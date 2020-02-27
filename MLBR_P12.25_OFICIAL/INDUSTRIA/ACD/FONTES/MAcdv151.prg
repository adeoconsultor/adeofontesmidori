#INCLUDE "Acdv151.ch" 
#include "protheus.ch"
#INCLUDE 'APVT100.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � acdv151    � Autor � Sandro              � Data � 14/08/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de transferencia (sem Controle de Localizacao) 	  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SigaACD                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri��o � PLANO DE MELHORIA CONTINUA                                 ���
�������������������������������������������������������������������������Ĵ��
���ITEM PMC  � Responsavel              � Data         |BOPS:             ���
�������������������������������������������������������������������������Ĵ��
���      01  �                          �              |                  ���
���      02  �Flavio Luiz Vicco         �18/05/2006    |00000098412       ���
���      03  �                          �              |                  ���
���      04  �                          �              |                  ���
���      05  �Flavio Luiz Vicco         �11/07/2006    |00000100246       ���
���      06  �                          �              |                  ���
���      07  �                          �              |                  ���
���      08  �                          �              |                  ���
���      09  �Flavio Luiz Vicco         �11/07/2006    |00000100246       ���
���      10  �Flavio Luiz Vicco         �18/05/2006    |00000098412       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/   
//Template user function macdv151(uPar1,uPar2,uPar3,uPar4,uPar5,uPar6,uPar7,uPar8,uPar9,uPar10)
//Return U_Macdv151(uPar1,uPar2,uPar3,uPar4,uPar5,uPar6,uPar7,uPar8,uPar9,uPar10)

User Function Macdv151()
Local aKey        := array(3)

Private cArmOri   := Space(Tamsx3("B1_LOCPAD") [1])
Private cArmDes   := Space(Tamsx3("B1_LOCPAD") [1])
Private cCB0Prod  := Space(TamSx3("CB0_CODET2")[1])
Private cProduto  := Space(48)

Private nQtde     := 1
Private nQtdeProd := 1
Private cLote     := Space(10)
Private cSLote    := Space(6)
Private cNumSerie := Space(TamSX3("BF_NUMSERI")[1])
Private aLista    := {}
Private aHisEti   := {}
Private lMsErroAuto := .F.
Private nLin:= 0


//CBChkTemplate()

akey[2] := VTSetKey(24,{|| Estorna()},"Estorna") //"Estorna"
akey[3] := VTSetKey(09,{|| Informa()},"Informacoes") //"Informacoes"

While .t.
	VTClear
	nLin:= -1
	@ ++nLin,0 VTSAY "Transferencia"
	If ! GetArmOri()
		Exit
	EndIf
	GetProduto()
	GetArmDes()
	VTRead
	If vtLastKey() == 27
		If len(aLista) > 0 .and. ! VTYesNo('Confirma a saida?','Atencao') //'Confirma a saida?'###'Atencao'
			loop
		EndIf
		Exit
	EndIf
End
vtsetkey(24,akey[1])
vtsetkey(09,akey[2])
Return

//�����������������������������������������������������������������������������
Static Function GetArmOri()
If ! UsaCB0('01')
	@ ++nLin,0 VtSay 'Armazem origem'
	@ ++nLin,0 VTGet cArmOri pict '@!' Valid VldArmOri()
	VTRead()
	If VTLastkey() == 27
		Return .f.
	EndIf
	VTClear(1,0,2,19)
	nLin := 0
EndIf
Return .t.

//�����������������������������������������������������������������������������
Static Function VldArmOri()
If Empty(cArmOri)
	VtAlert('Armazem invalido', 'Aviso',.t.,4000,4) //'Armazem invalido'###'Aviso'
	VTKeyboard(chr(20))
	Return .f.
EndIf
If Trim(cArmOri) == SuperGetMV("MV_CQ")
	VtAlert("Esta rotina nao trata armazem de CQ!", 'Aviso',.t.,4000,4) //"Esta rotina nao trata armazem de CQ!"###'Aviso'
	VtAlert("Utilize as rotinas de Envio/Baixa CQ!", 'Aviso',.t.,4000,4) //"Utilize as rotinas de Envio/Baixa CQ!"###'Aviso'
	VTKeyboard(chr(20))
	Return .f.
EndIf
Return .t.

//�����������������������������������������������������������������������������
Static Function GetProduto()
If UsaCB0('01')
	@ ++nLin,0 VTSAY "Produto"
	@ ++nLin,0 VTGET cCB0Prod PICTURE "@!" valid VldProduto("01")
ElseIf ! UsaCB0('01')
	@ ++nLin,0 VTSAY "Quantidade"
	@ ++nLin,0 VTGET nQtde PICTURE CBPictQtde() valid nQtde > 0 when VTLastKey() == 5
	@ ++nLin,0 VTSAY "Produto"
	@ ++nLin,0 VTGET cProduto    PICTURE "@!" valid VldProduto("")
EndIf
Return

//�����������������������������������������������������������������������������
Static Function VldProduto(cTipo)
Local cTipId      := ""
Local aEtiqueta   := {}
Local nQE         := 0
Local nQtdeLida   := 0
Local nSaldo      := 0
Local aListaBKP   := {}
Local aHisEtiBKP  := {}
Local aItensPallet:= {}
Local lIsPallet   := .t.
Local nP          := 0

If "01" $ cTipo
	If Empty(cCB0Prod)
		Return .t.
	EndIf

	aItensPallet := CBItPallet(cCB0Prod)
	lIsPallet := .t.
	If len(aItensPallet) == 0
		aItensPallet:={cCB0Prod}
		lIsPallet := .f.
	EndIf
	cTipId:=CBRetTipo(cCB0Prod)
	If cTipId == "01" .and. cTipId $ cTipo .or. lIsPallet
		aListaBKP := aClone(aLista)
		aHisEtiBKP:= aClone(aHisEti)

		Begin Sequence
			For nP:= 1 to len(aItensPallet)
				cCB0Prod :=  padr(aItensPallet[nP],20)
				aEtiqueta:= CBRetEti(cCB0Prod,"01")
				If Empty(aEtiqueta)
					VTALERT("Etiqueta invalida","Aviso" ,.T.,4000,3) //"Etiqueta invalida"###"Aviso"
					Return .f.
//					Break
				EndIf
				If ! lIsPallet .and. ! Empty(CB0->CB0_PALLET)
					VTALERT("Etiqueta invalida, Produto pertence a um Pallet","Aviso",.T.,4000,2) //"Etiqueta invalida, Produto pertence a um Pallet"###"Aviso"
					Return .f.
//					Break
				EndIf
				//--Valida se a etiqueta j� foi consumida por outro processo
				If CB0->CB0_STATUS $ "123"  
					VTBeep(2)
					VTAlert("Etiqueta invalida","Aviso",.T.,4000,3) //"Etiqueta invalida"###"Aviso"
					VTKeyBoard(chr(20))
					Return .f.
				EndIf				
				If ! Empty(aEtiqueta[2]) .and. Ascan(aHisEti,cCB0Prod) > 0
					VTALERT("Etiqueta ja lida","Aviso" ,.T.,4000,3) //"Etiqueta ja lida"###"Aviso"
					Return .f.
//					Break
				EndIf
				If aEtiqueta[10] == SuperGetMV("MV_CQ")
					VtAlert("Esta rotina nao trata armazem de CQ!", 'Aviso',.t.,4000,4) //"Esta rotina nao trata armazem de CQ!"###'Aviso'
					VtAlert("Utilize as rotinas de Envio/Baixa CQ!", 'Aviso',.t.,4000,4) //"Utilize as rotinas de Envio/Baixa CQ!"###'Aviso'
					Return .f.
//					Break
				EndIf
				If Localiza(aEtiqueta[1])
					VTALERT("Produto lido controla endereco!","Aviso",.T.,4000,3) //"Produto lido controla endereco!"###"Aviso"
					VTALERT("Utilize rotina especifica ACDV150","Aviso",.T.,4000) //"Utilize rotina especifica ACDV150"###"Aviso"
					Return .f.
//					Break
				EndIf
				If !Empty(aEtiqueta[13])
					VTALERT("Etiqueta utilizada em NF saida.","Aviso",.T.,4000,3) //"Etiqueta utilizada em NF saida."###"Aviso"
					Return .f.
//					Break
				EndIf
				If Empty(aEtiqueta[2])
					aEtiqueta[2]:= 1
				EndIf
				cArmOri := aEtiqueta[10]
				cLote   := aEtiqueta[16]
				cSLote  := aEtiqueta[17]
				cNumSerie:=CB0->CB0_NUMSER
				If ! CBProdLib(cArmOri,aEtiqueta[1])
					Return .f.
//					Break
				EndIf
				cProduto  := aEtiqueta[1]
				nQE:= 1
				If ! CBProdUnit(aEtiqueta[1])
					nQE := CBQtdEmb(aEtiqueta[1])
					If empty(nQE)
						Return .f.
						Break
					EndIf
				EndIf
				nQtdeProd := aEtiqueta[2]*nQE
				//��������������������������������������������������������Ŀ
				//� Consiste Quantidade Negativa                           �
				//����������������������������������������������������������
				If SuperGetMV('MV_ESTNEG')=='N'
					nQtdeLida := 0
					aEval(aLista,{|x|  If(x[1]+x[3]+x[4]+x[5]+x[6]==cProduto+cArmOri+cLote+cSLote+cNumSerie,nQtdeLida+=x[2],nil)})
					//--> Verifica se o saldo do armz esta liberado
					SB2->(DbSetOrder(1))
					SB2->(DbSeek(xFilial("SB2")+cProduto+cArmOri))
					nSaldo := SaldoMov()
					If nQtdeProd+nQtdeLida >  nSaldo
						VTALERT("Quantidade excede o saldo disponivel","Aviso" ,.T.,4000,3) //"Quantidade excede o saldo disponivel"###"Aviso"
						Return .f.
//						Break
					EndIf
				EndIf
				If ExistBlock("AV151VPR")
					If ! ExecBlock("AV151VPR",.F.,.F.,cCB0Prod)
						Break
					EndIf
				EndIf
				TrataArray(cCB0Prod)
			Next
			VTKeyboard(chr(20))
			Return .f.
		End Sequence
		aLista := aClone(aListaBKP)
		aHisEti:= aClone(aHisEtiBKP)
		VTKeyboard(chr(20))
		Return .f.
	Else
		VTALERT("Etiqueta invalida","Aviso" ,.T.,4000,3) //"Etiqueta invalida"###"Aviso"
		VTKeyboard(chr(20))
		Return .f.
	EndIf
Else
	If Empty(cProduto)
		Return .t.
	EndIf
	If ! CBLoad128(@cProduto)
		VTKeyboard(chr(20))
		Return .f.
	EndIf
	cTipId:=CBRetTipo(cProduto)
	If ! cTipId $ "EAN8OU13-EAN14-EAN128"
		VTALERT("Etiqueta invalida.","Aviso",.T.,4000,3) //"Etiqueta invalida."###"Aviso"
		VTKeyboard(chr(20))
		Return .f.
	EndIf
	aEtiqueta := CBRetEtiEAN(cProduto)
	If Empty(aEtiqueta) .or. Empty(aEtiqueta[2])
		VTALERT("Etiqueta invalida.","Aviso",.T.,4000,3) //"Etiqueta invalida."###"Aviso"
		VTKeyboard(chr(20))
		Return .f.
	EndIf
	If ! CBProdLib(cArmOri,aEtiqueta[1])
		VTKeyBoard(chr(20))
		Return .f.
	EndIf
	nQE:= 1
	If ! CBProdUnit(aEtiqueta[1])
		nQE := CBQtdEmb(aEtiqueta[1])
		If empty(nQE)
			VTKeyboard(chr(20))
			Return .f.
		EndIf
	EndIf
	cLote := aEtiqueta[3]
	If ! CBRastro(aEtiqueta[1],@cLote,@cSLote)
		VTKeyboard(chr(20))
		Return .f.
	EndIf
	If Localiza(aEtiqueta[1])
		VTALERT("Produto lido controla endereco!","Aviso",.T.,4000,3) //"Produto lido controla endereco!"###"Aviso"
		VTALERT('Utilize rotina especifica ACDV150',"Aviso",.T.,4000) //"Utilize rotina especifica ACDV150"###"Aviso"
		VTKeyboard(chr(20))
		cLote  := Space(10)
		cSLote := Space(6)
		cNumSerie:= Space(TamSX3("BF_NUMSERI")[1])
		Return .f.
	EndIf
	cProduto  := aEtiqueta[1]
	nQtdeProd := aEtiqueta[2]*nQtde*nQE
	If Len(aEtiqueta) >= 5
		cNumSerie:=Padr(aEtiqueta[5],Len(Space(TamSX3("BF_NUMSERI")[1])))
	EndIf
	If SuperGetMV('MV_ESTNEG')=='N'
		nQtdeLida := 0
		aEval(aLista,{|x|  If(x[1]+x[3]+x[4]+x[5]+x[6]==cProduto+cArmOri+cLote+cSLote+cNumSerie,nQtdeLida+=x[2],nil)})
		SB2->(DbSetOrder(1))
		SB2->(DbSeek(xFilial("SB2")+cProduto+cArmOri))
		nSaldo := SaldoMov()
		If nQtdeProd+nQtdeLida > nSaldo
			VTALERT("Quantidade excede o saldo disponivel","Aviso" ,.T.,4000,3) //"Quantidade excede o saldo disponivel"###"Aviso"
			cLote  := Space(10)
			cSLote := Space(6)
			cNumSerie:= Space(TamSX3("BF_NUMSERI")[1])
			VTKeyboard(chr(20))
			Return .f.
		EndIf
	EndIf
	If ExistBlock("AV151VPR")
		If ! ExecBlock("AV151VPR",.F.,.F.,cCB0Prod)
			VTKeyboard(chr(20))
			Return .f.
		EndIf
	EndIf
	TrataArray(Nil)
	nQtde := 1
	VTGetRefresh('nQtde')
	VTKeyboard(chr(20))
	cLote  := Space(10)
	cSLote := Space(6)
	cNumSerie:=Space(TamSX3("BF_NUMSERI")[1])
	Return .f.
EndIf
Return .f.

//�����������������������������������������������������������������������������
Static Function GetArmDes()

@ ++nLin,0 VtSay 'Armazem destino'
@ ++nLin,0 VTGet cArmDes pict '@!' Valid VTLastkey() == 5 .or. (! Empty(cArmDes) .and. VldEndDes()) When !Empty(aLista)

Return

//�����������������������������������������������������������������������������
Static Function VldEndDes()

Local nI
Local _cTexto 	:= 'Movimenta��o N�O Permitida No(s) Armazem(s) -> '+ GetMv('MA_ARMAZEM')

If Empty(cArmDes)
	VtAlert('Armazem invalido', 'Aviso',.t.,4000,4) //'Armazem invalido'###'Aviso'
	VTKeyboard(chr(20))
	VTClearGet("cArmDes")
	VTGetSetFocus("cArmDes")
	Return .f.
EndIf
If Trim(cArmDes) == SuperGetMV("MV_CQ")
	VtAlert("Esta rotina nao trata armazem de CQ!", 'Aviso',.t.,4000,4) //"Esta rotina nao trata armazem de CQ!"###'Aviso'
	VtAlert("Utilize as rotinas de Envio/Baixa CQ!", 'Aviso',.t.,4000,4) //"Utilize as rotinas de Envio/Baixa CQ!"###'Aviso'
	VTKeyboard(chr(20))
	Return .f.
EndIf
For nI := 1 to Len(aLista)
	If ! CBProdLib(cArmDes,aLista[nI,1],.f.)
		VTALERT('Produto '+aLista[nI,1]+' bloqueado para inventario no armazem '+cArmDes,'Aviso',.t.,4000,2) //'Produto '###' bloqueado para inventario no armazem '###'Aviso'
		VTKeyboard(chr(20))
		If ! UsaCb0("02")
			VTClearGet("cArmDes")
			VTGetSetFocus("cArmDes")
		EndIf
		Return .f.
	EndIf
	SB2->(DbSetOrder(1))
	If !SB2->(MsSeek(xFilial('SB2')+aLista[nI,1]+cArmDes,.F.)) .And. SuperGetMV('MV_VLDALMO',.F.,'S') == 'S'
		VtAlert(STR0045+AllTrim(aLista[nI,1])+".")
		VTClearGet("cArmDes")
		VTGetSetFocus("cArmDes")
		Return .F.
	EndIf
Next
If Ascan(aLista,{|x| x[3] ==cArmDes}) > 0
	VTALERT("Armazem de origem igual ao destino","Aviso" ,.T.,4000,3) //"Armazem de origem igual ao destino"###"Aviso"
	VTKeyboard(chr(20))
	If ! UsaCb0("02")
		VTClearGet("cArmDes")
		VTGetSetFocus("cArmDes")
	EndIf
	Return .f.
EndIf

/*If Empty(cArmDes)
	VtAlert('Armazem invalido', 'Aviso',.t.,4000,4) //'Armazem invalido'###'Aviso'
	VTKeyboard(chr(20))
	Return .f.
EndIf
*/
If Trim(cArmDes) == SuperGetMV("MV_CQ")
	VtAlert("Esta rotina nao trata armazem de CQ!", 'Aviso',.t.,4000,4) //"Esta rotina nao trata armazem de CQ!"###'Aviso'
	VtAlert("Utilize as rotinas de Envio/Baixa CQ!", 'Aviso',.t.,4000,4) //"Utilize as rotinas de Envio/Baixa CQ!"###'Aviso'
	VTKeyboard(chr(20))
	Return .f.
EndIf

If cArmDes $ GetMv('MA_ARMAZEM')                           //NAO FOI USADA A ROTINA MA_ARMAZEM() PQ ESTE FONTE � CUSTOMIZADO E SER� SUBSTITUIDO
//	Help(" ",1,"HELP","MA_ARMAZEM",_cTexto,1,0)            //NO FUTURO QUANDO O DO PADR�O ESTIVER CORRIGIDO (ERRO NO FONTE PADR�O)
	VtAlert(_cTexto, 'Aviso',.t.,,4)                        //O HELP DEVE SER SUBSTITUIDO PELO VTALERT() POIS SOMENTE ESTE FUNCIONA COMO MSG NO COLETOR RF
	VTClearGet("cArmDes")
	VTGetSetFocus("cArmDes")
	Return .f.
EndIf

/*IF !Existchav("NNR",cArmDes,1)
	VtAlert("Armazem, n�o cadastrado no sistema!", 'Aviso',.t.,4000,4)
	VTClearGet("cArmDes")
	VTGetSetFocus("cArmDes")
	Return .f.
EndIf
*/

If ! GravaTransf()
	Return .f.
EndIf
Return .t.


//�����������������������������������������������������������������������������
Static Function TrataArray(cEtiqueta,lEstorno)
Local nPos
Default lEstorno := .f.
If ! lEstorno
	If cEtiqueta <> NIL
		aadd(aHisEti,cEtiqueta)
	EndIf	
	nPos := aScan(aLista,{|x| x[1]+x[3]+x[4]+x[5]+x[6] == cProduto+cArmOri+cLote+cSLote+cNumSerie})
	If Empty(nPos)
		aadd(aLista,{cProduto,nQtdeProd,cArmOri,cLote,cSLote,cNumSerie})
	Else
		aLista[nPos,2]+=nQtdeProd
	EndIf
Else
	nPos := aScan(aLista,{|x| x[1]+x[3]+x[4]+x[5]+x[6] == cProduto+cArmOri+cLote+cSLote+cNumSerie})
	aLista[nPos,2] -= nQtdeProd
	If Empty(aLista[nPos,2])
		aDel(aLista,nPos)
		aSize(aLista,len(aLista)-1)
	EndIf
	If cEtiqueta <> NIL
		nPos := aScan(aHisEti,cEtiqueta)
		aDel(aHisEti,nPos)
		aSize(aHisEti,len(aHisEti)-1)
	EndIf
EndIf
Return

//�����������������������������������������������������������������������������
Static Function GravaTransf()
Local aSave
Local nI,nX
Local aTransf:={}
Local aEtiqueta
Local cArmOri2 := ""
Local cDoc     := ""
Local dValid
Private nModulo := 4

If ! VTYesNo("Confirma transferencia?","Aviso" ,.T.) //"Confirma transferencia?"###"Aviso"
	VTKeyboard(chr(20))
	Return .f.
EndIf

aSave     := VTSAVE()
VTClear()
VTMsg('Aguarde...') //'Aguarde...'
//�����������������������������������������������������������Ŀ
//�Ponto de entrada: Informar numero do documento.            �
//�������������������������������������������������������������
If ExistBlock('ACD151DC')
	cDoc := ExecBlock('ACD151DC',.F.,.F.)
	cDoc := If(ValType(cDoc)=="C",cDoc,"")
Endif
Begin Transaction
	lMsErroAuto := .F.
	lMsHelpAuto := .T.
	aTransf:=Array(len(aLista)+1)
	aTransf[1] := {cDoc,dDataBase}
	For nI := 1 to Len(aLista)
		SB1->(dbSeek(xFilial("SB1")+aLista[nI,1]))
		dValid := dDatabase+SB1->B1_PRVALID
		If Rastro(aLista[nI,1])
			SB8->(DbSetOrder(3))
			SB8->(DbSeek(xFilial("SB8")+aLista[nI,1]+aLista[nI,3]+aLista[nI,4]+AllTrim(aLista[nI,5])))
			dValid := SB8->B8_DTVALID
		EndIf
		aTransf[nI+1]:=  {{"D3_COD" , SB1->B1_COD				,NIL}}
		aAdd(aTransf[nI+1],{"D3_DESCRI" , SB1->B1_DESC				,NIL})
		aAdd(aTransf[nI+1],{"D3_UM"     , SB1->B1_UM				,NIL})
		aAdd(aTransf[nI+1],{"D3_LOCAL"  , aLista[nI,3]				,NIL})
		aAdd(aTransf[nI+1],{"D3_LOCALIZ", Space(15)				,NIL})
		aAdd(aTransf[nI+1],{"D3_COD"    , SB1->B1_COD				,NIL})
		aAdd(aTransf[nI+1],{"D3_DESCRI" , SB1->B1_DESC				,NIL})
		aAdd(aTransf[nI+1],{"D3_UM"     , SB1->B1_UM				,NIL})
		aAdd(aTransf[nI+1],{"D3_LOCAL"  , cArmDes					,NIL})
		aAdd(aTransf[nI+1],{"D3_LOCALIZ", Space(15)				,NIL})
		aAdd(aTransf[nI+1],{"D3_NUMSERI", aLista[nI,6]				,NIL})//numserie
		aAdd(aTransf[nI+1],{"D3_LOTECTL", aLista[nI,4]				,NIL})//lote
		aAdd(aTransf[nI+1],{"D3_NUMLOTE", aLista[nI,5]				,NIL})//sublote
		aAdd(aTransf[nI+1],{"D3_DTVALID", dValid					,NIL})
		aAdd(aTransf[nI+1],{"D3_POTENCI", criavar("D3_POTENCI")	,NIL})
		aAdd(aTransf[nI+1],{"D3_QUANT"  , aLista[nI,2]				,NIL})
		aAdd(aTransf[nI+1],{"D3_QTSEGUM", criavar("D3_QTSEGUM")	,NIL})
		aAdd(aTransf[nI+1],{"D3_ESTORNO", criavar("D3_ESTORNO")	,NIL})
		aAdd(aTransf[nI+1],{"D3_NUMSEQ" , criavar("D3_NUMSEQ")		,NIL})
		aAdd(aTransf[nI+1],{"D3_LOTECTL", aLista[nI,4]				,NIL})
		aAdd(aTransf[nI+1],{"D3_DTVALID", dValid					,NIL})
		/*Ponto de entrada, permite manipular e ou acrescentar dados no array aTransf.*/
		If ExistBlock("V151AUTO")	
			aPEAux := aClone(aTransf)  
			aPEAux := ExecBlock("V151AUTO",.F.,.F.,{aTransf})
			If ValType(aPEAux)=="A" 
				aTransf := aClone(aPEAux)
			EndIf
		EndIf								
		If ! UsaCB0("01")
			CBLog("02",{SB1->B1_COD,aLista[nI,2],aLista[nI,4],aLista[nI,5],aLista[nI,3],,cArmDes})
		EndIf
	Next
	MSExecAuto({|x| MATA261(x)},aTransf)
	If lMsErroAuto
		VTALERT("Falha na gravacao da transferencia","ERRO",.T.,4000,3) //"Falha na gravacao da transferencia"###"ERRO"
		DisarmTransaction()
		Break
	EndIf
	If UsaCb0("01") .and. Len(aHiseti) > 0
		For nx:= 1 to len(aHisEti)
			aEtiqueta := CBRetEti(aHisEti[nX],"01")
			cArmOri2   := aEtiqueta[10]
			aEtiqueta[10] := cArmDes
			CBGrvEti("01",aEtiqueta,aHisEti[nX])
			CBLog("02",{CB0->CB0_CODPRO,CB0->CB0_QTDE,CB0->CB0_LOTE,CB0->CB0_SLOTE,cArmOri2,,cArmDes,,CB0->CB0_CODETI})
		Next
	Else

	EndIf
	If ExistBlock("ACD151GR")
		ExecBlock("ACD151GR",.F.,.F.)
	EndIf
End Transaction
VtRestore(,,,,aSave)
If lMsErroAuto
	VTDispFile(NomeAutoLog(),.t.)
Else
	If ExistBlock("ACD151OK")
		ExecBlock("ACD151OK",.F.,.F.)
	EndIf
	cArmOri     := Space(Tamsx3("B1_LOCPAD") [1])
	cEndOri     := Space(15)
	cCB0ArmOri  := Space(20)
	cArmDes     := Space(Tamsx3("B1_LOCPAD") [1])
	cCB0Prod	:= Space(20)
	cProduto  	:= Space(48)
	cLote       := Space(10)
	cSLote      := Space(6)
	cNumSerie   := Space(TamSX3("BF_NUMSERI")[1])
	nQtde    	:= 1
	aLista := {}
	aHisEti:= {}
EndIf
Return .t.

//�����������������������������������������������������������������������������
Static Function Informa()
Local aCab  := {"Produto","Quantidade","Armazem","Lote","SubLote","Num.Serie"} //"Produto"###"Quantidade"###"Armazem"###"Lote"###"SubLote"###"Num.Serie"
Local aSize := {15,16,7,10,7,20}
Local aSave := VTSAVE()
VtClear()
VTaBrowse(0,0,7,19,aCab,aLista,aSize)
VtRestore(,,,,aSave)
Return

//�����������������������������������������������������������������������������
Static Function Estorna()
Local aTela
Local cEtiqueta
Local nQtde := 1
aTela := VTSave()
VTClear()
cEtiqueta := Space(20)
@ 00,00 VtSay Padc("Estorno da Leitura",VTMaxCol()) //"Estorno da Leitura"
If ! UsaCB0('01')
	@ 1,00 VTSAY  'Qtde.' VTGet nQtde   pict CBPictQtde() when VTLastkey() == 5 //'Qtde.'
EndIf
@ 02,00 VtSay "Etiqueta:"
@ 03,00 VtGet cEtiqueta pict "@!" Valid VldEstorno(cEtiqueta,@nQtde)
VtRead
vtRestore(,,,,aTela)
Return

//�����������������������������������������������������������������������������
Static Function VldEstorno(cEtiqueta,nQtde)
Local nPos
Local aEtiqueta,nQE
Local aListaBKP := aClone(aLista)
Local aHisEtiBKP:= aClone(aHisEti)
Local aItensPallet := CBItPallet(cEtiqueta)
Local lIsPallet := .t.
Local nP

If Empty(cEtiqueta)
	Return .f.
EndIf

If len(aItensPallet) == 0
	aItensPallet:={cEtiqueta}
	lIsPallet := .f.
EndIf

Begin Sequence
	For nP:= 1 to len(aItensPallet)
		cEtiqueta:=padr(aItensPallet[nP],20)
		If UsaCB0("01")
			nPos := Ascan(aHisEti, {|x| AllTrim(x) == AllTrim(cEtiqueta)})
			If nPos == 0
				VTALERT("Etiqueta nao encontrada","Aviso",.T.,4000,2) //"Etiqueta nao encontrada"###"Aviso"
				Return .f.
//				Break
			EndIf
			aEtiqueta:=CBRetEti(cEtiqueta,'01')
			cProduto := aEtiqueta[1]
			cArmOri  := aEtiqueta[10]
			cEndOri  := aEtiqueta[9]
			cLote    := aEtiqueta[16]
			cSlote   := aEtiqueta[17]
			cNumSerie:=CB0->CB0_NUMSER

			If Empty(aEtiqueta[2])
				aEtiqueta[2] := 1
			EndIf
			nQtde	   := 1

			If ! lIsPallet .and. ! Empty(CB0->CB0_PALLET)
				VTALERT("Etiqueta invalida, Produto pertence a um Pallet","Aviso",.T.,4000,2) //"Etiqueta invalida, Produto pertence a um Pallet"###"Aviso"
				Return .f.
//				Break
			EndIf

		Else

			If ! CBLoad128(@cEtiqueta)
				Return .f.
			EndIf
			aEtiqueta := CBRetEtiEAN(cEtiqueta)
			If Len(aEtiqueta) == 0
				VTALERT("Etiqueta invalida","Aviso",.T.,4000,2) //"Etiqueta invalida"###"Aviso"
				VTKeyboard(chr(20))
				Return .f.
			EndIf
			cProduto := aEtiqueta[1]
			If ascan(aLista,{|x| x[1] ==cProduto}) == 0
				VTALERT("Produto nao encontrado","Aviso",.T.,4000,2) //"Produto nao encontrado"###"Aviso"
				VTKeyboard(chr(20))
				Return .f.
			EndIf
			cLote := aEtiqueta[3]
			If len(aEtiqueta) >=5
				cNumSerie:= padr(aEtiqueta[5],Len(Space(TamSX3("BF_NUMSERI")[1])))
			EndIf
		EndIf

		nQE := 1
		If ! CBProdUnit(cProduto)
			nQE := CBQtdEmb(cProduto)
			If Empty(nQE)
				Return .f.
//				Break
			EndIf
		EndIf
		nQtdeProd:=nQtde*nQE*aEtiqueta[2]

		If ! Usacb0("01") .and. ! CBRastro(cProduto,@cLote,@cSLote)
			Return .f.
//			Break
		EndIf

		nPos := Ascan(aLista,{|x| x[1]+x[3]+x[4]+x[5]+x[6] == cProduto+cArmOri+cLote+cSLote+cNumSerie})
		If nPos == 0
			VTALERT("Produto nao encontrado neste armazem","Aviso",.T.,4000,2) //"Produto nao encontrado neste armazem"###"Aviso"
			Return .f.
//			Break
		EndIf
		If aLista[nPos,2] < nQtdeProd
			VTALERT("Quantidade excede o estorno","Aviso",.T.,4000,2) //"Quantidade excede o estorno"###"Aviso"
			Return .f.
//			Break
		EndIf
		If UsaCB0("01")
			TrataArray(cEtiqueta,.t.)
		Else
			TrataArray(,.t.)
		EndIf
	Next
	If ! VTYesNo("Confirma o estorno?","ATENCAO",.t.) //"Confirma o estorno?"###"ATENCAO"
		Return .f.
//		Break
	EndIf
	nQtde:= 1
	VTGetRefresh("nQtdePro")
	VTKeyboard(chr(20))
	Return .f.
End Sequence
aLista := aClone(aListaBKP)
aHisEti:= aClone(aHisEtiBKP)
nQtde  := 1
VTGetRefresh("nQtdePro")
VTKeyBoard(chr(20))
Return .f.
