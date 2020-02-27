#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
/**/
User Function EXMVC001()
Local oBrowse

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZZ3')
oBrowse:SetDescription('Cadastro de COTACAO WEB FORNECEDOR')
oBrowse:Activate() 

Return


Static Function MenuDef()
Local aRotina := {}

aAdd( aRotina, { 'Visualizar', 'VIEWDEF.EXMVC001', 0, 2, 0, NIL } ) 
aAdd( aRotina, { 'Incluir'   , 'VIEWDEF.EXMVC001', 0, 3, 0, NIL } )
aAdd( aRotina, { 'Alterar'   , 'VIEWDEF.EXMVC001', 0, 4, 0, NIL } )
aAdd( aRotina, { 'Excluir'   , 'VIEWDEF.EXMVC001', 0, 5, 0, NIL } )
aAdd( aRotina, { 'Imprimir'  , 'VIEWDEF.EXMVC001', 0, 8, 0, NIL } )
aAdd( aRotina, { 'Copiar'    , 'VIEWDEF.EXMVC001', 0, 9, 0, NIL } ) 

Return aRotina


Static Function ModelDef()
Local oModel
Local oStruZZ3 := FWFormStruct(1,"ZZ3")

oModel := MPFormModel():New("MD_ZZ3") 
oModel:addFields('MASTERZZ3',,oStruZZ3)
 
Return oModel


Static Function ViewDef()
Local oModel := ModelDef()
Local oView
Local oStrZZ3:= FWFormStruct(2, 'ZZ3')
 
oView := FWFormView():New()
oView:SetModel(oModel)
oView:AddField('FORM_ZZ3' , oStrZZ3,'MASTERZZ3' ) 
oView:CreateHorizontalBox( 'BOX_FORM_ZZ3', 100)
oView:SetOwnerView('FORM_ZZ3','BOX_FORM_ZZ3')
 
Return oView