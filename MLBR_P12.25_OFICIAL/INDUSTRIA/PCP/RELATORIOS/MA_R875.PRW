#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"
#INCLUDE "TOPCONN.CH"

#define STR0001 "Relacao para Analise dos Estoques"
#define STR0002 "Este relatório demonstra a situaçäo de cada item da estrutura"
#define STR0003 "do produto Pai em relaçäo ao seu saldo , seu empenho , suas  "
#define STR0004 "entradas previstas e sua classe ABC."
#define STR0005 "Zebrado"
#define STR0006 "Administracao"
#define STR0007 "PRODUTO(S)"
#define STR0008  "CODIGO          DESCRICAO                      TP GRUP UM    SALDO ATUAL   EMPENHO PARA           SC's           PC's           OP's           PV's     PONTO DE         LOTE   PRAZO EST.EM       CONSUMO   ULTIMA   CL  TP"
#define STR0009 "                                                                         REQ/PV/RESERVA      COLOCADAS      COLOCADOS      COLOCADAS      COLOCADOS       PEDIDO    ECONOMICO ENTREGA  MESES         MEDIO    SAIDA      N/F"
#define STR0010 "CANCELADO PELO OPERADOR"
#define STR0011 "PRODUTO PAI: "
#define STR0012 "  SALDO ATUAL  ---> "
#define STR0013 "T O T A I S  :"
#define STR0014 "Produto Pai"
#define STR0015 "SCs Colocadas"
#define STR0016 "PCs Colocados"
#define STR0017 "OPs Colocadas"
#define STR0018 "PVs Colocados"
#define STR0019 "Estruturas"
#define STR0020 "Produtos"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	MA_R875
// Autor 		Alexandre Dalpiaz
// Data 		24/05/10
// Descricao  	Customização do relatório MATR875 - Help-Desk 000789
//				(Relacao para Analise dos Estoques) ou necessidade de criar novo relatório.
// Uso         	Midori Atlantica
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MA_R875()
///////////////////////

Private oReport
PRIVATE cPerg 	:= "MAMTR875  "
PRIVATE _cEnter := chr(13) + chr(10)
ValidPerg()

If FindFunction("TRepInUse") .And. TRepInUse()
	oReport:= ReportDef()
	oReport:PrintDialog()
Else
	MATR875R3()
EndIf

Return NIL

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ReportDef()
///////////////////////////
Local oReport
Local oSection1    // Secao 1
Local oSection2    // Secao 2
Local oSection3    // Secao 3
Local cTitle    := "Relacao para Analise dos Estoques"
Local cAliasSG1 := "QRYSG1"
cAliasSG1   := GetNextAlias()
lQuery 		:= .t.

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
fErase(__RelDir + 'MA_R875.PRT')
oReport:= TReport():New("MA_R875",cTitle,"MAMTR875", {|oReport| ReportPrint(oReport,cAliasSG1, .t.)},OemToAnsi(STR0002)+" "+OemToAnsi(STR0003)+" "+OemToAnsi(STR0004)) //##"Este relat¢rio demonstra a situa‡„o de cada item da estrutura"##"do produto Pai em rela‡„o ao seu saldo , seu empenho , suas  "##"entradas previstas e sua classe ABC."
oReport:SetPortrait() 	//Define a orientacao de pagina do relatorio como retrato
oReport:SetEdit(.f.) 	//Não permite alterações pelo usuario

Pergunte(oReport:GetParam(),.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao das secoes utilizadas pelo relatorio                            ³
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
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ oSection1 (Impressao Produto Pai)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport,"Estruturas",{"SG1","SB1","SB2"},/*Ordem*/)
oSection1:SetHeaderBreak()
oSection1:SetHeaderPage()

TRCell():New(oSection1,'G1_COD' 	,'QRYSG1', 'CÓDIGO'  		, '@!'				,  6 , /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'DESCPAI' 	,'QRYSG1', 'DESCRIÇÃO'		, '@!'				, 60 , /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'GRUPOPAI'  	,'QRYSG1', 'GRUPO'			, '@!'				,  4 , /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'TIPOPAI' 	,'QRYSG1', 'TIPO'			, '@!'				,  2 , /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'DISPONIVEL'	,'QRYSG1', 'SALDO ATUAL' 	, '@E 999,999.9999'	, 12 , /*lPixel*/,/*{|| code-block de impressao }*/)
oSection1:SetNoFilter({})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ oSection2 (Impressao Componentes)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1,"Produtos",{"SG1","SB1","SB2"},/*Ordem*/)

TRCell():New(oSection2,'G1_COMP'	,'QRYSG1', 'CÓDIGO'			, '@!'				,  6 , /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'DESCFILHO'	,'QRYSG1', 'DESCRIÇÃO'		, '@!'				, 60 , /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'GRUPOFILHO'	,'QRYSG1', 'GRUPO'			, '@!'				,  4 , /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'TIPOFILHO'	,'QRYSG1', 'TIPO'			, '@!'				,  2 , /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B2_QATU'   	,'QRYSG1', 'SALDO ATUAL'	, '@E 999,999.9999'	, 12 , /*lPixel*/,/*{|| code-block de impressao }*/)
oSection2:SetNoFilter({"SB2"})
oSection2:lHeaderSection := .f.

oSection3 := TRSection():New(oSection1,"Produtos",{"SG1","SB1","SB2"},/*Ordem*/)

TRCell():New(oSection3,'G1_COMP'	,'QRYSG1', 'CÓDIGO'			, '@!'				,  6 , /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'DESCPAI'	,'QRYSG1', 'DESCRIÇÃO'		, '@!'				, 60 , /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'GRUPOPAI'	,'QRYSG1', 'GRUPO'			, '@!'				,  4 , /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'TIPOPAI'	,'QRYSG1', 'TIPO'			, '@!'				,  2 , /*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'_nAtual'   	,        , 'SALDO ATUAL'	, '@E 999,999.9999'	, 12 , /*lPixel*/,{|| R875SldAtu() })
oSection3:SetNoFilter({"SB2"})
oSection3:lHeaderSection := .f.

Return(oReport)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ReportPrint(oReport,cAliasSG1)
/////////////////////////////////////////////////////
Local oSection1  := oReport:Section(1)
Local oSection2  := oReport:Section(1):Section(1)
Local oSection3  := oReport:Section(1):Section(2)

MakeSqlExpr(oReport:GetParam())

_nLastRec := Query97()
DbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatorio                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter(_nLastRec)
oSection1:Init()

///////////
/////////// impressão de after market
///////////

_lImpAF := .f.
Do While  !oReport:Cancel() .And. !QRYSG1->(Eof()) .and. at('AF',QRYSG1->GRUPOPAI) > 0
	_lImpAF := .t.
	oReport:IncMeter()
	oSection1:PrintLine() // Impressao da secao 1
	dbSkip()
EndDo
If _lImpAF
	oReport:FatLine()
	oReport:SkipLine()
EndIf

///////////
/////////// impressão de produtos acabados com estrutura
///////////
_lImpGrp := .f.
Do While !oReport:Cancel() .And. !QRYSG1->(Eof()) .and. QRYSG1->GRUPOPAI == QRYSG1->GRUPOFILHO
	_lImpGrp := .t.
	
	oSection1:PrintLine() // Impressao da secao 1
	oReport:ThinLine()
	_cCod   := QRYSG1->G1_COD
	oSection2:Init()
	Do While !eof() .and. _cCod == QRYSG1->G1_COD
		oReport:IncMeter()
		oSection2:PrintLine() // Impressao da secao 2
		dbSkip()
	EndDo
	oReport:FatLine()
	oSection2:Finish()
	oReport:SkipLine()
	
EndDo

If _lImpAF
	oReport:FatLine()
EndIf

///////////
/////////// impressão de produtos acabados SEM estrutura
///////////
Do While  !oReport:Cancel() .And. !QRYSG1->(Eof()) .and. QRYSG1->GRUPOPAI <> QRYSG1->GRUPOFILHO
	
	_cCod   := QRYSG1->G1_COD
	oSection3:Init()
	/*
	_nAtual := 0
	SB2->(DbSeek(xFilial('SB2') + QRYSG1->G1_COD,.f.))
	Do While SB2->(!eof()) .and. SB2->B2_FILIAL + SB2->B2_COD == xFilial('SB2') + QRYSG1->G1_COD
	_nAtual += SB2->B2_QATU
	SB2->(DbSkip())
	EndDo
	*/
	oSection3:PrintLine() // Impressao da secao 2
	Do While !eof() .and. _cCod == QRYSG1->G1_COD
		oReport:IncMeter()
		DbSkip()
	EndDo
	oSection3:Finish()
	
EndDo
oSection1:Finish()
oReport:FatLine()

Return Nil

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function MATR875R3()
////////////////////////////
LOCAL titulo 	:= "Relacao para Analise dos Estoques"
LOCAL cString  	:= "SG1"
LOCAL wnrel 	:= "MA_TR875"
LOCAL cDesc1   	:= "Este relat¢rio demonstra a situa‡„o de cada item da estrutura"
LOCAL cDesc2   	:= "do produto Pai em rela‡„o ao seu saldo , seu empenho , suas  "
LOCAL cDesc3   	:= "entradas previstas e sua classe ABC."
LOCAL Tamanho  	:= "M"
LOCAL i			:= 0

PRIVATE aReturn	:= {"Zebrado",1,"Administracao", 1, 2, 1, "",1 }
PRIVATE nLastKey:= 0

pergunte(cPerg,.F.)
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho,.f.)

If nLastKey == 27
	Set Filter To
	Return
Endif

fErase(__RelDir + wnrel + '.##R')
SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| R875Imp(@lEnd,wnRel,titulo,tamanho,cString)},titulo)

Return NIL

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function R875Imp(lEnd,wnRel,titulo,tamanho,cString)
//////////////////////////////////////////////////////////
LOCAL cRodaTxt := "PRODUTO(S)"
Local i			:= 0

PRIVATE nomeprog := "MA_TR875"
PRIVATE nTipo    := 0
PRIVATE cabec1,cabec2
PRIVATE nCntImpr := 0
PRIVATE li := 80 ,m_pag := 1

cabec1 := "CODIGO   DESCRICAO                                                   GRUPO TP  SALDO ATUAL"
cabec2 := ''

_nLastRec := Query97()
SetRegua(_nLastRec)

///////////
/////////////// impressão dos after-market
///////////
_lImpAF := .f.
Do While !eof() .and. at('AF',QRYSG1->GRUPOPAI) > 0
	_lImpAF := .t.
	IncRegua()
	
	If lEnd
		@ PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	EndIf
	
	If li > 58
		Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
	EndIf
	_cLinha := left(QRYSG1->G1_COD,6) + ' - ' + QRYSG1->DESCPAI + ' ' + QRYSG1->GRUPOPAI + ' '
	_cLinha += QRYSG1->TIPOPAI + ' ' + transform(QRYSG1->DISPONIVEL,'@E 999,999.9999')
	@   li++,000 PSAY _cLinha
	DbSkip()
EndDo
If _lImpAF
	@ li++,000 PSAY __PrtThinLine()
EndIf

///////////
/////////// impressão de produtos acabados com estrutura
///////////
_lImpGrp := .f.
Do While !eof() .and. QRYSG1->GRUPOPAI == QRYSG1->GRUPOFILHO
	
	_lImpGrp := .t.
	If li > 58
		Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
	EndIf
	_cLinha := left(QRYSG1->G1_COD,6) + ' - ' + QRYSG1->DESCPAI + ' ' + QRYSG1->GRUPOPAI + ' '
	_cLinha += QRYSG1->TIPOPAI + ' ' + transform(QRYSG1->DISPONIVEL,'@E 999,999.9999')
	@   li,000 PSAY _cLinha
	@ ++li,000 PSAY __PrtThinLine()
	
	_cCod := QRYSG1->G1_COD
	Do While !eof() .and. _cCod == QRYSG1->G1_COD
		
		IncRegua()
		
		If lEnd
			@ PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		EndIf
		
		If li > 58
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
		EndIf
		
		_cLinha := left(QRYSG1->G1_COMP,6) + ' - ' + QRYSG1->DESCFILHO + ' ' + QRYSG1->GRUPOFILHO + ' '
		_cLinha += QRYSG1->TIPOFILHO + ' ' + transform(QRYSG1->B2_QATU,'@E 999,999.9999')
		@ ++li,000 PSAY _cLinha
		
		DbSkip()
		
	EndDo
	@ ++li,000 PSAY __PrtThinLine()
	++li
	
EndDo

///////////
/////////// impressão de produtos acabados SEM estrutura
///////////
_lImpGrp := .f.
Do While !eof() .and. QRYSG1->GRUPOPAI <> QRYSG1->GRUPOFILHO
	
	_lImpGrp := .t.
	If li > 58
		Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
	EndIf
	
	_nAtual := 0
	SB2->(DbSeek(xFilial('SB2') + QRYSG1->G1_COD,.f.))
	Do While SB2->(!eof()) .and. SB2->B2_FILIAL + SB2->B2_COD == xFilial('SB2') + QRYSG1->G1_COD
		_nAtual += SB2->B2_QATU
		SB2->(DbSkip())
	EndDo
	
	_cLinha := left(QRYSG1->G1_COD,6) + ' - ' + QRYSG1->DESCPAI + ' ' + QRYSG1->GRUPOPAI + ' '
	_cLinha += QRYSG1->TIPOPAI + ' ' + transform(_nAtual,'@E 999,999.9999')
	@   ++li,000 PSAY _cLinha
	
	_cCod := QRYSG1->G1_COD
	Do While !eof() .and. _cCod == QRYSG1->G1_COD
		IncRegua()
		DbSkip()
	EndDo
	
EndDo
@ ++li,000 PSAY __PrtThinLine()

DbCloseArea()
If li != 80
	Roda(_nLastRec,cRodaTxt,Tamanho)
EndIf

If aReturn[5] == 1
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return NIL


////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Query97
///////////////////////
_cGrupos := ''
_cGrpAF  := ''
mv_par05 := alltrim(mv_par05+',')

Do While !empty(mv_par05)
	_nPosic := at(',',mv_par05)
	_xGrupo := alltrim(left(mv_par05,_nPosic-1))+ ','
	If at('AF',_xGrupo) > 0
		_cGrpAF += _xGrupo
	Else
		_cGrupos += _xGrupo
	EndIf
	mv_par05 := substr(mv_par05,_nPosic+1)
EndDo

_cGrupos := left(_cGrupos,len(_cGrupos)-1)
_cGrpAF  := left(_cGrpAF ,len(_cGrpAF) -1)

_cQuery := "SELECT G1_FILIAL, G1_COD, PAI.B1_DESC DESCPAI, ISNULL(DISPONIVEL,0) DISPONIVEL, PAI.B1_GRUPO GRUPOPAI, PAI.B1_TIPO TIPOPAI,"
_cQuery += _cEnter + " G1_COMP, FILHO.B1_DESC DESCFILHO, FILHO.B1_GRUPO GRUPOFILHO, FILHO.B1_TIPO TIPOFILHO, B2_QATU"
_cQuery += _cEnter + " FROM " + RetSqlName('SG1') + " SG1"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SB1') + " PAI"
_cQuery += _cEnter + " ON PAI.D_E_L_E_T_ <> '*'"
_cQuery += _cEnter + " AND PAI.B1_COD = G1_COD"
_cQuery += _cEnter + " AND PAI.B1_GRUPO IN " +  FormatIn(alltrim(_cGrupos),',') + ""
_cQuery += _cEnter + " AND PAI.B1_TIPO = '" +  mv_par06 + "'"

_cQuery += _cEnter + " INNER JOIN  " + RetSqlName('SB1') + " FILHO"
_cQuery += _cEnter + " ON FILHO.D_E_L_E_T_ <> '*'"
_cQuery += _cEnter + " AND FILHO.B1_COD = G1_COMP"

_cQuery += _cEnter + " LEFT JOIN  " + RetSqlName('SB2') + " SB2"
_cQuery += _cEnter + " ON SB2.D_E_L_E_T_ <> '*'"
_cQuery += _cEnter + " AND B2_COD = G1_COMP"
_cQuery += _cEnter + " AND B2_FILIAL = G1_FILIAL"

_cQuery += _cEnter + " LEFT JOIN ("

_cQuery += _cEnter + " SELECT G1_FILIAL FILIAL, G1_COD PRODUTO, min(B2_QATU) DISPONIVEL"
_cQuery += _cEnter + " FROM  " + RetSqlName('SG1') + " SG1"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SB1') + " SB1"
_cQuery += _cEnter + " ON SB1.D_E_L_E_T_ <> '*'"
_cQuery += _cEnter + " AND SB1.B1_COD = G1_COD"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SB2') + " SB2"
_cQuery += _cEnter + " ON SB2.D_E_L_E_T_ <> '*'"
_cQuery += _cEnter + " AND B2_COD = G1_COMP"
_cQuery += _cEnter + " AND B2_FILIAL = G1_FILIAL"

_cQuery += _cEnter + " WHERE SG1.D_E_L_E_T_ <> '*'"
_cQuery += _cEnter + " AND G1_FILIAL = '" + xFilial('SG1') + "'"
_cQuery += _cEnter + " AND G1_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
_cQuery += _cEnter + " AND G1_COD BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
_cQuery += _cEnter + " AND G1_NIV = '01'"

_cQuery += _cEnter + " GROUP BY G1_FILIAL, G1_COD"

_cQuery += _cEnter + " ) DISPO"
_cQuery += _cEnter + " ON FILIAL = G1_FILIAL"
_cQuery += _cEnter + " AND PRODUTO = G1_COD"

_cQuery += _cEnter + " WHERE SG1.D_E_L_E_T_ <> '*'"
_cQuery += _cEnter + " AND G1_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
_cQuery += _cEnter + " AND G1_COD BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
_cQuery += _cEnter + " AND G1_NIV = '01'"

_cQuery += _cEnter + " UNION

_cQuery += _cEnter + " SELECT B2_FILIAL G1_FILIAL, B2_COD G1_COD, SB1.B1_DESC DESCPAI,"
_cQuery += _cEnter + " B2_QATU DISPONIVEL, SB1.B1_GRUPO GRUPOPAI, SB1.B1_TIPO TIPOPAI,"
_cQuery += _cEnter + "  '' G1_COMP, '' DESCFILHO, '' GRUPOFILHO, '' TIPOFILHO, B2_QATU"
_cQuery += _cEnter + "  FROM SB1010 SB1, SB2010 SB2"

_cQuery += _cEnter + " WHERE SB1.D_E_L_E_T_ <> '*'"
_cQuery += _cEnter + " AND B1_COD BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
_cQuery += _cEnter + "  AND B1_GRUPO IN " + FormatIn(_cGrpAF,',')
_cQuery += _cEnter + "  AND SB2.D_E_L_E_T_ <> '*'"
_cQuery += _cEnter + "  AND B2_COD = B1_COD"
_cQuery += _cEnter + " AND B2_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"

_cQuery += _cEnter + "  ORDER BY G1_FILIAL, PAI.B1_GRUPO, G1_COD, G1_COMP"

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,_cQuery), 'QRYSG1', .F., .T.)

MemoWrit("c:\spool\sql\ma_r875.sql", _cQuery)

dbSelectArea("QRYSG1")
count to _nLastRec
DbGoTop()

Return(_nLastRec)


/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
Local j, i
///////////////////////////

cAlias := Alias()
aPerg  := {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd( aPerg , {cPerg, "01", "Filial de                          ", "","", "mv_ch1", "C",  2 , 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "SM0", "", "SMO",""})
aAdd( aPerg , {cPerg, "02", "Filial até                         ", "","", "mv_ch2", "C",  2 , 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "SM0", "", "SMO",""})
aAdd( aPerg , {cPerg, "03", "Produto de                         ", "","", "mv_ch3", "C", 15 , 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "SB1", "", "SB1",""})
aAdd( aPerg , {cPerg, "04", "Produto até                        ", "","", "mv_ch4", "C", 15 , 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "SB1", "", "SB1",""})
aAdd( aPerg , {cPerg, "05", "Grupos (separados por vírgula)	    ", "","", "mv_ch5", "C", 60 , 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "SBM", "", "SBM",""})
aAdd( aPerg , {cPerg, "06", "Tipo                               ", "","", "mv_ch6", "C",  2 , 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "02", "", "02",""})

DbSelectArea("SX1")
DbSetOrder(1)
For i:=1 to Len(aPerg)
	RecLock("SX1",!DbSeek(cPerg + aPerg[i,2]))
	For j:=1 to FCount()
		If j <= Len(aPerg[i]) .and. !(left(alltrim(FieldName(j)),6) $ 'X1_PRE/X1_CNT')
			FieldPut(j,aPerg[i,j])
		EndIf
	Next
	MsUnlock()
Next

DbSelectArea(cAlias)
Return

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/// calcula o saldo atual do produto SEM estrutura de todos os almoxarifados da filial
/// chamado por codigo de bloco na definição da seção 3
/////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function R875SldAtu()
////////////////////////////
_cCod   := QRYSG1->G1_COD
_nAtual := 0
SB2->(DbSeek(xFilial('SB2') + QRYSG1->G1_COD,.f.))
Do While SB2->(!eof()) .and. SB2->B2_FILIAL + SB2->B2_COD == xFilial('SB2') + QRYSG1->G1_COD
	_nAtual += SB2->B2_QATU
	SB2->(DbSkip())
EndDo
Return(_nAtual)
