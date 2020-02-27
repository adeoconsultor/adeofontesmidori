#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "Totvs.ch"
/*
*
* Descr.: PE efetua a validação dos parametros do lançamento contabil antes da sua inclusão
*/
User Function VDCTB101GR()
Local lRet := .T.

cTpSald := "9"
M->CT2_TPSALD := "9"
CT2->CT2_TPSALD := "9"

Return(lRet)