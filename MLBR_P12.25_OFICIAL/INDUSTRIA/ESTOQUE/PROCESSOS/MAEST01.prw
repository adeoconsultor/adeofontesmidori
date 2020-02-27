#INCLUDE "PROTHEUS.CH"
//Constantes da funcao
#DEFINE 	 CCOMP 		1
#DEFINE	 CQUANT 	2
#DEFINE	 CQTSEGUM 	3
#DEFINE	 CRATEIO 	4
#DEFINE	 CLOTECTL	5
#DEFINE	 CNUMLOTE	6
#DEFINE	 CDTVALID 	7
#DEFINE	 CLOCALIZ 	8
#DEFINE	 CNUMSERI 	9
#DEFINE  CCUSTO07   5
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³          ³ Autor ³ Bruno M. Mota         ³ Data ³05/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Consultor de Neg ³Contato ³ bmassarelli@taggs.com.br       ³±±
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
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MAEST01()
// Variaveis Locais da Funcao
Local cAlDes	 	:= Space(02)
Local cNomProd		:= Space(60)
Local cAlOrig	 	:= Space(02)
Local cDescProd	 	:= Space(15)
Local cDoc	 		:= Space(9)
Local cEnd	 		:= Space(15)
Local cLote	 		:= Space(10)
Local cNumSeri	 	:= Space(20)
Local cSubLote	 	:= Space(6)
Local cTME          := Space(3)
Local cTMD			:= Space(3)
Local cCC			:= Space(11)
Local dVldLote	 	:= CtoD("/ /")
Local nPotencia	 	:= 0
Local nQtdDes	 	:= 0
Local nQtdDes2	 	:= 0
Local nRadioGrp1 	:= 1 // O padrão do radio button será componentes
Local nOpc 			:= 0
Local lGeraPV		:= .T.
Local oNomProd
Local oAlDes
Local oAlOrig
Local oDescProd
Local oDoc
Local oEnd
Local oLote
Local oNumSeri
Local oPotencia
Local oQtdDes
Local oQtdDes2
Local oRadioGrp1
Local oSubLote
Local oVldLote
Local oGeraPV
Local oTME
Local oTMD
Local oCC
// Variaveis Private da Funcao
Private lDesAuto 	:= .T.
Private nStru		:= 0		//Variavel utilizada pela Estrut2
Private oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL 		:= .F.                        
Private INCLUI 		:= .F.                        
Private ALTERA 		:= .F.                        
Private DELETA 		:= .F.                        
//Seta ordem da SD3
SD3->(dbSetOrder(2))
//Seta ordem da SF5
SF5->(dbSetOrder(1))
//Chama a funcao de criar parametros
CriaPar({"MV_MAEST1","MV_MAEST2"})
//Atribui os parametros de movimentos internos as variaveis
cTME := GetMv(PadR("MV_MAEST1",10))
cTMD := GetMv(PadR("MV_MAEST2",10))
//Monta interface com o usuario
DEFINE MSDIALOG oDlg TITLE "Desmontagem Automática" FROM C(198),C(401) TO C(519),C(1041) PIXEL

	// Cria as Groups do Sistema
	@ C(002),C(003) TO C(158),C(316) LABEL "" PIXEL OF oDlg
	@ C(027),C(009) TO C(156),C(228) LABEL "Dados da desmontagem" PIXEL OF oDlg

	// Cria Componentes Padroes do Sistema
	// Cria Componentes Padroes do Sistema
	@ C(010),C(009) Say "Este programa realiza a desmontagem de kits de acordo com a estrutura cadastrada para o mesmo no sistema, de acordo com a quantidade informada pelo usuário." Size C(299),C(015) COLOR CLR_BLUE PIXEL OF oDlg
	@ C(037),C(234) TO C(082),C(308) LABEL "Desmontagem em:" PIXEL OF oDlg
	@ C(041),C(237) Radio oRadioGrp1 Var nRadioGrp1 Items "Componentes","Peças" 3D Size C(047),C(010) PIXEL OF oDlg
	@ C(037),C(013) Say "Produto Pai:" Size C(034),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(037),C(051) MsGet oDescProd Var cDescProd F3 "SB1" Size C(060),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(050),C(013) Say "Desc. Prod:" Size C(032),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(050),C(051) MsGet oNomProd Var cNomProd Size C(162),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(037),C(121) Say "Qtd. Desmontar:" Size C(041),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(037),C(163) MsGet oQtdDes Var nQtdDes Size C(051),C(009) COLOR CLR_BLACK Picture "@E 999,999,999.99" PIXEL OF oDlg
	@ C(064),C(013) Say "Qtd. 2da UN:" Size C(036),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(064),C(051) MsGet oQtdDes2 Var nQtdDes2 Size C(060),C(009) COLOR CLR_BLACK Picture "@E 999,999,999.99" PIXEL OF oDlg
	@ C(064),C(121) Say "Documento:" Size C(030),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(064),C(163) MsGet oDoc Var cDoc Size C(051),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(080),C(013) Say "Lote:" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(080),C(051) MsGet oLote Var cLote Size C(060),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(080),C(121) Say "Sub-Lote:" Size C(027),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(080),C(163) MsGet oSubLote Var cSubLote Size C(051),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(095),C(121) Say "Potência:" Size C(024),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(097),C(163) MsGet oPotencia Var nPotencia Size C(051),C(009) COLOR CLR_BLACK Picture "@E 999,999,999.99" PIXEL OF oDlg
	@ C(097),C(013) Say "Vld. Lote:" Size C(028),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(097),C(051) MsGet oVldLote Var dVldLote Size C(060),C(009) COLOR CLR_BLACK Picture "@D 99/99/99" PIXEL OF oDlg
	@ C(112),C(013) Say "Endereço:" Size C(027),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(112),C(051) MsGet oEnd Var cEnd Size C(060),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(112),C(121) Say "Num. Série:" Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(112),C(163) MsGet oNumSeri Var cNumSeri Size C(051),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(128),C(013) Say "Arm. Org.:" Size C(027),C(009) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(128),C(040) MsGet oAlOrig Var cAlOrig Size C(019),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(128),C(062) Say "Mov. Req.:" Size C(028),C(009) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(128),C(091) MsGet oTME Var cTME F3 "SF5" Size C(023),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(128),C(116) Say "Arm. Dest.:" Size C(028),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(128),C(146) MsGet oAlDes Var cAlDes Size C(019),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(128),C(169) Say "Mov. Dev.:" Size C(029),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(128),C(199) MsGet oTMD Var cTMD F3 "SF5" Size C(022),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(143),C(013) Say "Centro Custo:" Size C(046),C(007) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(143),C(051) MsGet oCC Var cCC F3 "CTT" Size C(060),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg	
	@ C(130),C(234) CheckBox oGeraPV Var lGeraPV Prompt "Gera Ped. Vendas" Size C(056),C(008) PIXEL OF oDlg
	DEFINE SBUTTON FROM C(088),C(234) TYPE 1 ENABLE OF oDlg ACTION {||nOpc := 1,oDlg:End()}
	DEFINE SBUTTON FROM C(107),C(234) TYPE 2 ENABLE OF oDlg ACTION {||oDlg:End()}

	// Cria ExecBlocks dos Componentes Padroes do Sistema
	oDescProd:bValid    := {|| ExistCpo("SB1",cDescProd) }
	oDescProd:bChange	:= {|| cNomProd := Posicione("SB1",1,xFilial("SB1")+cDescProd,"B1_DESC") }
	oQtdDes:bValid     	:= {|| IIf(nQtdDes > 0,.T.,.F.) }
	oQtdDes2:bValid     := {|| IIf(nQtdDes2 >= 0,.T.,.F.) }
	oDoc:bValid     	:= {|| IIf(Empty(cDoc) .Or. SD3->(dbSeek(xFilial("SD3")+cDoc)),.F.,.T.) }	
	oLote:bValid     	:= {|| VldLote(cDescProd,cLote) }
	oSubLote:bValid     := {|| VldSubLote(cDescProd,cSubLote) }
	oEnd:bValid     	:= {|| VldEnd(cDescProd,cEnd) }
	oNumSeri:bValid     := {|| VldEnd(cDescProd,cEnd) }
	oTME:bValid     	:= {|| IIf(ExistCpo("SF5",cTME) .And. AllTrim(cTME) > "500",.T.,.F.)}	
	oTMD:bValid     	:= {|| IIf(ExistCpo("SF5",cTMD) .And. AllTrim(cTMD) < "500",.T.,.F.)}	
	oCC:bValid	     	:= {|| ExistCpo("CTT",cCC) }		
	oTMD:bWhen			:= {|| .F.}
	oTME:bWhen			:= {|| .F.}
	oNomProd:bWhen		:= {|| .F.}	
//	oAlOrig:bValid     	:= {|| VldAl(cDescProd,cAlOrig) }
//	oAlDes:bValid     	:= {|| VldAl(cDescProd,cAlDes) }	
	
ACTIVATE MSDIALOG oDlg CENTERED 
//Valida opcao
If nOpc == 1
	//Processa desmontagem
	Processa({||Desmonta(cDescProd,nQtdDes,nRadioGrp1,cAlDes,cAlOrig,cDoc,cEnd,cLote,cNumSeri,cSubLote,dVldLote,nPotencia,nQtdDes2,lGeraPV,cTME,cTMD,cCC)})
	//Mensagem de conclusao
	APMsgInfo("Processo concluído com sucesso.")
EndIf	
//Retorno da funcao	
Return(.T.)
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcao responsavel pela desmontagem dos produtos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
Static Function Desmonta(cDescProd,nQtdDes,nRadioGrp1,cAlDes,cAlOrig,cDoc,cEnd,cLote,cNumSeri,cSubLote,dVldLote,nPotencia,nQtdDes2,lGeraPV,cTME,cTMD,cCC)
//Variaveis locais da funcao
Local aCabec	:= {} 
Local aLinhas	:= {}
Local cArqNome 	:= ""
Local cNivel	:= ""
Local lRet		:= .F.
Local nX		:= 0
Local nCustoPr	:= 0
Local nCustoFl	:= 0
//Variaveis privadas da função
Private aAux		:= {}
Private lMsErroAuto := .F.
Private nEstru		:= 0
Private nRat		:= 0
//Inicio da funcao
//Cria area de trabalho com a estrutura do produto
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ Estrut2  ³ Rev.  ³ Marcelo Pimentel      ³ Data ³ 24/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Faz a explosao de uma estrutura a partir do SG1            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ Estrut2(ExpC1,ExpN1,ExpC2,ExpC3)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN1 = Quantidade a ser explodida                         ³±±
±±³          ³ ExpC2 = Alias do arquivo de trabalho                       ³±±
±±³          ³ ExpC3 = Nome do arquivo criado                             ³±±
±±³          ³ ExpL1 = Monta a Estrutura exatamente como se ve na tela    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observa‡„o³ Como e uma funcao recursiva precisa ser criada uma variavel³±±
±±³          ³ private nEstru com valor 0 antes da chamada da fun‡„o.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
//Regua do arquivo temporario
dbSelectArea('SG1')
dbSetOrder(1)

dbSelectArea('SD3')
dbSetOrder(1)

ProcRegua(50)
//Campos de retorno da rotina :ESTRUT->NIVEL,  ESTRUT->CODIGO,   ESTRUT->COMP,   ESTRUT->QUANT,   ESTRUT->TRT

cArqNome := Estrut2(cDescProd,nQtdDes)
//Monta variavel verificadora do nivel a ser utilizado
IIf(nRadioGrp1 == 1,cNivel := "000001",cNivel := "000002")
//Posiciona no primeiro registro da estrutura
ESTRUT->(dbGoTop())
//Monta o array que sera utilizado como parametro pela msexecauto, realizando tratamentos.
While !ESTRUT->(EoF())
	//Verifica o nivel é o escolhido pelo usuário 
	If ESTRUT->NIVEL <> cNivel
		//Muda de registro
		ESTRUT->(dbSkip())
	//Verifica se a quantidade é inteira ou menor que 1
	ElseIf (ESTRUT->NIVEL == cNivel) .And. ((ESTRUT->QUANT <> Round(ESTRUT->QUANT,0)) .Or. (ESTRUT->QUANT < 1))
		//Muda de registro
		ESTRUT->(dbSkip())
	Else
		//Monta array com os dados 	
		//"D3_COD","D3_QUANT","D3_QTSEGUM","D3_RATEIO","D3_LOTECTL","D3_NUMLOTE","D3_DTVALID","D3_LOCALIZ","D3_NUMSERI"
//        AAdd(aAux,{ESTRUT->COMP,ESTRUT->QUANT,0,0,,,,,,})
        AAdd(aAux,{ESTRUT->COMP,ESTRUT->QUANT,0,0,Posicione('SB2',1,xFilial('SB2')+ESTRUT->COMP+cAlDes,"B2_CM1")})        
		//Muda de registro
		ESTRUT->(dbSkip())
		//Ajusta flag de verificacao
        lRet := .T.                                                                           	
    EndIf
    //Adiciona regua
    IncProc("Processando arquivo temporario...")
EndDo
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³FimEstrut2³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 04/02/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Encerra arquivo utilizado na explosao de uma estrutura     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ FimEstrut2(ExpC1,ExpC2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do Arquivo de Trabalho                       ³±±
±±³          ³ ExpC2 = Nome do Arquivo de Trabalho                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
//Finaliza a tabela ESTRUT
FimEstrut2(,cArqNome)						
//Verifica se a rotina gerou algum item no array principal
If !lRet
	//Envia mensagem de alerta
	Alert("Não foi possível gerar a estrutura para o produto! Por favor, verifique o código inserido nos parametros.")
	//Retorno da rotina
	Return()
EndIf	
//Monta variavel com a diferença da porcentagem do rateio
nRat := 0
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tirar documentação quando utilizar custo proporcional³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
/*
//Seta ordem da SB2
SB2->(dbSetOrder(1))
//Posiciona no custo do produto principal na SB2
SB2->(dbSeek(xFilial("SB2")+cDescProd+cAlOrig))
//Seta valor do produto principal
nCustoPr := SB2->B2_CM1
//Loop para montagem da diferença
For nX := 1 to Len(aAux)
	//Posiciona no produto filho
	SB2->(dbSeek(xFilial("SB2")+aAux[nX][CCOMP]+cAlOrig))
	//Calcula rateio
	aAux[nX][CRATEIO] :=  (SB2->B2_CM1*100)/nCustoPr
	//Monta a diferença d rateio
	nRat +=	aAux[nX][CRATEIO]
Next nX
*/
//Loop para montagem da diferença
For nX := 1 to Len(aAux)
	nRat += (100/Len(aAux))       
Next nX 
//Termina montagem do valor com a diferença se existir
nRat := 100-nRat
//Chama rotina de validação dos itens da desmontagem
//VldItem(aAux)
//Monta o cabeçalho de acordo com os parametros informados na tela principal
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa rotina por desmontagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
/*
aCabec := {{"cProduto"		,cDescProd	,NIL},;
			{"nQtdOrig"		,nQtdDes	,NIL},;
			{"nQtdOrigSe"	,nQtdDes2	,NIL},;
			{"cLocOrig"		,cAlOrig	,NIL},;
			{"cDocumento"	,cDoc		,NIL},;
			{"cLocaliza"	,cEnd		,NIL},;
			{"cLoteDigi"	,cLote		,NIL},;
			{"cNumLote"		,cSubLote	,NIL},;
			{"cNumSerie"	,cNumSeri	,NIL},;
			{"dDtValid"		,dVldLote	,NIL},;
			{"nPotencia"	,nPotencia	,NIL}}
//Monta array de linhas da msexecauto
For nX := 1 to Len(aAux)
	//Adiciona valor ao array
	AAdd(aLinhas,{{	"D3_COD"		, aAux[nX][CCOMP]		, Nil},;
					{"D3_LOCAL"  	, cAlDes				, Nil},;
					{"D3_QUANT"  	, aAux[nX][CQUANT]		, Nil},;
					{"D3_RATEIO" 	, aAux[nX][CRATEIO]		, Nil},;
					{"D3_QTSEGUM"	, aAux[nX][CQTSEGUM]	, Nil}})
//					{"D3_LOTECTL"	, aAux[nX][CLOTECTL]	, Nil},;
//					{"D3_NUMLOTE"	, aAux[nX][CNUMLOTE]	, Nil},;
//					{"D3_DTVALID"	, aAux[nX][CDTVALID]	, Nil},;
//					{"D3_LOCALIZ"	, aAux[nX][CLOCALIZ]	, Nil},;
//					{"D3_NUMSERI"  	, aAux[nX][CNUMSERI]	, Nil}})
	//Incrementa regua
	IncProc("Processando itens...")
Next nX
//Incrementa regua
IncProc("Processando desmontagem...")
//Executa Msexecauto
MSExecAuto({|v,x,y,z| Mata242(v,x,y,z)},aCabec,aLinhas,3,.T.)
//Verifica se houve erro
If lMsErroAuto
	//Mostra o erro
	Mostraerro()
EndIf
*/
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa rotina por TM³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
//Executa movimento de saída
aCabec := {{"D3_TM"			,cTME													,NIL},;
			{"D3_COD"		,cDescProd												,NIL},;
			{"D3_UM"		,Posicione("SB1",1,xFilial("SB1")+cDescProd,"B1_UM")	,NIL},;
			{"D3_QUANT"		,nQtdDes												,NIL},;
			{"D3_LOCAL"		,cAlOrig												,NIL},;
			{"D3_DOC"		,cDoc													,NIL},;
			{"D3_EMISSAO"	,dDatabase												,NIL},;			
			{"D3_CC"		,cEnd													,NIL}}
//Incrementa regua
IncProc("Processando desmontagem...")
//Executa Msexecauto
MSExecAuto({|x,y| Mata240(x,y)},aCabec,3,.T.)
//Verifica se houve erro
If lMsErroAuto
	//Mostra o erro
	Mostraerro()
	//Mensagem indicando onde ocoreu o problema
	Alert("Ocorreu um erro na saída do produto pai")
	//Retorno da rotina
	Return()
EndIf
//Monta movimento de entrada
aCabec := {	{"D3_DOC"		,Soma1(cDoc)		,NIL},;
			{"D3_TM"		,cTMD			,NIL},;
			{"D3_CC"		,cCC			,NIL},;			
			{"D3_EMISSAO"	,dDatabase		,NIL}}
//Monta array de linhas da msexecauto
For nX := 1 to Len(aAux)
	//Adiciona valor ao array
	AAdd(aLinhas,{{	"D3_COD"		, aAux[nX][CCOMP]		, Nil},;
					{"D3_LOCAL"  	, cAlDes				, Nil},;
					{"D3_QUANT"  	, aAux[nX][CQUANT]		, Nil},;
					{"D3_CC"		, cCC					, NIL},;								
					{"D3_QTSEGUM"	, aAux[nX][CQTSEGUM]	, Nil},;
					{"D3_CUSTO1"    , iif(aAux[nX][CCUSTO07] > 0, aAux[nX][CCUSTO07] * aAux[nX][CQUANT],1)	, Nil}})
					
	//Incrementa regua
	IncProc("Processando itens da desmontagem...")
Next nX
//Executa Msexecauto
MSExecAuto({|x,y,z| Mata241(x,y,z)},aCabec,aLinhas,3,.T.)
//Verifica se houve erro
If lMsErroAuto
	//Mostra o erro
	Mostraerro()
	//Mensagem indicando onde ocoreu o problema
	Alert("Ocorreu um erro na entrada do produto filho.")
	//Retorno da rotina
	Return()
EndIf	
//Verifica se pocessa pedido de venda
If lGeraPV
	//gera pedido de venda
	GeraPed(cCC)
EndIf	
//Retorno da rotina
Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³          ³ Autor ³ Bruno M. Mota         ³ Data ³10/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Consultor de Neg ³Contato ³ bmassarelli@taggs.com.br       ³±±
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
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VldItem(aItem)
// Variaveis Locais da Funcao
// Variaveis Private da Funcao
Private oDlg2				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.                        
Private INCLUI := .F.                        
Private ALTERA := .F.                        
Private DELETA := .F.                        
// Privates das ListBoxes
Private aListBox1 := {}
Private oListBox1

DEFINE MSDIALOG oDlg2 TITLE "Dados dos Itens da desmontagem" FROM C(328),C(347) TO C(575),C(883) PIXEL

	// Cria as Groups do Sistema
	@ C(000),C(000) TO C(120),C(265) LABEL "" PIXEL OF oDlg2

	// Cria Componentes Padroes do Sistema
	@ C(009),C(005) Say " Por favor, ajuste as informações referentes aos produtos resultantes da desmontagem." Size C(255),C(008) COLOR CLR_BLUE PIXEL OF oDlg2
	DEFINE SBUTTON FROM C(102),C(117) TYPE 1 ENABLE OF oDlg2 ACTION {|| IIf(VldArray(aListBox1),oDlg2:End(),"")}

	// Cria ExecBlocks dos Componentes Padroes do Sistema

	// Chamadas das ListBox do Sistema
	fListBox1(aItem)

ACTIVATE MSDIALOG oDlg2 CENTERED 

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³fListBox1() ³ Autor ³ Bruno M. Mota         ³ Data ³10/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Montagem da ListBox                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fListBox1(aItem)
Local nX

	// Carrega o array da Listbox
	For nX := 1 To Len(aItem)
		//Adiciona dados no array
		Aadd(aListBox1,{aAux[nX][CCOMP],aAux[nX][CQUANT],aAux[nX][CQTSEGUM],IIf(nX == 1,((100/Len(aAux))+nRat),((100/Len(aAux))))})
//		Aadd(aListBox1,{aAux[nX][CCOMP],aAux[nX][CQUANT],aAux[nX][CQTSEGUM],IIf(nX == 1,((100/Len(aAux))+nRat),((100/Len(aAux)))),aAux[nX][CLOTECTL],aAux[nX][CNUMLOTE],aAux[nX][CDTVALID],aAux[nX][CLOCALIZ],aAux[nX][CNUMSERI]})
		/*BEGINDOC
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Utilizar linha abaixo no custo proporcional³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ENDDOC*/
		//Aadd(aListBox1,{aAux[nX][CCOMP],aAux[nX][CQUANT],aAux[nX][CQTSEGUM],IIf(nX == 1,aAux[nX][CRATEIO]+nRat,aAux[nX][CRATEIO])})
	Next nX

//		HEADER "Componente","Quantidade","Qtd. 2a UM","Rateio %","Lote","Sub-Lote","vld. Lote","Endereço","Nro. Serie";
//		ColSizes 50,50,50,50,50,50,50,50
	@ C(022),C(005) ListBox oListBox1 Fields ;
		HEADER "Componente","Quantidade","Qtd. 2a UM","Rateio %";
		Size C(255),C(075) Of oDlg2 Pixel;
		ColSizes 50,50,50,50
	oListBox1:SetArray(aListBox1)

	// Cria ExecBlocks das ListBoxes
	oListBox1:bLDblClick := {|| EditCell(oListBox1:ColPos) }
	oListBox1:bLine := {||			{;
		aListBox1[oListBox1:nAT,01],;
		aListBox1[oListBox1:nAT,02],;
		aListBox1[oListBox1:nAT,03],;
		aListBox1[oListBox1:nAT,04]}}		
//		aListBox1[oListBox1:nAT,05],;
//		aListBox1[oListBox1:nAT,06],;
//		aListBox1[oListBox1:nAT,07],;
//		aListBox1[oListBox1:nAT,08],;
//		aListBox1[oListBox1:nAT,09]}}		

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³EditCell()  ³ Autor ³ Bruno M. Mota         ³ Data ³10/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Edia celula da listbox                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function EditCell(nPos)
//Variaveis locais da funcao
//Inicio da funcao
//Verfica a posição da coluna
If (nPos == 1) .Or. (nPos == 5) .Or. (nPos == 6) .Or. (nPos == 8) .Or. (nPos == 9)
	//edita a celula com picture de caracter
	lEditCell( aListBox1, oListBox1, "@!", oListBox1:ColPos )          
Elseif	(nPos == 2) .Or. (nPos == 3)
	//edita a celula com picture de numerica
	lEditCell( aListBox1, oListBox1, "@E 999,999,999,999.99", oListBox1:ColPos )          
Elseif	(nPos == 4)
	//edita a celula com picture de data
	lEditCell( aListBox1, oListBox1, "@E 999.99", oListBox1:ColPos )        	
Elseif	(nPos == 7)
	//edita a celula com picture de %
	lEditCell( aListBox1, oListBox1, "@D", oListBox1:ColPos )        		
EndIf
//Retorno da rotina
Return() 

#INCLUDE "PROTHEUS.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³          ³ Autor ³ Bruno M. Mota         ³ Data ³13/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Consultor de Neg ³Contato ³                                ³±±
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
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GeraPed(cCC)
// Variaveis Locais da Funcao
Local cCliente	 	:= Space(6)
Local cCondPag	 	:= Space(3)
Local cLoja	 		:= Space(2)
Local cTES	 		:= Space(3)
Local cTESPvc       := Space(3) //Exclusivo para Pedido com 2 TES (PNP2)
Local cTabPrc       := Space(3)
Local cTpCli	 	:= CriaVar("A1_TIPO",.F.)
Local cNum			:= ""
Local aCabPV		:= {}
Local aItemPV		:= {} //Vai gerar pedido de venda de itens que nao for couro - ITENS
Local aItemPVC      := {} //Vai gerar pedido de venda de couro - ITENS
Local aTpCli		:= {"Cons.Final","Prod.Rural","Revendedor","Solidario","Exportacao/Importacao"}
Local nOpc 			:= 0
Local nPrcVen       := 1
Local cTpCli
Local oCliente
Local oCondPag
Local oLoja
Local oTES
Local oTESPvc
Local oTabPrc
Local oTpCli
Local lCouro := .F.                                  
Local nContC   := 0
Local nContPvc := 0
Local nIc, nX

// Variaveis Private da Funcao
Private FormPV				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.                        
Private INCLUI := .F.                        
Private ALTERA := .F.                        
Private DELETA := .F.                        
//inicio da funcao
//Seta ordem SA1
SA1->(dbSetOrder(1))
//Monta interface com o usuário
DEFINE MSDIALOG FormPV TITLE "Dados do Pedido de Vendas" FROM C(219),C(476) TO C(424),C(856) PIXEL

	// Cria as Groups do Sistema
	@ C(000),C(003) TO C(100),C(186) LABEL "" PIXEL OF FormPV
	@ C(007),C(007) TO C(024),C(182) LABEL "" PIXEL OF FormPV
	@ C(026),C(007) TO C(094),C(182) LABEL "Dados Gerais PV" PIXEL OF FormPV

	// Cria Componentes Padroes do Sistema
	@ C(013),C(010) Say "Por favor, digite as informações que compõem o pedido de vendas." Size C(224),C(008) COLOR CLR_BLUE PIXEL OF FormPV
	@ C(038),C(012) Say "Cliente:" Size C(019),C(008) COLOR CLR_BLACK PIXEL OF FormPV
	@ C(038),C(033) MsGet oCliente Var cCliente F3 "SA1" Size C(034),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF FormPV
	@ C(038),C(077) Say "Loja:" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF FormPV
	@ C(038),C(092) MsGet oLoja Var cLoja Size C(019),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF FormPV
	@ C(038),C(121) Say "Cond. Pag.:" Size C(032),C(008) COLOR CLR_BLACK PIXEL OF FormPV
	@ C(038),C(153) MsGet oCondPag Var cCondPag F3 "SE4" Size C(023),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF FormPV
	@ C(055),C(012) Say "Tipo Cliente:" Size C(032),C(008) COLOR CLR_BLACK PIXEL OF FormPV
	@ C(055),C(036) ComboBox cTpCli Items aTpCli Size C(060),C(010) PIXEL OF FormPV
//	@ C(055),C(113) Say "TES Itens:" Size C(028),C(008) COLOR CLR_BLACK PIXEL OF FormPV	
	@ C(055),C(095) Say "TES Couro:" Size C(028),C(008) COLOR CLR_BLACK PIXEL OF FormPV
//	@ C(055),C(139) MsGet oTES Var cTES F3 "SF4" Size C(021),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF FormPV
	@ C(055),C(118) MsGet oTES Var cTES F3 "SF4" Size C(021),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF FormPV
	@ C(055),C(140) Say "TES PVC:" Size C(028),C(008) COLOR CLR_BLACK PIXEL OF FormPV
	@ C(055),C(158) MsGet oTESPvc Var cTESPvc F3 "SF4" Size C(021),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF FormPV

	@ C(072),C(012) Say "Tabela Preço:" Size C(028),C(008) COLOR CLR_BLACK PIXEL OF FormPV
	@ C(072),C(042) MsGet oTabPrc Var cTabPrc F3 "DA0" Size C(021),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF FormPV
	
	
	
	DEFINE SBUTTON FROM C(080),C(077) TYPE 1 ENABLE OF FormPV ACTION {||nOpc := 1,FormPV:End()}
	DEFINE SBUTTON FROM C(080),C(122) TYPE 2 ENABLE OF FormPV ACTION {||FormPV:End()}

	// Cria ExecBlocks dos Componentes Padroes do Sistema
	oCliente:bValid     := {|| ExistCpo("SA1",cCliente) }
	oCliente:bChange	:= {|| cLoja := SA1->A1_LOJA}
//	oLoja:bValid     	:= {|| IIf(Empty(cLoja) .Or. !SA1->(dbSeek(xFilial("SA1")+cLoja)),.F.,.T.) }
	oLoja:bValid     	:= {|| IIf(Empty(cLoja),.F.,.T.) }
	oCondPag:bValid     := {|| ExistCpo("SE4",cCondPag) }
	oTES:bValid		    := {|| ExistCpo("SF4",cTES) }  
	oTESPvc:bValid      := {|| ExistCpo("SF4",cTESPvc) }
	oTabPrc:bValid      := {|| ExistCpo("DA0",cTabPrc) }
	

ACTIVATE MSDIALOG FormPV CENTERED 
//Verifica a opçao do usuario
If nOpc == 1
	//Monta o numero do PV
//	cNum := GetSX8Num("SC5","C5_NUM")     
	cNum := GETSXENUM("SC5","C5_NUM")
	//Vertifica tipo de cliente
	Do Case
		Case cTpCli == "Cons.Final"
			cTpCli := "F"
		Case cTpCli == "Prod.Rural"
			cTpCli := "R"
		Case cTpCli == "Revendedor"
			cTpCli := "R"
		Case cTpCli == "Solidario"
			cTpCli := "S"
		Case cTpCli == "Exportacao/Importacao"
			cTpCli := "X"
	EndCase	
	//Monta dados da msexecauto (cabeçalho)
	aCabPV := {{"C5_NUM"		,cNum						,NIL},;
				{"C5_TIPO"		,"N"						,NIL},;
				{"C5_CLIENTE"	,cCliente					,NIL},;
				{"C5_LOJACLI"	,cLoja						,NIL},;				
				{"C5_CONDPAG"	,cCondPag					,NIL},;
				{"C5_TIPOCLI"	,cTpCli						,NIL}}

	//Monta a variavel de itens do PV                      
	cItem := ""
	For nX := 1 To Len(aAux)
		//Adiciona dados ao array 
		if nx < 10
			cItem := '0'+cvaltochar(nx)
		elseif nx < 100
			cItem := cvaltochar(nx)
		else 
			cItem := U_incItem(nx)
		endif
		
		//Rotina para identificar se o produto é couro 
		for nIc := 1 to Len(Posicione("SB1",1,xFilial("SB1")+aAux[nX][CCOMP],"B1_DESC"))
			if Substr(Posicione("SB1",1,xFilial("SB1")+aAux[nX][CCOMP],"B1_DESC"),nIc,5)=='COURO'
				lCouro :=.T.
			endif
		next                                           
		//Rotina para buscar o valor unitário da mercadoria.
		dbSelectArea('DA1')
		dbSetOrder(1)
		if dbSeek(xFilial('DA1')+cTabPrc+aAux[nX][CCOMP])
			nPrcVen := DA1->DA1_PRCVEN
		endif
		if lCouro 
			AAdd(aItemPVC,{  {"C6_ITEM"      ,cItem, 				,NIL},;
							{"C6_PRODUTO"	,aAux[nX][CCOMP]		,NIL},;
							{"C6_QTDVEN"	,aAux[nX][CQUANT]		,NIL},;
							{"C6_PRCVEN"	,nPrcVen		   			,NIL},;
							{"C6_VALOR"		,Round(aAux[nX][CQUANT]*nPrcVen,2)	,NIL},;						
							{"C6_TES"		,cTES					,NIL}}) 
			nContC++
		else
		
			AAdd(aItemPV,{  {"C6_ITEM"      ,cItem, 				,NIL},;
							{"C6_PRODUTO"	,aAux[nX][CCOMP]		,NIL},;
							{"C6_QTDVEN"	,aAux[nX][CQUANT]		,NIL},;
							{"C6_PRCVEN"	,nPrcVen		   			,NIL},;
							{"C6_VALOR"		,Round(aAux[nX][CQUANT]*nPrcVen,2)	,NIL},;						
							{"C6_TES"		,cTESPvc					,NIL}}) 

			nContPvc++
		endif   
		lCouro := .F.                               
		nPrcVen := 1
	Next nX
	//Incrementa regua
	IncProc("Processando pedido de vendas...")
	//Executa Msexecauto
	if nContPvc > 0
	MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabPV,aItemPV,3)
	//Verifica se houve erro
	If lMsErroAuto
		//Mostra o erro
		Mostraerro()
		RollBackSX8()
	Else
		//Mostra numero do pedido criado
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial("SC6")+cNum)
		while !SC6->(eof()).and.SC6->C6_NUM == cNum
			RecLock("SC6",.F.)
				SC6->C6_CCUSTO := cCC
			MsUnLock("SC6")
			SC6->(dbSkip())
			IncProc("Atualizando Centro de Custo..."+cCC+" Produto: "+SC6->C6_PRODUTO)
		enddo
			Alert("Numero do Pedido de Vendas Materia Prima: "+cNum)
		EndIf                                              
	EndIf
	//Confirma Numeração
	ConfirmSX8()


 	//Gera o pedido de venda de couros....

	//Monta dados da msexecauto (cabeçalho)
	if nContC > 0 
		cNum := GETSXENUM("SC5","C5_NUM")
		aCabPV := {}
		aCabPV := {{"C5_NUM"		,cNum						,NIL},;
					{"C5_TIPO"		,"N"						,NIL},;
					{"C5_CLIENTE"	,cCliente					,NIL},;
					{"C5_LOJACLI"	,cLoja						,NIL},;				
					{"C5_CONDPAG"	,cCondPag					,NIL},;
					{"C5_TIPOCLI"	,cTpCli						,NIL}}

		
			MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabPV,aItemPVC,3)
		
			//Verifica se houve erro
			If lMsErroAuto
				//Mostra o erro
				Mostraerro()
				RollBackSX8()
			Else
				//Mostra numero do pedido criado
				dbSelectArea("SC6")
				dbSetOrder(1)
				dbSeek(xFilial("SC6")+cNum)
				while !SC6->(eof()).and.SC6->C6_NUM == cNum
					RecLock("SC6",.F.)
					SC6->C6_CCUSTO := cCC
					MsUnLock("SC6")
					SC6->(dbSkip())
					IncProc("Atualizando Centro de Custo..."+cCC+" Produto: "+SC6->C6_PRODUTO)
				enddo
				Alert("Numero do Pedido de Vendas Materia Prima: "+cNum)
			EndIf                                              
	endif
	
	//Confirma Numeração
	ConfirmSX8()
EndIf
//Retorno da rotina
Return(.T.)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³VldArray    ³ Autor ³ Bruno M. Mota         ³ Data ³10/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Valida array alterado                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VldArray(aItem)
//Variaveis locais da funcao
Local nRateio 	:= 0
Local lret		:= .F.
Local nX
//Inicio da funcao
For nX := 1 To len(aItem)
	//Soma os valores do rateio
	nRateio += aItem[nX][CRATEIO]
Next nX
//Verfica se é igual a 100%
If nRateio == 100
	//Retorno verdadeiro
	lRet := .T.	
	//Ajusta array auxiliar
	aAux := aListBox1
Else
	//Mensagem de alerta
	Alert("O total do rateio dos itens é diferente de 100%")
Endif
//Retorno da funcao
Return(lRet)	
	
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³VldLote  ³ Autor   ³ Bruno Massarelli Mota  ³ Data ³10/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por validar se o produto escolhido pelo   ³±±
±±³           ³ usuário é passivel de controle de lote.                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VldLote(cProduto,cLote)
//Variaveis locais da funcao
Local lRet := .T.
//Inicio da função
//Seta ordem da SB1
SB1->(dbSetOrder(1))
//Posiciona SB1
If SB1->(dbSeek(xFilial("SB1")+cProduto))
	//Verfica se esta configurado para uso de lote
	If SB1->B1_RASTRO == "N" .And. !Empty(cLote)
		//Mensagem de alerta
		Alert("Este produto não utiliza controle de lote!")
		//Reconfigura retorno
		lRet := .F.
	ElseIf 	SB1->B1_RASTRO == "S" .And. Empty(cLote)
		//Mensagem de alerta
		Alert("Este produto utiliza controle de sub-lote!")
		//Reconfigura retorno
		lRet := .F.
	ElseIf 	SB1->B1_RASTRO == "L" .And. Empty(cLote)
		//Mensagem de alerta
		Alert("Este produto utiliza controle de lote!")
		//Reconfigura retorno
		lRet := .F.
	EndIf
EndIf
//Retorno da funcao
Return(lRet)	


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³VldSubLot³ Autor   ³ Bruno Massarelli Mota  ³ Data ³10/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por validar se o produto escolhido pelo   ³±±
±±³           ³ usuário é passivel de controle de sub-lote.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VldSubLote(cProduto,cSubLote)
//Variaveis locais da funcao
Local lRet := .T.
//Inicio da função
//Seta ordem da SB1
SB1->(dbSetOrder(1))
//Posiciona SB1
If SB1->(dbSeek(xFilial("SB1")+cProduto))
	//Verfica se esta configurado para uso de lote
	If SB1->B1_RASTRO == "N" .And. !Empty(cSubLote)
		//Mensagem de alerta
		Alert("Este produto não utiliza controle de sub-lote!")
		//Reconfigura retorno
		lRet := .F.
	ElseIf 	SB1->B1_RASTRO == "L" .And. !Empty(cSubLote)
		//Mensagem de alerta
		Alert("Este produto não utiliza controle de sub-lote!")
		//Reconfigura retorno
		lRet := .F.
	ElseIf 	SB1->B1_RASTRO == "S" .And. Empty(cSubLote)
		//Mensagem de alerta
		Alert("Este produto utiliza controle de sub-lote!")
		//Reconfigura retorno
		lRet := .F.
	EndIf
EndIf
//Retorno da funcao
Return(lRet)	

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³VldEnd   ³ Autor   ³ Bruno Massarelli Mota  ³ Data ³10/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por validar se o produto escolhido pelo   ³±±
±±³           ³ usuário é passivel de controle de endereços.                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VldEnd(cProduto,cEnd)
//Variaveis locais da funcao
Local lRet := .T.
//Inicio da função
//Seta ordem da SB1
SB1->(dbSetOrder(1))
//Posiciona SB1
If SB1->(dbSeek(xFilial("SB1")+cProduto))
	//Verfica se esta configurado para uso de lote
	If SB1->B1_LOCALIZ == "N" .And. !Empty(cEnd)
		//Mensagem de alerta
		Alert("Este produto não utiliza controle de endereços!")
		//Reconfigura retorno
		lRet := .F.
	ElseIf 	SB1->B1_LOCALIZ == "S" .And. Empty(cEnd)
		//Mensagem de alerta
		Alert("Este produto utiliza controle de endereços!")
		//Reconfigura retorno
		lRet := .F.
	EndIf
EndIf
//Retorno da funcao
Return(lRet)	


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³VldEnd   ³ Autor   ³ Bruno Massarelli Mota  ³ Data ³10/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por validar se o produto escolhido pelo   ³±±
±±³           ³ usuário é passivel de controle de endereços.                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VldAl(cProduto,cAl)
//Variaveis locais da funcao
Local lRet := .T.
//Inicio da função
//Seta ordem da SB1
SB9->(dbSetOrder(1))
//Posiciona SB1
If !SB9->(dbSeek(xFilial("SB9")+cProduto+cAl))
	//Mensagem de alerta
	Alert("Este produto não foi localizado no armazém selecionado!")
	//Reconfigura retorno
	lRet := .F.
EndIf
//Retorno da funcao
Return(lRet)	

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³CriaPar  ³ Autor   ³ Bruno Massarelli Mota  ³ Data ³10/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por criara os parametros que contem o va- ³±±
±±³           ³ lor dos movimentos internos.                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CriaPar(aPar)
Local nX
//Posiciona SX6
For nX := 1 To Len(aPar)
	//Verifica se ja existe o parametro
	If SX6->(dbSeek(xFilial("SX6")+PadR(aPar[nX],10)))
		//Muda de registro
		Loop
	Else
		//Trava SX6
		SX6->(RecLock("SX6",.T.))
			SX6->X6_FIL 		:= xFilial("SX6")
			SX6->X6_VAR 		:= PadR(aPar[nX],10)
			SX6->X6_TIPO 		:= "C"
			//Verfica se e entrada ou saida
			If AllTrim(aPar[nX]) == "MV_MAEST1"
				SX6->X6_DESCRIC	:= "Destermina a saida padrao para desmontagem aut."
				SX6->X6_DSCSPA	:= "Destermina a saida padrao para desmontagem aut."
				SX6->X6_DSCENG	:= "Destermina a saida padrao para desmontagem aut."			
				SX6->X6_CONTEUD 	:= "508"
				SX6->X6_CONTSPA 	:= "508"
				SX6->X6_CONTENG 	:= "508"
			ElseIf	AllTrim(aPar[nX]) == "MV_MAEST2"
				SX6->X6_DESCRIC	:= "Destermina a entrada padrao para desmontagem aut."   
				SX6->X6_DSCSPA	:= "Destermina a entrada padrao para desmontagem aut."
				SX6->X6_DSCENG	:= "Destermina a entrada padrao para desmontagem aut."				
				SX6->X6_CONTEUD 	:= "007"
				SX6->X6_CONTSPA 	:= "007"
				SX6->X6_CONTENG 	:= "007"
			EndIf	
			SX6->X6_PROPRI := "N"
		//Libera SX6
		SX6->(MsUnlock())	
	EndIf
Next nX
//Retorno da rotina
Return()			
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)                                                         
/*
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           */
		nTam *= 1.28                                                               
//	EndIf                                                                         
                                                                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
	//³Tratamento para tema "Flat"³                                               
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)                                                                

user function incItem(nx)
local nItem:= nx - 99
local cAlfa1:= "9"
local cAlfa2:= ""           
local cAlfa := ""
Do Case
	Case nItem > 27 .and. nItem <= 52
		nItem := nItem - 27
		cAlfa1:="A"
	Case nItem > 52 .and. nItem  <= 78
		nItem := nItem - 52
		cAlfa1:="B"
	Case nItem > 78 .and. nItem  <= 104
		nItem := nItem - 78
		cAlfa1:="C"
	Case nItem > 104 .and. nItem  <= 130
		nItem := nItem - 104
		cAlfa1:="D"
	Case nItem > 130 .and. nItem  <= 156
		nItem := nItem - 130
		cAlfa1:="E"
	Case nItem > 156 .and. nItem  <= 182
		nItem := nItem - 156
		cAlfa1:="F"
	Case nItem > 182 .and. nItem  <= 208
		nItem := nItem - 182
		cAlfa1:="G"
	Case nItem > 208 .and. nItem  <= 234
		nItem := nItem - 208
		cAlfa1:="H"         
	Case nItem > 234 .and. nItem  <= 260
		nItem := nItem - 234
		cAlfa1:="I"
	Case nItem > 260 .and. nItem  <= 286
		nItem := nItem - 260
		cAlfa1:="J"
	Case nItem > 286 .and. nItem  <= 312
		nItem := nItem - 286
		cAlfa1:="K"
EndCase
		
Do Case
	Case nItem == 1
		cAlfa2:= "A"
	Case nItem == 2
		cAlfa2:= "B"
	Case nItem == 3
		cAlfa2:= "C"
	Case nItem == 4
		cAlfa2:= "D"
	Case nItem == 5
		cAlfa2:= "E"
	Case nItem == 6
		cAlfa2:= "F"
	Case nItem == 7
		cAlfa2:= "G"
	Case nItem == 8
		cAlfa2:= "H"
	Case nItem == 9
		cAlfa2:= "I"
	Case nItem == 10
		cAlfa2:= "J"
	Case nItem == 11
		cAlfa2:= "K"
	Case nItem == 12
		cAlfa2:= "L"
	Case nItem == 13
		cAlfa2:= "M"
	Case nItem == 14
		cAlfa2:= "N"
	Case nItem == 15
		cAlfa2:= "O"
	Case nItem == 16
		cAlfa2:= "P"
	Case nItem == 17
		cAlfa2:= "Q"
	Case nItem == 18
		cAlfa2:= "R"
	Case nItem == 19
		cAlfa2:= "S"
	Case nItem == 20
		cAlfa2:= "T"
	Case nItem == 21
		cAlfa2:= "U"
	Case nItem == 22
		cAlfa2:= "V"
	Case nItem == 23
		cAlfa2:= "W"
	Case nItem == 24
		cAlfa2:= "X"
	Case nItem == 25
		cAlfa2:= "Y"
	Case nItem == 26
		cAlfa2:= "Z"
	EndCase
	cAlfa:= cAlfa1+cAlfa2
return cAlfa
