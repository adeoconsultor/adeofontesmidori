#Include "Protheus.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTE01  ºAutor  ³Antonio             º Data ³  25/07/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de ajuste do estoque por lote                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Midori                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AJUSTELT()

Local oPerg
Local cUsuario := RetCodUsr()

Private cPerg := "AJUSTE01"

If !Alltrim(cUsuario) $ '001046'           //,000273'
	HS_MsgInf("Usuário não permitido a efetuar o acerto da movimentação do estoque por lote!!!","Atenção!!!","Movimentação por lote")
	Return( nil )
EndIf 

oPerg := AdvplPerg():New( cPerg )

//-------------------------------------------------------------------
//    AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
// Parametriza as perguntas
//-------------------------------------------------------------------
oPerg:AddPerg( "Produto De...: " ,"C",TamSx3("B1_COD")[1]    , , , "SB1")
oPerg:AddPerg( "Produto Até..: " ,"C",TamSx3("B1_COD")[1]    , , , "SB1")
oPerg:AddPerg( "Grupo........: " ,"C",TamSx3("B1_GRUPO")[1]  , , , "SBM")
oPerg:AddPerg( "Armazem......: " ,"C",TamSx3("B1_LOCPAD")[1] , , , "NNR")
oPerg:SetPerg()

If ! Pergunte( cPerg, .T. )
	Return( nil )
EndIf

If (Empty(MV_PAR01) .And. Empty(MV_PAR02)) .or. Empty(MV_PAR03)
	If EMpty(MV_PAR03)
		HS_MsgInf("Informe pelo menos o grupo para continuar o acerto da movimentação do estoque por lote! ","Atenção!!!","Movimentação por lote")
		Return( nil )
	EndIf 
	If (Empty(MV_PAR01) .And. Empty(MV_PAR02))
		If !MsgYesNo("Vc não Informou os produtos, tem certeza que o acerto da movimentação do estoque por lote será por grupo?")
			Return( nil )
		EndIf
	EndIf 

EndIf

If Alltrim(MV_PAR04) == '98' .OR. Alltrim(MV_PAR04) == 'LE'
	HS_MsgInf("Armazem não permitido efetuar o acerto da movimentação do estoque por lote!!!","Atenção!!!","Movimentação por lote")
	Return( nil )
EndIf 

MsgRun("Gerando Estoques/Movimentação por Lote !!!! Aguarde ...",,{|| fProcessa(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04) })

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fProcessa ºAutor  ³Antonio             º Data ³  16/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para processamento da Rotina.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MIDORI                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fProcessa(cProdDe,cProdAte,cGrupo,cLocal)

Local cSql      := "" 
Local cSql0     := "" 
Local cSql1     := "" 
Local cSql2     := "" 
Local cUAliaSB1 := GetNextAlias()
Local cUAliaSB2 := GetNextAlias()
Local cUAliaSD4 := GetNextAlias()
Local cUAliaCB0 := GetNextAlias()
Local cProduto:= ""

cSql0 := " SELECT SB1.B1_COD "
cSql0 += "  FROM " + RetSqlName("SB1") + " SB1 "
cSql0 += "   WHERE SB1.B1_FILIAL   = '" + xFilial("SB1") + "' "
cSql0 += "     AND SB1.D_E_L_E_T_  = ' '  "
If !Empty(cProdDe) .And. !Empty(cProdAte)
	cSql0 += "     AND SB1.B1_COD BETWEEN '" + cProdDe + "' AND '" + cProdAte + "'"
EndIf
cSql0 += "     AND SB1.B1_GRUPO =  '" + cGrupo + "' "
cSql0 += "  ORDER BY SB1.B1_COD "
dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql0),cUAliaSB1,.F.,.T.)


While (cUAliaSB1)->(!Eof()) 

	cProduto := (cUAliaSB1)->B1_COD

	SB1->(dbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+(cUAliaSB1)->B1_COD ) )
		RecLock("SB1",.F.)
		SB1->B1_RASTRO := 'L'
		MsUnlock()
	EndIf		

	(cUAliaSB1)->(dbSkip())

EndDo

cSql := " SELECT SB2.B2_COD  , "
cSql += "        SB2.B2_QATU , "
cSql += "        SB2.B2_LOCAL "
cSql += "  FROM " + RetSqlName("SB2") + " SB2 "
cSql += " JOIN "  + RetSqlName("SB1") + " SB1 ON SB1.B1_COD = SB2.B2_COD "
cSql += "     AND SB1.B1_FILIAL   = '" + xFilial("SB1") + "' "
cSql += "     AND SB1.D_E_L_E_T_  = ' ' "
cSql += "   WHERE SB2.B2_FILIAL   = '" + xFilial("SB2") + "' "
cSql += "     AND SB2.D_E_L_E_T_  = ' '  "
cSql += "     AND SB1.B1_RASTRO   = 'L'  "
cSql += "     AND SB2.B2_QATU     > 0    "
If !Empty(cLocal)
	cSql += "     AND SB2.B2_LOCAL  =  '"+ cLocal +"' "
Else
	cSql += "     AND SB2.B2_LOCAL  NOT IN('98','LE') "
EndIf

If !Empty(cProdDe) .And. !Empty(cProdAte)
	cSql += "     AND SB2.B2_COD BETWEEN '" + cProdDe + "' AND '" + cProdAte + "'"
EndIf
cSql += "     AND SB1.B1_GRUPO =  '" + cGrupo + "' "
cSql += "  ORDER BY SB2.B2_COD "


dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql),cUAliaSB2,.F.,.T.)
 
While (cUAliaSB2)->(!Eof()) 

	cProduto := (cUAliaSB2)->B2_COD
	cLocal   := (cUAliaSB2)->B2_LOCAL
	
/*	SB8->(dbSetOrder(3))
	If SB8->(!DbSeek(xFilial("SB8")+(cUAliaSB2)->B2_COD+cLocal+'LOTEINICIO' ) )
		RecLock("SB8",.T.)
		SB8->B8_FILIAL  := xFilial("SB8")
		SB8->B8_PRODUTO := (cUAliaSB2)->B2_COD
		SB8->B8_LOCAL   := (cUAliaSB2)->B2_LOCAL
		SB8->B8_SALDO   := (cUAliaSB2)->B2_QATU
		SB8->B8_DATA    := dDataBase
		SB8->B8_ORIGLAN := 'MN' 
		SB8->B8_LOTEFOR := 'LOTEINICIO'
		SB8->B8_LOTECTL := 'LOTEINICIO'
		SB8->B8_DFABRIC := dDataBase
		SB8->B8_DTVALID := dDataBase+1825
		SB8->B8_DOC     := AllTrim((cUAliaSB2)->B2_COD)+(cUAliaSB2)->B2_LOCAL
		MsUnlock()
	EndIf		
 */
 

	SBJ->(dbSetOrder(1))
	If SBJ->(!DbSeek(xFilial("SBJ")+cProduto+cLocal+'LOTEINICIO' ) )
		RecLock("SBJ",.T.)
		SBJ->BJ_FILIAL  := xFilial("SBJ")
		SBJ->BJ_COD     := (cUAliaSB2)->B2_COD
		SBJ->BJ_LOCAL   := (cUAliaSB2)->B2_LOCAL
		SBJ->BJ_DATA    := dDataBase
		SBJ->BJ_QINI    := (cUAliaSB2)->B2_QATU
		SBJ->BJ_LOTECTL := 'LOTEINICIO'
		SBJ->BJ_DTVALID := dDataBase+1825
		MsUnlock()
	EndIf		
/*
           
	cSql1 := " SELECT SD4.D4_COD    , "
	cSql1 += "        SD4.D4_DATA   , "
	cSql1 += "        SD4.D4_OP     , "
	cSql1 += "        SD4.D4_LOCAL  , "
	cSql1 += "        SD4.D4_QTDEORI, "
	cSql1 += "        SD4.D4_QUANT    "
	cSql1 += "  FROM " + RetSqlName("SD4") + " SD4     "
	cSql1 += " JOIN  " + RetSqlName("SB1") + " SB1 ON  "
	cSql1 += " 			SB1.B1_COD     =  SD4.D4_COD               AND " 
	cSql1 += " 			SB1.D_E_L_E_T_ <> '*'                      AND "
	cSql1 += "   		SB1.B1_FILIAL  =  '" + xFilial("SB1") + "' AND "
	cSql1 += "   		SB1.B1_RASTRO  =  'L'                      AND "
	cSql1 += "   		SB1.B1_GRUPO   =  '"+ cGrupo +"'             "
	cSql1 += "   WHERE "
	cSql1 += " 			SD4.D_E_L_E_T_ <> '*'                      AND "
	cSql1 += "   		SD4.D4_FILIAL  =  '" + xFilial("SD4") + "' AND "
	cSql1 += "   		SD4.D4_QUANT   <> 0                        AND "
	cSql1 += "   		SD4.D4_COD     =  '" + cProduto + "'       AND "
	cSql1 += "   		SD4.D4_LOCAL   =  '" + cLocal   + "'           "
	dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql1),cUAliaSD4,.F.,.T.)
	
	While (cUAliaSD4)->(!Eof()) 

		SD4->(dbSetOrder(2))
		If SD4->(DbSeek(xFilial("SD4")+(cUAliaSD4)->D4_OP+cProduto+(cUAliaSD4)->D4_LOCAL))
			RecLock("SD4",.F.)
			SD4->D4_LOTECTL  := 'LOTEINICIO'
			SD4->D4_DTVALID  := dDataBase+1825
			SD4->D4_X_LOTE   := 'LOTEINICIO'
			SD4->D4_X_DTVLL  := dDataBase+1825
			MsUnlock()
		EndIF

		(cUAliaSD4)->(dbSkip())
	EndDo

	cSql2 := " SELECT CB0.CB0_CODPRO , "
	cSql2 += "        CB0.CB0_CODETI , "
	cSql2 += "        CB0.CB0_LOCAL  , "
	cSql2 += "        CB0.CB0_LOTE   , "
	cSql2 += "        CB0.CB0_DTVLD    "
	cSql2 += "  FROM " + RetSqlName("CB0") + " CB0  "
	cSql2 += "   WHERE "
	cSql2 += " 			CB0.D_E_L_E_T_ <> '*'                      AND "
	cSql2 += "   		CB0.CB0_FILIAL =  '" + xFilial("CB0") + "' AND "
	cSql2 += "   		CB0.CB0_PALLET =  ' '                      AND "
	cSql2 += "   		CB0.CB0_CODPRO =  '" + cProduto + "'       AND "
	cSql2 += "   		CB0.CB0_LOCAL  =  '" + cLocal   + "'       AND "
	cSql2 += "   		CB0.CB0_STATUS =  ' '           "
	dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql2),cUAliaCB0,.F.,.T.)
	
	While (cUAliaCB0)->(!Eof()) 
		CB0->(dbSetOrder(1))
		If CB0->(dbSeek(xFilial("CB0")+(cUAliaCB0)->CB0_CODETI))
			RecLock("CB0",.F.)
			CB0->CB0_LOTE     := 'LOTEINICIO'
			CB0->CB0_DTVLD    := dDataBase+1825
			MsUnlock()
		EndIF

		(cUAliaCB0)->(dbSkip())
	EndDo


	(cUAliaSD4)->(dbCloseArea())
	(cUAliaCB0)->(dbCloseArea())
	*/

	(cUAliaSB2)->(dbSkip())

EndDo

(cUAliaSB2)->(dbCloseArea())
(cUAliaSB1)->(dbCloseArea())

Return()





//ESTORNO
User Function AJUSTEL1()

Local cSql1     := "" 
Local cSql2     := "" 
Local cUAliaSD4 := GetNextAlias()
Local cUAliaCB0 := GetNextAlias()


	cSql1 := " SELECT SD4.D4_COD    , "
	cSql1 += "        SD4.D4_DATA   , "
	cSql1 += "        SD4.D4_TRT   , "
	cSql1 += "        SD4.D4_OP     , "
	cSql1 += "        SD4.D4_LOCAL  , "
	cSql1 += "        SD4.D4_LOTECTL     "
	cSql1 += "  FROM " + RetSqlName("SD4") + " SD4     "
	cSql1 += "   WHERE "
	cSql1 += " 			SD4.D_E_L_E_T_ <> '*'                      AND "
	cSql1 += "   		SD4.D4_FILIAL  =  '" + xFilial("SD4") + "' AND "
	cSql1 += "   		SD4.D4_LOTECTL = 'LOTEINICIO' "
	dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql1),cUAliaSD4,.F.,.T.)
	
	While (cUAliaSD4)->(!Eof()) 

		SD4->(dbSetOrder(1))
		If SD4->(DbSeek(xFilial("SD4")+(cUAliaSD4)->D4_COD+(cUAliaSD4)->D4_OP+(cUAliaSD4)->D4_TRT+(cUAliaSD4)->D4_LOTECTL ))
			RecLock("SD4",.F.)
			SD4->D4_LOTECTL  := ' '
			SD4->D4_DTVALID  := CtoD("//")
			SD4->D4_X_LOTE   := ' '
			SD4->D4_X_DTVLL  := CtoD("//")
			MsUnlock()
		EndIF

		(cUAliaSD4)->(dbSkip())
	EndDo

	cSql2 := " SELECT CB0.CB0_CODPRO , "
	cSql2 += "        CB0.CB0_CODETI , "
	cSql2 += "        CB0.CB0_LOCAL  , "
	cSql2 += "        CB0.CB0_LOTE   , "
	cSql2 += "        CB0.CB0_DTVLD    "
	cSql2 += "  FROM " + RetSqlName("CB0") + " CB0  "
	cSql2 += "   WHERE "
	cSql2 += " 			CB0.D_E_L_E_T_ <> '*'                      AND "
	cSql2 += "   		CB0.CB0_FILIAL =  '" + xFilial("CB0") + "' AND "
	cSql2 += "   		CB0.CB0_LOTE =  'LOTEINICIO' "
	dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql2),cUAliaCB0,.F.,.T.)
	
	While (cUAliaCB0)->(!Eof()) 
		CB0->(dbSetOrder(1))
		If CB0->(dbSeek(xFilial("CB0")+(cUAliaCB0)->CB0_CODETI))
			RecLock("CB0",.F.)
			CB0->CB0_LOTE     := ''
			CB0->CB0_DTVLD    := CtoD("//")
			MsUnlock()
		EndIF

		(cUAliaCB0)->(dbSkip())
	EndDo



(cUAliaCB0)->(dbCloseArea())
(cUAliaSD4)->(dbCloseArea())

Return()
                                                                               




//so CB0

User Function AJUSTEL2()

Local cSql2     := "" 
Local cUAliaCB0 := GetNextAlias()

cSql2 := " SELECT CB0.CB0_CODPRO , "
cSql2 += "        CB0.CB0_CODETI , "
cSql2 += "        CB0.CB0_LOCAL  , "
cSql2 += "        CB0.CB0_LOTE   , "
cSql2 += "        CB0.CB0_DTVLD    "
cSql2 += "  FROM " + RetSqlName("CB0") + " CB0  "
cSql2 += "   WHERE "
cSql2 += " 			CB0.D_E_L_E_T_ <> '*'                      AND "
cSql2 += "   		CB0.CB0_FILIAL =  '" + xFilial("CB0") + "' AND "
cSql2 += "   		CB0.CB0_CODPRO IN('044988','044989','044990','044991' ,'044992' ,'044993' ,'044994' ,'044995' ,'061889' ,'066602') AND "
cSql2 += "   		CB0.CB0_STATUS =  ' '  AND CB0.CB0_LOCAL = '01'   AND YEAR(CB0.CB0_DTNASC) >='2017'      "

dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql2),cUAliaCB0,.F.,.T.)

While (cUAliaCB0)->(!Eof()) 
	CB0->(dbSetOrder(1))
	If CB0->(dbSeek(xFilial("CB0")+(cUAliaCB0)->CB0_CODETI))
		RecLock("CB0",.F.)
		CB0->CB0_LOTE  := 'LOTEINICIO'
		CB0->CB0_DTVLD := dDataBase+1825
		MsUnlock()
	EndIF

	(cUAliaCB0)->(dbSkip())
EndDo


(cUAliaCB0)->(dbCloseArea())

Return()




/*SELECT *   
 FROM CB0010 CB0  
   WHERE 
CB0.D_E_L_E_T_ <> '*'                      AND 
CB0.CB0_FILIAL =  '08' AND 
CB0.CB0_PALLET =  ' '                      AND 
CB0.CB0_CODPRO  IN('044988','044989','044990','044991' ,'044992' ,'044993' ,'044994' ,'044995' ,'061889' ,'066602')     AND 
CB0.CB0_STATUS =  ' '  AND CB0.CB0_LOCAL = '01'   AND YEAR(CB0.CB0_DTNASC) >='2017'     
ORDER BY CB0.CB0_CODPRO*/