#INCLUDE "Protheus.ch"
#INCLUDE "topconn.ch"
/*
NOME DO PROGRAMA:MACOMR02.PRW
AUTOR     		:JOSE ROBERTO DE SOUZA 
DATA			:25/05/10
OBJETIVO		:IMPRESSAO DO RELATORIO PERSONALIZADO DE PEDIDOS EM ABERTO, CONSIDERANDO TODA A 
				 RASTREABILIDADE DESDE A SC ATE O RECEBIMENTO. 
			 

*/

//--------------------------
User Function MACOMR02()
//--------------------------
Local nIII := 0                                  
Local cQuery := ""
Private cPerg := PADR("MACOMR02",10)
PRIVATE lEnd := .F.
Private nKK := 0
if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	ValidPerg(cPerg)
endif
Pergunte(cPerg,.T.)      

//Arquivo temporario da funcao para geracao do relatorio
aCTB	:= {}
AADD(aCTB,{"C1_FILIAL" 	    , "C", 02, 0 } )
AADD(aCTB,{"B1_GRUPO" 	    , "C", 04, 0 } )
AADD(aCTB,{"BM_DESC" 	    , "C", 40, 0 } )
AADD(aCTB,{"C1_NUM" 	    , "C", 06, 0 } )
AADD(aCTB,{"C1_ITEM" 	    , "C", 04, 0 } )
AADD(aCTB,{"C1_EMISSAO" 	, "D", 08, 0 } )
AADD(aCTB,{"C1_DATPRF" 	    , "D", 08, 0 } )
AADD(aCTB,{"C1_NOMAPRO" 	, "C", 15, 0 } )
AADD(aCTB,{"C1_COTACAO" 	, "C", 06, 0 } )
AADD(aCTB,{"C7_NUM"  	    , "C", 06, 0 } )
AADD(aCTB,{"C7_EMISSAO" 	, "D", 08, 0 } )
AADD(aCTB,{"C7_CONAPRO" 	, "C", 06, 0 } )
AADD(aCTB,{"C1_PRODUTO" 	, "C", 15, 0 } )
AADD(aCTB,{"B1_IMPORT" 		, "C", 01, 0 } )
AADD(aCTB,{"C1_DESCRI"	 	, "C", 40, 0 } )
AADD(aCTB,{"C7_PRECO" 	    , "N", 15, 0 } )
AADD(aCTB,{"C7_FORNECE" 	, "C", 06, 0 } )
AADD(aCTB,{"C7_LOJA" 	    , "C", 02, 0 } )
AADD(aCTB,{"A2_NOME" 	    , "C", 30, 0 } )
AADD(aCTB,{"C7_QUANT" 	    , "N", 15, 3 } )
AADD(aCTB,{"C7_TOTAL" 	    , "N", 15, 3 } )
AADD(aCTB,{"C7_VALICM"	 	, "N", 15, 3 } )
AADD(aCTB,{"C7_VALIPI" 		, "N", 15, 3 } )
AADD(aCTB,{"SALDO"	 	    , "N", 15, 3 } )
AADD(aCTB,{"D1_VUNIT" 	    , "N", 15, 3 } )
AADD(aCTB,{"D1_TOTAL" 	    , "N", 15, 3 } )
AADD(aCTB,{"D1_EMISSAO" 	, "D", 08, 0 } )
AADD(aCTB,{"D1_DOC" 	    , "C", 30, 0 } )
AADD(aCTB,{"D1_SERIE" 	    , "C", 03, 0 } )
AADD(aCTB,{"APROV1" 	    , "C", 20, 0 } )
AADD(aCTB,{"APROV2" 	    , "C", 20, 0 } )

ctrbCTB := CriaTrab(aCTB, .T.)
dbUseArea(.T.,,ctrbCTB,"MD1",.F.,.F.)
INDEX ON C1_FILIAL + B1_GRUPO + C1_NUM + C1_ITEM TO &ctrbCTB

//Mensagem solciitando ao usuario que aguarde a extraçao dos dados
CursorWait()
MsgRun( "Selecionando Solicitacoes, Pedidos e NF de entrada, aguarde..."+Str(nKK),, { || MCR02P() } ) 
CursorArrow()

//-------------------
MD1->(dbgotop())
If TRepInUse()
	//Gera as definicoes do relatorio
	oReport := ReportDef()
	//Monta interface com o usuário
	oReport:PrintDialog()
endif
//Retorno da funcao
MD1->(dbCloseArea())
MD2->(dbCloseArea())
Ferase(ctrbCTB+".dbf")
Ferase(ctrbCTB+".cdx")
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

//oReport := TReport():New(cPerg,"N.F. Entrada X P.C. X S.C.",cPerg,{|oReport| Printreport(oReport)},;
//				"Este relatorio cruzara as informacoes de entrada com o pedido de compras e suas respectivas solicitacoes.")

oReport := TReport():New(cPerg,"N.F. Entrada X P.C. X S.C.","",{|oReport| Printreport(oReport)},;
				"Este relatorio cruzara as informacoes de entrada com o pedido de compras e suas respectivas solicitacoes.")


//Cria a Seção do relatorio
oSection1 := TRSection():New(oReport,"N.F. Entrada X P.C. X S.C.",{"MD1"},/*Ordem*/)

//Cria as celulas do relatório 
TRCell():New(oSection1,"B1_GRUPO"	,"MD1","Grp. Prd."   		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"BM_DESC"	,"MD1","Desc. Grp."			,"@!"				,30,/*TAMPIXEL*/,/*BLOCO*/)

TRCell():New(oSection1,"C1_FILIAL"	,"MD1","Filial" 	 		,"@!"				,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_NUM"		,"MD1","Num. Sol."  		,"@!"				,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_ITEM"	,"MD1","Item Sol."  		,"@!"				,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_EMISSAO"	,"MD1","Dt. Emissao."		,"@!"               ,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_DATPRF"	,"MD1","Dt. Neces."			,"@!"               ,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_NOMAPRO"	,"MD1","Aprovador da SC	"	,"@!"               ,30,/*TAMPIXEL*/,/*BLOCO*/)

TRCell():New(oSection1,"C1_COTACAO"	,"MD1","Num.Cotacao	"		,"@!"               ,10,/*TAMPIXEL*/,/*BLOCO*/)

TRCell():New(oSection1,"C7_NUM"		,"MD1","Ped. Comp."			,"@!"               ,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C7_EMISSAO"	,"MD1","Emissao Ped. Com."	,"@!"               ,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C7_CONAPRO"	,"MD1","Aprov/Bloq."		,"@!"               ,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_PRODUTO"	,"MD1","Cod. Prd."  		,"@!"				,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"B1_IMPORT"	,"MD1","Importado"  		,"@!"				,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C1_DESCRI"	,"MD1","Desc.Prd."  		,"@!"				,30,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C7_PRECO"	,"MD1","Pr.Unit." 	 		,"@!"				,30,/*TAMPIXEL*/,/*BLOCO*/)

TRCell():New(oSection1,"C7_FORNECE"	,"MD1","Cod. Forn."  		,"@!"				,06,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C7_LOJA"	,"MD1","Loja. Forn."  		,"@!"				,02,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"A2_NOME"	,"MD1","Nom. Forn."			,"@!"               ,40,/*TAMPIXEL*/,/*BLOCO*/)

TRCell():New(oSection1,"C7_QUANT"	,"MD1","Quant. Ped. Com"	,"@E 999,999,999.99",15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C7_TOTAL"	,"MD1","Val. Merc. Ped. Com","@E 999,999,999.99",15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C7_VALICM"	,"MD1","Val. ICMS"  		,"@E 999,999,999.99",15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"C7_VALIPI"	,"MD1","Val. IPI"			,"@E 999,999,999.99",15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"SALDO"		,"MD1","Saldo Pend."   		,"@E 999,999,999.99",06,/*TAMPIXEL*/,/*BLOCO*/)

TRCell():New(oSection1,"D1_VUNIT"	,"MD1","Val.Un.Nf."			,"@E 999,999,999.99",15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"D1_TOTAL"	,"MD1","Val.Tot.Nf."   		,"@E 999,999,999.99",15,/*TAMPIXEL*/,/*BLOCO*/)

TRCell():New(oSection1,"D1_EMISSAO"	,"MD1","Emissao N.F."		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"D1_DOC"		,"MD1","Num. Nf."   		,"@!"				,30,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"D1_SERIE"	,"MD1","Ser. Nf." 	 		,"@!"				,03,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"APROV1"		,"MD1","Aprovador 1"		,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"APROV2"		,"MD1","Aprovador 2"		,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)

Return(oReport)

//-------------------------
Static Function PrintReport()
//-------------------------
Private oSection1 := oReport:Section(1)
oReport:FatLine()
oSection1:Print()
Return()

//----------------------
STATIC FUNCTION MCR02P()
//----------------------
Local cDoc := ""
Local nRegs := 0 
//Rotina de pesquisa de dados
BeginSql Alias "MD2"
	%NoParser%
	SELECT C1_FILIAL,C1_NUM,C1_ITEM,C1_EMISSAO,C1_DATPRF,C1_NOMAPRO,C1_COTACAO,C1_QUANT,C1_QUJE,C1_PRODUTO, B1_GRUPO,B1_IMPORT
	FROM %Table:SC1% SC1, %Table:SB1% SB1
	WHERE 
	C1_PRODUTO BETWEEN  %Exp:mv_par05% AND %Exp:mv_par06% AND 
	B1_GRUPO   BETWEEN  %Exp:mv_par07% AND %Exp:mv_par08% AND 
	C1_EMISSAO BETWEEN  %Exp:mv_par09% AND %Exp:mv_par10% AND
	C1_FILIAL  BETWEEN  %Exp:mv_par11% AND %Exp:mv_par12% AND 
	C1_PRODUTO = B1_COD AND 
	SC1.%NotDel% AND
	SB1.%NotDel% 
EndSql
MD2->(DBGOTOP())
do while MD2->(!eof())
	nKK++
	RecLock("MD1",.t.)
	MD1->C1_FILIAL  :=	MD2->C1_FILIAL
	MD1->B1_GRUPO	:=  MD2->B1_GRUPO
	if SBM->(dbSeek(xFilial("SBM")+MD2->B1_GRUPO))
		MD1->BM_DESC	:=	SBM->BM_DESC
    endif 
	MD1->C1_NUM     :=	MD2->C1_NUM
	MD1->C1_ITEM    :=	MD2->C1_ITEM
	MD1->C1_EMISSAO	:=	STOD(MD2->C1_EMISSAO)
	MD1->C1_DATPRF 	:=	STOD(MD2->C1_DATPRF)
	MD1->C1_NOMAPRO	:= 	MD2->C1_NOMAPRO
	MD1->C1_PRODUTO	:=	MD2->C1_PRODUTO
	//Pesquisa B1 
	if SB1->(dbSeek(xFilial("SB1")+MD2->C1_PRODUTO))
		MD1->B1_IMPORT 	:=	MD2->B1_IMPORT
	endif
	MD1->C1_COTACAO	:=	MD2->C1_COTACAO
	//Pesquisa Pedido
	cQuery := " SELECT *  "
	cQuery += " FROM " + RetSqlName("SC7")
	cQuery += " WHERE C7_FILIAL = '" + MD2->C1_FILIAL + "'"
	cQuery += "	AND C7_NUMSC ='"  + MD2->C1_NUM +"'"
	cQuery += "	AND C7_ITEMSC ='" + MD2->C1_ITEM +"'"
	cQuery += "	AND SC7010.D_E_L_E_T_ <> '*' "
	TCQUERY cQuery NEW ALIAS "MD3"

	MD1->C7_NUM    	:=	MD3->C7_NUM
	MD1->C7_EMISSAO	:=	STOD(MD3->C7_EMISSAO)
	MD1->C7_CONAPRO	:=	MD3->C7_CONAPRO
	MD1->C1_DESCRI	:=	SB1->B1_DESC
	MD1->C7_PRECO	:=	MD3->C7_PRECO
	MD1->C7_FORNECE	:=	MD3->C7_FORNECE
	MD1->C7_LOJA    :=	MD3->C7_LOJA
	if SA2->(dbSeek(xFilial("SA2")+MD3->C7_FORNECE+MD3->C7_LOJA))
		MD1->A2_NOME    :=	SA2->A2_NOME
	endif 
	MD1->C7_QUANT   :=	MD3->C7_QUANT
	MD1->C7_TOTAL   :=	MD3->C7_TOTAL
	MD1->C7_VALICM  :=	MD3->C7_VALICM
	MD1->C7_VALIPI  :=	MD3->C7_VALIPI
	MD1->SALDO      :=	(MD3->C7_QUANT - MD3->C7_QUJE)

	//Pesquisa NF Entrada 
	cQuery := " SELECT *  "
	cQuery += " FROM " + RetSqlName("SD1")
	cQuery += " WHERE D1_FILIAL = '" + MD2->C1_FILIAL + "'"
	IF len(alltrim(MD3->C7_NUM))=0
		cQuery += "	AND D1_PEDIDO ='ZZZZZZ'"
    else 
		cQuery += "	AND D1_PEDIDO ='" + MD3->C7_NUM +"'"
	endif 
	if len(alltrim(MD3->C7_ITEM)) = 0 
		cQuery += "	AND D1_ITEMPC ='ZZZZ'"
	else
		cQuery += "	AND D1_ITEMPC ='" + MD3->C7_ITEM +"'"
	endif                                                          
	cQuery += "	AND SD1010.D_E_L_E_T_ <> '*' "
	TCQUERY cQuery NEW ALIAS "MD4"

	cDoc := ""
	do WHILE MD4->(!EOF())
		cDoc =+ alltrim(MD4->D1_DOC)+","
		MD1->D1_VUNIT   :=	MD4->D1_VUNIT
		MD1->D1_TOTAL   :=	MD4->D1_TOTAL
		MD1->D1_EMISSAO :=	STOD(MD4->D1_EMISSAO)
//		MD1->D1_DOC     :=	MD4->D1_DOC
		MD1->D1_DOC     :=	cDoc
		MD1->D1_SERIE   :=	MD4->D1_SERIE
		MD4->(dbSkip())
	ENDDO 

	//Pesquisa Aprovadores 
	cQuery := " SELECT DISTINCT CR_NUM,CR_APROV,AL_NOME,CR_NIVEL,CR_STATUS  "
	cQuery += " FROM " + RetSqlName("SCR")+ ", " + RetSqlName("SAL")
	cQuery += " WHERE CR_FILIAL = '" + MD2->C1_FILIAL + "'"
	cQuery += "	AND AL_FILIAL ='"    + MD2->C1_FILIAL + "'"
	cQuery += "	AND CR_NUM ='" + MD3->C7_NUM +"'"
	cQuery += "	AND AL_APROV = CR_APROV "
	cQuery += "	AND SCR010.D_E_L_E_T_ <> '*' "
	cQuery += "	AND SAL010.D_E_L_E_T_ <> '*' "
	cQuery += "	GROUP BY CR_NUM,CR_APROV,AL_NOME,CR_NIVEL,CR_STATUS "
	cQuery += "	ORDER BY CR_NIVEL,CR_STATUS "

	TCQUERY cQuery NEW ALIAS "MD5"

	do while MD5->(!eof())
		do case
			case MD5->CR_NIVEL = "01" .and. MD5->CR_STATUS = "05" //Primeiro aprovador 
				MD1->APROV1    :=	MD5->AL_NOME
			case MD5->CR_NIVEL = "02" .and. MD5->CR_STATUS = "05" //Segundo aprovador 
				MD1->APROV2    :=	MD5->AL_NOME
		endcase
		MD5->(dbSkip())
    enddo 

	MsUnlock("MD1")
	MD2->(dbSkip())
	MD3->(dbCloseArea())
	MD4->(dbCloseArea())
	MD5->(dbCloseArea())	
enddo 
RETURN



//--------------------------------
Static Function ValidPerg(cPerg)
//--------------------------------
//Variaveis locais
Local aRegs := {}
Local i,j
//Inicio da funcao
dbSelectArea("SX1")
dbSetOrder(1)
//   1          2        3         4          5           6       7       8             9        10      11     12       13        14        15         16       17       18       19        20          21        22      23        24       25         26        27       28       29       30          31        32       33       34        35          36        37     38     39       40       41        42
//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_PYME/X1_GRPSXG/X1_HELP/X1_PICTURE
AADD(aRegs,{cPerg,"01","De Fornecedor" 	,"","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
AADD(aRegs,{cPerg,"02","Ate Fornecedor"	,"","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
AADD(aRegs,{cPerg,"03","De Loja"  		,"","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Loja" 		,"","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","De Produto"  	,"","","mv_ch5","C",15,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
AADD(aRegs,{cPerg,"06","Ate Produto" 	,"","","mv_ch6","C",15,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
AADD(aRegs,{cPerg,"07","De Grp. Prod."	,"","","mv_ch7","C",04,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""})
AADD(aRegs,{cPerg,"08","Ate Grp. Prod."	,"","","mv_ch8","C",04,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""})
AADD(aRegs,{cPerg,"09","De Dt. Digit."	,"","","mv_ch9","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","De Ate. Digit."	,"","","mv_cha","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","De Filial"  	,"","","mv_chb","C",02,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Ate. Filial"	,"","","mv_chc","C",02,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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



