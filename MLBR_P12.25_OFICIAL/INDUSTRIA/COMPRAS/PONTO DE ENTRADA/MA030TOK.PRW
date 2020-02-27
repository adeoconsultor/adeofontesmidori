#INCLUDE "RWMAKE.CH"    
#INCLUDE "PROTHEUS.ch"

/*
----------------------------------------------------------------------------------------
Funcao: MA030TOK														Data: 29.1.2017
Autor : WILLER TRINDADE
----------------------------------------------------------------------------------------
Objetivo:  
----------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------*/
User Function MA030TOK()

Local lRet	 	:= .T.
Local cEnt		:= CHR(13)+CHR(10)   

	If AllTrim(M->A1_TIPO) == "F" .And. (M->A1_CONTRIB) <> "2"
		Alert ("Favor informar campo de Contribuinte do ICMS como 'NAO' para correta validação do cadastro 'Aba Fiscais', campo Contribuinte")
		lRet := .F.
	EndIf	
		
Return(lRet)		