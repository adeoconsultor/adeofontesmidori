#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMACOMR03  บAutor  ณBruno M. Mota       บ Data ณ  29/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio responsavel por trazer as solicitacoes de compras บฑฑ
ฑฑบ          ณbloqueadas ou nao, assim como seus respectivos PV e NFE.    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP 8.11/R4 ou 10.1 - Especifico Midori                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MACOMR03()
//Variaveis locais da funcao
//variaveis privadas da funcao
Private cPerg := PADR("MACOMR03",10)
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
ฑฑบPrograma  ณReportDef บAutor  ณBruno M. Mota       บ Data ณ  29/01/10   บฑฑ
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
oReport := TReport():New(cPerg,"N.F. Entrada X P.C. X S.C.",cPerg,{|oReport| Printreport(oReport)},;
				"Este relatorio cruzara as informacoes de entrada com o pedido de compras e suas respectivas solicitacoes.")
//Cria a Se็ใo do relatorio
oSection1 := TRSection():New(oReport,"N.F. Entrada X P.C. X S.C.",{"SD1","SC1","SC7","SA2","SB1"},/*Ordem*/)
//Cria as celulas do relat๓rio 
TRCell():New(oSection1,"C1_NUM"		,"TMP","Sol. Comp."			,"@!"               ,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_EMISSAO"	,"TMP","Emissao Sol. Com."	,"@!"               ,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_SOLICIT"	,"TMP","Nom. Sol."  		,"@!"				,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"B1_GRUPO"	,"TMP","Grp. Prd."   		,"@!"				,04,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"BM_DESC"	,"TMP","Desc. Grp."			,"@!"				,30,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_PRODUTO"	,"TMP","Cod. Prd."  		,"@!"				,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"B1_DESC"	,"TMP","Desc. Prd."			,"@!"               ,40,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_QUANT"	,"TMP","Quant. Ped. Com"	,"@E 999,999,999.99",15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_DATPRF"	,"TMP","Dt. Neces."			,"@!"               ,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_FORNECE"	,"TMP","Cod. Forn."  		,"@!"				,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_LOJA"	,"TMP","Loja. Forn."  		,"@!"				,02,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"A2_NOME"	,"TMP","Nom. Forn."			,"@!"               ,40,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_COTACAO"	,"TMP","Num. Cota็ใo"		,"@!"				,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_PEDIDO"	,"TMP","Num. Pedido"		,"@!"				,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_ITEMPED"	,"TMP","Item do Pedido"		,"@!"				,02,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_APROV"	,"TMP","Aprov./Bloq."		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_NOMAPRO"	,"TMP","Nom. Aprovador"		,"@!"				,40,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_FILENT"	,"TMP","Filial Entrg."		,"@!"				,02,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_IMPORT"	,"TMP","Prod. Importado"	,"@!"				,03,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_QUJE"	,"TMP","Saldo Pend. Sol."	,"@E 999,999,999.99",06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"D1_SERIE"	,"TMP","Ser. Doc."  		,"@!"				,03,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"D1_DOC"		,"TMP","Num. Doc."   		,"@!"				,09,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"D1_EMISSAO"	,"TMP","Emissao N.F."		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)

//Retorno da funcao
Return(oReport)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReporบAutor  ณBruno M. Mota       บ Data ณ  29/01/09   บฑฑ
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
	DISTINCT SB1.B1_DESC,
	SB1.B1_GRUPO,
	SBM.BM_DESC,
	SC1.C1_FORNECE,
	SC1.C1_LOJA,
	SC1.C1_NUM,
	SC1.C1_ITEM,
	SC1.C1_PRODUTO,
	SC1.C1_QUANT,
	SC1.C1_DATPRF,
	SC1.C1_FORNECE,
	SC1.C1_LOJA,
	CASE
		WHEN SA2.A2_NOME IS NULL
		THEN 'N/D'
		ELSE SA2.A2_NOME
	END A2_NOME	,
	SC1.C1_EMISSAO,
	SC1.C1_COTACAO,
	SC1.C1_PEDIDO,
	SC1.C1_ITEMPED,
	SC1.C1_SOLICIT,
	SC1.C1_QUJE,
	CASE 
		WHEN SC1.C1_APROV = 'L' 
		THEN 'LIBERADO' 
		ELSE 'BLOQUEADO' 
	END C1_APROV,
	SC1.C1_NOMAPRO,
	SC1.C1_FILENT,
	CASE 
		WHEN SC1.C1_IMPORT = 'S' 
		THEN 'SIM' 
		ELSE 
		CASE 
			WHEN SC1.C1_IMPORT = 'N' 
			THEN 'NAO' 
		END 
	END C1_IMPORT,
	CASE 
		WHEN SC7.C7_EMISSAO IS NULL 
		THEN 'N/D' 
		ELSE SC7.C7_EMISSAO 
	END C7_EMISSAO,
	CASE 
		WHEN SD1.D1_SERIE IS NULL 
		THEN 'N/D' 
		ELSE D1_SERIE 
	END D1_SERIE, 
	CASE 
		WHEN SD1.D1_DOC IS NULL 
		THEN 'N/D' 
		ELSE D1_DOC 
	END D1_DOC,
	CASE 
		WHEN SD1.D1_EMISSAO IS NULL 
		THEN 'N/D' 
		ELSE D1_EMISSAO 
	END D1_EMISSAO
FROM
	%Table:SC1% SC1 
		LEFT OUTER JOIN %Table:SC7% SC7 
		ON SC1.C1_NUM = SC7.C7_NUMSC AND
		SC1.C1_ITEM = SC7.C7_ITEMSC 
		INNER JOIN %Table:SB1% SB1 
		ON SC1.C1_PRODUTO = SB1.B1_COD 
		LEFT OUTER JOIN %Table:SD1% SD1 
		ON SC7.C7_NUM = SD1.D1_PEDIDO AND
		SC7.C7_ITEM = SD1.D1_ITEMPC
		LEFT OUTER JOIN %table:SA2% SA2
		ON SA2.A2_COD = SC1.C1_FORNECE AND
		SA2.A2_LOJA = SC1.C1_LOJA
		INNER JOIN %Table:SBM% SBM 
		ON SBM.BM_GRUPO = SB1.B1_GRUPO
WHERE
	SB1.B1_COD BETWEEN %Exp:mv_par01% AND
	%Exp:mv_par02% AND
	SB1.B1_GRUPO BETWEEN %Exp:mv_par03% AND
	%Exp:mv_par04% AND
	SC1.C1_EMISSAO BETWEEN %Exp:mv_par05% AND
	%Exp:mv_par06% AND
	SC1.C1_FILIAL BETWEEN %Exp:mv_par07% AND
	%Exp:mv_par08% AND
	SC1.%NotDel%zzzz
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
ฑฑบPrograma  ณValidPerg บAutor  ณBruno M. Mota       บ Data ณ  29/01/09   บฑฑ
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
AADD(aRegs,{cPerg,"01","De Produto"  	,"","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Produto" 	,"","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","De Grp. Prod."	,"","","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Grp. Prod."	,"","","mv_ch4","C",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","De Dt. Digit."	,"","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","De Ate. Digit."	,"","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","De Filial"  	,"","","mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate. Filial"	,"","","mv_ch8","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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