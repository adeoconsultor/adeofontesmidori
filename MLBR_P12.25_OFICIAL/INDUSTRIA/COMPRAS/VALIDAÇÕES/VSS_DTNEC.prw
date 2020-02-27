#include 'RWMAKE.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VSS_DTNEC �Autor  � Vinicius Schwartz  � Data �  04/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para tratar prazo de necessidade a partir do campo   ���
���          �B1_PE do produto ref. ao fornecedor.                        ���
�������������������������������������������������������������������������͹��
���Uso.      �Fun��o onde ser� carregada ao ser informado a data no campo ���
���          �C1_DATPRF validando se o prazo de necessidade nao eh menor  ���
���          �que o prazo estipulado pelo fornecedor.		              ���
���          �Ref. ao HDI 004598                                          ���
���          �Solic. MARCIA DE C OLIVEIRA KOBAYASHI (Compras)             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VSS_DTNEC()
Local lRet := .T.   
Local nPrz

nPosProd   :=aScan(aHeader,{|x| AllTrim(x[2])=="C1_PRODUTO"}) 

//Valida se data da necessidade eh >= ao prazo do fornecedor
//Alert ('Produto: '+Acols[N,nPosProd])

DbSelectArea('SB1')
DbSetOrder(1)
DbSeek(xFilial('SB1') + Acols[N,nPosProd])

If(SB1->B1_PE <> 0)
	If (M->C1_DATPRF >= (dDatabase + SB1->B1_PE))
		lRet := .T.
	Else 
		MsgStop("Data Informada Menor que a Data Prazo do Fornecedor que � de "+cValToChar(SB1->B1_PE)+" dias.","Aten��o")
		lRet := .F.
	Endif
EndIf

Return(lRet)