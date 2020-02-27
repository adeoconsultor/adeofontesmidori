#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.ch"
/*
---------------------------------------------------------------------------------------------------
Objetivo: Autorização de Pagamento - Informacoes sobre forma de pagamento
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
14-Tipo de Conta     	| 1=Conta Corrente 2= Conta Poupanca
15-Forma de Pagamento   | 1=DOC/TED 2=Boleto/DDA 3=Cheque
---------------------------------------------------------------------------------------------------
Alterações:
---------------------------------------------------------------------------------------------------
- Mar/10 - Retirado campos financeiros da tela por solicitação usuaria Patricia (Fiscal)
- Chamado HD No. 516 - Alteração tela para incluir dados financeiros
---------------------------------------------------------------------------------------------------*/

User Function SF1100I
Local aOrigem   := {}
Local nOpca     := 0
Local aDadosTit := {}
Local aDadosAP  := {}
Local cFornece 	:= ""
Local cOrigem   := ""
Local cBco      := ""
Local cAge      := ""
Local cConta    := ""
Local oDlg
Local cxHist	:= ""
Local cNumAp    := ""
LOCAL aTpCta 	:= {"1=Corrente","2=Poupanca",""}
LOCAL aFrmPag 	:= {"1=DOC/TED","2=Boleto/DDA","3=Cheque","4=Caixa","5=Cnab Folha","6=Cartão Corporativo"}
Local nPosProd	:= 1//Ascan(aHeader, {|n| Alltrim(n[2]) = "D1_COD"})							// Posicao do codigo do produto
Local cPrdY		:= GetMv ('MV_PRODCON')

Local _x

Private _cEmlFor	:= GetMv ('MA_EMAIL20')  
Private cPrdC		:= ''
Private oHist	
//
Private cCodApr  := CriaVar("ZW_USRAP")
Private cNomApr  := CriaVar("ZW_USRAPN") 
//
Private cCodOri  	:= CriaVar("F1_X_ORIG") ,cVarOri
Private cTpCta   	:= CriaVar("F1_X_TPCTA"), cvar
Private cFrmPag  	:= CriaVar("F1_X_FPAGT"),cVarPag
Private cNomFav  	:= CriaVar("E2_X_NOMFV")
Private cInscr   	:= CriaVar("E2_X_CPFFV")
Private cCodHi   	:= space(3)
Private cHistor  	:= CriaVar("E2_HIST")
Private	cCodUs	 	:= UsrFullName(RetCodUsr() )
Private cDocProd 	:= SD1->D1_DOC+Space(2)+SD1->D1_SERIE
Private cCodFPrd	:= SF1->F1_FORNECE
Private cCodLjFo	:= SF1->F1_LOJA
Private cNomFPrd	:= POSICIONE("SA2",1,XFILIAL("SA2")+cCodFPrd+cCodLjFo,"A2_NOME") 
 
Private lVLDAPRV := .T.

aOrigem   := {}

For _x := 1 to Len(aCols)
	If  Alltrim(aCols[_x][nPosProd]) $ cPrdY
		cPrdC += Alltrim(aCols[_x][nPosProd]) + space(2)
	EndIf		
Next

If Len(cPrdC) > 0
	WENVMAIL(cPrdC, cDocProd,_cEmlFor, 'Documento Entrada  - Produto Reembolso JPY' )
EndIf

If SF1->F1_TIPO == "D"  //Devolucao  //!= "N"    //alterado CHAMADO HD No. 908-17/06/10 - Para gerar AP para Notas Complementares ICM/IPI/PREÇO
	Return
Else
	If FunName() = "MATA116"	// Verifica se doc. é uma NF Frete. Impede gerar AP em duplicidade quando Nota de Frete (HD No. 1037 30/06/10)
		Return
	EndIf
EndIf

If !Empty(SF1->F1_DUPL)          

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//ROTINA DESENVOLVIDA POR ANESIO PARA SOLICITAR CODIGO DA RETENCAO CASO O USUARIO NAO INCLUA NA CLASSIFICACAO
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	cQuery := " Select E2_PREFIXO, E2_NUM, E2_TIPO, E2_PARCELA, E2_NATUREZ, E2_DIRF, E2_CODRET, E2_EMISSAO from SE2010 "
	cQuery += " where D_E_L_E_T_ = ' '  AND E2_FILIAL = '"+xFilial("SE2")+"' "
	cQuery += " AND E2_NUM = '"+SF1->F1_DOC+"' " 
	cQuery += " AND E2_EMISSAO = '"+dtos(SF1->F1_EMISSAO)+"' "
	cQuery += " AND E2_TIPO = 'TX' "
		
	if Select("TMPE2") > 0
		dbSelectArea('TMPE2')
		TMPE2->(dbCloseArea())
	endif
	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), 'TMPE2', .T., .T.)
	
	dbSelectArea("TMPE2")
	TMPE2->(dbGotop())
	nCount:= 0
	lCodRet := .T. 
	cPrefixo:= "" 
	cNum 	:= "" 
	cParc	:= ""
	cTipo 	:= "" 
	nCtRet  := 0
	while !TMPE2->(eof())
		nCount++
			cPrefixo:= TMPE2->E2_PREFIXO
			cNum 	:= TMPE2->E2_NUM
			cParc	:= TMPE2->E2_PARCELA
			cTipo 	:= TMPE2->E2_TIPO
			if TMPE2->E2_NATUREZ $ 'IRF       ' .and. empty(TMPE2->E2_CODRET) 
				Private cGetCRet   := Space(4)
				Private cSayCodRet := Space(8)
				
				SetPrvt("oFont1","oDlg1","oSayCodRet","oGetCRet","oBtnConfirma")
				oFont1     := TFont():New( "MS Sans Serif",0,-20,,.T.,0,,700,.F.,.F.,,,,,, )
				oDlg1      := MSDialog():New( 194,298,304,575,"Informar Código de Retenção",,,.F.,,,,,,.T.,,,.T. )
				oSayCodRet := TSay():New( 008,012,{||"Codigo "+AllTrim(TMPE2->E2_NATUREZ)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,016)
				oGetCRet   := TGet():New( 024,012,{|u| If(PCount()>0,cGetCRet:=u,cGetCRet)},oDlg1,048,014,'@!',{||agVld(cGetCRet, cPrefixo, cNum, cParc, cTipo)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F., ("SX5", "37"),"cGetCRet",,)
				oBtnConfir := TButton():New( 024,080,"&Confirmar",oDlg1,{|| oDlg1:End(), agVld(cGetCRet, cPrefixo, cNum, cParc, cTipo)} ,048,016,,,,.T.,,"",,,,.F. )
		
				oDlg1:Activate(,,,.T.)
			endif
			if TMPE2->E2_NATUREZ $ 'COFINS    ' .and. empty(TMPE2->E2_CODRET) 
				cGetCRet   := Space(4)
				cSayCodRet := Space(8)
				
				SetPrvt("oFont1","oDlg1","oSayCodRet","oGetCRet","oBtnConfirma")
				oFont1     := TFont():New( "MS Sans Serif",0,-20,,.T.,0,,700,.F.,.F.,,,,,, )
				oDlg1      := MSDialog():New( 194,298,304,575,"Informar Código de Retenção",,,.F.,,,,,,.T.,,,.T. )
				oSayCodRet := TSay():New( 008,012,{||"Codigo "+AllTrim(TMPE2->E2_NATUREZ)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,016)
				oGetCRet   := TGet():New( 024,012,{|u| If(PCount()>0,cGetCRet:=u,cGetCRet)},oDlg1,048,014,'@!',{||agVld(cGetCRet, cPrefixo, cNum, cParc, cTipo)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F., ("SX5", "37"),"cGetCRet",,)
				oBtnConfir := TButton():New( 024,080,"&Confirmar",oDlg1,{|| oDlg1:End(), agVld(cGetCRet, cPrefixo, cNum, cParc, cTipo)} ,048,016,,,,.T.,,"",,,,.F. )
		
				oDlg1:Activate(,,,.T.)
			endif
			if TMPE2->E2_NATUREZ $ 'PIS       ' .and. empty(TMPE2->E2_CODRET) 
				cGetCRet   := Space(4)
				cSayCodRet := Space(8)
				
				SetPrvt("oFont1","oDlg1","oSayCodRet","oGetCRet","oBtnConfirma")
				oFont1     := TFont():New( "MS Sans Serif",0,-20,,.T.,0,,700,.F.,.F.,,,,,, )
				oDlg1      := MSDialog():New( 194,298,304,575,"Informar Código de Retenção",,,.F.,,,,,,.T.,,,.T. )
				oSayCodRet := TSay():New( 008,012,{||"Codigo "+AllTrim(TMPE2->E2_NATUREZ)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,016)
				oGetCRet   := TGet():New( 024,012,{|u| If(PCount()>0,cGetCRet:=u,cGetCRet)},oDlg1,048,014,'@!',{||agVld(cGetCRet, cPrefixo, cNum, cParc, cTipo)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F., ("SX5", "37"),"cGetCRet",,)
				oBtnConfir := TButton():New( 024,080,"&Confirmar",oDlg1,{|| oDlg1:End(), agVld(cGetCRet, cPrefixo, cNum, cParc, cTipo)} ,048,016,,,,.T.,,"",,,,.F. )
		
				oDlg1:Activate(,,,.T.)
			endif
		
		TMPE2->(dbSkip())
	enddo

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FIM ROTINA
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//ROTINA DESENVOLVIDA POR ANESIO PARA SOLICITAR CODIGO DE PAGAMENTO EM TITULOS PUBLICOS
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Condicao para chamar a tela de inclusao de CODIGO DE PAGAMENTO E COMPETENCIA			
if SF1->F1_FORNECE > "999999"
	Private cGetCP     := Space(4)
	Private cGetComp   := CTOD('  /  /  ')
	SetPrvt("oDlgCP","oSayCP","oSayCOMP","oGetCP","oGetComp","oBtn1")

	oDlgCP      := MSDialog():New( 138,307,268,556,"Adicionais GPS",,,.F.,,,,,,.T.,,,.T. )
	oSayCP      := TSay():New( 008,008,{||"CÓDIGO PAGAMENTO: "},oDlgCP,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
	oSayCOMP      := TSay():New( 024,008,{||"COMPETENCIA"},oDlgCP,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
	oGetCP     := TGet():New( 005,076,{|u| If(PCount()>0,cGetCP:=u,cGetCP)},oDlgCP,036,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetCP",,)
	oGetComp   := TGet():New( 022,076,{|u| If(PCount()>0,cGetComp:=u,cGetComp)},oDlgCP,036,008,'@r 99/99/9999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetComp",,)
//	oGetComp   := TGet():New( 022,060,,oDlgCP,052,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oBtn1      := TButton():New( 040,075,"&Confirmar",oDlgCP,{|| oDlgCP:End(), agVldCP(xFilial("SF1"), SF1->F1_DOC, SF1->F1_FORNECE, SF1->F1_LOJA,SF1->F1_EMISSAO, cGetCP, cGetComp)},037,012,,,,.T.,,"",,,,.F. )

	oDlgCP:Activate(,,,.T.)
endif
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FIM ROTINA
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




	SA2->( dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA) )
	cFornece := Substr( SA2->A2_COD+" "+ SA2->A2_LOJA +" "+ SA2->A2_NOME,1,50)
	cBco     := SA2->A2_BANCO
	cAge     := SA2->A2_AGENCIA
	cConta   := SA2->A2_NUMCON
	cTpCta   := SA2->A2_X_TPCON		//If(Empty(SA2->A2_X_TPCON),"",SA2->A2_X_TPCON)
	cFrmPag  := cVarPag := aFrmPag
	cOrigem  := " "
//	alert('PEDIDO ->'+SD1->D1_PEDIDO)
	cxHist   := U_AG_HIST2(xFilial('SF1'), SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA, SD1->D1_PEDIDO)
	/*
	------------------------------------
	Numero da AP
	------------------------------------*/
	//cNumAp := GETSXENUM('SE2','E2_X_NUMAP','E2_X_NUMAP') /*AOliveira 25-05-2011*/    //GetSxeNum("SE2","E2_X_NUMAP")
	//ConfirmSx8()   
	
	cNumAp := U_XGETNAP() /*AOliveira 18-07-2019*/
	
	/*---- Monta a Interface com o Usuário ---*/
	While .T.
		DEFINE MSDIALOG oDlg FROM	15,6 TO 420,597 TITLE OemToAnsi("Autorização de Pagamento MATA103") PIXEL
		@ 000,  1 TO  45, 294 LABEL OemToAnsi("Fornecedor") OF oDlg PIXEL
		@ 049,  1 TO  91, 294 LABEL OemToAnsi("Pagamento através de Crédito em Conta") OF oDlg PIXEL  //75
		@ 096,  1 TO 135, 294 LABEL OemToAnsi("Favorecido") OF oDlg PIXEL  
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
		@ 72,240 MSCOMBOBOX oCbx VAR cTpCta ITEMS aTpCta SIZE 46, 50 OF oDlg PIXEL //Valid !Empty(cTpCta)
		/*	------------------
		FAVORECIDO
		------------------*/
		@ 105,13 SAY   OemToAnsi("Nome")	SIZE 26, 7 OF oDlg PIXEL
		@ 102,42 MSGET cNomFav SIZE 149, 10 OF oDlg PIXEL Picture "@!"
		
		@ 105,197 SAY	OemToAnsi("CNPJ/CPF") SIZE 26, 7 OF oDlg PIXEL
		@ 102, 230 MSGET cInscr SIZE 54,10 OF oDlg PIXEL //Valid CGC(cInscr)
		
//		@ 120, 13 SAY	OemToAnsi("Histórico")	SIZE 26, 7 OF oDlg PIXEL
//		@ 117, 42 MSGET cHistor SIZE 149,10 OF oDlg PIXEL Picture "@!"
		@ 120, 13 SAY   OemToAnsi("Cod.Hist.") SIZE 26, 7 OF oDlg Pixel
//		@ 117, 42 MSGET cCodHi SIZE 35, 10 OF oDlg Pixel Picture "@!"  Valid !Empty(cCodHi) .and. VLDHIST(cCodHi) .And. ExistCpo("SZJ", cCodHi) F3 "SZJ" 
		@ 117, 42 MSGET cCodHi SIZE 35, 10 OF oDlg Pixel Picture "@!"  Valid VLDHIST(cCodHi,'D') F3 "SZJ" 

		@ 120, 45 SAY	OemToAnsi("")	SIZE 26, 7 OF oDlg PIXEL
		@ 117, 80 MSGET oHist Var cHistor SIZE 210,10 OF oDlg PIXEL Picture "@!" Valid VLDCHIST(cCodHi)

		@ 142, 13 SAY	OemToAnsi(cxHist)	SIZE 250, 7 OF oDlg PIXEL

		/*	------------------
		APROVADOR
		------------------*/
		@ 152,13 SAY   OemToAnsi("Aprovador")	SIZE 26, 7 OF oDlg PIXEL
		//@ 150,42 MSGET cNomApr SIZE 149, 10 OF oDlg PIXEL Picture "@!" F3 "Z4"
		//@ 150,042 MSGET cCodApr SIZE 054, 10 OF oDlg PIXEL Picture "@!" VALID !Empty(cCodApr) .And. ExistCpo("SX5", + "Z4" + cCodApr) F3 "Z4"
		@ 150,042 MSGET cCodApr SIZE 054, 10 OF oDlg PIXEL Picture "@!" VALID VLDAPRV(cCodApr) F3 "Z4"
		//@ 150,100 MSGET cNomApr SIZE 150, 10 OF oDlg PIXEL Picture "@!" WHEN .F. 
		
		
		DEFINE SBUTTON FROM 185, 260 TYPE 1	ACTION (if(VLDHIST(cCodHi, 'F'), oDlg:End(), nOpca=0 ))	ENABLE OF oDlg
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

		//Obrigar ao usuário informar o histórico padrao...
		if empty(cCodHi)
			ApMsgAlert('Favor preencher o código do histórico')
			Loop
		endif
		if cCodHi == '001'
			if !VLDCHIST(cCodHi)
				loop 
			endif
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
			if empty(cCodHi)
				ApMsgAlert('Favor preencher o código do histórico')
				Loop
			endif
			If !ApMsgYesNo("Confirma a Forma de Pagamento ?")
				Loop
			EndIf
			
		EndIf
		//Gravar o nome reduzido do fornecedor no cabeçalho da nota
		RecLock('SF1',.F.)
		SF1->F1_NREDUZ := U_AG_SHNREDUZ(SF1->F1_FORNECE, SF1->F1_LOJA, SF1->F1_TIPO)
			//Gravar o nome do usuário que fez a inclusao da nota fiscal....caso esteja em branco....
			If Empty(SF1->F1_USERPN)
				SF1->F1_USERPN  := cUserName
			endif
	
		MsUnLock("SF1")
		
		If nOpcA == 0
			RecLock('SF1',.F.)
			SF1->F1_X_ORIG := cCodOri
			SF1->F1_X_NUMAP:= cNumAp
			SF1->F1_X_FPAGT:= cFrmPag
			
			If cFrmPag == '1'           // --DOC/TED
				SF1->F1_X_BCOFV:= cBco
				SF1->F1_X_AGEFV:= cAge
				SF1->F1_X_CTAFV:= cConta
				SF1->F1_X_TPCTA:= cTPCta
			EndIf
			MsUnLock('SF1')
		EndIf
		Exit
	EndDo
	
	aAdd(aDadosAP,{"TOTAL DA NOTA FISCAL",SF1->F1_VALBRUT})
	//						1				2	   3	    4					5			6		7		   8				9				10			11		12         13        14      15      16
	aAdd(aDadosTit, {SF1->F1_PREFIXO,SF1->F1_DUPL,"",SF1->F1_ESPECIE,SF1->F1_FORNECE,SF1->F1_LOJA,cNumAp,SF1->F1_X_BCOFV,SF1->F1_X_AGEFV,SF1->F1_X_CTAFV,cNomFav,cInscr,SF1->F1_X_ORIG,cTpCta,cFrmPag,cHistor, cxHist})

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
		VSS_ENVMAIL(cNumAp, cFornece, _cEmail, SF1->F1_DUPL)


		//17-01-2020
		//Comentado por AOliveira, pois não deveria estar executando no novo processo de aporvação de AP.
		//U_RFINR01(aDadosTit,aDadosAP) 
	       
	Else 
		//Processo Antigo
		//Impressao da AP
		U_RFINR01(aDadosTit,aDadosAP)
	EndIf


aDadosTit := {}
EndIf

Return

/*----------------------------
If cFrmPag == '1'
If Empty(cBco)
cBco     := SA2->A2_BANCO
cAge     := SA2->A2_AGENCIA
cConta   := SA2->A2_NUMCON
Loop
ElseIf Empty(cAge)
Loop
ElseIf Empty(cConta)
Loop
EndIf
Else
If !Empty(cBco)
cBco := ""
cAge := ""
cConta := ""
Loop
EndIf
EndIf

If nOpcA == 0
SF1->F1_X_ORIG := cCodOri
SF1->F1_X_NUMAP:= cNumAp
SF1->F1_X_FPAGT:= cFrmPag

If cFrmPag == '1'           // --DOC/TED
SF1->F1_X_BCOFV:= cBco
SF1->F1_X_AGEFV:= cAge
SF1->F1_X_CTAFV:= cConta
SF1->F1_X_TPCTA:= cTPCta
EndIf
EndIf

If Empty(cCodOri)
Loop
EndIf
------------------------------------------------*/

////////////////////////////////////////////////////////////////////////////////////////
//FUNCAO PARA GRAVAR O CODIGO DE PAGAMENTO E COMPETENCIA
//DESENVOLVIDO POR ANESIO G.FARIA - MAIO-2014 - anesio@outlook.com
////////////////////////////////////////////////////////////////////////////////////////
static function agVldCP(cPrefixo, cNum, cFornece, cLoja, cEmissao, cCodCP, cCodComp)
local cQuery := ""
cQuery := " Select E2_PREFIXO, E2_NUM, E2_TIPO, E2_PARCELA, E2_NATUREZ  from SE2010 "
cQuery += " where D_E_L_E_T_ = ' '  AND E2_FILIAL = '"+xFilial("SE2")+"' "
cQuery += " AND E2_NUM = '"+cNum+"' " 
cQuery += " AND E2_FORNECE = '"+cFornece+"' AND E2_LOJA = '"+cLoja+"' " 
cQuery += " AND E2_EMISSAO = '"+dtos(cEmissao)+"' "
cQuery += " AND E2_TIPO = 'NF' "
	
if Select("TMPE2") > 0
	dbSelectArea('TMPE2')
	TMPE2->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), 'TMPE2', .T., .T.)

dbSelectArea("TMPE2")
TMPE2->(dbGotop())
dbSelectArea('SE2')
	dbSetOrder(1)
	if dbSeek(xFilial('SE2')+TMPE2->E2_PREFIXO + cNum + TMPE2->(E2_PARCELA + E2_TIPO)+cFornece+cLoja)
		RecLock("SE2",.F.)
		SE2->E2_X_CODRE = cCodCP
		SE2->E2_APURAC := cCodComp//stod(cCodComp)
		MsUnLock("SE2")
	endif
return 


////////////////////////////////////////////////////////////////////////////////////////
//FUNCAO PARA VERIFICAR SE O CODIGO DE RETENCAO UTILIZADO EXISTE NO ARQUIVO SX5
//DESENVOLVIDO POR ANESIO G.FARIA - MAIO/JUNHO-2013 - anesio@outlook.com
////////////////////////////////////////////////////////////////////////////////////////
static function agVld(cCodRet, cPrefixo, cNum, cParc, cTipo)
local lRetCd := .T.
cQX5 := " SELECT X5_TABELA from SX5010 where D_E_L_E_T_ = ' ' and X5_TABELA = '37' and X5_CHAVE = '"+cCodRet+"' "

if Select('TMPX5') > 0 
	dbSelectArea('TMPX5')
	TMPX5->(dbCloseArea())
endif

dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQX5), 'TMPX5', .T., .T.)

nCount := 0
dbSelectArea('TMPX5')
TMPX5->(dbGotop())
while !TMPX5->(eof())
	nCount++
	TMPX5->(dbSkip())
enddo
if nCount == 0
	Alert('Codigo de Retenção invalido, por favor corrija. ')
	oGetCRet:SetFocus()
	Return
	lRetCd := .F.
else
	dbSelectArea('SE2')
	dbSetOrder(1)
	if dbSeek(xFilial('SE2')+cPrefixo + cNum + cParc + cTipo + "UNIAO")
		RecLock("SE2",.F.)
		SE2->E2_DIRF = '1'
		SE2->E2_CODRET := cCodRet
		MsUnLock("SE2")
	endif
endif

return lRetCd

////////////////////////////////////////////////////////////////////////////////////////
//Funcao para validar o codigo do histório e alimentar o campo HISTORICO
////////////////////////////////////////////////////////////////////////////////////////
static function VLDHIST(cCodHi, cFrom)
local lRet := .T.
//if Substr(cHistor,1,12) == space(12)
if cFrom == 'D'
	cHistor := Posicione("SZJ", 1, xFilial("SZJ")+cCodHi, "ZJ_DESCRI")
	oHist:Refresh()
endif 
if Empty(cCodHi) 
	Alert('Favor preencher o histórico padrao')
	lRet := .F.
	Return lRet
endif
if !ExistCpo("SZJ", cCodHi) 
	Alert('O Código digitado não existe no cadastro')
	lRet := .F.
	Return lRet
endif
return lRet

////////////////////////////////////////////////////////////////////////////////////////
//Funcao para validar o campo HISTORICO
//Não permitir alimentar com "HISTORICO PADRAO" quando o codigo for 001
////////////////////////////////////////////////////////////////////////////////////////
static function VLDCHIST(cCodHi)
local lRet := .T.
if cCodHi == '001' .and. cHistor == Posicione("SZJ", 1, xFilial("SZJ")+cCodHi, "ZJ_DESCRI")
	Alert("Quando utilizado "+ ALLTRIM(Posicione("SZJ", 1, xFilial("SZJ")+cCodHi, "ZJ_DESCRI"))+chr(13)+"O Histórico deverá ser preenchido com valor diferente")
	lRet := .F.
	Return lRet
endif 
if Empty(cHistor)
	Alert("O campo histórico é obrigatório")
	lRet := .F.
	Return lRet
endif
return lRet



///////////////////////////////////////////////////////////////////////////
//Funcao para gravar o historico da nota fiscal
//baseado no pedido de compras, aprovadores e solicitante.
//desenvolvido por anesio g.faria anesio@anesio.com.br
///////////////////////////////////////////////////////////////////////////

user  function AG_HIST2(cxFilial, cNfiscal, cSerie, cFornece, cLoja, cPed)
local cHist := ""
local cQuery:= ""

cQuery := " Select distinct C7_NUM, C7_NUMSC from SC7010 where D_E_L_E_T_ =' ' " 
cQuery += " and C7_FILIAL = '"+cxFilial+"' and C7_NUM = '"+cPed+"' " 
if Select('TMPC7') > 0 
	dbSelectArea('TMPC7')
	TMPC7->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(,, cQuery), 'TMPC7', .T.,.T.)

if TMPC7->C7_NUMSC == space(6)
	cHist := 'PED:'+cPed+'|PED.SEM SC| '

	cQSCR := " Select CR_NUM, CR_NIVEL, CR_DATALIB, CR_USER, CR_VALLIB from SCR010 where CR_FILIAL = '"+cxFilial+"' and CR_LIBAPRO <> '' "
	cQSCR += " and CR_NUM='"+cPed+"' "
	
	if Select("TMPCR") > 0 
		dbSelectArea("TMPCR")
		TMPCR->(dbCloseArea())
	endif
	
	dbUseArea(.T.,"TOPCONN", tcGenQry(,,cQSCR), 'TMPCR', .T., .T.)
	
	cUsr01 := "" //Usuario que fez a liberacao nivel 01
	cUsr02 := "" //Usuario que fez a liberacao nivel 02
	dbSelectArea("TMPCR")
	TMPCR->(dbGotop())
	while !TMPCR->(eof())
		if TMPCR->CR_NIVEL == '01' 
			cUsr01 := "APROV.NIV 01: "+UsrRetName(TMPCR->CR_USER)
		elseif TMPCR->CR_NIVEL == '02'
			cUsr02 := "APROV.NIV 02: "+UsrRetName(TMPCR->CR_USER)
		endif
		TMPCR->(dbSkip())
	enddo
else
	cQSC1 := " SELECT DISTINCT C1_RINGSHO, C1_NUMRSHO FROM SC1010 WHERE D_E_L_E_T_ = ' ' AND C1_RINGSHO = 'S' " 
	cQSC1 += " AND C1_FILIAL = '"+xFilial("SC1")+"' AND C1_NUM = '"+TMPC7->C7_NUMSC+"' " 
	if Select('TMPC1') > 0
		dbSelectArea('TMPC1')
		TMPC1->(dbCloseArea())
	endif
	
	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQSC1), 'TMPC1',.T., .T.)
	dbSelectArea("TMPC1")
	TMPC1->(dbGotop())
	cRingiSho := "SEM RINGI-SHO:"
	while !TMPC1->(eof())
		cRingiSho := "RINGI-SHO: "+TMPC1->C1_NUMRSHO
		TMPC1->(dbSkip())
	enddo
//	if substr(cRingiSho,12,5) == space(5)
//		cRingiSho := "SEM RINGI-SHO"
//	endif
	
	cHist := 'PED:'+cPed+'| SOLICITACAO: '+TMPC7->C7_NUMSC+ "| "+cRingiSho

		

	cQSCR := " Select CR_NUM, CR_NIVEL, CR_DATALIB, CR_USER, CR_VALLIB from SCR010 where CR_FILIAL = '"+cxFilial+"' and CR_LIBAPRO <> '' "
	cQSCR += " and CR_NUM='"+cPed+"' "
	
	if Select("TMPCR") > 0 
		dbSelectArea("TMPCR")
		TMPCR->(dbCloseArea())
	endif
	
	dbUseArea(.T.,"TOPCONN", tcGenQry(,,cQSCR), 'TMPCR', .T., .T.)
	
	cUsr01 := "" //Usuario que fez a liberacao nivel 01
	cUsr02 := "" //Usuario que fez a liberacao nivel 02
	dbSelectArea("TMPCR")
	TMPCR->(dbGotop())
	while !TMPCR->(eof())
		if TMPCR->CR_NIVEL == '01' 
			cUsr01 := "APROV.NIV 01: "+UsrRetName(TMPCR->CR_USER)
		elseif TMPCR->CR_NIVEL == '02'
			cUsr02 := "APROV.NIV 02: "+UsrRetName(TMPCR->CR_USER)
		endif
		TMPCR->(dbSkip())
	enddo
endif

cHist := cHist + cUsr01+' '+cUsr02

return cHist


////////////////////////////////////////////////////////////////////////////////////////
//Funcao para gravar o nome reduzido do fornecedor no cabeçalho da nota fiscal
//Desenvolvido por Anesio G.Faria (anesio@anesio.com.br) em 07/03/2014
//Conforme chamado aberto por Marcos Eurides - N.Chamado 005076
////////////////////////////////////////////////////////////////////////////////////////
user function AG_SHNREDUZ(cCod, cLoja, cTipo)
local cRetNome := "" 
//	Alert('TIPO-> '+cTipo)
	IF cTipo $ 'DB'
		cRetNome := Posicione("SA1",1,xFilial("SA1")+cCod+cLoja,"A1_NREDUZ")	
	else
		cRetNome := POSICIONE("SA2",1,XFILIAL("SA2")+cCod+cLoja,"A2_NREDUZ")
	endif	
return cRetNome

/*--------------------------------------------
------Inicio de envio de e-mail----------
--------------------------------------------*/
Static Function WENVMAIL(cPrdC, cDocProd, _cEmlFor, cProc)

Local oHtml
Local oProcess 

SETMV("MV_WFMLBOX","WORKFLOW")
cProcess := OemToAnsi("001011")
cStatus  := OemToAnsi("001011") 
_cProc  := OemToAnsi(cProc) 
oProcess:= TWFProcess():New( '001010', _cProc )
oProcess:NewTask( cStatus, "\WORKFLOW\HTM\ProCont.htm" )
oHtml    := oProcess:oHTML
oHtml:ValByName("Data"			,DTOC(DDATABASE))
oHtml:ValByName("Prod"   		,cPrdC)
oHtml:ValByName("acao"			,_cProc)
	                                     
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	 aAdd( oHtml:ValByName( "it.desc" ), "Entrada do(s) Produto(s) : "+cPrdC)
 	 aAdd( oHtml:ValByName( "it.desc" ), "Nota Fiscal/Serie: "+cDocProd )
 	 aAdd( oHtml:ValByName( "it.desc" ), "Fornecedor: "+cCodFPrd+Space(1)+cCodLjFo+"/"+Space(1)+cNomFPrd )
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	 aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
	 aAdd( oHtml:ValByName( "it.desc" ), "Usuario : "+cCodUs)
   	 aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
	   	 
	   	    	                                 
oProcess:cSubject := _cProc + ":"+ cPrdC 
		
		
		
oProcess:cTo      := _cEmlFor     
		
oProcess:Start()                    
   	       
oProcess:Finish() 
Return(Nil)


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
		cA2CDUSR := Alltrim(Posicione("SA2",1, xFilial("SA2")+ SF1->F1_FORNECE+SF1->F1_LOJA,"A2_XCDUSR") )
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