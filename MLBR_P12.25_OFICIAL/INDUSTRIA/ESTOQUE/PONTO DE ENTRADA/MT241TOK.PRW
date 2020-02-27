#INCLUDE "rwmake.CH"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	MT241TOK()
// Autor 		Bruno Mota
// Data			03/03/10
// Descricao  	Ponto de entrada na rotina de movimentos internos modelo II.
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
User Function MT241TOK()
////////////////////////
Local _lRet 	:= .t.
Local _nI

nPosQtd :=aScan(aHeader,{|x|AllTrim(x[2])=="D3_QUANT"}) 

If FunName() == 'MATA185'
	
	_aAlias    := GetArea()
	_aAliasSCP := GetArea('SCP')
	_aAliasSCQ := GetArea('SCQ')
	
	_aEstru := {}
	aAdd(_aEstru,{'CQ_NUM'		, 'C',  6, 0})
	aAdd(_aEstru,{'CQ_PRODUTO'	, 'C',  6, 0})
	aAdd(_aEstru,{'B1_DESC'		, 'C', 60, 0})
	aAdd(_aEstru,{'CQ_CC'		, 'C',  9, 0})
	aAdd(_aEstru,{'CQ_QUANT'	, 'N', 12, 2})
	aAdd(_aEstru,{'D3_QUANT'	, 'N', 12, 2})
	aAdd(_aEstru,{'CQ_UM'		, 'C',  2, 0})
	aAdd(_aEstru,{'AH_DESCPO'	, 'C', 40, 0})
	aAdd(_aEstru,{'CP_OBS'		, 'C', 30, 0})
	aAdd(_aEstru,{'CP_SOLICIT'	, 'C', 25, 0})
	
	_cTmp := CriaTrab(_aEstru,.t.)

	IF SELECT( 'TMP' ) > 0
		DbSelectArea( 'TMP' )
		DbcloseArea()
	ENDIF

	DbUseArea(.t.,,_cTmp,'TMP',.t.,.f.)
	
	For _nI := 1 to len(aCols)
		RecLock('TMP',.t.)
		TMP->CQ_NUM 	:= a185Dados[_nI, 2]
		TMP->CQ_PRODUTO := a185Dados[_nI, 4]
		TMP->B1_DESC 	:= a185Dados[_nI, 5]
		TMP->CQ_CC 		:= a185Dados[_nI,10]
		TMP->D3_QUANT 	:= aCols[_nI, nPosQtd]
		TMP->CQ_UM 		:= a185Dados[_nI, 7]
		TMP->AH_DESCPO 	:= Posicione('SAH',1,xFilial('SAH') + a185Dados[_nI, 7],'AH_DESCPO')
		TMP->CP_OBS 	:= Posicione('SCP',1,xFilial('SCP') + a185Dados[_nI, 2] + a185Dados[_nI, 3],'CP_OBS')
		TMP->CP_SOLICIT := SCP->CP_SOLICIT
		TMP->CQ_QUANT 	:= SCP->CP_QUANT
		MsUnLock()
	Next
     
    if cFilAnt <> '09' //Desativado conforme solicitação via chamado HDi 003047 aberto por Andre Mansano
		U_MAESTR01(.T.)
	endif
	
	fErase(_cTmp + '.dbf')
	RestArea(_aAliasSCP)
	RestArea(_aAliasSCQ)
	RestArea(_aAlias)

	Pergunte('MTA185',.f.)

Else
	
	nPosObs := AScan(aHeader,{|x| AllTrim(x[2]) == "D3_ATLOBS"})
	For _nI := 1 To Len(aCols)
		//Verifica se o campo foi preenchido
		If empty(GdFieldGet('D3_ATLOBS',_nI)) .and. (Type("lDesAuto") == "U")
			_lRet := .f.
			Alert("Campo de observação na linha " + StrZero(_nI,2) + " não pode estar em branco!")
			Exit
		EndIf 
		
			/*
		 * Bloqueio de TM
		 * Solic. Marcelo Freitas - Custos 
		 * Diego Henrique Mafisolli 09/03/2017
		 */    		
		_lRet := U_VLDMOVTM(GdFieldGet('D3_COD',_nI), cTM, StrZero(_nI,2))
	Next
	
EndIf
Return(_lRet)
