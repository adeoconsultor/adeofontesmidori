#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.ch"

//////////////////////////////////////////////////////////////////////////////////
//Ponto de entrada chamado no menu outras acoes fonte GFEA044 - Documento de Carga
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por antonio - 20-08-2018
///////////////////////////////////////////////////////////////////////////////

User Function GFEA0442()
 
    Local aRotina
    // Posições do Array
    // 1. Nome da opção no menu   
    // 2. Nome da Rotina associada                                
    // 3. Usado pela rotina                                       
    // 4. Tipo de Operação a ser efetuada
     
    aRotina := { {"Classif. CTE x NFE", "U_GFEA044Z(.F.)", 0, 4} }
 
Return aRotina



//Atualização dos campos do GFE - antonio 16/08/18
User Function GFEA044Z()
//User Function UGFEGRV(cxF1_DOC,cxF1_SERIE,cxF1_FORNECE,cxF1_LOJA)

	//CONSIDERAR CFOP(S) DE CUSTO/DESPESA
	Local cNFOPGFE := SuperGetMV("MV_NFOPGFE",.F.,'1101,1122,1406,1551,1902,1925,2101,2122,2406,2551,2902,2925,3101,3127,3551,1401,1653,2501,1501,2501') //CFOPS CUSTO
	//CONSIDERAR CFOP(S) DE CUSTO/DESPESA
	Local cValorCU := 0
	Local cValorDE := 0

/*	cxF1_DOC      := '000000087' //'000000183'
	cxF1_SERIE    := '1   '      //'1  '
	cxF1_FORNECE  := '005533'    //'006294'
	cxF1_LOJA     := '01'        //'01'
 */ 

	Local cxF1_DOC      := GW1->GW1_NRDC
	Local cxF1_SERIE    := GW1->GW1_SERDC
	Local cChaveNFE     := GW1->GW1_DANFE
	Local cGW1_CDTPDC   := ''

	cQuery := "SELECT SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_CF, SD1.D1_TOTAL, SF1.F1_CHVNFE "
	cQuery += "  FROM "+RetSqlName("SD1")+" SD1 "
	cQuery += "    JOIN "+RetSqlName("SF1")+" SF1 ON SD1.D1_DOC = SF1.F1_DOC AND SD1.D1_SERIE = SF1.F1_SERIE AND "
	cQuery += "                       SD1.D1_FORNECE=SF1.F1_FORNECE AND SD1.D1_LOJA = SF1.F1_LOJA AND "
	cQuery += "                       SF1.F1_FILIAL  = '"+xFilial("SF1")+"' AND SF1.D_E_L_E_T_ = ' ' AND"
	cQuery += "                       SF1.F1_CHVNFE  = '" + cChaveNFE + "' "
	cQuery += " WHERE SD1.D1_FILIAL  = '"+xFilial("SD1")+"' "
	cQuery += "   AND SD1.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SD1.D1_DOC     = '" + cxF1_DOC     + "' "
	cQuery += "   AND SD1.D1_SERIE   = '" + cxF1_SERIE   + "' "
//	cQuery += "   AND SD1.D1_FORNECE = '" + cxF1_FORNECE + "' "
//	cQuery += "   AND SD1.D1_LOJA    = '" + cxF1_LOJA    + "' "
//	cQuery += "   AND SD1.D1_CF      NOT IN ( " + cNFOPGFE   + ") "
	cQuery += " ORDER BY SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_FORNECE, SD1.D1_LOJA
//	cQuery := ChangeQuery( cQuery )

	If Select ('cAliasSql') > 0
		DbSelectArea('cAliasSql')
		DbCloseArea()
	EndIf

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'cAliasSql',.f.,.t.)

	dbGoTop()
	
	While !cAliasSql->(Eof())
		cChaveNFE:=cAliasSql->F1_CHVNFE 
		If AllTrim(cAliasSql->D1_CF) $ cNFOPGFE                  //CUSTO
			cValorCU := cAliasSql->D1_TOTAL
		Else                                                     //DESPESAS
			cValorDE := cAliasSql->D1_TOTAL
		EndIf

		cAliasSql->(dbSkip())
	
	EndDo

	If Empty(cChaveNFE)
		MsgAlert("Chave NFE não informada! NFE não classificada!!! ")
		Return
	EndIf

	If cValorDE == 0                //O SISTEMA JA GRAVA COMO NFE, NESTE CASO NÃO SERÁ TRATADO

/*
		dbSelectArea("GW1")
		dbSetOrder(12)
		If dbSeek( cChaveNFE )
			Reclock("GW1",.F.)
			GW1->GW1_CDTPDC := 'NFE'
			MsUnlock()
		EndIf
//CASO SEJA ALTERADO DE NFE PARA XXX, INCLUIR O TRECHO ABAIXO DO GW8, ALTERANDO SO NO FINAL O RECLOCK O GW8->GW8_CDTPDC := 'NFE'


*/
	EndIf

	If cValorCU == 0                //TODOS OS ITENS ESTÃO SOMENTE COM DESPESAS, SERA GRAVADO COMO 'NFED'

		dbSelectArea("GW1")
		dbSetOrder(1)
		If dbSeek(xFilial("GW1")+GW1->GW1_CDTPDC+GW1->GW1_EMISDC+GW1->GW1_SERDC+GW1->GW1_NRDC)
			cGW1_CDTPDC := GW1->GW1_CDTPDC
			If Reclock("GW1",.F.)
				GW1->GW1_CDTPDC := 'NFED'
				GW1->(MsUnlock())
//				msgalert("executei")
			EndIf
		EndIf

		cQuery := "SELECT GW8.GW8_CDTPDC, GW8.GW8_EMISDC, GW8.GW8_NRDC, GW8.GW8_SERDC, GW8.GW8_SEQ, GW8.GW8_ITEM, GW8.GW8_CFOP, GW8.GW8_VALOR "
		cQuery += "  FROM "+RetSqlName("GW8")+" GW8 "
		cQuery += "    JOIN "+RetSqlName("GW1")+" GW1 ON GW8.GW8_NRDC   = GW1.GW1_NRDC     AND  GW8.GW8_SERDC = GW1.GW1_SERDC AND "
		cQuery += "                                      GW8.GW8_EMISDC = GW1.GW1_EMISDC   AND "
		cQuery += "                                      GW1.GW1_FILIAL = '"+xFilial("GW1")+"' AND GW1.D_E_L_E_T_ = ' '  AND "
		cQuery += "                                      GW1.GW1_DANFE  = '" + cChaveNFE + "' "
		cQuery += " WHERE GW8.GW8_FILIAL  = '"+xFilial("GW8")+"' "
		cQuery += "   AND GW8.D_E_L_E_T_ = ' ' "
		cQuery += "   AND GW8.GW8_NRDC   = '" + cxF1_DOC    + "' "
		cQuery += "   AND GW8.GW8_SERDC  = '" + cxF1_SERIE  + "' "
	cQuery += " ORDER BY GW8.GW8_CDTPDC, GW8.GW8_EMISDC, GW8.GW8_SERDC, GW8.GW8_NRDC, GW8.GW8_ITEM "
//		cQuery := ChangeQuery( cQuery )

		If Select ('cAliasSql1') > 0
			DbSelectArea('cAliasSql1')
			DbCloseArea()
		EndIf

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'cAliasSql1',.f.,.t.)
		dbGoTop()

		While cAliasSql1->(!Eof())

			dbSelectArea("GW8")
			dbSetOrder(2)
			If dbSeek(xFilial("GW8")+cAliasSql1->GW8_CDTPDC + cAliasSql1->GW8_EMISDC + cAliasSql1->GW8_SERDC + cAliasSql1->GW8_NRDC + cAliasSql1->GW8_SEQ )
				Reclock("GW8",.F.)
				GW8->GW8_CDTPDC := 'NFED'
				MsUnlock()
			EndIf

			cAliasSql1->(dbSkip())
   		EndDo


			cQuery := "SELECT GWU.GWU_CDTPDC, GWU.GWU_EMISDC, GWU.GWU_NRDC, GWU.GWU_SERDC, GWU.R_E_C_N_O_ GWURECNO "
			cQuery += "  FROM "+RetSqlName("GWU")+" GWU "
			cQuery += " WHERE GWU.GWU_FILIAL  = '"+xFilial("GWU")+"' "
			cQuery += "   AND GWU.D_E_L_E_T_  = ' ' "
			cQuery += "   AND GWU.GWU_NRDC    = '" + cxF1_DOC   + "' "
			cQuery += "   AND GWU.GWU_SERDC   = '" + cxF1_SERIE + "' "
			cQuery += "   AND GWU.GWU_CDTPDC  = 'NFE' "
			cQuery += " ORDER BY GWU.GWU_NRDC, GWU.GWU_SERDC "
 //			cQuery := ChangeQuery( cQuery )

			If Select ('cAliasSql3') > 0
				DbSelectArea('cAliasSql3')
				DbCloseArea()
			EndIf

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'cAliasSql3',.f.,.t.)
			dbGoTop()
                                         
			While cAliasSql3->(!Eof())

				DbGoTo( cAliasSql3->GWURECNO  ) // Posicionando o GWU de acordo com o RECNO

				If Reclock("GWU",.F.)
					GWU->GWU_CDTPDC := 'NFED'
					MsUnlock()
				EndIf

				cAliasSql3->(dbSkip())
	   		EndDo
/*

		dbSelectArea("GWU")
		dbSetOrder(1)
		If dbSeek(xFilial("GWU")+cGW1_CDTPDC + GW1->GW1_EMISDC + GW1->GW1_SERDC + GW1->GW1_NRDC )
			While !Eof() .And. ( GWU->GWU_EMISDC == GW1->GW1_EMISDC .And. GWU->GWU_NRDC == GW1->GW1_NRDC .And. GWU->GWU_SERDC == GW1->GW1_SERDC) 
	
				Reclock("GWU",.F.)
				GWU->GWU_CDTPDC := 'NFED'
				MsUnlock()
	
				dbSkip()

	   		EndDo

		EndIf

//		cAliasSql1->(dbCloseArea())
  */

	EndIf
  
  
	If cValorCU > 0 .And. cValorDE > 0       //NESTE CASO TEMOS CUSTO E DESPESA

		If cValorDE > cValorCU               //CASO A DESPESA SEJA MAIOR QUE O CUSTO GRAVARA 'NFED'
		
			dbSelectArea("GW1")
			dbSetOrder(12)
			If dbSeek( cChaveNFE )
				cGW1_CDTPDC := GW1->GW1_CDTPDC
				Reclock("GW1",.F.)
				GW1->GW1_CDTPDC := 'NFED'
				MsUnlock()
			EndIf

			cQuery := "SELECT GW8.GW8_CDTPDC, GW8.GW8_EMISDC, GW8.GW8_NRDC, GW8.GW8_SERDC, GW8.GW8_SEQ, GW8.GW8_ITEM, GW8.GW8_CFOP, GW8.GW8_VALOR "
			cQuery += "  FROM "+RetSqlName("GW8")+" GW8 "
			cQuery += "    JOIN "+RetSqlName("GW1")+" GW1 ON GW8.GW8_NRDC   = GW1.GW1_NRDC     AND  GW8.GW8_SERDC = GW1.GW1_SERDC AND "
			cQuery += "                                      GW8.GW8_EMISDC = GW1.GW1_EMISDC   AND "
			cQuery += "                                      GW1.GW1_FILIAL = '"+xFilial("GW1")+"' AND GW1.D_E_L_E_T_ = ' ' AND "
			cQuery += "                                      GW1.GW1_DANFE  = '" + cChaveNFE + "' "
			cQuery += " WHERE GW8.GW8_FILIAL  = '"+xFilial("GW8")+"' "
			cQuery += "   AND GW8.D_E_L_E_T_ = ' ' "
			cQuery += "   AND GW8.GW8_NRDC   = '" + cxF1_DOC   + "' "
			cQuery += "   AND GW8.GW8_SERDC  = '" + cxF1_SERIE + "' "
			cQuery += " ORDER BY GW8.GW8_CDTPDC, GW8.GW8_EMISDC, GW8.GW8_SERDC, GW8.GW8_NRDC, GW8.GW8_ITEM "
 //			cQuery := ChangeQuery( cQuery )

			If Select ('cAliasSql2') > 0
				DbSelectArea('cAliasSql2')
				DbCloseArea()
			EndIf

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'cAliasSql2',.f.,.t.)
			dbGoTop()
	
			While cAliasSql2->(!Eof())
	
				dbSelectArea("GW8")
				dbSetOrder(2)
				If dbSeek(xFilial("GW8")+cAliasSql2->GW8_CDTPDC + cAliasSql2->GW8_EMISDC + cAliasSql2->GW8_SERDC + cAliasSql2->GW8_NRDC + cAliasSql2->GW8_SEQ)
					Reclock("GW8",.F.)
					GW8->GW8_CDTPDC := 'NFED'
					MsUnlock()
				EndIf
	
				cAliasSql2->(dbSkip())
	   		EndDo


			cQuery := "SELECT GWU.GWU_CDTPDC, GWU.GWU_EMISDC, GWU.GWU_NRDC, GWU.GWU_SERDC, GWU.R_E_C_N_O_ GWURECNO "
			cQuery += "  FROM "+RetSqlName("GWU")+" GWU "
			cQuery += " WHERE GWU.GWU_FILIAL  = '"+xFilial("GWU")+"' "
			cQuery += "   AND GWU.D_E_L_E_T_  = ' ' "
			cQuery += "   AND GWU.GWU_NRDC    = '" + cxF1_DOC   + "' "
			cQuery += "   AND GWU.GWU_SERDC   = '" + cxF1_SERIE + "' "
			cQuery += "   AND GWU.GWU_CDTPDC  = 'NFE' "
			cQuery += " ORDER BY GWU.GWU_NRDC, GWU.GWU_SERDC "
 //			cQuery := ChangeQuery( cQuery )

			If Select ('cAliasSql3') > 0
				DbSelectArea('cAliasSql3')
				DbCloseArea()
			EndIf

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'cAliasSql3',.f.,.t.)

                                         
			While cAliasSql3->(!Eof())

				DbGoTo( cAliasSql3->GWURECNO  ) // Posicionando o GWU de acordo com o RECNO

				If Reclock("GWU",.F.)
					GWU->GWU_CDTPDC := 'NFED'
					MsUnlock()
				EndIf

				cAliasSql3->(dbSkip())
	   		EndDo


/*			dbSelectArea("GWU")
			dbSetOrder(1)
			If dbSeek(xFilial("GWU")+cGW1_CDTPDC + GW1->GW1_EMISDC + GW1->GW1_SERDC + GW1->GW1_NRDC )
					                                                                                                                                            
				While !Eof() .And. ( GWU->GWU_EMISDC == GW1->GW1_EMISDC .And. GWU->GWU_NRDC == GW1->GW1_NRDC .And. GWU->GWU_SERDC == GW1->GW1_SERDC) 
		
					Reclock("GWU",.F.)
					GWU->GWU_CDTPDC := 'NFED'
					MsUnlock()
		
					dbSkip()
	
		   		EndDo
	
			EndIf

//			cAliasSql2->(dbCloseArea())*/
		EndIf

	EndIf

  //	cAliasSql->(dbCloseArea())

	If !Empty(cChaveNFE)
		MsgAlert("Classificação CTE x NFE efetuada com sucesso!!! ")
	EndIf

Return


/*	cQuery := "SELECT GW8.GW8_CDTPDC, GW8.GW8_NRDC, GW8.GW8_SERDC, GW8.GW8_CFOP, GW8.GW8_VALOR "
	cQuery += "  FROM "+RetSqlName("GW8")+" GW8 "
	cQuery += " WHERE GW8.GW8_FILIAL  = '"+xFilial("GW8")+"' "
	cQuery += "   AND GW8.D_E_L_E_T_ = ' ' "
	cQuery += "   AND GW8.GW8_NRDC   = '" + SF1->F1_DOC   + "' "
	cQuery += "   AND GW8.GW8_NRDC   = '" + SF1->F1_SERIE + "' "
	cQuery += " ORDER BY GW8.GW8_NRDC, GW8.GW8_SERDC "
	cQuery := ChangeQuery( cQuery )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSql,.f.,.t.)
	dbGoTop()
