#INCLUDE "rwmake.ch"
/*
---------------------------------------------------------------------------------------------
Funcao  : MTA185MNU							Tipo: Ponto de Entrada
---------------------------------------------------------------------------------------------
Objetivo: Inclui opcao Imprimir Recibo de requisi��o no Browse da Baixa de Pre-requisi��o
-------------------------------------------------------------------------------------------*/
User Function MTA185MNU()  

aAdd(aRotina, { "Recibo de requisi��o" , "U_MAESTR01(.f.)" , 0 , 6} )  //

Return()