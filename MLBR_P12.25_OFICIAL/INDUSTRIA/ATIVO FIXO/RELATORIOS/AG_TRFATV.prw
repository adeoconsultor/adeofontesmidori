#INCLUDE "Protheus.ch"  

///////////////////////////////////////////////////////////////////////////////
//Relatorio de Fichas de Corte em Aberto - solicitado via chamado HDi 004180
//Gera Relatorio das fichas referentes aos planos que estão em aberto na produção.
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br - 02-12-2011
///////////////////////////////////////////////////////////////////////////////

User Function AG_TRFATV()
Local cQuery := ""
Private cPerg := PADR("AG_TRFATF",10)
if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
endif
Pergunte(cPerg,.T.)      


if Select("TMPTRF") > 0 
	dbSelectArea("TMPTRF")
	TMPTRF->(dbCloseArea())
endif
//Arquivo temporario da funcao para geracao do relatorio
aTRF	:= {}
AADD(aTRF,{"FILIAL" 	    , "C", 02, 0 } )
AADD(aTRF,{"NOTA" 		    , "C", 09, 0 } )
AADD(aTRF,{"CCUSTO" 	    , "C", 20, 0 } )
AADD(aTRF,{"SERIE"          , "C", 03, 0 } )
AADD(aTRF,{"DTEMISS" 	    , "C", 10, 0 } )
AADD(aTRF,{"ITEM"	    	, "C", 02, 0 } )
AADD(aTRF,{"PRODUTO"  	   	, "C", 15, 0 } )
AADD(aTRF,{"DESCPRD"    	, "C", 50, 0 } )
AADD(aTRF,{"FILDEST"    	, "C", 02, 0 } )
AADD(aTRF,{"DTCLASS"    	, "C", 10, 0 } )

ctrTRF := CriaTrab(aTRF, .T.)
dbUseArea(.T.,,ctrTRF,"TMPTRF",.F.,.F.)
INDEX ON FILIAL + NOTA + DTEMISS TO &ctrTRF

if Select("TMP") > 0
	dbSelectArea("TMP")
	TMP->(dbCloseArea())
endif
//alert('DATA-> '+dTos(mv_par01)) 
BeginSql Alias "TMP"
	%NoParser%                               
		Select D2_FILIAL, D2_DOC, D2_SERIE, 
		Substring(D2_EMISSAO,7,2)+'/'+Substring(D2_EMISSAO,5,2)+'/'+Substring(D2_EMISSAO,1,4) EMISSAO,
		D2_ITEM, D2_COD, B1_DESC, D2_LOJA 
		from %Table:SD2% SD2, %Table:SB1% SB1
		where SD2.%NotDel%  and SB1.%NotDel% 
		and D2_COD = B1_COD
		and Substring(D2_EMISSAO,1,6) between %Exp:substr(dtos(mv_par01),1,6)% and %Exp:substr(dtos(mv_par02),1,6)% 
		and D2_CF = '5552'
EndSql

do while TMP->(!eof())
	RecLock('TMPTRF',.T.)
	TMPTRF->FILIAL	:= TMP->D2_FILIAL
	TMPTRF->NOTA	:= TMP->D2_DOC
	TMPTRF->SERIE	:= TMP->D2_SERIE
	TMPTRF->DTEMISS := TMP->EMISSAO
	TMPTRF->ITEM	:= TMP->D2_ITEM
	TMPTRF->PRODUTO	:= TMP->D2_COD
	TMPTRF->DESCPRD	:= TMP->B1_DESC
	TMPTRF->FILDEST	:= TMP->D2_LOJA
    MsUnLock('TMPTRF')
	TMP->(dbSkip())
enddo
//TMP->(dbCloseArea())
TMPTRF->(dbgotop())
TMP->(dbgotop())

If TRepInUse()
	//Gera as definicoes do relatorio
	oReport := ReportDef()
	//Monta interface com o usuário
	oReport:PrintDialog()
endif
//Retorno da funcao
RFC->(dbCloseArea())
Ferase(ctrTRF+".dbf")
Ferase(ctrTRF+".cdx")

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
oReport := TReport():New(cPerg,"Relacao de transferencia de ativos",cPerg,{|oReport| Printreport(oReport)},;
				"Relação de transferencia de ativos")
//Cria a Seção do relatorio
oSection1 := TRSection():New(oReport,"Transferencia de ativos",{"TMPTRF"},/*Ordem*/)


//Cria as celulas do relatório 
TRCell():New(oSection1,"FILIAL"		,"TMPTRF","FILIAL"   		,"@!"					,02,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"NOTA"		,"TMPTRF","Nota Fiscal"   	,"@!"					,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"SERIE"		,"TMPTRF","Serie"   	    ,"@!"					,05,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"DTEMISS"	,"TMPTRF","Emissao"  		,"@!"					,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"ITEM"		,"TMPTRF","Item"   			,"@!"					,02,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"PRODUTO"	,"TMPTRF","Produto" 		,"@!"					,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"DESCPRD"	,"TMPTRF","Descricao"		,"@!"					,50,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection1,"FILDEST"    ,"TMPTRF","Destino"	    	,"@!" 					,02,/*TAMPIXEL*/,/*BLOCO*/)


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
AADD(aRegs,{cPerg,"01","Emissao de "			,"","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Emissao ate "			,"","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"02","Ord.Produçao De"		,"","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC2","","","",""})
//AADD(aRegs,{cPerg,"03","Ord.Produçao Até" 		,"","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SC2","","","",""})

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