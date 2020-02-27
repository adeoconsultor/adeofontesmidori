//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Programa..: UZSCHEDULE
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Data......: 24 de Janeiro de 2010, 16:00
//|Uso.......: SIGAEEC 
//|Versao....: Protheus 10    
//|Descricao.: Shipping Schedule
//|Observação:
//+-----------------------------------------------------------------------------------//

//+-----------------------------------------------------------------------------------//
//|Definições de Includes
//+-----------------------------------------------------------------------------------//
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//+-----------------------------------------------------------------------------------//
//|Definições de tela 
//+-----------------------------------------------------------------------------------//
#DEFINE TOP_TELA     oMainWnd:nTop+125   // Parte Superior
#DEFINE C_INI_TELA   oMainWnd:nLeft+5    // Coluna Inicial
#DEFINE BUT_TELA     oMainWnd:nBottom-Iif(SetMdiChild(),-30,60) // Parte Inferior
#DEFINE C_FIM_TELA   oMainWnd:nRight-10  // Coluna Final
#DEFINE MEIO_TELA    INT(((oMainWnd:nBottom-60)-(oMainWnd:nTop+125))/4)-10 // Meio da tela

//+-----------------------------------------------------------------------------------//
//|Definições de aRotina
//+-----------------------------------------------------------------------------------//
#DEFINE VISUAL    2
#DEFINE INCLUSAO  3
#DEFINE ALTERACAO 4
#DEFINE EXCLUSAO  5

//+-----------------------------------------------------------------------------------//
//|Funcao....: U_UZSCHEDULE()
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Descricao.: Função principal das Shipping Schedules cadastradas
//|Observação: 
//+-----------------------------------------------------------------------------------//
*------------------------------------------------* 
User Function UZSCHEDULE()
*------------------------------------------------* 

Local aPos  := {}
Local nLin1 := 00
Local nLin2 := 00
Local nCol1 := 00
Local nCol2 := 00
Local lBtnDESP := .T.
Local cPesq    := Space(6)

Private aINVSch  := {}
Private bLineSCH := Nil
Private oGrpSCH1 := Nil
Private oGrpSCH2 := Nil
Private oGrpSCH3 := Nil
Private oLbxSCH  := Nil
Private oDlgSCH  := Nil
Private oLBSCH:= Nil
Private nFocSCH  := 0
Private aVetSCH  := {}
Private aVetBKP  := {}

UZSChCarr(.F.)
If Len(aVetSCH) > 0
	SCHUpDate(1,,.F.)
EndIf

Define MsDialog oDlgSCH Title "Shipping Schedule" From 0,0 TO 300,600 OF oDlgSCH PIXEL STYLE DS_MODALFRAME

aPos := PosDlg(oDlgSCH)

nLin1 := 02
nLin2 := aPos[3]-2
nCol1 := 05
nCol2 := 65

oGrpSCH1 := TGroup():New( nLin1,nCol1,nLin2,nCol2,"Funções",oDlgSCH,CLR_BLACK,CLR_WHITE,.T.,.F. )

@ nLin1+=8 ,nCol1+=5 BUTTON "Incluir"      SIZE  50,10 PIXEL OF oDlgSCH ACTION SCHFunc(0,INCLUSAO)
@ nLin1+=12,nCol1    BUTTON "Alterar"      SIZE  50,10 PIXEL OF oDlgSCH ACTION SCHFunc(nFocSCH,ALTERACAO)
@ nLin1+=12,nCol1    BUTTON "Excluir"      SIZE  50,10 PIXEL OF oDlgSCH ACTION SCHFunc(nFocSCH,EXCLUSAO)
@ nLin1+=12,nCol1    BUTTON "Visualizar"   SIZE  50,10 PIXEL OF oDlgSCH ACTION SCHFunc(nFocSCH,VISUAL)
@ nLin1+=12,nCol1    BUTTON "Vis Invoice"  SIZE  50,10 PIXEL OF oDlgSCH ACTION SCHVisFat(aINVSch[oLbxSCH:nAt,1])
@ nLin1+=12,nCol1    BUTTON "Imprimir"     SIZE  50,10 PIXEL OF oDlgSCH ACTION U_IMPSHIPS(nFocSCH)
@ nLin1+=12,nCol1    BUTTON "Sair"         SIZE  50,10 PIXEL OF oDlgSCH ACTION oDlgSCH:End()

nLin1 := 02
nCol1 := nCol2+5
nCol2 := nCol1+75

oGrpSCH2 := TGroup():New( nLin1,nCol1,nLin2,nCol2,"Shipping",oDlgSCH,CLR_BLACK,CLR_WHITE,.T.,.F. )
@nLin1+=8,nCol1+=5  MSGET cPesq PICTURE "@!" SIZE 48,08 PIXEL OF oDlgSCH
@nLin1,nCol1+52 BUTTON "..."                 SIZE 13,10 PIXEL OF oDlgSCH ACTION SCHBusca(cPesq)

oLBSCH := TListBox():New(nLin1+=12,nCol1,{|u| If(PCount()==0,nFocSCH,nFocSCH:=u)},aVetSCH,65,(nLin2-nLin1-5),{|| SCHUpDate(nFocSCH,oDlgSCH,.T.)},oDlgSCH,,CLR_BLACK,CLR_WHITE,.T. )

nLin1 := 02
nCol1 := nCol2+5
nCol2 := aPos[4]-2

oGrpSCH3 := TGroup():New( nLin1,nCol1,nLin2,nCol2,"Faturas",oDlgSCH,CLR_BLACK,CLR_WHITE,.T.,.F. )

@ nLin1+=8 ,nCol1+=5 LISTBOX oLbxSCH FIELDS HEADER "Faturas","Data","Importador" SIZE (nCol2-nCol1)-5,(nLin2-nLin1)-5 OF oDlgSCH PIXEL 

oLbxSCH:SetArray(aINVSch)
oLbxSCH:bLine := bLineSCH
    	             
Activate MsDialog oDlgSCH Centered   

TMPSCH->(dbCloseArea())
                                               
Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: SCHBusca()
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Descricao.: Realiza busca das schedules existentes
//|Observação: 
//+-----------------------------------------------------------------------------------//
*------------------------------------------------* 
Static Function SCHBusca(cBusca)
*------------------------------------------------* 

Local lRet := .T.
Local nSch := 0

If !Empty(cBusca)
	If aScan(aVetSCH,cBusca) == 0
		MsgInfo("Shipping Schedule não encontrada no sistema","Sem Shipping")
		lRet := .F.
	Else
		nSch := aScan(aVetSCH,cBusca)
		oLBSCH:Select(aScan(aVetSCH,cBusca))
		SCHUpDate(nSch,oDlgSCH,.T.)
		oLBSCH:Refresh()
	EndIf
EndIf

Return(lRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: UZSChCarr()
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Descricao.: Carrega Schedule já exitentes
//|Observação: 
//+-----------------------------------------------------------------------------------//
*------------------------------------------------* 
Static Function UZSChCarr(xUp)
*------------------------------------------------* 

Local cSql  := ""

aVetSCH := {}
aVetBkp := {}
aINVSch := {}

aDescSCH := {"Faturas","Data","Importador"}
cLine := "{aINVSch[oLbxSCH:nAt,1],aINVSch[oLbxSCH:nAt,2],aINVSch[oLbxSCH:nAt,3]}"
bLineSCH := &( "{ || " + cLine + " }" )
aAdd(aINVSch,{"","",""})

cSql := " SELECT ZZE_SCHEDU,ZZE_SEQREL,ZZE_DTSCHE,ZZE_INVOIC,ZZE_DTINV,ZZE_IMPNOM,ZZE_SCDTRE,ZZE_NRRSCH "
cSql += " FROM "+RetSqlName("ZZE")+" WHERE D_E_L_E_T_ <> '*' AND ZZE_FILIAL = '"+xFilial("ZZE")+"' AND ZZE_SCHEDU <> ' ' "
cSql += " ORDER BY ZZE_SCHEDU "            

Iif(Select("TMPSCH") # 0, TMPSCH->(dbCloseArea()), .T.)
TcQuery cSql New Alias "TMPSCH"
dbSelectArea("TMPSCH")
TMPSCH->(dbgotop()) 

If TMPSCH->(!EOF()) .AND. TMPSCH->(!BOF())
	While TMPSCH->(!EOF())
		If aScan(aVetSCH,TMPSCH->ZZE_SCHEDU) == 0
			aAdd(aVetSCH,TMPSCH->ZZE_SCHEDU)
			aAdd(aVetBkp,{TMPSCH->ZZE_SCHEDU,StoD(TMPSCH->ZZE_DTSCHE),StoD(TMPSCH->ZZE_SCDTRE),;
						  TMPSCH->ZZE_NRRSCH,TMPSCH->ZZE_SEQREL})
		EndIf
		TMPSCH->(dbSkip())
	EndDo
EndIf

If xUp
	oLBSCH:SetItems(aVetSCH)
EndIf

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: SCHUpDate()
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Descricao.: Faz update ao movimentar o TListBox
//|Observação: 
//+-----------------------------------------------------------------------------------//
*------------------------------------------------* 
Static Function SCHUpDate(nxComp,xoDl,xlAtu)
*------------------------------------------------* 

Local xComp := ""

If !Empty(nxComp)
	xComp := aVetSCH[nxComp]
	aINVSch := {}
	TMPSCH->(dbGoTop())
	While TMPSCH->(!EOF())
		If TMPSCH->ZZE_SCHEDU == xComp
			aAdd(aINVSch,{TMPSCH->ZZE_INVOIC,StoD(TMPSCH->ZZE_DTINV),Alltrim(TMPSCH->ZZE_IMPNOM)})
		EndIf
		TMPSCH->(dbSkip())
	EndDo			
EndIf

If xlAtu
	oLbxSCH:SetArray(aINVSch)
	oLbxSCH:bLine := bLineSCH
	oLbxSCH:Refresh()
	xoDl:Refresh()
EndIf

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: SCHFunc()
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Descricao.: Função para inclusão, alteração, exclusão e visualização dos schedules
//|Observação: 
//+-----------------------------------------------------------------------------------//
*------------------------------------------------* 
Static Function SCHFunc(xSch,nOpc)
*------------------------------------------------* 

Local bOk      := {|| lRet := SCHGrava(nOpc,aVetFunc,cSche,dDt,dDtRev,nRev), Iif(lRet,oDlg:End(),.T.)}
Local bCancel  := {|| oDlg:End() }
Local lMak     := Iif(nOpc <> INCLUSAO,.T.,.F.)
Local lRet     := .T.
Local cSql     := ""
Local oDlg     := Nil
Local oGrpS1   := Nil
Local oGrpS2   := Nil
Local oLBoxS   := Nil
Local aPosS    := {}
Local aVetFunc := {}
Local aButt    := {}
Local nLi1     := 00
Local nLi2     := 00
Local nCo1     := 00
Local nCo2     := 00
Local cSche    := Space(6)
Local dDt      := CtoD(Space(8))
Local dDtRev   := CtoD(Space(8))
Local nRev     := 0
Local lWheAlt  := Iif(nOpc == INCLUSAO,.T.,.F.)
Local lWheExc  := Iif(nOpc == ALTERACAO,.T.,.F.)
Local oOk      := LoadBitmap( GetResources(), "LBOK" )
Local oNo      := LoadBitmap( GetResources(), "LBNO" )
Local bLineS   := &("{|| "+"{Iif(aVetFunc[oLbxS:nAt,1],oOk,oNo),aVetFunc[oLbxS:nAt,2],aVetFunc[oLbxS:nAt,3],aVetFunc[oLbxS:nAt,4]}"+"}")
Local aDescS   := {"","Faturas","Data","Importador"}

If nOpc <> INCLUSAO .AND. Empty(xSch)
	MsgInfo("Não há Shipping Schedule selecionada","Sem Shipping")
	Return
ElseIf nOpc <> INCLUSAO
	cSche  := aVetBKP[Ascan(aVetBKP,{|x|x[1] == aVetSCH[xSch] }),1]
	dDt    := aVetBKP[Ascan(aVetBKP,{|x|x[1] == aVetSCH[xSch] }),2]
	dDtRev := aVetBKP[Ascan(aVetBKP,{|x|x[1] == aVetSCH[xSch] }),3]
	nRev   := aVetBKP[Ascan(aVetBKP,{|x|x[1] == aVetSCH[xSch] }),4]
EndIf

cSql := " SELECT ZZE_INVOIC,ZZE_DTINV,ZZE_IMPNOM FROM "+RetSqlName("ZZE")
cSql += " WHERE D_E_L_E_T_ <> '*' AND ZZE_FILIAL = '"+xFilial("ZZE")+"' "
cSql += " AND ZZE_SCHEDU = '"+Iif(nOpc <> INCLUSAO,aVetSCH[xSch]," ")+"' "
cSql += " ORDER BY ZZE_INVOIC "            

Iif(Select("TMPINC") # 0, TMPINC->(dbCloseArea()), .T.)
TcQuery cSql New Alias "TMPINC"
dbSelectArea("TMPINC")
TMPINC->(dbgotop()) 

If TMPINC->(EOF()) .AND. TMPINC->(BOF()) .AND. nOpc == INCLUSAO
	MsgInfo("Não há Invoices para Inclusão","Sem Invoices")
	TMPINC->(dbCloseArea())
	Return
EndIf

While TMPINC->(!EOF())
	aAdd(aVetFunc,{lMak,TMPINC->ZZE_INVOIC,TMPINC->ZZE_DTINV,Alltrim(TMPINC->ZZE_IMPNOM)})
	TMPINC->(dbSkip())
EndDo
TMPINC->(dbCloseArea())

If nOpc == ALTERACAO
	aAdd(aButt,{"AVGARMAZEM" ,{ || SCHCargaN(aVetFunc,oLbxS,bLineS)  }, "Carrega Faturas Disponiveis"})
ElseIf nOpc == VISUAL
	bOk := bCancel
EndIf

Define MsDialog oDlg Title "Shipping Schedule" From 0,0 TO 300,600 OF oDlg PIXEL STYLE DS_MODALFRAME

aPosS := PosDlg(oDlg)

nLi1 := 15
nLi2 := aPosS[3]-2
nCo1 := 05
nCo2 := 100

oGrpS1 := TGroup():New( nLi1,nCo1,nLi2,nCo2,"Cadastrais",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )

@ nLi1+=9 ,nCo1+=5 SAY "Schedule"  SIZE 40,7 PIXEL OF oDlg
@ nLi1 ,nCo1+30 MSGET cSche PICTURE "@!" WHEN lWheAlt SIZE 55,8 PIXEL OF oDlg
@ nLi1+=12,nCo1 SAY "Data"  SIZE 40,7 PIXEL OF oDlg
@ nLi1 ,nCo1+30 MSGET dDt PICTURE "@D" WHEN lWheAlt SIZE 55,8 PIXEL OF oDlg
@ nLi1+=12,nCo1 SAY "Dt Revisao"  SIZE 40,7 PIXEL OF oDlg
@ nLi1 ,nCo1+30 MSGET dDtRev PICTURE "@D" WHEN lWheExc SIZE 55,8 PIXEL OF oDlg
@ nLi1+=12,nCo1 SAY "Nr Revisao"  SIZE 40,7 PIXEL OF oDlg
@ nLi1 ,nCo1+30 MSGET nRev PICTURE "@E 99" WHEN lWheExc SIZE 55,8 PIXEL OF oDlg

nLi1 := 15
nCo1 := nCo2+5
nCo2 := aPosS[4]-2

oGrpS2 := TGroup():New( nLi1,nCo1,nLi2,nCo2,"Faturas",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )

oLbxS  := TWBrowse():New( nLi1+10,nCo1+5,(nCo2-nCo1)-10,(nLi2-nLi1)-15,,aDescS,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oLbxS:SetArray( aVetFunc )
If nOpc == INCLUSAO .OR. nOpc == ALTERACAO
	oLbxS:bLDblClick := { || aVetFunc[oLbxS:nAt,1] := !aVetFunc[oLbxS:nAt,1] }
EndIf
oLbxS:bLine := bLineS
    	             
Activate MsDialog oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel,,aButt) Centered   

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: SCHGrava()
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Descricao.: Grava Dados do Shipping Schedule
//|Observação: 
//+-----------------------------------------------------------------------------------//
*------------------------------------------------* 
Static Function SCHGrava(xOpc,xVet,xSch,xDt,xDtRe,xnRe)
*------------------------------------------------* 

Local lRet := .F.
Local nTem := Ascan(xVet,{|x|x[1] == .T. } )
Local hj

If xOpc == INCLUSAO .AND. (Empty(xSch) .OR. Empty(xDt))
	MsgInfo("Numero da Shipping Schedule e Data devem ser preenchidos","Obrigatorio")
	Return(lRet)
ElseIf Empty(nTem)
	MsgInfo("Não há faturas selecionadas","Sem faturas")
	Return(lRet)	
EndIf

lRet := MsgYesNo("Confirma a gravação das informações?","Gravar")

ZZE->(dbSetOrder(1))
Begin Transaction
	If lRet
		For hj := 1 To Len(xVet)
			If ZZE->(dbSeek(xFilial("ZZE")+xVet[hj,2]))
				ZZE->(RecLock("ZZE",.F.))
				If xVet[hj,1]
					If  xOpc <> EXCLUSAO
						ZZE->ZZE_SCHEDU := xSch
						ZZE->ZZE_DTSCHE := xDt
						ZZE->ZZE_NRRSCH := xnRe
						ZZE->ZZE_SCDTRE := xDtRe
					Else
						ZZE->ZZE_SCHEDU := ""
						ZZE->ZZE_SEQREL := ""
						ZZE->ZZE_DTSCHE := CtoD("")
						ZZE->ZZE_NRRSCH := 0
						ZZE->ZZE_SCDTRE := CtoD("")						
					EndIf
				ElseIf xOpc == ALTERACAO
					ZZE->ZZE_SCHEDU := ""
					ZZE->ZZE_SEQREL := ""
					ZZE->ZZE_DTSCHE := CtoD("")
					ZZE->ZZE_NRRSCH := 0
					ZZE->ZZE_SCDTRE := CtoD("")
				EndIf
				ZZE->(MsUnLock())
			EndIf
		Next
	EndIf
End Transaction

Processa({ || UZSChCarr(.T.) })
If Len(aVetSCH) > 0
	SCHUpDate(1,oDlgSCH,.T.)
EndIf

Return(lRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: SCHCargaN()
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Descricao.: Carrega faturas disponiveis
//|Observação: 
//+-----------------------------------------------------------------------------------//
*------------------------------------------------* 
Static Function SCHCargaN(xVet,xLbl,xLine)
*------------------------------------------------* 

Local cSql := ""

cSql := " SELECT ZZE_INVOIC,ZZE_DTINV,ZZE_IMPNOM FROM "+RetSqlName("ZZE")
cSql += " WHERE D_E_L_E_T_ <> '*' AND ZZE_FILIAL = '"+xFilial("ZZE")+"' AND ZZE_SCHEDU = '' "
cSql += " ORDER BY ZZE_INVOIC "            

Iif(Select("TMPINC") # 0, TMPINC->(dbCloseArea()), .T.)
TcQuery cSql New Alias "TMPINC"
dbSelectArea("TMPINC")
TMPINC->(dbgotop()) 

If TMPINC->(EOF()) .AND. TMPINC->(BOF()) .AND. nOpc == INCLUSAO
	MsgInfo("Não há Invoices para Carregar","Sem Invoices")
	TMPINC->(dbCloseArea())
	Return
EndIf

While TMPINC->(!EOF())
	aAdd(xVet,{.F.,TMPINC->ZZE_INVOIC,TMPINC->ZZE_DTINV,Alltrim(TMPINC->ZZE_IMPNOM)})
	TMPINC->(dbSkip())
EndDo
TMPINC->(dbCloseArea())

xLbl:SetArray(xVet)
xLbl:bLDblClick := { || xVet[xLbl:nAt,1] := !xVet[xLbl:nAt,1] }
xLbl:bLine := xLine
xLbl:Refresh()

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: SCHVisFat(xFat)
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Descricao.: Visualiza fatura em foco no Browser
//|Observação: 
//+-----------------------------------------------------------------------------------//
*------------------------------------------------* 
Static Function SCHVisFat(xFat)
*------------------------------------------------* 

ZZE->(dbSetOrder(1))
If ZZE->(dbSeek(xFilial("ZZE")+xFat))
	U_UZINVMANUT("ZZE",ZZE->(RecNo()),VISUAL,.T.)
EndIf

Return