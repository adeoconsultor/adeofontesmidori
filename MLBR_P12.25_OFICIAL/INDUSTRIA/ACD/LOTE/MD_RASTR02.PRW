#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MD_RASTR02 ³ Autor ³ Antonio           ³ Data ³  01/02/2018  ³±±           
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Rastreabilidade 2 PNP2                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄQÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MD_RASTR02                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³      ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³          ³ 2018 ³ relatorio personalizado.	                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MRASTR02()
                                   
Local aArea := GetArea()
Local oPerg

Private cPerg  := "RELRA02"

//Executa a pergunta do relatório
oPerg := AdvplPerg():New( cPerg )

//-------------------------------------------------------------------
//    AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
// Parametriza as perguntas
//-------------------------------------------------------------------
oPerg:AddPerg( "Plano Inicial.........: " ,"C",TamSx3("ZP_OPMIDO")[1]  , ,          , "SZP")
oPerg:AddPerg( "Plano Final...........: " ,"C",TamSx3("ZP_OPMIDO")[1]  , ,          , "SZP")
oPerg:AddPerg( "Cod. Ord. Separação...: " ,"C",TamSx3("D4_X_ORSEP")[1] , ,          , "SD4")
oPerg:AddPerg( "Listar Grupo 45?(S/N).: " ,"N",1                       , ,{"S","N"} , )
oPerg:SetPerg()

If ! Pergunte( cPerg, .T. )
	Return( nil )
EndIf

If (Empty(MV_PAR01) .And. Empty(MV_PAR02))
	If Empty(MV_PAR03)
		HS_MsgInf("Informe pelo menos um plano valido para continuar! ","Atenção!!!","Impressão da Ordem de Separação")
		Return( nil )
	EndIf 
EndIf

//Processa o relatorio usando a classe tReport (Release 4)
//Verifica se esta utilizando release 4   

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
//	oReport := UReportDef()
//	oReport:PrintDialog()
	U_MRASTR2()
Else
	U_MRASTR2()
EndIf

RestArea( aArea )

Return


//Relatorio R4 ->
//desenvolver

 
//Relatorio R3 ->                                           

//////////////////////////////////////////////////////////////////////////////////////////
// Função: MD_RASTR3() Autor: Antonio C Damaceno - Data: 10/11/17
// Objetivo: Relatorio de Rastreabilidade

User Function MRASTR2()

Local cString 	:= "SF2"
Local cDesc1  	:= "Relatório de Rastreabilidade (2) - " + IIF(AllTrim(SM0->M0_CODFIL) == '08', 'PNP2','BRB') 
Local cDesc2  	:= "Será impresso de acordo com os parâmetros solicitados pelo"
Local cDesc3  	:= " usuário."
//Local aOrd    	:= {"Matricula","Nome","Centro Custo","Cargo"}

Private aReturn  := {"Zebrado",1,"Administração",2,2,1,"",1 }
Private NomeProg := "MD_RASTR02"
Private nLastKey := 0
Private Titulo   := "Relatório de Rastreabilidade (2) - " + IIF(AllTrim(SM0->M0_CODFIL) == '08', 'PNP2','BRB') 
Private Colunas  := 132 
Private cCabec1  := ""
Private cCabec2  := ""
Private nLin     := 60
Private nTamanho := "G" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
m_pag    := 1

wnrel:="MD_RASTR02"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,/*aOrd*/,,nTamanho)

If nLastKey = 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
EndIf

RptStatus({|lEnd| Rastr02Imp(@lEnd,wnRel,cString)},Titulo)

Return
                        

//////////////////////////////////////////////////////
//Interface de Impressão - 17/11/17
//////////////////////////////////////////////////////
Static Function Rastr02Imp(lEnd,wnRel,cString)
                                              
	Local cQuery0    := ""
	Local cAlTMP0    := GetNextAlias()
	Local cQuery     := ""
	Local cAlTMP     := GetNextAlias()
	Local cQuery1    := ""
	Local cAlTMP1    := GetNextAlias()
	Local cQuery2    := ""
	Local cAlTMP2    := GetNextAlias()
	Local cQueryX    := ""
	Local cAlTMPX    := GetNextAlias()
	Local cQuery3    := ""
	Local cAlTMP3    := GetNextAlias()

	Local cQuerya    := ""
	Local cAlTMPa    := GetNextAlias()

	Local aLinhaOS   :={}
	Local cD1LoteCtl := ""
	Local cCodPro    := ""
	Local nTotCtl    := 0
	Local cCodPai, cPaiQtde, cPaiDesc, cCodOS, dDataOS,	cPlanoMP, cPlanoCO, nI 

	
	cQuerya := " SELECT SZP.ZP_PRODUTO, SZP.ZP_QUANT, SZP.ZP_OBS FROM " + RetSqlName("SZP") + " SZP "
	cQuerya += " WHERE SZP.ZP_OPMIDO = '" + MV_PAR01 + "' "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuerya),cAlTMPa,.T.,.T.) 
	If (cAlTMPa)->(! Eof())
    	cCodPai  := (cAlTMPa)->ZP_PRODUTO
    	cPaiQtde := (cAlTMPa)->ZP_QUANT
    	cPaiDesc := (cAlTMPa)->ZP_OBS
	EndIf                        
	(cAlTMPa)->(dbCloseArea())
	
	cQueryX := " SELECT ZZP.ZZP_ORDSEP , ZZP.ZZP_DATA FROM " + RetSqlName("ZZP") + " ZZP "
	cQueryX += " WHERE ZZP.ZZP_OPMIDO = '" + MV_PAR01 + "' "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryX),cAlTMPX,.T.,.T.) 
	If (cAlTMPX)->(! Eof())
    	cCodOS  := (cAlTMPX)->ZZP_ORDSEP
    	dDataOS := (cAlTMPX)->ZZP_DATA
	EndIf
	(cAlTMPX)->(dbCloseArea())

	cQuery0 := " SELECT SC2.C2_PLANOMP, SC2.C2_PLANOCO FROM " + RetSqlName("SC2") + " SC2 "
	cQuery0 += " WHERE SC2.C2_OPMIDO = '" + MV_PAR01 + "' AND SC2.C2_PLANOMP <> ' ' AND SC2.C2_PLANOCO <> ' ' "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery0),cAlTMP0,.T.,.T.) 
	If (cAlTMP0)->(! Eof())
		cPlanoMP:=(cAlTMP0)->C2_PLANOMP
		cPlanoCO:=(cAlTMP0)->C2_PLANOCO
	EndIf
	(cAlTMP0)->(dbCloseArea())
	
	cQuery := " SELECT RTRIM(SG1.G1_COD) AS G1_COD, SB1B.B1_DESC AS B1_DESCB, SB1B.B1_UM , RTRIM(SG1.G1_COMP) AS G1_COMP, SB1A.B1_DESC AS B1_DESCA, "
	cQuery += "              SG1.G1_UM, SG1.G1_GROPC, SG1.G1_OPC, SG1.G1_PERDA, SG1.G1_QUANT, SG1.G1_INI  , SG1.G1_FIM, "
	cQuery += "            	 SB1B.B1_LADO "
	cQuery += " FROM " + RetSqlName("SG1") + " SG1 WITH (NOLOCK) "
	cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1A ON "
	cQuery += " 	SB1A.B1_COD = SG1.G1_COMP AND SB1A.B1_FILIAL = '"+ xFilial("SB1")+"' AND SB1A.D_E_L_E_T_ = ''"
	cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1B ON "
	cQuery += " 	SB1B.B1_COD = SG1.G1_COD AND SB1B.B1_FILIAL = '"+ xFilial("SB1")+"' AND SB1B.D_E_L_E_T_ = ''"
	cQuery += " WHERE "
	cQuery += " 	SG1.G1_FILIAL = '"+ xFilial("SZP")+"' AND "
	cQuery += " 	SG1.G1_COD IN ('"+cCodPai+"')  "
	cQuery += " 	AND SG1.G1_INI <= '"+DtoS(dDataBase) +"' "
	cQuery += " 	AND SG1.G1_FIM >= '"+DtoS(dDataBase) +"' "
	If MV_PAR04 == 2 //Não
		cQuery += " 	AND SB1A.B1_GRUPO <> '45' "
		cQuery += " 	AND SB1B.B1_GRUPO <> '45' "
    EndIf
	cQuery += " 	AND SB1A.B1_GRUPO NOT IN('45C') "
	cQuery += " 	AND SB1B.B1_GRUPO NOT IN('45C') "
	cQuery += " 	AND SG1.D_E_L_E_T_ = '' "
	cQuery += " 	AND SUBSTRING(SG1.G1_COMP,1,3) <> 'MOD'
	cQuery += " ORDER BY SG1.G1_COD, SG1.G1_COMP "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlTMP,.T.,.T.) 

	SetRegua((cAlTMP)->(RecCount()))

	While (cAlTMP)->(! Eof())
        
		(cAlTMP)->(IncRegua())

            	//           1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9
				//  1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		cCabec1 := "DATA DA PRODUÇÃO: "+DtoC(StoD(dDataOS))+"                              PLANO->       MP:"+cPlanoMP+"  CO:"+cPlanoCO+"                        KITS: "+Transform(cPaiQtde,"@E 99999")+"                                      REPOSIÇÃO"
		cCabec2 := "COD     DESCRIÇÃO                                                      PADRAO      UM      QTD PEÇAS   LOTE MIDORI    LOTE/NF                      FORNECEDOR                         ETQ        QTDE PEÇAS    LOTE "

		If lEnd
			@Prow()+1,0 PSAY "Cancelado Pelo Operador!!!"
			Exit
		EndIf

		If nLin > 55
	    	cCodPai  := SZP->ZP_PRODUTO
	    	cPaiQtde := SZP->ZP_QUANT
	    	cPaiDesc := SZP->ZP_OBS
			Cabec(Titulo+"          "+cCodPai+" "+cPaiDesc+" Plano: "+MV_PAR01,cCabec1,cCabec2,Nomeprog,nTamanho,15)
			nLin:=9
		EndIf

		@ nLin,000 Psay (cAlTMP)->G1_COMP
		@ nLin,010 Psay (cAlTMP)->B1_DESCA
		nLin := nLin + 1
		@ nLin,000 Psay Repli('-', 220)
		nLin := nLin + 1

		cQuery1 := " SELECT RTRIM(SG1.G1_COD) AS G1_COD, SB1B.B1_DESC AS B1_DESCB, SB1B.B1_UM , RTRIM(SG1.G1_COMP) AS G1_COMP, "
		cQuery1 += "               SB1A.B1_DESC AS B1_DESCA, SG1.G1_UM, SG1.G1_GROPC, SG1.G1_OPC, SG1.G1_PERDA, SG1.G1_QUANT, SG1.G1_INI,  "
		cQuery1 += "               SG1.G1_FIM, 	 SB1B.B1_LADO "
		cQuery1 += " FROM " + RetSqlName("SG1") + " SG1 WITH (NOLOCK) "
		cQuery1 += " INNER JOIN " + RetSqlName("SB1") + " SB1A ON "
		cQuery1 += " 	SB1A.B1_COD = SG1.G1_COMP AND SB1A.B1_FILIAL = '"+ xFilial("SB1")+"' AND SB1A.D_E_L_E_T_ = ''"
		cQuery1 += " INNER JOIN " + RetSqlName("SB1") + " SB1B ON "
		cQuery1 += " 	SB1B.B1_COD = SG1.G1_COD AND SB1B.B1_FILIAL = '"+ xFilial("SB1")+"' AND SB1B.D_E_L_E_T_ = ''"
		cQuery1 += " LEFT JOIN " + RetSqlName("SBZ") + " SBZA ON "
		cQuery1 += " 	SG1.G1_COMP = SBZA.BZ_COD  AND SBZA.BZ_FILIAL = '"+ xFilial("SBZ")+"' AND SBZA.D_E_L_E_T_ = ''""
		cQuery1 += " LEFT JOIN " + RetSqlName("SBZ") + " SBZB ON "
		cQuery1 += "    SG1.G1_COD  = SBZB.BZ_COD AND SBZB.BZ_FILIAL = '"+ xFilial("SBZ")+"' AND SBZB.D_E_L_E_T_ = ''""
		cQuery1 += " WHERE 	SG1.G1_FILIAL  = '"+ xFilial("SZP")+"' "
		cQuery1 += " 	AND SG1.D_E_L_E_T_ = '' "
		cQuery1 += " 	AND SG1.G1_COD    IN ('"+(cAlTMP)->G1_COMP+"')  "
		cQuery1 += " 	AND SG1.G1_INI    <= '"+DtoS(dDataBase) +"' "
		cQuery1 += " 	AND SG1.G1_FIM    >= '"+DtoS(dDataBase) +"' "
		If MV_PAR04 = 2 //Não
			cQuery1 += " 	AND SB1A.B1_GRUPO <> '45' "
			cQuery1 += " 	AND SB1B.B1_GRUPO <> '45' "
	    EndIf
		cQuery1 += " 	AND SB1A.B1_GRUPO NOT IN('45C') "
		cQuery1 += " 	AND SB1B.B1_GRUPO NOT IN('45C') "
		cQuery1 += " 	AND SUBSTRING(SG1.G1_COMP,1,3) <> 'MOD'
		cQuery1 += " 	AND SBZA.BZ_ORDSEP = 'S' "
		cQuery1 += " GROUP BY SG1.G1_COD,   SB1B.B1_DESC, SB1B.B1_UM, SG1.G1_COMP, SB1A.B1_DESC, SG1.G1_UM,      SG1.G1_GROPC, SG1.G1_OPC, " 
		cQuery1 += "          SG1.G1_PERDA, SG1.G1_QUANT, SG1.G1_INI, SG1.G1_FIM,  SB1B.B1_LADO, SBZA.BZ_ORDSEP, SBZB.BZ_ORDSEP
		cQuery1 += " ORDER BY SG1.G1_COD, SG1.G1_COMP "
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlTMP1,.T.,.T.) 
	
		SetRegua((cAlTMP1)->(RecCount()))
	
		While (cAlTMP1)->(! Eof())
	        
			(cAlTMP1)->(IncRegua())

/*        	If SUBSTR((cAlTMP1)->B1_DESCA,1,3) == 'KIT'
				(cAlTMP1)->(dbSkip())
				Loop
        	EndIf
*/
        	If SUBSTR((cAlTMP1)->B1_DESCA,1,5) == 'LINHA'
				aAdd(aLinhaOS,{(cAlTMP1)->G1_COMP,(cAlTMP1)->B1_DESCA,(cAlTMP1)->G1_QUANT, (cAlTMP1)->G1_UM})
				(cAlTMP1)->(dbSkip())
				Loop
        	EndIf

			@ nLin,000 Psay (cAlTMP1)->G1_COMP
			@ nLin,010 Psay (cAlTMP1)->B1_DESCA
//			@ nLin,070 Psay Transform((cAlTMP1)->G1_QUANT*cPaiQtde,"@E 999.9999")
			@ nLin,070 Psay Transform((cAlTMP1)->G1_QUANT,"@E 999.9999")
			@ nLin,084 Psay (cAlTMP1)->G1_UM 

			cQuery2 := " SELECT ZZK.ZZK_ORDSEP , ZZK.ZZK_CODPRO , ZZK.ZZK_QTDORI, ZZK.ZZK_LOTE FROM " + RetSqlName("ZZK") + " ZZK "
			cQuery2 += " WHERE ZZK.ZZK_ORDSEP = '" + cCodOS + "' AND ZZK.ZZK_CODPRO = '" + (cAlTMP1)->G1_COMP + "' ORDER BY ZZK.ZZK_CODPRO"
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAlTMP2,.T.,.T.) 

			nTotCtl:=0
			While (cAlTMP2)->(! Eof())
				nTotCtl:=nTotCtl+1
				(cAlTMP2)->(dbSkip())
			EndDo

			
			(cAlTMP2)->(dbGoTop())
			aLote:={}

			While (cAlTMP2)->(! Eof())
//				@ nLin,093 Psay Transform((cAlTMP2)->ZZK_QTDORI,"@E 9,999.9999")
//				@ nLin,093 Psay Transform((cAlTMP1)->G1_QUANT*cPaiQtde,"@E 9,999.9999")
//				@ nLin,105 Psay (cAlTMP2)->ZZK_LOTE

				cD1LoteCtl := (cAlTMP2)->ZZK_LOTE
				cCodPro    := (cAlTMP2)->ZZK_CODPRO

				If nTotCTL > 1
					cAlTMP2A := GetNextAlias()
					cQuery2A := " SELECT SD4.D4_COD, SUM(SD4.D4_QTDEORI) D4_QTDEORI "
					cQuery2A += " FROM " + RetSqlName("SD4") + " SD4 "
					cQuery2A += " WHERE SD4.D4_X_LOTE  = '" + (cAlTMP2)->ZZK_LOTE   + "' "
					cQuery2A += "   AND SD4.D4_COD     = '" + (cAlTMP2)->ZZK_CODPRO + "' "
					cQuery2A += "   AND SD4.D4_X_ORSEP = '" + cCodOS                + "' "
					cQuery2A += "   AND SD4.D4_PRODUTO = '" + (cAlTMP)->G1_COMP     + "' "
					cQuery2A += " 	AND SD4.D4_FILIAL  = '" + xFilial("SD4")        + "' "
					cQuery2A += " 	AND SD4.D_E_L_E_T_ = '' "
					cQuery2A += " GROUP BY SD4.D4_COD "
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2A),cAlTMP2A,.T.,.T.) 
					If (cAlTMP2A)->(!Eof())
						aAdd(aLote,{cD1LoteCtl,cCodPro,(cAlTMP2A)->D4_QTDEORI})
					EndIf
					(cAlTMP2A)->(dbCloseArea())
				Else
					aAdd(aLote,{cD1LoteCtl,cCodPro,(cAlTMP1)->G1_QUANT*cPaiQtde})
				EndIf

				(cAlTMP2)->(dbSkip())

			EndDo
//			Else
//				cD1LoteCtl := ""
//				cCodPro    := ""
///			EndIf
			(cAlTMP2)->(dbCloseArea())

			For nI := 1 to Len(aLote)
//			If !Empty(cD1LoteCtl) .And. !Empty(cCodPro)
				cAlTMP3 := GetNextAlias()
				cQuery3 := " SELECT SD1.D1_FORNECE , SD1.D1_LOJA , SA2.A2_NREDUZ , SD1.D1_LOTEFOR, SD1.D1_LOTECTL, SD1.D1_COD, SD1.D1_DOC, SD1.D1_SERIE "
				cQuery3 += " FROM " + RetSqlName("SD1") + " SD1 "
				cQuery3 += " JOIN " + RetSqlName("SA2") + " SA2 ON SA2.A2_COD    = SD1.D1_FORNECE AND SA2.A2_LOJA = SD1.D1_LOJA "
				cQuery3 += "                                   AND SA2.A2_FILIAL = '"+ xFilial("SA2")+"' AND SA2.D_E_L_E_T_ = '' "
//				cQuery3 += " WHERE SD1.D1_COD    = '" + cCodPro + "' AND SD1.D1_LOTECTL = '" + cD1LoteCtl + "' "
				cQuery3 += " WHERE SD1.D1_COD    = '" + aLote[nI,2] + "' AND SD1.D1_LOTECTL = '" + aLote[nI,1] + "' "
				cQuery3 += "   AND SD1.D1_FILIAL = '"+ xFilial("SD1")+"' AND SD1.D_E_L_E_T_ = '' "
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),cAlTMP3,.T.,.T.) 
				If (cAlTMP3)->(! Eof())
					@ nLin,093 Psay Transform(aLote[nI,3],"@E 9,999.9999")    //qtde
					@ nLin,105 Psay aLote[nI,1]                               //lotectl
					@ nLin,119 Psay Substr((cAlTMP3)->D1_LOTEFOR,1,12)+"  "+(cAlTMP3)->D1_DOC+"  "+(cAlTMP3)->D1_SERIE
					@ nLin,148 Psay (cAlTMP3)->A2_NREDUZ
					nLin:=nLin+1
				Else
					nLin:=nLin+1
				EndIf
				(cAlTMP3)->(dbCloseArea())
//			EndIf
			Next
						
//			nLin:=nLin+1

			(cAlTMP1)->(dbSkip())
		EndDo

		nLin:=nLin+1

		(cAlTMP1)->(dbCloseArea())

		(cAlTMP)->(dbSkip())
	EndDo

	If Len(aLinhaOS) > 0
		@ nLin,010 Psay 'LINHAS DE COSTURA'
		nLin:=nLin+1
	EndIf
	
	@ nLin,000 Psay Repli('-', 220)
	nLin:=nLin+1
	
    aSort( aLinhaOS,,, { |x, y| x[1] < y[1] } )

	If Len(aLinhaOS) > 0
		cCodPrd := aLinhaOS[1,1]
	Else
		cCodPrd := " "
	EndIf
	
	nTQte   := 0

	For nI := 1 to Len(aLinhaOS)                                     

		If aLinhaOS[nI,1] <> cCodPrd
			@ nLin,000 Psay aLinhaOS[nI-1,1]                 // 1 - (cAlTMP1)->G1_COMP   
			@ nLin,010 Psay aLinhaOS[nI-1,2]                 // 2 - (cAlTMP1)->B1_DESCA   
			@ nLin,070 Psay Transform(nTQte,"@E 999.9999")   // 3 - (cAlTMP1)->G1_QUANT
			@ nLin,084 Psay aLinhaOS[nI-1,4]                 // 4 - (cAlTMP1)->G1_UM
			cCodPrd := aLinhaOS[nI,1]
			nTQte   := 0 
			nLin:=nLin+1
		EndIf
		nTQte := nTQte + aLinhaOS[nI,3]
	Next

	If Len(aLinhaOS) > 0
		@ nLin,000 Psay aLinhaOS[nI-1,1]                   // 1 - (cAlTMP1)->G1_COMP   
		@ nLin,010 Psay aLinhaOS[nI-1,2]                   // 2 - (cAlTMP1)->B1_DESCA   
		@ nLin,070 Psay Transform(nTQte,"@E 999.9999")     // 3 - (cAlTMP1)->G1_QUANT
		@ nLin,084 Psay aLinhaOS[nI-1,4]                   // 4 - (cAlTMP1)->G1_UM
		nLin:=nLin+1
	EndIf
		
	(cAlTMP)->(dbCloseArea())

	Set Filter to 
	
	If aReturn[5] = 1
		Set Printer To
		Commit
		ourspool(wnrel)
	Endif
	
	MS_FLUSH()
			
Return Nil       

       
