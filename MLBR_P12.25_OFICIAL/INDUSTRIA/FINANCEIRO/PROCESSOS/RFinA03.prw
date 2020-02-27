#include "fileio.ch"             
#Include "PROTHEUS.CH"
/* 
-----------------------------------------------------------------------------
Função       : RFINA03		
Autor        : Gildésio Campos								Data: 19/05/2010
-----------------------------------------------------------------------------
Descricao    : Retorno do pagamento de Tributos Bradesco 
-----------------------------------------------------------------------------
Objetivo     : Ler arquivo de exportação gerado pelo OBB/Tributos Bradesco e 
               promover a baixa dos respectivos titulos no Financeiro/CP.
               Apenas titulos tipo Taxas serão tratados por essa rotina.
-----------------------------------------------------------------------------
*/
User Function RFinA03()

Local lOk	   := .F.
Local aSays    := {}
Local aButtons := {}

PRIVATE cCadastro := OemToAnsi( "Retorno gerado pelo OBB/Bradesco - Tributos")
/*
------------------------------------------------------------------
 Parametros                                         
------------------------------------------------------------------                                                   
MV_PAR01: Mostra Lanc. Contab  ? Sim Nao           
MV_PAR02: Aglutina Lanc. Contab? Sim Nao           
MV_PAR03: Arquivo de Entrada   ?                   
MV_PAR04: Arquivo de Config    ?                   
MV_PAR05: Banco                ?                   
MV_PAR06: Agencia              ?                   
MV_PAR07: Conta                ?                   
MV_PAR08: SubConta             ?                   
MV_PAR09: Contabiliza          ?                    
MV_PAR10: Padrao Cnab          ? Modelo1       NAO UTILIZADO
------------------------------------------------------------------
*/
If Pergunte("RFIN03",.T.)
	dbSelectArea("SE2")
	dbSetOrder(1)

	aADD(aSays,"Processamento do arquivo de retorno")
	aADD(aSays,"Pagamento de Tributos - Bradesco")
	aADD(aButtons, { 5,.T.,{|| Pergunte("RFIN03",.T. ) } } )
	aADD(aButtons, { 1,.T.,{|| lOk := .T.,FechaBatch()}} )
	aADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

	FormBatch( cCadastro, aSays, aButtons ,,,535)

	MV_PAR03 := UPPER(MV_PAR03)
	MV_PAR04 := UPPER(MV_PAR04)		//"\SYSTEM\BANCOS\TRIB\"

	If lOk
		RFinA03Gera()	//("SE2")
	EndIf

/*	---------------------------------------------------
	Recupera a Integridade dos dados                   
	---------------------------------------------------*/
	dbSelectArea("SE2")
	dbSetOrder(1)
EndIf

Return
/* 
-----------------------------------------------------------------------------
Função       : RFINA03GERA		
Autor        : Gildésio Campos								Data: 19/05/2010
-----------------------------------------------------------------------------
Descricao    : Retorno do pagamento de Tributos Bradesco 
-----------------------------------------------------------------------------
Objetivo     : Ler arquivo de exportação gerado pelo OBB/Tributos Bradesco e 
               promover a baixa dos respectivos titulos no Financeiro/CP.
               Apenas titulos tipo Taxas serão tratados por essa rotina.
-----------------------------------------------------------------------------
*/
Static Function RFinA03Gera()
PRIVATE cLotefin := " ",nTotAbat := 0,cConta := " "
PRIVATE nHdlBco := 0,nHdlConf := 0,nSeq := 0 ,cMotBx := "DEB"
PRIVATE nValEstrang := 0
PRIVATE nTotAGer := 0
PRIVATE VALOR  := 0
PRIVATE ABATIMENTO := 0
Private nAcresc, nDecresc
PRIVATE cMarca := GetMark()
PRIVATE aAC := { "Abandona","Confirma" }

Processa({|lEnd| RFin03Proc()})  // Chamada com regua
/*
--------------------------------
Fecha os Arquivos ASCII
--------------------------------*/
If nHdlBco > 0
	FCLOSE(nHdlBco)
Endif	           

If nHdlConf > 0
	FCLOSE(nHdlConf)
Endif	

Return .T.
/* 
-----------------------------------------------------------------------------
Função       : RFINA03GERA		
Autor        : Gildésio Campos								Data: 19/05/2010
-----------------------------------------------------------------------------
Descricao    : Retorno do pagamento de Tributos Bradesco 
-----------------------------------------------------------------------------
Objetivo     : Processamento do arquivo recebido do Banco
-----------------------------------------------------------------------------
*/
Static Function RFin03Proc()

Local cPosNum,cPosData,cPosDesp,cPosDesc,cPosAbat,cPosPrin,cPosJuro,cPosMult,cPosForne
Local cPosOcor,cPosTipo,cPosCgc, cRejeicao, cPosDebito
Local cChave430,cNumSe2,cChaveSe2
Local cArqConf,cArqEnt,cPosNsNum
Local cTabela    := "17",cPadrao,cLanca,cNomeArq
Local cFilOrig   := cFilAnt	// Salva a filial para garantir que nao seja alterada em customizacao
Local xBuffer
Local lPosNum    := .f., lPosData := .f.
Local lPosDesp   := .f., lPosDesc := .f., lPosAbat := .f.
Local lPosPrin   := .f., lPosJuro := .f., lPosMult := .f.
Local lPosOcor   := .f., lPosTipo := .f., lMovAdto := .F.
Local lPosNsNum  := .f., lPosForne:= .f., lPosRejei:= .f.
Local lPosCgc    := .f., lPosdebito:=.f.
Local lDesconto,lContabiliza,lUmHelp := .F.,lCabec := .f.
Local lPadrao    := .f., lBaixou := .f., lHeader := .f.
Local lRet       := .T.
Local nLidos,nLenNum,nLenData,nLenDesp,nLenDesc,nLenAbat,nLenForne,nLenRejei
Local nLenPrin,nLenJuro,nLenMult,nLenOcor,nLenTipo,nLenCgc, nLenDebito,nLenNsNum
Local nTotal     := 0,nPos,nPosEsp,nBloco := 0,nF:=0
Local nSavRecno  := Recno()
Local nTamForn   := Tamsx3("E2_FORNECE")[1]
//Local nTamOcor   := TamSx3("EB_REFBAN")[1]
Local aTabela    := {},aLeitura := {},aValores := {},aCampos := {}
Local dDebito
Local nTamTit	:= TamSX3("E2_PREFIXO")[1]+TamSX3("E2_NUM")[1]+TamSX3("E2_PARCELA")[1]
Local lNewIndice := RFinA03Ind()  //Verifica a existencia dos indices de IDCNAB sem filial

Private cBanco, cAgencia, cConta
Private cHist070, cArquivo
Private lAut:=.f., nTotAbat := 0
Private cCheque := " ", cPortado := " ", lAdiantamento := .F.
Private cNumBor := " ", cForne  := " " , cCgc := "", cDebito := ""
Private cModSpb := "1"  // Colocado apenas para não dar problemas nas rotinas de baixa
Private cAutentica := Space(25)  //Autenticacao retornada pelo segmento Z
Private cLote

lChqPre := .F.
/*
-----------------------------------------------------------------
Posiciona no Banco indicado                                  
-----------------------------------------------------------------*/
cBanco  := mv_par05
cAgencia:= mv_par06
cConta  := mv_par07
cSubCta := mv_par08

dbSelectArea("SA6")
DbSetOrder(1)                   
SA6->( dbSeek(xFilial("SA6")+cBanco+cAgencia+cConta) )

dbSelectArea("SEE")
DbSetOrder(1)
SEE->( dbSeek(xFilial("SEE")+cBanco+cAgencia+cConta+cSubCta) )
nBloco := If( SEE->EE_NRBYTES==0, 464, SEE->EE_NRBYTES+2)		

If !SEE->( found() )
	ApMsgAlert("Conta nao cadastrada na tabela SEE","Info","Atenção")
	lRet:= .F.
Endif

If lRet .And. GetMv("MV_BXCNAB") == "S" // Baixar arquivo recebidos pelo CNAB aglutinando os valores
	If Empty(SEE->EE_LOTECP)
		cLoteFin := "0001"
	Else
		cLoteFin := Soma1(SEE->EE_LOTECP)
	EndIf
EndIf

If lRet
	cTabela := Iif( Empty(SEE->EE_TABELA), "17" , SEE->EE_TABELA )
	dbSelectArea( "SX5" )
	If !SX5->( dbSeek( xFilial("SX5")+ cTabela ) )
		Help(" ",1,"PAR430")
		lRet := .F.
	Endif
EndIf
/*
---------------------------------------------------------
Verifica se arquivo ja foi processado anteriormente	
---------------------------------------------------------*/
If lRet .And. !(ChkExpFile())
	lRet := .F.
Endif

While lRet .And. !SX5->(Eof()) .and. SX5->X5_TABELA == cTabela
	AADD(aTabela,{Alltrim(X5Descri()),PadR(AllTrim(SX5->X5_CHAVE),3)})
	SX5->(dbSkip( ))
EndDo

If lRet
/*	--------------------------------------------------
	Verifica o numero do Lote
	--------------------------------------------------*/
	dbSelectArea("SX5")
	dbSeek(xFilial("SX5")+"09FIN")
	cLote := Substr(X5Descri(),1,4)
/*	--------------------------------------------------
	Arquivo de Entrada (Exportação)
	--------------------------------------------------*/
	cArqEnt := mv_par03
	IF !FILE(cArqEnt)
		ApMsgAlert("Arquivo de Entrada não encontrado.","INFO","Aviso")
		lRet:= .F.
	EndIf
/*	-----------------------------------------------------------------------
	Abre arquivo de configuracao (Retorno) conforme o Tipo de Tributo
	Nome do arquivo: XXX_EXPTRB.CPR     (X)--> Codigo no Layout
	-----------------------------------------------------------------------
	Onde XXX -->  (1)	001-DARF SIMPLES		| (2)	002-DARF PRETO
				  (5)	005-GARE DR				| (6)	006-GARE ICMS
				  (7)	007-GPS          		| (B)	010-CONTAS DE CONSUMO
				  (G)	011-GNRE via digitação  | (F)	012-FGTS
				  (R)	013-GARE-120			| (H)	014-GNRE
				  (D)	015-DARF via Cod.Barras	| (I)	016-IPTU
				  (O)	017-OUTROS via C.Barras	|
	-----------------------------------------------------------------------*/
	If lRet	
		cNomArqCfg := Right(Alltrim(cArqEnt),3)+"_EXPTRB.CPR" //001_EXPTRB.CPR
		cArqConf   := "\SYSTEM\BANCOS\TRIB\"+cNomArqCfg

		If !FILE(cArqConf)
			ApMsgAlert("Arquivo de Configuração não encontrado.","INFO","Aviso")
			lRet:= .F. 
		ElseIf ( MV_PAR10 == 1 )
			nHdlConf:=FOPEN(cArqConf,0+64)
		EndIf
	EndIF
EndIf
	
If lRet 
	/*	
	---------------------------------------
	Le arquivo de configuracao 
	---------------------------------------*/
	nLidos:=0
	FSEEK(nHdlConf,0,0)
	nTamArq:=FSEEK(nHdlConf,0,2)
	FSEEK(nHdlConf,0,0)
	While nLidos <= nTamArq
	/*	--------------------------------------------
		Verifica o tipo de qual registro foi lido 
		--------------------------------------------*/
		xBuffer:=Space(85)
		FREAD(nHdlConf,@xBuffer,85)                          

		IF SubStr(xBuffer,1,1) == CHR(1)
			nLidos+=85
			Loop
		EndIF
		IF SubStr(xBuffer,1,1) == CHR(3)
			Exit
		EndIF
		IF !lPosNum
			cPosNum:=Substr(xBuffer,17,10)
			nLenNum:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosNum:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosData
			cPosData:=Substr(xBuffer,17,10)
			nLenData:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosData:=.t.
			nLidos+=85
			Loop
		End
		IF !lPosDesp
			cPosDesp:=Substr(xBuffer,17,10)
			nLenDesp:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDesp:=.t.
			nLidos+=85
			Loop
		End
		IF !lPosDesc
			cPosDesc:=Substr(xBuffer,17,10)
			nLenDesc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDesc:=.t.
			nLidos+=85
			Loop
		End
		IF !lPosAbat
			cPosAbat:=Substr(xBuffer,17,10)
			nLenAbat:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosAbat:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosPrin
			cPosPrin:=Substr(xBuffer,17,10)
			nLenPrin:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosPrin:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosJuro
			cPosJuro:=Substr(xBuffer,17,10)
			nLenJuro:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosJuro:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosMult
			cPosMult:=Substr(xBuffer,17,10)
			nLenMult:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosMult:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosOcor
			cPosOcor:=Substr(xBuffer,17,10)
			nLenOcor:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosOcor:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosTipo
			cPosTipo:=Substr(xBuffer,17,10)
			nLenTipo:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosTipo:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosNsNum
			cPosNsNum := Substr(xBuffer,17,10)
			nLenNsNum := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosNsNum := .t.
			nLidos += 85
			Loop
		EndIF
		IF !lPosRejei
      		cPosRejei := Substr(xBuffer,17,10)
			nLenRejei := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosRejei := .t.
			nLidos += 85
			Loop
		EndIF
		IF !lPosForne
      		cPosForne := Substr(xBuffer,17,10)
			nLenForne := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosForne := .t.
			nLidos += 85
			Loop
		EndIF
		IF !lPosCgc
	      	cPosCgc   := Substr(xBuffer,17,10)
			nLenCgc   := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosCgc   := .t.
			nLidos += 85
			Loop
		EndIF
		IF !lPosDebito
			cPosDebito:=Substr(xBuffer,17,10)
			nLenDebito:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDebito:=.t.
			nLidos+=85
			Loop
		EndIF
	EndDo
	/*	
	-----------------------------------
	Fecha arquivo de configuracao 
	-----------------------------------*/
	Fclose(nHdlConf)
EndIf 
/*
-------------------------------------------
Abre arquivo de exportação gerado pelo OBB 
-------------------------------------------*/
If lRet
	cArqEnt:=mv_par03
	IF !FILE(cArqEnt)
		ApMsgAlert("Arquivo de Entrada não encontrado","INFO","Atenção")
		lRet:= .F.
	Else
		nHdlBco:=FOPEN(cArqEnt,0+64)
	EndIF
EndIf

If lRet
	nLidos:=0
	FSEEK(nHdlBco,0,0)
	nTamArq:=FSEEK(nHdlBco,0,2)
	FSEEK(nHdlBco,0,0)
	
	ProcRegua( nTamArq/nBloco )
/*	----------------------------------		
	Gera arquivo de Trabalho            
	----------------------------------*/
	AADD(aCampos,{"FILMOV","C",02,0})
	AADD(aCampos,{"DATAD","D",08,0})
	AADD(aCampos,{"TOTAL","N",17,2})
	
	If Select("TRB") == 0
		cNomeArq:=CriaTrab(aCampos)
		dbUseArea( .T., __cRDDNTTS, cNomeArq, "TRB", if(.F. .Or. .F., !.F., NIL), .F. )
		IndRegua("TRB",cNomeArq,"FILMOV+Dtos(DATAD)",,,"")
	Endif
	
	While nLidos <= nTamArq
		IncProc()
		nDespes :=0
		nDescont:=0
		nAbatim :=0
		nValRec :=0
		nJuros  :=0
		nMulta  :=0
		nValCc  :=0
		nValPgto:= 0
		nCM     := 0
		ABATIMENTO := 0
	
		cFilAnt := cFilOrig					// sempre restaura a filial original 
		
		xBuffer:=Space(nBloco)
		FREAD(nHdlBco,@xBuffer,nBloco)
		/*	
		-------------------------------------------
		Le aquivo de exportação gerado pelo OBB 
		-------------------------------------------*/
		cOcorr := Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor)
		cOcorr := AllTrim(cOcorr)
			
		If cOcorr != '04' .And. cOcorr != '11'	//04-INCONSISTENTE	11-PAGAMENTO EFETUADO
			nLidos += nBloco
			Loop
        EndIf
            
		cNumTit :=Substr(xBuffer,Int(Val(Substr(cPosNum, 1,3))),nLenNum )
		cData   :=Substr(xBuffer,Int(Val(Substr(cPosData,1,3))),nLenData)
		cData   :=ChangDate(cData,SEE->EE_TIPODAT)
		dBaixa  :=Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y",Len(Substr(cData,5))))
		dDebito :=dBaixa		// se nao for preenchido, usa dBaixa
		cTipo   :=Substr(xBuffer,Int(Val(Substr(cPosTipo, 1,3))),nLenTipo )
		cNsNum  := " "
			
		If !Empty(cPosDesp)
			nDespes:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosDesp,1,3))),nLenDesp))/100,2)
		EndIf
		If !Empty(cPosDesc)
			nDescont:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosDesc,1,3))),nLenDesc))/100,2)
		EndIf
		If !Empty(cPosAbat)
			nAbatim:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosAbat,1,3))),nLenAbat))/100,2)
		EndIf
		If !Empty(cPosPrin)
			nValPgto :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosPrin,1,3))),nLenPrin))/100,2)
		EndIF
		If !Empty(cPosJuro)
			nJuros  :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosJuro,1,3))),nLenJuro))/100,2)
		EndIf
		If !Empty(cPosMult)
			nMulta  :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosMult,1,3))),nLenMult))/100,2)
		EndIf
		If !Empty(cPosNsNum)
			cNsNum  :=Substr(xBuffer,Int(Val(Substr(cPosNsNum,1,3))),nLenNsNum)
		EndIf
		IF !Empty(cPosRejei)
			cRejeicao  :=Substr(xBuffer,Int(Val(Substr(cPosRejei,1,3))),nLenRejei)
		End
		IF !Empty(cPosForne)
			cForne  :=Substr(xBuffer,Int(Val(Substr(cPosForne,1,3))),nLenForne)
		End

//			cOcorr := Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor)
//			cOcorr := AllTrim(cOcorr)
	
		If !Empty(cPosCgc)
			cCgc  :=Substr(xBuffer,Int(Val(Substr(cPosCgc,1,3))),nLenCgc)
		Endif

		If !Empty(cPosDebito)
			cDebito :=Substr(xBuffer,Int(Val(Substr(cPosDebito,1,3))),nLenDebito)
			cDebito :=ChangDate(cDebito,SEE->EE_TIPODAT)
			If !Empty(cDebito)
				dDebito :=Ctod(Substr(cDebito,1,2)+"/"+Substr(cDebito,3,2)+"/"+Substr(cDebito,5),"ddmm"+Replicate("y",Len(Substr(cDebito,5))))
			Endif
		Endif
		nCM := 0
		/*
		------------------------------------
		Verifica especie do titulo
		--> Sempre tipo 'TX'
		------------------------------------*/
		nPos := Ascan(aTabela, {|aVal|aVal[1] == Alltrim(Substr(cTipo,1,3))})
		If nPos != 0
			cEspecie := aTabela[nPos][2]
		Else
			cEspecie := "TX "		//Alterado para nao ter que informar tipo no layout de envio
		EndIf

		/*
		------------------------------------
		Despreza se for titulo de abatimento
		------------------------------------*/
		If cEspecie $ MVABATIM		// Nao lˆ titulo de abatimento
			nLidos += nBloco
			Loop
		EndIf
/*		--------------------------------------------------------------------
		Verifica se existe o titulo no SE2. Caso este titulo nao seja
		localizado, passa-se para a proxima linha do arquivo retorno
		--------------------------------------------------------------------*/	
		dbSelectArea("SE2")
		dbSetOrder( 1 )
		lHelp := .F.
       	/*
       	--------------------------------
       	Pesquisa Registro pelo IdCnab
       	--------------------------------*/
		If lNewIndice .and. !Empty(xFilial("SE2"))
			SE2->(dbSetOrder(13)) // IdCnab (sem filial)
			SE2->(MsSeek(Substr(cNumTit,1,10)))
			cFilAnt	:= SE2->E2_FILIAL
			mv_par09	:= 2  //Desligo contabilizacao on-line				
		Else
			SE2->(dbSetOrder(11)) // Filial+IdCnab
			SE2->(MsSeek(xFilial("SE2")+	Substr(cNumTit,1,10)))
		Endif
       	/*
       	------------------------------------
       	Pesquisa Registro pelo titulo no SE2
       	------------------------------------*/
		If SE2->(!Found())
			SE2->(dbSetOrder(1))			
			While .T.
				cChave430 := IIf(!Empty(cForne),Pad(cNumTit,nTamTit)+cEspecie+SubStr(cForne,1,nTamForn),Pad(cNumTit,nTamTit)+cEspecie)
				If !(dbSeek(xFilial("SE2")+cChave430))
					nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,3))},nPos+1)
					If nPos != 0
						cEspecie := aTabela[nPos][2]
					Else
						Exit
					Endif
				Else
					cNumSe2   := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
					cChaveSe2 := IIf(!Empty(cForne),cNumSe2+SE2->E2_FORNECE,cNumSe2)
					nPosEsp	  := nPos	// Gravo nPos para volta-lo ao valor inicial, caso encontre o titulo
	    	
					While !Eof() .and. SE2->E2_FILIAL+cChaveSe2 == xFilial("SE2")+cChave430
						nPos := nPosEsp
						If Empty(cCgc)
							Exit
						Endif
						dbSelectArea("SA2")
						If dbSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
							If Substr(SA2->A2_CGC,1,14) == cCGC .or. StrZero(Val(SA2->A2_CGC),14,0) == StrZero(Val(cCGC),14,0)
								Exit
							Endif
						Endif
						dbSelectArea("SE2")
						dbSkip()
						cNumSe2   := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
						cChaveSe2 := IIf(!Empty(cForne),cNumSe2+SE2->E2_FORNECE,cNumSe2)
						nPos 	  := 0
					Enddo
					Exit
				EndIF
			Enddo	
		Else
			nPos := 1
		Endif
		
		If nPos == 0
			lHelp := .T.
		EndIF
		
		If !lUmHelp .And. lHelp
			ApMsgAlert("Especie do titulo Invalida","INFO","Aviso")
			lUmHelp := .T.
		Endif

		If !lHelp
			dbSelectArea("SE2")

			IF nF == 0
				nF:=1
				cPadrao:="530"
				lPadrao:=VerPadrao(cPadrao)
				lContabiliza:= Iif(mv_par09==1,.T.,.F.)
			Endif
		/*	----------------------------------------
			Monta Contabilizacao
			----------------------------------------*/
			If !lCabec .and. lPadrao .and. lContabiliza
				nHdlPrv:=HeadProva(cLote,"RFINA03",Substr(cUsuario,7,6),@cArquivo) 
				lCabec := .t.
			EndIf
			nValEstrang := SE2->E2_SALDO
			lDesconto   := .F.
			nTotAbat	:= SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,;
							SE2->E2_FORNECE,SE2->E2_MOEDA,"S",dBaixa,SE2->E2_LOJA)
			ABATIMENTO  := nTotAbat
			cBanco      := mv_par05
			cAgencia    := mv_par06
			cConta      := mv_par07
			cHist070    := "Valor ref pagto de Tributos"  //"Valor Pago s/ Titulo "
		/*	----------------------------------------------------------
			Verifica se a despesa esta descontada do valor principal
			----------------------------------------------------------*/				
			If SEE->EE_DESPCRD == "S"
				nValPgto+=nDespes
			EndIF
			nTotAger += nValPgto
			cLanca := Iif(mv_par09==1,"S","N")
			cBenef := SE2->E2_NOMFOR

			BEGIN TRANSACTION
				If SE2->E2_TIPO $ MVPAGANT+"/"+MVTXA
					RecLock("SE5",.T.)
					SE5->E5_FILIAL	:= xFilial()
					SE5->E5_BANCO	:= cBanco
					SE5->E5_AGENCIA := cAgencia
					SE5->E5_CONTA	:= cConta
					SE5->E5_DATA	:= dBaixa
					SE5->E5_VALOR	:= SE2->E2_VLCRUZ
					SE5->E5_NATUREZ := SE2->E2_NATUREZ
					SE5->E5_RECPAG  := "P"
					SE5->E5_TIPO	:= IIF(SE2->E2_TIPO $ MVPAGANT,MVPAGANT,MVTXA)
					SE5->E5_LA		:= "S"
					SE5->E5_TIPODOC := IIF(SE2->E2_TIPO $ MVPAGANT,"PA","TXA")
					SE5->E5_HISTOR  := SE2->E2_HIST
					SE5->E5_BENEF   := SA2->A2_NOME
					SE5->E5_PREFIXO := SE2->E2_PREFIXO
					SE5->E5_NUMERO  := SE2->E2_NUM
					SE5->E5_PARCELA := SE2->E2_PARCELA
					SE5->E5_CLIFOR  := SE2->E2_FORNECE
					SE5->E5_LOJA	:= SE2->E2_LOJA
					SE5->E5_DTDIGIT := dDataBase
					SE5->E5_MOTBX	:= "NOR"
					SE5->E5_DTDISPO := SE5->E5_DATA
					SE5->E5_VLMOED2 := SE2->E2_VALOR
					If SPBInUse()
						SE5->E5_MODSPB		:= SE2->E2_MODSPB
					Endif
					AtuSalBco( cBanco,cAgencia,cConta,SE5->E5_DTDISPO,SE5->E5_VALOR,"-" )
					lBaixou := .T.
					lMovAdto := .T.
		      	ELSE
					// Serao usadas na Fa080Grv para gravar a baixa do titulo, considerando os acrescimos e decrescimos
					nAcresc     := Round(NoRound(xMoeda(SE2->E2_SDACRES,SE2->E2_MOEDA,1,dBaixa,3),3),2)
					nDecresc    := Round(NoRound(xMoeda(SE2->E2_SDDECRE,SE2->E2_MOEDA,1,dBaixa,3),3),2)
		        	lBaixou:=fA080Grv(lPadrao,.F.,.T.,cLanca,cArqEnt)
		        	lMovAdto := .F.
				ENDIF
			END TRANSACTION
				
			If lBaixou .and. !lMovAdto		// somente gera pro lote quando nao for PA para nao duplicar no Extrato 
				dbSelectArea("TRB")
				If !(dbSeek(xFilial("SE5")+Dtos(dDebito)))
					Reclock("TRB",.T.)
					Replace FILMOV With xFilial("SE5")
					Replace DATAD With dDebito
				Else
					Reclock("TRB",.F.)
				Endif
				Replace TOTAL WITH TOTAL + nValPgto
				MsUnlock()
		    Endif
				
			If lCabec .and. lPadrao .and. lContabiliza .and. lBaixou
				nTotal+=DetProva(nHdlPrv,cPadrao,"RFINA03",cLote)
			EndIf
			
			If cOcorr == '04' //04-INCONSISTENTE
				dbSelectArea("SE2")
				dbSetOrder(11)  // Filial+IdCnab

				If !DbSeek(xFilial("SE2")+	Substr(cNumTit,1,10))
					dbSetOrder(1)
					dbSeek(xFilial()+Pad(cNumTit,nTamTit)+cEspecie) // Filial+Prefixo+Numero+Parcela+Tipo
				Endif
				
				dbSelectArea("SEA")
				dbSetOrder(1)
				dbSeek(xFilial()+SE2->E2_NUMBOR+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)  
				
				If ( Found() .And. SE2->E2_SALDO != 0 )
					Begin Transaction
						RecLock( "SE2" )
						SE2->E2_NUMBOR := Space(6)
						SE2->E2_PORTADO := Space(Len(SE2->E2_PORTADO))
						SE2->E2_IDCNAB  := Space(Len(SE2->E2_IDCNAB))
						MsUnlock( )           
						
						dbSelectArea("SEA")
						RecLock("SEA",.F.,.T.)
						dbDelete()
						MsUnlock( )
					End Transaction
				EndIf
			EndIf
		EndIf
	EndDo
	
	cFilAnt := cFilOrig					// sempre restaura a filial original 
	
	If lCabec .and. lPadrao .and. lContabiliza 
		dbSelectArea("SE2")
		dbGoBottom()
		dbSkip()
		VALOR := nTotAger
		ABATIMENTO := 0
		nTotal+=DetProva(nHdlPrv,cPadrao,"RFINA03",cLote)
	Endif
	
	IF lPadrao .and. lContabiliza .and. lCabec
		RodaProva(nHdlPrv,nTotal)
		/*
		-------------------------------------------
		Envia para Lancamento Contabil                      
		-------------------------------------------*/
		lDigita:=IIF(mv_par01==1,.T.,.F.)
		lAglut :=IIF(mv_par02==1,.T.,.F.)
		cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
	End
/*	---------------------------------------------------------------------------
	Grava no SEE o n£mero do Ultimo lote recebido e gera movimentacao bancaria
	---------------------------------------------------------------------------*/
	If !Empty(cLoteFin) .and. GetMv("MV_BXCNAB") == "S"
		If TRB->(Reccount()) > 0
			RecLock("SEE",.F.)
			SEE->EE_LOTECP := cLoteFin
			MsUnLock()

			dbSelectArea("TRB")
			dbGotop()

			While !Eof()
				Reclock( "SE5" , .T. )
				SE5->E5_FILIAL := xFilial()
				SE5->E5_DATA   := TRB->DATAD
				SE5->E5_VALOR  := TRB->TOTAL
				SE5->E5_RECPAG := "P"
				SE5->E5_DTDIGIT:= TRB->DATAD
				SE5->E5_BANCO  := cBanco
				SE5->E5_AGENCIA:= cAgencia
				SE5->E5_CONTA  := cConta
				SE5->E5_DTDISPO:= TRB->DATAD
				SE5->E5_LOTE   := cLoteFin
				SE5->E5_HISTOR := "Baixa por Retorno CNAB / Lote : " + cLoteFin 
				If SpbInUse()
					SE5->E5_MODSPB := "1"
				Endif
				MsUnlock()
			/*	--------------------------------------------
				Atualiza saldo bancario
				--------------------------------------------*/
				AtuSalBco(cBanco,cAgencia,cConta,SE5->E5_DATA,SE5->E5_VALOR,"-")

				dbSelectArea("TRB")
				dbSkip()
			Enddo
		Endif	
	EndIf
	
	dbSelectArea("TRB")
	dbCloseArea()
	Ferase(cNomeArq+GetDBExtension())         // Elimina arquivos de Trabalho
	Ferase(cNomeArq+OrdBagExt())	 		  // Elimina arquivos de Trabalho
	
	VALOR := 0
EndIf
	
Return .F.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ChangDate ³ Autor ³ Wagner Xavier         ³ Data ³ 23/06/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Converte um string data para o formato ddmmaa de acordo com ³±±
±±³          ³um determionado tipo passado para a fun‡„o.                 ³±±
±±³          ³Tipo 1 - ddmmaa                                             ³±±
±±³          ³Tipo 2 - mmddaa                                             ³±±
±±³          ³Tipo 3 . aammdd                                             ³±±
±±³          ³Tipo 4 - ddmmaaaa                                           ³±±
±±³          ³Tipo 5 - aaaammdd                                           ³±±
±±³          ³Tipo 6 - mmddaaaa                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/             
Static Function ChangDate(__cData,nPosicao)
LOCAL nPosDia:=0,nPosMes:=0,nPosAno:=0
LOCAL aSubs  := {}

// posicao do dia,mes,ano,tamanho do ano;
AADD( aSubs,{ 01,03,05,2 } )
AADD( aSubs,{ 03,01,05,2 } )
AADD( aSubs,{ 05,03,01,2 } )
AADD( aSubs,{ 01,03,05,4 } )
AADD( aSubs,{ 07,05,01,4 } )
AADD( aSubs,{ 03,01,05,4 } )

If nPosicao == 0;nPosicao++;Endif

nPosDia := aSubs[nPosicao][1]
nPosMes := aSubs[nPosicao][2]
nPosAno := aSubs[nPosicao][3]

__cData := Substr(__cData,nPosDia,2)+Substr(__cData,nPosMes,2)+Substr(__cData,nPosAno,aSubs[nPosicao][4])

If Len(__cData) == 8
	__cData := Substr(__cData,1,4)+Substr(__cData,7,2)
Endif

Return(__cData)
/*
-----------------------------------------------------------------------------
Funcao	 : ChkExpFile()
-----------------------------------------------------------------------------
Descricao: Checa se arquivo de TB j  foi processado anteriormente
-----------------------------------------------------------------------------*/
Static Function ChkExpFile()  
LOCAL cFile := "PT"+cNumEmp+".VRF"
LOCAL lRet	:= .F.
LOCAL aFiles:= {}
LOCAL cString
LOCAL nTam
LOCAL nHdlFile

If !FILE(cFile)
	nHdlFile := fCreate(cFile)
ELSE
	While (nHdlFile := fOpen(cFile,FO_READWRITE+FO_EXCLUSIVE))==-1 .AND. ;
		MsgYesNo("Nao foi possivel abrir o arquivo TB"+cNumEmp+".VRF, Deseja tentar novamente ?","Atencao !!!")
	End
Endif

If nHdlFile > 0

	nTam := TamSx1("RFIN03","03")[1] // Tamanho do parametro
	xBuffer := SPACE(nTam)
	// Le o arquivo e adiciona na matriz
	While fReadLn(nHdlFile,@xBuffer,nTam) 
		Aadd(aFiles, Trim(xBuffer))
	Enddo	

	If ASCAN(aFiles,Trim(MV_PAR03)) > 0   
		ApMsgAlert("Arquivo de Trans.Banc. j  processado","INFO","Atenção")
	Else
		fSeek(nHdlFile,0,2) // Posiciona no final do arquivo
		cString := Alltrim(mv_par03)+Chr(13)+Chr(10)
		fWrite(nHdlFile,cString)	// Grava nome do arquivo a ser processado
		lRet := .T.
	Endif	
	fClose (nHdlFile)
Else
	ApMsgAlert("Erro na leitura do arquivo de entrada","INFO","Atenção")
EndIf	

Return lRet
/*
-----------------------------------------------------------------------------
Funcao   : RFinA03Ind()
-----------------------------------------------------------------------------
Descricao: Verifica existencia dos indices 19(SE1) e 13(SE2)         
-----------------------------------------------------------------------------*/
Static Function RFinA03Ind()
Local lIndSE1 := .F.
Local lIndSE2 := .F.
Local aAreaAtu := GetArea()

//Verifica existencia do indice 12 do SE5 - E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ
dbSelectArea("SIX")
If MSSeek("SE1"+"J") 
	If "E1_IDCNAB" $ CHAVE .AND. !("E1_FILIAL" $ CHAVE)
		lIndSE1 :=	.T.
	EndIf
Endif
If MSSeek("SE2"+"D") 
	If "E2_IDCNAB" $ CHAVE .AND. !("E2_FILIAL" $ CHAVE)
		lIndSE2 :=	.T.
	EndIf
Endif
	
RestArea(aAreaAtu)

Return (lIndSe1 .and. lIndSe2)
