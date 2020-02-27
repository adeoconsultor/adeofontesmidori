#include "totvs.ch"
//========================================================================================================
// MT097BUT  -  Alessandro Freire - Advpl Tecnologia                                           Junho/2015
//--------------------------------------------------------------------------------------------------------
// Descrição
// Dialog que demonstra as cotações  de cada produto do pedido de compras.
// P.E. executado na rotina MATA097 - Liberação de documentos
//--------------------------------------------------------------------------------------------------------
// Parâmetros
// nil
//--------------------------------------------------------------------------------------------------------
// Returno
// nil
//========================================================================================================
User Function MT097BUT()  
Processa( { || u_DlgCota() }, "Analisando cotações. Aguarde..." )
Return( nil )                                                   

//========================================================================================================
// DlgCota   -  Alessandro Freire - Advpl Tecnologia                                           Junho/2015
//--------------------------------------------------------------------------------------------------------
// Descrição
// Dialog que demonstra as cotações  de cada produto do pedido de compras.
// Deve estar posicionado no SC7
//--------------------------------------------------------------------------------------------------------
// Parâmetros
// nil
//--------------------------------------------------------------------------------------------------------
// Returno
// nil
//========================================================================================================
User Function DlgCota()

Local aArea     := GetArea()
Local aAreaSC7  := SC7->(GetArea())
Local cPedido   := SC7->C7_NUM    
Local aItens    := {}
Local lContinua := .f.
Local oDlg, oGrid
            
//----------------------------------------------------
// verifica se há cotações para este pedido de compra
//----------------------------------------------------
dbSelectArea("SC7")
dbSetOrder(1)
dbSeek(xFilial("SC7")+cPedido)

While ! Eof() .and. xFilial("SC7")+cPedido == SC7->(C7_FILIAL+C7_NUM)
	lContinua := ! Empty( SC7->C7_NUMCOT )
	If lContinua
		Exit
	EndIf
	dbSkip()
Enddo      

//----------------------------------------------------
// Se não houver cotações, sai da rotina
//----------------------------------------------------
If ! lContinua
	MsgInfo( "Não há nenhuma cotação para este pedido de compra", "Atenção" ) 
	RestArea( aAreaSC7 )
	RestArea( aArea )
	Return(nil)
EndIf                                   

RestArea( aAreaSC7 )
RestArea( aArea )

oDlg := uAdvPlDlg():New( "Cotações de Compra", nil, nil, "Pedido " + cPedido )
                
oGrid:= MyGrid():New( 000, 000, 000, 000, 0,,,,,, 99999,,,, oDlg:oPnlCenter ) 
                                                                                                                                  
oGrid:AddColumn( {"Cotação"  , "COTACAO" , x3Picture("C8_NUM"    ), TamSx3("C8_NUM" )[1]   , TamSx3("C8_NUM" )[2]   , "", "", "C", "", "R", "", "", "", "A", "" } )
oGrid:AddColumn( {"Item"     , "ITEM"    , x3Picture("C8_ITEM"   ), TamSx3("C8_ITEM" )[1]  , TamSx3("C8_ITEM" )[2]  , "", "", "C", "", "R", "", "", "", "A", "" } )
oGrid:AddColumn( {"Proposta" , "PROPOSTA", x3Picture("C8_NUMPRO" ), TamSx3("C8_NUMPRO" )[1], TamSx3("C8_NUMPRO" )[2], "", "", "C", "", "R", "", "", "", "A", "" } )
oGrid:AddColumn( {"Fornec."  , "FORNECE" , x3Picture("A2_CODIGO" ), TamSx3("A2_COD"    )[1], TamSx3("A2_COD"    )[2], "", "", "C", "", "R", "", "", "", "A", "" } )
oGrid:AddColumn( {"Lj."      , "LOJA"    , x3Picture("A2_LOJA"   ), TamSx3("A2_LOJA"   )[1], TamSx3("A2_LOJA"   )[2], "", "", "C", "", "R", "", "", "", "A", "" } )
oGrid:AddColumn( {"Razão Soc", "NOMEFOR" , x3Picture("A2_NOME"   ), TamSx3("A2_NOME"   )[1], TamSx3("A2_NOME"   )[2], "", "", "C", "", "R", "", "", "", "A", "" } )
oGrid:AddColumn( {"Produto"  , "PRODUTO" , x3Picture("C8_PRODUTO"), TamSx3("C8_PRODUTO")[1], TamSx3("C8_PRODUTO")[2], "", "", "C", "", "R", "", "", "", "A", "" } )
oGrid:AddColumn( {"Descrição", "DESCRIC" , x3Picture("B1_DESC"   ), TamSx3("B1_DESC"   )[1], TamSx3("B1_DESC"   )[2], "", "", "C", "", "R", "", "", "", "A", "" } )
oGrid:AddColumn( {"It.Pedido", "ITEMPED" , x3Picture("C8_ITEMPED"), TamSx3("C8_ITEMPED")[1], TamSx3("C8_ITEMPED")[2], "", "", "C", "", "R", "", "", "", "A", "" } )
oGrid:AddColumn( {"UM"       , "UM"      , x3Picture("C8_UM"     ), TamSx3("C8_UM"     )[1], TamSx3("C8_UM"     )[2], "", "", "C", "", "R", "", "", "", "A", "" } )
oGrid:AddColumn( {"Qtde"     , "QUANT"   , x3Picture("C8_QUANT"  ), TamSx3("C8_QUANT"  )[1], TamSx3("C8_QUANT"  )[2], "", "", "N", "", "R", "", "", "", "A", "" } )
oGrid:AddColumn( {"Vlr.Unit" , "PRECO"   , x3Picture("C8_PRECO"  ), TamSx3("C8_PRECO"  )[1], TamSx3("C8_PRECO"  )[2], "", "", "N", "", "R", "", "", "", "A", "" } )
oGrid:AddColumn( {"Total"    , "TOTAL"   , x3Picture("C8_TOTAL"  ), TamSx3("C8_TOTAL"  )[1], TamSx3("C8_TOTAL"  )[2], "", "", "N", "", "R", "", "", "", "A", "" } )
oGrid:AddColumn( {"Condição" , "COND"    , x3Picture("C8_COND"   ), TamSx3("C8_COND"   )[1], TamSx3("C8_COND"   )[2], "", "", "C", "", "R", "", "", "", "A", "" } )
oGrid:AddColumn( {"Descrição", "DESCOND" , x3Picture("E4_DESCRI" ), TamSx3("E4_DESCRI" )[1], TamSx3("E4_DESCRI" )[2], "", "", "C", "", "R", "", "", "", "A", "" } )
oGrid:AddColumn( {"Prz.Dias ", "PRAZO"   , x3Picture("C8_PRAZO"  ), TamSx3("C8_PRAZO"  )[1], TamSx3("C8_PRAZO"  )[2], "", "", "C", "", "R", "", "", "", "A", "" } )
oGrid:AddColBmp( "STATUS" )

oGrid:SeekSet() // Ativa pesquisa
oGrid:SheetSet() // Ativa planilha
oGrid:IndexSet() // Ativa Ordenação
                         
oGrid:AddButton( "Legendas", {||Legenda()}  ) 

oGrid:Load()
            
oGrid:SetAlignAllClient()
                        
// Gera o arquivo temporário e Carrega os dados na grid
GeraTmp( cPedido, @oGrid )               

oDlg:oDlg:bInit := { || oGrid:oGrid:GoBottom(), oGrid:oGrid:GoTop() }

oDlg:Activate()
                       
RestArea( aAreaSC7 )
RestArea( aArea )

Return( nil )                  

//========================================================================================================
// GeraTmp   -  Alessandro Freire - Advpl Tecnologia                                           Junho/2015
//--------------------------------------------------------------------------------------------------------
// Descrição
// Cria o arquivo de trabalho com os dados das cotações
//--------------------------------------------------------------------------------------------------------
// Parâmetros
// nil
//--------------------------------------------------------------------------------------------------------
// Returno
// nil
//========================================================================================================
Static Function GeraTmp( cPedido, oGrid )

Local cAlias 
Local cArq    
Local cSql
Local cAliasSql := GetNextAlias()
Local aCmp      := {}                     
Local aArea     := GetArea()
Local nLoop

AAdd( aCmp, {"STATUS"  , "C", 020                    , 0 } )
AAdd( aCmp, {"COTACAO" , "C", TamSx3("C8_NUM"    )[1], 0 } )
AAdd( aCmp, {"ITEM"    , "C", TamSx3("C8_ITEM"   )[1], 0 } )
AAdd( aCmp, {"PROPOSTA", "C", TamSx3("C8_NUMPRO" )[1], 0 } )
AAdd( aCmp, {"PRODUTO" , "C", TamSx3("C8_PRODUTO")[1], 0 } )
AAdd( aCmp, {"DESCRIC" , "C", TamSx3("B1_DESC"   )[1], 0 } )
AAdd( aCmp, {"ITEMPED" , "C", TamSx3("C8_ITEMPED")[1], 0 } )
AAdd( aCmp, {"UM"      , "C", TamSx3("C8_UM"     )[1], 0 } )
AAdd( aCmp, {"QUANT"   , "N", TamSx3("C8_QUANT"  )[1], TamSx3("C8_QUANT"  )[2] } )  
AAdd( aCmp, {"PRECO"   , "N", TamSx3("C8_PRECO"  )[1], TamSx3("C8_PRECO"  )[2] } )
AAdd( aCmp, {"TOTAL"   , "N", TamSx3("C8_TOTAL"  )[1], TamSx3("C8_TOTAL"  )[2] } )  
AAdd( aCmp, {"COND"    , "C", TamSx3("C8_COND"   )[1], 0 } )  
AAdd( aCmp, {"DESCOND" , "C", TamSx3("E4_DESCRI" )[1], 0 } ) 
AAdd( aCmp, {"PRAZO"   , "N", TamSx3("C8_PRAZO"  )[1], TamSx3("C8_PRAZO"  )[2] } )  
AAdd( aCmp, {"FORNECE" , "C", TamSx3("C8_FORNECE")[1], 0 } ) 
AAdd( aCmp, {"LOJA"    , "C", TamSx3("C8_LOJA"   )[1], 0 } ) 
AAdd( aCmp, {"NOMEFOR" , "C", TamSx3("A2_NOME"   )[1], 0 } ) 

//----------------------------------------------------
// Cria o arquivo de trabalho
//----------------------------------------------------
cArq	:= CriaTrab(aCmp)
cAlias  := cArq
DbUseArea(.T.,__LocalDriver,cArq,cAlias)
                             
//----------------------------------------------------
// Adiciona registros ao arquivo de trabalho
//----------------------------------------------------
dbSelectArea("SC7")              
dbSetOrder(1)
dbSeek( xFilial("SC7") + cPedido )

While ! Eof() .and. xFilial("SC7")+cPedido == SC7->(C7_FILIAL+C7_NUM)
             
 	cSql := ""
	cSql += "SELECT CASE "
	cSql += "         WHEN SC8.C8_NUMPED <> '"+cPedido+"' AND SC8.C8_PRECO > 0 THEN 'BR_CINZA' "
	cSql += "		  WHEN SC8.C8_NUMPED = '"+cPedido+"' THEN 'BR_VERDE' "
	cSql += "		  WHEN SC8.C8_PRECO = 0 THEN 'BR_VERMELHO' "
	cSql += "	   END STATUS"
	cSql += "    , SC8.C8_NUM     COTACAO"
	cSql += "	 , SC8.C8_ITEM    ITEM"
	cSql += "	 , SC8.C8_NUMPRO  PROPOSTA"
	cSql += "	 , SC8.C8_PRODUTO PRODUTO"
	cSql += "    , SB1.B1_DESC    DESCRIC"
	cSql += "	 , SC8.C8_ITEMPED ITEMPED"
	cSql += "	 , SC8.C8_UM      UM"
	cSql += "	 , SC8.C8_QUANT   QUANT"
	cSql += "	 , SC8.C8_PRECO   PRECO"
	cSql += "	 , SC8.C8_TOTAL   TOTAL"
	cSql += "	 , SC8.C8_COND    COND"
	cSql += "	 , SE4.E4_DESCRI  DESCOND"
	cSql += "	 , SC8.C8_PRAZO   PRAZO"
	cSql += "	 , SC8.C8_FORNECE FORNECE"
	cSql += "	 , SC8.C8_LOJA    LOJA"
	cSql += "	 , SA2.A2_NOME    NOMEFOR"

	cSql += "  FROM "+RetSqlName("SC8")+" SC8"
	cSql += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_FILIAL = '"+xFilial("SA2")+"'"
	cSql += "                      AND SA2.A2_COD = SC8.C8_FORNECE"
	cSql += "					   AND SA2.A2_LOJA = SC8.C8_LOJA"
	cSql += "					   AND SA2.D_E_L_E_T_ = ' '"
	cSql += "  LEFT JOIN "+RetSqlName("SE4")+" SE4 ON SE4.E4_FILIAL = '"+xFilial("SE4")+"'"
	cSql += "                      AND SE4.E4_CODIGO = SC8.C8_COND"
	cSql += "                      AND SE4.D_E_L_E_T_ = ' '"

	cSql += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql += "                      AND SB1.B1_COD = SC8.C8_PRODUTO"
	cSql += "                      AND SB1.D_E_L_E_T_ = ' '"

	cSql += " WHERE SC8.D_E_L_E_T_ = ' '"
	cSql += "   AND SC8.C8_NUM     = '"+SC7->C7_NUMCOT +"'"
	cSql += "   AND SC8.C8_PRODUTO = '"+SC7->C7_PRODUTO+"'"
	cSql += "   AND SC8.C8_FILIAL  = '"+xFilial("SC7") +"'"

	cSql += " ORDER BY SC8.C8_ITEMPED, SC8.C8_FORNECE, SC8.C8_LOJA, SC8.C8_NUMPRO"
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),cAliasSql,.F., .T.)
    dbGoTop()
    lGrvSql := .f.
    While ! Eof() 
    	lGrvSql := .t.              
    	RecLock( cAlias, .t. )
    	For nLoop := 1 to FCount()
    		cField := FieldName(nLoop)
    		xCont  := (cAliasSql)->&(cField)
    		FieldPut( nLoop, xCont)
    	Next nLoop
    	MsUnlock()
    	dbSelectArea( cAliasSql )
    	dbSkip()
    Enddo             
                             
	(cAliasSql)->(dbCloseArea()) 
	dbSelectArea( cAlias )
	
	//----------------------------------------------------
	// Se não houver cotações, grava o item do pedido
	// no arquivo de trabalho
	//----------------------------------------------------
    If ! lGrvSql
    	RecLock( cAlias, .t. )
    	(cAlias)->STATUS  := "BR_AMARELO"
    	(cAlias)->PRODUTO := SC7->C7_PRODUTO
    	(cAlias)->DESCRIC := Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO, "B1_DESC" )
    	(cAlias)->ITEMPED := SC7->C7_ITEM
    	(cAlias)->UM      := SC7->C7_UM
    	MsUnlock()
    EndIf
	
	dbSelectArea("SC7")
	dbSkip()
	
Enddo                                  

// carrega os dados na grid
oGrid:FromTmp( cAlias )

dbSelectArea( cAlias )
dbCloseArea()                                                        
Ferase(cArq+GetDBExtension())

RestArea( aArea )
Return( nil )

//========================================================================================================
// Legenda   -  Alessandro Freire - Advpl Tecnologia                                           Junho/2015
//--------------------------------------------------------------------------------------------------------
// Descrição
// Abre dialog com as legendas do grid
//--------------------------------------------------------------------------------------------------------
// Parâmetros
// nil
//--------------------------------------------------------------------------------------------------------
// Returno
// nil
//========================================================================================================

Static Function Legenda()
                                 
Local aLegenda := {}

AAdd( aLegenda, { "BR_CINZA"   , "Cotação perdedora  " } ) 
AAdd( aLegenda, { "BR_VERDE"   , "Cotação vencedora  " } )
AAdd( aLegenda, { "BR_VERMELHO", "Cotação sem análise" } )
AAdd( aLegenda, { "BR_AMARELO" , "Item sem cotação   " } )

BrwLegenda("Legendas", "Status", aLegenda)
                              
Return( nil )

