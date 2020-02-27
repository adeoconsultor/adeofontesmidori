#include 'totvs.ch'

#define CSS_BTN_GREY      1
#define CSS_BTN_GREEN     2
#define CSS_BTN_RED       3
#define CSS_BTN_YELLOW    4
#define CSS_BTN_BLUE      5
#define CSS_BTN_ORANGE    6
#define CSS_BTN_PINK      7

/*/{Protheus.doc} TAdvplDialog
Classe utilizada para montar dialog padrão Advpl Tecnologia
@author Alessandro Freire
@since 27/06/2017
@version 1.0
@example
(examples)

/*/
class TAdvplDialog

	data aTitle
	data aBtn
	data aBtnAux
	data aLabelSize
	data aSaySize

	data MainContainer // objeto MSDIALOG
	data BorderPanel
	data MainPanel
	data ButtonPanel
	data TitlePanel

	data lButtonBar

	data bOnClose
	data bOnInit
	data nHeight
	data nWidth


	method new( cTitle ) constructor
	method DisableButtonBar() // Remove a barra de botões
	method EnableButtonBar()  // Adiciona a barra de botões
	method addButton( cLabel, bAction, cGlyph, cToolTip, nStyle )        // Adiciona um botão na barra de botões
	method TitleText( cTitle, cCss, nOption )     // Adiciona um texto da Dialog
	method ClassInit() // Inicializador da Dialog, após ela ser mostrada para o usuário. Utilizado internamente
	method SetInit()   // Monta o bInit da Dialog chamando o ClassInit()

	method OnInit( bOnInit ) // imediatamente antes de abrir a dialog
	method OnClose( bOnClose ) // imediatamente antes de fechar a dialog
	method Close() // fecha a dialog
	method SetSize( nPAltura, nPLargura ) // Percentual de altura e largura
	Method StyleButton( oBtn, nStyle )  // Estilo CSS do botão
	method Activate()


endclass

//========================================================================================================================
/*/{Protheus.doc} new
Metodo construtor. São criados 3 painéis:
TitlePanel=Painél com o título da dialog
MainPanel=Painel central, onde deverão ser dispostos os objetos
ButtonPanel=Painel com a barra de botões

@author Alessandro Freire
@since 27/06/2017
@version AdvplLib 2.0
@example
oDlg:=TAdvplDialog():New( {"Titulo Linha 1", "Titulo Linha 2"}, .t., 100, 100 )
@param caTitle, array ou character, Linha de texto para o header da dialog
@param [nHeight], numeric, % Altura da Dialog
@param [nWidth], numeric, % Largura da Dialog
/*/
//========================================================================================================================
method new( caTitle, lButtonBar, nHeight, nWidth, cClrBack1, cClrBack2 ) class TAdvplDialog

	Local aTitle    := {}
	Local nLoop     := 1

	Local aSize      := MsAdvSize(.T.)

	Local nSizeBtn   := 0
	Local nLoop1     := 0
	Local nLoop2     := 0

	Default cClrBack1  := "#4682B4"
	Default cClrBack2  := cClrBack1

	Default caTitle    := ""
	Default nHeight    := 100 // Altura da dialog
	Default nWidth     := 100 // Largura da dialog
	Default lButtonBar := .t.

	If ValType( caTitle ) == "A"
		For nLoop := 1 to Len( caTitle )
			aAdd( aTitle, caTitle[nLoop] )
			// somente 2 linhas para título e subtitulo
			If nLoop > 2
				Exit
			EndIf
		Next nLoop
	ElseIf ValType( caTitle ) == "C"
		aAdd( aTitle, caTitle )
		aAdd( aTitle, "" )
	Else
		aAdd( aTitle, "" ) 
		aAdd( aTitle, "" )
	EndIf

	::aBtn       := {}
	::aBtnAux    := {}
	::aTitle     := { {"",nil,nil} ,{"",nil,nil} }
	::aLabelSize := {16,12 }
	::aSaySize   := {10 ,8 }

	::bOnInit    := {||.t.}
	::bOnClose   := {||.t.}

	::lButtonBar := .t.

	::nHeight    := 100 // Altura em % da tela
	::nWidth     := 100 // Largura em % da tela

	// Cria a dialog
	DEFINE MSDIALOG ::MainContainer TITLE "" FROM 000, 000  TO (aSize[6]/100*::nHeight), (aSize[5]/100*::nWidth) PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP)

	// Cria o painel de titulo
	::TitlePanel:= TPanel():New( 0, 0, "", ::MainContainer, nil, nil, nil, nil, nil, 20, 20, .f., .f. )
	::TitlePanel:SetCss("QFrame{ background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 "+cClrBack1+", stop: 1 "+cClrBack2+");}")
	::TitlePanel:Align := CONTROL_ALIGN_TOP

	For nLoop := 1 to Len( aTitle )
		::TitleText( aTitle[nLoop],,nLoop )
	Next nLoop

	// Cria o painel de botoes
	If ::lButtonBar
		@ 000, 000 MSPANEL ::ButtonPanel SIZE 250, 020 OF ::MainContainer
		::ButtonPanel:Align := CONTROL_ALIGN_BOTTOM
	EndIf

	// Cria o painel principal
	@ 000, 000 MSPANEL ::MainPanel SIZE 250, 011 OF ::MainContainer
	::MainPanel:Align := CONTROL_ALIGN_ALLCLIENT

return( Self )

//========================================================================================================================
/*/{Protheus.doc} DisableButtonBar
Não mostra a barra de botões na dialog
@author Alessandro Freire
@since 31/07/2017
@version AdvplLib 2.0
/*/
method DisableButtonBar() class TAdvplDialog
	::lButtonBar := .f.
Return( Self )

//========================================================================================================================
method EnableButtonBar() class TAdvplDialog
	::lButtonBar := .t.
Return( Self )

//========================================================================================================================
/*/{Protheus.doc} addButton
Adiciona um botão na barra inferior da dialog
@author Alessandro Freire
@since 31/07/2017
@version AdvplLib 2.0
@param cLabel, characters, Label do botão
@param bAction, block, Bloco de código com a ação do botão
@param [cGlyph], characters, Image do botão. atualmente só aceita .png. Pode ser utilizado um recurso do rpo.
@param [cToolTip], characters, Tooltip do botão
@param [nStyle], numeric, Cor do botão. pode ser:
cinza=1 | verde = 2 | vermelho = 3 | amarelo = 4 | azul = 5 | laranja = 6 | rosa = 7
@param [cCss], character, Caso nenhum formato padrão atenda o desenvolvedor poderá informar uma string CSS para formatar o botão
/*/
//========================================================================================================================
method addButton( cLabel, bAction, cGlyph, cToolTip, nStyle, cCss ) class TAdvplDialog

	//Local oBtn
	//Local nTam := Len(Trim(cLabel))*3.5

	If ValType( nStyle ) == "U" .and. ValType( cCss ) == "U"
		// Verifica se nStyle ou cCss foram informados
		Default nStyle := 1
		Default cCss   := StyleButton( nStyle,cGlyph )

	ElseIf ValType( nStyle ) == "N"
		// Ou nStyle ou cCss devem ser informados. Nunca os dois. Preferência por nStyle
		nStyle  := if( nStyle > 7 .or. Empty(nStyle) , CSS_BTN_GREY, nStyle )
		cCss    := StyleButton(nStyle,cGlyph)

	EndIf

	Self:lButtonBar := .t.

	aAdd( ::aBtnAux, { cLabel, bAction, cGlyph, cToolTip, cCss } )

Return( Self )
//=======================================================================================================================
METHOD StyleButton( oBtn, nStyle, cGlyph ) Class TAdvplDialog
	Local cCss := StaticCall(TAdvplDialog,STYLEBUTTON,NSTYLE,CGLYPH)
	oBtn:SetCss( cCss )
	oBtn:Refresh()
Return( Self )

//=======================================================================================================================
/*/{Protheus.doc} TitleText
Edita a 1a ou 2a linha de título da Dialog
@author Alessandro Freire
@since 31/07/2017
@version AdvplLib 2.0
@param cTitle, characters, Título da Dialog
@param [cCss], characters, CSS desejado pelo usuário
@param nLine, numeric, linha do título. Pode ser 1 ou 2.
/*/
METHOD TitleText( cTitle, cCss, nLine ) Class TAdvplDialog

	// Só modifica o texto se a linha for informada
	If ValType( nLine ) <> "N"
		Return( Self )
	EndIf

	// Só aceita 2 linhas de título
	If nLine > 2
		Return( Self )
	EndIf

	// Verifica se mantém o CSS ou atualiza
	If ValType( cCss ) == "U"
		If ValType( ::aTitle[nLine,2] ) == "U"
			cCss := StyleSay( "TSay" , "Calibri" , ::aLabelSize[ nLine ] , nLine == 1 )
		Else
			cCss := ::aTitle[nLine,2]
		EndIf
	EndIf

	::aTitle[nLine,1] := cTitle
	::aTitle[nLine,2] := cCss

	// Se a dialog já estiver aberta, atualiza o objeto TSay correspondente
	If Valtype( ::aTitle[nLine,3] ) == "O"
		::aTitle[nLine,3]:SetText( ::aTitle[nLine,1] )
		::aTitle[nLine,3]:SetCss( cCss )
		::aTitle[nLine,3]:CtrlRefresh()
	EndIf

Return( Self )
//======================================================================================================================
/*/{Protheus.doc} Activate
Monta a Dialog e a mostra na tela
@author Alessandro Freire
@since 31/07/2017
@version undefined
@param [cClrBack1], characters, Cor inicial da barra de título
@param [cClrBack2], characters, Cor final da barra de título
/*/
Method Activate( cClrBack1, cClrBack2 ) class TAdvplDialog


	// configura o bInit da Dialog
	::MainContainer:bInit := { || ::classInit(), Eval(::bOnInit) }

	// Mostra a dialog para o usuário
	::MainContainer:Activate(,,,.T.)

Return(self)
//=======================================================================================================================
/*/{Protheus.doc} classInit
Método interno da classe. Não deve ser utilizado
@author Alessandro Freire
@since 28/07/2017
@version AdvplLib 2.0
/*/
//=======================================================================================================================
method classInit() class TAdvplDialog

	Local nLoop1, nLoop2, oText

	Local nSizeBtn
	Local nSizeBtn
	Local cLabel
	Local bAction
	Local cGlyph
	Local cToolTip
	Local cCss
	Local oBtn
	Local oText


		@ 000, 000 SAY ::aTitle[1,3] PROMPT ::aTitle[1,1] SIZE 249, ::aSaySize[1] OF ::TitlePanel PIXEL
		::aTitle[1,3]:Align := CONTROL_ALIGN_TOP
		::aTitle[1,3]:SetCss( ::aTitle[1,2] )

		@ 000, 000 SAY ::aTitle[2,3] PROMPT ::aTitle[2,1] SIZE 249, ::aSaySize[2] OF ::TitlePanel PIXEL
		::aTitle[2,3]:Align := CONTROL_ALIGN_TOP
		::aTitle[2,3]:SetCss( ::aTitle[2,2] )

	// Cria o painel de botões
	If ::lButtonBar

		For nLoop2 := 1 to Len( ::aBtnAux )

			//aAdd( ::aBtnAux, { cLabel, bAction, cGlyph, cToolTip, cCss } )

			nSizeBtn := Len(Trim(::aBtnAux[nLoop2,1]))*3.5
			nSizeBtn := if( nSizeBtn < 40, 40, nSizeBtn )
			cLabel   := Trim(::aBtnAux[nLoop2,1])
			bAction  := if( Len(::aBtnAux[nLoop2]) >= 2, ::aBtnAux[nLoop2,2], {||.t.} )
			cGlyph   := if( Len(::aBtnAux[nLoop2]) >= 3, ::aBtnAux[nLoop2,3], nil )
			cToolTip := if( Len(::aBtnAux[nLoop2]) >= 4, ::aBtnAux[nLoop2,4], nil )
			cCss     := if( Len(::aBtnAux[nLoop2]) >= 5, ::aBtnAux[nLoop2,5], nil )

			oBtn:= TButton():New( 000, 199, cLabel, ::ButtonPanel, bAction, nSizeBtn, 011,,,, .t.,,cToolTip )
			oBtn:SetCss( cCss )
			oBtn:Align := CONTROL_ALIGN_RIGHT

			AAdd( ::aBtn, oBtn  )

		Next nLoop2

	EndIf


Return( self )

//=======================================================================================================================
/*/{Protheus.doc} onInit
Código de bloco com a execução após a montagem da dialog.
@author Alessandro Freire
@since 28/07/2017
@version AdvplLib 2.0
@param bOnInit, block, codeblock definido pelo usuário para ser executado na inicialização da dialog
/*/
//=======================================================================================================================
method onInit( bOnInit ) class TAdvplDialog

	::bOnInit := bOnInit

Return( self )

//=======================================================================================================================
/*/{Protheus.doc} close
Fecha a Dialog
@author Alessandro Freire
@since 28/07/2017
@version AdvplLib 2.0
/*/
//=======================================================================================================================
method close() class TAdvplDialog

	If Eval( ::bOnClose )
		::mainContainer:End()
	EndIf

return( self )

//=======================================================================================================================
/*/{Protheus.doc} OnClose
Envia o bloco de código que deve ser realizado para validar se Fecha ou não a Dialog.
@author Alessandro Freire
@since 31/07/2017
@version AdvplLib 2.0
@param bOnClose, block, Código de bloco que deve ser executado ao se encerrar uma dialog. Deve Retornar .t. ou .f.
/*/
//=======================================================================================================================
method OnClose( bOnClose ) class TAdvplDialog

default bOnClose := {||.t.}

::bOnClose := bOnClose

return( self )

//=======================================================================================================================
//=======================================================================================================================
//=======================================================================================================================
Static Function StyleButton(nStyle,cGlyph)

	Local cCss         := ""
	Local cColorHover  := "#2A80B9"
	Local cColorBorder := "#777777"
	Local aStyle       := {}
	Local cFont        := "Arial"
	DEFAULT nStyle := 1

	nStyle := if( nStyle > 7 .or. nStyle < 1, 1, nStyle )

	/*
	#define CSS_BTN_GREY      1
	#define CSS_BTN_GREEN     2
	#define CSS_BTN_RED       3
	#define CSS_BTN_YELLOW    4
	#define CSS_BTN_BLUE      5
	#define CSS_BTN_ORANGE    6
	#define CSS_BTN_PINK      7
	*/

	aAdd( aStyle, {"#A9A9A9","#D3D3D3"} ) // DarkGrey, LightGrey
	aAdd( aStyle, {"#00FF7F","#90EE90"} ) // SpringGreen, LightGreen
	aAdd( aStyle, {"#FF6347","#FFA07A"} ) // Tomato, LightSalmon
	aAdd( aStyle, {"#FFD700","#F0E68C"} ) // Gold, Khaki
	aAdd( aStyle, {"#6495ED","#ADD8E6"} ) // CornFlowerBlue, LightBlue
	aAdd( aStyle, {"#FF8C00","#FFA500"} ) // DarkOrange, Orange
	aAdd( aStyle, {"#F08080","#FFC0CB"} ) // LightCoral, Pink

	cCSS += 'QPushButton         { background-color: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 '+aStyle[nStyle,2]+', stop: 1 '+aStyle[nStyle,2]+' ); }'
	cCSS += 'QPushButton:pressed { background-color: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 '+aStyle[nStyle,2]+', stop: 1 '+aStyle[nStyle,1]+' ); '
	cCss +=                      ' border-style: inset;}'
	cCSS += 'QPushButton:hover   { font: bold; border-width:2px; border-style:solid; border-color: #1E90FF; }'

	cCSS += 'QPushButton         { font-family: '+cFont+'; }'
	cCSS += 'QPushButton         { font-size: 10px; }'
	cCSS += 'QPushButton         { border-width: 1px; }'
	cCSS += 'QPushButton         { border-style: outset; }'
	cCSS += 'QPushButton         { border-color: '+cColorBorder+'; }'
	cCSS += 'QPushButton         { border-radius: 3px; }'
	cCSS += 'QPushButton         { min-width: 20px; }'
	cCSS += 'QPushButton         { margin: 2px 2px 2px 2px; }'
	cCSS += 'QPushButton         { font: bold; }'

	If Valtype( cGlyph ) <> "U"
		//cCss += 'QPushButton    { icon:url(rpo:'+cGlyph+'.png); } "


		 cCss += "QPushButton    {background-image:url(rpo:"+cGlyph+".png);} "
		 cCss += "QPushButton    {background-repeat: no-repeat;}"
		 cCss += "QPushButton    {background-attachment: fixed;}"
		 cCss += "QPushButton    {padding-left:25px;} "

	EndIf

Return(cCss)

//==================================================================================================================
Static Function StyleSay( cObject, cFamily, nSize, lBold, cForeGnd, cBackGnd, cAlign )

	Default cObject  := "QlineEdit" // pode ser "TGet" também
	Default cFamily  := "Century Gothic"
	Default nSize    := 10
	Default lBold    := .f.
	Default cForeGnd := "white"


	cRet := cObject
	cRet += "{"
	cRet += "color: "+cForeGnd+"; "

	If ValType(cBackGnd) == "C"
		cRet += "background-color: "+cBackGnd+"; "
	EndIf

	//cRet += "font-family: " + cFamily + "; "
	cRet += "font-name: "+cFamily+"; "
	cRet += "font: " +if(lBold, "bold ", "" ) + AllTrim(Str(nSize))+"px; "

	If ValType(cAlign) == "C"
		cRet += "text-align: "+cAlign+"; "
	EndIf

	cRet += "}"

	//cRet :=  if(lSay,"TSay","TGet") + "{ color: "+cHexa+"; font-family: consolas; font: bold "+AllTrim(Str(nSize))+"px; }"

Return( cRet )



User Function tGetBrumbers()
 Local cNome := Space(100) //Irei declarar uma variável chamada cNome do tipo string para o meu campo nome
 Local cEstiloNom := "" //Irei declarer uma variavel chamada cEstiloNom do tipo string para inserir meu estilo

 //Irei criar uma janela
 DEFINE DIALOG oDlg TITLE "Usando estilos CSS no Protheus" FROM 180,180 TO 550,700 PIXEL

 /*Para funcionar, é preciso utilizar a classe QLineEdit ele será responsável para o correto desenvolvimento do estilo que será utilizado no meu objeto.
 Para quem já conhece CSS, verá que é exatamente o mesmo código utilizado para uma página web.
 A apresentação de imagens nos objetos criados podem ser resgatados de dentro do repositório (RPO), exemplificando ficaria assim: (rpo:imagemqueexistenorepositorio.png)
 */

 cEstiloNom := "QLineEdit{ border: 1px solid gray;border-radius: 5px;background-color: #ffffff;selection-background-color: #ffffff;"
 cEstiloNom += "background-image:url(rpo:responsa.png); "
 cEstiloNom += "background-repeat: no-repeat;"
 cEstiloNom += "background-attachment: fixed;"
 cEstiloNom += "padding-left:25px; "
 cEstiloNom += "}"

 /*Agora criamos o nosso objeto tGet normalmente*/
 oNome := TGet():New( 01,10,{|| cNome },oDlg,200,011,"",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cNome",,,,,,,"Nome: ",1 )

 /*Neste momento, para definirmos o estilo, usaremos a propriedade SetCss, no qual informaremos a ela a variavel que contém o estilo que criamos anteriormente.*/
 oNome:SetCss(cEstiloNom)

 //Finalizamos a janela
 ACTIVATE DIALOG oDlg CENTERED

Return //Finalizamos o programa
