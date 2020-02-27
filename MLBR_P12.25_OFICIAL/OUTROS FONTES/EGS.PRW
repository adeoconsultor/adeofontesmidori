#INCLUDE "PROTHEUS.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLFTJ001I  บAutor  ณAndreia J da Silva  บ Data ณ  17/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao da Query e Montagem do Layout.                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LUFT				                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function EGS()

Local cNomArq	:= "Relatorio NDI"
Local _cQuery	:= ""
Local cAlias	:= ""
Local lReturn	:= .F.
Local cPerg		:= 'EGS001'     

Private cCadastro   := "Geracao de Arquivo Texto "

AjustaSx1(cPerg)
If Pergunte( cPerg, .T. )  
    //CRIAR UMA PASTA COM ESTE NOME NO MESMO LUGAR ONDE ESTA A PASTA SYSTEM
	cDiret := "\Exporta\"+cNomArq+".TXT"
	
	_cQuery := " SELECT SC1.C1_FILIAL AS FILIAL, SC1.C1_NUM AS NUN_SC, SC1.C1_USER AS SOLICITANTE," 
	_cQuery += " SC1.C1_SITEID AS SITE_ID, SC1.C1_ESCOPO AS ESCOPO, SC1.C1_AREA AS AREA, SC1.C1_TPPAGTO AS PAGTO, SC1.C1_IDENTIF AS IDENTIFICACAO,"
	_cQuery += " SC1.C1_DTINIC AS DT_INI, SC1.C1_DTFINAL AS DT_FIN,"
	_cQuery += " SC1.C1_EMISSAO AS DT_EMISSAO_SC, SC1.C1_DTAPROV AS DT_APROV_SC, SC7.C7_NUM AS NUM_PC, SUM(SC7.C7_TOTAL) AS TOT_PC,"
	_cQuery += " SC7.C7_EMISSAO AS DT_EMISSAO_PC,"
	_cQuery += " SD1.D1_DOC AS NUM_NF, SUM(SD1.D1_TOTAL) AS TOT_NF,"
	_cQuery += " (SELECT MAX(SCR.CR_DATALIB)"
	_cQuery += " FROM "
	_cQuery  +=	RetSqlName("SCR") + " SCR "
	_cQuery += " WHERE SCR.D_E_L_E_T_=''"
	_cQuery += " AND SCR.CR_NUM = SC7.C7_NUM "
	_cQuery += " AND SCR.CR_FILIAL = SC1.C1_FILIAL)AS DT_APROV_PC," //DA ERRO AQUI.....
	_cQuery += " SC7.C7_TPSERV AS TIPO_SERV, SC7.C7_CC AS CENT_CUSTO, SC7.C7_CONTA AS CONT_CTBL, SC7.C7_ITEMCTA AS ITEM_CTBL,"
	_cQuery += " SUM(SC7.C7_TOTAL) AS TOTAL, SD1.D1_DTDIGIT AS CONTABILIZADO "
	_cQuery += " FROM "  
	_cQuery  +=	RetSqlName("SC7") + " SC7, "
	_cQuery  +=	RetSqlName("SD1") + " SD1, "
	_cQuery  +=	RetSqlName("SC1") + " SC1  "
	_cQuery += " WHERE SC1.C1_NUM = SC7.C7_NUMSC "
	_cQuery += " AND SC1.C1_ITEM = SC7.C7_ITEMSC "
	_cQuery += " AND SC7.C7_NUM  = SD1.D1_PEDIDO  "
	_cQuery += " AND SC7.C7_ITEM = SD1.D1_ITEMPC "
	_cQuery += " AND SC1.D_E_L_E_T_ = ' '"
	_cQuery += " AND SC7.D_E_L_E_T_ = ' '"
	_cQuery += " AND SD1.D_E_L_E_T_ = ' '"
	_cQuery += " AND SD1.D1_FILIAL = SC7.C7_FILIAL "
	_cQuery += " AND SD1.D1_FILIAL = SC1.C1_FILIAL "
	_cQuery += " AND SC1.C1_DTAPROV != ' ' "
	_cQuery += " AND SD1.D1_DTDIGIT BETWEEN '" + DTOS(mv_par01) + "'"
	_cQuery += " AND '" + DTOS(mv_par02) + "'"
	_cQuery += " GROUP BY SC1.C1_FILIAL,SC1.C1_NUM,SC1.C1_USER,SC1.C1_SITEID, SC1.C1_ESCOPO, SC1.C1_AREA, SC1.C1_TPPAGTO, SC1.C1_IDENTIF," 
	_cQuery += " SC1.C1_DTINIC, SC1.C1_DTFINAL, SC1.C1_EMISSAO, SC1.C1_DTAPROV, SC7.C7_NUM,"
	_cQuery += " SD1.D1_DOC, SC7.C7_TPSERV, SC7.C7_EMISSAO, SC7.C7_CC, SC7.C7_CONTA, SC7.C7_ITEMCTA, SD1.D1_DTDIGIT "
	_cQuery += " ORDER BY SC7.C7_NUM "
	memowrit("E:\Query\testePA1.sql",_cQuery)//monta query de sql
	_cQuery := ChangeQuery(_cQuery)
	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,_cQuery),"QRY",.T.,.T.)
	
	cAlias := "QRY"
	
	//A QUERY ESTA SENDO GERADA SEM REGISTROS
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMV_PAR01 - Emissao De                       ณ
	//ณMV_PAR02 - Emissao Ate                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
	cNomArq := AllTrim(cNomArq)+".TXT"
		
	//If QRY->(!EOF())
		lReturn :=	U_MontaArq(cDiret,cNomArq)
	//EndIf
	
	If SELECT("QRY") > 0
		QRY->( dbCloseArea() )
	EndIf
EndIf

Return lReturn

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaArq  บAutor  ณMicrosiga           บ Data ณ  06-20-08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta estrutura do Arquivo texto                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LUFT                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function MontaArq(cDiret,cNomArq)
Local aArea		   := GetArea()
Local lRet		   := .T.
//Local nTotal	   := 0
Local nHandle1	   := 0
Private nValTot	   := 0
Private cQuebraLin := Chr(13)+Chr(10)  // Caracteres de Salto de Linha
Private nQtdReg    := 0                
Private	cFilial	   := ''
Private	cNumSC	   := ''      
Private	cSol	   := ''		
Private	cSite	   := ''       
Private	cEscopo		:= ''		
Private	cArea		:= ''		
Private	cTpPagto	:= ''	
Private	cIdentif	:= ''	
Private	dDtInic		:= ''		
Private	dDtFin		:= ''		
Private	dDtEmiSC	:= ''
Private	dDtApvSC	:= ''
Private	nNumPc		:= ''
Private	nTotPC		:= 0
Private	dDtEmiPC	:= ''
Private	cNunNF		:= ''
Private	nTotNF		:= 0
Private	dDtApvPC	:= ''
Private	cTpServ		:= ''
Private	cCC         := ''
Private	cCNTCTBL    := ''
Private	cITEMCTBL   := ''
Private	nTotal      := 0
Private	nContab     := 0
Private	nQtdReg		:= 0

aCampos := {}
Aadd(aCampos,{"Fil"			,"C", 001, 002, 002, 'FILIAL'		, 'L' } )
Aadd(aCampos,{"NUM.SC"		,"C", 003, 008, 006, 'cNumSC'		, 'L' } )
Aadd(aCampos,{"SOL"			,"C", 009, 014, 006, 'cSol' 		, 'L' } )
Aadd(aCampos,{"SITE_ID"		,"C", 015, 020, 050, 'cSite' 		, 'L' } )
Aadd(aCampos,{"ESCOPO"	 	,"C", 065, 070, 050, 'cEscopo'		, 'L' } )
Aadd(aCampos,{"AREA"		,"C", 115, 120, 002, 'cArea'		, 'L' } )
Aadd(aCampos,{"TPPAGTO" 	,"C", 117, 122, 002, 'cTpPagto'		, 'L' } )
Aadd(aCampos,{"IDENTIF" 	,"C", 119, 124, 030, 'cIdentif'		, 'L' } )
Aadd(aCampos,{"DTINIC"	 	,"C", 149, 154, 008, 'dDtInic'		, 'L' } )
Aadd(aCampos,{"DTFIN" 		,"D", 157, 162, 008, 'dDtFin'		, 'L' } )
Aadd(aCampos,{"DT_EMIS_SC"	,"D", 165, 170, 008, 'dDtEmiSC'		, 'L' } )
Aadd(aCampos,{"DT_APV_SC"	,"D", 173, 178, 008, 'dDtApvSC'		, 'L' } )
Aadd(aCampos,{"NUM_PC"		,"N", 181, 186, 009, 'nNumPc' 		, 'L' } )
Aadd(aCampos,{"TOT_PC"		,"N", 190, 195, 016, 'nTotPC' 		, 'L' } )
Aadd(aCampos,{"DT_EMIS_PC"	,"D", 206, 211, 008, 'dDtEmiPC'	 	, 'L' } )
Aadd(aCampos,{"NUM_NF"		,"C", 214, 219, 009, 'cNunNF' 		, 'L' } )
Aadd(aCampos,{"TOT_NF"		,"N", 223, 228, 016, 'nTotNF' 		, 'L' } )
Aadd(aCampos,{"DT_APV_PC"	,"D", 239, 244, 008, 'dDtApvPC'		, 'L' } )
Aadd(aCampos,{"TPSERV"   	,"C", 247, 252, 002, 'cTpServ' 		, 'L' } )
Aadd(aCampos,{"CC"    		,"C", 249, 254, 009, 'cCC' 			, 'L' } )
Aadd(aCampos,{"CNT_CTBL"	,"C", 258, 263, 020, 'cCNTCTBL'		, 'L' } )
Aadd(aCampos,{"ITEM_CTBL"	,"C", 278, 283, 009, 'cITEMCTBL'	, 'L' } )
Aadd(aCampos,{"TOT"	   		,"N", 287, 292, 016, 'nTotal' 		, 'L' } )
Aadd(aCampos,{"CONTABTOT"	,"N", 303, 308, 008, 'nContab' 		, 'L' } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ						      Montar Detalhes          					ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//If QRY->( !Eof() )
If QRY->( Eof() )
	nHandle1 := FCreate(AllTrim(cDiret))

	VarInfo('nHandle', nHandle1)    
	VarInfo('cDiret' , cDiret )

	//If nHandle1 >= 0
	If nHandle1 <= 0
		ProcRegua(50)
		//cLote := QRY->PA1_LOTE
		FWrite(nHandle1,U_GeraArq(aCampos))
		
//		While QRY->(!Eof()).And. cLote == QRY->PA1_LOTE
		While QRY->(Eof())
			IncProc("Processando...")
			//COLOCAR OS CAMPOS DA QUERY AQUI PORQUE NAO ALTEREI ISTO   
			
			cFilial		:= QRY->C1_FILIAL
			cNumSC      := QRY->C1_NUM
			cSol		:= QRY->C1_USER
			cSite       := QRY->C1_SITEID
			cEscopo		:= QRY->C1_ESCOPO
			cArea		:= QRY->C1_AREA
			cTpPagto	:= QRY->C1_TPPAGTO
			cIdentif	:= QRY->C1_IDENTIF
			dDtInic		:= QRY->C1_DTINIC
			dDtFin		:= QRY->C1_DTFIN
			dDtEmiSC	:= QRY->C1_EMISSAO
			dDtApvSC	:= QRY->C1_DTAPROV
			nNumPc		:= QRY->C1_NUM
			nTotPC		:= QRY->C7_TOTAL
			dDtEmiPC	:= QRY->C7_EMISSAO
			cNunNF		:= QRY->D1_DOC
			nTotNF		:= QRY->D1_TOTAL
			dDtApvPC	:= QRY->CR_DATALIB	
			cTpServ		:= QRY->C7_TPSERV
			cCC         := QRY->C7_CC
			cCNTCTBL    := QRY->C7_CONTA
			cITEMCTBL   := QRY->C7_ITEMCTA
			nTotal      := QRY->C7_TOTAL
			nContab     := QRY->D1_DTDIGIT
			nQtdReg		+= 1			
						
			RepassaDados(nHandle1)

			QRY->(DbSkip())
		EndDo
		
		FWrite(nHandle1,U_GeraArq(aTraller)) //Escreve o Arquivo Texto
		FClose(nHandle1) //Fecha o Arquivo Texto
	Else
		Conout("["+AllTrim(cDiret)+"]")
		Conout('Nao foi possivel criar arquivo de texto')
	EndIf
Else
	lRet := .F.
EndIf

RestArea(aArea)

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหออออออัอออออออออออออออออออหอออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRepassaDados บ AutorณValdemir jose      บData ณ 13/04/07    บฑฑ
ฑฑฬออออออออออุอออออออออออออสออออออฯอออออออออออออออออออสอออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Repassa informacoes para o arquivo REM que esta criado     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LUFT                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RepassaDados(nHandle1)

FWrite(nHandle1,U_GeraArq(aCampos,aTraller))

Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GeraArq    บ Autor ณ Valdemir jose      บ Data ณ  13/04/07   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao do Arquivo texto.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LUFT                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function GeraArq(aTipo)
Local nI     := 0
Local nX     := 0
Local cLinha := ''
Local aTip   := Len(aTipo)

For nI := 1 To aTip
	bAux      := &( '{ || ' + aTipo[nI][6] + ' } ' )
	cTipo     := aTipo[nI][2]
	cInicio   := aTipo[nI][3]
	nTamanho  := aTipo[nI][5]
	cAlinha   := aTipo[nI][7]
	uConteudo := EVal( bAux )
	uConteudo := IIf(ValType(uConteudo) == 'U' , '', uConteudo)
	                         
	
//	Aadd(aCampos,{"Fil"			,"C", 001, 002, 002, 'cFilial'		, 'L' } )
	
	
	If  cTipo == 'C'
		If cAlinha  == 'R'
			uConteudo := PADL(SubStr(AllTrim(uConteudo), 1, nTamanho), nTamanho)
		Else
			uConteudo := PADR(SubStr(AllTrim(uConteudo), 1, nTamanho), nTamanho)
		EndIf
	ElseIf cTipo == 'N'
		If ValType(uConteudo) == 'C' 
			uConteudo := StrZero(Val(uConteudo), nTamanho) 
		ElseIf ValType(uConteudo) == 'N' .and. aTipo[nI][6] != 'nItens'
			uConteudo := Transform(Val(StrZero(uConteudo, nTamanho, 2)), "@E 999,999,999,999.99")
		ElseIf aTipo[nI][6] == 'nItens'                    
			uConteudo := StrZero(uConteudo, nTamanho) 
		EndIf  
	ElseIf cTipo == 'D'
		If ValType(uConteudo) == 'C'
			uConteudo := MyDTOS(STOD(uConteudo))
		ElseIf ValType(uConteudo) == 'D'
			uConteudo := MyDTOS(uConteudo)
		EndIf
	EndIf
	cLinha += uConteudo+Chr(9)
Next
cLinha += cQuebraLin

Return cLinha

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณAjustaSX1 ณ Autor ณ  Andreia J Silva      ณ Data ณ17/06/08  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Monta perguntas no SX1.                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function AjustaSx1(cPerg)
cPerg := Left(cPerg,10)

PutSX1(cPerg,"01","DT. Emissao de:" ,"Emissao De:"  ,"DT. Emissao de:"  ,"mv_ch1","D",8,0,0,"G","!Vazio()","","","S","mv_par01","","","","","","","","","","","","","","","","",,,)
PutSX1(cPerg,"02","DT. Emissao ate:","Emissao Ate:" ,"DT. Emissao ate:" ,"mv_ch2","D",8,0,0,"G","!Vazio()","","","S","mv_par02","","","","","","","","","","","","","","","","",,,)

Return   
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MyDTOS   บAutor  ณAndreia J da Silva  บ Data ณ  19/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para conversao das datas em string.                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LUFT                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MyDTOS(dData)
Local cRet := Space(10)

cTemp := dtos(dData) 
If !Empty(cTemp)
	cRet := right(cTemp,2)+"/"+substr(cTemp,5,2)+"/"+left(cTemp,4)
EndIf

Return cRet