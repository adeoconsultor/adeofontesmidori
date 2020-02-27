#INCLUDE "RWMAKE.CH"    
#INCLUDE "PROTHEUS.ch"
/*
----------------------------------------------------------------------------------------
Funcao: MT010ALT														Data: 02.09.2010
Autor : Sandro Albuquerque
----------------------------------------------------------------------------------------
Objetivo: PONTO DE ENTRADA PARA GRAVAR O USUARIO QUE EFETUOU A ALTERAÇÃO DO PRODUTO
--------------------------------------------------------------------------------------*/
User Function MT010ALT

IF ALTERA
	Replace	B1_XALTERA 	With RETCODUSR()+'-'+ALLTRIM(SUBSTR(CUSUARIO,7,15))+' -  EM '+DTOC(DDATABASE)
	Replace B1_XROTINA	With FUNNAME()
Endif              

Return()