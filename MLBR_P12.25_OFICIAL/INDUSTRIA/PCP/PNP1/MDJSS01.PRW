#Include 'Protheus.ch'
#Include 'Parmtype.ch'

#Define ET_ATLREF 1
#Define ET_CODBAR 2
#Define ET_DESPRODUTO 3
#Define ET_NUMLOTE 4
#Define ET_DTAEMISSAO 5
#Define ET_QTDPRODUTO 6


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


User Function MDJSS01()  

	Local oPerg
	Local cSql    := ""

	Private cPerg  := "MDJSS01"
    Private aTipo := {"Rack", "Caixa"}
	oPerg := AdvplPerg():New( cPerg )

	//-------------------------------------------------------------------
	// AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
	// Parametriza as perguntas
	//-------------------------------------------------------------------
    oPerg:AddPerg( "OPs"        , "C" , 27 ,   ,      , ""    )
	// oPerg:AddPerg( "Multiplo"        , "N" ,  2,   ,      , ""    )
	// oPerg:AddPerg( "Serie"              , "C" , 3 ,   ,      , ""    )
    oPerg:AddPerg( "Tipo da Etiqueta"   ,     ,   ,   ,aTipo       ) 
	oPerg:SetPerg()

	If ! Pergunte( cPerg, .t. )
		Return( nil )
	EndIf

	Processa( {|| MontaEtiq()}, "Aguarde..." ) 

return( nil )
                                                                 


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
    Local dAnoAtual := Year(dDataBase)
    Local aOP := Strtokarr2( MV_PAR01, ";")
    Local aProdOP := {}
    Local nQuantTotal := 0
    Local AliasOP := GetNextAlias()
    Local aEtiq       := {}

    Local cET_DESPRODUTO  := ""
    Local cET_NUMLOTE    := ""
    Local cET_DTAEMISSAO    := ""
    Local nET_QTDPRODUTO    := 0
    Local cET_ATLREF := ""
    Local cET_CODBAR := ""
    Local I

    For I := 1 TO Len(aOP) Step 1                               
        cSql := ""
        cSql += "SELECT "
        cSql += "SC2.C2_PRODUTO AS COD_PRODUTO, "
        cSql += "SB1.B1_ATLREF AS DES_ATLREF, "
        cSql += "SB1.B1_DESC AS DES_PRODUTO, "
        cSql += "CONCAT( SUBSTRING(SC2.C2_DATRF, 7, 2), '/', SUBSTRING(SC2.C2_DATRF, 5, 2), '/', SUBSTRING(SC2.C2_DATRF, 1, 4) ) AS DTA_EMISSAO, "
        cSql += "SC2.C2_QUANT AS QTD_PRODUTO "
        cSql += "FROM SC2010 AS SC2 "
        cSql += "INNER JOIN SB1010 AS SB1 "
        cSql += "ON SC2.C2_PRODUTO = SB1.B1_COD "
        cSql += "AND SB1.D_E_L_E_T_ = '' "
        cSql += "WHERE C2_NUM = '"+ AllTrim(aOP[I]) +"' "
        cSql += "AND SC2.D_E_L_E_T_ = '' "

        If Select("AliasOp") > 0
            dbCloseArea(AliasOp)    
        EndIf

        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),AliasOp,.T.,.T.)

        While (AliasOp)->(!Eof())
            if I > 1
                If AllTrim((AliasOp)->COD_PRODUTO) != aProdOP[I - 1]
                    Alert('Produto de produção da OP ' + AllTrim(aOP[I]) + ' é divergente das demais OPS')
                    Exit
                EndIf
            Else
                
                cET_DESPRODUTO := AllTrim((AliasOp)->DES_PRODUTO)
                cET_ATLREF := AllTrim((AliasOp)->DES_ATLREF)
                cET_DTAEMISSAO := AllTrim((AliasOp)->DTA_EMISSAO)
            EndIf
            AAdd(aProdOP, AllTrim((AliasOp)->COD_PRODUTO))
            nQuantTotal += (AliasOp)->QTD_PRODUTO
            (AliasOp)->(dbSkip())
        EndDo

        (AliasOp)->(dbCloseArea())

    Next 

    dbSelectArea("SX6")
    dbSetOrder(1)
    If ! dbSeek( xFilial("SX6") + "MA_ETQJSS" )
        RecLock("SX6",.T.)
        SX6->X6_FIL     := xFilial("SX6") 
        SX6->X6_VAR     := "MA_ETQJSS"
        SX6->X6_TIPO    := "C"
        SX6->X6_DESCRIC := "Serial JSS"
        SX6->X6_CONTEUD := "201800001"
        MsUnlock()
    EndIf

    If SubStr(AllTrim(Str(Val(GetMV("MA_ETQJSS")))), 1, 4) <> AllTrim(Str(Year(dDataBase)))
        If dbSeek( xFilial("SX6") + 'MA_ETQJSS' )
            RecLock( "SX6",.F. )
            SX6->X6_CONTEUD := AllTrim(Str( Year(dDataBase) ) + "00001")
            MsUnlock()
        EndIf
    EndIf

    nET_QTDPRODUTO := nQuantTotal
    cET_CODBAR := allTrim(PADL(Val(GetMV("MA_ETQJSS")), 9, "0"))
    cET_NUMLOTE := SubStr(cET_DTAEMISSAO, 9, 2) + SubStr(cET_DTAEMISSAO, 4, 2) + SubStr(cET_DTAEMISSAO, 1, 2) + SubStr(AllTrim(Str(Val(GetMV("MA_ETQJSS")))), 6, 4)

    AAdd( aEtiq, {	cET_ATLREF ,;
                cET_CODBAR ,;
                cET_DESPRODUTO ,;
                cET_NUMLOTE ,;
                cET_DTAEMISSAO ,;
                nET_QTDPRODUTO } ) 	

    cSerial := AllTrim(Str(Val(GetMV("MA_ETQJSS")) + 1))
	
	        // Grava o proximo serial livre
    dbSelectArea("SX6")
    dbSetOrder(1)
    If dbSeek( xFilial("SX6") + 'MA_ETQJSS' )
        RecLock( "SX6",.F. )
        SX6->X6_CONTEUD := cSerial
        MsUnlock()
    EndIf

    

	If ! Empty( aEtiq )
  		ImpEt( aEtiq )
	EndIf

	// (cAliasTST)->(dbCloseArea())

Return( nil )


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
	Local cFile    := "ETIQJSS"+StrTran( Time(), ":", "" ) + ".PRN" 
	Local nHdl     := -1
	Local nLoop    := 0
    Local nLoopQtd    := 0
    Local nQtdEtiqueta := 0

	nHdl := FCreate( cTempDir+cFile ) 
	If nHdl < 0
		apMsgAlert("Erro na geração do arquivo temporário. Erro : " + AllTrim(Str(FError())) )
	EndIf

    If MV_PAR02 == 1
        For nLoop := 1 to Len( aEtiq )

            FWrite(nHdl, "CT~~CD,~CC^~CT~" + CRLF)
            FWrite(nHdl, "^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ" + CRLF)
            FWrite(nHdl, "^XA" + CRLF)
            FWrite(nHdl, "^MMT" + CRLF)
            FWrite(nHdl, "^PW591" + CRLF)
            FWrite(nHdl, "^LL1678" + CRLF)
            FWrite(nHdl, "^LS0" + CRLF)
            FWrite(nHdl, "^FO320,0^GFA,06784,06784,00004,:Z64:" + CRLF)
            FWrite(nHdl, "eJztw0ENAAAMA6GTPukz0SckdJWqqqqqqqqOPLAYRy4=:F487" + CRLF)
            FWrite(nHdl, "^FO256,0^GFA,06784,06784,00004,:Z64:" + CRLF)
            FWrite(nHdl, "eJztw7ENAAAMAiDj/0f3CbdCQpNUVVVVVVXV91cOyekNHQ==:71BC" + CRLF)
            FWrite(nHdl, "^FT79,1005^A0B,34,33^FH\^FDTO^FS" + CRLF)
            FWrite(nHdl, "^FT386,929^A0B,34,33^FH\^FD"+  AllTrim(aEtiq[nLoop, ET_NUMLOTE]) +"^FS" + CRLF) // LOTE
            FWrite(nHdl, "^FT79,1652^A0B,34,33^FH\^FDFROM^FS" + CRLF)
            FWrite(nHdl, "^FT176,1654^A@B,28,29,TT0003M_^FH\^CI17^F8^FDPENAPOLIS - SP^FS^CI0" + CRLF)
            FWrite(nHdl, "^FT146,1655^A@B,28,29,TT0003M_^FH\^CI17^F8^FDAV. ANTONIO VERONESE, 1007^FS^CI0" + CRLF)
            FWrite(nHdl, "^FT116,1653^A@B,28,29,TT0003M_^FH\^CI17^F8^FDMIDORI AUTO LEATHER BRASIL LTDA^FS^CI0" + CRLF)
            FWrite(nHdl, "^FT207,1654^A@B,28,29,TT0003M_^FH\^CI17^F8^FDalexandre.sanches@midoriautoleather.com.br^FS^CI0" + CRLF)
            FWrite(nHdl, "^FO488,0^GB0,1678,1^FS" + CRLF)
            FWrite(nHdl, "^FO408,0^GB0,1105,1^FS" + CRLF)
            FWrite(nHdl, "^FT350,1672^A0B,20,19^FH\^FDLICENSE PLATE (1J):^FS" + CRLF)
            FWrite(nHdl, "^BY3,3,62^FT432,1623^BCB,,N,N" + CRLF)
            FWrite(nHdl, "^FD>:1J>50003935"+ aEtiq[nLoop, ET_CODBAR] +"^FS" + CRLF) // CodBarras
            FWrite(nHdl, "^FT82,347^A@B,28,29,TT0003M_^FH\^CI17^F8^FDMADE IN ^FS^CI0" + CRLF)
            FWrite(nHdl, "^FT124,347^A@B,28,29,TT0003M_^FH\^CI17^F8^FDBRAZIL^FS^CI0" + CRLF)
            FWrite(nHdl, "^FT177,1007^A@B,28,29,TT0003M_^FH\^CI17^F8^FDJUNDIAI - SP^FS^CI0" + CRLF)
            FWrite(nHdl, "^FT316,1495^A0B,34,33^FH\^FD"+ AllTrim(aEtiq[nLoop, ET_ATLREF]) +"^FS" + CRLF) // ATLREF
            FWrite(nHdl, "^FT466,278^A0B,34,33^FH\^FD"+ AllTrim(Str(aEtiq[nLoop, ET_QTDPRODUTO])) +".000^FS" + CRLF) // QUANTIDADE
            FWrite(nHdl, "^FT567,1603^A0B,34,33^FH\^FD"+ AllTrim(StrTran(MV_PAR01, ";", ",")) +"^FS" + CRLF) // OP
            FWrite(nHdl, "^FT466,896^A0B,34,33^FH\^FDJUI3935^FS" + CRLF) // LOTE
            FWrite(nHdl, "^FT385,310^A0B,34,33^FH\^FD"+ AllTrim(aEtiq[nLoop, ET_DTAEMISSAO]) +"^FS" + CRLF) // DATA DE EMISSAO
            FWrite(nHdl, "^FT209,1007^A@B,28,29,TT0003M_^FH\^CI17^F8^FDPLANT /DOC: 111^FS^CI0" + CRLF)
            FWrite(nHdl, "^FT145,1006^A@B,28,29,TT0003M_^FH\^CI17^F8^FDROD. DOM GABRIEL P. B. COUTO, KM 66^FS^CI0" + CRLF)
            FWrite(nHdl, "^FT430,469^A0B,20,19^FH\^FDQUANTITY (Q)^FS" + CRLF)
            FWrite(nHdl, "^FT349,473^A0B,20,19^FH\^FDDATE:^FS" + CRLF)
            FWrite(nHdl, "^FT350,1094^A0B,20,19^FH\^FDLOT # (1T)^FS" + CRLF)
            FWrite(nHdl, "^FT113,1006^A@B,28,29,TT0003M_^FH\^CI17^F8^FDJOYSON SAFETY SYSTEMS BRASIL LTDA^FS^CI0" + CRLF)
            FWrite(nHdl, "^BY192,192^FT253,219^BXB,6,200,0,0,1,~" + CRLF)
            FWrite(nHdl, "^FH\^FD[)>06ZA0011J0003935"+ aEtiq[nLoop,ET_CODBAR] +"Q"+ AllTrim(Str(aEtiq[nLoop, ET_QTDPRODUTO])) +".000P"+ AllTrim(aEtiq[nLoop, ET_ATLREF]) +"V00039351T"+ AllTrim(aEtiq[nLoop, ET_NUMLOTE]) +"KJUI3935^FS" + CRLF) // QRCODE
            FWrite(nHdl, "^FT242,1653^A0B,23,24^FH\^FDASN^FS" + CRLF)
            FWrite(nHdl, "^FT429,1096^A0B,20,19^FH\^FDPO # (K):^FS" + CRLF)
            FWrite(nHdl, "^FT283,1097^A0B,20,19^FH\^FDPART DESC:^FS" + CRLF)
            FWrite(nHdl, "^FT509,840^A0B,20,19^FH\^FDVISTO CONFER\D2NCIA^FS" + CRLF)
            FWrite(nHdl, "^FT315,990^A0B,31,31^FH\^FD"+ aEtiq[nLoop, ET_DESPRODUTO] +"^FS" + CRLF) // DESCRICAO DO PRODUTO
            FWrite(nHdl, "^FT510,469^A0B,20,19^FH\^FDVISTO EMBALAGEM^FS" + CRLF)
            FWrite(nHdl, "^FT557,1670^A0B,20,19^FH\^FDOPS:^FS" + CRLF)
            FWrite(nHdl, "^FT283,1672^A0B,20,19^FH\^FDPART NUMBER (P):^FS" + CRLF)
            FWrite(nHdl, "^FT510,1670^A0B,20,19^FH\^FDSUPPLIER AREA (1J):^FS" + CRLF)
            FWrite(nHdl, "^FT464,1502^A0B,28,28^FH\^FD0003935"+ aEtiq[nLoop, ET_CODBAR] +"^FS" + CRLF) // Licence Plate
            FWrite(nHdl, "^LRY^FO489,845^GB102,0,1^FS^LRN" + CRLF)
            FWrite(nHdl, "^LRY^FO329,479^GB262,0,1^FS^LRN" + CRLF)
            FWrite(nHdl, "^LRY^FO262,1105^GB227,0,1^FS^LRN" + CRLF)
            FWrite(nHdl, "^PQ1,0,1,Y^XZ" + CRLF)

        Next nLoop
    EndIf

    // If MV_PAR03 == 1 // Tipo da Etiqueta = Rack
	
    //     For nLoop := 1 to Len( aEtiq )
    //         IncProc()

    //         If Mod( Val(aEtiq[nLoop,ET_QTDPRODUTO]), 40 ) == 0

    //             nQtdEtiqueta := Val(aEtiq[nLoop,ET_QTDPRODUTO]) / 40

    //             For nLoopQtd := 1 to nQtdEtiqueta
    //             // For nLoopQtd := 1 to 1

    //                 FWrite(nHdl,"CT~~CD,~CC^~CT~"+CRLF)
    //                 FWrite(nHdl,"^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ"+CRLF)
    //                 FWrite(nHdl,"^XA"+CRLF)
    //                 FWrite(nHdl,"^MMT"+CRLF)
    //                 FWrite(nHdl,"^PW591"+CRLF)
    //                 FWrite(nHdl,"^LL1678"+CRLF)
    //                 FWrite(nHdl,"^LS0"+CRLF)
    //                 FWrite(nHdl,"^FT79,1005^A0B,34,33^FH\^FDTO^FS"+CRLF)
    //                 FWrite(nHdl,"^FT425,904^A0B,45,45^FH\^FD"+ aEtiq[nLoop,ET_NUMLOTE] +"^FS"+CRLF) //Lote
    //                 FWrite(nHdl,"^FT79,1652^A0B,34,33^FH\^FDFROM^FS"+CRLF)
    //                 FWrite(nHdl,"^FT176,1654^A@B,28,29,TT0003M_^FH\^CI17^F8^FDPENAPOLIS - SP^FS^CI0"+CRLF)
    //                 FWrite(nHdl,"^FT146,1655^A@B,28,29,TT0003M_^FH\^CI17^F8^FDAV. ANTONIO VERONESE, 1007^FS^CI0"+CRLF)
    //                 FWrite(nHdl,"^FT116,1653^A@B,28,29,TT0003M_^FH\^CI17^F8^FDMIDORI AUTO LEATHER BRASIL LTDA^FS^CI0"+CRLF)
    //                 FWrite(nHdl,"^FT207,1654^A@B,28,29,TT0003M_^FH\^CI17^F8^FDalexandre.sanches@midoriautoleather.com.br^FS^CI0"+CRLF)
    //                 FWrite(nHdl,"^FO537,2^GB0,1663,2^FS"+CRLF)
    //                 FWrite(nHdl,"^FO447,2^GB0,1102,1^FS"+CRLF)
    //                 FWrite(nHdl,"^FO349,1^GB0,1664,1^FS"+CRLF)
    //                 FWrite(nHdl,"^FO262,2^GB0,1663,1^FS"+CRLF)
    //                 FWrite(nHdl,"^FT385,1657^A0B,20,19^FH\^FDLICENSE PLATE (1J):^FS"+CRLF)
    //                 FWrite(nHdl,"^BY3,3,83^FT481,1623^BCB,,N,N"+CRLF)
    //                 FWrite(nHdl,"^FD>:1J>50003935"+ aEtiq[nLoop,ET_CODBAR] +"^FS"+CRLF) //Codigo de Barras
    //                 FWrite(nHdl,"^FT82,347^A@B,28,29,TT0003M_^FH\^CI17^F8^FDMADE IN ^FS^CI0"+CRLF)
    //                 FWrite(nHdl,"^FT124,347^A@B,28,29,TT0003M_^FH\^CI17^F8^FDBRAZIL^FS^CI0"+CRLF)
    //                 FWrite(nHdl,"^FT177,1007^A@B,28,29,TT0003M_^FH\^CI17^F8^FDJUNDIAI - SP^FS^CI0"+CRLF)
    //                 FWrite(nHdl,"^FT327,1495^A0B,45,45^FH\^FD"+ aEtiq[nLoop,ET_PARTNUM] +"^FS"+CRLF) //PartNumber
    //                 FWrite(nHdl,"^FT514,290^A0B,45,45^FH\^FD40.000^FS"+CRLF) //Quantidade
    //                 FWrite(nHdl,"^FT518,859^A0B,45,45^FH\^FDJUI3935^FS"+CRLF)
    //                 FWrite(nHdl,"^FT423,334^A0B,45,45^FH\^FD"+ aEtiq[nLoop,ET_DTAEMISSAO] +"^FS"+CRLF) //Data
    //                 FWrite(nHdl,"^FT209,1007^A@B,28,29,TT0003M_^FH\^CI17^F8^FDPLANT /DOC: 111^FS^CI0"+CRLF)
    //                 FWrite(nHdl,"^FT145,1006^A@B,28,29,TT0003M_^FH\^CI17^F8^FDROD. DOM GABRIEL P. B. COUTO, KM 66^FS^CI0"+CRLF)
    //                 FWrite(nHdl,"^FT479,466^A0B,20,19^FH\^FDQUANTITY (Q)^FS"+CRLF)
    //                 FWrite(nHdl,"^FT385,468^A0B,20,19^FH\^FDDATE:^FS"+CRLF)
    //                 FWrite(nHdl,"^FT379,1085^A0B,20,19^FH\^FDLOT # (1T)^FS"+CRLF)
    //                 FWrite(nHdl,"^FT113,1006^A@B,28,29,TT0003M_^FH\^CI17^F8^FDJOYSON SAFETY SYSTEMS BRASIL LTDA^FS^CI0"+CRLF)
    //                 FWrite(nHdl,"^BY192,192^FT253,219^BXB,6,200,0,0,1,~"+CRLF)
    //                 FWrite(nHdl,"^FH\^FD[)>06ZA0011J0003935"+ aEtiq[nLoop,ET_CODBAR] +"Q"+ aEtiq[nLoop,ET_QTDPRODUTO] +"P"+ aEtiq[nLoop,ET_PARTNUM] +"V00039351T"+ aEtiq[nLoop,ET_NUMLOTE] +"KJUI3935^FS"+CRLF) //Data Matrix
    //                 FWrite(nHdl,"^FT242,1653^A0B,23,24^FH\^FDASN^FS"+CRLF)
    //                 FWrite(nHdl,"^FT480,1087^A0B,20,19^FH\^FDPO # (K):^FS"+CRLF)
    //                 FWrite(nHdl,"^FT288,1087^A0B,17,16^FH\^FDPART DESC:^FS"+CRLF)
    //                 FWrite(nHdl,"^FT315,990^A0B,31,31^FH\^FD"+ aEtiq[nLoop,ET_DESPRODUTO] +"^FS"+CRLF) // Produto
    //                 FWrite(nHdl,"^FT287,1657^A0B,17,16^FH\^FDPART NUMBER (P):^FS"+CRLF)
    //                 FWrite(nHdl,"^FT568,1655^A0B,20,19^FH\^FDSUPPLIER AREA (1J):^FS"+CRLF)
    //                 FWrite(nHdl,"^FT510,1502^A0B,28,28^FH\^FD0003935 "+ aEtiq[nLoop,ET_CODBAR] +"^FS"+CRLF) //Licence Plate
    //                 FWrite(nHdl,"^LRY^FO349,478^GB189,0,1^FS^LRN"+CRLF)
    //                 FWrite(nHdl,"^LRY^FO262,1105^GB274,0,1^FS^LRN"+CRLF)
    //                 FWrite(nHdl,"^PQ1,0,1,Y^XZ"+CRLF)

    //             Next nLoop

    //         Else

    //             FWrite(nHdl,"CT~~CD,~CC^~CT~"+CRLF)
    //             FWrite(nHdl,"^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ"+CRLF)
    //             FWrite(nHdl,"^XA"+CRLF)
    //             FWrite(nHdl,"^MMT"+CRLF)
    //             FWrite(nHdl,"^PW591"+CRLF)
    //             FWrite(nHdl,"^LL1678"+CRLF)
    //             FWrite(nHdl,"^LS0"+CRLF)
    //             FWrite(nHdl,"^FT57,1014^A0B,34,33^FH\^FDTO^FS"+CRLF)
    //             FWrite(nHdl,"^FT403,913^A0B,45,45^FH\^FD"+ aEtiq[nLoop,ET_NUMLOTE] +"^FS"+CRLF) //Lote
    //             FWrite(nHdl,"^FT57,1661^A0B,34,33^FH\^FDFROM^FS"+CRLF)
    //             FWrite(nHdl,"^FT154,1662^A@B,28,29,TT0003M_^FH\^CI17^F8^FDPENAPOLIS - SP^FS^CI0"+CRLF)
    //             FWrite(nHdl,"^FT124,1663^A@B,28,29,TT0003M_^FH\^CI17^F8^FDAV. ANTONIO VERONESE, 1007^FS^CI0"+CRLF)
    //             FWrite(nHdl,"^FT94,1662^A@B,28,29,TT0003M_^FH\^CI17^F8^FDMIDORI AUTO LEATHER BRASIL LTDA^FS^CI0"+CRLF)
    //             FWrite(nHdl,"^FT186,1662^A@B,28,29,TT0003M_^FH\^CI17^F8^FDalexandre.sanches@midoriautoleather.com.br^FS^CI0"+CRLF)
    //             FWrite(nHdl,"^FO516,10^GB0,1663,1^FS"+CRLF)
    //             FWrite(nHdl,"^FO425,10^GB0,1102,1^FS"+CRLF)
    //             FWrite(nHdl,"^FO327,10^GB0,1663,1^FS"+CRLF)
    //             FWrite(nHdl,"^FO240,11^GB0,1662,1^FS"+CRLF)
    //             FWrite(nHdl,"^FT364,1666^A0B,20,19^FH\^FDLICENSE PLATE (1J):^FS"+CRLF)
    //             FWrite(nHdl,"^BY3,3,83^FT460,1631^BCB,,N,N"+CRLF)
    //             FWrite(nHdl,"^FD>:1J>50003935"+ aEtiq[nLoop,ET_CODBAR] +"^FS"+CRLF) //Codigo de Barras
    //             FWrite(nHdl,"^FT60,356^A@B,28,29,TT0003M_^FH\^CI17^F8^FDMADE IN ^FS^CI0"+CRLF)
    //             FWrite(nHdl,"^FT102,356^A@B,28,29,TT0003M_^FH\^CI17^F8^FDBRAZIL^FS^CI0"+CRLF)
    //             FWrite(nHdl,"^FT155,1016^A@B,28,29,TT0003M_^FH\^CI17^F8^FDJUNDIAI - SP^FS^CI0"+CRLF)
    //             FWrite(nHdl,"^FT305,1503^A0B,45,45^FH\^FD"+ aEtiq[nLoop,ET_PARTNUM] +"^FS"+CRLF) //PartNumber
    //             FWrite(nHdl,"^FT492,299^A0B,45,45^FH\^FD"+ aEtiq[nLoop,ET_QTDPRODUTO] +"^FS"+CRLF) //Quantidade
    //             FWrite(nHdl,"^FT496,868^A0B,45,45^FH\^FDJUI3935^FS"+CRLF)
    //             FWrite(nHdl,"^FT401,342^A0B,45,45^FH\^FD"+ aEtiq[nLoop,ET_DTAEMISSAO] +"^FS"+CRLF) //Data
    //             FWrite(nHdl,"^FT187,1015^A@B,28,29,TT0003M_^FH\^CI17^F8^FDPLANT /DOC: 111^FS^CI0"+CRLF)
    //             FWrite(nHdl,"^FT123,1015^A@B,28,29,TT0003M_^FH\^CI17^F8^FDROD. DOM GABRIEL P. B. COUTO, KM 66^FS^CI0"+CRLF)
    //             FWrite(nHdl,"^FT458,475^A0B,20,19^FH\^FDQUANTITY (Q)^FS"+CRLF)
    //             FWrite(nHdl,"^FT364,476^A0B,20,19^FH\^FDDATE:^FS"+CRLF)
    //             FWrite(nHdl,"^FT357,1094^A0B,20,19^FH\^FDLOT # (1T)^FS"+CRLF)
    //             FWrite(nHdl,"^FT92,1015^A@B,28,29,TT0003M_^FH\^CI17^F8^FDJOYSON SAFETY SYSTEMS BRASIL LTDA^FS^CI0"+CRLF)
    //             FWrite(nHdl,"^BY192,192^FT231,228^BXB,6,200,0,0,1,~"+CRLF)
    //             FWrite(nHdl,"^FH\^FD[)>06ZA0011J0003935"+ aEtiq[nLoop,ET_CODBAR] +"Q"+ aEtiq[nLoop,ET_QTDPRODUTO] +"P"+ aEtiq[nLoop,ET_PARTNUM] +"V00039351T"+ aEtiq[nLoop,ET_NUMLOTE] +"KJUI3935^FS"+CRLF) //Data Matrix
    //             FWrite(nHdl,"^FT220,1662^A0B,23,24^FH\^FDASN^FS"+CRLF)
    //             FWrite(nHdl,"^FT458,1095^A0B,20,19^FH\^FDPO # (K):^FS"+CRLF)
    //             FWrite(nHdl,"^FT266,1095^A0B,17,16^FH\^FDPART DESC:^FS"+CRLF)
    //             FWrite(nHdl,"^FT301,943^A0B,39,38^FH\^FD"+ aEtiq[nLoop,ET_DESPRODUTO] +"^FS"+CRLF) // Produto
    //             FWrite(nHdl,"^FT265,1665^A0B,17,16^FH\^FDPART NUMBER (P):^FS"+CRLF)
    //             FWrite(nHdl,"^FT546,1663^A0B,20,19^FH\^FDSUPPLIER AREA (1J):^FS"+CRLF)
    //             FWrite(nHdl,"^FT488,1511^A0B,28,28^FH\^FD0003935 "+ aEtiq[nLoop,ET_CODBAR] +"^FS"+CRLF) //Licence Plate
    //             FWrite(nHdl,"^LRY^FO328,487^GB189,0,1^FS^LRN"+CRLF)
    //             FWrite(nHdl,"^LRY^FO240,1114^GB274,0,1^FS^LRN"+CRLF)
    //             FWrite(nHdl,"^PQ1,0,1,Y^XZ"+CRLF)

    //         EndIf
        
    //     Next nLoop
    // Else // Tipo da Etiqueta = Caixa
    //     For nLoop := 1 to Len( aEtiq )
    //         IncProc()

    //         FWrite(nHdl," CT~~CD,~CC^~CT~ " + CRLF)
    //         FWrite(nHdl," ^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ " + CRLF)
    //         FWrite(nHdl," ^XA " + CRLF)
    //         FWrite(nHdl," ^MMT " + CRLF)
    //         FWrite(nHdl," ^PW799 " + CRLF)
    //         FWrite(nHdl," ^LL0799 " + CRLF)
    //         FWrite(nHdl," ^LS0 " + CRLF)
    //         FWrite(nHdl," ^FT384,41^A0N,25,24^FH\^FDTO^FS " + CRLF)
    //         FWrite(nHdl," ^FT25,373^A0N,34,33^FH\^FD"+ aEtiq[nLoop,ET_NUMLOTE] +"^FS " + CRLF)
    //         FWrite(nHdl," ^FT24,42^A0N,25,24^FH\^FDFROM^FS " + CRLF)
    //         FWrite(nHdl," ^FO25,291^GB766,0,1^FS " + CRLF)
    //         FWrite(nHdl," ^FO25,491^GB766,0,1^FS " + CRLF)
    //         FWrite(nHdl," ^FO25,675^GB766,0,2^FS " + CRLF)
    //         FWrite(nHdl," ^FO24,195^GB767,0,1^FS " + CRLF)
    //         FWrite(nHdl," ^FT24,181^A0N,23,24^FH\^FDASN^FS " + CRLF)
    //         FWrite(nHdl," ^FT25,152^A0N,17,16^FH\^FDalexandre.sanches@midoriautoleather.com.br^FS " + CRLF)
    //         FWrite(nHdl," ^FT24,265^A0N,25,24^FH\^FD"+ aEtiq[nLoop,ET_PARTNUM] +"^FS " + CRLF)
    //         FWrite(nHdl," ^FT632,314^A0N,17,16^FH\^FDMADE IN BRAZIL^FS " + CRLF)
    //         FWrite(nHdl," ^FT345,330^A0N,25,24^FH\^FDDATE:^FS " + CRLF)
    //         FWrite(nHdl," ^FT25,461^A0N,34,33^FH\^FD"+ aEtiq[nLoop,ET_QTDPRODUTO] +"^FS " + CRLF)
    //         FWrite(nHdl," ^FT344,375^A0N,34,33^FH\^FD"+ aEtiq[nLoop,ET_DTAEMISSAO] +"^FS " + CRLF)
    //         FWrite(nHdl," ^FT346,461^A0N,34,33^FH\^FDJUI3935^FS " + CRLF)
    //         FWrite(nHdl," ^FT384,125^A0N,20,19^FH\^FDJUNDIAI - SP^FS " + CRLF)
    //         FWrite(nHdl," ^FT257,267^A0N,25,24^FH\^FD"+ aEtiq[nLoop,ET_DESPRODUTO] +"^FS " + CRLF)
    //         FWrite(nHdl," ^FT384,153^A0N,20,19^FH\^FDPLANT /DOC: 111^FS " + CRLF)
    //         FWrite(nHdl," ^FT25,522^A0N,25,24^FH\^FDLICENSE PLATE (1J):^FS " + CRLF)
    //         FWrite(nHdl," ^FT274,635^A0N,34,33^FH\^FD0003935 "+ aEtiq[nLoop,ET_CODBAR] +"^FS " + CRLF)
    //         FWrite(nHdl," ^FT25,416^A0N,25,24^FH\^FDQUANTITY (Q)^FS " + CRLF)
    //         FWrite(nHdl," ^FT346,417^A0N,25,24^FH\^FDPO # (K):^FS " + CRLF)
    //         FWrite(nHdl," ^FT24,127^A0N,20,19^FH\^FDPENAPOLIS - SP^FS " + CRLF)
    //         FWrite(nHdl," ^FT24,329^A0N,25,24^FH\^FDLOT # (1T)^FS " + CRLF)
    //         FWrite(nHdl," ^FT256,225^A0N,25,24^FH\^FDPART DESC:^FS " + CRLF)
    //         FWrite(nHdl," ^FT24,225^A0N,25,24^FH\^FDPART NUMBER (P):^FS " + CRLF)
    //         FWrite(nHdl," ^FT25,72^A0N,20,19^FH\^FDMIDORI AUTO LEATHER BRASIL LTDA^FS " + CRLF)
    //         FWrite(nHdl," ^FT24,100^A0N,20,19^FH\^FDAV. ANTONIO VERONESE, 1007^FS " + CRLF)
    //         FWrite(nHdl," ^FT384,70^A0N,20,19^FH\^FDJOYSON SAFETY SYSTEMS BRASIL LTDA^FS " + CRLF)
    //         FWrite(nHdl," ^FT24,714^A0N,25,24^FH\^FDSUPPLIER AREA (1J):^FS " + CRLF)
    //         FWrite(nHdl," ^FT384,98^A0N,20,19^FH\^FDROD. DOM GABRIEL P. B. COUTO, KM 66^FS " + CRLF)
    //         FWrite(nHdl," ^BY160,160^FT608,482^BXN,5,200,0,0,1,~ " + CRLF)
    //         FWrite(nHdl," ^FH\^FD[)>06ZA0011J0003935"+ aEtiq[nLoop,ET_CODBAR] +"Q"+ aEtiq[nLoop,ET_QTDPRODUTO] +"P"+ aEtiq[nLoop,ET_PARTNUM] +"V00039351T"+ aEtiq[nLoop,ET_NUMLOTE] +"KJUI3935^FS " + CRLF)
    //         FWrite(nHdl," ^BY4,3,62^FT102,599^BCN,,N,N " + CRLF)
    //         FWrite(nHdl," ^FD>:1J>50003935"+ aEtiq[nLoop,ET_CODBAR] +"^FS " + CRLF)
    //         FWrite(nHdl," ^LRY^FO373,14^GB0,179,3^FS^LRN " + CRLF)
    //         FWrite(nHdl," ^PQ1,0,1,Y^XZ " + CRLF)
    //         FWrite(nHdl,"  " + CRLF)
    //     Next nLoop
    // EndIf
 
	FClose( nHdl )
	WinExec( "CMD /C TYPE " + cTempDir + cFile + " > " + "LPT1")

	
Return( nil )
