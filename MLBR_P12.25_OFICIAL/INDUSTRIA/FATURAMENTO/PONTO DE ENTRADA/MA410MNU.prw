#include "Protheus.Ch"
#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MT410BRW ³ Autor ³ Paulo R. Trivellato   ³ Data ³ 28.04.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inclui opção específica na chamada do browse de pedidos de ³±±
±±³          ³ venda (aRotina).                                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MT410BRW( nOpca )                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico: Midori Atlantica                               ³±±
±±³          ³ Ponto de Entrada antes de chamar browse.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³TI0470        ³29/04/08³ ---  ³ Inclusao de opcoes no aRotina          ³±±
±±³              ³        ³      ³                                        ³±±
±±³              ³        ³      ³                                        ³±±
±±³              ³        ³      ³                                        ³±±
±±³              ³        ³      ³                                        ³±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MA410MNU()  
                          ********************************************************************
If Funname() == "MATA410" /// Para nao contemplar o módulo de Exportação - Luiz - 16/07/2010
                          ********************************************************************
	//Condicao gerada  por Humberto Garcia para adequacao na utilizacao do browse pelos usuarios de Penapolis e Penapolis 2
	_aRotina := {}
	aAdd(_aRotina, { "Altera Tudo"				,"A410Altera"		, 0 , 4 , 20 , NIL})	//"Alterar"
	aAdd(_aRotina, { "Alt. Dados do P.Venda"	,"U_CFATA001"		, 0 , 4 })				// Alteração do Cabeçalho do Pedido de Venda
	aAdd(_aRotina, { "Alt. Dados p/ NF"			,"U_CFATA002"		, 0 , 4 })				// Alteração do Cabeçalho da Nota Fiscal de Saída
	aRotina[4] :=  {'Alterações'				, aClone(_aRotina)	, 0, 4 }
	
	_aRotina := {}
	aAdd(_aRotina, { "Imprimir Pré-Nota"		,"U_MAFATR01"	, 0 , 0})		// pre-nota
	If SM0->M0_CODFIL != '08' .and. SM0->M0_CODFIL != '09' .and. SM0->M0_CODFIL != '12'
		aAdd(_aRotina, { "Imp. NFiscal Saída","U_NFMIDORI(SC5->C5_NOTA,SC5->C5_SERIE,2)", 0 , 4})		// Impressão da Nota Fiscal de Saída
	ElseIf SM0->M0_CODFIL = '08' .or. SM0->M0_CODFIL = '12'
		aAdd(_aRotina, { "Imp. NFiscal Saída","U_PFMIDORI2(SC5->C5_NOTA,SC5->C5_SERIE,2)", 0 , 4})		// Impressão da Nota Fiscal de Saída
	Else
		aAdd(_aRotina, { "Imp. NFiscal Saída","U_PNFMIDORI(SC5->C5_NOTA,SC5->C5_SERIE,2)", 0 , 4})		// Impressão da Nota Fiscal de Saída
	EndIf
	aAdd(_aRotina, { "Boleto Bradesco"    , "U_RBolbrad('A')" , 0 , 6} )  //
	aAdd(_aRotina, { "Boleto Banco Tokyo" , "U_BolTokyo" , 0 , 6} )
	aAdd(aRotina,  { "Impressões"         , _aRotina     , 0 , 6} )  //
	
	//Aadd(aRotina, { "Alt. Dados do P.Venda"	,"U_CFATA001"	, 0 , 4})		// Alteração do Cabeçalho do Pedido de Venda
	//Aadd(aRotina, { "Alt. Dados p/ NF"		,"U_CFATA002"	, 0 , 4})		// Alteração do Cabeçalho da Nota Fiscal de Saída
	Aadd(aRotina, { "Nova Liberacao"		,"A455LibAlt"	, 0 , 0})		// "Nova Liberacao"
	aAdd(aRotina, { "Consulta NF"			,"U_MA_090"		, 0, 4, 20, nil})
	aAdd(aRotina, { "Estorna Liberação"		,"U_MA_BLQPV"	, 0, 4, 20, nil})
	
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
	MsgBox('Nota Fiscal não encontrada','ATENÇÃO!!!','INFO')
EndIf

Return()


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Estorna liberações do pedido de venda
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
	MsgBox('Pedido já faturado, a liberação não pode ser estornada!','ATENÇÃO!!!','INFO')
	_lRet := .f.

ElseIf MsgBox('Confirma estorno das liberações do pedido','ATENÇÃO!!!','YESNO')

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

	MsgBox('Liberação estornada!','ATENÇÃO!!!','INFO')

Else
	MsgBox('Liberação não foi estornada!','ATENÇÃO!!!','INFO')
EndIf

RestArea(_aAlias)
Return(_lRet)