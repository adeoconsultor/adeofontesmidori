#INCLUDE "TOPCONN.ch" 
#INCLUDE "TOTVS.Ch"

// Define dos modos das rotinas
#DEFINE VISUALIZAR	2
#DEFINE INCLUIR		3
#DEFINE ALTERAR		4
#DEFINE EXCLUIR		5
#DEFINE OK			1
#DEFINE CANCELA		2
#DEFINE ENTER		Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ MIDAMAN01 ณ Autor ณ Antonio - ADVPL TEC  ณ Data ณ 17.09.15 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Rotina para Manuten็ใo do Kit                              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe e ณ MIDAMAN01()                                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Midori                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ PROGRAMADOR  ณ DATA   ณ MOTIVO DA ALTERACAO                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ        ณ                                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Criadas as tabelas SZT E SZU, caso ja tenha no cliente, criaremos outras posteriores.

SZT
ZT_CODKIT - Produto Kit Fardo C 15
ZT_DSCKIT - Dscri็ใo Prd Kit Fardo C 45

SZU

ZU_CODKIT   - Produto Kit Fardo C 15    R/V  (nใo aparece nos itens)
ZU_ITEM     - Item              C 04    R/A
ZU_PRODUTO  - Cod Produto       C 15    R/A
ZU_DSCPRD   - Descri็ใo Produto C 45    R/V
ZU_UMPRD    - Unidade de Medida C 02    R/V
ZU_QTDE     - Qtde              N 05 02 R/A
ZU_PRATEIO  - % Rateio          N 05 02 

Incluir valida็ใo U_DURAPRD() no campo (ZU_PRODUTO)


/*/
User Function MIAMAN01()

Private cCadastro	:= "Manuten็ใo em KIT FARDO"
Private cAlias		:= "SZT"
Private aRotina		:= MenuDef()

dbSelectArea(cAlias)
SZT->(dbSetOrder(1)) // ZT_FILIAL+ZT_CODMAN
SZT->(dbGotop())
mBrowse(,,,,cAlias )  

Return()          


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณMenuDef  ณ Autor ณ Antonio Carlos Damaceno ณ Data ณ17/09/15 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Utilizacao de menu Funcional                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณArray com opcoes da rotina.                                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณParametros do array a Rotina:                               ณฑฑ
ฑฑณ          ณ1. Nome a aparecer no cabecalho                             ณฑฑ
ฑฑณ          ณ2. Nome da Rotina associada                                 ณฑฑ
ฑฑณ          ณ3. Reservado                                                ณฑฑ
ฑฑณ          ณ4. Tipo de Transao a ser efetuada:                        ณฑฑ
ฑฑณ          ณ		1 - Pesquisa e Posiciona em um Banco de Dados     ณฑฑ
ฑฑณ          ณ    2 - Simplesmente Mostra os Campos                       ณฑฑ
ฑฑณ          ณ    3 - Inclui registros no Bancos de Dados                 ณฑฑ
ฑฑณ          ณ    4 - Altera o registro corrente                          ณฑฑ
ฑฑณ          ณ    5 - Remove o registro corrente do Banco de Dados        ณฑฑ
ฑฑณ          ณ5. Nivel de acesso                                          ณฑฑ
ฑฑณ          ณ6. Habilita Menu Funcional                                  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao efetuada                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function MenuDef()
Local aRotina := {}

aAdd( aRotina ,{"Pesquisar"  , "AxPesqui"	,0,1 }) //"Pesquisar"
aAdd( aRotina ,{"Visualizar" , "U_UInclui"	,0,2 }) //"Visualizar"
aAdd( aRotina ,{"Incluir"    , "U_UInclui"	,0,3 }) //"Incluir"
aAdd( aRotina ,{"Alterar"    , "U_UInclui"	,0,4 }) //"Alterar"
aAdd( aRotina ,{"Excluir"    , "U_UInclui"	,0,5 }) //"Excluir"

Return(aRotina)





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUInclui บAutor  ณAntonio               บ Data ณ  17/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo de manutn็ใo Dados do KIT FARDO                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fat                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UInclui(cAlias,nRecNo,nOpc)

Local aHeader 		:= {}
Local aCols   		:= {}
Local cCPOs			:= ""		      // Campos que aparecerใo na getdados
Local cChav			:= ""
Private oEnch		:= Nil
Private oDlg		:= Nil
Private oGet		:= Nil

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis internas para a MsMGet()ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aTELA[0][0]
Private aGETS[0]

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis para a MsAdvSize e MsObjSizeณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private lEnchBar	:= .F.            // Se a janela de diแlogo possuirแ enchoicebar (.T.)
Private lPadrao 	:= .F.            // Se a janela deve respeitar as medidas padr๕es do Protheus (.T.) ou usar o mแximo disponํvel (.F.)
Private nMinY	   	:= 400            // Altura mํnima da janela

Private aSize		:= MsAdvSize(lEnchBar, lPadrao, nMinY)
Private aInfo	   	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3} // Coluna Inicial, Linha Inicial
Private aObjects   	:= {}
Private aPosObj	   	:= {}

aAdd(aObjects,{100,100,.T.,.F.})      // Definicoes para a Enchoice
aAdd(aObjects,{150,150,.T.,.F.})      // Definicoes para a Getdados
aAdd(aObjects,{100,025,.T.,.F.})

aPosObj := MsObjSize(aInfo,aObjects)  // Mantem proporcao - Calcula Horizontal


// Valida็ใo da inclusใo
If SZT->(RecCount()) == 0 .And. !(nOpc==INCLUIR)
	Return .T.
Endif

cCPOs := "ZU_CODKIT"

aHeader	:= CriaHeader(NIL,cCPOs,aHeader,"SZU")
aCols	:= CriaAcols(aHeader,"SZU",1,xFilial("SZU")+SZT->ZT_CODKIT,nOpc,aCols)
MontaTela(aHeader,aCols,nRecNo,nOpc)

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaHeaderบAutor  ณANTONIO                    ณ  19/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria o Aheader da getdados                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FAT                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaHeader(cCampos,cExcessao,aHeader,cAliasG)
Local   aArea		:= (cAliasG)->(GetArea())
Default aHeader 	:= {}
DEFAULT cCampos 	:= "" // Campos a serem considerados
DEFAULT cExcessao	:= "" // Campos que nใo considerados

SX3->(dbSetOrder(1))
SX3->(dbSeek(cAliasG))
While SX3->(!EOF()) .And.  SX3->X3_ARQUIVO == cAliasG
	If (cNivel >= SX3->X3_NIVEL) .AND. !(AllTrim(SX3->X3_CAMPO) $ Alltrim(cExcessao)) .And. (X3USO(SX3->X3_USADO))
		aAdd( aHeader, { AlLTrim( X3Titulo() ), ; // 01 - Titulo
		SX3->X3_CAMPO	, ;				// 02 - Campo
		SX3->X3_Picture	, ;				// 03 - Picture
		SX3->X3_TAMANHO	, ;				// 04 - Tamanho
		SX3->X3_DECIMAL	, ;				// 05 - Decimal
		SX3->X3_Valid  	, ;				// 06 - Valid
		SX3->X3_USADO  	, ;				// 07 - Usado
		SX3->X3_TIPO   	, ;				// 08 - Tipo
		SX3->X3_F3		, ;				// 09 - F3
		SX3->X3_CONTEXT , ;	    	   	// 10 - Contexto
		SX3->X3_CBOX	, ; 	  		// 11 - ComboBox
		SX3->X3_RELACAO , } )   		// 12 - Relacao
	Endif
	SX3->(dbSkip())
End
RestArea(aArea)
Return(aHeader)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaAcolsบAutor  ณANTONIO                    ณ  19/11/14   บฑฑ
ฑฑบDesc.     ณFunc๕a que cria Acols                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณaHeader : aHeader aonde o aCOls serแ baseado                บฑฑ
ฑฑบ          ณcAlias  : Alias da tabela                                   บฑฑ
ฑฑบ          ณnIndice : Indice da tabela que sera usado para              บฑฑ
ฑฑบ          ณcComp   : Informacao dos Campos para ser comparado no While บฑฑ
ฑฑบ          ณnOpc    : Op็ใo do Cadastro                                 บฑฑ
ฑฑบ          ณaCols   : Opcional caso queira iniciar com algum elemento   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriaAcols(aHeader,cAliasG,nIndice,cComp,nOpc,aCols)
Local 	nX			:= 0
Local 	nCols     	:= 0
Local   aArea		:= (cAliasG)->(GetArea())
DEFAULT aCols 		:= {}

IF nOpc == INCLUIR
	aAdd(aCols,Array(Len(aHeader)+1))
	aCols[1][Len(aHeader)+1] := .F.

	For nX := 1 To Len(aHeader)
//		aCols[1][nX] := CriaVar(aHeader[nX][2])

		IF AllTrim(aHeader[nX,2]) == "ZU_ITEM"			
			aCols[1,nX]:= Soma1("0000")		
		ELSE			
			aCols[1,nX]:=CriaVar(aHeader[nX,2])		
		ENDIF	
	
	Next nX
//	aCols[1][Len(aHeader)+1] := .F.
Else

	(cAliasG)->(dbSetOrder(nIndice))
	(cAliasG)->(dbSeek(cComp))
	While (cAliasG)->(!Eof()) .And. ALLTRIM((cAliasG)->(ZU_FILIAL+ZU_CODKIT)) == ALLTRIM(cComp)
		aAdd(aCols,Array(Len(aHeader)+1))
		nCols ++
		For nX := 1 To Len(aHeader)
			If ( aHeader[nX][10] != "V")
				aCols[nCols][nX] := (cAliasG)->(FieldGet(FieldPos(aHeader[nX][2])))
			Else
				aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
			Endif
		Next nX
		aCols[nCols][Len(aHeader)+1] := .F.
		(cAliasG)->(dbSkip())
	End
EndIf
RestArea(aArea)
Return(aCols)


    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaTela บAutor  ณณANTONIO            บ Data ณ  17/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFunc็ใo responsแvel por montar a tela                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaTela(aHeader,aCols,nReg,nOpc)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis da MsNewGetDados()      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nOpcX			:= 0                                 // Op็ใo da MsNewGetDados
Local cLinhaOk     	:= "U_MAN001LOK()" 					 // Funcao executada para validar o contexto da linha atual do aCols (Localizada no Fonte GS1008)
Local cTudoOk      	:= "AllwaysTrue()" 					// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos     	:= ""                       		// Nome dos campos do tipo caracter que utilizarao incremento automatico.
Local nFreeze      	:= 000              				// Campos estaticos na GetDados.
Local nMax         	:= 999              				// Numero maximo de linhas permitidas.
Local aAlter    	:= {}                               // Campos a serem alterados pelo usuario
Local cFieldOk     	:= "AllwaysTrue"					// Funcao executada na validacao do campo
Local cSuperDel    	:= "AllwaysTrue"          			// Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cDelOk       	:= "AllwaysTrue"    				// Funcao executada para validar a exclusao de uma linha do aCols
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis da MsMGet()             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local aAlterEnch	:= {}                  // Campos que podem ser editados na Enchoice
Local aPos		  	:= {000,000,120,400}   // Dimensao da MsMget em relacao ao Dialog  (LinhaI,ColunaI,LinhaF,ColunaF)
Local nModelo		:= 3     			   // Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local lF3 		  	:= .F.				   // Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria		:= .T.	   	 	       // Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lColumn		:= .F.				   // Indica se a apresentacao dos campos sera em forma de coluna
Local caTela 		:= "" 				   // Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lNoFolder		:= .F.				   // Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty		:= .F.				   // Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis da EnchoiceBar()        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nOpcA			:= 0										// Botใo Ok ou Cancela
Local nCont			:= 0
Local aArea			:= GetArea()
Local lExistGet
Local oCodKit := Nil
Local oDescri := Nil

Private cCodKit := ""
Private cDescri := ""

If nOpc != INCLUIR

	cCodKit := SZT->ZT_CODKIT
	cDescri := SZT->ZT_DSCKIT

Else
	cCodKit := CriaVar("ZT_CODKIT")
	cDescri := Posicione("SB1",1,xFilial("SB1")+cCodKit,"B1_DESC")
EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAdiciona os campos a serem atualizados pelo usuario na MsNewGetDadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nCont := 1 to Len(aHeader)

	aAlter := {"ZU_ITEM","ZU_PRODUTO","ZU_QTDE","ZU_PRATEIO"}

	If ( aHeader[nCont][10] != "V") .And. X3USO(aHeader[nCont,7])
		aAdd(aAlter,aHeader[nCont,2])
	EndIf
Next nCont

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefini็ใod dos Objetosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oDlg := MSDIALOG():New(aSize[7],aSize[2],aSize[6],aSize[5],cCadastro,,,,,,,,,.T.)

If nOpc == INCLUIR .Or. nOpc == ALTERAR
	nOpcX	:= GD_INSERT+GD_UPDATE+GD_DELETE
Else
	nOpcX	:= 0
EndIf

oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,36,.T.,.F.)
oTPane1:Align := CONTROL_ALIGN_TOP
@ 004, 006 SAY "Produto Kit Fardo: " SIZE 90,7 PIXEL OF oTPane1 
@ 004, 250 SAY "Descri็ใo: " SIZE 90,7 PIXEL OF oTPane1

@ 003, 066 MSGET oCodKit VAR cCodKit  Picture "@!" When INCLUI Valid NaoVazio(cCodKit) .And. U_EnchMan(cCodKit,nOpc)  SIZE 50,7 PIXEL OF oTPane1 F3 "SB1"
@ 4.1, 300 SAY   cDescri SIZE 230,7 PIXEL OF oTPane1


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMsNewGetDadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
oGet			:= MsNewGetDados():New(aPosObj[2][1],aPosObj[2][2],aPosObj[2][3],aPosObj[2][4],nOpcX,;
cLinhaOk ,cTudoOk,"+ZU_ITEM" /*cIniCpos*/,aAlter,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oDLG,aHeader,aCols)
oGet:obrowse:align:= CONTROL_ALIGN_ALLCLIENT

oDlg:bInit 		:= EnchoiceBar(oDlg,{||IIF( IIF(nOpc == INCLUIR .Or. nOpc == ALTERAR, U_MAN001TOK(nOpc) , .T.) ,(nOpcA:=1,oDlg:End()), )},{|| oDlg:End()})
oDlg:lCentered	:= .T.
oDlg:Activate()

If nOpcA == OK .AND. !(nOpc == VISUALIZAR)
	Begin Transaction
	MAN001Grava(nOpc)
	ConfirmSX8()
	End Transaction
Else
	RollBackSX8()
Endif

RestArea(aArea)
Return(nOpcA)

User Function XTeste(cCodKit)
	cDescri := Posicione("SB1",1,xFilial("SB1")+cCodKit,"B1_DESC")
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ EnchMan  บAutor  ณANTONIO             บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao para o campo Kit Fardo                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function EnchMan(cCodKit,nOpc)
Local lRet	:= .T.

If lRet .and. nOpc==3
	lRet := ExistChav("SZT", cCodKit ) 
	cDescri := Posicione("SB1",1,xFilial("SB1")+cCodKit,"B1_DESC")
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMAN001LOK บAutor  ณANTONIO บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo LinOK da rotina                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MAN001LOK(nLinha,lHelp)
Local lRet 			:= .T.
Local nX			:= 0
Local aCols 		:= oGet:aCols
Local aHeader		:= oGet:aHeader
Local nPosItem		:= aScan(aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_ITEM")})
Local nPosChav		:= aScan(aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_PRODUTO")})
Local nTRateio		:= 0

Default nLinha := oGet:nAt
Default lHelp := .T.

For nX:= 1 to Len(aCols)

	If !aCols[nX][Len(aHeader)+1] .And. nX != nLinha .And.;
		ALLTRIM(aCols[nX][nPosChav]) == ALLTRIM(aCols[nLinha][nPosChav])
		If lHelp
			Help(" ",1,"FR0LINDUP" , , "Linha Duplicada" ,3,0 )
		EndIf
		lRet := .F.
		Exit
	EndIf 

	nTRateio:=nTRateio+oGet:aCols[nX,GdFieldPos("ZU_PRATEIO",aHeader)]
	
Next nX

If nTRateio > 100
	If lHelp
		Help(" ",1,"FR0LINDUP" , , "Total do Rateio nใo pode ser maior que 100% !!!" ,3,0 )
	EndIf
	lRet := .F.
	
EndIf


If nLinha == Len(aCols) + 1
	oGet:aCols[nLinha+1,GdFieldPos("ZU_ITEM",aHeader)]:= Soma1(Str(nLinha+1))
EndIf

Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMAN001Grava บAutor  ณANTONIO บ Data ณ  19/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para efetuar a grava็ใo nas tabelas                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIN                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MAN001Grava(nOpc)
Local nX			:= 0
Local nI 			:= 0
//Local nPosChav		:= aScan(oGet:aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_CODMAN")})
Local nPosChav		:= cCodKit
Local nPosChvAux	:= aScan(oGet:aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_ITEM")})

Local nPosProd		:= aScan(oGet:aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_PRODUTO")})

Local nPosDesc      := aScan(oGet:aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_DSCPRD")})
Local nPosUM        := aScan(oGet:aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_UMPRD")})

Local nPosQtde		:= aScan(oGet:aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_QTDE")})
Local nPosPRat      := aScan(oGet:aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_PRATEIO")})

Local lGrava		:= .F.
Local cArquivo		:= ""
Local cChave		:= ""
Local nIndex		:= 0
Local aArea			:= GetArea()
Local aAreaSZT		:= SZT->(GetArea())
Local cAliasG		:= "SZU"

If nOpc == INCLUIR .Or. nOpc == ALTERAR
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณGrava o cabe็alho da tabelaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	lGrava := ( SZT->(dbSeek(xFilial("SZT")+cCodKit)) )
	RecLock("SZT",!lGrava)
	SZT->ZT_FILIAL  := xFilial("SZT")
	SZT->ZT_CODKIT  := cCodKit
	SZT->ZT_DSCKIT  := cDescri

	MsUnLock()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณGrava os Itens da Tabelaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For nX:= 1 to Len(oGet:aCols)
		lGrava := ( (cAliasG)->(dbSeek(xFilial(cAliasG)+cCodKit+oGet:Acols[nX,nPosChvAux])) )
		If oGet:Acols[nX,Len(oGet:aHeader)+1] .And. lGrava .And. U_MAN001LOK(nX,.F.)
			RecLock(cAliasG,!lGrava)
			( cAliasG )->( dbDelete() )
			MsUnlock()
		ElseIf !oGet:Acols[nX,Len(oGet:aHeader)+1] .And. (!Empty(cCodKit) .Or. !Empty(oGet:Acols[nX,nPosChvAux]))
			RecLock(cAliasG,!lGrava)
			(cAliasG)->ZU_FILIAL := xFilial(cAliasG)
			(cAliasG)->ZU_CODKIT := cCodKit
			For nI:= 1 to Len(oGet:aHeader)
				(cAliasG)->(FieldPut(FieldPos(Trim(oGet:aHeader[nI,2])),oGet:aCols[nX,nI]))
			Next nI

			nPosProd	:= oGet:aCols[nX,GdFieldPos("ZU_PRODUTO", oGet:aHeader)]
			nPosDesc	:= oGet:aCols[nX,GdFieldPos("ZU_DSCPRD" , oGet:aHeader)]
			nPosUM  	:= oGet:aCols[nX,GdFieldPos("ZU_UMPRD"  , oGet:aHeader)]
			nPosQtde	:= oGet:aCols[nX,GdFieldPos("ZU_QTDE"   , oGet:aHeader)]
			nPosPRat 	:= oGet:aCols[nX,GdFieldPos("ZU_PRATEIO", oGet:aHeader)]

			MsUnLock()
		EndIf
	Next nX
	
ElseIf nOpc == EXCLUIR
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDeleta os Itensณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SZT->(dbSetOrder(1)) // ZT_FILIAL + ZT_CODMAN
	If SZT->(dbSeek(xFilial("SZT")+ cCodKit))
		RecLock(cAlias,.F.)
		( cAlias )->( dbDelete() )
		MsUnlock()
	EndIf
		
	(cAliasG)->(dbSeek(xFilial(cAliasG)+cCodKit))
	While (cAliasG)->(!EOF()) .And. (cAliasG)->(ZU_FILIAL + ZU_CODMAN ) == xFilial(cAliasG)+cCodKit
		RecLock(cAliasG,.F.)
		( cAliasG )->( dbDelete() )
		MsUnlock()
		(cAliasG)->(dbSkip())
	EndDo


	For nX:= 1 to Len(oGet:aCols)

		nPosProd := oGet:aCols[nX,GdFieldPos("ZU_PRODUTO", oGet:aHeader)]
		nPosDesc := oGet:aCols[nX,GdFieldPos("ZU_DSCPRD" , oGet:aHeader)]
		nPosUM   := oGet:aCols[nX,GdFieldPos("ZU_UMPRD"  , oGet:aHeader)]
		nPosQtde := oGet:aCols[nX,GdFieldPos("ZU_QTDE"   , oGet:aHeader)]
		nPosPRat := oGet:aCols[nX,GdFieldPos("ZU_PRATEIO", oGet:aHeader)]
	
	Next	

EndIf

dbSetOrder(1)

RestArea(aAreaSZT)
RestArea(aArea)
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMAN001TOK บAutor  ณANTONIO บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo TudoOK da rotina                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MAN001TOK(nOpc)
Local lRet 			:= .T.
Local nX	  		:= 0
Local aCols 		:= oGet:aCols
Local aHeader		:= oGet:aHeader
Local nPosChav		:= aScan(aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_PRODUTO")})
Local nItens		:= 0
Local nPos			:= 0
Local nTRateio      := 0

lRet := NaoVazio(cCodKit) .And. U_EnchMan(cCodKit,nOpc)

If lRet
	For nX:= 1 to Len(aCols)
		If !aCols[nX][Len(aHeader)+1]
			If !U_MAN001LOK(nX)
				lRet := .F.
				Exit
			ElseIF !Empty(aCols[nX][nPosChav])
				nItens++
			EndIf
		EndIf

		nTRateio:=nTRateio+oGet:aCols[nX,GdFieldPos("ZU_PRATEIO",aHeader)]

	Next nX
EndIf

If lRet .And. nItens == 0
	Help(" ",1,"FR0NOLIN" , , "Por favor, crie pelo menos um item" ,3,0 )
	lRet := .F.
EndIf

If lRet	
	If nTRateio <> 100
//		If lHelp
			Help(" ",1,"FR0LINDUP" , , "Total do Rateio nใo pode ser maior ou menor que 100% !!!" ,3,0 )
//		EndIf
		lRet := .F.
	EndIf
EndIf

Return lRet

     
   
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ DURAPRD  ณ Autor ณ Antonio                 ณ Data ณ26/11/2014ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Buscar nome do Produto/Unidade na getdados do cCodKit        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametros ณ oObjeto := Objeto da NewGetDados                             ณฑฑ
ฑฑณ           ณ nLinha  := Linha da GetDados, caso o parametro nao seja      ณฑฑ
ฑฑณ           ณ            preenchido o Default sera o nAt da NewGetDados    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function DURAPRD() 

	Local lRet  := .T.
	Local cProduto, nPosProd

	nPosProd := oGet:aCols[oGet:nAt,GdFieldPos("ZU_PRODUTO",oGet:aHeader)]

	If Empty(cProduto)

		If Alltrim(Readvar()) == "M->ZU_PRODUTO"
			nPosProD := M->ZU_PRODUTO
		Else
			nPosProD := oGet:aCols[oGet:nAt,GdFieldPos("ZU_PRODUTO",oGet:aHeader)]
		EndIf

		SB1->(dbSetOrder(1)) // B1_FILIAL + B1_COD
		If SB1->(dbSeek(xFilial("SB1") + nPosProd ))

			If !oGet:aCols[oGet:nAt,Len(oGet:aHeader)+1]

				oGet:aCols[oGet:nAt,GdFieldPos("ZU_DSCPRD",oGet:aHeader)]:=SB1->B1_DESC
				oGet:aCols[oGet:nAt,GdFieldPos("ZU_UMPRD",oGet:aHeader)]:=SB1->B1_UM

				cDescPRD := SB1->B1_DESC
			    cUMPRD   := SB1->B1_UM
			
				oGet:Refresh()
			EndIf
		EndIf
	EndIf


	If !oGet:aCols[oGet:nAt,Len(oGet:aHeader)+1]

		If Alltrim(Readvar()) == "M->ZU_PRODUTO"
			nPosProD := M->ZU_PRODUTO
		Else
			nPosProD := oGet:aCols[oGet:nAt,GdFieldPos("ZU_PRODUTO",oGet:aHeader)]
		EndIf

		SB1->(dbSetOrder(1)) // B1_FILIAL + B1_COD
		If SB1->(dbSeek(xFilial("SB1") + nPosProd ))

			If !oGet:aCols[oGet:nAt,Len(oGet:aHeader)+1]

				oGet:aCols[oGet:nAt,GdFieldPos("ZU_DSCPRD",oGet:aHeader)]:=SB1->B1_DESC
				oGet:aCols[oGet:nAt,GdFieldPos("ZU_UMPRD",oGet:aHeader)]:=SB1->B1_UM

				cDescPRD := SB1->B1_DESC
			    cUMPRD   := SB1->B1_UM
			
				oGet:Refresh()
			EndIf
		EndIf

//		oGet:aCols[oGet:nAt,GdFieldPos("ZU_NOMCLI",oGet:aHeader)]:=Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NOME")

	EndIf

	oGet:ForceRefresh()
	oGet:obrowse:Refresh()

Return(lRet)


