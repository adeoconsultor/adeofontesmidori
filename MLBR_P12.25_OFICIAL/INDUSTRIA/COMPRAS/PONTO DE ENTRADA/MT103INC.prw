#Include "Protheus.ch"
#Include "RwMake.ch"
/*
*Funcao: MT103INC  | AOliveira 21-05-2019
*Descr.: PE pertence ao MATA103X(fun��es de vld doc Entrada). 
         E verifica se o doc entrada pode ser  inclu�do ou classificado, NFEVLDINI().
*Uso   : Midori.
         Ser� utilizado para validar se j� existe titulo no financeiro com o mesmo 
         numero da entrada, para o fornecedor em quest�o.
*/
User Function MT103INC( )

Local lRet     := .T.       
Local aArea    := GetArea()
Local aAreaSE2 := SE2->(GetArea())
Local aAreaSF1 := SE2->(GetArea())      

/*If lClass
	
	DbSelectArea("SE2")
	SE2->(DbSetOrder(1)) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
	SE2->(DbGoTop() )
	//SE2->( DbSeek() )

EndIf
*/

RestArea(aArea) 
RestArea(aAreaSE2) 
RestArea(aAreaSF1) 

Return(lRet)