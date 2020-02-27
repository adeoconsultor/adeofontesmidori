#Include 'Protheus.ch'
#Include 'Parmtype.ch'

#Define ET_CODPRO   1
#Define ET_BARPRO   2
#Define ET_QTDE     3
#Define ET_BARQTDE  4
#Define ET_DESPRO   5
#Define ET_FORNECE  6
#Define ET_BARFOR   7
#Define ET_DATA     8  
#Define ET_REVIS    9  
#Define ET_PACKNR   10
#Define ET_BARPACK  11
#Define ET_LOTE     12
#Define ET_BARLOTE  13

//==========================================================================================
// MDAUTL01 - Antonio Carlos Damaceno - Advpl Tec - Dez/2018   |   Revisao/Ajuste: //
//------------------------------------------------------------------------------------------
// Descrição
// Impressão de etiquetas de codigo de barra para AUTOLIV
//------------------------------------------------------------------------------------------
// Parametros
// nenhum
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
// [)><RS>06<GS>3S0000000004<GS>V90965012<GS>P642018102A<GS>A<GS>Q60<GS>1T12345678901<RS><EOT>


User Function MDAUTL01()  

	Local oPerg
	Local cSql    := ""

	Private cPerg  := "MDAUTL01"
	Private aPorta := {"LPT1","LPT2","LPT3"}

	oPerg := AdvplPerg():New( cPerg )

	//-------------------------------------------------------------------
	// AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
	// Parametriza as perguntas
	//-------------------------------------------------------------------
	oPerg:AddPerg( "Nota Fiscal"        , "C" , 9 ,   ,      , ""    )                 //1
	oPerg:AddPerg( "Serie"              , "C" , 3 ,   ,      , ""    )                 //2
	oPerg:AddPerg( "Qtde de Caixas"     , "N" , 3 ,   ,      ,       )                 //3
	oPerg:AddPerg( "Porta Impressão"    ,     ,   ,   ,aPorta        )                 //4
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

	Local nLoop
	Local aEtiq       := {}
	Local cAliasTST   := GetNextAlias()
	Local cET_CODPRO  := ""
	Local cET_BARPRO  := ""
	Local nET_QTDE    := 0
	Local cET_BARQTDE := ""
	Local cET_DESPRO  := ""
	Local cET_FORNECE := '90965012'        //VALOR FIXO (CODIGO DE FORNECEDOR NO CLIENTE DA PROPRIA MIDORI)
	Local cET_BARFOR  := ""
	Local dET_DATA    := "" 
	Local cET_REVIS   := 'A'
	Local cET_PACKNR  := ""
	Local cET_BARPACK := ""
	Local cET_LOTE    := ""
	Local cET_BARLOTE := "" 
	Local cCodPro     := ""
	Local cDescr      := ""
	Local cRevis      := "A"

	ProcRegua( 0 )

	// verifica se o parametro de controle existe
	// Se não existir, cria
	dbSelectArea("SX6")
	dbSetOrder(1)
	If ! dbSeek( xFilial("SX6") + 'MV_AUTOLIV' )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6") 
		SX6->X6_VAR     := 'MV_AUTOLIV'
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Serial Autoliv"
		SX6->X6_CONTEUD := '1'
		MsUnlock()
	EndIf
	
/*	cSql := " SELECT SC2.C2_FILIAL, SC2.C2_NUM, SC2.C2_PRODUTO, SC2.C2_LOCAL, SC2.C2_QUANT, SC2.C2_EMISSAO, SC2.C2_DATPRF "
	cSql += " FROM " + RetSqlName("SC2") + " SC2  "
	cSql += " JOIN " + RetSqlName("SB1") + " SB1 ON SC2.C2_PRODUTO = SB1.B1_COD               AND "
	cSql += "                                       SB1.B1_FILIAL  = '" + xFilial("SB1") + "' AND "
	cSql += "                                       SB1.D_E_L_E_T_ = ' ' "
	cSql += " WHERE "
	If !Empty(MV_PAR01) .And. !Empty(MV_PAR02)
		cSql += "       SC2.C2_NUM      BETWEEN '" + MV_PAR01 + "'  AND  '" + MV_PAR02 + "'  AND "
	EndIf
	If !Empty(MV_PAR03) .And. !Empty(MV_PAR04)
		cSql += "       SC2.C2_PRODUTO BETWEEN '" + MV_PAR03 + "'  AND  '" + MV_PAR04 + "'  AND "
	EndIf
	cSql += "       SC2.C2_FILIAL  = '" + xFilial("SC2") + "'  AND  SC2.D_E_L_E_T_ = ' ' "
	cSql += " ORDER BY SC2.C2_NUM "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasTST,.T.,.T.) 
*/

	cSql := " SELECT SF2.F2_FILIAL, SF2.F2_DOC, SF2.F2_SERIE, SD2.D2_COD, SD2.D2_ITEM, SD2.D2_QUANT, SB1.B1_DESC, SB1.B1_ATLREF, SB1.B1_UM, SF2.F2_CHVNFE, "
	cSql += " SD2.D2_LOTECTL, SF2.F2_EMISSAO "
//	cSql += " (SELECT SZP.ZP_NUM    FROM SZP010 SZP WHERE SZP.ZP_OPMIDO = '"+MV_PAR03+"' AND SZP.ZP_FILIAL = '" + xFilial("SZP") + "' AND SZP.D_E_L_E_T_ = ' ') AS ZP_NUM, "
//	cSql += " (SELECT SZP.ZP_QUANT  FROM SZP010 SZP WHERE SZP.ZP_OPMIDO = '"+MV_PAR03+"' AND SZP.ZP_FILIAL = '" + xFilial("SZP") + "' AND SZP.D_E_L_E_T_ = ' ') AS ZP_QUANT, "
//	cSql += " (SELECT SZP.ZP_OPMIDO FROM SZP010 SZP WHERE SZP.ZP_OPMIDO = '"+MV_PAR03+"' AND SZP.ZP_FILIAL = '" + xFilial("SZP") + "' AND SZP.D_E_L_E_T_ = ' ') AS ZP_OPMIDO "
	cSql += " FROM " + RetSqlName("SF2") + " SF2  "
	cSql += " JOIN " + RetSqlName("SD2") + " SD2 ON SF2.F2_DOC     = SD2.D2_DOC               AND "
	cSql += "                                       SF2.F2_SERIE   = SD2.D2_SERIE             AND "
	cSql += "                                       SF2.F2_CLIENTE = SD2.D2_CLIENTE           AND "
	cSql += "                                       SF2.F2_LOJA    = SD2.D2_LOJA              AND "
	cSql += "                                       SD2.D2_FILIAL  = '" + xFilial("SD2") + "' AND "
	cSql += "                                       SD2.D_E_L_E_T_ = ' ' "
	cSql += " JOIN " + RetSqlName("SB1") + " SB1 ON SD2.D2_COD     = SB1.B1_COD               AND "
	cSql += "                                       SB1.B1_FILIAL  = '" + xFilial("SB1") + "' AND "
	cSql += "                                       SB1.D_E_L_E_T_ = ' ' "
	cSql += " WHERE SF2.F2_DOC     = '" + MV_PAR01 + "'       AND "
	cSql += "       SF2.F2_SERIE   = '" + MV_PAR02 + "'       AND "
	cSql += "       SF2.F2_FILIAL  = '" + xFilial("SF2") + "' AND " 
	cSql += "       SF2.D_E_L_E_T_ = ' ' "
	cSql += " ORDER BY SB1.B1_ATLREF "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasTST,.T.,.T.) 
			
	(cAliasTST)->(dbGoTop())

	zzLin := 0

	While (cAliasTST)->(!Eof())

		zzLin:=zzlin+1  
		
		For nLoop := 1 to MV_PAR03

			cProduto := (cAliasTST)->B1_ATLREF
			cDescr   := (cAliasTST)->B1_DESC
	
			cET_CODPRO   := SUBSTR( (cAliasTST)->B1_ATLREF , 1, AT(' ' , (cAliasTST)->B1_ATLREF ) )
			cET_BARPRO   := SUBSTR( (cAliasTST)->B1_ATLREF , 1, AT(' ' , (cAliasTST)->B1_ATLREF ) )
			nET_QTDE     := Transform(((cAliasTST)->D2_QUANT/ MV_PAR03),"@E999999")   
			cET_BARQTDE  := Transform(((cAliasTST)->D2_QUANT/ MV_PAR03),"@E999999")
			cET_DESPRO   := cDescr
			cET_FORNECE  := '90965012'
			cET_BARFOR   := cET_FORNECE
			dET_DATA     := (cAliasTST)->F2_EMISSAO
			cET_REVIS    := cRevis                                                                  
			cET_PACKNR   := StrZero(Val(GetMV("MV_AUTOLIV")),10)
			cET_BARPACK  := StrZero(Val(GetMV("MV_AUTOLIV")),10)
			cET_LOTE     := IIf( !Empty( (cAliasTST)->D2_LOTECTL) , (cAliasTST)->D2_LOTECTL, AllTrim((cAliasTST)->F2_DOC)+AllTrim((cAliasTST)->F2_SERIE)    )
			cET_BARLOTE  := IIf( !Empty( (cAliasTST)->D2_LOTECTL) , (cAliasTST)->D2_LOTECTL, AllTrim((cAliasTST)->F2_DOC)+AllTrim((cAliasTST)->F2_SERIE)    )
	
			AAdd( aEtiq, {	cET_CODPRO    ,;
							cET_BARPRO    ,;
							nET_QTDE      ,;
							cET_BARQTDE   ,;
							cET_DESPRO    ,;
							cET_FORNECE   ,;
							cET_BARFOR    ,;
							dET_DATA      ,;
							cET_REVIS     ,;
							cET_PACKNR    ,;
							cET_BARPACK   ,;
							cET_LOTE      ,;
							cET_BARLOTE  } ) 
	
			cSerial := Val(GetMV("MV_AUTOLIV")) + 1
	
			// Grava o próximo serial livre
			dbSelectArea("SX6")
			dbSetOrder(1)
			If dbSeek( xFilial("SX6") + 'MV_AUTOLIV' )
				RecLock( "SX6",.F. )
				SX6->X6_CONTEUD := Str(cSerial)
				MsUnlock()
			EndIf
			
		Next nLoop                          
		
		(cAliasTST)->(dbSkip())          
					
	EndDo

	If ! Empty( aEtiq )
  		ImpEt( aEtiq )
	EndIf

	(cAliasTST)->(dbCloseArea())

Return( nil )




//==========================================================================================
// ImpEt - Antonio - Advpl Tecnologia - Fevereiro / 2018
//------------------------------------------------------------------------------------------
// Descrição
// Impressão de etiquetas TS TRIM.
//------------------------------------------------------------------------------------------
// Parametros
// aEtiq - Array de etiquetas
// { { NF, Serie, Sequencia, Código de Barras, Fornecedor, Lote, Qtde, UM, Cod Produto, 
//     Descrição Produto } }
// Código de barras formado por: (Letra N[1])+NF[9]+Serie[2]+Seq[003] -> N00005081101001
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
Static Function ImpEt( aEtiq )

	Local cTempDir := GetTempPath()
	Local cFile    := "ETIQ"+StrTran( Time(), ":", "" ) + ".PRN" 
	Local nHdl     := -1
	Local nLoop    := 0
//	Local dMMMAAAA:=SubStr(CMonth(dDataBase),1,3)+" "+Alltrim(Str(Year(dDataBase)))

	nHdl := FCreate( cTempDir+cFile ) 
	alert(cTempDir+cFile)
	If nHdl < 0
		apMsgAlert("Erro na geração do arquivo temporário. Erro : " + AllTrim(Str(FError())) )
	EndIf
	
	For nLoop := 1 to Len( aEtiq )
		IncProc()

		// Parametrizacao da etiqueta

		//nQtde   :=
		//nPackNr :=

		FWrite(nHdl,"CT~~CD,~CC^~CT~"+CRLF)
		FWrite(nHdl,"^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ"+CRLF)
//		MscbWrite("~DG000.GRF,02048,016,")
//		MscbWrite(",:::::::::::::::::::::I0F0F0F0F0F0F0F0F0F0F0F0F,:::H0HF0F0F00F00F0H0F0I0F0FF,:::I0F0FJFH0F00F0F0F0H0F0F,:::H0JFI0F0H0F0H0HFH0HF0FF,:::I0F00FF00FMF0FF0H0HF,:::H0F0H0F00F0FF0FHFH0KF0F,:::I0JF0FF0F0F00FF0F00F00F,:::H0HFI0HF0F0I0JF0FF0F0F,:::I0IF0F0F0FF0FJFH0F0FHF,:::H0F0F0FHFH0F0FHFI0HFJ0F,:::J0HFI0F00FHF0FMF0F,:::H0HFL0HFM0MF,:::I0F00F0F0F0F0FHF0FF00F0FF,:::H0F0F0F0J0HF0F0H0IF0FHF,:::I0IFI0HFH0HF0FHFH0F0H0F,:::H0F00F0FF0F0H0IF0F00F00FF,:::J0IF0F00F0FHFJ0JF0F,:::H0F0I0HF0F0FF0FHF0FLF,:::L0HF0F0F0K0F0F0I0F,:::H0F0F0I0JF0F0F0FF0F00FF,:::I0F0I0F00FF00FF00F0J0F,:::H0F0F0F0J0HF0F0H0F0FF00F,:::J0JFH0F00F00F0F0K0F,:::H0gJF,:::,:::::::::^XA")
		FWrite(nHdl,"^XA"+CRLF)
		FWrite(nHdl,"^MMT"+CRLF)
		FWrite(nHdl,"^PW591"+CRLF)
		FWrite(nHdl,"^LL1678"+CRLF)
		FWrite(nHdl,"^LS0"+CRLF)
//		FWrite(nHdl,"^FT32,640^XG000.GRF,1,1^FS"+CRLF)
		//FWrite(nHdl,"^FT17,1664^A0B,14,14^FH\^FD(8) Customer part no (P)^FS"+CRLF) 
		FWrite(nHdl,"^FT40,1669^A0B,14,14^FH\^FD(8) Customer part no (P)^FS"+CRLF)
		FWrite(nHdl,"^FT72,361^A0B,56,55^FH\^FDMADE IN ^FS"+CRLF)
		FWrite(nHdl,"^FT143,361^A0B,56,55^FH\^FDBRAZIL^FS"+CRLF)
		FWrite(nHdl,"^FT242,1053^A0B,56,55^FH\^FDKT^FS"+CRLF)
		FWrite(nHdl,"^FT242,1450^A0B,56,55^FH\^FD"+Transform(aEtiq[nLoop,ET_QTDE],"@E 999999")+"^FS"+CRLF)
		//FWrite(nHdl,"^FT226,704^A0B,56,55^FH\^FD" + aEtiq[nLoop,ET_DESPRO] + "^FS"+CRLF)
		FWrite(nHdl,"^FT226,730^A0B,36,35^FH\^FD" + Rtrim(aEtiq[nLoop,ET_DESPRO]) + "^FS"+CRLF) // descricao produto com letra menor
		FWrite(nHdl,"^FT331,505^A0B,56,55^FH\^FDMLBR^FS"+CRLF)
		FWrite(nHdl,"^FT442,294^A0B,56,55^FH\^FDA^FS"+CRLF)
		FWrite(nHdl,"^FT440,750^A0B,46,45^FH\^FDP" + DtoC(dDataBase)+"^FS"+CRLF)     //Data de produção ou data de expedição.
		FWrite(nHdl,"^FT513,596^A0B,56,55^FH\^FD"  + aEtiq[nLoop,ET_LOTE] + "^FS"+CRLF)
		FWrite(nHdl,"^FT518,1500^A0B,56,55^FH\^FD" + aEtiq[nLoop,ET_PACKNR]+"^FS"+CRLF)  //serial implementando + 1   
		FWrite(nHdl,"^FT379,1510^A0B,56,55^FH\^FD" + aEtiq[nLoop,ET_FORNECE] + "^FS"+CRLF)
//      [)><RS>06<GS>3S0000000004<GS>V90965012<GS>P642018102A<GS>A<GS>Q60<GS>1T12345678901<RS><EOT>
//		FWrite(nHdl,"^BY70,70^FT175,550^BXB,4,200,36,36,1^FH\^FD[)><RS>06<GS>3S"+aEtiq[nLoop,ET_PACKNR]+"<GS>V"+aEtiq[nLoop,ET_FORNECE]+"<GS>P"+aEtiq[nLoop,ET_CODPRO]+"<GS>"+aEtiq[nLoop,ET_REVIS]+"<GS>Q"+aEtiq[nLoop,ET_QTDE]+"<GS>1T"+aEtiq[nLoop,ET_LOTE]+'<RS><EOT>'+"^FS"+CRLF)		
		FWrite(nHdl,"^BY70,70^FT175,550^BXB,4,200,36,36,1^FH\^FD[)>3006293S"+aEtiq[nLoop,ET_PACKNR]+"29V"+aEtiq[nLoop,ET_FORNECE]+"29P"+aEtiq[nLoop,ET_CODPRO]+"29"+aEtiq[nLoop,ET_REVIS]+"29Q"+aEtiq[nLoop,ET_QTDE]+"291T"+aEtiq[nLoop,ET_LOTE]+'304'+"^FS"+CRLF)		
		FWrite(nHdl,"^BY2,3,53^FT584,685^B3B,N,,N,N"+CRLF)
		FWrite(nHdl,"^FD1T" + aEtiq[nLoop,ET_BARLOTE] + "^FS"+CRLF)
		FWrite(nHdl,"^FT85,1480^A0B,56,55^FH\^FD" + aEtiq[nLoop,ET_BARPRO] + "^FS"+CRLF)
		FWrite(nHdl,"^BY2,3,48^FT582,1600^B3B,N,,N,N"+CRLF)
		FWrite(nHdl,"^FD3S"+aEtiq[nLoop,ET_BARPACK]+"Z^FS"+CRLF)
		FWrite(nHdl,"^BY2,3,47^FT445,1600^B3B,N,,N,N"+CRLF)
		FWrite(nHdl,"^FDV" + aEtiq[nLoop,ET_BARFOR] + "^FS"+CRLF)
		FWrite(nHdl,"^BY4,3,50^FT305,1600^B3B,N,,N,N"+CRLF)
		FWrite(nHdl,"^FDQ"+aEtiq[nLoop,ET_BARQTDE]+"^FS"+CRLF)
		FWrite(nHdl,"^BY2,3,53^FT160,1600^B3B,N,,N,N"+CRLF)
		FWrite(nHdl,"^FDP" + aEtiq[nLoop,ET_CODPRO] + "^FS"+CRLF)
		FWrite(nHdl,"^FO459,13^GB0,1657,1^FS"+CRLF)
		FWrite(nHdl,"^FO377,12^GB0,825,1^FS"+CRLF)
		FWrite(nHdl,"^FO316,843^GB0,830,1^FS"+CRLF)
		FWrite(nHdl,"^FO173,8^GB0,1658,1^FS"+CRLF)
		FWrite(nHdl,"^FT194,1150^A0B,14,14^FH\^FD(9B) Unit (U)^FS"+CRLF)
		FWrite(nHdl,"^FT194,1661^A0B,14,14^FH\^FD(9) Quantity (Q)^FS"+CRLF)
		FWrite(nHdl,"^FO233,11^GB0,826,1^FS"+CRLF)
		FWrite(nHdl,"^FT197,829^A0B,14,14^FH\^FD(10) Description^FS"+CRLF)
		FWrite(nHdl,"^FT258,829^A0B,14,14^FH\^FD(11) Supplier Reference^FS"+CRLF)
		FWrite(nHdl,"^FT485,1669^A0B,14,14^FH\^FD(15) Pack No (S)^FS"+CRLF)
		FWrite(nHdl,"^FT339,1669^A0B,14,14^FH\^FD(12) Supplier Code (V)^FS"+CRLF)
		FWrite(nHdl,"^FT401,831^A0B,14,14^FH\^FD(13) Date^FS"+CRLF)
		FWrite(nHdl,"^FT487,831^A0B,14,14^FH\^FD(16) Batch no (H)^FS"+CRLF)
		FWrite(nHdl,"^FT400,482^A0B,14,14^FH\^FD(14) Part revision^FS"+CRLF)
		FWrite(nHdl,"^LRY^FO385,489^GB71,0,2^FS^LRN"+CRLF)
		FWrite(nHdl,"^LRY^FO172,838^GB412,0,1^FS^LRN"+CRLF)
		FWrite(nHdl,"^PQ1,0,1,Y^XZ"+CRLF)
		FWrite(nHdl,"^XA^ID000.GRF^FS^XZ"+CRLF)
		//MSCBEND()
	
	Next nLoop                                    


//	nPackNr := Soma1( nPackNr )
 
	FClose( nHdl )
	
	//WinExec( "CMD /C TYPE " + cTempDir + cFile + " > " + aPorta[mv_par04])   
	WinExec( "CMD /C TYPE " + cTempDir + cFile + " > " + "LPT1")
   
	//MSCBCLOSEPRINTER()
	
Return( nil )	
 