#INCLUDE "RWMAKE.CH"    
#INCLUDE "PROTHEUS.ch"
/*
----------------------------------------------------------------------------------------
Autor : Gildesio Campos     		Data: 03/09/10
----------------------------------------------------------------------------------------
Objetivo: PE apos a gravacao do titulo TITULO DDA na tabela FIG
		  -	Grava o campo E2_X_DDAOK para indicar que deve ser enviado no arquivo
		    de alegação e autorização do pagamento no sistema DDA 
---------------------------------------------------------------------------------------------------
*/
User Function FA260GRFIG()    
//Atualiza FIG 
FIG->FIG_X_ALEG := "1"		//1-Aceite	2-Nao Aceite
//Atualiza SE2
SE2->E2_X_DDAOK := FIG_X_ALEG	//1-Aceite	2-Nao Aceite

Return
