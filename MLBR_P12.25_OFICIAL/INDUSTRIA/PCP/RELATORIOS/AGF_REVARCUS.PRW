#INCLUDE "Protheus.ch"  

//////////////////////////////////////////////////////////////////////////////////////////
//Programa de averiguação de divergencias entre custo medio dos movimentos
//////////////////////////////////////////////////////////////////////////////////////////
//O usuário define via parametros quais os percentuais que deseja considerar na variacao
//Busca o custo médio do ultimo fechamento B9_CM1, compara com o custo médio atual B2_CM1
//Verifica a variação
//Depois faz uma busca movimento a movimento do item comparando com a variação do custo 
//B2_CM1 da tabela SB2. se tiver a maior do que o definido no parametro, guarda as informacoes
//num array para depois descarregar num no relatorio.
///////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br - 23-11-2011
///////////////////////////////////////////////////////////////////////////

User Function AGF_REVARCUS()
	Processa( {|lEnd| CalcVarCus(@lEnd)}, "Aguarde...","Calculando divergencias.", .T. )

return

static function CalcVarCus(lEnd)		
local dMvUlMes 	:= GetMv ('MV_ULMES') //busca o ultimo fechamento ocorrido por filial
local nVarCus   := 0 //Pega o percentual que o usuario informou no parametro
local cQB2		:= "" //Query para filtrar SB2
local aFiliais  := {}
local nItens    := 0
local cGrupo    := '' 
Local i
Private cPerg   := "AGF_VARCUS"
public nItTot   := 0
public aItens   := {}

//Alert('Variacao de custo...->'+cValToChar(nVarCus))

if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
endif
Pergunte(cPerg,.T.)      


//Arquivo temporario da funcao para geracao do relatorio
public aTMP	:= {}                               
AADD(aTMP,{"D3_EMISSAO"	    , "D", 08, 0 } )
AADD(aTMP,{"D3_COD"        	, "C", 06, 0 } )
AADD(aTMP,{"D3_DESC"       	, "C", 50, 0 } )
AADD(aTMP,{"D3_DOC"   		, "C", 10, 0 } )
AADD(aTMP,{"D3_TM" 	    	, "C", 03, 0 } )
AADD(aTMP,{"D3_CF"  		, "C", 03, 0 } )
AADD(aTMP,{"D3_GRUPO"		, "C", 04, 0 } )
AADD(aTMP,{"D3_LOCAL"  	   	, "C", 02, 0 } )
AADD(aTMP,{"D3_NUMSEQ"      , "C", 06, 0 } )
AADD(aTMP,{"D3_OP"			, "C", 12, 0 } )
AADD(aTMP,{"D3_UM"			, "C", 02, 0 } )
AADD(aTMP,{"D3_QTDE"		, "N", 15, 6 } )
AADD(aTMP,{"D3_CUSTO"		, "N", 15, 6 } )
AADD(aTMP,{"D3_CUSTMOV"     , "N", 15, 6}  ) 
AADD(aTMP,{"D3_VARIAC"      , "N", 15, 2}  ) 


ctrTMP := CriaTrab(aTMP, .T.)
dbUseArea(.T.,,ctrTMP,"TMP",.F.,.F.)
INDEX ON D3_GRUPO + D3_DESC to &ctrTMP

nVarCus := mv_par01                                            

//Organiza os grupos que o usuario selecionou no parametro para ser entendido pela query                   
if cGrupo <> space(40)
	for i:=1 to 40
		if Substr(mv_par02,i,1) == ';' .or. Substr(mv_par02,i,1) == '/'
			cGrupo:= cGrupo+"','"
		else
			cGrupo:= cGrupo+Substr(mv_par02,i,1)
		endif
		if Substr(mv_par02,i,1) == " "
			i:= 40
		endif
	next
endif


	incProc("Calculando saldo produto...")



	if Select("TRBB2") > 0
		dbSelectArea("TRBB2")
		dbCloseArea()
	endif
	
	cQB2 := " SELECT B2_COD, B2_LOCAL, B2_CM1 FROM SB2010 SB2, SB1010 SB1 "
	cQB2 += " WHERE SB2.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' "
	cQB2 += " AND B2_FILIAL = '"+xFilial('SB2')+"' AND B1_FILIAL = '"+xFilial('SB1')+"' "
	cQB2 += " AND B2_COD = B1_COD "
	if Substr(mv_par02,1,4) <> space(4)
		cQB2 += " AND B1_GRUPO in ('"+cGrupo+"') " 
	else
		cQB2 += " AND B1_GRUPO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
	endif
	cQB2 += " AND B2_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQB2 += " AND B2_LOCAL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND Substring(B2_COD,1,3) <> 'MOD' "
	
	dbUseArea(.T.,"TOPCONN", TcGenQry(,,cQB2), "TRBB2",.T.,.T.)
	dbSelectArea("TRBB2")                               
	ProcRegua( reccount() )
//	Alert('Consulta realizada.......Calcular produto...')
	dbGotop()
	while !TRBB2->(eof())
		U_FiltraB9B2(TRBB2->B2_COD, TRBB2->B2_LOCAL, dMvUlMes, nVarCus, TRBB2->B2_CM1, cFilAnt)
		U_FiltraD1(TRBB2->B2_COD, TRBB2->B2_LOCAL, dMvUlMes, nVarCus, TRBB2->B2_CM1, cFilAnt)
		U_FiltraD2(TRBB2->B2_COD, TRBB2->B2_LOCAL, dMvUlMes, nVarCus, TRBB2->B2_CM1, cFilAnt)
		U_FiltraD3(TRBB2->B2_COD, TRBB2->B2_LOCAL, dMvUlMes, nVarCus, TRBB2->B2_CM1, cFilAnt)
		TRBB2->(dbSkip())          
		incProc("Calculando produto "+Substr(TRBB2->B2_COD,1,6))
	enddo                          
 

for i:= 1 to len(aItens)
	RecLock("TMP",.T.)
		TMP->D3_COD			:= aItens[i][1]
		TMP->D3_DESC		:= aItens[i][2]
		TMP->D3_DOC			:= aItens[i][3]
		TMP->D3_EMISSAO 	:= cTod(aItens[i][4])
		TMP->D3_LOCAL		:= aItens[i][5]
		TMP->D3_TM 			:= aItens[i][6]
		TMP->D3_CF			:= aItens[i][7]

		TMP->D3_GRUPO		:= Posicione('SB1',1,xFilial('SB1')+aItens[i][1],'B1_GRUPO')
//		TMP->D3_NUMSEQ		:= aItens[i][]
//		TMP->D3_OP			:= aItens[i][10]
//		TMP->D3_UM			:= aItens[i][11]
		TMP->D3_QTDE		:= aItens[i][8]
		TMP->D3_CUSTO		:= aItens[i][9]
		TMP->D3_CUSTMOV     := aItens[i][10]
		TMP->D3_VARIAC      := aItens[i][11]*100
	MsUnLock("TMP")

next i	
if len(aItens) > 0 
	If TRepInUse()
		//Gera as definicoes do relatorio
		oReport := ReportDef()
		//Monta interface com o usuário
		oReport:PrintDialog()
	endif
	//Retorno da funcao
else
	Alert('Não existem informações a serem impressas....')
endif
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

		TMP->D3_COD			:= TMP->D3_COD
		TMP->D3_DESC		:= TMP->D3_DESC
		TMP->D3_DOC			:= TMP->D3_DOC
		TMP->D3_EMISSAO 	:= TMP->D3_EMISSAO
		TMP->D3_LOCAL		:= TMP->D3_LOCAL
		TMP->D3_TM 			:= TMP->D3_TM
		TMP->D3_CF			:= TMP->D3_CF
		TMP->D3_GRUPO		:= TMP->D3_GRUPO
		TMP->D3_QTDE		:= TMP->D3_QTDE
		TMP->D3_CUSTO		:= TMP->D3_CUSTO
		TMP->D3_CUSTMOV     := TMP->D3_CUSTMOV
		TMP->D3_VARIAC      := TMP->D3_VARIAC


	//Cria as celulas do relatório 
	TRCell():New(oSection1,"D3_COD"			,"TMP","Cod.Prod"		,"@!"					,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D3_DESC"		,"TMP","Descr.Produto"  ,"@!"					,50,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D3_DOC"	    	,"TMP","Documento"      ,"@!"					,09,/*TAMPIXEL*/,/*BLOCO*/)	
	TRCell():New(oSection1,"D3_EMISSAO"		,"TMP","Emissao"		,"@!"					,08,/*TAMPIXEL*/,/*BLOCO*/)	
	TRCell():New(oSection1,"D3_LOCAL"		,"TMP","Local"			,"@!"					,02,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D3_TM"  		,"TMP","TM "	   		,"@!"					,03,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D3_CF"  		,"TMP","Cod.Fisc"		,"@!"					,03,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D3_GRUPO"		,"TMP","Grupo"			,"@!"					,04,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D3_QTDE"		,"TMP","           Qtde","@E 99,999.999999"		,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D3_CUSTO"       ,"TMP","      Custo Med","@E 99,999.999999"		,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D3_CUSTMOV"		,"TMP","      Custo Mov","@E 99,999.999999"       ,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D3_VARIAC"		,"TMP","       Variacao","@E 99,999.99%"	    ,15,/*TAMPIXEL*/,/*BLOCO*/)
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
//PutSx1(cPerg,"01","Data Inicial                  ?"," "," ","mv_ch1","D",8,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo inicial"},{"Informe o periodo inicial"},{"Informe o periodo inicial"})
//PutSx1(cPerg,"02","Data final                    ?"," "," ","mv_ch2","D",8,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo final"},{"Informe o periodo final"},{"Informe o periodo final"})
PutSx1(cPerg,"01","Perc.Variação                 ?"," "," ","mv_ch1","N",06,0,0,"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o percentual de variação"},{"Informe o percentual de variação"},{"Informe o percentual de variação"})
PutSx1(cPerg,"02","Grupos                        ?"," "," ","mv_ch2","C",40,0,0,"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe os grupos a serem filtrados, separado por ; ou /, sem espaços entre os grupos"},{"Informe os grupos a serem filtrados, separado por ; ou /"},{"Informe os grupos a serem filtrados, separado por ; ou /"})
PutSx1(cPerg,"03","Produto de                    ?"," "," ","mv_ch3","C",15,0,0,"G","","SB1","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto inicial"},{"Informe o produto inicial"},{"Informe o produto inicial"})
PutSx1(cPerg,"04","Produto ate                   ?"," "," ","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto final"},{"Informe o produto final"},{"Informe o produto final"})
PutSx1(cPerg,"05","Armazem Inicial               ?"," "," ","mv_ch5","C",02,0,0,"G","","   ","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o Armazem inicial           "},{"Informe o Armazem inicial           "},{"Informe o Armazem inicial           "})
PutSx1(cPerg,"06","Armazem Final                 ?"," "," ","mv_ch6","C",02,0,0,"G","","   ","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o Armazem final             "},{"Informe o Armazem final             "},{"Informe o Armazem final             "})
PutSx1(cPerg,"07","Grupo Inicial                 ?"," "," ","mv_ch7","C",04,0,0,"G","","SBM","","","mv_par07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o grupo inicial"},{"Informe o grupo inicial"},{"Informe o grupo inicial"})
PutSx1(cPerg,"08","Grupo Final                   ?"," "," ","mv_ch8","C",04,0,0,"G","","SBM","","","mv_par08"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o grupo final"},{"Informe o grupo final"},{"Informe o grupo final"})

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