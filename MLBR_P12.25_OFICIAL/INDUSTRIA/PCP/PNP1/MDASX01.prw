#Include 'Protheus.ch'
#Include 'Parmtype.ch'


//==========================================================================================
// MDASX01 - Guilherme Suganame - Junho/2019   |   Revisao/Ajuste: //
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


User Function MDASX01()  

	Local oPerg
	Private cPerg  := "MDASX01"
    Private aTipo := {"Motorista", "Passageiro"}
	oPerg := AdvplPerg():New( cPerg )
    
	//-------------------------------------------------------------------
	// AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
	// Parametriza as perguntas
	//-------------------------------------------------------------------
    oPerg:AddPerg( "Tipo da Etiqueta"   ,    ,   ,   ,aTipo       ) //1
    oPerg:AddPerg( "Data"              , "D" ,  9,   ,      , ""    ) //2    
    oPerg:AddPerg( "Quantidade"   , "N", 3 ,   ,) //3 
    oPerg:AddPerg( "Inicia em"   , "C", 3 ,   ,) //4 
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
    Local nSerial := 0
    Local cData :=  DtoS(MV_PAR02)

    Local cET_TIPO := ""
    Local cET_SEQ := ""
    Local cET_DATA := ""
    Local cET_CODBAR := ""
    Local nLoop := 0

	ProcRegua( 0 )

    // verifica se o parametro de controle existe
	// Se nao existir, cria

    nSerial := Val(MV_PAR04) - 1

    For nLoop := 1 to MV_PAR03

        nSerial := nSerial + 1

        If MV_PAR01 == 1
            cET_TIPO := "1"
        Else
            cET_TIPO := "2"
        EndIf

        cET_DATA := substr(AllTrim(cData), 7, 2) + substr(AllTrim(cData), 5, 2) + substr(AllTrim(cData), 3, 2)

        cET_CODBAR := cET_TIPO + cET_DATA + PadL( AllTrim(Str(nSerial)), 3, "0" ) + "0101"
        AAdd( aEtiq, cET_CODBAR ) 		
        

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
	Local cFile    := "ETIQASX"+StrTran( Time(), ":", "" ) + ".PRN" 
	Local nHdl     := -1
	Local nLoop    := 0

	nHdl := FCreate( cTempDir+cFile ) 
	If nHdl < 0
		apMsgAlert("Erro na geração do arquivo temporário. Erro : " + AllTrim(Str(FError())) )
	EndIf
	
	For nLoop := 1 to Len( aEtiq )
		IncProc()

        FWrite(nHdl, "CT~~CD,~CC^~CT~" + CRLF)
        FWrite(nHdl, "^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ" + CRLF)
        FWrite(nHdl, "^XA" + CRLF)
        FWrite(nHdl, "^MMT" + CRLF)
        FWrite(nHdl, "^PW559" + CRLF)
        FWrite(nHdl, "^LL0400" + CRLF)
        FWrite(nHdl, "^LS0" + CRLF)
        FWrite(nHdl, "^BY3,3,139^FT112,259^BCN,,N,N" + CRLF)
        FWrite(nHdl, "^FD>;"+ aEtiq[nLoop] +"^FS" + CRLF)
        FWrite(nHdl, "^FT174,292^A0N,31,31^FH\^FD"+ aEtiq[nLoop] +"^FS" + CRLF)
        FWrite(nHdl, "^PQ1,0,1,Y^XZ" + CRLF)

       
        // FWrite(nHdl, "CT~~CD,~CC^~CT~" + CRLF)
        // FWrite(nHdl, "^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ" + CRLF)
        // FWrite(nHdl, "^XA" + CRLF)
        // FWrite(nHdl, "^MMT" + CRLF)
        // FWrite(nHdl, "^PW799" + CRLF)
        // FWrite(nHdl, "^LL0519" + CRLF)
        // FWrite(nHdl, "^LS0" + CRLF)
        // FWrite(nHdl, "^BY3,3,139^FT103,87^BCR,,N,N" + CRLF)
        // FWrite(nHdl, "^FD>;"+ aEtiq[nLoop] +"^FS" + CRLF)
        // FWrite(nHdl, "^BY3,3,139^FT431,422^BCB,,N,N" + CRLF)
        // FWrite(nHdl, "^FD>;"+ aEtiq[nLoop] +"^FS" + CRLF)
        // FWrite(nHdl, "^FT70,148^A0R,31,31^FH\^FD"+ aEtiq[nLoop] +"^FS" + CRLF)
        // FWrite(nHdl, "^FT464,358^A0B,31,31^FH\^FD"+ aEtiq[nLoop] +"^FS" + CRLF)
        // FWrite(nHdl, "^PQ1,0,1,Y^XZ" + CRLF)
	
	Next nLoop                                    
 
	FClose( nHdl )
	WinExec( "CMD /C TYPE " + cTempDir + cFile + " > " + "LPT1")

	
Return( nil )