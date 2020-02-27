#INCLUDE "Protheus.ch"  

///////////////////////////////////////////////////////////////////////////////
//Relatorio de Transferencias entre filiais
//Gera a soma das transferencias entre filiais dentro do mes/ano selecionado
//apresentando informacoes 
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br - 02-12-2011
///////////////////////////////////////////////////////////////////////////////

User Function AGF_TRFFIL()
Local cQuery := ""
Private cPerg := PADR("AG_TRFFIL",10)
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
AADD(aTRB,{"LOJA" 		    , "C", 02, 0 } )
AADD(aTRB,{"GRUPO" 		    , "C", 04, 0 } )
AADD(aTRB,{"COD_ORI" 	    , "C", 15, 0 } )
AADD(aTRB,{"DESCR" 		    , "C", 50, 0 } )
AADD(aTRB,{"UNMED"	        , "C", 02, 0 } )
AADD(aTRB,{"TIPO"     		, "C", 02, 0 } )
AADD(aTRB,{"QTDEORI" 	    , "N", 15, 2 } )
AADD(aTRB,{"VLRUNORI" 	    , "N", 15, 2 } )
AADD(aTRB,{"VLRTTORI" 	    , "N", 15, 2 } )
AADD(aTRB,{"CUSTORI"        , "N", 15, 0 } )
AADD(aTRB,{"COD_DEST"       , "C", 15, 0 } )
AADD(aTRB,{"QTDEDST" 	    , "N", 15, 2 } )
AADD(aTRB,{"VLRUNDST" 	    , "N", 15, 2 } )
AADD(aTRB,{"VLRTTDST" 	    , "N", 15, 2 } )
AADD(aTRB,{"CUSTDST"        , "N", 15, 0 } )
AADD(aTRB,{"CUSTDIF"        , "N", 15, 0 } )



ctrTRB := CriaTrab(aTRB, .T.)
dbUseArea(.T.,,ctrTRB,"TRB",.F.,.F.)
INDEX ON LOJA+COD_ORI TO &ctrTRB

if Select("TMP") > 0
	dbSelectArea("TMP")
	TMP->(dbCloseArea())
endif

BeginSql Alias "TMP"
	%NoParser%                               
		Select D2_LOJA, D2_GRUPO, D2_COD, B1_DESC, B1_UM, B1_TIPO, Sum(D2_QUANT) D2_QUANT, Sum(D2_TOTAL) / Sum(D2_QUANT) PRCUNIT, 
		Sum(D2_TOTAL) D2_TOTAL, SUM(D2_CUSTO1) D2_CUSTO
		from %Table:SD2% SD2, %Table:SB1% SB1
		where SD2.%NotDel% and SB1.%NotDel%
		and D2_COD = B1_COD
		and Substring(D2_EMISSAO,1,4)= %Exp:mv_par01%
		and Substring(D2_EMISSAO,5,2)= %Exp:mv_par02%
		and D2_FILIAL = %Exp:xFilial("SD2")%
		and D2_CLIENTE = '000001' 
//		if mv_par03 <> '**' .and. mv_par03 <> space(2) 
//		    and D2_LOJA = %Exp:mv_par03%		
//		endif
		and D2_TIPO ='N' 
		group by D2_LOJA, D2_GRUPO, D2_COD, B1_DESC, B1_UM, B1_TIPO
		order by D2_COD
EndSql

dbSelectArea('TMP')
dbGotop()

do while TMP->(!eof())
		Reclock("TRB",.T.)
		TRB->LOJA			:= TMP->D2_LOJA
		TRB->GRUPO   	 	:= TMP->D2_GRUPO
		TRB->COD_ORI  		:= TMP->D2_COD
		TRB->DESCR   		:= TMP->B1_DESC
		TRB->UNMED  		:= TMP->B1_UM
		TRB->TIPO  			:= TMP->B1_TIPO
		TRB->QTDEORI  		:= TMP->D2_QUANT
		TRB->VLRUNORI  		:= TMP->PRCUNIT
		TRB->VLRTTORI  		:= TMP->D2_TOTAL
		TRB->CUSTORI  		:= TMP->D2_CUSTO		
		TRB->COD_DEST     	:= TMP->D2_COD
		TRB->QTDEDST  		:= 0
		TRB->VLRUNDST    	:= 0
		TRB->VLRTTDST  		:= 0
		TRB->CUSTDST   		:= 0
		TRB->CUSTDIF 		:= 0
		Msunlock("TRB")
	TMP->(dbSkip())
enddo 
//TMP->(dbCloseArea())
//Alert('Total de nota-> '+cValToChar(nCount))
TRB->(dbgotop())


if Select("TMP") > 0
	dbSelectArea("TMP")
	TMP->(dbCloseArea())
endif


BeginSql Alias "TMP"
	%NoParser%                               
                                
		Select D1_FILIAL, D1_COD, Sum(D1_QUANT) D1_QUANT, Sum(D1_TOTAL) / Sum(D1_QUANT) PRCUNIT, Sum(D1_TOTAL) D1_TOTAL, Sum(D1_CUSTO) D1_CUSTO
		from %Table:SD1% SD1, %Table:SB1% SB1
		where SD1.%NotDel% and SB1.%NotDel% 
		and D1_COD = B1_COD
		and Substring(D1_EMISSAO,1,4)= %Exp:mv_par01%
		and Substring(D1_EMISSAO,5,2)= %Exp:mv_par02%
//		if mv_par03 <> '**' .and. mv_par03 <> space(2) 
//			and D1_FILIAL = %Exp:mv_par03%
//		endif
		and D1_FORNECE = '000148' and D1_LOJA = %Exp:xFilial("SD1")%
		and D1_TIPO ='N' 
		group by D1_FILIAL, D1_COD
		order by D1_FILIAL, D1_COD

EndSql

do while TMP->(!eof())
	dbSelectArea('TRB')
	TRB->(dbGotop())
	if TRB->(dbSeek(TMP->(D1_FILIAL+D1_COD)))
		Reclock("TRB",.F.)
		TRB->QTDEDST  		:= TMP->D1_QUANT
		TRB->VLRUNDST    	:= TMP->PRCUNIT
		TRB->VLRTTDST  		:= TMP->D1_TOTAL
		TRB->CUSTDST   		:= TMP->D1_CUSTO
		TRB->CUSTDIF 		:= TRB->CUSTORI - TMP->D1_CUSTO
		Msunlock("TRB")
	endif
	TMP->(dbSkip())
enddo 




If TRepInUse()
	//Gera as definicoes do relatorio
	oReport := ReportDef()
	//Monta interface com o usuário
	oReport:PrintDialog()
endif
//Retorno da funcao
TRB->(dbCloseArea())
Ferase(ctrTRB+".dbf")
Ferase(ctrTRB+".cdx")

Return()

//-------------------------
Static Function ReportDef()
//-------------------------
//Variaveis locais da funcao
Local oReport 	:= ""
Local oBreak	:= ""
Local oSection1	:= ""
//Inicio da funcao
//Monta o objeto do relatorio
oReport := TReport():New(cPerg,"Relacao de Transferencia entre filiais",cPerg,{|oReport| Printreport(oReport)},;
				"Transferencia entre filiais ")
//Cria a Seção do relatorio
oSection1 := TRSection():New(oReport,"Section ?????",{"TRB"},/*Ordem*/)

//Cria as celulas do relatório 
TRCell():New(oSection1,"GRUPO"		,"TRB","PLANO"   		,"@!"					,04,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"COD_ORI"	,"TRB","CODIGO"   		,"@!"					,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"DESCR"		,"TRB","DESCRICAO" 	    ,"@!"					,50,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"UNMED"		,"TRB","UN.MED" 	 	,"@!"					,02,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"TIPO"		,"TRB","TIPO"   		,"@!"					,02,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"QTDEORI"	,"TRB","QTDE" 			,"@E 999,999.999"		,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"VLRUNORI"	,"TRB","VLR.UNIT"		,"@E 999,999.999"		,15,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection1,"VLRTTORI"	,"TRB","VLR.TOTAL"		,"@E 999,999.999"		,15,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection1,"CUSTORI"	,"TRB","CUSTO TOTAL"	,"@E 999,999.999"		,15,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection1,"LOJA"		,"TRB","FIL.DEST"  		,"@!"					,02,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"COD_DEST"  ,"TRB","COD.DEST"	    ,"@!"					,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"QTDEDST"	,"TRB","QTDE" 			,"@E 999,999.999"		,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"VLRUNDST"	,"TRB","VLR.UNIT"		,"@E 999,999.999"		,15,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection1,"VLRTTDST"	,"TRB","VLR.TOTAL"		,"@E 999,999.999"		,15,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection1,"CUSTDST"	,"TRB","CUSTO TOTAL"	,"@E 999,999.999"		,15,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection1,"CUSTDIF"	,"TRB","DIF.CUSTO"		,"@E 999,999.999"		,15,/*lPixel*/,/*CodeBlock*/)


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