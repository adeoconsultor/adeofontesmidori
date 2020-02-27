#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} Controle de Credito PIS/COFINS
author willer trindade

@version 1.0
/*/

Static Function W_PISCOF()


Static Function MenuDef()
Local aRotina := {}

//ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PESQBRW"          OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.W_PISCOF" OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.W_PISCOF" OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.W_PISCOF" OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.W_PISCOF" OPERATION 5 ACCESS 0
//ADD OPTION aRotina TITLE "Abrir Chamado"     ACTION "RHDA001AC"      OPERATION 2 ACCESS 0

Return aRotina

Static Function ModelDef()
       
Local oStruCCY	:= FWFormStruct( 1, 'CCY' )
Local oStruCCW	:= FWFormStruct( 1, 'CCW' )
Local oModel
     
oModel := MPFormModel():New('ModelDef')
oModel:AddFields( 'CCY', /*cOwner*/, oStruCCY )
oModel:AddGrid( 'CCW', 'CCY', oStruCCW )
//oModel:SetRelation( 'CCW', {	{ 'CCW_FILIAL', 'xFilial("CCW")' },; 
//								{ 'CCW_PERIOD', 'CCY_PERIOD' },;
//								{ 'CCW_COD',		'CCY_COD' }	}, CCW->( IndexKey( 1 ) ) )
oModel:SetDescription( 'Controle de Creditos PIS/COFINS' )
oModel:GetModel( 'CCY' ):SetDescription( 'Creditos PIS' )
oModel:GetModel( 'CCW' ):SetDescription( 'Creditos COFINS' )
oModel:GetModel( 'CCY' ):SetOnlyView ( .F. )   
oModel:GetModel( 'CCW' ):SetOnlyView ( .F. )        

Return oModel

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
