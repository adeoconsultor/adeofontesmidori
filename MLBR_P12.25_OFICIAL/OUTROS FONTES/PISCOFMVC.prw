#INCLUDE 'FWMVCDEF.CH'   

/*/{Protheus.doc} Controle de Credito PIS/COFINS
author willer trindade

@version 1.0
/*/


User Function PISCOFMVC()

Local aCoors := FWGetDialogSize( oMainWnd )
Local oPanelUp, oFWLayer, oPanelLeft, oPanelRight, oBrowseUp, oBrowseLeft, oBrowseRight, oRelacZA4//, oRelacZA5
Private oDlgPrinc


Define MsDialog oDlgPrinc Title 'Monitor Creditos de Pis/Cofins' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel
//
// Cria o conteiner onde serão colocados os browses
//
oFWLayer := FWLayer():New()
oFWLayer:Init( oDlgPrinc, .F., .T. )
//
// Define Painel Superior
//
oFWLayer:AddLine( 'UP', 50, .F. )
// Cria uma "linha" com 50% da tela
oFWLayer:AddCollumn( 'ALL', 100, .T., 'UP' )
// Na "linha" criada eu crio uma coluna com 100% da tamanho dela
oPanelUp := oFWLayer:GetColPanel( 'ALL', 'UP' )
// Pego o objeto desse pedaço do container
//
// Painel Inferior
//
oFWLayer:AddLine( 'DOWN', 50, .F. )
// Cria uma "linha" com 50% da tela
oFWLayer:AddCollumn( 'LEFT' , 100, .T., 'DOWN' )
// Na "linha" criada eu crio uma coluna com 50% da tamanho dela
//oFWLayer:AddCollumn( 'RIGHT', 50, .T., 'DOWN' )
// Na "linha" criada eu crio uma coluna com 50% da tamanho dela
oPanelLeft := oFWLayer:GetColPanel( 'LEFT' , 'DOWN' ) // Pego o objeto do pedaço esquerdo
//oPanelRight := oFWLayer:GetColPanel( 'RIGHT', 'DOWN' ) // Pego o objeto do pedaço direito

//oFWLayer:AddLine( 'DOWN2', 20, .F.) 
//oFWLayer:AddCollumn( 'RIGHT' , 100, .T., 'DOWN2' )
//oPanelRight := oFWLayer:GetColPanel( 'RIGHT', 'DOWN2' ) // Pego o objeto do pedaço direito

//
// FWmBrowse Superior Albuns
//
oBrowseUp:= FWmBrowse():New()
oBrowseUp:SetOwner( oPanelUp )
// Aqui se associa o browse ao componente de tela
oBrowseUp:SetDescription( "Creditos PIS" )
oBrowseUp:SetAlias( 'CCY' )
oBrowseUp:SetMenuDef( 'W_PISCOF' )
// Define de onde virao os botoes deste browse
oBrowseUp:SetProfileID( '1' )
BrowseUp:DisableDetails()
oBrowseUp:ForceQuitButton()

//oBrowseUp:AddLegend( "A1_MSBLQL=='1'", "RED" ,   "Cliente Bloqueado" )
//oBrowseUp:AddLegend( "A1_MSBLQL=='2' .AND. Empty(A1_LC)", "WHITE" ,   "Cliente S/ Limite Credito" ) 
//oBrowseUp:AddLegend( "A1_MSBLQL=='2' .AND. !Empty(A1_LC) .AND. Empty(A1_CODSIAF)", "YELLOW" ,   "Cliente Analise Fiscal" ) 
//oBrowseUp:AddLegend( "A1_MSBLQL=='2' .AND. !Empty(A1_LC) .AND. !Empty(A1_CODSIAF) .AND. Empty(A1_CONTA)", "BLUE" ,   "Cliente Analise Contabil" )       
//oBrowseUp:AddLegend( "A1_MSBLQL=='2' .AND. !Empty(A1_LC) .AND. !Empty(A1_CODSIAF) .AND. !Empty(A1_CONTA)", "GREEN" , "Cliente Liberado") 
//oBrowseUp:AddLegend( "A1_MSBLQL<>'1'", "GRAY" ,   "Cliente sem Analise Completa" )

oBrowseUp:Activate()

//
// Lado Esquerdo Musicas
//
oBrowseLeft:= FWMBrowse():New()
oBrowseLeft:SetOwner( oPanelLeft )
oBrowseLeft:SetDescription( 'Creditos COFINS' )
oBrowseLeft:SetMenuDef( 'W_PISCOF' )
// Referencia vazia para que nao exiba nenhum botao
oBrowseLeft:DisableDetails()
oBrowseLeft:SetAlias( 'CCW' )
oBrowseLeft:SetProfileID( '2' )

//oBrowseLeft:AddLegend( "C5_LIBEROK==' '", "GRAY" ,   "Pedido Bloqueado" )  
//oBrowseLeft:AddLegend( "C5_LIBEROK=='S' .AND. !Empty(C5_NOTA)" , "ORANGE" ,  "Nota Fiscal Emitida" )
//oBrowseLeft:AddLegend( "C5_LIBEROK=='S' .AND. !Empty(C5_NOTA) .AND. (C5_XSTASEP)=='S' .AND. !Empty(C5_XSENT)" , "BLUE" ,  "Pedido c/ Transportador" )
//oBrowseLeft:AddLegend( "C5_LIBEROK==''", "WHITE" ,  "Pedido Liberado" )
oBrowseLeft:Activate()
//
// Lado Direito Autores/Interpretes
//
//oBrowseRight:= FWMBrowse():New()
//oBrowseRight:SetOwner( oPanelRight )
//oBrowseRight:SetDescription( 'Status' )
//oBrowseRight:SetMenuDef( '' )
// Referencia vazia para que nao exiba nenhum botao
//oBrowseRight:DisableDetails()
//oBrowseRight:SetAlias( '' )
//oBrowseLeft:SetProfileID( '3' )

//oBrowseRight:Activate()
//
// Relacionamento entre os Paineis
//
//oRelacSC5:= FWBrwRelation():New()
//oRelacSC5:SetRelation( 'CCW', {	{ 'CCW_FILIAL', 'xFilial("CCW")' },; 
//								{ 'CCW_PERIOD', 'CCY_PERIOD' }}, CCW->( IndexKey( 1 ) ) )
//oRelacSC5:Activate()
//oRelacZA5:= FWBrwRelation():New()
//oRelacZA5:AddRelation( oBrowseLeft, oBrowseRight, { { 'ZA5_FILIAL', 'xFilial( "ZA5" )' }, { 'ZA5_ALBUM' , 'ZA4_ALBUM' }, { 'ZA5_MUSICA', 'ZA4_MUSICA' } } )
//oRelacZA5:Activate()
Activate MsDialog oDlgPrinc Center
Return NIL
//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

//ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PESQBRW"          OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.W_PISCOF" OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.W_PISCOF" OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.W_PISCOF" OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.W_PISCOF" OPERATION 5 ACCESS 0
//ADD OPTION aRotina TITLE "Abrir Chamado"     ACTION "RHDA001AC"      OPERATION 2 ACCESS 0

Return aRotina
//-------------------------------------------------------------------
Static Function ModelDef()
Local oStruCCY	:= FWFormStruct( 1, 'CCY' )
Local oStruCCW	:= FWFormStruct( 1, 'CCW' )
Local oModel
     
oModel := MPFormModel():New('ModelDef')
oModel:AddFields( 'CCY', /*cOwner*/, oStruCCY )
oModel:AddGrid( 'CCW', 'CCY', oStruCCW )
oModel:SetRelation( 'CCW', {	{ 'CCW_FILIAL', 'xFilial("CCW")' },; 
								{ 'CCW_PERIOD', 'CCY_PERIOD' }},CCW->( IndexKey( 1 ) ) )
oModel:SetDescription( 'Controle de Creditos PIS/COFINS' )
oModel:GetModel( 'CCY' ):SetDescription( 'Creditos PIS' )
oModel:GetModel( 'CCW' ):SetDescription( 'Creditos COFINS' )
oModel:GetModel( 'CCY' ):SetOnlyView ( .T. )   
oModel:GetModel( 'CCW' ):SetOnlyView ( .T. )        

Return oModel
//-------------------------------------------------------------------
Static Function ViewDef()
Local oModel := FWLoadModel( 'W_PISCOF' )
Local oStruCCY := FWFormStruct( 2, 'CCY' )
Local oStruCCW := FWFormStruct( 2, 'CCW' )
Local oView

oView := FWFormView():New()
oView:SetModel( oModel )
oView:SetCloseOnOk({|| .T. })
  
oView:AddField( 'VIEW_CCY', oStruCCY, 'CCY' )
oView:AddGrid( 	'VIEW_CCW', oStruCCW, 'CCW' )

oView:CreateHorizontalBox( 'SUPERIOR', 50 )
oView:SetOwnerView( 'VIEW_CCY', 'SUPERIOR' )

oView:CreateHorizontalBox( 'INFERIOR', 50 )
oView:SetOwnerView( 'VIEW_CCW', 'INFERIOR' )

oView:SetCursor(oModel)
        
Return oView

