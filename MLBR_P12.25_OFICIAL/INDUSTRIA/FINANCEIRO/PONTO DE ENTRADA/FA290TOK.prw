#INCLUDE "RWMAKE.CH"    
#INCLUDE "PROTHEUS.ch"
/*
----------------------------------------------------------------------------------------
Funcao: FA290TOK														Data: 12.04.2010
Autor : Gildesio Campos
----------------------------------------------------------------------------------------
Objetivo: 	1-Ponto de Entrada na confirmacao da Fatura
			2-Cria as variaveis que serao utilizadas no PE FA290
			3-Monta a interface com o usuário para informar dados da AP
----------------------------------------------------------------------------------------*/
User Function FA290TOK()              
Local lRet      := .T.    
Local nOpca     := 0
Local oDlg      

Public aTpCta 	:= {"1=Corrente","2=Poupanca",""}
Public aFrmPag  := {"1=DOC/TED","2=Boleto/DDA","3=Cheque","4=Caixa"}
Public cCodOri  := CriaVar("E2_X_ORIG") ,cVarOri 
Public cTpCta   := CriaVar("E2_X_TPCTA"), cvar
Public cFrmPag  := CriaVar("E2_X_FPAGT"),cVarPag       
Public cNomFav  := CriaVar("E2_X_NOMFV")
Public cInscr   := CriaVar("E2_X_CPFFV")   
Public cHistor  := CriaVar("E2_HIST")  

Public cFornece := Substr( SA2->A2_COD+" "+ SA2->A2_LOJA +" "+ SA2->A2_NOME,1,50)
Public cBco     := SA2->A2_BANCO
Public cAge     := SA2->A2_AGENCIA
Public cConta   := SA2->A2_NUMCON
Public cTpConta := If(Empty(SA2->A2_X_TPCON),"3",SA2->A2_X_TPCON)
Public aDadosTit:= {}  
Public cNumAp
Public aTitFt   := {}

Public cNumTit := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
Public nJuros  := CriaVar("E2_JUROS")  
Public nMulta  := CriaVar("E2_MULTA")  
Public nCorrec := CriaVar("E2_CORREC")  
Public cCodRec := CriaVar("E2_X_CODRE")  
Public cCodRec2:= CriaVar("E2_X_CODRE")  
Public cRefer  := CriaVar("E2_X_REFER")  
Public cObsTr  := CriaVar("E2_X_OBSTR")  
Public dDataAp := CriaVar("E2_APURAC") 
Public nOutEnt := CriaVar("E2_ACRESC")
Public aTpDoc  := {"1=DARF","2=GPS"}
Public cTpDoc  := ""
Public dDtPagto := CriaVar("E2_APURAC")    //quando o documento é pago com atraso -- criar um campo no SE2
Public cForOrig :=  CriaVar("E2_X_FORIG")
//Public cLojaOrig:= CriaVar("E2_X_LORIG")
/*---- Monta a Interface com o Usuário ---*/
cTpCta   := cTpConta	
cFrmPag  := cVarPag := aFrmPag[1]     
cHistor  := "JUNCAO DE TITULOS EM FATURA"

/*--- Numero da AP ---*/
cNumAp := GETSXENUM('SE2','E2_X_NUMAP','E2_X_NUMAP') /*AOliveira 25-05-2011*/    //GetSx8Num("SE2","E2_X_NUMAP")
ConfirmSx8()

/*--- Verifica se titulos sao tipo TX ---*/
U_A290TRB()
	    
While .T.	                                      
	DEFINE MSDIALOG oDlg FROM	15,6 TO 320,597 TITLE OemToAnsi("Autorização de Pagamento - Faturas") PIXEL
	@  0,  1 TO  45, 294 LABEL OemToAnsi("Fornecedor") OF oDlg PIXEL  
	@ 49,  1 TO  91, 294 LABEL OemToAnsi("Pagamento através de Crédito em Conta") OF oDlg PIXEL  //75
	@ 96,  1 TO 135, 294 LABEL OemToAnsi("Favorecido") OF oDlg PIXEL  

	@ 11, 13 SAY	OemToAnsi("Nome")	SIZE	21,  7	 OF oDlg PIXEL 
	@  9, 42 MSGET	cFornece SIZE 149, 10	 OF oDlg PIXEL WHEN .F.

	@ 11,197 SAY	OemToAnsi("Numero AP")	SIZE	28,  7	 OF oDlg PIXEL  
	@ 9, 230 MSGET cNumAp SIZE	54, 10	 OF oDlg PIXEL WHEN .F.

	@ 29, 13 SAY	OemToAnsi("Origem")	SIZE	26,  7	 OF oDlg PIXEL 
	@ 26, 42 MSGET cCodOri        		SIZE 18, 10 OF oDlg PIXEL Picture "@!"  Valid !Empty(cCodOri) .And. ExistCpo("SX5", + "80" + cCodOri) F3 "80"
 
	/*--- Pagamento atraves de conta bancaria ---*/
	@ 60, 13 SAY	OemToAnsi("Forma de Pagamento: ")	SIZE 56, 7 OF oDlg PIXEL   
	@ 57, 72 MSCOMBOBOX oCbx VAR cFrmPag ITEMS aFrmPag SIZE 46, 7 OF oDlg PIXEL Valid !Empty(cTpCta)

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
	@ 102, 230 MSGET cInscr SIZE 54,10 OF oDlg PIXEL Valid CGC(cInscr)
	
	@ 120, 13 SAY	OemToAnsi("Histórico")	SIZE 26, 7 OF oDlg PIXEL 
	@ 117, 42 MSGET cHistor SIZE 149,10 OF oDlg PIXEL WHEN .F.

	DEFINE SBUTTON oBtn FROM 140, 220 TYPE 11 ACTION (U_A290TRB())  ENABLE OF oDlg  
	DEFINE SBUTTON FROM 140, 260 TYPE 1	ACTION (nOpca=0,oDlg:End())	ENABLE OF oDlg
	
	oBtn:cToolTip := "Alterar dados complementares do tributo"
    oCbx:Select(Val(cTpCta))     //Posiciona no item selecionado
	ACTIVATE MSDIALOG oDlg CENTERED

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
		cBco := ""
		cAge := ""
		cConta := "" 
		cTpCta   := cVar := ""

		If !ApMsgYesNo("Confirma a Forma de Pagamento ?")
			Loop
		EndIf
	EndIf        

	Exit
EndDo
/*
--------------------------------
PE FA290 eh chamado apos esse PE
--------------------------------
*/
Return(lRet)   
/*
----------------------------------------------------------------------------------------
Funcao: A290TRB													Data: 05.11.2010
Autor : Gildesio Campos
----------------------------------------------------------------------------------------
Objetivo: 	Interface para digitação de dados complementares do Tributo 
			- CHAMADO HDi No. 001893
----------------------------------------------------------------------------------------*/
User Function A290TRB()
Local nOpca     := 0
Local oDlg      

cDescNat := ""
If SED->(MsSeek(xFilial("SED")+CNAT))
	cDescNat := Alltrim(CNAT) + "-" + Alltrim(SED->ED_DESCRIC)
EndIf

While .T.	
	DEFINE MSDIALOG oDlg FROM	15,6 TO 420,597 TITLE OemToAnsi("Impostos e Taxas") PIXEL         
	@  11, 13 SAY OemToAnsi("Natureza")	SIZE	28,  7	 OF oDlg PIXEL 
	@   9, 42 MSGET cDescNat SIZE 149, 10 OF oDlg PIXEL WHEN .F.

	@  11,197 SAY OemToAnsi("Tipo Doc.")	SIZE	28,  7	 OF oDlg PIXEL  
	@   9,230 MSCOMBOBOX oCby VAR cTpDoc ITEMS aTpDoc SIZE 54, 10 OF oDlg PIXEL Valid !Empty(cTpDoc)

	@  29, 13 SAY OemToAnsi("Data p/Pagamento")	SIZE	60,  7	 OF oDlg PIXEL 
	@  26, 62 MSGET dDtPagto SIZE 75, 10 OF oDlg PIXEL 	

//	Fa290Tab(Val(cTpDoc))
	
	@  29,195 SAY OemToAnsi("Cod. Receita") SIZE	60,  7	 OF oDlg PIXEL  
	@  26,250 MSGET cCodRec SIZE 34, 10 OF oDlg PIXEL Picture "@!" Valid !Empty(cCodRec)

	/*--- Dados complementares ---*/
	@  45,  1 TO 195, 294 LABEL OemToAnsi("Dados Complementares") OF oDlg PIXEL  //75
	@  55, 13 SAY OemToAnsi("Fornecedor de Origem")	SIZE 60,  7	 OF oDlg PIXEL
    @  65, 13 MSGET cForOrig SIZE 250, 10 F3 "FORIG"  OF oDlg PIXEL                         
    	
	@  80, 13 SAY OemToAnsi("Data da Apuração")	SIZE 60,  7	 OF oDlg PIXEL 
	@  90, 13 MSGET dDataAp SIZE 75, 10 OF oDlg PIXEL 	

	@  80,160 SAY OemToAnsi("Juros")	SIZE 40,  7	 OF oDlg PIXEL 
	@  90,160 MSGET nJuros SIZE 75, 10 OF oDlg PIXEL PICTURE "@E 999,999.99"
/*----*/
	@ 105, 13 SAY OemToAnsi("Multa")	SIZE 40,  7	 OF oDlg PIXEL               
	@ 115, 13 MSGET nMulta SIZE 75, 10 OF oDlg PIXEL PICTURE "@E 999,999.99"	

	@ 105,160 SAY OemToAnsi("Correção Monetária")	SIZE 60,  7	 OF oDlg PIXEL 
	@ 115,160 MSGET nCorrec SIZE 75, 10 OF oDlg PIXEL PICTURE "@E 999,999.99"		
/*----*/
	@ 135, 13 SAY OemToAnsi("Outras Entidades")	SIZE 60,  7	 OF oDlg PIXEL 
	@ 145, 13 MSGET nOutEnt SIZE 75, 10 OF oDlg PIXEL PICTURE "@E 999,999.99"	

	@ 135,160 SAY OemToAnsi("Referencia/Identificação")	SIZE 80,  7	 OF oDlg PIXEL 
	@ 145,160 MSGET cRefer SIZE 100, 10 OF oDlg PIXEL		
/*----*/
	@ 165, 13 SAY OemToAnsi("Observação")	SIZE 40,  7	 OF oDlg PIXEL 
	@ 175, 13 MSGET cObsTr SIZE 250, 10 OF oDlg PIXEL 	
                                                                                              
	DEFINE SBUTTON FROM 190, 260 TYPE 1	ACTION (nOpca=0,oDlg:End())	ENABLE OF oDlg
    oCby:Select(Val(cTpDoc))     //Posiciona no item selecionado
	oDlg:Refresh()

	ACTIVATE MSDIALOG oDlg CENTERED
    EXIT
EndDo

Return()
/*
*/
Static Function FA290TAB(cPos)

If cPos == 1	//1-darf	
	cCodRec := Tabela("37",cCodRec,.f.)
ElseIf cPos == 2	//2-gps
	cCodRec := Tabela("60",cCodRec,.f.)
EndIf

Return
/*
If cTpDoc == "1"	//1-darf	
	@  26,250 MSGET cCodRec SIZE 34, 10 OF oDlg PIXEL Picture "@!" Valid !Empty(cCodRec) .And. ExistCpo("SX5", + "37" + cCodRec) F3 "37"
ElseIf cTpDoc == "2"	//2-gps
	@  26,250 MSGET cCodRec SIZE 34, 10 OF oDlg PIXEL Picture "@!" Valid !Empty(cCodRec) .And. ExistCpo("SX5", + "60" + cCodRec) F3 "60"
EndIf
*/
