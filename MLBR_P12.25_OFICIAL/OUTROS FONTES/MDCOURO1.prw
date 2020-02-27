#INCLUDE 'TOTVS.CH'
#include "tbiconn.ch"
#include 'topconn.ch'
#include 'parmtype.ch'

/*
//==========================================================================================
// MDCouro1 - Antonio Carlos - Advpl Tecnologia - maio / 2019
//------------------------------------------------------------------------------------------
// Descrição
// Monitor de Pallets de Couro/Quimicos de Acordo com NF Entrada (PNP1)
//------------------------------------------------------------------------------------------
// Parametros
// nenhum
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
*/

User Function MDCOURO1()

Local oPerg
Local nLoop

Private cSql     := ""
Private aHead    := {}
Private cPerg    := "MDCOU01"
Private oDlg, oGrdEnd

oPerg := AdvplPerg():New( cPerg )

//-------------------------------------------------------------------
//    AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
// Parametriza as perguntas
//-------------------------------------------------------------------
oPerg:AddPerg( "Informe a Data Inicial.:"   ,"D",TamSx3("ZO_EMISSNF")[1], , , "",,)
oPerg:AddPerg( "Informe a Data Final...:"   ,"D",TamSx3("ZO_EMISSNF")[1], , , "",,)

oPerg:AddPerg( "Informe a NF Inicial.:"     ,"C",TamSx3("ZO_NFORI")[1], , , "",,)
oPerg:AddPerg( "Informe a NF Final...:"     ,"C",TamSx3("ZO_NFORI")[1], , , "",,)

oPerg:AddPerg( "Informe o Pallet Inicial.:" ,"C",TamSx3("ZO_NUMPLT")[1], , , "",,)
oPerg:AddPerg( "Informe o Pallet Final...:" ,"C",TamSx3("ZO_NUMPLT")[1], , , "",,)
                                                                                           
oPerg:AddPerg( "Produto Inicial.:" ,"C",TamSx3("ZO_PRODUTO")[1], , , "",,)
oPerg:AddPerg( "Produto Final...:" ,"C",TamSx3("ZO_PRODUTO")[1], , , "",,)

oPerg:AddPerg( "(C)ouro / (Q)uimicos ?"     ,"C",1                     , ,{"C","Q"} , "",,)
oPerg:AddPerg( "Situação?             "     ,"C",1                     , ,{"1=Analise","2=Disponivel","4=Reprovado","6=Devolvido","T=Todos"} , "",,)

oPerg:AddPerg( "Ordenar Por?          "     ,"C",1                     , ,{"1=Data Nf","2=Nr Nf","3=Pallet"} , "",,)

//oPerg:AddPerg( "Situação?             "     ,"C",1                     , ,{"1","2","3","4","5","6","T"} , "",,)
//1=Analise;2=Disponivel;3=Consumido;4=Reprovado;5=Parcial;6=Devolvido                                                            
oPerg:SetPerg()

If ! Pergunte( cPerg, .t. )
	Return( nil )
EndIf
                    
//-----------------------------------------------
// Seleciona os registros
//-----------------------------------------------

cSql := "SELECT "
cSql += "       CB0_CODETI	   AS CODETIQ    , "
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
cSql += "INNER JOIN " + RetSqlName("CB0") + " CB0 ON "
cSql += "	SZO.ZO_FILIAL  = CB0.CB0_FILIAL AND "
cSql += "	SZO.ZO_NFORI   = CB0.CB0_NFENT  AND "
cSql += "	SZO.ZO_NUMPLT  = CB0.CB0_PALSZO AND "
cSql += "	SZO.ZO_PRODUTO = CB0.CB0_CODPRO AND "
cSql += "	SZO.ZO_NUMLOTE = CB0.CB0_LOTEFO AND "
cSql += "	CB0.D_E_L_E_T_ = ''  AND CB0.CB0_FILIAL = '" + xFILIAL("CB0") + "' "

cSql += "INNER JOIN " + RetSqlName("SA2") + " SA2 ON "
cSql += "	SA2.A2_COD     = SZO.ZO_CODFOR  AND SA2.A2_LOJA   = SZO.ZO_LJFOR AND "
cSql += "	SA2.D_E_L_E_T_ = ''             AND SA2.A2_FILIAL = '" + xFILIAL("SA2") + "' "
cSql += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON "
cSql += "	SB1.B1_COD     = SZO.ZO_PRODUTO AND "
cSql += "	SB1.D_E_L_E_T_ = ''             AND SB1.B1_FILIAL = '" + xFILIAL("SB1") + "' "
If MV_PAR09 == 1  //Couro
	cSql += "	AND SB1.B1_GRUPO IN('11') "
ElseIf MV_PAR09 == 2  //Quimicos
	cSql += "	AND SB1.B1_GRUPO IN('12','14') "
EndIf
cSql += "WHERE "
cSql += "	SZO.ZO_FILIAL = '" + xFILIAL("SZO") + "' AND "
cSql += "	SZO.D_E_L_E_T_ = ''         "
If !Empty(MV_PAR01) .AND. !Empty(MV_PAR02)
	cSql += "	AND SZO.ZO_EMISSNF  BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'  "
EndIf
If !Empty(MV_PAR03) .AND. !Empty(MV_PAR04)
	cSql += "	AND SZO.ZO_NFORI  BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'  "
EndIf
If !Empty(MV_PAR05) .AND. !Empty(MV_PAR06)
	cSql += "	AND SZO.ZO_NUMPLT  BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'  "
EndIf
If !Empty(MV_PAR07) .AND. !Empty(MV_PAR08)
	cSql += "	AND SZO.ZO_PRODUTO BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "'  "
EndIf

//1=Analise;2=Disponivel;3=Consumido;4=Reprovado;5=Parcial;6=Devolvido                                                            
If MV_PAR10 == 1  //Analise
	cSql += "	AND SZO.ZO_SITUACA = '1' "
ElseIf MV_PAR10 == 2  //Disponivel
	cSql += "	AND SZO.ZO_SITUACA = '2' "
ElseIf MV_PAR10 == 4  //Reprovado
	cSql += "	AND SZO.ZO_SITUACA = '4' "
ElseIf MV_PAR10 == 5  //Parcial
	cSql += "	AND SZO.ZO_SITUACA = '5' "
ElseIf MV_PAR10 == 6  //Devolvido
	cSql += "	AND SZO.ZO_SITUACA = '6' "
EndIf

If MV_PAR11 == 1  //Ordenar por data emissao Nf
	cSql += "	ORDER BY ZO_EMISSNF "
ElseIf MV_PAR11 == 2  //Ordenar por Nf + Serie
	cSql += "	ORDER BY ZO_NFORI,ZO_SERIE "
ElseIf MV_PAR11 == 3  //Ordenar por Numero do Pallet
	cSql += "	ORDER BY ZO_NUMPLT "
EndIf

//tcsetfield(cSql,'ZO_EMISSNF','D',8,0)

cSql := ChangeQuery( cSql )


//-----------------------------------------------
// Monta a dialog
//-----------------------------------------------

If MV_PAR09 == 1  //Couro
	oDlg:= uAdvplDlg():New(  "Monitor de Pallets de Couro de Acordo com NF Entrada (PNP1)", .t., .t., , nil, 100, 100 )
Else             //Quimicos
	oDlg:= uAdvplDlg():New(  "Monitor de Pallets de Quimicos de Acordo com NF Entrada (PNP1)", .t., .t., , nil, 100, 100 )
EndIf

Aadd(aHead, { "Filial"         , "FILIAL"     , "@!"   , 2                               , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Cod. Etiqueta"  , "CODETIQ"    , "@!"   , TamSX3("CB0_CODETI" )[1]        , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Nf Orig"        , "NFORI"      , "@!"   , TamSX3("ZO_NFORI"   )[1]        , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Série"          , "SERIE"      , "@!"   , TamSx3("ZO_SERIE"   )[1]        , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Dt Emiss NF"    , "EMISSNF"    , "@!"   , TamSx3("ZO_EMISSNF" )[1]        , 0 , ".F.", "", "D", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Dt Digitação NF", "DTDIGNF"    , "@!"   , TamSx3("ZO_DTLCMTO" )[1]        , 0 , ".F.", "", "D", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Cod Fornec"     , "CODFOR"     , "@!"   , TamSx3("ZO_CODFOR"  )[1]        , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Lj Fornec"      , "LJFOR"      , "@!"   , TamSx3("ZO_LJFOR"   )[1]        , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Nome"           , "A2NOME"     , "@!"   , 15 /*TamSx3("A2_NOME")[1]*/     , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Produto"        , "PRODUTO"    , "@!"   , 6 /*TamSx3("ZO_PRODUTO" )[1]*/  , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Descrição"      , "B1DESC"     , "@!"   , 15 /*TamSx3("B1_DESC")[1]*/     , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Lote"           , "NUMLOTE"    , "@!"   , TamSx3("ZO_NUMLOTE" )[1]        , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Dt Valid Lote"  , "DTVALID"    , "@!"   , TamSx3("ZO_DTVALID" )[1]        , 0 , ".F.", "", "D", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Nr Pallet"      , "NUMPLT"     , "@!"   , TamSx3("ZO_NUMPLT"  )[1]        , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
If MV_PAR09 == 1  //Couro
	Aadd(aHead, { "Qtd Couro"  , "QTDCOUR"    , "@!"   , TamSx3("ZO_QTDCOUR" )[1]        , 0 , ".F.", "", "N", ""   , "R","","", ".F.", "A", ""} )
	Aadd(aHead, { "Qtde Vqt"   , "QTDEVQ"     , "@!"   , TamSx3("ZO_QTDEVQ " )[1]        , 0 , ".F.", "", "N", ""   , "R","","", ".F.", "A", ""} )
	Aadd(aHead, { "Qtde M2 "   , "QTDEM2"     , "@E 999,999.9999"   , 12                 , 4 , ".F.", "", "N", ""   , "R","","", ".F.", "A", ""} )
	Aadd(aHead, { "Vlr Média"  , "M2VQPLT"    , "@E 999.99"         ,  6                 , 2 , ".F.", "", "N", ""   , "R","","", ".F.", "A", ""} )
Else             //quimicos
	Aadd(aHead, { "Qtde Kg "   , "QTDEM2"     , "@E 999,999.9999"   , 12                 , 4 , ".F.", "", "N", ""   , "R","","", ".F.", "A", ""} )
EndIf
Aadd(aHead, { "Situação"       , "SITUCOD"    , "@!"   , TamSx3("ZO_SITUACA" )[1]        , 0 , ".T.", "", "C", ""   , "R","","", ".T.", "A", ""} )
Aadd(aHead, { "Descrição"      , "SITUACA"    , "@!"   , TamSx3("ZO_SITUACA" )[1]        , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Endereço"       , "ENDERE"     , "@!"   , TamSx3("ZO_ENDERE" )[1]         , 0 , ".T.", "", "C", ""   , "R","","", ".T.", "A", ""} )


/*
//Aadd(aHead, { "Situação"      , "SITUCOD"    , "@!"   , TamSx3("ZO_SITUACA" )[1]        , 0 , ".T.", "", "C", ""   , "R","","", ".T.", "A", "U_USIT()"} )
1 - TITULO, ;
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

oGrdEnd:AddButton( "Salvar Alterações", { || Processa( {|| MonSalv(@oGrdEnd) }, "Aguarde..." ) } )

oGrdEnd:Load()
oGrdEnd:FromSql( cSql )
oGrdEnd:SetAlignAllClient()

oDlg:SetInit( {|| oGrdEnd:Refresh(.t.)})
oDlg:Activate()

Return( Nil )
						                                                      

User Function USIT()
	MonSalv(@oGrdEnd)
	oGrdEnd:Refresh(.t.)
Return(.t.)
						

//==========================================================================================
// MonSalv - Antonio - Advpl Tecnologia - Maio / 2019
//------------------------------------------------------------------------------------------
// Descrição
// Monta o array com os produtos que serão alterados o endereço
//------------------------------------------------------------------------------------------
// Parametros
// Nenhum
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
Static Function MonSalv(oGrd)

Local nLoop

ProcRegua( 0 )

//
For nLoop := 1 to Len( oGrd:aCols )
	
	IncProc()
	
	If !Empty(oGrd:GetField("ENDERE"  , nLoop)) .or. !Empty(oGrd:GetField("SITUCOD"  , nLoop))

		cQuery := " UPDATE SZO010 "
		cQuery += " SET ZO_SITUACA   = '" + oGrd:GetField("SITUCOD" , nLoop) + "' "
		cQuery += "  ,  ZO_ENDERE    = '" + oGrd:GetField("ENDERE"  , nLoop) + "' "
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


	EndIF
	
Next nLoop

MsgStop("Alterado com sucesso!!!")
//oGrd:FromSql( cSql )
	
Return( nil )

						
