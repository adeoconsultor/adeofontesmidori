#include 'protheus.ch'
#include 'rwmake.ch'
#INCLUDE "TOPCONN.CH"

/////////////////////////////////////////////////////////////////////////////////////////////
// Ponto de entrada chamado para validacao do ringi-sho
// Alterado ponto de entrada de MT097LOK para MT094LOK
//para atender nova rotina de liberacao de documento
// Diego Mafisolli 23/03/18
/////////////////////////////////////////////////////////////////////////////////////////////

user function MT094LOK()

local lRet := .T.

Local nRingSho := space(8)
Local cMsgText := ""
Local cBlqRSho := Getmv('MA_BLQRSHO')
Local zzrok    := .F.
Local cFil	   := cFilant

dbSelectArea("SC7")
dbSetOrder(1)
if dbSeek(xFilial("SC7")+AllTrim(SCR->CR_NUM))
	while !SC7->(eof()).and.SC7->C7_NUM == ALLTRIM(SCR->CR_NUM)
		dbSelectArea("SC1")
		dbSetOrder(1)
		if dbSeek(xFilial("SC1")+SC7->(C7_NUMSC+C7_ITEMSC))
			RecLock("SC7",.F.)
			SC7->C7_X_CODEV := SC1->C1_X_CODEV
			msUnLock("SC7")
		endif
		SC7->(dbSkip())
	enddo
endif

/////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para verificar total gasto com Ringisho na liberacao do pedido
//Bloqueia liberacao se atingir valor total do Ringisho
//Desenvolvido Diego Mafisolli - 22/10/2015 - solicitado por Fabio Moura - Suprimentos
/////////////////////////////////////////////////////////////////////////////////////////////
If cBlqRSho == "S"
	// Retorna Num.RingiSho atraves do pedido posicionado
	cQuery := "SELECT DISTINCT C1_RINGSHO, C1_NUMRSHO "
	cQuery += "FROM SC7010, SC1010 "
	cQuery += "WHERE C7_FILIAL = '"+cFil+"' "
	cQuery += "AND '"+cFil+"' = C1_FILIAL "
	cQuery += "and C7_NUMSC = C1_NUM "
	//cQuery += "and C7_NUM = '066012' "
	cQuery += "and C7_NUM = '"+Alltrim(SCR->CR_NUM)+"' "
	cQuery += "and SC7010.D_E_L_E_T_ = '' "
	cQuery += "and SC1010.D_E_L_E_T_ = ''"
	
	if Select("TMPSC1") > 0
		dbSelectArea("TMPSC1")
		TMPSC1->(dbCloseArea())
	endif
	
	cQuery:= ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TMPSC1",.T.,.T.)
	
	TMPSC1->(dbGoTop())
	
	If TMPSC1->C1_RINGSHO == 'S' .And. !TMPSC1->C1_NUMRSHO == Space(8)
		nRingSho := TMPSC1->C1_NUMRSHO
		
		cQuery := "SELECT DISTINCT "
		cQuery += "C1_NUMRSHO, ZZR_NUMRSH, ZZR_APRVJP, ZZR_DATAJP, ISNULL(ZZR_VALRSH,0) AS ZZR_VALRSH, (Sum(D1_TOTAL)-Sum(D1_VALDESC)) TOTALNF, "
		cQuery += "(ZZR_VALRSH - Sum(D1_TOTAL) - Sum(D1_VALDESC)) SALDO "
		cQuery += "FROM SC7010 "
		cQuery += "LEFT JOIN SD1010 ON"
		cQuery += "	C7_FILIAL = D1_FILIAL AND "
		cQuery += "	C7_NUM = D1_PEDIDO AND"
		cQuery += "	C7_PRODUTO = D1_COD AND "
		cQuery += "	C7_ITEM = D1_ITEMPC AND "
		cQuery += "	C7_FORNECE = D1_FORNECE AND "
		cQuery += "	C7_LOJA = D1_LOJA AND SD1010.D_E_L_E_T_ = ''"
		//	cQuery += "LEFT JOIN SF1010 ON"
		//	cQuery += "	D1_FILIAL = F1_FILIAL AND "
		//	cQuery += "	D1_DOC = F1_DOC AND"
		//	cQuery += "	D1_SERIE = F1_SERIE "
		cQuery += "INNER JOIN SC1010 ON "
		cQuery += "	C7_FILIAL = C1_FILIAL AND "
		cQuery += "	C7_NUM = C1_PEDIDO AND "
		cQuery += "	C7_PRODUTO = C1_PRODUTO AND "
		cQuery += "	C7_NUMSC = C1_NUM AND "
		cQuery += "	C7_ITEMSC = C1_ITEM AND "
		cQuery += "	SC1010.D_E_L_E_T_ = '' "
		cQuery += "LEFT JOIN ZZR010 ON "
		cQuery += "	ZZR_NUMRSH = C1_NUMRSHO "
		cQuery += "WHERE "
		cQuery += " C1_NUMRSHO = '"+nRingSho+"' "
		cQuery += "	AND SC7010.D_E_L_E_T_ = '' "
		cQuery += "GROUP BY "
		cQuery += "	C1_NUMRSHO,ZZR_NUMRSH,ZZR_APRVJP,ZZR_DATAJP,ZZR_VALRSH "
		
		if Select("TMPZZR") > 0
			dbSelectArea("TMPZZR")
			TMPZZR->(dbCloseArea())
		endif
		
		cQuery:= ChangeQuery(cQuery)
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TMPZZR",.T.,.T.)
		TMPZZR->(dbGoTop())
		
		If TMPZZR->ZZR_APRVJP == 'S' .And. TMPZZR->ZZR_DATAJP == space(8)
			zzrok := .F.
		else
			If TMPZZR->ZZR_VALRSH <> 0
				zzrok := .T.
			Endif
		Endif
		
		If zzrok == .F. .And. TMPZZR->ZZR_APRVJP == 'S' .And. TMPZZR->ZZR_DATAJP == space(8)
			cMsgText += "Ringi-sho " + Substr(TMPZZR->C1_NUMRSHO,1,4)+'/'+Substr(TMPZZR->C1_NUMRSHO,5,8) + " aguardando aprovação do Japão." + Chr(13) + Chr(10)
			cMsgText += "Em caso de duvida entrar em contato com Planejamento Estratégico."
			
			MSGINFO(cMsgText,"Pedido nao liberado")
			lRet := .F.
			
		Elseif zzrok == .F.
			cMsgText += "Pedido não liberado. Valor do Ringi-sho " + Substr(TMPZZR->C1_NUMRSHO,1,4)+'/'+Substr(TMPZZR->C1_NUMRSHO,5,8) + " nao cadastrado." + Chr(13) + Chr(10)
			cMsgText += "Em caso de duvida entrar em contato com setor de Compras/Suprimentos."
			
			MSGINFO(cMsgText,"Pedido nao liberado")
			lRet := .F.
		Else
			If TMPZZR->C1_NUMRSHO <> ' ' .And. (TMPZZR->TOTALNF + SCR->CR_TOTAL) > TMPZZR->ZZR_VALRSH
				
				cMsgText := "Pedido não liberado. RingiSho " + Substr(TMPZZR->C1_NUMRSHO,1,4)+'/'+Substr(TMPZZR->C1_NUMRSHO,5,8) + "atingiu o limite de valor." + Chr(13) + Chr(10)
				cMsgText += "Valor RingiSho: " + cValToChar(TMPZZR->ZZR_VALRSH) + Chr(13) + Chr(10)
				cMsgText += "Total entrada c/ NF : " + cValToChar(TMPZZR->TOTALNF) + Chr(13) + Chr(10)
				cMsgText += "Saldo RingiSho: " + cValToChar(TMPZZR->SALDO) + Chr(13) + Chr(10)
				cMsgText += "Total Pedido: " + cValToChar(SCR->CR_TOTAL) + Chr(13) + Chr(10)
				cMsgText += "Em caso de duvida entrar em contato com setor de Compras/Suprimentos."
				
				MSGINFO(cMsgText,"Pedido nao liberado.")
				lRet := .F.
			Endif
		Endif
		
		
	Endif // If parametro MA_BLQRSHO
EndIf


return lRet

////////////////////////////////////////////////////////////////////////////////////////////////
//Funçao complementar do ponto de entrada com objetivo de incluir o numero do projeto na nota
//fiscal de entrada
//desenvolvido por anesio G.Faria (anesio@anesio.com.br)
////////////////////////////////////////////////////////////////////////////////////////////////
user function AG_SHEVEN(cPed)
//Local nPosPed   := AScan(aHeader,{|x|AllTrim(x[2]) == "D1_PEDIDO"}) //Localizar o numero do pedido para buscar o codigo do evento
//Local nPosItP   := AScan(aHeader,{|x|AllTrim(x[2]) == "D1_ITEMPC"}) //Item do Pedido de compras



return
