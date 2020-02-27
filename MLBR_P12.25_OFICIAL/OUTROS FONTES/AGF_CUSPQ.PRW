#INCLUDE "Protheus.ch"  

///////////////////////////////////////////////////////////////////////////////
//Relatorio de consumo de produto quimico - solicitado via chamado HDi 004206
//Gera o relatorio das quantidades de Produtos Quimicos consumido por artigo
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br - 19-12-2011
///////////////////////////////////////////////////////////////////////////////

User Function AGF_CUSPQ()
Local cQuery := ""          
Local cGrupo := "" 
Local i
Private cPerg   := "AGF_CONSPQ"

if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
endif
Pergunte(cPerg,.T.)      
                   

for i:=1 to 40
	if Substr(mv_par03,i,1) == ';' .or. Substr(mv_par03,i,1) == '/'
		cGrupo:= cGrupo+"','"
	else
		cGrupo:= cGrupo+Substr(mv_par03,i,1)
	endif
	if Substr(mv_par03,i,1) == " "
		i:= 40
	endif
next              



if Select("TMP") > 0 
	dbSelectArea("TMP")
	TMP->(dbCloseArea())
endif
//Arquivo temporario da funcao para geracao do relatorio
aTMP	:= {}                               
if mv_par10 <> 1
	AADD(aTMP,{"C2_NUM" 	    , "C", 05, 0 } )
	AADD(aTMP,{"D3_COD"	        , "C", 15, 0 } )
	AADD(aTMP,{"D3_LOCAL" 	    , "C", 02, 0 } )
endif
AADD(aTMP,{"C2_PRODUTO"	    , "C", 15, 0 } )
AADD(aTMP,{"B1_DESC"        , "C", 50, 0 } )
AADD(aTMP,{"C2_QUANT" 	    , "N", 15, 2 } )
AADD(aTMP,{"C2_QTDM2"		, "N", 15, 2 } )
AADD(aTMP,{"D3_QUANT"  	   	, "N", 15, 2 } )
AADD(aTMP,{"D3_CUSTO"   	, "N", 15, 2 } )
AADD(aTMP,{"B1_TPCLASS"	    , "C", 20, 0 } )
ctrTMP := CriaTrab(aTMP, .T.)
dbUseArea(.T.,,ctrTMP,"TMP",.F.,.F.)
if mv_par10 == 1
	INDEX ON C2_PRODUTO TO &ctrTMP
else
	INDEX ON C2_NUM + C2_PRODUTO to &ctrTMP
endif

alert('Grupos-> '+cGrupo)
if Select("TMPQ") > 0
	dbSelectArea("TMPQ")
	TMPQ->(dbCloseArea())
endif
//cGrupo := '('+cGrupo+')'
cQuery := " Select C2_NUM,  C2_PRODUTO, B1_DESC, C2_QUANT, C2_QTDM2, D3_COD, D3_QUANT, D3_CUSTO1, D3_LOCAL, "
cQuery += "	CASE B1_TPCLASS "
cQuery += "	When 'CT' Then 'CROMO T.TINTA' "
cQuery += "	When 'FT' Then 'CROMO FREE T.TINTA' "
cQuery += " When 'CR' Then 'CROMO' "
cQuery += "	When 'CF' Then 'CROMO FREE' "
cQuery += "	When 'CV' Then 'CROMO VOLANTE' "
cQuery += "	Else 'SEM CLASSIFIC' "
cQuery += "	end as B1_TPCLASS "
cQuery += "	from SC2010 SC2, SD3010 SD3, SB1010 SB1 " 
cQuery += "	where SC2.D_E_L_E_T_ = ' ' and SD3.D_E_L_E_T_ = ' ' and SB1.D_E_L_E_T_ = ' ' " 
//		and B1_TPCLASS <> '  ' 
cQuery += " and C2_NUM = Substring(D3_OP,1,6) " 
cQuery += " and C2_PRODUTO = B1_COD " 
cQuery += " and C2_FILIAL = D3_FILIAL " 
cQuery += "	and D3_FILIAL = '"+xFilial("SD3")+"' " 
cQuery += " and C2_FILIAL = '"+xFilial("SC2")+"' " 
cQuery += " and Substring(D3_COD,1,3)<> 'MOD' " 
cQuery += " and D3_LOCAL between '"+mv_par08+"' and '"+mv_par09+"' "
cQuery += " and D3_GRUPO in ('"+cGrupo+"') " //%Exp:cGrupo%
cQuery += " and D3_EMISSAO between  '"+dtos(mv_par01)+"' and '"+dtos(mv_par02)+ "' " 
cQuery += " and C2_PRODUTO between '"+mv_par04+"' and '"+mv_par05+"' " 
cQuery += " and C2_NUM between '"+mv_par06+"' and '"+mv_par07+"' " 
if mv_par10 == 1
	cQuery += " order by C2_PRODUTO " 
else
	cQuery += " order by C2_NUM " 
endif

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPQ" ,.F.,.T.)


ncounti:= 0
ncounta:= 0
ncusto := 0
if mv_par10 == 1
	do while TMPQ->(!eof())
		if !TMP->(dbSeek(TMPQ->C2_PRODUTO))
			Reclock("TMP",.T.)
			TMP->C2_PRODUTO		:= TMPQ->C2_PRODUTO
			TMP->B1_DESC   	 	:= TMPQ->B1_DESC   
			TMP->C2_QUANT		:= TMPQ->C2_QUANT
			TMP->C2_QTDM2 		:= TMPQ->C2_QTDM2
			TMP->D3_QUANT 		:= TMPQ->D3_QUANT
			TMP->D3_CUSTO 		:= TMPQ->D3_CUSTO1
			TMP->B1_TPCLASS		:= TMPQ->B1_TPCLASS
			nCusto+= TMPQ->D3_CUSTO1
			Msunlock("TMP")
			ncounti++
		else
			Reclock("TMP",.F.)
			TMP->C2_QUANT		+= TMPQ->C2_QUANT
			TMP->C2_QTDM2 		+= TMPQ->C2_QTDM2
			TMP->D3_QUANT 		+= TMPQ->D3_QUANT
			TMP->D3_CUSTO 		+= TMPQ->D3_CUSTO1
//			nCusto+= TMPQ->D3_CUSTO1			
			Msunlock("TMP")
			ncounta++
		endif
	TMPQ->(dbSkip())
	enddo 
else
	do while TMPQ->(!eof())
		Reclock("TMP",.T.)
		TMP->C2_NUM 		:= TMPQ->C2_NUM
		TMP->D3_COD			:= TMPQ->D3_COD
		TMP->D3_LOCAL       := TMPQ->D3_LOCAL
		TMP->C2_PRODUTO		:= TMPQ->C2_PRODUTO
		TMP->B1_DESC   	 	:= TMPQ->B1_DESC   
		TMP->C2_QUANT		:= TMPQ->C2_QUANT
		TMP->C2_QTDM2 		:= TMPQ->C2_QTDM2
		TMP->D3_QUANT 		:= TMPQ->D3_QUANT
		TMP->D3_CUSTO 		:= TMPQ->D3_CUSTO1
		TMP->B1_TPCLASS		:= TMPQ->B1_TPCLASS
		ncounti++
		MsUnLock('TMP')
		TMPQ->(dbSkip())
	enddo
endif


alert('Inserido -> '+cValToChar(nCounti)+' alterado -> '+cValToChar(ncounta)+' Custo Total-> '+cValTochar(nCusto))
//TMP->(dbCloseArea())
TMP->(dbGotop())
TMPQ->(dbGotop())

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
oReport := TReport():New(cPerg,"Custo de Produto Quimico por Produto Acabado",cPerg,{|oReport| Printreport(oReport)},;
				"Custo de Produto Quimico por Produto ")
//Cria a Seção do relatorio
oSection1 := TRSection():New(oReport,"Custo de Produto Quimico",{"TMP"},/*Ordem*/)

if mv_par10 == 1
			TMP->C2_PRODUTO		:= TMPQ->C2_PRODUTO
			TMP->B1_DESC   	 	:= TMPQ->B1_DESC   
			TMP->C2_QUANT		+= TMPQ->C2_QUANT
			TMP->C2_QTDM2 		+= TMPQ->C2_QTDM2
			TMP->D3_QUANT 		+= TMPQ->D3_QUANT
			TMP->D3_CUSTO 		+= TMPQ->D3_CUSTO1
			TMP->B1_TPCLASS		+= TMPQ->B1_TPCLASS
	//Cria as celulas do relatório 
	TRCell():New(oSection1,"C2_PRODUTO"		,"TMP","Prod.Acab"		,"@!"					,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"B1_DESC"		,"TMP","Descr.Produto"  ,"@!"					,50,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"C2_QUANT"		,"TMP","Qtde Produz" 	,"@E 999,999,999.99"	,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"C2_QTDM2"		,"TMP","Qtde M2"  	 	,"@E 999,999,999.99"	,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D3_QUANT"		,"TMP","Qtde PQ"		,"@E 999,999,999.99"	,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D3_CUSTO"		,"TMP","Custo PQ"		,"@E 999,999,999.99"	,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"B1_TPCLASS"     ,"TMP","Tipo Class"   	,"@!" 					,20,/*TAMPIXEL*/,/*BLOCO*/)

else
		TMP->C2_NUM 		:= TMPQ->C2_NUM
		TMP->D3_COD			:= TMPQ->D3_COD
		TMP->D3_LOCAL       := TMPQ->D3_LOCAL
		TMP->C2_PRODUTO		:= TMPQ->C2_PRODUTO
		TMP->B1_DESC   	 	:= TMPQ->B1_DESC   
		TMP->C2_QUANT		:= TMPQ->C2_QUANT
		TMP->C2_QTDM2 		:= TMPQ->C2_QTDM2
		TMP->D3_QUANT 		:= TMPQ->D3_QUANT
		TMP->D3_CUSTO 		:= TMPQ->D3_CUSTO1
		TMP->B1_TPCLASS		:= TMPQ->B1_TPCLASS

	//Cria as celulas do relatório 
	TRCell():New(oSection1,"C2_NUM"			,"TMP","Ord.Prod"  		,"@!"					,06,/*TAMPIXEL*/,/*BLOCO*/)	
	TRCell():New(oSection1,"C2_PRODUTO"		,"TMP","Prod.Acab"		,"@!"					,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"B1_DESC"		,"TMP","Descr.Produto"  ,"@!"					,50,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"C2_QUANT"		,"TMP","Qtde Produz" 	,"@E 999,999,999.99"	,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"C2_QTDM2"		,"TMP","Qtde M2"  	 	,"@E 999,999,999.99"	,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D3_COD"		    ,"TMP","Prod.Quim" 		,"@!"					,15,/*TAMPIXEL*/,/*BLOCO*/)	
	TRCell():New(oSection1,"D3_LOCAL"		,"TMP","Local"  		,"@!"					,02,/*TAMPIXEL*/,/*BLOCO*/)	
	TRCell():New(oSection1,"D3_QUANT"		,"TMP","Qtde PQ"		,"@E 999,999,999.99"	,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D3_CUSTO"		,"TMP","Custo PQ"		,"@E 999,999,999.99"	,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"B1_TPCLASS"     ,"TMP","Tipo Class"   	,"@!" 					,20,/*TAMPIXEL*/,/*BLOCO*/)
endif	

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
PutSx1(cPerg,"01","Periodo de                    ?"," "," ","mv_ch1","D",8,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo inicial"},{"Informe o periodo inicial"},{"Informe o periodo inicial"})
PutSx1(cPerg,"02","Periodo ate                   ?"," "," ","mv_ch2","D",8,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo final"},{"Informe o periodo final"},{"Informe o periodo final"})
PutSx1(cPerg,"03","Grupos                        ?"," "," ","mv_ch3","C",40,0,0,"G","","   ","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe os grupos a serem filtrados, separado por ; ou /, sem espaços entre os grupos"},{"Informe os grupos a serem filtrados, separado por ; ou /"},{"Informe os grupos a serem filtrados, separado por ; ou /"})
PutSx1(cPerg,"04","Produto de                    ?"," "," ","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto inicial"},{"Informe o produto inicial"},{"Informe o produto inicial"})
PutSx1(cPerg,"05","Produto ate                   ?"," "," ","mv_ch5","C",15,0,0,"G","","SB1","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto final"},{"Informe o produto final"},{"Informe o produto final"})
PutSx1(cPerg,"06","Ordem de Producao de          ?"," "," ","mv_ch6","C",6,0,0, "G","","SC2","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a OP Inicial        "},{"Informe a OP Inicial        "},{"Informe a OP Inicial        "})
PutSx1(cPerg,"07","Ordem de Producao ate         ?"," "," ","mv_ch7","C",6,0,0, "G","","SC2","","","mv_par07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a OP Final        "},{"Informe a OP Final        "},{"Informe a OP Final        "})
PutSx1(cPerg,"08","Armazem de                    ?"," "," ","mv_ch8","C",2,0,0, "G","","   ","","","mv_par08"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o Armazem inicial           "},{"Informe o Armazem inicial           "},{"Informe o Armazem inicial           "})
PutSx1(cPerg,"09","Armazem ate                   ?"," "," ","mv_ch9","C",2,0,0, "G","","   ","","","mv_par09"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o Armazem Final           "},{"Informe o Armazem final           "},{"Informe o Armazem final           "})
PutSx1(cPerg,"10","Imprimir Resumo               ?"," "," ","mv_cha","N",1,0,2, "C","","   ","","","mv_par10","Sim","Si","Yes", " ","Nao","No","No"," "," "," ", " "," "," "," ",	" ","",{"Imprimir resumo ao final do relatorio"},{"Imprimir resumo ao final do relatorio"},{"Imprimir resumo ao final do relatorio"})
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
