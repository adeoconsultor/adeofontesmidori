#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMACTBR01  บAutor  ณBruno M. Mota       บ Data ณ  03/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio responsavel imprimir o razใo contabil de acordo   บฑฑ
ฑฑบ          ณcom a solicita็ใo feita pela usuแria Elizabeth Takahashi    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP 8.11/R4 ou 10.1 - Especifico Midori                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MACTBR01()
//Variaveis locais da funcao
//variaveis privadas da funcao
Private cPerg := PADR("MACTBR01",10)
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
ฑฑบPrograma  ณReportDef บAutor  ณBruno M. Mota       บ Data ณ  03/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDefini็ใo do relat๓rio                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
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
//nCt:=0
oReport := TReport():New(cPerg,"Razใo Contแbil",cPerg,{|oReport| Printreport(oReport)},;
				"Este relatorio imprimira o razใo contแbil.")
//Cria a Se็ใo do relatorio
oSection1 := TRSection():New(oReport,"Razใo Contแbil",{"CT2","CT1"}, /*Ordem*/)
//Cria as celulas do relat๓rio
//nCt++
//alert("EXECUTANDO -> "+cValToChar(nCt))
TRCell():New(oSection1,"FILIAL"		,"TMP","Filial"			,"@!"				,02,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"CONTA"		,"TMP","Conta Contabil"	,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"DESC01"		,"TMP","Descri็ใo"		,"@!"				,40,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"DDATA"		,"TMP","Data Lanc."  	,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"LOTE"		,"TMP","Lote"		  	,"@!"				,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"SUBLOTE"	,"TMP","Sub. Lote"		,"@!"               ,03,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"DOC"		,"TMP","Documento"  	,"@!"				,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"LINHA"		,"TMP","Linha"			,"@!"               ,03,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"XPARTIDA"	,"TMP","Contra Partida"	,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"CUSTO"		,"TMP","Custo"		   	,"@!"				,09,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"ITEM"		,"TMP","Item"			,"@!"               ,09,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"UNID_ORIG"	,"TMP","Unidade Origem"	,"@!"               ,09,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"HIST"		,"TMP","Historico"  	,"@!"				,40,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"DEBITO"		,"TMP","Debito"			,"@E 999,999,999.99",12,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"CREDITO"	,"TMP","Credito"	   	,"@E 999,999,999.99",12,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"TIPOLAN"	,"TMP","D/C"		  	,"@!"				,01,/*TAMPIXEL*/,/*BLOCO*/)
//Retorno da funcao
Return(oReport)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReporบAutor  ณBruno M. Mota       บ Data ณ  03/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImprime o relatorio                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintReport()
//Variaveis locais da funcao
//variaveis privadas da funcao
Private oSection1 := oReport:Section(1)
//Inicio da funcao
//Desabilita o cabe็alho de quebra de pagina
oSection1:SetHeaderBreak(.F.)
oSection1:SetPageBreak(.F.)
//Inicia a query da section 1
oSection1:BeginQuery()
//Inicia a montagem da query
BeginSql Alias "TMP"
%NoParser%
SELECT
    FILIAL,
	CONTA,
	DESC01,
	SUBSTRING(DDATA,7,2)+'/'+SUBSTRING(DDATA,5,2)+'/'+SUBSTRING(DDATA,1,4) DDATA,
	LOTE,
	SUBLOTE,
	DOC,
	LINHA,
	XPARTIDA,
	CUSTO,
	ITEM UNID_ORIG,
	HIST,
	DEBITO,
	CREDITO,
	CASE 
		WHEN TIPOLAN = '1' 
		THEN 'D' 
		ELSE 'C' 
	END TIPOLAN 
FROM
	(	SELECT
			CT1_CONTA CONTA,
			CT1_DESC01 DESC01,
			
     		// Por Sandro chamado:001221
			CASE 
				WHEN CT2_FILIAL IS NULL 
				THEN ' ' 
				ELSE CT2_FILIAL 
			END FILIAL,
			// At้ aqui.   
			
			CASE 
				WHEN CT2_CCD IS NULL 
				THEN ' ' 
				ELSE CT2_CCD 
			END CUSTO,
			CASE 
				WHEN CT2_ITEMD IS NULL 
				THEN ' ' 
				ELSE CT2_ITEMD 
			END ITEM,
			CASE 
				WHEN CT2_CLVLDB IS NULL 
				THEN ' ' 
				ELSE CT2_CLVLDB 
			END CLVL,
			CASE 
				WHEN CT2_DATA IS NULL 
				THEN ' ' 
				ELSE CT2_DATA 
			END DDATA,
			CASE 
				WHEN CT2_TPSALD IS NULL 
				THEN ' ' 
				ELSE CT2_TPSALD 
			END TPSALD,
			CASE 
				WHEN CT2_DC IS NULL 
				THEN ' ' 
				ELSE CT2_DC 
			END DC,
			CASE 
				WHEN CT2_LOTE IS NULL 
				THEN ' ' 
				ELSE CT2_LOTE 
			END LOTE,
			CASE 
				WHEN CT2_SBLOTE IS NULL 
				THEN ' ' 
				ELSE CT2_SBLOTE 
			END SUBLOTE,
			CASE 
				WHEN CT2_DOC IS NULL 
				THEN ' ' 
				ELSE CT2_DOC 
			END DOC,
			CASE 
				WHEN CT2_LINHA IS NULL 
				THEN ' ' 
				ELSE CT2_LINHA 
			END LINHA,
			CASE 
				WHEN CT2_CREDIT IS NULL 
				THEN ' ' 
				ELSE CT2_CREDIT 
			END XPARTIDA,
			CASE 
				WHEN CT2_HIST IS NULL 
				THEN ' ' 
				ELSE CT2_HIST 
			END HIST,
			CASE 
				WHEN CT2_SEQHIS IS NULL 
				THEN ' ' 
				ELSE CT2_SEQHIS 
			END SEQHIS,
			CASE 
				WHEN CT2_SEQLAN IS NULL 
				THEN ' ' 
				ELSE CT2_SEQLAN 
			END SEQLAN,
			'1' TIPOLAN,
			CASE 
				WHEN CT2_VALOR IS NULL 
				THEN 0 
				ELSE CT2_VALOR 
			END DEBITO,
			0 CREDITO,
			CASE 
				WHEN CT2_EMPORI IS NULL 
				THEN ' ' 
				ELSE CT2_EMPORI 
			END EMPORI,
			CASE 
				WHEN CT2_FILORI IS NULL 
				THEN ' ' 
				ELSE CT2_FILORI 
			END FILORI 
		FROM
			%Table:CT1% CT1 
			LEFT JOIN %Table:CT2% CT2 
			ON CT2.CT2_FILIAL BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND
			CT2.CT2_DEBITO = CT1.CT1_CONTA AND
			CT2.CT2_DATA   >= %Exp:mv_par05% AND
			CT2.CT2_DATA   <= %Exp:mv_par06% AND
			CT2.CT2_CCD    >= %Exp:mv_par07% AND
			CT2.CT2_CCD    <= %Exp:mv_par08% AND
			CT2.CT2_ITEMD  >= %Exp:mv_par09% AND
			CT2.CT2_ITEMD  <= %Exp:mv_par10% AND
			CT2.CT2_CLVLDB >= %Exp:mv_par11% AND
			CT2.CT2_CLVLDB <= %Exp:mv_par12% AND
			CT2.CT2_TPSALD = '1' AND
			CT2.CT2_MOEDLC = '01' AND
			(CT2.CT2_DC = '1' OR
			CT2.CT2_DC = '3') AND
			CT2_VALOR <> 0 AND
			CT2.%NotDel%
		WHERE
			CT1.CT1_FILIAL = %Exp:xFilial("CT1")% AND
			CT1.CT1_CLASSE = '2' AND
			CT1.CT1_CONTA  >= %Exp:mv_par03% AND
			CT1.CT1_CONTA  <= %Exp:mv_par04% AND
			CT1.%NotDel%
		UNION
SELECT
	CT1_CONTA CONTA,
	CT1_DESC01 DESC01,
	
	// Por Sandro chamado:001221
	CASE
		WHEN CT2_FILIAL IS NULL 
			THEN ' ' 
		ELSE CT2_FILIAL 
	END FILIAL, 
	// At้ aqui. 
	
	CASE 
		WHEN CT2_CCC IS NULL 
		THEN ' ' 
		ELSE CT2_CCC 
	END CUSTO,
	CASE 
		WHEN CT2_ITEMC IS NULL 
		THEN ' ' 
		ELSE CT2_ITEMC 
	END ITEM,
	CASE 
		WHEN CT2_CLVLCR IS NULL 
		THEN ' ' 
		ELSE CT2_CLVLCR 
	END CLVL,
	CASE 
		WHEN CT2_DATA IS NULL 
		THEN ' ' 
		ELSE CT2_DATA 
	END DDATA,
	CASE 
		WHEN CT2_TPSALD IS NULL 
		THEN ' ' 
		ELSE CT2_TPSALD 
	END TPSALD,
	CASE 
		WHEN CT2_DC IS NULL 
		THEN ' ' 
		ELSE CT2_DC 
	END DC,
	CASE 
		WHEN CT2_LOTE IS NULL 
		THEN ' ' 
		ELSE CT2_LOTE 
	END LOTE,
	CASE 
		WHEN CT2_SBLOTE IS NULL 
		THEN ' ' 
		ELSE CT2_SBLOTE 
	END SUBLOTE,
	CASE 
		WHEN CT2_DOC IS NULL 
		THEN ' ' 
		ELSE CT2_DOC 
	END DOC,
	CASE 
		WHEN CT2_LINHA IS NULL 
		THEN ' ' 
		ELSE CT2_LINHA 
	END LINHA,
	CASE 
		WHEN CT2_DEBITO IS NULL 
		THEN ' ' 
		ELSE CT2_DEBITO 
	END XPARTIDA,
	CASE 
		WHEN CT2_HIST IS NULL 
		THEN ' ' 
		ELSE CT2_HIST 
	END HIST,
	CASE 
		WHEN CT2_SEQHIS IS NULL 
		THEN ' ' 
		ELSE CT2_SEQHIS 
	END SEQHIS,
	CASE 
		WHEN CT2_SEQLAN IS NULL 
		THEN ' ' 
		ELSE CT2_SEQLAN 
	END SEQLAN,
	'2' TIPOLAN,
	0 CREDITO,
	CASE 
		WHEN CT2_VALOR IS NULL 
		THEN 0 
		ELSE CT2_VALOR 
	END DEBITO,
	CASE 
		WHEN CT2_EMPORI IS NULL 
		THEN ' ' 
		ELSE CT2_EMPORI 
	END EMPORI,
	CASE 
		WHEN CT2_FILORI IS NULL 
		THEN ' ' 
		ELSE CT2_FILORI 
	END FILORI 
FROM
	%Table:CT1% CT1 
	LEFT JOIN %Table:CT2% CT2 
	ON CT2.CT2_FILIAL BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND
	CT2.CT2_CREDIT = CT1.CT1_CONTA AND
	CT2.CT2_DATA   >= %Exp:mv_par05% AND
	CT2.CT2_DATA   <= %Exp:mv_par06% AND
	CT2.CT2_CCC    >= %Exp:mv_par07% AND
	CT2.CT2_CCC    <= %Exp:mv_par08% AND
	CT2.CT2_ITEMC  >= %Exp:mv_par09% AND
	CT2.CT2_ITEMC  <= %Exp:mv_par10% AND
	CT2.CT2_CLVLCR >= %Exp:mv_par11% AND
	CT2.CT2_CLVLCR <= %Exp:mv_par12% AND
	CT2.CT2_TPSALD = '1' AND
	CT2.CT2_MOEDLC = '01' AND
	(CT2.CT2_DC = '2' OR
	CT2.CT2_DC = '3') AND
	CT2_VALOR <> 0 AND
	CT2.%NotDel%
WHERE
	CT1.CT1_FILIAL = %Exp:xFilial("CT1")% AND
	CT1.CT1_CLASSE = '2' AND
	CT1.CT1_CONTA >= %Exp:mv_par03% AND
	CT1.CT1_CONTA <= %Exp:mv_par04% AND
	CT1.%NotDel%
	)
	CK
WHERE
	(DEBITO <> 0 OR
	CREDITO <> 0)	
ORDER BY
    FILIAL,
	CONTA,
	DOC,
	LOTE,
	SUBLOTE,
	LINHA
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
ฑฑบPrograma  ณValidPerg บAutor  ณBruno M. Mota       บ Data ณ  03/04/10   บฑฑ
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
AADD(aRegs,{cPerg,"01","De Filial" 		,"","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Filial"		,"","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","De Conta"  		,"","","mv_ch3","C",20,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Conta" 		,"","","mv_ch4","C",20,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","De Data"  		,"","","mv_ch3","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate Data" 		,"","","mv_ch4","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","De C. Custo"	,"","","mv_ch7","C",09,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate C. Custo"	,"","","mv_ch8","C",09,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","De Item C."		,"","","mv_ch9","C",09,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","De Item C."		,"","","mv_cha","C",09,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","De C. Valor"  	,"","","mv_chb","C",09,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","De C. Valor"	,"","","mv_chc","C",09,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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