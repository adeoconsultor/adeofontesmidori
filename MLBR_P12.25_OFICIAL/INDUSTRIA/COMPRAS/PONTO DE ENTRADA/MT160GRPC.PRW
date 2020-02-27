#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.ch"
/*
----------------------------------------------------------------------------------------
Autor : Diego Mafisolli
----------------------------------------------------------------------------------------
Objetivo: PE após analise cotacao para alterar campos do pedido de compra          
29/04/19 - Altera Prazo Entrega(C7_DATPRF) para data aprovacao SC + B1_PE - Solicit. Marcos Oliveira
----------------------------------------------------------------------------------------
*/

User Function MT160GRPC() 
	If SC1->C1_DATPRF < SC1->C1_DTAPROV+SB1->B1_PE
		SC7->C7_DATPRF := SC1->C1_DTAPROV+SB1->B1_PE
	Else
		SC7->C7_DATPRF := SC1->C1_DATPRF		           
	Endif      
Return()