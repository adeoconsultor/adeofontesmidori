#Include 'Protheus.ch'

//=================================================================================================================
// MidAcArm -                                   Alessandro Freire                                  - Fev / 2016
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Tela de Correção do armazém informado na Etiqueta
//-----------------------------------------------------------------------------------------------------------------
// Parametros
// nil
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
User Function MIDACARM()
	
	Local nStyle   := GD_INSERT+GD_UPDATE+GD_DELETE
	Local nFreeze  := 1
	Local aLinha   := {}
	Local cLinhaOk := "StaticCall(MIDACARM,LINHAOK)"
	Local cTudoOk  := "StaticCall(MIDACARM,TUDOOK)"
	Local oLayer
	Local oDlg
	Local oPnl
	
	Private oGrid
	
	oDlg:= uAdvPlDlg():New("Correção de Armazém de Etiqueta",.t.,.t.)
	oDlg:AddButton("Corrigir",{|| lOk := TudoOk(),;
		                          if( lOk, Processa( {||Corrigir( oGrid )}, "Atualizando etiquetas..." ),.f.),;
		                          if( lOk, oDlg:Close(), .f. ) })
	
	oLayer:=FWLayer():New()
	oLayer:Init( oDlg:oPnlCenter, .f. )
	oLayer:AddLine( "LINHA1", 100, .f. )
	oLayer:AddColumn("COLUNA1",100, .f., "LINHA1" )
	oLayer:AddWindow("COLUNA1","ETIQUETAS","Informe as etiquetas",100,.f.,.f.,,"LINHA1")
	
	oPnl := oLayer:GetWinPanel("COLUNA1","ETIQUETAS","LINHA1")
	
	AAdd( aLinha,;
		{CriaVar("CB0_CODETI"),;
		CriaVar("CB0_LOCAL") ,;
		CriaVar("CB0_LOCAL") ,;
		CriaVar("CB0_CODPRO"),;
		CriaVar("B1_DESC")   ,;
		CriaVar("CB0_QTDE")  ,;
		CriaVar("CB0_LOTE")  ,;
		CriaVar("CB0_LOCALI"),;
		CriaVar("CB0_STATUS"),;
		.f.} )
	
	oGrid:=MyGrid():New( 0,0,0,0,nStyle, cLinhaOk, cTudoOk,,,,,,,, oPnl )
	
	oGrid:AddColumn( {"Etiqueta"       , "CB0_CODETI" , "@!"             , TamSx3("CB0_CODETI")[1],0,"StaticCall(MIDACARM,VALIDETI)","","C","","R","","","","A","","",""} )
	oGrid:AddColumn( {"Armazém Atual"  , "CB0_LOCAL"  , "@!"             , TamSx3("CB0_LOCAL" )[1],0,""          ,"","C","","R","","","","V","","",""} )
	oGrid:AddColumn( {"Armazém Destino", "LOCDES"     , "@!"             , TamSx3("CB0_LOCAL" )[1],0,"StaticCall(MIDACARM,VALIDLOC)","","C","","R","","","","A","","",""} )
	oGrid:AddColumn( {"Produto"        , "CB0_CODPRO" , "@!"             , TamSx3("CB0_CODPRO")[1],0,""          ,"","C","","R","","","","V","","",""} )
	oGrid:AddColumn( {"Descrição"      , "DESCRICAO"  , "@!"             , TamSx3("B1_DESC"   )[1],0,""          ,"","C","","R","","","","V","","",""} )
	oGrid:AddColumn( {"Quantidade"     , "CB0_QTDE"   , "@E 999,999.9999", 11                     ,4,""          ,"","N","","R","","","","V","","",""} )
	oGrid:AddColumn( {"Lote"           , "CB0_LOTE"   , "@!"             , TamSx3("CB0_LOTE"  )[1],0,""          ,"","C","","R","","","","V","","",""} )
	oGrid:AddColumn( {"Endereço"       , "CB0_LOCALI" , "@!"             , TamSx3("CB0_LOCALI")[1],0,""          ,"","C","","R","","","","V","","",""} )
	oGrid:AddColumn( {"Status"         , "STATUS"     , "@!"             , TamSx3("CB0_STATUS")[1],0,""          ,"","C","","R","","","","A","","",""} )
	oGrid:Load()
	oGrid:SetAlignAllClient()
	oGrid:SetArray( aLinha )
	
	oDlg:oDlg:bInit := {||oGrid:oGrid:GoBottom(),oGrid:oGrid:GoTop()}
	oDlg:Activate()
	
Return( nil )
//=================================================================================================================
// Corrigir -                                   Alessandro Freire                                  - Fev / 2016
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Corrige os armazéns das etiquetas
//-----------------------------------------------------------------------------------------------------------------
// Parametros
// nil
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Static Function Corrigir()

Local nLoop

ProcRegua( Len( oGrid:oGrid:aCols ) )

For nLoop := 1 to Len( oGrid:oGrid:aCols )
	IncProc()
	dbSelectArea("CB0")
	dbSetOrder(1)
	dbSeek(xFilial("CB0")+oGrid:GetField("CB0_CODETI",nLoop))
	RecLock("CB0",.F.)
	CB0->CB0_LOCAL := oGrid:GetField("LOCDES",nLoop)
	CB0->CB0_STATUS := oGrid:GetField("STATUS",nLoop)
	MsUnlock()
Next nLoop

apMsgInfo("As etiquetas foram corrigidas")

Return( nil )
//=================================================================================================================
// ValidLoc -                                   Alessandro Freire                                  - Fev / 2016
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Valida o armazém de destino
//-----------------------------------------------------------------------------------------------------------------
// Parametros
// nil
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Static Function ValidLoc()
	
	If Empty( M->LOCDES )
		apMsgAlert("Informe o armazém destino")
		Return(.f.)
	EndIf
	
	If M->LOCDES == oGrid:GetField("CB0_LOCAL")
		If !MSGYESNO("Alteração de Status ?")
			apMsgAlert("O armazém de destino não pode ser igual ao armazém atual")
			Return(.f.)
		EndIf
	EndIf
	
Return( .t. )
//=================================================================================================================
// ValidEti -                                   Alessandro Freire                                  - Fev / 2016
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Valida a Etiqueta Informada
//-----------------------------------------------------------------------------------------------------------------
// Parametros
// nil
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Static Function ValidEti()
	Local lRet  := .t.
	
	dbSelectArea("CB0")
	dbSetOrder(1)
	If ! dbSeek(xFilial("CB0")+M->CB0_CODETI)
		apMsgAlert("Etiqueta não encontrada.")
		Return(.f.)
	EndIf
	
	If CB0->CB0_TIPO <> "01"
		apMsgAlert("Esta não é uma etiqueta de produto")
		Return(.f.)
	EndIf
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+CB0->CB0_CODPRO)
	
	oGrid:SetField("CB0_LOCAL",CB0->CB0_LOCAL)
	oGrid:SetField("LOCDES", CriaVar("CB0_LOCAL") )
	oGrid:SetField("CB0_CODPRO",CB0->CB0_CODPRO)
	oGrid:SetField("DESCRICAO",SB1->B1_DESC)
	oGrid:SetField("CB0_QTDE",CB0->CB0_QTDE)
	oGrid:SetField("CB0_LOTE",CB0->CB0_LOTE)
	oGrid:SetField("CB0_LOCALIZ",CB0->CB0_LOCALIZ)
	oGrid:SetField("STATUS",CB0->CB0_STATUS)
	
Return(.t.)

//=================================================================================================================
// LinhaOk -                                   Alessandro Freire                                  - Fev / 2016
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// LinhaOk do Grid
//-----------------------------------------------------------------------------------------------------------------
// Parametros
// nil
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Static Function LinhaOk( nLinha )
	
	Default nLinha := oGrid:GetAt()
	
	If oGrid:IsDeleted( nLinha )
		Return(.t.)
	EndIf
	
	If Empty( oGrid:GetField("CB0_CODETI",nLinha) )
		apMsgAlert( "Preencha o código da Etiqueta" )
		Return(.f.)
	EndIf
	
	If Empty( oGrid:GetField("LOCDES",nLinha) )
		apMsgAlert( "Preencha o armazém de destino" )
		Return(.f.)
	EndIf
	
Return( .t. )


//=================================================================================================================
// TudoOk -                                   Alessandro Freire                                  - Fev / 2016
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// TudoOk do Grid
//-----------------------------------------------------------------------------------------------------------------
// Parametros
// nil
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Static Function TudoOk()
	
	Local lRet  := .t.
	Local nLoop
	
	For nLoop := 1 to Len( oGrid:oGrid:aCols )
		lRet :=	LinhaOk( nLoop )
		If ! lRet
			Exit
		EndIf
	Next nLoop
	
Return( lRet )
