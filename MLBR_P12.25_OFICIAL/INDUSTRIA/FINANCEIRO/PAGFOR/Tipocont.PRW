# Include 'Protheus.ch'

/*

Programa - TipoCont
Autor    - Humberto Garcia
Data     - 11/12/2009                        

Finalidade e descricão:

	Este programa e utilizado na posicão 479 do PAGFOR Bradesco e tem a finalidade de retonar o tipo de conta
do fornecedor, de acordo com a modalidade de pagamento (EA_MODELO) e a informacao cadastrada no  no campo A2_X_TPCON.

*/


User function TipoCont


//Local cTpCont:= If(empty(SA2->A2_X_TPCON),"1",SA2->A2_X_TPCON) 

Local cTpCont:= ""

If Empty(SE2->E2_X_TPCTA)                                  
   If(empty(SA2->A2_X_TPCON))
     cTpCont:= "1"
   Else  
     cTpCont:= SA2->A2_X_TPCON 
   EndIf 

Else
     cTpCont:= SE2->E2_X_TPCTA
EndIf



Return(cTpCont)