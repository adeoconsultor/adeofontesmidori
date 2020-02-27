#Include 'Protheus.ch'
#Include 'Parmtype.ch'

#Define ET_DESCRICAO 1
#Define ET_ATLREF 2
#Define ET_QUANT 3
#Define ET_NOTA 4
#Define ET_EMISSAO 5
#Define ET_PEDIDO 6
#Define ET_CODEMB 7
#Define ET_EMPMAX 8
#Define ET_MODELO 9
#Define ET_DATAVALIDADE 10
#Define ET_VOLUME 11
#Define ET_PESO 12
#Define ET_PESOBRUTO 13

//==========================================================================================
// MDETIQHPE - Guilherme Suganame - Outubro/2019   |   Revisao/Ajuste: //
//------------------------------------------------------------------------------------------
// Descrição
// Impressão de etiquetas HPE
//------------------------------------------------------------------------------------------
// Parametros
// nenhum
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================


User Function MDETIQHPE()  

    Local oPerg
	Private cPerg  := "MDETIQHPE"    
	// Private aQtde := {"1", "2", "3","4"}
    // Private aTipo := {"Perfurado", "Não Perfurado"}
	oPerg := AdvplPerg():New( cPerg )
    

	//-------------------------------------------------------------------
	// AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
	// Parametriza as perguntas
	//-------------------------------------------------------------------
    oPerg:AddPerg( "Número da Nota"   , "C", 9 ,   ,) //1 
    oPerg:AddPerg( "Série"   , "C", 3,   ,) //2 
    oPerg:AddPerg( "Modelo"   , "C", 20,   ,) //3
    oPerg:AddPerg( "Empilhamento Máximo"   , "N", 3 ,   ,) //4
    
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

    Local cSql := ""
    Local ItemTemp := GetNextAlias() 
    Local recCount := 0
    Local aEtiq := {}
    Local QtdEtiq := 0

    // informações para montagem da etiqueta
    Local cET_DESCRICAO := ""    
    Local cET_ATLREF := ""
    Local nET_QUANT := 0
    Local cET_NOTA := ""
    Local cET_DATAEMISSAO := ""
    Local cET_PEDIDO := ""
    Local cET_CODEMB := ""
    Local nET_PESO := 0
    Local nET_PESOBRUTO := 0
    Local nET_EMPMAX := 0
    Local cET_MODELO := ""
    local cET_DATAVALIDADE := ""
    Local cET_VOLUME := ""
    Local fET_PESO := 0
    Local fET_PESOBRUTO := 0
    Local i


    cSql := "SELECT"
    cSql += "     SB1.B1_DESC AS B1_DESC, "
    cSql += "     SD2.D2_QUANT AS D2_QUANT, "
    cSql += "     SB1.B1_ATLREF AS B1_ATLREF, "
    cSql += "     SD2.D2_DOC AS D2_DOC, "
    cSql += "     SD2.D2_EMISSAO AS D2_EMISSAO, "
    cSql += "     SD2.D2_PEDIDO AS D2_PEDIDO, "
    cSql += "     CONVERT(VARCHAR, DATEADD(month, 6, SD2.D2_EMISSAO), 112) AS VALIDADE, "
    cSql += "     SB1.B1_PESO AS B1_PESO "
    cSql += " FROM SD2010 AS SD2 "
    cSql += " INNER JOIN SB1010 AS SB1 "
    cSql += " ON SD2.D2_COD = SB1.B1_COD "
    cSql += " AND SD2.D_E_L_E_T_ = '' "
    cSql += " WHERE SD2.D2_DOC = '"+ AllTrim(MV_PAR01) +"'  "
    cSql += " AND SD2.D2_SERIE = '"+ AllTrim(MV_PAR02) +"' "
    cSql += " AND SD2.D2_FILIAL = '"+ xFilial("SD2") +"' "
    cSql += " AND SD2.D_E_L_E_T_ = '' "
    cSql += " ORDER BY SD2.D2_ITEM "

    If Select("ItemTemp") > 0
        dbCloseArea()
    EndIf

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ItemTemp,.T.,.T.)
    (ItemTemp)->(dbGoTop())

    While (ItemTemp)->(!Eof())
        QtdEtiq := (ItemTemp)->D2_QUANT

        cET_DESCRICAO := AllTrim( (ItemTemp)->B1_DESC )
        cET_ATLREF := AllTrim( (ItemTemp)->B1_ATLREF )
        cET_QUANT := 10
        cET_NOTA := AllTrim( (ItemTemp)->D2_DOC )
        cET_EMISSAO := AllTrim( (ItemTemp)->D2_EMISSAO )
        cET_PEDIDO := AllTrim( (ItemTemp)->D2_PEDIDO )
        cET_CODEMB := "EM180000"
        nET_EMPMAX := MV_PAR04
        cET_MODELO := MV_PAR03
        cET_DATAVALIDADE := AllTrim( (ItemTemp)->VALIDADE )     
        fET_PESO := (ItemTemp)->B1_PESO
        fET_PESOBRUTO := (B1_PESO * QtdEtiq) + 0.35
        

        For i := 1 TO QtdEtiq / 10
            cET_VOLUME := STR(i) + " PACOTE"

            AAdd( aEtiq, {  cET_DESCRICAO,;
                            cET_ATLREF,;
                            cET_QUANT,;
                            cET_NOTA,;
                            cET_EMISSAO,;
                            cET_PEDIDO,;
                            cET_CODEMB,;
                            nET_EMPMAX,;
                            cET_MODELO,;
                            cET_DATAVALIDADE,;
                            cET_VOLUME,;
                            fET_PESO,;
                            fET_PESOBRUTO })
        Next i
        (ItemTemp)->(dbSkip())  
    EndDo

    If ! Empty( aEtiq )
  		ImpEt( aEtiq )
	EndIf

    dbCloseArea(ItemTemp)

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
	Local cFile    := "ETIQHPE"+StrTran( Time(), ":", "" ) + ".PRN" 
	Local nHdl     := -1
	Local nLoop    := 0
    Local nLoop2 := 0

	nHdl := FCreate( cTempDir+cFile ) 
	If nHdl < 0
		apMsgAlert("Erro na geração do arquivo temporário. Erro : " + AllTrim(Str(FError())) )
	EndIf
	
    //For nLoop := 1 to Len( aEtiq )
    For nLoop := 1 to 2
        IncProc()
        FWrite(nHdl, " CT~~CD,~CC^~CT~" + CRLF)
        FWrite(nHdl, " ^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ" + CRLF)
        FWrite(nHdl, " ^XA" + CRLF)
        FWrite(nHdl, " ^MMT" + CRLF)
        FWrite(nHdl, " ^PW815" + CRLF)
        FWrite(nHdl, " ^LL1215" + CRLF)
        FWrite(nHdl, " ^LS0" + CRLF)
        FWrite(nHdl, " ^FO32,1056^GFA,01280,01280,00008,:Z64:eJzlkzFugzAUhp+FUIYOLGWMcoXeoHToTiWsLPUdWKIulUJv1CMY9QIMZQtSDlCpSF1Qi3Dt935LpFcoC/nyYfP4nx9RvIySu5v4prQGyx9qMKYUdqN4vQe7xnPf94MFn8Xr2vOnLFD3w2A6zy/gu17rcsWt3yD4Zt59sa/yB/ZzNrJ/TMuS/eZ8w17Ye+b2lHbsn8UX13iesjGwpY14SsT738JE4kkFtuDoz+AO/AHW4J9JeOiFnbPic431bpL12sj+O/7egnacj6WM2VLK3x+5oFSXF35r1nxXim8n4fYd6xf4Cn6G73PO3x4l7yI9YH+H/XO8n/B+SpGHEn+ZR8gn1D+CT/ALeF8gj0W470vkM0k++sD9eXPu+zXUpwfpf4L6SM5HQ1eojwz6lYyr/sR+teBYTwUOh5P704HRL12B56Th+qq05nrmjby/Sp9wXmJ/BmEV88nX9VhSqvtzfupVXjGfOZ6fMp6XBvnUSnhBPrquMU8hH2NkAI8yXxTmK/AtBnKL+UlWA8oDmwn7J7h+b3i9vw4FrS+l6N9dv6+oDhU=:C002" + CRLF)
        // FWrite(nHdl, " eJzlkzFugzAUhp+FUIYOLGWMcoXeoHToTiWsLPUdWKIulUJv1CMY9QIMZQtSDlCpSF1Qi3Dt935LpFcoC/nyYfP4nx9RvIySu5v4prQGyx9qMKYUdqN4vQe7xnPf94MFn8Xr2vOnLFD3w2A6zy/gu17rcsWt3yD4Zt59sa/yB/ZzNrJ/TMuS/eZ8w17Ye+b2lHbsn8UX13iesjGwpY14SsT738JE4kkFtuDoz+AO/AHW4J9JeOiFnbPic431bpL12sj+O/7egnacj6WM2VLK3x+5oFSXF35r1nxXim8n4fYd6xf4Cn6G73PO3x4l7yI9YH+H/XO8n/B+SpGHEn+ZR8gn1D+CT/ALeF8gj0W470vkM0k++sD9eXPu+zXUpwfpf4L6SM5HQ1eojwz6lYyr/sR+teBYTwUOh5P704HRL12B56Th+qq05nrmjby/Sp9wXmJ/BmEV88nX9VhSqvtzfupVXjGfOZ6fMp6XBvnUSnhBPrquMU8hH2NkAI8yXxTmK/AtBnKL+UlWA8oDmwn7J7h+b3i9vw4FrS+l6N9dv6+oDhU=:C002" + CRLF)
        FWrite(nHdl, " ^BY4,3,85^FT452,610^BCB,,Y,Y" + CRLF)
        FWrite(nHdl, " ^FD>:"+ AllTrim(Str(aEtiq[nLoop, ET_QUANT])) +"^FS" + CRLF)
        FWrite(nHdl, " ^BY4,3,87^FT452,1153^BCB,,Y,Y" + CRLF)
        FWrite(nHdl, " ^FD>:"+ AllTrim(aEtiq[nLoop, ET_ATLREF]) +"^FS" + CRLF)
        FWrite(nHdl, " ^FO1,1032^GB123,0,4^FS" + CRLF)
        FWrite(nHdl, " ^FO0,343^GB657,0,4^FS" + CRLF)
        FWrite(nHdl, " ^FO654,345^GB0,862,4^FS" + CRLF)
        FWrite(nHdl, " ^FO512,346^GB0,860,4^FS" + CRLF)
        FWrite(nHdl, " ^FO253,9^GB0,336,4^FS" + CRLF)
        FWrite(nHdl, " ^FO654,9^GB0,334,4^FS" + CRLF)
        FWrite(nHdl, " ^FO416,9^GB0,336,3^FS" + CRLF)
        FWrite(nHdl, " ^FO512,9^GB0,335,4^FS" + CRLF)
        FWrite(nHdl, " ^FO173,8^GB0,337,3^FS" + CRLF)
        FWrite(nHdl, " ^FO332,9^GB0,336,4^FS" + CRLF)
        FWrite(nHdl, " ^FO93,9^GB0,336,4^FS" + CRLF)
        FWrite(nHdl, " ^FO254,345^GB0,861,3^FS" + CRLF)
        FWrite(nHdl, " ^FO123,348^GB0,859,4^FS" + CRLF)
        FWrite(nHdl, " ^FT687,402^A0B,28,28^FH\^FDQUALIDADE^FS" + CRLF)
        FWrite(nHdl, " ^FT150,1190^A0B,23,24^FH\^FDDESCRI\80\C7O^FS" + CRLF)
        FWrite(nHdl, " ^FT281,1188^A0B,23,24^FH\^FDC\E3DIGO^FS" + CRLF)
        FWrite(nHdl, " ^FT285,616^A0B,28,28^FH\^FDQTD^FS" + CRLF)
        FWrite(nHdl, " ^FT768,1192^A0B,25,24^FH\^FDR PREF. ANDRELINO VAZ DE ARRUDA, 830 - PQ IND WILLIAM DIB JORGE^FS" + CRLF)
        FWrite(nHdl, " ^FT735,1192^A0B,25,24^FH\^FDMIDORI AUTO LEATHER BRASIL LTDA^FS" + CRLF)
        FWrite(nHdl, " ^FT599,233^A0B,34,33^FH\^FD"+ AllTrim(aEtiq[nLoop, ET_VOLUME]) +"^FS" + CRLF)
        FWrite(nHdl, " ^FT504,241^A0B,31,31^FH\^FD"+ Substr(aEtiq[nLoop, ET_DATAVALIDADE], 7, 2) + "/" + Substr(aEtiq[nLoop, ET_DATAVALIDADE], 5, 2) + "/" + Substr(aEtiq[nLoop, ET_DATAVALIDADE], 0, 4) +"^FS" + CRLF)
        FWrite(nHdl, " ^FT407,247^A0B,31,31^FH\^FD"+ AllTrim(aEtiq[nLoop, ET_MODELO]) +"^FS" + CRLF)
        FWrite(nHdl, " ^FT245,211^A0B,28,28^FH\^FD"+ AllTrim(Str(aEtiq[nLoop, ET_PESOBRUTO])) +"^FS" + CRLF)
        FWrite(nHdl, " ^FT323,180^A0B,28,28^FH\^FD"+ AllTrim(Str(aEtiq[nLoop, ET_EMPMAX])) +"^FS" + CRLF)
        FWrite(nHdl, " ^FT166,214^A0B,28,28^FH\^FD"+ AllTrim(Str(aEtiq[nLoop, ET_PESO])) +"^FS" + CRLF)
        FWrite(nHdl, " ^FT599,653^A0B,34,33^FH\^FD"+ aEtiq[nLoop, ET_PEDIDO] +"^FS" + CRLF)
        FWrite(nHdl, " ^FT599,909^A0B,34,33^FH\^FD"+ Substr(aEtiq[nLoop, ET_EMISSAO], 7, 2) + "/" + Substr(aEtiq[nLoop, ET_EMISSAO], 5, 2) + "/" + Substr(aEtiq[nLoop, ET_EMISSAO], 0, 4) +"^FS" + CRLF)
        FWrite(nHdl, " ^FT599,1159^A0B,34,33^FH\^FD"+ aEtiq[nLoop, ET_NOTA] +"^FS" + CRLF)
        FWrite(nHdl, " ^FT689,1192^A0B,31,31^FH\^FDFORNECEDOR^FS" + CRLF)
        // FWrite(nHdl, " ^FT212,1035^A0B,34,33^FH\^FDCAPA ASSENTO BANCO DIANT. LE COURO 2^FS" + CRLF)
        FWrite(nHdl, " ^FT154,1035^A0B,28,28^FH\^FD"+ aEtiq[nLoop, ET_DESCRICAO] +"^FS" + CRLF)
        FWrite(nHdl, " ^FT544,696^A0B,28,28^FH\^FDPEDIDO^FS" + CRLF)
        FWrite(nHdl, " ^FT545,957^A0B,28,28^FH\^FDDATA DE EMISS\C7O^FS" + CRLF)
        FWrite(nHdl, " ^FT545,1194^A0B,28,28^FH\^FDN\A7 NOTA^FS" + CRLF)
        FWrite(nHdl, " ^FT545,338^A0B,28,28^FH\^FDVOLUME^FS" + CRLF)
        FWrite(nHdl, " ^FT448,338^A0B,28,28^FH\^FDITEM V\B5LIDO AT\90^FS" + CRLF)
        FWrite(nHdl, " ^FT364,337^A0B,28,28^FH\^FDMODELO^FS" + CRLF)
        FWrite(nHdl, " ^FT286,339^A0B,28,28^FH\^FDEMP. M\B5XIMO^FS" + CRLF)
        FWrite(nHdl, " ^FT205,338^A0B,28,28^FH\^FDPESO BRUTO (KG)^FS" + CRLF)
        FWrite(nHdl, " ^FT125,337^A0B,28,28^FH\^FDPESO POR PE\80A (KG)^FS" + CRLF)
        FWrite(nHdl, " ^FT37,338^A0B,28,28^FH\^FDC\E3D. EMBALAGEM^FS" + CRLF)
        FWrite(nHdl, " ^FT43,1029^A0B,31,31^FH\^FDHPE AUTOMOTORES DO BRASIL LTDA^FS" + CRLF)
        FWrite(nHdl, " ^FT113,1031^A0B,23,24^FH\^FDCEP: 75709-901 - FONE: (64) 3441-8584 ou (64) 3441-8581^FS" + CRLF)
        FWrite(nHdl, " ^FT79,1030^A0B,23,24^FH\^FDRod. BR-050, Km 283, Quadras 5, 7, 7-A, S/N DIMIC-Catal\C6o-GO^FS" + CRLF)
        FWrite(nHdl, " ^FO655,409^GB155,0,3^FS" + CRLF)
        FWrite(nHdl, " ^FO256,621^GB259,0,3^FS" + CRLF)
        FWrite(nHdl, " ^FO516,701^GB139,0,3^FS" + CRLF)
        FWrite(nHdl, " ^FT83,257^A0B,39,38^FH\^FD"+ aEtiq[nLoop, ET_CODEMB] +"^FS" + CRLF)
        FWrite(nHdl, " ^FO513,963^GB145,0,3^FS" + CRLF)
        FWrite(nHdl, " ^PQ1,0,1,Y^XZ" + CRLF)
    
    Next nLoop
 
	FClose( nHdl )
	WinExec( "CMD /C TYPE " + cTempDir + cFile + " > " + "LPT1")

	
Return( nil )