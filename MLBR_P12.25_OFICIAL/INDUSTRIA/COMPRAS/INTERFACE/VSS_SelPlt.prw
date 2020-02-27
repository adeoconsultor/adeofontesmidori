#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VSS_SelPltºAutor  ³Vinicius Schwartz   º Data ³  30/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para selecionar os pallets correspondentes ao lote   º±±
±±º          ³informado ao ser ajustado o empenho da OP. O objetivo eh    º±±
±±º          ³informar o pallet que sera consumido para facilitar a ras-  º±±
±±º          ³treabilidade do couro.    								  º±±
±±º          ³Solicitante: Thiago/Fabio - HDI 004883					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


User Function VSS_SelPlt()

Local cQuery := ""
Local cLote	 := M->D4_LOTECTL
Local cProd  := iif(TYPE("M->D4_COD") == "S", M->D4_COD, "")
//IF TYPE ("_aDados") == "A"
//   alert ("Jah existe")
//endifM->D4_COD
Local nPosCodP := 0
Local nPosPltF := 0
Local cCodP

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±± Declaração de Variaveis Private dos Objetos                             ±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Private cSayLot := cLote
Private oOk := LoadBitmap( GetResources(), "LBOK")
Private oNo := LoadBitmap( GetResources(), "LBNO")
Public cPallets := Space(1)

SetPrvt("oDlg1","oSay1","oSayLot","oBtn1","oBtn2","oBrw1")

If FunName() = "MATA381"
	Memowrite("C:\TEMP\PRD.TXT", cProd + Posicione("SB1", 1, xFilial("SB1")+cProd,"B1_GRUPO"))
	if !Posicione("SB1", 1, xFilial("SB1")+cProd,"B1_GRUPO") $ '11  '
	
		//Localiza posicao dos campos de Cod do produto e pallets       
		nPosCodP   :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_COD"})
		nPosPltF   :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_X_PLTF"})
		
		//Caso nao localize o produto ou o mesmo nao seja do grupo 11, sera finalizada a funcao
		cCodP := aCols[n,nPosCodP]
		//Alert ('Produto: ' + cCodP)
		If ! Vld_prod(cCodP,cLote)
			aCols[n,nPosPltF] := Space(1)
			Return .T.
		Endif
		
		//ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		//±± Definicao do Dialog e todos os seus componentes.                        ±±
		//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		oFont1     := TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, )
		oDlg1      := MSDialog():New( 234,543,517,811,"Seleciona Pallets",,,.F.,,,,,,.T.,,,.T. )
		oSay1      := TSay():New( 008,008,{||"Lote:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSayLot    := TSay():New( 008,028,{|u| If(PCount()>0,cSayLot:=u,cSayLot)},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oBtn1      := TButton():New( 125,087,"Confirmar",oDlg1,{|| Confirm_Plt(),oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )
		oBtn2      := TButton():New( 125,043,"Cancelar",oDlg1,{|| oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )
		
		@ 020,004  LISTBOX oBrw1 Fields HEADER "   ",'Pallet' SIZE 128,100  ON DBLCLICK clk_LST() Of oDlg1 Pixel
		
		//Query para filtrar todos os pallets do lote utilizado
		cQuery := " SELECT ZO_NUMPLT FROM SZO010 "
		cQuery += " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NUMLOTE = '"+cLote+"' AND D_E_L_E_T_ <> '*' "
		cQuery += " AND ZO_STATUS = 'LIB' AND ZO_NFCLASS = 'S' "
		
		If Select ('TMPSZO') > 0
			DbSelectArea('TMPSZO')
			DbCloseArea()
		EndIf
			
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TMPSZO',.T.,.T.)
		DbSelectArea("TMPSZO")
		DbGoTop()
		
		aPlts := {}
		
		//While para alimentar a grid a partir da query
		While !TMPSZO->(EOF())   
			Aadd(aPlts, {.F., TMPSZO->ZO_NUMPLT})
			TMPSZO->(DbSkip())		
		Enddo
		
		//Caso nao localize o lote informado na tabela SZO, sera finalizada a funcao
		if len(aPlts) == 0
			Alert('Para o lote informado não foi localizado nenhum pallet para seleção!!!')
			Aadd(aPlts,{ .F.,' '}  )
			oBtn1:Disable()
		Endif
		
		oBrw1:SetArray(aPlts)
		oBrw1:bLine := { || { iif( aPlts[oBrw1:nAt,1], ook, oNo ) , aPlts[oBrw1:nAt,2 ]}  }
		
		oDlg1:Activate(,,,.T.)
		
		//Preenche o campo D4_X_PLTF com os pallets selecionados
		aCols[n,nPosPltF] := cPallets
	endif	
EndIf

//Retorna se satisfazer todos os cases
Return .T.


//////////////////////////////////////////////////////
//Funcao chamada ao habilitar ou desabilitar um pallet
//////////////////////////////////////////////////////
Static Function clk_LST()
Local cPltMain := aPlts[oBrw1:nAt,2]
Local lFlagChk  := aPlts[oBrw1:nAt,1]
Local nn1

For nn1 := 1 to len( aPlts )
	if aPlts[nn1 , 2 ] == cPltMain

		if !  lFlagChk
			aPlts[nn1 , 1 ]  := .t.
		Else
			aPlts[nn1 ,1 ]  := .f.
		Endif
	Endif
Next

oBrw1:Refresh()

Return()

/////////////////////////////////////////////
//Validando se o produto pertence ao grupo 11
/////////////////////////////////////////////
Static Function Vld_prod(cCodP,cLot)
Local lRet := .T.

DbSelectArea('SB1')
DbSetOrder(1)

If DbSeek(xFilial('SB1') + cCodP)
	If SB1->B1_GRUPO == '11  ' .And. cLot <> Space(10)
		//Alert ('Localizou o produto')
		lRet := .T.
	Else
		//Alert('Retorna pq o produto não é do grupo, ou o lote está em branco')
		lRet := .F.
	Endif
Else
	//Alert ('Retorna pq não localizou o produto')
	lRet := .F.
Endif

Return lRet

//////////////////////////////////////
//Funcao para o botao de confirmacao//
//////////////////////////////////////
Static Function Confirm_Plt()
Local cPltAtu := ""
Local cPltTot := "/"
Local i

//Monta string com os pallets selecionados
For i:=1 to len (aPlts)
	If aPlts[i,1] .And. (aPlts [i,2] <> cPltAtu)
		cPltAtu := aPlts[i,2]
		cPltTot := cPltTot + cPltAtu + "/"
	endif
next i

//Atribui a string a variavel desconsiderando os espacos em branco
cPallets := StrTran(cPltTot,' ','')

Return