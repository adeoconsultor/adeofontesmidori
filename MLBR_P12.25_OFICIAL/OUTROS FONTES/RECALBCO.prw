#INCLUDE "PROTHEUS.CH"

Static lFWCodFil := .T.
Static __lSchedule  := FWGetRunSchedule() 

#define STR0001  "Confirma"
#define STR0002  "Redigita"
#define STR0003 "Abandona"
#define STR0004 "Reconciliaçäo de Saldos Bancários "
#define STR0005 "Este programa tem como objetivo recalcular e analisar os saldos   "
#define STR0006 "Bancários dia a dia de um determinado período até a data base do    "
#define STR0007 "sistema. Utilizando no caso de haver necessidade de retroagir a     "
#define STR0008 "movimentaçäo bancária. Use como referência a data em que o saldo    "
#define STR0009 "ficou defasado. "
#define STR0010 "O  objetivo  deste  programa é o de recalcular os saldos "
#define STR0011 "Bancários  dia a dia  de um  determinado periodo até a data base "
#define STR0012 "do sistema. Utilizado no caso de haver necessidade de retroagir "
#define STR0013 "a movimentaçäo bancária. Use como referência a data em que "
#define STR0014 "o saldo ficou defasado. Pressione qualquer tecla para continuar. "
#define STR0015 "Selecionando Registros..."
#define STR0016 "Nao sao permitidos recalculos de saldos bancarios "
#define STR0017 "de data anterior a data contida no parametro MV_DATAFIN"
#define STR0018 "Parâmetros"
#define STR0019 "Visualizar"
#define STR0020 "Operador não tem acesso a todas às Filiais."
#define STR0021	"O Saldo do banco não considerará movimentos das filiais negadas. "  
#define STR0022	"Operador não tem acesso as Filiais Informadas nos parâmetros. "

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Fina210  ³ Autor ³ Wagner Xavier         ³ Data ³ 01.12.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Recalcula os saldos bancarios dentro de um determinado     ³±±
±±³          ³ periodo                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinA210(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			ATUALIZACOES SOFRIDAS                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Claudio  ³13/07/00³xxxxxx³ Retirar todas as chamadas a WriteSx2       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RECALBCO(lDireto)

Local lPanelFin := IsPanelFin()
LOCAL nOpca	:=0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL aSays:={}, aButtons:={}
LOCAL cProcessa := ""
Local cFunction:= "FINA210"
Local cTitle:= STR0004
Local bProcess
Local cDescription:= STR0005 + STR0006 + STR0007 + STR0008 + STR0009
Local cPerg:="FIN210"
Local oProcess

//--- Tratamento Gestao Corporativa
Local lGestao   := Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
//
Local cFilFwSE8 := IIF( lGestao, FwFilial("SE8") , xFilial("SE8") )
Local cFilFwSA6 := IIF( lGestao, FwFilial("SA6") , xFilial("SA6") )

DEFAULT lDireto := .F.

Private cCadastro := OemToAnsi(STR0004)  //"Reconcilia‡„o de Saldos Banc rios"
Private lFA210SE5 := ExistBlock("FA210SE5")
Private lFA210SE8 := ExistBlock("FA210SE8")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o log de processamento                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If IsBlind() .Or. lDireto
	ProcLogIni( aButtons )
	
	cProcessa := "X210Processa(.T.)"
	
	ProcLogAtu("INICIO")
	BatchProcess(	cCadastro, 	STR0005 + Chr(13) + Chr(10) +;
										STR0006 + Chr(13) + Chr(10) +;
										STR0007 + Chr(13) + Chr(10) +;
										STR0008 + Chr(13) + Chr(10) +;
										STR0009, "FINA210",;
						{ || &cProcessa }, { || .F. })
	ProcLogAtu("FIM")
	Return .T.
Endif

oProcess := tNewProcess():New( cFunction, cTitle, {|oSelf| FA210NewPerg ( oSelf ) }, cDescription, cPerg )

If lPanelFin  //Chamado pelo Painel Financeiro
	dbSelectArea(FinWindow:cAliasFile)
	FinVisual(FinWindow:cAliasFile,FinWindow,(FinWindow:cAliasFile)->(Recno()),.T.)
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA210NewPergºAutor³ALvaro Camillo Neto º Data ³  05/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tratamento para a utilização do tNewProcess                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA210NewPerg( oSelf )

Local lFilsUsr	:= FindFunction("FilsUsr")
Local cFils		:= ""

Private lUsAllFls	:= .T.

//*************************************************************************************************
// Solucao | Multi filial | A6 | E5 | E8 | Descricao                                              *
//     1   |     Sim      | E  | E  | E  | Rodar Multi filial filtrando filial no A6, E5          *
//     2   |     Sim      | E  | E  | C  | Normal com filial do A6 e no E5 de '  ' ate 'ZZ'       *
//     3   |     Sim      | E  | C  | E  | Rodar Multi filial filtrando filial no A6 e E5_FILORI  *
//         |     Sim      | E  | C  | C  | Idem a Solucao 2                                       *
//         |     Sim      | C  | E  | E  | Idem a Solucao 1                                       *
//         |     Nao      | C  | E  | C  | Idem a Solucao 2                                       *
//         |     Sim      | C  | C  | E  | Idem a Solucao 3                                       *
//     4   |     Nao      | C  | C  | C  | Rodar Normal sem filtro                                *
//*************************************************************************************************

If lFilsUsr
	lUsAllFls := FilsUsr(MV_PAR09, MV_PAR10, @cFils)
EndIf

If lUsAllFls
	If MV_PAR08 == 1 .And. ( !Empty(FwFilial("SE8")) .or. !Empty(FwFilial("SA6")) )
		FA210FIL( MV_PAR09, MV_PAR10, .F. , oSelf )
	Else
		X210Processa(.F.,oSelf)
	EndIf
Else
	If Empty(cFils)
		Help(" ", 1, "NOFIL", NIL, STR0022, 1, 0)		//"Operador não tem acesso as Filiais Informadas nos parâmetros."
	Else
		Help(" ",1,"FILSACS",,STR0020+; //"Operador não tem acesso a todas às Filiais."
										STR0021,1,0) //"O Saldo do banco não considerará movimentos das filiais negadas."
		X210Processa(.F.,oSelf,,cFils)
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA210Fil ºAutor  ³Alvaro Camillo Neto º Data ³  21/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Executa o processamento para cada filial                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA210                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA210Fil(cFilDe,cFilAte,lAuto,oSelF)

Local cFilIni 	:= cFIlAnt
Local aArea		:= GetArea()
Local nInc		:= 0
Local aSM0		:= AdmAbreSM0()

For nInc := 1 To Len( aSM0 )
	If aSM0[nInc][1] == cEmpAnt .AND. aSM0[nInc][2] >= cFilDe .and. aSM0[nInc][2] <= cFilAte
		cFilAnt := aSM0[nInc][2]

		oSelf:SaveLog( "MENSAGEM: EXECUTANDO A APURACAO DA FILIAL " + cFilAnt)
		
		X210Processa(lAuto,oSelF,nInc == 1)
	EndIf
Next

cFIlAnt := cFilIni
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Fa210pro ³ Autor ³ Wagner Xavier         ³ Data ³ 09.03.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Recalcula os saldos bancarios dentro de um determinado     ³±±
±±³          ³ periodo para versao TopConnect                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ X210Processa()                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function X210Processa( lBat, oSelf,lFirst, cFils )

LOCAL nSaldoIni, nEntradas
LOCAL nSaidas, nData
LOCAL cQuery
LOCAL dDataMovto
Local nSalRecIni := 0   //Saldo Reconciliado Inicial
Local nEntrRec 	:= 0		//Entrada ja conciliada
Local nSaidRec 	:= 0		//Saida ja conciliada
Local lCxLoja  	:= GetNewPar("MV_CXLJFIN",.F.)
Local cTabela14 := ""
Local cFilTRB := ""
Local cFilSE8,cFilSE82 := ""
Local nTamFilSE5 := 0
Local nTamFilSE8 := 0
Local lComp		:= FwModeAccess("SE8",3) == "C" .And. FwModeAccess("SE5",3) == "E"  // Verifico o compartilhamento das duas tabelas apenas uma vez para melhorar o desempenho 
Local lAreaRest := .F.
Local cChaveSE5 := ""
Local aAreaAtu  := {}
//Controle para verificações no caso da tabela SE5 possuir um compartilhamento superior a SE8
Local cFilSE5 := ""
Local cFilAux,cData   := ""
Local bBncFilIgl := { || ( ( Substr(TRB210->E5_FILIAL,1,nTamFilSE8)+TRB210->E5_BANCO+TRB210->E5_AGENCIA+TRB210->E5_CONTA == Substr(cFilSE8,1,nTamFilSE8)+cBanco+cAgencia+cConta ) .Or. ( lSolucao3 .And. Empty( TRB210->E5_FILIAL ) .And. TRB210->E5_BANCO+TRB210->E5_AGENCIA+TRB210->E5_CONTA == cBanco+cAgencia+cConta ) ) }
Local lSolucao3 := FWSizeFilial() > 2 .And. AllTrim( xFilial( "SE8" ) ) > AllTrim( xFilial( "SE5" ) )//Filial da SE5 pode possuir compartilhamento somente na filial, não estando vazia
Local lSolucao2	:= .F.
Local nNewSald := 0
Default lFirst := .T. 
Default cFils	:= ""

lBat := if( ValType( lBat ) <> 'L', .F., lBat)
oSelf := if( ValType( oSelf ) <> 'O', nil, oSelf)

If !lBat

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula total de registros a serem processados corretamente ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT COUNT( R_E_C_N_O_ ) TOTREG "
	cQuery += " FROM " + RetSqlName("SA6")
	cQuery += " WHERE A6_FILIAL ='" + xFilial("SA6") + "'"
	cQuery += " AND   A6_COD     between '" + mv_par01 + "' AND '" + mv_par02 + "'"
	cQuery += " AND   A6_AGENCIA between '" + mv_par03 + "' AND '" + mv_par04 + "'"
	cQuery += " AND   A6_NUMCON  between '" + mv_par05 + "' AND '" + mv_par06 + "'"
	cQuery += " AND D_E_L_E_T_ = ' '"

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBTOT',.T.,.T.)

	If oSelf <> nil
		oSelf:Savelog("INICIO")
		oSelf:SetRegua1(TRBTOT->TOTREG)
		oSelf:SetRegua2(TRBTOT->TOTREG)
	Else
		ProcRegua(TRBTOT->TOTREG)
	EndIf

	TRBTOT->( dbCloseArea() )

EndIf

/*
If !DtMovFin(mv_par07,.F.,"3")
	Help(" ",1,"DATAFIN",,STR0016+	STR0017,1,0) //"Nao sao permitidos recalculos de saldos bancarios" //"de data anterior a data contida no parametro MV_DATAFIN"
									 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento com o erro  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If oSelf <> nil
		oSelf:Savelog("ERRO","DATAFIN",STR0016+STR0017)	//"Processamento iniciado."
	Else
		ProcLogAtu("ERRO","DATAFIN",STR0016+STR0017)	//"Processamento iniciado."
    EndIf

	Return
Endif
*/
// Carrega a tabela 14
SX5->(DbSetOrder(1))
SX5->(MsSeek(xFilial("SX5")+"14"))
While SX5->(!Eof()) .And. SX5->X5_TABELA == "14"
	cTabela14 += (Alltrim(SX5->X5_CHAVE) + "/")
	SX5->(DbSkip())
End
cTabela14 += If(cPaisLoc=="BRA","","/$ ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01 // Do Banco                                         ³
//³ mv_par02 // Ate o Banco                                      ³
//³ mv_par03 // Da Agˆncia                                       ³
//³ mv_par04 // At‚ a Agˆncia                                    ³
//³ mv_par05 // Da Conta                                         ³
//³ mv_par06 // At‚ a Conta                                      ³
//³ mv_par07 // A partir da Data                                 ³
//³ mv_par08 // Seleciona Filiais?                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia rec lculo dos saldos, atrav‚s da movimenta‡„o banc ria³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT SA6.R_E_C_N_O_ A6_RECNO,"
cQuery += " E5_FILIAL, E5_BANCO, E5_AGENCIA, E5_CONTA, E5_DTDISPO, E5_TIPODOC, E5_MOEDA,"
cQuery += " E5_NUMCHEQ, E5_MOTBX, E5_NUMERO, E5_RECPAG, E5_VALOR, E5_DOCUMEN,E5_RECONC,E5_SEQ, E5_FILORIG "
If lComp
	If "MSSQL" $ UPPER(AllTrim(TcGetDB())) 
		cQuery += " , SUBSTRING(E5_FILIAL, 1, " + str(Len(AllTrim(xFilial("SE8")))) + ") AS E5_FIL "
	Else
		cQuery += " , SUBSTR(E5_FILIAL, 1, " + str(Len(AllTrim(xFilial("SE8")))) + ") AS E5_FIL "
	EndIf
EndIf
cQuery += " FROM " + RetSqlName("SA6") + " SA6, " + RetSqlName("SE5") + " SE5"
cQuery += " WHERE SA6.D_E_L_E_T_ = ' '"
cQuery += " AND SE5.D_E_L_E_T_ = ' '"

//*************************************************************************************************
// Solucao | Multi filial | A6 | E5 | E8 | Descricao                                              *
//     1   |     Sim      | E  | E  | E  | Rodar Multi filial filtrando filial no A6, E5          *
//     2   |     Sim      | E  | E  | C  | Normal com filial do A6 e no E5 de '  ' ate 'ZZ'       *
//     3   |     Sim      | E  | C  | E  | Rodar Multi filial filtrando filial no A6 e E5_FILORI  *
//         |     Sim      | E  | C  | C  | Idem a Solucao 2                                       *
//         |     Sim      | C  | E  | E  | Idem a Solucao 1                                       *
//         |     Nao      | C  | E  | C  | Idem a Solucao 2                                       *
//         |     Sim      | C  | C  | E  | Idem a Solucao 3                                       *
//     4   |     Nao      | C  | C  | C  | Rodar Normal sem filtro                                *
//*************************************************************************************************

//************
// Solução 1 *
//************
If !Empty(FwFilial("SE8")) .and. !Empty(FwFilial("SE5"))

	cQuery += " AND A6_FILIAL ='" + xFilial("SA6") + "'"
	cQuery += " AND E5_FILIAL = '" + xFilial("SE5") + "'"
	
	If MV_PAR08 == 1
		cQuery += " AND E5_FILORIG BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "'"		
	EndIf

//************
// Solução 2 *
//************
ElseIf Empty(FwFilial("SE8")) .and. ( !Empty(FwFilial("SA6")) .or. !Empty(FwFilial("SE5")) )

	cQuery += " AND A6_FILIAL = '" + xFilial("SA6") + "'"
	// Controle de acesso de Usuário às filiais selecionadas.
	If lUsAllFls
		cQuery += " AND E5_FILIAL between '  ' AND 'ZZ'"
	Else
		If Empty(cFils)
			cQuery += " AND E5_FILIAL = '" + xFilial("SE5") + "' " 
		Else
			cQuery += " AND E5_FILIAL IN (" + cFils + ") "
		EndIf
	EndIf
	lSolucao2	:= .T.
	
//************
// Solução 4 *
//************
ElseIf Empty(FwFilial("SE8"))

	cQuery += " AND A6_FILIAL = '" + xFilial("SA6") + "'"
	cQuery += " AND E5_FILIAL = '" + xFilial("SE5") + "'"

//************
// Solução 3 *
//************
ElseIf Empty(FwFilial("SE5")) .and. !Empty(FwFilial("SE8"))

	cQuery += " AND A6_FILIAL = '" + xFilial("SA6") + "'"
	cQuery += " AND E5_FILORIG = '" + xFilial("SE8") + "'"
	lSolucao3 := .T.

EndIf

cQuery += " AND A6_COD between '" + mv_par01 + "' AND '" + mv_par02 + "'"
cQuery += " AND A6_AGENCIA between '" + mv_par03 + "' AND '" + mv_par04 + "'"
cQuery += " AND A6_NUMCON between '" + mv_par05 + "' AND '" + mv_par06 + "'"

If cPaisLoc <> "BRA"
	cQuery += " AND   E5_VENCTO <= E5_DTDISPO" 
Endif
cQuery += " AND A6_COD = E5_BANCO"
cQuery += " AND A6_AGENCIA = E5_AGENCIA"
cQuery += " AND A6_NUMCON = E5_CONTA"
cQuery += " AND E5_SITUACA NOT IN ('C')"
cQuery += " AND E5_TIPODOC NOT IN ('BA','DC','JR','MT','CM','D2','J2','M2','C2','V2','CP','TL') "
cQuery += " AND E5_DTDISPO >= '" + dtos(mv_par07) + "'"

If lComp
	cQuery += " ORDER BY E5_FIL, E5_BANCO, E5_AGENCIA, E5_CONTA, E5_DTDISPO "
Else
	cQuery += " ORDER BY E5_BANCO, E5_AGENCIA, E5_CONTA, E5_DTDISPO"
EndIf

cQuery := ChangeQuery(cQuery)

dbSelectArea("SE5")
SE5->( DbSetOrder(12) )

dbSelectArea("SE8")
 
lCont := .T.

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB210',.T.,.T.)
TcSetField("TRB210", "E5_DTDISPO", "D")

While TRB210->(!Eof())   .And. lCont

	If !lBat
		If oSelf <> nil
			oSelf:IncRegua1("Selecionando Registros...")
			oSelf:IncRegua2()
		Else
			IncProc()
		EndIf
	Endif

	dbSelectArea("TRB210")
	If lSolucao3
		//************
		// Solução 3 *
		//************
		cFilAux := Iif( Empty( E5_FILORIG ) , cFilAnt , E5_FILORIG )
		cFilTRB  := FwxFilial("SE8",cFilAux)
	Else
		//********************
		// Solução 1 , 2 e 4 *
		//********************
		cFilAux := E5_FILIAL
		cFilTRB  := FwxFilial("SE5",cFilAux)
	EndIf
	cFilSE8  := FwxFilial("SE8",cFilAux)
	cFilSE5  := FwxFilial("SE5",cFilAux)
	nTamFilSE5 := Len(Alltrim(cFilTRB))
	nTamFilSE8 := Len(Alltrim(cFilSE8))	
	cBanco   := E5_BANCO
	cAgencia := E5_AGENCIA
	cConta   := E5_CONTA
	nSaldoIni:= 0
	nEntradas:= 0
	nSaidas  := 0
	nEntrRec := 0
	nSaidRec := 0
	cFilSE82 := xFilial("SE8", cFilTRB)
	cFilSE52 := FWxFilial("SE5",cFilSE5)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza Saldo de Partida.                              ³
	//³ Observe que o programa retorna um registro no banco de  ³
	//³ dados, portanto a data de referencia ‚  a data em que   ³
	//³ o saldo ficou errado, n„o a data correta do saldo.      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SE8->(dbSeek( xFilial("SE8")+cBanco+cAgencia+cConta+Dtos(mv_par07),.T. ))
	SE8->(dbSkip( -1 ))
	If SE8->E8_FILIAL != xFilial("SE8") .or. SE8->E8_BANCO != cBanco .or. SE8->E8_AGENCIA != cAgencia .or. SE8->E8_CONTA != cConta .or. SE8->(BOF()) .or. SE8->(EOF())
		nSaldoIni := 0
		nSalRecIni := 0   //Saldo Reconciliado Inicial
	Else
		nSaldoIni := SE8->E8_SALATUA
		nSalRecIni := SE8->E8_SALRECO   //Saldo Reconciliado Inicial
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza movimenta‡„o banc ria                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRB210")
   //	While TRB210->(!Eof()) .and. Eval( bBncFilIgl )
	While TRB210->(!Eof()) .and. ( ( Substr(TRB210->E5_FILIAL,1,nTamFilSE8)+TRB210->E5_BANCO+TRB210->E5_AGENCIA+TRB210->E5_CONTA == Substr(cFilSE8,1,nTamFilSE8)+cBanco+cAgencia+cConta ) .Or. ( lSolucao3 .And. Empty( TRB210->E5_FILIAL ) .And. TRB210->E5_BANCO+TRB210->E5_AGENCIA+TRB210->E5_CONTA == cBanco+cAgencia+cConta ) )
		dDataMovto := TRB210->E5_DTDISPO
		
		dbSelectArea("TRB210")
		While TRB210->(!Eof()) .and. Eval( bBncFilIgl ) .And. TRB210->E5_DTDISPO == dDataMovto
		
			// Controle de acesso de Usuário às filiais selecionadas.
			If !lSolucao2
				If !lUsAllFls
					If lSolucao3
						If !TRB210->E5_FILORIG $ cFils
							TRB210->(dbSkip())
							Loop
						EndIf
					ElseIf !TRB210->E5_FILIAL $ cFils
						If Empty(FWxFilial("SE5"))
							If !cFilAnt $ cFils
								TRB210->(dbSkip())
								Loop
							EndIf
						Else
							TRB210->(dbSkip())
							Loop
						EndIf
					EndIf
				EndIf
			EndIf
			
			If TRB210->E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(TRB210->E5_NUMCHEQ) .and. !(TRB210->E5_TIPODOC $ "TR#TE")
				TRB210->(dbSkip())
				Loop
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Na transferencia somente considera nestes numerarios 		  ³
			//³ No Fina100 ‚ tratado desta forma.                    		  ³
			//³ As transferencias TR de titulos p/ Desconto/Cau‡Æo (FINA060) ³
			//³ nÆo sofrem mesmo tratamento dos TR bancarias do FINA100      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If TRB210->E5_TIPODOC $ "TR/TE" .and. Empty(TRB210->E5_NUMERO)
				If !(TRB210->E5_MOEDA $ cTabela14)
					TRB210->(dbSkip())
					Loop
				Endif
			Endif

			If TRB210->E5_TIPODOC $ "TR/TE" .and. (Substr(TRB210->E5_NUMCHEQ,1,1)=="*" ;
				.or. Substr(TRB210->E5_DOCUMEN,1,1) == "*" )
				TRB210->(dbSkip())
				Loop
			Endif

			If TRB210->E5_MOEDA == "CH" .and. (IsCaixaLoja(TRB210->E5_BANCO) .And. !lCxLoja .And. TRB210->E5_TIPODOC $ "TR/TE")	// Sangria
				TRB210->(dbSkip())
				Loop
			Endif

			If SubStr(TRB210->E5_NUMCHEQ,1,1)=="*"      //cheque para juntar (PA)
				TRB210->(dbSkip())
				Loop
			Endif

			If !Empty(TRB210->E5_MOTBX)
				If !MovBcoBx(TRB210->E5_MOTBX)
					TRB210->(dbSkip())
					Loop
				Endif
			Endif

			If TRB210->E5_RECPAG = "R"
				nEntradas += TRB210->E5_VALOR
				If !Empty(TRB210->E5_RECONC)
					nEntrRec += TRB210->E5_VALOR
				Endif
			Else
				nSaidas += TRB210->E5_VALOR
				If !Empty(TRB210->E5_RECONC)
					nSaidRec += TRB210->E5_VALOR
				Endif
			Endif
			If lFA210SE5
				ExecBlock("FA210SE5",.F.,.F.)
	   		EndIf
	      	TRB210->(dbSkip())
		Enddo  // Quebra da data
		
		SE8->(dbSeek(FwxFilial("SE8",cFilTRB)+cBanco+cAgencia+cConta+Dtos(dDataMovto)))
		IF SE8->(Eof())
			RecLock("SE8",.t.)
		Else
			RecLock("SE8",.f.)
		Endif
		
		Replace 	SE8->E8_FILIAL		With FwxFilial("SE8",cFilTRB),;
					SE8->E8_BANCO			With cBanco,;
					SE8->E8_AGENCIA		With cAgencia,;
					SE8->E8_CONTA			With cConta,;
					SE8->E8_DTSALATU		With dDataMovto
		Replace	SE8->E8_SALATUA		With nSaldoIni+nEntradas-nSaidas
		Replace	SE8->E8_SALRECO		With nSalRecIni+nEntrRec-nSaidRec
		SE8->( MsUnlock() )

		If lFA210SE8
			ExecBlock("FA210SE8",.F.,.F.)
		EndIf
		
		If !(TRB210->(EoF())) .AND. TRB210->(E5_BANCO+E5_AGENCIA+E5_CONTA) == cBanco+cAgencia+cConta
			 
			cQuery	:= " SELECT SE8.R_E_C_N_O_ RECNOSE8"
			cQuery	+= " FROM " + RetSqlName("SE8") + " SE8 "
			cQuery	+= " WHERE SE8.E8_DTSALAT BETWEEN '" + DToS(dDataMovto+1) + "' AND '" + DToS( (TRB210->E5_DTDISPO) - 1) + "' AND "
			cQuery	+= 			" SE8.E8_FILIAL = '" + cFilSE82 + "' AND "
			cQuery	+= 			" SE8.E8_BANCO = '" + cBanco + "' AND "
			cQuery	+= 			" SE8.E8_AGENCIA = '" + cAgencia + "' AND "
			cQuery	+= 			" SE8.E8_CONTA = '" + cConta + "' AND "
			cQuery	+= 			" SE8.D_E_L_E_T_ = '' "
			
			If lComp
				cQuery	+= 			" AND Not Exists ( "
				cQuery	+= 						" SELECT SE5.R_E_C_N_O_ RECNOSE5 "
				cQuery	+= 						" FROM	" + RetSqlName("SE5") + " SE5 "
				cQuery	+= 						" WHERE SE8.E8_DTSALAT = SE5.E5_DTDISPO AND "
				cQuery	+= 							" SE5.E5_FILIAL = '" + cFilSE52 + "' AND "
				cQuery	+= 							" SE5.E5_BANCO = SE8.E8_BANCO AND "
				cQuery	+= 							" SE5.E5_AGENCIA = SE8.E8_AGENCIA AND "
				cQuery	+= 							" SE5.E5_CONTA = SE8.E8_CONTA AND "
				cQuery	+= 							" SE5.E5_NUMCHEQ = '" + TRB210->E5_NUMCHEQ + "' AND "
				cQuery	+= 							" SE5.D_E_L_E_T_ = '' "
				cQuery	+= 					" ) "
			EndIf
			
			cQuery := ChangeQuery(cQuery)
			
			DbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), 'TRBSE8', .T., .T. )
			
			While !(TRBSE8->(Eof()))
				SE8->( DbGoTo( TRBSE8->RECNOSE8 ) )
				
				RecLock( "SE8", .F., .T. )
					SE8->( DbDelete() )
				SE8->( MsUnlock() )
				
				TRBSE8->( DbSkip() )
			EndDo
			
			TRBSE8->( DbCloseArea() )
			
		Else
		
			nData := dDataMovto
		
		EndIf

		If TRB210->(Eof()) .OR. TRB210->(E5_BANCO+E5_AGENCIA+E5_CONTA) != cBanco + cAgencia + cConta
			
			SE8->( DbSeek(xFilial("SE8")+cBanco+cAgencia+cConta+dtos(dDataMovto+1), .T. ) )
			While !Eof() .and. FwxFilial("SE8",cFilTRB)+cBanco+cAgencia+cConta == SE8->(E8_FILIAL+E8_BANCO+E8_AGENCIA+E8_CONTA)
				RecLock("SE8",.F.,.T.)
				If lComp
					cChaveSE5 := TRB210->(E5_BANCO+E5_AGENCIA+E5_CONTA)+dtos(nData)+TRB210->E5_NUMCHEQ 
					aAreaAtu := GetArea()
					
					If SE5->(!DbSeek(FwxFilial("SE5",cFilTRB)+cChaveSE5))
						lAreaRest := .T.
						RestArea(aAreaAtu)
						SE8->(dbDelete())
					EndIf
					
					If !lAreaRest
						RestArea(aAreaAtu)
					EndIf
					
					lAreaRest := .F.				
				Else						
					SE8->(dbDelete())
				EndIf												
				SE8->(MsUnlock())
				SX2->(MsUnlock())
				SE8->(dbSkip())
			Enddo
		Endif
	
	Enddo  // Fecha Primeiro Loop do SE5

	If Empty(FwFilial("SA6")) .and. !Empty(FwFilial("SE8")) .and. !Empty(FwFilial("SE5"))	
		If lFirst
			dbSelectArea("SA6")
			If SA6->(dbSeek( xFilial("SA6")+cBanco+cAgencia+cConta))
				RecLock("SA6")
				Replace A6_SALATU With nSaldoIni+nEntradas-nSaidas
				SA6->(MsUnLock())
			EndIf
		Else	
			dbSelectArea("SA6")
			If SA6->(dbSeek( xFilial("SA6")+cBanco+cAgencia+cConta))
				RecLock("SA6")
				nNewSald := A6_SALATU + nSaldoIni+nEntradas-nSaidas
				Replace A6_SALATU With nNewSald
				SA6->(MsUnLock())
			EndIf
		EndIf	
	Else
		dbSelectArea("SA6")
		If SA6->(dbSeek( xFilial("SA6")+cBanco+cAgencia+cConta))
			RecLock("SA6")
			Replace A6_SALATU With nSaldoIni+nEntradas-nSaidas
			SA6->(MsUnLock())
		EndIf
	Endif	
			

	dbSelectArea("TRB210")
Enddo

TRB210->(DbCloseArea())

If oSelf <> nil
	oSelf:Savelog("FIM")
EndIf

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AdmAbreSM0³ Autor ³ Orizio                ³ Data ³ 22/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna um array com as informacoes das filias das empresas ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AdmAbreSM0()
	Local aArea			:= SM0->( GetArea() )
	Local aAux			:= {}
	Local aRetSM0		:= {}
	Local lFWLoadSM0	:= .T.
	Local lFWCodFilSM0 	:= .T.

	If lFWLoadSM0
		aRetSM0	:= FWLoadSM0()
	Else
		DbSelectArea( "SM0" )
		SM0->( DbGoTop() )
		While SM0->( !Eof() )
			aAux := { 	SM0->M0_CODIGO,;
						IIf( lFWCodFilSM0, FWGETCODFILIAL, SM0->M0_CODFIL ),;
						"",;
						"",;
						"",;
						SM0->M0_NOME,;
						SM0->M0_FILIAL }

			aAdd( aRetSM0, aClone( aAux ) )
			SM0->( DbSkip() )
		End
	EndIf

	RestArea( aArea )
Return aRetSM0

/*/{Protheus.doc} SchedDef
Uso - Execucao da rotina via Schedule.

Permite usar o botao Parametros da nova rotina de Schedule
para definir os parametros(SX1) que serao passados a rotina agendada.

@return  aParam
/*/

Static Function SchedDef(aEmp)

Local aParam := {}

aParam := {	"P"			,;	//Tipo R para relatorio P para processo
				"FIN210"	,;	//Nome do grupo de perguntas (SX1)
				Nil			,;	//cAlias (para Relatorio)
				Nil			,;	//aArray (para Relatorio)
				Nil			}	//Titulo (para Relatorio)

Return aParam