#INCLUDE "Protheus.ch"									
#INCLUDE "topconn.ch"									
/*									
Programa:	MACTBR08.prw								
Autor   :	JOSE ROBERTO DE SOUZA 								
Data    :	31/05/2010								
Objetivo:	Relatório de de notas fiscais de emtrada 								
			Valores de pis/cofins com suas bases 						
			Por Filial e Data. 						
*/									
//--------------------------									
User Function MACTBR08()									
//--------------------------									
Local nIII 		:= 0							
Local cQuery 	:= ""								
Private cPerg 	:= PADR("MACTBR08",10)								
Private nPosPed := 0 									
Private aAcum 	:= aAcum := {}								
									
if !SX1->(dbSeek(cPerg))									
	//Cria as perguntas								
	ValidPerg(cPerg)								
endif									
Pergunte(cPerg,.T.)      									
									
//Arquivo temporario da funcao para geracao do relatorio									
aCTB	:= {}								
AADD(aCTB,{"FILIAL" 	    , "C", 02, 0 } )								
AADD(aCTB,{"NFSER" 		    , "C", 03, 0 } )							
AADD(aCTB,{"NFNUM" 		    , "C", 09, 0 } )							
AADD(aCTB,{"NFITEM" 		, "C", 04, 0 } )							
AADD(aCTB,{"TIPONF" 	  	, "C", 02, 0 } )							
AADD(aCTB,{"ESPECIE" 	  	, "C", 10, 0 } )							
AADD(aCTB,{"DTENT"	 	    , "D", 08, 0 } )							
AADD(aCTB,{"GRUPO"     		, "C", 04, 0 } )							
AADD(aCTB,{"DESCGRP"   		, "C", 30, 0 } )							
AADD(aCTB,{"NCM" 	  		, "C", 10, 0 } )						
AADD(aCTB,{"FORNEC" 	  	, "C", 10, 0 } )							
AADD(aCTB,{"LOJAFORN" 	  	, "C", 02, 0 } )							
AADD(aCTB,{"NFORNEC"    	, "C", 30, 0 } )								
AADD(aCTB,{"CODPRO" 	   	, "C", 15, 0 } )							
AADD(aCTB,{"DESCP" 		    , "C", 40, 0 } )							
AADD(aCTB,{"CFOP" 	    	, "C", 05, 0 } )							
AADD(aCTB,{"CSTPIS"	    	, "C", 02, 0 } )							
AADD(aCTB,{"CSTCOF"	    	, "C", 02, 0 } )							
AADD(aCTB,{"CODBCC"     	, "C", 02, 0 } )								
AADD(aCTB,{"EST"     		, "C", 02, 0 } )							
AADD(aCTB,{"BPIS"     		, "N", 15, 2 } )							
AADD(aCTB,{"PIS"     		, "N", 15, 2 } )							
AADD(aCTB,{"ALPIS"     		, "N", 15, 2 } )							
AADD(aCTB,{"COF"     		, "N", 15, 2 } )							
AADD(aCTB,{"ALCOF"     		, "N", 15, 2 } )							
AADD(aCTB,{"VTOT"     		, "N", 15, 2 } )
//
AADD(aCTB,{"BASICM"    		, "N", 15, 2 } )							
AADD(aCTB,{"ALICMS"    		, "N", 15, 2 } )
AADD(aCTB,{"VLICMS"    		, "N", 15, 2 } )
//							
AADD(aCTB,{"VTOTAL"    		, "N", 15, 2 } )							
AADD(aCTB,{"TES"     		, "C", 03, 0 } )							
AADD(aCTB,{"UM"     		, "C", 02, 0 } )							
AADD(aCTB,{"CCUSTO"    		, "C", 09, 0 } )							
AADD(aCTB,{"CONIND"    		, "C", 20, 0 } )							
AADD(aCTB,{"ESTDIR"    		, "C", 20, 0 } )							
AADD(aCTB,{"GERAIS"    		, "C", 20, 0 } )							
AADD(aCTB,{"CONTA"     		, "C", 20, 0 } )							
AADD(aCTB,{"ALQCOFM"   		, "N", 10, 2 } )							
AADD(aCTB,{"VLRCOFM"     	, "N", 10, 2 } )								
AADD(aCTB,{"CHAVENF" 	    , "C", 44, 0 } )								
									
ctrbCTB := CriaTrab(aCTB, .T.)									
dbUseArea(.T.,,ctrbCTB,"CTB",.F.,.F.)									
INDEX ON FILIAL + GRUPO + CODPRO TO &ctrbCTB									
									
//Mensagem solciitando ao usuario que aguarde a extraçao dos dados									
CursorWait()									
MsgRun( "Selecionando arquivo de Notas de Entrada, aguarde...",, { || MCTBR08() } ) 									
CursorArrow()									
									
CTB->(dbgotop())									
									
//If TRepInUse()									
	//Gera as definicoes do relatorio								
	oReport := ReportDef()								
	//Monta interface com o usuário								
	oReport:PrintDialog()								
//endif									
//Retorno da funcao									
CTB->(dbCloseArea())									
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
Local oSection2	:= ""								
//Inicio da funcao									
//Monta o objeto do relatorio									
oReport := TReport():New(cPerg,"Relatorio de N.Fiscais de Entrada (Pis/Cof)",cPerg,{|oReport| Printreport(oReport)},;									
				"Informar o total de Pis/Cofins nas notas de entrada." )					
//Cria a Seção do relatorio									
oSection1 := TRSection():New(oReport,"Section ?????",{"CTB"},/*Ordem*/)									
									
//Cria as celulas do relatório 									
TRCell():New(oSection1,"FILIAL"		,"CTB","Filial"   		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)	
TRCell():New(oSection1,"CODPRO"		,"CTB","Produto"   		,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)	
TRCell():New(oSection1,"UM"			,"CTB","Un.Medida"  	,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"DESCP"		,"CTB","Descrição"  	,"@!"				,40,/*TAMPIXEL*/,/*BLOCO*/)		
									
TRCell():New(oSection1,"GRUPO"		,"CTB","Grupo"   		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)	
TRCell():New(oSection1,"DESCGRP"	,"CTB","Desc.Grupo"  	,"@!"				,30,/*TAMPIXEL*/,/*BLOCO*/)			
TRCell():New(oSection1,"NCM"		,"CTB","NCM"   			,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)
									
TRCell():New(oSection1,"NFSER"		,"CTB","Serie NF"  		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)	
TRCell():New(oSection1,"NFNUM"		,"CTB","Num. NF"  		,"@!"				,15,/*TAMPIXEL*/,/*BLOCO*/)	
TRCell():New(oSection1,"NFITEM"		,"CTB","Item NF"  		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)	
TRCell():New(oSection1,"ESPECIE"	,"CTB","Especie NF"		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)		
TRCell():New(oSection1,"TIPONF"		,"CTB","Tipo NF"		,"@!"				,02,/*TAMPIXEL*/,/*BLOCO*/)	
									
TRCell():New(oSection1,"FORNEC"		,"CTB","Cod.For"  		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)	
TRCell():New(oSection1,"LOJAFORN"	,"CTB","Loja.For"  		,"@!"				,02,/*TAMPIXEL*/,/*BLOCO*/)		
TRCell():New(oSection1,"NFORNEC"	,"CTB","Nome Fornec"	,"@!"				,40,/*TAMPIXEL*/,/*BLOCO*/)			
TRCell():New(oSection1,"EST"		,"CTB","Estado"			,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)
									
TRCell():New(oSection1,"DTENT"		,"CTB","Dt. Entrada" 	,"@!"				,15,/*TAMPIXEL*/,/*BLOCO*/)		
TRCell():New(oSection1,"CFOP"		,"CTB","CFOP"  			,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"TES"		,"CTB","TES" 	 		,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)
									
TRCell():New(oSection1,"BPIS"		,"CTB","Base Pis/Cof" 	,"@!"				,15,/*TAMPIXEL*/,/*BLOCO*/)		
TRCell():New(oSection1,"PIS"		,"CTB","Valor Pis" 		,"@!"				,15,/*TAMPIXEL*/,/*BLOCO*/)	
TRCell():New(oSection1,"ALPIS"		,"CTB","Aliq. Pis" 		,"@!"				,15,/*TAMPIXEL*/,/*BLOCO*/)	
TRCell():New(oSection1,"COF"		,"CTB","Valor Cof" 		,"@!"				,15,/*TAMPIXEL*/,/*BLOCO*/)	
TRCell():New(oSection1,"ALCOF"		,"CTB","Aliq. Cof" 		,"@!"				,15,/*TAMPIXEL*/,/*BLOCO*/)	
									
TRCell():New(oSection1,"CSTPIS"		,"CTB","CST PIS" 		,"@!"				,02,/*TAMPIXEL*/,/*BLOCO*/)	
TRCell():New(oSection1,"CSTCOF"		,"CTB","CST COF" 		,"@!"				,02,/*TAMPIXEL*/,/*BLOCO*/)	
TRCell():New(oSection1,"CODBCC"		,"CTB","COD.B.CRED"		,"@!"				,02,/*TAMPIXEL*/,/*BLOCO*/)	
									
TRCell():New(oSection1,"VTOT"		,"CTB","Valor Contabil"	,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)

TRCell():New(oSection1,"BASICM"		,"CTB","Base ICMS	"	,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)		
TRCell():New(oSection1,"ALICMS"		,"CTB","Aliq ICMS"		,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"VLICMS"		,"CTB","Valor ICMS"		,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)	
		
TRCell():New(oSection1,"VTOTAL"		,"CTB","Valor Total"	,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)		
                                                                                                           									
TRCell():New(oSection1,"CCUSTO"		,"CTB","C.Custo" 		,"@!"				,09,/*TAMPIXEL*/,/*BLOCO*/)	
//TRCell():New(oSection1,"CONIND"		,"CTB","Conind" 		,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)	
//TRCell():New(oSection1,"ESTDIR"		,"CTB","Est.Dir." 		,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)	
//TRCell():New(oSection1,"GERAIS"		,"CTB","Gerais" 		,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)	
TRCell():New(oSection1,"CONTA"		,"CTB","Conta" 			,"@!"				,20,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"ALQCOFM"	,"CTB","Aliq Cof Maj" 	,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)			
TRCell():New(oSection1,"VLRCOFM"	,"CTB","Valor Cof Maj" 	,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)			
TRCell():New(oSection1,"CHAVENF"	,"CTB","Chave NF-e"  	,"@!"				,44,/*TAMPIXEL*/,/*BLOCO*/)			
									
									
Return(oReport)									
									
//-------------------------									
Static Function PrintReport()									
//-------------------------									
Private oSection1 := oReport:Section(1)									
									
oReport:FatLine()									
oSection1:Print()									
									
Return()									
									
									
//---------------------------									
Static Function MCTBR08()									
//---------------------------									
//Rotina de pesquisa d dados									
BeginSql Alias "TMP"									
	%NoParser%								
	SELECT FT_FILIAL,FT_SERIE,FT_NFISCAL,FT_PRODUTO,FT_ITEM,FT_ESPECIE,FT_ENTRADA,FT_CFOP,FT_ESTADO,FT_CLIEFOR,FT_LOJA,FT_BASEPIS,FT_VALPIS,								
	FT_VALCOF,FT_VALCONT,FT_ALIQPIS, FT_ALIQCOF, FT_CSTPIS, FT_CSTCOF, FT_CODBCC, FT_CONTA, FT_MALQCOF, FT_MVALCOF, FT_CHVNFE, FT_BASEICM, FT_VALICM, FT_ALIQICM								
	FROM %Table:SFT% SFT								
	WHERE 								
	FT_FILIAL  BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND								
	FT_ENTRADA BETWEEN %Exp:mv_par03% AND %Exp:mv_par04% AND 								
	SUBSTRING(FT_CFOP,1,1) IN ('1','2','3','0')								
	AND FT_DTCANC = ''
	AND FT_TIPOMOV = 'E'
	AND	SFT.%NotDel% 								
	GROUP BY FT_FILIAL,FT_SERIE,FT_NFISCAL,FT_PRODUTO,FT_ITEM,FT_ESPECIE,FT_ENTRADA,FT_CFOP,FT_ESTADO,FT_CLIEFOR,FT_LOJA,FT_BASEPIS,FT_VALPIS,FT_VALCOF,FT_VALCONT,FT_ALIQPIS,								
	FT_ALIQCOF, FT_CSTPIS, FT_CSTCOF, FT_CODBCC, FT_CONTA, FT_MALQCOF, FT_MVALCOF,FT_CHVNFE, FT_BASEICM, FT_VALICM, FT_ALIQICM									
	ORDER BY FT_FILIAL, FT_CLIEFOR, FT_LOJA,FT_NFISCAL, FT_ITEM								
EndSql									
									
dbSelectArea("TMP")									
TMP->(dbGotop())									
ProcRegua(RecCount())									
ncount:= 0									
do while TMP->(!eof())									
	//Posicionando tabelas								
	IncProc("Gravando Informacoes...."+TMP->FT_FILIAL+ " Produto "+TMP->FT_PRODUTO)								
	cTipo := 'N'								
	if SB1->(dbSeek(xFilial("SB1") + TMP->FT_PRODUTO))								
									
    endif									
									
	if SBM->(dbSeek(xFilial("SBM") + SB1->B1_GRUPO)) //compartilhado								
									
	endif 								
	if !SD1->(dbSeek(TMP->FT_FILIAL + TMP->FT_NFISCAL + TMP->FT_SERIE + TMP->FT_CLIEFOR + TMP->FT_LOJA + TMP->FT_PRODUTO + TMP->FT_ITEM))								
		TMP->(dbSkip())							
	endif								
	//Posiciona Item na NS entrada (Localizar TES)								
	if SD1->(dbSeek(TMP->FT_FILIAL + TMP->FT_NFISCAL + TMP->FT_SERIE + TMP->FT_CLIEFOR + TMP->FT_LOJA + TMP->FT_PRODUTO + TMP->FT_ITEM))								
		cTipo := SD1->D1_TIPO							
	endif 								
	if cTipo $ 'D|B'								
		if SA1->(dbSeek(xFilial("SA1") + TMP->FT_CLIEFOR+TMP->FT_LOJA)) //compartilhado							
									
		endif 							
	 else								
		if SA2->(dbSeek(xFilial("SA2") + TMP->FT_CLIEFOR+TMP->FT_LOJA)) //compartilhado							
									
		endif 							
	endif								
									
	Reclock("CTB",.T.)								
	CTB->FILIAL   := TMP->FT_FILIAL								
	CTB->NFSER	  := TMP->FT_SERIE							
	CTB->NFNUM    := TMP->FT_NFISCAL								
	CTB->NFITEM   := TMP->FT_ITEM								
	CTB->TIPONF	  := cTipo							
	CTB->ESPECIE  := TMP->FT_ESPECIE								
	CTB->GRUPO    := Posicione("SB1",1,xFilial("SB1")+TMP->FT_PRODUTO,"B1_GRUPO") //SB1->B1_GRUPO																
	CTB->DTENT 	  := STOD(TMP->FT_ENTRADA)							
	CTB->DESCGRP  := SBM->BM_DESC								
	CTB->NCM	  := SB1->B1_POSIPI							
									
	CTB->FORNEC	  := TMP->FT_CLIEFOR							
	CTB->LOJAFORN := TMP->FT_LOJA								
	CTB->NFORNEC  := iif(cTipo $ 'D|B', SA1->A1_NOME, SA2->A2_NOME)								
	CTB->EST	  := TMP->FT_ESTADO							
									
	CTB->CODPRO	  := TMP->FT_PRODUTO							
	CTB->DESCP	  := SB1->B1_DESC							
	CTB->CFOP	  := TMP->FT_CFOP							
	CTB->BPIS	  := TMP->FT_BASEPIS							
	CTB->PIS	  := TMP->FT_VALPIS							
	CTB->COF	  := TMP->FT_VALCOF							
	CTB->ALPIS	  := TMP->FT_ALIQPIS							
	CTB->ALCOF	  := TMP->FT_ALIQCOF							
	CTB->VTOT	  := TMP->FT_VALCONT

	CTB->BASICM	  := TMP->FT_BASEICM
	CTB->ALICMS	  := TMP->FT_ALIQICM						
	CTB->VLICMS	  := TMP->FT_VALICM	
	
	CTB->VTOTAL	  := SD1->D1_TOTAL							
	CTB->TES	  := SD1->D1_TES							
	CTB->CSTPIS   := TMP->FT_CSTPIS								
	CTB->CSTCOF   := TMP->FT_CSTCOF								
	CTB->CODBCC   := TMP->FT_CODBCC								
	CTB->UM		  := SD1->D1_UM						
	CTB->CCUSTO	  := SD1->D1_CC							
//	CTB->CONIND	  := SB1->B1_CONIND							
//	CTB->ESTDIR	  := SB1->B1_ESTDIR 							
//	CTB->GERAIS	  := SB1->B1_GERAIS							
	CTB->CONTA	  := TMP->FT_CONTA							
	CTB->ALQCOFM  := TMP->FT_MALQCOF								
	CTB->VLRCOFM  := TMP->FT_MVALCOF								
	CTB->CHAVENF  := TMP->FT_CHVNFE								
	Msunlock("CTB")								
									
	nPosPed	:=	Ascan(aAcum,TMP->FT_CFOP)						
	If nPosPed == 0								
		AAdd(aAcum,{TMP->FT_CFOP,TMP->FT_BASEPIS,TMP->FT_VALPIS,TMP->FT_VALCOF,TMP->FT_VALCONT})							
	Else								
		aAcum[nPosPed][2] := aAcum[nPosPed][2] + TMP->FT_BASEPIS							
		aAcum[nPosPed][3] := aAcum[nPosPed][3] + TMP->FT_VALPIS							
		aAcum[nPosPed][4] := aAcum[nPosPed][4] + TMP->FT_VALCOF							
		aAcum[nPosPed][5] := aAcum[nPosPed][5] + TMP->FT_VALCONT							
	Endif								
	ncount++								
	MD1->(dbCloseArea())								
	TMP->(dbSkip())								
enddo 									
Alert("Encerrado temporario..."+cValToChar(nCount)+" registros" )									
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
									
