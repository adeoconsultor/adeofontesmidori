#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �         � Autor �                       � Data �           ���
�������������������������������������������������������������������������Ĵ��
���Locacao   �                  �Contato �                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �                                               ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               ���
���              �  /  /  �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function MDCNSPEDC()

/*������������������������������������������������������������������������ٱ�
�� Declara��o de cVariable dos componentes                                 ��
ٱ�������������������������������������������������������������������������*/
Private cMsg       := 'DIGITE O N�MERO DO PEDIDO DE COMPRAS, EM SEGUIDA TECLE ENTER.'
Private cNumPedido := Space(20)

/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
SetPrvt("oFont1","oFont2","oDlgPedido","oSay1","oGet1","oGet2")

/*������������������������������������������������������������������������ٱ�
�� Definicao do Dialog e todos os seus componentes.                        ��
ٱ�������������������������������������������������������������������������*/
oFont1     := TFont():New( "Arial",0,-64,,.F.,0,,400,.F.,.F.,,,,,, )
oFont2     := TFont():New( "Arial",0,-19,,.F.,0,,400,.F.,.F.,,,,,, )
//oDlgPedido := MSDialog():New( 012,006,740,1266,"Consulta de Pedidos de Compras",,,.T.,,,,,,.T.,,oFont1,.T. )
oDlgPedido := MSDialog():New( 012,006,580,900,"Consulta de Pedidos de Compras",,,.T.,,,,,,.T.,,oFont1,.T. )
oBmp1 	   := TBitmap():New(008,008,180,070,,"midoriautoleather_logo.PNG",.T.,oDlgPedido,,, .T.,.T.,,"",.T.,,.T.,,.F. )
oSay1      := TSay():New( 108,091,{||"Pedido de Compras"},oDlgPedido,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,288,032)
oGet1      := TGet():New( 148,091,{|u| If(PCount()>0,cNumPedido:=u,cNumPedido)},oDlgPedido,289,038,'',{|| !empty(cNumPedido ) .and. VldNPc() } ,CLR_WHITE,CLR_HBLUE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNumPedido",,)
oGet2      := TGet():New( 270,002,{|u| If(PCount()>0,cMsg:=u,cMsg)},oDlgPedido,475,013,'',,CLR_BLACK,CLR_HGRAY,oFont2,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cMsg",,)
// oGet2:Disable()
//
oDlgPedido:Activate(,,,.T. )

Return
//-----------------------------------------------------------
STATIC FUNCTION VldNPc()
//
SC7->( DbSetOrder(1) )
DbSelectArea( 'SC7' )
//
if ! DbSeek( xFilial( 'SC7' ) + Alltrim( cNumPedido )    )
	Alert( 'Pedido de Compras ' + Alltrim(cNumPedido)  + ' N�o encontrado na base de dados.' )
	Return( .F. )
Else
	//
	nrec1 := recno()
	//
	nTotComp := 0
	nTotEnt    := 0
	While !eof() .and. C7_FILIAL == XFILIAL('SC7') .AND. C7_NUM == Alltrim( cNumPedido )
		if SC7->C7_RESIDUO <> 'S'
			nTotComp += C7_QUANT
			nTotEnt    += C7_QUJE
		endif
		DbSkip()
	Enddo
	//
	if  nTotComp  -  nTotEnt   == 0
		Alert( 'Pedido de Compras ' + Alltrim(cNumPedido)  + ' J� atendido totalmente, n�o havendo nenhum produto a ser entregue. Entre com outro n�mero de Pedido de Compra.' )
		Return( .F. )
	Endif
	//
	DbGoTo( nrec1 )
	U_DetpCompra( Alltrim(cNumPedido ))
	DbSelectArea('SC7')
	set filter to
	DbGoTop()
	oGet1:SetFocus()
	Return(.T. )
Endif
//
RETURN(.T.)
//-----------------------------------------------------------
