#Include "PROTHEUS.Ch"
#Include "TOPCONN.Ch"

#define STR0001  "Este programa ira imprimir o Balancete Comparativo "
#define STR0002  "de acordo com os parametros solicitados pelo usuario. "
#define STR0003  "Comparativo de "
#define STR0004  "|CODIGO            |DESCRICAO          |  PERIODO 01  |  PERIODO 02  |  PERIODO 03  |  PERIODO 04  |  PERIODO 05  |  PERIODO 06  |  PERIODO 07  |  PERIODO 08  |  PERIODO 09  |  PERIODO 10  |  PERIODO 11  |  PERIODO 12  |"
#define STR0005  "COMPARATIVO ANALITICO DE "
#define STR0006  "COMPARATIVO SINTETICO DE "
#define STR0007  "COMPARATIVO DE "
#define STR0008  " DE "
#define STR0009  " ATE "
#define STR0010  " EM "
#define STR0011  " CONTA "
#define STR0012  "O plano gerencial ainda näo esta disponivel para este relatorio. "
#define STR0013  "Criando Arquivo Temporario... "
#define STR0014  "Zebrado"
#define STR0015  "Administracäo"
#define STR0016  "***** CANCELADO PELO OPERADOR *****"
#define STR0017  "T O T A I S  D O  P E R I O D O: "
#define STR0018  "TOTAIS DO "
#define STR0019  "O periodo solicitado ultrapassa o limite de 6 meses."
#define STR0020  "Sera impresso somente os 6 meses a partir da data inicial."
#define STR0021  "Caso nao atualize os saldos compostos na"
#define STR0022  "emissao dos relatorios(MV_SLDCOMP ='N'),"
#define STR0023  "rodar a rotina de atualizacao de saldos "
#define STR0024  "Altere a configuracäo de livros..."
#define STR0025  "Config. de Livros..."
#define STR0026  "TOTAIS: "
#define STR0027  "TOTAIS DO PERIODO:"
#define STR0028  "TOTAL PERIODO"
#define STR0029  "ACUMULADO"
#define STR0030  "GRUPO ("
#define STR0031  "PERIODO "
#define STR0032  "Total - "
#define STR0033  "Total Geral - "
#define STR0034  " Superior"
#define STR0035  "Grupo"

//Tradução PTG 20080721

//--------------------------RELEASE 04------------------------------------------------//
User Function Cbr285r2()
//-------------------------------------------------------------------------------------
CtAjustSx1("CTR285A")

If FindFunction("TRepInUse") .And. TRepInUse()
	Cbr285R42()
Else
	//Return CTBR285R3() // Executa versão anterior do fonte
Endif

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ctbr285r2 ºAutor  ³Claudio Servulo     º Data ³  31/05/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Release 4                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//-----------------------------
Static Function Cbr285R42()
//-----------------------------
Private aArea := GetArea()
Private lAtSlComp		:= Iif(GETMV("MV_SLDCOMP") == "S",.T.,.F.)
Private cMensagem		:= ""
Private cSayCC			:= CtbSayApro("CTT")
Private cString			:= "CTT"
Private cTitulo 		:= STR0003+Upper(Alltrim(cSayCC))+" / "+ STR0011 	//"Comparativo de" " Conta "
Private oDlgSem
Private aTpSemestre		:= {"1o.Semestre","2o.Semestre"}
Private cJust			:= " "
Private cCusto 			:= ""
If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mostra tela de aviso - Atualizacao de saldos				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMensagem := STR0021+chr(13)  		//"Caso nao atualize os saldos compostos na"
cMensagem += STR0022+chr(13)  		//"emissao dos relatorios(MV_SLDCOMP ='N'),"
cMensagem += STR0023+chr(13)  		//"rodar a rotina de atualizacao de saldos "

IF !lAtSlComp
	IF !MsgYesNo(cMensagem,STR0009)	//"ATEN€ŽO"
		Return
	Endif
EndIf

Pergunte("CTR285A",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					       ³
//³ mv_par01				// Data Inicial              	       ³
//³ mv_par02				// Data Final                          ³
//³ mv_par03				// C.C. Inicial         		       ³
//³ mv_par04				// C.C. Final   					   ³
//³ mv_par05				// Conta Inicial                       ³
//³ mv_par06				// Conta Final   					   ³
//³ mv_par07				// Imprime Contas:Sintet/Analit/Ambas  ³
//³ mv_par08				// Set Of Books				    	   ³
//³ mv_par09				// Saldos Zerados?			     	   ³
//³ mv_par10				// Moeda?          			     	   ³
//³ mv_par11				// Pagina Inicial  		     		   ³
//³ mv_par12				// Saldos? Reais / Orcados/Gerenciais  ³
//³ mv_par13				// Imprimir ate o Segmento?			   ³
//³ mv_par14				// Filtra Segmento?					   ³
//³ mv_par15				// Conteudo Inicial Segmento?		   ³
//³ mv_par16				// Conteudo Final Segmento?		       ³
//³ mv_par17				// Conteudo Contido em?				   ³
//³ mv_par18				// Pula Pagina                         ³
//³ mv_par19				// Imprime Cod. C.Custo? Normal/Red.   ³
//³ mv_par20				// Imprime Cod. Conta? Normal/Reduzido ³
//³ mv_par21				// Salta linha sintetica?              ³
//³ mv_par22 				// Imprime Valor 0.00?                 ³
//³ mv_par23 				// Divide por?                         ³
//³ mv_par24				// Posicao Ant. L/P? Sim / Nao         ³
//³ mv_par25				// Data Lucros/Perdas?                 ³
//³ mv_par26				// Totaliza periodo ?                  ³
//³ mv_par27				// Se Totalizar ?                  	   ³
//³ mv_par28				// Imprime C.C?Sintet/Analit/Ambas 	   ³
//³ mv_par29				// Imprime Totalizacao de C.C. Sintet. ³
//³ mv_par30				// Tipo de Comparativo?(Movimento/Acumulado)  ³
//³ mv_par31				// Quebra por Grupo Contabil?		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Tela para definir o semestre a ser impresso no relatorio
DEFINE MSDIALOG oDlgSem  TITLE "Selecione o Semestre desejado ( 1o. ou 2o. )" FROM 0,0 TO 125,450 OF oDlgSem PIXEL

@ 29, 10 SAY "Semestre: " of oDlgSem PIXEL
@ 37, 10 COMBOBOX oJust VAR cJust ITEMS aTpSemestre SIZE 80,10 PIXEL OF oDlgSem

DEFINE SBUTTON FROM 50,160 TYPE 1  OF oDlgSem ACTION semest() ENABLE
DEFINE SBUTTON FROM 50,190 TYPE 2  OF oDlgSem ACTION oDlgSem:END() ENABLE
ACTIVATE MSDIALOG oDlgSem CENTER

//-----------------------------------------
Static Function Semest()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := RDef(cSayCC, cString, cTitulo)

If !Empty(oReport:uParam)
	Pergunte(oReport:uParam,.F.)
EndIf

oReport:PrintDialog()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Cbr285R42 ºAutor  ³Paulo Carnelossi    º Data ³  16/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Release 4                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//---------------------------------------------------
Static Function RDef(cSayCC, cString, cTitulo)
//---------------------------------------------------
Local nX

Private cPerg	 	:= "CTR285A"
Private cDesc1 		:= STR0001			//"Este programa ira imprimir o Balancete Comparativo "
Private cDesc2 		:= Upper(Alltrim(cSayCC)) +" / "+ STR0011	// " Conta "
Private cDesc3 		:= STR0002  //"de acordo com os parametros solicitados pelo Usuario"

Private oReport

Private nX := 1
Private aOrdem := {}

Private aMes285r :={'JANEIRO  ','FEVEREIRO','MARCO    ', 'ABRIL    ','MAIO     ', 'JUNHO    ','JULHO    ', 'AGOSTO   ','SETEMBRO ','OUTUBRO  ','NOVEMBRO ','DEZEMBRO '}

Private  ano285r  := str(year(ddatabase),4)

Private oCentroCusto

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


oReport := TReport():New("CTBR285R",cTitulo, cPerg, ;
{|oReport| If(!ct040Valid(mv_par08), oReport:CancelPrint(), RPrint(oReport,cSayCC, cString, cTitulo))},;
cDesc1+CRLF+cDesc2+CRLF+cDesc3 )

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
//adiciona ordens do relatorio

oCentroCusto := TRSection():New(oReport, cSayCC, {"CTT", "CT1"}, aOrdem /*{}*/, .F., .F.)

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
//³                                                                        ³                                                        d
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TRCell():New(oCentroCusto,	"CTT_CUSTO"	,"CTT",/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oCentroCusto,	"CTT_DESC01","CTT",/*Titulo*/,/*Picture*/,30/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)

if cjust  = "1o.Semestre" // primeiro semestre
	nX := 1
	For nX := 1 To 6
		TRCell():New(oCentroCusto,"VALOR_PER"+StrZero(nX,2),"",aMes285r[nX]/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
	Next
elseif cjust  = "2o.Semestre"// segundo semestre
	nX := 7
	For nX := 7 To 12
		TRCell():New(oCentroCusto,	"VALOR_PER"+StrZero(nX,2),"",aMes285r[nX]/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
	Next
endif



//if aTpSemestre = 1 // primeiro semestre
//	For nX := 1 To 6
//	 	TRCell():New(oCentroCusto,"VALOR_PER"+StrZero(nX,2),"",STR0031+StrZero(nX,2)/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
//	Next
//else  // segundo semestre
//	nX := 6
//	For nX := 7 To 12
//		TRCell():New(oCentroCusto,	"VALOR_PER"+StrZero(nX,2),"",STR0031+StrZero(nX,2)/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
//	Next
//endif

TRCell():New(oCentroCusto,	"VALOR_TOTAL","","TOTAL ANO "+ano285r /*STR0028*//*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
oCentroCusto:Cell("VALOR_TOTAL"):Disable()
oCentroCusto:Cell("CTT_CUSTO"):SetLineBreak()
oCentroCusto:Cell("CTT_DESC01"):SetLineBreak()
oCentroCusto:Cell("CTT_DESC01"):disable()
oCentroCusto:SetColSpace(0)
oCentroCusto:SetHeaderPage()
oCentroCusto:SetLineBreak()

TRPosition():New(oCentroCusto,'CT1',1,{ || xFilial('CT1')+cArqTmp->CONTA } )

//-----------total do centro custo
oTotCenCusto := TRSection():New(oReport, STR0032+AllTrim(cSayCC), {"CTT", "CT1"}, aOrdem /*{}*/, .F., .F.)	//	"Total - "

TRCell():New(oTotCenCusto,	"CTT_CUSTO"	,"CTT",/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTotCenCusto,	"CTT_DESC01","CTT",/*Titulo*/,/*Picture*/,30/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)

if cjust  = "1o.Semestre" // primeiro semestre
	nX := 1
	For nX := 1 To 6
		TRCell():New(oTotCenCusto,	"VALOR_PER"+StrZero(nX,2),"", /*STR0031+StrZero(nX,2)*//*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)	//	"PERIODO "
	Next
elseif cjust  = "2o.Semestre"
	nX := 7
	For nX := 7 To 12
		TRCell():New(oTotCenCusto,	"VALOR_PER"+StrZero(nX,2),"",STR0031+StrZero(nX,2)/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)	//	"PERIODO "
	Next
endif


TRCell():New(oTotCenCusto,	"VALOR_TOTAL","",STR0028/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)	//	"TOTAL PERIODO"
oTotCenCusto:Cell("CTT_CUSTO"):SetLineBreak()
oTotCenCusto:Cell("CTT_DESC01"):SetLineBreak()
oTotCenCusto:Cell("CTT_CUSTO"):Hide()
oTotCenCusto:Cell("CTT_DESC01"):Hide()
oTotCenCusto:Cell("VALOR_TOTAL"):Disable()
oTotCenCusto:SetColSpace(0)
//oTotCenCusto:SetLineBreak()

oTotCenCusto:SetNoFilter({"CTT","CT1"})

//-----------total do centro custo superior
oTotSupCusto := TRSection():New(oReport, STR0032+AllTrim(cSayCC)+STR0034, {"CTT", "CT1"}, aOrdem /*{}*/, .F., .F.)	//	"Total - " + cSayCC + " Superior"

TRCell():New(oTotSupCusto,	"CTT_CUSTO"	,"CTT",/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTotSupCusto,	"CTT_DESC01","CTT",/*Titulo*/,/*Picture*/,30/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)


if cjust  = "1o.Semestre" // primeiro semestre
	nX := 1
	For nX := 1 To 6
		TRCell():New(oTotSupCusto,	"VALOR_PER"+StrZero(nX,2),"",/*STR0031+StrZero(nX,2)*//*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)	//	"PERIODO "
	Next
elseif cjust  = "2o.Semestre"
	nX := 7
	For nX := 7 To 12
		TRCell():New(oTotSupCusto,	"VALOR_PER"+StrZero(nX,2),"",STR0031+StrZero(nX,2)/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)	//	"PERIODO "
	Next
endif



TRCell():New(oTotSupCusto,	"VALOR_TOTAL","",STR0028/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)	//	"TOTAL PERIODO"
oTotSupCusto:Cell("CTT_CUSTO"):SetLineBreak()
oTotSupCusto:Cell("CTT_DESC01"):SetLineBreak()
oTotSupCusto:Cell("CTT_CUSTO"):Hide()
oTotSupCusto:Cell("CTT_DESC01"):Hide()
oTotSupCusto:Cell("VALOR_TOTAL"):Disable()
oTotSupCusto:SetColSpace(0)
//oTotSupCusto:SetLineBreak()

oTotSupCusto:SetNoFilter({"CTT","CT1"})

//---total geral
oTotGerCusto := TRSection():New(oReport, STR0033+AllTrim(cSayCC), {"CTT", "CT1"}, aOrdem /*{}*/, .F., .F.)	//	"Total Geral - "+cSayCC

TRCell():New(oTotGerCusto,	"CTT_CUSTO"	,"CTT",/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTotGerCusto,	"CTT_DESC01","CTT",/*Titulo*/,/*Picture*/,30/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)

if cjust  = "1o.Semestre" // primeiro semestre
	
	nX := 1
	For nX := 1 To 6
		TRCell():New(oTotGerCusto,	"VALOR_PER"+StrZero(nX,2),"",/*STR0031+StrZero(nX,2)*//*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)	//	"PERIODO"
	Next
elseif cjust  = "2o.Semestre"
	nX := 7
	For nX := 7 To 12
		TRCell():New(oTotGerCusto,	"VALOR_PER"+StrZero(nX,2),"",STR0031+StrZero(nX,2)/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)	//	"PERIODO"
	Next
endif


TRCell():New(oTotGerCusto,	"VALOR_TOTAL","",STR0028/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)	//	"TOTAL PERIODO"
oTotGerCusto:Cell("CTT_CUSTO"):SetLineBreak()
oTotGerCusto:Cell("CTT_DESC01"):SetLineBreak()
oTotGerCusto:Cell("CTT_CUSTO"):Hide()
oTotGerCusto:Cell("CTT_DESC01"):Hide()
oTotGerCusto:Cell("VALOR_TOTAL"):Disable()
oTotGerCusto:SetColSpace(0)
//oTotGerCusto:SetLineBreak()

oTotGerCusto:SetNoFilter({"CTT","CT1"})

//-----------total do grupo
oTotGrupo := TRSection():New(oReport, STR0032+STR0035, {"CTT", "CT1"}, aOrdem /*{}*/, .F., .F.)

TRCell():New(oTotGrupo,	"CTT_CUSTO"	,"CTT",/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oTotGrupo,	"CTT_DESC01","CTT",/*Titulo*/,/*Picture*/,30/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)

if cjust  = "1o.Semestre" // primeiro semestre
	nX := 1
	For nX := 1 To 6
		TRCell():New(oTotGrupo,	"VALOR_PER"+StrZero(nX,2),"",/*STR0031+StrZero(nX,2)*//*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)	//	"PERIODO "
	Next
elseif cjust  = "2o.Semestre"
	nX := 7
	For nX := 7 To 12
		TRCell():New(oTotGrupo,	"VALOR_PER"+StrZero(nX,2),"",STR0031+StrZero(nX,2)/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)	//	"PERIODO "
	Next
endif

TRCell():New(oTotGrupo,	"VALOR_TOTAL","",STR0028/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
oTotGrupo:Cell("CTT_CUSTO"):SetLineBreak()
oTotGrupo:Cell("CTT_DESC01"):SetLineBreak()
oTotGrupo:Cell("CTT_CUSTO"):Hide()
oTotGrupo:Cell("CTT_DESC01"):Hide()
oTotGrupo:Cell("VALOR_TOTAL"):Disable()
oTotGrupo:SetColSpace(0)
//oTotGrupo:SetLineBreak()

oTotGrupo:SetNoFilter({"CTT","CT1"})

Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Cbr285R4 ºAutor  ³Paulo Carnelossi    º Data ³  16/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Release 4                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RPrint(oReport,cSayCC, cString, cTitulo)

Local oSection1 	:= oReport:Section(1)

Local aSetOfBook
Local aCtbMoeda	:= {}
Local lRet			:= .T.
Local nDivide		:= 1
Local cPicture
Local cDescMoeda
Local cCodMasc		:= ""
Local cMascara		:= ""
Local cMascCC		:= ""
Local cSepara1		:= ""
Local cSepara2		:= ""
Local cGrupo		:= ""
Local cGrupoAnt	:= ""
Local lFirstPage	:= .T.
Local nDecimais
Local cCustoAnt		:= ""
Local cCCResAnt		:= ""
Local lImpConta		:= .F.
Local lImpCusto		:= .T.
Local nTamConta		:= Len(CriaVar("CT1_CONTA"))
Local cCtaIni		:= mv_par05
Local cCtaFim		:= mv_par06
Local nPosAte		:= 0
Local nDigitAte		:= 0
Local cSegAte   	:= mv_par13
Local cArqTmp   	:= ""
Local cCCSup		:= ""//Centro de Custo Superior do centro de custo atual
Local cAntCCSup		:= ""//Centro de Custo Superior do centro de custo anterior
Local lPula			:= Iif(mv_par21==1,.T.,.F.)
Local lPrintZero	:= Iif(mv_par22==1,.T.,.F.)
Local lImpAntLP		:= Iif(mv_par24 == 1,.T.,.F.)
Local lVlrZerado	:= Iif(mv_par09==1,.T.,.F.)
Local dDataLP  		:= mv_par25
Local aMeses		:= {}
Local dDataFim 		:= mv_par02
Local lJaPulou		:= .F.
Local nMeses		:= 1
Local aTotCol		:= {0,0,0,0,0,0,0,0,0,0,0,0}
Local aTotCC		:= {0,0,0,0,0,0,0,0,0,0,0,0}
Local aTotCCSup		:= {}
Local aSupCC		:= {}
Local nTotLinha		:= 0
Local nCont			:= 0
Local aTotGrupo		:= {0,0,0,0,0,0,0,0,0,0,0,0}
Local nTotLinGrp	:= 0

Local lImpSint 		:= Iif(mv_par07 == 2,.F.,.T.)
Local lImpTotS		:= Iif(mv_par29 == 1,.T.,.F.)
Local lImpCCSint	:= .T.
Local lNivel1		:= .F.

Local nPos 			:= 0
Local nDigitos 		:= 0
Local n				:= 0
Local nVezes		:= 0
Local nPosCC		:= 0
Local nTamaTotCC	:= 0
Local nAtuTotCC		:= 0
Local cTpComp		:= If( mv_par30 == 1,"M","S" )	//	Comparativo : "M"ovimento ou "S"aldo Acumulado

//Local cTpSemestre2	:= 1
Local cTpSemestre2	:= If( cjust  = "1o.Semestre" ,1,2 )	//	Semestre  o : "1"o. Semestre ou "2"o.Semestre

Local oCentroCusto  := oReport:Section(1)
Local oTotCenCusto  := oReport:Section(2)
Local oTotSupCusto  := oReport:Section(3)
Local oTotGerCusto  := oReport:Section(4)
Local oTotGrupo	 	:= oReport:Section(5)
Local cText_CC
Local cText_CCSup
Local cText_CCGer
Local cText_Grupo
Local Titulo
Local nRegTmp       := 1
Local YY,YN,nPP

Private cFil285r    := "(Filial: "+ alltrim(SM0->M0_FILIAL) +")"
Private nFlag285r   := 1
Private aRecTmp   	:= {}
Private nMesProc 	:= 0
Private nKK			:= 0
PRIVATE nomeProg  	:= "MAC285R"
Private cVar 		:= ""
oReport:SetLandscape()

aSetOfBook := CTBSetOf(mv_par08)

If mv_par23 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par23 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par23 == 4		// Divide por milhao
	nDivide := 1000000
EndIf

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par10,nDivide)
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
		oReport:CancelPrint()
		Return
	Endif
Endif

cDescMoeda 	:= aCtbMoeda[2]
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par10)
cPicture		:= aSetOfBook[4]

aPeriodos := ctbPeriodos(mv_par10, mv_par01, mv_par02, .T., .F.)

For nCont := 1 to len(aPeriodos)
	//Se a Data do periodo eh maior ou igual a data inicial solicitada no relatorio.
	If aPeriodos[nCont][1] >= mv_par01 .And. aPeriodos[nCont][2] <= mv_par02
		If nMeses <= 12
			AADD(aMeses,{StrZero(nMeses,2),aPeriodos[nCont][1],aPeriodos[nCont][2]})
		EndIf
		nMeses += 1
	EndIf
Next

//Mascara do Centro de Custo
If Empty(aSetOfBook[6])
	cMascCC :=  GetMv("MV_MASCCUS")
Else
	cMascCC := RetMasCtb(aSetOfBook[6],@cSepara1)
EndIf

// Mascara da Conta Contabil
If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
Else
	cMascara := RetMasCtb(aSetOfBook[2],@cSepara2)
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par07 == 1
	Titulo:=	STR0006+ Upper(Alltrim(cSayCC)) + " / "+ STR0011 		//"COMPARATIVO SINTETICO DE  "
ElseIf mv_par07 == 2
	Titulo:=	STR0005 + Upper(Alltrim(cSayCC)) + " / "+ STR0011		//"COMPARATIVO ANALITICO DE  "
ElseIf mv_par07 == 3
	Titulo:=	STR0007 + Upper(Alltrim(cSayCC)) + " / "+ STR0011		//"COMPARATIVO DE  "
EndIf

Titulo += 	STR0008 + DTOC(mv_par01) + STR0009 + Dtoc(mv_par02) + 	STR0010 + cDescMoeda

If mv_par12 > "1"
	Titulo += " (" + Tabela("SL", mv_par12, .F.) + ")"
Endif

If mv_par30 = 2
	mv_par26 := 2
	Titulo := AllTrim(Titulo) + "  " + STR0029
EndIf
oReport:SetTitle(Titulo)
oReport:SetCustomText( {|| CtCGCCabTR(,,,,,dDataFim,titulo,,,,,oReport) } )

If mv_par26 = 1		// Com total, nao imprime descricao
	oCentroCusto:Cell("VALOR_TOTAL"):Enable()
	oTotCenCusto:Cell("VALOR_TOTAL"):Disable()//DisableEnable()
	oTotSupCusto:Cell("VALOR_TOTAL"):Disable()//Enable()
	oTotGerCusto:Cell("VALOR_TOTAL"):Disable()//DisableEnable()
	oTotGrupo:Cell("VALOR_TOTAL"):Disable()//DisableEnable()
	
	oCentroCusto:Cell("CTT_DESC01"):Enable()
	oTotCenCusto:Cell("CTT_DESC01"):Enable()//Disable()
	oTotSupCusto:Cell("CTT_DESC01"):Enable()//Disable()
	oTotGerCusto:Cell("CTT_DESC01"):Enable()//Disable()
	oTotGrupo:Cell("CTT_DESC01"):Enable()//Disable()
Else
	oCentroCusto:Cell("VALOR_TOTAL"):Enable()
	oTotCenCusto:Cell("VALOR_TOTAL"):Disable()// Enable()//Disable()
	oTotSupCusto:Cell("VALOR_TOTAL"):Disable()
	oTotGerCusto:Cell("VALOR_TOTAL"):Disable()
	oTotGrupo:Cell("VALOR_TOTAL"):Disable()
	
	oCentroCusto:Cell("CTT_DESC01"):Enable()//Enable()
	oTotCenCusto:Cell("CTT_DESC01"):Enable()
	oTotSupCusto:Cell("CTT_DESC01"):Enable()
	oTotGerCusto:Cell("CTT_DESC01"):Enable()
	oTotGrupo:Cell("CTT_DESC01"):Enable()
Endif

//For nCont := 1 to Len(aMeses)
//	cabec2 := SPACE(1)+Strzero(Day(aMeses[nCont][2]),2)+"/"+Strzero(Month(aMeses[nCont][2]),2)+ " - "
//	cabec2 += Strzero(Day(aMeses[nCont][3]),2)+"/"+Strzero(Month(aMeses[nCont][3]),2)
//	oCentroCusto:Cell("VALOR_PER"+StrZero(nCont,2)):SetTitle(STR0031+StrZero(nCont,2)+CRLF+cabec2)
//Next


oReport:SetPageNumber(mv_par11)

// Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)
	For n := 1 to Val(cSegAte)
		nDigitAte += Val(Subs(cMascara,n,1))
	Next
EndIf

If !Empty(mv_par14)			//// FILTRA O SEGMENTO Nº
	If Empty(mv_par08)		//// VALIDA SE O CÓDIGO DE CONFIGURAÇÃO DE LIVROS ESTÁ CONFIGURADO
		help("",1,"CTN_CODIGO")
		oReport:CancelPrint()
		Return
	Else
		If !Empty(aSetOfBook[5])
			MsgInfo(STR0012+CHR(10)+STR0024,STR0025)
			oReport:CancelPrint()
			Return
		Endif
	Endif
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+aSetOfBook[2])
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == aSetOfBook[2]
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == STRZERO(val(mv_par14),2)
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)
				Exit
			EndIf
			dbSkip()
		EndDo
	Else
		help("",1,"CTM_CODIGO")
		oReport:CancelPrint()
		Return
	EndIf
EndIf

#IFNDEF TOP
	DbSelectArea("CTT")
	cFilter := oCentroCusto:GetAdvplExp('CTT')
	CTT->( dbSetFilter( { || &cFiltro }, cFiltro ) )
#ELSE
	cFilter := oCentroCusto:GetSQLExp('CTT')
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
CTGerComp(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
mv_par01,mv_par02,"CT3","",mv_par05,mv_par06,mv_par03,mv_par04,,,,,mv_par10,;
mv_par12,aSetOfBook,mv_par14,mv_par15,mv_par16,mv_par17,;
.F.,.F.,,"CTT",lImpAntLP,dDataLP,nDivide,cTpComp,.F.,,.T.,aMeses,lVlrZerado,,,lImpSint,cString,cFilter/*oCentroCusto:GetAdvplExp()/*aReturn[7]*/,lImpTotS)},;
STR0013,;  //"Criando Arquivo Tempor rio..."
STR0003+Upper(Alltrim(cSayCC)) +" / " +  STR0011 )     //"Balancete Verificacao C.CUSTO / CONTA

If Select("cArqTmp") == 0
	oReport:CancelPrint()
	Return
EndIf

If mv_par29 == 1	//Se totaliza centro de custo
	dbSelectArea("cArqTmp")
	dbSetOrder(1)
	dbGotop()
	While!Eof()
		If !Empty(cArqTmp->CCSUP)
			dbSelectArea("CTT")
			dbSetOrder(1)
			If MsSeek(xFilial()+cArqTmp->CCSUP)
				If Empty(CTT->CTT_CCSUP)
					lNivel1	:= .T.
				Else
					lNivel1	:= .F.
				EndIf
			EndIf
			
			dbSelectArea("cArqTmp")
			If (( mv_par28 == 2 .And. TIPOCC == "2" ) .Or. (mv_par28 == 1 .And. TIPOCC == "1" ) .Or. (mv_par28 == 3 ) .Or. lNivel1) .And.;
				(( mv_par07 == 2 .And. TIPOCONTA == "2" ) .Or. (mv_par07 <> 2 .And. TIPOCONTA == "1" .And. Empty(CTASUP)))
				
				nPosCC	:= ASCAN(aTotCCSup,{|x| x[1]==CCSUP})
				If  nPosCC <= 0
					aSupCC := {}
					For nVezes := 1 to Len(aMeses)
						aAdd(aSupCC,&("COLUNA"+Alltrim(Str(nVezes,2))))
					Next
					If Len(aMeses) < 12
						For nVezes := Len(aMeses)+1 to 12
							aAdd(aSupCC,0)
						Next
					EndIf
					AADD(aTotCCSup,{CCSUP,aSupCC})
				Else
					For nVezes := 1 to Len(aMeses)
						aTotCCSup[nPosCC][2][nVezes]	+= 	&("COLUNA"+Alltrim(Str(nVezes,2)))
					Next
				EndIf
			EndIf
		EndIf
		dbSkip()
		
	End
EndIf

dbSelectArea("cArqTmp")
dbSetOrder(1)
dbGoTop()

//-----------------------------------------------------------------
//--> final da selecao
nMesProc := val(substr(DTOS(MV_PAR01),5,2) )

For nPP := nMesProc to  val(substr(DTOS(MV_PAR02),5,2) )
	nKK++ //contador de colunas para agrupar os resultados.
	cQuery := ""
	cQuery += " SELECT CT4_FILIAL,CT4_ITEM,CT4_CUSTO,CT4_CONTA,(CT4_DEBITO-CT4_CREDIT) AS MOV   "
	cQuery += " FROM " + RETSQLNAME("CT4")
	cQuery += " WHERE CT4_CONTA BETWEEN '"+ MV_PAR05 + "' AND '" + MV_PAR06 + "'"
	cQuery += " AND CT4_DATA BETWEEN '" + DTOS(aPeriodos[nPP,1]) + "' AND '" + DTOS(aPeriodos[nPP,2]) + "'"
	cQuery += " AND CT4_ITEM  = '"+ cFilAnt +"'"
	cQuery += " AND CT4_FILIAL <> '"+ cFilAnt +"'"
	cQuery += " AND D_E_L_E_T_ <> '*' "
	cQuery += " ORDER BY CT4_FILIAL,CT4_CUSTO, CT4_CONTA "
	TcQuery cQuery New Alias "M1"
	

	cArqTmp->(dbGoTop()) //Posiciona o Arquivo temporário no primeiro registro

	//-- existem lançamento que nao sao da filial corrente e devem ser exluidos do relatorio
	//-- que deve mostrar somente a despesa da filial solicitada. 
	//-- no processamento abaixo será retirado o registro que nao pertence a filial solicitada. 
	dbSelectArea("cArqTmp")
	cArqTmp->(dbGoTop())
	aCtaSup := {}
	nRec := 0 
	DO while cArqTmp->(!eof())

		cQuery := ""
		cQuery += " SELECT *  "
		cQuery += " FROM " + RETSQLNAME("CT4")
		cQuery += " WHERE CT4_CONTA = '"+ cArqTmp->CONTA+ "'"
		cQuery += " AND CT4_DATA BETWEEN '" + DTOS(aPeriodos[nPP,1]) + "' AND '" + DTOS(aPeriodos[nPP,2]) + "'"
		cQuery += " AND CT4_CUSTO  = '"+ cArqTmp->CUSTO +"'"
		cQuery += " AND CT4_FILIAL <> CT4_ITEM "
		cQuery += " AND D_E_L_E_T_ <> '*' "
		cQuery += " ORDER BY CT4_CONTA "
		TcQuery cQuery New Alias "M9"

		dbSelectArea("cArqTmp")
		do while M9->(!eof())
			cVar	:= "cArqTmp->COLUNA"+alltrim(Str(nKK)) 	// grava dados do periodo
			if cArqTmp->CONTA = M9->CT4_CONTA 
			 	if cArqTmp->CUSTO = M9->CT4_CUSTO 
			 		if cArqTmp->CUSTO = M9->CT4_CUSTO 
			 			if &cVar = (M9->CT4_DEBITO * -1)
							RecLock("cArqTmp",.F.)
			    			&cVar  := 0.00
							cArqTmp->(msUnlock())
						endif
					endif
				endif
			endif 
			M9->(dbSkip())
		enddo 		
		M9->(dbCloseArea())
		cArqTmp->(dbSkip())
	enddo
    //-- Fim do processamento. 



	//Grava o item que não tem no relatório, pois o relatório nao contempla
	do While M1->(!eof())
		if !cArqTmp->(dbSeek(M1->CT4_CUSTO + M1->CT4_CONTA	)) //Pesquisa no Temporário se existe a conta temporária
			RecLock("cArqTmp",.T.)
		else
			RecLock("cArqTmp",.F.)
		endif
		if M1->MOV < 0
			cVar	:= "cArqTmp->COLUNA"+alltrim(Str(nKK)) 	// grava dados do periodo
			&(cVar)	:= &(cVar)+(M1->MOV * -1)
			cArqTmp->CONTA		:= M1->CT4_CONTA
			cArqTmp->CUSTO		:= M1->CT4_CUSTO
			IF CTT->(dbSeek(xFilial("CTT")+cArqTmp->CUSTO	))
				cArqTmp->DESCCC		:= CTT->CTT_DESC01
			else
				cArqTmp->DESCCC		:= "N/I"
			endif
			cArqTmp->TIPOCC			:= 	CTT->CTT_CLASSE
			cArqTmp->CCSUP 			:= 	CTT->CTT_CCLP
			
			IF CT1->(dbSeek(xFilial("CT1")+cArqTmp->CONTA	))
				cArqTmp->DESCCTA	:= CT1->CT1_DESC01
			else
				cArqTmp->DESCCTA	:= "N/I"
			endif
			
			cArqTmp->CTARES			:= CT1->CT1_RES
			cArqTmp->TIPOCONTA 		:= CT1->CT1_NORMAL
			cArqTmp->CTASUP 		:= CT1->CT1_CTASUP
			cArqTmp->FILIAL 		:= cFilAnt
		else
			cVar	:= "cArqTmp->COLUNA"+alltrim(Str(nKK)) 	// grava dados do periodo
			&(cVar)	:= &(cVar)+(M1->MOV * -1)
			cArqTmp->CONTA		:= M1->CT4_CONTA
			cArqTmp->CUSTO		:= M1->CT4_CUSTO
			if CTT->(dbSeek(xFilial("CTT")+cArqTmp->CUSTO	))
				cArqTmp->DESCCC		:= CTT->CTT_DESC01
			else
				cArqTmp->DESCCC		:= "N/I"
			endif
			cArqTmp->TIPOCC			:= 	CTT->CTT_CLASSE
			cArqTmp->CCSUP 			:= 	CTT->CTT_CCLP
			
			if CT1->(dbSeek(xFilial("CT1")+cArqTmp->CONTA	))
				cArqTmp->DESCCTA	:= CT1->CT1_DESC01
			else
				cArqTmp->DESCCTA	:= "N/I"
			endif
			
			cArqTmp->CTARES			:= CT1->CT1_RES
			cArqTmp->TIPOCONTA 		:= CT1->CT1_NORMAL
			cArqTmp->CTASUP 		:= CT1->CT1_CTASUP
			cArqTmp->FILIAL 		:= cFilAnt
		endif
		cArqTmp->(msUnlock())
		M1->(dbSkip())
	enddo
	
	//Trabalhar com o temporario para inserir as contas superiores no arquivo que falta.
	nArqTab := "MAC285"+alltrim(str(nKK))+".dbf"
	Copy To &(nArqTab)  //Copia arquivo para area auxiliar
	dbUseArea(.t.,,nArqTab,"MAC")
	INDEX ON CUSTO + CONTA TO MAC
	MAC->(dbGoTop()) //Posiciona o Arquivo temporário no primeiro registro
	cArqTmp->(dbGoTop()) //Posiciona o Arquivo temporário no primeiro registro
	
	//Leitura do arquivo para verificar a as contas superiores
	aCtaSup := {}
	do While MAC->(!eof())
		cCt	:= MAC->CUSTO
		if len(alltrim(MAC->CONTA)) = 7
			CT1->(dbSeek(xFilial("CT1")+MAC->CONTA))
			AADD(aCtaSup,CT1->CT1_CTASUP)
			CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
			AADD(aCtaSup,CT1->CT1_CTASUP)
			CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
			AADD(aCtaSup,CT1->CT1_CTASUP)
			CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
			AADD(aCtaSup,CT1->CT1_CTASUP)
		endif
		For YY = 1 to len(aCtaSup)
			if !cArqTmp->(dbSeek(cCt + aCtaSup[YY] 	)) //Pesquisa no Temporário se existe a conta superior
				CT1->(dbSeek(xFilial("CT1")+aCtaSup[YY] ))
				RecLock("cArqTmp",.T.)
				cVar	:= "cArqTmp->COLUNA"+alltrim(Str(nKK)) 	// grava dados do periodo
				&(cVar)	:= (M1->MOV * -1)  //verificar o valor a ser gravado
				cArqTmp->CONTA		:= CT1->CT1_CONTA
				cArqTmp->CUSTO		:= cCt
				if CTT->(dbSeek(xFilial("CTT")+cCt	))
					cArqTmp->DESCCC		:= CTT->CTT_DESC01
				else
					cArqTmp->DESCCC		:= "N/I"
				endif
				cArqTmp->TIPOCC			:= 	CTT->CTT_CLASSE
				cArqTmp->CCSUP 			:= 	CTT->CTT_CCSUP
				cArqTmp->DESCCTA		:= 	CT1->CT1_DESC01
				cArqTmp->CTARES			:= 	CT1->CT1_RES
				cArqTmp->TIPOCONTA 		:= 	CT1->CT1_NORMAL
				cArqTmp->CTASUP 		:= 	CT1->CT1_CTASUP
				cArqTmp->FILIAL 		:=	cFilAnt
				cArqTmp->(msUnlock())
			endif
		next YY
		aCtaSup := {}
		MAC->(dbSkip())
	enddo


	//Zerando valores das contas sinteticas
	dbSelectArea("cArqTmp")
	cArqTmp->(dbGoTop())
	aCtaSup := {}
	nRec := 0 
	DO WHILE cArqTmp->(!eof())
		nRec++
		dbGoto(nRec)
		cCt	:= cArqTmp->CUSTO
		aCtaSup := {}
		if len(alltrim(cArqTmp->CONTA)) = 7
			CT1->(dbSeek(xFilial("CT1")+cArqTmp->CONTA))
			AADD(aCtaSup,CT1->CT1_CTASUP)
			CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
			AADD(aCtaSup,CT1->CT1_CTASUP)
			CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
			AADD(aCtaSup,CT1->CT1_CTASUP)
			CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
			AADD(aCtaSup,CT1->CT1_CTASUP)
		else
            loop
		endif
		
		for YN = 1 to len(aCtaSup)
			cArqTmp->(dbSeek(cCt + aCtaSup[YN] )) //Pesquisa no CT1 se existe a conta superior
			RecLock("cArqTmp",.F.)
			//cArqTmp->FILIAL := "10"//cFilAnt

			cVar	:= "cArqTmp->COLUNA"+alltrim(Str(nKK)) 	// grava dados do periodo
			&(cVar) := 0
			cArqTmp->(msUnlock())
		Next YN
	enddo
	//--------------------------------------------------------------------------------------------------
	
    //Adicionando valores as contas superiores 
    

	cArqTmp->(dbGoTop())
	aCtaSup := {}
	nRec := 0 
	DO WHILE cArqTmp->(!eof())
		nRec++
		dbGoto(nRec)
		cCt	:= cArqTmp->CUSTO
		cVar1	:= "cArqTmp->COLUNA"+alltrim(Str(nKK)) // 	Captura o valor do lançamento
		nValor := &cVar1 //Valor do lançamento
		aCtaSup := {}
		if len(alltrim(cArqTmp->CONTA)) = 7
			CT1->(dbSeek(xFilial("CT1")+cArqTmp->CONTA))
			AADD(aCtaSup,CT1->CT1_CTASUP)
			CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
			AADD(aCtaSup,CT1->CT1_CTASUP)
			CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
			AADD(aCtaSup,CT1->CT1_CTASUP)
			CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
			AADD(aCtaSup,CT1->CT1_CTASUP)
		else
            loop
		endif
		
		For YN = 1 to len(aCtaSup)
			cArqTmp->(dbSeek(cCt + aCtaSup[YN] )) //Pesquisa no CT1 se existe a conta superior
			RecLock("cArqTmp",.F.)
			//cArqTmp->FILIAL := "10"//cFilAnt

			cVar	:= "cArqTmp->COLUNA"+alltrim(Str(nKK)) 	// grava dados do periodo
			&cVar := (&cVar + nValor) 
			cArqTmp->(msUnlock())
		Next YN
		cArqTmp->(dbSkip())
	enddo
	MAC->(dbCloseArea())
	M1->(dbCloseArea())
Next

dbSelectArea("cArqTmp")
dbSetOrder(1)
dbGoTop()


//-------------------------------------------------------------------

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial
//nao esta disponivel e sai da rotina.
If RecCount() == 0 .And. !Empty(aSetOfBook[5])
	dbCloseArea()
	FErase(cArqTmp+GetDBExtension())
	FErase("cArqInd"+OrdBagExt())
	oReport:CancelPrint()
	Return
Endif

//linha detalhe
//Se totaliza e mostra a descricao
//If mv_par26 = 1 .And. mv_par27 = 2
//	oCentroCusto:Cell("CTT_CUSTO"):SetBlock({||Left(cArqTmp->DESCCTA,18)})
//Else
//	If mv_par20 == 1 //Codigo Normal
//		oCentroCusto:Cell("CTT_CUSTO"):SetBlock({|| EntidadeCTB(Subs(cArqTmp->CONTA,1,16),,,16,.F.,cMascara,cSepara2,/*cAlias*/,/*nOrder*/,.F./*lGraf*/,/*oPrint*/,.F./*lSay*/) } )
//	Else //Codigo Reduzido
//		oCentroCusto:Cell("CTT_CUSTO"):SetBlock({|| EntidadeCTB(cArqTmp->CTARES,,,16,.F.,cMascara,cSepara2,/*cAlias*/,/*nOrder*/,.F./*lGraf*/,/*oPrint*/,.F./*lSay*/) } )
//	Endif
//Endif

oCentroCusto:Cell("CTT_CUSTO"):SetBlock({||EntidadeCTB(Subs(cArqTmp->CONTA,1,12),,,12,.F.,cMascara,cSepara2,/*cAlias*/,/*nOrder*/,.F./*lGraf*/,/*oPrint*/,.F./*lSay*/) } )
oCentroCusto:Cell("CTT_DESC01"):SetBlock({||Left(cArqTmp->DESCCTA,30)})

// Se nao totalizar ou se totalizar e mostrar a descricao da conta
//If mv_par26 == 2
//	oCentroCusto:Cell("CTT_DESC01"):SetBlock({|| Left(cArqTmp->DESCCTA,19) })
//Endif


if cTpSemestre2 = 1  // primeiro semestre
	oCentroCusto:Cell("VALOR_PER01"):SetBlock({|| ValorCTB(cArqTmp->COLUNA1,,,12,nDecimais,CtbSinalMov(),cPicture, cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )
	oCentroCusto:Cell("VALOR_PER02"):SetBlock({|| ValorCTB(cArqTmp->COLUNA2,,,12,nDecimais,CtbSinalMov(),cPicture, cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )
	oCentroCusto:Cell("VALOR_PER03"):SetBlock({|| ValorCTB(cArqTmp->COLUNA3,,,12,nDecimais,CtbSinalMov(),cPicture, cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )
	oCentroCusto:Cell("VALOR_PER04"):SetBlock({|| ValorCTB(cArqTmp->COLUNA4,,,12,nDecimais,CtbSinalMov(),cPicture, cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )
	oCentroCusto:Cell("VALOR_PER05"):SetBlock({|| ValorCTB(cArqTmp->COLUNA5,,,12,nDecimais,CtbSinalMov(),cPicture, cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )
	oCentroCusto:Cell("VALOR_PER06"):SetBlock({|| ValorCTB(cArqTmp->COLUNA6,,,12,nDecimais,CtbSinalMov(),cPicture, cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )
	
elseif  cTpSemestre2 = 2  // segundo semestre
	oCentroCusto:Cell("VALOR_PER07"):SetBlock({|| ValorCTB(cArqTmp->COLUNA7,,,12,nDecimais,CtbSinalMov(),cPicture, cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )
	oCentroCusto:Cell("VALOR_PER08"):SetBlock({|| ValorCTB(cArqTmp->COLUNA8,,,12,nDecimais,CtbSinalMov(),cPicture, cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )
	oCentroCusto:Cell("VALOR_PER09"):SetBlock({|| ValorCTB(cArqTmp->COLUNA9,,,12,nDecimais,CtbSinalMov(),cPicture, cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )
	oCentroCusto:Cell("VALOR_PER10"):SetBlock({|| ValorCTB(cArqTmp->COLUNA10,,,12,nDecimais,CtbSinalMov(),cPicture, cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )
	oCentroCusto:Cell("VALOR_PER11"):SetBlock({|| ValorCTB(cArqTmp->COLUNA11,,,12,nDecimais,CtbSinalMov(),cPicture, cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )
	oCentroCusto:Cell("VALOR_PER12"):SetBlock({|| ValorCTB(cArqTmp->COLUNA12,,,12,nDecimais,CtbSinalMov(),cPicture, cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )
endif

If mv_par26 == 1
	oCentroCusto:Cell("VALOR_TOTAL"):enable()
	oCentroCusto:Cell("VALOR_TOTAL"):SetBlock({|| ValorCTB(nTotLinha,,,12,nDecimais,CtbSinalMov(),cPicture, cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )
EndIf

//------------------total do centro de custo

//If mv_par26 == 2
//	If mv_par19 == 2	.And. cArqTmp->TIPOCC == '2'//Se Imprime cod. reduzido do centro de Custo e eh analitico
//		oTotCenCusto:Cell("CTT_CUSTO"):SetBlock({|| "" })
//		oTotCenCusto:Cell("CTT_DESC01"):SetBlock({|| STR0018+ Upper(Alltrim(cSayCC))+ " : " +EntidadeCTB(cCCResAnt,,,15,.F.,cMascCC,cSepara1,/*cAlias*/,/*nOrder*/,.F./*lGraf*/,/*oPrint*/,.F./*lSay*/) })
//	Else //Se Imprime cod. normal do Centro de Custo
//		oTotCenCusto:Cell("CTT_CUSTO"):SetBlock({|| "" })
//		oTotCenCusto:Cell("CTT_DESC01"):SetBlock({|| STR0018+ Upper(Alltrim(cSayCC))+ " : "+ EntidadeCTB(cCustoAnt,,,15,.F.,cMascCC,cSepara1,/*cAlias*/,/*nOrder*/,.F./*lGraf*/,/*oPrint*/,.F./*lSay*/)	 })
//	Endif
//Else                                                        J
//	oTotCenCusto:Cell("CTT_CUSTO"):SetBlock({|| "" })
//	oTotCenCusto:Cell("CTT_DESC01"):SetBlock({||STR0026+;
//										If(mv_par19 == 2 .And. cArqTmp->TIPOCC == '2'/*Se Imprime cod. reduzido do centro de Custo e eh analitico*/,;
//												Subs(cCCResAnt,1,10),;
//												Subs(cCustoAnt,1,10);
//											) })  //"TOTAIS: "
//EndIf

//oTotCenCusto:Cell("CTT_CUSTO"):SetBlock({|| "" })
//oTotCenCusto:Cell("CTT_DESC01"):SetBlock({|| STR0018+ Upper(Alltrim(cSayCC))+ " : "+ EntidadeCTB(cCustoAnt,,,15,.F.,cMascCC,cSepara1,/*cAlias*/,/*nOrder*/,.F./*lGraf*/,/*oPrint*/,.F./*lSay*/)	 })

//if cTpSemestre == 1 // primeiro semestre
//	oTotCenCusto:Cell("VALOR_PER01"):SetBlock({|| ValorCTB(aTotCC[ 1],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
//	oTotCenCusto:Cell("VALOR_PER02"):SetBlock({|| ValorCTB(aTotCC[ 2],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
//	oTotCenCusto:Cell("VALOR_PER03"):SetBlock({|| ValorCTB(aTotCC[ 3],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
//	oTotCenCusto:Cell("VALOR_PER04"):SetBlock({|| ValorCTB(aTotCC[ 4],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
//	oTotCenCusto:Cell("VALOR_PER05"):SetBlock({|| ValorCTB(aTotCC[ 5],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
//	oTotCenCusto:Cell("VALOR_PER06"):SetBlock({|| ValorCTB(aTotCC[ 6],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
//else
//	oTotCenCusto:Cell("VALOR_PER07"):SetBlock({|| ValorCTB(aTotCC[ 7],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
//	oTotCenCusto:Cell("VALOR_PER08"):SetBlock({|| ValorCTB(aTotCC[ 8],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
//	oTotCenCusto:Cell("VALOR_PER09"):SetBlock({|| ValorCTB(aTotCC[ 9],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
//	oTotCenCusto:Cell("VALOR_PER10"):SetBlock({|| ValorCTB(aTotCC[10],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
//	oTotCenCusto:Cell("VALOR_PER11"):SetBlock({|| ValorCTB(aTotCC[11],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
//	oTotCenCusto:Cell("VALOR_PER12"):SetBlock({|| ValorCTB(aTotCC[12],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
//endif

//If mv_par26 == 1
//	oTotCenCusto:Cell("VALOR_TOTAL"):enable()
//	oTotCenCusto:Cell("VALOR_TOTAL"):SetBlock({|| ValorCTB(nTotLinha,,,12,nDecimais,CtbSinalMov(),cPicture, cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )
//EndIf
//------------------total do centro de custo superior

//If mv_par26 == 2
//	If mv_par19 == 2	.And. cArqTmp->TIPOCC == '2'//Se Imprime cod. reduzido do centro de Custo e eh analitico
//		oTotSupCusto:Cell("CTT_CUSTO"):SetBlock({|| STR0018+ Upper(Alltrim(cSayCC))+ " : "+EntidadeCTB(cCCResAnt,,,15,.F.,cMascCC,cSepara1,/*cAlias*/,/*nOrder*/,.F./*lGraf*/,/*oPrint*/,.F./*lSay*/) })
//	Else //Se Imprime cod. normal do Centro de Custo
//		oTotSupCusto:Cell("CTT_CUSTO"):SetBlock({|| STR0018+ Upper(Alltrim(cSayCC))+ " : "+EntidadeCTB(cAntCCSup,,,15,.F.,cMascCC,cSepara1,/*cAlias*/,/*nOrder*/,.F./*lGraf*/,/*oPrint*/,.F./*lSay*/) })
//	Endif
//Else
//	If mv_par19 == 2	.And. cArqTmp->TIPOCC == '2'//Se Imprime cod. reduzido do centro de Custo e eh analitico
//		oTotSupCusto:Cell("CTT_CUSTO"):SetBlock({|| STR0026 + Subs(cCCResAnt,1,10)})
//	Else //Se Imprime cod. normal do Centro de Custo
//		oTotSupCusto:Cell("CTT_CUSTO"):SetBlock({|| STR0026 + Subs(cAntCCSup,1,10)})
//	Endif
//EndIf



if cTpSemestre2 = 1  // primeiro semestre
	oTotSupCusto:Cell("VALOR_PER01"):SetBlock({|| ValorCTB(aTotCCSup[nPosCC][2][ 1],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotSupCusto:Cell("VALOR_PER02"):SetBlock({|| ValorCTB(aTotCCSup[nPosCC][2][ 2],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotSupCusto:Cell("VALOR_PER03"):SetBlock({|| ValorCTB(aTotCCSup[nPosCC][2][ 3],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotSupCusto:Cell("VALOR_PER04"):SetBlock({|| ValorCTB(aTotCCSup[nPosCC][2][ 4],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotSupCusto:Cell("VALOR_PER05"):SetBlock({|| ValorCTB(aTotCCSup[nPosCC][2][ 5],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotSupCusto:Cell("VALOR_PER06"):SetBlock({|| ValorCTB(aTotCCSup[nPosCC][2][ 6],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
elseif cTpSemestre2 = 2
	oTotSupCusto:Cell("VALOR_PER07"):SetBlock({|| ValorCTB(aTotCCSup[nPosCC][2][ 7],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotSupCusto:Cell("VALOR_PER08"):SetBlock({|| ValorCTB(aTotCCSup[nPosCC][2][ 8],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotSupCusto:Cell("VALOR_PER09"):SetBlock({|| ValorCTB(aTotCCSup[nPosCC][2][ 9],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotSupCusto:Cell("VALOR_PER10"):SetBlock({|| ValorCTB(aTotCCSup[nPosCC][2][10],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotSupCusto:Cell("VALOR_PER11"):SetBlock({|| ValorCTB(aTotCCSup[nPosCC][2][11],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotSupCusto:Cell("VALOR_PER12"):SetBlock({|| ValorCTB(aTotCCSup[nPosCC][2][12],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
endif


If mv_par26 == 1
	oTotSupCusto:Cell("VALOR_TOTAL"):enable()
	oTotSupCusto:Cell("VALOR_TOTAL"):SetBlock({|| ValorCTB(nTotLinha,,,12,nDecimais,CtbSinalMov(),cPicture, cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )
EndIf

//------------------total Geral
//If mv_par26 == 2
//	oTotGerCusto:Cell("CTT_CUSTO"):SetBlock({|| STR0017 })   //"T O T A I S  D O  P E R I O D O : "
//Else //Se Imprime cod. normal do Centro de Custo
//	oTotGerCusto:Cell("CTT_CUSTO"):SetBlock({|| STR0027 })   //"TOTAIS  DO  PERIODO: "
//EndIf


if cTpSemestre2 == 1  // primeiro semestre
	oTotGerCusto:Cell("VALOR_PER01"):SetBlock({|| ValorCTB(aTotCol[ 1],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGerCusto:Cell("VALOR_PER02"):SetBlock({|| ValorCTB(aTotCol[ 2],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGerCusto:Cell("VALOR_PER03"):SetBlock({|| ValorCTB(aTotCol[ 3],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGerCusto:Cell("VALOR_PER04"):SetBlock({|| ValorCTB(aTotCol[ 4],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGerCusto:Cell("VALOR_PER05"):SetBlock({|| ValorCTB(aTotCol[ 5],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGerCusto:Cell("VALOR_PER06"):SetBlock({|| ValorCTB(aTotCol[ 6],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
else
	oTotGerCusto:Cell("VALOR_PER07"):SetBlock({|| ValorCTB(aTotCol[ 7],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGerCusto:Cell("VALOR_PER08"):SetBlock({|| ValorCTB(aTotCol[ 8],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGerCusto:Cell("VALOR_PER09"):SetBlock({|| ValorCTB(aTotCol[ 9],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGerCusto:Cell("VALOR_PER10"):SetBlock({|| ValorCTB(aTotCol[10],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGerCusto:Cell("VALOR_PER11"):SetBlock({|| ValorCTB(aTotCol[11],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGerCusto:Cell("VALOR_PER12"):SetBlock({|| ValorCTB(aTotCol[12],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
endif


If mv_par26 == 1
	oTotGerCusto:Cell("VALOR_TOTAL"):disable() //enable()
	oTotGerCusto:Cell("VALOR_TOTAL"):SetBlock({|| ValorCTB(nTotGeral,,,12,nDecimais,CtbSinalMov(),cPicture, cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )
EndIf


//------------------total do grupo
If mv_par31 == 1
	oTotGrupo:Cell("CTT_CUSTO"):SetBlock({|| "" })
	oTotGrupo:Cell("CTT_DESC01"):SetBlock({|| STR0030 + Left(cGrupo,10) + ")" })		//"GRUPO ("
EndIf

if cTpSemestre2 == 1  // primeiro semestre
	oTotGrupo:Cell("VALOR_PER01"):SetBlock({|| ValorCTB(aTotGrupo[ 1],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGrupo:Cell("VALOR_PER02"):SetBlock({|| ValorCTB(aTotGrupo[ 2],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGrupo:Cell("VALOR_PER03"):SetBlock({|| ValorCTB(aTotGrupo[ 3],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGrupo:Cell("VALOR_PER04"):SetBlock({|| ValorCTB(aTotGrupo[ 4],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGrupo:Cell("VALOR_PER05"):SetBlock({|| ValorCTB(aTotGrupo[ 5],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGrupo:Cell("VALOR_PER06"):SetBlock({|| ValorCTB(aTotGrupo[ 6],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
else
	oTotGrupo:Cell("VALOR_PER07"):SetBlock({|| ValorCTB(aTotGrupo[ 7],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGrupo:Cell("VALOR_PER08"):SetBlock({|| ValorCTB(aTotGrupo[ 8],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGrupo:Cell("VALOR_PER09"):SetBlock({|| ValorCTB(aTotGrupo[ 9],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGrupo:Cell("VALOR_PER10"):SetBlock({|| ValorCTB(aTotGrupo[10],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGrupo:Cell("VALOR_PER11"):SetBlock({|| ValorCTB(aTotGrupo[11],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
	oTotGrupo:Cell("VALOR_PER12"):SetBlock({|| ValorCTB(aTotGrupo[12],,,12,nDecimais,CtbSinalMov(),cPicture, , , , , , ,lPrintZero,.F./*lSay*/) } )
endif

If mv_par26 == 1
	oTotGrupo:Cell("VALOR_TOTAL"):enable()
	oTotGrupo:Cell("VALOR_TOTAL"):SetBlock({|| ValorCTB(nTotLinGrp,,,12,nDecimais,CtbSinalMov(),cPicture, cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )
EndIf

//------------------inicio do relatorio
dbSelectArea("cArqTmp")
dbGoTop()
oReport:SetMeter(RecCount())
oCentroCusto:Init()

cGrupo    := cArqTmp->GRUPO

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIF
	
	oReport:IncMeter()
	
	cText_CC 	:= ""
	cText_CCSup := ""
	cText_CCGer	:= ""
	cText_Grupo	:= ""
	
	******************** "FILTRAGEM" PARA IMPRESSAO *************************
	
	
	If mv_par28 == 1					// So imprime Sinteticas
		If TIPOCC == "2"
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par28 == 2				// So imprime Analiticas
		If TIPOCC == "1"
			dbSkip()
			Loop
		EndIf
	EndIf
	
	If mv_par07 == 1					// So imprime Sinteticas
		If TIPOCONTA == "2"
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par07 == 2				// So imprime Analiticas
		If TIPOCONTA == "1"
			dbSkip()
			Loop
		EndIf
	EndIf
	
	//Filtragem ate o Segmento ( antigo nivel do SIGACON)
	If !Empty(cSegAte)
		If Len(Alltrim(CONTA)) > nDigitAte
			dbSkip()
			Loop
		Endif
	EndIf
	
	dbSelectArea("cArqTmp")
	If lVlrZerado	.And. ;
		(Abs(COLUNA1)+Abs(COLUNA2)+Abs(COLUNA3)+Abs(COLUNA4)+Abs(COLUNA5)+Abs(COLUNA6)+Abs(COLUNA7)+Abs(COLUNA8)+;
		Abs(COLUNA9)+Abs(COLUNA10)+Abs(COLUNA11)+Abs(COLUNA12)) == 0
		If CtbExDtFim("CTT")
			dbSelectArea("CTT")
			dbSetOrder(1)
			If MsSeek(xFilial()+ cArqTmp->CUSTO)
				If !CtbVlDtFim("CTT",mv_par01)
					dbSelectArea("cArqTmp")
					dbSkip()
					Loop
				EndIf
			EndIf
		EndIf
		
		If CtbExDtFim("CT1")
			dbSelectArea("CT1")
			dbSetOrder(1)
			If MsSeek(xFilial()+ cArqTmp->CONTA)
				If !CtbVlDtFim("CT1",mv_par01)
					dbSelectArea("cArqTmp")
					dbSkip()
					Loop
				EndIf
			EndIf
		EndIf
		dbSelectArea("cArqTmp")
	EndIf
	
	//Caso faca filtragem por segmento de Conta,verifico se esta dentro
	//da solicitacao feita pelo usuario.
	If !Empty(mv_par14)
		If Empty(mv_par15) .And. Empty(mv_par16) .And. !Empty(mv_par17)
			If  !(Substr(cArqTMP->CONTA,nPos,nDigitos) $ (mv_par17) )
				dbSkip()
				Loop
			EndIf
		Else
			If Substr(cArqTMP->CONTA,nPos,nDigitos) < Alltrim(mv_par15) .Or. Substr(cArqTMP->CONTA,nPos,nDigitos) > Alltrim(mv_par16)
				dbSkip()
				Loop
			EndIf
		Endif
	EndIf
	
	************************* ROTINA DE IMPRESSAO *************************
	
	
	
	
	If mv_par31 == 1														// Quebra por Grupo Contabil
		
		If !lFirstPage .And.;
			(cGrupo <> cArqTmp->GRUPO) .Or.;										// Grupo Diferente ou
			((cCustoAnt <> cArqTmp->CUSTO) .And. ! Empty(cCustoAnt))				// Centro de Custo Diferente
			
			oReport:ThinLine()
			
			nTotLinGrp	:= 0
			For nVezes := 1 to Len(aTotGrupo)
				nTotLinGrp	+= aTotGrupo[nVezes]
			Next
			
			oTotGrupo:Init()
			oTotGrupo:lPrintHeader := .F.
			cText_Grupo := STR0030 + Left(cGrupo,10) + ")"		//"GRUPO ("
			
			oReport:PrintText(cText_Grupo, oReport:Row(), 5)
			oReport:SkipLine()
			oReport:ThinLine()
			oTotGrupo:PrintLine()
			oTotGrupo:Finish()
			
			cGrupo		:= cArqTmp->GRUPO
			aTotGrupo	:= {0,0,0,0,0,0,0,0,0,0,0,0}
		EndIf
		
	Else																					// Nao quebra por Grupo
		
		If (cCustoAnt <> cArqTmp->CUSTO) .And. ! Empty(cCustoAnt)
			oReport:ThinLine()
			
			dbSelectArea("CTT")
			dbSetOrder(1)
			If MsSeek(xFilial()+cArqTmp->CUSTO)
				cCCSup	:= CTT->CTT_CCSUP
			Else
				cCCSup	:= ""
			EndIf
			
			dbSelectArea("CTT")
			dbSetOrder(1)
			If MsSeek(xFilial()+cCustoAnt)
				cAntCCSup	:= CTT->CTT_CCSUP
			Else
				cAntCCSup	:= ""
			EndIf
			
			//Total da Linha
			nTotLinha	:= 0     			// Incluso esta linha para impressao dos totais
			For nVezes := 1 to Len(aMeses)	// por periodo em 09/06/2004 por Otacilio
				nTotLinha	+= aTotCC[nVezes]
			Next
			
			oTotCenCusto:Init()
			oTotCenCusto:lPrintHeader := .F.
			
			If mv_par26 == 2
				//cText_CC := STR0018+ Upper(Alltrim(cSayCC))+ " : " +EntidadeCTB( If(mv_par19 == 2 .And. cArqTmp->TIPOCC == '2' /* Se Imprime cod. reduzido do centro de Custo e eh analitico */,;
				//                                                               cCCResAnt,cCustoAnt),,,15,.F.,cMascCC,cSepara1,/*cAlias*/,/*nOrder*/,.F./*lGraf*/,/*oPrint*/,.F./*lSay*/)
			Else
				//cText_CC := STR0026+If( mv_par19 == 2 .And. cArqTmp->TIPOCC == '2'/*Se Imprime cod. reduzido do centro de Custo e eh analitico*/,;
				//                      Subs(cCCResAnt,1,10),;
				//					Subs(cCustoAnt,1,10))
			EndIf
			
			//oReport:PrintText(cText_CC, oReport:Row(), 5)
			//oReport:SkipLine()
			//oReport:ThinLine()
			//oTotCenCusto:PrintLine()
			oReport:SkipLine()
			oTotCenCusto:Finish()
			
			aTotCC 	:= {0,0,0,0,0,0,0,0,0,0,0,0}
			
			If lImpTotS .And. cCCSup <> cAntCCSup .And. !Empty(cAntCCSup) //Se for centro de custo superior diferente
				//oReport:SkipLine()
				
				//Total da Linha
				nTotLinha	:= 0     			// Incluso esta linha para impressao dos totais
				
				nPosCC	:= ASCAN(aTotCCSup,{|x| x[1]== cAntCCSup })
				If  nPosCC > 0
					For nVezes := 1 to Len(aMeses)	// por periodo em 09/06/2004 por Otacilio
						nTotLinha	+= aTotCCSup[nPosCC][2][nVezes]
					Next
					oTotSupCusto:Init()
					oTotSupCusto:lPrintHeader := .F.
					If mv_par26 == 2
						//cText_CCSup := STR0018+Upper(Alltrim(cSayCC))+ " : "+EntidadeCTB( If(mv_par19 == 2,cCCResAnt,cAntCCSup) ,,,15,.F.,cMascCC,cSepara1,/*cAlias*/,/*nOrder*/,.F./*lGraf*/,/*oPrint*/,.F./*lSay*/)
					Else
						//cText_CCSup :=  STR0026 + Subs( IF(mv_par19 == 2 .And. cArqTmp->TIPOCC == '2' /*Se Imprime cod. reduzido do centro de Custo e eh analitico*/,;
						//                                 cCCResAnt,;
						//                               cAntCCSup) ,1,10)
					EndIf
					
					oReport:PrintText(cText_CCSup, oReport:Row(), 5)
					oReport:SkipLine()
					oReport:ThinLine()
					oTotSupCusto:PrintLine()
					oTotSupCusto:Finish()
					
					dbSelectArea("cArqTmp")
					nRegTmp	:= Recno()
					dbSelectArea("CTT")
					lImpCCSint	:= .T.
				EndIf
				
				While lImpCCSint
					dbSelectArea("CTT")
					If MsSeek(xFilial()+cAntCCSup) .And. !Empty(CTT->CTT_CCSUP)
						cAntCCSup	:= CTT->CTT_CCSUP
						dbSelectArea("cArqTmp")
						
						//Total da Linha
						nTotLinha	:= 0     			// Incluso esta linha para impressao dos totais
						nPosCC	:= ASCAN(aTotCCSup,{|x| x[1]== cAntCCSup })
						If  nPosCC > 0
							For nVezes := 1 to Len(aMeses)	// por periodo em 09/06/2004 por Otacilio
								nTotLinha	+= aTotCCSup[nPosCC][2][nVezes]
							Next
							oTotSupCusto:Init()
							oTotSupCusto:lPrintHeader := .F.
							
							If mv_par26 == 2
								//cText_CCSup := STR0018+Upper(Alltrim(cSayCC))+ " : "+EntidadeCTB( If(mv_par19 == 2,cCCResAnt,cAntCCSup) ,,,15,.F.,cMascCC,cSepara1,/*cAlias*/,/*nOrder*/,.F./*lGraf*/,/*oPrint*/,.F./*lSay*/)
							Else
								//cText_CCSup :=  STR0026 + Subs( IF(mv_par19 == 2 .And. cArqTmp->TIPOCC == '2' /*Se Imprime cod. reduzido do centro de Custo e eh analitico*/,;
								//                                 cCCResAnt,;
								//                               cAntCCSup) ,1,10)
							EndIf
							
							oReport:PrintText(cText_CCSup, oReport:Row(), 5)
							oReport:SkipLine()
							oReport:ThinLine()
							oTotSupCusto:PrintLine()
							
							oTotSupCusto:Finish()
							lImpCCSint	:= .T.
						EndIF
					Else
						lImpCCSint	:= .F.
					EndIf
				End
				cAntCCSup		:= ""
				cCCSup			:= ""
				dbSelectArea("cArqTmp")
				dbGoto(nRegTmp)
			EndIf
		Endif
		
	EndIf
	
	If mv_par31 == 1									// Quebra por Grupo Contabil
		If cGrupo != cArqTmp->GRUPO .And. !lFirstPage		// Grupo Diferente
			oReport:EndPage()
		EndIf
	Else
		If mv_par18 == 1 .And. ! Empty(cCustoAnt)
			If cCustoAnt <> cArqTmp->CUSTO //Se o CC atual for diferente do CC anterior
				oReport:EndPage()
			EndIf
		Endif
	EndIf
	
	
	
	
	
	//Se mudar de centro de custo
	
	if nFlag285r > 1
		cFil285r := ""
	endif
	
	
	If 	(cArqTmp->CUSTO <> cCustoAnt .And. !Empty(cCustoAnt)) .Or. lFirstPage .Or. ;
		(mv_par31 == 1 .And. cGrupoAnt <> cArqTmp->GRUPO)
		
		//Imprime titulo do centro de custo
		oReport:SkipLine()
		oReport:ThinLine()
		
		//Imprime titulo do centro de custo
		oReport:PrintText(Upper(cSayCC), oReport:Row(), oReport:Col())
		If mv_par19 == 2 .And. cArqTmp->TIPOCC == '2'//Se Imprime Cod Reduzido do C.Custo e eh analitico
			oReport:PrintText(EntidadeCTB(CCRES,,,20,.F.,cMascCC,cSepara1,/*cAlias*/,/*nOrder*/,.F./*lGraf*/,/*oPrint*/,.F./*lSay*/), oReport:Row(), oReport:Col()+200)
		Else //Se Imprime Cod. Normal do C.Custo
			oReport:PrintText(EntidadeCTB(alltrim(CUSTO)+" "+alltrim(DESCCC)+UPPER(cFil285r),,,45,.F.,cMascCC,cSepara1,/*cAlias*/,/*nOrder*/,.F./*lGraf*/,/*oPrint*/,.F./*lSay*/), oReport:Row(), oReport:Col()+200)
			nFlag285r++ // flag para nao imprimir filial
			
		Endif
		
		//oReport:PrintText("   " +cArqTMP->DESCCC, oReport:Row(), oReport:Col()+500)
		
		oReport:SkipLine()
		oReport:ThinLine()
		lFirstPage := .F.
	Endif
	
	
	dbSelectArea("cArqTmp")
	//Total da Linha
	nTotLinha	:= COLUNA1+COLUNA2+COLUNA3+COLUNA4+COLUNA5+COLUNA6+COLUNA7+COLUNA8+COLUNA9+COLUNA10+COLUNA11+COLUNA12
	oCentroCusto:PrintLine()
	
	lJaPulou := .F.
	If lPula .And. TIPOCONTA == "1"				// Pula linha entre sinteticas
		//oReport:SkipLine()
		//oReport:SkipLine()
		lJaPulou := .T.
	Else
		//oReport:SkipLine()
	EndIf
	
	************************* FIM   DA  IMPRESSAO *************************
	
	If mv_par07 != 1					// Imprime Analiticas ou Ambas
		If TIPOCONTA == "2"
			If (mv_par28 != 1 .And. TIPOCC == "2")
				For nVezes := 1 to Len(aMeses)
					aTotCol[nVezes]	+=&("COLUNA"+Alltrim(Str(nVezes,2)))
				Next
			ElseIf (mv_par28 == 1 .And. cArqTmp->TIPOCC != "2"	)	//Imprime centro de custo sintetico
				If mv_par07 == 2 	//Imprime contas analiticas
					For nVezes := 1 to Len(aMeses)
						If Empty(CCSUP)
							aTotCol[nVezes]	+=&("COLUNA"+Alltrim(Str(nVezes,2)))
						EndIf
					Next
				ElseIf mv_par07 == 3	//Imprime contas sinteticas e analiticas
					If Empty(CCSUP)      //Somar somente o centro de custo sintetico
						For nVezes := 1 to Len(aMeses)
							aTotCol[nVezes]	+=&("COLUNA"+Alltrim(Str(nVezes,2)))
						Next
					EndIf
				EndIf
			EndIf
			For nVezes := 1 to Len(aMeses)
				aTotCC[nVezes] 		+=&("COLUNA"+Alltrim(Str(nVezes,2)))
				aTotGrupo[nVezes]	+=&("COLUNA"+Alltrim(Str(nVezes,2)))
			Next
		Endif
	Else
		If (TIPOCONTA == "1" .And. Empty(CTASUP))
			If (mv_par28 != 1 .And. cArqTmp->TIPOCC == "2")
				For nVezes := 1 to Len(aMeses)
					aTotCol[nVezes] 	+=&("COLUNA"+Alltrim(Str(nVezes,2)))
				Next
			ElseIf (mv_par28 == 1 .And. cArqTmp->TIPOCC != "2"	)
				If Empty(CCSUP)
					For nVezes := 1 to Len(aMeses)
						aTotCol[nVezes] 	+=&("COLUNA"+Alltrim(Str(nVezes,2)))
					Next
				EndIf
			EndIf
			For nVezes := 1 to Len(aMeses)
				aTotCC[nVezes] 		+=&("COLUNA"+Alltrim(Str(nVezes,2)))
				aTotGrupo[nVezes]	+=&("COLUNA"+Alltrim(Str(nVezes,2)))
			Next
		EndIf
	Endif
	
	cCustoAnt := cArqTmp->CUSTO
	cCCResAnt := cArqTmp->CCRES
	cGrupoAnt := cArqTmp->GRUPO
	cGrupo 	  := cArqTmp->GRUPO
	
	dbSelectarea("cArqTmp")
	dbSkip()
	
	If lPula .And. TIPOCONTA == "1" 			// Pula linha entre sinteticas
		If !lJaPulou
			//oReport:SkipLine()
		EndIf
	EndIf
EndDO

oCentroCusto:Finish()


IF mv_par31 == 1				// Quebra por Grupo Contabil
	If cGrupo <> cArqTmp->GRUPO
		oReport:ThinLine()
		
		nTotLinGrp	:= 0
		For nVezes := 1 to Len(aTotGrupo)
			nTotLinGrp	+= aTotGrupo[nVezes]
		Next
		
		oTotGrupo:Init()
		oTotGrupo:lPrintHeader := .F.
		cText_Grupo := STR0030 + Left(cGrupo,10) + ")"		//"GRUPO ("
		
		//oReport:PrintText(cText_Grupo, oReport:Row(), 5)
		oReport:SkipLine()
		oReport:ThinLine()
		oTotGrupo:PrintLine()
		oTotGrupo:Finish()
	EndIf
ELSE
	
	//Imprime o total do ultimo Conta a ser impresso.
	oReport:ThinLine()
	
	dbSelectArea("CTT")
	dbSetOrder(1)
	If MsSeek(xFilial("CTT")+cArqTmp->CUSTO)
		cCCSup	:= CTT->CTT_CCSUP	//Centro de Custo Superior
	Else
		cCCSup	:= ""
	EndIf
	
	If MsSeek(xFilial("CTT")+cCustoAnt)
		cAntCCSup := CTT->CTT_CCSUP	//Centro de Custo Superior do Centro de custo anterior.
		cCCRes	  := CTT->CTT_RES
	Else
		cAntCCSup := ""
	EndIf
	
	dbSelectArea("cArqTmp")
	
	//Total da Linha
	nTotLinha	:= 0
	For nVezes := 1 to Len(aMeses)
		nTotLinha	+= aTotCC[nVezes]
	Next
	
	oTotCenCusto:Init()
	oTotCenCusto:lPrintHeader := .F.
	
	If mv_par26 == 2
		//cText_CC := STR0018+ Upper(Alltrim(cSayCC))+ " : " +EntidadeCTB( If(mv_par19 == 2 .And. cArqTmp->TIPOCC == '2' /*Se Imprime cod. reduzido do centro de Custo e eh analitico*/,;
		//                                                               cCCResAnt,cCustoAnt),,,15,.F.,cMascCC,cSepara1,/*cAlias*/,/*nOrder*/,.F./*lGraf*/,/*oPrint*/,.F./*lSay*/)
	Else
		// cText_CC := STR0026+If( mv_par19 == 2 .And. cArqTmp->TIPOCC == '2'/*Se Imprime cod. reduzido do centro de Custo e eh analitico*/,;
		//                       Subs(cCCResAnt,1,10),;
		//						Subs(cCustoAnt,1,10))
	EndIf
	//oReport:PrintText(cText_CC, oReport:Row(), 5)
	oReport:SkipLine()
	oReport:ThinLine()
	oTotCenCusto:PrintLine()
	
	oTotCenCusto:Finish()
	
	If (cArqTmp->TIPOCC == "1" .And. !Empty(cArqTmp->CCSUP)) .Or. (cArqTmp->TIPOCC == "2")
		aTotCC 	:= {0,0,0,0,0,0,0,0,0,0,0,0}
	EndIf
	
	If lImpTotS .And. cCCSup <> cAntCCSup .And. !Empty(cAntCCSup) //Se for centro de custo superior diferente
		
		//Total da Linha
		nTotLinha	:= 0     			// Incluso esta linha para impressao dos totais
		nPosCC	:= ASCAN(aTotCCSup,{|x| x[1]== cAntCCSup })
		If  nPosCC > 0
			For nVezes := 1 to Len(aMeses)	// por periodo em 09/06/2004 por Otacilio
				nTotLinha	+= aTotCCSup[nPosCC][2][nVezes]
			Next
			
			oTotSupCusto:Init()
			oTotSupCusto:lPrintHeader := .F.
			
			If mv_par26 == 2
				//cText_CCSup := STR0018+Upper(Alltrim(cSayCC))+ " : "+EntidadeCTB( If(mv_par19 == 2,cCCResAnt,cAntCCSup) ,,,15,.F.,cMascCC,cSepara1,/*cAlias*/,/*nOrder*/,.F./*lGraf*/,/*oPrint*/,.F./*lSay*/)
			Else
				//cText_CCSup :=  STR0026 + Subs( IF(mv_par19 == 2 .And. cArqTmp->TIPOCC == '2' /* Se Imprime cod. reduzido do centro de Custo e eh analitico*/,;
				//                                 cCCResAnt,;
				//                               cAntCCSup) ,1,10)
			EndIf
			
			oReport:PrintText(cText_CCSup, oReport:Row(), 5)
			oReport:SkipLine()
			oReport:ThinLine()
			oTotSupCusto:PrintLine()
			oTotSupCusto:Finish()
			
			dbSelectArea("CTT")
			lImpCCSint	:= .T.
		EndIf
		
		While lImpCCSint
			dbSelectArea("CTT")
			If MsSeek(xFilial()+cAntCCSup) .And. !Empty(CTT->CTT_CCSUP)
				cAntCCSup	:= CTT->CTT_CCSUP
				dbSelectArea("cArqTmp")
				
				//Total da Linha
				nTotLinha	:= 0     			// Incluso esta linha para impressao dos totais
				nPosCC	:= ASCAN(aTotCCSup,{|x| x[1]== cAntCCSup })
				If  nPosCC > 0
					For nVezes := 1 to Len(aMeses)	// por periodo em 09/06/2004 por Otacilio
						nTotLinha	+= aTotCCSup[nPosCC][2][nVezes]
					Next
					
					oTotSupCusto:Init()
					oTotSupCusto:lPrintHeader := .F.
					
					If mv_par26 == 2
						//cText_CCSup := STR0018+Upper(Alltrim(cSayCC))+ " : "+EntidadeCTB( If(mv_par19 == 2,cCCResAnt,cAntCCSup) ,,,15,.F.,cMascCC,cSepara1,/*cAlias*/,/*nOrder*/,.F./*lGraf*/,/*oPrint*/,.F./*lSay*/)
					Else
						//cText_CCSup :=  STR0026 + Subs( IF(mv_par19 == 2 .And. cArqTmp->TIPOCC == '2' /*Se Imprime cod. reduzido do centro de Custo e eh analitico*/,;
						//                                 cCCResAnt,;
						//                               cAntCCSup) ,1,10)
					EndIf
					
					//    oReport:PrintText(cText_CCSup, oReport:Row(), 5)
					oReport:SkipLine()
					oReport:ThinLine()
					oTotSupCusto:PrintLine()
					
					oTotSupCusto:Finish()
					
					lImpCCSint	:= .T.
				EndIf
			Else
				lImpCCSint	:= .F.
			EndIf
		End
		cAntCCSup		:= ""
		cCCSup			:= ""
		dbSelectArea("cArqTmp")
	EndIf
	
ENDIF

IF ! oReport:Cancel()
	oReport:ThinLine()
	
	//TOTAL GERAL
	nTotGeral	:= aTotCol[1]+aTotCol[2]+aTotCol[3]+aTotCol[4]+aTotCol[5]+aTotCol[6]+aTotCol[7]
	nTotGeral 	+= aTotCol[8]+aTotCol[9]+aTotCol[10]+aTotCol[11]+aTotCol[12]
	
	//oTotGerCusto:Init()
	//oTotGerCusto:lPrintHeader := .F.
	
	//If mv_par26 == 2	//	Se NAO Totaliza Periodo
	//	cText_CCGer := STR0017		//"T O T A I S  D O  P E R I O D O : "
	//Else
	//	cText_CCGer := STR0027		//"TOTAIS  DO  PERIODO: "
	//EndIf
	
	//oReport:PrintText(cText_CCGer, oReport:Row(), 5)
	//oReport:SkipLine()
	//oReport:ThinLine()
	//oTotGerCusto:PrintLine()
	
	//oTotGerCusto:Finish()
	
	nTotGeral	:= 0
	
	oReport:ThinLine()
	
	Set Filter To
	
EndIF

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()
Ferase(cArqTmp+GetDBExtension())
Ferase("cArqInd"+OrdBagExt())
dbselectArea("CT2")

Return



//--------------------------RELEASE 03------------------------------------------------//

#DEFINE 	COL_SEPARA1			1
#DEFINE 	COL_CONTA 			2
#DEFINE 	COL_SEPARA2			3
#DEFINE 	COL_DESCRICAO		4
#DEFINE 	COL_SEPARA3			5
#DEFINE 	COL_COLUNA1       	6
#DEFINE 	COL_SEPARA4			7
#DEFINE 	COL_COLUNA2       	8
#DEFINE 	COL_SEPARA5			9
#DEFINE 	COL_COLUNA3       	10
#DEFINE 	COL_SEPARA6			11
#DEFINE 	COL_COLUNA4   		12
#DEFINE 	COL_SEPARA7			13
#DEFINE 	COL_COLUNA5   		14
#DEFINE 	COL_SEPARA8			15
#DEFINE 	COL_COLUNA6   		16
#DEFINE 	COL_SEPARA9			17
#DEFINE 	COL_COLUNA7			18
#DEFINE 	COL_SEPARA10		19
#DEFINE 	COL_COLUNA8			20
#DEFINE 	COL_SEPARA11		21
#DEFINE 	COL_COLUNA9			22
#DEFINE 	COL_SEPARA12		23
#DEFINE 	COL_COLUNA10		24
#DEFINE 	COL_SEPARA13		25
#DEFINE 	COL_COLUNA11		26
#DEFINE 	COL_SEPARA14		27
#DEFINE 	COL_COLUNA12		28
#DEFINE 	COL_SEPARA15		29

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Ctbr285R3³ Autor ³ Simone Mie Sato   	³ Data ³ 29.04.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Comparativo de C.Custo x Cta  s/ 6 meses. 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Ctbr285R3      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       							  				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ SIGACTB      							  				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum									  				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Cbr285R3()

Local aSetOfBook
Local aCtbMoeda	:= {}
Local cSayCC		:= CtbSayApro("CTT")
Local cDesc1 		:= STR0001			//"Este programa ira imprimir o Balancete Comparativo "
Local cDesc2 		:= Upper(Alltrim(cSayCC)) +" / "+ STR0011	// " Conta "
Local cDesc3 		:= STR0002  //"de acordo com os parametros solicitados pelo Usuario"
Local cNomeArq
LOCAL wnrel
LOCAL cString		:= "CTT"
Local titulo 		:= STR0003+Upper(Alltrim(cSayCC))+" / "+ STR0011 	//"Comparativo de" " Conta "
Local lRet			:= .T.
Local nDivide		:= 1
Local cMensagem		:= ""
Local cMensagem2	:= ""
Local lAtSlComp		:= Iif(GETMV("MV_SLDCOMP") == "S",.T.,.F.)

PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= "CTR285A"
PRIVATE aReturn 	:= { STR0015, 1,STR0016, 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE aLinha		:= {}
PRIVATE nomeProg  	:= "CTBR285R"
PRIVATE Tamanho		:="G"

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

li 		:= 80
m_pag		:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mostra tela de aviso - Atualizacao de saldos				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMensagem := STR0021+chr(13)  		//"Caso nao atualize os saldos compostos na"
cMensagem += STR0022+chr(13)  		//"emissao dos relatorios(MV_SLDCOMP ='N'),"
cMensagem += STR0023+chr(13)  		//"rodar a rotina de atualizacao de saldos "

IF !lAtSlComp
	IF !MsgYesNo(cMensagem,STR0009)	//"ATEN€ŽO"
		Return
	Endif
EndIf

Pergunte("CTR285A",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					       ³
//³ mv_par01				// Data Inicial              	       ³
//³ mv_par02				// Data Final                          ³
//³ mv_par03				// C.C. Inicial         		       ³
//³ mv_par04				// C.C. Final   					   ³
//³ mv_par05				// Conta Inicial                       ³
//³ mv_par06				// Conta Final   					   ³
//³ mv_par07				// Imprime Contas:Sintet/Analit/Ambas  ³
//³ mv_par08				// Set Of Books				    	   ³
//³ mv_par09				// Saldos Zerados?			     	   ³
//³ mv_par10				// Moeda?          			     	   ³
//³ mv_par11				// Pagina Inicial  		     		   ³
//³ mv_par12				// Saldos? Reais / Orcados/Gerenciais  ³
//³ mv_par13				// Imprimir ate o Segmento?			   ³
//³ mv_par14				// Filtra Segmento?					   ³
//³ mv_par15				// Conteudo Inicial Segmento?		   ³
//³ mv_par16				// Conteudo Final Segmento?		       ³
//³ mv_par17				// Conteudo Contido em?				   ³
//³ mv_par18				// Pula Pagina                         ³
//³ mv_par19				// Imprime Cod. C.Custo? Normal/Red.   ³
//³ mv_par20				// Imprime Cod. Conta? Normal/Reduzido ³
//³ mv_par21				// Salta linha sintetica?              ³
//³ mv_par22 				// Imprime Valor 0.00?                 ³
//³ mv_par23 				// Divide por?                         ³
//³ mv_par24				// Posicao Ant. L/P? Sim / Nao         ³
//³ mv_par25				// Data Lucros/Perdas?                 ³
//³ mv_par26				// Totaliza periodo ?                  ³
//³ mv_par27				// Se Totalizar ?                  	   ³
//³ mv_par28				// Imprime C.C?Sintet/Analit/Ambas 	   ³
//³ mv_par29				// Imprime Totalizacao de C.C. Sintet. ³
//³ mv_par30				// Tipo de Comparativo?(Movimento/Acumulado)  ³
//³ mv_par31				// Quebra por Grupo Contabil?		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel	:= "CTBR285R"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,,.F.,"",,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ct040Valid(mv_par08)
	lRet := .F.
Else
	aSetOfBook := CTBSetOf(mv_par08)
Endif

If mv_par23 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par23 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par23 == 4		// Divide por milhao
	nDivide := 1000000
EndIf

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par10,nDivide)
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
		lRet := .F.
	Endif
Endif

If !lRet
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CR285Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,cSayCC,nDivide)})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CR285IMP ³ Autor ³ Simone Mie Sato       ³ Data ³ 29.04.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime relatorio -> Balancete C.Custo/Conta               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CR285Imp(lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,cSayCC)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd 		= Acao do CodeBlock                           ³±±
±±³			 ³ WnRel 		= Titulo do Relatorio				          ³±±
±±³			 ³ cString		= Mensagem						              ³±±
±±³			 ³ aSetOfBook 	= Registro de Config. Livros   		          ³±±
±±³			 ³ aCtbMoeda	= Registro ref. a moeda escolhida             ³±±
±±³			 ³ cSayCC		= Descric.C.Custo utilizado pelo usuario. 	  ³±±
±±³			 ³ nDivide		= Fator de div.dos valores a serem impressos. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CR285Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,cSayCC,nDivide)

Local aColunas		:= {}
Local CbTxt			:= Space(10)
Local CbCont		:= 0
Local limite		:= 220
Local cabec1  		:= ""
Local cabec2		:= ""
Local cPicture
Local cDescMoeda
Local cCodMasc		:= ""
Local cMascara		:= ""
Local cMascCC		:= ""
Local cSepara1		:= ""
Local cSepara2		:= ""
Local cGrupo		:= ""
Local cGrupoAnt	:= ""
Local lFirstPage	:= .T.
Local nDecimais
Local cCustoAnt		:= ""
Local cCCResAnt		:= ""
Local l132			:= .T.
Local lImpConta		:= .F.
Local lImpCusto		:= .T.
Local nTamConta		:= Len(CriaVar("CT1_CONTA"))
Local cCtaIni		:= mv_par05
Local cCtaFim		:= mv_par06
Local nPosAte		:= 0
Local nDigitAte		:= 0
Local cSegAte   	:= mv_par13
Local cArqTmp   	:= ""
Local cCCSup		:= ""//Centro de Custo Superior do centro de custo atual
Local cAntCCSup		:= ""//Centro de Custo Superior do centro de custo anterior

Local lPula			:= Iif(mv_par21==1,.T.,.F.)
Local lPrintZero	:= Iif(mv_par22==1,.T.,.F.)
Local lImpAntLP		:= Iif(mv_par24 == 1,.T.,.F.)
Local lVlrZerado	:= Iif(mv_par09==1,.T.,.F.)
Local dDataLP  		:= mv_par25
Local aMeses		:= {}
Local dDataFim 		:= mv_par02
Local lJaPulou		:= .F.
Local nMeses		:= 1
Local aTotCol		:= {0,0,0,0,0,0,0,0,0,0,0,0}
Local aTotCC		:= {0,0,0,0,0,0,0,0,0,0,0,0}
Local aTotCCSup		:= {}
Local aSupCC		:= {}
Local nTotLinha		:= 0
Local nCont			:= 0
Local aTotGrupo		:= {0,0,0,0,0,0,0,0,0,0,0,0}
Local nTotLinGrp	:= 0

Local lImpSint 		:= Iif(mv_par07 == 2,.F.,.T.)
Local lImpTotS		:= Iif(mv_par29 == 1,.T.,.F.)
Local lImpCCSint	:= .T.
Local lNivel1		:= .F.

Local nPos 			:= 0
Local nDigitos 		:= 0
Local n				:= 0
Local nVezes		:= 0
Local nPosCC		:= 0
Local nTamaTotCC	:= 0
Local nAtuTotCC		:= 0
Local cTpComp		:= If( mv_par30 == 1,"M","S" )	//	Comparativo : "M"ovimento ou "S"aldo Acumulado
Local lImpCabecCC 	:= .F.

cDescMoeda 	:= aCtbMoeda[2]
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par10)

aPeriodos := ctbPeriodos(mv_par10, mv_par01, mv_par02, .T., .F.)

For nCont := 1 to len(aPeriodos)
	//Se a Data do periodo eh maior ou igual a data inicial solicitada no relatorio.
	If aPeriodos[nCont][1] >= mv_par01 .And. aPeriodos[nCont][2] <= mv_par02
		If nMeses <= 12
			AADD(aMeses,{StrZero(nMeses,2),aPeriodos[nCont][1],aPeriodos[nCont][2]})
		EndIf
		nMeses += 1
	EndIf
Next

//Mascara do Centro de Custo
If Empty(aSetOfBook[6])
	cMascCC :=  GetMv("MV_MASCCUS")
Else
	cMascCC := RetMasCtb(aSetOfBook[6],@cSepara1)
EndIf

// Mascara da Conta Contabil
If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
Else
	cMascara := RetMasCtb(aSetOfBook[2],@cSepara2)
EndIf

cPicture 		:= aSetOfBook[4]
cabec1 := STR0004  //"|CODIGO            |DESCRICAO          |  PERIODO 01  |  PERIODO 02  |  PERIODO 03  |  PERIODO 04  |  PERIODO 05  |  PERIODO 06  |  PERIODO 07  |  PERIODO 08  |  PERIODO 09  |  PERIODO 10  |  PERIODO 11  |  PERIODO 12  |
tamanho := "G"
limite	:= 220
l132	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par07 == 1
	Titulo:=	STR0006+ Upper(Alltrim(cSayCC)) + " / "+ STR0011 		//"COMPARATIVO ANALITICO DE  "
ElseIf mv_par07 == 2
	Titulo:=	STR0005 + Upper(Alltrim(cSayCC)) + " / "+ STR0011		//"COMPARATIVO SINTETICO DE  "
ElseIf mv_par07 == 3
	Titulo:=	STR0007 + Upper(Alltrim(cSayCC)) + " / "+ STR0011		//"COMPARATIVO DE  "
EndIf

Titulo += 	STR0008 + DTOC(mv_par01) + STR0009 + Dtoc(mv_par02) + 	STR0010 + cDescMoeda

If mv_par12 > "1"
	Titulo += " (" + Tabela("SL", mv_par12, .F.) + ")"
Endif

If mv_par30 = 2
	mv_par26 := 2
	Titulo := AllTrim(Titulo) + "   " + STR0029
EndIf
aColunas := { 000, 001, 019, 020, 039, 040, 054, 055, 069, 070, 084, 085, 099, 100, 114,  115, 129, 130, 144, 145, 159, 160, 174, 175, 189, 190 , 204, 205, 219}

cabec1 := STR0004  //"|CODIGO            |DESCRICAO          |  PERIODO 01  |  PERIODO 02  |  PERIODO 03  |  PERIODO 04  |  PERIODO 05  |  PERIODO 06  |  PERIODO 07  |  PERIODO 08  |  PERIODO 09  |  PERIODO 10  |  PERIODO 11  |  PERIODO 12  |

If mv_par26 = 1		// Com total, nao imprime descricao
	If mv_par27 = 2
		Cabec1 := Stuff(Cabec1, 2, 10, Subs(Cabec1, 21, 10))
	Endif
	Cabec1 := Stuff(Cabec1, 21, 20, "")
	If mv_par27 == 1
		Cabec1 += " "+STR0028+"     |"	// TOTAL PERIODO
	Else
		Cabec1 += " "+STR0028+"|"	// TOTAL PERIODO
	EndIf
	
	
	For nCont := 6 to (Len(aColunas)-1)
		If mv_par27 == 1 			//Se mostrar conta
			aColunas[nCont] -= 20
		ElseIf mv_par27 == 2		// Se mostrar a descricao
			aColunas[nCont] -= 15
		EndIf
	Next
	
	If mv_par27 = 2
		Cabec1 := Stuff(Cabec1, 19, 0, Space(5))
		cabec2 := "|                       |"
	Else
		cabec2 := "|                  |"
	Endif
Else
	If mv_par20 = 2
		Cabec1 := 	Left(Cabec1, 11) + "|" + Subs(Cabec1, 21, 15) + Space(12) + "|" +;
		Subs(Cabec1, 41)
		Cabec2 := 	"|          |                           |"
	Else
		cabec2 := "|                  |                   |"
	Endif
Endif
For nCont := 1 to Len(aMeses)
	cabec2 += SPACE(1)+Strzero(Day(aMeses[nCont][2]),2)+"/"+Strzero(Month(aMeses[nCont][2]),2)+ "   "
	cabec2 += Strzero(Day(aMeses[nCont][3]),2)+"/"+Strzero(Month(aMeses[nCont][3]),2)+"|"
Next

For nCont:= Len(aMeses) to 12
	If nCont == 12
		//Se totaliza a linha e mostra a conta
		If mv_par26 == 1  .And. mv_par27 == 1
			cabec2+=SPACE(19)+"|"
		Else
			cabec2+=SPACE(14)+"|"
		EndIf
	Else
		cabec2+=SPACE(14)+"|"
	EndIf
Next

m_pag := mv_par11

// Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)
	For n := 1 to Val(cSegAte)
		nDigitAte += Val(Subs(cMascara,n,1))
	Next
EndIf

If !Empty(mv_par14)			//// FILTRA O SEGMENTO Nº
	If Empty(mv_par08)		//// VALIDA SE O CÓDIGO DE CONFIGURAÇÃO DE LIVROS ESTÁ CONFIGURADO
		help("",1,"CTN_CODIGO")
		Return
	Else
		If !Empty(aSetOfBook[5])
			MsgInfo(STR0012+CHR(10)+STR0024,STR0025)
			Return
		Endif
	Endif
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+aSetOfBook[2])
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == aSetOfBook[2]
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == STRZERO(val(mv_par14),2)
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)
				Exit
			EndIf
			dbSkip()
		EndDo
	Else
		help("",1,"CTM_CODIGO")
		Return
	EndIf
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
CTGerComp(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
mv_par01,mv_par02,"CT3","",mv_par05,mv_par06,mv_par03,mv_par04,,,,,mv_par10,;
mv_par12,aSetOfBook,mv_par14,mv_par15,mv_par16,mv_par17,;
.F.,.F.,,"CTT",lImpAntLP,dDataLP,nDivide,cTpComp,.F.,,.T.,aMeses,lVlrZerado,,,lImpSint,cString,aReturn[7],lImpTotS)},;
STR0013,;  //"Criando Arquivo Tempor rio..."
STR0003+Upper(Alltrim(cSayCC)) +" / " +  STR0011 )     //"Balancete Verificacao C.CUSTO / CONTA

If Select("cArqTmp") == 0
	Return
EndIf

If mv_par29 == 1	//Se totaliza centro de custo
	dbSelectArea("cArqTmp")
	dbSetOrder(1)
	dbGotop()
	While!Eof()
		If !Empty(cArqTmp->CCSUP)
			dbSelectArea("CTT")
			dbSetOrder(1)
			If MsSeek(xFilial()+cArqTmp->CCSUP)
				If Empty(CTT->CTT_CCSUP)
					lNivel1	:= .T.
				Else
					lNivel1	:= .F.
				EndIf
			EndIf
			
			dbSelectArea("cArqTmp")
			//			If (( mv_par28 == 2 .And. TIPOCC == "2" ) .Or. (mv_par28 == 1 .And. TIPOCC == "1" .And. Empty(CCSUP)) .Or. (mv_par28 == 3 ) .Or. lNivel1) .And.;
			If (( mv_par28 == 2 .And. TIPOCC == "2" ) .Or. (mv_par28 == 1 .And. TIPOCC == "1" ) .Or. (mv_par28 == 3 ) .Or. lNivel1) .And.;
				(( mv_par07 == 2 .And. TIPOCONTA == "2" ) .Or. (mv_par07 <> 2 .And. TIPOCONTA == "1" .And. Empty(CTASUP)))
				
				
				nPosCC	:= ASCAN(aTotCCSup,{|x| x[1]==CCSUP})
				If  nPosCC <= 0
					aSupCC := {}
					For nVezes := 1 to Len(aMeses)
						aAdd(aSupCC,&("COLUNA"+Alltrim(Str(nVezes,2))))
					Next
					If Len(aMeses) < 12
						For nVezes := Len(aMeses)+1 to 12
							aAdd(aSupCC,0)
						Next
					EndIf
					AADD(aTotCCSup,{CCSUP,aSupCC})
				Else
					For nVezes := 1 to Len(aMeses)
						aTotCCSup[nPosCC][2][nVezes]	+= 	&("COLUNA"+Alltrim(Str(nVezes,2)))
					Next
				EndIf
			EndIf
		EndIf
		dbSkip()
	End
EndIf

dbSelectArea("cArqTmp")
dbSetOrder(1)
dbGoTop()

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial
//nao esta disponivel e sai da rotina.
If RecCount() == 0 .And. !Empty(aSetOfBook[5])
	dbCloseArea()
	FErase(cArqTmp+GetDBExtension())
	FErase("cArqInd"+OrdBagExt())
	Return
Endif

SetRegua(RecCount())

cGrupo := GRUPO
While !Eof()
	
	If lEnd
		@Prow()+1,0 PSAY STR0016   //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF
	
	IncRegua()
	
	******************** "FILTRAGEM" PARA IMPRESSAO *************************
	
	
	If mv_par28 == 1					// So imprime Sinteticas
		If TIPOCC == "2"
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par28 == 2				// So imprime Analiticas
		If TIPOCC == "1"
			dbSkip()
			Loop
		EndIf
	EndIf
	
	If mv_par07 == 1					// So imprime Sinteticas
		If TIPOCONTA == "2"
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par07 == 2				// So imprime Analiticas
		If TIPOCONTA == "1"
			dbSkip()
			Loop
		EndIf
	EndIf
	
	//Filtragem ate o Segmento ( antigo nivel do SIGACON)
	If !Empty(cSegAte)
		If Len(Alltrim(CONTA)) > nDigitAte
			dbSkip()
			Loop
		Endif
	EndIf
	
	If lVlrZerado	.And. ;
		(Abs(COLUNA1)+Abs(COLUNA2)+Abs(COLUNA3)+Abs(COLUNA4)+Abs(COLUNA5)+Abs(COLUNA6)+Abs(COLUNA7)+Abs(COLUNA8)+;
		Abs(COLUNA9)+Abs(COLUNA10)+Abs(COLUNA11)+Abs(COLUNA12)) == 0
		If CtbExDtFim("CTT")
			dbSelectArea("CTT")
			dbSetOrder(1)
			If MsSeek(xFilial()+ cArqTmp->CUSTO)
				If !CtbVlDtFim("CTT",mv_par01)
					dbSelectArea("cArqTmp")
					dbSkip()
					Loop
				EndIf
			EndIf
		EndIf
		
		If CtbExDtFim("CT1")
			dbSelectArea("CT1")
			dbSetOrder(1)
			If MsSeek(xFilial()+ cArqTmp->CONTA)
				If !CtbVlDtFim("CT1",mv_par01)
					dbSelectArea("cArqTmp")
					dbSkip()
					Loop
				EndIf
			EndIf
		EndIf
		dbSelectArea("cArqTmp")
	EndIf
	
	//Caso faca filtragem por segmento de Conta,verifico se esta dentro
	//da solicitacao feita pelo usuario.
	If !Empty(mv_par14)
		If Empty(mv_par15) .And. Empty(mv_par16) .And. !Empty(mv_par17)
			If  !(Substr(cArqTMP->CONTA,nPos,nDigitos) $ (mv_par17) )
				dbSkip()
				Loop
			EndIf
		Else
			If Substr(cArqTMP->CONTA,nPos,nDigitos) < Alltrim(mv_par15) .Or. Substr(cArqTMP->CONTA,nPos,nDigitos) > Alltrim(mv_par16)
				dbSkip()
				Loop
			EndIf
		Endif
	EndIf
	
	************************* ROTINA DE IMPRESSAO *************************
	If mv_par31 == 1																	// Quebra por Grupo Contabil
		If (cGrupo <> GRUPO) .Or.;													// Grupo Diferente ou
			((cCustoAnt <> cArqTmp->CUSTO) .And. ! Empty(cCustoAnt))	// Centro de Custo Diferente
			
			@li,00 PSAY REPLICATE("-",limite)
			li+=2
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@li,aColunas[COL_SEPARA1] PSAY "|"
			@li,01 PSAY STR0030 + Left(cGrupo,10) + ")"  		//"GRUPO ("
			@li,aColunas[COL_SEPARA2] PSAY "|"
			
			ValorCTB(aTotGrupo[1],li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA4]		PSAY "|"
			ValorCTB(aTotGrupo[2],li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA5]		PSAY "|"
			ValorCTB(aTotGrupo[3],li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA6]		PSAY "|"
			ValorCTB(aTotGrupo[4],li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA7] PSAY "|"
			ValorCTB(aTotGrupo[5],li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA8] PSAY "|"
			ValorCTB(aTotGrupo[6],li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA9] PSAY "|"
			ValorCTB(aTotGrupo[7],li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA10] PSAY "|"
			ValorCTB(aTotGrupo[8],li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA11] PSAY "|"
			ValorCTB(aTotGrupo[9],li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA12] PSAY "|"
			ValorCTB(aTotGrupo[10],li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA13] PSAY "|"
			ValorCTB(aTotGrupo[11],li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA14] PSAY "|"
			ValorCTB(aTotGrupo[12],li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			If mv_par26 = 1		// Imprime Total
				nTotLinGrp	:= 0
				For nVezes := 1 to Len(aTotGrupo)
					nTotLinGrp	+= aTotGrupo[nVezes]
				Next
				If mv_par27 == 1//Mostrar a conta
					@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
					ValorCTB(nTotLinGrp,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
				ElseIf mv_par27 == 2	//Mostrar a descricao
					@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
					ValorCTB(nTotLinGrp,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
				EndIf
			Endif
			@ li,aColunas[COL_SEPARA15] PSAY "|"
			
			li			:= 60
			cGrupo		:= GRUPO
			aTotGrupo	:= {0,0,0,0,0,0,0,0,0,0,0,0}
		EndIf
	Else
		If (cCustoAnt <> cArqTmp->CUSTO) .And. ! Empty(cCustoAnt)
			@li,00 PSAY	Replicate("-",limite)
			li++
			@li,aColunas[COL_SEPARA1] PSAY "|"
			
			If mv_par26 == 2
				@li,aColunas[COL_CONTA] PSAY STR0018+ Upper(Alltrim(cSayCC))+ " : " //"T O T A I S  D O  "
				If mv_par19 == 2	.And. cArqTmp->TIPOCC == '2'//Se Imprime cod. reduzido do centro de Custo e eh analitico
					EntidadeCTB(cCCResAnt,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
				Else //Se Imprime cod. normal do Centro de Custo
					EntidadeCTB(cCustoAnt,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
				Endif
				@ li,aColunas[COL_SEPARA3] PSAY "|"
			Else
				@li,aColunas[COL_CONTA] PSAY STR0026 //"TOTAIS: "
				If mv_par19 == 2	.And. cArqTmp->TIPOCC == '2'//Se Imprime cod. reduzido do centro de Custo e eh analitico
					@li,9 PSAY Subs(cCCResAnt,1,10)
				Else //Se Imprime cod. normal do Centro de Custo
					@li,9 PSAY Subs(cCustoAnt,1,10)
				Endif
				If mv_par27 == 1
					@li,aColunas[COL_SEPARA2] PSAY "|"
				Else
					@li,aColunas[COL_SEPARA2]+5 PSAY "|"
				EndIf
			EndIf
			
			dbSelectArea("CTT")
			dbSetOrder(1)
			If MsSeek(xFilial()+cArqTmp->CUSTO)
				cCCSup	:= CTT->CTT_CCSUP
			Else
				cCCSup	:= ""
			EndIf
			
			dbSelectArea("CTT")
			dbSetOrder(1)
			If MsSeek(xFilial()+cCustoAnt)
				cAntCCSup	:= CTT->CTT_CCSUP
			Else
				cAntCCSup	:= ""
			EndIf
			dbSelectArea("cArqTmp")
			
			//Total da Linha
			nTotLinha	:= 0     			// Incluso esta linha para impressao dos totais
			For nVezes := 1 to Len(aMeses)	// por periodo em 09/06/2004 por Otacilio
				nTotLinha	+= aTotCC[nVezes]
			Next
			
			ValorCTB(aTotCC[1],li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA4]		PSAY "|"
			ValorCTB(aTotCC[2],li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA5]		PSAY "|"
			ValorCTB(aTotCC[3],li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA6]		PSAY "|"
			ValorCTB(aTotCC[4],li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA7] PSAY "|"
			ValorCTB(aTotCC[5],li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA8] PSAY "|"
			ValorCTB(aTotCC[6],li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA9] PSAY "|"
			ValorCTB(aTotCC[7],li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA10] PSAY "|"
			ValorCTB(aTotCC[8],li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA11] PSAY "|"
			ValorCTB(aTotCC[9],li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA12] PSAY "|"
			ValorCTB(aTotCC[10],li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA13] PSAY "|"
			ValorCTB(aTotCC[11],li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA14] PSAY "|"
			ValorCTB(aTotCC[12],li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			If mv_par26 = 1		// Imprime Total
				If mv_par27 == 1//Mostrar a conta
					@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
					ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
				ElseIf mv_par27 == 2	//Mostrar a descricao
					@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
					ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
				EndIf
			Endif
			@ li,aColunas[COL_SEPARA15] PSAY "|"
			aTotCC 	:= {0,0,0,0,0,0,0,0,0,0,0,0}
			
			If lImpTotS .And. cCCSup <> cAntCCSup .And. !Empty(cAntCCSup) //Se for centro de custo superior diferente
				li++
				@li,aColunas[COL_SEPARA1] PSAY "|"
				If mv_par26 == 2
					@li,aColunas[COL_CONTA] PSAY STR0018+ Upper(Alltrim(cSayCC))+ " : " //"T O T A I S  D O  "
					If mv_par19 == 2	.And. cArqTmp->TIPOCC == '2'//Se Imprime cod. reduzido do centro de Custo e eh analitico
						EntidadeCTB(cCCResAnt,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
					Else //Se Imprime cod. normal do Centro de Custo
						EntidadeCTB(cAntCCSup,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
					Endif
					@ li,aColunas[COL_SEPARA3] PSAY "|"
				Else
					@li,aColunas[COL_CONTA] PSAY STR0026 //"TOTAIS: "
					If mv_par19 == 2	.And. cArqTmp->TIPOCC == '2'//Se Imprime cod. reduzido do centro de Custo e eh analitico
						@li,9 PSAY Subs(cCCResAnt,1,10)
					Else //Se Imprime cod. normal do Centro de Custo
						@li,9 PSAY Subs(cAntCCSup,1,10)
					Endif
					If mv_par27 == 1
						@li,aColunas[COL_SEPARA2] PSAY "|"
					Else
						@li,aColunas[COL_SEPARA2]+5 PSAY "|"
					EndIf
				EndIf
				
				//Total da Linha
				nTotLinha	:= 0     			// Incluso esta linha para impressao dos totais
				
				nPosCC	:= ASCAN(aTotCCSup,{|x| x[1]== cAntCCSup })
				If  nPosCC > 0
					For nVezes := 1 to Len(aMeses)	// por periodo em 09/06/2004 por Otacilio
						nTotLinha	+= aTotCCSup[nPosCC][2][nVezes]
					Next
					
					ValorCTB(aTotCCSup[nPosCC][2][1],li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA4]		PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][2],li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA5]		PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][3],li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA6]		PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][4],li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA7] PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][5],li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA8] PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][6],li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA9] PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][7],li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA10] PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][8],li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA11] PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][9],li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA12] PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][10],li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA13] PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][11],li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA14] PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][12],li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					If mv_par26 = 1		// Imprime Total
						If mv_par27 == 1//Mostrar a conta
							@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
							ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
						ElseIf mv_par27 == 2	//Mostrar a descricao
							@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
							ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
						EndIf
					Endif
					@ li,aColunas[COL_SEPARA15] PSAY "|"
					dbSelectArea("cArqTmp")
					nRegTmp	:= Recno()
					dbSelectArea("CTT")
					lImpCCSint	:= .T.
				EndIf
				While lImpCCSint
					dbSelectArea("CTT")
					If MsSeek(xFilial()+cAntCCSup) .And. !Empty(CTT->CTT_CCSUP)
						cAntCCSup	:= CTT->CTT_CCSUP
						li++
						@li,aColunas[COL_SEPARA1] PSAY "|"
						If mv_par26 == 2
							@li,aColunas[COL_CONTA] PSAY STR0018+ Upper(Alltrim(cSayCC))+ " : " //"T O T A I S  D O  "
							EntidadeCTB(cAntCCSup,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
							@ li,aColunas[COL_SEPARA3] PSAY "|"
						Else
							@li,aColunas[COL_CONTA] PSAY STR0026 //"TOTAIS: "
							@li,9 PSAY Subs(cAntCCSup,1,10)
							
							If mv_par27 == 1
								@li,aColunas[COL_SEPARA2] PSAY "|"
							Else
								@li,aColunas[COL_SEPARA2]+5 PSAY "|"
							EndIf
						EndIf
						dbSelectArea("cArqTmp")
						
						//Total da Linha
						nTotLinha	:= 0     			// Incluso esta linha para impressao dos totais
						nPosCC	:= ASCAN(aTotCCSup,{|x| x[1]== cAntCCSup })
						If  nPosCC > 0
							For nVezes := 1 to Len(aMeses)	// por periodo em 09/06/2004 por Otacilio
								nTotLinha	+= aTotCCSup[nPosCC][2][nVezes]
							Next
							
							ValorCTB(aTotCCSup[nPosCC][2][1],li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
							@ li,aColunas[COL_SEPARA4]		PSAY "|"
							ValorCTB(aTotCCSup[nPosCC][2][2],li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
							@ li,aColunas[COL_SEPARA5]		PSAY "|"
							ValorCTB(aTotCCSup[nPosCC][2][3],li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
							@ li,aColunas[COL_SEPARA6]		PSAY "|"
							ValorCTB(aTotCCSup[nPosCC][2][4],li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
							@ li,aColunas[COL_SEPARA7] PSAY "|"
							ValorCTB(aTotCCSup[nPosCC][2][5],li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
							@ li,aColunas[COL_SEPARA8] PSAY "|"
							ValorCTB(aTotCCSup[nPosCC][2][6],li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
							@ li,aColunas[COL_SEPARA9] PSAY "|"
							ValorCTB(aTotCCSup[nPosCC][2][7],li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
							@ li,aColunas[COL_SEPARA10] PSAY "|"
							ValorCTB(aTotCCSup[nPosCC][2][8],li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
							@ li,aColunas[COL_SEPARA11] PSAY "|"
							ValorCTB(aTotCCSup[nPosCC][2][9],li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
							@ li,aColunas[COL_SEPARA12] PSAY "|"
							ValorCTB(aTotCCSup[nPosCC][2][10],li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
							@ li,aColunas[COL_SEPARA13] PSAY "|"
							ValorCTB(aTotCCSup[nPosCC][2][11],li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
							@ li,aColunas[COL_SEPARA14] PSAY "|"
							ValorCTB(aTotCCSup[nPosCC][2][12],li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
							If mv_par26 = 1		// Imprime Total
								If mv_par27 == 1//Mostrar a conta
									@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
									ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
								ElseIf mv_par27 == 2	//Mostrar a descricao
									@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
									ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
								EndIf
							Endif
							@ li,aColunas[COL_SEPARA15] PSAY "|"
							li++
							lImpCCSint	:= .T.
						EndIF
					Else
						lImpCCSint	:= .F.
					EndIf
				End
				cAntCCSup		:= ""
				cCCSup			:= ""
				dbSelectArea("cArqTmp")
				dbGoto(nRegTmp)
			EndIf
			
		Endif
	EndIf
	
	If mv_par31 == 1												// Quebra por Grupo Contabil
		If cGrupo != GRUPO									// Grupo Diferente
			li	:= 60
		EndIf
	Else
		If mv_par18 == 1 .And. ! Empty(cCustoAnt)
			If cCustoAnt <> cArqTmp->CUSTO //Se o CC atual for diferente do CC anterior
				li 	:= 60
			EndIf
		Endif
	EndIf
	
	If li > 58
		If !lFirstPage
			@ Prow()+1,00 PSAY	Replicate("-",limite)
		EndIf
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		If mv_par31 == 2 .And. mv_par28 == 3 .Or. lFirstPage
			If mv_par18 == 1 .or. lFirstPage
				//Imprime titulo do centro de custo
				li++
				@li,00 PSAY REPLICATE("-",limite)
				li++
				@ li,aColunas[COL_SEPARA1] PSAY "|"
				@ li,aColunas[COL_CONTA]+4 PSAY Upper(cSayCC)
				If mv_par19 == 2 .And. cArqTmp->TIPOCC == '2'//Se Imprime Cod Reduzido do C.Custo e eh analitico
					EntidadeCTB(CCRES,li,aColunas[COL_CONTA]+20,20,.F.,cMascCC,cSepara1)
				Else //Se Imprime Cod. Normal do C.Custo
					EntidadeCTB(CUSTO,li,aColunas[COL_CONTA]+20,20,.F.,cMascCC,cSepara1)
				Endif
				@ li,aColunas[COL_CONTA]+ Len(CriaVar("CTT_DESC01")) PSAY "   " +cArqTMP->DESCCC
				@ li,aColunas[COL_SEPARA15] PSAY "|"
				li++
				@li,00 PSAY REPLICATE("-",limite)
				li++
				lImpCabecCC := .T.
			Endif
		EndIf
		lFirstPage := .F.
	Endif
	
	//Se mudar de centro de custo
	If ! lImpCabecCC
		If	(CUSTO <> cCustoAnt .And. !Empty(cCustoAnt))	.Or.;
			li > 58														.Or.;
			(mv_par18 == 1 .And. mv_par31 == 2)				.Or.;
			(mv_par31 == 1 .And. cGrupoAnt <> cArqTmp->GRUPO)
			
			//Imprime titulo do centro de custo
			li++
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@ li,aColunas[COL_SEPARA1] PSAY "|"
			@ li,aColunas[COL_CONTA]+4 PSAY Upper(cSayCC)
			If mv_par19 == 2 .And. cArqTmp->TIPOCC == '2'//Se Imprime Cod Reduzido do C.Custo e eh analitico
				EntidadeCTB(CCRES,li,aColunas[COL_CONTA]+20,20,.F.,cMascCC,cSepara1)
			Else //Se Imprime Cod. Normal do C.Custo
				EntidadeCTB(CUSTO,li,aColunas[COL_CONTA]+20,20,.F.,cMascCC,cSepara1)
			Endif
			@ li,aColunas[COL_CONTA]+ Len(CriaVar("CTT_DESC01")) PSAY "   " +cArqTMP->DESCCC
			@ li,aColunas[COL_SEPARA15] PSAY "|"
			li++
			@li,00 PSAY REPLICATE("-",limite)
			li++
		EndIf
	Else
		lImpCabecCC := .F.
	Endif
	
	//Total da Linha
	nTotLinha	:= COLUNA1+COLUNA2+COLUNA3+COLUNA4+COLUNA5+COLUNA6+COLUNA7+COLUNA8+COLUNA9+COLUNA10+COLUNA11+COLUNA12
	
	@ li,aColunas[COL_SEPARA1] PSAY "|"
	//Se totaliza e mostra a descricao
	If mv_par26 = 1 .And. mv_par27 = 2
		@ li,aColunas[COL_CONTA] PSAY Left(DESCCTA,18)
		@ li,aColunas[COL_SEPARA2]+5 PSAY "|"
	Else
		If mv_par20 == 1       //Codigo Normal
			EntidadeCTB(Subs(CONTA,1,16),li,aColunas[COL_CONTA],16,.F.,cMascara,cSepara2)
		Else //Codigo Reduzido
			EntidadeCTB(CTARES,li,aColunas[COL_CONTA],16,.F.,cMascara,cSepara2)
		Endif
		@ li,aColunas[COL_SEPARA2] PSAY "|"
	Endif
	
	// Se nao totalizar ou se totalizar e mostrar a descricao da conta
	If mv_par26 == 2
		@ li,aColunas[COL_DESCRICAO] PSAY Left(DESCCTA,19)
		@ li,aColunas[COL_SEPARA3] PSAY "|"
	Endif
	ValorCTB(COLUNA1,li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA4]		PSAY "|"
	ValorCTB(COLUNA2,li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5]		PSAY "|"
	ValorCTB(COLUNA3,li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6]		PSAY "|"
	ValorCTB(COLUNA4,li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA7] PSAY "|"
	ValorCTB(COLUNA5,li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	ValorCTB(COLUNA6,li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA9] PSAY "|"
	ValorCTB(COLUNA7,li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA10] PSAY "|"
	ValorCTB(COLUNA8,li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA11] PSAY "|"
	ValorCTB(COLUNA9,li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA12] PSAY "|"
	ValorCTB(COLUNA10,li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA13] PSAY "|"
	ValorCTB(COLUNA11,li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA14] PSAY "|"
	ValorCTB(COLUNA12,li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	If mv_par26 == 1
		If mv_par27 == 1
			@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
			ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
		ElseIf mv_par27 == 2	//Mostrar a descricao
			@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
			ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
		EndIf
	EndIf
	@ li,aColunas[COL_SEPARA15] PSAY "|"
	lJaPulou := .F.
	If lPula .And. TIPOCONTA == "1"				// Pula linha entre sinteticas
		li++
		@ li,aColunas[COL_SEPARA1] PSAY "|"
		//Se totaliza e mostra a descricao da conta
		If mv_par26 == 1 .And. mv_par27 == 2
			@ li,aColunas[COL_SEPARA2]+5 PSAY "|"
		Else
			@ li,aColunas[COL_SEPARA2] PSAY "|"
		EndIf
		//Se nao totaliza periodo
		If mv_par26 == 2
			@ li,aColunas[COL_SEPARA3] PSAY "|"
		EndIf
		@ li,aColunas[COL_SEPARA4] PSAY "|"
		@ li,aColunas[COL_SEPARA5] PSAY "|"
		@ li,aColunas[COL_SEPARA6] PSAY "|"
		@ li,aColunas[COL_SEPARA7] PSAY "|"
		@ li,aColunas[COL_SEPARA8] PSAY "|"
		@ li,aColunas[COL_SEPARA9] PSAY "|"
		@ li,aColunas[COL_SEPARA10] PSAY "|"
		@ li,aColunas[COL_SEPARA11] PSAY "|"
		@ li,aColunas[COL_SEPARA12] PSAY "|"
		@ li,aColunas[COL_SEPARA13] PSAY "|"
		@ li,aColunas[COL_SEPARA14] PSAY "|"
		If mv_par26 == 1
			If mv_par27 == 1
				@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
			Else
				@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
			Endif
		EndIf
		@ li,aColunas[COL_SEPARA15] PSAY "|"
		li++
		lJaPulou := .T.
	Else
		li++
	EndIf
	
	************************* FIM   DA  IMPRESSAO *************************
	
	If mv_par07 != 1					// Imprime Analiticas ou Ambas
		If TIPOCONTA == "2"
			If (mv_par28 != 1 .And. TIPOCC == "2")
				For nVezes := 1 to Len(aMeses)
					aTotCol[nVezes] 	+=&("COLUNA"+Alltrim(Str(nVezes,2)))
					aTotGrupo[nVezes] 	+=&("COLUNA"+Alltrim(Str(nVezes,2)))
				Next
			ElseIf (mv_par28 == 1 .And. cArqTmp->TIPOCC != "2"	)	//Imprime centro de custo sintetico
				If mv_par07 == 2 	//Imprime contas analiticas
					For nVezes := 1 to Len(aMeses)
						If Empty(CCSUP)
							aTotCol[nVezes] 	+=&("COLUNA"+Alltrim(Str(nVezes,2)))
							aTotGrupo[nVezes] 	+=&("COLUNA"+Alltrim(Str(nVezes,2)))
						EndIf
					Next
				ElseIf mv_par07 == 3	//Imprime contas sinteticas e analiticas
					If Empty(CCSUP)      //Somar somente o centro de custo sintetico
						For nVezes := 1 to Len(aMeses)
							aTotCol[nVezes] 	+=&("COLUNA"+Alltrim(Str(nVezes,2)))
							aTotGrupo[nVezes] 	+=&("COLUNA"+Alltrim(Str(nVezes,2)))
						Next
					EndIf
				EndIf
			EndIf
			For nVezes := 1 to Len(aMeses)
				aTotCC[nVezes] 		+=&("COLUNA"+Alltrim(Str(nVezes,2)))
			Next
		Endif
	Else
		If (TIPOCONTA == "1" .And. Empty(CTASUP))
			If (mv_par28 != 1 .And. cArqTmp->TIPOCC == "2")
				For nVezes := 1 to Len(aMeses)
					aTotCol[nVezes] 	+=&("COLUNA"+Alltrim(Str(nVezes,2)))
					aTotGrupo[nVezes] 	+=&("COLUNA"+Alltrim(Str(nVezes,2)))
				Next
			ElseIf (mv_par28 == 1 .And. cArqTmp->TIPOCC != "2"	)
				If Empty(CCSUP)
					For nVezes := 1 to Len(aMeses)
						aTotCol[nVezes] 	+=&("COLUNA"+Alltrim(Str(nVezes,2)))
						aTotGrupo[nVezes] 	+=&("COLUNA"+Alltrim(Str(nVezes,2)))
					Next
				EndIf
			EndIf
			For nVezes := 1 to Len(aMeses)
				aTotCC[nVezes] 		+=&("COLUNA"+Alltrim(Str(nVezes,2)))
			Next
		EndIf
	Endif
	
	cCustoAnt := cArqTmp->CUSTO
	cCCResAnt := cArqTmp->CCRES
	cGrupoAnt := cArqTmp->GRUPO
	
	
	dbSelectarea("cArqTmp")
	dbSkip()
	
	If lPula .And. TIPOCONTA == "1" 			// Pula linha entre sinteticas
		If !lJaPulou
			@ li,aColunas[COL_SEPARA1] PSAY "|"
			//Se totaliza e mostra a descricao da conta
			If mv_par26 == 1 .And. mv_par27 == 2
				@ li,aColunas[COL_SEPARA2]+5 PSAY "|"
			Else
				@ li,aColunas[COL_SEPARA2] PSAY "|"
			EndIf
			//Se nao totaliza periodo
			If mv_par26 == 2
				@ li,aColunas[COL_SEPARA3] PSAY "|"
			EndIf
			@ li,aColunas[COL_SEPARA4] PSAY "|"
			@ li,aColunas[COL_SEPARA5] PSAY "|"
			@ li,aColunas[COL_SEPARA6] PSAY "|"
			@ li,aColunas[COL_SEPARA7] PSAY "|"
			@ li,aColunas[COL_SEPARA8] PSAY "|"
			@ li,aColunas[COL_SEPARA9] PSAY "|"
			@ li,aColunas[COL_SEPARA10] PSAY "|"
			@ li,aColunas[COL_SEPARA11] PSAY "|"
			@ li,aColunas[COL_SEPARA12] PSAY "|"
			@ li,aColunas[COL_SEPARA13] PSAY "|"
			@ li,aColunas[COL_SEPARA14] PSAY "|"
			//Se totaliza linha
			If mv_par26 == 1
				If mv_par27 == 1
					@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
				Else
					@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
				EndIf
			EndIf
			
			@ li,aColunas[COL_SEPARA15] PSAY "|"
			li++
		EndIf
	EndIf
EndDO

If mv_par31 == 1				// Quebra por Grupo Contabil
	If cGrupo <> GRUPO			// Grupo Diferente - Totaliza e Quebra
		@li,00 PSAY REPLICATE("-",limite)
		li+=2
		@li,00 PSAY REPLICATE("-",limite)
		li++
		@li,aColunas[COL_SEPARA1] PSAY "|"
		@li,01 PSAY STR0030 + Left(cGrupo,10) + ")"  		//"GRUPO ("
		@li,aColunas[COL_SEPARA2] PSAY "|"
		
		ValorCTB(aTotGrupo[1],li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA4]		PSAY "|"
		ValorCTB(aTotGrupo[2],li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA5]		PSAY "|"
		ValorCTB(aTotGrupo[3],li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA6]		PSAY "|"
		ValorCTB(aTotGrupo[4],li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA7] PSAY "|"
		ValorCTB(aTotGrupo[5],li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA8] PSAY "|"
		ValorCTB(aTotGrupo[6],li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA9] PSAY "|"
		ValorCTB(aTotGrupo[7],li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA10] PSAY "|"
		ValorCTB(aTotGrupo[8],li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA11] PSAY "|"
		ValorCTB(aTotGrupo[9],li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA12] PSAY "|"
		ValorCTB(aTotGrupo[10],li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA13] PSAY "|"
		ValorCTB(aTotGrupo[11],li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA14] PSAY "|"
		ValorCTB(aTotGrupo[12],li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		If mv_par26 = 1		// Imprime Total
			nTotLinGrp	:= 0
			For nVezes := 1 to Len(aTotGrupo)
				nTotLinGrp	+= aTotGrupo[nVezes]
			Next
			If mv_par27 == 1//Mostrar a conta
				@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
				ValorCTB(nTotLinGrp,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
			ElseIf mv_par27 == 2	//Mostrar a descricao
				@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
				ValorCTB(nTotLinGrp,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
			EndIf
		Endif
		@ li,aColunas[COL_SEPARA15] PSAY "|"
		li++
		
		cGrupo		:= GRUPO
		aTotGrupo	:= {0,0,0,0,0,0,0,0,0,0,0,0}
	EndIf
Else
	
	If li > 50
		If !lFirstPage
			@ Prow()+1,00 PSAY	Replicate("-",limite)
		EndIf
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
	Endif
	
	//Imprime o total do ultimo Conta a ser impresso.
	@li,00 PSAY	Replicate("-",limite)
	li++
	@li,aColunas[COL_SEPARA1] PSAY "|"
	
	dbSelectArea("CTT")
	dbSetOrder(1)
	If MsSeek(xFilial("CTT")+cArqTmp->CUSTO)
		cCCSup	:= CTT->CTT_CCSUP	//Centro de Custo Superior
	Else
		cCCSup	:= ""
	EndIf
	
	If MsSeek(xFilial("CTT")+cCustoAnt)
		cAntCCSup := CTT->CTT_CCSUP	//Centro de Custo Superior do Centro de custo anterior.
		cCCRes	  := CTT->CTT_RES
	Else
		cAntCCSup := ""
	EndIf
	
	dbSelectArea("cArqTmp")
	
	If mv_par26 == 2
		@li,aColunas[COL_CONTA] PSAY STR0018+ Upper(cSayCC)+ " : " //"T O T A I S  D O  "
		If mv_par19 == 2	.And. cArqTmp->TIPOCC == '2'//Se Imprime cod. reduzido do centro de Custo e eh analitico
			EntidadeCTB(cCCResAnt,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
		Else //Se Imprime cod. normal do Centro de Custo
			EntidadeCTB(cCustoAnt,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
		Endif
		@ li,aColunas[COL_SEPARA3] PSAY "|"
	Else
		@li,aColunas[COL_CONTA] PSAY STR0026 //"TOTAIS: "
		If mv_par27 == 1
			If mv_par19 == 2	.And. cArqTmp->TIPOCC == '2'//Se Imprime cod. reduzido do centro de Custo e eh analitico
				@li,9 PSAY Subs(cCCResAnt,1,10)
			Else //Se Imprime cod. normal do Centro de Custo
				@li,9 PSAY Subs(cCustoAnt,1,10)
			Endif
			@ li,aColunas[COL_SEPARA2] PSAY "|"
		Else
			@ li,aColunas[COL_SEPARA2]+5 PSAY "|"
		EndIf
	EndIf
	
	ValorCTB(aTotCC[1],li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA4]		PSAY "|"
	ValorCTB(aTotCC[2],li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5]		PSAY "|"
	ValorCTB(aTotCC[3],li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6]		PSAY "|"
	ValorCTB(aTotCC[4],li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA7] PSAY "|"
	ValorCTB(aTotCC[5],li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	ValorCTB(aTotCC[6],li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA9] PSAY "|"
	ValorCTB(aTotCC[7],li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA10] PSAY "|"
	ValorCTB(aTotCC[8],li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA11] PSAY "|"
	ValorCTB(aTotCC[9],li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA12] PSAY "|"
	ValorCTB(aTotCC[10],li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA13] PSAY "|"
	ValorCTB(aTotCC[11],li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA14] PSAY "|"
	ValorCTB(aTotCC[12],li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	
	//Total da Linha
	nTotLinha	:= 0
	For nVezes := 1 to Len(aMeses)
		nTotLinha	+= aTotCC[nVezes]
	Next
	
	If mv_par26 == 1
		If mv_par27 == 1	//Mostrar a conta
			@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
			ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
		ElseIf mv_par27 == 2	//Mostrar a descricao
			@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
			ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
		EndIf
	EndIf
	@ li,aColunas[COL_SEPARA15] PSAY "|"
	If (cArqTmp->TIPOCC == "1" .And. !Empty(cArqTmp->CCSUP)) .Or. (cArqTmp->TIPOCC == "2")
		aTotCC 	:= {0,0,0,0,0,0,0,0,0,0,0,0}
	EndIf
	li++
	
	If lImpTotS .And. cCCSup <> cAntCCSup .And. !Empty(cAntCCSup) //Se for centro de custo superior diferente
		
		@li,aColunas[COL_SEPARA1] PSAY "|"
		If mv_par26 == 2
			@li,aColunas[COL_CONTA] PSAY STR0018+ Upper(Alltrim(cSayCC))+ " : " //"T O T A I S  D O  "
			EntidadeCTB(cAntCCSup,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
			@ li,aColunas[COL_SEPARA3] PSAY "|"
		Else
			@li,aColunas[COL_CONTA] PSAY STR0026 //"TOTAIS: "
			@li,9 PSAY Subs(cAntCCSup,1,10)
			
			If mv_par27 == 1
				@li,aColunas[COL_SEPARA2] PSAY "|"
			Else
				@li,aColunas[COL_SEPARA2]+5 PSAY "|"
			EndIf
		EndIf
		
		//Total da Linha
		nTotLinha	:= 0     			// Incluso esta linha para impressao dos totais
		nPosCC	:= ASCAN(aTotCCSup,{|x| x[1]== cAntCCSup })
		If  nPosCC > 0
			For nVezes := 1 to Len(aMeses)	// por periodo em 09/06/2004 por Otacilio
				nTotLinha	+= aTotCCSup[nPosCC][2][nVezes]
			Next
			
			ValorCTB(aTotCCSup[nPosCC][2][1],li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA4]		PSAY "|"
			ValorCTB(aTotCCSup[nPosCC][2][2],li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA5]		PSAY "|"
			ValorCTB(aTotCCSup[nPosCC][2][3],li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA6]		PSAY "|"
			ValorCTB(aTotCCSup[nPosCC][2][4],li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA7] PSAY "|"
			ValorCTB(aTotCCSup[nPosCC][2][5],li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA8] PSAY "|"
			ValorCTB(aTotCCSup[nPosCC][2][6],li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA9] PSAY "|"
			ValorCTB(aTotCCSup[nPosCC][2][7],li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA10] PSAY "|"
			ValorCTB(aTotCCSup[nPosCC][2][8],li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA11] PSAY "|"
			ValorCTB(aTotCCSup[nPosCC][2][9],li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA12] PSAY "|"
			ValorCTB(aTotCCSup[nPosCC][2][10],li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA13] PSAY "|"
			ValorCTB(aTotCCSup[nPosCC][2][11],li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA14] PSAY "|"
			ValorCTB(aTotCCSup[nPosCC][2][12],li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
			If mv_par26 = 1		// Imprime Total
				If mv_par27 == 1//Mostrar a conta
					@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
					ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
				ElseIf mv_par27 == 2	//Mostrar a descricao
					@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
					ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
				EndIf
			Endif
			@ li,aColunas[COL_SEPARA15] PSAY "|"
			li++
			dbSelectArea("CTT")
			lImpCCSint	:= .T.
		EndIf
		
		While lImpCCSint
			dbSelectArea("CTT")
			If MsSeek(xFilial()+cAntCCSup) .And. !Empty(CTT->CTT_CCSUP)
				cAntCCSup	:= CTT->CTT_CCSUP
				@li,aColunas[COL_SEPARA1] PSAY "|"
				If mv_par26 == 2
					@li,aColunas[COL_CONTA] PSAY STR0018+ Upper(Alltrim(cSayCC))+ " : " //"T O T A I S  D O  "
					EntidadeCTB(cAntCCSup,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
					@ li,aColunas[COL_SEPARA3] PSAY "|"
				Else
					@li,aColunas[COL_CONTA] PSAY STR0026 //"TOTAIS: "
					@li,9 PSAY Subs(cAntCCSup,1,10)
					
					If mv_par27 == 1
						@li,aColunas[COL_SEPARA2] PSAY "|"
					Else
						@li,aColunas[COL_SEPARA2]+5 PSAY "|"
					EndIf
				EndIf
				dbSelectArea("cArqTmp")
				
				//Total da Linha
				nTotLinha	:= 0     			// Incluso esta linha para impressao dos totais
				nPosCC	:= ASCAN(aTotCCSup,{|x| x[1]== cAntCCSup })
				If  nPosCC > 0
					For nVezes := 1 to Len(aMeses)	// por periodo em 09/06/2004 por Otacilio
						nTotLinha	+= aTotCCSup[nPosCC][2][nVezes]
					Next
					
					ValorCTB(aTotCCSup[nPosCC][2][1],li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA4]		PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][2],li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA5]		PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][3],li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA6]		PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][4],li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA7] PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][5],li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA8] PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][6],li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA9] PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][7],li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA10] PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][8],li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA11] PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][9],li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA12] PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][10],li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA13] PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][11],li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					@ li,aColunas[COL_SEPARA14] PSAY "|"
					ValorCTB(aTotCCSup[nPosCC][2][12],li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
					If mv_par26 = 1		// Imprime Total
						If mv_par27 == 1//Mostrar a conta
							@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
							ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
						ElseIf mv_par27 == 2	//Mostrar a descricao
							@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
							ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
						EndIf
					Endif
					@ li,aColunas[COL_SEPARA15] PSAY "|"
					li++
					lImpCCSint	:= .T.
				EndIf
			Else
				lImpCCSint	:= .F.
			EndIf
		End
		cAntCCSup		:= ""
		cCCSup			:= ""
		dbSelectArea("cArqTmp")
	EndIf
EndIf

IF li != 80 .And. !lEnd
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,aColunas[COL_SEPARA1] PSAY "|"
	If mv_par26 == 2
		@li,aColunas[COL_CONTA]   PSAY STR0017  		//"T O T A I S  D O  P E R I O D O : "
		@ li,aColunas[COL_SEPARA3]		PSAY "|"
	Else
		@li,aColunas[COL_CONTA]   PSAY STR0027  		//"TOTAIS  DO  PERIODO: "
		If mv_par27 == 1
			@ li,aColunas[COL_SEPARA2]		PSAY "|"
		Else
			@ li,aColunas[COL_SEPARA2]+4   PSAY "|"
		EndIf
	EndIf
	ValorCTB(aTotCol[1],li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA4]		PSAY "|"
	ValorCTB(aTotCol[2],li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5]		PSAY "|"
	ValorCTB(aTotCol[3],li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6]		PSAY "|"
	ValorCTB(aTotCol[4],li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA7] PSAY "|"
	ValorCTB(aTotCol[5],li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	ValorCTB(aTotCol[6],li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA9] PSAY "|"
	ValorCTB(aTotCol[7],li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA10] PSAY "|"
	ValorCTB(aTotCol[8],li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA11] PSAY "|"
	ValorCTB(aTotCol[9],li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA12] PSAY "|"
	ValorCTB(aTotCol[10],li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA13] PSAY "|"
	ValorCTB(aTotCol[11],li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA14] PSAY "|"
	ValorCTB(aTotCol[12],li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	
	//TOTAL GERAL
	nTotGeral	:= aTotCol[1]+aTotCol[2]+aTotCol[3]+aTotCol[4]+aTotCol[5]+aTotCol[6]+aTotCol[7]
	nTotGeral 	+= aTotCol[8]+aTotCol[9]+aTotCol[10]+aTotCol[11]+aTotCol[12]
	
	If mv_par26 = 1		// Imprime Total
		If mv_par27 == 1//Mostrar a conta
			@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
			ValorCTB(nTotGeral,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
		ElseIf mv_par27 == 2	//Mostrar a descricao
			@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
			ValorCTB(nTotGeral,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
		EndIf
	Endif
	
	nTotGeral	:= 0
	@ li,aColunas[COL_SEPARA15] PSAY "|"
	
	li++
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,0 PSAY " "
	roda(cbcont,cbtxt,"M")
	Set Filter To
EndIF

If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()
Ferase(cArqTmp+GetDBExtension())
Ferase("cArqInd"+OrdBagExt())
dbselectArea("CT2")

MS_FLUSH()

