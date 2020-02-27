#INCLUDE "Protheus.ch"  

///////////////////////////////////////////////////////////////////////////////
//Relatorio de Consumo mensal de Mao de Obra por Unidade
//Gera a soma das MODs consumidas por filial
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria anesio@anesio.com.br - 05-06-2014
///////////////////////////////////////////////////////////////////////////////

User Function AG_MODMES()

//If TRepInUse()
	//Gera as definicoes do relatorio
	oReport := ReportDef()
	//Monta interface com o usuário
	oReport:PrintDialog()
//endif

return


//-------------------------
Static Function ReportDef()
//-------------------------
//Variaveis locais da funcao
Local oReport 	:= ""
Local oBreak	:= ""
Local oSection1	:= ""
Local cQuery 	:= ""

Private cPerg := PADR("AG_MODMES",10)
if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
endif
Pergunte(cPerg,.T.)      

if Select("TRB") > 0 
	dbSelectArea("TRB")
	TRB->(dbCloseArea())
endif       


//Arquivo temporario da funcao para geracao do relatorio
aTRB	:= {}
AADD(aTRB,{"FILIAL" 	    , "C", 02, 0 } )
AADD(aTRB,{"COD_MOD" 	    , "C", 15, 0 } )
AADD(aTRB,{"QTDEMOD" 	    , "N", 15, 2 } )
AADD(aTRB,{"CUSTO" 		    , "N", 15, 2 } )

ctrTRB := CriaTrab(aTRB, .T.)
dbUseArea(.T.,,ctrTRB,"TRB",.F.,.F.)
INDEX ON FILIAL+COD_MOD TO &ctrTRB

if Select("TMP") > 0
	dbSelectArea("TMP")
	TMP->(dbCloseArea())
endif

BeginSql Alias "TMP"
	%NoParser%
	Select D3_FILIAL, D3_COD, Sum(D3_QUANT) QTDE, SUM(D3_CUSTO1) CUSTO
	from %table:SD3% SD3
	where SD3.%NotDel% 
	and Substring(D3_EMISSAO,1,4)=%Exp:mv_par01%
	and Substring(D3_EMISSAO,5,2)=%Exp:mv_par02%
	and Substring(D3_COD,1,3) ='MOD'
	and D3_CF = 'RE1'
	group by D3_FILIAL, D3_COD
	order by 1,2
EndSql

dbSelectArea('TMP')
dbGotop()

do while TMP->(!eof())
		Reclock("TRB",.T.)
		TRB->FILIAL			:= TMP->D3_FILIAL
		TRB->COD_MOD   	 	:= TMP->D3_COD
		TRB->QTDEMOD  		:= TMP->QTDE
		TRB->CUSTO   		:= TMP->CUSTO
		Msunlock("TRB")
	TMP->(dbSkip())
enddo 
//TMP->(dbCloseArea())
//Alert('Total de nota-> '+cValToChar(nCount))
TRB->(dbgotop())

//Retorno da funcao
//Monta o objeto do relatorio
oReport := TReport():New(cPerg,"Relacao de Consumo de Mão de Obra",cPerg,{|oReport| Printreport(oReport)},;
				"Relação de Consumo de Mão de obra mensal ")
//Cria a Seção do relatorio
oSection1 := TRSection():New(oReport,"Section ?????",{"TRB"},/*Ordem*/)


//Cria as celulas do relatório 
TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL"   		,"@!"					,04,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"COD_MOD"	,"TRB","CODIGO"   		,"@!"					,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"QTDEMOD"	,"TRB","QTDE MOD" 		,"@E 999,999,999.9999"		,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"CUSTO"		,"TRB","CUSTO MOD"		,"@E 999,999,999.99"		,15,/*lPixel*/,/*CodeBlock*/)


Ferase(ctrTRB+".dbf")
Ferase(ctrTRB+".cdx")


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
AADD(aRegs,{cPerg,"01","Informe o Ano"	,"","","mv_ch1","C",04,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Informe o mes"	,"","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"03","Filial Destino" ,"","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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