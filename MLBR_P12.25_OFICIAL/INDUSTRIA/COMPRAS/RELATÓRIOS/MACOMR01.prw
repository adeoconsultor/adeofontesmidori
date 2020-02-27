#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMACOMR01  บAutor  ณBruno M. Mota       บ Data ณ  11/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio responsavel por trazer os dados cruzados da nota  บฑฑ
ฑฑบ          ณfiscal de entrada com o pedido de compras e sol. de compras บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP 8.11/R4 ou 10.1 - Especifico Midori                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MACOMR01()
//Variaveis locais da funcao
//variaveis privadas da funcao
Private cPerg := PADR("MACOMR01",10)
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
ฑฑบPrograma  ณReportDef บAutor  ณBruno M. Mota       บ Data ณ  11/01/10   บฑฑ
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
TRCell():New(oSection1,"D1_GRUPO"	,"TMP","Grp. Prd."   	,"@!"				,04,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"BM_DESC"	,"TMP","Desc. Grp."		,"@!"				,30,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"D1_FORNECE"	,"TMP","Cod. Forn."  	,"@!"				,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"D1_LOJA"	,"TMP","Loja. Forn."  	,"@!"				,02,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"A2_NOME"	,"TMP","Nom. Forn."		,"@!"               ,40,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"D1_COD"		,"TMP","Cod. Prd."  	,"@!"				,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"B1_DESC"	,"TMP","Desc. Prd."		,"@!"               ,40,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"D1_QUANT"	,"TMP","Quant."			,"@E 999,999,999.99",15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"D1_DOC"		,"TMP","Num. Doc."   	,"@!"				,09,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"D1_SERIE"	,"TMP","Ser. Doc."  	,"@!"				,03,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"D1_EMISSAO"	,"TMP","Emissao"		,"@!"               ,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"D1_PEDIDO"	,"TMP","Ped. Comp."		,"@!"               ,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C7_NUMSC"	,"TMP","Num. Sol."  	,"@!"				,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_DATPRF"	,"TMP","Dt. Neces."		,"@!"               ,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C7_QUJE"	,"TMP","Qt. Entr."   	,"@E 999,999,999.99",06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"D1_VALICM"	,"TMP","Val. ICMS"  	,"@E 999,999,999.99",15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"D1_VALIPI"	,"TMP","Val. IPI"		,"@E 999,999,999.99",15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"D1_CUSTO"	,"TMP","Val. Merc."		,"@E 999,999,999.99",15,/*TAMPIXEL*/,/*BLOCO*/)
//Retorno da funcao
Return(oReport)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReporบAutor  ณBruno M. Mota       บ Data ณ  04/06/09   บฑฑ
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
//Verifica se utilizara parametro ou nao
If mv_par11 == 1
	//Monta um query para todas as TES
	//Abre SF4
	SF4->(dbSetOrder(1))
	//Posiciona no primeiro registro
	SF4->(dbGoTop())
	//Processa TES
	While (!SF4->(EoF())) .And. (SF4->F4_CODIGO < "500")
		//Monta string
		cTES += SF4->F4_CODIGO+"','"
		//Muda de registro
		SF4->(dbSkip())
	EndDo
	//Ajusta variavel cTES
   //	cTES := SubStr(cTES,1,Len(cTES)-3) //AOliveira 11-07-2011   //
   SubStr(cTES,Len(cTES)-3,Len(cTES))
ElseIf	mv_par11 == 2
	//Adiciona valores ao parametro
	cTES := GetMv("MV_MACOMR1")
EndIf	
//Inicia a query da section 1
oSection1:BeginQuery()
//Inicia a montagem da query
BeginSql Alias "TMP"
%NoParser%
SELECT 
	DISTINCT	D1_GRUPO,
				BM_DESC,
				D1_FORNECE,
				D1_LOJA, 
				D1_COD, 
				D1_DOC, 
				D1_SERIE,
				A2_NOME, 
				B1_DESC,
				D1_QUANT, 
				D1_EMISSAO, 
				CASE 
					WHEN SD1.D1_PEDIDO IS NULL OR SD1.D1_PEDIDO = ' '
					THEN 'N/D'
					ELSE SD1.D1_PEDIDO
					END D1_PEDIDO, 
				CASE 
					WHEN SC7.C7_NUMSC IS NULL 
					THEN 'N/D' 
					ELSE SC7.C7_NUMSC 
					END C7_NUMSC, 
				CASE 
					WHEN SC1.C1_DATPRF IS NULL OR SC1.C1_DATPRF= ' '
					THEN 'N/D' 
					ELSE SC1.C1_DATPRF 
					END C1_DATPRF,
				SD1.D1_DTDIGIT, 
                CASE
					WHEN SC7.C7_QUJE IS NULL OR SC7.C7_QUJE = 0 
					THEN CASE
						 WHEN SC7.C7_QUJE IS NULL THEN 0
						 WHEN SC7.C7_QUJE = 0 THEN (SC7.C7_QUANT-SD1.D1_QUANT)
						 END
					ELSE (SC7.C7_QUANT-SC7.C7_QUJE)
					END C7_QUJE,
				D1_VALICM, 
				D1_VALIPI, 
				D1_QUANT*D1_VUNIT D1_CUSTO
FROM
	%Table:SD1%	SD1 LEFT OUTER JOIN
				%Table:SC7% SC7 ON SD1.D1_PEDIDO = SC7.C7_NUM AND 
				SC7.C7_ITEM = SD1.D1_ITEMPC AND
				SD1.D1_FILIAL = SC7.C7_FILIAL 
			LEFT OUTER JOIN
                %Table:SC1% SC1 ON SC7.C7_NUMSC =SC1.C1_NUM AND 
                SC1.C1_ITEM = SC7.C7_ITEMSC AND
                SC7.C7_FILIAL = SC1.C1_FILIAL 
            INNER JOIN
                %Table:SA2% SA2 ON SD1.D1_FORNECE = SA2.A2_COD AND 
                SD1.D1_LOJA = SA2.A2_LOJA 
			INNER JOIN
                %Table:SB1% SB1 ON SD1.D1_COD = SB1.B1_COD
            INNER JOIN 
            	%Table:SBM% SBM ON SB1.B1_GRUPO = SBM.BM_GRUPO    
WHERE
	SD1.D1_FORNECE BETWEEN %Exp:mv_par01% AND  %Exp:mv_par02% AND
	SD1.D1_LOJA BETWEEN  %Exp:mv_par03% AND  %Exp:mv_par04% AND
	SB1.B1_COD BETWEEN  %Exp:mv_par05% AND  %Exp:mv_par06% AND
	SB1.B1_GRUPO BETWEEN  %Exp:mv_par07% AND  %Exp:mv_par08% AND	
	SD1.D1_EMISSAO BETWEEN  %Exp:mv_par09% AND  %Exp:mv_par10% AND
	SD1.D1_TES IN (%Exp:cTES%) AND		
	SD1.%NotDel% AND
	SA2.%NotDel% AND
	SB1.%NotDel% //AND			
	//SD1.D1_FILIAL  BETWEEN %Exp:mv_par12% AND  %Exp:mv_par13% 
	//.AND.
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
ฑฑบPrograma  ณValidPerg บAutor  ณBruno M. Mota       บ Data ณ  11/01/09   บฑฑ
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
AADD(aRegs,{cPerg,"01","De Fornecedor" 	,"","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Fornecedor"	,"","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","De Loja"  		,"","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Loja" 		,"","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","De Produto"  	,"","","mv_ch3","C",15,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate Produto" 	,"","","mv_ch4","C",15,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","De Grp. Prod."	,"","","mv_ch7","C",04,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate Grp. Prod."	,"","","mv_ch8","C",04,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","De Dt. Digit."	,"","","mv_ch9","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","De Ate. Digit."	,"","","mv_cha","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Considera TES"  ,"","","mv_chb","C",20,0,0,"C","","mv_par11","T=Todas","T=Todas","T=Todas","","","P=Parametro","P=Parametro","P=Parametro","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","De Filial"		,"","","mv_chc","C",02,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Ate Filial"  	,"","","mv_chd","C",02,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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