#Include "PROTHEUS.Ch"

#define STR0001  "Este programa ira imprimir o Comparativo de Contas Contabeis."
#define STR0002  "Os valores sao ref. a movimentacao do periodo solicitado. "
#define STR0003  "Comparativo de Contas Contabeis"
#define STR0004  "|CODIGO            |DESCRICAO          |  PERIODO 01  |  PERIODO 02  |  PERIODO 03  |  PERIODO 04  |  PERIODO 05  |  PERIODO 06  |  PERIODO 07  |  PERIODO 08  |  PERIODO 09  |  PERIODO 10  |  PERIODO 11  |  PERIODO 12  |"
#define STR0005  "COMPARATIVO ANALITICO DE "
#define STR0006  " ATE "
#define STR0007  " EM "
#define STR0008  "COMPARATIVO SINTETICO DE "
#define STR0009  " ATENCAO "
#define STR0010  "***** CANCELADO PELO OPERADOR *****"
#define STR0011  "T O T A I S  D O  P E R I O D O: "
#define STR0012  "COMPARATIVO DE "
#define STR0013  "Zebrado"
#define STR0014  "Administracao"
#define STR0015  "Criando Arquivo Temporario..."
#define STR0016  "T O T A I S  D O  G R U P O("
#define STR0017  "Caso nao atualize os saldos  basicos  na"
#define STR0018  "digitacao dos lancamentos (MV_ATUSAL='N'),"
#define STR0019  "rodar a rotina de atualizacao de saldos "
#define STR0020  "para todos os periodos solicitados nesse "
#define STR0021  "relatorio."
#define STR0022  "Por favor, verifique se o calend.contabil e a amarracao moeda/calendario "
#define STR0023  "foram cadastrados corretamente..."
#define STR0024  "TOTAL DO PERIODO: "
#define STR0025  "TOTAL DO GRUPO ("
#define STR0026  "ACUMULADO"
#define STR0027  "  ATE"
#define STR0028  " TOTAL PERIODO "
#define STR0029  "Conta Contábil"
#define STR0030  "CODIGO"
#define STR0031  "DESCRICAO"

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

//Tradução PTG


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Ctbr265	³ Autor ³ Simone Mie Sato   	³ Data ³ 30.10.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Comparativo de Movim. de Contas x 12 Colunas	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctbr265()                               			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso    	 ³ Generico     											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MACtbr265()

Private Titulo		:= ""
Private NomeProg	:= "MACTBR265"

If FindFunction("TRepInUse") .And. TRepInUse() 
	MACTBR265R4()
Else
	//CTBR265R3()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³MACTBR266R4³ Autor³ CLAUDIO SERVULO  		³ Data ³ 17/06/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Comparativo de Movim. de Contas x 12 Colunas - R4³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBR266R4												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ ESPECIFICO MIDORI                          				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MACTBR265R4() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := ReportDef()      

If !Empty( oReport:uParam )
	Pergunte( oReport:uParam, .F. )
EndIf	

oReport :PrintDialog()      
Return                                

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Daniel Sakavicius		³ Data ³ 04/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Esta funcao tem como objetivo definir as secoes, celulas,   ³±±
±±³          ³totalizadores do relatorio que poderao ser configurados     ³±±
±±³          ³pelo relatorio.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
Local cREPORT		:= "CTBR265"
Local cTITULO		:= Capital(STR0003)							//	"Comparativo de Contas Contabeis"
Local cDESC			:= OemToAnsi(STR0001)+OemtoAnsi(STR0002)	//	"Este programa ira imprimir o Comparativo de Contas Contabeis."
                                                                //	"Os valores sao ref. a movimentacao do periodo solicitado. "
Local cPerg	   		:= "CTR265"
Local aTamConta		:= {20}	//	TAMSX3("CT1_CONTA")
Local aTamDesc		:= {20}
Local aTamVal		:= {12}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport	:= TReport():New( cReport,cTITULO,cPERG, { |oReport| ReportPrint( oReport ) }, cDESC )
oReport:SetLandScape(.T.)

// Define o tamanho da fonte a ser impressa no relatorio
oReport:nFontBody := 4
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
oSection1  := TRSection():New( oReport, STR0029, {"cArqTmp","CT1"},, .F., .F. )        
TRCell():New( oSection1, "CONTA"   , ,STR0030/*Titulo*/,/*Picture*/,aTamConta[1]/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection1, "DESCCTA" , ,STR0031/*Titulo*/,/*Picture*/,aTamDesc[1] /*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection1, "COLUNA1" , ,       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNA2" , ,       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNA3" , ,       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNA4" , ,       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNA5" , ,       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNA6" , ,       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNA7" , ,       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNA8" , ,       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNA9" , ,       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNA10", ,       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNA11", ,       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNA12", ,       /*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection1, "COLUNAT" , ,STR0028/*Titulo*/,/*Picture*/,aTamVal[1]+2/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")

oSection1:SetTotalInLine(.F.)          
oSection1:SetTotalText(STR0011)	//	"T O T A I S  D O  P E R I O D O: "

Return(oReport)     

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³ Daniel Sakavicius	³ Data ³ 02/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime o relatorio definido pelo usuario de acordo com as  ³±±
±±³          ³secoes/celulas criadas na funcao ReportDef definida acima.  ³±±
±±³          ³Nesta funcao deve ser criada a query das secoes se SQL ou   ³±±
±±³          ³definido o relacionamento e filtros das tabelas em CodeBase.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportPrint(oReport)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³EXPO1: Objeto do relatório                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport )

Local oSection1 	:= oReport:Section(1)

Local oTotCol1, oTotCol2, oTotCol3, oTotCol4 , oTotCol5 , oTotCol6 ,;
      oTotCol7, oTotCol8, oTotCol9, oTotCol10, oTotCol11, oTotCol12,;
      oTotColTot

Local oTotGrp1,	oTotGrp2, oTotGrp3, oTotGrp4 , oTotGrp5 , oTotGrp6 ,;
      oTotGrp7,	oTotGrp8, oTotGrp9, oTotGrp10, oTotGrp11, oTotGrp12,;
      oTotGrpTot, oBreakGrp

Local aCtbMoeda		:= {}
Local cSeparador	:= ""
Local cPicture
Local cDescMoeda
Local nDivide		:= 1
Local cString		:= "CT1"

Local cCodMasc		:= ""
Local cGrupo		:= ""
Local cArqTmp
Local dDataFim 		:= mv_par02

Local lFirstPage	:= .T.
Local lJaPulou		:= .F.
Local lQbGrupo		:= Iif(mv_par11==1,.T.,.F.)
Local lPrintZero	:= Iif(mv_par17==1,.T.,.F.)
Local lPula			:= Iif(mv_par16==1,.T.,.F.) 
Local lNormal		:= Iif(mv_par18==1,.T.,.F.)
Local nDecimais

Local cSegmento		:= mv_par12
Local cSegIni		:= mv_par13
Local cSegFim		:= mv_par14
Local cFiltSegm		:= mv_par15
Local cSegAte   	:= mv_par20
Local nDigitAte		:= 0

Local lImpAntLP		:= Iif(mv_par21 == 1,.T.,.F.)
Local dDataLP		:= mv_par22
Local nMeses		:= 1
Local nCont			:= 0
Local nDigitos		:= 0
Local nVezes		:= 0
Local nPos			:= 0 
Local lVlrZerado	:= Iif(mv_par07 == 1,.T.,.F.)
Local lImpSint		:= Iif(mv_par05 = 2,.F.,.T.)
Local cHeader 		:= ""
Local cTpComp		:= If( mv_par25 == 1,"M","S" )	//	Comparativo : "M"ovimento ou "S"aldo Acumulado
Local lAtSlBase		:= Iif(GETMV("MV_ATUSAL")== "S",.T.,.F.)
Local cFilter		:= ""
Local cTipoAnt		:= ""
Local cFilUser		:= ""
Local cDifZero		:= ""
Local cEspaco
Local bCond

Local aTamConta		:= {20}	//	TAMSX3("CT1_CONTA")
Local aTamDesc		:= {20}
Local aTamVal		:= {12}
Local aMeses		:= {}          
Local aPeriodos
Private  aMes265r :={'JANEIRO  ','FEVEREIRO','MARCO    ', 'ABRIL    ','MAIO     ', 'JUNHO    ','JULHO    ', 'AGOSTO   ','SETEMBRO ','OUTUBRO  ','NOVEMBRO ','DEZEMBRO '}
Private  ano265r := str(year(ddatabase),4)

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mostra tela de aviso - processar exclusivo					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMensagem := STR0017+chr(13)  		//"Caso nao atualize os saldos  basicos  na"
cMensagem += STR0018+chr(13)  		//"digitacao dos lancamentos (MV_ATUSAL='N'),"
cMensagem += STR0019+chr(13)  		//"rodar a rotina de atualizacao de saldos "
cMensagem += STR0020+chr(13)  		//"para todas as filiais solicitadas nesse "
cMensagem += STR0021+chr(13)  		//"relatorio."

IF !lAtSlBase
	IF !MsgYesNo(cMensagem,STR0009)	//"ATEN€ŽO"
		Return
	Endif
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ct040Valid(mv_par06)
	Return
Else
   aSetOfBook := CTBSetOf(mv_par06)
Endif

If mv_par19 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par19 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par19 == 4		// Divide por milhao
	nDivide := 1000000
EndIf	

aCtbMoeda  	:= CtbMoeda(mv_par08,nDivide)
If Empty(aCtbMoeda[1])                       
   Help(" ",1,"NOMOEDA")
   Return
Endif

cDescMoeda 	:= Alltrim(aCtbMoeda[2])

If !Empty(aCtbMoeda[6])
	cDescMoeda += STR0007 + aCtbMoeda[6]			// Indica o divisor
EndIf	

nDecimais := DecimalCTB(aSetOfBook,mv_par08)
cPicture  := AllTrim( Right(AllTrim(aSetOfBook[4]),12) )

aPeriodos := ctbPeriodos(mv_par08, mv_par01, mv_par02, .T., .F.)

For nCont := 1 to len(aPeriodos)       
	//Se a Data do periodo eh maior ou igual a data inicial solicitada no relatorio.
	If aPeriodos[nCont][1] >= mv_par01 .And. aPeriodos[nCont][2] <= mv_par02 
		If nMeses <= 12
			AADD(aMeses,{StrZero(nMeses,2),aPeriodos[nCont][1],aPeriodos[nCont][2]})	
			nMeses += 1           					
		EndIf
	EndIf
Next                                                                   

If nMeses == 1
	cMensagem := STR0022	//"Por favor, verifique se o calend.contabil e a amarracao moeda/calendario "
	cMensagem += STR0023	//"foram cadastrados corretamente..."		
	MsgAlert(cMensagem)
	Return
EndIf                                                      

If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
	cCodMasc := ""
Else
	cCodmasc	:= aSetOfBook[2]
	cMascara 	:= RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf     

If !Empty(cSegAte)                
    nDigitAte	:= CtbRelDig(cSegAte,cMascara) 	
EndIf

If !Empty(cSegmento)
	If Empty(mv_par06)
		Help("",1,"CTN_CODIGO")
		Return
	Endif
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+cCodMasc)
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cCodMasc
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == STRZERO(val(cSegmento),2)
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)      
				Exit
			EndIf	
			dbSkip()
		EndDo	
	Else
		Help("",1,"CTM_CODIGO")
		Return
	EndIf	
EndIf	

// Comparar "1-Mov. Periodo" / "2-Saldo Acumulado"
If mv_par25 == 2
	cHeader := "SLD"			/// Indica que deverá obter o saldo na 1ª coluna (Comparativo de Saldo Acumulado)
	mv_par23 := 2				/// NÃO DEVE TOTALIZAR (O ULTIMO PERIODO É A POSICAO FINAL)
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par05 == 1
	Titulo:=	STR0008	//"COMPARATIVO SINTETICO DE "
ElseIf mv_par05 == 2
	Titulo:=	STR0005	//"COMPARATIVO ANALITICO DE "
ElseIf mv_par05 == 3
	Titulo:=	STR0012 //"COMPARATIVO DE "
EndIf

Titulo += 	DTOC(mv_par01) + STR0006 + Dtoc(aMeses[Len(aMeses)][3]) + ;
				STR0007 + cDescMoeda

If mv_par25 == 2
	Titulo += " - "+STR0026
Endif				
If mv_par10 > "1"			
	Titulo += " (" + Tabela("SL", mv_par10, .F.) + ")"
Endif                     

oReport:SetPageNumber( mv_par09 ) // numeração da pagina
oReport:SetCustomText( {|| CtCGCCabTR(,,,,,dDataFim,titulo,,,,,oReport) } )

DbSelectArea("CT1")
cFilUser := oSection1:GetAdvplExp("CT1")

If Empty(cFilUser)
	cFilUser := ".T."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTGerComp(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
				mv_par10,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				.F.,.F.,mv_par11,cHeader,lImpAntLP,dDataLP,nDivide,cTpComp,.F.,,.T.,aMeses,lVlrZerado,,,lImpSint,cString,cFilUser)},;
				STR0015, STR0003)//"Criando Arquivo Tempor rio..."				 	//"Comparativo de Contas Contabeis "

oReport:NoUserFilter()

If Select("cArqTmp") == 0
	Return
EndIf			
				
dbSelectArea("cArqTmp")
dbGoTop()        

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial 
//nao esta disponivel e sai da rotina.
If RecCount() == 0 .And. !Empty(aSetOfBook[5])                                       
	dbCloseArea()
	FErase(cArqTmp+GetDBExtension())
	FErase("cArqInd"+OrdBagExt())
	Return
Endif

oSection1:OnPrintLine( {|| ( IIf( lPula .And. (cTipoAnt == "1" .Or. (cArqTmp->TIPOCONTA == "1" .And. cTipoAnt == "2")), oReport:SkipLine(),NIL),;
								 cTipoAnt := cArqTmp->TIPOCONTA;
							)  })       

cDifZero := " (cArqTmp->COLUNA1  <> 0 .OR. cArqTmp->COLUNA2  <> 0 .OR. cArqTmp->COLUNA3  <> 0 .OR. "
cDifZero += "  cArqTmp->COLUNA4  <> 0 .OR. cArqTmp->COLUNA5  <> 0 .OR. cArqTmp->COLUNA6  <> 0 .OR. "
cDifZero += "  cArqTmp->COLUNA7  <> 0 .OR. cArqTmp->COLUNA8  <> 0 .OR. cArqTmp->COLUNA9  <> 0 .OR. "
cDifZero += "  cArqTmp->COLUNA10 <> 0 .OR. cArqTmp->COLUNA11 <> 0 .OR. cArqTmp->COLUNA12 <> 0)"
							           
If mv_par05 == 1					// So imprime Sinteticas
	cFilter := "cArqTmp->TIPOCONTA  <>  '2'  "
	If !lVlrZerado
		cFilter += " .AND. " + cDifZero
	EndIf
ElseIf mv_par05 == 2				// So imprime Analiticas
	cFilter := "cArqTmp->TIPOCONTA  <>  '1'  "
	If !lVlrZerado
		cFilter += " .AND. " + cDifZero
	EndIf	
EndIf

If !lVlrZerado
	If Empty(cFilter)
		cFilter := cDifZero
	Endif
EndIf

oSection1:SetFilter( cFilter )                                                

For nCont := 1 to Len(aMeses)     
	cColVal := "COLUNA"+Alltrim(Str(nCont))
	cDtCab := Strzero(Day(aMeses[nCont][2]),2)+"/"+Strzero(Month(aMeses[nCont][2]),2)+ " - "
	cDtCab += Strzero(Day(aMeses[nCont][3]),2)+"/"+Strzero(Month(aMeses[nCont][3]),2)	

	oSection1:Cell(cColVal):SetTitle(aMes265r[nCont])	
Next

For nCont:= Len(aMeses)+1 to 12
	cColVal := "COLUNA"+Alltrim(Str(nCont))
	oSection1:Cell(cColVal):SetTitle(aMes265r[nCont])
Next       
                                  
//	23-Imprime coluna "Total Periodo" (totalizando por linha)	( 1-Sim )
//  24-Imprime a descricao da conta								( 2-Nao )

//IF mv_par23 = 2
//	oSection1:Cell("DESCCTA"):SetBlock ( { || (cArqTmp->DESCCTA) })	//	Imprime a Descricao
//	oSection1:Cell("CONTA"  ):SetBlock( {|| IF( cArqTmp->TIPOCONTA == "2" .And. mv_par05 <> 2,	cEspaco:=SPACE(02),	cEspaco:="" ),	/*Fazer um recuo nas contas analíticas em relação à sintética*/;
//		                                    IF( lNormal,	cEspaco + EntidadeCTB(cArqTmp->CONTA,0,0,70,.F.,cMascara,,,,,,.F.),	    /*Se Imprime Codigo Normal da Conta*/;
//	       		                                    			IF( cArqTmp->TIPOCONTA == "1",	AllTrim(cArqTmp->CONTA),	cEspaco + AllTrim(cArqTmp->CTARES) ) ) } )	//Conta Sintética
//ElseIf mv_par23 = 1 .and. MV_PAR24 = 2
//	oSection1:Cell("CONTA"  ):Disable()								//	Desabilita Codigo da Conta
//	oSection1:Cell("DESCCTA"):SetBlock ( { || (cArqTmp->DESCCTA) })	//	Imprime a Descricao	       		                                    			
//Else
//	oSection1:Cell("DESCCTA"):Disable()								//	Desabilita Descricao da Conta
//	oSection1:Cell("CONTA"  ):SetBlock( {|| IF( cArqTmp->TIPOCONTA == "2" .And. mv_par05 <> 2,	cEspaco:=SPACE(02),	cEspaco:="" ),	/*Fazer um recuo nas contas analíticas em relação à sintética*/;
//   		                                    IF( lNormal,	cEspaco + EntidadeCTB(cArqTmp->CONTA,0,0,70,.F.,cMascara,,,,,,.F.),	    /*Se Imprime Codigo Normal da Conta*/;
//       		                                    			IF( cArqTmp->TIPOCONTA == "1",	AllTrim(cArqTmp->CONTA),	cEspaco + AllTrim(cArqTmp->CTARES) ) ) } )	//Conta Sintética
//EndIf


//Imprime o numero da conta e a descricao ...

oSection1:Cell("CONTA"  ):SetBlock( {|| IF( cArqTmp->TIPOCONTA == "2" .And. mv_par05 <> 2,	cEspaco:=SPACE(02),	cEspaco:="" ),	/*Fazer um recuo nas contas analíticas em relação à sintética*/;
   		                                    IF( lNormal,	cEspaco + EntidadeCTB(cArqTmp->CONTA,0,0,70,.F.,cMascara,,,,,,.F.),	    /*Se Imprime Codigo Normal da Conta*/;
       		                                    			IF( cArqTmp->TIPOCONTA == "1",	AllTrim(cArqTmp->CONTA),	cEspaco + AllTrim(cArqTmp->CTARES) ) ) } )	//Conta Sintética

oSection1:Cell("DESCCTA"):SetBlock ( { || (cArqTmp->DESCCTA) })	//	Imprime a Descricao	       		                                    			



oSection1:Cell("COLUNA1"):SetBlock ( { || ValorCTB(cArqTmp->COLUNA1 ,,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) } )
oSection1:Cell("COLUNA2"):SetBlock ( { || ValorCTB(cArqTmp->COLUNA2 ,,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) } )
oSection1:Cell("COLUNA3"):SetBlock ( { || ValorCTB(cArqTmp->COLUNA3 ,,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) } )
oSection1:Cell("COLUNA4"):SetBlock ( { || ValorCTB(cArqTmp->COLUNA4 ,,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) } )
oSection1:Cell("COLUNA5"):SetBlock ( { || ValorCTB(cArqTmp->COLUNA5 ,,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) } )
oSection1:Cell("COLUNA6"):SetBlock ( { || ValorCTB(cArqTmp->COLUNA6 ,,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) } )
oSection1:Cell("COLUNA7"):SetBlock ( { || ValorCTB(cArqTmp->COLUNA7 ,,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) } )
oSection1:Cell("COLUNA8"):SetBlock ( { || ValorCTB(cArqTmp->COLUNA8 ,,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) } )
oSection1:Cell("COLUNA9"):SetBlock ( { || ValorCTB(cArqTmp->COLUNA9 ,,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) } )
oSection1:Cell("COLUNA10"):SetBlock( { || ValorCTB(cArqTmp->COLUNA10,,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) } )
oSection1:Cell("COLUNA11"):SetBlock( { || ValorCTB(cArqTmp->COLUNA11,,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) } )
oSection1:Cell("COLUNA12"):SetBlock( { || ValorCTB(cArqTmp->COLUNA12,,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) } )
           
//	Imprime coluna "Total Periodo" (totalizando por linha)
If mv_par23 == 1
	oSection1:Cell("COLUNAT"):SetBlock( { || ValorCTB(cArqTmp->(COLUNA1+COLUNA2+COLUNA3+;
	                                                            COLUNA4+COLUNA5+COLUNA6+;
	                                                            COLUNA7+COLUNA8+COLUNA9+;
	                                                            COLUNA10+COLUNA11+COLUNA12),,,aTamVal[1],nDecimais,.T.,cPicture,, , , , , ,lPrintZero,.F.) } )
Else
	oSection1:Cell("COLUNAT"):Disable()
Endif


bCond := {|| Iif( cArqTmp->TIPOCONTA="1"/*Conta Sintetica*/, IF( mv_par05 <> 1	/*Analiticas ou ambas*/,;
                                                                 .F.,;
                                                                 IF(cArqTmp->NIVEL1 /*Maior Conta superiora*/,.T.,.F.) ),;
                                                             .T. ) }


// Quebra por Grupo
If lQbGrupo

	//Totais do Grupo
	oBreakGrp := TRBreak():New(oSection1, { || cArqTmp->GRUPO },{|| STR0016+" "+ RTrim( Upper(AllTrim(cGrupo) )) + " )" },,,.F.)	//	"T O T A I S  D O  G R U P O ("
	oBreakGrp:OnBreak( { |x| cGrupo := x } )

	oTotGrp1 := TRFunction():New(oSection1:Cell("COLUNA1"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA1, 0 ) },.F.,.F.,.F.,oSection1)

	oTotGrp2 := TRFunction():New(oSection1:Cell("COLUNA2"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA2, 0 ) },.F.,.F.,.F.,oSection1)

	oTotGrp3 := TRFunction():New(oSection1:Cell("COLUNA3"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA3, 0 ) },.F.,.F.,.F.,oSection1)

	oTotGrp4 := TRFunction():New(oSection1:Cell("COLUNA4"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA4, 0 ) },.F.,.F.,.F.,oSection1)

	oTotGrp5 := TRFunction():New(oSection1:Cell("COLUNA5"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA5, 0 ) },.F.,.F.,.F.,oSection1)

	oTotGrp6 := TRFunction():New(oSection1:Cell("COLUNA6"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA6, 0 ) },.F.,.F.,.F.,oSection1)

	oTotGrp7 := TRFunction():New(oSection1:Cell("COLUNA7"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA7, 0 ) },.F.,.F.,.F.,oSection1)

	oTotGrp8 := TRFunction():New(oSection1:Cell("COLUNA8"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA8, 0 ) },.F.,.F.,.F.,oSection1)

	oTotGrp9 := TRFunction():New(oSection1:Cell("COLUNA9"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA9, 0 ) },.F.,.F.,.F.,oSection1)

	oTotGrp10 := TRFunction():New(oSection1:Cell("COLUNA10"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA10, 0 ) },.F.,.F.,.F.,oSection1)

	oTotGrp11 := TRFunction():New(oSection1:Cell("COLUNA11"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA11, 0 ) },.F.,.F.,.F.,oSection1)

	oTotGrp12 := TRFunction():New(oSection1:Cell("COLUNA12"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->COLUNA12, 0 ) },.F.,.F.,.F.,oSection1)


	TRFunction():New(oSection1:Cell("COLUNA1"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp1:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

	TRFunction():New(oSection1:Cell("COLUNA2"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp2:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

	TRFunction():New(oSection1:Cell("COLUNA3"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp3:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

	TRFunction():New(oSection1:Cell("COLUNA4"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp4:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

	TRFunction():New(oSection1:Cell("COLUNA5"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp5:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

	TRFunction():New(oSection1:Cell("COLUNA6"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp6:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

	TRFunction():New(oSection1:Cell("COLUNA7"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp7:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

	TRFunction():New(oSection1:Cell("COLUNA8"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp8:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

	TRFunction():New(oSection1:Cell("COLUNA9"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp9:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

	TRFunction():New(oSection1:Cell("COLUNA10"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp10:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

	TRFunction():New(oSection1:Cell("COLUNA11"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp11:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

	TRFunction():New(oSection1:Cell("COLUNA12"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrp12:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )


	//	Imprime coluna "Total Periodo" (totalizando por linha)
	If mv_par23 == 1
		oTotGrpTot := TRFunction():New(oSection1:Cell("COLUNAT"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	                             { || If( Eval(bCond), cArqTmp->(COLUNA1+COLUNA2+COLUNA3+COLUNA4+;
                                                                 COLUNA5+COLUNA6+COLUNA7+COLUNA8+;
                                                                 COLUNA9+COLUNA10+COLUNA11+COLUNA12), 0 ) },.F.,.F.,.F.,oSection1)

		TRFunction():New(oSection1:Cell("COLUNAT"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
    	{ || ValorCTB(oTotGrpTot:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

		oTotGrpTot:Disable()
	EndIf

	oTotGrp1:Disable()
	oTotGrp2:Disable()
	oTotGrp3:Disable()
	oTotGrp4:Disable()
	oTotGrp5:Disable()
	oTotGrp6:Disable()
	oTotGrp7:Disable()
	oTotGrp8:Disable()
	oTotGrp9:Disable()
	oTotGrp10:Disable()
	oTotGrp11:Disable()
	oTotGrp12:Disable()
EndIf


// Total
oTotCol1  := TRFunction():New(oSection1:Cell("COLUNA1"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA1, 0 ) },.F.,.T.,.F.,oSection1)
oTotCol2  := TRFunction():New(oSection1:Cell("COLUNA2"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA2, 0 ) },.F.,.T.,.F.,oSection1)
oTotCol3  := TRFunction():New(oSection1:Cell("COLUNA3"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA3, 0 ) },.F.,.T.,.F.,oSection1)
oTotCol4  := TRFunction():New(oSection1:Cell("COLUNA4"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA4, 0 ) },.F.,.T.,.F.,oSection1)
oTotCol5  := TRFunction():New(oSection1:Cell("COLUNA5"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA5, 0 ) },.F.,.T.,.F.,oSection1)
oTotCol6  := TRFunction():New(oSection1:Cell("COLUNA6"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA6, 0 ) },.F.,.T.,.F.,oSection1)
oTotCol7  := TRFunction():New(oSection1:Cell("COLUNA7"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA7, 0 ) },.F.,.T.,.F.,oSection1)
oTotCol8  := TRFunction():New(oSection1:Cell("COLUNA8"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA8, 0 ) },.F.,.T.,.F.,oSection1)
oTotCol9  := TRFunction():New(oSection1:Cell("COLUNA9"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA9, 0 ) },.F.,.T.,.F.,oSection1)
oTotCol10 := TRFunction():New(oSection1:Cell("COLUNA10"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA10, 0 ) },.F.,.T.,.F.,oSection1)
oTotCol11 := TRFunction():New(oSection1:Cell("COLUNA11"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA11, 0 ) },.F.,.T.,.F.,oSection1)
oTotCol12 := TRFunction():New(oSection1:Cell("COLUNA12"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                             { || If( Eval(bCond), cArqTmp->COLUNA12, 0 ) },.F.,.T.,.F.,oSection1)

//	Imprime coluna "Total Periodo" (totalizando por linha)
If mv_par23 == 1
	oTotColTot := TRFunction():New(oSection1:Cell("COLUNAT"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
                                   { || If( Eval(bCond), cArqTmp->(COLUNA1+COLUNA2+COLUNA3+COLUNA4+COLUNA5+COLUNA6+;
                                                                   COLUNA7+COLUNA8+COLUNA9+COLUNA10+COLUNA11+COLUNA12), 0 ) },.F.,.T.,.F.,oSection1)
EndIf
                                                                      
TRFunction():New(oSection1:Cell("COLUNA1"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol1:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("COLUNA2"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol2:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("COLUNA3"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol3:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("COLUNA4"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol4:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("COLUNA5"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol5:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("COLUNA6"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol6:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("COLUNA7"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol7:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("COLUNA8"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol8:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("COLUNA9"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol9:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("COLUNA10"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol10:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("COLUNA11"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol11:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("COLUNA12"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCol12:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )

// Comparar "1-Mov. Periodo" / "2-Saldo Acumulado"
If mv_par23 == 1
	TRFunction():New(oSection1:Cell("COLUNAT"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
    { || ValorCTB(oTotColTot:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) },.F.,.T.,.F.,oSection1 )
EndIf

oTotCol1:Disable()
oTotCol2:Disable()
oTotCol3:Disable()
oTotCol4:Disable()
oTotCol5:Disable()
oTotCol6:Disable()
oTotCol7:Disable()
oTotCol8:Disable()
oTotCol9:Disable()
oTotCol10:Disable()
oTotCol11:Disable()
oTotCol12:Disable()

// Comparar "1-Mov. Periodo" / "2-Saldo Acumulado"
If mv_par23 == 1
	oTotColTot:Disable()
EndIf
                     
oReport:SetTotalInLine(.F.)	
oReport:SetTotalText(STR0011)	//	"T O T A I S  D O  P E R I O D O: "
oSection1:Print()

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea() 
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIF	

Return

/*
-------------------------------------------------------- RELEASE 3 -------------------------------------------------------------
*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Ctbr265R3³ Autor ³ Simone Mie Sato   	³ Data ³ 30.10.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Comparativo de Movim. de Contas x 12 Colunas	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctbr265()                               			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso    	 ³ Generico     											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ctbr265R3()
Local aSetOfBook
Local aCtbMoeda		:= {}
LOCAL cDesc1 		:= STR0001	//"Este programa ira imprimir o Comparativo de Contas Contabeis."
LOCAL cDesc2 		:= STR0002  //" Os valores sao ref. a movimentacao do periodo solicitado. "
Local cDesc3		:= ""
LOCAL wnrel
LOCAL cString		:= "CT1"
Local titulo 		:= STR0003 	//"Comparativo  de Contas Contabeis "
Local lRet			:= .T.
Local nDivide		:= 1
Local lAtSlBase		:= Iif(GETMV("MV_ATUSAL")== "S",.T.,.F.)

PRIVATE Tamanho		:="G"
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= "CTR265"
PRIVATE aReturn 	:= { STR0013, 1,STR0014, 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE aLinha		:= {}
PRIVATE nomeProg  	:= "CTBR265"

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf
li 		:= 80
m_pag	:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mostra tela de aviso - processar exclusivo					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMensagem := STR0017+chr(13)  		//"Caso nao atualize os saldos  basicos  na"
cMensagem += STR0018+chr(13)  		//"digitacao dos lancamentos (MV_ATUSAL='N'),"
cMensagem += STR0019+chr(13)  		//"rodar a rotina de atualizacao de saldos "
cMensagem += STR0020+chr(13)  		//"para todas as filiais solicitadas nesse "
cMensagem += STR0021+chr(13)  		//"relatorio."

IF !lAtSlBase
	IF !MsgYesNo(cMensagem,STR0009)	//"ATEN€ŽO"
		Return
	Endif
EndIf

Pergunte("CTR265",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros								  ³
//³ mv_par01				// Data Inicial                  	  		  ³
//³ mv_par02				// Data Final                        		  ³
//³ mv_par03				// Conta Inicial                         	  ³
//³ mv_par04				// Conta Final  							  ³
//³ mv_par05				// Imprime Contas: Sintet/Analit/Ambas   	  ³
//³ mv_par06				// Set Of Books				    		      ³
//³ mv_par07				// Saldos Zerados?			     		      ³
//³ mv_par08				// Moeda?          			     		      ³
//³ mv_par09				// Pagina Inicial  		     		    	  ³
//³ mv_par10				// Saldos? Reais / Orcados	/Gerenciais   	  ³
//³ mv_par11				// Quebra por Grupo Contabil?		    	  ³
//³ mv_par12				// Filtra Segmento?					    	  ³
//³ mv_par13				// Conteudo Inicial Segmento?		   		  ³
//³ mv_par14				// Conteudo Final Segmento?		    		  ³
//³ mv_par15				// Conteudo Contido em?				    	  ³
//³ mv_par16				// Salta linha sintetica ?			    	  ³
//³ mv_par17				// Imprime valor 0.00    ?			    	  ³
//³ mv_par18				// Imprimir Codigo? Normal / Reduzido  		  ³
//³ mv_par19				// Divide por ?                   			  ³
//³ mv_par20				// Imprimir Ate o segmento?			   		  ³
//³ mv_par21				// Posicao Ant. L/P? Sim / Nao         		  ³
//³ mv_par22				// Data Lucros/Perdas?                 		  ³
//³ mv_par23				// Totaliza periodo ?                  		  ³
//³ mv_par24				// Se Totalizar ?                  		  	  ³
//³ mv_par25				// Tipo de Comparativo?(Movimento/Acumulado)  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel	:= "CTBR265"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ct040Valid(mv_par06)
	lRet := .F.
Else
   aSetOfBook := CTBSetOf(mv_par06)
Endif

If mv_par19 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par19 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par19 == 4		// Divide por milhao
	nDivide := 1000000
EndIf	

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par08,nDivide)
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

RptStatus({|lEnd| CTR265Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,nDivide)})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTR265IMP ³ Autor ³ Simone Mie Sato       ³ Data ³ 30.10.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime relatorio  									      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTR265Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    	  - A‡ao do Codeblock                             ³±±
±±³          ³ WnRel   	  - T¡tulo do relat¢rio                           ³±±
±±³          ³ cString 	  - Mensagem                                      ³±±
±±³          ³ aSetOfBook - Matriz ref. Config. Relatorio                 ³±±
±±³          ³ aCtbMoeda  - Matriz ref. a moeda                           ³±±
±±³          ³ nDivde     - Fator de divisao para impressao dos valores   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTR265Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,nDivide)

Local aColunas		:= {}
LOCAL CbTxt			:= Space(10)
Local CbCont		:= 0
LOCAL limite		:= 220
Local cabec1   		:= ""
Local cabec2   		:= ""
Local cSeparador	:= ""
Local cPicture
Local cDescMoeda
Local cCodMasc		:= ""
Local cMascara
Local cGrupo		:= ""
Local cArqTmp
Local dDataFim 		:= mv_par02
Local lFirstPage	:= .T.
Local lJaPulou		:= .F.
Local lPrintZero	:= Iif(mv_par17==1,.T.,.F.)
Local lPula			:= Iif(mv_par16==1,.T.,.F.) 
Local lNormal		:= Iif(mv_par18==1,.T.,.F.)
Local nDecimais
Local aTotCol		:= {0,0,0,0,0,0,0,0,0,0,0,0}
Local aTotGrp		:= {0,0,0,0,0,0,0,0,0,0,0,0}
Local cSegmento		:= mv_par12
Local cSegAte   	:= mv_par20
Local cSegIni		:= mv_par13
Local cSegFim		:= mv_par14
Local cFiltSegm		:= mv_par15
Local nDigitAte		:= 0
Local lImpAntLP		:= Iif(mv_par21 == 1,.T.,.F.)
Local dDataLP		:= mv_par22
Local aMeses		:= {}          
Local nTotGeral		:= 0
Local aPeriodos
Local nMeses		:= 1
Local nCont			:= 0
Local nDigitos		:= 0
Local nVezes		:= 0
Local nPos			:= 0 
Local lVlrZerado	:= Iif(mv_par07 == 1,.T.,.F.)
Local lImpSint		:= Iif(mv_par05 = 2,.F.,.T.)
Local lSinalMov		:= CtbSinalMov()
Local cHeader 		:= ""
Local cTpComp		:= If( mv_par25 == 1,"M","S" )	//	Comparativo : "M"ovimento ou "S"aldo Acumulado

cDescMoeda 	:= Alltrim(aCtbMoeda[2])

If !Empty(aCtbMoeda[6])
	cDescMoeda += STR0007 + aCtbMoeda[6]			// Indica o divisor
EndIf	

nDecimais := DecimalCTB(aSetOfBook,mv_par08)
cPicture  := AllTrim( Right(AllTrim(aSetOfBook[4]),12) )

aPeriodos := ctbPeriodos(mv_par08, mv_par01, mv_par02, .T., .F.)

For nCont := 1 to len(aPeriodos)       
	//Se a Data do periodo eh maior ou igual a data inicial solicitada no relatorio.
	If aPeriodos[nCont][1] >= mv_par01 .And. aPeriodos[nCont][2] <= mv_par02 
		If nMeses <= 12
			AADD(aMeses,{StrZero(nMeses,2),aPeriodos[nCont][1],aPeriodos[nCont][2]})	
			nMeses += 1           					
		EndIf
	EndIf
Next                                                                   

If nMeses == 1
	cMensagem := STR0022	//"Por favor, verifique se o calend.contabil e a amarracao moeda/calendario "
	cMensagem += STR0023	//"foram cadastrados corretamente..."		
	MsgAlert(cMensagem)
	Return
EndIf                                                      

If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
	cCodMasc := ""
Else
	cCodmasc	:= aSetOfBook[2]
	cMascara 	:= RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par05 == 1
	Titulo:=	STR0008	//"COMPARATIVO SINTETICO DE "
ElseIf mv_par05 == 2
	Titulo:=	STR0005	//"COMPARATIVO ANALITICO DE "
ElseIf mv_par05 == 3
	Titulo:=	STR0012 //"COMPARATIVO DE "
EndIf

Titulo += 	DTOC(mv_par01) + STR0006 + Dtoc(aMeses[Len(aMeses)][3]) + ;
				STR0007 + cDescMoeda

If mv_par25 == 2
	Titulo += " - "+STR0026
Endif				
If mv_par10 > "1"			
	Titulo += " (" + Tabela("SL", mv_par10, .F.) + ")"
Endif                     

aColunas := { 000, 001, 019, 020, 039, 040, 054, 055, 069, 070, 084, 085, 099, 100, 114,  115, 129, 130, 144, 145, 159, 160, 174, 175, 189, 190 , 204, 205, 219} 

cabec1 := STR0004  //"|CODIGO            |DESCRICAO          |  PERIODO 01  |  PERIODO 02  |  PERIODO 03  |  PERIODO 04  |  PERIODO 05  |  PERIODO 06  |  PERIODO 07  |  PERIODO 08  |  PERIODO 09  |  PERIODO 10  |  PERIODO 11  |  PERIODO 12  |

If mv_par25 == 2				/// SE IMPRIME SALDO ACUMULADO
	mv_par23 := 2				/// NÃO DEVE TOTALIZAR (O ULTIMO PERIODO É A POSICAO FINAL)
Endif

If mv_par23 = 1		// Com total, nao imprime descricao
	If mv_par24 = 2
		Cabec1 := Stuff(Cabec1, 2, 10, Subs(Cabec1, 21, 10))
	Endif
	Cabec1 := Stuff(Cabec1, 21, 20, "")
	Cabec1 += " TOTAL PERIODO|"
	For nCont := 6 To Len(aColunas)
		aColunas[nCont] -= 20
	Next	
	For nCont := 3 To Len(aColunas)
		If mv_par24 = 2
			aColunas[nCont] += 5
		Endif
	Next
	If mv_par24 = 2
		Cabec1 := Stuff(Cabec1, 19, 0, Space(5))
		cabec2 := "|                       |"
	Else
		cabec2 := "|                  |"
	Endif
Else
	If mv_par18 = 2
		Cabec1 := 	Left(Cabec1, 11) + "|" + Subs(Cabec1, 21, 15) + Space(12) + "|" +;
					Subs(Cabec1, 41)
		Cabec2 := 	"|          |                           |"
	Else
		cabec2 := "|                  |                   |" 
	Endif
Endif
For nCont := 1 to Len(aMeses)
	If mv_par25 == 2	/// SE FOR ACUMULADO É O SALDO ATE A DATA FINAL
		cabec2 += " "+STR0027+" - "
	Else
		cabec2 += SPACE(1)+Strzero(Day(aMeses[nCont][2]),2)+"/"+Strzero(Month(aMeses[nCont][2]),2)+ " - "	
	Endif
	cabec2 += Strzero(Day(aMeses[nCont][3]),2)+"/"+Strzero(Month(aMeses[nCont][3]),2)+"|"
Next

For nCont:= Len(aMeses)+1 to 12
	cabec2+=SPACE(14)+"|"
Next         

If mv_par23 = 1		// Com total, nao imprime descricao
	Cabec2 += "              |"
Endif
                                                                                                    
If mv_par18 = 2 .And. mv_par23 = 2		// Reduzido
	aColunas[COL_SEPARA2]	:= 11
	aColunas[COL_DESCRICAO]	:= 12
Endif

m_pag := mv_par09

// Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)                
    nDigitAte	:= CtbRelDig(cSegAte,cMascara) 	
EndIf

If !Empty(cSegmento)
	If Empty(mv_par06)
		Help("",1,"CTN_CODIGO")
		Return
	Endif
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+cCodMasc)
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cCodMasc
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == STRZERO(val(cSegmento),2)
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)      
				Exit
			EndIf	
			dbSkip()
		EndDo	
	Else
		Help("",1,"CTM_CODIGO")
		Return
	EndIf	
EndIf	

If mv_par25 == 2
	cHeader := "SLD"			/// Indica que deverá obter o saldo na 1ª coluna (Comparativo de Saldo Acumulado)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTGerComp(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
				mv_par10,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				.F.,.F.,mv_par11,cHeader,lImpAntLP,dDataLP,nDivide,cTpComp,.F.,,.T.,aMeses,lVlrZerado,,,lImpSint,cString,aReturn[7])},;
				STR0015, STR0003)//"Criando Arquivo Tempor rio..."				 	//"Comparativo de Contas Contabeis "

If Select("cArqTmp") == 0
	Return
EndIf			
				
dbSelectArea("cArqTmp")
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
dbSelectArea("cArqTmp")

While !Eof()

	If lEnd
		@Prow()+1,0 PSAY STR0010   //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF

	IncRegua()

	******************** "FILTRAGEM" PARA IMPRESSAO *************************

	If mv_par05 == 1					// So imprime Sinteticas
		If TIPOCONTA == "2"
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par05 == 2				// So imprime Analiticas
		If TIPOCONTA == "1"
			dbSkip()
			Loop
		EndIf
	EndIf

	If (Abs(COLUNA1)+Abs(COLUNA2)+Abs(COLUNA3)+Abs(COLUNA4)+Abs(COLUNA5)+Abs(COLUNA6)+;
	    Abs(COLUNA7)+Abs(COLUNA8)+Abs(COLUNA9)+Abs(COLUNA10)+Abs(COLUNA11)+Abs(COLUNA12)) == 0
		If mv_par07 == 2						// Saldos Zerados nao serao impressos
			dbSkip()
			Loop	
		ElseIf  mv_par07 == 1		//Se imprime saldos zerados, verificar a data de existencia da entidade
			If CtbExDtFim("CT1") 
				dbSelectArea("CT1")
				dbSetOrder(1)
				If MsSeek(xFilial()+cArqTmp->CONTA)
					If !CtbVlDtFim("CT1",mv_par01) 
			     		dbSelectArea("cArqTmp")
			     		dbSkip()
			     		Loop		
					EndIf
				EndIf		
			EndIf
			dbSelectArea("cArqTmp")
		EndIf
	EndIf      	
	
	//Filtragem ate o Segmento ( antigo nivel do SIGACON)		
	If !Empty(cSegAte)
		If Len(Alltrim(CONTA)) > nDigitAte
			dbSkip()
			Loop
		Endif
	EndIf

	If !Empty(cSegmento)
		If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
			If  !(Substr(cArqTmp->CONTA,nPos,nDigitos) $ (cFiltSegm) ) 
				dbSkip()
				Loop
			EndIf	
		Else
			If Substr(cArqTmp->CONTA,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
				Substr(cArqTmp->CONTA,nPos,nDigitos) > Alltrim(cSegFim)
				dbSkip()
				Loop
			EndIf	
		Endif
	EndIf	
	************************* ROTINA DE IMPRESSAO *************************

	If mv_par11 == 1							// Grupo Diferente - Totaliza e Quebra
		If cGrupo != GRUPO
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@li,aColunas[COL_SEPARA1] PSAY "|"
			If mv_par23 <> 1		// Com total, nao imprime descricao
				@li,aColunas[COL_CONTA]  PSAY STR0016 + Alltrim(cGrupo) + "):"  		//"T O T A I S  D O  G R U P O: "
				@li,aColunas[COL_SEPARA3] PSAY "|"
			Else
				@li,aColunas[COL_CONTA]  PSAY STR0025 + Alltrim(cGrupo) + "):"  		//"TOTAIS DO GRUPO: "
				@ li,aColunas[COL_SEPARA4] 		PSAY "|"
    			@ li,aColunas[COL_SEPARA15] + 15 PSAY "|"				
				Li++ 
				@li,aColunas[COL_SEPARA1] PSAY "|"
				@li,aColunas[COL_SEPARA2] PSAY "|"
			Endif
			ValorCTB(aTotGrp[1],li,aColunas[COL_COLUNA1],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA4]		PSAY "|"
			ValorCTB(aTotGrp[2],li,aColunas[COL_COLUNA2],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA5]		PSAY "|"
			ValorCTB(aTotGrp[3],li,aColunas[COL_COLUNA3],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA6]		PSAY "|"
			ValorCTB(aTotGrp[4],li,aColunas[COL_COLUNA4],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA7] PSAY "|"	
			ValorCTB(aTotGrp[5],li,aColunas[COL_COLUNA5],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA8] PSAY "|"
			ValorCTB(aTotGrp[6],li,aColunas[COL_COLUNA6],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA9] PSAY "|"                                                                       
			ValorCTB(aTotGrp[7],li,aColunas[COL_COLUNA7],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA10] PSAY "|"                                                                       
			ValorCTB(aTotGrp[8],li,aColunas[COL_COLUNA8],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA11] PSAY "|"                                                                       
			ValorCTB(aTotGrp[9],li,aColunas[COL_COLUNA9],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA12] PSAY "|"                                                                       
			ValorCTB(aTotGrp[10],li,aColunas[COL_COLUNA10],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA13] PSAY "|"                                                                       
			ValorCTB(aTotGrp[11],li,aColunas[COL_COLUNA11],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA14] PSAY "|"                                                                       
			ValorCTB(aTotGrp[12],li,aColunas[COL_COLUNA12],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA15] PSAY "|"
			If mv_par23 = 1		// Imprime Total
				ValorCTB(	aTotGrp[1] + aTotGrp[2] + aTotGrp[3] + aTotGrp[4] +;
							aTotGrp[5] + aTotGrp[6] + aTotGrp[7] + aTotGrp[8] +;
							aTotGrp[9] + aTotGrp[10] + aTotGrp[11] + aTotGrp[12],li,aColunas[COL_SEPARA15]  + 1,12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA15] + 15 PSAY "|"
			Endif			
			//TOTAL GERAL
			li++
			li			:= 60
			cGrupo		:= GRUPO
			aTotGrp 	:= {0,0,0,0,0,0,0,0,0,0,0,0}
		EndIf		
	Else
		If NIVEL1				// Sintetica de 1o. grupo
			li 	:= 60
		EndIf
	EndIf

	IF li > 58 
		If !lFirstPage
			@Prow()+1,00 PSAY	Replicate("-",limite)
		EndIf
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		lFirstPage := .F.
	End
 
	@ li,aColunas[COL_SEPARA1] 		PSAY "|"
	If mv_par23 = 1 .And. mv_par24 = 2
		@ li,aColunas[COL_CONTA] PSAY Left(DESCCTA,18)
	Else
		If lNormal
			If TIPOCONTA == "2" 		// Analitica -> Desloca 2 posicoes
				EntidadeCTB(Subs(CONTA,1,16),li,aColunas[COL_CONTA]+2,16,.F.,cMascara,cSeparador)
			Else	
				EntidadeCTB(Subs(CONTA,1,16),li,aColunas[COL_CONTA],18,.F.,cMascara,cSeparador)
			EndIf	
		Else
			If TIPOCONTA == "2"		// Analitica -> Desloca 2 posicoes
				@li,aColunas[COL_CONTA] PSAY Alltrim(CTARES)
			Else
				@li,aColunas[COL_CONTA] PSAY Alltrim(CONTA)
			EndIf						
		EndIf
	Endif
	@ li,aColunas[COL_SEPARA2] 		PSAY "|"
	If mv_par23 <> 1		// Com total, nao imprime descricao
		If mv_par18 = 2		// Reduzido
			@ li,aColunas[COL_DESCRICAO] PSAY Left(DESCCTA,27)
		Else
			@ li,aColunas[COL_DESCRICAO] PSAY Left(DESCCTA,19)
		Endif
		@ li,aColunas[COL_SEPARA3]		PSAY "|"
	Endif
	ValorCTB(COLUNA1,li,aColunas[COL_COLUNA1],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA4]		PSAY "|"
	ValorCTB(COLUNA2,li,aColunas[COL_COLUNA2],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5]		PSAY "|"
	ValorCTB(COLUNA3,li,aColunas[COL_COLUNA3],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6]		PSAY "|"
	ValorCTB(COLUNA4,li,aColunas[COL_COLUNA4],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA7] PSAY "|"	
	ValorCTB(COLUNA5,li,aColunas[COL_COLUNA5],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	ValorCTB(COLUNA6,li,aColunas[COL_COLUNA6],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA9] PSAY "|"
	ValorCTB(COLUNA7,li,aColunas[COL_COLUNA7],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA10] PSAY "|"
	ValorCTB(COLUNA8,li,aColunas[COL_COLUNA8],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA11] PSAY "|"
	ValorCTB(COLUNA9,li,aColunas[COL_COLUNA9],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA12] PSAY "|"
	ValorCTB(COLUNA10,li,aColunas[COL_COLUNA10],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA13] PSAY "|"
	ValorCTB(COLUNA11,li,aColunas[COL_COLUNA11],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA14] PSAY "|"
	ValorCTB(COLUNA12,li,aColunas[COL_COLUNA12],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA15] PSAY "|"
	If mv_par23 = 1		// Imprime Total
		ValorCTB(	COLUNA1 + COLUNA2 + COLUNA3 + COLUNA4 + COLUNA5 + COLUNA6 +;
					COLUNA7 + COLUNA8 + COLUNA9 + COLUNA10 + COLUNA11 + COLUNA12,;
					li,aColunas[COL_SEPARA15]  + 1,12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA15] + 15 PSAY "|"
	Endif			
	
	lJaPulou := .F.
	
	If lPula .And. TIPOCONTA == "1"				// Pula linha entre sinteticas
		li++
		@ li,aColunas[COL_SEPARA1] PSAY "|"
		@ li,aColunas[COL_SEPARA2] PSAY "|"
		If mv_par23 <> 1		// Com total, nao imprime descricao
			@ li,aColunas[COL_SEPARA3] PSAY "|"	
		Endif
		@ li,aColunas[COL_SEPARA4] PSAY "|"
		@ li,aColunas[COL_SEPARA5] PSAY "|"
		@ li,aColunas[COL_SEPARA6] PSAY "|"
		@ li,aColunas[COL_SEPARA7] PSAY "|"
		@ li,aColunas[COL_SEPARA8] PSAY "|"
		@ li,aColunas[COL_SEPARA9] PSAY "|"
		@ li,aColunas[COL_SEPARA10]PSAY "|"			
		@ li,aColunas[COL_SEPARA11] PSAY "|"
		@ li,aColunas[COL_SEPARA12] PSAY "|"
		@ li,aColunas[COL_SEPARA13] PSAY "|"	
		@ li,aColunas[COL_SEPARA14] PSAY "|"
		@ li,aColunas[COL_SEPARA15] PSAY "|"		
		li++
		lJaPulou := .T.
	Else
		li++
	EndIf			

	************************* FIM   DA  IMPRESSAO *************************

	If mv_par05 == 1					// So imprime Sinteticas - Soma Sinteticas
		If TIPOCONTA == "1"			
			If NIVEL1      
				For nVezes := 1 to Len(aMeses)
					aTotCol[nVezes] +=&("COLUNA"+Alltrim(Str(nVezes,2)))				
					aTotGrp[nVezes] +=&("COLUNA"+Alltrim(Str(nVezes,2)))
				Next	
			EndIf
		EndIf
	Else									// Soma Analiticas
		If Empty(cSegAte)				//Se nao tiver filtragem ate o nivel
			If TIPOCONTA == "2"
				For nVezes := 1 to Len(aMeses)
					aTotCol[nVezes] +=&("COLUNA"+Alltrim(Str(nVezes,2)))
					aTotGrp[nVezes] +=&("COLUNA"+Alltrim(Str(nVezes,2)))									
				Next							
			EndIf
		Else							//Se tiver filtragem, somo somente as sinteticas
			If TIPOCONTA == "1"
				If NIVEL1
					For nVezes := 1 to Len(aMeses)
						aTotCol[nVezes] +=&("COLUNA"+Alltrim(Str(nVezes,2)))				
					Next							
				EndIf
			EndIf
    	Endif			
	EndIf

	dbSkip()       
	If lPula .And. TIPOCONTA == "1" 			// Pula linha entre sinteticas
		If !lJaPulou
			@ li,aColunas[COL_SEPARA1] PSAY "|"
			@ li,aColunas[COL_SEPARA2] PSAY "|"
			If mv_par23 <> 1		// Com total, nao imprime descricao
				@ li,aColunas[COL_SEPARA3] PSAY "|"	
			Endif
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
			@ li,aColunas[COL_SEPARA15] PSAY "|"			
			li++
		EndIf	
	EndIf		
EndDO

IF li != 80 .And. !lEnd
	IF li > 58 
		@Prow()+1,00 PSAY	Replicate("-",limite)
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		li++
	End
	If mv_par11 == 1							// Grupo Diferente - Totaliza e Quebra
		If cGrupo != GRUPO
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@li,aColunas[COL_SEPARA1] PSAY "|"
			If mv_par23 <> 1		// Com total, nao imprime descricao
				@li,aColunas[COL_CONTA]  PSAY STR0016 + ALLTRIM (cGrupo)	//"TOTAIS DO GRUPO: "
				@ li,aColunas[COL_SEPARA3]	PSAY "|"
			Else
				@li,aColunas[COL_CONTA] PSAY STR0025 + ALLTRIM (cGrupo)  	//"T O T A I S  D O  G R U P O: "
				@ li,aColunas[COL_SEPARA2] 		PSAY "|"
			Endif
			ValorCTB(aTotGrp[1],li,aColunas[COL_COLUNA1],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA4]		PSAY "|"
			ValorCTB(aTotGrp[2],li,aColunas[COL_COLUNA2],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA5]		PSAY "|"
			ValorCTB(aTotGrp[3],li,aColunas[COL_COLUNA3],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA6]		PSAY "|"
			ValorCTB(aTotGrp[4],li,aColunas[COL_COLUNA4],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA7] PSAY "|"	
			ValorCTB(aTotGrp[5],li,aColunas[COL_COLUNA5],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA8] PSAY "|"
			ValorCTB(aTotGrp[6],li,aColunas[COL_COLUNA6],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA9] PSAY "|"                                                                       
			ValorCTB(aTotGrp[7],li,aColunas[COL_COLUNA7],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA10] PSAY "|"                                                                       
			ValorCTB(aTotGrp[8],li,aColunas[COL_COLUNA8],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA11] PSAY "|"                                                                       
			ValorCTB(aTotGrp[9],li,aColunas[COL_COLUNA9],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA12] PSAY "|"                                                                       
			ValorCTB(aTotGrp[10],li,aColunas[COL_COLUNA10],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA13] PSAY "|"                                                                       
			ValorCTB(aTotGrp[11],li,aColunas[COL_COLUNA11],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA14] PSAY "|"                                                                       
			ValorCTB(aTotGrp[12],li,aColunas[COL_COLUNA12],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA15] PSAY "|"                                                                       						
			If mv_par23 = 1		// Imprime Total
				ValorCTB(	aTotGrp[1] + aTotGrp[2] + aTotGrp[3] + aTotGrp[4] +;
							aTotGrp[5] + aTotGrp[6] + aTotGrp[7] + aTotGrp[8] +;
							aTotGrp[9] + aTotGrp[10] + aTotGrp[11] + aTotGrp[12],li,aColunas[COL_SEPARA15] + 1 ,12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA15] + 15 PSAY "|"
			Endif			
			li++
			cGrupo		:= GRUPO
			aTotGrp 	:= {0,0,0,0,0,0}
		EndIf		
	EndIf

	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,aColunas[COL_SEPARA1] PSAY "|"
	If mv_par23 <> 1		// Com total, nao imprime descricao
		@li,aColunas[COL_CONTA]   PSAY STR0011  		//"T O T A I S  D O  P E R I O D O : "
		@ li,aColunas[COL_SEPARA3]		PSAY "|"
	Else
		@li,aColunas[COL_CONTA] PSAY STR0024 //"TOTAIS DO PERIODO: "
		@ li,aColunas[COL_SEPARA2] 		PSAY "|"
	Endif
	ValorCTB(aTotCol[1],li,aColunas[COL_COLUNA1],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)

	@ li,aColunas[COL_SEPARA4]		PSAY "|"
	ValorCTB(aTotCol[2],li,aColunas[COL_COLUNA2],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)

	@ li,aColunas[COL_SEPARA5]		PSAY "|"
	ValorCTB(aTotCol[3],li,aColunas[COL_COLUNA3],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)

	@ li,aColunas[COL_SEPARA6]		PSAY "|"
	ValorCTB(aTotCol[4],li,aColunas[COL_COLUNA4],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)

	@ li,aColunas[COL_SEPARA7] PSAY "|"	
	ValorCTB(aTotCol[5],li,aColunas[COL_COLUNA5],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)

	@ li,aColunas[COL_SEPARA8] PSAY "|"
	ValorCTB(aTotCol[6],li,aColunas[COL_COLUNA6],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)

	@ li,aColunas[COL_SEPARA9] PSAY "|"                                                                       
	ValorCTB(aTotCol[7],li,aColunas[COL_COLUNA7],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)

	@ li,aColunas[COL_SEPARA10] PSAY "|"                                                                      	
	ValorCTB(aTotCol[8],li,aColunas[COL_COLUNA8],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)		

	@ li,aColunas[COL_SEPARA11] PSAY "|"                                                                      	
	ValorCTB(aTotCol[9],li,aColunas[COL_COLUNA9],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)		

	@ li,aColunas[COL_SEPARA12] PSAY "|"                                                                      	
	ValorCTB(aTotCol[10],li,aColunas[COL_COLUNA10],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)		

	@ li,aColunas[COL_SEPARA13] PSAY "|"                                                                      	
	ValorCTB(aTotCol[11],li,aColunas[COL_COLUNA11],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)		

	@ li,aColunas[COL_SEPARA14] PSAY "|"                                                                      	
	ValorCTB(aTotCol[12],li,aColunas[COL_COLUNA12],12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)		

	@ li,aColunas[COL_SEPARA15] PSAY "|"                                                                      		
	If mv_par23 = 1		// Imprime Total
		ValorCTB(	aTotCol[1] + aTotCol[2] + aTotCol[3] + aTotCol[4] +;
					aTotCol[5] + aTotCol[6] + aTotCol[7] + aTotCol[8] +;
					aTotCol[9] + aTotCol[10] + aTotCol[11] + aTotCol[12],li,aColunas[COL_SEPARA15] + 1,12,nDecimais,.T.,cPicture, , , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA15] + 15 PSAY "|"
	Endif			

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
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIF	
dbselectArea("CT2")

MS_FLUSH()
