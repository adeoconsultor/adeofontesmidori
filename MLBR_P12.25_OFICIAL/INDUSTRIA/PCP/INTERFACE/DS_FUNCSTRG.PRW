#include 'Protheus.ch' 
#include 'rwmake.ch' 

/*
  LOCAL PARA ARMAZENAR FUNCOES DESTINADAS A TRABALHAR COM STRINGS
*/ 

/**
 * Funcao utilizada para retirar os "SS" e "*" da variavel cUsuario
 *  
 * @author  : Diego Silva
 * @version : 26/07/2012
 * 
 * @param   : Char cUsuClean // Variavel que recebe o nome do usuario
 */                                                              
user function dsCleanUsu(cUsuClean)
	// Retirar os "SS"
	cUsuClean := StrTran(cUsuClean,'SS','')
	// Retirar os "*"
	cUsuClean := StrTran(cUsuClean,'*','')
return cUsuClean