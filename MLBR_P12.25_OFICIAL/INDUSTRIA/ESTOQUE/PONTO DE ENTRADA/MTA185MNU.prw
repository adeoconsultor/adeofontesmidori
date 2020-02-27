#INCLUDE "rwmake.ch"
/*
---------------------------------------------------------------------------------------------
Funcao  : MTA185MNU							Tipo: Ponto de Entrada
---------------------------------------------------------------------------------------------
Objetivo: Inclui opcao Imprimir Recibo de requisição no Browse da Baixa de Pre-requisição
-------------------------------------------------------------------------------------------*/
User Function MTA185MNU()  

aAdd(aRotina, { "Recibo de requisição" , "U_MAESTR01(.f.)" , 0 , 6} )  //

Return()