#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


///////////////////////////////////////////////////////////////////////////////
//Função com objetivo de permitir ao departamento de custo bloquear e desbloquear 
//o a movimentacao de estoque dentro de um periodo
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria anesio@anesio.com.br - 05-06-2014
///////////////////////////////////////////////////////////////////////////////

user function AG_BLQMOV()
Private cData      := getmv('MV_DBLQMOV')

SetPrvt("oFont1","oDlgBlq","oSaay1","oGet1","oBtnConfirma","oBtnFecha")

oFont1     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oDlgBlq    := MSDialog():New( 113,324,227,646,"Bloqueia Movtos Estoques",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 012,004,{||"Bloquear até a data: "},oDlgBlq,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
oGet1      := TGet():New( 012,092,{|u| If(PCount()>0,cData:=u,cData)},oDlgBlq,056,010,'@r 99/99/9999',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cData",,)
oBtnConfir := TButton():New( 032,068,"&Confirmar",oDlgBlq, {|| oDlgBlq:end(), BLQMOV()},036,012,,,,.T.,,"",,,,.F. )
oBtnFecha  := TButton():New( 032,111,"&Fechar",oDlgBlq,{|| oDlgBlq:end()},037,012,,,,.T.,,"",,,,.F. )

oDlgBlq:Activate(,,,.T.)

return

//////////////////////////////////////////////////////////////////////////////////////////////
//função de bloqueio
static function BLQMOV()
local lRet := .T.
hora:= A680ConvHora(time(), "N", "C")
if apmsgnoyes("Confirma a alteração do parametro MV_DBLQMOV para a data selecionada?"+chr(13)+chr(13)+"FICARÁ GRAVADO LOG DESSA OPERACAO","ATENÇÃO")
	putmv("MV_DBLQMOV",cData)
		RecLock("AIF",.T.)
		AIF->AIF_TABELA := "SX6"
		AIF->AIF_CODPRO := ""
		AIF->AIF_CAMPO  := "MV_DBLQMOV"
		AIF->AIF_CONTEU := "ALTERADO PARA " +DtoC(cData)+" POR "+cUserName+" EM "+DtoC(Date())+" AS "+hora
		AIF->AIF_DATA   := dDataBase 
		AIF->AIF_HORA   := substr(time(),1,5)
		MsUnlock("AIF")
		Alert("Executado com sucesso....")
else
	Alert("Operacão cancelada...")
endif

return


///////////////////////////////////////////////////////////////////////////////
//Função com objetivo de permitir ao departamento de ativo imobilizado
//a bloquear a entrada de ativo com produtos que já sofreram inclusao
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria anesio@anesio.com.br - 10-06-2014
///////////////////////////////////////////////////////////////////////////////
user function AG_BLQATV()
Local aSays 	:= {}                       
Local aButtons 	:= {}
Local nOpca 	:= 0 
Local cFilAtu 	:= cFilAnt
Local cFalTrue  := SuperGetMv( "MA_VLDGR90" , .F. )
Local _cFalTrue := cValToChar(cFalTrue)
Local cFilAtu 	:= cFilAnt
Private cTitulo := OemToAnsi("Bloqueio Movimento Ativo Duplicado")

aAdd(aSays,OemToAnsi("Rotina tem como objetivo liberar/bloquear movimentações de ativo duplicado"))
aAdd(aSays,OemToAnsi("O conteúdo atual é " + " = " + _cFalTrue))
aAdd(aSays,OemToAnsi(".T. => Movto Bloqueado | .F. => Movto Liberado"))

aAdd(aButtons, { 5, .T., {|| _cFalTrue := bAltPerc() } } ) //Carrega botao de alteração do parâmetros
aAdd(aButtons, { 1, .T., {|o| nOpca := 1, IF(gpconfOK(), FechaBatch(), nOpca:=0) }} ) //Se selecionar botao Ok. Executa alteração e fecha tela de entrada
aAdd(aButtons, { 2, .T., {|o| FechaBatch() }} ) //Se selecionado botao Cancelar, fecha tela de entrada.

FormBatch(cTitulo,aSays,aButtons) //Exibe Tela de entrada

If nOpca == 1 
	If( _cFalTrue == "Bloqueia" )
		PUTMV("MA_VLDGR90", cValToChar(".T.")) //Altera SX6  
	Else
		PUTMV("MA_VLDGR90", cValToChar(".F.")) //Altera SX6  	
	Endif
Endif


Return( Nil ) 
/*-----------------*/
Static Function bAltPerc() 

Local nOpc := 0
Local cRet := "" 
Local aItems  := {"Bloqueia","Libera"}  
Local cCombo  := " "


DEFINE MSDIALOG _oDlg TITLE "Selecione a opção desejada." FROM C(273),C(346) TO C(350),C(484) PIXEL
@ C(007),C(005) COMBOBOX cCombo ITEMS aItems Size C(057),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
DEFINE SBUTTON FROM C(022),C(005) TYPE 1 ENABLE OF _oDlg ACTION(nOpc:=1,_oDlg:End())
DEFINE SBUTTON FROM C(022),C(037) TYPE 2 ENABLE OF _oDlg ACTION(_oDlg:End())
ACTIVATE MSDIALOG _oDlg CENTERED
If nOpc == 1
	cRet:=cCombo
EndIf                           

Return(cRet) 


