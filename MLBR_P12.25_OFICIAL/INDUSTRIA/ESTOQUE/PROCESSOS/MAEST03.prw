#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³          ³ Autor ³ Bruno M. Mota         ³ Data ³11.12.2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Consultor de Neg ³Contato ³ bmassarelli@taggs.com.br       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ajuste de empenho para um grupo de produtos                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MAEST03()
// Variaveis Locais da Funcao
// Variaveis Private da Funcao
Private oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private cGrupo	 	:= Space(2)
Private cOP	 		:= Space(6)
Private nPorcentag	:= 0
Private nOpc 		:= 0
Private nResp		:= 0
Private oGrupo
Private oOP
Private oPorcentag
Private VISUAL := .F.                        
Private INCLUI := .F.                        
Private ALTERA := .F.                        
Private DELETA := .F.                        
                        

DEFINE MSDIALOG oDlg TITLE "Ajuste de Empenho" FROM C(178),C(181) TO C(344),C(668) PIXEL

	// Cria as Groups do Sistema
	@ C(000),C(004) TO C(033),C(243) LABEL "" PIXEL OF oDlg
	@ C(035),C(001) TO C(083),C(194) LABEL "Dados do Ajuste:" PIXEL OF oDlg

	// Cria Componentes Padroes do Sistema
	@ C(010),C(008) Say "Esta rotina realiza ajustes de empenho para todos os produtos de um determinado grupo selecionado pelo usuário, baseado em uma porcentagem fornecida." Size C(231),C(017) COLOR CLR_BLUE PIXEL OF oDlg
	@ C(053),C(008) Say "Ordem de Produção:" Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(053),C(059) MsGet oOP Var cOP F3 "SC2" Size C(060),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(053),C(124) Say "Grupo do Produto:" Size C(046),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(053),C(171) MsGet oGrupo Var cGrupo F3 "SBM" Size C(016),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(069),C(008) Say "Porcentagem:" Size C(034),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(069),C(059) MsGet oPorcentag Var nPorcentag Size C(060),C(009) COLOR CLR_BLACK Picture "@E 9,999.99" PIXEL OF oDlg
	DEFINE SBUTTON FROM C(038),C(207) TYPE 1 ENABLE OF oDlg ACTION {|| nOpc := 1,oDlg:End()}
	DEFINE SBUTTON FROM C(056),C(207) TYPE 2 ENABLE OF oDlg ACTION {|| Alert("Processo cancelado pelo usuário."),oDlg:End() }

	// Cria ExecBlocks dos Componentes Padroes do Sistema
    oGrupo:bValid 		:= {|| ExistCpo("SBM",cGrupo)}
    
ACTIVATE MSDIALOG oDlg CENTERED                 
//Processa a escolha do usuário
If nOpc == 1       
   //  IF nRadio == 1
     
     //Endif

	//Valida o valor da porcentagem
	If nPorcentag > 100
		//Envia um aviso ao usuário
		nResp := Aviso("Valor da Porcentagem","O valor inserido ultrapassa 100%. Deseja confirmar ?",{"Sim","Nào"})
		//Verifica a escolha do usuário
		If nResp == 2
			//Sai da rotina
			Return()
		EndIf
	EndIf
	//Processa a rotina de atualizacao
	Processa({||AtuSD4()})
	//Reinicia a rotina
	U_MAEST03()
EndIf	
//Retorno da rotina
Return

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Rotina de atualizacao da SD4³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
Static Function AtuSD4()
//Variaveis locais da funcao
Local cQuery := ""
//Inicio da funcao
//Monta a query
cQuery := "SELECT"
cQuery += "	D4_COD,"
cQuery += "	D4_QTDEORI+((D4_QTDEORI*"+Str(nPorcentag)+")/100) QTDORI,"
cQuery += "	D4_QUANT+((D4_QUANT*"+Str(nPorcentag)+")/100) SALDO "
cQuery += "FROM"
cQuery += "	"+RetSqlName("SD4")+" SD4 "
cQuery += "		INNER JOIN "+RetSqlName("SB1")+" SB1 "
cQuery += "		ON B1_COD = D4_COD AND"
cQuery += "		SUBSTRING(D4_OP,1,6) = '"+cOP+"' AND"
cQuery += "		SB1.B1_GRUPO = '"+cGrupo+"'"
//Ajusta a query de acordo com a base de dados
cQuery := ChangeQuery(cQuery)
//Executa a query dos valores
TcQuery cQuery New Alias "SD4TMP"
//Determina tmanho da regua
ProcRegua(30)
//Inicia transacao
Begin Transaction
//Seta a ordem da tabela SD4
SD4->(dbSetOrder(1))
//Posiciona tabela temporaria no primeiro registro                                                                                 
SD4TMP->(dbGoTop())
//Loop de Processamento
While !SD4TMP->(EoF())
	//Posiciona tabela SD4
	If SD4->(dbSeek(xFilial("SD4")+SD4TMP->D4_COD+cOP))
		//Trava registro para gravação
		RecLock("SD4",.F.)
			SD4->D4_QTDEORI := SD4TMP->QTDORI
			SD4->D4_QUANT  := SD4TMP->SALDO
		SD4->(MsUnlock())
	EndIf
	//Muda de registro
	SD4TMP->(dbSkip())
	//Atualiza regua
	IncProc("Atualizando empenhos...")
EndDo
//Fecha a tabela temporaria
SD4TMP->(dbCloseArea())
//Termina a transacao
End Transaction
//Alerta de finalizaçao da rotina
Alert("Operação Concluída")
//Retorno da rotina
Return(.T.)

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
