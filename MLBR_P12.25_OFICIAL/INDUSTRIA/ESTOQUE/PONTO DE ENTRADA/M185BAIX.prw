#INCLUDE "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M185BAIX  �Autor  �Bruno M. Mota       � Data �  01/14/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa responsavel pela liberacao da baixa da SA de acordo���
���          �com a impressao do recibo.                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP 10.1 Especifico - Midori                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

Fun��o comentada em 21/05/2010
Chamado HDI 000729/000730
Alexandre Dalpiaz

*/
User Function _M185BAIX()
//Variaveis locais
Local lRet := .T.
//Inicio da funcao
//Executa a query para saber se existe algum registro que faz parte de  um recibo
BeginSql Alias "TMP"
%NoParser%
SELECT
	DISTINCT SCP.CP_LIBERA 
FROM
	%Table:SCP% SCP 
WHERE
	SCP.CP_NUM = %Exp:SCP->CP_NUM% AND
	SCP.CP_LIBERA = 'X' AND
	SCP.%NotDel% AND
	SCP.CP_FILIAL = %Exp:xFilial("SCP")%
EndSql
//Verifica se a query trouxe resultado
If TMP->(EoF())
	//Mensagem de erro
	Alert("N�o foi impresso nenhum recibo para os itens da requisi��o.")
	//Ajusta variavel de retorno
	lRet := .F.
EndIf
//Fecha tabela temporaria
TMP->(dbCloseArea())
//Retorno da funcao
Return(lRet)