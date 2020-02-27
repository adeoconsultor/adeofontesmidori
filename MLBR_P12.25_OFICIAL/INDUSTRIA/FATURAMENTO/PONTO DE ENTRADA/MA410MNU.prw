#include "Protheus.Ch"
#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MT410BRW � Autor � Paulo R. Trivellato   � Data � 28.04.09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Inclui op��o espec�fica na chamada do browse de pedidos de ���
���          � venda (aRotina).                                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MT410BRW( nOpca )                                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico: Midori Atlantica                               ���
���          � Ponto de Entrada antes de chamar browse.                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
���TI0470        �29/04/08� ---  � Inclusao de opcoes no aRotina          ���
���              �        �      �                                        ���
���              �        �      �                                        ���
���              �        �      �                                        ���
���              �        �      �                                        ���
���              �        �      �                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MA410MNU()  
                          ********************************************************************
If Funname() == "MATA410" /// Para nao contemplar o m�dulo de Exporta��o - Luiz - 16/07/2010
                          ********************************************************************
	//Condicao gerada  por Humberto Garcia para adequacao na utilizacao do browse pelos usuarios de Penapolis e Penapolis 2
	_aRotina := {}
	aAdd(_aRotina, { "Altera Tudo"				,"A410Altera"		, 0 , 4 , 20 , NIL})	//"Alterar"
	aAdd(_aRotina, { "Alt. Dados do P.Venda"	,"U_CFATA001"		, 0 , 4 })				// Altera��o do Cabe�alho do Pedido de Venda
	aAdd(_aRotina, { "Alt. Dados p/ NF"			,"U_CFATA002"		, 0 , 4 })				// Altera��o do Cabe�alho da Nota Fiscal de Sa�da
	aRotina[4] :=  {'Altera��es'				, aClone(_aRotina)	, 0, 4 }
	
	_aRotina := {}
	aAdd(_aRotina, { "Imprimir Pr�-Nota"		,"U_MAFATR01"	, 0 , 0})		// pre-nota
	If SM0->M0_CODFIL != '08' .and. SM0->M0_CODFIL != '09' .and. SM0->M0_CODFIL != '12'
		aAdd(_aRotina, { "Imp. NFiscal Sa�da","U_NFMIDORI(SC5->C5_NOTA,SC5->C5_SERIE,2)", 0 , 4})		// Impress�o da Nota Fiscal de Sa�da
	ElseIf SM0->M0_CODFIL = '08' .or. SM0->M0_CODFIL = '12'
		aAdd(_aRotina, { "Imp. NFiscal Sa�da","U_PFMIDORI2(SC5->C5_NOTA,SC5->C5_SERIE,2)", 0 , 4})		// Impress�o da Nota Fiscal de Sa�da
	Else
		aAdd(_aRotina, { "Imp. NFiscal Sa�da","U_PNFMIDORI(SC5->C5_NOTA,SC5->C5_SERIE,2)", 0 , 4})		// Impress�o da Nota Fiscal de Sa�da
	EndIf
	aAdd(_aRotina, { "Boleto Bradesco"    , "U_RBolbrad('A')" , 0 , 6} )  //
	aAdd(_aRotina, { "Boleto Banco Tokyo" , "U_BolTokyo" , 0 , 6} )
	aAdd(aRotina,  { "Impress�es"         , _aRotina     , 0 , 6} )  //
	
	//Aadd(aRotina, { "Alt. Dados do P.Venda"	,"U_CFATA001"	, 0 , 4})		// Altera��o do Cabe�alho do Pedido de Venda
	//Aadd(aRotina, { "Alt. Dados p/ NF"		,"U_CFATA002"	, 0 , 4})		// Altera��o do Cabe�alho da Nota Fiscal de Sa�da
	Aadd(aRotina, { "Nova Liberacao"		,"A455LibAlt"	, 0 , 0})		// "Nova Liberacao"
	aAdd(aRotina, { "Consulta NF"			,"U_MA_090"		, 0, 4, 20, nil})
	aAdd(aRotina, { "Estorna Libera��o"		,"U_MA_BLQPV"	, 0, 4, 20, nil})
	
Endif

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MA_090()  // CONSULTA NOTA FISCAL DE SAIDA A PARTIR DO PEDIDO DE VENDAS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

_aAlias := GetArea()
             
_cQuery := "SELECT DISTINCT C9_FILIAL, C9_NFISCAL, C9_SERIENF"
_cQuery += " FROM " + RetSqlName('SC9') + " SC9"
_cQuery += " WHERE C9_FILIAL = '" + SC5->C5_FILIAL + "'"
_cQuery += " AND C9_PEDIDO = '" + SC5->C5_NUM + "'"
_cQuery += " AND SC9.D_E_L_E_T_ <> '*'"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'_SC9',.F.,.T.)            
_cTexto := 'Este pedido foi faturado em mais de uma nota fiscal' + chr(13) + chr(10)
_cTexto += 'Selecione a nota que deseja consultar'

_aNotas := {'Sair'}
Do While !eof()         
	aAdd(_aNotas,_SC9->C9_NFISCAL + '/' + _SC9->C9_SERIENF)
	DbSkip()
EndDo                                                   
DbCloseArea()                                                       

If len(_aNotas) > 2
	_nNota := 2
	Do While _nNota > 1
		_nNota := Aviso('Consulta NF - Pedido: ' + SC5->C5_NUM,_cTexto ,_aNotas , 2 )
		If _nNota > 1
			a410VeNota(SC5->C5_FILIAL + left(_aNotas[_nNota],9) + right(_aNotas[_nNota],3)) 
		EndIf
	EndDo
Else
	a410VeNota(SC5->C5_FILIAL + left(_aNotas[2],9) + right(_aNotas[2],3))
EndIf

RestArea(_aAlias)
    
Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function a410VeNota(_cNota)
//////////////////////////////////

SF2->(DbSetOrder(1))
If SF2->(DbSeek(_cNota,.F.))
	MC090Visual()
Else
	MsgBox('Nota Fiscal n�o encontrada','ATEN��O!!!','INFO')
EndIf

Return()


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Estorna libera��es do pedido de venda
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MA_BLQPV()
////////////////////////
_aAlias := GetArea()
_lRet := .f.
DbSelectArea('SC9')
DbSetOrder(1)
DbSeek(xFilial('SC9') + SC5->C5_NUM,.F.)
_lTemNF  := .f.
_lTemLib := .f.
Do While !Eof() .and. xFilial('SC9') + SC5->C5_NUM == SC9->C9_FILIAL + SC9->C9_PEDIDO
	If !empty(SC9->C9_NFISCAL)
		_lTemNF := .t.
	EndIf
	DbSkip()
EndDo    
If _lTemNF
	MsgBox('Pedido j� faturado, a libera��o n�o pode ser estornada!','ATEN��O!!!','INFO')
	_lRet := .f.

ElseIf MsgBox('Confirma estorno das libera��es do pedido','ATEN��O!!!','YESNO')

	DbSeek(xFilial('SC9') + SC5->C5_NUM,.F.)
	Do While !Eof() .and. xFilial('SC9') + SC5->C5_NUM == SC9->C9_FILIAL + SC9->C9_PEDIDO
		
		If Empty(SC9->C9_NFISCAL)
			a460Estorna()
			_lRet := .t.
		Endif
		DbSkip()
	EndDo
	_cQuery := "UPDATE " + RetSqlName('SC6') 
	_cQuery += " SET C6_QTDEMP = 0, C6_QTDLIB = 0, C6_QTDLIB2 = 0, C6_QTDEMP2 = 0"
	_cQuery += " WHERE C6_FILIAL = '" + SC5->C5_FILIAL + "'"
	_cQuery += " AND C6_NUM = '" + SC5->C5_NUM + "'"
	TcSqlExec(_cQuery)

	MsgBox('Libera��o estornada!','ATEN��O!!!','INFO')

Else
	MsgBox('Libera��o n�o foi estornada!','ATEN��O!!!','INFO')
EndIf

RestArea(_aAlias)
Return(_lRet)