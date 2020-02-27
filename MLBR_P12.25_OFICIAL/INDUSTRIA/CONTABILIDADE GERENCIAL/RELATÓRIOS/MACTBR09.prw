#INCLUDE "PROTHEUS.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TOPCONN.CH"

#DEFINE PICVAL  "@E 999,999,999.99"

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori
//|Funcao....: MACTBR09()
//|Autor.....: Jose Roberto de Souza  -  Taggs Consultoria
//|Data......: 14 de junho de 2010
//|Uso.......: SIGACTB
//|Versao....: Protheus - 10
//|Descricao.: Relatorio resumo de operações COP
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function MACTBR09()
*-----------------------------------------*
Private cTitulo  	:= "Resumo de Operações CFOP"
Private aArea    	:= GetArea()
Private aConteud 	:= {}
Private aConteud1	:= {}
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cPerg  		:= PADR("MACTBR09",10)
Private nFilImpVez 	:= 0
If !SX1->(dbSeek(cPerg))
	ValidPerg(cPerg)
EndIf

If !Pergunte(cPerg,.T. )
	Return
Endif

Processa({|| MCTR09()},'Analisando Dados...')

Return .T.

//+-----------------------------------------------------------------------------------//
//|Funcao....: MCTR09()
//|Autor.....: Jose Roberto deSouza - Taggs Consultoria
//|Uso.......: SIGACTB
//|Descricao.: Gera relatorio de resumo de CFOP (Entradas e saidas)
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MCTR09()
*-----------------------------------------*
Local nKK
Private aAreaNF		:= GetArea()
Private cCab		:= ""
Private cAcum		:= 0
Private nVCONT		:= 0
Private nVMER		:= 0
Private nVFRETE		:= 0
Private nVIPI		:= 0
Private nVICM		:= 0
Private nVPIS		:= 0
Private nVCOF		:= 0
Private nAcumLiq	:= 0
Private nAcumL 		:= 0

//----------------ENTRADAS CONSOLICADO CONFORME PARAMETRO DE FILIAL ---------------------------------------
//+-------------------------------------------//
//| Faz Select selecionando os dados da CFOP
//+-------------------------------------------//
cQuery := ""
cQuery += " SELECT FT_CFOP,  "
cQuery += " SUM(FT_VALCONT)	AS VCONT,   "
cQuery += " SUM(FT_FRETE)	AS VFRETE,  "
cQuery += " SUM(FT_VALIPI)	AS VIPI,  "
cQuery += " SUM(FT_VALICM)	AS VICM,  "
cQuery += " SUM(FT_VALPIS)	AS VPIS,  "
cQuery += " SUM(FT_VALCOF)	AS VCOF,  "
cQuery += " SUM(FT_VALICM)	AS VICM,  "
cQuery += " SUM(FT_TOTAL)	AS VMER   "
cQuery += " FROM " + RETSQLNAME("SFT")
cQuery += " WHERE "
cQuery += " FT_FILIAL  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02 + "'AND "
cQuery += " FT_ENTRADA BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04) + "' AND "
cQuery += " SUBSTRING(FT_CFOP,1,1) IN ('1','2','3','4') AND FT_OBSERV <> 'NF CANCELADA' "
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " GROUP BY FT_CFOP "
cQuery += " ORDER BY FT_CFOP "
TcQuery cQuery New Alias "TNF"


aAdd(aConteud,{"RELATORIO RESUMO DE CFOP","","","","","","","","","",""})
aAdd(aConteud,{"CONSOLIDADO  "+DTOC(MV_PAR03)+" ATÉ "+ DTOC(MV_PAR04),"","","","","","","","","","",})
aAdd(aConteud,{"ENTRADAS","","","","","","","","","",""})
aAdd(aConteud,{"","","","","","","","","","","",})

//Tabulaçao       1        2               3              4                    5       6      7     8     9      10      11           
aAdd(aConteud,{"FILIAL","CFOP DESCRIÇÃO","VALOR TOTAL","VALOR PROD/SERVIÇOS","FRETE","IPI","ICMS","PIS","COFINS","ISS","VALOR LIQUIDO"})



do While TNF->(!EOF())
	//Fazer validaçoes em outras tabelas
	If SX5->(dbSeek(xFilial("SX5")+"13"+TNF->FT_CFOP))
		cTxt := SX5->X5_DESCRI
	EndIf
	//Acumuladores 2-(6+7+8+9+10)
	nAcumLiq := TNF->VCONT-(TNF->VFRETE+TNF->VIPI+TNF->VICM+TNF->VPIS+TNF->VCOF)
	//Tabulaçao       1        2               3              4                    5       6      7     8     9      10      11           
	aAdd(aConteud,{TNF->FT_CFOP,cTxt,TNF->VCONT,TNF->VMER,TNF->VFRETE,TNF->VIPI,TNF->VICM,TNF->VPIS,TNF->VCOF,,nAcumLiq})
	nVCONT   := nVCONT  + TNF->VCONT
	nVMER    := nVMER   + TNF->VMER
	nVFRETE  := nVFRETE + TNF->VFRETE
	nVIPI    := nVIPI   + TNF->VIPI
	nVICM    := nVICM   + TNF->VICM
	nVPIS    := nVPIS   + TNF->VPIS
	nVCOF    := nVCOF   + TNF->VCOF
	nAcumL   := nAcumL  + nAcumLiq
	TNF->(dbSkip())
EndDo
TNF->(dbCloseArea())
aAdd(aConteud,{"","","","","","","","","","","",})

//aAdd(aConteud,{TNF->FT_CFOP,cTxt                ,TNF->VCONT,TNF->VMER,TNF->VFRETE,TNF->VIPI,TNF->VICM,TNF->VPIS,TNF->VCOF,,nAcumLiq})
aAdd(aConteud,{""          ,"TOTAIS ENTRADAS-->",nVCONT    ,nVMER    ,nVFRETE    ,nVIPI    ,nVICM    ,nVPIS    ,nVCOF    ,,nAcumL})


//----------------SAIDAS CONSOLICADO CONFORME PARAMETRO DE FILIAL ---------------------------------------


aAdd(aConteud,{"","","","","","","","","","",""})
aAdd(aConteud,{"","","","","","","","","","",""})
aAdd(aConteud,{"","","","","","","","","","",""})

aAdd(aConteud,{"SAIDAS","","","","","","","","","",""})
aAdd(aConteud,{"","","","","","","","","","",""})
//aAdd(aConteud,{"CFOP","DESCRIÇÃO CFOP","VALOR TOTAL","VALOR PROD/SERVIÇOS","FRETE","IPI","ICMS","PIS","ISS","VALOR LIQUIDO"})
//Tabulaçao       1        2               3              4                    5       6      7     8     9      10      11           
aAdd(aConteud,{"FILIAL","CFOP DESCRIÇÃO","VALOR TOTAL","VALOR PROD/SERVIÇOS","FRETE","IPI","ICMS","PIS","COFINS","ISS","VALOR LIQUIDO"})

cQuery := ""
cQuery += " SELECT FT_CFOP,  "
cQuery += " SUM(FT_VALCONT)	AS VCONT,   "
cQuery += " SUM(FT_FRETE)	AS VFRETE,  "
cQuery += " SUM(FT_VALIPI)	AS VIPI,  "
cQuery += " SUM(FT_VALICM)	AS VICM,  "
cQuery += " SUM(FT_VALPIS)	AS VPIS,  "
cQuery += " SUM(FT_VALCOF)	AS VCOF,  "
cQuery += " SUM(FT_VALICM)	AS VICM,  "
cQuery += " SUM(FT_TOTAL)	AS VMER   "
cQuery += " FROM " + RETSQLNAME("SFT")
cQuery += " WHERE "
cQuery += " FT_FILIAL  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02 + "'AND "
cQuery += " FT_ENTRADA BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04) + "' AND "
cQuery += " SUBSTRING(FT_CFOP,1,1) IN ('5','6','7','8') AND FT_OBSERV <> 'NF CANCELADA' "
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " GROUP BY FT_CFOP "
cQuery += " ORDER BY FT_CFOP "
TcQuery cQuery New Alias "TNF"
ZeraAcum()

do While TNF->(!EOF())
	//Fazer validaçoes em outras tabelas
	If SX5->(dbSeek(xFilial("SX5")+"13"+TNF->FT_CFOP))
		cTxt := SX5->X5_DESCRI
	EndIf
	//Acumuladores 2-(6+7+8+9+10)
	nAcumLiq := TNF->VCONT-(TNF->VFRETE+TNF->VIPI+TNF->VICM+TNF->VPIS+TNF->VCOF)
	aAdd(aConteud,{TNF->FT_CFOP,cTxt,TNF->VCONT,TNF->VMER,TNF->VFRETE,TNF->VIPI,TNF->VICM,TNF->VPIS,TNF->VCOF,,nAcumLiq})
	nVCONT   := nVCONT  + TNF->VCONT
	nVMER    := nVMER   + TNF->VMER
	nVFRETE  := nVFRETE + TNF->VFRETE
	nVIPI    := nVIPI   + TNF->VIPI
	nVICM    := nVICM   + TNF->VICM
	nVPIS    := nVPIS   + TNF->VPIS
	nVCOF    := nVCOF   + TNF->VCOF
	nAcumL   := nAcumL  + nAcumLiq
	TNF->(dbSkip())
EndDo
TNF->(dbCloseArea())

aAdd(aConteud,{"","","","","","","","","","","",})
//aAdd(aConteud,{TNF->FT_CFOP,cTxt                ,TNF->VCONT,TNF->VMER,TNF->VFRETE,TNF->VIPI,TNF->VICM,TNF->VPIS,TNF->VCOF,,nAcumLiq})
aAdd(aConteud,{""          ,"TOTAIS SAIDAS-->",nVCONT    ,nVMER    ,nVFRETE    ,nVIPI    ,nVICM    ,nVPIS    ,nVCOF    ,,nAcumL})
aAdd(aConteud,{"","","","","","","","","","","",})
aAdd(aConteud,{"","","","","","","","","","","",})



//----------------------------------RESUMO DE OPERACOES POR FILIAL -----------------------------------------------------

//TOTALIZADORES POR FILIAL 
aAdd(aConteud,{"TOTALIZADOR POR FILIAL","","","","","","","","","","",})

//---seleciona as filiais a serem processadas
cQuery := " SELECT "
cQuery += " FT_FILIAL "
cQuery += " FROM " + RETSQLNAME("SFT")
cQuery += " WHERE "
cQuery += " FT_ENTRADA BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04) + "' AND "
cQuery += " FT_FILIAL  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02 + "'AND "
cQuery += " D_E_L_E_T_ <> '*' "
cQuery += " GROUP BY FT_FILIAL "
cQuery += " ORDER BY FT_FILIAL "
TcQuery cQuery New Alias "FIL"


aAdd(aConteud,{"RESUMO POR FILIAL","","","","","","","","","",""})
aAdd(aConteud,{"","","","","","","","","","","",})

//Processa filiais
do while FIL->(!eof())
	//SELECIONA ENTRADAS
	cQuery := ""
	cQuery += " SELECT FT_CFOP, FT_FILIAL, "
	cQuery += " SUM(FT_VALCONT)	AS VCONT,   "
	cQuery += " SUM(FT_FRETE)	AS VFRETE,  "
	cQuery += " SUM(FT_VALIPI)	AS VIPI,  "
	cQuery += " SUM(FT_VALICM)	AS VICM,  "
	cQuery += " SUM(FT_VALPIS)	AS VPIS,  "
	cQuery += " SUM(FT_VALCOF)	AS VCOF,  "
	cQuery += " SUM(FT_VALICM)	AS VICM,  "
	cQuery += " SUM(FT_TOTAL)	AS VMER   "
	cQuery += " FROM " + RETSQLNAME("SFT")
	cQuery += " WHERE "
	cQuery += " FT_ENTRADA BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04) + "' AND "
	cQuery += " FT_FILIAL  BETWEEN '"+FIL->FT_FILIAL+"' AND '"+FIL->FT_FILIAL + "'AND "
	cQuery += " SUBSTRING(FT_CFOP,1,1) IN ('1','2','3','4') AND FT_OBSERV <> 'NF CANCELADA' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	cQuery += " GROUP BY FT_FILIAL,FT_CFOP "
	cQuery += " ORDER BY FT_FILIAL,FT_CFOP "
	TcQuery cQuery New Alias "TNE"
	aAdd(aConteud,{"ENTRADAS","","","","","","","","","","",})
	aAdd(aConteud,{"","","","","","","","","","","",})

	//Tabulaçao       1        2               3              4                    5       6      7     8     9      10      11           
	aAdd(aConteud,{"FILIAL","CFOP DESCRIÇÃO","VALOR TOTAL","VALOR PROD/SERVIÇOS","FRETE","IPI","ICMS","PIS","COFINS","ISS","VALOR LIQUIDO"})
	aAdd(aConteud,{"","","","","","","","","","","",})
	ZeraAcum()
	do While TNE->(!EOF())
		cVarFil := TNE->FT_FILIAL
		nFilImpVez := 1 //imprime o nome da filial somente uma vez
		do while TNE->FT_FILIAL = cVarFil
			If SX5->(dbSeek(xFilial("SX5")+"13"+TNE->FT_CFOP))
				cTxt := SX5->X5_DESCRI
			EndIf
			//Acumuladores 2-(6+7+8+9+10)
			nAcumLiq := TNE->VCONT-(TNE->VFRETE+TNE->VIPI+TNE->VICM+TNE->VPIS+TNE->VCOF)
			if nFilImpVez = 1
				//Tabulaçao       1                                     2                 3          4         5           6         7         8     9   10        11           
				aAdd(aConteud,{TNE->FT_FILIAL+"-"+NomeFil("01",cVarFil),TNE->FT_CFOP+cTxt,TNE->VCONT,TNE->VMER,TNE->VFRETE,TNE->VIPI,TNE->VICM,TNE->VPIS,TNE->VCOF,,nAcumLiq})
			else
				//Tabulaçao       1                                     2                 3          4         5           6         7         8     9   10        11           
				aAdd(aConteud,{"" 									   ,TNE->FT_CFOP+cTxt,TNE->VCONT,TNE->VMER,TNE->VFRETE,TNE->VIPI,TNE->VICM,TNE->VPIS,TNE->VCOF,,nAcumLiq})
			endif
			nFilImpVez := 0 //imprime o nome da filial somente uma vez
			nVCONT   := nVCONT  + TNE->VCONT
			nVMER    := nVMER   + TNE->VMER
			nVFRETE  := nVFRETE + TNE->VFRETE
			nVIPI    := nVIPI   + TNE->VIPI
			nVICM    := nVICM   + TNE->VICM
			nVPIS    := nVPIS   + TNE->VPIS
			nVCOF    := nVCOF   + TNE->VCOF
			nAcumL   := nAcumL  + nAcumLiq
			TNE->(dbSkip())
		enddo
		//Imprime o resultado por filial.
		aAdd(aConteud,{"","","","","","","","","","","",})
		aAdd(aConteud,{""          ,"TOTAIS ENTRADAS FILIAL: "+NomeFil("01",cVarFil),nVCONT    ,nVMER    ,nVFRETE    ,nVIPI    ,nVICM    ,nVPIS    ,nVCOF    ,,nAcumL})
		//Totalizador das entradas  
		aAdd(aConteud1,{""          ,"TOTAIS ENTRADAS FILIAL: "+NomeFil("01",cVarFil),nVCONT    ,nVMER    ,nVFRETE    ,nVIPI    ,nVICM    ,nVPIS    ,nVCOF   ,,nAcumL})
		//-->
		ZeraAcum()
		TNE->(dbSkip())
	EndDo
	TNE->(dbCloseArea())

	
	//SELECIONA SAÍDS
	nFilImpVez := 0 //imprime o nome da filial somente uma vez
	aAdd(aConteud,{"","","","","","","","","","","",})
	aAdd(aConteud,{"SAIDAS","","","","","","","","","","",})

	//Tabulaçao       1        2               3              4                    5       6      7     8     9      10      11           
	aAdd(aConteud,{"FILIAL","CFOP DESCRIÇÃO","VALOR TOTAL","VALOR PROD/SERVIÇOS","FRETE","IPI","ICMS","PIS","COFINS","ISS","VALOR LIQUIDO"})
	
	//SELECIONA AS SAIDAS DA MESMA FILIAL
	cQuery := ""
	cQuery += " SELECT FT_CFOP, FT_FILIAL, "
	cQuery += " SUM(FT_VALCONT)	AS VCONT,  "
	cQuery += " SUM(FT_FRETE)	AS VFRETE, "
	cQuery += " SUM(FT_VALIPI)	AS VIPI,  "
	cQuery += " SUM(FT_VALICM)	AS VICM,  "
	cQuery += " SUM(FT_VALPIS)	AS VPIS,  "
	cQuery += " SUM(FT_VALCOF)	AS VCOF,  "
	cQuery += " SUM(FT_VALICM)	AS VICM,  "
	cQuery += " SUM(FT_TOTAL)	AS VMER   "
	cQuery += " FROM " + RETSQLNAME("SFT")
	cQuery += " WHERE "
	cQuery += " FT_ENTRADA BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04) + "' AND "
	cQuery += " FT_FILIAL  BETWEEN '"+FIL->FT_FILIAL+"' AND '"+FIL->FT_FILIAL + "'AND "
	cQuery += " SUBSTRING(FT_CFOP,1,1) IN ('5','6','7','8') AND FT_OBSERV <> 'NF CANCELADA' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	cQuery += " GROUP BY FT_FILIAL,FT_CFOP "
	cQuery += " ORDER BY FT_FILIAL,FT_CFOP "
	TcQuery cQuery New Alias "TNS"
	do While TNS->(!EOF())
		cVarFil := TNS->FT_FILIAL
		nFilImpVez := 1 //imprime o nome da filial somente uma vez
		do while TNS->FT_FILIAL = cVarFil
			If SX5->(dbSeek(xFilial("SX5")+"13"+TNS->FT_CFOP))
				cTxt := SX5->X5_DESCRI
			EndIf
			//Acumuladores 2-(6+7+8+9+10)
			nAcumLiq := TNS->VCONT-(TNS->VFRETE+TNS->VIPI+TNS->VICM+TNS->VPIS+TNS->VCOF)
			if nFilImpVez = 1
				//			aAdd(aConteud,{TNS->FT_CFOP,cTxt,TNS->FT_FILIAL+"-"+NomeFil("01",cVarFil),TNS->VCONT,TNS->VMER,TNS->VFRETE,TNS->VIPI,TNS->VICM,TNS->VPIS,TNS->VCOF,,nAcumLiq})
				aAdd(aConteud,{TNS->FT_FILIAL+"-"+NomeFil("01",cVarFil),TNS->FT_CFOP+cTxt,TNS->VCONT,TNS->VMER,TNS->VFRETE,TNS->VIPI,TNS->VICM,TNS->VPIS,TNS->VCOF,,nAcumLiq})
			else
				aAdd(aConteud,{"" 									   ,TNS->FT_CFOP+cTxt,TNS->VCONT,TNS->VMER,TNS->VFRETE,TNS->VIPI,TNS->VICM,TNS->VPIS,TNS->VCOF,,nAcumLiq})
			endif
			nFilImpVez := 0 //imprime o nome da filial somente uma vez
			
			//		nAcumLiq := TNS->VCONT-(TNS->VFRETE+TNS->VIPI+TNS->VICM+TNS->VPIS+TNS->VCOF)
			//		aAdd(aConteud,{TNS->FT_FILIAL+"-"+NomeFil("01",cVarFil),TNS->FT_CFOP+cTxt,TNS->VCONT,TNS->VMER,TNS->VFRETE,TNS->VIPI,TNS->VICM,TNS->VPIS,TNS->VCOF,,nAcumLiq})
			nVCONT   := nVCONT  + TNS->VCONT
			nVMER    := nVMER   + TNS->VMER
			nVFRETE  := nVFRETE + TNS->VFRETE
			nVIPI    := nVIPI   + TNS->VIPI
			nVICM    := nVICM   + TNS->VICM
			nVPIS    := nVPIS   + TNS->VPIS
			nVCOF    := nVCOF   + TNS->VCOF
			nAcumL   := nAcumL  + nAcumLiq
			TNS->(dbSkip())
		enddo
		//Imprime o resultado por filial.
		//aAdd(aConteud,{TNS->FT_CFOP,cTxt                                      ,TNS->VCONT,TNS->VMER,TNS->VFRETE,TNS->VIPI,TNS->VICM,TNS->VPIS,TNS->VCOF,,nAcumLiq})
		aAdd(aConteud,{""          ,"TOTAIS SAIDAS : "+NomeFil("01",cVarFil),nVCONT    ,nVMER    ,nVFRETE    ,nVIPI    ,nVICM    ,nVPIS    ,nVCOF    ,,nAcumL})
		//Totalizador de saidas 
		aAdd(aConteud1,{""          ,"TOTAIS SAIDAS : "+NomeFil("01",cVarFil),nVCONT    ,nVMER    ,nVFRETE    ,nVIPI    ,nVICM    ,nVPIS    ,nVCOF    ,,nAcumL})

		aAdd(aConteud,{"","","","","","","","","","","",})
		ZeraAcum()
		TNS->(dbSkip())
	EndDo
	//totalizador Devolucoes
	//SELECIONA AS SAIDAS DA MESMA FILIAL
	cQuery := ""
	cQuery += " SELECT FT_CFOP, FT_FILIAL, "
	cQuery += " SUM(FT_VALCONT)	AS VCONT,  "
	cQuery += " SUM(FT_FRETE)	AS VFRETE, "
	cQuery += " SUM(FT_VALIPI)	AS VIPI,  "
	cQuery += " SUM(FT_VALICM)	AS VICM,  "
	cQuery += " SUM(FT_VALPIS)	AS VPIS,  "
	cQuery += " SUM(FT_VALCOF)	AS VCOF,  "
	cQuery += " SUM(FT_VALICM)	AS VICM,  "
	cQuery += " SUM(FT_TOTAL)	AS VMER   "
	cQuery += " FROM " + RETSQLNAME("SFT")
	cQuery += " WHERE "
	cQuery += " FT_ENTRADA BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04) + "' AND "
	cQuery += " FT_FILIAL  BETWEEN '"+FIL->FT_FILIAL+"' AND '"+FIL->FT_FILIAL + "'AND "
	cQuery += " FT_TIPO IN ('D') AND FT_OBSERV <> 'NF CANCELADA' AND "
	cQuery += " FT_CFOP < 5000 AND "  //dev de vendas 
	cQuery += " D_E_L_E_T_ <> '*' "
	cQuery += " GROUP BY FT_FILIAL,FT_CFOP "
	cQuery += " ORDER BY FT_FILIAL,FT_CFOP "
	TcQuery cQuery New Alias "TDE"
	do While TDE->(!EOF())
		cVarFil := TDE->FT_FILIAL
		nFilImpVez := 1 //imprime o nome da filial somente uma vez
		do while TDE->FT_FILIAL = cVarFil
			If SX5->(dbSeek(xFilial("SX5")+"13"+TDE->FT_CFOP))
				cTxt := SX5->X5_DESCRI
			EndIf
			//Acumuladores 2-(6+7+8+9+10)
			nAcumLiq := TDE->VCONT-(TDE->VFRETE+TDE->VIPI+TDE->VICM+TDE->VPIS+TDE->VCOF)
			nVCONT   := nVCONT  + TDE->VCONT
			nVMER    := nVMER   + TDE->VMER
			nVFRETE  := nVFRETE + TDE->VFRETE
			nVIPI    := nVIPI   + TDE->VIPI
			nVICM    := nVICM   + TDE->VICM
			nVPIS    := nVPIS   + TDE->VPIS
			nVCOF    := nVCOF   + TDE->VCOF
			nAcumL   := nAcumL  + nAcumLiq
			TDE->(dbSkip())
		enddo
		aAdd(aConteud1,{""          ,"TOTAIS DEV.SAIDA : "+NomeFil("01",cVarFil),nVCONT    ,nVMER    ,nVFRETE    ,nVIPI    ,nVICM    ,nVPIS    ,nVCOF    ,,nAcumL})
    	TDE->(dbSkip())
    enddo 
	TDE->(dbCloseArea())
	//
	//SELECIONA AS SAIDAS DA MESMA FILIAL
	cQuery := ""
	cQuery += " SELECT FT_CFOP, FT_FILIAL, "
	cQuery += " SUM(FT_VALCONT)	AS VCONT,  "
	cQuery += " SUM(FT_FRETE)	AS VFRETE, "
	cQuery += " SUM(FT_VALIPI)	AS VIPI,  "
	cQuery += " SUM(FT_VALICM)	AS VICM,  "
	cQuery += " SUM(FT_VALPIS)	AS VPIS,  "
	cQuery += " SUM(FT_VALCOF)	AS VCOF,  "
	cQuery += " SUM(FT_VALICM)	AS VICM,  "
	cQuery += " SUM(FT_TOTAL)	AS VMER   "
	cQuery += " FROM " + RETSQLNAME("SFT")
	cQuery += " WHERE "
	cQuery += " FT_ENTRADA BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04) + "' AND "
	cQuery += " FT_FILIAL  BETWEEN '"+FIL->FT_FILIAL+"' AND '"+FIL->FT_FILIAL + "'AND "
	cQuery += " FT_TIPO IN ('D') AND FT_OBSERV <> 'NF CANCELADA' AND "
	cQuery += " FT_CFOP > 5000 AND " //CFOP > 5000 - DEV DE COMPRA 
	cQuery += " D_E_L_E_T_ <> '*' "
	cQuery += " GROUP BY FT_FILIAL,FT_CFOP "
	cQuery += " ORDER BY FT_FILIAL,FT_CFOP "
	TcQuery cQuery New Alias "TDS"
	do While TDS->(!EOF())
		cVarFil := TDS->FT_FILIAL
		nFilImpVez := 1 //imprime o nome da filial somente uma vez
		do while TDS->FT_FILIAL = cVarFil
			If SX5->(dbSeek(xFilial("SX5")+"13"+TDS->FT_CFOP))
				cTxt := SX5->X5_DESCRI
			EndIf
			//Acumuladores 2-(6+7+8+9+10)
			nAcumLiq := TDS->VCONT-(TDS->VFRETE+TDS->VIPI+TDS->VICM+TDS->VPIS+TDS->VCOF)
			nVCONT   := nVCONT  + TDS->VCONT
			nVMER    := nVMER   + TDS->VMER
			nVFRETE  := nVFRETE + TDS->VFRETE
			nVIPI    := nVIPI   + TDS->VIPI
			nVICM    := nVICM   + TDS->VICM
			nVPIS    := nVPIS   + TDS->VPIS
			nVCOF    := nVCOF   + TDS->VCOF
			nAcumL   := nAcumL  + nAcumLiq
			TDS->(dbSkip())
		enddo
		aAdd(aConteud1,{""          ,"TOTAIS DEV.ENTRADA : "+NomeFil("01",cVarFil),nVCONT    ,nVMER    ,nVFRETE    ,nVIPI    ,nVICM    ,nVPIS    ,nVCOF    ,,nAcumL})
    	TDS->(dbSkip())
    enddo 
	TDS->(dbCloseArea())
	//

	// Totalizadores da filial (Entradas, Saídas, Devolucoes (Entrada e Saída) 
	for nKK = 1 to len(aConteud1)
		aAdd(aConteud,{aConteud1[nKK,1],aConteud1[nKK,2],aConteud1[nKK,3],aConteud1[nKK,4],aConteud1[nKK,5],aConteud1[nKK,6],aConteud1[nKK,7],aConteud1[nKK,8],aConteud1[nKK,9],,aConteud1[nKK,10]})
	next 
		
	TNS->(dbCloseArea())
	FIL->(dbSkip())
	aConteud1 := {}
enddo
FIL->(dbCloseArea())

//---------------------------------------------------
nCab := 1
aDir := MDirArq()
If Empty(aDir[1]) .OR. Empty(aDir[2])
	Return
Else
	Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
	If lOk
		MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
	EndIf
EndIf

if MV_PAR05 = 1  //Imprime analítico 
	U_MACTBR9A(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,Alltrim(aDir[1]),Alltrim(aDir[2]))
endif 

RestArea(aAreaNF)

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: MDirArq
//|Descricao.: Defini Diretório e nome do arquivo a ser gerado
//|Retorno...: aRet[1] = Diretório de gravação
//|            aRet[2] = Nome do arquivo a ser gerado
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MDirArq()
*-----------------------------------------*
Local aRet := {"",""}
Private bFileFat:={|| cDir:=UZXChoseDir(),If(Empty(cDir),cDir:=Space(250),Nil)}
Private cArq    := Space(10)
Private cDir    := Space(250)
Private oDlgDir := Nil
Private cPath   := "Selecione diretório"
Private aArea   := GetArea()
Private lRetor  := .T.
Private lSair   := .F.

//+-----------------------------------------------------------------------------------//
//| Definição da janela e seus conteúdos
//+-----------------------------------------------------------------------------------//
While .T.
	DEFINE MSDIALOG oDlgDir TITLE "Definição de Arquivo e Diretório" FROM 0,0 TO 175,368 OF oDlgDir PIXEL
	
	@ 06,06 TO 65,180 LABEL "Dados do arquivo" OF oDlgDir PIXEL
	
	@ 15, 10 SAY   "Nome do Arquivo"  SIZE 45,7 PIXEL OF oDlgDir
	@ 25, 10 MSGET cArq               SIZE 50,8 PIXEL OF oDlgDir
	
	@ 40, 10 SAY "Diretorio de gravação"  SIZE  65, 7 PIXEL OF oDlgDir
	@ 50, 10 MSGET cDir PICTURE "@!"      SIZE 150, 8 WHEN .F. PIXEL OF oDlgDir
	@ 50,162 BUTTON "..."                 SIZE  13,10 PIXEL OF oDlgDir ACTION Eval(bFileFat)
	
	DEFINE SBUTTON FROM 70,10 TYPE 1  OF oDlgDir ACTION (UZXValRel("ok")) ENABLE
	DEFINE SBUTTON FROM 70,50 TYPE 2  OF oDlgDir ACTION (UZXValRel("cancel")) ENABLE
	
	ACTIVATE MSDIALOG oDlgDir CENTER
	
	If lRetor
		Exit
	Else
		Loop
	EndIf
EndDo

If lSair
	Return(aRet)
EndIf

aRet := {cDir,cArq}

Return(aRet)

*-----------------------------------------*
Static Function UZXChoseDir()
*-----------------------------------------*
Local cTitle:= "Geração de arquivo"
Local cMask := "Formato *|*.*"
Local cFile := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions:= GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY

cFile:= cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,.F., nOptions)

Return(cFile)

//+-----------------------------------------------------------------------------------//
//|Funcao....: UZXValRel()
//|Descricao.: Valida informações de gravação
//|Uso.......: U_UZXDIRARQ
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function UZXValRel(cValida)
*-----------------------------------------*

Local lCancela

If cValida = "ok"
	If Empty(Alltrim(cArq))
		MsgInfo("O nome do arquivo deve ser informado","Atenção")
		lRetor := .F.
	ElseIf Empty(Alltrim(cDir))
		MsgInfo("O diretório deve ser informado","Atenção")
		lRetor := .F.
	ElseIf Len(Alltrim(cDir)) <= 3
		MsgInfo("Não se pode gravar o arquivo no diretório raiz, por favor, escolha um subdiretório.","Atenção")
		lRetor := .F.
	Else
		oDlgDir:End()
		lRetor := .T.
	EndIf
Else
	lCancela := MsgYesNo("Deseja cancelar a geração do Relatório / Documento?","Atenção")
	If lCancela
		oDlgDir:End()
		lRetor := .T.
		lSair  := .T.
	Else
		lRetor := .F.
	EndIf
EndIf

Return(lRetor)

//+-----------------------------------------------------------------------------------//
//|Funcao....: MCSV
//|Descricao.: Gera Arvquivo do tipo csv
//|Retorno...: .T. ou .F.
//|Observação:
//+-----------------------------------------------------------------------------------//
*-------------------------------------------------*
Static Function MCVS(axVet,cxCab,cxArqTxt,PICTUSE)
*-------------------------------------------------*

Local cEOL       := CHR(13)+CHR(10)
Local nTamLin    := 2
Local cLin       := Space(nTamLin)+cEOL
Local cDadosCSV  := ""
Local lRet       := .T.
Local nHdl,nt,jk       := 0

If Len(axVet) == 0
	MsgInfo("Dados não informados","Sem dados")
	lRet := .F.
	Return(lRet)
ElseIf Empty(cxArqTxt)
	MsgInfo("Diretório e nome do arquivo não informados corretamente","Diretório ou Arquivo")
	lRet := .F.
	Return(lRet)
EndIf

cxArqTxt := cxArqTxt+".csv"
nHdl := fCreate(cxArqTxt)

If nHdl == -1
	MsgAlert("O arquivo de nome "+cxArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

nTamLin := 2
cLin    := Space(nTamLin)+cEOL

ProcRegua(Len(axVet))

If !Empty(cxCab)
	cLin := Stuff(cLin,01,02,cxCab)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no Cabeçalho. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		Endif
	Endif
EndIf

For jk := 1 to Len(axVet)
	nTamLin   := 2
	cLin      := Space(nTamLin)+cEOL
	cDadosCSV := ""
	IncProc("Gerando arquivo CSV")
	For nt := 1 to Len(axVet[jk])
		If ValType(axVet[jk,nt]) == "C"
			cDadosCSV += axVet[jk,nt]+Iif(nt = Len(axVet[jk]),"",";")
		ElseIf ValType(axVet[jk,nt]) == "N"
			cDadosCSV += Transform(axVet[jk,nt],PICTUSE)+Iif(nt = Len(axVet[jk]),"",";")
		ElseIf ValType(axVet[jk,nt]) == "U"
			cDadosCSV += +Iif(nt = Len(axVet[jk]),"",";")
		Else
			cDadosCSV += axVet[jk,nt]+Iif(nt = Len(axVet[jk]),"",";")
		EndIf
	Next
	cLin := Stuff(cLin,01,02,cDadosCSV)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo nos Itens. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		Endif
	Endif
Next
fClose(nHdl)
Return(lOk)

//+-----------------------------------------------------------------------------------//
//|Funcao....: MExcel
//|Descricao.: Abre arquivo csv em excel
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MExcel(cxDir,cxArq)
*-----------------------------------------*
Local cArqTxt := cxDir+cxArq+".csv"
Local cMsg    := "Relatorio gerado com sucesso!"+CHR(13)+CHR(10)+"O arquivo "+cxArq+".csv"
cMsg    += " se encontra no diretório "+cxDir

MsgInfo(cMsg,"Atenção")

If MsgYesNo("Deseja Abrir o arquivo em Excel?","Atenção")
	If ! ApOleClient( 'MsExcel' )
		MsgStop(" MsExcel nao instalado ")
		Return
	EndIf
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cArqTxt)
	oExcelApp:SetVisible(.T.)
EndIf

Return
//------------------------
Static Function ZeraAcum()
//------------------------
nVCONT		:= 0
nVMER		:= 0
nVFRETE		:= 0
nVIPI		:= 0
nVICM		:= 0
nVPIS		:= 0
nVCOF		:= 0
nAcumLiq	:= 0
nAcumL 		:= 0
return


//+-----------------------------------------------------------------------------------//
//|Funcao....: ValidPerg
//|Descricao.: Valida perguntas utilizadas no SX1
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function ValidPerg(cPerg)
*-----------------------------------------*

Local aRegs := {}
Local i,j
dbSelectArea("SX1")
dbSetOrder(1)
//   1          2        3         4          5           6       7       8             9        10      11     12       13        14        15         16       17       18       19        20          21        22      23        24       25         26        27       28       29       30          31        32       33       34        35          36        37     38     39       40       41        42
//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_PYME/X1_GRPSXG/X1_HELP/X1_PICTURE
AADD(aRegs,{cPerg,"01","De Filial" 		,"","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Filial"		,"","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Data de" 		,"","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Data Ate" 		,"","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Analit/Sintet" 	,"","","mv_ch5","N",01,0,0,"C","","mv_par05","Sim","Sim","Sim","","","2","Nao","Nao","","","","","","","","","","","","","","","","","","","","",""})

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

//---------------------------------------
Static Function NomeFil(cNomEmp,cNumFil)
//---------------------------------------
Local aArFil := GetArea()
SM0->(dbGoTop())
if SM0->(dbSeek(cNomEmp+cNumFil))
	RestArea(aArFil)
	Return(alltrim(SM0->M0_FILIAL))
else
	RestArea(aArFil)
	Return("Filial nao encontrada !")
endif
