#INCLUDE "Protheus.ch"  

///////////////////////////////////////////////////////////////////////////////
//Relatorio de planos embarcado - solicitado via chamado HDi 003611
//Gera o relatorio dos planos embarcados por periodo, modelo, plano e cliente
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br - 02-12-2011
///////////////////////////////////////////////////////////////////////////////

User Function AGF_RELEMB()
Local cQuery := ""
Private cPerg := PADR("RELEMB01",10)
if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
endif
Pergunte(cPerg,.T.)      


if Select("EMB") > 0 
	dbSelectArea("EMB")
	EMB->(dbCloseArea())
endif
//Arquivo temporario da funcao para geracao do relatorio
aEMB	:= {}
AADD(aEMB,{"PLANO" 		    , "C", 20, 0 } )
AADD(aEMB,{"SEQUENC" 	    , "C", 02, 0 } )
AADD(aEMB,{"MODELO" 	    , "C", 15, 0 } )
AADD(aEMB,{"DESCMOD"	    , "C", 50, 0 } )
AADD(aEMB,{"INVOICE"     	, "C", 20, 0 } )
AADD(aEMB,{"QTDEEMB" 	    , "N", 15, 2 } )
AADD(aEMB,{"QTDISPE" 	    , "N", 15, 2 } )
AADD(aEMB,{"SALDO" 		    , "N", 15, 2 } )
AADD(aEMB,{"CLIENTE"        , "C", 06, 0 } )
AADD(aEMB,{"LOJA"           , "C", 02, 0 } )
AADD(aEMB,{"NOMECLI"        , "C", 50, 0 } )
ctrEmb := CriaTrab(aEMB, .T.)
dbUseArea(.T.,,ctrEMB,"EMB",.F.,.F.)
INDEX ON PLANO + SEQUENC + MODELO TO &ctrEmb

if Select("TMP") > 0
	dbSelectArea("TMP")
	TMP->(dbCloseArea())
endif

BeginSql Alias "TMP"
	%NoParser%                               
	
	SELECT ZG_PLANO, ZG_SEQUEN, ZG_QTDEPLA, C2_NUM, C2_PRODUTO, C2_EMISSAO,
	ZG_DATA, ZG_DTEMBAR, ZG_EMBARCA, ZG_INVOICE, ZG_QTDEEMB, 
	ZG_NUMEMB, ZG_QTDISPE, C2_CLIENTE, C2_LOJA
	FROM %Table:SZG% SZG, %Table:SC2% SC2
	WHERE 
		ZG_FILIAL = C2_FILIAL
		and ZG_PLANO = C2_OPMIDO and                             
		C2_PRODUTO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND
		ZG_PLANO   BETWEEN %Exp:mv_par03% AND %Exp:mv_par04% AND 
		ZG_DTEMBAR BETWEEN %Exp:mv_par05% AND %Exp:mv_par06% AND 
		C2_CLIENTE BETWEEN %Exp:mv_par07% AND %Exp:mv_par08% AND
		C2_LOJA    BETWEEN %Exp:mv_par09% AND %Exp:mv_par10% AND
		SZG.%NotDel% and SC2.%NotDel%
		ORDER BY ZG_PLANO, ZG_SEQUEN
EndSql
ncount:= 0
do while TMP->(!eof())
		Reclock("EMB",.T.)
		EMB->PLANO    := TMP->ZG_PLANO
		EMB->SEQUENC  := TMP->ZG_SEQUEN
		EMB->MODELO   := TMP->C2_PRODUTO
		EMB->DESCMOD  := Posicione("SB1",1,xFilial("SB1")+TMP->C2_PRODUTO,"B1_DESC")
		EMB->INVOICE  := TMP->ZG_INVOICE
		EMB->QTDEEMB  := TMP->ZG_QTDEEMB
		EMB->QTDISPE  := TMP->ZG_QTDISPE
		EMB->CLIENTE  := TMP->C2_CLIENTE
		EMB->LOJA     := TMP->C2_LOJA
		EMB->NOMECLI  := Posicione("SA1",1,xFilial("SA1")+TMP->(C2_CLIENTE+C2_LOJA),"A1_NOME")
		EMB->SALDO    := 0
		Msunlock("EMB")
	TMP->(dbSkip())    
	ncount++
enddo 
//TMP->(dbCloseArea())
EMB->(dbgotop())
if ncount == 0
	Alert('Não existe informacoes com os parametros utilizados...')
	return()
endif

If TRepInUse()
	//Gera as definicoes do relatorio
	oReport := ReportDef()
	//Monta interface com o usuário
	oReport:PrintDialog()
endif
//Retorno da funcao
EMB->(dbCloseArea())
Ferase(ctrEMB+".dbf")
Ferase(ctrEMB+".cdx")

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
oReport := TReport():New(cPerg,"Relacao de embarque de planos",cPerg,{|oReport| Printreport(oReport)},;
				"Embarque de planos PNP2 ")
//Cria a Seção do relatorio
oSection1 := TRSection():New(oReport,"Section ?????",{"EMB"},/*Ordem*/)

		EMB->PLANO    := TMP->ZG_PLANO
		EMB->SEQUENC  := TMP->ZG_SEQUEN
		EMB->MODELO   := TMP->C2_PRODUTO
		EMB->DESCMOD  := Posicione("SB1",1,xFilial("SB1")+TMP->C2_PRODUTO,"B1_DESC")
		EMB->INVOICE  := TMP->ZG_INVOICE
		EMB->QTDEEMB  := TMP->ZG_QTDEEMB
		EMB->QTDISPE  := TMP->ZG_QTDISPE
		EMB->CLIENTE  := TMP->C2_CLIENTE
		EMB->LOJA     := TMP->C2_LOJA
		EMB->NOMECLI  := Posicione("SA1",1,xFilial("SA1")+TMP->(C2_CLIENTE+C2_LOJA),"A1_NOME")
		EMB->SALDO    := 0


//Cria as celulas do relatório 
TRCell():New(oSection1,"PLANO"		,"EMB","PLANO"   		,"@!"					,20,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"SEQUENC"	,"EMB","Sequenc"   		,"@!"					,02,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"MODELO"		,"EMB","Modelo"   	    ,"@!"					,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"DESCMOD"	,"EMB","Descrição"  	,"@!"					,50,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"INVOICE"	,"EMB","Invoice"   		,"@!"					,20,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"QTDEEMB"	,"EMB","Quantidade" 	,"@E 999,999.999"		,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"QTDISPE"	,"EMB","Disponivel"		,"@E 999,999.999"		,15,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection1,"CLIENTE"    ,"EMB","Cliente"	    ,"@!"					,08,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"LOJA"		,"EMB","Loja"			,"@!"					,02,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"NOMECLI"    ,"EMB","Nome do Cliente","@!"					,50,/*TAMPIXEL*/,/*BLOCO*/)
//TRCell():New(oSection1,"EMBUNIT"	,"EMB","Custo Medio" 	,"@E 999,999.999" 	,15,/*TAMPIXEL*/,/*BLOCO*/)
//TRCell():New(oSection1,"EMBCST"		,"EMB","Custo Total" 	,"@E 999,999.999"	,15,/*TAMPIXEL*/,/*BLOCO*/)


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
AADD(aRegs,{cPerg,"01","Modelo De"		,"","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Modelo Ate"		,"","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Plano De" 		,"","","mv_ch3","C",20,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SC2","","","",""})
AADD(aRegs,{cPerg,"04","Plano Ate" 		,"","","mv_ch4","C",20,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SC2","","","",""})
AADD(aRegs,{cPerg,"05","Data De"  	    ,"","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Data Ate" 	    ,"","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Cliente De" 	,"","","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
AADD(aRegs,{cPerg,"08","Cliente Ate"	,"","","mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
AADD(aRegs,{cPerg,"09","Loja de" 		,"","","mv_ch9","C",02,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Loja Ate" 		,"","","mv_cha","C",02,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})




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