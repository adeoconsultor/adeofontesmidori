#INCLUDE "TOTVS.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "MSGRAPHI.CH" 
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.CH"

#DEFINE X3TITULO   1
#DEFINE X3CAMPO    2
#DEFINE X3PICTURE  3
#DEFINE X3TAMANHO  4
#DEFINE X3DECIMAL  5
#DEFINE X3VALID    6
#DEFINE X3USADO    7
#DEFINE X3TIPO     8
#DEFINE X3F3       9
#DEFINE X3CONTEXT 10
#DEFINE X3CBOX    11
#DEFINE X3RELACAO 12
#DEFINE X3WHEN    13
#DEFINE X3VISUAL  14
#DEFINE X3VLDUSER 15
#DEFINE X3PICTVAR 16
#DEFINE X3OBRIGAT 17
                           
// Posição dos botões da classe na buttonbar
#DEFINE BTNBAR_GRAFICO    1
#DEFINE BTNBAR_ORGANIZA   2
#DEFINE BTNBAR_FILTRO     3
#DEFINE BTNBAR_SEEK       4
#DEFINE BTNBAR_PLANILHA   5

/*
#DEFINE BTN_DEFAULT   1
#DEFINE BTN_CLOSE     2
#DEFINE BTN_CONFIRM   3
#DEFINE BTN_MAIS      4
#DEFINE BTN_PRIMARY   5
#DEFINE BTN_DANGER    6
#DEFINE BTN_SUCCESS   7
#DEFINE BTN_INFO      9
#DEFINE BTN_WARNING  10
*/

Static STATUS_NORMAL       := 0
Static STATUS_UNEXPANDED   := 1
Static STATUS_EXPANDED     := 2

//CLASSE MYGRID
//-------------
Class MyGrid
	Data oGrid
	Data oBrowse HIDDEN
	Data nUsado
	
	//Variaveis de inicialização
	Data nTop
	Data nLeft
	Data nBottom
	Data nRight
	Data nStyle
	Data cLinhaOk
	Data cTudoOk
	Data cIniCpos
	Data aAlter
	Data nFreeze
	Data nMax
	Data cFieldOk
	Data cSuperDel
	Data cDelOk
	Data oWnd
	Data aHeader
	Data aCols
	Data uChange
	Data cTela
	Data lLoaded
	

	Data oPnlGrid
	Data aBtnBar
	Data aBtnBar2 // Botões da Classe
	Data oBtnBar  // Botões do usuário
	Data lBtnBar
	
	// Barra de Pesquisas
	Data oBarSeek // Barra de pesquisas
	Data lSeekSet // Insere barra de pesquisas
	Data oCbxSeek
	DAta oGetSeek
	Data aItSeek
	Data cGetSeek
	DAta oBtnSeek
	Data oBtnNext
	Data nCbxSeek

	// Grafico
	Data aGraf
   
	Data lTotaliza
	Data lDescIndex
	Data aCpoDisp
	Data aColsDisp
	Data aColsOrd

	// Filtro
	Data aColsOrig // aCols original, sem filtro
	Data aColsFil  // aCols do Grid de Filtro
	
	// Trabalhar como MarkBrowse
	Data lIsMarkSet       
	Data lAllMark
	Data oTik
	Data oNo	 
	Data bOnMark
	
	Data cAliasTree Hidden //Alias temporário para indexar a árvore, caso esteja sendo utilizada
	Data cIndID     Hidden//Indice do arquivo temporário por ID
	Data cIndParent Hidden //Indice do arquivo temporário por ID do Pai
	Data lTree      Hidden //Facilitador para verificar se existe árvore na grid
	Data nIndent    Hidden //Quantidade de caracteres para indentação
	Data cIdSeq     Hidden //Controle sequecial de ID
	Data nPosIDTree Hidden //Posição do ID no aCols
	Data oHColBMP   Hidden
	
	Method New(nTop, nLeft, nBottom, nRight, nStyle, cLinhaOk, cTudoOk, cIniCpos, aAlter, nFreeze, nMax, cFieldOk, cSuperDel, cDelOk, oWnd,  ;
	aPartHeader, aParCols, uChange, cTela) Constructor
	Method AddColumn(aColumn)  //Adiciona Coluna no aHeader conforme parametro -- passa-se os dados da coluna no array conforme cfg. do aHeader
	Method AddColSX3(cFieldSX3, cTitulo, cCampo, cPicture, nTamanho, nDecimal, cValid, cF3, cCBox, cRelacao, cWhen, cVisual, cVldUser)//Adiciona Coluna no aHeader conforme dicionario
	Method AddColsDic(cAlias) //Adiciona todos os campos do dicionário de uma determinada tabela
	Method AddColBMP(cName, cBMPDefault, nPos) //Adiciona Coluna para exibir BMP
	Method AddLine(aInfo) //Adiciona linha na grid
	Method Load()         //Instancia a MsNewgetDados
	Method SetAlignAllClient()
	Method SetAlignTop()
	Method SetAlignBottom()
	Method SetAlignLeft()
	Method SetAlignRight()
	Method SetDoubleClick(bCodeBlock) //Bloco de codigo executado no duplo clique
	Method SetChange(bCodeBlock)      //Bloco de codigo executado no evento OnChange
	Method GetAt()                    //Retorna nAt da Grid
	Method SetAt(nAt)                 //Possibilita mudar nAt da Grid
	Method GetColPos()                //Retorna qual coluna foi selecionada na Grid
	Method GetField(cField, nRow)     //Retorna o conteúdo de um campo na linha nAt
	Method SetField(cField, xValue, nRow)   //Preenche campo com conteúdo na linha nAt
	Method FromSql(cSql)              //Carrega linhas na Grid de acordo com uma query passada
	Method FromSql1()
	Method FromTmp( cAlias )          // Carrega linhas na grid de acordo com tabela temporaria
	Method SetArray(aCols)            //Mesmo papel da SetArray na NewGetdados
	Method Refresh()
	Method GetColHeader(cField)       //Retorna o número da coluna de um determinado campo na grid
	Method Busca(xBusca, cField)      //Busca conteúdo em determinada coluna
	Method SetFocus()
	Method GotFocus(bAction)
	Method LostFocus(bAction) 
	Method Totaliza() // Totaliza os campos
	Method IsDeleted(nRow) //Retorna se determinada linha da grid está excluida
	Method AddButton() // Adiciona botão em oBtnBar
	Method AddGraf()  // Adiciona parâmetros para posterior montagem do gráfico com a ShowGraf
	Method ShowGraf() // Abre dialog para seleção do gráfico desejado
	Method Grafico() // Abre janela com gráficos
	Method ClearCols() // Remove a aCols
	Method ClearGrid() // Limpa aCols e aHeader
	Method SetF3() // Adiciona o F3 da ADVPL a um campo no grid
	// Indexar Grid
	Method IndexSet() // Prepara a MyGrid para Indexação
	Method IndexShow() // Abre dialog de indexação
	Method IndexDo()    // Indexa o grid da myGrid
	
	// Filtrar Grid
	Method FilterSet()   // Grid utiliza filtro
	Method FilterShow() // Abre dialog para seleção dos filtros
	Method FilterSave() // Salva os aCols sem filtro do Grid, salva o aCols do Grid de Filtro
	Method FilterGrid() // Filtra o conteúdo do grid

	// Barra de Pesquisas
	Method SeekSet() // Ajusta o grid para pesquisa
	Method ItSeek() // Preenche os campos para pesquisa
	Method ChangeSeek() // bChange do combo de pesquisa 
	Method GridSeek() // Efetua a pesquisa no grid
	Method MyCriaVar() // Conteudo vazio de acordo com o tipo de ::aHeader

	// Gerar planilha
	Method SheetSet() // Gera planilha Excel
	
	// Trabalhar como MarkBrowse
	Method MarkSet() // Trabalha como MarkBrowse
	Method Marca() // Marca / Desmarca
	Method IsMarked() // Linha Marcada?
	Method OnMark() // Executa codigo de bloco ao marcar/Desmarcar
			
	Method Tree()                     //Adiciona coluna BMP para simulação de arvore
	Method SaveNodeInfo(nLevel, cIDParent, nStatus) //Grava informações do Nó no arquivo temporário
	Method DelNodeInfo(nRow)                        //Exclui informações do Nó
	Method AddTreeChields(aFieldCols, nRowParent) //Adiciona "SubAcols" um nivel abaixo de determinado item
	Method AddChield(aInfo)           //Adiciona linha "filha" na arvore
	Method GetLevel(nRow)                 //Retorna nível de acordo com o nAt
	Method GetIDNode(nRow)            //Retorna ID do Nó
	Method SetTreeStatus(nStatus, nRow) //Seta algum status na linha, default nAt
	Method SetTreeExpanded(nRow)						//Seta Bitmap "-" no item da arvore, na linha passada, default nAt
	Method SetTreeUnExpanded(nRow)    //Seta Bitmap "+" no item da arvore, na linha passada, default nAt
	Method IsExpanded(nRow)           //Retorna .T. se uma linha está expandida, default nAt
	Method AddColID(aVet, nLevel)             //Adiciona coluna ID no aCols
	Method GetRowID(cID)              //Busca no acols a linha que contém determinado ID
	Method GetNodeInfo(cInfo, nRow)   //Retorna informações do arquivo temporário a respeito de um determinado nó da árvore
	Method DelTreeChields()           //Exclui registros "filhos" a partir de um nó da árvore
	Method GetParentRowId(nBackLvl)
	Method GetParentField(cField, nBackLvl)
	
EndClass

Method New(nTop, nLeft, nBottom, nRight, nStyle, cLinhaOk, cTudoOk, cIniCpos, aAlter, nFreeze, nMax, cFieldOk, cSuperDel, cDelOk, oWnd, ;
aPartHeader, aParCols, uChange, cTela) Class MyGrid

::oGrid     := Nil
::oBrowse   := Nil
::nTop      := nTop
::nLeft     := nLeft
::nBottom   := nBottom
::nRight    := nRight
::nStyle    := nStyle
::cLinhaOk  := cLinhaOk
::cTudoOk   := cTudoOk
::cIniCpos  := cIniCpos
::aAlter    := aAlter
::nFreeze   := nFreeze
::nMax      := nMax
::cFieldOk  := cFieldOk
::cSuperDel := cSuperDel
::cDelOk    := cDelOk
::oWnd      := oWnd
::aHeader   := aPartHeader
::aCols     := aParCols
::uChange   := uChange
::cTela     := cTela
::lTotaliza := .f.
::lLoaded   := .f.
::aBtnBar2  := { nil, nil, nil, nil, nil } // Gráficos, Indice, Filtro, Pesquisa, Planilha

// Filtro
::aColsOrig := {}
::aColsFil  := {}

::aGraf     := {}
::oPnlGrid  := nil
::aBtnBar   := {}
::lBtnBar   := .f.
::oBtnBar   := nil

::oBarSeek := nil // Barra de pesquisas
::lSeekSet := .f. // Insere barra de pesquisas
::oCbxSeek := nil
::oGetSeek := nil
::aItSeek  := {}
::cGetSeek := Space(20)
::oBtnSeek := nil
::oBtnNext := nil
::nCbxSeek := 1

::lDescIndex := .f.
::aCpoDisp   := {}
::aColsDisp  := {}
::aColsOrd   := {}

// MarkBrowse
::lIsMarkSet := .f. // .t.=trata grid como markbrowse
::lAllMark   := .f. // .t.=traz todos os registros marcados

::nUsado     := 0

::oHColBMP   := Thash():New()
::lTree      := .F.
::cIdSeq     := StrZero(0, 10)
::nPosIDTree := 0
//	::nIndent   := 2

Return(Self)
************************************************************************************************************************************
Method AddColumn(aColumn) Class MyGrid
Local nLoop := 1
/* Padrão aHeader MsNewGetDados
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
If ::aHeader == Nil
	::aHeader := {}
EndIf
             
For nLoop := 1 to 17
	If nLoop > Len( aColumn )
		aAdd( aColumn, "" )
	EndIf
Next nLoop

aAdd(::aHeader, aColumn)

::nUsado++

Return(self)

Method AddColSX3(cFieldSX3, cTitulo, cCampo, cPicture, nTamanho, nDecimal, cValid, cF3, cCBox, cRelacao, cWhen, cVisual, cVldUser) Class MyGrid
Local aArea   := GetArea()
Local aAreaX3 := SX3->(GetArea())

Default cCBox := ""

If ::aHeader == Nil
	::aHeader := {}
EndIf

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek(cFieldSX3)
	
	If !Empty(SX3->X3_CBOX) .And. At("#", SX3->X3_CBOX) > 0
		cCbox := &(StrTran(SX3->X3_CBOX, "#", ""))
	Else
		cCbox := SX3->X3_CBOX
	EndIf

	aAdd(::aHeader, {IIf(cTitulo <> Nil, cTitulo, SX3->X3_TITULO) , ;
	IIf(cCampo   <> Nil, cCampo  , SX3->X3_CAMPO  ) , ;
	IIf(cPicture <> Nil, cPicture, SX3->X3_PICTURE), ;
	IIf(nTamanho <> Nil, nTamanho, SX3->X3_TAMANHO), ;
	IIf(nDecimal <> Nil, nDecimal, SX3->X3_DECIMAL), ;
	IIf(cValid   <> Nil, cValid  , SX3->X3_VALID  ), ;
	SX3->X3_USADO  , ;
	SX3->X3_TIPO   , ;
	IIf(cF3      <> Nil, cF3     , SX3->X3_F3     ), ;
	SX3->X3_CONTEXT, ;
	cCbox          , ;
	IIf(cRelacao <> Nil, cRelacao, SX3->X3_RELACAO), ;
	IIf(cWhen    <> Nil, cWhen   , SX3->X3_WHEN   ), ;
	IIf(cVisual  <> Nil, cVisual , SX3->X3_VISUAL ), ;
	IIf(cVldUser <> Nil, cVldUser, SX3->X3_VLDUSER), ;
	SX3->X3_PICTVAR, ;
	SX3->X3_OBRIGAT})
EndIf

::nUsado++

RestArea(aAreaX3)
RestArea(aArea)
Return(self)
************************************************************************************************************************************
Method AddColsDic(cAlias) Class MyGrid

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek(cAlias)
While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cAlias
	If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_BROWSE == "S"
		Self:AddColSX3(SX3->X3_CAMPO)
	EndIf
	
	SX3->(DbSkip())
End

Return(self)
************************************************************************************************************************************
//Cria nova linha na Grid
//Com os dados da linha passados no parâmetro ou uma linha em branco, caso o parametro não tenha sido passado
Method AddLine(aInfo) Class MyGrid
Local nI      := 0
Local aArea   := GetArea()
Local aAreaX3 := SX3->(GetArea())

Default aInfo := {}

::aCols := Self:oGrid:aCols

If ::aCols == Nil
	::aCols := {}
EndIf

If Len(aInfo) > 0
	// Quando for markbrowse
// aqui teste
/*	If ::lIsMarkSet
		                 
		aSize( aInfo, Len(aInfo) + 1 ) // aumento a linha em 1 coluna
		aIns( aInfo, 1 ) // insiro na coluna 1 NIL

		aInfo[1] := if( ::lAllMark, "LBTIK", "LBNO" )
	EndIf
*/
	aAdd(::aCols, aInfo)                              

Else
	aAdd(::aCols, Array(::nUsado + 1))
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	
	For nI := 1 To Len(::aHeader)
		
		If DbSeek(::aHeader[nI, X3CAMPO]) //É um campo do dicionário
			::aCols[Len(::aCols), nI] := CriaVar(::aHeader[nI, X3CAMPO], .F.)
		Else
			If ::aHeader[nI, X3TIPO] == "D"
				::aCols[Len(::aCols), nI] := CTOD("  /  /  ")
			ElseIf ::aHeader[nI, X3TIPO] == "N"
				::aCols[Len(::aCols), nI] := 0
			ElseIf ::aHeader[nI, X3TIPO] == "C"
				If ::aHeader[nI, X3PICTURE] <> "@BMP"
					::aCols[Len(::aCols), nI] := Space(::aHeader[nI, X3TAMANHO])
				Else//Insere Bitmap padrão
					IF ::lIsMarkSet .and. nI == 1
						::aCols[Len(::aCols), nI] := if( ::lAllMark, "LBTIK", "LBNO" )
					Else
						::aCols[Len(::aCols), nI] := ::oHColBmp:getObj(nI)
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	
	//Adiciona a última coluna -- deleted
	::aCols[Len(::aCols), ::nUsado+1] := .F.
EndIf

If ::lTree//Se tem arvore adiciona uma coluna para ID da linha
	Self:AddColID(@::aCols[Len(::aCols)])
EndIf

If ::oGrid <> Nil
//	::oGrid:SetArray(::aCols) // aqui
	::SetArray(::aCols)
	::oGrid:Refresh()
EndIf

Return(self)

**********************************************************************************************************************************************
// Carrega a MsNewGetDados da MyGrid
**********************************************************************************************************************************************
Method Load() Class MyGrid

Local nLoop

//------------------------------------------------------------------
// Limpa o painel que contém a grid, caso o método Load seja
// chamado mais de uma vez
//------------------------------------------------------------------
//If ValType(::oPnlGrid) == "O"
//	FreeObj(::oPnlGrid)
//EndIf

//------------------------------------------------------------------
// Painel que conterá o grid
//------------------------------------------------------------------
If ValType( ::oPnlGrid ) <> "O"
	::oPnlGrid := TPanel():New( ::nTop, ::nLeft, "", ::oWnd, nil, nil, nil, nil, nil, ::nBottom, ::nRight, .f., .f. )
EndIf

//------------------------------------------------------------------
// Adiciona a barra de pesquisa
//------------------------------------------------------------------
If ::lSeekSet .and. ValType( ::oBarSeek ) <> "O"
	::oBarSeek := AdvplBar():New( ::oPnlGrid,2 )
	::oBarSeek:BarAlignTop()
	::ItSeek()
	@ 000, 003 MSCOMBOBOX ::oCbxSeek VAR ::nCbxSeek ITEMS ::aItSeek SIZE 102, 010 OF ::oBarSeek:oPanel PIXEL
	::oCbxSeek:bChange := { || ::ChangeSeek() }
	::oCbxSeek:Select(1)
	@ 000, 108 MSGET ::oGetSeek      VAR ::cGetSeek SIZE 132, 010 OF ::oBarSeek:oPanel PIXEL                      
	@ 000, 241 BUTTON ::oBtnSeek  PROMPT ">"        SIZE 017, 010 OF ::oBarSeek:oPanel PIXEL ACTION Processa( {||::GridSeek(.f.),::oGrid:oBrowse:SetFocus()}, "Pesquisando..." )
	@ 000, 259 BUTTON ::oBtnNext  PROMPT ">>"       SIZE 017, 010 OF ::oBarSeek:oPanel PIXEL ACTION Processa( {||::GridSeek(.t.),::oGrid:oBrowse:SetFocus()}, "Pesquisando..." )
EndIf

//------------------------------------------------------------------
// Adiciona a barra de botões
//------------------------------------------------------------------
If ::lBtnBar .and. ValType( ::oBtnBar ) <> "O"
	::oBtnBar := AdvplBar():New( ::oPnlGrid,2 )
	::oBtnBar:BarAlignTop()
	::oBtnBar:BtnAlignLeft()
	
	//------------------------------------------------------------------------
	// 	Adiciona os botões de gráfico, filtro, ordenar e planilha
	//------------------------------------------------------------------------
	For nLoop := 1 to Len( ::aBtnBar2 )
		
		// Botão não definido
		If ValType( ::aBtnBar2[nLoop] ) == "U"
			Loop
		EndIf
		
		::oBtnBar:AddButton( ::aBtnBar2[nLoop,1], ::aBtnBar2[nLoop,2] )
		
	Next nLoop
	
	//------------------------------------------------------------------
	// Adiciona os demais botoes definidos em ::oMyGrid:AddButton()
	//------------------------------------------------------------------
	For nLoop := 1 to Len( ::aBtnBar )
		::oBtnBar:AddButton( ::aBtnBar[nLoop,1], ::aBtnBar[nLoop,2] )
	Next nLoop
	
EndIf

//-----------------------------
// Carrega a MsNewGetDados
//-----------------------------
If ValType( ::oGrid ) == "O"
	::oGrid := nil
EndIf
                                                                    
//-----------------------------
// Se for MarkSet, não deixa
// editar
//-----------------------------
If ::lIsMarkSet
	::nStyle  := 0
//	::nFreeze := 1
	::oTik    := LoadBitmap( GetResources(), "LBTIK" )
	::oNo     := LoadBitmap( GetResources(), "LBNO"  )
EndIf

::oGrid := MsNewGetDados():New(::nTop, ::nLeft, ::nBottom, ::nRight, ::nStyle, ::cLinhaOk, ::cTudoOk, ::cIniCpos, ::aAlter, ::nFreeze, ::nMax, ::cFieldOk, ;
::cSuperDel, ::cDelOk, ::oPnlGrid, ::aHeader, ::aCols, ::uChange, ::cTela)
::oBrowse := ::oGrid:oBrowse
::oGrid:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT

::aCols := ::oGrid:aCols

If ::lIsMarkSet
	::SetDoubleClick( {|| ::Marca() } )
EndIf                                                            
//------------------------------------------------------------------
// Informa que a MyGrid já foi carregada para tela.
// Variável utilizada para evitar que os botões sejam carregados
// mais de uma vez.
//------------------------------------------------------------------
::lLoaded := .t.

Return(self)

***************************************************************************************************************************************

Method SetAlignAllClient() Class MyGrid
::oPnlGrid:Align := CONTROL_ALIGN_ALLCLIENT
Return(self)
************************************************************************************************************************************
Method SetAlignTop() Class MyGrid
::oPnlGrid:Align := CONTROL_ALIGN_TOP
Return(self)                                                                                                                        
************************************************************************************************************************************
Method SetAlignBottom() Class MyGrid
::oPnlGrid:Align := CONTROL_ALIGN_BOTTOM
Return(self)
************************************************************************************************************************************
Method SetAlignLeft() Class MyGrid
::oPnlGrid:Align := CONTROL_ALIGN_LEFT
Return(self)
************************************************************************************************************************************
Method SetAlignRight() Class MyGrid
::oPnlGrid:Align := CONTROL_ALIGN_RIGHT
Return(self)
************************************************************************************************************************************
Method SetDoubleClick(bCodeBlock) Class MyGrid
::oGrid:oBrowse:BlDblClick := bCodeBlock
Return(self)
************************************************************************************************************************************
Method SetChange(bCodeBlock) Class MyGrid
::oGrid:bChange := bCodeBlock
Return(self)
************************************************************************************************************************************
Method AddColBMP(cName, cBMPDefault, nPos, cTitle) Class MyGrid

Default cTitle      := " "
Default cBMPDefault := ""

cBMPDefault :=  "'" + cBMPDefault + "'"

nPos := 1

If ::aHeader == Nil
	::aHeader := {}
EndIf

If nPos > Len(::aHeader)
	nPos := Len(::aHeader)+1
EndIf

aSize(::aHeader, Len(::aHeader) + 1 )
aIns(::aHeader, nPos)

::aHeader[nPos] := { cTitle, cName, "@BMP", 3, 0, .F., "", "C", "", "V", "", cBMPDefault, "", "V", "" } // aqui teste , "", ""}

::oHColBMP:put(nPos, cBMPDefault) //Armazena o Bitmap padrão para aquela coluna

::nUsado++
Return(self)

Method Tree() Class MyGrid
Local aFields  := {}
Local cFile := Nil

::lTree := .T.

aAdd(aFields, {"ID"        , "C", 10 , 0})
aAdd(aFields, {"LEVEL "    , "N", 2  , 0})
aAdd(aFields, {"IDPARENT"  , "C", 10 , 0})
aAdd(aFields, {"STATUS"    , "N", 1  , 0})

cFile := CriaTrab(aFields, .T.)

::cAliasTree := CriaTrab(Nil, .F.)
DbUseArea(.T., "DBFCDX", cFile, ::cAliasTree, .F., .F.)

::cIndParent := CriaTrab(Nil , .F.)
DbCreateIndex(::cIndParent, "IDPARENT", {|| IDPARENT })

::cIndID     := CriaTrab(Nil , .F.)
DbCreateIndex(::cIndID, "ID", {|| ID })

DbSetIndex(::cIndParent)
DbSetIndex(::cIndID)

Self:AddColBMP("TREE", "SHORTCUTPLUS", 1)
Return(self)
************************************************************************************************************************************
Method AddChield(aInfo) Class MyGrid
Self:AddLine(aInfo)
Return(self)
************************************************************************************************************************************
Method GetAt() Class MyGrid
Return(::oGrid:nAt)

************************************************************************************************************************************
Method SetArray(aCols) Class MyGrid

Local nLoop
Local cBmp

//---------------------------------
// Tratamento quando MarkSet()
//---------------------------------
// aqui teste
If ::lIsMarkSet
	// Verifica se deve ou não trazer todas as colunas marcadas
	If ::lAllMark
		cBmp := "LBTIK"
	Else
		cBmp := "LBNO"
	EndIf

EndIf

If ::lIsMarkSet .and. ValType( ::aCols[1] ) == "A" 
    //----------------------------------------------------------        
	// Verifica se todos os campos estão com o bitmap de marca
	//----------------------------------------------------------
	For nLoop := 1 to Len( ::aCols )                              
		//----------------------------------------------------------
		// Verifica se deve inserir a coluna de marca               
		//----------------------------------------------------------
		If Len(::aCols[nLoop]) <= Len( ::aHeader )                  
			//----------------------------------------------------------
			// Adiciona a coluna de marca                               
			//----------------------------------------------------------
			aSize( ::aCols[nLoop], Len(::aCols[nLoop])+1 )
			aIns( ::aCols[nLoop], 1 )                                     
			//----------------------------------------------------------
			// Adiciona o bitmap correto                                
			//----------------------------------------------------------
			::aCols[nLoop,1] := cBmp	
		EndIf
	Next nLoop
	
EndIf

::aCols := aClone(aCols)

If ::oGrid <> Nil
                     
	//----------------------------------------------------------
	// Verifica se tem coluna de marca
	//----------------------------------------------------------
	If ::lIsMarkSet .and. ValType( ::aCols ) == "A"             
		//----------------------------------------------------------
		//  Verifica de deve colocar o bitmap padrão ou
		//  deixa com o bitmap atual de marca
		//----------------------------------------------------------
		For nLoop := 1 to Len( ::aCols )
			If Empty( ::aCols[nLoop,1] )
				::aCols[nLoop,1] := cBmp
			EndIf
		Next nLoop
	EndIf

	::oGrid:SetArray(::aCols)
	Self:Refresh()

EndIf

Return(self)
************************************************************************************************************************************
Method FromSql(cSql, lBmp, lProcessa) Class MyGrid
	Default lProcessa := .F.
	
	If lProcessa
		Processa( {||Self:FromSql1(cSql,lBmp) }, "Selecionando dados..." )
	Else
		Self:FromSql1(cSql,lBmp)
	EndIf
Return(self)
************************************************************************************************************************************
Method FromSql1(cSql, lBmp) Class MyGrid

Local nCol       := 0, nPos := 0
Local aVet       := {}
Local aColsTMP   := {}
Local cAlias     := CriaTrab(Nil, .F.)
Local xVar       := Nil
Local nIni       := 1

Default lBmp := .T.

//TCQuery cSql New Alias &cAlias

dbUseArea(.t., "TOPCONN", TcGenQry(,,cSql), cAlias, .f., .t. )

// Preenche o array do combo de pesquisa
::ItSeek()

For nCol := 1 To Len(::aHeader)
	If ::aHeader[nCol, 10] <> "V" .And. ::aHeader[nCol, 08] $ "D/N"
		TCSetField(cAlias, ::aHeader[nCol, 02], ::aHeader[nCol, 08], ::aHeader[nCol, 04], ::aHeader[nCol, 05])
	EndIf
Next
        
Self:nUsado := Len( Self:aHeader )

DbSelectArea(cAlias)

If (cAlias)->(Eof()) //Se não retornar nada na query, carrega com uma linha em branco evitando erros
	aVet := Array(::nUsado + 1)  
	                        
	//---------------------------------
	// Tratamento quando MarkSet()
	//---------------------------------
	If ::lIsMarkSet
		nIni := 2   
		If ::lAllMark
			aVet[1] := "LBTIK"
		Else
			aVet[1] := "LBNO"
		EndIf
	EndIf
	
	For nCol := nIni To Len(::aHeader)
		If (nPos := (cAlias)->(FieldPos(::aHeader[nCol, X3CAMPO]))) > 0
			If ::aHeader[nCol, X3TIPO] == "C"
				xVar := Space(::aHeader[nCol, X3TAMANHO])
			ElseIf ::aHeader[nCol, X3TIPO] == "D"
				xVar := CTOD("  /  /  ")
			ElseIf ::aHeader[nCol, X3TIPO] == "N"
				xVar := 0
			Else
				xVar := Nil
			EndIf
			
			If !Empty(::aHeader[nCol, X3RELACAO])
				xVar       := &(::aHeader[nCol, X3RELACAO])
				aVet[nCol] := xVar
			Else
				aVet[nCol] := xVar
			EndIf
			
		ElseIf lBmp //Verifica se deve carregar BMP Padrão
			If ::aHeader[nCol, X3PICTURE] == "@BMP" //Somente para colunas do tipo "BMP"
				aVet[nCol] := ::oHColBmp:getObj(nCol)
			EndIf
		EndIf
	Next
	
	aVet[::nUsado + 1] := .F.
	
	If ::lTree //Se utiliza árvore
		Self:AddColID(@aVet)
	EndIf
	
	aAdd(aColsTMP, aVet)
	
Else
	
	While !(cAlias)->(Eof())
		aVet := Array(Len(Self:aHeader) + 1)

		//---------------------------------
		// Tratamento quando MarkSet()
		//---------------------------------
		nIni := 1
		If ::lIsMarkSet
			nIni := 2   
			If ::lAllMark
				aVet[1] := "LBTIK"
			Else
				aVet[1] := "LBNO"
			EndIf
		EndIf
		
		For nCol := nIni To Len(::aHeader)
			If (nPos := (cAlias)->(FieldPos(::aHeader[nCol, X3CAMPO]))) > 0
				aVet[nCol] := (cAlias)->(&(Field(nPos)))
			ElseIf lBmp //Verifica se deve carregar BMP Padrão
				If ::aHeader[nCol, X3PICTURE] == "@BMP" //Somente para colunas do tipo "BMP"
					aVet[nCol] := ::oHColBmp:getObj(nCol)
				EndIf
			EndIf
		Next
		
		aVet[Len(Self:aHeader) + 1] := .F.
		
		If ::lTree //Se utiliza árvore
			Self:AddColID(@aVet)
		EndIf
		
		aAdd(aColsTMP, aVet)
		
		(cAlias)->(DbSkip())
	End
EndIf

(cAlias)->(DbCloseArea())

If Empty(aColsTMP)
	aAdd(aColsTMP, Array(::nUsado + 1))
	aAdd(aColsTMP[Len(aColsTMP)], .F.)
	If ::cIniCpos <> Nil
		cAux := StrTran(Self:cIniCpos, "+", "")
		If (nPosAux := GetColHeader(cAux)) > 0
			aColsTMP[Len(aColsTMP), nPosAux] := StrZero(1, ::aHeader[nPosAux, X3TAMANHO])
		EndIf
	EndIf
EndIf

Self:SetArray(aColsTMP)

Return(self)
******************************************************************************************************
Method ItSeek() Class MyGrid

Local nLoop 

::aItSeek := {}

For nLoop := 1 to Len( ::aHeader )                                   
	If Empty( ::aHeader[nLoop,X3TITULO] )
		Loop
	EndIf     
	If ::aHeader[nLoop,X3PICTURE] == "@BMP"
		Loop
	EndIf
	If ::aHeader[nLoop,X3TIPO] == "M"
		Loop
	EndIf
	AAdd( ::aItSeek, StrZero(nLoop,3) + " " + ::aHeader[nLoop,X3TITULO] )
Next nLoop

If ValType( ::oCbxSeek ) == "O"
	::oCbxSeek:SetItems( ::aItSeek )
EndIf

Return(self)
************************************************************************************************************************************
Method Refresh(lFirstLine) Class MyGrid
Default lFirstLine := .f.
::oGrid:Refresh()//Alterado para testar refresh() ::oGrid:oBrowse:Refresh()
If lFirstLine
	::oGrid:GoBottom()
	::oGrid:GoTop()
EndIf
Return(self)
************************************************************************************************************************************
Method GetLevel(nRow) Class MyGrid
Local nLevel := 0

Default nRow := Self:GetAt()

DbSelectArea(::cAliasTree)
DbSetOrder(1)
If DbSeek(Self:GetIDNode(nRow)) //Busca a linha no arquivo de índice da árvore
	nLevel := (::cAliasTree)->LEVEL
EndIf

Return(nLevel)
************************************************************************************************************************************
Method GetField(cField, nRow) Class MyGrid
Local nPosField := aScan(::aHeader, {|aVet| AllTrim(aVet[2]) == AllTrim(cField)})
Local xRet := Nil

Default nRow := ::GetAt()

If nPosField > 0
	xRet := ::oGrid:aCols[nRow, nPosField]
EndIf
Return(xRet)
************************************************************************************************************************************
Method AddTreeChields(aFieldCols, nRowParent) Class MyGrid
Local nFor := 0
Local nCurrent := 0
Local cIDParent  := ""
Local nNextLevel := 0

Default nRowParent := Self:GetAt()

cIDParent  := Self:GetNodeInfo("ID") //ID da linha "pai"
nNextLevel := Self:GetNodeInfo("LEVEL") + 1//Incrmenta 1 no nivel para gravar nos "filhos"

nCurrent := nRowParent + 1

For nFor := 1 To Len(aFieldCols)
	//Aumenta a coluna do ID no array auxiliar
	Self:AddColID(aFieldCols[nFor], nNextLevel, cIDParent)
	
	//Aumenta espaço no aCols
	aSize(::oGrid:aCols, Len(::oGrid:aCols)+1)
	aIns(::oGrid:aCols, nCurrent)
	::oGrid:aCols[nCurrent] := aFieldCols[nFor]
	
Next

::aCols := aClone(::oGrid:aCols)

Self:Refresh()

Return(self)
************************************************************************************************************************************
Method SetField(cField, xValue, nRow) Class MyGrid
Local nPosField := aScan(::aHeader, {|aVet| AllTrim(aVet[2]) == AllTrim(cField)})
Local xRet := Nil

Default nRow := Self:GetAt()

If nPosField > 0
	::oGrid:aCols[nRow, nPosField] := xValue
EndIf

Self:Refresh()

Return(self)
************************************************************************************************************************************
Method SetTreeStatus(nStatus, nRow) Class MyGrid

Default nRow := Self:GetAt()

Self:SetField("TREE", IIf(nStatus == STATUS_UNEXPANDED, "SHORTCUTPLUS", "SHORTCUTMINUS"))

DbSelectArea(::cAliasTree)
DbSetOrder(1)//ID
If DbSeek(Self:GetIDNode(nRow)) //Busca a linha no arquivo de índice da árvore
	RecLock(::cAliasTree, .F.)
	(::cAliasTree)->STATUS := nStatus
	MsUnlock()
EndIf

Return(self)
************************************************************************************************************************************
Method SetTreeExpanded(nRow) Class MyGrid

Self:SetTreeStatus(STATUS_EXPANDED, nRow)

Return(self)
************************************************************************************************************************************
Method SetTreeUnExpanded(nRow) Class MyGrid

Self:SetTreeStatus(STATUS_UNEXPANDED, nRow)

Return(self)
************************************************************************************************************************************
Method IsExpanded(nRow) Class MyGrid
Local lRet := .T.

Default nRow := Self:GetAt()

DbSelectArea(::cAliasTree)
DbSetOrder(1)//ID
If DbSeek(Self:GetIDNode(nRow)) //Busca a linha no arquivo de índice da árvore
	lRet := (::cAliasTree)->STATUS == STATUS_EXPANDED
EndIf

Return(lRet)
************************************************************************************************************************************
Method GetNodeInfo(cInfo, nRow) Class MyGrid
Local xRet := Nil

Default nRow := Self:GetAt()

DbSelectArea(::cAliasTree)
DbSetOrder(1)//ID
If DbSeek(Self:GetIDNode(nRow)) //Busca a linha no arquivo de índice da árvore
	xRet := (::cAliasTree)->&(cInfo)
EndIf

Return(xRet)
************************************************************************************************************************************
Method DelTreeChields(nRow) Class MyGrid
Local cIDParent := ""
Local nPosDel   := 0
Local lDel      := .T.
Local nRowDel   := 0
Local nLevelIni := 0

Default nRow := Self:GetAt()

nRowDel := nRow + 1

//Busca Nivel do registro pai
DbSelectArea(::cAliasTree)
DbSetOrder(1)//ID
If DbSeek(Self:GetIDNode(nRow))
	nLevelIni := (::cAliasTree)->LEVEL
EndIf

//A idéia é excluir linhas até achar uma que seja do mesmo nível de onde veio o clique
While lDel .And. nRowDel <= Len(::oGrid:aCols)
	If Self:GetLevel(nRowDel) > nLevelIni
		Self:DelNodeInfo(nRowDel) //Exclui informações do arquivo
		
		//Ajusta aCols
		aDel(::oGrid:aCols, nRowDel)
		aSize(::oGrid:aCols, Len(::oGrid:aCols)-1)
		
	Else
		lDel := .F.
	EndIf
End

Self:Refresh()

Self:SetTreeUnExpanded()

Return(self)
************************************************************************************************************************************
Method SaveNodeInfo(nLevel, cIDParent, nStatus) Class MyGrid

Default nLevel    := 1
Default cIdParent := Space(Len(::cIdSeq))
Default nStatus   := STATUS_UNEXPANDED

::cIdSeq := Soma1(::cIdSeq)

DbSelectArea(::cAliasTree)
RecLock(::cAliasTree, .T.)
(::cAliasTree)->ID       := ::cIdSeq
(::cAliasTree)->LEVEL    := nLevel
(::cAliasTree)->IDPARENT := cIDParent
(::cAliasTree)->STATUS   := nStatus
MsUnlock()
Return(::cIdSeq)
************************************************************************************************************************************
Method DelNodeInfo(nRow) Class MyGrid

DbSelectArea(::cAliasTree)
DbSetOrder(1)//ID
If DbSeek(Self:GetIDNode(nRow))
	RecLock(::cAliasTree, .F.)
	DbDelete()
	MsUnlock()
EndIf

Return(self)
************************************************************************************************************************************
Method GetIDNode(nRow) Class MyGrid
Default nRow := Self:GetAt()
Return(::oGrid:aCols[nRow, ::nPosIDTree])
************************************************************************************************************************************
Method AddColID(aVet, nLevel, cIDParent) Class MyGrid

Default nLevel := 1
Default cIDParent := ""

::nPosIDTree := Len(::aHeader)+1   //Armazena essa posição para facilitar
aSize(aVet, Len(aVet)+1)        //Aumenta o tamanho da linha
aIns(aVet, ::nPosIDTree)           //Insere um espaço em branco antes do deletado
aVet[::nPosIDTree] := Self:SaveNodeInfo(nLevel, cIDParent)   //Salva as informações		no temporário e armazena o ID na coluna

Return(self)
************************************************************************************************************************************
Method GetRowID(cID) Class MyGrid
Local nRow := 0

Default cID := Self:GetIDNode()

nRow := aScan(::oGrid:aCols, {|aVet| aVet[::nPosIDTree] == cID})

Return(nRow)
************************************************************************************************************************************
Method GetParentRowId(nBackLvl) Class MyGrid
Local nRow := 0
Local cId  := Self:GetIDNode()
Local nI   := 1

Default nBackLvl := 1

For nI := 1 To nBackLvl
	cId := self:GetNodeInfo("IDPARENT", Self:GetRowID(cId))
Next

nRow := Self:GetRowID(cId)
Return(nRow)
************************************************************************************************************************************
Method GetParentField(cField, nBackLvl) Class MyGrid
Local cRet := ""

Default nBackLvl := 1

cRet := Self:GetField(cField, Self:GetParentRowId(nBackLvl))
Return(cRet)
************************************************************************************************************************************
Method GetColHeader(cField) Class MyGrid
Local nRet := 0

nRet := aScan(::aHeader, {|aVet| AllTrim(aVet[2]) == AllTrim(cField) })

Return(nRet)
************************************************************************************************************************************
Method Busca(xBusca, cField) Class MyGrid
Local nRet := 0

nRet := aScan(::oGrid:aCols, {|aVet| AllTrim(aVet[Self:GetColHeader(cField)]) = AllTrim(xBusca) })

Return(nRet)
************************************************************************************************************************************
Method SetAt(nAt) Class MyGrid
Self:oGrid:oBrowse:nAt := nAt 
Self:Refresh()
Self:oGrid:Goto(nAt)
Self:Refresh()
Return(self)
************************************************************************************************************************************
Method SetFocus() Class MyGrid
::oGrid:oBrowse:SetFocus()
Return(self)
************************************************************************************************************************************
Method GetColPos() Class MyGrid
Return(::oGrid:oBrowse:nColPos)
************************************************************************************************************************************
Method GotFocus(bAction) Class MyGrid
::oGrid:oBrowse:bGotFocus := bAction
Return(self)
************************************************************************************************************************************
Method LostFocus(bAction) Class MyGrid
::oGrid:oBrowse:bLostFocus := bAction
Return(self)
************************************************************************************************************************************
User Function __MyGrid()
Return()

//=================================================================================================================
// FromTmp():MyGrid() -                    Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Adiciona linhas na grid a partir de uma tabela temporária
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method FromTmp( cAlias, lBmp ) Class MyGrid

Local aArea      := GetArea()
Local nCol       := 0, nPos := 0
Local aVet       := {}
Local aColsTMP   := {}
Local xVar       := Nil 
Local nIni       := 1

Default lBmp := .t.

// Preenche o array para o combo de pesquisa
::ItSeek()

DbSelectArea(cAlias)

If (cAlias)->(Eof()) //Se não retornar nada na query, carrega com uma linha em branco evitando erros
	aVet := Array(::nUsado + 1)
	                 
	//---------------------------------
	// Tratamento quando MarkSet()
	//---------------------------------
	If ::lIsMarkSet
		nIni := 2   
		If ::lAllMark
			aVet[1] := "LBTIK"
		Else
			aVet[1] := "LBNO"
		EndIf
	EndIf

	For nCol := nIni To Len(::aHeader)
 
 		If (nPos := (cAlias)->(FieldPos(::aHeader[nCol, X3CAMPO]))) > 0
			If ::aHeader[nCol, X3TIPO] == "C"
				xVar := Space(::aHeader[nCol, X3TAMANHO])
			ElseIf ::aHeader[nCol, X3TIPO] == "D"
				xVar := CTOD("  /  /  ")
			ElseIf ::aHeader[nCol, X3TIPO] == "N"
				xVar := 0
			Else
				xVar := Nil
			EndIf
			
			aVet[nCol] := xVar
		ElseIf lBmp //Verifica se deve carregar BMP Padrão
			If ::aHeader[nCol, X3PICTURE] == "@BMP" //Somente para colunas do tipo "BMP"
				aVet[nCol] := ::oHColBmp:getObj(nCol)
			EndIf
		EndIf
	Next
	
	aVet[::nUsado + 1] := .F.
	
	If ::lTree //Se utiliza árvore
		Self:AddColID(@aVet)
	EndIf
	
	aAdd(aColsTMP, aVet)
	
Else
	dbGoTop()
	While !(cAlias)->(Eof())
		aVet := Array(::nUsado + 1)


		//---------------------------------
		// Tratamento quando MarkSet()
		//---------------------------------
		If ::lIsMarkSet
			nIni := 2   
			If ::lAllMark
				aVet[1] := "LBTIK"
			Else
				aVet[1] := "LBNO"
			EndIf
		EndIf

			
		For nCol := nIni To Len(::aHeader)
			If (nPos := (cAlias)->(FieldPos(::aHeader[nCol, X3CAMPO]))) > 0
				aVet[nCol] := (cAlias)->(&(Field(nPos)))
			ElseIf lBmp //Verifica se deve carregar BMP Padrão
				If ::aHeader[nCol, X3PICTURE] == "@BMP" //Somente para colunas do tipo "BMP"
					aVet[nCol] := ::oHColBmp:getObj(nCol)
				EndIf
			EndIf
		Next
		
		aVet[::nUsado + 1] := .F.
		
		If ::lTree //Se utiliza árvore
			Self:AddColID(@aVet)
		EndIf
		
		aAdd(aColsTMP, aVet)
		
		(cAlias)->(DbSkip())
	End
EndIf

If Empty(aColsTMP)
	aAdd(aColsTMP, Array(::nUsado + 1))
	aAdd(aColsTMP[Len(aColsTMP)], .F.)
	If ::cIniCpos <> Nil
		cAux := StrTran(Self:cIniCpos, "+", "")
		If (nPosAux := GetColHeader(cAux)) > 0
			aColsTMP[Len(aColsTMP), nPosAux] := StrZero(1, ::aHeader[nPosAux, X3TAMANHO])
		EndIf
	EndIf
EndIf

Self:SetArray(aColsTMP)                      

RestArea( aArea )

Return(self)                                                                                         

//=================================================================================================================
// MyGrid():AddButton() -                  Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Adiciona um botão na barra oBtnBar 
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros                     
// cLabel      - Label do botão
// bAction     - Código de bloco com a ação do botão
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method AddButton( cLabel, bAction ) Class MyGrid

::lBtnBar := .t.
     
//------------------------------------------------------------------
// Somente insere o botão na barra se a tela ainda não tiver sido
// carregada pelo método Load()
//------------------------------------------------------------------
If ! ::lLoaded
	AAdd( ::aBtnBar, { cLabel, bAction } )
EndIf

Return(self)

//=================================================================================================================
// MyGrid():AddGraf -                     Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Adiciona um gráfico 
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros                     
// cTitulo     - Titulo da Dialog de Gráfico
// nColSerie   - Coluna responsável pelo título da série
// aCpoEntra   - Array com os campos que contem os valores da série. {{ "CAMPO","Descrição"},...}
// aCpoSai     - Array com os campos que não devem entrar nos valores {"CAMPO1","CAMPO2",...}  
// lOnlyTotV   - Somente mostra no gráfico o somatório das colunas de cada linha. PRECISA ter nColSerie
// lOnlyTotH   - Somente mostra no gráfico o somatório das colunas. nColserie será ignorado. As séries serão os 
//               Títulos das colunas
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method AddGraf( cTitulo, nColSerie, aCpoEntra, aCpoSai, lOnlyTotH, lOnlyTotV  ) Class MyGrid
AAdd( Self:aGraf, {cTitulo, nColSerie, aCpoEntra, aCpoSai, lOnlyTotH, lOnlyTotV} )
Return(self)

//=================================================================================================================
// MyGrid():ShowGraf -                     Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Abre dialog para selecionar o gráfico desejado
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros                     
// nil
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method ShowGraf() Class MyGrid

Local oDlgSel
Local oBtnFecha
Local oBtnOk
Local oCbxGraf
Local nCbxGraf := 1                                    
Local aItem    := {}
Local lOk      := .f.
Local nLoop    
Local cTitulo, nColSerie, aCpoEntra, aCpoSai, lOnlyTotH, lOnlyTotV

If Empty( Self:aGraf )
	Return(self)
EndIf

For nLoop := 1 to Len( Self:aGraf )
	AAdd( aItem, Self:aGraf[nLoop,1] )
Next nLoop                        

DEFINE MSDIALOG oDlgSel TITLE "Gráficos" FROM 000, 000  TO 080, 165 PIXEL

@ 003, 004 SAY "Selecione o gráfico desejado" SIZE 075, 007 OF oDlgSel PIXEL
@ 011, 005 MSCOMBOBOX oCbxGraf VAR nCbxGraf ITEMS aItem SIZE 072, 010 OF oDlgSel COLORS 0, 16777215 PIXEL
@ 024, 041 BUTTON oBtnOk PROMPT "Ok" SIZE 037, 012 OF oDlgSel ACTION ( lOk := .t. , oDlgSel:End() ) PIXEL
@ 024, 003 BUTTON oBtnFecha PROMPT "Fechar" SIZE 037, 012 OF oDlgSel ACTION ( oDlgSel:End() ) PIXEL

ACTIVATE MSDIALOG oDlgSel CENTERED

If ! lOk
	Return(self)
EndIf                                                                       

cTitulo   := Self:aGraf[nCbxGraf,1]
nColSerie := Self:aGraf[nCbxGraf,2]
aCpoEntra := aClone( Self:aGraf[nCbxGraf,3] )
aCpoSai   := aClone( Self:aGraf[nCbxGraf,4] )
lOnlyTotH := Self:aGraf[nCbxGraf,5]
lOnlyTotV := Self:aGraf[nCbxGraf,6]

Self:Grafico( cTitulo, nColSerie, aCpoEntra, aCpoSai, lOnlyTotH, lOnlyTotV )
                       
Return(self)
//=================================================================================================================
// MyGrid():Grafico -                     Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Monta gráfico de barras padrão da classe
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros                     
// cTitulo     - Titulo da Dialog de Gráfico
// nColSerie   - Coluna responsável pelo título da série
// aCpoEntra   - Array com os campos que contem os valores da série. {{ "CAMPO","Descrição"},...}
// aCpoSai     - Array com os campos que não devem entrar nos valores {"CAMPO1","CAMPO2",...}  
// lOnlyTotH   - Totaliza a linha. PRECISA ter nColSerie
// lOnlyTotV   - Totaliza a vertical. Cada coluna será uma série
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method Grafico( cTitulo, nColSerie, aCpoEntra, aCpoSai, lOnlyTotH, lOnlyTotV  ) Class MyGrid
                   
Local oDlgGrf   := nil
Local oGraf     := nil
Local aSeries   := {}     
Local nLoop, nX, nSerie


Default nColSerie := 0
Default cTitulo   := "Gráfico"                        
Default aCpoEntra := {}
Default aCpoSai   := {}
Default lOnlyTotH := .f.
Default lOnlyTotV := .f. 

// Se não tem título para a série, não pode totalizar verticalmente
If Empty( nColSerie )
	lOnlyTotV := .f.
EndIf
                                           
// Não pode ter totalização na vertical e na horizontal. Ou um ou outro
lOnlyTotH := if( lOnlyTotV, .f., lOnlyTotH )                           
lOnlyTotV := if( lOnlyTotH, .f., lOnlyTotV )

oDlgGrf := uAdvPlDlg():New(cTítulo,.t.,.t.)

oGraf := TMSGraphic():new(0,0,oDlgGraf:oPnlCenter,,,,0,0)
oGraf:Align := CONTROL_ALIGN_ALLCLIENT

If lOnlyTotV
	// Grafico totalizando cada linha
	For nLoop := 1 to Len( Self:oGrid:aCols ) 
	
		nSerie := oGraf:CreateSerie( GRP_BAR, Self:oGrid:aCols[nLoop,nColSerie] )
		nSoma  := 0

		For nX := 1 to Len( Self:oGrid:aCols[nLoop] )-1
		
			// Se o campo não for numerico, não entra no somatorio
			If ValType( Self:oGrid:aCols[nLoop,nX] ) <> "N"
				Loop
			EndIf
			
			// Se o campo for o responsável pelo título da serie, não entra no somatório
			If nColSerie == nX
				Loop
			EndIf                                                                  
			
			// se o campo estiver em aCpoSai, não entra no somatório
			If ! Empty( aCpoSai )
				nScan := aScan( aCpoSai, { |x| Trim(Upper(x)) == Trim(Upper(Self:oGrid:aHeader[nX,X3CAMPO])) } )
				If nScan > 0
					Loop
				EndIf				
			EndIf
			
			// se o campo não estiver em aCpoEntra, não entra no somatório
			If ! Empty( aCpoEntra )
				nScan := aScan( aCpoEntra, { |x| Trim(Upper(x)) == Trim(Upper(Self:oGrid:aHeader[nX,X3CAMPO])) } )
				If Empty( nScan )
					Loop
				EndIf				
			EndIf
	
			nSoma += Self:oGrid:aCols[nLoop,nX]
			
		Next nX 
		
		// Adiciona o valor na série     
		oGraf:Add( nSerie, nSoma )
		
	Next nLoop

EndIf


oDlgGrf:Activate()

Return(self)

//=================================================================================================================
// MyGrid():Totaliza -                    Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Totaliza os campos
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method Totaliza( cTexto, nColuna, aCampos ) Class MyGrid
           
Local nLoop, nX, cTipo, nPos
Local nTamGrid := Len( ::oGrid:aCols )
Local aTotal   := Array(Len(Self:aHeader)+1)// aClone( Self:aCols[1] )

Default cTexto  := "***TOTAL"
Default nColuna := 1       
Default aCampos := {}   

::lTotaliza := .t.
                                                                                                             
// Se o Grid já tiver totalização, limpa a linha de total 
If ! Empty( ::oGrid:aCols )
	If ValType( ::oGrid:aCols[ nTamGrid, nColuna ] ) == "C" .and.  Trim(::oGrid:aCols[ nTamGrid, nColuna ]) == cTexto
		// Exclui a linha da aCols
		Adel( ::oGrid:aCols, nTamGrid   )
		ASize(::oGrid:aCols, nTamGrid-1 )
	EndIf
EndIf

// Faz o tratamento das cores da MyGrid()
bBlkBack := {|| if( ValType(Self) == "O", u_uGdBkCor( Self:oGrid ), nil ) }     
bBlkFore := {|| if( ValType(Self) == "O", u_uGdCor( Self:oGrid )  , nil ) }
If ValType( Self:oGrid:oBrowse ) == "O"
	Self:oGrid:oBrowse:lUseDefaultColors := .F. 
	Self:oGrid:oBrowse:SetBlkBackColor( bBlkBack )
	Self:oGrid:oBrowse:SetBlkColor( bBlkFore )
EndIf

For nX := 1 to Len( Self:aHeader )
	
	cTipo := Self:aHeader[nX,X3TIPO] 
	
	If cTipo == "C"
		If nX == nColuna
			aTotal[nX] := cTexto
		Else
			aTotal[nX] := " "
		EndIf
	EndIf
	
	If cTipo == "N"
		aTotal[nX] := 0
	EndIf
	
	If cTipo == "D"
		aTotal[nX] := CtoD("")
	EndIf
	
	If cTipo == "L"
		aTotal[nX] := .f.
	EndIf
	
Next nX                         

aTotal[Len(aTotal)] := .f.
     
// Define quais campos serão totalizados
If Empty( aCampos )
	For nLoop := 1 to Len(Self:aHeader)
		If Self:aHeader[nLoop,8] == "N"
			AAdd( aCampos, Self:aHeader[nLoop,2] )
			aTotal[nLoop] := 0
		EndIf 
	Next nLoop
EndIf                                   

// Executa a totalização dos campos
For nLoop := 1 to Len( Self:aCols )
                  
	For nX := 1 to Len( Self:aHeader )
		
		cTipo := ValType( Self:aCols[nLoop,nX] )
		
		If cTipo == "C"
			If nX == nColuna
				aTotal[nX] := cTexto
			Else
				aTotal[nX] := " "
			EndIf        
		EndIf
		
		If cTipo == "N"
			cCampo := Upper(Trim(Self:aHeader[nX,2]))
			nPos := aScan( aCampos, { |x| Upper(Trim(x)) == cCampo } )
			
			If nPos > 0
				nSoma      := Self:aCols[nLoop,nX]
				aTotal[nX] += nSoma
			Else
				aTotal[nX] := 0
			EndIf
		EndIf
		
		If cTipo == "D"
			aTotal[nX] := CtoD("")
		EndIf                    
		
		If cTipo == "L"
			aTotal[nX] := .f.
		EndIf
		
	Next nX
Next nLoop
                            
Self:AddLine(aTotal)      
nAtxxx1 := Len(Self:aCols)
nAtxxx1 := if( nAtxxx1 < 1, 1, nAtxxx1 )
Self:SetAt( nAtxxx1 )
Self:Refresh()
Self:SetAt(1) 
Self:Refresh()

Return(self) 
***************************************************************************************************************
//Verifica se determinada linha está deletada
Method IsDeleted(nRow) Class MyGrid

Local lRet := .F.

Default nRow := ::GetAt()

lRet := ::oGrid:aCols[nRow, ::nUsado+1]

Return(lRet)


//=================================================================================================================
// MyGrid():ClearCols() -                  Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Zera aCols
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros          
// nil
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method ClearCols() Class MyGrid

If ValType( Self:oGrid ) == "O" 
	Self:oGrid:aCols   := {}
EndIf

If ValType( Self:oBrowse ) == "O" 
	Self:aCols   := {}
EndIf

Return(self)

//=================================================================================================================
// MyGrid():ClearGrid() -                  Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Zera aHeader e aCols
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros          
// nil
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method ClearGrid() Class MyGrid
                  
Self:aCols   := {}
Self:aHeader := {}

Self:ClearCols()

If ValType( Self:oGrid ) == "O" 
	Self:oGrid:aHeader := {}
EndIf

If ValType( Self:oBrowse ) == "O" 
	Self:aHeader := {}
EndIf

Return(self)   

//=================================================================================================================
// MyGrid():IndexSet() -                  Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Prepara a MyGrid para indexação por usuário
// Deve ser carregada após as definições das colunas ( AddColumn, AddColSX3... ) porque utiliza as definições
// das colunas
// Deve ser carregada antes de Load para garantir que a btnbar da MyGrid seja criada
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros          
// aCampos - Campos da MyGrid que poderão ser indexados    { "CAMPO1", "CAMPO2",... } 
// lNoKeep - Não mantem os campos do filtro, sendo recarregados todas as vezes
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method IndexSet( aCampos, lNoKeep ) Class MyGrid

Local nLoop 

Default aCampos := {}        
Default lNoKeep := .f.

::aCpoDisp  := aClone( aCampos ) 
::aColsDisp := {}
::aColsOrd  := {}
::lBtnBar   := .t.

If ValType( ::aHeader ) <> "A" 
	::aColsDisp := {}
EndIf

// Adiciona os campos que podem ser utilizados nos indices
If ValType( ::aCpoDisp ) == "A" .and. Empty( ::aCpoDisp ) .and. ValType( ::aHeader ) == "A"
	For nLoop := 1 to Len( ::aHeader )   
		AAdd( ::aCpoDisp, ::aHeader[ nLoop, X3CAMPO ] )
	Next nLoop
EndIf                   
                     
//------------------------------------------------------------------
// Somente insere o botão na barra se a tela ainda não tiver sido
// carregada pelo método Load()
//------------------------------------------------------------------
If ! ::lLoaded
	Self:aBtnBar2[BTNBAR_ORGANIZA] := { "Organizar", { || Processa( {|| Self:IndexShow( lNoKeep ) },"Organizando Grid..." ) } }
EndIf
             
Return(self)

//=================================================================================================================
// MyGrid():IndexShow() -                  Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Mostra a Dialog de ordenação do Grid
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros          
// nil
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method IndexShow( lNoKeep ) Class MyGrid

Local oBtnCancel
Local oBtnDown
Local oBtnOk
Local oBtnUp
Local oBtnVai
Local oBtnVolta
Local oSay1
Local oSay2
Local oDlgOrd
Local oGdDisp
Local oGdOrd
Local oBtnBar        
Local oCbx
Local oHead
Local oPnl

Local nTamLin
Local nLoop
Local nScan  
Local aCLeft     := {}
Local aCRight    := {}
Local aHead      := {}
Local lOk        := .f.
Local lDescIndex := ::lDescIndex

Local cX       := ""
Local cY       := ""
Local cString  := ""
Local cStringX := ""
Local cStringY := ""
Local cBlock   := ""
Local nPos, cTipo, bBlock, aLinTotal

Default lNoKeep := .f.

// Monta o aHeader
AAdd( aHead, {"Descrição", "X3_TITULO", ""   , 20, 0, , "", "C", "" , "V", "", "", "", "V", "", "", ""} )
AAdd( aHead, {"Ordem"    , "X3_ORDEM" , "999", 03, 0, , "", "N", "" , "V", "", "", "", "V", "", "", ""} )


// Monta o aCols dos grid
If lNoKeep
    // Se não mantém o status dos campos, refaz o grid             
	::aCpoDisp := {}
	For nLoop := 1 to Len( ::aHeader )   
		AAdd( ::aCpoDisp, ::aHeader[ nLoop, X3CAMPO ] )
	Next nLoop

	::aColsDisp := {}
	::aColsOrd  := {}
EndIf

If Empty( ::aColsDisp ) .and. Empty( ::aColsOrd )
	For nLoop := 1 to Len( ::aCpoDisp )
		nScan := aScan( ::aHeader, {|x| Upper(Trim(x[X3CAMPO])) == Upper(Trim(::aCpoDisp[nLoop])) } )
		If Empty( nScan )
			Loop
		EndIf                       
		
		// Cabeçalho vazio não entra
		If Empty(::aHeader[ nScan, X3TITULO ])
			Loop
		EndIf 
		
		AAdd( ::aColsDisp, { ::aHeader[nLoop,X3TITULO], nScan, .f. } )
	Next nLoop
	AAdd( ::aColsOrd, { " ", 0, .f. } )
EndIf
                  
// Cria a dialog personalizada
DEFINE MSDIALOG oDlgOrd TITLE "Organizar Grid" FROM 000, 000  TO 250, 585 PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP)
         
oHead := DlgHead():New( oDlgOrd, "Grid | Organizar" )

oPanel:= TPanel():New( 0, 0, "", oDlgOrd, nil, nil, nil, nil, nil, 0, 0, .f., .f. )
oPanel:Align := CONTROL_ALIGN_ALLCLIENT     

@ 004, 005 SAY "Campos Disponíveis" SIZE 071, 007 OF oPanel PIXEL
oGdDisp:= MyGrid():New(012, 004, 110, 065, 0,,,,, , 99999,,,, oPanel )
oGdDisp:AddColumn(aHead[1])
oGdDisp:AddColumn(aHead[2])
oGdDisp:Load()                                     
oGdDisp:ClearCols()
oGdDisp:SetDoubleClick( {||OrdL2R(@oGdDisp, @oGdOrd)} )

// Adiciona as linhas da acols
For nLoop := 1 to Len( ::aColsDisp ) 
	oGdDisp:AddLine( ::aColsDisp[nLoop] )
Next nLoop           
oGdDisp:Refresh()
                 
// Ações também disponíveis via duplo clique nos grids
@ 025, 120 BUTTON oBtnVai   PROMPT ">" SIZE 013, 012 ACTION OrdL2R(@oGdDisp, @oGdOrd) OF oPanel PIXEL
@ 039, 120 BUTTON oBtnVolta PROMPT "<" SIZE 013, 012 ACTION OrdR2L(@oGdDisp, @oGdOrd) OF oPanel PIXEL

@ 004, 136 SAY "Ordem desejada" SIZE 072, 007 OF oPanel PIXEL
oGdOrd := MyGrid():New(012, 135, 110, 065, 0,,,,, , 99999,,,, oPanel )
oGdOrd:AddColumn(aHead[1])
oGdOrd:AddColumn(aHead[2])
oGdOrd:Load()
oGdOrd:ClearCols()
oGdOrd:SetDoubleClick( {||OrdR2L(@oGdDisp, @oGdOrd)} )

// Adiciona as linhas da acols
If ! Empty( ::aColsOrd )
	For nLoop := 1 to Len( ::aColsOrd ) 
		oGdOrd:AddLine( ::aColsOrd[nLoop] )
	Next nLoop
Else
	oGdOrd:AddLine( {" ",0,.f.} )
EndIf
oGdOrd:Refresh()

@ 025, 252 BUTTON oBtnUp   PROMPT "Acima"  SIZE 037, 012 ACTION OrdUp(@oGdOrd) OF oPanel PIXEL
@ 039, 252 BUTTON oBtnDown PROMPT "Abaixo" SIZE 037, 012 ACTION OrdDn(@oGdOrd) OF oPanel PIXEL

@ 080, 140 CHECKBOX oCbx VAR ::lDescIndex PROMPT "do maior para o menor" SIZE 095, 008 OF oPanel PIXEL

oBtnBar:= AdvplBar():New( oDlgOrd )
oBtnBar:AddButton( "Ok"      , {|| lOk := .t., ::aColsOrd := aClone(oGdOrd:oGrid:aCols) , oDlgOrd:End() } )
oBtnBar:AddButton( "Cancelar", {|| oDlgOrd:End() } ) 
aCRigth := aClone( oGdOrd:oGrid:aCols )

ACTIVATE MSDIALOG oDlgOrd CENTERED
                                 
                                    
// Aqui nTamLin = Linhas do Grid da Classe
nTamLin := Len( Self:oGrid:aCols )

// Caso tenha cancelado, garante que a ordem dos campos será mantida
If ! lOk           
	::lDescIndex := lDescIndex
	::aColsOrd   := aClone( aCRight )
	Return(self)
EndIf      

If Empty( oGdOrd:oGrid:aCols      ) .or. ; // Sem campo para indexar
   Empty( oGdOrd:oGrid:aCols[1,1] ) .or. ; // Sem campo para indexar
   nTamLin == 1 .or. ;                     // Grid só tem uma linha
   ( nTamLin < 3 .and. ::lTotaliza )       // Grid tem total e só uma linha de detalhe
	
	::lDescIndex := lDescIndex
	::aColsOrd   := aClone( aCRight )
	Return(self)

EndIf

cX       := ""
cY       := ""
cString  := ""
cStringX := ""
cStringY := ""
cBlock   := ""
                      
// Aqui nTamLin = linhas do grid de campos a indexar
nTamLin := Len( oGdOrd:oGrid:aCols )
For nLoop := 1 to nTamLin
	                                     
	// Posicao do campo no aHeader da Classe
	nPos   := oGdOrd:oGrid:aCols[nLoop,2]                    

	// Tipo do conteudo do aHeader da Classe
	cTipo  := Self:oGrid:aHeader[ nPos, X3TIPO  ]
	
	If cTipo == "C" 
		cX := "x["+AllTrim(Str(nPos))+"]"
		cY := "y["+AllTrim(Str(nPos))+"]"
	ElseIf cTipo == "N"
//		cX := "Str( x["+AllTrim(Str(nPos))+"] )"
//		cY := "Str( y["+AllTrim(Str(nPos))+"] )"
		cX := "if(x["+AllTrim(Str(nPos))+"] < 0,'0','1') + Transform(Abs(x["+AllTrim(Str(nPos))+"]),'@E 999,999,999.99')"
		cY := "if(y["+AllTrim(Str(nPos))+"] < 0,'0','1') + Transform(Abs(y["+AllTrim(Str(nPos))+"]),'@E 999,999,999.99')"

	ElseIf cTipo == "D"                       
		cX := "DtoS( x["+AllTrim(Str(nPos))+"] )"
		cY := "DtoS( y["+AllTrim(Str(nPos))+"] )"

	ElseIf cTipo == "L"
		cX := "if( x["+AllTrim(Str(nPos))+"], '1', '0' )"
		cY := "if( y["+AllTrim(Str(nPos))+"], '1', '0' )" 
	ElseIf cTipo == "M"                                                          
		Loop
	EndIf   
	
	cStringX += cX
	cStringY += cY
	
	If nLoop < nTamLin
		cStringX += "+"
		cStringY += "+"
	EndIf                                   
	
Next nLoop

If Empty( cStringX )
	Return(self)
EndIf

cBlock := "{ |x,y| " + cStringX +  if( ::lDescIndex," > "," < " ) + cStringY + " }"
bBlock := &(cBlock) 

aLinTotal := Self:oGrid:aCols[ Len(Self:oGrid:aCols) ] 

// Elimina a linha de total para evitar conflitos no indice
If ::lTotaliza
	ADel(  Self:oGrid:aCols,Len(Self:oGrid:aCols)  )                  
	ASize( Self:oGrid:aCols,Len(Self:oGrid:aCols)-1)
EndIf                       

// Indexa o grid
Processa( {||::IndexDo( bBlock )}, "Organizando grid..." )                        
                                                           
// Retorna a linha de total
If ::lTotaliza
	AAdd( Self:oGrid:aCols, aClone(aLinTotal) )
EndIf                       

::Self:Refresh()

Return(self)

//=================================================================================================================
// MyGrid():IndexDo() -                    Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Indexa a MyGrid
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros          
// bBlock - Código de bloco utilizado para indexar o array
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method IndexDo( bBlock ) Class MyGrid
ProcRegua(0)
IncProc()
aSort( Self:oGrid:aCols,,,bBlock )
Return(self) 

//=================================================================================================================
// MyGrid():FilterSet() -                    Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Ajusta a MyGrid para aceitar o filtro nos grids
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros          
// nil
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method FilterSet() Class MyGrid
             
::aColsOrig := {}  // aCols original, sem filtro
::aColsFil  := {}  // aCols do Grid de Filtro
::lBtnBar   := .t.
                     
//------------------------------------------------------------------
// Somente insere o botão na barra se a tela ainda não tiver sido
// carregada pelo método Load()
//------------------------------------------------------------------
If ! ::lLoaded
	::aBtnBar2[BTNBAR_FILTRO] := { "Filtro" , {|| Processa( {|| Self:FilterShow() },"Filtrando Grid...." ) } }
EndIf

Return(self)   

//=================================================================================================================
// MyGrid():SeekSet() -                    Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Ajusta a MyGrid para aceitar o pesquisa nos grids
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros          
// nil
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method SeekSet() Class MyGrid
             
::lSeekSet := .t.
                     
Return(self)   

//=================================================================================================================
// MyGrid():FilterShow() -                 Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Mostra a tela de filtro da MyGrid
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros          
// nil
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method FilterShow() Class MyGrid
             
Local nOk      := 0
Local oDlg                             
Local oBtnBar
Local oHead
Local oGrid
Local nLoop
Local cCampos := ""                                        
Local cCondic := "1=Igual;2=Maior;3=Maior ou Igual;4=Menor;5=Menor ou Igual;6=Contém;7=Não Contém;8=Diferente"
Local cOpera  := "1=e;2=ou;3=)"

//	Data aColsOrig // aCols original, sem filtro
//	Data aColsFil  // aCols do Grid de Filtro
//	Data lFiltra   // Grid utiliza ou não o recurso de filtro
                   
// Salva o aCols original ( sem filtro )
If Empty( Self:aColsOrig )
	Self:aColsOrig := aClone( Self:oGrid:aCols )
EndIf
                                                       
// Cria o combo para os campos
For nLoop := 1 to Len( Self:aHeader )
	If Empty( Self:aHeader[nLoop,X3TITULO] )
		Loop
	EndIf   
	cCampos += StrZero(nLoop,2) + "=" + Self:aHeader[nLoop,X3TITULO]
	cCampos += if( nLoop < Len( Self:aHeader ), ";", "" )
Next nLoop
                                                                                                      
DEFINE MSDIALOG oDlg TITLE "" FROM 000, 000  TO 500, 700 COLORS 0, 16777215 PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP)
         
oHead  := DlgHead():New( oDlg, "Grid | Filtro" )

oBtnBar:= AdvplBar():New( oDlg )
oBtnBar:AddButton( "Filtrar"      , {|| nOk := 1, oDlg:End() } )
oBtnBar:AddButton( "Limpar Filtro", {|| nOk := 2, oDlg:End() } )
oBtnBar:AddButton( "Cancelar"     , {|| oDlg:End() } ) 

oGrid := MyGrid():New(200, 200, 600, 600, GD_INSERT+GD_UPDATE+GD_DELETE,,,,,, 99999,,,, oDlg)

oGrid:AddColumn({"Parentese"  , "PARENTESE", "@!"   , 1  , 0, , "", "C", "" , "V", "1=("  , "", "", "A", "", "", ""})
oGrid:AddColumn({"Campo"      , "CAMPO"    , "@!"   , 2  , 0, , "", "C", "" , "V", cCampos, "", "", "A", "", "", ""})
oGrid:AddColumn({"Condição"   , "CONDICAO" , "@1"   , 1  , 0, , "", "C", "" , "V", cCondic, "", "", "A", "", "", ""})
oGrid:AddColumn({"Conteúdo"   , "CONTEUDO" , "@S40" , 512, 0, , "", "C", "" , "V", ""     , "", "", "A", "", "", ""})
oGrid:AddColumn({"Operador 1" , "OPERA1"   , "@1"   , 1  , 0, , "", "C", "" , "V", cOpera , "", "", "A", "", "", ""})
oGrid:AddColumn({"Operador 2" , "OPERA2"   , "@1"   , 1  , 0, , "", "C", "" , "V", cOpera , "", "", "A", "", "", ""})

oGrid:Load()
oGrid:SetAlignAllClient()

ACTIVATE MSDIALOG oDlg CENTERED

Return(self)

//=================================================================================================================
// MyGrid():SheetSet() -                  Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Ajusta a Classe para gerar planilha Excel
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros          
// ni
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method SheetSet( cPerg, cWSheet, cTitle ) Class MyGrid

::lBtnBar := .t.
            
//------------------------------------------------------------------
// Somente insere o botão na barra se a tela ainda não tiver sido
// carregada pelo método Load()
//------------------------------------------------------------------
If ! ::lLoaded
	::aBtnBar2[BTNBAR_PLANILHA] := { "Planilha", {|| u_AdvPlan( Self, ,cPerg, cWSheet, cTitle ) } }
EndIf

Return(self)
//=================================================================================================================
// MyGrid():ChangeSeek() -                 Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// bChange de ::oCbxSeek
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros          
// nil
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method ChangeSeek() Class MyGrid

Local nPos     := if( ::oCbxSeek:nAt < 1, 1, ::oCbxSeek:nAt )
Local aParams  := ::MyCriaVar( Val( SubStr( ::aItSeek[ npos ],1, 3 ) ) )
Local xConteudo:= aParams[1]
Local cTipo    := aParams[2]
Local cPicture := aParams[3]
Local nTamanho := aParams[4]
Local cF3      := aParams[5]                               

::cGetSeek := xConteudo                                 

If ValType( ::oGetSeek ) == "O"

//	If GetBuild() > "7.00.121227P" 
//		::oGetSeek:cPlaceHold := "<Informe o conteúdo a pesquisar>"
//	EndIf

	If ! Empty( cPicture )
		::oGetSeek:Picture := cPicture
	EndIf                             

	If ! Empty( cF3 )
		::oGetSeek:cF3 := cF3
	EndIf          

	::oGetSeek:CtrlRefresh()
Endif

Return(self)                                                     
//=================================================================================================================
// MyGrid():GridSeek() -                 Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Efetua a pesquisa dentro do grid
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros          
// lNext - Pesquisa o próximo
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method GridSeek( lNext ) Class MyGrid

Local xConteudo := ::cGetSeek 
Local nPos      := if( ::oCbxSeek:nAt < 1, 1, ::oCbxSeek:nAt )
Local nCol      := Val( SubStr( ::aItSeek[nPos],1,3 ) )
Local nRow      := ::GetAt()+1
Local nSeek     := 0
Local nTam      := 0
Local nLoop   

ProcRegua(0)
IncProc()

If ValType(::oGrid:aCols) <> "A" .or. Empty( ::oGrid:aCols )
	MsgInfo("Grid vazio") 
	Return(self)
EndIf                                              

If ValType( xConteudo ) == "C" 
	xConteudo := Trim(Upper(xConteudo)) 
	nTam      := Len(xConteudo)
EndIf         

For nLoop := if( lNext, nRow, 1) to Len(::oGrid:aCols)
    //IncProc("Analisando linha " + AllTrim(Str(nLoop)) )  
    If ValType( ::oGrid:aCols[nLoop,nCol] )  == ValType( xConteudo )
		If nTam > 0
			If Upper( SubStr( ::oGrid:aCols[nLoop,nCol],1,nTam ) ) == xConteudo
				nSeek := nLoop
				Exit
			EndIf
		Else        
			If ::oGrid:aCols[nLoop,nCol] == xConteudo
				nSeek := nLoop
				Exit
			EndIf
		EndIf
	EndIf
Next                        

If nSeek > 0
	Self:oGrid:oBrowse:SetFocus()
	Self:oGrid:GoTop()
	Self:oGrid:Goto( nSeek )
	Self:oGrid:oBrowse:SetFocus()
Else
	MsgInfo("Registro não encontrado")
	Self:oGrid:oBrowse:SetFocus()
EndIf                    
                            
Return(self)

//=================================================================================================================
// MyGrid():MyCriaVar() -                  Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Retorna um conteudo vazio de acordo com o campo na posicao de ::aHeader informada em nPosHead
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros          
// nPosHead - Posicao do ::aHeader para buscar as propriedades do campo
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// aRet - { conteudo, tipo, picture, tamanho )
//=================================================================================================================
Method MyCriaVar( nPosHead ) Class MyGrid

Local cPicture := AllTrim(::aHeader[nPosHead,X3PICTURE])
Local cTipo    := ::aHeader[nPosHead,X3TIPO] 
Local nTamanho := ::aHeader[nPosHead,X3TAMANHO]
Local cF3      := ::aHeader[nPosHead,X3F3]
Local xConteudo:= nil                   


Do Case
	Case cTipo == "C"
		xConteudo := Space( nTamanho )
	Case cTipo == "N"                 
		xConteudo := 0
	Case cTipo == "D" 
		xConteudo := CtoD("")
	Case cTipo == "L"       
		xConteudo := .f.
EndCase                 

Return( {xConteudo, cTipo, cPicture, nTamanho, cF3 } )


**********************************************************************************************************************
** Funções Auxiliares
**********************************************************************************************************************
//=================================================================================================================
// MyGrid():OrdDn() -                     Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Desce a linha posicionada
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros          
// oGdOrd  - MyGrid com os campos disponívels. Passado por referencia
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Static Function OrdDn( oGdOrd )

Local nLinha  := oGdOrd:oGrid:nAt
Local aLinha1 := {}
Local aLinha2 := {}

If Empty( oGdOrd:oGrid:aCols )
	Return()
EndIf
              
// Se estiver na última linha, não tem como descer mais
If nLinha == Len( oGdOrd:oGrid:aCols )
	Return()
EndIf
                          
// Captura os conteúdos da linha posicionada no grid e da linha
// imediatamente abaixo
aLinha1 := aClone( oGdOrd:oGrid:aCols[ nLinha    ] )
aLinha2 := aClone( oGdOrd:oGrid:aCols[ nLinha +1 ] )
                                                                                  
// Inverte as posições das linhas
oGdOrd:oGrid:aCols[ nLinha   ] := aClone( aLinha2 )
oGdOrd:oGrid:aCols[ nLinha+1 ] := aClone( aLinha1 )
oGdOrd:Refresh()
oGdOrd:oGrid:GoTo( nLinha+1 )
oGdOrd:oGrid:oBrowse:SetFocus()

Return()

//=================================================================================================================
// MyGrid():OrdDn() -                     Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Sobe a linha posicionada
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros          
// oGdOrd  - MyGrid com os campos disponívels. Passado por referencia
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Static Function OrdUp( oGdOrd )

Local nLinha  := oGdOrd:oGrid:nAt
Local aLinha1 := {}
Local aLinha2 := {}
                                     
If Empty( oGdOrd:oGrid:aCols )
	Return()
EndIf 

If nLinha == 1
	Return()
EndIf
              
// Captura os conteúdos a linha imediatamente acima e da linha posicionada no grid
aLinha1 := aClone( oGdOrd:oGrid:aCols[ nLinha-1 ] )
aLinha2 := aClone( oGdOrd:oGrid:aCols[ nLinha   ] )
                                                                                  
// Inverte as posições das linhas
oGdOrd:oGrid:aCols[ nLinha-1 ] := aClone( aLinha2 )
oGdOrd:oGrid:aCols[ nLinha   ] := aClone( aLinha1 )
oGdOrd:Refresh()
oGdOrd:oGrid:GoTo( nLinha-1 )
oGdOrd:oGrid:oBrowse:SetFocus()
Return()

//=================================================================================================================
// MyGrid():OrdL2R() -                     Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// ::ShowIndex() - Passa um campo disponível para indexação para o grid de campos indexáveis
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros          
// oGdDisp - MyGrid com os campos disponiveis. Passado por referencia
// oGdOrd  - MyGrid com os campos disponívels. Passado por referencia
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Static Function OrdL2R( oGdDisp, oGdOrd )

Local nLinDisp
Local nLinOrd  := 0
Local nOrdem   := 0

If ! Empty( oGdOrd:oGrid:aCols[1,1] )
	nLinOrd  := aScan( oGdOrd:oGrid:aCols, {|x| x[2] == nOrdem } ) 
EndIf

// Não deixa colocar o mesmo campo 2x na grid de indexação
If nLinOrd > 0
	MsgInfo("Este campo já está indexado")
	Return(nil)
EndIf

nLinDisp := oGdDisp:oGrid:nAt  
nOrdem   := oGdDisp:oGrid:aCols[ nLinDisp, 2 ]

If Empty( oGdOrd:oGrid:aCols[1,1] )
	oGdOrd:oGrid:aCols[1] := aClone( oGdDisp:oGrid:aCols[ nLinDisp ] )
Else
	oGdOrd:AddLine(  aClone( oGdDisp:oGrid:aCols[ nLinDisp ] ) )
EndIf
oGdOrd:Refresh()

Return()

//=================================================================================================================
// MyGrid():OrdR2L() -                     Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// ::ShowIndex() - Passa um campo indexado para o grid de campos disponíveis
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros          
// oGdDisp - MyGrid com os campos disponiveis. Passado por referencia
// oGdOrd  - MyGrid com os campos disponívels. Passado por referencia
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Static Function OrdR2L( oGdDisp, oGdOrd ) 

Local nLinDisp, nLinha, nSize, cCampo

If Empty( oGdOrd:oGrid:aCols )
	MsgInfo( "Grid vazio" )
	Return(nil)
EndIf

nLinha := oGdOrd:oGrid:nAt
nSize  := Len( oGdOrd:oGrid:aCols )
   
// Remove a linha posicionada do Grid
aDel(  oGdOrd:oGrid:aCols, nLinha    )

// Ajusta o tamanho de acols   
aSize( oGdOrd:oGrid:aCols, nSize - 1 )
                     
// Sempre deixa pelo menos uma linha vazia no grid
If Empty( oGdOrd:oGrid:aCols )
	oGdOrd:AddLine( { " ", 0, .f. } )
EndIf
 
oGdOrd:Refresh()

Return()

//=================================================================================================================
// MyGrid():MarkSet() -                    Alessandro de Barros Freire                               - Março / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// ::MarkSet( ) - Habilita a MyGrid a Trabalhar como MarkBrowse
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros          
// oGdDisp - MyGrid com os campos disponiveis. Passado por referencia
// oGdOrd  - MyGrid com os campos disponívels. Passado por referencia
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Method MarkSet( lAllMark ) Class MyGrid
                               
Local bDblClick  := { || Self:Marca() }
Default lAllMark := .f.

Self:lIsMarkSet  := .t.
Self:lAllMark    := lAllMark
                
Self:AddColBMP("MARCA", IF(lAllMark,"LBTIK","LBNO"), 1, "   " )

Return(self)
******************************************************************************************************************                                    
Method Marca( lMark, nLineMark ) Class MyGrid

Local nLinha  := 0
Local cName   := "" 

Default nLineMark := Self:GetAt()

nLinha := nLineMark
cName  := Self:oGrid:aCols[ nLinha, 1 ]

//--------------------------------------------------
// Força marcar ou desmarcar o campo
//--------------------------------------------------
If ValType( lMark ) == "L"
	If lMark
		cName := "LBNO" 
	Else
		cName := "LBTIK"
	EndIf
EndIf

If cName == "LBTIK"
	Self:oGrid:aCols[nLinha,1] := "LBNO" 
Else
	Self:oGrid:aCols[nLinha,1] := "LBTIK"
EndIf                               
                  
//-----------------------------------------
// Executa uma rotina ao marcar/desmarcar  
//-----------------------------------------
If ValType( Self:bOnMark ) == "B" 
	Eval( Self:bOnMark )
EndIf
      
Self:oGrid:oBrowse:DrawSelect()

Return(self)
******************************************************************************************************************
Method OnMark( bOnMark ) Class MyGrid

Self:bOnMark := bOnMark

Return(self)

******************************************************************************************************************                                    
Method IsMarked( nLinha ) Class MyGrid 

Local nLinha := if( ValType(nLinha) <> "N", Self:GetAt(), nLinha )
Local cName  := Self:oGrid:aCols[ nLinha, 1 ]
Local lRet   := .f.

If cName == "LBTIK"
	lRet := .t.
EndIf                               

Return( lRet )

//==========================================================================================
// MyGrid():SetF3() - Alessandro Freire - Março / 2016
//------------------------------------------------------------------------------------------
// Descrição
// Adiciona uma Consulta F3 sem utilizar o SXB
//------------------------------------------------------------------------------------------
// Parametro
// cCampo     - Campo que receberá o F3
// cFunction  - Nome da função que executará o F3. O retorno desta função deve ser:
//              { cSql, aCampos, cCampo de retorno }
//              cSql    - String contendo a query
//              aCampos - aHeader
//              cCampo  - Campo contido em cSql que deverá ser retornado
// cTitulo    - Título da Dialog da consulta F3
//------------------------------------------------------------------------------------------
// Obs.: Deve ser chamada depois que MyGrid():aHeader estiver preenchido
//------------------------------------------------------------------------------------------
// Retorno
// nil
//==========================================================================================
Method SetF3( cCampo, cFunc, cTitulo ) Class MyGrid 

Local nPosHead := aScan( Self:aHeader, {|x| Trim(Upper(x[2]))==Trim(Upper(cCampo)) } )
Local cX3WHEN  := ""
Local cX3VALID := ""

Default cTitulo := ""

//---------------------------------------
// Define o F3 para o campo
//---------------------------------------
If nPosHead > 0
	cX3WHEN := Trim( Self:aHeader[nPosHead,X3WHEN] )
	cX3WHEN += if( !Empty(cX3WHEN), " .and. ", "" ) + "u_AdvplF3( '"+cTitulo+"', '"+cCampo+"', '"+cFunc+"' )"
	Self:aHeader[nPosHead,X3WHEN] := cX3WHEN
EndIf

//---------------------------------------
// Retira o F3 do campo
//---------------------------------------
If nPosHead > 0
	cX3VALID := Trim( Self:aHeader[nPosHead,X3VALID] )
	cX3VALID += if( !Empty(cX3VALID), " .and. ", "" ) + "STATICCALL(ADVPLF3,UNSETF3)"
	Self:aHeader[nPosHead,X3VALID] := cX3VALID
EndIf

Return(self)

//=================================================================================================================
// uGdBkCor -                                    Alessandro Freire                                  - Abril / 2015
//-----------------------------------------------------------------------------------------------------------------
// Muda a cor do fundo da última linha da getdados
//-----------------------------------------------------------------------------------------------------------------
// Parametros
// oGrid - Objeto da classe myGrid
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nRet  - Cor no formato RGB
//=================================================================================================================
User Function uGDBkCor( oGrid )

Local nCorImpar := RGB(255,255,255) // branco
Local lPar      := .t.
Local lUltima   := .f.
Local nRet

If ValType( oGrid ) == "U"
	Return() 
EndIf

lPar      := Mod(oGrid:oBrowse:nAt,2) == 0
lUltima   := ( oGrid:oBrowse:nAt == Len(oGrid:aCols) )

nRet := nCorImpar

If lUltima
	nRet := RGB(32,55,100)
EndIf        

Return nRet

//=================================================================================================================
// uGdCor -                                      Alessandro Freire                                  - Abril / 2015
//-----------------------------------------------------------------------------------------------------------------
// Muda a cor da letra da última linha da getdados
//-----------------------------------------------------------------------------------------------------------------
// Parametros
// oGrid - Objeto da classe myGrid
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nRet  - Cor no formato RGB
//=================================================================================================================
User Function uGdCor( oGrid )

Local nRet    := RGB(0,0,0) // preto
Local lUltima := .f.

If ValType( oGrid ) == "U"
	Return( nRet ) 
EndIf

lUltima := ( oGrid:oBrowse:nAt == Len(oGrid:aCols) )

If lUltima
	nRet := RGB(255,255,255) // branco
EndIf        

Return nRet
