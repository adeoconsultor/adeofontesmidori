#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	F050BOT
// Autor 		Alexandre Dalpiaz
// Data 		28/04/10
// Descricao  	Ponto de entrada na tela de consulta de titulos a pagar. Inclui botão.
//				Em consulta de faturas, lista todos os títulos que compoem a fatura.
//				Em consulta de títulos integrantes de fatura, lista os movimentos de baixa da fatura
// Uso         	Midori Atlantica
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function F050BOT()
///////////////////////

_aButtons := {}        
If SE2->E2_FATURA = 'NOTFAT'
	aAdd(_aButtons,{'PMSZOOMIN',{|| U_MA_FC750()},'Títulos da Fatura','Títulos da Fatura'})
ElseIf !empty(SE2->E2_FATURA)
	aAdd(_aButtons,{'SIMULACA',{|| U_MA_FC750()},'Posição da Fatura','Posição da Fatura'})
EndIf
Return(_aButtons)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MA_FC750()
////////////////////////
Local _cEnter := chr(13) + chr(10)

If SE2->E2_FATURA = 'NOTFAT'
	
	_cQuery := "SELECT E2_FILORIG, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_NOMFOR, "
	_cQuery += _cEnter + " E2_EMISSAO, E2_VENCTO, E2_VENCREA, E5_DATA, E2_VALOR, E5_VALOR"
	_cQuery += _cEnter + " FROM " + RetSqlName('SE2') + " SE2 (NOLOCK)"
	
	_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SE5') + " SE5 (NOLOCK)"
	_cQuery += _cEnter + " ON SE5.D_E_L_E_T_ <> '*'"
	_cQuery += _cEnter + " AND E5_PREFIXO = E2_PREFIXO"
	_cQuery += _cEnter + " AND E5_NUMERO = E2_NUM"
	_cQuery += _cEnter + " AND E5_FORNECE = E2_FORNECE"
	_cQuery += _cEnter + " AND E5_LOJA = E2_LOJA"
	_cQuery += _cEnter + " AND E5_PARCELA = E2_PARCELA"
	_cQuery += _cEnter + " AND E5_TIPO = E2_TIPO"
	_cQuery += _cEnter + " AND E5_MOTBX = 'FAT'"
	
	_cQuery += _cEnter + " WHERE E2_FATURA = '" + SE2->E2_NUM + "'"
	_cQuery += _cEnter + " AND SE2.D_E_L_E_T_ <> '*'"
	
	MsAguarde({|| DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'TRB',.f.,.f.)},'Selecionando títulos...')

	TcSetField("TRB","E2_EMISSAO","D")
	TcSetField("TRB","E2_VENCTO" ,"D")
	TcSetField("TRB","E2_VENCREA","D")
	TcSetField("TRB","E5_DATA"   ,"D")
	
	DbGoTop()                                                                                 
	
	_aCols := {}
	Do While !eof()
		aAdd(_aCols, {E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_EMISSAO, E2_VENCTO, E2_VENCREA, E5_DATA, E2_VALOR, E5_VALOR,.F.})
		DbSkip()
	EndDo
	
	DbCloseArea()

	_nAltura 	:= 150 + 15 * len(_aCols)
	_nLargura 	:= oMainWnd:nClientWidth - 50
	_aHeader := {}

	DbSelectArea('SX3')
	DbSetOrder(2)
	DbSeek('E2_PREFIXO') ; AADD(_aHeader,{ TRIM(X3_TITULO)  , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E2_NUM'    ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,10, X3_DECIMAL 		, ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E2_PARCELA') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E2_TIPO'   ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E2_EMISSAO') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E2_VENCTO' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E2_VENCREA') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E5_DATA'   ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E2_VALOR'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E5_VALOR'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	_nOPc := 0
	oDlg1       := MSDialog():New( 20,0,_nAltura,_nLargura,"Títulos da fatura " + SE2->E2_NUM,,,.F.,,,,,,.T.,,,.T. )
	oDlg1:bInit := {||EnchoiceBar(oDlg1,{||_nOpc :=1,oDlg1:End() },{||_nOpc := 2,oDlg1:End()},.F.)}
	oBrwDiv     := MsNewGetDados():New(020,00,_nAltura/2-10,_nLargura/2,,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',,_aHeader,_aCols )
	oDlg1:Activate(,,,.t.)
	
ElseIf !empty(SE2->E2_FATURA)
	
	_cQuery := "SELECT E2_FILORIG, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_NOMFOR, "
	_cQuery += _cEnter + " E2_EMISSAO, E2_VENCTO, E2_VENCREA, E5_DATA, E2_VALOR, E5_VALOR, E5_RECPAG, E5_MOTBX"
	_cQuery += _cEnter + " FROM " + RetSqlName('SE2') + " SE2 (NOLOCK)"
	
	_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SE5') + " SE5 (NOLOCK)"
	_cQuery += _cEnter + " ON SE5.D_E_L_E_T_ <> '*'"
	_cQuery += _cEnter + " AND E5_PREFIXO = E2_PREFIXO"
	_cQuery += _cEnter + " AND E5_NUMERO = E2_NUM"
	_cQuery += _cEnter + " AND E5_FORNECE = E2_FORNECE"
	_cQuery += _cEnter + " AND E5_LOJA = E2_LOJA"
	_cQuery += _cEnter + " AND E5_PARCELA = E2_PARCELA"
	_cQuery += _cEnter + " AND E5_TIPO = E2_TIPO"
	
	_cQuery += _cEnter + " WHERE E2_NUM = '" + SE2->E2_FATURA + "'"
	_cQuery += _cEnter + " AND SE2.D_E_L_E_T_ <> '*'"
	
	MsAguarde({|| DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'TRB',.f.,.f.)},'Selecionando títulos...')
	
	DbGoTop()
	TcSetField("TRB","E2_EMISSAO","D")
	TcSetField("TRB","E2_VENCTO" ,"D")
	TcSetField("TRB","E2_VENCREA","D")
	TcSetField("TRB","E5_DATA"   ,"D")
	
	DbGoTop()                                                                                 
	
	_aCols := {}
	Do While !eof()
		aAdd(_aCols, {E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_EMISSAO, E2_VENCTO, E2_VENCREA, E5_DATA, E2_VALOR, E5_VALOR,.F.})
		DbSkip()
	EndDo
	
	DbCloseArea()

	_nAltura 	:= 150 + 15 * len(_aCols)
	_nLargura 	:= oMainWnd:nClientWidth - 50
	_aHeader := {}

	DbSelectArea('SX3')
	DbSetOrder(2)
	DbSeek('E2_PREFIXO') ; AADD(_aHeader,{ TRIM(X3_TITULO)  , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E2_NUM'    ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,10, X3_DECIMAL 		, ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E2_PARCELA') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E2_TIPO'   ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E2_EMISSAO') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E2_VENCTO' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E2_VENCREA') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E5_DATA'   ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E2_VALOR'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E5_VALOR'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , ''						, X3_USADO, X3_TIPO, X3_ARQUIVO } )
	_nOPc := 0
	oDlg1       := MSDialog():New( 20,0,_nAltura,_nLargura,"Títulos da fatura " + SE2->E2_NUM,,,.F.,,,,,,.T.,,,.T. )
	oDlg1:bInit := {||EnchoiceBar(oDlg1,{||_nOpc :=1,oDlg1:End() },{||_nOpc := 2,oDlg1:End()},.F.)}
	oBrwDiv     := MsNewGetDados():New(020,00,_nAltura/2-10,_nLargura/2,,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',,_aHeader,_aCols )
	oDlg1:Activate(,,,.t.)

EndIf
                                                 
Return()
