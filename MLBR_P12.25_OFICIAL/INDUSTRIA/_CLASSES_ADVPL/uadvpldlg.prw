#include "totvs.ch"
#include "advpltec.ch"

#DEFINE CLR_FRONT  16777215
#DEFINE CLR_BACKG  7884319

//============================================================================================
// Classe uAdvPlDlg()  -               Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Cria Dialog padrão da ADVPL
//--------------------------------------------------------------------------------------------
// Parâmetros
// nil
//--------------------------------------------------------------------------------------------
// Retorno
// nil
//============================================================================================
      
CLASS uAdvPlDlg
        
Data oPnlTop
Data lPnlTop 
Data oPnlCenter

Data lConfirmClose
Data cMsgClose
Data bBefore

Data oBtnBar
Data lBtnBar   
Data lDoubleBar                
Data aSize

Data oDlg
Data cText1
Data cText2

Method New() Constructor
Method SetText1()
Method SetText2()
Method AddButton()          
Method Close()
Method SetInit()
Method Activate()
Method ConfirmClose() // Exibe uma mensagem antes de fechar a dialog
Method BeforeClose()  // Executa um codeblock antes de fechar a dialog
Method SetDoubleBar() // Barra de botoes mais alta

ENDCLASS

//============================================================================================
// uAdvPlDlg():New()  -                Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Construtor da classe
//--------------------------------------------------------------------------------------------
// Parâmetros
// cTitulo - Titulo da Dialog
// lPnlTop - Mostra o painel de título
// lBtnBar - Mostra o painel de botoes
//--------------------------------------------------------------------------------------------
// Retorno
// nil
//============================================================================================
Method New( cText1, lPnlTop, lBtnBar, cText2, nCor, nAltura, nLargura, lDoubleBar ) CLASS UAdvPlDlg

Local aSize      := MsAdvSize(.T.)

Default cText1    := "TOTVS"
Default lPnlTop   := .t. 
Default lBtnBar   := .t.                         
Default cText2    := ""
Default nAltura   := 100
Default nLargura  := 100
Default lDoubleBar:= .f.

Self:cText1        := cText1        
Self:cText2        := cText2
Self:lPnlTop       := lPnlTop
Self:lBtnBar       := lBtnBar
Self:cMsgClose     := ""
Self:lConfirmClose := .f.
Self:aSize         := aClone( aSize )
Self:bBefore       := {||.t.}
Self:lDoubleBar    := lDoubleBar
         
DEFINE MSDIALOG Self:oDlg TITLE Self:cText1 FROM 000, 000  TO (aSize[6]/100*nAltura), (aSize[5]/100*nLargura) PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP)
                                
// Cria o painel com o título
If Self:lPnlTop
	Self:oPnlTop := DlgHead():New( Self:oDlg, Self:cText1, Self:cText2, nCor )
EndIf                  

// Cria o painel para os botões
If Self:lBtnBar
	Self:oBtnBar := AdvplBar():New( Self:oDlg, ,Self:lDoubleBar )
	Self:oBtnBar:BarAlignBottom()     
	Self:AddButton( "Fechar" , {|| Self:Close( Self:lConfirmClose ) }, BTN_CLOSE )
EndIf                             

// Cria o painel central da dialog, onde os objetos devem ser distribuídos
@ 000, 000 MSPANEL Self:oPnlCenter SIZE 250, 013 OF Self:oDlg
Self:oPnlCenter:Align := CONTROL_ALIGN_ALLCLIENT
                                                             
Return( Self )
//*****************************************************************************************************
Method SetDoubleBar() Class uAdvplDlg
	Self:lDoubleBar := .t.
	If Valtype( Self:oBtnBar ) == "O"
		Self:oBtnBar:SetDoubleBar()
	EndIf
	If ValType( Self:oPnlCenter ) == "O"
		Self:oPnlCenter:Align := CONTROL_ALIGN_ALLCLIENT
		Self:oPnlCenter:Refresh()
	EndIf
Return( nil )

//============================================================================================
// uAdvPlDlg():SetInit()  -            Alessandro Freire                        - Marco / 2016
//--------------------------------------------------------------------------------------------
// Descrição
// Configura a inicialização da dialog
//--------------------------------------------------------------------------------------------
// Parâmetros
// bInit   - Bloco de código
//--------------------------------------------------------------------------------------------
// Retorno
// nil
//============================================================================================
METHOD SetInit( bBlock ) Class uAdvPlDlg

DEFAULT bBlock := { || .t. }
Self:oDlg:bInit := { || Eval(bBlock), Self:oPnlCenter:Align := CONTROL_ALIGN_ALLCLIENT, Self:oPnlCenter:Refresh() }

Return( nil )
//============================================================================================
// uAdvPlDlg():Activate()  -           Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Ativa a dialog 
//--------------------------------------------------------------------------------------------
// Parâmetros
// cLabel - Label do botao
// bBlock - Codigo de bloco com a acao do botao
//--------------------------------------------------------------------------------------------
// Retorno
// nil
//============================================================================================
Method AddButton( cLabel, bBlock, nStyle, cLeftRight ) CLASS UAdvPlDlg

Default nStyle := BTN_DEFAULT

If ! Self:lBtnBar
	Self:lBtnBar := .t.
	Self:oBtnBar := AdvplBar():New( Self:oDlg, ,Self:lDoubleBar )
	Self:oBtnBar:BarAlignBottom()
EndIf                             

Self:oBtnBar:AddButton( cLabel, bBlock, nStyle, cLeftRight )
                                               
Return( nil )

//============================================================================================
// uAdvPlDlg():Activate()  -           Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Ativa a dialog 
//--------------------------------------------------------------------------------------------
// Parâmetros
// nil
//--------------------------------------------------------------------------------------------
// Retorno
// nil
//============================================================================================
Method Activate( ) CLASS UAdvPlDlg

Self:oDlg:Activate(,,,.T.)

Return( nil ) 

//============================================================================================
// uAdvPlDlg():Close() -              Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Fecha a janela 
//--------------------------------------------------------------------------------------------
// Parâmetros
// nil
//--------------------------------------------------------------------------------------------
// Retorno
// nil
//============================================================================================
Method Close( lAsk ) CLASS UAdvPlDlg
                 
Local lClose   := .t.
Default lAsk   := .f.

If lAsk
	lClose := MsgYesNo( Self:cMsgClose )
EndIf

If lClose
	//------------------------------------
	// Executa o codeblock passado
	// no método BeforeClose()
	//------------------------------------
	Eval( Self:bBefore )
	Self:oDlg:End()
EndIf

Return( nil )                                                        
**************************************************************************************************
Method SetText1( cText1 ) CLASS uAdvPlDlg
If ValType(Self:oPnlTop) == "O"
	Self:oPnlTop:SetText1( cText1 )
EndIf
Return( nil )
**************************************************************************************************
Method SetText2( cText2 ) CLASS uAdvPlDlg
If ValType(Self:oPnlTop) == "O"
	Self:oPnlTop:SetText2( cText2 )
EndIf
Return( nil )

***********************************************************************************************
CLASS DlgHead
                
Data oPanel                                                                               
Data cText1
Data cText2
Data oText1
Data oText2

Method New() Constructor
Method SetText1()
Method SetText2()
Method SetText( cText, nLinha )

ENDCLASS
***********************************************************************************************
Method New( oDlg, cText1, cText2, nCor ) Class DlgHead

Local oFont1    := TFont():New("Arial",,022,,.T.,,,,,.F.,.F.)
Local nClrFront := CLR_FRONT
Local nClrBack  := CLR_BACKG

Default cText1 := "AdvPl Tecnologia" 
Default cText2 := "by AdvPl Tecnologia"
Default nCor   := 3

If Empty( cText2 )                     
	cText2 := "by AdvPl Tecnologia"
EndIf              

Do Case
                                             
	//---------------------------------------------------------------------------------
	// referencia de cores: http://erikasarti.net/html/tabela-cores/
	//---------------------------------------------------------------------------------
	Case nCor == 3 // Padrão ou Inclusão
		nClrFront := CLR_FRONT
		nClrBack  := CLR_BACKG
		nClrPnl1  := "#4682B4" // SteelBlue
		nClrPnl2  := "#DCDCDC" // Gainsboro
	Case nCor == 4 // Alteração
		nClrFront := CLR_WHITE   
		nClrBack  := Rgb(191,143,0) // Mostarda
		nClrPnl1  := "#FF8C00" // DarkOrange
		nClrPnl2  := "#FFD700" // Gold
	Case nCor == 5 // Exclusão
		nClrFront := CLR_WHITE   
		nClrBack  := Rgb(139,0,0) // vermelho
		nClrPnl1  := "#8B0000" // DarkRed
		nClrPnl2  := "#FFA07A" // LightSalmon
	Case nCor == 6
		nClrFront := CLR_WHITE
		nClrBack  := Rgb(0,128,128) // verde
		nClrPnl1  := "#006400" // DarkGreen
		nClrPnl2  := "#90EE90" // LightGreen
EndCase

Self:cText1    := " " + cText1
Self:cText2    := "  " + cText2

Self:oPanel:= TPanel():New( 0, 0, "", oDlg, nil, nil, nil, nil, nil, 20, 20, .f., .f. )
Self:oPanel:SetCss("QFrame{ background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 "+nClrPnl1+", stop: 1 "+nClrPnl2+");}")

@ 000, 000 SAY Self:oText1 PROMPT Self:cText1 SIZE 249, 014 OF Self:oPanel FONT oFont1 COLORS  nClrFront, nClrBack PIXEL
@ 014, 000 SAY Self:oText2 PROMPT Self:cText2 SIZE 249, 007 OF Self:oPanel             COLORS  nClrFront, nClrBack PIXEL


Self:oPanel:Align := CONTROL_ALIGN_TOP
Self:oText1:Align := CONTROL_ALIGN_ALLCLIENT
Self:oText2:Align := CONTROL_ALIGN_BOTTOM

Return( Self )            

***********************************************************************************************
Method SetText1( cText1 ) Class DlgHead
Self:cText1 := " " + cText1
Self:oText1:SetText( Self:cText1 )
Self:oText1:CtrlRefresh()
Return( nil )    

***********************************************************************************************
Method SetText2( cText2 ) Class DlgHead
Self:cText2 := "  " + cText2
Self:oText2:SetText( Self:cText2 )
Self:oText2:CtrlRefresh()
Return( nil )    
***********************************************************************************************
Method SetText( cText, nLinha ) Class DlgHead

Default nLinha := 1

If nLinha == 1
	Self:SetText1( cText ) 
Else
	Self:SetText2( cText )
EndIf                    

Return( nil )

***********************************************************************************************
Method ConfirmClose( cMsgClose ) CLASS uAdvplDlg

Default cMsgClose := "Deseja sair da rotina?"

Self:cMsgClose     := cMsgClose
Self:lConfirmClose := .t.

Return(nil)

***********************************************************************************************
Method BeforeClose( bBefore ) CLASS uAdvplDlg
Self:bBefore := bBefore
Return( nil )

***********************************************************************************************
***********************************************************************************************
***********************************************************************************************
***********************************************************************************************
CLASS AdvplBar

Data oPanel
Data aBtn
Data cBarAlign
Data cBtnAlign
Data lDoubleBar

Method New() Constructor
Method AddButton()
Method BarAlignBottom()
Method BarAlignTop()
Method BtnAlignLeft()
Method BtnAlignRight()
Method GetCss(cClass)
Method SetDoubleBar()

ENDCLASS   

***********************************************************************************************
Method New( oDlg, nCor, lDoubleBar ) Class AdvplBar
                
Local nClrFront
Local nClrBack   

Default nCor       := 3
Default lDoubleBar := .f.

Self:aBtn      := {}
Self:cBarAlign := "B"
Self:cBtnAlign := "R"
Self:lDoubleBar:= lDoubleBar

Do Case
	Case nCor == 1
		nClrFront := CLR_FRONT
		nClrBack  := CLR_BACKG
	Case nCor == 2
		nClrFront := Rgb(0,0,0) // Preto
		nClrBack  := Rgb(155,194,230) // Azul claro
	Case nCor == 3
		nClrFront := Rgb(0,0,0) // Preto
		nClrBack  := Rgb(255,255,255) // Branco
EndCase
              
@ 000, 000 MSPANEL Self:oPanel SIZE 250, 011 OF oDlg COLORS nClrFront, nClrBack
If Self:lDoubleBar
	Self:oPanel:Move(Self:oPanel:nTop,Self:oPanel:nLeft,Self:oPanel:nWidth,Self:oPanel:nHeight*2,,.T.)
EndIf

Self:BarAlignBottom()
              
Return( Self )                      

//*****************************************************************************************************
Method SetDoubleBar() Class AdvplBar
	Self:lDoubleBar := .t.
	Self:oPanel:Move(Self:oPanel:nTop,Self:oPanel:nLeft,Self:oPanel:nWidth,Self:oPanel:nHeight*2,,.T.)
	If Self:cBarAlign == "B"
		Self:BarAlignBottom()
	Else
		Self:BarAlignTop()
	EndIf
	Self:oPanel:Refresh()
Return( nil )


***********************************************************************************************
Method AddButton( cLabel, bAction, nStyle, cLeftRight ) Class AdvplBar
Local oBtn
Local nTam := Len(Trim(cLabel))*3.5

Default nStyle := BTN_DEFAULT

nTam := if( nTam < 40, 40, nTam )

oBtn := TButton():New( 000, 199, cLabel, Self:oPanel, bAction, nTam, 011,,,, .t.)
oBtn:SetCss( Self:GetCss(nStyle) )

If ValType( cLeftRight ) == "C"
	cLeftRight := Upper( cLeftRight )
Else
	cLeftRight := Self:cBtnAlign
EndIf

If cLeftRight == "L"
	oBtn:Align := CONTROL_ALIGN_LEFT
Else
	oBtn:Align := CONTROL_ALIGN_RIGHT
EndIf
AAdd( Self:aBtn, oBtn  )

Return( nil )
***********************************************************************************************
Method BarAlignBottom() CLASS AdvplBar
Self:oPanel:Align := CONTROL_ALIGN_BOTTOM
Self:cBarAlign    := "B"
Return( nil )
***********************************************************************************************
Method BarAlignTop() CLASS AdvplBar
Self:oPanel:Align := CONTROL_ALIGN_TOP
Self:cBarAlign    := "T"
Return( nil )
***********************************************************************************************
Method BtnAlignLeft() CLASS AdvplBar
          
Local nLoop

For nLoop := 1 to Len( Self:aBtn )
	Self:aBtn[nLoop]:Align := CONTROL_ALIGN_LEFT
Next nLoop                                     

Self:cBtnAlign := "L"

Return( nil ) 
***********************************************************************************************
Method BtnAlignRight() CLASS AdvplBar
          
Local nLoop

For nLoop := 1 to Len( Self:aBtn )
	Self:aBtn[nLoop]:Align := CONTROL_ALIGN_RIGHT
Next nLoop                                     

Self:cBtnAlign := "R"

Return( nil )

***********************************************************************************************

Method GetCss(nClass) CLASS AdvplBar
	Local cCss := ""

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
	
	
	Do Case
		Case	nClass == BTN_CLOSE
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:			11px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
			cCSS += 'QPushButton			{ border-radius:		3px             ; }'
			cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #F6F7FA, stop: 1 #DADBDE ); }'
			cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				1px 1px 1px 1px; }'
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #DADBDE, stop: 1 #F6F7FA ); }'
			cCSS += 'QPushButton			{ font:				bold            ; }'
			cCSS += 'QPushButton			{ margin:				1px 1px 1px 1px; }'
			
		/***** Definimos o CSS do Botao Confirmar da barra deMenu *****/
		Case	nClass == BTN_CONFIRM
			
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
			cCSS += 'QPushButton			{ margin:				1px 1px 1px 1px; }'
			cCSS += 'QPushButton:pressed	{ background-color: qlineargradient(spread:pad, x1:0.494591, y1:0, x2:0.528, y2:1, stop:0.619318 rgba(254, 191, 4, 255), stop:0.892045 rgba(255, 214, 94, 255)); }'
			
		/***** Definimos o CSS do Botao Confirmar da barra deMenu *****/
		Case	nClass == BTN_MAIS
			
			cCSS := 'QPushButton        { font-family: Verdana  ; }'
			cCSS += 'QPushButton        { font:        bold     ; }'
			cCSS += 'QPushButton        { border:      none     ; }' 
			cCSS += 'QPushButton        { font-size:   10px     ; }'
			cCSS += 'QPushButton:hover  { color:       #2A80B9  ; }'
			cCSS += 'QPushButton:pressed{ color:       #FFFFFF  ; }' 
			
		/***** Definimos o CSS dos objetos da Classe TBUTTON *****/
		Case	nClass == BTN_DEFAULT
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		10px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
			cCSS += 'QPushButton			{ border-radius:	3px             ; }'
			cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #D4DFFF, stop: 1 #A2B1DB ); }'
			cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				1px 1px 1px 1px; }'
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #A2B1DB, stop: 1 #D4DFFF ); }'
		Case	nClass == BTN_PRIMARY
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		09px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
			cCSS += 'QPushButton			{ border-radius:	3px             ; }'
			cCSS += 'QPushButton			{ color:	#FFFFFF             ; }'    		
			cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #92B5D4, stop: 1 #3071A9 ); }'
			cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				1px 1px 1px 1px; }'
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #3071A9, stop: 1 #92B5D4 ); }'			

		Case	nClass == BTN_DANGER
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		09px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
			cCSS += 'QPushButton			{ border-radius:	3px             ; }'
			cCSS += 'QPushButton			{ color:	#FFFFFF             ; }'    
			cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #E37B78, stop: 1 #C9302C ); }'
			cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				1px 1px 1px 1px; }'
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #C9302C, stop: 1 #E37B78 ); }'						

		Case	nClass == BTN_SUCCESS
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		09px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
			cCSS += 'QPushButton			{ border-radius:	3px             ; }'
			cCSS += 'QPushButton			{ color:	#FFFFFF             ; }'                                  
			cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #8BC98B, stop: 1 #449D44 ); }'
			cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				1px 1px 1px 1px; }'
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #449D44, stop: 1 #8BC98B ); }'						

		Case	nClass == BTN_INFO
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		09px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
			cCSS += 'QPushButton			{ border-radius:	3px             ; }'
			cCSS += 'QPushButton			{ color:	#FFFFFF             ; }'        		                                                                                                                  
			cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #9ECFDE, stop: 1 #5bc0de ); }'
			cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				1px 1px 1px 1px; }'
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #5bc0de, stop: 1 #9ECFDE ); }'						

		Case	nClass == BTN_WARNING
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		09px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
			cCSS += 'QPushButton			{ border-radius:	3px             ; }'
			cCSS += 'QPushButton			{ color:	#FFFFFF             ; }'        		                                                                                                                  
			cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #EDC893, stop: 1 #F0AD4E ); }'
			cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				1px 1px 1px 1px; }'
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #F0AD4E, stop: 1 #EDC893 ); }'						
	EndCase
Return(cCss)