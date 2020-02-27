#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MDEXETQ  ³ Autor ³ Antonio - ADVPL       ³ Data ³02/08/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±³Retorno   ³                                                            ³±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/     

User Function MDEXETQ()

Local cCodEtq	 := Space(10)
Local oCodEtq
Local cImpEt 	

Private oDlg
Private nOpc

//Monta interface com o usuário
DEFINE MSDIALOG oDlg TITLE "Exclusão da Etq de Pallet" FROM C(164),C(182) TO C(325),C(409) PIXEL

// Cria as Groups do Sistema
@ C(003),C(003) TO C(102),C(260) LABEL "Informe o Código da Etiqueta" PIXEL OF oDlg

// Cria Componentes Padroes do Sistema
@ C(013),C(008) Say "Cod Etq:" Size C(038),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(013),C(030) MsGet oCodEtq Var cCodEtq Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg

DEFINE SBUTTON FROM C(028),C(046) TYPE 1 ENABLE OF oDlg ACTION {||nOpc := 1,oDlg:End()}

ACTIVATE MSDIALOG oDlg CENTERED

If nOpc == 1
	Processa({||ExcCB0(cCodEtq)})
Else
	Alert("Processamento cancelado pelo usuário")
EndIf
Return(.T.)


/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Execução da Rotina - Antonio
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Static Function ExcCB0(cCodEtq,cImpEt)

Local cAliasCB := GetNextAlias()
Local cAliasC1 := GetNextAlias()
Local cAliasC2 := GetNextAlias()
Local cQuery   := "" 
Local cQuery1  := "" 
Local cQuery2  := "" 
Local lRet     := .T.

ProcRegua(5)
//Aumenta a regua
IncProc("Procurando Etiqueta referente ao Pallet...")

If Select(cAliasCB) > 0
	dbSelectArea(cAliasCB)
	dbClosearea()
Endif
              
cQuery := " SELECT CB0.CB0_CODETI, CBL.CBL_DOC, CBL.CBL_SERIE, CB0.CB0_PALLET, CB0.R_E_C_N_O_ CB0REC, COALESCE( CBL.R_E_C_N_O_, 0 ) CBLREC "
cQuery += "  FROM " + RetSqlName("CB0") + " CB0  "

cQuery += "   INNER JOIN " + RetSqlName("CBL") + " CBL ON "
cQuery += "         CBL.CBL_FILIAL = '" + xFilial("CBL") + "' AND "
cQuery += "         CBL.CBL_CODETI = CB0.CB0_CODETI AND "
cQuery += "         CBL.D_E_L_E_T_ = ' ' "
cQuery += "   INNER JOIN " + RetSqlName("CBK") + " CBK ON "
cQuery += "         CBK.CBK_FILIAL = '" + xFilial("CBK") + "' AND "
cQuery += "         CBK.CBK_DOC    = CBL.CBL_DOC    AND "
cQuery += "         CBK.CBK_SERIE  = CBL.CBL_SERIE  AND "
cQuery += "         CBK.CBK_CLIENT = CBL.CBL_CLIENT AND "
cQuery += "         CBK.CBK_LOJA   = CBL.CBL_LOJA   AND "
cQuery += "         CBK.CBK_STATUS > '0'  AND "               /* 0 OU VAZIO - NAO INICIOU EMBARQUE, 1=EMBARCANDO, 2=EMBARCADO */
cQuery += "         CBK.D_E_L_E_T_ = ' '  "
     
cQuery += "   WHERE CB0.CB0_PALLET = '" + cCodEtq + "' "
cQuery += "     AND CB0.CB0_TIPO   = '01' "
cQuery += "     AND CB0.D_E_L_E_T_ = ' '  "
cQuery += "     AND CB0.CB0_FILIAL = '" + xFilial("CB0") + "' "
cQuery += "   ORDER BY CB0.R_E_C_N_O_"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCB,.T.,.T.) 

// INICIO ALESSANDRO
// TONHÃO, CRIEI OS CAMPOS REC NA QUERY, AÍ NÃO PRECISA DAR SEEK. VAI DIRETO PELO DBGOTO()
// 1o. FAZ UM LOOP NA QUERY TODA. SE ALGUM REGISTRO TIVER CBL_DOC PREENCHIDO, NÃO DEIXA EXCLUIR O PALETE
// 2o. FECHA A AREA DA QUERY PQ QUERY NÃO FAZ DBGOTOP()
// 3o. SE NÃO TIVER CBL_DOC PREENCHIDO, EXECUTA A QUERY NOVAMENTE COM DBUSEAREA(). SE TIVER, AVISE O USUÁRIO E SAI DA ROTINA.
//     - WHILE ! EOF()
//       - SELECIONA CB0
//       - DBGOTO( (cAliasCB0)->CB0REC ) 
//       - RECLOK() DBDELETE() MSUNLOCK()
//       - SELECIONA cAliasCB0, DBSKIP()
//       - ENDDO
// FIM ALESANDRO

dbSelectArea(cAliasCB)

While (cAliasCB)->(!Eof())

	IncProc("Procurando Etiqueta referente ao Pallet...")
	
	If !Empty((cAliasCB)->CB0_DOC)

		Alert("Etiqueta " + cCodEtq + " está vinculada a nota fiscal No.: " + (cAliasCB)->CBL_DOC + " " + (cAliasCB)->CBL_SERIE + ", não pode ser excluida!!! ")
		(cAliasCB)->(dbCloseArea())
		lRet:=.F.
		Exit
	EndIf
	
	(cAliasCB)->(dbSkip())

EndDo


If lRet
	(cAliasCB)->(dbCloseArea())

	cQuery1 := " SELECT CB0.CB0_CODETI, CB0.CB0_PALLET, CB0.R_E_C_N_O_ CB0REC1 "
	cQuery1 += "  FROM " + RetSqlName("CB0") + " CB0  "
	cQuery1 += "   WHERE CB0.CB0_PALLET = '" + cCodEtq + "' "
	cQuery1 += "     AND CB0.CB0_TIPO   = '01' "
	cQuery1 += "     AND CB0.D_E_L_E_T_ = ' '  "
	cQuery1 += "     AND CB0.CB0_FILIAL = '" + xFilial("CB0") + "' "
	cQuery1 += "   ORDER BY CB0.R_E_C_N_O_"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAliasC1,.T.,.T.) 
	
	While (cAliasC1)->(!Eof())
		
		//DBGOTO( (cAliasC1)->CB0REC1 )
		CB0->(dbSetOrder(1))
		If CB0->(dbSeek(xFilial("CB0")+(cAliasC1)->CB0_CODETI) )
			RecLock("CB0",.F.)
			CB0->CB0_PALLET := ' '
			MsUnlock()
		EndIf
		
		(cAliasC1)->(dbSkip())
	
	EndDo

	cQuery2 := " SELECT CB0.CB0_CODETI, CB0.CB0_PALLET, CB0.R_E_C_N_O_ CB0REC2 "
	cQuery2 += "  FROM " + RetSqlName("CB0") + " CB0 "     
	cQuery2 += "   WHERE CB0.CB0_CODETI = '" + cCodEtq + "' "
	cQuery2 += "     AND CB0.D_E_L_E_T_ = ' '  "
	cQuery2 += "     AND CB0.CB0_FILIAL = '" + xFilial("CB0") + "' "
	cQuery2 += "     AND CB0.CB0_TIPO   = '01' "
	cQuery2 += "   ORDER BY CB0.R_E_C_N_O_"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAliasC2,.T.,.T.) 
	
	dbSelectArea(cAliasC2)

	While (cAliasC2)->(!Eof())

//		DBGOTO( (cAliasC2)->CB0REC2 )
		If CB0->(dbSeek(xFilial("CB0")+(cAliasC2)->CB0_CODETI) )
			RecLock("CB0",.F.)
			CB0->( dbDelete() )
			MsUnlock()
		EndIf	
		(cAliasC2)->(dbSkip())
	
	EndDo


Else
	Alert("Etiqueta não encontrada!!! ")
	(cAliasCB)->(dbCloseArea())
EndIf   

(cAliasC1)->(dbCloseArea())
(cAliasC2)->(dbCloseArea())


Alert("Processo Finalizado com Sucesso!!! ")

Return()                     
