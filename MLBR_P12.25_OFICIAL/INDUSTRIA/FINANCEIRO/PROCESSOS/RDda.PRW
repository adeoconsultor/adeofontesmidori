#INCLUDE "RWMAKE.CH"   
#INCLUDE "PROTHEUS.ch"
/*
----------------------------------------------------------------------------------------
Autor   : Gildesio Campos     		Data: 09/09/10 
Programa: RDDA
----------------------------------------------------------------------------------------
Objetivo: Especifico para arquivo de remessa de titulo RASTREADOS - DDA
----------------------------------------------------------------------------------------
Uso: Utilizado no arquivo de Configuração Cnab a Pagar 237_PAGE.CPE quando o bordero de 
	pagamentos modelo 30 - PAGAMENTO DE TITULOS RASTREADOS - DDA
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
Autor   : Gildesio Campos     		Data: 09/09/10 
Programa: RDDA01
----------------------------------------------------------------------------------------
Objetivo: Alegação do Sacado --> 01-Aceite 	02-Nao Aceite
----------------------------------------------------------------------------------------
*/
User Function RDDA01()    
Local cRet := ""
Local cBco := Substr(SE2->E2_CODBAR,1,3)  

If cBco == '237' 
//	If xPos == '1'	//-->Chamada da rotina na posição 374-375 --> titulos Cobranca Bradesco
		/*	Pos.374-375 --> ( 2)-Reconhecimento da Divida 1-Aceite 2-Nao Aceite  
			Pos.376-379 --> ( 4)-Codigo Motivo da Alegação
			Pos.380-398 --> (19)-Brancos  ( 1)-DV do codigo de barras
			Pos.399-413 --> (15)-CNPJ/CPF Sacador / Avalista
		*/
		cRet := StrZero(Val(SE2->E2_X_DDAOK),2)+If(SE2->E2_X_DDAOK == '2',"0207" + Space(34),Space(38))    //=40
//	EndIf
Else
//	If xPos == '2'	//-->Chamada da rotina na posição 401-402 --> titulos de Terceiros (preenche pos.374-413)
		/*	Pos.374-398 --> (25)-Campo Livre
			Pos.399-399 --> ( 1)-DV do codigo de barras
			Pos.400-400 --> ( 1)-Moeda 
			Pos.401-402 --> ( 2)-Reconhecimento da Divida 1-Aceite 2-Nao Aceite                   
			Pos.403-406 --> ( 4)-Codigo Motivo da Alegação
			Pos.407-413 --> ( 7)-Brancos     
		*/
        cCL  := Substr(SE2->E2_CODBAR,20,25)+Substr(SE2->E2_CODBAR,5,1)+Substr(SE2->E2_CODBAR,4,1)
		cRet := cCL + StrZero(Val(SE2->E2_X_DDAOK),2) + If(SE2->E2_X_DDAOK == '2',"0207"+Space(7),Space(11))  //=40
//	EndIf
EndIf           

Return(cRet)
