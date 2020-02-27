#Include "Protheus.ch"
#Include "Rwmake.ch" 
// #########################################################################################
// Descrição: Define Data para disponibilizar comprovante pagamento mensal no portal RH
// ----------+------------------------	+-----------------------------------------------------
// 06/06/15  | Willer Trindade Nery 	| Modulo Gestão de Pessoal
// ----------+------------------------	+-----------------------------------------------------
User Function WN_TCFDFOL()   

Local aSays 	:= {}                       
Local aButtons 	:= {}
Local nOpca 	:= 0 
Local cFilAtu 	:= cFilAnt
Local cFalTrue  := GetMv( "MV_TCFDFOL" )
Local _cFalTrue := cValToChar(cFalTrue)
Local cFilAtu 	:= cFilAnt
Private cTitulo := OemToAnsi("Parâmetro Liberação Hollerith no Portal")

aAdd(aSays,OemToAnsi("Rotina tem como objetivo efetuar mudança quantidade de dias considerando"))
aAdd(aSays,OemToAnsi("último dia do mes a qual será disponibilizado consulta do Hollerith"))
aAdd(aSays,OemToAnsi("O conteúdo atual é " + " = " + _cFalTrue))
aAdd(aSays,OemToAnsi("O conteudo poderá ser negativo se deseja liberar antes do ultimo dia do mes,"))
aAdd(aSays,OemToAnsi("Ex: -1, será liberado dia 30 no mes 31"))
aAdd(aSays,OemToAnsi("Esta liberação é feita por filial, checar filial a qual entrou no sistema"))

aAdd(aButtons, { 5, .T., {|| _cFalTrue := bAltPerc() } } ) //Carrega botao de alteração do parâmetros
aAdd(aButtons, { 1, .T., {|o| nOpca := 1, IF(gpconfOK(), FechaBatch(), nOpca:=0) }} ) //Se selecionar botao Ok. Executa alteração e fecha tela de entrada
aAdd(aButtons, { 2, .T., {|o| FechaBatch() }} ) //Se selecionado botao Cancelar, fecha tela de entrada.

FormBatch(cTitulo,aSays,aButtons) //Exibe Tela de entrada

IF ( nOpca == 1 )
	PUTMV("MV_TCFDFOL", _cFalTrue) //Altera SX6
EndIF


Return( Nil ) 
/*-----------------*/
Static Function bAltPerc() 

Local nOpc := 0
Local cRet := "" 
Local aItems  := {"S","N"}  
Local cCombo  := " "


DEFINE MSDIALOG _oDlg TITLE "Informe numero de dias" FROM C(273),C(346) TO C(350),C(484) PIXEL
@ C(007),C(005) COMBOBOX cCombo ITEMS aItems Size C(057),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
DEFINE SBUTTON FROM C(022),C(005) TYPE 1 ENABLE OF _oDlg ACTION(nOpc:=1,_oDlg:End())
DEFINE SBUTTON FROM C(022),C(037) TYPE 2 ENABLE OF _oDlg ACTION(_oDlg:End())
ACTIVATE MSDIALOG _oDlg CENTERED
If nOpc == 1
	cRet:=cCombo
EndIf                           

Return(cRet) 