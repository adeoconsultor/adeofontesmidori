#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "FONT.ch"

#define STR0001  "OP's Previstas"
#define STR0002  "Firma OPs"
#define STR0003  "Exclui OPs"
#define STR0004  " Firma as OPs marcadas ?"
#define STR0005  " Deleta as OPs marcadas ?"
#define STR0006  "Selecionando Registros..."
#define STR0007  "Pesquisar"
#define STR0008  "Atenção"
#define STR0009  "Todas as OPs intermediárias que possuam vinculo com alguma OP Pai marcada no Browse, serão firmadas, "
#define STR0010  "devido o sistema estar parametrizado para trabalhar com produção automática (MV_PRODAUT habilitado). "
#define STR0011  "Deseja continuar o processo ?"
#define STR0012  "Sim"
#define STR0013  "Não"
#define STR0014  "Deletando OP's previstas..."
#define STR0015  "Deletando SC's previstas..."
#define STR0016  "Deletando PC's/CP's previstos..."

//---------------------------------
/*
Este Programa controla o embarque dos planos produzidos
*/
User Function MD_EMBPLA()



Local	nI			:= 0
Local 	aCampos		:= {}
Private cMarca 		:= GetMark()

//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa  ³
//³ ----------- Elementos contidos por dimensao ------------ ³
//³ 1. Nome a aparecer no cabecalho                          ³
//³ 2. Nome da Rotina associada                              ³
//³ 3. Usado pela rotina                                     ³
//³ 4. Tipo de Transa‡„o a ser efetuada                      ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados         ³
//³    2 - Simplesmente Mostra os Campos                     ³
//³    3 - Inclui registros no Bancos de Dados               ³
//³    4 - Altera o registro corrente                        ³
//³    5 - Remove o registro corrente do Banco de Dados      ³
//³    6 - Altera determinados campos sem incluir novos Regs ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCadastro := "Embarque de Planos"

Private aRotina := MenuDef()
Private aIndTmp 	:= {}
Private aSavMTA652  := Array(8)
Private oVermelho   := LoadBitmap( GetResources(), "BR_VERMELHO" )
Private oAmarelo    := LoadBitmap( GetResources(), "BR_AMARELO" )
Private oVerde      := LoadBitmap( GetResources(), "BR_VERDE" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de variaveis para rotina de inclusao automatica



//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // De  Produto                           ³
//³ mv_par02            // Ate Produto                           ³
//³ mv_par03            // De  Ordem de Producao                 ³
//³ mv_par04            // Ate Ordem de Producao                 ³
//³ mv_par05            // De  Data de Entrega                   ³
//³ mv_par06            // Ate Data de Entrega                   ³
//³ mv_par07            // De  Data de Inicio                    ³
//³ mv_par08            // Ate Data de Inicio                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("MTA652",.F.)
For ni := 1 to 8
	aSavMTA652[ni] := &("mv_par"+StrZero(ni,2))
Next ni

dbSelectArea("SC2")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra o arquivo conforme perguntas antes de mostrar     ³
//³ o browse                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PLNPFiltEmb()
dbGoTop()
// MarkBrow("SC2","C2_OK",  ,  ,   , cMarca)
//
aCampos := {}
AADD(aCampos,{"C2_OK"            		,""," "})
AADD(aCampos,{"C2_OPMIDO"    		,"","Num. Plano "    })
AADD(aCampos,{"C2_NUM"    			,"","Num.Protheus"    })
AADD(aCampos,{"C2_EMISSAO"  		,"","Emissao"    })
AADD(aCampos,{"C2_PRODUTO"  	,"","Produto"    })
AADD(aCampos,{"C2_QUANT"    		,"","Quantidade"    })
AADD(aCampos,{"C2_CLIENTE"    		,"","Cliente" ,   })
AADD(aCampos,{"C2_LOJA"    			,"","Loja"    })
AADD(aCampos,{"C2_RELEASE"    	,"","Release"    })
AADD(aCampos,{"C2_DTRELE"    		,"","Release"    })
//AADD(aCampos,{"C2_NMLIB1"    		,"","1 Liberacao"   })
//AADD(aCampos,{"C2_DTLIB1"    		,"","Data"    })
//
aCores := {} // Limpando a variavel
Aadd(aCores,{" C2_EMBARC =='T' .AND. C2_LIBER  == 'OK' "    ,"BR_VERMELHO" })
Aadd(aCores,{" C2_EMBARC =='P' .AND. C2_LIBER  == 'OK' " ,"BR_AMARELO"   })
Aadd(aCores,{"(empty(C2_EMBARC) .or. C2_EMBARC =='N') .AND. C2_LIBER  == 'OK' "    ,"BR_VERDE" })

//
MarkBrow("SC2","C2_OK", ,aCampos , , cMarca , , , , , , , , , aCores )
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna indices do SC2                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SC2")
dbSetOrder(10 ) // Ordenado pelo numero do Plano do Cliente
aEval(aIndTmp, {|cFile| fErase(cFile+OrdBagExt())})


RETURN
//----------------------------------
Static FUNCTION PLNPFiltEmb(nOrder)
LOCAL cIndice,nInd,cFirmaCond:=""
Local cNomeInd:=CriaTrab(NIL,.F.)
nOrder := If(nOrder=Nil,10,nOrder)

Aadd(aIndTmp, cNomeInd)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera index de trabalho do SC2                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC2")
dbSetOrder( 10 )
cIndice   := Indexkey()
cFirmaCond += 'C2_FILIAL=="'+xFilial("SC2")+'".And. '
cFirmaCond += ' ! Empty( C2_OPMIDO ) .And. C2_EMBARC  <> "T" '
cFirmaCond += " .and. dTos(C2_EMISSAO) >= '20110201' .and. C2_QUJE > 0 "

IndRegua("SC2",cNomeInd,cIndice,,cFirmaCond,STR0006)	//"Selecionando Registros..."

nInd := RetIndex("SC2")
dbSetOrder(nInd+1)
Return
//--------------------------------------------
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³LPLNPesqPla³ Autor ³ Marcelo Iuspa         ³ Data ³ 24/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Botao Pesquisa do aRotina                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Mata651                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PesqPlan
Local cCampo,nReg
Local nOpt1:=nOrdemAtual
Local cOrd
Local oDlg, nOpca := 0
Private aOrd := {}
PesqOrd("SC2")
cCampo  := Space(40)
aEval(aOrd, {|x, y| aOrd[y] := OemToAnsi(x)})
cOrd := aOrd[nOrdemAtual]

DEFINE MSDIALOG oDlg FROM 5, 5 TO 14, 50 TITLE OemToAnsi(STR0007) //"Pesquisar"
@ 0.6,1.3 COMBOBOX oCBX VAR cOrd ITEMS aOrd  SIZE 165,44  ON CHANGE (nOpt1:=oCbx:nAt)  OF oDlg FONT oDlg:oFont
@ 2.1,1.3 MSGET cCampo SIZE 165,10
DEFINE SBUTTON FROM 055,122   TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 055,149.1 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED
If nOpca == 0
	Return 0
Endif
dbSetOrder(nOpt1)
nOrdemAtual := IndexOrd()
PLNPFiltra(nOrdemAtual)
nReg := RecNo()
If ! dbSeek(xFilial("SC2")+trim(cCampo), .T.)
	dbGoTo(nReg)
	Help(" ",1,"PESQ01")
EndIF
Return .T.
//-----------------------------
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MA651Filtro ³ Autor ³Rodrigo de A Sartorio³ Data ³ 03/02/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Estabelece o topo e o Fim da markbrowse                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MA651Filtro                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA651                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Function MA651Filtro(lTop)
Local cRetorno := ""
If lTop
cRetorno:=xFilial("SC2")+"P"
Else
cRetorno:=xFilial("SC2")+Repl(Chr(255),Len(SC2->C2_TPOP))
EndIf
Return(cRetorno)
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Fabio Alves Silva     ³ Data ³08/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MenuDef()

//Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
//             {"Visualizar","U_VISUPLA",0,2} ,;
//             {"Incluir","U_GERAEMB",0,3} ,;
//             {"Alterar","U_GeraEmb",0,4} ,;
//             {"Excluir","AxDeleta",0,5},;
//             {"Legenda","u_LegStat",0,0} }


Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","U_VISUPLA",0,2} ,;
             {"Incluir","U_INCLUI",0,3} ,;  
             {"Gerar Embarque","U_GERAEMB",0,4} ,;
             {"Legenda","u_LegStat",0,0} }



//PRIVATE aRotina	:= {	{"Pesquisar"         	,"AxPesqui"	,0,1,0,.f.},;
//									{'Visualizar ' 			,"U_VISUPLA"	,0,2,0,.f.},;
//									{'Gerar Embarque'		,"U_GERAEMB"		,0,4,0,.f.},;
//									{'Legenda '				,"u_LegStat"   ,0,5,0,.f.} }
                     

Return(aRotina)
//------------------------------------------------------------------------------------------------
USER FUNCTION VISUPLA()
A650VIEW( 'SC2', SC2->( RECNO() ), 2 )
Return()



User Function GeraEmb(cAlias,nReg,nOpc)
Local aSaveArea := GetArea()
Local aCampos := {}
Local aAltera := {}
Local nOpca := 0
Local cArq 
Local aTpSald := ""
Local lEmbarque
Local oGetDb
Local oDlg
Local oFnt                
Local oEmbarque    
Private lImpresso     := .F.
Private aTela := {}
Private aGets := {}
Private aHeader := {}
Public cInvoice := ""                              

aCampos := U_aHeader(@aAltera)


//+----------------------------------------------------------------+
//| Cria arquivo Temporario para uso com MSGETDB |

U_CriaTMP(aCampos,@cArq)

//+----------------------------------------------------------------+
//| Carrega dados para MSGETDB |
//+----------------------------------------------------------------+
cNumEmb := U_EmbCarr(4)
dbSelectArea("SZG")
dbSetOrder(5)
if dbSeek(xFilial("SZG")+cNumEmb)

	cInvoice := Space(20)


	DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 40,120 OF oMainWnd

  	DEFINE FONT oFnt	NAME "Arial" Size 10,15
  	DEFINE FONT oFntCabec NAME "Arial" Size 10, 30
		oTPanel1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,20,.T.,.F.)
		oTPanel1:Align := CONTROL_ALIGN_TOP

	
		@ 4, 005 SAY "EMBARQUE: " PIXEL FONT oFntCabec COLOR CLR_BLUE OF oTPanel1
//		@ 4, 068 SAY "Fornedor:"    SIZE 70,7 PIXEL OF oTPanel1
//		@ 4, 190 SAY "Emissao:" SIZE 70,7 PIXEL OF oTPanel1
//		@ 4, 260 Say "Lote:"    SIZE 70,7 PIXEL OF oTPanel1

//		@ 3, 110 MSGET cNumEmb When .F. SIZE 30,15 PIXEL OF oTPanel1
		@ 4, 070 SAY cNumEmb PIXEL FONT oFntCabec COLOR CLR_BLACK OF oTPanel1
		@ 4, 160 SAY "INVOICE " PIXEL FONT oFntCabec COLOR CLR_BLUE of oTPanel1
		@ 4, 240 MSGET cInvoice   When .T. SIZE 78,7 PIXEL OF oTPanel1
		@ 4, 350 CheckBox oEmbarque Var lEmbarque Prompt "Embarcar ?" Size C(056),C(004) PIXEL FONT oFntCabec COLOR CLR_BLUE OF oTPanel1
//		@ 3, 215 MSGET dData   When .F. SIZE 40,7 PIXEL OF oTPanel1
//		@ 3, 275 MSGET cLote  When .F. SIZE 40,7 PIXEL OF oTPanel1
		oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,24,.T.,.F.)
		oTPanel2:Align := CONTROL_ALIGN_BOTTOM
		If nOpc == 4                                                                                                     
//		oGetDB:= MSGetDB():New(0, 0, 0, 0, Iif(nOpc==3,4,nOpc),"U_cLOk", "U_cTOk", "+ZG_SEQUEN",.t.,aAltera,,.t.,,"TMP")
  		oGetDB  := MSGetDB():New(0, 0, 0, 0, Iif(nOpc==3,4,nOpc),"U_cLok","U_cTOk", "+ZG_SEQUEN",.t.,aAltera,,.t.,,"TMP",,,,,,,) //"U_cDel")
		Else
		   oGetDB := MSGetDados():New(0,0,0,0,nOpc)
		Endif

		oGetDB:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
//  	@225,420  BMPBUTTON TYPE 06 ACTION (ExecBlock("U_cTOk(cInvoice)"), ExecBlock("MD_RELEMBPL(cNumEmb)") ) 
	  	@225,420  BMPBUTTON TYPE 06 ACTION if(u_cTok(cNumEmb,lEmbarque), {u_GravaEmb(cNumEmb,4,cInvoice, lEmbarque) , U_MD_RELEMBPL(cNumEmb)}, Alert("Acerte as informacoes antes de imprimir..."))

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,;
				{||nOpca:=1,if(u_cTok(cNumEmb,lEmbarque), (u_GravaEmb(cNumEmb,4,cInvoice, lEmbarque), oDlg:End()),nOpca := 0)},;
				{||nOpca:=2,U_DelCanc(cNumEmb), oDlg:End()}) VALID nOpca != 0 CENTERED
	
else
	Alert("Não Há Planos a serem embarcados e/ou os planos marcados já embarcaram...")
endif
DbSelectArea( "TMP" )
DbCloseArea()
If Select("cArq") = 0
	FErase(cArq+GetDBExtension())
EndIf	
	
dbSelectArea("SZG")
dbSetOrder(1)


	
Return nOpca


User Function GravaEmb(cNumEmb,nOpc,cInvoice,lEmbarque)
Local aSaveArea := GetArea() 
Local lDesmarca := .F.             
Local lConfirma := .F.       
Local lPergunta := .T.
//Alert("Entrou para Salvar....")
dbSelectArea("SC2")
dbSetOrder(1)
dbGotop()
dbSelectArea("TMP")
dbgotop()
While !Eof()
//	Alert("Salvando....")
	If !TMP->ZG_FLAG // Item nao deletado na MSGETDB
		If nOpc == 3 .Or. nOpc == 4
			dbSelectArea("SZG")
			dbSetOrder(5)      
//			Alert("EMBARQUE: "+cNumEmb)
			If !(dbSeek(xFilial("SZG")+cNumEmb+TMP->ZG_PLANO))
				RecLock( "SZG", .t. )
				SZG->ZG_FILIAL  := xFilial()
				SZG->ZG_NUMEMB := cNumEmb
				MsUnLock("SZG")
			Else
//				Alert("Salvando alteracao......")
				RecLock( "SZG", .f. )
				SZG->ZG_QTDEEMB := TMP->ZG_QTDEEMB
				SZG->ZG_INVOICE := cInvoice
				if SZG->ZG_INVOICE <> space(20)
					if lEmbarque 
						SZG->ZG_EMBARCA := 'S'
					elseif  SZG->ZG_EMBARCA == 'S'
						if !lDesmarca .and. lPergunta
							if APMsgNoYes("Deseja desmarcar a confirmação desse embarque ?","Embarque: "+cNumEmb+" PLANO: "+SZG->ZG_PLANO)
								SZG->ZG_EMBARCA := 'N'
								lDesmarca := .T.     
								lPergunta := .F.
							else
								lPergunta := .F.
							endif
						elseif lDesmarca .and. !lPergunta
							SZG->ZG_EMBARCA := 'N'
						endif
					elseif lConfirma .and. lPergunta
						SZG->ZG_EMBARCA := 'S'      
					elseif lConfirma .and. !lPergunta
						SZG->ZG_EMBARCA := 'N'
					elseif lPergunta
						if APMsgNoYes("Deseja confirmar que foi e/ou será embarcado esse embarque ?","Embarque: "+cNumEmb)
							if cInvoice <> space(20)
								SZG->ZG_EMBARCA := 'S'
								lEmbarque := .T.
								lConfirma:= .T.
							else
								Alert("Informe o numero da invoice")
								Return
							endif
						else                      
							SZG->ZG_EMBARCA := 'N'					
							lPergunta := .F.
						endif
					endif
				endif
				MsUnLock("SZG")

				dbSelectArea("SC2")
				dbSetOrder(10)
				if dbSeek(xFilial("SC2")+TMP->ZG_PLANO)
					RecLock( "SC2" , .f.)
					if TMP->ZG_QTDEEMB == TMP->ZG_QTDISPE
						SC2->C2_EMBARC := 'T'
					else
						SC2->C2_EMBARC := 'P'
					endif
					MsUnLock( "SC2" )
				endif
//					RetIndex("SC2")
			Endif
	 Else  //if nOpc == 5 // Se for exclusao
			dbSelectArea("SZG")
			dbSetOrder(5)
			If dbSeek(xFilial()+cNumEmb)
				RecLock("SZG",.F.,.T.)
				dbDelete()
				MsUnlOCK()
			EndIf
		EndIf
	Else // Item deletado na MSGETDB
		dbSelectArea("SZG")
		dbSetOrder(5)
		If dbSeek(xFilial()+cNumEmb)
			RecLock( "SZG", .f., .t. )
			DbDelete()
			MsUnlock("SZG")
		Endif
	EndIf
	dbSelectArea("TMP")
	dbSkip()
Enddo
RestArea(aSaveArea)
Return





User Function GravaPImp(cNumEmb,nOpc,cInvoice,lEmbarque)
Local aSaveArea := GetArea() 
//Alert("Entrou para Salvar....")
dbSelectArea("TMP")
dbgotop()
While !Eof()
//	Alert("Salvando....")
	If !TMP->ZG_FLAG // Item nao deletado na MSGETDB
		If nOpc == 3 .Or. nOpc == 4
			dbSelectArea("SZG")
			dbSetOrder(5)      
//			Alert("EMBARQUE: "+cNumEmb)
			If !(dbSeek(xFilial("SZG")+cNumEmb+TMP->ZG_PLANO))
				RecLock( "SZG", .t. )
				SZG->ZG_FILIAL  := xFilial()
				SZG->ZG_NUMEMB := cNumEmb
				MsUnLock("SZG")
			Else
//				Alert("Salvando alteracao......")
				RecLock( "SZG", .f. )
				SZG->ZG_QTDEEMB := TMP->ZG_QTDEEMB
				SZG->ZG_INVOICE := cInvoice                                       
				if lEmbarque
					SZG->ZG_EMBARCA := 'S'
				else
					SZG->ZG_EMBARCA := 'N'
				endif
				MsUnLock("SZG")
			Endif
//			For nCont := 1 To Len(aHeader)
//				If (aHeader[nCont][10] != "V" )
//					FieldPut(FieldPos(aHeader[nCont][2]),;
//					TMP->(FieldGet(FieldPos(aHeader[nCont][2]))))
//				EndIf
//			Next nCont

	 Else  //if nOpc == 5 // Se for exclusao
			dbSelectArea("SZG")
			dbSetOrder(5)
			If dbSeek(xFilial()+cNumEmb)
				RecLock("SZG",.F.,.T.)
				dbDelete()
				MsUnlOCK()
			EndIf
		EndIf
	Else // Item deletado na MSGETDB
		dbSelectArea("SZG")
		dbSetOrder(5)
		If dbSeek(xFilial()+cNumEmb)
			RecLock( "SZG", .f., .t. )
			DbDelete()
			MsUnlock("SZG")
		Endif
	EndIf
	dbSelectArea("TMP")
	dbSkip()
Enddo
RestArea(aSaveArea)
Return



                            
User function DelCanc(cNumEmb)
if !lImpresso 

	dbSelectArea("SZG")
	dbSetOrder(5)
	dbGotop()
	If dbSeek(xFilial("SZG")+cNumEmb)
		while !SZG->(eof()) .and. SZG->ZG_NUMEMB == cNumEmb
			RecLock("SZG",.F.,.T.)
			dbDelete()
			MsUnlOCK()
			SZG->(dbSkip())
		enddo	
	EndIf
endif
lImpresso := .F.
Return 

/*
//+------------+---------+-------+-----------------------+------+----------+
| Funcao |cTOk| Autor | Pilar S. Albaladejo | Data | 24/07/00 |
+------------+---------+-------+-----------------------+------+----------+
| Descricao | Valida MSGETDB -> Tudo OK |
+------------+-----------------------------------------------------------+
| Sintaxe | cTOk(ExpC1) |
+------------+-----------------------------------------------------------+
| Parametros | Nenhum |
+------------+-----------------------------------------------------------+
| Retorno | Nenhum |
+------------+-----------------------------------------------------------+
| Uso | CTBA120 |
+------------+-----------------------------------------------------------+
/*/
user function cTOk(cNumEmb, lEmbarque)
Local aSaveArea := GetArea()
Local lRet := .T.
Local cMsg := "" 
//alert("Validando...")
dbSelectArea("TMP")
dbGotop()
	while !TMP->(eof()) 
		if lRet             
//			alert("Validando...lRET")
			if !TMP->ZG_FLAG
//				alert("Validando....ZG_FLAG...")			
				if cInvoice = space(20) .and. lEmbarque
					Alert("Informar numero da invoice")
					lRet:=.F.
				endif
				if TMP->ZG_QTDEEMB > TMP->ZG_QTDISPE
					Alert("Quantidade a embarcar nao pode ser maior que a quantidade diponivel para embarque")
					lRet := .F.
				endif 
				if TMP->ZG_QTDEEMB < 0 
					Alert("Quantidade a embarcar nao pode ser negativo")
					lRet := .F.        
				endif
			endif    
		endif
		TMP->(dbSkip())		
	enddo
//if lRet                                           
//	u_GravaEmb(cNumEmb,4,cInvoice, lEmbarque)	
//endif
	
RestArea(aSaveArea)
Return lRet




user Function cLOk()
Local lRet := .T.
Local nCont
	if TMP->ZG_QTDEEMB > TMP->ZG_QTDISPE
		Alert("Quantidade a embarcar nao pode ser maior que a quantidade diponivel para embarque")
		lRet := .F.
	endif

Return lRet


/*/
+------------+---------+-------+-----------------------+------+----------+
| Funcao |CriaTMP| Autor | Pilar S. Albaladejo | Data | 24/07/00 |
+------------+---------+-------+-----------------------+------+----------+
| Descricao | Cria Arquivo Temporario para MSGETDB |
+------------+-----------------------------------------------------------+
| Sintaxe | CriaTMP(ExpA1,ExpC1) |
+------------+-----------------------------------------------------------+
| Parametros | ExpA1 = Matriz com campos a serem criados |
| | ExpC1 = Nome do arquivo temporario |
+------------+-----------------------------------------------------------+
| Retorno | Nenhum |
+------------+-----------------------------------------------------------+
| Uso | CTBA120 |
+------------+-----------------------------------------------------------+
/*/
user Function CriaTMP(aCampos,cArq)
Local cChave
Local aSaveArea := GetArea()
cChave := ""
cArq := CriaTrab(aCampos,.t.)
dbUseArea(.t.,,cArq,"TMP",.t.,.f.)
RestArea(aSaveArea)

Return

/*/
+------------+----------+-------+-----------------------+------+----------+
| Funcao |aHeader| Autor | Pilar S. Albaladejo | Data | 24/07/00 |
+------------+----------+-------+-----------------------+------+----------+
| Descricao | Montar aHeader para arquivo temporario da MSGETDB |
+------------+------------------------------------------------------------+
| Sintaxe | aHeader(ExpA1) |
+------------+------------------------------------------------------------+
| Parametros | ExpA1 = Matriz com campos que podem ser alterados |
+------------+------------------------------------------------------------+
| Retorno | ExpA1 = Matriz com campos a serem criados no arq temporario|
+------------+------------------------------------------------------------+
| Uso | CTBA120 |
+------------+------------------------------------------------------------+
/*/
user Function aHeader(aAltera)
Local aSaveArea:= GetArea()
Local aFora := {"ZG_EMBARCA","ZG_NUMEMB"}
Local aCampos := {}
Local nCriter := 0
PRIVATE nUsado := 0
// Montagem da matriz aHeader
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZG")
While !EOF() .And. (x3_arquivo == "SZG")
	If Alltrim(x3_campo) == "SZG_SEQUEN" .Or. ;
			x3Uso(x3_usado) .and. cNivel >= x3_nivel
		If Ascan(aFora,Trim(X3_CAMPO)) <= 0
			nUsado++
			AADD(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal, x3_valid,;
				x3_usado, x3_tipo, "TMP", x3_context } )
			If Alltrim(x3_campo) <> "ZG_SEQUEN"
				Aadd(aAltera,Trim(X3_CAMPO))               
			EndIf
		EndIF
	EndIF                                                                            
	aAdd( aCampos, { SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO,SX3->X3_DECIMAL } )
	dbSkip()
EndDO
Aadd(aCampos,{"ZG_FLAG","L",1,0})
RestArea(aSaveArea)

Return aCampos



user Function EmbCarr(nOpc)
Local aSaveArea:= GetArea()
Local cAlias := "SZG"
Local nPos     
Local nCont := 0  
nOpc := 4        

If nOpc != 3 // Visualizacao / Alteracao / Exclusao
	cNumEmb := U_AddPlanos()
	
	dbSelectArea("SZG")
	dbSetOrder(5)           
	dbGotop()
	If dbSeek(xFilial("SZG")+cNumEmb)
		
		While !Eof() .And. SZG->ZG_FILIAL == xFilial("SZG") .And. SZG->ZG_NUMEMB == cNumEmb
			
			dbSelectArea("TMP")
			dbAppend()
			For nCont := 1 To Len(aHeader)
				nPos := FieldPos(aHeader[nCont][2])
				If (aHeader[nCont][08] <> "M" .And. aHeader[nCont][10] <> "V" )
					FieldPut(nPos,(cAlias)->(FieldGet(FieldPos(aHeader[nCont][2]))))
				EndIf
			Next nCont
			TMP->ZG_FLAG := .F.
			dbSelectArea("SZG")
			
			dbSkip()
		EndDo
	EndIf
Else
	dbSelectArea("TMP")
	dbAppend()
	For nCont := 1 To Len(aHeader)
		If (aHeader[nCont][08] <> "M" .And. aHeader[nCont][10] <> "V" )
			nPos := FieldPos(aHeader[nCont][2])
			FieldPut(nPos,CriaVar(aHeader[nCont][2],.T.))
		EndIf
	Next nCont
		TMP->ZG_FLAG := .F.
		TMP->ZG_SEQUEN:= "01"
EndIf
dbSelectArea("TMP")
dbGoTop()                                 
RestArea(aSaveArea)
Return cNumEmb


//Funcao para gerar o numero do embarque automaticamente....
Static function GerNumEmb()
Private cEmb:= ""
cQuery := " SELECT MAX(ZG_NUMEMB) AS ZG_NUMEMB FROM SZG010 Where D_E_L_E_T_ = ' ' "
	
IF SELECT( 'TRBZG' ) > 0
	DbSelectArea( 'TRBZG' )
		DbcloseArea()
ENDIF
	dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQuery  ), 'TRBZG' , .F. , .T. )
                                                                             
	if Val(TRBZG->ZG_NUMEMB) < 9
		cEmb := '00000'+cValToChar(Val(TRBZG->ZG_NUMEMB)+1)
	elseif Val(TRBZG->ZG_NUMEMB) < 99                    
		cEmb := '0000'+cValToChar(Val(TRBZG->ZG_NUMEMB)+1)
	elseif Val(TRBZG->ZG_NUMEMB) < 999
		cEmb := '000'+cValToChar(Val(TRBZG->ZG_NUMEMB)+1)
	elseif Val(TRBZG->ZG_NUMEMB) < 99999
		cEmb := '00'+cValToChar(Val(TRBZG->ZG_NUMEMB)+1)
	elseif Val(TRBZG->ZG_NUMEMB) < 99999
		cEmb := '0'+cValToChar(Val(TRBZG->ZG_NUMEMB)+1)
	else
		cEmb := cValToChar(Val(TRBZG->ZG_NUMEMB)+1)
	endif
return 	cEmb

User function Inclui()
	Alert("Rotina não disponivel, utilize a geração de embarque...","Atenção")
return


User function AddPlanos()
Local cEmbarque:= GerNumEmb()
Local nQtdEmb  := 0     
Local cSequen  := ""  
Local nCont    := 0
DbSelectArea('SC2')                             
DbGoTop()
While !eof()
	if c2_ok == cMarca
		dbSelectArea("SZG")
		dbSetOrder(1)
		dbseek(xFilial("SZG")+SC2->C2_OPMIDO)
//			Alert("Encontrado o plano....|"+SZG->ZG_PLANO+"|)
			while !eof() .and. xFilial("SZG") == SC2->C2_FILIAL .and. Substr(SZG->ZG_PLANO,1,12) == SC2->C2_OPMIDO
//				Alert("JA Embarcado.: "+cValToChar(nCont+1)+" Vezes")
				if Year(SZG->ZG_DTEMBAR) == Year(dDatabase)
					nQtdEmb += SZG->ZG_QTDEEMB
					nCont   += 1
				endif
			 	SZG->(dbSkip())
			 enddo
//		 alert('nQtde-> '+cValToChar(nQtdEmb))	 
		if nQtdEmb < SC2->C2_QUANT	 
			RecLock("SZG",.T.)
		    SZG->ZG_FILIAL := xFilial()
		    SZG->ZG_PLANO  := SC2->C2_OPMIDO
		    SZG->ZG_NUMEMB := cEmbarque
		    if nCont < 9
			    SZG->ZG_SEQUEN := '0'+cValToChar(nCont+1)
			else
				SZG->ZG_SEQUEN := cValToChar(nCont+1)
			endif                                                                       
			SZG->ZG_QTDEPLA := SC2->C2_QUANT
			SZG->ZG_DATA    := ddatabase
			SZG->ZG_DTEMBAR := ddatabase
			SZG->ZG_QTDEEMB := SC2->C2_QUANT - nQtdEmb
			SZG->ZG_QTDISPE := SC2->C2_QUANT - nQtdEmb
			SZG->ZG_NUMOP   := SC2->C2_NUM
			MsUnlock("SZG")

		endif
	Endif              
	nQtdEmb := 0
	nCont   := 0 
	
	dbSelectArea("SC2")
	SC2->(DbSkip())
Enddo

Return cEmbarque


User Function LegStat()

Local aLegenda := { { "BR_VERDE", 'Plano ainda nao embarcado' } , ;  //"Inativa"
{ "BR_AMARELO"  ,'Plano embarcado parcial.' } }

BrwLegenda( 'Rotina de embarque de planos', 'Status ', aLegenda  ) //"Status"
Return(.T.)

