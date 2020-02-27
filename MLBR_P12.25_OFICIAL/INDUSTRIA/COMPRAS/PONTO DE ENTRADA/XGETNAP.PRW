#include "totvs.ch" 
#Include "Protheus.ch"
#Include "TopConn.ch" 
#Include "RwMake.ch"
/*---------------------------------------------------------
Funcao: XGETNAP()  |Autor: AOliveira    |Data: 18/07/2019
-----------------------------------------------------------
Descr.: Rotina tem como objetivo retornar numeração unica
        para o campo E2_X_NUMAP
-----------------------------------------------------------
Uso:    MIDORI
---------------------------------------------------------*/

User Function XGETNAP()
Local cRet := ""
Local lSeek    := .T.

While lSeek 
	
	cRet :=  GETSXENUM('SE2','E2_X_NUMAP','E2_X_NUMAP') 
	ConfirmSx8()

	cQry01 := "SELECT TOP 100 COUNT(*) QTDE FROM "+RetSQLName("SZW")+" WHERE ZW_NUMAP = '"+Alltrim(cRet)+"' AND D_E_L_E_T_ = '' "
	TCQUERY cQry01 ALIAS "TBX" NEW                                                                         
	
	cQry02 := "SELECT TOP 100 COUNT(*) QTDE FROM "+RetSQLName("SE2")+" WHERE E2_X_NUMAP = '"+Alltrim(cRet)+"' AND D_E_L_E_T_ = '' "    
	TCQUERY cQry02 ALIAS "TBY" NEW
	
	If  (TBX->QTDE == 0 .And. TBY->QTDE == 0)   
		lSeek := .F.
	EndIf              
	 
	TBX->(DbCloseArea())
	TBY->(DbCloseArea())     
	
EndDo

Return(cRet)