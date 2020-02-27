#Include 'Protheus.ch'
#Include 'Parmtype.ch'

#Define ET_DESPRODKIT 1
#Define ET_DESPRODCOMP 2
#Define ET_QTDPECA 3
#Define ET_ATLREF 4
#Define ET_DESUM 5
#Define ET_TIPOETQ 6


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


User Function MDCORTECAIXA()  

    Local oPerg
	Private cPerg  := "MDCORTECAI"

    Private aTipoFicha := {"Corte", "Recorte"}
    Private aTipo := {"Perfurado", "Não Perfurado", "Ambos"}
	oPerg := AdvplPerg():New( cPerg )
    

	//-------------------------------------------------------------------
	// AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
	// Parametriza as perguntas
	//-------------------------------------------------------------------
    oPerg:AddPerg( "Plano"   , "C", 20 ,   ,) //4 
    oPerg:AddPerg( "Tipo da Ficha"   ,    ,   ,   ,aTipoFicha       ) //1
    oPerg:AddPerg( "Multiplo"   , "N" ,  3 ,   ,       ) //1
    oPerg:AddPerg( "Tipo"   ,    ,   ,   ,aTipo       ) //1
    oPerg:AddPerg( "Produto"   , "C", 20 ,   ,)
    
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

    If MV_PAR02 = 1
        ImpEtqCort()
    Else
        ImpEtqRec()
    EndIf
  

Return( nil )



Static Function ImpEtqRec()
    Local cSql := ""
    Local KitTemp := GetNextAlias()
    Local CompTemp := GetNextAlias()
    Local Rec := 0
    Local aEtiq := {}
    Local KitPerf := .F.

    // PRODUTO KIT
    Local cET_CODKIT := ""
    Local cET_DESKIT := ""
    Local nET_QTDKIT := 0

    // PRODUTO COMPONENTE   
    Local cET_ATLREF := ""
    Local cET_CODCOMP := ""
    Local cET_DESCOMP := ""
    Local cET_DESUM := ""
    Local nET_TIPOETQ := 0
    Local nET_QTDPECA := 0


    cSql := " SELECT "
    cSql += "    SZP.ZP_PRODUTO AS COD_KIT,  "
    cSql += "    SB1.B1_DESC AS DES_KIT, "
    cSql += "    SZP.ZP_QUANT AS QTD_KIT "
    cSql += " FROM SZP010 AS SZP "
    cSql += " INNER JOIN SB1010 AS SB1 "
    cSql += " ON SZP.ZP_PRODUTO = SB1.B1_COD "
    cSql += " WHERE SZP.D_E_L_E_T_ = '' "
    cSql += " AND SZP.ZP_FILIAL = '09' "
    cSql += " AND SZP.ZP_OPMIDO = '"+ AllTrim(MV_PAR01) +"'"

    If Select("KitTemp") > 0
    	dbSelectArea('KitTemp')
		dbCloseArea()
	EndIf

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),KitTemp,.T.,.T.)
    Count to Rec
    (KitTemp)->(dbGoTop())

    If Rec > 0        
        cET_CODKIT := allTrim( (KitTemp)->COD_KIT )
        cET_DESKIT := allTrim( (KitTemp)->DES_KIT )

        If 'PERF' $ cET_DESKIT
            KitPerf := .T.
        EndIf

        cSql := " SELECT"
        cSql += "    ZH_FILIAL,"
        cSql += "    ZH_DESCR AS DES_COMP,"
        cSql += "    ZH_QUANT AS QTD_COMP,"
        cSql += "    B1_UM AS DES_UM,"
        cSql += "    B1_ATLREF AS DES_ATLREF,"
        cSql += "    ZH_MODELO,"
        cSql += "    CASE"
        cSql += "       WHEN ZH_DESCR LIKE '%PERF%' THEN 0"
        cSql += "       ELSE 1"
        cSql += "    END AS TIPO_ETIQUETA"
        cSql += " FROM SZH010 AS SZH"
        cSql += " LEFT JOIN SB1010 AS SB1"
        cSql += " ON SZH.ZH_PRODUTO = SB1.B1_COD"
        cSql += " AND SB1.D_E_L_E_T_ = ''"
        cSql += " WHERE SZH.ZH_PLANO = '"+ AllTrim(MV_PAR01) +"'"
        cSql += " AND SZH.D_E_L_E_T_ = ''"
        If KitPerf = .F.
            If MV_PAR04 = 1
                cSql += " AND COMP.B1_DESC LIKE '%PERF%' "
            ElseIf MV_PAR04 = 2
                cSql += " AND COMP.B1_DESC NOT LIKE '%PERF%' "
            EndIf
        EndIf

        If AllTrim(MV_PAR05) <> '' 
            cSql += " AND ZH_PRODUTO = '"+ AllTrim(MV_PAR05) +"' "
        Endif
        
        If Select("CompTemp") > 0
            dbSelectArea('CompTemp')
            dbCloseArea()
        EndIf

        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),CompTemp,.T.,.T.)
        Count to Rec
        // (CompTemp)->(dbCloseArea())
        (CompTemp)->(dbGoTop())

        If Rec > 0
            While (CompTemp)->(!Eof())

                cET_DESCOMP := allTrim( (CompTemp)->DES_COMP )
                nET_QTDPECA := (CompTemp)->QTD_COMP
                cET_ATLREF := allTrim( (CompTemp)->DES_ATLREF )
                cET_DESUM := allTrim( (CompTemp)->DES_UM )
                If KitPerf = .T.
                    nET_TIPOETQ := 0
                Else    
                    nET_TIPOETQ := (CompTemp)->TIPO_ETIQUETA
                EndIf

                AAdd( aEtiq, { cET_DESKIT,;
                            cET_DESCOMP,;
                            nET_QTDPECA,;
                            cET_ATLREF,;
                            cET_DESUM,;
                            nET_TIPOETQ })

                (CompTemp)->(dbSkip())

            endDo
        Else
            (CompTemp)->(dbCloseArea())
            cET_CODKIT := allTrim( (KitTemp)->COD_KIT )
            cET_DESKIT := allTrim( (KitTemp)->DES_KIT )           

            cSql := ""
            cSql += " SELECT "
            cSql += "     SG1.G1_COMP AS COD_COMP,"
            cSql += "     COMP.B1_DESC AS DES_COMP,"
            cSql += "     SG1.G1_UM AS DES_UM,"
            cSql += "     SG1.G1_QUANT AS QTD_COMP,"
            cSql += "     COMP.B1_ATLREF AS DES_ATLREF,"
            cSql += "     CASE"
            cSql += "       WHEN COMP.B1_DESC LIKE '%PERF%' THEN 0"
            cSql += "       ELSE 1"
            cSql += "     END AS TIPO_ETIQUETA"
            cSql += " FROM SG1010 AS SG1 "
            cSql += " INNER JOIN SB1010 AS COMP "
            cSql += " ON SG1.G1_COMP = COMP.B1_COD "
            cSql += " WHERE G1_FILIAL = '09' "
            cSql += " AND SG1.G1_COD = '"+ AllTrim(cET_CODKIT) +"' "
            cSql += " AND SG1.G1_FIM >= '"+ DtoS( dDataBase ) +"' "
            cSql += " AND SG1.D_E_L_E_T_ = '' "
            If MV_PAR04 = 1
                cSql += " AND COMP.B1_DESC LIKE '%PERF%' "
            ElseIf MV_PAR04 = 2
                cSql += " AND COMP.B1_DESC NOT LIKE '%PERF%' "
            EndIf

            If AllTrim(MV_PAR05) <> '' 
                cSql += " AND SG1.G1_COMP = '"+ AllTrim(MV_PAR05) +"' "
            Endif

            cSql += " ORDER BY SG1.G1_COD, SG1.G1_COMP "

            If Select("CompTemp") > 0
                dbSelectArea('CompTemp')
                dbCloseArea()
            EndIf

            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),CompTemp,.T.,.T.)

            While (CompTemp)->(!Eof())

                cET_DESCOMP := allTrim( (CompTemp)->DES_COMP )
                nET_QTDPECA := (KitTemp)->QTD_KIT
                cET_ATLREF := allTrim( (CompTemp)->DES_ATLREF )
                cET_DESUM := allTrim( (CompTemp)->DES_UM )
                nET_TIPOETQ := (CompTemp)->TIPO_ETIQUETA

                AAdd( aEtiq, { cET_DESKIT,;
                            cET_DESCOMP,;
                            nET_QTDPECA,;
                            cET_ATLREF,;
                            cET_DESUM,;
                            nET_TIPOETQ })

                (CompTemp)->(dbSkip())

            endDo
        EndIf

        dbCloseArea()

        If ! Empty( aEtiq )
            ImpEt( aEtiq )
        EndIf
        
    Else
        apMsgAlert( "o Plano "+ AllTrim(MV_PAR01) +" não foi encontrado no sistema." )
    EndIf        

    
Return( nil )


Static Function ImpEtqCort()
    Local cSql := ""
    Local KitTemp := GetNextAlias()
    Local CompTemp := GetNextAlias()
    Local FacaTemp := GetNextAlias()
    Local Rec := 0
    Local aEtiq := {}  
    Local DataAtu := PadL(Year(dDataBase), 4, "0") + PadL(Month(dDataBase), 2, "0") + PadL(Day(dDataBase), 2, "0")
    Local ParKTNEW := GETMV('MA_KTNEW') + GETMV('MA_KTNEW1') + GETMV('MA_KTNEW2')
    Local KitPerf := .F.

    // PRODUTO KIT
    Local cET_CODKIT := ""
    Local cET_DESKIT := ""
    Local nET_QTDKIT := 0

    // PRODUTO COMPONENTE   
    Local cET_CODCOMP := ""
    Local cET_DESCOMP := ""

    // PRODUTO FACA
    Local cET_ATLREF := ""
    Local cET_DESUM := ""
    Local nET_TIPOETQ := 0
    Local nET_QTDPECA := 0

    cSql += " SELECT "
    cSql += "     SZP.ZP_PRODUTO AS COD_KIT,  "
    cSql += "     SB1.B1_DESC AS DES_KIT, "
    cSql += "     SZP.ZP_QUANT AS QTD_KIT "
    cSql += " FROM SZP010 AS SZP "
    cSql += " INNER JOIN SB1010 AS SB1 "
    cSql += " ON SZP.ZP_PRODUTO = SB1.B1_COD "
    cSql += " WHERE SZP.D_E_L_E_T_ = '' "
    cSql += " AND SZP.ZP_FILIAL = '09' "
    cSql += " AND SZP.ZP_OPMIDO = '"+ AllTrim(MV_PAR01) +"' "
    
    If Select("KitTemp") > 0
    	dbSelectArea('KitTemp')
		dbCloseArea()
	EndIf

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),KitTemp,.T.,.T.)
    Count to Rec
    (KitTemp)->(dbGoTop())

    If Rec > 0   

        cET_CODKIT := allTrim( (KitTemp)->COD_KIT )
        cET_DESKIT := allTrim( (KitTemp)->DES_KIT )
        nET_QTDKIT := (KitTemp)->QTD_KIT
        nET_QTDPECA := nET_QTDKIT / MV_PAR02  

        If 'PERF' $ cET_DESKIT
            KitPerf := .T.
        EndIf

        If cET_CODKIT $ ParKTNEW
            cSql := ""
            cSql += " SELECT "
            cSql += "     SG1.G1_COMP AS COD_COMP,"
            cSql += "     COMP.B1_DESC AS DES_COMP,"
            cSql += "     SG1.G1_UM AS DES_UM,"
            cSql += "     SG1.G1_QUANT AS QTD_COMP,"
            cSql += "     COMP.B1_ATLREF AS DES_ATLREF,"
            cSql += "     CASE"
            cSql += "       WHEN COMP.B1_DESC LIKE '%PERF%' THEN 0"
            cSql += "       ELSE 1"
            cSql += "     END AS TIPO_ETIQUETA"
            cSql += " FROM SG1010 AS SG1 "
            cSql += " INNER JOIN SB1010 AS COMP "
            cSql += " ON SG1.G1_COMP = COMP.B1_COD "
            cSql += " WHERE G1_FILIAL = '09' "
            cSql += " AND SG1.G1_COD = '"+ AllTrim(cET_CODKIT) +"' "
            cSql += " AND SG1.G1_FIM >= '"+ DtoS( dDataBase ) +"' "
            cSql += " AND SG1.D_E_L_E_T_ = '' "
            If KitPerf = .F.
                If MV_PAR04 = 1
                    cSql += " AND COMP.B1_DESC LIKE '%PERF%' "
                ElseIf MV_PAR04 = 2
                    cSql += " AND COMP.B1_DESC NOT LIKE '%PERF%' "
                EndIf
            EndIf

            If AllTrim(MV_PAR05) <> '' 
                cSql += " AND SG1.G1_COMP = '"+ AllTrim(MV_PAR05) +"' "
            Endif

            cSql += " ORDER BY SG1.G1_COD, SG1.G1_COMP "

             If Select("CompTemp") > 0
                dbSelectArea('CompTemp')
                dbCloseArea()
            EndIf

            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),CompTemp,.T.,.T.)
            (CompTemp)->(dbGoTop())

            While (CompTemp)->(!Eof())

                cET_DESCOMP := allTrim( (CompTemp)->DES_COMP )
                nET_QTDPECA := (KitTemp)->QTD_KIT
                cET_ATLREF := allTrim( (CompTemp)->DES_ATLREF )
                cET_DESUM := allTrim( (CompTemp)->DES_UM )
                If KitPerf = .T.
                    nET_TIPOETQ := 0
                Else    
                    nET_TIPOETQ := (CompTemp)->TIPO_ETIQUETA
                EndIf

                AAdd( aEtiq, { cET_DESKIT,;
                            cET_DESCOMP,;
                            nET_QTDPECA,;
                            cET_ATLREF,;
                            cET_DESUM,;
                            nET_TIPOETQ })

                (CompTemp)->(dbSkip())

            endDo

        Else
            cSql := ""
            cSql += " SELECT "
            cSql += "     SG1.G1_COMP AS COD_COMP,"
            cSql += "     COMP.B1_DESC AS DES_COMP"
            cSql += " FROM SG1010 AS SG1 "
            cSql += " INNER JOIN SB1010 AS COMP "
            cSql += " ON SG1.G1_COMP = COMP.B1_COD "
            cSql += " WHERE G1_FILIAL = '09' "
            cSql += " AND SG1.G1_COD = '"+ AllTrim(cET_CODKIT) +"' "
            cSql += " AND SG1.G1_FIM >= '"+ DtoS( dDataBase ) +"' "
            cSql += " AND SG1.D_E_L_E_T_ = '' "
            cSql += " ORDER BY SG1.G1_COD, SG1.G1_COMP "

            If Select("CompTemp") > 0
                dbSelectArea('CompTemp')
                dbCloseArea()
            EndIf

            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),CompTemp,.T.,.T.)
            (CompTemp)->(dbGoTop())

            While (CompTemp)->(!Eof())
                cEt_CODCOMP := allTrim( (CompTemp)->COD_COMP )
                cET_DESCOMP := allTrim( (CompTemp)->DES_COMP )            

                cSql := ""
                cSql += " SELECT "
                cSql += "     COMP.B1_ATLREF AS DES_ATLREF, "
                cSql += "     SG1.G1_UM AS DES_UM,"
                cSql += "     CASE"
                cSql += "       WHEN COMP.B1_DESC LIKE '%PERF%' THEN 0"
                cSql += "       ELSE 1"
                cSql += "     END AS TIPO_ETIQUETA"
                cSql += " FROM SG1010 AS SG1 "
                cSql += " INNER JOIN SB1010 AS COMP "
                cSql += " ON SG1.G1_COMP = COMP.B1_COD "
                cSql += " WHERE G1_FILIAL = '09' "
                cSql += " AND SG1.G1_COD = '"+ AllTrim(cEt_CODCOMP) +"' "
                cSql += " AND SG1.G1_FIM >= '"+DataAtu+"' "
                cSql += " AND SG1.D_E_L_E_T_ = '' "

                If KitPerf = .F.
                    If MV_PAR04 = 1
                        cSql += " AND COMP.B1_DESC LIKE '%PERF%' "
                    ElseIf MV_PAR04 = 2
                        cSql += " AND COMP.B1_DESC NOT LIKE '%PERF%' "
                    EndIf
                EndIf

                If AllTrim(MV_PAR05) <> '' 
                    cSql += " AND SG1.G1_COMP = '"+ AllTrim(MV_PAR05) +"' "
                Endif

                cSql += " ORDER BY SG1.G1_COD, SG1.G1_COMP "
                
                If Select("FacaTemp") > 0
                    dbSelectArea('FacaTemp')
                    dbCloseArea()
                EndIf

                dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),FacaTemp,.T.,.T.)
                (FacaTemp)->(dbGoTop())

                While (FacaTemp)->(!Eof())

                    cET_ATLREF := allTrim( (FacaTemp)->DES_ATLREF )
                    cET_DESUM := allTrim( (FacaTemp)->DES_UM )
                    nET_TIPOETQ := (FacaTemp)->TIPO_ETIQUETA
                    If KitPerf = .T.
                        nET_TIPOETQ := 0
                    Else    
                        nET_TIPOETQ := (FacaTemp)->TIPO_ETIQUETA
                    EndIf

                    AAdd( aEtiq, {  cET_DESKIT,;
                                    cET_DESCOMP,;
                                    nET_QTDPECA,;
                                    cET_ATLREF,;
                                    cET_DESUM,;
                                    nET_TIPOETQ })

                    (FacaTemp)->(dbSkip())   

                endDo            

                dbCloseArea()

                (CompTemp)->(dbSkip())   

            endDo
        EndIf

        dbCloseArea()

        If ! Empty( aEtiq )
  		    ImpEt( aEtiq )
        EndIf

        dbCloseArea()
        
    Else
        apMsgAlert( "o Plano "+ AllTrim(MV_PAR01) +" não foi encontrado no sistema." )
    EndIf        

    
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
	Local cFile    := "ETIQCORTECAIXA"+StrTran( Time(), ":", "" ) + ".PRN" 
	Local nHdl     := -1
	Local nLoop    := 0
    Local nLoop2   := 0
    Local nQtdPeca := 0

    Local nMod := 0
    Local nMultiplo := 0
    Local nDiv := 0

	nHdl := FCreate( cTempDir+cFile ) 
	If nHdl < 0
		apMsgAlert("Erro na geração do arquivo temporário. Erro : " + AllTrim(Str(FError())) )
	EndIf

    For nLoop := 1 to Len( aEtiq )

        If MV_PAR03 > 0 .AND. aEtiq[nLoop, ET_QTDPECA] > MV_PAR03

            nMultiplo := MV_PAR03

            nMod := aEtiq[nLoop, ET_QTDPECA] % nMultiplo

            If nMod = 0
                nQtdPeca := aEtiq[nLoop, ET_QTDPECA]                
            Else
                nQtdPeca := aEtiq[nLoop, ET_QTDPECA] - nMod
            EndIf

            nDiv := nQtdPeca / nMultiplo

        Else
            nMod := 0
            nMultiplo := aEtiq[nLoop, ET_QTDPECA]
            nDiv := 1
        EndIf

        

        For nLoop2 := 1 to nDiv
            FWrite(nHdl, " CT~~CD,~CC^~CT~ " + CRLF)
            FWrite(nHdl, " ^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ " + CRLF)
            FWrite(nHdl, " ^XA " + CRLF)
            FWrite(nHdl, " ^MMT " + CRLF)
            FWrite(nHdl, " ^PW639 " + CRLF)
            FWrite(nHdl, " ^LL0320 " + CRLF)
            FWrite(nHdl, " ^LS0 " + CRLF)
            FWrite(nHdl, " ^FT11,95^A0N,39,38^FB623,1,0,C^FH\^FD"+ Substr( aEtiq[nLoop, ET_DESPRODKIT], 1, 31) +"^FS " + CRLF)
            FWrite(nHdl, " ^FT11,142^A0N,42,40^FB623,1,0,C^FH\^FD"+ Substr( aEtiq[nLoop, ET_DESPRODKIT], 32, 66) +"^FS " + CRLF)
            FWrite(nHdl, " ^FT16,223^A0N,34,33^FB595,1,0,C^FH\^FD"+ Substr( aEtiq[nLoop, ET_DESPRODCOMP], 34, 100) +"^FS " + CRLF)
            FWrite(nHdl, " ^FT50,45^A0N,39,38^FB595,1,0,C^FH\^FD("+ AllTrim(MV_PAR01) +")^FS " + CRLF)
            FWrite(nHdl, " ^FT16,187^A0N,34,33^FB595,1,0,C^FH\^FD"+ Substr( aEtiq[nLoop, ET_DESPRODCOMP], 1, 33 ) +"^FS " + CRLF)
            FWrite(nHdl, " ^FT510,285^A0N,45,45^FH\^FD"+ AllTrim(Str( nMultiplo )) +" "+ aEtiq[nLoop, ET_DESUM] +"^FS " + CRLF)
            FWrite(nHdl, " ^FT30,286^A0N,39,38^FH\^FD"+ AllTrim(aEtiq[nLoop, ET_ATLREF]) +"^FS " + CRLF)
            if aEtiq[nLoop, ET_TIPOETQ] = 0
                FWrite(nHdl, " ^FO1,296^GB637,0,22^FS " + CRLF)
            EndIf
            FWrite(nHdl, " ^PQ1,0,1,Y^XZ " + CRLF)

        Next nLoop2
        // EndDo

        If nMod <> 0 
        
            FWrite(nHdl, " CT~~CD,~CC^~CT~ " + CRLF)
            FWrite(nHdl, " ^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ " + CRLF)
            FWrite(nHdl, " ^XA " + CRLF)
            FWrite(nHdl, " ^MMT " + CRLF)
            FWrite(nHdl, " ^PW639 " + CRLF)
            FWrite(nHdl, " ^LL0320 " + CRLF)
            FWrite(nHdl, " ^LS0 " + CRLF)
            FWrite(nHdl, " ^FT11,95^A0N,39,38^FB623,1,0,C^FH\^FD"+ Substr( aEtiq[nLoop, ET_DESPRODKIT], 1, 31) +"^FS " + CRLF)
            FWrite(nHdl, " ^FT11,142^A0N,42,40^FB623,1,0,C^FH\^FD"+ Substr( aEtiq[nLoop, ET_DESPRODKIT], 32, 66) +"^FS " + CRLF)
            FWrite(nHdl, " ^FT16,223^A0N,34,33^FB595,1,0,C^FH\^FD"+ Substr( aEtiq[nLoop, ET_DESPRODCOMP], 34, 100) +"^FS " + CRLF)
            FWrite(nHdl, " ^FT50,45^A0N,39,38^FB595,1,0,C^FH\^FD("+ AllTrim(MV_PAR01) +")^FS " + CRLF)
            FWrite(nHdl, " ^FT16,187^A0N,34,33^FB595,1,0,C^FH\^FD"+ Substr( aEtiq[nLoop, ET_DESPRODCOMP], 1, 33 ) +"^FS " + CRLF)
            FWrite(nHdl, " ^FT510,285^A0N,45,45^FH\^FD"+ AllTrim(Str( nMod )) +" "+ aEtiq[nLoop, ET_DESUM] +"^FS " + CRLF)
            FWrite(nHdl, " ^FT30,286^A0N,39,38^FH\^FD"+ AllTrim(aEtiq[nLoop, ET_ATLREF]) +"^FS " + CRLF)
            if aEtiq[nLoop, ET_TIPOETQ] = 0
                FWrite(nHdl, " ^FO1,296^GB637,0,22^FS " + CRLF)
            EndIf
            FWrite(nHdl, " ^PQ1,0,1,Y^XZ " + CRLF)

        EndIf
        
    Next nLoop
	

 
	FClose( nHdl )
	WinExec( "CMD /C TYPE " + cTempDir + cFile + " > " + "LPT1")

	
Return( nil ) 