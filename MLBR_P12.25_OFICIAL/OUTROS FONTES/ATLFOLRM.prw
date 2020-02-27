#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ATLFOLRM  �Autor  �REGINALDO - MIDORI  � Data �  07/02/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � GERA NUMERO SEQUENCIAL PARA NUMERO DE REMESSA              ���
���          � CNAB PAGFOR - FOLHA DE PAGAMENTO                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ATLFOLRM()
                   
Local _nNumero := 1 //Variavel para gravar o numero

dbSelectArea("SX6")
//Pesquisa na tabela de parametros Configurador se o parametro esta como exclusivo
If SX6->(dbSeek(SRA->RA_FILIAL+"MV_ATLFORM"))
	_nNumero := Val(SX6->X6_CONTEUD)
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD :=Str(_nNumero+1) // Grava o numero utilizado
	MSUNLOCK()
//Pesquisa na tabela de parametros Configurador se o parametro esta como compartilhado
ElseIf SX6->(dbSeek("  "+"MV_ATLFORM"))
	_nNumero := Val(SX6->X6_CONTEUD)
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD :=Str(_nNumero+1) // Grava o numero utilizado
	MSUNLOCK()
EndIf

Return(StrZero(_nNumero,5))