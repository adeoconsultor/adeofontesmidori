#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH" 
#INCLUDE "TBICONN.CH"
                               
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMD_PL  บAutor  ณAntonio Damaceno    บData  ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
    
User Function MD_PL()
	Local lRet := .t.
	Local dDataI:=dDataBase //Ctod("09/08/2016")
	Local oData

	Local cPallet:=Space(10)
	Local oPallet
	
	Private oDlg
	Private nOpc
	
	//Monta interface com o usuแrio
	DEFINE MSDIALOG oDlg TITLE "ETIQUETAS DE PALLET" FROM C(164),C(182) TO C(325),C(409) PIXEL
	
	// Cria as Groups do Sistema
//	@ C(003),C(003) TO C(102),C(260) LABEL "Informe a Data: " PIXEL OF oDlg
	
	// Cria Componentes Padroes do Sistema
//	@ C(013),C(008) Say "Data:" Size C(038),C(008) COLOR CLR_BLACK PIXEL OF oDlg
//	@ C(013),C(030) MsGet oData Var dDataI Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg

	@ C(003),C(003) TO C(102),C(260) LABEL "Informe o PALLET" PIXEL OF oDlg
	
	// Cria Componentes Padroes do Sistema
	@ C(013),C(008) Say "Pallet:" Size C(038),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(013),C(030) MsGet oPallet Var cPallet Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg


	
	DEFINE SBUTTON FROM C(028),C(046) TYPE 1 ENABLE OF oDlg ACTION {||nOpc := 1,oDlg:End()}
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpc == 1
		Processa( {||lRet := u_cRELPROVF(dDataI,cPallet)}, "Aguarde..." )
//		Processa( {||lRet := u_RELPROVF(dDataI,cPallet)}, "Aguarde..." )
	EndIf
	
Return( lRet )


User Function cRELPROVF(dDataI,cPallet)           

Local aArea   := GetArea()

Local cQryRes := "" //Query pata resultados ja obtidos
Local aDados  := {}           
Local cArqGer
Local lImp:=.t.


cQryRes := " SELECT "
cQryRes += " CB0_CODETI,CB0_CODPRO,SB1.B1_DESC,CB0_PALLET,CB0_DTNASC,CB0_OP "
cQryRes += " FROM " + RetSqlName("CB0") + " CB0 "
cQryRes += "   INNER JOIN " + RetSqlName("SB1") + " SB1 ON "
cQryRes += "         SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
cQryRes += "         SB1.B1_COD    = CB0.CB0_CODPRO AND "
cQryRes += "         SB1.D_E_L_E_T_ = ' ' "
//cQryRes += "  WHERE CB0.CB0_DTNASC = " + DtoS(dDATAI) + ""
cQryRes += "  WHERE CB0.CB0_PALLET = '" + cPallet + "'"
cQryRes += "  AND CB0.CB0_OP <> ' ' "
cQryRes += "  AND CB0.CB0_PALLET <> ' ' "
cQryRes += " ORDER BY CB0.CB0_CODETI "             
cQryRes := ChangeQuery(cQryRes)
TCQUERY cQryRes NEW ALIAS "QRYRES"


WHILE !(QRYRES->(EOF()))

  	If lImp
          //cod etq, cod prod,descricao produto, nr pallet, data pallet, nf , nr op , data op
	   	AAdd(aDaDOS, {"","",SM0->M0_CODIGO + ' ' +SM0->M0_NOMECOM + "Data: "+DtoC(dDataBase),"","","","","" })
	   	AAdd(aDaDOS, {"","","E T I Q U E T A  S   D E   P A L L E T   G E R A D A S","","","","",""})
	   	AAdd(aDaDOS, {'Cod Etq',    'Produto',    'Descricao',      'Pallet',      'Data Pallet',      'Nf',      'Nr Op',  'Data Op'})
		lImp:=.f.
	EndIf
		
//   	AAdd(aDaDOS, {QRYRES->CB0_CODETI+" "+ QRYRES->CB0_CODPRO+" "+ QRYRES->B1_DESC+" "+ QRYRES->CB0_PALLET+" "+ QRYRES->CB0_OP+" "})
	   	AAdd(aDaDOS, {QRYRES->CB0_CODETI,QRYRES->CB0_CODPRO,QRYRES->B1_DESC,QRYRES->CB0_PALLET,CB0_DTNASC," ",QRYRES->CB0_OP,"  "})
	   	
	QRYRES->(DBSkip())
End

IF (Len(aDados) > 0)

	cArqGer := MkExcWB(.F., aDados)
	
	IF (cArqGer <> Nil)
		IF !ApOleClient( 'MsExcel' )
			MsgAlert("O excel nใo foi encontrado. Arquivo " + cArqGer + " gerado em " + GetClientDir( ) + ".", "MsExcel nใo encontrado" )
		ELSE
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open(cArqGer)
			oExcelApp:SetVisible(.T.)
		EndIF
	EndIF  ^
	
ELSE

	MsgInfo("Os dados selecionados nos parโmetros nใo retornaram nenhum resultado!")
	
EndIF  

QRYRES->(dbCloseArea()) 

Return
*/       



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFS_MkExcWBบAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria um arquivo XML para o Excel no diret๓rio indicado,    บฑฑ
ฑฑบ          ณ o no diret๓rio informado pelo parโmetro                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParโmetrosณ aItens: Matriz MxN que cont้m os dados a serem colocados   บฑฑ
ฑฑบ          ณ         na planilha                                        บฑฑ
ฑฑบ          ณ aCabec: Cabe็alho da planilha colocado na primeira linha   บฑฑ
ฑฑบ          ณ lCabec: Indica se a primiera linha da matriz corresponde   บฑฑ
ฑฑบ          ณ         ao cabe็alho da planilha                           บฑฑ
ฑฑบ          ณ cDirSrv:Diret๓rio no servidor onde serแ salvo o arquivo    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorna   ณO nome do arquivo salvo no servidor ou Nil, caso nใo seja   บฑฑ
ฑฑบ          ณpossivel efetuar a grava็ใo                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MkExcWB( lCabec, aItens, aCabec, cDirServer )
	Local cCreate   := AllTrim( Str( Year( dDataBase ) ) ) + "-" + AllTrim( Str( Month( dDataBase ) ) ) + "-" + AllTrim( Str( Day( dDataBase ) ) ) + "T" + SubStr( Time(), 1, 2 ) + ":" + SubStr( Time(), 4, 2 ) + ":" + SubStr( Time(), 7, 2 ) + "Z" // string de data no formato <Ano>-<Mes>-<Dia>T<Hora>:<Minuto>:<Segundo>Z
	Local nFields   := 8 // Nบ de Colunas  formato string
	Local nRecords  := 8 // Numero de Linhas + Cabe็alho formato string
	Local cFileName := CriaTrab( , .F. )
	Local i, j

	
	cFileName := Lower(GetClientDir( ) + cFileName + ".XLS")
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
		
	If ( nHandle := FCreate( cFileName , FC_NORMAL ) ) != -1
		ConOut("Arquivo criado com sucesso.")
	Else
		MsgAlert("Nใo foi possivel criar a planilha. Por favor, verifique se existe espa็o em disco ou voc๊ possui pemissใo de escrita no diret๓rio \system\", "Erro de cria็ใo de arquivo")
		ConOut("Nใo foi possivel criar a planilha no diret๓rio \system\")
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
							
	// Linha de Cabe็alho 
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
		MsgAlert("Nใo foi possivel criar a planilha. Por favor, verifique se existe espa็o em disco ou voc๊ possui pemissใo de escrita no diret๓rio \system\", "Erro de cria็ใo de arquivo")
		ConOut("Nใo foi possivel criar a planilha no diret๓rio \system\")
	EndIf
	
Return cFileName
*/
                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFS_GetCellบAutor  ณ     Microsiga      บ Data ณ  18/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera arquivo no SX1                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿	
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
                

/*
User Function RELPROVF(dDataI,cPallet)           

Local aArea   := GetArea()

Local aCabExcel :={}
Local aItensExcel :={}

// AADD(aCabExcel, {"TITULO DO CAMPO", "TIPO", NTAMANHO, NDECIMAIS})

AADD(aCabExcel, {"CB0_CODETI" ,"C", 10, 0})
AADD(aCabExcel, {"CB0_CODPRO" ,"C", 15, 0})
AADD(aCabExcel, {"B1_DESC"    ,"C", 40, 0})
AADD(aCabExcel, {"CB0_PALLET" ,"C", 10, 0})
AADD(aCabExcel, {"CB0_DTNASC" ,"D", 08, 0})
AADD(aCabExcel, {"CB0_OP"     ,"C", 13, 0})
AADD(aCabExcel, {"CB0_OP"     ,"C", 13, 0})

MsgRun("Favor Aguardar.....", "Selecionando os Registros",{|| GProcItens(aCabExcel, @aItensExcel, dDataI, cPallet)})
MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"GETDADOS",;
"E T I Q U E T A  S   D E   P A L L E T   G E R A D A S",aCabExcel,aItensExcel}})})

Return()


        
Static Function GProcItens(aHeader, aCols, dDataI, cPallet)

Local aItem   := {}
Local nX
Local cQryRes := "" //Query pata resultados ja obtidos
Local aDados  := {}

cQryRes := " SELECT "
cQryRes += " CB0_CODETI,CB0_CODPRO,SB1.B1_DESC,CB0_PALLET,CB0_DTNASC,CB0_OP "
cQryRes += " FROM " + RetSqlName("CB0") + " CB0 "
cQryRes += "   INNER JOIN " + RetSqlName("SB1") + " SB1 ON "
cQryRes += "         SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
cQryRes += "         SB1.B1_COD    = CB0.CB0_CODPRO AND "
cQryRes += "         SB1.D_E_L_E_T_ = ' ' "
//cQryRes += "  WHERE CB0.CB0_DTNASC = " + DtoS(dDATAI) + ""
cQryRes += "  WHERE CB0.CB0_PALLET = " + cPallet + ""
cQryRes += "  AND CB0.CB0_OP <> ' ' "
cQryRes += "  AND CB0.CB0_PALLET <> ' ' "
cQryRes += " ORDER BY CB0.CB0_CODETI "             
cQryRes := ChangeQuery(cQryRes)
TCQUERY cQryRes NEW ALIAS "QRYRES"

WHILE !(QRYRES->(EOF()))

	aItem := Array(Len(aHeader))
	For nX := 1 to Len(aHeader)
		IF aHeader[nX][2] == "C"
			aItem[nX] := CHR(160)+QRYRES->&(aHeader[nX][1])
		ELSE
			aItem[nX] := StoD(QRYRES->&(aHeader[nX][1]))
		ENDIF
	Next nX

	AADD(aCols,aItem)
	aItem := {}

	QRYRES->(DBSkip())
End

QRYRES->(dbCloseArea) 

Return()
*/
