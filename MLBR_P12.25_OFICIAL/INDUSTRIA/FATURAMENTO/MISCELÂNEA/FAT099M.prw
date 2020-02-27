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
User Function FAT099M()
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
Private cTitulo := OemToAnsi("Importacao de Produtos sem FCI")
Private cArq :=""

aAdd(aSays,OemToAnsi('Rotina tem como objetivo realizar Importacao de Produtos sem FCI, '))
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
		
		//Deletar CFD
		cComando := "TRUNCATE TABLE " + RETSQLNAME("CFD")
		TcSqlExec(cComando)
		TcRefresh(RETSQLNAME("CFD"))*/
		
		Processa({|lEnd|ImpAtivo()},"Processando Registros","Aguarde...")
		
	Else
		Help(" ",1,"FAT099M","Arquivo csv não encontrado",,1,0) //"Não foi possível copiar o arquivo para o servidor., copie o arquivo diretamente no servidor."
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
LOCAL nx:=0
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
Private cDuplSN1 := "REGISTROS nao EXISTE NA BASE DE DADOS"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"ATIVO IMOBILIZADO"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"FILIAL;COD.BEM   ;ITEM"+CHR(13)+CHR(10)

Private nTamCBASE := TamSx3("CFD_COD")[1]
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
	
	If (SubStr(_cTemp,1,7) == ('Filial;')) .And. _lLeCab == .F.
		_nCols := 0
		//Le cabecalho do arq.
		While Len(_cTemp) > 0 .And. _nCols <= 4
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
	IncProc("Atualizando Cadastro de Produtos FCI...") //Incrementa a régua
	
	//If !Empty(aTabela[n1][34]) ///Verifica conta-contabil
	
	DbSelectArea("CFD")
	CFD->(DbsetOrder(2))//N1_FILIAL+N1_CBASE+N1_ITEM
	CFD->(DbGotop())
	If !CFD->(MsSeek(StrZero(Val(Alltrim(aTabela[n1][2])),2) + StrZero(Val(Alltrim(aTabela[n1][1])),6) + Space(9)+'072019'))
		
		DbSelectArea("CFD")
		CFD->(RecLock("CFD",.T.))
		CFD->CFD_FILIAL	:= StrZero(Val(Alltrim(aTabela[n1][2])),2)
		CFD->CFD_PERCAL	:= '072019'
		CFD->CFD_PERVEN	:= '052019'
		CFD->CFD_COD	:= StrZero(Val(Alltrim(aTabela[n1][1])),6)
		CFD->CFD_VSAIIE	:= Val(Alltrim(aTabela[n1][4]))
		CFD->CFD_VPARIM	:= 1.6
		CFD->CFD_ORIGEM	:= '5'
		
		CFD->(MSUNLOCK())
	Else
		//Aviso('Atencao',"Ativo Não Encontrado!"+Chr(13)+StrZero(Val(Alltrim(aTabela[n1][1])),2)+Space(2)+Alltrim(aTabela[n1][2]),{'Ok'})
		//Grava Log de duplicados.
			cDuplSN1 += StrZero(Val(Alltrim(aTabela[n1][1])),2)+";"+Upper(Alltrim(aTabela[n1][2]))+CHR(13)+CHR(10)
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
