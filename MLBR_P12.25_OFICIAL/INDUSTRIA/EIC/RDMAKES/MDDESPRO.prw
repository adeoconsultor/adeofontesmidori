#INCLUDE 'TOTVS.CH'
#include "tbiconn.ch"
#include 'topconn.ch'
#include 'parmtype.ch'

/*
//==========================================================================================
// MDDESPRO - Antonio Carlos - Advpl Tecnologia - Janeiro / 2019
//------------------------------------------------------------------------------------------
// Descri��o
// Despesas Imp. Por Processos
//------------------------------------------------------------------------------------------
// Parametros
// nenhum
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
*/

User Function MDDESPRO()

Local oGrdEnd    := nil
Local oPerg
Local nLoop

Private cSql     := ""
Private aHead    := {}
Private cPerg    := "MU261M"
Private oDlg, oGrdEnd

oPerg := AdvplPerg():New( cPerg )

//-------------------------------------------------------------------
//    AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
// Parametriza as perguntas
//-------------------------------------------------------------------
oPerg:AddPerg( "Informe o Data Inicial.:" ,"D",TamSx3("W6_DT_HAWB")[1], , , "",,)
oPerg:AddPerg( "Informe o Data Final...:" ,"D",TamSx3("W6_DT_HAWB")[1], , , "",,)

oPerg:AddPerg( "Informe a Filial Inicial.:" ,"C",TamSx3("W6_FILIAL")[1], , , "",,)
oPerg:AddPerg( "Informe a Filial Final...:" ,"C",TamSx3("W6_FILIAL")[1], , , "",,)

oPerg:SetPerg()

If ! Pergunte( cPerg, .t. )
	Return( nil )
EndIf
                    
//-----------------------------------------------
// Seleciona os registros
//-----------------------------------------------

cSql := "SELECT DISTINCT "
cSql += "       WD_FILIAL  AS FILIAL       , "
cSql += "       WD_HAWB    AS HAMB         , "
cSql += "       W6_DT_HAWB AS DATA_PROCES  , "
cSql += "       WD_DESPESA AS DESPESAS     , " 
cSql += "       YB_DESCR   AS DESCRICAO    , "
cSql += "       WD_VALOR_R AS VALOR_R      , "
cSql += "       W6_DT_EMB  AS DATA_EMB     , "
cSql += "       W6_DI_NUM  AS DI_NUM       , "  
cSql += "       W6_DTREG_D AS DATA_REG_DI  , "
cSql += "       W6_NF_ENT  AS NF_ENT       , " 
cSql += "       W6_SE_NF   AS SE_NF        , "
cSql += "       W6_DT_NF   AS DATA_EMIS_NF   "
cSql += "FROM " + RetSqlName("SWD") + " SWD "
cSql += "INNER JOIN " + RetSqlName("SYB") + " SYB ON "
cSql += "	YB_DESP        = WD_DESPESA AND "
cSql += "	SYB.D_E_L_E_T_ = ''          "
cSql += "INNER JOIN " + RetSqlName("SW6") + " SW6 ON "
cSql += "	W6_FILIAL      = WD_FILIAL AND "
cSql += "	W6_HAWB        = WD_HAWB   AND "
cSql += "	SW6.D_E_L_E_T_ = ''         "

If !Empty(MV_PAR03) .AND. !Empty(MV_PAR04)
	cSql += "	AND W6_FILIAL  BETWEEN  '" + MV_PAR03       + "' AND '" + MV_PAR04       + "'  "
EndIf

cSql += "WHERE "
cSql += "	W6_DT_HAWB BETWEEN  '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'  AND "             //'20180101' and '20181130' AND 
cSql += "	SWD.D_E_L_E_T_ = ''  "
If !Empty(MV_PAR03) .AND. !Empty(MV_PAR04)
	cSql += "	AND WD_FILIAL  BETWEEN  '" + MV_PAR03       + "' AND '" + MV_PAR04       + "' "
EndIf
cSql := ChangeQuery( cSql )

//-----------------------------------------------
// Monta a dialog
//-----------------------------------------------
oDlg:= uAdvplDlg():New(  "Despesas Imp. Por Processos", .t., .t., , nil, 100, 100 )
//PesqPict('ZZS',"ZZS_QTDE")
//Aadd(aHead, {   "Dt Validade" , "DTVALID"  , "@!"               , TamSx3("ZZS_DTVALI")[1] , 0 , ".f.", "", "D", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Filial"        , "FILIAL"      , "@!"            , 2                         , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Hamb"          , "HAMB"        , "@!"            , TamSX3("WD_HAWB"   )[1]   , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Data Processo" , "DATA_PROCES" , "@!"            , TamSx3("W6_DT_HAWB")[1]   , 0 , ".F.", "", "D", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Despesas"      , "DESPESAS"    , "@!"            , TamSx3("WD_DESPESA")[1]   , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Descri��o"     , "DESCRICAO"   , "@!"            , 20/*TamSx3("YB_DESCR"  )[1]*/   , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Valor R$"      , "VALOR_R"     , PesqPict('SWD',"WD_VALOR_R") , TamSx3("WD_VALOR_R")[1] , 2 , ".F.", "", "N", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Data Emb"      , "DATA_EMB"    , "@!"            , TamSx3("W6_DT_EMB" )[1]   , 0 , ".F.", "", "D", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "DI Num"        , "DI_NUM"      , "@!"            , TamSX3("W6_DI_NUM" )[1]   , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Data Reg DI"   , "DATA_REG_DI" , "@!"            , TamSx3("W6_DTREG_D")[1]   , 0 , ".F.", "", "D", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "NF Ent"        , "NF_ENT"      , "@!"            , TamSx3("F1_DOC" )[1]      , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "SE NF"         , "SE_NF"       , "@!"            , TamSx3("D1_SERIE"  )[1]   , 0 , ".F.", "", "C", ""   , "R","","", ".F.", "A", ""} )
Aadd(aHead, { "Data NF"       , "DATA_EMIS_NF", "@!"            , TamSx3("W6_DT_NF"  )[1]   , 0 , ".F.", "", "D", ""   , "R","","", ".F.", "A", ""} )

oGrdEnd:= MyGrid():New( 000, 000, 000, 000, GD_UPDATE,,,,,, 99999,,,, oDlg:oPnlCenter )

For nLoop := 1 to Len( aHead )
	oGrdEnd:AddColumn( aHead[nLoop] )
Next nLoop

//oGrdEnd:AddColBMP("MARCA","UNCHECKED_15")

oGrdEnd:SeekSet()
oGrdEnd:IndexSet()
oGrdEnd:SheetSet()

//oGrdEnd:AddButton( "Gerar Planilha " , { || Processa( {|| U_UGerPlan(@oGrdEnd) }, "Aguarde..." ) } )
//oGrdEnd:AddButton( "Estornar Marcados "   , { || Processa( {|| MonEnd(@oGrdEnd,2) }, "Aguarde..." ) } )
oGrdEnd:Load()
oGrdEnd:FromSql( cSql )
oGrdEnd:SetAlignAllClient()
//oGrdEnd:SetDoubleClick( {|| oGrdEnd:SetField("MARCA", IIF(oGrdEnd:GetField("MARCA") == "BR_VERDE","UNCHECKED_15", "BR_VERDE" /*MarDes(@oGrdEnd)*/ )) } )

oDlg:SetInit( {|| oGrdEnd:Refresh(.t.)})
oDlg:Activate()

Return( Nil )
                                                                           

User Function UGerPlan(oGrd)

	Local nLoop
	Local aDados := {}
	Local cxFilial, cHamb , cDtPro, cDesp, cDescri, cValorR, cDtEmb, cDINum, cDtRegDI, cNFEnt, cSENF, cDtEmiNF

// Titulo
                //  1    2            3             4                  5                6    7      8        9       10   11   12
   	AAdd(aDaDOS, { ' ', ' ', 'Midori AutoLeather', ' ', 'Despesas Imp. Por Processos', ' ', ' ', 'Data:', dDatabase, ' ', ' ', ' ' })

// Pula uma linha

                //  1    2    3    4    5    6    7    8    9   10   11   12
   	AAdd(aDaDOS, { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' })

// Cabec 1
	
   	AAdd(aDaDOS, {	"Filial"        ,;              // 1
					"Hamb"          ,;              // 2
					"Data Processo" ,;              // 3
					"Despesas"      ,;              // 4
					"Descricao"     ,;              // 5
					"Valor R$"      ,;              // 6
					"Data Emb"      ,;              // 7
					"DI Num"        ,;              // 8
					"Data Reg DI"   ,;              // 9
					"NF Ent"        ,;              // 10
					"SE NF"         ,;              // 11
					"Data NF"        })             // 12

// Pula uma linha

                //  1    2    3    4    5    6    7    8    9   10   11   12
   	AAdd(aDaDOS, { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' })

// Dados

	For nLoop := 1 to Len( oGrd:aCols )     

		cxFilial  := oGrd:GetField("FILIAL"       , nLoop)
		cHamb    := oGrd:GetField("HAMB"         , nLoop)
		cDtPro   := oGrd:GetField("DATA_PROCES"  , nLoop)
		cDesp    := oGrd:GetField("DESPESAS"     , nLoop)

		cDescri  := oGrd:GetField("DESCRICAO"    , nLoop)
		cValorR  := oGrd:GetField("VALOR_R"      , nLoop)
		cDtEmb   := oGrd:GetField("DATA_EMB"     , nLoop)
		cDINum   := oGrd:GetField("DI_NUM"       , nLoop)

		cDtRegDI := oGrd:GetField("DATA_REG_DI"  , nLoop)
		cNFEnt   := oGrd:GetField("NF_ENT"       , nLoop)
		cSENF    := oGrd:GetField("SE_NF"        , nLoop)
		cDtEmiNF := oGrd:GetField("DATA_EMIS_NF" , nLoop)
                      //  1       2       3      4      5         6       7        8       9        10      11      12
	   	AAdd(aDaDOS, {cxFilial, cHamb, cDtPro, cDesp, cDescri, cValorR, cDtEmb, cDINum, cDtRegDI, cNFEnt, cSENF, cDtEmiNF })
	
	Next
	

	IF (Len(aDados) > 0)
	
		cArqGer := MkExcWB(.F., aDados)
		
		IF (cArqGer <> Nil)
			IF !ApOleClient( 'MsExcel' )
				MsgAlert("O excel n�o foi encontrado. Arquivo " + cArqGer + " gerado em " + GetClientDir( ) + ".", "MsExcel n�o encontrado" )
			ELSE
				oExcelApp := MsExcel():New()
				oExcelApp:WorkBooks:Open(cArqGer)
				oExcelApp:SetVisible(.T.)
			EndIF
		EndIF
		
	ELSE
	
		MsgInfo("Os dados selecionados nos par�metros n�o retornaram nenhum resultado!")
		
	EndIF  


Return



/*
��������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FS_MkExcWB�Autor  �                    � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria um arquivo XML para o Excel no diret�rio indicado,    ���
���          � o no diret�rio informado pelo par�metro                    ���
�������������������������������������������������������������������������͹��
���Par�metros� aItens: Matriz MxN que cont�m os dados a serem colocados   ���
���          �         na planilha                                        ���
���          � aCabec: Cabe�alho da planilha colocado na primeira linha   ���
���          � lCabec: Indica se a primiera linha da matriz corresponde   ���
���          �         ao cabe�alho da planilha                           ���
���          � cDirSrv:Diret�rio no servidor onde ser� salvo o arquivo    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Retorna   �O nome do arquivo salvo no servidor ou Nil, caso n�o seja   ���
���          �possivel efetuar a grava��o                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MkExcWB( lCabec, aItens, aCabec, cDirServer )
	Local cCreate   := AllTrim( Str( Year( dDataBase ) ) ) + "-" + AllTrim( Str( Month( dDataBase ) ) ) + "-" + AllTrim( Str( Day( dDataBase ) ) ) + "T" + SubStr( Time(), 1, 2 ) + ":" + SubStr( Time(), 4, 2 ) + ":" + SubStr( Time(), 7, 2 ) + "Z" // string de data no formato <Ano>-<Mes>-<Dia>T<Hora>:<Minuto>:<Segundo>Z
	Local nFields   := 12 // N� de Colunas  formato string
	Local nRecords  := 12 // Numero de Linhas + Cabe�alho formato string
	Local cFileName := CriaTrab( , .F. )
	Local i, j

	Local cDirNI    := UZXChoseDir()

	//	cFileName := Lower(GetClientDir( ) + cFileName + ".XLS")
	//cFileName := Lower("\\172.17.0.183\temp\Jairson\"+ cFileName + ".XLS")

	cFileName := Lower(cDirNI + cFileName + ".XLSX")

	If Empty( aItens )
		aItens := aClone( aCols )
	End
	
	If Empty(aCabec) .AND. lCabec
		For i := 1 To Len( aHeader )
			AAdd( aCabec, aHeader[i][1] )
		Next
	EndIf
	
	If lCabec == Nil
		lCabec := .T.
	EndIf
	
	nRecords := Len( aItens)
			
/*	If lCabec
		nFields := Len( aCabec )
	Else
		nFields := Len( aItens[1] )
	EndIf
  */			
		
	If ( nHandle := FCreate( cFileName ) ) != -1
		ConOut("Arquivo criado com sucesso.")
	Else
		MsgAlert("N�o foi possivel criar a planilha. Por favor, verifique se existe espa�o em disco ou voc� possui pemiss�o de escrita no diret�rio \system\", "Erro de cria��o de arquivo")
		ConOut("N�o foi possivel criar a planilha no diret�rio \system\")
	 Return()
	EndIf
 		
	cFile := "<?xml version=" + Chr(34) + "1.0" + Chr(34) + "?>" + Chr(13) + Chr(10)
	cFile += "<?mso-application progid=" + Chr(34) + "Excel.Sheet" + Chr(34) + "?>" + Chr(13) + Chr(10)
	cFile += "<Workbook xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:spreadsheet" + Chr(34) + " " + Chr(13) + Chr(10)
	cFile += "	xmlns:o=" + Chr(34) + "urn:schemas-microsoft-com:office:office" + Chr(34) + " " + Chr(13) + Chr(10)
	cFile += "	xmlns:x=" + Chr(34) + "urn:schemas-microsoft-com:office:excel" + Chr(34) + " " + Chr(13) + Chr(10)
	cFile += "	xmlns:ss=" + Chr(34) + "urn:schemas-microsoft-com:office:spreadsheet" + Chr(34) + " " + Chr(13) + Chr(10)
	cFile += "	xmlns:html=" + Chr(34) + "http://www.w3.org/TR/REC-html40" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "	<DocumentProperties xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:office" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "		<Author>" + AllTrim(SubStr(cUsuario,7,15)) + "</Author>" + Chr(13) + Chr(10)
	cFile += "		<LastAuthor>" + AllTrim(SubStr(cUsuario,7,15)) + "</LastAuthor>" + Chr(13) + Chr(10)
	cFile += "		<Created>" + cCreate + "</Created>" + Chr(13) + Chr(10)
	cFile += "		<Company>Microsiga Intelligence</Company>" + Chr(13) + Chr(10)
	cFile += "		<Version>11.6568</Version>" + Chr(13) + Chr(10)
	cFile += "	</DocumentProperties>" + Chr(13) + Chr(10)
	cFile += "	<ExcelWorkbook xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:excel" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "		<WindowHeight>9345</WindowHeight>" + Chr(13) + Chr(10)
	cFile += "		<WindowWidth>11340</WindowWidth>" + Chr(13) + Chr(10)
	cFile += "		<WindowTopX>480</WindowTopX>" + Chr(13) + Chr(10)
	cFile += "		<WindowTopY>60</WindowTopY>" + Chr(13) + Chr(10)
	cFile += "		<ProtectStructure>False</ProtectStructure>" + Chr(13) + Chr(10)
	cFile += "		<ProtectWindows>False</ProtectWindows>" + Chr(13) + Chr(10)
	cFile += "	</ExcelWorkbook>" + Chr(13) + Chr(10)
	cFile += "	<Styles>" + Chr(13) + Chr(10)
	cFile += "		<Style ss:ID=" + Chr(34) + "Default" + Chr(34) + " ss:Name=" + Chr(34) + "Normal" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "			<Alignment ss:Vertical=" + Chr(34) + "Bottom" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "			<Borders/>" + Chr(13) + Chr(10)
	cFile += "			<Font/>" + Chr(13) + Chr(10)
	cFile += "			<Interior/>" + Chr(13) + Chr(10)
	cFile += "			<NumberFormat/>" + Chr(13) + Chr(10)
	cFile += "			<Protection/>" + Chr(13) + Chr(10)
	cFile += "		</Style>" + Chr(13) + Chr(10)
	cFile += "	<Style ss:ID=" + Chr(34) + "s21" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "		<NumberFormat ss:Format=" + Chr(34) + "Short Date" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "	</Style>" + Chr(13) + Chr(10)
	cFile += "	</Styles>" + Chr(13) + Chr(10)
	cFile += " <Worksheet ss:Name=" + Chr(34) + "Planilha Nova " + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "		<Table ss:ExpandedColumnCount=" + Chr(34) + AllTrim( Str( nFields ) ) + Chr(34) + " ss:ExpandedRowCount=" + Chr(34) + AllTrim( Str( Iif( lCabec, 1 + nRecords, nRecords ) ) ) + Chr(34) + " x:FullColumns=" + Chr(34) + "1" + Chr(34) + " x:FullRows=" + Chr(34) + "1" + Chr(34) + ">" + Chr(13) + Chr(10)
							
	// Linha de Cabe�alho 
	If lCabec
		cFile += "			<Row>" + Chr(13) + Chr(10)
		For i := 1 To nFields
			cFile += "				<Cell><Data ss:Type=" + Chr(34) + "String" + Chr(34) + ">" + AllTrim(aCabec[i]) + "</Data></Cell>" + Chr(13) + Chr(10)
		Next
		cFile += "			</Row>" + Chr(13) + Chr(10)
	EndIf
			
	If nHandle >=0
	 FWrite(nHandle, cFile)
	 cFile := ""
	Endif
				
	For i := 1 To nRecords
		cFile += "			<Row>" + Chr(13) + Chr(10)
		For j := 1 To nFields
			cFile += "				" + FS_GetCell(aItens[i][j]) + Chr(13) + Chr(10)
		Next
		cFile += "			</Row>" + Chr(13) + Chr(10)
	 If (i % 100) == 0
	  If nHandle >=0
	   FWrite(nHandle, cFile)
		  cFile := ""
	  Endif
	 Endif
	Next
   
  
 cFile += "		</Table>" + Chr(13) + Chr(10)
 cFile += "		<WorksheetOptions xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:excel" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "			<PageSetup>" + Chr(13) + Chr(10)
	cFile += "				<Header x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "				<Footer x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "				<PageMargins x:Bottom=" + Chr(34) + "0.984251969" + Chr(34) + " x:Left=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Right=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Top=" + Chr(34) + "0.984251969" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "			</PageSetup>" + Chr(13) + Chr(10)
	cFile += "			<Selected/>" + Chr(13) + Chr(10)
	cFile += "			<ProtectObjects>False</ProtectObjects>" + Chr(13) + Chr(10)
	cFile += "			<ProtectScenarios>False</ProtectScenarios>" + Chr(13) + Chr(10)
	cFile += "		</WorksheetOptions>" + Chr(13) + Chr(10)
	cFile += "	</Worksheet>" + Chr(13) + Chr(10)
  
	cFile += "	<Worksheet ss:Name=" + Chr(34) + "Plan2" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "		<WorksheetOptions xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:excel" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "			<PageSetup>" + Chr(13) + Chr(10)
	cFile += "				<Header x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "				<Footer x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "				<PageMargins x:Bottom=" + Chr(34) + "0.984251969" + Chr(34) + " x:Left=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Right=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Top=" + Chr(34) + "0.984251969" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "			</PageSetup>" + Chr(13) + Chr(10)
	cFile += "			<ProtectObjects>False</ProtectObjects>" + Chr(13) + Chr(10)
	cFile += "			<ProtectScenarios>False</ProtectScenarios>" + Chr(13) + Chr(10)
	cFile += "		</WorksheetOptions>" + Chr(13) + Chr(10)
	cFile += "	</Worksheet>" + Chr(13) + Chr(10)
	cFile += "	<Worksheet ss:Name=" + Chr(34) + "Plan3" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "		<WorksheetOptions xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:excel" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "			<PageSetup>" + Chr(13) + Chr(10)
	cFile += "				<Header x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "				<Footer x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "				<PageMargins x:Bottom=" + Chr(34) + "0.984251969" + Chr(34) + " x:Left=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Right=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Top=" + Chr(34) + "0.984251969" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "			</PageSetup>" + Chr(13) + Chr(10)
	cFile += "			<ProtectObjects>False</ProtectObjects>" + Chr(13) + Chr(10)
	cFile += "			<ProtectScenarios>False</ProtectScenarios>" + Chr(13) + Chr(10)
	cFile += "		</WorksheetOptions>" + Chr(13) + Chr(10)
	cFile += "	</Worksheet>" + Chr(13) + Chr(10)
	cFile += "</Workbook>" + Chr(13) + Chr(10)
	
	ConOut("Criando o arquivo " + cFileName + ".")
	If nHandle  >= 0
		FWrite(nHandle, cFile)
		FClose(nHandle)
		ConOut("Arquivo criado com sucesso.")
	Else
		MsgAlert("N�o foi possivel criar a planilha. Por favor, verifique se existe espa�o em disco ou voc� possui pemiss�o de escrita no diret�rio \system\", "Erro de cria��o de arquivo")
		ConOut("N�o foi possivel criar a planilha no diret�rio \system\")
	EndIf
	
Return cFileName

                  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FS_GetCell�Autor  �     Microsiga      � Data �  18/04/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera arquivo no SX1                                        ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������	
 */
Static Function FS_GetCell( xVar )
	Local cRet  := ""
	Local cType := ValType(xVar)
	
	If cType == "U"
		cRet := "<Cell><Data ss:Type=" + Chr(34) + "General" + Chr(34) + "></Data></Cell>"
	ElseIf cType == "C"
		cRet := "<Cell><Data ss:Type=" + Chr(34) + "String" + Chr(34) + ">" + AllTrim( xVar ) + "</Data></Cell>"
	ElseIf cType == "N"
		cRet := "<Cell><Data ss:Type=" + Chr(34) + "Number" + Chr(34) + ">" + AllTrim( Str( xVar ) ) + "</Data></Cell>"
	ElseIf cType == "D"
		xVar := DToS( xVar )
	           //<Cell ss:StyleID=              "s21"              ><Data ss:Type=              "DateTime"              >    2006                  -    12                    -    27                    T00:00:00.000</Data></Cell>
		cRet := "<Cell ss:StyleID=" + Chr(34) + "s21" + Chr(34) + "><Data ss:Type=" + Chr(34) + "DateTime" + Chr(34) + ">" + SubStr(xVar, 1, 4) + "-" + SubStr(xVar, 5, 2) + "-" + SubStr(xVar, 7, 2) + "T00:00:00.000</Data></Cell>"
	Else
		cRet := "<Cell><Data ss:Type=" + Chr(34) + "Boolean" + Chr(34) + ">" + Iif ( xVar , "=VERDADEIRO" ,  "=FALSO" ) + "</Data></Cell>"
	EndIf

Return cRet          


*-----------------------------------------*
Static Function UZXChoseDir()
*-----------------------------------------*
Local cTitle:= "Gera��o de arquivo"
Local cMask := "Formato *|*.*"
Local cFile := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions:= GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY

cFile:= cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,.F., nOptions)

Return(cFile)
