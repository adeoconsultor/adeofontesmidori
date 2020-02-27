#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
//
//
//
User Function MD_RLPRPRC()
//
cPerg      := "MPRPRC"
aArea := GetArea()
nOpcA := 0
cContGrupo := ''
//
AjustaSx1() // Funcao faz a montagem das perguntas
PERGUNTE(cPerg, .F. )
//
FormBatch('Produtos em Processo Produtivo',{'Produtos em Processo Produtivo','Esta rotina gerará a planilha Excel ref. aos produtos em processo produtivo ( estoque ), conforme os parametros especificos.' },;
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
aDesCMeses 		:= { 'JANEIRO','FEVEREIRO','MARCO','ABRIL','MAIO','JUNHO','JULHO','AGOSTO','SETEMBRO','OUTUBRO','NOVEMBRO','DEZEMBRO' }
cArqTrab   		:= ''
aMeses    		:= {}
//
//cQuery          := "Select SZ3.R_E_C_N_O_ as REC, SZ7.R_E_C_N_O_ as RECSZ7  FROM "+ RetSqlName('SZ3') + " SZ3, " +  RetSqlName('SZ7') + " SZ7 "
//cQuery          += " Where SZ3.D_E_L_E_T_ = ' ' and SZ3.Z3_FILIAL = '" + xFilial('SZ3') + "' and "
//cQuery          += "SZ3.Z3_DTAPON   = '"+space(08) + "'  and "
//cQuery          += "SZ3.Z3_MATERIA    >= '"+ MV_PAR03 + "' and SZ3.Z3_MATERIA <= '" + MV_PAR04  + "' AND "
//cQuery          += "SZ7.Z7_FILIAL = '" + xFilial('SZ7') + "' AND SZ7.Z7_NUMFC =  SZ3.Z3_NUMFC AND SZ7.Z7_FASE = '01' AND SZ7.D_E_L_E_T_ =' ' "
//
cQuery          := "Select SZ3.R_E_C_N_O_ as REC  FROM "+ RetSqlName('SZ3') + " SZ3  "
cQuery          += " Where SZ3.D_E_L_E_T_ = ' ' and SZ3.Z3_FILIAL = '" + xFilial('SZ3') + "' and "
cQuery          += "SZ3.Z3_DTAPON   = '"+space(08) + "'  and "
cQuery          += "SZ3.Z3_MATERIA    >= '"+ MV_PAR03 + "' and SZ3.Z3_MATERIA <= '" + MV_PAR04  + "' "
//cQuery          += "SC
//cQuery          += "SZ7.Z7_FILIAL = '" + xFilial('SZ7') + "' AND SZ7.Z7_NUMFC =  SZ3.Z3_NUMFC AND SZ7.Z7_FASE = '01' AND SZ7.D_E_L_E_T_ =' ' "
//
memowrite('c:\tt1.sql',cQuery )
//alert('salvei')
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
ProcREgua( nTotalITens )
//
cItensLin := ''
//
aDataItens := {} // array que contera os itens que serao descarregados
nItemAtu := 0
aPlanosJa := {} // array que contera os planos ja processados para soma das quantidades
//
//
While !eof()
	nItemAtu ++
	DbSelectArea( 'SZ3' )
	DbGoTo( TRBSZ3->REC )
	Incproc('Item:  ' + Alltrim(Str( nItemAtu ))+ '  De: '+Alltrim( Str(nTotalITens))  )
	//
	DbSelectArea( 'SZ7' )
	DbSetOrder(1)
	if ( ! DbSeek( xFilial('SZ7') + SZ3->Z3_NUMFC + '01'  ) ) .OR. ;  // INTERESSA APENAS AS FICHAS QUE JA FORAM INICIADAS PELO OPERADOR
	   ( DbSeek( xFilial('SZ7') + SZ3->Z3_NUMFC + '06'  ) )

		DbSelectArea( 'TRBSZ3' )
		DbSkip()
	    Loop

	ENDIF
  
//	if posicione('SD4',2,xFilial('SD4') + SZ3->(Z3_NUMOP + Z3_ITEM + Z3_SEQUEN),"D4_LOCAL") <>  '02'
//		DbSelectArea( 'TRBSZ3' )
//		DbSkip()
//	    Loop
//	endif		
	 
	
	//
	//
	sb1->( DbSeek(xFilial('SB1') + SZ3->Z3_MATERIA ) ) 
	//
	// Este bloco pesquisa o elemento da array de acordo com o item de aglutinacao escolhido
	nPosicao := Ascan( aDataItens , {|x| Alltrim(x[1]) == Alltrim( SZ3->Z3_MATERIA ) }  )
	if nPosicao > 0 
	   aDataItens[ nPosicao, 4 ]  += SZ3->Z3_M2TOT
	Else  
	     //aSaldo    := CalcEst( SB1->B1_COD ,SB1->B1_LOCPAD , dDataBase )

		SB2->(DBSETORDER(1))
		SB2->( DBSEEK( XFILIAL('SB2') + SZ3->Z3_MATERIA + SB1->B1_LOCPAD ) ) 
		//                             		
		AAdd( 	aDataItens, { 	sz3->z3_materia , Posicione( 'SB1' , 1 , xFilial('SB1') + SZ3->Z3_MATERIA , 'B1_DESC' ) , SB2->B2_QATU, SZ3->Z3_SLDM2 } )
		// AAdd( 	aDataItens, { 	sz3->z3_materia , Posicione( 'SB1' , 1 , xFilial('SB1') + SZ3->Z3_MATERIA , 'B1_DESC' ) , aSaldo[1] - SZ3->Z3_M2TOT , SZ3->Z3_M2TOT } )
	Endif 
	//
	DbSelectArea( 'TRBSZ3' )
	DbSkip()
	//
Enddo
//
lExcel := .F.
If ! ApOleClient( 'MsExcel' )
	MsgStop( 'MsExcel nao instalado. ' )
Else
	lExcel := .T.
	oExcelApp := MsExcel():New()
	oExcelApp:SetVisible(.T.)
Endif
//
//               
cNomeArq := ''
nSeqtx := 1     
nHdl := -1
While nHdl == -1           
   cNomeArq := 'c:\MD_PRPRC' + Strzero( nSeqtx,2 ) + '.CSV'
   nHdl	:=	MSFCreate( cNomeArq )
   nSeqtx++   
Enddo
//
cCabecalho := 'Produtos em Processo Produtivo  - Data de Emissao : ' + Dtoc( dDataBase ) + chr(13) + chr(10)
cCabecalho += 'Peca Plano;Descricao;Estoque Fisico - Processo Produtivo;M2 Processo Produtivo;Estoque Fisico'   + Chr(13) + Chr(10)
fWrite( nHdl , cCabecalho )                  		// Filial          02
ProcRegua( len( aDataItens ) )
For nn1 := 1 to len( aDataItens )
	//
	incproc('Gerando Planilha...')
	cItensLin := 	Alltrim(aDataItens[nn1,1 ]) + ';'	+ 	Alltrim(aDataItens[nn1,2 ] )  + ';' + Alltrim(STR( aDataItens[nn1 , 3 ] - aDataItens[nn1 , 4 ]  ) ) + ';' + Alltrim(STR( aDataItens[nn1 , 4 ] ) )+;
	                ';'+Alltrim(STR( aDataItens[nn1 , 3 ] ) ) + Chr(13) + chr(10)
	//
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

// MEMOWRITE('C:\TECO_RELPNPII.CSV', cCabecalho + cItensLin )
Return()
//------------------------------------------------------------------------------
Static Function AjustaSx1()
//
PutSx1(cPerg, "01","Do Grupo"  				,"",""					,"mv_ch1"	,"C"	,04	,0	,0	,"G","", "","","","mv_par01"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "02","Ate o Grupo"			,"",""					,"mv_ch2"	,"C"	,04	,0	,0	,"G","", "","","","mv_par02"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "03","Do Material Plano" 		,"",""					,"mv_ch3"	,"C"	,15	,0	,0	,"G","", "","","","mv_par03"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "04","Ate o Material Plano"	,"",""					,"mv_ch4"	,"C"	,15	,0	,0	,"G","", "","","","mv_par04"," "," "," ","","","","","","","","","","","",""," ", , ,)
//PutSx1(cPerg, "05","Do Armazem       " 		,"",""					,"mv_ch5"	,"C"	,02	,0	,0	,"G","", "","","","mv_par05"," "," "," ","","","","","","","","","","","",""," ", , ,)
//PutSx1(cPerg, "06","Ate o Armazem       "	,"",""					,"mv_ch6"	,"C"	,02	,0	,0	,"G","", "","","","mv_par06"," "," "," ","","","","","","","","","","","",""," ", , ,)
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
