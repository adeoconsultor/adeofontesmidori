#include 'totvs.ch'
#include 'topconn.ch'
#include 'parmtype.ch'
                                                                              
//////////////////////////////////////////////////////////////////////////////////////////
// Função: MDMONOSC() Autor: Antonio C Damaceno - Data: 11/07/17
// Objetivo: Monitor de Ordem de Separação na planta de Costura

User Function MD_MONOSC()

Local aCores    := {}

Private aRotina	:= MenuDef()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCadastro	:= "Monitor de Ordem de Separação"

aAdd(aCores, { 'ZZP_STATUS== "E"' , 'BR_VERMELHO' })
aAdd(aCores, { 'ZZP_STATUS== "P"' , 'BR_AMARELO' })
aAdd(aCores, { 'ZZP_STATUS== "N"' , 'BR_VERDE'  })

dbSelectArea("ZZP")
dbSetOrder(1)
mBrowse(6,1,22,75,"ZZP",,,,,,aCores)

Return()



Static Function MenuDef()

Private aRotina	:= {	{ "Pesquisar"               ,"AxPesqui"      , 0 , 1,0 ,.F.},;
						{ 'Ordem Separação'         ,"U_UMD_MONOSC()", 0 , 4,0 ,NIL},;
						{ 'Encerrar Ord. Separação' ,"U_FMD_MONOSC()", 0 , 4,0 ,NIL},;
						{ 'Excluir  Ord. Separação' ,"U_EMD_MONOSC()", 0 , 4,0 ,NIL},;
						{ 'Legenda'                 ,"U_MonOscLeg()" , 0 , 0,0 ,NIL} }
//						{ "Visualizar"              ,"AxVisual"      , 0 , 2,0 ,NIL}	

Return(aRotina)


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Encerrar ordem de separação - Antonio - 11/01/18
User Function FMD_MONOSC()

If MsgYesNo("Tem certeza que deseja encerrar a Ordem de Separação? ","Monitor de Ordem de Separação")

	RecLock("ZZP",.F.)
	ZZP->ZZP_STATUS := 'E'
	MsUnlock()
	
	ZZK->(dbSetOrder(1))
	IF ZZK->(dbSeek(xFilial("ZZK")+ZZP->ZZP_ORDSEP) )

		While ZZK->(!Eof()) .And. (ZZK->ZZK_ORDSEP == ZZP->ZZP_ORDSEP)
			RecLock("ZZK",.F.)
			ZZK->ZZK_STATUS := 'E'
			ZZK->ZZK_QTDSEP := 	ZZK->ZZK_QTDORI
			MsUnlock()

			ZZK->(dbSkip())
		EndDo

	Endif

EndIf


Return(.T.)


                           
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MonOscLeg()

aLegenda := {}
aAdd(aLegenda, {"BR_VERMELHO" , "Encerrada"    })
aAdd(aLegenda, {"BR_VERDE"    , "Não Iniciada" })
aAdd(aLegenda, {"BR_AMARELO"  , "Pendente"     })

BrwLegenda(cCadastro,"Status",aLegenda)

Return(.T.)



User Function UMD_MONOSC()

Local oPerg
Local oGrdPre  := Nil
Local cPerg    := "MTM202OS"
Local cSql1    := ""
Local nLoop

Private oDlg, oGridPrd
Private cSql    := ""
Private aHead   := {}
Private nPRODUT := 0
           
Private cUAliasZZK := GetNextAlias()

//-----------------------------------------------
// Seleciona os registros
//-----------------------------------------------
//----------------------------------------
// Monta query dos produtos que devem
// ser analizados
//----------------------------------------
cSql += "SELECT ZZK.ZZK_CODPRO  PRODUTO "
cSql += "     , SB1.B1_DESC     XDESC   "
cSql += "     , ZZK.ZZK_LOCAL   ARMAZEM "
cSql += "     , ZZP.ZZP_OPMIDO  PLANO   "
cSql += "     , ZZK.ZZK_ORDSEP  ORDSEP  "
cSql += "     , ZZK.ZZK_LOTE    LOTE    "
cSql += "     , ZZK.ZZK_DTVLL   DTVLL   "
cSql += "     , ZZK.ZZK_QTDSEP  QTDSEP  "
cSql += "     , ZZK.ZZK_QTDORI  QTDORI  "
cSql += "     , SITUOS = 
cSql += "              CASE 
cSql += "                 WHEN ZZK.ZZK_STATUS = 'E' THEN 'BR_VERMELHO'  "
cSql += "                 WHEN ZZK.ZZK_STATUS = 'P' THEN 'BR_AMARELO'  "
cSql += "                 WHEN ZZK.ZZK_STATUS = 'N' THEN 'BR_VERDE'   "
cSql += "              END "
cSql += "  FROM "+RetSqlName("ZZK")+" ZZK "
cSql += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
cSql += "                      AND SB1.B1_COD      = ZZK.ZZK_CODPRO "
cSql += "                      AND ( SB1.B1_RASTRO = 'L' OR SB1.B1_LOCALIZ = 'S' ) "
cSql += "                      AND SB1.D_E_L_E_T_  = ' ' "
cSql += " INNER JOIN "+RetSqlName("ZZP")+" ZZP ON ZZP.ZZP_FILIAL = '"+xFilial("ZZP")+"' "
cSql += "                      AND ZZP.ZZP_ORDSEP  = ZZK.ZZK_ORDSEP "
cSql += "                      AND ZZP.D_E_L_E_T_  = ' ' "
cSql += "WHERE ZZK.ZZK_FILIAL  = '"+xFilial("ZZK")+"' "
cSql += "  AND ZZK.ZZK_ORDSEP  = '"+ZZP->ZZP_ORDSEP+"'  "
cSql += "  AND ZZK.D_E_L_E_T_  = ' ' "       

ProcRegua(0)
IncProc("Filtrando registros") 

cSql := ChangeQuery( cSql )
cSql1 := ChangeQuery( cSql )
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql1),cUAliasZZK,.f.,.t.) 	

//-----------------------------------------------
// Monta a dialog
//-----------------------------------------------
oDlg:= uAdvplDlg():New(  "Monitor de Ordem de Separação de Materiais - OS Nr: "+(cUAliasZZK)->ORDSEP + " - Plano: "+(cUAliasZZK)->PLANO , .t., .t., , nil, 100, 100 )
Aadd(aHead, { "Produto"     , "PRODUTO"  , "@!"                  , TamSX3("D4_COD"     )[1] , 0 , ".f.", "", "C", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Descricao"   , "XDESC"    , "@!"                  , 80                       , 0 , ".f.", "", "C", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Armazém"     , "ARMAZEM"  , "@!"                  , 10                       , 0 , ".f.", "", "C", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Lote Midori" , "LOTE"     , "@!"                  , TamSx3("D4_LOTECTL" )[1] , 0 , ".f.", "", "C", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Valid Lote"  , "DTVLL"    , "@D"                  , TamSx3("D4_DATA"    )[1] , 0 , ".f.", "", "D", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Qtd Original", "QTDORI"   , "@E 999,999.9999"     , TamSx3("D4_QUANT"   )[1] , 4 , ".f.", "", "N", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Qtd Separada", "QTDSEP"   , "@E 999,999.9999"     , TamSx3("D4_QUANT"   )[1] , 4 , ".f.", "", "N", "" , "R","","", ".f.", "A", ""} )

oGrdPre:= MyGrid():New( 000, 000, 000, 000, GD_UPDATE,,,,,, 99999,,,, oDlg:oPnlCenter )

oGrdPre:AddButton( "Legenda"   , {|| BrwLegenda("Legenda da OS","Situação Ord Separação",{	{"BR_VERMELHO","Encerrada"} , {"BR_AMARELO","Pendente"}, {"BR_VERDE","Não Iniciada"} } ) } )

For nLoop := 1 to Len( aHead )
	oGrdPre:AddColumn( aHead[nLoop] )
Next nLoop

//oGrdPre:AddColBMP("MARCA","UNCHECKED_15")
oGrdPre:AddColBMP("SITUOS")

ProcRegua(100) 

oGrdPre:SeekSet()
oGrdPre:IndexSet()
oGrdPre:SheetSet()
oGrdPre:Load()
oGrdPre:FromSql( cSql )
oGrdPre:SetAlignAllClient()

//oGrdPre:oGrid:bFieldOk := {|| FieldOk(oGrdPre) }
//oGrdPre:SetDoubleClick( {|| oGrdPre:SetField("MARCA", IIF(oGrdPre:GetField("MARCA") == "CHECKED_15","UNCHECKED_15", MarDes(@oGrdPre) )) } )

//nLoteCtl := aScan(oGrdPre:aHeader, {| aVet | aVet[2] == "LOTE"})

oDlg:SetInit( {|| oGrdPre:Refresh(.T.)})
oDlg:Activate()

Return( Nil )


Static Function GridCalc(oGrid) 
// +---------------------------------------------------------------------------+
// | Desc.    | GridCalc - Calcula valores do Grid.                            |
// +---------------------------------------------------------------------------+

Local nPLEGEND  := aScan(oGrid:AHEADER,{|x| AllTrim(x[2])=="SITUOS"})   // LEGENDA
Local aCols     := aClone(oGrid:ACOLS)
Local nI

If nPLEGEND > 0 

		For nI := 1 to len(aCols)
			
			If AllTrim(aCols[nI, nPLEGEND ]) == 'BR_BRANCO'
			   	aCols[nI, nPDIASAM ] := "           "  
			ElseIf AllTrim(aCols[nI, nPLEGEND ]) $ 'BR_VERDE/BR_VERMELHO/BR_AMARELO'
			   	//aCols[nI, nPDIASAM ] :=   cValToChar( dDataBase - aCols[nI, nPDATACD] )
			   	aCols[nI, nPDIASAM ] :=  Transform(dDataBase - aCols[nI, nPDATACD], "@e 999,999,999" )
		 	EndIf
			
		Next

EndIf 
		
oGrid:SetArray(aCols)
oGrid:Refresh()

Return nil
           



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Excluir ordem de separação - Antonio - 18/12/18
User Function EMD_MONOSC()

Local cSql := ""

If MsgYesNo("Tem certeza que deseja excluir a Ordem de Separação? ","Monitor de Ordem de Separação")

	RecLock("ZZP",.F.)
	dbDelete()
	MsUnlock()
	
	ZZK->(dbSetOrder(1))
	IF ZZK->(dbSeek(xFilial("ZZK")+ZZP->ZZP_ORDSEP) )

		While ZZK->(!Eof()) .And. (ZZK->ZZK_ORDSEP == ZZP->ZZP_ORDSEP)
			RecLock("ZZK",.F.)
			dbDelete()
			MsUnlock()
			ZZK->(dbSkip())
		EndDo

	Endif

	cSql := " UPDATE "+RetSqlName("SD4")+" SD4 SET SD4.D4_X_LOTE = '', SD4.D4_X_ORSEP = '', SD4.D4_X_DTVLL = '' "
	cSql += " WHERE SD4.D4_FILIAL  = '"+xFilial("SD4")+"' AND SD4.D_E_L_E_T_  = ' ' "       
	cSql += "   AND SD4.D4_X_ORSEP = '"+ZZP->ZZP_ORDSEP+"'  "
//	cSql += "   AND SD4.D4_OP  IN ( SELECT SC2.C2_NUM+'01001' FROM "+RetSqlName("SC2")+" SC2 WHERE SC2.C2_OPMIDO IN ('DUB2 44-18') ) "
//	cSql += "   AND SD4.D4_COD IN ( SELECT SB1.B1_COD         FROM "+RetSqlName("SB1")+" SB1 WHERE SB1.B1_RASTRO = 'L') "
	
	ProcRegua(0)
	IncProc("Filtrando registros") 
	
	cSql := ChangeQuery( cSql )

	MsgAlert("OS: " + ZZP->ZZP_ORDSEP + " Excluída Com Sucesso! ")

EndIf

//oGrid:Refresh()

Return()
