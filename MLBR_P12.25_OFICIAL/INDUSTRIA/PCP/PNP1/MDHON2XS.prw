#Include 'Protheus.ch'
#Include 'Parmtype.ch'

#Define ET_DESKIT 1
#Define ET_DESCOMPONENTE 2
#Define ET_QTDKIT 3
#Define ET_NUMSEQ 5
#Define ET_NUMLOTE 6
#Define ET_COMPATLREF 7
#Define ET_NUMPLANO 8
// #Define ET_DTAEMISSAO 5
// #Define ET_QTDPRODUTO 6



//==========================================================================================
// MDJSS01 - Guilherme Suganame - Junho/2019   |   Revisao/Ajuste: //
//------------------------------------------------------------------------------------------
// Descrição
// Impressão de etiquetas de Rack da JSS
//------------------------------------------------------------------------------------------
// Parametros
// nenhum
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================


User Function MDHON2XS()  

	Local oPerg
    
	Private cPerg  := "MDHON2XS"
    // Private aTipo := {"Rack", "Caixa"}
	oPerg := AdvplPerg():New( cPerg )

	//-------------------------------------------------------------------
	// AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
	// Parametriza as perguntas
	//-------------------------------------------------------------------
	oPerg:AddPerg( "Plano"        , "C" , 25 ,   ,      , ""    )
	// oPerg:AddPerg( "Serie"              , "C" , 3 ,   ,      , ""    )
    // oPerg:AddPerg( "Tipo da Etiqueta"   ,     ,   ,   ,aTipo       ) 
	oPerg:SetPerg()

	If ! Pergunte( cPerg, .t. )
		Return( NIL )
	EndIf

	Processa( {|| MontaEtiq()}, "Aguarde..." ) 

return( NIL )
                                                                 


//==========================================================================================
// MontaEtiq - Antonio - Advpl Tecnologia - Dez / 2018    |     Revisao/Ajuste: 
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
 
    Local cDataLote := substr(DtoS(dDataBase), 3, 4)
    Local KitTemp   := GetNextAlias()
    Local CompTemp   := GetNextAlias()
	Local FacaTemp   := GetNextAlias()    
    Local cSerial := ""
    Local cSql := ""
    // Local RecCount := 0

    Local aEtiq := {}
    local aFaca := {}

    local cET_DESKIT := ""
    local nET_QTDKIT := 0
    local cET_NUMLOTE := ""
    local cET_NUMSEQ := ""
    local cET_NUMPLANO := ""
    local cET_DESCOMPONENTE := ""    
    local cET_COMPATLREF := ""    

    dbSelectArea("SX6")
	dbSetOrder(1)
	If ! dbSeek( xFilial("SX6") + 'MA_HON2XS' )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6") 
		SX6->X6_VAR     := 'MA_HON2XS'
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Serial Autoliv"
		SX6->X6_CONTEUD := '1'
		MsUnlock()
	EndIf
    

    cSql := ""
    cSql += "SELECT "
    cSql += "   SZP.ZP_PRODUTO AS COD_KIT, "
    cSql += "   SZP.ZP_NUM AS NUM_LOTE, "
    cSql += "   SB1.B1_DESC AS DES_KIT, "
    cSql += "   SZP.ZP_QUANT AS QTD_KIT "
    cSql += "FROM SZP010 AS SZP "
    cSql += "LEFT JOIN SB1010 AS SB1 "
    cSql += "ON SZP.ZP_PRODUTO = SB1.B1_COD "
    cSql += "AND SB1.D_E_L_E_T_ = '' "
    cSql += "WHERE SZP.ZP_OPMIDO = '"+ AllTrim(MV_PAR01) +"' "
    cSql += "AND SZP.D_E_L_E_T_ = '' "

    If Select("KitTemp") > 0
        dbSelectArea("KitTemp")
		dbCloseArea(KitTemp)
	EndIf

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),KitTemp,.T.,.T.)
    (KitTemp)->(dbGoTop())

    While (KitTemp)->(!Eof())
        cET_DESKIT := AllTrim( (KitTemp)->DES_KIT )
        nET_QTDKIT := (KitTemp)->QTD_KIT
        cET_NUMLOTE := AllTrim(cDataLote) + AllTrim( (KitTemp)->NUM_LOTE )
        cET_NUMPLANO := AllTrim( MV_PAR01 )
        
        
        cSql := ""
        cSql += "SELECT "
        cSql += " SG1.G1_COD AS COD_COMPONENTE, "
        cSql += " SB1.B1_DESC AS DES_COMPONENTE, "
        cSql += " SB1.B1_ATLREF AS COMP_ATLREF, "
        cSql += " SG1.G1_COMP AS COD_FACA "
        cSql += "FROM SG1010 AS SG1 "
        cSql += "LEFT JOIN SB1010 AS SB1 "
        cSql += "ON SG1.G1_COMP = SB1.B1_COD "
        cSql += "AND SB1.D_E_L_E_T_ = '' "
        cSql += "WHERE SG1.G1_COD = '"+ allTrim( (KitTemp)->COD_KIT ) +"' "
        cSql += "AND SG1.G1_FILIAL = '"+ xFilial("SG1") +"' "
        cSql += "AND SG1.G1_FIM >= '"+ DtoS( dDataBase ) +"' "
        cSql += "AND SG1.D_E_L_E_T_ = '' "

        If Select("CompTemp") > 0
            dbSelectArea("CompTemp")
            dbCloseArea(CompTemp)
        EndIf

        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),CompTemp,.T.,.T.)
        (CompTemp)->(dbGoTop())

        While (CompTemp)->(!Eof())

            cET_DESCOMPONENTE := AllTrim( (CompTemp)->DES_COMPONENTE )
            cET_COMPATLREF := AllTrim( (CompTemp)->COMP_ATLREF )
            cET_NUMSEQ := StrZero(Val(GetMV("MA_HON2XS")), 10)

            aFaca := {}

            cSql := ""
            cSql += "SELECT "
            cSql += " SG1.G1_COMP AS COD_FACA, "
            cSql += " SB1.B1_ATLREF AS DES_ATLREF, "
            cSql += "     CASE "
            cSql += "         WHEN SB1.B1_DESC LIKE '%PERF%' THEN 0 "
            cSql += "         ELSE 1 "
            cSql += "     END AS TIPO_FACA "
            cSql += "FROM SG1010 AS SG1 "
            cSql += "LEFT JOIN SB1010 AS SB1 "
            cSql += "ON SG1.G1_COMP = SB1.B1_COD "
            cSql += "AND SB1.D_E_L_E_T_ = '' "
            cSql += "WHERE SG1.G1_COD = '"+ allTrim( (CompTemp)->COD_FACA ) +"' "
            cSql += "AND SG1.G1_FIM >= '"+ DtoS( dDataBase ) +"' "
            cSql += "AND SG1.D_E_L_E_T_ = '' "
            cSql += "ORDER BY TIPO_FACA "

            If Select("FacaTemp") > 0
                dbSelectArea("FacaTemp")
                dbCloseArea(FacaTemp)
            EndIf

            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),FacaTemp,.T.,.T.)
            (FacaTemp)->(dbGoTop())

            While (FacaTemp)->(!Eof())
                if( (FacaTemp)->TIPO_FACA = 0 )
                    AAdd(aFaca, AllTrim((FacaTemp)->DES_ATLREF) + ' PERF')
                Else
                    Aadd(aFaca, AllTrim((FacaTemp)->DES_ATLREF))
                EndIf
                (FacaTemp)->(dbSkip()) 
            EndDo

            (FacaTemp)->(dbCloseArea())

            Aadd( aEtiq, { cET_DESKIT ,;
                        cET_DESCOMPONENTE ,;
                        nET_QTDKIT ,;
                        aFaca ,;
                        cET_NUMSEQ ,;
                        cET_NUMLOTE ,;
                        cET_COMPATLREF, ;
                        cET_NUMPLANO })

            cSerial := Val(GetMV("MA_HON2XS")) + 1

            dbSelectArea("SX6")
            dbSetOrder(1)
            If dbSeek( xFilial("SX6") + 'MA_HON2XS' )
                RecLock( "SX6",.F. )
                SX6->X6_CONTEUD := Str(cSerial)
                MsUnlock()
            EndIf


            (CompTemp)->(dbSkip())
        EndDo

        (CompTemp)->(dbCloseArea())
        
        (KitTemp)->(dbSkip())
        
        // cET_CODCOMPONENTE := allTrim( (CompTemp)->COD_COMPONENTE )
        // cET_DESCOMPONENTE := allTrim( (CompTemp)->DES_COMPONENTE )
        // nET_QTDCOMPONENTE :=  (CompTemp)->QTD_COMPONENTE
        // cET_NUMSEQUENCIAL := StrZero(Val(GetMV("MA_HON2XS")), 10)
        // cET_NUMLOTE := cDataLote + StrZero(Val(MV_PAR01), 9)
        // cET_COMPATLREF := allTrim( (CompTemp)->DES_COMPATLREF )

        // aFaca := {}

        // cSql := ""
        // cSql += " SELECT "
        // cSql += "     SG1.G1_COMP, "
        // cSql += "     SB1.B1_ATLREF AS DES_ATLREF, "
        // cSql += "     CASE "
        // cSql += "         WHEN SB1.B1_DESC LIKE '%PERF%' THEN 0 "
        // cSql += "         ELSE 1 "
        // cSql += "     END AS TIPO_FACA "
        // cSql += " FROM SG1010 AS SG1 "
        // cSql += " INNER JOIN SB1010 AS SB1 "
        // cSql += " ON SG1.G1_COMP = SB1.B1_COD "
        // cSql += " AND SB1.D_E_L_E_T_ = '' "
        // cSql += " WHERE SG1.G1_COD = '"+ cET_CODCOMPONENTE +"' "
        // cSql += " AND SG1.G1_FIM >= '"+ DtoS( dDataBase ) +"' "
        // cSql += " AND SG1.G1_FILIAL = '"+ xFilial("SG1") +"' "
        // cSql += " AND SG1.D_E_L_E_T_ = '' "
        // cSql += " ORDER BY TIPO_FACA "

        // If Select("FacaTemp") > 0
        //     dbCloseArea(FacaTemp)
        // EndIf

        // dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),FacaTemp,.T.,.T.)
        // (FacaTemp)->(dbGoTop())

        // While (FacaTemp)->(!Eof())
        //     if( (FacaTemp)->TIPO_FACA = 0 )
        //         AAdd(aFaca, AllTrim((FacaTemp)->DES_ATLREF) + ' PERF')
        //     Else
        //         Aadd(aFaca, AllTrim((FacaTemp)->DES_ATLREF))
        //     EndIf
        //     (FacaTemp)->(dbSkip()) 
        // EndDo

        // (FacaTemp)->(dbCloseArea())
        
        // Aadd( aEtiq, { cET_DESMODELO ,;
        //                cET_DESCOMPONENTE ,;
        //                nET_QTDCOMPONENTE ,;
        //                aFaca ,;
        //                cET_NUMSEQUENCIAL ,;
        //                cET_NUMLOTE ,;
        //                cET_COMPATLREF })

        // cSerial := Val(GetMV("MA_HON2XS")) + 1

        // dbSelectArea("SX6")
        // dbSetOrder(1)
        // If dbSeek( xFilial("SX6") + 'MA_HON2XS' )
        //     RecLock( "SX6",.F. )
        //     SX6->X6_CONTEUD := Str(cSerial)
        //     MsUnlock()
        // EndIf

        // (CompTemp)->(dbSkip()) 

    EndDo

	If ! Empty( aEtiq )
  		ImpEt( aEtiq )
	EndIf

    (KitTemp)->(dbCloseArea())

    // (CompTemp)->(dbCloseArea())

Return( NIL )


//==========================================================================================
// ImpEt - Antonio - Advpl Tecnologia - Fevereiro / 2018
//------------------------------------------------------------------------------------------
// Descrição
// Impressão de etiquetas de Rack da JSS.
//------------------------------------------------------------------------------------------
// Parametros
// aEtiq - Array de etiquetas
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
Static Function ImpEt( aEtiq )

	Local cTempDir := GetTempPath()
	Local cFile    := "ETIQHON2XS"+StrTran( Time(), ":", "" ) + ".PRN" 
	Local nHdl     := -1
	Local nLoop    := 0
    Local nLoop2    := 0
    Local nQtdEtiqueta := 0

	nHdl := FCreate( cTempDir+cFile ) 
	If nHdl < 0
		apMsgAlert("Erro na geração do arquivo temporário. Erro : " + AllTrim(Str(FError())) )
	EndIf

    For nLoop := 1 to Len( aEtiq )
    // For nLoop := 1 to 1
        FWrite(nHdl, " CT~~CD,~CC^~CT~ " + CRLF)
        FWrite(nHdl, " ^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ " + CRLF)
        FWrite(nHdl, " ^XA " + CRLF)
        FWrite(nHdl, " ^MMT " + CRLF)
        FWrite(nHdl, " ^PW591 " + CRLF)
        FWrite(nHdl, " ^LL1678 " + CRLF)
        FWrite(nHdl, " ^LS0 " + CRLF)
        FWrite(nHdl, " ^FT127,1626^A0B,56,64^FH\^FD"+ aEtiq[nLoop, ET_DESKIT] +"^FS " + CRLF)
        FWrite(nHdl, " ^FT337,716^A0B,59,69^FH\^FD"+ AllTrim(Transform(aEtiq[nLoop, ET_QTDKIT],"@E 999999")) +"^FS " + CRLF)
        FWrite(nHdl, " ^FT565,836^A0B,39,50^FH\^FDMIDORI AUTO LEATHER BRASIL^FS " + CRLF)
        FWrite(nHdl, " ^FT231,1629^A0B,39,43^FH\^FD"+ aEtiq[nLoop, ET_DESCOMPONENTE] +"^FS " + CRLF)        
        For nLoop2 := 1 to Len( aEtiq[nLoop, 4] )
            if nLoop2 = 1
                FWrite(nHdl, " ^FT337,1661^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][1] +"^FS " + CRLF)            
            ElseIf nLoop2 = 2
                FWrite(nHdl, " ^FT377,1661^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][2] +"^FS " + CRLF)
            ElseIf nLoop2 = 3
                FWrite(nHdl, " ^FT418,1661^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][3] +"^FS " + CRLF) 
            ElseIf nLoop2 = 4
                FWrite(nHdl, " ^FT457,1662^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][4] +"^FS " + CRLF) 
            ElseIf nLoop2 = 5
                FWrite(nHdl, " ^FT497,1662^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][5] +"^FS " + CRLF) 
            ElseIf nLoop2 = 6
                FWrite(nHdl, " ^FT538,1662^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][6] +"^FS " + CRLF) 
            ElseIf nLoop2 = 7
                FWrite(nHdl, " ^FT337,1397^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][7] +"^FS " + CRLF) 
            ElseIf nLoop2 = 8
                FWrite(nHdl, " ^FT377,1397^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][8] +"^FS " + CRLF) 
            ElseIf nLoop2 = 9
                FWrite(nHdl, " ^FT418,1397^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][9] +"^FS " + CRLF) 
            ElseIf nLoop2 = 10
                FWrite(nHdl, " ^FT458,1397^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][10] +"^FS " + CRLF) 
            ElseIf nLoop2 = 11
                FWrite(nHdl, " ^FT498,1397^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][11] +"^FS " + CRLF) 
            ElseIf nLoop2 = 12
                FWrite(nHdl, " ^FT538,1398^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][12] +"^FS " + CRLF) 
            ElseIf nLoop2 = 13
                FWrite(nHdl, " ^FT338,1133^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][13] +"^FS " + CRLF) 
            ElseIf nLoop2 = 14
                FWrite(nHdl, " ^FT378,1133^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][14] +"^FS " + CRLF) 
            ElseIf nLoop2 = 15
                FWrite(nHdl, " ^FT418,1133^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][15] +"^FS " + CRLF) 
            ElseIf nLoop2 = 16
                FWrite(nHdl, " ^FT458,1134^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][16] +"^FS " + CRLF) 
            ElseIf nLoop2 = 17
                FWrite(nHdl, " ^FT498,1133^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][17] +"^FS " + CRLF) 
            ElseIf nLoop2 = 18
                FWrite(nHdl, " ^FT539,1134^A0B,25,24^FH\^FD"+ aEtiq[nLoop, 4][18] +"^FS " + CRLF) 
            EndIf        
        Next nLoop2
           
        FWrite(nHdl, " ^FT175,1643^A0B,17,19^FH\^FDCOMPONENTE^FS " + CRLF)
        FWrite(nHdl, " ^FT385,383^A0B,17,19^FH\^FDPLANO^FS " + CRLF)
        FWrite(nHdl, " ^FT450,383^A0B,45,45^FH\^FD"+ aEtiq[nLoop, ET_NUMPLANO] +"^FS" + CRLF)
        FWrite(nHdl, " ^FT284,513^A0B,17,19^FH\^FDLOTE^FS " + CRLF)
        FWrite(nHdl, " ^FT339,506^A0B,51,55^FH\^FD"+ aEtiq[nLoop, ET_NUMLOTE] +"^FS " + CRLF)
        FWrite(nHdl, " ^FT385,879^A0B,17,19^FH\^FDSEQUENCIAL^FS " + CRLF)
        FWrite(nHdl, " ^FT460,837^A0B,56,55^FH\^FD"+ aEtiq[nLoop, ET_NUMSEQ] +"^FS " + CRLF)
        FWrite(nHdl, " ^FT523,875^A0B,17,19^FH\^FDFORNECEDOR^FS " + CRLF)
        FWrite(nHdl, " ^FT61,1645^A0B,17,19^FH\^FDMODELO^FS " + CRLF)
        FWrite(nHdl, " ^FT287,1659^A0B,17,19^FH\^FDCONTE\E9DO DA EMBALAGEM^FS " + CRLF)
        FWrite(nHdl, " ^FO493,0^GB0,887,4^FS " + CRLF)
        FWrite(nHdl, " ^FO359,0^GB0,888,4^FS " + CRLF)
        FWrite(nHdl, " ^FT284,879^A0B,17,19^FH\^FDQUANT. (KT)^FS " + CRLF)
        FWrite(nHdl, " ^FO260,0^GB0,1678,2^FS " + CRLF)
        FWrite(nHdl, " ^FT65,225^BQN,2,6 " + CRLF)
        // FWrite(nHdl, " ^FH\^FDLA,S0000000001 P4063605-20 Q000060000 1T190700053291^FS " + CRLF)
        FWrite(nHdl, " ^FH\^FDLA,"+ "S" + aEtiq[nLoop, ET_NUMSEQ] + " P" + aEtiq[nLoop, ET_COMPATLREF] + " Q" + PadR(PadL( AllTrim(Str(aEtiq[nLoop, ET_QTDKIT])), 6, "0" ), 9, "0") + " 1T"+ aEtiq[nLoop, ET_NUMLOTE] + "^FS" + CRLF)        
        FWrite(nHdl, " ^LRY^FO363,402^GB131,0,2^FS^LRN " + CRLF)
        FWrite(nHdl, " ^LRY^FO262,534^GB99,0,2^FS^LRN " + CRLF)
        FWrite(nHdl, " ^LRY^FO311,1156^GB236,0,3^FS^LRN " + CRLF)
        FWrite(nHdl, " ^LRY^FO311,1420^GB236,0,2^FS^LRN " + CRLF)
        FWrite(nHdl, " ^LRY^FO261,887^GB330,0,2^FS^LRN " + CRLF)
        FWrite(nHdl, " ^PQ1,0,1,Y^XZ " + CRLF)

    Next nLoop

    
 
	FClose( nHdl )
	WinExec( "CMD /C TYPE " + cTempDir + cFile + " > " + "LPT1")

	
Return( NIL )
