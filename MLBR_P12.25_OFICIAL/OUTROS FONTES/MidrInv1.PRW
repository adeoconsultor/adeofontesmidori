#include 'protheus.ch'
#include 'parmtype.ch'

#define ET_CODIGO       1
#define ET_SEQUENCIA    2
#define ET_LINHA1       3  
#define ET_LINHA2       4
#define ET_TIPO         5
#define ET_UM           6
#define ET_LOTE         7
#define ET_BARRA0       8
#define ET_BARRA1       9
#define ET_BARRA2      10
#define ET_BARRA3      11
#define ET_BARRA4      12
#define ET_BARRA5      13

//#define ET_BARRA      8

//==========================================================================================
// MidrInv1 - Alessandro Freire - Advpl Tecnologia - Novembro / 2016
//------------------------------------------------------------------------------------------
// Descrição
// Impressão de etiquetas de codigo de barra para inventário personalizado.
//------------------------------------------------------------------------------------------
// Parametros
// nenhum
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
user function MidrInv1()

	Local oPerg, cSql := ""
	Local nLoop
	Private cPerg := "MIDRINV1"
	Private oDlg, oGridPrd
	Private aHead := {}
	Private aPorta := {"LPT1","LPT2","LPT3"}
	oPerg := AdvplPerg():New( cPerg )

	//-------------------------------------------------------------------
	//    AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
	// Parametriza as perguntas
	//-------------------------------------------------------------------
	oPerg:AddPerg( "Armazem"                   ,"C",TamSx3("B1_LOCPAD")[1], ,         , "NNR",,"@!")   //1      MV_PAR01
	oPerg:AddPerg( "Grupo"                     ,"C",TamSx3("B1_GRUPO")[1] , ,         , "SBM")         //2      ..
	oPerg:AddPerg( "Produto"                   ,"C",TamSx3("B1_COD")[1]   , ,         , "SB1")         //3      ..
	oPerg:AddPerg( "Sequência(S/N)"            ,   ,                      , ,{"S","N"},     ,)         //4      ..
	oPerg:AddPerg( "Porta Impressão"           ,   ,                      , ,aPorta          )         //5      ..
	oPerg:AddPerg( "Com Saldo(S/N)"            ,   ,                      , ,{"S","N"},     ,)         //6      ..
	oPerg:AddPerg( "Ordem Impressão(Cod/Descr)",   ,                      , ,{"C","D"},     ,)         //7      ..
	oPerg:AddPerg( "Lote"                      ,"C",10                    , ,         ,      ,,'@!')   //8      MV_PAR08                
	oPerg:AddPerg( "C.Custo"                   ,"C",TamSx3("CTT_CUSTO")[1]   , ,         ,      ,,'@!')   //9      MV_PAR09                
	oPerg:SetPerg()

//	oPerg:AddPerg( "Proxima Sequência"       ,"C",TamSx3("B1_LOCPAD")[1], , ,      )

	If ! Pergunte( cPerg, .t. )
		Return( nil )
	EndIf

 /*	If !Empty(mv_par08)

		aRet:=StrTokArr(mv_par08,",")
        cxLote1:=""
		For nLin := 1 to Len(aRet)
			cxLote := aRet(nLin)
			If nLin > 1
				cxLote1 += ","
			EndIf		
			cxLote1 += "'"+cxLote+"'"
		Next

    EndIf
   */
    
/*	If MV_PAR04 == 1
		If Empty(MV_PAR03)
			Alert("Você não pode solicitar a sequência para vários produtos, escolha somente um produto para impressão do proximo sequencial!")
			Return( nil )
		EndIf
	EndIf
  */

	If MV_PAR06 == 1  //com saldo

		//-----------------------------------------------
		// Seleciona os registros
		//-----------------------------------------------
		cSql += "SELECT SB2.B2_COD PRODUTO "
		cSql += "     , SB2.B2_LOCAL ARMAZEM "
		cSql += "	  , COALESCE( SB8.B8_LOTECTL, ' ' ) LOTE "
		cSql += "	  , SB1.B1_DESC DESCRICAO "
		cSql += "	  , SB1.B1_TIPO TIPOX "
		cSql += "	  , SB1.B1_UM UMX "
		cSql += "	  , SB1.B1_GRUPO GRUPOX "
		cSql += "	  , 1 ETIQ "
		cSql += "  FROM "+RetSqlName("SB2")+" SB2 "
	
		cSql += "  INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
		cSql += "                           SB1.B1_COD = SB2.B2_COD AND "
		If !Empty( mv_par02 )
			cSql += "						   SB1.B1_GRUPO = '"+Trim(mv_par02)+"' AND "
		EndIf
		cSql += "						   SB1.D_E_L_E_T_ = ' ' "
	
		cSql += "  LEFT JOIN "+RetSqlName("SB8")+" SB8 ON SB8.B8_FILIAL = '"+xFilial("SB8")+"' AND " 
		cSql += "                          SB8.B8_PRODUTO = SB1.B1_COD AND "
		cSql += "                          SB8.B8_LOCAL = SB2.B2_LOCAL AND "
		cSql += "						  SB8.B8_SALDO > 0 AND "
		cSql += "						   SB8.D_E_L_E_T_ = ' ' AND"
		cSql += "						  SB1.B1_RASTRO = 'L' "

		cSql += " WHERE SB2.B2_FILIAL = '"+xFilial("SB2")+"' " 
		cSql += "   AND SB2.B2_QATU > 0 "
		If !Empty( mv_par01 )
			cSql += "   AND SB2.B2_LOCAL = '"+Trim(mv_par01)+"' "
		EndIf
		If !Empty( mv_par03 )
			cSql += "   AND SB2.B2_COD = '"+Trim(mv_par03)+"' "
		EndIf
		cSql += "   AND SB2.D_E_L_E_T_ = ' ' "

		If !Empty( mv_par08 )
			cSql += "                          AND SB8.B8_LOTECTL IN('"+Trim(mv_par08)+"') "
		EndIf

		If MV_PAR07 == 1  //'C'                            //Impressão por ordem de codigo
			cSql += "   ORDER BY SB2.B2_COD "
		Else                                               //Impressão por ordem de descrição
			cSql += "   ORDER BY SB1.B1_DESC "
		EndIf
		
	Else                                                            //sem saldo
		//-----------------------------------------------
		// Seleciona os registros
		//-----------------------------------------------
		cSql += "SELECT SB2.B2_COD PRODUTO "
		cSql += "     , SB2.B2_LOCAL ARMAZEM "
		cSql += "	  , COALESCE( SB8.B8_LOTECTL, ' ' ) LOTE "
		cSql += "	  , SB1.B1_DESC DESCRICAO "
		cSql += "	  , SB1.B1_TIPO TIPOX "
		cSql += "	  , SB1.B1_UM UMX "
		cSql += "	  , SB1.B1_GRUPO GRUPOX "
		cSql += "	  , 1 ETIQ "
		cSql += "  FROM "+RetSqlName("SB2")+" SB2 "
	
		cSql += "  INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
		cSql += "                           SB1.B1_COD = SB2.B2_COD AND "
		If !Empty( mv_par02 )
			cSql += "						   SB1.B1_GRUPO = '"+Trim(mv_par02)+"' AND "
		EndIf
		cSql += "						   SB1.D_E_L_E_T_ = ' ' "
	
		cSql += "  LEFT JOIN "+RetSqlName("SB8")+" SB8 ON SB8.B8_FILIAL = '"+xFilial("SB8")+"' AND " 
		cSql += "                          SB8.B8_PRODUTO = SB1.B1_COD AND "
		cSql += "                          SB8.B8_LOCAL   = SB2.B2_LOCAL AND "
		cSql += "						   SB8.B8_SALDO   = 0 AND "
		cSql += "						   SB8.D_E_L_E_T_ = ' ' AND"
		cSql += "						   SB1.B1_RASTRO  = 'L' "
	
		cSql += " WHERE SB2.B2_FILIAL = '"+xFilial("SB2")+"' " 
		cSql += "   AND SB2.B2_QATU = 0 "
		If !Empty( mv_par01 )
			cSql += "   AND SB2.B2_LOCAL = '"+Trim(mv_par01)+"' "
		EndIf
		If !Empty( mv_par03 )
			cSql += "   AND SB2.B2_COD = '"+Trim(mv_par03)+"' "
		EndIf
		cSql += "   AND SB2.D_E_L_E_T_ = ' ' "	

		If !Empty( mv_par08 )
			cSql += "                          AND SB8.B8_LOTECTL IN('"+Trim(mv_par08)+"') "
		EndIf

		If MV_PAR07 == 1                             //Impressão por ordem de codigo
			cSql += "   ORDER BY SB2.B2_COD "
		Else                                         //Impressão por ordem de descrição
			cSql += "   ORDER BY SB1.B1_DESC "
		EndIf

	EndIf
   	//MemoWrite("C:\TEMP\etiquetainvp1.TXT", cSql)
	cSql := ChangeQuery( cSql )

	cAliascSQL1:=GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliascSQL1,.T.,.T.)                                

	If (cAliascSQL1)->(Eof())
		If !Empty(MV_PAR08)  //LOTE
			If MsgYesNo("Produto com Lote não possui Saldos Iniciais, Deseja Incluir?")

				If SB9->(!dbSeek(xFilial("SB9")+MV_PAR03+MV_PAR01 )) //FILIAL+PRODUTO+LOCAL - ORDEM 1
					Reclock("SB9",.T.)
					SB9->B9_FILIAL := xFilial("SB9")
					SB9->B9_COD    := MV_PAR03
					SB9->B9_LOCAL  := MV_PAR01
					SB9->B9_QINI   := 0
					MsUnlock()			
				EndIf				

				If SB2->(!dbSeek(xFilial("SB2")+MV_PAR03+MV_PAR01 )) //FILIAL+PRODUTO+LOCAL - ORDEM 1
					Reclock("SB2",.T.)
					SB2->B2_FILIAL := xFilial("SB2")
					SB2->B2_COD    := MV_PAR03
					SB2->B2_LOCAL  := MV_PAR01
					SB2->B2_QATU   := 0
					MsUnlock()			
				EndIf				
				
				SB8->(dbSetOrder(3))
				If SB8->(!dbSeek(xFilial("SB8")+MV_PAR03+MV_PAR01+MV_PAR08 ))   //FILIAL+PRODUTO+LOCAL+LOTECTL+NUMLOTE+DATAVALID - ORDEM 3
					Reclock("SB8",.T.)
					SB8->B8_FILIAL  := xFilial("SB8")
					SB8->B8_PRODUTO := MV_PAR03
					SB8->B8_LOCAL   := MV_PAR01
					SB8->B8_QTDORI  := 0
					SB8->B8_DATA    := dDataBase
					SB8->B8_SALDO   := 0
					SB8->B8_ORIGLAN := 'MN'
					SB8->B8_LOTECTL := MV_PAR08
					SB8->B8_DTVALID := dDataBase
					SB8->B8_DOC     := 'INICIAL'
					SB8->B8_DFABRIC := dDataBase
					MsUnlock()			
				EndIf				

				(cAliascSQL1)->(dbCloseArea()) 
				cSql := "" 			
				//-----------------------------------------------
				// Seleciona os registros
				//-----------------------------------------------
				cSql += "SELECT SB2.B2_COD PRODUTO "
				cSql += "     , SB2.B2_LOCAL ARMAZEM "
				cSql += "	  , COALESCE( SB8.B8_LOTECTL, ' ' ) LOTE "
				cSql += "	  , SB1.B1_DESC DESCRICAO "
				cSql += "	  , SB1.B1_TIPO TIPOX "
				cSql += "	  , SB1.B1_UM UMX "
				cSql += "	  , SB1.B1_GRUPO GRUPOX "
				cSql += "	  , 1 ETIQ "
				cSql += "  FROM "+RetSqlName("SB2")+" SB2 "
			
				cSql += "  INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
				cSql += "                           SB1.B1_COD = SB2.B2_COD AND "
				If ! Empty( mv_par02 )
					cSql += "						   SB1.B1_GRUPO = '"+Trim(mv_par02)+"' AND "
				EndIf
				cSql += "						   SB1.D_E_L_E_T_ = ' ' "
			
				cSql += "  LEFT JOIN "+RetSqlName("SB8")+" SB8 ON SB8.B8_FILIAL = '"+xFilial("SB8")+"' AND " 
				cSql += "                          SB8.B8_PRODUTO = SB1.B1_COD AND "
				cSql += "                          SB8.B8_LOCAL   = SB2.B2_LOCAL AND "
				cSql += "						   SB8.B8_SALDO   = 0 AND "
				cSql += "						   SB8.D_E_L_E_T_ = ' ' AND"
				cSql += "						   SB1.B1_RASTRO  = 'L' "
			
				cSql += " WHERE SB2.B2_FILIAL = '"+xFilial("SB2")+"' " 
//				cSql += "   AND SB2.B2_QATU = 0 "
				If ! Empty( mv_par01 )
					cSql += "   AND SB2.B2_LOCAL = '"+Trim(mv_par01)+"' "
				EndIf
				If ! Empty( mv_par03 )
					cSql += "   AND SB2.B2_COD = '"+Trim(mv_par03)+"' "
				EndIf
				cSql += "   AND SB2.D_E_L_E_T_ = ' ' "	
		
				If ! Empty( mv_par08 )
					cSql += "                          AND SB8.B8_LOTECTL IN('"+Trim(mv_par08)+"') "
				EndIf
		
				If MV_PAR07 == 1                             //Impressão por ordem de codigo
					cSql += "   ORDER BY SB2.B2_COD "
				Else                                         //Impressão por ordem de descrição
					cSql += "   ORDER BY SB1.B1_DESC "
				EndIf
		
				//MemoWrite("C:\TEMP\etiquetainvp1.TXT", cSql)
				cSql := ChangeQuery( cSql )

			EndIf
		EndIf	
	EndIf


	//-----------------------------------------------
	// Monta a dialog
	//-----------------------------------------------
	oDlg:= uAdvplDlg():New(  "Etiquetas para inventário", .t., .t., , nil, 100, 100 )


	Aadd(aHead, { "Produto"    , "PRODUTO"  , "@!"     , TamSX3("B1_COD")[1]    , 0 , ".f.", "", "C", ""   , "R","","", ".f.", "A", ""} )
	Aadd(aHead, { "Armazém"    , "ARMAZEM"  , "@!"     , TamSx3("B1_LOCPAD")[1] , 0 , ".f.", "", "C", ""   , "R","","", ".f.", "A", ""} )
	Aadd(aHead, { "Lote"       , "LOTE"     , "@!"     , TamSx3("B8_LOTECTL")[1], 0 , ".f.", "", "C", ""   , "R","","", ".f.", "A", ""} )
	Aadd(aHead, { "Descrição"  , "DESCRICAO", "@!"     , TamSx3("B1_DESC")[1]   , 0 , ".f.", "", "C", ""   , "R","","", ".f.", "A", ""} )
	Aadd(aHead, { "Etiquetas"  , "ETIQ"     , "@E 9999", 4                      , 0 , ".t.", "", "N", ""   , "R","","", ".t.", "A", ""} )
	Aadd(aHead, { "Tipo"       , "TIPOX"    , "@!"     , TamSx3("B1_TIPO")[1]   , 0 , ".f.", "", "C", ""   , "R","","", ".f.", "A", ""} )
	Aadd(aHead, { "UM"         , "UMX"      , "@!"     , TamSx3("B1_UM")[1]     , 0 , ".f.", "", "C", ""   , "R","","", ".f.", "A", ""} )

	oGrdEtiq:= MyGrid():New( 000, 000, 000, 000, GD_UPDATE,,,,,, 99999,,,, oDlg:oPnlCenter )

	For nLoop := 1 to Len( aHead )
		oGrdEtiq:AddColumn( aHead[nLoop] )
	Next nLoop

	oGrdEtiq:SeekSet()
	oGrdEtiq:IndexSet()
	oGrdEtiq:SheetSet()
	oGrdEtiq:AddButton( "Imprimir"   , { || Processa( {|| MontaEtiq()}, "Aguarde..." ) } )
	oGrdEtiq:Load()
	oGrdEtiq:FromSql( cSql )
	oGrdEtiq:SetAlignAllClient()       

	oDlg:SetInit( {|| oGrdEtiq:Refresh(.T.)})
	oDlg:Activate()

return( nil )

//==========================================================================================
// MontaEtiq - Alessandro Freire - Advpl Tecnologia - Novembro / 2016
//------------------------------------------------------------------------------------------
// Descrição
// Monta o array com as etiquetas
//------------------------------------------------------------------------------------------
// Parametros
// Nenhum
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
Static Function MontaEtiq()
                                              
	Local nLoop, nX, nxEtq
	Local aEtiq := {}
	Local cSequencia := "", cSoma := "00", cBarra0, cBarra1, cBarra2, cBarra3, cBarra4, cBarra5, cLote, cCodPro
	Local cAliasXZT  := "", lRet:=.F.,cSeque1

	ProcRegua( 0 )

	// Imprime as linhas do grid
	For nLoop := 1 to Len( oGrdEtiq:aCols )

		For nX := 1 to oGrdEtiq:GetField("ETIQ", nLoop)
			
			IncProc()
			
			// Imprime n vezes a mesma linha do grid com sequenciais diferentes
			// somente imprime as linhas que não estiverem com 0
			If MV_PAR04 == 1
				cCodPro:=AllTrim(oGrdEtiq:GetField("PRODUTO", nLoop) )
				cLote:=oGrdEtiq:GetField("LOTE", nLoop)
				
				cAliasXZT   := GetNextAlias()
	
				cSql := "SELECT ZZT.ZZT_CODETQ , ZZT.ZZT_SEQUEN, ZZT.ZZT_CODPRO,"
				cSql += " ZZT.ZZT_LOTE, SB1.B1_DESC, ZZT.ZZT_LOCAL "
				cSql += "  FROM " + RetSqlName("ZZT") + " ZZT  "
	
				cSql += "  INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL  = '"+xFilial("SB1")+"' AND "
				cSql += "                                          SB1.B1_COD     = ZZT.ZZT_CODPRO AND "
				cSql += "						                   SB1.D_E_L_E_T_ = ' ' "
	
				cSql += "  WHERE ZZT.ZZT_FILIAL  = '" + xFilial("ZZT") + "' AND "
				cSql += "        ZZT.D_E_L_E_T_  = ' '                AND " 
				cSql += "        ZZT.ZZT_CODPRO  = '" + cCodPro  + "' AND "
				cSql += "        ZZT_LOTE        = '" + cLOTE    + "' AND "
				cSql += "        ZZT.ZZT_LOCAL   = '" + MV_PAR01 + "' "  
				cSql += "AND SUBSTRING(RIGHT(RTRIM(ZZT_CODETQ),9),1,6) = '" + SubStr(DtoS(dDataBase),3) + "' " 

				If MV_PAR07 == 1                            //Impressão por ordem de codigo
					cSql += "   ORDER BY ZZT.ZZT_CODPRO, ZZT_SEQUEN "
				Else                                         //Impressão por ordem de descrição
					cSql += "   ORDER BY SB1.B1_DESC, ZZT_SEQUEN "
				EndIf
				
				//MemoWrite("C:\TEMP\etiquetainvp1.TXT", cSql)	
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasXZT,.T.,.T.) 
				dbSelectArea(cAliasXZT)
	
				If (cAliasXZT)->(!Eof())
					lRet:=.T.
					While (cAliasXZT)->(!Eof())
						cSoma       := SubStr((cAliasXZT)->ZZT_SEQUEN,7,2)
						cSeque1     := SubStr((cAliasXZT)->ZZT_SEQUEN,1,6)
						(cAliasXZT)->(dbSkip())
					End
				Else
					cSoma := "00"
					lRet:=.F.
				EndIf
				(cAliasXZT)->(dbCloseArea())  			
				
			Else
				cSoma := "00"
			EndIf
				
			cSoma      := Soma1(cSoma)
			If !lRet
				cSequencia := SubStr(DtoS(dDataBase),3)
			Else
				cSequencia := cSeque1
			EndIf

			cSequencia += cSoma

///inicio da alteração do sequencial novo()
			nSeqGer:=0
			cSeqOrd := SubStr(Alltrim(Str(Year(dDataBase))),3,2)+Alltrim(StrZero(Month(dDataBase),2))   //(AAMM)

			cNewAliXZT := GetNextAlias()
			cSql := "SELECT MAX(ZZT_SEQGER) SEQGER "
			cSql += "  FROM " + RetSqlName("ZZT") + " ZZT "
			cSql += "  WHERE ZZT.ZZT_FILIAL  = '" + xFilial("ZZT") + "' AND "
			cSql += "        ZZT.D_E_L_E_T_  = ' ' AND " 
			cSql += "        SUBSTRING(ZZT.ZZT_SEQUEN,1,4) = '" + cSeqOrd + "' "
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cNewAliXZT,.T.,.T.) 
			If (cNewAliXZT)->(!Eof())
				cBarra5 := Soma1(StrZero(Val((cNewAliXZT)->SEQGER),6))
			Else
				cBarra5 := Soma1(StrZero(nSeqGer,6))
			EndIf                            
			(cNewAliXZT)->(dbCloseArea())
///Fim da alteração do sequencial novo()

			For nxEtq := 1 to 4
	
				cBarra0 := AllTrim(oGrdEtiq:GetField("ARMAZEM", nLoop) ) //+ '>6|>5' 

				cBarra1 := AllTrim(oGrdEtiq:GetField("PRODUTO", nLoop) ) //+ '>6|>5' 
	
				cLote:=oGrdEtiq:GetField("LOTE", nLoop)
	
	
				cBarra2 := If( Empty(cLote), '' , AllTrim(cLote) ) //+ '>6|>5' 
	
				cBarra3 := AllTrim( cSequencia )
	
				cBarra4 := IIf(nxEtq==1,'A', IIf(nxEtq==2,'B',IIf(nxEtq==3,'C','P') ) )
				
				AAdd( aEtiq, {	oGrdEtiq:GetField("PRODUTO", nLoop),;
								cSequencia,;
								SubStr(oGrdEtiq:GetField("DESCRICAO", nLoop),1,26),;
								SubStr(oGrdEtiq:GetField("DESCRICAO", nLoop),27),;
								oGrdEtiq:GetField("TIPOX", nLoop),;
								oGrdEtiq:GetField("UMX", nLoop),;
								oGrdEtiq:GetField("LOTE", nLoop),;
								cBarra0,;                        //8    ARMAZEM
								cBarra1,;                        //9    produto
								cBarra2,;                        //10    lote
								cBarra3,;                        //11   sequencia
								cBarra4,;                        //12   a,b,c,p
								cBarra5 } )                      //13   000001

	
				If cBarra4 <> 'P'
	                dbSelectArea("ZZT")
	                dbSetOrder(1)   //era indice 2 (etq+local)

					If	!dbSeek(xFilial("ZZT")+AllTrim(cBarra0)+AllTrim(cBarra1)+IIf(Empty(AllTrim(cBarra2)), AllTrim(cBarra2) ,AllTrim(cBarra2))+AllTrim(cBarra3)+cBarra4)
	
						Reclock("ZZT",.T.)
						ZZT->ZZT_FILIAL  := xFilial("ZZT")
						ZZT->ZZT_CODETQ  := AllTrim(cBarra0)+AllTrim(cBarra1)+IIf(Empty(AllTrim(cBarra2)), AllTrim(cBarra2) ,AllTrim(cBarra2))+AllTrim(cBarra3)+cBarra4
						ZZT->ZZT_LOCAL   := AllTrim(cBarra0)
						ZZT->ZZT_CCUSTO  := MV_PAR09
						ZZT->ZZT_CODPRO  := AllTrim(cBarra1)
						ZZT->ZZT_LOTE    := AllTrim(cBarra2)
						ZZT->ZZT_SEQUEN  := AllTrim(cBarra3)+AllTrim(cBarra4)
						ZZT->ZZT_SEQGER  := AllTrim(cBarra5)

					//	ZZT->ZZT_DTVALI  := dDataBase + 1780    //cData
						MsUnlock()
	
					EndIf
	
				EndIf
	
				If cSoma == "ZZ"
					cSoma := "00"
				EndIf
				
			Next nX
	
		Next nLoop
	
	Next nxEtq
    //                 8      11
	//aEtiq := { { '038053', 'P' }, { '038053', 'A' }, { '038053', 'B' } }
	//	ASORT(aEtiq,,,{ | x,y | (x[11]+x[8]+x[9]) < (y[11]+x[8]+x[9]) } )	

	If ! Empty( aEtiq )
		ImpEt( aEtiq )
	EndIf

Return( nil )

//==========================================================================================
// ImpEt - Alessandro Freire - Advpl Tecnologia - Novembro / 2016
//------------------------------------------------------------------------------------------
// Descrição
// Impressão de etiquetas de codigo de barra para inventário personalizado.
//------------------------------------------------------------------------------------------
// Parametros
// aEtiq - Array de etiquetas
// { { Produto, Sequencial, Descr Linha 1, Descr Linha 2, tipo, UM, Lote, Código de Barras } }
// Código de barras formado por
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
Static Function ImpEt( aEtiq )

	Local cTempDir := GetTempPath()
	Local cFile    := "ETIQ"+StrTran( Time(), ":", "" ) + ".PRN" 
	Local nHdl     := -1
	Local nLoop    := 0
	Local dMMMAAAA:=SubStr(CMonth(dDataBase),1,3)+" "+Alltrim(Str(Year(dDataBase)))

	
	//MSCBPRINTER( "ZEBRA", aPorta[mv_par05],,,.f.,,,,)//,/* [ nDensidade ]*/, /*[ nTamanho ]*/, .F., /*"1290"*/, /*"172.17.0.161"*/, /*[ cEnv ]*/, /*[ nMemoria ]*/, /*cSpool*/, /*[ lDrvWin ]*/, /*[ cPathSpool ]*/ )
	//MSCBCHKSTATUS(.f.)

	nHdl := FCreate( cTempDir+cFile ) 
	//alert(cTempDir+cFile) //exibe diretorio gravacao arquivo temporario etiqueta
	If nHdl < 0
		apMsgAlert("Erro na geração do arquivo temporário. Erro : " + AllTrim(Str(FError())) )
	EndIf
	
	For nLoop := 1 to Len( aEtiq )
		IncProc()
		//MSCBBEGIN(1,4)


		// Parametrizacao da etiqueta
		FWrite(nHdl,"CT~~CD,~CC^~CT~"+CRLF)
		FWrite(nHdl,"^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ"+CRLF)
		FWrite(nHdl,"^XA"+CRLF)
		FWrite(nHdl,"^MMT"+CRLF)
		FWrite(nHdl,"^PW799"+CRLF)

		FWrite(nHdl,"^LL0480"+CRLF)
		FWrite(nHdl,"^LS0"+CRLF)

		// 1a linha
		FWrite(nHdl,"^FT41,36^A0N,28,28^FH\^FDCodigo: "+Trim(aEtiq[nLoop,ET_CODIGO])+"^FS"+CRLF) // Código do produto

		// 2a Linha
		FWrite(nHdl,"^FT40,71^A0N,28,43^FH\^FD"+Trim(aEtiq[nLoop,ET_LINHA1])+"^FS"+CRLF) // 1a linha da descricao do produto

		// 3a Linha
		FWrite(nHdl,"^FT41,106^A0N,28,43^FH\^FD"+Trim(aEtiq[nLoop,ET_LINHA2])+"^FS"+CRLF) // 2a linha da descricao do produto

		// 4a Linha
		FWrite(nHdl,"^FT42,142^A0N,28,28^FH\^FDTipo: "  +Trim(aEtiq[nLoop,ET_TIPO])   + "^FS"+CRLF) // Tipo do produto
		FWrite(nHdl,"^FT252,34^A0N,28,28^FH\^FDArm: "   +Trim(aEtiq[nLoop,ET_BARRA0]) + "^FS"+CRLF) // ARMAZEM
		FWrite(nHdl,"^FT331,143^A0N,28,28^FH\^FD"       +Trim(aEtiq[nLoop,ET_BARRA4]) + "^FS"+CRLF) // ABC - Contagens do estoque
		FWrite(nHdl,"^FT166,143^A0N,28,28^FH\^FDUM: "   +Trim(aEtiq[nLoop,ET_UM])     + "^FS"+CRLF) // Unidade de medida do produto
		FWrite(nHdl,"^FT416,144^A0N,28,28^FH\^FDLOTE: " +Trim(aEtiq[nLoop,ET_LOTE])   + "^FS"+CRLF) // Lote do produto

		// 5a Linha
		FWrite(nHdl,"^BY2,3,94^FT42,267^BCN,,Y,N"+CRLF) // Parametriza o código de barras? 
//		cBarra:=aEtiq[nLoop,ET_BARRA0]+" >5"+aEtiq[nLoop,ET_BARRA1]+">6 >5"+aEtiq[nLoop,ET_BARRA2]+">6 >5"+aEtiq[nLoop,ET_BARRA3]+">6"+aEtiq[nLoop,ET_BARRA4]
////		cBarra:=">6"+aEtiq[nLoop,ET_BARRA0]+">5"+aEtiq[nLoop,ET_BARRA1]+">6"+aEtiq[nLoop,ET_BARRA2]+">5"+aEtiq[nLoop,ET_BARRA3]+">6"+aEtiq[nLoop,ET_BARRA4]

		cBarra:=aEtiq[nLoop,ET_BARRA0]+aEtiq[nLoop,ET_BARRA1]+aEtiq[nLoop,ET_BARRA2]+">5"+aEtiq[nLoop,ET_BARRA3]+">6"+aEtiq[nLoop,ET_BARRA4]

		FWrite(nHdl,"^FD"+cBarra+"^FS"+CRLF) // String do Código de barras
		FWrite(nHdl,"^FT372,33^A0N,28,36^FH\^FDSeq: "+aEtiq[nLoop,ET_SEQUENCIA]+"^FS"+CRLF) // Sequencia

		If Trim(aEtiq[nLoop,ET_BARRA4]) <> 'P'           //so imprime estes dados se for <> 'P'
			FWrite(nHdl,"^FO43,304^GB212,96,8^FS"+CRLF)                                       //Retangulo da qtde
			FWrite(nHdl,"^FT121,431^A0N,28,28^FH\^FDQtde^FS"+CRLF)                            //Quantidade
			FWrite(nHdl,"^FO349,392^GB352,0,3^FS"+CRLF)                                       //Linha da assinatura
			FWrite(nHdl,"^FT494,426^A0N,28,28^FH\^FDNome^FS"+CRLF)                            //Nome
		EndIf
		
		FWrite(nHdl,"^FT330,445^A0N,28,28^FH\^FD "+dMMMAAAA+"^FS"+CRLF)           //Dez 2017

		FWrite(nHdl,"^FT693,38^A0N,28,28^FH\^FD"+Trim(aEtiq[nLoop,ET_BARRA5])+"^FS"+CRLF)    //Sequencial (novo)

		// Finaliza a etiqueta
		FWrite(nHdl,"^PQ1,0,1,Y^XZ"+CRLF)
 
		//MSCBEND()
	Next nLoop                                    
	FClose( nHdl )
	
	WinExec( "CMD /C TYPE " + cTempDir + cFile + " > " + aPorta[mv_par05])
	//MSCBCLOSEPRINTER()
	
Return( nil )	
             

//Pesquisa do Lote para retirar o '-'
Static Function UPESQ(cLote,cPesq)
	
    Local aRet  := {}
    Local cRet  := ''
	Default cPesq := "-"
	
	aRet:=StrTokArr(cLote,cPesq)

	If Len(aRet) > 0
		cRet := aRet[1]
		IF Len(aRet) > 1
			cRet += aRet[2]
		EndIf
	Else
		cRet := cLote
	EndIf
	
Return(cRet)                                                    
                                                  
