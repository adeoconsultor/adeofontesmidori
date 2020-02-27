#include 'totvs.ch'
#include 'topconn.ch'
#include 'parmtype.ch'
                                                                              
//////////////////////////////////////////////////////////////////////////////////////////
// Fun็ใo: MDGEROSC() Autor: Antonio C Damaceno - Data: 02/02/17
// Objetivo: Gerar Ordem de Separa็ใo na planta de Costura

User Function MD_GEROSC()

Local oPerg
Local oGrdPre   := nil
Local cPerg     :="MTA202OS"
Local cSql1     := ""
Local cAliasZZP := GetNextAlias()
                                
Private oDlg, oGridPrd
Private cSql    := ""
Private aHead   := {}
Private nPRODUT := 0
           
Private cUAliaSD4 := GetNextAlias()
Private lOSErro   :=.F.
Private cLoteExcl := "" //lotes nao disponivel conforme for empenhando o saldo da sb8

Private oPlanoMP
Private oPlanoCO
Private cPlanoMP := Space(20)
Private cPlanoCO := Space(20)

oPerg := AdvplPerg():New( cPerg )

//-------------------------------------------------------------------
//    AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
// Parametriza as perguntas
//-------------------------------------------------------------------
oPerg:AddPerg( "Plano Inicial: " ,"C",TamSx3("ZP_OPMIDO")[1] , , , "SZP")
oPerg:AddPerg( "Plano Final..: " ,"C",TamSx3("ZP_OPMIDO")[1] , , , "SZP")
oPerg:SetPerg()

If ! Pergunte( cPerg, .t. )
	Return( nil )
EndIf

//checar se ja existe plano gerado com o codigo informado, caso seja positivo, serแ gerado uma nova OS
	cQuery := " SELECT ZZP.ZZP_OPMIDO "
	cQuery += "  FROM " + RetSqlName("ZZP") + " ZZP  "
	cQuery += "  WHERE ZZP.ZZP_FILIAL = '" + xFilial("ZZP") + "' AND ZZP.D_E_L_E_T_ = '  ' AND" 
	cQuery += "        ZZP.ZZP_OPMIDO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZZP,.T.,.T.) 

	If (cAliasZZP)->(! Eof())                            
		If !MsgYesNo( "Jแ Existe Ordem Separa็ใo Gerada P/ Este Plano, Deseja Gerar Uma Nova OS caso ainda tenha Empenhos?")
			(cAliasZZP)->(dbCloseArea())
			Return()
		EndIf
	EndIf
	(cAliasZZP)->(dbCloseArea())
//checar se ja existe plano gerado com o codigo informado, caso seja positivo, serแ gerado uma nova OS


Processa({|| UVGerOsc(cSql1) }, "Validando dados...")


Return()
 

Static Function UVGerOsc(cSql1) 
Local nLoop                                                        

// Limpa B8_QEMPPRE antes de gerar proxima OS
// Obs: Segundo Flavio Garcia nao eh gerado uma proxima ordem separacao
// antes de transferir os saldos da ordem anterior                             
// Diego 19/01/2018
                   
cSql := "UPDATE "+RetSqlName("SB8")+" SET B8_QEMPPRE = 0 WHERE B8_SALDO > 0"
TcSqlExec(cSql)                        

//----------------------------------------
// Monta query dos produtos que devem
// ser analizados
//----------------------------------------
cSql := "SELECT SB1.B1_DESC    XDESC   "
cSql += "     , SD4.D4_COD     PRODUTO "
cSql += "     , SD4.D4_LOCAL   ARMAZEM "
cSql += "     , SD4.D4_OP      OP      "
cSql += "     , SC2.C2_OPMIDO  PLANO   "
cSql += "     , SD4.D4_QUANT   EMPENHO "
cSql += "     , SD4.D4_DATA    DATA    "
cSql += "     , SD4.D4_LOTECTL LOTE    "
cSql += "     , SD4.D4_DTVALID DTVLL   "
cSql += "     , SB1.B1_RASTRO  RASTRO  "
cSql += "     , SB1.B1_LOCALIZ LOCALIZ "
cSql += "     , SD4.R_E_C_N_O_ RECNOD4 "                                    
cSql += "     , COALESCE( X.DC_QTDORIG, 0 ) EMPENDER " // TOTAL JA EMPENHADO NOS ENDERECOS ( SBF )
cSql += "  FROM "+RetSqlName("SD4")+" SD4 "
cSql += " INNER JOIN "+RetSqlName("SC2")+" SC2 ON SC2.C2_FILIAL = '"+xFilial("SC2")+"' "
cSql += "                      AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN = SD4.D4_OP "
cSql += "                      AND SC2.C2_OPMIDO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
//cSql += "                      AND SC2.C2_NUM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cSql += "                      AND SC2.D_E_L_E_T_  = ' ' "
cSql += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
cSql += "                      AND SB1.B1_COD      = SD4.D4_COD "
cSql += "                      AND ( SB1.B1_RASTRO = 'L' OR SB1.B1_LOCALIZ = 'S' ) "
cSql += "                      AND SB1.D_E_L_E_T_  = ' ' "
cSql += " INNER JOIN "+RetSqlName("SBZ")+" SBZ ON SBZ.BZ_FILIAL = '"+xFilial("SBZ")+"'
cSql += " 			           AND SBZ.BZ_COD      = SB1.B1_COD " 
cSql += "   		           AND SBZ.BZ_ORDSEP   = 'S' "
cSql += " 			           AND SBZ.D_E_L_E_T_  = ' ' "
cSql += "  LEFT JOIN ( SELECT SDC.DC_PRODUTO "         
cSql += "                   , SDC.DC_OP "
cSql += "                   , SDC.DC_LOCAL "
cSql += "                   , SUM( DC_QTDORIG ) DC_QTDORIG "
cSql += "                FROM "+RetSqlName("SDC")+" SDC "
cSql += "               WHERE SDC.DC_FILIAL  = '"+xFilial("SDC")+"' "
cSql += "                 AND SDC.DC_ORIGEM  = 'SC2' "
cSql += "                 AND SDC.D_E_L_E_T_ = ' ' "
cSql += "               GROUP BY SDC.DC_PRODUTO "
cSql += "                   , SDC.DC_OP "
cSql += "                   , SDC.DC_LOCAL ) X ON X.DC_OP      = SD4.D4_OP "
cSql += "                                     AND X.DC_PRODUTO = SD4.D4_COD "
cSql += "                                     AND X.DC_LOCAL   = SD4.D4_LOCAL "
cSql += "WHERE SD4.D4_FILIAL   = '"+xFilial("SD4")+"' "
//cSql += "  AND SD4.D4_LOTECTL  = ' '  "
cSql += "  AND SD4.D4_X_ORSEP  = ' '  "            //CAMPO DA ORDEM DE SEPARAวรO EM BRANCO
cSql += "  AND SD4.D4_QUANT    = SD4.D4_QTDEORI "
cSql += "  AND SD4.D_E_L_E_T_  = ' ' "       
cSql += "ORDER BY "
cSql += "         SD4.D4_COD     "
cSql += "       , SD4.D4_LOTECTL "
cSql += "       , SD4.D4_DTVALID "

ProcRegua(0)
IncProc("Filtrando registros") 
IncProc("Filtrando registros") 
IncProc("Filtrando registros") 
cSql1 := cSql
cSql := ChangeQuery( cSql )
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql1),cUAliaSD4,.f.,.t.) 	

//-----------------------------------------------
// Monta a dialog
//-----------------------------------------------
oDlg:= uAdvplDlg():New(  "Gerador de Ordem de Separa็ใo de Materiais", .t., .t., , nil, 100, 100 )
Aadd(aHead, { "Plano"         , "PLANO"    , "@!"                  , TamSX3("C2_OPMIDO"  )[1] , 0 , ".f.", "", "C", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "OP"            , "OP"       , "@!"                  , TamSx3("C2_NUM"     )[1] , 0 , ".f.", "", "C", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Produto"       , "PRODUTO"  , "@!"                  , TamSX3("D4_COD"     )[1] , 0 , ".f.", "", "C", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Descricao"     , "XDESC"    , "@!"                  , TamSX3("B1_DESC"    )[1] , 0 , ".f.", "", "C", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Data"          , "DATA"     , "@!"                  , TamSx3("D4_DATA"    )[1] , 0 , ".f.", "", "D", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Empenho"       , "EMPENHO"  , "@E 999,999,999.9999" , TamSx3("D4_QUANT"   )[1] , 4 , ".f.", "", "N", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Armaz้m"       , "ARMAZEM"  , "@!"                  , TamSx3("D4_LOCAL"   )[1] , 0 , ".f.", "", "C", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Lote Midori"   , "LOTE"     , "@!"                  , TamSx3("D4_LOTECTL" )[1] , 0 , ".f.", "", "C", "" , "R","","", ".f.", "A", ""} )
Aadd(aHead, { "Validade Lote" , "DTVLL"    , "@!"                  , TamSx3("D4_DTVALID" )[1] , 0 , ".f.", "", "D", "" , "R","","", ".f.", "A", ""} )

oGrdPre:= MyGrid():New( 000, 000, 000, 000, GD_UPDATE,,,,,, 99999,,,, oDlg:oPnlCenter )

For nLoop := 1 to Len( aHead )
	oGrdPre:AddColumn( aHead[nLoop] )
Next nLoop

ProcRegua(100) 

oGrdPre:SeekSet()
oGrdPre:IndexSet()
oGrdPre:SheetSet()
oGrdPre:AddButton( "Gerar Ordem Separa็ใo"  , { || Processa( {|| MonEncPre(@oGrdPre,2) }, "Aguarde..." ) } )
oGrdPre:Load()
oGrdPre:FromSql( cSql )
oGrdPre:SetAlignAllClient()

oDlg:SetInit( {|| oGrdPre:Refresh(.T.)})
oDlg:Activate()

Return( Nil )
                                                                                
 

//Ajustar o empenho para os lotes
Static Function MonEncPre(oGrdPre,nParam)

	Local cXXAliaSD4 := GetNextAlias()
	Local cPlano     := aScan(oGrdPre:aHeader, {| aVet | aVet[2] == "PLANO"})
	Local cProduto   := aScan(oGrdPre:aHeader, {| aVet | aVet[2] == "PRODUTO"})
	Local cLoteCtl   := aScan(oGrdPre:aHeader, {| aVet | aVet[2] == "LOTE"})
	Local cLocal     := aScan(oGrdPre:aHeader, {| aVet | aVet[2] == "ARMAZEM"})
	Local nQuant     := aScan(oGrdPre:aHeader, {| aVet | aVet[2] == "EMPENHO"})

	Default nParam   := 1

	Private cUTotQtd  := 0

	cQuery := " SELECT MAX(SD4.D4_X_ORSEP) ULTORSEP "
	cQuery += "  FROM " + RetSqlName("SD4") + " SD4  "
	cQuery += "  WHERE SD4.D4_FILIAL = '" + xFilial("SD4") + "' AND SD4.D_E_L_E_T_ = '  ' " 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cXXAliaSD4,.T.,.T.) 

	If (cXXAliaSD4)->(! Eof())                            
		cD4_X_ORSEP:=Soma1( (cXXAliaSD4)->ULTORSEP )
	Else
		MsgInfo( "Ordem de separa็ใo nใo serแ gerada, numero em duplicidade, contate depto TI!")
		(cXXAliaSD4)->(dbCloseArea())
		Return()
	EndIf
	(cXXAliaSD4)->(dbCloseArea())

	If !FS_GrvPla()   //Tela para usuแrio informar os planos da Lectra e Couro - 31/10/17 - Antonio
		MsgInfo( "Planos da Lectra e Couro Invแlidos ou nใo Informados, Ordem de Separa็ใo nใo serแ Gerada!!!","ATENวรO")
		Return()
	EndIf

	cUProduto := (cUAliaSD4)->PRODUTO
	cULoteCtl := (cUAliaSD4)->LOTE
	cUVldLote := (cUAliaSD4)->DTVLL
	
	While (cUAliaSD4)->(!Eof())                            
	
		IncProc("Ajustando empenhos")                                                           
	
		If (cUAliaSD4)->RASTRO == "L"
			//-------------------------------------
			// trata os produtos que controlam lote
			//------------------------------------- 		
			If cUProduto == (cUAliaSD4)->PRODUTO .AND. cULoteCtl == (cUAliaSD4)->LOTE .And. cUVldLote == (cUAliaSD4)->DTVLL
				cUTotQtd := cUTotQtd + (cUAliaSD4)->EMPENHO
			Else
				cUProduto := (cUAliaSD4)->PRODUTO
				cULoteCtl := (cUAliaSD4)->LOTE
				cUVldLote := (cUAliaSD4)->DTVLL
				cUTotQtd  := 0
				cUTotQtd  := cUTotQtd + (cUAliaSD4)->EMPENHO
				// Limpa lotes utilizados produto anterior
				// Correcao nao empenhar lotes alguns produtos
				// Add Diego 28/10/17
				cLoteExcl := "" 
			EndIf                                                                                                     

			TrataLote( (cUAliaSD4)->PRODUTO, (cUAliaSD4)->ARMAZEM, (cUAliaSD4)->EMPENHO, (cUAliaSD4)->EMPENDER, (cUAliaSD4)->OP, (cUAliaSD4)->RECNOD4, cD4_X_ORSEP, cUTotQtd )

		Else
			                                                   
			//----------------------------------------------------------------------
			// Se a quantidade empenhada no SD4 (Campo EMPENHO) for a mesma do SDC
			// (Campo EMPENDER), nใo precisa fazer mais nada.
			//----------------------------------------------------------------------
			IF (cUAliaSD4)->EMPENDER >= (cUAliaSD4)->EMPENHO
				dbSelectArea( cUAliaSD4 )
				dbSkip()
			    Loop
			EndIf   
	
			//-------------------------------------
			// trata os produtos que controlam  
			// somente endere็o
			//-------------------------------------
			TrataEnd( (cUAliaSD4)->PRODUTO, (cUAliaSD4)->ARMAZEM, (cUAliaSD4)->EMPENHO, (cUAliaSD4)->EMPENDER, (cUAliaSD4)->OP, (cUAliaSD4)->RECNOD4 , cD4_X_ORSEP)
		EndIf
	     
		dbSelectArea( cUAliaSD4 )
		dbSkip()
	Enddo       
	 
	(cUAliaSD4)->(dbCloseArea())
             
	If !lOSErro
		MsgInfo( "Processo finalizado com sucesso.") 
		oGrdPre:ClearGrid() // Limpa aCols e aHeader
	Else
		MsgInfo( "Processo com erro, verifique!!!")
		oGrdPre:ClearGrid() // Limpa aCols e aHeader
	EndIf

Return( nil )   




//***********************************************************************************************************
// Rotina para tratar os Lotes - Alessandro e Antonio(Aproveitando rotina feira pelo Ale)
//***********************************************************************************************************
Static Function TrataLote( cPrd, cArm, nEmpenho, nEmpEnder, cOP, nRecno, cOrdSep, nSoma) 

Local aEmpenho  := {}
Local cSql      := ""
Local cAliasB8  := GetNextAlias()                 
Local aArea     := GetArea()
Local cTRT      := ""           
Local aVetor    := {}
Local nX        := 0
Local cNUAliaSD4 := GetNextAlias()
Local nItem     := 1
Local cArm1     := '01'
Local nSeqD4    := 0
Local nQEmp		:= 0

Default cArm1:='01'  // buscar sempre o armazem 01 conforme DEFINIDO com Thiago

Private lMsErroAuto := .F.

dbSelectArea("SD4")
dbGoTo(nRecno)      

cSql += "SELECT SB8.B8_PRODUTO "
cSql += "     , SB8.B8_LOCAL "
cSql += "     , SB8.B8_DATA "
cSql += "     , SB8.B8_DTVALID "
cSql += "     , SB8.B8_SALDO "
cSql += "     , (SB8.B8_SALDO - SB8.B8_EMPENHO - B8_QEMPPRE) B8_LIVRE "
cSql += "     , SB8.B8_LOTECTL "
cSql += "  FROM "+RetSqlName("SB8")+" SB8 "
cSql += " WHERE SB8.B8_FILIAL = '"+xFilial("SB8")+"' "
cSql += "   AND SB8.B8_PRODUTO = '" +cPrd+ "' "
//cSql += "   AND SB8.B8_SALDO - SB8.B8_EMPENHO - "+nEmpenho+" > 0 "
cSql += "   AND (SB8.B8_SALDO - SB8.B8_EMPENHO - B8_QEMPPRE) > 0 "
cSql += "   AND SB8.B8_LOCAL = '"+cArm1+"' "
cSql += "   AND SB8.B8_DTVALID >= '"+DtoS(dDataBase)+"' "               

/* add Diego */
If !empty(cLoteExcl)                                                  	
	cSql += "	AND SB8.B8_LOTECTL NOT IN ("+substr(cLoteExcl,0,len(cLoteExcl)-1)+") "
Endif          
/**/

cSql += "   AND SB8.D_E_L_E_T_ = ' ' "
cSql += " ORDER BY SB8.B8_DTVALID, SB8.B8_LOTECTL "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasB8,.f.,.t.) 	
dbGoTop()

nSOMA1:=nSOMA
nSOMA2:=0

While (cAliasB8)->(! Eof())    
	                          
	//------------------------------------------
	// Se tem menos estoque livre no lote do que
	// o necessแrio para o empenho
	//------------------------------------------
	If (cAliasB8)->B8_LIVRE <= ( nEmpenho )

		If nSoma1 == (cAliasB8)->B8_LIVRE
			If nEmpenho -(cAliasB8)->B8_LIVRE <> 0
				(cAliasB8)->(dbSkip())
				AAdd( aEmpenho, { cPrd, cArm1, (cAliasB8)->B8_LOTECTL, nEmpenho - nSoma1, (cAliasB8)->B8_DTVALID } )   //Empenha no Armazem Padrao (B1_LOCPAD)			
				nQEmp := nEmpenho - nSoma1
			Else                                                   
				AAdd( aEmpenho, { cPrd, cArm1, (cAliasB8)->B8_LOTECTL, nEmpenho, (cAliasB8)->B8_DTVALID } )   //Empenha no Armazem Padrao (B1_LOCPAD)
				nQEmp := nEmpenho
			Endif
			
			// Previsao Empenho na execucao da Ordem Separa็ใo
			// Utilizado na query acima para verificar saldo livre
			// Corrigi problema empenhar em outra ordem separacao saldo pre empenhado
			SB8->(dbSetOrder(1))
			If SB8->(DbSeek(xFilial("SB8") + cPrd + cArm1 + (cAliasB8)->B8_DTVALID + (cAliasB8)->B8_LOTECTL))
				If RecLock("SB8",.F.)
					SB8->B8_QEMPPRE  := SB8->B8_QEMPPRE + nQEmp                      
					MsUnlock()
				EndIf
			EndIf

			nSoma1:=0
			cUTotQtd  := 0
 			nSoma2 := nEmpenho
		Else
				AAdd( aEmpenho, { cPrd, cArm1, (cAliasB8)->B8_LOTECTL, (cAliasB8)->B8_LIVRE, (cAliasB8)->B8_DTVALID } )   //Empenha no Armazem Padrao (B1_LOCPAD)
			
			// Previsao Empenho na execucao da Ordem Separa็ใo
			// Utilizado na query acima para verificar saldo livre
			// Corrigi problema empenhar em outra ordem separacao saldo pre empenhado
			SB8->(dbSetOrder(1))
			If SB8->(DbSeek(xFilial("SB8") + cPrd + cArm1 + (cAliasB8)->B8_DTVALID + (cAliasB8)->B8_LOTECTL))
				If RecLock("SB8",.F.)
					SB8->B8_QEMPPRE  := SB8->B8_QEMPPRE + (cAliasB8)->B8_LIVRE                      
					MsUnlock()
				EndIf
			EndIf
		cLoteExcl += "'"+(cAliasB8)->B8_LOTECTL+"',"      // add Diego
		EndIf
		                                                                                                                                                 

        If nSoma1 <> 0
			If (cAliasB8)->B8_LIVRE > nSoma1
				nSoma1    := (cAliasB8)->B8_LIVRE - nSoma1
	    	Else
				nSoma1   := (cAliasB8)->B8_LIVRE
	    	EndIf  	 	

        EndIf

		If nSoma1 == (cAliasB8)->B8_LIVRE
			//nSoma2 := nEmpenho
			nSoma2 := (cAliasB8)->B8_LIVRE
		EndIf

	Else
		//-----------------------------------------
		// Se tem mais estoque livre no lote do que
		// o necessแrio para o empenho
		//-----------------------------------------
		nSoma2 := nEmpenho
		AAdd( aEmpenho, { cPrd, cArm1, (cAliasB8)->B8_LOTECTL, nSoma2, (cAliasB8)->B8_DTVALID } )   //Empenha no Armazem Padrao (B1_LOCPAD)
		
		// Previsao Empenho na execucao da Ordem Separa็ใo
		// Utilizado na query acima para verificar saldo livre
		// Corrigi problema empenhar em outra ordem separacao saldo pre empenhado
		SB8->(dbSetOrder(1))
		If SB8->(DbSeek(xFilial("SB8") + cPrd + cArm1 + (cAliasB8)->B8_DTVALID + (cAliasB8)->B8_LOTECTL))
			If RecLock("SB8",.F.)
				SB8->B8_QEMPPRE  := SB8->B8_QEMPPRE + nSoma2                      
				MsUnlock()
			EndIf
		EndIf
				
	EndIf                          
	
	//-----------------------------------------
	// Se alcan็ou a quantidade necessแria 
	// para o empenho, sai do loop
	//-----------------------------------------	
	If nEmpenho == (cAliasB8)->B8_LIVRE
		exit
	Endif
	
	If nSoma2 == nEmpenho  
		If (nSoma2 - (cAliasB8)->B8_LIVRE) == 0 
			(cAliasB8)->(dbSkip())    
		Else  
  			Exit                                           		
		Endif                                                                                         
	Endif                                       
	


	
Enddo

(cAliasB8)->(dbCloseArea())

RestArea( aArea )                 
     
//---------------------------------------
// Nใo serแ possํvel empenhar a 
// quantidade total necessแria. Mant้m
// os empenhos como estใo
//---------------------------------------
If ( nSoma2 - nEmpenho ) <> 0
	Return( nil )
EndIf
                         
//---------------------------------------
// posiciona no Recno da SD4
//---------------------------------------
dbSelectArea("SD4")
dbGoTo(nRecno)     
cTrt       := SD4->D4_TRT
cxXLocal   := SD4->D4_LOCAL              
cxXLoteCTL := SD4->D4_LOTECTL
                              
//---------------------------------------
// Executa o empenho dos lotes (nos campos de lote e validade customizados)
//---------------------------------------

For nX := 1 to Len( aEmpenho ) 
	nSeqD4 := nSeqD4 + 1 
	
	SD4->(dbSetOrder(1))
	If SD4->(DbSeek(xFilial("SD4") + aEmpenho[nX,1] + cOP + cTrt + cxXLoteCTL))

		If Empty(SD4->D4_X_ORSEP) 

			If RecLock("SD4",.F.)
				SD4->D4_COD     := aEmpenho[nX,1]       
				SD4->D4_LOCAL   := CXXLOCAL
				SD4->D4_OP      := cOp                  
				SD4->D4_DATA    := dDataBase            
				SD4->D4_QTDEORI := aEmpenho[nX,4]       
				SD4->D4_QUANT   := aEmpenho[nX,4]       
				SD4->D4_TRT     := cTrt                 
				SD4->D4_X_LOTE  := aEmpenho[nX,3]                   //grava primeiramente os campos customizados do lote
				SD4->D4_X_DTVLL := StoD(aEmpenho[nX,5]) 
			    SD4->D4_X_ORSEP := cORDSEP              
				SD4->D4_QTSEGUM := 0                    
				MsUnlock()
			EndIf

		Else

			If RecLock("SD4",.T.)
				SD4->D4_FILIAL  := xFilial("SD4")
				SD4->D4_COD     := aEmpenho[nX,1]       
				SD4->D4_LOCAL   := CXXLOCAL        
				SD4->D4_OP      := cOp                  
				SD4->D4_DATA    := dDataBase            
				SD4->D4_QTDEORI := aEmpenho[nX,4]       
				SD4->D4_QUANT   := aEmpenho[nX,4]       
				SD4->D4_TRT     := cValToChar(nSeqD4)                 
				SD4->D4_X_LOTE  := aEmpenho[nX,3]       
				SD4->D4_X_DTVLL := StoD(aEmpenho[nX,5]) 
			    SD4->D4_X_ORSEP := cORDSEP              
				SD4->D4_QTSEGUM := 0                    
				MsUnlock()
			EndIf
		
		EndIf

	Else
	
		If RecLock("SD4",.T.)
			SD4->D4_FILIAL  := xFilial("SD4")
			SD4->D4_COD     := aEmpenho[nX,1]       
			SD4->D4_LOCAL   := CXXLOCAL        
			SD4->D4_OP      := cOp                  
			SD4->D4_DATA    := dDataBase            
			SD4->D4_QTDEORI := aEmpenho[nX,4]       
			SD4->D4_QUANT   := aEmpenho[nX,4]       
			SD4->D4_TRT     := cValToChar(nSeqD4)                 
			SD4->D4_X_LOTE  := aEmpenho[nX,3]       
			SD4->D4_X_DTVLL := StoD(aEmpenho[nX,5]) 
		    SD4->D4_X_ORSEP := cORDSEP              
			SD4->D4_QTSEGUM := 0                    
			MsUnlock()
		EndIf

	EndIf	

Next nX


For nX := 1 to Len( aEmpenho )           //passa Op por Op para gravar os campos de Plano da Lectra e Plano do Couro - 31/10/17
	SC2->(dbSetOrder(1))
	If SC2->(dbSeek(xFilial("SC2") + SubStr(cOP,1,6) + '01' + '001'))
		Reclock("SC2",.F.)
		SC2->C2_PLANOMP := cPlanoMP
		SC2->C2_PLANOCO := cPlanoCO
		MsUnlock()
	EndIf
Next nX



//Salva na ZZP(OS) e ZZK (Itens da OS)
If !lOSErro

	cSql := " SELECT '', "
	cSql += "        SC2.C2_OPMIDO       D4PLANO   , "
	cSql += "        SD4.D4_COD          D4PRODUTO , "
	cSql += "        SB1.B1_DESC         D4XDESC   , "
	cSql += "        SD4.D4_DATA         D4DATA    , "
	cSql += "        SD4.D4_LOCAL        D4LOCAL   , "
	cSql += "        SD4.D4_X_LOTE       D4LOTE    , "
	cSql += "        SD4.D4_X_DTVLL      D4VALID   , "
	cSql += "        SD4.D4_X_ORSEP      D4ORSEP   , "
	cSql += "        SUM(SD4.D4_QTDEORI) D4QUANT     "
	cSql += "  FROM " + RetSqlName("SC2") + " SC2    "
	cSql += " JOIN " + RetSqlName("SD4") + " SD4 ON  "
	cSql += " 			SUBSTRING(SD4.D4_OP,1,6) =  SC2.C2_NUM AND " 
	cSql += " 			SD4.D_E_L_E_T_           <> '*' AND "
	cSql += "   		SD4.D4_FILIAL            =  '" + xFilial("SD4") + "' "
	cSql += " JOIN " + RetSqlName("SB1") + " SB1 ON  "
	cSql += " 			SB1.B1_COD     =  SD4.D4_COD AND " 
	cSql += " 			SB1.D_E_L_E_T_ <> '*' AND "
	cSql += "   		SB1.B1_FILIAL  =  '" + xFilial("SB1") + "' AND "
	cSql += "   		SB1.B1_RASTRO  =  'L' "
	cSql += " JOIN " + RetSqlName("SBZ") + " SBZ ON  "
	cSql += " 			SBZ.BZ_COD     =  SB1.B1_COD AND " 
	cSql += " 			SBZ.D_E_L_E_T_ <> '*' AND "
	cSql += "   		SBZ.BZ_FILIAL  =  '" + xFilial("SBZ") + "' AND "
	cSql += "   		SBZ.BZ_ORDSEP  =  'S' "
	cSql += "   WHERE SC2.C2_FILIAL    =  '" + xFilial("SC2") + "' "
	cSql += "     AND SC2.D_E_L_E_T_   =  ' ' "
//	If !Empty(MV_PAR01) .and. !Empty(MV_PAR02)
//		cSql += "     AND SC2.C2_OPMIDO BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"'"
//	EndIf
	cSql += "     AND SD4.D4_QUANT    = SD4.D4_QTDEORI "
	cSql += "     AND SD4.D4_X_ORSEP = '"+ cORDSEP +"' "
	cSql += "     AND SUBSTRING(SD4.D4_COD,1,3) <> 'MOD' "
	cSql += "   GROUP BY  "
	cSql += "        SC2.C2_OPMIDO  , "
	cSql += "        SD4.D4_COD     , "
	cSql += "        SB1.B1_DESC    , "
	cSql += "        SD4.D4_DATA    , "
	cSql += "        SD4.D4_LOCAL   , "
	cSql += "        SD4.D4_X_LOTE  , "
	cSql += "        SD4.D4_X_DTVLL , "
	cSql += "        SD4.D4_X_ORSEP   "
	cSql += "     ORDER BY  "
	cSql += "        SC2.C2_OPMIDO  , "
	cSql += "        SD4.D4_COD     , "
	cSql += "        SB1.B1_DESC    , "
	cSql += "        SD4.D4_DATA    , "
	cSql += "        SD4.D4_LOCAL   , "
	cSql += "        SD4.D4_X_LOTE  , "
	cSql += "        SD4.D4_X_DTVLL , "
	cSql += "        SD4.D4_X_ORSEP   "
	dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql),cNUAliaSD4,.F.,.T.)
  
	If (cNUAliaSD4)->(!Eof()) 
		If ZZP->(DbSeek(xFilial("ZZP")+(cNUAliaSD4)->D4ORSEP))
			RecLock("ZZP",.F.)
		Else
			RecLock("ZZP",.T.)
		EndIf

		ZZP->ZZP_FILIAL  := xFilial("ZZP")
		ZZP->ZZP_ORDSEP  := (cNUAliaSD4)->D4ORSEP
		ZZP->ZZP_DATA    := dDataBase
		ZZP->ZZP_OPMIDO  := (cNUAliaSD4)->D4PLANO
		ZZP->ZZP_STATUS  := 'N'
		MsUnlock()
	EndIF

	While (cNUAliaSD4)->(!Eof())

		ZZK->(dbSetOrder(1))
		If ZZK->(DbSeek(xFilial("ZZK")+(cNUAliaSD4)->D4ORSEP+STRZERO(nItem,3)+Alltrim((cNUAliaSD4)->D4PRODUTO)+(cNUAliaSD4)->D4LOTE ))
			RecLock("ZZK",.F.)
		Else
			RecLock("ZZK",.T.)
		EndIf

		ZZK->ZZK_FILIAL  := xFilial("ZZK")
		ZZK->ZZK_ORDSEP  := (cNUAliaSD4)->D4ORSEP
		ZZK->ZZK_ITEM    := STRZERO(nItem,3)
		ZZK->ZZK_CODPRO  := (cNUAliaSD4)->D4PRODUTO
		ZZK->ZZK_DESC    := (cNUAliaSD4)->D4XDESC
		ZZK->ZZK_LOCAL   := (cNUAliaSD4)->D4LOCAL
		ZZK->ZZK_LOTE    := (cNUAliaSD4)->D4LOTE
		ZZK->ZZK_DTVLL   := StoD((cNUAliaSD4)->D4VALID)
		ZZK->ZZK_QTDORI  := (cNUAliaSD4)->D4QUANT
		ZZK->ZZK_QTDSEP  := 0
		ZZK->ZZK_STATUS  := 'N'
		MsUnlock()

		(cNUAliaSD4)->(dbSkip())

	EndDo
                               
	(cNUAliaSD4)->(dbCloseArea())

EndIf

Return( nil )



//***********************************************************************************************************
//Rotina para tratar endere็amentos - Alessandro Freire
//***********************************************************************************************************
Static Function TrataEnd( cPrd, cArm, nEmpenho, nEmpEnder, cOP, nRecno )
                                               
Local aEmpenho := {}
Local cSql     := ""
Local cAliasBF := GetNextAlias()                 
Local aArea    := GetArea()
Local nSoma    := 0
Local cTRT     := ""           
Local aVetor   := {}
Local nX       := 0

cSql += "SELECT SBF.BF_PRODUTO "
cSql += "     , SBF.BF_LOCAL "
cSql += "     , SBF.BF_LOCALIZ "
cSql += "     , SUM( SBF.BF_QUANT - SBF.BF_EMPENHO ) BF_LIVRE "
cSql += "  FROM "+RetSqlName("SBF")+" SBF "
cSql += " WHERE SBF.BF_FILIAL = '"+xFilial("SBF")+"' "
cSql += "   AND SBF.BF_PRODUTO = '"+cPrd+"' "
cSql += "   AND SBF.BF_LOCAL = '"+cArm+"' "                            //Verificar se estแ no armazem correto
cSql += "   AND SBF.D_E_L_E_T_ = ' ' "
cSql += " GROUP BY SBF.BF_PRODUTO "
cSql += "     , SBF.BF_LOCAL "
cSql += "     , SBF.BF_LOCALIZ "
cSql += "HAVING SUM( SBF.BF_QUANT - SBF.BF_EMPENHO ) > 0 "
                                           
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasBF,.f.,.t.) 	
dbGoTop()

While (cAliasBF)->(! Eof())                                    

	If (cAliasBF)->BF_LIVRE <= ( nEmpenho - nSoma )
		//----------------------------------------------
		// Se tem menos estoque livre no endere็o do que
		// o necessแrio para o empenho:
		// Pega todo o saldo livre do endere็o
		//----------------------------------------------
		nSoma += (cAliasBF)->BF_LIVRE
		AAdd( aEmpenho, { (cAliasBF)->BF_LIVRE,;    // D4_QUANT
		                  (cAliasBF)->BF_LOCALIZ,;  // DC_LOCALIZ
		                   "",;                     // DC_NUMSERI
		                  0,;                       // D4_QTSEGUM
		                  .F.  } )
	Else
		//----------------------------------------------
		// Se tem mais estoque livre no endere็o do que
		// o necessแrio para o empenho:
		// Pega somente o que falta empenhar, deixando
		// o resto do estoque livre.
		//----------------------------------------------
		nSoma += (nEmpenho - nSoma)
		AAdd( aEmpenho, { nSoma                 ,; // D4_QUANT
		                  (cAliasBF)->BF_LOCALIZ,; // DC_LOCALIZ
		                   ""                   ,; // DC_NUMSERI
		                  0                     ,; // D4_QTSEGUM
		                  .F.  } )
	EndIf                          
	
	//-----------------------------------------
	// Se alcan็ou a quantidade necessแria 
	// para o empenho, sai do loop
	//-----------------------------------------
	If nSoma == nEmpenho
		Exit
	EndIf

	dbSelectArea(cAliasBF)
	dbSkip()
Enddo

(cAliasBF)->(dbCloseArea())

RestArea( aArea )                 
     
//---------------------------------------
// Nใo serแ possํvel empenhar a 
// quantidade total necessแria. Mant้m
// os empenhos como estใo
//---------------------------------------
If ( nSoma - nEmpenho ) <> 0
	Return( nil )
EndIf
                         
//---------------------------------------
// Apaga o empenho atual. ษ necessแrio
// apagar o empenho atual para diminuir
// B2_QEMP. 
//---------------------------------------
dbSelectArea("SD4")
dbGoTo(nRecno)     

lMsErroAuto := .F.
 
aVetor:={   {"D4_COD"     ,SD4->D4_COD     ,Nil},; //COM O TAMANHO EXATO DO CAMPO
            {"D4_LOCAL"   ,SD4->D4_LOCAL   ,Nil},;
            {"D4_OP"      ,SD4->D4_OP      ,Nil},;
            {"D4_DATA"    ,SD4->D4_DATA    ,Nil},;
            {"D4_QTDEORI" ,SD4->D4_QTDEORI ,Nil},;
            {"D4_QUANT"   ,SD4->D4_QUANT   ,Nil},;
            {"D4_TRT"     ,SD4->D4_TRT     ,Nil},;
            {"D4_QTSEGUM" ,SD4->D4_QTSEGUM ,Nil}}
             
MSExecAuto({|x,y| mata380(x,y)},aVetor,5 ) 

//---------------------------------------
// Se nใo conseguiu apagar o empenho sem
// endere็o, nใo continua a rotina
//---------------------------------------
If lMsErroAuto
    Alert("Erro ao excluir empenho por endere็o")
    MostraErro()
	lOSErro:=.T.
    Return( nil )
EndIf
                              
lMsErroAuto := .F.
MSExecAuto({|x,y| mata380(x,y,z)},aVetor,3, aEmpenho ) 

If lMsErroAuto
    Alert("Erro ao incluir empenho por endere็o")
	lOSErro:=.T.
    MostraErro()
EndIf

Return( nil )
                                        



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProgramav ณ FS_GrvPla   บ Autor ณAntonio C. Damaceno บ Data ณ  31/10/17บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Tela para informar e gravar os Planos de Couro e Lectra    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Static Function FS_GrvPla()

Local lRet := .T.
Local oDlg
Local nOpc
Local nLastKey := 0 
Local oTButton1, oTButton2

//Monta interface com o usuแrio
DEFINE MSDIALOG oDlg TITLE "PLANOS LECTRA/COURO" FROM C(010),C(010) TO C(225),C(359) PIXEL

@ C(003),C(003) TO C(260),C(360) LABEL "Informe os Planos a serem Gravados" PIXEL OF oDlg

@ C(033),C(008) Say "Plano Lectra:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(033),C(050) MsGet oPlanoMP Var cPlanoMP Size C(081),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg   VALID FS_XPla(cPlanoMP)

@ C(053),C(008) Say "Plano Couro:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(053),C(050) MsGet oPlanoCO Var cPlanoCO Size C(081),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg   VALID FS_XPla(cPlanoCO)

oTButton1 := TButton():New( 120, 065, 'Confirmar',oDlg,{||nOpc := 1,oDlg:End() }, 50,10,,,.F.,.T.,.F.,,.F.,,,.F. )   
oTButton2 := TButton():New( 120, 120, 'Fechar'   ,oDlg,{||nOpc := 2,oDlg:End() }, 50,10,,,.F.,.T.,.F.,,.F.,,,.F. )   

ACTIVATE MSDIALOG oDlg CENTERED

If nOpc == 1

	If Empty(cPlanoMP) .or. Empty(cPlanoCO)
		Alert('Campo nใo pode ficar em branco !!!')
		lRet:=.F.
		Return(lRet)  
	EndIf
	
Else
	lRet:=.F.
EndIf

Return(lRet)  



//valida para nใo deixar campo do plano Lectra e Couro em branco ou vazio.
Static Function FS_XPLA(cParam)

	Local lRet:=.T.
	
	If Empty(cParam)
		Alert('Campo nใo pode ficar em branco ou vazio!!!')
		lRet:=.F.
		Return(lRet)  
	EndIf
                         
Return(lRet)
