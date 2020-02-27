#INCLUDE "Average.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EICPO400 º Autor ³Robson Sanchez      º Data ³  06/07/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ TRATAMENTO E INCLUSAO DA IMPRESSAO DO PO EM CRYSTAL        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ IMPORTACAO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: U_EICPO400()
//|Autor.....: Robson Luiz Sanchez Dias
//|Data......: 06 de Julho de 2009
//|Uso.......: SIGAEIC
//|Versao....: Protheus - 10.1
//|Descricao.: Contem todos pontos de entradas do EICPO400 e funcoes para tratamento da PO de Importacao
//|Observação:
//------------------------------------------------------------------------------------//

*-----------------------------*
User Function EICPO400()
*-----------------------------*

/*
If ParamIxb == "AROTINA"
//  Aadd(aRotina,{ "Imprime PO","U_POCRYSTAL" , 0 , 2 })
Endif
*/


If ParamIxb == "ANTES_GRAVAR"    // Ponto de Entrada chamado -  apos a gravacao do PO e do Pedido de Compras
	sc7->(dbsetorder(1))
	
	SC7->(dbseek(xFilial('SC7')+SW2->W2_PO_SIGA))
	While ! sc7->(eof()) .and. sc7->c7_filial == xFilial('SC7') .and. sc7->c7_num = sw2->w2_po_siga
		sc7->(reclock("SC7",.f.))
		sc7->c7_conapro:= "B"
		sc7->(MsUnlock())
		sc7->(dbskip())
	End
	
	cGrAprov := ''
	SY1->(dbSetOrder(1))
	IF SY1->(DbSeek(xFilial("SY1")+SW2->W2_COMPRA)) .And. !Empty(SY1->Y1_GRAPROV)
		cGrAprov := SY1->Y1_GRAPROV
	ENDIF
	
	
	sw2->(reclock("SW2",.f.))
	
	// EOS - Pegar moeda correspondente ao SIGACOM
	SW2->W2_CONAPRO:=Space(Len(SW2->W2_CONAPRO))
	SYF->(dbSetOrder(1))
	IF SYF->(dbSeek(xFilial("SYF") + SW2->W2_MOEDA))
		nMoe_Com := SYF->YF_MOEFAT
	ENDIF
	MaAlcDoc({SW2->W2_PO_SIGA,"PC",SW2->W2_FOB_TOT,,,cGrAprov,,nMoe_Com,,SW2->W2_PO_DT},,3)
	lLiberado:=MaAlcDoc({SW2->W2_PO_SIGA,"PC",SW2->W2_FOB_TOT,,,cGrAprov,,nMoe_Com,,SW2->W2_PO_DT},,1)
	SW2->W2_CONAPRO:=If(lLiberado,"L","B")
	SW2->(MsUnlock())
Endif

Return


User Function IPO400MNU

Local aRotina:={}

Aadd(aRotina,{ "Imprime PO","U_POCRYSTAL" , 0 , 2 })

Return aRotina
