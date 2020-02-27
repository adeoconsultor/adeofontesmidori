#INCLUDE "EEC.CH"

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midoria Atlantica
//|Funcao....: U_EECAP100()
//|Autor.....: Armando M. Urzum - armando.u@uol.com.br
//|Data......: 11 de Janeiro de 2010, 08:00
//|Uso.......: SIGAEEC
//|Versao....: Protheus - 10        `
//|Descricao.: PE referente ao Pedido de Exportação.
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function EECAP100()
*-----------------------------------------*

Local cParamIXB                 	
Local aAreaEE8 := GetArea()
Local aAreaSC6 := GetArea()
Local nTipo    := 0

Local nItPl    := 0              // somatoria da quantidade de itens (1,2,3 ... n Itens)
Local nFatConv := 0              // fator de conversao, sera gravado na SB5   (B5_CONVDIP)
Local nPesLiq  := 0              // Peso Liquido Total
Local nTotPec  := 0              // Valor total de peças
Local cItem,hj    := 0                                                                
Local cGrupo   := "" 

If Type("PARAMIXB") = "A"
   cParamIXB := PARAMIXB[1]
ElseIf Type("PARAMIXB") = "C"
    cParamIXB := PARAMIXB
EndIf

Do Case

	Case cParamIXB == "DETMAN_ANTES_DIALOG"  
	
	//lEE8Auto := .t.
	
		If !ALTERA
			Return
		EndIf
		If Len(axDadRom) = 0
			Return
		EndIf    

		EE2->(dbSetOrder(1))
	
		M->EE8_COD_I  := axItRoma[nxCouRom,3] 
		M->EE8_EMBAL1 := Posicione("SB1",1,xFilial("SB1")+M->EE8_COD_I,"B1_CODEMB")
		M->EE8_EMBAL1 := Iif(Empty(M->EE8_EMBAL1),axDadRom[3],M->EE8_EMBAL1)
		M->EE8_UNIDAD := Posicione("SB1",1,xFilial("SB1")+M->EE8_COD_I,"B1_UM")
		M->EE8_POSIPI := Posicione("SB1",1,xFilial("SB1")+M->EE8_COD_I,"B1_POSIPI")
		M->EE8_DESC   := IiF(EECPPE07("CALCEMB"),M->EE8_DESC,M->EE8_DESC)
		M->EE8_DESC   := IiF(AP100PrecoI(),M->EE8_DESC,M->EE8_DESC)
		M->EE8_PRECO  := Posicione("SA5",1,xFilial("SA5")+M->EE8_FORN+M->EE8_FOLOJA+M->EE8_COD_I,"A5_VLCOTUS")
		M->EE8_PART_N := Posicione("SA5",1,xFilial("SA5")+M->EE8_FORN+M->EE8_FOLOJA+M->EE8_COD_I,"A5_CODPRF")
		M->EE8_FABR   := Posicione("SA5",1,xFilial("SA5")+M->EE8_FORN+M->EE8_FOLOJA+M->EE8_COD_I,"A5_FABR")
		M->EE8_FALOJA := Posicione("SA5",1,xFilial("SA5")+M->EE8_FORN+M->EE8_FOLOJA+M->EE8_COD_I,"A5_FALOJA")
		M->EE8_PRECO  := TABPRECO(M->EE8_PRECO,M->EE8_COD_I,"",M->EE7_IMPORT+M->EE7_IMLOJA,M->EE7_MOEDA)
		M->EE8_CODNOR := Posicione("EXN",1,xFilial("EXN")+M->EE8_COD_I+M->EE7_PAISET,"EXN_NORMA")
		M->EE8_VM_NOR := Iif(!Empty(M->EE8_CODNOR),MSMM(Posicione("EEI",1,xFilial("EEI")+M->EE8_CODNOR,"EEI_DESC"),60,1),"")

		M->EE8_TES    := axDadRom[1]
		M->EE8_CF     := axDadRom[2]
		M->EE8_SLDINI := axItRoma[nxCouRom,6]
		M->EE8_QE     := M->EE8_SLDINI
		M->EE8_SLDATU := M->EE8_SLDINI		
		M->EE8_QTDEM1 := axItRoma[nxCouRom,8]		
		M->EE8_PSLQUN := axItRoma[nxCouRom,5]/axItRoma[nxCouRom,6]
		M->EE8_PSLQTO := axItRoma[nxCouRom,5]		
		M->EE8_PSBRUN := axItRoma[nxCouRom,4]/axItRoma[nxCouRom,6]
		M->EE8_PSBRTO := axItRoma[nxCouRom,4]		
		M->EE8_QTDCLI := M->EE8_SLDINI/2
		M->EE8_QTDLIM := M->EE8_SLDINI/2
		M->EE8_XITROM := "S"

		If EE2->(dbSeek(xFilial()+MC_CPRO+TM_GER+M->EE7_IDIOMA+AVKEY(M->EE8_COD_I,"EE2_COD")))
			M->EE8_VM_DES := MSMM(EE2->EE2_TEXTO,AVSX3("EE2_VM_TEX")[AV_TAMANHO])
		Else
			M->EE8_VM_DES := Posicione("SB1",1,xFilial("SB1")+M->EE8_COD_I,"B1_DESC")
		Endif
		
		axRoma[Len(axRoma),2] := M->EE8_SEQUEN
        
	Case cParamIXB == "PE_GRV"    
		If !ALTERA
			Return
		EndIf
        If Len(axRoma) > 0
        	ZZB->(dbSetOrder(2))
        	For hj := 1 To Len(axRoma)
        		If ZZB->(dbSeek(xFilial("ZZB")+M->EE7_PEDIDO+axRoma[hj,1]))
        	    	While ZZB->(!EOF()) .AND. ZZB->(ZZB_FILIAL+ZZB_PEDIDO+ZZB_COD_I) == (xFilial("ZZB")+M->EE7_PEDIDO+axRoma[hj,1])						
						ZZB->(RecLock("ZZB",.F.))
						ZZB->ZZB_USADO := axRoma[hj,2]
						ZZB->(MsUnLock())   
						ZZB->(dbSkip())
					EndDo				
				EndIf
        	Next
        EndIf
		RestArea(aAreaEE8)
		
	Case cParamIXB == "PE_GRVDET"
		If !ALTERA
			Return
		EndIf
 		If Len(axDadRom) > 0
 			nOpcA := 0
 		EndIf
 		
//	Case cParamIXB == "DEL_WORKIT"
//		Public aEE8Bkp := aClone(aEE8CamposEditaveis)
//		Public aItemBkp:= aClone(aItemEnchoice)        
//		Private cSLDINI := WorkIT->EE8_SLDINI
		

	Case cParamIXB == "ESTORNO_PEDIDO"		
		ZZA->(dbSetOrder(1))
		ZZB->(dbSetOrder(1))

		If ZZA->(dbSeek(xFilial("ZZA")+EE7->EE7_PEDIDO))
			While ZZA->(!EOF()) .AND. (xFilial("ZZA")+ZZA->ZZA_PEDIDO)==(EE7->EE7_FILIAL+EE7->EE7_PEDIDO)
				ZZA->(RecLock("ZZA",.F.))
				ZZA->(dbDelete())
				ZZA->(MsUnLock())
				ZZA->(dbSkip())
			EndDo
		EndIf

		If ZZB->(dbSeek(xFilial("ZZB")+EE7->EE7_PEDIDO))
			While ZZB->(!EOF()) .AND. (xFilial("ZZB")+ZZB->ZZB_PEDIDO)==(EE7->EE7_FILIAL+EE7->EE7_PEDIDO)
				ZZB->(RecLock("ZZB",.F.))
				ZZB->(dbDelete())
				ZZB->(MsUnLock())
				ZZB->(dbSkip())
			EndDo
		EndIf

	Case cParamIXB == "GRV_PED"                     //inclusão após a gravação do pedido de exportação e pedido do protheus - Antonio
                    
		dbSelectArea("SC6")
		dbSetOrder(1) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO  		
		cGrupo := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_GRUPO")    
		 		
		If dbSeek(xFilial("SC6")+EE7->EE7_PEDFAT )
			While !SC6->(Eof()) .And. SC6->C6_NUM == EE7->EE7_PEDFAT
				nTotPec := nTotPec + SC6->C6_QTDVEN

				cItem:=Alltrim(Str(Val(SC6->C6_ITEM)))
				cItem:=IIf(Len(cItem)=1,'     '+cItem, '    '+cItem)

				dbSelectArea("EE8")
				dbSetOrder(1) //EE8_FILIAL+EE8_PEDIDO+EE8_SEQUEN+EE8_COD_I
				If dbSeek(xFilial("EE8")+EE7->EE7_PEDIDO+cItem+SC6->C6_PRODUTO ) 
			
					RecLock("SC6",.F.)
					SC6->C6_CCUSTO := EE8->EE8_CCUSTO
					SC6->C6_QTDVQ  := EE8->EE8_QTDVQ
					SC6->C6_LOTECTL:= EE8->EE8_LOTECT
					SC6->C6_LOCAL  := EE8->EE8_X_LOCA   
	
					MsUnLock("SC6")

				EndIf

				SC6->(dbSkip())

			EndDo
		EndIf

		dbSelectArea("SC5")
		dbSetOrder(1) //C5_FILIAL+C5_NUM
		If dbSeek(xFilial("SC5")+EE7->EE7_PEDFAT  )

			nFatConv := EE7->EE7_PESLIQ/nTotPec
			nFatConv := STR(nFatConv, 12, 4)
			nFatConv := Val(nFatConv)
          
          			
			dbSelectArea("SB5")
			dbSetOrder(1) //B5_FILIAL+B5_COD
			
			// Valida se é produto exportacao com UM DIPI
			// Diego - adicionado para correcao erro impressao Danfe 01/10/18
			If dbSeek(xFilial("SB5")+SC6->C6_PRODUTO )
			    If !empty(SB5->B5_UMDIPI) .And. SB5->B5_UMDIPI $ 'KG'    
					nPesLiq:=nFatConv*nTotPec   
				Else
					nPesLiq:=EE7->EE7_PESLIQ 
				Endif
            Endif                 
            
             //ver para incluir a gravacao do peso liquido na SC5
			RecLock("SC5",.F.)
			SC5->C5_PESOL   := nPesLiq 
			SC5->C5_TRANSP  := EE7->EE7_XTRANS
			SC5->C5_X_VEIC  := EE7->EE7_XPLACA
			SC5->C5_X_UFV   := EE7->EE7_XUFV
	 		SC5->C5_MENNOTA := EE7->EE7_XMENOT
			MsUnLock("SC5")
		EndIf

		If !Empty(nPesLiq)                     //ja esta posicionado na EE7
			RecLock("EE7",.F.)
			EE7->EE7_PESLIQ := nPesLiq
			MsUnLock("EE7")
		EndIf

		dbSelectArea("SC6")
		dbSetOrder(1) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
		dbGoTop()                                                 //PELO FATO DE RODAR O SEEK NA SC6 NO BLOCO ACIMA, VOLTA NO INICIO DO ARQUIVO
		If dbSeek(xFilial("SC6")+EE7->EE7_PEDFAT )

			While !SC6->(Eof()) .And. (SC6->C6_NUM == EE7->EE7_PEDFAT) .And. (xFilial("SC6") == SC6->C6_FILIAL )

				dbSelectArea("SB5")
				dbSetOrder(1) //B5_FILIAL+B5_COD
				If dbSeek(xFilial("SB5")+SC6->C6_PRODUTO )
					
					// Valida se é produto exportacao com UM DIPI
					// Diego - adicionado para correcao erro impressao Danfe 01/10/18
					If !empty(SB5->B5_UMDIPI) .And. SB5->B5_UMDIPI $ 'KG'    
						If RecLock("SB5",.F.)
							SB5->B5_CONVDIP := nFatConv
							MsUnLock("SB5")
						Else
							MsgAlert("Não foi possível gravar o campo de conversão (B5_CONVDIP) para o produto: " + SC6->C6_PRODUTO + ", informe o valor (" + Transform(nFatConv,"@E 999,999.99") + ") no campo!")
						EndIf  
					Endif
				Else
					MsgAlert("Não foi possível gravar o campo de conversão (B5_CONVDIP) para o produto: " + SC6->C6_PRODUTO + ", informe o valor (" + Transform(nFatConv,"@E 999,999.99") + ") no campo!")
				EndIf				

				SC6->(dbSkip())
			EndDo
		Else
			MsgAlert("Não foi possível gravar o campo de conversão (B5_CONVDIP) para o produto: " + SC6->C6_PRODUTO + ", informe o valor (" + Transform(nFatConv,"@E 999,999.99") + ") no campo!")
		EndIf
End Case

Return(Nil)

//Função para adicionar menu no Browse 
user function IAP100MNU()
local aRot := {}

	AADD(aRot, { "IMP.FECH.CAMBIO","U_FECHCAMB",0,nil})
 
Return aRot
//Fim da Rotina de Adicionar Menu no Browse
 
  
