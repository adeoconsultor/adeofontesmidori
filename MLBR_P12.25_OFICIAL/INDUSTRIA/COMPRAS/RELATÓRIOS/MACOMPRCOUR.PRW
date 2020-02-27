#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#DEFINE PICVAL  "@E 999,999,999.99"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MACOMPRCOUR³ Autor ³Anesio G.Faria-Taggs ³ Data ³18/10/2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³angfaria@hotmail.com            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Programa para imprimir relatorio de compras de couro        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Midori Atlantica - PNP1                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Anesio G.Fari                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ComprCour()

Private cPerg   := "COMPRCOUR"
//Exclusivo para gerar Excel...
Private aConteud:= {}
Private aDir   	:= {}
Private nHdl   	:= 0
Private lOk     := .T.
Private cArqTxt := ""
Private cCab    := ""

If APMsgNoYes("Deseja Gerar para Excel", "Gerar Excel")

	aDir := MDirArq()
	
	If Empty(aDir[1]) .OR. Empty(aDir[2])
		Return
	Else
		AjustaSx1()
		If ! Pergunte(cPerg,.T.)
			Return
		EndIf
		
		U_GeraArqExcel()
		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
	EndIf
Else
	
	U_RelComprCour()
	
EndIf



Return



User Function RelComprCour()
Local titulo 	:= "RELATÓRIO DE COMPRAS DE COURO - FC01 R.D.N.F"
Local cString	:= ""
Local wnrel		:= "COMPRCOUR"
Local cDesc		:= "Este programa ira imprimir a relacao de compras de couros conforme parametro especificado"
Local aOrd    	:= "Por Produto "
Local tamanho	:= "G"
Local lRet      := .T.
Private aReturn := {"TST01",1,"TST02", 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
Private cPerg   := "COMPRCOUR"
Private nLastKey:= 0




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Pergunte("ComprCour",.T.)

AjustaSx1()
If ! Pergunte(cPerg,.T.)
	Return
Endif

//msgbox("Perguntas OK...")
//msgbox("Gerado arquivo consulta....")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd,,Tamanho)
wnrel := SetPrint(cString,wnrel,,@titulo,cDesc,"","",.F.,,,Tamanho)
//msgbox("Ok Relatorio....")
If aReturn[4] == 1
	Tamanho := "G"
EndIf
If nLastKey == 27
	Set Filter To
	lRet := .F.
EndIf

If lRet
	SetDefault(aReturn,cString)
EndIf

If lRet .And. nLastKey == 27
	Set Filter To
	lRet := .F.
EndIf

If lRet
	
	RptStatus({|lEnd| MntRelComprCour(@lEnd,wnRel,titulo,tamanho)},titulo)
	
EndIf

Return NIL


//msgbox("Chamado Relatorio...")
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MntRelComprCour³ Autor ³ Anesio G.Faria³ Data ³ 18.10.2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Compras			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MntRelComprCour(lEnd,wnRel,titulo,tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbTxt
Local CbCont,cabec1,cabec2
Local limite    := If(aReturn[4] == 1,132,180)
Local nomeprog  := "COMPRCOUR"
Local nTipo     := 0
Local cStatus,nOrdem,cSeek
Local cQuery    := "",cIndex := CriaTrab("",.F.),nIndex:=0
Local cQuerySD1 := ""
Local lTipo     := .F.
Local cAliasQry := GetNextAlias()
Local cQrySD1   := GetNextAlias()
Local aCampos   := {}
Local aCposRes  := {}
Local aCposCMP  := {}
Local nReg      := 0
Local i         := 0
Local cGrupo    := ""
Local InfSF8Ant := ""
Local aCposSF8  := {}
Local cAliasSF8 := GetNextAlias()
Local cQuerySF8 := ""
Local cDocAnt   := ""
Local nDocAnt   := 2
Local nContRep  :=0

//Variáveis totalizadora produto
Local nvqp:=0, nmquadp :=0, ntotbp:=0, nicmp:=0, ncofp:=0, npisp:=0, nliqp:=0, nfretep:=0, nicmfretp:=0, npisfretp:=0, mcoffretp:=0, nliqfretp:=0

//Variáveis totalizadora fornecedor
Local nvqf:=0, nmquadf :=0, ntotbf:=0, nicmf:=0, ncoff:=0, npisf:=0, nliqf:=0, nfretef:=0, nicmfretf:=0, npisfretf:=0, mcoffretf:=0, nliqfretf:=0
Local nvqfk:=0, nmquadfk :=0, ntotbfk:=0, nicmfk:=0, ncoffk:=0, npisfk:=0, nliqfk:=0, nfretefk:=0, nicmfretfk:=0, npisfretfk:=0, mcoffretfk:=0, nliqfretfk:=0

//Variáveis totalizadora geral
Local nvqt:=0, nmquadt :=0, ntotbt:=0, nicmt:=0, ncoft:=0, npist:=0, nliqt:=0, nfretet:=0, nicmfrett:=0, npisfrett:=0, mcoffrett:=0, nliqfrett:=0
Local nvqtk:=0, nmquadtk :=0, ntotbtk:=0, nicmtk:=0, ncoftk:=0, npistk:=0, nliqtk:=0, nfretetk:=0, nicmfrettk:=0, npisfrettk:=0, mcoffrettk:=0, nliqfrettk:=0

//Tabela temporária para gravar SF8 - Esta tabela existe por nao haver possibilidade
//	de criar um mecanismo de buscas das notas fiscais de frete quando há mais de uma NF amarrada a mesma nota fiscal de frete
AADD(aCposSF8, {"F8_NFDIFRE", "C",  9})
AADD(aCposSF8, {"F8_SEDIFRE", "C",  3})
AADD(aCposSF8, {"F8_TRANSP",  "C",  6})
AADD(aCposSF8, {"F8_LOJTRAN", "C",  2})
AADD(aCposSF8, {"F8_FORNECE", "C",  6})
AADD(aCposSF8, {"F8_LOJA",    "C",  2})
AADD(aCposSF8, {"F8_ITEM",    "C",  4})
AADD(aCposSF8, {"F8_NFORIG",  "C",  9})
AADD(aCposSF8, {"F8_SERORIG", "C",  3})

cNomeSF8 := CriaTrab(aCposSF8,.T.)
If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea("TRB")
Endif
dbUseArea(.T.,,cNomeSF8,"TRB",Nil,.F.)

cQuerySF8 := " SELECT F8_NFDIFRE, F8_SEDIFRE, F8_TRANSP, F8_LOJTRAN, F8_NFORIG, F8_SERORIG, F8_FORNECE, F8_LOJA "
cQuerySF8 += " FROM " + RetSQLName( "SF8" ) + " SF8, "  + RetSQLName( "SD1") + " SD1 "
cQuerySF8 += " WHERE "
cQuerySF8 += " SF8.F8_FILIAL = '"+xFilial("SF8") + "' "
cQuerySF8 += " AND SD1.D1_FILIAL = '"+xFilial("SD1") + "' "
cQuerySF8 += " AND SD1.D_E_L_E_T_ <> '*' "
cQuerySF8 += " AND SF8.D_E_L_E_T_ <> '*' "
cQuerySF8 += " AND D1_DOC = F8_NFDIFRE "
cQuerySF8 += " AND D1_SERIE = F8_SEDIFRE "
cQuerySF8 += " AND D1_FORNECE = F8_TRANSP "
cQuerySF8 += " AND D1_LOJA = F8_LOJTRAN "
cQuerySF8 += " AND SF8.F8_TIPO = 'F' "
cQuerySF8 += " ORDER BY F8_NFDIFRE, F8_SEDIFRE, F8_TRANSP, F8_LOJTRAN "

cQuerySF8 := ChangeQuery(cQuerySF8)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuerySF8),cAliasSF8, .F., .T.)

//Gravar na tabela intermediária....
nDocAnt:=1
cDocAnt:=""
dbGotop()
While !(cAliasSF8)->(EoF())
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->F8_NFDIFRE := (cAliasSF8)->F8_NFDIFRE
	TRB->F8_SEDIFRE := (cAliasSF8)->F8_SEDIFRE
	TRB->F8_TRANSP  := (cAliasSF8)->F8_TRANSP
	TRB->F8_LOJTRAN := (cAliasSF8)->F8_LOJTRAN
	TRB->F8_FORNECE := (cAliasSF8)->F8_FORNECE
	TRB->F8_LOJA    := (cAliasSF8)->F8_LOJA
	TRB->F8_NFORIG  := (cAliasSF8)->F8_NFORIG
	TRB->F8_SERORIG := (cAliasSF8)->F8_SERORIG
	
	if cDocAnt == (cAliasSF8)->F8_NFDIFRE+(cAliasSF8)->F8_SEDIFRE
		//		alert("Gravando ITEM DIFERENTE..."+(cAliasSF8)->F8_NFDIFRE+" VALOR: " +cValToChar(nDocAnt))
		if nDocAnt == 2
			TRB->F8_ITEM := '0002'
		elseif nDocAnt == 3
			TRB->F8_ITEM := '0003'
		elseif nDocAnt== 4
			TRB->F8_ITEM := '0004'
		elseif nDocAnt== 5
			TRB->F8_ITEM := '0005'
		elseif nDocAnt== 6
			TRB->F8_ITEM := '0006'
		endif
	else
		TRB->F8_ITEM := '0001'
		nDocAnt:=1
	endif
	nDocAnt++
	nContRep++
	TRB->(MsUnLock())
	cDocAnt := (cAliasSF8)->F8_NFDIFRE+(cAliasSF8)->F8_SEDIFRE
	(cAliasSF8)->(dbSkip())
enddo
//msgbox("Gravado arquivo SF8 com sucesso... Repedito ->"+cValToChar(nContRep)+" Registros...")

//Tabela temporária para gravar as informacoes, depois jogar para relatório ou exportar para Excel....
AADD(aCampos, {"D1_DOC",       "C",  9})
AADD(aCampos, {"D1_SERIE",     "C",  3})
AADD(aCampos, {"D1_ITEM",      "C",  3})
AADD(aCampos, {"D1_ENTRADA",   "D",  8})
AADD(aCampos, {"D1_EMISSAO",   "D",  8})
AADD(aCampos, {"E1_VENCTO",    "D",  8})
AADD(aCampos, {"D1_UF",        "C",  2})
AADD(aCampos, {"B1_COD",       "C", 15})
AADD(aCampos, {"B1_DESC",      "C", 60})
AADD(aCampos, {"A2_COD",       "C",  6})
AADD(aCampos, {"A2_LOJA",      "C",  2})
AADD(aCampos, {"A2_NOME",      "C", 60})
AADD(aCampos, {"B1_TIPO",      "C", 15})
AADD(aCampos, {"B1_UM",        "C",  2})
AADD(aCampos, {"QUILO",        "N", 18,6})
AADD(aCampos, {"VAQTA",        "N", 18,6})
AADD(aCampos, {"MQUAD",        "N", 18,6})
AADD(aCampos, {"PEQUAD",       "N", 18,6})
AADD(aCampos, {"D1_VUNIT",     "N", 18,6})
AADD(aCampos, {"D1_TOTAL",     "N", 18,6})
AADD(aCampos, {"D1_VICMS",     "N", 18,6})
AADD(aCampos, {"D1_VPIS",      "N", 18,6})
AADD(aCampos, {"D1_VCOFINS",   "N", 18,6})
AADD(aCampos, {"D1_TOTALIQ",   "N", 18,6})
AADD(aCampos, {"D1_MMTVQTA",   "N", 18,6}) //Media de Metragem por Vaquetas
AADD(aCampos, {"D1_VUNITLQ",   "N", 18,6})
AADD(aCampos, {"D1_CONHECF",   "C",  9}) //Numero do conhecimento de frete
AADD(aCampos, {"D1_SERFRET",   "C",  3}) //Numero da serie do conhecimento de frete
AADD(aCampos, {"D1_FORFRET",   "C",  6})
AADD(aCampos, {"D1_LOJFRET",   "C",  2})
AADD(aCampos, {"D1_VFRETE",    "N", 18,6}) //Valor do Frete
AADD(aCampos, {"D1_VICMFRT",   "N", 18,6}) //Valor ICMS Frete
AADD(aCampos, {"D1_VPISFRT",   "N", 18,6}) //Valor PIS Frete
AADD(aCampos, {"D1_LOTECTL",   "C", 10})
AADD(aCampos, {"D1_VCOFFRT",   "N", 18,6}) //Valor COFINS Frete
AADD(aCampos, {"D1_VLIQFRT",   "N", 18,6}) //Valor Total Liquido do Frete
AADD(aCampos, {"D1_VUNIFRT",   "N", 18,6}) //Valor Unitário por M² incluso no Frete

cNome := CriaTrab(aCampos,.T.)
If (Select("TMP") <> 0)
	dbSelectArea("TMP")
	dbCloseArea("TMP")
Endif
dbUseArea(.T.,,cNome,"TMP",Nil,.F.)

//Tabela temporária para armazenar Resumo
AADD(aCposRes, {"A2_COD",       "C",  6})
AADD(aCposRes, {"A2_LOJA",      "C",  2})
AADD(aCposRes, {"D1_UF",        "C",  2})
AADD(aCposRes, {"A2_NOME",      "C", 60})
AADD(aCposRes, {"B1_TIPO",      "C", 15})
AADD(aCposRes, {"B1_DESC",      "C", 60})
AADD(aCposRes, {"B1_COD",       "C", 15})
AADD(aCposRes, {"B1_UM",        "C",  2})
AADD(aCposRes, {"QUILO",        "N", 18, 6})
AADD(aCposRes, {"VAQTA",        "N", 18, 6})
AADD(aCposRes, {"MQUAD",        "N", 18, 6})
AADD(aCposRes, {"D1_TOTAL",     "N", 18, 6})
AADD(aCposRes, {"D1_VICMS",     "N", 18, 6})
AADD(aCposRes, {"D1_VPIS",      "N", 18, 6})
AADD(aCposRes, {"D1_VCOFINS",   "N", 18, 6})
AADD(aCposRes, {"D1_TOTALIQ",   "N", 18, 6})
AADD(aCposRes, {"D1_MMTVQTA",   "N", 18, 6}) //Media de Metragem por Vaquetas
AADD(aCposRes, {"D1_VUNITLQ",   "N", 18, 6})
AADD(aCposRes, {"D1_CONHECF",   "C", 9}) //Numero do conhecimento de frete
AADD(aCposRes, {"D1_VFRETE",    "N", 18, 6}) //Valor do Frete
AADD(aCposRes, {"D1_VICMFRT",   "N", 18, 6}) //Valor ICMS Frete
AADD(aCposRes, {"D1_VPISFRT",   "N", 18, 6}) //Valor PIS Frete
AADD(aCposRes, {"D1_VCOFFRT",   "N", 18, 6}) //Valor COFINS Frete
AADD(aCposRes, {"D1_VLIQFRT",   "N", 18, 6}) //Valor Total Liquido do Frete
AADD(aCposRes, {"D1_VUNIFRT",   "N", 18, 6}) //Valor Unitário por M² incluso no Frete

cNomeRes := CriaTrab(aCposRes,.T.)
If (Select("RES") <> 0)
	dbSelectArea("RES")
	dbCloseArea("RES")
Endif
dbUseArea(.T.,,cNomeRes,"RES",Nil,.F.)



cGrupo := "'"
for i:=1 to 40
	if Substr(mv_par03,i,1) == ';' .or. Substr(mv_par03,i,1) == '/'
		cGrupo:= cGrupo+"','"
	elseif Substr(mv_par03,i,1) <> " "
		cGrupo:= cGrupo+Substr(mv_par03,i,1)
	endif
	if Substr(mv_par03,i,1) == " "
		cGrupo := cGrupo + "'"
		i := 40
	endif
next
//alert("Variavel Grupo -> "+cGrupo)


//cQuery := "SELECT D1_FORNECE, D1_LOJA, D1_ITEM, D1_DOC, D1_SERIE, D1_FILIAL, D1_EMISSAO, D1_DTDIGIT, D1_COD, D1_X_DESCR, D1_TIPOCOU, "
cQuery := "SELECT D1_FORNECE, D1_LOJA, F1_TIPO, D1_ITEM, D1_DOC, D1_SERIE, D1_FILIAL, D1_EMISSAO, D1_DTDIGIT, D1_COD, D1_X_DESCR, D1_TIPOCOU, " // AOliveira 05-07-11, Chamado 003535
cQuery += "D1_QUANT, D1_NVQTAS, D1_QUILOS, D1_VUNIT, D1_TOTAL, D1_VALICM, D1_VALIMP5, D1_VALIMP6, D1_VALFRE , " // VALIMP5 = PIS, VALIMP6 = COFINS
cQuery += "D1_PICM, D1_LOTECTL, D1_BASIMP5, D1_BASIMP6, F1_ESPECIE " // D1_BASIMP5 = BASE PIS, D1_BASIMP6 = BASE COFINS
cQuery += "FROM " + RetSQLName( "SD1" ) + " SD1, " + RetSQLName( "SF1" ) + " SF1 "
cQuery += "WHERE "
cQuery += "SD1.D1_FILIAL = '"+xFilial("SD1") + "' AND SF1.F1_FILIAL = '"+xFilial("SF1") + "' "
cQuery += "AND SD1.D_E_L_E_T_ <> '*' AND SF1.D_E_L_E_T_ <> '*' AND "
cQuery += "SF1.F1_ESPECIE <> 'CTR' AND "
cQuery += "SD1.D1_DOC = SF1.F1_DOC AND SD1.D1_SERIE = SF1.F1_SERIE AND SD1.D1_FORNECE = SF1.F1_FORNECE AND SD1.D1_LOJA = SF1.F1_LOJA AND "
cQuery += "SD1.D1_DTDIGIT BETWEEN '" + dtos(MV_PAR01) + "' AND '" + dtos(MV_PAR02) + "' AND "
//msgbox("DATA--> "+dTos(MV_PAR01)+ " ATÉ "+dTos(MV_PAR02))
cQuery += "SD1.D1_GRUPO in (" + cGrupo + ") AND "
cQuery += "SD1.D1_COD BETWEEN '" + MV_PAR04 + "' AND '"+ MV_PAR05 + "' AND "
cQuery += "SD1.D1_FORNECE BETWEEN '" + MV_PAR06 + "' AND '"+ MV_PAR07 + "' AND "
cQuery += "SD1.D1_LOJA BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' AND "
cQuery += "SD1.D1_DOC + SD1.D1_SERIE + SD1.D1_FORNECE <> '0000265663  001077' AND D1_QUANT > D1_QTDEDEV AND "
cQuery += "SD1.D1_TES not in ('164','165','102') "
cQuery += "ORDER BY D1_EMISSAO, D1_COD "

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)

TcSetField(cAliasQry, "D1_EMISSAO", "D")
TcSetField(cAliasQry, "D1_DTDIGIT", "D")

DbSelectArea("TRB")
cArquivo := CriaTrab(,.F.)
INDREGUA("TRB",cArquivo,"F8_NFORIG+F8_SERORIG+F8_FORNECE+F8_LOJA+F8_ITEM",,)

//msgbox("Query Gerada.....")
//Gravar na tabela intermediária....
nCont:=0
ncontseq:=0
cItemAnt:= ""
dbGotop()
While !(cAliasQry)->(EoF())
	dbSelectArea("TMP")
	RecLock("TMP",.T.)
	TMP->D1_DOC 		:= (cAliasQry)->D1_DOC
	TMP->D1_SERIE  		:= (cAliasQry)->D1_SERIE
	TMP->D1_ENTRADA		:= (cAliasQry)->D1_DTDIGIT
	TMP->D1_EMISSAO		:= (cAliasQry)->D1_EMISSAO
	dbSelectArea("SE2")
	dbSetOrder(6)
	//			msgbox("Busca -->> "+(cAliasQry)->(D1_FORNECE+D1_LOJA+D1_FILIAL+D1_DOC))
	dbSeek(xFilial("SE2")+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA+(cAliasQry)->D1_FILIAL+' '+(cAliasQry)->D1_DOC )
	TMP->E1_VENCTO      := SE2->E2_VENCREA
	//		TMP->D1_UF          :=  Posicione("SA2",1,xFilial("SA2")+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA, "A2_EST")
	TMP->D1_UF          :=  If((cAliasQry)->F1_TIPO = "B",Posicione("SA1",1,xFilial("SA1")+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA, "A1_EST"),Posicione("SA2",1,xFilial("SA2")+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA, "A2_EST") )//AOliveira 05-07-11 , Chamado 003535
	TMP->B1_COD         := (cAliasQry)->D1_COD
	TMP->B1_DESC        := (cAliasQry)->D1_X_DESCR
	TMP->A2_COD         := (cAliasQry)->D1_FORNECE
	TMP->A2_LOJA        := (cAliasQry)->D1_LOJA
	//		TMP->A2_NOME        := Posicione("SA2",1,xFilial("SA2")+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA, "A2_NOME")
	TMP->A2_NOME        := If((cAliasQry)->F1_TIPO = "B",Posicione("SA1",1,xFilial("SA1")+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA, "A1_NOME"),Posicione("SA2",1,xFilial("SA2")+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA, "A2_NOME")) //AOliveira 05-07-2011, Chamado 003535
	TMP->B1_UM          := Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->D1_COD, "B1_UM")
	if (cAliasQry)->D1_TIPOCOU == '1'
		TMP->B1_TIPO        := "INTEGRAL"
	elseif (cAliasQry)->D1_TIPOCOU == '2'
		TMP->B1_TIPO        := "DIV TRIPA"
	elseif (cAliasQry)->D1_TIPOCOU == '3'
		TMP->B1_TIPO        := "DIV BLUE"
	else
		TMP->B1_TIPO        := "OUTROS"
	endif
	TMP->QUILO          := (cAliasQry)->D1_QUILOS
	TMP->VAQTA          := (cAliasQry)->D1_NVQTAS
	if Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->D1_COD, "B1_UM") == "M2"
		TMP->MQUAD          := (cAliasQry)->D1_QUANT
		TMP->D1_VUNIT       := ((cAliasQry)->D1_TOTAL+(cAliasQry)->D1_VALFRE)/(cAliasQry)->D1_QUANT
	elseif Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->D1_COD, "B1_UM") == "P2"
		TMP->PEQUAD         := (cAliasQry)->D1_QUANT
		TMP->MQUAD          := (cAliasQry)->D1_QUANT * 0.092903
		TMP->D1_VUNIT       := ((cAliasQry)->D1_TOTAL+(cAliasQry)->D1_VALFRE)/((cAliasQry)->D1_QUANT*0.092903)
	else
		TMP->MQUAD          := (cAliasQry)->D1_QUANT
		TMP->D1_VUNIT       := ((cAliasQry)->D1_TOTAL+(cAliasQry)->D1_VALFRE)/(cAliasQry)->D1_QUANT
	endif
	TMP->D1_TOTAL       := (cAliasQry)->D1_TOTAL + (cAliasQry)->D1_VALFRE
	TMP->D1_LOTECTL     := (cAliasQry)->D1_LOTECTL
	TMP->D1_VICMS       := (cAliasQry)->D1_VALICM
	TMP->D1_VPIS        := (cAliasQry)->D1_VALIMP5
	TMP->D1_VCOFINS     := (cAliasQry)->D1_VALIMP6
	
	
	TMP->D1_TOTALIQ    := ((cAliasQry)->D1_TOTAL+(cAliasQry)->D1_VALFRE) - ((cAliasQry)->D1_VALICM + (cAliasQry)->D1_VALIMP5 + (cAliasQry)->D1_VALIMP6)
	if Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->D1_COD, "B1_UM") == "M2"
		TMP->D1_MMTVQTA 	:= (cAliasQry)->D1_QUANT / (cAliasQry)->D1_NVQTAS	//Media de Metragem por Vaquetas
	endif
	if Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->D1_COD, "B1_UM") == "P2"
		TMP->D1_MMTVQTA 	:= ((cAliasQry)->D1_QUANT * 0.092903) / (cAliasQry)->D1_NVQTAS
	endif
	
	TMP->D1_VUNITLQ    := TMP->D1_TOTALIQ / TMP->MQUAD
	
	if Posicione("SB1",1,xFilial("SB1")+TMP->B1_COD, "B1_TIPO") == 'MO'
		DbSelectArea("SD1")
		cChave := "D1_FILIAL+D1_DOCREFF+D1_SERREFF+D1_FORNREF+D1_LOJREFF"
		cIndSD1 := CriaTrab(Nil,.F.)
		IndRegua("SD1", cIndSD1, cChave, , , "Selecionando Pedidos...")
		if dbSeek(xFilial("SD1")+TMP->D1_DOC+TMP->D1_SERIE+TMP->A2_COD+TMP->A2_LOJA )
			// 				msgbox("Localizado Filial-> "+SD1->D1_FILIAL+" nota fiscal--> "+SD1->D1_DOC+" valor-> "+cValToChar(SD1->D1_TOTAL))
			TMP->D1_CONHECF := SD1->D1_DOC	//Numero do conhecimento de frete
			TMP->D1_SERFRET := SD1->D1_SERIE
			TMP->D1_FORFRET := SD1->D1_FORNECE
			TMP->D1_LOJFRET := SD1->D1_LOJA
			TMP->D1_VFRETE	:= SD1->D1_TOTAL
			TMP->D1_VICMFRT	:= SD1->D1_VALICM
			TMP->D1_VPISFRT	:= SD1->D1_VALIMP5
			TMP->D1_VCOFFRT	:= SD1->D1_VALIMP6
			TMP->D1_VLIQFRT	:= SD1->D1_TOTAL - (SD1->D1_VALICM+SD1->D1_VALIMP5+SD1->D1_VALIMP6)
		endif
		DbSelectArea( "SD1" ) //Selecionando a area
		DbSetOrder( 1 ) //Posicionando na ordem de origem
		fErase( cIndSD1 + OrdBagExt() ) //Deletando arquivo de trabalho
	else
		DbSelectArea("TRB")
		dbGotop()
		if dbSeek((cAliasQry)->D1_DOC+(cAliasQry)->D1_SERIE+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA+(cAliasQry)->D1_ITEM )
			dbSelectArea("SD1")
			dbSetOrder(1)
			dbGotop()
			dbSeek(xFilial("SD1")+TRB->F8_NFDIFRE+TRB->F8_SEDIFRE+TRB->F8_TRANSP+TRB->F8_LOJTRAN,.T.)
			while !eof().and.SD1->D1_FILIAL == xFilial("SD1").and.SD1->D1_DOC == TRB->F8_NFDIFRE;
				.and.SD1->D1_SERIE == TRB->F8_SEDIFRE.and.SD1->D1_FORNECE == TRB->F8_TRANSP;
				.and.SD1->D1_LOJA == TRB->F8_LOJTRAN
				if TRB->F8_ITEM == SD1->D1_ITEM
					TMP->D1_CONHECF := SD1->D1_DOC	//Numero do conhecimento de frete
					TMP->D1_SERFRET := SD1->D1_SERIE
					TMP->D1_FORFRET := SD1->D1_FORNECE
					TMP->D1_LOJFRET := SD1->D1_LOJA
					TMP->D1_VFRETE	:= SD1->D1_TOTAL
					TMP->D1_VICMFRT	:= SD1->D1_VALICM
					TMP->D1_VPISFRT	:= SD1->D1_VALIMP5
					TMP->D1_VCOFFRT	:= SD1->D1_VALIMP6
					TMP->D1_VLIQFRT	:= SD1->D1_TOTAL - (SD1->D1_VALICM+SD1->D1_VALIMP5+SD1->D1_VALIMP6)
				endif
				SD1->(dbSkip())
			enddo
		endif
	endif
	TMP->D1_VUNIFRT:= (TMP->D1_VLIQFRT/TMP->MQUAD)+TMP->D1_VUNITLQ
	TMP->(MsUnLock())
	
	//Verificar se houve algum abatimento na nota fiscal
	if cItemAnt <> ( (cAliasQry)->D1_DOC+(cAliasQry)->D1_SERIE+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA  )
		dbSelectArea("SF1")
		dbSetOrder(1)
		if dbSeek(xFilial("SF1")+(cAliasQry)->D1_DOC+(cAliasQry)->D1_SERIE+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA,.T.)
			if SF1->F1_VALMERC > SF1->F1_VALBRUT
				RecLock("TMP",.T.)
				TMP->D1_DOC 	:= (cAliasQry)->D1_DOC
				TMP->D1_SERIE  	:= (cAliasQry)->D1_SERIE
				TMP->A2_COD     := (cAliasQry)->D1_FORNECE
				TMP->A2_LOJA    := (cAliasQry)->D1_LOJA
				TMP->A2_NOME    := Posicione("SA2",1,xFilial("SA2")+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA, "A2_NOME")
				TMP->B1_COD     := (cAliasQry)->D1_COD
				TMP->B1_DESC    := (cAliasQry)->D1_X_DESCR
				TMP->D1_TOTAL   :=  SF1->F1_VALBRUT - (SF1->F1_VALMERC + SF1->F1_FRETE)
				TMP->D1_VICMS   := 0
				TMP->D1_VPIS    := 0
				TMP->D1_VCOFINS := 0
				TMP->D1_TOTALIQ :=  SF1->F1_VALBRUT - SF1->F1_VALMERC
				TMP->(MsUnLock())
			endif
		endif
	endif
	cItemAnt := (cAliasQry)->D1_DOC+(cAliasQry)->D1_SERIE+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA
	(cAliasQry)->(dbSkip())
	nCont++
enddo

nContItem:=0
cCONHECF := ""
cSERFRET := ""
cFORFRET := ""
cLOJFRET := ""

cNotaAnt  := ""
cSerieAnt := ""
cFornAnt  := ""
cLojaAnt  := ""
nIndice   := 0

DbSelectArea("TMP")
cArquivo := CriaTrab(,.F.)
INDREGUA("TMP",cArquivo,"D1_DOC+D1_SERIE+A2_COD+A2_LOJA",,)
dbGotop()

While TMP->(!eof())

	
	If  (cNotaAnt+cSerieAnt+cFornAnt+cLojaAnt) == TMP->D1_DOC + TMP->D1_SERIE + TMP->A2_COD + TMP->A2_LOJA
		If RecLock("TMP",.F.)
			TMP->D1_CONHECF := cCONHECF
			TMP->D1_SERFRET := cSERFRET
			TMP->D1_FORFRET := cFORFRET
			TMP->D1_LOJFRET := cLOJFRET
			If TMP->D1_VFRETE == 0
				TMP->D1_VFRETE  := 1
			EndIf

//            MSGalert("Notas: "+cNotaAnt+" "+cSerieAnt+" "+cFornAnt+" "+cLojaAnt)
// 			if TMP->(eof())
//				exit
//			ENdIf   
			
			TMP->(MsUnLock())
		EndIf
	EndIf
	If TMP->D1_VFRETE > 0 .and. Posicione("SB1",1,xFilial("SB1")+TMP->B1_COD, "B1_TIPO") <> 'MO'
		dbSelectArea("SF1")
		dbSetOrder(1)
		IF dbSeek(xFilial("SF1") + TMP->D1_DOC + TMP->D1_SERIE + TMP->A2_COD + TMP->A2_LOJA)
			if TMP->D1_TOTAL < SF1->F1_VALMERC
				dbSelectArea("SD1")
				dbSetOrder(1)
				//			alert("NOTA PESQUISADA-> "+TMP->(D1_CONHECF+D1_SERFRET+D1_FORFRET+D1_LOJFRET))
				If dbSeek(xFilial("SD1")+TMP->D1_CONHECF + TMP->D1_SERFRET + TMP->D1_FORFRET + TMP->D1_LOJFRET)
				//			alert("NOTA ENCONTRADA-> "+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA))
					While !SD1->(eof()).and.SD1->D1_FILIAL == xFilial("SD1") .and. (SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA) == (TMP->D1_CONHECF + TMP->D1_SERFRET + TMP->D1_FORFRET + TMP->D1_LOJFRET)
						nContItem++
						SD1->(dbSkip())
					enddo
				EndIf
				//   			msgbox("Atualizando Nota Fiscal --> "+TMP->D1_DOC+ "TOTAL DE ITENS -> "+cVAlToChar(nContItem))
				If nContItem == 1
	
					If nIndice == 0
	
						nFreteAnt    := TMP->D1_VFRETE
						nICMFrtAnt   := TMP->D1_VICMFRT
						nVPISFrtAnt  := TMP->D1_VPISFRT
						nVCOFFrtAnt  := TMP->D1_VCOFFRT
						nVLiqFrtAnt  := TMP->D1_VLIQFRT
	
						RecLock("TMP",.F.)
						TMP->D1_VFRETE	:= TMP->D1_VFRETE  * (TMP->D1_TOTAL / SF1->F1_VALMERC)
						TMP->D1_VICMFRT := TMP->D1_VICMFRT * (TMP->D1_TOTAL / SF1->F1_VALMERC)
						TMP->D1_VPISFRT := TMP->D1_VPISFRT * (TMP->D1_TOTAL / SF1->F1_VALMERC)
						TMP->D1_VCOFFRT := TMP->D1_VCOFFRT * (TMP->D1_TOTAL / SF1->F1_VALMERC)
						TMP->D1_VLIQFRT := TMP->D1_VLIQFRT * (TMP->D1_TOTAL / SF1->F1_VALMERC)
						TMP->(MsUnlock())
						
						nFreteAnt    := nFreteAnt - TMP->D1_VFRETE
						nICMFrtAnt   := nICMFrtAnt - TMP->D1_VICMFRT
						nVPISFrtAnt  := nVPISFrtAnt - TMP->D1_VPISFRT
						nVCOFFrtAnt  := nVCOFFrtAnt - TMP->D1_VCOFFRT
						nVLiqFrtAnt  := nVLiqFrtAnt - TMP->D1_VLIQFRT
						
						nIndice := TMP->D1_VFRETE / SF1->F1_VALMERC
	
					Else
	
						dbSelectArea("SF1")
						dbSetOrder(1)
						If dbSeek(xFilial("SF1")+TMP->D1_CONHECF + TMP->D1_SERFRET + TMP->D1_FORFRET + TMP->D1_LOJFRET,.T.)
							RecLock("TMP",.F.)
							TMP->D1_VFRETE	:= nFreteAnt
							TMP->D1_VICMFRT := nICMFrtAnt
							TMP->D1_VPISFRT := nVPISFrtAnt
							TMP->D1_VCOFFRT := nVCOFFrtAnt
							TMP->D1_VLIQFRT := nVLiqFrtAnt
							TMP->(MsUnlock())
	
							nFreteAnt    := 0
							nICMFrtAnt   := 0
							nVPISFrtAnt  := 0
							nVCOFFrtAnt  := 0
							nVLiqFrtAnt  := 0
						EndIf					
					endif
				endif
			endif

			nContItem := 0
			
		endif
	endif

	cCONHECF := TMP->D1_CONHECF
	cSERFRET := TMP->D1_SERFRET
	cFORFRET := TMP->D1_FORFRET
	cLOJFRET := TMP->D1_LOJFRET
	
	cNotaAnt  := TMP->D1_DOC
	cSerieAnt := TMP->D1_SERIE
	cFornAnt  := TMP->A2_COD
	cLojaAnt  := TMP->A2_LOJA
 // exit
 	TMP->(dbSkip())

EndDo


dbSelectArea("TMP")
dbGotop()
while TMP->(!eof())
	if TMP->D1_VFRETE <= 1
		RecLock("TMP", .F.)
		TMP->D1_VFRETE := 0
		TMP->(MsUnLock())
	endif
	TMP->(dbSkip())
enddo

if MV_PAR10 = 1  //Gerar Resumo
	DbSelectArea("TMP")
	cArquivo := CriaTrab(,.F.)
	INDREGUA("TMP",cArquivo,"D1_DOC+D1_SERIE+A2_COD+A2_LOJA",,)
	dbGotop()
	While !TMP->(eof())
		if Posicione("SB1",1,xFilial("SB1")+TMP->B1_COD, "B1_TIPO") <> 'MO'
			//		.and. Posicione("SB1",1,xFilial("SB1")+TMP->B1_COD, "B1_UM") <> 'KG'
			dbSelectArea("RES")
			cArqRes := CriaTrab(,.F.)
			INDREGUA("RES",cArqRes, "A2_COD+A2_LOJA+B1_COD",,)
			if dbSeek(TMP->A2_COD + TMP->A2_LOJA + TMP->B1_COD )
				RecLock("RES",.F.)
				RES->VAQTA  		+= TMP->VAQTA
				RES->MQUAD			+= TMP->MQUAD
				RES->D1_TOTAL		+= TMP->D1_TOTAL
				RES->D1_VICMS 		+= TMP->D1_VICMS
				RES->D1_VPIS 		+= TMP->D1_VPIS
				RES->D1_VCOFINS 	+= TMP->D1_VCOFINS
				RES->D1_TOTALIQ 	+= TMP->D1_TOTALIQ
				RES->D1_MMTVQTA		+= TMP->D1_MMTVQTA
				RES->D1_VUNITLQ		+= TMP->D1_VUNITLQ
				RES->D1_CONHECF		+= TMP->D1_CONHECF
				RES->D1_VFRETE		+= TMP->D1_VFRETE
				RES->D1_VICMFRT		+= TMP->D1_VICMFRT
				RES->D1_VPISFRT		+= TMP->D1_VPISFRT
				RES->D1_VCOFFRT		+= TMP->D1_VCOFFRT
				RES->D1_VLIQFRT		+= TMP->D1_VLIQFRT
				RES->D1_VUNIFRT		+= TMP->D1_VUNIFRT
				RES->(MsUnlock())
		else
				RecLock("RES",.T.)
				RES->A2_COD			:= TMP->A2_COD
				RES->A2_LOJA		:= TMP->A2_LOJA
				RES->D1_UF			:= TMP->D1_UF
				RES->A2_NOME 		:= TMP->A2_NOME
				RES->B1_TIPO		:= TMP->B1_TIPO
				RES->B1_COD	 		:= TMP->B1_COD
				RES->B1_DESC		:= Posicione("SB1",1,xFilial("SB1")+TMP->B1_COD, "B1_DESC")
				RES->B1_UM 			:= Posicione("SB1",1,xFilial("SB1")+TMP->B1_COD, "B1_UM")
				RES->VAQTA  		:= TMP->VAQTA
				RES->MQUAD			:= TMP->MQUAD
				RES->D1_TOTAL		:= TMP->D1_TOTAL
				RES->D1_VICMS 		:= TMP->D1_VICMS
				RES->D1_VPIS 		:= TMP->D1_VPIS
				RES->D1_VCOFINS 	:= TMP->D1_VCOFINS
				RES->D1_TOTALIQ 	:= TMP->D1_TOTALIQ
				RES->D1_MMTVQTA		:= TMP->D1_MMTVQTA
				RES->D1_VUNITLQ		:= TMP->D1_VUNITLQ
				RES->D1_CONHECF		:= TMP->D1_CONHECF
				RES->D1_VFRETE		:= TMP->D1_VFRETE
				RES->D1_VICMFRT		:= TMP->D1_VICMFRT
				RES->D1_VPISFRT		:= TMP->D1_VPISFRT
				RES->D1_VCOFFRT		:= TMP->D1_VCOFFRT
				RES->D1_VLIQFRT		:= TMP->D1_VLIQFRT
				RES->D1_VUNIFRT		:= TMP->D1_VUNIFRT
				RES->(MsUnlock())
			endif
		endif //Fim do teste se o produto é Mao de Obra
		TMP->(dbSkip())
	enddo
	
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt  := Space(10)
cbcont := 0
li     := 79
m_pag  := 1

nTipo  := IIf(aReturn[4]==1,15,18)
nOrdem := aReturn[8]
lTipo  := IIf(aReturn[4]==1,.T.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cabec1 := "  NOTA  ENTRADA    EMISSAO     VENCIMENTO      QTDE      QTDE     VALOR     TOTAL N.      ICMS      COFINS       PIS        TOTAL  MEDIO  VLR.UNIT  N.CONHEC.   TOTAL      ICMS   COFINS       PIS    TOTAL LIQ  VALOR UNIT  "
cabec2 := "FISCAL                                         VAQ         M²   UNIT.R$    FISCAL R$       R$           R$        R$       LIQ.R$  M2/VQ  S/IMP.R$      FRETE |-------------------FRETE R$---------------------| S/IMP+FRET  "
//		   123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789
//                       1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20
//Cabeçalho para o Resumo
cabec3 := "  PRODUTO                                   TOTAL         TOTAL VLR.UN.      TOTAL N.        ICMS      COFINS        PIS          TOTAL  MEDIO VLR.UNIT       TOTAL      ICMS      COFINS        PIS     TOTAL LIQ  VALOR UNIT  "
cabec4 := "                                               VQ            M2     R$      FISCAL R$         R$           R$         R$         LIQ.R$  M2/VQ S/IMP.R$ |-----------------------FRETE R$----_---------------------| S/IMP+FRET  "
//		   123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789
//                       1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20


nContForn:=0


SetRegua(RecCount())		// Total de Elementos da regua
DbSelectArea("TMP")
cArquivo := CriaTrab(,.F.)
INDREGUA("TMP",cArquivo,"A2_COD+A2_LOJA+B1_DESC",,)
dbGotop()
cProduto:= ""
cFornec := ""
cUmProd := ""
While !TMP->(EoF())
	IncRegua()
	if Posicione("SB1",1,xFilial("SB1")+TMP->B1_COD, "B1_TIPO") <> 'MO'
		If lEnd
			@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
			Exit
		EndIf
		if Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIf
		if cFornec <> TMP->A2_COD+TMP->A2_LOJA
			@Li ,000 Psay "FORNECEDOR: "+TMP->A2_COD+'-'+TMP->A2_LOJA+'-'+TMP->A2_NOME + " UF: "+TMP->D1_UF
			li++
		endif
		if (cProduto <> TMP->B1_COD).or.(cFornec <> TMP->A2_COD+TMP->A2_LOJA)
			@Li ,005 Psay "PRODUTO/ARTIGO: "+Substr(TMP->B1_COD,1,6)+'-'+TMP->B1_DESC + "  TIPO: "+TMP->B1_TIPO+ " UNID.MEDIDA: "+;
			Posicione("SB1",1,xFilial("SB1")+TMP->B1_COD, "B1_UM")
			if  Posicione("SB1",1,xFilial("SB1")+TMP->B1_COD, "B1_UM") == 'P2'
				@Li , 130 Psay "CONVERTIDO P/ M²"
			endif
			
			li++
		endif

		cProduto:= TMP->B1_COD
		cFornec := TMP->A2_COD+TMP->A2_LOJA
		
		@Li ,001 PSay Substr(TMP->D1_DOC,4,6)
		@Li ,008 Psay TMP->D1_ENTRADA
		@Li ,019 Psay TMP->D1_EMISSAO
		@Li ,030 Psay TMP->E1_VENCTO
		@Li ,043 Psay TMP->VAQTA Picture "@E 999,999"
		@Li ,051 Psay TMP->MQUAD Picture "@E 999,999.99"

		if TMP->B1_UM == 'KG'
			@Li ,061 Psay TMP->B1_UM
		endif
		
		@Li ,064 Psay TMP->D1_VUNIT Picture "@E 999.99"
		@Li ,071 Psay TMP->D1_TOTAL Picture "@E 9,999,999.99"
		@Li ,086 Psay TMP->D1_VICMS Picture "@E 99,999.99"
		@Li ,097 Psay TMP->D1_VPIS Picture "@E 99,999.99"
		@Li ,107 Psay TMP->D1_VCOFINS Picture "@E 99,999.99"
		@Li ,117 Psay TMP->D1_TOTALIQ Picture "@E 9,999,999.99"
		@Li ,131 Psay TMP->D1_MMTVQTA Picture "@E 99.99"
		@Li ,138 Psay TMP->D1_VUNITLQ Picture "@E 999.99"
		@Li ,146 Psay TMP->D1_CONHECF
		@Li ,157 Psay TMP->D1_VFRETE Picture "@E 99,999.99"
		@Li ,168 Psay TMP->D1_VICMFRT Picture "@E 9,999.99"
		@Li ,176 Psay TMP->D1_VPISFRT Picture "@E 99,999.99"
		@Li ,186 Psay TMP->D1_VCOFFRT Picture "@E 99,999.99"
		@Li ,196 Psay TMP->D1_VLIQFRT Picture "@E 9,999,999.99"
		@Li ,211 Psay TMP->D1_VUNIFRT Picture "@E 99,999.99"
		li++
		
		if TMP->D1_TOTAL > 0
			nMQuadAnt  := TMP->MQUAD
			nVUnitAnt  := TMP->D1_VUNIT
			nVTotalAnt := TMP->D1_TOTAL
			nVicmsAnt  := TMP->D1_VICMS
			nVpisAnt   := TMP->D1_VPIS
			nVCofAnt   := TMP->D1_VCOFINS
			nTotLiqAnt := TMP->D1_TOTALIQ
			nMmtvtaAnt := TMP->D1_MMTVQTA
			nVunLiqAnt := TMP->D1_VUNITLQ
			nVFretAnt  := TMP->D1_VFRETE
			nVicmFrAnt := TMP->D1_VICMFRT
			nVPisFrAnt := TMP->D1_VPISFRT
			nVCofFrAnt := TMP->D1_VCOFFRT
			nVliqFrAnt := TMP->D1_VLIQFRT
			nVuniFrAnt := TMP->D1_VUNIFRT
		elseif TMP->D1_TOTAL < 0
			@Li ,010 PSay "CALCULO DA DIFERENÇA DE VALOR-->> "
			@Li ,064 Psay nVUnitAnt Picture "@E 999.99"
			@Li ,071 Psay TMP->D1_TOTAL + nVTotalAnt Picture "@E 9,999,999.99"
			@Li ,086 Psay nVicmsAnt Picture "@E 99,999.99"
			@Li ,097 Psay nVpisAnt Picture "@E 99,999.99"
			@Li ,107 Psay TMP->D1_VCOFINS Picture "@E 99,999.99"
			@Li ,117 Psay TMP->D1_TOTALIQ + nTotLiqAnt Picture "@E 9,999,999.99"
			@Li ,131 Psay nMmtvtaAnt Picture "@E 99.99"
			@Li ,138 Psay (TMP->D1_TOTALIQ + nTotLiqAnt) / nMquadAnt Picture "@E 999.99"
			@Li ,157 Psay nVFretAnt Picture "@E 99,999.99"
			@Li ,168 Psay nVicmFrAnt Picture "@E 9,999.99"
			@Li ,176 Psay nVPisFrAnt Picture "@E 99,999.99"
			@Li ,186 Psay nVCofFrAnt Picture "@E 99,999.99"
			@Li ,196 Psay nVliqFrAnt Picture "@E 9,999,999.99"
			@Li ,211 Psay (TMP->D1_TOTALIQ + nTotLiqAnt + nVliqFrAnt) / nMquadAnt Picture "@E 99,999.99"
			Li++
		endif
		
		//if TMP->B1_UM <> 'KG'
		//	nmquadp   += TMP->MQUAD
		//endif
		
		cUmProd := TMP->B1_UM
		
		nmquadp   += TMP->MQUAD
		nvqp      += TMP->VAQTA
		ntotbp    += TMP->D1_TOTAL
		nicmp     += TMP->D1_VICMS
		ncofp     += TMP->D1_VCOFINS
		npisp     += TMP->D1_VPIS
		nliqp     += TMP->D1_TOTALIQ
		nfretep   += TMP->D1_VFRETE
		nicmfretp += TMP->D1_VICMFRT
		npisfretp += TMP->D1_VPISFRT
		mcoffretp += TMP->D1_VCOFFRT
		nliqfretp += TMP->D1_VLIQFRT
		TMP->(dbSkip())

		if (cProduto <> TMP->B1_COD) .or. (cFornec <> TMP->A2_COD+TMP->A2_LOJA)
			@LI ,005 Psay "TOTAL DO PRODUTO/ARTIGO ---->>>>"
			@Li ,043 Psay nvqp      Picture "@E 999,999"
			@Li ,051 Psay nmquadp   Picture "@E 999,999.99"
			@Li ,064 Psay ntotbp / nmquadp Picture "@E 999.99"
			@Li ,071 Psay ntotbp    Picture "@E 9,999,999.99"
			@Li ,085 Psay nicmp     Picture "@E 999,999.99"
			@Li ,096 Psay npisp     Picture "@E 999,999.99"
			@Li ,107 Psay ncofp     Picture "@E 99,999.99"
			@Li ,117 Psay nliqp     Picture "@E 9,999,999.99"
			@Li ,131 Psay nmquadp / nvqp Picture "@E 99.99"
			@Li ,138 Psay (nliqp / nMquadp) Picture "@E 999.99"
			@Li ,157 Psay nfretep   Picture "@E 99,999.99"
			@Li ,168 Psay nicmfretp Picture "@E 9,999.99"
			@Li ,176 Psay npisfretp Picture "@E 99,999.99"
			@Li ,186 Psay mcoffretp Picture "@E 99,999.99"
			@Li ,196 Psay nliqfretp Picture "@E 9,999,999.99"
			@Li ,211 Psay (nliqp + nliqfretp) / nMquadp Picture "@E 99,999.99"
			li++
			//		@Li ,  0 PSay __PrtThinLine()
			li++
			if cUmProd <> 'KG'
				nvqf+=nvqp; nmquadf +=nmquadp; ntotbf+=ntotbp; nicmf+=nicmp; ncoff+=ncofp; npisf+=npisp; nliqf+=nliqp; nfretef+=nfretep; nicmfretf+=nicmfretp; npisfretf+=npisfretp; mcoffretf+=mcoffretp; nliqfretf+=nliqfretp
			else
				nvqfk+=nvqp; nmquadfk +=nmquadp; ntotbfk+=ntotbp; nicmfk+=nicmp; ncoffk+=ncofp; npisfk+=npisp; nliqfk+=nliqp; nfretefk+=nfretep; nicmfretfk+=nicmfretp; npisfretfk+=npisfretp; mcoffretfk+=mcoffretp; nliqfretfk+=nliqfretp
			endif
			nvqp:=0; nmquadp :=0; ntotbp:=0; nicmp:=0; ncofp:=0; npisp:=0; nliqp:=0; nfretep:=0; nicmfretp:=0; npisfretp:=0; mcoffretp:=0; nliqfretp:=0
		endif
		if cFornec <> TMP->A2_COD+TMP->A2_LOJA
			@Li ,000 PSay "TOTAL DO FORNECEDOR ---->>>"
			@Li ,043 Psay nvqf      Picture "@E 999,999"
			@Li ,051 Psay nmquadf   Picture "@E 999,999.99"
			@Li ,064 Psay ntotbf / nmquadf Picture "@E 999.99"
			@Li ,071 Psay ntotbf    Picture "@E 9,999,999.99"
			@Li ,085 Psay nicmf     Picture "@E 999,999.99"
			@Li ,096 Psay npisf     Picture "@E 999,999.99"
			@Li ,107 Psay ncoff     Picture "@E 99,999.99"
			@Li ,117 Psay nliqf     Picture "@E 9,999,999.99"
			@Li ,131 Psay nmquadf / nvqf Picture "@E 99.99"
			@Li ,138 Psay (nliqf / nMquadf) Picture "@E 999.99"
			@Li ,157 Psay nfretef   Picture "@E 99,999.99"
			@Li ,168 Psay nicmfretf Picture "@E 9,999.99"
			@Li ,176 Psay npisfretf Picture "@E 99,999.99"
			@Li ,186 Psay mcoffretf Picture "@E 99,999.99"
			@Li ,196 Psay nliqfretf Picture "@E 9,999,999.99"
			@Li ,211 Psay (nliqf + nliqfretf) / nMquadf Picture "@E 99,999.99"
			li++
			
			if nmquadfk > 0 // Verifica se houve entrada de algum produto por QUILO
				
				@Li ,000 PSay "TOTAL DO FORNECEDOR (QUILOS)---->>>"
				@Li ,043 Psay nvqfk      Picture "@E 999,999"
				@Li ,051 Psay nmquadfk   Picture "@E 999,999.99"
				@Li ,064 Psay ntotbfk / nmquadfk Picture "@E 999.99"
				@Li ,071 Psay ntotbfk    Picture "@E 9,999,999.99"
				@Li ,085 Psay nicmfk     Picture "@E 999,999.99"
				@Li ,096 Psay npisfk     Picture "@E 999,999.99"
				@Li ,107 Psay ncoffk     Picture "@E 99,999.99"
				@Li ,117 Psay nliqfk     Picture "@E 9,999,999.99"
				@Li ,131 Psay nmquadfk / nvqfk Picture "@E 99.99"
				@Li ,138 Psay (nliqfk / nMquadfk) Picture "@E 999.99"
				@Li ,157 Psay nfretefk   Picture "@E 99,999.99"
				@Li ,168 Psay nicmfretfk Picture "@E 9,999.99"
				@Li ,176 Psay npisfretfk Picture "@E 99,999.99"
				@Li ,186 Psay mcoffretfk Picture "@E 99,999.99"
				@Li ,196 Psay nliqfretfk Picture "@E 9,999,999.99"
				@Li ,211 Psay (nliqfk + nliqfretfk) / nMquadfk Picture "@E 99,999.99"
				li++
			endif
			
			@Li ,  0 PSay __PrtThinLine()
			li++
			nContForn++
			
			nvqt+=nvqf; nmquadt +=nmquadf; ntotbt+=ntotbf; nicmt+=nicmf; ncoft+=ncoff; npist+=npisf; nliqt+=nliqf; nfretet+=nfretef; nicmfrett+=nicmfretf; npisfrett+=npisfretf; mcoffrett+=mcoffretf; nliqfrett+=nliqfretf
			nvqf :=0; nmquadf :=0; ntotbf:=0; nicmf:=0; ncoff:=0; npisf:=0; nliqf:=0; nfretef:=0; nicmfretf:=0; npisfretf:=0; mcoffretf:=0; nliqfretf:=0
			nvqtk+=nvqfk; nmquadtk +=nmquadfk; ntotbtk+=ntotbfk; nicmtk+=nicmfk; ncoftk+=ncoffk; npistk+=npisfk; nliqtk+=nliqfk; nfretetk+=nfretefk; nicmfrettk+=nicmfretfk; npisfrettk+=npisfretfk; mcoffrettk+=mcoffretfk; nliqfrettk+=nliqfretfk
			nvqfk:=0; nmquadfk :=0; ntotbfk:=0; nicmfk:=0; ncoffk:=0; npisfk:=0; nliqfk:=0; nfretefk:=0; nicmfretfk:=0; npisfretfk:=0; mcoffretfk:=0; nliqfretfk:=0
		endif
	else //Se o Produto For Mao de Obra o sistema já pula para o proximo...
		TMP->(dbSkip())
	endif //Fim da Rotina que testa se o produto é Mao de OBRA
	
enddo


//ROTINA PARA IMPRIMIR APENAS A MAO DE OBRA
SetRegua(RecCount())		// Total de Elementos da regua
DbSelectArea("TMP")
nvqp:=0; nmquadp :=0; ntotbp:=0; nicmp:=0; ncofp:=0; npisp:=0; nliqp:=0; nfretep:=0; nicmfretp:=0; npisfretp:=0; mcoffretp:=0; nliqfretp:=0
nvqfmo :=0; nmquadfmo :=0; ntotbfmo:=0; nicmfmo:=0; ncoffmo:=0; npisfmo:=0; nliqfmo:=0; nfretefmo:=0; nicmfretfmo:=0; npisfretfmo:=0; mcoffretfmo:=0; nliqfretfmo:=0
nvqtmo :=0 ; nmquadtmo :=0; ntotbtmo:=0; nicmtmo:=0; ncoftmo:=0; npistmo:=0; nliqtmo:=0; nfretetmo:=0; nicmfrettmo:=0; npisfrettmo:=0; mcoffrettmo:=0; nliqfrettmo:=0
//nvqtmo :=0nvqfmo; nmquadtmo +=nmquadfmo; ntotbtmo+=ntotbfmo; nicmtmo+=nicmfmo; ncoftmo+=ncoffmo; npistmo+=npisfmo; nliqtmo+=nliqfmo; nfretetmo+=nfretefmo; nicmfrettmo+=nicmfretfmo; npisfrettmo+=npisfretfmo; mcoffrettmo+=mcoffretfmo; nliqfrettmo+=nliqfretfmo

dbGotop()
cProduto:= ""
cFornec := ""
Li++
@Li ,  0 PSay __PrtThinLine()
Li++


While !TMP->(EoF())
	IncRegua()
	if Posicione("SB1",1,xFilial("SB1")+TMP->B1_COD, "B1_TIPO") == 'MO'
		If lEnd
			@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
			Exit
		EndIf
		if Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIf
		if cFornec <> TMP->A2_COD+TMP->A2_LOJA
			@Li ,000 Psay "FORNECEDOR: "+TMP->A2_COD+'-'+TMP->A2_LOJA+'-'+TMP->A2_NOME + " UF: "+TMP->D1_UF
			li++
		endif
		if (cProduto <> TMP->B1_COD).or.(cFornec <> TMP->A2_COD+TMP->A2_LOJA)
			@Li ,005 Psay "PRODUTO/ARTIGO: "+Substr(TMP->B1_COD,1,6)+'-'+TMP->B1_DESC + "  TIPO: "+TMP->B1_TIPO+ " UNID.MEDIDA: "+;
			Posicione("SB1",1,xFilial("SB1")+TMP->B1_COD, "B1_UM")
			
			li++
		endif
		cProduto:= TMP->B1_COD
		cFornec := TMP->A2_COD+TMP->A2_LOJA
		
		@Li ,001 PSay Substr(TMP->D1_DOC,4,6)
		@Li ,008 Psay TMP->D1_ENTRADA
		@Li ,019 Psay TMP->D1_EMISSAO
		@Li ,030 Psay TMP->E1_VENCTO
		@Li ,043 Psay TMP->VAQTA Picture "@E 999,999"
		@Li ,051 Psay TMP->MQUAD Picture "@E 999,999.99"

		if TMP->B1_UM == 'KG'
			@Li ,061 Psay TMP->B1_UM
		endif
		
		@Li ,064 Psay TMP->D1_VUNIT   Picture "@E 999.99"
		@Li ,071 Psay TMP->D1_TOTAL   Picture "@E 9,999,999.99"
		@Li ,086 Psay TMP->D1_VICMS   Picture "@E 99,999.99"
		@Li ,097 Psay TMP->D1_VPIS    Picture "@E 99,999.99"
		@Li ,107 Psay TMP->D1_VCOFINS Picture "@E 99,999.99"
		@Li ,117 Psay TMP->D1_TOTALIQ Picture "@E 9,999,999.99"
		@Li ,131 Psay TMP->D1_MMTVQTA Picture "@E 99.99"
		@Li ,138 Psay TMP->D1_VUNITLQ Picture "@E 999.99"
		
		/*	@Li ,146 Psay SD1->D1_DOC
		@Li ,157 Psay SD1->D1_TOTAL Picture "@E 99,999.99"
		@Li ,168 Psay TMP->D1_VICMFRT Picture "@E 9,999.99"
		@Li ,176 Psay TMP->D1_VPISFRT Picture "@E 99,999.99"
		@Li ,186 Psay TMP->D1_VCOFFRT Picture "@E 99,999.99"
		@Li ,196 Psay TMP->D1_VLIQFRT Picture "@E 9,999,999.99"
		@Li ,211 Psay TMP->D1_VUNIFRT Picture "@E 99,999.99"
		*/
		
		@Li ,146 Psay TMP->D1_CONHECF
		@Li ,157 Psay TMP->D1_VFRETE  Picture "@E 99,999.99"
		@Li ,168 Psay TMP->D1_VICMFRT Picture "@E 9,999.99"
		@Li ,176 Psay TMP->D1_VPISFRT Picture "@E 99,999.99"
		@Li ,186 Psay TMP->D1_VCOFFRT Picture "@E 99,999.99"
		@Li ,196 Psay TMP->D1_VLIQFRT Picture "@E 9,999,999.99"
		@Li ,211 Psay TMP->D1_VUNIFRT Picture "@E 99,999.99"
		li++
		
		
		if TMP->B1_UM <> 'KG'
			nmquadp   += TMP->MQUAD
		endif
		
		if TMP->D1_TOTAL > 0
			nMQuadAnt  := TMP->MQUAD
			nVUnitAnt  := TMP->D1_VUNIT
			nVTotalAnt := TMP->D1_TOTAL
			nVicmsAnt  := TMP->D1_VICMS
			nVpisAnt   := TMP->D1_VPIS
			nVCofAnt   := TMP->D1_VCOFINS
			nTotLiqAnt := TMP->D1_TOTALIQ
			nMmtvtaAnt := TMP->D1_MMTVQTA
			nVunLiqAnt := TMP->D1_VUNITLQ
			nVFretAnt  := TMP->D1_VFRETE
			nVicmFrAnt := TMP->D1_VICMFRT
			nVPisFrAnt := TMP->D1_VPISFRT
			nVCofFrAnt := TMP->D1_VCOFFRT
			nVliqFrAnt := TMP->D1_VLIQFRT
			nVuniFrAnt := TMP->D1_VUNIFRT
		elseif TMP->D1_TOTAL < 0
			@Li ,010 PSay "CALCULO DA DIFERENÇA DE VALOR-->> "
			@Li ,064 Psay nVUnitAnt Picture "@E 999.99"
			@Li ,071 Psay TMP->D1_TOTAL + nVTotalAnt Picture "@E 9,999,999.99"
			@Li ,086 Psay nVicmsAnt Picture "@E 99,999.99"
			@Li ,097 Psay nVpisAnt Picture "@E 99,999.99"
			@Li ,107 Psay TMP->D1_VCOFINS Picture "@E 99,999.99"
			@Li ,117 Psay TMP->D1_TOTALIQ + nTotLiqAnt Picture "@E 9,999,999.99"
			@Li ,131 Psay nMmtvtaAnt Picture "@E 99.99"
			@Li ,138 Psay (TMP->D1_TOTALIQ + nTotLiqAnt) / nMquadAnt Picture "@E 999.99"
			@Li ,157 Psay nVFretAnt Picture "@E 99,999.99"
			@Li ,168 Psay nVicmFrAnt Picture "@E 9,999.99"
			@Li ,176 Psay nVPisFrAnt Picture "@E 99,999.99"
			@Li ,186 Psay nVCofFrAnt Picture "@E 99,999.99"
			@Li ,196 Psay nVliqFrAnt Picture "@E 9,999,999.99"
			@Li ,211 Psay (TMP->D1_TOTALIQ + nTotLiqAnt + nVliqFrAnt) / nMquadAnt Picture "@E 99,999.99"
			Li++
		endif
		
		nvqp      += TMP->VAQTA
		ntotbp    += TMP->D1_TOTAL
		nicmp     += TMP->D1_VICMS
		ncofp     += TMP->D1_VCOFINS
		npisp     += TMP->D1_VPIS
		nliqp     += TMP->D1_TOTALIQ
		nfretep   += TMP->D1_VFRETE
		nicmfretp += TMP->D1_VICMFRT
		npisfretp += TMP->D1_VPISFRT
		mcoffretp += TMP->D1_VCOFFRT
		nliqfretp += TMP->D1_VLIQFRT

		TMP->(dbSkip())

		if cProduto <> TMP->B1_COD
			@LI ,005 Psay "TOTAL DO PRODUTO/ARTIGO ---->>>>"
			@Li ,043 Psay nvqp Picture "@E 999,999"
			@Li ,051 Psay nmquadp Picture "@E 999,999.99"
			@Li ,064 Psay ntotbp / nmquadp Picture "@E 999.99"
			@Li ,071 Psay ntotbp Picture "@E 9,999,999.99"
			@Li ,085 Psay nicmp Picture "@E 999,999.99"
			@Li ,096 Psay npisp Picture "@E 999,999.99"
			@Li ,107 Psay ncofp Picture "@E 99,999.99"
			@Li ,117 Psay nliqp Picture "@E 9,999,999.99"
			@Li ,131 Psay nmquadp / nvqp Picture "@E 99.99"
			@Li ,138 Psay (nliqp / nMquadp) Picture "@E 999.99"
			@Li ,157 Psay nfretep Picture "@E 99,999.99"
			@Li ,168 Psay nicmfretp Picture "@E 9,999.99"
			@Li ,176 Psay npisfretp Picture "@E 99,999.99"
			@Li ,186 Psay mcoffretp Picture "@E 99,999.99"
			@Li ,196 Psay nliqfretp Picture "@E 9,999,999.99"
			@Li ,211 Psay (nliqp + nliqfretp) / nMquadp Picture "@E 99,999.99"
			li++
			//		@Li ,  0 PSay __PrtThinLine()
			li++
			nvqfmo+=nvqp; nmquadfmo +=nmquadp; ntotbfmo+=ntotbp; nicmfmo+=nicmp; ncoffmo+=ncofp; npisfmo+=npisp; nliqfmo+=nliqp; nfretefmo+=nfretep; nicmfretfmo+=nicmfretp; npisfretfmo+=npisfretp; mcoffretfmo+=mcoffretp; nliqfretfmo+=nliqfretp
			nvqp:=0; nmquadp :=0; ntotbp:=0; nicmp:=0; ncofp:=0; npisp:=0; nliqp:=0; nfretep:=0; nicmfretp:=0; npisfretp:=0; mcoffretp:=0; nliqfretp:=0
		endif
		if cFornec <> TMP->A2_COD+TMP->A2_LOJA
			@Li ,000 PSay "TOTAL DO FORNECEDOR ---->>>"
			@Li ,043 Psay nvqfmo      Picture "@E 999,999"
			@Li ,051 Psay nmquadfmo   Picture "@E 999,999.99"
			@Li ,064 Psay ntotbfmo / nmquadfmo Picture "@E 999.99"
			@Li ,071 Psay ntotbfmo    Picture "@E 9,999,999.99"
			@Li ,085 Psay nicmfmo     Picture "@E 999,999.99"
			@Li ,096 Psay npisfmo     Picture "@E 999,999.99"
			@Li ,107 Psay ncoffmo     Picture "@E 99,999.99"
			@Li ,117 Psay nliqfmo     Picture "@E 9,999,999.99"
			@Li ,131 Psay nmquadfmo / nvqfmo Picture "@E 99.99"
			@Li ,138 Psay (nliqfmo / nMquadfmo) Picture "@E 999.99"
			@Li ,157 Psay nfretefmo   Picture "@E 99,999.99"
			@Li ,168 Psay nicmfretfmo Picture "@E 9,999.99"
			@Li ,176 Psay npisfretfmo Picture "@E 99,999.99"
			@Li ,186 Psay mcoffretfmo Picture "@E 99,999.99"
			@Li ,196 Psay nliqfretfmo Picture "@E 9,999,999.99"
			@Li ,211 Psay (nliqfmo + nliqfretfmo) / nMquadfmo Picture "@E 99,999.99"
			li++
			@Li ,  0 PSay __PrtThinLine()
			li++
			nContForn++
			nvqtmo+=nvqfmo; nmquadtmo +=nmquadfmo; ntotbtmo+=ntotbfmo; nicmtmo+=nicmfmo; ncoftmo+=ncoffmo; npistmo+=npisfmo; nliqtmo+=nliqfmo; nfretetmo+=nfretefmo; nicmfrettmo+=nicmfretfmo; npisfrettmo+=npisfretfmo; mcoffrettmo+=mcoffretfmo; nliqfrettmo+=nliqfretfmo
			nmquadfmo :=0; ntotbfmo:=0; nicmfmo:=0; ncoffmo:=0; npisfmo:=0; nliqfmo:=0; nfretefmo:=0; nicmfretfmo:=0; npisfretfmo:=0; mcoffretfmo:=0; nliqfretfmo:=0
		endif
	else //Se o Produto For Mao de Obra o sistema já pula para o proximo...
		TMP->(dbSkip())
	endif //Fim da Rotina que testa se o produto é Mao de OBRA
	
enddo


if Li > 60
	Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
EndIf
@Li ,000 PSay "TOTAL GERAL MATERIA PRIMA ---->>>> "
@Li ,043 Psay nvqt + nvqf         Picture "@E 999,999"
@Li ,051 Psay nmquadt + nmquadf   Picture "@E 999,999.99"
@Li ,064 Psay (ntotbt+ntotbf) / (nmquadt+nmquadf) Picture "@E 999.99"
@Li ,071 Psay ntotbt+ntotbf       Picture "@E 9,999,999.99"
@Li ,085 Psay nicmt+nicmf         Picture "@E 999,999.99"
@Li ,096 Psay npist+npisf         Picture "@E 999,999.99"
@Li ,107 Psay ncoft+ncoff         Picture "@E 99,999.99"
@Li ,117 Psay nliqt+nliqf         Picture "@E 9,999,999.99"
@Li ,131 Psay (nmquadt + nmquadf) / (nvqt + nvqf) Picture "@E 99.99"
@Li ,138 Psay ((nliqt+nliqf) / (nMquadt+nmquadf)) Picture "@E 999.99"
@Li ,157 Psay nfretet+nfretef     Picture "@E 99,999.99"
@Li ,168 Psay nicmfrett+nicmfretf Picture "@E 9,999.99"
@Li ,176 Psay npisfrett+npisfretf Picture "@E 99,999.99"
@Li ,186 Psay mcoffrett+mcoffretf Picture "@E 99,999.99"
@Li ,196 Psay nliqfrett+nliqfretf Picture "@E 9,999,999.99"
@Li ,211 Psay ((nliqt+nliqf) + (nliqfrett+nliqfretf)) / (nMquadt+nMquadf) Picture "@E 99,999.99"

Li++

if nmquadtk > 0 //Teste se há movimentação em KG
	@Li ,000 PSay "TOTAL GERAL MATERIA PRIMA (QUILOS)---->>>> "
	@Li ,043 Psay nvqtk      Picture "@E 999,999"
	@Li ,051 Psay nmquadtk   Picture "@E 999,999.99"
	@Li ,064 Psay ntotbtk / nmquadtk Picture "@E 999.99"
	@Li ,071 Psay ntotbtk    Picture "@E 9,999,999.99"
	@Li ,085 Psay nicmtk     Picture "@E 999,999.99"
	@Li ,096 Psay npistk     Picture "@E 999,999.99"
	@Li ,107 Psay ncoftk     Picture "@E 99,999.99"
	@Li ,117 Psay nliqtk     Picture "@E 9,999,999.99"
	@Li ,131 Psay nmquadtk / nvqtk  Picture "@E 99.99"
	@Li ,138 Psay nliqtk / nMquadtk Picture "@E 999.99"
	@Li ,157 Psay nfretetk   Picture "@E 99,999.99"
	@Li ,168 Psay nicmfrettk Picture "@E 9,999.99"
	@Li ,176 Psay npisfrettk Picture "@E 99,999.99"
	@Li ,186 Psay mcoffrettk Picture "@E 99,999.99"
	@Li ,196 Psay nliqfrettk Picture "@E 9,999,999.99"
	@Li ,211 Psay (nliqtk + nliqfrettk) / nMquadtk Picture "@E 99,999.99"
	li++
endif


@Li ,000 PSay "TOTAL GERAL MAO-DE-OBRA ---->>>> "
@Li ,043 Psay nvqtmo      Picture "@E 999,999"
@Li ,051 Psay nmquadtmo   Picture "@E 999,999.99"
@Li ,064 Psay (ntotbtmo) / (nmquadtmo) Picture "@E 999.99"
@Li ,071 Psay ntotbtmo    Picture "@E 9,999,999.99"
@Li ,085 Psay nicmtmo     Picture "@E 999,999.99"
@Li ,096 Psay npistmo     Picture "@E 999,999.99"
@Li ,107 Psay ncoftmo     Picture "@E 99,999.99"
@Li ,117 Psay nliqtmo     Picture "@E 9,999,999.99"
@Li ,131 Psay nmquadtmo / nvqtmo Picture "@E 99.99"
@Li ,138 Psay (nliqtmo / nMquadtmo) Picture "@E 999.99"
@Li ,157 Psay nfretetmo   Picture "@E 99,999.99"
@Li ,168 Psay nicmfrettmo Picture "@E 9,999.99"
@Li ,176 Psay npisfrettmo Picture "@E 99,999.99"
@Li ,186 Psay mcoffrettmo Picture "@E 99,999.99"
@Li ,196 Psay nliqfrettmo Picture "@E 9,999,999.99"
@Li ,211 Psay (nliqtmo + nliqfrettmo) / nMquadtmo Picture "@E 99,999.99"

Li++
@Li , 0  Psay __PrtThinLine()
Li++
@Li ,000 PSay "TOTAL GERAL ---->>>> "
@Li ,043 Psay nvqtmo + nvqt + nvqtk + nvqf Picture "@E 999,999"
@Li ,051 Psay nmquadtmo + nmquadt + nmquadtk + nmquadf Picture "@E 999,999.99"
@Li ,064 Psay (ntotbtmo+ntotbtk+ntotbt+ntotbf) / (nmquadtmo+nmquadt+nmquadtk+nmquadf) Picture "@E 999.99"
@Li ,071 Psay ntotbtmo+ntotbtk+ntotbt+ntotbf Picture "@E 9,999,999.99"
@Li ,085 Psay nicmtmo+nicmtk+nicmt+nicmf Picture "@E 999,999.99"
@Li ,096 Psay npistmo+npistk+npist+npisf Picture "@E 999,999.99"
@Li ,107 Psay ncoftmo+ncoftk+ncoft+ncoff Picture "@E 99,999.99"
@Li ,117 Psay nliqtmo+nliqtk+nliqt+nliqf Picture "@E 9,999,999.99"
@Li ,131 Psay (nmquadtmo + nmquadtk + nmquadt + nmquadf) / (nvqtmo + nvqt + nvqtk + nvqf) Picture "@E 99.99"
@Li ,138 Psay ((nliqtmo+nliqtk+nliqt+nliqf) / (nMquadtmo+nMquadt+nMquadtk+nmquadf)) Picture "@E 999.99"
@Li ,157 Psay nfretetmo+nfretetk+nfretet+nfretef Picture "@E 99,999.99"
@Li ,168 Psay nicmfrettmo+nicmfrett+nicmfrettk+nicmfretf Picture "@E 9,999.99"
@Li ,176 Psay npisfrettmo+npisfrettk+npisfrett+npisfretf Picture "@E 99,999.99"
@Li ,186 Psay mcoffrettmo+mcoffrett+mcoffrettk+mcoffretf Picture "@E 99,999.99"
@Li ,196 Psay nliqfrettmo+nliqfrett+nliqfrettk+nliqfretf Picture "@E 9,999,999.99"
@Li ,211 Psay ((nliqtmo+nliqtk+nliqt+nliqf) + (nliqfrettmo+nliqfrettk+nliqfrett+nliqfretf)) / (nMquadtmo+nMquadt+nMquadtk+nMquadf) Picture "@E 99,999.99"

If MV_PAR10 == 1 // Imprimir Resumo

	nmquad    := 0
	nvqp      := 0
	ntotbp    := 0
	nicmp     := 0
	ncofp     := 0
	npisp     := 0
	nliqp     := 0
	nfretep   := 0
	nicmfretp := 0
	npisfretp := 0
	mcoffretp := 0
	nliqfretp := 0

	nmquad1   := 0
	nvqp1     := 0
	ntotbp1   := 0
	nicmp1    := 0
	ncofp1    := 0
	npisp1    := 0
	nliqp1    := 0
	nfretep1  := 0
	nicmfretp1:= 0
	npisfretp1:= 0
	mcoffretp1:= 0
	nliqfretp1:= 0
	
	//Imprimir Totais de Produtos em Quilo...
	nmquadk    := 0
	nvqpk      := 0
	ntotbpk    := 0
	nicmpk     := 0
	ncofpk     := 0
	npispk     := 0
	nliqpk     := 0
	nfretepk   := 0
	nicmfretpk := 0
	npisfretpk := 0
	mcoffretpk := 0
	nliqfretpk := 0
	
	Cabec("RESUMO GERAL",cabec3,cabec4,nomeprog,tamanho,nTipo)
	
	@Li, 000 PSay "RESUMO GERAL"
	Li++
	cFornec:= ""
	dbSelectArea("RES")
	dbGotop()
	While !RES->(eof())
		
		If cFornec <> RES->A2_COD
			@Li ,000 Psay Substr(RES->A2_NOME,1,50)+" "+RES->A2_COD+"-"+RES->A2_LOJA
			@Li ,065 Psay "UF: "+RES->D1_UF
			cFornec := RES->A2_COD
			Li++
		EndIf

		@Li ,002 Psay Substr(RES->B1_DESC,1,32)+" UM:"+RES->B1_UM
		@Li ,042 Psay RES->VAQTA              Picture "@E 999,999"
		@Li ,050 Psay RES->MQUAD              Picture "@E 9,999,999.99"
		@Li ,064 Psay RES->(D1_TOTAL/MQUAD)   Picture "@E 999.99"
		@Li ,071 Psay RES->D1_TOTAL           Picture "@E 99,999,999.99"
		@Li ,086 Psay RES->D1_VICMS           Picture "@E 999,999.99"
		@Li ,098 Psay RES->D1_VPIS            Picture "@E 999,999.99"
		@Li ,110 Psay RES->D1_VCOFINS         Picture "@E 999,999.99"
		@Li ,122 Psay RES->D1_TOTALIQ         Picture "@E 99,999,999.99"
		@Li ,137 Psay RES->MQUAD / RES->VAQTA Picture "@E 99.99"
		@Li ,144 Psay RES->D1_TOTALIQ / RES->MQUAD Picture "@E 999.99"
		@Li ,152 Psay RES->D1_VFRETE          Picture "@E 999,999.99"
		@Li ,164 Psay RES->D1_VICMFRT         Picture "@E 99,999.99"
		@Li ,175 Psay RES->D1_VPISFRT         Picture "@E 999,999.99"
		@Li ,186 Psay RES->D1_VCOFFRT         Picture "@E 999,999.99"
		@Li ,197 Psay RES->D1_VLIQFRT         Picture "@E 99,999,999.99"
		@Li ,213 PSay (RES->D1_VLIQFRT+RES->D1_TOTALIQ)/RES->MQUAD Picture "@E 99.99"
		Li++
		
		if Li > 60
			Cabec(titulo,cabec3,cabec4,nomeprog,tamanho,nTipo)
		EndIf
		if RES->B1_UM <> 'KG'
			nmquad    += RES->MQUAD
			nvqp      += RES->VAQTA
			ntotbp    += RES->D1_TOTAL
			nicmp     += RES->D1_VICMS
			ncofp     += RES->D1_VCOFINS
			npisp     += RES->D1_VPIS
			nliqp     += RES->D1_TOTALIQ
			nfretep   += RES->D1_VFRETE
			nicmfretp += RES->D1_VICMFRT
			npisfretp += RES->D1_VPISFRT
			mcoffretp += RES->D1_VCOFFRT
			nliqfretp += RES->D1_VLIQFRT
			
			nmquad1    += RES->MQUAD
			nvqp1      += RES->VAQTA
			ntotbp1    += RES->D1_TOTAL
			nicmp1     += RES->D1_VICMS
			ncofp1     += RES->D1_VCOFINS
			npisp1     += RES->D1_VPIS
			nliqp1     += RES->D1_TOTALIQ
			nfretep1   += RES->D1_VFRETE
			nicmfretp1 += RES->D1_VICMFRT
			npisfretp1 += RES->D1_VPISFRT
			mcoffretp1 += RES->D1_VCOFFRT
			nliqfretp1 += RES->D1_VLIQFRT
		else
			nmquadk    += RES->MQUAD
			nvqpk      += RES->VAQTA
			ntotbpk    += RES->D1_TOTAL
			nicmpk     += RES->D1_VICMS
			ncofpk     += RES->D1_VCOFINS
			npispk     += RES->D1_VPIS
			nliqpk     += RES->D1_TOTALIQ
			nfretepk   += RES->D1_VFRETE
			nicmfretpk += RES->D1_VICMFRT
			npisfretpk += RES->D1_VPISFRT
			mcoffretpk += RES->D1_VCOFFRT
			nliqfretpk += RES->D1_VLIQFRT
		endif
		
		RES->(dbSkip())
		If cFornec <> RES->A2_COD
			
			@Li ,000 Psay "TOTAL DO FORNECEDOR-->> "
			@Li ,042 Psay nvqp1 Picture "@E 999,999"
			@Li ,050 Psay nmquad1 Picture "@E 9,999,999.99"
			@Li ,064 Psay ntotbp1/nmquad1 Picture "@E 999.99"
			@Li ,071 Psay ntotbp1 Picture "@E 99,999,999.99"
			@Li ,086 Psay nicmp1 Picture "@E 999,999.99"
			@Li ,098 Psay npisp1 Picture "@E 999,999.99"
			@Li ,110 Psay ncofp1 Picture "@E 999,999.99"
			@Li ,122 Psay nliqp1 Picture "@E 99,999,999.99"
			@Li ,137 Psay nmquad1 / nvqp1 Picture "@E 99.99"
			@Li ,144 Psay nliqp1 / nmquad1 Picture "@E 999.99"
			@Li ,152 Psay nfretep1 Picture "@E 999,999.99"
			@Li ,164 Psay nicmfretp1 Picture "@E 99,999.99"
			@Li ,175 Psay npisfretp1 Picture "@E 999,999.99"
			@Li ,186 Psay mcoffretp1 Picture "@E 999,999.99"
			@Li ,197 Psay nliqfretp1 Picture "@E 99,999,999.99"
			@Li ,213 Psay (nliqp1+nliqfretp1) / nmquad1 Picture "@E 99.99"
			Li++
			
			if ntotbpk > 0 //Se houver produto em Quilos no Resumo....
				@Li ,000 Psay "TOTAL DO FORNECEDOR (QUILOS)--> "
				@Li ,042 Psay nvqpk Picture "@E 999,999"
				@Li ,050 Psay nmquadk Picture "@E 9,999,999.99"
				@Li ,064 Psay ntotbpk/nmquadk Picture "@E 999.99"
				@Li ,071 Psay ntotbpk Picture "@E 99,999,999.99"
				@Li ,086 Psay nicmpk Picture "@E 999,999.99"
				@Li ,098 Psay npispk Picture "@E 999,999.99"
				@Li ,110 Psay ncofpk Picture "@E 999,999.99"
				@Li ,122 Psay nliqpk Picture "@E 99,999,999.99"
				@Li ,137 Psay nmquadk / nvqpk Picture "@E 99.99"
				@Li ,144 PSay nliqpk/nmquadk Picture "@E 999.99"
				@Li ,152 Psay nfretepk Picture "@E 999,999.99"
				@Li ,164 Psay nicmfretpk Picture "@E 99,999.99"
				@Li ,175 Psay npisfretpk Picture "@E 999,999.99"
				@Li ,186 Psay mcoffretpk Picture "@E 999,999.99"
				@Li ,197 Psay nliqfretpk Picture "@E 99,999,999.99"
				@Li ,213 Psay (nliqpk+nliqfretpk)  / nMquadk Picture "@E 99.99"
				
				//Zerar variáveis de totais de Produtos em Quilo...
				nmquadk    := 0
				nvqpk      := 0
				ntotbpk    := 0
				nicmpk     := 0
				ncofpk     := 0
				npispk     := 0
				nliqpk     := 0
				nfretepk   := 0
				nicmfretpk := 0
				npisfretpk := 0
				mcoffretpk := 0
				nliqfretpk := 0
			EndIf
			
			@Li , 0 Psay __PrtThinLine()
			li++
			nmquad1   := 0
			nvqp1     := 0
			ntotbp1   := 0
			nicmp1    := 0
			ncofp1    := 0
			npisp1    := 0
			nliqp1    := 0
			nfretep1  := 0
			nicmfretp1:= 0
			npisfretp1:= 0
			mcoffretp1:= 0
			nliqfretp1:= 0
		EndIf
		
	EndDo
	
	@Li ,  0 Psay __PrtThinLine()
	Li++
	@Li,   0 Psay "TOTAL DO RESUMO DE MATERIA PRIMA --->>> "
	@Li ,042 Psay nvqp Picture "@E 999,999"
	@Li ,050 Psay nmquad  Picture "@E 9,999,999.99"
	@Li ,064 Psay ntotbp/nmquad Picture "@E 999.99"
	@Li ,071 Psay ntotbp   Picture "@E 99,999,999.99"
	@Li ,086 Psay nicmp    Picture "@E 999,999.99"
	@Li ,098 Psay npisp    Picture "@E 999,999.99"
	@Li ,110 Psay ncofp    Picture "@E 999,999.99"
	@Li ,122 Psay nliqp    Picture "@E 99,999,999.99"
	@Li ,137 Psay nmquad / nvqp Picture "@E 99.99"
	@Li ,144 Psay ((nliqt+nliqf) / (nMquadt+nmquadf)) Picture "@E 999.99"
	//		@Li ,119 Psay RES->MQUAD / RES->VAQTA Picture "@E 99.99"
	//		@Li ,126 Psay RES->D1_TOTALIQ / RES->MQUAD Picture "@E 999.99"
	@Li ,152 Psay nfretep   Picture "@E 999,999.99"
	@Li ,164 Psay nicmfretp Picture "@E 99,999.99"
	@Li ,175 Psay npisfretp Picture "@E 999,999.99"
	@Li ,186 Psay mcoffretp Picture "@E 999,999.99"
	@Li ,197 Psay nliqfretp Picture "@E 99,999,999.99"
	@Li ,213 Psay ((nliqt+nliqf) + (nliqfrett+nliqfretf)) / (nMquadt+nMquadf) Picture "@E 99.99"
	
	Li++
	
	if nmquadtk > 0 //Teste se há movimentação em KG
		@Li ,000 PSay "TOTAL RESUMO MATERIA PRIMA (QUILOS)-> "
		@Li ,042 Psay nvqtk      Picture "@E 999,999"
		@Li ,050 Psay nmquadtk   Picture "@E 9,999,999.99"
		@Li ,064 Psay ntotbtk / nmquadtk Picture "@E 999.99"
		@Li ,071 Psay ntotbtk    Picture "@E 99,999,999.99"
		@Li ,086 Psay nicmtk     Picture "@E 999,999.99"
		@Li ,098 Psay npistk     Picture "@E 999,999.99"
		@Li ,110 Psay ncoftk     Picture "@E 999,999.99"
		@Li ,122 Psay nliqtk     Picture "@E 99,999,999.99"
		@Li ,137 Psay nmquadtk / nvqtk Picture "@E 99.99"
		@Li ,144 Psay nliqtk / nMquadtk Picture "@E 999.99"
		@Li ,152 Psay nfretetk   Picture "@E 999,999.99"
		@Li ,164 Psay nicmfrettk Picture "@E 99,999.99"
		@Li ,175 Psay npisfrettk Picture "@E 999,999.99"
		@Li ,186 Psay mcoffrettk Picture "@E 999,999.99"
		@Li ,197 Psay nliqfrettk Picture "@E 99,999,999.99"
		@Li ,213 Psay (nliqtk + nliqfrettk) / nMquadtk Picture "@E 99.99"
		li++
	endif
	@Li ,000 PSay "TOTAL DO RESUMO DE MAO-DE-OBRA ---->>>> "
	@Li ,042 Psay nvqtmo    Picture "@E 999,999"
	@Li ,050 Psay nmquadtmo Picture "@E 9,999,999.99"
	@Li ,064 Psay ntotbtmo/nmquadtmo Picture "@E 999.99"
	@Li ,071 Psay ntotbtmo  Picture "@E 99,999,999.99"
	@Li ,086 Psay nicmtmo   Picture "@E 999,999.99"
	@Li ,098 Psay npistmo   Picture "@E 999,999.99"
	@Li ,110 Psay ncoftmo   Picture "@E 999,999.99"
	@Li ,122 Psay nliqtmo   Picture "@E 99,999,999.99"
	@Li ,137 Psay nmquadtmo / nvqtmo Picture "@E 99.99"
	@Li ,144 Psay (nliqtmo / nMquadtmo) Picture "@E 999.99"
	//		@Li ,119 Psay RES->MQUAD / RES->VAQTA Picture "@E 99.99"
	//		@Li ,126 Psay RES->D1_TOTALIQ / RES->MQUAD Picture "@E 999.99"
	@Li ,152 Psay nfretetmo   Picture "@E 999,999.99"
	@Li ,164 Psay nicmfrettmo Picture "@E 99,999.99"
	@Li ,175 Psay npisfrettmo Picture "@E 999,999.99"
	@Li ,186 Psay mcoffrettmo Picture "@E 999,999.99"
	@Li ,197 Psay nliqfrettmo Picture "@E 99,999,999.99"
	@Li ,213 Psay (nliqtmo + nliqfrettmo) / nMquadtmo Picture "@E 99.99"
	
	Li++
	@Li , 0  Psay __PrtThinLine()
	Li++
	@Li ,000 PSay "TOTAL GERAL DO RESUMO---->>>> "
	@Li ,042 Psay nvqtmo + nvqt + nvqtk + nvqf Picture "@E 999,999"
	@Li ,050 Psay nmquadtmo + nmquadt  + nmquadtk + nmquadf Picture "@E 9,999,999.99"
	@Li ,064 Psay (ntotbtmo+ntotbt+ntotbtk+ntotbf)/(nmquadtmo + nmquadt + nmquadtk + nmquadf) Picture "@E 999.99"
	@Li ,071 Psay ntotbtmo+ntotbt+ntotbtk+ntotbf Picture "@E 99,999,999.99"
	@Li ,086 Psay nicmtmo+nicmt+nicmtk+nicmf Picture "@E 999,999.99"
	@Li ,098 Psay npistmo+npist+npistk+npisf Picture "@E 999,999.99"
	@Li ,110 Psay ncoftmo+ncoft+ncoftk+ncoff Picture "@E 999,999.99"
	@Li ,122 Psay nliqtmo+nliqt+nliqtk+nliqf Picture "@E 99,999,999.99"
	@Li ,137 Psay (nmquadtmo + nmquadt + nmquadtk + nmquadf) / (nvqtmo + nvqt + nvqtk + nvqf) Picture "@E 99.99"
	@Li ,144 Psay ((nliqtmo+nliqt+nliqtk+nliqf) / (nMquadtmo+nMquadt+nMquadtk+nmquadf)) Picture "@E 999.99"
	//		@Li ,119 Psay RES->MQUAD / RES->VAQTA Picture "@E 99.99"
	//		@Li ,126 Psay RES->D1_TOTALIQ / RES->MQUAD Picture "@E 999.99"
	@Li ,152 Psay nfretetmo+nfretet+nfretetk+nfretef Picture "@E 999,999.99"
	@Li ,164 Psay nicmfrettmo+nicmfrett+nicmfrettk+nicmfretf Picture "@E 99,999.99"
	@Li ,175 Psay npisfrettmo+npisfrett+npisfrettk+npisfretf Picture "@E 999,999.99"
	@Li ,186 Psay mcoffrettmo+mcoffrett+mcoffrettk+mcoffretf Picture "@E 999,999.99"
	@Li ,197 Psay  nliqfrettmo+nliqfrett+nliqfrettk+nliqfretf Picture "@E 99,999,999.99"
	@Li ,213 Psay ((nliqtmo+nliqt+nliqtk+nliqf) + (nliqfrettmo+nliqfrett+nliqfrettk+nliqfretf)) / (nMquadtmo+nMquadt+nMquadtk+nMquadf) Picture "@E 99.99"
EndIf

If Li != 80
	Roda(cbcont,cbtxt)
EndIf

If aReturn[5] == 1
	Set Printer To
	OurSpool(wnrel)
EndIf

MS_FLUSH()
Return NIL



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Anesio G.Faria -    ³    18.10.2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aArea := GetArea()
PutSx1(cPerg,"01","Periodo de      ?"," "," ","mv_ch1","D",8,0,0, "G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo inicial"},{"Informe o periodo inicial"},{"Informe o periodo inicial"})
PutSx1(cPerg,"02","Periodo ate     ?"," "," ","mv_ch2","D",8,0,0, "G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo final"},{"Informe o periodo final"},{"Informe o periodo final"})
PutSx1(cPerg,"03","Grupos          ?"," "," ","mv_ch3","C",40,0,0,"G","","   ","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe os grupos a serem filtrados, separado por ; ou /, sem espaços entre os grupos"},{"Informe os grupos a serem filtrados, separado por ; ou /"},{"Informe os grupos a serem filtrados, separado por ; ou /"})
PutSx1(cPerg,"04","Produto de      ?"," "," ","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto inicial"},{"Informe o produto inicial"},{"Informe o produto inicial"})
PutSx1(cPerg,"05","Produto ate     ?"," "," ","mv_ch5","C",15,0,0,"G","","SB1","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto final"},{"Informe o produto final"},{"Informe o produto final"})
PutSx1(cPerg,"06","Fornecedor de   ?"," "," ","mv_ch6","C",6,0,0, "G","","SA2","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o fornecedor inicial"},{"Informe o fornecedor inicial"},{"Informe o fornecedor inicial"})
PutSx1(cPerg,"07","Fornecedor ate  ?"," "," ","mv_ch7","C",6,0,0, "G","","SA2","","","mv_par07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o fornecedor final"},{"Informe o fornecedor final"},{"Informe o fornecedor final"})
PutSx1(cPerg,"08","Loja de         ?"," "," ","mv_ch8","C",2,0,0, "G","","   ","","","mv_par08"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a loja do fornecedor inicial"},{"Informe a loja do fornecedor inicial"},{"Informe a loja do fornecedor inicial"})
PutSx1(cPerg,"09","Loja ate        ?"," "," ","mv_ch9","C",2,0,0, "G","","   ","","","mv_par09"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a loja do fornecedor final"},{"Informe a loja do fornecedor final"},{"Informe a loja do fornecedor final"})
PutSx1(cPerg,"10","Imprimir Resumo ?"," "," ","mv_cha","N",1,0,2, "C","","   ","","","mv_par10","Sim","Si","Yes", " ","Nao","No","No"," "," "," ", " "," "," "," ",	" ","",{"Imprimir resumo ao final do relatorio"},{"Imprimir resumo ao final do relatorio"},{"Imprimir resumo ao final do relatorio"})
RestArea(aArea)
Return


User Function GeraArqExcel()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cQuery    := "",cIndex := CriaTrab("",.F.),nIndex:=0
Local cAliasQry := GetNextAlias()
//Local cQrySD1  := GetNextAlias()
Local aCampos   := {}
Local aCposSF8  := {}
Local cAliasSF8 := GetNextAlias()
Local cQuerySF8 := ""
Local cDocAnt   := ""
Local nDocAnt   := 2
Local i         := 0
Local cGrupo    := ""
Local nContRep  :=0

//Tabela temporária para gravar SF8 - Esta tabela existe por nao haver possibilidade
//	de criar um mecanismo de buscas das notas fiscais de frete quando há mais de uma NF amarrada a mesma nota fiscal de frete
AADD(aCposSF8, {"F8_NFDIFRE", "C",  9})
AADD(aCposSF8, {"F8_SEDIFRE", "C",  3})
AADD(aCposSF8, {"F8_TRANSP",  "C",  6})
AADD(aCposSF8, {"F8_LOJTRAN", "C",  2})
AADD(aCposSF8, {"F8_FORNECE", "C",  6})
AADD(aCposSF8, {"F8_LOJA",    "C",  2})
AADD(aCposSF8, {"F8_ITEM",    "C",  4})
AADD(aCposSF8, {"F8_NFORIG",  "C",  9})
AADD(aCposSF8, {"F8_SERORIG", "C",  3})

cNomeSF8 := CriaTrab(aCposSF8,.T.)
If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea("TRB")
Endif
dbUseArea(.T.,,cNomeSF8,"TRB",Nil,.F.)

cQuerySF8 := " SELECT F8_NFDIFRE, F8_SEDIFRE, F8_TRANSP, F8_LOJTRAN, F8_NFORIG, F8_SERORIG, F8_FORNECE, F8_LOJA "
cQuerySF8 += " FROM " + RetSQLName( "SF8" ) + " SF8, "  + RetSQLName( "SD1") + " SD1 "
cQuerySF8 += " WHERE "
cQuerySF8 += " SF8.F8_FILIAL = '"+xFilial("SF8") + "' "
cQuerySF8 += " AND SD1.D1_FILIAL = '"+xFilial("SD1") + "' "
cQuerySF8 += " AND SD1.D_E_L_E_T_ <> '*' "
cQuerySF8 += " AND SF8.D_E_L_E_T_ <> '*' "
cQuerySF8 += " AND D1_DOC = F8_NFDIFRE "
cQuerySF8 += " AND D1_SERIE = F8_SEDIFRE "
cQuerySF8 += " AND D1_FORNECE = F8_TRANSP "
cQuerySF8 += " AND D1_LOJA = F8_LOJTRAN "
cQuerySF8 += " AND SF8.F8_TIPO = 'F' "
cQuerySF8 += " ORDER BY F8_NFDIFRE, F8_SEDIFRE, F8_TRANSP, F8_LOJTRAN "

If Select(cAliasSF8) > 0
	DbSelectArea(cAliasSF8)
	DbCloseArea()
EndIf

cQuerySF8 := ChangeQuery(cQuerySF8)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuerySF8),cAliasSF8, .F., .T.)

//Gravar na tabela intermediária....
nDocAnt:=1
cDocAnt:=""
dbGotop()
While !(cAliasSF8)->(EoF())
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->F8_NFDIFRE := (cAliasSF8)->F8_NFDIFRE
	TRB->F8_SEDIFRE := (cAliasSF8)->F8_SEDIFRE
	TRB->F8_TRANSP  := (cAliasSF8)->F8_TRANSP
	TRB->F8_LOJTRAN := (cAliasSF8)->F8_LOJTRAN
	TRB->F8_FORNECE := (cAliasSF8)->F8_FORNECE
	TRB->F8_LOJA    := (cAliasSF8)->F8_LOJA
	TRB->F8_NFORIG  := (cAliasSF8)->F8_NFORIG
	TRB->F8_SERORIG := (cAliasSF8)->F8_SERORIG
	
	if cDocAnt == (cAliasSF8)->F8_NFDIFRE+(cAliasSF8)->F8_SEDIFRE
		//		alert("Gravando ITEM DIFERENTE..."+(cAliasSF8)->F8_NFDIFRE+" VALOR: " +cValToChar(nDocAnt))
		if nDocAnt == 2
			TRB->F8_ITEM := '0002'
		elseif nDocAnt == 3
			TRB->F8_ITEM := '0003'
		elseif nDocAnt== 4
			TRB->F8_ITEM := '0004'
		elseif nDocAnt== 5
			TRB->F8_ITEM := '0005'
		elseif nDocAnt== 6
			TRB->F8_ITEM := '0006'
		endif
	else
		TRB->F8_ITEM := '0001'
		nDocAnt:=1
	endif
	nDocAnt++
	nContRep++
	TRB->(MsUnLock())
	cDocAnt := (cAliasSF8)->F8_NFDIFRE+(cAliasSF8)->F8_SEDIFRE
	(cAliasSF8)->(dbSkip())
enddo
//msgbox("Gravado arquivo SF8 com sucesso... Repedito ->"+cValToChar(nContRep)+" Registros...")

//Tabela temporária para gravar as informacoes, depois jogar para relatório ou exportar para Excel....
AADD(aCampos, {"D1_DOC",       "C",  9})
AADD(aCampos, {"D1_SERIE",     "C",  3})
AADD(aCampos, {"D1_ITEM",      "C",  3})
AADD(aCampos, {"D1_ENTRADA",   "D",  8})
AADD(aCampos, {"D1_EMISSAO",   "D",  8})
AADD(aCampos, {"E1_VENCTO",    "D",  8})
AADD(aCampos, {"D1_UF",        "C",  2})
AADD(aCampos, {"B1_COD",       "C", 15})
AADD(aCampos, {"B1_DESC",      "C", 60})
AADD(aCampos, {"A2_COD",       "C",  6})
AADD(aCampos, {"A2_LOJA",      "C",  2})
AADD(aCampos, {"A2_NOME",      "C", 60})
AADD(aCampos, {"B1_TIPO",      "C", 15})
AADD(aCampos, {"B1_UM",        "C",  2})
AADD(aCampos, {"QUILO",        "N", 18,6})
AADD(aCampos, {"VAQTA",        "N", 18,6})
AADD(aCampos, {"MQUAD",        "N", 18,6})
AADD(aCampos, {"PEQUAD",       "N", 18,6})
AADD(aCampos, {"D1_VUNIT",     "N", 18,6})
AADD(aCampos, {"D1_TOTAL",     "N", 18,6})
AADD(aCampos, {"D1_VICMS",     "N", 18,6})
AADD(aCampos, {"D1_VPIS",      "N", 18,6})
AADD(aCampos, {"D1_VCOFINS",   "N", 18,6})
AADD(aCampos, {"D1_TOTALIQ",   "N", 18,6})
AADD(aCampos, {"D1_MMTVQTA",   "N", 18,6}) //Media de Metragem por Vaquetas
AADD(aCampos, {"D1_VUNITLQ",   "N", 18,6})
AADD(aCampos, {"D1_CONHECF",   "C",  9}) //Numero do conhecimento de frete
AADD(aCampos, {"D1_SERFRET",   "C",  3}) //Numero da serie do conhecimento de frete
AADD(aCampos, {"D1_FORFRET",   "C",  6})
AADD(aCampos, {"D1_LOJFRET",   "C",  2})
AADD(aCampos, {"D1_VFRETE",    "N", 18,6}) //Valor do Frete
AADD(aCampos, {"D1_VICMFRT",   "N", 18,6}) //Valor ICMS Frete
AADD(aCampos, {"D1_VPISFRT",   "N", 18,6}) //Valor PIS Frete
AADD(aCampos, {"D1_LOTECTL",   "C", 10}) //LOTE DO PRODUTO
AADD(aCampos, {"D1_VCOFFRT",   "N", 18,6}) //Valor COFINS Frete
AADD(aCampos, {"D1_VLIQFRT",   "N", 18,6}) //Valor Total Liquido do Frete
AADD(aCampos, {"D1_VUNIFRT",   "N", 18,6}) //Valor Unitário por M² incluso no Frete

cNome := CriaTrab(aCampos,.T.)
If (Select("TMP") <> 0)
	dbSelectArea("TMP")
	dbCloseArea("TMP")
Endif
dbUseArea(.T.,,cNome,"TMP",Nil,.F.)

cGrupo := "'"
for i:=1 to 40
	if Substr(mv_par03,i,1) == ';' .or. Substr(mv_par03,i,1) == '/'
		cGrupo:= cGrupo+"','"
	elseif Substr(mv_par03,i,1) <> " "
		cGrupo:= cGrupo+Substr(mv_par03,i,1)
	endif
	if Substr(mv_par03,i,1) == " "
		cGrupo := cGrupo + "'"
		i:= 40
	endif
next

//alert("Variavel Grupo -> "+cGrupo)
//cQuery := "SELECT D1_FORNECE, D1_LOJA, D1_ITEM, D1_DOC, D1_SERIE, D1_FILIAL, D1_EMISSAO, D1_DTDIGIT, D1_COD, D1_X_DESCR, D1_TIPOCOU, "
cQuery := "SELECT D1_FORNECE, D1_LOJA, F1_TIPO, D1_ITEM, D1_DOC, D1_SERIE, D1_FILIAL, D1_EMISSAO, D1_DTDIGIT, D1_COD, D1_X_DESCR, D1_TIPOCOU, " //AOliveira 05-07-2011 Chamado 003535 Inclusão do campo "F1_TIPO"
cQuery += "D1_QUANT, D1_NVQTAS, D1_QUILOS, D1_VUNIT, D1_TOTAL, D1_VALICM, D1_VALIMP5, D1_VALIMP6, D1_VALFRE , " // VALIMP5 = PIS, VALIMP6 = COFINS
cQuery += "D1_PICM, D1_LOTECTL, D1_BASIMP5, D1_BASIMP6, F1_ESPECIE " // D1_BASIMP5 = BASE PIS, D1_BASIMP6 = BASE COFINS
cQuery += "FROM " + RetSQLName( "SD1" ) + " SD1, " + RetSQLName( "SF1" ) + " SF1 "
cQuery += "WHERE "
cQuery += "SD1.D1_FILIAL = '"+xFilial("SD1") + "' AND SF1.F1_FILIAL = '"+xFilial("SF1") + "' "
cQuery += "AND SD1.D_E_L_E_T_ <> '*' AND SF1.D_E_L_E_T_ <> '*' AND "
cQuery += "SF1.F1_ESPECIE <> 'CTR' AND "
cQuery += "SD1.D1_DOC = SF1.F1_DOC AND SD1.D1_SERIE = SF1.F1_SERIE AND SD1.D1_FORNECE = SF1.F1_FORNECE AND SD1.D1_LOJA = SF1.F1_LOJA AND "
cQuery += "SD1.D1_DTDIGIT BETWEEN '" + dtos(MV_PAR01) + "' AND '" + dtos(MV_PAR02) + "' AND "
//msgbox("DATA--> "+dTos(MV_PAR01)+ " ATÉ "+dTos(MV_PAR02))
cQuery += "SD1.D1_GRUPO in (" + cGrupo + ") AND "
cQuery += "SD1.D1_COD BETWEEN '" + MV_PAR04 + "' AND '"+ MV_PAR05 + "' AND "
cQuery += "SD1.D1_FORNECE BETWEEN '" + MV_PAR06 + "' AND '"+ MV_PAR07 + "' AND "
cQuery += "SD1.D1_LOJA BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' AND "
cQuery += "SD1.D1_DOC + SD1.D1_SERIE + SD1.D1_FORNECE <> '0000265663  001077' AND "
cQuery += "SD1.D1_TES not in ('164','165') "
cQuery += "ORDER BY D1_EMISSAO, D1_COD "

If Select(cAliasQry) > 0
	DbSelectArea(cAliasQry)
	DbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)

TcSetField(cAliasQry, "D1_EMISSAO", "D")
TcSetField(cAliasQry, "D1_DTDIGIT", "D")

DbSelectArea("TRB")
cArquivo := CriaTrab(,.F.)
INDREGUA("TRB",cArquivo,"F8_NFORIG+F8_SERORIG+F8_FORNECE+F8_LOJA+F8_ITEM",,)

//msgbox("Query Gerada.....")
//Gravar na tabela intermediária....
nCont:=0
ncontseq:=0
cItemAnt:= ""
dbGotop()
While !(cAliasQry)->(EoF())
	dbSelectArea("TMP")
	RecLock("TMP",.T.)
	TMP->D1_DOC 		:= (cAliasQry)->D1_DOC
	TMP->D1_SERIE  		:= (cAliasQry)->D1_SERIE
	TMP->D1_ENTRADA		:= (cAliasQry)->D1_DTDIGIT
	TMP->D1_EMISSAO		:= (cAliasQry)->D1_EMISSAO
	dbSelectArea("SE2")
	dbSetOrder(6)
	//			msgbox("Busca -->> "+(cAliasQry)->(D1_FORNECE+D1_LOJA+D1_FILIAL+D1_DOC))
	dbSeek(xFilial("SE2")+(cAliasQry)->(D1_FORNECE+D1_LOJA+D1_FILIAL+' '+D1_DOC))
	TMP->E1_VENCTO      := SE2->E2_VENCREA
	//		TMP->D1_UF          :=  Posicione("SA2",1,xFilial("SA2")+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA, "A2_EST")
	TMP->D1_UF          :=  If((cAliasQry)->F1_TIPO == 'B',Posicione("SA1",1,xFilial("SA1")+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA, "A1_EST"),Posicione("SA2",1,xFilial("SA2")+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA, "A2_EST")) //AOliveira 05-06-11 Chamado 003535
	TMP->B1_COD         := (cAliasQry)->D1_COD
	TMP->B1_DESC        := (cAliasQry)->D1_X_DESCR
	TMP->A2_COD         := (cAliasQry)->D1_FORNECE
	TMP->A2_LOJA        := (cAliasQry)->D1_LOJA
	//		TMP->A2_NOME        := Posicione("SA2",1,xFilial("SA2")+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA, "A2_NOME")
	TMP->A2_NOME        := If((cAliasQry)->F1_TIPO == 'B',Posicione("SA1",1,xFilial("SA1")+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA, "A1_NOME"),Posicione("SA2",1,xFilial("SA2")+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA, "A2_NOME") ) //AOliveira 05-06-11 Chamado 003535
	TMP->B1_UM          := Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->D1_COD, "B1_UM")
	if (cAliasQry)->D1_TIPOCOU == '1'
		TMP->B1_TIPO        := "INTEGRAL"
	elseif (cAliasQry)->D1_TIPOCOU == '2'
		TMP->B1_TIPO        := "DIV TRIPA"
	elseif (cAliasQry)->D1_TIPOCOU == '3'
		TMP->B1_TIPO        := "DIV BLUE"
	else
		TMP->B1_TIPO        := "OUTROS"
	endif
	TMP->QUILO          := (cAliasQry)->D1_QUILOS
	TMP->VAQTA          := (cAliasQry)->D1_NVQTAS
	if Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->D1_COD, "B1_UM") == "M2"
		TMP->MQUAD          := (cAliasQry)->D1_QUANT
		TMP->D1_VUNIT       := (cAliasQry)->((D1_TOTAL+D1_VALFRE)/D1_QUANT)
	elseif Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->D1_COD, "B1_UM") == "P2"
		TMP->PEQUAD         := (cAliasQry)->D1_QUANT
		TMP->MQUAD          := (cAliasQry)->D1_QUANT * 0.092903
		TMP->D1_VUNIT       := (cAliasQry)->((D1_TOTAL+D1_VALFRE)/(D1_QUANT*0.092903))
	else
		TMP->MQUAD          := (cAliasQry)->D1_QUANT
		TMP->D1_VUNIT       := (cAliasQry)->((D1_TOTAL+D1_VALFRE)/D1_QUANT)
	endif
	TMP->D1_TOTAL       := (cAliasQry)->D1_TOTAL + (cAliasQry)->D1_VALFRE
	TMP->D1_VICMS       := (cAliasQry)->D1_VALICM
	TMP->D1_LOTECTL     := (cAliasQry)->D1_LOTECTL
	TMP->D1_VPIS        := (cAliasQry)->D1_VALIMP5
	TMP->D1_VCOFINS     := (cAliasQry)->D1_VALIMP6
	
	
	TMP->D1_TOTALIQ    := ((cAliasQry)->D1_TOTAL+(cAliasQry)->D1_VALFRE) - ((cAliasQry)->D1_VALICM + (cAliasQry)->D1_VALIMP5 + (cAliasQry)->D1_VALIMP6)
	if Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->D1_COD, "B1_UM") == "M2"
		TMP->D1_MMTVQTA 	:= (cAliasQry)->D1_QUANT / (cAliasQry)->D1_NVQTAS	//Media de Metragem por Vaquetas
	endif
	if Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->D1_COD, "B1_UM") == "P2"
		TMP->D1_MMTVQTA 	:= ((cAliasQry)->D1_QUANT * 0.092903) / (cAliasQry)->D1_NVQTAS
	endif
	
	TMP->D1_VUNITLQ    := TMP->D1_TOTALIQ / TMP->MQUAD
	
	if Posicione("SB1",1,xFilial("SB1")+TMP->B1_COD, "B1_TIPO") == 'MO'
		DbSelectArea("SD1")
		cChave := "D1_FILIAL+D1_DOCREFF+D1_SERREFF+D1_FORNREF+D1_LOJREFF"
		cIndSD1 := CriaTrab(Nil,.F.)
		IndRegua("SD1", cIndSD1, cChave, , , "Selecionando Pedidos...")
		if dbSeek(xFilial("SD1")+TMP->(D1_DOC+D1_SERIE+A2_COD+A2_LOJA),.T.)
			TMP->D1_CONHECF := SD1->D1_DOC	//Numero do conhecimento de frete
			TMP->D1_SERFRET := SD1->D1_SERIE
			TMP->D1_FORFRET := SD1->D1_FORNECE
			TMP->D1_LOJFRET := SD1->D1_LOJA
			TMP->D1_VFRETE	:= SD1->D1_TOTAL
			TMP->D1_VICMFRT	:= SD1->D1_VALICM
			TMP->D1_VPISFRT	:= SD1->D1_VALIMP5
			TMP->D1_VCOFFRT	:= SD1->D1_VALIMP6
			TMP->D1_VLIQFRT	:= SD1->D1_TOTAL - (SD1->D1_VALICM+SD1->D1_VALIMP5+SD1->D1_VALIMP6)
		endif
		DbSelectArea( "SD1" ) //Selecionando a area
		DbSetOrder( 1 ) //Posicionando na ordem de origem
		fErase( cIndSD1 + OrdBagExt() ) //Deletando arquivo de trabalho
	else
		DbSelectArea("TRB")
		dbGotop()
		if dbSeek((cAliasQry)->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM))
			dbSelectArea("SD1")
			dbSetOrder(1)
			dbGotop()
			dbSeek(xFilial("SD1")+TRB->(F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN),.T.)
			while !eof().and.SD1->D1_FILIAL == xFilial("SD1").and.SD1->D1_DOC == TRB->F8_NFDIFRE;
				.and.SD1->D1_SERIE == TRB->F8_SEDIFRE.and.SD1->D1_FORNECE == TRB->F8_TRANSP;
				.and.SD1->D1_LOJA == TRB->F8_LOJTRAN
				if TRB->F8_ITEM == SD1->D1_ITEM
					TMP->D1_CONHECF := SD1->D1_DOC	//Numero do conhecimento de frete
					TMP->D1_SERFRET := SD1->D1_SERIE
					TMP->D1_FORFRET := SD1->D1_FORNECE
					TMP->D1_LOJFRET := SD1->D1_LOJA
					TMP->D1_VFRETE	:= SD1->D1_TOTAL
					TMP->D1_VICMFRT	:= SD1->D1_VALICM
					TMP->D1_VPISFRT	:= SD1->D1_VALIMP5
					TMP->D1_VCOFFRT	:= SD1->D1_VALIMP6
					TMP->D1_VLIQFRT	:= SD1->D1_TOTAL - (SD1->D1_VALICM+SD1->D1_VALIMP5+SD1->D1_VALIMP6)
				endif
				SD1->(dbSkip())
			enddo
		endif
	endif
	TMP->D1_VUNIFRT:= (TMP->D1_VLIQFRT/TMP->MQUAD)+TMP->D1_VUNITLQ
	TMP->(MsUnLock())
	
	//Verificar se houve algum abatimento na nota fiscal
	if cItemAnt <> (cAliasQry)->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
		dbSelectArea("SF1")
		dbSetOrder(1)
		if dbSeek(xFilial("SF1")+(cAliasQry)->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA),.T.)
			if SF1->F1_VALMERC > SF1->F1_VALBRUT
				RecLock("TMP",.T.)
				TMP->D1_DOC 		:= (cAliasQry)->D1_DOC
				TMP->D1_SERIE  		:= (cAliasQry)->D1_SERIE
				TMP->A2_COD         := (cAliasQry)->D1_FORNECE
				TMP->A2_LOJA        := (cAliasQry)->D1_LOJA
				TMP->A2_NOME        := Posicione("SA2",1,xFilial("SA2")+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA, "A2_NOME")
				TMP->B1_COD         := (cAliasQry)->D1_COD
				TMP->B1_DESC        := (cAliasQry)->D1_X_DESCR
				TMP->D1_TOTAL       :=  SF1->F1_VALBRUT - (SF1->F1_VALMERC + SF1->F1_FRETE)
				TMP->D1_VICMS       := 0
				TMP->D1_VPIS        := 0
				TMP->D1_VCOFINS     := 0
				TMP->D1_TOTALIQ     :=  SF1->F1_VALBRUT - SF1->F1_VALMERC
				TMP->(MsUnLock())
			endif
		endif
	endif
	cItemAnt := (cAliasQry)->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
	(cAliasQry)->(dbSkip())
	nCont++
enddo

nContItem:=0
cCONHECF := ""
cSERFRET := ""
cFORFRET := ""
cLOJFRET := ""

cNotaAnt  := ""
cSerieAnt := ""
cFornAnt  := ""
cLojaAnt  := ""
nIndice   := 0
DbSelectArea("TMP")
cArquivo := CriaTrab(,.F.)
INDREGUA("TMP",cArquivo,"D1_DOC+D1_SERIE+A2_COD+A2_LOJA",,)
TMP->(dbGotop())
While !TMP->(eof())
	if  (cNotaAnt+cSerieAnt+cFornAnt+cLojaAnt) == TMP->(D1_DOC+D1_SERIE+A2_COD+A2_LOJA)
		RecLock("TMP",.F.)
		TMP->D1_CONHECF := cCONHECF
		TMP->D1_SERFRET := cSERFRET
		TMP->D1_FORFRET := cFORFRET
		TMP->D1_LOJFRET := cLOJFRET
		if TMP->D1_VFRETE == 0
			TMP->D1_VFRETE  := 1
		endif
		TMP->(MsUnLock())
	endif
	if TMP->D1_VFRETE > 0 .and. Posicione("SB1",1,xFilial("SB1")+TMP->B1_COD, "B1_TIPO") <> 'MO'
		dbSelectArea("SF1")
		dbSetOrder(1)
		dbSeek(xFilial("SF1")+TMP->(D1_DOC+D1_SERIE+A2_COD+A2_LOJA),.T.)
		if TMP->D1_TOTAL < SF1->F1_VALMERC
			dbSelectArea("SD1")
			dbSetOrder(1)
			//			alert("NOTA PESQUISADA-> "+TMP->(D1_CONHECF+D1_SERFRET+D1_FORFRET+D1_LOJFRET))
			dbSeek(xFilial("SD1")+TMP->(D1_CONHECF+D1_SERFRET+D1_FORFRET+D1_LOJFRET),.T.)
			//			alert("NOTA ENCONTRADA-> "+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA))
			While !SD1->(eof()).and.SD1->D1_FILIAL == xFilial("SD1").and.SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)==TMP->(D1_CONHECF+D1_SERFRET+D1_FORFRET+D1_LOJFRET)
				nContItem++
				SD1->(dbSkip())
			enddo
			//   			msgbox("Atualizando Nota Fiscal --> "+TMP->D1_DOC+ "TOTAL DE ITENS -> "+cVAlToChar(nContItem))
			if nContItem == 1
				RecLock("TMP",.F.)
				if nIndice = 0
					nFreteAnt    := TMP->D1_VFRETE
					nICMFrtAnt   := TMP->D1_VICMFRT
					nVPISFrtAnt  := TMP->D1_VPISFRT
					nVCOFFrtAnt  := TMP->D1_VCOFFRT
					nVLiqFrtAnt  := TMP->D1_VLIQFRT
					
					TMP->D1_VFRETE	:= TMP->D1_VFRETE  * (TMP->D1_TOTAL / SF1->F1_VALMERC)
					TMP->D1_VICMFRT := TMP->D1_VICMFRT * (TMP->D1_TOTAL / SF1->F1_VALMERC)
					TMP->D1_VPISFRT := TMP->D1_VPISFRT * (TMP->D1_TOTAL / SF1->F1_VALMERC)
					TMP->D1_VCOFFRT := TMP->D1_VCOFFRT * (TMP->D1_TOTAL / SF1->F1_VALMERC)
					TMP->D1_VLIQFRT := TMP->D1_VLIQFRT * (TMP->D1_TOTAL / SF1->F1_VALMERC)
					
					nFreteAnt    := nFreteAnt - TMP->D1_VFRETE
					nICMFrtAnt   := nICMFrtAnt - TMP->D1_VICMFRT
					nVPISFrtAnt  := nVPISFrtAnt - TMP->D1_VPISFRT
					nVCOFFrtAnt  := nVCOFFrtAnt - TMP->D1_VCOFFRT
					nVLiqFrtAnt  := nVLiqFrtAnt - TMP->D1_VLIQFRT
					
					TMP->(MsUnlock())
					nIndice := TMP->D1_VFRETE / SF1->F1_VALMERC
				else
					dbSelectArea("SF1")
					dbSetOrder(1)
					dbSeek(xFilial("SF1")+TMP->D1_CONHECF+TMP->D1_SERFRET+TMP->D1_FORFRET+TMP->D1_LOJFRET,.T.)
					TMP->D1_VFRETE	:= nFreteAnt
					TMP->D1_VICMFRT := nICMFrtAnt
					TMP->D1_VPISFRT := nVPISFrtAnt
					TMP->D1_VCOFFRT := nVCOFFrtAnt
					TMP->D1_VLIQFRT := nVLiqFrtAnt
					TMP->(MsUnlock())
					nFreteAnt    := 0
					nICMFrtAnt   := 0
					nVPISFrtAnt  := 0
					nVCOFFrtAnt  := 0
					nVLiqFrtAnt  := 0
					
				endif
			endif
			nContItem := 0
			
		endif
	endif
	cCONHECF := TMP->D1_CONHECF
	cSERFRET := TMP->D1_SERFRET
	cFORFRET := TMP->D1_FORFRET
	cLOJFRET := TMP->D1_LOJFRET
	
	cNotaAnt  := TMP->D1_DOC
	cSerieAnt := TMP->D1_SERIE
	cFornAnt  := TMP->A2_COD
	cLojaAnt  := TMP->A2_LOJA
	TMP->(dbSkip())
enddo


dbSelectArea("TMP")
dbGotop()
while TMP->(!eof())
	if TMP->D1_VFRETE <= 1
		RecLock("TMP", .F.)
		TMP->D1_VFRETE := 0
		TMP->(MsUnLock())
	endif
	TMP->(dbSkip())
enddo

//Alert("Atualizacao Frete finalizado...")

aAdd(aConteud,{"","RELATORIO R.D.N.F. COMPRAS DE COURO","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aConteud,{"","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) //27 colunas


aAdd(aConteud,{"NOTA"  ,"ENTRADA", "EMISSAO", "VENCIMENTO", "CURTUME","UF","ARTIGO","TIPO", "CLASSI","QTDE ","QTDE","QTDE","VALOR  ","TOTAL N. ","ICMS", "PIS","COFINS", "TOTAL  ","MEDIO","VLR.UNIT ","N.CONHEC.","TOTAL  ","ICMS   ","PIS    ","LOTE","COFINS ","TOTAL LIQ","VALOR UNIT"})
aAdd(aConteud,{"FISCAL","       ", "       ", "          ", "       ","  ","      ","    ","FICACAO","VAQ  "," M² ","P²  ",  "UNIT.R$","FISCAL R$"," R$ ", " R$","  R$  ", "LIQ.R$ ","M2/VQ","S/IMP.R$" ,"FRETE    ","FRET.R$","FRET.R$","FRET.R$","  ","FRET.R$","FRET.R$  ","S/IMP+FRET"})


dbSelectArea("TMP")
dbGotop()
While TMP->(!eof())
	aAdd(aConteud,{"","","","","","","",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"", 0,0,0}) //27 colunas
	aConteud [len(aConteud),1] := TMP->D1_DOC
	aConteud [len(aConteud),2] := dToC(TMP->D1_ENTRADA)
	aConteud [len(aConteud),3] := dToC(TMP->D1_EMISSAO)
	aConteud [len(aConteud),4] := dToC(TMP->E1_VENCTO)
	aConteud [len(aConteud),5] := TMP->A2_COD+'-'+Substr(TMP->A2_NOME,1,25)
	aConteud [len(aConteud),6] := TMP->D1_UF
	aConteud [len(aConteud),7] := Substr(TMP->B1_COD,1,6)+'-'+TMP->B1_DESC
	aConteud [len(aConteud),8] := TMP->B1_TIPO
	aConteud [len(aConteud),9] := "" //Classificacao
	aConteud [len(aConteud),10] := TMP->VAQTA
	aConteud [len(aConteud),11]:= TMP->MQUAD
	aConteud [len(aConteud),12]:= TMP->PEQUAD
	aConteud [len(aConteud),13]:= TMP->D1_VUNIT
	aConteud [len(aConteud),14]:= TMP->D1_TOTAL
	aConteud [len(aConteud),15]:= TMP->D1_VICMS
	aConteud [len(aConteud),16]:= TMP->D1_VPIS
	aConteud [len(aConteud),17]:= TMP->D1_VCOFINS
	aConteud [len(aConteud),18]:= TMP->D1_TOTALIQ
	aConteud [len(aConteud),19]:= TMP->D1_MMTVQTA
	aConteud [len(aConteud),20]:= TMP->D1_VUNITLQ
	aConteud [len(aConteud),21]:= TMP->D1_CONHECF
	aConteud [len(aConteud),22]:= TMP->D1_VFRETE
	aConteud [len(aConteud),23]:= TMP->D1_VICMFRT
	aConteud [len(aConteud),24]:= TMP->D1_VPISFRT
	aConteud [len(aConteud),25]:= TMP->D1_LOTECTL
	aConteud [len(aConteud),26]:= TMP->D1_VCOFFRT
	aConteud [len(aConteud),27]:= TMP->D1_VLIQFRT
	aConteud [len(aConteud),28]:= TMP->D1_VUNIFRT
	//		aConteud [len(aConteud),27]:= TMP->D1_ITEM
	
	TMP->(dbSkip())
enddo

return

//+-----------------------------------------------------------------------------------//
//|Funcao....: MDirArq
//|Descricao.: Define Diretório e nome do arquivo a ser gerado
//|Retorno...: aRet[1] = Diretório de gravação
//|            aRet[2] = Nome do arquivo a ser gerado
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MDirArq()
*-----------------------------------------*
Local aRet := {"",""}
Private bFileFat:={|| cDir:=UZXChoseDir(),If(Empty(cDir),cDir:=Space(250),Nil)}
Private cArq    := Space(10)
Private cDir    := Space(250)
Private oDlgDir := Nil
Private cPath   := "Selecione diretório"
Private aArea   := GetArea()
Private lRetor  := .T.
Private lSair   := .F.

//+-----------------------------------------------------------------------------------//
//| Definição da janela e seus conteúdos
//+-----------------------------------------------------------------------------------//
While .T.
	DEFINE MSDIALOG oDlgDir TITLE "Definição de Arquivo e Diretório" FROM 0,0 TO 175,368 OF oDlgDir PIXEL
	
	@ 06,06 TO 65,180 LABEL "Dados do arquivo" OF oDlgDir PIXEL
	
	@ 15, 10 SAY   "Nome do Arquivo"  SIZE 45,7 PIXEL OF oDlgDir
	@ 25, 10 MSGET cArq               SIZE 50,8 PIXEL OF oDlgDir
	
	@ 40, 10 SAY "Diretorio de gravação"  SIZE  65, 7 PIXEL OF oDlgDir
	@ 50, 10 MSGET cDir PICTURE "@!"      SIZE 150, 8 WHEN .F. PIXEL OF oDlgDir
	@ 50,162 BUTTON "..."                 SIZE  13,10 PIXEL OF oDlgDir ACTION Eval(bFileFat)
	
	DEFINE SBUTTON FROM 70,10 TYPE 1  OF oDlgDir ACTION (UZXValRel("ok")) ENABLE
	DEFINE SBUTTON FROM 70,50 TYPE 2  OF oDlgDir ACTION (UZXValRel("cancel")) ENABLE
	
	ACTIVATE MSDIALOG oDlgDir CENTER
	
	If lRetor
		Exit
	Else
		Loop
	EndIf
EndDo

If lSair
	Return(aRet)
EndIf

aRet := {cDir,cArq}

Return(aRet)

*-----------------------------------------*
Static Function UZXChoseDir()
*-----------------------------------------*
Local cTitle:= "Geração de arquivo"
Local cMask := "Formato *|*.*"
Local cFile := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions:= GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY

cFile:= cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,.F., nOptions)

Return(cFile)


//+-----------------------------------------------------------------------------------//
//|Funcao....: UZXValRel()
//|Descricao.: Valida informações de gravação
//|Uso.......: U_UZXDIRARQ
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function UZXValRel(cValida)
*-----------------------------------------*

Local lCancela

If cValida = "ok"
	If Empty(Alltrim(cArq))
		MsgInfo("O nome do arquivo deve ser informado","Atenção")
		lRetor := .F.
	ElseIf Empty(Alltrim(cDir))
		MsgInfo("O diretório deve ser informado","Atenção")
		lRetor := .F.
		//	ElseIf Len(Alltrim(cDir)) <= 3
		//		MsgInfo("Não se pode gravar o arquivo no diretório raiz, por favor, escolha um subdiretório.","Atenção")
		//		lRetor := .F.
	Else
		oDlgDir:End()
		lRetor := .T.
	EndIf
Else
	lCancela := MsgYesNo("Deseja cancelar a geração do Relatório / Documento?","Atenção")
	If lCancela
		oDlgDir:End()
		lRetor := .T.
		lSair  := .T.
	Else
		lRetor := .F.
	EndIf
EndIf

Return(lRetor)


//+-----------------------------------------------------------------------------------//
//|Funcao....: MCSV
//|Descricao.: Gera Arvquivo do tipo csv
//|Retorno...: .T. ou .F.
//|Observação:
//+-----------------------------------------------------------------------------------//

*-------------------------------------------------*
Static Function MCVS(axVet,cxCab,cxArqTxt,PICTUSE)
*-------------------------------------------------*

Local cEOL       := CHR(13)+CHR(10)
Local nTamLin    := 2
Local cLin       := Space(nTamLin)+cEOL
Local cDadosCSV  := ""
Local lRet       := .T.
Local nHdl,nt,jk       := 0

If Len(axVet) == 0
	MsgInfo("Dados não informados","Sem dados")
	lRet := .F.
	Return(lRet)
ElseIf Empty(cxArqTxt)
	MsgInfo("Diretório e nome do arquivo não informados corretamente","Diretório ou Arquivo")
	lRet := .F.
	Return(lRet)
EndIf

cxArqTxt := cxArqTxt+".csv"
nHdl := fCreate(cxArqTxt)

If nHdl == -1
	MsgAlert("O arquivo de nome "+cxArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

nTamLin := 2
cLin    := Space(nTamLin)+cEOL

ProcRegua(Len(axVet))

If !Empty(cxCab)
	cLin := Stuff(cLin,01,02,cxCab)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no Cabeçalho. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		Endif
	Endif
EndIf
For jk := 1 to Len(axVet)
	nTamLin   := 2
	cLin      := Space(nTamLin)+cEOL
	cDadosCSV := ""
	IncProc("Gerando arquivo CSV")
	For nt := 1 to Len(axVet[jk])
		If ValType(axVet[jk,nt]) == "C"
			cDadosCSV += axVet[jk,nt]+Iif(nt = Len(axVet[jk]),"",";")
		ElseIf ValType(axVet[jk,nt]) == "N"
			cDadosCSV += Transform(axVet[jk,nt],PICTUSE)+Iif(nt = Len(axVet[jk]),"",";")
		ElseIf ValType(axVet[jk,nt]) == "U"
			cDadosCSV += +Iif(nt = Len(axVet[jk]),"",";")
		Else
			cDadosCSV += axVet[jk,nt]+Iif(nt = Len(axVet[jk]),"",";")
		EndIf
	Next
	cLin := Stuff(cLin,01,02,cDadosCSV)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo nos Itens. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		Endif
	Endif
Next
fClose(nHdl)
Return(lOk)

//+-----------------------------------------------------------------------------------//
//|Funcao....: MExcel
//|Descricao.: Abre arquivo csv em excel
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MExcel(cxDir,cxArq)
*-----------------------------------------*
Local cArqTxt := cxDir+cxArq+".csv"
Local cMsg    := "Relatorio gerado com sucesso!"+CHR(13)+CHR(10)+"O arquivo "+cxArq+".csv"
cMsg    += " se encontra no diretório "+cxDir

MsgInfo(cMsg,"Atenção")

If MsgYesNo("Deseja Abrir o arquivo em Excel?","Atenção")
	If ! ApOleClient( 'MsExcel' )
		MsgStop(" MsExcel nao instalado ")
		Return
	EndIf
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cArqTxt)
	oExcelApp:SetVisible(.T.)
EndIf

Return
