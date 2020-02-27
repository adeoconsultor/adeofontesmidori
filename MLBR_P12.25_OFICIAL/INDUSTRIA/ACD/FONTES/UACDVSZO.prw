#include "totvs.ch"
#INCLUDE 'APVT100.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ UAcdVSZO    ³ Autor ³ Antonio            ³ Data ³ 25/04/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de                                             	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ PLANO DE MELHORIA CONTINUA                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ITEM PMC  ³ Responsavel              ³ Data         |Docto             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      01  ³                          ³              |                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
//Template function Uacdv151(uPar1,uPar2,uPar3,uPar4,uPar5,uPar6,uPar7,uPar8,uPar9,uPar10)
//Return Uacdv151(uPar1,uPar2,uPar3,uPar4,uPar5,uPar6,uPar7,uPar8,uPar9,uPar10)

User Function UACDVSZO()

Local aKey        := array(3)

Private cCB0Prod  := Space(TamSx3("CB0_CODET2")[1])
Private cProduto  := Space(48)
Private c_CodEtq  := Space(10)
Private cSituacao := Space(2)

Private cNumSerie := Space(TamSX3("BF_NUMSERI")[1])
Private aLista    := {}
Private aHisEti   := {}
Private nQtdeProd := 1

//CBChkTemplate()

akey[3] := VTSetKey(09,{|| Informa()},"Informacoes")

While .t.
	VTClear
	nLin:= -1
	@ ++nLin,01 VTSAY "Situacao do Pallet"
	GetProduto()
	GetSit()
	VTRead
	If vtLastKey() == 27
		If len(aLista) > 0 .and. ! VTYesNo('Confirma a saida?','Atencao')
			loop
		EndIf
		Exit
	EndIf

	GravaSZO()

	VTKeyboard(chr(20))
	
End
vtsetkey(24,akey[1])
vtsetkey(09,akey[2])
Return
                        

//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function GetProduto()
If UsaCB0('01')

	@ ++nLin,0 VTSAY "Produto"
	@ ++nLin,0 VTGET cCB0Prod PICTURE "@!" valid VldProduto("01")

//	@ ++nLin,0 VTSAY "Situacao: "
//	@ nLin,10 VTGET cSituacao PICTURE "@!" valid VldSituacao("01")
//	@ ++nLin,0 VTSAY "1-Analise/2-Disponiv"
//	@ ++nLin,0 VTSAY "3-Consumo/4-Reprovad"

EndIf

Return .F.
                      

Static Function GetSit()
If UsaCB0('01')

	@ ++nLin,0 VTSAY "Situacao: "
	@ nLin,10 VTGET cSituacao PICTURE "@!" valid VldSituacao("01")
	@ ++nLin,0 VTSAY "1-Analise/2-Disponiv"
	@ ++nLin,0 VTSAY "3-Consumo/4-Reprovad"
	@ ++nLin,0 VTSAY "5-Transf Parcial"
	@ ++nLin,0 VTSAY "6-Devolvido"

EndIf

Return .F.



//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function VldSituacao(cTipo)

	If "01" $ cTipo
	
		If Empty(c_CodEtq) .or. Empty(cSituacao)
			VTKeyBoard(chr(20))
			Return .t.
		EndIf

		If AllTrim(cSituacao) <> '1'                      //'A Analise' 
			If AllTrim(cSituacao) <> '2'                  //'D Disponivel'
				If AllTrim(cSituacao) <> '3'              //'C Consumido'
					If AllTrim(cSituacao) <> '4'          //'R Reprovado'  
						If AllTrim(cSituacao) <> '5'      //'P Baixa Parcial'  
							If AllTrim(cSituacao) <> '6'  //'E Devolvido'  
								VTALERT("Situacao invalida, Situacoes Validas (123456 (ADCRPE) )!!! ","Aviso",.T.,4000,2)
								VTKeyBoard(chr(20))
								Return .f.
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf

		If AllTrim(cSituacao) == '3'             //'C'
			VTALERT("Situacao invalida, 3-(C)onsumo somente através de transferencia via RF!!! ","Aviso",.T.,4000,2)
			VTKeyBoard(chr(20))
			Return .f.
		ElseIf AllTrim(cSituacao) == '1'         //'A'
			VTALERT("Situacao invalida, o Produto ja se encontra em 1-(A)nalise!!! ","Aviso",.T.,4000,2)
			VTKeyBoard(chr(20))
			Return .f.
		EndIf

	EndIf

	VTKeyboard(chr(20))

Return .T.



//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function VldProduto(cTipo)

Local cTipId      := ""
Local aEtiqueta   := {}
Local aListaBKP   := {}
Local aHisEtiBKP  := {}
Local aItensPallet:= {}
Local lIsPallet   := .t.
Local nP

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
	If (cTipId == "01" .and. cTipId $ cTipo) .or. lIsPallet
                                                   
		aListaBKP := aClone(aLista)
		aHisEtiBKP:= aClone(aHisEti)

		Begin Sequence
			For nP:= 1 to len(aItensPallet)

				cCB0Prod := Padr(aItensPallet[nP],20)
				aEtiqueta:= CBRetEti(cCB0Prod,"01")

				If Empty(aEtiqueta)
					VTALERT("Etiqueta invalida","Aviso",.T.,4000,3)
					VTKeyBoard(chr(20))
					Return .f.
				EndIf
				If ! lIsPallet .and. ! Empty(CB0->CB0_PALLET)
					VTALERT("Etiqueta invalida, Produto pertence a um Pallet(PNP2)","Aviso",.T.,4000,2)
					VTKeyBoard(chr(20))
					Return .f.
				EndIf
				//--Valida se a etiqueta já foi consumida por outro processo
				If CB0->CB0_STATUS $ "123"  
					VTBeep(2)
					VTAlert("Etiqueta invalida","Aviso",.T.,4000,3)
					VTKeyBoard(chr(20))
					Return .f.
				EndIf				
				If ! Empty(aEtiqueta[2]) .and. Ascan(aHisEti,cCB0Prod) > 0
					VTALERT("Etiqueta ja lida","Aviso" ,.T.,4000,3)
					VTKeyBoard(chr(20))
					Return .f.
				EndIf
				If aEtiqueta[10] == SuperGetMV("MV_CQ")
					VtAlert("Esta rotina nao trata armazem de CQ!",'Aviso',.t.,4000,4)
					VtAlert("Utilize as rotinas de Envio/Baixa CQ!",'Aviso',.t.,4000,4)
					VTKeyBoard(chr(20))
					Return .f.
				EndIf
				If Localiza(aEtiqueta[1])
					VTALERT("Produto lido controla endereco!","Aviso",.T.,4000,3)
					VTALERT("Utilize rotina especifica ACDV150","Aviso",.T.,4000)
					VTKeyBoard(chr(20))
					Return .f.
				EndIf
				If !Empty(aEtiqueta[13])
					VTALERT("Etiqueta utilizada em NF saida.","Aviso",.T.,4000,3)
					VTKeyBoard(chr(20))
					Return .f.
				EndIf

				If Empty(aEtiqueta[2])
					aEtiqueta[2]:= 1
				EndIf

				cProduto  := aEtiqueta[1]

				TrataArray(cCB0Prod)

			Next

			VTKeyboard(chr(20))
			Return .F.

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
	aEtiqueta := CBRetEtiEAN(cProduto)
	If Empty(aEtiqueta) .or. Empty(aEtiqueta[2])
		VTALERT("Etiqueta invalida.","Aviso",.T.,4000,3)
		VTKeyboard(chr(20))
		Return .f.
	EndIf

	VTKeyboard(chr(20))
	cNumSerie:=Space(TamSX3("BF_NUMSERI")[1])

	Return .f.
EndIf

Return .f.



//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function TrataArray(cEtiqueta,lEstorno)
Local nPos
Default lEstorno := .f.
If ! lEstorno
	If cEtiqueta <> NIL
		aadd(aHisEti,cEtiqueta)
	EndIf	
	nPos := aScan(aLista,{|x| x[1]+x[3] == cProduto+cEtiqueta})
	If Empty(nPos)
		aadd(aLista,{cProduto,nQtdeProd,cEtiqueta})
	Else
		aLista[nPos,2]+=nQtdeProd
	EndIf
Else
	nPos := aScan(aLista,{|x| x[1]+x[3] == cProduto+cEtiqueta})
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

  

//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function GravaSZO()

Local aSave
Local lParSZO := SuperGetMv("MV_TSESZO",.F.,.T.)
Local nI

If ! VTYesNo("Confirma a Situacao?","Aviso" ,.T.)
	VTKeyboard(chr(20))
	Return .f.
EndIf

aSave     := VTSAVE()
VTClear()
VTMsg('Aguarde...')

If Alltrim(cSituacao) == '6'           //No caso de produtos devolvidos (situação=06) a alteração só pode ser individual por pallet
	lParSZO := .F.
EndIF

For nI:= 1 to Len(aLista)

	dbSelectArea("CB0")
	dbSetOrder(1)
	If dbSeek( xFilial("CB0") + aLista[nI,3] )

		cProd   := CB0->CB0_CODPRO
		cPallet := CB0->CB0_PALSZO
		cSayNF  := CB0->CB0_NFENT
		cSaySer := CB0->CB0_SERIEE
		cSayFor := CB0->CB0_FORNEC
		cSayLj  := CB0->CB0_LOJAFO	
		
		cQuery := " UPDATE "+RetSqlName("SZO")+" "
		cQuery += " SET "
		cQuery += "      ZO_SITUACA    =  '" + cSituacao       + "' "                                
		cQuery += "     ,ZO_DATAALT    =  '" + DtoS(dDataBase) + "' "
		cQuery += "     ,ZO_USUARIO    =  '" + RetCodUsr()     + "' " 
		If Alltrim(cSituacao) == '2'            //NO CASO DE ALTERAR A SITUAÇÃO PARA 2-DISPONIVEL, SERÁ GRAVADA A DATA DE LIBERACAO
			cQuery += "     ,ZO_DTLIBE =  '" + DtoS(dDataBase) + "' "
		EndIf
		cQuery += " WHERE   ZO_FILIAL  =  '" + xFilial('SZO')  + "' "
		cQuery += "     AND ZO_NFORI   =  '" + cSayNF          + "' "
		cQuery += "     AND ZO_SERIE   =  '" + cSaySer         + "' "
		cQuery += " 	AND ZO_CODFOR  =  '" + cSayFor         + "' "         
		cQuery += "     AND ZO_LJFOR   =  '" + cSayLj          + "' "
		cQuery += " 	AND D_E_L_E_T_ <> '*' "
		If !lParSZO          //altera somente o pallet caso contrario, altera todos os produtos da nf
			cQuery += " 	AND ZO_NUMPLT  =  '" + cPallet         + "' "
		EndIf
		
		TcSqlExec( cQuery )    

	EndIf

Next

Return .t.



//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function Informa()
Local aCab  := {"Produto","Quantidade","Armazem","Lote","SubLote","Num.Serie"}
Local aSize := {15,16,7,10,7,20}
Local aSave := VTSAVE()
VtClear()
VTaBrowse(0,0,7,19,aCab,aLista,aSize)
VtRestore(,,,,aSave)
Return
