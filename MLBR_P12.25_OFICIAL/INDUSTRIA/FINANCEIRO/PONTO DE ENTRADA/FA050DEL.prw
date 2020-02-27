#INCLUDE "rwmake.ch"
#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA050DEL  �Autor  �ExclusivErp         � Data �  28/04/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada executado atraves do programa FINA050.PRW ���
���          � e acionado apos a confirmacao da exclusao dos titulos.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MIDORI                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA050DEL()

Local cArea  := GetArea()
Local cChave := ""
Local _lOk	 := .F.

// MsgAlert("Ponto de Entrada : FA050DEL")
cChave := SE2->E2_FILIAL+SE2->E2_FILORIG+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_TIPO+SE2->E2_FORNECE

If Alltrim(SE2->E2_ORIGEM) <> "GPEM670"
	Return(.t.)
EndIf

//----------------------------------------------------------------------------//
// Exclusao dos dados dos titulos a pagar, no Modulo Gestao de Pessoal        //
//----------------------------------------------------------------------------//
DbSelectArea("RC1")
RC1->(DbSetOrder(2))

If	RC1->(DbSeek(cChave))
	_lOk := .T.
	RecLock("RC1",.F.,.T.)
	RC1->(DbDelete())
	MsUnLock()
Else
	_lOk := .F.
	MsgAlert(OemtoAnsi("T�tulo n�o poder� ser exclu�do, pois n�o foi localizado no m�dulo Gest�o de Pessoal"))
EndIf

RestArea(cArea)

Return(_lOk)
