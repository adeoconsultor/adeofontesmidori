#INCLUDE "rwmake.ch"
#include "Average.ch"
#INCLUDE "TopConn.ch"

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: NFDesclEic()
//|Autor.....: Luiz Fernando - luiz@dqzafra.com.br
//|Data......: 28 de Julho de 2010, 19:15:00
//|Uso.......: SIGAEIC
//|Versao....: Protheus - 10.1
//|Descricao.: Gera Estorno da Classificacao da NF de Importacao.
//|Observação:
//+-----------------------------------------------------------------------------------//

*----------------------------------------------*
User Function NFDesclEic()
*----------------------------------------------*

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cFilSF1     := xFilial("SF1")
Local nF1, nD1, nSD1
Private lMSErroAuto := .F.

Private _wnvlFrete
Private _wnvlSegur
Private _wnDoc
Private _wnSerie
Private _wnvlII
Private _wnvlBASPis
Private _wnvlBASCof
Private _wnvlPis
Private _wnvlCof
Private _wnvlICM
Private _wnvlFOB
Private _wnvlCIF
Private _wCTipoNf

If Empty(SF1->F1_HAWB)
	MsgInfo("NF não é de Importação !","Atenção")
	Return .F.
Endif

If SF1->F1_STATUS == "C"
	MsgInfo("NF de Importação com Classificação não permitida para o Cancelamento!","Atenção")
	Return .F.
Endif

If Empty(SF1->F1_STATUS)
	MsgInfo("NF não Classificada !","Atenção")
	Return .F.
Endif

_cOrig := ""
_cNfPrinc := SF1->F1_DOC+SF1->F1_SERIE

_aliasAchaSD1 := GetArea()

********************************************************************************************************************************
**** Verifica consistencia de nota complementar para a Primeira
**** O sistema TOTVS nao permite fazer cancelamento de classificacao da nota principal se a complementar estiver classificada
********************************************************************************************************************************
If SD1->(dbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
	If SD1->D1_TIPO == "N"
		SD1->(DbSetOrder(8))
		If SD1->(dbSeek(xFilial("SD1")+SF1->(F1_HAWB+"2")))
			While SD1->D1_CONHEC == SF1->F1_HAWB .AND. SD1->D1_TIPO_NF == "2"
				If SD1->D1_NFORI+SD1->D1_SERIORI == _cNfPrinc
					_cOrig := SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
					_cStatOrig := Posicione("SF1",1,_cOrig,"F1_STATUS")
					If !Empty(_cStatOrig)
						MsgInfo("Nota Fiscal Complementar "+ALLTRIM(SF1->F1_DOC)+" / "+AllTrim(SF1->F1_SERIE)+" deve ser Desclassificada antes da Principal !","Atenção")
						RestArea(_aliasAchaSD1)
						Return .F.
					Else
						SD1->(RecLock("SD1",.F.))
						SD1->D1_TIPO := "."
						SD1->(MsUnlock())
					Endif
				Endif
				SD1->(DbSkip())
			EndDo
		Endif
	Endif
Endif

RestArea(_aliasAchaSD1)
********************************************************************************************************************************

ProcRegua(3)
IncProc("Estornando Classificacao Nota Fiscal")

SD1->(dbSetOrder(1))
SF1->(dbSetOrder(5))

Begin Transaction

aItens  := {}
aItemSD1:= {}
aCabSF1 := {}

If MsgYesNo("Deseja Excluir a Classificação NF?","Exclusão Classificação EIC")
	
	_cNf := SF1->F1_DOC+SF1->F1_SERIE
	
	If SD1->(dbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
		
		While SD1->(!EOF()) .AND. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == (xFilial("SD1")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA))
			
			If SD1->D1_CONHEC # SF1->F1_HAWB
				SD1->(dbSkip())
				Loop
			EndIf
			
			aItem := {}
			aAdd(aItem,{"D1_DOC"    ,SD1->D1_DOC    ,NIL})
			aAdd(aItem,{"D1_SERIE"  ,SD1->D1_SERIE  ,NIL})
			aAdd(aItem,{"D1_FORNECE",SD1->D1_FORNECE,NIL})
			aAdd(aItem,{"D1_LOJA"   ,SD1->D1_LOJA   ,NIL})
			aAdd(aItens,ACLONE(aItem))
			
			aItemD1 := {}
			nUsado:=0
			dbSelectArea("SX3")
			dbSeek("SD1")
			aHeader:={}
			While !Eof().And.(x3_arquivo=="SD1")
				If X3USO(x3_usado).And.cNivel>=x3_nivel
					If Alltrim(SX3->X3_CAMPO) == "D1_OPER" .or. Alltrim(SX3->X3_CAMPO) == "D1_DESEST" .OR. Alltrim(SX3->X3_CAMPO) == "D1_ITEMMED"
						DbSkip()
						Loop
					Endif
					nUsado:=nUsado+1
					Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
					x3_tamanho, x3_decimal,"AllwaysTrue()",;
					x3_usado, x3_tipo, x3_arquivo, x3_context } )
				Endif
				dbSkip()
			End
			
			aAdd(aItemD1,{"D1_FILIAL"    , SD1->D1_FILIAL   ,NIL})
			aAdd(aItemD1,{"D1_ITEM"      , SD1->D1_ITEM     ,NIL})
			aAdd(aItemD1,{"D1_COD"	     , SD1->D1_COD      ,NIL})
			aAdd(aItemD1,{"D1_UM"        , SD1->D1_UM       ,NIL})
			aAdd(aItemD1,{"D1_QUANT"	 , SD1->D1_QUANT    ,NIL})
			aAdd(aItemD1,{"D1_VUNIT"     , SD1->D1_VUNIT    ,NIL})
			aAdd(aItemD1,{"D1_TOTAL"     , SD1->D1_TOTAL    ,NIL})
			aAdd(aItemD1,{"D1_VALIPI"    , SD1->D1_VALIPI   ,NIL})
			aAdd(aItemD1,{"D1_VALICM"    , SD1->D1_VALICM   ,NIL})
			aAdd(aItemD1,{"D1_CF"        , SD1->D1_CF       ,NIL})
			aAdd(aItemD1,{"D1_IPI"       , SD1->D1_IPI      ,NIL})
			aAdd(aItemD1,{"D1_PICM"      , SD1->D1_PICM     ,NIL})
			aAdd(aItemD1,{"D1_PESO"      , SD1->D1_PESO     ,NIL})
			aAdd(aItemD1,{"D1_PEDIDO"    , SD1->D1_PEDIDO   ,NIL})
			aAdd(aItemD1,{"D1_ITEMPC"    , SD1->D1_ITEMPC   ,NIL})
			aAdd(aItemD1,{"D1_FORNECE"   , SD1->D1_FORNECE  ,NIL})
			aAdd(aItemD1,{"D1_LOJA"      , SD1->D1_LOJA     ,NIL})
			aAdd(aItemD1,{"D1_LOCAL"     , SD1->D1_LOCAL 	,NIL})
			aAdd(aItemD1,{"D1_DOC"       , SD1->D1_DOC 		,NIL})
			aAdd(aItemD1,{"D1_EMISSAO"   , SD1->D1_EMISSAO 	,NIL})
			aAdd(aItemD1,{"D1_DTDIGIT"   , SD1->D1_DTDIGIT 	,NIL})
			aAdd(aItemD1,{"D1_GRUPO"     , SD1->D1_GRUPO 	,NIL})
			aAdd(aItemD1,{"D1_TIPO"      , SD1->D1_TIPO 	,NIL})
			aAdd(aItemD1,{"D1_SERIE"     , SD1->D1_SERIE 	,NIL})
			aAdd(aItemD1,{"D1_TP"        , SD1->D1_TP 		,NIL})
			aAdd(aItemD1,{"D1_QTSEGUM"   , SD1->D1_QTSEGUM 	,NIL})
			aAdd(aItemD1,{"D1_NFORI"     , SD1->D1_NFORI 	,NIL})
			aAdd(aItemD1,{"D1_SERIORI"   , SD1->D1_SERIORI 	,NIL})
			aAdd(aItemD1,{"D1_ITEMORI"   , SD1->D1_ITEMORI 	,NIL})
			aAdd(aItemD1,{"D1_DATORI"    , SD1->D1_DATORI 	,NIL})
			aAdd(aItemD1,{"D1_BASEICM"   , SD1->D1_BASEICM 	,NIL})
			aAdd(aItemD1,{"D1_LOTEFOR"   , SD1->D1_LOTEFOR 	,NIL})
			aAdd(aItemD1,{"D1_BASEIPI"   , SD1->D1_BASEIPI 	,NIL})
			aAdd(aItemD1,{"D1_LOTECTL"   , SD1->D1_LOTECTL 	,NIL})
			aAdd(aItemD1,{"D1_NUMLOTE"   , SD1->D1_NUMLOTE 	,NIL})
			aAdd(aItemD1,{"D1_DTVALID"   , SD1->D1_DTVALID 	,NIL})
			aAdd(aItemD1,{"D1_FORMUL"    , SD1->D1_FORMUL 	,NIL})
			aAdd(aItemD1,{"D1_II"        , SD1->D1_II 		,NIL})
			aAdd(aItemD1,{"D1_TEC"       , SD1->D1_TEC 		,NIL})
			aAdd(aItemD1,{"D1_CONHEC"    , SD1->D1_CONHEC 	,NIL})
			aAdd(aItemD1,{"D1_BASIMP5"   , SD1->D1_BASIMP5 	,NIL})
			aAdd(aItemD1,{"D1_BASIMP6"   , SD1->D1_BASIMP6 	,NIL})
			aAdd(aItemD1,{"D1_VALIMP5"   , SD1->D1_VALIMP5 	,NIL})
			aAdd(aItemD1,{"D1_VALIMP6"   , SD1->D1_VALIMP6 	,NIL})
			aAdd(aItemD1,{"D1_TIPO_NF"   , SD1->D1_TIPO_NF 	,NIL})
			aAdd(aItemD1,{"D1_ALQIMP5"   , SD1->D1_ALQIMP5 	,NIL})
			aAdd(aItemD1,{"D1_ALQIMP6"   , SD1->D1_ALQIMP6 	,NIL})
			aAdd(aItemD1,{"D1_LOCPAD"    , SD1->D1_LOCPAD 	,NIL})
			aAdd(aItemD1,{"D1_CC"        , SD1->D1_CC    	,NIL})
			aAdd(aItemD1,{"D1_CONTA"     , SD1->D1_CONTA 	,NIL})
			aAdd(aItemD1,{"D1_ITEMCTA"   , SD1->D1_ITEMCTA 	,NIL})
			
			aAdd(aItemSD1,aClone(aItemD1))
			
			SD1->(RecLock("SD1",.F.,.T.))
			SD1->(DBDELETE())
			SD1->(MsUnlock())
			
			SD1->(dbSkip())
			
		EndDo
		
	EndIf
	
	aCab := {}
	aAdd(aCab,{"F1_DOC"    ,SF1->F1_DOC    ,NIL})   // NUMERO DA NOTA
	aAdd(aCab,{"F1_SERIE"  ,SF1->F1_SERIE  ,NIL})   // SERIE DA NOTA
	aAdd(aCab,{"F1_FORNECE",SF1->F1_FORNECE,NIL})   // FORNECEDOR
	aAdd(aCab,{"F1_LOJA"   ,SF1->F1_LOJA   ,NIL})   // LOJA DO FORNECEDOR
	aAdd(aCab,{"F1_TIPO"   ,SF1->F1_TIPO   ,NIL})   // TIPO DA NF
	nRecno := SF1->(RecNo())
	
	aCabF1 := {}
	nUsado:=0
	dbSelectArea("SX3")
	dbSeek("SF1")
	aHeader:={}
	While !Eof().And.(x3_arquivo=="SF1")
		If X3USO(x3_usado).And.cNivel>=x3_nivel
			nUsado:=nUsado+1
			Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal,"AllwaysTrue()",;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
		Endif
		dbSkip()
	End
	
		aAdd(aCabF1,{"F1_FILIAL"  , SF1->F1_FILIAL   ,NIL})
		aAdd(aCabF1,{"F1_DOC"     , SF1->F1_DOC      ,NIL})
		aAdd(aCabF1,{"F1_SERIE"   , SF1->F1_SERIE    ,NIL})
		aAdd(aCabF1,{"F1_FORNECE" , SF1->F1_FORNECE  ,NIL})
		aAdd(aCabF1,{"F1_LOJA"    , SF1->F1_LOJA     ,NIL})
		aAdd(aCabF1,{"F1_COND"    , SF1->F1_COND     ,NIL})
		aAdd(aCabF1,{"F1_EMISSAO" , SF1->F1_EMISSAO  ,NIL})
		aAdd(aCabF1,{"F1_EST"     , SF1->F1_EST      ,NIL})
		aAdd(aCabF1,{"F1_FRETE"   , SF1->F1_FRETE    ,NIL})
		aAdd(aCabF1,{"F1_DESPESA" , SF1->F1_DESPESA  ,NIL})
		aAdd(aCabF1,{"F1_BASEICM" , SF1->F1_BASEICM  ,NIL})
		aAdd(aCabF1,{"F1_VALICM"  , SF1->F1_VALICM   ,NIL})
		aAdd(aCabF1,{"F1_BASEIPI" , SF1->F1_BASEIPI  ,NIL})
		aAdd(aCabF1,{"F1_VALIPI"  , SF1->F1_VALIPI   ,NIL})
		aAdd(aCabF1,{"F1_VALMERC" , SF1->F1_VALMERC  ,NIL})
		aAdd(aCabF1,{"F1_VALBRUT" , SF1->F1_VALBRUT  ,NIL})
		aAdd(aCabF1,{"F1_TIPO"    , SF1->F1_TIPO     ,NIL})
		aAdd(aCabF1,{"F1_DTDIGIT" , SF1->F1_DTDIGIT  ,NIL})
		aAdd(aCabF1,{"F1_FORMUL"  , SF1->F1_FORMUL   ,NIL})
		aAdd(aCabF1,{"F1_NFORIG"  , SF1->F1_NFORIG   ,NIL})
		aAdd(aCabF1,{"F1_SERORIG" , SF1->F1_SERORIG  ,NIL})
		aAdd(aCabF1,{"F1_ESPECIE" , SF1->F1_ESPECIE  ,NIL})
		aAdd(aCabF1,{"F1_IMPORT"  , SF1->F1_IMPORT   ,NIL})
		aAdd(aCabF1,{"F1_II"      , SF1->F1_II       ,NIL})
		aAdd(aCabF1,{"F1_HAWB"    , SF1->F1_HAWB     ,NIL})
		aAdd(aCabF1,{"F1_TIPO_NF" , SF1->F1_TIPO_NF  ,NIL})
		aAdd(aCabF1,{"F1_IPI"     , SF1->F1_IPI      ,NIL})
		aAdd(aCabF1,{"F1_ICMS"    , SF1->F1_ICMS     ,NIL})
		aAdd(aCabF1,{"F1_PESOL"   , SF1->F1_PESOL    ,NIL})
		aAdd(aCabF1,{"F1_FOB_R"   , SF1->F1_FOB_R    ,NIL})
		aAdd(aCabF1,{"F1_SEGURO"  , SF1->F1_SEGURO   ,NIL})
		aAdd(aCabF1,{"F1_CIF"     , SF1->F1_CIF      ,NIL})
		aAdd(aCabF1,{"F1_MOEDA"   , SF1->F1_MOEDA    ,NIL})
		aAdd(aCabF1,{"F1_RECBMTO" , SF1->F1_RECBMTO  ,NIL})
		aAdd(aCabF1,{"F1_CTR_NFC" , SF1->F1_CTR_NFC  ,NIL})
		aAdd(aCabF1,{"F1_TIPODOC" , SF1->F1_TIPODOC  ,NIL})
		
		aAdd(aCabSF1,ACLONE(aCabF1))
		
		SF1->(RecLock("SF1",.F.,.T.))
		SF1->(DBDELETE())
		SF1->(MsUnlock())
		
	MSExecAuto({|x,y,z| MATA103(x,y,z)},aCab,aItens,20)
	
	If lMSErroAuto
		MostraErro()
		Return
	EndIf
	
	Reclock("SF1",.T.)
	For nF1 := 1 to Len(aCabF1)
		Do Case
			Case Alltrim(aCabF1[nF1][1]) == "F1_FILIAL"
				SF1->F1_FILIAL := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_DOC"
				SF1->F1_DOC    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_SERIE"
				SF1->F1_SERIE  := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_FORNECE"
				SF1->F1_FORNECE:= aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_LOJA"
				SF1->F1_LOJA      := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_COND"
				SF1->F1_COND      := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_EMISSAO"
				SF1->F1_EMISSAO      := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_EST"
				SF1->F1_EST      := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_FRETE"
				SF1->F1_FRETE      := aCabF1[nF1][2] // Ver Alteracao
			Case Alltrim(aCabF1[nF1][1]) == "F1_DESPESA"
				SF1->F1_DESPESA      := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_BASEICM"
				SF1->F1_BASEICM      := 0 //aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_VALICM"
				SF1->F1_VALICM      := 0 //aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_BASEIPI"
				SF1->F1_BASEIPI      := 0.00 //aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_VALIPI"
				SF1->F1_VALIPI      := 0.00 //aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_VALMERC"
				SF1->F1_VALMERC      := 00.00 //aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_VALBRUT"
				SF1->F1_VALBRUT      := 0.00 //aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_TIPO"
				SF1->F1_TIPO    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_DTDIGIT"
				SF1->F1_DTDIGIT    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_FORMUL"
				SF1->F1_FORMUL    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_NFORIG"
				SF1->F1_NFORIG    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_SERORIG"
				SF1->F1_SERORIG    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_ESPECIE"
				SF1->F1_ESPECIE    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_IMPORT"
				SF1->F1_IMPORT    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_II"
				SF1->F1_II    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_HAWB"
				SF1->F1_HAWB    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_TIPO_NF"
				SF1->F1_TIPO_NF    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_IPI"
				SF1->F1_IPI    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_ICMS"
				SF1->F1_ICMS    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_PESOL"
				SF1->F1_PESOL    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_FOB_R"
				SF1->F1_FOB_R    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_SEGURO"
				SF1->F1_SEGURO    := aCabF1[nF1][2] // Trazer SwN
			Case Alltrim(aCabF1[nF1][1]) == "F1_CIF"
				SF1->F1_CIF    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_MOEDA"
				SF1->F1_MOEDA    := 0
			Case Alltrim(aCabF1[nF1][1]) == "F1_RECBMTO"
				SF1->F1_RECBMTO    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_CTR_NFC"
				SF1->F1_CTR_NFC    := aCabF1[nF1][2]
			Case Alltrim(aCabF1[nF1][1]) == "F1_TIPODOC"
				SF1->F1_TIPODOC    := "10"
		EndCase
		
	Next nF1
	MsUnlock()
	
	_wnDoc   := SF1->F1_DOC
	_wnSerie := SF1->F1_SERIE
	
	BuscaWn()
	
	RecLock("SF1",.F.)
	SF1->F1_FRETE   := _wnvlFrete
	SF1->F1_SEGURO  := _wnvlSegur
	SF1->F1_II      := _wnvlII
	//SF1->F1_BASIMP5 := _wnvlBASPis
	//SF1->F1_BASIMP6 := _wnvlBASCof
	//SF1->F1_VALIMP5 := _wnvlPis
	//SF1->F1_VALIMP6 := _wnvlCof
	SF1->F1_ICMS    := _wnvlICM
	SF1->F1_FOB_R   := _wnvlFOB
	SF1->F1_CIF     := _wnvlCIF
	
	SF1->F1_DTDIGIT := SF1->F1_EMISSAO
	If _wCTipoNf == "1"
		SF1->F1_TIPO    := "N"
	Else
		SF1->F1_TIPO    := "C"
	Endif
	SF1->F1_TIPO_NF := _wCTipoNf
	SF1->F1_FORMUL  := "S"
	SF1->F1_CTR_NFC := SF1->F1_DOC+SF1->F1_SERIE
	If _wCTipoNf == "1"
		SF1->F1_TIPODOC := "10"
	Else
		SF1->F1_TIPODOC := "13"
	Endif
	
	MsUnlock()
	
	For nSD1 := 1 to Len(aItemSD1)
		
		Reclock("SD1",.T.)
		
		For nD1 := 1 to Len(aItemD1)
			
			Do Case
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_FILIAL"
					SD1->D1_FILIAL := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_ITEM"
					SD1->D1_ITEM := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_COD"
					SD1->D1_COD := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_UM"
					SD1->D1_UM := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_QUANT"
					SD1->D1_QUANT := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_VUNIT"
					SD1->D1_VUNIT := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_TOTAL"
					SD1->D1_TOTAL := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_VALIPI"
					SD1->D1_VALIPI := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_VALICM"
					SD1->D1_VALICM := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_CF"
					SD1->D1_CF := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_IPI"
					SD1->D1_IPI := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_PICM"
					SD1->D1_PICM := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_PESO"
					SD1->D1_PESO := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_PEDIDO"
					SD1->D1_PEDIDO := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_ITEMPC"
					SD1->D1_ITEMPC := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_FORNECE"
					SD1->D1_FORNECE := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_LOJA"
					SD1->D1_LOJA := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_LOCAL"
					SD1->D1_LOCAL := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_DOC"
					SD1->D1_DOC := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_EMISSAO"
					SD1->D1_EMISSAO := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_DTDIGIT"
					SD1->D1_DTDIGIT := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_GRUPO"
					SD1->D1_GRUPO := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_TIPO"
					SD1->D1_TIPO := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_SERIE"
					SD1->D1_SERIE := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_TP"
					SD1->D1_TP := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_QTSEGUM"
					SD1->D1_QTSEGUM := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_NFORI"
					SD1->D1_NFORI := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_SERIORI"
					SD1->D1_SERIORI := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_ITEMORI"
					SD1->D1_ITEMORI := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_DATORI"
					SD1->D1_DATORI := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_BASEICM"
					SD1->D1_BASEICM := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_LOTEFOR"
					SD1->D1_LOTEFOR := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_BASEIPI"
					SD1->D1_BASEIPI := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_LOTECTL"
					SD1->D1_LOTECTL := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_NUMLOTE"
					SD1->D1_NUMLOTE := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_DTVALID"
					SD1->D1_DTVALID := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_FORMUL"
					SD1->D1_FORMUL := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_II"
					SD1->D1_II := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_TEC"
					SD1->D1_TEC := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_CONHEC"
					SD1->D1_CONHEC := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_BASIMP5"
					SD1->D1_BASIMP5 := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_BASIMP6"
					SD1->D1_BASIMP6 := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_VALIMP5"
					SD1->D1_VALIMP5 := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_VALIMP6"
					SD1->D1_VALIMP6 := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_TIPO_NF"
					SD1->D1_TIPO_NF := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_ALQIMP5"
					SD1->D1_ALQIMP5 := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_ALQIMP6"
					SD1->D1_ALQIMP6 := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_LOCPAD"
					SD1->D1_LOCPAD := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_CC"
					SD1->D1_CC := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_CONTA"
					SD1->D1_CONTA := aItemSD1[nSD1][nD1][2]
				Case Alltrim(aItemSD1[nSD1][nD1][1]) == "D1_ITEMCTA"
					SD1->D1_ITEMCTA := aItemSD1[nSD1][nD1][2]

			EndCase
			
		Next nD1
		
		MsUnlock()
		
	Next nSD1
	
	
	SF1->(dbGoTo(nRecno))
	
	//Limpa a Nota Fiscal de Transferencia
	If !lMSErroAuto
		_OldF1Area := GetArea()
		SWN->(dbsetorder(3))
		SWN->(dbseek(xFilial("SWN")+SF1->F1_HAWB))
		While !SWN->(eof()) .and. SWN->WN_FILIAL == xFilial("SWN") .and. SWN->WN_HAWB == SF1->F1_HAWB
			
			cWNPO := Substr(SWN->WN_PO_NUM,1,6)
			`               SC7->(DbSetOrder(1))
			IF SC7->(dbSeek(xFilial("SC7")+cWNPO+SWN->WN_ITEM))
				If SWN->WN_QUANT != SC7->C7_QTDACLA
					_nQuant := SWN->WN_QUANT
					
					SC7->(RecLock("SC7",.F.))
					SC7->C7_QTDACLA := _nQuant
					SC7->C7_QUJE    := SC7->C7_QUJE - _nQuant
					SC7->(MsUnlock())
					
					If SC7->C7_QUJE == 0
						SC7->(RecLock("SC7",.F.))
						SC7->C7_ENCER := " "
						SC7->(MsUnlock())
					Endif
					
					H = Posicione("SB2",1,xFilial("SB2")+SC7->C7_PRODUTO+SC7->C7_LOCAL,"B2_QATU")
					SB2->(Reclock("SB2"),.F.)
					SB2->B2_QATU := SB2->B2_QATU - _nQuant
					SB2->(MsUnlock())
				Endif
			EndIf
			SWN->(dbSkip())
		EndDo
		RestArea(_OldF1Area)
		
		_aliasAchaSD1 := GetArea()
		
		********************************************************************************************************************************
		**** Verifica consistencia de nota complementar para a Primeira
		**** Corrige consistencia da nota complementar
		********************************************************************************************************************************
		If SD1->(dbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
			If SD1->D1_TIPO == "N" .and. !Empty(SF1->F1_HAWB)
				SD1->(DbSetOrder(8))
				If SD1->(dbSeek(xFilial("SD1")+SF1->(F1_HAWB+"2")))
					While SD1->D1_CONHEC == SF1->F1_HAWB .AND. SD1->D1_TIPO_NF == "2"
						SD1->(RecLock("SD1",.F.))
						SD1->D1_TIPO := "C"
						SD1->(MsUnlock())
						SD1->(DbSkip())
					EndDo
				Endif
			Endif
		Endif
		
		RestArea(_aliasAchaSD1)
		********************************************************************************************************************************
		
		MsgInfo("Classificação NF estornada com sucesso!","Exclusão Classif")
		
	EndIf
	
EndIf

End Transaction

Return

***********************************
** Acha Inf Impost Import - Luiz
************************************
Static Function BuscaWn()

Store 0 to _wnvlFrete,_wnvlSegur, _wnvlII , _wnvlBASPis, _wnvlBASCof
Store 0 to _wnvlPis  , _wnvlCof , _wnvlICM, _wnvlFOB   , _wnvlCIF

oldarea := Alias()

DbSelectArea("SWN")
DbSetOrder(1)
Dbseek(xFilial("SWN")+_wnDoc+_wnSerie)

If !Eof()
	
	While SWN->WN_DOC == _wnDoc
		_wnvlFrete  := _wnvlFrete  + SWN->WN_FRETE
		_wnvlSegur  := _wnvlSegur  + SWN->WN_SEGURO
		_wnvlII		:= _wnvlII     + SWN->WN_IIVAL
		_wnvlBASPis := _wnvlBASPis + SWN->WN_BASPIS
		_wnvlBASCof := _wnvlBASCof + SWN->WN_BASCOF
		_wnvlPis    := _wnvlPis    + SWN->WN_VLRPIS
		_wnvlCof    := _wnvlCof    + SWN->WN_VLRCOF
		_wnvlICM    := _wnvlICM    + SWN->WN_VL_ICM
		_wnvlFOB    := _wnvlFOB    + SWN->WN_FOB_R
		_wnvlCIF    := _wnvlCIF    + SWN->WN_CIF
		_wCTipoNf   := SWN->WN_TIPO_NF
		DbSkip()
	Enddo
	
Endif

Return