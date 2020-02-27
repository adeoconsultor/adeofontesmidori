#INCLUDE 'TOTVS.CH'
#include "tbiconn.ch"
#include 'topconn.ch'
#include 'parmtype.ch'

/*
//==========================================================================================
// MDCouro2 - Antonio Carlos - Advpl Tecnologia - Setembro / 2019
//------------------------------------------------------------------------------------------
// Descrição
// Revalidar Datas de Validade dos Lotes (PNP1)
//------------------------------------------------------------------------------------------
// Parametros
// nenhum
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
*/

User Function MDCOURO2()

Local oPerg
Local nLoop

Private cSql     := ""
Private aHead    := {}
Private cPerg    := "MDCOU02"
Private oDlg, oGrdEnd

oPerg := AdvplPerg():New( cPerg )

//-------------------------------------------------------------------
//    AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
// Parametriza as perguntas
//-------------------------------------------------------------------

oPerg:AddPerg( "Informe o Pallet Inicial.:" ,"C",TamSx3("ZO_NUMPLT")[1], , , "",,)
oPerg:AddPerg( "Informe o Pallet Final...:" ,"C",TamSx3("ZO_NUMPLT")[1], , , "",,)

oPerg:SetPerg()

If ! Pergunte( cPerg, .t. )
	Return( nil )
EndIf
                    
//-----------------------------------------------
// Seleciona os registros
//-----------------------------------------------

cSql := "SELECT "
cSql += "       SZO.ZO_FILIAL  AS FILIAL    , "
cSql += "       SZO.ZO_NFORI   AS NFORI     , "
cSql += "       SZO.ZO_SERIE   AS SERIE     , "
cSql += "       SZO.ZO_EMISSNF AS EMISSNF   , "
cSql += "       SZO.ZO_DTLCMTO AS DTDIGNF   , "
cSql += "       SZO.ZO_CODFOR  AS CODFOR    , "
cSql += "       SZO.ZO_LJFOR   AS LJFOR     , "
cSql += "       SA2.A2_NOME    AS A2NOME    , "
cSql += "       SZO.ZO_PRODUTO AS PRODUTO   , "
cSql += "       SB1.B1_DESC    AS B1DESC    , "
cSql += "       SZO.ZO_NUMLOTE AS NUMLOTE   , " 
cSql += "       SZO.ZO_DTVALID AS DTVALID   , " 
cSql += "       SZO.ZO_RVALID  AS DTRVALID  , " 
cSql += "       SZO.ZO_NUMPLT  AS NUMPLT    , "
cSql += "       SZO.ZO_QTDCOUR AS QTDCOUR   , "
cSql += "       SZO.ZO_QTDEVQ  AS QTDEVQ    , "
cSql += "       SZO.ZO_QTDEM2  AS QTDEM2    , "
cSql += "       SZO.ZO_M2VQPLT AS M2VQPLT   , "
cSql += "       SZO.ZO_SITUACA AS SITUCOD   ,  "
cSql += " CASE  SZO.ZO_SITUACA WHEN '1' THEN 'Analise'            "
cSql += "                      WHEN '2' THEN 'Disponivel'         "
cSql += "                      WHEN '3' THEN 'Consumido'          "
cSql += "                      WHEN '4' THEN 'Reprovado'          "
cSql += "                      WHEN '5' THEN 'Parcial (Consumo)'  "
cSql += "                      WHEN '6' THEN 'Devolvido (Pallet)' "
cSql += "       END AS SITUACA              , "
cSql += "       SZO.ZO_ENDERE  AS ENDERE      "                                
cSql += "FROM " + RetSqlName("SZO") + " SZO "
cSql += "LEFT JOIN " + RetSqlName("SA2") + " SA2 ON "
cSql += "	SA2.A2_COD     = SZO.ZO_CODFOR  AND SA2.A2_LOJA   = SZO.ZO_LJFOR AND "
cSql += "	SA2.D_E_L_E_T_ = ''             AND SA2.A2_FILIAL = '" + xFILIAL("SA2") + "' "
cSql += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON "
cSql += "	SB1.B1_COD     = SZO.ZO_PRODUTO AND "
cSql += "	SB1.D_E_L_E_T_ = ''             AND SB1.B1_FILIAL = '" + xFILIAL("SB1") + "' "
//Couro
cSql += "	AND SB1.B1_GRUPO IN('12','14') "
cSql += "WHERE "
cSql += "	SZO.ZO_FILIAL  = '" + xFILIAL("SZO")  + "' AND "
cSql += "	SZO.ZO_DTVALID <> ' ' AND "                     
cSql += "	SZO.ZO_DTVALID < '" + DtoS(dDataBase) + "' AND "     //CONTROLAR OS QUE ESTÃO COM LOTE VENCIDO E AINDA NAO FORAM REVALIDADOS
//cSql += "	SZO.ZO_RVALID  = ' '  AND "  
cSql += "	SZO.ZO_SITUACA <> '3' AND "                      
cSql += "	SZO.D_E_L_E_T_ = '' "                                                        
If !Empty(MV_PAR01) .AND. !Empty(MV_PAR02)
	cSql += "	AND SZO.ZO_NUMPLT  BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "
EndIf

cSql += "	ORDER BY ZO_EMISSNF "
cSql := ChangeQuery( cSql )

//tcsetfield(cSql,'ZO_EMISSNF','D',8,0)

//-----------------------------------------------
// Monta a dialog
//-----------------------------------------------

oDlg:= uAdvplDlg():New(  "Revalidar Datas de Validade dos Lotes - Couro (PNP1)", .t., .t., , nil, 100, 100 )

Aadd(aHead, { "Filial"          , "FILIAL"   , "@!"              , 2                         , 0 , ".F.", "", "C", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Nf Orig"         , "NFORI"    , "@!"              , TamSX3("ZO_NFORI"   )[1]  , 0 , ".F.", "", "C", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Série"           , "SERIE"    , "@!"              , TamSx3("ZO_SERIE"   )[1]  , 0 , ".F.", "", "C", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Dt Emiss NF"     , "EMISSNF"  , "@D"              , TamSx3("ZO_EMISSNF" )[1]  , 0 , ".F.", "", "D", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Dt Digitação NF" , "DTDIGNF"  , "@D"              , TamSx3("ZO_DTLCMTO" )[1]  , 0 , ".F.", "", "D", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Cod Fornec"      , "CODFOR"   , "@!"              , TamSx3("ZO_CODFOR"  )[1]  , 0 , ".F.", "", "C", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Lj Fornec"       , "LJFOR"    , "@!"              , TamSx3("ZO_LJFOR"   )[1]  , 0 , ".F.", "", "C", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Nome"            , "A2NOME"   , "@!"              , 15                        , 0 , ".F.", "", "C", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Produto"         , "PRODUTO"  , "@!"              , 6                         , 0 , ".F.", "", "C", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Descrição"       , "B1DESC"   , "@!"              , 15                        , 0 , ".F.", "", "C", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Lote"            , "NUMLOTE"  , "@!"              , TamSx3("ZO_NUMLOTE" )[1]  , 0 , ".F.", "", "C", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Dt Valid Lote"   , "DTVALID"  , "@!"              , TamSx3("ZO_DTVALID" )[1]  , 0 , ".F.", "", "D", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Dt Revalid Lote" , "DTRVALID" , "@!"              , TamSx3("ZO_DTVALID" )[1]  , 0 , ".T.", "", "D", "" , "R","","", ".T.", "A", ""} )
Aadd(aHead, { "Nr Pallet"       , "NUMPLT"   , "@!"              , TamSx3("ZO_NUMPLT"  )[1]  , 0 , ".F.", "", "C", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Qtd Couro"       , "QTDCOUR"  , "@!"              , TamSx3("ZO_QTDCOUR" )[1]  , 0 , ".F.", "", "N", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Qtde Vqt"        , "QTDEVQ"   , "@!"              , TamSx3("ZO_QTDEVQ " )[1]  , 0 , ".F.", "", "N", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Qtde M2 "        , "QTDEM2"   , "@E 999,999.9999" , 12                        , 4 , ".F.", "", "N", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Vlr Média"       , "M2VQPLT"  , "@E 999.99"       , 6                         , 2 , ".F.", "", "N", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Situação"        , "SITUCOD"  , "@!"              , TamSx3("ZO_SITUACA" )[1]  , 0 , ".F.", "", "C", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Descrição"       , "SITUACA"  , "@!"              , TamSx3("ZO_SITUACA" )[1]  , 0 , ".F.", "", "C", "" , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Endereço"        , "ENDERE"   , "@!"              , TamSx3("ZO_ENDERE" )[1]   , 0 , ".F.", "", "C", "" , "R","","", ".F.", "A", ""} )


/*1 - TITULO, ;
2 - CAMPO   	, ;
3 - PICTURE 	, ;
4 - TAMANHO 	, ;
5 - DECIMAL 	, ;
6 - VALID   	, ;
7 - USADO   	, ;
8 - TIPO    	, ;
9 - F3      	, ;
10 - CONTEXT 	, ;
11 - CBOX    	, ;
12 - RELACAO 	, ;
13 - WHEN    	, ;
14 - VISUAL  	, ;
15 - VLDUSER 	, ;
16 - PICTVAR 	, ;
17 - OBRIGAT})
  */
//Habilitado o campo de endereço para digitação caso na entrada da nf a pessoa não saiba que endereço será .
//Esta digitação será feita somente pelo Celso (gestor da area). - Antonio 21/05/19 .

oGrdEnd:= MyGrid():New( 000, 000, 000, 000, GD_UPDATE,,,,,, 99999,,,, oDlg:oPnlCenter )

For nLoop := 1 to Len( aHead )
	oGrdEnd:AddColumn( aHead[nLoop] )
Next nLoop

oGrdEnd:SeekSet()
oGrdEnd:IndexSet()
oGrdEnd:SheetSet()  //excel

oGrdEnd:AddButton( "Reemitir Etiquetas", { || Processa( {|| MonSalv(@oGrdEnd) }, "Aguarde..." ) } )

oGrdEnd:Load()
oGrdEnd:FromSql( cSql )
oGrdEnd:SetAlignAllClient()

oDlg:SetInit( {|| oGrdEnd:Refresh(.T.)})
oDlg:Activate()

Return( Nil )
						                                                      

				

//==========================================================================================
// MonSalv - Antonio - Advpl Tecnologia - Setembro / 2019
//------------------------------------------------------------------------------------------
// Descrição
// Monta o array com os produtos que serão alterados a data de validade do lote
//------------------------------------------------------------------------------------------
// Parametros
// Nenhum
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
Static Function MonSalv(oGrd)

Local nLoop
Local cLocApt:=""

ProcRegua( 0 )

//
For nLoop := 1 to Len( oGrd:aCols )
	
	IncProc()
	
	If !Empty(oGrd:GetField("DTRVALID"  , nLoop))

		cQuery := " UPDATE SZO010 "
		cQuery += " SET ZO_RVALID    = '" + DtoS(oGrd:GetField("DTRVALID", nLoop)) + "' "
		cQuery += "       ,ZO_SITUACA = '2' " // deixa pallet disponivel automaticamente, pois foi revalidado // Diego - 18/09/19
		cQuery += " WHERE ZO_FILIAL  = '" + xFilial('SZO')                   + "' AND "
		cQuery += "       ZO_NFORI   = '" + oGrd:GetField("NFORI"   , nLoop) + "' AND "
		cQuery += "       ZO_SERIE   = '" + oGrd:GetField("SERIE"   , nLoop) + "' AND "
		cQuery += "       ZO_CODFOR  = '" + oGrd:GetField("CODFOR"  , nLoop) + "' AND " 
		cQuery += "       ZO_LJFOR   = '" + oGrd:GetField("LJFOR"   , nLoop) + "' AND "
		cQuery += "       ZO_PRODUTO = '" + oGrd:GetField('PRODUTO' , nLoop) + "' AND "
		cQuery += "       ZO_NUMPLT  = '" + oGrd:GetField("NUMPLT"  , nLoop) + "' AND "
		cQuery += "       ZO_NUMLOTE = '" + oGrd:GetField('NUMLOTE' , nLoop) + "' AND "
		cQuery += "       D_E_L_E_T_ <> '*' "
		TcSqlExec( cQuery )

		cSayNF  := oGrd:GetField("NFORI"   , nLoop)
		cSaySer := oGrd:GetField("SERIE"   , nLoop)
		cSayFor := oGrd:GetField("CODFOR"  , nLoop)
		cSayLj  := oGrd:GetField("LJFOR"   , nLoop)

		//If MsgYesNo('Emitir etiqueta de Pallet (PNP1) - Quimicos (S/N)?' )

		// Se a etiqueta não tiver movimento, apaga
		CB0->(DbSetOrder(6))
		CB0->(DbSeek(xFilial("CB0") + cSayNF + cSaySer + cSayFor + cSayLj))
		While CB0->(DbSeek(xFilial("CB0") + cSayNF + cSaySer + cSayFor + cSayLj ))
			If CB0->CB0_PALSZO <> oGrd:GetField("NUMPLT"   , nLoop)
				//CB0->(dbSkip())             
				//Loop
				Exit
			EndIf
			cLocApt:=CB0->CB0_LOCAL
			RecLock("CB0",.F.)
			dbDelete()
			MsUnlock()			
			CB0->(dbSkip())             
		Enddo

	    SB1->( dbSetOrder(1) )
	    SB1->( dbSeek( xFilial("SB1") + oGrd:GetField('PRODUTO' , nLoop) ) )
		If Empty(cLocApt)
			cLocApt	:= SB1->B1_LOCPAD	
		EndIf

	 	aParam    := {}                  
		nQtOpEtiq := 1
		AAdd( aParam, oGrd:GetField('QTDEM2' , nLoop) ) // quantidade da etiqueta                           1
		AAdd( aParam, nil           ) // Codigo do separador                                                2
		AAdd( aParam, nil           ) // Código da etiqueta, no caso de uma reimpressão                     3
		AAdd( aParam, nQtOpEtiq     ) // Quantidade de etiquetas                                            4
		AAdd( aParam, cSayNF        ) // nota de entrada                                                    5
		AAdd( aParam, cSaySer       ) // Serie da nota de entrada                                           6
		AAdd( aParam, cSayFor       ) // Codigo do fornecedor da nota de entrada                            7
		AAdd( aParam, cSayLj        ) // Loja do fornecedor da nota de entrada                              8
		AAdd( aParam, cLocApt       ) // Armazem                                                            9
		AAdd( aParam, nil           ) // Numero da OP                                                      10
		AAdd( aParam, nil           ) // Numero sequencial da etiqueta quando for reimpressao              11
		AAdd( aParam, If(SB1->B1_RASTRO=="L", oGrd:GetField('NUMLOTE' , nLoop), nil ) )                  //12
		AAdd( aParam, nil           ) // Sublote                                                           13

		AAdd( aParam, oGrd:GetField('DTVALID' , nLoop))            // Data de Validade                     14

		AAdd( aParam, nil           ) // Centro de Custos                                                  15
		AAdd( aParam, cLocApt       ) // Local de Origem                                                   16
		AAdd( aParam, nil           ) // Local cOPREQ    := If(len(paramixb) >=17,paramixb[17],NIL)        17
		AAdd( aParam, nil           ) // Local cNumSerie := If(len(paramixb) >=18,paramixb[18],NIL)        18
		AAdd( aParam, nil           ) // Local cOrigem   := If(len(paramixb) >=19,paramixb[19],NIL)        19
		AAdd( aParam, nil           ) // Local cEndereco := If(len(paramixb) >=20,paramixb[20],NIL)        20
		AAdd( aParam, nil           ) // Local cPedido   := If(len(paramixb) >=21,paramixb[21],NIL)        21
		AAdd( aParam, 0             ) // Local nResto    := If(len(paramixb) >=22,paramixb[22],0)          22
		AAdd( aParam, nil           ) // Local cItNFE    := If(len(paramixb) >=23,paramixb[23],NIL)        23   
		AAdd( aParam, oGrd:GetField('NUMPLT' , nLoop) ) // Local cPallet  := If(len(paramixb) >=24,paramixb[24],"")    24       
		AAdd( aParam, oGrd:GetField('PRODUTO' , nLoop)  ) // If(len(paramixb) >=25,paramixb[25],"")                     25       
		AAdd( aParam, oGrd:GetField('NUMLOTE' , nLoop)  )  //LOTE DO FORNECEDOR                                         26
		AAdd( aParam, oGrd:GetField('DTRVALID' , nLoop) )           // Data de Revalidade do lote               //27

		ExecBlock("IMG12",,,aParam )               	

	EndIF
	
Next nLoop

MsgStop("Alterado com sucesso!!!")
//oGrd:FromSql( cSql )
oGrdEnd:Refresh(.T.)
	
Return( nil )