#INCLUDE "Protheus.ch"  

///////////////////////////////////////////////////////////////////////////////
//Relatorio de Venda X Custo de producao
//Gera um relatorio com o valor vendido em determinado periodo e busca o custo de producao
//////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br -07-08-2012
///////////////////////////////////////////////////////////////////////////////

User Function AG_RLFRET()
Processa( {|lEnd| GeraFrt(@lEnd)}, "Aguarde...","Filtrando conhecimentos de frete...", .T. )

return

static function GeraFrt(lEnd)		
Local cQuery := ""          
Private cPerg   := "AG_RLFRT"
if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
endif
Pergunte(cPerg,.T.)      


//Busca o custo unitario das MODs no periodo
if Select('TRB') > 0
	dbSelectArea('TRB')
	TRB->(dbCloseArea())
endif

cQuery := " Select ZM_NUMCONH CONHEC, ZM_DTCONHE DTCONHE, ZM_TRANSP CODTRAN, A2_NOME NOMETRAN, ZM_NFISCAL NOTA,  ZM_SERIE SERIE, "
cQuery += " ZM_FILIAL FILIAL, ZM_VALCONH VALCONHE, ZM_VALFRET VALFRET, ZM_CLIENTE CLIE_FOR, ZM_LOJCLI LOJA, F2_VALBRUT VALBRUT, F2_TIPO TIPO, "
cQuery += " A1_NOME NOME, A1_END ENDERECO, A1_MUN MUNICIPIO, A1_EST UF, F2_EMISSAO EMISSAO, F2_VOLUME1 VOLUME, F2_PBRUTO PESO, ZM_TPNOTA, ZM_ORIGDES, ZM_DESTINO "
cQuery += " from SZM010 SZM, SA2010 SA2, SA1010 SA1, SF2010 SF2 "
cQuery += " where SZM.D_E_L_E_T_ = ' ' and SA2.D_E_L_E_T_ =' ' and SA1.D_E_L_E_T_ =' ' and SF2.D_E_L_E_T_ =' ' " 
cQuery += " and A2_COD = ZM_TRANSP and A2_LOJA = ZM_LJTRANS and ZM_CLIENTE = A1_COD and ZM_LOJCLI = A1_LOJA "
cQuery += " AND F2_DOC = ZM_NFISCAL and F2_SERIE = ZM_SERIE AND F2_CLIENTE = ZM_CLIENTE and F2_LOJA = ZM_LOJCLI "
cQuery += " and ZM_DTCONHE between '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
cQuery += " and ZM_FILIAL between '"+mv_par03+"' AND '"+mv_par04+"' "
cQuery += " union all " 
cQuery += " Select ZM_NUMCONH CONHEC, ZM_DTCONHE DTCONHE, ZM_TRANSP CODTRAN, A2_NOME NOMETRAN, ZM_NFISCAL NOTA,  ZM_SERIE SERIE, "
cQuery += " ZM_FILIAL FILIAL, ZM_VALCONH VALCONHE, ZM_VALFRET VALFRET, ZM_CLIENTE CLIE_FOR, ZM_LOJCLI LOJA, F1_VALBRUT VALBRUT, F1_TIPO TIPO, "
cQuery += " A2_NOME NOME, A2_END ENDERECO, A2_MUN MUNICIPIO, A2_EST UF, F1_EMISSAO EMISSAO, F1_VOLUME1 VOLUME, F1_PBRUTO PESO, ZM_TPNOTA, ZM_ORIGDES, ZM_DESTINO "
cQuery += " from SZM010 SZM, SA2010 SA2, SF1010 SF1 "
cQuery += " where SZM.D_E_L_E_T_ = ' ' and SA2.D_E_L_E_T_ =' ' and SA2.D_E_L_E_T_ =' ' "
cQuery += " and A2_COD = ZM_TRANSP and A2_LOJA = ZM_LJTRANS "
cQuery += " AND F1_DOC = ZM_NFISCAL and F1_SERIE = ZM_SERIE AND F1_FORNECE = ZM_CLIENTE and F1_LOJA = ZM_LOJCLI "
cQuery += " and ZM_DTCONHE between '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' " 
cQuery += " and ZM_FILIAL between '"+mv_par03+"' AND '"+mv_par04+"' "                                      

dbUseArea(.T., "TOPCONN", tcGenQry(,, cQuery ),"TRB", .T.,.T.)

MemoWrite("C:\temp\REL_FRETE.TXT", cQuery) 


//Arquivo temporario da funcao para geracao do relatorio
aTMP	:= {}
AADD(aTMP,{"FILIAL"			, "C", 02, 0 } )
AADD(aTMP,{"ORIGDES"		, "C", 60, 0 } )
AADD(aTMP,{"DESTINO"		, "C", 60, 0 } )
AADD(aTMP,{"CONHEC"	   		, "C", 09, 0 } )
AADD(aTMP,{"DTCONHE" 	    , "C", 10, 0 } )
AADD(aTMP,{"TPNOTA" 	    , "C", 06, 0 } )
AADD(aTMP,{"CODTRAN"        , "C", 06, 0 } )
AADD(aTMP,{"NOMETRAN"       , "C", 50, 0 } )
AADD(aTMP,{"NOTA" 			, "C", 09, 0 } )
AADD(aTMP,{"SERIE" 	   		, "C", 03, 0 } )
AADD(aTMP,{"VALCONHE"		, "N", 15, 2 } )
AADD(aTMP,{"VALFRET" 		, "N", 15, 2 } )
AADD(aTMP,{"VALBRUT" 		, "N", 15, 2 } )
AADD(aTMP,{"NOME"      	 	, "C", 50, 0 } )
AADD(aTMP,{"ENDERECO"       , "C", 40, 0 } )
AADD(aTMP,{"MUNICIPIO"      , "C", 30, 0 } )
AADD(aTMP,{"UF"       		, "C", 02, 0 } )
AADD(aTMP,{"EMISSAO" 		, "C", 10, 0 } )
AADD(aTMP,{"VOLUME"			, "N", 15, 2 } )
AADD(aTMP,{"PESO" 	  		, "N", 15, 2 } )

ctrTMP := CriaTrab(aTMP, .T.)
dbUseArea(.T.,,ctrTMP,"TMP",.F.,.F.)
INDEX ON FILIAL + NOTA to &ctrTMP

dbSelectArea('TRB')
TRB->(dbGotop())
While !TRB->(eof())
	RecLock("TMP",.T.)
	TMP->FILIAL		:= TRB->FILIAL
	TMP->ORIGDES    := TRB->ZM_ORIGDES
	TMP->DESTINO    := TRB->ZM_DESTINO
	TMP->CONHEC    	:= TRB->CONHEC
	TMP->DTCONHE	:= dToc(stod(TRB->DTCONHE))
	TMP->TPNOTA		:= iif(TRB->ZM_TPNOTA=="C","COMPRA","VENDA")
	TMP->CODTRAN	:= TRB->CODTRAN
	TMP->NOMETRAN   := TRB->NOMETRAN
	TMP->NOTA		:= TRB->NOTA
	TMP->SERIE		:= TRB->SERIE
	TMP->VALCONHE	:= TRB->VALCONHE
	TMP->VALFRET	:= TRB->VALFRET
	TMP->VALBRUT	:= TRB->VALBRUT
	TMP->NOME  		:= iif(TRB->TIPO == "B", Posicione("SA1", 1, xFilial("SA1")+TRB->(CLIE_FOR+LOJA), "A1_NOME"), TRB->NOME     )
	TMP->ENDERECO	:= iif(TRB->TIPO == "B", Posicione("SA1", 1, xFilial("SA1")+TRB->(CLIE_FOR+LOJA), "A1_END" ), TRB->ENDERECO )
	TMP->MUNICIPIO	:= iif(TRB->TIPO == "B", Posicione("SA1", 1, xFilial("SA1")+TRB->(CLIE_FOR+LOJA), "A1_MUN" ), TRB->MUNICIPIO)
	TMP->UF			:= iif(TRB->TIPO == "B", Posicione("SA1", 1, xFilial("SA1")+TRB->(CLIE_FOR+LOJA), "A1_EST" ), TRB->UF       )
	TMP->EMISSAO	:= dToc(stod(TRB->EMISSAO))
	TMP->VOLUME		:= TRB->VOLUME
	TMP->PESO       := TRB->PESO
//	Alert("DATA-> "+dToc(stod(TMP->DTCONHE))+" DT1-> "+TRB->DTCONHE+" DT2 "+dtos(ctod(TMP->DTCONHE)))
	MsUnLock("TMP")
	TRB->(dbSkip())
enddo

dbSelectArea("TMP")
TMP->(dbGotop())
//If TRepInUse()
	//Gera as definicoes do relatorio
	oReport := ReportDef()
	//Monta interface com o usuário
	oReport:PrintDialog()
//endif



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


oReport := TReport():New(cPerg,"Relatorio de Composicao Frete",cPerg,{|oReport| Printreport(oReport)},;
				"Relatorio de Composicao de Frete ")
//Cria a Seção do relatorio
oSection1 := TRSection():New(oReport,"Relatorio de Composicao de Frete",{"TMP"},/*Ordem*/)

/*	TMP->FILIAL		:= TRB->FILIAL
	TMP->CONHEC    	:= TRB->CONHEC
	TMP->DTCONHE	:= dToc(stod(TRB->DTCONHE))
	TMP->TPNOTA		:= iif(TRB->ZM_TPNOTA=="C","COMPRA","VENDA")
	TMP->CODTRAN	:= TRB->CODTRAN
	TMP->NOMETRAN   := TRB->NOMETRAN
	TMP->NOTA		:= TRB->NOTA
	TMP->SERIE		:= TRB->SERIE
	TMP->VALCONHE	:= TRB->VALCONHE
	TMP->VALFRET	:= TRB->VALFRET
	TMP->VALBRUT	:= TRB->VALBRUT
	TMP->NOME  		:= TRB->NOME
	TMP->ENDERECO	:= TRB->ENDERECO
	TMP->MUNICIPIO	:= TRB->MUNICIPIO
	TMP->UF			:= TRB->UF
	TMP->EMISSAO	:= dToc(stod(TRB->EMISSAO))
	TMP->VOLUME		:= TRB->VOLUME
	TMP->PESO       := TRB->PESO
  */
	//Cria as celulas do relatório 
	TRCell():New(oSection1,"FILIAL"		   	,"TMP","Filial         ","@!"					,02,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"CONHEC"			,"TMP","Num.Conheciment","@!"					,09,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"DTCONHE"		,"TMP","Dt.Conheicmento",""						,10,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"TPNOTA"			,"TMP","Tipo Nota      ",""						,06,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"CODTRAN"	   	,"TMP","Cod.Transp"		,"@!"					,06,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"NOMETRAN"   	,"TMP","Nome Transp"	,"@!"					,50,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"NOTA"			,"TMP","Nota Fiscal"	,"@!"					,09,/*TAMPIXEL*/,/*BLOCO*/)	
	TRCell():New(oSection1,"SERIE"			,"TMP","Serie          ","@!"   				,03,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"VALCONHE"		,"TMP","Vlr Conheciment","@E 9,999,999.99"		,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"VALFRET"		,"TMP","      Vlr.Frete","@E 9,999,999.99"		,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"VALBRUT"	    ,"TMP","      Vlr.Bruto","@E 9,999,999.99"		,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"NOME"	    	,"TMP","Cliente/Forn   ","@E!"            		,50,/*TAMPIXEL*/,/*BLOCO*/)	
	TRCell():New(oSection1,"ENDERECO"	    ,"TMP","Endereco       ","@E!"             		,40,/*TAMPIXEL*/,/*BLOCO*/)	
	TRCell():New(oSection1,"MUNICIPIO"		,"TMP","Municipio      ","@E!"          		,30,/*TAMPIXEL*/,/*BLOCO*/)	
	TRCell():New(oSection1,"UF"	        	,"TMP","UF	           ","@E!"            		,02,/*TAMPIXEL*/,/*BLOCO*/)		
	TRCell():New(oSection1,"ORIGDES"   		,"TMP","Origem"			,"@!"					,50,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"DESTINO"   		,"TMP","Destino"		,"@!"					,50,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"EMISSAO"	    ,"TMP","Emissao        ",""                		,10,/*TAMPIXEL*/,/*BLOCO*/)		
	TRCell():New(oSection1,"VOLUME"	        ,"TMP","  		 Volume","@E 9,999,999"		    ,15,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"PESO"	        ,"TMP","  		   Peso","@E 9,999,999.99"		,15,/*TAMPIXEL*/,/*BLOCO*/)
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
PutSx1(cPerg,"01","Data Inicial                  ?"," "," ","mv_ch1","D",8,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo inicial"},{"Informe o periodo inicial"},{"Informe o periodo inicial"})
PutSx1(cPerg,"02","Data final                    ?"," "," ","mv_ch2","D",8,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo final"},{"Informe o periodo final"},{"Informe o periodo final"})
PutSx1(cPerg,"03","Filial de                     ?"," "," ","mv_ch3","C",02,0,0,"G","","   ","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a filial inicial "},{"Informe a filial inicia  "},{"Informe a filial inicial "})
PutSx1(cPerg,"04","Filial ate                    ?"," "," ","mv_ch4","C",02,0,0,"G","","   ","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a filial final "},{"Informe a filial final "},{"Informe a filial final "})
//PutSx1(cPerg,"05","Grupo Inicial                 ?"," "," ","mv_ch5","C",04,0,0,"G","","SBM","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o grupo inicial"},{"Informe o grupo inicial"},{"Informe o grupo inicial"})
//PutSx1(cPerg,"06","Grupo Final                   ?"," "," ","mv_ch6","C",04,0,0,"G","","SBM","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o grupo final"},{"Informe o grupo final"},{"Informe o grupo final"})

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