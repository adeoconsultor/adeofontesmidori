#include "Protheus.ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT140TOK ºAutor  ³ Antonio            º Data ³  29/08/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Programa para ajustar lotes no caso de pedido de compras que º±±
±±ºDesc.     ³ nao atualiza quando busca via F5                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico MIDORI ATLANTICA INDUSTRIAL                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT140TOK()

Local nPosDVL	:= Ascan(aHeader,{|x|Alltrim(x[2]) == "D1_DTVALID"})           //ANTONIO
Local nPosLote	:= Ascan(aHeader,{|x|Alltrim(x[2]) == "D1_LOTECTL"})           //ANTONIO 29/08/17
Local cProduto	:= Ascan(aHeader,{|x|Alltrim(x[2]) == "D1_COD"})               //ANTONIO 29/08/17  
Local cGrupo
Local cDescProd	
Local _cEmlFor
Local aItens   := {}
                                                    
Local _lRet     := .T.
Local _aArea     := GetArea()
Local nI, _i

If Inclui .Or. Altera

		// Validacao dos itens da pre-nota de entrada 
		// para envio Workflow
		// U_145ENVMAIL - Diego Mafisolli 21/11/17 
		_cEmlFor := GetMv ('MA_EMAIL06')+",diego.mafisolli@midoriautoleather.com.br"

		For nI := 1 to Len(aCols)
		
			cGrupo     := Posicione("SB1", 1, xFilial("SB1") + aCols[nI,cProduto], "B1_GRUPO")
			cDescProd  := Posicione("SB1", 1, xFilial("SB1") + aCols[nI,cProduto], "B1_DESC")

			If Alltrim(cGrupo) $ '90'   
				aAdd(aItens,{aCols[nI,cProduto], cDescProd, cGrupo})		
			EndIf
		Next
	
		If Len(aItens) > 0
			U_145ENVMAIL(aItens,_cEmlFor,cNFiscal,cA100For+'-'+cLoja,"", "<Pre-Nota Entrada>")
		EndIf     
    /*
     * U_145ENVMAIL
     */
	                                                             
	
	// Somente Valida Notas Normais e De Beneficiamento na Filial 08 PNP2
	If Upper(Alltrim(cTipo)) $ "N|B" .AND. xFilial("SD1") $ '08|19'
		
		//	Executa Varredura No aCols
		For _i := 1 To Len(aCols)

			SB1->(dbSetOrder(1)) // B1_FILIAL + B1_COD
			If SB1->(dbSeek(xFilial("SB1") + aCols[_i, cProduto] )) 
			
				If AllTrim(SB1->B1_GRUPO) == '16' .And. AllTrim(SB1->B1_RASTRO) == 'L'
					// Verifica Linha Ativa
					If !GdDeleted(_i)
					
						If _lRet  //ajusta data de validade do lote caso tenha pedido de compra
							If Empty(aCols[_i,nPosLote])  
								aCols[_i,nPosLote] := U_MIFLMPEM(_i) 
							EndIf
							
							If Empty(aCols[_i,nPosDVL]) .or.  aCols[_i,nPosDVL] == dDataBase
								//aCols[_i,nPosDVL] := dDEmissao+1825
								aCols[_i,nPosDVL] := dDatabase+1825 // Alterado para Dt. Digitacao - Solicitacao Amanda Adario 16/04/19
							EndIf
						EndIf
	
					EndIf
				EndIf

			EndIf

		Next _i
	EndIf
EndIf

RestArea(_aArea)

Return _lRet
