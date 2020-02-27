#INCLUDE "RWMAKE.CH"
/*
-As funcoes abaixo tem como objetivo ajustar o apontamento dos produtos quimicos conforme a necessidade,
fazendo substituicao daqueles sem estoque e atualizando os empenhos daqueles com saldo, conforme
tabela simplificada para os produtos correspondentes.
Desenvolvido por Rogerio Nunes, em 01/04/10. Especifico Modiri Atlantica, unidade PNP I

-Manutencao por Vinicius Schwartz, em 07/11/2012. Especifico Midori Atlantica, PNP1 - Sera atribuido um valor para a variavel publica cPltsNumOP, onde,
o conteudo sera utilizado no PE A250ETRAN (apos a gravacao do apontamento) para ser preenchido o conteudo do campo D3_X_PLTF de acordo com o D4_X_PLTF.
Ref ao Thiago/Fabio - HDI 004883
*/

User Function A250ITOK()
//
Private  aAltens := {}  // Array que contera os produtos alternativos para o apontamento, caso nao seja encontrado o saldo em estoque para o produto princpal
Private nSaldo1 := 0
Private nRecSd4 := 0
Public cPltsNumOP //Variavel publica para ser utilizada no PE A250ETRAN que preenchera o campo D3_X_PLTF de acordo com o campo D4_X_PLTF (Vinicius Schwartz-TI)
Public cDocDrwb  //Variavel pubica para ser utilizada na gracao do lote na tabe SZC (Anesio 15/10/2014)
Public cProDrwb  //Variavel pubica para ser utilizada na gracao do lote na tabe SZC (Anesio 15/10/2014)
Public cLoteDrwb  //Variavel pubica para ser utilizada na gracao do lote na tabe SZC (Anesio 15/10/2014)
Public nQtdDrwb  //Variavel pubica para ser utilizada na gracao do lote na tabe SZC (Anesio 15/10/2014)      
Public cPartida  //Variavel pubica para ser utilizada no P.E A250ETRAN

//

if cFilant <> '09' .and. cFilant <> '10'
   Return()
Endif 
//
VR_SD4EST()

//Alert ('Atribuiu') //Sera utilizada no PE A250ETRAN
cPltsNumOP := M->D3_OP
cDocDrwb   := M->D3_NUMSEQ
cProDrwb   := M->D3_COD
cLoteDrwb  := M->D3_X_LTDRW
nQtdDrwb   := M->D3_QUANT       
cPartida   := M->D3_PARTIDA // variavel utilizada no PE A250ETRAN

//
Return()
//-------------------------------------------------------------------
/*
A funcao abaixo tem como objetivo varrer o SD4 de acordo com o SC2 digitado, para que os saldos de todos os produtos sejam verificados para a correta extracao do estoque.
*/
Static Function VR_SD4EST()
//
DbSelectArea('SD4')
cOrdAtu := Indexord()
DbSetOrder( 2 ) // sETANDO PARA A ORDEM DE OP + CODIGO + LOCAL
//
cQuery := "SELECT SD4.R_E_C_N_O_ AS REC "
cQuery += " FROM "+RetSqlName("SD4")+" SD4 WHERE "
cQuery += "SD4.D4_FILIAL='"+xFilial("SD4")+"' AND SD4.D_E_L_E_T_=' ' AND "
cQuery += "SD4.D4_OP =  '" +M->D3_OP +"' "
//
If Select("TRBD4") > 0
	DbSelectArea( "TRBD4" )
	DbCloseArea()
Endif
//
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBD4",.T.,.T.)
//
//
While ! eof()
	//
	DbSelectArea('SD4')
	Dbgoto( TRBD4->REC )
	//
	cMainProd  :=  D4_COD
	nSaldo1      := D4_QUANT
	//
	DbSelectArea('SB2')
	DbSetORder(1)
	if DbSeek( xFilial( 'SB2') + cMainProd + sd4->d4_local  )
		aSaldo        := { B2_QATU , B2_QEMP }
	eLSE
		aSaldo        := { 0 }
	Endif
	//
	DbSelectArea('SD4')
	//
	//
	if aSaldo[1] < nSaldo1    // O Saldo em Estoque for menor que o Saldo Empenhado, dispara a rotina de acerto
		// O bloco abaixo verifica se o saldo, apesar < que a quant D4, e maior que zero, para rateio
		//
		nRecSd4 := Recno()
		//
		M->D4_FILIAL 			:= D4_FILIAL
		M->D4_COD   			:= D4_COD
		M->D4_LOCAL 			:= D4_LOCAL
		M->D4_DATA  			:= D4_DATA
		M->D4_OP   				:= D4_OP
		M->D4_QTDEORI   		:= D4_QTDEORI
		M->D4_QUANT 			:= D4_QUANT
		//
//Rotina antiga que buscava da tabela 'ZA' SX5
//		cTabs := Alltrim( Str( Val( cMainProd ) ) ) + ',' + Tabela( 'ZA', Alltrim( Str( Val( cMainProd ) ) ) ,  .f. )
//Rotina nova, buscando em SZE que permite ao usuário fazer alteracao
	cTabs := Alltrim( Str( Val( cMainProd ) ) ) + ',' + Posicione("SZE",1,xFilial("SZE")+cMainProd,"ZE_OPC")
		aAltens := QuebraSep( cTabs , ','  )  // A Variavel cSep indica qual o separador que servira para a quebra do item e alimentacao da array		
		//  aAltens := { cMainProd , '014519' }  // Esse produto fixo devera ser substituido pelo item da tabela simplificada de correspondencia de codigos
		SubstPRod() // Realizacao do rateio dos saldos em estoque para a baixa do produto principal em pauta
		//
	Endif
	//
	//
	DbSelectArea('TRBD4')
	DbSkip()
Enddo
//
//
DbSelectArea( 'SD4' )
DbSetORder( cOrdAtu )
Return()
//-------------------------------------------------------------------
/*
A funcao abaixo tem como objetivo substituir o produto original por outro, quando esse nao tiver saldo em estoque suficiente para atender o empenho
*/
Static Function SubstPRod()
//
Local nRecd4Ori := sd4->( Recno() ) // O primeiro bloco varre a array para saber qual dos produtos tem saldo em estoque
Local AiToK  := {} // Essa Array devera ser carregada com os itens que tem saldo em estoque para realizar o rateio
Local nn1
//
DbSelectarea( 'SD4' )
For nn1 := 1 to len( aAltens )
	//
	if nSaldo1 > 0
		//
		// A variavel abaixo sera atualizada conforme o saldo em estoque, se total ou parcial
		//
		DbSelectArea('SB2')
		DbSetORder(1)
		if DbSeek( xFilial( 'SB2') + Padr( aAltens[ nn1 ] , 15 ) + sd4->d4_local  )
			aSldAux        := { B2_QATU , B2_QEMP }
		eLSE
			aSldAux        := { 0 }
		Endif
		//
		nQtRat := 0
		nQtRat := iif ( aSldAux[1] >= nSaldo1 , nSaldo1 , iif( aSldAux[1] > 0, aSldAux[1] , 0 )  )
		//
		if nQtRat <>  0
			AAdd( AiToK , { Padr( aAltens[ nn1 ] , 15 ) , nQtRat   }   )
			nSaldo1 -=  nQtRat
		Endif
		//
	Endif
	//
Next
//
// O bloco abaixo tem como objetivo realizar a gravacao dos itens que foram efetivamente rateados para outros produtos ou para o mesmo produto
if len( AiToK ) == 1 .and. alltrim( AiToK[1,1] ) == alltrim( cMainProd  ) // Se somente rateou para o produto com saldo < que o D4, e so tem ele, sai fora
	Return()
Else
	//
	For nn1 := 1 to len(  AiToK  )
		// Primeiramente processa se o produto for o mesmo que o principal, para que somente substitua o principal com a quantidade de rateio
		if alltrim( AiToK[ nn1  , 1 ] ) ==  alltrim( cMainProd  )
			//
			DbSelectArea('SB2')
			DbSetORder(1)
			if DbSeek( xFilial( 'SB2') + cMainProd + sd4->d4_local  )
				Reclock('SB2', .f. )
				Replace B2_QEMP WITH  (  B2_QEMP - M->D4_QUANT ) + AiToK[ nn1  , 2 ] // Substituindo a  quantidade empenhada para que fique somente o saldo
				MsUnlock()
			Endif
			//
			// O BLOCO ABAIXO TEM COMO OBJETIVO ATUALIZAR A TABELA SD4
			Reclock('SD4',.f. )
				Replace D4_QTDEORI 	WITH   AiToK[ nn1  , 2 ]
				Replace D4_QUANT 		WITH   AiToK[ nn1  , 2 ]
			MsUnlock()
			//
		Else
			//
			if nn1 == 1  // SE for o primeiro item e nao tiver saldo algum nele pra acertar, deleta o sd4 cria outro
				DbSelectArea('SD4')
				//
				DbSelectArea('SB2')
				DbSetORder(1)
				if DbSeek( xFilial( 'SB2') + cMainProd + sd4->d4_local  )
					Reclock('SB2', .f. )
					Replace B2_QEMP WITH  B2_QEMP - M->D4_QUANT // retira a quantidade empenhada
					MsUnlock()
				Endif
				//
			Endif
			//
			DbSelectArea('SB2')
			DbSetORder(1)
			if DbSeek( xFilial( 'SB2') + AiToK[ nn1  , 1 ] + M->D4_LOCAL   )
				Reclock('SB2', .f. )
				Replace B2_QEMP WITH  B2_QEMP + AiToK[ nn1  , 2 ] // Substituindo a  quantidade empenhada para que fique somente o saldo
				MsUnlock()
			Endif
			//
			DbSelectArea('SD4')
			if nn1 == 1  // SE for o primeiro item e nao tiver saldo algum nele pra acertar, deleta o sd4 cria outro
				Reclock('SD4',.f. )
			Else
				Reclock('SD4',.T.)
			Endif
			//
			Replace D4_FILIAL 		WITH   M->D4_FILIAL
			Replace D4_COD 			WITH   AiToK[ nn1  , 1 ]
			Replace D4_LOCAL 		WITH   M->D4_LOCAL
			Replace D4_OP 			WITH   M->D4_OP
			Replace D4_DATA 		WITH   M->D4_DATA
			Replace D4_QTDEORI 		WITH   AiToK[ nn1  , 2 ]
			Replace D4_QUANT 		WITH   AiToK[ nn1  , 2 ]
			//
			MsUnlock()
			//
		Endif
	Next
	//
Endif
//
//
Return()
//--------------------------------------------------------------------
Static  Function QuebraSep( Linha , cSep  )  // A Variavel cSep indica qual o separador que servira para a quebra do item e alimentacao da array
Local aItens1 := {} // Array que sera preenchida a partir da quebra dos itens
Local cDsAux := ''
Local n1 := 1
Local nk1
//
For n1 := 1 to len( Linha )
	if substr(linha,n1,1) <> csep
		cDsAux += substr(linha,n1,1)
	Else
		AAdd( aItens1, cDsAux )
		cDsAux := ''
	Endif
	//
Next
// Adicionando o ultimo elemento da quebra com o item
if cDsAux <> ''
	AAdd( aItens1, cDsAux )
Endif
//
// Como a funcao e especifica para produtos, o bloco abaixo equalizara os codigos para a realidade Midori
For nk1 := 1 to len( aitens1 )
     nPrOrig := StrZero( Val( aitens1[nk1] ) , 6 ) 
     //
     aitens1[ nk1 ] := nPrOrig
Next 
//
Return( aitens1 )
//--------------------------------------------------------