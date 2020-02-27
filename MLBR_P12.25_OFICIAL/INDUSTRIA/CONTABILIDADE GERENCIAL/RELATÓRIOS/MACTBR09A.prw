#INCLUDE "PROTHEUS.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TOPCONN.CH"

#DEFINE PICVAL  "@E 999,999,999.99"

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori
//|Funcao....: MACTBR09A()
//|Autor.....: Jose Roberto de Souza  -  Taggs Consultoria
//|Data......: 14 de junho de 2010
//|Uso.......: SIGACTB
//|Versao....: Protheus - 10
//|Descricao.: Relatorio resumo de operações CFOP - ANALITICO 
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function MACTBR9A()      
*-----------------------------------------*
Private cTitulo  	:= "Resumo de Operações CFOP - ANALITICO"
Private aArea    	:= GetArea()
Private aConteud 	:= {}
Private aConteud1	:= {}
//Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cPerg  		:= PADR("MACTBR09",10)
Private nFilImpVez 	:= 0
If !SX1->(dbSeek(cPerg))
	ValidPerg(cPerg)
EndIf

//If !Pergunte(cPerg,.T. )
//	Return
//Endif

Processa({|| MCTR09A()},'Analisando Dados...')

Return .T.

//+-----------------------------------------------------------------------------------//
//|Funcao....: MCTR09A()
//|Autor.....: Jose Roberto deSouza - Taggs Consultoria
//|Uso.......: SIGACTB
//|Descricao.: Gera relatorio de resumo de CFOP (Entradas e saidas) - ANALITICO 
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MCTR09A()
*-----------------------------------------*
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


//----------------------------------RESUMO DE OPERACOES POR FILIAL -----------------------------------------------------

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


aAdd(aConteud,{"ANALITICO POR FILIAL","","","","","","","","","",""})
aAdd(aConteud,{"","","","","","","","","","","",})

//Processa filiais
do while FIL->(!eof())
	//SELECIONA ENTRADAS
	cQuery := ""
	cQuery += " SELECT FT_NFISCAL,FT_SERIE,FT_CFOP, FT_FILIAL, FT_CLIEFOR, FT_LOJA,"
	cQuery += " FT_VALCONT	AS VCONT,   "
	cQuery += " FT_FRETE	AS VFRETE,  "
	cQuery += " FT_VALIPI	AS VIPI,  "
	cQuery += " FT_VALICM	AS VICM,  "
	cQuery += " FT_VALPIS	AS VPIS,  "
	cQuery += " FT_VALCOF	AS VCOF,  "
	cQuery += " FT_VALICM	AS VICM,  "
	cQuery += " FT_TOTAL	AS VMER   "
	cQuery += " FROM " + RETSQLNAME("SFT")
	cQuery += " WHERE "
	cQuery += " FT_ENTRADA BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04) + "' AND "
	cQuery += " FT_FILIAL  BETWEEN '"+FIL->FT_FILIAL+"' AND '"+FIL->FT_FILIAL + "'AND "
	cQuery += " SUBSTRING(FT_CFOP,1,1) IN ('1','2','3','4') AND FT_OBSERV <> 'NF CANCELADA' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	cQuery += " ORDER BY FT_FILIAL,FT_CFOP "
	TcQuery cQuery New Alias "TNE"
	aAdd(aConteud,{"ENTRADAS","","","","","","","","","","",})
	aAdd(aConteud,{"","","","","","","","","","","",})

//	aAdd(aConteud,{"FILIAL","CFOP DESCRIÇÃO","VALOR TOTAL","VALOR PROD/SERVIÇOS","FRETE","IPI","ICMS","PIS","ISS","VALOR LIQUIDO"})
	aAdd(aConteud,{"FILIAL","N.FISCAL/SERIE","FORNECEDOR/LOJA","CFOP DESCRIÇÃO","VALOR TOTAL","VALOR PROD/SERVIÇOS","FRETE","IPI","ICMS","PIS","ISS","VALOR LIQUIDO"})

	aAdd(aConteud,{"","","","","","","","","","","","","",})
	ZeraAcumA()
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
				if SA2->(dbSeek(xFilial("SA2")+ TNE->FT_CLIEFOR+TNE->FT_LOJA))
					aAdd(aConteud,{TNE->FT_FILIAL+"-"+NomeFilA("01",cVarFil),TNE->FT_NFISCAL+"-"+TNE->FT_SERIE,TNE->FT_CLIEFOR+"-"+TNE->FT_LOJA+"-"+alltrim(SA2->A2_NOME),TNE->FT_CFOP+cTxt,TNE->VCONT,TNE->VMER,TNE->VFRETE,TNE->VIPI,TNE->VICM,TNE->VPIS,TNE->VCOF,nAcumLiq})
                else 
					aAdd(aConteud,{TNE->FT_FILIAL+"-"+NomeFilA("01",cVarFil),TNE->FT_NFISCAL+"-"+TNE->FT_SERIE,TNE->FT_CLIEFOR+"-"+TNE->FT_LOJA+"-"+"N/I"                ,TNE->FT_CFOP+cTxt,TNE->VCONT,TNE->VMER,TNE->VFRETE,TNE->VIPI,TNE->VICM,TNE->VPIS,TNE->VCOF,nAcumLiq})
				endif                 
			else
				if SA2->(dbSeek(xFilial("SA2")+ TNE->FT_CLIEFOR+TNE->FT_LOJA))
					aAdd(aConteud,{"" 									        ,TNE->FT_NFISCAL+"-"+TNE->FT_SERIE,TNE->FT_CLIEFOR+"-"+TNE->FT_LOJA+"-"+alltrim(SA2->A2_NOME),TNE->FT_CFOP+cTxt,TNE->VCONT,TNE->VMER,TNE->VFRETE,TNE->VIPI,TNE->VICM,TNE->VPIS,TNE->VCOF,nAcumLiq})
				else 
					aAdd(aConteud,{"" 									        ,TNE->FT_NFISCAL+"-"+TNE->FT_SERIE,"N/I"                                                     ,TNE->FT_CFOP+cTxt,TNE->VCONT,TNE->VMER,TNE->VFRETE,TNE->VIPI,TNE->VICM,TNE->VPIS,TNE->VCOF,nAcumLiq})
				endif 
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
		aAdd(aConteud,{"","","","","","","","","","","","",})
		aAdd(aConteud,{"",""          ,"TOTAIS ENTRADAS FILIAL: "+NomeFilA("01",cVarFil),"",nVCONT    ,nVMER    ,nVFRETE    ,nVIPI    ,nVICM    ,nVPIS    ,nVCOF    ,nAcumL})
		//Totalizador das entradas  
		aAdd(aConteud1,{"",""          ,"TOTAIS ENTRADAS FILIAL: "+NomeFilA("01",cVarFil),"",nVCONT    ,nVMER    ,nVFRETE    ,nVIPI    ,nVICM    ,nVPIS    ,nVCOF    ,nAcumL})
		//-->
		ZeraAcumA()
		TNE->(dbSkip())
	EndDo
	TNE->(dbCloseArea())

	
	//SELECIONA SAÍDS
	nFilImpVez := 0 //imprime o nome da filial somente uma vez
	aAdd(aConteud,{"","","","","","","","","","","","","",})
	aAdd(aConteud,{"SAIDAS","","","","","","","","","","","","",})
	aAdd(aConteud,{"FILIAL","","CFOP DESCRIÇÃO","VALOR TOTAL","VALOR PROD/SERVIÇOS","FRETE","IPI","ICMS","PIS","ISS","VALOR LIQUIDO"})
	
	//SELECIONA AS SAIDAS DA MESMA FILIAL
	cQuery := ""
	cQuery += " SELECT FT_CFOP, FT_FILIAL,FT_CLIEFOR, FT_LOJA, FT_NFISCAL, FT_SERIE, "
	cQuery += " FT_VALCONT	AS VCONT,  "
	cQuery += " FT_FRETE	AS VFRETE, "
	cQuery += " FT_VALIPI	AS VIPI,  "
	cQuery += " FT_VALICM	AS VICM,  "
	cQuery += " FT_VALPIS	AS VPIS,  "
	cQuery += " FT_VALCOF	AS VCOF,  "
	cQuery += " FT_VALICM	AS VICM,  "
	cQuery += " FT_TOTAL	AS VMER   "
	cQuery += " FROM " + RETSQLNAME("SFT")
	cQuery += " WHERE "
	cQuery += " FT_ENTRADA BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04) + "' AND "
	cQuery += " FT_FILIAL  BETWEEN '"+FIL->FT_FILIAL+"' AND '"+FIL->FT_FILIAL + "'AND "
	cQuery += " SUBSTRING(FT_CFOP,1,1) IN ('5','6','7','8') AND FT_OBSERV <> 'NF CANCELADA' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
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
				if SA1->(dbSeek(xFilial("SA1")+ TNS->FT_CLIEFOR+TNS->FT_LOJA))
					aAdd(aConteud,{TNS->FT_FILIAL+"-"+NomeFilA("01",cVarFil),TNS->FT_NFISCAL+"-"+TNS->FT_SERIE,TNS->FT_CLIEFOR+"-"+TNS->FT_LOJA+"-"+alltrim(SA1->A1_NOME),TNS->FT_CFOP+cTxt,TNS->VCONT,TNS->VMER,TNS->VFRETE,TNS->VIPI,TNS->VICM,TNS->VPIS,TNS->VCOF,nAcumLiq})
                else 
					aAdd(aConteud,{TNS->FT_FILIAL+"-"+NomeFilA("01",cVarFil),TNS->FT_NFISCAL+"-"+TNS->FT_SERIE,TNS->FT_CLIEFOR+"-"+TNS->FT_LOJA+"-"+"N/I"                ,TNS->FT_CFOP+cTxt,TNS->VCONT,TNS->VMER,TNS->VFRETE,TNS->VIPI,TNS->VICM,TNS->VPIS,TNS->VCOF,nAcumLiq})
				endif                 
			else
				if SA1->(dbSeek(xFilial("SA1")+ TNS->FT_CLIEFOR+TNS->FT_LOJA))
					aAdd(aConteud,{"" 									        ,TNS->FT_NFISCAL+"-"+TNS->FT_SERIE,TNS->FT_CLIEFOR+"-"+TNS->FT_LOJA+"-"+alltrim(SA1->A1_NOME),TNS->FT_CFOP+cTxt,TNS->VCONT,TNS->VMER,TNS->VFRETE,TNS->VIPI,TNS->VICM,TNS->VPIS,TNS->VCOF,nAcumLiq})
				else 
					aAdd(aConteud,{"" 									        ,TNS->FT_NFISCAL+"-"+TNS->FT_SERIE,"N/I"                                                     ,TNS->FT_CFOP+cTxt,TNS->VCONT,TNS->VMER,TNS->VFRETE,TNS->VIPI,TNS->VICM,TNS->VPIS,TNS->VCOF,nAcumLiq})
				endif 
			endif

			nFilImpVez := 0 //imprime o nome da filial somente uma vez
			
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
		//aAdd(aConteud,{TNS->FT_CFOP,cTxt                                      ,TNS->VCONT,TNS->VMER,TNS->VFRETE,TNS->VIPI,TNS->VICM,TNS->VPIS,TNS->VCOF,nAcumLiq})
		aAdd(aConteud,{"",""          ,"TOTAIS SAIDAS : "+NomeFilA("01",cVarFil),"",nVCONT    ,nVMER    ,nVFRETE    ,nVIPI    ,nVICM    ,nVPIS    ,nVCOF    ,nAcumL})
		//Totalizador de saidas 
		aAdd(aConteud1,{"",""          ,"TOTAIS SAIDAS : "+NomeFilA("01",cVarFil),,nVCONT    ,nVMER    ,nVFRETE    ,nVIPI    ,nVICM    ,nVPIS    ,nVCOF    ,nAcumL})

		aAdd(aConteud,{"","","","","","","","","","","","","",})
		ZeraAcumA()
		TNS->(dbSkip())
	EndDo
	//totalizador Devolucoes
	//SELECIONA AS SAIDAS DA MESMA FILIAL
	cQuery := ""
	cQuery += " SELECT FT_CFOP, FT_FILIAL,FT_CLIEFOR,FT_LOJA, "
	cQuery += " FT_VALCONT	AS VCONT,  "
	cQuery += " FT_FRETE	AS VFRETE, "
	cQuery += " FT_VALIPI	AS VIPI,  "
	cQuery += " FT_VALICM	AS VICM,  "
	cQuery += " FT_VALPIS	AS VPIS,  "
	cQuery += " FT_VALCOF	AS VCOF,  "
	cQuery += " FT_VALICM	AS VICM,  "
	cQuery += " FT_TOTAL	AS VMER   "
	cQuery += " FROM " + RETSQLNAME("SFT")
	cQuery += " WHERE "
	cQuery += " FT_ENTRADA BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04) + "' AND "
	cQuery += " FT_FILIAL  BETWEEN '"+FIL->FT_FILIAL+"' AND '"+FIL->FT_FILIAL + "'AND "
	cQuery += " FT_TIPO IN ('D') AND FT_OBSERV <> 'NF CANCELADA' AND "
	cQuery += " FT_CFOP < 5000 AND "  //dev de vendas 
	cQuery += " D_E_L_E_T_ <> '*' "
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
		aAdd(aConteud1,{"",""          ,"TOTAIS DEV.SAIDA : "+NomeFilA("01",cVarFil),nVCONT    ,nVMER    ,nVFRETE    ,nVIPI    ,nVICM    ,nVPIS    ,nVCOF    ,nAcumL})
    	TDE->(dbSkip())
    enddo 
	TDE->(dbCloseArea())
	//
	//SELECIONA AS SAIDAS DA MESMA FILIAL
	cQuery := ""
	cQuery += " SELECT FT_CFOP, FT_FILIAL,FT_CLIEFOR,FT_LOJA, "
	cQuery += " FT_VALCONT	AS VCONT,  "
	cQuery += " FT_FRETE	AS VFRETE, "
	cQuery += " FT_VALIPI	AS VIPI,  "
	cQuery += " FT_VALICM	AS VICM,  "
	cQuery += " FT_VALPIS	AS VPIS,  "
	cQuery += " FT_VALCOF	AS VCOF,  "
	cQuery += " FT_VALICM	AS VICM,  "
	cQuery += " FT_TOTAL	AS VMER   "
	cQuery += " FROM " + RETSQLNAME("SFT")
	cQuery += " WHERE "
	cQuery += " FT_ENTRADA BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04) + "' AND "
	cQuery += " FT_FILIAL  BETWEEN '"+FIL->FT_FILIAL+"' AND '"+FIL->FT_FILIAL + "'AND "
	cQuery += " FT_TIPO IN ('D') AND FT_OBSERV <> 'NF CANCELADA' AND "
	cQuery += " FT_CFOP > 5000 AND " //CFOP > 5000 - DEV DE COMPRA 
	cQuery += " D_E_L_E_T_ <> '*' "
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
		aAdd(aConteud1,{"",""          ,"TOTAIS DEV.ENTRADA : "+NomeFilA("01",cVarFil),nVCONT    ,nVMER    ,nVFRETE    ,nVIPI    ,nVICM    ,nVPIS    ,nVCOF    ,nAcumL})
    	TDS->(dbSkip())
    enddo 
	TDS->(dbCloseArea())
	//

	// Totalizadores da filial (Entradas, Saídas, Devolucoes (Entrada e Saída) 
//	for nKK = 1 to len(aConteud1)
//		aAdd(aConteud,{"",aConteud1[nKK,1],aConteud1[nKK,2],aConteud1[nKK,3],aConteud1[nKK,4],aConteud1[nKK,5],aConteud1[nKK,6],aConteud1[nKK,7],aConteud1[nKK,8],aConteud1[nKK,9],aConteud1[nKK,10]})
//	next 
		
	TNS->(dbCloseArea())
	FIL->(dbSkip())
	aConteud1 := {}
enddo
FIL->(dbCloseArea())

//---------------------------------------------------
nCab := 1
aDir := MDirArqA()
If Empty(aDir[1]) .OR. Empty(aDir[2])
	Return
Else
	Processa({ || lOk := MCVSA(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
	If lOk
		MExcelA(Alltrim(aDir[1]),Alltrim(aDir[2]))
	EndIf
EndIf
RestArea(aAreaNF)

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: MDirArqA
//|Descricao.: Defini Diretório e nome do arquivo a ser gerado
//|Retorno...: aRet[1] = Diretório de gravação
//|            aRet[2] = Nome do arquivo a ser gerado
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MDirArqA()
*-----------------------------------------*
Local aRet := {"",""}
Private bFileFat:={|| cDir:=UZXChoseDirA(),If(Empty(cDir),cDir:=Space(250),Nil)}
//Private cArq    := Space(10)
//Private cDir    := Space(250)
Private cArq    := Alltrim(aDir[2] )+"_a"
Private cDir    := Alltrim(aDir[1] )

Private oDlgDir := Nil
Private cPath   := "Selecione diretório"
Private aArea   := GetArea()
Private lRetor  := .T.
Private lSair   := .F.

//+-----------------------------------------------------------------------------------//
//| Definição da janela e seus conteúdos
//+-----------------------------------------------------------------------------------//
/*
While .T.
	DEFINE MSDIALOG oDlgDir TITLE "Definição de Arquivo e Diretório" FROM 0,0 TO 175,368 OF oDlgDir PIXEL
	
	@ 06,06 TO 65,180 LABEL "Dados do arquivo" OF oDlgDir PIXEL
	
	@ 15, 10 SAY   "Nome do Arquivo"  SIZE 45,7 PIXEL OF oDlgDir
	@ 25, 10 MSGET cArq               SIZE 50,8 PIXEL OF oDlgDir
	
	@ 40, 10 SAY "Diretorio de gravação"  SIZE  65, 7 PIXEL OF oDlgDir
	@ 50, 10 MSGET cDir PICTURE "@!"      SIZE 150, 8 WHEN .F. PIXEL OF oDlgDir
	@ 50,162 BUTTON "..."                 SIZE  13,10 PIXEL OF oDlgDir ACTION Eval(bFileFat)
	
	DEFINE SBUTTON FROM 70,10 TYPE 1  OF oDlgDir ACTION (UZXValRelA("ok")) ENABLE
	DEFINE SBUTTON FROM 70,50 TYPE 2  OF oDlgDir ACTION (UZXValRelA("cancel")) ENABLE
	
	ACTIVATE MSDIALOG oDlgDir CENTER
	
	If lRetor
		Exit
	Else
		Loop
	EndIf
EndDo
*/

UZXValRelA("ok")


If lSair
	Return(aRet)
EndIf

aRet := {cDir,cArq}

Return(aRet)

*-----------------------------------------*
Static Function UZXChoseDirA()
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
//|Funcao....: UZXValRelA()
//|Descricao.: Valida informações de gravação
//|Uso.......: UZXDIRARQ
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function UZXValRelA(cValida)
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
//		oDlgDir:End()
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
Static Function MCVSA(axVet,cxCab,cxArqTxt,PICTUSE)
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
//|Funcao....: MExcelA
//|Descricao.: Abre arquivo csv em excel
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MExcelA(cxDir,cxArq)
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
Static Function ZeraAcumA()
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



//---------------------------------------
Static Function NomeFilA(cNomEmp,cNumFil)
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
