#Include "Protheus.ch"
 
/*---------------------------------------------------------------------------------*
 | P.E.:  MT121BRW                                                                 |
 | Desc:  Adição de opções no Ações Relacionadas do Pedidos de Compra              |
 | Diego Mafisolli - 10/12/2018											           |
 *---------------------------------------------------------------------------------*/
 
User Function MT121BRW()
 	//aAdd(aRotina, {"Impr. Ped.Compra Midori", "U_VSS_ATLR02()", 0, 0, 6}) // utilizar nova rotina impr. pedido compra 
    aAdd(aRotina, {"Envio Ped.Compra E-mail", "U_PCGRFEMAI(.T.,'')", 0, 0, 6}) // Usado para envio ao fornecedor 
    aAdd(aRotina, {"Impr. Ped.Compra Grafico", "U_RELPCGRF(.F.,'')", 0, 0, 6}) // Impressao PC Midori
    aAdd(aRotina, {"Alterar Senha Env. Email", "U_MBRUPDWF7()", 0, 0, 6}) // Impressao PC Midori
    
Return()