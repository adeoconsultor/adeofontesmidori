#INCLUDE "MATR820.CH"
#INCLUDE "RWMAKE.CH"
/*
Funcao de Emissao do Formulario CT - 08
Desenvolvido por Rogerio Nunes em 12/03/10
*/
Static cAliasTop

User Function MID_MTR820()
Local titulo  := STR0039 //"Ordens de Producao"
Local cString := "SC2"
Local wnrel   := "MATR820"
Local cDesc   := STR0001	//"Este programa ira imprimir a Rela‡„o das Ordens de Produ‡„o"
Local aOrd    := {}	//"Por Numero"###"Por Produto"###"Por Centro de Custo"###"Por Prazo de Entrega"
Local tamanho := "P"

//Private aReturn  := {STR0006,1,STR0007, 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
Private aReturn  := {STR0006,1,STR0007, 3, 2, 2, "",3 }	//"Zebrado"###"Administracao"
Private cPerg    :="MDRLPL"
Private nLastKey := 0
Private lItemNeg := .F.
Private cMainOp
//
AjustaSx1()
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPErg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Do PLano                                ³
//³ mv_par02            // Ate o Plano                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//-- Verifica se o SH8 esta locado para atualizacao por outro processo
If !IsLockSH8()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd,.F.,Tamanho)
	
	lItemNeg := GetMv("MV_NEGESTR") .And. mv_par11 == 1
	
	If nLastKey == 27
		dbSelectArea("SH8")
		dbClearFilter()
		dbCloseArea()
		dbSelectArea("SC2")
		Return
	Endif
	//
	SetDefault(aReturn,cString)
	//
	If nLastKey == 27
		dbSelectArea("SH8")
		dbClearFilter()
		dbCloseArea()
		dbSelectArea("SC2")
		Return
	Endif                                            

	
	RptStatus({|lEnd| R820Imp(@lEnd,wnRel,titulo,tamanho)},titulo)
	
EndIf

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R820Imp  ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 13.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R820Imp(lEnd,wnRel,titulo,tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbCont,cabec1,cabec2
Local limite     := 80
Local nQuant     := 1
Local nomeprog   := "MATR820"
Local nTipo      := 18
Local cProduto   := SPACE(LEN(SC2->C2_PRODUTO))
Local cQtd,i,nBegin
Local cIndSC2    := CriaTrab(NIL,.F.), nIndSC2

#IFDEF TOP
	Local bBlockFiltro := {|| .T.}
#ENDIF

Private aArray   := {}
Private li       := 80

cAliasTop  := "TRBC2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
m_pag    := 1
lPrim    := .t.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1 := ""
cabec2 := ""
//
dbSelectArea("SC2")
DbSetOrder( 1 )
//
                         

// cAliasTop := GetNextAlias()
cQuery := "SELECT SC2.R_E_C_N_O_ AS REC "
cQuery += " FROM "+RetSqlName("SC2")+" SC2 WHERE "
cQuery += "SC2.C2_FILIAL='"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_=' ' AND "
cQuery += "SC2.C2_OPMIDO >= '" +alltrim(MV_PAR01) +"' AND SC2.C2_OPMIDO <= '" + alltrim(MV_PAR02) + "' AND "
cQuery += "SC2.C2_EMISSAO between '"+dTos(MV_PAR03)+"' AND '"+dTos(MV_PAR04)+"' "
// cQuery += "ORDER BY SC2.C2_NUM, "
//
If Select("TRBC2") > 0
	DbSelectArea( "TRBC2" )
	DbCloseArea()
Endif
//
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBC2",.T.,.T.)
//                        

SetRegua( TRBC2->(LastRec()) )

//
While !Eof()

	
	IF lEnd
		@ Prow()+1,001 PSay STR0009	//"CANCELADO PELO OPERADOR"
		Exit
	EndIF
	
	IncRegua()
	
	SC2->(dbGoto( (cAliasTop)->REC ) )
	//
	//
	cMainOp := SC2->C2_NUM
	//
	//
	cProduto  := SC2->C2_PRODUTO
	//             
	
	dbSelectArea("SB1")
	dbSeek(xFilial()+cProduto)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona o primeiro elemento da estrutura , ou seja , o Pai  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//
	// Carr_GrOPS()
	//
	//
	SC2->(dbGoto( (cAliasTop)->REC ) )
	//                   

	cProduto  := SC2->C2_PRODUTO
	//
	dbSelectArea("SB1")
	dbSeek(xFilial()+cProduto)
	                  
	
	AddAr820(nQuant)
	                  
	
	SC2->(dbGoto( (cAliasTop)->REC ) ) // Reposicionando o SC2 para a impressao do Ct08
	//
	/*
	If mv_par09 == 1
	aSort( aArray,2,, { |x, y| (x[1]+x[8]) < (y[1]+y[8]) } )
	Else
	aSort( aArray,2,, { |x, y| (x[8]+x[1]) < (y[8]+y[1]) } )
	ENDIF
	*/
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime cabecalho                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cabecOp(Tamanho)
	lPrim := .T.
	//
	// AAdd( aGrpOps , { cCompoNivel , ALLTRIM( SB1->B1_DESC ) , SC2->C2_QUANT * nQtNivel , SC2->C2_QUANT , nQtNivel  ,SB1->B1_UM,'',''  }  )
	
	For I := 1 TO Len(aArray)
		//
		//
		@Li ,   0 PSay Alltrim(aArray[I][1] )    	 				   	// CODIGO PRODUTO
		@li,08 PSay Substr( aArray[I][2],1,45 )
		@Li , 53 psay ' ' +Transform( aArray[I][3]  ,'@E 999,999.9999' ) + '   ' + aArray[I][6] + "  " + Transform( aArray[I][5] ,'@E 99.9999' )
		//
		if len( aArray[I][2] ) > 45
			Li ++
			@li,08 PSay Substr( aArray[I][2],46,45 )
		Endif
		Li++
		//
		@ Li ,  00 PSay __PrtThinLine()
		Li++
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se nao couber, salta para proxima folha                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF li > 55
			Li ++
			@ Li,00 psay PADL(' CONTINUA NA PAGINA ' + ALLTRIM(STR(M_PAG  ) )+ '...' , 80 )
			Li := 0
			CabecOp(Tamanho)		// imprime cabecalho da OP
		EndIF
		
	Next I
	
	
	
	*	m_pag++
	Li := 0					// linha inicial - ejeta automatico
	aArray:={}
	
	dbSelectArea( 'TRBC2' )
	dbSkip()

EndDO
//                              

Roda(cbCont,'CT08      ' ,Tamanho)
//
//
dbSelectArea("SH8")
dbCloseArea()
//
If aReturn[5] = 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return NIL

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ AddAr820 ³ Autor ³ Paulo Boschetti       ³ Data ³ 07/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Adiciona um elemento ao Array                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ AddAr820(ExpN1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Quantidade da estrutura                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function AddAr820(nQuantItem)
Local nNivAtu

// customizando pra atender a Midori
//
NRECB1 := SB1->( RECNO() )
cMainCodB1 := SB1->B1_COD
aCompsG1 := {}
//  Pegando todos os componentes abaixo do codigo principal
//
// O laco abaixo tem como objetivo varrer a estrutura em busca das materias primas para descarga no relatorio
aStruNiv1 := U_Trz_Struct( cMainCodB1 )
cProd := SB1->B1_COD
//       


While .t. // .and. cProd == SB1->B1_COD // Esse laco
	//
	// Essa parte tera duas query´s e uma array que conetera o proximo superior ate chegar no final
	// a Cada Loop, ele pegara quem sao os superiores, gerara a query com todos os itens superiores,
	// gerara  a segunda query com os inferiores e puxara as Materias Primas que tiver
	// Quando acabar , ele sai do loop e volta ao normal
	//
	aPis := {}
	cProds := '' // variavel que contera os produtos raiz
	For nNivAtu := 1 to LEN(aStruNiv1)
		nY:= At( Alltrim( aStruNiv1[ nNivAtu , 1] ) , cProds )
		//
		if ny == 0
			cProds += "'"+Alltrim( aStruNiv1[ nNivAtu , 1] ) + "',"
		Endif
	Next
	cProds := Substr( cProds, 1 , Len( cProds ) - 1 )
	//                                   
	
	cQuerySup := "Select R_E_C_N_O_ as REC  FROM " + RetSqlName('SG1') + " Where G1_FILIAL ='" + xFilial('SG1') + "' And "
	cQuerySup += "D_E_L_E_T_ = ' ' AND G1_COD IN(" + cProds + ") ORder by G1_COD , G1_COMP "
	//                          
//	Alert("cProds: "+cProds+ " cMainCod B1: "+cMainCodB1)
	if Select('TrbSup1') > 0
		DbSelectArea('TrbSup1')
		DbCloseArea()
	Endif
	//
	dbUseArea(.T.,"TOPCONN",TcGenQry(,, cQuerySup ) , 'TrbSup1' , .T. , .T. )
	//
	DbGoTop()
	//
	// Se a tabela estiver vazia, e porque o produto esta no ultimo nivel e deve ser tratado como materia prima
	if eof()
		// 
		cProd := ''           
//		Alert("A tabela está vazia....")		
		cQuerySup := "Select R_E_C_N_O_ as REC  FROM " + RetSqlName('SG1') + " Where G1_FILIAL ='" + xFilial('SG1') + "' And "
		cQuerySup += "D_E_L_E_T_ = ' ' AND G1_COD = '" + cMainCodB1  + "' AND Substring(G1_COMP,1,3) <> 'MOD' AND "
		cQuerySup += "G1_COMP IN(" + cProds + ") ORder by G1_COD , G1_COMP "
		//
		if Select('TrbSup1') > 0
			DbSelectArea('TrbSup1')
			DbCloseArea()
		Endif
		//
		dbUseArea(.T.,"TOPCONN",TcGenQry(,, cQuerySup ) , 'TrbSup1' , .T. , .T. )
		//
		DbGoTop()
		//
	Endif
	//  	 
	While ! eof()
		//
		DbSelectArea('SG1')
		DbGoTo( TrbSup1->REC )
		//
		cCodAtu := SG1->G1_COD // AGREGA O CODIGO ATUAL
		cDescNivelSup := Posicione('SB1',1,  xFilial('SB1') + cCodAtu, 'B1_DESC')
		//
		cCodComp := SG1->G1_COMP
		nQtdComp := sg1->G1_Quant
		//
		SB1->(DbSetORder( 1 ) )
		SB1->( DBSEEK( XFILIAL( 'SB1' ) + cCodComp   ) )
		//
		IF SB1->B1_UM == 'M2' .or. SB1->B1_UM == 'MT'
			nRetPos := Ascan( aArray ,     {|x| x[1] == cCodComp  }        )
			//
			nRtPSup := Ascan( aStruNiv1  ,      {|x| alltrim(x[1]) == alltrim( sg1->g1_cod )  }        )
			//
			nQtdSup := iif( nRtPSup == 0, 1, aStruNiv1[ nRtPSup , 4 ] )
			//
			if nRetPos > 0
				aArray[ nRetPos , 3  ]  += SC2->C2_QUANT * ( nQtdComp * nQtdSup )
				aArray[ nRetPos , 5  ]  += ( nQtdComp * nQtdSup )
			Else
				// AADD( aArray, { cCodAtu , cDescNivelSup , SB1->B1_TIPO,SB1->B1_UM,nQtdComp,  SB1->B1_COD,'','','' } )
				AADD( aArray, { cCodComp , sb1->b1_desc , SC2->C2_QUANT * ( nQtdComp * nQtdSup ) , SC2->C2_QUANT , ( nQtdComp * nQtdSup ) , SB1->B1_UM,'',''  } )
			Endif
			//
		Else
			AaDd(aPis, { cCodComp , ALLTRIM(SB1->B1_DESC) , SB1->B1_UM , SG1->G1_QUANT , SG1->G1_COD} )
			//			
			//
		Endif
		//
		DbSelectArea( 'TRBSUP1' )
		//
		//
//		Alert("Pulando Registro...")
		DbSkip()
	Enddo
	//
	if len( aPis ) == 0
		exit
	Endif
	aStruNiv1 := aPis // igualando a array para agregar o novo nivel superior .
	//                               
                                                                   
Enddo
//
SB1->( dbgoto( NRECB1 )  )
//
Return()
//-------------------------------------
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ MontStruc³ Autor ³ Ary Medeiros          ³ Data ³ 19/10/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta um array com a estrutura do produto                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ MontStruc(ExpC1,ExpN1,ExpN2)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN1 = Quantidade base a ser explodida                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function MontStruc(cOp,nQuant)

dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial()+cOp)

While !Eof() .And. D4_FILIAL+D4_OP == xFilial()+cOp
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no produto desejado                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSeek(xFilial()+SD4->D4_COD)
	If SD4->D4_QUANT > 0 .Or. (lItemNeg .And. SD4->D4_QUANT < 0)
		AddAr820(SD4->D4_QUANT)
	EndIf
	dbSelectArea("SD4")
	dbSkip()
Enddo

dbSetOrder(1)
//
Return
//----------------------------------------------------
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ CabecOp  ³ Autor ³ Paulo Boschetti       ³ Data ³ 07/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta o cabecalho da Ordem de Producao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ CabecOp()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function CabecOp(Tamanho)

// Local cCabec1 := SM0->M0_NOME+STR0010	//"        O R D E M   D E   P R O D U C A O       NRO :"
Local cCabec1 := "          P L A N O   D E  P R O D U Ç Ã O "
Local cCabec2 := "Codigo                               Descricao                  Quantidade  UM.      Padrao"
//
//"CODIGO          DESCRICAO                      QUANTIDADE|UM|PADRAO
// XXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXX.XXX,XXXX | XXX | XXX.XXX,XXXX
// 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                  1                2                3                4               5                7                8

//Local cCabec3 := "                MATERIAIS DO PLANO                    |QUANTIDADE | UM | PADRAO"
//						      012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                                             1                2                3               4                 5                6               7

Local cCabec3 := "                MATERIAIS DO PLANO                      QUANTIDADE   UM   PADRAO"


Local nBegin

If li # 5
	li := 0
Endif
//
Cabec("","" ,"","",Tamanho,18,{ SM0->M0_NOME + ' - '+ SM0->M0_FILIAL +  cCabec1 + '            CT08 -   Pag. ' +TRANSFORM(m_pag,'999')  , ' Emissao: ' + DTOC( dDataBase ) + '                  Numero Plano : '+SC2->C2_OPMIDO   +'                     Núm Protheus: ' + SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)   } , .f. )
//
//
SA1->( DbSetOrder( 1 ) )
SA1->(  DbSeek( xFilial('SA1') +  SC2->C2_CLIENTE + SC2->C2_LOJA  )  )
SB1->(  DbSeek( xFilial('SB1') +  SC2->C2_PRODUTO  )   )
//
if  lPrim
	@ li, 00 psay 'Cliente : ' + SC2->C2_CLIENTE + '/' + SC2->C2_LOJA + '-' + Substr(sa1->A1_NOME,1,28 )
	@ li, 50 psay 'C.N.P.J.: '
	@ li, 60 psay sa1->a1_cgc Picture pesqpict('SA1', 'A1_CGC' )
	Li ++
	//
	@Li,00 PSay 'Modelo: ' + Alltrim(sc2->c2_produto )  +' - ' + Substr( SB1->B1_DESC, 1 , 45  ) // alltrim( aArray[1][1] )  +  " - " +Alltrim(aArray[1][2])	//"Produto: "
	@Li,63 PSay "Qtde. : " + Alltrim( Transform(SC2->C2_QUANT	, '@E 99999999999999' )  ) + iif( sb1->b1_tipo == 'PA', '  KIT',' ' + sb1->b1_UM  )
	//
	Li++
	//
	@Li,00 PSay 'Pedido Cliente : ' + SC2->C2_RELEASE
	@ li,40  Psay 'MES : ' + Substr(    DTOC(SC2->C2_DATPRI) , 4 )
	@ li,55  Psay 'Prev. Emb. : ' +  DTOC( SC2->C2_DATPRF )
	Li ++
	//
	//
	@Li,00  PSay 'Prev. Inicio: '+DTOC(SC2->C2_DATPRI)	//"Prev. : "
	@Li,52 PSay 'Prev. Conclusao: '+DTOC(SC2->C2_DATPRF)	//"Prev. : "
	Li++
	@Li,00 PSay STR0023+SC2->C2_CC				//"C.Custo: "
	@Li,42 PSay STR0024+DTOC(SC2->C2_DATAJI)	//"Ajuste: "
	@Li,62 PSay STR0024+DTOC(SC2->C2_DATAJF)	//"Ajuste: "
	Li++
	If SC2->C2_STATUS == "S"
		@Li,00 PSay STR0025						//"Status: OP Sacramentada"
	ElseIf SC2->C2_STATUS == "U"
		@Li,00 PSay STR0026						//"Status: OP Suspensa"
	ElseIf SC2->C2_STATUS $ " N"
		@Li,00 PSay STR0027						//"Status: OP Normal"
	EndIf
	@Li,42 PSay STR0028							//	"Real  :   /  /      Real  :   /  / "
	Li++

	@Li, 00 Psay "Multiplo Couro: "+Alltrim( Transform(SC2->C2_QTDLOTE	, '@E 99999999999' ) )
	@Li, 42 Psay "Considera lado: "+iif(SC2->C2_LADO=='S', 'SIM','NAO')
	Li++

	
	If !(Empty(SC2->C2_OBS))
		@Li,00 PSay STR0029						//"Observacao: "
		For nBegin := 1 To Len(Alltrim(SC2->C2_OBS)) Step 65
			@li,012 PSay Substr(SC2->C2_OBS,nBegin,65)
			li++
		Next nBegin
	EndIf
	//
//	Li++
	@ li,00 psay 'C O N F E R E N C I A  :'
	lI += 2
	@ LI,00 PSAY '1. ______________________________________________     ______/_______/_________'
	lI += 2
	@ LI,00 PSAY '2. ______________________________________________     ______/_______/_________'
	//
	lPrim    := .F.
Else
	@ LI,00 PSAY 'Continuacao do Plano : ' +  SC2->C2_OPMIDO   +'  Núm Protheus: ' + SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
Endif
// Aqui termina o if
Li++
@Li,00 PSay __PrtFatLine()
//
//
//
//Li++
//@Li,00 PSay cCabec2
Li++
@Li,00 PSay cCabec3
Li++
@Li,00 PSay __PrtFatLine()
Li++
//--------------------------------------------------------------
Static Function AjustaSx1()
//
PutSx1(cPerg,"01","Do Plano "		,"Do Plano "		,"Do Plano "		,"mv_ch1"	,"C"	,20	,0	,0	,"G",,,,,"mv_par01",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg,"02","Ate o  Plano "	,"Ate o  Plano "	,"Ate o  Plano "	,"mv_ch2"	,"C"	,20	,0	,0	,"G",,,,,"mv_par02",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg,"03","Emissao de   "	,"Emissao de   "	,"Emissao de   "	,"mv_ch3"	,"D"	,08	,0	,0	,"G",,,,,"mv_par03",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg,"04","Emissao ate  "	,"Emissao ate  "	,"Emissao ate  "	,"mv_ch4"	,"D"	,08	,0	,0	,"G",,,,,"mv_par04",,,,,,,,,,,,,,,,,,,)
//
Return Nil
//---------------------------------------------------------------------
/*
A funcao abaixo tem como objetivo carregar os grupos de produtos que estao dentro da op
*/
Static Function Carr_GrOPS()
//
aGrpOps := {} // Array contendo os grupos de produtos
//
DbSelectArea('SC2')
DbSeek(xFilial('SC2') + cMainOp )
//
cProdPA := SC2->C2_PRODUTO // Produto principal
//
While ! eof() .and. SC2->C2_FILIAL == xFilial('SC2') .and.  SC2->C2_NUM  == cMainOp
	//
	//
	//if C2_ITEM + C2_SEQUEN == '01001'  // o PRIMEIRO PRODUTO NAO INTERESSA NESSA LISTA
	//Dbskip()
	//Loop
	//Endif
	
	
	//
	cNumSup1 :=  '' // Numero Superior do Lancamento
	cProdPI1    := SC2->C2_PRODUTO // Produto principal
	//
	//IF Alltrim( sc2->C2_UM ) <> 'M2'  .and.  Alltrim( sc2->C2_UM ) <> 'CM'
	IF Alltrim( sc2->C2_UM ) <> 'M2'  // .and.  Alltrim( sc2->C2_UM ) <> 'CM'
		//
		// Posicionando no SG1 pra buscar tanto as quantidades em Pecas quanto as quantidades em Metros quadrados
		// Presuspondo  que o produto sempre se encontre em uma estrutura determinada
		DbSelectArea('SB1')
		DbSeek( xFilial('SB1') + SC2->C2_PRODUTO )
		DbSelectArea('SC2')
		cLadob1           := sb1->b1_lado
		//
		DbSelectArea('SG1')
		DbSetORder(1)
		DbSeek( xFilial( 'SG1' ) + SC2->C2_PRODUTO  )
		nRecNivel      :=  SG1->( Recno() )
		cCompoNivel := SG1->G1_COMP
		DbSelectArea( 'SG1' )
		DbSetORder( 1 )
		DbSeek( xFilial( 'SG1' ) + cCompoNivel  )
		//
		SB1->( DbSeek( xFilial('SB1') + cCompoNivel )  )
		//
		//
		// Descendo a um nivel abaixo
		if !found() .or. SB1->B1_UM == 'M2'
			SG1->(  DbGoTo( nRecNivel )  )
			nQtNivel        := SG1->G1_QUANT
			//
			DbSelectArea('SB1')
			DbSeek( xFilial('SB1') + SG1->G1_COMP  )
			//
			nRetPos := Ascan(  aGrpOps ,     {|x| x[1] == SG1->G1_COMP    }  )
			//
			//
			IF nRetPos == 0
				AAdd( aGrpOps , { cCompoNivel , ALLTRIM( SB1->B1_DESC ) , SC2->C2_QUANT * nQtNivel , SC2->C2_QUANT , nQtNivel  ,SB1->B1_UM,'',''  }  )
			Else
				aGrpOps[ nRetPos , 3  ]  += SC2->C2_QUANT * nQtNivel
				aGrpOps[ nRetPos , 5  ]  += nQtNivel
			Endif
			//
		Endif
		//
	ENDIF
	//
	DbSelectArea('SC2')
	Dbskip()
Enddo
//
aArray := aGrpOps
//
//
Return( aArray )
//------------------------------------------------------------
//
// A breve funcao abaixo tem como objetivo copiar a estrutura de um determinado produto de uma filial para a outra
//
//
User Function  TrcStruP()
Local nNivAtu, j, nn1
//
cEmpAnt := '01'
RpcSetType(3)
RpcSetEnv(cEmpAnt, '10',,,,, { "SG1", "SB1", "SC2" } )
//
aItens  := {}
cFilDe  := '10'
cFilAte := '08'
//
Aadd(aItens,{'011695','010543'})
Aadd(aItens,{'010543','011757'})
Aadd(aItens,{'011757','007789'})
Aadd(aItens,{'010543','011758'})
Aadd(aItens,{'011758','007789'})
Aadd(aItens,{'010543','011759'})
Aadd(aItens,{'011759','007789'})
Aadd(aItens,{'010543','011760'})
Aadd(aItens,{'011760','007789'})
Aadd(aItens,{'010543','011761'})
Aadd(aItens,{'011761','007789'})
Aadd(aItens,{'010543','011762'})
Aadd(aItens,{'011762','007789'})
Aadd(aItens,{'011695','010557'})
Aadd(aItens,{'010557','011763'})
Aadd(aItens,{'011763','007789'})
Aadd(aItens,{'010557','011764'})
Aadd(aItens,{'011764','007789'})
Aadd(aItens,{'010557','011765'})
Aadd(aItens,{'011765','007789'})
Aadd(aItens,{'010557','011766'})
Aadd(aItens,{'011766','007789'})
Aadd(aItens,{'010557','011767'})
Aadd(aItens,{'011767','007789'})
Aadd(aItens,{'010557','011769'})
Aadd(aItens,{'011769','007789'})
Aadd(aItens,{'011695','010558'})
Aadd(aItens,{'010558','011747'})
Aadd(aItens,{'011747','007789'})
Aadd(aItens,{'010558','011748'})
Aadd(aItens,{'011748','007789'})
Aadd(aItens,{'010558','011749'})
Aadd(aItens,{'011749','007789'})
Aadd(aItens,{'010558','011750'})
Aadd(aItens,{'011750','007789'})
Aadd(aItens,{'010558','011751'})
Aadd(aItens,{'011751','007789'})
Aadd(aItens,{'011695','010562'})
Aadd(aItens,{'010562','011752'})
Aadd(aItens,{'011752','007789'})
Aadd(aItens,{'010562','011753'})
Aadd(aItens,{'011753','007789'})
Aadd(aItens,{'010562','011754'})
Aadd(aItens,{'011754','007789'})
Aadd(aItens,{'010562','011755'})
Aadd(aItens,{'011755','007789'})
Aadd(aItens,{'010562','011756'})
Aadd(aItens,{'011756','007789'})
Aadd(aItens,{'011695','010569'})
Aadd(aItens,{'010569','011770'})
Aadd(aItens,{'011770','007789'})
Aadd(aItens,{'010569','011771'})
Aadd(aItens,{'011771','007789'})
Aadd(aItens,{'010569','011772'})
Aadd(aItens,{'011772','007789'})
Aadd(aItens,{'010569','011773'})
Aadd(aItens,{'011773','007789'})
Aadd(aItens,{'010569','011774'})
Aadd(aItens,{'011774','007789'})
Aadd(aItens,{'010569','011775'})
Aadd(aItens,{'011775','007789'})
Aadd(aItens,{'011695','013740'})
Aadd(aItens,{'013740','011780'})
Aadd(aItens,{'011780','007789'})
Aadd(aItens,{'013740','011782'})
Aadd(aItens,{'011782','007789'})
Aadd(aItens,{'013740','011804'})
Aadd(aItens,{'011804','007789'})
Aadd(aItens,{'011695','013742'})
Aadd(aItens,{'013742','011776'})
Aadd(aItens,{'011776','007789'})
Aadd(aItens,{'013742','011778'})
Aadd(aItens,{'011778','007789'})
Aadd(aItens,{'013742','011802'})
Aadd(aItens,{'011802','007789'})
//
aStr1 := SG1->( DbStruct()  ) // Estrutura do Alias
_cTmpSql  := CriaTrab( aStr1 , .T. )
//
if select("TMPREC") > 0
	DbCloseArea("TMPREC")
Endif
//
DBUSEAREA(.T.,,_cTmpSql,"TMPREC")
//
//
For nn1 := 1 to len(aItens)
	cQuery := "Select * from " + RetSqlName('SG1') + " where D_E_L_E_T_=' ' AND  G1_FILIAL='10'  and "
	cQuery += " G1_COD ='"+ aItens[nn1,1] + "' And G1_COMP = '"+ aItens[nn1,2] + "' "
	//
	if select('G1ORIG') > 0
		DbSelectArea('G1ORIG')
		DbCloseArea()
	Endif
	//
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), 'G1ORIG' ,.T.,.T.)
	//
	DbSelectArea( 'G1ORIG' )
	While ! eof()
		DbSelectArea('TMPREC')
		Reclock( 'TMPREC', .T. )
		FOR j :=1 TO Len(  aStr1  )
			cCp   	:= Astr1[ j , 1 ]
			//
			cCpnf 	:= 'G1ORIG->' + cCp
			//
			if substr( Astr1[ j , 1 ], 4,2 ) <> 'MS'
				IF Astr1[ j , 2 ] <> 'D'
					if Alltrim(  Astr1[ j , 1 ] ) <> 'G1_FILIAL'
						&cCp	:= &cCpnf
					Else
						&cCp	:= '08'
					Endif
					
				Else
					&cCp	:=  cTod(  substr( &cCpnf , 7,2 ) + '/' + substr( &cCpnf , 5,2 ) + '/' + substr( &cCpnf , 1,4 )  )
				Endif
			Endif
		NEXT
		//
		MsUnlock()
		//
		DbSelectArea('G1ORIG')
		DbSkip()
	Enddo
Next
//
DbSelectArea('G1ORIG')
DbCloseArea()
//
DbSelectArea('TMPREC')
DbCloseArea()
//
if file('IMP1.DBF')
	fErase( 'IMP1.DBF' )
Endif
//
fRename( _cTmpSql + '.dbf', 'IMP1.DBF' )
//
U_VoltEstr()
//
Return()
//
//-------------------------------------------------
//
User Function VoltEstr()
Local j
/*
cEmpAnt := '01'
RpcSetType(3)
RpcSetEnv(cEmpAnt, '08',,,,, { "SG1", "SB1", "SC2" } )
*/
//
aItens  := {}
cFilDe  := '10'
cFilAte := '08'
//
if select("TMPREC") > 0
	DbCloseArea("TMPREC")
Endif
//
DBUSEAREA(.T.,,'IMP1.DBF' ,"TMPREC")
aStr1 := DbStruct()
//
DbGoTop()
While !eof()
	//
	cQuery := "Select * from " + RetSqlName('SG1') + " where D_E_L_E_T_=' ' AND  G1_FILIAL='08'  and "
	cQuery += " G1_COD ='"+ TMPREC->G1_COD + "' And G1_COMP = '"+ TMPREC->G1_COMP + "' "
	//
	if select('G1DEST') > 0
		DbSelectArea('G1DEST')
		DbCloseArea()
	Endif
	//
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), 'G1DEST' ,.T.,.T.)
	//
	IF EOF()
		DbSelectArea('SG1')
		Reclock( 'SG1', .T. )
		FOR j :=1 TO Len(  aStr1  )
			cCp   	:= Astr1[ j , 1 ]
			//
			cCpnf 	:= 'TMPREC->' + cCp
			//
			&cCp	:= &cCpnf
			/*
			if substr( Astr1[ j , 1 ], 4,2 ) <> 'MS'
			IF Astr1[ j , 2 ] <> 'D'
			&cCp	:= &cCpnf
			Else
			&cCp	:=  cTod(  substr( &cCpnf , 7,2 ) + '/' + substr( &cCpnf , 5,2 ) + '/' + substr( &cCpnf , 1,4 )  )
			Endif
			Endif
			*/
		NEXT
		//
		MsUnlock()
		//
	EndIF
	
	DbSelectArea('TMPREC')
	DbSkip()
Enddo
//
Return()
//------------------------------------------
User Function AlimB1Lado()
Local nn1
//
//
cEmpAnt := '01'
RpcSetType(3)
RpcSetEnv(cEmpAnt, '08',,,,, { "SB1", "SC2" } )
//
aItens  := {}
//
Aadd(aItens,{'011723','B'})
Aadd(aItens,{'011724','B'})
Aadd(aItens,{'011725','B'})
Aadd(aItens,{'011726','B'})
Aadd(aItens,{'011727','B'})
Aadd(aItens,{'011728','B'})
Aadd(aItens,{'011729','A'})
Aadd(aItens,{'011730','A'})
Aadd(aItens,{'011731','A'})
Aadd(aItens,{'011732','A'})
Aadd(aItens,{'011733','A'})
Aadd(aItens,{'011734','A'})
Aadd(aItens,{'011713','B'})
Aadd(aItens,{'011714','B'})
Aadd(aItens,{'011715','B'})
Aadd(aItens,{'011716','B'})
Aadd(aItens,{'011717','B'})
Aadd(aItens,{'011718','A'})
Aadd(aItens,{'011719','A'})
Aadd(aItens,{'011720','A'})
Aadd(aItens,{'011721','A'})
Aadd(aItens,{'011722','A'})
Aadd(aItens,{'011741','B'})
Aadd(aItens,{'011742','B'})
Aadd(aItens,{'011803','B'})
Aadd(aItens,{'011744','A'})
Aadd(aItens,{'011745','A'})
Aadd(aItens,{'011805','A'})
Aadd(aItens,{'011735','A'})
Aadd(aItens,{'011736','B'})
Aadd(aItens,{'011737','A'})
Aadd(aItens,{'011738','B'})
Aadd(aItens,{'011739','A'})
Aadd(aItens,{'011740','B'})
Aadd(aItens,{'011723','B'})
Aadd(aItens,{'011724','B'})
Aadd(aItens,{'011725','B'})
Aadd(aItens,{'011726','B'})
Aadd(aItens,{'011727','B'})
Aadd(aItens,{'011728','B'})
Aadd(aItens,{'011729','A'})
Aadd(aItens,{'011730','A'})
Aadd(aItens,{'011731','A'})
Aadd(aItens,{'011732','A'})
Aadd(aItens,{'011733','A'})
Aadd(aItens,{'011734','A'})
Aadd(aItens,{'011713','B'})
Aadd(aItens,{'011714','B'})
Aadd(aItens,{'011715','B'})
Aadd(aItens,{'011716','B'})
Aadd(aItens,{'011717','B'})
Aadd(aItens,{'011718','A'})
Aadd(aItens,{'011719','A'})
Aadd(aItens,{'011720','A'})
Aadd(aItens,{'011721','A'})
Aadd(aItens,{'011722','A'})
Aadd(aItens,{'011741','B'})
Aadd(aItens,{'011742','B'})
Aadd(aItens,{'011743','B'})
Aadd(aItens,{'011744','A'})
Aadd(aItens,{'011745','A'})
Aadd(aItens,{'011746','A'})
Aadd(aItens,{'011735','A'})
Aadd(aItens,{'011736','B'})
Aadd(aItens,{'011737','A'})
Aadd(aItens,{'011738','B'})
Aadd(aItens,{'011739','A'})
Aadd(aItens,{'011740','B'})
//
DbSelectArea('SB1')
DbSetOrder(1)
//
nPRoc := 0
For nn1 := 1 to len(aItens)
	if DbSeek( xFilial('SB1') + aItens[nn1,1] )
		Reclock('SB1', .f. )
		Replace b1_lado with aItens[nn1,2]
		MsUnlock()
		nPRoc ++
	Endif
Next
//
alert( 'processamento concluido com sucesso.' + str( nPRoc  ) )
//
Return()
//----------------------------------------
User Function AlimB2FIL8()
//
//
cEmpAnt := '01'
RpcSetType(3)
RpcSetEnv(cEmpAnt, '08',,,,, { "SB1", "SB2" } )
//
aItens  := {}
//
cQuery := 'Select B1_COD FROM ' + RETSQLNAME('SB1') + " WHERE D_E_L_E_T_ = ' ' AND B1_TIPO = 'MO' "
//
if select('TRBB2') > 0
	DbSelectArea( 'TRBB2' )
	DbCloseArea()
Endif
//
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBB2',.T.,.T. )
//
DbGoTop()
While !eof()
	DbSelectArea('SB2')
	//
	if DbSeek( xFilial('SB2') + TRBB2->B1_COD + '01' )
		Reclock('SB2',.f.)
		Replace B2_QATU WITH 1000000
		MsUnlock()
	Endif
	//
	DbSelectArea( 'TRBB2' )
	DbSkip()
Enddo
//
alert( 'processamento concluido com sucesso.')
//
Return()
//-----------------------------------------------------------
// A funcao abaixo tem como objetivo montar a estrutura de cada item para explosao no sistema
User Function Trz_Struct( CodPRoduto )
//
aPRodsRet := {}
cQuery := "Select R_E_C_N_O_ as REC from " + RetSqlName('SG1') +  " Where D_E_L_E_T_ = ' ' AND G1_FILIAL ='"+ xFilial('SG1') + "' "
cQuery += " and G1_COD = '" + CodPRoduto + "'"
//
if Select('TrbNiv') > 0
	DbSelectArea('TrbNiv')
	DbCloseArea()
Endif
//
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery) , 'TrbNiv' , .T. , .T. )
//
DbGoTop()
While ! eof()
	//
	DbSelectArea('SG1')
	DbGoTo( TrbNiv->REC )
	//
	cLadob1           := iif( !empty(sb1->b1_lado), sb1->b1_lado, 'A' )
	nCodAtu := SG1->G1_COD
	// if DbSeek( xFilial('SG1') +  nCodAtu  )
	//	While ! eof() .and. G1_FILIAL == XFILIAL('SG1') .AND. G1_COD == nCodAtu
	//
	SB1->( DBSEEK( XFILIAL( 'SB1' ) + SG1->G1_COMP   )  )
	//
	AAdd( aPRodsRet, { SG1->G1_COMP , ALLTRIM(SB1->B1_DESC) , SB1->B1_UM , SG1->G1_QUANT  } )
	//
	//		DbSkip()
	//	Enddo
	//
	// Endif
	DbSelectArea( 'TrbNiv' )
	DbSkip()
Enddo
Return( aPRodsRet )
//------------------------------------------
User Function AlimB8()
//
//
cEmpAnt := '01'
RpcSetType(3)
RpcSetEnv(cEmpAnt, '09',,,,, { "SB1", "SD5" } )
//
//
DbSelectArea('SD5')
DbSetOrder(1)
//
RECLOCK('SD5', .T.)
//
D5_FILIAL   := XFILIAL('SD5')
D5_PRODUTO  := '016304'
D5_LOCAL    := '01'
D5_DOC		:= '000001169'
D5_SERIE	:= '1'
D5_DATA		:= CTOD('02/12/2010')
D5_ORIGLAN	:= '006'
D5_NUMSEQ	:= Proxnum()
D5_QUANT	:= 1241.83
D5_LOTECTL	:= 'QP69041210'
D5_DTVALID	:= CTOD('21/12/2011')
//
MSUNLOCK()
//
alert( 'processamento concluido com sucesso.' + str( nPRoc  ) )
//
Return()
//----------------------------------------
//
// A funcao abaixo arruma os codigos para Barbosa, eliminando as ops neles contidas
//
User Function AjCodBsa()
//
// aCods := {'001949','0019471','001941','006064'}
//
// Primeiro passo: Buscar todos os produtos que utilizam esses codigos
// Segundo passo: Descobrir todas as OP´s para os Produtos Intermediarios
// Terceiro passo: buscar todos os empenhos que utilizam os produtos em pauta
// Quarto passo: Excluir todos os empenhos em pauta
// Quinto passo: Excluir todas as OPS em Pauta
//
//
cEmpAnt := '01'
RpcSetType(3)
RpcSetEnv(cEmpAnt, '08',,,,, { "SB1", "SG1" } )
//
cQuery := "Select R_E_C_N_O_ AS REC FROM " + RetsqlName('SG1')+ " WITH(NOLOCK) WHERE G1_FILIAL ='" + xFilial('SG1') + "' AND "
cQuery += "G1_COMP IN('001949','001947','001941','006064') AND D_E_L_E_T_ = ' ' ORDER BY G1_COMP"
//
//
If Select("TRBG1") > 0
	DbSelectArea( "TRBG1" )
	DbCloseArea()
Endif
//
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBG1",.T.,.T.)
//
DbGoTop()
While !eof()
	//
	DbSelectArea('SG1')
	DbGoTo( TRBG1->REC )
	//
	// O bloco abaixo busca as OPs Abertas e ainda nao encerradas para a exclusao posterior
	//
	cQueryC2 := "Select R_E_C_N_O_ AS REC FROM " + RetsqlName('SC2')+ " WITH(NOLOCK) WHERE C2_FILIAL ='" + xFilial('SC2') + "' AND "
	cQueryC2 += "C2_PRODUTO = '" + SG1->G1_COD  + "' AND C2_DATRF = '' AND D_E_L_E_T_ = ' ' "
	//
	If Select("TRBC2") > 0
		DbSelectArea( "TRBC2" )
		DbCloseArea()
	Endif
	//
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryC2),"TRBC2",.T.,.T.)
	//
	DbGoTop()
	WHILE ! EOF()
		//
		DbSelectArea('SC2')
		DbGoTo( TRBC2->REC )
		//
		DbSelectarea('SD4')
		DbSetORder(1)
		//
		// O BLOCO ABAIXO BUSCA OS EMPENHOS PARA DELETA-LOS CASO ENCONTRE ALGUM NESSA SITUACAO
		IF DBSEEK( XFILIAL('SD4') + SG1->G1_COMP + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN   )
			RECLOCK('SD4')
			DBDELETE()
			MSUNLOCK()
		ENDIF
		//
		DBSELECTAREA('SC2')
		RECLOCK('SC2',.F.)
		DBDELETE()
		MSUNLOCK()
		//
		DBSELECTAREA('TRBC2')
		DBSKIP()
		//
	ENDDO
	//
	
	//
	DbSelectArea( "TRBG1" )
	DbsKip()
Enddo
//
//
alert( 'processamento concluido com sucesso.' )
//
Return()
//----------------------------------------
//
// A funcao abaixo tem como objetivo limpar as OPs para a unidade Uberaba
//
user function ACUBAC2()
Local nn1
cEmpAnt := '01'
RpcSetType(3)
RpcSetEnv(cEmpAnt, '10',,,,, { "SC2","SD4","SD3" } )
//
//
aops := {}
Aadd( aops,{'01021601012',0,0})
Aadd( aops,{'00002701001',0,0})
Aadd( aops,{'00007801001',0,0})
Aadd( aops,{'00008101001',0,0})
Aadd( aops,{'00012101001',0,0})

/*
Aadd( aops,{'00013901001',440,440})
Aadd( aops,{'00014501001',440,440})
Aadd( aops,{'00018001001',440,440})
Aadd( aops,{'00022101001',440,440})
Aadd( aops,{'00028601001',440,440})
Aadd( aops,{'00026001001',440,440})
Aadd( aops,{'00033301001',440,440})
Aadd( aops,{'00038601001',440,440})
Aadd( aops,{'00039001001',440,440})
Aadd( aops,{'00033201001',440,440})
Aadd( aops,{'00048001001',440,440})
Aadd( aops,{'00048301001',440,440})
Aadd( aops,{'00050301001',440,440})
Aadd( aops,{'00050401001',440,440})
Aadd( aops,{'00051001001',440,440})
Aadd( aops,{'00052301001',440,440})
Aadd( aops,{'00052401001',440,440})
Aadd( aops,{'00052501001',440,440})
Aadd( aops,{'00052601001',440,440})
Aadd( aops,{'00054101001',440,440})
Aadd( aops,{'00050801001',440,440})
Aadd( aops,{'00052001001',440,440})
Aadd( aops,{'00058801001',440,440})
Aadd( aops,{'00062401001',440,440})
Aadd( aops,{'00061901001',440,440})
Aadd( aops,{'00064801001',440,440})
Aadd( aops,{'00064901001',440,440})
Aadd( aops,{'00067001001',440,440})
Aadd( aops,{'00071301001',440,440})
Aadd( aops,{'00072601001',440,49.66})
Aadd( aops,{'00068501001',440,440})
Aadd( aops,{'00074301001',440,440})
Aadd( aops,{'00074901001',440,440})
Aadd( aops,{'00074701001',440,440})
Aadd( aops,{'00074801001',440,440})
Aadd( aops,{'00073601001',440,440})
Aadd( aops,{'00081301001',4440,3981.56})
Aadd( aops,{'00082401001',440,440})
Aadd( aops,{'00082501001',440,440})
Aadd( aops,{'00082601001',440,440})
Aadd( aops,{'00082101001',440,17.73})
Aadd( aops,{'00084901001',440,440})
Aadd( aops,{'00078101001',440,440})
Aadd( aops,{'00078501001',440,440})
Aadd( aops,{'00086201001',440,440})
Aadd( aops,{'00085701001',440,440})
Aadd( aops,{'00085801001',440,440})
Aadd( aops,{'00085301001',440,440})
Aadd( aops,{'00081701001',440,440})
Aadd( aops,{'00087701001',440,440})
Aadd( aops,{'00087801001',440,440})
Aadd( aops,{'00088201001',440,440})
Aadd( aops,{'00088301001',440,4.55})
Aadd( aops,{'00083901001',440,440})
Aadd( aops,{'00086301001',440,440})
Aadd( aops,{'00090101001',440,37.04})
Aadd( aops,{'00086401001',440,440})
Aadd( aops,{'00092301001',440,440})
Aadd( aops,{'00092401001',440,440})
Aadd( aops,{'00091601001',440,440})
Aadd( aops,{'00091901001',440,440})
Aadd( aops,{'00092101001',440,440})
Aadd( aops,{'00085201001',440,440})
Aadd( aops,{'00093201001',440,440})
Aadd( aops,{'00093301001',440,440})
Aadd( aops,{'00092601001',440,440})
Aadd( aops,{'00088901001',440,440})
Aadd( aops,{'00093901001',440,27.15})
Aadd( aops,{'00094101001',440,440})
Aadd( aops,{'00094201001',440,142.31})
Aadd( aops,{'00094501001',440,440})
Aadd( aops,{'00094601001',440,440})
Aadd( aops,{'00094701001',440,440})
Aadd( aops,{'00094801001',440,440})
Aadd( aops,{'00095701001',440,163.12})
Aadd( aops,{'00090901001',440,440})
Aadd( aops,{'00096001001',440,440})
Aadd( aops,{'00095401001',440,440})
Aadd( aops,{'00095201001',440,440})
Aadd( aops,{'00095301001',440,440})
Aadd( aops,{'00095101001',440,440})
Aadd( aops,{'00096701001',440,440})
Aadd( aops,{'00097201001',440,440})
Aadd( aops,{'00097301001',440,440})
Aadd( aops,{'00097501001',440,440})
Aadd( aops,{'00095001001',440,440})
Aadd( aops,{'00093801001',440,440})
Aadd( aops,{'00099501001',440,440})
Aadd( aops,{'00099601001',440,440})
Aadd( aops,{'00098301001',440,440})
Aadd( aops,{'00098501001',440,440})
Aadd( aops,{'00098701001',440,440})
Aadd( aops,{'00098901001',440,440})
Aadd( aops,{'00092701001',440,440})
Aadd( aops,{'00092801001',440,440})
Aadd( aops,{'00094901001',440,440})
Aadd( aops,{'00100601001',440,440})
Aadd( aops,{'00096801001',440,440})
Aadd( aops,{'00102301001',440,31.44})
Aadd( aops,{'00105301001',440,98.11})
Aadd( aops,{'00104301001',440,126.16})
Aadd( aops,{'00108601001',440,440})
Aadd( aops,{'00110301001',440,4.37})
Aadd( aops,{'00109201001',440,440})
Aadd( aops,{'00111601001',440,84.11})
Aadd( aops,{'00113301001',440,29.7})
Aadd( aops,{'00112301001',440,52.86})
Aadd( aops,{'00111101001',440,440})
Aadd( aops,{'00111201001',440,440})
Aadd( aops,{'00115601001',440,440})
Aadd( aops,{'00115101001',440,10.84})
Aadd( aops,{'00114701001',440,13.2})
Aadd( aops,{'00109501001',440,440})
Aadd( aops,{'00118101001',440,440})
Aadd( aops,{'00113501001',440,440})
Aadd( aops,{'00117501001',440,14.02})
Aadd( aops,{'00117601001',440,0,65})
Aadd( aops,{'00117301001',440,275.69})
Aadd( aops,{'00119301001',440,440})
Aadd( aops,{'00119401001',440,440})
Aadd( aops,{'00113801001',440,440})
Aadd( aops,{'00117001001',440,440})
Aadd( aops,{'00120801001',440,440})
Aadd( aops,{'00115901001',440,440})
Aadd( aops,{'00116001001',440,440})
Aadd( aops,{'00121201001',440,440})
Aadd( aops,{'00115701001',440,440})
Aadd( aops,{'00115801001',440,440})
Aadd( aops,{'00120101001',440,29.44})
Aadd( aops,{'00120301001',440,440})
Aadd( aops,{'00121001001',440,440})
Aadd( aops,{'00116501001',440,440})
Aadd( aops,{'00116301001',440,7.92})
Aadd( aops,{'00121801001',440,440})
Aadd( aops,{'00120701001',440,440})
Aadd( aops,{'00123001001',440,440})
Aadd( aops,{'00123101001',440,440})
Aadd( aops,{'00120401001',440,440})
Aadd( aops,{'00120501001',440,440})
Aadd( aops,{'00122401001',440,440})
Aadd( aops,{'00122501001',440,440})
Aadd( aops,{'00122101001',440,440})
Aadd( aops,{'00122201001',440,440})
Aadd( aops,{'00122301001',440,440})
Aadd( aops,{'00118601001',440,440})
Aadd( aops,{'00118701001',440,440})
Aadd( aops,{'00123501001',440,440})
Aadd( aops,{'00123601001',440,440})
Aadd( aops,{'00123701001',440,440})
Aadd( aops,{'00123801001',440,440})
Aadd( aops,{'00123901001',440,440})
Aadd( aops,{'00124001001',440,440})
Aadd( aops,{'00124101001',440,440})
Aadd( aops,{'00124201001',440,440})
Aadd( aops,{'00124301001',440,440})
Aadd( aops,{'00117701001',440,440})
Aadd( aops,{'00118401001',440,440})
Aadd( aops,{'00125601001',440,440})
Aadd( aops,{'00121501001',440,440})
Aadd( aops,{'00125701001',440,440})
Aadd( aops,{'00125801001',440,440})
Aadd( aops,{'00125001001',440,440})
Aadd( aops,{'00124501001',440,440})
Aadd( aops,{'00125101001',440,440})
Aadd( aops,{'00124701001',440,440})
Aadd( aops,{'00124801001',440,440})
Aadd( aops,{'00126201001',440,440})
Aadd( aops,{'0012633 001',440,356.57})
Aadd( aops,{'00121701001',440,432,3})
Aadd( aops,{'00121601001',440,440})
Aadd( aops,{'00119501001',440,440})
Aadd( aops,{'00128201001',440,440})
Aadd( aops,{'00128301001',440,142.37})
Aadd( aops,{'00122701001',440,440})
Aadd( aops,{'00122801001',440,440})
Aadd( aops,{'00127401001',440,440})
Aadd( aops,{'00127501001',440,440})
Aadd( aops,{'00127101001',440,440})
Aadd( aops,{'00128001001',440,440})
Aadd( aops,{'00123301001',440,440})
Aadd( aops,{'00123401001',440,440})
Aadd( aops,{'00129401001',440,440})
Aadd( aops,{'00122601001',440,440})
Aadd( aops,{'00130301001',440,440})
Aadd( aops,{'00125501001',440,21.17})
Aadd( aops,{'00129501001',440,440})
Aadd( aops,{'00129801001',440,440})
Aadd( aops,{'00131701001',440,440})
Aadd( aops,{'00133001001',440,440})
Aadd( aops,{'00133101001',440,440})
Aadd( aops,{'00133201001',440,440})
Aadd( aops,{'00127701001',440,440})
Aadd( aops,{'00127801001',440,440})
Aadd( aops,{'00127901001',440,440})
Aadd( aops,{'00132301001',440,440})
Aadd( aops,{'00132001001',440,440})
Aadd( aops,{'00132101001',440,440})
Aadd( aops,{'00128601001',440,440})
Aadd( aops,{'00133801001',440,440})
Aadd( aops,{'00134001001',440,440})
Aadd( aops,{'00134101001',440,440})
Aadd( aops,{'00134201001',440,440})
Aadd( aops,{'00134301001',440,440})
Aadd( aops,{'00127601001',440,33.83})
Aadd( aops,{'00135301001',440,440})
Aadd( aops,{'00134701001',440,440})
Aadd( aops,{'00134801001',440,440})
Aadd( aops,{'00135201001',440,440})
Aadd( aops,{'00136401001',440,440})
Aadd( aops,{'00136501001',440,440})
Aadd( aops,{'00135801001',440,440})
Aadd( aops,{'00135901001',440,440})
Aadd( aops,{'00136001001',440,440})
Aadd( aops,{'00136101001',440,440})
Aadd( aops,{'00130101001',440,26.22})
Aadd( aops,{'00137601001',440,375.46})
Aadd( aops,{'00138801001',440,440})
Aadd( aops,{'00132401001',440,440})
Aadd( aops,{'00140401001',440,385.12})
Aadd( aops,{'00140601001',440,65.59})
Aadd( aops,{'00139701001',440,9.89})
Aadd( aops,{'00141901001',440,440})
Aadd( aops,{'00142701001',440,440})
Aadd( aops,{'00143801001',440,440})
Aadd( aops,{'00144101001',440,440})
Aadd( aops,{'00144201001',440,440})
Aadd( aops,{'00193301001',200,200})
Aadd( aops,{'00196301001',200,200})
Aadd( aops,{'00197201001',200,200})
Aadd( aops,{'00193701001',200,200})
Aadd( aops,{'00159001001',200,200})
Aadd( aops,{'00161401001',200,200})
Aadd( aops,{'00161701001',200,200})
Aadd( aops,{'00161801001',200,200})
Aadd( aops,{'00161901001',200,200})
Aadd( aops,{'00162101001',200,200})
Aadd( aops,{'00160401001',200,200})
Aadd( aops,{'00200901001',200,200})
Aadd( aops,{'00224001001',200,5})
Aadd( aops,{'00239001001',200,200})
Aadd( aops,{'00242301001',200,200})
Aadd( aops,{'00244401001',200,200})
Aadd( aops,{'00249201001',200,200})
Aadd( aops,{'00249301001',200,200})
Aadd( aops,{'00253401001',200,200})
Aadd( aops,{'00252201001',200,200})
Aadd( aops,{'00252301001',200,200})
Aadd( aops,{'00255301001',200,200})
Aadd( aops,{'00258401001',200,200})
Aadd( aops,{'00258501001',200,200})
Aadd( aops,{'00290001001',200,200})
Aadd( aops,{'00961501001',200,34})
Aadd( aops,{'00976501001',30,1})
Aadd( aops,{'00975401001',220,26})
Aadd( aops,{'00996101001',100,55})
Aadd( aops,{'01022201001',150,150})
Aadd( aops,{'01024801001',200,98})
Aadd( aops,{'01025601001',200,111})
Aadd( aops,{'01040801001',200,159})
Aadd( aops,{'01033801001',200,155})
Aadd( aops,{'01031501001',200,86})
Aadd( aops,{'01032901001',200,151})
Aadd( aops,{'01035401001',200,2})
Aadd( aops,{'01031801001',200,47})
Aadd( aops,{'01043301001',220,220})
Aadd( aops,{'01038801001',200,200})
Aadd( aops,{'01038901001',200,8})
Aadd( aops,{'01047001001',220,220})
Aadd( aops,{'01047101001',220,6})
Aadd( aops,{'01053201001',220,10})
Aadd( aops,{'01048901001',200,6})
Aadd( aops,{'01054901001',220,44})
Aadd( aops,{'01055201001',220,12})
Aadd( aops,{'01055701001',200,4})
Aadd( aops,{'01053901001',200,2})
Aadd( aops,{'01060801001',220,1})
Aadd( aops,{'01055601001',200,200})
Aadd( aops,{'01061701001',200,129})
Aadd( aops,{'01061801001',200,200})
Aadd( aops,{'01062001001',200,102})
Aadd( aops,{'01069301001',220,9})
Aadd( aops,{'01069401001',220,220})
Aadd( aops,{'01069701001',220,142})
Aadd( aops,{'01069901001',220,7})
Aadd( aops,{'01070001001',220,220})
Aadd( aops,{'01064701001',100,72})
Aadd( aops,{'01070801001',220,82})
Aadd( aops,{'01071001001',220,220})
Aadd( aops,{'01071401001',220,124})
Aadd( aops,{'01071501001',220,220})
Aadd( aops,{'01071601001',220,220})
Aadd( aops,{'01072101001',220,41})
Aadd( aops,{'01070901001',220,3})
Aadd( aops,{'01066801001',220,3})
Aadd( aops,{'01073201001',220,47})
Aadd( aops,{'01073001001',220,220})
Aadd( aops,{'01073101001',220,220})
Aadd( aops,{'01072701001',220,220})
Aadd( aops,{'01070401001',200,76})
Aadd( aops,{'01070601001',200,185})
Aadd( aops,{'01074101001',220,220})
Aadd( aops,{'01074201001',220,220})
Aadd( aops,{'01083501001',220,220})
Aadd( aops,{'01074701001',110,22})
Aadd( aops,{'01073901001',220,220})
Aadd( aops,{'01074001001',220,220})
Aadd( aops,{'01075601001',220,167})
Aadd( aops,{'01075701001',220,220})
Aadd( aops,{'01075801001',220,220})
Aadd( aops,{'01075901001',220,220})
Aadd( aops,{'01074501001',200,38})
Aadd( aops,{'01079301001',10,10})
Aadd( aops,{'01077601001',110,110})
Aadd( aops,{'01077701001',110,110})
Aadd( aops,{'01077801001',110,110})
Aadd( aops,{'01077901001',110,110})
Aadd( aops,{'01075001001',200,200})
Aadd( aops,{'01075101001',200,200})
Aadd( aops,{'01075201001',200,200})
Aadd( aops,{'01075301001',200,200})
Aadd( aops,{'01078901001',220,157})
Aadd( aops,{'01079001001',220,220})
Aadd( aops,{'01079101001',220,220})
Aadd( aops,{'01079401001',90,90})
Aadd( aops,{'01081201001',220,220})
Aadd( aops,{'01083401001',220,220})
Aadd( aops,{'01076301001',200,200})
Aadd( aops,{'01076401001',200,200})
Aadd( aops,{'01076501001',200,200})
Aadd( aops,{'01076601001',200,200})
Aadd( aops,{'01076701001',200,200})
Aadd( aops,{'01076801001',200,200})
Aadd( aops,{'01077201001',100,100})
Aadd( aops,{'01081801001',220,220})
Aadd( aops,{'01081901001',220,220})
Aadd( aops,{'01082001001',220,220})
Aadd( aops,{'01076901001',220,220})
Aadd( aops,{'01077001001',220,220})
Aadd( aops,{'01076001001',200,200})
Aadd( aops,{'01076101001',200,200})
Aadd( aops,{'01076201001',200,200})
Aadd( aops,{'01080301001',110,104})
Aadd( aops,{'01078101001',200,200})
Aadd( aops,{'01078201001',200,200})
Aadd( aops,{'01078301001',200,200})
Aadd( aops,{'01078401001',200,200})
Aadd( aops,{'01078501001',200,200})
Aadd( aops,{'01078801001',200,200})
Aadd( aops,{'01077401001',200,200})
Aadd( aops,{'01077501001',200,200})
Aadd( aops,{'01081301001',200,200})
Aadd( aops,{'01081401001',200,200})
Aadd( aops,{'01083601001',200,200})
Aadd( aops,{'01083701001',200,200})
Aadd( aops,{'01083801001',200,200})
Aadd( aops,{'01083901001',200,200})

*/
//
// o Bloco abaixo varrera a op pra saber o que fazer com cada registro
//
For nn1 := 1 to len( aops )
	// primeiro bloco : Verificar os Empenhos - SD4
	// SEgundo Bloco: Verificar se Houve Movimentacoes de APontamento - SD3
	// TErceiro Bloco: Verifiar e Encerrar / eliminar as OPs
	DbSelectArea('SC2')
	DbSetORder(1)
	if DbSeek(xFilial('SC2') + substr( aops[ nn1 , 1 ] ,1 ,6 )  )
		//
		While !eof() .and. C2_FILIAL == XFILIAL('SC2') .AND.   C2_NUM == substr( aops[ nn1 , 1 ] ,1 ,6 )
			DbSelectArea('SD4')
			DbSetORder( 2 )
			if DbSeek( xFilial('SD4') + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN  )
				While !eof() .and. D4_FILIAL == XFILIAL('SD4') .AND. alltrim(D4_OP) == alltrim(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)
					if D4_QUANT  == 0 // SE AINDA NAO HOUVE QUALQUER LANCAMENTO PRA ABATIMENTO
						RECLOCK('SD4', .F.)
						DBDELETE()
						MSUNLOCK()
						//
					ELSE
						RECLOCK('SD4', .F.)
						Replace D4_QUANT WITH D4_QTDEORI
						MSUNLOCK()
					Endif
					DbSkip()
				Enddo
			Endif
			//
			// SEgundo bloco: Encerrando a OP
			DbSelectArea('SC2')
			//
			Reclock('SC2',.f.)
			IF C2_QUJE > 0
				REPLACE C2_DATRF	WITH C2_EMISSAO
			ELSE
				DBDELETE()
			ENDIF
			MsUnlock()
			//
			DbSelectArea('SC2')
			DbSkip()
		Enddo
	Endif
Next
//
ALERT('PROCESSAMENTO CONCLUIDO COM SUCESSO ! ')
//
RETURN()
//--------------------------------------------------------
USer Function GRVInvent()
Local nn2, nn1
//
cEmpAnt := '01'
RpcSetType(3)
RpcSetEnv(cEmpAnt, '10',,,,, { "SB1", "SB7" } )
//
aInvent := {}
lMsErroAuto := .F.
//
aProds := {} // Array que contera os produtos
//
Aadd(aprods,{'147','02',219.91})
Aadd(aprods,{'199','02',16.31})
Aadd(aprods,{'2934','02',481.7})
Aadd(aprods,{'2941','02',834.37})
Aadd(aprods,{'3014','02',1238.35})
Aadd(aprods,{'3015','02',440.48})
Aadd(aprods,{'3072','02',598.25})
Aadd(aprods,{'3073','02',46.58})
Aadd(aprods,{'3075','02',279.04})
Aadd(aprods,{'3080','02',129})
Aadd(aprods,{'3084','02',781.64})
Aadd(aprods,{'3085','02',1.09})
Aadd(aprods,{'3086','02',311.65})
Aadd(aprods,{'3087','02',767.29})
Aadd(aprods,{'3088','02',424.08})
Aadd(aprods,{'3109','02',42.5})
Aadd(aprods,{'3122','02',500.4})
Aadd(aprods,{'3124','02',30})
Aadd(aprods,{'3129','02',521.59})
Aadd(aprods,{'3130','02',35.83})
Aadd(aprods,{'3131','02',10.1})
Aadd(aprods,{'6594','02',14.94})
Aadd(aprods,{'6690','02',55.46})
Aadd(aprods,{'8731','02',526.75})
Aadd(aprods,{'9843','02',325.21})
Aadd(aprods,{'9845','02',697.32})
Aadd(aprods,{'10442','02',589.05})
Aadd(aprods,{'10782','02',331.09})
Aadd(aprods,{'11649','02',134.72})
Aadd(aprods,{'11650','02',63.44})
Aadd(aprods,{'11651','02',429.49})
Aadd(aprods,{'11652','02',91.62})
Aadd(aprods,{'11653','02',111.77})
Aadd(aprods,{'11654','02',66.92})
Aadd(aprods,{'11655','02',273.25})
Aadd(aprods,{'11656','02',64.6})
Aadd(aprods,{'11820','02',683.66})
Aadd(aprods,{'15380','02',122.4})
Aadd(aprods,{'15835','02',1087.95})
Aadd(aprods,{'15836','02',540.24})
Aadd(aprods,{'16834','02',148.4})
Aadd(aprods,{'19800','02',881.92})
Aadd(aprods,{'19801','02',411.19})
Aadd(aprods,{'19802','02',4018.61})
Aadd(aprods,{'19803','02',629.2})
Aadd(aprods,{'19804','02',3285.63})
Aadd(aprods,{'19805','02',422.32})
Aadd(aprods,{'19806','02',2811.55})
Aadd(aprods,{'19807','02',2203.13})
Aadd(aprods,{'19808','02',399.48})
Aadd(aprods,{'19809','02',214.36})
//
For nn1 := 1 to len( aProds )
	//
	aProds[nn1 , 1] := Strzero( Val( aProds[nn1 , 1] ), 6 )
	//
	SB1->( DbSetOrder( 1 ) )
	SB1->(dbSeek(xFilial("SB1") + aProds[nn1 , 1] ) )
	//
	DbSelectArea('SB2')
	DbSetORder(1)
	if ! DbSeek( XFILIAL('SB2') + PADR( aProds[nn1 , 1],15 )   +  aProds[nn1 , 2] )
	   REclock('SB2',.t.)
	      Replace B2_FILIAL WITH XFILIAL('SB2')
	      Replace B2_COD    WITH aProds[nn1 , 1]
	      Replace B2_LOCAL  WITH aProds[nn1 , 2]
	      REplace B2_QATU 	WITH aProds[nn1 , 3]
	   MsUnlock()           
	   //
	   DbSelectARea('SB9')
	   Reclock('SB9', .t.)
	      Replace B9_FILIAL WITH XFILIAL('SB9')
	      REPLACE B9_COD 	WITH aProds[nn1 , 1]
	      REPLACE B9_LOCAL	WITH aProds[nn1 , 2]
	      REPLACE B9_QINI	WITH aProds[nn1 , 3]
	      // REPLACE B9_
	   MSUnlock()	   
	Endif 	                
	//
	DBSELECTAREA('SB2')                 
	//
	Aadd(aInvent,{"B7_FILIAL"  		,	XFILIAL('SB7')		,	Nil	})
	Aadd(aInvent,{"B7_COD"     		,	aProds[nn1 , 1]		,	Nil	})
	Aadd(aInvent,{"B7_LOCAL"   		,	aProds[nn1 , 2] 	,	Nil	})
	Aadd(aInvent,{"B7_TIPO"    		,	SB1->B1_TIPO   		,	Nil	})
	Aadd(aInvent,{"B7_DOC"     		,	'INVGER02'			,	Nil	})
	Aadd(aInvent,{"B7_QUANT"   		,	aProds[nn1 , 3]		,	Nil	})
	Aadd(aInvent,{"B7_QTSEGUM" 		,	0					,	Nil	})
	Aadd(aInvent,{"B7_DATA"    		,	ctod('31/12/10')	,	Nil	})
	Aadd(aInvent,{"B7_DTVALID" 		,	ctod('31/12/11')	,	Nil	})
	// MSExecAuto({|x,y| mata270(x,y)}	,aInvent,3)
	// 
	DbSelectArea('SB7')
	REclock('SB7', .t. ) 
	For nn2 := 1 to len( aInvent ) 
	    cCampo := aInvent[nn2,1]
	    Replace &cCampo With  aInvent[nn2,2]	
	Next 
	MsUnlock()
	//
	//
	/*
	If lMsErroAuto
		MostraErro()
	Endif
	*/
	aInvent := {}
Next
//
ALERT('PROCESSAMENTO CONCLUIDO COM SUCESSO')

Return .T.
//--------------------------------------
User function AT_EMPUBA()
Local nn2
//
//
cFilant := '08'
cEmpAnt := '01'
RpcSetType(3)
RpcSetEnv(cEmpAnt, cFilAnt,,,,, { "SB2", "SD4" } )
//
aAreaAnt   := GetArea()
aAreaSC2   := SC2->(GetArea())
aAreaSD4   := SD4->(GetArea())
aAreaSDC   := SDC->(GetArea())
lProcessD4 := .T.
nEmpenhoD4 := 0
nEmpenho   := 0               
dDataFim   := ctod('31/12/11')
//
cQuery := "SELECT R_E_C_N_O_ as REC FROM SB2010 WHERE B2_FILIAL = '08' AND D_E_L_E_T_ = ' '"
//
If Select("TRB2") > 0
	DbSelectArea( "TRB2" )
	DbCloseArea()
Endif
//
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB2",.T.,.T.)
//
DbGotop()
While !eof()
	//
	DbSelectArea('SB2')
	DbGoTo( TRB2->REC )
	//
	// nSaldo1 := SaldoEmp( cTod( '31/12/2011' ) )
	//	           
	nEmpenhoD4 := 0
	// Varre empenhos ate a data estipulada
	dbSelectArea("SC2")
	dbSetOrder(1)
	dbSelectArea("SDC")
	dbSetOrder(2)
	dbSelectArea("SD4")
	dbSetOrder(3)
	dbSeek(xFilial("SD4")+ SB2->B2_COD + SB2->B2_LOCAL)
	While lProcessD4 .And. !Eof() .And. D4_FILIAL + D4_COD + D4_LOCAL == xFilial("SD4") + SB2->B2_COD+SB2->B2_LOCAL
		// Se existe algum empenho com lote preenchido, assume empenho do SB2
		// pois os saldos dos lotes ja estao comprometidos com a colocacao
		// do empenho
		//If Rastro(D4_COD) .And. !Empty(D4_LOTECTL+D4_NUMLOTE)
		 //	lProcessD4:=.F.
		//EndIf
		// Se existe algum empenho com localizacao, assume empenho do SB2
		// pois os saldos das localizacoes ja estao comprometidos com a colocacao
		// do empenho
		If lProcessD4 .And. Localiza(D4_COD)
			cSeekSDC:=xFilial("SDC")+SD4->D4_COD+SD4->D4_LOCAL+SD4->D4_OP+SD4->D4_TRT
			cComparaSDC:="DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT"
			dbSelectArea("SDC")
			dbSeek(cSeekSDC)
			While lProcessD4 .And. !Eof() .And. cSeekSDC == &(cComparaSDC)
				If QtdComp(DC_QUANT) > QtdComp(0)
					lProcessD4:=.F.
				EndIf
				dbSkip()
			End
		EndIf
		dbSelectArea("SD4")
		// Soma quantidade do empenho
		If QtdComp(D4_QUANT) > QtdComp(0) .And. D4_DATA < dDataFim .And. ;
			SC2->(dbSeek(xFilial("SC2")+SD4->D4_OP)) .And. SC2->C2_TPOP $ " F"
			nEmpenhoD4+=D4_QUANT
		EndIf
		dbSkip()
	End
	
	/*
	If lProcessD4
	nEmpenho:=nEmpenhoD4
	EndIf
	*/
	
	//alert( sb2->b2_cod + '-'+ str( nEmpenhoD4 ) )
	
	DbSelecTarea('SB2')
	REclock('SB2',.f.)
	Replace B2_QEMP with nEmpenhoD4
	Msunlock()
	*/
	//
	DbSelectArea('TRB2')
	DbSkip()
Enddo
//
alert( 'Processamento Concluido com Sucesso')
RETURN()
//---------------------------------------
