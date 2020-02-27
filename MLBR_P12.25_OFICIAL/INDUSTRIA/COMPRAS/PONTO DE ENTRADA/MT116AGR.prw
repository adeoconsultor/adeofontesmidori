#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.ch"
/*
----------------------------------------------------------------------------------------
Autor : Gildesio Campos
----------------------------------------------------------------------------------------
Objetivo: PE apos a gravacao do titulo ref. NF Conhec Frete no SE2
-	Gera AP para o titulo
-	Monta array para Impressão da Autorizacao de Pagmento
----------------------------------------------------------------------------------------
aDadosTit:	1-Prefixo
			2-Numero do Titulo
			3-Parcela
			4-Tipo
			5-Fornecedor
			6-Loja
			7-Numero da AP
			8-Banco Fav
			9-Agencia Fav
			10-Conta Fav
			11-Nom Fav
			12-Cpf Fav
			13-Origem AP
			14-Tipo de Conta     	| 1=Conta Corrente 2= Conta Poupanca (A2_X_TPCON)
			15-Forma de Pagamento   | 1=DOC/TED 2=Boleto/DDA 3=Cheque
			16-Historico
---------------------------------------------------------------------------------------------------
Alterações efetuadas na rotina
---------------------------------------------------------------------------------------------------
Data		| No. Chamado	|Descrição
---------------------------------------------------------------------------------------------------
12.08.2010	| 000.697		| Exibir dados bancarios do fornecedor na tela da AP

---------------------------------------------------------------------------------------------------
*/
User Function MT116AGR()

Local lRet      := .T.
Local nOpca     := 0
Local oDlg
Local _aArea    := GetArea()

Local aOrigem   := {}
Local aDadosTit := {}
Local aDadosAP  := {}
Local cOrigem   := ""
Local cBco      := ""
Local cAge      := ""
Local cConta    := ""
Local cFornece  := ""
Local cNumAp    := ""   
LOCAL aTpCta 	:= {"1=Corrente","2=Poupanca",""}
LOCAL aFrmPag 	:= {"1=DOC/TED","2=Boleto/DDA","3=Cheque","4=Caixa","5=Cnab Folha","6=Cartão Corporativo"}

Private cCodApr  := CriaVar("ZW_USRAP") 
Private cNomApr  := CriaVar("ZW_USRAPN") 
Private cCodOri  := CriaVar("F1_X_ORIG") ,cVarOri
Private cTpCta   := CriaVar("F1_X_TPCTA"), cvar
Private cFrmPag  := CriaVar("F1_X_FPAGT"),cVarPag
Private cNomFav  := CriaVar("E2_X_NOMFV")
Private cInscr   := CriaVar("E2_X_CPFFV")
Private cHistor  := CriaVar("E2_HIST")
Private cHist1   := CriaVar("E2_HIST1")

lRet      := .T.
aOrigem   := {}
nOpca     := 0
oDlg      := oDlg
/**/
If !Inclui
	Return
EndIf                

If FunName() = "GFEA065"	// Verifica se doc. é uma NF Frete. Impede gerar AP em duplicidade quando Nota de Frete (HD No. 1037 30/06/10)
	Return
EndIf
	
/**/

cHist1 := "MT116AGR.PRW"

If  .t. //SF4->F4_DUPLIC == 'S'
	SA2->( dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) )
	cFornece := Substr( SE2->E2_FORNECE+" "+ SE2->E2_LOJA +" "+ SA2->A2_NOME,1,50)
	cBco     := SA2->A2_BANCO
	cAge     := SA2->A2_AGENCIA
	cConta   := SA2->A2_NUMCON
	cTpCta   := SA2->A2_X_TPCON		//If(Empty(SA2->A2_X_TPCON),"",SA2->A2_X_TPCON)
	cFrmPag  := cVarPag := aFrmPag
	cOrigem  := " "
	/*
	------------------------------------
	Numero da AP
	------------------------------------*/
	//cNumAp := GETSXENUM('SE2','E2_X_NUMAP','E2_X_NUMAP') /*AOliveira 25-05-2011*/    //GetSxeNum("SE2","E2_X_NUMAP")
	
	cNumAp := U_XGETNAP() /*AOliveira 18-07-2019*/ 
	
	ConfirmSx8()
	//	Alert('Nota fiscal -> '+ALLTRIM(SE2->E2_NUM)+"/"+ALLTRIM(SE2->E2_PREFIXO))
	
	cQSF8 := " Select F8_NFORIG, F8_SERORIG, F8_FORNECE, F8_LOJA from SF8010 where D_E_L_E_T_ = ' ' and F8_FILIAL = '"+xFilial("SF8")+"' "
	cQSF8 += " AND F8_NFDIFRE = '"+SE2->E2_NUM+"' AND F8_TRANSP = '"+SE2->E2_FORNECE+"' AND F8_LOJTRAN = '"+SE2->E2_LOJA+"' "
	cQSF8 += " Order by F8_FORNECE "
	
	if Select("TMPF8") > 0
		dbSelectArea("TMPF8")
		TMPF8->(dbCloseArea())
	endif
	dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQSF8), 'TMPF8', .T., .T. )
	
	cHistTmp := ""
	cHistFor := ""
	cOldFor := ""
	nCtHist  := 0
	dbSelectArea('TMPF8')
	TMPF8->(dbGotop())
	while !TMPF8->(eof())
		cHistTmp := cHistTMP+TMPF8->(F8_NFORIG+'-'+F8_SERORIG)+";"
		if cOldFor <> TMPF8->F8_FORNECE
			cHistFor := cHistFor+TMPF8->(F8_FORNECE+"-"+F8_LOJA)+";"
		endif
		nCtHist++
		cOldFor := TMPF8->F8_FORNECE
		TMPF8->(dbSkip())
	enddo
	cHistTmp := Substr(cHistTmp,1, Len(cHistTmp)-1)
	cHistFor := Substr(cHistFor,1, Len(cHistFor)-1)
	
	cHistor := "NF(s):"+cHistTmp+" FORN:"+cHistFor //"Frete NF "+ALLTRIM(SF1->F1_DOC)+"/"+ALLTRIM(SF1->F1_SERIE)+" Forn.: "+SF1->F1_FORNECE+"-"+SF1->F1_LOJA
	/*---- Monta a Interface com o Usuário ---*/
	While .T.
		DEFINE MSDIALOG oDlg FROM	15,6 TO 420,597 TITLE OemToAnsi("Autorização de Pagamento") PIXEL
		@ 000,  1 TO  45, 294 LABEL OemToAnsi("Fornecedor") OF oDlg PIXEL
		@ 049,  1 TO  91, 294 LABEL OemToAnsi("Pagamento através de Crédito em Conta") OF oDlg PIXEL  //75
		@ 096,  1 TO 135, 294 LABEL OemToAnsi("Favorecido") OF oDlg PIXEL
		@ 142,  1 TO 180, 294 LABEL OemToAnsi("Aprovador") OF oDlg PIXEL
		
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
		@ 72,240 MSCOMBOBOX oCbx VAR cTpCta ITEMS aTpCta SIZE 46, 50 OF oDlg PIXEL //Valid !Empty(cTpCta)
		/*	------------------
		FAVORECIDO
		------------------*/
		@ 105,13 SAY   OemToAnsi("Nome")	SIZE 26, 7 OF oDlg PIXEL
		@ 102,42 MSGET cNomFav SIZE 149, 10 OF oDlg PIXEL Picture "@!"
		
		@ 105,197 SAY	OemToAnsi("CNPJ/CPF") SIZE 26, 7 OF oDlg PIXEL
		@ 102, 230 MSGET cInscr SIZE 54,10 OF oDlg PIXEL //Valid CGC(cInscr)
		
		@ 120, 13 SAY	OemToAnsi("Histórico")	SIZE 26, 7 OF oDlg PIXEL
		@ 117, 42 MSGET cHistor SIZE 149,10 OF oDlg PIXEL Picture "@!"
		   
		/*	------------------
		APROVADOR
		------------------*/
		@ 152,13 SAY   OemToAnsi("Aprovador")	SIZE 26, 7 OF oDlg PIXEL
		//@ 150,42 MSGET cNomApr SIZE 149, 10 OF oDlg PIXEL Picture "@!" F3 "Z4"
		//@ 150,042 MSGET cCodApr SIZE 054, 10 OF oDlg PIXEL Picture "@!" VALID !Empty(cCodApr) .And. ExistCpo("SX5", + "Z4" + cCodApr) F3 "Z4"
		@ 150,042 MSGET cCodApr SIZE 054, 10 OF oDlg PIXEL Picture "@!" VALID VLDAPRV(cCodApr) F3 "Z4"

		//@ 150,100 MSGET cNomApr SIZE 150, 10 OF oDlg PIXEL Picture "@!" WHEN .F. 
		
		
		DEFINE SBUTTON FROM 185, 260 TYPE 1	ACTION (nOpca=0,oDlg:End())	ENABLE OF oDlg
		oCbx:Select(Val(cTpCta))     //Posiciona no item selecionado
		
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
		
		If Empty(cCodOri)
			Loop
		EndIf
		RecLock("SE2",.F.)
		SE2->E2_X_NOMFV := cNomFav
		SE2->E2_X_CPFFV := cInscr
		SE2->E2_HIST    := cHistor
		SE2->E2_X_USUAR := Alltrim(USRFULLNAME(RETCODUSR()))
		SE2->E2_X_DEPTO := Tabela("80",cCodOri,.f.)
		SE2->E2_X_CODUS := RetCodUsr()
		msUnlock("SE2")
		
		Exit
	EndDo
	aAdd(aDadosAP,{"TOTAL DO DOCUMENTO CTR",0})
	aAdd(aDadosAP,{"",Nil})
	//	aAdd(aDadosAP,{Upper("Ref.Nota Fiscal Nr. "+ALLTRIM(SF1->F1_DOC)+"  Serie: "+ALLTRIM(SF1->F1_SERIE)),Nil})
	aAdd(aDadosAP,{Upper("Ref.NF(s).Nr(s). "+cHistTMP),Nil})
	//	aAdd(aDadosAP,{Upper("Fornecedor: "+SF1->F1_FORNECE+"-"+SF1->F1_LOJA+" - "+Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME")),Nil})
	aAdd(aDadosAP,{Upper("Fornedor (es)"+cHistFor),Nil})
	
	aAdd(aDadosTit, {SE2->E2_PREFIXO,SE2->E2_NUM ,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,cNumAp,cBco,cAge,cConta,cNomFav,cInscr,cCodOri,cTpCta,cFrmPag,cHistor, cHist1})

    //AOliveira
    // 
	If SuperGetMV("EP_NEWAP",.F., .F.) // GetMv() 
		//Novo processo ativo
	    //u_GRVSZW(aDadosTit,cNumAp)
	    //u_GRVSZW(aDadosTit,cNumAp,RetCodUsr()) //17-10-2019 AOliveira Inclusão para gravar COD USR que incluiu a AP
	    u_GRVSZW(aDadosTit,cNumAp,RetCodUsr(),cCodApr) //22-10-2019 AOliveira Inclusão para gravar COD APR da AP		
		
		//Enviar e-mail de aviso.  
		//VSS_ENVMAIL(_cAP, _cForn, _cEmlAP)
		//_cEmail :=  "andre@sigasp.com;"+iif( Empty(UsrRetMail(cCodApr)), "" , UsrRetMail(cCodApr) )
		_cEmail :=  iif( Empty(UsrRetMail(cCodApr)), "" , UsrRetMail(cCodApr) )
		VSS_ENVMAIL(cNumAp, cFornece, _cEmail, SE2->E2_NUM)
			    
	Else 
		//Processo Antigo
		U_RFINR01(aDadosTit,aDadosAP)
	EndIf
	
	
EndIf

RestArea(_aArea)
Return

/*
While .T.
DEFINE MSDIALOG oDlg FROM	15,6 TO 150,597 TITLE OemToAnsi("Autorização de Pagamento") PIXEL
@  0,  1 TO  45, 294 LABEL OemToAnsi("Fornecedor") OF oDlg PIXEL

@ 11, 13 SAY	OemToAnsi("Nome")	SIZE	21,  7	 OF oDlg PIXEL
@  9, 42 MSGET cFornece SIZE 149, 10	 OF oDlg PIXEL WHEN .F.

@ 11,197 SAY	OemToAnsi("Numero AP")	SIZE	28,  7	 OF oDlg PIXEL
@ 9, 230 MSGET cNumAp SIZE	54, 10	 OF oDlg PIXEL WHEN .F.

@ 29, 13 SAY	OemToAnsi("Origem")	SIZE	26,  7	 OF oDlg PIXEL
@ 26, 42 MSGET cCodOri        		SIZE 18, 10 OF oDlg PIXEL Picture "@!"  Valid !Empty(cCodOri) .And. ExistCpo("SX5", + "80" + cCodOri) F3 "80"

@ 29, 90 SAY	OemToAnsi("Histórico")	SIZE 26, 7 OF oDlg PIXEL
@ 26,120 MSGET cHistor SIZE 149,10 OF oDlg PIXEL Picture "@!" WHEN .F.

DEFINE SBUTTON FROM 50, 260 TYPE 1	ACTION (nOpca=0,oDlg:End())	ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED

If Empty(cCodOri)
Loop
Else
Exit
EndIf
EndDo
*/

/*
* VSS_ENVMAIL
*
*@versao: 1.0
*@autor : AOliveira
*@Data  : 2018-02-06
*@Descr.: Inicia WF de envio de e-mail
*/
Static Function VSS_ENVMAIL(_cAP, _cForn, _cEmlAP, _cNumTit)

Local oHtml
Local oProcess

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
aAdd( oHtml:ValByName( "it.desc" ), "AP: "+ Alltrim(_cAP) +" ")
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