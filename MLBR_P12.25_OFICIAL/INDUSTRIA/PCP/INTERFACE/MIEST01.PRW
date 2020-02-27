#INCLUDE "TOTVS.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMIEST01  บAutor  ณAntonio Carlos Damaceno บ Data ณ  25/02/03บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para ESTORNO PLANO/DA FICHA e DESBLOQUEAR PLANO     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAP11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MIEST01()

//TBrowseButton()  
DEFINE DIALOG oDlg TITLE "ESTORNO PLANO | ESTORNO DA FICHA | DESBLOQUEAR PLANO | ALTERA PLANO" FROM 180,180 TO 550,700 PIXEL	    

@ C(010),C(010) TO C(160),C(260) LABEL "Clique na op็ใo desejada:" PIXEL OF oDlg

oTBrowseButton1 := TBrowseButton():New( 040,080,'ESTORNO DO PLANO  DE PRODUวรO ',oDlg,{||FS_ESTP01()},100,10,,,.F.,.T.,.F.,,.F.,,,)    
oTBrowseButton2 := TBrowseButton():New( 060,080,'ESTORNO DA FICHA  DE PRODUวรO ',oDlg,{||FS_ESTF01()},100,10,,,.F.,.T.,.F.,,.F.,,,)
oTBrowseButton3 := TBrowseButton():New( 080,080,'DESBLOQUEAR PLANO DE PRODUวรO ',oDlg,{||FS_ESTD01()},100,10,,,.F.,.T.,.F.,,.F.,,,)
oTBrowseButton4 := TBrowseButton():New( 100,080,'ALTERAR O PLANO DE PRODUวรO   ',oDlg,{||FS_ESTA01()},100,10,,,.F.,.T.,.F.,,.F.,,,)
oTBrowseButton5 := TBrowseButton():New( 130,105,'SAIR',oDlg,{|| oDlg:End() },50,10,,,.F.,.T.,.F.,,.F.,,,)
ACTIVATE DIALOG oDlg CENTERED 
Return  


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina do ESTORNO DO PLANO DE PRODUวรO
//ANTONIO - 01/09
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function FS_ESTP01()
//Alert('Clique em ESTORNO PLANO PRODUวรO')

Local cQuery    := ""
Local cAliasSql := GetNextAlias()
Local cAliasSql1:= GetNextAlias()
Local cAliasSql2:= GetNextAlias()
Local lRet      := .F.
Local cCodPlano	:= Space(20)
Local oCodPlano

Private oDlg
Private nOpc

//Monta interface com o usuแrio
//DEFINE MSDIALOG oDlg TITLE "Altera็ใo de Campos do Plano de Produ็ใo" FROM C(164),C(182) TO C(325),C(409) PIXEL
DEFINE MSDIALOG oDlg TITLE "Estorno do Plano de Produ็ใo" FROM C(010),C(010) TO C(325),C(409) PIXEL

// Cria as Groups do Sistema
@ C(003),C(003) TO C(160),C(260) LABEL "Informe o Plano a Estornar" PIXEL OF oDlg

// Cria Componentes Padroes do Sistema
@ C(013),C(008) Say "Cod Plano:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(013),C(050) MsGet oCodPlano Var cCodPlano Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg VALID FS_XPLANO(cCodPlano,"EP")

oTBrowseButton := TBrowseButton():New( 180,145,'Confirmar',oDlg,{||nOpc := 1,oDlg:End() },50,10,,,.F.,.T.,.F.,,.F.,,,)
oTBrowseButton1 := TBrowseButton():New( 180,200,'Fechar',oDlg,{||oDlg:End() },50,10,,,.F.,.T.,.F.,,.F.,,,)

ACTIVATE MSDIALOG oDlg CENTERED

/************* ESTORNO PLANO  ********************
####### RESET NOS CAMPOS DA TABELA SZ3 PARA TODAS AS FICHAS DO PLANO #######
UPDATE SZ3010 SET Z3_SALDO = Z3_QTDE, Z3_M2TOT = (Z3_QTDE * Z3_M2PAD), Z3_STATUS = 'A', Z3_DTAPON = '',Z3_USUAPON = '', Z3_HRAPON = '', Z3_OPAPONT = 'N' 
WHERE
Z3_FILIAL = '09' AND 
Z3_PLANO IN ('369B 32-02C/16') AND 
D_E_L_E_T_ = ''  

####### RESET NO SALDO EM M2 DAS FICHAS #######
UPDATE SZ3010 SET Z3_SLDM2 = Z3_M2TOT
Z3_FILIAL = '09' AND 
Z3_PLANO IN ('369B 32-02C/16') AND 
D_E_L_E_T_ = ''  

UPDATE SZ7010 SET D_E_L_E_T_ = '*'
WHERE
Z7_FILIAL = '09' AND
Z7_PLANO IN ('369B 32-02C/16') AND 
D_E_L_E_T_ = ''
*/

If nOpc == 1

	cQuery := " SELECT SZ3.Z3_PLANO, SZ3.Z3_NUMFC, SZ3.Z3_PRODUTO, SZ3.Z3_MATERIA, SZ3.Z3_NUMOP "
	cQuery += "  FROM "+RetSqlName("SZ3")+" SZ3 " "
	cQuery += "  JOIN "+RetSqlName("SC2")+" SC2 ON SC2.C2_FILIAL  = '"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_ = ' ' AND SC2.C2_NUM = SZ3.Z3_NUMOP "
	cQuery += " WHERE SZ3.Z3_FILIAL  = '"+xFilial("SZ3")+"' "
	cQuery += "   AND SZ3.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SZ3.Z3_PLANO = '" + cCodPlano + "' "
	cQuery += "   AND SC2.C2_QUJE <> 0 "
	cQuery += " ORDER BY SZ3.Z3_PLANO "
	cQuery := ChangeQuery( cQuery )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSql2,.f.,.t.)
	dbGoTop()

	If (cAliasSql2)->(Eof())

		cQuery := "SELECT SZ3.Z3_PLANO, SZ3.Z3_NUMFC, SZ3.Z3_PRODUTO, SZ3.Z3_MATERIA, SZ3.Z3_NUMOP, SZ3.Z3_M2TOT, SZ3.Z3_ITEM, SZ3.Z3_SEQUEN "
		cQuery += "  FROM "+RetSqlName("SZ3")+" SZ3 "
		cQuery += " WHERE SZ3.Z3_FILIAL  = '"+xFilial("SZ3")+"' "
		cQuery += "   AND SZ3.D_E_L_E_T_ = ' ' "
		cQuery += "   AND SZ3.Z3_PLANO   = '" + cCodPlano + "' "
		cQuery += " ORDER BY SZ3.Z3_PLANO "
		cQuery := ChangeQuery( cQuery )
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSql,.f.,.t.)
		dbGoTop()
	
		If !(cAliasSql)->(Eof())
			While !(cAliasSql)->(Eof())

//				dbSelectArea("SZ3")                          //ESTAVA O INDICE 4, MAS EXISTEM ITENS QUE SรO IGUAIS E NรO ENCONTRAVA O PROXIMO
//				dbSetOrder(4)                                //ALTERADO PARA INDICE 5, POIS TERม O CAMPO Z3_SEQUEN QUE DIFERENCIARม DOS DEMAIS - ANTONIO 15/01/19
//				If dbSeek(xFilial("SZ3")+(cAliasSql)->Z3_NUMFC+(cAliasSql)->Z3_PRODUTO)

				dbSelectArea("SZ3")
				dbSetOrder(5)
				If dbSeek(xFilial("SZ3")+(cAliasSql)->Z3_NUMFC+(cAliasSql)->Z3_NUMOP+(cAliasSql)->Z3_ITEM+(cAliasSql)->Z3_SEQUEN+(cAliasSql)->Z3_PRODUTO)
					//Se Z3_OPAPONT = 'S' , emitir mensagem para usuแrio estornar as OPs e nใo deixar estornar.
					Reclock("SZ3",.F.)
					SZ3->Z3_SALDO   := SZ3->Z3_QTDE
					SZ3->Z3_M2TOT   := (SZ3->Z3_QTDE * SZ3->Z3_M2PAD)
					SZ3->Z3_STATUS  := 'A'
					SZ3->Z3_DTAPON  := CtoD("//")
					SZ3->Z3_USUAPON := " "
					SZ3->Z3_HRAPON  := " "  
					SZ3->Z3_OPAPONT := "N"  
					SZ3->Z3_SLDM2   := SZ3->Z3_M2TOT
					MsUnlock()
				EndIf

				dbSelectArea("SD4")
				dbSetOrder(2)
		   		If dbSeek(xFilial("SD4")+AllTrim((cAliasSql)->Z3_NUMOP)+'01001'+(cAliasSql)->Z3_MATERIA )
					Reclock("SD4",.F.)
					SD4->D4_QTDEORI := (cAliasSql)->Z3_M2TOT
					SD4->D4_QUANT   := (cAliasSql)->Z3_M2TOT
					MsUnlock()
	            EndIf


				(cAliasSql)->(dbSkip())
	
				lRet:=.T.
	
			Enddo
	
			If lRet
	
				cQuery := "SELECT SZ7.Z7_PLANO, SZ7.Z7_NUMFC, SZ7.Z7_FASE "
				cQuery += "  FROM "+RetSqlName("SZ7")+" SZ7 "
				cQuery += " WHERE SZ7.Z7_FILIAL  = '"+xFilial("SZ7")+"' "
				cQuery += "   AND SZ7.D_E_L_E_T_ = ' ' "
				cQuery += "   AND SZ7.Z7_PLANO   = '" + cCodPlano + "' "
				cQuery += " ORDER BY SZ7.Z7_PLANO "
				cQuery := ChangeQuery( cQuery )
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSql1,.f.,.t.)
				dbGoTop()
	
				If !(cAliasSql1)->(Eof())
					While !(cAliasSql1)->(Eof())
					
						dbSelectArea("SZ7")
						dbSetOrder(1)
						If dbSeek(xFilial("SZ7")+(cAliasSql1)->Z7_NUMFC+(cAliasSql1)->Z7_FASE)
							Reclock("SZ7",.F.)
							dbDelete()	
							MsUnlock()
						EndIf
				
						(cAliasSql1)->(dbSkip())
					Enddo
	
					(cAliasSql1)->(dbCloseArea())
	
				EndIf
		
				Alert("Plano estornado com sucesso!!!")
				(cAliasSql)->(dbCloseArea())
	                	
			EndIf

		EndIf

	Else
		Alert("Por Favor, Estorne primeiro as OPs para executar esta opera็ใo !!!")
	EndIf

	(cAliasSql2)->(dbCloseArea())

EndIf

Return  



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//ROTINA PARA ESTORNO DA FICHA DE PRODUวรO
//ANTONIO 25/08/16
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function FS_ESTF01()
//Alert('Clique em ESTORNO DA FICHA DE PRODUวรO')

Local cQuery     := ""
Local cAliasSql  := GetNextAlias()
Local cAliasSql1 := GetNextAlias()
Local cAliasSql2 := GetNextAlias()
Local cCodFicha	 := Space(16)
Local oCodFicha
Local lRet       := .F.

Private oDlg
Private nOpc

//Monta interface com o usuแrio
//DEFINE MSDIALOG oDlg TITLE "Altera็ใo de Campos do Plano de Produ็ใo" FROM C(164),C(182) TO C(325),C(409) PIXEL
DEFINE MSDIALOG oDlg TITLE "Estorno da Ficha de Produ็ใo" FROM C(010),C(010) TO C(325),C(409) PIXEL

// Cria as Groups do Sistema
@ C(003),C(003) TO C(160),C(260) LABEL "Informe a Ficha a Estornar" PIXEL OF oDlg

// Cria Componentes Padroes do Sistema
@ C(013),C(008) Say "Cod Ficha:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(013),C(050) MsGet oCodFicha Var cCodFicha Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg //VALID FS_XPLANO(cCodFicha)

oTBrowseButton := TBrowseButton():New( 180,145,'Confirmar',oDlg,{||nOpc := 1,oDlg:End() },50,10,,,.F.,.T.,.F.,,.F.,,,)
oTBrowseButton1 := TBrowseButton():New( 180,200,'Fechar',oDlg,{||oDlg:End() },50,10,,,.F.,.T.,.F.,,.F.,,,)

ACTIVATE MSDIALOG oDlg CENTERED

//####### RESET NOS CAMPOS DA TABELA SZ3 PARA UMA FICHA ESPECอFICA #######
//************* ESTORNO DA FICHA  ********************
//UPDATE SZ3010 SET Z3_SALDO = Z3_QTDE, Z3_M2TOT = (Z3_QTDE * Z3_M2PAD), Z3_STATUS = 'A', Z3_DTAPON = '',Z3_USUAPON = '', Z3_HRAPON = '', Z3_OPAPONT = 'N' 
//WHERE
//Z3_FILIAL = '09' AND 
//Z3_NUMFC IN ('A021840029581001') AND 
//D_E_L_E_T_ = ''  
//
//####### RESET NO SALDO EM M2 DAS FICHAS #######
//UPDATE SZ3010 SET Z3_SLDM2 = Z3_M2TOT
//Z3_FILIAL = '09' AND 
//Z3_NUMFC IN ('A021840029581001') AND 
//D_E_L_E_T_ = ''  

//UPDATE SZ7010 SET D_E_L_E_T_ = '*'
//WHERE
//Z7_FILIAL = '09' AND
//Z7_NUMFC IN ('A021840029581001') AND 
//D_E_L_E_T_ = '' 

If nOpc == 1

	cQuery := " SELECT SZ3.Z3_PLANO, SZ3.Z3_NUMFC, SZ3.Z3_PRODUTO, SZ3.Z3_MATERIA, SZ3.Z3_NUMOP "
	cQuery += "  FROM "+RetSqlName("SZ3")+" SZ3 " "
	cQuery += "  JOIN "+RetSqlName("SC2")+" SC2 ON SC2.C2_FILIAL  = '"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_ = ' ' AND SC2.C2_NUM = SZ3.Z3_NUMOP "
	cQuery += " WHERE SZ3.Z3_FILIAL  = '"+xFilial("SZ3")+"' "
	cQuery += "   AND SZ3.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SZ3.Z3_NUMFC = '" + cCodFicha + "' "
	cQuery += "   AND SC2.C2_QUJE <> 0 "
	cQuery += " ORDER BY SZ3.Z3_NUMFC "
	cQuery := ChangeQuery( cQuery )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSql2,.f.,.t.)
	dbGoTop()

	If (cAliasSql2)->(Eof())

		cQuery := "SELECT SZ3.Z3_PLANO, SZ3.Z3_NUMFC, SZ3.Z3_PRODUTO, SZ3.Z3_MATERIA, SZ3.Z3_NUMOP, SZ3.Z3_M2TOT, SZ3.Z3_ITEM, SZ3.Z3_SEQUEN "
		cQuery += "  FROM "+RetSqlName("SZ3")+" SZ3 "
		cQuery += " WHERE SZ3.Z3_FILIAL  = '"+xFilial("SZ3")+"' "
		cQuery += "   AND SZ3.D_E_L_E_T_ = ' ' "
		cQuery += "   AND SZ3.Z3_NUMFC   = '" + cCodFicha + "' "
		cQuery += " ORDER BY SZ3.Z3_NUMFC "
		cQuery := ChangeQuery( cQuery )
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSql,.f.,.t.)
		dbGoTop()

		While !(cAliasSql)->(Eof())

	//		@ C(033),C(008) Say "Plano      Produto           Materia" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	//		@ C(053),C(008) Say (cAliasSql)->Z3_PLANO+" "+(cAliasSql)->Z3_PRODUTO+" "+(cAliasSql)->Z3_MATERIA Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg


//			dbSelectArea("SZ3")                          //ESTAVA O INDICE 4, MAS EXISTEM ITENS QUE SรO IGUAIS E NรO ENCONTRAVA O PROXIMO
//			dbSetOrder(4)                                //ALTERADO PARA INDICE 5, POIS TERม O CAMPO Z3_SEQUEN QUE DIFERENCIARม DOS DEMAIS - ANTONIO 15/01/19
//			If dbSeek(xFilial("SZ3")+(cAliasSql)->Z3_NUMFC+(cAliasSql)->Z3_PRODUTO)

			dbSelectArea("SZ3")
			dbSetOrder(5)
			If dbSeek(xFilial("SZ3")+(cAliasSql)->Z3_NUMFC+(cAliasSql)->Z3_NUMOP+(cAliasSql)->Z3_ITEM+(cAliasSql)->Z3_SEQUEN+(cAliasSql)->Z3_PRODUTO)
				Reclock("SZ3",.F.)
				SZ3->Z3_SALDO  := SZ3->Z3_QTDE
				SZ3->Z3_M2TOT  := (SZ3->Z3_QTDE * SZ3->Z3_M2PAD)
				SZ3->Z3_STATUS  := 'A'
				SZ3->Z3_DTAPON  := CtoD("//")
				SZ3->Z3_USUAPON := " "
				SZ3->Z3_HRAPON  := " "  
				SZ3->Z3_OPAPONT := "N"  
				SZ3->Z3_SLDM2   := SZ3->Z3_M2TOT
				MsUnlock()
			EndIf

			dbSelectArea("SD4")
			dbSetOrder(2)
	   		If dbSeek(xFilial("SD4")+AllTrim((cAliasSql)->Z3_NUMOP)+'01001'+(cAliasSql)->Z3_MATERIA )
				Reclock("SD4",.F.)
				SD4->D4_QTDEORI := (cAliasSql)->Z3_M2TOT
				SD4->D4_QUANT   := (cAliasSql)->Z3_M2TOT
				MsUnlock()
            EndIf
	            
			(cAliasSql)->(dbSkip())

			lRet:=.T.

		Enddo

		If lRet

			cQuery := "SELECT SZ7.Z7_PLANO, SZ7.Z7_NUMFC, SZ7.Z7_FASE "
			cQuery += "  FROM "+RetSqlName("SZ7")+" SZ7 "
			cQuery += " WHERE SZ7.Z7_FILIAL   = '"+xFilial("SZ7")+"' "
			cQuery += "   AND SZ7.D_E_L_E_T_  = ' ' "
			cQuery += "   AND SZ7.Z7_NUMFC = '" + cCodFicha + "' "
			cQuery += " ORDER BY SZ7.Z7_NUMFC "
			cQuery := ChangeQuery( cQuery )
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSql1,.f.,.t.)
			dbGoTop()

			If !(cAliasSql1)->(Eof())
				While !(cAliasSql1)->(Eof())
				
					dbSelectArea("SZ7")
					dbSetOrder(1)
					If dbSeek(xFilial("SZ7")+(cAliasSql1)->Z7_NUMFC+(cAliasSql1)->Z7_FASE)
						Reclock("SZ7",.F.)
						dbDelete()	
						MsUnlock()
					EndIf
			
					(cAliasSql1)->(dbSkip())
				Enddo

			EndIf	
  
			(cAliasSql1)->(dbCloseArea())

		EndIf

		(cAliasSql)->(dbCloseArea())
		
		Alert("Ficha estornada com sucesso!!!")

	Else

		Alert("Por Favor, Estorne primeiro as OPs para executar esta opera็ใo !!!")

	EndIf

	(cAliasSql2)->(dbCloseArea())

EndIf

Return  


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//ROTINA PARA DESBLOQUEAR PLANO DE PRODUวรO
//ANTONIO 25/08/16
//Campo ZP_OPGERAD=G (Alterar o campo  ZP_OPGERAD = N e ZP_OPSOK = ' '
//OBS.: Somente os planos que tiverem com o campo ZP_OPGERAD=G
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function FS_ESTD01()
//Alert('Clique em DESBLOQUEAR PLANO')

Local cCodPlano	 := Space(20)
Local oCodPlano

Private oDlg
Private nOpc

//Monta interface com o usuแrio
//DEFINE MSDIALOG oDlg TITLE "Altera็ใo de Campos do Plano de Produ็ใo" FROM C(164),C(182) TO C(325),C(409) PIXEL
DEFINE MSDIALOG oDlg TITLE "Desbloquear Plano de Produ็ใo" FROM C(010),C(010) TO C(325),C(409) PIXEL

// Cria as Groups do Sistema
@ C(003),C(003) TO C(160),C(260) LABEL "Informe o Plano a Desbloquear" PIXEL OF oDlg

// Cria Componentes Padroes do Sistema
@ C(013),C(008) Say "Cod Plano:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(013),C(050) MsGet oCodPlano Var cCodPlano Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg VALID FS_XPLANO(cCodPlano,"DP")

oTBrowseButton := TBrowseButton():New( 180,145,'Confirmar',oDlg,{||nOpc := 1,oDlg:End() },50,10,,,.F.,.T.,.F.,,.F.,,,)
oTBrowseButton1 := TBrowseButton():New( 180,200,'Fechar',oDlg,{||oDlg:End() },50,10,,,.F.,.T.,.F.,,.F.,,,)

ACTIVATE MSDIALOG oDlg CENTERED

If nOpc == 1
	dbSelectArea("SZP")
	dbSetOrder(2)
	If dbSeek(xFilial("SZP")+cCodPlano)

//Campo ZP_OPGERAD=G (Alterar o campo  ZP_OPGERAD = N e ZP_OPSOK = ' '
//OBS.: Somente os planos que tiverem com o campo ZP_OPGERAD=G
		If AllTrim(SZP->ZP_OPGERAD) == 'G'
			Reclock("SZP",.F.)
			SZP->ZP_OPGERAD := 'N'
			SZP->ZP_OPSOK   := " "
			MsUnlock()

			If SZP->ZP_PLNPARC == 'S'
		
				If dbSeek(xFilial("SZH")+cCodPlano)
					dbSelectArea("SZH")
					dbSetOrder(1)
					If dbSeek(xFilial("SZH")+cCodPlano)
						While !Eof() .And. xFilial("SZH") == SZH->ZH_FILIAL .And. SZH->ZH_PLANO == cCodPlano		
							Reclock("SZH",.F.)
							SZH->ZH_STATUS  := 'N'
							MsUnlock()
							SZH->(dbSkip())
						EndDo
					EndIf
				EndIf
	
			EndIf
	
			Alert('PLANO Desbloqueado com SUCESSO!!!')
		Else
			Alert("Este Plano nใo estแ bloqueado !!!")

		EndIf

	EndIf

EndIf

Return  
 

//ALTERAR PLANO
//Somente os campos do cliente /loja /nome do cliente/ centro custo/Armazem/Release 
//(id้ia de trazer uma tela tipo axcadastro com os campos para o usuแrio alterar o que necessitar.
//Tabelas SZP e SC2
//Verificar se o Plano ้ Parcial  (Campo ZP_PLNPARC=S, alterar na tabela SZH)
//*Incluir query  (Alterar o campo ZH_STATUS de 'G' para 'N')
Static Function FS_ESTA01()

Local cCodPlano	 := Space(20)
Local oCodPlano
Local oCodCli
Local oCodLoja
Local oNomeCli
Local oCodLocal
Local oCodCC
Local oRelease
Local oMultiplo

Private cCodCli   := Space(06)
Private cCodLoja  := Space(02)
Private cNomeCli  := Space(40)
Private cCodLocal := Space(02)
Private cCodCC    := Space(09)  
Private cRelease  := Space(20)
Private nMultiplo := 0
Private oDlg
Private nOpc

//If Empty(cCodPlano)
//	Alert('Clique em ALTERAR PLANO')
//	Return
//EndIf

//Monta interface com o usuแrio
//DEFINE MSDIALOG oDlg TITLE "Altera็ใo de Campos do Plano de Produ็ใo" FROM C(164),C(182) TO C(325),C(409) PIXEL
DEFINE MSDIALOG oDlg TITLE "Altera็ใo de Campos do Plano de Produ็ใo" FROM C(010),C(010) TO C(425),C(509) PIXEL

// Cria as Groups do Sistema
@ C(003),C(003) TO C(260),C(360) LABEL "Informe os campos a serem alterados" PIXEL OF oDlg

// Cria Componentes Padroes do Sistema
@ C(013),C(008) Say "Cod Plano:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
If Empty(cCodPlano)
	@ C(013),C(050) MsGet oCodPlano Var cCodPlano Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg VALID FS_XPLANO(cCodPlano,'AP')
EndIf                              

@ C(033),C(008) Say "Cod Cliente:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(033),C(050) MsGet oCodCli Var cCodCli F3 'SA1' Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg

@ C(053),C(008) Say "Loja Cliente:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(053),C(050) MsGet oCodLoja Var cCodLoja Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg VALID FS_XCli(cCodCli+cCodLoja)

@ C(073),C(008) Say "Nome Cliente:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(073),C(050) MsGet oNomeCli Var cNomeCli WHEN .F. Size C(141),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg

@ C(093),C(008) Say "Centro Custo:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(093),C(050) MsGet oCodCC Var cCodCC F3 'CTT' Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg

@ C(113),C(008) Say "Armaz้m:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(113),C(050) MsGet oCodLocal Var cCodLocal Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg Valid FS_XLoc(cCodLocal)

@ C(133),C(008) Say "Release:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(133),C(050) MsGet oRelease Var cRelease Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg

@ C(153),C(008) Say "Multiplo:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(153),C(050) MsGet oMultiplo Var nMultiplo Size C(041),C(009) COLOR CLR_BLACK Picture "99999" PIXEL OF oDlg

//DEFINE SBUTTON FROM C(128),C(046) TYPE 1 ENABLE OF oDlg ACTION {||nOpc := 1,oDlg:End()}

oTBrowseButton := TBrowseButton():New( 250,145,'Confirmar',oDlg,{||nOpc := 1,oDlg:End() },50,10,,,.F.,.T.,.F.,,.F.,,,)
oTBrowseButton1 := TBrowseButton():New( 250,200,'Fechar',oDlg,{||oDlg:End() },50,10,,,.F.,.T.,.F.,,.F.,,,)

ACTIVATE MSDIALOG oDlg CENTERED

If nOpc == 1
	//Tabelas SZP e SC2
	//Verificar se o Plano ้ Parcial  (Campo ZP_PLNPARC=S, alterar na tabela SZH)

	dbSelectArea("SZP")
	dbSetOrder(2)
	If dbSeek(xFilial("SZP")+cCodPlano)
		Reclock("SZP",.F.)
		SZP->ZP_CLIENTE := cCodCli
		SZP->ZP_LOJA    := cCodLoja
		SZP->ZP_NOMCLIE := cNomeCli
		SZP->ZP_LOCAL   := cCodLocal
		SZP->ZP_CC      := cCodCC
		SZP->ZP_RELEASE := cRelease
		SZP->ZP_MULTPLO := nMultiplo
		MsUnlock()
	EndIf

	dbSelectArea("SC2")
	dbSetOrder(12)
	If dbSeek(xFilial("SC2")+cCodPlano)

		While !Eof() .And. SC2->C2_OPMIDO == cCodPlano

			If SC2->C2_OPMIDO == cCodPlano
				Reclock("SC2",.F.)
				SC2->C2_CLIENTE := cCodCli
				SC2->C2_LOJA    := cCodLoja
				SC2->C2_LOCAL   := cCodLocal
				SC2->C2_CC      := cCodCC
				SC2->C2_RELEASE := cRelease 
				SC2->C2_QTDLOTE := nMultiplo
				MsUnlock()
			EndIf

			dbSkip()

		EndDo

		Alert('PLANO ALTERADO COM SUCESSO!!!')

	EndIf

Else
	Alert("Processamento cancelado pelo usuแrio")
EndIf

Return(.T.)  
                                 
                                 
/////////////////////////////////////////////////
//Verifica se plano exist
//Antonio
/////////////////////////////////////////////////
Static Function FS_XPLANO(cCodPlano,cParam)

	Local lRet:=.T.

	dbSelectArea("SZP")
	dbSetOrder(2)
	If dbSeek(xFilial("SZP")+cCodPlano)

		If !Empty(cCodPlano)
			@ C(013),C(050) MsGet oCodPlano Var cCodPlano Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg WHEN .F.
	
			If cParam == 'AP' .And. nOPC <> 1
				cCodCli   := SZP->ZP_CLIENTE
				cCodLoja  := SZP->ZP_LOJA
				cNomeCli  := SZP->ZP_NOMCLIE
				cCodLocal := SZP->ZP_LOCAL
				cCodCC	  := SZP->ZP_CC
				cRelease  := SZP->ZP_RELEASE
				nMultiplo := SZP->ZP_MULTPLO
			EndIf

		EndIf
	Else
		Alert('PLANO NรO CADASTRADO!!')
		lRet:=.F.
	EndIf
		
Return(lRet) 


/////////////////////////////////////////////////
//Verifica se Cliente existe
//Antonio
/////////////////////////////////////////////////
Static Function FS_XCli(cCodCli)

	Local lRet:=.T.

	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek(xFilial("SA1")+cCodCli)
		cNomeCli :=Posicione("SA1",1,xFilial("SA1")+cCodCli,"A1_NOME")
	Else
		Alert('CLIENTE NรO CADASTRADO!!')
		lRet:=.F.
	EndIf
		
Return(lRet)
             


/////////////////////////////////////////////////
//Verifica se Armazem existe no parametro
//Antonio
/////////////////////////////////////////////////
Static Function FS_XLoc(cCodLocal)

	Local lRet    :=.T.
	Local _cTexto := 'Movimenta็ใo Nใo Permitida No(s) Armazem(s) -> '+ GetMv('MA_ARMAZEM') + chr(13) + chr(13)
                                                                                                                  
	If !cCodLocal $ GetMV('MA_ARMAZEM')
		lRet:=.T.
	Else                                         
	
		Help("Digite um Armazem Vแlido para continuar!!! ",1,"HELP","MA_ARMAZEM",_cTexto,1,0)
		lRet:=.F.
	EndIf

Return(lRet)
