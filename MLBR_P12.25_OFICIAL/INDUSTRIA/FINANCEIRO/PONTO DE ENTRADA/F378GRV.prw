#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.ch"
/*---------------------------------------------------------
Funcao: F378GRV()    |Autor: AOliveira    |Data:22-03-2012
-----------------------------------------------------------
Desc.: PE tem como objetivo realizar a gravação da AP
       no momento de geração dos Titulos de aglutinação de
       impostos (PCC).
---------------------------------------------------------*/
User Function F378GRV()

Local aDadosTit := {}
Local aDadosAP  := {}
Local _aArea    := GetArea()
Local cNumAp    := SE2->E2_X_NUMAP
Local cRet      := .T.

Local nOpca     := 0
Local cBco      := ""
Local cAge      := ""
Local cConta    := ""
Local oDlg
Local cFornece  := ""
LOCAL aTpCta 	:= {"1=Corrente","2=Poupanca",""}
LOCAL aFrmPag 	:= {"1=DOC/TED","2=Boleto/DDA","3=Cheque","4=Caixa","5=Cnab Folha","6=Cartão Corporativo"}

If FunName()$"EICDI500|EICDI501|EICDI502"	//Não exibe tela de AP para usuários do EIC
	Return(cRet)
EndIf
//
Private cCodApr  := CriaVar("ZW_USRAP") 
Private cNomApr  := CriaVar("ZW_USRAPN") 
//
Private cCodOri  := CriaVar("E2_X_ORIG") ,cVarOri
Private cTpCta   := CriaVar("E2_X_TPCTA"),cvar
Private cFrmPag  := CriaVar("E2_X_FPAGT"),cVarPag
Private cNomFav  := CriaVar("E2_X_NOMFV")
Private cInscr   := CriaVar("E2_X_CPFFV")
Private cHistor  := CriaVar("E2_HIST")
Private _cFiltro := ""

cFornece := Substr( SA2->A2_COD+" "+ SA2->A2_LOJA +" "+ SA2->A2_NOME,1,50)
cBco     := SA2->A2_BANCO
cAge     := SA2->A2_AGENCIA
cConta   := SA2->A2_NUMCON
cTpCta   := SA2->A2_X_TPCON		//If(Empty(SA2->A2_X_TPCON),"",SA2->A2_X_TPCON)
cFrmPag  := cVarPag := aFrmPag

/*------------------------------------
	Numero da AP
------------------------------------*/    
/*
cNumAp := GetSxeNum("SE2","E2_X_NUMAP")
ConfirmSx8()  
*/

cNumAp := u_XGETNAP() /*AOliveira 18-07-2019*/

/*---- Monta a Interface com o Usuário ---*/
While .T.
	DEFINE MSDIALOG oDlg FROM	15,6 TO 420,597 TITLE OemToAnsi("Autorização de Pagamento") PIXEL
	@  0,  1 TO  45, 294 LABEL OemToAnsi("Fornecedor") OF oDlg PIXEL
	@ 49,  1 TO  91, 294 LABEL OemToAnsi("Pagamento através de Crédito em Conta") OF oDlg PIXEL  //75
	@ 96,  1 TO 135, 294 LABEL OemToAnsi("Favorecido") OF oDlg PIXEL 
	@ 142,  1 TO 140, 294 LABEL OemToAnsi("Aprovador") OF oDlg PIXEL
	
	@ 11, 13 SAY	OemToAnsi("Nome")	SIZE	21,  7	 OF oDlg PIXEL
	@  9, 42 MSGET cFornece SIZE 149, 10	 OF oDlg PIXEL WHEN .F.
	
	@ 11,197 SAY	OemToAnsi("Numero AP")	SIZE	28,  7	 OF oDlg PIXEL
	@ 9, 230 MSGET cNumAp SIZE	54, 10	 OF oDlg PIXEL WHEN .F.
	
	@ 29, 13 SAY	OemToAnsi("Origem")	SIZE	26,  7	 OF oDlg PIXEL
	@ 26, 42 MSGET cCodOri        		SIZE 18, 10 OF oDlg PIXEL Picture "@!"  Valid !Empty(cCodOri) .And. ExistCpo("SX5", + "80" + cCodOri) F3 "80"
	
	/*--- Pagamento atraves de conta bancaria ---*/
	@ 60, 13 SAY	OemToAnsi("Forma de Pagamento: ")	SIZE 56, 7 OF oDlg PIXEL
	@ 57, 72 MSCOMBOBOX oCbx VAR cFrmPag ITEMS aFrmPag SIZE 46, 7 OF oDlg PIXEL //Valid !Empty(cTpCta)
	
	@ 60,220 SAY	OemToAnsi("Banco")	SIZE 26, 7 OF oDlg PIXEL
	@ 57,240 MSGET cBco SIZE 25,10 OF oDlg PIXEL //Valid !Empty(cBco)
	
	@ 75, 13 SAY	OemToAnsi("Agencia") SIZE 26, 7 OF oDlg PIXEL
	@ 72, 42 MSGET cAge SIZE 35,10 OF oDlg PIXEL //Valid !Empty(cAge)
	
	@ 75, 95 SAY	OemToAnsi("Numero Conta")	SIZE 40, 7 OF oDlg PIXEL
	@ 72,135 MSGET  cConta SIZE 50,10 OF oDlg PIXEL //Valid !Empty(cConta)
	
	@ 75,200 SAY	OemToAnsi("Tipo de Conta")	SIZE 40, 7 OF oDlg PIXEL
	@ 72,240 MSCOMBOBOX oCbx VAR cTpCta ITEMS aTpCta SIZE 46, 50 OF oDlg PIXEL
	/*	------------------
	FAVORECIDO
	------------------*/
	@ 105,13 SAY   OemToAnsi("Nome")	SIZE 26, 7 OF oDlg PIXEL
	@ 102,42 MSGET cNomFav SIZE 149, 10 OF oDlg PIXEL Picture "@!"
	
	@ 105,197 SAY	OemToAnsi("CNPJ/CPF") SIZE 26, 7 OF oDlg PIXEL
	@ 102, 230 MSGET cInscr SIZE 54,10 OF oDlg PIXEL Valid CGC(cInscr)
	
	@ 120, 13 SAY	OemToAnsi("Histórico")	SIZE 26, 7 OF oDlg PIXEL
	@ 117, 42 MSGET cHistor SIZE 149,10 OF oDlg PIXEL Picture "@!"

	/*	------------------
	APROVADOR
	------------------*/
	@ 152,13 SAY   OemToAnsi("Aprovador")	SIZE 26, 7 OF oDlg PIXEL
	//@ 150,042 MSGET cCodApr SIZE 054, 10 OF oDlg PIXEL Picture "@!" VALID !Empty(cCodApr) .And. ExistCpo("SX5", + "Z4" + cCodApr) F3 "Z4"
	@ 150,042 MSGET cCodApr SIZE 054, 10 OF oDlg PIXEL Picture "@!" VALID  VLDAPRV(cCodApr) F3 "Z4"
	
	DEFINE SBUTTON FROM 185, 260 TYPE 1	ACTION (nOpca=0,oDlg:End())	ENABLE OF oDlg
	oCbx:Select(Val(cTpCta))     //Posiciona no item selecionado
	oDlg:Refresh()
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	//Obrigar ao usuário informar o aprovador...
	if empty(cCodApr)
		ApMsgAlert('Favor preencher o código do Aprovador')
		Loop
	endif
	if !(VLDAPRV(cCodApr))
		Loop			
	endif

	If cFrmPag == '1'
		If (cBco+cAge+cConta+cTpCta) != SA2->(A2_BANCO+A2_AGENCIA+A2_NUMCON+A2_X_TPCON)
			If !ApMsgYesNo("Dados da Conta Bancária diferente do cadastro do Fornecedor. Confirma ?","Não","Sim")
				cBco     := SA2->A2_BANCO
				cAge     := SA2->A2_AGENCIA
				cConta   := SA2->A2_NUMCON
				cTpCta   := SA2->A2_X_TPCON
				Loop
			EndIf
			If Empty(cBco) .Or. Empty(cAge) .Or. Empty(cConta) .Or. Empty(cTpCta)
				ApMsgAlert("Para esse tipo de pagamento informe os dados bancários","INFO")
				Loop
			EndIf
		Else
			If !Empty(cBco) .and. !Empty(cAge) .and. !Empty(cConta) .and. !Empty(cTpCta)
				If !ApMsgYesNo("Confirma os dados da Conta Bancária ?","Sim","Não")
					Loop
				EndIf
			Else
				ApMsgAlert("Dados bancários inválidos! Verifique")
				Loop
			EndIf
		EndIf
	Else
		cBco   := ""
		cAge   := ""
		cConta := ""
		cTpCta := ""
		
		If !ApMsgYesNo("Confirma a Forma de Pagamento ?")
			Loop
		EndIf
	EndIf
	
	SE2->E2_X_NUMAP := cNumAp
	SE2->E2_X_ORIG  := cCodOri
	SE2->E2_X_FPAGT := cFrmPag
	SE2->E2_X_FLAG  := "1"			//	IMPRESSO
	
	If cFrmPag == '1'           	// 	DOC/TED
		SE2->E2_X_BCOFV := cBco
		SE2->E2_X_AGEFV := cAge
		SE2->E2_X_CTAFV := cConta
		SE2->E2_X_TPCTA := cTPCta
	EndIf
	SE2->E2_X_NOMFV := cNomFav
	SE2->E2_X_CPFFV := cInscr
	SE2->E2_HIST    := cHistor
	SE2->E2_X_USUAR := Alltrim(USRFULLNAME(RETCODUSR()))
	SE2->E2_X_DEPTO := Tabela("80",cCodOri,.f.)
	SE2->E2_X_CODUS := RetCodUsr()
	
	Exit
EndDo                 

aAdd(aDadosAP,{Upper("Referente Titulos"),Nil})
aDadosAP:= xTiAgl(SE2->E2_NUM,SE2->E2_NATUREZ,aDadosAP)
//aAdd(aDadosAP,{Upper("Ref.Titulo Nr. "+SE2->E2_PREFIXO+" - "+SE2->E2_NUM+" - "+SE2->E2_PARCELA+" - "+SE2->E2_TIPO),Nil})
//aAdd(aDadosAP,{Upper("Fornecedor: "+SE2->E2_FORNECE+"-"+SE2->E2_LOJA+" - "+Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_NOME")),Nil})

aAdd(aDadosTit, {	SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,cNumAp,SE2->E2_X_BCOFV,;
SE2->E2_X_AGEFV,SE2->E2_X_CTAFV,SE2->E2_X_NOMFV,SE2->E2_X_CPFFV,SE2->E2_X_ORIG,SE2->E2_X_TPCTA,SE2->E2_X_FPAGT,SE2->E2_HIST, SE2->E2_HIST1})

//AOliveira
//
If SuperGetMV("EP_NEWAP",.F., .F.) // GetMv()
	//Novo processo ativo
	//u_GRVSZW(aDadosTit,cNumAp)    
	//u_GRVSZW(aDadosTit,cNumAp,RetCodUsr()) //17-10-2019 AOliveira Inclusão para gravar COD USR que incluiu a AP
	u_GRVSZW(aDadosTit,cNumAp,RetCodUsr(),cCodApr) //22-10-2019 AOliveira Inclusão para gravar COD APR da AP		
	    
	    
	//Enviar e-mail de aviso.  
	//VSS_ENVMAIL(_cAP, _cForn, _cEmlAP)
	_cEmail :=  iif( Empty(UsrRetMail(cCodApr)), "" , UsrRetMail(cCodApr) )
	VSS_ENVMAIL(cNumAp, cFornece, _cEmail, SE2->E2_PREFIXO, SE2->E2_NUM )	
	
Else
	//Processo Antigo
	U_RFINR01(aDadosTit,aDadosAP,"",_cFiltro)    //(aTit,aDesc,xRotina)
EndIf

RestArea(_aArea)

Return()       	                                              
                            
/*---------------------------------------------------------
---------------------------------------------------------*/
Static Function xTiAgl(_cNum,_cNaturez,aDadosAP)
Local cQuery := " "

if Select('TMP1') > 0
	dbSelectArea('TMP1')
	TMP1->(dbCloseArea())
endif

cQuery := " SELECT * FROM "  
cQuery += RetSqlName("SE5")+" SE5 "
cQuery += " WHERE E5_AGLIMP = '"+_cNum+"' "
cQuery += " AND E5_NATUREZ = '"+_cNaturez+"' "
cQuery += " AND E5_SITUACA = ' ' "
cQuery += " AND D_E_L_E_T_ = ' ' "

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'TMP1',.T.,.F.)
DbSelectArea("TMP1") 
TMP1->(DbGoTop())
While !TMP1->(Eof())        
	aAdd(aDadosAP,{Upper("   "+TMP1->E5_PREFIXO+" - "+TMP1->E5_NUMERO+" - "+TMP1->E5_PARCELA+" - "+TMP1->E5_TIPO),TMP1->E5_VALOR})	
	TMP1->(DbSkip())
EndDo
TMP1->(DbCloseArea())

Return(aDadosAP)


/*
* VSS_ENVMAIL
*
*@versao: 1.0
*@autor : AOliveira
*@Data  : 2018-02-06
*@Descr.: Inicia WF de envio de e-mail
*/
Static Function VSS_ENVMAIL(_cAP, _cForn, _cEmlAP,_cPrefixo, _cNumTit)

Local oHtml
Local oProcess

Default _cAP      := "" 
Default _cForn    := "" 
Default _cEmlAP   := ""
Default _cPrefixo := "" 


SETMV("MV_WFMLBOX","WORKFLOW")
cProcess := OemToAnsi("001001")
cStatus  := OemToAnsi("001001")
//_cProc  := OemToAnsi(cProc)

oProcess:= TWFProcess():New( '001001', _cAP )
oProcess:NewTask( cStatus, "\WORKFLOW\HTM\VldPro.htm" )
oHtml    := oProcess:oHTML
oHtml:ValByName("Data"	    ,DTOC(DDATABASE))
oHtml:ValByName("AP"   		,_cAP)

aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
aAdd( oHtml:ValByName( "it.desc" ), "AP: "+ Alltrim(_cAP) +"  -- Filial: "+Alltrim(_cPrefixo))
aAdd( oHtml:ValByName( "it.desc" ), "Fornecedor: "+ Alltrim(_cForn) +" ")        
aAdd( oHtml:ValByName( "it.desc" ), "Num.Titulo: "+ Alltrim(_cNumTit) +" ")
aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
aAdd( oHtml:ValByName( "it.desc" ), "| AGUARDANDO APROVAÇÃO                                                                 |")
aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")

oProcess:cSubject := "AP: "+_cAP+"   ( AGUARDANDO APROVAÇÃO ) "

oProcess:cTo      := _cEmlAP

oProcess:Start()
oProcess:Finish()
Return()

/*
* VLDAPRV
*
*@versao: 1.0
*@autor : AOliveira
*@Data  : 12-02-2020
*@Descr.: VALIDA APROVADOR
*/
Static Function VLDAPRV(_cVal)
Local lRet := .T.
Local _cMsg := ""
Local cA2CDUSR := ""

DEFAULT _cVAL := ""

if ( Empty(_cVAL)  )
	_cMsg := "( Codigo do Aprovador, não está preenchido! )"
	lRet := .F.
else
	if !( ExistCpo("SX5", "Z4" + _cVAL) )
		_cMsg := "( Codigo do Aprovador informado, não é valido! )"
		lRet := .F.		
	else
		cA2CDUSR := Alltrim(Posicione("SA2",1, xFilial("SA2")+ SE2->E2_FORNECE+SE2->E2_LOJA,"A2_XCDUSR") )
		if ( Alltrim(cA2CDUSR) == Alltrim(_cVAL) )
			cMSG := "( Aprovador não pode ser o Fornecedor! )"	
			lRet := .f.
		endif	
	endif	
endif

if !(lRet)
	Aviso( "MNT AP","Selecione um aprovador, valido!"+CRLF+_cMSG ,{"Ok"},1)	
endif

Return(lRet)