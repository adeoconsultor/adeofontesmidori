#include 'RWMAKE.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VSS_DTENT �Autor  � Vinicius Schwartz  � Data �  18/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para tratar prazo de entrega a partir do campo       ���
���          �C8_X_DTPRZ                                                  ���
�������������������������������������������������������������������������͹��
���Uso.      �Fun��o onde ser� carregada ao ser informado a data no campo ���
���          �C8_X_DTPRZ validando se o prazo de entrega nao eh menor que ���
���          �a data da emissao.    						              ���
���          �Ref. ao HDI 004564                                          ���
���          �Solic. Marcio Grizoni (Compras)                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VSS_DTENT()
Local lRet := .T.

//Valida se data informada eh maior que data da emissao
If (M->C8_X_DTPRZ >= dA150Emis)
	lRet:= .T.            
Else
	MsgStop("Data Informada Menor que a data de Emiss�o! ","Aten��o")
	lRet:= .F.
End



Return(lRet)