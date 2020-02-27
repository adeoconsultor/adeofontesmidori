//#INCLUDE "Acdv250.ch" 
#include "protheus.ch"
#include "apvt100.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ UACDV250  ³ Autor ³ Antonio  	                     ³ Data ³ 24/05/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Embarque Simples Carrinho (R.F.)       						  		   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Rotina de embarque simples sobre os itens da Nota Fiscal de Saida	   ³±±
±±³       	 ³ OBS.: Nao utiliza controle de enderecamento/palletizacao                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
//Template function ACDV250(uPar1,uPar2,uPar3,uPar4,uPar5,uPar6,uPar7,uPar8,uPar9,uPar10)
//Return ACDV250(uPar1,uPar2,uPar3,uPar4,uPar5,uPar6,uPar7,uPar8,uPar9,uPar10)

User Function UACDV250

Private cNota
Private cSerie
Private cCodOpe := CBRetOpe()

If Empty(cCodOpe)
	VTAlert("Operador nao cadastrado","Aviso",.T.,4000)
	Return .F.
EndIf   

While .T.
	cNota  := Space(TamSx3("F2_DOC")[1])
	cSerie := Space(TamSx3("F2_SERIE")[1])
	VTClear()
	@ 0,00 VTSAY 'Embarque Carrinho'
	@ 1,00 VTSAY 'Nota :' VTGet cNota pict '@!' Valid VldNota(cNota) F3 "CBK" 
	@ 2,00 VTSAY 'Serie:' VTGet cSerie pict '@!' Valid VldNota(cNota+cSerie) .or. VtLastkey()==5
	VTRead
   	If VtLastKey() == 27                    
		Exit
	EndIf
 	Embarque()
EndDo  

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VldNota  º Autor ³Henrique Gomes Oikawaº Data ³  31/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a nota fiscal de saida                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ACD                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldNota(cChave)

If Empty(cChave)
	VTKeyBoard(chr(23))
	Return .F.
EndIf
SF2->(dbSetOrder(1))
If ! SF2->(dbSeek(xFilial()+cChave))
	VTAlert("Nota fiscal nao cadastrada","Aviso",.T.,4000,2)
	VTKeyBoard(chr(20))
	Return .F.
EndIf
If Len(cChave) < 9
	Return .t.
Endif
CBK->(DbSetOrder(1))
If CBK->(DbSeek(xFilial('CBK')+cChave)) .AND. (CBK->(CBK_CLIENT+CBK_LOJA+DTOS(CBK_EMISSA))<>SF2->(F2_CLIENTE+F2_LOJA+DTOS(F2_EMISSAO)))
	//Se a nota gravada na tabela de Conferencia Embarque 'CBK' diferente da Nota fiscal, exclui CBK/CBL
	UCBV250Del(SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA))
Endif
If CBK->(Eof())
	UCBV250Grv(SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA))
Endif

If CBK->CBK_STATUS == "2"
	IF ! VTYesNo("Embarque de Carrinho finalizado,Confirma reabertura da conferência?","Atencao",.T.,4000) //'Embarque finalizado, "Confirma reabertura da conferência?"'###'Atencao'
		VtClearGet("cNota")  // Limpa o get
		VtClearGet("cSerie")  // Limpa o get
		VTGetSetFocus("cNota")
		Return .F.
	EndIf
	UCBV250Del(SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA))
	UCBV250Grv(SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA))
Endif

Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UCBV250Del  ºAutor  ³ TOTVS               º Data ³  31/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exclui registros das tabelas CBK/CBL                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UCBV250Del(cChaveSF2)

CBK->(DbSetOrder(1))
CBK->(DbSeek(xFilial("CBK")+cChaveSF2))
While CBK->(!Eof() .AND. CBK_FILIAL+CBK_DOC+CBK_SERIE+CBK_CLIENT+CBK_LOJA == xFilial("CBK")+cChaveSF2)
	RecLock("CBK",.F.)
	CBK->(DbDelete())
	CBK->(MsUnlock())
	CBK->(DbSkip())
Enddo

CBL->(DbSetOrder(2))
CBL->(DbSeek(xFilial("CBL")+cChaveSF2))
While CBL->(!Eof() .AND. CBL_FILIAL+CBL_DOC+CBL_SERIE+CBL_CLIENT+CBL_LOJA == xFilial("CBL")+cChaveSF2)
	RecLock("CBL",.F.)
	CBL->(DbDelete())
	CBL->(MsUnlock())
	CBL->(DbSkip())
Enddo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CBV250Grv  ºAutor  ³ TOTVS               º Data ³  31/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega os itens das tabelas CBK / CBL           			 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UCBV250Grv(cChaveSF2)
Local aAreaSF2 := SF2->(GetArea())

SF2->(DbSetOrder(1))
SF2->(DbSeek(xFilial("SF2")+cChaveSF2))

//Grava cabecalho da Conferencia de Embarque:
RecLock("CBK",.T.)
CBK->CBK_FILIAL := xFilial('CBK')
CBK->CBK_DOC    := SF2->F2_DOC
CBK->CBK_SERIE  := SF2->F2_SERIE
CBK->CBK_CLIENT := SF2->F2_CLIENTE
CBK->CBK_LOJA   := SF2->F2_LOJA
CBK->CBK_EMISSA := SF2->F2_EMISSAO
CBK->CBK_STATUS := "0" //Embarque em andamento
CBK->CBK_XCARRI := "S" //Embarque De Carrinho
CBK->(MsUnlock())

RestArea(aAreaSF2)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Embarque ºAutor  ³Henrique Gomes Oikawaº Data ³  31/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz o embarque dos itens da nota fiscal         			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Embarque()
Local   bkey06
Local   bKey09
Local   bkey24
Local   cEtiqProd
Local   lUsaCB0 := UsaCB0('01')
Private lFimEmb := .f.

bkey09 := VTSetKey(09,{|| Informa()},"Informacoes")
bKey24 := VTSetKey(24,{|| Estorna()},"Estorno")        // CTRL+X //
While .t.
	If lUsaCB0
		cEtiqProd := Space(TamSx3("CB0_CODET2")[1])
	Else
		cEtiqProd := Space(48)
	Endif
	@ 4,00 VTSAY 'Leia a etiqueta'
	@ 5,00 VTGET cEtiqProd pict '@!' Valid uCBV250VEt(cEtiqProd)
	VTRead

	If lFimEmb

//		If ExistBlock("IMG11")
//		   ExecBlock("IMG11",,,{cEtiPallet})
//		   ExecBlock("IMG11",,,{cEtiqProd})
//		EndIf
		
//		If ExistBlock('IMG00')
//			ExecBlock("IMG00",,,{"UACDV250",cEtiqProd})
//		EndIf

		Exit
	EndIf

	If VTLastkey() == 27
		If ! VTYesNo('Confirma a saida?','Atencao',.T.)
			Loop
		EndIf
		AtuCBK(.t.)
		Exit
	EndIf
EndDo
vtsetkey(09,bkey09)
vtsetkey(24,bkey24)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CBV250VEt ºAutor  ³Henrique Gomes Oikawaº Data ³  31/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a etiqueta de produto								    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UCBV250VEt(cEtiqProd,lEstorna,nQtdEmbMonit,oGetEtiq)
Local   cTipo
Local   cProduto     := Space(TamSX3("CBL_PROD")[01])
Local   cLote        := Space(TamSX3("CBL_LOTECT")[01])
Local   cNumSerie    := Space(TamSX3("CBL_NUMSER")[01])
Local   nQE          := 1
Local   aEtiqueta    := {}
Local   lUsaCB0      := UsaCB0('01')
Local   lRet         := .f.
Default lEstorna     := .f.
Default nQtdEmbMonit := 1

If Empty(cEtiqProd)
	If IsTelNet()
		Return .f.
	Else
		Return .t.
	Endif
EndIf

cTipo  := CBRetTipo(cEtiqProd)
If cTipo == "01"  // --> Etiqueta de Produto  com CB0
	aEtiqueta:= CBRetEti(cEtiqProd,"01")
	If Empty(aEtiqueta)
		CBAlert("Etiqueta invalida","Aviso",.t.,4000,3)
		If IsTelNet()
			VtClearGet("cEtiqProd")  // Limpa o get
		Endif
		Return .f.
	EndIf
	If !Empty(CB0->CB0_PALLET)
	   	CBALERT("Etiqueta invalida, Produto pertence a um Pallet","AVISO",.T.,4000,2)
		If IsTelNet()
			VtClearGet("cEtiqProd")  // Limpa o get
		Endif
		Return .f.
	Endif   
	CBL->(DbSetOrder(1))
	If CBL->(DbSeek(xFilial('CBL')+CBK->(CBK_DOC+CBK_SERIE)+AllTrim(cEtiqProd))) .and. !lEstorna
	   	CBALERT("Etiqueta ja lida","AVISO",.T.,4000,2)
		If IsTelNet()
			VtClearGet("cEtiqProd")  // Limpa o get
		Endif
	   	Return .f.
	Endif
	CB0->(DbSetOrder(1))
	If CB0->(DbSeek(xFilial('CB0')+AllTrim(cEtiqProd))) .and. !lEstorna
		If CB0->CB0_ETQPAL == 'C'
		   	CBALERT("Etiqueta ja lida","AVISO",.T.,4000,2)
			If IsTelNet()
				VtClearGet("cEtiqProd")  // Limpa o get
			Endif
		   	Return .f.
		EndIf
	Endif
	cProduto  := aEtiqueta[01]
	nQE       := aEtiqueta[02] * nQtdEmbMonit
	cLote     := aEtiqueta[16]
	cNumSerie := aEtiqueta[23]
	If ! CBProdUnit(cProduto)
		nQE := CBQtdEmb(cProduto)
	EndIf
	If Empty(nQE)
		CBAlert("Quantidade invalida!","Aviso",.t.,4000,3)
		If IsTelNet()
			VtClearGet("cEtiqProd")  // Limpa o get
		Endif
		Return .f.
	EndIf      

	SBZ->(DbSetOrder(1))                                              //analisa se a etiqueta é mesmo de um carrinho
	If SBZ->(DbSeek(xFilial('SBZ')+cProduto )) .and. !lEstorna
		If SBZ->BZ_XCARRI <> 'S'
			CBAlert("Produto não pertence a um carrinho!","Aviso",.t.,4000,3)
			If IsTelNet()
				VtClearGet("cEtiqProd")  // Limpa o get
			Endif
			Return .f.
    	EndIf
	EndIf

Elseif cTipo $ "EAN8OU13-EAN14-EAN128" // --> Etiqueta EAN
	aEtiqueta := CBRetEtiEan(cEtiqProd)
	If Empty(aEtiqueta)
		CBAlert("Etiqueta invalida!","Aviso",.T.,4000,2)
		If IsTelNet()
			VtClearBuffer()
			VTkeyBoard(chr(20))
		Endif
	 	Return .f.
	EndIf
	cProduto  := aEtiqueta[01]
	nQE 	  := If(aEtiqueta[2] == 0,1,aEtiqueta[2]) * nQtdEmbMonit
	cLote     := aEtiqueta[16]    //03
	cNumSerie := aEtiqueta[23]    //05
	If ! CBProdUnit(cProduto)
		nQE := CBQtdEmb(cProduto)
	EndIf
	If Empty(nQE)
		CBAlert("Quantidade invalida!","Aviso",.t.,4000,3)
		If IsTelNet()
			VtClearBuffer()
			VTkeyBoard(chr(20))
		Endif
		Return .f.
	EndIf      
Else
	CBAlert("Etiqueta invalida!","Aviso",.t.,4000,3)
	If IsTelNet()
		VtKeyboard(Chr(20))  // zera o get
	Endif
	Return .F.
Endif

If !VldProd(cProduto,nQE,cLote,cNumSerie,If(lUsaCB0,CB0->CB0_CODETI,Space(10)),lEstorna)
 	Return .f.
EndIf

If IsTelNet()
	VtClearBuffer()
	VTKeyBoard(chr(20))
	lRet := .t.
Else
	lRet := .f.
Endif
AtuCBK()  //Atualiza status de conferencia embarque
If IsInCallStack("ACDA150")
	ACDA150Sts(.t.)
	oGetEtiq:buffer := Space(48)  
	cEtiq := Space(48)
Endif    

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VldProd  ºAutor  ³Henrique Gomes Oikawaº Data ³  31/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida o produto lido									   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldProd(cProduto,nQE,cLote,cNumSerie,cEtiqProd,lEstorna)
Local  aRetAnalise := {}
Local  nQtdeNota   := 0
Local  nQtdeEmb    := 0
Local  nQtdeNec    := 0
Local  lRet		   := .T.	
Local  lSai		   := .F.	

CBL->(DbSetOrder(6))
If lEstorna                                            

	If lRet .And. !CBL->(DbSeek(xFilial("CBL")+CBK->(CBK_DOC+CBK_SERIE+CBK_CLIENT+CBK_LOJA)+cProduto+cLote+cNumSerie+cEtiqProd))
		CBAlert("Não existe saldo a coletar para estorno deste produto!","Aviso",.T.,4000,2)
		lSai:= CBYesNo("Deseja sair da tela de estorno?","Aviso")
		lRet:= .f.
	Endif       
	
	If lRet .And. CBL->CBL_QTDEMB < nQE
		CBAlert("A quantidade informada e superior a quantidade lida!","Aviso",.T.,4000,2)
		lRet := .f.
	Endif
	
	If lRet .And. !CBYesNo("Confirma estorno?","Aviso")
		lRet:= .f.
	Endif
	
	If lRet
		RecLock('CBL',.F.)
		If CBL->CBL_QTDEMB > nQE
			CBL->CBL_QTDEMB -= nQE
		Else
			CBL->(DbDelete())
		Endif
		CBL->(MsUnlock())
		
		AtuCBK()  //Atualiza status de conferencia embarque
	EndIf
	
	If IsTelNet()
		VtClearBuffer()
		VTkeyBoard(chr(20))
	Endif         
	
	Return lSai
Endif
   /*
aRetAnalise := AnalisaEmb(cProduto,cLote,cNumSerie)
nQtdeNota 	:= aRetAnalise[01]
nQtdeEmb  	:= aRetAnalise[02]
nQtdeNec  	:= nQtdeNota - nQtdeEmb

If lRet .And. nQtdeNec <= 0
	CBAlert("Nao existe saldo a coletar deste produto!","Aviso",.T.,4000,2)
	If IsTelNet()
		VtClearBuffer()
		VTkeyBoard(chr(20))
	Endif
	lRet:= .f.
EndIf
	
If lRet .And. nQtdeNec < nQE
	CBAlert("Quantidade maior que necessaria!","Aviso",.T.,4000,2)
	If IsTelNet()
		VtClearBuffer()
		VTkeyBoard(chr(20))
	Endif
	lRet:=  .f.
EndIf*/

If lRet
	CBL->(dbSetOrder(6))       //xFilial('CBL')+CBK->CBK_DOC+CBK->CBK_SERIE+CBK->CBK_CLIENT+CBK->CBK_LOJA+cProduto+cLote
	If CBL->(DbSeek(xFilial('CBL')+CBK->CBK_DOC+CBK->CBK_SERIE+CBK->CBK_CLIENT+CBK->CBK_LOJA+cProduto+cLote+cNumSerie+cEtiqProd))
		RecLock('CBL',.F.)
		CBL->CBL_QTDEMB += nQE
		CBL->(MsUnlock())
		
		AtuCBK()  //Atualiza status de conferencia embarque

	Else

/*		cQuery := " SELECT DISTINCT G1_COD, G1_COMP, G1_QUANT, CB0_CODETI ,CB0_CODPRO,CB0_DTNASC,CB0_QTDE, CB0_OP "
		cQuery += " FROM "+RetSqlName("SG1")+" SG1, "+RetSqlName("SB1")+" SB1, "+RetSqlName("CB0")+" CB0 "
		cQuery += " WHERE SG1.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' '  AND CB0.D_E_L_E_T_ = ' ' "
		cQuery += " AND SG1.G1_COD = B1_COD AND SG1.G1_FILIAL = '" + xFilial('SG1') + '" "
		cQuery += " AND SG1.G1_COD = '" + cProduto + '" "
		cQuery += " AND CB0_CODPRO = G1_COMP "
		cQuery += " AND CB0_XKIT   = '" + CB0->CB0_XKIT + '" "
		cQuery += " AND CB0_XCARRI <> 'S' AND CB0.CB0_FILIAL = '" + xFilial('CB0') + '" "
		cQuery += " ORDER BY G1_COD, G1_COMP "
 */

		cQuery := " SELECT ((G1_QUANT / (100 - G1_PERDA)) * 100) G1_QUANT , G1_COD,B.B1_DESC, "
		cQuery += "        B.B1_UM,G1_COMP, A.B1_DESC, G1_UM , C.CB0_QTDE, CB0_CODETI , CB0_LOTE "
		cQuery += " FROM "+RetSqlName("SG1")+" SG1 "
		cQuery += " JOIN "+RetSqlName("SB1")+" A ON "
		cQuery += " 	A.B1_COD = SG1.G1_COMP AND A.D_E_L_E_T_ = ' ' AND A.B1_FILIAL = '" + xFilial('SB1') + "' "
		cQuery += "  JOIN "+RetSqlName("SB1")+" B ON B.B1_COD = G1_COD AND B.D_E_L_E_T_ = ' ' AND A.B1_FILIAL = '" + xFilial('SB1') + "' "
		cQuery += "  JOIN "+RetSqlName("CB0")+" C ON C.CB0_CODPRO = SG1.G1_COMP "
		cQuery += " 	 AND C.CB0_XKIT   = '" + CB0->CB0_XKIT + "' "
		cQuery += " 	 AND C.CB0_XCARRI <> 'S' AND C.CB0_FILIAL = '" + xFilial('CB0') + "' AND C.D_E_L_E_T_ = ' '"
//		cQuery += " 	                         AND C.CB0_FILIAL = '" + xFilial('CB0') + "' AND C.D_E_L_E_T_ = ' '"
		cQuery += " WHERE "
		cQuery += " 	    SG1.G1_FILIAL = '" + xFilial('CB0') + "' " 
		cQuery += " 	AND SG1.G1_COD = '" +cProduto + "' "
		cQuery += " 	AND SUBSTRING(SG1.G1_COMP,1,3) <> 'MOD' "
		cQuery += " 	AND SG1.G1_FIM > '20170101' "
		cQuery += " 	AND SG1.D_E_L_E_T_ = '' "
		cQuery += " ORDER BY SG1.G1_COD, SG1.G1_COMP "
	
		If Select("XTMPG1") > 0 
			dbSelectArea("XTMPG1")
			XTMPG1->(dbCloseArea())
		EndIf
		
		dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "XTMPG1", .T., .T. )
			
		dbSelectArea("XTMPG1")
		XTMPG1->(dbGotop())

		cCodPro:= ""                   //XTMPG1->G1_COMP			

		While XTMPG1->(!Eof())
		
			If cCodPro <> XTMPG1->G1_COMP			
     
				aRetAnalise := AnalisaEmb(XTMPG1->G1_COMP,XTMPG1->CB0_LOTE,cNumSerie)
				nQtdeNota 	:= aRetAnalise[01]
				nQtdeEmb  	:= aRetAnalise[02]
				nQtdeNec  	:= nQtdeNota - nQtdeEmb
				
				If lRet .And. nQtdeNec <= 0
					CBAlert("Nao existe saldo a coletar deste produto!","Aviso",.T.,4000,2)
					If IsTelNet()
						VtClearBuffer()
						VTkeyBoard(chr(20))
					Endif
					lRet:= .f.
				EndIf
					
				If lRet .And. nQtdeNec < nQE
					CBAlert("Quantidade maior que necessaria!","Aviso",.T.,4000,2)
					If IsTelNet()
						VtClearBuffer()
						VTkeyBoard(chr(20))
					Endif
					lRet:=  .f.
				EndIf

				If lRet
					RecLock('CBL',.T.)
					CBL->CBL_FILIAL := xFilial('CBL')
					CBL->CBL_DOC    := CBK->CBK_DOC
					CBL->CBL_SERIE  := CBK->CBK_SERIE
					CBL->CBL_CLIENT := CBK->CBK_CLIENT
					CBL->CBL_LOJA   := CBK->CBK_LOJA
					CBL->CBL_PROD   := XTMPG1->G1_COMP
					cLote:=XTMPG1->CB0_LOTE
					CBL->CBL_LOTECT := cLote
					CBL->CBL_NUMSER := cNumSerie
					CBL->CBL_CODETI := XTMPG1->CB0_CODETI       //cEtiqProd
					CBL->CBL_XCARRI := "S" //Embarque De Carrinho
	
//					CBL->CBL_QTDEMB += nQE
					CBL->CBL_QTDEMB := XTMPG1->CB0_QTDE

					CBL->(MsUnlock())
					
					CB0->(dbSetOrder(1))
					If CB0->(DbSeek(xFilial('CB0')+XTMPG1->CB0_CODETI))
						RecLock('CB0',.F.)
						CB0->CB0_XCARRI := 'S'
						CB0->(MsUnlock())
					EndIf

					AtuCBK()  //Atualiza status de conferencia embarque
	
					cCodPro:= XTMPG1->G1_COMP			

				EndIf
				
			EndIf	

			XTMPG1->(dbSkip())	

		EndDo
	    
		CB0->(dbSetOrder(1))
		If CB0->(DbSeek(xFilial('CB0')+cEtiqProd))
			RecLock('CB0',.F.)
			CB0->CB0_ETQPAL := 'C'
			CB0->(MsUnlock())
		EndIf

	Endif

EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Estorna	  ³ Autor ³Henrique Gomes Oikawa³ Data ³ 31/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Estorno das etiquetas lidas                       		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Estorna()
Local aTela	   := {}	
Local cEtiqueta                         
Local lUsaCB0  := UsaCB0('01')
Local lSai	   := .F.	

If Empty(cNota)
	Return
Endif

aTela := VTSave()
VTClear()                       
If lUsaCB0
   cEtiqueta := Space(TamSx3("CB0_CODET2")[1])
Else
   cEtiqueta := Space(48)
Endif
@ 00,00 VtSay Padc("Estorno da Leitura",VTMaxCol())
@ 02,00 VtSay "Etiqueta:"
@ 03,00 VtGet cEtiqueta pict "@!" Valid uCBV250VEt(cEtiqueta,.t.)
VtRead                    

vtRestore(,,,,aTela)

Return 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Informa    ³ Autor ³Henrique Gomes Oikawa³ Data ³ 01/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Mostra produtos que ja foram lidos                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Informa()
Local aCab,aSize,aSave := VTSAVE()
Local aHist:={}

If Empty(cNota)
	Return
Endif

CBL->(dbSetOrder(2))
CBL->(DbSeek(xFilial('CBL')+CBK->(CBK_DOC+CBK_SERIE+CBK_CLIENT+CBK_LOJA)))
While CBL->(!Eof() .and. CBL_FILIAL+CBL_DOC+CBL_SERIE+CBL_CLIENT+CBL_LOJA == xFilial('SF2')+CBK->(CBK_DOC+CBK_SERIE+CBK_CLIENT+CBK_LOJA))
	AADD(aHist,{CBL->CBL_CODETI,CBL->CBL_PROD,CBL->CBL_LOTECT,CBL->CBL_NUMSER,Transform(CBL->CBL_QTDEMB,"@E 999,999.99")})
	CBL->(DbSkip())
EndDo
aSort(aHist,,,{|x,y| x[2]+x[3]+x[4]+x[1] < y[2]+y[3]+y[4]+y[1] })

VTClear() 
@ 0,0 VTSay "Operador : "+cCodOpe
aCab  := {"Etiqueta","Produto","Lote","Num.Serie","Qtde"} //"Etiqueta"###"Produto"###"Qtde"
aSize := {10,15,10,20,12}
VTaBrowse(1,0,7,19,aCab,aHist,aSize)
VtRestore(,,,,aSave)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ AtuCBK     ³ Autor ³Henrique Gomes Oikawa³ Data ³ 31/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualiza o status da tabela de Cabecalho de Embarque (CBK) ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuCBK(lFinal)

Local aRetAnalise := {}
Local nQtdeNota   := 0
Local nQtdeEmb    := 0
Local lCarrinho   := .F.

Default lFinal    := .F.

aRetAnalise := AnalisaEmb()
nQtdeNota 	:= aRetAnalise[1]
nQtdeEmb  	:= aRetAnalise[2]

/*If nQtdeNota == nQtdeEmb
	lFimEmb := .t.
	CBAlert("Embarque finalizado!","Aviso",.T.,4000) //"Embarque finalizado!"###"Aviso"
	RecLock("CBK",.F.)
	CBK->CBK_DTEMBQ := dDataBase
	CBK->CBK_STATUS := "2" //Embarque finalizado
	CBK->(MsUnlock())
Else
	RecLock("CBK",.F.)
	CBK->CBK_STATUS := "1" //Embarque em andamento
	CBK->(MsUnlock())
	If lFinal
		CBAlert("Embarque em aberto!","Aviso",.T.,4000) //"Embarque em aberto!"###"Aviso"
	Endif
Endif
 */

cQuery := " SELECT CB0_XKIT, CB0_CODETI, CB0_XCARRI "
cQuery += " FROM "+RetSqlName("SG1")+" SG1 "
cQuery += " JOIN "+RetSqlName("SB1")+" A ON "
cQuery += " 	A.B1_COD = SG1.G1_COMP AND A.D_E_L_E_T_ = ' ' AND A.B1_FILIAL = '" + xFilial('SB1') + "' "
cQuery += "  JOIN "+RetSqlName("SB1")+" B ON B.B1_COD = G1_COD AND B.D_E_L_E_T_ = ' ' AND A.B1_FILIAL = '" + xFilial('SB1') + "' "
cQuery += "  JOIN "+RetSqlName("CB0")+" C ON C.CB0_CODPRO = SG1.G1_COMP "
cQuery += " 	 AND C.CB0_XKIT   = '" + CB0->CB0_XKIT + "' "
cQuery += " 	 AND C.CB0_FILIAL = '" + xFilial('CB0') + "' AND C.D_E_L_E_T_ = ' '"
cQuery += " WHERE "
cQuery += " 	    SG1.G1_FILIAL = '" + xFilial('CB0') + "' " 
cQuery += " 	AND SUBSTRING(SG1.G1_COMP,1,3) <> 'MOD' "
cQuery += " 	AND SG1.G1_FIM > '20170101' "
cQuery += " 	AND SG1.D_E_L_E_T_ = '' "
cQuery += " ORDER BY SG1.G1_COD, SG1.G1_COMP "

If Select("XTMPG1A") > 0 
	dbSelectArea("XTMPG1A")
	XTMPG1A->(dbCloseArea())
EndIf
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "XTMPG1A", .T., .T. )
	
dbSelectArea("XTMPG1A")
XTMPG1A->(dbGotop())
While XTMPG1A->(!Eof())

	If Empty(XTMPG1A->CB0_XCARRI)
    	lCarrinho := .T.
	EndIf

	XTMPG1A->(dbSkip())

EndDo

If !lCarrinho
	lFimEmb := .t.
	CBAlert("Embarque finalizado!","Aviso",.T.,4000) //"Embarque finalizado!"###"Aviso"
	RecLock("CBK",.F.)
	CBK->CBK_DTEMBQ := dDataBase
	CBK->CBK_STATUS := "2" //Embarque finalizado
	CBK->(MsUnlock())
Else
	RecLock("CBK",.F.)
	CBK->CBK_STATUS := "1" //Embarque em andamento
	CBK->(MsUnlock())
	If lFinal
		CBAlert("Embarque em aberto!","Aviso",.T.,4000) //"Embarque em aberto!"###"Aviso"
	Endif
Endif


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AnalisaEmb º Autor ³Henrique Gomes Oikawaº Data ³  31/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Analisa a necessidade de embarque do produto lido		     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AnalisaEmb(cProduto,cLote,cNumSerie)
Local   nQtdPrdNF := 0
Local   nQtdPrdEm := 0
Local   nQtdeNota := 0
Local   nQtdeEmb  := 0
Local   aRet      := {}

Default cProduto  := Space(TamSX3("CBL_PROD")[01])
Default cLote     := Space(TamSX3("CBL_LOTECT")[01])
Default cNumSerie := Space(TamSX3("CBL_NUMSER")[01])

SD2->(DbSetOrder(3))
SD2->(DbSeek(xFilial('SD2')+CBK->CBK_DOC+CBK->CBK_SERIE+CBK->CBK_CLIENT+CBK->CBK_LOJA))
While SD2->(!Eof()) .AND. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == xFilial('SF2')+CBK->CBK_DOC+CBK->CBK_SERIE+CBK->CBK_CLIENT+CBK->CBK_LOJA
	If !Empty(cProduto) .AND. (SD2->D2_COD+SD2->D2_LOTECTL+Alltrim(SD2->D2_NUMSERI) == cProduto+cLote+alltrim(cNumSerie))
		nQtdPrdNF += SD2->D2_QUANT
	Endif
	nQtdeNota += SD2->D2_QUANT
	SD2->(DbSkip())
EndDo

CBL->(dbSetOrder(2))                                                                  
CBL->(DbSeek(xFilial('CBL')+CBK->CBK_DOC+CBK->CBK_SERIE+CBK->CBK_CLIENT+CBK->CBK_LOJA))
While CBL->(!Eof()) .and. CBL->CBL_FILIAL+CBL->CBL_DOC+CBL->CBL_SERIE+CBL->CBL_CLIENT+CBL->CBL_LOJA == xFilial('SF2')+CBK->CBK_DOC+CBK->CBK_SERIE+CBK->CBK_CLIENT+CBK->CBK_LOJA
	If !Empty(cProduto) .AND. (CBL->CBL_PROD+CBL->CBL_LOTECT+alltrim(CBL->CBL_NUMSER) == cProduto+cLote+alltrim(cNumSerie))
		nQtdPrdEm += CBL->CBL_QTDEMB
	Endif
	nQtdeEmb += CBL->CBL_QTDEMB
	CBL->(DbSkip())
EndDo

If !Empty(cProduto)
	aRet := {nQtdPrdNF,nQtdPrdEm}
Else
	aRet := {nQtdeNota,nQtdeEmb}
Endif

Return aClone(aRet)
             

                        /*

SELECT ((G1_QUANT / (100 - G1_PERDA)) * 100) QUANT ,RTRIM(G1_COD) AS G1_COD,B.B1_DESC, B.B1_UM,RTRIM(G1_COMP) AS G1_COMP, A.B1_DESC, G1_UM,CB0_CODETI,CB0_QTDE
FROM SG1010 
JOIN SB1010 A ON
	A.B1_COD = G1_COMP
 JOIN SB1010 B ON
	B.B1_COD = G1_COD
 JOIN CB0010 C ON
	C.CB0_CODPRO = G1_COMP
	 AND C.CB0_XKIT   = '1'
	 AND C.CB0_XCARRI <> 'S' AND C.CB0_FILIAL = '08'

WHERE
	G1_FILIAL = '08' AND
	G1_COD IN ('071356')  
	AND SUBSTRING(G1_COMP,1,3) <> 'MOD'
	AND G1_FIM > '20170101' 
	AND SG1010.D_E_L_E_T_ = ''
ORDER BY G1_COD, G1_COMP
*/