#Include 'protheus.ch'
#Include 'rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VSS_StatNF�Autor  �Vinicius Schwartz   � Data �  29/10/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pontos de entrada para tratar a classificacao das notas,	  ���
���          �exclus�o da pre-nota e documento de entrada.				  ���
���          �Atualiza o status da informacao do campo ZO_STATUS, utili-  ���
���          �zado para liberar a utilizacao dos pallets incluidos ao dar ���
���          �entrada em uma pre-nota.									  ���
���          �Solicitante: Thiago/Fabio - HDI 004883					  ���
�������������������������������������������������������������������������͹��
���Uso       � COMPRAS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function VSS_StatNF (cStat)
Local cQuery := ""

DbSelectArea('SZO')
DbSetOrder(1)

If cStat == 'CLA'
	If DbSeek (xFilial('SZO')+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
		
		cQuery:= " UPDATE SZO010 "
		cQuery+= " SET ZO_NFCLASS = 'S' "
		cQuery+= " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NFORI = '"+SF1->F1_DOC+"' AND ZO_SERIE = '"+SF1->F1_SERIE+"' AND ZO_CODFOR = '"+SF1->F1_FORNECE+"' AND ZO_LJFOR = '"+SF1->F1_LOJA+"' AND D_E_L_E_T_ <> '*' "
		nret1 := TcSqlExec( cQuery )
		
	Endif
Endif

If cStat == 'EXC'
	If DbSeek (xFilial('SZO')+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
		
		cQuery:= " UPDATE SZO010 "
		cQuery+= " SET ZO_NFCLASS = 'N', ZO_STATUS = 'EXC' "
		cQuery+= " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NFORI = '"+SF1->F1_DOC+"' AND ZO_SERIE = '"+SF1->F1_SERIE+"' AND ZO_CODFOR = '"+SF1->F1_FORNECE+"' AND ZO_LJFOR = '"+SF1->F1_LOJA+"' AND D_E_L_E_T_ <> '*' "
		nret1 := TcSqlExec( cQuery )
		
	Endif
Endif

Return()