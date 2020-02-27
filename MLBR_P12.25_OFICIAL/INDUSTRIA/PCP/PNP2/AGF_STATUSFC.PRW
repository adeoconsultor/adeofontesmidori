#INCLUDE "Protheus.ch"  

///////////////////////////////////////////////////////////////////////////////
//Relatorio de Fichas de Corte em Aberto - solicitado via chamado HDi 004180
//Gera Relatorio das fichas referentes aos planos que estão em aberto na produção.
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br - 02-12-2011
///////////////////////////////////////////////////////////////////////////////

User Function AGF_STATUSFC()
Local cQuery := ""
Private cPerg := PADR("STATFC",10)
if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
endif
Pergunte(cPerg,.T.)      


if Select("RFC") > 0 
	dbSelectArea("RFC")
	RFC->(dbCloseArea())
endif
//Arquivo temporario da funcao para geracao do relatorio
aRFC	:= {}
AADD(aRFC,{"PLANO" 		    , "C", 20, 0 } )
AADD(aRFC,{"NUMOP" 		    , "C", 06, 0 } )
AADD(aRFC,{"NUMFC"          , "C", 20, 0 } )
AADD(aRFC,{"MATERIAL" 	    , "C", 15, 0 } )
AADD(aRFC,{"DESCMAT"	    , "C", 50, 0 } )
AADD(aRFC,{"GRUPO"  	   	, "C", 04, 0 } )
AADD(aRFC,{"FASE" 	    	, "C", 20, 2 } )
AADD(aRFC,{"DTFICHA" 	    , "C", 10, 0 } )
AADD(aRFC,{"M2PAD" 		    , "N", 15, 2 } )
AADD(aRFC,{"M2TOTAL"        , "N", 15, 2 } )
ctrRFC := CriaTrab(aRFC, .T.)
dbUseArea(.T.,,ctrRFC,"RFC",.F.,.F.)
INDEX ON PLANO + NUMOP + NUMFC TO &ctrRFC

if Select("TMP") > 0
	dbSelectArea("TMP")
	TMP->(dbCloseArea())
endif

BeginSql Alias "TMP"
	%NoParser%                               
		Select Z3_PLANO, Z3_NUMOP, Z3_NUMFC, Z3_MATERIA, B1_DESC, B1_GRUPO,
			CASE Max(Z7_FASE)		
		        WHEN '00' THEN 'SEPARACAO COURO'		
        		WHEN '01' THEN 'RISCAGEM'		
		        WHEN '02' THEN 'CORTE'		
				WHEN '03' THEN 'PRIMEIRA INSPECAO' 
				WHEN '04' THEN 'SEGUNDA INSPECAO' 
        		WHEN '05' THEN 'EXPEDICAO A APONTAR'		
				ELSE 'EXPEDICAO'
			END FASE,		
			Substring(Z3_DTFICHA,7,2)+'/'+Substring(Z3_DTFICHA,5,2)+'/'+Substring(Z3_DTFICHA,1,4) DTFICHA,		
			CASE Max(Z7_FASE)		
				When '00' THEN Sum(Z3_M2TOT)/1	
				When '01' THEN Sum(Z3_M2TOT)/2	
				When '02' THEN Sum(Z3_M2TOT)/3	
				When '03' THEN Sum(Z3_M2TOT)/4	
				When '04' THEN Sum(Z3_M2TOT)/5	
				When '05' THEN Sum(Z3_M2TOT)/6	
			END  M2PAD,		
			CASE Max(Z7_FASE)		
				When '00' THEN Sum(Z3_SLDM2)/1	
				When '01' THEN Sum(Z3_SLDM2)/2	
				When '02' THEN Sum(Z3_SLDM2)/3	
				When '03' THEN Sum(Z3_SLDM2)/4	
				When '04' THEN Sum(Z3_SLDM2)/5	
				When '05' THEN Sum(Z3_SLDM2)/6	
			END  TOTAL		
		from %Table:SZ3% SZ3, %Table:SB1% SB1, %Table:SZ7% SZ7		
		where SZ3.%NotDel%  and SB1.%NotDel%  and SZ7.%NotDel%
		and Z3_MATERIA = B1_COD		
		and Z3_STATUS = 'A'		
		and Z7_NUMFC = Z3_NUMFC		
		and Z7_FASE <> '06' 		
		and Z3_DTFICHA >= %Exp:mv_par01%
		and Z3_NUMOP between %Exp:mv_par02% and %Exp:mv_par03%
		group By Z3_PLANO, Z3_NUMOP, Z3_NUMFC, Z3_MATERIA, B1_DESC, B1_GRUPO,		
		Z3_DTFICHA
		order by B1_GRUPO, Substring(Z3_DTFICHA,7,2)+'/'+Substring(Z3_DTFICHA,5,2)+'/'+Substring(Z3_DTFICHA,1,4)
EndSql

do while TMP->(!eof())
		Reclock("RFC",.T.)
		RFC->PLANO    := TMP->Z3_PLANO
		RFC->NUMOP    := TMP->Z3_NUMOP   
		RFC->NUMFC    := TMP->Z3_NUMFC
		RFC->MATERIAL := TMP->Z3_MATERIA
		RFC->DESCMAT  := TMP->B1_DESC
		RFC->GRUPO    := TMP->B1_GRUPO
		RFC->FASE     := TMP->FASE
		RFC->DTFICHA  := TMP->DTFICHA
		RFC->M2PAD    := TMP->M2PAD
		RFC->M2TOTAL  := TMP->TOTAL
		Msunlock("RFC")
	TMP->(dbSkip())
enddo 
//TMP->(dbCloseArea())
RFC->(dbgotop())
TMP->(dbgotop())

If TRepInUse()
	//Gera as definicoes do relatorio
	oReport := ReportDef()
	//Monta interface com o usuário
	oReport:PrintDialog()
endif
//Retorno da funcao
RFC->(dbCloseArea())
Ferase(ctrRFC+".dbf")
Ferase(ctrRFC+".cdx")

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
oReport := TReport():New(cPerg,"Relacao de fichas em aberto",cPerg,{|oReport| Printreport(oReport)},;
				"Fichas de produção em aberto - PNP2 ")
//Cria a Seção do relatorio
oSection1 := TRSection():New(oReport,"Relação de Fichas",{"RFC"},/*Ordem*/)

/*		RFC->PLANO    := TMP->Z3_PLANO
		RFC->NUMOP    := TMP->Z3_NUMOP   
		RFC->NUMFC    := TMP->Z3_NUMFC
		RFC->MATERIAL := TMP->Z3_MATERIA
		RFC->DESCMAT  := TMP->B1_DESC
		RFC->GRUPO    := TMP->B1_GRUPO
		RFC->FASE     := TMP->FASE
		RFC->DTFICHA  := TMP->DTFICHA
		RFC->M2PAD    := TMP->M2PAD
		RFC->M2TOTAL  := TMP->TOTAL
  */

//Cria as celulas do relatório 
TRCell():New(oSection1,"PLANO"		,"RFC","PLANO"   			,"@!"					,20,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"NUMOP"		,"RFC","Num.OP."   			,"@!"					,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"NUMFC"		,"RFC","Num.Ficha"   	    ,"@!"					,20,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"MATERIAL"	,"RFC","Material"  			,"@!"					,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"DESCMAT"	,"RFC","Descr.Material"   	,"@!"					,50,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"GRUPO"		,"RFC","Grupo" 				,"@!"					,04,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"FASE"		,"RFC","FASE"				,"@!"					,20,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection1,"DTFICHA"    ,"RFC","Dt.Ficha"	    	,"@!" 					,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"M2PAD"		,"RFC","M2 Padrao"			,"@E 999,999.999"		,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"M2TOTAL"   	,"RFC","M2 Total"			,"@E 999,999.999"		,15,/*TAMPIXEL*/,/*BLOCO*/)


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
AADD(aRegs,{cPerg,"01","A Partir de "			,"","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ord.Produçao De"		,"","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC2","","","",""})
AADD(aRegs,{cPerg,"03","Ord.Produçao Até" 		,"","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SC2","","","",""})

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
