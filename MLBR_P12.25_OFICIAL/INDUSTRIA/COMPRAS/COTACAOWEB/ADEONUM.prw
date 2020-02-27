#include "totvs.ch" 
#Include "Protheus.ch"
#Include "TopConn.ch" 
#Include "RwMake.ch"

User Function ADEONUM()
 
 
//Preparando Ambiente
//RpcSetType(3)
lRetEnv := RpcSetEnv("01", "01", ,, 'COM', , {"SE2","SZW"},  ,.f. , , )

	XGETNUM()
	
If lRetEnv 

EndIf

Return()     
 



/*---------------------------------------------------------
Funcao: XGETNUM()  |Autor: AOliveira    |Data: 18/07/2019
-----------------------------------------------------------
Descr.: Rotina tem como objetivo retornar numeração unica
-----------------------------------------------------------
Uso:    MIDORI
---------------------------------------------------------*/
Static Function XGETNUM()
Local cRet := ""
Local nSorteio := 0
Local lSeek    := .T.
Local _cCodigo :=  ""

Local _nTamanho := TamSX3('E2_X_NUMAP')[1]
Local x

/*
While lSeek 
	
	_cCodigo :=  ""  
	
	For x:=1 To _nTamanho
		nSorteio := Randomize( 1, 10 )
		_cCodigo +=  Alltrim(Str(nSorteio))
	Next x
	
	_cCodigo := Alltrim(_cCodigo)
	 
	cQry01 := "SELECT TOP 100 COUNT(*) QTDE FROM "+RetSQLName("SZW")+" WHERE ZW_NUMAP = '"+Alltrim(_cCodigo)+"' AND D_E_L_E_T_ = '' "
	TCQUERY cQry01 ALIAS "TBX" NEW                                                                         
	
	cQry02 := "SELECT TOP 100 COUNT(*) QTDE FROM "+RetSQLName("SE2")+" WHERE E2_X_NUMAP = '"+Alltrim(_cCodigo)+"' AND D_E_L_E_T_ = '' "    
	TCQUERY cQry02 ALIAS "TBY" NEW
	
	If  (TBX->QTDE == 0 .And. TBY->QTDE == 0)   
		lSeek := .F.
	EndIf              
	 
	TBX->(DbCloseArea())
	TBY->(DbCloseArea())     
	
EndDo
*/

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

cRet := _cCodigo

Return(cRet)