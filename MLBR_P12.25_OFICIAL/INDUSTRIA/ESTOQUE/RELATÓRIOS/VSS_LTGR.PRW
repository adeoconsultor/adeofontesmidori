#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

#define STR0001  "Este programa emitira um Kardex com todas as movimentacoes"
#define STR0002  "do estoque por Lote/Sub-Lote, diariamente. Observacao: o primeiro"
#define STR0003  "movimento de cada Lote/Sub-Lote se refere a criacao do mesmo."
#define STR0004  "Kardex por Lote/Sub-Lote (por produto)"
#define STR0005  "Zebrado"
#define STR0006  "Administracao"
#define STR0007  "Armazem Data Movim.   Valid. Lote    Documento       Origem Lcto.    Estornado           Entrada             Saida             Saldo"
#define STR0008  "CANCELADO PELO OPERADOR"
#define STR0009  "Produto: "
#define STR0010  "Descricao: "
#define STR0011  "Tipo: "
#define STR0012  "Unidade: "
#define STR0013  "Sub-Lote: "
#define STR0014  "Lote: "
#define STR0015  "Saldo Inicial: "
#define STR0016  "Total do Sub-Lote -> "
#define STR0017  "Total do Lote -> "
#define STR0018  "Total do Produto -> "
#define STR0019  "Selecionando Registros..."
#define STR0020  "Descr. Arm.: "
#define STR0023  "Documento"
#define STR0024  "Tipo"
#define STR0025  "Entrada"
#define STR0026  "Saida"
#define STR0027  "Saldo"
#define STR0028  "Produtos"
#define STR0029  "Saldos por Lote"
#define STR0030  "Movimentos por Lote"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o     ³ VSS_LTGR ³ Autor ³Alexandre Inacio Lemes³ Data ³28/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Kardex p/ Lote e por Grupo Sobre o SD5                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³ MATR435(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Generico                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Manutencao ³ Por Vinicius de Sousa Schwartz - TI / Midori Atlantica    ³±±
±±³           ³ Em 25/04/2012 para adicionar opcao de filtro por grupo    ³±±
±±³           ³ de produto - Solic. Thiago Cruz - Midori Atlantica        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function VSS_LTGR()     

Local oReport           

If FindFunction("TRepInUse") .And. TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:= ReportDef()
	oReport:PrintDialog()
Else
	MATR435R3()
EndIf                   
 
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ReportDef³Autor  ³Alexandre Inacio Lemes ³Data  ³28/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Kardex p/ Lote Sobre o SD5                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ oExpO1: Objeto do relatorio                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local cTitle      := STR0004 //"Kardex por Lote/Sub-Lote (por produto)"
Local cPicSaldo   := PesqPict("SB8","B8_SALDO"  ,18)
Local cPicEmpenho := PesqPict("SB8","B8_EMPENHO",18)
Local oReport 
Local oSection1
Local oSection2
Local oSection3
Local nTamDoc     := Max(TamSX3("D5_DOC")[1], TamSX3("D5_OP")[1])

#IFDEF TOP
	Local cAliasSB8 := GetNextAlias()
#ELSE
	Local cAliasSB8 := "SB8"
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                     	 ³
//³ mv_par01       	// Do  Produto                         	 	 ³
//³ mv_par02        // Ate Produto                         	 	 ³
//³ mv_par03        // De  Lote                            	 	 ³
//³ mv_par04        // Ate Lote			        			 	 ³
//³ mv_par05        // De  Sub-Lote                          	 ³
//³ mv_par06        // Ate Sub-Lote			        		 	 ³
//³ mv_par07        // De  Local		        			 	 ³
//³ mv_par08        // Ate Local							 	 ³
//³ mv_par09        // De  Data			        			 	 ³
//³ mv_par10        // Ate Data								 	 ³
//³ mv_par11       	// Lotes/Sub S/ Movimentos (Lista/Nao Lista) ³
//³ mv_par12       	// Lote/Sub Saldo Zerado   (Lista/Nao Lista) ³ 
//³ mv_par13       	// QTDE. na 2a. U.M. ?     (Sim/Nao)         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()
Pergunte("MR435A",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Descricao do Relatorio                                                 ³
//³                                                                        ³
//³ STR0001	//"Este programa emitir  um Kardex com todas as movimenta‡”es" ³
//³ STR0002	//"do estoque por Lote/Sub-Lote, diariamente. Observa‡„o: o 1o"³                                                                        
//³ STR0003	//"movimento de cada Lote/Sub-Lote se refere a cria‡„o do mesmo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:= TReport():New("MATR435",cTitle,"MR435A", {|oReport| ReportPrint(oReport,cAliasSB8)},STR0001+" "+STR0002+" "+STR0003)
oReport:SetTotalInLine(.F.)
oReport:SetPortrait() 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1:= TRSection():New(oReport,STR0028,{"SB8","SB1","SB2"}) //"Produtos"
oSection1:SetTotalInLine(.F.)
oSection1:SetTotalText(" ")
oSection1:SetLineStyle()
oSection1:SetNoFilter("SB1")
oSection1:SetNoFilter("SB2")

TRCell():New(oSection1,"B8_PRODUTO","SB8",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_DESC"   ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_TIPO"   ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_UM"     ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| If(mv_par13 <> 1 ,SB1->B1_UM,SB1->B1_SEGUM)})
TRCell():New(oSection1,"B2_LOCALIZ","SB2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_GRUPO","SB1","	Grupo",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection2:= TRSection():New(oSection1,STR0029,{"SB8"}) //"Saldos por Lote"
oSection2:SetTotalInLine(.F.)
oSection2:SetTotalText(" ")
oSection2:SetLineStyle()

TRCell():New(oSection2,"B8_NUMLOTE","SB8",STR0013	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"B8_LOTECTL","SB8",STR0014	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"SP1"       ,"   "," "		,/*Picture*/,47			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"SALDO"     ,"   ",STR0015	,cPicSaldo	,18			,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection2,"TOTAL"     ,"   "," "		,cPicSaldo	,18			,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
oSection2:Cell("SP1"):HideHeader()
oSection2:Cell("TOTAL"):Hide()
oSection2:SetCharSeparator("")

oSection3:= TRSection():New(oSection2,STR0030,{"SD5","SB8"}) //"Movimentos por Lote"
oSection3:SetTotalInLine(.F.)
oSection3:SetHeaderPage()
oSection3:SetNoFilter("SD5")
 
TRCell():New(oSection3,"D5_LOCAL"  ,"SD5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"D5_DATA"   ,"SD5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"D5_DTVALID","SD5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"D5_OP"     ,"SD5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"NUMDOC"    ,"SD5",STR0023	,/*Picture*/, nTamDoc	,/*lPixel*/,{|| If(!Empty(SD5->D5_OP) , SD5->D5_OP , SD5->D5_DOC ) })

If cPaisLoc != "BRA"
	TRCell():New(oSection3,"DESCDOC","   ",STR0024,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| If( AllTrim(SD5->D5_SERIE) == "X" , If(cPaisLoc == "CHI" ,"GUI","REM") , "FAC" ) })
EndIf

TRCell():New(oSection3,"D5_ORIGLAN","SD5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"D5_ESTORNO","SD5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"ENTRADA"   ,"   ",STR0025	 ,cPicSaldo  ,18		 ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection3,"SAIDA"     ,"   ",STR0026	 ,cPicEmpenho,18		 ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection3,"SALDO"     ,"   ",STR0027	 ,cPicSaldo  ,18		 ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Alexandre Inacio Lemes ³Data  ³28/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Kardex p/ Lote Sobre o SD5                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasSB8)

Local oSection1 := oReport:Section(1) 
Local oSection2 := oReport:Section(1):Section(1)  
Local oSection3 := oReport:Section(1):Section(1):Section(1)  
Local cCampo    := ""
Local cCompara  := ""
Local cLote     := ""
Local cLocal    := ""
Local cSubLote  := ""
Local cProduto  := ""
Local cProdAnt  := ""
Local cCondicao := ""
Local cWorkSD5  := ""
Local cFilter   := ""
Local cWhere    := ""
Local lProd     := .T.					
Local lLote     := .T.					
Local lLoteZera := .T.                  
Local lMovSD5   := .T.
Local lOkSublote:= .F.
Local lSeek     := .F.
Local nEntrada  := 0
Local nSaida    := 0
Local nSaldo    := 0 	
Local nSldLote  := 0
Local nIndSD5   := 0
Local nSD5Quant := 0  
Local nRec      := 0
Local nTotal    := 0

Local oTotal_EN1,oTotal_SA1, oTotal_SL1
Local oTotal_EN2,oTotal_SA2, oTotal_SL2

dbSelectArea('SB1')
dbSetOrder(1)

dbSelectArea("SB8")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatorio                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Filtro utilizado na condicao Where                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cWhere := "%"
	If mv_par13 == 1
		If mv_par12 == 2
			cWhere += "B8_SALDO2 > 0 AND "
		Else
			cWhere += ""
		EndIf
	Else
		If mv_par12 == 2
			cWhere += "B8_SALDO > 0 AND "
		Else
			cWhere += ""
		EndIf
	EndIf
	cWhere += "%"
	
 	MakeSqlExpr(oReport:uParam)
    
 	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasSB8
			
	SELECT SB8.* 
	
	FROM %table:SB8% SB8 
	
	JOIN %table:SB1% SB1 ON
		  SB1.D_E_L_E_T_ <> '*' AND
		  SB1.B1_COD = SB8.B8_PRODUTO AND
		  SB1.B1_GRUPO >= %Exp:mv_par15% AND
		  SB1.B1_GRUPO <= %Exp:mv_par16%
	
	WHERE B8_FILIAL    = %xFilial:SB8% AND 
		  B8_PRODUTO  >= %Exp:mv_par01% AND 
	      B8_PRODUTO  <= %Exp:mv_par02% AND      
	      B8_LOTECTL  >= %Exp:mv_par03% AND 
	      B8_LOTECTL  <= %Exp:mv_par04% AND          
	      B8_NUMLOTE  >= %Exp:mv_par05% AND 
	      B8_NUMLOTE  <= %Exp:mv_par06% AND      
	      B8_LOCAL    >= %Exp:mv_par07% AND 
	      B8_LOCAL    <= %Exp:mv_par08% AND      
		  %Exp:cWhere% 
	      SB8.%NotDel% 

	ORDER BY B8_PRODUTO,B8_LOTECTL,B8_LOCAL,B8_NUMLOTE
					
	EndSql 

    oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

    oSection2:SetParentQuery()

#ELSE

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao Advpl                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeAdvplExpr(oReport:uParam)

	cCondicao := 'B8_FILIAL=="'        + xFilial('SB8') + '".And.'
	cCondicao += 'B8_PRODUTO>="'       + mv_par01       + '".And.B8_PRODUTO<="'         + mv_par02       + '".And.'
	cCondicao += 'B8_LOTECTL>="'       + mv_par03       + '".And.B8_LOTECTL<="'         + mv_par04       + '".And.'
	cCondicao += 'B8_NUMLOTE>="'       + mv_par05       + '".And.B8_NUMLOTE<="'         + mv_par06       + '".And.'
	cCondicao += 'B8_LOCAL>="'         + mv_par07       + '".And.B8_LOCAL<="'           + mv_par08       + '"'

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para saldos na primeira e segunda unidade de medida          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par13 == 1
		If mv_par12 == 2
			cCondicao += " .And. B8_SALDO2 > 0 "
		EndIf
	Else
		If mv_par12 == 2
			cCondicao += " .And. B8_SALDO > 0 "
		EndIf
	EndIf


	oReport:Section(1):SetFilter(cCondicao,"B8_PRODUTO+B8_LOTECTL+B8_LOCAL+B8_NUMLOTE")

#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho para a tabela SD5.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD5")

cWorkSD5:= CriaTrab("",.F.)
cFilter := 'D5_FILIAL=="'+xFilial("SD5")+'".And.D5_PRODUTO>="'+mv_par01+'".And.D5_PRODUTO<="'+mv_par02+'".And.'
cFilter += 'D5_LOTECTL>="'+mv_par03+'".And.D5_LOTECTL<="'+mv_par04+'".And.'
cFilter += 'D5_NUMLOTE>="'+mv_par05+'".And.D5_NUMLOTE<="'+mv_par06+'".And.'
cFilter += 'D5_LOCAL>="'  +mv_par07+'".And.D5_LOCAL<="'  +mv_par08+'".And.'
cFilter += 'Dtos(D5_DATA)>="'+Dtos(mv_par09)+'".And.Dtos(D5_DATA)<="'+Dtos(mv_par10)+'"'

IndRegua("SD5",cWorkSD5,"D5_PRODUTO+D5_LOCAL+D5_LOTECTL+Dtos(D5_DATA)+D5_NUMLOTE+D5_NUMSEQ",,cFilter,STR0019) //"Selecionando Registros..."

nIndSD5 := RetIndex("SD5")
#IFNDEF TOP
	dbSetIndex(cWorkSD5 + OrdBagExt())
#ENDIF
dbSetOrder(nIndSD5+1)
dbGotop()

oTotal_EN1 :=TRFunction():New(oSection3:Cell("ENTRADA"  ),"CALCENT1"	,"SUM"		,/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T./*lEndReport*/,.F./*lEndPage*/,,oSection1)
oTotal_SA1 :=TRFunction():New(oSection3:Cell("SAIDA"    ),"CALCSAI1"	,"SUM"		,/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oSection1) 
oTotal_SL1 :=TRFunction():New(oSection3:Cell("SALDO"    ),NIL			,"ONPRINT"	,/*oBreak1*/,,/*cPicture*/,{|| ( (oSection1:GetFunction("CALCENT1"):GetLastValue() - oSection1:GetFunction("CALCSAI1"):GetLastValue())+ oSection2:Cell("TOTAL"):GetValue() ) },.T.,.F. ,,oSection1)

oTotal_EN2 :=TRFunction():New(oSection3:Cell("ENTRADA"  ),"CALCENT2"	,"SUM"		,/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oSection2)
oTotal_SA2 :=TRFunction():New(oSection3:Cell("SAIDA"    ),"CALCSAI2"	,"SUM"		,/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oSection2) 
oTotal_SL2 :=TRFunction():New(oSection3:Cell("SALDO"    ),NIL			,"ONPRINT"	,/*oBreak1*/,,/*cPicture*/,{|| ( (oSection2:GetFunction("CALCENT2"):GetLastValue() - oSection2:GetFunction("CALCSAI2"):GetLastValue())+ oSection2:Cell("SALDO"):GetValue() ) },.T.,.F. ,,oSection2) 

If mv_par14 == 2
	oSection1:Cell("B2_LOCALIZ"):Disable()
EndIf

oReport:SetMeter(SB8->(LastRec()))
dbSelectArea(cAliasSB8)

While !oReport:Cancel() .And. !(cAliasSB8)->(Eof())

	oReport:IncMeter()
	If oReport:Cancel()
		Exit
	EndIf

	oSection1:Init()

	cProduto := (cAliasSB8)->B8_PRODUTO
	cLote    := (cAliasSB8)->B8_LOTECTL
	cSubLote := (cAliasSB8)->B8_NUMLOTE
	cLocal   := (cAliasSB8)->B8_LOCAL
	
	nSldLote :=CalcEstL(cProduto,cLocal,mv_par10+1,(cAliasSB8)->B8_LOTECTL,If(Rastro(cProduto,"S"),(cAliasSB8)->B8_NUMLOTE,NIL))[If(mv_par13<>1,1,7)]
	
	lLoteZera:= If( mv_par12 == 1 , .T. , If( nSldLote == 0 , .F. , .T. ) )
    lProd    := AllTrim( cProdAnt) <> AllTrim( (cAliasSB8)->B8_PRODUTO )
	lLote 	 := .T.	
	lMovSD5  := .T.
	nRec     := 0
	
	dbSelectArea("SD5")
	If !dbSeek(cProduto + cLocal + cLote ,.T.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se Lista Lote/Sub Sem Movimentos   ³
		//³ 1 = Lista          2 = Nao Lista		    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lLote   := If( mv_par11 == 1 , .T. , .F. )
		lMovSD5 := If( mv_par12 == 1 .And. lLote , .T. , .F. )

	ElseIf Rastro(cProduto,"S")

		lOkSublote:=.F.

		While !Eof() .And. SD5->D5_PRODUTO+SD5->D5_LOCAL+SD5->D5_LOTECTL == cProduto+cLocal+cLote
			If  SD5->D5_NUMLOTE == cSubLote
				lOkSublote:=.T.	
				Exit
			EndIf	
			dbSelectArea("SD5")
			dbSkip()
		EndDo
		If !lOkSubLote
			lLote   := If(mv_par11 == 1, .T. , .F. )
			lMovSD5 := If(mv_par12 == 1 .And. lLote , .T. , .F. )
		EndIf
	EndIf	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera no filtro o Lote/Sub com o Saldo Zerado ³
	//³ 1 = Lista          2 = Nao Lista		          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par12 == 2 .And. nSldLote == 0 .And. !lMovSD5
		dbSelectArea(cAliasSB8)
		dbSkip()
	EndIf
	
	dbSelectArea("SD5")
	If (lSeek:=MsSeek(cProduto+cLocal+cLote, .F.)) .Or. lLote

		If lProd .And. lLote .And. lLoteZera
			
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+cProduto))

			If mv_par14 == 1
				SB2->(MsSeek(xFilial("SB2")+cProduto+cLocal)) 
			Endif

			oSection1:PrintLine()		

			lProd    := .F.
			cProdAnt := cProduto
		EndIf
		
		If lLote .And. lLoteZera

			oSection2:Init()

			If SB1->B1_RASTRO == "S"
				oSection2:Cell("B8_NUMLOTE"):Enable()
				oSection2:Cell("SP1"):SetSize(60-Len(STR0013)-Len(STR0014)-TamSX3("B8_NUMLOTE")[1]-TamSX3("B8_LOTECTL")[1],.F./*lPixel*/) //"Sub-Lote: "###"Lote: "
			ElseIf SB1->B1_RASTRO == "L"
	 			oSection2:Cell("B8_NUMLOTE"):Disable()
				oSection2:Cell("SP1"):SetSize(61-Len(STR0014)-TamSX3("B8_LOTECTL")[1],.F./*lPixel*/) //"Lote: "
			EndIf

			nSaldo:=CalcEstL(cProduto,cLocal,mv_par09,(cAliasSB8)->B8_LOTECTL,IF(Rastro(cProduto,"S"),(cAliasSB8)->B8_NUMLOTE,NIL))[If(mv_par13<>1,1,7)]
            nTotal+=nSaldo // armazena o total do produto
            
			oSection2:Cell("SALDO"):SetValue(nSaldo)
			oSection2:Cell("TOTAL"):SetValue(nTotal)
			nRec := 0
			
			oSection2:PrintLine()		

		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Zera os totais de cada Lote/SubLote   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nEntrada := nSaida := 0
		
		cCampo	:= "D5_PRODUTO+D5_LOTECTL"
		cCompara:=	D5_PRODUTO+D5_LOTECTL
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao dos Movimentos do Lote/Sub  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do While !Eof() .And. &(cCampo) == cCompara .And. lLoteZera

			oSection3:Init()

			If  SD5->D5_LOCAL <> cLocal .Or. (Rastro(cProduto,"S") .And.  SD5->D5_NUMLOTE <> cSubLote)
				dbSkip()
				Loop
			EndIf

			nSD5Quant := If(mv_par13 <> 1, SD5->D5_QUANT,SD5->D5_QTSEGUM)

			If SD5->D5_ORIGLAN <= "500" .Or. Substr( SD5->D5_ORIGLAN,1,2) $ "DE/PR" .Or. SD5->D5_ORIGLAN == "MAN"
				oSection3:Cell("ENTRADA"):SetValue(nSD5Quant)
				oSection3:Cell("SAIDA"  ):SetValue(0)
				nEntrada+=nSD5Quant
				nSaldo  +=nSD5Quant
			Elseif SD5->D5_ORIGLAN > "500" .Or. Substr(SD5->D5_ORIGLAN,1,2) == "RE"
				oSection3:Cell("SAIDA"  ):SetValue(nSD5Quant)
				oSection3:Cell("ENTRADA"):SetValue(0)
				nSaida  +=nSD5Quant
				nSaldo  -=nSD5Quant
			EndIf

			oSection3:Cell("SALDO"):SetValue(nSaldo)

			oSection3:PrintLine()
			
			nRec +=1
			dbSkip()
		EndDo
		
  		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Lote Sem Movimentos ou movimentos fora do critério de data informado, coloca o saldo Inicial p/célula Entrada |
	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nRec = 0         
			oSection3:Init()
			oSection3:Cell("ENTRADA"):SetValue(0)
			oSection3:Cell("SAIDA"):SetValue(0)
			oSection3:Hide()
			oSection3:PrintLine()  
			oSection3:Show()
		EndIf

		oSection3:Finish()

		If lLote .And. lLoteZera
			oTotal_EN1:HideHeader()
			oTotal_SA1:HideHeader()
			oTotal_SL1:HideHeader()

			oTotal_EN2:ShowHeader()
			oTotal_SA2:HideHeader()
			oTotal_SL2:HideHeader()

			oTotal_EN2:SetTitle(If(SB1->B1_RASTRO == "S" , STR0016 , STR0017 )) //"Total do Sub-Lote -> " # "Total do Lote -> "
			oSection2:Finish()
		Else
			lLote := .T.
		Endif
		
	EndIf
	
	dbSelectArea(cAliasSB8)
	If Rastro(cProduto,"L")
		Do While !Eof() .And. cProduto + cLocal == (cAliasSB8)->B8_PRODUTO + (cAliasSB8)->B8_LOCAL
			If cLote <> (cAliasSB8)->B8_LOTECTL
				Exit
			EndIf
			dbSkip()
		EndDo
	Else
		dbSkip()
	EndIf
	
	If ( cProduto <> (cAliasSB8)->B8_PRODUTO .And. If( !( mv_par12 == 1 ) ,nSaldo > 0 , .T. ) ) .And. lSeek
 		oTotal_EN2:HideHeader()
 		oTotal_SA2:HideHeader()
 		oTotal_SL2:HideHeader()
		
		oTotal_EN1:ShowHeader()
		oTotal_SA1:HideHeader()
		oTotal_SL1:HideHeader()

		oTotal_EN1:SetTitle(STR0018)

		oSection1:Finish()		

		lProd  := .T.
		nTotal := 0
	Else                                           
   		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    //³ Quebrou o Produto e não possui movimentos de Entrada / Saídas no critério de data informado   ³
	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cProduto <> (cAliasSB8)->B8_PRODUTO .And. nRec = 0 
	 		oTotal_EN2:HideHeader()
	 		oTotal_SA2:HideHeader()
	 		oTotal_SL2:HideHeader()
			
			oTotal_EN1:ShowHeader()
			oTotal_SA1:HideHeader()
			oTotal_SL1:HideHeader()
	
			oTotal_EN1:SetTitle(STR0018)

		    oSection1:Hide()
			oSection1:Finish()
	    	oSection1:Show()
	    	
			nTotal := 0
	  	EndIf
	EndIf
	
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve ordens originais da tabela e apaga indice de trabalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SD5")
dbSelectArea("SD5")
dbSetOrder(1)
dbClearFilter()

If File(cWorkSD5+OrdBagExt())
	Ferase(cWorkSD5+OrdBagExt())
EndIf

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MATR435R3³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 11.05.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Kardex p/ Lote Sobre o SD5                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Rodrigo Sar.³26/05/98³XXXXX ³Trocada pergunte p/ corrigir falha de     ³±±
±±³            ³        ³      ³atualizacao de versao.                    ³±±
±±³Rodrigo Sar.³08/09/98³17321A³Corrigido while para lotes iguais         ³±±
±±³FernandoJoly³20/10/98³18410A³Inclus„o da Data de Validade e Documento. ³±±
±±³FernandoJoly³10/11/98³XXXXXX³Ajuste para o Ano 2000.                   ³±±
±±³Fernando J. ³03/12/98³18813A³ImpressÆo correta do campo "Documento".   ³±±
±±³Cesar       ³25/03/99³20051A³Alteracao do Lay-Out p/ Sair #OP Completa ³±±
±±³Cesar       ³07/04/99³XXXXXX³Alteracao do Lay-Out p/ Tamanho M         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MATR435R3T()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cDesc1    := STR0001	//"Este programa emitir  um Kardex com todas as movimenta‡”es"
LOCAL cDesc2    := STR0002	//"do estoque por Lote/Sub-Lote, diariamente. Observa‡„o: o primeiro"
LOCAL cDesc3    := STR0003	//"movimento de cada Lote/Sub-Lote se refere a cria‡„o do mesmo."
LOCAL titulo	:= STR0004	//"Kardex por Lote/Sub-Lote (por produto)"
LOCAL wnrel     := "MATR435"
LOCAL Tamanho   := "G"
LOCAL cString   := "SB8"

PRIVATE aReturn := {STR0005,1,STR0006, 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   := "MR435A"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria a Pergunta Nova no Sx1                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                     	 ³
//³ mv_par01       	// Do  Produto                         	 	 ³
//³ mv_par02        // Ate Produto                         	 	 ³
//³ mv_par03        // De  Lote                            	 	 ³
//³ mv_par04        // Ate Lote			        			 	 ³
//³ mv_par05        // De  Sub-Lote                          	 ³
//³ mv_par06        // Ate Sub-Lote			        		 	 ³
//³ mv_par07        // De  Local		        			 	 ³
//³ mv_par08        // Ate Local							 	 ³
//³ mv_par09        // De  Data			        			 	 ³
//³ mv_par10        // Ate Data								 	 ³
//³ mv_par11       	// Lotes/Sub S/ Movimentos (Lista/Nao Lista) ³
//³ mv_par12       	// Lote/Sub Saldo Zerado   (Lista/Nao Lista) ³ 
//³ mv_par13       	// QTDE. na 2a. U.M. ?     (Sim/Nao)         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("MR435A",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel :=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,.f.,Tamanho)

If nLastKey = 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C435Imp(@lEnd,wnRel,tamanho,titulo)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C435IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 14.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR435			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C435Imp(lEnd,WnRel,tamanho,titulo)
LOCAL cCampo   := ""
LOCAL cCompara := ""
LOCAL cLote    := ""
LOCAL cSubLote := ""
LOCAL lOkSublote:=.F.
LOCAL cProduto := ""
LOCAL cIndexD5 := "D5_PRODUTO+D5_LOCAL+D5_LOTECTL+DTOS(D5_DATA)+D5_NUMLOTE+D5_NUMSEQ"
LOCAL cIndexB8 := "B8_PRODUTO+B8_LOTECTL+B8_LOCAL+B8_NUMLOTE"
LOCAL lProd    := .T.					// Flag do Subtitulo Produto
LOCAL lLote    := .T.					// Flag do Subtitulo Lote
LOCAL lTotal   := .F.					// Flag de Impressao do Total do relatorio
LOCAL nEntrada := nSaida :=nSaldo  :=0 	// Totalizadores de Valor por Lote
LOCAL nLentrada:= nLsaida:=nProduto:=0	// Totalizadores de Valor por Produto
LOCAL nIndD5   := 0
LOCAL nIndB8   := 0
LOCAL nTipo    := 0
LOCAL cProdAnt := ""
LOCAL lLoteZera:= .T.                   // Flag para Listar Lote Zerado
LOCAL nSD5Quant:= 0
LOCAL lSeek    := .F.
LOCAL	cCondD5:= 'D5_FILIAL=="'+xFilial("SD5")+'".And.D5_PRODUTO>="'+mv_par01+'".And.D5_PRODUTO<="'+mv_par02+'".And.'
LOCAL	cCondB8:= 'B8_FILIAL=="'+xFilial("SB8")+'".And.B8_PRODUTO>="'+mv_par01+'".And.B8_PRODUTO<="'+mv_par02+'".And.'

cCondD5 += 'D5_LOTECTL>="'+mv_par03+'".And.D5_LOTECTL<="'+mv_par04+'".And.'
cCondD5 += 'D5_NUMLOTE>="'+mv_par05+'".And.D5_NUMLOTE<="'+mv_par06+'".And.'
cCondD5 += 'D5_LOCAL>="'  +mv_par07+'".And.D5_LOCAL<="'  +mv_par08+'".And.'
cCondD5 += 'DTOS(D5_DATA)>="'+DTOS(mv_par09)+'".And.DTOS(D5_DATA)<="'+DTOS(mv_par10)+'"'

cCondB8 += 'B8_LOTECTL>="'+mv_par03+'".And.B8_LOTECTL<="'+mv_par04+'".And.'
cCondB8 += 'B8_NUMLOTE>="'+mv_par05+'".And.B8_NUMLOTE<="'+mv_par06+'".And.'
cCondB8 += 'B8_LOCAL>="'  +mv_par07+'".And.B8_LOCAL<="'  +mv_par08+'"'

If !Empty(aReturn[7])
	cCondB8 += '.And.' + aReturn[7]
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega o nome do arquivo de indice de trabalho      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArqD5 := CriaTrab("",.F.)
cNomArqB8 := CriaTrab("",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o indice de trabalho para o SD5              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD5")
IndRegua("SD5",cNomArqD5,cIndexD5,,cCondD5,STR0019) //"Selecionando Registros..."
nIndD5 := RetIndex('SD5')
#IFNDEF TOP
	dbSetIndex(cNomArqD5 + OrdBagExt())
#ENDIF
dbSetOrder(nIndD5 + 1)
dbGotop()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o indice de trabalho para o SB8              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB8")
IndRegua("SB8",cNomArqB8,cIndexB8,,cCondB8,STR0019) //"Selecionando Registros..."
nIndB8 := RetIndex('SB8')
#IFNDEF TOP
	dbSetIndex(cNomArqB8 + OrdBagExt())
#ENDIF
dbSetOrder(nIndB8 + 1)
dbGotop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cbtxt := SPACE(10)
PRIVATE cbcont:= 0
PRIVATE li    := 80
PRIVATE m_pag := 01

PRIVATE cabec1  := STR0007	// 'Local   Data Movim.   Valid. Lote    Documento       Origem Lcto.    Estornado           Entrada             Saida             Saldo'
PRIVATE cabec2  := ""
//--						    99       99/99/9999    99/99/9999    999999999999         XXX            X        999999999.9999    999999999.9999    999999999.9999   
//--                            0         1         2         3         4         5         6         7         8         9        10        11        12        13
//--                            0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
dbSelectArea("SB8")
SetRegua(LastRec())
Do While !Eof()
    lProd    := allTrim(cProdAnt)#allTrim(B8_PRODUTO)
	cProduto := B8_PRODUTO
	cLote    := B8_LOTECTL
	cSubLote := B8_NUMLOTE
	cLocal   := B8_LOCAL
	lLote 	 := .T.	
	lTotal   := .T.
	lMovSD5  := .T.
	
	IncRegua()
	
	If lEnd
		@PROW()+1,001 PSay STR0008 //"CANCELADO PELO OPERADOR"
		Exit
	EndIf
	
	If li > 56
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf
	
	nSldLote:=CalcEstL(cProduto,cLocal,mv_par10+1,B8_LOTECTL,IF(Rastro(cProduto,"S"),B8_NUMLOTE,NIL))[If(mv_par13<>1,1,7)]
	
	lLoteZera := IF(mv_par12 == 1,.T.,IF(nSldLote == 0,.F.,.T.))
	
	dbSelectArea("SD5")
	If !dbSeek(cProduto+cLocal+cLote,.T.)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se Lista Lote/Sub Sem Movimentos   ³
		//³ 1 = Lista          2 = Nao Lista		    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lLote  := If(mv_par11==1,.T.,.F.)
		lMovSD5:= If(mv_par12==1.And.lLote,.T.,.F.)
	ElseIf Rastro(cProduto,"S")
		lOkSublote:=.F.
		While !EOF() .And. D5_PRODUTO+D5_LOCAL+D5_LOTECTL == cProduto+cLocal+cLote
			If D5_NUMLOTE == cSubLote
				lOkSublote:=.T.	
				Exit
			EndIf	
			dbSkip()
		End
		If !lOkSubLote
			lLote  := If(mv_par11==1,.T.,.F.)
			lMovSD5:= If(mv_par12==1.And.lLote,.T.,.F.)
		EndIf                                                      
	EndIf	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera no filtro o Lote/Sub com o Saldo Zerado ³
	//³ 1 = Lista          2 = Nao Lista		          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par12 == 2 .And. nSldLote == 0 .And. !lMovSD5
		dbSelectArea("SB8")
		dbSkip()
	EndIf
	
	dbSelectArea("SD5")
	If (lSeek:=MsSeek(cProduto+cLocal+cLote, .F.)) .Or. lLote
		If lProd .And. lLote .And. lLoteZera
			
			If li > 56
				cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			EndIf
			
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+cProduto))
			@ li,00 PSay STR0009+cProduto					//"Produto: "
			@ li,25 PSay STR0010+Substr(SB1->B1_DESC,1,45)	//"Descr.: "
			@ li,62 PSay STR0011+SB1->B1_TIPO				//"Tipo: "
			@ li,71 PSay STR0012+If(mv_par13 <> 1 ,SB1->B1_UM,SB1->B1_SEGUM) //"Unidade: "
			If mv_par14 == 1
				If SB2->(MsSeek(xFilial("SB2")+cProduto+cLocal)) .And. !Empty(SB2->B2_LOCALIZ)
					@ li,104 PSay STR0020+SB2->B2_LOCALIZ //"Descr. Arm.: "
				Endif
			Endif
			Li += 2
			lProd  := .F.
			lTotal := .T.
			cProdAnt := cProduto
		EndIf
		
		If lLote .And. lLoteZera
			If li > 56
				cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			EndIf
			
			If SB1->B1_RASTRO == "S"
				@ li,01 PSay STR0013+SB8->B8_NUMLOTE+"    "+STR0014+SB8->B8_LOTECTL	//"Sub-Lote: "###"Lote: "
			ElseIf SB1->B1_RASTRO == "L"
				@ li,01 PSay STR0014+SB8->B8_LOTECTL		//"Lote: "
			EndIf
			nSaldo:=CalcEstL(cProduto,cLocal,mv_par09,SB8->B8_LOTECTL,IF(Rastro(cProduto,"S"),SB8->B8_NUMLOTE,NIL))[If(mv_par13<>1,1,7)]
			@ li,59 PSay STR0015							//"Saldo Inicial: "
			@ Li,93 pSay Transform(nSaldo,PesqPictQt('D5_QUANT',18))
			Li += 2
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Zera os totais de cada Lote/SubLote   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nEntrada := nSaida := 0
		
		cCampo	:= "D5_PRODUTO+D5_LOTECTL"
		cCompara:=	D5_PRODUTO+D5_LOTECTL
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao dos Movimentos do Lote/Sub  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do While !Eof() .And. &(cCampo) == cCompara .And. lLoteZera
			If D5_LOCAL # cLocal .Or. (Rastro(cProduto,"S") .And. D5_NUMLOTE # cSubLote)
				dbSkip()
				Loop
			EndIf                              
			if D5_ESTORNO == "S"
				dbSkip()
				loop
			endif
			If li > 56
				cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			EndIf
			@ Li, 00 pSay Left(SD5->D5_LOCAL, 02)
			@ Li, 09 pSay DtoC(SD5->D5_DATA)
			@ Li, 23 pSay DtoC(SD5->D5_DTVALID)
			@ Li, 37 pSay If(!Empty(SD5->D5_OP), SD5->D5_OP, SD5->D5_DOC)
			If cPaisLoc != "BRA"
				If AllTrim(SD5->D5_SERIE) == "X"
					@ Li, 62 pSay If(cPaisLoc=="CHI","GUI","REM")
				Else
					@ Li, 62 pSay "FAC"
				EndIf
			EndIf
			@ Li, 66 pSay Left(SD5->D5_ORIGLAN, 03)
			@ Li, 81 pSay SD5->D5_ESTORNO
			nSD5Quant := If(mv_par13 <> 1,D5_QUANT,D5_QTSEGUM)
			If D5_ORIGLAN <= "500" .Or. Substr(D5_ORIGLAN,1,2) $ "DE/PR" .Or. D5_ORIGLAN == "MAN"
				@ Li, 93 pSay Transform(nSD5Quant, PesqPictQt('D5_QUANT',18))
				nEntrada+=nSD5Quant
				nSaldo  +=nSD5Quant
			Elseif D5_ORIGLAN > "500" .Or. Substr(D5_ORIGLAN,1,2) == "RE"
				@ Li, 112 pSay Transform(nSD5Quant, PesqPictQt('D5_QUANT',18))
				nSaida  +=nSD5Quant
				nSaldo  -=nSD5Quant
			EndIf
			@ Li, 129 pSay Transform(nSaldo, PesqPictQt('D5_QUANT',18))
			Li++
			dbSkip()
			
			IF li > 59
				cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			EndIF
			
		EndDo
	
		If lLote .And. lLoteZera
			If nEntrada > 0 .And. nSaida > 0 .Or. nSaldo > 0
				If li > 56
					cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				EndIf
				@ li,00 PSAY cLocal
				If SB1->B1_RASTRO == "S"
					@ li,03 PSay STR0016	//"Total do Sub-Lote -> "
				ElseIf SB1->B1_RASTRO == "L"
					@ li,03 PSay STR0017	//"Total do Lote -> "
				EndIf
				If nEntrada > 0
					@ Li, 93 pSay Transform(nEntrada, PesqPictQt('D5_QUANT',18))
				EndIf
				If nSaida > 0
					@ Li, 112 pSay Transform(nSaida, PesqPictQt('D5_QUANT',18))
				EndIf
				@ Li, 129 pSay Transform(nSaldo, PesqPictQt('D5_QUANT',18))
			EndIf
			nLentrada += nEntrada
			nLsaida   += nSaida
			nProduto  += nSaldo
			Li += 2
		Else
			lLote := .T.
		Endif
	EndIf
	
	dbSelectArea("SB8")
	If Rastro(cProduto,"L")
		Do While !Eof() .And. cProduto+cLocal == B8_PRODUTO+B8_LOCAL
			If cLote # B8_LOTECTL
				Exit
			EndIf
			dbSkip()
		EndDo
	Else
		dbSkip()
	EndIf
	
	If cProduto # B8_PRODUTO .And. if(!(mv_par12==1),nProduto > 0,.T.)
		If li > 56
			cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf
		If !(nLentrada <= 0 .And. nLsaida <= 0)
			@ li,00 PSay __PrtThinLine()
			Li++
			@ li,00 PSay STR0018	//"Total do Produto -> "
			If nLentrada > 0
				@ Li, 93 pSay Transform(nLentrada, PesqPictQt('D5_QUANT',18))
			EndIf
			If nLsaida > 0
				@ Li, 112 PSay Transform(nLsaida, PesqPictQt('D5_QUANT',18))
			EndIf
			@ Li, 129 pSay Transform(nProduto, PesqPictQt('D5_QUANT',18))
			Li++
			@ li,00 PSay __PrtThinLine()
			Li++
        ElseIf lLote .And. !lSeek
	        Li++
	        @ li,00 PSay __PrtThinLine()
	        Li++
		EndIf	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Zera os Totais do Produto   	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nLentrada := nLsaida := nProduto :=0
		lProd  := .T.
		lTotal := .F.
	EndIf
	
EndDo

If lTotal .And. if(!(mv_par12==1),nProduto > 0,.T.)
	If li > 56
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf
	@ li,00 PSay __PrtThinLine()
	Li++
	@ li,00 PSay STR0018	//"Total do Produto -> "
	If nLentrada > 0
		@ Li, 93 pSay Transform(nLentrada, PesqPictQt('D5_QUANT',18))
	EndIf
	If nLsaida > 0
		@ Li, 112 PSay Transform(nLsaida, PesqPictQt('D5_QUANT',18))
	EndIf
	@ Li, 129 pSay Transform(nProduto, PesqPictQt('D5_QUANT',18))
	Li++
	@ li,00 PSay __PrtThinLine()
	Li++
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Zera os Totais do Produto   	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLentrada := nLsaida := nProduto :=0
	IF li != 80
		roda(cbcont,cbtxt,Tamanho)
	EndIF
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve as ordens originais do arquivo                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SD5")
dbClearFilter()
RetIndex("SB8")
dbClearFilter()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga indice de trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArqD5 += OrdBagExt()
cNomArqB8 += OrdBagExt()
Delete File &(cNomArqD5)
Delete File &(cNomArqB8)

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1 ³ Autor ³ Marcos V. Ferreira    ³ Data ³30.03.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria as perguntas necesarias para o programa                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()

Local aHelpPor :={} 
Local aHelpEng :={} 
Local aHelpSpa :={} 

/*-----------------------MV_PAR13--------------------------*/
PutSx1("MR435A","13","QTDE. na 2a. U.M. ?","CTD. EN 2a. U.M. ?","QTTY. in 2a. U.M. ?", "mv_chd", "N", 0, 0, 2,"C", "", "", "", "","MV_PAR13","Sim","Si","Yes", "","Nao","No","No", "", "", "", "", "", "", "", "", "", "", "", "", "")

/*-----------------------MV_PAR14--------------------------*/
Aadd( aHelpPor, "Imprime descricao do Armazem. Sim ou Nao" )

Aadd( aHelpEng, "Print warehouse description. Yes or No  " )

Aadd( aHelpSpa, "Imprime descripcion del almacen. Si o No" ) 

PutSx1( "MR435A","14","Imprime descricao do Armazem ?","Imprime descripc. del almacen?","Print warehouse description ?","mv_che",;
"N",1,0,2,"C","","","","","mv_par14","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

/*-----------------------MV_PAR15/16--------------------------*/
PutSx1("MR435A","15","Grupo de	 ?"," "," ", "mv_chd","G",4,0,0, "C","","SBM","","","MV_PAR15"," "," "," ", ""," "," "," ", "", "", "", "", "", "", "", "", "",{"Informe o grupo do produto Final"},{"Informe o grupo do produto Final"}, {"Informe o grupo do produto Final"})
PutSx1("MR435A","16","Grupo Até	 ?"," "," ", "mv_chd","G",4,0,0, "C","","SBM","","","MV_PAR16"," "," "," ", ""," "," "," ", "", "", "", "", "", "", "", "", "",{"Informe o grupo do produto Final"},{"Informe o grupo do produto Final"}, {"Informe o grupo do produto Final"})

Return
