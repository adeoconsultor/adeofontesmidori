#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
//
//
User Function MD_RLVNPRD()
//
cPerg      := "MDRLVN"
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
Local nn1, nnr, nn2, nK, nMeses
/*
cEmpAnt := '01'
RpcSetType( 3 ) // Desligando o servidor de licencas
RpcSetEnv(cEmpAnt, '08',,,,, { "SG1", "SB1", "SC2" } )
*/
//
aDesCMeses := { 'JANEIRO','FEVEREIRO','MARCO','ABRIL','MAIO','JUNHO','JULHO','AGOSTO','SETEMBRO','OUTUBRO','NOVEMBRO','DEZEMBRO' }
DtIni 			:=  DTOS ( MV_PAR03 )
DtFim 		:=  DTOS(  MV_PAR04 )
cArqTrab   := ''
aMeses    := {}
CriaBdTrb() // Chamando a funcao que cria a tabela temporario
ListaGrupos()
//
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
		IF  M0_CODFIL >=   MV_PAR01   .AND.  M0_CODFIL <=  MV_PAR02
			AAdd( aFils ,  M0_CODFIL )
		ENDIF
	ENDIF
	//
	DbSkip()
Enddo
//
DbGoTo( nRecM0 )
//
// O laco Abaixo cria as Arrays por Filial de acordo com os registros levantados na SM0
Procregua( len( aFils )  )
For nn1 := 1 to  len( aFils )
	//
	IncProc( 'Processando Movimentos da Filial ' +  aFils[NN1]  )
	//
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
	  	if SF4->F4_TRANFIL <> '1' // SE A ENTRADA PROVEM DA TRANSFERENCIA DE OUTRA FILIAL
			//
			DbSelectArea( 'TRB' )
			if DbSeek( aFils[NN1] + SD2->D2_CCUSTO + SD2->D2_COD + SUBSTR( DTOS( SD2->D2_EMISSAO ),  1 , 6  )   )
				Reclock('TRB', .F. )
				//alert( 'achei SD2')
			Else
				Reclock('TRB', .T. )
				Replace FILIAL 		WITH  aFils[NN1]
				Replace PRODUTO 	WITH  SD2->D2_COD
				Replace CCUSTO		WITH SD2->D2_GRUPO
				Replace ANOMES			WITH SUBSTR( DTOS( SD2->D2_EMISSAO ),  1 , 6  )
				//
				/*
				SB1->( DbSeek( xFilial('SB1') + SD2->D2_COD ) )
				aSalAlmox := CalcEst( SD2->D2_COD , SB1->B1_LOCPAD , STOD( DtIni ) - 1     )
				//
				Replace QTANT			WITH QTANT +  aSalAlmox[ 1 ]
				Replace VATU1			WITH VATU1 + 	aSalAlmox[  2 ]
				*/
				//
			Endif
			//  
			/*
			aTam:=TamSX3("D2_TOTAL")
			AADD(aCampos,{ "D2VTRAN"   ,"N",aTam[1],aTam[2] } )
			AADD(aCampos,{ "D2PRODS"   ,"N",aTam[1],aTam[2] } )*/
			//
			Replace D2IPI		WITH	D2IPI	 	+	 	SD2->D2_VALIPI
			Replace D2ICMS 		WITH    D2ICMS 	    +		SD2->D2_VALICM
			Replace D2PIS		WITH    D2PIS  		+		SD2->D2_VALIMP5
			Replace D2COFINS    WITH    D2COFINS    +	 	SD2->D2_VALIMP6
			Replace D2FRETE     WITH    D2FRETE     +		SD2->D2_VALFRE

			            			
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
	cConteudo  :=  CHR(13)  + CHR(10)  + CHR(13)  + CHR(10)+ 'ANALISE DE VENDAS' + CHR(13)  + CHR(10) + CHR(13)  + CHR(10)
	cConteudo += CHR(13)  + CHR(10)  + aDesCMeses[ VAL( SUBSTR( aMeses[nMeses], 5,2 )  )  ] + ' / '  + SUBSTR( aMeses[nMeses], 1,4  ) + CHR(13)  + CHR(10)
	
	cConteudo += 'Grupo;;Faturado'  + cHR(13) + CHR(10) + 'Filial;Vendas;Produtos;Nomenclatura;TOTAL;IPI;ICMS;PIS;COFINS;Fretes'+ Chr(13) + chr(10)
	//
	For nnr := 4 to 9
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
				nRetPos := Ascan(  cArFil ,     {|x| Alltrim( x[1] )  ==  Alltrim( CCUSTO )  .and.  Alltrim( x[2] ) ==  Alltrim( ANOMES  )   .and.  Alltrim( x[3] ) ==  Alltrim( PRODUTO  )   }  )
				//
				IF nRetPos == 0
					
					Aadd( cArFil ,{ Alltrim( CCUSTO )  ,  Alltrim( ANOMES  ), PRODUTO ,  D2VTRAN, D2IPI,D2ICMS,D2PIS,D2COFINS,D2FRETE  }  )
					//											 QTANT + D1QUANT + D1QTRAN   ,   VATU1 + D1TOTAL + D1VTRAN   }  )
					
				Else
					cArFil[nRetPos, 4] += d2vtran
					cArFil[nRetPos, 5] += d2ipi
					cArFil[nRetPos, 6] += D2icms
					cArFil[nRetPos, 7] += D2pis
					cArFil[nRetPos, 8] += D2cofins
					cArFil[nRetPos, 9] += D2frete
				Endif
				//
				DbSelectArea('TRB')
				DbSkip()
			Enddo
		Else
			lTemFilial := .F.
		Endif
		//
		For nnr := 4 to 9
			CnTot := 'nTot' + Alltrim( Str( nnr ) )
			&CnTot := 0
		Next
		// 
		//CaRfIL :=aSort()
		CaRfIL := aSort( CaRfIL,,, { |x, y| x[1] + x[2]  < y[2] +y[2]  } )
		//  
		cFilGrpAnt := ''
		lPrim := .T. 
		For nK := 1 to len( cArFil )			            
			
			// cConteudo += aFils[ nn2 ] +';' +  cArFil[nK, 1] +';' + cArFil[ nK, 2 ]+ ';' + Transform( cArFil[ nK, 3 ], ' @E 99,999,999.9999'  )  +';'+ Transform( cArFil[ nK, 4 ], ' @E 99,999,999.9999'  )  +';'+ Transform( cArFil[ nK, 5 ], ' @E 99,999,999.9999'  )  +';'+;
			// Transform( cArFil[ nK, 6 ], ' @E 99,999,999.9999'  )  +';'+ Transform( cArFil[ nK, 7 ], ' @E 99,999,999.9999'  )  +';'+ Transform( cArFil[ nK, 8 ], ' @E 99,999,999.9999'  )  +';'+;
			// Transform( cArFil[ nK, 9 ], ' @E 99,999,999.9999'  )  +';'+ Transform( cArFil[ nK, 10 ], ' @E 99,999,999.9999'  )  +';'+ Transform( cArFil[ nK, 11 ], ' @E 99,999,999.9999'  )  +';'+;
			// Transform( cArFil[ nK,12 ], ' @E 99,999,999.9999'  )  + ';'+  Transform(  ( cArFil[nK, 4]  + cArFil[nK, 5]  + cArFil[nK, 7]  ) - ( cArFil[nK, 9]  + cArFil[nK, 11]   )  , ' @E 99,999,999.9999'  ) + ';'+;
			// Transform( ( cArFil[nK, 3] + cArFil[nK, 6]  + cArFil[nK, 8]  ) - ( cArFil[nK, 10]  + cArFil[nK, 12]  )  , ' @E 99,999,999.9999'  ) +  Chr(13) + chr(10)
			if cFilGrpAnt  <> cArFil[nK, 1] + cArFil[ nK, 2 ]                                                                                              
			    //
			    if !lPrim
			       cConteudo += + Chr(13) + chr(10)  + ' ; ; ;Total Grupo ;' + str(AtotGr[1])+';'+str(AtotGr[2])+';'+str(AtotGr[3])+';'+str(AtotGr[4])+';'+str(AtotGr[5]) + chr(13) + Chr(10) +  chr(13) + Chr(10)
			    Endif 
			    //
				cConteudo += aFils[ nn2 ] +';' +  cArFil[nK, 1] +' - '+POSICIONE('SBM', 1, XFILIAL('SBM') + cArFil[nK, 1] , 'BM_DESC' )  + Chr(13) + chr(10) 
				//
				AtotGr := {0,0,0,0,0,0}
				lPrim := .F. 
				//
			Endif 
			//			
			// cConteudo += aFils[ nn2 ] +';' +  cArFil[nK, 1] +' - '+POSICIONE('SBM', 1, XFILIAL('SBM') + cArFil[nK, 1] , 'BM_DESC' )  + Chr(13) + chr(10) +;
			cConteudo += ';' + cArFil[ nK, 2 ]+ ';' +  cArFil[ nK, 3 ] +' ;' +POSICIONE('SB1', 1, XFILIAL('SB1') + cArFil[nK, 3] , 'B1_DESC' )     +';'+ str( cArFil[ nK, 4 ]  )  +';'+ str( cArFil[ nK, 5 ]  )  +';'+;
			str( cArFil[ nK, 6 ]  )  +';'+ str( cArFil[ nK, 7 ]  )  +';'+ str( cArFil[ nK, 8 ]  ) +';'+ str( cArFil[ nK, 9 ]  )  +';' +  Chr(13) + chr(10)
			//
			For nnr := 4 to 9
				CnTot := 'nTot' + Alltrim( Str( nnr ) )
				&CnTot += cArFil[ nk, nnr ]
				//
				CnTot := 'nTotGer' + Alltrim( Str( nnr ) )
				&CnTot += cArFil[ nk, nnr ]
				//
			Next
			//
			cFilGrpAnt  := cArFil[nK, 1] + cArFil[ nK, 2 ]
			AtotGr[1]  += cArFil[nK, 4]
			AtotGr[2]  += cArFil[nK, 5]
			AtotGr[3]  += cArFil[nK, 6]
			AtotGr[4]  += cArFil[nK, 7]
			AtotGr[5]  += cArFil[nK, 8]
			AtotGr[5]  += cArFil[nK, 9]			
			//
		Next
		//
		if lTemFilial
			cConteudo += ';TOTAL FILIAL ' + aFils[ nn2 ] + ';;;'
			//
			For nnr := 4 to 9
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
	For nnr := 4 to 9
		//CnTot := "Transform( nTotGer" + Alltrim( Str( nnr ) ) + ", ' @E 99,999,999.9999' )"
		CnTot := "Str( nTotGer" + Alltrim( Str( nnr ) ) + ")"
		cConteudo += &CnTot + ';'
	Next
	//
	cConteudo := substr(cConteudo, 1, len(cConteudo) -1 ) + chr(13) + chr( 10 )
	//
	cConteudo := StrTran( cConteudo, '.' , ','  )
	//
	cDirCsv := Alltrim( mv_par07 )
	
	MemoWRite(cDirCsv + '\MOV_' + aDesCMeses[ VAL( SUBSTR( aMeses[nMeses], 5,2 )  )  ] + '_'  + SUBSTR( aMeses[nMeses], 1,4  )   +  '.CSV',   cConteudo  )
	//
	If lExcel
		oExcelApp:WorkBooks:Open( cDirCsv + '\MOV_' + aDesCMeses[ VAL( SUBSTR( aMeses[nMeses], 5,2 )  )  ] + '_'  + SUBSTR( aMeses[nMeses], 1,4  )   +  '.CSV'   ) // Abre o arquivo gerado
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
aTam:=TamSX3("D2_GRUPO")
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
AADD(aCampos,{ "D2PRODS"   ,"N",aTam[1],aTam[2] } )
//
aTam:=TamSX3("CD2_VLTRIB")
AADD(aCampos,{ "D2IPI"   ,"N",aTam[1],aTam[2] } )
AADD(aCampos,{ "D2ICMS"   ,"N",aTam[1],aTam[2] } )
AADD(aCampos,{ "D2PIS"   ,"N",aTam[1],aTam[2] } )
AADD(aCampos,{ "D2COFINS"   ,"N",aTam[1],aTam[2] } )
AADD(aCampos,{ "D2FRETE"   ,"N",aTam[1],aTam[2] } )


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
PutSx1(cPerg,"01","Filial De "		,"Filial De "	,"Filial De "	,"mv_ch1"	,"C"	,02	,0	,0	,"G",,,,,"mv_par01",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg,"02","Filial Ate "		,"Filial Ate "	,"Filial Ate "	,"mv_ch2"	,"C"	,02	,0	,0	,"G",,,,,"mv_par02",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg,"03","Data De "		,"Data De "		,"Data De "		,"mv_ch3"	,"D"	,08	,0	,0	,"G",,,,,"mv_par03",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg,"04","Data Ate "		,"Data Ate "	,"Data Ate "	,"mv_ch4"	,"D"	,08	,0	,0	,"G",,,,,"mv_par04",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg,"05","Do Grupo  ?"		,""				,""				,"mv_ch5"	,"C"	,04	,0	,0	,"G","", "SBM","","","mv_par05"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg,"06","Ate o Grupo?"	,""				,""				,"mv_ch6"	,"C"	,04	,0	,0	,"G","", "SBM","","","mv_par06"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg,"07","Diretorio?"		,""				,""				,"mv_ch7"	,"C"	,80 ,0	,0	,"G","", "","","","mv_par07"," "," "," ","","","","","","","","","","","",""," ", , ,)
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
	//
	lEscolhido := iif( ( BM_GRUPO >= mv_par05 .AND. BM_GRUPO <= MV_PAR06 ) , .t.,.f.)
	//
	AADD(aGrupo,{ lEscolhido , SubStr(BM_GRUPO,1,5)+" "+cCapital})
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