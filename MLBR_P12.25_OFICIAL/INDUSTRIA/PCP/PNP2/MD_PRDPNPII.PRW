#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
//
//
//
User Function MD_PRDPNPII()
//
cPerg      := "MDMPPR"
aArea := GetArea()
nOpcA := 0
cContGrupo := ''
//
AjustaSx1() // Funcao faz a montagem das perguntas
PERGUNTE(cPerg, .F. )

//
FormBatch('Mapa de Producoes',{'Mapa de Producoes','Esta rotina gerará a planilha Excel ref. as producoes realizadas, conforme os parametros especificos.' },;
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
// User Function Rog_PROC()
//
Local aFils := {}
Local nn1 
//
/*
cEmpAnt := '01'
RpcSetType( 3 ) // Desligando o servidor de licencas
RpcSetEnv(cEmpAnt, '08',,,,, { "SG1", "SB1", "SC2" } )

//
cPerg      := "MDMPPR"
aArea := GetArea()
nOpcA := 0
cContGrupo := ''
//
//AjustaSx1() // Funcao faz a montagem das perguntas
//PERGUNTE(cPerg, .F. )
*/
//
aDesCMeses 		:= { 'JANEIRO','FEVEREIRO','MARCO','ABRIL','MAIO','JUNHO','JULHO','AGOSTO','SETEMBRO','OUTUBRO','NOVEMBRO','DEZEMBRO' }
DtIni 			:=  DTOS ( MV_PAR01 )
DtFim 			:=  DTOS(  MV_PAR02 )
cArqTrab   		:= ''
aMeses    		:= {}
//

cQuery          := "Select SZ3.R_E_C_N_O_ as REC, SC2.R_E_C_N_O_ AS RECSC2  FROM "+ RetSqlName('SZ3') + " SZ3," + RetSqlName('SC2') + " SC2," + RetSqlName('SB1') + " SB1, " + RetSqlNAme('SB1') + " SB1B"
cQuery          += " Where SZ3.D_E_L_E_T_ <> '*' and SZ3.Z3_FILIAL = '" + xFilial('SZ3') + "' and "
cQuery          += "SZ3.Z3_DTAPON   <> '"+space(08) + "' and  SZ3.Z3_DTAPON   >= '"+DtIni + "' and SZ3.Z3_DTAPON <= '"+ DtFim + "' and "
cQuery          += "SZ3.Z3_PLANO    >= '"+ MV_PAR03 + "' and SZ3.Z3_PLANO <= '" + MV_PAR04  + "' and "
cQuery          += "SZ3.Z3_NUMOP + SZ3.Z3_ITEM +  SZ3.Z3_SEQUEN >= '"+ MV_PAR07 + "' and SZ3.Z3_NUMOP + SZ3.Z3_ITEM +  SZ3.Z3_SEQUEN <= '" + MV_PAR08  + "' and "
cQuery          += "SB1.B1_GRUPO    >= '"+ MV_PAR11 + "' AND SB1.B1_GRUPO <= '" + MV_PAR12  + "' AND "
cQuery          += "SZ3.Z3_MATERIA    >= '"+ MV_PAR13 + "' and SZ3.Z3_MATERIA <= '" + MV_PAR14  + "' and "
// cQuery          += "SZ3.Z3_PRODUTO    >= '"+ MV_PAR09 + "' and SZ3.Z3_PRODUTO <= '" + MV_PAR10  + "' and "
cQuery          += "SZ3.Z3_NUMFC      >= '"+ MV_PAR15 + "' and SZ3.Z3_NUMFC   <= '" + MV_PAR16  + "' AND "
cQuery          += "LTRIM(RTRIM( SZ3.Z3_CORTADO)) Between '"+ Alltrim(MV_PAR20) + "' and '" + Alltrim(MV_PAR21 ) + "' AND "
cQuery          += "SZ3.Z3_LOTE       >= '"+ Alltrim(MV_PAR22) + "' and SZ3.Z3_LOTE     <= '" + Alltrim(MV_PAR23 ) + "' AND "
cQuery          += "SB1B.B1_GRUPO    >= '"+ MV_PAR24 + "' AND SB1B.B1_GRUPO <= '" + MV_PAR25  + "' AND "
cQuery          += "SC2.C2_FILIAL = '" +xFilial('SC2') + "' and  "
// cQuery          += "SC2.C2_PRODUTO    >= '"+ Alltrim(MV_PAR09) + "' and SC2.C2_PRODUTO <= '" + Alltrim(MV_PAR10)  + "' and "
cQuery          += "SC2.C2_NUM = SZ3.Z3_NUMOP and SC2.C2_ITEM =  SZ3.Z3_ITEM  AND SC2.C2_SEQUEN =  SZ3.Z3_SEQUEN AND SZ3.Z3_PRODUTO = SB1.B1_COD AND SZ3.Z3_MATERIA = SB1B.B1_COD AND"
cQuery          += " SC2.D_E_L_E_T_ = ' ' And  "
cQuery          += "exists( select R_E_C_N_O_ AS REC FROM "+ RetSqlNAme('SC2') + " WITH( NOLOCK ) WHERE C2_FILIAL = '"+xFilial('SC2')+"' and " 
cQuery          += "C2_NUM = SZ3.Z3_NUMOP and C2_ITEM =  '01'  AND C2_SEQUEN =  '001' AND D_E_L_E_T_ = ' ' and  "
cQuery          += "C2_PRODUTO Between '" + Alltrim( mv_par09 ) + "' and '" +alltrim( mv_par10 )+ "' ) " 
cQuery          += " order By Z3_NUMFC "

// MemoWrite( 'c:\mdprd.txt',cQuery)
//alert('criou a query e vai voltar ')
//return()
//
IF SELECT( 'TRBSZ3' ) > 0
	DbSelectArea( 'TRBSZ3' )
	DbcloseArea()
ENDIF
//
dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQuery ), 'TRBSZ3' , .F. , .T. )
//                                  
DbSelectArea( 'TRBSZ3' )
dbgoBottom()
nTotalITens := 0
DbGoTop()
While !eof()
	nTotalITens++
	Dbskip()
Enddo
DbGotop()
ProcREgua( Reccount() )
//
cItensLin := ''
//
aDataItens := {} // array que contera os itens que serao descarregados
nItemAtu := 0
aPlanosJa := {} // array que contera os planos ja processados para soma das quantidades
//
//
cFicAtu := ''
nM2Compl:= 0
nM2CompP:= 0
While !eof()                                   

	nItemAtu ++
	DbSelectArea( 'SZ3' )
	DbGoTo( TRBSZ3->REC )
//	DbGoTo(20799352)
	incproc('Item:  ' + Alltrim(Str( nItemAtu ))+ '  De: '+Alltrim( Str(nTotalITens)) +'  OP: ' + ALLTRIM(SZ3->Z3_NUMOP) + SZ3->Z3_ITEM + SZ3->Z3_SEQUEN )
	//
	DbSelectArea('SZ7')
	DbSetOrder(1)
	if DbSeek( xFilial('SZ7') + SZ3->Z3_NUMFC + '02'  )
		nM2CompP := SZ7->Z7_M2COMPL
	endif
	SZ7->(dbGotop())
	if ! DbSeek( xFilial('SZ7') + SZ3->Z3_NUMFC + '01'  )
		nM2Compl:= 0
		DbSelectArea( 'TRBSZ3' )
		DbSkip()
		Loop
	else
		if SZ7->Z7_M2COMPL > 0 .and. alltrim(SZ3->Z3_NUMFC) <> alltrim(cFicAtu)
			nM2Compl:= SZ7->Z7_M2COMPL
		Endif
	endif
	// 
	DbSelectArea('SD3')
	DbSetORder( 1 )
	if ! DbSeek(xFilial('SD3') + PADR( Padr( SZ3->Z3_NUMOP , 6 ) + SZ3->Z3_ITEM + SZ3->Z3_SEQUEN ,14) + PADR(SZ3->Z3_MATERIA, 15))
	// if ! DbSeek( '0999ELGE01001  05472006' )
		DbSelectArea( 'TRBSZ3' )
		DbSkip()
		Loop
	Endif
	//		
	if  alltrim(SZ3->Z3_NUMFC) <> alltrim(cFicAtu)
		u__Rt_FcLct( SZ3->Z3_NUMFC )
		//DbSelectArea( 'TRBSZ3' )
		//DbSkip()
		//Loop
	Endif                         
	//                       
	//alert('ok')
	cPrdOp := ''             
	nQtOp  := 0
	DbSelectArea('SC2')
	DbSetORder(1) // Setando a ordem do SC2 para numero da OP
	if DbSeek( xFilial('SC2') + ALLTRIM(SZ3->Z3_NUMOP) + '01001' )
		//
		IF SC2->C2_PRODUTO < mv_par09 .or. SC2->C2_PRODUTO > mv_par10
			DbSelectArea( 'TRBSZ3' )
			//DbSkip()
			//Loop		    
		ENDIF
		*/
		//
		cPrdOp := SC2->C2_PRODUTO
		nQtOp  := SC2->C2_QUANT
	Endif
	//
	*/
	DbGoTo( TRBSZ3->RECSC2 )
	//
	/*
	if SC2->C2_PRODUTO < MV_PAR09 .OR. SC2->C2_PRODUTO > MV_PAR10
	DbSelectArea( 'TRBSZ3' )
	DbSkip()
	Loop
	Endif
	*/
	// cQrD3 := "Select R_E_C_N_O_ as Rec from  " + REtSqlNAme( 'SD3' ) + " Where   D_E_L_E_T_ <> '*' and D3_OP ='"+ ALLTRIM(SZ3->Z3_NUMOP) + SZ3->Z3_ITEM + SZ3->Z3_SEQUEN + "' AND "
	// cQrD3 += " D3_COD ='" + SZ3->Z3_MATERIA + "' and D3_ESTORNO = '' "
	//
	//IF SELECT( 'TRBSD3' ) > 0
	//	DbSelectArea( 'TRBSD3' )
	//	DbcloseArea()
	//ENDIF
	//
	//dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQrD3 ), 'TRBSD3' , .F. , .T. )
	//
	//DbGoTop()
	//if Eof()
	
	//
	//DbSelectArea('SD3')
	//DbGoTo( TRBSD3->REC )
	//
	/*
	if ! msgyesno( sz3->z3_numfc )
	Exit
	Endif
	*/
	//
	// cItensLin += 	SC2->C2_PRODUTO + ';'+ Posicione( 'SB1' , 1 , xFilial('SB1') + SC2->C2_PRODUTO, 'B1_DESC' ) + ';' +;
	//  				SZ3->Z3_MATERIA + ';'+ Posicione( 'SB1' , 1 , xFilial('SB1') + SZ3->Z3_MATERIA, 'B1_DESC' ) + ';' +;
	//	  				STR( SZ3->Z3_QTDE) + ';'+STR( SZ3->Z3_QTDE * SZ3->Z3_M2PAD ) +';' + STR( SZ3->Z3_M2TOT )  +  Chr(13) + chr(10)
	//
  //		if ApMsgNoYes("Qtde nQtOp: "+cValToChar(nQtOP),"Deseja Sair ? ")
//			Return
//		endif

	if mv_par18 == 1 // Analitico ou Sintetico
		
		AAdd( aDataItens, { SC2->C2_PRODUTO ,;
		Posicione( 'SB1' , 1 , xFilial('SB1') + SC2->C2_PRODUTO, 'B1_DESC' ) ,	;
		SZ3->Z3_MATERIA,;
		Posicione( 'SB1' , 1 , xFilial('SB1') + SZ3->Z3_MATERIA, 'B1_DESC' ) , 	;
		SZ3->Z3_QTDE,;
		SZ3->Z3_QTDE * SZ3->Z3_M2PAD ,  ;
		SZ3->Z3_SLDM2 ,;  // SZ3->Z3_M2TOT ,;        
		nM2Compl, ; 
		nM2CompP, ; 
		( ( SZ3->Z3_QTDE * SZ3->Z3_M2PAD ) / SZ3->Z3_SLDM2 ) * 100  ,;
		"'" + SZ3->Z3_NUMFC ,;
		SZ3->Z3_PLANO,;
		cPrdOp,;
		Posicione( 'SB1' , 1 , xFilial('SB1') + cPrdOp , 'B1_DESC' ) ,;
		DTOC( SC2->C2_EMISSAO ),;
		nQtOp , SZ3->Z3_CORTADO, SZ3->Z3_LOTE  } )
		
	Else
		// Este bloco pesquisa o elemento da array de acordo com o item de aglutinacao escolhido
		//
		nPosPlano := Ascan( aPlanosJa , Alltrim( SZ3->Z3_PLANO  ) )
		//
		If mv_par19 == 1
			nPosicao := Ascan( aDataItens , {|x| Alltrim(x[11]) == Alltrim( cPrdOp )    }  )
		Elseif mv_par19 == 2
			nPosicao := Ascan( aDataItens , {|x| Alltrim( x[1]) == Alltrim( SC2->C2_PRODUTO  )  }  )
		Elseif mv_par19 == 3
			nPosicao := Ascan( aDataItens , {|x| Alltrim( x[3]) == Alltrim( SZ3->Z3_MATERIA  )  }  )
		Endif
		//
		if nPosicao  == 0
			If mv_par19 == 1
				
				AAdd( 	aDataItens, { 	space(15) ,;
				'' ,	;
				'',;
				'', 	;
				SZ3->Z3_QTDE,;
				SZ3->Z3_QTDE * SZ3->Z3_M2PAD ,  ;
				SZ3->Z3_SLDM2 ,;  // SZ3->Z3_M2TOT ,; 
				nM2Compl, ;
				nM2CompP, ;
				( ( SZ3->Z3_QTDE * SZ3->Z3_M2PAD ) / SZ3->Z3_SLDM2 ) * 100  ,;
				"",;
				" ",;
				cPrdOp,;
				Posicione( 'SB1' , 1 , xFilial('SB1') + cPrdOp , 'B1_DESC' ) ,;
				' ',;
				nQtOp , Alltrim(SZ3->Z3_CORTADO ) , Alltrim(SZ3->Z3_LOTE) } )
				
			ElseIf mv_par19 == 2
				
				AAdd( 	aDataItens, { SC2->C2_PRODUTO ,;
				Posicione( 'SB1' , 1 , xFilial('SB1') + SC2->C2_PRODUTO, 'B1_DESC' ) ,	;
				SZ3->Z3_MATERIA,;
				Posicione( 'SB1' , 1 , xFilial('SB1') + SZ3->Z3_MATERIA, 'B1_DESC' ) , 	;
				SZ3->Z3_QTDE,;
				SZ3->Z3_QTDE * SZ3->Z3_M2PAD ,  ;
				SZ3->Z3_SLDM2 ,;  // SZ3->Z3_M2TOT ,; 
				nM2Compl ,;
				nM2CompP ,;
				( ( SZ3->Z3_QTDE * SZ3->Z3_M2PAD ) / SZ3->Z3_SLDM2  ) * 100  ,;
				"'" + SZ3->Z3_NUMFC ,;
				SZ3->Z3_PLANO,;
				cPrdOp,;
				Posicione( 'SB1' , 1 , xFilial('SB1') + cPrdOp , 'B1_DESC' ) ,;
				DTOC( SC2->C2_EMISSAO ),;
				nQtOp , Alltrim(SZ3->Z3_CORTADO), Alltrim(SZ3->Z3_LOTE ) } )
				
			ElseIf mv_par19 == 3
				
				AAdd( 	aDataItens, { SC2->C2_PRODUTO ,;
				Posicione( 'SB1' , 1 , xFilial('SB1') + SC2->C2_PRODUTO, 'B1_DESC' ) ,	;
				SZ3->Z3_MATERIA,;
				Posicione( 'SB1' , 1 , xFilial('SB1') + SZ3->Z3_MATERIA, 'B1_DESC' ) , 	;
				SZ3->Z3_QTDE,;
				SZ3->Z3_QTDE * SZ3->Z3_M2PAD ,  ;
				SZ3->Z3_SLDM2 ,;  // SZ3->Z3_M2TOT ,; 
				nM2Compl ,;
				nM2CompP ,;
				( ( SZ3->Z3_QTDE * SZ3->Z3_M2PAD ) / SZ3->Z3_SLDM2  ) * 100  ,;
				"'" + SZ3->Z3_NUMFC ,;
				SZ3->Z3_PLANO,;
				cPrdOp,;
				Posicione( 'SB1' , 1 , xFilial('SB1') + cPrdOp , 'B1_DESC' ) ,;
				DTOC( SC2->C2_EMISSAO ),;
				nQtOp , ;
				Alltrim( SZ3->Z3_CORTADO),;
				Alltrim(SZ3->Z3_LOTE) } )
			Endif
			//
			if nPosPlano == 0
				AAdd( aPlanosJa, SZ3->Z3_Plano )
			Endif
			//
		Else
			//
			if nPosPlano == 0
				AAdd( aPlanosJa, SZ3->Z3_Plano )
			Endif
			//                         
//			Alert("Adicionando...."+cValToChar(aDataItens[ nPosicao  , 15 ])])
			aDataItens[ nPosicao  , 5 ]  += SZ3->Z3_QTDE
			aDataItens[ nPosicao  , 6 ]  += SZ3->Z3_QTDE * SZ3->Z3_M2PAD
			aDataItens[ nPosicao  , 7 ]  += SZ3->Z3_SLDM2 // SZ3->Z3_M2TOT ,; 
			aDataItens[ nPosicao  , 8 ]  += nM2Compl
			aDataItens[ nPosicao  , 9 ]  += nM2CompP
			aDataItens[ nPosicao  , 10 ]  := ( ( aDataItens[ nPosicao  , 6 ] / aDataItens[ nPosicao  , 7 ] )  * 100)
			aDataItens[ nPosicao  , 16 ] += iif( nPosPlano > 0  , 0  ,  nQtOp )
			aDataItens[ nPosicao  , 17 ] += iif( alltrim(SZ3->Z3_CORTADO) == '' ,'' , iif(  at( alltrim(SZ3->Z3_CORTADO) ,aDataItens[ nPosicao  , 17 ]   ) == 0  ,' / ' + alltrim(SZ3->Z3_CORTADO) , ''  )) 
			aDataItens[ nPosicao  , 18 ] += iif( alltrim(SZ3->Z3_PLANO  ) == '' ,'' , iif(  at( alltrim(SZ3->Z3_PLANO) ,aDataItens[ nPosicao  , 18 ]   )   == 0  ,' / ' + alltrim(SZ3->Z3_PLANO)   , ''  ))
			//
		Endif
	Endif
	//
	cFicAtu := SZ3->Z3_NUMFC
	//
	nM2Compl := 0
	nM2CompP := 0
	DbSelectArea( 'TRBSZ3' )
	DbSkip()
	//
Enddo

cNomeArq := ''
nSeqtx := 1
nHdl := -1
While nHdl == -1 
//	Alert("Criando arquivo...")
	cNomeArq := 'c:\temp\MD_RLPNPII' + Strzero( nSeqtx,2 ) + '.CSV'
	nHdl	:=	MSFCreate( cNomeArq )
	nSeqtx++
Enddo

//lExcel := .F.
If ! ApOleClient( 'MSEXCEL' )
	Alert( 'MsExcel nao instalado. Demonstrativo gerado em ' + cNomeArq )  
	lExcel := .F.	
else
	lExcel := .T.     
	Alert( 'Demonstrativo gerado em ' + cNomeArq )
	oExcelApp := MsExcel():New()
	oExcelApp:SetVisible(.T.)
Endif    

//fWrite(nHdl,cFil)                  		// Filial          02
//fWrite(nHdl,StrZero(nHdlPRV,10,0))   	// ID do arquivo   10
//fWrite(nHdl,PADR(cLoteAtf,15))     		// Lote do arquivo 15
aAglut := {'Kit do Plano','Pecas do Plano','Material do Plano'}

cCabecalho := 'Lancamentos dos Produtos - Periodo: ' + Dtoc( MV_PAR01 ) + ' A ' + dToc( MV_PAR02 ) + chr(13) + chr(10)
//
If mv_par18 == 1
	cCabecalho += 'Relatorio Analitico'  + chr(13) + chr(10)
Else
	cCabecalho += 'Relatorio Sintetico, Aglutinado por ' + aAglut[ mv_par19 ] + chr(13) + chr(10)
Endif
//
cCabecalho += 'Peca Plano;Descricao;Material ; Descricao Material; Quantidade Pecas;M2 Pdrao;M2 Real ; M2 Compl;M2 Comp Perf; % Aproveitamento; Ficha de Corte ; Plano de Producao; Produto Plano; Descricao;Data Plano; Qtde. Kit;Num Linha;Lote'   + Chr(13) + Chr(10)
fWrite( nHdl , cCabecalho )                  		// Filial          02
ProcRegua( len( aDataItens ) )
For nn1 := 1 to len( aDataItens )
	//
	incproc('Gerando Planilha...')
//	if RetCodUsr() <> '000281'
		cItensLin := 	"'" + Alltrim(aDataItens[nn1,1 ]) 			+ ';'	+ 	Alltrim(aDataItens[nn1,2 ] )  + ';' +;
		"'" + Alltrim(aDataItens[nn1,3 ])  			+ ';'	+	Alltrim(aDataItens[nn1,4 ] )  + ';' +;
		Alltrim(STR( aDataItens[nn1,5 ] ) )		+ ';'	+	Alltrim(STR( aDataItens[nn1,6 ] ) ) + ';' +;
		Alltrim(STR( aDataItens[nn1,7 ] ) )  	+  ';'	+	Alltrim(STR( aDataItens[nn1,8 ] ) ) + ';' + Alltrim(STR( aDataItens[nn1,9 ] ) ) + ';' + ;
		Alltrim(STR( aDataItens[nn1,10] ) ) + ';' +;
		aDataItens[nn1,11 ]+ ';' + aDataItens[nn1,12 ]+ ';' + aDataItens[nn1,13 ]+ ';'+ aDataItens[nn1,14 ] +  ';' + aDataItens[nn1,15 ] +  ';'	+ Alltrim(STR( aDataItens[nn1,16 ] ) + ";'"  + ;
		aDataItens[nn1,17 ] + ";'" + aDataItens[nn1,18 ]  )+ Chr(13) + chr(10)
/*    else
		cItensLin := 	"'" + Alltrim(aDataItens[nn1,1 ]) 			+ ','	+ 	Alltrim(aDataItens[nn1,2 ] )  + ',' +;
		"'" + Alltrim(aDataItens[nn1,3 ])  			+ ','	+	Alltrim(aDataItens[nn1,4 ] )  + ',' +;
		Alltrim(STR( aDataItens[nn1,5 ] ) )		+ ','	+	Alltrim(STR( aDataItens[nn1,6 ] ) ) + ',' +;
		Alltrim(STR( aDataItens[nn1,7 ] ) )  	+  ','	+	Alltrim(STR( aDataItens[nn1,8 ] ) ) + ',' + Alltrim(STR( aDataItens[nn1,9 ] ) ) + ',' + ;
		Alltrim(STR( aDataItens[nn1,10] ) ) + ',' +;
		aDataItens[nn1,11 ]+ ',' + aDataItens[nn1,12 ]+ ',' + aDataItens[nn1,13 ]+ ','+ aDataItens[nn1,14 ] +  ',' + aDataItens[nn1,15 ] +  ','	+ Alltrim(STR( aDataItens[nn1,16 ] ) + ",'"  + ;
		aDataItens[nn1,17 ] + ",'" + aDataItens[nn1,18 ]  )+ Chr(13) + chr(10)
	endif
  */
  	cItensLin := StrTran( cItensLin, '.',',')
	fWrite( nHdl , cItensLin )
	//
Next
//
//
fClose(nHdl)
//
If lExcel
	oExcelApp:WorkBooks:Open( cNomeArq   ) // Abre o arquivo gerado
Endif
//

//MEMOWRITE('C:\MD_RLPNPII.CSV', cCabecalho + cItensLin )
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
PutSx1(cPerg, "01","Data De "				,"Data De ","Data De "	,"mv_ch1"	,"D"	,08	,0	,0	,"G",,,,,"mv_par01",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg, "02","Data Ate "				,"Data Ate ","Data Ate ","mv_ch2"	,"D"	,08	,0	,0	,"G",,,,,"mv_par02",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg, "03","Do Plano ?"				,"",""					,"mv_ch3"	,"C"	,20	,0	,0	,"G","", "","","","mv_par03"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "04","Ate o Plano?"			,"",""					,"mv_ch4"	,"C"	,20	,0	,0	,"G","", "","","","mv_par04"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "05","Do Cliente?"			,"",""					,"mv_ch5"	,"C"	,06	,0	,0	,"G","", "","","","mv_par05"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "06","Ate o Cliente?"			,"",""					,"mv_ch6"	,"C"	,06	,0	,0	,"G","", "","","","mv_par06"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "07","Da OP Siga "			,"",""					,"mv_ch7"	,"C"	,11	,0	,0	,"G","", "","","","mv_par07"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "08","Ate a Op Siga"			,"",""					,"mv_ch8"	,"C"	,11	,0	,0	,"G","", "","","","mv_par08"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "09","Do Produto Plano"  		,"",""					,"mv_ch9"	,"C"	,15	,0	,0	,"G","", "","","","mv_par09"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "10","Ate o Produto PLano"	,"",""					,"mv_cha"	,"C"	,15	,0	,0	,"G","", "","","","mv_par10"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "11","Do Grupo"  				,"",""					,"mv_chb"	,"C"	,04	,0	,0	,"G","", "","","","mv_par11"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "12","Ate o Grupo"			,"",""					,"mv_chc"	,"C"	,04	,0	,0	,"G","", "","","","mv_par12"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "13","Do Material Plano" 		,"",""					,"mv_chd"	,"C"	,15	,0	,0	,"G","", "","","","mv_par13"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "14","Ate o Material PLano"	,"",""					,"mv_che"	,"C"	,15	,0	,0	,"G","", "","","","mv_par14"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "15","Da Ficha Corte" 		,"",""					,"mv_chd"	,"C"	,20	,0	,0	,"G","", "","","","mv_par15"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "16","Ate a Ficha Corte"		,"",""					,"mv_che"	,"C"	,20	,0	,0	,"G","", "","","","mv_par16"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "17","Modelo Relatorio ?"		,"",""					,"mv_chf"	,"N"	,01	,0	,0	,"C","", "", "","","mv_par17","Rel. 1 "," "," ","","Rel. 2","","","","","","","","","","",	" ", , ,)
PutSx1(cPerg, "18","Apresentacao Dados ?"	,"",""					,"mv_chg"	,"N"	,01	,0	,0	,"C","", "", "","","mv_par18","Analitico"," "," ","","Sintetico","","","","","","","","","","",	" ", , ,)
PutSx1(cPerg, "19","Aglutina Por 	?"		,"",""					,"mv_chh"	,"N"	,01	,0	,0	,"C","", "", "","","mv_par19","Kit Plano"," "," ","","Peca"," "," ","Mat Prima","Mat Prima","","","","","","",	" ", , ,)
PutSx1(cPerg, "20","Da Linha"  				,"",""					,"mv_chi"	,"C"	,06	,0	,0	,"G","", "","","","mv_par20"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "21","Ate a Linha"			,"",""					,"mv_chj"	,"C"	,06	,0	,0	,"G","", "","","","mv_par21"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "22","Do Lote"  				,"",""					,"mv_chk"	,"C"	,15	,0	,0	,"G","", "","","","mv_par22"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "23","Ate o Lote"				,"",""					,"mv_chl"	,"C"	,15	,0	,0	,"G","", "","","","mv_par23"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "24","Do Grupo Material"		,"",""					,"mv_chm"	,"C"	,04	,0	,0	,"G","", "","","","mv_par24"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "25","Até Grupo o Grupo Material"	,"",""				,"mv_chn"	,"C"	,04	,0	,0	,"G","", "","","","mv_par25"," "," "," ","","","","","","","","","","","",""," ", , ,)
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