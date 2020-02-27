#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MdrTrw01
@description Rotina de impressão das etiquetas da TRW (Etiqueta de volante).
@author abfre
@since 16/12/2016
@version 11
@type function
/*/
user function MdrTrw01()

	Local cPerg := "MDRTRW01"
	Local oPerg := AdvplPerg():New(cPerg)

	oPerg:AddPerg( "OP"        , "C", 11, 0,,"SC2" )
	oPerg:AddPerg( "Quantidade", "N", 06, 0 )
	oPerg:AddPerg( "Porta"     ,    ,   ,  ,{"LPT1","LPT2","LPT3","LPT4"} )
	oPerg:SetPerg()

	If ! Pergunte( cPerg, .t. )
		Return( nil )
	EndIf

	Processa( {|| SetEtiq() }, "Aguarde..." )

return( nil )

//********************************************************************************************************************************

Static Function SetEtiq()

	Local nJuliana := dDataBase - Stod(StrZero(Year(dDataBase),4)+"0101")  // Quantidade de dias desde o inicio do ano
	Local nLoop    := 0

	Local cPar     := "MDRTRW0101" // Retorna um serial para a data - conteudo: AAAAMMDDSSSSS
	Local cPnTrw      // 10 dig max
	Local cPnCli      // 16 dig max
	Local cJuliana    // 03 dig
	Local cAnoPrd     // 02 dig 
	Local cSerial     // 05 dig

	// verifica se o parametro de controle existe
	// Se não existir, cria
	dbSelectArea("SX6")
	dbSetOrder(1)
	If ! dbSeek( fwFilial() + cPar )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := fwFilial()
		SX6->X6_VAR     := cPar
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Serial TRW"
		SX6->X6_CONTEUD := SubStr( SX6->X6_CONTEUD,1,8 ) + Soma1( SubStr(SX6->X6_CONTEUD,9,5) )
		MsUnlock()
	EndIf

	// Define o serial. Todos os dias o serial é reiniciado
	RecLock("SX6",.F.)
	If StoD( SubStr(SX6->X6_CONTEUD,1,8) ) <> dDataBase
		SX6->X6_CONTEUD := DtoS( dDataBase ) + "00001"
	EndIf
	MsUnlock()

	// Posiciona na OP para saber qual é o produto que vai sair na etiqueta
	dbSelectArea("SC2")
	dbSetOrder(1)
	If ! dbSeek( xFilial("SC2") + Trim( mv_par01 ) )
		apMsgAlert("OP "+Trim(mv_par01)+" não existe.")
		Return( nil )
	EndIf

	dbSelectArea("SB1")
	dbSetOrder(1)
	If ! dbSeek( xFilial("SB1") + SC2->C2_PRODUTO )
		apMsgAlert( "PRODUTO informado na OP " + Trim(mv_par01) + " não está cadastrado." )
		Return( nil )
	EndIf

	// SE QUANTIDADE NAO FOR INFORMADA
	// ASSUME A QUANTIDADE TOTAL DA OP
	If Empty( mv_par02 )
		mv_par02 := SC2->C2_QUANT
	EndIf

	If ! MsgYesNo( "Deseja imprimir " +AllTrim(Str(mv_par02))+ " etiquetas do produto " + Trim(SB1->B1_COD) + "-" + Trim(SB1->B1_DESC) + " ?" )
		Return( nil )
	EndIf

	If SB1->( FieldPos("B1_ATLREF") ) > 0
		cPnTrw   := AllTrim(SB1->B1_ATLREF)        // 10 dig max
	Else
		cPnTrw   := AllTrim("9999999999")        // 10 dig max
	EndIf
	cPnCli   := AllTrim(SB1->B1_COD)         // 16 dig max
	cJuliana := StrZero( nJuliana, 3)        // 03 dig
	cAnoPrd  := SubStr( SX6->X6_CONTEUD,3,2) // 02 dig 
	cSerial  := SubStr( SX6->X6_CONTEUD,9,5) // 05 dig

	ProcRegua( mv_par02 )

	IncProc()
	If ! PrintEtiq( cPnTrw, cPnCli, cJuliana, cAnoPrd, cSerial )
		Return( nil )
	EndIf

Return( nil )

//*********************************************************************************************************************

Static Function PrintEtiq( cPnTrw, cPnCli, cJuliana, cAnoPrd, cSerial )

	Local cString   := ""
	Local cFile     := Lower( CriaTrab(nil,.f.)+".prn" )
	Local nHdl      := -1
	Local cPath     := GetTempPath(.t.)
	Local cCompleto := ""
	Local cCmd      := ""
	Local cPorta    := "LPT"+AllTrim(Str(mv_par03))
	Local nLoop

	If SubStr(cPath,Len(cPath),1) <> "\"
		cPath := Trim( cPath ) + "\"
	EndIf

	cCompleto := cPath + cFile
	// Cria um arquivo temporario com a etiqueta  
	//ALERT(cCompleto)
	nHdl := fCreate( cCompleto )

	If nHdl < 0
		apMsgInfo( "impossível criar o arquivo " + cCompleto )
		Return( .f. )
	EndIf

	For nLoop := 1 to mv_par02
		fWrite( nHdl,"CT~~CD,~CC^~CT~"+CRLF)
		fWrite( nHdl,"^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ"+CRLF)
		fWrite( nHdl,"^XA"+CRLF)
		fWrite( nHdl,"^MMT"+CRLF)
		fWrite( nHdl,"^PW160"+CRLF)
		fWrite( nHdl,"^LL0102"+CRLF)
		fWrite( nHdl,"^LS0"+CRLF)
		fWrite( nHdl,"^BY66,66^FT86,74^BXB,3,200,22,22,1,~"+CRLF)
		fWrite( nHdl,"^FH\^FD\7E1"+cPnTrw+"\7E1"+cJuliana+"\7E1"+cAnoPrd+"\7E1"+cSerial+"^FS"+CRLF)
		fWrite( nHdl,"^FT104,75^A0B,17,16^FH\^FD"+cPnTrw+"^FS"+CRLF)
		fWrite( nHdl,"^FT119,75^A0B,17,16^FH\^FD"+cJuliana+cAnoPrd+"^FS"+CRLF)
		fWrite( nHdl,"^FT135,75^A0B,17,16^FH\^FD"+cSerial+"^FS"+CRLF)
		fWrite( nHdl,"^FT153,75^A0B,17,16^FH\^FDTRW ONLY^FS"+CRLF)
		fWrite( nHdl,"^PQ1,0,1,Y^XZ"+CRLF)

		cSerial := Soma1( cSerial )

		// Grava o próximo serial livre
		RecLock( "SX6",.F. )
		SX6->X6_CONTEUD := SubStr( SX6->X6_CONTEUD,1,8 ) + cSerial
		MsUnlock()

	Next nLoop

	fClose( nHdl )

	If ! File( cCompleto )
		msgInfo( "Arquivo " + cCompleto + " não existe!" )
	EndIf
    
	nHdl := FCreate( cPath + "imprime.bat" )
	// Imprime a etiqueta dando um type na porta LPT local (smartclient)
	cCmd := "CD " + cPath + CRLF
   	//	cCmd += "TYPE %1 "+Chr(62)+cPorta   	// nao consegue encontrar arquivo para impressao
	cCmd += "TYPE "+cCompleto+Chr(62)+cPorta 	// linha corrigida - Diego em 09/03/17
	fWrite( nHdl,cCmd )
	fClose( nHdl )

	WinExec( "CMD /C " + cPath + "imprime.bat "+cFile )

	// WinExec( "CMD /C TYPE "+cCompleto+" > "+cPorta )

	// Apaga o arquivo pra não ficar com lixo na pasta
	//fErase( cCompleto )  // se habilitado nao imprimi - Diego 10/03/2017


Return( .t. )