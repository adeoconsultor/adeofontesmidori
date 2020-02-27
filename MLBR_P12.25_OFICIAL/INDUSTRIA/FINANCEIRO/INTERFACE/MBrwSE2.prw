#INCLUDE 'PROTHEUS.CH'
#INCLUDE "rwmake.ch"
/*
--------------------------------------------------------------------------
Programa: RFINA02										Data: 30/05/2011
--------------------------------------------------------------------------
Objetivo: Re-Impressao de Autorização de Pagamento de Titulos - MANUAL
--------------------------------------------------------------------------
*/                                                     
User Function MBrwSE2()
Local cAlias := "SE2"
Local aIndices := {} , _cFiltro, bFilBrw
Private cCadastro := "Atualização de Titulos"
Private aRotina := {}    


AADD(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
AADD(aRotina,{"Visualizar" ,"AxVisual",0,2})
AADD(aRotina,{"Alterar" ,"u_bAltVenc",0,3})


_cFiltro := "E2_VALOR == E2_SALDO .AND. Empty(E2_BAIXA)"

bFilBrw	 :=	{|| FilBrowse('SE2',@aIndices,_cFiltro)}   //Filtra o MBrowse
Eval( bFilBrw )
	
mBrowse(6,1,22,75,cAlias)

Return Nil                              

/*------------------------------------------------------------------------
Programa: bAltVenc										Data: 30/05/2011
--------------------------------------------------------------------------
Objetivo: Realiza alteração de Vencto de titulos. SE2
------------------------------------------------------------------------*/   
User Function bAltVenc()
Local dVencto := SE2->E2_VENCTO
Local nOpc := 0 ,_oDlg, oEdit1

If MsgYesNo("Rotina tem como Objetivo realizar a alteração da Data de Vencto para titulos em abertos! Deseja continuar...","Confirma a operação")
	
	DEFINE MSDIALOG _oDlg TITLE "Vencimento" FROM C(273),C(346) TO C(350),C(484) PIXEL
	@ C(007),C(005) MsGet oEdit1 Var dVencto Size C(057),C(009) COLOR CLR_BLACK PIXEL OF _oDlg VALID (dVencto >= SE2->E2_EMISSAO)
	DEFINE SBUTTON FROM C(022),C(005) TYPE 1 ENABLE OF _oDlg ACTION(nOpc := 1, _oDlg:End())
	DEFINE SBUTTON FROM C(022),C(037) TYPE 2 ENABLE OF _oDlg ACTION(_oDlg:End())
	ACTIVATE MSDIALOG _oDlg CENTERED
	
	If nOpc == 1
		RecLock("SE2",.F.)
		SE2->E2_VENCTO := dVencto
		SE2->E2_VENCREA := DataValida(dVencto)
		SE2->(MsUnLock())
	EndIf
	
EndIf

Return ()                             

/*---------------------------------------------------------------
Programa: C										Data: 30/05/2011
-----------------------------------------------------------------
Objetivo: 
---------------------------------------------------------------*/   
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth

If nHRes == 640
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)
	nTam *= 1
Else
	nTam *= 1.28
EndIf

If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf                 

Return Int(nTam)