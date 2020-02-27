#include "totvs.ch"

*******************************************************************************************************************
// Classe de Log
*******************************************************************************************************************

CLASS AdvplLog
           
Data cHeader
Data cTexto 

Method New() Constructor
Method AddText()
Method Show()

ENDCLASS

*******************************************************************************************************************
// Classe de Log
*******************************************************************************************************************
Method New( cHeader ) Class AdvPlLog


Default cHeader := "Log do sistema"

::cTexto  := ""
::cHeader := cHeader 

Return( Self )

*******************************************************************************************************************
// Classe de Log
*******************************************************************************************************************
Method AddText( cText ) Class AdvPlLog

Default cText := " "   

::cTexto += cText + CRLF

Return( nil )

*******************************************************************************************************************
// Classe de Log
*******************************************************************************************************************
Method Show() Class AdvPlLog

Local oHead, oBar, oTxt
Local oDlg          

DEFINE MSDIALOG oDlg TITLE ::cHeader FROM 000, 000  TO 500, 500 PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP)

oHead := DlgHead():New( oDlg, ::cHeader )    
oBar  := AdvPlBar():New( oDlg )
oBar:AddButton( "Fechar", {||oDlg:End()} )

@ 020, 000 GET oTxt VAR ::cTexto OF oDlg MULTILINE SIZE 250, 209 READONLY HSCROLL PIXEL
oTxt:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTERED

Return( nil )