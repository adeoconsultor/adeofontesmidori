#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	ma_opmido
// Autor 		ANESIO G.FARIA - TAGGs Consultoria
// Data			04-03-2011
// Descricao  	Valida os planos para que o usuario nao duplique numero de planos em OPs
// Uso         	Midori Atlantica
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MA_OPMIDO()
//////////////////////////


Local _lRet 	:= .t.
Local _cTexto 	:= 'PLANO JA LANCADO '+ chr(13) + chr(13)
                                   
//Alert("OP: "+M->C2_OPMIDO)
/*if M->C2_OPMIDO <> space(12)
	dbSelectArea("SC2")   
	dbSetOrder(10)
		if dbSeek(xFilial("SC2")+M->C2_OPMIDO)
			while !SC2->(eof()).and.SC2->C2_OPMIDO == M->C2_OPMIDO
				if SC2->C2_OPMIDO == M->C2_OPMIDO .and. Year(SC2->C2_EMISSAO) == Year(M->C2_EMISSAO)
					_lRet   := MsgBox(_cTexto,'PLANO:'+SC2->C2_OPMIDO+" OP: "+SC2->C2_NUM,'ATENÇÃO!!!','ALERT')
					_lRet := .F.
				endif
				SC2->(dbSkip())
			enddo
		EndIf
	endif
*/	
Return(_lRet)

