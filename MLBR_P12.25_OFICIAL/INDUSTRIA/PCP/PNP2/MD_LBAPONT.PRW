#INCLUDE "PROTHEUS.CH"

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
Este Programa controla as liberacoes de plano de producao para que os usuarios realizem os apontamentos das fichas.
*/
User Function MD_LBAPONT()
Local	nI, nn1			:= 0
Local 	aCampos		:= {}
Private cMarca 		:= GetMark()
Private nOrdemAtual := 10
Private cusrs := Getmv( 'MV_MIDOLBPL'  )
Private aUsrs := U_QuebraSep( cusrs , ';'  )
Private cUserCod  := ''
//
For nn1 := 1 to len( aUsrs )
	cUsuArray := aUsrs[ nn1 ]
	//
	if Alltrim(substr( cUsuArray  , 2 ) )   == Alltrim( RetCodUsr()   )
		cUserCod  := aUsrs[ nn1 ]
		exit
	Endif
Next
//  
/*
if cUserCod == ''
	Alert('Atenção !!! Você Não tem direito a utilizar esta rotina. Entre em contato com o Administrador do sistema.')
	Return()
Endif 
*/
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
Private cCadastro := "Planos de Produção"

Private aRotina := MnuDf()
Private aIndTmp 	:= {}
Private aSavMTA652  := Array(8)
Private oVermelho   := LoadBitmap( GetResources(), "BR_VERMELHO" )
Private oAmarelo    := LoadBitmap( GetResources(), "BR_AMARELO" )
Private oVerde      := LoadBitmap( GetResources(), "BR_VERDE" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de variaveis para rotina de inclusao automatica    ³
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
dbSelectArea("SC2")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra o arquivo conforme perguntas antes de mostrar     ³
//³ o browse                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PLNPFiltra()
dbGoTop()
// MarkBrow("SC2","C2_OK",  ,  ,   , cMarca)
//
aCampos := {}
AADD(aCampos,{"C2_OK"            		,""," "})
AADD(aCampos,{"C2_OPMIDO"    		,"","Num. Plano "    })
AADD(aCampos,{"C2_NUM"    			,"","Num.Protheus"    })
AADD(aCampos,{"C2_PLIBER"    		,"","Liberado ?"})
AADD(aCampos,{"C2_EMISSAO"  		,"","Emissao"    })
AADD(aCampos,{"C2_PRODUTO"  	,"","Produto"    })
AADD(aCampos,{"C2_QUANT"    		,"","Quantidade"    })
AADD(aCampos,{"C2_CLIENTE"    		,"","Cliente" ,   })
AADD(aCampos,{"C2_LOJA"    			,"","Loja"    })
//AADD(aCampos,{"C2_NMCLI"    		,"","Nome"  , Posicione('SA1' , 1 , xFilial('SA1') + SC2->C2_CLIENTE + SC2->C2_LOJA, 'A1_NOME'    )   })
AADD(aCampos,{"C2_RELEASE"    	,"","Release"    })
AADD(aCampos,{"C2_DTRELE"    		,"","Release"    })
AADD(aCampos,{"C2_NMLIB1"    		,"","1 Liberacao"   })
AADD(aCampos,{"C2_DTLIB1"    		,"","Data"    })
//
aCores := {} // Limpando a variavel
Aadd(aCores,{"empty(C2_USLIB1) .and. empty(C2_USLIB2) .AND. C2_LIBER <>'OK' "    ,"BR_VERMELHO" })
Aadd(aCores,{"! empty(C2_USLIB1) .and. empty(C2_USLIB2) .AND. C2_LIBER <>'OK'  " ,"BR_AMARELO"   })
//
MarkBrow("SC2","C2_OK", ,aCampos , , cMarca , , , , , , , , , )
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna indices do SC2                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SC2")
dbSetOrder(10 ) // Ordenado pelo numero do Plano do Cliente
aEval(aIndTmp, {|cFile| fErase(cFile+OrdBagExt())})


RETURN
//----------------------------------
Static FUNCTION PLNPFiltra(nOrder)
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
cFirmaCond += 'C2_FILIAL=="'+xFilial("SC2")+'".And.C2_TPOP=="'+"F"+'".And. '
cFirmaCond += ' C2_PLIBER == .F. .AND. ! Empty( C2_OPMIDO ) '

IndRegua("SC2",cNomeInd,cIndice,,cFirmaCond,STR0006)	//"Selecionando Registros..."

nInd := RetIndex("SC2")
dbSetOrder(nInd+1)
Return
//--------------------------------------------
Static Function MnuDf()

/*
PRIVATE aRotina	:= {	{"Pesquisar"         	,"u_LPLNPesqui"	,0,1,0,.f.},;
{'Visualizar ' 			,"U_VISUPLANO"	,0,4,0,.f.},;
{'Aprovar ' 				,"U_APROVPL"		,0,5,0,.f.},;
{'Legenda '				,"u_Mid_LegPlP"   ,0,5,0,.f.} }
*/
PRIVATE aRotina	:= {	{"Pesquisar"         	,"AxPesqui"	,0,1,0,.f.},;
						{'Visualizar ' 			,"U_VISUPLANO"	,0,4,0,.f.},;
						{'Aprovar ' 			,"U_APROVAPL"		,0,5,0,.f.} }


Return(aRotina)
//------------------------------------------------------------------------------------------------
//  A funcao abaixo tem como objetivo realizar a aprovacao do plano, verificando o status do aprovador,
// Bem como a sua existencia no cadastro de aprovadores
User Function APROVAPL()
If  ! MsgYesno( 'Deseja Realmente aprovar os itens Selecionados ?' )
	Return()
Endif
//
DbSelectArea('SC2')
DbGoTop()
While !SC2->(eof())     
	
	if c2_ok == cMarca
		// O bloco abaixo fara a verificacao quanto a seu o usuario podera realizar todas as liberacoes de uma so vez ou se ele somente podera faze-la
		// na primeira ou seguna vez
		//                                                     
		Reclock('SC2' , .f. )
			Replace C2_PLIBER 	WITH  .T.
		Msunlock()
        //
	Endif
	// 
	SC2->(DbSkip())
Enddo
//
Return()
//------------------------------------------------------------------------------------------------
/*
User Function QuebraSep( Linha , cSep  )  // A Variavel cSep indica qual o separador que servira para a quebra do item e alimentacao da array
Local aItens1 := {} // Array que sera preenchida a partir da quebra dos itens
Local cDsAux := ''
Local n1 := 1
//
For n1 := 1 to len( Linha )
	if substr(linha,n1,1) <> csep
		cDsAux += substr(linha,n1,1)
	Else
		AAdd( aItens1, cDsAux )
		cDsAux := ''
	Endif
	//
Next
// Adicionando o ultimo elemento da quebra com o item
if cDsAux <> ''
	AAdd( aItens1, cDsAux )
Endif

Return( aitens1 )
*/
//--------------------------------------------------------