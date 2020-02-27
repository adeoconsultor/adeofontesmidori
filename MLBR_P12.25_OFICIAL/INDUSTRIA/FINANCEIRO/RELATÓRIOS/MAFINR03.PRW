#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMAFINR03  บAutor  ณBruno M. Mota       บ Data ณ  15/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio responsavel por trazer as contas a receber de     บฑฑ
ฑฑบ          ณacordo com as vendas das filiais e das exporta็๕es.         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP 8.11/R4 ou 10.1 - Especifico Midori                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MAFINR03()
//Variaveis locais da funcao
//variaveis privadas da funcao
Private cPerg := PADR("MAFINR03",10)
//Inicio da funcao
//Verifica se existe os parametros
IF !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	ValidPerg(cPerg)
EndIf
//Executa a pergunta do relat๓rio
Pergunte(cPerg,.f.)
//Processa o relatorio usando a classe tReport (Release 4)
//Verifica se esta utilizando release 4
If TRepInUse()
	//Gera as definicoes do relatorio
	oReport := ReportDef()
	//Monta interface com o usuแrio
	oReport:PrintDialog()
EndIf
//Retorno da funcao
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณBruno M. Mota       บ Data ณ  15/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDefini็ใo do relat๓rio                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()
//Variaveis locais da funcao
Local oReport 	:= ""
Local oBreak	:= ""
Local oSection1	:= ""
//Inicio da funcao
//Monta o objeto do relatorio
oReport := TReport():New("MAFINR03","Posi็ใo Contas a Receber X Filial",cPerg,{|oReport| Printreport(oReport)},;
				"Este relatorio imprimirแ a posi็ใo do contas a receber por filial.")
//Cria a Se็ใo do relatorio
oSection1 := TRSection():New(oReport,"Posi็ใo Contas a Receber X Filial",{"SE1","SA1"},/*Ordem*/)
//Cria as celulas do relat๓rio 
TRCell():New(oSection1,"E1_VENCREA"	,"TMP","Vencimento"			,"@E 999,999,999.99",13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"VAL_EX"		,"TMP","Exporta็๕es"		,"@E 999,999,999.99",13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"VAL_GRU"	,"TMP","Vendas Guarulhos" 	,"@E 999,999,999.99",13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"VAL_ALEGR"	,"TMP","Vendas Alt. Alegre"	,"@E 999,999,999.99",13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"VAL_PNP2"	,"TMP","Vendas Penแpolis 2"	,"@E 999,999,999.99",13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"VAL_PNP1"	,"TMP","Vendas Penแpolis 1" ,"@E 999,999,999.99",13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"VAL_UBA"	,"TMP","Vendas Uberaba"		,"@E 999,999,999.99",13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"VAL_CBI"	,"TMP","Vendas Cambuํ"		,"@E 999,999,999.99",13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"VAL_CLE"	,"TMP","Vendas Clementina"	,"@E 999,999,999.99",13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"VAL_BAR"	,"TMP","Vendas Barra Funda"		,"@E 999,999,999.99",13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"TOT_DIA"	,"TMP","Total do Dia"		,"@E 999,999,999.99",13,/*TAMPIXEL*/,/*BLOCO*/)
//Cria as quebras totalizadoras
oBreak := TRBreak():New(oSection1,"","Total Geral: ")
//Cria funcao totalizadora do consumo de MP
TRFunction():New(oSection1:Cell("VAL_EX"),NIL,"SUM",oBreak)
//Cria funcao totalizadora do consumo de PA
TRFunction():New(oSection1:Cell("VAL_GRU"),NIL,"SUM",oBreak)
//Cria funcao totalizadora do consumo de PA
TRFunction():New(oSection1:Cell("VAL_ALEGR"),NIL,"SUM",oBreak)
//Cria funcao totalizadora do consumo de PA
TRFunction():New(oSection1:Cell("VAL_PNP2"),NIL,"SUM",oBreak)
//Cria funcao totalizadora do consumo de PA
TRFunction():New(oSection1:Cell("VAL_PNP1"),NIL,"SUM",oBreak)
//Cria funcao totalizadora do consumo de PA
TRFunction():New(oSection1:Cell("VAL_UBA"),NIL,"SUM",oBreak)
//Cria funcao totalizadora do consumo de PA
TRFunction():New(oSection1:Cell("VAL_CBI"),NIL,"SUM",oBreak)
//Cria funcao totalizadora do consumo de PA
TRFunction():New(oSection1:Cell("VAL_CLE"),NIL,"SUM",oBreak)
//Cria funcao totalizadora do consumo de PA
TRFunction():New(oSection1:Cell("VAL_BAR"),NIL,"SUM",oBreak)
//Cria funcao totalizadora do consumo de PA
TRFunction():New(oSection1:Cell("TOT_DIA"),NIL,"SUM",oBreak)
//Retorno da funcao

//Retorno da funcao
Return(oReport)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReporบAutor  ณBruno M. Mota       บ Data ณ  15/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImprime o relatorio                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintReport()
//Variaveis locais da funcao
Local cTES := ""
//variaveis privadas da funcao
Private oSection1 := oReport:Section(1)
//Inicio da funcao
//Inicia a query da section 1
oSection1:BeginQuery()
//Inicia a montagem da query
BeginSql Alias "TMP"
%NoParser%
SELECT                                                                                    
	E1_VENCREA,
	ROUND(SUM(VAL_EX),2) VAL_EX,
	ROUND(SUM(VAL_GRU),2) VAL_GRU,
	ROUND(SUM(VAL_ALEGR),2) VAL_ALEGR,
	ROUND(SUM(VAL_PNP2),2) VAL_PNP2,
	ROUND(SUM(VAL_PNP1),2) VAL_PNP1,
	ROUND(SUM(VAL_UBA),2) VAL_UBA,
	ROUND(SUM(VAL_CBI),2) VAL_CBI,
   	ROUND(SUM(VAL_CLE),2) VAL_CLE,
   	ROUND(SUM(VAL_BAR),2) VAL_BAR,
	ROUND(SUM(VAL_EX+VAL_GRU+VAL_ALEGR+VAL_PNP2+VAL_PNP1+VAL_UBA+VAL_CBI+VAL_CLE+VAL_BAR),2) 
	TOT_DIA 
FROM
	(	SELECT
			CASE 
				WHEN E1_PREFIXO IN ('01',
				'04',
				'08',
				'09',
				'10',
				'12',
				'18',
				'16') AND
				E1_FILIAL = ' ' AND
				A1_EST = 'EX' 
				THEN E1_SALDO 
				ELSE 0 
			END VAL_EX,
			CASE 
				WHEN E1_PREFIXO IN ('01',
				'04',
				'08',
				'09',
				'10',
				'12',
				'18',
				'16') AND
				E1_FILIAL = ' ' AND
				A1_EST <> 'EX' 
				THEN 
				CASE 
					WHEN E1_PREFIXO = '01' 
					THEN E1_SALDO 
					ELSE 0 
				END 
				ELSE 0 
			END VAL_GRU,
			CASE 
				WHEN E1_PREFIXO IN ('01',
				'04',
				'08',
				'09',
				'10',
				'12',
				'18',
				'16') AND
				E1_FILIAL = ' ' AND
				A1_EST <> 'EX' 
				THEN 
				CASE 
					WHEN E1_PREFIXO = '04' 
					THEN E1_SALDO 
					ELSE 0 
				END 
				ELSE 0 
			END VAL_ALEGR,
			CASE 
				WHEN E1_PREFIXO IN ('01',
				'04',
				'08',
				'09',
				'10',
				'12',
				'18',
				'16') AND
				E1_FILIAL = ' ' AND
				A1_EST <> 'EX' 
				THEN 
				CASE 
					WHEN E1_PREFIXO = '08' 
					THEN E1_SALDO 
					ELSE 0 
				END 
				ELSE 0 
			END VAL_PNP2,
			CASE 
				WHEN E1_PREFIXO IN ('01',
				'04',
				'08',
				'09',
				'10',
				'12',
				'18',
				'16') AND
				E1_FILIAL = ' ' AND
				A1_EST <> 'EX' 
				THEN 
				CASE 
					WHEN E1_PREFIXO = '09' 
					THEN E1_SALDO 
					ELSE 0 
				END 
				ELSE 0 
			END VAL_PNP1,
			CASE 
				WHEN E1_PREFIXO IN ('01',
				'04',
				'08',
				'09',
				'10',
				'12',
				'18',
				'16') AND
				E1_FILIAL = ' ' AND
				A1_EST <> 'EX' 
				THEN 
				CASE 
					WHEN E1_PREFIXO = '10' 
					THEN E1_SALDO 
					ELSE 0 
				END 
				ELSE 0 
			END VAL_UBA,
			CASE 
				WHEN E1_PREFIXO IN ('01',
				'04',
				'08',
				'09',
				'10',
				'12',
				'18',
				'16') AND
				E1_FILIAL = ' ' AND
				A1_EST <> 'EX' 
				THEN 
				CASE 
					WHEN E1_PREFIXO = '16' 
					THEN E1_SALDO 
					ELSE 0 
				END 
				ELSE 0 
			END VAL_CBI,
			CASE 
				WHEN E1_PREFIXO IN ('01',
				'04',
				'08',
				'09',
				'10',
				'12',
				'18',
				'16') AND
				E1_FILIAL = ' ' AND
				A1_EST <> 'EX' 
				THEN 
				CASE 
					WHEN E1_PREFIXO = '12' 
					THEN E1_SALDO 
					ELSE 0 
				END 
				ELSE 0 
			END VAL_CLE,
			CASE 
				WHEN E1_PREFIXO IN ('01',
				'04',
				'08',
				'09',
				'10',
				'12',
				'18',
				'16') AND
				E1_FILIAL = ' ' AND
				A1_EST <> 'EX' 
				THEN 
				CASE 
					WHEN E1_PREFIXO = '18' 
					THEN E1_SALDO 
					ELSE 0 
				END 
				ELSE 0 
			END VAL_BAR,
			E1_VENCREA 
		FROM
			SE1010 SE1 
			INNER JOIN SA1010 SA1 
			ON E1_CLIENTE = A1_COD AND
			E1_LOJA = A1_LOJA 
		WHERE
			SE1.D_E_L_E_T_ = ' ' AND
			SA1.D_E_L_E_T_ = ' ' AND
			SE1.E1_TIPO IN ('NF',
			'BOL',
			'DP') AND
			E1_SALDO <> 0 AND
			E1_FATURA = ' ' AND
			E1_VENCREA BETWEEN %Exp:DtoS(mv_par01)% AND %Exp:DtoS(mv_par02)% 
	)
	CK 
GROUP BY
	E1_VENCREA 
ORDER BY
	E1_VENCREA 
EndSql
//Termina a query da secao
oSection1:EndQuery()
//Imprime relatorio
oSection1:Print()
//Retorno da funcao
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณBruno M. Mota       บ Data ณ  15/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCadastra perguntas do relatorio                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP 8.11/R4 ou 10.1 - Especifico Midori                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg(cPerg)
//Variaveis locais
Local aRegs := {}
Local i,j
//Inicio da funcao
dbSelectArea("SX1")
dbSetOrder(1)
//   1          2        3         4          5           6       7       8             9        10      11     12       13        14        15         16       17       18       19        20          21        22      23        24       25         26        27       28       29       30          31        32       33       34        35          36        37     38     39       40       41        42
//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_PYME/X1_GRPSXG/X1_HELP/X1_PICTURE
AADD(aRegs,{cPerg,"01","De Data Vencimento"  	,"","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Data Vencimento" 	,"","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Loop de armazenamento
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif     
Next
//Retorno da funcao
Return()          