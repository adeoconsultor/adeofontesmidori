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
Este Programa controla as liberacoes de plano de producao por usuario. Especifico Midori. Desenvolvido por Rogerio Nunes em 03/02/10.
*/
User Function AGF_GERFIC()
Local	nI			:= 0
Local 	aCampos		:= {}
Local nn1
Private cMarca 		:= GetMark()
Private nOrdemAtual := 10
Private cusrs := Getmv( 'MV_MIDOLBPL'  )
Private aUsrs := U_QuebraSep( cusrs , ';'  )
Private cUsuPermit  := ''
Private oOk := LoadBitmap( GetResources(), "LBOK")
Private oNo := LoadBitmap( GetResources(), "LBNO")
//
For nn1 := 1 to len( aUsrs )
	cUsuArray := aUsrs[ nn1 ]
	//
	if Alltrim(substr( cUsuArray  , 2 ) )   == Alltrim( RetCodUsr()   )
		cUsuPermit  := aUsrs[ nn1 ]
		exit
	Endif
Next
//
/*
if cUsuPermit == ''
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

Private aRotina := MnuMonta()
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
For ni := 1 to 8
	aSavMTA652[ni] := &("mv_par"+StrZero(ni,2))
Next ni



dbSelectArea("SZP")
dbSetOrder(2)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra o arquivo conforme perguntas antes de mostrar     ³
//³ o browse                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  PLNPFiltra()
//set filter to ZP_FILIAL== xFilial("SZP") .And. ZP_LIBER == "OK" //.and. (ZP_ANO == cValToChar(Year(dDatabase))) //.or. ZP_ANO = '2013')
dbGoTop()
// MarkBrow("SC2","C2_OK",  ,  ,   , cMarca)
//
aCampos := {}
AADD(aCampos,{"ZP_OK"    		,"",""     	})
AADD(aCampos,{"ZP_OPMIDO"    		,"","Num. Plano "     	})
AADD(aCampos,{"ZP_EMISSAO"  		,"","Emissao"  		  	})
AADD(aCampos,{"ZP_QUANT"    		,"","Quantidade"    	})
AADD(aCampos,{"ZP_PRODUTO"  		,"","Produto"   		})
AADD(aCampos,{"ZP_CLIENTE"    		,"","Cliente"    		})
AADD(aCampos,{"ZP_LOJA"    			,"","Loja"    			})
AADD(aCampos,{"ZP_NOMCLIE"    		,"","Nome"     			})
AADD(aCampos,{"ZP_RELEASE"    		,"","Release"    		})
AADD(aCampos,{"ZP_DTRELEA"    		,"","Release"    		})
AADD(aCampos,{"ZP_NMLIB1"    		,"","1 Liberacao"   	})
AADD(aCampos,{"ZP_DTLIB1"    		,"","Data"    			})
AADD(aCampos,{"ZP_NMLIB2"    		,"","2 Liberacao"   	})
AADD(aCampos,{"ZP_DTLIB2"    		,"","Data"    			})
AADD(aCampos,{"ZP_EMISSAO"    		,"","Impr. Ficha"    	})
//
aCores := {} // Limpando a variavel
//Aadd(aCores,{"empty(C2_USLIB1) .and. empty(C2_USLIB2) .AND. C2_LIBER <>'OK' "    ,"BR_VERMELHO" })
//Aadd(aCores,{"! empty(C2_USLIB1) .and. empty(C2_USLIB2) .AND. C2_LIBER <>'OK'  " ,"BR_AMARELO"   })
//
// MarkBrow("SC2","C2_OK", ,aCampos ,  , cMarca , , , , , , , , ,  )
MarkBrow("SZP","ZP_OK", ,aCampos ,  , cMarca , , , , , , , , ,  )
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna indices do SC2                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RetIndex("SZP")
aEval(aIndTmp, {|cFile| fErase(cFile+OrdBagExt())})
dbSetOrder(1)

RETURN
//----------------------------------
Static FUNCTION PLNPFiltra(nOrder)
LOCAL cIndice,nInd,cFirmaCond:=""
Local cNomeInd:=CriaTrab(NIL,.F.)
nOrder := If(nOrder=Nil,2,nOrder)

Aadd(aIndTmp, cNomeInd)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera index de trabalho do SC2                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZP")
dbSetOrder(2)
cIndice   := Indexkey()
cFirmaCond += 'ZP_FILIAL=="'+xFilial("SZP")+'".And. '
cFirmaCond += ' ZP_LIBER == "OK" '  
cFirmaCond += ' .and. ZP_ANO = "'+cValToChar(Year(dDatabase))+'" '

//
IndRegua("SZP",cNomeInd,cIndice,,cFirmaCond,STR0006)	//"Selecionando Registros..."
nInd := RetIndex("SZP")
#IFNDEF TOP
	dbSetIndex(cNomeInd+OrdBagExt())
#ENDIF
dbSetOrder(nInd+1)
Return

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

Static Function MnuMonta()

PRIVATE aRotina	:= {}
AaDd( aRotina	,	{"Pesquisar"         		,"aXPesqui"	,0,1,0,.f.} )
AaDd( aRotina	,	{'Visualizar ' 				,"U_VISUP"	,0,4,0,.f.} ) 
//
if cUsuPermit <> ''
   AaDd( aRotina	,	{'Fichas de Corte' 	    ,"U_AGF_DETFHC( SC2->(RECNO() )  )",0,5,0,.f.} )
Endif 
//
AaDd( aRotina	,	{'Status PLano' 	        ,"U_StatFic()" ,0,5,0,.f.} )
AaDd( aRotina	,	{'Legenda '					,"u_Mid_LegPlP"   ,0,5,0,.f.} )
									
// U_MD_GRFCOR(  SC2->(RECNO() )  )
//-------------------------
Return(aRotina)
//------------------------------------------------------------------------------------------------
Static Function ChvFic()
Return('ZP_FILIAL== xFilial("SZP").And. ZP_LIBER == "OK" ')
//------------------------------------------------------------------------------------------------

/*USer   Function QuebraSep( Linha , cSep  )  // A Variavel cSep indica qual o separador que servira para a quebra do item e alimentacao da array
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
//
//
Return( aitens1 )
//--------------------------------------------------------