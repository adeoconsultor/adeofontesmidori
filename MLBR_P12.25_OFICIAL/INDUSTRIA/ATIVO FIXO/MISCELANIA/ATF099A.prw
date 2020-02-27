#INCLUDE "rwmake.ch"
#include "FILEIO.CH"
#include "Protheus.CH"
/*
----------------------------------------------------------------
Funcao  : IMPATV
----------------------------------------------------------------
Objetivo: Importacao do CADASTRO DE ATIVOS
----------------------------------------------------------------
*/
User Function ATF099A()
//--------------------------------------
Local cTitulo:= "Importação de Tabelas "
Local nOpca
Local nSeqReg
Local cCadastro

Local aSays := {}
Local aButtons := {}
Local nOpca := 0
Local cBarra := If(isSrvUnix(),"/","\")
Local cDestino := ""
Private cTitulo := OemToAnsi("Importacao do CADASTRO DE ATIVOS")
Private cArq :=""

aAdd(aSays,OemToAnsi('Rotina tem como objetivo realizar Importacao do CADASTRO DE ATIVOS, '))
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
		
		//Deletar SN3
		cComando := "TRUNCATE TABLE " + RETSQLNAME("SN3")
		TcSqlExec(cComando)
		TcRefresh(RETSQLNAME("SN3"))*/
		
		Processa({|lEnd|ImpAtivo()},"Processando Registros","Aguarde...")
		
	Else
		Help(" ",1,"IMPATV","Arquivo csv não encontrado",,1,0) //"Não foi possível copiar o arquivo para o servidor., copie o arquivo diretamente no servidor."
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
Static Function ImpAtivo()
//-----------------------------
//Local cPath    := GetSrvProfString("StartPath","")
//Local cArqTrb :=
//Local cInd    := ""
Local nRegs   := 0
Local nGrav   := 0
Local cIndTrb := "Z1_CBASE"
Local cInd    := ""
//lOCAL DTFIM   := ctod(" /  /  ")
LOCAL nProcessos:=6
LOCAL nOpc := 3 // Inclusao
LOCAL aCab:={},aItens:={},aLinha:={}
LOCAL n1,nx:=0
LOCAL cTextAviso:="Cadastros Processados! Rotina encerrada com sucesso!"
//
Local nLastKey  := 0
Local _cBuffer  := ""
Local _nPos     := 0
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
Private cDuplSN1 := "REGISTROS nao EXISTE NA BASE DE DADOS"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"ATIVO IMOBILIZADO"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"FILIAL;COD.BEM   ;ITEM"+CHR(13)+CHR(10)

Private nTamCBASE := TamSx3("N1_CBASE")[1]
Private nTamITEM  := TamSx3("N1_ITEM")[1]

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
	
	If (SubStr(_cTemp,1,23) == ('FILIAL;COD DO BEM;ITEM;')) .And. _lLeCab == .F.
		_nCols := 0
		//Le cabecalho do arq.
		While Len(_cTemp) > 0 .And. _nCols <= 6
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
	IncProc("Atualizando Cadastro de Ativos...") //Incrementa a régua
	
	//If !Empty(aTabela[n1][34]) ///Verifica conta-contabil
	
	DbSelectArea("SN3")
	SN3->(DbsetOrder(1))//N1_FILIAL+N1_CBASE+N1_ITEM
	SN3->(DbGotop())
	If SN3->(DbSeek( StrZero(Val(Alltrim(aTabela[n1][1])),2) + PadR(Upper(Alltrim(aTabela[n1][2])),nTamCBASE,"")+ PadR(Upper(Alltrim(aTabela[n1][3])),nTamITEM,"")))
		
		DbSelectArea("SN3")
		SN3->(RecLock("SN3",.F.))
		//SN3->N3_FILIAL	:= StrZero(Val(Alltrim(aTabela[n1][1])),2)
		//SN3->N3_CBASE	:= Alltrim(aTabela[n1][4])
		//SN3->N3_ITEM 	:= StrZero(Val(Alltrim(aTabela[n1][5])),4)
		//SN3->N3_TIPO 	:= StrZero(Val(Alltrim(aTabela[n1][30])),2)
		//SN3->N3_HISTOR 	:= SUBSTR(Alltrim(aTabela[n1][7]),1,40)//31
		//SN3->N3_TPSALDO := Alltrim(aTabela[n1][32])
		//SN3->N3_TPDEPR	:= Alltrim(aTabela[n1][33])
		//SN3->N3_CCONTAB := Alltrim(aTabela[n1][34])
		SN3->N3_CUSTBEM := Alltrim(aTabela[n1][4]) //N3_CCUSTO
		SN3->N3_CDEPREC := Alltrim(aTabela[n1][5])//PARA CONTA
		SN3->N3_CCUSTO	:= Alltrim(aTabela[n1][4])
		//SN3->N3_CCDEPR	:= Alltrim(aTabela[n1][38])//
		//SN3->N3_DINDEPR := CtoD(Alltrim(aTabela[n1][39]))
		//SN3->N3_VORIG1	:= Val(StrTran(StrTran(Alltrim(aTabela[n1][40]),".",""),",","."))
		//SN3->N3_TXDEPR1	:= Val(StrTran(StrTran(Alltrim(aTabela[n1][41]),".",""),",","."))
		//SN3->N3_VORIG3  := (Val(StrTran(StrTran(Alltrim(aTabela[n1][40]),".",""),",",".")) / 0.8287) //(N3_VORIG1 / 0,8287)
		//SN3->N3_AQUISIC	:= CtoD(aTabela[n1][6])
		SN3->N3_CCDESP	:= Alltrim(aTabela[n1][4])
		SN3->N3_CCCDEP	:= Alltrim(aTabela[n1][4])
		SN3->N3_CCCDES	:= Alltrim(aTabela[n1][4])
		SN3->N3_CCCORR	:= Alltrim(aTabela[n1][4])
		//SN3->N3_NOVO 	:= "S"
		//SN3->N3_BXICMS	:= 0
		//SN3->N3_AMPLIA1	:= 0
		//SN3->N3_VLACEL1	:= 0
		//SN3->N3_RATEIO	:= "2"
		//SN3->N3_CRIDEPR	:= "00"
		//SN3->N3_VRCMES1	:= 0
		//SN3->N3_VRDMES1	:= 0
		//SN3->N3_VRCACM1 := 0
		//SN3->N3_VRDACM1	:= 0
		//SN3->N3_VRCDM1	:= 0
		//SN3->N3_VRCDB1	:= 0
		//SN3->N3_VRCDA1	:= 0
		//SN3->N3_BAIXA	:= ""
		
		SN3->(MSUNLOCK())
	Else
		//Aviso('Atencao',"Ativo Não Encontrado!"+Chr(13)+StrZero(Val(Alltrim(aTabela[n1][1])),2)+Space(2)+Alltrim(aTabela[n1][2]),{'Ok'})
		//Grava Log de duplicados.
			cDuplSN1 += StrZero(Val(Alltrim(aTabela[n1][1])),2)+";"+Upper(Alltrim(aTabela[n1][2]))+";0001;"+CHR(13)+CHR(10)
			lLog := .T.
	EndIf
	//Else
	//Aviso('Atencao',"Ativo sem Conta Contabil."+Chr(13)+Alltrim(aTabela[n1][4])+StrZero(Val(Alltrim(aTabela[n1][5])),4),{'Ok'})
	//AOliveira 29/03/2011.
	//SN1->"ATIVO IMOBILIZADO"
	//FILIAL;COD.BEM   ;ITEM;DT.AQUICICAO;DESCRICAO                               ;
	//XX    ;XXXXXXXXXX;XXXX;XX/XX/XXXX  ;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
	//lLog := .T.
	//cDuplSN1 += Alltrim(aTabela[n1][13])+";"+Upper(Alltrim(aTabela[n1][1]))+";0001;"+aTabela[n1][3]+";"+SUBSTR(Alltrim(aTabela[n1][2]),1,40)+";"+SUBSTR(TRB->Z1_DESCR,1,40)+CHR(13)+CHR(10)
	//EndIf
	
Next

//-------------------------------------
//AOliveira 29/03/2011.
//Exibe listagem de arquivos Duplicados
//-------------------------------------
FT_FUSE()
//
If lLog//!Empty(cDuplSN1)
	
	cArqTxt	:= "C:\relato\naoachados.txt"
	nHdl	:= fCreate(cArqTxt)
	
	If nHdl == -1
		Aviso('Atencao',"O arquivo " + cArqTxt + " nao pode ser criado!",{'Ok'})
		Return Nil
	Endif
	
	fWrite(nHdl,cDuplSN1)
	Aviso('Atencao',"Listagem dos Registros Nao Encontrados."+Chr(13)+cArqTxt,{'Ok'})
	WinExec("Notepad.exe " + cArqTxt)
	fClose(nHdl)
	
EndIf

Aviso('Atencao',cTextAviso,{'Ok'})


Return()
