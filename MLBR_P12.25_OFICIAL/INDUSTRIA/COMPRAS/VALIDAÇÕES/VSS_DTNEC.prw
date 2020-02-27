#include 'RWMAKE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VSS_DTNEC ºAutor  ³ Vinicius Schwartz  º Data ³  04/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para tratar prazo de necessidade a partir do campo   º±±
±±º          ³B1_PE do produto ref. ao fornecedor.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso.      ³Função onde será carregada ao ser informado a data no campo º±±
±±º          ³C1_DATPRF validando se o prazo de necessidade nao eh menor  º±±
±±º          ³que o prazo estipulado pelo fornecedor.		              º±±
±±º          ³Ref. ao HDI 004598                                          º±±
±±º          ³Solic. MARCIA DE C OLIVEIRA KOBAYASHI (Compras)             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VSS_DTNEC()
Local lRet := .T.   
Local nPrz

nPosProd   :=aScan(aHeader,{|x| AllTrim(x[2])=="C1_PRODUTO"}) 

//Valida se data da necessidade eh >= ao prazo do fornecedor
//Alert ('Produto: '+Acols[N,nPosProd])

DbSelectArea('SB1')
DbSetOrder(1)
DbSeek(xFilial('SB1') + Acols[N,nPosProd])

If(SB1->B1_PE <> 0)
	If (M->C1_DATPRF >= (dDatabase + SB1->B1_PE))
		lRet := .T.
	Else 
		MsgStop("Data Informada Menor que a Data Prazo do Fornecedor que é de "+cValToChar(SB1->B1_PE)+" dias.","Atenção")
		lRet := .F.
	Endif
EndIf

Return(lRet)