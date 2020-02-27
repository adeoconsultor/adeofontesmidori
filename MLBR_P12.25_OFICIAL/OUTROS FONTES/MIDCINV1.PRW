#include 'totvs.ch'
#include 'topconn.ch'
#include 'parmtype.ch'

//==========================================================================================
// MIDCINV1 - Antonio Carlos - Advpl Tecnologia - Novembro / 2016
//------------------------------------------------------------------------------------------
// Descrição
// Monitor do Inventario personalizado.
//------------------------------------------------------------------------------------------
// Parametros
// nenhum
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
user function MIDCINV1()

Local oPerg, nLoop
Local oGrdInv    := nil
Local dDataI     := SuperGetMV("MV_DTIINI",.F.,"")
Local dDataF     := SuperGetMV("MV_DTIFIM",.F.,"")

Private cSql     := ""
Private cPerg    := "MIDCINV1"
Private aHead    := {}
Private nPRODUTO := 0
Private nLOTE    := 0
Private nLEITU   := 0
Private nCODETQ  := 0
Private oDlg, oGridPrd

oPerg := AdvplPerg():New( cPerg )

//-------------------------------------------------------------------
//    AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
// Parametriza as perguntas
//-------------------------------------------------------------------
oPerg:AddPerg( "Armazem","C",TamSx3("B1_LOCPAD")[1], , , "NNR",,)
oPerg:AddPerg( "Grupo"  ,"C",TamSx3("B1_GRUPO")[1] , , , "SBM",,)
//oPerg:AddPerg( "Produto","C",TamSx3("B1_COD")[1]   , , , "SB1")
oPerg:SetPerg()

If ! Pergunte( cPerg, .t. )
	Return( nil )
EndIf

//-----------------------------------------------
// Seleciona os registros
//-----------------------------------------------

cSql := " SELECT '','', "
cSql += "        ZZS.ZZS_DOC DOCUMENTO , "
cSql += "        ZZS.ZZS_CODPRO PRODUTO, "
cSql += "        ZZS.ZZS_LOCAL ARMAZEM , "
cSql += "        ZZS.ZZS_LOTE LOTE     , "
cSql += "        SB1.B1_DESC DESCRICAO , "
cSql += "        ZZS.ZZS_USR USUARIO   , "
cSql += "        ZZS.ZZS_LEITU LEITU   , "
cSql += "        ZZS.ZZS_QTDE  QTDE   , "
cSql += "        ZZS.ZZS_DTVALI DTVALID , "
cSql += "        ZZS.ZZS_CCUSTO CCUSTO , "
cSql += "        ZZS.ZZS_CODETQ CODETQ , "
cSql += "        ZZS.ZZS_ENCERR ENCERRAR "
//		ZZS_DTINV  := dData

cSql += "  FROM " + RetSqlName("ZZS") + " ZZS  "
cSql += "  INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
cSql += "                           SB1.B1_COD = ZZS.ZZS_CODPRO AND "
If ! Empty( mv_par02 )
	cSql += "						   SB1.B1_GRUPO = '"+Trim(mv_par02)+"' AND "
EndIf
cSql += "						   SB1.D_E_L_E_T_ = ' ' "
cSql += "   WHERE ZZS.ZZS_FILIAL  = '" + xFilial("ZZS") + "' "

//If ! Empty( mv_par01 ) // teste
cSql += "     AND ZZS.ZZS_LOCAL   = '"+Trim(mv_par01)+"' "
//EndIf

cSql += "     AND ZZS.ZZS_ENCERR <> 'S' "
cSql += "     AND ZZS.D_E_L_E_T_  = ' ' "
//	cSql += "     AND ZZS.ZZS_CODPRO  BETWEEN  "
cSql += "     AND ZZS.ZZS_DTINV BETWEEN '" + DtoS(dDataI) + "' AND '" + DtoS(dDataF) + "' "
cSql += "     ORDER BY ZZS.ZZS_DOC, ZZS.ZZS_CODPRO, ZZS.ZZS_LOTE, ZZS.ZZS_CODETQ "
cSql := ChangeQuery( cSql )

//-----------------------------------------------
// Monta a dialog
//-----------------------------------------------
oDlg:= uAdvplDlg():New(  "Monitor do Inventário", .t., .t., , nil, 100, 100 )
//PesqPict('ZZS',"ZZS_QTDE")
Aadd(aHead, {   "Encerrar"    , "Encerrar" , "@!"               , 1                       , 0 , ".t.", "", "C", ""   , "R","","", ".t.", "A", ""} )
Aadd(aHead, {   "Docto"       , "DOCUMENTO", "@!"               , TamSX3("B7_DOC"    )[1] , 0 , ".f.", "", "C", ""   , "R","","", ".f.", "A", ""} )
Aadd(aHead, {   "Armazém"     , "ARMAZEM"  , "@!"               , TamSx3("B7_LOCAL"  )[1] , 0 , ".f.", "", "C", ""   , "R","","", ".f.", "A", ""} )
Aadd(aHead, {   "Descrição"   , "DESCRICAO", "@!"               , TamSx3("B1_DESC"   )[1] , 0 , ".f.", "", "C", ""   , "R","","", ".f.", "A", ""} )
Aadd(aHead, {   "Produto"     , "PRODUTO"  , "@!"               , TamSX3("B7_COD"    )[1] , 0 , ".f.", "", "C", ""   , "R","","", ".f.", "A", ""} )
Aadd(aHead, {   "Lote"        , "LOTE"     , "@!"               , TamSx3("B7_LOTECTL")[1] , 0 , ".f.", "", "C", ""   , "R","","", ".f.", "A", ""} )
Aadd(aHead, {   "Dt Validade" , "DTVALID"  , "@!"               , TamSx3("ZZS_DTVALI")[1] , 0 , ".f.", "", "D", ""   , "R","","", ".f.", "A", ""} )
Aadd(aHead, {   "Contagem"    , "LEITU"    , "@!"               , TamSx3("ZZS_LEITU" )[1] , 0 , ".f.", "", "C", ""   , "R","","", ".f.", "A", ""} )
Aadd(aHead, {   "Qtde"        , "QTDE"     , PesqPict('ZZS',"ZZS_QTDE")              ,14                       , 4 , ".f.", "", "N", ""   , "R","","", ".f.", "A", ""} )
Aadd(aHead, {   "C.Custo"     , "CCUSTO"   , "@!"               , TamSx3("ZZS_CCUSTO")[1] , 0 , ".f.", "", "C", ""   , "R","","", ".f.", "A", ""} )
Aadd(aHead, {   "Usuário"     , "USUARIO"  , "@!"               , TamSx3("ZZS_USR"   )[1] , 0 , ".f.", "", "C", ""   , "R","","", ".f.", "A", ""} )
Aadd(aHead, {   "Cod Etq"     , "CODETQ"   , "@!"               , TamSx3("ZZS_CODETQ")[1] , 0 , ".f.", "", "C", ""   , "R","","", ".f.", "A", ""} )
Aadd(aHead, {   " "           , ""         , "@!"               , 3                       , 0 , ".f.", "", "C", ""   , "V","","", ".f.", "A", ""} )

oGrdInv:= MyGrid():New( 000, 000, 000, 000, GD_UPDATE,,,,,, 99999,,,, oDlg:oPnlCenter )

For nLoop := 1 to Len( aHead )
	oGrdInv:AddColumn( aHead[nLoop] )
Next nLoop

oGrdInv:AddColBMP("MARCA","UNCHECKED_15")

oGrdInv:SeekSet()
oGrdInv:IndexSet()
oGrdInv:SheetSet()
//	oGrdInv:AddButton( "Encerrar Inventário"   , { || Processa( {|| MontaInv()}, "Aguarde..." ) } )
oGrdInv:AddButton( "Encerrar Inventário"   , { || Processa( {|| MonEncInv(@oGrdInv) }, "Aguarde..." ) } )
oGrdInv:Load()
oGrdInv:FromSql( cSql )
oGrdInv:SetAlignAllClient()

//oGrdInv:oGrid:bFieldOk := {|| FieldOk(oGrdInv) }
oGrdInv:SetDoubleClick( {|| oGrdInv:SetField("MARCA", IIF(oGrdInv:GetField("MARCA") == "BR_VERDE","UNCHECKED_15", MarDes(@oGrdInv) )) } )

nPRODUTO := aScan(oGrdInv:aHeader, {| aVet | aVet[2] == "PRODUTO"})
nLOTE    := aScan(oGrdInv:aHeader, {| aVet | aVet[2] == "LOTE"   })
nLEITU   := aScan(oGrdInv:aHeader, {| aVet | aVet[2] == "LEITU"  })
nCODETQ  := aScan(oGrdInv:aHeader, {| aVet | aVet[2] == "CODETQ" })

oDlg:SetInit( {|| oGrdInv:Refresh(.t.)})
oDlg:Activate()

return( nil )

static Function MarDes(oGrd)
//==========================================================================================
// MarDes - Paulo Oliveira - Advpl Tecnologia - Novembro / 2016
//------------------------------------------------------------------------------------------
// Descrição
// Marca ou desmarca a linha
//------------------------------------------------------------------------------------------
// Parametros
// oGrd - objeto mygrid
//------------------------------------------------------------------------------------------
// Retorno
// lRet - "UNCHECKED_15" ou "BR_VERDE"
//==========================================================================================
Local lRet := "UNCHECKED_15"
Local nPos := 0
Local nPosC:= 0
//Local cLeTMP := IIf(oGrd:GetField("LEITU", oGrd:GetAt()) = "A", "B", "A")
Local cETQ   := oGrd:GetField("CODETQ", oGrd:GetAt())
Local cLeTMP := IIf( SUBSTR( TRIM(cETQ), LEN(TRIM(cETQ)), 1) = "A", "B", "A" )

nPosC := ASCAN(oGrd:aCols, {| aVet | aVet[nPRODUTO]+aVet[nLOTE]+trim(aVet[nCODETQ]) == oGrd:GetField("PRODUTO", oGrd:GetAt())+oGrd:GetField("LOTE", oGrd:GetAt())+SUBSTR( TRIM(cETQ), 1, LEN(TRIM(cETQ))-1)+"C" })
if nPosC > 0
	oGrd:SetField("MARCA", "BR_VERDE", nPosC)
	lRet := "UNCHECKED_15"
	
else
	
	//nPos := ASCAN(oGrd:aCols, {| aVet | aVet[nPRODUTO]+aVet[nLOTE]+aVet[nLEITU] == oGrd:GetField("PRODUTO", oGrd:GetAt())+oGrd:GetField("LOTE", oGrd:GetAt())+cLeTMP })
	nPos := ASCAN(oGrd:aCols, {| aVet | aVet[nPRODUTO]+aVet[nLOTE]+trim(aVet[nCODETQ]) == oGrd:GetField("PRODUTO", oGrd:GetAt())+oGrd:GetField("LOTE", oGrd:GetAt())+SUBSTR( TRIM(cETQ), 1, LEN(TRIM(cETQ))-1)+cLeTMP })
	
	if ( oGrd:GetField("QTDE", oGrd:GetAt()) >= 0 )  .and. ( SUBSTR( TRIM(oGrd:GetField("CODETQ", oGrd:GetAt()) ), LEN(TRIM(cETQ)), 1)  = "C" )  // existe a 3ª Leitura - marcar a linha
		lRet := "BR_VERDE"
		
	ElseIf ( nPos > 0 ) .AND. ( oGrd:GetField("QTDE", nPos) >= 0 ) .and. ( oGrd:GetField("QTDE", oGrd:GetAt()) == oGrd:GetField("QTDE", nPos ) ) .and. ( oGrd:GetField("CODETQ", oGrd:GetAt()) <> oGrd:GetField("CODETQ", nPos ) ) // 1ª e 2ª iguais marcar a linha
		lRet := "BR_VERDE"
		
	Else
		lRet := "UNCHECKED_15"
		aviso("Atenção!","Confira os campos de Quantidade.",{"OK"})
		
	EndIf
	
EndIf





Return(lRet)


//==========================================================================================
// MonEncInv - Antonio - Advpl Tecnologia - Novembro / 2016
//------------------------------------------------------------------------------------------
// Descrição
// Monta o array com os produtos inventariados
//------------------------------------------------------------------------------------------
// Parametros
// Nenhum
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
Static Function MonEncInv(oGrd)

Local nLoop, nX
Local aSB7 := {}
Local nQuant, nNx := 0
Local cLeitu := " "

Local dDataI     := SuperGetMV("MV_DTIINI",.F.,"")
Local dDataF     := SuperGetMV("MV_DTIFIM",.F.,"")

ProcRegua( 0 )

//
For nLoop := 1 to Len( oGrd:aCols )
	
	IncProc()
	
	//For nX := 1 to oGrdInv:GetField("ETIQ", nLoop)
	if oGrd:GetField("MARCA"  , nLoop) == "BR_VERDE"
		
		// ZZS_FILIAL + ZZS_DOC + ZZS_CODPRO + ZZS_LOTE + ZZS_CODETQ + ZZS_LOCAL
		AAdd( aSB7, {	oGrd:GetField("DOCUMENTO", nLoop),;    // 1
		oGrd:GetField("PRODUTO"  , nLoop),;    // 2
		oGrd:GetField("ARMAZEM"  , nLoop),;    // 3 ZZS_LOCAL
		oGrd:GetField("LOTE"     , nLoop),;    // 4
		oGrd:GetField("USUARIO"  , nLoop),;    // 5
		oGrd:GetField("QTDE"     , nLoop),;    // 6
		oGrd:GetField("LEITU"    , nLoop),;    // 7
		oGrd:GetField("CDCT"     , nLoop),;    // 8
		oGrd:GetField("CODETQ"   , nLoop),;    // 9
		oGrd:GetField("DTVALID"  , nLoop),;    // 10
		oGrd:GetField("CCUSTO"   , nLoop),;     // 11 Centro de Custo   
		oGrd:GetField("CODETQ"    , nLoop);     // 12 Centro de Custo
		} )
		/*
		AAdd( aSB7, {	oGrdInv:GetField("DOCUMENTO", nLoop),;    // 1
		oGrdInv:GetField("PRODUTO"  , nLoop),;    // 2
		oGrdInv:GetField("ARMAZEM"  , nLoop),;    // 3
		oGrdInv:GetField("LOTE"     , nLoop),;    // 4
		oGrdInv:GetField("USUARIO"  , nLoop),;    // 5
		oGrdInv:GetField("QTDE"     , nLoop),;    // 6
		oGrdInv:GetField("CDCT"     , nLoop),;    // 7
		oGrdInv:GetField("ACONT"    , nLoop);     // 8
		} )
		*/
	EndIF
	//Next nX
	
Next nLoop

nTot:=0
nTotAnt:=0
countLoop := 0

If ! Empty( aSB7 )
	SB7->(dbSetOrder(4)) //FILIAL + DOC + LOTECTL + COD + LOCAL
	
	For nNx := 1 to Len(aSB7)
		SB7->( dbGoTop() )
		
		If SB7->(dbSeek(xFilial("SB7")+aSB7[nNx,1]+"   "+aSB7[nNx,4]+aSB7[nNx,2]+aSB7[nNx,3], .T. ))  // EXISTE NA SB7 - filial + documento + lote + produto + Local
			RecLock("SB7",.F.)
			nTot := SB7->B7_QUANT
		Else
			nTot:=0
			nTotAnt:=0
			RecLock("SB7",.T.)  
		EndIf
		
		SB7->B7_FILIAL  := xFilial("SB7")
		SB7->B7_DOC     := aSB7[nNx,1]+"   "
		SB7->B7_COD     := aSB7[nNx,2]
		SB7->B7_LOCAL   := aSB7[nNx,3]
		SB7->B7_LOTECTL := aSB7[nNx,4]
		SB7->B7_TIPO    := Posicione("SB1",1,xFilial("SB1")+aSB7[nNx,2],"B1_TIPO") //BUSCA O B1_TIPO
		//SB7->B7_QUANT   := SB7->B7_QUANT + aSB7[nNx,6]// soma-se as quantidades 
		SB7->B7_QUANT   := aSB7[nNx,6]
		SB7->B7_DATA    := dDataBase
		SB7->B7_DTVALID := dDataBase //aSB7[nNx,10]  // Validade do Lote
		SB7->B7_STATUS  := "1"
		
		SB7->B7_CC      := aSB7[nNx,11] // CC não existe na base testes.
		//		SB7->B7_STATUS  := "1"
		//		SB7->B7_CONTAGE := ""
		MsUnlock()
		
		// Verificar o indice correto.
		
		ZZS->(dbSetOrder(1)) // ZZS_FILIAL   + ZZS_DOC+ ZZS_CODPRO+   ZZS_LOTE+ ZZS_CODETQ+  ZZS_LOCAL
		ZZS->( dbGoTop() )
		//If ZZS->(dbSeek(xFilial("ZZS")+aSB7[nNx,1]+aSB7[nNx,2]+aSB7[nNx,4] )) // LOCALIZA REGISTRO NA ZZS
		//            ZZS_FILIAL   + ZZS_DOC+ ZZS_CODPRO+   ZZS_LOTE+ ZZS_CODETQ+  ZZS_LOCAL
		//If ZZS->(dbSeek(xFilial("ZZS")+aSB7[nNx,1]+aSB7[nNx,2]+aSB7[nNx,4]+aSB7[nNx,9]+aSB7[nNx,3] )) // LOCALIZA REGISTRO NA ZZS
		If ZZS->(dbSeek(xFilial("ZZS")+aSB7[nNx,1]+aSB7[nNx,2]+aSB7[nNx,4]+substr(aSB7[nNx,12],1,8) )) // LOCALIZA REGISTRO NA ZZS
			
			While ZZS->(!Eof()) 
				If xFilial("ZZS")+aSB7[nNx,1]+aSB7[nNx,2]+aSB7[nNx,4]+substr(aSB7[nNx,12],1,8)+aSB7[nNx,3] == ZZS->ZZS_FILIAL+ZZS->ZZS_DOC+ZZS->ZZS_CODPRO+ZZS->ZZS_LOTE+substr(ZZS->ZZS_CODETQ,1,8)+ZZS->ZZS_LOCAL

				    If ZZS->ZZS_ENCERR == 'S' 
				    	ZZS->(DbSkip())
						Loop	
				    Endif
					
					If DtoS(ZZS->ZZS_DTINV) < DtoS(dDataI) .Or. DtoS(ZZS->ZZS_DTINV) > DtoS(dDataF)   //considerar somente os itens inventariados no periodo
						ZZS->(DbSkip())                                                   //do inventario
						Loop
					EndIf	  
								

					RecLock("ZZS",.F.)
					ZZS->ZZS_ENCERR := 'S' // MARCA O REGISTRO COMO ENCERRADO NA TABLEA ZZS
					MsUnlock()
				   	
					If ZZS->ZZS_LEITU == 'A'
	                    
		                nTotAnt:=ZZS_QTDE
						nTot:=nTot+ZZS->ZZS_QTDE

					ElseIf ZZS->ZZS_LEITU == 'B' .And. aSB7[nNx,7] == 'B'
					    
					   	If nNx > 1
					   		If xFilial("ZZS") == cFilAnt .And. aSB7[nNx-1,1] == ZZS->ZZS_DOC .And. aSB7[nNx-1,2] == ZZS->ZZS_CODPRO .And. aSB7[nNx-1,4] == ZZS->ZZS_LOTE .And. substr(aSB7[nNx-1,12],1,9) == substr(ZZS->ZZS_CODETQ,1,8)+'A' .And. aSB7[nNx-1,3] ==	ZZS->ZZS_LOCAL					
									nTot:=nTot-nTotAnt 
							Endif     
						Endif
                                                                     
		            
					ElseIf ZZS->ZZS_LEITU == 'C' 
	
						nTot:=nTot-nTotAnt
	
						nTot:=nTot+ZZS->ZZS_QTDE
				
					Endif
				EndIf				
				
				ZZS->(DbSkip())
			EndDo

			RecLock("SB7",.F.)
			SB7->B7_QUANT   := nTot  // soma-se as quantidades
			MsUnlock()

			//nTot:=0 // Comentado por Diego
			
		EndIf
	Next nX
	
	//oGrd:Refresh()
	oGrd:FromSql( cSql )
	
EndIf

Return( nil )

