#Include "Protheus.ch"
#Include "RwMake.ch"  
#Include "Topconn.ch"              
/*---------------------------------------------------------
Funcao : A906CFAP     |Autor: AOliveira   |Data: 13-09-2018
-----------------------------------------------------------
Descr. : Rotina tem como objetivo realizar tratativa de 
         CFOP no CIAP.                                     
         Parametro ES_NOTCF será criado automaticamente 
         pela rotina.
-----------------------------------------------------------                                                                                 


Uso    : Midori 
---------------------------------------------------------*/
User Function A906CFAP()

Local cQuery    := ""

Local dDataDe := PARAMIXB[1]
Local dDataAte := PARAMIXB[2]

Local cAliasSD2 := ""

Local lMVP3CIAP := GetNewPar("MV_P3CIAP", .F.)
Local lCiapDev	:= GetNewPar("MV_CIAPDEV",.F.)

Local cNOTCF    := ""   

Local aStruSD2  := SD2->(dbStruct())

CreatePar() // Cria parametro ES_NOTCF
cNOTCF    := GetNewPar("ES_NOTCF","")


cAliasSD2 := GetNextAlias()


	IF !lCiapDev
		cQuery := "SELECT D2_EMISSAO, D2_TIPO, D2_TES, D2_CF, SUM(D2_TOTAL) D2_TOTAL ,SUM(D2_SEGURO) D2_SEGURO, " +CRLF
		cQuery += " SUM(D2_VALFRE) D2_VALFRE, SUM(D2_DESPESA) D2_DESPESA, SUM(D2_VALIPI) D2_VALIPI, "+CRLF
		cQuery += " SUM(D2_ICMSRET) D2_ICMSRET, SUM(D2_BASEICM)  D2_BASEICM, SUM(D2_VALBRUT) D2_VALBRUT,D2_DESCICM,"+CRLF
		cQuery += "D2_FILIAL, D2_DOC, D2_SERIE, D2_ITEM, D2_CLIENTE, D2_LOJA, D2_COD, FT_VALCONT FROM "+CRLF
		cQuery += RetSqlName("SD2")+" SD2 "+CRLF
		cQuery += "LEFT JOIN SFT010 AS SFT ON (SFT.FT_FILIAL = SD2.D2_FILIAL AND SFT.FT_NFISCAL = SD2.D2_DOC AND SFT.FT_SERIE = SD2.D2_SERIE AND SFT.FT_ITEM = SD2.D2_ITEM AND SFT.FT_CLIEFOR = SD2.D2_CLIENTE AND SFT.FT_LOJA = SD2.D2_LOJA AND SFT.FT_PRODUTO = SD2.D2_COD AND SFT.D_E_L_E_T_ = '')"+CRLF
		cQuery += "LEFT JOIN SF4010 AS SF4 ON F4_CODIGO = D2_TES"+CRLF
	Else
		cQuery := "SELECT D2_EMISSAO, D2_TIPO, D2_TES, D2_CF, "
		cQuery += "(Sum(D2_TOTAL)   - (CASE WHEN SUM(D1_TOTAL)   > 0 THEN SUM(D1_TOTAL)    ELSE 0 END)) D2_TOTAL, "+CRLF
		cQuery += "(Sum(D2_SEGURO)  - (CASE WHEN SUM(D1_SEGURO)  > 0 THEN SUM(D1_SEGURO)   ELSE 0 END)) D2_SEGURO, "+CRLF
		cQuery += "(Sum(D2_VALFRE)  - (CASE WHEN SUM(D1_VALFRE)  > 0 THEN SUM(D1_VALFRE)   ELSE 0 END)) D2_VALFRE, "+CRLF
		cQuery += "(Sum(D2_DESPESA) - (CASE WHEN SUM(D1_DESPESA) > 0 THEN SUM(D1_DESPESA)  ELSE 0 END)) D2_DESPESA, "+CRLF
		cQuery += "(Sum(D2_VALIPI)  - (CASE WHEN SUM(D1_VALIPI)  > 0 THEN SUM(D1_VALIPI)   ELSE 0 END)) D2_VALIPI, "+CRLF
		cQuery += "(Sum(D2_ICMSRET) - (CASE WHEN SUM(D1_ICMSRET) > 0 THEN SUM(D1_ICMSRET)  ELSE 0 END)) D2_ICMSRET, "+CRLF
		cQuery += "(Sum(D2_BASEICM) - (CASE WHEN SUM(D1_BASEICM) > 0 THEN SUM(D1_BASEICM)  ELSE 0 END)) D2_BASEICM , "+CRLF
		cQuery += "(Sum(D2_VALBRUT) - (CASE WHEN SUM(D1_TOTAL)   > 0 THEN SUM(D1_TOTAL - D1_VALDESC + D1_VALFRE + D1_SEGURO + D1_DESPESA) ELSE 0 END)) D2_VALBRUT  "+CRLF
		cQuery += ",(Sum(FT_VALCONT) - (CASE WHEN SUM(D1_TOTAL)   > 0 THEN SUM(D1_TOTAL - D1_VALDESC + D1_VALFRE + D1_SEGURO + D1_DESPESA) ELSE 0 END)) FT_VALCONT  "+CRLF
	
		cQuery += "FROM "+RetSqlName("SD2")+" SD2 "+CRLF
		cQuery += "LEFT JOIN "+RetSqlName("SD1")+" SD1 ON ( SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND SD1.D1_TIPO = 'D' AND SD1.D1_DTDIGIT BETWEEN '"+dTos(dDataDe)+"' AND '"+dTos(dDataAte)+"' "+CRLF
		cQuery += "AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE AND SD1.D1_ITEMORI = SD2.D2_ITEM AND SD1.D1_FORNECE = SD2.D2_CLIENTE AND SD1.D1_LOJA = SD2.D2_LOJA AND SD1.D1_COD = SD2.D2_COD AND SD1.D_E_L_E_T_ = '' ) "+CRLF
		
		cQuery += RetSqlName("SF4")+" SF4 "+CRLF
	Endif

	cQuery += " WHERE D2_FILIAL = '"+ xFilial("SD2") +"' "+CRLF
	cQuery += " AND D2_EMISSAO BETWEEN '"+dTos(dDataDe)+"' AND '"+dTos(dDataAte)+"'"+CRLF
	cQuery += " AND D2_TIPO <> 'I'"+CRLF
	cQuery += " AND (SD2.D2_CF LIKE '5%' OR SD2.D2_CF LIKE '6%' OR SD2.D2_CF LIKE '7%') "+CRLF
	cQuery += " AND SD2.D2_CF NOT IN "+FormatIn(cNOTCF,"/")+CRLF
	cQuery += " AND SD2.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += " AND F4_FILIAL = '"+xFilial("SF4")+"'"+CRLF
	cQuery += " AND F4_CODIGO = D2_TES "+CRLF
	cQuery += " AND F4_LFICM NOT IN ('N','Z')"+CRLF
	If !lMVP3CIAP
		cQuery += " AND F4_PODER3 = 'N'"+CRLF
	EndIf
	cQuery += " AND SF4.D_E_L_E_T_ = '' "+CRLF
	cQuery += " GROUP BY D2_EMISSAO, D2_TIPO, D2_TES, D2_CF, D2_DESCICM, D2_FILIAL, D2_DOC, D2_SERIE, D2_ITEM, D2_CLIENTE, D2_LOJA, D2_COD, FT_VALCONT"+CRLF
	cQuery += " ORDER BY D2_EMISSAO"+CRLF
	//cQuery := ChangeQuery (cQuery)
	DbUseArea (.T., "TOPCONN", TcGenQry (,, cQuery), cAliasSD2, .T., .T.)    
	                  
	aEval(aStruSD2, {|e| If(e[2]!= "C" .And. SD2->(FieldPos(Alltrim(e[1]))) > 0, TCSetField(cAliasSD2, e[1], e[2],e[3],e[4]),Nil)})
	
	//TCQUERY cQuery ALIAS "cAliasSD2" NEW

DbSelectArea(cAliasSD2)
(cAliasSD2)->(DbGoTop ())

Return(cAliasSD2)


/*---------------------------------------------------------
Funcao: CreatePar   |Autor: AOliveira   |Data:13-09-2018
-----------------------------------------------------------
Desc.   Rotina tem como Objetivo criar Parametro ES_NOTCF
---------------------------------------------------------*/
Static Function CreatePar()

Local _aAreaSX6 := GetArea("SX6")

DbSelectArea("SX6")
SX6->(DbSetorder(1))
SX6->(DbgoTop())
SX6->(Dbseek(xFilial()+"ES_NOTCF"))
If !Found()
	Reclock("SX6",.T.)
	SX6->X6_FIL:=xFilial()
	SX6->X6_VAR:= "ES_NOTCF"
	SX6->X6_TIPO:= "C"
	SX6->X6_CONTEUD:= "5605/5924/6924"
	SX6->X6_DESCRIC:= "Define CFOP que não serao listados no "
	SX6->X6_DESC1  := "ponto de entrada A906CFAP "
	SX6->(MsUnlock())
Endif

RestArea(_aAreaSX6)

Return()