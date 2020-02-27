#include 'protheus.ch'
#include 'parmtype.ch'

#define ET_NF         1
#define ET_SERIE      2
#define ET_SEQUENCIA  3
#define ET_BARRANF    4
#define ET_FORNECE    5
#define ET_LOTE       6
#define ET_QUANT      7
#define ET_UM         8
#define ET_BARRALQU   9
#define ET_CODPRO     10
#define ET_DESPRO     11
                                                     
//==========================================================================================
// MidTST01 - Antonio Carlos Damaceno - Advpl Tec - Fev/2018   |   Revisao/Ajuste: 29/11/18
//------------------------------------------------------------------------------------------
// Descrição
// Impressão de etiquetas de codigo de barra para TS TRIM
//------------------------------------------------------------------------------------------
// Parametros
// nenhum
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
User Function MidTST01()

	Local oPerg
	Local cSql    := ""

	Private cPerg := "MIDTST01"
//	Private oDlg, oGridPrd
	Private aPorta := {"LPT1","LPT2","LPT3"}

	oPerg := AdvplPerg():New( cPerg )

	//-------------------------------------------------------------------
	//    AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
	// Parametriza as perguntas
	//-------------------------------------------------------------------
	oPerg:AddPerg( "Nota Fiscal"      ,"C",9 , ,             , "")                 //1
	oPerg:AddPerg( "Serie"            ,"C",3 , ,             , "")                 //2
	oPerg:AddPerg( "Plano"            ,"C",20, ,             , "SZP")              //3
	oPerg:AddPerg( "Sequencia"        ,"C",3 , ,             , "")                 //4
//	oPerg:AddPerg( "Modelo:(A)(B)(C)" ,   ,  , ,{"A","B","C"},   )                 //
	oPerg:AddPerg( "Qtde de Caixas"   ,"N",3 , ,             ,   )                 //5
	oPerg:AddPerg( "Porta Impressão"  ,   ,  , ,aPorta           )                 //6
	oPerg:SetPerg()

	If ! Pergunte( cPerg, .t. )
		Return( nil )
	EndIf

	Processa( {|| MontaEtiq()}, "Aguarde..." ) 

return( nil )
                                                                 

//==========================================================================================
// MontaEtiq - Antonio - Advpl Tecnologia - Fev / 2018    |     Revisao/Ajuste: 29/11/18
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
	Local aEtiq         := {}
	Local cAliasTST     := GetNextAlias()
	Local cET_NF        := ""
	Local cET_SERIE     := ""
	Local cET_SEQUENCIA := ""
	Local cET_BARRANF   := ""
	Local cET_FORNECE   := ""
	Local cET_LOTE      := ""
	Local cET_QUANT     := 0
	Local cET_UM        := ""
	Local cET_CODPRO    := ""
	Local cET_DESPRO    := ""
	Local cET_BARRALQU  := ""
	Local nQTDETQ       := 0
	
	ProcRegua( 0 )

	cSql := " SELECT SF2.F2_FILIAL, SF2.F2_DOC, SF2.F2_SERIE, SD2.D2_COD, SD2.D2_ITEM, SD2.D2_QUANT, SB1.B1_DESC, SB1.B1_ATLREF, SB1.B1_UM, SF2.F2_CHVNFE,"
	cSql += " (SELECT SZP.ZP_NUM    FROM SZP010 SZP WHERE SZP.ZP_OPMIDO = '"+MV_PAR03+"' AND SZP.ZP_FILIAL = '" + xFilial("SZP") + "' AND SZP.D_E_L_E_T_ = ' ') AS ZP_NUM, "
	cSql += " (SELECT SZP.ZP_QUANT  FROM SZP010 SZP WHERE SZP.ZP_OPMIDO = '"+MV_PAR03+"' AND SZP.ZP_FILIAL = '" + xFilial("SZP") + "' AND SZP.D_E_L_E_T_ = ' ') AS ZP_QUANT, "
	cSql += " (SELECT SZP.ZP_OPMIDO FROM SZP010 SZP WHERE SZP.ZP_OPMIDO = '"+MV_PAR03+"' AND SZP.ZP_FILIAL = '" + xFilial("SZP") + "' AND SZP.D_E_L_E_T_ = ' ') AS ZP_OPMIDO "
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

//	If MV_PAR05 == "A"

	(cAliasTST)->(dbGoTop())

	If (cAliasTST)->(!Eof())
		If Empty((cAliasTST)->F2_CHVNFE)
			MsgStop("Nota Fiscal não foi faturada e ou transmitida !!! Verifique com o Depto responsável !!!")
			(cAliasTST)->(dbCloseArea())
			Return()
		EndIf
	EndIf
	        zzlin:=0
	While (cAliasTST)->(!Eof())
          zzlin:=zzlin+1
		cET_NF         := (cAliasTST)->F2_DOC
		cET_SERIE      := (cAliasTST)->F2_SERIE
		cET_SEQUENCIA  := MV_PAR04
		cET_BARRANF    := AllTrim((cAliasTST)->F2_DOC)+AllTrim((cAliasTST)->F2_SERIE)+AllTrim(MV_PAR04)
		cET_FORNECE    := 'MIDORI AUTO LEATHER BRASIL LT'
		cET_LOTE       := 'MLBR'+AllTrim((cAliasTST)->ZP_NUM)
//		cET_QUANT      := (cAliasTST)->ZP_QUANT) 
		cET_QUANT      := (((cAliasTST)->D2_QUANT / (cAliasTST)->ZP_QUANT) / MV_PAR05) * (cAliasTST)->ZP_QUANT  
		cET_UM         := (cAliasTST)->B1_UM
		cET_BARRALQU   := cET_LOTE+Transform((cAliasTST)->ZP_QUANT,"@E9999999")+(cAliasTST)->B1_UM
		cET_CODPRO     := (cAliasTST)->B1_ATLREF
		cET_DESPRO     := (cAliasTST)->B1_DESC

		AAdd( aEtiq, {	cET_NF          ,;         //1  NF
						cET_SERIE       ,;         //2  SERIE
						cET_SEQUENCIA   ,;         //3  SEQ
						cET_BARRANF     ,;         //4  COD BARRAS NF
						cET_FORNECE     ,;         //5  DESCRICAO FORNECE
						cET_LOTE        ,;         //6  LOTE
						cET_QUANT       ,;         //7  QUANTIDADE
						cET_UM          ,;         //8  UNID MED
						cET_BARRALQU    ,;         //9  COD BARRAS LOTE+QUANT+UM
						cET_CODPRO      ,;         //10 COD produto    (B1_ATLREF)
						cET_DESPRO     } )         //11 DESCR PRODUTO
			
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

	//MSCBPRINTER( "ZEBRA", aPorta[mv_par06],,,.f.,,,,)//,/* [ nDensidade ]*/, /*[ nTamanho ]*/, .F., /*"1290"*/, /*"172.17.0.161"*/, /*[ cEnv ]*/, /*[ nMemoria ]*/, /*cSpool*/, /*[ lDrvWin ]*/, /*[ cPathSpool ]*/ )
	//MSCBCHKSTATUS(.f.)

	nHdl := FCreate( cTempDir+cFile ) 
	alert(cTempDir+cFile)
	If nHdl < 0
		apMsgAlert("Erro na geração do arquivo temporário. Erro : " + AllTrim(Str(FError())) )
	EndIf
	
	For nLoop := 1 to Len( aEtiq )
		IncProc()
		//MSCBBEGIN(1,4)

		// Parametrizacao da etiqueta

/*		FWrite(nHdl,"CT~~CD,~CC^~CT~"+CRLF)
		FWrite(nHdl,"^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ"+CRLF)
		FWrite(nHdl,"^XA"+CRLF)
		FWrite(nHdl,"^MMT"+CRLF)
		FWrite(nHdl,"^PW799"+CRLF)
		FWrite(nHdl,"^LL0799"+CRLF)
		FWrite(nHdl,"^LS0"+CRLF)
		FWrite(nHdl,"^BY3,3,52^FT222,540^BCB,,N,N"+CRLF)
		FWrite(nHdl,"^FD>:N>"+aEtiq[nLoop,ET_BARRANF]+"^FS"+CRLF)
		FWrite(nHdl,"^FO624,26^GB0,758,5^FS"+CRLF)
		FWrite(nHdl,"^FO456,24^GB0,756,6^FS"+CRLF)
		FWrite(nHdl,"^FO235,26^GB0,752,6^FS"+CRLF)
        FWrite(nHdl,"^FT152,743^A0B,34,33^FH\^FDTS TRIM^FS"+CRLF)
		FWrite(nHdl,"^FT90,474^A0B,23,24^FH\^FDNota Fiscal^FS"+CRLF)
		FWrite(nHdl,"^FT525,773^A0B,28,28^FH\^FDCodigo do Produto (TS TECH)^FS"+CRLF) 
		FWrite(nHdl,"^FT338,76^A0B,28,28^FH\^FD"  + Trim(aEtiq[nLoop,ET_UM])       + "^FS"+CRLF)
		FWrite(nHdl,"^FT336,238^A0B,28,28^FH\^FD" + Transform(aEtiq[nLoop,ET_QUANT],"@E 99999999") + "^FS"+CRLF)
		FWrite(nHdl,"^FT143,118^A0B,28,28^FH\^FD" + Trim(aEtiq[nLoop,ET_SEQUENCIA])+ "^FS"+CRLF)
		FWrite(nHdl,"^FT142,268^A0B,28,28^FH\^FD" + Trim(aEtiq[nLoop,ET_SERIE])    + "^FS"+CRLF)
		FWrite(nHdl,"^FT140,473^A0B,28,28^FH\^FD" + Trim(aEtiq[nLoop,ET_NF])       + "^FS"+CRLF)
		FWrite(nHdl,"^FT422,511^A0B,28,28^FH\^FD" + Trim(aEtiq[nLoop,ET_LOTE])     + "^FS"+CRLF)
		FWrite(nHdl,"^FT338,768^A0B,28,28^FH\^FD" + Trim(aEtiq[nLoop,ET_FORNECE])  + "^FS"+CRLF)
		FWrite(nHdl,"^FT593,723^A0B,39,38^FH\^FD" + Trim(aEtiq[nLoop,ET_CODPRO])   + "^FS"+CRLF)
		FWrite(nHdl,"^FT695,771^A0B,28,28^FH\^FDDescricao do Produto^FS"+CRLF)
		FWrite(nHdl,"^FT293,254^A0B,28,28^FH\^FDQuantidade^FS"+CRLF)
		FWrite(nHdl,"^FT756,772^A0B,31,31^FH\^FD" + SubStr(aEtiq[nLoop,ET_DESPRO],1,42)   + "^FS"+CRLF)
		FWrite(nHdl,"^FT94,285^A0B,28,28^FH\^FDSerie^FS"+CRLF)
		FWrite(nHdl,"^FT94,157^A0B,28,28^FH\^FDSequencia^FS"+CRLF)
		FWrite(nHdl,"^FT287,769^A0B,28,28^FH\^FDFornecedor^FS"+CRLF)
		FWrite(nHdl,"^FT421,770^A0B,28,28^FH\^FDLote de Fabricacao:^FS"+CRLF)
		FWrite(nHdl,"^FT293,81^A0B,28,28^FH\^FDUM^FS"+CRLF)
//		FWrite(nHdl,"^LRY^FO63,535^GB160,0,8^FS^LRN"+CRLF)
        FWrite(nHdl,"^LRY^FO64,558^GB160,0,7^FS^LRN"+CRLF)
		// Finaliza a etiqueta
		FWrite(nHdl,"^PQ1,0,1,Y^XZ"+CRLF)
*/

		FWrite(nHdl,"CT~~CD,~CC^~CT~"+CRLF)
		FWrite(nHdl,"^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ"+CRLF)
		FWrite(nHdl,"^XA"+CRLF)
		FWrite(nHdl,"^MMT"+CRLF)
		FWrite(nHdl,"^PW799"+CRLF)
		FWrite(nHdl,"^LL0799"+CRLF)
		FWrite(nHdl,"^LS0"+CRLF)
		FWrite(nHdl,"^FT40,148^A0N,34,33^FH\^FDTS TRIM^FS"+CRLF)
		FWrite(nHdl,"^FT53,778^A0N,34,33^FH\^FD"  + SubStr(aEtiq[nLoop,ET_DESPRO],16,55) + "^FS"+CRLF)
		FWrite(nHdl,"^FT52,726^A0N,34,33^FH\^FD"  + SubStr(aEtiq[nLoop,ET_DESPRO],1,15)  + "^FS"+CRLF)
		FWrite(nHdl,"^FT49,521^A0N,28,28^FH\^FD"  + Trim(aEtiq[nLoop,ET_CODPRO])         + "^FS"+CRLF)
		FWrite(nHdl,"^FT633,122^A0N,23,24^FH\^FD" + Trim(aEtiq[nLoop,ET_SEQUENCIA])      + "^FS"+CRLF)
		FWrite(nHdl,"^FT455,124^A0N,23,24^FH\^FD" + Trim(aEtiq[nLoop,ET_SERIE])          + "^FS"+CRLF)
		FWrite(nHdl,"^FT198,123^A0N,23,24^FH\^FD" + Trim(aEtiq[nLoop,ET_NF])             + "^FS"+CRLF)
		FWrite(nHdl,"^FT51,669^A0N,23,24^FH\^FDDescricao do Produto^FS"+CRLF)
		FWrite(nHdl,"^FT41,280^A0N,23,24^FH\^FDMIDORI AUTO LEATHER BRASIL LT^FS"+CRLF)
		FWrite(nHdl,"^FT51,479^A0N,23,24^FH\^FDCodigo do Produto (TS TECH)^FS"+CRLF)
		FWrite(nHdl,"^FT677,281^A0N,23,24^FH\^FDUM^FS"+CRLF)
		FWrite(nHdl,"^FT534,281^A0N,23,24^FH\^FDQuant^FS"+CRLF)
		FWrite(nHdl,"^FT41,317^A0N,23,24^FH\^FDLote de Fabricacao^FS"+CRLF)
		FWrite(nHdl,"^FT679,321^A0N,23,24^FH\^FD" + Trim(aEtiq[nLoop,ET_UM])             + "^FS"+CRLF)
		FWrite(nHdl,"^FT546,322^A0N,23,24^FH\^FD" + Transform(aEtiq[nLoop,ET_QUANT],"@E 9999999") + "^FS"+CRLF)
		FWrite(nHdl,"^FT293,318^A0N,23,24^FH\^FD" + Trim(aEtiq[nLoop,ET_LOTE])           + "^FS"+CRLF)
		FWrite(nHdl,"^FT578,81^A0N,28,28^FH\^FDSequencia^FS"+CRLF)
		FWrite(nHdl,"^FT436,84^A0N,28,28^FH\^FDSerie^FS"+CRLF)
		FWrite(nHdl,"^FT187,83^A0N,28,28^FH\^FDNota Fiscal^FS"+CRLF)
		FWrite(nHdl,"^FO10,631^GB764,0,2^FS"+CRLF)
		FWrite(nHdl,"^FO3,39^GB775,0,1^FS"+CRLF)
		FWrite(nHdl,"^FO14,434^GB757,0,1^FS"+CRLF)
		FWrite(nHdl,"^FO9,237^GB762,0,1^FS"+CRLF)
		FWrite(nHdl,"^BY3,3,62^FT49,609^BCN,,N,N"+CRLF)
		FWrite(nHdl,"^FD>;" + Trim(aEtiq[nLoop,ET_CODPRO])   + "^FS"+CRLF)
		FWrite(nHdl,"^BY3,3,62^FT41,413^BCN,,N,N"+CRLF)
//		FWrite(nHdl,"^FD>:MLBR>504709512>60PC^FS"+CRLF)
		FWrite(nHdl,"^FD>:" + Trim(aEtiq[nLoop,ET_BARRALQU])     + "^FS"+CRLF)
		FWrite(nHdl,"^BY3,3,62^FT187,221^BCN,,N,N"+CRLF)
		FWrite(nHdl,"^FD>:N>"+aEtiq[nLoop,ET_BARRANF]        +"^FS"+CRLF)
		FWrite(nHdl,"^LRY^FO173,36^GB0,199,4^FS^LRN"+CRLF)
		FWrite(nHdl,"^LRY^FO774,36^GB0,751,3^FS^LRN"+CRLF)
		FWrite(nHdl,"^PQ1,0,1,Y^XZ"+CRLF)
 
		//MSCBEND()
	Next nLoop                                    
	FClose( nHdl )
	
	WinExec( "CMD /C TYPE " + cTempDir + cFile + " > " + aPorta[mv_par06])
	//MSCBCLOSEPRINTER()
	
Return( nil )	
 
/*
 SELECT SF2.F2_FILIAL, SF2.F2_DOC, SF2.F2_SERIE, SD2.D2_COD, SD2.D2_ITEM, SB1.B1_DESC, SB1.B1_ATLREF, SB1.B1_UM, 
 (SELECT SZP.ZP_NUM    FROM SZP010 SZP WHERE SZP.ZP_OPMIDO = '037309') AS ZP_NUM, 
 (SELECT SZP.ZP_QUANT  FROM SZP010 SZP WHERE SZP.ZP_OPMIDO = '037309') AS ZP_QUANT, 
 (SELECT SZP.ZP_OPMIDO FROM SZP010 SZP WHERE SZP.ZP_OPMIDO = '037309') AS ZP_OPMIDO  FROM SF2010 SF2  
 JOIN SD2010 SD2 ON SF2.F2_DOC     = SD2.D2_DOC               AND                                        SF2.F2_SERIE   = SD2.D2_SERIE 
 AND                                        SF2.F2_CLIENTE = SD2.D2_CLIENTE           AND 
 SF2.F2_LOJA    = SD2.D2_LOJA              AND   
 SD2.D2_FILIAL  = '09' AND                                        SD2.D_E_L_E_T_ = ' '  
 JOIN SB1010 SB1 ON SD2.D2_COD     = SB1.B1_COD               AND                                        SB1.B1_FILIAL  = '  ' AND    
 SD2.D_E_L_E_T_ = ' ' 
 WHERE SF2.F2_DOC     = '000049976'       AND        SF2.F2_SERIE   = '1  '     
 AND        SF2.F2_FILIAL  = '09' AND        SF2.D_E_L_E_T_ = ' '  ORDER BY SD2.D2_DOC,SD2.D2_ITEM 
 */
 