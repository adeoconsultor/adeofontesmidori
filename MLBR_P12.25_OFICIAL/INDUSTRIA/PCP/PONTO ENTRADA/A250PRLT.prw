#INCLUDE "TOTVS.CH"

/*
//////////////////////////////////////////////////////////////////////////////////////
// Programa : A250PRLT - Ponto de Entrada dentro do MATA250 Apontamento de produção //
// Descrição: Troca ou Trata o lote e a data de validade                            //
// Autor    : Antonio Carlos Damaceno - 20/11/18                                    //
//////////////////////////////////////////////////////////////////////////////////////
*/
User Function A250PRLT

Local aArea      := GetArea()
Local cLote      := ParamIXB[1]      //-- Lote sugerido pelo sistema
Local cData      := ParamIXB[2]      //-- Data de Validade sugerida pelo sistema
Local lExibeLt   := ParamIXB[3]      //-- Exibir a getdados para confirmação da sugestão do lote na tela.
Local aRet       := {}
Local cProduto   := SC2->C2_PRODUTO
Local cMV_PRODUB := SuperGetMV("MV_PRODUB",.F.,'074565')     //caso o parametro não esteja criado, busca o codigo '074565' automaticamente

cData    := cData + 1825           // a pedido da usuária Amanda/Thiago PNP2 solicitaram para incluir a data de validade do lote pra 5 anos + 1 dia (antonio)
cLote    := '          '           // idem acima     (ver se deixa como AUTO ou VAZIO)
lExibeLt := .T.

If AllTrim(cProduto) == cMV_PRODUB // produto de dublagem idem acima (esta chumbado no parametro a pedido do cliente)
	cLote := SC2->C2_OPMIDO        // Para produto de dublagem o lote será o numero do plano
EndIf

AADD(aRet,cLote)
AADD(aRet,cData)
AADD(aRet,lExibeLt)

RestArea(aArea)

Return aRet        
