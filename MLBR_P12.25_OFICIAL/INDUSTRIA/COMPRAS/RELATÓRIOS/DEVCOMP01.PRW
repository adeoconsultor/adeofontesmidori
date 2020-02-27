#INCLUDE "Protheus.ch"
#INCLUDE "topconn.ch"
/*
Programa:	DEVCOMP01.prw
Autor   :	ANESIO GERALDO DE FARIA
Data    :	19/02/14
Objetivo:	Relatório de devolucao de compras

*/
//--------------------------
User Function DEVCOMP01()
//--------------------------
Local nIII 		:= 0
Local cQuery 	:= ""
Private cPerg 	:= PADR("DEVCOMP01",10)
Private nPosPed := 0 
Private aAcum 	:= aAcum := {}

if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	ValidPerg(cPerg)
endif
Pergunte(cPerg,.T.)      

//Arquivo temporario da funcao para geracao do relatorio
aCOM	:= {}
AADD(aCOM,{"FILIAL" 	    , "C", 02, 0 } )
AADD(aCOM,{"NFSER" 		    , "C", 03, 0 } )
AADD(aCOM,{"NFNUM" 		    , "C", 09, 0 } )
AADD(aCOM,{"NFITEM" 		, "C", 04, 0 } )
AADD(aCOM,{"DTEMIS"	 	    , "D", 08, 0 } )
AADD(aCOM,{"GRUPO"     		, "C", 04, 0 } )
AADD(aCOM,{"DESCGRP"   		, "C", 30, 0 } )
AADD(aCOM,{"FORNEC" 	  	, "C", 10, 0 } )
AADD(aCOM,{"NFORNEC"    	, "C", 30, 0 } )
AADD(aCOM,{"CODPRO" 	   	, "C", 15, 0 } )
AADD(aCOM,{"DESCP" 		    , "C", 40, 0 } )
AADD(aCOM,{"CFOP" 	    	, "C", 05, 0 } )
AADD(aCOM,{"CSTPIS"	    	, "C", 02, 0 } )
AADD(aCOM,{"CSTCOF"	    	, "C", 02, 0 } )
AADD(aCOM,{"CODBCC"     	, "C", 02, 0 } )
AADD(aCOM,{"EST"     		, "C", 02, 0 } )
AADD(aCOM,{"BPIS"     		, "N", 15, 2 } )
AADD(aCOM,{"PIS"     		, "N", 15, 2 } )
AADD(aCOM,{"ALPIS"     		, "N", 15, 2 } )
AADD(aCOM,{"COF"     		, "N", 15, 2 } )
AADD(aCOM,{"ALCOF"     		, "N", 15, 2 } )
AADD(aCOM,{"VTOT"     		, "N", 15, 2 } )
AADD(aCOM,{"TES"     		, "C", 03, 0 } )
AADD(aCOM,{"UM"     		, "C", 02, 0 } )
AADD(aCOM,{"CCUSTO"    		, "C", 09, 0 } )
AADD(aCOM,{"NFORI"    		, "C", 09, 0 } )
AADD(aCOM,{"SERORI"    		, "C", 05, 0 } )
AADD(aCOM,{"GERAIS"    		, "C", 20, 0 } )
AADD(aCOM,{"CONTA"     		, "C", 20, 0 } )

ctrbCOM := CriaTrab(aCOM, .T.)
dbUseArea(.T.,,ctrbCOM,"COM",.F.,.F.)
INDEX ON FILIAL + GRUPO + CODPRO TO &ctrbCOM

//Mensagem solciitando ao usuario que aguarde a extraçao dos dados
CursorWait()
MsgRun( "Selecionando arquivo de Notas de Devolucao, aguarde...",, { || DEVCPR() } ) 
CursorArrow()

COM->(dbgotop())

If TRepInUse()
	//Gera as definicoes do relatorio
	oReport := ReportDef()
	//Monta interface com o usuário
	oReport:PrintDialog()
endif
//Retorno da funcao
COM->(dbCloseArea())
Ferase(ctrbCOM+".dbf")
Ferase(ctrbCOM+".cdx")

Return()

//-------------------------
Static Function ReportDef()
//-------------------------
//Variaveis locais da funcao
Local oReport 	:= ""
Local oBreak	:= ""
Local oSection1	:= ""
Local oSection2	:= ""
//Inicio da funcao
//Monta o objeto do relatorio
oReport := TReport():New(cPerg,"Relatorio de N.Fiscais de Devoluçao",cPerg,{|oReport| Printreport(oReport)},;
				"Informar total de notas fiscais de devolução. ")
//Cria a Seção do relatorio
oSection1 := TRSection():New(oReport,"Section ?????",{"COM"},/*Ordem*/)

//Cria as celulas do relatório 
TRCell():New(oSection1,"FILIAL"		,"COM","Filial"   		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"CODPRO"		,"COM","Produto"   		,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"UM"			,"COM","Un.Media"  		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"DESCP"		,"COM","Descrição"  	,"@!"				,40,/*TAMPIXEL*/,/*BLOCO*/)

TRCell():New(oSection1,"GRUPO"		,"COM","Grupo"   		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"DESCGRP"	,"COM","Desc.Grupo"  	,"@!"				,30,/*TAMPIXEL*/,/*BLOCO*/)

TRCell():New(oSection1,"NFSER"		,"COM","Serie NF"  		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"NFNUM"		,"COM","Num. NF"  		,"@!"				,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"NFITEM"		,"COM","Item NF"  		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)

TRCell():New(oSection1,"FORNEC"		,"COM","Cod.For"  		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"NFORNEC"	,"COM","Nome Fornec"	,"@!"				,40,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"EST"		,"COM","Estado"			,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)

TRCell():New(oSection1,"DTEMIS"		,"COM","Dt. Emissao" 	,"@!"				,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"CFOP"		,"COM","CFOP"  			,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"TES"		,"COM","TES" 	 		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)

TRCell():New(oSection1,"BPIS"		,"COM","Base Pis/Cof" 	,"@!"				,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"PIS"		,"COM","Valor Pis" 		,"@!"				,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"ALPIS"		,"COM","Aliq. Pis" 		,"@!"				,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"COF"		,"COM","Valor Cof" 		,"@!"				,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"ALCOF"		,"COM","Aliq. Cof" 		,"@!"				,15,/*TAMPIXEL*/,/*BLOCO*/)

TRCell():New(oSection1,"CSTPIS"		,"COM","CST PIS" 		,"@!"				,02,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"CSTCOF"		,"COM","CST COF" 		,"@!"				,02,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"CODBCC"		,"COM","COD.B.CRED"		,"@!"				,02,/*TAMPIXEL*/,/*BLOCO*/)

TRCell():New(oSection1,"VTOT"		,"COM","Valor Contabil"	,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)
                                                                                                           
TRCell():New(oSection1,"CCUSTO"		,"COM","C.Custo" 		,"@!"				,09,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"NFORI"		,"COM","NF.Orig"		,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"SERORI"		,"COM","Serie Orig" 	,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"GERAIS"		,"COM","Gerais" 		,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"CONTA"		,"COM","Conta" 			,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)


Return(oReport)

//-------------------------
Static Function PrintReport()
//-------------------------
Private oSection1 := oReport:Section(1)

oReport:FatLine()
oSection1:Print()

Return()


//---------------------------
Static Function DEVCPR()
//---------------------------
//Rotina de pesquisa d dados
BeginSql Alias "TMP"
	%NoParser%
	SELECT D2_FILIAL, D2_DOC, D2_UM, D2_SERIE, D2_COD, D2_ITEM, D2_TIPO, D2_EMISSAO, D2_TES, D2_CF, D2_CLIENTE, D2_LOJA, D2_BASIMP5, D2_BASIMP6,
	D2_NFORI, D2_SERIORI,
	D2_ALQIMP5, D2_ALQIMP6, D2_VALIMP5, D2_VALIMP6, FT_CSTPIS, FT_CSTCOF, FT_VALCONT, FT_CODBCC, D2_CCUSTO,
	FT_BASEPIS, FT_VALPIS, FT_VALCOF, FT_ESTADO, D2_NFORI, D2_SERIORI
	FROM %Table:SD2% SD2, %Table:SFT% SFT
	where SD2.%NotDel%  and SFT.D_E_L_E_T_ =' '
	and FT_FILIAL = D2_FILIAL
	and FT_NFISCAL = D2_DOC 
	and FT_PRODUTO = D2_COD
	and FT_ITEM = D2_ITEM
	and FT_CLIEFOR = D2_CLIENTE
	and FT_LOJA = D2_LOJA
	and FT_DTCANC = ''
	and D2_NFORI <> ''
	and D2_FILIAL  BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND
	D2_EMISSAO BETWEEN %Exp:mv_par03% AND %Exp:mv_par04% 
//	GROUP BY FT_FILIAL,FT_SERIE,FT_NFISCAL,FT_PRODUTO,FT_ITEM,FT_ENTRADA,FT_CFOP,FT_ESTADO,FT_CLIEFOR,FT_LOJA,FT_BASEPIS,FT_VALPIS,FT_VALCOF,FT_VALCONT,FT_ALIQPIS, FT_ALIQCOF, FT_CSTPIS, FT_CSTCOF, FT_CODBCC
	ORDER BY D2_FILIAL, D2_DOC, D2_SERIE
EndSql

do while TMP->(!eof())
	//Posicionando tabelas 
	cTipo := 'N'
	if SB1->(dbSeek(xFilial("SB1") + TMP->D2_COD))
			
    endif 

	if SBM->(dbSeek(xFilial("SBM") + SB1->B1_GRUPO)) //compartilhado

	endif 
	//Posiciona Item na NS entrada (Localizar TES)
//	if SD1->(dbSeek(TMP->FT_FILIAL + TMP->FT_NFISCAL + TMP->FT_SERIE + TMP->FT_CLIEFOR + TMP->FT_LOJA + TMP->FT_PRODUTO + TMP->FT_ITEM))
		cTipo := TMP->D2_TIPO
//	endif     
	if SA2->(dbSeek(xFilial("SA2") + TMP->(D2_CLIENTE+D2_LOJA))) //compartilhado
	
	endif 
/*	if cTipo $ 'D|B'
		if SA1->(dbSeek(xFilial("SA1") + TMP->D2_CLIEFOR)) //compartilhado
	
		endif 
	 else
		if SA2->(dbSeek(xFilial("SA2") + TMP->FT_CLIEFOR)) //compartilhado
	
		endif 
	endif
*/
	Reclock("COM",.T.)
	COM->FILIAL   := TMP->D2_FILIAL
	COM->NFSER	  := TMP->D2_SERIE
	COM->NFNUM    := TMP->D2_DOC
	COM->NFITEM   := TMP->D2_ITEM

	COM->GRUPO    := SB1->B1_GRUPO
	COM->DTEMIS	  := STOD(TMP->D2_EMISSAO)
	COM->DESCGRP  := SBM->BM_DESC

	COM->FORNEC	  := TMP->D2_CLIENTE
	COM->NFORNEC  := iif(cTipo $ 'D|B', SA2->A2_NOME, SA1->A1_NOME)
	COM->EST	  := TMP->FT_ESTADO

	COM->CODPRO	  := TMP->D2_COD
	COM->DESCP	  := SB1->B1_DESC
	COM->CFOP	  := TMP->D2_CF
	COM->BPIS	  := TMP->D2_BASIMP5
	COM->PIS	  := TMP->D2_VALIMP5
	COM->COF	  := TMP->D2_VALIMP6
	COM->ALPIS	  := TMP->D2_ALQIMP5
	COM->ALCOF	  := TMP->D2_ALQIMP6
	COM->VTOT	  := TMP->FT_VALCONT
	COM->TES	  := TMP->D2_TES
	COM->CSTPIS   := TMP->FT_CSTPIS
	COM->CSTCOF   := TMP->FT_CSTCOF
	COM->CODBCC   := TMP->FT_CODBCC
	COM->UM		  := TMP->D2_UM
	COM->CCUSTO	  := TMP->D2_CCUSTO
	COM->NFORI	  := TMP->D2_NFORI
	COM->SERORI	  := TMP->D2_SERIORI 
	COM->GERAIS	  := SB1->B1_GERAIS
	COM->CONTA	  := SB1->B1_CONTA
	Msunlock("COM")

	nPosPed	:=	Ascan(aAcum,TMP->D2_CF)
	If nPosPed == 0
		AAdd(aAcum,{TMP->D2_CF,TMP->FT_BASEPIS,TMP->FT_VALPIS,TMP->FT_VALCOF,TMP->FT_VALCONT})
	Else
		aAcum[nPosPed][2] := aAcum[nPosPed][2] + TMP->FT_BASEPIS
		aAcum[nPosPed][3] := aAcum[nPosPed][3] + TMP->FT_VALPIS
		aAcum[nPosPed][4] := aAcum[nPosPed][4] + TMP->FT_VALCOF
		aAcum[nPosPed][5] := aAcum[nPosPed][5] + TMP->FT_VALCONT		
	Endif

//	MD1->(dbCloseArea())
	TMP->(dbSkip())
enddo 

TMP->(dbCloseArea())
Return


//----------------------------------
Static Function ValidPerg(cPerg)
//----------------------------------
//Variaveis locais
Local aRegs := {}
Local i,j
//Inicio da funcao
dbSelectArea("SX1")
dbSetOrder(1)
//   1          2        3         4          5           6       7       8             9        10      11     12       13        14        15         16       17       18       19        20          21        22      23        24       25         26        27       28       29       30          31        32       33       34        35          36        37     38     39       40       41        42
//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_PYME/X1_GRPSXG/X1_HELP/X1_PICTURE
AADD(aRegs,{cPerg,"01","De Filial" 		,"","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Filial"		,"","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Data de" 		,"","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Data Ate" 		,"","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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