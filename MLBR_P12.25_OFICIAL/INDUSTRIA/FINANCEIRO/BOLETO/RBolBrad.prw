#include "Protheus.ch"
#include "RWMAKE.CH"
/*
-----------------------------------------------------------------------------
Programa : RBolBrad
-----------------------------------------------------------------------------
Descricao: Boleto de Cobranca - Banco Bradesco (Via rotina de Pedido de Venda)
-----------------------------------------------------------------------------
Especifico para o Cliente
-----------------------------------------------------------------------------
Atualizações : 	Chamado:004283  "AOliveira - 03-02-2012"
				Realizado inclusão de chave de indice o SE1, para corrigir
				posicionamento de registo no SE1 na emissão do bordero.     
				
				AOliveira 08-12-2017
				Alterado a linha 320 para sempre Mv_par19-Grava Bordero = SIM
				
				AOliveira 11-09-2018
				Alteração para que a emissão via pedido de venda sejá realizado
				somente para o pedido posicionado, sem mais a necessidade de 
				incluir os parametro de "Emissão, Prefixo, Titulo No., Cliente, 
				Vencimento e Considera Filiais"
-----------------------------------------------------------------------------
*/
User Function RBOLBRAD(_cParams)
Local wnrel
Local tamanho		:= "G"
Local titulo		:= "Boleto de Cobrança - Banco Bradesco"
Local cDesc1		:= "Impressão de Boletos para Cobrança Direta."
Local cDesc2		:= ""
Local cDesc3		:= "Cobrança Bradesco - Carteira - 09"
Local cDesc4		:= ""
Local cDesc5		:= ""
Local aSays     	:= {}, aButtons := {}, nOpca := 0
  
LOCAL aParamBox := {}  
LOCAL cTitulo := "Boleto de Cobrança - Banco Bradesco"
Static aPergRet := {}            
LOCAL bOk := {|| .T.}
LOCAL aButtons := {}
LOCAL lCentered := .T.
LOCAL nPosx
LOCAL nPosy
LOCAL cLoad := "XPARAM_01"
LOCAL lCanSave := .T.
LOCAL lUserSave := .T.

Local aMvPar := {}  
Local nMv := 0

Local cMSG

Private nomeprog 	:= "RBOLBRAD"
Private nLastKey 	:= 0
Private cPerg    	:= "BOL237"
Private oPrint

Private oFontAr8	:= TFont():New("Tahoma", 8, 8,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr9	:= TFont():New("Tahoma", 9, 9,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr10	:= TFont():New("Tahoma",10,10,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr14	:= TFont():New("Tahoma",14,14,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr16	:= TFont():New("Tahoma",16,16,,.F.,,,,.T.,.F.)	//Normal

Private oFontAr8n	:= TFont():New("Tahoma", 8, 8,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr9n	:= TFont():New("Tahoma", 9, 9,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr10n	:= TFont():New("Tahoma",10,10,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr11n	:= TFont():New("Tahoma",11,11,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr12n	:= TFont():New("Tahoma",12,12,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr14n	:= TFont():New("Tahoma",14,14,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr16n	:= TFont():New("Tahoma",16,16,,.T.,,,,.T.,.F.)	//Negrito

Private oFont3 	:= TFont():New("Tahoma",,14,,.T.,,,,.T.,.F. )	//Negrito

Private aTitulos := {}

Private aNotaBol := {SC5->C5_FILIAL,SC5->C5_NOTA, SC5->C5_CLIENTE}

Default _cParams := ""

//Backup do Parametros Padrao
For nMv := 1 To 40
   aAdd( aMvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
Next nMv

oPrint:= TMSPrinter():New()
oPrint:SetPortrait()
oPrint:SetPaperSize(9)

dbSelectArea("SEA")
dbSetOrder(1)
dbSelectArea("SA6")
dbSetOrder(1)
dbSelectArea("SEE")
dbSetOrder(1)
dbSelectArea("SE1")
dbSetOrder(1)

cString := "SE1"
wnrel   := "RBOLBRA"
     
If _cParams == "A"
    
	If !Empty(SC5->C5_NOTA)
	    
		/*
		AADD(aSays,cDesc1)
		AADD(aSays,cDesc2)
		AADD(aSays,cDesc3)
		AADD(aSays,cDesc4)
		
		AADD(aButtons, { 5,.T.,{|| XPARAM() } } )
		AADD(aButtons, { 1,.T.,{|| nOpca := 1, FechaBatch() }} )
		AADD(aButtons, { 2,.T.,{|| nOpca := 0, FechaBatch() }} )
		
		FormBatch( Titulo, aSays, aButtons,, 160 )
			        	
		If nOpca == 1
			RptStatus({|lEnd| RBol02(@lEnd,wnRel,cString,_cParams)},Titulo)		
			oPrint:Preview()  		// Visualizar antes de enviar para impressora				
		EndIf   
		*/

		aAdd(aParamBox,{1,"% Multa Por Atraso  ",2.00  ,"@E 999.99", ,"" ,".F.",10 ,.F.})
		aAdd(aParamBox,{1,"Banco               ",Space(TamSx3("A6_COD")[1]),"@!","","SA6","",0,.F.})
		aAdd(aParamBox,{1,"Agencia             ",Space(TamSx3("A6_AGENCIA")[1]),"@!","","","",0,.F.})
		aAdd(aParamBox,{1,"Conta               ",Space(TamSx3("A6_NUMCON")[1]),"@!","","","",0,.F.})
		aAdd(aParamBox,{1,"Sub-Conta           ",Space(TamSx3("EE_SUBCTA")[1]),"@!","","","",0,.F.})
		aAdd(aParamBox,{2,"Grava Bordero       ","Sim",{"Sim","Não"},50,"",.F.})
		                                         
		//If ParamBox(aParamBox,"Parametros",@aRet)
		lRet := ParamBox(aParamBox, cTitulo, aPergRet, bOk, aButtons, lCentered, nPosx,nPosy, /*oMainDlg*/ , cLoad, lCanSave, lUserSave)
		                                                                                    
		If lRet

			_cCODIGO  := PadR(Alltrim(Mv_Par02),TamSx3("EE_CODIGO")[1])
			_cAGENCIA := PadR(Alltrim(Mv_Par03),TamSx3("EE_AGENCIA")[1])
			_cCONTA   := PadR(Alltrim(Mv_Par04),TamSx3("EE_CONTA")[1])
			_cSUBCTA  := PadR(Alltrim(Mv_Par05),TamSx3("EE_SUBCTA")[1])		   
			DbSelectArea("SEE")
			SEE->(DbSetOrder(1)) //EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA						
			If !(SEE->(DBSeek(xFilial("SEE") + _cCODIGO + _cAGENCIA + _cCONTA + _cSUBCTA))) 
				
				cMSG := "Problema:"+CRLF
				cMSG += "  Parametros de Bancos nao encontrados para o "+CRLF
				cMSG += "  Banco: "+_cCODIGO +CRLF
				cMSG += "  Agencia: "+_cAGENCIA +CRLF
				cMSG += "  Conta: "+_cCONTA +CRLF
				cMSG += "  Sub-Conta: "+_cSUBCTA +CRLF
			
				Aviso("Atenção", cMSG , {"OK"} )
				Return(.F.)
			EndIf

			RptStatus({|lEnd| RBol02(@lEnd,wnRel,cString,_cParams)},Titulo)		
			oPrint:Preview()  		// Visualizar antes de enviar para impressora			

		Endif

    Else
		ApMsgAlert("Não existe Nota para o pedido ( "+SC5->C5_NUM+" )")    	
    EndIf
    
Else

	RBolPerg()
	Pergunte(cPerg,.F.)
	
	AADD(aSays,cDesc1)
	AADD(aSays,cDesc2)
	AADD(aSays,cDesc3)
	AADD(aSays,cDesc4)
	
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	AADD(aButtons, { 1,.T.,{|| nOpca := 1, FechaBatch() }} )
	AADD(aButtons, { 2,.T.,{|| nOpca := 0, FechaBatch() }} )
	
	FormBatch( Titulo, aSays, aButtons,, 160 )
	        	
	If nOpca == 0
		If FunName() == 'MATA410'
			Pergunte('MTA410',.F.)
		EndIf
		Return
	EndIf
	
	If nLastKey = 27
		dbClearFilter()
		If FunName() == 'MATA410'
			Pergunte('MTA410',.F.)
		EndIf
		Return
	Endif
	
	RptStatus({|lEnd| RProcBol(@lEnd,wnRel,cString,_cParams)},Titulo)
	
	oPrint:Preview()  		// Visualizar antes de enviar para impressora
	
	If FunName() == 'MATA410'
		Pergunte('MTA410',.F.)
	EndIf
EndIf

//Restaurar Parametros Padrao
For nMv := 1 To Len( aMvPar )
    &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
Next nMv

Return

/*
----------------------------------------------------------------------
Funcao   : RProcBol()
Descricao: Processamento do Boleto de Cobrança
----------------------------------------------------------------------*/
Static Function RProcBol(lEnd,wnRel,cString,_cParams) 

Local lSeekSEE := .f.


Private cNReduz  := "Banco Bradesco"
Private cLocalPag:= "Pagável Preferencialmente na Rede Bradesco"
Private cUsoBco  := "9004"
Private cCIP     := "000"
Private cSacador := "", cInstr1 := "", cInstr2 := ""
Private cIdBco   := "237-2"
Private cMoeda   := '9'
Private cCarteira:= "09"
//Private cDescCrt := "COBRANCA REGISTRADA"
Private cAgencia := "" 	//SA6->(A6_AGENCIA+A6_X_DIGAG)
Private cConta   := "" //SA6->A6_NUMCON
Private cDvCC    := "" //SA6->A6_X_DIGCT
Private cCodCed  := ""
Private cNN      := "", cDvNN := ""
Private cBanco   := "237"
Private cParcela := Space(Len(SE1->E1_PARCELA))
Private cTipo    := "NF"+Space((Len(SE1->E1_TIPO)-2))
Private cLogoBco := "\system\237_brad.jpg"

Private cCodBar,cLinDig
Private cFator, dBase, cImpNNum, cLivre
Private cCNPJCli, cEndCli, cBairroCli, cCepCli, cMunCli, cUFCli
Private cDvCodBar
Private cQuery := ""
Private cQuery1:= ""
Private	cNewLinDig
Private	cCBLD
Private aTitulos := {}
Private	lGeraBor := .T. //AOliveira aplicando valor a variavel  --- 20180704
Private nSldRet	:= 0
/*
--------------------------------------------
Parametros da Rotina de Impressao do Boleto
--------------------------------------------
Mv_par01-Da Emissão
Mv_par02-Ate Emissão
Mv_par03-Do Prefixo
Mv_par04-Ate Prefixo
Mv_par05-Do Titulo No.
Mv_par06-Ate Titulo No.
Mv_par07-Do Cliente
Mv_par08-Ate Cliente
Mv_par09-% Multa Por Atraso
Mv_par10-Banco
Mv_par11-Agencia
Mv_par12-Conta
Mv_par13-Sub-Conta
Mv_par14-Do Vencimento
Mv_par15-Ate Vencimento
Mv_par16-Considera Filiais
Mv_par17-Da Filial
Mv_par18-Ate Filial
Mv_par19-Grava Bordero
-------------------------------------------
pesquisa conta bancaria
-------------------------------------------*/
cQuery1 := "SELECT * FROM "
cQuery1 += RetSqlName("SA6")+" SA6 "
cQuery1 += " WHERE "
cQuery1 += " SA6.A6_FILIAL  = '"+xFilial("SA6")+"' AND "
cQuery1 += " SA6.A6_COD = '" + Mv_Par10 + "' AND "
cQuery1 += " SA6.A6_AGENCIA = '" + Mv_Par11 + "' AND "
cQuery1 += " SA6.A6_NUMCON = '" + Mv_Par12 + "' AND "
cQuery1 += " SA6.D_E_L_E_T_ = ''"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TRB",.F.,.T.)

cSA6Agenc := Alltrim(TRB->A6_AGENCIA)		   		//Alltrim(TRB->A6_AGENCIA)+Alltrim(TRB->A6_X_DIGAG)
cSA6Conta := Alltrim(TRB->A6_NUMCON)		   		//Alltrim(TRB->A6_NUMCON) +Alltrim(TRB->A6_X_DIGCT)
cAgencia  := Substr(cSA6Agenc,1,4)					//Alltrim(TRB->A6_AGENCIA)
cConta    := Substr(cSA6Conta,1,Len(cSA6Conta)-1)	//Alltrim(TRB->A6_NUMCON)
cDvCC     := Right(cSA6Conta,1)						//Alltrim(TRB->A6_X_DIGCT)
/*
-------------------------------------------
Pesquisa Titulo conforme parametros
-------------------------------------------*/
cQuery := " SELECT * FROM "
cQuery += RetSqlName("SE1")+" SE1 "
cQuery += " WHERE "
/*
-----------------------------
Considera Filiais
-----------------------------*/
If Mv_Par16 == 1
	cQuery += " SE1.E1_FILIAL BETWEEN '"+Mv_Par17 + "' AND '" + Mv_Par18 + "' AND "
Else
	cQuery += " SE1.E1_FILIAL  = '"+xFilial("SE1")+"' AND "
EndIf
cQuery += " SE1.E1_TIPO IN ('NF','FT') AND "
cQuery += " SE1.E1_SALDO > 0 AND "
cQuery += " SE1.E1_EMISSAO BETWEEN '" + DtoS(Mv_Par01) + "' AND '" + DtoS(Mv_Par02) + "' AND "
cQuery += " SE1.E1_PREFIXO BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "' AND "
cQuery += " SE1.E1_NUM BETWEEN '" + Mv_Par05 + "' AND '" + Mv_Par06 + "' AND "
cQuery += " SE1.E1_CLIENTE BETWEEN '" + Mv_Par07 + "' AND '" + Mv_Par08 + "' AND "

If _cParams == "A"
	cQuery += " SE1.E1_VENCTO BETWEEN	 '" + DtoS(Mv_Par14) + "' AND '" + DtoS(Mv_Par15) + "' AND "
EndIf

cQuery += " SE1.E1_BAIXA = '' AND "
cQuery += " SE1.E1_NATUREZ <> '2008' AND "			//CHAMADO HD No. 000.221
cQuery += " SE1.E1_NATUREZ <> '2005' AND "			//CHAMADO HD No. 000.245
cQuery += " SE1.D_E_L_E_T_ = ''"
cQuery += " ORDER BY SE1.E1_FILIAL,SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)

dbSelectArea("TMP")
SetRegua(RecCount())
dbGoTop()

While TMP->(!Eof())
	If Mv_Par10 != cBanco
		ApMsgAlert("Banco incorreto! Verifique os parametros da rotina.")
		Exit
	EndIf
	
	lCliOk := SA1->(MsSeek(xFilial("SA1") + TMP->(E1_CLIENTE+E1_LOJA)))
	
	If RetPessoa(SA2->A2_CGC) == "F"
		cCNPJCli := Transform(SA1->A1_CGC,"@R 999.999.999-99")
	Else
		cCNPJCli := Transform(SA1->A1_CGC,"@R 99.999.999/9999-99")
	Endif
	cEndCli		:= SA1->A1_END
	cBairroCli	:= SA1->A1_BAIRRO
	cCepCli		:= SA1->A1_CEP
	cMunCli		:= SA1->A1_MUN
	cUFCli		:= SA1->A1_EST
	
	While TMP->(!Eof()) .And. TMP->(E1_CLIENTE + E1_LOJA) == SA1->(A1_COD + A1_LOJA)
		If !Empty(TMP->E1_PORTADO)
			If TMP->E1_PORTADO != Mv_Par10   //Titulo em Cobranca em outro Banco
				TMP->(dbSkip())
				Loop
			Else
				If  TMP->(E1_AGEDEP+E1_CONTA)!= TRB->(A6_AGENCIA+A6_NUMCON)	//Titulo em Cobranca em outro Ag/Conta
					TMP->(dbSkip())
					Loop
				EndIf
			EndIf
		EndIf
		/*		----------------------------------
		Codigo do Cedente
		----------------------------------*/
		cCodCed := Substr(cSA6Agenc,1,Len(cSA6Agenc)-1) + "-"+Right(Alltrim(cSA6Agenc),1)+" / " + cConta + "-" + cDvCC			//Alltrim(TRB->A6_AGENCIA)+"-"+Alltrim(TRB->A6_X_DIGAG)
		//		cCodCed += " / " + cConta + "-" + cDvCC				//Alltrim(TRB->A6_NUMCON)+"-"+Alltrim(TRB->A6_X_DIGCT)
		/*		----------------------------------
		Calculo do Fator de Vencimento
		----------------------------------*/
		dBase   := CtoD("07/10/1997")   //-- conforme layout BRADESCO
		cFator  := STR(INT(StoD(TMP->E1_VENCTO) - dBase),4)
		/*		----------------------------------
		Calculo do Nosso Numero
		----------------------------------*/
		DbSelectArea("SEE")
		SEE->(DbSetOrder(1))
		lSeekSEE := SEE->(DbSeek(xFilial("SEE") + Mv_Par10 + Mv_Par11 + Mv_Par12 + Mv_Par13))
		//SEE->(MsSeek(xFilial("SEE") + Mv_Par10 + Mv_Par11 + Mv_Par12 + Mv_Par13))
		
		If Empty(TMP->E1_PORTADO)
			If Empty(SEE->EE_FAXATU)
				DbSelectArea("SEE")
				RecLock("SEE",.F.)
				SEE->EE_FAXATU := Alltrim(SEE->EE_FAXINI)
				SEE->(MsUnLock())
			EndIf
			//			nNumfaix := Val(Alltrim(SEE->EE_FAXATU)) + 1
			//			cNN      := StrZero(nNumfaix,11)
			                       
			DbSelectArea("SEE")
			RecLock("SEE",.F.)
			nNumfaix := Val(Alltrim(SEE->EE_FAXATU)) + 1     //26/05/10-Chamado No. - Sentenca colocada nesse ponto pois da forma anterior pode em algumas situacoes
			cNN      := StrZero(nNumfaix,11)                 //gerar NOSSO NUMERO duplicado tornando o boleto invalido.
			
			SEE->EE_FAXATU := cNN
			SEE->(MsUnLock())
			
			cDvNN := CalcDvNN()
			lGeraBor := .T.
		Else
			/*	-----------------------------
			Reimpressao do Boleto
			-----------------------------*/
			lGeraBor := .F.
			
			cNN   := Substr(Alltrim(TMP->E1_NUMBCO),1,11)
			cDvNN := Right(Alltrim(TMP->E1_NUMBCO),1)
		EndIf
		
		nSldRet	:= TMP->E1_SALDO
		
		/*----------------------------------
		Calculo do DV Codigo de Barras
		----------------------------------*/
		cLivre   := StrZero(Val(cAgencia),4) + cCarteira + cNN +  StrZero(Val(cConta),7)+ "0"
		cValor   := STRZERO(nSldRet * 100,10)
		cDvCodBar:= CalcCodBar(cBanco,cMoeda,cFator,cValor,cLivre)
		cCodBar  := cBanco + cMoeda + cDvCodBar + cFator + cValor + cLivre
		/*----------------------------------
		Calculo da Linha Digitavel
		----------------------------------*/
		cLinDig	:= CalcLinDig(cBanco,cMoeda,cFator,cValor,cLivre)
		/*		----------------------------------
		Atualiza Dados Bancarios do Titulo
		----------------------------------*/
		//		(1)-E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		
		//		SE1->(MsSeek(xFilial("SE1")+TMP->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
		SE1->(MsSeek(TMP->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
		If .f. //Empty(SE1->E1_PORTADO)
			RecLock("SE1",.F.)
			SE1->E1_NUMBCO	:= cNN + cDvNN
			SE1->E1_PORTADO := Mv_Par10	  			//Banco Portador
			SE1->E1_AGEDEP  := cSA6Agenc           	//Agencia
			SE1->E1_CONTA   := cSA6Conta			//Conta Corrente para Credito
			SE1->E1_SITUACA := '1'					//Cobranca
			SE1->E1_CODBAR  := cCodBar             	//Codigo de Barras
			SE1->(MsUnLock())
			
			lGeraBor := .T.
		EndIf
		/*	-------------------------------------
		Adicona titulo ao bordero de Cobranca
		-------------------------------------*/
		If .T. //Mv_Par19 == 1 //Sim ///AOliveira solicitado pelo Sr. Willer 08-12-2017
			If lGeraBor
				//AOliveira -- 03-02-2012 -----Realizado inclusão do campo E1_TIPO
				Aadd(aTitulos, {SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_VENCTO,;
				SE1->E1_VALOR,SE1->E1_NUMBCO,SE1->E1_PORTADO,SE1->E1_AGEDEP ,SE1->E1_CONTA,SE1->E1_FILIAL,SE1->E1_TIPO})
				lGeraBor := .F.
			EndIf
		EndIf
		/*		----------------------------------
		Impressao do Boleto Santander
		----------------------------------*/
		RImpBolBra()
		
		TMP->(dbSkip())
	EndDo
EndDo
TMP->(dbCloseArea())
TRB->(dbCloseArea())
/*
---------------------------
Grava Bordero de Cobranca
---------------------------*/
If Len(aTitulos) > 0
	GravaBor()
EndIf
Return 


//
//
//
/*
----------------------------------------------------------------------
Funcao   : RBol02()
Descricao: Processamento do Boleto de Cobrança (via Pedido de Venda)
----------------------------------------------------------------------*/
Static Function RBol02(lEnd,wnRel,cString,_cParams)

Local _cCODIGO  := ""
Local _cAGENCIA := ""
Local _cCONTA   := ""
Local _cSUBCTA  := ""

Local lSeekSEE := .F.
Private cNReduz  := "Banco Bradesco"
Private cLocalPag:= "Pagável Preferencialmente na Rede Bradesco"
Private cUsoBco  := "9004"
Private cCIP     := "000"
Private cSacador := "", cInstr1 := "", cInstr2 := ""
Private cIdBco   := "237-2"
Private cMoeda   := '9'
Private cCarteira:= "09"
//Private cDescCrt := "COBRANCA REGISTRADA"
Private cAgencia := "" 	//SA6->(A6_AGENCIA+A6_X_DIGAG)
Private cConta   := "" //SA6->A6_NUMCON
Private cDvCC    := "" //SA6->A6_X_DIGCT
Private cCodCed  := ""
Private cNN      := "", cDvNN := ""
Private cBanco   := "237"
Private cParcela := Space(Len(SE1->E1_PARCELA))
Private cTipo    := "NF"+Space((Len(SE1->E1_TIPO)-2))
Private cLogoBco := "\system\237_brad.jpg"

Private cCodBar,cLinDig
Private cFator, dBase, cImpNNum, cLivre
Private cCNPJCli, cEndCli, cBairroCli, cCepCli, cMunCli, cUFCli
Private cDvCodBar
Private cQuery := ""
Private cQuery1:= ""
Private	cNewLinDig
Private	cCBLD
Private aTitulos := {}
Private	lGeraBor := .T. //AOliveira aplicando valor a variavel  --- 20180704
Private nSldRet	:= 0
/*
--------------------------------------------
Parametros da Rotina de Impressao do Boleto
--------------------------------------------
Mv_par01-% Multa Por Atraso
Mv_par02-Banco
Mv_par03-Agencia
Mv_par04-Conta
Mv_par05-Sub-Conta
Mv_par06-Grava Bordero
-------------------------------------------
pesquisa conta bancaria
-------------------------------------------*/
cQuery1 := "SELECT * FROM "
cQuery1 += RetSqlName("SA6")+" SA6 "
cQuery1 += " WHERE "
cQuery1 += " SA6.A6_FILIAL  = '"+xFilial("SA6")+"' AND "
cQuery1 += " SA6.A6_COD = '" + Mv_Par02 + "' AND "
cQuery1 += " SA6.A6_AGENCIA = '" + Mv_Par03 + "' AND "
cQuery1 += " SA6.A6_NUMCON = '" + Mv_Par04 + "' AND "
cQuery1 += " SA6.D_E_L_E_T_ = ''"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TRB",.F.,.T.)

cSA6Agenc := Alltrim(TRB->A6_AGENCIA)		   		//Alltrim(TRB->A6_AGENCIA)+Alltrim(TRB->A6_X_DIGAG)
cSA6Conta := Alltrim(TRB->A6_NUMCON)		   		//Alltrim(TRB->A6_NUMCON) +Alltrim(TRB->A6_X_DIGCT)
cAgencia  := Substr(cSA6Agenc,1,4)					//Alltrim(TRB->A6_AGENCIA)
cConta    := Substr(cSA6Conta,1,Len(cSA6Conta)-1)	//Alltrim(TRB->A6_NUMCON)
cDvCC     := Right(cSA6Conta,1)						//Alltrim(TRB->A6_X_DIGCT)
/*
-------------------------------------------
Pesquisa Titulo conforme parametros
-------------------------------------------*/
cQuery := " SELECT * FROM "
cQuery += RetSqlName("SE1")+" SE1 "
cQuery += " WHERE "
/*
-----------------------------
Considera Filiais
-----------------------------*/
cQuery += " SE1.E1_FILIAL  = '"+xFilial("SE1")+"' AND "
cQuery += " SE1.E1_TIPO IN ('NF','FT') AND "
cQuery += " SE1.E1_SALDO > 0 AND "
cQuery += " SE1.E1_PREFIXO = '" + SC5->C5_FILIAL + "' AND "
cQuery += " SE1.E1_NUM = '" + SC5->C5_NOTA + "' AND "
cQuery += " SE1.E1_CLIENTE = '" + SC5->C5_CLIENTE + "' AND "
cQuery += " SE1.E1_BAIXA = '' AND "
cQuery += " SE1.E1_NATUREZ <> '2008' AND "			//CHAMADO HD No. 000.221
cQuery += " SE1.E1_NATUREZ <> '2005' AND "			//CHAMADO HD No. 000.245
cQuery += " SE1.D_E_L_E_T_ = ''"
cQuery += " ORDER BY SE1.E1_FILIAL,SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)

DbSelectArea("TMP")              
_nQtde := 0                                
TMP->(DbGoTop())
TMP->( dBEval({|| _nQtde++}) )  
SetRegua(RecCount())
TMP->(dbGoTop())

If _nQtde > 0
	While TMP->(!Eof())
		If Mv_Par02 != cBanco
			ApMsgAlert("Banco incorreto! Verifique os parametros da rotina.")
			Exit
		EndIf
		
		lCliOk := SA1->(MsSeek(xFilial("SA1") + TMP->(E1_CLIENTE+E1_LOJA)))
		
		If RetPessoa(SA2->A2_CGC) == "F"
			cCNPJCli := Transform(SA1->A1_CGC,"@R 999.999.999-99")
		Else
			cCNPJCli := Transform(SA1->A1_CGC,"@R 99.999.999/9999-99")
		Endif
		cEndCli		:= SA1->A1_END
		cBairroCli	:= SA1->A1_BAIRRO
		cCepCli		:= SA1->A1_CEP
		cMunCli		:= SA1->A1_MUN
		cUFCli		:= SA1->A1_EST
		
		While TMP->(!Eof()) .And. TMP->(E1_CLIENTE + E1_LOJA) == SA1->(A1_COD + A1_LOJA)
			If !Empty(TMP->E1_PORTADO)
				If TMP->E1_PORTADO != Mv_Par02   //Titulo em Cobranca em outro Banco
					TMP->(dbSkip())
					Loop
				Else
					If  TMP->(E1_AGEDEP+E1_CONTA)!= TRB->(A6_AGENCIA+A6_NUMCON)	//Titulo em Cobranca em outro Ag/Conta
						TMP->(dbSkip())
						Loop
					EndIf
				EndIf
			EndIf
			/*		----------------------------------
			Codigo do Cedente
			----------------------------------*/
			cCodCed := Substr(cSA6Agenc,1,Len(cSA6Agenc)-1) + "-"+Right(Alltrim(cSA6Agenc),1)+" / " + cConta + "-" + cDvCC			//Alltrim(TRB->A6_AGENCIA)+"-"+Alltrim(TRB->A6_X_DIGAG)
			//		cCodCed += " / " + cConta + "-" + cDvCC				//Alltrim(TRB->A6_NUMCON)+"-"+Alltrim(TRB->A6_X_DIGCT)
			/*		----------------------------------
			Calculo do Fator de Vencimento
			----------------------------------*/
			dBase   := CtoD("07/10/1997")   //-- conforme layout BRADESCO
			cFator  := STR(INT(StoD(TMP->E1_VENCTO) - dBase),4)
			/*		----------------------------------
			Calculo do Nosso Numero
			----------------------------------*/
			DbSelectArea("SEE")
			SEE->(DbSetOrder(1)) //EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA
			
			_cCODIGO  := PadR(Alltrim(Mv_Par02),TamSx3("EE_CODIGO")[1])
			_cAGENCIA := PadR(Alltrim(Mv_Par03),TamSx3("EE_AGENCIA")[1])
			_cCONTA   := PadR(Alltrim(Mv_Par04),TamSx3("EE_CONTA")[1])
			_cSUBCTA  := PadR(Alltrim(Mv_Par05),TamSx3("EE_SUBCTA")[1])
			
			lSeekSEE := SEE->(DBSeek(xFilial("SEE") + _cCODIGO + _cAGENCIA + _cCONTA + _cSUBCTA))
             
			If !(lSeekSEE)
				Return(.F.)
			EndIf
			
			If Empty(TMP->E1_PORTADO)
				If Empty(SEE->EE_FAXATU)
					DbSelectArea("SEE")
					RecLock("SEE",.F.)
					SEE->EE_FAXATU := Alltrim(SEE->EE_FAXINI)
					SEE->(MsUnLock())
				EndIf
				//			nNumfaix := Val(Alltrim(SEE->EE_FAXATU)) + 1
				//			cNN      := StrZero(nNumfaix,11)
				
				DbSelectArea("SEE")
				RecLock("SEE",.F.)
				nNumfaix := Val(Alltrim(SEE->EE_FAXATU)) + 1     //26/05/10-Chamado No. - Sentenca colocada nesse ponto pois da forma anterior pode em algumas situacoes
				cNN      := StrZero(nNumfaix,11)                 //gerar NOSSO NUMERO duplicado tornando o boleto invalido.
				
				SEE->EE_FAXATU := cNN
				SEE->(MsUnLock())
				
				cDvNN := CalcDvNN()
				lGeraBor := .T.
			Else
				/*	-----------------------------
				Reimpressao do Boleto
				-----------------------------*/
				lGeraBor := .F.
				
				cNN   := Substr(Alltrim(TMP->E1_NUMBCO),1,11)
				cDvNN := Right(Alltrim(TMP->E1_NUMBCO),1)
			EndIf
			
			nSldRet	:= TMP->E1_SALDO
			
			/*----------------------------------
			Calculo do DV Codigo de Barras
			----------------------------------*/
			cLivre   := StrZero(Val(cAgencia),4) + cCarteira + cNN +  StrZero(Val(cConta),7)+ "0"
			cValor   := STRZERO(nSldRet * 100,10)
			cDvCodBar:= CalcCodBar(cBanco,cMoeda,cFator,cValor,cLivre)
			cCodBar  := cBanco + cMoeda + cDvCodBar + cFator + cValor + cLivre
			/*----------------------------------
			
			----------------------------------*/
			cLinDig	:= CalcLinDig(cBanco,cMoeda,cFator,cValor,cLivre)
			/*		----------------------------------
			Atualiza Dados Bancarios do Titulo
			----------------------------------*/
			//		(1)-E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			
			//		SE1->(MsSeek(xFilial("SE1")+TMP->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
			DbSelectArea("SE1")
			SE1->(DbSeek(TMP->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
			If Empty(SE1->E1_PORTADO)
				RecLock("SE1",.F.)
				SE1->E1_NUMBCO	:= cNN + cDvNN
				SE1->E1_PORTADO := Mv_Par02	  			//Banco Portador
				SE1->E1_AGEDEP  := cSA6Agenc           	//Agencia
				SE1->E1_CONTA   := cSA6Conta			//Conta Corrente para Credito
				SE1->E1_SITUACA := '1'					//Cobranca
				SE1->E1_CODBAR  := cCodBar             	//Codigo de Barras
				SE1->(MsUnLock())
				
				lGeraBor := .T.
			EndIf
			/*	-------------------------------------
			Adicona titulo ao bordero de Cobranca
			-------------------------------------*/
			If .T. //Mv_Par19 == 1 //Sim ///AOliveira solicitado pelo Sr. Willer 08-12-2017
				If lGeraBor
					//AOliveira -- 03-02-2012 -----Realizado inclusão do campo E1_TIPO
					Aadd(aTitulos, {SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_VENCTO,;
					                SE1->E1_VALOR,SE1->E1_NUMBCO,SE1->E1_PORTADO,SE1->E1_AGEDEP ,SE1->E1_CONTA,SE1->E1_FILIAL,SE1->E1_TIPO})
					lGeraBor := .F.
				EndIf
			EndIf
			/*		----------------------------------
			Impressao do Boleto Santander
			----------------------------------*/
			RImpBolBra(_cParams)
			
			TMP->(dbSkip())
		EndDo
	EndDo
Else
	ApMsgAlert("Não existe titulo para Nota ( "+SC5->C5_NOTA+" )")
EndIf                                           

TMP->(dbCloseArea())
TRB->(dbCloseArea())
/*
---------------------------
Grava Bordero de Cobranca
---------------------------*/
If Len(aTitulos) > 0
	GravaBor()
EndIf
Return
//
//
//



/*
----------------------------------------------------------------------
Funcao   : RImpBolBra()
Descricao: Impressão do Boleto de Cobrança
----------------------------------------------------------------------*/
Static Function RImpBolBra(_cParams)
Local nLin    := 220
Local nColBIni:= 120
Local nColBFim:= 2300
Local cCgc := "60398914000184" //If(Empty(SM0->M0_CGC),"00000000000000",SM0->M0_CGC)
Local cNome:= SM0->M0_NOMECOM		//If(Empty(SM0->M0_NOMECOM),"NOME DO CEDENTE",SM0->M0_NOMECOM)
Local cDataEmi := GravaData(StoD(TMP->E1_EMISSAO),.f.,5)
Local cDataVenc:= GravaData(StoD(TMP->E1_VENCTO),.f.,5)
Local cDataProc:= GravaData(dDataBase,.f.,5)	//ddmmaaa
Local nCnt
                                   
Default _cParams := ""

cDataEmi  := Substr(cDataEmi,1,2)+"/"+Substr(cDataEmi,3,2)+"/"+Substr(cDataEmi,5,4)
cDataVenc := Substr(cDataVenc,1,2)+"/"+Substr(cDataVenc,3,2)+"/"+Substr(cDataVenc,5,4)
cDataProc := Substr(cDataProc,1,2)+"/"+Substr(cDataProc,3,2)+"/"+Substr(cDataProc,5,4)

For nCnt := 1 To 2
	oPrint:SayBitmap(nLin,120,cLogoBco,275,90)
	nLin += 20
	oPrint:Say(nLin,460,"| " + cIdBco + " |",oFont3)     //2256 - 440
	nLin += 6
	
	If nCnt > 1
		oPrint:Say(nlin,720,cLinDig,oFontAr14)
	Endif
	nLin += 74
	oPrint:Line(nLin,nColbIni,nLin,nColbFim)
	oPrint:Line(nLin,1650,nLin+100,1650)
	
	oPrint:Say(nLin,120,"Local de Pagamento:",oFontAr8)
	oPrint:Say(nLin+30,120, cLocalPag,oFontAr10n)
	oPrint:Say(nLin,1660,"Vencimento  ",oFontAr8)
	oPrint:Say(nLin+30,1680,cDataVenc,oFontAr10n)
	nLin += 70	//2450
	
	oPrint:Line(nLin,nColbIni,nLin,nColbFim)
	oPrint:Line(nLin,1650,nLin+70,1650)		//Traco vertical
	
	oPrint:Say(nLin,120,"Beneficiário",oFontAr8)
	oPrint:Say(nLin,1660,"Agência/Código Beneficiário",oFontAr8)
	oPrint:Say(nLin+30,120,Alltrim(cNome),oFontAr10)
	oPrint:Say(nLin+30,1200,"CNPJ: "+Transform(cCgc,"@R 99.999.999/9999-99"),oFontAr10)
	oPrint:Say(nLin+30,1680,cCodCed,oFontAr10) 	//Agencia / Codigo Cedente
	nLin += 70	//2520
	
	oPrint:Line(nLin,nColbIni,nLin,nColbFim)
	oPrint:Line(nLin, 410,nLin+70, 410)		//Traco vertical //Col 380
	oPrint:Line(nLin, 720,nLin+70, 720)		//Traco vertical
	oPrint:Line(nLin, 980,nLin+70, 980)		//Traco vertical
	oPrint:Line(nLin,1180,nLin+70,1180)		//Traco vertical
	oPrint:Line(nLin,1650,nLin+70,1650)		//Traco vertical
	
	oPrint:Say(nLin, 120,"Data do Documento",oFontAr8)
	oPrint:Say(nLin, 420,"No.Documento",oFontAr8) 	//390
	oPrint:Say(nLin, 730,"Espécie Documento",oFontAr8)
	oPrint:Say(nLin, 990,"Aceite",oFontAr8)
	oPrint:Say(nLin,1190,"Data Processamento",oFontAr8)
	oPrint:Say(nLin,1660,"Nosso Número",oFontAr8)
	nLin += 30	//2550
	
	oPrint:Say(nLin, 150,cDataEmi,oFontAr10)
	oPrint:Say(nLin, 440,TMP->E1_PREFIXO + " " +TMP->E1_NUM + " " + TMP->E1_PARCELA,oFontAr10)
	oPrint:Say(nLin, 800,"DP",oFontAr10)
	oPrint:Say(nLin,1060,"N",oFontAr10)
	oPrint:Say(nLin,1280,cDataProc,oFontAr10)
	oPrint:Say(nLin,1700,cCarteira+"/"+cNN+"-"+cDvNN,oFontAr10)
	nLin += 40 //2590
	
	oPrint:Line(nLin,nColbIni,nLin,nColbFim)
	oPrint:Line(nLin, 190,nLin+10, 190)		//Traco vertical
	oPrint:Line(nLin, 350,nLin+70, 350)		//Traco vertical
	oPrint:Line(nLin, 410,nLin+70, 410)		//Traco vertical
	oPrint:Line(nLin, 580,nLin+70, 580)		//Traco vertical
	oPrint:Line(nLin, 720,nLin+70, 720)		//Traco vertical
	oPrint:Line(nLin,1080,nLin+40,1080)		//Traco vertical
	oPrint:Say(nLin+30,1073,"X",oFontAr10)
	oPrint:Line(nLin,1650,nLin+70,1650)		//Traco vertical
	
	oPrint:Say(nLin, 120,"Uso do Banco",oFontAr8)
	oPrint:Say(nLin, 360,"CIP",oFontAr8)
	oPrint:Say(nLin, 440,"Carteira",oFontAr8)
	oPrint:Say(nLin, 610,"Moeda",oFontAr8)
	oPrint:Say(nLin, 730,"Quantidade",oFontAr8)
	oPrint:Say(nLin,1090,"Valor",oFontAr8)
	oPrint:Say(nLin,1660,"(=) Valor do Documento",oFontAr8)
	nLin += 30	//2620
	
	oPrint:Say(nLin, 150,cUsoBco,oFontAr8)
	oPrint:Say(nLin, 360,cCIP,oFontAr8)
	oPrint:Say(nLin, 460,cCarteira,oFontAr8)
	oPrint:Say(nLin, 630,"R$",oFontAr9) // Especie Moeda
	
	nSldRet	:= TMP->E1_SALDO
	oPrint:Say(nLin,1730,Transform(nSldRet,"@E 999,999,999.99"),oFontAr10n) // Valor do documento
	nLin += 40	//2660
	
	oPrint:Line(nLin,nColbIni,nLin,nColbFim)
	oPrint:Say(nLin, 120,"Instruções",oFontAr8) // Instrucoes para o banco
	oPrint:Line(nLin,1650,nLin+70,1650)		//Traco vertical
	oPrint:Say(nLin,1660,"(-) Desconto",oFontAr8) // (-)Desconto
	nLin += 70	//2730
	
	If Empty(_cParams) 
		If Mv_Par09 > 0    //A PERGUNTA TEM Q ESTAR PREENCHIDA PARA SAIR VALOR MULTA - WILLER
			//Imprime o valor da multa em R$
			nMulta := (nSldRet * (Mv_Par09 / 100))
			oPrint:Say(nLin, 120,"Após vencimento multa de R$ "+Alltrim(Transform(nMulta,"@E 999,999.99")),oFontAr8) //WILLER HDI 004612
			
			//Imprime o valor da multa em %
			//nMulta := Mv_Par09
			//oPrint:Say(nLin, 120,"Após vencimento cobrar Multa de "+Alltrim(Transform(nMulta,"@E 999.99"))+" %",oFontAr10)
		EndIf  
	Else
		If Mv_Par01 > 0    //A PERGUNTA TEM Q ESTAR PREENCHIDA PARA SAIR VALOR MULTA - WILLER
			//Imprime o valor da multa em R$
			nMulta := (nSldRet * (Mv_Par01 / 100))
			oPrint:Say(nLin, 120,"Após vencimento multa de R$ "+Alltrim(Transform(nMulta,"@E 999,999.99")),oFontAr8) //WILLER HDI 004612
		EndIf  	
	EndIf
	
	oPrint:Line(nLin,1650,nLin,nColbFim)
	oPrint:Line(nLin,1650,nLin+70,1650)		//Traco vertical
	oPrint:Say(nLin,1660,"(-) Outras Deduções",oFontAr8) // (-)Abatimento
	nLin += 70 //2800
	
	oPrint:Line(nLin,1650,nLin,nColbFim)
	oPrint:Line(nLin,1650,nLin+70,1650)    //traco
	
	If TMP->E1_VALJUR > 0
		oPrint:Say(nLin, 120,"Apos vencimento Mora Diária R$ "+Alltrim(Transform(TMP->E1_VALJUR,"@E 999,999.99")),oFontAr8)
	EndIf
	
	oPrint:Say(nLin,1660,"(+) Mora/Multa",oFontAr8)
	nLin += 70 //2870
	//Rotina para imprimir o desconto de imposto retido da TAKATA - Anesio: 20/09/2012
	cQRet := " SELECT Sum(E1_VALOR) E1_VALOR FROM SE1010 WHERE D_E_L_E_T_ = ' ' "
	cQRet += " AND E1_NUM = '"+TMP->E1_NUM+"' AND E1_PREFIXO = '"+TMP->E1_PREFIXO+"' "
	cQRet += " AND E1_CLIENTE = '"+TMP->E1_CLIENTE+"' AND E1_LOJA = '"+TMP->E1_LOJA+"' "
	cQRet += " AND E1_EMISSAO = '"+TMP->E1_EMISSAO+"' AND E1_TIPO in ('CF-','PI-') "
	
	if Select('IMPRET') > 0
		dbSelectArea('IMPRET')
		IMPRET->(dbCloseArea())
	endif
	
	dbUseArea(.T., 'TOPCONN', tcGenQry (, , cQRet), 'IMPRET',.F.,.T. )
	
	dbSelectArea('IMPRET')
	if IMPRET->E1_VALOR > 0
		oPrint:Say(nLin+30, 120,"Abatimento R$ "+Alltrim(Transform(IMPRET->E1_VALOR,"@E 999,999.99"))+' referente PIS/COF retido sobre valor total Nota Fiscal.',oFontAr8)
		//+Space(1)+Alltrim(Transform(TMP->E1_VALOR,"@E 999,999.99")),oFontAr8)
	endif
	
	//oPrint:Say( nLin, 120,"PROTESTAR APÓS 10 DIAS DO VENCIMENTO",oFontAr10) //WILLER HDI 004612
	oPrint:Line(nLin,1650,nLin,nColbFim)
	oPrint:Line(nLin,1650,nLin+70,1650)		//Traco vertical
	oPrint:Say(nLin,1660,"(+) Outros Acréscimos",oFontAr8)
	nLin += 70 //2940
	
	oPrint:Line(nLin,1650,nLin,nColbFim)
	oPrint:Line(nLin,1650,nLin+70,1650)		//Traco vertical
	oPrint:Say(nLin,1660,"(=) Valor Cobrado",oFontAr8) // (=)Valor Cobrado
	nLin += 70 //3010
	
	oPrint:Line(nLin,nColbIni,nLin,nColbFim)
	oPrint:Say(nLin,nColbIni,"Pagador ",oFontAr8)
	nLin += 40	//3050
	oPrint:Say(nLin,nColbIni,Alltrim(SA1->A1_NOME),oFontAr10n)
	oPrint:Say(nLin,1200,"CNPJ/CPF: "+cCNPJCli + Space(10) + "Cód.Cliente: "+SA1->A1_COD+"-"+SA1->A1_LOJA,oFontAr10)
	nLin += 40  //3090
	oPrint:Say(nLin,nColbIni,Alltrim(cEndCli) + " - " + Alltrim(cBairroCli),oFontAr10)
	nLin += 40	//3130
	oPrint:Say(nLin,nColbIni,Transform(cCepCli,"@R 99.999-999")+" - "+Alltrim(cMunCli) + " - " + cUFCli,oFontAr10)
	nLin += 50	//3180
	oPrint:Say(nLin,nColbIni,"Sacador/Avalista: "+Alltrim(cSacador),oFontAr10)
	//	oPrint:Say(nLin,1660,"Código de Baixa: ",oFontAr8)
	nLin += 30	//3210
	oPrint:Line(nLin+5,nColbIni,nLin+5,nColbFim)
	If nCnt == 1
		oPrint:Say(nLin+10,1460,"Autenticação Mecânica / RECIBO DO PAGADOR",oFontAr8)
	EndIf
	/*
	--------------------------------
	Impressao do Codigo de Barras
	--------------------------------*/
	If nCnt > 1
		oPrint:Say(nLin+10,1650,"Autenticação Mecânica / FICHA DE COMPENSAÇÃO",oFontAr8)
		
		MSBAR("INT25"   ,; //01 cTypeBar - String com o tipo do codigo de barras ("EAN13","EAN8","UPCA","SUP5","CODE128","INT25","MAT25,"IND25","CODABAR","CODE3_9")
		27.5   	,; //02 nRow	 - Numero da Linha em centimentros      //27.5
		1.3    	,; //03 nCol	 - Numero da coluna em centimentros
		cCodBar  	,; //04 cCode	 - String com o conteudo do codigo    //cCbld
		oPrint    ,; //05 oPr		 - Objecto Printer
		.F.       ,; //06 lcheck	 - Se calcula o digito de controle
		Nil       ,; //07 Cor 	 - Numero da Cor, utilize a "common.ch"
		.T.       ,; //08 lHort	 - Se imprime na Horizontal
		0.022  	,; //09 nWidth	 - Numero do Tamanho da barra em centimetros   //0.013
		1.3      	,; //10 nHeigth	 - Numero da Altura da barra em milimetros
		.F.      ,; //11 lBanner	 - Se imprime o linha em baixo do codigo
		Nil	    ,; //12 cFont	 - String com o tipo de fonte
		Nil       ,; //13 cMode	 - String com o modo do codigo de barras CODE128
		.F.        ) //14 lImprime - Imprime direto sem preview
		
		oPrint:EndPage()
	EndIf
	If nCnt == 1
		nLin := 2250
	EndIf
Next

Return
/*
-----------------------------------------------------------------------------
Funcao    : CalcCodBar
-----------------------------------------------------------------------------
Descricao :	Calculo do DV do Codigo de Barras
-----------------------------------------------------------------------------
Parametros: cExpr1 - Banco
cExpr2 - Moeda
cExpr3 - Fator de Vencimento
cExpr4 - Valor do Titulo
cExpr5 - Campo Livre
-----------------------------------------------------------------------------
*** Codigo de Barras - Padrão FEBRABAN
-----------------------------------------------------------------------------
Pos  Tam  Picture 	Conteudo
-----------------------------------------------------------------------------
001   3	  9(3)		Identificacao do Banco
004	  1   9			Codigo da Moeda (9-Real)
005   1   9			Digito Verificado do Codigo de Barras
006   4   9(4)		Fator de Vencimento (Pos. 06 a 09)
010	  10  9(8)v99	Valor Nominal do Titulo (Pos. 10 a 19)
020   25  9(25)		Campo Livre - De acordo com especificacoes do Banco
-----------------------------------------------------------------------------*/
Static Function CalcCodBar(xBanco,xMoeda,xFator,xValor,xCpLvr)
Local nCnt
Local sFator := "4329876543298765432987654329876543298765432"
Local Modulo := 11
Local nResto := 0
Local nSoma  := 0
Local cDvCBar:= ""
Local cCodBar:= xBanco + xMoeda + xFator + xValor + xCpLvr

For nCnt := 1 To 43
	nSoma += ( Val(Substr(cCodBar,nCnt,1)) * Val(Substr(sFator,nCnt,1)) )
Next
//Conforme manual do BRADESCO
nResto := nSoma % Modulo
nresto := Modulo - nresto

If nResto == 0 .Or. nResto == 1 .Or. nResto > 9
	cDvCBar := "1"
Else
	cDvCBar := Str(nResto, 1)
EndIf

Return(cDvCBar)
/*
-----------------------------------------------------------------------------
Funcao    : CalcLinDig
-----------------------------------------------------------------------------
Descricao :	Calculo da linha digitavel
-----------------------------------------------------------------------------
Parametros: cExpr1 - Banco
cExpr2 - Moeda
cExpr3 - Fator de Vencimento
cExpr4 - Valor do Titulo
cExpr5 - Campo Livre
-----------------------------------------------------------------------------------------------
*** Linha Digitavel - Padrão FEBRABAN
-----------------------------------------------------------------------------------------------
Pos		Tam	Conteudo
-----------------------------------------------------------------------------------------------
001   	3	Identificacao do Banco
004		1	Codigo da Moeda (9-Real)
005		5	1a. a 5a. posicoes do Campo Livre						(P.20 a 24 do CB)
010		1	Dv do primeiro bloco
011		10	6a. a 15a. posicoes do Campo Livre     					(P.25 a 34 do CB)
021		1	Dv do segundo bloco
022		10	16a. a 25a. posicoes do Campo Livre						(P.35 a 44 do CB)
032		1	Dv do terceiro bloco
033		1	Digito verificador Geral 								(P.5 do CB)
034		14	Campo Livre - Posicoes 34 a 37 Fator de Vencimento		(P.6 a 9 do CB)
- Posicoes 38 a 47 Valor Nominal do Titulo 	(P.10 a 19 do CB)
-----------------------------------------------------------------------------------------------
*/
Static Function CalcLinDig(xBanco,xMoeda,xFator,xValor,xCpLvr)
Local   cBloco1,cBloco2,cBloco3,cBloco4,cDvBlc1,cDvBlc2,cDvBlc3
Local   xLinDig := ""
Local   sFator1 := "212121212", sFator2 := "1212121212"

cBloco1   := xBanco + xMoeda + Substr(xCpLvr,1,5)
cBloco2   := Substr(xCpLvr,6,10)
cBloco3   := Substr(xCpLvr,16,10)
cBloco4   := xFator + xValor

xLinDig := Substr(cBloco1,1,5) + "." + Substr(cBloco1,6,4) + CalcLinDv(cBloco1,sFator1)  		// 99999.9999 9
xLinDig += " " + Substr(cBloco2,1,5) + "." + Substr(cBloco2,6,5) + CalcLinDv(cBloco2,sFator2)  	// 99999.99999 9
xLinDig += " " + Substr(cBloco3,1,5) + "." + Substr(cBloco3,6,5) + CalcLinDv(cBloco3,sFator2)  	// 99999.99999 9
xLinDig += " " +  cDvCodBar + " " + cBloco4

Return(xLinDig)
/*
=============================================================================
Funcao    : CalcLinDv
-----------------------------------------------------------------------------
Descricao :	Calculo dos DV's da linha digitavel
-----------------------------------------------------------------------------
Parametros: cExpr1 - String com bloco para ser calculado
-----------------------------------------------------------------------------
*/
Static Function CalcLinDv(xBloco,xFator)
Local sFator  := xFator
Local nResto  := 0
Local nDvBloco:= 0
Local cDvBloco:= ""
Local Modulo  := 10
Local nSoma   := 0
Local nCnt, nCntx, nDv
Local x

For nCnt := 1 To Len(xBloco)
	nDvBloco := (Val(Substr(xBloco,nCnt,1)) * Val(Substr(sFator,nCnt,1)) )
	
	If nDvBloco > 9
		nDv := 0
		For nCntx := 1 To Len(Alltrim(Str(nDvBloco)))
			nDv += Val(Substr(Alltrim(Str(nDvBloco)),nCntx,1))
		Next nCntx
		nSoma += nDv
	Else
		nSoma += nDvBloco
	EndIf
Next nCnt

x := (nSoma / 10)
If x > Int(x)
	x := ((Int(x)+1) * 10)
Else
	x := x * 10
EndIf

cDvBloco := Str((x - nSoma), 1)

Return(cDvBloco)
/*
-----------------------------------------------------------------------------
Funcao    : CalcDvNN
-----------------------------------------------------------------------------
Descricao : Calculo do DV do NN (BRADESCO)
-----------------------------------------------------------------------------
Nota......:	Composicao do Nosso Numero p/calculo do DV: 99NNNNNNNNNNN D onde:
2765432765432
N = Faixa seqüencial de 00000000001 a 99999999999
D = Dígito de controle
-----------------------------------------------------------------------------*/
Static Function CalcDvNN()
Local sFator := "2765432765432"
Local cNNC   := cCarteira + cNN    //nosso numero p/ calculo do DV
Local Modulo := 11, nCnt, nDv := 0, nSoma := 0, nResto

For nCnt := 1 To Len(cNNC)
	nSoma += Val(Substr(cNNC,nCnt,1)) * Val(Substr(sFator,nCnt,1))
Next

nResto := nSoma % Modulo

If nResto == 0
	nDv := 0
	nDv := Str(nDv,1)
ElseIf nResto == 1
	nDv := 'P'
Else
	nDv := Modulo - nResto
	nDv := Str(nDv,1)
EndIf

Return(nDv)
/*
-----------------------------------------------------------------------------
Funcao    : RBolPerg
-----------------------------------------------------------------------------
Descricao : Monta perguntas para impressao de boletos
-----------------------------------------------------------------------------
Parametros: cExpr1 - Perguntas no SX1
-----------------------------------------------------------------------------
*/
Static Function RBolPerg()
Local sAlias := Alias()
Local aRegs:={}
Local j, i

cPerg := PADR(cPerg,10)

dbSelectArea("SX1")
dbSetOrder(1)

AADD(aRegs,{cPerg,"01","Da Emissão          ?","","","mv_ch1" ,"D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Emissão         ?","","","mv_ch2" ,"D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Do Prefixo          ?","","","mv_ch3" ,"C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Prefixo         ?","","","mv_ch4" ,"C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Do Titulo (NF) No.  ?","","","mv_ch5" ,"C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate Titulo (NF) No. ?","","","mv_ch6" ,"C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Do Cliente          ?","","","mv_ch7" ,"C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
AADD(aRegs,{cPerg,"08","Ate Cliente         ?","","","mv_ch8" ,"C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
AADD(aRegs,{cPerg,"09","% Multa Por Atraso  ?","","","mv_ch9" ,"N",05,2,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Banco               ?","","","mv_cha" ,"C",03,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA6",""})
AADD(aRegs,{cPerg,"11","Agencia             ?","","","mv_chb" ,"C",05,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Conta               ?","","","mv_chc" ,"C",10,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Sub-Conta           ?","","","mv_chd" ,"C",03,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Do Vencimento       ?","","","mv_che" ,"D",08,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"15","Ate Vencimento      ?","","","mv_chf" ,"D",08,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"16","Considera Filiais   ?","","","mv_chg" ,"N",01,0,0,"C","","mv_par16","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"17","Da Filial           ?","","","mv_chh" ,"C",02,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"18","Ate Filial          ?","","","mv_chi" ,"C",02,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"19","Grava Bordero ?      ","","","mv_chj" ,"N",01,0,0,"C","","mv_par19","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		SX1->(MsUnlock())
	Endif
Next
dbSelectArea(sAlias)

Return

/*
-----------------------------------------------------------------
Funcao   : GravaBor()
Descricao: Gravar bordero de Cobranca para os titulos impressos

-----------------------------------------------------------------*/
Static Function GravaBor()
Local xPrefixo
Local xNumero
Local xParcela
Local cSE1Fil
Local xTipo
Local nCnt

Local cNumBor := Alltrim(GetMv("MV_NUMBORR")) // A Numeracao de borderos nao é controlada pelo SXE/SXF

cNumBor := StrZero(( Val(cNumBor) + 1 ),6)

If Len(aTitulos) > 0
	
	For nCnt := 1 To Len(aTitulos)
		cSE1Fil  := aTitulos[nCnt,12]  //filial do titulo e nao a filial corrente
		xPrefixo := aTitulos[nCnt,1]
		xNumero  := aTitulos[nCnt,2]
		xParcela := aTitulos[nCnt,3]
		xTipo    := aTitulos[nCnt,13]
		
		//SE1->(MsSeek(xFilial("SE1") + xPrefixo + xNumero + xParcela))
		DbSelectArea("SE1") //AOliveira 03-02-12
		SE1->(DBSeek(cSE1Fil + xPrefixo + xNumero + xParcela + xTipo)) //AOliveira 03-02-12
		
		RecLock("SEA",.T.)
		SEA->EA_FILIAL      := xFilial("SEA")
		SEA->EA_PREFIXO     := SE1->E1_PREFIXO
		SEA->EA_NUM         := SE1->E1_NUM
		SEA->EA_PARCELA     := SE1->E1_PARCELA
		SEA->EA_PORTADO     := SE1->E1_PORTADO
		SEA->EA_AGEDEP      := SE1->E1_AGEDEP
		SEA->EA_NUMBOR      := cNumBor
		SEA->EA_DATABOR     := dDataBase
		SEA->EA_TIPO        := SE1->E1_TIPO
		SEA->EA_CART        := "R"
		SEA->EA_NUMCON      := SE1->E1_CONTA
		SEA->EA_TRANSF      := "N"
		SEA->EA_SITUACA     := SE1->E1_SITUACA
		SEA->EA_SITUANT     := "0"
		SEA->(MsUnlock())
		
		/*----------------------------------
		Grava dados do Bordero no titulo
		----------------------------------*/
		
		DbSelectArea("SE1")
		RecLock("SE1",.F.)
		SE1->E1_NUMBOR  := cNumBor
		SE1->E1_DATABOR := dDataBase
		SE1->E1_MOVIMEN := dDataBase
		SE1->(MsUnlock())
		
	Next nCnt
	
	/*	--- Atualiza parametro ---*/
	
	DbSelectArea("SX6")
	SX6->(dbSeek(xFilial("SX6")+"MV_NUMBORR"))
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := cNumBor
	SX6->(MsUnlock())
	
EndIf

Return



/*
Funcao : XPARAM
Autor  : AOliveira
Data   : 2018-09-11
Descr. : Novos Parametros de usuário
*/
Static Function XPARAM()

LOCAL aParamBox := {}  
LOCAL cTitulo := "Parametros"
Static aPergRet := {}            
LOCAL bOk := {|| .T.}
LOCAL aButtons := {}
LOCAL lCentered := .T.
LOCAL nPosx
LOCAL nPosy
LOCAL cLoad := "XPARAM_01"
LOCAL lCanSave := .T.
LOCAL lUserSave := .T.

aAdd(aParamBox,{1,"% Multa Por Atraso  ",2.00  ,"@E 999.99", ,"" ,".F.",10 ,.F.})
aAdd(aParamBox,{1,"Banco               ",Space(TamSx3("A6_COD")[1]),"@!","","SA6","",0,.F.})
aAdd(aParamBox,{1,"Agencia             ",Space(TamSx3("A6_AGENCIA")[1]),"@!","","","",0,.F.})
aAdd(aParamBox,{1,"Conta               ",Space(TamSx3("A6_NUMCON")[1]),"@!","","","",0,.F.})
aAdd(aParamBox,{1,"Sub-Conta           ",Space(TamSx3("EE_SUBCTA")[1]),"@!","","","",0,.F.})
aAdd(aParamBox,{2,"Grava Bordero       ","Sim",{"Sim","Não"},50,"",.F.})
                                         
//If ParamBox(aParamBox,"Parametros",@aRet)
lRet := ParamBox(aParamBox, cTitulo, aPergRet, bOk, aButtons, lCentered, nPosx,nPosy, /*oMainDlg*/ , cLoad, lCanSave, lUserSave)

If lRet
	
Endif

Return()
