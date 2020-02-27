#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH" 
#INCLUDE "TBICONN.CH"
                               
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMIDRB28XB7()  บAutor  ณAntonio Damaceno    บData  ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ TEM Estoque SB2/SB8 E NAO TEM NA SB7                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
    
User Function MIDRB28XB7()
	Local lRet := .t.
	Local dDataI:=dDataBase //Ctod("09/08/2016")
	Local oData
	Local oCodLocalI
	Local  cCodLocalI := Space(02)
	Local oCodLocalF
	Local  cCodLocalF := Space(02)
	Local oGrupoI
	Local  cGrupoI := Space(04)
	Local oGrupoF
	Local  cGrupoF := Space(04)
//	Local cDirNI    := SuperGetMV('MV_X_DIRNI',.F., "\\172.17.0.183\temp\Jairson\")  //PARAMETRO CRIADO PARA INFORMAR O DIRETORIO DE GRAVAวรO DO ARQUIVO
//	                                                                                 //.XLS GERADO
	Private oDlg
	Private nOpc
	
	//Monta interface com o usuแrio
	DEFINE MSDIALOG oDlg TITLE "Aguarde" FROM C(164),C(182) TO C(325),C(409) PIXEL
	
	// Cria as Groups do Sistema
//	@ C(003),C(003) TO C(102),C(260) LABEL "Informe a Data: " PIXEL OF oDlg
	
	// Cria Componentes Padroes do Sistema
//	@ C(013),C(008) Say "Data:" Size C(038),C(008) COLOR CLR_BLACK PIXEL OF oDlg
//	@ C(013),C(030) MsGet oData Var dDataI Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg

	@ C(003),C(003) TO C(102),C(260) LABEL "TEM Estoque SB2/SB8 E NAO TEM NA SB7" PIXEL OF oDlg

	@ C(013),C(028) Say "Do Armaz้m:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(013),C(070) MsGet oCodLocalI Var cCodLocalI Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg F3 'NNR'

	@ C(023),C(028) Say "At้ Armaz้m:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(023),C(070) MsGet oCodLocalF Var cCodLocalF Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg F3 'NNR'

	@ C(033),C(028) Say "Do Grupo:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(033),C(070) MsGet oGrupoI Var cGrupoI Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg F3 'SBM'

	@ C(043),C(028) Say "At้ Grupo:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(043),C(070) MsGet oGrupoF Var cGrupoF Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg F3 'SBM'
		
	// Cria Componentes Padroes do Sistema
	
	DEFINE SBUTTON FROM C(068),C(046) TYPE 1 ENABLE OF oDlg ACTION {||nOpc := 1,oDlg:End()}
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpc == 1
		Processa( {||lRet := u_cRELB28XB7(cCodLocalI,cCodLocalF,cGrupoF,cGrupoF)}, "Aguarde..." )
	EndIf
	
Return( lRet )


User Function cRELB28XB7(cCodLocalI,cCodLocalF,cXGrupoI,cXGrupoF)           

Local cQryRes   := "" //Query pata resultados ja obtidos
Local aDados    := {}           
Local cArqGer
Local lImp      := .t.
Local cSql      := ""
Local cAliasSB28 := GetNextAlias()
Local cAliasSB7 := ''
Local cCodEtq   := ''
Local cCodPro   := ''
Local cSequen   := ''
Local cLote     := ''
Local cLocal    := ''
Local cGrupo    := ''
Local cUM       := ''
Local cSaldo1   := ""
Local cSaldo2   := ""
Local cCusto    := ""
Local nCustoT   := 0
Local dDataI    := SuperGetMV("MV_DTIINI",.F.,"")
Local dDataF    := SuperGetMV("MV_DTIFIM",.F.,"")

//-----------------------------------------------
// Seleciona os registros
//-----------------------------------------------
cSql += "SELECT SB2.B2_COD PRODUTO "
cSql += "     , SB2.B2_LOCAL ARMAZEM "
cSql += "	  , COALESCE( SB8.B8_LOTECTL, ' ' ) LOTE "
cSql += "	  , SB1.B1_DESC DESCRICAO "
cSql += "	  , SB1.B1_TIPO TIPOX "
cSql += "	  , SB1.B1_UM UMX "
cSql += "	  , SB1.B1_GRUPO GRUPOX "
cSql += "	  , 1 ETIQ "
cSql += "	  , SB2.B2_QATU SALDOB2"
cSql += "	  , SB8.B8_SALDO SALDOB8"
cSql += "	  , SB2.B2_CM1   CUSTO"

cSql += "  FROM "+RetSqlName("SB2")+" SB2 "

cSql += "  INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
cSql += "                           SB1.B1_COD = SB2.B2_COD AND "
//cSql += "						   SB1.B1_GRUPO = '"+Trim(cXGrupo)+"' AND "
cSql += "						   SB1.D_E_L_E_T_ = ' ' "

cSql += "  LEFT JOIN "+RetSqlName("SB8")+" SB8 ON SB8.B8_FILIAL = '"+xFilial("SB8")+"' AND " 
cSql += "                          SB8.B8_PRODUTO = SB1.B1_COD AND "
cSql += "                          SB8.B8_LOCAL = SB2.B2_LOCAL AND "
cSql += "					 	   SB8.B8_SALDO > 0 AND "
cSql += "						   SB8.D_E_L_E_T_ = ' ' AND"
cSql += "						   SB1.B1_RASTRO = 'L' "

cSql += " WHERE SB2.B2_FILIAL = '"+xFilial("SB2")+"' " 
cSql += "   AND SB2.B2_QATU > 0 "

If !Empty(cCodLocalI) .And. !Empty(cCodLocalF)
	cSql += "   AND SB2.B2_LOCAL BETWEEN '"+Trim(cCodLocalI)+"' AND '"+Trim(cCodLocalF)+"' "
EndIf
cSql += "   AND SB2.D_E_L_E_T_ = ' ' "
If !Empty(cXGrupoI) .And. !Empty(cXGrupoF)
	cSql += "	AND SB1.B1_GRUPO BETWEEN '"+Trim(cXGrupoI)+"' AND '"+Trim(cXGrupoF)+"' "
ENdIf
cSql += "ORDER BY SB2.B2_COD, SB2.B2_LOCAL, SB1.B1_GRUPO " 

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasSB28,.T.,.T.) 
dbSelectArea(cAliasSB28)

AAdd(aDaDOS, {"",SM0->M0_CODIGO + ' ' +SM0->M0_NOMECOM + "Data: "+DtoC(dDataBase),"","",'','','',"","" })
AAdd(aDaDOS, {"","TEM Estoque SB2/SB8 E NAO TEM NA SB7","","",'','','','',""})
AAdd(aDaDOS, {'Armazem',  'Produto','Descricao', 'UM' , 'Grupo', 'Lote', 'Saldo ','Custo Unit','Custo Total'})

While (cAliasSB28)->(!Eof())

	cCodPro := (cAliasSB28)->PRODUTO
	cDesc   := (cAliasSB28)->DESCRICAO
	cLocal  := (cAliasSB28)->ARMAZEM
	cGrupo  := (cAliasSB28)->GRUPOX
	cUM     := (cAliasSB28)->UMX
	cLote   := (cAliasSB28)->LOTE
	cSaldo1 := (cAliasSB28)->SALDOB2
	cSaldo2 := (cAliasSB28)->SALDOB8
	cCusto  := (cAliasSB28)->CUSTO
 
	cAliasSB7  := GetNextAlias()
	cSql := "SELECT B7_COD, B7_LOCAL, B7_LOTECTL, B7_DATA "
	cSql += "  FROM " + RetSqlName("SB7") + " SB7 "
	cSql += "  WHERE SB7.B7_FILIAL   = '" + xFilial("SB7") + "' AND "
	cSql += "        SB7.D_E_L_E_T_  = ' '                AND " 
	cSql += "        SB7.B7_COD      = '" + cCodPro  + "' AND "
	cSql += "        SB7.B7_LOTECTL  = '" + cLote    + "' AND "
	cSql += "        SB7.B7_LOCAL    = '" + cLocal   + "' AND " 
//	cSql += "        SB7.B7_DATA    > '20161101' "
	cSql += "        SB7.B7_DATA BETWEEN '" + DTOS(dDataI) + "' AND '" + DTOS(dDataF) + "' "
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasSB7,.T.,.T.) 
	dbSelectArea(cAliasSB7)

		
	If (cAliasSB7)->(Eof())
		nCustoT:=IIf(cSaldo1>0,cCusto*cSaldo1,cCusto*cSaldo2)	
	   	AAdd(aDaDOS, {cLocal, AllTrim(cCodPro), AllTrim(cDesc), cUM, cGRUPO, AllTrim(cLote), IIf(cSaldo1>0,cSaldo1,cSaldo2),Transform(cCusto,"@E 999,999.99"),Transform(nCustoT,"@E 999,999.99")})

	EndIf					
	(cAliasSB7)->(dbCloseArea()) 
	
	(cAliasSB28)->(dbSkip())

EndDo

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
	EndIF
	
ELSE

	MsgInfo("Os dados selecionados nos parโmetros nใo retornaram nenhum resultado!")
	
EndIF  

(cAliasSB28)->(dbCloseArea()) 

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
	Local nFields   := 9 // Nบ de Colunas  formato string
	Local nRecords  := 9 // Numero de Linhas + Cabe็alho formato string
	Local cFileName := CriaTrab( , .F. )
	Local i, j

	Local cDirNI    := UZXChoseDir()

	//	cFileName := Lower(GetClientDir( ) + cFileName + ".XLS")
	//cFileName := Lower("\\172.17.0.183\temp\Jairson\"+ cFileName + ".XLS")

	cFileName := Lower(cDirNI + cFileName + ".XLS")

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


*-----------------------------------------*
Static Function UZXChoseDir()
*-----------------------------------------*
Local cTitle:= "Gera็ใo de arquivo"
Local cMask := "Formato *|*.*"
Local cFile := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions:= GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY

cFile:= cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,.F., nOptions)

Return(cFile)
