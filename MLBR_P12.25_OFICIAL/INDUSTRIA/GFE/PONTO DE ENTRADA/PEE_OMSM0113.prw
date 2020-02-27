#Include 'Protheus.ch'

/*/{Protheus.doc} OMSM0113
(long_description)
@type function
@author Fernando Carvalho
@since 26/04/2018
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
User Function OMSM0113()      
	Local oModelGW8 := PARAMIXB[1] 
	Local aArea := GetArea()
	if oModelGW8:GetLine() == 1
		oModelGW8:SetValue( 'GW8_PESOR', SF2->F2_PLIQUI )
	Endif	
    RestArea(aArea)
Return .T.