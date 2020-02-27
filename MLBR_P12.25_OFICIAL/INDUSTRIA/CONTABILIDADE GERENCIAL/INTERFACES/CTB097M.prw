// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : CTB097M
// ---------+-------------------+-----------------------------------------------------------
// Date     | Author Willer Trindade| Contabilizacao das Despesas Importação
// ---------+-------------------+-----------------------------------------------------------
// 21/10/15 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"
#Include "PROTHEUS.Ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"


//------------------------------------------------------------------------------------------
/*/{Protheus.doc}
Montagem da tela de processamento

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     21/10/2015
/*/
//------------------------------------------------------------------------------------------
User Function CTB097M
//--< variáveis >---------------------------------------------------------------------------
Local oBrowse
Local cFiltro

Local oGrp    	:= Nil
Local bOk     	:= {||nOpcao:=1, oDlg:End() }
Local bCancel 	:= {||nOpcao:=0, oDlg:End() }
Local nOpcao  	:= 0


Private oDlg  	:= Nil
Private cIMP    := "        "

DEFINE MSDIALOG oDlg TITLE "Selecione o Processo de Importação" From 1,1 to 150,370 of oMainWnd PIXEL
oGrp  := TGroup():New( 15,5,48,100,"Seleção Importação",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
@ 27,10 SAY "Proc: " SIZE 100,7 PIXEL OF oDlg
@ 27,32 MSGET cIMP Picture "@!" F3 "SW6" SIZE 60,7 PIXEL OF oDlg
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) Centered


If nOpcao == 1
	
	cFiltro := 	" WD_HAWB = Alltrim(cIMP) "
	
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetDescription( "Contabilizacao das Despesas de Importação" )
	oBrowse:ForceQuitButton()	    // Força a exibicao do botão Sair
	oBrowse:SetAlias( "SWD" )
	
	oBrowse:SetFilterDefault( cFiltro )
	
	oBrowse:AddLegend( 'WD_NF_COMP > " " .AND. WD_BASEADI <> "1"', "RED" , "Despesa NF Primeira")
	oBrowse:AddLegend( 'WD_NF_COMP = " " .AND. WD_BASEADI <> "1"', "GREEN"  , "Despesa Sem Vinculo")
	//oBrowse:AddLegend( 'E5_SITUACA $ "X"', "YELLOW" , "Movimento Bancario - Cancelado" )
	//oBrowse:AddLegend( 'E5_SITUACA $ "E"', "RED" , "Movimento Bancario - Estorno" )
	
	oBrowse:Activate()
Else
	Return
EndIf
Return
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Modelo de dados do cadastro
/*/
//-------------------------------------------------------------------
Static Function Modeldef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruSWD 	:= FWFormStruct( 1, 'SWD' )
Local oModel // Modelo de dados que será construído

// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New('SWDMODEL',/*Pre-Validacao*/ ,/*{ |oModel| ftudoOk(oModel) }*/,/* { |oModel| fCommit(oModel) }*/,/*Cancel*/ )

// Adiciona ao modelo um componente de formulário
oModel:AddFields('SWDMASTER', /*cOwner*/, oStruSWD  )

// Adiciona a descrição do Modelo de Dados
oModel:SetDescription( 'Contabilizacao das Despesas de Importação' )

// Adiciona a descrição do Componente do Modelo de Dados
oModel:GetModel( 'SWDMASTER' ):SetDescription( 'SWD - Despesas de Importação' )

// chave primaria
oModel:SetPrimaryKey( {} )

oModel:GetModel( 'SWDMASTER' ):SetOnlyView ( .T. )
oModel:GetModel( 'SWDMASTER' ):SetOptional( .T. )

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
View de dados do Cadastro
/*/
//-------------------------------------------------------------------
Static Function ViewDef()

Local oView
Local oModel  := FWLoadModel( "CTB097M" )

Local oStruSWD := FWFormStruct( 2, 'SWD' ,/*bCampos*/ )

oView := FWFormView():New()
oView:SetModel( oModel )

oView:AddField( 'VIEW_SWD',oStruSWD, 'SWDMASTER' )//(ID,ESTRUTURA,MODEL)


// Cria um "box" horizontal para receber cada elemento da view
oView:CreateHorizontalBox( 'SUPERIOR', 100 )//(ID,% DA TELA)

// Relaciona o identificador (ID) da View com o "box" para exibição
oView:SetOwnerView( 'VIEW_SWD', 'SUPERIOR' )

oView:SetDescription( "Contabilizacao das Despesas de Importação" )
oView:EnableControlBar( .T. )


Return oView

//MENU DEF
Static Function MenuDef()

Local aRotina := {}
ADD OPTION aRotina TITLE "Pesquisar"			ACTION "PesqBrw"                          	    OPERATION 1  ACCESS 0
ADD OPTION aRotina TITLE "Visualizar"			ACTION "VIEWDEF.CTB097M"						OPERATION 4  ACCESS 0
//ADD OPTION aRotina TITLE "Valorizar Est"		ACTION "U_CTB06A09()"		  				  	OPERATION 2  ACCESS 0
ADD OPTION aRotina TITLE "Contabilizar"			ACTION "U_CTB06A08()"		  				  	OPERATION 2  ACCESS 0
ADD OPTION aRotina TITLE "Legenda"				ACTION "U_LEG06A08()"     						OPERATION 10 ACCESS 0

Return aRotina

User Function LEG06A08

Local aCores := { 	{"BR_VERDE", "Despesa Sem Vinculo" },;		//"Movimento Bancario - Receber"
{"BR_VERMELHO", "Despesa NF Primeira" } }	//"Movimento Bancario - Estorno"

BrwLegenda("Contabilizacao de Despesas","Legenda",aCores)

Return(.T.)

// contabilizacao
User Function CTB06A08

Local nOpcGD:= GD_UPDATE

Local aSizeAut	:= MsAdvSize(.T.,.F.,) //pega o tamanho da tela
Local aInfo
Local aPosObj
Local aPosGet
Local aObjects	:= {}

Private oBrw1
Private aCoBrw := {}
Private aHeBrw := {}
Private noBrw1  :=0
Private aCposAlt := {}

private oDlgCtb

private oFont1     := TFont():New( "Times New Roman",0,-29,,.T.,0,,700,.F.,.F.,,,,,, )

aAdd(aObjects,{100,100,.T.,.T.})// Definicoes para a Enchoice

//pega posição dos objetos
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

oDlgCtb		:= MSDialog():New( aSizeAut[7],aSizeAut[2],aSizeAut[6],aSizeAut[5],"Contabilizacao das Despesas de Importação",,,.F.,,,,,,.T.,,,.T. )

MHeBrw() //Montagem do Header / Cabecalho

oBrw1      := MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3]-30,aPosObj[1,4],nOpcGd,,,,aCposAlt,0,99,,,,oDlgCtb,aHeBrw,aCoBrw, )

MCoBrw()  // montagem do aCols

If Len(oBrw1:aCols)==0
	Aviso("[CTB097M]","Não existem movimentos para contabilizar.",{"Ok"})
	oDlgCtb:End()
	return
Endif

oTButton1 := TButton():Create( oDlgCtb,aPosObj[1,3]-15,aPosObj[1,4]-260,"Confirmar",{|| Contabiliza()},60,10,,,,.T.,,,,,,)
oTButton2 := TButton():Create( oDlgCtb,aPosObj[1,3]-15,aPosObj[1,4]-200,"Sair",{|| oDlgCtb:End() },60,10,,,,.T.,,,,,,)

oDlgCtb:Activate(,,,.T.)

Return()

/*
Function  # Monta aHeader da MsNewGetDados para o Alias:
*/
Static Function MHeBrw()

SX3->(dbSetOrder(2))

noBrw1++
Aadd(aHeBrw,{"  "                    ,     "OK"              ,   "@BMP"                    ,     1,     0,"",,     "C","",""})

noBrw1++
sx3->(dbseek("WD_HAWB"))
Aadd(aHeBrw,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )

noBrw1++
sx3->(dbseek("WD_DESPESA"))
Aadd(aHeBrw,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )

noBrw1++
sx3->(dbseek("WD_VALOR_R"))
Aadd(aHeBrw,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )

noBrw1++
sx3->(dbseek("WD_DOCTO"))
Aadd(aHeBrw,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )

noBrw1++
sx3->(dbseek("WD_FORN"))
Aadd(aHeBrw,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )

noBrw1++
sx3->(dbseek("WD_LOJA"))
Aadd(aHeBrw,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"U_Deb06A08()",;
SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
aAdd(aCposAlt, SX3->X3_CAMPO)

noBrw1++
SX3->(dbseek("WD_CTRFIN1"))
Aadd(aHeBrw,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID, SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT})

noBrw1++
sx3->(dbseek("WD_PREFIXO"))
Aadd(aHeBrw,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )

noBrw1++
sx3->(dbseek("WD_PARCELA"))
Aadd(aHeBrw,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )

noBrw1++
sx3->(dbseek("WD_EMISSAO"))
Aadd(aHeBrw,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )



noBrw1++
Aadd(aHeBrw,{"RECNO",	"RECNO", "999999999",9,0,,,"N" } )

Return

/*
Function  # MCoBrw1() - Monta aCols da MsNewGetDados para o Alias:
*/
Static Function MCoBrw()

local cQuery := ""
local cArqTmp := GetNextAlias()
Local cLegenda

oBrw1:aCols:={}

cQuery := " select WD_HAWB,WD_DESPESA, WD_VALOR_R,WD_DOCTO, WD_FORN, WD_LOJA, WD_CTRFIN1, WD_PREFIXO, WD_PARCELA, WD_EMISSAO, "
cQuery += " WD_NF_COMP,WD_BASEADI,SWD.R_E_C_N_O_ RECNO "
cQuery += " from "+RetSqlTab("SWD")
cQuery += " where WD_FILIAL = '"+xFilial("SWD")+"' "
//cQuery += " AND E5_MOTBX = 'CMP' AND E5_TIPO = 'NF' "
cQuery += " AND WD_HAWB = '"+cIMP+"' "
cQuery += " AND WD_NF_COMP = ' ' "
cQuery += " AND WD_BASEADI <> '1'  "
//cQuery += " AND E5_SITUACA <> 'C' "
cQuery += " AND  SWD.D_E_L_E_T_ = ' '"
cQuery += " order by WD_HAWB,WD_DESPESA "
cQuery := ChangeQuery(cQuery)

If (Select(cArqTmp) <> 0)
	dbSelectArea(cArqTmp)
	dbCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cArqTmp,.T.,.T.)

Count to nCont

(cArqTmp)->(dbGoTop())

While (cArqTmp)->(!Eof() )
	// para legenda na MSNEWGETDADOS
	if (cArqTmp)->WD_NF_COMP = " " .AND. WD_BASEADI <> "1"
		cLegenda := LoaDbitmap( GetResources(), "BR_VERDE" )
		
	else
		cLegenda := LoaDbitmap( GetResources(), "BR_VERMELHO" )
	endif
	
	aAdd(oBrw1:aCols,{ clegenda,;
	(cArqTmp)->WD_HAWB,;
	(cArqTmp)->WD_DESPESA,;
	(cArqTmp)->WD_VALOR_R,;
	(cArqTmp)->WD_DOCTO,;
	(cArqTmp)->WD_FORN,;
	(cArqTmp)->WD_LOJA,;
	(cArqTmp)->WD_CTRFIN1,;
	(cArqTmp)->WD_PREFIXO,;
	(cArqTmp)->WD_PARCELA,;
	stod((cArqTmp)->WD_EMISSAO),;
	(cArqTmp)->RECNO,;
	.F. })
	(cArqTmp)->(DbSkip())
EndDo

(cArqTmp)->(dbCloseArea())

Return

// contabilizacao

Static Function Contabiliza

local aArea := SWD->(GetArea())

local nX:= 0
Local nCont			:= 0	// Contador de linhas

Private cLote		:= "008851"					// Lote na contabilidade
Private cPadrao		:= "IMP"					// Lançamento padrão criado
private lPadrao		:= VerPadrao(cPadrao)		// Validação da existência do Lançto padrão.
Private cProg		:= "CTB097M"				// Nome da rotina
Private cArquivo	:= ""						// Nome do arquivo contra prova
Private lDigita		:= .T.						// Mostra o lançamento na tela ou não.
Private lAglutina	:= .F.						// Aglutina o lançamento ou não.
Private nTotal		:= 0						// Para o total da contabilização.
Private cChave		:= ""						// Chave para inclusaO

//Cria Cabeçalho na contabilização
nHdlPrv := HeadProva(cLote,cProg,cUserName,@cArquivo)
nTotal 	:= 0
nCont 	:= 0

For nX:=1 to Len(oBrw1:aCols)
	
	// Controle para gerar lote de até 999 linhas.
	If nCont = 9999
		RodaProva(nHdlPrv,nTotal) // Finalização da contabilização
		lLancOk := cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglutina,,dDataBase)
		
		// Novo lote para contabilizar
		nHdlPrv  := HeadProva(cLote,cProg,cUserName,@cArquivo) //Cria Cabeçalho na contabilização
		nTotal := 0
		nCont := 0
		
	EndIF
	
	// Inicializa variaveis interna do sistema para o LP
	VALOR		:= oBrw1:aCols[nX][nPosVal]
	
	HISTORICO 	:= ""
	
	nTotal 	+= DetProva(nHdlPrv,cPadrao,cProg,cLote)
	nCont++
	
Next

If nTotal <> 0
	RodaProva(nHdlPrv,nTotal) // Finalização da contabilização
	lLancOk := cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglutina,,dDatabase)
EndIf

RestArea(aArea)

return()
