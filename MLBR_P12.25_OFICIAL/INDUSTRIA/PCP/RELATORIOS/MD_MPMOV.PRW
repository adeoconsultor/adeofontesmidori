#INCLUDE "PROTHEUS.CH"

#define STR0001  "Mapa das Movimentacoes"
#define STR0002  "Este programa ira emitir um resumo da relacao de"
#define STR0003  "quantidades do estoque. Sera emitido em forma de"
#define STR0004  "colunas, com Filial,Armazem,Codigo e Quantidade."
#define STR0005  " Tipo     "
#define STR0006  " Grupo    "
#define STR0007  "Zebrado"
#define STR0008  "Administracao"
#define STR0009  "QTD          COMPRAS    DEVOLUCOES     MOVIMENTACOES      REQUISICOES     REQUISICOES  SALDO INICIAL    APROPRIACAO   SALDO FINAL   TRANFERENCIAS        PRODUCAO TRANSFERENCIA           VENDAS        OUTRAS        OUTRAS"
#define STR0010  "VALOR                     DE VENDA          INTERNAS      P/ PRODUCAO     P/ PROCESSO    EM PROCESSO   MAT.INDIRETO   EM PROCESSO        INTERNAS                 ENTRE FILIAIS                       ENTRADAS        SAIDAS"
#define STR0011  "CANCELADO PELO OPERADOR"
#define STR0012  "Quantidade Inicial"
#define STR0013  "Valor inicial"
#define STR0014  "Quantidade Final"
#define STR0015  "Valor Final"
#define STR0016  "Total Tipo : "
#define STR0017  "Total Grupo: "
#define STR0018  "TOTAL GERAL : "
#define STR0019  "Vlr. Inicial Medio"
#define STR0020  "Vlr. Final Medio"
#define STR0021  "Selecionando Registros"
#define STR0022  "QTD"
#define STR0023  "VALOR"
#define STR0024  "COMPRAS"
#define STR0025  "DEVOLUÇÕES"
#define STR0026  "DE VENDA"
#define STR0027  "MOVIMENTAÇÕES"
#define STR0028  "INTERNAS"
#define STR0029  "REQUISIÇÕES"
#define STR0030  "P/ PRODUÇÃO"
#define STR0031  "P/ PROCESSO"
#define STR0032  "SALDO INICIAL"
#define STR0033  "EM PROCESSO"
#define STR0034  "APROPRIAÇÃO"
#define STR0035  "MAT.INDIRETO"
#define STR0036  "SALDO FINAL"
#define STR0037  "TRANSFERENCIAS"
#define STR0038  "PRODUÇÃO"
#define STR0039  "ENTRE FILIAIS"
#define STR0040  "VENDAS"
#define STR0041  "OUTRAS"
#define STR0042  "ENTRADAS"
#define STR0043  "SAIDAS"
#define STR0044  "Qtde.Inicial:"
#define STR0045  "Vlr.Inicial:"
#define STR0046  "Vlr.Inicial Medio:"
#define STR0047  "Qtde.Final:"
#define STR0048  "Vlr.Final:"
#define STR0049  "Vlr.Final Medio:"
#define STR0050  "Produtos"
#define STR0051  "Movimentação dos Produtos"

#DEFINE PICVAL  "@E 999,999,999.99"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MD_MPMOV  ³ Autor ³ Anesio G.Faria        ³ Data ³ 10/04/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mapa das Movimentacoes de Qtde em Excel                    ³±±
±±³Descri‡…o ³ Baseado no relatorio MATR330 "MAPA DE MOVIMENTACAO"        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/
User Function MD_MPMOV()
	U_MDMATR3()
Return


User Function MDMATR3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo LOCAL padrao de todos os relatorios           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL Tamanho  := "G"
LOCAL titulo   := STR0001	//"Mapa das Movimentacoes"
LOCAL cDesc1   := STR0002	//"Este programa ira emitir um resumo da relacao de"
LOCAL cDesc2   := STR0003	//"quantidades do estoque. Sera emitido em forma de"
LOCAL cDesc3   := STR0004	//"colunas, com Filial,LOCAL,Codigo e Quantidade."
LOCAL cString  := "SB1"
LOCAL aOrd     := {STR0005,STR0006}	//" Tipo     "###" Grupo    "
LOCAL wnrel    := "MATR330"
LOCAL nTamSX1  := Len(SX1->X1_GRUPO)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea1	:= Getarea()                                         

Private aConteud:= {}       
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab := ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private para SIGAVEI, SIGAPEC e SIGAOFI       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lVEIC		:= UPPER(GETMV("MV_VEICULO"))=="S"
Private aSB1Cod	:= {}
Private aSB1Ite	:= {}
Private nCOL1		:= 0
Private XSB1, xSB2, xSD1, xSD2, xSD3, xSF4
PRIVATE cLocProc := GetMV("MV_LOCPROC")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn  := {STR0007, 1,STR0008, 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
PRIVATE nLastKey := 0 ,cPerg := "MTR330"
PRIVATE nRegs    := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Almox. de                                    ³
//³ mv_par02     // Almox. ate                                   ³
//³ mv_par03     // Produto de                                   ³
//³ mv_par04     // Produto ate                                  ³
//³ mv_par05     // tipo de                                      ³
//³ mv_par06     // tipo ate                                     ³
//³ mv_par07     // grupo de                                     ³
//³ mv_par08     // grupo ate                                    ³
//³ mv_par09     // data inicial                                 ³
//³ mv_par10     // data final                                   ³
//³ mv_par11     // moeda selecionada ( 1 a 5 )                  ³
//³ mv_par12     // Saldo a considerar : Atual / Fechamento      ³
//³ mv_par13     // Rem/Dev Poder 3 Compras - Sim/Nao            ³
//³ mv_par14     // Rem/Dev Poder 3 Vendas  - Sim/Nao            ³
//³ mv_par15     // Impr. Vlr. Medio  - Sim/Nao                  ³
//³ mv_par16     // Imprime OPs geradas pelo SIGAMNT? Sim / Nao  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta o SX1 com as novas perguntas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajustar o SX1 para SIGAVEI, SIGAPEC e SIGAOFI                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DBSELECTAREA("SD2")
DBSETORDER(1)
nRegs := SD2->(RecCount())
XSD2  := XFILIAL("SD2")

DBSELECTAREA("SD3")
DBSETORDER(1)
nRegs += SD3->(RecCount())
XSD3  := XFILIAL("SD3")

DBSELECTAREA("SD1")
DBSETORDER(1)
nRegs += SD1->(RecCount())
XSD1  := XFILIAL("SD1")

DBSELECTAREA("SF4")
DBSETORDER(1)
XSF4  := XFILIAL("SF4")

DBSELECTAREA("SB2")
DBSETORDER(1)
XSB2  := XFILIAL("SB2")

DBSELECTAREA("SB1")
DBSETORDER(1)
XSB1  := XFILIAL("SB1")

aSB1Cod	:= TAMSX3("B1_COD")
aSB1Ite	:= TAMSX3("B1_CODITE")

If lVEIC
	nCOL1		:= ABS(aSB1Cod[1] - aSB1Ite[1]) + 1 +  aSB1Cod[1]
	DBSELECTAREA("SX1")
	DBSETORDER(1)
	DBSEEK(PADR(cPerg,nTamSX1))
	DO WHILE SX1->X1_GRUPO == PADR(cPerg,nTamSX1) .AND. !SX1->(EOF())
		IF "PRODU" $ UPPER(SX1->X1_PERGUNT) .AND. UPPER(SX1->X1_TIPO) == "C" .AND. ;
		(SX1->X1_TAMANHO <> aSB1Ite[1] .OR. UPPER(SX1->X1_F3) <> "VR4")
			RECLOCK("SX1",.F.)
			SX1->X1_TAMANHO := aSB1Ite[1]
			SX1->X1_F3 := "VR4"
			DBCOMMIT()
			MSUNLOCK()
		ENDIF
		DBSKIP()
	ENDDO
Else
	DBSELECTAREA("SX1")
	DBSETORDER(1)
	DBSEEK(PADR(cPerg,nTamSX1))
	DO WHILE SX1->X1_GRUPO == PADR(cPerg,nTamSX1) .AND. !SX1->(EOF())
		IF "PRODU" $ UPPER(SX1->X1_PERGUNT) .AND. UPPER(SX1->X1_TIPO) == "C" .AND. ;
		(SX1->X1_TAMANHO <> aSB1Cod[1] .OR. UPPER(SX1->X1_F3) <> "SB1")
			RECLOCK("SX1",.F.)
			SX1->X1_TAMANHO := aSB1Cod[1]
			SX1->X1_F3 := "SB1"
			DBCOMMIT()
			MSUNLOCK()
		ENDIF
		DBSKIP()
	ENDDO
EndIf
DBCOMMITALL()
RESTAREA(aArea1)

AjustaSX1()

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho)

If nLastKey == 27
	DBSELECTAREA("SB1")
	dbClearFilter()
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	DBSELECTAREA("SB1")
	dbClearFilter()
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona a ordem escolhida ao titulo do relatorio          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("NewHead")#"U"
	NewHead += " ("+AllTrim(aOrd[aReturn[8]])+")"
Else
	Titulo += " ("+AllTrim(aOrd[aReturn[8]])+")"
EndIf

if APMsgNoYes("Deseja Gerar para Excel", "Gerar Excel")
	aDir := MDirArq()
	If Empty(aDir[1]) .OR. Empty(aDir[2])
		Return
	Else
		Processa({ || MOV_EXCEL(), 'Gerando Planilha de Mapa...' } )                      
		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif
else

	RptStatus({|lEnd| C330Imp(@lEnd,wnRel,cString,tamanho,titulo)},titulo)

endif


Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C330IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 12.12.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR330			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C330Imp(lEnd,WnRel,cString,tamanho,titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis especificas deste relatorio                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL lPassou := .F. ,lTeveItem := .F. ,cTipant ,cFiliant ,nCusto
LOCAL nTvIniAlm,nTvCompra,nTvDevVen,nTvReqSOP,nTvReqCOP,nTvRE3DE3,nTvIniPrc,nTvRE2DE2,nTvFimPrc,nTvRE4DE4,nTvProduc,nTvTransf,nTvVendas,nTvFimAlm
LOCAL nTqQtdIni,nTqCompra,nTqDevVen,nTqReqSOP,nTqReqCOP,nTqRE3DE3,	nTqIniPrc,nTqRE2DE2,nTqFimPrc,nTqRE4DE4,nTqProduc,nTqTransf,nTqVendas,nTqQtdFim
LOCAL nGvIniAlm,nGvCompra,nGvDevVen,nGvReqSOP,nGvReqCOP,nGvRE3DE3,nGvIniPrc,nGvRE2DE2,nGvFimPrc,nGvRE4DE4,nGvProduc,nGvTransf,nGvVendas,nGvFimAlm
LOCAL nGqQtdIni,nGqCompra,nGqDevVen,nGqReqSOP,nGqReqCOP,nGqRE3DE3,nGqIniPrc,nGqRE2DE2,nGqFimPrc,nGqRE4DE4,nGqProduc,nGqTransf,nGqVendas,nGqQtdFim
LOCAL nAqIniAlm,nAqCompra,nAqDevVen,nAqReqSOP,nAqReqCOP,nAqRE3DE3,nAqIniPrc,nAqRE2DE2,nAqFimPrc,nAqRE4DE4,nAqProduc,nAqTransf,nAqVendas,nAqFimAlm
LOCAL nAvIniAlm,nAvCompra,nAvDevVen,nAvReqSOP,nAvReqCOP,nAvRE3DE3,nAvIniPrc,nAvRE2DE2,nAvFimPrc,nAvRE4DE4,nAvProduc,nAvTransf,nAvVendas,nAvFimAlm
LOCAL nAqEntrad,nAvEntrad,nTqEntrad,nTvEntrad,nGqEntrad,nGvEntrad
LOCAL nAqSaidas,nAvSaidas,nTqSaidas,nTvSaidas,nGqSaidas,nGvSaidas
LOCAL cCodAux := "", cLOCALAux := "  "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis para determinar as pictures usadas na impressao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cPictSD115 := PesqPict("SD1","D1_CUSTO"+If(mv_par11>1,Strzero(mv_par11,1,0),""),15,mv_par11)
LOCAL cPictSD113 := PesqPict("SD1","D1_CUSTO"+If(mv_par11>1,Strzero(mv_par11,1,0),""),13,mv_par11)
LOCAL cPictSD313 := PesqPict("SD3","D3_CUSTO"+Strzero(mv_par11,1,0),13,mv_par11)
LOCAL cPictSD314 := PesqPict("SD3","D3_CUSTO"+Strzero(mv_par11,1,0),14,mv_par11)
LOCAL cPictSD315 := PesqPict("SD3","D3_CUSTO"+Strzero(mv_par11,1,0),15,mv_par11)
LOCAL cPictSD316 := PesqPict("SD3","D3_CUSTO"+Strzero(mv_par11,1,0),16,mv_par11)
LOCAL cPictSD213 := PesqPict("SD2","D2_CUSTO"+Strzero(mv_par11,1,0),13,mv_par11)
LOCAL cPictSD216 := PesqPict("SD2","D2_CUSTO"+Strzero(mv_par11,1,0),16,mv_par11)
LOCAL cPictFim13 := PesqPict("SB2","B2_VFIM"+Str(mv_par11,1),13,mv_par11)
LOCAL cPictFim16 := PesqPict("SB2","B2_VFIM"+Str(mv_par11,1),16,mv_par11)
LOCAL cPictIni13 := PesqPict("SB9","B9_VINI"+Str(mv_par11,1),13,mv_par11)
LOCAL cPictIni16 := PesqPict("SB9","B9_VINI"+Str(mv_par11,1),16,mv_par11)
LOCAL bBloco     := { |nV,nX| Trim(nV)+Str(nX,1) }
LOCAL nVUnit     := 0
LOCAL cCondWhile, cAnt, cVar
LOCAL cTrbSB1 	 := CriaTrab("",.F.)
LOCAL cTrbSB2 	 := Subs(cTRBSB1,1,7)+"A"
LOCAL cTrbSD1 	 := Subs(cTRBSB1,1,7)+"B"
LOCAL cTrbSD2 	 := Subs(cTRBSB1,1,7)+"C"
LOCAL cTrbSD3 	 := Subs(cTRBSB1,1,7)+"D"
LOCAL nIndex	 := 0
LOCAL nIndB2     := 0
LOCAL aSldFimPrc := {0,0}
LOCAL lQuery     := .F.
LOCAL cQuery     := ""
LOCAL cQueryD1   := ""
LOCAL cQueryD2   := ""
LOCAL cQueryD3   := ""
LOCAL cQueryB1 := ""
LOCAL cQueryB1A  := ""
LOCAL cQueryB1C  := ""
LOCAL cAliasSB1  := "SB1"
LOCAL cAliasSB2  := "SB2"
LOCAL cAliasSD1  := "SD1"
LOCAL cAliasSD2  := "SD2"
LOCAL cAliasSD3  := "SD3"
LOCAL cAliasTop  := CriaTrab("",.F.)
LOCAL cB1_COD    := ""
LOCAL cB1_DESC   := ""
LOCAL cB1_UM     := ""
LOCAL nCol       := IIF(mv_par15==1,0,41)
LOCAL lRetPE	 := .F.
LOCAL lR330Trans := ExistBlock('R330TRANS')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cB1_CODITE	:= ""
LOCAL cIndexkey	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt  := SPACE(10)
cbcont := 0
li     := 80
m_pag  := 1
nTipo  := IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Cabec1 := STR0009 // 'QTD          COMPRAS    DEVOLUCOES     MOVIMENTACOES      REQUISICOES     REQUISICOES  SALDO INICIAL    APROPRIACAO   SALDO FINAL   TRANFERENCIAS        PRODUCAO TRANSFERENCIA           VENDAS        OUTRAS       OUTRAS'
Cabec2 := STR0010 // 'VALOR                     DE VENDA          INTERNAS      P/ PRODUCAO     P/ PROCESSO    EM PROCESSO   MAT.INDIRETO   EM PROCESSO        INTERNAS                 ENTRE FILIAIS                       ENTRADAS       SAIDAS'
//                         123456789012345 1234567890123  1234567890123456  124356789012356  12345678901234  1234567890123  1234567890123 1234567890123  12345678901234 123456789012345 1234567890123 1234567890123456 1234567890123 1234567890123
//                              1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//                    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

Store 0 To nGvIniAlm,nGvCompra,nGvDevVen,nGvReqSOP,nGvReqCOP
Store 0 To nGvRE3DE3,nGvIniPrc,nGvRE2DE2,nGvFimPrc,nGvRE4DE4
Store 0 To nGvProduc,nGvTransf,nGvVendas,nGvFimAlm

Store 0 To nGqQtdIni,nGqCompra,nGqDevVen,nGqReqSOP,nGqReqCOP
Store 0 To nGqRE3DE3,nGqIniPrc,nGqRE2DE2,nGqFimPrc,nGqRE4DE4
Store 0 To nGqProduc,nGqTransf,nGqVendas,nGqQtdFim

Store 0 To nGqEntrad,nGqSaidas,nGvEntrad,nGvSaidas

dbSelectArea("SB1")
if ! lVEIC
	If aReturn[8] == 1
		dbSetOrder(2)
	Else
		dbSetOrder(4)
	EndIf
	cIndexkey	:= indexkey()
else
	If aReturn[8] == 1
		dbSetOrder(2)
		cIndexkey	:= "B1_FILIAL + B1_TIPO + B1_CODITE"
	Else
		dbSetOrder(7) // B1_FILIAL+B1_GRUPO+B1_CODITE
		cIndexkey	:= indexkey()
	EndIf
EndIf
cIndexkey := ALLTRIM(cIndexkey)


dbSelectArea("SB1")
cCondWhile := IIF(!Empty(aReturn[7]), aReturn[7] + ".And." ,"")
cCondWhile += "B1_FILIAL =='" + xSB1 + "'"
If ! lVEIC
	cCondWhile += " .And. B1_COD  >='" + mv_par03 + "'"
	cCondWhile += " .And. B1_COD  <='" + mv_par04 + "'"
Else
	cCondWhile += " .And. B1_CODITE  >='" + mv_par03 + "'"
	cCondWhile += " .And. B1_CODITE  <='" + mv_par04 + "'"
EndIf
cCondWhile += " .And. B1_TIPO >='" + mv_par05 + "'"
cCondWhile += " .And. B1_TIPO <='" + mv_par06 + "'"
cCondWhile += " .And. B1_GRUPO >='" + mv_par07 + "'"
cCondWhile += " .And. B1_GRUPO <='" + mv_par08 + "'"
If "" <> cIndexkey
	IndRegua("SB1", cTrbSB1,  cIndexkey, , cCondWhile)
Else
	IndRegua("SB1", cTrbSB1, IndexKey(), , cCondWhile)
EndIf
nIndex := RetIndex("SB1")

dbSetOrder(nIndex+1)
//SetRegua(RecCount())		// Total de Elementos da regua

dbSelectArea("SB2")
dbSetOrder(1)

cCondWhile := "B2_FILIAL=='" + xSB2 + "'"
cCondWhile += " .And. B2_LOCAL >='" + mv_par01 + "'"
cCondWhile += " .And. B2_LOCAL <='" + mv_par02 + "'"

IndRegua("SB2", cTrbSB2, IndexKey(), , cCondWhile)
nIndex := RetIndex("SB2")
nIndB2 := nIndex+1
dbSetOrder(nIndB2)
dbGoTop()

dbSelectArea("SD1")
dbSetOrder(2)

cCondWhile := "D1_FILIAL=='" + xSD1 + "'"
cCondWhile += " .And. D1_LOCAL >= '" + mv_par01 + "'"
cCondWhile += " .And. D1_LOCAL <= '" + mv_par02 + "'"
cCondWhile += " .And. DTOS(D1_DTDIGIT) >= '" + DTOS(mv_par09) + "'"
cCondWhile += " .And. DTOS(D1_DTDIGIT) <= '" + DTOS(mv_par10) + "'"

If cPaisLoc <> "BRA"
	cCondWhile	+= " .And. D1_REMITO = '" + Space(TamSx3("D1_REMITO")[1]) + "' "
EndIf

IndRegua("SD1", cTrbSD1, IndexKey(), , cCondWhile)
nIndex := RetIndex("SD1")
dbSetOrder( nIndex+1 )
SetRegua( RecCount() )		// Total de Elementos da regua
dbGoTop()

dbSelectArea("SD2")
cCondWhile := "D2_FILIAL=='" + xSD2 + "'"
cCondWhile += " .And. D2_LOCAL >='" + mv_par01 + "'"
cCondWhile += " .And. D2_LOCAL <='" + mv_par02 + "'"
cCondWhile += " .And. DTOS(D2_EMISSAO) >='" + DTOS(mv_par09) + "'"
cCondWhile += " .And. DTOS(D2_EMISSAO) <='" + DTOS(mv_par10) + "'"

If cPaisLoc <> "BRA"
	cCondWhile	+= " .And. D2_REMITO = '" + Space(TamSx3("D2_REMITO")[1]) + "' "
EndIf
IndRegua("SD2",cTrbSD2,IndexKey(),,cCondWhile)
nIndex := RetIndex("SD2")
dbSetOrder(nIndex+1)
dbGoTop()

dbSelectArea("SD3")
dbSetOrder(3)

cCondWhile := "D3_FILIAL == '" + xSD3 + "'"
cCondWhile += " .And. D3_LOCAL >= '" + mv_par01 + "'"
cCondWhile += " .And. D3_LOCAL <= '" + mv_par02 + "'"
cCondWhile += " .And. DTOS(D3_EMISSAO) >= '" + DTOS(mv_par09) + "'"
cCondWhile += " .And. DTOS(D3_EMISSAO) <= '" + DTOS(mv_par10) + "'"	

IndRegua("SD3",cTrbSD3,IndexKey(),,cCondWhile)
nIndex := RetIndex("SD3")
dbSetOrder(nIndex+1)

dbSelectArea(cAliasSB1)
SetRegua(RecCount())		// Total de Elementos da regua
dbGoTop()

Do While ( !(cAliasSB1)->(Eof()) )

	If lEnd
		@PROW()+1,001 PSay STR0011	//"CANCELADO PELO OPERADOR"
		Exit
	EndIf

	cAnt := If(aReturn[8]==1,"B1_TIPO","B1_GRUPO")
	cVar := If(aReturn[8]==1, B1_TIPO , B1_GRUPO )

	Store 0 To nTvIniAlm,nTvCompra,nTvDevVen,nTvReqSOP,nTvReqCOP
	Store 0 To nTvRE3DE3,nTvIniPrc,nTvRE2DE2,nTvFimPrc,nTvRE4DE4
	Store 0 To nTvProduc,nTvTransf,nTvVendas,nTvFimAlm

	Store 0 To nTqQtdIni,nTqCompra,nTqDevVen,nTqReqSOP,nTqReqCOP
	Store 0 To nTqRE3DE3,nTqIniPrc,nTqRE2DE2,nTqFimPrc,nTqRE4DE4
	Store 0 To nTqProduc,nTqTransf,nTqVendas,nTqQtdFim

	Store 0 To nTqEntrad,nTvEntrad,nTqSaidas,nTvSaidas

	dbSelectArea(cAliasSB1)
	While (!(cAliasSB1)->( Eof() ) ) ;
	.And. ( &(cAnt) == cVar ) ;
	.And. ( (cAliasSB1)->B1_FILIAL == xSB1 )

		Store 0 To nAqIniAlm,nAqCompra,nAqDevVen,nAqReqSOP,nAqReqCOP
		Store 0 To nAqRE3DE3,nAqIniPrc,nAqRE2DE2,nAqFimPrc,nAqRE4DE4
		Store 0 To nAqProduc,nAqTransf,nAqVendas,nAqFimAlm

		Store 0 To nAvIniAlm,nAvCompra,nAvDevVen,nAvReqSOP,nAvReqCOP
		Store 0 To nAvRE3DE3,nAvIniPrc,nAvRE2DE2,nAvFimPrc,nAvRE4DE4
		Store 0 To nAvProduc,nAvTransf,nAvVendas,nAvFimAlm

		Store 0 To nAqEntrad,nAvEntrad,nAqSaidas,nAvSaidas

		If lEnd
			@PROW()+1,001 PSay STR0011	//"CANCELADO PELO OPERADOR"
			Exit
		EndIf

//		IncRegua()
//		ProcRegua(len(aConteud))
		IncProc("Gerando arquivo TMP")
		cB1_COD  := (cAliasSB1)->B1_COD
		cB1_DESC := (cAliasSB1)->B1_DESC
		cB1_UM   := (cAliasSB1)->B1_UM
		If lVEIC
			cB1_CODITE	:= (cAliasSB1)->B1_CODITE
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pega o saldo final e inicial dos almoxarifados               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea(cAliasSB2)
		dbSetOrder(nIndB2)
		dbSeek( xSB2 + cB1_COD)
		DO While ( !(cAliasSB2)->( Eof() ) );
		.And. ((cAliasSB2)->B2_COD == cB1_COD) ;
		.And. ((cAliasSB2)->B2_FILIAL == xSB2)

			If lEnd
				@PROW()+1,001 PSAY STR0013	//"CANCELADO PELO OPERADOR"
				loper:=.F.
				Exit
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Nao permite listar os produtos com Armazem em Processo       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea(cAliasSB2)
			If B2_LOCAL == cLocProc
				dbSkip()
				Loop
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Totaliza o saldo final ou atual de cada almoxarifado         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If	mv_par12 == 1
				nAqFimAlm += B2_QATU
				nAvFimAlm +=&(Eval(bBloco,"B2_VATU",mv_par11))
			Elseif mv_par12 == 2
				nAqFimAlm += B2_QFIM
				nAvFimAlm +=&(Eval(bBloco,"B2_VFIM",mv_par11))
			Else
				aSaldoFim := CalcEst((cAliasSB2)->B2_COD,(cAliasSB2)->B2_LOCAL,mv_par10+1)
				nAqFimAlm += aSaldoFim[1]
				nAvFimAlm += aSaldoFim[1+mv_par11]
			EndIf

			aSaldoIni := CalcEst((cAliasSB2)->B2_COD,(cAliasSB2)->B2_LOCAL,mv_par09)
			nAqIniAlm += aSaldoIni[1]

			nVUnit    := aSaldoIni[mv_par11+1]/If(QtdComp(nAqIniAlm)>QtdComp(0),nAqIniAlm,1)
			nAvIniAlm += If(QtdComp(nAqIniAlm)>QtdComp(0),nAqIniAlm,1) * nVUnit
			dbSelectArea(cAliasSB2)
			dbSkip()
		EndDo
		If nAqIniAlm != 0 .Or. nAvIniAlm != 0 .Or. nAqFimAlm != 0 .Or. nAvFimAlm != 0
			lPassou := .T.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pega o saldo em processo (B2_LOCAL = cLocProc)               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSaldoIni := CalcEst(cB1_COD,cLocProc,mv_par09)
		nAqIniPrc += aSaldoIni[1]
		nAvIniPrc += aSaldoIni[mv_par11+1]

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pega o saldo final em processo (B2_LOCAL = cLocProc)         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSldFimPrc := SldFimPrc(cB1_COD,cLocProc) 
		nAqFimPrc  := aSldFimPrc[1]
		nAvFimPrc  += aSldFimPrc[2]

		If nAqIniPrc != 0 .Or. nAvIniPrc != 0 .Or. nAqFimPrc != 0 .Or. nAvFimPrc != 0
			lPassou := .T.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica as Entradas                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD1")
		dbSeek( xSD1 + cB1_COD )
		SetRegua(RecCount())

		Do While (!SD1->( Eof() )) ;
		.And. (SD1->(D1_FILIAL+D1_COD) == xSD1 + cB1_COD)

			If lEnd
				@PROW()+1,001 PSAY STR0013	//"CANCELADO PELO OPERADOR"
				loper:=.F.
				Exit
			EndIf

//			IncRegua()		// Incrementa a regua
//			ProcRegua(len(aConteud))
			IncProc("Gerando arquivo TMP")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SD1")
			If D1_ORIGLAN $ "LF"
				dbSkip()
				Loop
			EndIf
			If cPaisLoc <> "BRA" .And. !Empty(D1_REMITO)
				dbSkip()
				Loop
			EndIf

			SF4->(dbSeek(xSF4 + (cAliasSD1)->D1_TES))

			If SF4->F4_ESTOQUE == "S"

				nCusto := &("D1_CUSTO"+If(mv_par11==1,"",StrZero(mv_par11,1)))

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica o ponto de entrada para considerar Transferencia ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lRetPE := If(lR330Trans .And. ValType(lRetPE := ExecBlock("R330TRANS",.F.,.F.,{ D1_CF }) ) =='L', lRetPE, .F.)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Separa as transferencias das compras                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lRetPE .Or. ( (Len(D1_CF) == 3 .And. SubStr(D1_CF,1,3)$"121/122/126/192/221/222/226/292") .Or. (Len(D1_CF) > 3 .And. SubStr(D1_CF,1,4)$"1151/1152/1552/2151/2152/2552") )
					nAqTransf += D1_QUANT
					nAvTransf += nCusto
				ElseIf D1_TIPO == "D"
					nAqDevVen += D1_QUANT
					nAvDevVen += nCusto
				ElseIf SF4->F4_PODER3 $ "RD" .And. mv_par13 == 1
					nAqEntrad += D1_QUANT
					nAvEntrad += nCusto
				Else
					nAqCompra += D1_QUANT
					nAvCompra += nCusto
				EndIf
				lPassou := .T.
			EndIf

			dbSelectArea("SD1")
			dbSkip()
		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica as Movimentacoes Internas                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD3")
		dbSeek( xSD3 + cB1_COD )
		SetRegua( RecCount() )

		Do While (!SD3->(Eof())) ;
		.And. (SD3->(D3_FILIAL+D3_COD) == xSD3 + cB1_COD)

			If lEnd
				@PROW()+1,001 PSAY STR0013	//"CANCELADO PELO OPERADOR"
				loper:=.F.
				Exit
			EndIf

			//IncRegua()		// Incrementa a regua
//			ProcRegua(len(aConteud))
			IncProc("Gerando arquivo TMP")			
			//-- Filtro para Nao imprimir OPs referentes ao SIGAMNT
			If !Empty(SD3->D3_OP) .And. MV_PAR16 == 2 .And. !__lPyme
				SC2->(dbSetOrder(1)) //-- C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
				If SC2->(dbSeek(xFilial('SC2')+SD3->D3_OP, .F.))
					If AllTrim(SC2->C2_ITEM) == 'OS' .AND. SC2->C2_SEQUEN == '001'
						dbSkip()
						Loop
					EndIf
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aglutina materiais requisitados para consumo proprio         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SD3")
			If (D3_CF$"RE0/DE0" .And. Empty(D3_OP)) .Or. (D3_CF$"RE6/DE6" .And. Empty(D3_OP))
				If D3_TM <= "500"
					nAqReqSOP += D3_QUANT
					nAvReqSOP += &(Eval(bBloco,"D3_CUSTO",mv_par11))
				Else
					nAqReqSOP -= D3_QUANT
					nAvReqSOP -= &(Eval(bBloco,"D3_CUSTO",mv_par11))
				EndIf
				lPassou := .T.
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aglutina materiais diretos utilizados em ordens de producao  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (D3_CF$"RE0/DE0" .And. !Empty(D3_OP)) .Or. (D3_CF$"RE1/DE1/RE5/DE5") .OR. (D3_CF$"RE6/DE6" .And. !Empty(D3_OP))
				If D3_TM <= "500"
					nAqReqCOP += D3_QUANT
					nAvReqCOP += &(Eval(bBloco,"D3_CUSTO",mv_par11))
				Else
					nAqReqCOP -= D3_QUANT
					nAvReqCOP -= &(Eval(bBloco,"D3_CUSTO",mv_par11))
				EndIf
				lPassou := .T.
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aglutina materiais indiretos enviados para o processo        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If D3_CF$"RE3/DE3"
				If D3_TM <= "500"
					nAqRE3DE3 += D3_QUANT
					nAvRE3DE3 += &(Eval(bBloco,"D3_CUSTO",mv_par11))
				Else
					nAqRE3DE3 -= D3_QUANT
					nAvRE3DE3 -= &(Eval(bBloco,"D3_CUSTO",mv_par11))
				EndIf
				lPassou := .T.
			EndIF

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aglutina materiais indiretos apropriados `a producao         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If D3_CF$"RE2/DE2"
				If D3_TM <= "500"
					nAqRE2DE2 += D3_QUANT
					nAvRE2DE2 += &(Eval(bBloco,"D3_CUSTO",mv_par11))
				Else
					nAqRE2DE2 -= D3_QUANT
					nAvRE2DE2 -= &(Eval(bBloco,"D3_CUSTO",mv_par11))
				EndIf
				lPassou := .T.
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aglutina as transferencias internas                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If D3_CF$"RE4/DE4/RE7/DE7"
				If D3_TM <= "500"
					nAqRE4DE4 += D3_QUANT
					nAvRE4DE4 += &(Eval(bBloco,"D3_CUSTO",mv_par11))
				Else
					nAqRE4DE4 -= D3_QUANT
					nAvRE4DE4 -= &(Eval(bBloco,"D3_CUSTO",mv_par11))
				EndIf
				lPassou := .T.
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aglutina as entradas de produtos importados                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If D3_CF$"RE8/DE8"
				If D3_TM <= "500"
					nAqCompra += D3_QUANT
					nAvCompra += &(Eval(bBloco,"D3_CUSTO",mv_par11))
				Else
					nAqCompra -= D3_QUANT
					nAvCompra -= &(Eval(bBloco,"D3_CUSTO",mv_par11))
				EndIf
				lPassou := .T.
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aglutina as producoes e subtrai os estornos                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If D3_CF$"PR0/ER0/PR1/ER1"
				If D3_TM <= "500"
					nAqProduc += D3_QUANT
					nAvProduc += &(Eval(bBloco,"D3_CUSTO",mv_par11))
				Else
					nAqProduc -= D3_QUANT
					nAvProduc -= &(Eval(bBloco,"D3_CUSTO",mv_par11))
				EndIf
				lPassou := .T.
			EndIf

			dbSelectArea("SD3")
			dbSkip()

		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica as Saidas                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD2")
		dbSeek(xSD2 + cB1_COD)
		SetRegua(RecCount())

		Do While (!SD2->(Eof())) ;
		.And. (SD2->(D2_FILIAL+D2_COD) == xSD2 + cB1_COD)

			If lEnd
				@PROW()+1,001 PSAY STR0013	//"CANCELADO PELO OPERADOR"
				loper:=.F.
				Exit
			EndIf

//			IncRegua()		// Incrementa a regua
//			ProcRegua(len(aConteud))
			IncProc("Gerando arquivo TMP")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SD2")
			If D2_ORIGLAN == "LF"
				dbSkip()
				Loop
			EndIf
			If cPaisLoc <> "BRA" .And. !Empty(D2_REMITO)
				dbSkip()
				Loop
			EndIf

			SF4->(dbSeek(xSF4 + (cAliasSD2)->D2_TES))

			If SF4->F4_ESTOQUE == "S"

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica o ponto de entrada para considerar Transferencia ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lRetPE := If(lR330Trans .And. ValType(lRetPE := ExecBlock("R330TRANS",.F.,.F.,{ D2_CF }) ) =='L', lRetPE, .F.)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Separa as transferencias das vendas                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lRetPE .Or. ( (Len(D2_CF) == 3 .And. SubStr(D2_CF,1,3)$"521/522/526/592/621/622/626/692") .Or. (Len(D2_CF) >3 .And. SubStr(D2_CF,1,4)$"5151/5152/5156/5552/6151/6152/6156/6552") )
					nAqTransf -= D2_QUANT
					nAvTransf -= &(Eval(bBloco,"D2_CUSTO",mv_par11))
				ElseIf D2_TIPO == "D"
					nAqCompra -= D2_QUANT
					nAvCompra -= &(Eval(bBloco,"D2_CUSTO",mv_par11))
				ElseIf SF4->F4_PODER3 $ "RD" .And. mv_par14 == 1
					nAqSaidas += D2_QUANT
					nAvSaidas += &(Eval(bBloco,"D2_CUSTO",mv_par11))
				Else
					nAqVendas += D2_QUANT
					nAvVendas += &(Eval(bBloco,"D2_CUSTO",mv_par11))
				EndIf
				lPassou := .T.
			EndIf
			
			dbSelectArea("SD2")
			dbSkip()
			
		EndDo
		dbSelectArea(cAliasSB1)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Rotina de Impressao                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lPassou
			If Li > 55
				Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			EndIf

			//           1         2         3         4         5         6         7         8         9        10        11
			// 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
			// 1234 123456789012345 123456789012345678901234567890 12 Quantidade Inicial 1234567890123456 Valor inicial    1234567890123456

			@ li,000 PSay cVar

			If ! lVEIC
				@ LI,005 PSay cB1_COD
			Else
				@ LI,005 PSay cB1_CODITE + ' ' + cB1_COD
			EndIf

			@ li,021 + nCOL1 PSay SubStr(cB1_DESC,1,30)
			@ li,052 + nCOL1 PSay cB1_UM
			@ li,118 PSay STR0012	//"Quantidade Inicial"
			@ li,136 PSay nAqIniAlm //Picture PesqPict(Iif(mv_par12==1,"SB2","SB9"),Iif(mv_par12==1,"B2_QATU","B9_QINI"),16)
			@ li,153 PSay STR0013	//"Valor inicial"
			@ li,166 PSay nAvIniAlm Picture cPictIni16
			If mv_par15 == 1
				@ li,184 PSay STR0019 // "Valor Inicial Medio"
				@ li,204 Psay nAvIniAlm/IIF(nAqIniAlm==0,1,nAqIniAlm) Picture cPictIni16
			EndIf
			li++
			@ li,005 PSay nAqCompra Picture PesqPict("SD1","D1_QUANT",15)
			@ li,021 PSay nAqDevVen Picture PesqPict("SD1","D1_QUANT",13)
			@ li,036 PSay nAqReqSOP Picture PesqPict("SD3","D3_QUANT",16)
			@ li,054 PSay nAqReqCOP Picture PesqPict("SD3","D3_QUANT",16)
			@ li,071 PSay nAqRE3DE3 Picture PesqPict("SD3","D3_QUANT",14)
			@ li,087 PSay nAqIniPrc Picture PesqPict("SB2","B2_QFIM",13)
			@ li,102 PSay nAqRE2DE2 Picture PesqPict("SD3","D3_QUANT",13)
			@ li,116 PSay nAqFimPrc Picture PesqPict("SB2",Iif(mv_par12==1,"B2_QATU","B2_QFIM"),13)
			@ li,131 PSay nAqRE4DE4 Picture PesqPict("SD3","D3_QUANT",14)
			@ li,146 PSay nAqProduc Picture PesqPict("SD3","D3_QUANT",15)
			@ li,162 PSay nAqTransf Picture PesqPict("SD2","D2_QUANT",13)
			@ li,176 PSay nAqVendas Picture PesqPict("SD2","D2_QUANT",16)
			@ li,193 PSay nAqEntrad Picture PesqPict("SD2","D2_QUANT",13)
			@ li,207 PSay nAqSaidas Picture PesqPict("SD2","D2_QUANT",13)
			li++
			@ li,005 PSay nAvCompra Picture cPictSD115
			@ li,021 PSay nAvDevVen Picture cPictSD113
			@ li,036 PSay nAvReqSOP Picture cPictSD316
			@ li,054 PSay nAvReqCOP Picture cPictSD316
			@ li,071 PSay nAvRE3DE3 Picture cPictSD314
			@ li,087 PSay nAvIniPrc Picture cPictIni13
			@ li,102 PSay nAvRE2DE2 Picture cPictSD313
			@ li,116 PSay nAvFimPrc Picture cPictFim13
			@ li,131 PSay nAvRE4DE4 Picture cPictSD314
			@ li,146 PSay nAvProduc Picture cPictSD315
			@ li,162 PSay nAvTransf Picture cPictSD213
			@ li,176 PSay nAvVendas Picture cPictSD216
			@ li,193 PSay nAvEntrad Picture cPictSD213
			@ li,207 PSay nAvSaidas Picture cPictSD213
			li++

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera as Req. p/ Processo e o Saldo Inicial em Processo  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nAqFimAlm += nAqIniPrc - nAqRE3DE3 + nAqRE2DE2
			nAvFimAlm += nAvIniPrc - nAvRE3DE3 + nAvRE2DE2

			@ li,119 PSay STR0014	//"Qtd. Final"
			@ li,136 PSay nAqFimAlm Picture PesqPict("SB2",Iif(mv_par12==1,"B2_QATU","B2_QFIM"),16)
			@ li,154 PSay STR0015	//"Vlr. Final"
			@ li,166 PSay nAvFimAlm Picture cPictFim16
			If mv_par15 == 1
				@ li,184 PSay STR0020
				@ li,204 Psay nAvFimAlm/IIF(nAqFimAlm==0,1,nAqFimAlm) Picture cPictFim16
			EndIf
			li++
			li++

			lPassou   := .F.
		EndIf
		dbSelectArea(cAliasSB1)
		dbSkip()
	EndDo

	If Li > 55
		Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf

	dbSelectArea(cAliasSB1)
EndDo



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga Arquivos Temporarios                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lQuery
	dbSelectArea(cAliasSB1)
	dbCloseArea()
Else
	FERASE(cTrbSB1+OrdbagExt())
	FERASE(cTrbSB2+GetDBExtension())
	FERASE(cTrbSB2+OrdbagExt())
	FERASE(cTrbSD1+GetDBExtension())
	FERASE(cTrbSD1+OrdbagExt())
	FERASE(cTrbSD2+GetDBExtension())
	FERASE(cTrbSD2+OrdbagExt())
	FERASE(cTrbSD3+GetDBExtension())
	FERASE(cTrbSD3+OrdbagExt())
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Ordem Original dos arquivos                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbClearFilter()
dbSetOrder(1)
dbSelectArea("SB2")
dbSetOrder(1)
dbSelectArea("SD1")
dbSetOrder(1)
dbSelectArea("SD2")
dbSetOrder(1)
dbSelectArea("SD3")
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer TO
	Commit
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SldFimPrc ³ Autor ³ Larson Zordan         ³ Data ³ 25.04.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pega o saldo final em processo                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR330			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SldFimPrc(cProduto,cLocProc)
Local aAreaAnt := GetArea()
Local bBloco   := { |nV,nX| Trim(nV)+Str(nX,1) }
Local aSldFim  := {}
Local nSldQtd  := 0
Local nSldVlr  := 0

dbSelectArea("SB2")
dbSetOrder(1)
If dbSeek( xFilial("SB2") + cProduto + cLocProc )
	If	mv_par12 == 1
		nSldQtd += B2_QATU
	Elseif mv_par12 == 2
		nSldQtd += B2_QFIM
	Else
		aSldFim := CalcEst(cProduto,cLocProc,mv_par10+1)
		nSldQtd += aSldFim[1]
	EndIf
	nSldVlr += If(mv_par12<3,&(Eval(bBloco,Iif(mv_par12 == 1,"B2_VATU","B2_VFIM"),mv_par11)),aSldFim[mv_par11+1])
EndIf

RestArea(aAreaAnt)
Return({nSldQtd,nSldVlr})

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1³ Autor ³ Alexandre Inacio Lemes³ Data ³27/06/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Altera o combo do parametro moeda para Get                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR330  		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()

Local aArea := { Alias(), IndexOrd() }
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}   
Local nTamSX1  := Len(SX1->X1_GRUPO)

dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(PADR("MTR330",nTamSX1)+"11")
	RecLock("SX1",.F.)
	Replace X1_TAMANHO 	with 2
	Replace X1_PRESEL   with 1
	Replace X1_GSC   	with "G"
	Replace X1_DEF01    with SPACE(15)
	Replace X1_DEFSPA1  with SPACE(15)
	Replace X1_DEFENG1  with SPACE(15)
	Replace X1_DEF02    with SPACE(15)
	Replace X1_DEFSPA2  with SPACE(15)
	Replace X1_DEFENG2  with SPACE(15)
	Replace X1_DEF03    with SPACE(15)
	Replace X1_DEFSPA3  with SPACE(15)
	Replace X1_DEFENG3  with SPACE(15)
	Replace X1_DEF04    with SPACE(15)
	Replace X1_DEFSPA4  with SPACE(15)
	Replace X1_DEFENG4  with SPACE(15)
	Replace X1_DEF05    with SPACE(15)
	Replace X1_DEFSPA5  with SPACE(15)
	Replace X1_DEFENG5  with SPACE(15)
	If Empty(X1_CNT01) .Or. Alltrim(X1_CNT01) == '0'
		Replace X1_CNT01 With ' 1'
	EndIf
	MsUnLock()
EndIf

dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(PADR("MTR330",nTamSX1)+"15") .And. (!(AllTrim(X1_PERGUNT) == "Mostrar Valor Medio ?") .Or. !(AllTrim(X1_PERENG) == "Show Average Value?"))
	RecLock("SX1",.F.)
	dbDelete()
	MsUnLock()
EndIf

PutSx1("MTR330", "15", "Mostrar Valor Medio ?","Mostrar Valor Promedio ?","Show Average Value?","mv_chf", "N", 1, 0, 2, "C","","","","", "mv_par15", "Sim","Si","Yes","","Nao", "No","No","","","","","","","","","","","","","")

dbSelectArea( aArea[1] )
dbSetOrder( aArea[2] )

aAdd(aHelpPor, 'Considera ou nao as OPs geradas pelo    ')
aAdd(aHelpPor, 'modulo de Manutencao de Ativos          ')
aAdd(aHelpPor, 'neste relatorio                         ')

aAdd( aHelpEng, 'It considers or not the POs generated by')
aAdd( aHelpEng, 'the Asset Maintenance module            ')
aAdd( aHelpEng, 'in this report                          ')

aAdd( aHelpSpa, 'Considera o no las OPs generadas por el ')
aAdd( aHelpSpa, 'modulo de Mantenimiento De Activos      ')
aAdd( aHelpSpa, 'en este informe                         ')

PutSx1( 'MTR330','16','Considera OPs do SIGAMNT     ?','¿Considera OPs do SIGAMNT    ?','Consider POs from SIGAMNT    ?','mv_chg',;
'N',1,0,1,'C','','','','N','mv_par16','Sim','Si','Yes','',;
'Nao','No','No','','','','','','','','','',;
aHelpPor,aHelpEng,aHelpSpa)

dbSelectArea("SX1")
dbSetOrder(1)
If SX1->(DbSeek (PADR("MTR330",nTamSX1)+"16"))
	RecLock("SX1",.F.)
	Replace SX1->X1_PYME With "N"
	MsUnLock()
EndIf

Return Nil

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
Local nHdl, nt, jk       := 0

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
IncProc("Gerando arquivo TMP")

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

//+-----------------------------------------------------------------------------------//
//|Funcao....: MDirArq
//|Descricao.: Defini Diretório e nome do arquivo a ser gerado
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


Static Function MOV_EXCEL()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis especificas deste relatorio                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL lPassou := .F. ,lTeveItem := .F. ,cTipant ,cFiliant ,nCusto
LOCAL nTvIniAlm,nTvCompra,nTvDevVen,nTvReqSOP,nTvReqCOP,nTvRE3DE3,nTvIniPrc,nTvRE2DE2,nTvFimPrc,nTvRE4DE4,nTvProduc,nTvTransf,nTvVendas,nTvFimAlm
LOCAL nTqQtdIni,nTqCompra,nTqDevVen,nTqReqSOP,nTqReqCOP,nTqRE3DE3,	nTqIniPrc,nTqRE2DE2,nTqFimPrc,nTqRE4DE4,nTqProduc,nTqTransf,nTqVendas,nTqQtdFim
LOCAL nGvIniAlm,nGvCompra,nGvDevVen,nGvReqSOP,nGvReqCOP,nGvRE3DE3,nGvIniPrc,nGvRE2DE2,nGvFimPrc,nGvRE4DE4,nGvProduc,nGvTransf,nGvVendas,nGvFimAlm
LOCAL nGqQtdIni,nGqCompra,nGqDevVen,nGqReqSOP,nGqReqCOP,nGqRE3DE3,nGqIniPrc,nGqRE2DE2,nGqFimPrc,nGqRE4DE4,nGqProduc,nGqTransf,nGqVendas,nGqQtdFim
LOCAL nAqIniAlm,nAqCompra,nAqDevVen,nAqReqSOP,nAqReqCOP,nAqRE3DE3,nAqIniPrc,nAqRE2DE2,nAqFimPrc,nAqRE4DE4,nAqProduc,nAqTransf,nAqVendas,nAqFimAlm
LOCAL nAvIniAlm,nAvCompra,nAvDevVen,nAvReqSOP,nAvReqCOP,nAvRE3DE3,nAvIniPrc,nAvRE2DE2,nAvFimPrc,nAvRE4DE4,nAvProduc,nAvTransf,nAvVendas,nAvFimAlm
LOCAL nAqEntrad,nAvEntrad,nTqEntrad,nTvEntrad,nGqEntrad,nGvEntrad
LOCAL nAqSaidas,nAvSaidas,nTqSaidas,nTvSaidas,nGqSaidas,nGvSaidas
LOCAL cCodAux := "", cLOCALAux := "  "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis para determinar as pictures usadas na impressao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cPictSD115 := PesqPict("SD1","D1_CUSTO"+If(mv_par11>1,Strzero(mv_par11,1,0),""),15,mv_par11)
LOCAL cPictSD113 := PesqPict("SD1","D1_CUSTO"+If(mv_par11>1,Strzero(mv_par11,1,0),""),13,mv_par11)
LOCAL cPictSD313 := PesqPict("SD3","D3_CUSTO"+Strzero(mv_par11,1,0),13,mv_par11)
LOCAL cPictSD314 := PesqPict("SD3","D3_CUSTO"+Strzero(mv_par11,1,0),14,mv_par11)
LOCAL cPictSD315 := PesqPict("SD3","D3_CUSTO"+Strzero(mv_par11,1,0),15,mv_par11)
LOCAL cPictSD316 := PesqPict("SD3","D3_CUSTO"+Strzero(mv_par11,1,0),16,mv_par11)
LOCAL cPictSD213 := PesqPict("SD2","D2_CUSTO"+Strzero(mv_par11,1,0),13,mv_par11)
LOCAL cPictSD216 := PesqPict("SD2","D2_CUSTO"+Strzero(mv_par11,1,0),16,mv_par11)
LOCAL cPictFim13 := PesqPict("SB2","B2_VFIM"+Str(mv_par11,1),13,mv_par11)
LOCAL cPictFim16 := PesqPict("SB2","B2_VFIM"+Str(mv_par11,1),16,mv_par11)
LOCAL cPictIni13 := PesqPict("SB9","B9_VINI"+Str(mv_par11,1),13,mv_par11)
LOCAL cPictIni16 := PesqPict("SB9","B9_VINI"+Str(mv_par11,1),16,mv_par11)
LOCAL bBloco     := { |nV,nX| Trim(nV)+Str(nX,1) }
LOCAL nVUnit     := 0
LOCAL cCondWhile, cAnt, cVar
LOCAL cTrbSB1 	 := CriaTrab("",.F.)
LOCAL cTrbSB2 	 := Subs(cTRBSB1,1,7)+"A"
LOCAL cTrbSD1 	 := Subs(cTRBSB1,1,7)+"B"
LOCAL cTrbSD2 	 := Subs(cTRBSB1,1,7)+"C"
LOCAL cTrbSD3 	 := Subs(cTRBSB1,1,7)+"D"
LOCAL nIndex	 := 0
LOCAL nIndB2     := 0
LOCAL aSldFimPrc := {0,0}
LOCAL lQuery     := .F.
LOCAL cQuery     := ""
LOCAL cQueryD1   := ""
LOCAL cQueryD2   := ""
LOCAL cQueryD3   := ""
LOCAL cQueryB1 := ""
LOCAL cQueryB1A  := ""
LOCAL cQueryB1C  := ""
LOCAL cAliasSB1  := "SB1"
LOCAL cAliasSB2  := "SB2"
LOCAL cAliasSD1  := "SD1"
LOCAL cAliasSD2  := "SD2"
LOCAL cAliasSD3  := "SD3"
LOCAL cAliasTop  := CriaTrab("",.F.)
LOCAL cB1_COD    := ""
LOCAL cB1_DESC   := ""
LOCAL cB1_UM     := ""
LOCAL nCol       := IIF(mv_par15==1,0,41)
LOCAL lRetPE	 := .F.
LOCAL lR330Trans := ExistBlock('R330TRANS')


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cB1_CODITE	:= ""
LOCAL cIndexkey	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nTipo  := IIF(aReturn[4]==1,15,18)



aAdd(aConteud,{"","MAPA DE MOVIMENTACAO DE PRODUTO","","","","","","","","","","","","","","","","","",""})
aAdd(aConteud,{"","","","","","","","","","","","","","","","","","","",""}) //20 colunas

//                   1      2       3         4           5             6         7               8            9                10            11                            12                 13                        14          15               16              17            18               19                20
aAdd(aConteud,{"GRUPO","TIPO","CODIGO","DESCRICAO","SALDO INICIAL","COMPRAS","DEV.VENDAS","MOV.INTERNAS","REQ.PRODUCAO","REQ.PROCESSO","SLD INICIAL EM PROCESSO","APROPR.MAT.INDIRETO","SLD FINAL EMP PROCESSO","TRASNF.INTERNA","PRODUCAO ", "TRANSF.ENTR.FILIAIS","VENDAS","OUTRAS SAIDAS","OUTRAS ENTRADAS", "SALDO FINAL"})



Store 0 To nGvIniAlm,nGvCompra,nGvDevVen,nGvReqSOP,nGvReqCOP
Store 0 To nGvRE3DE3,nGvIniPrc,nGvRE2DE2,nGvFimPrc,nGvRE4DE4
Store 0 To nGvProduc,nGvTransf,nGvVendas,nGvFimAlm

Store 0 To nGqQtdIni,nGqCompra,nGqDevVen,nGqReqSOP,nGqReqCOP
Store 0 To nGqRE3DE3,nGqIniPrc,nGqRE2DE2,nGqFimPrc,nGqRE4DE4
Store 0 To nGqProduc,nGqTransf,nGqVendas,nGqQtdFim

Store 0 To nGqEntrad,nGqSaidas,nGvEntrad,nGvSaidas

dbSelectArea("SB1")
if ! lVEIC
	If aReturn[8] == 1
		dbSetOrder(2)
	Else
		dbSetOrder(4)
	EndIf
	cIndexkey	:= indexkey()
else
	If aReturn[8] == 1
		dbSetOrder(2)
		cIndexkey	:= "B1_FILIAL + B1_TIPO + B1_CODITE"
	Else
		dbSetOrder(7) // B1_FILIAL+B1_GRUPO+B1_CODITE
		cIndexkey	:= indexkey()
	EndIf
EndIf
cIndexkey := ALLTRIM(cIndexkey)


dbSelectArea("SB1")
cCondWhile := IIF(!Empty(aReturn[7]), aReturn[7] + ".And." ,"")
cCondWhile += "B1_FILIAL =='" + xSB1 + "'"
If ! lVEIC
	cCondWhile += " .And. B1_COD  >='" + mv_par03 + "'"
	cCondWhile += " .And. B1_COD  <='" + mv_par04 + "'"
Else
	cCondWhile += " .And. B1_CODITE  >='" + mv_par03 + "'"
	cCondWhile += " .And. B1_CODITE  <='" + mv_par04 + "'"
EndIf
cCondWhile += " .And. B1_TIPO >='" + mv_par05 + "'"
cCondWhile += " .And. B1_TIPO <='" + mv_par06 + "'"
cCondWhile += " .And. B1_GRUPO >='" + mv_par07 + "'"
cCondWhile += " .And. B1_GRUPO <='" + mv_par08 + "'"
If "" <> cIndexkey
	IndRegua("SB1", cTrbSB1,  cIndexkey, , cCondWhile)
Else
	IndRegua("SB1", cTrbSB1, IndexKey(), , cCondWhile)
EndIf
nIndex := RetIndex("SB1")

dbSetOrder(nIndex+1)

dbSelectArea("SB2")
dbSetOrder(1)

cCondWhile := "B2_FILIAL=='" + xSB2 + "'"
cCondWhile += " .And. B2_LOCAL >='" + mv_par01 + "'"
cCondWhile += " .And. B2_LOCAL <='" + mv_par02 + "'"

IndRegua("SB2", cTrbSB2, IndexKey(), , cCondWhile)
nIndex := RetIndex("SB2")
nIndB2 := nIndex+1
dbSetOrder(nIndB2)
dbGoTop()

dbSelectArea("SD1")
dbSetOrder(2)

cCondWhile := "D1_FILIAL=='" + xSD1 + "'"
cCondWhile += " .And. D1_LOCAL >= '" + mv_par01 + "'"
cCondWhile += " .And. D1_LOCAL <= '" + mv_par02 + "'"
cCondWhile += " .And. DTOS(D1_DTDIGIT) >= '" + DTOS(mv_par09) + "'"
cCondWhile += " .And. DTOS(D1_DTDIGIT) <= '" + DTOS(mv_par10) + "'"

If cPaisLoc <> "BRA"
	cCondWhile	+= " .And. D1_REMITO = '" + Space(TamSx3("D1_REMITO")[1]) + "' "
EndIf

IndRegua("SD1", cTrbSD1, IndexKey(), , cCondWhile)
nIndex := RetIndex("SD1")
dbSetOrder( nIndex+1 )
ProcREgua( Reccount() )
IncProc("Gerando arquivo TMP")
dbGoTop()

dbSelectArea("SD2")
cCondWhile := "D2_FILIAL=='" + xSD2 + "'"
cCondWhile += " .And. D2_LOCAL >='" + mv_par01 + "'"
cCondWhile += " .And. D2_LOCAL <='" + mv_par02 + "'"
cCondWhile += " .And. DTOS(D2_EMISSAO) >='" + DTOS(mv_par09) + "'"
cCondWhile += " .And. DTOS(D2_EMISSAO) <='" + DTOS(mv_par10) + "'"

If cPaisLoc <> "BRA"
	cCondWhile	+= " .And. D2_REMITO = '" + Space(TamSx3("D2_REMITO")[1]) + "' "
EndIf
IndRegua("SD2",cTrbSD2,IndexKey(),,cCondWhile)
nIndex := RetIndex("SD2")
dbSetOrder(nIndex+1)
dbGoTop()

dbSelectArea("SD3")
dbSetOrder(3)

cCondWhile := "D3_FILIAL == '" + xSD3 + "'"
cCondWhile += " .And. D3_LOCAL >= '" + mv_par01 + "'"
cCondWhile += " .And. D3_LOCAL <= '" + mv_par02 + "'"
cCondWhile += " .And. DTOS(D3_EMISSAO) >= '" + DTOS(mv_par09) + "'"
cCondWhile += " .And. DTOS(D3_EMISSAO) <= '" + DTOS(mv_par10) + "'"	

IndRegua("SD3",cTrbSD3,IndexKey(),,cCondWhile)
nIndex := RetIndex("SD3")
dbSetOrder(nIndex+1)

dbSelectArea(cAliasSB1)
dbGoTop()
count:=1
Do While ( !(cAliasSB1)->(Eof()) )

	If lEnd
		@PROW()+1,001 PSay STR0011	//"CANCELADO PELO OPERADOR"
		Exit
	EndIf

	cAnt := If(aReturn[8]==1,"B1_TIPO","B1_GRUPO")
	cVar := If(aReturn[8]==1, B1_TIPO , B1_GRUPO )

	Store 0 To nTvIniAlm,nTvCompra,nTvDevVen,nTvReqSOP,nTvReqCOP
	Store 0 To nTvRE3DE3,nTvIniPrc,nTvRE2DE2,nTvFimPrc,nTvRE4DE4
	Store 0 To nTvProduc,nTvTransf,nTvVendas,nTvFimAlm

	Store 0 To nTqQtdIni,nTqCompra,nTqDevVen,nTqReqSOP,nTqReqCOP
	Store 0 To nTqRE3DE3,nTqIniPrc,nTqRE2DE2,nTqFimPrc,nTqRE4DE4
	Store 0 To nTqProduc,nTqTransf,nTqVendas,nTqQtdFim

	Store 0 To nTqEntrad,nTvEntrad,nTqSaidas,nTvSaidas

	dbSelectArea(cAliasSB1)
	While (!(cAliasSB1)->( Eof() ) ) ;
	.And. ( &(cAnt) == cVar ) ;
	.And. ( (cAliasSB1)->B1_FILIAL == xSB1 )

		Store 0 To nAqIniAlm,nAqCompra,nAqDevVen,nAqReqSOP,nAqReqCOP
		Store 0 To nAqRE3DE3,nAqIniPrc,nAqRE2DE2,nAqFimPrc,nAqRE4DE4
		Store 0 To nAqProduc,nAqTransf,nAqVendas,nAqFimAlm

		Store 0 To nAvIniAlm,nAvCompra,nAvDevVen,nAvReqSOP,nAvReqCOP
		Store 0 To nAvRE3DE3,nAvIniPrc,nAvRE2DE2,nAvFimPrc,nAvRE4DE4
		Store 0 To nAvProduc,nAvTransf,nAvVendas,nAvFimAlm

		Store 0 To nAqEntrad,nAvEntrad,nAqSaidas,nAvSaidas

		If lEnd
			@PROW()+1,001 PSay STR0011	//"CANCELADO PELO OPERADOR"
			Exit
		EndIf

		IncProc("Gerando arquivo TMP....Registro-> "+cValToChar(count))		

		cB1_COD  := (cAliasSB1)->B1_COD
		cB1_DESC := (cAliasSB1)->B1_DESC
		cB1_UM   := (cAliasSB1)->B1_UM
		If lVEIC
			cB1_CODITE	:= (cAliasSB1)->B1_CODITE
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pega o saldo final e inicial dos almoxarifados               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea(cAliasSB2)
		dbSetOrder(nIndB2)
		dbSeek( xSB2 + cB1_COD)
		DO While ( !(cAliasSB2)->( Eof() ) );
		.And. ((cAliasSB2)->B2_COD == cB1_COD) ;
		.And. ((cAliasSB2)->B2_FILIAL == xSB2)

			If lEnd
				aAdd(aConteud,{"","","","",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) //20 colunas
				aConteud [len(aConteud),1] := "CANCELADO PELO OPERADO...."
				loper:=.F.
				Exit
			EndIf
                

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Nao permite listar os produtos com Armazem em Processo       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea(cAliasSB2)
			If B2_LOCAL == cLocProc
				dbSkip()
				Loop
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Totaliza o saldo final ou atual de cada almoxarifado         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If	mv_par12 == 1
				nAqFimAlm += B2_QATU
				nAvFimAlm +=&(Eval(bBloco,"B2_VATU",mv_par11))
			Elseif mv_par12 == 2
				nAqFimAlm += B2_QFIM
				nAvFimAlm +=&(Eval(bBloco,"B2_VFIM",mv_par11))
			Else
				aSaldoFim := CalcEst((cAliasSB2)->B2_COD,(cAliasSB2)->B2_LOCAL,mv_par10+1)
				nAqFimAlm += aSaldoFim[1]
				nAvFimAlm += aSaldoFim[1+mv_par11]
			EndIf

			aSaldoIni := CalcEst((cAliasSB2)->B2_COD,(cAliasSB2)->B2_LOCAL,mv_par09)
			nAqIniAlm += aSaldoIni[1]

			nVUnit    := aSaldoIni[mv_par11+1]/If(QtdComp(nAqIniAlm)>QtdComp(0),nAqIniAlm,1)
			nAvIniAlm += If(QtdComp(nAqIniAlm)>QtdComp(0),nAqIniAlm,1) * nVUnit
			dbSelectArea(cAliasSB2)
			dbSkip()
		EndDo
		If nAqIniAlm != 0 .Or. nAvIniAlm != 0 .Or. nAqFimAlm != 0 .Or. nAvFimAlm != 0
			lPassou := .T.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pega o saldo em processo (B2_LOCAL = cLocProc)               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSaldoIni := CalcEst(cB1_COD,cLocProc,mv_par09)
		nAqIniPrc += aSaldoIni[1]
		nAvIniPrc += aSaldoIni[mv_par11+1]

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pega o saldo final em processo (B2_LOCAL = cLocProc)         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSldFimPrc := SldFimPrc(cB1_COD,cLocProc) 
		nAqFimPrc  := aSldFimPrc[1]
		nAvFimPrc  += aSldFimPrc[2]

		If nAqIniPrc != 0 .Or. nAvIniPrc != 0 .Or. nAqFimPrc != 0 .Or. nAvFimPrc != 0
			lPassou := .T.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica as Entradas                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD1")
		dbSeek( xSD1 + cB1_COD )

		Do While (!SD1->( Eof() )) ;
		.And. (SD1->(D1_FILIAL+D1_COD) == xSD1 + cB1_COD)

			If lEnd
				aAdd(aConteud,{"","","","",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) //20 colunas
				aConteud [len(aConteud),1] := "CANCELADO PELO OPERADO...."
				loper:=.F.
				Exit
			EndIf

			IncProc("Gerando arquivo TMP....Registro de Entrada-> "+cValToChar(count))		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SD1")
			If D1_ORIGLAN $ "LF"
				dbSkip()
				Loop
			EndIf
			If cPaisLoc <> "BRA" .And. !Empty(D1_REMITO)
				dbSkip()
				Loop
			EndIf

			SF4->(dbSeek(xSF4 + (cAliasSD1)->D1_TES))

			If SF4->F4_ESTOQUE == "S"

				nCusto := &("D1_CUSTO"+If(mv_par11==1,"",StrZero(mv_par11,1)))

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica o ponto de entrada para considerar Transferencia ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lRetPE := If(lR330Trans .And. ValType(lRetPE := ExecBlock("R330TRANS",.F.,.F.,{ D1_CF }) ) =='L', lRetPE, .F.)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Separa as transferencias das compras                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lRetPE .Or. ( (Len(D1_CF) == 3 .And. SubStr(D1_CF,1,3)$"121/122/126/192/221/222/226/292") .Or. (Len(D1_CF) > 3 .And. SubStr(D1_CF,1,4)$"1151/1152/1552/2151/2152/2552") )
					nAqTransf += D1_QUANT
					nAvTransf += nCusto
				ElseIf D1_TIPO == "D"
					nAqDevVen += D1_QUANT
					nAvDevVen += nCusto
				ElseIf SF4->F4_PODER3 $ "RD" .And. mv_par13 == 1
					nAqEntrad += D1_QUANT
					nAvEntrad += nCusto
				Else
					nAqCompra += D1_QUANT
					nAvCompra += nCusto
				EndIf
				lPassou := .T.
			EndIf
            count++
			dbSelectArea("SD1")
			dbSkip()
		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica as Movimentacoes Internas                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD3")
		dbSeek( xSD3 + cB1_COD )
		Count := 1
		Do While (!SD3->(Eof())) ;
		.And. (SD3->(D3_FILIAL+D3_COD) == xSD3 + cB1_COD)

			If lEnd
				aAdd(aConteud,{"","","","",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) //20 colunas
				aConteud [len(aConteud),1] := "CANCELADO PELO OPERADO...."
				loper:=.F.
				Exit
			EndIf

			IncProc("Gerando arquivo TMP....Movimentacoes Interna-> "+cValToChar(Count))
			//-- Filtro para Nao imprimir OPs referentes ao SIGAMNT
			If !Empty(SD3->D3_OP) .And. MV_PAR16 == 2 .And. !__lPyme
				SC2->(dbSetOrder(1)) //-- C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
				If SC2->(dbSeek(xFilial('SC2')+SD3->D3_OP, .F.))
					If AllTrim(SC2->C2_ITEM) == 'OS' .AND. SC2->C2_SEQUEN == '001'
						dbSkip()
						Loop
					EndIf
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aglutina materiais requisitados para consumo proprio         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SD3")
			If (D3_CF$"RE0/DE0" .And. Empty(D3_OP)) .Or. (D3_CF$"RE6/DE6" .And. Empty(D3_OP))
				If D3_TM <= "500"
					nAqReqSOP += D3_QUANT
					nAvReqSOP += &(Eval(bBloco,"D3_CUSTO",mv_par11))
				Else
					nAqReqSOP -= D3_QUANT
					nAvReqSOP -= &(Eval(bBloco,"D3_CUSTO",mv_par11))
				EndIf
				lPassou := .T.
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aglutina materiais diretos utilizados em ordens de producao  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (D3_CF$"RE0/DE0" .And. !Empty(D3_OP)) .Or. (D3_CF$"RE1/DE1/RE5/DE5") .OR. (D3_CF$"RE6/DE6" .And. !Empty(D3_OP))
				If D3_TM <= "500"
					nAqReqCOP += D3_QUANT
					nAvReqCOP += &(Eval(bBloco,"D3_CUSTO",mv_par11))
				Else
					nAqReqCOP -= D3_QUANT
					nAvReqCOP -= &(Eval(bBloco,"D3_CUSTO",mv_par11))
				EndIf
				lPassou := .T.
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aglutina materiais indiretos enviados para o processo        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If D3_CF$"RE3/DE3"
				If D3_TM <= "500"
					nAqRE3DE3 += D3_QUANT
					nAvRE3DE3 += &(Eval(bBloco,"D3_CUSTO",mv_par11))
				Else
					nAqRE3DE3 -= D3_QUANT
					nAvRE3DE3 -= &(Eval(bBloco,"D3_CUSTO",mv_par11))
				EndIf
				lPassou := .T.
			EndIF

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aglutina materiais indiretos apropriados `a producao         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If D3_CF$"RE2/DE2"
				If D3_TM <= "500"
					nAqRE2DE2 += D3_QUANT
					nAvRE2DE2 += &(Eval(bBloco,"D3_CUSTO",mv_par11))
				Else
					nAqRE2DE2 -= D3_QUANT
					nAvRE2DE2 -= &(Eval(bBloco,"D3_CUSTO",mv_par11))
				EndIf
				lPassou := .T.
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aglutina as transferencias internas                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If D3_CF$"RE4/DE4/RE7/DE7"
				If D3_TM <= "500"
					nAqRE4DE4 += D3_QUANT
					nAvRE4DE4 += &(Eval(bBloco,"D3_CUSTO",mv_par11))
				Else
					nAqRE4DE4 -= D3_QUANT
					nAvRE4DE4 -= &(Eval(bBloco,"D3_CUSTO",mv_par11))
				EndIf
				lPassou := .T.
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aglutina as entradas de produtos importados                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If D3_CF$"RE8/DE8"
				If D3_TM <= "500"
					nAqCompra += D3_QUANT
					nAvCompra += &(Eval(bBloco,"D3_CUSTO",mv_par11))
				Else
					nAqCompra -= D3_QUANT
					nAvCompra -= &(Eval(bBloco,"D3_CUSTO",mv_par11))
				EndIf
				lPassou := .T.
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aglutina as producoes e subtrai os estornos                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If D3_CF$"PR0/ER0/PR1/ER1"
				If D3_TM <= "500"
					nAqProduc += D3_QUANT
					nAvProduc += &(Eval(bBloco,"D3_CUSTO",mv_par11))
				Else
					nAqProduc -= D3_QUANT
					nAvProduc -= &(Eval(bBloco,"D3_CUSTO",mv_par11))
				EndIf
				lPassou := .T.
			EndIf

			dbSelectArea("SD3")
			dbSkip()
            Count++
		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica as Saidas                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD2")
		dbSeek(xSD2 + cB1_COD)
        Count:= 1
		Do While (!SD2->(Eof())) ;
		.And. (SD2->(D2_FILIAL+D2_COD) == xSD2 + cB1_COD)

			If lEnd
				aAdd(aConteud,{"","","","",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) //20 colunas
				aConteud [len(aConteud),1] := "CANCELADO PELO OPERADO...."
				loper:=.F.
				Exit
			EndIf

			IncProc("Gerando arquivo TMP....Registros de Saidas-> "+cValToChar(Count))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SD2")
			If D2_ORIGLAN == "LF"
				dbSkip()
				Loop
			EndIf
			If cPaisLoc <> "BRA" .And. !Empty(D2_REMITO)
				dbSkip()
				Loop
			EndIf

			SF4->(dbSeek(xSF4 + (cAliasSD2)->D2_TES))

			If SF4->F4_ESTOQUE == "S"

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica o ponto de entrada para considerar Transferencia ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lRetPE := If(lR330Trans .And. ValType(lRetPE := ExecBlock("R330TRANS",.F.,.F.,{ D2_CF }) ) =='L', lRetPE, .F.)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Separa as transferencias das vendas                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lRetPE .Or. ( (Len(D2_CF) == 3 .And. SubStr(D2_CF,1,3)$"521/522/526/592/621/622/626/692") .Or. (Len(D2_CF) >3 .And. SubStr(D2_CF,1,4)$"5151/5152/5156/5552/6151/6152/6156/6552") )
					nAqTransf -= D2_QUANT
					nAvTransf -= &(Eval(bBloco,"D2_CUSTO",mv_par11))
				ElseIf D2_TIPO == "D"
					nAqCompra -= D2_QUANT
					nAvCompra -= &(Eval(bBloco,"D2_CUSTO",mv_par11))
				ElseIf SF4->F4_PODER3 $ "RD" .And. mv_par14 == 1
					nAqSaidas += D2_QUANT
					nAvSaidas += &(Eval(bBloco,"D2_CUSTO",mv_par11))
				Else
					nAqVendas += D2_QUANT
					nAvVendas += &(Eval(bBloco,"D2_CUSTO",mv_par11))
				EndIf
				lPassou := .T.
			EndIf
			
			dbSelectArea("SD2")
			dbSkip()
			Count++
		EndDo
		dbSelectArea(cAliasSB1)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Rotina de Impressao                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lPassou

			aAdd(aConteud,{"","","","",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) //20 colunas
			
		IncProc("Gerando arquivo TMP....Gravando no Excel...")
			aConteud [len(aConteud),1] := "'"+Posicione("SB1",1,xFilial("SB1")+cB1_COD,"B1_GRUPO")
            aConteud [len(aConteud),2] := cB1_UM
            aConteud [len(aConteud),3] := cB1_COD+"'"
            aConteud [len(aConteud),4] := cB1_DESC
			aConteud [Len(aConteud),5] := nAqIniAlm //Iif(mv_par12==1,"B2_QATU","B9_QINI")
			aConteud [Len(aConteud),6] := nAqCompra  //COMPRAS
			aConteud [Len(aConteud),7] := nAqDevVen //DEV.VENDAS
			aConteud [Len(aConteud),8] := nAqReqSOP //REQ.PRODUCAO
			aConteud [Len(aConteud),9] := nAqReqCOP //REQ.PROCESSO
			aConteud [Len(aConteud),10] := nAqRE3DE3
			aConteud [Len(aConteud),11] := nAqIniPrc
			aConteud [Len(aConteud),12] := nAqRE2DE2
			aConteud [Len(aConteud),13] := nAqFimPrc
			aConteud [Len(aConteud),14] := nAqRE4DE4
			aConteud [Len(aConteud),15] := nAqProduc
			aConteud [Len(aConteud),16] := nAqTransf
			aConteud [Len(aConteud),17] := nAqVendas
			aConteud [Len(aConteud),18] := nAqEntrad
			aConteud [Len(aConteud),19] := nAqSaidas

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera as Req. p/ Processo e o Saldo Inicial em Processo  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nAqFimAlm += nAqIniPrc - nAqRE3DE3 + nAqRE2DE2
			aConteud [Len(aConteud),20] := nAqFimAlm

			lPassou   := .F.
		EndIf
		dbSelectArea(cAliasSB1)
		dbSkip()
	EndDo

	dbSelectArea(cAliasSB1)
EndDo



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga Arquivos Temporarios                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lQuery
	dbSelectArea(cAliasSB1)
	dbCloseArea()
Else
	FERASE(cTrbSB1+OrdbagExt())
	FERASE(cTrbSB2+GetDBExtension())
	FERASE(cTrbSB2+OrdbagExt())
	FERASE(cTrbSD1+GetDBExtension())
	FERASE(cTrbSD1+OrdbagExt())
	FERASE(cTrbSD2+GetDBExtension())
	FERASE(cTrbSD2+OrdbagExt())
	FERASE(cTrbSD3+GetDBExtension())
	FERASE(cTrbSD3+OrdbagExt())
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Ordem Original dos arquivos                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbClearFilter()
dbSetOrder(1)
dbSelectArea("SB2")
dbSetOrder(1)
dbSelectArea("SD1")
dbSetOrder(1)
dbSelectArea("SD2")
dbSetOrder(1)
dbSelectArea("SD3")
dbSetOrder(1)
Return

