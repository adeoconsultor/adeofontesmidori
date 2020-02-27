#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
//
//
User Function MD_RLD3()
//
cPerg      := "MDRLD3"
aArea := GetArea()
nOpcA := 0
cContGrupo := ''
//
AjustaSx1() // Funcao faz a montagem das perguntas
PERGUNTE(cPerg, .F. )
//
FormBatch('Movimentacoes de Produtos',{'Movimentacoes de Produtos','Esta rotina gerará a planilha Excel ref. as movimentacoes de produtos via Producao por Filial e Periodo'},;
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
Local nn1
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
	cQueryD3 := "Select R_E_C_N_O_ as REC from 	" +  RetSqlName("SD3") + " Where D3_FILIAL = '" + aFils[NN1] + "' "
	cQueryD3 += " AND D3_EMISSAO >= '" + DtIni  + "'"
	cQueryD3 += " AND D3_EMISSAO <= '" + DtFim + "'"
	cQueryD3 += " AND D3_COD >= '" + mv_par05  + "'"
	cQueryD3 += " AND D3_COD <= '" + mv_par06 + "'"
	cQueryD3 += " AND D3_GRUPO >= '" + mv_par07  + "'"
	cQueryD3 += " AND D3_GRUPO <= '" + mv_par08 + "'"
	cQueryD3 += " AND D3_TIPO >= '" + mv_par09  + "'"
	cQueryD3 += " AND D3_TIPO <= '" + mv_par10  + "'"
	cQueryD3 +=  " AND D3_CF = 'PR0'"
	//
	IF ! EMPTY(cContGrupo)
		cQueryD3 += " AND D3_GRUPO IN( "+ cContGrupo + ") "
	Endif
	//
	
	cQueryD3 += " AND D3_ESTORNO <> 'S' "
	cQueryD3 += " AND D_E_L_E_T_=' '"
	//
	IF SELECT( 'TRBSD3' )  > 0
		DbSelectArea( 'TRBSD3' )
		DbcloseArea()
	ENDIF
	//
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQueryD3), 'TRBSD3' , .F. , .T. )
	//
	DbSelectArea( 'TRBSD3' )
	DbGoTop()
	//
	While ! Eof()
		DbSelectArea( 'SD3' )
		DbGoTo( TRBSD3->REC )
		//
		//
		// O BLOCO ABAIXO TEM COMO OBJETIVO GRAVAS OS REGISTROS DENTRO DA TABELA TEMPORARIA
		//
		DbSelectArea( 'TRB' )
		if DbSeek( aFils[NN1] + SD3->D3_COD + SUBSTR( DTOS( SD3->D3_EMISSAO ),  1 , 6  )   )
			Reclock('TRB', .F. )
			//alert( 'achei SD3')
		Else
			Reclock('TRB', .T. )
			Replace FILIAL 		WITH  aFils[NN1]
			Replace PRODUTO 	WITH  SD3->D3_COD
			Replace ANOMES			WITH SUBSTR( DTOS( SD3->D3_EMISSAO ),  1 , 6  )
			//
			SB1->( DbSeek( xFilial('SB1') + SD3->D3_COD ) )
			//aSalAlmox := CalcEst( SD3->D3_COD , SB1->B1_LOCPAD , STOD( DtIni ) - 1     )
			//
			// Replace QTANT			WITH QTANT +  aSalAlmox[ 1 ]
			// Replace VATU1			WITH VATU1 + 	aSalAlmox[  2 ]
			//
		Endif
		//
		//
		Replace D3QUANT		WITH	D3QUANT	 	+	 	SD3->D3_QUANT
		Replace D3TOTAL		WITH    D3TOTAL	    +		SD3->D3_CUSTO1
		//
		MsUnlock()
		//
		DbSelectArea( 'TRBSD3' )
		DbSkip()
	Enddo
	//
Next
//
cLinha := ''
DbSelectarea('TRB')
DbGoTop()
//
DbSelectarea('TRB')
DbGoTop()
//
// O bloco abaixo tem como objetivo alimentar as arrays para as filiais
lExcel := .F.

lExcel := .F.
If ! ApOleClient( 'MsExcel' )
	MsgStop( 'MsExcel nao instalado.')
Else
	lExcel := .T.
	oExcelApp := MsExcel():New()
	oExcelApp:SetVisible(.T.)
Endif
//

// Humberto
  
cConteudo  :=  CHR(13)  + CHR(10)  + CHR(13)  + CHR(10)
cConteudo  += 'Filial de: '     + MV_PAR01 + CHR(13)  + CHR(10) 
cConteudo  += 'Filial até: '    + MV_PAR02 + CHR(13)  + CHR(10)
cConteudo  += 'Data de: '       + DtoC(MV_PAR03) + CHR(13)  + CHR(10)
cConteudo  += 'Data ate: '      + DtoC(MV_PAR04) + CHR(13)  + CHR(10)
cConteudo  += 'Do Produto: '    + MV_PAR05 + CHR(13)  + CHR(10)
cConteudo  += 'Ate o Produto: ' + MV_PAR06 + CHR(13)  + CHR(10)
cConteudo  += 'Do Grupo: '      + MV_PAR07 + CHR(13)  + CHR(10)
cConteudo  += 'Ate o Produto: ' + MV_PAR08 + CHR(13)  + CHR(10)
cConteudo  += 'Do Tipo: '       + MV_PAR09 + CHR(13)  + CHR(10)
cConteudo  += 'Ate o Tipo: '    + MV_PAR10 + CHR(13)  + CHR(10)
cConteudo  += 'Diretorio: '     + MV_PAR11 + CHR(13)  + CHR(10)
cConteudo  +=  CHR(13)  + CHR(10)
cConteudo  += 'Data da Consulta: ' + DtoC(dDataBase)


cConteudo  +=  CHR(13)  + CHR(10)  + CHR(13)  + CHR(10)+ 'RELATORIO DE PRODUÇÃO;Periodo Inicial: '+ dToc(MV_PAR03)+'; Periodo Final :  '+ dToc(MV_PAR04)+ CHR(13)  + CHR(10) + CHR(13)  + CHR(10)
// CConteudo  += 'Unidade : ' + sm0->m0_filial + CHR(13)  + CHR(10) + CHR(13)  + CHR(10)

cConteudo += ';;PRODUTOS;;PRODUCAO;;;;ESTOQUE ATUAL '  + cHR(13) + CHR(10)
cConteudo +=  'Grupo;Descricao Grupo ; Código;Nomenclatura;Unid.;Quantidade;Custo Variável;Unitário;Quantidade;Unitário;Total'+ Chr(13) + chr(10)
//
//
ProcREgua( TRB->( RecCount() ) )
DbSelectArea('TRB')
DbGoTop()
cFilAnt := ''
While ! eof()
	//
	IncProc( 'Gerando Planilha ...' )
	//                                                
	DbSelectArea('SB1')
	DbSetORder(1)
	DbSeek( xFilial('SB1') + TRB->PRODUTO ) 
	//
	DbSelectARea('TRB')
	//
	if cFilAnt <> filial                                                                                                                                                          
	   cConteudo += CHR(13) + chr(10) + CHR(13) + chr(10)
	   cConteudo += ' UNIDADE :  ' + trb->FILIAL + ' - ' +  Posicione("SM0",1,cEmpAnt + TRB->filial , "M0_FILIAL")	   + CHR(13) + chr(10)
	Endif 
	// 
	SB2->(DbSetOrder(1))
	SB2->(DbSeek( trb->filial + SB1->B1_COD + SB1->B1_LOCPAD ))  
	//
	//cConteudo += SB1->B1_GRUPO + ';' + Posicione('SBM', 1, xFilial('SBM') + SB1->B1_GRUPO,'BM_DESC') + ';' + Produto+ ';' + SB1->B1_DESC  + ';' + SB1->B1_UM  +';'+ str( D3QUANT )  +';'+ str( D3TOTAL  )  +';'+str(D3TOTAL  / D3QUANT) +';'+ str( SB2->B2_QATU  ) +';'+ str( SB2->B2_VATU1  / SB2->B2_QATU  ) +';'+ str( SB2->B2_VATU1   ) +  Chr(13) + chr(10)
	cConteudo += SB1->B1_GRUPO + ';' + Posicione('SBM', 1, xFilial('SBM') + SB1->B1_GRUPO,'BM_DESC') + ';' + Produto+ ';' + SB1->B1_DESC  + ';' + SB1->B1_UM  +';'+ str( D3QUANT )  +';'+ Transform(D3TOTAL,"99999999999999.9999" )  +';'+Transform(D3TOTAL  / D3QUANT,"99999999999999.9999") +';'+ Transform(SB2->B2_QATU,"99999999999999.99") +';'+ Transform(SB2->B2_VATU1 / SB2->B2_QATU,"999999999999999999.9999") +';'+ Transform(SB2->B2_VATU1,"999999999999999999.99") +  Chr(13) + chr(10)

	//
	DbselectArea('TRB')
	cFilAnt := filial                                                                                                                                                                                                                                                                                                                                                                                           
	DbSkip()
Enddo
//
//                      
cDirCsv := Alltrim( mv_par11 ) 
cConteudo := substr(cConteudo, 1, len(cConteudo) -1 ) + chr(13) + chr( 10 )                                                                                                                 
cConteudo := StrTran( cConteudo, '.' , ','  )
MemoWRite(cDirCsv+ '\PRODUCAO_.CSV',   cConteudo  )
//
If lExcel
	oExcelApp:WorkBooks:Open( cDirCsv+'\PRODUCAO_.CSV'   ) // Abre o arquivo gerado
Endif
//
//
DbCloseArea()
//
Return()
//------------------------------------------------------------------------------
Static Function CriaBdTrb() // Chamando a funcao que cria a tabela temporario

Local aCampos 	:= {}

AADD(aCampos,{ "FILIAL"  ,"C", 2 ,0 } )
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
aTam:=TamSX3("D3_QUANT")
AADD(aCampos,{ "D3QUANT"   ,"N",aTam[1],aTam[2] } )
//
aTam:=TamSX3("D3_CUSTO1")
AADD(aCampos,{ "D3TOTAL"   ,"N",aTam[1],aTam[2] } )
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
IndRegua("TRB",cArqTrab,"FILIAL + PRODUTO + ANOMES",,,"Selecionando Registros..." )

Return()
//-----------------------------------------
Static Function AjustaSx1()
//
PutSx1(cPerg,"01","Filial De "		,"Filial De "	,"Filial De "	,"mv_ch1"	,"C"	,02	,0	,0	,"G",,,,,"mv_par01",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg,"02","Filial Ate "		,"Filial Ate "	,"Filial Ate "	,"mv_ch2"	,"C"	,02	,0	,0	,"G",,,,,"mv_par02",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg,"03","Data De "		,"Data De "		,"Data De "		,"mv_ch3"	,"D"	,08	,0	,0	,"G",,,,,"mv_par03",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg,"04","Data Ate "		,"Data Ate "	,"Data Ate "	,"mv_ch4"	,"D"	,08	,0	,0	,"G",,,,,"mv_par04",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg,"05","Do Produto  ?"	,""				,""				,"mv_ch5"	,"C"	,15	,0	,0	,"G","", "SB1","","","mv_par05"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg,"06","Ate o PRoduto?"	,""				,""				,"mv_ch6"	,"C"	,15	,0	,0	,"G","", "SB1","","","mv_par06"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg,"07","Do Grupo  ?"		,""				,""				,"mv_ch7"	,"C"	,04	,0	,0	,"G","", "SBM","","","mv_par07"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg,"08","Ate o Grupo?"	,""				,""				,"mv_ch8"	,"C"	,04	,0	,0	,"G","", "SBM","","","mv_par08"," "," "," ","","","","","","","","","","","",""," ", , ,)

PutSx1(cPerg,"09","Do Tipo  ?"		,""				,""				,"mv_ch9"	,"C"	,02	,0	,0	,"G","", "","","","mv_par09"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg,"10","Ate o Tipo?"		,""				,""				,"mv_cha"	,"C"	,02	,0	,0	,"G","", "","","","mv_par10"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg,"11","Diretorio?"		,""				,""				,"mv_chb"	,"C"	,80 ,0	,0	,"G","", "","","","mv_par11"," "," "," ","","","","","","","","","","","",""," ", , ,)

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
	lEscolhido := iif( ( BM_GRUPO >= mv_par07 .AND. BM_GRUPO <= MV_PAR08 ) , .t.,.f.)
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