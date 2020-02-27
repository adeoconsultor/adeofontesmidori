#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	MT240TOK()
// Autor 		Alexandre Dalpiaz
// Data			08/06/10
// Descricao  	Validaçao do estoque na digitação do pedido de vendas
//            	Utiliza o parâmtro mv_par08 (MTA410): 1 - não bloqueia estoque (padrão)
//				2 - Bloqueia se não tiver saldo em estoque, 3 - Pede confirmação do usuário
// Uso         	Midori Atlantica
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MA_410EST()
/////////////////////////
Local _lRet := .t., _cEnter := chr(13) + chr(10)
Local _nQuant, _cLocal, _nSaldo, _cTexto, _nQtdVen

if SA1->A1_EST <> "EX" .and. !Altera //alterado para nao contemplar exportacao - Jose Roberto - Taggs 
	
	If mv_par08 == 1
		Return(.t.)
	EndIf
	
	If ReadVar() == 'M->C6_QTDVEN'
		_cLocal  := GdFieldGet('C6_LOCAL',n)
		_nQtdVen := M->C6_QTDVEN
	ElseIf ReadVar() == 'M->C6_LOCAL'
		_cLocal  := M->C6_LOCAL
		_nQtdVen := GdFieldGet('C6_QTDVEN',n)
	EndIf
	
	_nQuant := Posicione('SB2',1,xFilial('SB2') + GdFieldGet('C6_PRODUTO') + _cLocal ,'B2_QATU')
	_nSaldo := _nQuant - SB2->B2_RESERVA - SB2->B2_QPEDVEN - SB2->B2_QEMP
	
	If _nQtdVen > _nSaldo
		_cTexto := 'Produto: ' + alltrim(SB1->B1_COD) + ' - ' + SB1->B1_DESC + _cEnter + _cEnter
		_cTexto += 'Estoque atual: ' + tran(_nQuant,'@E 999,999.9999') + _cEnter
		If SB2->B2_QEMP > 0
			_cTexto += 'Quant Empenhada: ' + tran(SB2->B2_QEMP,'@E 999,999.9999') + _cEnter
		EndIf
		If SB2->B2_RESERVA > 0
			_cTexto += 'Quant Reservada: ' + tran(SB2->B2_RESERVA,'@E 999,999.9999') + _cEnter
		EndIf
		If SB2->B2_QPEDVEN > 0
			_cTexto += 'Quant em Ped Venda: ' + tran(SB2->B2_QPEDVEN,'@E 999,999.9999') + _cEnter
		EndIf
		
		If mv_par08 == 2		// bloqueia estoque - não permite digitação do item
			Aviso('Estoque indisponível',_cTexto,{'OK'},3)
			_lRet := .f.
		ElseIf mv_par08 == 3		// confirma se bloqueia estoque
			_lRet := (Aviso('Estoque indisponível',_cTexto,{'Continuar','Cancelar'},3) == 1)
		EndIf
	EndIf
endif
Return(_lRet)
