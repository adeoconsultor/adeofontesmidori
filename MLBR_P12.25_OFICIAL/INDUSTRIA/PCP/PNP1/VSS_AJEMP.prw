#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"     
#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VSS_AJEMP ºAutor  ³ Vinicius Schwartz  º Data ³  09/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Projeto Ajuste de empenho por Kg                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso.      ³Esta rotina realiza ajustes de empenho para todos os produ- º±±
±±º          ³tos de um determinado grupo selecionado pelo usuário,       º±±
±±º          ³baseado em uma qtde de kg fornecida.						  º±±
±±º          ³                    							              º±±
±±º          ³Solicitacao: Thiago Cruz                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

User Function VSS_AJEMP()
// Variaveis Locais da Funcao
Local lManual := .T.
// Variaveis Private da Funcao
Private oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
//Private cGrupo	 	:= Space(2)
Private cOP	 		:= Space(6)
Private nKg			:= 0
Private nOpc 		:= 0
Private nResp		:= 0
Private aItens      := {}
//Private oGrupo
Private oOP
Private oKg
Private VISUAL := .F.                        
Private INCLUI := .F.                        
Private ALTERA := .F.                        
Private DELETA := .F. 


DEFINE MSDIALOG oDlg TITLE "Ajuste de Empenho" FROM C(178),C(181) TO C(344),C(668) PIXEL

	// Cria as Groups do Sistema
	@ C(000),C(004) TO C(033),C(243) LABEL "" PIXEL OF oDlg
	@ C(035),C(001) TO C(083),C(194) LABEL "Dados do Ajuste:" PIXEL OF oDlg

	// Cria Componentes Padroes do Sistema
	@ C(010),C(008) Say "Esta rotina realiza ajustes de empenho para todos os produtos de um determinado grupo selecionado pelo usuário, baseado em uma qtd de Kg  fornecida." Size C(231),C(017) COLOR CLR_BLUE PIXEL OF oDlg
	@ C(053),C(008) Say "Ordem de Produção:" Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(053),C(059) MsGet oOP Var cOP F3 "SC2" Size C(060),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
//	@ C(053),C(124) Say "Grupo do Produto:" Size C(046),C(008) COLOR CLR_BLACK PIXEL OF oDlg
//	@ C(053),C(171) MsGet oGrupo Var cGrupo F3 "SBM" Size C(016),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(069),C(008) Say "Kg:" Size C(034),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(069),C(059) MsGet oKg Var nKg Size C(060),C(009) COLOR CLR_BLACK Picture "@E 9,999.9999" PIXEL OF oDlg
	DEFINE SBUTTON FROM C(038),C(207) TYPE 1 ENABLE OF oDlg ACTION {|| U_AtD4B2(cOP,nKg, lManual)}
	DEFINE SBUTTON FROM C(056),C(207) TYPE 2 ENABLE OF oDlg ACTION {|| Alert("Processo cancelado pelo usuário."),oDlg:End() }
	DEFINE SBUTTON FROM C(074),C(207) TYPE 6 ENABLE OF oDlg ACTION {|| VSS_IMPAJE()}

	oDlg:Activate(,,,.T.)
   

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Rotina de atualizacao da SD4³
//³e SB2 				       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
User Function AtD4B2(cOP,nKg, lManual)
//Variaveis locais da funcao
Local cQry := ""
Local nWet		:= 0 //WW ou WB 8
Local nQtdVq	:= 0 //Qtde de VQ SC2
Local nQtdAnt	:= 0 //Qtde na SD4 antes da alteracao
Local nQtdAtu	:= 0 //Qtde da SD4 apos o calc 
Local cCodPro	:= Space(6)
Local cTpClass	:= Space(2)

//Inicio da funcao
        
		//Descobrindo o TP de Class do produto para tratar WW ou WB
        //Posiciona em SC2 para pegar Cod do Protudo
        dbSelectArea('SC2')
        dbSetOrder(1)
        dbSeek(xFilial('SC2')+cOP)
        cCodPro := SC2->C2_PRODUTO
                
        //Posiciona em SB1 para pegar o Tipo de Class.
		dbSelectArea('SB1')
		dbSetOrder(1)
		dbSeek(xFilial('SB1')+cCodPro)
		cTpClass := SB1->B1_TPCLASS        
        
		//Verifica se WB ou WW
		if cTpClass == 'CF'  //WW = 3Kg
			nWet := 3
		Elseif (cTpClass == 'CR') .OR. (cTpClass == 'CV')  //WB = 3.5Kg
			nWet := 3.5
		Endif
	

//Verifica se tabelas temporias existem e encerra as mesmas antes de executar as novas
if Select("TMPSD4") > 0 
	dbSelectArea("TMPSD4")
	TMPSD4->(dbCloseArea())
endif


//Monta a query

cQry := " SELECT D4.D4_FILIAL, D4.D4_COD, D4.D4_LOCAL, D4.D4_OP, D4.D4_QTDEORI, D4.D4_QUANT, "
cQry += "		B2.B2_FILIAL, B2.B2_COD, B2.B2_LOCAL, B2.B2_QEMP, B1.B1_COD, B1.B1_TPCLASS, "
cQry += " 		C2.C2_NUM, C2.C2_QUANT, C2.C2_QUJE "
cQry += " FROM SD4010 D4 "
cQry += " JOIN SB1010 B1 "
cQry += "	ON B1.D_E_L_E_T_ <> '*' "
cQry += "	AND B1.B1_COD = D4.D4_COD "
cQry += "	AND (B1.B1_GRUPO = '12' OR B1.B1_GRUPO = '14') "
cQry += " JOIN SB2010 B2 "
cQry += "	ON B2.D_E_L_E_T_ <> '*' "
cQry += "	AND B2.B2_FILIAL = D4.D4_FILIAL "
cQry += "	AND B2.B2_LOCAL = D4.D4_LOCAL "
cQry += "	AND B2.B2_COD = D4.D4_COD " 
cQry += " JOIN SC2010 C2 "
cQry += " 	ON C2.D_E_L_E_T_ <> '*' "
cQry += " 	AND C2.C2_FILIAL = D4.D4_FILIAL "
cQry += "	AND C2.C2_NUM = SUBSTRING(D4.D4_OP,1,6) "
cQry += " WHERE D4.D_E_L_E_T_ <> '*' "
cQry += "	AND SUBSTRING(D4.D4_OP,1,6) = '"+cOP+"' " 
cQry += "	AND D4_FILIAL = '"+xFilial("SD4")+"' " 
cQry += " 	ORDER BY D4.D4_OP "  

cQry:= ChangeQuery(cQry)
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry),"TMPSD4",.T.,.T.) 

	//Inicia a transacao
	Begin Transaction  
	
	//Posiciona tabela temporaria no primeiro registro
	TMPSD4->(dbGoTop())
	
	//Loop de processamento
	While !TMPSD4->(EOF())
	
		//Verifica Qtd de VQ na SC2
		nQtdVq := TMPSD4->C2_QUANT

		dbSelectArea('SC2')
		SC2->(dbSetOrder(1))
		dbSeek(xFilial('SC2')+cOP)
		if SC2->C2_X_KG == 0
			nKgAnt := SC2->C2_QUANT * nWet
		else
			if lManual
				nKgAnt := SC2->C2_X_KG
			else
				nKgAnt := SC2->C2_QUANT * nWet
			endif
		endif

		If nKg > 0
			//Faz alteracao SD4   
			dbSelectArea('SD4')		
			SD4->(dbSetOrder(1))
			If SD4->(dbSeek(xFilial("SD4")+TMPSD4->D4_COD+cOP))
				//Trava registro para gravar   
				RecLock("SD4",.F.)
					nQtdAnt := SD4->D4_QUANT
					SD4->D4_QUANT := TMPSD4->D4_QUANT * (nKg / nKgAnt)			//Saldo
					nQtdAtu := SD4->D4_QUANT                                                              
					SD4->D4_QTDEORI := (TMPSD4->D4_QTDEORI - nQtdAnt) +  nQtdAtu		//Qtde Ori	
				SD4->(MsUnlock()) 
			EndIf
			
			//Faz alteracao SB2
			dbSelectArea('SB2')
			SB2->(dbSetOrder(1))
			If SB2->(dbSeek(xFilial("SB2")+TMPSD4->D4_COD+TMPSD4->D4_LOCAL))
				//Trava registro para gravar
				RecLock("SB2",.F.)
					SB2->B2_QEMP := SB2->B2_QEMP + (nQtdAtu - nQtdAnt)
				SB2->(MsUnlock())		                                                
			EndIf
        EndIf
				
	    TMPSD4->(dBSkip())
	
	EndDo                   
	
	//Fecha a tabela temporaria
	TMPSD4->(dbCloseArea())
	
	//Grava o Kg na SC2
	dbSelectArea('SC2')
	SC2->(dbSetOrder(1))
	dbSeek(xFilial('SC2')+cOP)
	RecLock('SC2',.F.)
	SC2->C2_X_KG := nKg           
	SC2->C2_X_DTKG := dDataBase
	MsUnLock('SC2')
	

	End Transaction
	
		
if lManual
	//Alerta de finalizaçao da rotina
	Alert("Operação Concluída")
	
	oDlg:End()
	U_VSS_AJEMP()        
endif

//Retorno da rotina */
Return


//Funcao para chamar a impressao para conferencia
//Vinicius de Sousa Schwartz - TI - Midori Atlantica 11/04/2012
Static Function VSS_IMPAJE()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cData   := Date()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg2","oData","oGet1","oBtnprint")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg2      := MSDialog():New( 091,232,203,392,"Impressão",,,.F.,,,,,,.T.,,,.T. )
oData   := TSay():New( 008,012,{||"Informe Data Referência:"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGet1      := TGet():New( 020,008,{|u| If(PCount()>0, cData:=u, cData)},oDlg2,056,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SC2","",,)
oBtnprint  := TButton():New( 032,008,"Imprimir",oDlg2,{|| oDlg2:End(),U_VSS_RELAJ(cData)},056,012,,,,.T.,,"",,,,.F. )

oDlg2:Activate(,,,.T.)

Return

//


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
	//³Tratamento para tema "Flat"³                                               
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)   