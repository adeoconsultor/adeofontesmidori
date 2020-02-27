#include "totvs.ch"
//====================================================================================]
// AV120Fim()  -  Alessandro Freire - Outubro / 2015
//------------------------------------------------------------------------------------
// Descrição
// Verifica se pode ou não encerrar a conferência da nota fiscal - ACD
// Ponto ocorre na confirmação do encerramento da conferência da nota fiscal no
// coletor
//------------------------------------------------------------------------------------
//
//====================================================================================]

User Function AV120FIM()

Local cNota   := ParamIxb[1]
Local cSerie  := ParamIxb[2]
Local cFornec := ParamIxb[3]
Local cLoja   := ParamIxb[4]

Local lRet := .t.

dbSelectArea("SF1")
SF1->(dbSetOrder(1))
If SF1->(dbSeek(xFilial("SF1")+cNota+cSerie+cFornec+cLoja))
	dbSelectArea("SD1")
	SD1->(dbSetOrder(1))
	If SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
		While ! SD1->(Eof()) .and. xFilial("SD1") == D1_FILIAL .and.;
			SD1->D1_DOC == SF1->F1_DOC .and. SD1->D1_SERIE == SF1->F1_SERIE .and. SD1->D1_FORNECE == SF1->F1_FORNECE .and.;
			SD1->D1_LOJA == SF1->F1_LOJA
                                                
			//--------------------------------------------------
			// Marca o item como conferido caso o produto 
			// não tenha necessidade de impressão de etiquetas  
			//--------------------------------------------------
			//SB1->(dbSetOrder(1))
			//SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
			//If SB1->B1_ZZIMPET <> "S"
			SBZ->(dbSetOrder(1))
			SBZ->(dbSeek(xFilial("SBZ")+SD1->D1_COD))
			If SBZ->BZ_ZZIMPET <> "S"
				RecLock("SD1",.F.)
				SD1->D1_QTDCONF := SD1->D1_QUANT
				MsUnlock()
			EndIf
			
			If SD1->D1_QUANT > SD1->D1_QTDCONF //Divergente
				lRet := .f.                     
				VTAlert("Nota com divergencia nao pode ser encerrada","Atencao",.T.,4000)
				Exit
			EndIf
			SD1->(dbSkip())
		EndDo
	EndIf
EndIf
Return( lRet )
