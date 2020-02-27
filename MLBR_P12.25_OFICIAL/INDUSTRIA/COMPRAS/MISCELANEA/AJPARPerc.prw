#Include "Protheus.ch"
#Include "Rwmake.ch" 
/*---------------------------------------------------------
Função: AJPARPerc 	|Autor: AOliveira  |Data: 26-07-2011
-----------------------------------------------------------
Descr.: Tela para alteração de Parametro especifico no SX6
---------------------------------------------------------*/
User Function AJPARPerc()   

Local aSays := {}                       
Local aButtons := {}
Local nOpca := 0 
Local _nVlPerc:= ""
Private cTitulo := OemToAnsi("Parametro Percentual de Entrada")

aAdd(aSays,OemToAnsi("Rotina tem como objetivo Realizar alteração no Parametro de Percentual "))
aAdd(aSays,OemToAnsi("para Tolerancia de Entrada.                                            "))
aAdd(aSays,OemToAnsi("                                                                       "))
aAdd(aSays,OemToAnsi("                                                                       "))
aAdd(aSays,OemToAnsi("                                                                       "))
aAdd(aSays,OemToAnsi("                                                                       "))
aAdd(aButtons, { 5, .T., {|| _nVlPerc := bAltPerc() } } ) //Carrega botao de alteração do parâmetros
aAdd(aButtons, { 1, .T., {|o| nOpca := 1, IF(gpconfOK(), FechaBatch(), nOpca:=0) }} ) //Se selecionar botao Ok. Executa alteração e fecha tela de entrada
aAdd(aButtons, { 2, .T., {|o| FechaBatch() }} ) //Se selecionado botao Cancelar, fecha tela de entrada.

FormBatch(cTitulo,aSays,aButtons) //Exibe Tela de entrada

IF ( nOpca == 1 )
	PUTMV("EP_PERCENTR", _nVlPerc) //Altera SX6
EndIF


Return( NIL )                 
      
/*-----------------*/
Static Function bAltPerc() 

Local nVlPerc := ""
Local nOpc := 0
Local cRet := ""   

/*Cria Parametro caso não exista*/
DbSelectArea("SX6")
DbSetorder(1)
DbgoTop()
Dbseek(xFilial()+"EP_PERCENTR")
If !Found()
	Reclock("SX6",.T.)
	SX6->X6_FIL:=xFilial()
	SX6->X6_VAR:="EP_PERCENTR"
	SX6->X6_TIPO:="N"
	SX6->X6_CONTEUD:= "1.03"
	SX6->X6_DESCRIC:="% de tolerancia de entrada"
	MsUnlock()
Endif
                   
nVlPerc := GetMV("EP_PERCENTR")

DEFINE MSDIALOG _oDlg TITLE "Percentual" FROM C(273),C(346) TO C(350),C(484) PIXEL
@ C(007),C(005) MsGet oEdit1 Var nVlPerc Size C(057),C(009) COLOR CLR_BLACK PIXEL OF _oDlg PICTURE "@R 9.99" VALID !Empty(nVlPerc)
DEFINE SBUTTON FROM C(022),C(005) TYPE 1 ENABLE OF _oDlg ACTION(nOpc:=1,_oDlg:End())
DEFINE SBUTTON FROM C(022),C(037) TYPE 2 ENABLE OF _oDlg ACTION(_oDlg:End())
ACTIVATE MSDIALOG _oDlg CENTERED
If nOpc == 1
	cRet:=nVlPerc
EndIf                           

Return(cRet)