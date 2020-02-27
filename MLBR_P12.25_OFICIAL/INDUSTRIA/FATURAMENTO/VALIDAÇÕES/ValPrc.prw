#Include 'Protheus.ch'
#INCLUDE "rwmake.CH"
/*
�������������������������������������������������������������������������� ���
�������������������������������������������������������������������������� ���
�������������������������������������������������������������������������� ���
���Programa  �VALPRC  �Autor  �Humberto Garcia Liendo� Data �  04/13/11    ���
�������������������������������������������������������������������������� ���
���Desc.     �  Este programa est� cadastrado na valida��o de usu�rio do   ���
���          �  campo C6_PRCVEN e tem a finalidade de informar divergencias���
                entre o pre�o unit�rio do produto e o pre�o unitario da    ���
                tabela de pre�os                                           ���
�������������������������������������������������������������������������� ���
���Uso       � AP                                                          ���
�������������������������������������������������������������������������� ���
�������������������������������������������������������������������������� ���
�������������������������������������������������������������������������� ���
*/


User Function ValPrc

Local cRet := .T.

If l410auto = .F.
	                                                       
	nPos:= Ascan( aHeader, {|x| AllTrim(x[2]) == "C6_PRUNIT" })
	
	If !Empty(M->C5_TABELA)
		If M->C6_PRCVEN <> aCols[n,nPos]
			MsgAlert("O pre�o informado � diferente do pre�o cadastrado na tabela.")
		EndIf
	EndIf
	
EndIf                                   

Return(cRet)
