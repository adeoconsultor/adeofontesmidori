#Include "Protheus.ch"
#Include "Rwmake.ch" 
// #########################################################################################
// Descrição: Define Integração EEC x FIN esta ativa
// ----------+------------------------	+-----------------------------------------------------
// 06/06/15  | Willer Trindade Nery 	| Modulo Gestão EEC
// ----------+------------------------	+-----------------------------------------------------
User Function WT_INTFIN()   

Local aSays 	:= {}                       
Local aButtons 	:= {}
Local nOpca 	:= 0 
Local cFalTrue  := GetMV("MV_AVG0131")
Local _cFalTrue := cValToChar(cFalTrue)
Private cTitulo := OemToAnsi("Parâmetro Integração EEC x FIN")

aAdd(aSays,OemToAnsi("Rotina tem como objetivo realizar alteração no"))
aAdd(aSays,OemToAnsi("parametro Integração EEC x FIN (Coloque F para desabilitar ou T para habilitar)."))
aAdd(aSays,OemToAnsi("O conteúdo atual é " + " - " + _cFalTrue))
aAdd(aSays,OemToAnsi("Sempre verificar a integração, pois afeta o funcionamento"))
aAdd(aSays,OemToAnsi("do sistema e os títulos de recebimento no financeiro."))

aAdd(aButtons, { 5, .T., {|| _cFalTrue := bAltPerc() } } ) //Carrega botao de alteração do parâmetros
aAdd(aButtons, { 1, .T., {|o| nOpca := 1, IF(gpconfOK(), FechaBatch(), nOpca:=0) }} ) //Se selecionar botao Ok. Executa alteração e fecha tela de entrada
aAdd(aButtons, { 2, .T., {|o| FechaBatch() }} ) //Se selecionado botao Cancelar, fecha tela de entrada.

FormBatch(cTitulo,aSays,aButtons) //Exibe Tela de entrada

IF ( nOpca == 1 )
	PUTMV("MV_AVG0131", _cFalTrue) //Altera SX6
EndIF


Return( Nil ) 
/*-----------------*/
Static Function bAltPerc() 

Local nOpc := 0
Local cRet := "" 
Local aItems  := {".F.",".T."}  
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