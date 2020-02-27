#INCLUDE "RWMAKE.CH"    
#INCLUDE "PROTHEUS.ch"
/*
----------------------------------------------------------------------------------------
Funcao: F290BAIXA														Data: 12.04.2010
Autor : Gildesio Campos
----------------------------------------------------------------------------------------
Objetivo: 	1-Ponto de Entrada na confirmacao da Fatura
			2-Cria as variaveis que serao utilizadas no PE FA290
			3-Monta a interface com o usuário para informar dados da AP
----------------------------------------------------------------------------------------*/
User Function F290BAIXA() 
Local cRet := ""

aAdd(aTitFt,{SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,E2_X_NUMAP})  // PFX 999999999-X XX / 999999  |  

Return(cRet)            