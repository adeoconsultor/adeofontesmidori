#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMAFINR04  บAutor  ณBruno M. Mota       บ Data ณ  22/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio responsavel por trazer as contas a pagar de acor- บฑฑ
ฑฑบ          ณdo com as naturezas de movimenta็ใo.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP 8.11/R4 ou 10.1 - Especifico Midori                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//------------------------
User Function MAFINR04()
//------------------------
Private cPerg := PADR("MAFINR04",10)
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
ฑฑบPrograma  ณReportDef บAutor  ณBruno M. Mota       บ Data ณ  22/03/10   บฑฑ
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
oReport := TReport():New("MAFINR04","Posi็ใo Contas a Pagar X Natureza",cPerg,{|oReport| Printreport(oReport)},;
				"Este relatorio imprimirแ a posi็ใo do contas a pagar po natureza.")
//Cria a Se็ใo do relatorio
oSection1 := TRSection():New(oReport,"Posi็ใo Contas a Pagar X Natureza",{"SE2","SA2"},/*Ordem*/)
//Cria as celulas do relat๓rio 
TRCell():New(oSection1,'E2_VENCREA'				,'TMP','Vencimento'   					,'@!'				,13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'GPESSOAL' 				,'TMP','Gastos com Pessoal'   			,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'GGERAIS' 				,'TMP','Gastos Gerais'   				,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'IMPOSTOS' 				,'TMP','Impostos'  	 					,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'INVESTIMENTOS' 			,'TMP','Investimentos'   				,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'MP_COUROS' 				,'TMP','M.P. Couros'   					,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'MP_QUIMICOS' 			,'TMP','M.P Quimicos'   				,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'MP_SECUNDARIOS' 		,'TMP','M.P. Secundarios'   			,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'MP_SEC_FOR' 			,'TMP','M.P FORMTAP'   					,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'MP_INT_EMB' 			,'TMP','M.P. Inermed/Emb.'   			,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'MP_OUT_INS' 			,'TMP','M.P. Outros Ins.'   			,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'MO_IND' 				,'TMP','M.O. Indus.'   					,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'FRETE_EXT' 				,'TMP','Fretes Externos'  	 			,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'FRETES_CARR' 			,'TMP','Fretes/Carretos'   				,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'FRETES_SERV_TERCEIRO' 	,'TMP','Fretes S/ Ind. Terc.'   		,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'FRETES_TRANSF_MATRIZ' 	,'TMP','Fretes S/ Trasnf. Mat./Fil.'   	,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'FRETES_V_EXT' 		,'TMP','Fretes Vendas Ext.'   			,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'FRETES_VEND_INT' 		,'TMP','Fretes Vendas Int.'  		 	,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'COMB_IND' 				,'TMP','Comb.Ind.        '   			,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'COMB_VEIC' 				,'TMP','Comb.Veic.        '   			,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'TRANSF_BANC' 			,'TMP','Transf. Bancarias'   			,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,'TOTAL_DIA'	 			,'TMP','Total Dia        '   			,'@E 999,999,999.99',13,/*TAMPIXEL*/,/*BLOCO*/)


//Cria as quebras totalizadoras
oBreak := TRBreak():New(oSection1,"","Total Geral: ")
//Cria funcao totalizadora
TRFunction():New(oSection1:Cell('GPESSOAL')				,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('GGERAIS')				,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('IMPOSTOS')				,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('INVESTIMENTOS')		,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('MP_COUROS')			,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('MP_QUIMICOS')			,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('MP_SECUNDARIOS')		,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('MP_SEC_FOR')			,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('MP_INT_EMB')			,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('MP_OUT_INS')			,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('MO_IND')				,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('FRETE_EXT')			,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('FRETES_CARR')			,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('FRETES_SERV_TERCEIRO'),NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('FRETES_TRANSF_MATRIZ'),NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('FRETES_V_EXT')		,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('FRETES_VEND_INT')		,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('COMB_IND')				,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('COMB_VEIC')			,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('TRANSF_BANC')			,NIL,'SUM',oBreak)
TRFunction():New(oSection1:Cell('TOTAL_DIA')			,NIL,'SUM',oBreak)
//Retorno da funcao
Return(oReport)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReporบAutor  ณBruno M. Mota       บ Data ณ  22/03/10   บฑฑ
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
	E2_VENCREA,
	CAST(SUM(GPESSOAL) AS NUMERIC (10,	2)) GPESSOAL,
	CAST(SUM(GGERAIS) AS NUMERIC (10,	2)) GGERAIS,
	CAST(SUM(IMPOSTOS) AS NUMERIC (10,	2)) IMPOSTOS,
	CAST(SUM(INVESTIMENTOS) AS NUMERIC (10,	2)) INVESTIMENTOS,
	CAST(SUM(MP_COUROS) AS NUMERIC (10,		2)) MP_COUROS,
	CAST(SUM(MP_QUIMICOS) AS NUMERIC (10,	2)) MP_QUIMICOS,
	CAST(SUM(MP_SECUNDARIOS) AS NUMERIC (10,	2)) MP_SECUNDARIOS,
	CAST(SUM(MP_SEC_FOR) AS NUMERIC (10,	2)) MP_SEC_FOR,
	CAST(SUM(MP_INT_EMB) AS NUMERIC (10	,2)) MP_INT_EMB,
	CAST(SUM(MP_OUT_INS) AS NUMERIC (10,	2)) MP_OUT_INS,
	CAST(SUM(MO_IND) AS NUMERIC (10,	2)) MO_IND,
	CAST(SUM(FRETE_EXT) AS NUMERIC (10,	2)) FRETE_EXT,
	CAST(SUM(FRETES_CARR) AS NUMERIC (10,	2)) FRETES_CARR,
	CAST(SUM(FRETES_SERV_TERCEIRO) AS NUMERIC (10,	2)) FRETES_SERV_TERCEIRO,
	CAST(SUM(FRETES_TRANSF_MATRIZ) AS NUMERIC (10,	2)) FRETES_TRANSF_MATRIZ,
	CAST(SUM(FRETES_V_EXT) AS NUMERIC (10,	2)) FRETES_V_EXT,
	CAST(SUM(FRETES_VEND_INT) AS NUMERIC (10,	2)) FRETES_VEND_INT,
	CAST(SUM(COMB_IND) AS NUMERIC (10,	2)) COMB_IND,
	CAST(SUM(COMB_VEIC) AS NUMERIC (10,	2)) COMB_VEIC,
	CAST(SUM(TRANSF_BANC) AS NUMERIC (10,	2)) TRANSF_BANC,
	CAST(SUM(GPESSOAL+GGERAIS+IMPOSTOS+INVESTIMENTOS+MP_COUROS+MP_QUIMICOS+MP_SECUNDARIOS+MP_SEC_FOR+MP_INT_EMB+MP_OUT_INS+MO_IND+FRETE_EXT+FRETES_CARR+FRETES_SERV_TERCEIRO+FRETES_TRANSF_MATRIZ+FRETES_V_EXT+FRETES_VEND_INT+COMB_IND+COMB_VEIC+TRANSF_BANC	) AS NUMERIC(10,	2)) TOTAL_DIA 
FROM
	(	SELECT
			E2_VENCREA,
			CASE 
				WHEN E2_NATUREZ IN ('1032',
				'1033',
				'1034',
				'1035',
				'1036',
				'3027',
				'3028',
				'3029',
				'3030',
				'3031',
				'3033',
				'3034',
				'3035',
				'3037',
				'3063',
				'5041',
				'1021',
				'5045',
				'6011',
				'6013',
				'6017',
				'6029',
				'5048',
				'1037',
				'1038',
				'1046',
				'5051',
				'1000',
				'1001',
				'1002',								
				'1003',
				'1004',
				'1005',
				'1040', 
				'3077', 
				'3000', 
				'1048') 
				THEN E2_SALDO 
				ELSE 0 
			END GPESSOAL,
			CASE 
				WHEN E2_NATUREZ IN ('5001',
				'3039',
				'3040',
				'3041',
				'3049',
				'3051',
				'3053',
				'3054',
				'3056',
				'3057',
				'3058',
				'3060',
				'3061',
				'3062',
				'3064',
				'3065',
				'3066',
				'3067',
				'3068',
				'3069',
				'3070',
				'3071',
				'3072',
				'3073',
				'3075',
				'3002',
				'3003',
				'3004',
				'3005',
				'3006',
				'3007',
				'3008',
				'3009',
				'3010',
				'3011',
				'3013',
				'3014',
				'3017',
				'3018',
				'3022',
				'1039',
				'1043',
				'3023',
				'3025',
				'5002',
				'5003',
				'5004',
				'5005',
				'5006',
				'5009',
				'5010',
				'5011',
				'5012',
				'5013',
				'5014',
				'5015',
				'5017',
				'5018',
				'5019',
				'5020',
				'5021',
				'5022',
				'5023',
				'5024',
				'5025',
				'5026',
				'5027',
				'5028',
				'5029',
				'5030',
				'5031',
				'5032',
				'5033',
				'5034',
				'5035',
				'5036',
				'5037',
				'5038',
				'5039',
				'5040',
				'5042',
				'5044',
				'5046',
				'5047',
				'5016',
				'2000',
				'5000',
				'5049') 
				THEN E2_SALDO 
				ELSE 0 
			END GGERAIS,
			CASE 
				WHEN E2_NATUREZ IN ('6001',
				'6003',
				'6009',
				'6010',
				'6012',
				'6018',
				'6021',
				'6016',
				'6022',
				'6023',
				'6024',
				'3079',
				'6025',
				'IRF',
				'CSLL',
				'PIS',
				'COFINS',
				'6000',
				'6026') 
				THEN E2_SALDO 
				ELSE 0 
			END IMPOSTOS,
			CASE 
				WHEN E2_NATUREZ IN ('7001',
				'7000',
				'7002',
				'7003',
				'7004',
				'7005',
				'7006',
				'7007',
				'7008',
				'7009',
				'7010',
				'7011',
				'3016',
				'3019',
				'3020',
				'7012',
				'7013') 
				THEN E2_SALDO 
				ELSE 0 
			END INVESTIMENTOS,
			CASE 
				WHEN E2_NATUREZ IN ('4001') 
				THEN E2_SALDO 
				ELSE 0 
			END MP_COUROS ,
			CASE 
				WHEN E2_NATUREZ IN ('4002') 
				THEN E2_SALDO 
				ELSE 0 
			END MP_QUIMICOS ,
			CASE 
				WHEN E2_NATUREZ IN ('4003','4000') 
				THEN E2_SALDO 
				ELSE 0 
			END MP_SECUNDARIOS ,
			CASE 
				WHEN E2_NATUREZ IN ('4004') 
				THEN E2_SALDO 
				ELSE 0 
			END MP_SEC_FOR ,
			CASE 
				WHEN E2_NATUREZ IN ('4006') 
				THEN E2_SALDO 
				ELSE 0 
			END MP_INT_EMB ,
			CASE 
				WHEN E2_NATUREZ IN ('4007') 
				THEN E2_SALDO 
				ELSE 0 
			END MP_OUT_INS ,
			CASE 
				WHEN E2_NATUREZ IN ('4008') 
				THEN E2_SALDO 
				ELSE 0 
			END MO_IND ,
			CASE 
				WHEN E2_NATUREZ IN ('3043') 
				THEN E2_SALDO 
				ELSE 0 
			END FRETE_EXT ,
			CASE 
				WHEN E2_NATUREZ IN ('3044') 
				THEN E2_SALDO 
				ELSE 0 
			END FRETES_CARR ,
			CASE 
				WHEN E2_NATUREZ IN ('3045') 
				THEN E2_SALDO 
				ELSE 0 
			END FRETES_SERV_TERCEIRO ,
			CASE 
				WHEN E2_NATUREZ IN ('3046') 
				THEN E2_SALDO 
				ELSE 0 
			END FRETES_TRANSF_MATRIZ ,
			CASE 
				WHEN E2_NATUREZ IN ('3047') 
				THEN E2_SALDO 
				ELSE 0 
			END FRETES_V_EXT ,
			CASE 
				WHEN E2_NATUREZ IN ('3048') 
				THEN E2_SALDO 
				ELSE 0 
			END FRETES_VEND_INT ,
			CASE 
				WHEN E2_NATUREZ IN ('5007') 
				THEN E2_SALDO 
				ELSE 0 
			END COMB_IND,
			CASE 
				WHEN E2_NATUREZ IN ('5008') 
				THEN E2_SALDO 
				ELSE 0 
			END COMB_VEIC ,
			CASE 
				WHEN E2_NATUREZ IN ('1018') 
				THEN E2_SALDO 
				ELSE 0 
			END TRANSF_BANC 
		FROM
			SE2010 SE2 
			INNER JOIN SA2010 SA2 
			ON E2_FORNECE = A2_COD AND
			E2_LOJA = A2_LOJA 
		WHERE
			SE2.D_E_L_E_T_ = ' ' AND
			SA2.D_E_L_E_T_ = ' ' AND
			SE2.E2_TIPO IN ('NF',
			'BOL',
			'DP','RC','FT','FOL','TX','CH','TF','DIR' )  AND
			E2_VENCREA BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND E2_SALDO > 0.00
	)
	CK 
GROUP BY
	E2_VENCREA 
ORDER BY
	E2_VENCREA
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
ฑฑบPrograma  ณValidPerg บAutor  ณBruno M. Mota       บ Data ณ  22/03/10   บฑฑ
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