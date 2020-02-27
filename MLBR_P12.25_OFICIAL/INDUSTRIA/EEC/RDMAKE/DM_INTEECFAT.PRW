#Include "Protheus.ch"
#Include "Rwmake.ch" 
// #########################################################################################
// Descri√ß√£o: Define Integra√ß√£o EIC x COM esta ativa
// ----------+------------------------	+-----------------------------------------------------
// 06/06/15  | Willer Trindade Nery 	| Modulo Gest√£o EIC
// ----------+------------------------	+-----------------------------------------------------
User Function DM_INTEECFAT()   

Local aSays 	:= {}                       
Local aButtons 	:= {}
Local nOpca 	:= 0 
Local cFalTrue  := GetMV("MV_EECFAT")
Local _cFalTrue := cValToChar(cFalTrue)
Private cTitulo := OemToAnsi("Parametro IntegraÁ„o Exportacao x Faturamento")

aAdd(aSays,OemToAnsi("Rotina tem como objetivo realizar alteraÁao no"))
aAdd(aSays,OemToAnsi("parametro IntegraÁ„o Exportacao x Faturamento (.F. Desabilitado ou .T. habilitado)."))
aAdd(aSays,OemToAnsi("O conteudo atual È " + " - " + _cFalTrue))
aAdd(aSays,OemToAnsi("Sempre verificar a integraÁao, pois afeta o funcionamento do sistema.(MV_EECFAT)."))

aAdd(aButtons, { 5, .T., {|| _cFalTrue := bAltPerc() } } ) //Carrega botao de altera√ß√£o do par√¢metros
aAdd(aButtons, { 1, .T., {|o| nOpca := 1, IF(gpconfOK(), FechaBatch(), nOpca:=0) }} ) //Se selecionar botao Ok. Executa altera√ß√£o e fecha tela de entrada
aAdd(aButtons, { 2, .T., {|o| FechaBatch() }} ) //Se selecionado botao Cancelar, fecha tela de entrada.

FormBatch(cTitulo,aSays,aButtons) //Exibe Tela de entrada

IF ( nOpca == 1 )
	PUTMV("MV_EECFAT", _cFalTrue) //Altera SX6
EndIF


Return( Nil ) 
/*-----------------*/
Static Function bAltPerc() 

Local nOpc := 0
Local cRet := "" 
Local aItems  := {".T.",".F."}  
Local cCombo  := " "


DEFINE MSDIALOG _oDlg TITLE "Desabilita ou Habilita" FROM C(273),C(346) TO C(350),C(484) PIXEL
@ C(007),C(005) COMBOBOX cCombo ITEMS aItems Size C(057),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
DEFINE SBUTTON FROM C(022),C(005) TYPE 1 ENABLE OF _oDlg ACTION(nOpc:=1,_oDlg:End())
DEFINE SBUTTON FROM C(022),C(037) TYPE 2 ENABLE OF _oDlg ACTION(_oDlg:End())
ACTIVATE MSDIALOG _oDlg CENTERED
If nOpc == 1
	cRet:=cCombo
EndIf                           

Return(cRet) 