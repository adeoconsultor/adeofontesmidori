#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#include "COLORS.CH"
//---------------------------------
User Function MD_CNSTPL(  nRecSc2 , lConsulta )
//
Private oFontSay ,oFontSayB,oFontDad,obrProds,cBanco,obrfics,cfics,ochkAll
Private tchkAll := .T.
Private acPrds := {}
Private cMainOp := SC2->C2_NUM   //  Ordem de Producao Principal
Private aGrpOps := {} // Array contendo os grupos de produtos
Private aGrpDispAux := {} // Array que acumulara as Materias Primas Por Produto Intermediario, quebrando as quantidades para cada um destes
Private aGrpAuxOps := {} // Array que acumulara as Materias Primas Por Produto Intermediario, quebrando as quantidades para cada um destes
Private nLotQuebra := 0 // Variavel que contem a quantidade de quebra por ficha
Private oOk := LoadBitmap( GetResources(), "LBOK")
Private oNo := LoadBitmap( GetResources(), "LBNO")
Private  aPisFic := {}
Private lTemFicha := .F. // Flag informando que ainda nao tem fichas de corte lancados para a ordem de producao
Private lTemFcApont := .f. // Flag indicando se ha alguma ficha ja apontada
Private nLin
Private wnrel   	:= "FICORTE"
Private aLados  	:= { 'A', 'B' } // Array contendo os lados para processamento, mesmo se houver necessidade de se abrir para outros lados, o sistema estara pronto para atender
Private lLado     	:= .F.
Private lCons 		:= Iif( Type("lConsulta")#"U", lConsulta, .F. )
Private aFases 		:= {}
//
// Ja posicionando na ordem de producao principal
DbSelectArea('SC2')
DbSetOrder(1)
DbSeek(   xFilial('SC2') + cMainOp + '01001'   )  //  Posicionando na OP Principal
lLado     := iif( sc2->c2_lado == 'S', .T. , .F. )
//
cGprPl          :=  SC2->C2_PRODUTO // Produto do Plano de Producao
//
if ! TRZ_FASES( cGprPl )
   REturn()
Endif 
//
DbSelectArea('SC2')
//
nLotQuebra := SC2->C2_QTDLOTE // Aqui ja posicionando a quantidade por lote de quebra
//
DEFINE FONT oFontSay     NAME "Arial"    SIZE 0,16  BOLD
DEFINE FONT oFontSayb   NAME "Arial"    SIZE 0,16  BOLD UNDERLINE
DEFINE FONT oFontDad     NAME "Arial"    SIZE 0,16
//
DEFINE MSDIALOG oDlgDet1 FROM 000,000 TO 600,1200  TITLE "FICHAS DE CORTE - Consulta Fichas do Plano" PIXEL
//
//
@ 10, 5 say "Plano:" 			Color CLR_HBLUE object oObj1
@ 10, 80 say "OP Siga:" 	Color CLR_HBLUE object oObj2
@ 10,170 say "Emissão:" 	Color CLR_HBLUE object oObj3
@ 10,240 say "Cliente: " 	Color CLR_HBLUE object oObj4
//
@ 07,25 BUTTON SC2->C2_OPMIDO   SIZE 50 ,12  of oDlgDet1 Pixel // ACTION  e_fabric()


@ 10, 108 say SC2->C2_NUM 	 			object oObj7
@ 10,200 say Dtoc( SC2->C2_EMISSAO )		object oObj8
@ 07,265 BUTTON SC2->C2_CLIENTE  + "/" + C2_LOJA 	 + '-'+ Alltrim(Posicione('SA1' , 1 , xFilial('SA1') + SC2->C2_CLIENTE + SC2->C2_LOJA, 'A1_NOME'    )  );
SIZE 200,12  of oDlgDet1 Pixel // ACTION  e_fabric()
//
@ 10,475   say "Release: " 	Color CLR_HBLUE object oObj5
@ 10 ,500   say Alltrim(  SC2->C2_RELEASE  )  +'-' +  Dtoc( C2_DTRELE) 	object oObj12
//
@ 25,05  say "Produto: " 	Color CLR_HBLUE object oObj9
@  23,35 BUTTON Alltrim(C2_PRODUTO) + '-' +  Alltrim( Posicione('SB1' , 1 , xFilial('SB1') + SC2->C2_PRODUTO, 'B1_DESC'    )  ) ;
SIZE 175,12  of oDlgDet1 Pixel // ACTION  e_fabric()

@ 25,220   say "Qtde. : " 	Color CLR_HBLUE object oObj10
@ 25,240   say Alltrim( Transform( SC2->C2_QUANT , '@E 99,999,999.9999')  )   	object oObj11
@ 25,280   say "Previsão: " 	Color CLR_HBLUE object oObj13
@ 25,310   say Dtoc( SC2->C2_DATPRF )  	object oObj14
@ 25,350   say "Multiplos : " 	Color CLR_HBLUE object oObj15
@ 25,383   say Alltrim( Transform( SC2->C2_QTDLOTE , '@E 99999999')  )  + '   Peça'+ iif(SC2->C2_QTDLOTE > 1, 's','' )  	object oObj16
//
oObj1:setfont(oFontSay )
oObj2:setfont(oFontSay )
oObj3:setfont(oFontSay)
oObj4:setfont(oFontSay)
oObj5:setfont(oFontSay)
oObj9:setfont(oFontSay)
oObj10:setfont(oFontSay)
oObj13:setfont(oFontSay)
oObj15:setfont(oFontSay)
//
oObj7:setfont(oFontDad )
oObj8:setfont(oFontDad )
oObj11:setfont(oFontDad )
oObj12:setfont(oFontDad )
oObj14:setfont(oFontDad )
oObj16:setfont(oFontDad )
//
DbSelectArea('SC2')
DbSetOrder(1)
DbSeek(   xFilial('SC2') + cMainOp + '01001'   )  //  Posicionando na OP Principal
//
Carr_GrOPS() // Carregando os itens por grupo de produtos na op
Carr_PrOPS() // fUNCAO QUE CARREGA OS ITENS DA OP
//
aGrpOps := aSort( aGrpOps,2,, { |x, y| x[1] < y[1] } )
//
IF LEN(acPrds ) == 0
	acPrds := { space( 15 ), space( 30 ) ,  0 , 0 , 0, '' }
Endif
// AAdd(acPrds, { 'Produto 1 ', 'Descri 1 '} )
//
acFics := {}
CARR_SZ3() // Verifica se ha fichas de corte ja geradas no Arquivo SZ3 para o plano
//
@ 45,05 LISTBOX obrProds VAR cBanco Fields HEADER "Codigo","Descricao" , "Qtde OP","Qtde M2"  ON CHANGE ChngGrpPrs() SIZE 290,117  pixel // ON CHANGE CHNG() ON DBLCLICK Ad_PrLst()
obrProds:SetArray(acPrds)
/*Alert('Tamanho acPrds -> '+cValToChar(len(acPrds)))
for i:= 1 to len(acPrds)
	Alert('Item -> '+cValToChar(obrProds:nAt))
	Alert('Item 1 '+acPrds[obrProds:nAt,1])
	Alert('Item 2 '+acPrds[obrProds:nAt,2])
	Alert('Item 3 '+cValToChar(acPrds[obrProds:nAt,3]))
	Alert('Item 4 '+cValToChar(acPrds[obrProds:nAt,4]))
next i */
//obrProds:bLine := { || { acPrds[obrProds:nAt,1],acPrds[obrProds:nAt,2],acPrds[obrProds:nAt,3],acPrds[obrProds:nAt,4]   }  }
//
AAdd( aGrpDispAux , {space(10),space(30),space(10)   }  )
//
@ 45,305 LISTBOX obrAuxProds VAR cPrsAux Fields HEADER  "Codigo","Descricao" , "Qtde OP", "Qtde M2", "Padrao M2" SIZE 290,117  pixel // ON CHANGE ChngGrpPrs()  ON DBLCLICK Ad_PrLst()
obrAuxProds:SetArray( aGrpDispAux )
obrAuxProds:bLine := { || { aGrpDispAux[obrAuxProds:nAt,1] , aGrpDispAux[obrAuxProds:nAt,2] , aGrpDispAux[obrAuxProds:nAt,3] , aGrpDispAux[obrAuxProds:nAt,4] }  }
//
// AAdd( aGrpAuxOps , { SG1->G1_COMP , ALLTRIM( SB1->B1_DESC ) , SC2->C2_PRODUTO , SC2->C2_QUANT, SG1->G1_QUANT,SC2->C2_QUANT * SG1->G1_QUANT  }  )
//
@ 165,05  LISTBOX obrfics VAR cFics Fields HEADER "   ",'Numero da Ficha','Dta Ficha','Tipo' ,'Dt Apont','Status Atual' , 'Material' , "Descricao", "Qtde ","Total M2" ,"M2 Padrao", 'Num Cartao' SIZE 589,113  ON DBLCLICK clk_LST() pixel // ON CHANGE CHNG() ON DBLCLICK Ad_PrLst()
obrfics:SetArray(acFics)
obrfics:bLine := { || { iif( acFics[obrfics:nAt,1], ook, oNo ) , acFics[obrfics:nAt,2],acFics[obrfics:nAt,3],acFics[obrfics:nAt,4],acFics[obrfics:nAt,5] , acFics[obrfics:nAt,6] , acFics[obrfics:nAt,7], acFics[obrfics:nAt,8], acFics[obrfics:nAt,9], acFics[obrfics:nAt,10], acFics[obrfics:nAt,11], acFics[obrfics:nAt,12] }  }
//
Activate Dialog oDlgDet1 Centered
//
Return()
//------------------------------------------------------------
Static Function clk_LST()
Local cFicMain := acFics[obrfics:nAt,2]
Local lFlagChk  := acFics[obrfics:nAt,1]
Local nn1 := 0
//
For nn1 := 1 to len( acFics )
	if acFics[nn1 , 2 ] == cFicMain
		if !  lFlagChk
			acFics[nn1 , 1 ]  := .t.
		Else
			acFics[nn1 ,1 ]  := .f.
		Endif
	Endif
Next
obrfics:REfresh()
//
Return()
//-------------------------------------------------------------
Static Function CHNG_LST()
Local nn1 := 0
For nn1 := 1 to len( acFics )
	if tchkAll
		acFics[nn1 , 1 ]  := .t.
	Else
		acFics[nn1 ,1 ]  := .f.
	Endif
Next
obrfics:REfresh()
Return()
//-------------------------------------------------------------

/*
A funcao abaixo tem como objetivo carregar a Estrutura dos produtos com todas as ops carregadas, a partir do plano de producao gerado
*/
Static Function Carr_PrOPS()
//
Local nn1 := 0
acPrds := {}
//
DbSelectArea('SC2')
DbSetOrder(1)
if DbSeek(   xFilial('SC2') + cMainOp + '01001'   )  //  Posicionando na OP Principal
	//
	AAdd( acPrds, {'TODOS', 'TODOS OS PRODUTOS             ' ,Transform( 0, '@E 999,999')  , Transform( 0 , '@E 99,999.9999') , Transform( 0, '@E 9,999.9999')  , ' '  }  )
	//
	// O bloco abaixo tem como objetivo descarregar os grupos de produtos
	For nn1 := 1 to len( aGrpOps )
		AAdd( acPrds, { aGrpOps[ nn1,1 ] ,   Substr( aGrpOps[ nn1,2 ],1,30 )  ,Transform( aGrpOps[ nn1 , 4  ] , '@E 999,999')  , Transform( aGrpOps[ nn1,3 ] , '@E 99,999.9999') , Transform( 0, '@E 9,999.9999')  , ' '  }  )
	Next
Endif
//

Return()
//------------------------------------------------------------
/*
A funcao abaixo tem como objetivo carregar os grupos de produtos que estao dentro da op
*/
Static Function Carr_GrOPS()
//
aGrpOps := {} // Array contendo os grupos de produtos
//
nRecSc2 := SC2->( Recno() )
DbSelectArea('SC2')
DbSetOrder(1)
set filter to
DbGoTop()
//Alert("OP: "+cMainOP) 
if ! DbSeek(   xFilial('SC2') + cMainOp + '01001'   )  //  Posicionando na OP Principal
	Alert('Op Princopal do PLano nao Encontrada. Entre em contato com o Administrador do Sistema.')
	Return()
Endif
//
cProdPA := SC2->C2_PRODUTO // Produto principal
//
While ! eof() .and. C2_FILIAL == xFilial('SC2') .and.  C2_NUM  == cMainOp
	//
	/*
	if C2_ITEM + C2_SEQUEN == '01001'  // o PRIMEIRO PRODUTO NAO INTERESSA NESSA LISTA
	Dbskip()
	Loop
	Endif
	*/
	//
	cNumSup1 :=  '' // Numero Superior do Lancamento
	cProdPI1    := SC2->C2_PRODUTO // Produto principal
	//
	//
	//
	IF Alltrim( C2_UM ) <> 'M2'
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
		// cUmCompnivel := Posicione('SB1',1,xFilial('SB1') + cCompoNivel, 'B1_UM' )
		//
		// Descendo a um nivel abaixo
		DbSelectArea( 'SG1' )
		DbSetORder( 1 )
		DbSeek( xFilial( 'SG1' ) + cCompoNivel  )
		//
		SB1->( DbSeek( xFilial('SB1') + cCompoNivel )  )
		//
		// if ! DbSeek( xFilial( 'SG1' ) + cCompoNivel  )
		if !found() .or. SB1->B1_UM == 'M2'
			//
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
				AAdd( aGrpOps , { SG1->G1_COMP , ALLTRIM( SB1->B1_DESC ) , SC2->C2_QUANT * nQtNivel , SC2->C2_QUANT , cLadob1   }  )
			Else
				aGrpOps[ nRetPos , 3  ]  += SC2->C2_QUANT * nQtNivel
				aGrpOps[ nRetPos , 4  ]  += SC2->C2_QUANT
			Endif
			AAdd( aGrpAuxOps , { SG1->G1_COMP , ALLTRIM( SB1->B1_DESC ) , SC2->C2_PRODUTO , SC2->C2_QUANT, SG1->G1_QUANT,SC2->C2_QUANT * nQtNivel , cLadob1, sc2->c2_ITEM, SC2->C2_SEQUEN }  )
			//
		Endif
		//
	ENDIF
	//
	DbSelectArea('SC2')
	Dbskip()
Enddo
//
set filter to C2_FILIAL== xFilial("SC2") .And. C2_TPOP == "F" .And. C2_LIBER == "OK"
dbGoTo(  nRecSc2  )
//
Return()
//------------------------------------------------------------------------------------------------------------------
// A funcao abaixo tem como objetivo carregar os itens de produtos intermediarios a partir das materias primas lancadas
Static Function ChngGrpPrs()
Local nn1 := 0
//
aGrpDispAux := {}
aFicsAux      := {}
cMPMain := acPrds[obrProds:nAt,1]
//
For nn1 := 1 to len( aPisFic )
	if ( alltrim( aPisFic[ nn1 , 6  ]  ) == alltrim( cMPMain  )  ) .or.  ( alltrim( cMPMain  ) == 'TODOS' )
		//
		//
		AAdd( aFicsAux,{ aPisFic[nn1,1],aPisFic[nn1,2],aPisFic[nn1,3],aPisFic[nn1,4],aPisFic[nn1,5],aPisFic[nn1,6],aPisFic[nn1,7],aPisFic[nn1,8],aPisFic[nn1,9] ,aPisFic[nn1,10],aPisFic[nn1,11] ,aPisFic[nn1,12] }  )
		//
	Endif
Next
//
if len(aFicsAux) == 0
	AAdd( aFicsAux,{ .f.,' ',' ',' ',' ',' ',' ',' ',' ',' ',' ' ,' '}  )
Endif
//
//
acFics := aFicsAux
//
obrfics:SetArray(acFics)
obrfics:bLine := { || { iif( acFics[obrfics:nAt,1], ook, oNo ) , acFics[obrfics:nAt,2],acFics[obrfics:nAt,3],acFics[obrfics:nAt,4],acFics[obrfics:nAt,5] , acFics[obrfics:nAt,6] , acFics[obrfics:nAt,7], acFics[obrfics:nAt,8], acFics[obrfics:nAt,9], acFics[obrfics:nAt,10], acFics[obrfics:nAt,11], acFics[obrfics:nAt,12] }  }
obrfics:Refresh()
//
//
For nn1 := 1 to len( aGrpAuxOps )
	if ( alltrim( aGrpAuxOps[ nn1 , 1  ]  ) == alltrim( cMPMain  )  ) .or.  ( alltrim( cMPMain  ) == 'TODOS' )
		//
		AAdd( aGrpDispAux , { Alltrim(aGrpAuxOps[ nn1 , 3  ] ) , Alltrim(Posicione( 'SB1', 1, xFilial('SB1') + aGrpAuxOps[ nn1 , 3  ], 'B1_DESC' ) ) , Alltrim(Transform( aGrpAuxOps[ nn1 , 4  ] ,'@E 99,999.9999' ) )  , Alltrim( Transform( aGrpAuxOps[ nn1 , 6  ] ,'@E 99,999.9999' )  ) ,Alltrim( Transform( aGrpAuxOps[ nn1 , 5  ] ,'@E 99,999.9999' )  )   }  )
	Endif
Next
//
if Len( aGrpDispAux ) == 0
	AAdd( aGrpDispAux , {space(10),space(20),space(10),space(10),space(10)    }  )
Endif
//
obrAuxProds:SetArray( aGrpDispAux )
obrAuxProds:bLine := { || { aGrpDispAux[obrAuxProds:nAt,1],aGrpDispAux[obrAuxProds:nAt,2],aGrpDispAux[obrAuxProds:nAt,3] ,aGrpDispAux[obrAuxProds:nAt,4 ] ,aGrpDispAux[obrAuxProds:nAt,5 ]   }  }
obrAuxProds:Refresh()
//
Return()
//-----------------------------------------------------------
// A funcao abaixo tem como objetivo pesquisar a tabela SZ3 para validar se ja existe registros ref a fichas de corte
//
//
Static Function CARR_SZ3()
//
aPisFic := {}
//
DbSelectArea('SZ3')
DbSetOrder(4) // Ordenando por Z3_NUMFC + Z3_PRODUTO


//
cQuery := "Select R_E_C_N_O_ as Rec   from "+ RetSqlName( 'SZ3' ) + " where D_E_L_E_T_ =' ' and Z3_FILIAL = '" + xFilial('SC2') + "' and Z3_NUMOP LIKE('%"+ Alltrim( cMainOp ) + "%') "
//
if select('TRBZ3') > 0
	DbSelectArea( 'TRBZ3' )
	DbCloseArea()
Endif
//
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZ3',.T.,.T. )
DbGoTop()
//
If ! eof()
	LtemFicha := .T. // Flag informando que ainda nao tem fichas de corte lancados para a ordem de producao
	//
	While !eof()
		DbSelectArea('SZ3')
		DbGoTo( TRBZ3->REC ) // POSICIONO NO SZ3
		// While ! eof() .and. substr( Z3_NUMFC, iif( lLado, 2 ,1 ) , 6 ) == cMainOp
		// While ! eof() .and.  Z3_NUMFC $  cMainOp // verifca se contem ou nao o numero da op
		//
		if !empty( Z3_DTAPON )
			lTemFcApont := .T. // Flag indicando se ha alguma ficha ja apontada
		Endif
		//
		//
		nRetPos := Ascan(  aPisFic ,     {|x| Alltrim( x[2] ) == Alltrim( SZ3->Z3_NUMFC )  }  )
		//
		if nRetPos == 0
		    //
		    cStatusAtu := TRZ_Aponts( SZ3->Z3_NUMFC )
		    //
			AAdd( aPisFic,  {   .t. , ;   // flag
			SZ3->Z3_NUMFC  , ; // numero da ficha
			SZ3->Z3_DTFICHA,; // Data Base da Geracao da Ficha
			SZ3->Z3_TPFCH,; // Tipo da Ficha ( N- Normal; C- Complementar )
			DTOC( SZ3->Z3_DTAPON   ),; //  Data do Apontamento da Ficha
			cStatusAtu ,;
			ALLTRIM(SZ3->Z3_MATERIA)  ,; // Materia Prima
			Alltrim( Posicione('SB1' , 1 , xFilial('SB1') + Alltrim( SZ3->Z3_MATERIA  ) , 'B1_DESC'    )  ) ,; //  Descricao do Produto Intermediario
			TRansform( SZ3->Z3_QTDE ,'@E 99,999.9999' ) , ; // Quantidade do Lote
			TRansform( SZ3->Z3_M2TOT   , '@E 99,999.9999' )  , ; // Metros Quadrados utilizados
			TRansform( SZ3->Z3_M2PAD , '@E 99,999.9999' ) ,; // M2 Padrao
			ALLTRIM( SZ3->Z3_CARTAO ) }   )  // Numero do Cartao
		Endif
		//
		//
		DbSelectArea('TRBZ3')
		Dbskip()
	Enddo
	//
Endif
//
if len(aPisFic) == 0
	AAdd( aPisFic,{ .f.,' ',' ',' ',' ',' ',' ',' ',' ',' ',' ' , ' ' }  )
Endif
//
acFics := aPisFic
acFics := aSort( acFics,,, { |x, y| x[2] +x[6] +x[7]  < y[2] +y[6]+ y[7]  } )
//
//obrfics:SetArray(acFics)
//obrfics:bLine := { || { iif( acFics[obrfics:nAt,1], ook, oNo ) , acFics[obrfics:nAt,2],acFics[obrfics:nAt,3],acFics[obrfics:nAt,4],acFics[obrfics:nAt,5] , acFics[obrfics:nAt,6] , acFics[obrfics:nAt,7], acFics[obrfics:nAt,8], acFics[obrfics:nAt,9], acFics[obrfics:nAt,10], acFics[obrfics:nAt,11], acFics[obrfics:nAt,12] }  }
//
Return()
//---------------------------------------------------------------------------------
//---------------------------------------------------------------------------------
/*
A Funcao abaixo tem como objetivo buscar as operacoes a partir de um determinado produto
*/
Static Function TRZ_FASES( cProduto )
//
Local cAliAtu := Alias()
//
aFases :=  {}
DbSelectArea('SG2')
dBsETorDER( 1 )
if DbSeek( xFilial('SG2') + padr(cProduto, 15 )  )
	//
	While ! eof() .and. G2_FILIAL == xFilial('SG2') .AND. G2_PRODUTO ==  padr(cProduto, 15 )
		AAdd(  aFases , { G2_OPERAC, G2_DESCRI } )
//		Alert("OPERACAO: "+G2_OPERAC+  " DESCRICAO: "+G2_DESCRI)
		DbSkip()
	Enddo
	//
	aFases := aSort( aFases,2,, { |x, y| x[1] < y[1] } )
	//
Else
	Alert( 'Não foram encontradas Fases para o Produto '  + Alltrim( cProduto ) + '. Por favor, corrija' )
	Return( .F. )
Endif
//
Return(.T. )
//----------------------------------------------
Static  Function TRZ_Aponts( cFicha )
//
cAliasAtu := Alias()
//
cFaseAtu  := ''
//
DbSelectArea('SZ7')
if DbSeek(xFilial('SZ7') + Padr( cFicha,20  ) )
	
	While !eof() .and. Z7_FILIAL = xFilial('SZ7') .and. Z7_NUMFC == Padr( cFicha,20  )
		//
		nRetPos := Ascan( aFases, {|x| Alltrim( x[1] ) == Alltrim( Z7_FASE )  } )
		cFaseAtu := Alltrim( Z7_FASE )
		//
		DbSelectArea('SZ7')
		DbSkip()
	Enddo
	//
Endif
// Apos alimentar o browse de fases, correr a array de fases para verificar se ha alguma que ja foi apontada
//
// O bloco aponta a fase atual
If cFaseAtu == ''
	cFaseAtu := strzero( 0 , 2 )
Else
	//
	// Agora a Fase atual sera auferida a partir da array de fases... Se estiver na ultima fase e a posicao for maior que o tamanho da array, o sistema entendera que e o apontamento final da ficha
	nRetPos := Ascan( aFases, {|x| Alltrim( x[1] ) == Alltrim( cFaseAtu )  } )
	//
	if nRetPos + 1  =  len( aFases ) // se for igual ao tamanho da array quer dizer que ta na ultima fase
		cFaseAtu 				:= aFases[ nRetPos + 1, 1 ]
	Elseif nRetPos + 1  >   len( aFases ) // se for igual ao tamanho da array quer dizer que ta na ultima fase
		cFaseAtu 				:= 'ZZ'
	Else
		cFaseAtu 				:= aFases[ nRetPos + 1, 1 ]
	Endif
	//
	//
Endif
//
DbSelectArea('SZ3')
//
//
// O bloco abaixo tem como objetivo verificar a data de efetivacao do apontamento da ficha de corte
//
if Z3_STATUS == 'A'
	cGStatusFic := 'EM ABERTO'
ELSE
	cGStatusFic := 'BAIXADA'
Endif

//        
//alert("FASE ATUAL: "+cFaseAtu)
IF cFaseAtu == 'ZZ'
	cGFaseAtu :=  'APONTADA EM TODAS AS FASES'
Else
	cGFaseAtu :=  cFaseAtu + ' - ' + aFases[ Ascan( aFases, {|x| Alltrim( x[1] ) == Alltrim( cFaseAtu )  } ) , 2  ]
Endif
//
Return( cGFaseAtu )
//-----------------------------------------------