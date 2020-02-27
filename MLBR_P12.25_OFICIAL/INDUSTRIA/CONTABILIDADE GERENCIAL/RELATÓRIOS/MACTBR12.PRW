#Include "PROTHEUS.Ch"

#define STR0001  "Este programa ira imprimir o Balancete de Verificacao Modelo 1 (132 Colunas), a"
#define STR0002  "conta eh impressa limitando-se a 20 caracteres e sua descricao 30 caracteres,"
#define STR0003  "Balancete Auxiliar de Verificacao"
#define STR0004  "|  CODIGO                     |      D E S C R I C A O                          |    SALDO ANTERIOR             |     DEBITO       |      CREDITO      |    MOVIMENTO DO PERIODO       |         SALDO ATUAL               |"
#define STR0005  "|  CODIGO               |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |"
#define STR0006  "BALANCETE DE VERIFICACAO ANALITICO DE "
#define STR0007  " ATE "
#define STR0008  " EM "
#define STR0009  "BALANCETE DE VERIFICACAO SINTETICO DE "
#define STR0010  "***** CANCELADO PELO OPERADOR *****"
#define STR0011  "T O T A I S  D O  P E R I O D O: "
#define STR0012  "Selecionando Registros..."
#define STR0013  "Zebrado"
#define STR0014  "Administracao"
#define STR0015  "Criando Arquivo Temporario..."
#define STR0016  "os valores impressos sao saldo anterior, debito, credito e saldo atual do periodo."
#define STR0017  "BALANCETE DE VERIFICACAO DE "
#define STR0018  " (ORCADO)"
#define STR0019  " (GERENCIAL)"
#define STR0020  "T O T A I S  D O  G R U P O ("
#define STR0021  "DIV."
#define STR0022  "|  CODIGO                     |      D E S C R I C A O                          |        SALDO ANTERIOR             |           DEBITO             |            CREDITO                |         SALDO ATUAL               |"
#define STR0023  "Microsiga Software S/A"
#define STR0024  "Hora Termino: "
#define STR0025  "Favor preencher os parametros Grupos Receitas/Despesas e Data Sld Ant. Receitas/Despesas ou"
#define STR0026  "deixar o parametro Ignora Sl Ant.Rec/Des = Nao "
#define STR0027  "Plano de contas"
#define STR0028  "Conta"
#define STR0029  "Descricao"
#define STR0030  "Saldo anterior"
#define STR0031  "Débito"
#define STR0032  "Crédito"
#define STR0033  "Movimento do periodo"
#define STR0034  "Saldo atual"
#define STR0035  "Ignora Sl Ant.Rec/Des"

#DEFINE 	COL_SEPARA1			1
#DEFINE 	COL_CONTA 			2
#DEFINE 	COL_SEPARA2			3
#DEFINE 	COL_DESCRICAO		4
#DEFINE 	COL_SEPARA3			5
#DEFINE 	COL_SALDO_ANT    	6
#DEFINE 	COL_SEPARA4			7
#DEFINE 	COL_VLR_DEBITO   	8
#DEFINE 	COL_SEPARA5			9
#DEFINE 	COL_VLR_CREDITO  	10
#DEFINE 	COL_SEPARA6			11
#DEFINE 	COL_MOVIMENTO 		12
#DEFINE 	COL_SEPARA7			13
#DEFINE 	COL_SALDO_ATU 		14
#DEFINE 	COL_SEPARA8			15
#DEFINE 	TAM_VALOR			20
#DEFINE 	PICVAL  			"@E 999,999,999,999.99"

//-----------------------
User function MaCtbr12()
//-----------------------
Local lImpBalR4		:= FindFunction( "TRepInUse" ) .And. TRepInUse()
Local aEst 			:= {} //Temporario para numeracao de vezes que ira rodar o programa para preenchimendo do planilhao
Local IKJ
Private titulo		:= ""
Private nomeprog	:= "MACTBR12"
Private nGrv		:= ""
CtAjustSx1('CTR040')

//If lImpBalR4

//Abrir os arquivos de trabalho VEZ.dbf , controla o numero de vezes esta sendo rodado o programa de balancete
//e tambem acumula os periodos para a montagem do cabecalho da planilha
if !file( "VEZ.DBF" )
	aadd(aEst,{"NVEZ"		,"N",02,0})
	aadd(aEst,{"NVEZP1"		,"C",18,0})
	aadd(aEst,{"NVEZP2"		,"C",18,0})
	aadd(aEst,{"NVEZP3"		,"C",18,0})
	aadd(aEst,{"NVEZP4"		,"C",18,0})
	aadd(aEst,{"NVEZP5"		,"C",18,0})
	aadd(aEst,{"NVEZP6"		,"C",18,0})
	aadd(aEst,{"NVEZP7"		,"C",18,0})
	aadd(aEst,{"NVEZP8"		,"C",18,0})
	aadd(aEst,{"NVEZP9"		,"C",18,0})
	aadd(aEst,{"NVEZP10"	,"C",18,0})
	aadd(aEst,{"NVEZP11"	,"C",18,0})
	aadd(aEst,{"NVEZP12"	,"C",18,0})
	cArqVez := CriaTrab(aEst,.T.)
	dbUseArea(.T.,,cArqVez,"VEZ",.F.,.F.)
	RecLock("VEZ",.T.)
	VEZ->NVEZ := 0
	VEZ->(msUnlock("VEZ") )
	Copy To &("VEZ.DBF")
endif
//Abre Planilha contador de vezes de execu'cao e periodo
dbUseArea(.T.,,"VEZ.DBF","VEZ",.F.,.F.)

//limpa dados da planilha BAL.dbf
If MsgYesNo("Deseja LIMPAR planilha de balancetes consolidados ?", "Gera Planilha Consolidata" )
	RECLOCK("VEZ",.F.)
	VEZ->NVEZ := 0
	for IKJ := 1 to 12
		cVar1 		:= "VEZ->NVEZP"+alltrim(Str(IKJ)) 	// limpando a planilha de cabeçalho de de periodos
		&(cVar1)   	:= ""
	next
	MSUNLOCK("VEZ")
	dbUseArea(.F.,,"BAL.DBF","MX",.F.,.F.)
	MX->(__DBZAP())
	Mx->(dbCloseArea())
	dbUseArea(.T.,,"VEZ.DBF","VEZ",.F.,.F.)
endif

U_MCTR12() //Gera relatorio padrao

//executa funcao para montagem da planilha.
If MsgYesNo("Deseja gerar planilha consolidada agora?", "Gera Planilha Consolidata" )
	U_MCTR12B() //Gera planilhao
endif
VEZ->(dbCloseArea())

Return


//------------------------
User Function MCTR12()
//------------------------
Local nQuadro
//Interface de impressao
Private aQuadro := { "","","","","","","",""}
Private aSelFil	:= {}

For nQuadro :=1 To Len(aQuadro)
	aQuadro[nQuadro] := Space(Len(CriaVar("CT1_CONTA")))
Next

CtbCarTxt()

Pergunte("CTR040",.T.)

//-------------------------
RECLOCK("VEZ",.F.)
if VEZ->NVEZ > 12
	VEZ->NVEZ := 0
	MsgInfo("Você já processou 12 periodos, o primeiro periodo sera substituido.")
else
	VEZ->NVEZ := VEZ->NVEZ + 1 //numerador de vezes que o programa é executado para controle das colunas a serem preenchidas
	cVar1 		:= "VEZ->NVEZP"+alltrim(Str(VEZ->NVEZ)) 	// grava dados do periodo
	&(cVar1)   	:= dtoc(MV_PAR01) + "-" + dtoc(MV_PAR02)
endif
VEZ->(MSUNLOCK("VEZ"))
nVezJJ := VEZ->NVEZ
//-------------------------

oReport := ReportDef()

If Valtype( oReport ) == 'O'
	If ! Empty( oReport:uParam )
		Pergunte( oReport:uParam, .F. )
	EndIf
	oReport:PrintDialog()
Endif
oReport := Nil
Return

//--------------------------------
Static Function ReportDef()
//--------------------------------
local aArea	   		:= GetArea()
Local CREPORT		:= "CTBR040"
Local CTITULO		:= STR0006				   			// "Emissao do Relat. Conf. Dig. "
Local CDESC			:= OemToAnsi(STR0001)+OemToAnsi(STR0002)+OemToAnsi(STR0003)			// "Este programa ira imprimir o Relatorio para Conferencia"
Local cPerg	   		:= "CTR040"
Local CCOLBAR		:= "|"
Local aTamConta		:= TAMSX3("CT1_CONTA")
Local aTamVal		:= TAMSX3("CT2_VALOR")
Local aTamDesc		:= {40}
Local cPictVal 		:= PesqPict("CT2","CT2_VALOR")
Local nDecimais
Local cMascara		:= ""
Local cSeparador	:= ""
Local nTamConta		:= 20
Local aSetOfBook
Local nMaskFator 	:= 1

// Efetua a pergunta antes de montar a configuração do relatorio, afim de poder definir o layout a ser impresso
Pergunte( "CTR040" , .F. )
//Pergunte( "CTR040" , .F. )
If mv_par30 == 1 .And. Len( aSelFil ) <= 0  .And. !IsBlind()
	aSelFil := AdmGetFil()
	If Len( aSelFil ) <= 0
		Return
	EndIf
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)	    	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! mCtr12V( mv_par06 )
	Return .F.
Else
	aSetOfBook := CTBSetOf( mv_par06 )
Endif

cMascara := RetMasCtb( aSetOfBook[2], @cSeparador )

If ! Empty( cMascara )
	nTamConta := aTamConta[1] + ( Len( Alltrim( cMascara ) ) / 2 )
Else
	nTamConta := aTamConta[1]
EndIf

cPicture := aSetOfBook[4]

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

//"Este programa tem o objetivo de emitir o Cadastro de Itens Classe de Valor "
//"Sera impresso de acordo com os parametros solicitados pelo"
//"usuario"
oReport	:= TReport():New( cReport,Capital(CTITULO),cPerg, { |oReport| Pergunte(cPerg , .F. ), If(! ReportPrint( oReport ), oReport:CancelPrint(), .T. ) }, CDESC )
oReport:ParamReadOnly()

IF GETNEWPAR("MV_CTBPOFF",.T.)
	oReport:SetEdit(.F.)
ENDIF

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
oSection1  := TRSection():New( oReport, "PLANO DE CONTAS", {"cArqTmp","CT1"},, .F., .F.,,,,,,,,,0 ) //"Plano de contas"

TRCell():New( oSection1, "CONTA"	,,"CONTA"/*Titulo*/	,/*Picture*/, nTamConta /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"LEFT"*/,,/*"LEFT"*/,,,.F.)
TRCell():New( oSection1, "DESCCTA"  ,,"DESCR CONTA"/*Titulo*/	,/*Picture*/, aTamDesc[1]/*Tamanho*/, /*lPixel*/,/*CodeBlock*/,  /*"LEFT"*/,.T.,/*"LEFT"*/,,,.F.)
TRCell():New( oSection1, "SALDOANT" ,,"SALDO ANT"/*Titulo*/	,/*Picture*/, TAM_VALOR+2 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)
TRCell():New( oSection1, "SALDODEB" ,,"DEBITO"/*Titulo*/	,/*Picture*/, TAM_VALOR+2 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)
TRCell():New( oSection1, "SALDOCRD" ,,"CREDITO"/*Titulo*/	,/*Picture*/, TAM_VALOR+2 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)
TRCell():New( oSection1, "MOVIMENTO",,"MOVIMENTO"/*Titulo*/	,/*Picture*/, TAM_VALOR+2 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)
TRCell():New( oSection1, "SALDOATU" ,,"SALDO ATUAL"/*Titulo*/	,/*Picture*/, TAM_VALOR+2 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)

TRPosition():New( oSection1, "CT1", 1, {|| xFilial( "CT1" ) + cArqTMP->CONTA })

oSection1:Cell("CONTA"):lHeaderSize		:= .F.
oSection1:Cell("DESCCTA"):lHeaderSize	:= .F.
oSection1:Cell("SALDOANT"):lHeaderSize	:= .F.
oSection1:Cell("SALDODEB"):lHeaderSize	:= .F.
oSection1:Cell("SALDOCRD"):lHeaderSize	:= .F.
oSection1:Cell("MOVIMENTO"):lHeaderSize	:= .F.
oSection1:Cell("SALDOATU"):lHeaderSize	:= .F.

oSection1:SetTotalInLine(.F.)
oSection1:SetTotalText('') //STR0011) //"T O T A I S  D O  P E R I O D O: "
oSection1:SetEdit(.F.)

Return( oReport )

/*
Impressao do relatorio
----------------------
*/
//------------------------------------
Static Function ReportPrint( oReport )
//------------------------------------
Local oSection1 	:= oReport:Section(1)
Local lExterno		:= .F.
Local aSetOfBook
Local dDataFim 		:= mv_par02
Local lFirstPage	:= .T.
Local lJaPulou		:= .F.
Local lRet			:= .T.
Local lPrintZero	:= (mv_par18==1)
Local lPula			:= (mv_par17==1)
Local lNormal		:= (mv_par19==1)
Local lVlrZerado	:= (mv_par07==1)
Local lQbGrupo		:= (mv_par11==1)
Local lQbConta		:= (mv_par11==2)
Local l132			:= .T.
Local nDecimais
Local nDivide		:= 1
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotMov		:= 0
Local nGrpDeb		:= 0
Local nGrpCrd		:= 0
Local cSegAte   	:= mv_par21
Local nDigitAte		:= 0
Local lImpAntLP		:= (mv_par22 == 1)
Local dDataLP		:= mv_par23
Local lImpSint		:= Iif(mv_par05=1 .Or. mv_par05 ==3,.T.,.F.)
Local lRecDesp0		:= (mv_par25 == 1)
Local lImpMov		:= (mv_par16 == 1)
Local cRecDesp		:= mv_par26
Local dDtZeraRD		:= mv_par27
Local n
Local oMeter
Local oText
Local oDlg
Local oBreak
Local lImpPaisgm	:= .F.
Local nMaxLin   	:= mv_par28
Local cMoedaDsc		:= mv_par29
Local aCtbMoeda		:= {}
Local aCtbMoedadsc	:= {}
Local CCOLBAR		:= "|"
Local cTipoAnt		:= ""
Local cGrupoAnt		:= ""
Local cArqTmp		:= ""
Local Tamanho		:= "M"
Local cSeparador	:= ""
Local aTamVal		:= TAMSX3("CT2_VALOR")
Local oTotGerDeb
Local oTotGerCrd
Local cPicture
Local cContaSint
Local cBreak		:= "2"
Local cGrupo		:= ""
Local nTotGerDeb	:= 0
Local nTotGerCrd	:= 0
Local nTotGerMov	:= 0
Local nCont			:= 0
Local cFilUser		:= ""
Local nMasc			:= 0
Local cMasc			:= ""

Private nLinReport    := 9

If oReport:nDevice == 5 .OR. oReport:nDevice == 3
	oSection1:Cell("SALDOANT"):SetAlign("RIGHT")
	oSection1:Cell("SALDODEB"):SetAlign("RIGHT")
	oSection1:Cell("SALDOCRD"):SetAlign("RIGHT")
	oSection1:Cell("MOVIMENTO"):SetAlign("RIGHT")
	oSection1:Cell("SALDOATU"):SetAlign("RIGHT")
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)	    	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! Mctr12V( mv_par06 )
	Return .F.
Else
	aSetOfBook := CTBSetOf(mv_par06)
Endif

If mv_par20 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par20 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par20 == 4		// Divide por milhao
	nDivide := 1000000
EndIf

If lRet
	aCtbMoeda := CtbMoeda( mv_par08 , nDivide )
	
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
		lRet := .F.
		Return lRet
	Endif
	
	// validação da descrição da moeda
	if lRet .And. ! Empty( mv_par29 ) .and. mv_par29 <> nil
		aCtbMoedadsc := CtbMoeda( mv_par29 , nDivide )
		
		If Empty( aCtbMoedadsc[1] )
			Help( " " , 1 , "NOMOEDA")
			lRet := .F.
			Return lRet
		Endif
	Endif
Endif

If lRet
	If (mv_par25 == 1) .and. ( Empty(mv_par26) .or. Empty(mv_par27) )
		cMensagem	:= STR0025	//"Favor preencher os parametros Grupos Receitas/Despesas e "
		cMensagem	+= STR0026	//"Data Sld Ant. Receitas/Desp. "
		MsgAlert(cMensagem,"Ignora Sl Ant.Rec/Des")	 //"Ignora Sl Ant.Rec/Des"
		lRet    	:= .F.
		Return lRet
	EndIf
EndIf

aCtbMoeda  	:= CtbMoeda(mv_par08,nDivide)

cDescMoeda 	:= Alltrim(aCtbMoeda[2])
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par08)

If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
Else
	cMascara 	:= RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf
cPicture 		:= aSetOfBook[4]

lPrintZero	:= Iif(mv_par18==1,.T.,.F.)

If oReport:Title() == oReport:cRealTitle
	IF mv_par05 == 1
		Titulo:=	OemToAnsi(STR0009)	//"BALANCETE DE VERIFICACAO SINTETICO DE "
	ElseIf mv_par05 == 2
		Titulo:=	OemToAnsi(STR0006)	//"BALANCETE DE VERIFICACAO ANALITICO DE "
	ElseIf mv_par05 == 3
		Titulo:=	OemToAnsi(STR0017)	//"BALANCETE DE VERIFICACAO DE "
	EndIf
	Titulo += 	DTOC(mv_par01) + OemToAnsi(STR0007) + Dtoc(mv_par02) + ;
	OemToAnsi(STR0008) + cDescMoeda + CtbTitSaldo(mv_par10)
Else
	Titulo := oReport:Title()
Endif

oReport:SetPageNumber( mv_par09 )
oReport:SetCustomText( {|| nCtCGCCabTR(dDataFim,titulo,oReport)})


cFilUser := oSection1:GetAdvplExpr("CT1")
If Empty(cFilUser)
	cFilUser := ".T."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao			  		     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lExterno  .or. IsBlind()
	CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
	mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
	mv_par10,aSetOfBook,mv_par12,mv_par13,mv_par14,mv_par15,;
	.F.,.F.,mv_par11,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,cFilUser,lRecDesp0,;
	cRecDesp,dDtZeraRD,,,,,,,cMoedaDsc)
Else
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
	CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
	mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
	mv_par10,aSetOfBook,mv_par12,mv_par13,mv_par14,mv_par15,;
	.F.,.F.,mv_par11,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,cFilUser,lRecDesp0,;
	cRecDesp,dDtZeraRD,,,,,,,cMoedaDsc,,aSelFil)},;
	OemToAnsi(OemToAnsi(STR0015)),;  //"Criando Arquivo Tempor rio..."
	OemToAnsi(STR0003))  				//"Balancete Verificacao"
EndIf

nCount := cArqTmp->(RecCount())
oReport:SetMeter(nCont)
lRet := !(nCount == 0 .And. !Empty(aSetOfBook[5]))

If lRet
	// Verifica Se existe filtragem Ate o Segmento
	If ! Empty( cSegAte )
		//Efetua tratamento da mascara para consegui efetuar o controle do segmento
		For nMasc := 1 to Len( cMascara )
			cMasc += "0"+SubStr( cMascara,nMasc,1 )
		Next nMasc
		
		nDigitAte := CtbRelDig( cSegAte, cMasc )
		oSection1:SetFilter( 'Len(Alltrim(cArqTmp->CONTA)) <= ' + alltrim( Str( nDigitAte )) )
	EndIf
	
	cArqTmp->(dbGoTop())
	MCtr12A() //Funcao para transferir dados para a tabela temporaria
	cArqTmp->(dbGoTop())
	//-----------------------------------
	If lNormal
		oSection1:Cell("CONTA"):SetBlock( {|| EntidadeCTB(cArqTmp->CONTA,000,000,030,.F.,cMascara,cSeparador,,,.F.,,.F.)} )
	Else
		oSection1:Cell("CONTA"):SetBlock( {|| cArqTmp->CTARES } )
	EndIf
	
	oSection1:Cell("DESCCTA"):SetBlock( { || cArqTMp->DESCCTA } )
	
	oSection1:Cell("SALDOANT"):SetBlock( { || ValorCTB(cArqTmp->SALDOANT,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDODEB"):SetBlock( { || ValorCTB(cArqTmp->SALDODEB,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDOCRD"):SetBlock( { || ValorCTB(cArqTmp->SALDOCRD,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDOATU"):SetBlock( { || ValorCTB(cArqTmp->SALDOATU,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.) } )
	
	//	 Imprime Movimento
	If !lImpMov
		oSection1:Cell("MOVIMENTO"):SetSize(0)
		oSection1:Cell("MOVIMENTO"):Disable()
	Else
		oSection1:Cell("MOVIMENTO"):SetBlock( { || ValorCTB(cArqTmp->MOVIMENTO,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,, lPrintZero,.F.) } )
	EndIf
	
	If lQbGrupo
		//*********************************
		// Total por Grupo do relatorio   *
		//*********************************
		oBrkGrupo := TRBreak():New(oSection1, { || cArqTmp->GRUPO },{|| STR0020+" "+ RTrim( Upper(AllTrim(cGrupo) )) + " )" },,,.F.)	//	" T O T A I S "
		oBrkGrupo:OnBreak( { |x| cGrupo := x } )
		
		oTotGrpDeb := TRFunction():New(oSection1:Cell("SALDODEB"),,"SUM",oBrkGrupo/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || Iif(cArqTmp->TIPOCONTA="1",0,cArqTmp->SALDODEB) },.F.,.F.,.F.,oSection1)
		oTotGrpDeb:Disable()
		
		oTotGrpCrd := TRFunction():New(oSection1:Cell("SALDOCRD"),,"SUM",oBrkGrupo/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || Iif(cArqTmp->TIPOCONTA="1",0,cArqTmp->SALDOCRD) },.F.,.F.,.F.,oSection1)
		oTotGrpCrd:Disable()
		
		TRFunction():New(oSection1:Cell("SALDODEB"),,"ONPRINT",oBrkGrupo/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrpDeb:GetValue(),,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )
		
		TRFunction():New(oSection1:Cell("SALDOCRD"),,"ONPRINT",oBrkGrupo/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrpCrd:GetValue(),,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )
		
	EndIf
	
	//******************************
	// Total Geral do relatorio    *
	//******************************
	oBrkGeral := TRBreak():New(oSection1, { || cArqTmp->(!Eof()) },{|| STR0011 },,,.F.)	//	" T O T A I S "
	
	// Totaliza
	oTotGerDeb := TRFunction():New(oSection1:Cell("SALDODEB"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || Iif(cArqTmp->TIPOCONTA="1",0,cArqTmp->SALDODEB) },.F.,.F.,.F.,oSection1)
	oTotGerDeb:Disable()
	
	oTotGerCrd := TRFunction():New(oSection1:Cell("SALDOCRD"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || Iif(cArqTmp->TIPOCONTA="1",0,cArqTmp->SALDOCRD) },.F.,.F.,.F.,oSection1)
	oTotGerCrd:Disable()
	
	TRFunction():New(oSection1:Cell("SALDODEB"),,"ONPRINT",oBrkGeral/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotGerDeb:GetValue(),,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1)
	
	// Imprime
	TRFunction():New(oSection1:Cell("SALDOCRD"),,"ONPRINT",oBrkGeral/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotGerCrd:GetValue(),,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.)},.F.,.F.,.F.,oSection1)
	
	oSection1:OnPrintLine( {|| 	CTR040OnPrint( lPula, lQbConta, nMaxLin, @cTipoAnt, @nLinReport, @cGrupoAnt ) } )
	
	oSection1:Print()
	
	If mv_par24 ==1
		oReport:Section(1):SetHeaderSection(.F.)
		ImpQuadro(Tamanho,X3USO("CT2_DCD"),dDataFim,mv_par08,aQuadro,cDescMoeda,oReport:ClassName(),(If (lImpAntLP,dDataLP,cTod(""))),cPicture,nDecimais,lPrintZero,mv_par10,oReport)
	EndIf
	
EndIf
dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIF

Return .T.


/*
Descricao ³ Executa acoes especificadas nos parametros do relatorio,
³ antes de imprimir cada linha.
*/
//--------------------------------------------------------------------------------
Static Function CTR040OnPrint( lPula, lQbConta, nMaxLin, cTipoAnt, nLinReport )
//--------------------------------------------------------------------------------
Local lRet := .T.

// Verifica salto de linha para conta sintetica (mv_par17)
If lPula .And. (cTipoAnt == "1" .Or. (cArqTmp->TIPOCONTA == "1" .And. cTipoAnt == "2"))
	oReport:SkipLine()
EndIf

// Verifica quebra de pagina por conta (mv_par11)
If lQbConta .And. cArqTmp->NIVEL1
	oReport:EndPage()
	nLinReport := 9
	Return
EndIf

// Verifica numero maximo de linhas por pagina (mv_par28)
If ! Empty(nMaxLin)
	CTR040MaxL(nMaxLin,@nLinReport)
EndIf

cTipoAnt := cArqTmp->TIPOCONTA

If mv_par05 == 1		// Apenas sinteticas
	lRet := (cArqTmp->TIPOCONTA == "1")
ElseIf mv_par05 == 2	// Apenas analiticas
	lRet := (cArqTmp->TIPOCONTA == "2")
EndIf

Return lRet

/*
------------------------------------------------------------------------- RELEASE 3 -------------------------------------------------------------------------------
*/
//---------------------------------
Static Function MCtbR12(wnRel)
//---------------------------------
Local aSetOfBook
Local aCtbMoeda	:= {}
LOCAL cDesc1 		:= OemToAnsi(STR0001)	//"Este programa ira imprimir o Balancete de Verificacao Modelo 1 (80 Colunas), a"
LOCAL cDesc2 		:= OemToansi(STR0002)   //"conta eh impressa limitando-se a 20 caracteres e sua descricao 30 caracteres,"
LOCAL cDesc3		:= OemToansi(STR0016)   //"os valores impressao sao saldo anterior, debito, credito e saldo atual do periodo."
LOCAL cString		:= "CT1"
Local cTitOrig		:= ""
Local lRet			:= .T.
Local nDivide		:= 1
Local lExterno 	:= .F.
Local nQuadro

PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= "CTR040"
PRIVATE aLinha		:= {}
PRIVATE nomeProg  	:= "CTBR040"
PRIVATE titulo 		:= OemToAnsi(STR0003) 	//"Balancete de Verificacao"
Private aSelFil		:= {}

Default wnRel := ""

lExterno := !Empty(wnRel)

If ! lExterno
	PRIVATE Tamanho		:= "M"
	PRIVATE aReturn 	:= { OemToAnsi(STR0013), 1,OemToAnsi(STR0014), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
EndIf

cTitOrig	:= titulo

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

li	:= 60 //80



Private aQuadro := { "","","","","","","",""}

For nQuadro :=1 To Len(aQuadro)
	aQuadro[nQuadro] := Space(Len(CriaVar("CT1_CONTA")))
Next

CtbCarTxt()

Pergunte("CTR040",.F.)


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
//³ mv_par16				// Imprime Coluna Mov ?				    	  ³
//³ mv_par17				// Salta linha sintetica ?			    	  ³
//³ mv_par18				// Imprime valor 0.00    ?			    	  ³
//³ mv_par19				// Imprimir Codigo? Normal / Reduzido  		  ³
//³ mv_par20				// Divide por ?                   			  ³
//³ mv_par21				// Imprimir Ate o segmento?			   		  ³
//³ mv_par22				// Posicao Ant. L/P? Sim / Nao         		  ³
//³ mv_par23				// Data Lucros/Perdas?                 		  ³
//³ mv_par24				// Imprime Quadros Contábeis?				  ³
//³ mv_par25				// Rec./Desp. Anterior Zeradas?				  ³
//³ mv_par26				// Grupo Receitas/Despesas?      			  ³
//³ mv_par27				// Data de Zeramento Receita/Despesas?		  ³
//³ mv_par28                // Num.linhas p/ o Balancete Modelo 1		  ³
//³ mv_par29				// Descricao na moeda?						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If ! lExterno
	Pergunte("CTR040",.T.)
	
	If mv_par30 == 1 .And. Len( aSelFil ) <= 0 .And. !IsBlind()
		aSelFil := AdmGetFil()
		If Len( aSelFil ) <= 0
			Return
		EndIf
	EndIf
	
	wnrel	:= "CTBR040"            //Nome Default do relatorio em Disco
	wnrel := SetPrint(cString,wnrel,,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
Endif

If nLastKey == 27
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Mctr12v(mv_par06)
	lRet := .F.
Else
	aSetOfBook := CTBSetOf(mv_par06)
Endif

If mv_par20 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par20 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par20 == 4		// Divide por milhao
	nDivide := 1000000
EndIf

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par08,nDivide)
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
		lRet := .F.
	Endif
Endif

If lRet
	If (mv_par25 == 1) .and. ( Empty(mv_par26) .or. Empty(mv_par27) )
		cMensagem	:= STR0025	//"Favor preencher os parametros Grupos Receitas/Despesas e "
		cMensagem	+= STR0026	//"Data Sld Ant. Receitas/Desp. "
		MsgAlert(cMensagem,"Ignora Sl Ant.Rec/Des")
		lRet    	:= .F.
	EndIf
EndIf

If !lRet
	Set Filter To
	Return
EndIf


If !lExterno .And. ( mv_par16 == 1 .Or. ( mv_par16 == 2 .And.	aReturn[4] == 2 ))	//Se nao imprime coluna mov. e eh paisagem
	tamanho := "G"
EndIf

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| MCTR12Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,nDivide,lExterno,cTitorig)})

Return

/*/
Descrição Imprime relatorio -> Balancete Verificacao Modelo 1
/*/
//-------------------------------------------------------------------------------------------
Static Function MCTR12Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,nDivide,lExterno,cTitOrig)
//-------------------------------------------------------------------------------------------
Local aColunas		:= {}
LOCAL CbTxt			:= Space(10)
Local CbCont		:= 0
LOCAL limite		:= 132
Local cabec1   	:= ""
Local cabec2   	:= ""
Local cSeparador	:= ""
Local cPicture
Local cDescMoeda
Local cCodMasc
Local cMascara
Local cGrupo		:= ""
Local cArqTmp
Local dDataFim 	:= mv_par02
Local lFirstPage	:= .T.
Local lJaPulou		:= .F.
Local lPrintZero	:= Iif(mv_par18==1,.T.,.F.)
Local lPula			:= Iif(mv_par17==1,.T.,.F.)
Local lNormal		:= Iif(mv_par19==1,.T.,.F.)
Local lVlrZerado	:= Iif(mv_par07==1,.T.,.F.)
Local l132			:= .T.
Local nDecimais
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotMov		:= 0
Local nGrpDeb		:= 0
Local nGrpCrd		:= 0
Local cSegAte   	:= mv_par21
Local nDigitAte	:= 0
Local lImpAntLP	:= Iif(mv_par22 == 1,.T.,.F.)
Local dDataLP		:= mv_par23
Local lImpSint		:= Iif(mv_par05=1 .Or. mv_par05 ==3,.T.,.F.)
Local lRecDesp0		:= Iif(mv_par25==1,.T.,.F.)
Local cRecDesp		:= mv_par26
Local dDtZeraRD		:= mv_par27
Local n
Local oMeter
Local oText
Local oDlg
Local lImpPaisgm	:= .F.
Local nMaxLin   	:= iif( mv_par28 > 58 , 58 , mv_par28 )
Local cMoedaDsc		:= mv_par29
Local nMasc			:= 0
Local cMasc			:= ""

cDescMoeda 	:= Alltrim(aCtbMoeda[2])
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par08)

If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
Else
	cMascara 	:= RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf
cPicture 		:= aSetOfBook[4]

If mv_par16 == 2 .And. !lExterno .And. 	aReturn[4] == 2	//Se nao imprime coluna mov. e eh paisagem
	lImpPaisgm	:= .T.
	limite		:= 220
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Alltrim(Titulo) == Alltrim(cTitorig) // Se o titulo do relatorio nao foi alterado pelo usuario
	IF mv_par05 == 1
		Titulo:=	OemToAnsi(STR0009)	//"BALANCETE DE VERIFICACAO SINTETICO DE "
	ElseIf mv_par05 == 2
		Titulo:=	OemToAnsi(STR0006)	//"BALANCETE DE VERIFICACAO ANALITICO DE "
	ElseIf mv_par05 == 3
		Titulo:=	OemToAnsi(STR0017)	//"BALANCETE DE VERIFICACAO DE "
	EndIf
EndIf
Titulo += 	DTOC(mv_par01) + OemToAnsi(STR0007) + Dtoc(mv_par02) + ;
OemToAnsi(STR0008) + cDescMoeda + CtbTitSaldo(mv_par10)

If nDivide > 1
	Titulo += " (" + OemToAnsi(STR0021) + Alltrim(Str(nDivide)) + ")"
EndIf

If mv_par16 == 1 .And. ! lExterno		// Se imprime saldo movimento do periodo
	cabec1 := OemToAnsi(STR0004)  //"|  CODIGO              |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |    DEBITO     |    CREDITO   | MOVIMENTO DO PERIODO |   SALDO ATUAL    |"
	tamanho := "G"
	limite	:= 220
	l132	:= .F.
Else
	If lImpPaisgm		//Se imprime em formato paisagem
		cabec1 := STR0022  //"|  CODIGO                     |      D E S C R I C A O                          |        SALDO ANTERIOR             |           DEBITO             |            CREDITO                |         SALDO ATUAL               |"
	Else
		cabec1 := OemToAnsi(STR0005)  //"|  CODIGO               |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |"
	EndIf
Endif

If ! lExterno
	SetDefault(aReturn,cString,,,Tamanho,If(Tamanho="G",2,1))
Endif

If l132
	If lImpPaisgm
		aColunas := { 000,001, 030, 032, 080,086, 116, 118, 147, 151, 183, , ,187,219}
	Else
		aColunas := { 000,001, 024, 025, 057,058, 077, 078, 094, 095, 111, , , 112, 131 }
	EndIf
Else
	aColunas := { 000,001, 030, 032, 080,082, 112, 114, 131, 133, 151, 153, 183,185,219}
Endif

If ! lExterno
	m_pag := mv_par09
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lExterno  .or. IsBlind()
	CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
	mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
	mv_par10,aSetOfBook,mv_par12,mv_par13,mv_par14,mv_par15,;
	.F.,.F.,mv_par11,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,aReturn[7],lRecDesp0,;
	cRecDesp,dDtZeraRD,,,,,,,cMoedaDsc)
Else
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
	CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
	mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
	mv_par10,aSetOfBook,mv_par12,mv_par13,mv_par14,mv_par15,;
	.F.,.F.,mv_par11,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,aReturn[7],lRecDesp0,;
	cRecDesp,dDtZeraRD,,,,,,,cMoedaDsc,,aSelFil)},;
	OemToAnsi(OemToAnsi(STR0015)),;  //"Criando Arquivo Tempor rio..."
	OemToAnsi(STR0003))  				//"Balancete Verificacao"
EndIf

// Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)
	
	//Efetua tratamento da mascara para consegui efetuar o controle do segmento
	For nMasc := 1 to Len( cMascara )
		
		cMasc += "0"+SubStr( cMascara,nMasc,1 )
		
	Next nMasc
	
	
	nDigitAte := CtbRelDig(cSegAte,cMasc)
	
EndIf

dbSelectArea("cArqTmp")
//dbSetOrder(1)
dbGoTop()

SetRegua(RecCount())

cGrupo := GRUPO

While !Eof()
	
	If lEnd
		@Prow()+1,0 PSAY OemToAnsi(STR0010)   //"***** CANCELADO PELO OPERADOR *****"
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
	
	//Filtragem ate o Segmento ( antigo nivel do SIGACON)
	If !Empty(cSegAte)
		If Len(Alltrim(CONTA)) > nDigitAte
			dbSkip()
			Loop
		Endif
	EndIf
	
	
	************************* ROTINA DE IMPRESSAO *************************
	
	If mv_par11 == 1 							// Grupo Diferente - Totaliza e Quebra
		If cGrupo != GRUPO
			@li,00 PSAY REPLICATE("-",limite)
			li+=2
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@li,aColunas[COL_SEPARA1] PSAY "|"
			@li,39 PSAY OemToAnsi(STR0020) + cGrupo + ") : "  		//"T O T A I S  D O  G R U P O: "
			@li,aColunas[COL_SEPARA4] PSAY "|"
			ValorCTB(nGrpDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA5] PSAY "|"
			ValorCTB(nGrpCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA6] PSAY "|"
			@li,aColunas[COL_SEPARA8] PSAY "|"
			li++
			li		:= 60
			cGrupo	:= GRUPO
			nGrpDeb	:= 0
			nGrpCrd	:= 0
		EndIf
		
	ElseIf  mv_par11 == 2
		If NIVEL1				// Sintetica de 1o. grupo
			li := 60
		EndIf
	EndIf
	
	IF li > nMaxLin
		If !lFirstPage
			@Prow()+1,00 PSAY	Replicate("-",limite)
		EndIf
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		lFirstPage := .F.
	EndIf
	
	@ li,aColunas[COL_SEPARA1] 		PSAY "|"
	If lNormal
		If TIPOCONTA == "2" 		// Analitica -> Desloca 2 posicoes
			If l132
				EntidadeCTB(CONTA,li,aColunas[COL_CONTA]+2,21,.F.,cMascara,cSeparador)
			Else
				EntidadeCTB(CONTA,li,aColunas[COL_CONTA]+2,27,.F.,cMascara,cSeparador)
			EndIf
		Else
			If l132
				EntidadeCTB(CONTA,li,aColunas[COL_CONTA],23,.F.,cMascara,cSeparador)
			Else
				EntidadeCTB(CONTA,li,aColunas[COL_CONTA],29,.F.,cMascara,cSeparador)
			EndIf
		EndIf
	Else
		If TIPOCONTA == "2"		// Analitica -> Desloca 2 posicoes
			@li,aColunas[COL_CONTA] PSAY Alltrim(CTARES)
		Else
			@li,aColunas[COL_CONTA] PSAY Alltrim(CONTA)
		EndIf
	EndIf
	
	@ li,aColunas[COL_SEPARA2] 		PSAY "|"
	
	If !l132
		@ li,aColunas[COL_DESCRICAO] 	PSAY Substr(DESCCTA,1,48)
	Else
		@ li,aColunas[COL_DESCRICAO] 	PSAY Substr(DESCCTA,1,30)
	Endif
	
	@ li,aColunas[COL_SEPARA3]		PSAY "|"
	ValorCTB(SALDOANT,li,aColunas[COL_SALDO_ANT],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
	
	@ li,aColunas[COL_SEPARA4]		PSAY "|"
	ValorCTB(SALDODEB,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
	
	@ li,aColunas[COL_SEPARA5]		PSAY "|"
	ValorCTB(SALDOCRD,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
	
	@ li,aColunas[COL_SEPARA6]		PSAY "|"
	
	If !l132
		ValorCTB(MOVIMENTO,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA7] PSAY "|"
	Endif
	ValorCTB(SALDOATU,li,aColunas[COL_SALDO_ATU],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
	
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	
	lJaPulou := .F.
	
	If lPula .And. TIPOCONTA == "1"				// Pula linha entre sinteticas
		li++
		@ li,aColunas[COL_SEPARA1] PSAY "|"
		@ li,aColunas[COL_SEPARA2] PSAY "|"
		@ li,aColunas[COL_SEPARA3] PSAY "|"
		@ li,aColunas[COL_SEPARA4] PSAY "|"
		@ li,aColunas[COL_SEPARA5] PSAY "|"
		@ li,aColunas[COL_SEPARA6] PSAY "|"
		If !l132
			@ li,aColunas[COL_SEPARA7] PSAY "|"
			@ li,aColunas[COL_SEPARA8] PSAY "|"
		Else
			@ li,aColunas[COL_SEPARA8] PSAY "|"
		EndIf
		li++
		lJaPulou := .T.
	Else
		li++
	EndIf
	
	************************* FIM   DA  IMPRESSAO *************************
	
	If mv_par05 == 1					// So imprime Sinteticas - Soma Sinteticas
		If TIPOCONTA == "1"
			If NIVEL1
				nTotDeb += SALDODEB
				nTotCrd += SALDOCRD
				nGrpDeb += SALDODEB
				nGrpCrd += SALDOCRD
			EndIf
		EndIf
	Else									// Soma Analiticas
		If Empty(cSegAte)				//Se nao tiver filtragem ate o nivel
			If TIPOCONTA == "2"
				nTotDeb += SALDODEB
				nTotCrd += SALDOCRD
				nGrpDeb += SALDODEB
				nGrpCrd += SALDOCRD
			EndIf
		Else							//Se tiver filtragem, somo somente as sinteticas
			If TIPOCONTA == "1"
				If NIVEL1
					nTotDeb += SALDODEB
					nTotCrd += SALDOCRD
					nGrpDeb += SALDODEB
					nGrpCrd += SALDOCRD
				EndIf
			EndIf
		Endif
	EndIf
	
	dbSkip()
	If lPula .And. TIPOCONTA == "1" 			// Pula linha entre sinteticas
		If !lJaPulou
			@ li,aColunas[COL_SEPARA1] PSAY "|"
			@ li,aColunas[COL_SEPARA2] PSAY "|"
			@ li,aColunas[COL_SEPARA3] PSAY "|"
			@ li,aColunas[COL_SEPARA4] PSAY "|"
			@ li,aColunas[COL_SEPARA5] PSAY "|"
			@ li,aColunas[COL_SEPARA6] PSAY "|"
			If !l132
				@ li,aColunas[COL_SEPARA7] PSAY "|"
				@ li,aColunas[COL_SEPARA8] PSAY "|"
			Else
				@ li,aColunas[COL_SEPARA8] PSAY "|"
			EndIf
			li++
		EndIf
	EndIf
EndDO

//IF li != 80 .And. !lEnd
IF li <= 58 .OR. li >= 58 .And. !lEnd
	IF li > nMaxLin
		@Prow()+1,00 PSAY	Replicate("-",limite)
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		li++
	End
	If mv_par11 == 1							// Grupo Diferente - Totaliza e Quebra
		If cGrupo != GRUPO
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@li,aColunas[COL_SEPARA1] PSAY "|"
			@li,39 PSAY OemToAnsi(STR0020) + cGrupo + ") : "  		//"T O T A I S  D O  G R U P O: "
			@li,aColunas[COL_SEPARA4] PSAY "|"
			ValorCTB(nGrpDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA5] PSAY "|"
			ValorCTB(nGrpCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA6] PSAY "|"
			If !l132
				nTotMov := nTotMov + (nGrpCrd - nGrpDeb)
				If Round(NoRound(nTotMov,3),2) < 0
					ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
				ElseIf Round(NoRound(nTotMov,3),2) > 0
					ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
				EndIf
				@ li,aColunas[COL_SEPARA7] PSAY "|"
			Endif
			@li,aColunas[COL_SEPARA8] PSAY "|"
			li++
			@li,00 PSAY REPLICATE("-",limite)
			li+=2
		EndIf
	EndIf
	
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,aColunas[COL_SEPARA1] PSAY "|"
	@li,39 PSAY OemToAnsi(STR0011)  		//"T O T A I S  D O  M E S : "
	@li,aColunas[COL_SEPARA4] PSAY "|"
	ValorCTB(nTotDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
	@li,aColunas[COL_SEPARA5] PSAY "|"
	ValorCTB(nTotCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
	@li,aColunas[COL_SEPARA6] PSAY "|"
	If !l132
		nTotMov := nTotMov + (nTotCrd - nTotDeb)
		If Round(NoRound(nTotMov,3),2) < 0
			ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
		ElseIf Round(NoRound(nTotMov,3),2) > 0
			ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
		EndIf
		@li,aColunas[COL_SEPARA7] PSAY "|"
	EndIf
	@li,aColunas[COL_SEPARA8] PSAY "|"
	li++
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,0 PSAY " "
	
	IF lExterno
		If (li + 3) < 60
			@57,00 PSAY __PrtfatLine()
			@58,01 Psay STR0023   //  "Microsiga Software S/A"
			If Tamanho == "M"
				@58,100 Psay STR0024 + " " + Time()      //"Hora Termino: "
			ElseIf Tamanho == "G"
				@58,190 Psay STR0024 + " "+ Time()  //"Hora Termino: "
			Else
				@58,050 Psay STR0024 + " "+ Time()	   //"Hora Termino: "
			EndIf
			@59,00 PSAY __PrtfatLine()
		EndIf
	Endif
	Set Filter To
EndIF

If mv_par24 ==1
	ImpQuadro(Tamanho,X3USO("CT2_DCD"),dDataFim,mv_par08,aQuadro,cDescMoeda,nomeprog,(If (lImpAntLP,dDataLP,cTod(""))),cPicture,nDecimais,lPrintZero,mv_par10)
EndIf

If aReturn[5] = 1 .And. ! lExterno
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

If ! lExterno
	MS_FLUSH()
Endif

Return .T.

/*/
Valida Perguntas
/*/
//-------------------------------------------------------------------------------------------
Static Function Mctr12V(cSetOfBook)
//-------------------------------------------------------------------------------------------
Local aSaveArea:= GetArea()
Local lRet		:= .T.

If !Empty(cSetOfBook)
	dbSelectArea("CTN")
	dbSetOrder(1)
	If !dbSeek(xfilial()+cSetOfBook)
		aSetOfBook := ("","",0,"","")
		Help(" ",1,"NOSETOF")
		lRet := .F.
	EndIf
EndIf

RestArea(aSaveArea)

Return lRet


/*
Desc.      Baseado no parametro MV_PAR28 ("Num.linhas p/ o Balancete
Modelo 1"), cujo conteudo esta na variavel "nMaxLin", controla
a quebra de pagina no TReport
*/
//-------------------------------------------------------------------------------------------
Static Function CTR040MaxL(nMaxLin,nLinReport)
//-------------------------------------------------------------------------------------------
nLinReport++

If nLinReport > nMaxLin
	oReport:EndPage()
	nLinReport := 10
EndIf

Return Nil


/*
*/
//-------------------------------------------------------------------------------------------
STATIC FUNCTION nCtCGCCabTR(dDataFim,titulo,oReport)
//-------------------------------------------------------------------------------------------
nLinReport := 10
RETURN CtCGCCabTR(,,,,,dDataFim,titulo,,,,,oReport)




//-------------------------
Static Function MCtr12A()
//-------------------------
Local aEstru   := {}
Local aArr     := getarea()
Local lCred    := .f.
dbSelectArea("cArqTmp")
Copy To &("MACTBR12.DBF")
cArqTmp->(dbGoTop())
do while cArqTmp->(!eof())
	if !file( "BAL.DBF" )
		//Cria a estrutura dos campos da tabela que recebera os balancetes
		aadd(aEstru,{"CONTA"	,"C",20,0})
		aadd(aEstru,{"DESC"		,"C",30,0})
		
		aadd(aEstru,{"SDANTM1"	,"N",15,2})
		aadd(aEstru,{"DBM1"		,"N",15,2})
		aadd(aEstru,{"CRM1"		,"N",15,2})
		aadd(aEstru,{"MVM1"		,"N",15,2})
		aadd(aEstru,{"SDATM1"	,"N",15,2})
		
		aadd(aEstru,{"SDANTM2"	,"N",15,2})
		aadd(aEstru,{"DBM2"		,"N",15,2})
		aadd(aEstru,{"CRM2"		,"N",15,2})
		aadd(aEstru,{"MVM2"		,"N",15,2})
		aadd(aEstru,{"SDATM2"	,"N",15,2})
		
		aadd(aEstru,{"SDANTM3"	,"N",15,2})
		aadd(aEstru,{"DBM3"		,"N",15,2})
		aadd(aEstru,{"CRM3"		,"N",15,2})
		aadd(aEstru,{"MVM3"		,"N",15,2})
		aadd(aEstru,{"SDATM3"	,"N",15,2})
		
		aadd(aEstru,{"SDANTM4"	,"N",15,2})
		aadd(aEstru,{"DBM4"		,"N",15,2})
		aadd(aEstru,{"CRM4"		,"N",15,2})
		aadd(aEstru,{"MVM4"		,"N",15,2})
		aadd(aEstru,{"SDATM4"	,"N",15,2})
		
		aadd(aEstru,{"SDANTM5"	,"N",15,2})
		aadd(aEstru,{"DBM5"		,"N",15,2})
		aadd(aEstru,{"CRM5"		,"N",15,2})
		aadd(aEstru,{"MVM5"		,"N",15,2})
		aadd(aEstru,{"SDATM5"	,"N",15,2})
		
		aadd(aEstru,{"SDANTM6"	,"N",15,2})
		aadd(aEstru,{"DBM6"		,"N",15,2})
		aadd(aEstru,{"CRM6"		,"N",15,2})
		aadd(aEstru,{"MVM6"		,"N",15,2})
		aadd(aEstru,{"SDATM6"	,"N",15,2})
		
		aadd(aEstru,{"SDANTM7"	,"N",15,2})
		aadd(aEstru,{"DBM7"		,"N",15,2})
		aadd(aEstru,{"CRM7"		,"N",15,2})
		aadd(aEstru,{"MVM7"		,"N",15,2})
		aadd(aEstru,{"SDATM7"	,"N",15,2})
		
		aadd(aEstru,{"SDANTM8"	,"N",15,2})
		aadd(aEstru,{"DBM8"		,"N",15,2})
		aadd(aEstru,{"CRM8"		,"N",15,2})
		aadd(aEstru,{"MVM8"		,"N",15,2})
		aadd(aEstru,{"SDATM8"	,"N",15,2})
		
		aadd(aEstru,{"SDANTM9"	,"N",15,2})
		aadd(aEstru,{"DBM9"		,"N",15,2})
		aadd(aEstru,{"CRM9"		,"N",15,2})
		aadd(aEstru,{"MVM9"		,"N",15,2})
		aadd(aEstru,{"SDATM9"	,"N",15,2})
		
		aadd(aEstru,{"SDANTM10"	,"N",15,2})
		aadd(aEstru,{"DBM10"	,"N",15,2})
		aadd(aEstru,{"CRM10"	,"N",15,2})
		aadd(aEstru,{"MVM10"	,"N",15,2})
		aadd(aEstru,{"SDATM10"	,"N",15,2})
		
		aadd(aEstru,{"SDANTM11"	,"N",15,2})
		aadd(aEstru,{"DBM11"	,"N",15,2})
		aadd(aEstru,{"CRM11"	,"N",15,2})
		aadd(aEstru,{"MVM11"	,"N",15,2})
		aadd(aEstru,{"SDATM11"	,"N",15,2})
		
		aadd(aEstru,{"SDANTM12"	,"N",15,2})
		aadd(aEstru,{"DBM12"	,"N",15,2})
		aadd(aEstru,{"CRM12"	,"N",15,2})
		aadd(aEstru,{"MVM12"	,"N",15,2})
		aadd(aEstru,{"SDATM12"	,"N",15,2})
		
		aadd(aEstru,{"TPCT"		,"C",01,0})
		
		cArqImp := CriaTrab(aEstru,.T.)
		dbUseArea(.T.,,cArqImp,"MX",.F.,.F.)
		// transformando em tabela permanente
		Copy To &("BAL.dbf") //Sera criada na System e ao final processamento sera gerado um arquivo csv
		//Cria indice
		DbClearIndex()
		Index on CONTA TO "BAL" //Criando indice
	else
		//copia dados referente ao mes em processamento
		if Select("MX") = 0
			dbUseArea(.T.,,"BAL.DBF","MX",.F.,.F.)
			DbClearIndex()
			Index on CONTA TO "BAL" //Criando indice
			if !MX->(dbSeek(cArqTmp->CONTA))
				RecLock("MX",.t.)
			else
				RecLock("MX",.f.)
			endif
			
			MX->CONTA 	:= cArqTmp->CONTA
			MX->DESC	:= cArqTMp->DESCCTA
			
			cVar := "MX->SDANTM"+alltrim(Str(nVezJJ))
			//					ValorCtb(nSaldo           ,nLin,nCol,nTamanho   ,nDecimais,lSinal,cPicture      ,cTipo          ,cConta,lGraf,oPrint,cTipoSinal, cIdentifi,lPrintZero,lSay)
			nGrv := ValorCTB(cArqTmp->SALDOANT,    ,    ,TAM_VALOR-2,2        ,.T.   ,"999999999.99",cArqTmp->NORMAL,      ,     ,      ,          ,          ,.f.       ,.F.)
			if substr(nGrv,len(nGrv),1) = "C"
				lCred		:= .t.
			endif
			nGrv := val(substr(nGrv,1,len(nGrv)-2))
			if lCred .and. cVar $ "MX->SDANTM"+ alltrim(Str(nVezJJ)) + "#MX->MVM"+ alltrim(Str(nVezJJ)) + "#MX->SDATM"+ alltrim(Str(nVezJJ)) //Muda sinal somente para o saldo anterior, movimento e saldo atual "SDANTM#DBM#CRM#MVM#SDATM"
				nGrv := (nGrv * -1)
			endif
			&(cVar)   		:= nGrv
			lCred		:= .f.
						
			//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
			cVar := "MX->DBM"+alltrim(Str(nVezJJ))                        
			
			nGrv := ValorCTB(cArqTmp->SALDODEB,    ,    ,TAM_VALOR-2,2        ,.T.   ,"999999999.99",cArqTmp->NORMAL,      ,     ,      ,          ,          ,.f.       ,.F.)
//			if substr(nGrv,len(nGrv),1) = "C"
//				lCred		:= .t.
//			endif
	
			nGrv := val(substr(nGrv,1,len(nGrv)-2))  //solicitado pelo Hissashi - o valor do debito e credito devem conter sinal 16/11/10
//			if lCred 
//				nGrv := (nGrv * -1)
//			endif

			&(cVar)   						:= nGrv
			lCred		:= .f.

			//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
			
			cVar := "MX->CRM"+alltrim(Str(nVezJJ))
			nGrv := ValorCTB(cArqTmp->SALDOCRD,    ,    ,TAM_VALOR-2,2        ,.T.   ,"999999999.99",cArqTmp->NORMAL,      ,     ,      ,          ,          ,.f.       ,.F.)
//			if substr(nGrv,len(nGrv),1) = "C"
//				lCred		:= .t.
//			endif

			nGrv := val(substr(nGrv,1,len(nGrv)-2))  //solicitado pelo Hissashi - o valor do debito e credito devem conter sinal 16/11/10
//			if lCred 
				nGrv := (nGrv * -1)
//			endif

			&(cVar)							:= nGrv
			lCred		:= .f.

			//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
			cVar := "MX->MVM"+alltrim(Str(nVezJJ)) //Movimento mantem sinal na planilha
			nGrv := ValorCTB(cArqTmp->MOVIMENTO,    ,    ,TAM_VALOR-2,2        ,.T.   ,"999999999.99",cArqTmp->NORMAL,      ,     ,      ,          ,          ,.f.       ,.F.)
			if substr(nGrv,len(nGrv),1) = "C"
				lCred		:= .t.
			endif
			nGrv := val(substr(nGrv,1,len(nGrv)-2))
			if lCred
				nGrv := (nGrv * -1)
			endif
			&(cVar)							:= nGrv
			lCred		:= .f.

			//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
			
			cVar := "MX->SDATM"+alltrim(Str(nVezJJ)) //Saldo atual mantem sinal na planilha 
			nGrv := ValorCTB(cArqTmp->SALDOATU,    ,    ,TAM_VALOR-2,2        ,.T.   ,"999999999.99",cArqTmp->NORMAL,      ,     ,      ,          ,          ,.f.       ,.F.)
			if substr(nGrv,len(nGrv),1) = "C"
				lCred		:= .t.
			endif
			nGrv := val(substr(nGrv,1,len(nGrv)-2))
			if lCred .and. cVar $ "MX->SDANTM"+ alltrim(Str(nVezJJ)) + "#MX->MVM"+ alltrim(Str(nVezJJ)) + "#MX->SDATM"+ alltrim(Str(nVezJJ)) //Muda sinal somente para o saldo anterior, movimento e saldo atual "SDANTM#DBM#CRM#MVM#SDATM"
				nGrv := (nGrv * -1)
			endif
			&(cVar)							:= nGrv
			lCred		:= .f.
			//			&(cVar)							:= cArqTmp->SALDOATU
			MX->(msUnlock("MX"))
		else
			//		dbUseArea(.T.,,"BAL.DBF","MX",.F.,.F.)
 			if !MX->(dbSeek(cArqTmp->CONTA))
				RecLock("MX",.t.)
			else
				RecLock("MX",.f.)
			endif

			MX->CONTA 	:= cArqTmp->CONTA
			MX->DESC	:= cArqTMp->DESCCTA
			
			cVar := "MX->SDANTM"+alltrim(Str(nVezJJ))
			//					ValorCtb(nSaldo           ,nLin,nCol,nTamanho   ,nDecimais,lSinal,cPicture      ,cTipo          ,cConta,lGraf,oPrint,cTipoSinal, cIdentifi,lPrintZero,lSay)
			nGrv := ValorCTB(cArqTmp->SALDOANT,    ,    ,TAM_VALOR-2,2        ,.T.   ,"999999999.99",cArqTmp->NORMAL,      ,     ,      ,          ,          ,.f.       ,.F.)
			if substr(nGrv,len(nGrv),1) = "C"
				lCred		:= .t.
			endif
			nGrv := val(substr(nGrv,1,len(nGrv)-2))
			if lCred .and. cVar $ "MX->SDANTM"+ alltrim(Str(nVezJJ)) + "#MX->MVM"+ alltrim(Str(nVezJJ)) + "#MX->SDATM"+ alltrim(Str(nVezJJ)) //Muda sinal somente para o saldo anterior, movimento e saldo atual "SDANTM#DBM#CRM#MVM#SDATM"
				nGrv := (nGrv * -1)
			endif
			&(cVar)   		:= nGrv
			lCred		:= .f.
						
			//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
			cVar := "MX->DBM"+alltrim(Str(nVezJJ))
			nGrv := ValorCTB(cArqTmp->SALDODEB,    ,    ,TAM_VALOR-2,2        ,.T.   ,"999999999.99",cArqTmp->NORMAL,      ,     ,      ,          ,          ,.f.       ,.F.)
//			if substr(nGrv,len(nGrv),1) = "C"
//				lCred		:= .t.
//			endif

			nGrv := val(substr(nGrv,1,len(nGrv)-2))  //solicitado pelo Hissashi - o valor do debito e credito devem conter sinal 16/11/10
//			if lCred 
//				nGrv := (nGrv * -1)
//			endif

			&(cVar)   						:= nGrv
			lCred		:= .f.

			//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
			
			cVar := "MX->CRM"+alltrim(Str(nVezJJ))
			nGrv := ValorCTB(cArqTmp->SALDOCRD,    ,    ,TAM_VALOR-2,2        ,.T.   ,"999999999.99",cArqTmp->NORMAL,      ,     ,      ,          ,          ,.f.       ,.F.)
			if substr(nGrv,len(nGrv),1) = "C"
				lCred		:= .t.
			endif

			nGrv := val(substr(nGrv,1,len(nGrv)-2))  //solicitado pelo Hissashi - o valor do debito e credito devem conter sinal 16/11/10
			if lCred 
				nGrv := (nGrv * -1)
			endif

			&(cVar)							:= nGrv
			lCred		:= .f.

			//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
			cVar := "MX->MVM"+alltrim(Str(nVezJJ)) //Movimento mantem sinal na planilha
			nGrv := ValorCTB(cArqTmp->MOVIMENTO,    ,    ,TAM_VALOR-2,2        ,.T.   ,"999999999.99",cArqTmp->NORMAL,      ,     ,      ,          ,          ,.f.       ,.F.)
			if substr(nGrv,len(nGrv),1) = "C"
				lCred		:= .t.
			endif
			nGrv := val(substr(nGrv,1,len(nGrv)-2))
			if lCred
				nGrv := (nGrv * -1)
			endif
			&(cVar)							:= nGrv
			lCred		:= .f.

			//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
			
			cVar := "MX->SDATM"+alltrim(Str(nVezJJ)) //Saldo atual mantem sinal na planilha 
			nGrv := ValorCTB(cArqTmp->SALDOATU,    ,    ,TAM_VALOR-2,2        ,.T.   ,"999999999.99",cArqTmp->NORMAL,      ,     ,      ,          ,          ,.f.       ,.F.)
			if substr(nGrv,len(nGrv),1) = "C"
				lCred		:= .t.
			endif
			nGrv := val(substr(nGrv,1,len(nGrv)-2))
			if lCred .and. cVar $ "MX->SDANTM"+ alltrim(Str(nVezJJ)) + "#MX->MVM" + alltrim(Str(nVezJJ)) + "#MX->SDATM" + alltrim(Str(nVezJJ)) //Muda sinal somente para o saldo anterior, movimento e saldo atual "SDANTM#DBM#CRM#MVM#SDATM"
				nGrv := (nGrv * -1)
			endif
			&(cVar)							:= nGrv
			lCred		:= .f.
			//			&(cVar)							:= cArqTmp->SALDOATU
			MX->(msUnlock("MX"))
			
		endif
	Endif
	cArqTmp->(dbSkip())
	lCred		:= .f. //para trocar de sinal
enddo
MX->(dbCloseArea())
//VEZ->(dbCloseArea())
RestArea(aArr)
Return


//----------------------------------
User Function MCTR12B()
//----------------------------------
Local   nLc			:= 0
Private cTitulo  	:= "Relatorio de despesas por unidade de negocios"
Private aConteud 	:= {}
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""

Processa({|| MCTR12C()},'Analisando Dados...')

Return .T.

//-----------------------------------------
Static Function MCTR12c()
//-----------------------------------------
Local _cCampo 		:=""
Local IKK,JI
Private cCab		:= ""
Private cAcum,IKK		:= 0
Private aSdc        := {}

//+--------------------------------------------------------------//
//| Faz Select principal para preenchimento do array de impressao
//+--------------------------------------------------------------//
//Adicionando linhas no array para cabeçalho da planilha
aAdd(aConteud,{"BALANCETE MES-A-MES","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) //63 colunas
//aAdd(aConteud,{"CONTA","DESCRICAO","SD ANT MES 1","DEBITO MES 1","CREDITO MES 1 ","MOV MES 1","SD ATUAL M1","SD ANT MES 1","DEBITO MES 1","CREDITO MES 1 ","MOV MES 1","SD ATUAL M1","SD ANT MES 1","DEBITO MES 1","CREDITO MES 1 ","MOV MES 1","SD ATUAL M1","SD ANT MES 1","DEBITO MES 1","CREDITO MES 1 ","MOV MES 1","SD ATUAL M1","SD ANT MES 1","DEBITO MES 1","CREDITO MES 1 ","MOV MES 1","SD ATUAL M1","SD ANT MES 1","DEBITO MES 1","CREDITO MES 1 ","MOV MES 1","SD ATUAL M1","SD ANT MES 1","DEBITO MES 1","CREDITO MES 1 ","MOV MES 1","SD ATUAL M1","SD ANT MES 1","DEBITO MES 1","CREDITO MES 1 ","MOV MES 1","SD ATUAL M1","SD ANT MES 1","DEBITO MES 1","CREDITO MES 1 ","MOV MES 1","SD ATUAL M1","SD ANT MES 1","DEBITO MES 1","CREDITO MES 1 ","MOV MES 1","SD ATUAL M1","SD ANT MES 1","DEBITO MES 1","CREDITO MES 1 ","MOV MES 1","SD ATUAL M1","SD ANT MES 1","DEBITO MES 1","CREDITO MES 1 ","MOV MES 1","SD ATUAL M1"})
aAdd(aConteud,{"CONTA","DESCRICAO","SALDO ANT","DEBITO","CREDITO","MOVIMENTO","SALDO ATUAL","SALDO ANT","DEBITO","CREDITO","MOVIMENTO","SALDO ATUAL","SALDO ANT","DEBITO","CREDITO","MOVIMENTO","SALDO ATUAL","SALDO ANT","DEBITO","CREDITO","MOVIMENTO","SALDO ATUAL","SALDO ANT","DEBITO","CREDITO","MOVIMENTO","SALDO ATUAL","SALDO ANT","DEBITO","CREDITO","MOVIMENTO","SALDO ATUAL","SALDO ANT","DEBITO","CREDITO","MOVIMENTO","SALDO ATUAL","SALDO ANT","DEBITO","CREDITO","MOVIMENTO","SALDO ATUAL","SALDO ANT","DEBITO","CREDITO","MOVIMENTO","SALDO ATUAL","SALDO ANT","DEBITO","CREDITO","MOVIMENTO","SALDO ATUAL","SALDO ANT","DEBITO","CREDITO","MOVIMENTO","SALDO ATUAL","SALDO ANT","DEBITO","CREDITO","MOVIMENTO","SALDO ATUAL","TP.CONTA"})
aAdd(aConteud,{"","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) //63 colunas

//Cabeçalho
//Tabulaçao     1       2           3              4              5                6           7             8              9              10              11           12            13             14             15               16          17            18             19             20               21          22            23             24             25               26          27            28             29             30               31          32            33             34             35               36          37            38             39
for IKK := 1 to 12
	do Case
		Case IKK = 2
			nCol := 3
			_cCampo :=VEZ->(field(IKK))
			aConteud [len(aConteud),nCol] 	:= VEZ->(FieldGet(Fieldpos(_cCampo))) //Sd.Ant
			//			aConteud [len(aConteud),nCol+1] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Debito
			//			aConteud [len(aConteud),nCol+2] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Credito
			//			aConteud [len(aConteud),nCol+3] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Movimento
			//			aConteud [len(aConteud),nCol+4] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Saldo Atual
			
		Case IKK = 3
			nCol := 8
			_cCampo :=VEZ->(field(IKK))
			aConteud [len(aConteud),nCol] 	:= VEZ->(FieldGet(Fieldpos(_cCampo))) //Sd.Ant
			//			aConteud [len(aConteud),nCol+1] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Debito
			//			aConteud [len(aConteud),nCol+2] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Credito
			//			aConteud [len(aConteud),nCol+3] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Movimento
			//			aConteud [len(aConteud),nCol+4] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Saldo Atual
			
		Case IKK = 4
			nCol := 13
			_cCampo :=VEZ->(field(IKK))
			aConteud [len(aConteud),nCol] 	:= VEZ->(FieldGet(Fieldpos(_cCampo))) //Sd.Ant
			//			aConteud [len(aConteud),nCol+1] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Debito
			//			aConteud [len(aConteud),nCol+2] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Credito
			//			aConteud [len(aConteud),nCol+3] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Movimento
			//			aConteud [len(aConteud),nCol+4] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Saldo Atual
			
		Case IKK = 5
			nCol := 18
			_cCampo :=VEZ->(field(IKK))
			aConteud [len(aConteud),nCol] 	:= VEZ->(FieldGet(Fieldpos(_cCampo))) //Sd.Ant
			//			aConteud [len(aConteud),nCol+1] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Debito
			//			aConteud [len(aConteud),nCol+2] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Credito
			//			aConteud [len(aConteud),nCol+3] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Movimento
			//			aConteud [len(aConteud),nCol+4] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Saldo Atual
			
		Case IKK = 6
			nCol := 23
			_cCampo :=VEZ->(field(IKK))
			aConteud [len(aConteud),nCol] 	:= VEZ->(FieldGet(Fieldpos(_cCampo))) //Sd.Ant
			//			aConteud [len(aConteud),nCol+1] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Debito
			//			aConteud [len(aConteud),nCol+2] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Credito
			//			aConteud [len(aConteud),nCol+3] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Movimento
			//			aConteud [len(aConteud),nCol+4] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Saldo Atual
			
		Case IKK = 7
			nCol := 28
			_cCampo :=VEZ->(field(IKK))
			aConteud [len(aConteud),nCol] 	:= VEZ->(FieldGet(Fieldpos(_cCampo))) //Sd.Ant
			//			aConteud [len(aConteud),nCol+1] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Debito
			//			aConteud [len(aConteud),nCol+2] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Credito
			//			aConteud [len(aConteud),nCol+3] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Movimento
			//			aConteud [len(aConteud),nCol+4] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Saldo Atual
			
		Case IKK = 8
			nCol := 32
			_cCampo :=VEZ->(field(IKK))
			aConteud [len(aConteud),nCol] 	:= VEZ->(FieldGet(Fieldpos(_cCampo))) //Sd.Ant
			//			aConteud [len(aConteud),nCol+1] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Debito
			//			aConteud [len(aConteud),nCol+2] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Credito
			//			aConteud [len(aConteud),nCol+3] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Movimento
			//			aConteud [len(aConteud),nCol+4] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Saldo Atual
			
		Case IKK = 9
			nCol := 37
			_cCampo :=VEZ->(field(IKK))
			aConteud [len(aConteud),nCol] 	:= VEZ->(FieldGet(Fieldpos(_cCampo))) //Sd.Ant
			//			aConteud [len(aConteud),nCol+1] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Debito
			//			aConteud [len(aConteud),nCol+2] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Credito
			//			aConteud [len(aConteud),nCol+3] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Movimento
			//			aConteud [len(aConteud),nCol+4] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Saldo Atual
			
		Case IKK = 10
			nCol := 42
			_cCampo :=VEZ->(field(IKK))
			aConteud [len(aConteud),nCol] 	:= VEZ->(FieldGet(Fieldpos(_cCampo))) //Sd.Ant
			//			aConteud [len(aConteud),nCol+1] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Debito
			//			aConteud [len(aConteud),nCol+2] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Credito
			//			aConteud [len(aConteud),nCol+3] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Movimento
			//			aConteud [len(aConteud),nCol+4] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Saldo Atual
			
		Case IKK = 11
			nCol := 47
			_cCampo :=VEZ->(field(IKK))
			aConteud [len(aConteud),nCol] 	:= VEZ->(FieldGet(Fieldpos(_cCampo))) //Sd.Ant
			//			aConteud [len(aConteud),nCol+1] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Debito
			//			aConteud [len(aConteud),nCol+2] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Credito
			//			aConteud [len(aConteud),nCol+3] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Movimento
			//			aConteud [len(aConteud),nCol+4] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Saldo Atual
			
		Case IKK = 12
			nCol := 52
			_cCampo :=VEZ->(field(IKK))
			aConteud [len(aConteud),nCol] 	:= VEZ->(FieldGet(Fieldpos(_cCampo))) //Sd.Ant
			//			aConteud [len(aConteud),nCol+1] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Debito
			//			aConteud [len(aConteud),nCol+2] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Credito
			//			aConteud [len(aConteud),nCol+3] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Movimento
			//			aConteud [len(aConteud),nCol+4] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Saldo Atual
			
		Case IKK = 13
			nCol := 57
			_cCampo :=VEZ->(field(IKK))
			aConteud [len(aConteud),nCol] 	:= VEZ->(FieldGet(Fieldpos(_cCampo))) //Sd.Ant
			//			aConteud [len(aConteud),nCol+1] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Debito
			//			aConteud [len(aConteud),nCol+2] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Credito
			//			aConteud [len(aConteud),nCol+3] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Movimento
			//			aConteud [len(aConteud),nCol+4] := VEZ->(FieldGet(Fieldpos(_cCampo))) //Saldo Atual
			
			
			
	endcase
next

//Abrindo Tabela com o conteudo a ser transferido para o Array / Csv
dbUseArea(.T.,,"BAL.dbf","MX",.F.,.F.)
//Cria indice
DbClearIndex()
Index on CONTA TO "BAL" //Criando indice

ProcRegua(RecCount())

do While MX->(!eof())
	incproc()
	aAdd(aConteud,{"","",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) //63 colunas linha vazia
	For JI:=1 To MX->(Fcount())
		_cCampo :=MX->(field(JI))
		aConteud [len(aConteud),JI] := mx->(FieldGet(Fieldpos(_cCampo)))
	Next
	MX->(dbSkip())
enddo
//apos a montagem da planilha devera ser zerado o contador de vezes
if !file( "VEZ.DBF" )
	aadd(aEst,{"NVEZ"		,"N",02,0})
	cArqVez := CriaTrab(aEst,.T.)
	dbUseArea(.T.,,cArqVez,"VEZ",.F.,.F.)
	RecLock("VEZ",.T.)
	VEZ->NVEZ := 0
	VEZ->(msUnlock("VEZ") )
	Copy To &("VEZ.DBF")
	//else
	//	dbUseArea(.T.,,"VEZ.DBF","VEZ",.F.,.F.)
endif
//VEZ->(dbCloseArea())

nCab := 1
aDir := MDirArq()
If Empty(aDir[1]) .OR. Empty(aDir[2])
	Return
Else
	Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
	If lOk
		MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
	EndIf
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
Local nHdl,nt,jk := 0

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

//			If !l132
//				nTotMov := nTotMov + (nGrpCrd - nGrpDeb)
//				If Round(NoRound(nTotMov,3),2) < 0
//					ValorCTB(nTotMov,li  ,aColunas[COL_MOVIMENTO],17      ,nDecimais,.T.   ,cPicture,"1"  ,      ,     ,      ,          ,          ,lPrintZero)
//					ValorCtb(nSaldo ,nLin,nCol                   ,nTamanho,nDecimais,lSinal,cPicture,cTipo,cConta,lGraf,oPrint,cTipoSinal, cIdentifi,lPrintZero,lSay)
//				ElseIf Round(NoRound(nTotMov,3),2) > 0
//					ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
//				EndIf
//				@ li,aColunas[COL_SEPARA7] PSAY "|"
//			Endif
