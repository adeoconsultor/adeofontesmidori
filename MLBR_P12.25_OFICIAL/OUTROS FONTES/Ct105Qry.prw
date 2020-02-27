#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CT105QRY  �Autor  �PrimaInfo           � Data �  19/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na funcao de contabilizacao para adicionar ���
���          �campos na query.                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Midori                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/* Removido temporariamente do projeto para ver se resolve problema contabil. financeiro
 * Diego em 18/06/18
 */
User Function Ct105Qry()

Local aArea		:= GetArea()                              
Local cQry		:= PARAMIXB[1]                            
Local lAglLcto	:= PARAMIXB[2]

If lAglLcto
	cQry:= StrTran(cQry,"CTK_TPSALD","CTK_TPSALD,CTK_ORIGEM")
EndIf		

RestArea(aArea)      

Return(cQry)