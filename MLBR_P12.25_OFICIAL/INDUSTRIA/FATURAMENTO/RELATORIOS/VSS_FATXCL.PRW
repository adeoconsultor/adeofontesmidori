#include "protheus.ch"
//#include "TopConn.ch"
//#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VSS_FATXCLºAutor  ³ Vinicius Schwartz  º Data ³  22/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de Faturamento por Cliente                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                         

User Function VSS_FATXCL()
Local cQry := ""   
Private cPerg := "VSS_FATXCL"
if !SX1->(dbSeek(cPerg))
	//Criando as perguntas
	AjustaSx1(cPerg)
endif
Pergunte(cPerg,.T.)


//Verifica se tabelas temporias existem e encerra as mesmas antes de executar as novas
if Select("TMPSD2") > 0 
	dbSelectArea("TMPSD2")
	TMPSD2->(dbCloseArea())
endif


//Filtra as saídas (SD2) quando TES Gera Financeiro = "S" e Atualiza Estoque = "S"
cQry:= "	SELECT D2_FILIAL, D2_CLIENTE, A1_NOME, D2_DOC, D2_EMISSAO, D2_PEDIDO, D2_COD, B1_DESC, D2_QUANT, D2_PRCVEN, D2_TOTAL "
cQry+= "	FROM SD2010 SD2 "
cQry+= "	JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ <> '*' "
cQry+= "  		AND A1_COD = D2_CLIENTE "
cQry+= "		AND A1_LOJA = D2_LOJA "
cQry+= "	JOIN SB1010 SB1 ON SB1.D_E_L_E_T_ <> '*' "
cQry+= "		AND B1_COD = D2_COD "
cQry+= "	JOIN SF4010 SF4 ON SF4.D_E_L_E_T_ <> '*' "
cQry+= "		AND F4_CODIGO = D2_TES "
//cQry+= "		AND F4_FILIAL = D2_FILIAL "  - Comentado por ter unificado as TES
cQry+= "	WHERE SD2.D_E_L_E_T_ <>  '*' "
cQry+= "		AND D2_TIPO <>   'D' "
cQry+= "		AND F4_DUPLIC =  'S' "
cQry+= "		AND F4_ESTOQUE = 'S' " 
cQry+= "		AND D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cQry+= "		AND D2_EMISSAO BETWEEN '"+dTos(mv_par03)+"' AND '"+dTos(mv_par04)+"' "
cQry+= "		AND D2_CLIENTE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
cQry+= "		ORDER BY D2_FILIAL, D2_CLIENTE, D2_EMISSAO "   

cQry:= ChangeQuery(cQry)
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry),"TMPSD2",.T.,.T.)  

//Define campo data de emissao para o tipo data
TcSetField("TMPSD2", "D2_EMISSAO", "D")

//Arquivos temporario da funcao para geracao do relatorio
aTMP	:={}
AADD(aTMP,{"D2_FILIAL"		, "C", 02, 0 } )
AADD(aTMP,{"A1_NOME"		, "C", 50, 0 } )
AADD(aTMP,{"D2_DOC"			, "C", 09, 0 } )
AADD(aTMP,{"D2_EMISSAO"		, "D", 08, 0 } )
AADD(aTMP,{"D2_PEDIDO"		, "C", 06, 0 } )
AADD(aTMP,{"D2_COD"			, "C", 06, 0 } )
AADD(aTMP,{"B1_DESC"		, "C", 06, 0 } )
AADD(aTMP,{"D2_QUANT"		, "N", 15, 4 } )
AADD(aTMP,{"D2_PRCVEN"		, "N", 15, 6 } )
AADD(aTMP,{"D2_TOTAL"		, "N", 15, 2 } )
ctrTMP := CriaTrab(aTMP, .T.)
dbUseArea(.T.,,ctrTMP,"TMP",.F.,.F.)       

dbSelectArea("TMPSD2")
TMPSD2->(dbGoTop())
while !TMPSD2->(eof())
	dbSelectArea("TMP")
	RecLock("TMP",.T.)  
	TMP->D2_FILIAL	:= TMPSd2->D2_FILIAL
	TMP->A1_NOME   	:= TMPSD2->A1_NOME	
	TMP->D2_DOC     := TMPSD2->D2_DOC
	TMP->D2_EMISSAO := TMPSD2->D2_EMISSAO
	TMP->D2_PEDIDO  := TMPSD2->D2_PEDIDO
	TMP->D2_COD     := TMPSD2->D2_COD
	TMP->B1_DESC    := TMPSD2->B1_DESC
	TMP->D2_QUANT   := TMPSD2->D2_QUANT
	TMP->D2_PRCVEN  := TMPSD2->D2_PRCVEN
	TMP->D2_TOTAL   := TMPSD2->D2_TOTAL
	MsUnLock("TMP")
	TMPSD2->(dbSkip())
	incProc("Pesquisando Registros...")
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
oReport := TReport():New(cPerg,"Relatório de Faturamento por Cliente...",cPerg,{|oReport| Printreport(oReport)},;
				"Relatório de Faturamento por Cliente...")
//Cria a Seção do relatorio
oSection1 := TRSection():New(oReport,"Relatório de Faturamento por Cliente...",{"TMP"},/*Ordem*/)

	TMP->D2_FILIAL	:= TMP->D2_FILIAL
	TMP->A1_NOME   	:= TMP->A1_NOME	
	TMP->D2_DOC     := TMP->D2_DOC
	TMP->D2_EMISSAO := TMP->D2_EMISSAO
	TMP->D2_PEDIDO  := TMP->D2_PEDIDO
	TMP->D2_COD     := TMP->D2_COD
	TMP->B1_DESC    := TMP->B1_DESC
	TMP->D2_QUANT   := TMP->D2_QUANT
	TMP->D2_PRCVEN  := TMP->D2_PRCVEN
	TMP->D2_TOTAL   := TMP->D2_TOTAL

//Cria as celulas do relatório
	TRCell():New(oSection1,"D2_FILIAL"		,"TMP","Filial"			,"@!"					,02,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"A1_NOME"		,"TMP","Nome"			,"@!"					,50,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D2_DOC"			,"TMP","Num. Docto."	,"@!"					,09,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D2_EMISSAO"		,"TMP","Emissao"  		,"@!"					,08,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D2_PEDIDO"		,"TMP","Pedido"			,"@!"					,06,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D2_COD"			,"TMP","Produto"		,"@!"					,06,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"B1_DESC"		,"TMP","Descricao"		,"@!"					,06,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D2_QUANT"		,"TMP","Quantidade"		,"@E 9,999,999.99"		,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D2_PRCVEN"		,"TMP","Vlr.Unit"		,"@E 9,999,999.99"		,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"D2_TOTAL"		,"TMP","Vlr.Total"		,"@E 9,999,999.99"		,15,/*TAMPIXEL*/,/*BLOCO*/)

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
PutSx1(cPerg,"01","Filial Inicial                ?"," "," ","mv_ch1","C",2,0,0,"G","","SD2","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a filial inicial"},{"Informe a filial inicial"},{"Informe a filial inicial"})
PutSx1(cPerg,"02","Filial Final                  ?"," "," ","mv_ch2","C",2,0,0,"G","","SD2","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a filial final"},{"Informe a filial final"},{"Informe a filial final"})
PutSx1(cPerg,"03","Data Inicial                  ?"," "," ","mv_ch3","D",8,0,0,	"G","","   ","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo inicial"},{"Informe o periodo inicial"},{"Informe o periodo inicial"})
PutSx1(cPerg,"04","Data final                    ?"," "," ","mv_ch4","D",8,0,0,	"G","","   ","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo final"},{"Informe o periodo final"},{"Informe o periodo final"})
PutSx1(cPerg,"05","Cliente de                    ?"," "," ","mv_ch5","C",6,0,0, "G","","SD2","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o cliente inicial"},{"Informe o cliente inicial"},{"Informe o cliente inicial"})
PutSx1(cPerg,"06","Cliente ate                   ?"," "," ","mv_ch6","C",6,0,0, "G","","SD2","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o cliente final"},{"Informe o cliente final"},{"Informe o cliente final"})


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