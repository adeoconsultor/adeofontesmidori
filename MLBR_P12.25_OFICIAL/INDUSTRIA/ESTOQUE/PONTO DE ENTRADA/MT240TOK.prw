#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	MT240TOK()
// Autor 		Bruno Mota
// Data			03/03/10
// Descricao  	Ponto de entrada na rotina de movimentos internos modelo I.
//				Validaçao da rotina: validação do campo D3_ATLOBS
//
// Alterações
//
// Alexandre Dalpiaz
// Data 		20/05/10
// Descricao  	Utilizado na tela de confirmação da baixa pre-requisiçao ao armazem (MATA185)
//				Chamada para impressão o recibo de solicitações ao armazém
// Uso         	Midori Atlantica
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MT240TOK()
////////////////////////
_lRet := .t.
If FunName() == 'MATA185'
	
	aCols := {{}}
	aAdd(aCols[1], '')
	aAdd(aCols[1], '')
	aAdd(aCols[1], '')
	aAdd(aCols[1], M->D3_QUANT)
	
	a185Dados := {{}}
	aAdd(a185Dados[1], '')
	aAdd(a185Dados[1], SCP->CP_NUM) 	//				TMP->CQ_NUM 	:= a185Dados[_nI, 2]
	aAdd(a185Dados[1], SCP->CP_ITEM)	//				ITEM
	aAdd(a185Dados[1], SCP->CP_PRODUTO) //				TMP->CQ_PRODUTO := a185Dados[_nI, 4]
	aAdd(a185Dados[1], SCP->CP_DESCRI) 	//				TMP->B1_DESC 	:= a185Dados[_nI, 5]
	aAdd(a185Dados[1], '')
	aAdd(a185Dados[1], SCP->CP_UM) 		//				TMP->AH_DESCPO 	:= a185Dados[_nI, 7]
	aAdd(a185Dados[1], '')
	aAdd(a185Dados[1], '')
	aAdd(a185Dados[1], SCP->CP_CC) 		//				TMP->CQ_CC 		:= a185Dados[_nI,10]
	
	_lRet := U_MT241TOK()
	
Else
	
	If (Empty(M->D3_ATLOBS)) .And. (Type("lDesAuto") == "U")
		_lRet := .F.
		Alert("Campo de observação não pode estar em branco!")
	EndIf
	
EndIf    

/*
 * Bloqueio de TM
 * Solic. Marcelo Freitas - Custos 
 * Diego Henrique Mafisolli 09/03/2017
 */           
_lRet := U_VLDMOVTM(M->D3_COD, M->D3_TM)  

Return(_lRet)
