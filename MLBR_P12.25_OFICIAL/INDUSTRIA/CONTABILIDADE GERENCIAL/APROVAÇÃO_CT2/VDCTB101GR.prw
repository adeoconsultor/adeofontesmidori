#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "Totvs.ch"
/*
*
* Descr.: PE efetua a valida��o dos parametros do lan�amento contabil antes da sua inclus�o
*/
User Function VDCTB101GR()
Local lRet := .T.

cTpSald := "9"
M->CT2_TPSALD := "9"
CT2->CT2_TPSALD := "9"

Return(lRet)