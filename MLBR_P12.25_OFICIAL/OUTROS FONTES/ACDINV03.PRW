#INCLUDE "TOTVS.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACDINV03 ºAutor  ³Antonio Carlos Damaceno º Data ³  06/12/16º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de CAD Cadastro Etq na ZZT                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
028019|APAPU13416|112401C
*/

User Function ACDINV03()

Local cAlias := "ZZT"

Private cCadastro  := OemToAnsi("Cadastro Etq na ZZT")
Private aRotina    := { }

AADD(aRotina, { "Pesquisar" , "AxPesqui", 0, 1 })
AADD(aRotina, { "Visualizar", "AxVisual", 0, 2 })
AADD(aRotina, { "Incluir"   , "AxInclui", 0, 3 })
AADD(aRotina, { "Alterar"   , "AxAltera", 0, 4 })
AADD(aRotina, { "Excluir"   , "U_UAxDeleta()", 0, 5 })

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6, 1, 22, 75, cAlias)

Return NIL
           

User Function UAxDeleta()

Local cAliasZZS   := GetNextAlias()
Local cCodLocal   := ZZT->ZZT_LOCAL
Local cZZS_CODPRO := ZZT->ZZT_CODPRO
Local cZZS_LOTE   := ZZT->ZZT_LOTE
Local cZZS_CODETQ := ZZT->ZZT_SEQUEN

cQuery := " SELECT ZZS.ZZS_CODPRO, ZZS.ZZS_CODETQ, ZZS.ZZS_LOTE "
cQuery += "  FROM " + RetSqlName("ZZS") + " ZZS  "
cQuery += "  WHERE ZZS.ZZS_FILIAL  = '" + xFilial("ZZS") + "' AND "
cQuery += "        ZZS.D_E_L_E_T_  = ' ' AND " 
cQuery += "        ZZS.ZZS_CODPRO  = '" + cZZS_CODPRO + "' AND "
cQuery += "        ZZS.ZZS_LOTE    = '" + cZZS_LOTE   + "' AND "
cQuery += "        ZZS.ZZS_CODETQ  = '" + cZZS_CODETQ + "' AND "
cQuery += "        ZZS.ZZS_LOCAL   = '" + cCodLocal   + "' "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZZS,.T.,.T.) 
dbSelectArea(cAliasZZS)

If (cAliasZZS)->(!Eof())
	Alert('Etiqueta não pode ser excluída, pois já existem lançamentos desta etiqueta no inventário!!!')
	(cAliasZZS)->(dbCloseArea())
    Return
Else
	RecLock("ZZT",.F.)
	dbDelete()
	MsUnlock()
EndIf
                  
(cAliasZZS)->(dbCloseArea())

Return    
