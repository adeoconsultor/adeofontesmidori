#INCLUDE "rwmake.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050DEL  ºAutor  ³ExclusivErp         º Data ³  28/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada executado atraves do programa FINA050.PRW ³±±
±±³          ³ e acionado apos a confirmacao da exclusao dos titulos.     ³±±
±±³          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MIDORI                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
	MsgAlert(OemtoAnsi("Título não poderá ser excluído, pois não foi localizado no módulo Gestão de Pessoal"))
EndIf

RestArea(cArea)

Return(_lOk)
