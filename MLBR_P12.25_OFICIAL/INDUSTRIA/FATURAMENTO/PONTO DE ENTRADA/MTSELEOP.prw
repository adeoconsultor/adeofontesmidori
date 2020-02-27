#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	MTSELEOP
// Autor 		Alexandre Dalpiaz
// Data 		09/05/10
// Descricao  	Ponto de entrada na tela pedidos de vendas/Previsão de vendas. Para escolha de opcionais dos produtos
//				Utiliza quinta pergunta do grupo MTA410 /MTA700
// Uso         	Midori Atlantica
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MTSELEOP()
////////////////////////                        

local _lRet := .t.

If FunName() == 'MATA410'
	_lRet := iif(mv_par05 == 1,.t.,.f.)
ElseIf FunName() == 'MATA700'
	_lRet := iif(mv_par03 == 1,.t.,.f.)
EndIf

Return(_lRet)