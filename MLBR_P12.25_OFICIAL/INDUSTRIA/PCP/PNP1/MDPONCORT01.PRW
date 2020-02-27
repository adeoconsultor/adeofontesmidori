#Include 'Protheus.ch'
#Include 'Parmtype.ch'


//==========================================================================================
// MDPONCORT - Guilherme Suganame - SETEMBRO/2019   |   Revisao/Ajuste: //
//------------------------------------------------------------------------------------------
// Descrição
// Impressão de etiquetas ASX
//------------------------------------------------------------------------------------------
// Parametros
// nenhum
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================


User Function MDPONCORT()  

	Local oPerg
	Private cPerg  := "MDPONCORT"
	oPerg := AdvplPerg():New( cPerg )
    
    oPerg:AddPerg( "Quantidade"   , "N", 3 ,   ,) //1 
    oPerg:AddPerg( "Título"   , "C", 50 ,   ,) //2 
    oPerg:AddPerg( "Descrição"   , "C", 50 ,   ,) //2 
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

	Local aEtiq       := {}

    Local cET_TITULO := ""
    Local cET_DESCRICAO := ""
    Local nLoop := 0

	ProcRegua( 0 )

    // verifica se o parametro de controle existe
	// Se nao existir, cria

    For nLoop := 1 to MV_PAR01

        cET_TITULO = Upper(AllTrim(MV_PAR02))
        cET_DESCRICAO = Upper(AllTrim(MV_PAR03))

        AAdd( aEtiq, {  cET_TITULO, ; 
                        cET_DESCRICAO })
        

    Next nLoop

	If ! Empty( aEtiq )
  		ImpEt( aEtiq )
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
	Local cFile    := "ETIQPONCORT"+StrTran( Time(), ":", "" ) + ".PRN" 
	Local nHdl     := -1
	Local nLoop    := 0

	nHdl := FCreate( cTempDir+cFile ) 
	If nHdl < 0
		apMsgAlert("Erro na geração do arquivo temporário. Erro : " + AllTrim(Str(FError())) )
	EndIf
	
	For nLoop := 1 to Len( aEtiq )
		IncProc()

        // FWrite(nHdl, "CT~~CD,~CC^~CT~" + CRLF)
        // FWrite(nHdl, "^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ" + CRLF)
        // FWrite(nHdl, "^XA" + CRLF)
        // FWrite(nHdl, "^MMT" + CRLF)
        // FWrite(nHdl, "^PW559" + CRLF)
        // FWrite(nHdl, "^LL0400" + CRLF)
        // FWrite(nHdl, "^LS0" + CRLF)
        // FWrite(nHdl, "^BY3,3,139^FT112,259^BCN,,N,N" + CRLF)
        // FWrite(nHdl, "^FD>;"+ aEtiq[nLoop] +"^FS" + CRLF)
        // FWrite(nHdl, "^FT174,292^A0N,31,31^FH\^FD"+ aEtiq[nLoop] +"^FS" + CRLF)
        // FWrite(nHdl, "^PQ1,0,1,Y^XZ" + CRLF)
        
        FWrite(nHdl, "CT~~CD,~CC^~CT~" + CRLF)
        FWrite(nHdl, "^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ" + CRLF)
        FWrite(nHdl, "^XA" + CRLF)
        FWrite(nHdl, "^MMT" + CRLF)
        FWrite(nHdl, "^PW519" + CRLF)
        FWrite(nHdl, "^LL0400" + CRLF)
        FWrite(nHdl, "^LS0" + CRLF)
        // FWrite(nHdl, "^FT433,53^A0R,39,38^FH\^FDPONTO DE CORTE^FS" + CRLF)
        // FWrite(nHdl, "^FT373,72^A0R,34,33^FH\^FD"+ aEtiq[nLoop] +"^FS" + CRLF)
        // FWrite(nHdl, "^FT187,311^A0B,34,33^FH\^FD"+ aEtiq[nLoop] +"^FS" + CRLF)
        // FWrite(nHdl, "^FT127,330^A0B,39,38^FH\^FDPONTO DE CORTE^FS" + CRLF)

        FWrite(nHdl, "^FT433,53^A0R,39,38^FH\^FD"+ aEtiq[nLoop, 1] +"^FS " + CRLF)
        FWrite(nHdl, "^FT375,88^A0R,28,28^FH\^FD"+ SubStr(aEtiq[nLoop, 2], 1, 15) +"^FS " + CRLF)
        FWrite(nHdl, "^FT334,88^A0R,28,28^FH\^FD"+ SubStr(aEtiq[nLoop, 2], 16, 30) +"^FS " + CRLF)        
        FWrite(nHdl, "^FT199,295^A0B,28,28^FH\^FD" + SubStr(aEtiq[nLoop, 2], 1, 15) + "^FS+ " + CRLF)
        FWrite(nHdl, "^FT240,295^A0B,28,28^FH\^FD" + SubStr(aEtiq[nLoop, 2], 16, 30) + "^FS+ " + CRLF)        
        FWrite(nHdl, "^FT149,330^A0B,39,38^FH\^FD"+ aEtiq[nLoop, 1] +"^FS" + CRLF)
        FWrite(nHdl, "^PQ1,0,1,Y^XZ" + CRLF)
	
	Next nLoop                                    
 
	FClose( nHdl )
	WinExec( "CMD /C TYPE " + cTempDir + cFile + " > " + "LPT2")

	
Return( nil )