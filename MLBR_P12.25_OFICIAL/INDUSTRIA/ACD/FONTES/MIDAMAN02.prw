#INCLUDE "TOPCONN.ch"
#INCLUDE "TOTVS.Ch"

// Define dos modos das rotinas
#DEFINE INCLUIR		3
#DEFINE OK			1
#DEFINE CANCELA		2
#DEFINE ENTER		Chr(13)+Chr(10)

#command @ <row>, <col> VTGET <var> [PICTURE <pic>]               ;
[<password: PASSWORD>]                    ;
[VALID <valid>] [WHEN <when>] [F3 <sF3>]  ;
;
=> VTSetGet( @<var>, <"var">, <row>, <col>, {|| <valid> },  ;
{|| <pic> }, {|| <when> }, <.password.> ,<sF3>)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MIDAMAN02 ³ Autor ³ Antonio - ADVPL TEC  ³ Data ³ 17.09.15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para Desmontagem do Kit                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MIDAMAN02()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Midori                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ MOTIVO DA ALTERACAO                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Criada a tabela SZV, caso ja tenha no cliente, criaremos outras posteriores.

SZV

ZV_CODDES   - Cod da Desmontagem do Kit Fardo C 6     R/V  (não aparece nos itens)
ZV_ITEM     - Item                            C 04    R/A
ZV_CODKIT   - Produto Kit Fardo               C 15    R/A
ZV_DSCKIT   - Descrição Produto Kit Fardo     C 45    R/V
ZV_LOCALOR  - Armazem Origem                  C 02    R/V
ZV_LOTE     - Lote                            C 10    R/V
ZV_ENDORI   - Endereço Origem                 C 15    R/V
ZV_QTDE     - Qtde                            N 05 02 R/A
ZV_LOCALDE  - Armazem Destino                 C 02    R/V
ZV_ENDDES   - Endereço Destino                C 15    R/V
ZV_CC       - Centro de Custo                 C 09    R/V
ZV_DTVALID  - Data Validade Lote              D 08    R/V

Incluir validação U_xDURAPRD()  no campo (ZV_CODKIT)
/*/


User Function MIAMAN02()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis da EnchoiceBar()        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOpcA			:= 0										// Botão Ok ou Cancela
Local nCont			:= 0
Local aArea			:= GetArea()

Local cCadastro	:= "Desmontagem do KIT FARDO"

Local oDlg		:= Nil
Local lEnchBar	:= .F.            // Se a janela de diálogo possuirá enchoicebar (.T.)
Local lPadrao 	:= .F.            // Se a janela deve respeitar as medidas padrões do Protheus (.T.) ou usar o máximo disponível (.F.)
Local nMinY	   	:= 400            // Altura mínima da janela



Private oGet		:= Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis para a MsAdvSize e MsObjSize³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aSize		:= MsAdvSize(lEnchBar, lPadrao, nMinY)
Private aInfo	   	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3} // Coluna Inicial, Linha Inicial
Private aObjects   	:= {}
Private aPosObj	   	:= {}

aAdd(aObjects,{100,100,.T.,.F.})      // Definicoes para a Enchoice
aAdd(aObjects,{150,150,.T.,.F.})      // Definicoes para a Getdados
aAdd(aObjects,{100,025,.T.,.F.})

aPosObj := MsObjSize(aInfo,aObjects)  // Mantem proporcao - Calcula Horizontal

Private cCodDes := ""
Private cDescri := ""

//  MM+AA+HH+SS
cCodDES := SUBSTR(DTOC(dDataBase),4,2)+SUBSTR(DTOC(dDataBase),9,2)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),7,2)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definiçãod dos Objetos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDlg   := MSDIALOG():New(aSize[7],aSize[2],aSize[6],aSize[5],cCadastro,,,,,,,,,.T.)

nOpcX  := GD_INSERT+GD_UPDATE+GD_DELETE

aLinha := {}
AAdd( aLinha,{	"0001",;
Space( TamSx3("B1_COD"    )[1] ),;
Space( TamSx3("B1_LOCPAD" )[1] ),;
Space( TamSx3("D3_LOTECTL")[1] ),;
Space( TamSx3("D3_LOCALIZ")[1] ),;
0,;
Space( TamSx3("CTT_CUSTO" )[1] ),;
" ",;
.f. } )

oGet:= MyGrid():New(000, 000, 1200, 1400,nOpcX,"u_man02lOk",,"+ZV_ITEM",,, 99999,,,,  oDlg )
oGet:AddColSX3("ZV_ITEM")
oGet:AddColSX3("ZV_CODKIT")
oGet:AddColSX3("ZV_LOCALOR")
oGet:AddColSX3("ZV_LOTE")
oGet:AddColSX3("ZV_ENDORI")
oGet:AddColumn({ "Quantidade", "ZV_QTDE",  "99999", 5                     , 0,""                     , "", "N", "", "V", "", "", "", "A", "", "", ""})
oGet:AddColumn({ "C.Custo"   , "ZV_CC"  ,  "@!"   , TamSx3("CTT_CUSTO")[1], 0,"ValidaCusto(M->ZV_CC)", "", "C", "CTT", "V", "", "", "", "A", "", "", ""})
oGet:AddColumn({ " "   , "VAZIO"  ,  "@!"   , 1, 0,"ValidaCusto(M->ZV_CC)", "", "C", "", "V", "", "", "", "V", "", "", ""})
oGet:Load()
oGet:SetAlignAllClient()
oGet:SetArray(aLinha)

oDlg:bInit 		:= EnchoiceBar(oDlg,{||Processa( {||MAN002Grava()}, "Desmontando fardo..." ),oDlg:End()},{|| oDlg:End()})
oDlg:lCentered	:= .T.
oDlg:Activate()

RestArea(aArea)
Return(nOpcA)

User Function man02lOk()
Local cProduto  := oGet:GetField( "ZV_CODKIT" )
Local cArmazem  := oGet:GetField( "ZV_LOCALOR")
Local nQtde     := oGet:GetField( "ZV_QTDE"   )
Local cLoteCtl  := oGet:GetField( "ZV_LOTE"   )
Local cEndereco := oGet:GetField( "ZV_ENDORI" )
Local cCusto    := oGet:GetField( "ZV_CC"     )
Local lRet      := .t.

If Empty(cProduto) .or. Empty(cArmazem) .or. Empty(nQtde) .or. Empty(cCusto)
	lRet := .f.
	apMsgAlert( "Preencha os campos de produto, armazem, quantidade e centro de custos" )
EndIf

Return( lRet )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAN002Grava ºAutor  ³ANTONIO º Data ³  19/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para efetuar a gravação nas tabelas                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIN                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MAN002Grava()
Local nX			:= 0
Local nI 			:= 0
Local aArea			:= GetArea()
Local aAreaSZV		:= SZV->(GetArea())
Local lNoErro       := .t.
Local aErro         := {}

ProcRegua( Len( oGet:aCols ) )

//Executa o execauto do MATA242()

For nI:= 1 to Len(oGet:oGrid:aCols)
	
	IncProc()
	
	If oGet:IsDeleted( nI ) 		//VALIDA SE LINHA FOI DELETADA
		Loop
	EndIf
	
	cProduto  := oGet:GetField( "ZV_CODKIT" , nI )
	cArmazem  := oGet:GetField( "ZV_LOCALOR", nI )
	nQtde     := oGet:GetField( "ZV_QTDE"   , nI )
	cLoteCtl  := oGet:GetField( "ZV_LOTE"   , nI )
	cEndereco := oGet:GetField( "ZV_ENDORI" , nI )
	cCusto    := oGet:GetField( "ZV_CC"     , nI )
	
	If Empty(cProduto) .or. Empty(cArmazem) .or. Empty(nQtde) .or. Empty(cCusto)
		Loop
	EndIf
	
	lNoErro   := Desmonta( cProduto, cArmazem, nQtde, cLoteCtl, cEndereco, cCusto )
	AAdd( aErro, {lNoErro, cProduto} )
	
Next nX

cStr := ""
For nX := 1 to Len( aErro )
	If aErro[nX][1]
		Loop
	EndIf
	cStr += aErro[nX][2] + iif( nX < Len(aErro), ", ", "" )
Next nX

If ! Empty( cStr )
	cStr := "Produtos: " + CRLF + cStr
	apMsgInfo(cStr, "Desmontagem ocorreu com erros")
Else
	apMsgInfo("Desmontagem ocorreu com sucesso!", "Desmontagem")
EndIf

dbSetOrder(1)

RestArea(aAreaSZV)
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAN002TOK ºAutor  ³ANTONIO º Data ³  20/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação TudoOK da rotina                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MAN002TOK(nOpc)
Local lRet 			:= .T.
Local nX	  		:= 0
Local aCols 		:= oGet:oGrid:aCols
Local nItens		:= 0
Local nPos			:= 0
Local nTRateio      := 0

lRet := NaoVazio(cCodDes) //.And. U_EnchMan(cCodDes,nOpc)

If lRet
	For nX:= 1 to Len(aCols)
		If oGet:IsDeleted( nX )
			IF !Empty( oGet:GetField("ZV_CODKIT",nX) )
				nItens++
			EndIf
		EndIf
		
	Next nX
EndIf

If lRet .And. nItens == 0
	Help(" ",1,"FR0NOLIN" , , "Por favor, crie pelo menos um item" ,3,0 )
	lRet := .F.
EndIf

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ DURAPRD  ³ Autor ³ Antonio                 ³ Data ³26/11/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Buscar nome do Produto/Unidade na getdados do cCodDes        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ oObjeto := Objeto da NewGetDados                             ³±±
±±³           ³ nLinha  := Linha da GetDados, caso o parametro nao seja      ³±±
±±³           ³            preenchido o Default sera o nAt da NewGetDados    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function xDURAPRD()

Local lRet  := .T.
Local cProduto, nPosProd

SB1->(dbSetOrder(1)) // B1_FILIAL + B1_COD
If SB1->(dbSeek(xFilial("SB1") + M->ZV_CODKIT ))
	If !oGet:IsDeleted()
		oGet:SetField("ZV_DSCKIT",SB1->B1_DESC)
	EndIf
Else
	apMsgAlert("Produto não existe.")
	lRet := .f.
EndIf

Return(lRet)

//============================================================================================
// u_DesmVT  - Alessandro Freire - Fev/2016
//--------------------------------------------------------------------------------------------
// Descrição
// Executa a desmontagem do kit fardo via terminal
//--------------------------------------------------------------------------------------------
// Parametros
//
//--------------------------------------------------------------------------------------------
// Retorno
//
//============================================================================================
User Function DesmVt()

Local cEtiq     := Space( TamSx3("CB0_CODETI")[1])
Local aArea     := GetArea()
Local cProduto
Local cArmazem
Local nQtde
Local cLoteCtl
Local cEndereco
Local cCusto    := Space( TamSx3("CTT_CUSTO")[1])

//---------------------------------
// Limpa a tela
//---------------------------------
VtClear()

//---------------------------------
// Solicita as informações da
// etiqueta e centro de custos
//---------------------------------
VTSay( 0, 0, "---[DESMONTAGEM]---", NIL )

VTSay( 1, 0, "Etiqueta", nil )
@ 2,00 VTGET cEtiq  VALID Empty(cEtiq) .or. VldEtiq( cEtiq )

VTSay( 4, 0, "Centro de Custo:", nil )
@ 5,00 VTGET cCusto VALID Empty(cCusto) .or. ValidaCusto( cCusto )
VtRead()

//---------------------------------
// Sai da rotina
//---------------------------------
If Empty( cEtiq ) .or. VtLastKey() == 27
	VtAlert("Desmontagem cancelada")
	Return(nil)
EndIf

If ! VTYesNo("Confirma a desmontagem?",,.t.)
	VtAlert("Desmontagem cancelada")
	Return(nil)
EndIf

VTSay( 7, 0, "Aguarde...", nil )
//---------------------------------
// Posiciona na Etiqueta
//---------------------------------
dbSelectArea("CB0")
dbSetOrder(1)
dbSeek( xFilial("CB0") + cEtiq )

cProduto  := CB0->CB0_CODPRO
cArmazem  := CB0->CB0_LOCAL
nQtde     := CB0->CB0_QTDE
cLoteCtl  := CB0->CB0_LOTE
cEndereco := CB0->CB0_LOCALI

lErro := Desmonta( cProduto, cArmazem, nQtde, cLoteCtl, cEndereco, cCusto )

VTClear()

If lErro
	VTAlert( "ocorreram erros na desmontagem" )
Else
	VTAlert( "Desmontagem OK!" )
EndIf

RestArea( aArea )
Return( nil )

Static Function VldEtiq( cEtiq )

//---------------------------------
// Posiciona na Etiqueta
//---------------------------------
dbSelectArea("CB0")
dbSetOrder(1)
If ! dbSeek( xFilial("CB0") + cEtiq )
	VTAlert("Etiqueta não encontrada")
	Return(.f.)
EndIf

If CB0->CB0_TIPO <> "01"
	VTAlert("Etiqueta não é de produto.")
	Return(.f.)
EndIf

dbSelectArea("SZT")
dbSetOrder(1)
If ! dbSeek(xFilial("SZT")+Trim(CB0->CB0_CODPRO))
	VTAlert("Produto não é Kit Fardo")
	Return(.f.)
EndIf

Return(.t.)

//============================================================================================
// Desmonta - Alessandro Freire - Fev/2016
//--------------------------------------------------------------------------------------------
// Descrição
// Executa a desmontagem do kit fardo. Todas as validações devem ser feitas previamente.
//--------------------------------------------------------------------------------------------
// Parametros
//
//--------------------------------------------------------------------------------------------
// Retorno
//
//============================================================================================
Static Function Desmonta( cProduto, cArmazem, nQtde, cLoteCtl, cEndereco, cCusto )

Local aAutoCab   := {}
Local aAutoItens := {}
Local aItens     := {}

Local cD3LOTECTL := Space( TamSx3("D3_LOTECTL")[1] )
Local dD3DTVALID := CtoD("")
Local cD3LOCALIZ := Space( TamSx3("BF_LOCALIZ")[1] )

Local cLoteItem  := cD3LOTECTL
Local dVldItem   := dD3DTVALID
Local cEndItem   := cD3LOCALIZ

Local cCodDes    := SUBSTR(DTOC(dDataBase),4,2) + SUBSTR(DTOC(dDataBase),9,2) + SUBSTR(TIME(),1,2) + SUBSTR(TIME(),7,2)
Local lNoErro    := .t.

Private lMsErroAuto := .F.

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+cProduto))

//----------------------------------------------
// Verifica se endereça o item
//----------------------------------------------
If SB1->B1_LOCALIZ == "S"
	cD3LOCALIZ := cEndereco
EndIf

// -------------------------------------------------------
// Define o lote do produto como sendo o mesmo do KIT
// -------------------------------------------------------
IF SB1->B1_RASTRO == "L"
	
	cD3LOTECTL := cLoteCtl
	//--------------------------------------------------------------------
	// precisa posicionar no produto lote para pegar a data de validade
	//--------------------------------------------------------------------
	dbSelectArea("SB8")
	dbSetOrder(3) // B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
	If dbSeek(xFilial("SB8") + cProduto + cArmazem + cLoteCtl )
		dD3DTVALID := SB8->B8_DTVALID
	Else
		dD3DTVALID := CtoD(Space(08))
	EndIf
	
EndIf

//--------------------------------------------------------
// Insere os produto que será desmontado
//--------------------------------------------------------
aAutoCab := {}
aAdd( aAutoCab, {"cProduto"   , cProduto             , Nil} )
aAdd( aAutoCab, {"cLocOrig"   , cArmazem             , Nil} )
aAdd( aAutoCab, {"nQtdOrig"   , nQtde                , Nil} )
aAdd( aAutoCab, {"nQtdOrigSe" , CriaVar("D3_QTSEGUM"), Nil} )
aAdd( aAutoCab, {"cDocumento" , cCodDes              , Nil} )
aAdd( aAutoCab, {"cNumLote"   , CriaVar("D3_NUMLOTE"), Nil} )
aAdd( aAutoCab, {"cLoteDigi"  , cD3LOTECTL           , Nil} )
aAdd( aAutoCab, {"dDtValid"   , dD3DTVALID           , Nil} )
aAdd( aAutoCab, {"nPotencia"  , CriaVar("D3_POTENCI"), Nil} )
aAdd( aAutoCab, {"cLocaliza"  , cD3LOCALIZ           , Nil} )
aAdd( aAutoCab, {"cNumSerie"  , CriaVar("D3_NUMSERI"), Nil} )

//--------------------------------------------------------
// Insere os itens que serão gerados a partir da
// desmontagem do produto acima
//--------------------------------------------------------
SZU->(dbSeek(xFilial("SZU")+cProduto))
aItens     := {}
aAutoItens := {}
While ! SZU->(Eof()) .And. (xFilial("SZU") + cProduto) == SZU->( ZU_FILIAL + ZU_CODKIT )
	
	SB1->(dbSetOrder(1))
	SB1->( dbSeek( xFilial("SB1")+Trim(SZU->ZU_PRODUTO) ) )
	
	cLoteItem := Space( TamSx3("D3_LOTECTL")[1] )
	dVldItem  := CtoD("")
	cEndItem  := Space( TamSx3("BF_LOCALIZ")[1] )
	
	//----------------------------------------------
	// Verifica se endereça o item
	//----------------------------------------------
	If SB1->B1_LOCALIZ == "S"
		If ! Empty( cD3LOCALIZ )
			cEndItem := cD3LOCALIZ
		EndIf
	EndIf
	
	//----------------------------------------------
	// Verifica se trata o lote do item
	//----------------------------------------------
	IF SB1->B1_RASTRO == "L"
		
		If Empty( cD3LOTECTL )
			//----------------------------------------------------------------------
			// Se o produto KIT não controlar lote e o produto gerado controla,
			// Será gerado um número de lote para o produto.
			//----------------------------------------------------------------------
			cLoteItem := "P"+SM0->M0_CODFIL+SubStr( DtoS(dDataBase),3,4 )+"KF"
		Else
			// -------------------------------------------------------
			// Se o produto KIT controla lote, o seu numero de lote
			// será exportado para o produto gerado no desmonte
			// -------------------------------------------------------
			cLoteItem := cD3LOTECTL
		EndIf
		
		//----------------------------------------------------------
		// precisa posicionar no lote para pegar a data de validade
		//----------------------------------------------------------
		dbSelectArea("SB8")
		dbSetOrder(3)      // B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
		
		If dbSeek(xFilial("SB8") + cProduto + cArmazem + cLoteItem )
			dVldItem := SB8->B8_DTVALID
		Else
			//----------------------------------------------------------
			// Se o lote não existir, a data de validade será criada
			// para aproximadamente de 10 anos
			//----------------------------------------------------------
			dVldItem := dDataBase + 3650
		EndIf
	EndIf
	
	aItens := {}
	//"D3_COD.D3_LOCAL.D3_QUANT.D3_RATEIO.D3_QTSEGUM.D3_LOCALIZ.D3_NUMLOTE.D3_LOTECTL.D3_DTVALID.D3_NUMSERI.D3_POTENCI.D3_CONTA.D3_ITEMCTA.D3_CLVL.D3_CC"
	
	If IsTelNet()
		dbSelectArea("SX3")
		dbSetOrder(1)
		dbSeek("SD3")
		While ! Eof() .and. SX3->X3_ARQUIVO == "SD3"
			
			If ! X3Uso(SX3->X3_USADO) .AND. Trim(SX3->X3_CAMPO) <> "D3_RATEIO"
				dbSkip()
				Loop
			EndIf                  
			
			AAdd( aItens, {Trim(SX3->X3_CAMPO),CriaVar(SX3->X3_CAMPO,.F.),".T." } )
			
			dbSkip()
			
		Enddo
		
		nD3COD   := aScan( aItens, {|x| x[1] == "D3_COD"   } )
		nD3LOCAL := aScan( aItens, {|x| x[1] == "D3_LOCAL" } )
		nD3QUANT := aScan( aItens, {|x| x[1] == "D3_QUANT" } )
		nD3CC    := aScan( aItens, {|x| x[1] == "D3_CC"    } ) 
		nD3RATEIO:= aScan( aItens, {|x| x[1] == "D3_RATEIO"} )
		
		aItens[nD3COD,2]    := SZU->ZU_PRODUTO
		aItens[nD3LOCAL,2]  := cArmazem
		aItens[nD3QUANT,2]  := nQtde * SZU->ZU_QTDE
		aItens[nD3CC,2]     := cCusto
		aItens[nD3RATEIO,2] := SZU->ZU_PRATEIO
		
	EndIf
	
	If ! IstelNet()
		AAdd( aItens, {"D3_COD"    , SZU->ZU_PRODUTO      , Nil })
		AAdd( aItens, {"D3_LOCAL"  , cArmazem             , Nil })
		AAdd( aItens, {"D3_QUANT"  , nQtde * SZU->ZU_QTDE , Nil })
		AAdd( aItens, {"D3_QTSEGUM", 0, Nil })
		AAdd( aItens, {"D3_CC"     , cCusto               , Nil })
		
		If SB1->B1_RASTRO == "L" 
			AAdd( aItens, {"D3_LOTECTL", cLoteItem        , ".T." })
			AAdd( aItens, {"D3_DTVALID", dVldItem         , ".T." })
		EndIf
		
		If SB1->B1_LOCALIZ == "S"  
			AAdd( aItens, {"D3_LOCALIZ", cEndItem         , ".T." })
		EndIf
		
		AAdd( aItens, {"D3_RATEIO" , SZU->ZU_PRATEIO      , Nil })
	Endif
	
	AAdd( aAutoItens, aItens )
	SZU->(dbSkip())
	
EndDo

Private lMsHelpAuto := .t.
Private lMsErroAuto := .f.

MSExecAuto({|v,x,y| Mata242(v,x,y)},aAutoCab,aAutoItens,3)

lNoErro := .t.
If lMsErroAuto
	lNoErro := .f.
	MostraErro()
	DisarmTransaction()
EndIf

Return( lNoErro )


/*
// Exemplo do Alessandro, não estou usando a função, esta dentro da função de gravação.
User Function Auto242()

Private lMsErroAuto := .F.

Local aAutoCab := { {"cProduto"   , Pad("PA", Len(SD3->D3_COD))   , Nil}, ;
{"cLocOrig"   , "01"                          , Nil}, ;
{"nQtdOrig"   , 100                           , Nil}, ;
{"nQtdOrigSe" , CriaVar("D3_QTSEGUM")         , Nil}, ;
{"cDocumento" , Pad("0123", Len(SD3->D3_DOC)) , Nil}, ;
{"cNumLote"   , CriaVar("D3_NUMLOTE")         , Nil}, ;
{"cLoteDigi"  , CriaVar("D3_LOTECTL")         , Nil}, ;
{"dDtValid"   , CriaVar("D3_DTVALID")         , Nil}, ;
{"nPotencia"  , CriaVar("D3_POTENCI")         , Nil}, ;
{"cLocaliza"  , CriaVar("D3_LOCALIZ")         , Nil}, ;
{"cNumSerie"  , CriaVar("D3_NUMSERI")         , Nil}}

Local aAutoItens := { {"D3_COD"    , Pad("MP1", Len(SD3->D3_COD)) , Nil}, ;
{"D3_LOCAL"  , "01"                         , Nil}, ;
{"D3_QUANT"  , 1                            , Nil}, ;
{"D3_QTSEGUM", 1                            , Nil}, ;
{"D3_RATEIO" , 20                           , Nil}},;

{{"D3_COD"    , Pad("MP2", Len(SD3->D3_COD)) , Nil}, ;
{"D3_LOCAL"  , "01"                         , Nil}, ;
{"D3_QUANT"  , 24                           , Nil}, ;
{"D3_QTSEGUM", 2                            , Nil}, ;
{"D3_RATEIO" , 80                           , Nil}}}

MSExecAuto({|v,x,y,z| Mata242(v,x,y,z)},aAutoCab,aAutoItens,3,.T.)

If lMsErroAuto
MostraErro()
DisarmTransaction()
EndIf

Return
*/
