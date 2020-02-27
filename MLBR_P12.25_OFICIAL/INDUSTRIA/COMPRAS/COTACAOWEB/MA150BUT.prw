#include "totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "RwMake.ch"
/*
* Funcao: MA150BUT
* Autor:  AOliveira
* Data:   10-07-2018
* Descr.:
*/
User Function MA150BUT()

Local aBotao := {}

aadd(aBotao,{"RPMCPO"   ,{|| U_XDWEB() },"Dados Web"})  

Return(aBotao) 