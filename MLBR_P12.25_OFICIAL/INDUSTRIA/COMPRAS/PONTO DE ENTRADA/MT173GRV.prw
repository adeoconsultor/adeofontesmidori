#Include "Protheus.ch"            
#Include "Rwmake.ch"
//-----------------------------------------------
//Autor : Consultoria
//Data  : 28/03/2011
//Função: MT173GRV
//Desc. : PE apos a gravação do SC7 e Atuallização
//        do SC3. Utilizado como resolução do 
//		  chamado 002815.
//-----------------------------------------------
User Function MT173GRV()
Local aAreaSC7 := GetArea("SC7")
Local aAreaSC3 := GetArea("SC3")

DbSelectArea("SC")
RecLock('SC7',.F.) 

REPLACE SC7->C7_ITEMCTA WITH SC3->C3_ITEMCTA
REPLACE SC7->C7_CLVL    WITH SC3->C3_CLVL

MsUnLock()

RestArea(aAreaSC7)
RestArea(aAreaSC3)

Return()