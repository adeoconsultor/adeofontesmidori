#INCLUDE "TOTVS.CH"
//#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TRYEXCEPTION.CH"          
#INCLUDE "TOPCONN.CH"

Class UBrowse From LongClassName
	
	Data aPesqIdx  As Array HIDDEN
	Data aSeek     As Array HIDDEN
	DATA lSeeAll   As Boolean HIDDEN
	DATA lSeek     As Boolean HIDDEN
	DATA aFilial   As Array HIDDEN
	DATA aAllFilial As Array HIDDEN
	Data nSqlTot
	Data aColumns As Array
	Data bVldMark As Block HIDDEN
	DATA oTimer
	DATA nInterval
	
	DATA bTimerAction
	
	Data cClassName as String HIDDEN
	Data cTitle As String HIDDEN
	Data lNeedActivate As Boolean HIDDEN
		
	Data oOwner As Object HIDDEN
	Data oLayer As Object HIDDEN
	Data oBrw As Object HIDDEN 
	
	Data bExitWnd HIDDEN
	Data lForceQuit As Boolean HIDDEN
	Data oPnlButton As Object HIDDEN
	Data oPnlGrid   As Object HIDDEN
		
	Data cMenuDef As String HIDDEN
	Data aButtons As Array HIDDEN 
	Data cCapital As String HIDDEN 
	
	Data cAlias   As String HIDDEN
	Data aHeader  As Array HIDDEN
	Data aLegend  As Array HIDDEN
	Data nUsado   As Integer HIDDEN
	
	Data aFieldFilter As Array HIDDEN
	
	Data aFilter As Array HIDDEN
	
	Data cSql As String HIDDEN
	
	Data bChange HIDDEN
	Data bBeforeExec HIDDEN

	Data bAfterExec HIDDEN

	Data cFilDef As String HIDDEN 
	Data lDataArray As Boolean
	Data aColsArr As Array
	
	//Mark
	DATA bAfterMark
	DATA bAllMark
	DATA bCustomMarkRec
	
	DATA xFieldMark
	DATA cMark

	DATA lInvert
	DATA lSemaphore
	DATA aMarkKey As Array HIDDEN
	DATA aMarkCols As Array HIDDEN
	
	Data bBackColor As Block HIDDEN
	Data aStatusColumns As Array HIDDEN

	DATA lChgAll As Boolean
	
	Data bSeekChange As Block HIDDEN

	Method SetSeekChange(bSeekChange)
	
	METHOD SetChgAll(lChgAll)
		
	METHOD SetAfterMark(bAfterMark)
	Method MarkRec()
	Method IsInvert()
	Method Mark(cMark)
	Method CheckSemaphore(lUnLock)
	Method Semaphore()
	METHOD CanMark(cMark)
	Method AddMarkColumns(bMark,bLDblClick,bHeaderClick)
	//Method AddStatusColumns(bStatus,bLDblClick)
	METHOD OpenSemaphore()

	Method SetAllMark(bAllMark)
	Method SetCustomMarkRec(bCustomMarkRec)  
	METHOD SetDoubleClick(bLDblClick)
	Method SetFieldMark(xFieldMark)
	
	Method SetInvert(lInvert)
	Method SetTemporary(lTemporary)
	Method SetMark(cMark,cAlias,cField)      
	Method SetSemaphore(lSemaphore)
	
	Method Activate(oWnd)
	Method AddButton(cTitle, xAction, uParam1, nOption, nVerify, lNeedFind) 
	Method AddColSx3(cFieldSX3, cTitulo, cCampo, cPicture, nTamanho, nDecimal, nAlign)
	Method AddColumn(aColumn, lFilterField)
	Method AddFieldFilter(cField, cTipo, nTamanho, nDecimal)
	Method AddFilter(cFilter,  cExpAdvPL,  lNoCheck,  lSelected,  cAlias,  lFilterAsk,  aFilParser,  cID)
	Method AddLegend(cCond, cColor, cTitle)
	Method AddSqlInd( xField )
	Method AddSX3Filter(cField)
	Method AfterOption(cFunction ,nOption ,nVerify) 
	Method At()                 
	Method BeforeOption(cFunction,nOption,nVerify) 
	Method ClassName()
	Method CreateArrTable()    
	Method CreateBrwColumns()
	Method CreateButtons()
	Method CreateDataTable()
	Method CreateLegend()
	Method CreateOwner()
	Method CreatePnlButton()
	Method CreateSqlTable()
	Method DSPesqIdx() 
	Method DTPesqIdx() 
	Method Execute(cFunction,nOption,nVerify,cTitle)
	Method FromSql(cSql)
	Method GetField(cField, nRow)
	Method GetOwner()
	Method GoTo(nReg)      
	Method LoadButtons()
	Method LoadDicCol()
	Method LoadFils(cAlias) 
	Method NeedRefresh()
	Method New(oWnd)
	Method OnStartFilter()
	Method Refresh(lForce)
	Method SelectRow(nRow)
	Method SetAfterExec(bAfterExec) 
	Method SetAlias(cAlias)
	Method SetArray(aCols)
	Method SetBackColor(nBackColor)
	Method SetbChange(bChange)
	Method SetBeforeExec(bBeforeExec)
	Method SetClrAlterRow(nClrAlterRow)
	Method SetDataArray(lDataArray)
	Method SetExitWnd(bBlock)
	Method SetFilial(aFils) 
	Method SetFilterDefault(cFilter)
	Method SetFontBrowse(oFont)
	Method SetForeColor(nForeColor)
	Method SetLineHeight(nHeight)
	Method SetMenuDef(cMenuDef)
	Method SetPnlButton(oPnlButton) 
	Method SetPnlGrid(oPnlGrid) 
	Method SetSeeAll(lSeeAll)
	Method SetSeek(lSeek,aSeek)
	Method SetTitle(cTitle)	
	Method SqlRefresh()
	Method SqlTotReg()
	
	Method SetbBackColor(bColor) 
	METHOD GetMarkKey() 
	Method IsMark(nRow)
	Method ResetMark()
	Method SetbVldMark(bBlock)
	
	Method AddStatusColumns(bMeth, bView, cTitle)
	
	//Seek
	Method DTSeek(oSeek)
	
	Method ChangeTopBot()	
	
	Method DefFilial() 
	Method SelFilial() 
EndClass

Method SetSeekChange(bSeekChange) Class UBrowse
	self:bSeekChange := bSeekChange
Return(Self)

Method AddStatusColumns(bMeth, bView, cTitle) Class UBrowse
	Default cTitle := ""
	aAdd(self:aStatusColumns, {bMeth, bView, cTitle})
Return(self)

Method SetbVldMark(bBlock) Class UBrowse
	self:bVldMark := bBlock
Return(Self)

Method ResetMark() Class UBrowse
	Local nI := 1 
	
	For nI := 1 To Len(self:aMarkKey)
		UnLockByName(FunName() + self:aMarkKey[nI], .T., .T., .T. )
	Next        
	self:aMarkKey := {}
	self:aMarkCols := {}
	self:Refresh()
Return(self)

Method SetbBackColor(bColor) class UBrowse
	self:bBackColor := bColor      
	If self:oBrw <> Nil
		self:oBrw:SetBlkBackColor(self:bBackColor)
	EndIf
Return(Self)

METHOD SetSemaphore(lSemaphore) CLASS UBrowse
	PARAMTYPE 0 VAR lSemaphore AS LOGICAL OPTIONAL DEFAULT .T.
	
	::lSemaphore := lSemaphore
Return(Nil)

METHOD SetMark(cMark,cAlias,cField) CLASS UBrowse
	PARAMTYPE 0 VAR cMark  AS CHARACTER OPTIONAL
	PARAMTYPE 1 VAR cAlias AS CHARACTER OPTIONAL DEFAULT ::Alias()
	PARAMTYPE 2 VAR cField AS CHARACTER OPTIONAL DEFAULT ::cFieldMark
	
	If ValType(cMark) == "U"
		If ValType(cAlias) == "C" .And. ValType(cField) == "C"
			::cMark := GetMark(.F.,cAlias,cField)
		EndIf
	Else
		::cMark := cMark
	EndIf	
Return(Nil)

METHOD SetTemporary(lTemporary) CLASS UBrowse
Return(self:oBrw:SetTemporary(lTemporary))

METHOD SetInvert(lInvert) CLASS UBrowse
	PARAMTYPE 0 VAR lInvert AS LOGICAL
	::lInvert := lInvert
Return

METHOD SetFieldMark(xFieldMark) CLASS UBrowse
	Default xFieldMark := Nil 
	
	If xFieldMark <> Nil
		If ValType(xFieldMark) == "C"
			xFieldMark := {xFieldMark}
		EndIf
		
		self:xFieldMark := xFieldMark
	EndIf
Return(self)

METHOD SetDoubleClick(bLDblClick) CLASS UBrowse
Return(self:oBrw:SetDoubleClick(bLDblClick))

METHOD SetCustomMarkRec(bCustomMarkRec) CLASS UBrowse
	PARAMTYPE 0 VAR bCustomMarkRec AS BLOCK	
	self:bCustomMarkRec := bCustomMarkRec	
Return(Nil)

METHOD SetAllMark(bAllMark) CLASS UBrowse
	PARAMTYPE 0 VAR bAllMark AS BLOCK
	::bAllMark := bAllMark
Return(Nil)

METHOD SetAfterMark(bAfterMark) CLASS UBrowse
	PARAMTYPE 0 VAR bAfterMark AS BLOCK	
	::bAfterMark := bAfterMark	
Return

METHOD OpenSemaphore() CLASS UBrowse
	Local cAlias  := "FWMARKBRW"
	Local cFile   := GetPathSemaforo()+"FWMARKBRW.LCX"
	Local aStruct := {}
	
	//-------------------------------------------------------------------
	// Verifica se pode apagar o arquivo
	//-------------------------------------------------------------------
	If FErase(cFile) >= 0
		FErase(SubStr(cFile,1,Len(cFile)-4)+RetIndExt())
	EndIf
	
	If !File(cFile)
		MakeDir(GetPathSemaforo())
		Aadd(aStruct,{"ALIAS"   ,"C", 3,0})
		Aadd(aStruct,{"RECNO"   ,"C",10,0})
		Aadd(aStruct,{"USERNAME","C",25,0})
		DbCreate(cFile,aStruct,__LocalDriver)
	EndIf
	
	If MsOpenDbf(.T.,__LocalDriver,cFile,cAlias,.T.,.F.,.F.,.F.)
		DbSelectArea(cAlias)
		cIndex := cAlias+"1"
		lReOpen := !MsFile(cFile,cIndex,__LocalDriver)
		MsOpenIdx(cIndex,"ALIAS+RECNO",.T.,.F.,,cFile)
		If lReOpen
			DbCloseArea()
			MsOpenDbf(.T.,__LocalDriver,cFile,cAlias,.T.,.F.,.F.,.F.)
			DbSelectArea(cAlias)
			MsOpenIdx(cIndex,"ALIAS+RECNO",.T.,.F.,,cFile)
		EndIf
		DbSetOrder(1)
	EndIf
Return(Nil)

/*
METHOD AddStatusColumns(bStatus,bLDblClick) CLASS UBrowse
Return(self:oBrw:AddStatusColumns(bStatus,bLDblClick))
*/

METHOD AddMarkColumns(bMark,bLDblClick,bHeaderClick) CLASS UBrowse
Return(self:oBrw:AddMarkColumns(bMark,bLDblClick,bHeaderClick))

METHOD GetMarkKey() CLASS UBrowse
	Local nI := 1 
	Local cChave := ""
	
	If !Empty(self:xFieldMark)		
		For nI := 1 To Len(self:xFieldMark)
			If AllTrim(self:xFieldMark[nI]) == "R_E_C_N_O_"
				cChave += (self:oBrw:Alias())->( AllTrim(Str(RECNO())) )
			Else
				cChave += (self:oBrw:Alias())->( &(self:xFieldMark[nI]) )
			EndIf
		Next
	EndIf
Return(cChave)

METHOD CanMark() CLASS UBrowse
	Local lRet := .F.
	Local cChave := self:GetMarkKey()
	
	If !Empty(self:xFieldMark)
		lRet := aScan(self:aMarkKey, { |aVet| aVet ==  cChave } ) > 0 
	EndIf
Return lRet

METHOD Semaphore() CLASS UBrowse
Return ::lSemaphore

METHOD CheckSemaphore(lUnLock) CLASS UBrowse
	Local cAlias := ::Alias()
	Local cRecno := LTrim(Str((cAlias)->(Recno())))
	Local lRet   := .T.
	Local cSaveAlias := Alias()
	
	PARAMTYPE 0 VAR lUnLock AS LOGICAL OPTIONAL DEFAULT .F.
	
	//-------------------------------------------------------------------
	// Verifica se o controle de marca exclusiva está habilitada
	//-------------------------------------------------------------------
	If ::Semaphore()
		DbSelectArea("FWMARKBRW")
		If !DbSeek(cAlias+cRecno)
			If !lUnLock
				DbAppend(.F.)
				FWMARKBRW->ALIAS    := cAlias
				FWMARKBRW->RECNO    := cRecno
				FWMARKBRW->USERNAME := cUserName
				MsRUnlock(Recno())
				SimpleLock()
			EndIf
		Else
			If lUnLock
				MsRUnlock(Recno())
			Else
				If !RLock()
					Alert("Registro está sendo utilizado pelo usuário: " + FWMARKBRW->USERNAME) 
					lRet := .F.
				Else
					FWMARKBRW->USERNAME := cUserName
					MsRUnlock(Recno())
					SimpleLock()
				EndIf
			EndIf
		EndIf
		
		DbSelectArea(cSaveAlias)
	EndIf
Return lRet

METHOD Mark(cMark) CLASS UBrowse
	PARAMTYPE 0 VAR cMark AS CHARACTER OPTIONAL DEFAULT self:cMark
Return cMark

METHOD IsInvert() CLASS UBrowse
Return(self:lInvert)

METHOD MarkRec(lExecAfter) CLASS UBrowse
	Local cChave := self:GetMarkKey()
	Local nField := 0
	
	Default lExecAfter := .T.
	
	If self:bVldMark <> Nil .And. !( Eval(self:bVldMark) )
		Return(self)	
	EndIf
		
	If ValType(::bCustomMarkRec) == "U"
		If !Empty(::xFieldMark) //.And. ::Valid()
		
			nPosMark := aScan(self:aMarkKey, { |aVet| aVet ==  cChave } )			
			
			If nPosMark == 0//Não está marcado 
				If LockByName(FunName() + cChave, .T., .T., .T. )
					aAdd(self:aMarkKey, cChave)

					aAdd(self:aMarkCols, {})
					
					For nField := 1 To Len(self:aHeader)
						aAdd(aTail(self:aMarkCols), self:GetField(self:aHeader[nField, 1]))
					Next
				Else
					Aviso("Atenção", "Registro selecionado por outro usuário!", {"OK"})
				EndIf
			Else
				If UnLockByName(FunName() + cChave, .T., .T., .T. ) 					
					aDel(self:aMarkKey , nPosMark )
					aSize(self:aMarkKey, Len(self:aMarkKey) - 1)

					aDel(self:aMarkCols , nPosMark )
					aSize(self:aMarkCols, Len(self:aMarkCols) - 1)					
				EndIf
			EndIf				
		EndIf
	Else
		Eval(::bCustomMarkRec)
	EndIf                              
	
	If lExecAfter .And. ValType(::bAfterMark) == "B"	
		Eval(::bAfterMark) 
	EndIf
Return(self)
	
Method SetForeColor(nForeColor) CLASS UBrowse	
Return(self:oBrw:SetForeColor(nForeColor))

Method SetFontBrowse(oFont) CLASS UBrowse
Return(self:oBrw:SetFontBrowse(oFont))

Method SetBackColor(nBackColor) CLASS UBrowse
Return(self:oBrw:SetBackColor(nBackColor))

Method SetClrAlterRow(nClrAlterRow) CLASS UBrowse	
Return(self:oBrw:SetClrAlterRow(nClrAlterRow))

Method SetLineHeight(nHeight) CLASS UBrowse
Return(self:oBrw:SetLineHeight(nHeight))

Method ClassName() Class UBrowse
Return(self:cClassName)

Method IsMark(nRow) Class UBrowse
Return(self:CanMark())

Method GetField(cField, nRow) Class UBrowse
	Local xRet := Nil
	Local nField := aScan(self:aHeader, { |aVet| AllTrim(Upper(aVet[1])) == AllTrim(Upper(cField)) } )
	
	Default nRow := self:At()
		
	If nField > 0 
		xRet := self:oBrw:GetColumnData(nField + IIF(!Empty(self:aLegend), 1, 0) + Len(self:aStatusColumns))//Se tem legenda pega campo + 1
		
		If self:aHeader[nField, 2] == "N"
			xRet := Val(xRet)
		ElseIf self:aHeader[nField, 2] == "D"
			xRet := CtoD(xRet)
		EndIf
		
	EndIf	
Return(xRet)

Method GoTo(nReg) Class UBrowse
	self:oBrw:GoTo(nReg)
Return()

Method SelectRow(nRow) Class UBrowse
	self:oBrw:SelectRow(nRow)
Return()

Method At() Class UBrowse
Return(self:oBrw:At())

Method SetDataArray(lDataArray) Class UBrowse
	self:lDataArray := lDataArray
Return(Self)

Method SetArray(aCols) Class UBrowse       
	Local nI := 0
	Local nJ := 1
	Local nI
	
	self:aColsArr := aCols
	
	For nI := 1 To Len(self:aColsArr)
		For nJ := 1 To Len(self:aHeader)
			If self:aHeader[nJ, 2] == "D" .And. ValType( self:aColsArr[nI, nJ] ) == "D"
				self:aColsArr[nI, nJ] := DtoC(self:aColsArr[nI, nJ])
			ElseIf self:aHeader[nJ, 2] == "N" .And. ValType( self:aColsArr[nI, nJ] ) == "N"
				If !Empty(self:aHeader[nJ, 5])
					self:aColsArr[nI, nJ] := Transform(self:aColsArr[nI, nJ], self:aHeader[nJ, 5])
				Else
					self:aColsArr[nI, nJ] := AllTrim(Str(self:aColsArr[nI, nJ]))
				EndIf
			EndIf
		Next
	Next
	
	
	If self:oBrw <> Nil
		self:oBrw:SetArray(self:aColsArr)
	EndIf
Return(Self)

Method AddFilter(cFilter,  cExpAdvPL,  lNoCheck,  lSelected,  cAlias,  lFilterAsk,  aFilParser,  cID) Class UBrowse
	aAdd(self:aFilter, {cFilter,  cExpAdvPL,  lNoCheck,  lSelected,  cAlias,  lFilterAsk,  aFilParser,  cID } )

	If self:oBrw <> Nil
		self:oBrw:AddFilter(cFilter,  cExpAdvPL,  lNoCheck,  lSelected,  cAlias,  lFilterAsk,  aFilParser,  cID)
	EndIf
Return(Nil)

Method AddSqlInd( xField ) Class UBrowse
	Local aArea := GetArea()
	Local aAreaSX3 := SX3->(GetArea())
	Local cTitulo := ""
	Local aAux := {}
	Local nI
	
	DbSelectArea( "SX3" )
	SX3->(DbSetOrder(2))
		
	If ValType( xField ) == "A"
		//xField -> {cChave, aConfig) 
		//cChave -> "A1_COD + A1_LOJA"
		//aConfig -> cSx3Field 
		//aConfig -> {Titulo, Tipo, Tamanho, Decimal} 
		cChave    := xField[1]
		aConfig := xField[2]
		
		aAdd(self:aPesqIdx, cChave)
		For nI := 1 To Len(aConfig )
			If ValType(aConfig [nI]) == "A"
				cTitulo += IIF(Empty(cTitulo), "", "+") + aConfig [nI, 1]
				aAdd(aAux, {"", aConfig[nI, 2],aConfig[nI, 3],aConfig[nI, 4],aConfig[nI, 1], ,})
			Else
				If SX3->(DbSeek(aConfig[nI]) )
					cTitulo += IIF(Empty(cTitulo), "", "+") + AllTrim(SX3->X3_TITULO)
					aAdd(aAux, { "", SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL,AllTrim(SX3->X3_TITULO),,})			
				EndIf				
			EndIf				
		Next
		aAdd(self:aSeek, {cTitulo, aAux} )				
	Else
		If SX3->(DbSeek(xField) )
			aAdd(self:aPesqIdx, AllTrim(SX3->X3_CAMPO))
			aAdd(self:aSeek, {AllTrim(SX3->X3_TITULO), {{ "", SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL,SX3->X3_TITULO,,}} } )
		EndIf
	EndIf
	
	RestArea(aAreaSX3)
	RestArea(aArea)
Return(Self)

Method SetSeeAll(lSeeAll) Class UBrowse
	self:lSeeAll := lSeeAll
Return(Self)         

METHOD SetSeek(lSeek,aSeek) CLASS UBrowse
	PARAMTYPE 0 VAR lSeek AS LOGICAL OPTIONAL DEFAULT .T.
	PARAMTYPE 1 VAR aSeek AS ARRAY   OPTIONAL DEFAULT {}
	
	self:lSeek := lSeek
	self:aSeek := aSeek
Return(Nil)


Method New(cTitle) Class UBrowse
	//PARAMTYPE 0 VAR cTitle AS STRING OPTIONAL DEFAULT Space(1)
	Default cTitle := ""
	
	::cClassName    := "UBROWSE"
	::cTitle        := cTitle
	::aPesqIdx     := {}
	::aSeek           := {}	
	::cCapital      := ""
	::oOwner        := Nil
	::lNeedActivate := .F.
	::aButtons      := {} 
	::bExitWnd      := { || self:oOwner:End() }
	::lForceQuit    := .F.
	::oPnlGrid      := Nil
	::oPnlButton    := Nil
	::cAlias        := ""
	::aHeader       := {}
	::aLegend       := {}
	::cSql          := ""
	::nUsado        := 0 
	::aFieldFilter	:= {}
	::oBrw := Nil
	::bChange := { || self:DefFilial(), .T. }
	::bBackColor := { || Nil }
	::nSqlTot := 0
	::aMarkKey := {}
	::aMarkCols := {}
	::aStatusColumns := {}
	
	::aFilter := {}
	::cFilDef := ""
	
	::bTimerAction := { || CursorWait(), self:Refresh(), CursorArrow() }

	::bAfterExec := { |cFunction,nOption,nVerify| CursorWait(), self:Refresh(.T.), CursorArrow() }
		
	//-------------------------------------------------------------------
	// Executa a chamada do construtor da classe FWBrowse
	//-------------------------------------------------------------------
	//_Super:New(oWnd)  
	::aColumns := {}
	::bVldMark := Nil
Return(Self)
/*    
Method GetField(cField) Class UBrowse
	Local cRet := ""
	
	If (self:cAlias)->(FieldPos(cField)) > 0
		cRet := (self:cAlias)->( &(cField) )
	EndIf
Return(cRet)
*/                   
Method FromSql(cSql) Class UBrowse

	Local nI
	self:cSql := cSql 

	If self:oBrw <> Nil
		self:oBrw:SetQuery(self:cSql)		
		For nI := 1 To Len(self:aHeader)                 
			If self:aHeader[nI, 2] <> 'C'                                                          
				TcSetField(self:cAlias, self:aHeader[nI, 1], self:aHeader[nI, 2], self:aHeader[nI, 3], self:aHeader[nI, 4])
				//TCSetField(< cAlias>, < cCampo>          , < cTipo>           , [ nTamanho]        , [ nDecimais] )
			EndIf
		Next
		self:oBrw:Refresh(.T.)
	EndIf	
Return(Self)

Method SetbChange(bChange) Class UBrowse
	Local oSelf := Self      
	
	self:bChange := { || self:DefFilial(), Eval(bChange) }
		
	If self:oBrw <> Nil
		self:oBrw:bChange := self:bChange //{ || self:oTimer:Activate() } //bChange
	EndIf
Return(Self)

Method SetFilterDefault(cFilter) Class UBrowse
	self:cFilDef := cFilter 
	
	If self:oBrw <> Nil
		self:oBrw:SetFilterDefault(self:cFilDef)
	EndIf
Return(Self)

Method Refresh(lForce) Class UBrowse
	Default lForce := .F.
	
	If self:oBrw <> Nil            
		If self:oBrw:DataQuery() 
			self:SqlRefresh(lForce)
		Else
			self:oBrw:Refresh()
		EndIf	
	EndIf
Return(Self)

Method SqlRefresh(lForce) Class UBrowse
	Default lForce := .F.
	
	//If lForce .Or. self:NeedRefresh()
		self:oBrw:oData:DeActivate()
		self:oBrw:oData:Activate()
		self:oBrw:Refresh()
	//EndIf
Return(Self)

Method NeedRefresh() Class UBrowse
	Local lRet := .F.
	Local nCount := self:SqlTotReg()
	If lRet := self:nSqlTot <> nCount
		self:nSqlTot := nCount
	EndIf
Return(lRet)
	                                            
Method SqlTotReg() Class UBrowse
	Local cSql := ""
	cSql := " SELECT COUNT(*) COUNT FROM ( " + self:cSql + " ) QUERY "
	//-------------------------------------------------------------------
	// Retira o ORDER BY da Query
	//-------------------------------------------------------------------
	If At("ORDER BY", Upper(cSql)) > 0
		cSql := SubStr(cSql,1,At("ORDER BY",cSql)-1) + SubStr(cSql,RAt(")",cSql))
	EndIf	                                                                   
	
	//Aviso("select", cSql, {"OK"})
		
	DbUseArea( .T., "TOPCONN", TCGENQRY(,,cSql),"SQLCOUNT",.F.,.T.)
	nCount := SQLCOUNT->COUNT
	SQLCOUNT->(DbCloseArea())
Return(nCount)

Method SetPnlButton(oPnlButton) Class UBrowse
	self:oPnlButton := oPnlButton
Return(Nil)

Method SetPnlGrid(oPnlGrid) Class UBrowse
	self:oPnlGrid := oPnlGrid
Return(Nil)

Method AddLegend(cCond, cColor, cTitle) Class UBrowse
	aAdd(self:aLegend, {cCond, cColor, cTitle})
Return(Self)

Method SetMenuDef(cMenuDef) class UBrowse
	//PARAMTYPE 0 VAR cMenuDef AS String DEFAULT FunName()
	Default cMenuDef := FunName() 
	
	self:cMenuDef := cMenuDef
	self:LoadButtons()
Return(self)

Method Activate(oOwner) Class UBrowse
	//PARAMTYPE 0 VAR oOwner AS OBJECT OPTIONAL DEFAULT oMainWnd
	Local nI
	Default oOwner := self:GetOwner()
	
	self:lSeek := .T.
	
	self:oOwner := oOwner	      
	
	If self:oPnlGrid == Nil 
		self:oLayer := FWLayer():New()
		self:oLayer:Init(self:oOwner, .F., .T. )
		
		If !Empty(self:aButtons)
			self:oLayer:AddLine('MAIN'  , 094, .F. )		
			self:oLayer:AddLine('DOWN'  , 006, .F. )
			self:oPnlButton := self:oLayer:getLinePanel('DOWN')		
		Else
			self:oLayer:AddLine('MAIN'  , 100, .F. )		
		EndIf
		
		self:oLayer:AddCollumn('MAINCOL', 100, .T., 'MAIN')
		self:oLayer:AddWindow( 'MAINCOL', 'C01W01', "" , 100, .F., .F.,, 'MAIN', { || } )	
		
		self:oPnlGrid := self:oLayer:getWinPanel('MAINCOL', 'C01W01', 'MAIN')
	EndIf
	
	self:SetTitle(self:cTitle)
	
	//FWBrowse 
	self:oBrw := FWBrowse():New(self:oPnlGrid)
	
	If self:lDataArray
		self:CreateArrTable()
	ElseIf Empty(self:cSql)
		//CreateDataTable
		self:CreateDataTable()
	Else
		//CreateSqlTable
		self:CreateSqlTable()
	EndIf
	
	If !Empty(self:cFilDef)
		self:oBrw:SetFilterDfault(self:cFilDef)
	EndIf
			
	For nI := 1 To Len(self:aFilter)
		self:oBrw:AddFilter(self:aFilter[nI, 1],  self:aFilter[nI, 2],  self:aFilter[nI, 3],  self:aFilter[nI, 4],  self:aFilter[nI, 5],  self:aFilter[nI, 6],  self:aFilter[nI, 7],  self:aFilter[nI, 8])
	Next
	
	self:oBrw:nFontBody := 5

	/*
	oProfile:= FWProfile():New()
	oProfile:SetTask("PROTHEUS")
	oProfile:SetType("BROWSE" + self:cAlias)
	oProfile:Load()
	aProfile := oProfile:GetProfile()
	*/
	
	self:oBrw:SetUseFilter(,{ || self:OnStartFilter() })
		
	self:CreatePnlButton()
	
	//Cria Mark Browse
	If !Empty(self:xFieldMark)             		
		bMark      := { || If(self:CanMark(),'LBOK','LBNO') }
		bLDblClick := { || self:MarkRec() }
		
		self:oBrw:bCustomlDblClick := bLDblClick
		
		self:oBrw:AddMarkColumns(bMark,bLDblClick,self:bAllMark)
		
		self:oBrw:SetColumnOrder(Len(self:oBrw:aColumns),1)
	EndIf
		
	//-------------------------------------------------------------------	
	// Verifica se o usuário tem direito a utilizar o locate
	//-------------------------------------------------------------------	
	If !VerSenha(175)
		self:oBrw:DisableLocate()
	EndIf
	//-------------------------------------------------------------------	
	// Verifica se o usuário tem direito a utilizar o filtro
	//-------------------------------------------------------------------		
	If !VerSenha(116)
		self:oBrw:DisableFilter()
	EndIf
				
	self:oBrw:Activate()      
	          
	//Ajusta Tamanho das colunas
	//For nI := 1 To Len(self:aHeader)
	//	self:oBrw:Browse():SetColumnSize( nI, self:aHeader[nI, 7] * 0.7 )
	//Next
	self:SetbChange(self:bChange)
	self:SetbBackColor(self:bBackColor)
	
	self:oBrw:Refresh()
	
	//Timer para Refresh        
	self:nInterval := 60000                                                                                                                
	self:oTimer := TTimer():New(self:nInterval, {|| Processa(self:bTimerAction, "Atualizando...") }, self:oPnlGrid:OWND)	
	self:oTimer:Activate()                                   
	
	//self:oTimer := TTimer():New(self:nInterval, {|| Eval(self:bChange), self:oTimer:DeActivate(), self:Refresh() }, self:oPnlGrid:OWND)
    
	/*
	If !Empty(self:cSql)
		//Ajusta Tipos de Dados		
		For nI := 1 To Len(self:aHeader)                         
			If self:aHeader[nI, 4] <> "C"
				TcSetField(self:cAlias, self:aHeader[nI, 1] ,self:aHeader[nI, 4], self:aHeader[nI, 7], self:aHeader[nI, 8])
			EndIf
		Next
	EndIf
	*/
		
	
	If self:lNeedActivate
		self:oOwner:Activate()		
		self:oBrw:DeActivate()
	EndIf
	
Return(Self)                        

METHOD LoadFils(cAlias) CLASS UBrowse
Local nI          := 0
Local nPos      := 0
Local aProfFil  := {}
Local aEmpresas := FWLoadSM0()
Local cFunName  := Upper(FunName())
Local lAddFil   := .T.
Local cFil      := ""

PARAMTYPE 0 VAR cAlias AS CHARACTER

If FindProfDef(cUserName,cFunName,'MBRWSHWFIL',cAlias)
	lAddFil := .F.
	aProfFil := Str2Array(RetProfDef(cUserName,cFunName,'MBRWSHWFIL',cAlias))
EndIf

self:aAllFilial := {}
self:aFilial    := {}

//-------------------------------------------------------------------
// Posiciona no grupo de empresas atual
//-------------------------------------------------------------------
If (nPos := Ascan(aEmpresas, { |x| x[SM0_GRPEMP] == cEmpAnt } )) > 0
	For nI := nPos To Len(aEmpresas)
		If aEmpresas[nI,SM0_GRPEMP] == cEmpAnt
			If aEmpresas[nI,SM0_USEROK] .And. (aEmpresas[nI,SM0_CODFIL] == cFilAnt .Or. self:lSeeAll)//
				cFil := xFilial(cAlias,aEmpresas[nI,SM0_CODFIL])
				//-------------------------------------------------------------------
				// Filial disponíveis para o usuário
				//-------------------------------------------------------------------
				If aEmpresas[nI,SM0_USEROK] .And. (lAddFil .Or. Ascan(aProfFil,cEmpAnt+aEmpresas[nI,SM0_CODFIL]) == 0)
					If Ascan(self:aFilial,cFil) == 0
						Aadd(self:aFilial,cFil)
					EndIf
				EndIf
				//-------------------------------------------------------------------
				// Todas filiais do grupo de empresas
				//-------------------------------------------------------------------
				If Ascan(self:aAllFilial,cFil) == 0
					Aadd(self:aAllFilial,cFil)
				EndIf
			EndIf
		Else
			Exit
		EndIf
	Next nI
	aSort(self:aFilial,,,{|x,y| x < y})
	aSort(self:aAllFilial,,,{|x,y| x < y})
EndIf

Return self:aFilial

Method CreatePnlButton() Class UBrowse                           
	If self:oPnlButton <> Nil
		If Empty(self:aButtons) .And. !Empty(self:cMenuDef) 
			self:LoadButtons()
		EndIf
		
		If !Empty(self:aButtons)
			self:CreateButtons()
		EndIf
	EndIf
Return(self)

METHOD SetChgAll(lChgAll) CLASS UBrowse
PARAMTYPE 0 VAR lChgAll AS LOGICAL OPTIONAL

::lChgAll := lChgAll

Return

Method CreateDataTable() Class UBrowse
	Local bSeek := Nil
	
	If ValType(::lSeeAll) == "U"
		::lSeeAll := VerSenha(114)
	EndIf
	
	If ValType(::lChgAll) == "U"
		If VerSenha(115)
			::lSeeAll := .T.
			::lChgAll := .T.
		Else
			::lSeeAll := .F.
			::lChgAll := .F.
		EndIf
	ElseIf ::lChgAll
		::lSeeAll := .T.
	EndIf
		
	self:LoadFils(self:cAlias)
	
	//Define Datatable FWBrowse
	self:oBrw:SetDataTable()
	//Define Alias FWBrowse
	self:oBrw:SetAlias( self:cAlias )

	self:CreateLegend()	
	
	//Se aHeder não definido
	//Carrega aHeader padrão
	If Empty(self:aHeader)
		self:LoadDicCol()
	EndIF
	
	//Cria colunas baseada no aHeader
	self:CreateBrwColumns()
	
	// Carrega as opções de pesquisa		
	If self:lSeek .And. Empty(self:aSeek)
		self:DTPesqIdx()  
	EndIf

	//-------------------------------------------------------------------	
	// Habilita a opção de pesquisa
	//-------------------------------------------------------------------
	If self:lSeek .And. !Empty(self:aSeek)
		//-------------------------------------------------------------------
		// Para as tabelas que não utilizam TopConnect o controle do seek será efetuado pela FWMBrowse
		//-------------------------------------------------------------------
		//If !::Temporary()
		bSeek := { |oSeek| self:DTSeek(oSeek) }
		//EndIf
		self:oBrw:SetSeek(bSeek,self:aSeek)
		//self:oBrw:SetSeekChange({ |o| ::SeekChange(o) })
		//-------------------------------------------------------------------
		// Força a primeira atualização da quebra na impressão do relatório
		//-------------------------------------------------------------------
		//self:SeekChange()
	EndIf

	If !::lSeeAll
		::ChangeTopBot()
	Else
		//-------------------------------------------------------------------
		// Adiciona novos itens de configuração
		//-------------------------------------------------------------------
		self:oBrw:AddCustomConfig("Filial",{|o| MBrFilialCfg(o,Self:oBrw) }, { || MBrSaveFilCfg(Self:oBrw) } ) 
	EndIf
	
	//-------------------------------------------------------------------	
	// Atualiza o controle de visualização dos registros da tabela
	//-------------------------------------------------------------------
	::self:oBrw:oData:SetSeeAll(self:lSeeAll)
	//-------------------------------------------------------------------
	// Atualiza o controle de apresentação da filial na pesquisa (MSLIB)
	//-------------------------------------------------------------------
	SetBrwSeeAll(self:lSeeAll)
		
	//	
	self:SetFilial(self:aFilial)
Return(Nil)             

METHOD ChangeTopBot() CLASS UBrowse
	Local cCpoFil := ""
	Local cTopFun := "xFilial('"+self:cAlias+"')"
	Local cBotFun := cTopFun
	Local lTopBotDef := .F.
	
	If At(PrefixoCpo(self:cAlias)+"_FILIAL",Indexkey()) == 1
		cCpoFil :=  self:cAlias+"->"+PrefixoCpo(self:cAlias)+"_FILIAL"
		cTopFun := "xFilial('"+self:cAlias+"')"
		cBotFun := cTopFun
		lTopBotDef := .F.
	Else
		//-------------------------------------------------------------------
		// Qdo filial nao faz parte da chave (Ex. SRA, ordem 8)
		//-------------------------------------------------------------------
		cCpoFil := "'"+Space(FWSizeFilial())+"'" 
		cTopfun := cCpoFil
		cBotFun := "'ZZ'"
		lTopBotDef := .F.
	EndIf

//-------------------------------------------------------------------
// Atualiza a visualização de Top/Bottom
//-------------------------------------------------------------------
self:oBrw:SetFilter(cCpoFil,&(cTopFun),&(cBotFun))

Return            

Method DTSeek(oSeek) Class UBrowse
	Local nOrder       := 1
	Local nOrdSelected := 0
	Local nRecno       := 0
	Local cSeek        := ""

	If ValType(oSeek) == "O"
		cSeek  := RTrim(oSeek:GetSeek())
		nOrder := oSeek:GetOrder()
		nOrdSelected := oSeek:OrderSelected()
		nOldRec:= (self:oBrw:Alias())->(Recno())
		
		(self:cAlias)->(DbSetOrder(nOrder))		
		If (self:cAlias)->( !DbSeek( IIF( self:lSeeAll .And. !Empty( xFilial(self:cAlias) ), "", xFilial(self:cAlias)) + cSeek , .T. ) )
			Help(" ",1,"PESQ01")		
			self:oBrw:UpdateTopBot()
			self:oBrw:GoTo(nOldRec)
		Else
			nRecno := (self:oBrw:Alias())->(Recno())
			
			//-------------------------------------------------------------------
			// Verifica se a ordem foi alterada e executa a atualização do controle do Top/Bottom
			//-------------------------------------------------------------------
			If nOrder <> self:oBrw:oData:GetOldOrder()
				self:oBrw:UpdateTopBot()
				self:oBrw:GoTo(nRecno)
			EndIf		
		EndIf
	EndIf

Return nRecno

/*
METHOD SeekChange(oComboSeek) CLASS FWMBrowse
Local cAlias      := ""
Local cIndex      := ""
Local nI          := 0
Local nAuxOrd     := 0
Local nOrder      := 1
Local aBreak      := {}
Local aIndexKey   := {}
Local aNickName   := {}

PARAMTYPE 0 VAR oComboSeek AS OBJECT OPTIONAL

cAlias := ::FWBrowse():Alias()
//-------------------------------------------------------------------
// Localiza a ordem selecionada do índice na tabela
//-------------------------------------------------------------------	
If ValType(oComboSeek) == "O"
	nOrder := oComboSeek:nAt
EndIf
For nI := 1 To Len(::aSeek)
	If Len(::aSeek[nI]) > 3
		If ::aSeek[nI,4]
			nAuxOrd++
			If nAuxOrd == nOrder
				nOrder := ::aSeek[nI,3]
				cIndex := ::aSeek[nI,1]
				Exit
			EndIf
		EndIf
	EndIf
Next nI
//-------------------------------------------------------------------
// Caso não localizou, força a primeira ordem
//-------------------------------------------------------------------	
If Empty(cIndex) .And. Len(::aSeek) > 0
	nOrder := ::aSeek[1,3]
	cIndex := ::aSeek[1,1]
EndIf

//-------------------------------------------------------------------
// Atualiza o Browse com a nova ordem selecionada
//-------------------------------------------------------------------	
(cAlias)->(DbSetOrder(nOrder))
::Refresh()

//-------------------------------------------------------------------
// Verifica se a impressão dos itens do Browse está habilitada
//-------------------------------------------------------------------	
If ::OptionReport()
	//-------------------------------------------------------------------
	// Monta a quebra do relatório de acordo com o índice selecionado
	//-------------------------------------------------------------------	
	aIndexKey := StrToKArr((cAlias)->(IndexKey(nOrder)),"+")
	aNickName := StrToKArr(cIndex,"+")
	For nI := 1 To Len(aIndexKey)
		If nI <> Len(aIndexKey)
			Aadd( aBreak, { aIndexKey[nI], AllTrim(aNickName[nI]) } )
		EndIf
	Next nI
	//-------------------------------------------------------------------
	// Indica a quebra de impressão no relatório
	//-------------------------------------------------------------------	
	If !Empty(aBreak)
		::SetBreakReport(aBreak)
	EndIf
EndIf

Return
*/
Method DTPesqIdx() Class UBrowse
	Local aPesqOrd := {}
	Local aInfoSeek := {}
	Local nI := 0
	
	self:aSeek := {} //Sobrepõe qualquer pesquisa definida
	self:aPesqIdx := {}
	
	//-------------------------------------------------------------------
	// Retorna os índices da tabela
	//-------------------------------------------------------------------
	AxPesqOrd(self:cAlias,@self:aPesqIdx,,self:lSeeAll,@aPesqOrd)
	
	//-------------------------------------------------------------------
	// Retorna informações para os detalhes da pesquisa
	//-------------------------------------------------------------------
	PesqList(self:cAlias,self:lSeeAll,{},@aInfoSeek)

	//-------------------------------------------------------------------
	// Chave de Pesquisa
	// 1 - Chave
	// 2 - Detalhes da pesquisa
	// 3 - Ordem do índice na tabela
	//-------------------------------------------------------------------
	For nI := 1 To Len(self:aPesqIdx)
		If self:aPesqIdx[nI,2]   
			If Empty(xFilial(self:cAlias))
				aPesqOrd[nI] := StrTran(UPPER(aPesqOrd[nI]), "FILIAL+", "")
				If (nPosFil := aScan( aInfoSeek[nI], { |aVet| aVet[7] == PrefixoCpo(self:cAlias) + "_FILIAL" } ) ) > 0					
					aDel( aInfoSeek[nI] , nPosFil )
					aSize( aInfoSeek[nI] , Len(aInfoSeek[nI]) - 1 )
				EndIf
			EndIf
				
			Aadd( self:aSeek, { aPesqOrd[nI], aInfoSeek[nI], self:aPesqIdx[nI,1], .T. } )
		EndIf
	Next nI

	
Return(Self)

Method DefFilial(lSelFil) CLASS UBrowse
	
	Default lSelFil := .F.
	
	If (self:cAlias)->( FieldPos(PrefixoCpo(self:cAlias) + "_FILIAL") ) > 0
		If TYPE("INCLUI") <> "U" .And. INCLUI
			If lSelFil .And. self:lSeeAll
				cFilAnt :=  self:SelFilial()  
				
				SM0->( DbSeek(cEmpAnt + cFilAnt) )
			EndIf
			If !FlatMode()
				oMsgItem3:SetText(Capital(AllTrim(SM0->M0_NOME)+" / "+AllTrim(SM0->M0_FILIAL)))
			EndIf			
		ElseIf !Empty(xFilial(self:cAlias)) .And. !Empty((self:cAlias)->( &(PrefixoCpo(self:cAlias) + "_FILIAL") )) .And. cFilAnt <> (self:cAlias)->( &(PrefixoCpo(self:cAlias) + "_FILIAL") )
			cFilAnt :=  (self:cAlias)->( &(PrefixoCpo(self:cAlias) + "_FILIAL") )
			
			SM0->( DbSeek(cEmpAnt + cFilAnt) )
			
			If !FlatMode()
				oMsgItem3:SetText(Capital(AllTrim(SM0->M0_NOME)+" / "+AllTrim(SM0->M0_FILIAL)))
			EndIf
		EndIf
	EndIf
	
Return(Nil)

Method SelFilial() CLASS UBrowse
	Local nRecSM0 := SM0->( RecNo() )
	Local aFilSm0 := {} 
	Local cFilCbx := ""
	
	SM0->(DbSeek(cEmpAnt))
	While SM0->(!Eof()) .And. SM0->M0_CODIGO == cEmpAnt
		aAdd(aFilSm0, Padr(SM0->M0_CODFIL,FWSizeFilial())+"-"+SM0->M0_FILIAL )
	
		SM0->( DbSkip() )
	EndDo
	
	SM0->( DbGoto( nRecSM0 ) )

	//-------------------------------------------------------------------		
	// Exibe a lista de filiais para o usuário
	//-------------------------------------------------------------------
	If Len(aFilSm0) > 1
		DEFINE MSDIALOG oDlg TITLE "Selecione a Filial" FROM 010, 010 TO 110, 270 PIXEL // 
	
			@ 015, 010 SAY "Filial" OF oDlg PIXEL // 
			@ 015, 040 MSCOMBOBOX oCbx VAR cFilCbx ITEMS aFilSm0 SIZE 080, 012 OF oDlg PIXEL
	
			DEFINE SBUTTON oBtn FROM 035, 100 TYPE 1 ENABLE OF oDlg PIXEL ACTION oDlg:End()
	
		ACTIVATE MSDIALOG oDlg CENTERED
	Else
		cFilCbx := aFilSm0[1]
	EndIf
	
Return( Subs(cFilCbx,1,FWSizeFilial()) ) 

METHOD SetFilial(aFils) CLASS UBrowse
	PARAMTYPE 0 VAR aFils AS ARRAY OPTIONAL DEFAULT {}

	self:aFilial := aFils
	If ValType(self:oBrw:oData) == "O"
		self:oBrw:oData:SetFilial(self:aFilial)
	EndIf

Return()

Method CreateArrTable() Class UBrowse
	self:oBrw:SetDataArray()
	
	If !Empty(self:cAlias)
		self:oBrw:SetAlias(self:cAlias)
	EndIf
	
	If !Empty(self:aColsArr)
		self:oBrw:SetArray(self:aColsArr)
	EndIf
	                        
	If !Empty(self:aSeek)
		self:oBrw:SetSeek(/*bSeek*/,self:aSeek)
	EndIf
	
	self:CreateLegend()
	
	//Cria colunas baseada no aHeader
	self:CreateBrwColumns()
				
Return(self)        

Method CreateSqlTable() Class UBrowse
	//Define DataQuery FWBrowse
	self:oBrw:SetDataQuery()
	//self:oBrw:oData := UBrwQuery():New()
	self:oBrw:oData:SetShowLimit(.F.)

	//Define Alias FWBrowse
	If Empty(self:cAlias)
		self:SetAlias( GetNextAlias() )
	EndIf
	self:oBrw:SetAlias( self:cAlias )

	self:CreateLegend()
	
	//Cria colunas baseada no aHeader
	self:CreateBrwColumns()

	// Carrega as opções de pesquisa		
	self:DSPesqIdx()
	//Define Select
	self:oBrw:SetQuery(self:cSql)

Return(self)        

Method DSPesqIdx() Class UBrowse
	self:oBrw:SetQueryIndex(self:aPesqIdx)
	self:oBrw:SetSeek(Nil, self:aSeek)
Return(self)

Method CreateLegend()Class UBrowse
	Local nI := 1
	
	For nI := 1 To Len(self:aLegend)	
		self:oBrw:AddLegend(self:aLegend[nI, 1], self:aLegend[nI, 2], self:aLegend[nI, 3])
	Next           

	For nI := 1 To Len(self:aStatusColumns)         
		self:oBrw:AddStatusColumns(self:aStatusColumns[nI, 1], self:aStatusColumns[nI, 2])
		
		nPos := Len(self:oBrw:aColumns)
		
		If !Empty(self:aStatusColumns[nI, 1])		
			self:oBrw:aColumns[nPos]:SetTitle(self:aStatusColumns[nI, 3])
		EndIf
		
	Next
	
Return(self)

Method CreateBrwColumns()Class UBrowse
	Local nI
	/*
	Local nI := 1, aAux := {}
	Local aColumns := {}
	
	For nI := 1 To Len(self:aHeader)
		aAux := {}
		
		For nJ := 2 To Len(self:aHeader[nI])
			aAdd(aAux, self:aHeader[nI, nJ])
		Next 
		
		aAdd(aColumns, aAux)
	Next
	*/
	For nI := 1 To Len(self:aColumns)	
		self:oBrw:SetColumns({self:aColumns[nI]})
	Next
Return(self)

Method AddFieldFilter(cField, cTitulo, cTipo, nTamanho, nDecimal) Class UBrowse
	If aScan(self:aFieldFilter, { |aVet| AllTrim(aVet[1]) ==  AllTrim(cField) } ) == 0
		aAdd(self:aFieldFilter, {}) 
		
		aAdd(aTail(self:aFieldFilter), AllTrim(cField))
		aAdd(aTail(self:aFieldFilter), AllTrim(cTitulo))
		aAdd(aTail(self:aFieldFilter), cTipo)
		aAdd(aTail(self:aFieldFilter), nTamanho)
		aAdd(aTail(self:aFieldFilter), nDecimal)
		aAdd(aTail(self:aFieldFilter), Nil)
	EndIf
Return(Self)

Method AddSX3Filter(cFieldSX3) Class UBrowse
	Local aArea   := GetArea()
	Local aAreaX3 := SX3->(GetArea())
	
	If aScan(self:aFieldFilter, { |aVet| AllTrim(aVet[1]) ==  AllTrim(SX3->X3_CAMPO) } ) == 0
		DbSelectArea("SX3")
		DbSetOrder(2)
		If SX3->(DbSeek(cFieldSX3))
			aAdd(self:aFieldFilter, {}) 
			
			aAdd(aTail(self:aFieldFilter), AllTrim(SX3->X3_CAMPO))
			aAdd(aTail(self:aFieldFilter), AllTrim(SX3->X3_TITULO))
			aAdd(aTail(self:aFieldFilter), SX3->X3_TIPO)
			aAdd(aTail(self:aFieldFilter), SX3->X3_TAMANHO)
			aAdd(aTail(self:aFieldFilter), SX3->X3_DECIMAL)
			aAdd(aTail(self:aFieldFilter), Nil)		
		EndIf
	EndIf
	
	RestArea(aAreaX3)
	RestArea(aArea)
Return(Self)

Method OnStartFilter() Class UBrowse
	Local nI
	Local aFields    := self:oBrw:oData:GetFieldFilter()
	Local aSx3Filter := {}
	
	CursorWait()
	If Empty(aFields)
		self:oBrw:oFWFilter:SetField(self:aFieldFilter)
	EndIf
	CursorArrow()
Return(Nil)

Method SetTitle(cTitle) Class UBrowse 	
	Local oWnd := Nil                 
	
	Default cTitle := "" //PARAMTYPE 0 VAR cTitle AS String OPTIONAL DEFAULT ""
		
	self:cTitle := cTitle 

	TRYEXCEPTION
		self:oLayer:SetWinTitle('MAINCOL', 'C01W01', self:cTitle, 'MAIN')
	//CATCHEXCEPTION USING oException
	ENDEXCEPTION	
Return(Self)

Method LoadButtons() Class UBrowse 
	Local uMenuDef := &("STATICCALL("+StrTran(self:cMenuDef,"#","")+",MenuDef)")
	Local nI := 1
	
	If ValType(uMenuDef) == "A"
		For nI := 1 To Len(uMenuDef)
			//-------------------------------------------------------------------
			// Título
			// Função
			// Opção da Rotina
			// Validação (VerSenha)
			// Inclusão
			//-------------------------------------------------------------------
			self:AddButton(uMenuDef[nI,1],uMenuDef[nI,2],uMenuDef[nI,3],uMenuDef[nI,4],If(Len(uMenuDef[nI])>4,uMenuDef[nI][5],),If(Len(uMenuDef[nI])>6,uMenuDef[nI][7],))
	        
			/*
			If ::nExecuteDef == Nil
				If "VISUAL" $ Upper(uMenuDef[nI,1]) .Or. "CONSULTA" $ Upper(uMenuDef[nI,1]) .Or. "VIEW" $ Upper(uMenuDef[nI,1])
					::SetDoubleClick(::GetButton(nI)[2])
					::nExecuteDef := nI
				EndIf
			Else
				If ::nExecuteDef == nI
					::SetDoubleClick(::GetButton(nI)[2])
				EndIf
			EndIf
			*/
		Next nI
	EndIf

Return(Self)

METHOD AddButton(cTitle, xAction, uParam1, nOption, nVerify, lNeedFind) CLASS UBrowse
	Local nI
	Local nPos
	Local cRotina
	Local bAction
	Local oSelf := Self
	Local cRealTitle := cTitle 

	//PARAMTYPE 0 VAR cTitle    AS CHARACTER
	//PARAMTYPE 1 VAR xAction   AS BLOCK, CHARACTER, ARRAY OPTIONAL DEFAULT { || .T. }
	//PARAMTYPE 2 VAR uParam1   AS NUMERIC OPTIONAL DEFAULT 0
	//PARAMTYPE 3 VAR nOption   AS NUMERIC OPTIONAL DEFAULT 0
	//PARAMTYPE 4 VAR nVerify   AS NUMERIC OPTIONAL DEFAULT 0
	//PARAMTYPE 5 VAR lNeedFind AS LOGICAL OPTIONAL DEFAULT .T.

	DEFAULT xAction := { || .T. }
	DEFAULT uParam1 := 0
	DEFAULT nOption := 0
	DEFAULT nVerify := 0
	DEFAULT lNeedFind := .T.

	//-------------------------------------------------------------------
	// Não permite adicionar botão com o mesmo nome
	//-------------------------------------------------------------------
	If Ascan(self:aButtons, { |x| Trim(x[7]) == Trim(cRealTitle) }) == 0
		If !("&" $ cTitle)
			cRotina :=""
			For nI := 1 To Len(cTitle)
				If IsUpper(SubStr(cTitle,nI,1))
					cRotina += "&"+Subs(cTitle,nI)
					Exit
				Else
					cRotina += SubStr(cTitle,nI,1)
				EndIf
			Next nI
		Else
			cRotina := cTitle
		EndIf
			
		//-------------------------------------------------------------------
		// Verifica se o atalho já foi utilizado por outro botão
		//-------------------------------------------------------------------
		If (nPos := At("&",cRotina)) > 0 .And. Lower(Subs(cRotina,nPos+1,1)) $ self:cCapital
			cRotina := StrTran(cRotina,"&","")
			For nI:= 1 To Len(cRotina)
				If !(Lower(SubStr(cRotina,nI,1)) $ self:cCapital)
					cRotina := SubStr(cRotina,1,nI-1)+"&"+Upper(Subs(cRotina,nI,1))+Subs(cRotina,nI+1)
					self:cCapital += Lower(Subs(cRotina,nI+1,1))
					Exit
				EndIf
			Next nI 
		ElseIf nPos > 0
			self:cCapital += Lower(SubStr(cRotina,nPos+1,1))
		EndIf
		
		cTitle := ButCapital(cRotina)
		
		//-------------------------------------------------------------------
		// Tratamento para chamada de função ou SubMenu
		//-------------------------------------------------------------------
		If ValType(xAction) == "C"
			bAction := &('{ || Self:Execute("'+xAction+'",'+Str(nOption)+','+Str(nVerify)+',"'+StrTran(cTitle,'&','')+'" ) }')
		Else
			bAction := xAction
		EndIf
		
		Aadd( self:aButtons, { cTitle, bAction, uParam1, nOption, nVerify, lNeedFind, cRealTitle } )
	EndIf
Return(Self)              

Method SetExitWnd(bBlock) Class UBrowse
	self:lForceQuit := .T.             
	self:bExitWnd := bBlock
Return(self)
	
Method CreateButtons() Class UBrowse
	Local oPnlBottom := self:oPnlButton
	Local nButton := 1
	Local nNumPnl := Int((oPnlBottom:nClientWidth - 120) / 120)  
	Local oMenu := nil
	Local nRot1
	Local nRot

	If (self:oOwner:ClassName() $ "TWINDOW|MSDIALOG|TDIALOG") .Or. self:lForceQuit
		oBtn	:=	TButton():New( 000, 000, 'Sair', oPnlBottom, self:bExitWnd , 050, 010, , , , .T., , , , {|| }, , )
		oBtn:SetCss( GetCss( 'TBTNDANGER' ) )
		oBtn:Align	:=	CONTROL_ALIGN_RIGHT
		oBtn:lCanGotFocus := .F.
	EndIf

	For nButton := 1 To Min(Len(self:aButtons), nNumPnl)     
		cTitle     := self:aButtons[nButton, 1]
		bAction    := self:aButtons[nButton, 2]
		uParam1    := self:aButtons[nButton, 3] 
		nOption    := self:aButtons[nButton, 4]
		nVerify    := self:aButtons[nButton, 5] 
		lNeedFind  := self:aButtons[nButton, 6] 
		cRealTitle := self:aButtons[nButton, 7]
		
		If ValType(bAction) == "A"
			// Cria Menu    
			oMenu01 := tMenu():new(0, 0, 0, 0, .T., , oMenu)
			
			For nRot1 := 1 To Len(bAction)
				cTit := bAction[nRot1,1]
				xAct := bAction[nRot1,2]
				nOpt := bAction[nRot1,4]
				nVer := IIF(Len(bAction[nRot1]) > 4, bAction[nRot1,5], 0)
				
				bAct := &('{ || Self:Execute("'+xAct+'",'+Str(nOpt)+','+Str(nVer)+',"'+StrTran(cTit,'&','')+'" ) }')
				
				oMenu0101 := tMenuItem():new(oMenu01, cTit, , , , bAct, , , , , , , , , .T.)
				oMenu01:add(oMenu0101)
			Next
			
			oBtn :=	TButton():New( 000, 000, cTitle, oPnlBottom, { || }, 050, 010, , , , .T., , , , {|| }, , )
			oBtn:SetCss( GetCss( 'TBTNPRIMARY' ) )
			oBtn:Align	:=	CONTROL_ALIGN_LEFT
			oBtn:lCanGotFocus := .F.
			oBtn:SetPopupMenu(oMenu01)
		Else
			oBtn := TButton():New( 000, 000, cTitle, oPnlBottom, bAction, 050, 010, , , , .T., , , , {|| }, , )
			oBtn:SetCss( GetCss( 'TBTNPRIMARY' ) )
	  		oBtn:Align	:=	CONTROL_ALIGN_LEFT
	  		oBtn:lCanGotFocus := .F.
		EndIf
	Next
	
	If Len(self:aButtons) > nNumPnl
		oMenu01 := tMenu():new(0, 0, 0, 0, .T., , oMenu)
		
		For nButton := nNumPnl + 1 To Len(self:aButtons)
			cTitle     := self:aButtons[nButton, 1]
			bAction    := self:aButtons[nButton, 2]
			uParam1    := self:aButtons[nButton, 3] 
			nOption    := self:aButtons[nButton, 4]
			nVerify    := self:aButtons[nButton, 5] 
			lNeedFind  := self:aButtons[nButton, 6] 
			cRealTitle := self:aButtons[nButton, 7]
			
				
			If ValType(bAction) == "A"			
				oMenu0101 := tMenuItem():new(oMenu01, cTitle, , , , {|| }, , , , , , , , , .T.)	
				oMenu01:add(oMenu0101)
					
				For nRot := 1 To Len(bAction)				
					cTit := bAction[nRot,1]
					xAct := bAction[nRot,2]
					nOpt := bAction[nRot,4]
					nVer := IIF(Len(bAction[nRot]) > 4, bAction[nRot,5], 0)
				
					bAct := &('{ || Self:Execute("'+xAct+'",'+Str(nOpt)+','+Str(nVer)+',"'+StrTran(cTit,'&','')+'" ) }')
				
					oSubMenu := tMenuItem():new(oMenu0101, cTit, , , , bAct, , , , , , , , , .T.)	
					// adiciona o subitem do submenu		
					oMenu0101:add(oSubMenu)
				Next
			Else
				oMenu0101 := TMenuItem():New(oMenu01, cTitle,,,,bAction,,,,,,,,,.T.)
				oMenu01:Add(oMenu0101)
			EndIf			
		Next
			
		oBtn	:=	TButton():New( 000, 000, "Ações Relacionadas", oPnlBottom, { || }, 65, 010, , , , .T., , , , {|| }, , )
		oBtn:SetCss( GetCss( 'TBTNDEFAULT' ) )
		oBtn:Align	:=	CONTROL_ALIGN_LEFT
		
		// Define botão no Menu
		oBtn:SetPopupMenu(oMenu01)
	EndIf	
Return(Nil)

Method GetOwner() Class UBrowse
	If self:oOwner == Nil
		self:CreateOwner()
	EndIf
Return(self:oOwner)

Method CreateOwner() Class UBrowse                                       
	Local aSize := MsAdvSize()
	self:lNeedActivate := .T.
	Define MsDialog self:oOwner TITLE '' From aSize[1], aSize[2] TO aSize[6], aSize[5] STYLE nOr(WS_VISIBLE,WS_POPUP) Of oMainWnd Pixel
Return(self)

Method SetAlias(cAlias) Class UBrowse
	self:cAlias := cAlias
Return(Self)

Method LoadDicCol() Class UBrowse	
	Local aArea   := GetArea()
	Local aAreaX3 := SX3->(GetArea())

	If self:lSeeAll .And. !Empty(xFilial(self:cAlias))
		self:AddColSx3(PrefixoCpo(self:cAlias) + "_FILIAL")
	EndIf
	
	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	SX3->(DbSeek( self:cAlias ))	

	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == self:cAlias		
		If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .and. SX3->X3_BROWSE == "S"
			self:AddColSx3(SX3->X3_CAMPO)
		EndIf
		
		SX3->(DbSkip())
	EndDo

	RestArea(aAreaX3)
	RestArea(aArea)
Return(Self)
           
Method Execute(cFunction,nOption,nVerify,cTitle) CLASS UBrowse
	Local oCursor
	Local oFWMVCWindow
	Local oModel
	Local oReport
	Local oSelf := Self
	Local oView
	Local xRet
	Local cProgram  := ""
	Local nOldRec   := 0
	Local nPos      := 0
	Local lDelete   := .F.
	Local lProcess  := .T.
	Local aCoors    := {}
	Local aClassify := {}
	
	Private INCLUI := nOption == 3
	Private ALTERA := nOption == 4
	Private EXCLUI := nOption == 5
	
	//PARAMTYPE 0 VAR oBrowse   AS OBJECT
	PARAMTYPE 0 VAR cFunction AS CHARACTER
	PARAMTYPE 1 VAR nOption   AS NUMERIC
	PARAMTYPE 2 VAR nVerify   AS NUMERIC OPTIONAL DEFAULT 0
	PARAMTYPE 3 VAR cTitle    AS CHARACTER OPTIONAL DEFAULT ""
	
	//-------------------------------------------------------------------
	// Desabilita os Detalhes para a execução da função
	//-------------------------------------------------------------------
	//If ValType(::oPanelDetails) == "O"
	//	::oPanelDetails:Disable()
	//EndIf
	//-------------------------------------------------------------------
	// Verifica se a execução esta sendo realizado pelo Browse
	//-------------------------------------------------------------------
	//If !::lNoBrowse
	//	::oPanelOptions:Disable()
	//	::oPanelBrowse:Disable()
	//EndIf
	//-------------------------------------------------------------------
	// Efetua a alteração dos alias que utilizam JOIN na tabela
	//-------------------------------------------------------------------
	oSelf:oBrw:SaveArea()
	
	lProcess := oSelf:BeforeOption(cFunction,nOption,nVerify)
	
	If lProcess
		//-------------------------------------------------------------------
		// Select com menos campo no TOP
		//-------------------------------------------------------------------
		SetSrvMap(oSelf:oBrw:Alias())
		//-------------------------------------------------------------------
		// Desabilita a tecla F12
		//-------------------------------------------------------------------
		//Set Key VK_F12 To
		//-------------------------------------------------------------------
		// Executa a ação do botão
		//-------------------------------------------------------------------
		/*
		If Upper(Subs(cFunction,1,7)) == "VIEWDEF"
			//-------------------------------------------------------------------
			// Verifica se o View já foi carregado anteriormente
			//-------------------------------------------------------------------
			If (nPos := At(".",cFunction)) > 0
				cProgram := SubStr(cFunction,nPos+1)
				If (nPos := Ascan( ::aViews, { |x| x[1] == cProgram } )) > 0
					oView := ::aViews[nPos,2]
				EndIf
			EndIf
			//-------------------------------------------------------------------
			// Verifica se é impressão do Modelo
			//-------------------------------------------------------------------
			If nOption == 8
				oModel := FWLoadModel(cProgram)
				oModel:Activate()
				oReport := oModel:ReportDef()
				oReport:PrintDialog()
				oModel:DeActivate()
			Else
				//-------------------------------------------------------------------
				// Verifica se é Manutenção nos registros
				//-------------------------------------------------------------------
				If ValType(oView) <> "O"
					Aadd( ::aViews, { cProgram, FWLoadView(cFunction) } )
					oView := ::aViews[Len(::aViews),2]
				Endif
				//-------------------------------------------------------------------
				// Busca o objeto de controle da View e atualiza suas propriedades
				//-------------------------------------------------------------------
				If ValType(oView) == "O"  
					oView:SetOperation(If(nOption==2,MODEL_OPERATION_VIEW,nOption))				
					//-------------------------------------------------------------------
					// Monta o DLG para o View
					//-------------------------------------------------------------------
					aCoors := FWGetDialogSize(::_oOwner)
					oFWMVCWindow := FWMVCWindow():New()
					oFWMVCWindow:setView(oView)
					oFWMVCWindow:setPos(aCoors[1],aCoors[2])
					oFWMVCWindow:setSize(aCoors[3],aCoors[4])
					oFWMVCWindow:SetBrowse(Self,.T.)
					oFWMVCWindow:SetTitle(cTitle)	
					oFWMVCWindow:Show()	  
					oView:ClearPanel()
					oView:DeActivate()			
				EndIf
			EndIf
		Else
		*/		
			DbSelectArea(oSelf:oBrw:Alias())
			nOldRec := Recno()

			Self:DefFilial(.T.)
						
			If !("("$cFunction)
				xRet := &cFunction.(Alias(),RecNo(),nOption,/*aEncho*/)
			Else
				xRet := &cFunction
			EndIf
		
		//EndIf
		//-------------------------------------------------------------------
		// Habilita a tecla F12
		//-------------------------------------------------------------------
		//If ValType(::bParam) == "B"
		//	SetKey(VK_F12,::bParam)
		//EndIf
		//-------------------------------------------------------------------		
		// Select com menos campo no TOP
		//-------------------------------------------------------------------
		SetSrvMap(oSelf:oBrw:Alias(),oSelf:oBrw:MapField())
		//-------------------------------------------------------------------
		// Restaura a posição do registro inicial
		//-------------------------------------------------------------------
		DbSelectArea(oSelf:oBrw:Alias())
		If Eof()
			DbGoTo(nOldRec)
		EndIf
		//-------------------------------------------------------------------
		// Aplica a classificação customizada
		//-------------------------------------------------------------------
		If !Empty(oSelf:oBrw:aClassify)
			aEval(oSelf:oBrw:aClassify, { |x| Aadd( aClassify, LTrim(Str(x)) ) } )
			oSelf:oBrw:SetClassifyColumn(aClassify)
		EndIf
		//-------------------------------------------------------------------
		// Tratamento para exclusão de registros
		//-------------------------------------------------------------------
		If nOption == 5
			lDelete := Set(11,"OFF")   // Set Dele OFF
			If Deleted() .And. lDelete
				SET DELETE ON
				DbSkip()
				If Eof()
					DbGoBottom()
				EndIf
			ElseIf !Deleted() .And. lDelete
				SET DELETE ON
			EndIf
		EndIf
		//-------------------------------------------------------------------
		// Atualização do controle de Top/Bottom de Browse
		//-------------------------------------------------------------------
		If nOption <> 2 .And. nOption <> 8
			oSelf:oBrw:UpdateTopBot(.F.)
		EndIf
		//-------------------------------------------------------------------
		// Permite o tratamento após a execução
		//-------------------------------------------------------------------
		self:AfterOption(cFunction,nOption,nVerify)
		
		//-------------------------------------------------------------------
		// Atualiza os registros do Browse
		//-------------------------------------------------------------------
		oSelf:oBrw:GoTo(Recno())	
		//-------------------------------------------------------------------
		// Atualização dos detalhes
		//-------------------------------------------------------------------
		//::UpdateDetails()
	EndIf
	
	//-------------------------------------------------------------------
	// Restaura a alteração dos alias que utilizam JOIN na tabela
	//-------------------------------------------------------------------
	oSelf:oBrw:RestoreArea()
	
	//-------------------------------------------------------------------
	// Habilita os Detalhes para a execução da função
	//-------------------------------------------------------------------
	//If ValType(::oPanelDetails) == "O"
	//	::oPanelDetails:Enable()
	//EndIf
	
	//-------------------------------------------------------------------
	// Verifica se a execução esta sendo realizado pelo Browse
	//-------------------------------------------------------------------
	//If !::lNoBrowse
	//	::oPanelOptions:Enable()
	//	::oPanelBrowse:Enable()
		//-------------------------------------------------------------------
		// Posiciona o foco no Browse
		//-------------------------------------------------------------------	
		oSelf:oBrw:SetFocus(.T.)
	//EndIf
	
Return(Nil) 

METHOD AfterOption(cFunction,nOption,nVerify) CLASS UBrowse
Local lRet := .T.

If ValType(self:bAfterExec) == "B"
	//-------------------------------------------------------------------
	// Efetua a alteração dos alias que utilizam JOIN na tabela
	//-------------------------------------------------------------------
	Self:oBrw:SaveArea()
	//-------------------------------------------------------------------
	// Executa o Code-Block para tratamentos antes da execução
	//-------------------------------------------------------------------
	lRet := Eval(self:bAfterExec,cFunction,nOption,nVerify)
	//-------------------------------------------------------------------
	// Restaura a alteração dos alias que utilizam JOIN na tabela
	//-------------------------------------------------------------------
	Self:oBrw:RestoreArea()
	Self:oTimer:Activate()
EndIf

Return lRet

METHOD BeforeOption(cFunction,nOption,nVerify) CLASS UBrowse
Local lRet := .T.

If ValType(self:bBeforeExec) == "B"
	//-------------------------------------------------------------------
	// Efetua a alteração dos alias que utilizam JOIN na tabela
	//-------------------------------------------------------------------
	Self:oBrw:SaveArea()  
	//-------------------------------------------------------------------
	// Executa o Code-Block para tratamentos antes da execução
	//-------------------------------------------------------------------
	lRet := Eval(self:bBeforeExec,cFunction,nOption,nVerify)
	//-------------------------------------------------------------------
	// Restaura a alteração dos alias que utilizam JOIN na tabela
	//-------------------------------------------------------------------
	Self:oBrw:RestoreArea()
	Self:oTimer:DeActivate()
EndIf

Return lRet 

METHOD SetAfterExec(bAfterExec) CLASS UBrowse
PARAMTYPE 0 VAR bAfterExec AS BLOCK

::bAfterExec := bAfterExec

Return

METHOD SetBeforeExec(bBeforeExec) CLASS UBrowse
PARAMTYPE 0 VAR bBeforeExec AS BLOCK

::bBeforeExec := bBeforeExec

Return

Method AddColSx3(cFieldSX3, cTitulo, cCampo, cPicture, nTamanho, nDecimal, nAlign) Class UBrowse
	Local aArea   := GetArea()
	Local aAreaX3 := SX3->(GetArea())
	Local oConf := THash():New()
	Local bData := Nil
	
	cCampo := IIF(cCampo <> Nil, cCampo, cFieldSX3)
	
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	
	If !SX3->( DbSeek(cFieldSX3) )
		Return(self)
	EndIf

	If SX3->X3_CONTEXT == 'V'
		bData := "{ || " + AllTrim(SX3->X3_INIBRW) + " }"						
	ElseIf SX3->X3_TIPO == "D" 
		If u_Exists({{"T", self:cAlias}})
			bData := "{ || DtoC(" + cCampo + ")}"
		Else
			bData := "{ || DtoC(StoD(" + cCampo + ")) }"			
		EndIf
	Else
		bData := "{ || " + cCampo + " } "
	EndIf
	
	If cTitulo == Nil
		cTitulo := Alltrim(SX3->( X3Titulo() ))
	EndIf
	
	If cPicture == Nil
		cPicture := Alltrim(SX3->( X3_PICTURE ))
	EndIf
			
	If nTamanho == Nil
		nTamanho := SX3->( X3_TAMANHO )
	EndIf

	If nDecimal == Nil
		nDecimal := SX3->( X3_DECIMAL )
	EndIf
	
	If nAlign == Nil
		If SX3->X3_TIPO == "N"
			nAlign := 2
		EndIf
	EndIf
	
	oConf:Put("cField"  , cFieldSX3)		
	oConf:Put("cTitle"  , cTitulo)
	oConf:Put("bData"   , &bData )
	oConf:Put("cType"   , SX3->X3_TIPO)
	oConf:Put("xPicture", cPicture)
	oConf:Put("nAlign"  , nAlign)
	oConf:Put("nSize"   , nTamanho)
	oConf:Put("nDecimal", nDecimal)
	//oConf:Put("nForeColor")
	//oConf:Put("cComment")
	//oConf:Put("bLDblClick")
	//oConf:Put("bHeaderClick")
	//oConf:Put("lDelete")
	//oConf:Put("lDetails")
	//oConf:Put("lEdit")
	//oConf:Put("lImage")
	//oConf:Put("cReadVar")
	//oConf:Put("bValid")
	//oConf:Put("aOptions")
	//oConf:Put("nOrder")	
	
	self:AddColumn(oConf)
	RestArea(aAreaX3)
	RestArea(aArea)
Return(Self)

Method AddColumn(oConf, lFilterField) Class UBrowse
/*
oConf:GetObj("bData")
oConf:GetObj("cTitle")
oConf:GetObj("cType")
oConf:GetObj("nSize")
oConf:GetObj("nDecimal")
oConf:GetObj("xPicture")
oConf:GetObj("nForeColor")
oConf:GetObj("cComment")
oConf:GetObj("bLDblClick")
oConf:GetObj("bHeaderClick")
oConf:GetObj("lDelete")
oConf:GetObj("lDetails")
oConf:GetObj("lEdit")
oConf:GetObj("lImage")
oConf:GetObj("cReadVar")
oConf:GetObj("bValid")
oConf:GetObj("aOptions")
oConf:GetObj("nOrder")
*/
	Local oFWBrwColumn := FWBrwColumn():New()
	Local aProp := {"cField", "cTitle", "bData", "cType", "xPicture", "nAlign", "nSize", "nDecimal", "lImage"}
	Local nFatSize := 1.15
	Local nI
	
	Default lFilterField := .T.
		
	If ValType(oConf) == "A"
		/* Padrão aHeader
			[01] Campo
			[02] Título da coluna
			[03] Code-Block de carga dos dados		
			[04] Tipo de dados
			[05] Máscara
			[06] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
			[07] Tamanho
			[08] Decimal	
			[09] Image	
		*/
	
		aAux := aClone(oConf)
		oConf := THash():New()
		
		For nI := 1 To Len(aProp)        
			If nI <= Len(aAux)
				oConf:Put(aProp[nI], aAux[nI])
			Else
				oConf:Put(aProp[nI], Nil)			
			EndIf
		Next
	EndIf
		
	If self:aHeader == Nil
		self:aHeader := {}
	EndIf
			
	If( ValType(oConf:GetObj("nAlign")) == "N" )
		oFWBrwColumn:SetAlign(oConf:GetObj("nAlign"))
	EndIf
	
	If( ValType(oConf:GetObj("nBackColor")) == "N" )
		oFWBrwColumn:SetBackColor(oConf:GetObj("nBackColor"))
	EndIf		
	If( ValType(oConf:GetObj("cComment")) == "C" )
		oFWBrwColumn:SetComment(oConf:GetObj("cComment"))
	EndIf
	If( ValType(oConf:GetObj("bData")) == "B" )
		oFWBrwColumn:SetData(oConf:GetObj("bData"))
	EndIf
	If( ValType(oConf:GetObj("nDecimal")) == "N" )
		oFWBrwColumn:SetDecimal(oConf:GetObj("nDecimal"))
	EndIf		
	
	If oConf:GetObj("lDelete") <> Nil .And. oConf:GetObj("lDelete")
		oFWBrwColumn:SetDelete(oConf:GetObj("lDelete"))
	EndIf
	
	If oConf:GetObj("lDetails") <> Nil .And. oConf:GetObj("lDetails")
		oFWBrwColumn:SetDetails(oConf:GetObj("lDetails"))
	EndIf
	
	If( ValType(oConf:GetObj("bLDblClick")) == "B" )
		oFWBrwColumn:SetDoubleClick(oConf:GetObj("bLDblClick"))
	EndIf
	
	If oConf:GetObj("lEdit") <> Nil .And. oConf:GetObj("lEdit")
		oFWBrwColumn:SetEdit(oConf:GetObj("lEdit"))
	EndIf
	If( ValType(oConf:GetObj("nForeColor")) == "N" )
		oFWBrwColumn:SetForeColor(oConf:GetObj("nForeColor"))
	EndIf		
	If( ValType(oConf:GetObj("bHeaderClick")) == "B" )
		oFWBrwColumn:SetHeaderClick(oConf:GetObj("bHeaderClick"))
	EndIf
	oFWBrwColumn:SetOptions(oConf:GetObj("aOptions"))
	If( ValType(oConf:GetObj("nOrder")) == "N" )
		oFWBrwColumn:SetOrder(oConf:GetObj("nOrder"))
	EndIf		
	If( ValType(oConf:GetObj("xPicture")) == "C")
		oFWBrwColumn:SetPicture(oConf:GetObj("xPicture"))
		nFatSize := 1.3
	ElseIf( ValType(oConf:GetObj("xPicture")) == "B")
		oFWBrwColumn:SetPicture(oConf:GetObj("xPicture"))
		nFatSize := 1.3
	EndIf
	If( ValType(oConf:GetObj("cReadVar")) == "C" )
		oFWBrwColumn:SetReadVar(oConf:GetObj("cReadVar"))
	EndIf
	If( ValType(oConf:GetObj("nSize")) == "N" )       
	
		oFWBrwColumn:SetSize(oConf:GetObj("nSize") * nFatSize)
	EndIf		                                                 

	If( ValType(oConf:GetObj("cType")) == "C" )
		oFWBrwColumn:SetType(oConf:GetObj("cType"))
	EndIf

	If( ValType(oConf:GetObj("bValid")) == "B" )
		oFWBrwColumn:SetValid(oConf:GetObj("bValid"))
	EndIf

	If( ValType(oConf:GetObj("cTitle")) == "C" )
		oFWBrwColumn:SetTitle(oConf:GetObj("cTitle"))
	Else
		oFWBrwColumn:SetTitle("  ")
	EndIf
		
	If oConf:GetObj("lImage") <> Nil .And. oConf:GetObj("lImage")		
		
		oFWBrwColumn := FWBrwColumn():New()
		
		oFWBrwColumn:SetTitle("")
		oFWBrwColumn:SetData(oConf:GetObj("bData"))
		oFWBrwColumn:SetType("C")
		oFWBrwColumn:SetDoubleClick(oConf:GetObj("bLDblClick"))
		oFWBrwColumn:SetAlign("CENTER")
		oFWBrwColumn:SetSize(1)
		oFWBrwColumn:SetDecimal(0)
		oFWBrwColumn:SetImage(.T.)
		oFWBrwColumn:SetDetails(.F.)
		oFWBrwColumn:SetOrder(1)
		oFWBrwColumn:SetOrderDefault(1)		
		lFilterField := .F.	
	EndIf
		
	aAdd(self:aHeader, {oConf:GetObj("cField"), oConf:GetObj("cType"), oConf:GetObj("nSize"), oConf:GetObj("nDecimal"), oConf:GetObj("xPicture")})

	If lFilterField                                                                  
		self:AddFieldFilter(oConf:GetObj("cField"), oConf:GetObj("cTitle"), oConf:GetObj("cType"), oConf:GetObj("nSize"), oConf:GetObj("nDecimal"))
	EndIf
	
	self:nUsado++
	
	aAdd(self:aColumns, oFWBrwColumn)
Return(self)

Static Function ButCapital(cText)
	Local nI
	
	cText := Lower(cText)
	
	For nI:= 1 To Len(cText)
		If Subs(cText,nI,1) <> "&"
			cText := Subs(cText,1,nI-1)+Upper(Subs(cText,nI,1))+Subs(cText,nI+1)
			Exit
		EndIf
	Next nI
	
Return cText

Static Function GetCss(cClass)
	Local cCss := ""
	
	Do Case
		Case	Upper( cClass ) == 'TBUTCLOSE'
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:			11px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
    		cCSS += 'QPushButton			{ border-radius:		3px             ; }'
    		cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #F6F7FA, stop: 1 #DADBDE ); }'
    		cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				3px 10px 9px 0px; }'
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #DADBDE, stop: 1 #F6F7FA ); }'
			cCSS += 'QPushButton			{ font:				bold            ; }'
			cCSS += 'QPushButton			{ margin:				5px 5px 5px 5px ; }'
			
		/***** Definimos o CSS do Botao Confirmar da barra deMenu *****/
		Case	Upper( cClass ) == 'TBUTCONFIRM'
			
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:			10px            ; }'
			cCSS += 'QPushButton			{ font:				bold            ; }'
			cCSS += 'QPushButton			{ background-color:	qlineargradient(spread:pad, x1:0.494591, y1:0, x2:0.528, y2:1, stop:0.0852273 rgba(255, 214, 94, 255), stop:0.295455 rgba(254, 191, 4, 255)); }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
    		cCSS += 'QPushButton			{ border-radius:		3px             ; }'
			cCSS += 'QPushButton			{ color:				#000000         ; }'
			cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				3px 10px 9px 0px; }'
			cCSS += 'QPushButton:pressed	{ background-color: qlineargradient(spread:pad, x1:0.494591, y1:0, x2:0.528, y2:1, stop:0.619318 rgba(254, 191, 4, 255), stop:0.892045 rgba(255, 214, 94, 255)); }'
			
		/***** Definimos o CSS do Botao Confirmar da barra deMenu *****/
		Case	Upper( cClass ) == 'TBUTMAIS'
			
			cCSS := 'QPushButton        { font-family: Verdana  ; }'
			cCSS += 'QPushButton        { font:        bold     ; }'
			cCSS += 'QPushButton        { border:      none     ; }' 
			cCSS += 'QPushButton        { font-size:   10px     ; }'
			cCSS += 'QPushButton:hover  { color:       #2A80B9  ; }'
			cCSS += 'QPushButton:pressed{ color:       #FFFFFF  ; }' 
			
		/***** Definimos o CSS dos objetos da Classe TBUTTON *****/
		Case	Upper( cClass ) == 'TBUTTON'
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		10px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
    		cCSS += 'QPushButton			{ border-radius:	3px             ; }'
    		cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #D4DFFF, stop: 1 #A2B1DB ); }'
    		cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				3px 5px 4px 0px; }'
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #A2B1DB, stop: 1 #D4DFFF ); }'
		Case	Upper( cClass ) == 'TBTNPRIMARY'
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		09px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
    		cCSS += 'QPushButton			{ border-radius:	3px             ; }'
    		cCSS += 'QPushButton			{ color:	#FFFFFF             ; }'    		
    		cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #92B5D4, stop: 1 #3071A9 ); }'
    		cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				3px 5px 4px 0px; }'
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #3071A9, stop: 1 #92B5D4 ); }'			

		Case	Upper( cClass ) == 'TBTNDANGER'
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		09px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
    		cCSS += 'QPushButton			{ border-radius:	3px             ; }'
    		cCSS += 'QPushButton			{ color:	#FFFFFF             ; }'    
    		cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #E37B78, stop: 1 #C9302C ); }'
    		cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				3px 5px 4px 0px; }'
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #C9302C, stop: 1 #E37B78 ); }'						

		Case	Upper( cClass ) == 'TBTNSUCCESS'
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		09px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
    		cCSS += 'QPushButton			{ border-radius:	3px             ; }'
    		cCSS += 'QPushButton			{ color:	#FFFFFF             ; }'                                  
    		cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #8BC98B, stop: 1 #449D44 ); }'
    		cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				3px 5px 4px 0px; }'
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #449D44, stop: 1 #8BC98B ); }'						

		Case	Upper( cClass ) == 'TBTNDEFAULT'
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		09px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
    		cCSS += 'QPushButton			{ border-radius:	3px             ; }'
    		cCSS += 'QPushButton			{ color:	#000000             ; }'    
    		cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #FFFFFF, stop: 1 #F0F0F0 ); }'
    		cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				3px 5px 4px 0px; }'
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #F0F0F0, stop: 1 #FFFFFF ); }'						

		Case	Upper( cClass ) == 'TBTNINFO'
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		09px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
    		cCSS += 'QPushButton			{ border-radius:	3px             ; }'
    		cCSS += 'QPushButton			{ color:	#FFFFFF             ; }'        		                                                                                                                  
    		cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #9ECFDE, stop: 1 #5bc0de ); }'
    		cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				3px 5px 4px 0px; }'
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #5bc0de, stop: 1 #9ECFDE ); }'						
		Case	Upper( cClass ) == 'TBTNWARNING'
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		09px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
    		cCSS += 'QPushButton			{ border-radius:	3px             ; }'
    		cCSS += 'QPushButton			{ color:	#FFFFFF             ; }'        		                                                                                                                  
    		cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #EDC893, stop: 1 #F0AD4E ); }'
    		cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				3px 5px 4px 0px; }'
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #F0AD4E, stop: 1 #EDC893 ); }'						
	EndCase
Return(cCss)