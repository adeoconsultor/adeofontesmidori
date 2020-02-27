#INCLUDE "Protheus.ch"  

///////////////////////////////////////////////////////////////////////////////
//Relatorio de Venda X Custo de producao
//Gera um relatorio com o valor vendido em determinado periodo e busca o custo de producao
//////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br -07-08-2012
///////////////////////////////////////////////////////////////////////////////

User Function AGF_CUSXVEND()
Processa( {|lEnd| CalcConsCus(@lEnd)}, "Aguarde...","Calculando Custos X Valor de Venda.", .T. )

return

static function CalcConsCus(lEnd)		
Local cQuery := ""          
Private cPerg   := "AGF_CUSXV"
if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
endif
Pergunte(cPerg,.T.)      


//Busca o custo unitario das MODs no periodo
if Select('TRMOD') > 0
	dbSelectArea('TRMOD')
	TRMOD->(dbCloseArea())
endif

cQTRMOD := " Select FILIAL, D3_COD, (CUSTMOD / QTDEMOD) MODUNIT from " 
cQTRMOD += " (Select D3_FILIAL FILIAL, D3_COD, SUM(D3_QUANT) QTDEMOD, SUM(D3_CUSTO1) CUSTMOD " 
cQTRMOD += " from SD3010 " 
cQTRMOD += " where D_E_L_E_T_ = ' '  " 
if cFilant <> '01
	cQTRMOD += " and D3_FILIAL ='" +xFilial('SD3')+"' " 
endif
cQTRMOD += " and Substring(D3_COD,1,3)='MOD' " 
//cQTRMOD += " and Substring(D3_EMISSAO,1,6)='201401' "
cQTRMOD += " AND D3_EMISSAO between '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' " 
cQTRMOD += " group by D3_FILIAL, D3_COD) RESMOD "
cQTRMOD += " order by FILIAL, D3_COD " 
                                      
dbUseArea(.T., "TOPCONN", tcGenQry(,, cQTRMOD ),"TRMOD", .T.,.T.)
aVlMod := {}
dbSelectArea('TRMOD')
dbGotop()
while !TRMOD->(eof())
	AADD(aVlMod, {D3_COD, MODUNIT})
	TRMOD->(dbSkip())
enddo

//Verifica se tabelas temporias existem e encerra as mesmas antes de executar as novas
if Select("TRB") > 0 
	dbSelectArea("TRB")
	TRB->(dbCloseArea())
endif

cQuery := " Select D2_GRUPO, D2_COD, B1_DESC, B1_UM, B1_TIPO, Sum(D2_QUANT) D2_QUANT, AVG(D2_PRCVEN) D2_PRCVEN, "
cQuery += " Sum(D2_TOTAL) D2_TOTAL, SUM(D2_TOTAL)- SUM(D2_VALIMP5+D2_VALIMP6+D2_VALICM) VALOR_S_IMP, Sum(D2_CUSTO1) D2_CUSTO1, "
cQuery += " 0 CUSTOMOD, SUM(D2_VALIMP5) COFINS, Sum(D2_VALIMP6) PIS, SUM(D2_VALICM) ICMS "
//--((SUM(D2_TOTAL)- SUM(D2_VALIMP5+D2_VALIMP6+D2_VALICM)) - SUM(D2_CUSTO1)) / SUM(D2_CUSTO1) MARG_CONTRIB
cQuery += " from SD2010 SD2, SB1010 SB1, SF4010 SF4 " 
cQuery += " where SD2.D_E_L_E_T_ = ' ' and SB1.D_E_L_E_T_ = ' '  and SF4.D_E_L_E_T_ = ' '  "
cQuery += " and D2_COD = B1_COD "
cQuery += " and F4_CODIGO = D2_TES "
cQuery += " and F4_FILIAL = '"+xFilial("SF4")+"' "
cQuery += " and D2_FILIAL = '"+xFilial("SD2")+"' "
//cQuery += " and D2_FILIAL = F4_FILIAL   "  - Comentado por ter unificado as TES
cQuery += " and D2_EMISSAO between '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
cQuery += " and D2_CLIENTE <> '000001' "
cQuery += " and D2_COD between '"+mv_par03+"' AND '"+mv_par04+"' "
cQuery += " and D2_GRUPO between '"+mv_par05+"' AND '"+mv_par06+"' "
cQuery += " and D2_TIPO <> 'D' "
cQuery += " and F4_ESTOQUE = 'S' and F4_DUPLIC = 'S' " 
cQuery += " group by D2_GRUPO, D2_COD, B1_DESC, B1_UM, B1_TIPO "
cQuery += " order by B1_DESC "


                                                            
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN", tcGenQry(,,cQuery),"TRB",.F.,.T.)

//Arquivo temporario da funcao para geracao do relatorio
aTMP	:= {}                               
AADD(aTMP,{"B1_GRUPO"		, "C", 04, 0 } )
AADD(aTMP,{"B1_COD" 	    , "C", 15, 0 } )
AADD(aTMP,{"B1_DESC"        , "C", 50, 0 } )
AADD(aTMP,{"B1_UM" 			, "C", 02, 0 } )
AADD(aTMP,{"B1_TIPO" 		, "C", 02, 0 } )
AADD(aTMP,{"QTDE"			, "N", 15, 2 } )
AADD(aTMP,{"PRCUNIT" 		, "N", 15, 2 } )
AADD(aTMP,{"VLRTOT" 		, "N", 15, 2 } )
AADD(aTMP,{"VLRTSIMP"       , "N", 15, 2 } )
AADD(aTMP,{"CUSTOPRD"       , "N", 15, 2 } )
AADD(aTMP,{"CUSTOMOD"       , "N", 15, 2 } )
AADD(aTMP,{"MARGCONT"       , "N", 12, 2 } )
AADD(aTMP,{"VLRPIS" 		, "N", 15, 2 } )
AADD(aTMP,{"VLRCOF"			, "N", 15, 2 } )
AADD(aTMP,{"VLRICM" 		, "N", 15, 2 } )

ctrTMP := CriaTrab(aTMP, .T.)
dbUseArea(.T.,,ctrTMP,"TMP",.F.,.F.)
INDEX ON B1_COD + B1_DESC to &ctrTMP

dbSelectArea('TRB')
dbGotop()
While !TRB->(eof())
	RecLock("TMP",.T.)
	TMP->B1_GRUPO	:= TRB->D2_GRUPO
	TMP->B1_COD    	:= TRB->D2_COD
	TMP->B1_DESC	:= TRB->B1_DESC
	TMP->B1_UM		:= TRB->B1_UM
	TMP->B1_TIPO	:= TRB->B1_TIPO
	TMP->QTDE		:= TRB->D2_QUANT
	TMP->PRCUNIT	:= TRB->D2_PRCVEN
	TMP->VLRTOT		:= TRB->D2_TOTAL
	TMP->VLRTSIMP	:= TRB->VALOR_S_IMP
	TMP->CUSTOPRD	:= TRB->D2_CUSTO1
	TMP->CUSTOMOD	:= TRB->D2_QUANT * CALCMOD(TRB->D2_COD)
	TMP->MARGCONT	:= iif(TRB->D2_CUSTO1 > 0, Round(((TRB->VALOR_S_IMP - TRB->D2_CUSTO1) / TRB->D2_CUSTO1)*100,2) , 0)
	TMP->VLRPIS		:= TRB->PIS
	TMP->VLRCOF		:= TRB->COFINS
	TMP->VLRICM		:= TRB->ICMS
	MsUnLock("TMP")
	TRB->(dbSkip())
enddo


If TRepInUse()
	//Gera as definicoes do relatorio
	oReport := ReportDef()
	//Monta interface com o usuário
	oReport:PrintDialog()
endif



//Retorno da funcao
TMP->(dbCloseArea())
Ferase(ctrTMP+".dbf")
Ferase(ctrTMP+".cdx")

Return()

//-------------------------
Static Function ReportDef()
//-------------------------
//Variaveis locais da funcao
Local oReport 	:= ""
Local oBreak	:= ""
Local oSection1	:= ""
Local nCount    := 0
//Inicio da funcao
//Monta o objeto do relatorio


oReport := TReport():New(cPerg,"Relatorio de Composicao de Valor de Venda X Custo de Produção",cPerg,{|oReport| Printreport(oReport)},;
				"Relatorio de Composicao de Valor de Venda X Custo de Produção ")
//Cria a Seção do relatorio
oSection1 := TRSection():New(oReport,"Relatorio de Composicao de custo de produção",{"TMP"},/*Ordem*/)

	TMP->B1_GRUPO	:= TMP->B1_GRUPO
	TMP->B1_COD    	:= TMP->B1_COD
	TMP->B1_DESC	:= TMP->B1_DESC
	TMP->B1_UM		:= TMP->B1_UM
	TMP->B1_TIPO	:= TMP->B1_TIPO
	TMP->QTDE		:= TMP->QTDE
	TMP->PRCUNIT	:= TMP->PRCUNIT
	TMP->VLRTOT		:= TMP->VLRTOT
	TMP->VLRTSIMP	:= TMP->VLRTSIMP
	TMP->CUSTOPRD	:= TMP->CUSTOPRD
	TMP->CUSTOMOD	:= TMP->CUSTOMOD
	TMP->MARGCONT	:= TMP->MARGCONT
	TMP->VLRPIS		:= TMP->VLRPIS
	TMP->VLRCOF		:= TMP->VLRCOF
	TMP->VLRICM		:= TMP->VLRICM
	//Cria as celulas do relatório 
	TRCell():New(oSection1,"B1_COD"			,"TMP","Cod.Prod"		,"@!"					,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"B1_DESC"		,"TMP","Descr.Produto"  ,"@!"					,50,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"B1_GRUPO"		,"TMP","Grupo"			,"@!"					,04,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"B1_UM"	   		,"TMP","UM"		  		,"@!"					,02,/*TAMPIXEL*/,/*BLOCO*/)	
	TRCell():New(oSection1,"B1_TIPO"		,"TMP","Tipo"			,"@!"					,02,/*TAMPIXEL*/,/*BLOCO*/)	
	TRCell():New(oSection1,"QTDE"			,"TMP","    	   Qtde","@E 9,999,999.99"		,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"PRCUNIT"		,"TMP","       Prc.Unit","@E 9,999,999.99"		,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"VLRTOT"			,"TMP","      Vlr.Total","@E 9,999,999.99"		,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"VLRTSIMP"	    ,"TMP","  Vlr.S/Imposto","@E 9,999,999.99"		,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"CUSTOPRD"	    ,"TMP","  Custo Produto","@E 9,999,999.99"		,15,/*TAMPIXEL*/,/*BLOCO*/)	
	TRCell():New(oSection1,"CUSTOMOD"	    ,"TMP","	  Custo MOD","@E 9,999,999.99"		,15,/*TAMPIXEL*/,/*BLOCO*/)	
	TRCell():New(oSection1,"MARGCONT"	    ,"TMP"," Margem Contr.%","@E 999.99%"	  		,15,/*TAMPIXEL*/,/*BLOCO*/)	
	TRCell():New(oSection1,"VLRPIS"	        ,"TMP","  		Vlr.PIS","@E 9,999,999.99"		,15,/*TAMPIXEL*/,/*BLOCO*/)	
	TRCell():New(oSection1,"VLRCOF"	        ,"TMP","  	 Vlr.COFINS","@E 9,999,999.99"		,15,/*TAMPIXEL*/,/*BLOCO*/)		
	TRCell():New(oSection1,"VLRICM"	        ,"TMP","  		Vlr.ICM","@E 9,999,999.99"		,15,/*TAMPIXEL*/,/*BLOCO*/)		
//	TRCell():New(oSection1,"B1_TPCLASS"     ,"TMP","Tipo Class"   	,"@!" 					,20,/*TAMPIXEL*/,/*BLOCO*/)


Return(oReport)

//-------------------------
Static Function PrintReport()
//-------------------------
Private oSection1 := oReport:Section(1)
oReport:FatLine()
oSection1:Print()
Return()


//--------------------------------
Static Function AjustaSx1(cPerg)
//--------------------------------
//Variaveis locais
Local aRegs := {}
Local i,j
//Inicio da funcao
dbSelectArea("SX1")
dbSetOrder(1)
//   1          2        3         4          5           6       7       8             9        10      11     12       13        14        15         16       17       18       19        20          21        22      23        24       25         26        27       28       29       30          31        32       33       34        35          36        37     38     39       40       41        42
//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_PYME/X1_GRPSXG/X1_HELP/X1_PICTURE
PutSx1(cPerg,"01","Data Inicial                  ?"," "," ","mv_ch1","D",8,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo inicial"},{"Informe o periodo inicial"},{"Informe o periodo inicial"})
PutSx1(cPerg,"02","Data final                    ?"," "," ","mv_ch2","D",8,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo final"},{"Informe o periodo final"},{"Informe o periodo final"})
PutSx1(cPerg,"03","Produto de                    ?"," "," ","mv_ch3","C",15,0,0,"G","","SB1","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto inicial"},{"Informe o produto inicial"},{"Informe o produto inicial"})
PutSx1(cPerg,"04","Produto ate                   ?"," "," ","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto final"},{"Informe o produto final"},{"Informe o produto final"})
PutSx1(cPerg,"05","Grupo Inicial                 ?"," "," ","mv_ch5","C",04,0,0,"G","","SBM","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o grupo inicial"},{"Informe o grupo inicial"},{"Informe o grupo inicial"})
PutSx1(cPerg,"06","Grupo Final                   ?"," "," ","mv_ch6","C",04,0,0,"G","","SBM","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o grupo final"},{"Informe o grupo final"},{"Informe o grupo final"})

//PutSx1(cPerg,"07","Armazem ate                   ?"," "," ","mv_ch9","C",2,0,0, "G","","   ","","","mv_par09"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o Armazem Final           "},{"Informe o Armazem final           "},{"Informe o Armazem final           "})
//PutSx1(cPerg,"08","Imprimir Resumo               ?"," "," ","mv_cha","N",1,0,2, "C","","   ","","","mv_par10","Sim","Si","Yes", " ","Nao","No","No"," "," "," ", " "," "," "," ",	" ","",{"Imprimir resumo ao final do relatorio"},{"Imprimir resumo ao final do relatorio"},{"Imprimir resumo ao final do relatorio"})
///PutSx1(cPerg,"11","Imprimir M2 Pelo              ?"," "," ","mv_chb","N",1,0,2, "C","","   ","","","mv_par11","Soma Consumo","Soma Consumo","Soma Consumo", " ","Media Consumo","Media Consumo","Media Consumo"," "," "," ", " "," "," "," ",	" ","",{"Imprimir consumo pela Média ou Pela Soma"},{"Imprimir consumo pela Média ou Pela Soma"},{"Imprimir consumo pela Média ou Pela Soma"})

//Loop de armazenamento
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			endif
		Next
		MsUnlock()
	endif
Next
Return()

//////////////////////////////////////////////////////////////////////////////////////
//Funcao para fazer o calculo da mao de obra individual para cada produto
//////////////////////////////////////////////////////////////////////////////////////
static function CALCMOD(cCod)
local nCusMod := 0

if Select('TMPG1')> 0
	dbSelectArea('TMPG1')
	TMPG1->(dbCloseArea())
endif

	cQG1 := " SELECT G1_COD, G1_COMP, AVG(G1_QUANT) G1_QUANT "
	cQG1 += " FROM SG1010 SG1 "
	cQG1 += " where SG1.D_E_L_E_T_ = ' '  "
	cQG1 += " and G1_COD = '"+cCod+"' " 
	cQG1 += " and Substring(G1_COMP,1,3) = 'MOD' " 
	cQG1 += " group by G1_COD, G1_COMP "
	cQG1 += " order by G1_COMP " 

	cQD3 := ChangeQuery(cQG1)
	dbUseArea(.T.,"TOPCONN", tcGenQry(,, cQG1), "TMPG1",.F.,.T.)

	
	dbSelectArea("TMPG1")
	TMPG1->(dbGotop())
	while !TMPG1->(eof())
//	Alert('Chamando produto -> '+TMPG1->G1_COMP)
		nPos := aScan(aVlMod, {|x| x[1] == G1_COMP } ) 
		if nPos > 0
//			Alert('Produto-> '+aVlMod[nPos][1]+' Vlr Mod -> '+cValToChar(aVlMod[nPos][2]))
			nCusMod += TMPG1->G1_QUANT * aVlMod[nPos][2]
		endif
	TMPG1->(dbSkip())
	incProc("Calculando custo de MOD "+TMPG1->G1_COMP)
	enddo
     
return nCusMod