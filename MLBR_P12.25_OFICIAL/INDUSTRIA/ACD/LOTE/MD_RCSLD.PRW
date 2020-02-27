#include 'totvs.ch'
#include 'topconn.ch'
                                                                              
//////////////////////////////////////////////////////////////////////////////////////////
// Função: MD_RCSLD() Autor: Antonio C Damaceno - Data: 12/12/17
// Objetivo: Relatorio de conferencia de saldos para Gerar Ordem de Separação na planta de Costura

User Function MD_RCSLD()

Local oPerg
Local cPerg     :="MD_RCSLD"
Local cAliasZZP := GetNextAlias()
                                
Private oDlg, oGridPrd
Private aHead   := {}

oPerg := AdvplPerg():New( cPerg )

//-------------------------------------------------------------------
//    AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
// Parametriza as perguntas
//-------------------------------------------------------------------
oPerg:AddPerg( "Plano Inicial: " ,"C",TamSx3("ZP_OPMIDO")[1] , , , "SZP")
//oPerg:AddPerg( "Plano Final..: " ,"C",TamSx3("ZP_OPMIDO")[1] , , , "SZP")
oPerg:SetPerg()

	If ! Pergunte( cPerg, .t. )
		Return( nil )
	EndIf

	cQuery := " SELECT ZZP.ZZP_OPMIDO "
	cQuery += "  FROM " + RetSqlName("ZZP") + " ZZP  "
	cQuery += "  WHERE ZZP.ZZP_FILIAL = '" + xFilial("ZZP") + "' AND ZZP.D_E_L_E_T_ = '  ' AND" 
	cQuery += "        ZZP.ZZP_OPMIDO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZZP,.T.,.T.) 

	If (cAliasZZP)->(Eof())                            
		MsgInfo( "Este Plano Não Existe, informe um plano que esteja cadastrado na base de dados!","Atenção")
		(cAliasZZP)->(dbCloseArea())
		Return()
	EndIf
	(cAliasZZP)->(dbCloseArea())

	Processa({|| URCSLD() }, "Validando dados...")

Return()
 



Static Function URCSLD()

Local cSql := ""
Local cAliasSD4 := GetNextAlias()
Local nLoop
//----------------------------------------
// Monta query dos produtos que devem
// ser analizados
//---------------------------------------- 

cSql += " SELECT SD4.D4_COD     PRODUTO  , "
cSql += "        SB1.B1_DESC    XDESC    , "
cSql += "        B8.B8_LOCAL    LOCALB8  , "
cSql += "        B8.B8SALDO     SALDO    , "
cSql += "        SD4.D4_LOCAL   LOCALD4  , "
cSql += "    SUM(SD4.D4_QUANT)  QEMP     , "
cSql += "        'LEGENDA' =    CASE  "
cSql += "                       WHEN B8.B8SALDO > 0 THEN 'Saldo Ok' "
cSql += "                       ELSE 'Saldo Insuficiente' "
cSql += "                       END  "
cSql += " 	FROM " +RetSqlName("SD4")+ " SD4 " 
cSql += " 	JOIN " +RetSqlName("SB1")+ " SB1 ON B1_COD = D4_COD AND B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ <> '*'"
cSql += " CROSS APPLY ( SELECT B8_PRODUTO, B8_LOCAL,(SUM(B8_SALDO) - SUM(B8_QEMPPRE) - SUM(B8_EMPENHO)) AS B8SALDO "
cSql += " 	              FROM "+RetSqlName("SB8")+ " B8 "
cSql += " 	            WHERE B8_FILIAL  =  '"+xFilial("SB8")+"' AND "
cSql += " 		              B8_PRODUTO =  D4_COD    AND "
cSql += " 		              B8_SALDO   >  0         AND "
cSql += " 		              B8_LOCAL   =  '01'      AND "
cSql += " 		              B8.D_E_L_E_T_ <> '*'        "
cSql += " 	            GROUP BY B8_PRODUTO,  B8_LOCAL  "
cSql += "              ) AS B8 "
cSql += " WHERE "
cSql += "   SD4.D4_FILIAL  =  '"+xFilial("SD4")+"' AND "
cSql += " 	SD4.D_E_L_E_T_ <> '*'                  AND "
cSql += "   SD4.D4_QUANT   >  0 AND "
cSql += "   SD4.D4_COD     IN ( SELECT B1_COD FROM " +RetSqlName("SB1")+ " WHERE B1_RASTRO = 'L') AND "
cSql += "   SD4.D4_OP      IN ( SELECT C2_NUM+'01001' FROM " +RetSqlName("SC2")+ " WHERE C2_OPMIDO = '" + MV_PAR01 + "' ) "
//cSql += "                       SC2.C2_OPMIDO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cSql += " GROUP BY D4_COD, B1_DESC, B8_LOCAL, B8SALDO, D4_LOCAL "
cSql += " ORDER BY D4_COD "
                        
ProcRegua(0)
IncProc("Filtrando registros") 

//-----------------------------------------------
// Monta a dialog
//-----------------------------------------------

oDlg:= uAdvplDlg():New(  "Relatorio de conferencia de saldos para Gerar Ordem de Separação na planta de Costura", .t., .t., , nil, 100, 100 )
Aadd(aHead, { "Produto"         , "PRODUTO"  , "@!"               , TamSX3("D4_COD"   )[1] , 0 , ".f.", "", "C", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Descricao"       , "XDESC"    , "@!"               , TamSX3("B1_DESC"  )[1] , 0 , ".f.", "", "C", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Armazém Empenho" , "LOCALD4"  , "@!"               , TamSx3("D4_LOCAL" )[1] , 0 , ".f.", "", "C", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Empenhado"       , "QEMP"     , "@E 999,999.9999"  , TamSx3("D4_QUANT" )[1] , 4 , ".f.", "", "N", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Armazém Lote"    , "LOCALB8"  , "@!"               , TamSx3("D4_LOCAL" )[1] , 0 , ".f.", "", "C", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Saldo Lote"      , "SALDO"    , "@E 999,999.9999"  , TamSx3("B8_SALDO" )[1] , 4 , ".f.", "", "N", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Disponibilidade" , "LEGENDA"  , "@!"               , 20                     , 0 , ".f.", "", "C", "" , "R","","", ".f.", "A", ""} )

oGrdPre:= MyGrid():New( 000, 000, 000, 000, GD_UPDATE,,,,,, 99999,,,, oDlg:oPnlCenter )

For nLoop := 1 to Len( aHead )
	oGrdPre:AddColumn( aHead[nLoop] )
Next nLoop

ProcRegua(100) 

oGrdPre:SeekSet()
oGrdPre:IndexSet()
oGrdPre:SheetSet()
//oGrdPre:AddButton( "Gerar Ordem Separação"  , { || Processa( {|| MonEncPre(@oGrdPre,2) }, "Aguarde..." ) } )
oGrdPre:Load()
oGrdPre:FromSql( cSql )
oGrdPre:SetAlignAllClient()

oDlg:SetInit( {|| oGrdPre:Refresh(.T.)})
oDlg:Activate()

Return( Nil )
