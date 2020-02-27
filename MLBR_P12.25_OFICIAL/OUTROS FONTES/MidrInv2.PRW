#include 'protheus.ch'
#include 'parmtype.ch'

#define ET_CODIGO     1
#define ET_SEQUENCIA  2
#define ET_LINHA1     3  
#define ET_LINHA2     4
#define ET_TIPO       5
#define ET_UM         6
#define ET_LOTE       7
#define ET_BARRA0      8
#define ET_BARRA1      9
#define ET_BARRA2      10
#define ET_BARRA3      11
#define ET_BARRA4      12
#define ET_BARRA5      13

//#define ET_BARRA      8

//==========================================================================================
// MidrInv2 - Antonio Caros Damaceno - Advpl Tecnologia - Abril / 2017
//------------------------------------------------------------------------------------------
// Descrição
// Reimpressão de etiquetas de codigo de barra para inventário personalizado.
//------------------------------------------------------------------------------------------
// Parametros
// nenhum
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
user function MidrInv2()

	Local oPerg, cSql := ""
	Private cPerg := "MIDRINV2"
	Private oDlg, oGridPrd
	Private aHead := {}
	Private aPorta := {"LPT1","LPT2","LPT3"}
	oPerg := AdvplPerg():New( cPerg )

	//-------------------------------------------------------------------
	//    AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
	// Parametriza as perguntas
	//-------------------------------------------------------------------
	oPerg:AddPerg( "Etiquetas"           ,"C",30, , , "")
	oPerg:AddPerg( "(A)(B)(C)(P)(T)odas" ,  ,  , ,{"A","B","C","P","T"}, , )
	oPerg:AddPerg( "Porta Impressão"   ,   ,                      , ,aPorta  )
	oPerg:SetPerg()

	If ! Pergunte( cPerg, .t. )
		Return( nil )
	EndIf

 /*	If !Empty(mv_par08)

		aRet:=StrTokArr(mv_par08,",")
        cxLote1:=""
		For nLin := 1 to Len(aRet)
			cxLote := aRet(nLin)
			If nLin > 1
				cxLote1 += ","
			EndIf		
			cxLote1 += "'"+cxLote+"'"
		Next

    EndIf
   */
    

	Processa( {|| MontaEtiq()}, "Aguarde..." ) 

return( nil )
                                                                 

//==========================================================================================
// MontaEtiq - Alessandro Freire - Advpl Tecnologia - Novembro / 2016
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

	Local nLoop, nX, nxEtq
	Local aEtiq := {}
	Local cSequencia := "", cSoma := "00", cBarra0, cBarra1, cBarra2, cBarra3, cBarra4, cBarra5, cLote, cCodPro
	Local cAliasXZT  := "", lRet:=.F.,cSeque1

	ProcRegua( 0 )
		
	cAliasXZT   := GetNextAlias()

	cSql := "SELECT SUBSTRING(ZZT.ZZT_CODETQ,1,LEN('"+Trim(mv_par01)+"')) AS ZZT_CODETQ"
	cSql += "     , SUBSTRING(ZZT.ZZT_SEQUEN,1,8) AS ZZT_SEQUEN"
	cSql += "     , ZZT.ZZT_CODPRO "
	cSql += "     , ZZT.ZZT_LOTE   "
	cSql += "     , SB1.B1_DESC    " 
	cSql += "     , ZZT.ZZT_LOCAL  "
	cSql += "	  , SB1.B1_TIPO    "
	cSql += "	  , SB1.B1_UM      "
	cSql += "     , ZZT.ZZT_SEQGER "
	cSql += "  FROM " + RetSqlName("ZZT") + " ZZT  "
	cSql += "  INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL  = '"+xFilial("SB1")+"' AND "
	cSql += "                                          SB1.B1_COD     = ZZT.ZZT_CODPRO AND "
	cSql += "						                   SB1.D_E_L_E_T_ = ' ' "
	cSql += "  WHERE ZZT.ZZT_FILIAL  = '" + xFilial("ZZT") + "' AND "
	cSql += "        ZZT.D_E_L_E_T_  = ' '                      AND " 
	cSql += "        SUBSTRING(ZZT.ZZT_CODETQ,1,LEN('"+Trim(mv_par01)+"')) IN('"+Trim(mv_par01)+"') "
	cSql += "  GROUP BY "
	cSql += "       SUBSTRING(ZZT.ZZT_CODETQ,1,LEN('"+Trim(mv_par01)+"')) "
	cSql += "     , SUBSTRING(ZZT.ZZT_SEQUEN,1,8) "
	cSql += "     , ZZT.ZZT_CODPRO "
	cSql += "     , ZZT.ZZT_LOTE   "
	cSql += "     , SB1.B1_DESC    " 
	cSql += "     , ZZT.ZZT_LOCAL  "
	cSql += "	  , SB1.B1_TIPO    "
	cSql += "	  , SB1.B1_UM      "
	cSql += "     , ZZT.ZZT_SEQGER "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasXZT,.T.,.T.) 

	If MV_PAR02 == 5        //'T'

		If (cAliasXZT)->(!Eof())

			For nxEtq := 1 to 4
				cBarra0 := AllTrim((cAliasXZT)->ZZT_LOCAL )
				cBarra1 := AllTrim((cAliasXZT)->ZZT_CODPRO )
				cLote:=AllTrim((cAliasXZT)->ZZT_LOTE )
				cBarra2 := If( Empty(cLote), '' , AllTrim((cAliasXZT)->ZZT_LOTE) )
				cBarra3 := AllTrim( (cAliasXZT)->ZZT_SEQUEN )
				cSequencia:=cBarra3
				cBarra4 := IIf(nxEtq==1,'A', IIf(nxEtq==2,'B',IIf(nxEtq==3,'C','P') ) )
				cDesc:=AllTrim((cAliasXZT)->B1_DESC )
				cTipo:=AllTrim((cAliasXZT)->B1_TIPO )
				cUM:=AllTrim((cAliasXZT)->B1_UM )
				cBarra5 := AllTrim( (cAliasXZT)->ZZT_SEQGER )
				
				AAdd( aEtiq, {	cBarra1,;              //PRODUTO
								cSequencia,;           //SEQUENCIA
								SubStr(cDesc,1,26),;   //DESCRICAO1
								SubStr(cDesc,27),;     //DESCRICAO2
								cTipo,;
								cUM,;
								cLote,;
								cBarra0,;                        //8    ARMAZEM
								cBarra1,;                        //9    produto
								cBarra2,;                        //10    lote
								cBarra3,;                        //11   sequencia
								cBarra4,;                        //12   a,b,c,p
								cBarra5 } )                      //13   000001
				
				
			Next nX
	
		End                   
		
	Else          //A B C ou P

		If (cAliasXZT)->(!Eof())

			cBarra0 := AllTrim((cAliasXZT)->ZZT_LOCAL )
			cBarra1 := AllTrim((cAliasXZT)->ZZT_CODPRO )
			cLote:=AllTrim((cAliasXZT)->ZZT_LOTE )
			cBarra2 := If( Empty((cAliasXZT)->ZZT_LOTE), '' , AllTrim((cAliasXZT)->ZZT_LOTE) )
			cBarra3 := AllTrim( (cAliasXZT)->ZZT_SEQUEN )
			cSequencia:=cBarra3
			cBarra4 := IIf(MV_PAR02==1,'A', IIf(MV_PAR02==2,'B',IIf(MV_PAR02==3,'C','P') ) )
			cDesc:=AllTrim((cAliasXZT)->B1_DESC )
			cTipo:=AllTrim((cAliasXZT)->B1_TIPO )
			cUM:=AllTrim((cAliasXZT)->B1_UM )
			cBarra5 := AllTrim( (cAliasXZT)->ZZT_SEQGER )

			AAdd( aEtiq, {	cBarra1,;              //PRODUTO
							cSequencia,;           //SEQUENCIA
							SubStr(cDesc,1,26),;   //DESCRICAO1
							SubStr(cDesc,27),;     //DESCRICAO2
							cTipo,;
							cUM,;
							cLote,;
							cBarra0,;                        //8    ARMAZEM
							cBarra1,;                        //9    produto
							cBarra2,;                        //10   lote
							cBarra3,;                        //11   sequencia
							cBarra4,;                        //12   a,b,c,p
							cBarra5 } )                      //13   000001
				
		EndIf
	EndIf

	If ! Empty( aEtiq )
		ImpEt( aEtiq )
	EndIf

Return( nil )

//==========================================================================================
// ImpEt - Alessandro Freire - Advpl Tecnologia - Novembro / 2016
//------------------------------------------------------------------------------------------
// Descrição
// Impressão de etiquetas de codigo de barra para inventário personalizado.
//------------------------------------------------------------------------------------------
// Parametros
// aEtiq - Array de etiquetas
// { { Produto, Sequencial, Descr Linha 1, Descr Linha 2, tipo, UM, Lote, Código de Barras } }
// Código de barras formado por
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
Static Function ImpEt( aEtiq )

	Local cTempDir := GetTempPath()
	Local cFile    := "ETIQ"+StrTran( Time(), ":", "" ) + ".PRN" 
	Local nHdl     := -1
	Local nLoop    := 0
	Local dMMMAAAA:=SubStr(CMonth(dDataBase),1,3)+" "+Alltrim(Str(Year(dDataBase)))

	//MSCBPRINTER( "ZEBRA", aPorta[mv_par03],,,.f.,,,,)//,/* [ nDensidade ]*/, /*[ nTamanho ]*/, .F., /*"1290"*/, /*"172.17.0.161"*/, /*[ cEnv ]*/, /*[ nMemoria ]*/, /*cSpool*/, /*[ lDrvWin ]*/, /*[ cPathSpool ]*/ )
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
		FWrite(nHdl,"CT~~CD,~CC^~CT~"+CRLF)
		FWrite(nHdl,"^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ"+CRLF)
		FWrite(nHdl,"^XA"+CRLF)
		FWrite(nHdl,"^MMT"+CRLF)
		FWrite(nHdl,"^PW799"+CRLF)
		FWrite(nHdl,"^LL0480"+CRLF)
		FWrite(nHdl,"^LS0"+CRLF)

		// 1a linha
		FWrite(nHdl,"^FT41,36^A0N,28,28^FH\^FDCodigo: "+Trim(aEtiq[nLoop,ET_CODIGO])+"^FS"+CRLF) // Código do produto

		// 2a Linha
		FWrite(nHdl,"^FT40,71^A0N,28,43^FH\^FD"+Trim(aEtiq[nLoop,ET_LINHA1])+"^FS"+CRLF) // 1a linha da descricao do produto

		// 3a Linha
		FWrite(nHdl,"^FT41,106^A0N,28,43^FH\^FD"+Trim(aEtiq[nLoop,ET_LINHA2])+"^FS"+CRLF) // 2a linha da descricao do produto

		// 4a Linha
		FWrite(nHdl,"^FT42,142^A0N,28,28^FH\^FDTipo: "  +Trim(aEtiq[nLoop,ET_TIPO])   + "^FS"+CRLF) // Tipo do produto
		FWrite(nHdl,"^FT252,34^A0N,28,28^FH\^FDArm: "   +Trim(aEtiq[nLoop,ET_BARRA0]) + "^FS"+CRLF) // ARMAZEM
		FWrite(nHdl,"^FT331,143^A0N,28,28^FH\^FD"       +Trim(aEtiq[nLoop,ET_BARRA4]) + "^FS"+CRLF) // ABC - Contagens do estoque
		FWrite(nHdl,"^FT166,143^A0N,28,28^FH\^FDUM: "   +Trim(aEtiq[nLoop,ET_UM])     + "^FS"+CRLF) // Unidade de medida do produto
		FWrite(nHdl,"^FT416,144^A0N,28,28^FH\^FDLOTE: " +Trim(aEtiq[nLoop,ET_LOTE])   + "^FS"+CRLF) // Lote do produto

		// 5a Linha
		FWrite(nHdl,"^BY2,3,94^FT42,267^BCN,,Y,N"+CRLF) // Parametriza o código de barras? 
		
//		cBarra:=">6"+aEtiq[nLoop,ET_BARRA0]+">5"+aEtiq[nLoop,ET_BARRA1]+">6"+aEtiq[nLoop,ET_BARRA2]+">5"+aEtiq[nLoop,ET_BARRA3]+">6"+aEtiq[nLoop,ET_BARRA4]
//^FD>:01MOD998P>518122101>6A^FS
//		cBarra:=aEtiq[nLoop,ET_BARRA0]+aEtiq[nLoop,ET_BARRA1]+aEtiq[nLoop,ET_BARRA2]+aEtiq[nLoop,ET_BARRA3]+aEtiq[nLoop,ET_BARRA4]
//^BY2,3,94^FT42,267^BCN,,Y,N
//^FD >: 01 MOD998P APAPU >5 06317 1812210  >6 1A^FS   
//       01 MOD998P APAPU06317     18122101     A

		cBarra:=aEtiq[nLoop,ET_BARRA0]+aEtiq[nLoop,ET_BARRA1]+aEtiq[nLoop,ET_BARRA2]+">5"+aEtiq[nLoop,ET_BARRA3]+">6"+aEtiq[nLoop,ET_BARRA4]

		FWrite(nHdl,"^FD"+cBarra+"^FS"+CRLF) // String do Código de barras

		FWrite(nHdl,"^FT372,33^A0N,28,36^FH\^FDSeq: "+aEtiq[nLoop,ET_SEQUENCIA]+"^FS"+CRLF) // Sequencia


		If Trim(aEtiq[nLoop,ET_BARRA4]) <> 'P'           //so imprime estes dados se for <> 'P'
			FWrite(nHdl,"^FO43,304^GB212,96,8^FS"+CRLF)                                       //Retangulo da qtde
			FWrite(nHdl,"^FT121,431^A0N,28,28^FH\^FDQtde^FS"+CRLF)                            //Quantidade
			FWrite(nHdl,"^FO349,392^GB352,0,3^FS"+CRLF)                                       //Linha da assinatura
			FWrite(nHdl,"^FT494,426^A0N,28,28^FH\^FDNome^FS"+CRLF)                            //Nome
		EndIf
		
		FWrite(nHdl,"^FT330,445^A0N,28,28^FH\^FD "+dMMMAAAA+"^FS"+CRLF)           //Dez 2017

		FWrite(nHdl,"^FT693,38^A0N,28,28^FH\^FD"+Trim(aEtiq[nLoop,ET_BARRA5])+"^FS"+CRLF)    //Sequencial (novo)

		// Finaliza a etiqueta
		FWrite(nHdl,"^PQ1,0,1,Y^XZ"+CRLF)
 
		//MSCBEND()
	Next nLoop                                    
	FClose( nHdl )
	
	WinExec( "CMD /C TYPE " + cTempDir + cFile + " > " + aPorta[mv_par03])
	//MSCBCLOSEPRINTER()
	
Return( nil )	
             

//Pesquisa do Lote para retirar o '-'
Static Function UPESQ(cLote,cPesq)
	
    Local aRet  := {}
    Local cRet  := ''
	Default cPesq := "-"
	
	aRet:=StrTokArr(cLote,cPesq)

	If Len(aRet) > 0
		cRet := aRet[1]
		IF Len(aRet) > 1
			cRet += aRet[2]
		EndIf
	Else
		cRet := cLote
	EndIf
	
Return(cRet)                                                    
                                                  
