#include "totvs.ch"
#DEFINE ARR_TAMANHO    9 // Tamanho do array
#DEFINE ARR_ENDERECO   1 // Endereco do produto no armazem de origem
#DEFINE ARR_PRODUTO    2 // codigo do produto
#DEFINE ARR_DESCRICAO  3 // descricao do prduto
#DEFINE ARR_ARMORI     4 // armazem de origem
#DEFINE ARR_LOTE       5 // lote
#DEFINE ARR_QUANTIDADE 6 // quantidade
#DEFINE ARR_ARMDEST    7 // armazem de destino
#DEFINE ARR_MENSAGEM   8 // Mensagem
#DEFINE ARR_UM         9 // Mensagem

//========================================================================================================
// MIDR0001 - Alessandro Freire - OUTUBRO / 2015
//--------------------------------------------------------------------------------------------------------
// Descrição
// Relatório de separação de marcadorias FIFO
//--------------------------------------------------------------------------------------------------------
// Parametros
// nil
//--------------------------------------------------------------------------------------------------------
// Retorno
// nil
//========================================================================================================
User Function MIDR0001()

Local cPerg := "MIDR0001"
Local oPerg := AdvPlPerg():New(cPerg)                            

Private aRel := {}, nLoop := 1
               
//-------------------------------------------
// Ajusta os parâmetros
//-------------------------------------------
oPerg:AddPerg( "Plano Inicial", "C", 20  )
oPerg:AddPerg( "Plano Final"  , "C", 20  )
oPerg:AddPerg( "OP Inicial"   , "C", 6   )
oPerg:AddPerg( "OP Final"     , "C", 6   ) 

oPerg:SetPerg()
                                    
oReport := ReportDef( cPerg )
oReport:PrintDialog()

Return( nil )

//=================================================================================================================
// ReportDef() -                           Alessandro de Barros Freire                             - Outubro / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Cria o objeto que define o relatorio
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros
// nil
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Static Function ReportDef( cPerg )

Local oReport                  

//---------------------------------------
// Criação do componente de impressão
//---------------------------------------
// TReport():New
// ExpC1 : Nome do relatorio
// ExpC2 : Titulo
// ExpC3 : Pergunte
// ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao
// ExpC5 : Descricao
//---------------------------------------
oReport := TReport():New( cPerg , "Pick List", cPerg, {|oReport| ReportPrint(oReport)}, "Imprime o Pick List de produtos a transferir pelo coletor de dados" )
oReport:SetTotalInLine(.F.)
Pergunte(oReport:uParam, .F.)

//---------------------------------------
// Criação da seção utilizada pelo relatório
//
// TRSection():New
// ExpO1 : Objeto TReport que a seção pertence
// ExpC2 : Descrição da seçao
// ExpA3 : Array com as tabelas utilizadas pela seção. A primeira tabela será considerada como principal para a seção.
// ExpA4 : Array com as ordens do relatório
// ExpL5 : Carrega campos do SX3 como celulas
// Default : False
// ExpL6 : Carrega ordens do Sindex
// Default : False
//---------------------------------------

//---------------------------------------
// Criação da celulas da seção do relatório
//
// TRCell():New
// ExpO1 : Objeto TSection que a secao pertence
// ExpC2 : Nome da celula do relatório. O SX3 será consultado
// ExpC3 : Nome da tabela de referencia da celula
// ExpC4 : Titulo da celula
// Default : X3Titulo()
// ExpC5 : Picture
// Default : X3_PICTURE
// ExpC6 : Tamanho
// Default : X3_TAMANHO
// ExpL7 : Informe se o tamanho esta em pixel
// Default : False
// ExpB8 : Bloco de código para impressao.
// Default : ExpC2
//---------------------------------------
oSection := TRSection():New(oReport, "Pick List", "NNR", /*{Array com as ordens do relatório}*/, /*Campos do SX3*/, /*Campos do SIX*/)
oSection:SetTotalInLine(.F.)

TRCell():New(oSection, "NNR_CODIGO" , "NNR", "Armazém Destino", /*Picture*/, /*Tamanho*/, /*lPixel*/, {|| NNR->NNR_CODIGO } )
TRCell():New(oSection, "NNR_DESCRI" , "NNR", "Descrição"      , /*Picture*/, /*Tamanho*/, /*lPixel*/, {|| NNR->NNR_DESCRI } )

oSection2 := TRSection():New(oSection, "Produtos", "SD4", /*{Array com as ordens do relatório}*/, /*Campos do SX3*/, /*Campos do SIX*/)

TRCell():New(oSection2, "B1_LOCPAD"  , "SB1", "Armazém Origem", /*Picture*/, /*Tamanho*/, /*lPixel*/, {|| aRel[nLoop,ARR_ARMORI]    } )
TRCell():New(oSection2, "BF_LOCALIZ" , "SBF", "Endereço"      , /*Picture*/, /*Tamanho*/, /*lPixel*/, {|| aRel[nLoop,ARR_ENDERECO]  } )
TRCell():New(oSection2, "B8_LOTECTL" , "SB8", "Lote"          , /*Picture*/, /*Tamanho*/, /*lPixel*/, {|| aRel[nLoop,ARR_LOTE]      } )
TRCell():New(oSection2, "BF_PRODUTO" , "SBF", "Produto"       , /*Picture*/, /*Tamanho*/, /*lPixel*/, {|| aRel[nLoop,ARR_PRODUTO]   } )
TRCell():New(oSection2, "B1_DESC"    , "SB1", "Descrição"     , /*Picture*/, /*Tamanho*/, /*lPixel*/, {|| aRel[nLoop,ARR_DESCRICAO] } )
TRCell():New(oSection2, "B8_SALDO"   , "SB8", "Quantidade"    , /*Picture*/, /*Tamanho*/, /*lPixel*/, {|| aRel[nLoop,ARR_QUANTIDADE]} )
TRCell():New(oSection2, "B1_UM"      , "SB1", "UM"            , /*Picture*/, /*Tamanho*/, /*lPixel*/, {|| aRel[nLoop,ARR_UM]        } )
//TRCell():New(oSection2, "B8_LOCAL"   , "SB8", /*Titulo*/  , /*Picture*/, /*Tamanho*/, /*lPixel*/, {|| aRel[nLoop,ARR_ARMDEST]   } )
TRCell():New(oSection2, "MENSAGEM"   , "SB8", "Mensagem"      , "@!"       , 30         , /*lPixel*/, {|| aRel[nLoop,ARR_MENSAGEM]  } )

oSection2:SetTotalInLine(.F.)

Return( oReport )

//=================================================================================================================
// ReportPrint() -                        Alessandro de Barros Freire                             - Outubro / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Imprime o relatório
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros
// oReport - objeto contendo as definições do relatório
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================

Static Function ReportPrint(oReport)

Local aArea       := GetArea()
Local cArmDest    := ""
Local nConta      := 1
Local nLoop
          
// popula aRel              
aRel := {}          
Processa( {|| aRel := DadosRel() }, "Filtrando Registros..." )

//-------------------------------------------
// Inicio da impressao do fluxo do relatório
//-------------------------------------------
oReport:SetMeter(Len(aRel))
                    
For nLoop := 1 to Len( aRel )

	If oReport:Cancel() 
		Exit
	EndIf
	                                         
	//----------------------------------------
	// Executa a quebra por armazém de destino
	//----------------------------------------
	If cArmDest <> aRel[nLoop,ARR_ARMDEST]
                                                         
 		cArmDest := aRel[nLoop,ARR_ARMDEST]
		NNR->(dbSetOrder(1))
		NNR->(dbSeek(xFilial("NNR")+cArmDest))
           
        //----------------------------------------                          
        // Encerra a quebra por armazem           
        //----------------------------------------
   		If nLoop > 1                         
   			oReport:Section(1):Section(1):Finish()
   			oReport:Section(1):Finish()
   		EndIf
   		                                          
   		//----------------------------------------
   		// Inicia a quebra por armazem            
   		//----------------------------------------
		oReport:Section(1):Init()
		oReport:Section(1):PrintLine()
		
		oReport:Section(1):Section(1):Init()
		
	EndIf
    
	//----------------------------------------
   	// Impressão zebrada. verifica se imprime
   	// o fundo branco ou o fundo cinza            
	//----------------------------------------
	If ( nconta % 2 ) == 0
		nCor := CLR_HGRAY
	Else
		nCor := CLR_WHITE
	endIf       

	//-----------------------------------------
	// Carrega os dados de cada campo
	//-----------------------------------------
	oReport:Section(1):Section(1):Cell("B1_LOCPAD" ):SetClrBack(nCor) //cor da fonte
	oReport:Section(1):Section(1):Cell("BF_LOCALIZ"):SetClrBack(nCor) //cor da fonte
	oReport:Section(1):Section(1):Cell("B8_LOTECTL"):SetClrBack(nCor) //cor da fonte
	oReport:Section(1):Section(1):Cell("BF_PRODUTO"):SetClrBack(nCor) //cor da fonte
	oReport:Section(1):Section(1):Cell("B1_DESC"   ):SetClrBack(nCor) //cor da fonte
	oReport:Section(1):Section(1):Cell("B8_SALDO"  ):SetClrBack(nCor) //cor da fonte
	oReport:Section(1):Section(1):Cell("B1_UM"     ):SetClrBack(nCor) //cor da fonte
//	oReport:Section(1):Section(1):Cell("B8_LOCAL"  ):SetClrBack(nCor) //cor da fonte
	oReport:Section(1):Section(1):Cell("MENSAGEM"  ):SetClrBack(nCor) //cor da fonte
	
	//-----------------------------------------
	// Imprime a linha
	//-----------------------------------------
	oReport:Section(1):Section(1):PrintLine()
	nConta ++

	oReport:IncMeter()

Next nLoop

oReport:Section(1):Section(1):Finish()
oReport:Section(1):Finish()
oReport:Section(1):SetPageBreak(.T.)

dbCloseArea()
RestArea( aArea )
Return( nil )

//========================================================================================================
// DadosRel - Alessandro Freire - OUTUBRO / 2015
//--------------------------------------------------------------------------------------------------------
// Descrição
// Grava os itens que devem compor o relatório em um array
//--------------------------------------------------------------------------------------------------------
// Parametros
// nil
//--------------------------------------------------------------------------------------------------------
// Retorno
// aRel - Array com os itens do relatório
// [1] Endereco
// [2] Produto
// [3] Armazem
// [4] Descricao
// [5] Lote
// [6] Quantidade
// [7] Armazem destino
// [8] Mensagem
//========================================================================================================
Static Function DadosRel( ) 

Local cAlias    := GetNextAlias()                    
Local cAliasTrb := GetNextAlias()

Local aArea     := GetArea()   
Local aTrab     := {}

Local nQtdParc  := 0    

Local cSql      := SqlEndLote( mv_par01, mv_par02, mv_par03, mv_par04, .f. )
Local cSemSaldo := ""
Local cLocPad   := "01"
Local cMsg      := ""
Local cTrb      := ""
Local cTrbInd   := ""

aRel := {}
         
//------------------------------------------------------------------
// Cria arquivo de trabalho que irá armazenar a quantidade
// total necessária do produto + armazém
//------------------------------------------------------------------
AAdd( aTrab, { "RASTRO"    , "C", TamSx3("B1_RASTRO" )[1], 0                       } )
AAdd( aTrab, { "LOCALIZ"   , "C", TamSx3("B1_LOCALIZ")[1], 0                       } )           
AAdd( aTrab, { "ARMORI"    , "C", TamSx3("B1_LOCPAD" )[1], 0                       } )           
AAdd( aTrab, { "PRODUTO"   , "C", TamSx3("B1_COD"    )[1], 0                       } )
AAdd( aTrab, { "DESCRICAO" , "C", TamSx3("B1_DESC"   )[1], 0                       } )
AAdd( aTrab, { "UM"        , "C", TamSx3("B1_UM"     )[1], 0                       } )
AAdd( aTrab, { "TOTEMP"    , "N", TamSx3("D4_QTDEORI")[1], TamSx3("D4_QTDEORI")[2] } )
AAdd( aTrab, { "JAEMP"     , "N", TamSx3("D4_QTDEORI")[1], TamSx3("D4_QTDEORI")[2] } )
AAdd( aTrab, { "NECEMP"    , "N", TamSx3("D4_QTDEORI")[1], TamSx3("D4_QTDEORI")[2] } )
AAdd( aTrab, { "LIVRE"     , "N", TamSx3("D4_QTDEORI")[1], TamSx3("D4_QTDEORI")[2] } )

ProcRegua(0)
IncProc("Criando arquivo de trabalho...")
IncProc("Criando arquivo de trabalho...")
IncProc("Criando arquivo de trabalho...")
               
cTrb    := CriaTrab(aTrab,.T.)
dbUseArea(.T.,, cTrb, "TRB",.F.,.F.)
cTrbInd := CriaTrab(NIL,.F.)
IndRegua("TRB",cTrbInd,"PRODUTO+ARMORI",,,"Criando Indice...")
dbSelectArea("TRB")
dbSetOrder(1)                                                            

//---------------------------------------------------------
// Atualiza o arquivo de trabalho                    
//---------------------------------------------------------
ProcRegua(0)
IncProc("Atualizando arquivo de temporário...")
IncProc("Atualizando arquivo de temporário...")
IncProc("Atualizando arquivo de temporário...")
AtuArqTrb( mv_par01, mv_par02, mv_par03, mv_par04, "TRB" )

ProcRegua(0)
IncProc("Abrindo consulta no banco de dados...")
IncProc("Abrindo consulta no banco de dados...")
IncProc("Abrindo consulta no banco de dados...")
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAlias,.f.,.t.)
dbGoTop() 
           
nRecs := 0
While ! Eof()
	IncProc("Contando registros: " + AllTrim(Str(nRecs)))
	nRecs ++
	dbSkip()                     
enddo

ProcRegua(nRecs)
dbGoTop()
nRec := 0
While ! Eof() 
    nRec ++
	IncProc("Registro " + AllTrim(Str(nRec)) + " de " + AllTrim(Str(nRecs)) )
	                                      
	dbSelectArea("TRB")
	dbSetOrder(1) 
	dbSeek( (cAlias)->PRODUTO + (cAlias)->ARMORI )

	//-------------------------------------------------
	// nao tem necessidade de empenhar
	//-------------------------------------------------
	dbSelectArea( cAlias )
	If TRB->NECEMP <= 0
		dbSkip()
		Loop
	EndIf
    
	//-------------------------------------------------
	// nao tem saldo em estoque suficiente
	//-------------------------------------------------
	If TRB->LIVRE < TRB->NECEMP
		//-----------------------------------
		// Cria nova linha no array
		//-----------------------------------
		AAdd( aRel, Array(ARR_TAMANHO) )
		nPos := Len( aRel )

		aRel[nPos][ARR_ENDERECO   ] := " "
		aRel[nPos][ARR_PRODUTO    ] := (cAlias)->PRODUTO
		aRel[nPos][ARR_DESCRICAO  ] := (cAlias)->DESCRICAO
		aRel[nPos][ARR_ARMORI     ] := (cAlias)->ARMORI
		aRel[nPos][ARR_LOTE       ] := " "
		aRel[nPos][ARR_QUANTIDADE ] := 0           
		aRel[nPos][ARR_UM         ] := (cAlias)->UM
		aRel[nPos][ARR_ARMDEST    ] := (cAlias)->ARMDEST
		aRel[nPos][ARR_MENSAGEM   ] := "Saldo disponível insuficiente."
	
		dbSelectArea( cAlias )
		dbSkip()
		Loop
		
	EndIf    
	
	//--------------------------------------
	// Tratamento para produtos que não 
	// controlam lote ou endereço
	//--------------------------------------
	If (cAlias)->RASTRO <> "L"  .and. (cAlias)->LOCALIZ <> "S"

		//-----------------------------------
		// Cria nova linha no array
		//-----------------------------------
		AAdd( aRel, Array(ARR_TAMANHO) )
		nPos := Len( aRel )

		//-----------------------------------
		// Popula a nova linha no array
		//-----------------------------------		
		aRel[nPos][ARR_ENDERECO   ] := " "
		aRel[nPos][ARR_PRODUTO    ] := (cAlias)->PRODUTO
		aRel[nPos][ARR_DESCRICAO  ] := (cAlias)->DESCRICAO
		aRel[nPos][ARR_ARMORI     ] := (cAlias)->ARMORI
		aRel[nPos][ARR_LOTE       ] := " "
		aRel[nPos][ARR_QUANTIDADE ] := (cAlias)->NECEMP     
		aRel[nPos][ARR_UM         ] := (cAlias)->UM
		aRel[nPos][ARR_ARMDEST    ] := (cAlias)->ARMDEST
		aRel[nPos][ARR_MENSAGEM   ] := " "

	EndIf
 
	//-----------------------------------------
	// Tratamento para produtos que controlam 
	// lote E/OU endereço
	//-----------------------------------------
	If (cAlias)->RASTRO == "L" .or. (cAlias)->LOCALIZ == "S"
		//-----------------------------------------------
		// Monta query com os lotes/quantidade do
		// produto posicionado em cAlias
		//-----------------------------------------------
		cAliasSB8 := GetNextAlias()
	                     
	 	If (cAlias)->RASTRO == "L"
			cSqlSB8   := "SELECT SB8.B8_PRODUTO PRODUTO "
			cSqlSB8   += "     , SB8.B8_LOCAL   ARMORI "
		 	cSqlSB8   += "     , SB8.B8_LOTECTL LOTE "
		 	cSqlSB8   += "     , SB8.B8_DTVALID VALIDADE "
			cSqlSB8   += "     , COALESCE( SBF.BF_LOCALIZ, ' ' ) ENDERECO "
			cSqlSB8   += "     , COALESCE( SBF.BF_QUANT - SBF.BF_EMPENHO, SB8.B8_SALDO - SB8.B8_EMPENHO ) QTLIVRE "
			cSqlSB8   += "  FROM "+RetSqlName("SB8")+" SB8 "
			cSqlSB8   += "  LEFT JOIN "+RetSqlName("SBF")+" SBF ON SBF.BF_FILIAL  = '"+xFilial("SBF")+"' "
			cSqlSB8   += "                                     AND SBF.BF_LOTECTL = SB8.B8_LOTECTL "
			cSqlSB8   += "                                     AND SBF.BF_PRODUTO = SB8.B8_PRODUTO "
			cSqlSB8   += "                                     AND SBF.BF_LOCAL = SB8.B8_LOCAL "
			cSqlSB8   += "                                     AND SBF.BF_QUANT > SBF.BF_EMPENHO   "
			cSqlSB8   += "                                     AND SBF.D_E_L_E_T_ = ' ' "
			cSqlSB8   += " WHERE SB8.B8_FILIAL = '"+xFilial("SB8")+"' "
			cSqlSB8   += "   AND SB8.B8_SALDO > SB8.B8_EMPENHO "
			cSqlSB8   += "   AND SB8.B8_PRODUTO = '"+ (cAlias)->PRODUTO +"' "
			cSqlSB8   += "   AND SB8.B8_LOCAL = '"  + (cAlias)->ARMORI  +"' "
			cSqlSB8   += "   AND SB8.D_E_L_E_T_ = ' ' "
			cSqlSB8   += " ORDER BY  4,3,5 " 
		Else
			cSqlSB8   := "SELECT SBF.BF_PRODUTO PRODUTO "
			cSqlSB8   += "     , SBF.BF_LOCAL   ARMORI "
		 	cSqlSB8   += "     , SBF.BF_LOTECTL LOTE "
		 	cSqlSB8   += "     , ' '            VALIDADE "
			cSqlSB8   += "     , SBF.BF_LOCALIZ ENDERECO "
			cSqlSB8   += "     , SBF.BF_QUANT - SBF.BF_EMPENHO QTLIVRE "
			cSqlSB8   += "  FROM "+RetSqlName("SBF")+" SBF "
			cSqlSB8   += " WHERE SBF.BF_FILIAL  = '"+xFilial("SBF")+"' "
			cSqlSB8   += "   AND SBF.BF_LOTECTL = ' ' "
			cSqlSB8   += "   AND SBF.BF_PRODUTO = '"+ (cAlias)->PRODUTO +"' "
			cSqlSB8   += "   AND SBF.BF_LOCAL = '"  + (cAlias)->ARMORI  +"' "
			cSqlSB8   += "   AND SBF.BF_QUANT > SBF.BF_EMPENHO   "
			cSqlSB8   += "   AND SBF.D_E_L_E_T_ = ' ' "
			cSqlSB8   += " ORDER BY  4,3,5 " 
		EndIf	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSqlSB8),cAliasSB8,.f.,.t.)
		dbGoTop()
		
		nQtdParc := 0
		While ! Eof()
		             
		    //----------------------------------------------------
			// Se já peguei a quantidade necessária, saio do loop
			//----------------------------------------------------
			If nQtdParc >= (cAlias)->NECEMP
				Exit
			EndIf   
			                                                      
			//----------------------------------------------------
			// Saldo restante a pegar do estoque                  
			//----------------------------------------------------
			nSaldo := (cAlias)->NECEMP - nQtdParc  
			                
			//------------------------------------------------------
			// Se o saldo restante for menor do que a quantidade
			// livre no lote, pega do lote só o saldo restante
			//------------------------------------------------------
			nQtPega := 0
			If ( nSaldo ) <= (cAliasSB8)->QTLIVRE
				nQtPega := nSaldo
			Else 
				nQtPega := (cAliasSB8)->QTLIVRE
			EndIf
		
			//-----------------------------------
			// Cria nova linha no array
			//-----------------------------------
			AAdd( aRel, Array(ARR_TAMANHO) )
			nPos := Len( aRel )

			//-----------------------------------
			// Popula a nova linha no array
			//-----------------------------------		
			aRel[nPos][ARR_ENDERECO   ] := (cAliasB8)->ENDERECO
			aRel[nPos][ARR_PRODUTO    ] := (cAlias)->PRODUTO
			aRel[nPos][ARR_DESCRICAO  ] := (cAlias)->DESCRICAO
			aRel[nPos][ARR_ARMORI     ] := (cAlias)->ARMORI
			aRel[nPos][ARR_LOTE       ] := (cAliasSB8)->LOTE
			aRel[nPos][ARR_QUANTIDADE ] := nQtPega      
			aRel[nPos][ARR_UM         ] := (cAlias)->UM
			aRel[nPos][ARR_ARMDEST    ] := (cAlias)->ARMDEST
			aRel[nPos][ARR_MENSAGEM   ] := " "
				
			nQtdParc += nSaldo 
			
			dbSelectArea(cAliasSB8)
			dbSkip()
			
		Enddo
		//----------------------------------------
		// Fecha a área temporária do lote
		//---------------------------------------- 
		dbSelectArea(cAliasSB8)
		dbCloseArea()                             
		
	EndIf
	
	dbSelectArea( cAlias )                     
	dbSkip()
Enddo
            
dbSelectArea( cAlias )
dbCloseArea()                     

dbSelectArea( "TRB" )
dbCloseArea()
FErase( cTrbInd + OrdBagExt() )

RestArea( aArea )
ProcRegua(0)
IncProc("Organizando dados...")
IncProc("Organizando dados...")
IncProc("Organizando dados...")
aSort( aRel,,,{|x,y| x[ARR_ARMDEST]+x[ARR_ARMORI]+x[ARR_ENDERECO]+x[ARR_LOTE]+x[ARR_DESCRICAO] < y[ARR_ARMDEST]+y[ARR_ARMORI]+y[ARR_ENDERECO]+y[ARR_LOTE]+y[ARR_DESCRICAO] } )

Return( aRel  )
                                   
***********************************************************************************************************************************
** AtuArqTrb()                                    
** Atualiza o arquivo de trabalho
** campos: RASTRO, LOCALIZ, PRODUTO, DESCRICAO, UM, ARMDEST, ARMORI, TOTEMP, JAEMP
** indice: ARMORI, PRODUTO
***********************************************************************************************************************************
Static Function AtuArqTrb( cPlIni, cPlFim, cOpIni, cOpFim, cAliasTrb )

Local cAliasSql := GetNextAlias()                                    
Local lTotal    := .t.
Local cSql      := SqlEndLote( cPlIni, cPlFim, cOpIni, cOpFim, lTotal )
                                                
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasSql,.f.,.t.)
dbGoTop()
                                       
While ! Eof()    

	IncProc()

	dbSelectArea( cAliasTrb )
	dbSetOrder(1)
	
	RecLock( cAliasTrb, .T. )               
	
	(cAliasTrb)->RASTRO    := (cAliasSql)->RASTRO
	(cAliasTrb)->LOCALIZ   := (cAliasSql)->LOCALIZ
	(cAliasTrb)->ARMORI    := (cAliasSql)->ARMORI
	(cAliasTrb)->PRODUTO   := (cAliasSql)->PRODUTO
	(cAliasTrb)->DESCRICAO := (cAliasSql)->DESCRICAO
	(cAliasTrb)->UM        := (cAliasSql)->UM
	(cAliasTrb)->TOTEMP    := (cAliasSql)->TOTEMP
	(cAliasTrb)->JAEMP     := (cAliasSql)->JAEMP
	(cAliasTrb)->NECEMP    := (cAliasSql)->NECEMP
	(cAliasTrb)->LIVRE     := 0
	MsUnlock()                                   
	
	If (cAliasTrb)->RASTRO == "L"
		//-------------------------------------
		// Controla lote
		//-------------------------------------
		dbSelectArea("SB8")
		dbSetOrder(1)
		If dbSeek( xFilial("SB8") + (cAliasTrb)->PRODUTO + (cAliasTrb)->ARMORI )
			nLivre := 0
			While ! Eof() .and. (cAliasTrb)->(xFilial("SB8") + PRODUTO + ARMORI) == SB8->(B8_FILIAL + B8_PRODUTO + B8_LOCAL)
	
				If nLivre >= (cAliasTrb)->NECEMP
					Exit
				EndIf
	
				If SB8->B8_DTVALID < dDataBase
					dbSkip()
					Loop
				EndIf
	
				nLivre += SB8->B8_SALDO - SB8->B8_EMPENHO
				dbSkip()                
	
			Enddo
		    Reclock( cAliasTrb, .f. )
		    (cAliasTrb)->LIVRE := nLivre
		    MsUnlock()
		EndIf           
	Else
		If (cAliasTrb)->LOCALIZ == "S" 
			//-------------------------------------
			// Controla Endereço
			//-------------------------------------
			dbSelectArea("SBF")
			dbSetOrder(2)
			If dbSeek( xFilial("SBF") + (cAliasTrb)->PRODUTO + (cAliasTrb)->ARMORI )
				nLivre := 0
				While ! Eof() .and. (cAliasTrb)->(xFilial("SBF") + PRODUTO + ARMORI) == SBF->(BF_FILIAL + BF_PRODUTO + BF_LOCAL)
	
					If nLivre >= (cAliasTrb)->NECEMP
						Exit
					EndIf
	
					nLivre += ( SBF->BF_QUANT - SBF->BF_EMPENHO)
					dbSkip()
	
				Enddo
				Reclock( cAliasTrb, .f. )
		    	(cAliasTrb)->LIVRE := nLivre
		    	MsUnlock()
			EndIf
		Else
			//-------------------------------------
			// Não Controla Lote e nem Endereço
			//-------------------------------------  
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek( xFilial("SB2") + (cAliasTrb)->PRODUTO + (cAliasTrb)->ARMORI )
				Reclock( cAliasTrb, .f. )
				(cAliasTrb)->LIVRE := SB2->B2_QATU - SB2->B2_QEMP
				MsUnlock()
			EndIf
			
		EndIf
		
	EndIf
     
	dbSelectArea( cAliasSql )
	dbSkip()
	
Enddo 

dbSelectArea( cAliasSql )
dbCloseArea()

dbSelectArea( cAliasTrb )

Return( nil )

 
***********************************************************************************************************************************
** SqlEndLote()                                    
**
***********************************************************************************************************************************
Static Function SqlEndLote( cPlIni, cPlFim, cOpIni, cOpFim, lTotal )
    
Local cSql := ""

cSql += "SELECT X.RASTRO "+CRLF
cSql += "     , X.LOCALIZ "+CRLF
cSql += "     , X.PRODUTO "+CRLF
cSql += "     , X.DESCRICAO "+CRLF
cSql += "     , X.UM "+CRLF

if ! lTotal
	cSql += "     , X.ARMDEST "+CRLF
endIf

cSql += "     , X.ARMORI "+CRLF
cSql += "     , SUM( X.TOTEMP ) TOTEMP "+CRLF
cSql += "     , SUM( X.JAEMP ) JAEMP "+CRLF
cSql += "     , SUM( X.TOTEMP ) - SUM( X.JAEMP ) NECEMP " +CRLF

cSql += "  FROM ( SELECT SB1.B1_RASTRO  RASTRO "+CRLF
cSql += "              , SB1.B1_LOCALIZ LOCALIZ "+CRLF
cSql += "              , SD4.D4_COD     PRODUTO "+CRLF
cSql += "              , SB1.B1_DESC    DESCRICAO "+CRLF
cSql += "              , SB1.B1_UM      UM "+CRLF
cSql += "              , SD4.D4_LOCAL   ARMDEST "+CRLF
cSql += "              , COALESCE( SBZ.BZ_LOCPAD, SB1.B1_LOCPAD ) ARMORI "+CRLF
cSql += "              , SD4.D4_QTDEORI TOTEMP "+CRLF
cSql += "              , SD4.D4_OP      OP "+CRLF
cSql += "              , SUM( COALESCE( SDC.DC_QTDORIG, 0 ) ) JAEMP "+CRLF
cSql += "              , SD4.R_E_C_N_O_  D4_REC "+CRLF
cSql += "           FROM "+RetSqlName("SD4")+" SD4 "+CRLF
cSql += "          INNER JOIN "+RetSqlName("SC2")+" SC2 ON SC2.C2_FILIAL = '"+xFilial("SC2")+"' "+CRLF
cSql += "                               AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN = SD4.D4_OP "+CRLF
cSql += "                               AND SC2.C2_OPMIDO BETWEEN '"+cPlIni+"' AND '"+cPlFim+"' "+CRLF
cSql += "                               AND SC2.C2_DATRF = ' ' "+CRLF
cSql += "                               AND SC2.D_E_L_E_T_ = ' ' "+CRLF
cSql += "          INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
cSql += "                               AND SB1.B1_COD = SD4.D4_COD "+CRLF
cSql += "                               AND SB1.D_E_L_E_T_ = ' ' "+CRLF
cSql += "           LEFT JOIN "+RetSqlName("SBZ")+" SBZ ON SBZ.BZ_FILIAL = '"+xFilial("SBZ")+"' "+CRLF
cSql += "                               AND SBZ.BZ_COD = SD4.D4_COD "+CRLF
cSql += "                               AND SBZ.D_E_L_E_T_ = ' ' "+CRLF
cSql += "           LEFT JOIN "+RetSqlName("SDC")+" SDC ON SDC.DC_FILIAL = '"+xFilial("SDC")+"' "+CRLF
cSql += "                               AND SDC.D_E_L_E_T_ = ' ' "+CRLF
cSql += "                               AND SDC.DC_PRODUTO = SD4.D4_COD "+CRLF
cSql += "                               AND SDC.DC_OP = SD4.D4_OP "+CRLF
cSql += "                               AND SDC.DC_LOCAL = SD4.D4_LOCAL "+CRLF
cSql += "          WHERE SD4.D4_FILIAL = '"+xFilial("SD4")+"' "+CRLF
cSql += "            AND SD4.D4_QTDEORI = SD4.D4_QUANT "+CRLF
cSql += "            AND SUBSTRING(SD4.D4_OP,1,6) BETWEEN '"+cOpIni+"' AND '"+cOpFim+"' "+CRLF
cSql += "            AND SD4.D4_LOTECTL = ' ' "+CRLF
cSql += "            AND SD4.D4_QTDEORI > 0 "+CRLF
cSql += "            AND SD4.D_E_L_E_T_ = ' ' "+CRLF
cSql += "          GROUP BY SB1.B1_RASTRO  "+CRLF
cSql += "              , SB1.B1_LOCALIZ "+CRLF
cSql += "              , SD4.D4_COD     "+CRLF
cSql += "              , SB1.B1_DESC    "+CRLF
cSql += "              , SB1.B1_UM      "+CRLF
cSql += "              , SD4.D4_LOCAL   "+CRLF
cSql += "              , COALESCE( SBZ.BZ_LOCPAD, SB1.B1_LOCPAD ) "+CRLF
cSql += "              , SD4.D4_QTDEORI "+CRLF
cSql += "              , SD4.D4_OP      "+CRLF
cSql += "              , SD4.R_E_C_N_O_ ) X "+CRLF

cSql += " WHERE X.ARMDEST <> X.ARMORI"+CRLF
           
// GROUP BY
cSql += " GROUP BY X.RASTRO "+CRLF
cSql += "     , X.LOCALIZ "+CRLF
cSql += "     , X.PRODUTO "+CRLF
cSql += "     , X.DESCRICAO "+CRLF
cSql += "     , X.UM "+CRLF
If ! lTotal
	cSql += "     , X.ARMDEST "+CRLF
EndIf
cSql += "     , X.ARMORI "+CRLF

// ORDER BY
cSql += " ORDER BY "      +CRLF
If ! lTotal
	cSql += "       X.ARMDEST "+CRLF
	cSql += "     , X.ARMORI "+CRLF
	cSql += "     , X.PRODUTO 
Else
	cSql += "       X.ARMORI "+CRLF
	cSql += "     , X.PRODUTO 
EndIf
Return( cSql )