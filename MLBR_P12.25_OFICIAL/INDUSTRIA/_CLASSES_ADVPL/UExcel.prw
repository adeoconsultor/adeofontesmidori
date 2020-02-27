#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FILEIO.CH'

// Tabela de opções de exibição da janela da aplicação executada
#define SW_HIDE             0 // Escondido
#define SW_SHOWNORMAL       1 // Normal
#define SW_NORMAL           1 // Normal
#define SW_SHOWMINIMIZED    2 // Minimizada
#define SW_SHOWMAXIMIZED    3 // Maximizada
#define SW_MAXIMIZE         3 // Maximizada
#define SW_SHOWNOACTIVATE   4 // Na Ativação
#define SW_SHOW             5 // Mostra na posição mais recente da janela
#define SW_MINIMIZE         6 // Minimizada
#define SW_SHOWMINNOACTIVE  7 // Minimizada
#define SW_SHOWNA           8 // Esconde a barra de tarefas
#define SW_RESTORE          9 // Restaura a posição anterior
#define SW_SHOWDEFAULT      10// Posição padrão da aplicação
#define SW_FORCEMINIMIZE    11// Força minimização independente da aplicação executada
#define SW_MAX              11// Maximizada

User Function UExcel()
Return(UExcel():new())

/*/{Protheus.doc} UStyle
Classe responsavel por definir um estilo de configuracao para uma celula

@author Grupo Emporio
@since 11/02/2014
@version 1.0

/*/
class UStyle
	data oAlignment
	data oFont
	data oInterior
	data oNumber
	data oBorder

    data name
    data id

	method new(oHmFont, oHmAlign, oHmInt, oHmNumber)
	method setFont(oHmFont)
	method setAlign(oHmAlign)
	method setInterior(oHmInt)
	method setNumber(oHmNumber)
	method setBorder(cPosition, cType)
	method getAlignOpt()
	method getFontOpt()
	method getInteriorOpt()
	method getNumberOpt()
	method getBorderOptions()

	method RenderXml()
endclass

method new(name, oHmFont, oHmAlign, oHmInt, oHmNumber) class UStyle
	Default name := ""
	Default oHmAlign := THash():New()
	Default oHmFont  := THash():New()
	Default oHmInt   := THash():New()
	Default oHmNumber := THash():New()

	self:oBorder := THash():New()

	oHmAlign:addUnless("Vertical","Bottom")

	::name := name
	::setAlign(oHmAlign)
	::setFont(oHmFont)
	::setInterior(oHmInt)
	::setNumber(oHmNumber)
return(self)

method RenderXml() class UStyle
	Local cXml := ""

	cXml += '  <Style ss:ID="'+self:id+'" '+IIF(Empty(self:name),'','ss:Name="Normal"')+' > '
	cXml += '   <Alignment '+self:getAlignOpt()+' /> '
	cXml += self:getBorderOptions()//'   <Borders/> '
	cXml += '   <Font '+self:getFontOpt()+' /> '
	cXml += '   <Interior '+self:getInteriorOpt()+'/> '
	cXml += '   <NumberFormat '+self:getNumberOpt()+'/> '
	cXml += '   <Protection/> '
	cXml += '  </Style> '

return(cXml)

method getBorderOptions() class UStyle
	Local aKeys := self:oBorder:getKeys()	
	Local nI := 1                                               
	Local cRet := ""

	For nI := 1 To Len(aKeys)
		cRet += '<Border ss:Position="' + aKeys[nI] + '" ss:LineStyle="' + self:oBorder:getObj(aKeys[nI]) + '"/>'
	Next
return(IIF(!Empty(cRet), "<Borders>" + cRet + "</Borders>", "<Borders/>"))

method setBorder(cPosition, cType) class UStyle
	self:oBorder:put(cPosition, cType)
return(self)

method getInteriorOpt() class UStyle
	Local aKeys := ::oInterior:getKeys()
	Local nI := 1
	Local cRet := ""

	For nI := 1 To Len(aKeys)
		cRet += 'ss:'+aKeys[nI]+' = "'+::oInterior:getObj(aKeys[nI])+'" '
	Next
return(cRet)

method getNumberOpt() class UStyle
	Local aKeys := ::oNumber:getKeys()
	Local nI := 1
	Local cRet := ""

	For nI := 1 To Len(aKeys)
		cRet += 'ss:'+aKeys[nI]+' = "'+::oNumber:getObj(aKeys[nI])+'" '
	Next
return(cRet)

method getAlignOpt() class UStyle
	Local aKeys := ::oAlignment:getKeys()
	Local nI := 1
	Local cRet := ""

	For nI := 1 To Len(aKeys)
		cRet += 'ss:'+aKeys[nI]+' = "'+::oAlignment:getObj(aKeys[nI])+'" '
	Next
return(cRet)

method getFontOpt() class UStyle
	Local aKeys := ::oFont:getKeys()
	Local nI := 1
	Local cRet := ' x:Family="Swiss" '

	For nI := 1 To Len(aKeys)
		cRet += 'ss:'+aKeys[nI]+' = "'+::oFont:getObj(aKeys[nI])+'" '
	Next
return(cRet)

method setFont(oHmFont) class UStyle
	::oFont = oHmFont
return(NIL)

method setAlign(oHmAlign) class UStyle
	::oAlignment = oHmAlign
return(NIL)

method setInterior(oHmInt) class UStyle
	::oInterior = oHmInt
return(NIL)

method setNumber(oHmNumber) class UStyle
	::oNumber = oHmNumber
return(NIL)


/*/{Protheus.doc} UExcel
Cria um objeto do tipo Excel

@author Grupo Emporio
@since 11/02/2014
@version 1.0

/*/
class UExcel
	data ID as String
	data aWorkSheets
	data nAt
	data activeWorkSheet
	data cPath
	data aStyles
	data cArq
	data cInd
	data cNome As String
	data aXmlStr As Array
	data cPergunte As String
	data cTableName As String HIDDEN
	data cMaxItem As String
	data cTmpDir as String
	data lUseTmpFile
	
	data cFileName
	data nFileHandle

	data cOrientation As String HIDDEN
	
	data cScale As String HIDDEN
	data cHRes As String HIDDEN
	data cVRes As String HIDDEN
	
	method new(aWorkSheets,lUseTmp) constructor

	method activeRow()
	method setActiveRow(nRow)

	method activeCol()
	method setActiveCol(nCol)

	method activeCell()
	method offset(nRows, nCols, lAbsolute)

	method save(cPath)
	method save2(cPath)
	method persist(cConteudo)
	method show()
	method getDefaultStyle()
	method NewStyle(oHmFont, oHmAlign, oHmInt, oHmNumber, cName)

	method cleanTmpFiles()

	method FromAlias(cAlias, aCampos, nRow)
	method FromArray(aCols, aCabec, nRow)

	method setActiveWorkSheet(nSheet)
	method getWorkSheet(nSheet)
	method GetActiveRowId()
	method GetActiveColId()
	method GetActiveWorkSheet()

	method SetNome(cNome)

	//Compatibilidade
	method addRow(nCells)
	method NextRow(nCols)

	method addToXmlStr(cString)
	method renderXml()
	method renderXml2()
	method xmlCabec()
	method xmlDocProp()

	method SetPergunte(cPerg)
	method AddWorkSheet(cTitle)
	method RenderSx1()

	//Create Table
	method CreateTable()
	method ClearOldRegs()
	method GetTableName()
	method ExistTable()

	method GetOrientation()
	method SetLandscape()
	method SetPortrait()	
	
	//Printer Info	
	method GetScale()
	method GetHRes()
	method GetVRes()

	method SetScale(cScale)
	method SetHRes(cHRes)
	method SetVRes(cVRes)

endclass

method GetScale() Class UExcel
return(self:cScale)

method GetHRes() Class UExcel
return(self:cHRes)

method GetVRes() Class UExcel
return(self:cVRes)

method SetScale(cScale)   Class UExcel
	self:cScale := cScale
return(self)

method SetHRes(cHRes)     Class UExcel
	self:cHRes := cHRes
return(self)

method SetVRes(cVRes)     Class UExcel
	self:cVRes := cVRes
return(self)

method GetOrientation() class UExcel
return(self:cOrientation)

method SetLandscape() class UExcel
	self:cOrientation := "Landscape"
return(self)

method SetPortrait() class UExcel
	self:cOrientation := "Portrait"
return(self)

method new(aWorkSheets,lUseTmp)	class UExcel
	Local nI := 1
	Local oStyle := nil
	Local cId := GetExcelId()

	Default aWorkSheets := {"Plan1","Plan2"}
	Default lUseTmp := .f.

	//Alert("cExcel ID: " + cId )
	//Recupera ID
	::ID := cId
	::cNome := PADL(::id, 30, "0") + ".xls"
	::aWorkSheets := {}
	::aStyles := {}
	::aXmlStr := {""}
	::cMaxItem := "00" //IIF(Val(StrTran(Time(), ":", "")) <= 180000, "05", "10")
	self:cScale := "100"
	self:cHRes := "0"
	self:cVRes := "0"

	If lUseTmp
		::cFileName := StrTran(AllTrim(FWUUID(StrZero(Randomize(1000,33766),5))),"-","")
		::cTmpDir := "uexcel_tmp2/"
		::lUseTmpFile := .t.
		MakeDir(::cTmpDir)
	Else
		::cFileName := ""
		::cTmpDir := ""
		::lUseTmpFile := .f.
	EndIf

	::cTableName := "UEXCEL"
	    
    ::CreateTable()
    /*
	If ::CreateTable()
		::ClearOldRegs()
	EndIf
	*/
	
	::SetPortrait()

	oStyle := UStyle():New("Normal")
	oStyle:id := "Default"

	aAdd(::aStyles, oStyle)

	For nI := 1 To Len(aWorkSheets)
		aAdd(::aWorkSheets, UWorkSheet():new(aWorkSheets[nI], self, ::lUseTmpFile))
	Next

	If Len(::aWorkSheets) >= 1
		::nAt := 1
		::activeWorkSheet := ::aWorkSheets[::nAt]
	EndIf

return(self)

method ExistTable() class UExcel
	Local cTipoDB := AllTrim(TcGetDb())
    Local cSql := ""
    Local lRet := .F.       
    Local cDropSql := " DROP TABLE UEXCEL "

	If     cTipoDB == "MSSQL"
		cSql := "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '" + self:GetTableName() + "' "
	ElseIf cTipoDB == "ORACLE"
		cSql := "SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME='" + self:GetTableName() + "' "
        
		//Testa não temporaria
		TcQuery cSql + " AND TEMPORARY = 'N' " New Alias 'SQLTABLE'
		
		If SQLTABLE->(!Eof())
			//Drop no Oracle
			If TcSqlExec(cDropSql) <> 0
				UserException("Error on UExcel drop table: " + TCSQLError())
			EndIf		
		EndIf
		SQLTABLE->(DbCloseArea())				

	Else
		UserException("Database not supported yeat!")
	EndIf

	TcQuery cSql New Alias 'SQLTABLE'

	lRet := SQLTABLE->(!Eof())


	SQLTABLE->(DbCloseArea())
Return(lRet)

method CreateTable() class UExcel
	Local cTipoDB := AllTrim(TcGetDb())
	Local aCampos := {}, nI := 0
 	Local oCampos := THash():New()
 	Local cAux := "", cSql := ""

	If cTipoDB <> "MSSQL" .And. cTipoDB <> "ORACLE"
		UserException("Database not supported yeat!")
	EndIf

	If self:ExistTable()
		Return(.T.)
	EndIf

	aAdd(aCampos, {"ID"        , "C", 24 , 0})
	aAdd(aCampos, {"WORKSHEET" , "N", 3  , 0})
	aAdd(aCampos, {"ROWEX"     , "N", 10 , 0})
	aAdd(aCampos, {"COLEX"     , "N", 10 , 0})
	aAdd(aCampos, {"CONTENT"   , "C", 999, 0})
	aAdd(aCampos, {"STYLE"     , "C", 3  , 0})
	aAdd(aCampos, {"TIPO"      , "C", 1  , 0})
	aAdd(aCampos, {"COLSPAN"   , "C", 3  , 0})
	aAdd(aCampos, {"ROWSPAN"   , "C", 3  , 0})
	aAdd(aCampos, {"FORMULA"   , "C", 255, 0})
	aAdd(aCampos, {"DATA"      , "C", 8  , 0})
	aAdd(aCampos, {"HORA"      , "C", 8  , 0}) //99:99:99

	For nI := 1 To Len(aCampos)
		If     cTipoDB == "MSSQL"
			If aCampos[nI, 2] == "C"
				cAux := "VARCHAR"
			Else
				cAux := "NUMERIC"
			EndIf
		ElseIf cTipoDB == "ORACLE"
			If aCampos[nI, 2] == "C"
				cAux := "VARCHAR2"
			Else
				cAux := "NUMBER"
			EndIf
		EndIf
		cAux := aCampos[nI, 1] + " " + cAux + "(" + AllTrim(Str(aCampos[nI, 3])) + ")"

		oCampos:Put(aCampos[nI, 1], cAux)
	Next

	If cTipoDB == "ORACLE"	
		cSql += " CREATE GLOBAL TEMPORARY TABLE "+self:GetTableName()+" (" + oCampos:Join(", ") + ", CONSTRAINT pk_UExcel PRIMARY KEY (ID, WORKSHEET, ROWEX, COLEX) )  ON COMMIT PRESERVE ROWS "
	Else
		cSql += " CREATE TABLE "+self:GetTableName()+" (" + oCampos:Join(", ") + ", CONSTRAINT pk_UExcel PRIMARY KEY (ID, WORKSHEET, ROWEX, COLEX) ) "
	EndIf
	//cSql += " CREATE TABLE "+self:GetTableName()+" (" + oCampos:Join(", ") + ") "

	If TcSqlExec(cSql) <> 0
		UserException("Error on UExcel table create: " + TCSQLError())
	EndIf
return(.T.)

method ClearOldRegs() class UExcel
	Local cSql := ""
	Local dDtClean := GetNewPar("EM_UEXCEL",dDataBase)
	Local aFiles
	Local nCont

	If dDtClean < dDataBase

		cSql += "DELETE FROM " + self:GetTableName() + " WHERE (DATA < '" + DtoS(Date()) + "') "

		If TcSqlExec(cSql) <> 0
			UserException("Error on UExcel delete old regs: " + TCSQLError())
		EndIf

		If !Empty(Self:cTmpDir)
			aFiles := Directory(Self:cTmpDir + "*.tmp")
			For nCont := 1 to Len(aFiles)
				If aFiles[nCont,3] <= dDataBase-2
					FErase(Self:cTmpDir + Lower(AllTrim(aFiles[nCont,1])))
				EndIf
			Next nCont
		EndIf

		PUTMV("EM_UEXCEL",dDataBase)

	EndIf

return(self)

method GetTableName() class UExcel
return(self:cTableName)

method AddWorkSheet(cTitle, lSetActive) class UExcel

	Default cTitle := "Plan" + AllTrim(Str(Len(self:aWorkSheets) + 1))
	Default lSetActive := .F.

	aAdd(self:aWorkSheets, UWorkSheet():new(cTitle, self,self:lUseTmpFile))

	If lSetActive
		self:setActiveWorkSheet(Len(self:aWorkSheets))
	EndIf

return(self)

method SetPergunte(cPerg) class UExcel
	self:cPergunte := cPerg
return(self)

method addToXmlStr(cString) class UExcel
	Local nTamXml := 0
	Local nMaxStr := 64000
	Local nSubStr := 0

	If self:aXmlStr == Nil
		self:aXmlStr := {""}
	EndIF

	nTamXml := Len(self:aXmlStr[Len(self:aXmlStr)])


	IF nTamXml + Len(cString) > nMaxStr
		nSubStr := nMaxStr - nTamXml

		self:aXmlStr[Len(self:aXmlStr)] := self:aXmlStr[Len(self:aXmlStr)] + SubStr(cString, 1, nSubStr)
		cString := SubStr(cString, nSubStr + 1)

		aAdd(self:aXmlStr, "")
	EndIf

	self:aXmlStr[Len(self:aXmlStr)] := self:aXmlStr[Len(self:aXmlStr)] + cString

return(.T.)

method RenderSx1() class UExcel
	Local aArea := GetArea()
	Local aAreaSx1 := SX1->(GetArea())
	Local nPerg := 1, cMvPar := ""
	
	Local oERowSX1

	DbSelectArea("SX1")
	SX1->(DbSetOrder(1))

	If SX1->(DbSeek(self:cPergunte))
	
		If !self:lUseTmpFile
			self:addWorkSheet("Parametros(" + self:cPergunte + ")", .T.)
	
			self:offset(0, 1):SetValue("Pergunta")
			self:offset(0, 1):SetValue("Descricao")
			self:offset(0, 1):SetValue("Conteudo")
	
			While SX1->(!Eof()) .And. AllTrim(SX1->X1_GRUPO) == AllTrim(self:cPergunte)
				cMvPar := &("MV_PAR" + StrZero(nPerg, 2))
	
				self:NextRow()
				self:offset(0, 1):SetValue(SX1->X1_ORDEM)
				self:offset(0, 1):SetValue(SX1->X1_PERGUNT)
				self:offset(0, 1):SetValue(cMvPar)
	
				SX1->(DbSkip())
				nPerg++
			EndDo
		Else
		
			self:addWorkSheet("Parametros(" + self:cPergunte + ")")
			oERowSX1 := URow():New(self:getWorkSheet(Len(self:aWorkSheets)), 3 , , "C"  )
	
			oERowSX1:Cells(1):SetValue2("Pergunta")
			oERowSX1:Cells(2):SetValue2("Descricao")
			oERowSX1:Cells(3):SetValue2("Conteudo")
			oERowSX1:RenderRows()
	
			While SX1->(!Eof()) .And. AllTrim(SX1->X1_GRUPO) == AllTrim(self:cPergunte)
				cMvPar := &("MV_PAR" + StrZero(nPerg, 2))
	
				oERowSX1:Cells(1):SetValue2(SX1->X1_ORDEM)
				oERowSX1:Cells(2):SetValue2(SX1->X1_PERGUNT)

				oERowSX1:Cells(3):SetType(SX1->X1_TIPO)
				oERowSX1:Cells(3):SetValue2(cMvPar)
				oERowSX1:RenderRows()
	
				SX1->(DbSkip())
				nPerg++
			EndDo
		EndIf
	EndIf

	RestArea(aAreaSx1)
	RestArea(aArea)
return(self)

method renderXml() class UExcel
	Local nI := 1

	If !Empty(self:cPergunte)
		self:RenderSx1()
	EndIf

	self:addToXmlStr(self:xmlCabec())
	self:addToXmlStr(self:xmlDocProp())

	self:addToXmlStr(' <Styles> ')
	For nI := 1 To Len(self:aStyles)
		self:addToXmlStr(self:aStyles[nI]:RenderXml())
	Next
	self:addToXmlStr(' </Styles> ')

	For nI := 1 To Len(self:aWorkSheets)
		self:aWorkSheets[nI]:RenderXml()
	Next

	self:addToXmlStr("</Workbook>")
return(.T.)

method renderXml2() class UExcel
	Local nI := 1

	If !Empty(self:cPergunte)
		self:RenderSx1()
	EndIf

	self:Persist(self:xmlCabec())
	self:Persist(self:xmlDocProp())

	self:Persist(' <Styles> ')
	For nI := 1 To Len(self:aStyles)
		self:Persist(self:aStyles[nI]:RenderXml())
	Next
	self:Persist(' </Styles> ')

	For nI := 1 To Len(self:aWorkSheets)
		self:aWorkSheets[nI]:PersistExcel()
	Next
	self:Persist("</Workbook>")
return(.T.)

method xmlCabec() class UExcel
	Local cXml := '<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?> <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">'
return(cXml)

method xmlDocProp() class UExcel
	Local cXml := ""
	cXml +=' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office"> '
	cXml += '  <Author>'+cUserName+'</Author> '
	cXml += '  <LastAuthor>'+cUserName+'</LastAuthor> '
	cXml += '  <Created>'+DtoS(dDataBase)+'T'+Time()+'Z</Created> '
	cXml += '  <Company>'+SM0->M0_NOME+'</Company> '
	cXml += '  <Version>11.9999</Version> '
	cXml += ' </DocumentProperties> '
	cXml += ' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel"> <WindowHeight>10125</WindowHeight> <WindowWidth>17115</WindowWidth> <WindowTopX>120</WindowTopX> <WindowTopY>120</WindowTopY> <ProtectStructure>False</ProtectStructure> <ProtectWindows>False</ProtectWindows> </ExcelWorkbook> '
Return(cXml)

method SetNome(cNome) class UExcel
	self:cNome := cNome
return(self)

method addRow(nCells) class UExcel
	//Compatibilidade
	self:activeWorkSheet:offset(1,0)
return(self)

method NextRow(nCols) class UExcel
	//Compatibilidade
	self:offset(1,0)
return(self)

method activeCell() class UExcel
return(self:activeWorkSheet:getAtiveCell())

method setActiveWorkSheet(nSheet) class UExcel
	self:nAt := nSheet
	self:activeWorkSheet := self:aWorkSheets[::nAt]
return(self:activeWorkSheet)

method getWorkSheet(nSheet) class UExcel
return(self:aWorkSheets[nSheet])

method setActiveRow(nRow) class UExcel
Return(self:activeWorksheet:setActiveRow(nRow))

method FromAlias(cAlias, nIndice, aCampos, aCabec, nRow) class UExcel
	Local nCols := 0
	Local nI := 0
	Local oWorkSheet := nil
	Local oAlias := Nil

	Default aCampos := {}
	Default aCabec  := {}

	oWorkSheet := ::activeWorkSheet

	aCampos := IIF(Empty(aCampos), RetCposSx3(cAlias, @aCabec), aCampos)

	nCols := Len(aCampos) + 1

	While oWorkSheet:nRows < nRow
		oWorkSheet:addRow(nCols)
	EndDo

	::SetActiveRow(nRow)

	If !Empty(aCabec)
		For nI := 1 To Len(aCabec)
			oWorkSheet:activeRow:activeCell:setValue(aCabec[nI])
			::offset(0, 1)
		Next

		oWorkSheet:NextRow(nCols)
	EndIf

	DbSelectArea(cAlias)
	DbSetOrder(nIndice)

	While &(cAlias)->(!Eof())

		For nI := 1 To Len(aCampos)
			oWorkSheet:activeRow:activeCell:setValue( &(aCampos[nI]) )
			::offset(0, 1)
	    Next

		oWorkSheet:NextRow(nCols)
		&(cAlias)->(DbSkip())
	EndDo

return()

method FromArray(aCols, aCabec, nRow) class UExcel

//	Local oWorkSheet := Nil
	Local nI, nJ     := 0

	Default aCabec  := {}
	Default aCols   := {}
	Default nRow    := 0 //Compatibilidade

	If !Empty(aCabec)
		self:NextRow()
		For nI := 1 To Len(aCabec)
			self:offset(0, 1):setValue(aCabec[nI])
		Next
	EndIf

	If !Empty(aCols)
	For nI := 1 To Len(aCols)
		self:NextRow()
		For nJ := 1 To Len(aCols[nI])
			 self:offset(0, 1):setValue(aCols[nI, nJ])
		Next
	Next
	EndIf

Return()

method NewStyle(oHmFont, oHmAlign, oHmInt, oHmNumber, cName) class UExcel
	Local nI := 0
	Local cId := "s20"
	Local oStyle := Nil

	If Len(::aStyles) > 1
		For nI := 1 to Len(::aStyles)
			cId := ::aStyles[nI]:id
		Next

		cId := "s"+Soma1(SubStr(cId, 2))
	EndIf

	oStyle := UStyle():New("", oHmFont, oHmAlign, oHmInt, oHmNumber)
	oStyle:id := cId

	aAdd(::aStyles, oStyle)
return(oStyle)

method getDefaultStyle() class UExcel
return(::aStyles[1])

method show() class UExcel
	Local cAppDir  := Lower(GetRmtDir())
	Local cCommand := cAppDir + "uexcel.exe "
	Local lUseXlsX := .F.
		
	//oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open(::cPath)
	//oExcelApp:SetVisible(.T.)
	If !Empty(self:cPath) .And. File(self:cPath)
		
		If lUseXlsX := At(".xlsx", Lower(self:cPath)) > 0 .And. File(cCommand)		
			WaitRun('cmd.exe /C "' + cCommand + '" ' + self:cPath +' ', 0 )	
		EndIf
		
		//ShellExecute ( < cAcao>, < cArquivo>, < cParam>, < cDirTrabalho>, < nOpc> )
		ShellExecute("Open",self:cPath,"","",SW_SHOWMAXIMIZED)
		//shellExecute("Open", "C:\Windows\System32\cmd.exe", " /k dir", "C:\", 1 )
	Else
		Alert('Arquivo não encontrado!')
	EndIf
 //DEFINE DIALOG oDlgExcel TITLE cPath FROM 180,180 TO 550,700 PIXEL
		//	oTOleContainer := TOleContainer():New(094,001,260,092,oDlgExcel,.T., cPath )
  //ACTIVATE DIALOG oDlgExcel CENTERED
return()

method save(cPath) class UExcel
	Local lRet := .T.
	Local nFile := 0
	Local nI := 0//, oWorkSheet := Nil
	Local cTempDir := "uexcel_tmp/"
	Local cFileName := "tmp_" + self:ID
	Local lOk := .F.
	Local nArq := 0
//	Local nPos := 0
	Local cDrive := "", cDiretorio := "", cNome := "", cExtensao := ""
//    Local aXml := {}
	Default cPath := GetPath(self:cNome)

	MakeDir(cTempDir)
	If Empty(cPath)
		fErase(cTempDir + cFileName)
		Return(.F.)
	EndIf

	SplitPath(cPath, @cDrive, @cDiretorio, @cNome, @cExtensao)

	::cPath := cPath
	//nFile := fCreate(cPath, 0)
	nFile := fCreate(cTempDir + cFileName, 0)

	self:RenderXml()
	FreeUsedCode()
	For nI := 1 To Len(self:aXmlStr)
		GrvXml(nFile, self:aXmlStr[nI])
	Next

	fClose(nFile)

	While !lOk
		If File(::cPath)
			nArq++
			::cPath := cDrive + cDiretorio + cNome + "_(" + AllTrim(Str(nArq)) + ")" + cExtensao
		Else
			SplitPath(::cPath, @cDrive, @cDiretorio, @cNome, @cExtensao)

			self:cNome := cNome + cExtensao

			CpyS2T(cTempDir + cFileName, cDrive + cDiretorio, .F.)
			fRename(cDrive + cDiretorio + cFileName,cDrive + cDiretorio + cNome + cExtensao)
			fErase(cTempDir + cFileName)
			lOk := .T.
		EndIf
	EndDo

	fErase(cTempDir + cFileName)
return(lRet)

method Persist(cConteudo) class UExcel
	If ::nFileHandle > 0
		FWrite(::nFileHandle,cConteudo)
	EndIf
return

method save2(cPath) class UExcel
	Local lRet := .T.
	Local nFile := 0
	Local lOk := .F.
	Local nArq := 0
	Local cDrive := ""
	Local cDiretorio := ""
	Local cNome := ""
	Local cExtensao := ""

	Default cPath := GetPath(self:cNome)
	
	::nFileHandle := 0
	
	If Empty(cPath)
		::cleanTmpFiles()
		Return(.F.)
	EndIf

	SplitPath(cPath, @cDrive, @cDiretorio, @cNome, @cExtensao)

	::cPath := cPath
	::nFileHandle := fCreate(::cTmpDir + ::cFileName + ".tmp", 0)
	If ::nFileHandle <= 0
		Alert(FError())
		return .f.
	Endif

	self:RenderXml2()
	fClose(::nFileHandle)

	While !lOk
		If File(::cPath)
			nArq++
			::cPath := cDrive + cDiretorio + cNome + "_(" + AllTrim(Str(nArq)) + ")" + cExtensao
		Else
			SplitPath(::cPath, @cDrive, @cDiretorio, @cNome, @cExtensao)

			self:cNome := cNome + cExtensao

//			::cTmpDir + ::cFileName

			CpyS2T(::cTmpDir + ::cFileName + ".tmp", cDrive + cDiretorio, .F.)
			fRename(cDrive + cDiretorio + ::cFileName + ".tmp" ,cDrive + cDiretorio + cNome + cExtensao)
//			fErase(cTempDir + cFileName)
			lOk := .T.
		EndIf
	EndDo

	::cleanTmpFiles()

return(lRet)

method cleanTmpFiles() class UExcel
	Local nI
	If ::nFileHandle > 0
		FErase(::cTmpDir + ::cFileName + ".tmp")
	EndIf
	For nI := 1 to Len(self:aWorkSheets)
		self:aWorkSheets[nI]:cleanTmpFiles()
	Next nI
return

method offset(nRows, nCols, lAbsolute) class UExcel
	Default lAbsolute := .F.
return(self:activeWorkSheet:offset(nRows, nCols, lAbsolute))

method activeRow()	class UExcel
Return(::activeWorkSheet:nActiveRow)

method GetActiveRowId()	class UExcel
Return(::activeWorkSheet:nActiveRow)

method GetActiveColId()	class UExcel
Return(::activeWorkSheet:nActiveCol)

method GetActiveWorkSheet() class UExcel
Return(::activeWorkSheet)


/*/{Protheus.doc} UWorkSheet
Definicao de classe de uma planilha do Excel

@author Grupo Emporio
@since 11/02/2014
@version 1.0

/*/
class UWorkSheet
	data ID as Integer
	data workbook
	data name
	data nActiveRow
    data nActiveCol

 	data aRegs As Array

	data oRow

	data cFileName
	data nFileHandle

	method new(name, oParent,lUseTmp) constructor
	method getAtiveCell()
	method offset(nRows, nCols, lAbsolute)

	method getParent()

	method setActiveRow(nRow)
	method setActiveCol(nCol)

	method getActiveRow()

	method Persist(cConteudo)
	method PersistExcel()
	method close()
	method cleanTmpFiles()
	//Compatibilidade
	method addRow(nCells)
	method NextRow(nCols)

	method RenderXml()
	method RenderRows()
endclass

method new(name, oParent,lUseTmp) class UWorkSheet

	Default lUseTmp := .f.

	self:workbook := oParent
	self:name := SubStr(name, 1, 30)
	self:nActiveRow := 1
	self:nActiveCol := 1
	self:ID := Len(oParent:aWorkSheets) + 1
	self:aRegs := {}

	If lUseTmp
		::cFileName := oParent:cFileName + StrZero(::ID,2) + ".tmp"
		::nFileHandle := FCreate(oParent:cTmpDir + ::cFileName)

		If ::nFileHandle > 0
			::Persist(' <Worksheet ss:Name="'+self:name+'"> ')
			::Persist('  <Table x:FullColumns="1"  x:FullRows="1"> ')
		EndIf
	Else
		::nFileHandle := 0
	EndIf

return(self)

method RenderXml() class UWorkSheet
	Local cXml := ""
	Local oExcel := self:getParent()
	Local lSemaforo := .F.
	Local cExcelId := oExcel:Id
	Local cWorkSheet := AllTrim(Str(self:ID))
	Local cItemLock := "00"

	oExcel:addToXmlStr(' <Worksheet ss:Name="'+self:name+'"> ')
	oExcel:addToXmlStr('  <Table x:FullColumns="1"  x:FullRows="1"> ')
	
	/*
	While !lSemaforo
		lSemaforo := .T.
		While cItemLock < oExcel:CMAXITEM
			cItemLock := Soma1(cItemLock)
			lSemaforo := lSemaforo .And. LockFile("UEXCEL" + cExcelId + cWorkSheet + cItemLock)
		EndDo
		cItemLock := "00"
		Sleep(3)
	EndDo
	cItemLock := Soma1(cItemLock)
	LockFile("UEXCEL" + cExcelId + cWorkSheet + cItemLock)
	*/
	If Len(self:aRegs) > 0
		U_InsUExcel(SM0->M0_CODIGO, SM0->M0_CODFIL, cExcelId, cWorkSheet, aClone(self:aRegs))
	EndIf
	self:RenderRows()

	cXml += '  </Table> '
	cXml += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel"> '
	cXml += '    <PageSetup> '
	cXml += '      <Layout x:Orientation="' + oExcel:GetOrientation() + '"/>'	    	
	cXml += '       <Header x:Margin="0"/> '
	cXml += '       <Footer x:Margin="0"/> '   
    cXml += '		<PageMargins x:Bottom="0.39370078740157483" x:Left="0.39370078740157483" '
    cXml += '		  x:Right="0.39370078740157483" x:Top="0.39370078740157483"/> '
	cXml += '    </PageSetup>' 
	cXml += '    <Print> '
	cXml += '      <ValidPrinterInfo/> '
	cXml += '      <Scale>' + oExcel:GetScale() + '</Scale> '
	cXml += '      <HorizontalResolution>' + oExcel:GetHRes() + '</HorizontalResolution> '
	cXml += '      <VerticalResolution>' + oExcel:GetVRes() + '</VerticalResolution> '
	cXml += '    </Print> '
	cXml += '    <Selected/>'  	
	cXml += '    <Panes>'
	cXml += '      <Pane>'
	cXml += '        <Number>3</Number>'
	cXml += '        <ActiveRow>3</ActiveRow>'
	cXml += '      </Pane>'
	cXml += '    </Panes>'
	cXml += '    <ProtectObjects>False</ProtectObjects>'
	cXml += '    <ProtectScenarios>False</ProtectScenarios>'
	cXml += '  </WorksheetOptions>'
	cXml += ' </Worksheet>'
	oExcel:addToXmlStr(cXml)
Return(.T.)

method RenderRows() class UWorkSheet
	Local oExcel := self:getParent()
	Local nWorkSheet := self:ID  //WorkSheet

	Local nMaxRows := 0

	Local cSql := "", nI := 1//, nJ := 1
	Local cAlias := oExcel:ID

	cSql := " SELECT ID, WORKSHEET, MAX(ROWEX) MAXROWS FROM " + oExcel:GetTableName() + " WHERE ID = '" + oExcel:ID + "' AND WORKSHEET = " + AllTrim(Str(nWorkSheet)) + " GROUP BY ID, WORKSHEET "
	TcQuery cSql New Alias 'TMPMAXROW'
	nMaxRows := TMPMAXROW->MAXROWS
	TMPMAXROW->(DbCloseArea())

	For nI := 1 To nMaxRows
		cSql := " SELECT "
		cSql += "       ROWEX, COLEX, CONTENT, TIPO, STYLE, COLSPAN, ROWSPAN, FORMULA "
		cSql += "      FROM UEXCEL "
		cSql += " WHERE ID = '" + oExcel:ID + "' AND WORKSHEET = " + AllTrim(Str(nWorkSheet))
		cSql += "   AND ROWEX = '" + AllTrim(Str(nI)) + "' " //AND COLEX = '" + AllTrim(Str(nJ)) + "' "
		TcQuery cSql New Alias &(cAlias)

		If (cAlias)->(!Eof())
			cXml := '<Row>'
			While (cAlias)->(!Eof())
				If !Empty((cAlias)->CONTENT)
					oCell := UCell():New((cAlias)->ROWEX, (cAlias)->COLEX, self)
					oCell:LoadValues((cAlias)->CONTENT,(cAlias)->TIPO, (cAlias)->STYLE, Val((cAlias)->COLSPAN), Val((cAlias)->ROWSPAN), (cAlias)->FORMULA)
					cXml += oCell:RenderXml()
				EndIf

				(cAlias)->(DbSkip())
			EndDo
			cXml += '</Row>'
			oExcel:addToXmlStr(cXml)
		Else
			oExcel:addToXmlStr("<Row/>") //cXml := "<Row/>"
		EndIf
	(cAlias)->(DbCloseArea())
	Next
Return(Nil)

method addRow(nCells) class UWorkSheet
	//Compatibilidade
	self:offset(1,0)
return(self)

method NextRow(nCols) class UWorkSheet
	//Compatibilidade
	self:offset(1,0)
return(self)

method setActiveRow(nRow) class UWorkSheet
	self:nActiveRow := nRow
return(self:nActiveRow)

method setActiveCol(nCol) class UWorkSheet
	self:nActiveCol := nCol
return(self:nActiveCol)

method getActiveRow() class UWorkSheet
return(self:nActiveRow)

method getParent() class UWorkSheet
return(self:workbook)

method offset(nRows, nCols, lAbsolute) class UWorkSheet

	Default lAbsolute := .F.

	If nRows <> 0
		If lAbsolute
			::setActiveRow(nRows)
		Else
			::setActiveRow(self:nActiveRow + nRows)
		EndIf
		::setActiveCol(1)
	EndIf

	If nCols <> 0
		If lAbsolute
			::setActiveCol(nCols)
		Else
			::setActiveCol(self:nActiveCol + nCols)
		EndIf
	EndIf

return(self:getAtiveCell())

method getAtiveCell() class UWorkSheet
return(UCell():New(self:nActiveRow, self:nActiveCol, self))

method Persist(cConteudo) class UWorkSheet
	If ::nFileHandle > 0
		FWrite(::nFileHandle,cConteudo)
	EndIf
return

method PersistExcel() class UWorkSheet
	Local cBuffer := ""

	self:Close()

	If ::workbook:nFileHandle <> 0
		self:nFileHandle := FOpen(self:workbook:cTmpDir + ::cFileName)
//		While FRead(self:nFileHandle,@cBuffer,1000) > 0
		While FRead(self:nFileHandle,@cBuffer,1000) > 0
			FWrite(self:workbook:nFileHandle,cBuffer)
		End
		FClose(self:nFileHandle)
	EndIf
return

method cleanTmpFiles() class UWorkSheet
	If ::nFileHandle > 0
		FClose(::nFileHandle)
	EndIf
	FErase(::workbook:cTmpDir + ::cFileName )
return

method close() class UWorkSheet
	Local cAuxTexto := ""
	cAuxTexto += '  </Table> '
	cAuxTexto += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel"> '
	cAuxTexto += '    <PageSetup> '
	cAuxTexto += '      <Header x:Margin="0.49212598499999999"/> '
	cAuxTexto += '      <Footer x:Margin="0.49212598499999999"/> '
	cAuxTexto += '		<PageMargins x:Bottom="0.984251969" x:Left="0.78740157499999996" x:Right="0.78740157499999996" x:Top="0.984251969"/> '
	cAuxTexto += '    </PageSetup>'
	cAuxTexto += '    <Selected/>'
	cAuxTexto += '    <Panes>'
	cAuxTexto += '      <Pane>'
	cAuxTexto += '        <Number>3</Number>'
	cAuxTexto += '        <ActiveRow>3</ActiveRow>'
	cAuxTexto += '      </Pane>'
	cAuxTexto += '    </Panes>'
	cAuxTexto += '    <ProtectObjects>False</ProtectObjects>'
	cAuxTexto += '    <ProtectScenarios>False</ProtectScenarios>'
	cAuxTexto += '  </WorksheetOptions>'
	cAuxTexto += ' </Worksheet>'
	::Persist(cAuxTexto)

	If ::nFileHandle > 0
		FClose(::nFileHandle)
	EndIf

return


/*/{Protheus.doc} URow
Definicao de classe para uma linha da planilha

@author Rubens
@since 12/02/2014
@version 1.0

/*/
class URow
	data oWorkSheet as object
	data oStyle as object
	data aCells
	data sstyle

	method new(oParent,nTam,oStyle,cTipo,nColDesloc) constructor
	method reset(oParent,nTam,oStyle,cTipo)
	method addCell(cTipo,oStyle)
	method setStyle(oStyle)
	method getStyle()

	method setWorkSheet(oParent)
	method getActiveRow()
	method renderXml()
	method Cells(nCol)
	method NextRow()
	method RenderRows()
endclass

method new(oParent,nTam,oStyle,cTipo,nColDesloc) class URow
	
	Local nCont
	Default nTam := 0
	Default cTipo := ""
	Default nColDesloc := -1

	If oParent <> NIL
		Self:oWorkSheet := oParent
	EndIf

	::aCells := {}

	If nColDesloc == -1
		nColDesloc := Len(::aCells)+1
	EndIf

	If nTam > 0
		For nCont := 1 to nTam
			AADD( ::aCells , UCell():New(1,nColDesloc++,::oWorkSheet) )
			If !Empty(cTipo)
				::aCells[nCont]:setType(cTipo)
			EndIf
			::aCells[nCont]:SetRow(self)
			::aCells[nCont]:lNeedSeek := .f.
		Next nCont
	EndIf

	If oStyle <> NIL
		sstyle := oStyle:Id
		::oStyle := oStyle
	EndIf

return(self)

method reset(oParent,nTam,oStyle,cTipo) class URow
	Self:aCells := {}
	If oParent <> NIL .or. nTam <> NIL .or. oStyle <> NIL .or. cTipo <> NIL
		self:New( oParent,nTam,oStyle,cTipo )
	EndIf
Return(self)

method addCell( cTipo , oStyle ) class URow
	local oCellRet

	oCellRet := UCell():New(1,Len(::aCells)+1,::oWorkSheet)
	oCellRet:setType(cTipo)
	If oStyle <> NIL
		oCellRet:setStyle2(oStyle)
	Else
		If ::oStyle <> NIL
			oCellRet:setStyle2(::oStyle)
		EndIf
	EndIf
	oCellRet:setRow(self)

	AADD(::aCells,oCellRet)

return(oCellRet)

method setStyle(oStyle) class URow
	::oStyle := oStyle
	::sstyle := oStyle:Id
return(self)

method getStyle() class URow
If self:oStyle <> NIL
	return self:oStyle
Else
	return self:oWorkSheet:WorkBook:GetDefaultStyle()
EndIf
return (self:oStyle)

method setWorkSheet(oParent) class URow
	::oWorkSheet := oParent
return(self)

method getActiveRow() class URow
return(::oWorkSheet:getActiveRow())

method Cells(nCol) class URow
return(::aCells[nCol])

method NextRow() class URow
	cXml := "<Row/>"
	::oWorkSheet:Persist(cXml)
	::oWorkSheet:setActiveRow(++Self:oWorkSheet:getActiveRow())
return(cXml)

method RenderRows() class URow

	Local cXml := ""
	Local nPos

	cXml := "<Row>"
	For nPos := 1 to Len(::aCells)
		cXml += ::aCells[nPos]:renderXml2()
	Next nPos
	cXml += "</Row>"

	::oWorkSheet:Persist(cXml)
	::oWorkSheet:setActiveRow(++Self:oWorkSheet:getActiveRow())
return(cXml)


/*/{Protheus.doc} UCell
Definicao de classe de celula do Excel

@author Grupo Emporio
@since 11/02/2014
@version 1.0

/*/
class UCell
	data content
	data oWorkSheet as object
	data oRow as object
	data nRow as Integer
	data nCol as Integer
	data Style
	data tipo as String
	data nColSpan as Integer
	data nRowSpan as Integer
	data cFormula as String HIDDEN

	data lNeedSeek as Boolean

	method new(nRow, nCol,oParent) constructor
	method GetCellFromDb()

	method setValue(content, oStyle)
	method setValue2(content,lNoAcento)
	method getValue()
	method RenderValue()
	method RenderVal2()

	method setStyle(oStyle, lSeek)
	method setStyle2(oStyle)
	method getStyle()

	method setFormula(cFormula, lSeek)
	method getFormula()

	method setColSpan(nColSpan)
	method getColSpan()

	method setRowSpan(nRowSpan)
	method getRowSpan()

	method setType(cTipo)
	method getType()

	method getRow()
	method setRow()

	method renderXml()
	method renderXml2()

	method Put(cField, cValue)
	method LoadCellFromAlias(cAlias)
	method LoadValues(cContent,cTipo, nStyle, nColSpan, nRowSpan, cFormula)
endclass

//New - Novo Objeto Cell - Cell é preenchido caso exista no DB
method new(nRow, nCol, oWorkSheet) class UCell
	::oWorkSheet := oWorkSheet
	::nRow := nRow
	::nCol := nCol
	//::GetCellFromDb()
	::lNeedSeek := .T.
Return(self)

//GetCellFromDb() - Recupera Cell do DB
method GetCellFromDb() class UCell
	Local oHmKey    := THash():New()
	Local cSql := ""
	Local oExcel := self:oWorkSheet
	Local cExcelId   := self:oWorkSheet:GetParent():ID
	Local cWorkSheet := AllTrim(Str(self:oWorkSheet:ID))
	Local cRow := StrZero(self:nRow, 10)
	Local cCol := StrZero(self:nCol, 10)
	Local nPos := 0
	Local nI

	cChave := cId + cWorkSheet + cRow + cCol

	If (nPos := aScan(oExcel:aRegs, { |aVet| aVet[1] == cChave })) > 0
		self:LoadValues(oExcel:aRegs[nPos, 4], oExcel:aRegs[nPos, 6], oExcel:aRegs[nPos, 5], Val(oExcel:aRegs[nPos, 7]), Val(oExcel:aRegs[nPos, 8]), oExcel:aRegs[nPos, 9])
		self:lNeedSeek := .F.
		return(self)
	EndIf

	oHmKey:Put('ID'         , cExcelId)
	oHmKey:Put('WORKSHEET'  , cWorkSheet)
	oHmKey:Put('ROWEX'      , cRow)
	oHmKey:Put('COLEX'      , cCol)

	cSql += " SELECT CONTENT, STYLE, TIPO, COLSPAN, ROWSPAN, FORMULA "
	cSql += " FROM " + self:oWorkSheet:GetParent():GetTableName()
	cSql += " WHERE "
	For nI := 1 To Len(aKeys := oHmKey:getEntry())
		cSql += IIF(nI > 1, " AND ", "")
		cSql += aKeys[nI, 1] + " = '" +  aKeys[nI, 2] + "' "
	Next
	cSql += " ORDER BY ID, WORKSHEET, ROWEX, COLEX "

	TcQuery cSql New Alias 'SQLTEMP'

	If SQLTEMP->(!Eof())
		self:LoadCellFromAlias("SQLTEMP")
	Else
		self:style   := ""
		self:tipo    := "C"
		self:content := ""
	EndIf

	self:lNeedSeek := .F.
	SQLTEMP->(DbCloseArea())
return(self)

method LoadCellFromAlias(cAlias) class UCell
	self:style    := (cAlias)->STYLE
	self:tipo     := (cAlias)->TIPO
	self:cFormula := (cAlias)->FORMULA
	self:nColSpan := Val((cAlias)->COLSPAN)
	self:nRowSpan := Val((cAlias)->ROWSPAN)

	If  self:tipo == "N"
		self:content := Val((cAlias)->CONTENT)
	ElseIf self:tipo == "D"
		self:content := StoD((cAlias)->CONTENT)
	ElseIf self:tipo == "L"
		self:content := ((cAlias)->CONTENT)
	Else
		self:content := AllTrim((cAlias)->CONTENT)
	EndIf
	self:lNeedSeek := .F.
return(self)

method LoadValues(cContent,cTipo, nStyle, nColSpan, nRowSpan, cFormula) Class UCell
	self:style    := nStyle
	self:tipo     := cTipo
	self:cFormula := cFormula
	self:nColSpan := nColSpan
	self:nRowSpan := nRowSpan

	If  self:tipo == "N"
		self:content := Val(cContent)
	ElseIf self:tipo == "D"
		self:content := StoD(cContent)
	ElseIf self:tipo == "L"
		self:content := (cContent)
	Else
		self:content := AllTrim(cContent)
	EndIf
	self:lNeedSeek := .F.
return(self)

method setValue2(cContent,lNoAcento) class UCell

	Default lNoAcento := .f.

	Do Case
	Case self:tipo == "N"
//		self:content := Val(cContent)
		self:content := cContent
	Case self:tipo == "D"
		self:content := cContent
	Case self:tipo == "L"
		self:content := (cContent)
	Otherwise
		If lNoAcento
			self:content := EnCodeUtf8(NoAcento(AllTrim(cContent)))
		Else
			self:content := EnCodeUtf8(AllTrim(cContent))
		EndIf
	End Case

	self:lNeedSeek := .F.

return(self)

//setValue - Define content do Cell, podendo ter o estilo
method setValue(content, oStyle) class UCell
	Local aKeys := {}, aValues := {}

	Default oStyle := Nil

	aAdd(aKeys  , "CONTENT")
	aAdd(aKeys  , "TIPO")

	If     ValType(content) == "N"
		aAdd(aValues, AllTrim(Str(content, 20, 6)))
	ElseIf ValType(content) == "D"
		aAdd(aValues, DtoS(content))
	ElseIf ValType(content) == "L"
		aAdd(aValues, IIF(&(content), ".T.",".F."))
	Else
		aAdd(aValues, content)
	EndIf

	aAdd(aValues, ValType(content))

	If oStyle <> Nil
		aAdd(aKeys  , "STYLE")
		aAdd(aValues, oStyle:Id)
	EndIf

	self:Put(aKeys, aValues)
	self:content := content
	self:tipo := ValType(content)
return(self)

//getValue - Retorna o content da CELL
method getValue() class UCell
	If self:lNeedSeek
		self:GetCellFromDb()
	EndIf
return(self:content)

method RenderValue() class UCell
	Local cContent := self:GetValue()
	Local cValType := ValType(cContent)

	Do Case
	Case cValType == "N"
		cContent := AllTrim(Str(cContent, 20, 6))
	Case cValType == "D"
		cContent := DtoS(cContent)
	Case cValType == "L"
		cContent := IIF(&(cContent), ".T.",".F.")
//	Otherwise
//		cContent := cContent
	EndCase

Return(cContent)

method RenderVal2() class UCell
	Local cContent := self:GetValue()
	Local cValType := self:tipo

	Do Case
	Case cValType == "N"
		cContent := AllTrim(Str(cContent, 20, 6))
	Case cValType == "D"
		cContent := DtoC(cContent)
	Case cValType == "L"
		cContent := IIF(&(cContent), ".T.",".F.")
	EndCase

Return(cContent)

//setStyle - Define estilo da CELL
method setStyle(oStyle, lSeek) class UCell
	self:Put("STYLE", oStyle:Id)
	self:style := oStyle:Id
return(self)

method setStyle2(oStyle) class UCell
	self:style := oStyle:Id
return(self)

//getStyle - Retorna o estilo da CELL
method getStyle() class UCell
	If self:lNeedSeek
		self:GetCellFromDb()
	EndIf
return(IIf(self:style <> Nil .And. !Empty(self:style), self:style, ""))

method setFormula(cFormula, lSeek)class UCell
	self:Put("FORMULA", cFormula)
	self:cFormula := cFormula
return(self)

method getFormula()class UCell
	If self:lNeedSeek
		self:GetCellFromDb()
	EndIf
return(self:cFormula)

method setColSpan(nColSpan) class UCell
	self:Put("COLSPAN", AllTrim(Str(nColSpan)))
	self:nColSpan := nColSpan
return(self)

method getColSpan() class UCell
	If self:lNeedSeek
		self:GetCellFromDb()
	EndIf
return(self:nColSpan)

method setRowSpan(nRowSpan) class UCell
	self:Put("ROWSPAN", AllTrim(Str(nRowSpan)))
	self:nRowSpan := nRowSpan
return(self)

method getRowSpan() class UCell
	If self:lNeedSeek
		self:GetCellFromDb()
	EndIf
return(self:nRowSpan)

//renderXML - Renderiza a Cell em xml para o save do UExcel
method renderXml() class UCell
	Local cRet := ""

	cRet += "<Cell ss:Index='"+ AllTrim(Str(self:nCol - 1))+"' "
	cRet += IIF(Empty(self:getStyle()),'',' ss:StyleID="'+AllTrim(self:getStyle())+'" ')
	cRet += IIF(Empty(self:cFormula),'',' ss:Formula="'+AllTrim(self:cFormula)+'" ')
	cRet += IIF(Empty(self:nColSpan),'',' ss:MergeAcross="'+AllTrim(Str(self:nColSpan))+'" ')
	cRet += IIF(Empty(self:nRowSpan),'',' ss:MergeDown="'+AllTrim(Str(self:nRowSpan))+'" ')
	cRet += ">"

	cRet += "<Data ss:Type='"+IIf(self:Tipo == "N", "Number","String")+"'>"

	cRet += self:RenderValue()

	cRet += "</Data> </Cell>"

return(cRet)

method renderXml2() class UCell
	Local cRet := ""
	Local cAuxStyle := ""

	cRet += "<Cell ss:Index='"+ AllTrim(Str(self:nCol))+"' "

	cAuxStyle := AllTrim(self:getStyle())
	If Empty(cAuxStyle)
		cAuxStyle := self:GetRow():GetStyle():Id
	EndIf
	cRet += IIF(Empty(cAuxStyle),'',' ss:StyleID="'+AllTrim(cAuxStyle)+'" ')
	cRet += IIF(Empty(self:cFormula),'',' ss:Formula="'+AllTrim(self:cFormula)+'" ')
	cRet += IIF(Empty(self:nColSpan),'',' ss:MergeAcross="'+AllTrim(Str(self:nColSpan))+'" ')
	cRet += IIF(Empty(self:nRowSpan),'',' ss:MergeDown="'+AllTrim(Str(self:nRowSpan))+'" ')
	cRet += ">"

	cRet += "<Data ss:Type='"+IIf(self:Tipo == "N", "Number","String")+"'>"

	If Empty(self:cFormula)
		cRet += self:RenderVal2()
	EndIf

	cRet += "</Data> </Cell>"

return(cRet)


method setType(cTipo) class UCell
	self:tipo := cTipo
return(self)

method getType() class UCell
	Local cType := "String"

	If self:lNeedSeek
		self:GetCellFromDb()
	EndIf

	If     self:tipo == "C"
		cType := "String"
	ElseIf self:tipo == "N"
		cType := "Number"
	EndIF
Return(cType)

method setRow(oRow) class UCell
	::oRow := oRow
return(self)

method getRow(oRow) class UCell
return(::oRow)

method Put(cField, cValue) class UCell
	Local nPos := 0
	Local cChave := ""
	Local nI := 0
	Local cItemLock := "01"

	Local oExcel := self:oWorkSheet
	Local cExcelId   := self:oWorkSheet:GetParent():ID
	Local cWorkSheet := AllTrim(Str(self:oWorkSheet:ID))
	Local cRow := StrZero(self:nRow, 10)
	Local cCol := StrZero(self:nCol, 10)
	Local lSemaforo := .F., nTentativas := 0

	cChave := cExcelId + cWorkSheet + cRow + cCol

	If ValType(cField) <> "A"
		cField := {cField}
		cValue := {cValue}
	EndIf

	If (nPos := aScan(oExcel:aRegs, { |aVet| aVet[1] == cChave })) == 0
		aAdd(oExcel:aRegs, {})
		aAdd(oExcel:aRegs[Len(oExcel:aRegs)], cChave)

		aAdd(oExcel:aRegs[Len(oExcel:aRegs)], cRow)
		aAdd(oExcel:aRegs[Len(oExcel:aRegs)], cCol)

		aAdd(oExcel:aRegs[Len(oExcel:aRegs)], "")	// Conteudo
		aAdd(oExcel:aRegs[Len(oExcel:aRegs)], "")	// STYLE
		aAdd(oExcel:aRegs[Len(oExcel:aRegs)], "C") 	// TIPO
		aAdd(oExcel:aRegs[Len(oExcel:aRegs)], "0")	// COLSPAN
		aAdd(oExcel:aRegs[Len(oExcel:aRegs)], "0")	// ROWSPAN
		aAdd(oExcel:aRegs[Len(oExcel:aRegs)], "")	// FORMULA

		nPos := Len(oExcel:aRegs)
	EndIf

	For nI := 1 To Len(cField)
		If      cField[nI] == "CONTENT"
			oExcel:aRegs[nPos, 4]  := cValue[nI]
		ElseIf cField[nI] == "STYLE"
			oExcel:aRegs[nPos, 5]  := cValue[nI]
		ElseIf cField[nI] == "TIPO"
			oExcel:aRegs[nPos, 6]  := cValue[nI]
		ElseIf cField[nI] == "COLSPAN"
			oExcel:aRegs[nPos, 7]  := cValue[nI]
		ElseIf cField[nI] == "ROWSPAN"
			oExcel:aRegs[nPos, 8]  := cValue[nI]
		ElseIf cField[nI] == "FORMULA"
			oExcel:aRegs[nPos, 9] := cValue[nI]
		EndIf
	Next

	If Len(oExcel:aRegs) > 10000
		u_InsUExcel(SM0->M0_CODIGO, SM0->M0_CODFIL, cExcelId, cWorkSheet, aClone(oExcel:aRegs))
		oExcel:aRegs := {}
		
		/*
		nTentativas := 0
		While !lSemaforo
			If lSemaforo := LockFile("UEXCEL" + cExcelId + cWorkSheet + cItemLock)
				//u_InsUExcel(SM0->M0_CODIGO, SM0->M0_CODFIL, cExcelId, cWorkSheet, aClone(oExcel:aRegs))
				StartJob( "U_InsUExcel", GetEnvServer(), .F., SM0->M0_CODIGO, SM0->M0_CODFIL, cExcelId, cWorkSheet, aClone(oExcel:aRegs), .T., cItemLock )
				oExcel:aRegs := {}
			Else
				If cItemLock < oExcel:WORKBOOK:CMAXITEM
					cItemLock := Soma1(cItemLock, 2)
				ElseIf nTentativas > 4
					lSemaforo := .T.
				Else
					cItemLock := "01"
					nTentativas++
					Sleep(1)
				EndIf
			EndIf
		EndDo
		*/
	EndIf

Return(self)

User Function InsUExcel(cEmpId, cFilId, cExcelId, cWorkSheet, aRegs, lInitEnv, cItemLock)
	Local nI := 1//, nJ := 1
	Local cSql := ""
	Local nTotal := 0
	Local nHandle := 0

	Default lInitEnv := .F.
	Default cItemLock := ""

	//LockFile("UEXCEL" + cExcelId + cWorkSheet + cItemLock, @nHandle, , .T.)

	//ConOut("InsUExcel")
	//ConOut("cExcelId: " + cExcelId)

	If lInitEnv
		//ConOut("Iniciando Env")
		RpcClearEnv()
		RpcSetType(3)
		RpcSetEnv( cEmpId ,cFilId,,,"FAT",GetEnvServer())
		SetModulo( "SIGAFAT", "FAT" )
		//__cinternet := ""
		__cLogSiga := "NNNNNNNNNN"
	EndIf

	//ConOut("Total Registros" + StrZero(Len(aRegs), 6))
	For nI := 1 To Len(aRegs)
		//ConOut(" - Registro " + StrZero(nI, 6) + "/" + StrZero(Len(aRegs), 6))

		cSql := " SELECT COUNT(ID) TOT "
		cSql += "   FROM UEXCEL "
		cSql += "  WHERE ID = '" +cExcelId+ "' AND WORKSHEET = '" +cWorkSheet + "' "
		cSql += "    AND ROWEX = '" + aRegs[nI, 2] + "' AND COLEX = '" + aRegs[nI, 3] + "' "

		//ConOut(" -- Select: " + cSql)
		TcQuery cSql New Alias "SQLCOUNT"
		nTotal := SQLCOUNT->TOT
		//ConOut(" --- Total: " + StrZero(nTotal, 2))
		SQLCOUNT->(DbCloseArea())

		If nTotal == 0
			cSql := " INSERT INTO UEXCEL "
			cSql += " (ID, WORKSHEET, ROWEX, COLEX, DATA, HORA "
			If !Empty(aRegs[nI, 4])
				cSql += ", CONTENT "
			EndIf
			If !Empty(aRegs[nI, 5])
				cSql += ", STYLE "
			EndIf
			If !Empty(aRegs[nI, 6])
				cSql += ", TIPO "
			EndIf
			If !Empty(aRegs[nI, 7])
				cSql += ", COLSPAN "
			EndIf
			If !Empty(aRegs[nI, 8])
				cSql += ", ROWSPAN "
			EndIf
			If !Empty(aRegs[nI, 9])
				cSql += ", FORMULA "
			EndIf
			cSql += ")"
			cSql += " VALUES "
			cSql += " ('" + cExcelId + "', '" + cWorkSheet + "','" + aRegs[nI, 2] + "','" + aRegs[nI, 3] + "','" + DtoS(Date()) + "','" + Time() + "' "

			If !Empty(aRegs[nI, 4])
				cSql += ", '" + EnCodeUtf8(NoAcento(StrTran(aRegs[nI, 4], "'", "''"))) + "' "
			EndIf

			If !Empty(aRegs[nI, 5])
				cSql += ", '" + aRegs[nI, 5] + "' "
			EndIf

			If !Empty(aRegs[nI, 6])
				cSql += ", '" + aRegs[nI, 6] + "' "
			EndIf

			If !Empty(aRegs[nI, 7])
				cSql += ", '" + aRegs[nI, 7] + "' "
			EndIf

			If !Empty(aRegs[nI, 8])
				cSql += ", '" + aRegs[nI, 8] + "' "
			EndIf

			If !Empty(aRegs[nI, 9])
				cSql += ", '" + aRegs[nI, 9] + "' "
			EndIf
			cSql += ")"

			//ConOut(" -- Insert: " + cSql)

			If TcSqlExec(cSql) <> 0
				//ConOut(" -- Insert Error : " + TcSqlError())
				UserException("UExcel: Error to set a value to cell - " + TcSqlError())
			EndIf
		Else
			cSql := ""

			If !Empty(aRegs[nI, 4])
				cSql += IIF(!Empty(cSql), ",", "") + " CONTENT = '" + EnCodeUtf8(NoAcento(StrTran(aRegs[nI, 4], "'", "''"))) + "' "
			EndIf

			If !Empty(aRegs[nI, 5])
				cSql += IIF(!Empty(cSql), ",", "") + " STYLE   = '" + aRegs[nI, 5] + "' "
			EndIf

			If !Empty(aRegs[nI, 6])
				cSql += IIF(!Empty(cSql), ",", "") + " TIPO    = '" + aRegs[nI, 6] + "' "
			EndIf

			If !Empty(aRegs[nI, 7])
				cSql += IIF(!Empty(cSql), ",", "") + " COLSPAN = '" + aRegs[nI, 7] + "' "
			EndIf

			If !Empty(aRegs[nI, 8])
				cSql += IIF(!Empty(cSql), ",", "") + " ROWSPAN = '" + aRegs[nI, 8] + "' "
			EndIf

			If !Empty(aRegs[nI, 9])
				cSql += IIF(!Empty(cSql), ",", "") + " FORMULA = '" + aRegs[nI, 9] + "' "
			EndIf

			cSql := " UPDATE UEXCEL SET " + cSql
			cSql += " WHERE ID = '" + cExcelID + "' AND WORKSHEET = '" + cWorkSheet + "' "
			cSql += "   AND ROWEX = '" + aRegs[nI, 2] + "' AND COLEX = '" + aRegs[nI, 3] + "' "

			//ConOut("Update: " + cSql)
			////ConOut(Time() + " Cell:Put: update " + cSql)
			If TcSqlExec(cSql) <> 0
				//ConOut("Update Error: " + TcSqlError())
				UserException("UExcel: Error to set a value to cell - " + TcSqlError())
			EndIf
		EndIf
	Next

	FClose(nHandle)
return(.T.)

static function GrvXml(nFile, cLinha)
	Local lEncode := .F.
	//fWrite(nFile, cLinha + CHR(13) + CHR(10), Len(cLinha + CHR(13) + CHR(10)))
	If lEncode
		cLinha := EncodeXml(cLinha)
	EndIf
	fWrite(nFile, cLinha, Len(cLinha))
return(.T.)

Static function RetCposSx3(cAlias, aCabec)
	Local aArea := GetArea()
	Local aRet := {}

	DbSelectArea("SX3")
	DbSetOrder(1)

	If SX3->(!DbSeek(cAlias))
		RestArea(aArea)
		Return(aRet)
	EndIf

	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAlias

	    If SX3->X3_CONTEXT <> 'V'
			aAdd(aRet, SX3->X3_ARQUIVO+"->"+SX3->X3_CAMPO)
			aAdd(aCabec,SX3->X3_TITULO)
		EndIf

		SX3->(DbSkip())
	EndDo

	RestArea(aArea)
Return(aRet)

Static Function GetExcelId()
	Local cId := SM0->(M0_CODIGO + M0_CODFIL) + __cUserId + DtoS(Date()) + StrTran(Time(), ":", "")
	//	  				2           2              6           8                        6
Return(cId)

/*
	Local cTime := Time()
Return(AllTrim(Str(Val(DtoS(Date())) + (Val(SubStr(cTime, 1, 2)) * 1000) + (Val(SubStr(cTime, 4, 2)) * 1000) + (Val(SubStr(cTime, 7, 2)) * 1000))))
*/

Static Function EncodeXml(cString)
	Local aVet := {}

	aAdd(aVet, { "&lt;", "<" } )
	aAdd(aVet, { "&gt;", ">" } )
	aAdd(aVet, { "&amp;","&" } )
	aAdd(aVet, { "&aacute;", "á" } )
	aAdd(aVet, { "&acirc;", "â" } )
	aAdd(aVet, { "&agrave;", "à" } )
	aAdd(aVet, { "&atilde;", "ã" } )
	aAdd(aVet, { "&ccedil;", "ç" } )
	aAdd(aVet, { "&eacute;", "é" } )
	aAdd(aVet, { "&ecirc;", "ê" } )
	aAdd(aVet, { "&iacute;", "í" } )
	aAdd(aVet, { "&oacute;", "ó" } )
	aAdd(aVet, { "&ocirc;", "ô" } )
	aAdd(aVet, { "&otilde;", "õ" } )
	aAdd(aVet, { "&uacute;", "ú" } )
	aAdd(aVet, { "&uuml;", "ü" } )
	aAdd(aVet, { "&Aacute;", "Á" } )
	aAdd(aVet, { "&Acirc;", "Â" } )
	aAdd(aVet, { "&Agrave;", "À" } )
	aAdd(aVet, { "&Atilde;", "Ã" } )
	aAdd(aVet, { "&Ccedil;", "Ç" } )
	aAdd(aVet, { "&Eacute;", "É" } )
	aAdd(aVet, { "&Ecirc;", "Ê" } )
	aAdd(aVet, { "&Iacute;", "Í" } )
	aAdd(aVet, { "&Oacute;", "Ó" } )
	aAdd(aVet, { "&Ocirc;", "Ô" } )
	aAdd(aVet, { "&Otilde;", "Õ" } )
	aAdd(aVet, { "&Uacute;", "Ú" } )
	aAdd(aVet, { "&Uuml;", "Ü" } )


	aEval(aVet, {|x| StrTran(cString, x[2], x[1]) })

Return(cString)

Static Function GetPath(cNome)
	Local nOpcoes := GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY
	Local cDir := "C:\"
	Local cPath := ""
	Local lOk  := .F.
	Local nCont := 0
	Local cDrive := ""
	Local cDiretorio := ""
	Local cFileName := ""
	Local cExtensao := ""

	Default cNome := "Planilha.xls"

	cPath := cGetFile( '*' , 'Selecione diretório para salvar relatório', 1             , cDir          , .T.       , nOpcoes   ,.T.        , .T. )
	If !Empty(cPath)
		While !lOk
			If !(lOk := ExistDir(cDir) .Or. Empty(cDir))
				Aviso("Atenção", "Selecione um diretório válido", {"OK"})
			EndIf
		EndDo
	Else
		Return(cPath)
	EndIf
	cPath := cPath + cNome

	SplitPath(cPath, @cDrive, @cDiretorio, @cFileName, @cExtensao)

	While File(cDrive + cDiretorio + cFileName + IIf(Empty(nCont), "", "_" + AllTrim(Str(nCont))) + cExtensao)
		nCont++
	EndDo
Return(cDrive + cDiretorio + cFileName + IIf(Empty(nCont), "", "_" + AllTrim(Str(nCont))) + cExtensao)

static FUNCTION NoAcento(cString)
Local cChar  := ""
Local nX     := 0
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
Local cTio   := "ãõ"
Local cCecid := "çÇ"
Local cMaior := "&lt;"
Local cMenor := "&gt;" 

cString := u_uCodeXML( cString )

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("ao",nY,1))
		EndIf
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next

If cMaior$ cString
	cString := strTran( cString, cMaior, "" )
EndIf
If cMenor$ cString
	cString := strTran( cString, cMenor, "" )
EndIf

For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If Asc(cChar) < 32 .Or. Asc(cChar) > 123
		cString:=StrTran(cString,cChar,".")
	Endif
Next nX
Return cString

Static Function LockFile(cChave, nHandle, cFile, lPersist)
	Local lRet := .F.
	//Local cItem := "00"
	Local cTempDir := "uexcel_tmp/"

	Default cFile := ""
	Default nHandle := 0
	Default lPersist := .F.

	//While !lRet //.And. cItem <= "05"
	//Item := StrZero(Soma1(cItem, 2), 2)
	If !File(cTempDir + cChave + ".lck")
		lRet := (nHandle := FCreate(cTempDir + cChave + ".lck"))  >= 0
	Else
		lRet := (nHandle := FOpen(cTempDir + cChave + ".lck", FO_EXCLUSIVE + FO_READWRITE)) >= 0
	EndIf
	cFile := cTempDir + cChave + ".lck"
	//EndDo

	//If aScan(self:aLocks, { |aVet| aVet == cFile}) == 0
	//	aAdd(self:aLocks, cFile)
	//EndIf
	If lRet .And. !lPersist
		FClose(nHandle)
	EndIf
return(lRet)

Static Function GetRmtDir()
	Local cRet := StrTran(Lower(GetRemoteIniName()), "smartclient.ini", "")
Return(cRet)


//=============================================================================================================
// EncodeXML() - Alessandro de Barros Freire - Janeiro / 2015
//-------------------------------------------------------------------------------------------------------------
// Troca a acentuação pelo código correspondente em XML
//-------------------------------------------------------------------------------------------------------------
// Parametros
// cString - String a ser trocada
//-------------------------------------------------------------------------------------------------------------
// Retorno
// cRet    - String substituída
//=============================================================================================================
User Function uCodeXML(cString)
Local aVet   := {}
Local cStr   := "" 
Local cLetra := ""
Local nLoop

Default cString := ""

aAdd(aVet, {"&lt;", "<"})
aAdd(aVet, {"&gt;", ">"})
aAdd(aVet, {"&amp;","&"})
aAdd(aVet, {"&aacute;", "á"})
aAdd(aVet, {"&acirc;",  "â"})
aAdd(aVet, {"&agrave;", "à"})
aAdd(aVet, {"&atilde;", "ã"})
aAdd(aVet, {"&ccedil;", "ç"})

aAdd(aVet, {"&ecirc;",  "ê"})
aAdd(aVet, {"&eacute;", "é"})
aAdd(aVet, {"&iacute;", "í"})
aAdd(aVet, {"&oacute;", "ó"})
aAdd(aVet, {"&ocirc;",  "ô"})
aAdd(aVet, {"&otilde;", "õ"})
aAdd(aVet, {"&uacute;", "ú"})
aAdd(aVet, {"&uuml;",   "ü"})
aAdd(aVet, {"&Aacute;", "Á"})
aAdd(aVet, {"&Acirc;",  "Â"})
aAdd(aVet, {"&Agrave;", "À"})
aAdd(aVet, {"&Atilde;", "Ã"})
aAdd(aVet, {"&Ccedil;", "Ç"})
aAdd(aVet, {"&Eacute;", "É"})
aAdd(aVet, {"&Ecirc;",  "Ê"})
aAdd(aVet, {"&Iacute;", "Í"})
aAdd(aVet, {"&Oacute;", "Ó"})
aAdd(aVet, {"&Ocirc;",  "Ô"})
aAdd(aVet, {"&Otilde;", "Õ"})
aAdd(aVet, {"&Uacute;", "Ú"})
aAdd(aVet, {"&Uuml;",   "Ü"})
aAdd(aVet, {"o",        "º"})
aAdd(aVet, {"o",        "°"})
aAdd(aVet, {"?",        "¿"})
aAdd(aVet, {"u",        "µ"})
aAdd(aVet, {"3",        "³"})
aAdd(aVet, {" ",        "Ø"})

For nLoop := 1 to Len( cString )
	                                                           
	cLetra := SubStr(cString, nLoop,1 )
	aEval(aVet, {|x| cLetra := StrTran(cLetra, x[2], x[1]) })
	cStr += cLetra
	
Next nLoop

Return(cStr)
