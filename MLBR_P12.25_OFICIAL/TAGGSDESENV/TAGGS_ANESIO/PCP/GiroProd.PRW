#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³         ³ Autor ³                       ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GiroProd()
	U_RelProd()
Return 



User Function RelProd()
Local titulo 	:= "Posicao de estoque conforme consumo"
Local cString	:= ""
Local wnrel		:= "GIROPROD"
Local cDesc		:= "Este programa ira imprimir a relacao de produtos conforme consumo do periodo"
Local aOrd    	:= "Por data de consumo "
Local tamanho	:= "G"
Local lRet      := .T.
Private aReturn := {"TST01",1,"TST02", 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
Private cPerg   := "GIROPRD"                                                       
Private nLastKey:= 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Pergunte("RELPLT",.F.)
	
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

if MV_PAR07 <= MV_PAR08 
	If lRet
		RptStatus({|lEnd| MntRel1(@lEnd,wnRel,titulo,tamanho)},titulo)
	EndIf
else 
	msgbox("O periodo Normal é > que o período de Desuso...")	
endif
Return NIL

//msgbox("Chamado Relatorio...")
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MntPlt1  ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 13.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR850			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MntRel1(lEnd,wnRel,titulo,tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbTxt
Local CbCont,cabec1,cabec2
Local limite   := If(aReturn[4] == 1,132,180)
Local nomeprog := "RELCONSPROD"
Local nTipo    := 0
Local cStatus,nOrdem,cSeek
Local cQuery   := "",cIndex := CriaTrab("",.F.),nIndex:=0
Local cQuerySD1   := "",cIndex := CriaTrab("",.F.),nIndex:=0
//Local lQuerySD1   := .F.
Local lTipo    := .F.
Local nQtde, nValor, nCont := 0
Local nQtdeTotal, nValorTotal := 0
Local cAliasQry    := GetNextAlias()
Local cQrySD1    := GetNextAlias()
Local aCampos := {}   
Local aCpos  := {}                            
Local nReg   := 0
Local ncount := 0 
Local cont := 0              
Local cCodAnt := ""       
Local cTipoAnt := ""                                         
Local i:=0
Local cTipoCF :=""
Local cImprime := ""

AADD(aCampos, {"D3_COD",       "C", 15}) 
AADD(aCampos, {"B1_TIPO",      "C",  2})
AADD(aCampos, {"D3_GRUPO",     "C",  4})
AADD(aCampos, {"B1_DESC",      "C", 40})
AADD(aCampos, {"B1_UM",        "C",  2})
AADD(aCampos, {"B1_FILIAL",    "C",  2})
AADD(aCampos, {"D3_LOCAL",     "C",  2})
AADD(aCampos, {"B2_QATU",      "N", 9,2})
AADD(aCampos, {"B2_LOCAL",     "C",  2})
AADD(aCampos, {"B2_VATU1",     "N", 9,2})
AADD(aCampos, {"EMISSAO", 	   "D",  8})
AADD(aCampos, {"TIPO",         "C", 10})
AADD(aCampos, {"GRVA",   			 "C",  1})

cNome := CriaTrab(aCampos,.T.)
If (Select("TMP") <> 0)
	dbSelectArea("TMP")
	dbCloseArea("TMP")
Endif
dbUseArea(.T.,,cNome,"TMP",Nil,.F.)



//Cria Tabela Temporária para ordenar por produto que tem repetição....

AADD(aCpos, {"D3_COD",       "C", 15}) 
AADD(aCpos, {"B1_TIPO",      "C",  2})
AADD(aCpos, {"D3_GRUPO",     "C",  4})
AADD(aCpos, {"B1_DESC",      "C", 40})
AADD(aCpos, {"B1_UM",        "C",  2})
AADD(aCpos, {"B1_FILIAL",    "C",  2})
AADD(aCpos, {"D3_LOCAL",     "C",  2})
AADD(aCpos, {"B2_QATU",      "N", 9,2})
AADD(aCpos, {"B2_LOCAL",     "C",  2})
AADD(aCpos, {"B2_VATU1",     "N", 9,2})
AADD(aCpos, {"EMISSAO",		   "D",  8})
AADD(aCpos, {"TIPO",         "C", 10})

cNomeTRB := CriaTrab(aCpos,.T.)
If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea("TRB")
Endif
dbUseArea(.T.,,cNomeTRB,"TRB",Nil,.F.)

//Alert("MV_PAR09: "+mv_par09)
//for i:= 1 to len(mv_par09)
//    cTipoCF := "'"+Substr(mv_par09,i,3)+"',"
//    i:= i+3
//next i
/*
if Substr(mv_par09,1,3) <> ""
	cTipoCF := "'"+Substr(mv_par09,1,3)+"'"
endif 

if Substr(mv_par09,5,3) <> ""
	cTipoCF += ",'"+Substr(mv_par09,5,3)+"'"
endif 

if Substr(mv_par09,9,3) <> ""
	cTipoCF += ",'"+Substr(mv_par09,9,3)+"'"
endif 

if Substr(mv_par09,13,3) <> ""
	cTipoCF += ",'"+Substr(mv_par09,13,3)+"'"
endif 

if Substr(mv_par09,17,3) <> ""
	cTipoCF += ",'"+Substr(mv_par09,17,3)+"'"
endif 

if Substr(mv_par09,21,3) <> ""
	cTipoCF += ",'"+Substr(mv_par09,21,3)+"'"
endif 

if Substr(mv_par09,25,3) <> ""
	cTipoCF += ",'"+Substr(mv_par09,25,3)+"'"
endif 
  */
//cTipoCF := Substr(cTipoCF,1,Len(cTipoCF)-1)  
//  Alert("Tipo CF: "+cTipoCF)

cQuery := "SELECT D3_COD, B1_TIPO, D3_GRUPO, B1_DESC, B1_UM, B1_FILIAL, D3_LOCAL, B2_QATU, B2_LOCAL, B2_VATU1, "
cQuery += "Max(D3_EMISSAO) EMISSAO "
cQuery += "FROM " + RetSQLName( "SD3" ) + " SD3, " + RetSQLName( "SB1" ) + " SB1, " + RetSQLName( "SB2" ) + " SB2 " 
cQuery += "WHERE "
cQuery += "SD3.D3_FILIAL = '"+xFilial("SD3") + "' AND SB1.B1_FILIAL = '" +xFilial("SB1") + "' AND SB2.B2_FILIAL = '"+xFilial("SB2") + "'"
cQuery += "AND SD3.D_E_L_E_T_ <> '*' AND  SB1.D_E_L_E_T_ <> '*' AND SB2.D_E_L_E_T_ <> '*' "             
cQuery += "AND D3_COD = B1_COD AND B2_COD = D3_COD AND B2_COD = B1_COD AND B2_LOCAL = D3_LOCAL  AND B2_QATU > 0 "
cQuery += "AND D3_TM = '999' AND D3_CF in ('DE0','DE1','DE4','DE6','DE7','PR0','RE0','RE1','RE4','RE5','RE7') AND "
//cQuery += "AND D3_TM = '999' AND (D3_CF = 'RE1' OR D3_CF = 'RE5') AND "
cQuery += "SD3.D3_LOCAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND "
cQuery += "SD3.D3_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND "
cQuery += "SD3.D3_COD BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQuery += "GROUP BY D3_COD, B1_TIPO, D3_GRUPO, B1_DESC, B1_UM, B1_FILIAL, D3_LOCAL, B2_LOCAL, B2_QATU, B2_VATU1 "
cQuery += "ORDER BY EMISSAO DESC "

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)

TcSetField(cAliasQry, "EMISSAO", "D")
memowrite("C:\TEMP\QUERYDESUSO.TXT", cQuery)


//Gravar na tabela intermediária....
dbGotop()
While !(cAliasQry)->(EoF())
	dbSelectArea("TMP")	
	RecLock("TMP",.T.)
	TMP->D3_COD  := (cAliasQry)->D3_COD
	TMP->B1_TIPO := (cAliasQry)->B1_TIPO
	TMP->D3_GRUPO:= (cAliasQry)->D3_GRUPO
	TMP->B1_DESC := (cAliasQry)->B1_DESC
	TMP->B1_UM   := (cAliasQry)->B1_UM
	TMP->B1_FILIAL := (cAliasQry)->B1_FILIAL
	TMP->D3_LOCAL := (cAliasQry)->D3_LOCAL
	TMP->B2_QATU := (cAliasQry)->B2_QATU
	TMP->B2_VATU1 := (cAliasQry)->B2_VATU1
	TMP->EMISSAO:= (cAliasQry)->EMISSAO         
	if (dDatabase - (cAliasQry)->EMISSAO) <= mv_par07 
		TMP->TIPO := "NORMAL"
	elseif  (dDatabase - (cAliasQry)->EMISSAO) <= mv_par08
		TMP->TIPO := "LENTO" 
	else
		TMP->TIPO := "DESUSO"
	endif                                 
	TMP->GRVA := "S"
	nReg++                 
	MsUnLock("TMP")
	(cAliasQry)->(dbSkip())
enddo

	
//Gravar na tabela definitiva...
dbSelectArea(cAliasQry)
dbGotop()          
ncount:=0
While !(cAliasQry)->(EoF())   
	dbSelectArea("TMP")
	Tmp->(dbGotop())
	While !TMP->(Eof())
		if (cAliasQry)->D3_COD == TMP->D3_COD .and. ncount == 0 .and. TMP->GRVA == 'S'
			dbSelectArea("TRB")	
			RecLock("TRB",.T.)
			TRB->D3_COD   	:= (cAliasQry)->D3_COD
			TRB->B1_TIPO  	:= (cAliasQry)->B1_TIPO
			TRB->D3_GRUPO 	:= (cAliasQry)->D3_GRUPO
			TRB->B1_DESC  	:= (cAliasQry)->B1_DESC
			TRB->B1_UM  		:= (cAliasQry)->B1_UM
			TRB->B1_FILIAL 	:= (cAliasQry)->B1_FILIAL
			TRB->D3_LOCAL 	:= (cAliasQry)->D3_LOCAL
			TRB->B2_QATU 		:= (cAliasQry)->B2_QATU
			TRB->B2_VATU1 	:= (cAliasQry)->B2_VATU1
			TRB->EMISSAO 		:= (cAliasQry)->EMISSAO
			if (dDatabase - (cAliasQry)->EMISSAO) <= mv_par07 
				TRB->TIPO := "NORMAL"
				cTipoAnt  := "NORMAL "+TRB->D3_LOCAL
			elseif  (dDatabase - (cAliasQry)->EMISSAO) <= mv_par08
				TRB->TIPO := "LENTO" 
				cTipoAnt  := "LENTO "+TRB->D3_LOCAL
			else
				TRB->TIPO := "DESUSO"
				cTipoAnt  := "DESUSO "+TRB->D3_LOCAL
			endif          
			
			ncount := 1
			MsUnlock("TRB")
		elseif (cAliasQry)->D3_COD == TMP->D3_COD .and. TMP->GRVA == "S" .and. ncount > 0 
			RecLock("TRB",.T.)
			TRB->D3_COD   		:= TMP->D3_COD
			TRB->B1_TIPO  		:= TMP->B1_TIPO
			TRB->D3_GRUPO 		:= TMP->D3_GRUPO
			TRB->B1_DESC  		:= TMP->B1_DESC
			TRB->B1_UM  		:= TMP->B1_UM
			TRB->B1_FILIAL 		:= TMP->B1_FILIAL
			TRB->D3_LOCAL 		:= TMP->D3_LOCAL
			TRB->B2_QATU 		:= TMP->B2_QATU
			TRB->B2_VATU1 		:= TMP->B2_VATU1
			TRB->EMISSAO 		:= TMP->EMISSAO
			TRB->TIPO 			:= cTipoAnt
			MsUnlock("TRB")
			dbSelectArea("TMP")
			RecLock("TMP",.F.)
			TMP->GRVA := "N"
			MsUnLock("TMP")
		endif
	TMP->(dbSkip())
  enddo
	ncount := 0
(cAliasQry)->(dbSkip())                 
cont++
enddo


//Gera Query para identificar itens que teve entrada e não houve saída....
cQuerySD1 := "SELECT D1_COD, D1_UM, D1_GRUPO, D1_FILIAL, D1_LOCAL, B2_QATU, B2_VATU1, "
cQuerySD1 += "Max(D1_EMISSAO) EMISSAO "
cQuerySD1 += "FROM " + RetSQLName( "SD1" ) + " SD1, " + RetSQLName( "SF4" ) + " SF4, " + RetSQLName( "SB2" ) + " SB2 " 
cQuerySD1 += "WHERE "
cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1") + "' AND SF4.F4_FILIAL = '" +xFilial("SF4") + "' AND SB2.B2_FILIAL = '" +xFilial("SB2") + "'"
cQuerySD1 += "AND SD1.D_E_L_E_T_ <> '*' AND  SF4.D_E_L_E_T_ <> '*' AND  SB2.D_E_L_E_T_ <> '*'"
cQuerySD1 += "AND D1_TES = F4_CODIGO  "
cQuerySD1 += "AND D1_COD = B2_COD AND D1_LOCAL = B2_LOCAL "
cQuerySD1 += "AND F4_ESTOQUE = 'S' AND B2_QATU > 0 AND "
//cQuery += "AND D3_TM = '999' AND (D3_CF = 'RE1' OR D3_CF = 'RE5') AND "
cQuerySD1 += "SD1.D1_LOCAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND "
cQuerySD1 += "SD1.D1_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND "
cQuerySD1 += "SD1.D1_COD BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQuerySD1 += "GROUP BY D1_COD, D1_UM, D1_GRUPO, D1_FILIAL, D1_LOCAL, B2_QATU, B2_VATU1 "
cQuerySD1 += "ORDER BY EMISSAO "

cQuerySD1 := ChangeQuery(cQuerySD1)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuerySD1),cQrySD1, .F., .T.)

TcSetField(cQrySD1, "EMISSAO", "D")




//msgbox("Registros repetidos-->> "+cValToChar(contaTP))                

//msgbox("Total de Registro inserido ->> "+cValToChar(contaTP))	

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
//titulo += "Controle de Classificacao de Produtos / Por Palete "
cabec1 := "CODIGO           TIPO GRUPO  DESCRICAO                                    UM  FLIAL ALMX                 QTDE         CUSTO           VALOR         ULTIMO    C0NSUMO         ULTIMA     "
cabec2 := "                                                                                                                       UNIT                      MOVIMENTO                   ENTRADA     "
//				 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 
//             1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20
//                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890


rodap1 := "HISTORICO DE CONSUMO:  |   ATE " + cValToChar(mv_par07)+" DIAS |  ENTRE "+cValToChar(mv_par07+1)+" E "+cValToChar(mv_par08)+ " DIAS  | ACIMA DE " + cValToChar(mv_par08+1)+ " DIAS | "
rodap2 := "                       |    NORMAL     |        LENTO         |     DESUSO       |   DATA BASE: "  +dToc(dDataBase)


SetRegua(RecCount())		// Total de Elementos da regua

nQtde  := 0
nValor := 0
nQtdeTotal  := 0
nValorTotal := 0                                        

//Imprime os tipos NORMAIS....
dbSelectArea("TRB")
TRB->(dbGotop())
cCodAnt := TRB->D3_COD
While !TRB->(EoF())
	IncRegua()
	If lEnd
		@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
		Exit
	EndIf
	If li > 58
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf         
  	if Substr(TRB->TIPO,1,5) == "NORMA"
		@Li ,000 PSay TRB->D3_COD
		@Li ,018 PSay TRB->B1_TIPO
		@Li ,023 PSay TRB->D3_GRUPO
		@Li ,029 Psay TRB->B1_DESC
		@Li ,075 PSay TRB->B1_UM
		@Li ,079 PSay TRB->B1_FILIAL
		@Li ,085 PSay TRB->D3_LOCAL
		@Li ,095 PSay TRB->B2_QATU Picture "@E 999,999,999.99" //PesqPictQt("B2_QATU")
		@Li ,113 PSay (TRB->B2_VATU1/TRB->B2_QATU) Picture "@E 999,999.99"
		@Li ,125 PSay TRB->B2_VATU1 Picture "@E 999,999,999.99" //PesqPictQt("B2_VATU1")
		@Li ,144 PSay TRB->EMISSAO         
		nQtde  += TRB->B2_QATU
		nValor += TRB->B2_VATU1
		@Li ,159 PSay TRB->TIPO //"NORMAL"
		Li++
		nCont++                                          
		cCodAnt := TRB->D3_COD 
		endif 
TRB->(dbSkip())
endDo

  if Li > 57
	  @Li, 001 PSay rodap1
	  li++
	  @Li, 001 PSay rodap2 
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf         

 if nCont > 0                
//	 	@Li ,  0 PSay __PrtThinLine()  
		@Li, 010 PSay "T  O  T  A  L     N  O  R  M  A  L =  =  =  =  = > > > > " 
		@Li ,095 PSay nQtde Picture "@E 999,999,999.99" //PesqPictQt("B2_QATU")
		@Li ,125 PSay nValor Picture "@E 999,999,999.99" //PesqPictQt("B2_VATU1")
		Li++
		Li++
//	 	@Li ,  0 PSay __PrtThinLine()  
	 	nQtdeTotal  += nQtde
	 	nValorTotal += nValor
	 	nQtde := 0
	 	nValor:= 0
		nCont++
  endif 
	if Li > 57
	  @Li, 001 PSay rodap1
	  li++
	  @Li, 001 PSay rodap2 
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf         
nCont:= 0
//Imprime os tipos LENTOS....   



dbSelectArea("TRB")
dbGotop() 
cCodAnt:= TRB->D3_COD
While !TRB->(EoF())
	IncRegua()
	If lEnd
		@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
		Exit
	EndIf
	if Li > 57
	  @Li, 001 PSay rodap1
	  li++
	  @Li, 001 PSay rodap2 
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf         
	if Substr(TRB->TIPO,1,5) == "LENTO" 
	//(dDatabase - TRB->EMISSAO) > mv_par07
	//	  if(dDatabase - TRB->EMISSAO) <= mv_par08
			@Li ,000 PSay TRB->D3_COD
			@Li ,018 PSay TRB->B1_TIPO
			@Li ,023 PSay TRB->D3_GRUPO
			@Li ,029 Psay TRB->B1_DESC
			@Li ,075 PSay TRB->B1_UM
			@Li ,079 PSay TRB->B1_FILIAL
			@Li ,085 PSay TRB->D3_LOCAL
			@Li ,095 PSay TRB->B2_QATU Picture "@E 999,999,999.99" //PesqPictQt("B2_QATU")
			@Li ,113 PSay (TRB->B2_VATU1/TRB->B2_QATU) Picture "@E 999,999.99"
			@Li ,125 PSay TRB->B2_VATU1 Picture "@E 999,999,999.99" //PesqPictQt("B2_VATU1")
			@Li ,144 PSay TRB->EMISSAO         
			nQtde  += TRB->B2_QATU
			nValor += TRB->B2_VATU1
			@Li ,159 PSay TRB->TIPO //"LENTO"                                             
			cCodAnt := TRB->D3_COD 
			Li++
			nCont++ 
//		endif 
	endif
TRB->(dbSkip())
endDo
	if Li > 57
	  @Li, 001 PSay rodap1
	  li++
	  @Li, 001 PSay rodap2 
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf         

 if nCont > 0
//	 	@Li ,  0 PSay __PrtThinLine()  
		@Li, 010 PSay "T  O  T  A  L     L  E  N  T  O =  =  =  =  = > > > > " 
		@Li ,095 PSay nQtde Picture "@E 999,999,999.99" //PesqPictQt("B2_QATU")
		@Li ,125 PSay nValor Picture "@E 999,999,999.99" // PesqPictQt("B2_VATU1")
		Li++
		Li++
//	 	@Li ,  0 PSay __PrtThinLine()  
	 	nQtdeTotal  += nQtde
	 	nValorTotal += nValor
	 	nQtde := 0
	 	nValor:= 0
		nCont++
  endif 

	if Li > 57
	  @Li, 001 PSay rodap1
	  li++
	  @Li, 001 PSay rodap2 
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf         

nCont:= 0
//Imprime os tipos DESUSO....
dbSelectArea("TRB")
dbGotop()
While !TRB->(EoF())
	IncRegua()
	If lEnd
		@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
		Exit
	EndIf
	if Li > 57
	  @Li, 001 PSay rodap1
	  li++
	  @Li, 001 PSay rodap2 
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf         
	if Substr(TRB->TIPO,1,5) == "DESUS" 
		@Li ,000 PSay TRB->D3_COD
		@Li ,018 PSay TRB->B1_TIPO
		@Li ,023 PSay TRB->D3_GRUPO
		@Li ,029 Psay TRB->B1_DESC
		@Li ,075 PSay TRB->B1_UM
		@Li ,079 PSay TRB->B1_FILIAL
		@Li ,085 PSay TRB->D3_LOCAL
		@Li ,095 PSay TRB->B2_QATU Picture "@E 999,999,999.99" //PesqPictQt("B2_QATU")
		@Li ,113 PSay (TRB->B2_VATU1/TRB->B2_QATU) Picture "@E 999,999.99"
		@Li ,125 PSay TRB->B2_VATU1 Picture "@E 999,999,999.99" //PesqPictQt("B2_VATU1")
		@Li ,144 PSay TRB->EMISSAO         
		nQtde  += TRB->B2_QATU
		nValor += TRB->B2_VATU1
		@Li ,159 PSay TRB->TIPO //"DESUSO"
		Li++
		nCont++     
	endif 
TRB->(dbSkip())
endDo                          
	if Li > 57
	  @Li, 001 PSay rodap1
	  li++
	  @Li, 001 PSay rodap2 
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf         
 if nCont > 0
//	 	@Li ,  0 PSay __PrtThinLine()  
		@Li, 010 PSay "T  O  T  A  L     D  E  S  U  S  O =  =  =  =  = > > > > " 
		@Li ,095 PSay nQtde Picture "@E 999,999,999.99" //PesqPictQt("B2_QATU")
		@Li ,125 PSay nValor Picture "@E 999,999,999.99" //PesqPictQt("B2_VATU1")
		Li++
		Li++
//	 	@Li ,  0 PSay __PrtThinLine()  
	 	nQtdeTotal  += nQtde
	 	nValorTotal += nValor
	 	nQtde := 0
	 	nValor:= 0
		nCont++
  endif 

	if Li > 57
	  @Li, 001 PSay rodap1
	  li++
	  @Li, 001 PSay rodap2 
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf         
                                                        
//IMPRIMIR ITENS SEM MOVIMENTOS....
ncont := 0 
dbSelectArea(cQrySD1)
(cQrySD1)->(dbGotop())
While !(cQrySD1)->(eof())
	cImprime:="S"
	dbSelectArea("TRB")
	TRB->(dbGotop())
	While !TRB->(eof())
		if (cQrySD1)->D1_COD == TRB->D3_COD 
			cImprime:="N"
		endif
	TRB->(dbSkip())
	enddo
	if cImprime == "S"
		@Li ,000 PSay (cQrySD1)->D1_COD
		@Li ,023 PSay (cQrySD1)->D1_GRUPO
		@Li ,029 Psay Posicione("SB1",1,xFilial("SB1")+(cQrySD1)->D1_COD, "B1_DESC") //Posicione((cQrySD1)->B1_DESC
		@Li ,075 PSay (cQrySD1)->D1_UM
		@Li ,079 PSay (cQrySD1)->D1_FILIAL
		@Li ,085 PSay (cQrySD1)->D1_LOCAL
		@Li ,096 PSay (cQrySD1)->B2_QATU Picture "@E 999,999,999.99" //PesqPictQt("B2_QATU")
		@Li ,114 PSay ((cQrySD1)->B2_VATU1/(cQrySD1)->B2_QATU) Picture "@E 999,999.99"
		@Li ,126 PSay (cQrySD1)->B2_VATU1 Picture "@E 999,999,999.99" //PesqPictQt("B2_VATU1")
		@Li ,174 PSay (cQrySD1)->EMISSAO         
		nQtde  += (cQrySD1)->B2_QATU
		nValor += (cQrySD1)->B2_VATU1
		Li++
		nCont++
    endif
	(cQrySD1)->(dbSkip())
enddo		


 if nCont > 0
		@Li, 010 PSay "T  O  T  A  L     S  E  M     M  O  V  I  M  E  N  T  O  =  =  =  =  = > > > > " 
		@Li ,095 PSay nQtde Picture "@E 999,999,999.99" //PesqPictQt("B2_QATU")
		@Li ,125 PSay nValor Picture "@E 999,999,999.99" //PesqPictQt("B2_VATU1")
		Li++
		Li++
	 	nQtdeTotal  += nQtde
	 	nValorTotal += nValor
	 	nQtde := 0
	 	nValor:= 0
		nCont++
  endif 

if nQtdeTotal > 0 
   Li++
//	 	@Li ,  0 PSay __PrtThinLine()  
		@Li, 010 PSay "T  O  T  A  L     G  E  R  A  L = = = = = >>>> " 
		@Li ,095 PSay nQtdeTotal Picture "@E 999,999,999.99" //PesqPictQt("B2_QATU")
		@Li ,125 PSay nValorTotal Picture "@E 999,999,999.99" //PesqPictQt("B2_VATU1")
		Li++ 	
		@Li ,  0 PSay __PrtThinLine()  
		Li++
		Li++
		Li++
	  @Li, 001 PSay rodap1
	  li++
	  @Li, 001 PSay rodap2 
		
//	 	@Li ,  0 PSay __PrtThinLine()  
		Li++ 	
endif


If Li != 80
	Roda(cbcont,cbtxt)
EndIf


//If File(cIndex+OrdBagExt())
//	Ferase(cIndex+OrdBagExt())
//EndIf

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
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Anesio G.Faria -    ³    02.08.2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aArea := GetArea()
PutSx1(cPerg,"01","Armazem de                    ?"," "," ","mv_ch1","C",2,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o armazem inicial"},{"Informe o armazem inicial"},{"Informe o armazem inicial"})
PutSx1(cPerg,"02","Armazem ate                   ?"," "," ","mv_ch2","C",2,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o armazem final"},{"Informe o armazem final"},{"Informe o armazem final"})
PutSx1(cPerg,"03","Grupo de                      ?"," "," ","mv_ch3","C",6,0,0,	"G","","SBM","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o grupo inicial"},{"Informe o grupo inicial"},{"Informe o grupo inicial"})
PutSx1(cPerg,"04","Grupo ate                     ?"," "," ","mv_ch4","C",6,0,0,	"G","","SBM","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o grupo final"},{"Informe o grupo final"},{"Informe o grupo final"})
PutSx1(cPerg,"05","Produto de                    ?"," "," ","mv_ch5","C",15,0,0,"G","","SB1","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto inicial"},{"Informe o produto inicial"},{"Informe o produto inicial"})
PutSx1(cPerg,"06","Produto ate                   ?"," "," ","mv_ch6","C",15,0,0,"G","","SB1","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto final"},{"Informe o produto final"},{"Informe o produto final"})
PutSx1(cPerg,"07","N.dias prod Normal            ?"," "," ","mv_ch7","N",9,0,0,	"G","","   ","","","mv_par07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o numero máximo de dias para ser considerado normal"},{"Informe o numero máximo de dias para ser considerado normal"},{"Informe o numero máximo de dias para ser considerado normal"})
PutSx1(cPerg,"08","N.dias prod Desuso            ?"," "," ","mv_ch8","N",9,0,0,	"G","","   ","","","mv_par08"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o numero de dias a partir do qual o produto será considerado desuso"},{"Informe o numero de dias a partir do qual o produto será considerado desuso"},{"Informe o numero de dias a partir do qual o produto será considerado desuso"})
PutSx1(cPerg,"09","Imprimir Tipos CFO            ?"," "," ","mv_ch9","C",50,0,0,	"G","","   ","","","mv_par09"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Tipos a serem filtrados, use ; para separar, ex: RE0;RE3;RE5"},{"Tipos a serem filtrados, use ; para separar, ex: RE0;RE3;RE5"},{"Tipos a serem filtrados, use ; para separar, ex: RE0;RE3;RE5"})
RestArea(aArea)
Return