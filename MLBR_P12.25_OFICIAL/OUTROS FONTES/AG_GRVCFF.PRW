#Include 'Protheus.ch'

//Funcao para gravar informacoes na tabela CFF (Para geração CAT207)
//Desenvolvido por Anesio G.Faria
//Rotina incompleta

user function AG_GRVCFF()
Local cQuery := ""


Private cPerg := PADR("AG_GRVCFF",10)
if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
endif
Pergunte(cPerg,.T.)      



cQuery := " SELECT DISTINCT D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_CF from "+RetSqlName("SD2") + " SD2" 
cQuery += " where D_E_L_E_T_ = ' ' AND D2_FILIAL = '"+xFilial("SD2")+"' " 
cQuery += " AND Substring(D2_EMISSAO,1,6)='"+mv_par01+mv_par02+"' and D2_CF in ('7101', '7102', '7127','5501','6501')  " 

if Select("TMPD2") > 0 
	dbSelectArea("TMPD2")
	TMPD2->(dbCloseArea())
endif
     
memowrite("C:\temp\CFF.TXT", cQuery)
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPD2", .T., .T. )

//Filtra as notas fiscais de Saida em SD2 onde o CFOP = 7101 e grava na tabela as informacoes
//CFF_FILIAL CFF_CODLEG CFF_CODIGO CFF_ANEXO  CFF_ART    CFF_INC    CFF_ALIN   CFF_PRG    CFF_ITM    CFF_LTR    CFF_OBS                        CFF_NUMDOC CFF_SERIE CFF_CLIFOR CFF_LOJA D_E_L_E_T_ R_E_C_N_O_  R_E_C_D_E_L_
//---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ------------------------------ ---------- --------- ---------- -------- ---------- ----------- ------------
//09         0007       07         0          71         III                                                    SAIDA S/PGTO IMP.-EXPORTACAO   000011071  1         001378     00                  1           0
//09         0007       07         0          71         III                                                    SAIDA S/PGTO IMP.-EXPORTACAO   000011073  1                             *          2           2

//Seleciona a tabela CFF - Complemento de Credito Acumulado de ICMS
dbSelectArea("CFF")
dbSetOrder(1) //CFF_FILIAL+CFF_NUMDOC+CFF_SERIE+CFF_CLIFOR+CFF_LOJA+CFF_CODLEG+CFF_CODIGO+CFF_ANEXO+CFF_ART+CFF_INC+CFF_ALIN+CFF_PRG+CFF_ITM+CFF_LTR

nCount:= 0
//Seleciona a tabela temporaria criada no select
dbSelectArea("TMPD2")
TMPD2->(dbGotop())
while !TMPD2->(eof())
	if !CFF->(dbSeek(xFilial("CFF")+TMPD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA),.T.))
		if ALLTRIM(TMPD2->D2_CF) $ '|7101|7102|7127|'
			RecLock("CFF", .T.)
			CFF->CFF_FILIAL := xFilial("CFF")
			CFF->CFF_CODLEG := "0007"
			CFF->CFF_CODIGO := "07"
			CFF->CFF_ANEXO  := "0"
			CFF->CFF_ART    := "71"
			CFF->CFF_INC    := "III"
			CFF->CFF_OBS    := "SAIDA S/PGTO IMP.-EXPORTACAO"
			CFF->CFF_NUMDOC := TMPD2->D2_DOC
			CFF->CFF_SERIE  := TMPD2->D2_SERIE
			CFF->CFF_CLIFOR := TMPD2->D2_CLIENTE
			CFF->CFF_LOJA	:= TMPD2->D2_LOJA
			MsUnLock("CFF")
		else
			RecLock("CFF", .T.)
			CFF->CFF_FILIAL := xFilial("CFF")
			CFF->CFF_CODLEG := "0008"
			CFF->CFF_CODIGO := "08"
			CFF->CFF_ANEXO  := "0"
			CFF->CFF_ART    := "71"
			CFF->CFF_INC    := "III"
			CFF->CFF_OBS    := "SAIDA S/PGTO IMP.-EXPORT.INDIRETA"
			CFF->CFF_NUMDOC := TMPD2->D2_DOC
			CFF->CFF_SERIE  := TMPD2->D2_SERIE
			CFF->CFF_CLIFOR := TMPD2->D2_CLIENTE
			CFF->CFF_LOJA	:= TMPD2->D2_LOJA
			MsUnLock("CFF")
		endif 
		nCount++
	endif
	TMPD2->(dbSkip())
enddo
Alert("Rotina executada. "+cValToChar(nCount)+" Registros atualizados...")
return


///////////////////////////////////////////////////////////////////////////////////////////
//Monta a relacao de perguntas que precisa para fazer o filtro.............................

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
AADD(aRegs,{cPerg,"01","Informe o Ano"	,"","","mv_ch1","C",04,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Informe o mes"	,"","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"03","Filial Destino" ,"","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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