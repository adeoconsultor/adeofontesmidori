#INCLUDE "EEC.CH"

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: U_EECPPE09()
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Data......: 11 de Janeiro de 2010, 08:00
//|Uso.......: SIGAEEC
//|Versao....: Protheus - 10
//|Descricao.: PE Para exclus�o do Pedido
//|Observa��o: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function EECPPE09()
*-----------------------------------------*

ZZA->(dbSetOrder(1))
If ZZA->(dbSeek(xFilial("ZZA")+EE7->EE7_PEDIDO))
	If MsgYesNo("Pedido Possui Romaneio de Couro, deseja exclu�-lo mesmo assim?","Exclus�o")
		MsgInfo("Romenio de couro tamb�m ser� excluido","Exclus�o de Romaneio")
	Else
		Return .F.
	EndIf
EndIf

Return .T.

