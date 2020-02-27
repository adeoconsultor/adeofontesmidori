#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.ch"
/*
---------------------------------------------------------------------------------------------------
Objetivo: Imprimir a Autorização de Pagamento após confirmar INCLUSAO/ALTERACAO MANUAL do titulo
--> Nova Versao da roina: Exibe tela para digitação de dados da AP - idem a NF Entrada
---------------------------------------------------------------------------------------------------
Objetivo: Monta array para Impressão da Autorizacao de Pagmento
aDadosTit:	1-Prefixo
2-Numero do Titulo
3-Parcela
4-Tipo
5-Fornecedor
6-Loja
7-Numero da AP
8-Banco Fav
9-Agencia Fav
10-Conta Fav
11-Nom Fav
12-Cpf Fav
13-Origem AP
14-Tipo de Conta     	| 1=Conta Corrente 2= Conta Poupanca
15-Forma de Pagamento   | 1=DOC/TED 2=Boleto/DDA 3=Cheque
16-Historico
---------------------------------------------------------------------------------------------------*/
User Function FA050GRV()

Local aDadosTit := {}
Local aDadosAP  := {}
Local cNumAp    := M->E2_X_NUMAP
Local cRet      := .T.

Local nOpca     := 0
Local cBco      := ""
Local cAge      := ""
Local cConta    := ""
Local oDlg
Local cFornece  := ""
Local _cFiltro  := "" 
LOCAL aTpCta 	:= {"1=Corrente","2=Poupanca",""}
LOCAL aFrmPag 	:= {"1=DOC/TED","2=Boleto/DDA","3=Cheque","4=Caixa","5=Cnab Folha","6=Cartão Corporativo"}

If FunName()$"EICDI500|EICDI501|EICDI502|FINA340"	//Chamado HD No. 1050 - Não exibe tela de AP para usuários do EIC
	Return(cRet)
EndIf
If  IsInCallStack( "FA340COMP" ) 
	Return(cRet)
EndIf
//
Private cCodApr  := CriaVar("ZW_USRAP") 
Private cNomApr  := CriaVar("ZW_USRAPN") 
//
Private cCodOri  := CriaVar("E2_X_ORIG") ,cVarOri
Private cTpCta   := CriaVar("E2_X_TPCTA"),cvar
Private cFrmPag  := CriaVar("E2_X_FPAGT"),cVarPag
Private cNomFav  := CriaVar("E2_X_NOMFV")
Private cInscr   := CriaVar("E2_X_CPFFV")
Private cCodHi   := space(3)
Private cHistor  := CriaVar("E2_HIST")

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//ROTINA DESENVOLVIDA POR ANESIO PARA SOLICITAR CODIGO DA RETENCAO CASO O USUARIO NAO INCLUA NA CLASSIFICACAO
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	cQuery := " Select E2_PREFIXO, E2_NUM, E2_TIPO, E2_PARCELA, E2_NATUREZ, E2_DIRF, E2_CODRET, E2_EMISSAO from SE2010 "
	cQuery += " where D_E_L_E_T_ = ' '  AND E2_FILIAL = '"+xFilial("SE2")+"' "
	cQuery += " AND E2_NUM = '"+SF1->F1_DOC+"' " 
	cQuery += " AND E2_EMISSAO = '"+dtos(SF1->F1_EMISSAO)+"' "
	cQuery += " AND E2_TIPO = 'TX' "
		
	if Select("TMPE2") > 0
		dbSelectArea('TMPE2')
		TMPE2->(dbCloseArea())
	endif
	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), 'TMPE2', .T., .T.)
	
	dbSelectArea("TMPE2")
	TMPE2->(dbGotop())
	nCount:= 0
	lCodRet := .T. 
	cPrefixo:= "" 
	cNum 	:= "" 
	cParc	:= ""
	cTipo 	:= "" 
	
	while !TMPE2->(eof())
		nCount++
			cPrefixo:= TMPE2->E2_PREFIXO
			cNum 	:= TMPE2->E2_NUM
			cParc	:= TMPE2->E2_PARCELA
			cTipo 	:= TMPE2->E2_TIPO
			if TMPE2->E2_NATUREZ $ 'IRF       ' .and. empty(TMPE2->E2_CODRET) 
				lCodRet := .F.
			endif
		TMPE2->(dbSkip())
	enddo

	if nCount > 0 .and. !lCodRet
		Private cGetCRet   := Space(4)
		Private cSayCodRet := Space(8)
		
		SetPrvt("oFont1","oDlg1","oSayCodRet","oGetCRet","oBtnConfirma")

//		OF oDlg PIXEL Picture "@!"  Valid !Empty(cCodOri) .And. ExistCpo("SX5", + "80" + cCodOri) F3 "80"		
		oFont1     := TFont():New( "MS Sans Serif",0,-20,,.T.,0,,700,.F.,.F.,,,,,, )
		oDlg1      := MSDialog():New( 194,298,304,575,"Informar Código de Retenção",,,.F.,,,,,,.T.,,,.T. )
		oSayCodRet := TSay():New( 008,012,{||"Codigo IRF"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,016)
		oGetCRet   := TGet():New( 024,012,{|u| If(PCount()>0,cGetCRet:=u,cGetCRet)},oDlg1,048,014,'@!',{||agVld(cGetCRet, cPrefixo, cNum, cParc, cTipo)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F., ("SX5", "37"),"cGetCRet",,)
		oBtnConfir := TButton():New( 024,080,"&Confirmar",oDlg1,{|| oDlg1:End(), agVld(cGetCRet, cPrefixo, cNum, cParc, cTipo)} ,048,016,,,,.T.,,"",,,,.F. )

		oDlg1:Activate(,,,.T.)
	endif
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FIM ROTINA
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
cFornece := Substr( SA2->A2_COD+" "+ SA2->A2_LOJA +" "+ SA2->A2_NOME,1,50)
cBco     := SA2->A2_BANCO
cAge     := SA2->A2_AGENCIA
cConta   := SA2->A2_NUMCON
cTpCta   := SA2->A2_X_TPCON		//If(Empty(SA2->A2_X_TPCON),"",SA2->A2_X_TPCON)
cFrmPag  := cVarPag := aFrmPag
                                            
/*
------------------------------------
Numero da AP
------------------------------------*/
//cNumAp := GETSXENUM('SE2','E2_X_NUMAP','E2_X_NUMAP') /*AOliveira 25-05-2011*/    //GetSxeNum("SE2","E2_X_NUMAP")
//ConfirmSx8()

cNumAp := u_XGETNAP() /*AOliveira 18-07-2019*/

	
/*---- Monta a Interface com o Usuário ---*/
While .T.
	DEFINE MSDIALOG oDlg FROM	15,6 TO 420,597 TITLE OemToAnsi("Autorização de Pagamento FINA050") PIXEL
	@  0,  1 TO  45, 294 LABEL OemToAnsi("Fornecedor") OF oDlg PIXEL
	@ 49,  1 TO  91, 294 LABEL OemToAnsi("Pagamento através de Crédito em Conta") OF oDlg PIXEL  //75
	@ 96,  1 TO 135, 294 LABEL OemToAnsi("Favorecido") OF oDlg PIXEL 
	@ 142,  1 TO 140, 294 LABEL OemToAnsi("Aprovador") OF oDlg PIXEL
	
	@ 11, 13 SAY	OemToAnsi("Nome")	SIZE	21,  7	 OF oDlg PIXEL
	@  9, 42 MSGET cFornece SIZE 149, 10	 OF oDlg PIXEL WHEN .F.
	
	@ 11,197 SAY	OemToAnsi("Numero AP")	SIZE	28,  7	 OF oDlg PIXEL
	@ 9, 230 MSGET cNumAp SIZE	54, 10	 OF oDlg PIXEL WHEN .F.
	
	@ 29, 13 SAY	OemToAnsi("Origem")	SIZE	26,  7	 OF oDlg PIXEL
	@ 26, 42 MSGET cCodOri        		SIZE 18, 10 OF oDlg PIXEL Picture "@!"  Valid !Empty(cCodOri) .And. ExistCpo("SX5", + "80" + cCodOri) F3 "80"
	
	/*--- Pagamento atraves de conta bancaria ---*/
	@ 60, 13 SAY	OemToAnsi("Forma de Pagamento: ")	SIZE 56, 7 OF oDlg PIXEL
	@ 57, 72 MSCOMBOBOX oCbx VAR cFrmPag ITEMS aFrmPag SIZE 46, 7 OF oDlg PIXEL //Valid !Empty(cTpCta)
	
	@ 60,220 SAY	OemToAnsi("Banco")	SIZE 26, 7 OF oDlg PIXEL
	@ 57,240 MSGET cBco SIZE 25,10 OF oDlg PIXEL //Valid !Empty(cBco)
	
	@ 75, 13 SAY	OemToAnsi("Agencia") SIZE 26, 7 OF oDlg PIXEL
	@ 72, 42 MSGET cAge SIZE 35,10 OF oDlg PIXEL //Valid !Empty(cAge)
	
	@ 75, 95 SAY	OemToAnsi("Numero Conta")	SIZE 40, 7 OF oDlg PIXEL
	@ 72,135 MSGET  cConta SIZE 50,10 OF oDlg PIXEL //Valid !Empty(cConta)
	
	@ 75,200 SAY	OemToAnsi("Tipo de Conta")	SIZE 40, 7 OF oDlg PIXEL
	@ 72,240 MSCOMBOBOX oCbx VAR cTpCta ITEMS aTpCta SIZE 46, 50 OF oDlg PIXEL
	/*	------------------
	FAVORECIDO
	------------------*/
	@ 105,13 SAY   OemToAnsi("Nome")	SIZE 26, 7 OF oDlg PIXEL
	@ 102,42 MSGET cNomFav SIZE 149, 10 OF oDlg PIXEL Picture "@!"
	
	@ 105,197 SAY	OemToAnsi("CNPJ/CPF") SIZE 26, 7 OF oDlg PIXEL
	@ 102, 230 MSGET cInscr SIZE 54,10 OF oDlg PIXEL Valid CGC(cInscr)
	

//	@ 120, 13 SAY	OemToAnsi("Histórico")	SIZE 26, 7 OF oDlg PIXEL
//	@ 117, 42 MSGET cHistor SIZE 149,10 OF oDlg PIXEL Picture "@!"

	@ 120, 13 SAY   OemToAnsi("Cod.Hist.") SIZE 26, 7 OF oDlg Pixel
	@ 117, 42 MSGET cCodHi SIZE 35, 10 OF oDlg Pixel Picture "@!"  Valid VLDHIST(cCodHi,'D') F3 "SZJ" 

	@ 120, 45 SAY	OemToAnsi("Histórico")	SIZE 26, 7 OF oDlg PIXEL
	@ 117, 80 MSGET oHist Var cHistor SIZE 210,10 OF oDlg PIXEL Picture "@!" Valid VLDCHIST(cCodHi)

//	DEFINE SBUTTON FROM 140, 260 TYPE 1	ACTION (nOpca=0,oDlg:End())	ENABLE OF oDlg
//	oCbx:Select(Val(cTpCta))     //Posiciona no item selecionado


	/*	------------------
	APROVADOR
	------------------*/
	@ 152,13 SAY   OemToAnsi("Aprovador")	SIZE 26, 7 OF oDlg PIXEL
	//@ 150,042 MSGET cCodApr SIZE 054, 10 OF oDlg PIXEL Picture "@!" VALID !Empty(cCodApr) .And. ExistCpo("SX5",  "Z4" + cCodApr) F3 "Z4"
	@ 150,042 MSGET cCodApr SIZE 054, 10 OF oDlg PIXEL Picture "@!" VALID VLDAPRV(cCodApr) F3 "Z4"
		
	DEFINE SBUTTON FROM 185, 260 TYPE 1	ACTION (if(VLDHIST(cCodHi,'F'), oDlg:End(), nOpca=0 ))	ENABLE OF oDlg
	oCbx:Select(Val(cTpCta))     //Posiciona no item selecionado   aneso
	oDlg:Refresh()
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	//Obrigar ao usuário informar o aprovador...
	if empty(cCodApr)
		ApMsgAlert('Favor preencher o código do Aprovador')
		Loop
	endif
	if !(VLDAPRV(cCodApr))
		Loop			
	endif	
	
	
	//Obrigar ao usuário informar o histórico padrao...
	if empty(cCodHi)
		ApMsgAlert('Favor preencher o código do histórico')
		Loop
	endif
	if cCodHi == '001' .and. cHistor == Posicione("SZJ", 1, xFilial("SZJ")+cCodHi, "ZJ_DESCRI")
		VLDCHIST(cCodHi)
		loop
	endif
	
	If cFrmPag == '1'
		If (cBco+cAge+cConta+cTpCta) != SA2->(A2_BANCO+A2_AGENCIA+A2_NUMCON+A2_X_TPCON)
			If !ApMsgYesNo("Dados da Conta Bancária diferente do cadastro do Fornecedor. Confirma ?","Não","Sim")
				cBco     := SA2->A2_BANCO
				cAge     := SA2->A2_AGENCIA
				cConta   := SA2->A2_NUMCON
				cTpCta   := SA2->A2_X_TPCON
				Loop
			EndIf
			If Empty(cBco) .Or. Empty(cAge) .Or. Empty(cConta) .Or. Empty(cTpCta)
				ApMsgAlert("Para esse tipo de pagamento informe os dados bancários","INFO")
				Loop
			EndIf
		Else
			If !Empty(cBco) .and. !Empty(cAge) .and. !Empty(cConta) .and. !Empty(cTpCta)
				If !ApMsgYesNo("Confirma os dados da Conta Bancária ?","Sim","Não")
					Loop
				EndIf
			Else
				ApMsgAlert("Dados bancários inválidos! Verifique")
				Loop
			EndIf
		EndIf
	Else
		cBco   := ""
		cAge   := ""
		cConta := ""
		cTpCta := ""
		
		If !ApMsgYesNo("Confirma a Forma de Pagamento ?")
			Loop
		EndIf
	EndIf
	
	SE2->E2_X_NUMAP := cNumAp
	SE2->E2_X_ORIG  := cCodOri
	SE2->E2_X_FPAGT := cFrmPag
	SE2->E2_X_FLAG  := "1"			//	IMPRESSO
	
	If cFrmPag == '1'           	// 	DOC/TED
		SE2->E2_X_BCOFV := cBco
		SE2->E2_X_AGEFV := cAge
		SE2->E2_X_CTAFV := cConta
		SE2->E2_X_TPCTA := cTPCta
	EndIf
	SE2->E2_X_NOMFV := cNomFav
	SE2->E2_X_CPFFV := cInscr
	SE2->E2_HIST    := cHistor
	SE2->E2_X_USUAR := Alltrim(USRFULLNAME(RETCODUSR()))
	SE2->E2_X_DEPTO := Tabela("80",cCodOri,.f.)
	SE2->E2_X_CODUS := RetCodUsr()
	
	Exit
EndDo

///////////////////////////////////////////////////////*
aAdd(aDadosAP,{ Tabela("80",cCodOri,.F.),SE2->E2_VALOR})
//aAdd(aDadosAP,{"(+) ACRESCIMO"  ,SE2->E2_ACRESC})
aAdd(aDadosAP,{"(-) DECRESCIMO",SE2->E2_DECRESC})

*//////////////////////////////////////////////////////

aAdd(aDadosAP,{ Tabela("80",cCodOri,.F.),SE2->E2_VALOR})
aAdd(aDadosAP,{"(-) DECRESCIMO",SE2->E2_DECRESC})

// INCLUIDO POR SANDRO - CHAMADO 001931 - LIDIA
IF SE2->E2_NATUREZ $ '3013'
	aAdd(aDadosAP,{"(-) IRPF-(ALUGUEL)",0})
Endif
// ATÉ AQUI.

aAdd(aDadosTit, {	SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,cNumAp,SE2->E2_X_BCOFV,;
SE2->E2_X_AGEFV,SE2->E2_X_CTAFV,SE2->E2_X_NOMFV,SE2->E2_X_CPFFV,SE2->E2_X_ORIG,SE2->E2_X_TPCTA,SE2->E2_X_FPAGT,SE2->E2_HIST, SE2->E2_HIST1})

//AOliveira
//
If SuperGetMV("EP_NEWAP",.F., .F.) // GetMv()
	//Novo processo ativo
	//u_GRVSZW(aDadosTit,cNumAp)   
	//u_GRVSZW(aDadosTit,cNumAp,RetCodUsr()) //17-10-2019 AOliveira Inclusão para gravar COD USR que incluiu a AP
	u_GRVSZW(aDadosTit,cNumAp,RetCodUsr(),cCodApr) //22-10-2019 AOliveira Inclusão para gravar COD APR da AP		
	    
	//Enviar e-mail de aviso.  
	//VSS_ENVMAIL(_cAP, _cForn, _cEmlAP)
	//_cEmail :=  "andre@sigasp.com;"+iif( Empty(UsrRetMail(cCodApr)), "" , UsrRetMail(cCodApr) )
	_cEmail :=  iif( Empty(UsrRetMail(cCodApr)), "" , UsrRetMail(cCodApr) )
	VSS_ENVMAIL(cNumAp, cFornece, _cEmail, SE2->E2_NUM)

	
Else
	//Processo Antigo
	U_RFINR01(aDadosTit,aDadosAP,"",_cFiltro)    //(aTit,aDesc,xRotina)
EndIf

Return(cRet)
////////////////////////////////////////////////////////////////////////////////////////
//FUNCAO PARA VERIFICAR SE O CODIGO DE RETENCAO UTILIZADO EXISTE NO ARQUIVO SX5
//DESENVOLVIDO POR ANESIO G.FARIA - MAIO/JUNHO-2013 - anesio@outlook.com
////////////////////////////////////////////////////////////////////////////////////////
static function agVld(cCodRet, cPrefixo, cNum, cParc, cTipo)
local lRetCd := .T.
cQX5 := " SELECT X5_TABELA from SX5010 where D_E_L_E_T_ = ' ' and X5_TABELA = '37' and X5_CHAVE = '"+cCodRet+"' "

if Select('TMPX5') > 0 
	dbSelectArea('TMPX5')
	TMPX5->(dbCloseArea())
endif

dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQX5), 'TMPX5', .T., .T.)

nCount := 0
dbSelectArea('TMPX5')
TMPX5->(dbGotop())
while !TMPX5->(eof())
	nCount++
	TMPX5->(dbSkip())
enddo
if nCount == 0
	Alert('Codigo de Retenção invalido, por favor corrija. ')
	oGetCRet:SetFocus()
	Return
	lRetCd := .F.
else
	dbSelectArea('SE2')
	dbSetOrder(1)
	if dbSeek(xFilial('SE2')+cPrefixo + cNum + cParc + cTipo + "UNIAO")
		RecLock("SE2",.F.)
		SE2->E2_DIRF = '1'
		SE2->E2_CODRET := cCodRet
		MsUnLock("SE2")
	endif
endif

return lRetCd

////////////////////////////////////////////////////////////////////////////////////////
//Funcao para validar o codigo do histório e alimentar o campo HISTORICO
////////////////////////////////////////////////////////////////////////////////////////
static function VLDHIST(cCodHi, cFrom)
local lRet := .T.
if cFrom == 'D' //Origem da digitação do campo
	cHistor := Posicione("SZJ", 1, xFilial("SZJ")+cCodHi, "ZJ_DESCRI")
	oHist:Refresh()
endif 
if Empty(cCodHi) 
	Alert('Favor preencher o histórico padrao')
	lRet := .F.
	Return lRet
endif
if !ExistCpo("SZJ", cCodHi) 
	Alert('O Código digitado não existe no cadastro')
	lRet := .F.
	Return lRet
endif
return lRet

////////////////////////////////////////////////////////////////////////////////////////
//Funcao para validar o campo HISTORICO
//Não permitir alimentar com "HISTORICO PADRAO" quando o codigo for 001
////////////////////////////////////////////////////////////////////////////////////////
static function VLDCHIST(cCodHi)
local lRet := .T.
if cCodHi == '001' .and. cHistor == Posicione("SZJ", 1, xFilial("SZJ")+cCodHi, "ZJ_DESCRI")
	Alert("Quando utilizado "+ ALLTRIM(Posicione("SZJ", 1, xFilial("SZJ")+cCodHi, "ZJ_DESCRI"))+chr(13)+"O Histórico deverá ser preenchido com valor diferente")
	lRet := .F.
	Return lRet
endif 
if Empty(cHistor)
	Alert("O campo histórico é obrigatório")
	lRet := .F.
	Return lRet
endif
return lRet


/*
* VSS_ENVMAIL
*
*@versao: 1.0
*@autor : AOliveira
*@Data  : 2018-02-06
*@Descr.: Inicia WF de envio de e-mail
*/
Static Function VSS_ENVMAIL(_cAP, _cForn, _cEmlAP, _cNumTit)

Local oHtml
Local oProcess

SETMV("MV_WFMLBOX","WORKFLOW")
cProcess := OemToAnsi("001001")
cStatus  := OemToAnsi("001001")
//_cProc  := OemToAnsi(cProc)

oProcess:= TWFProcess():New( '001001', _cAP )
oProcess:NewTask( cStatus, "\WORKFLOW\HTM\VldPro.htm" )
oHtml    := oProcess:oHTML
oHtml:ValByName("Data"	    ,DTOC(DDATABASE))
oHtml:ValByName("AP"   		,_cAP)

aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
aAdd( oHtml:ValByName( "it.desc" ), "AP: "+ Alltrim(_cAP) +" ")
aAdd( oHtml:ValByName( "it.desc" ), "Fornecedor: "+ Alltrim(_cForn) +" ")                     
aAdd( oHtml:ValByName( "it.desc" ), "Num.Titulo: "+ Alltrim(_cNumTit) +" ")
aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
aAdd( oHtml:ValByName( "it.desc" ), "| AGUARDANDO APROVAÇÃO                                                                 |")
aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")

oProcess:cSubject := "AP: "+_cAP+"   ( AGUARDANDO APROVAÇÃO ) "

oProcess:cTo      := _cEmlAP

oProcess:Start()
oProcess:Finish()
Return()


/*
* VLDAPRV
*
*@versao: 1.0
*@autor : AOliveira
*@Data  : 12-02-2020
*@Descr.: VALIDA APROVADOR
*/
Static Function VLDAPRV(_cVal)
Local lRet := .T.
Local _cMsg := ""
Local cA2CDUSR := ""

DEFAULT _cVAL := ""

if ( Empty(_cVAL) )
	_cMsg := "( Codigo do Aprovador, não está preenchido! )"
	lRet := .F.
else
	if !( ExistCpo("SX5", "Z4" + _cVAL) )
		_cMsg := "( Codigo do Aprovador informado, não é valido! )"
		lRet := .F.		
	else
		cA2CDUSR := Alltrim(Posicione("SA2",1, xFilial("SA2")+ SF1->F1_FORNECE+SF1->F1_LOJA,"A2_XCDUSR") )
		if ( Alltrim(cA2CDUSR) == Alltrim(_cVAL) )
			cMSG := "( Aprovador não pode ser o Fornecedor! )"	
			lRet := .f.
		endif	
	endif	
endif

if !(lRet)
	Aviso( "MNT AP","Selecione um aprovador, valido!"+CRLF+_cMSG ,{"Ok"},1)	
endif

Return(lRet)