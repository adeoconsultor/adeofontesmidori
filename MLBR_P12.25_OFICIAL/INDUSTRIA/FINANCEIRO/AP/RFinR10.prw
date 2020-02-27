#include "RWMAKE.CH"
#include "PROTHEUS.CH"
#Include "RptDef.ch"
#Include "FWPrintSetup.ch"
#Include "Font.ch"
#Include "TopConn.ch"
/*
-----------------------------------------------------------------------------
Programa  : RFinR10
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
*/

User Function RFR10(aTit,aDesc,xRotina,_cFiltro)
Local wnrel
Local tamanho		:= "G"
Local titulo		:= "Autorização de Pagamento"
Local cDesc1		:= "Impressão de AP's "
Local cDesc2		:= ""
Local aSays     	:= {}, aButtons := {}, nOpca := 0

//Private cAPNum      := If(FunName() $ "MATA103",SF1->F1_X_NUMAP,cExpr1)
Private _aArea      := GetArea()
Private nomeprog 	:= "RFINR10"
Private nLastKey 	:= 0
Private cPerg    	:= "RFINR10"
Private oPrint
Private aDadosTit   := aTit
Private aDescri     := aDesc		//If(aDesc==Nil,Nil,aDesc)
Private lTitFT      := IIf(Valtype(aDesc)=="A",.F.,.T.)    //lTitFT = .T. -->titulo tipo "FT", senao conteudo de aDesc eh um array
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


Private cLocal          := "D:\Temp\"
Private lAdjustToLegacy := .T.
Private lDisableSetup   := .T.
/*
oPrint:=TMSPrinter():New()
oPrint:SetPortrait()
oPrint:SetPaperSize(9)
*/

//oPrint := FWMSPrinter():New('orcamento_000000.PD_', IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
oPrint := FWMSPrinter():New(nomeprog+'.PD_', IMP_PDF, lAdjustToLegacy) //,cLocal, lDisableSetup, , , , , , .F., )
     
oPrint:StartPage() 
oPrint:SetPortrait() //Define a orientação do relatório como retrato
oPrint:setPaperSize( 9 ) //Tamanho da Folha A4
oPrint:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior

//ApMsgAlert("Tecle OK para imprimir a Autorização de Pagamento...")

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

RptStatus({|lEnd| RFinR01Proc(xRotina)},Titulo) // - Diego

/*------------------------------------------------------------------
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

Private cLogo   :=  GetSrvProfString('Startpath','') +'lgrl'+Alltrim(cEmpAnt) + '.BMP'  //"\system\lgrl01.bmp"
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

Private _nMulta := 0
Private _nJuros := 0 
Private _nCMonetario := 0
Private _nDesc := 0



Public cNumAp   := adadosTit[1][7]

/*
--------------------------------------------
Reimpressão de AP
--------------------------------------------*/
If cRotOrig == "RFINA02"
	//lReimp := .T.
	lReimp := IIf(Alltrim(SZW->ZW_STATUS) $ 'C|D',.T.,.F.)
	
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
		RFat() //Monta array com os titulos que compoem a  Fatura na rotina8
	EndIf
	//	nPisCofCsl := 0
	nTotRet := 0
	//While TRB->(!Eof()) .And. xFilial("SE2") == TRB->E2_FILIAL .And. TRB->E2_PREFIXO == cPrefixo .And. TRB->E2_NUM == cNumTit .And. TRB->E2_X_NUMAP == cNumAP
	TRB->(DbGoTop())
	While !TRB->(Eof()) .And. TRB->E2_X_NUMAP == cNumAP
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
		    /*
			DbSelectArea("SE2")
			RecLock("SE2",.F.)
			SE2->E2_X_FLAG  := "2"		//Re-Impresso
			SE2->(MsUnlock())
			 */
			if SE2->(E2_PIS+E2_COFINS+E2_CSLL) > 0
				////////////////////////////////////////////////////////////////////////////////////////////////
				//				Alert('Numero da AP: |'+cNumAp+'|'+cValToChar(len(cNumAp)))
				nDeduz := VerSeDeduz(SE2->E2_FORNECE, SE2->E2_LOJA, SE2->E2_VENCREA, SE2->(E2_PREFIXO+E2_NUM))
				////////////////////////////////////////////////////////////////////////////////////////////////
				//Caso o valor retornado seja 1 ou 2 o valor a ser deduzido é apenas da duplicata corrente
				if nDeduz == 1 .or. nDeduz == 2
					nPisCofCsl :=  SE2->(E2_PIS+E2_COFINS+E2_CSLL)
					nPis :=  SE2->E2_PIS
					nCof :=  SE2->E2_COFINS
					nCsl :=  SE2->E2_CSLL
					nPCCTOT += SE2->(E2_PIS+E2_COFINS+E2_CSLL)
				elseif nDeduz == 3
					nPisCofCsl := nVRetPCC
					nPis :=  aVRetPCC[1] //SE2->E2_PIS
					nCof :=  aVRetPCC[1] //SE2->E2_COFINS
					nCsl :=  aVRetPCC[1] //SE2->E2_CSLL					
					nPCCTOT += SE2->(E2_PIS+E2_COFINS+E2_CSLL)
				elseif nDeduz == 4
					nPisCofCsl :=  SE2->(E2_PIS+E2_COFINS+E2_CSLL)
					nPis :=  SE2->E2_PIS
					nCof :=  SE2->E2_COFINS
					nCsl :=  SE2->E2_CSLL
					nPCCTOT += SE2->(E2_PIS+E2_COFINS+E2_CSLL)
				endif
				/////////////////////////////////////////////////////////////////////////////////////////////
				//Verificar o tipo de mensagem a ser adicionada...
				if nDeduz == 1 .or. nDeduz == 2
					//aAdd(aDescri, {"(-) DEDUCAO DE PIS, COFINS E CSLL", nPisCofCsl})
					aAdd(aDescri, {"(-) DEDUCAO DE PIS", nPis})
					aAdd(aDescri, {"(-) DEDUCAO DE COFINS", nCof})
					aAdd(aDescri, {"(-) DEDUCAO DE CSLL", nCsl})
				elseif nDeduz == 3
					//aAdd(aDescri, {"(-) DEDUCAO DE PIS, COFINS E CSLL (VALORES COMPOSTOS COM OUTRAS NOTAS)", nPisCofCsl}) 
					aAdd(aDescri, {"(-) DEDUCAO DE PIS (VALORES COMPOSTOS COM OUTRAS NOTAS)", nPis}) 
					aAdd(aDescri, {"(-) DEDUCAO DE COFINS (VALORES COMPOSTOS COM OUTRAS NOTAS)", nCof}) 
					aAdd(aDescri, {"(-) DEDUCAO DE CSLL (VALORES COMPOSTOS COM OUTRAS NOTAS)", nCsl}) 
				else
					//aAdd(aDescri, {"(-) INFORMATIVO DE PIS, COFINS E CSLL (SEM DEDUÇÃO NESSE MOMENTO) ", nPisCofCsl}) 
					aAdd(aDescri, {"(-) INFORMATIVO DE PIS (SEM DEDUÇÃO NESSE MOMENTO) ", nPis}) 
					aAdd(aDescri, {"(-) INFORMATIVO DE COFINS (SEM DEDUÇÃO NESSE MOMENTO) ", nCof}) 
					aAdd(aDescri, {"(-) INFORMATIVO DE CSLL (SEM DEDUÇÃO NESSE MOMENTO) ", nCsl}) 
				
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
		_nDesc := 0
		_nMulta := 0
		_nJuros := 0
		_nCMonetario := 0 //Aoliveira
		
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
	
	If lSZFOk
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
			
			DbSElectArea("SE2")
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
				SE2->E2_X_NOMFV := Iif(Empty(cBcoFv),"",cNomFv)
				SE2->E2_X_CPFFV := Iif(Empty(cBcoFv),"",cCpfFv)
				SE2->E2_X_TPCTA := cTpCta
				SE2->E2_X_FPAGT := cFPagt
				
				if SE2->(E2_PIS+E2_COFINS+E2_CSLL) > 0
					////////////////////////////////////////////////////////////////////////////////////////////////
					nDeduz := VerSeDeduz(SE2->E2_FORNECE, SE2->E2_LOJA, SE2->E2_VENCREA, SE2->(E2_PREFIXO+E2_NUM))
					////////////////////////////////////////////////////////////////////////////////////////////////
					//Caso o valor retornado seja 1 ou 2 o valor a ser deduzido é apenas da duplicata corrente
					if nDeduz == 1 .or. nDeduz == 2
						nPisCofCsl :=  SE2->(E2_PIS+E2_COFINS+E2_CSLL)
						nPis :=  SE2->E2_PIS
						nCof :=  SE2->E2_COFINS
						nCsl :=  SE2->E2_CSLL						
					elseif nDeduz == 3
						nPisCofCsl := nVRetPCC
						nPis :=  aVRetPCC[1] //SE2->E2_PIS
						nCof :=  aVRetPCC[2] //SE2->E2_COFINS
						nCsl :=  aVRetPCC[3] //SE2->E2_CSLL											
					elseif nDeduz == 4
						nPisCofCsl :=  SE2->(E2_PIS+E2_COFINS+E2_CSLL)
						nPis :=  SE2->E2_PIS
						nCof :=  SE2->E2_COFINS
						nCsl :=  SE2->E2_CSLL
					endif
					/////////////////////////////////////////////////////////////////////////////////////////////
					//Verificar o tipo de mensagem a ser adicionada...
					if nDeduz == 1 .or. nDeduz == 2
						//aAdd(aDescri, {"(-) DEDUCAO DE PIS, COFINS E CSLL", nPisCofCsl})
						aAdd(aDescri, {"(-) DEDUCAO DE PIS", nPis})
						aAdd(aDescri, {"(-) DEDUCAO DE COFINS", nCof})
						aAdd(aDescri, {"(-) DEDUCAO DE CSLL", nCsl})
					elseif nDeduz == 3
						//aAdd(aDescri, {"(-) DEDUCAO DE PIS, COFINS E CSLL (VALORES COMPOSTOS COM OUTRAS NOTAS)", nPisCofCsl})
						aAdd(aDescri, {"(-) DEDUCAO DE PIS (VALORES COMPOSTOS COM OUTRAS NOTAS)", nPis})
						aAdd(aDescri, {"(-) DEDUCAO DE COFINS (VALORES COMPOSTOS COM OUTRAS NOTAS)", nCof})
						aAdd(aDescri, {"(-) DEDUCAO DE CSLL (VALORES COMPOSTOS COM OUTRAS NOTAS)", nCsl})
					else
						//aAdd(aDescri, {"(-) INFORMATIVO DE PIS, COFINS E CSLL (SEM DEDUÇÃO NESSE MOMENTO) ", nPisCofCsl})
						aAdd(aDescri, {"(-) INFORMATIVO DE PIS (SEM DEDUÇÃO NESSE MOMENTO) ", nPis})
						aAdd(aDescri, {"(-) INFORMATIVO DE COFINS (SEM DEDUÇÃO NESSE MOMENTO) ", nCof})
						aAdd(aDescri, {"(-) INFORMATIVO DE CSLL (SEM DEDUÇÃO NESSE MOMENTO) ", nCsl})
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
			SE2->(MsUnlock())
			
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
Local xY, i, nCt, iHist, nCtd, nCnt, X  

Local cFileLogo  := GetSrvProfString('Startpath','') +'lgrl'+Alltrim(cEmpAnt) + '.BMP'

Private aQdrs   := {}
Private aText   := {}
Private aLines  := {}
Private aLogo   := {}

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
cFormaPag := 	Iif(aParcelas[1,22]=='1',"DOC/TED",;
				Iif(aParcelas[1,22]=='2',"Boleto/DDA",;
				Iif(aParcelas[1,22]=='3',"Cheque",;
				Iif(aParcelas[1,22]=='4',"Caixa",;
				Iif(aParcelas[1,22]=='5',"Cnab Folha",;
				Iif(aParcelas[1,22]=='6',"Cartão Corporativo",""))))))

//Box
//Cordenadas dos quadros principais 
         //{nLIni , nColIni, nLiFim, nColFim} 
AAdd(aQdrs,{ 00.25, 00.85, 00.75, 13.55 })   // Quadro 01  
AAdd(aQdrs,{ 00.25, 13.55, 00.75, 19.50 })   // Quadro 02  
AAdd(aQdrs,{ 00.75, 00.85, 04.40, 19.50 })   // Quadro 03 
AAdd(aQdrs,{ 04.40, 00.85, 04.90, 15.25 })   // Quadro 04  
AAdd(aQdrs,{ 04.40, 15.25, 04.90, 19.50 })   // Quadro 05
AAdd(aQdrs,{ 04.90, 00.85, 09.30, 15.25 })   // Quadro 06  
AAdd(aQdrs,{ 04.90, 15.25, 09.30, 19.50 })   // Quadro 07 
AAdd(aQdrs,{ 09.30, 00.85, 09.85, 15.25 })   // Quadro 08
AAdd(aQdrs,{ 09.30, 15.25, 09.85, 19.50 })   // Quadro 09
AAdd(aQdrs,{ 09.85, 00.85, 11.20, 11.70 })   // Quadro 10  
AAdd(aQdrs,{ 09.85, 11.68, 11.20, 19.50 })   // Quadro 11  
AAdd(aQdrs,{ 11.20, 00.85, 14.25, 19.50 })   // Quadro 12  
AAdd(aQdrs,{ 14.55, 00.85, 15.05, 13.55 })   // Quadro 13  
AAdd(aQdrs,{ 14.55, 13.55, 15.05, 19.50 })   // Quadro 14  
AAdd(aQdrs,{ 15.05, 00.85, 17.55, 19.50 })   // Quadro 15  
AAdd(aQdrs,{ 17.55, 00.85, 18.15, 03.15 })   // Quadro 16  
AAdd(aQdrs,{ 17.55, 03.15, 18.15, 19.50 })   // Quadro 17 
AAdd(aQdrs,{ 18.15, 00.85, 19.45, 11.70 })   // Quadro 18  
AAdd(aQdrs,{ 18.15, 11.70, 19.45, 19.50 })   // Quadro 19  
AAdd(aQdrs,{ 19.45, 00.85, 21.45, 19.50 })   // Quadro 20  

AAdd(aLogo,{ 01.15, 01.00, 01.45, 04.40 })
AAdd(aLogo,{ 15.35, 01.00, 15.60, 04.40 })
	
//Imprimindo Quadros principais.
For xY:= 1 To Len(aQdrs)
	nLinIn := 0
	nColIn := 0
	nLinFi := 0
	nColFi := 0
	
	nLinIn := CMtoPX( aQdrs[xY][1] )
	nColIn := CMtoPX( aQdrs[xY][2] )
	nLinFi := CMtoPX( aQdrs[xY][3] )
	nColFi := CMtoPX( aQdrs[xY][4] )
	                                           
	oPrint:Box( nLinIn,nColIn,nLinFi,nColFi )
	
Next xY 

//Imprimindo Logo
For xY:= 1 To Len(aLogo)  

	nLinIn := 0
	nColIn := 0
	nLinFi := 0
	nColFi := 0

	nLinIn := CMtoPX( aLogo[xY][1] )
	nColIn := CMtoPX( aLogo[xY][2] )
	nLinFi := CMtoPX( aLogo[xY][3] )
	nColFi := CMtoPX( aLogo[xY][4] )
		
	nTop    := CMtoPX( aLogo[xY][1] ) //
	nLeft   := CMtoPX( aLogo[xY][2] ) //
	nBottom := CMtoPX( aLogo[xY][3] ) //
	nRight  := CMtoPX( aLogo[xY][4] ) //
	
	//nTop, nLeft, nBottom, nRight
	oPrint:SayBitmap( nLinIn, nColIn, cFileLogo, (nColFi-nColIn), (nLinFi-nLinIn))
		
Next xY  

While .T.

	AAdd(aText,{ 00.65 , 01.00 ,"AUTORIZAÇÃO DE PAGAMENTO No. "+Alltrim(Transform(Val(SZW->ZW_NUMAP),"@E 999,999,999"))+ Space(3)+  IIf(Alltrim(SZW->ZW_STATUS) $ 'C|D', "( R )" , " " )  ,oFontAr12n })
    AAdd(aText,{ 00.65 , 13.70 ,"Unidade:  "+ cFilOrig +" - "+Upper(cUnidade) ,oFontAr12n })
	AAdd(aText,{ 01.50 , 04.95 ,"Fornecedor:" ,oFontAr11 })
		
	//Centro de Custo
	CTT->(MsSeek(xFilial("CTT")+aParcelas[1,23]))
	
	// l	Item de Debito                       
	CTD->(MsSeek(xFilial("CTD")+aParcelas[1,32]))

	// Fornecedor no Titulo
	SA2->(MsSeek(xFilial("SA2")+aParcelas[1,5]+aParcelas[1,6]))
	AAdd(aText,{ 01.50 , 06.90 ,Alltrim(SA2->A2_COD)+" - "+SA2->A2_LOJA+" - "+Alltrim(SA2->A2_NOME),oFontAr10n })
	
	If Len(Alltrim(SA2->A2_CGC)) > 11
		AAdd(aText,{ 01.85 , 04.95 ,"CNPJ:" ,oFontAr11 })                                     
		AAdd(aText,{ 01.85 , 06.90 ,IIf(Empty(SA2->A2_CGC),"",Transform(SA2->A2_CGC,"@R 99.999.999/9999-99")) ,oFontAr10n })                                     
	Else
		If !Empty(SA2->A2_CGC)
			AAdd(aText,{ 01.85 , 04.95 ,"CPF: " ,oFontAr11 })                                     
			AAdd(aText,{ 01.85 , 06.90 ,IIf(Empty(SA2->A2_CGC),"",Transform(SA2->A2_CGC,"@R 999.999.999-99")) ,oFontAr10n })                                     
		EndIf
	EndIf
	
	If lReimp		//cRotOrig == "RFINA02"
		AAdd(aText,{ 02.20 , 12.05 ,"Valor do Documento Fiscal - R$   "+Alltrim(Transform(nValorDoc,"@E 999,999,999.99")) ,oFontAr11n })
	ElseIf !lTitFT
		AAdd(aText,{ 02.20 , 12.05 ,"Valor do Documento Fiscal - R$   "+Alltrim(Transform(nValorDoc,"@E 999,999,999.99")) ,oFontAr11n })
	Else
		AAdd(aText,{ 02.20 , 12.05 ,"Valor do Documento Fiscal - R$   "+Alltrim(Transform(aDescri[Len(aDescri),2],"@E 999,999,999.99")) ,oFontAr11n })

	EndIf
	
	AAdd(aText,{ 02.55 , 01.00 ,"Origem " ,oFontAr10 })
	AAdd(aText,{ 02.55 , 02.80 ,":     "+Alltrim(aParcelas[1,19])+" - "+Upper(Alltrim(Tabela("80",aParcelas[1,19],.f.))),oFontAr10n })

	AAdd(aText,{ 02.90 , 01.00 ,"Natureza" ,oFontAr10 }) 
	AAdd(aText,{ 02.90 , 02.80 ,":     "+ Alltrim(aParcelas[1,9]) + " - "+Upper(Alltrim(SED->ED_DESCRIC)),oFontAr10n }) 
	
	AAdd(aText,{ 02.90 , 12.05 ,"Documento No." ,oFontAr11 })
	AAdd(aText,{ 02.90 , 14.80 ,":  "+aParcelas[1,2],oFontAr10n })

	AAdd(aText,{ 02.90 , 16.90 ,"Série",oFontAr11 })	
	AAdd(aText,{ 02.90 , 17.80 ,aParcelas[1,1]+" "+aParcelas[1,4],oFontAr10n })	

	/*--- Implementado em 19/07/10 ---*/
	If !Empty(aParcelas[1,23])

		AAdd(aText,{ 03.25 , 01.00 ,"C.C" ,oFontAr10 })
		AAdd(aText,{ 03.25 , 02.80 ,":     "+ Alltrim(aParcelas[1,23]) + " - " + Upper(Alltrim(CTT->CTT_DESC01))+;
		IIf (!Empty(aParcelas[1,32])," | "+ "It.Déb.: "+Alltrim(aParcelas[1,32])+" - "+Upper(Alltrim(CTD->CTD_DESC01)),""),oFontAr9n })
		
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
				_nLin  := 03.25
				for i:=1 to len(aCCusto)
		            If i == 1
						AAdd(aText,{ _nLin , 01.00 ,"C.C",oFontAr8 })
					EndIf
					AAdd(aText,{ _nLin , 02.80 ,"     :   "+ Alltrim(aCCusto[i,1])+ " - " + Upper(Alltrim(aCCusto[i,2]))+ " - "+aCCusto[i,3]+" "+aCCusto[i,4],oFontAr8 })
					_nLin += 0.30
				next i
			else
				ncount := 0
				cCC    := "" 
				_nLin  := 03.25
				
				for i:=1 to len(aCCusto)     
					If i == 1
						AAdd(aText,{ _nLin , 01.00 ,"C.Cs",oFontAr8 })
					Endif
					cCC := cCC+Alltrim(aCCusto[i,1])+" "
					ncount++
					//					//oPrint:Say(nLin, 260,"     :   "+ Alltrim(aCCusto[i,1])+ " - " + Upper(Alltrim(aCCusto[i,2]))+ " - "+aCCusto[i,3]+" "+aCCusto[i,4],oFontAr8)
					if ncount == 10 .or. i == len(aCCusto)     
						//AAdd(aText,{ 03.25 , 01.00 ,"C.Cs",oFontAr8 })
						AAdd(aText,{ _nLin , 02.80 ,"     :   "+cCC ,oFontAr8 })					
					    _nLin += 0.30
						ncount := 0
						cCC := ""
					endif
				next i
			endif
			
		endif
		
	EndIf
	
	/*---*/        
	AAdd(aText,{ 03.60 , 12.05 ,"Emissão" ,oFontAr11 }) 
	AAdd(aText,{ 03.60 , 14.80 ,":  "+cDtEmis,oFontAr10n }) 
	
	AAdd(aText,{ 03.95 , 12.05 ,"Processamento" ,oFontAr11 })
	AAdd(aText,{ 03.95 , 14.80 ,":  "+cDtProc,oFontAr10n })
	
	AAdd(aText,{ 04.30 , 12.05 ,"Vencimento Final" ,oFontAr11 }) 
	AAdd(aText,{ 04.30 , 14.80 ,":  "+cDtVencF,oFontAr10n }) 

	AAdd(aText,{ 04.30 , 01.00 ,"Quant. Parcelas"   ,oFontAr11 })
	AAdd(aText,{ 04.30 , 03.80 ,Alltrim(Transform(nQtdParcelas,"@E 999")),oFontAr10n })

	AAdd(aText,{ 04.30 , 05.50 ,"Vencimento Inicial" ,oFontAr11 }) 
	AAdd(aText,{ 04.30 , 08.40 ,cDtVencI,oFontAr10n }) 
           
	AAdd(aText,{ 04.80 , 01.00 ,"Descrição " ,oFontAr10n })
	AAdd(aText,{ 04.80 , 15.40 ,"Valor do Documento R$" ,oFontAr10n }) 

	/*	-----------------------------------------------
	Impressao das linhas de descricao
	-----------------------------------------------*/
	nLinImp := 0
	If Len(aDescri) > 0             
	    _nLin := 5.25
		For nCtd := 1 To Len(aDescri)
			If nCtd < Len(aDescri) 	//  12 eh Numero de Linhas no espaço da descrição
				If aDescri[nCtd,2] != Nil
					If aDescri[nCtd,2] > 0   
					
						AAdd(aText,{ _nLin , 01.00 ,aDescri[nCtd,1],oFontAr10 })
						AAdd(aText,{ _nLin , 15.40 ,Transform(aDescri[nCtd,2],"@E 999,999,999.99"),oFontAr10 })   
						_nLin += 0.35					
					Else
						If lReimp 
							AAdd(aText,{ _nLin , 01.00 ,aDescri[nCtd,1],oFontAr10 })
							_nLin += 0.35
						EndIf
					EndIf
				Else
					AAdd(aText,{ _nLin , 01.00 ,aDescri[nCtd,1],oFontAr10 }) 
					_nLin += 0.35
				EndIf
				
				nLinImp += 1
			Else
				For nCt := nLinImp To 12
					//oPrint:Say(nLin,120,"",oFontAr10)
					
				Next
				cHist1 := aParcelas[1,33]
				cHist2 := ""
				cHist3 := space(160)
				//Funcao para buscar as obsercacoes do pedido de compra
				if substr(aParcelas[1,33],5,6) >= '000000' .and. substr(aParcelas[1,33],5,6) <= '999999'
					cHist3:= agobsped(cFilOrig,substr(aParcelas[1,33],5,6))
				endif
				for iHist := 1 to len(aParcelas[1,33])
					if Substr(aParcelas[1,33],iHist,12)=="APROV.NIV 02"
						cHist1 := Substr(aParcelas[1,33],1,iHist-1)
						cHist2 := Substr(aParcelas[1,33],iHist, len(aParcelas[1,33]) - iHist)
						iHist := len(aParcelas[1,33])
					endif
				next iHist
				
				//                //oPrint:Line(nlin-40,nColIni, nLin-40, 1700) //Coluna destinada a observacoes do pedido (Incluida por Anesio)
				//oPrint:Say(nLin-150,120,cHist1, oFontAr10) // Imprimi a observacao1 incluida pelo usuario (particionado em 2)
				//oPrint:Say(nLin-120,120,cHist2, oFontAr10)	//
				//oPrint:Say(nLin-90,120,"OBS: "+substr(cHist3, 1,68), oFontAr10)	//
				//oPrint:Say(nLin-60,120,substr(cHist3,69,72), oFontAr10)	//
				//oPrint:Line(nLin,nColIni,nLin,nColFim)  	//H 
				// Imprimi a observacao1 incluida pelo usuario (particionado em 2)
				AAdd(aText,{ 08.25 , 01.00 ,cHist1, oFontAr10 }) 
				AAdd(aText,{ 08.45 , 01.00 ,cHist2, oFontAr10 }) 
				AAdd(aText,{ 08.65 , 01.00 ,"OBS: "+substr(cHist3, 1,68), oFontAr10 }) 
				AAdd(aText,{ 08.85 , 01.00 ,substr(cHist3,69,72), oFontAr10 }) 
				
				AAdd(aText,{ 09.70 , 10.55 ,"TOTAL LÍQUIDO A PAGAR" ,oFontAr10n }) 
				AAdd(aText,{ 09.70 , 15.40 ,Transform(aDescri[nCtd,2],"@E 999,999,999.99"),oFontAr10 })				
				
				
			EndIf
		Next
	EndIf

	AAdd(aText,{ 10.20 , 01.00 ,"Depósito em Conta Bancária " ,oFontAr10n })
	AAdd(aText,{ 10.20 , 11.85 ,"Favorecido:" ,oFontAr10n })  
	AAdd(aText,{ 10.65 , 11.85 ,aParcelas[1,14],oFontAr10n })  //Nome Favorecido

	AAdd(aText,{ 10.65 , 01.00 ,"Banco    : " ,oFontAr11 })
	AAdd(aText,{ 10.65 , 02.25 ,aParcelas[1,11],oFontAr10n })  
	
	AAdd(aText,{ 10.65 , 03.55 ,"Agencia  : " ,oFontAr11 })
	AAdd(aText,{ 10.65 , 05.05 ,aParcelas[1,12],oFontAr10n })   
	
	AAdd(aText,{ 10.65 , 06.80 ,"Conta No.: " ,oFontAr11 })
	AAdd(aText,{ 10.65 , 08.45 ,aParcelas[1,13],oFontAr10n })
	
	AAdd(aText,{ 11.05 , 01.00 ,"Tipo Conta:" ,oFontAr11 })
	AAdd(aText,{ 11.05 , 02.85 ,Iif(Empty(aParcelas[1,11]),"",Iif(aParcelas[1,15]=='1',"Corrente","Poupança")),oFontAr10n })

	AAdd(aText,{ 11.05 , 04.40 ,"Forma Pagamento: " ,oFontAr11 })
	AAdd(aText,{ 11.05 , 07.40 ,cFormaPag,oFontAr10n }) //Forma Pagto

	If !Empty(aParcelas[1,16])
		If Len(Alltrim(aParcelas[1,16])) > 11   
			AAdd(aText,{ 11.05 , 11.85 ,"CNPJ:  "+Transform(aParcelas[1,16],"@R 99.999.999/9999-99"),oFontAr10n }) 	//Cpf/Cnpj Favorecido
			//oPrint:Say(nLin,1400,"CNPJ:  "+Transform(aParcelas[1,16],"@R 99.999.999/9999-99"),oFontAr10n)	//Cpf/Cnpj Favorecido
		Else
			If !Empty(aParcelas[1,16]) 
				AAdd(aText,{ 11.05 , 11.85 ,"CPF:  " +Transform(aParcelas[1,16],"@R 999.999.999-99"),oFontAr10n }) 	//Cpf/Cnpj Favorecido
				//oPrint:Say(nLin,1400,"CPF:  " +Transform(aParcelas[1,16],"@R 999.999.999-99"),oFontAr10n)	//Cpf/Cnpj Favorecido
			EndIf
		EndIf
	EndIf                              
	
	AAdd(aText,{ 11.45 , 01.00 ,PadC("Anexo ao documento original",240),oFontAr9 })
	AAdd(aText,{ 13.95 , 01.00 ,"Emitente: "+Capital(aParcelas[1,21]),oFontAr10n })	
	AAdd(aText,{ 13.95 , 12.70 ,"Gestor da Unidade "+Capital(cUnidade),oFontAr10n })	
	
	/*-----------------*/
	//	//oPrint:Say(1700,nColIni,Replicate("-",240),oFontAr10)
	/*	--------------------------------------------------------
	Imprime Slip para Financeiro - Parcelas - Contas a Pagar
	--------------------------------------------------------*/
	nSlip := 0
	nLin  := 1720
	nLinF := 2530   //2560	//Quadro do primeiro slip ==> Tamanho do Slip em pixel --> 820
	
	//Imprimindo Texto
	For xY:= 1 To Len(aText)
		nLin := 0
		nCol := 0
		
		nLin   := CMtoPX( aText[xY][1] ) //Linha
		nCol   := CMtoPX( aText[xY][2] ) //Coluna
		cText  := aText[xY][3] //Texto
		oFont  := aText[xY][4] //Font
		
		//nLin, nCol, cText, oFont
		oPrint:Say( nLin, nCol, cText, oFont)
		
	Next xY   
	
	//Cordenadas das Lines
	//nTop, nLeft, nBottom, nRight 
	AAdd(aLines,{ 13.50, 01.00, 13.50, 06.75 }) 
	AAdd(aLines,{ 13.50, 12.65, 13.50, 18.60 }) 
	AAdd(aLines,{ 20.75, 01.00, 20.75, 06.75 }) 
	AAdd(aLines,{ 20.75, 12.65, 20.75, 18.60 }) 
	
	//Imprimindo Lines
	For xY:= 1 To Len(aLines)  
	
		nTop    := 0
		nLeft   := 0
		nBottom := 0
		nRight  := 0
		
		nTop    := CMtoPX( aLines[xY][1] ) //
		nLeft   := CMtoPX( aLines[xY][2] ) //
		nBottom := CMtoPX( aLines[xY][3] ) //
		nRight  := CMtoPX( aLines[xY][4] ) //
		
		//nTop, nLeft, nBottom, nRight
		oPrint:Line ( nTop, nLeft, nBottom, nRight )
		
	Next xY

	// 
	//Quadro Financeiro.
	//        
	atext := {} 
	atextFin := {}   
	lNewPag := .F.    
	_nQrd01 := 0
	For nCnt := 1 To Len(aParcelas)  
	    If nCnt == 1 
			cFormaPag := 	Iif(aParcelas[nCnt,22]=='1',"DOC/TED",;
			Iif(aParcelas[nCnt,22]=='2',"Boleto/DDA",;
			Iif(aParcelas[nCnt,22]=='3',"Cheque",;
			Iif(aParcelas[nCnt,22]=='4',"Caixa",;
			Iif(aParcelas[nCnt,22]=='5',"Cnab Folha",;
			Iif(aParcelas[nCnt,22]=='6',"Cartão Corporativo",""))))))
			
			SED->(MsSeek(xFilial("SED")+aParcelas[nCnt,9]))
			
			/*---- Vencimento do Titulo ---*/
			cDtVencI:= GravaData(aParcelas[nCnt,7],.f.,5)
			cDtVencI:= Substr(cDtVencI,1,2)+"/"+Substr(cDtVencI,3,2)+"/"+Substr(cDtVencI,5,4)
			
			//oPrint:Line(nLin,nColIni,nlin,nColFim)
			//oPrint:Line(nLin,nColIni,nLinF,nColIni)     		//vertical
			//oPrint:Line(nLin,1600,nLin+60,1600)     			//vertical
			//oPrint:Line(nLin,nColFim,nLinF,nColFim)     		//vertical
			nLin += 10
			
			If !lReimp   
			
				AAdd(aText,{ 14.95 , 01.00 ,"AUTORIZAÇÃO DE PAGAMENTO No. "+Alltrim(Transform(Val(aParcelas[nCnt,17]),"@E 999,999,999"))+" - "+Alltrim(Transform(nCnt,"@E 99"))+"/"+;
				Alltrim(Transform(Len(aParcelas),"@E 999")),oFontAr12n })
				
			Else
	
				AAdd(aText,{ 14.95 , 01.00 ,"AUTORIZAÇÃO DE PAGAMENTO No. "+Alltrim(Transform(Val(aParcelas[nCnt,17]),"@E 999,999,999"))+" - "+Alltrim(Transform(nCnt,"@E 99"))+"/"+;
				Alltrim(Transform(Len(aParcelas),"@E 999"))+ Space(3)+"( R )",oFontAr12n })
	
			EndIf
			//		//oPrint:Say(nLin,1610,"Unidade:  "+ CFILANT +" - "+Upper(cUnidade),oFontAr12n) 
			AAdd(aText,{ 14.95 , 13.70 ,"Unidade:  "+ cFilOrig +" - "+Upper(cUnidade),oFontAr12n })
			nLin += 50
	
			//oPrint:SayBitmap(nLin,120,cLogo,275,90)
	
			/*--------------------------------------------
			Atualiza Fornecedor no Titulo
			--------------------------------------------*/
			SA2->(MsSeek(xFilial("SA2")+aParcelas[nCnt,5]+aParcelas[nCnt,6]))	//fornece + loja
	
			AAdd(aText,{ 15.30 , 04.95 ,"Fornecedor : " ,oFontAr11 })
			AAdd(aText,{ 15.30 , 06.90 ,Alltrim(SA2->A2_COD)+" - "+SA2->A2_LOJA+" - "+Alltrim(SA2->A2_NOME),oFontAr10n })
			
			//oPrint:Say(nLin,700,"Fornecedor : ",oFontAr11)
			//oPrint:Say(nLin,930,Alltrim(SA2->A2_COD)+" - "+SA2->A2_LOJA+" - "+Alltrim(SA2->A2_NOME),oFontAr10n)
		   //	nLin += 40
			
			lForn := .F.
			If Len(Alltrim(SA2->A2_CGC)) > 11  
				AAdd(aText,{ 15.65 , 04.95 ,"CNPJ:" ,oFontAr11 }) 
				AAdd(aText,{ 15.65 , 06.90 ,Iif(Empty(SA2->A2_CGC),"",Transform(SA2->A2_CGC,"@R 99.999.999/9999-99")),oFontAr10n }) 		
				lForn := .T.
			Else
				If !Empty(SA2->A2_CGC)        
					AAdd(aText,{ 15.65 , 04.95 ,"CPF: ",oFontAr11 }) 
					AAdd(aText,{ 15.65 , 06.90 ,Iif(Empty(SA2->A2_CGC),"",Transform(SA2->A2_CGC,"@R 99.999.999/9999-99")),oFontAr10n }) 			
					lForn := .F.
				EndIf
			EndIf
			nLin += 25  //40
			/*--- Calculo do Valor agregado ---*/
			//TRB->E2_ACRESC    +TRB->E2_MULTA     + TRB->E2_JUROS    + TRB->E2_CORREC   - TRB->E2_DECRESC
			//nSomaX := aParcelas[nCnt,27]+aParcelas[nCnt,29]+aParcelas[nCnt,30]+aParcelas[nCnt,31]-aParcelas[nCnt,28]
			
			nSomaX := (aParcelas[nCnt,29]+aParcelas[nCnt,30]+aParcelas[nCnt,31]-aParcelas[nCnt,28])   //AOliveira 11-04-2011
			
			//oPrint:Say(nLin,1430,"Valor do Titulo (R) - R$  "+Alltrim(Transform(aParcelas[nCnt,20]+nSomaX- iif(lForn,nPisCofCsl,0),"@E 999,999,999.99")),oFontAr11n)
			AAdd(aText,{ 16.00 , 12.05 ,"Valor do Titulo "+ Iif(lReimp,"(R)","") +" - R$  "+Alltrim(Transform(aParcelas[nCnt,20]+nSomaX- iif(lForn,nPisCofCsl,0),"@E 999,999,999.99")),oFontAr11n })
			
			if nPCCTOT == nPisCofCsl
				nPisCofCsl := 0
			endif
	
			AAdd(aText,{ 16.35 , 01.00 ,"Origem" ,oFontAr10 })
			AAdd(aText,{ 16.35 , 02.90 ,":     "+Alltrim(aParcelas[1,19])+" - "+Upper(Alltrim(Tabela("80",aParcelas[1,19],.f.))),oFontAr10n ,oFontAr10 })
	
			AAdd(aText,{ 16.70 , 01.00 ,"Natureza:" ,oFontAr10 }) 		                          
			AAdd(aText,{ 16.70 , 02.90 ,":     "+ Alltrim(aParcelas[nCnt,9]) + " - "+Upper(Alltrim(SED->ED_DESCRIC)),oFontAr10n }) 
					                          
			
			AAdd(aText,{ 16.35 , 12.05 ,"Documento No." ,oFontAr11 })		
			AAdd(aText,{ 16.35 , 14.70 ,":     "+aParcelas[nCnt,1]+Space(1)+aParcelas[nCnt,2]+"-"+aParcelas[nCnt,3]+Space(2)+aParcelas[nCnt,4],oFontAr10n }) 
			
			AAdd(aText,{ 16.70 , 12.05 ,"Emissão" ,oFontAr11 })
			AAdd(aText,{ 16.70 , 14.70 ,":     "+cDtEmis,oFontAr10n })
	         
			AAdd(aText,{ 17.05 , 12.05 ,"Vencimento" ,oFontAr11 })
			AAdd(aText,{ 17.05 , 14.70 ,":     "+cDtVencI,oFontAr10n })
					
			
			If !Empty(aParcelas[nCnt,23]) 
			
				AAdd(aText,{ 17.05 , 01.00 ,"C. Custo",oFontAr10 })
				AAdd(aText,{ 17.05 , 02.90 ,":     "+ Alltrim(aParcelas[nCnt,23]) + " - " + Upper(Alltrim(CTT->CTT_DESC01))+;
				Iif (!Empty(aParcelas[nCnt,32])," | "+ "It.Déb.: "+Alltrim(aParcelas[nCnt,32])+" - "+Upper(Alltrim(CTD->CTD_DESC01)),""),oFontAr9n})
				
			EndIf
			
			AAdd(aText,{ 18.00 , 01.00 ,"Histórico " ,oFontAr10n })
			AAdd(aText,{ 18.00 , 3.35 ,Upper(Alltrim(aParcelas[nCnt,10])),oFontAr11})
			
			AAdd(aText,{ 18.40 , 01.00 ,"Depósito em Conta Bancária " ,oFontAr10n })
	
			AAdd(aText,{ 18.40 , 11.85 ,"Favorecido:" ,oFontAr10n }) 		
			AAdd(aText,{ 18.75 , 11.85 ,aParcelas[nCnt,14],oFontAr10n }) //Nome Favorecido		
			
			AAdd(aText,{ 18.75 , 01.00 ,"Banco    : " ,oFontAr11 }) 
			AAdd(aText,{ 18.75 , 02.30 ,aParcelas[nCnt,11],oFontAr10n }) 
			
			AAdd(aText,{ 18.75 , 03.55 ,"Agencia  : " ,oFontAr11 })
			AAdd(aText,{ 18.75 , 05.05 ,aParcelas[nCnt,12],oFontAr10n })
	
			AAdd(aText,{ 18.75 , 06.80 ,"Conta No.: " ,oFontAr11 })
			AAdd(aText,{ 18.75 , 08.45 ,aParcelas[nCnt,13],oFontAr10n })
			
			AAdd(aText,{ 19.10 , 01.00 ,"Tipo Conta:" ,oFontAr11 })
			AAdd(aText,{ 19.10 , 02.80 ,IIf(Empty(aParcelas[nCnt,11]),"",IIf(aParcelas[nCnt,15]=='1',"Corrente","Poupança")),oFontAr10n })//Tipo Conta
	
			AAdd(aText,{ 19.10 , 04.40 ,"Forma Pagamento: " ,oFontAr11 })
			AAdd(aText,{ 19.10 , 07.40 ,cFormaPag,oFontAr10n }) //Forma Pagto
	
			If !Empty(aParcelas[nCnt,16])
				If Len(Alltrim(aParcelas[nCnt,16])) > 11  
					AAdd(aText,{ 19.10 , 11.85 ,cFormaPag,oFontAr10n }) //Forma Pagto
					//oPrint:Say(nLin,1400,"CNPJ:  "+Transform(aParcelas[nCnt,16],"@R 99.999.999/9999-99"),oFontAr10n)	//Cpf/Cnpj Favorecido
				Else
					If !Empty(aParcelas[nCnt,16])  
						AAdd(aText,{ 19.10 , 11.85 ,"CPF:  "+Transform(aParcelas[nCnt,16],"@R 999.999.999-99"),oFontAr10n })	//Cpf/Cnpj Favorecido
						//oPrint:Say(nLin,1400,"CPF:  "+Transform(aParcelas[nCnt,16],"@R 999.999.999-99"),oFontAr10n)	//Cpf/Cnpj Favorecido
					EndIf
				EndIf
			EndIf
	        
			AAdd(aText,{ 19.70 , 11.15 ,"     | Setor Financeiro - Contas a Pagar",oFontAr9 })
	
			AAdd(aText,{ 19.70 , 01.00 ,cHist1, oFontAr8 })
			AAdd(aText,{ 19.90 , 01.00 ,cHist2, oFontAr8 })
			AAdd(aText,{ 20.10 , 01.00 ,"OBS: "+substr(cHist3, 1,68), oFontAr8 })
			AAdd(aText,{ 20.40 , 01.00 ,substr(cHist3,69,72), oFontAr8})
	
			AAdd(aText,{ 21.15 , 01.00 ,"Emitente: "+Capital(aParcelas[nCnt,21]),oFontAr10n })
			AAdd(aText,{ 21.15 , 12.65 ,"Gestor da Unidade "+Capital(cUnidade),oFontAr10n})		
			lNewPag := .T.
		Else   
		   //A partir da Pagina 2
			_nQrd01 ++
			If _nQrd01 == 1
				cFormaPag := 	Iif(aParcelas[nCnt,22]=='1',"DOC/TED",;
				Iif(aParcelas[nCnt,22]=='2',"Boleto/DDA",;
				Iif(aParcelas[nCnt,22]=='3',"Cheque",;
				Iif(aParcelas[nCnt,22]=='4',"Caixa",;
				Iif(aParcelas[nCnt,22]=='5',"Cnab Folha",;
				Iif(aParcelas[nCnt,22]=='6',"Cartão Corporativo",""))))))
				
				SED->(MsSeek(xFilial("SED")+aParcelas[nCnt,9]))
				
				/*---- Vencimento do Titulo ---*/
				cDtVencI:= GravaData(aParcelas[nCnt,7],.f.,5)
				cDtVencI:= Substr(cDtVencI,1,2)+"/"+Substr(cDtVencI,3,2)+"/"+Substr(cDtVencI,5,4)
				
				//oPrint:Line(nLin,nColIni,nlin,nColFim)
				//oPrint:Line(nLin,nColIni,nLinF,nColIni)     		//vertical
				//oPrint:Line(nLin,1600,nLin+60,1600)     			//vertical
				//oPrint:Line(nLin,nColFim,nLinF,nColFim)     		//vertical
				nLin += 10
					
				If !lReimp   
				
					AAdd(aText,{ 00.65 , 01.00 ,"AUTORIZAÇÃO DE PAGAMENTO No. "+Alltrim(Transform(Val(aParcelas[nCnt,17]),"@E 999,999,999"))+" - "+Alltrim(Transform(nCnt,"@E 99"))+"/"+;
					Alltrim(Transform(Len(aParcelas),"@E 999")),oFontAr12n })
					
				Else
		
					AAdd(aText,{ 00.65 , 01.00 ,"AUTORIZAÇÃO DE PAGAMENTO No. "+Alltrim(Transform(Val(aParcelas[nCnt,17]),"@E 999,999,999"))+" - "+Alltrim(Transform(nCnt,"@E 99"))+"/"+;
					Alltrim(Transform(Len(aParcelas),"@E 999"))+ Space(3)+"( R )",oFontAr12n })
		
				EndIf
				//		//oPrint:Say(nLin,1610,"Unidade:  "+ CFILANT +" - "+Upper(cUnidade),oFontAr12n) 
				AAdd(aText,{ 00.65 , 13.70 ,"Unidade:  "+ cFilOrig +" - "+Upper(cUnidade),oFontAr12n })
				nLin += 50
		
				//oPrint:SayBitmap(nLin,120,cLogo,275,90)
		
				/*--------------------------------------------
				Atualiza Fornecedor no Titulo
				--------------------------------------------*/
				SA2->(MsSeek(xFilial("SA2")+aParcelas[nCnt,5]+aParcelas[nCnt,6]))	//fornece + loja
		
				AAdd(aText,{ 01.30 , 04.95 ,"Fornecedor : " ,oFontAr11 })
				AAdd(aText,{ 01.30 , 06.90 ,Alltrim(SA2->A2_COD)+" - "+SA2->A2_LOJA+" - "+Alltrim(SA2->A2_NOME),oFontAr10n })
				
				//oPrint:Say(nLin,700,"Fornecedor : ",oFontAr11)
				//oPrint:Say(nLin,930,Alltrim(SA2->A2_COD)+" - "+SA2->A2_LOJA+" - "+Alltrim(SA2->A2_NOME),oFontAr10n)
			   //	nLin += 40
				
				lForn := .F.
				If Len(Alltrim(SA2->A2_CGC)) > 11  
					AAdd(aText,{ 01.65 , 04.95 ,"CNPJ:" ,oFontAr11 }) 
					AAdd(aText,{ 01.65 , 06.90 ,Iif(Empty(SA2->A2_CGC),"",Transform(SA2->A2_CGC,"@R 99.999.999/9999-99")),oFontAr10n }) 		
					lForn := .T.
				Else
					If !Empty(SA2->A2_CGC)        
						AAdd(aText,{ 01.65 , 04.95 ,"CPF: ",oFontAr11 }) 
						AAdd(aText,{ 01.65 , 06.90 ,Iif(Empty(SA2->A2_CGC),"",Transform(SA2->A2_CGC,"@R 99.999.999/9999-99")),oFontAr10n }) 			
						lForn := .F.
					EndIf
				EndIf
				nLin += 25  //40
				/*--- Calculo do Valor agregado ---*/
				//TRB->E2_ACRESC    +TRB->E2_MULTA     + TRB->E2_JUROS    + TRB->E2_CORREC   - TRB->E2_DECRESC
				//nSomaX := aParcelas[nCnt,27]+aParcelas[nCnt,29]+aParcelas[nCnt,30]+aParcelas[nCnt,31]-aParcelas[nCnt,28]
				
				nSomaX := (aParcelas[nCnt,29]+aParcelas[nCnt,30]+aParcelas[nCnt,31]-aParcelas[nCnt,28])   //AOliveira 11-04-2011
				
				//oPrint:Say(nLin,1430,"Valor do Titulo (R) - R$  "+Alltrim(Transform(aParcelas[nCnt,20]+nSomaX- iif(lForn,nPisCofCsl,0),"@E 999,999,999.99")),oFontAr11n)
				AAdd(aText,{ 02.00 , 12.05 ,"Valor do Titulo "+ Iif(lReimp,"(R)","") +" - R$  "+Alltrim(Transform(aParcelas[nCnt,20]+nSomaX- iif(lForn,nPisCofCsl,0),"@E 999,999,999.99")),oFontAr11n })
				
				if nPCCTOT == nPisCofCsl
					nPisCofCsl := 0
				endif
		
				AAdd(aText,{ 02.35 , 01.00 ,"Origem" ,oFontAr10 })
				AAdd(aText,{ 02.35 , 02.90 ,":     "+Alltrim(aParcelas[1,19])+" - "+Upper(Alltrim(Tabela("80",aParcelas[1,19],.f.))),oFontAr10n ,oFontAr10 })
		
				AAdd(aText,{ 02.70 , 01.00 ,"Natureza:" ,oFontAr10 }) 		                          
				AAdd(aText,{ 02.70 , 02.90 ,":     "+ Alltrim(aParcelas[nCnt,9]) + " - "+Upper(Alltrim(SED->ED_DESCRIC)),oFontAr10n }) 
						                          
				
				AAdd(aText,{ 02.35 , 12.05 ,"Documento No." ,oFontAr11 })		
				AAdd(aText,{ 02.35 , 14.70 ,":     "+aParcelas[nCnt,1]+Space(1)+aParcelas[nCnt,2]+"-"+aParcelas[nCnt,3]+Space(2)+aParcelas[nCnt,4],oFontAr10n }) 
				
				AAdd(aText,{ 02.70 , 12.05 ,"Emissão" ,oFontAr11 })
				AAdd(aText,{ 02.70 , 14.70 ,":     "+cDtEmis,oFontAr10n })
		         
				AAdd(aText,{ 03.05 , 12.05 ,"Vencimento" ,oFontAr11 })
				AAdd(aText,{ 03.05 , 14.70 ,":     "+cDtVencI,oFontAr10n })
						
				
				If !Empty(aParcelas[nCnt,23]) 
				
					AAdd(aText,{ 03.05 , 01.00 ,"C. Custo",oFontAr10 })
					AAdd(aText,{ 03.05 , 02.90 ,":     "+ Alltrim(aParcelas[nCnt,23]) + " - " + Upper(Alltrim(CTT->CTT_DESC01))+;
					Iif (!Empty(aParcelas[nCnt,32])," | "+ "It.Déb.: "+Alltrim(aParcelas[nCnt,32])+" - "+Upper(Alltrim(CTD->CTD_DESC01)),""),oFontAr9n})
					
				EndIf
				
				AAdd(aText,{ 03.70 , 01.00 ,"Histórico " ,oFontAr10n })
				AAdd(aText,{ 03.70 , 3.35 ,Upper(Alltrim(aParcelas[nCnt,10])),oFontAr11})
				
				AAdd(aText,{ 04.20 , 01.00 ,"Depósito em Conta Bancária " ,oFontAr10n })
		
				AAdd(aText,{ 04.20 , 11.85 ,"Favorecido:" ,oFontAr10n }) 		
				AAdd(aText,{ 04.55 , 11.85 ,aParcelas[nCnt,14],oFontAr10n }) //Nome Favorecido		
				
				AAdd(aText,{ 04.55 , 01.00 ,"Banco    : " ,oFontAr11 }) 
				AAdd(aText,{ 04.55 , 02.30 ,aParcelas[nCnt,11],oFontAr10n }) 
				
				AAdd(aText,{ 04.55 , 03.55 ,"Agencia  : " ,oFontAr11 })
				AAdd(aText,{ 04.55 , 05.05 ,aParcelas[nCnt,12],oFontAr10n })
		
				AAdd(aText,{ 04.55 , 06.80 ,"Conta No.: " ,oFontAr11 })
				AAdd(aText,{ 04.55 , 08.45 ,aParcelas[nCnt,13],oFontAr10n })
				
				AAdd(aText,{ 04.90 , 01.00 ,"Tipo Conta:" ,oFontAr11 })
				AAdd(aText,{ 04.90 , 02.80 ,IIf(Empty(aParcelas[nCnt,11]),"",IIf(aParcelas[nCnt,15]=='1',"Corrente","Poupança")),oFontAr10n })//Tipo Conta
		
				AAdd(aText,{ 04.90 , 04.40 ,"Forma Pagamento: " ,oFontAr11 })
				AAdd(aText,{ 04.90 , 07.40 ,cFormaPag,oFontAr10n }) //Forma Pagto
		
				If !Empty(aParcelas[nCnt,16])
					If Len(Alltrim(aParcelas[nCnt,16])) > 11  
						AAdd(aText,{ 04.90 , 11.85 ,cFormaPag,oFontAr10n }) //Forma Pagto
						//oPrint:Say(nLin,1400,"CNPJ:  "+Transform(aParcelas[nCnt,16],"@R 99.999.999/9999-99"),oFontAr10n)	//Cpf/Cnpj Favorecido
					Else
						If !Empty(aParcelas[nCnt,16])  
							AAdd(aText,{ 04.90 , 11.85 ,"CPF:  "+Transform(aParcelas[nCnt,16],"@R 999.999.999-99"),oFontAr10n })	//Cpf/Cnpj Favorecido
							//oPrint:Say(nLin,1400,"CPF:  "+Transform(aParcelas[nCnt,16],"@R 999.999.999-99"),oFontAr10n)	//Cpf/Cnpj Favorecido
						EndIf
					EndIf
				EndIf
		        
				AAdd(aText,{ 05.50 , 11.15 ,"     | Setor Financeiro - Contas a Pagar",oFontAr9 })
		
				AAdd(aText,{ 05.50 , 01.00 ,cHist1, oFontAr8 })
				AAdd(aText,{ 05.70 , 01.00 ,cHist2, oFontAr8 })
				AAdd(aText,{ 05.90 , 01.00 ,"OBS: "+substr(cHist3, 1,68), oFontAr8 })
				AAdd(aText,{ 06.10 , 01.00 ,substr(cHist3,69,72), oFontAr8})
		
				AAdd(aText,{ 06.95 , 01.00 ,"Emitente: "+Capital(aParcelas[nCnt,21]),oFontAr10n })
				AAdd(aText,{ 06.95 , 12.65 ,"Gestor da Unidade "+Capital(cUnidade),oFontAr10n})		
							
			ElseIf _nQrd01 == 2
			
				cFormaPag := 	Iif(aParcelas[nCnt,22]=='1',"DOC/TED",;
				Iif(aParcelas[nCnt,22]=='2',"Boleto/DDA",;
				Iif(aParcelas[nCnt,22]=='3',"Cheque",;
				Iif(aParcelas[nCnt,22]=='4',"Caixa",;
				Iif(aParcelas[nCnt,22]=='5',"Cnab Folha",;
				Iif(aParcelas[nCnt,22]=='6',"Cartão Corporativo",""))))))
				
				SED->(MsSeek(xFilial("SED")+aParcelas[nCnt,9]))
				
				/*---- Vencimento do Titulo ---*/
				cDtVencI:= GravaData(aParcelas[nCnt,7],.f.,5)
				cDtVencI:= Substr(cDtVencI,1,2)+"/"+Substr(cDtVencI,3,2)+"/"+Substr(cDtVencI,5,4)
				
				//oPrint:Line(nLin,nColIni,nlin,nColFim)
				//oPrint:Line(nLin,nColIni,nLinF,nColIni)     		//vertical
				//oPrint:Line(nLin,1600,nLin+60,1600)     			//vertical
				//oPrint:Line(nLin,nColFim,nLinF,nColFim)     		//vertical
				nLin += 10
					
				If !lReimp   
				
					AAdd(aText,{ 07.75 , 01.00 ,"AUTORIZAÇÃO DE PAGAMENTO No. "+Alltrim(Transform(Val(aParcelas[nCnt,17]),"@E 999,999,999"))+" - "+Alltrim(Transform(nCnt,"@E 99"))+"/"+;
					Alltrim(Transform(Len(aParcelas),"@E 999")),oFontAr12n })
					
				Else
		
					AAdd(aText,{ 07.75 , 01.00 ,"AUTORIZAÇÃO DE PAGAMENTO No. "+Alltrim(Transform(Val(aParcelas[nCnt,17]),"@E 999,999,999"))+" - "+Alltrim(Transform(nCnt,"@E 99"))+"/"+;
					Alltrim(Transform(Len(aParcelas),"@E 999"))+ Space(3)+"( R )",oFontAr12n })
		
				EndIf
				//		//oPrint:Say(nLin,1610,"Unidade:  "+ CFILANT +" - "+Upper(cUnidade),oFontAr12n) 
				AAdd(aText,{ 07.75 , 13.70 ,"Unidade:  "+ cFilOrig +" - "+Upper(cUnidade),oFontAr12n })
				nLin += 50
		
				//oPrint:SayBitmap(nLin,120,cLogo,275,90)
		
				/*--------------------------------------------
				Atualiza Fornecedor no Titulo
				--------------------------------------------*/
				SA2->(MsSeek(xFilial("SA2")+aParcelas[nCnt,5]+aParcelas[nCnt,6]))	//fornece + loja
		
				AAdd(aText,{ 08.55 , 04.95 ,"Fornecedor : " ,oFontAr11 })
				AAdd(aText,{ 08.55 , 06.90 ,Alltrim(SA2->A2_COD)+" - "+SA2->A2_LOJA+" - "+Alltrim(SA2->A2_NOME),oFontAr10n })
				
				//oPrint:Say(nLin,700,"Fornecedor : ",oFontAr11)
				//oPrint:Say(nLin,930,Alltrim(SA2->A2_COD)+" - "+SA2->A2_LOJA+" - "+Alltrim(SA2->A2_NOME),oFontAr10n)
			   //	nLin += 40
				
				lForn := .F.
				If Len(Alltrim(SA2->A2_CGC)) > 11  
					AAdd(aText,{ 08.90 , 04.95 ,"CNPJ:" ,oFontAr11 }) 
					AAdd(aText,{ 08.90 , 06.90 ,Iif(Empty(SA2->A2_CGC),"",Transform(SA2->A2_CGC,"@R 99.999.999/9999-99")),oFontAr10n }) 		
					lForn := .T.
				Else
					If !Empty(SA2->A2_CGC)        
						AAdd(aText,{ 08.90 , 04.95 ,"CPF: ",oFontAr11 }) 
						AAdd(aText,{ 08.90 , 06.90 ,Iif(Empty(SA2->A2_CGC),"",Transform(SA2->A2_CGC,"@R 99.999.999/9999-99")),oFontAr10n }) 			
						lForn := .F.
					EndIf
				EndIf
				nLin += 25  //40
				/*--- Calculo do Valor agregado ---*/
				//TRB->E2_ACRESC    +TRB->E2_MULTA     + TRB->E2_JUROS    + TRB->E2_CORREC   - TRB->E2_DECRESC
				//nSomaX := aParcelas[nCnt,27]+aParcelas[nCnt,29]+aParcelas[nCnt,30]+aParcelas[nCnt,31]-aParcelas[nCnt,28]
				
				nSomaX := (aParcelas[nCnt,29]+aParcelas[nCnt,30]+aParcelas[nCnt,31]-aParcelas[nCnt,28])   //AOliveira 11-04-2011
				
				//oPrint:Say(nLin,1430,"Valor do Titulo (R) - R$  "+Alltrim(Transform(aParcelas[nCnt,20]+nSomaX- iif(lForn,nPisCofCsl,0),"@E 999,999,999.99")),oFontAr11n)
				AAdd(aText,{ 09.25 , 12.05 ,"Valor do Titulo "+ Iif(lReimp,"(R)","") +" - R$  "+Alltrim(Transform(aParcelas[nCnt,20]+nSomaX- iif(lForn,nPisCofCsl,0),"@E 999,999,999.99")),oFontAr11n })
				
				if nPCCTOT == nPisCofCsl
					nPisCofCsl := 0
				endif
		
				AAdd(aText,{ 09.60 , 01.00 ,"Origem" ,oFontAr10 })
				AAdd(aText,{ 09.60 , 02.90 ,":     "+Alltrim(aParcelas[1,19])+" - "+Upper(Alltrim(Tabela("80",aParcelas[1,19],.f.))),oFontAr10n ,oFontAr10 })
		
				AAdd(aText,{ 09.95 , 01.00 ,"Natureza:" ,oFontAr10 }) 		                          
				AAdd(aText,{ 09.95 , 02.90 ,":     "+ Alltrim(aParcelas[nCnt,9]) + " - "+Upper(Alltrim(SED->ED_DESCRIC)),oFontAr10n }) 
						                          
				
				AAdd(aText,{ 09.60 , 12.05 ,"Documento No." ,oFontAr11 })		
				AAdd(aText,{ 09.60 , 14.70 ,":     "+aParcelas[nCnt,1]+Space(1)+aParcelas[nCnt,2]+"-"+aParcelas[nCnt,3]+Space(2)+aParcelas[nCnt,4],oFontAr10n }) 
				
				AAdd(aText,{ 09.95 , 12.05 ,"Emissão" ,oFontAr11 })
				AAdd(aText,{ 09.95 , 14.70 ,":     "+cDtEmis,oFontAr10n })
		         
				AAdd(aText,{ 10.30 , 12.05 ,"Vencimento" ,oFontAr11 })
				AAdd(aText,{ 10.30 , 14.70 ,":     "+cDtVencI,oFontAr10n })
						
				
				If !Empty(aParcelas[nCnt,23]) 
				
					AAdd(aText,{ 10.30 , 01.00 ,"C. Custo",oFontAr10 })
					AAdd(aText,{ 10.30 , 02.90 ,":     "+ Alltrim(aParcelas[nCnt,23]) + " - " + Upper(Alltrim(CTT->CTT_DESC01))+;
					Iif (!Empty(aParcelas[nCnt,32])," | "+ "It.Déb.: "+Alltrim(aParcelas[nCnt,32])+" - "+Upper(Alltrim(CTD->CTD_DESC01)),""),oFontAr9n})
					
				EndIf
				
				AAdd(aText,{ 10.90 , 01.00 ,"Histórico " ,oFontAr10n })
				AAdd(aText,{ 10.90 , 3.35 ,Upper(Alltrim(aParcelas[nCnt,10])),oFontAr11})
				
				AAdd(aText,{ 11.25 , 01.00 ,"Depósito em Conta Bancária " ,oFontAr10n })
		
				AAdd(aText,{ 11.25 , 11.85 ,"Favorecido:" ,oFontAr10n }) 		
				AAdd(aText,{ 11.60 , 11.85 ,aParcelas[nCnt,14],oFontAr10n }) //Nome Favorecido		
				
				AAdd(aText,{ 11.60 , 01.00 ,"Banco    : " ,oFontAr11 }) 
				AAdd(aText,{ 11.60 , 02.30 ,aParcelas[nCnt,11],oFontAr10n }) 
				
				AAdd(aText,{ 11.60 , 03.55 ,"Agencia  : " ,oFontAr11 })
				AAdd(aText,{ 11.60 , 05.05 ,aParcelas[nCnt,12],oFontAr10n })
		
				AAdd(aText,{ 11.60 , 06.80 ,"Conta No.: " ,oFontAr11 })
				AAdd(aText,{ 11.60 , 08.45 ,aParcelas[nCnt,13],oFontAr10n })
				
				AAdd(aText,{ 11.95 , 01.00 ,"Tipo Conta:" ,oFontAr11 })
				AAdd(aText,{ 11.95 , 02.80 ,IIf(Empty(aParcelas[nCnt,11]),"",IIf(aParcelas[nCnt,15]=='1',"Corrente","Poupança")),oFontAr10n })//Tipo Conta
		
				AAdd(aText,{ 11.95 , 04.40 ,"Forma Pagamento: " ,oFontAr11 })
				AAdd(aText,{ 11.95 , 07.40 ,cFormaPag,oFontAr10n }) //Forma Pagto
		
				If !Empty(aParcelas[nCnt,16])
					If Len(Alltrim(aParcelas[nCnt,16])) > 11  
						AAdd(aText,{ 11.95 , 11.85 ,cFormaPag,oFontAr10n }) //Forma Pagto
						//oPrint:Say(nLin,1400,"CNPJ:  "+Transform(aParcelas[nCnt,16],"@R 99.999.999/9999-99"),oFontAr10n)	//Cpf/Cnpj Favorecido
					Else
						If !Empty(aParcelas[nCnt,16])  
							AAdd(aText,{ 11.95, 11.85 ,"CPF:  "+Transform(aParcelas[nCnt,16],"@R 999.999.999-99"),oFontAr10n })	//Cpf/Cnpj Favorecido
							//oPrint:Say(nLin,1400,"CPF:  "+Transform(aParcelas[nCnt,16],"@R 999.999.999-99"),oFontAr10n)	//Cpf/Cnpj Favorecido
						EndIf
					EndIf
				EndIf
		        
				AAdd(aText,{ 12.75 , 11.15 ,"     | Setor Financeiro - Contas a Pagar",oFontAr9 })
		
				AAdd(aText,{ 12.75 , 01.00 ,cHist1, oFontAr8 })
				AAdd(aText,{ 12.95 , 01.00 ,cHist2, oFontAr8 })
				AAdd(aText,{ 13.15 , 01.00 ,"OBS: "+substr(cHist3, 1,68), oFontAr8 })
				AAdd(aText,{ 13.35 , 01.00 ,substr(cHist3,69,72), oFontAr8})
		
				AAdd(aText,{ 14.15 , 01.00 ,"Emitente: "+Capital(aParcelas[nCnt,21]),oFontAr10n })
				AAdd(aText,{ 14.15 , 12.65 ,"Gestor da Unidade "+Capital(cUnidade),oFontAr10n})		
				
			ElseIf _nQrd01 == 3
				cFormaPag := 	Iif(aParcelas[nCnt,22]=='1',"DOC/TED",;
				Iif(aParcelas[nCnt,22]=='2',"Boleto/DDA",;
				Iif(aParcelas[nCnt,22]=='3',"Cheque",;
				Iif(aParcelas[nCnt,22]=='4',"Caixa",;
				Iif(aParcelas[nCnt,22]=='5',"Cnab Folha",;
				Iif(aParcelas[nCnt,22]=='6',"Cartão Corporativo",""))))))
				
				SED->(MsSeek(xFilial("SED")+aParcelas[nCnt,9]))
				
				/*---- Vencimento do Titulo ---*/
				cDtVencI:= GravaData(aParcelas[nCnt,7],.f.,5)
				cDtVencI:= Substr(cDtVencI,1,2)+"/"+Substr(cDtVencI,3,2)+"/"+Substr(cDtVencI,5,4)
				
				//oPrint:Line(nLin,nColIni,nlin,nColFim)
				//oPrint:Line(nLin,nColIni,nLinF,nColIni)     		//vertical
				//oPrint:Line(nLin,1600,nLin+60,1600)     			//vertical
				//oPrint:Line(nLin,nColFim,nLinF,nColFim)     		//vertical
				nLin += 10
				
				If !lReimp   
				
					AAdd(aText,{ 14.95 , 01.00 ,"AUTORIZAÇÃO DE PAGAMENTO No. "+Alltrim(Transform(Val(aParcelas[nCnt,17]),"@E 999,999,999"))+" - "+Alltrim(Transform(nCnt,"@E 99"))+"/"+;
					Alltrim(Transform(Len(aParcelas),"@E 999")),oFontAr12n })
					
				Else
		
					AAdd(aText,{ 14.95 , 01.00 ,"AUTORIZAÇÃO DE PAGAMENTO No. "+Alltrim(Transform(Val(aParcelas[nCnt,17]),"@E 999,999,999"))+" - "+Alltrim(Transform(nCnt,"@E 99"))+"/"+;
					Alltrim(Transform(Len(aParcelas),"@E 999"))+ Space(3)+"( R )",oFontAr12n })
		
				EndIf
				//		//oPrint:Say(nLin,1610,"Unidade:  "+ CFILANT +" - "+Upper(cUnidade),oFontAr12n) 
				AAdd(aText,{ 14.95 , 13.70 ,"Unidade:  "+ cFilOrig +" - "+Upper(cUnidade),oFontAr12n })
				nLin += 50
		
				//oPrint:SayBitmap(nLin,120,cLogo,275,90)
		
				/*--------------------------------------------
				Atualiza Fornecedor no Titulo
				--------------------------------------------*/
				SA2->(MsSeek(xFilial("SA2")+aParcelas[nCnt,5]+aParcelas[nCnt,6]))	//fornece + loja
		
				AAdd(aText,{ 15.50 , 04.95 ,"Fornecedor : " ,oFontAr11 })
				AAdd(aText,{ 15.50 , 06.90 ,Alltrim(SA2->A2_COD)+" - "+SA2->A2_LOJA+" - "+Alltrim(SA2->A2_NOME),oFontAr10n })
				
				//oPrint:Say(nLin,700,"Fornecedor : ",oFontAr11)
				//oPrint:Say(nLin,930,Alltrim(SA2->A2_COD)+" - "+SA2->A2_LOJA+" - "+Alltrim(SA2->A2_NOME),oFontAr10n)
			   //	nLin += 40
				
				lForn := .F.
				If Len(Alltrim(SA2->A2_CGC)) > 11  
					AAdd(aText,{ 15.85 , 04.95 ,"CNPJ:" ,oFontAr11 }) 
					AAdd(aText,{ 15.85 , 06.90 ,Iif(Empty(SA2->A2_CGC),"",Transform(SA2->A2_CGC,"@R 99.999.999/9999-99")),oFontAr10n }) 		
					lForn := .T.
				Else
					If !Empty(SA2->A2_CGC)        
						AAdd(aText,{ 15.85 , 04.95 ,"CPF: ",oFontAr11 }) 
						AAdd(aText,{ 15.85 , 06.90 ,Iif(Empty(SA2->A2_CGC),"",Transform(SA2->A2_CGC,"@R 99.999.999/9999-99")),oFontAr10n }) 			
						lForn := .F.
					EndIf
				EndIf
				nLin += 25  //40
				/*--- Calculo do Valor agregado ---*/
				//TRB->E2_ACRESC    +TRB->E2_MULTA     + TRB->E2_JUROS    + TRB->E2_CORREC   - TRB->E2_DECRESC
				//nSomaX := aParcelas[nCnt,27]+aParcelas[nCnt,29]+aParcelas[nCnt,30]+aParcelas[nCnt,31]-aParcelas[nCnt,28]
				
				nSomaX := (aParcelas[nCnt,29]+aParcelas[nCnt,30]+aParcelas[nCnt,31]-aParcelas[nCnt,28])   //AOliveira 11-04-2011
				
				//oPrint:Say(nLin,1430,"Valor do Titulo (R) - R$  "+Alltrim(Transform(aParcelas[nCnt,20]+nSomaX- iif(lForn,nPisCofCsl,0),"@E 999,999,999.99")),oFontAr11n)
				AAdd(aText,{ 16.20 , 12.05 ,"Valor do Titulo "+ Iif(lReimp,"(R)","") +" - R$  "+Alltrim(Transform(aParcelas[nCnt,20]+nSomaX- iif(lForn,nPisCofCsl,0),"@E 999,999,999.99")),oFontAr11n })
				
				if nPCCTOT == nPisCofCsl
					nPisCofCsl := 0
				endif
		
				AAdd(aText,{ 16.55 , 01.00 ,"Origem" ,oFontAr10 })
				AAdd(aText,{ 16.55 , 02.90 ,":     "+Alltrim(aParcelas[1,19])+" - "+Upper(Alltrim(Tabela("80",aParcelas[1,19],.f.))),oFontAr10n ,oFontAr10 })
		
				AAdd(aText,{ 16.90 , 01.00 ,"Natureza:" ,oFontAr10 }) 		                          
				AAdd(aText,{ 16.90 , 02.90 ,":     "+ Alltrim(aParcelas[nCnt,9]) + " - "+Upper(Alltrim(SED->ED_DESCRIC)),oFontAr10n }) 
						                          
				
				AAdd(aText,{ 16.55 , 12.05 ,"Documento No." ,oFontAr11 })		
				AAdd(aText,{ 16.55 , 14.70 ,":     "+aParcelas[nCnt,1]+Space(1)+aParcelas[nCnt,2]+"-"+aParcelas[nCnt,3]+Space(2)+aParcelas[nCnt,4],oFontAr10n }) 
				
				AAdd(aText,{ 16.90 , 12.05 ,"Emissão" ,oFontAr11 })
				AAdd(aText,{ 16.90 , 14.70 ,":     "+cDtEmis,oFontAr10n })
		         
				AAdd(aText,{ 17.25 , 12.05 ,"Vencimento" ,oFontAr11 })
				AAdd(aText,{ 17.25 , 14.70 ,":     "+cDtVencI,oFontAr10n })
						
				
				If !Empty(aParcelas[nCnt,23]) 
				
					AAdd(aText,{ 17.25 , 01.00 ,"C. Custo",oFontAr10 })
					AAdd(aText,{ 17.25 , 02.90 ,":     "+ Alltrim(aParcelas[nCnt,23]) + " - " + Upper(Alltrim(CTT->CTT_DESC01))+;
					Iif (!Empty(aParcelas[nCnt,32])," | "+ "It.Déb.: "+Alltrim(aParcelas[nCnt,32])+" - "+Upper(Alltrim(CTD->CTD_DESC01)),""),oFontAr9n})
					
				EndIf
				
				AAdd(aText,{ 18.00 , 01.00 ,"Histórico " ,oFontAr10n })
				AAdd(aText,{ 18.00 , 3.35 ,Upper(Alltrim(aParcelas[nCnt,10])),oFontAr11})
				
				AAdd(aText,{ 18.40 , 01.00 ,"Depósito em Conta Bancária " ,oFontAr10n })
		
				AAdd(aText,{ 18.40 , 11.85 ,"Favorecido:" ,oFontAr10n }) 		
				AAdd(aText,{ 18.75 , 11.85 ,aParcelas[nCnt,14],oFontAr10n }) //Nome Favorecido		
				
				AAdd(aText,{ 18.75 , 01.00 ,"Banco    : " ,oFontAr11 }) 
				AAdd(aText,{ 18.75 , 02.30 ,aParcelas[nCnt,11],oFontAr10n }) 
				
				AAdd(aText,{ 18.75 , 03.55 ,"Agencia  : " ,oFontAr11 })
				AAdd(aText,{ 18.75 , 05.05 ,aParcelas[nCnt,12],oFontAr10n })
		
				AAdd(aText,{ 18.75 , 06.80 ,"Conta No.: " ,oFontAr11 })
				AAdd(aText,{ 18.75 , 08.45 ,aParcelas[nCnt,13],oFontAr10n })
				
				AAdd(aText,{ 19.10 , 01.00 ,"Tipo Conta:" ,oFontAr11 })
				AAdd(aText,{ 19.10 , 02.80 ,IIf(Empty(aParcelas[nCnt,11]),"",IIf(aParcelas[nCnt,15]=='1',"Corrente","Poupança")),oFontAr10n })//Tipo Conta
		
				AAdd(aText,{ 19.10 , 04.40 ,"Forma Pagamento: " ,oFontAr11 })
				AAdd(aText,{ 19.10 , 07.40 ,cFormaPag,oFontAr10n }) //Forma Pagto
		
				If !Empty(aParcelas[nCnt,16])
					If Len(Alltrim(aParcelas[nCnt,16])) > 11  
						AAdd(aText,{ 19.10 , 11.85 ,cFormaPag,oFontAr10n }) //Forma Pagto
						//oPrint:Say(nLin,1400,"CNPJ:  "+Transform(aParcelas[nCnt,16],"@R 99.999.999/9999-99"),oFontAr10n)	//Cpf/Cnpj Favorecido
					Else
						If !Empty(aParcelas[nCnt,16])  
							AAdd(aText,{ 19.10 , 11.85 ,"CPF:  "+Transform(aParcelas[nCnt,16],"@R 999.999.999-99"),oFontAr10n })	//Cpf/Cnpj Favorecido
							//oPrint:Say(nLin,1400,"CPF:  "+Transform(aParcelas[nCnt,16],"@R 999.999.999-99"),oFontAr10n)	//Cpf/Cnpj Favorecido
						EndIf
					EndIf
				EndIf
		        
				AAdd(aText,{ 19.70 , 11.15 ,"     | Setor Financeiro - Contas a Pagar",oFontAr9 })
		
				AAdd(aText,{ 19.70 , 01.00 ,cHist1, oFontAr8 })
				AAdd(aText,{ 20.05 , 01.00 ,cHist2, oFontAr8 })
				AAdd(aText,{ 20.40 , 01.00 ,"OBS: "+substr(cHist3, 1,68), oFontAr8 })
				AAdd(aText,{ 20.75 , 01.00 ,substr(cHist3,69,72), oFontAr8})
		
				AAdd(aText,{ 21.15 , 01.00 ,"Emitente: "+Capital(aParcelas[nCnt,21]),oFontAr10n })
				AAdd(aText,{ 21.15 , 12.65 ,"Gestor da Unidade "+Capital(cUnidade),oFontAr10n})		
				lNewPag := .T.
				_nQrd01 := 0			
			EndIf
				
		EndIf    
		
		
		AADD(atextFin,atext)
		atext := {}
		
	Next
	   
	//aTextFin := {}
	//aTextFin := aText
	lNewPag := .T.
	_nQrd01 := 0       
	For X:= 1 To Len(aTextFin) 
	
		If X == 1
			XPRINTT(aTextFin[X])
		EndIf                 
		
		If X >= 2
			If lNewPag
				oPrint:EndPage()
				oPrint:StartPage() 
				oPrint:SetPortrait() //Define a orientação do relatório como retrato
				oPrint:setPaperSize( 9 ) //Tamanho da Folha A4
				oPrint:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior				
				lNewPag := .f.
			EndIf
			_nQrd01 ++
			lNewPag := PrintQrd(_nQrd01,lNewPag) //
			If lNewPag
				_nQrd01 := 0
			EndIf
			XPRINTT(aTextFin[X])
		EndIf
	Next X
	
	Exit
	
EndDo



////oPrint:Preview()  		// Visualizar todos antes de enviar para impressora

cFilePrint := cLocal+nomeprog+".PD_"
File2Printer( cFilePrint, "PDF" )
oPrint:cPathPDF:= cLocal
oPrint:Preview()

Return
/*
----------------------------------------------------------------------
Funcao   : RFinR01Fat()
Descricao: Monta array com os titulos que compoem a  Fatura na rotina
de Reimpressao da AP
----------------------------------------------------------------------*/
Static Function RFat()
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
Static function VerSeDeduz(cForn, cLoja, dVencRea, cDuplicAtu)
local lRet 			:= 0
local _cForn 		:= cForn
local _cLoja 		:= cLoja
local _cVencRea 	:= Substr(DTOS(dVencRea),1,6)
local _cDuplicAtu 	:= cDuplicAtu //Essa variável contem o PREFIXO (primeiros 3 digitos) + NUMERO DA DUPLICATA (Registros de 4 a 12
local cQSA2 		:= ""
local cQSE2 		:= ""
local cCGC  		:= ""
local cFornLj 		:= ""


public nVretPCC 	:= 0
public aVretPCC 	:= {}

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
cQSE2 += " AND SUBSTRING(E2_VENCREA,1,6) = '"+_cVencRea+"' "
cQSE2 += " AND E2_PREFIXO+E2_NUM <> '"+_cDuplicAtu+"' "
cQSE2 += " AND E2_X_NUMAP <= '"+cNumAp+"' "

if Select("TMPPCC") > 0
	dbSelectArea("TMPPCC")
	TMPPCC->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQSE2), 'TMPPCC', .T., .T.)
dbSelectArea("TMPPCC")
TMPPCC->(dbGotop())
if !TMPPCC->(eof())
	if TMPPCC->E2_BASEPIS > 5000
		lRet := 2 	// Retornando 2 significa que deverá pegar o valor de retenção da duplicata corrente.
		// Semelhante ao código 1
		Return lRet
	endif
endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Caso a soma das duplicatas acima sejam menores que 5mil, o sistema fará a soma total das duplicatas para compor o valor da retenção
cQSE2 := " SELECT SUM(E2_BASEPIS) E2_BASEPIS, SUM(E2_PIS) E2_PIS, SUM(E2_COFINS) E2_COFINS, SUM(E2_CSLL) E2_CSLL "
cQSE2 += "  FROM SE2010 "
cQSE2 += " WHERE D_E_L_E_T_ = ' ' AND E2_FORNECE+E2_LOJA in ("+cFornLj+") "
cQSE2 += " AND E2_BASEPIS > 0  and E2_PIS > 0 "
cQSE2 += " AND SUBSTRING(E2_VENCREA,1,6) = '"+_cVencRea+"' "
cQSE2 += " AND E2_X_NUMAP <= '"+cNumAp+"' "

if Select("TMPPCC") > 0
	dbSelectArea("TMPPCC")
	TMPPCC->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQSE2), 'TMPPCC', .T., .T.)
dbSelectArea("TMPPCC")
TMPPCC->(dbGotop())
if !TMPPCC->(eof())
	if TMPPCC->E2_BASEPIS > 5000
		lRet := 3 // Retornando 3 significa que deverá pegar o valor total de retenção do mes
		nVRetPCC := TMPPCC->(E2_PIS+E2_COFINS+E2_CSLL)
		aVretPCC := {TMPPCC->E2_PIS,TMPPCC->E2_COFINS,TMPPCC->E2_CSLL}
	else
		lRet := 4 // Retornando 4 significa que não deverá haver retenção
	endif
endif
return lRet

//Funcao para retornar o histórico do pedido de compras
Static function agobsped(cFilOrig,cNumPed)
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


/*---------------------------------------------------------   
Funcao : CMtoPX()  |Autor: AOliveira    |Data: 06-12-2017
-----------------------------------------------------------
DESCRI.: Transformar CM em PIXELS
---------------------------------------------------------*/
Static Function CMtoPX(_nCM)
Local nRet := 0  
Local nDpi := 300      

Default _nCM := 0

nRet := Round( ((_nCM * nDpi)/2.5), 0) //Transformar CM em PIXELS

Return(nRet)


Static Function XPRINTT(aText)
Local xY

//Imprimindo Texto
For xY:= 1 To Len(aText)
	nLin := 0
	nCol := 0
	
	nLin   := CMtoPX( aText[xY][1] ) //Linha
	nCol   := CMtoPX( aText[xY][2] ) //Coluna
	cText  := aText[xY][3] //Texto
	oFont  := aText[xY][4] //Font
	
	//nLin, nCol, cText, oFont
	oPrint:Say( nLin, nCol, cText, oFont)
	
Next xY
Return()	


/*---------------------------------------------------------
Funcao: PrintQrd()  |Autor: AOliveira    |Data: 28/11/2017
-----------------------------------------------------------
Descr.: Rotina tem como Objetivo Imprimir qdr Financeiro
		a partir da 2º pagina.
-----------------------------------------------------------
Uso:    Generico
---------------------------------------------------------*/
Static Function PrintQrd(_nQrd,lNewPag)

Local aQdrs02 := {}
Local aLines  := {} 
Local aLogo   := {}
Local xY

Local cFileLogo  := GetSrvProfString('Startpath','') +'lgrl'+Alltrim(cEmpAnt) + '.BMP'

Default _nQrd := 0
Default lNewPag := .f.

If _nQrd == 1
	AAdd(aQdrs02,{ 00.25, 00.85, 00.75, 13.55 })   // Quadro 13
	AAdd(aQdrs02,{ 00.25, 13.55, 00.75, 19.50 })   // Quadro 14
	AAdd(aQdrs02,{ 00.75, 00.85, 03.25, 19.50 })   // Quadro 15
	AAdd(aQdrs02,{ 03.25, 00.85, 03.85, 03.15 })   // Quadro 16
	AAdd(aQdrs02,{ 03.25, 03.15, 03.85, 19.50 })   // Quadro 17
	AAdd(aQdrs02,{ 03.85, 00.85, 05.15, 11.70 })   // Quadro 18
	AAdd(aQdrs02,{ 03.85, 11.70, 05.15, 19.50 })   // Quadro 19
	AAdd(aQdrs02,{ 05.15, 00.85, 07.15, 19.50 })   // Quadro 20
	
	AAdd(aLines,{ 06.55, 01.00, 06.55, 06.75 })
	AAdd(aLines,{ 06.55, 12.65, 06.55, 18.60 })

	AAdd(aLogo,{ 0.90, 01.15, 02.15, 04.40 })

ElseIf _nQrd == 2
	AAdd(aQdrs02,{ 07.45, 00.85, 07.95, 13.55 })   // Quadro 13
	AAdd(aQdrs02,{ 07.45, 13.55, 07.95, 19.50 })   // Quadro 14
	AAdd(aQdrs02,{ 07.95, 00.85, 10.45, 19.50 })   // Quadro 15
	AAdd(aQdrs02,{ 10.45, 00.85, 11.05, 03.15 })   // Quadro 16
	AAdd(aQdrs02,{ 10.45, 03.15, 11.05, 19.50 })   // Quadro 17
	AAdd(aQdrs02,{ 11.05, 00.85, 12.35, 11.70 })   // Quadro 18
	AAdd(aQdrs02,{ 11.05, 11.70, 12.35, 19.50 })   // Quadro 19
	AAdd(aQdrs02,{ 12.35, 00.85, 14.35, 19.50 })   // Quadro 20
	
	AAdd(aLines,{ 13.75, 01.00, 13.75, 06.75 })
	AAdd(aLines,{ 13.75, 12.65, 13.75, 18.60 })

	AAdd(aLogo,{ 08.10, 01.15, 09.35, 04.40 })
		
ElseIf _nQrd == 3
	AAdd(aQdrs02,{ 14.55, 00.85, 15.05, 13.55 })   // Quadro 13
	AAdd(aQdrs02,{ 14.55, 13.55, 15.05, 19.50 })   // Quadro 14
	AAdd(aQdrs02,{ 15.05, 00.85, 17.55, 19.50 })   // Quadro 15
	AAdd(aQdrs02,{ 17.55, 00.85, 18.15, 03.15 })   // Quadro 16
	AAdd(aQdrs02,{ 17.55, 03.15, 18.15, 19.50 })   // Quadro 17
	AAdd(aQdrs02,{ 18.15, 00.85, 19.45, 11.70 })   // Quadro 18
	AAdd(aQdrs02,{ 18.15, 11.70, 19.45, 19.50 })   // Quadro 19
	AAdd(aQdrs02,{ 19.45, 00.85, 21.45, 19.50 })   // Quadro 20
	
	AAdd(aLines,{ 20.85, 01.00, 20.85, 06.75 })
	AAdd(aLines,{ 20.85, 12.65, 20.85, 18.60 })
	
	AAdd(aLogo,{ 15.20, 01.15, 16.45, 04.40 })
		 
	lNewPag := .T.
EndIf

//Imprimindo Quadros principais.
For xY:= 1 To Len(aQdrs02)
	nLinIn := 0
	nColIn := 0
	nLinFi := 0
	nColFi := 0
	
	nLinIn := CMtoPX( aQdrs02[xY][1] )
	nColIn := CMtoPX( aQdrs02[xY][2] )
	nLinFi := CMtoPX( aQdrs02[xY][3] )
	nColFi := CMtoPX( aQdrs02[xY][4] )
	                                           
	oPrint:Box( nLinIn,nColIn,nLinFi,nColFi )
	
Next xY 

//Imprimindo Lines
For xY:= 1 To Len(aLines)  

	nTop    := 0
	nLeft   := 0
	nBottom := 0
	nRight  := 0
	
	nTop    := CMtoPX( aLines[xY][1] ) //
	nLeft   := CMtoPX( aLines[xY][2] ) //
	nBottom := CMtoPX( aLines[xY][3] ) //
	nRight  := CMtoPX( aLines[xY][4] ) //
	
	//nTop, nLeft, nBottom, nRight
	oPrint:Line ( nTop, nLeft, nBottom, nRight )
	
Next xY  

//Imprimindo Logo
For xY:= 1 To Len(aLogo)  

	nLinIn := 0
	nColIn := 0
	nLinFi := 0
	nColFi := 0

	nLinIn := CMtoPX( aLogo[xY][1] )
	nColIn := CMtoPX( aLogo[xY][2] )
	nLinFi := CMtoPX( aLogo[xY][3] )
	nColFi := CMtoPX( aLogo[xY][4] )
		
	nTop    := CMtoPX( aLogo[xY][1] ) //
	nLeft   := CMtoPX( aLogo[xY][2] ) //
	nBottom := CMtoPX( aLogo[xY][3] ) //
	nRight  := CMtoPX( aLogo[xY][4] ) //
	
	//nTop, nLeft, nBottom, nRight
	oPrint:SayBitmap( nLinIn, nColIn, cFileLogo, (nColFi-nColIn), (nLinFi-nLinIn))
		
Next xY  

Return(lNewPag)