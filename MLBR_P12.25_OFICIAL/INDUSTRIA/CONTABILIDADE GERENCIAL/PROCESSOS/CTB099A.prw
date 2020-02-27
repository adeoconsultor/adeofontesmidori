#INCLUDE "rwmake.ch"
#include "FILEIO.CH"
#include "Protheus.CH"
/*
----------------------------------------------------------------
Funcao  : CTB099A
----------------------------------------------------------------
Objetivo: Importacao do CADASTRO DE CONTAS CONTABIL/REFERENCIAS
----------------------------------------------------------------
*/
User Function CTB099A()
//--------------------------------------
Local cTitulo:= "Importação de Contas Contabeis/Referenciais"
Local nOpca
Local nSeqReg
Local cCadastro

Local aSays := {}
Local aButtons := {}
Local nOpca := 0
Local cBarra := If(isSrvUnix(),"/","\")
Local cDestino := ""
Private cTitulo := OemToAnsi("Importação de Contas Contabeis/Referenciais")
Private cArq :=""

aAdd(aSays,OemToAnsi('Rotina tem como objetivo realizar Importacao de Contas Contabeis/Referenciais, '))
aAdd(aSays,OemToAnsi('com base em arquivo *.CSV informado pelo usuário.                   '))
//aAdd(aSays,OemToAnsi('Rotina também realizará a "Exclusão" de todos os registros atuais,  '))
//aAdd(aSays,OemToAnsi('existes na BASE DE DADOS. Antes da importação dos novos registros.  '))
aAdd(aSays,OemToAnsi('                                                                    '))
aAdd(aSays,OemToAnsi('                                                                    '))
aAdd(aSays,OemToAnsi('                                                                    '))
aAdd(aButtons, { 5, .T., {|o| Parametro() } } )           								//Parâmetros para execussão da Rotina.
aAdd(aButtons, { 1, .T., {|o| nOpca := 1, IF(gpconfOK(), FechaBatch(), nOpca:=0) }} ) 	//Se selecionar botao Ok fecha tela de entrada.
aAdd(aButtons, { 2, .T., {|o| FechaBatch() }} ) 										//Se selecionado botao Cancelar, fecha tela de entrada e retorna ao sistema.

FormBatch(cTitulo,aSays,aButtons) //Exibe Tela de entrada

IF ( nOpca == 1 )
	
	//If MsgYesNo("Ao executar esta Rotina, todos os dados de Ativo (Atual), serão deletados! Deseja Continuar?","Atenção")
	
	cDestino := GetSrvProfString("StartPath","")//+If(Right(GetSrvProfString("StartPath",""),1) == cBarra,"",cBarra)+"Ativo"
	If File(MV_PAR01) //CpyT2S(Alltrim(MV_PAR01),cDestino,.F.)
		
		/*//Deletar SN1
		cComando := "TRUNCATE TABLE " + RETSQLNAME("SN1")
		TcSqlExec(cComando)
		TcRefresh(RETSQLNAME("SN1"))
		
		//Deletar CVD
		cComando := "TRUNCATE TABLE " + RETSQLNAME("CVD")
		TcSqlExec(cComando)
		TcRefresh(RETSQLNAME("CVD"))*/
		
		Processa({|lEnd|ImpCont()},"Processando Registros","Aguarde...")
		
	Else
		Help(" ",1,"CTB099A","Arquivo csv não encontrado",,1,0) //"Não foi possível copiar o arquivo para o servidor., copie o arquivo diretamente no servidor."
	EndIf
	
	//EndIF
	
EndIF


Return

/*---------------------------------------------------------
Funcao: Parametro()  |Autor: AOliveira     |Data:24-08-2011
-----------------------------------------------------------
Desc.:
-----------------------------------------------------------
Retorno:
---------------------------------------------------------*/
Static Function Parametro()
Local aRet := {}
Local aParamBox := {}

AADD(aParamBox,{6,"Localizar",padr("",150),"",,"",90 ,.T.,".CSV |*.CSV","",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})
If ParamBox(aParamBox,"Selecionar Arquivo",@aRet)
	
Endif

Return(aRet)

/**/
Static Function ImpCont()
//-----------------------------
//Local cPath    := GetSrvProfString("StartPath","")
//Local cArqTrb :=
//Local cInd    := ""
Local nRegs   := 0
Local nGrav   := 0
Local cInd    := ""
LOCAL nProcessos:=6
LOCAL nOpc := 3 // Inclusao
LOCAL aCab:={},aItens:={},aLinha:={}
LOCAL nx	:=0
LOCAL cTextAviso:="Cadastros Processados! Rotina encerrada com sucesso!"
//
Local nLastKey  := 0
Local _cBuffer  := ""
Local _nPos,n1     := 0
Local _cTemp   	:= ""
Local _cArqAdm 	:= MV_PAR01
Private aCampos	:= {}
Private aTabela	:= {}
Private aReg    := {}
PRIVATE lMsErroAuto := .F.
Private nL01 := .T.
Private _nCols	:= 0
Private _nLin   := 0

////AOliveira 29/03/2011.
Private lSN1Ok	:= .F.
Private lLog	:= .F.
Private cDuplCC := "CONTA NAO EXISTE NA BASE DE DADOS"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"CONTA"+CHR(13)+CHR(10)+CHR(13)+CHR(10)

Private nTamCONTA := TamSx3("CVD_CONTA")[1]
//Private nTamITEM  := TamSx3("N1_ITEM")[1]

//
If !File(_cArqAdm)
	MsgAlert("Arquivo csv não encontrado","Importacao")
	Return
Endif

FT_FUSE(_cArqAdm)
FT_FGOTOP()
_cTLinha := FT_FLASTREC( )
_lLeCab := .F.

ProcRegua(_cTLinha) // Definindo Regua

While !FT_FEOF()
	_nLin ++
	IncProc("Lendo arquivo *.CSV...") //Incrementa a régua
	_cBuffer := FT_FREADLN() //Le a Linha do arquivo
	_cTemp   := _cBuffer
	_nPos    := At(";",_cTemp) //Definindo a colunna
	
	If (SubStr(_cTemp,1,20) == ('Cod Conta;Desc Moeda')) .And. _lLeCab == .F.
		_nCols := 0            //Cod Conta;Desc Moeda
		//Le cabecalho do arq.
		While Len(_cTemp) > 0 .And. _nCols <= 9
			_nCols ++
			_nPos    := At(";",_cTemp) //Definindo a colunna                       	
			AAdd ( aCampos, Alltrim(SubsTr(_cTemp,1,_nPos-1)),"1" )
			_cTemp   	:= SubsTr(_cTemp,_nPos+1)
		EndDo
		_lLeCab := .T.
	ElseIf _nLin > 1 .Or. _lLeCab == .T.
		//Le registros (linhas) do arquivo
		aReg := {}
		For n1:=1 To Len(aCampos)
			_nPos    := At(";",_cTemp) //Definindo a colunna
			AAdd ( aReg, Alltrim(SubsTr(_cTemp,1,_nPos-1)) )
			_cTemp   	:= SubsTr(_cTemp,_nPos+1)
		Next
		AAdd (aTabela,aReg)
	EndIf
	FT_FSKIP() //Salta p/ proxima Linha
EndDo

ProcRegua(Len(aTabela)) // Definindo Regua

For n1:= 1 To Len(aTabela)
	
	//Produto;Descricao;Venda
	IncProc("Atualizando Cadastro de Contas Contabeis/Referenciais...") //Incrementa a régua
	
	//If !Empty(aTabela[n1][34]) ///Verifica conta-contabil
	
	DbSelectArea("CVD")
	CVD->(DbsetOrder(4))//CVD_FILIAL+CVD_CONTA
	CVD->(DbGotop())
	If !CVD->(DbSeek( xFilial("CVD")+'10'+'101'+PadR(Upper(Alltrim(aTabela[n1][1])),nTamCONTA,"")))
		
		DbSelectArea("CVD")
		CVD->(RecLock("CVD",.T.))
		CVD->CVD_ENTREF:= '10'
		CVD->CVD_CODPLA := '101'
		CVD->CVD_CONTA	:= Alltrim(aTabela[n1][1]) 
		CVD->CVD_CTAREF := Alltrim(aTabela[n1][4])
		CVD->CVD_CLASSE := Alltrim(aTabela[n1][6])
		CVD->CVD_TPUTIL := Alltrim(aTabela[n1][9])
		CVD->CVD_NATCTA := StrZero(Val(Alltrim(aTabela[n1][8])),2)
		CVD->CVD_CTASUP := Alltrim(aTabela[n1][7])
		
	 	CVD->(MSUNLOCK())
	/*Else
		CVD->(DbSeek( xFilial("CVD")+ PadR(Upper(Alltrim(aTabela[n1][1])),nTamCONTA,"")))
		
		DbSelectArea("CVD")
		CVD->(RecLock("CVD",.F.))
		CVD->CVD_CTAREF := Alltrim(aTabela[n1][4])
		CVD->CVD_CLASSE := Alltrim(aTabela[n1][6])
		CVD->CVD_TPUTIL := Alltrim(aTabela[n1][9])
		CVD->CVD_NATCTA := StrZero(Val(Alltrim(aTabela[n1][8])),2)
		CVD->CVD_CTASUP := Alltrim(aTabela[n1][7])
		
		CVD->(MSUNLOCK())
	
	/*		//Aviso('Atencao',"Ativo Não Encontrado!"+Chr(13)+StrZero(Val(Alltrim(aTabela[n1][1])),2)+Space(2)+Alltrim(aTabela[n1][2]),{'Ok'})
		//Grava Log de duplicados.
			cDuplCC += Alltrim(aTabela[n1][1])+";"+CHR(13)+CHR(10)
			lLog := .T.
			*/
	EndIf
	//Else
	//Aviso('Atencao',"Ativo sem Conta Contabil."+Chr(13)+Alltrim(aTabela[n1][4])+StrZero(Val(Alltrim(aTabela[n1][5])),4),{'Ok'})
	//AOliveira 29/03/2011.
	//SN1->"ATIVO IMOBILIZADO"
	//FILIAL;COD.BEM   ;ITEM;DT.AQUICICAO;DESCRICAO                               ;
	//XX    ;XXXXXXXXXX;XXXX;XX/XX/XXXX  ;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
	//lLog := .T.
	//cDuplCC += Alltrim(aTabela[n1][13])+";"+Upper(Alltrim(aTabela[n1][1]))+";0001;"+aTabela[n1][3]+";"+SUBSTR(Alltrim(aTabela[n1][2]),1,40)+";"+SUBSTR(TRB->Z1_DESCR,1,40)+CHR(13)+CHR(10)
	//EndIf
	
Next

//-------------------------------------
//AOliveira 29/03/2011.
//Exibe listagem de arquivos Duplicados
//-------------------------------------
FT_FUSE()
//
If lLog//!Empty(cDuplCC)
	
	cArqTxt	:= "C:\relato\naoachados.txt"
	nHdl	:= fCreate(cArqTxt)
	
	If nHdl == -1
		Aviso('Atencao',"O arquivo " + cArqTxt + " nao pode ser criado!",{'Ok'})
		Return Nil
	Endif
	
	fWrite(nHdl,cDuplCC)
	Aviso('Atencao',"Listagem dos Registros Nao Encontrados."+Chr(13)+cArqTxt,{'Ok'})
	WinExec("Notepad.exe " + cArqTxt)
	fClose(nHdl)
	
EndIf

Aviso('Atencao',cTextAviso,{'Ok'})


Return()
