#include "rwmake.ch"        
/*------------------------------------------------------------------------
Programa: VLRACRESC       | Autor: AOliveira            |Data: 26/05/11
--------------------------------------------------------------------------
Objetivo: Retornar Vlr de Acrecimo do CNAB a Pagar
--------------------------------------------------------------------------
Uso: DEPARTAMENTO FINANCEIRO MIDORIA ATALNTICA
--------------------------------------------------------------------------
Parametros: Nenhum                                                        
--------------------------------------------------------------------------
Regra: Multa + Juros + Correcao + Acrescimo = VLR ACRESCIMO
------------------------------------------------------------------------*/
User Function VLRACRESC()                                 

Local nRet     := Replicate("0",15)                           
Local nAcresc  := (SE2->E2_MULTA + SE2->E2_JUROS + SE2->E2_CORREC + SE2->E2_ACRESC)        

Local nVlrDoc := u_PagVal() 
Local nVlrPag := u_ValPag()
                  
If nAcresc == 0.01 //13-07-11 -Acertado com a Lidia de casos de Acrescimo de 0,01 o valor devera ser ZERO (0)
	nAcresc := 0           
ElseIf SubStr(nVlrDoc,6) == SubStr(nVlrPag,6) //03-08-2011 -Vlr do Doc igual ao Vlr pago.
	nAcresc := 0           		
EndIf                  

nRet := StrZero(nAcresc*100,15)

Return(nRet)                                                                                                           