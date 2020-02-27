#include 'protheus.ch'
#include 'rwmake.ch'

user function AG_CATD3()
local cQuery := ""

cQuery := " Select CHVCAT, NREG from ( Select Distinct D3_X_LTDRW+D3_COD CHVCAT, Count(*) NREG from SD3010 "
cQuery += " where D_E_L_E_T_ =' ' and D3_FILIAL ='09' and Substring(D3_EMISSAO,1,6)='201401' "
cQuery += " and D3_OP <> '' group by D3_X_LTDRW+D3_COD) FDUPL where NREG > 1 order by 2 desc  "

if Select("TMP1") > 0 
	dbSelectArea("TMP1")
	TMP1->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", TcGenQry(, , cQuery), "TMP1", .T., .T.)

cQALTD3 := ""
nQtReg  := TMP1->NREG
DbSelectArea("TMP1")
TMP1->(dbGotop())
RecCount(0)
while !TMP1->(eof())
	nQtReg  := TMP1->NREG
	cQALTD3 := " Select D3_X_LTDRW, D3_NUMSEQ, R_E_C_N_O_ nReg from SD3010 where D_E_L_E_T_= ' ' and D3_FILIAL ='09'  and Substring(D3_EMISSAO,1,6)='201401' "
	cQALTD3 += " and D3_X_LTDRW+D3_COD = '"+TMP1->CHVCAT+"' ORDER BY D3_NUMSEQ " 
	
	if Select("TMP2") > 0 
		dbSelectArea("TMP2")
		TMP2->(DbCloseArea())
	endif
	dbUseArea(.T., "TOPCONN", TcGenQry(, , cQALTD3), "TMP2", .T., .T.)
     
	nCount:=0
	dbSelectArea("TMP2")
	TMP2->(dbGotop())
	while !TMP2->(eof())
		nRecNo := TMP2->nReg
		dbSelectArea("SD3")
		SD3->(dbGoto(nRecNo))
		RecLock("SD3",.F.)
		SD3->D3_X_LTDRW := Substr(SD3->D3_X_LTDRW,1,9)+cValToChar(nCount)
		MsUnLock("SD3")
		nCount++
		TMP2->(dbSkip())
	enddo
	TMP1->(dbSkip())
enddo
Alert("Rotina encerrada com sucesso...")

return