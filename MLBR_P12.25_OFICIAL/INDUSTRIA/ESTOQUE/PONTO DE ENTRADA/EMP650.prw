#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EMP650    �Autor  �Bruno M. Mota       � Data �  12/08/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada responsavel por atualizar o aCols do       ���
���          �ponto de entrada emp650                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EMP650()
//Variaveis locais da funcao
Local nPosCod 	:= ""
Local nPosLocal := ""
Local nX
//Inicio da funcao
nPosCod    :=	aScan(aHeader,{|x| AllTrim(x[2])=="G1_COMP" })
nPosLocal  :=	aScan(aHeader,{|x| AllTrim(x[2])=="D4_LOCAL"})
//Seta ordem SZ9
SZ1->(dbSetOrder(1))
//Varre aCols
For nX := 1 to Len(aCols)
	//Posiciona SZ1
	If SZ1->(dbSeek(xFilial("SZ1")+aCols[nX][nPosCod]))
		//Sobrescreve o valor do aCols
		aCols[nX][nPosLocal] := SZ1->Z1_LOCAL
	EndIf
Next nX                        

//Retorno da funcao
Return()		