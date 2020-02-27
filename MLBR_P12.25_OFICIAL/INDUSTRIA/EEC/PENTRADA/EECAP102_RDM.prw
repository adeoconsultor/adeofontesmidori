#INCLUDE "EEC.CH"

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midoria Atlantica
//|Funcao....: U_EECAP100()
//|Autor.....: Armando M. Urzum - armando.u@uol.com.br
//|Data......: 11 de Janeiro de 2010, 08:00
//|Uso.......: SIGAEEC
//|Versao....: Protheus - 10        `
//|Descricao.: PE referente ao Pedido de Exportação.
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function EECAP102()
*-----------------------------------------*

Local cParamIXB                 	
Local aAreaEE8 := GetArea()

If Type("PARAMIXB") = "A"
   cParamIXB := PARAMIXB[1]
ElseIf Type("PARAMIXB") = "C"
    cParamIXB := PARAMIXB
EndIf

Do Case

	Case cParamIXB == "PE_PESOS"
		Return .F.
		
End Case

Return .T.

