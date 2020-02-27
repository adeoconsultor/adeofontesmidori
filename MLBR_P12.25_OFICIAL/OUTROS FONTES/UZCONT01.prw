#Include "rwmake.ch"

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: U_UZCONT01()
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Data......: 11 de Janeiro de 2010 - 08:00
//|Uso.......: SIGAEIC
//|Versao....: Protheus - 10
//|Descricao.: Valida Informa��es para contabiliza��o em Transito
//|Observa��o:
//+-----------------------------------------------------------------------------------//
*----------------------------------------------*
User Function UZCONT01(dDataEmb)
*----------------------------------------------*

Local dOldData  := dDataBase
Public _nTotFob := 0

//------------------------------------------------------------------------------------//
//|Como as datas de contabiliza��o s�o efetuadas no Desembara�o e se o usu�rio  
//|estiver do Embarque o programa ir� retornar sem processamento contabil       
//------------------------------------------------------------------------------------//
If Alltrim(FunName()) == "EICDI501"
	Return Nil
Endif

//+------------------------------------------------------------------------------------//
//|A contabiliza��o s� ser� possivel se o processo possuir Invoice
//+------------------------------------------------------------------------------------//
SW8->(dbSetOrder(1))
SW9->(dbSetOrder(3))

If !SW8->(dbSeek(xFilial("SW8")+SW6->W6_HAWB)) .OR.	!SW9->(dbSeek(xFilial("SW9")+SW6->W6_HAWB))
	Return Nil
Else
	_nTotFob := SW6->W6_FOB_TOT
EndIf

//+------------------------------------------------------------------------------------//
//|VerIfica pelo parametro padrao do DESEMBARA�O F12 se fara a contabiliza��o   
//|Precionando F12 na tela do Desembara�o poderam selecionar os parametros      
//+------------------------------------------------------------------------------------//
MV_PAR03 := Posicione("SX1",1,"EICFI4    "+"02","X1_PRESEL")  // Mostra   Lan�amento Contabil?
MV_PAR04 := Posicione("SX1",1,"EICFI4    "+"03","X1_PRESEL")  // Aglutina Lan�amento Contabil?

Do Case

	//+------------------------------------------------------------------------------------//
	//|Contabiliza��o de Importa��o em Transito     
	//+------------------------------------------------------------------------------------//	
	Case !Empty(M->W6_DT_EMB) .AND. Empty(dDataEmb)
		U_UZValInform("900")

	//+------------------------------------------------------------------------------------//
	//|Estorno da Contabiliza��o de Importa��o em Transito
	//+------------------------------------------------------------------------------------//		
	Case !Empty(M->W6_DT_EMB) .AND. !Empty(dDataEmb) .AND. M->W6_DT_EMB <> dDataEmb
		SvDtEmb      := M->W6_DT_EMB
		M->W6_DT_EMB := dDataEmb
		
		If Empty(SW6->W6_CHEG)
			U_UZValInform("905")
			U_UZValInform("900")
		EndIf
		M->W6_DT_EMB := SvDtEmb

	//+------------------------------------------------------------------------------------//
	//|Estorno da Contabiliza��o de Importa��o em Transito
	//+------------------------------------------------------------------------------------//		
	Case Empty(M->W6_DT_EMB) .AND. !Empty(dDataEmb)
		
		SvDtEmb      := M->W6_DT_EMB
		M->W6_DT_EMB := dDataEmb
		
		If Empty(SW6->W6_CHEG)
			U_UZValInform("905")
		EndIf
		
EndCase

Return
//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: ValInform()
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Data......: 11 de Janeiro de 2010 - 08:00
//|Uso.......: SIGAEIC
//|Versao....: Protheus - 10
//|Descricao.: Contabiliza��o em transito SIGAEIC
//|Observa��o:
//+-----------------------------------------------------------------------------------//
*----------------------------------------------*
User Function UZValInform(cxLanc)
*----------------------------------------------*

If VerPadrao(cxLanc)
	Processa({|| UZContab(cxLanc)},"Contabilizando")
Else
	MsgInfo("Lancamento padronizado "+Alltrim(cxLanc)+" nao existe. Favor verificar os Lan�amentos cadastrados","Lan�amento Padr�o")
EndIf

Return

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: UZContab
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Data......: 11 de Janeiro de 2010 - 08:00
//|Uso.......: SIGAEIC
//|Versao....: Protheus - 10
//|Descricao.: Inicia Processamento Principal
//|Observa��o:
//+-----------------------------------------------------------------------------------//
*----------------------------------------------*
Static Function UZContab(cxLanc)
*----------------------------------------------*

Local nTotReg	:= SE2->(RecCount())
Local cArquivo	:= ""
Local cLote		:= "008850" // MV_PAR05
Local nTotal	:= 0
Local nHdlPrv	:= 0
Local lMostra	:= (mv_par03==1)
Local lAglut	:= (mv_par04==1)
Local lHead		:= .T.
Local cCNPJ		:= ""
Local nTxMoed   := 0

Private aRotina := {}

ProcRegua(nTotReg)

Begin Transaction
	
	SA2->(dbSetOrder(1))
	SWB->(dbSetOrder(1))
	SE2->(dbSetOrder(1))
	SWB->(dbSeek(xFilial("SWB")+SW6->W6_HAWB))
	
	While SWB->(!EOF()) .AND. SWB->WB_FILIAL == xFilial("SWB") .AND. SWB->WB_HAWB == SW6->W6_HAWB
		
		If !SE2->(dbSeek(xFilial("SE2")+"EIC"+SWB->WB_NUMDUP+SWB->WB_PARCELA+"INV"+SWB->WB_FORN+SWB->WB_LOJA))
			SWB->(dbSkip())
			Loop
		EndIf
		
		SA2->(dbSeek(xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA)))
		
		//+------------------------------------------------------------------------------------//
		//|Para contabiliza��o em Reais
		//+------------------------------------------------------------------------------------//
		nTxMoed  := SWB->WB_CA_TX
		nTxMoed  := IIf(Empty(nTxMoed),Posicione("SW9",1,xFilial("SW9")+SWB->WB_INVOICE+SWB->WB_FORN,"W9_TX_FOB"),nTxMoed)
		_nTotFob := SWB->WB_FOBMOE*nTxMoed
		lHead    := .T.
		
		If lHead
			lHead   := .F.
			nHdlPrv :=HeadProva(cLote,"CONTGD01",Subs(cUsuario,7,6),@cArquivo)
			If nHdlPrv <= 0
				Help(" ",1,"A100NOPRV")
				Return Nil
			EndIf
		EndIf
		
		nTotal := DetProva(nHdlPrv,cxLanc,"CONTGD01",cLote)
		
		If nHdlPrv > 0
			RodaProva(nHdlPrv,nTotal)
			lLctoOk	:= cA100Incl(cArquivo,nHdlPrv,3,cLote,lMostra,lAglut)
		EndIf
		
		SWB->(dbskip())
	EndDo
	
End Transaction

Return

//+------------------------------------------------------------------------------------//
//|Fim do programa UZCONT01.PRW
//+	------------------------------------------------------------------------------------//