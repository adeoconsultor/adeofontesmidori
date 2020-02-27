#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
//
//
//
User Function MD_RLMVPRD()
//
Local nMeses
cPerg      := "MDRLMV"
aArea := GetArea()
nOpcA := 0
cContGrupo := ''
//
AjustaSx1() // Funcao faz a montagem das perguntas
PERGUNTE(cPerg, .F. )
//
FormBatch('Movimentacoes de Produtos',{'Movimentacoes de Produtos','Esta rotina gerará a planilha Excel ref. as movimentacoes de produtos por Filial e Periodo'},;
{{5,.T.,{|o| pergunte(cPerg,.T.) }},;
{1,.T.,{|o| nOpcA:=1,o:oWnd:End()}  },;
{2,.T.,{|o| o:oWnd:End() }}})

If ( nOpcA == 1 )
	Processa({|| Ger_Movtos(), 'Gerando Planilhas...' } )
EndIf

RestArea(aArea)
Return(.F.)

//--------------------------------
/*
Esta funcao tem como obejtivo calcular as movimentacoes dos produtos por filial para agregar a array de centros de custo por filial e grupo de produtos
*/
Static  Function Ger_Movtos()
//
Local aFils := {}
Local nn1, nnr, nK, nn2, nMeses
/*
cEmpAnt := '01'
RpcSetType( 3 ) // Desligando o servidor de licencas
RpcSetEnv(cEmpAnt, '08',,,,, { "SG1", "SB1", "SC2" } )
*/
//
aDesCMeses := { 'JANEIRO','FEVEREIRO','MARCO','ABRIL','MAIO','JUNHO','JULHO','AGOSTO','SETEMBRO','OUTUBRO','NOVEMBRO','DEZEMBRO' }
DtIni 			:=  DTOS ( MV_PAR01 )
DtFim 		:=  DTOS(  MV_PAR02 )
cArqTrab   := ''
aMeses    := {}
CriaBdTrb() // Chamando a funcao que cria a tabela temporario
ListaGrupos()
//
IF MV_PAR03 == 1 // CONSIDERA FILIAIS
	//
	DbSelectArea( 'SM0' )
	nRecM0 := REcno()
	DbGoTop()
	Procregua( reccount() )
	While ! eof()
		//
		Incproc('Selecionando Filiais...' )
		//
		IF M0_CODIGO <> '99' 
		     IF  M0_CODFIL >=   MV_PAR04   .AND.  M0_CODFIL <=  MV_PAR05 
			      AAdd( aFils ,  M0_CODFIL )
			 ENDIF
		ENDIF
		//
		DbSkip()
	Enddo
	//
	DbGoTo( nRecM0 )
ELSE
	AAdd( aFils ,  SM0->M0_CODFIL )
ENDIF
//
// O laco Abaixo cria as Arrays por Filial de acordo com os registros levantados na SM0
Procregua( len( aFils )  )
For nn1 := 1 to  len( aFils )
	//
	IncProc( 'Processando Movimentos da Filial ' +  aFils[NN1]  )
	//
	// O PRIMEIRO BLOCO ALIMENTA A TABELA TEMPORARIA COM OS MOVIMENTOS DO SD3 ( MOVIMENTACAO INTERNA )	PARA AS ENTRADAS
	cQueryD3 := "SELECT R_E_C_N_O_ AS REC FROM " +  RetSqlName("SD3")
	cQueryD3 += " WHERE D3_FILIAL = '"+ aFils[NN1] + "' "
	cQueryD3 += " AND D3_EMISSAO >= '" + DtIni + "' AND D3_EMISSAO <= '"  + DtFim + "' "
	cQueryD3 += " AND D3_ESTORNO <> 'S' "
	//
	IF ! EMPTY(cContGrupo)
		cQueryD3 += " AND D3_GRUPO IN( "+ cContGrupo + ") "
	Endif
	//
	cQueryD3 += " AND D_E_L_E_T_=' '"
	//
	IF SELECT( 'TRBSD3' ) > 0
		DbSelectArea( 'TRBSD3' )
		DbcloseArea()
	ENDIF
	//
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQueryD3), 'TRBSD3' , .F. , .T. )
	//
	DbSelectArea( 'TRBSD3' )
	DbGoTop()
	//
	While !eof()
		//
		// Este bloco tem como objetivo alimentar a tabela temporaria com as movimentacoes do SD3
		DbSelectArea('SD3')
		DbGoTo( TRBSD3->REC  ) // Posicionando o SD3 de acordo com o RECNO da temporaria
		If D3_TM > '500'
			DbSelectArea( 'TRB' )
			if DbSeek( aFils[NN1] + SD3->D3_CC + SUBSTR( DTOS( SD3->D3_EMISSAO ),  1 , 6  ) + SD3->D3_COD    ) //
				Reclock('TRB', .F. )
				//alert( 'achei SD3')
			Else
				Reclock('TRB', .T. )
				Replace FILIAL 		WITH  aFils[NN1]
				Replace PRODUTO 	WITH  SD3->D3_COD
				Replace CCUSTO		WITH SD3->D3_CC
				Replace ANOMES		WITH SUBSTR( DTOS( SD3->D3_EMISSAO ),  1 , 6  )
				//
				SB1->( DbSeek( xFilial('SB1') + SD3->D3_COD ) )
				aSalAlmox := CalcEst( SD3->D3_COD , SB1->B1_LOCPAD , STOD( DtIni ) - 1     )
				//
				Replace QTANT			WITH QTANT +  aSalAlmox[ 1 ]
				Replace VATU1			WITH VATU1 + 	aSalAlmox[  2 ]
				//
			Endif
			//
			Replace D3QUANT		with D3QUANT  + SD3->D3_QUANT
			Replace D3CUSTO1	with D3CUSTO1 + SD3->D3_CUSTO1
		Endif
		//
		MsUnlock()
		//
		DbSelectArea( 'TRBSD3' )
		DbSkip()
	Enddo
	//
	//
	// o bloco abaixo tem como objetivo puxar as ENTRADAS dos produtos pelo SD1 normais
	cQueryD1 := "Select R_E_C_N_O_ as REC from 	" +  RetSqlName("SD1") + " Where D1_FILIAL = '" + aFils[NN1] + "' "
	cQueryD1 += " AND " +iif( mv_par07== 1, "D1_DTDIGIT", "D1_EMISSAO" ) +  " >= '" + DtIni  + "'"
	cQueryD1 += " AND " +iif( mv_par07== 1, "D1_DTDIGIT", "D1_EMISSAO" ) +  " <= '" + DtFim + "'"
	cQueryD1 +=  " AND D1_ORIGLAN <> 'LF'"
	//
	IF ! EMPTY(cContGrupo)
		cQueryD1 += " AND D1_GRUPO IN( "+ cContGrupo + ") "
	Endif
	//
	
	cQueryD1 += " AND D_E_L_E_T_=' '"
	//
	IF SELECT( 'TRBSD1' )  > 0
		DbSelectArea( 'TRBSD1' )
		DbcloseArea()
	ENDIF
	//
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQueryD1), 'TRBSD1' , .F. , .T. )
	//
	DbSelectArea( 'TRBSD1' )
	DbGoTop()
	//
	While ! Eof()
		DbSelectArea( 'SD1' )
		DbGoTo( TRBSD1->REC )
		//
		SF4->( DbSetOrder( 1 ) )
		SF4->( DbSeek( xFilial('SF4') + SD1->D1_TES   ) )
		IF SF4->F4_ESTOQUE <> 'S'
			DbSelectArea( 'TRBSD1' )
			DbSkip()
		ENDIF
		//
		//
		DbSelectArea( 'TRB' )
		if DbSeek( aFils[NN1] + SD1->D1_CC  + SUBSTR( DTOS( SD1->D1_EMISSAO ),  1 , 6  )  + SD1->D1_COD )
			Reclock('TRB', .F. )
			//alert( 'achei SD1')
		Else
			Reclock('TRB', .T. )
			Replace FILIAL 		WITH  aFils[NN1]
			Replace PRODUTO 	WITH  SD1->D1_COD
			Replace CCUSTO		WITH SD1->D1_CC
			Replace ANOMES			WITH SUBSTR( DTOS( SD1->D1_EMISSAO ),  1 , 6  )
			//
			SB1->( DbSeek( xFilial('SB1') + SD1->D1_COD ) )
			aSalAlmox := CalcEst( SD1->D1_COD , SB1->B1_LOCPAD , STOD( DtIni ) - 1     )
			//
			Replace QTANT			WITH QTANT +  aSalAlmox[ 1 ]
			Replace VATU1			WITH VATU1 + 	aSalAlmox[  2 ]
			//
		Endif
		//
		//
		// O BLOCO ABAIXO TEM COMO OBJETIVO GRAVAS OS REGISTROS DENTRO DA TABELA TEMPORARIA
		if SF4->F4_TRANFIL == '1' // SE A ENTRADA PROVEM DA TRANSFERENCIA DE OUTRA FILIAL
			//
			Replace D1QTRAN		WITH	D1QTRAN 	+	 SD1->D1_QUANT
			Replace D1VTRAN		WITH 	D1VTRAN 		+ 	 SD1->D1_TOTAL
			//
		ELSE
			//
			Replace D1QUANT		WITH	D1QUANT 	+ 	SD1->D1_QUANT
			Replace D1TOTAL		WITH 	D1TOTAL 		+  SD1->D1_TOTAL
			//
		ENDIF
		//
		MsUnlock()
		//
		DbSelectArea( 'TRBSD1' )
		DbSkip()
	Enddo
	//
	// TRazendo as Vendas
	//
	cQueryD2 := "Select R_E_C_N_O_ as REC from 	" +  RetSqlName("SD2") + " Where D2_FILIAL = '" + aFils[NN1] + "' "
	cQueryD2 += " AND D2_EMISSAO >= '" + DtIni  + "'"
	cQueryD2 += " AND D2_EMISSAO <= '" + DtFim + "'"
	cQueryD2 +=  " AND D2_ORIGLAN <> 'LF'"
	//
	IF ! EMPTY(cContGrupo)
		cQueryD2 += " AND D2_GRUPO IN( "+ cContGrupo + ") "
	Endif
	//
	
	cQueryD2 += " AND D_E_L_E_T_=' '"
	//
	IF SELECT( 'TRBSD2' )  > 0
		DbSelectArea( 'TRBSD2' )
		DbcloseArea()
	ENDIF
	//
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQueryD2), 'TRBSD2' , .F. , .T. )
	//
	DbSelectArea( 'TRBSD2' )
	DbGoTop()
	//
	While ! Eof()
		DbSelectArea( 'SD2' )
		DbGoTo( TRBSD2->REC )
		//
		SF4->( DbSetOrder( 1 ) )
		SF4->( DbSeek( xFilial('SF4') + SD2->D2_TES   ) )
		IF SF4->F4_ESTOQUE <> 'S'
			DbSelectArea( 'TRBSD2' )
			DbSkip()
		ENDIF
		//
		// O BLOCO ABAIXO TEM COMO OBJETIVO GRAVAS OS REGISTROS DENTRO DA TABELA TEMPORARIA
		if SF4->F4_TRANFIL == '1' // SE A ENTRADA PROVEM DA TRANSFERENCIA DE OUTRA FILIAL
			//
			DbSelectArea( 'TRB' )
			if DbSeek( aFils[NN1] + SD2->D2_CCUSTO + SD2->D2_COD + SUBSTR( DTOS( SD2->D2_EMISSAO ),  1 , 6  )   )
				Reclock('TRB', .F. )
				//alert( 'achei SD2')
			Else
				Reclock('TRB', .T. )
				Replace FILIAL 		WITH  aFils[NN1]
				Replace PRODUTO 	WITH  SD2->D2_COD
				Replace CCUSTO		WITH SD2->D2_CCUSTO
				Replace ANOMES			WITH SUBSTR( DTOS( SD2->D2_EMISSAO ),  1 , 6  )
				//
				SB1->( DbSeek( xFilial('SB1') + SD2->D2_COD ) )
				aSalAlmox := CalcEst( SD2->D2_COD , SB1->B1_LOCPAD , STOD( DtIni ) - 1     )
				//
				Replace QTANT			WITH QTANT +  aSalAlmox[ 1 ]
				Replace VATU1			WITH VATU1 + 	aSalAlmox[  2 ]
				//
			Endif
			
			Replace D2QTRAN		WITH	D2QTRAN 	+	 SD2->D2_QUANT
			Replace D2VTRAN		WITH 	D2VTRAN 		+ 	 SD2->D2_TOTAL
			//
		ENDIF
		//
		MsUnlock()
		//
		DbSelectArea( 'TRBSD2' )
		DbSkip()
	Enddo
	//
Next
//
cLinha := ''
DbSelectarea('TRB')
DbGoTop()
//
While !eof()
	nRetPos := Ascan( aMeses, ANOMES )
	//
	if nRetPos == 0
		AAdd( aMeses ,  ANOMES )
	Endif
	//
	DbSkip()
Enddo
//
DbSelectarea('TRB')
DbGoTop()
//
// O bloco abaixo tem como objetivo alimentar as arrays para as filiais
lExcel := .F.

If ! ApOleClient( 'MsExcel' )
	MsgStop( 'MsExcel nao instalado. ' )
Else
	lExcel := .T.
	oExcelApp := MsExcel():New()
	oExcelApp:SetVisible(.T.)
Endif

//
ProcREgua( len( aMeses ) )
For nMeses := 1 to len( aMeses )
	//
	IncProc( 'Gerando Planilha ref. ao Mes  ' + aMeses[ nMeses ]  )
	//
	cConteudo  :=  CHR(13)  + CHR(10)  + CHR(13)  + CHR(10)+ 'MAPA DEMONSTRATIVO DE MOVIMENTOS ' + CHR(13)  + CHR(10) + CHR(13)  + CHR(10)
	cConteudo += 'DATA:' + DTOC( DDATABASE ) + CHR(13)  + CHR(10)  + 'RESPONSÁVEL:' + CHR(13)  + CHR(10)  + 'VALOR: (R$) S/ICMS' + CHR(13)  + CHR(10)
	cConteudo += CHR(13)  + CHR(10)  + aDesCMeses[ VAL( SUBSTR( aMeses[nMeses], 5,2 )  )  ] + ' / '  + SUBSTR( aMeses[nMeses], 1,4  ) + CHR(13)  + CHR(10)
	
	cConteudo += 'FILIAL;CENTRO DE CUSTO;ANO-MES;SALDO-QTD;SALDO-R$;ENTRADA-QTD;ENTRADA-$;ENTRADA-TRANSFERIDA-QTD;ENTRADA-TRANSFERIDA-$;SAIDA-TRANSFERENCIA-QTD;SAIDA-TRANSFERENCIA-$;CONSUMO-QTD;CONSUMO-$;SALDO ATUAL-QTD;SALDO ATUAL-$'  + cHR(13) + CHR(10)
	//
	For nnr := 3 to 14
		CnTotgerk := 'nTotger' + Alltrim( Str( nnr ) )
		&CnTotgerk := 0
	Next
	//
	For nn2 := 1 to len( aFils )
		//
		cArFil := {}
		//
		DbSelectArea('TRB')
		//
		SET FILTER TO
		SET FILTER TO  ANOMES ==  aMeses[nMeses]
		DBGOTOP()
		//
		if DbSeek(    aFils[ nn2 ]  )
			lTemFilial := .T.
			While !eof() .and. FILIAL == aFils[ nn2 ]
				//
				nRetPos := Ascan(  cArFil ,     {|x| Alltrim( x[1] )  ==  Alltrim( CCUSTO )  .and.  Alltrim( x[2] ) ==  Alltrim( ANOMES  )    }  )
				//
				IF nRetPos == 0
					
					Aadd( cArFil ,{ Alltrim( CCUSTO )  ,  Alltrim( ANOMES  ), QTANT,VATU1,D1QUANT,D1TOTAL,;
					D1QTRAN,D1VTRAN,D2QTRAN,D2VTRAN,D3QUANT,D3CUSTO1,;
					( ( QTANT + D1QUANT + D1QTRAN ) - ( D2QTRAN + D3QUANT ) )  , ( ( VATU1 + D1TOTAL + D1VTRAN ) - ( D2VTRAN + D3CUSTO1 )  )  }  )
					//											 QTANT + D1QUANT + D1QTRAN   ,   VATU1 + D1TOTAL + D1VTRAN   }  )
					
				Else
					cArFil[nRetPos, 3] += QTANT
					cArFil[nRetPos, 4] += VATU1
					cArFil[nRetPos, 5] += D1QUANT
					cArFil[nRetPos, 6] += D1TOTAL
					cArFil[nRetPos, 7] += D1QTRAN
					cArFil[nRetPos, 8] += D1VTRAN
					cArFil[nRetPos, 9] += D2QTRAN
					cArFil[nRetPos, 10] += D2VTRAN
					cArFil[nRetPos, 11] += D3QUANT
					cArFil[nRetPos, 12] += D3CUSTO1
					cArFil[nRetPos, 13] := ( cArFil[nRetPos, 3]  + cArFil[nRetPos, 5]  + cArFil[nRetPos, 7]  ) - ( cArFil[nRetPos, 9]  + cArFil[nRetPos, 11]   )
					cArFil[nRetPos, 14] := ( cArFil[nRetPos, 4] + cArFil[nRetPos, 6]  + cArFil[nRetPos, 8]  )  - ( cArFil[nRetPos, 10]  + cArFil[nRetPos, 12]  )
				Endif
				//
				DbSelectArea('TRB')
				DbSkip()
			Enddo
		Else
			lTemFilial := .F.
		Endif
		//
		For nnr := 3 to 14
			CnTot := 'nTot' + Alltrim( Str( nnr ) )
			&CnTot := 0
		Next
		//
		//
		For nK := 1 to len( cArFil )
			
			// cConteudo += aFils[ nn2 ] +';' +  cArFil[nK, 1] +';' + cArFil[ nK, 2 ]+ ';' + Transform( cArFil[ nK, 3 ], ' @E 99,999,999.9999'  )  +';'+ Transform( cArFil[ nK, 4 ], ' @E 99,999,999.9999'  )  +';'+ Transform( cArFil[ nK, 5 ], ' @E 99,999,999.9999'  )  +';'+;
			// Transform( cArFil[ nK, 6 ], ' @E 99,999,999.9999'  )  +';'+ Transform( cArFil[ nK, 7 ], ' @E 99,999,999.9999'  )  +';'+ Transform( cArFil[ nK, 8 ], ' @E 99,999,999.9999'  )  +';'+;
			// Transform( cArFil[ nK, 9 ], ' @E 99,999,999.9999'  )  +';'+ Transform( cArFil[ nK, 10 ], ' @E 99,999,999.9999'  )  +';'+ Transform( cArFil[ nK, 11 ], ' @E 99,999,999.9999'  )  +';'+;
			// Transform( cArFil[ nK,12 ], ' @E 99,999,999.9999'  )  + ';'+  Transform(  ( cArFil[nK, 4]  + cArFil[nK, 5]  + cArFil[nK, 7]  ) - ( cArFil[nK, 9]  + cArFil[nK, 11]   )  , ' @E 99,999,999.9999'  ) + ';'+;
			// Transform( ( cArFil[nK, 3] + cArFil[nK, 6]  + cArFil[nK, 8]  ) - ( cArFil[nK, 10]  + cArFil[nK, 12]  )  , ' @E 99,999,999.9999'  ) +  Chr(13) + chr(10)
			
			cConteudo += aFils[ nn2 ] +';' +  cArFil[nK, 1] +' - '+POSICIONE('CTT', 1, XFILIAL('CTT') + cArFil[nK, 1] , 'CTT_DESC01' ) + ';' + cArFil[ nK, 2 ]+ ';' + str( cArFil[ nK, 3 ]  )  +';'+ str( cArFil[ nK, 4 ]  )  +';'+ str( cArFil[ nK, 5 ]  )  +';'+;
			str( cArFil[ nK, 6 ]  )  +';'+ str( cArFil[ nK, 7 ]  )  +';'+ str( cArFil[ nK, 8 ]  )  +';'+;
			str( cArFil[ nK, 9 ]  )  +';'+ str( cArFil[ nK, 10 ]  )  +';'+ str( cArFil[ nK, 11 ]  )  +';'+;
			str( cArFil[ nK,12 ]  )  + ';'+  str( cArFil[ nK,13 ]  ) + ';' + str( cArFil[ nK,14 ]  )  +  Chr(13) + chr(10)
			//
			For nnr := 3 to 14
				CnTot := 'nTot' + Alltrim( Str( nnr ) )
				&CnTot += cArFil[ nk, nnr ]
				//
				CnTot := 'nTotGer' + Alltrim( Str( nnr ) )
				&CnTot += cArFil[ nk, nnr ]
				//
			Next
		Next
		//
		if lTemFilial
			cConteudo += 'TOTAL FILIAL ' + aFils[ nn2 ] + ';;;'
			//
			For nnr := 3 to 14
				//CnTot := "Transform( nTot" + Alltrim( Str( nnr ) ) + ", ' @E 99,999,999.9999' )"
				CnTot := "Str( nTot" + Alltrim( Str( nnr ) ) + ")"
				cConteudo += &CnTot + ';'
				//
			Next
			//
			cConteudo := substr(cConteudo, 1, len(cConteudo) -1 ) + chr(13) + chr( 10 )+ chr(13) + chr( 10 )
			//
		Endif
		//
	Next
	//
	//
	//
	// O bloco abaixo descarrega os totais gerais
	cConteudo += chr( 13 ) + chr( 10 )
	cConteudo += 'TOTAL GERAL '  +  ';;;'
	//
	For nnr := 3 to 14
		//CnTot := "Transform( nTotGer" + Alltrim( Str( nnr ) ) + ", ' @E 99,999,999.9999' )"
		CnTot := "Str( nTotGer" + Alltrim( Str( nnr ) ) + ")"
		cConteudo += &CnTot + ';'
	Next
	//
	cConteudo := substr(cConteudo, 1, len(cConteudo) -1 ) + chr(13) + chr( 10 )
	//
	cConteudo := StrTran( cConteudo, '.' , ','  )
	//
	cConteudo +=   CHR(13) + CHR(10) + CHR(13) + CHR(10) + ';LEGENDA:' + CHR(13) + CHR(10)
	cConteudo +=  	';Saldo.I.(Kg): Saldo Mês anterior em (KG)' + CHR(13) + CHR(10)
	cConteudo +=  	';Saldo.I.(vlr): Saldo Mês anterior em (R$)' + CHR(13) + CHR(10)
	cConteudo +=  	';Ent.(Kg): Entrada em (KG)' + CHR(13) + CHR(10)
	cConteudo +=  	';Ent.(VLR): Entrada em (R$)' + CHR(13) + CHR(10)
	cConteudo +=  	';E.Trans.(Kg): Entrada de Trasferência de outra Filial em (KG)' + CHR(13) + CHR(10)
	cConteudo +=  	';E.Trans.(vlr): Entrada de Trasferência de outra Filial em (R$)' + CHR(13) + CHR(10)
	cConteudo +=  	';Saida-Trans.(Kg): Saida e Saida de Transferências em (KG)' + CHR(13) + CHR(10)
	cConteudo +=  	';Saida-Trans.(vlr): Saida e Saida de Transferências em (R$)' + CHR(13) + CHR(10)
	cConteudo +=  	';Cons.(Kg): Consumo em (KG)' + CHR(13) + CHR(10)
	cConteudo +=  	';Cons.(vlr): Consumo em (R$)' + CHR(13) + CHR(10)
	cConteudo +=  	';Saldo-A.(Kg): Saldo atual em (KG)' + CHR(13) + CHR(10)
	cConteudo +=  	';Saldo-A.(vlr): Saldo atual em (R$)'
	//
	cDirCsv := Alltrim( mv_par06 )
	MemoWRite(cDirCsv+'\MOV_' + aDesCMeses[ VAL( SUBSTR( aMeses[nMeses], 5,2 )  )  ] + '_'  + SUBSTR( aMeses[nMeses], 1,4  )   +  '.CSV',   cConteudo  )
	//
	If lExcel
		oExcelApp:WorkBooks:Open( cDirCsv+'\MOV_' + aDesCMeses[ VAL( SUBSTR( aMeses[nMeses], 5,2 )  )  ] + '_'  + SUBSTR( aMeses[nMeses], 1,4  )   +  '.CSV'   ) // Abre o arquivo gerado
	Endif
	//
Next
//
DbCloseArea()
//
Return()
//------------------------------------------------------------------------------
Static Function CriaBdTrb() // Chamando a funcao que cria a tabela temporario

Local aCampos 	:= {}

AADD(aCampos,{ "FILIAL"  ,"C", 2 ,0 } )
//
aTam:=TamSX3("CTT_CUSTO")
AADD(aCampos,{ "CCUSTO"  ,"C",aTam[1],aTam[2] } )
//
aTam:=TamSX3("B1_COD")
AADD(aCampos,{ "PRODUTO"   ,"C",aTam[1],aTam[2] } )
//
AADD(aCampos,{ "ANOMES"   ,"C",6,0 } )
//
aTam:=TamSX3("B2_VATU1")
AADD(aCampos,{ "VATU1"   ,"N",aTam[1],aTam[2] } )
//
aTam:=TamSX3("B2_QATU")
AADD(aCampos,{ "QTANT"   ,"N",aTam[1],aTam[2] } )
//
aTam:=TamSX3("D1_QUANT")
AADD(aCampos,{ "D1QUANT"   ,"N",aTam[1],aTam[2] } )
//
aTam:=TamSX3("D1_TOTAL")
AADD(aCampos,{ "D1TOTAL"   ,"N",aTam[1],aTam[2] } )
//
aTam:=TamSX3("D1_QUANT")
AADD(aCampos,{ "D1QTRAN"   ,"N",aTam[1],aTam[2] } )
//
aTam:=TamSX3("D1_TOTAL")
AADD(aCampos,{ "D1VTRAN"   ,"N",aTam[1],aTam[2] } )
//
//
aTam:=TamSX3("D2_QUANT")
AADD(aCampos,{ "D2QTRAN"   ,"N",aTam[1],aTam[2] } )
//
aTam:=TamSX3("D2_TOTAL")
AADD(aCampos,{ "D2VTRAN"   ,"N",aTam[1],aTam[2] } )
//
aTam:=TamSX3("D3_QUANT")
AADD(aCampos,{ "D3QUANT"   ,"N",aTam[1],aTam[2] } )
//
aTam:=TamSX3("D3_CUSTO1")
AADD(aCampos,{ "D3CUSTO1"   ,"N",aTam[1],aTam[2] } )
//
//
aTam:=TamSX3("B2_QATU")
AADD(aCampos,{ "QTFIM"   ,"N",aTam[1],aTam[2] } )
//
aTam:=TamSX3("B2_VATU1")
AADD( aCampos,{ "VFIM"   ,"N",aTam[1],aTam[2] } )
//
cArqTrab := CriaTrab(aCampos,.T.)
//
IF SELECT( 'TRB') > 0
	DbSelectArea('TRB')
	DbCloseArea()
ENDIF
//
dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)
//
dbSelectArea("TRB")
IndRegua("TRB",cArqTrab,"FILIAL + CCUSTO + ANOMES + PRODUTO",,,"Selecionando Registros..." )

Return()
//-----------------------------------------
Static Function AjustaSx1()
//
PutSx1(cPerg, "01","Data De "			,"Data De ","Data De ","mv_ch1"	,"D"	,08	,0	,0	,"G",,,,,"mv_par01",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg, "02","Data Ate "			,"Data Ate ","Data Ate ","mv_ch2"	,"D"	,08	,0	,0	,"G",,,,,"mv_par02",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg, "03","Considera Filiais ?","","","mv_ch3","N",01,0,0,"C","", "", "","","mv_par03","Sim"," "," ","","Nao","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "04","Da NF   ?"			,"","","mv_ch4","C",02,0,0,"G","", "","","","mv_par04"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "05","Ate a NF?"			,"","","mv_ch5","C",02,0,0,"G","", "","","","mv_par05"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "06","Diretorio?"		  	,""				,""				,"mv_ch6"	,"C"	,80 ,0	,0	,"G","", "","","","mv_par06"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "07","Data  Nf Entrada?"	,"","","mv_ch7","N",01,0,0,"C","", "", "","","mv_par07","Digitacao"," "," ","","Emissao","","","","","","","","","","",	" ", , ,)
//
Return Nil
//---------------------------------------------------------------------
/*
A funcao abaixo tem como objetivo mostrar um browse com os grupos para a escolha no select
*/
Static Function ListaGrupos()

SetPrvt("oDlgGrupos","oBtnOk","oLbGrupo","oCBox1")
//
oOk := LoadBitmap( GetResources(), "LBOK")
oNo := LoadBitmap( GetResources(), "LBNO")
lTodos := .T.
//
aGrupo := {}
dbSelectArea("SBM")
dbSeek(xFilial("SBM"))
Do While (BM_FILIAL == xFilial("SBM")) .AND. !Eof()
	cCapital := OemToAnsi(Capital(BM_DESC))
	AADD(aGrupo,{.T.,SubStr(BM_GRUPO,1,5)+" "+cCapital})
	dbSkip()
EndDo
//
oDlgGrupos := MSDialog():New( 095,232,450,643,"Escolha os Grupos de Produtos",,,.F.,,,,,,.T.,,,.T. )
oBtnOk       := SButton():New( 156,172,1,{|| IF( CarrGrupos()  ,close( oDlgGrupos ) , .T. ) },oDlgGrupos,,"", )
//
//oLbGrupo   := TListBox():New( 004,004,,,196,144,,oDlgGrupos,,CLR_BLACK,CLR_WHITE,.T.,,{|| MudaLinha() },,"",,,,,,, )
@ 004,004 LISTBOX oQual2 VAR cVarQ2 Fields HEADER "",'Grupo Produtos' SIZE 192,142 ON DBLCLICK (aGrupo:=MudaLinha(oQual2:nAt,aGrupo),oQual2:Refresh()) OF oDlgGrupos  PIXEL
oQual2:SetArray(aGrupo)
oQual2:bLine := { || {If(aGrupo[oQual2:nAt,1],oOk,oNo),aGrupo[oQual2:nAt,2]}}
//
//oCBox1     := TCheckBox():New( 156,004,"Todos os Itens",,oDlgGrupos,048,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )

@ 156,004 CHECKBOX oCBox1  VAR lTodos  PROMPT "Todos os Itens"  SIZE 048,008 ON CLICK( clicatodos() ) OF oDlgGrupos  PIXEL
//
// oDlgGrupos:Activate(,,,.T.)
ACTIVATE MSDIALOG oDlgGrupos CENTERED VALID CarrGrupos()
//
Return
//-------------------------------------------------------------
Static Function MudaLinha(nIt,aArray)
aArray[nIt,1] := !aArray[nIt,1]
Return aArray
//--------------------------------------------------------------
Static Function CarrGrupos()
Local nz1
//
cContGrupo := ''
For nz1:= 1 to len(aGrupo)
	if aGrupo[nz1, 1 ]
		cContGrupo += "'" +  ALLTRIM( SubStr( aGrupo[ nz1, 2 ] , 1 , 5 ) ) + "',"
	Endif
Next
//
cContGrupo := substr( cContGrupo, 1, len(cContGrupo ) -1 )
//
if empty(cContGrupo)
	Alert( ' Atenção ! Você precisa escolher pelo menos um grupo para Processamento. Por favor, corrija.')
	Return( .F. )
Endif
Return( .T.  )
//--------------------------------------------------------------
Static Function ClicaTodos()
Local nza
//
For nza := 1 to len( aGrupo )
	aGrupo[ nza,  1  ] := lTodos
Next
//
oQual2:Refresh()
//
Return()
//--------------------------------------------------------------