//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Programa..: UZINVMID
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Data......: 20 de Janeiro de 2010, 18:00
//|Uso.......: SIGAEEC 
//|Versao....: Protheus 10    
//|Descricao.: Tratamento de Proforma Invoices
//|Observação:
//+-----------------------------------------------------------------------------------//

//+-----------------------------------------------------------------------------------//
//|Definições de Includes
//+-----------------------------------------------------------------------------------//
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//+-----------------------------------------------------------------------------------//
//|Definições de tela 
//+-----------------------------------------------------------------------------------//
#DEFINE TOP_TELA     oMainWnd:nTop+125   // Parte Superior
#DEFINE C_INI_TELA   oMainWnd:nLeft+5    // Coluna Inicial
#DEFINE BUT_TELA     oMainWnd:nBottom-Iif(SetMdiChild(),-30,60) // Parte Inferior
#DEFINE C_FIM_TELA   oMainWnd:nRight-10  // Coluna Final
#DEFINE MEIO_TELA    INT(((oMainWnd:nBottom-60)-(oMainWnd:nTop+125))/4)-10 // Meio da tela

//+-----------------------------------------------------------------------------------//
//|Definições de aRotina
//+-----------------------------------------------------------------------------------//
#DEFINE VISUAL    2
#DEFINE INCLUSAO  3
#DEFINE ALTERACAO 4
#DEFINE EXCLUSAO  5

//+-----------------------------------------------------------------------------------//
//|Função....: UZINVBROW()
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Descricao.: Chamada do Browser
//|Observação:
//+-----------------------------------------------------------------------------------//
*------------------------------------------------* 
User Function UZINVBROW()
*------------------------------------------------* 

Private aCores     := {}
Private cCadastro  := "Cadastro de Invoices"
Private cINVLeg    := "Status das Invoices"

aRotina := INVMenu()

dbSelectArea("ZZE")
ZZE->(dbSetOrder(1))

aCores := {{ '!Empty(ZZE->ZZE_SCHEDU)','DISABLE' },; //Usada
	       { 'Empty(ZZE->ZZE_SCHEDU)','ENABLE' }}	 //Não Usada

mBrowse(6,1,22,75,"ZZE",,,,,,aCores)

Return .T.

//+-----------------------------------------------------------------------------------//
//|Função....: INVMenu()
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Descricao.: Monta aRotina
//|Observação:
//+-----------------------------------------------------------------------------------//
*------------------------------------------------* 
Static Function INVMenu()
*------------------------------------------------* 

Local aRet := {{ "Pesquisar"    ,"AxPesqui"            , 0, 1},;
               { "Visualizar"   ,"U_UZINVMANUT"        , 0, 2},;
               { "Incluir"      ,"U_UZINVMANUT"        , 0, 3},;
               { "Alterar"      ,"U_UZINVMANUT"        , 0, 4},;
               { "Excluir"      ,"U_UZINVMANUT"        , 0, 5},;
               { "Legenda"      ,"U_UZINVLEG"          , 0, 3}}

Return(aRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: U_UZINVLEG()
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Descricao.: Função para chamada da Legenda
//|Observação: 
//+-----------------------------------------------------------------------------------//
*------------------------------------------------* 
User Function UZINVLEG()
*------------------------------------------------* 

BrwLegenda(cINVLeg,,{{"ENABLE"     ,"Sem Shipping Schedule"},;
	                 {"DISABLE"    ,"Com Shipping Schedule"}})
	                          
Return .T.                                 

//+-----------------------------------------------------------------------------------//
//|Funcao....: U_UZINVMANUT()
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Descricao.: Função principal de chamada de tela de Faturas
//|Observação: 
//+-----------------------------------------------------------------------------------//
*------------------------------------------------* 
User Function UZINVMANUT(cAlias,nRec,nOpc,lVFat)
*------------------------------------------------* 

Local i

Private bOk      := {|| nOpcao := 1 , Processa({ || lGravar := INVGRAVA(nOpc) }) , If(lGravar,oDlg:End(),.T.) }
Private bCancel  := {|| nOpcao := 0 , Iif(MsgYesNo("Deseja realmente sair da Invoice?","Sair"),oDlg:End(),.F.) }
Private nTipTela := GD_INSERT + GD_UPDATE + GD_DELETE 
Private aTela[0][0],aGets[0]
Private oGet := oTela := oDlg := Nil
Private oOk      := LoadBitmap( GetResources(), "LBOK" )
Private oNo      := LoadBitmap( GetResources(), "LBNO" )
Private lInverte := .F.
Private lGravar  := .T.
Private cMarca   := GetMark()
Private aButtons := {} 
Private aHeader	 := {}
Private aCols	 := {}
Private aButtons := {}
Private aPedido  := {}
Private nUsado	 := 0
Private oLbx1    := Nil
Private oLbxIts  := {} 
Private aDescIts := {}
Private aIts     := {}
Private bLineIts := ""
Private cPedido  := Space(20)

lVFat := Iif(ValType(lVFat) == "A",.F.,lVFat)

cAlias  :="ZZE"
cAlias2 :="ZZF"

If !Empty(ZZE->ZZE_SCHEDU) .AND. nOpc == EXCLUSAO
	MsgStop("Invoice não pode ser excluida pois possue Shipping Schedule","Não Exclue")
	Return
EndIf

RegToMemory(cAlias,.T.)
If nOpc <> INCLUSAO
	For i := 1 TO ZZE->(FCount())
		M->&(ZZE->(FieldName(i))) := ZZE->(FieldGet(i))
	Next
	If nOpc == VISUAL
		bOk     := {|| oDlg:End() }
		bCancel := {|| oDlg:End() }
	EndIf
EndIf

MontaHead()
MontaCols(nOpc)

If nOpc == INCLUSAO .OR. nOpc == ALTERACAO
	aAdd(aButtons,{"AVGARMAZEM" ,{ || INVSelPed() }, "Seleciona Pedidos"})
EndIf

DEFINE MSDIALOG oDlg TITLE "Invoices" From TOP_TELA,C_INI_TELA to 600,600 of oMainWnd PIXEL STYLE DS_MODALFRAME 

aPos2 := PosDlgDown(oDlg)

oTela := MsMget():New(cAlias,nRec,nOpc,,,,,PosDlgUp(oDlg),,3,,,,,,,,,.F.)
oTela:Refresh()
If !lVFat
	oGet := MsNewGetDados():New(aPos2[1],aPos2[2],aPos2[3],aPos2[4],Iif(!Inclui.And.!Altera,0,nTipTela),,,'+ZZF_NUMERO',,0,1000,,,,oDlg,aHeader,aCols )
Else
	oGet := MsNewGetDados():New(aPos2[1],aPos2[2],aPos2[3],aPos2[4],0,,,'+ZZF_NUMERO',,0,1000,,,,oDlg,aHeader,aCols )
EndIf

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel,,aButtons) Centered

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: INVMontH()
//|Descricao.: Monta aHeader
//|Observação: 
//+-----------------------------------------------------------------------------------//
*------------------------------------------------* 
Static Function MontaHead()
*------------------------------------------------* 

aHeader := {}
nUsado 	:= 0

dbSelectArea("SX3")
SX3->(dbSetOrder(1))
If SX3->(dbSeek(cAlias2))
	While SX3->(!Eof()) .AND. SX3->X3_ARQUIVO == cAlias2
		If 	Upper(AllTrim(SX3->X3_CAMPO)) $ "ZZF_INVOIC"
			SX3->(dbSkip())
			Loop
		EndIf
		If X3USO(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
			Aadd(aHeader,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,,SX3->X3_CBOX,SX3->X3_RELACAO})
		EndIf
		SX3->(dbSkip())
	EndDo
EndIf 
nUsado := Len(aHeader)

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: MontaCols
//|Descricao.: Monta aCols
//|Observação: 
//+-----------------------------------------------------------------------------------//
*------------------------------------------------* 
Static Function MontaCols(nOpc)
*------------------------------------------------* 

Local nCnt, n, nI, nPos

dbSelectArea(cAlias2)
If nOpc == INCLUSAO
	aCols := Array(1,nUsado+1)
	For nI = 1 To Len(aHeader)
		If aHeader[nI,8] == "C"
			aCols[1,nI] := Space(aHeader[nI,4])
		ElseIf aHeader[nI,8] == "N"
			aCols[1,nI] := 0
		ElseIf aHeader[nI,8] == "D"
			aCols[1,nI] := CtoD(" / / ")
		ElseIf aHeader[nI,8] == "M"
			aCols[1,nI] := ""
		Else
			aCols[1,nI] := .F.
		EndIf
	Next nI
	aCols[1,nUsado+1] := .F.
Else
	&(cAlias2)->(dbSetOrder(1))
	If &(cAlias2)->(dbSeek(xFilial(cAlias2)+M->ZZE_INVOIC))
		While &(cAlias2)->(!EOF()) .AND. ZZF->(ZZF_FILIAL+ZZF_INVOIC) == xFilial('ZZE')+ZZE->ZZE_INVOIC
			aAdd(aCols,Array(nUsado+1))
			For nI := 1 to nUsado
				If Upper(AllTrim(aHeader[nI,10])) != "V" 	// Campo Real
					aCols[Len(aCols),nI] := FieldGet(FieldPos(aHeader[nI,2]))
				Else										// Campo Virtual
					cCpo := AllTrim(Upper(aHeader[nI,2]))
					aCols[Len(aCols),nI] := CriaVar(aHeader[nI,2])
				Endif
			Next nI
			aCols[Len(aCols),nUsado+1] := .F.
			If EE8->(dbSeek(xFilial("EE8")+ZZF->ZZF_PEDIDO+ZZF->ZZF_SEQUEN))
				aCols[Len(aCols),nUsado] := EE8->EE8_SLDINI-EE8->EE8_XSALDO
			EndIf
			ZZF->(dbSkip())
		EndDo
	EndIf
EndIf

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: INVSelPed
//|Descricao.: Faz a Seleção dos Pedidos
//|Observação: 
//+-----------------------------------------------------------------------------------//
*------------------------------------------------* 
Static Function INVSelPed()
*------------------------------------------------* 

Local bOk      := {||nOpcao:=1 , Processa({ || lRet := InvCarga(aPedido,aItsUse) }) ,Iif(lRet,oDlgSelec:End(),.T.) }
Local bCancel  := {||nOpcao:=0 , oDlgSelec:End() }
Local cTitulo  := "Seleção de Pedidos"
Local lRet     := .T.
Local aItsUse  := {}
Local aPedido  := {}
Local hj

Do Case
	Case Empty(Alltrim(M->ZZE_INVOIC))
		MsgInfo("Numero da Invoice deve ser preenchida antes da seleção de pedido","Não preenchido")
		Return .T.	
	Case Empty(M->ZZE_DTINV)
		MsgInfo("Data da Fatura deve ser preenchida antes da seleção de pedido","Não preenchido")
		Return .T.		
	Case Empty(Alltrim(M->ZZE_IMPORT))
		MsgInfo("Importador deve ser preenchido antes da seleção de pedido","Não preenchido")
		Return .T.		
	Case Empty(Alltrim(M->ZZE_LOJA))
		MsgInfo("Loja do Importador deve ser preenchida antes da seleção de pedido","Não preenchido")
		Return .T.
EndCase

If Len(oGet:aCols) == 1 .AND. !Empty(oGet:aCols[1,3]) .AND. !oGet:aCols[1,nUsado+1]
	For hj := 1 To Len(oGet:aCols)
		If Ascan(aPedido,oGet:aCols[hj,4]) = 0
			aAdd(aPedido,oGet:aCols[hj,4])
		EndIf
		If Ascan(aItsUse,oGet:aCols[hj,3]) = 0
			aAdd(aItsUse,oGet:aCols[hj,3])
		EndIf
	Next
EndIf

Define MsDialog oDlgSelec Title cTitulo FROM 155,170 To 415,370 STYLE nOR(DS_MODALFRAME, WS_POPUP) OF oMainWnd Pixel

	nOpcao := 0

     @ 1.5,.2 SAY AVSX3("EE7_PEDIDO",5) 
     @ 1.5,04 MSGET cPedido F3 "EE7A" SIZE 55,8 VALID VerPeds(cPedido)
     @ 2.5,04 LISTBOX oLbx1 VAR cPedido ITEMS aPedido SIZE 50,80 OF oDlgSelec UPDATE

Activate MsDialog oDlgSelec ON INIT EnchoiceBar(oDlgSelec,bOk,bCancel) Centered   
 
Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: VerPeds(cPedEEC)
//|Descricao.: Faz Validação dos pedidos informados antes de criar a consuta e 
//|            busca de dados
//|Observação: 
//+-----------------------------------------------------------------------------------//
*---------------------------------------------------------*
Static Function VerPeds(cPedEEC)
*---------------------------------------------------------*

Local lRet := .F.
Local lExi
Local lPed := .F.

lExi := Iif(!Empty(cPedEEC),existcpo("EE7",cPedEEC),.T.)
If !lExi
	Return .T.
ElseIf Empty(cPedEEC)
	Return .T.
ElseIf Ascan(aPedido,Alltrim(cPedEEC)) # 0
	MsgInfo("Pedido já informado","Pedido")
	Return .T.
ElseIf EE7->(dbSeek(xFilial("EE7")+Alltrim(cPedEEC)))
	If Alltrim(EE7->EE7_IMPORT) <> Alltrim(M->ZZE_IMPORT) .OR. Alltrim(EE7->EE7_IMLOJA) <> Alltrim(M->ZZE_LOJA)
		MsgInfo("Pedido não pertence ao cliente selecionado para a Invoice","Cliente Diferente")
		Return .T.	
	Else
		lPed := .T.
	EndIf
Else
	lPed := .T.
EndIf

If lPed
	oLbx1:ADD(cPedEEC)
	cPedido := Space(Len(EE7->EE7_PEDIDO))            
EndIf

Return   

//+-----------------------------------------------------------------------------------//
//|Funcao....: INVCarga
//|Descricao.: Realiza carga dos pedidos selecionados
//|Observação: 
//+-----------------------------------------------------------------------------------//
*---------------------------------------------------------*
Static Function INVCarga(xaPed,xaIts)
*---------------------------------------------------------*

Local cPed := ""
Local cIts := ""
Local cSql := ""
Local lRet := .F.
Local lZero:= .F.
Local nCont:= 1
Local nS, nH, nW

If Len(xaPed) = 0
	MsgInfo("Não há pedidos selecionados","Sem Pedido")
	Return(lRet)
EndIf

For nS := 1 TO Len(xaPed)
	cPed += "'"+Alltrim(xaPed[nS])+"'"+Iif(nS == Len(xaPed),"",",")
Next

If Len(xaIts) > 0
	For nH := 1 TO Len(xaIts)
		cIts += "'"+Alltrim(xaIts[nH])+"'"+Iif(nH == Len(xaIts),"",",")
	Next  
EndIf

cSql := " SELECT * FROM "+RetSqlName("EE8")
cSql += " WHERE D_E_L_E_T_ <> '*' AND EE8_FILIAL = '"+xFilial("EE8")+"' AND EE8_XITROM = 'N' "
cSql += " AND EE8_PEDIDO IN ("+cPed+") AND "+Iif(!Empty(cIts),"EE8_SEQUEN NOT IN ("+cIts+")","")+" EE8_XSALDO <> EE8_SLDINI"
cSql += " ORDER BY EE8_PEDIDO, EE8_SEQUEN "

Iif(Select("QRY") # 0,QRY->(dbCloseArea()),.T.)

TcQuery cSql New Alias "QRY"
QRY->(dbSelectArea("QRY"))
QRY->(dbGoTop())

If QRY->(EOF()) .AND. QRY->(BOF())
	MsgInfo("Não há itens ou saldo de itens para inclusão","Sem Itens")
	QRY->(dbCloseArea())
	Return(lRet)
Else
	lRet := .T.
EndIf

lZero := Iif(Len(oGet:aCols) == 1 .AND. Empty(oGet:aCols[1,3]) .AND. !oGet:aCols[1,nUsado+1],.T.,.F.)
nCont := Iif(lZero,1,Len(oGet:aCols))

While QRY->(!EOF())
	
	If !lZero
		aAdd(oGet:aCols,Array(nUsado+1))
		For nW := 1 To nUsado
			oGet:aCols[Len(oGet:aCols),nW] := CriaVar(aHeader[nW,2],.T.)
		Next nW
	EndIf
	
	oGet:aCols[nCont,UZSCAN(aHeader,"ZZF_ITEM",2)]   := StrZero(nCont,4)
	oGet:aCols[nCont,UZSCAN(aHeader,"ZZF_PEDIDO",2)] := QRY->EE8_PEDIDO
	oGet:aCols[nCont,UZSCAN(aHeader,"ZZF_SEQUEN",2)] := QRY->EE8_SEQUEN
	oGet:aCols[nCont,UZSCAN(aHeader,"ZZF_COD_I",2)]  := QRY->EE8_COD_I
	oGet:aCols[nCont,UZSCAN(aHeader,"ZZF_DESCR",2)]  := Alltrim(MsMM(QRY->EE8_DESC))
	oGet:aCols[nCont,UZSCAN(aHeader,"ZZF_QUANT",2)]  := QRY->EE8_SLDINI-QRY->EE8_XSALDO
	oGet:aCols[nCont,UZSCAN(aHeader,"ZZF_PRECO",2)]  := QRY->EE8_PRECO
	oGet:aCols[nCont,UZSCAN(aHeader,"ZZF_PRECOT",2)] := QRY->EE8_PRECO*(QRY->EE8_SLDINI-QRY->EE8_XSALDO)
	oGet:aCols[nCont,UZSCAN(aHeader,"ZZF_XSALDO",2)] := QRY->EE8_SLDINI-QRY->EE8_XSALDO
	oGet:aCols[nCont,nUsado+1] := .F.
	nCont++
	lZero := .F.
	QRY->(dbSkip())
EndDo

QRY->(dbCloseArea())
oGet:Refresh()

Return(lRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: UZSCAN()
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Descricao.: aScan para todos os Arrays Utilizados
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function UZSCAN(aArr,cCamp,nPosi)
*-----------------------------------------------------------*

Local nPos := 0

nPos := Ascan(aArr,{|x|x[nPosi] = cCamp } )

Return nPos

//+-----------------------------------------------------------------------------------//
//|Funcao....: INVValQTD
//|Descricao.: Valida quantidade informada
//|Observação: 
//+-----------------------------------------------------------------------------------//
*---------------------------------------------------------*
User Function INVValQTD()
*---------------------------------------------------------*

Local nTot   := 0
Local lRet   := .T.
Local nSaldo := oGet:aCols[n,UZSCAN(aHeader,"ZZF_XSALDO",2)]
Local nIte   := oGet:aCols[n,UZSCAN(aHeader,"ZZF_ITEM",2)]

If !INCLUI
	ZZF->(dbSetOrder(1))
	If ZZF->(dbSeek(xFilial("ZZF")+M->ZZE_INVOIC+nIte))
		nTot := Iif( (M->ZZF_QUANT-ZZF->ZZF_QUANT) > 0,(M->ZZF_QUANT-ZZF->ZZF_QUANT),0)
	EndIf
Else
	nTot := M->ZZF_QUANT
EndIf

If nTot > nSaldo
	MsgInfo("Quantidade informada maior que saldo Disponvel: "+Alltrim(Transform(nSaldo,"@E99,999,999,999.9999")),"Sem Saldo")
	lRet := .F.
EndIf

Return(lRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: InvGrava
//|Descricao.: Faz a Gravação dos dados
//|Observação: 
//+-----------------------------------------------------------------------------------//
*---------------------------------------------------------*
Static Function INVGRAVA(nOpc)
*---------------------------------------------------------*

Local lRet := .F.
Local nIts := Iif(aScan(oGet:aCols,{ |x| x[nUsado+1] == .F. .AND. !Empty(x[UZSCAN(aHeader,"ZZF_PEDIDO",2)])}) <> 0 ,.T.,.F.)
Local cMsg := "Confirma "+Iif(nOpc == INCLUSAO,"Inclusão",Iif(nOpc == ALTERACAO,"Alteração","Exclusçao"))+" da Invoice?"

If !nIts
	MsgInfo("Não há itens selecionados","Sem Itens")
	Return(lRet)
EndIf

If Obrigatorio(aGets,aTela)
	lRet := MsgYesNo(cMsg,"Invoice")
	If lRet
		Processa({ || GrvInv(nOpc) })	
	EndIf

EndIf

Return(lRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: GrvInv
//|Descricao.: Faz a Gravação dos dados
//|Observação: 
//+-----------------------------------------------------------------------------------//
*---------------------------------------------------------*
Static Function GrvInv(nOpc)
*---------------------------------------------------------*

Local lGrava := Iif(nOpc == INCLUSAO,.T.,.F.)
Local lDel   := .F.
Local nf

Begin Transaction
	
	ZZF->(dbSetOrder(1))
	If nOpc == EXCLUSAO
		If ZZF->(dbSeek(xFilial("ZZF")+M->ZZE_INVOIC))
			While ZZF->(!EOF()) .AND. ZZF->(ZZF_FILIAL+ZZF_INVOIC) == (xFilial("ZZF")+M->ZZE_INVOIC)
				INVSaldo(ZZF->ZZF_PEDIDO,ZZF->ZZF_SEQUEN,ZZF->ZZF_QUANT,nOpc)
				ZZF->(RecLock("ZZF",.F.))
				ZZF->(dbDelete())
				ZZF->(MsUnLock())
				ZZF->(dbSkip())
			EndDo
		EndIf
		ZZE->(RecLock("ZZE",.F.))
		ZZE->(dbDelete())
		ZZE->(MsUnLock())
	Else
		
		E_GRAVA("ZZE",lGrava)
		
		For nf := 1 TO Len(oGet:aCols)
			If !Empty(oGet:aCols[nf,UZSCAN(aHeader,"ZZF_ITEM",2)])
				If ZZF->(dbSeek(xFilial("ZZF")+M->ZZE_INVOIC+oGet:aCols[nf,UZSCAN(aHeader,"ZZF_ITEM",2)]))
					ZZF->(RecLock("ZZF",.F.))
					If oGet:aCols[nf,nUsado+1]
						lDel := .T.
					EndIf
					INVSaldo(ZZF->ZZF_PEDIDO,ZZF->ZZF_SEQUEN,ZZF->ZZF_QUANT,nOpc)
				ElseIf !oGet:aCols[nf,nUsado+1]
					ZZF->(RecLock("ZZF",.T.))
				ElseIf oGet:aCols[nf,nUsado+1]
					lDel := .T.				
				EndIf
				
				If !lDel
					INVSaldo(oGet:aCols[nf,UZSCAN(aHeader,"ZZF_PEDIDO",2)],oGet:aCols[nf,UZSCAN(aHeader,"ZZF_SEQUEN",2)],;
					oGet:aCols[nf,UZSCAN(aHeader,"ZZF_QUANT",2)],nOpc)
					ZZF->ZZF_FILIAL := xFilial("ZZF")
					ZZF->ZZF_INVOIC := M->ZZE_INVOIC
					ZZF->ZZF_ITEM   := oGet:aCols[nf,UZSCAN(aHeader,"ZZF_ITEM",2)]
					ZZF->ZZF_PEDIDO := oGet:aCols[nf,UZSCAN(aHeader,"ZZF_PEDIDO",2)]
					ZZF->ZZF_SEQUEN := oGet:aCols[nf,UZSCAN(aHeader,"ZZF_SEQUEN",2)]
					ZZF->ZZF_COD_I  := oGet:aCols[nf,UZSCAN(aHeader,"ZZF_COD_I",2)]
					ZZF->ZZF_DESCR  := oGet:aCols[nf,UZSCAN(aHeader,"ZZF_DESCR",2)]
					ZZF->ZZF_QUANT  := oGet:aCols[nf,UZSCAN(aHeader,"ZZF_QUANT",2)]
					ZZF->ZZF_PRECO  := oGet:aCols[nf,UZSCAN(aHeader,"ZZF_PRECO",2)]
					ZZF->ZZF_PRECOT := oGet:aCols[nf,UZSCAN(aHeader,"ZZF_PRECOT",2)]
					ZZF->ZZF_NRPLAN := oGet:aCols[nf,UZSCAN(aHeader,"ZZF_NRPLAN",2)]
					ZZF->ZZF_DTREAD := oGet:aCols[nf,UZSCAN(aHeader,"ZZF_DTREAD",2)]
					ZZF->ZZF_ETDREQ := oGet:aCols[nf,UZSCAN(aHeader,"ZZF_ETDREQ",2)]
				ElseIf !lGrava
					ZZF->(dbDelete())
				EndIf
				ZZE->(MsUnLock())
				lDel := .F.
			EndIf
		Next
	EndIf
	
End Transaction


Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: GrvInv
//|Descricao.: Faz a Gravação dos dados
//|Observação: 
//+-----------------------------------------------------------------------------------//
*---------------------------------------------------------*
Static Function INVSaldo(xPed,xSeq,xQtd,xOpc)
*---------------------------------------------------------*

Local nTot := 0

EE8->(dbSetOrder(1))
If EE8->(dbSeek(xFilial("EE8")+xPed+xSeq))
	nTot := Iif(xOpc == ALTERACAO,(xQtd-ZZF->ZZF_QUANT),Iif(xOpc == INCLUSAO,xQtd,-xQtd))
	EE8->(RecLock("EE8",.F.))
	EE8->EE8_XSALDO := EE8->EE8_XSALDO+nTot
	EE8->(MsUnLock())
EndIf

Return