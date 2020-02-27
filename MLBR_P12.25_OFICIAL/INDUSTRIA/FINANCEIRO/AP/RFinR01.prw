#include "RWMAKE.CH"
#include "PROTHEUS.CH"
/*                               
-----------------------------------------------------------------------------
Programa  : RFinR01
-----------------------------------------------------------------------------
Descricao : Impressao das Autorizacoes de Pagamentos originadas em:
			1-Documento de Entrada
			2-Financeiro (Inclusão manual de titulos)
			3-Gestão de Pessoal     
			4-Apurações -> ICMS/IPI/PIS/COFINS                               
			5-Documento de Entrada - EIC
-----------------------------------------------------------------------------
Parametros: 
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
			16-Historico
-----------------------------------------------------------------------------
Especifico para o Cliente
-----------------------------------------------------------------------------
Atualizações: 
	          AOliveira - 29/10/2018
	          Incluido exceção para o IF de validação no campo TRB->E2_ORIGEM
	          inclusão realizada nas linhas 189 à 192.
	          ===============================================================
	           
-----------------------------------------------------------------------------
*/

User Function RFinR01(aTit,aDesc,xRotina,_cFiltro)	
Local wnrel
Local tamanho		:= "G"
Local titulo		:= "Autorização de Pagamento"
Local cDesc1		:= "Impressão de AP's "
Local cDesc2		:= ""
Local aSays     	:= {}, aButtons := {}, nOpca := 0

//Private cAPNum      := If(FunName() $ "MATA103",SF1->F1_X_NUMAP,cExpr1)
Private _aArea      := GetArea()
Private nomeprog 	:= "RFinR01"
Private nLastKey 	:= 0
Private cPerg    	:= "RFINR01"
Private oPrint
Private aDadosTit   := aTit
Private aDescri     := aDesc		//If(aDesc==Nil,Nil,aDesc)
Private lTitFT      := If(Valtype(aDesc)=="A",.F.,.T.)    //lTitFT = .T. -->titulo tipo "FT", senao conteudo de aDesc eh um array
//Private xRotOrig    := xRotina   

Private oFontAr8	:= TFont():New("Arial", 8, 8,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr9	:= TFont():New("Arial", 9, 9,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr11	:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr14	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr16	:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)	//Normal

Private oFontAr8n	:= TFont():New("Arial", 8, 8,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr9n	:= TFont():New("Arial", 9, 9,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr10n	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr11n	:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr12n	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr14n	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr16n	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)	//Negrito

oPrint:=TMSPrinter():New()	
oPrint:SetPortrait()					
oPrint:SetPaperSize(9)					

ApMsgAlert("Tecle OK para Imprimir a Autorização de Pagamento...")

dbSelectArea("CTT")
dbSetOrder(1)
dbSelectArea("CTD")
dbSetOrder(1)
/*
------------------------------------------------------------------
Limpa filtro gerado pela rotina PE F050BROW
------------------------------------------------------------------*/
If !Empty(_cFiltro)
	dbSelectArea("SE2")
	dbSetOrder(1)

	Set Filter To
EndIf

RptStatus({|lEnd| RFinR01Proc(xRotina)},Titulo)
/*
------------------------------------------------------------------
Restaura filtro gerado pela rotina PE F050BROW
------------------------------------------------------------------*/
If !Empty(_cFiltro)   
	bFilBrw	:=	{|| FilBrowse('SE2',@_aIndices,_cFiltro)}    
	Eval( bFilBrw )
EndIf

Restarea(_aArea)
Return(.T.)
/*
----------------------------------------------------------------------
Funcao   : RFinR01Proc()
Descricao: Impressao da Autorizacao de Pagamento
----------------------------------------------------------------------*/
Static Function RFinR01Proc(cRotOrig)
Local cPrefixo := aDadosTit[1][1]
Local cNumTit  := aDadosTit[1][2]
Local cParcela := aDadosTit[1][3]
Local cTipo    := aDadosTit[1][4]
Local cFornece := aDadosTit[1][5]
Local cLoja    := aDadosTit[1][6]
Local cBcoFv   := adadosTit[1][8] 
Local cAgeFv   := adadosTit[1][9]
Local cCtaFv   := adadosTit[1][10]
Local cNomFv   := adadosTit[1][11]
//	1				2	   3	    4					5			6		7		   8				9				10			11		12         13        14      15      16
//F1_PREFIXO,SF1->F1_DUPL,"",SF1->F1_ESPECIE,SF1->F1_FORNECE,SF1->F1_LOJA,cNumAp,SF1->F1_X_BCOFV,SF1->F1_X_AGEFV,SF1->F1_X_CTAFV,cNomFav,cInscr,SF1->F1_X_ORIG,cTpCta,cFrmPag,cHistor})

Local cCpfFv   := adadosTit[1][12]
Local cOrigAp  := adadosTit[1][13]
Local cTpCta   := adadosTit[1][14]
Local cFPagt   := adadosTit[1][15]     
Local cHistor  := adadosTit[1][16]		//chamado HD No. 361
Local cxHist   := adadosTit[1][17]
Local NPISCOFCSL := 0
Local NPCCTOT    := 0 
Local nCt

Private cLogo   := "\system\lgrl01_1.bmp"
Private cQuery  := "" 
Private cDtVencI:= ""
Private cDtVencF:= ""
Private nQtdParcelas := 0
Private aParcelas := {}
Private nValorLiq := 0
Private nValorDoc := 0
Private nTotRet   := 0
Private	lReimp 	:= .F.
Private cFormaPag 
Private lSZFOk := .F.

Public cNumAp   := adadosTit[1][7]

/*
--------------------------------------------
Reimpressão de AP
--------------------------------------------*/
If cRotOrig == "RFINA02"  
	lReimp := .T.
    If Len(aDescri) > 0
		lSZFOk := .T.
	EndIf	
	
	SE2->(dbSetOrder(1))          //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
                                                                      
	If Alltrim(TRB->E2_ORIGEM) == "SIGAEIC"        //Titulos gerados pela Importacao
		aAdd(aDescri,{"TOTAL DOCUMENTO FISCAL",0})
	ElseIf Alltrim(TRB->E2_ORIGEM) == "MATA100"    //NF Mercadoria e Servicos
		aAdd(aDescri,{"TOTAL DOCUMENTO FISCAL",0})
		If Upper(Substr(TRB->E2_HIST,1,5)) == "FRETE"
			aAdd(aDescri,{Alltrim(TRB->E2_HIST),0})
		EndIf
	ElseIf Alltrim(TRB->E2_ORIGEM) == "FINA050"    				//Inclusao Manual de Titulos
   		If !(TRB->E2_TIPO $ "TX |TXA|ISS|INS|IRF|PIS|COF")		//cTipo
  			SED->(MsSeek(xFilial("SED")+SE2->E2_NATUREZ))  
			If !lSZFOk					//Len(aDescri) == 0
				aAdd(aDescri,{Alltrim(SED->ED_DESCRIC),0}) 
			Endif
/*-----------------------------
				If Substr(cOrigAp,1,1) == "2"    //RH /--- Alterado em 14/10/10 - Chamado HD No. 000415 ---	//
		  			SED->(MsSeek(xFilial("SED")+SE2->E2_NATUREZ))  
					aAdd(aDescri,{Alltrim(SED->ED_DESCRIC),0}) 
				Else
					aAdd(aDescri,{Alltrim(Tabela("80",TRB->E2_X_ORIG,.f.)),(TRB->E2_VALOR + TRB->E2_ACRESC)})  
				Endif
-----------------------------*/
//				SED->(MsSeek(xFilial("SED")+TRB->E2_NATUREZ))  
//				aAdd(aDescri,{Alltrim(SED->ED_DESCRIC),0}) 
		EndIf
	ElseIf Alltrim(TRB->E2_ORIGEM) == "FINA290"    //Faturas
		RFinR01Fat() 
	Else 
		//AOliveira -- 29-10-2018
		//Caso não existe na validação anterior
		aAdd(aDescri,{"TOTAL DOCUMENTO",0})		
	EndIf                                      
	
	//	nPisCofCsl := 0	
	nTotRet := 0	
	While TRB->(!Eof()) .And. xFilial("SE2") == TRB->E2_FILIAL .And. TRB->E2_PREFIXO == cPrefixo .And. TRB->E2_NUM == cNumTit .And. TRB->E2_X_NUMAP == cNumAP
		If !(TRB->E2_TIPO $ "TX |TXA|ISS|INS|IRF|PIS|COF")		//cTipo
        	cFormaPag := TRB->E2_X_FPAGT
		Else
        	cFormaPag := ""
		EndIf
   		aAdd(aParcelas,	{	TRB->E2_PREFIXO,TRB->E2_NUM    				,TRB->E2_PARCELA,	TRB->E2_TIPO   ,	TRB->E2_FORNECE,	TRB->E2_LOJA,;   
   							TRB->E2_VENCTO ,TRB->E2_VENCREA				,TRB->E2_NATUREZ,	TRB->E2_HIST   ,	TRB->E2_X_BCOFV,	TRB->E2_X_AGEFV,;
   							TRB->E2_X_CTAFV,TRB->E2_X_NOMFV				,TRB->E2_X_TPCTA,	TRB->E2_X_CPFFV,	TRB->E2_X_NUMAP,	TRB->E2_EMISSAO,;
   							TRB->E2_X_ORIG ,TRB->E2_VALOR+TRB->E2_ACRESC,TRB->E2_X_USUAR,	cFormaPag	   ,	TRB->E2_CCD    ,,,, TRB->E2_ACRESC,;
   							TRB->E2_DECRESC,TRB->E2_MULTA  				,TRB->E2_JUROS  ,   TRB->E2_CORREC ,    TRB->E2_ITEMD, TRB->E2_HIST1})

		If Empty(cDtVencI)
			cDtVencI := GravaData(TRB->E2_VENCTO,.f.,5)    //Primeiro vencto
		EndIf
		If (SE2->(MsSeek(xFilial("SE2")+ TRB->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))))
			RecLock("SE2",.F.)
			SE2->E2_X_FLAG  := "2"		//Re-Impresso
			MsUnlock()
			if SE2->(E2_PIS+E2_COFINS+E2_CSLL) > 0
				////////////////////////////////////////////////////////////////////////////////////////////////
//				Alert('Numero da AP: |'+cNumAp+'|'+cValToChar(len(cNumAp)))	
				nDeduz := U_VerSeDeduz(SE2->E2_FORNECE, SE2->E2_LOJA, SE2->E2_VENCREA, SE2->(E2_PREFIXO+E2_NUM))
				////////////////////////////////////////////////////////////////////////////////////////////////				
				//Caso o valor retornado seja 1 ou 2 o valor a ser deduzido é apenas da duplicata corrente
				if nDeduz == 1 .or. nDeduz == 2 
					nPisCofCsl :=  SE2->(E2_PIS+E2_COFINS+E2_CSLL)
					nPCCTOT += SE2->(E2_PIS+E2_COFINS+E2_CSLL)
				elseif nDeduz == 3
					nPisCofCsl := nVRetPCC
					nPCCTOT += SE2->(E2_PIS+E2_COFINS+E2_CSLL)
				elseif nDeduz == 4
					nPisCofCsl :=  SE2->(E2_PIS+E2_COFINS+E2_CSLL)
					nPCCTOT += SE2->(E2_PIS+E2_COFINS+E2_CSLL)
				endif
				/////////////////////////////////////////////////////////////////////////////////////////////
				//Verificar o tipo de mensagem a ser adicionada...
				if nDeduz == 1 .or. nDeduz == 2 
					aAdd(aDescri, {"(-) DEDUCAO DE PIS, COFINS E CSLL", nPisCofCsl})
				elseif nDeduz == 3
					aAdd(aDescri, {"(-) DEDUCAO DE PIS, COFINS E CSLL", nPisCofCsl})
				else
					aAdd(aDescri, {"(-) INFORMATIVO DE PIS, COFINS E CSLL (SEM DEDUÇÃO NESSE MOMENTO) ", nPisCofCsl})
					nPisCofCsl := 0
					nPCCTOT    := 0
				endif
			endif
//			nValor := (SE2->E2_VALOR + SE2->E2_ACRESC)
			
			If !(TRB->E2_TIPO $ "TX |TXA|ISS|INS|IRF|PIS|COF")		//cTipo
				cDtVencF     := GravaData(TRB->E2_VENCTO,.f.,5)    
            	nQtdParcelas += 1
				nValorLiq    += (TRB->E2_VALOR + TRB->E2_ACRESC)
			Else
	  			SED->(MsSeek(xFilial("SED")+SE2->E2_NATUREZ))  
				aAdd(aDescri,{"(-) "+Alltrim(SED->ED_DESCRIC),(TRB->E2_VALOR + TRB->E2_ACRESC)})  //nValor}) 

				If Alltrim(TRB->E2_ORIGEM) == "FINA050"
					cDtVencF     := GravaData(TRB->E2_VENCTO,.f.,5)    
    	        	nQtdParcelas += 1
            	EndIf
				nTotRet += (TRB->E2_VALOR + TRB->E2_ACRESC)
//            	Alert('Adicionando Total...'+cValToChar(nTotRet))
			EndIf
		EndIf
		TRB->(dbSkip())
	EndDo

	If Len(aParcelas) > 0
		nSomaX := 0    
		_nDesc := _nMulta := _nJuros := _nCMonetario := 0 //Aoliveira
		For nCt := 1 To Len(aParcelas)
			/*--- Verifica se descrição precisa ser detalhada ---*/
			nSomaX := aParcelas[nCt,29]+aParcelas[nCt,30]+aParcelas[nCt,31]-aParcelas[nCt,28]
			If nSomaX != 0
				If aParcelas[nCt,28] != 0 
					cDescri := "(-) DESCONTOS/ABATIMENTOS "
					aAdd(aDescri,{cDescri , aParcelas[nCt,28]})   //nValorX
					_nDesc := aParcelas[nCt,28] //AOliveira 22-03-11
				EndIf
				If aParcelas[nCt,29] != 0 
					cDescri := "(+) MULTA "
					aAdd(aDescri,{cDescri , aParcelas[nCt,29]}) //nValorX
					_nMulta := aParcelas[nCt,29] //AOliveira 22-03-11
				EndIf
				If aParcelas[nCt,30] != 0 
					cDescri := "(+) JUROS "
					aAdd(aDescri,{cDescri , aParcelas[nCt,30]}) //nValorX
					_nJuros := aParcelas[nCt,30] //AOliveira 22-03-11
				EndIf
				If aParcelas[nCt,31] != 0 
					cDescri := "(+) CORRECAO  MONETARIA"
					aAdd(aDescri,{cDescri , aParcelas[nCt,31]}) //nValorX
					_nCMonetario := aParcelas[nCt,31] //AOliveira 22-03-11
				EndIf
			EndIf
		Next
   	EndIf                            
	nValorDoc += nValorLiq + nTotRet 

	If !lSZFOk
		aDescri[1,2] := nValorDoc
	EndIf
	
	if nValorLiq == 0 
		nValorLiq := nValorDoc
	endif
	
	nValorLiq += 	((_nMulta + _nJuros + _nCMonetario) - _nDesc)
	aAdd(aDescri,{"TOTAL LÍQUIDO A PAGAR R$"  ,nValorLiq - nPCCTOT}) 


	RImpAutPag(aParcelas,"RFINA02", nPisCofCsl, nPCCTOT)	

	Return
EndIf

If !lTitFT
	/*	
	-------------------------------------------
	Atualiza campos ref. AP's no SE2  
	-------------------------------------------*/ 
	cQuery := " SELECT * FROM "  
	cQuery += RetSqlName("SE2")+" SE2 "
	cQuery += " WHERE " 
	cQuery += " SE2.E2_PREFIXO = '" + cPrefixo+ "' AND " 
	cQuery += " SE2.E2_NUM = '" + cNumTit + "' AND "   
	If FunName() == 'FINA050' .Or. FunName() == 'MATA103'
		cQuery += " SE2.E2_BAIXA = ' ' AND "   
	EndIf
	cQuery += " SE2.D_E_L_E_T_ = ' '"  
	cQuery += " ORDER BY SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPA",.F.,.T.)
	dbSelectArea("TMPA") 

	cDtVencI   := ""    
	nValorLiq  := 0
//	nPisCofCsl := 0
	nValorDoc  := 0	
	SE2->(dbSetOrder(1))          //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA

	lTitTx := .F.			//.T. se titulo de Taxas
	While TMPA->(!Eof()) 

		If FunName() == 'FINA050' .Or. FunName() == 'MATA103' .Or. FunName() == 'FINA378'   //
			If !(EMPTY(TMPA->E2_X_NUMAP))
				If TMPA->E2_X_NUMAP != 	cNumAp
					TMPA->(dbSkip())
					Loop
				EndIf
			EndIf
		EndIf
		
		If !(TMPA->E2_TIPO $ "TX |TXA|ISS|INS|IRF|PIS|COF")		//cTipo
			If TMPA->E2_FORNECE != cFornece  //Verifica se o fornecedor na NF é igual ao fornecedor no titulo 
				TMPA->(dbSkip())
				Loop
			EndIf
		Else
			If !Empty(TMPA->E2_TITPAI)     //TITULO DE TAXA INPUTADO MANUALMENTE --> CHAMADO HD No. 558
				If RIGHT(ALLTRIM(TMPA->E2_TITPAI),8) != (cFornece + cLoja)
					TMPA->(dbSkip())
					Loop
				EndIf
			EndIf
		EndIf

		If Empty(cDtVencI)
			cDtVencI := GravaData(StoD(TMPA->E2_VENCTO),.f.,5)    //Primeiro vencto
		EndIf

		If (SE2->(MsSeek(xFilial("SE2")+ TMPA->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))))

			RecLock("SE2",.F.)
    		SE2->E2_X_NUMAP := cNumAp
			SE2->E2_X_FLAG  := "1"		//IMPRESSO
			SE2->E2_X_ORIG  := cOrigAp
			SE2->E2_HIST    := cHistor			//Chamado HD No. 361 
			SE2->E2_HIST1   := cxHist
			SE2->E2_X_NOMFV := cNomFv



			If !(SE2->E2_TIPO $ "TX |TXA|ISS|INS|IRF|PIS|COF")
				SE2->E2_X_BCOFV := cBcoFv	//SA2->A2_BANCO
				SE2->E2_X_AGEFV := cAgeFv	//SA2->A2_AGENCIA
				SE2->E2_X_CTAFV := cCtaFv	//SA2->A2_NUMCON
				SE2->E2_X_NOMFV := If(Empty(cBcoFv),"",cNomFv)
				SE2->E2_X_CPFFV := If(Empty(cBcoFv),"",cCpfFv)
				SE2->E2_X_TPCTA := cTpCta
				SE2->E2_X_FPAGT := cFPagt   

			if SE2->(E2_PIS+E2_COFINS+E2_CSLL) > 0
				////////////////////////////////////////////////////////////////////////////////////////////////
				nDeduz := U_VerSeDeduz(SE2->E2_FORNECE, SE2->E2_LOJA, SE2->E2_VENCREA, SE2->(E2_PREFIXO+E2_NUM))
				////////////////////////////////////////////////////////////////////////////////////////////////				
				//Caso o valor retornado seja 1 ou 2 o valor a ser deduzido é apenas da duplicata corrente
				if nDeduz == 1 .or. nDeduz == 2 
					nPisCofCsl :=  SE2->(E2_PIS+E2_COFINS+E2_CSLL)
				elseif nDeduz == 3
					nPisCofCsl := nVRetPCC
				elseif nDeduz == 4
					nPisCofCsl :=  SE2->(E2_PIS+E2_COFINS+E2_CSLL)
				endif
				/////////////////////////////////////////////////////////////////////////////////////////////
				//Verificar o tipo de mensagem a ser adicionada...
				if nDeduz == 1 .or. nDeduz == 2 
					aAdd(aDescri, {"(-) DEDUCAO DE PIS, COFINS E CSLL", nPisCofCsl})
				elseif nDeduz == 3
					aAdd(aDescri, {"(-) DEDUCAO DE PIS, COFINS E CSLL", nPisCofCsl})
				else
					aAdd(aDescri, {"(-) INFORMATIVO DE PIS, COFINS E CSLL (SEM DEDUÇÃO NESSE MOMENTO) ", nPisCofCsl})
					nPisCofCsl := 0
					nPCCTOT    := 0
				endif
			endif


				cDtVencF     := GravaData(StoD(TMPA->E2_VENCTO),.f.,5)    
            	nQtdParcelas += 1
				nValorLiq    += SE2->E2_VALOR + SE2->E2_ACRESC  	//Calculodo valor bruto

				If FunName() == 'MATA103'
					nValorDoc := aDescri[1,2]
				Else
					nValorDoc += SE2->E2_VALOR + SE2->E2_ACRESC		//Calculodo valor total da compra  
				EndIf
			Else	//titulo de taxas

				If Empty(TMPA->E2_TITPAI)     //TITULO DE TAXA INPUTADO MANUALMENTE --> CHAMADO HD No. 558
					SE2->E2_X_FPAGT := cFPagt   

					cDtVencF     := GravaData(StoD(TMPA->E2_VENCTO),.f.,5)    
            		nQtdParcelas += 1
					nValorLiq    += SE2->E2_VALOR + SE2->E2_ACRESC  	//Calculodo valor liquido  
					lTitTx       := .T.
				Else
					lTitTx       := .F.
					SE2->E2_X_FPAGT := ""  

					If !(FunName() == 'MATA103')
						nValorDoc += SE2->E2_VALOR + SE2->E2_ACRESC
					EndIf
					SED->(MsSeek(xFilial("SED")+SE2->E2_NATUREZ))  
//					aAdd(aDescri,{Alltrim(SED->ED_DESCRIC),SE2->E2_VALOR + SE2->E2_ACRESC}) 
					aAdd(aDescri,{"(-) "+Alltrim(SED->ED_DESCRIC),SE2->E2_VALOR + SE2->E2_ACRESC}) 
				EndIf
			EndIf
			SE2->E2_X_CODUS := RetCodUsr()
			SE2->E2_X_USUAR := Alltrim(USRFULLNAME(RETCODUSR()))
			SE2->E2_X_DEPTO := Tabela("80",cOrigAp,.f.)
			MsUnlock()
		
			If !(SE2->E2_TIPO $ "TX |TXA|ISS|INS|IRF|PIS|COF")		//cTipo
    	    	cFormaPag := SE2->E2_X_FPAGT
			Else
        		cFormaPag := ""
			EndIf
        	aAdd(aParcelas,{SE2->E2_PREFIXO,SE2->E2_NUM    ,SE2->E2_PARCELA,SE2->E2_TIPO   ,SE2->E2_FORNECE,SE2->E2_LOJA,;   
        					SE2->E2_VENCTO ,SE2->E2_VENCREA,SE2->E2_NATUREZ,SE2->E2_HIST   ,SE2->E2_X_BCOFV,SE2->E2_X_AGEFV,;
        					SE2->E2_X_CTAFV,SE2->E2_X_NOMFV,SE2->E2_X_TPCTA,SE2->E2_X_CPFFV,SE2->E2_X_NUMAP,SE2->E2_EMISSAO,;
        					SE2->E2_X_ORIG ,SE2->E2_VALOR+SE2->E2_ACRESC,SE2->E2_X_USUAR,cFormaPag,SE2->E2_CCD,SE2->E2_CODINS,SE2->E2_CODRET,;
        					SE2->E2_X_CODRE,SE2->E2_ACRESC ,SE2->E2_DECRESC,SE2->E2_MULTA  ,SE2->E2_JUROS ,SE2->E2_CORREC,SE2->E2_ITEMD, SE2->E2_HIST1 })
		EndIf
		TMPA->(dbSkip())
	EndDo		

	If !lTitTx 			//.T. se titulo de Taxas
		If Substr(cCodOri,1,1) != "3"    //ADMINISTRAÇÃO
			aDescri[1,2] :=  nValorDoc 
		EndIf
    EndIf
	/*--- Ajusta array das descrições ---*/  
	If lTitTx 
		If Len(aParcelas) > 0
			nSomaX := 0
			For nCt := 1 To Len(aParcelas)
				/*--- Verifica se descrição precisa ser detalhada ---*/
				nSomaX := aParcelas[nCt,29]+aParcelas[nCt,30]+aParcelas[nCt,31]-aParcelas[nCt,28]
				If nSomaX != 0
					If aParcelas[nCt,28] != 0 
						cDescri := "(-) DESCONTOS/ABATIMENTOS "
						nValorX := aParcelas[nCt,28]
						aAdd(aDescri,{cDescri , nValorX}) 
					EndIf
					If aParcelas[nCt,29] != 0 
						cDescri := "(+) MULTA "
						nValorX := aParcelas[nCt,29]
						aAdd(aDescri,{cDescri , nValorX}) 
					EndIf
					If aParcelas[nCt,30] != 0 
						cDescri := "(+) JUROS "
						nValorX := aParcelas[nCt,30]
						aAdd(aDescri,{cDescri , nValorX}) 
					EndIf
					If aParcelas[nCt,31] != 0 
						cDescri := "(+) CORRECAO  MONETARIA"
						nValorX := aParcelas[nCt,31]
						aAdd(aDescri,{cDescri , nValorX}) 
					EndIf
				EndIf
			Next
			nValorLiq += nSomaX
    	EndIf
	EndIf
	aAdd(aDescri,{"TOTAL LÍQUIDO A PAGAR R$"  ,nValorLiq - nPisCofCsl}) 

	TMPA->(dbCloseArea())
Else
/*	----------------------------------------------
	Geracao de Fatura a Pagar
	----------------------------------------------*/
	aDescri   := {}
	aParcelas := aDadosTit
	
	If Empty(cDtVencI)
		cDtVencI := GravaData(aParcelas[1,7],.f.,5)    //Primeiro vencto
	EndIf

	cDtVencF     := GravaData(aParcelas[Len(aParcelas),7],.f.,5)    
   	nQtdParcelas := Len(aParcelas)
/*	-------------------------------------------------
	Titulos agregados a Fatura
	-------------------------------------------------*/
	nColuna := 1
	nElemFt := Len(aTitFt) 
	cString := ""

	aAdd(aDescri,{"JUNCAO DOS TITULOS EM FATURA",})
/*	----------------------------------------------
	Totaliza a Fatura
	----------------------------------------------*/
 	nJur := nMul := nCor := nAcr := nValorDoc := 0	
	For nCt := 1 To Len(aParcelas)
		/*--- Valores Complementares ---*/
		nAcr += aParcelas[nCt,27]
		nMul += aParcelas[nCt,29]
		nJur += aParcelas[nCt,30]
		nCor += aParcelas[nCt,31]
		/*--- Calculodo valor total da FATURA ---*/
		nValorDoc += aParcelas[nCt,20]            /*AOliveira - */
	Next  
	aDescri[1,2 ]:= nValorDoc 
	If nAcr > 0
		aAdd(aDescri,{"(+) Outras Entidades R$", nAcr})  
		nValorDoc += nAcr
	EndIf 
	If nMul > 0
		aAdd(aDescri,{"(+) Multa R$", nMul})  
		nValorDoc += nMul
	EndIf 
	If nJur > 0
		aAdd(aDescri,{"(+) Juros R$", nJur})  
		nValorDoc += nJur
	EndIf 
	If nCor > 0
		aAdd(aDescri,{"(+) Correção Monetária R$", nCor})  
		nValorDoc += nCor
	EndIf 

	For nCt := 1 To Len(aTitFt) 
		If nCt > 44
			Exit        // Sai do Looping
		EndIf   

		If nColuna < 4 
			cString += aTitFt[nCt,1]+Space(1)+aTitFt[nCt,2]+"-"+aTitFt[nCt,3]+Space(2)+aTitFt[nCt,4]+" | "
			If nColuna == 4
				aAdd(aDescri,{cString,})
			
				cString := ""  
				nColuna := 1		
			EndIf
            nColuna += 1
		Else             
	        cString += aTitFt[nCt,1]+Space(1)+aTitFt[nCt,2]+"-"+aTitFt[nCt,3]+Space(2)+aTitFt[nCt,4]
			aAdd(aDescri,{cString,})  		
			
			cString := ""
			nColuna := 1
		EndIf
	Next
	If !Empty(cString)
		aAdd(aDescri,{cString,})  		
	EndIf
	aAdd(aDescri,{"TOTAL DA FATURA R$", nValorDoc})  
EndIf					
                                
RImpAutPag(aParcelas,,nPisCofCsl, nPCCTOT)	

Return
/*
----------------------------------------------------------------------
Funcao   : RImpAutPag()
Descricao: Impressão da Autorizacao de Pagamento             
----------------------------------------------------------------------*/
Static Function RImpAutPag(aParcelas,cRotOrig, nPisCofCsl, nPCCTOT)
Local nLin       := 30	//60    
Local nColIni    := 100
Local nColFim    := 2300
Local cDtEmis    := GravaData(aParcelas[1,18],.f.,5)
Local cDtProc    := GravaData(dDataBase,.f.,5)
Local cUnidade   := ""
Local i, nCt, iHist, nCtd, nCnt
cDtEmis := Substr(cDtEmis ,1,2)+"/"+Substr(cDtEmis ,3,2)+"/"+Substr(cDtEmis ,5,4)
cDtVencI:= Substr(cDtVencI,1,2)+"/"+Substr(cDtVencI,3,2)+"/"+Substr(cDtVencI,5,4)
cDtVencF:= Substr(cDtVencF,1,2)+"/"+Substr(cDtVencF,3,2)+"/"+Substr(cDtVencF,5,4)
cDtProc := Substr(cDtProc ,1,2)+"/"+Substr(cDtProc ,3,2)+"/"+Substr(cDtProc ,5,4)

If lReimp
	cDtProc += Space(3)+"( R )"
EndIf
/*
--------------------------------------------
Filial de Origem
--------------------------------------------*/
If aParcelas[1,1] == 'EIC'	
	SM0->(MsSeek(cEmpAnt + CFILANT)) 	//PEGA A FILIAL CORRENTE
Else             
	SM0->(MsSeek(cEmpAnt + aParcelas[1,1])) 	//PEGA A FILIAL DO TITULO
EndIf
cUnidade:= UPPER(SM0->M0_FILIAL)
cFilOrig:= aParcelas[1,1]
/*	
--------------------------------------------
Imprime Anexo ao Documento Original
--------------------------------------------*/
SED->(dbSetOrder(1))
SED->(MsSeek(xFilial("SED")+aParcelas[1,9]))

nFolha := 1

cFormaPag := 	If(aParcelas[1,22]=='1',"DOC/TED",;
				If(aParcelas[1,22]=='2',"Boleto/DDA",;
				If(aParcelas[1,22]=='3',"Cheque",;
				If(aParcelas[1,22]=='4',"Caixa",;
				If(aParcelas[1,22]=='5',"Cnab Folha",;
				If(aParcelas[1,22]=='6',"Cartão Corporativo",""))))))
While .T.
/*	-----------------------------------------------
	Impressao do Anexo
	-----------------------------------------------*/
	oPrint:Line(nLin,nColIni,nlin,nColFim)
	oPrint:Line(nLin,nColIni,1680,nColIni)     		//vertical
	oPrint:Line(nLin,1600,nLin+60,1600)     		//vertical
	oPrint:Line(nLin,nColFim,1680,nColFim)     		//vertical
	nLin += 10
	
	If !lReimp
		oPrint:Say(nLin,120,"AUTORIZAÇÃO DE PAGAMENTO No. "+Alltrim(Transform(Val(aParcelas[1,17]),"@E 999,999,999")),oFontAr12n)
	Else
		oPrint:Say(nLin,120,"AUTORIZAÇÃO DE PAGAMENTO No. "+Alltrim(Transform(Val(aParcelas[1,17]),"@E 999,999,999"))+ Space(3)+"( R )",oFontAr12n)
	EndIf
//	oPrint:Say(nLin,1610,"Unidade:  "+ CFILANT +" - "+Upper(cUnidade),oFontAr12n)
	oPrint:Say(nLin,1610,"Unidade:  "+ cFilOrig +" - "+Upper(cUnidade),oFontAr12n)
	nLin += 50
	oPrint:Line(nLin,nColIni,nLin,nColFim)     //Horizontal
	nLin += 50
	oPrint:SayBitmap(nLin,120,cLogo,239,100)
	oPrint:Say(nLin,700,"Fornecedor: ",oFontAr11)
/*	--------------------------------------------
	Centro de Custo
	--------------------------------------------*/	
	CTT->(MsSeek(xFilial("CTT")+aParcelas[1,23]))	
/*	--------------------------------------------
l	Item de Debito
	--------------------------------------------*/	
	CTD->(MsSeek(xFilial("CTD")+aParcelas[1,32]))	
/*	--------------------------------------------
	Fornecedor no Titulo
	--------------------------------------------*/	
	SA2->(MsSeek(xFilial("SA2")+aParcelas[1,5]+aParcelas[1,6]))

	oPrint:Say(nLin,930,Alltrim(SA2->A2_COD)+" - "+SA2->A2_LOJA+" - "+Alltrim(SA2->A2_NOME),oFontAr10n)
	nLin += 40
	
	If Len(Alltrim(SA2->A2_CGC)) > 11
		oPrint:Say(nLin,700,"CNPJ: ",oFontAr11)
		oPrint:Say(nLin,930,If(Empty(SA2->A2_CGC),"",Transform(SA2->A2_CGC,"@R 99.999.999/9999-99")),oFontAr10n)
	Else
		If !Empty(SA2->A2_CGC)
			oPrint:Say(nLin,700,"CPF: ",oFontAr11)
			oPrint:Say(nLin,930,If(Empty(SA2->A2_CGC),"",Transform(SA2->A2_CGC,"@R 999.999.999-99")),oFontAr10n)
		EndIf
	EndIf
	nLin += 40
	If lReimp		//cRotOrig == "RFINA02"
		oPrint:Say(nLin,1430,"Valor do Documento Fiscal - R$   "+Alltrim(Transform(nValorDoc,"@E 999,999,999.99")),oFontAr11n)
	ElseIf !lTitFT
		oPrint:Say(nLin,1430,"Valor do Documento Fiscal - R$   "+Alltrim(Transform(nValorDoc,"@E 999,999,999.99")),oFontAr11n)
	Else
		oPrint:Say(nLin,1430,"Valor do Documento Fiscal - R$   "+Alltrim(Transform(aDescri[Len(aDescri),2],"@E 999,999,999.99")),oFontAr11n)
	EndIf
	nLin += 40
	oPrint:Say(nLin,120,"Origem",oFontAr10)
	oPrint:Say(nLin,270,":     "+Alltrim(aParcelas[1,19])+" - "+Upper(Alltrim(Tabela("80",aParcelas[1,19],.f.))),oFontAr10n)
	nLin += 40
	oPrint:Say(nLin, 120,"Natureza",oFontAr10)
	oPrint:Say(nLin, 270,":     "+ Alltrim(aParcelas[1,9]) + " - "+Upper(Alltrim(SED->ED_DESCRIC)),oFontAr10n)
	oPrint:Say(nLin,1430,"Documento No.",oFontAr11)
	oPrint:Say(nLin,1730,":     "+aParcelas[1,2],oFontAr10n)
	oPrint:Say(nLin,1990,"Série:  ",oFontAr11)
	oPrint:Say(nLin,2110,aParcelas[1,1],oFontAr10n)
//	oPrint:Say(nLin,2120,"Tipo:  ",oFontAr11)
	oPrint:Say(nLin,2200,aParcelas[1,4],oFontAr10n)
	nLin += 40
	/*--- Implementado em 19/07/10 ---*/  
	If !Empty(aParcelas[1,23])
		oPrint:Say(nLin,0120,"C. Custo",oFontAr10)
		oPrint:Say(nLin, 270,":     "+ Alltrim(aParcelas[1,23]) + " - " + Upper(Alltrim(CTT->CTT_DESC01))+;
	  	If (!Empty(aParcelas[1,32])," | "+ "It.Déb.: "+Alltrim(aParcelas[1,32])+" - "+Upper(Alltrim(CTD->CTD_DESC01)),""),oFontAr9n)
	else
		//Caso nao exista C.Custo cadastrado no SE2 vai fazer uma busca no SD1
		cQSD1 := " SELECT distinct D1_CC, D1_ITEMCTA from SD1010 Where D_E_L_E_T_ = ' ' " 
		cQSD1 += " AND D1_FILIAL = '"+ aParcelas[1,1]+"' AND D1_DOC = '"+aParcelas[1,2]+"' "
		cQSD1 += " AND D1_FORNECE = '"+aParcelas[1,5]+"' AND D1_LOJA = '"+aParcelas[1,6]+"' " 
		cQSD1 += " ORDER BY 1, 2  " 
		if Select("TMPD1") > 0
			dbSelectArea("TMPD1")
			TMPD1->(dbCloseArea())
		endif
		dbUseArea(.T., "TOPCONN", TcGenQry(, , cQSD1), "TMPD1", .T., .T.)
		
		dbSelectArea('TMPD1')
		TMPD1->(dbGotop())
		aCcusto:= {}
		nCtCust:= 0
		cOldCC := "" //TMPD1->D1_CC
		while !TMPD1->(eof()) //.and.SD1->D1_FILIAL == xFilial('SD1') .and. SD1->D1_DOC == aParcelas[1,2] .and. SD1->D1_SERIE == aParcelas[1,1] .and. SD1->D1_FORNECE == aParcelas[1,5] .and. SD1->D1_LOJA == aParcelas[1,6]
			if cOldCC <> TMPD1->D1_CC
				aadd( aCCusto, {TMPD1->D1_CC, AllTrim(Posicione('CTT',1,xFilial('CTT')+TMPD1->D1_CC, "CTT_DESC01")), "FILIAL: ", AllTrim(TMPD1->D1_ITEMCTA)+", " } ) 
				nCtCust++
			else
				aCCusto[len(aCCusto),4] := aCCusto[len(aCCusto),4]+AllTrim(TMPD1->D1_ITEMCTA)+', '
			endif
			cOldCC := TMPD1->D1_CC
			TMPD1->(dbSkip())
		enddo
    
	    if nCtCust > 0 
	    	if nCtCust <= 3
	    		for i:=1 to len(aCCusto)
	    			oPrint:Say(nLin, 120,"C.C",oFontAr8)
					oPrint:Say(nLin, 260,"     :   "+ Alltrim(aCCusto[i,1])+ " - " + Upper(Alltrim(aCCusto[i,2]))+ " - "+aCCusto[i,3]+" "+aCCusto[i,4],oFontAr8)
					nLin += 30
				next i
	    	else
	    		ncount := 0
	    		cCC    := ""
	    		for i:=1 to len(aCCusto)
		    		cCC := cCC+Alltrim(aCCusto[i,1])+" "
		    		ncount++
//					oPrint:Say(nLin, 260,"     :   "+ Alltrim(aCCusto[i,1])+ " - " + Upper(Alltrim(aCCusto[i,2]))+ " - "+aCCusto[i,3]+" "+aCCusto[i,4],oFontAr8)
	    			if ncount == 10 .or. i == len(aCCusto) 
		    			oPrint:Say(nLin, 120,"C.Cs",oFontAr8)
		    			oPrint:Say(nLin, 190,cCC)
						nLin += 30		    			
						ncount := 0
						cCC := ""
		    		endif
				next i
	    	endif
	    
	    endif
	
	EndIf

	
	
	
	
	/*---*/	
	oPrint:Say(nLin,1430,"Emissão",oFontAr11)
	oPrint:Say(nLin,1730,":     "+cDtEmis,oFontAr10n)
	nLin += 40
	oPrint:Say(nLin,1430,"Processamento",oFontAr11)
	oPrint:Say(nLin,1730,":     "+cDtProc,oFontAr10n)
	nLin += 40
	oPrint:Say(nLin, 120,"Quant. Parcelas:",oFontAr11)
	oPrint:Say(nLin, 430,Alltrim(Transform(nQtdParcelas,"@E 999")),oFontAr10n)
	oPrint:Say(nLin, 650,"Vencimento Inicial: ",oFontAr11)
	oPrint:Say(nLin, 980,cDtVencI,oFontAr10n)
	oPrint:Say(nLin,1430,"Vencimento Final",oFontAr11)
	oPrint:Say(nLin,1730,":     "+cDtVencF,oFontAr10n)
	nLin += 70
	oPrint:Line(nLin,nColIni,nLin,nColFim)     
	oPrint:Line(nLin,1800,nLin+640,1800)     	//V
	nLin += 10
	oPrint:Say(nLin, 120,"Descrição",oFontAr10n)
	oPrint:Say(nLin,1820,"Valor do Documento R$",oFontAr10n)
	nLin += 50
	oPrint:Line(nLin,nColIni,nLin,nColFim)  		//H   
/*	-----------------------------------------------
	Impressao das linhas de descricao
	-----------------------------------------------*/
	nLinImp := 0
	If Len(aDescri) > 0
		For nCtd := 1 To Len(aDescri) 
			If nCtd < Len(aDescri) 	//  12 eh Numero de Linhas no espaço da descrição 
				If aDescri[nCtd,2] != Nil
					If aDescri[nCtd,2] > 0
						oPrint:Say(nLin,120,aDescri[nCtd,1],oFontAr10) 
						oPrint:Say(nLin,1820,Transform(aDescri[nCtd,2],"@E 999,999,999.99"),oFontAr10) 
					Else
						If lReimp
							oPrint:Say(nLin,120,aDescri[nCtd,1],oFontAr10)
						EndIf
					EndIf
				Else
					oPrint:Say(nLin,120,aDescri[nCtd,1],oFontAr10)
				EndIf
				nLin += 40
				nLinImp += 1
			Else
				For nCt := nLinImp To 12
					oPrint:Say(nLin,120,"",oFontAr10) 
					nLin += 40
                Next
                cHist1 := aParcelas[1,33]
                cHist2 := ""
                cHist3 := space(160)
                //Funcao para buscar as obsercacoes do pedido de compra
                if substr(aParcelas[1,33],5,6) >= '000000' .and. substr(aParcelas[1,33],5,6) <= '999999'                	
                	cHist3:= u_agobsped(cFilOrig,substr(aParcelas[1,33],5,6))
    			endif
                for iHist := 1 to len(aParcelas[1,33])
                	if Substr(aParcelas[1,33],iHist,12)=="APROV.NIV 02"
                		cHist1 := Substr(aParcelas[1,33],1,iHist-1)
                		cHist2 := Substr(aParcelas[1,33],iHist, len(aParcelas[1,33]) - iHist)
                		iHist := len(aParcelas[1,33])
                	endif
                next iHist
                
//                oPrint:Line(nlin-40,nColIni, nLin-40, 1700) //Coluna destinada a observacoes do pedido (Incluida por Anesio)
                oPrint:Say(nLin-150,120,cHist1, oFontAr10) // Imprimi a observacao1 incluida pelo usuario (particionado em 2)
                oPrint:Say(nLin-120,120,cHist2, oFontAr10)	//
                oPrint:Say(nLin-90,120,"OBS: "+substr(cHist3, 1,68), oFontAr10)	//
                oPrint:Say(nLin-60,120,substr(cHist3,69,72), oFontAr10)	//
				oPrint:Line(nLin,nColIni,nLin,nColFim)  	//H                   
				nLin += 10
				oPrint:Say(nLin,1250,"TOTAL LÍQUIDO A PAGAR R$",oFontAr10n)
				oPrint:Say(nLin,1820,Transform(aDescri[nCtd,2],"@E 999,999,999.99"),oFontAr10) 
			EndIf
	   	Next
    EndIf
	nLin += 50
	oPrint:Line(nLin,nColIni,nLin,nColFim)  	//H   
	oPrint:Line(nLin,1380,nLin+160,1380)  		//V   
	nLin += 10
	oPrint:Say(nLin, 120,"Depósito em Conta Bancária",oFontAr10n)
	oPrint:Say(nLin,1400,"Favorecido:",oFontAr10n)
	nLin += 50
	oPrint:Say(nLin, 120,"Banco: ",oFontAr11)
	oPrint:Say(nLin, 270,aParcelas[1,11],oFontAr10n)
	oPrint:Say(nLin, 420,"Agencia: ",oFontAr11)
	oPrint:Say(nLin, 600,aParcelas[1,12],oFontAr10n)
	oPrint:Say(nLin, 800,"Conta No.: ",oFontAr11)
	oPrint:Say(nLin,1000,aParcelas[1,13],oFontAr10n)
	oPrint:Say(nLin,1400,aParcelas[1,14],oFontAr10n)  //Nome Favorecido
	nLin += 50
	oPrint:Say(nLin, 120,"Tipo Conta: ",oFontAr11)
	oPrint:Say(nLin, 330,If(Empty(aParcelas[1,11]),"",If(aParcelas[1,15]=='1',"Corrente","Poupança")),oFontAr10n) //Tipo Conta
	oPrint:Say(nLin, 500,"Forma Pagamento: ",oFontAr11)
	oPrint:Say(nLin, 870,cFormaPag,oFontAr10n) //Forma Pagto
	If !Empty(aParcelas[1,16])
		If Len(Alltrim(aParcelas[1,16])) > 11
			oPrint:Say(nLin,1400,"CNPJ:  "+Transform(aParcelas[1,16],"@R 99.999.999/9999-99"),oFontAr10n)	//Cpf/Cnpj Favorecido
		Else
			If !Empty(aParcelas[1,16])
				oPrint:Say(nLin,1400,"CPF:  " +Transform(aParcelas[1,16],"@R 999.999.999-99"),oFontAr10n)	//Cpf/Cnpj Favorecido
			EndIf
		EndIf
	EndIf
	nLin += 50
	oPrint:Line(nLin,nColIni,nLin,nColFim)  		//H   
	oPrint:Say(nLin, 120,PadC("Anexo ao documento original",240),oFontAr9)
	oPrint:Line(1600, 120,1600, 800)  		//H   
	oPrint:Line(1600,1500,1600,2200)  		//H   
	oPrint:Say(1610, 120,"Emitente: "+Capital(aParcelas[1,21]),oFontAr10n)
	oPrint:Say(1610,1500,"Gestor da Unidade "+Capital(cUnidade),oFontAr10n)
	oPrint:Line(1680,nColIni,1680,nColFim)  		//H   
    /*-----------------*/
//	oPrint:Say(1700,nColIni,Replicate("-",240),oFontAr10)
/*	--------------------------------------------------------
	Imprime Slip para Financeiro - Parcelas - Contas a Pagar
	--------------------------------------------------------*/
	nSlip := 0
	nLin  := 1720   
	nLinF := 2530   //2560	//Quadro do primeiro slip ==> Tamanho do Slip em pixel --> 820

	For nCnt := 1 To Len(aParcelas) 
		cFormaPag := 	If(aParcelas[nCnt,22]=='1',"DOC/TED",;
						If(aParcelas[nCnt,22]=='2',"Boleto/DDA",;
						If(aParcelas[nCnt,22]=='3',"Cheque",;
						If(aParcelas[nCnt,22]=='4',"Caixa",;
						If(aParcelas[nCnt,22]=='5',"Cnab Folha",;
						If(aParcelas[nCnt,22]=='6',"Cartão Corporativo",""))))))

		SED->(MsSeek(xFilial("SED")+aParcelas[nCnt,9]))

	    /*---- Vencimento do Titulo ---*/
		cDtVencI:= GravaData(aParcelas[nCnt,7],.f.,5)                       
		cDtVencI:= Substr(cDtVencI,1,2)+"/"+Substr(cDtVencI,3,2)+"/"+Substr(cDtVencI,5,4)

		oPrint:Line(nLin,nColIni,nlin,nColFim)
		oPrint:Line(nLin,nColIni,nLinF,nColIni)     		//vertical
		oPrint:Line(nLin,1600,nLin+60,1600)     			//vertical
		oPrint:Line(nLin,nColFim,nLinF,nColFim)     		//vertical
		nLin += 10

		If !lReimp
			oPrint:Say(nLin,120,"AUTORIZAÇÃO DE PAGAMENTO No. "+Alltrim(Transform(Val(aParcelas[nCnt,17]),"@E 999,999,999"))+" - "+Alltrim(Transform(nCnt,"@E 99"))+"/"+;
				                                                 Alltrim(Transform(Len(aParcelas),"@E 999")),oFontAr12n)
		Else
			oPrint:Say(nLin,120,"AUTORIZAÇÃO DE PAGAMENTO No. "+Alltrim(Transform(Val(aParcelas[nCnt,17]),"@E 999,999,999"))+" - "+Alltrim(Transform(nCnt,"@E 99"))+"/"+;
			                                                    Alltrim(Transform(Len(aParcelas),"@E 999"))+ Space(3)+"( R )",oFontAr12n)
		EndIf
//		oPrint:Say(nLin,1610,"Unidade:  "+ CFILANT +" - "+Upper(cUnidade),oFontAr12n)
		oPrint:Say(nLin,1610,"Unidade:  "+ cFilOrig +" - "+Upper(cUnidade),oFontAr12n)
		nLin += 50
		oPrint:Line(nLin,nColIni,nLin,nColFim)     //Horizontal
		nLin += 20	//50  aki
		oPrint:SayBitmap(nLin,120,cLogo,239,100)
/*		--------------------------------------------
		Atualiza Fornecedor no Titulo
		--------------------------------------------*/	
		SA2->(MsSeek(xFilial("SA2")+aParcelas[nCnt,5]+aParcelas[nCnt,6]))	//fornece + loja
		
		oPrint:Say(nLin,700,"Fornecedor : ",oFontAr11)
		oPrint:Say(nLin,930,Alltrim(SA2->A2_COD)+" - "+SA2->A2_LOJA+" - "+Alltrim(SA2->A2_NOME),oFontAr10n)
		nLin += 40
		
		lForn := .F. 
		If Len(Alltrim(SA2->A2_CGC)) > 11
			oPrint:Say(nLin,700,"CNPJ: ",oFontAr11)
			oPrint:Say(nLin,930,If(Empty(SA2->A2_CGC),"",Transform(SA2->A2_CGC,"@R 99.999.999/9999-99")),oFontAr10n)
			lForn := .T.
		Else
			If !Empty(SA2->A2_CGC)
				oPrint:Say(nLin,700,"CPF: ",oFontAr11)
				oPrint:Say(nLin,930,If(Empty(SA2->A2_CGC),"",Transform(SA2->A2_CGC,"@R 99.999.999/9999-99")),oFontAr10n)
				lForn := .F. 
			EndIf
		EndIf
		nLin += 25  //40
		/*--- Calculo do Valor agregado ---*/
				  //TRB->E2_ACRESC    +TRB->E2_MULTA     + TRB->E2_JUROS    + TRB->E2_CORREC   - TRB->E2_DECRESC
		//nSomaX := aParcelas[nCnt,27]+aParcelas[nCnt,29]+aParcelas[nCnt,30]+aParcelas[nCnt,31]-aParcelas[nCnt,28]

		nSomaX := (aParcelas[nCnt,29]+aParcelas[nCnt,30]+aParcelas[nCnt,31]-aParcelas[nCnt,28])   //AOliveira 11-04-2011		

		oPrint:Say(nLin,1430,"Valor do Titulo (R) - R$  "+Alltrim(Transform(aParcelas[nCnt,20]+nSomaX- iif(lForn,nPisCofCsl,0),"@E 999,999,999.99")),oFontAr11n)
		if nPCCTOT == nPisCofCsl
			nPisCofCsl := 0
		endif
		nLin += 55	//40
		oPrint:Say(nLin, 120,"Origem",oFontAr10)
		oPrint:Say(nLin, 270,":     "+Alltrim(aParcelas[1,19])+" - "+Upper(Alltrim(Tabela("80",aParcelas[1,19],.f.))),oFontAr10n)
		oPrint:Say(nLin,1430,"Documento No.",oFontAr11)
		oPrint:Say(nLin,1680,":     "+aParcelas[nCnt,1]+Space(1)+aParcelas[nCnt,2]+"-"+aParcelas[nCnt,3]+Space(2)+aParcelas[nCnt,4],oFontAr10n)
		nLin += 40
		oPrint:Say(nLin,120,"Natureza",oFontAr10)
		oPrint:Say(nLin,270,":     "+ Alltrim(aParcelas[nCnt,9]) + " - "+Upper(Alltrim(SED->ED_DESCRIC)),oFontAr10n)
		oPrint:Say(nLin,1430,"Emissão",oFontAr11)
		oPrint:Say(nLin,1680,":     "+cDtEmis,oFontAr10n)
		nLin += 40
		/*--- Implementado em 19/07/10 ---*/
     	If !Empty(aParcelas[nCnt,23])
			oPrint:Say(nLin,0120,"C. Custo",oFontAr10)
			oPrint:Say(nLin, 270,":     "+ Alltrim(aParcelas[nCnt,23]) + " - " + Upper(Alltrim(CTT->CTT_DESC01))+;
	   		If (!Empty(aParcelas[nCnt,32])," | "+ "It.Déb.: "+Alltrim(aParcelas[nCnt,32])+" - "+Upper(Alltrim(CTD->CTD_DESC01)),""),oFontAr9n)
		EndIf

		oPrint:Say(nLin,1430,"Vencimento",oFontAr11)
		oPrint:Say(nLin,1680,":     "+cDtVencI,oFontAr10n)
		nLin += 70
		oPrint:Line(nLin,nColIni,nLin,nColFim)     
		oPrint:Line(nLin,370,nLin+60,370)     		//Vertical
		nLin += 10
		oPrint:Say(nLin, 120,"Histórico",oFontAr10n)
		oPrint:Say(nLin, 390,Upper(Alltrim(aParcelas[nCnt,10])),oFontAr11)
		nLin += 50
		oPrint:Line(nLin,nColIni,nLin,nColFim)  	//H   
		oPrint:Line(nLin,1380,nLin+160,1380)  		//V   
		nLin += 10
		oPrint:Say(nLin, 120,"Depósito em Conta Bancária",oFontAr10n)
		oPrint:Say(nLin,1400,"Favorecido:",oFontAr10n)
		nLin += 50
		oPrint:Say(nLin, 120,"Banco: ",oFontAr11)
		oPrint:Say(nLin, 270,aParcelas[nCnt,11],oFontAr10n)
		oPrint:Say(nLin, 420,"Agencia: ",oFontAr11)
		oPrint:Say(nLin, 600,aParcelas[nCnt,12],oFontAr10n)
		oPrint:Say(nLin, 800,"Conta No.: ",oFontAr11)
		oPrint:Say(nLin,1000,aParcelas[nCnt,13],oFontAr10n)
		oPrint:Say(nLin,1400,aParcelas[nCnt,14],oFontAr10n)  //Nome Favorecido
		nLin += 50
		oPrint:Say(nLin, 120,"Tipo Conta: ",oFontAr11)
		oPrint:Say(nLin, 330,If(Empty(aParcelas[nCnt,11]),"",If(aParcelas[nCnt,15]=='1',"Corrente","Poupança")),oFontAr10n) //Tipo Conta
		oPrint:Say(nLin, 500,"Forma Pagamento: ",oFontAr11)
		oPrint:Say(nLin, 870,cFormaPag,oFontAr10n) //Forma Pagto
	
		If !Empty(aParcelas[nCnt,16])
			If Len(Alltrim(aParcelas[nCnt,16])) > 11
				oPrint:Say(nLin,1400,"CNPJ:  "+Transform(aParcelas[nCnt,16],"@R 99.999.999/9999-99"),oFontAr10n)	//Cpf/Cnpj Favorecido
			Else
				If !Empty(aParcelas[nCnt,16])
					oPrint:Say(nLin,1400,"CPF:  "+Transform(aParcelas[nCnt,16],"@R 999.999.999-99"),oFontAr10n)	//Cpf/Cnpj Favorecido
				EndIf
			EndIf	
		EndIf
		nLin += 50
		oPrint:Line(nLin,nColIni,nLin,nColFim)  		//H   
		oPrint:Say(nLin, 500,PadC("     | Setor Financeiro - Contas a Pagar",240),oFontAr9)

		nLin += 5
        oPrint:Say(nLin,120,cHist1, oFontAr8) // Imprimi a observacao1 incluida pelo usuario (particionado em 2)
        nLin += 25
        oPrint:Say(nLin,120,cHist2, oFontAr8)
        nLin += 25
        oPrint:Say(nLin,120,"OBS: "+substr(cHist3, 1,68), oFontAr8)
        nLin += 25
        oPrint:Say(nLin,120,substr(cHist3,69,72), oFontAr8)
        nLin += 20
//		oPrint:Line(nLin,nColIni,nLin,nColFim)  	//H                   




		nLin += 60
//		nLin += 160
		oPrint:Line(nLin, 120,nLin,800)  		//H   
		oPrint:Line(nLin,1500,nLin,2200)  			//H   
		nLin += 10
		oPrint:Say(nLin, 120,"Emitente: "+Capital(aParcelas[nCnt,21]),oFontAr10n)
		oPrint:Say(nLin,1500,"Gestor da Unidade "+Capital(cUnidade),oFontAr10n)
		nLin += 70
		oPrint:Line(nLinF,nColIni,nLinF,nColFim)  		//Monta quadro do Slip   
		nLin += 50
/*		-----------------------------
		Controle de Impressão do Slip
		-----------------------------*/
		nSlip += 1
		If nFolha == 1
			If nSlip == 2
				oPrint:EndPage()
				nFolha+=1
				nLin  := 30		//100    
				nLinF := nLin + 810 //2530   //2560	//Quadro do primeiro slip ==> Tamanho do Slip em pixel --> 820
				nSlip := 0
			Else
				nLinF := nLinF + 860 //Tam do slip
			EndIf
		Else
			If nSlip = 4
				oPrint:EndPage()
				nFolha+=1
				nLin  := 30		//100    
				nLinF := nLin + 810 //2530   //2560	//Quadro do primeiro slip ==> Tamanho do Slip em pixel --> 820
				nSlip := 0
			Else
				nLinF := nLinF + 860 //Tam do slip
			EndIf
		EndIf
	Next  
	Exit
EndDo
oPrint:Preview()  		// Visualizar todos antes de enviar para impressora

Return
/*
----------------------------------------------------------------------
Funcao   : RFinR01Fat()
Descricao: Monta array com os titulos que compoem a  Fatura na rotina 
		   de Reimpressao da AP
----------------------------------------------------------------------*/
Static Function RFinR01Fat()
Local cQuery   := ""
Local cFatPref := TRB->E2_PREFIXO      
Local cNumFat  := TRB->E2_NUM
Local nCt      := 0
Local nColuna  := 1
Local cString  := ""

aDescri := {}

cQuery := " SELECT * FROM "  
cQuery += RetSqlName("SE2")+" SE2 "
cQuery += " WHERE " 
cQuery += " SE2.E2_FATPREF = '" + cFatPref + "' AND "   
cQuery += " SE2.E2_FATURA  = '" + cNumFat  + "' AND " 
cQuery += " SE2.D_E_L_E_T_ = ' '"  
cQuery += " ORDER BY SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO, SE2.E2_FORNECE, SE2.E2_LOJA"
cQuery := ChangeQuery(cQuery)          

If Select("TMPB") > 0
	DbSelectArea("TMPB")
	DbCloseArea("TMPB")
EndIf

                                         
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPB",.F.,.T.)
dbSelectArea("TMPB") 

aAdd(aDescri,{"JUNCAO DOS TITULOS EM FATURA",})

While TMPB->(!Eof()) 
	If nColuna > 44
		Exit        // Sai do Looping
	EndIf   

	If nColuna < 4 
		cString += TMPB->E2_PREFIXO+Space(1)+Alltrim(TMPB->E2_NUM)+"-"+TMPB->E2_PARCELA+Space(2)+TMPB->E2_TIPO+" | "

		If nColuna == 4
			aAdd(aDescri,{cString,})
		
			cString := ""  
			nColuna := 1		
		Else
	  		nColuna += 1
		EndIf
	Else             
		cString += TMPB->E2_PREFIXO+Space(1)+Alltrim(TMPB->E2_NUM)+"-"+TMPB->E2_PARCELA+Space(2)+TMPB->E2_TIPO
		aAdd(aDescri,{cString,})  		
		
		cString := ""
		nColuna := 1
	EndIf

	TMPB->(dbSkip())
EndDo
If !Empty(cString)
	aAdd(aDescri,{cString,})  		
EndIf

Return




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Funcao para identificar se dedus o PIS, COFINS e CSLL na AP
//Trabalha em conjunto com o parametro MV_BX10925 - se for igual a 1 a funcao é valida
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
user function VerSeDeduz(cForn, cLoja, dVencRea, cDuplicAtu)
local lRet 			:= 0
local _cForn 		:= cForn
local _cLoja 		:= cLoja
local _cVencRea 	:= DTOS(dVencRea)
local _cDuplicAtu 	:= cDuplicAtu //Essa variável contem o PREFIXO (primeiros 3 digitos) + NUMERO DA DUPLICATA (Registros de 4 a 12
local cQSA2 		:= ""
local cQSE2 		:= ""
local cCGC  		:= ""
local cFornLj 		:= ""


public nVretPCC 	:= 0

//Alert('Numero AP: '+cNumAP)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Monta a query para pegar o CGC do Fornecedor
cQSA2 := " SELECT Substring(A2_CGC,1,8) A2_CGC FROM SA2010 where D_E_L_E_T_ = ' ' AND A2_COD = '"+_cForn+"' AND A2_LOJA = '"+_cLoja+"' "
if Select('TMPA2') > 0
	dbSelectArea('TMPA2')
	dbCloseArea('TMPA2')
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQSA2), 'TMPA2', .T., .T.)

dbSelectArea('TMPA2')
TMPA2->(dbGotop())
cCGC := TMPA2->A2_CGC

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Monta a query para todos os Codigos do grupo de CNPJ (8 primeiros caracteres)
cQSA2 := " SELECT A2_COD, A2_LOJA FROM SA2010 WHERE D_E_L_E_T_  = ' ' AND SUBSTRING(A2_CGC,1,8) = '"+cCGC+"' "
if Select('TMPA2') > 0
	dbSelectArea('TMPA2')
	dbCloseArea('TMPA2')
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQSA2), 'TMPA2', .T., .T.)

dbSelectArea('TMPA2')
TMPA2->(dbGotop())
while !TMPA2->(eof())
	cFornLj := cFornLj+ "'"+TMPA2->(A2_COD+A2_LOJA)+"',"
	TMPA2->(dbSkip())
enddo

cFornLj := Substr(cFornLj,1, Len(cFornLj)-1)


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Verifica se ja existe retencao para o fornecedor no mes do vencimento da parcela...
//Caso já houve retenção no periodo a rotina deve informar na AP apenas o valor devido da duplicata corrente...
/*cQSE2VRET := " SELECT SUM(E2_BASEPIS) E2_BASEPIS, SUM(E2_PIS) E2_PIS, SUM(E2_COFINS) E2_COFINS, SUM(E2_CSLL) E2_CSLL, "
cQSE2VRET += " SUM(E2_VRETPIS) E2_VRETPIS, SUM(E2_VRETCOF) E2_VRETCOF, SUM(E2_VRETCSL) E2_VRETCSL "
cQSE2VRET += "  FROM SE2010 " 
cQSE2VRET += " WHERE D_E_L_E_T_ = ' ' AND E2_FORNECE+E2_LOJA in ("+cFornLj+") "
cQSE2VRET += " AND E2_VRETPIS > 0  "
cQSE2VRET += " AND SUBSTRING(E2_BAIXA,1,6) = '"+_cVencRea+"' " 
cQSE2VRET += " AND E2_X_NUMAP <= '"+cNumAP+"' "

if Select("TMPVR") > 0
	dbSelectArea("TMPVR")
	TMPVR->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQSE2VRET), 'TMPVR', .T., .T.)
dbSelectArea("TMPVR")
TMPVR->(dbGotop())
nCtVr := 0
if !TMPVR->(eof())
	nCtVr := TMPVR->E2_BASEPIS
endif

//Caso já exista retenção encerra a pesquisa e retorna com 1 para pegar o valor da duplicata corrente....
if nCtVr > 0 
	lRet := 1 // Retornando 1 significa que deverá pegar o valor de retenção da duplicata corrente.
	Return lRet 
endif
  */
  


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Caso nao exista retenção já registrado no mes, o sistema fará um calculo para identificar se do total a reter referente as
//duplicatas anteriores menos a duplicata atual é superior a 5000 mil, caso positivo será considerado que já provisionou em APs anteriores
//E fará a retençao apenas a duplicata atual.
//Caso não seja menor, o sistema vai reter na duplicata atual o valor total devido de todas as anteriores.
cQSE2 := " SELECT SUM(E2_BASEPIS) E2_BASEPIS, SUM(E2_PIS) E2_PIS, SUM(E2_COFINS) E2_COFINS, SUM(E2_CSLL) E2_CSLL "
cQSE2 += "  FROM SE2010 " 
cQSE2 += " WHERE D_E_L_E_T_ = ' ' AND E2_FORNECE+E2_LOJA in ("+cFornLj+") "
cQSE2 += " AND E2_BASEPIS > 0  AND E2_PIS > 0 "
cQSE2 += " AND E2_VENCREA = '"+_cVencRea+"' " 
cQSE2 += " AND E2_PREFIXO+E2_NUM <> '"+_cDuplicAtu+"' "
//cQSE2 += " AND E2_X_NUMAP <= '"+cNumAp+"' "

if Select("TMPPCC") > 0
	dbSelectArea("TMPPCC")
	TMPPCC->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQSE2), 'TMPPCC', .T., .T.)
dbSelectArea("TMPPCC")
TMPPCC->(dbGotop())
if !TMPPCC->(eof())
	if TMPPCC->E2_BASEPIS > 215
		lRet := 2 	// Retornando 2 significa que deverá pegar o valor de retenção da duplicata corrente.
					// Semelhante ao código 1 
		Return lRet
	endif
endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Caso a soma das duplicatas acima sejam menores que 5mil, o sistema fará a soma total das duplicatas para compor o valor da retenção/*
cQSE2 := " SELECT SUM(E2_BASEPIS) E2_BASEPIS, SUM(E2_PIS) E2_PIS, SUM(E2_COFINS) E2_COFINS, SUM(E2_CSLL) E2_CSLL "
cQSE2 += "  FROM SE2010 " 
cQSE2 += " WHERE D_E_L_E_T_ = ' ' AND E2_FORNECE+E2_LOJA in ("+cFornLj+") "
cQSE2 += " AND E2_BASEPIS > 0  and E2_PIS > 0 "
cQSE2 += " AND E2_VENCREA = '"+_cVencRea+"' " 
cQSE2 += " AND E2_X_NUMAP <= '"+cNumAp+"' "

if Select("TMPPCC") > 0
	dbSelectArea("TMPPCC")
	TMPPCC->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQSE2), 'TMPPCC', .T., .T.)
dbSelectArea("TMPPCC")
TMPPCC->(dbGotop())
if !TMPPCC->(eof())
	if TMPPCC->E2_BASEPIS > 215.27
		lRet := 3 // Retornando 3 significa que deverá pegar o valor total de retenção do mes
		nVRetPCC := TMPPCC->(E2_PIS+E2_COFINS+E2_CSLL)
	else
		lRet := 4 // Retornando 4 significa que não deverá haver retenção
	endif
endif
return lRet

//Funcao para retornar o histórico do pedido de compras
user function agobsped(cFilOrig,cNumPed)
local cHist := ""
cQuery := " SELECT distinct C7_OBS from SC7010 where D_E_L_E_T_ = ' ' and C7_FILIAL = '"+cFilOrig+"' and C7_NUM = '"+cNumPed+"' "

if Select("HIST") > 0 
	dbSelectArea("HIST")
	HIST->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "HIST", .T., .T.)

	dbSelectArea("HIST")
	HIST->(dbGotop())
	while !HIST->(eof())
		cHist:= cHist+Alltrim(HIST->C7_OBS)+","
		HIST->(dbSkip())
	enddo	

if len(cHist) > 140
	cHist := Substr(cHist,1,140)
else
	cHist := cHist+space(140-len(cHist))
endif

return cHist