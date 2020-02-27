#include "totvs.ch"
#INCLUDE 'APVT100.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ UAcdV151    ³ Autor ³ Antonio            ³ Data ³ 13/04/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de transferencia (sem Controle de Localizacao) 	  ³±±
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

User Function UACDV151()

Local aKey        := array(3)

Private cArmOri   := Space(TamSx3("B1_LOCPAD") [1])
Private cArmDes   := Space(TamSx3("B1_LOCPAD") [1])
Private cCB0Prod  := Space(TamSx3("CB0_CODET2")[1])
Private cProduto  := Space(48)
Private cOrdSep   := Space(TamSx3("D4_X_ORSEP")[1])

Private nQtde     := 1
Private nQtdeProd := 1
Private cLote     := Space(10)
Private cSLote    := Space(6)
Private cNumSerie := Space(TamSX3("BF_NUMSERI")[1])
Private aLista    := {}
Private aHisEti   := {}
Private lMsErroAuto := .F.
Private nLin:= 0
Private aProdSD4:={}                    
//Private cEtiqueta

//CBChkTemplate()

akey[2] := VTSetKey(24,{|| Estorna()},"Estorna")
akey[3] := VTSetKey(09,{|| Informa()},"Informacoes")

While .t.
	VTClear
	nLin:= -1
	@ ++nLin,02 VTSAY "ORDEM DE SEPARACAO"
	If ! GetArmOri()
		Exit
	EndIf
	GetOrdSep()
	GetProduto()
	GetArmDes()
	VTRead
	If vtLastKey() == 27
		If len(aLista) > 0 .and. ! VTYesNo('Confirma a saida?','Atencao')
			loop
		EndIf
		Exit
	EndIf
End
vtsetkey(24,akey[1])
vtsetkey(09,akey[2])
Return
                        

//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function GetOrdSep()
//If ! UsaCB0('01')
	@ ++nLin,0 VtSay 'Nr. Ordem Separacao'
	@ ++nLin,0 VTGet cOrdSep pict '@!' Valid VldOrdSep()
	VTRead()
	If VTLastkey() == 27
		Return .f.
	EndIf
	VTClear(1,0,2,19)
	nLin := 0
//EndIf

	If len(aLista) > 0
		If VTYesNo('Encerrar Ord. Separacao?','Atencao')
			If ZZP->(DbSeek(xFilial("ZZP")+cOrdSep ))
				RecLock("ZZP",.F.)
				ZZP->ZZP_STATUS  := 'E'
				MsUnlock()
			EndIF
		EndIF
	EndIF

Return .t.

//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function VldOrdSep()

    Local cSql       := ""
	Local cXUAliaSD4 := GetNextAlias()
	Local cAliSD4CTL := GetNextAlias()

	Private _nTQtde  := 0

//	Private aProdSD4:={}
	    
	If Empty(cOrdSep)
		VtAlert('Ordem Separacao Invalida','Aviso' ,.t.,4000,4)
		VTKeyboard(chr(20))
		Return .f.
	Else
		ZZP->(DbSetOrder(1))
		If ZZP->(!DbSeek(xFilial("ZZP")+cOrdSep))
			VtAlert('Ordem de Separacao Nao Cadastrada','Aviso' ,.t.,4000,4)
			VTKeyboard(chr(20))
			Return .f.
		Else
			If ZZP->ZZP_STATUS == 'E'
				VtAlert('Ordem de Separacao Encerrada','Aviso' ,.t.,4000,4)
				VTKeyboard(chr(20))
				Return .f.
			EndIf
		EndIf
	EndIf
 

	cSql := " SELECT SD4.D4_COD, SD4.D4_X_LOTE, SD4.D4_X_ORSEP, SUM(SD4.D4_QUANT) D4_QUANT" //ALTERADO LOTE CTL
	cSql += "  FROM " + RetSqlName("SD4") + " SD4 "
	cSql += "   WHERE SD4.D4_FILIAL   =  '" + xFilial("SD4") + "' "
	cSql += "     AND SD4.D_E_L_E_T_  =  ' ' "
	cSql += "     AND SD4.D4_X_ORSEP  =  '" + cOrdSep + "' " 
	cSql += " GROUP BY SD4.D4_COD , SD4.D4_X_LOTE, SD4.D4_X_ORSEP "      //ALTERADO LOTE CTL
	cSql += " ORDER BY SD4.D4_COD , SD4.D4_X_LOTE, SD4.D4_X_ORSEP "
	
	dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql),cXUAliaSD4,.F.,.T.)
 
	If (cXUAliaSD4)->(Eof())
		VtAlert('Ordem Separacao Invalida', 'Aviso' ,.t.,4000,4)
		VTKeyboard(chr(20))
		Return .f.
	Else
		While (cXUAliaSD4)->(!Eof())

			aAdd(aProdSD4,{(cXUAliaSD4)->D4_COD,(cXUAliaSD4)->D4_X_LOTE, (cXUAliaSD4)->D4_X_ORSEP, (cXUAliaSD4)->D4_QUANT})
            _nTQtde+=(cXUAliaSD4)->D4_QUANT
			(cXUAliaSD4)->(dbSkip())

		End
    EndIf

	(cXUAliaSD4)->(dbCloseArea())
    
Return .t.


//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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


//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function VldArmOri()
If Empty(cArmOri)
	VtAlert('Armazem invalido','Aviso',.t.,4000,4)
	VTKeyboard(chr(20))
	Return .f.
EndIf
If Trim(cArmOri) == SuperGetMV("MV_CQ")
	VtAlert("Esta rotina nao trata armazem de CQ!",'Aviso',.t.,4000,4)
	VtAlert("Utilize as rotinas de Envio/Baixa CQ!",'Aviso',.t.,4000,4)
	VTKeyboard(chr(20))
	Return .f.
EndIf
Return .t.

//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
Local cSql        := ""
Local cYUAliaSD4   := GetNextAlias()
Local nI
Local nII                                               
//Local cEtiqueta

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
					VTALERT("Etiqueta invalida","Aviso",.T.,4000,3)
					Break
				EndIf
				If ! lIsPallet .and. ! Empty(CB0->CB0_PALLET)
					VTALERT("Etiqueta invalida, Produto pertence a um Pallet","Aviso",.T.,4000,2)
					Break
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
					Break
				EndIf
				If aEtiqueta[10] == SuperGetMV("MV_CQ")
					VtAlert("Esta rotina nao trata armazem de CQ!",'Aviso',.t.,4000,4)
					VtAlert("Utilize as rotinas de Envio/Baixa CQ!",'Aviso',.t.,4000,4)
					Break
				EndIf
				If Localiza(aEtiqueta[1])
					VTALERT("Produto lido controla endereco!","Aviso",.T.,4000,3)
					VTALERT("Utilize rotina especifica ACDV150","Aviso",.T.,4000)
					Break
				EndIf
				If !Empty(aEtiqueta[13])
					VTALERT("Etiqueta utilizada em NF saida.","Aviso",.T.,4000,3)
					Break
				EndIf
				If Empty(aEtiqueta[2])
					aEtiqueta[2]:= 1
				EndIf

				cArmOri := aEtiqueta[10]
				cLote   := aEtiqueta[16]
				cSLote  := aEtiqueta[17]
				cNumSerie:=CB0->CB0_NUMSER

				If ! CBProdLib(cArmOri,aEtiqueta[1])
					Break
				EndIf
				cProduto  := aEtiqueta[1]
				nQE:= 1
				If ! CBProdUnit(aEtiqueta[1])
					nQE := CBQtdEmb(aEtiqueta[1])
					If empty(nQE)
						Break
					EndIf
				EndIf
				nQtdeProd := aEtiqueta[2]*nQE

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Consiste Quantidade Negativa                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SuperGetMV('MV_ESTNEG')=='N'
					nQtdeLida := 0
					aEval(aLista,{|x|  If(x[1]+x[3]+x[4]+x[5]+x[6]==cProduto+cArmOri+cLote+cSLote+cNumSerie,nQtdeLida+=x[2],nil)})
					//--> Verifica se o saldo do armz esta liberado
					SB2->(DbSetOrder(1))
					SB2->(DbSeek(xFilial("SB2")+cProduto+cArmOri))
					nSaldo := SaldoMov()
					If nQtdeProd+nQtdeLida >  nSaldo
						VTALERT("Quantidade excede o saldo disponivel","Aviso",.T.,4000,3) 
						Break
					EndIf
				EndIf

				//VALIDA SE O PRODUTO EXISTE NA SD4 DE ACORDO COM A ORDEM DE SEPARAÇÃO
				cSql := "SELECT SD4.D4_COD      PRODUTO "
				cSql += "     , SD4.D4_X_ORSEP          "
				cSql += "     , SD4.D4_LOCAL    ARMAZEM "
				cSql += "     , SD4.D4_OP       OP      " 
				cSql += "     , SD4.D4_TRT      TRT     " 
				cSql += "     , SD4.D4_QUANT    EMPENHO "
				cSql += "     , SD4.D4_DATA     DATA    "
				cSql += "     , SD4.D4_X_LOTE   LOTE    "   //ALTERADO LOTE X X_LOTE
				cSql += "     , SB1.B1_RASTRO   RASTRO  "
				cSql += "     , SB1.B1_LOCALIZ  LOCALIZ "
				cSql += "     , SD4.R_E_C_N_O_  RECNOD4 "                                    
				//	cSql += "     , COALESCE( X.DC_QTDORIG, 0 ) EMPENDER " // TOTAL JA EMPENHADO NOS ENDERECOS ( SBF )
				cSql += "  FROM " + RetSqlName("SD4") + " SD4 "
				cSql += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
				cSql += "                      AND SB1.B1_COD = SD4.D4_COD "
				cSql += "                      AND ( SB1.B1_RASTRO = 'L' OR SB1.B1_LOCALIZ = 'S' ) "
				cSql += "   WHERE SD4.D4_FILIAL   =  '" + xFilial("SD4") + "' "
				cSql += "     AND SD4.D_E_L_E_T_  =  ' ' "
				cSql += "     AND SD4.D4_X_ORSEP  =  '" + cOrdSep  + "' "
				cSql += "     AND SD4.D4_COD      =  '" + cProduto + "' "
				//				cSql += "     AND SD4.D4_LOCAL    =  '" + cArmOri  + "' "
				cSql += "     AND SD4.D4_X_LOTE   =  '" + cLote    + "' "
				dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql),cYUAliaSD4,.F.,.T.)
				
				If (cYUAliaSD4)->(Eof())
					VtAlert('Produto Não Pertence a Esta Ordem Separacao', 'Aviso' ,.t.,4000,4)
					(cYUAliaSD4)->(dbCloseArea())
					VTKeyboard(chr(20))
					Return .f.
				EndIf
				
				If !Empty(CB0->CB0_X_ORSE)
					VtAlert('Etiqueta ja utilizada em outra Ordem Separacao', 'Aviso' ,.t.,4000,4)
					VTKeyboard(chr(20))
					Return .f.
				EndIf

				//validação para checar se a quantidade solicitada a transferir pela Ordem de Separação ja é suficiente - Antonio 02/05/017
				//INICIO
				l_X_Ret:=.F.
				n_X_QteT:=0
				n_X_Qtde:=0
				n_X_QteGer:=0
                For nI:=1 to Len(aProdSD4)                     
															    
//					n_T_Qtde := n_T_Qtde + aProdSD4[nI,4]

					If Ascan(aProdSD4[nI],aEtiqueta[1]) > 0          //Procurar se o produto existe no array(aProdSD4)

						If Ascan(aProdSD4[nI],aEtiqueta[16]) > 0          //Procurar se o LOTE existe no array(aProdSD4)
	
							n_X_Qtde:=aProdSD4[nI,4]
	
							For nII:=1 to Len(aLista)                    //Comparar se o produto existe no array(aLista)
								If aLista[nII, 1] == aEtiqueta[1]
									If aLista[nII, 4] == aEtiqueta[16]
										n_X_QteT += aLista[nII, 2]
										l_X_Ret:=.T.
									EndIf
								EndIf
	
								n_X_QteGer += aLista[nII, 2]
	
							Next
	
 							/*ERRO - ANTONIO VERIFICAR O PORQUE NÃO ESTA CALCULANDO CORRETAMENTE - 07/12/17
 							If l_X_Ret
								If n_X_QteT > n_X_Qtde
									VtAlert('Quantidade de Etiquetas ja Atingiram a qtde total para este Produto!', 'Aviso' ,.t.,4000,4)
									VTKeyboard(chr(20))
									Return .f.
								EndIf
							EndIf
							If n_X_QteGer >= _nTQtde
								n_X_QteGer := 0
								VtAlert('Quantidade de Etiquetas para Ordem de Separação Atendida!', 'Aviso' ,.t.,4000,4)
								VTKeyboard(chr(20))
								Return .T.
		                    EndIf
		                    ERRO - ANTONIO VERIFICAR O PORQUE NÃO ESTA CALCULANDO CORRETAMENTE - 07/12/17
		                    */

	                    EndIf

                    EndIf

                Next
				//validação para checar se a quantidade solicitada a transferir pela Ordem de Separação ja é suficiente - Antonio 02/05/017
				//FIM

				If ExistBlock("AV151VPR")
					If ! ExecBlock("AV151VPR",.F.,.F.,aEtiqueta)
						//break
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
		VTALERT("Etiqueta invalida","Aviso" ,.T.,4000,3)
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
		VTALERT("Etiqueta invalida.","Aviso",.T.,4000,3)
		VTKeyboard(chr(20))
		Return .f.
	EndIf
	aEtiqueta := CBRetEtiEAN(cProduto)
	If Empty(aEtiqueta) .or. Empty(aEtiqueta[2])
		VTALERT("Etiqueta invalida.","Aviso",.T.,4000,3)
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
		VTALERT("Produto lido controla endereco!","Aviso",.T.,4000,3)
		VTALERT("Utilize rotina especifica ACDV150","Aviso",.T.,4000)
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
			VTALERT("Quantidade excede o saldo disponivel","Aviso" ,.T.,4000,3)
			cLote  := Space(10)
			cSLote := Space(6)
			cNumSerie:= Space(TamSX3("BF_NUMSERI")[1])
			VTKeyboard(chr(20))
			Return .f.
		EndIf
	EndIf

	If ExistBlock("AV151VPR")
		If ! ExecBlock("AV151VPR",.F.,.F.,aEtiqueta)
			VTKeyboard(chr(20))
			Return .f.
		EndIf
	EndIf

	//VALIDA SE O PRODUTO EXISTE NA SD4 DE ACORDO COM A ORDEM DE SEPARAÇÃO

	cSql := "SELECT SD4.D4_COD     PRODUTO "
	cSql += "     , SD4.D4_X_ORSEP   "
	cSql += "     , SD4.D4_LOCAL   ARMAZEM "
	cSql += "     , SD4.D4_OP      OP      "
	cSql += "     , SD4.D4_QUANT   EMPENHO "
	cSql += "     , SD4.D4_DATA    DATA    "
	cSql += "     , SD4.D4_X_LOTE  LOTE    "   //ALTERADO LOTE CTL
//	cSql += "     , SB1.B1_RASTRO  RASTRO "
//	cSql += "     , SB1.B1_LOCALIZ LOCALIZ "
	cSql += "     , SD4.R_E_C_N_O_ RECNOD4 "                                    
//	cSql += "     , COALESCE( X.DC_QTDORIG, 0 ) EMPENDER " // TOTAL JA EMPENHADO NOS ENDERECOS ( SBF )
	cSql += "  FROM " + RetSqlName("SD4") + " SD4 "
	cSql += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
	cSql += "                      AND SB1.B1_COD = SD4.D4_COD "
	cSql += "                      AND ( SB1.B1_RASTRO = 'L' OR SB1.B1_LOCALIZ = 'S' ) "
	cSql += "   WHERE SD4.D4_FILIAL   =  '" + xFilial("SD4") + "' "
	cSql += "     AND SD4.D_E_L_E_T_  =  ' ' "
	cSql += "     AND SD4.D4_X_ORSEP  =  '" + cOrdSep  + "' "
	cSql += "     AND SD4.D4_COD      =  '" + cProduto + "' "
//	cSql += "     AND SD4.D4_LOCAL    =  '" + cArmOri  + "' "
	cSql += "     AND SD4.D4_X_LOTE   =  '" + cLote    + "' "
	dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql),cYUAliaSD4,.F.,.T.)
	
	If (cYUAliaSD4)->(Eof())
		VtAlert('Produto Não Pertence a Esta Ordem Separacao', 'Aviso' ,.t.,4000,4)
		VTKeyboard(chr(20))
		Return .f.
	EndIf
	
	If !Empty(CB0->CB0_X_ORSE)
		VtAlert('Etiqueta ja utilizada em outra Ordem Separacao', 'Aviso' ,.t.,4000,4)
		VTKeyboard(chr(20))
		Return .f.
	EndIf 

	TrataArray(Nil)
	nQtde := 1
	VTGetRefresh('nQtde')
	VTKeyboard(chr(20))
	cLote  := Space(10)
	cSLote := Space(6)
	cNumSerie:=Space(TamSX3("BF_NUMSERI")[1])

	(cYUAliaSD4)->(dbCloseArea())

	Return .f.
EndIf

Return .f.



//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function GetArmDes()
@ ++nLin,0 VtSay 'Armazem destino'
@ ++nLin,0 VTGet cArmDes pict '@!' Valid VTLastkey() == 5 .or. (! Empty(cArmDes) .and. VldEndDes()) When !Empty(aLista)
Return

//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function VldEndDes()
Local nI
If Empty(cArmDes)
	VtAlert('Armazem invalido','Aviso',.t.,4000,4)
	VTKeyboard(chr(20))
	VTClearGet("cArmDes")
	VTGetSetFocus("cArmDes")
	Return .f.
EndIf
If Trim(cArmDes) == SuperGetMV("MV_CQ")
	VtAlert("Esta rotina nao trata armazem de CQ!",'Aviso',.t.,4000,4)
	VtAlert("Utilize as rotinas de Envio/Baixa CQ!",'Aviso',.t.,4000,4)
	VTKeyboard(chr(20))
	Return .f.
EndIf
For nI := 1 to Len(aLista)
	If ! CBProdLib(cArmDes,aLista[nI,1],.f.)
		VTALERT('Produto '+aLista[nI,1]+' bloqueado para inventario no armazem '+cArmDes,'Aviso',.t.,4000,2)
		VTKeyboard(chr(20))
		If ! UsaCb0("02")
			VTClearGet("cArmDes")
			VTGetSetFocus("cArmDes")
		EndIf
		Return .f.
	EndIf
	SB2->(DbSetOrder(1))
	If !SB2->(MsSeek(xFilial('SB2')+aLista[nI,1]+cArmDes,.F.)) .And. SuperGetMV('MV_VLDALMO',.F.,'S') == 'S'
		VtAlert(''+AllTrim(aLista[nI,1])+".")  //STR0045
		VTClearGet("cArmDes")
		VTGetSetFocus("cArmDes")
		Return .F.
	EndIf
Next
If Ascan(aLista,{|x| x[3] ==cArmDes}) > 0
	VTALERT("Armazem de origem igual ao destino","Aviso" ,.T.,4000,3)
	VTKeyboard(chr(20))
	If ! UsaCb0("02")
		VTClearGet("cArmDes")
		VTGetSetFocus("cArmDes")
	EndIf
	Return .f.
EndIf  
If ! GravaTransf()
	VTALERT("Transferencia não efetuada, utiliza a rotina manual para correçoes e contate o TI","Aviso" ,.T.,4000,3)
	VTKeyboard(chr(20))
	VTClearGet("cArmDes") 
	VTClearGet("cOrdSep")
	Return .f.
Else
	If !lMsErroAuto
		VTALERT("Transferencia efetuada com sucesso!!!","Aviso" ,.T.,4000,3)   //////////////antonio 23/01/18 por o lMsErroAuto aqui
		VTKeyboard(chr(20))
		VTClearGet("cArmDes") 
		VTClearGet("cOrdSep")
	Else
		VTALERT("Transferencia não efetuada, utilize a rotina manual para correções e contate o TI","Aviso" ,.T.,4000,3)
		VTKeyboard(chr(20))
		VTClearGet("cArmDes") 
		VTClearGet("cOrdSep")
		Return .f.
	EndIf
EndIf
Return .t.


//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function GravaTransf()
Local aSave
Local nI,nX
Local aTransf:={}
Local aEtiqueta
Local cArmOri2 := ""
Local cDoc     := ""
Local dValid          
Local cAliSD4CTL := GetNextAlias()
//Private nModulo := 4

If ! VTYesNo("Confirma transferencia?","Aviso" ,.T.)
	VTKeyboard(chr(20))
	Return .f.
EndIf

aSave     := VTSAVE()
VTClear()
VTMsg('Aguarde...')
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada: Informar numero do documento.            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock('ACD151DC')
	cDoc := ExecBlock('ACD151DC',.F.,.F.)
	cDoc := If(ValType(cDoc)=="C",cDoc,"")
Endif

Begin Transaction

	lMsErroAuto := .F.
//	lMsHelpAuto := .T.
	aTransf:=Array(len(aLista)+1)
	aTransf[1] := {cDoc,dDataBase}
	For nI := 1 to Len(aLista)
	
		//GRAVAÇÃO DO LOTE NA SD4 DE ACORDO COM A ORDEM DE SEPARAÇÃO
		//O lote é gravado neste momento para que funcione corretamente a transferencia via execauto.
		cSql := "SELECT SD4.D4_COD     PRODUTO   "
		cSql += "     , SD4.D4_X_ORSEP           "
		cSql += "     , SD4.D4_OP      OP        " 
		cSql += "     , SD4.D4_TRT     TRT       " 
		cSql += "     , SD4.D4_X_LOTE  X_LOTE    "
		cSql += "     , SD4.D4_X_DTVLL X_DTVLL   "				
		cSql += "     , SD4.R_E_C_N_O_ X_RECNOD4 "                                    
		cSql += "  FROM " + RetSqlName("SD4") + " SD4 "
		cSql += "   WHERE SD4.D4_FILIAL   =  '" + xFilial("SD4") + "' "	
		cSql += "     AND SD4.D_E_L_E_T_  =  ' ' "
		cSql += "     AND SD4.D4_COD  =  '" + aLista[nI,1]  + "' "
		cSql += "     AND SD4.D4_X_ORSEP  =  '" + cOrdSep  + "' "
		dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql),cAliSD4CTL,.F.,.T.)
		
		If (cAliSD4CTL)->(Eof())
			VtAlert('Produto Não Pertence a Esta Ordem Separacao', 'Aviso' ,.t.,4000,4)
			(cAliSD4CTL)->(dbCloseArea())
			VTKeyboard(chr(20))
			Return .f.
		Else
/*			While (cAliSD4CTL)->(!Eof())
                    //////AJUSTA O EMPENHO
				dbGoTo((cAliSD4CTL)->X_RECNOD4)
				If RecLock("SD4",.F.)
					SD4->D4_LOTECTL := (cAliSD4CTL)->X_LOTE  
					SD4->D4_DTVALID := StoD((cAliSD4CTL)->X_DTVLL)        //StoD(aEmpenho[nX,5])
					MsUnlock()
				EndIf

				(cAliSD4CTL)->(dbSkip())							

			EndDo*/

			(cAliSD4CTL)->(dbCloseArea())

		EndIf
		//GRAVAÇÃO DO LOTE NA SD4 DE ACORDO COM A ORDEM DE SEPARAÇÃO

		SB1->(dbSeek(xFilial("SB1")+aLista[nI,1]))
		dValid := dDatabase+SB1->B1_PRVALID
		If Rastro(aLista[nI,1])
			SB8->(DbSetOrder(3))
			SB8->(DbSeek(xFilial("SB8")+aLista[nI,1]+aLista[nI,3]+aLista[nI,4]+AllTrim(aLista[nI,5])))
			dValid := SB8->B8_DTVALID
		EndIf

 		aTransf[nI+1]:=   {{"D3_COD"    , SB1->B1_COD			,NIL}} // Produto origem
		aAdd(aTransf[nI+1],{"D3_DESCRI" , SB1->B1_DESC			,NIL}) // Descricao produto origem
		aAdd(aTransf[nI+1],{"D3_UM"     , SB1->B1_UM			,NIL}) // UM origem
		aAdd(aTransf[nI+1],{"D3_LOCAL"  , aLista[nI,3]			,NIL}) // Almox origem 
		aAdd(aTransf[nI+1],{"D3_LOCALIZ", Space(15)				,NIL}) // Endereco origem

		aAdd(aTransf[nI+1],{"D3_COD"    , SB1->B1_COD			,NIL}) // Produto destino
		aAdd(aTransf[nI+1],{"D3_DESCRI" , SB1->B1_DESC			,NIL}) // Descricao produto destino
		aAdd(aTransf[nI+1],{"D3_UM"     , SB1->B1_UM			,NIL}) // UM destino
		aAdd(aTransf[nI+1],{"D3_LOCAL"  , cArmDes				,NIL}) // Almox destino
		aAdd(aTransf[nI+1],{"D3_LOCALIZ", Space(15)				,NIL}) // Endereco destino

		aAdd(aTransf[nI+1],{"D3_NUMSERI", aLista[nI,6]			,NIL}) // numserie
		aAdd(aTransf[nI+1],{"D3_LOTECTL", aLista[nI,4]			,NIL}) // lote origem
		aAdd(aTransf[nI+1],{"D3_NUMLOTE", aLista[nI,5]			,NIL}) // sublote origem
		aAdd(aTransf[nI+1],{"D3_DTVALID", dValid				,NIL}) // valid lote origem
		aAdd(aTransf[nI+1],{"D3_POTENCI", criavar("D3_POTENCI")	,NIL}) // Potencia
		aAdd(aTransf[nI+1],{"D3_QUANT"  , aLista[nI,2]			,NIL}) // quantidade
		aAdd(aTransf[nI+1],{"D3_QTSEGUM", criavar("D3_QTSEGUM")	,NIL}) // 2a und Med
		aAdd(aTransf[nI+1],{"D3_ESTORNO", criavar("D3_ESTORNO") ,NIL}) // Estorno
		aadd(aTransf[nI+1],{"D3_NUMSEQ" , criavar("D3_NUMSEQ")  ,NIL}) // Sequencia (D3_NUMSEQ)
		aAdd(aTransf[nI+1],{"D3_LOTECTL", aLista[nI,4]			,NIL}) // lote DESTINO
		aAdd(aTransf[nI+1],{"D3_DTVALID", dValid				,NIL}) // valid lote DESTINO
		aAdd(aTransf[nI+1],{"D3_DTLANC" , dDataBase				,NIL}) // DT Lancamento
		aAdd(aTransf[nI+1],{"D3_OBSERVA", 'Incluido via UACDV151',NIL}) // Observação

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

	MSExecAuto({|x,y| MATA261(x,y)},aTransf,3)

	If lMsErroAuto
//		MsgInfo("A Transferencia desse produto não foi realizada, favor verificar e transferir manualmente para evitar divergencias")
		VTALERT("Falha na gravacao da transferencia","ERRO",.T.,4000,3)
		Mostraerro()
		DisarmTransaction()
		Break 
		Return .f.
	Else
		// Subtrai quantidade transferida do empenho previsto B8_QEMPPRE
		// Diego Mafisolli - 30/10/2017
		For nI := 1 to Len(aLista)
			SB8->(DbSetOrder(3))
			SB8->(DbSeek(xFilial("SB8")+aLista[nI,1]+aLista[nI,3]+aLista[nI,4]+AllTrim(aLista[nI,5])))
	    	If RecLock("SB8",.F.)
	    		If (SB8->B8_QEMPPRE - aLista[nI,2]) > 0 
					SB8->B8_QEMPPRE := SB8->B8_QEMPPRE - aLista[nI,2]
				MsUnlock() 
				Else
					SB8->B8_QEMPPRE := 0
				Endif
			EndIf   
			                 
		Next
	EndIf 
	
	If UsaCb0("01") .and. Len(aHiseti) > 0
		For nx:= 1 to len(aHisEti)
			aEtiqueta := CBRetEti(aHisEti[nX],"01")
			cArmOri2   := aEtiqueta[10]
			aEtiqueta[10] := cArmDes
			CBGrvEti("01",aEtiqueta,aHisEti[nX])
			CBLog("02",{CB0->CB0_CODPRO,CB0->CB0_QTDE,CB0->CB0_LOTE,CB0->CB0_SLOTE,cArmOri2,,cArmDes,,CB0->CB0_CODETI})
		Next
	EndIf

	///NESTE MOMENTO AJUSTA EMPENHO
	If !lMsErroAuto

    	          //PRODUTO   /LOTE        /DVALID/ARMAZEM DESTINO
		For nI := 1 to Len(aLista)
			UACD151GR(aLista[nI,1],aLista[nI,4],dValid,cArmDes)  //ajusta empenho colocando o lote antes da transferencia
		Next


		If lMsErroAuto
			VTDispFile(NomeAutoLog(),.t.)
		Else
		//	If ExistBlock("ACD151OK")
		//		ExecBlock("ACD151OK",.F.,.F.)
		//	EndIf
		
			For nX := 1 to len(aHisEti)
		
				CB0->(dbSetOrder(1))                        //Grava numero da ordem de separação para não utilizar mais esta etiqueta
				If CB0->(dbSeek(xFilial("CB0")+aHisEti[nX]))
					RecLock("CB0",.F.)
					CB0->CB0_X_ORSE := cOrdSep
					CB0->(MsUnlock())
				EndIf
		
			Next 
		
			//AJUSTAR O EMPENHO - ANTONIO         ->"UACD151GR"
		
			cArmOri     := "" //Space(Tamsx3("B1_LOCPAD") [1])
			cEndOri     := "" //Space(15)
		//	cCB0ArmOri  := "" //Space(20)
			cArmDes     := "" //Space(Tamsx3("B1_LOCPAD") [1])
			cCB0Prod	:= "" //Space(20)
			cProduto  	:= "" //Space(48)
			cLote       := "" //Space(10)
			cSLote      := "" //Space(6)
			cNumSerie   := "" //Space(TamSX3("BF_NUMSERI")[1])
			nQtde    	:= 1
			aLista := {}
			aHisEti:= {}
		
		EndIf

	EndIf
 
End Transaction
VtRestore(,,,,aSave)

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


//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function Estorna()
Local aTela
Local cEtiqueta
Local nQtde := 1
aTela := VTSave()
VTClear()
cEtiqueta := Space(20)
@ 00,00 VtSay Padc("Estorno da Leitura",VTMaxCol())
If ! UsaCB0('01')
	@ 1,00 VTSAY  'Qtde.' VTGet nQtde   pict CBPictQtde() when VTLastkey() == 5
EndIf
@ 02,00 VtSay "Etiqueta:"
@ 03,00 VtGet cEtiqueta pict "@!" Valid VldEstorno(cEtiqueta,@nQtde)
VtRead
vtRestore(,,,,aTela)
Return


//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
				VTALERT("Etiqueta nao encontrada","Aviso",.T.,4000,2)
				Break
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
				VTALERT("Etiqueta invalida, Produto pertence a um Pallet","Aviso",.T.,4000,2)
				Break
			EndIf
		Else
			If ! CBLoad128(@cEtiqueta)
				Return .f.
			EndIf
			aEtiqueta := CBRetEtiEAN(cEtiqueta)
			If Len(aEtiqueta) == 0
				VTALERT("Etiqueta invalida","Aviso",.T.,4000,2)
				VTKeyboard(chr(20))
				Return .f.
			EndIf
			cProduto := aEtiqueta[1]
			If ascan(aLista,{|x| x[1] ==cProduto}) == 0
				VTALERT("Produto nao encontrado","Aviso",.T.,4000,2)
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
				Break
			EndIf
		EndIf
		nQtdeProd:=nQtde*nQE*aEtiqueta[2]

		If ! Usacb0("01") .and. ! CBRastro(cProduto,@cLote,@cSLote)
			Break
		EndIf

		nPos := Ascan(aLista,{|x| x[1]+x[3]+x[4]+x[5]+x[6] == cProduto+cArmOri+cLote+cSLote+cNumSerie})
		If nPos == 0
			VTALERT("Produto nao encontrado neste armazem","Aviso",.T.,4000,2)
			Break
		EndIf
		If aLista[nPos,2] < nQtdeProd
			VTALERT("Quantidade excede o estorno","Aviso",.T.,4000,2)
			Break
		EndIf
		If UsaCB0("01")
			TrataArray(cEtiqueta,.t.)
		Else
			TrataArray(,.t.)
		EndIf
	Next
	If ! VTYesNo("Confirma o estorno?","ATENCAO",.t.)
		Break
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
                    


//Ajustar o empenho para os lotes //"UACD151GR"
Static Function UACD151GR(cProduto,cxLote,dvalid,cArmD)
	Local cSql:=""
	Local cUAliaSD4:=GetNextAlias()

	Default cProduto:=''
	Default cxLote:=''
	Default dvalid:=CtoD('//')
 	Default cArmD:=''

	//VALIDA SE O PRODUTO EXISTE NA SD4 DE ACORDO COM A ORDEM DE SEPARAÇÃO

	cSql := "SELECT SD4.D4_COD     PRODUTO "
	cSql += "     , SD4.D4_X_ORSEP   "
	cSql += "     , SD4.D4_LOCAL   ARMAZEM "
	cSql += "     , SD4.D4_OP      OP      "
	cSql += "     , SD4.D4_QUANT   EMPENHO "
	cSql += "     , SD4.D4_DATA    DATA    "
	cSql += "     , SD4.D4_X_LOTE  LOTE    "
	cSql += "     , SB1.B1_RASTRO  RASTRO "
//	cSql += "     , SB1.B1_LOCALIZ LOCALIZ "
	cSql += "     , SD4.R_E_C_N_O_ RECNOD4 "                                    
//	cSql += "     , COALESCE( X.DC_QTDORIG, 0 ) EMPENDER " // TOTAL JA EMPENHADO NOS ENDERECOS ( SBF )
	cSql += "  FROM " + RetSqlName("SD4") + " SD4 "
	cSql += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
	cSql += "                      AND SB1.B1_COD = SD4.D4_COD "
	cSql += "                      AND ( SB1.B1_RASTRO = 'L' OR SB1.B1_LOCALIZ = 'S' ) "
	cSql += "   WHERE SD4.D4_FILIAL   =  '" + xFilial("SD4") + "' "
	cSql += "     AND SD4.D_E_L_E_T_  =  ' ' "
	cSql += "     AND SD4.D4_X_ORSEP  =  '" + cOrdSep  + "' "
//	cSql += "     AND SD4.D4_LOTECTL  =  ' ' "
	cSql += "     AND SD4.D4_COD      =  '" + cProduto + "' "
	cSql += "     AND SD4.D4_LOCAL    =  '" + cArmD  + "' "
	cSql += "     AND SD4.D4_X_LOTE   =  '" + cxLote    + "' "
	dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql),cUAliaSD4,.F.,.T.)

	VTALERT("Ajustando empenhos","Aviso",.T.,4000,3)

	While (cUAliaSD4)->(! Eof())                            
	
//		IncProc("Ajustando empenhos")
	
		If (cUAliaSD4)->RASTRO == "L"
			//-------------------------------------
			// trata os produtos que controlam lote
			//-------------------------------------
			TrataLote( (cUAliaSD4)->PRODUTO, (cUAliaSD4)->ARMAZEM, (cUAliaSD4)->EMPENHO, (cUAliaSD4)->EMPENHO /*(cUAliaSD4)->EMPENDER*/, (cUAliaSD4)->OP, (cUAliaSD4)->RECNOD4 , cxLote)
		Else
			
			//----------------------------------------------------------------------
			// Se a quantidade empenhada no SD4 (Campo EMPENHO) for a mesma do SDC
			// (Campo EMPENDER), não precisa fazer mais nada.
			//----------------------------------------------------------------------
/*			IF (cUAliaSD4)->EMPENDER >= (cUAliaSD4)->EMPENHO
				dbSelectArea( cUAliaSD4 )
				dbSkip()
			    Loop
			EndIf   
*/	
			//-------------------------------------
			// trata os produtos que controlam  
			// somente endereço
			//-------------------------------------
			TrataEnd( (cUAliaSD4)->PRODUTO, (cUAliaSD4)->ARMAZEM, (cUAliaSD4)->EMPENHO, (cUAliaSD4)->EMPENHO/*(cUAliaSD4)->EMPENDER*/, (cUAliaSD4)->OP, (cUAliaSD4)->RECNOD4, cxLote )
		EndIf
	     
		dbSelectArea( cUAliaSD4 )
		(cUAliaSD4)->(dbSkip())
	Enddo       
	 
	(cUAliaSD4)->(dbCloseArea())
	VTALERT("Empenhos Ajustados com Sucesso","Aviso",.T.,4000,3)

Return( nil )   
    



//***********************************************************************************************************
// Rotina para tratar os Lotes - Alessandro e Antonio(Aproveitando rotina feira pelo Ale)
//***********************************************************************************************************
Static Function TrataLote( cPrd, cArm1, nEmpenho, nEmpEnder, cOP, nRecno, cxLote ) 

Local aEmpenho   := {}
Local cSql       := ""
Local cAliasB8   := GetNextAlias()                 
Local aArea      := GetArea()
Local nSoma      := 0
Local cTRT       := ""           
Local aVetor     := {}
Local nX         := 0
Local cUNAliaSD4 := GetNextAlias()
Local cASD4ZZP   := GetNextAlias()
Local _cXQtdEmp                      
Local lAtuStaZZP := .T.    //'S'

//cArm:='LE' //Este Armazem vem default da query que está buscando do armazem da Lectra
//cArm1:='01'  //so para teste, buscar o B1_LOCPAD (ARMAZEM PADRAO DO PRODUTO)
		
//Private lMsErroAuto := .F.

dbSelectArea("SD4")
dbGoTo(nRecno)      

cSql += "SELECT SB8.B8_PRODUTO "
cSql += "     , SB8.B8_LOCAL "
cSql += "     , SB8.B8_DATA "
cSql += "     , SB8.B8_DTVALID "
cSql += "     , SB8.B8_SALDO - SB8.B8_EMPENHO B8_LIVRE "
cSql += "     , SB8.B8_LOTECTL "
cSql += "     , SB8.R_E_C_N_O_ RECNOB8 "                                    
cSql += "  FROM "+RetSqlName("SB8")+" SB8 "
cSql += " WHERE SB8.B8_FILIAL = '"+xFilial("SB8")+"' "
cSql += "   AND SB8.B8_PRODUTO = '" +cPrd+ "' "
cSql += "   AND SB8.B8_SALDO - SB8.B8_EMPENHO > 0 "
cSql += "   AND SB8.B8_LOCAL = '"+cArm1+"' "
cSql += "   AND SB8.B8_LOTECTL = '" +cxLote+ "' "
cSql += "   AND SB8.B8_DTVALID >= '"+DtoS(dDataBase)+"' "
cSql += "   AND SB8.D_E_L_E_T_ = ' ' "
cSql += " ORDER BY SB8.B8_DTVALID, SB8.B8_LOTECTL "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasB8,.f.,.t.) 	
dbGoTop()

While (cAliasB8)->(! Eof())
	
	If (cAliasB8)->B8_LIVRE <= ( nEmpenho - nSoma )
		//------------------------------------------
		// Se tem menos estoque livre no lote do que
		// o necessário para o empenho
		//------------------------------------------
		nSoma += (cAliasB8)->B8_LIVRE
		AAdd( aEmpenho, { cPrd, cArm1, (cAliasB8)->B8_LOTECTL, (cAliasB8)->B8_LIVRE, (cAliasB8)->B8_DTVALID , RECNOB8} )   //Empenha no Armazem Padrao (B1_LOCPAD)
	Else
		//-----------------------------------------
		// Se tem mais estoque livre no lote do que
		// o necessário para o empenho
		//-----------------------------------------
		nSoma += (nEmpenho - nSoma)
		AAdd( aEmpenho, { cPrd, cArm1, (cAliasB8)->B8_LOTECTL, nSoma, (cAliasB8)->B8_DTVALID , RECNOB8} )   //Empenha no Armazem Padrao (B1_LOCPAD)
	EndIf                          
	
	//-----------------------------------------
	// Se alcançou a quantidade necessária 
	// para o empenho, sai do loop
	//-----------------------------------------
	If nSoma == nEmpenho
		Exit
	EndIf
	
	(cAliasB8)->(dbSkip())
	
Enddo

(cAliasB8)->(dbCloseArea())

RestArea( aArea )                 
     
//---------------------------------------
// Não será possível empenhar a 
// quantidade total necessária. Mantém
// os empenhos como estão
//---------------------------------------
If ( nSoma - nEmpenho ) <> 0
	Return( nil )
EndIf
                         
//---------------------------------------
// Apaga o empenho atual 
//---------------------------------------
dbSelectArea("SD4")
dbGoTo(nRecno)     
cTrt  := SD4->D4_TRT                                             
                              
cD4_X_ORSEP:=SD4->D4_X_ORSEP

For nX := 1 to Len( aEmpenho ) 

 /*	If RECLOCK("SD4",.F.)
		SD4->D4_LOTECTL:=aEmpenho[nX,3]  
		SD4->D4_DTVALID:=StoD(aEmpenho[nX,5])
		MsUnlock()
	EndIf*/
  
	//gravar ZZP e ZZK
	 
  	cSql := " SELECT SD4.D4_COD      PRODUTO, " 
	cSql += "  	     SD4.D4_X_ORSEP  ORSEP  , "
	cSql += "        SD4.D4_X_LOTE   LOTE   , "                   //ALTERADO LOTE X XLOTE
	cSql += "  	     SUM(SD4.D4_QTDEORI)  EMPENHO  "
	cSql += "  FROM " + RetSqlName("SD4") + " SD4 "
	cSql += "   WHERE SD4.D4_FILIAL   =  '" + xFilial("SD4") + "' "
	cSql += "     AND SD4.D_E_L_E_T_  =  ' ' "
	cSql += "     AND SD4.D4_X_ORSEP  = '" + cD4_X_ORSEP + "' "
	cSql += "     AND SD4.D4_COD      = '" + cPrd        + "' "                                 
	cSql += "     AND SD4.D4_X_LOTE   = '" + aEmpenho[nX,3]  + "' "              //ALTERADO LOTE X XLOTE
	cSql += " GROUP BY SD4.D4_COD, SD4.D4_X_ORSEP, SD4.D4_X_LOTE "              //
	cSql += " ORDER BY SD4.D4_COD, SD4.D4_X_ORSEP, SD4.D4_X_LOTE "              //
	dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql),cUNAliaSD4,.F.,.T.)

	While (cUNAliaSD4)->(! Eof())                            

        If Empty((cUNAliaSD4)->LOTE)
			_cXQtdEmp:=(cUNAliaSD4)->EMPENHO
		   	Exit//0002347976 
		Else
			_cXQtdEmp:=(cUNAliaSD4)->EMPENHO
		EndIf        

		(cUNAliaSD4)->(dbSkip())

	Enddo       
	 
	(cUNAliaSD4)->(dbCloseArea())

	ZZK->(dbSetOrder(1))            //OS+ITEM+PRODUTO+LOTE
	IF ZZK->(dbSeek(xFilial("ZZK")+cD4_X_ORSEP+'001'+AllTrim(cPrd)+aEmpenho[nX,3] ))

		RecLock("ZZK",.F.)
//		ZZK->ZZK_QTDSEP += _cXQtdEmp
		ZZK->ZZK_QTDSEP := _cXQtdEmp
		ZZK->ZZK_STATUS := IIf(ZZK->ZZK_QTDSEP >= ZZK->ZZK_QTDORI, 'E' /*Encerrado*/, 'P' /*Parcial*/)        
		MsUnlock()

	EndIf	

Next

lAtuStaZZP := .T.   //'S'
/*
cSql := "SELECT SD4.D4_COD     "
cSql += "     , SD4.D4_X_ORSEP "
cSql += "     , SD4.D4_X_LOTE "                     //ALTERADO LOTE X XLOTE
cSql += "     , SC2.C2_OPMIDO  "
cSql += "     , SUM(SD4.D4_QUANT)   EMPENHO "
cSql += "     , SUM(SD4.D4_QTDEORI) ORIGEM  "
cSql += "  FROM " + RetSqlName("SD4") + " SD4 "
cSql += " 	JOIN " + RetSqlName("SC2") + " SC2 "
cSql += "		     ON  SC2.C2_NUM     = SUBSTRING(SD4.D4_OP,1,6) "
cSql += "		     AND SC2.C2_FILIAL  = '" + xFilial("SC2") + "' 
cSql += "		     AND SC2.D_E_L_E_T_ = ' ' "
cSql += "   JOIN " + RetSqlName("SB1") + " SB1 "
cSql += "		     ON   SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
cSql += "            AND  SB1.B1_COD    = SD4.D4_COD "
cSql += "            AND (SB1.B1_RASTRO = 'L' OR SB1.B1_LOCALIZ = 'S' ) "
cSql += "   WHERE SD4.D4_FILIAL   =  '" + xFilial("SD4") + "' "
cSql += "     AND SD4.D_E_L_E_T_  =  ' ' "
cSql += "     AND SD4.D4_X_ORSEP  =  '" + cD4_X_ORSEP  + "' "
cSql += "     AND  SC2.C2_OPMIDO <> ' ' "
cSql += "GROUP BY SD4.D4_COD     "
cSql += "       , SD4.D4_X_ORSEP "
cSql += "       , SD4.D4_X_LOTE "                    //ALTERADO L X X
cSql += "       , SC2.C2_OPMIDO  "
cSql += "ORDER BY SD4.D4_COD     "
dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql),cASD4ZZP,.F.,.T.)

While (cASD4ZZP)->(! Eof())     //verificar se na D4, as Ordem de separação estão todas atendidas para gravar na ZZP o Status='E'ncerrada                       

	If Empty((cASD4ZZP)->D4_X_LOTE) .OR. (cASD4ZZP)->EMPENHO <> (cASD4ZZP)->ORIGEM                //ALTERADO LOTE CTL
		lAtuStaZZP := .F. //'N'
	EndIf
	(cASD4ZZP)->(dbSkip())

Enddo       

(cASD4ZZP)->(dbCloseArea())
*/                               //antonio- estava fazendo via d4, mas o certo é fazer via ZZK/ZZP 23/01/18

cSql := "SELECT ZZK.ZZK_ORDSEP "
cSql += "     , ZZK.ZZK_QTDSEP "
cSql += "     , ZZK.ZZK_STATUS "
cSql += "  FROM " + RetSqlName("ZZK") + " ZZK "
cSql += "   WHERE ZZK.ZZK_FILIAL  =  '" + xFilial("ZZK") + "' "
cSql += "     AND ZZK.D_E_L_E_T_  =  ' ' "
cSql += "     AND ZZK.ZZK_ORDSEP  =  '" + cD4_X_ORSEP  + "' "
dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql),cASD4ZZP,.F.,.T.)

While (cASD4ZZP)->(! Eof())     //verificar se na ZZK, as Ordem de separação estão todas atendidas para gravar na ZZP o Status='E'ncerrada                       

	If (cASD4ZZP)->ZZK_STATUS <> 'E'
		lAtuStaZZP := .F. //'N'
	EndIf
	(cASD4ZZP)->(dbSkip())

Enddo       

(cASD4ZZP)->(dbCloseArea())



If lAtuStaZZP                 // Gravar na Ordem de separação estão todas atendidas para gravar na ZZP o Status='E'ncerrada                       

	If ZZP->(DbSeek(xFilial("ZZP")+cD4_X_ORSEP ))
		RecLock("ZZP",.F.)
		ZZP->ZZP_STATUS  := 'E'
		MsUnlock()
	EndIf
EndIf

/*For nX := 1 to Len( aEmpenho )         //AJUSTA O EMPENHO DA SB8          (RETIRAMOS AJUSTE DE EMPENHO DA SB8, POIS COM O NOVO PROCESSO NÃO 
	dbSelectArea("SB8")                  //                                  VAI MAIS ATUALIZAR ANTONIO 23/01/18)
	dbGoTo(aEmpenho[nX,6])
	
	RECLOCK("SB8",.F.)
	SB8->B8_EMPENHO:=SB8->B8_EMPENHO+aEmpenho[nX,4]  
	MsUnlock()
Next nX                    */

//// AJUSTAR EMPENHO DA SB2
/* Comentado por Diego em 28/10/17 - Empenhos na SB2 sao gerados quando gera OP
For nX := 1 to Len( aEmpenho )         //AJUSTA O EMPENHO DA SB2
	SB2->(dbSetOrder(1))
	IF SB2->(dbSeek(xFilial("SB2")+aEmpenho[nX,1]+aEmpenho[nX,2] ))
		RECLOCK("SB2",.F.)
		SB2->B2_QEMP:=SB2->B2_QEMP+aEmpenho[nX,4]  
		MsUnlock()
	EndIf
Next nX
*/
	 
Return( nil )



//***********************************************************************************************************
//Rotina para tratar endereçamentos - Alessandro Freire
//***********************************************************************************************************
Static Function TrataEnd( cPrd, cArm, nEmpenho, nEmpEnder, cOP, nRecno )
                                               
Local aEmpenho := {}
Local cSql     := ""
Local cAliasBF := GetNextAlias()                 
Local aArea    := GetArea()
Local nSoma    := 0
Local cTRT     := ""           
Local aVetor   := {}
Local nX       := 0

cSql += "SELECT SBF.BF_PRODUTO "
cSql += "     , SBF.BF_LOCAL "
cSql += "     , SBF.BF_LOCALIZ "
cSql += "     , SUM( SBF.BF_QUANT - SBF.BF_EMPENHO ) BF_LIVRE "
cSql += "  FROM "+RetSqlName("SBF")+" SBF "
cSql += " WHERE SBF.BF_FILIAL = '"+xFilial("SBF")+"' "
cSql += "   AND SBF.BF_PRODUTO = '"+cPrd+"' "
cSql += "   AND SBF.BF_LOCAL = '"+cArm+"' "                            //Verificar se está no armazem correto
cSql += "   AND SBF.D_E_L_E_T_ = ' ' "
cSql += " GROUP BY SBF.BF_PRODUTO "
cSql += "     , SBF.BF_LOCAL "
cSql += "     , SBF.BF_LOCALIZ "
cSql += "HAVING SUM( SBF.BF_QUANT - SBF.BF_EMPENHO ) > 0 "
                                           
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasBF,.f.,.t.) 	
dbGoTop()

While (cAliasBF)->(! Eof())                                    

	If (cAliasBF)->BF_LIVRE <= ( nEmpenho - nSoma )
		//----------------------------------------------
		// Se tem menos estoque livre no endereço do que
		// o necessário para o empenho:
		// Pega todo o saldo livre do endereço
		//----------------------------------------------
		nSoma += (cAliasBF)->BF_LIVRE
		AAdd( aEmpenho, { (cAliasBF)->BF_LIVRE,;    // D4_QUANT
		                  (cAliasBF)->BF_LOCALIZ,;  // DC_LOCALIZ
		                   "",;                     // DC_NUMSERI
		                  0,;                       // D4_QTSEGUM
		                  .F.  } )
	Else
		//----------------------------------------------
		// Se tem mais estoque livre no endereço do que
		// o necessário para o empenho:
		// Pega somente o que falta empenhar, deixando
		// o resto do estoque livre.
		//----------------------------------------------
		nSoma += (nEmpenho - nSoma)
		AAdd( aEmpenho, { nSoma                 ,; // D4_QUANT
		                  (cAliasBF)->BF_LOCALIZ,; // DC_LOCALIZ
		                   ""                   ,; // DC_NUMSERI
		                  0                     ,; // D4_QTSEGUM
		                  .F.  } )
	EndIf                          
	
	//-----------------------------------------
	// Se alcançou a quantidade necessária 
	// para o empenho, sai do loop
	//-----------------------------------------
	If nSoma == nEmpenho
		Exit
	EndIf

	dbSelectArea(cAliasBF)
	dbSkip()
Enddo

(cAliasBF)->(dbCloseArea())

RestArea( aArea )                 
     
//---------------------------------------
// Não será possível empenhar a 
// quantidade total necessária. Mantém
// os empenhos como estão
//---------------------------------------
If ( nSoma - nEmpenho ) <> 0
	Return( nil )
EndIf
                         
//---------------------------------------
// Apaga o empenho atual. É necessário
// apagar o empenho atual para diminuir
// B2_QEMP. 
//---------------------------------------
dbSelectArea("SD4")
dbGoTo(nRecno)     

lMsErroAuto := .F.
 
aVetor:={   {"D4_COD"     ,SD4->D4_COD     ,Nil},; //COM O TAMANHO EXATO DO CAMPO
            {"D4_LOCAL"   ,SD4->D4_LOCAL   ,Nil},;
            {"D4_OP"      ,SD4->D4_OP      ,Nil},;
            {"D4_DATA"    ,SD4->D4_DATA    ,Nil},;
            {"D4_QTDEORI" ,SD4->D4_QTDEORI ,Nil},;
            {"D4_QUANT"   ,SD4->D4_QUANT   ,Nil},;
            {"D4_TRT"     ,SD4->D4_TRT     ,Nil},;
            {"D4_QTSEGUM" ,SD4->D4_QTSEGUM ,Nil}}
             
MSExecAuto({|x,y| mata380(x,y)},aVetor,5 ) 

//---------------------------------------
// Se não conseguiu apagar o empenho sem
// endereço, não continua a rotina
//---------------------------------------
If lMsErroAuto
    Alert("Erro ao excluir empenho por endereço")
    MostraErro()
    Return( nil )
EndIf
                              
lMsErroAuto := .F.
MSExecAuto({|x,y| mata380(x,y)},aVetor,3, aEmpenho ) 

If lMsErroAuto
    Alert("Erro ao incluir empenho por endereço")
    MostraErro()
EndIf

Return( nil )
                     

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A380ValLoc³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 14/02/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Se a Op ja teve producao, impede a mudanca de Local        ³±±
±±³          ³ e valida se o local nao e' invalido                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A380ValLoc()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA380,MATA381                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A380ValLoc()
Local aArea := GetArea()
Local cLocNew :=""
Local lRet:=.T.
Local c381LocD4 := "",cOPOrig := "",cOPEmp := "",cProd := ""
Local nQtde := 0

If l380
	cLocNew := &(ReadVar())
	cOPOrig := M->D4_OPORIG
	cOPEmp  := M->D4_OP
	cProd	:= M->D4_COD
	nQtde	:= M->D4_QUANT
ElseIf l381
	cLocNew := If(SubStr(ReadVar(),4,8)=='D4_LOCAL',M->D4_LOCAL,If(!Empty(nPosLocal),aCols[n,nPosLocal],UserException('D4_LOCAL')))
	If !Empty(aCols[n,Len(aHeader)]) //alteracao
		dbSelectArea("SD4")
		dbGoTo(aCols[n,Len(aHeader)])
		c381LocD4 := SD4->D4_LOCAL	
		cOPOrig := SD4->D4_OPORIG
	EndIf
	cOPEmp  := cOP
	cProd 	:= aCols[n,nPosCod]
	nQtde	:= aCols[n,nPosQuant]
EndIf

If !ExistCpo("SB2",cProd+cLocNew)
	lRet := .F.
EndIf

// verifica Local de processo
If lRet
	ValLocProc(cLocNew)
EndIf

If cLocNew == GETMV("MV_CQ")
	lRet:=.F.
EndIf

If lRet .And. cLocNew != If(l380,cLocal,c381LocD4) .And. If(l380,cLocal,c381LocD4) != CriaVar("D4_LOCAL")
	If !Empty(cOPOrig)
		dbSelectArea("SC2")
		If dbSeek(xFilial("SC2")+cOPOrig) .And. SC2->C2_QUJE > 0
			Help(" ",1,"A380OPPROD")
			lRet:=.F.
		EndIf
	Else
		dbSelectArea("SC1")
		dbSetOrder(4)
		If dbSeek(xFilial("SC1")+cOPEmp)
			Do While !Eof() .And. SC1->C1_FILIAL+SC1->C1_OP == xFilial("SC1")+cOPEmp
				If SC1->C1_PRODUTO == cProd .And. SC1->C1_QUANT == nQtde .And. SC1->C1_QUJE > 0
					Help(" ",1,"A380SCCOMP")
					lRet:=.F.
					Exit
				EndIf
				dbSkip()
			EndDo
		EndIf
	EndIf
EndIf

RestArea(aArea)
Return lRet
