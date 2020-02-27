#INCLUDE "Protheus.ch" 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M103PCIT  �Autor  �Antonio C Damaceno  � Data �  13/12/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Manipula��o do aCols ap�s vinculo com Pedido de Compra      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M103PCIT()

Local nPosCod 	:= AScan(aHeader,{|x|AllTrim(x[2]) == "D1_COD"})     //Codigo do Produto
Local nPosDtVld := AScan(aHeader,{|x|AllTrim(x[2]) == "D1_DTVALID"}) //Data Validade do Lote
Local nI := 0

If Inclui
	For nI:= 1 to Len(Acols)
		If Rastro(aCols[nI][nPosCod])
			aCols[nI][nPosDtVld] := dDataBase+1825
		EndIf
	Next
EndIf

Return