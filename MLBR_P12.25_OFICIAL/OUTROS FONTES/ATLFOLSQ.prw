#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ATLFOLSQ  �Autor  �REGINALDO - MIDORI  � Data �  06/29/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � GERA NUMERO SEQUENCIAL PARA NUMERO PAGTO                   ���
���          � CNAB PAGFOR - FOLHA DE PAGAMENTO                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ATLFOLSQ()
                   
Local _nNumero := 1 //Variavel para gravar o numero

dbSelectArea("SX6")
//Pesquisa na tabela de parametros Configurador se o parametro esta como exclusivo
If SX6->(dbSeek(SRA->RA_FILIAL+"MV_ATLFOSQ"))
	_nNumero := Val(SX6->X6_CONTEUD)
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD :=Str(_nNumero+1) // Grava o numero utilizado
	MSUNLOCK()
//Pesquisa na tabela de parametros Configurador se o parametro esta como compartilhado
ElseIf SX6->(dbSeek("  "+"MV_ATLFOSQ"))
	_nNumero := Val(SX6->X6_CONTEUD)
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD :=Str(_nNumero+1) // Grava o numero utilizado
	MSUNLOCK()
EndIf

Return(StrZero(_nNumero,16))