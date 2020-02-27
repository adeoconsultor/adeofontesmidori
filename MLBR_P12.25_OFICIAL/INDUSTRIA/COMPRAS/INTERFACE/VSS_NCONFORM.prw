#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VSS_NCONF ºAutor  ³ Vinicius Schwartz  º Data ³  25/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela para inserir dados de Não Conformidade de Fornecedor   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso.      ³Rotina de inclusao de quantidade não conforme nas NF-Entradaº±±
±±º          ³Permite ao usuário informar no registro da tabela SD1, refe-º±±
±±º          ³rente a uma determinada NF de entrada qual a quantidade de  º±±
±±º          ³um determinado produto que foi entregue pelo fornecedor em  º±±
±±º          ³não conformidade.											  º±±
±±º          ³Solicitação de Edson Oseko - Qualidade.					  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

User Function VSS_NCONF

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cGetCdFor  := Space(6)
Private cGetCodPro := Space(15)
Private cGetLjFor  := Space(2)
Private cGetNF     := Space(9)
Private cGetQtd1   := 0
Private cGetQtd2   := 0
Private cGetSer    := Space(3)
Private cSayFor    := Space(50)
Private cSayGrp    := Space(4)
Private cSayProd   := Space(50)
Private cSayUm     := Space(2)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oSay1","oSay2","oSay3","oSayFor","oSay4","oSay5","oSay6","oSay7","oSayProd","oSay8")
SetPrvt("oSay10","oSayGrp","oSay12","oSayUm","oGetCdFor","oGetLjFor","oGetNF","oGetSer","oGetCodPro")
SetPrvt("oGetQtd2","oBtn1","oBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 181,468,461,1004,"Lançamento de Não Conformidade",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 006,005,{||"Cod. For:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 006,092,{||"Loja:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,022,008)
oSay3      := TSay():New( 020,005,{||"Fornecedor:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayFor    := TSay():New( 020,038,{|u| If(PCount()>0, cSayFor:=u, cSayFor)},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,216,008)
oSay4      := TSay():New( 038,005,{||"Num. NF:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay5      := TSay():New( 038,105,{||"Série:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6      := TSay():New( 055,005,{||"Cod. Prod:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay7      := TSay():New( 072,005,{||"Desc:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayProd   := TSay():New( 072,032,{|u| If(PCount()>0, cSayProd:=u, cSayProd)},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,224,008)
oSay8      := TSay():New( 088,005,{||"Qtde. na Entrada:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSay9      := TSay():New( 088,073,{||"Qtde. Não Conforme:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay10     := TSay():New( 056,100,{||"Grupo:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayGrp    := TSay():New( 056,120,{|u| If(PCount()>0, cSayGrp:=u, cSayGrp)},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay12     := TSay():New( 056,160,{||"UM:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayUm     := TSay():New( 056,176,{|u| If(PCount()>0, cSayUm:=u, cSayUm)},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetCdFor  := TGet():New( 004,033,{|u| If(PCount()>0,cGetCdFor:=u,cGetCdFor)},oDlg1,053,008,'',{||Vld_For(cGetCdFor,.T.)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2","cGetCdFor",,)
oGetLjFor  := TGet():New( 004,109,{|u| If(PCount()>0,cGetLjFor:=u,cGetLjFor)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetLjFor",,)
oGetNF     := TGet():New( 036,033,{|u| If(PCount()>0,cGetNF:=u,cGetNF)},oDlg1,065,008,'',{||Vld_NF(cGetNF,.T.)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF1","cGetNF",,)
oGetSer    := TGet():New( 036,125,{|u| If(PCount()>0,cGetSer:=u,cGetSer)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetSer",,)
oGetCodPro := TGet():New( 054,033,{|u| If(PCount()>0,cGetCodPro:=u,cGetCodPro)},oDlg1,060,008,'',{||Vld_Prod(cGetCodPro,.T.)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetCodPro",,)
oGetQtd1   := TGet():New( 100,005,{|u| If(PCount()>0,cGetQtd1:=u,cGetQtd1)},oDlg1,048,008,'@E 9,999,999.9999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtd1",,)
oGetQtd2   := TGet():New( 100,073,{|u| If(PCount()>0,cGetQtd2:=u,cGetQtd2)},oDlg1,052,008,'@E 9,999,999.9999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtd2",,)
oBtn1      := TButton():New( 115,208,"Confirma",oDlg1,{|| Vld_Tudo()},049,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 116,149,"Cancela",oDlg1,{|| oDlg1:End()},049,012,,,,.T.,,"",,,,.F. )

oGetQtd1:Disable()

oDlg1:Activate(,,,.T.)

Return

//Valida o fornecedor informado
Static Function Vld_For(cCodFor,lMoment)
Local lRet := .F.

DbSelectArea('SA2')
DbSetOrder(1)

If cCodFor == Space(6)
	lRet := .T.
Else	
	If DbSeek(xFilial('SA2') + cCodFor)
		cGetLjFor:=SA2->A2_LOJA
		cSayFor:=SA2->A2_NOME
		
		oGetLjFor:Refresh()
		oSayFor:Refresh()
		
		lRet:=.T.
	Else
		Alert('O fornecedor informado não é válido. Favor checar!')
		oGetCdFor:SetFocus()
		Return
	Endif
Endif

If lMoment
	cGetQtd1 := 0
	cGetQtd2 := 0
	oGetQtd1:Refresh()
	oGetQtd2:Refresh()
Endif

Return lRet

//Valida a NF informada
Static Function Vld_NF(cDoc,lMoment)
Local lRet := .F.

DbSelectArea('SF1')
DbSetOrder(1)

If cDoc == Space(9)
	lRet := .T.
Else
	If DbSeek(xFilial('SF1') + cDoc)
		
		If SF1->F1_FORNECE <> cGetCdFor .And. SF1->F1_LOJA <> cGetLjFor
			Alert('Essa NF não corresponde ao fornecedor informado. Favor checar!')
			oGetCdFor:SetFocus()
			Return
		Else	
			cGetSer:=SF1->F1_SERIE
		
			oGetSer:Refresh()
		
			lRet:=.T.
		endif
		
	Else
		Alert('A NF informada não é válida. Verifique se a mesma pertence a filial logada.! -> ' + xFilial('SD1'))
		oGetCdFor:SetFocus()
		Return
	Endif
Endif

If lMoment
	cGetQtd1 := 0
	cGetQtd2 := 0
	oGetQtd1:Refresh()
	oGetQtd2:Refresh()
Endif

Return lRet

//Valida o produto informado
Static Function Vld_Prod(cProd,lMoment)//Variavel lMoment indica .T. na informacao do cod, ou .F. na chamada de funcao na confirmacao. Isso para nao zerar o valr de QTde2
Local lRet := .F.
Local nCount := 0

DbSelectArea('SD1')
DbSetOrder(2)

If cProd == Space(15)
	lRet := .T.
Else
	If DbSeek (xFilial('SD1')+cProd+cGetNF+cGetSer+cGetCdFor+cGetLjFor)
		cSayGrp:=SD1->D1_GRUPO
		cSayUm:=SD1->D1_UM
		cSayProd:=SD1->D1_X_DESCR
	    
		While !SD1->(Eof()) .And. (xFilial('SD1')+cProd+cGetNF+cGetSer+cGetCdFor+cGetLjFor) == (SD1->D1_FILIAL+SD1->D1_COD+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
			
			If lMoment
				cGetQtd1+=SD1->D1_QUANT
				cGetQtd2+=SD1->D1_X_NCONF
			endif
			
			nCount ++
			
			DbSkip()
		EndDo

	
		oSayGrp:Refresh()
		oSayUm:Refresh()
		oSayProd:Refresh()
		oGetQtd1:REfresh()
		oGetQtd2:Refresh()
	Endif
	
	If nCount > 0
		lRet := .T.
	Else
			Alert ('Produto não encontrado na NF informada. Favor checar.')
			lRet := .F.
	Endif
	
Endif

Return lRet

//Valida todas as informacoes antes da confirmacao
Static Function Vld_Tudo()
lRet := .F.

//Passara por todas as validacoes novamente
If Vld_For(cGetCdFor,.F.) .And. Vld_NF(cGetNF,.F.) .And. Vld_Prod(cGetCodPro,.F.)
	lRet := .T.
Else
	Alert('Provavelmente alguma das informações acima não corresponde à mesma NF. Favor checar!')
	Return .F.
Endif

//Verifica se ficou algum campo em branco
If cGetCdFor == Space(6) .Or. cGetCodPro == Space(15) .Or. cGetLjFor == Space(2) .Or. cGetNF == Space(9) .Or. cGetSer == Space(3) .Or. cGetQtd1 == 0 
	Alert ('Existe algum campo que não foi preenchido. Favor verificar!')
	Return .F.
Endif

//Valida se a quantidade informada nao eh maior que a original
If lRet == .T. .And. (cGetQtd1 < cGetQtd2 .Or. cGetQtd2 < 0)
	Alert('A quantidade em não conformidade não pode ser maior que a quantidade original de entrada, que é = '+ cValToChar(cGetQtd1) +'. Favor checar!')
	Return .F.
Else
	DbSelectArea('SD1')
	DbSetOrder(2)

	If DbSeek(xFilial('SD1') + cGetCodPro + cGetNF + cGetSer + cGetCdFor + cGetLjFor)
	
		While !SD1->(Eof()) .And. (xFilial('SD1')+cGetCodPro+cGetNF+cGetSer+cGetCdFor+cGetLjFor) == (SD1->D1_FILIAL+SD1->D1_COD+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
			Alert('cGetQtd2 -> ' + cValToChar(cGetQtd2))
			If cGetQtd2 > SD1->D1_QUANT
				RecLock('SD1',.F.)//Altera
					SD1->D1_X_NCONF := SD1->D1_QUANT
					SD1->D1_X_USUNC := UsrRetname(RetCodUsr())
				MsUnlock('SD1')	
				cGetQtd2:= cGetQtd2 - SD1->D1_X_NCONF
			Else
				RecLock('SD1',.F.)//Altera
					SD1->D1_X_NCONF := cGetQtd2
					SD1->D1_X_USUNC := UsrRetname(RetCodUsr())
				MsUnlock('SD1')	
				cGetQtd2:= cGetQtd2 - SD1->D1_X_NCONF
			Endif
		
		
			DbSkip()
		Enddo
	
	Endif
	lRet := .T.
Endif

If lRet
	Msginfo('Processo concluído com sucesso!')
Else
	Alert('Houve algum erro no processo. Tente fazê-lo novamente.')
Endif

cGetQtd1   := 0
cGetQtd2   := 0
cGetCodPro := Space(15)
cSayGrp    := Space(4)
cSayProd   := Space(50)
cSayUm     := Space(2)

oGetQtd1:Refresh()
oGetQtd2:Refresh()
oGetCodPro:Refresh()
oSayGrp:Refresh()
oSayProd:Refresh()
oSayUm:Refresh()

oGetCdFor:SetFocus()

Return lRet