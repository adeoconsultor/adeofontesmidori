#include 'protheus.ch'
#include 'rwmake.ch'

//Funcao com objetivo de resolver problema de OPs que foram apontadas sem requisição no mes 11/2014
//desenvolvida por Anesio G.Faria em 19/11/2014 - anesio@anesio.com.br

user function AG_REFD3()
local cQD3 := ""
local aOps := {}
local aNSeq:= {}
Local i

/*cQD3 := " SELECT  distinct D3_NUMSEQ, D3_COD, R_E_C_N_O_ NREC from "+RetSqlName("SD3")+" Where D_E_L_E_T_ = ' ' AND D3_FILIAL = '09' AND SUBSTRING(D3_EMISSAO,1,6)='201411' "
cQD3 += " AND D3_CF = 'PR0' "
cQD3 += " ORDER BY D3_NUMSEQ " 

if Select("TMPD3") > 0 
	dbSelectArea("TMPD3")
	TMPD3->(dbCloseArea())
endif
Alert("Iniciando....")
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQD3), "TMPD3", .T., .T.)
Alert("Query1 Executada...")





cQD3R := " SELECT  distinct D3_NUMSEQ from "+RetSqlName("SD3")+" with (nolock) Where D_E_L_E_T_ = ' ' AND D3_FILIAL = '09' AND SUBSTRING(D3_EMISSAO,1,6)='201411' "
cQD3R += " AND D3_CF <> 'PR0' AND D3_OP <> '' "
cQD3R += " ORDER BY D3_NUMSEQ " 

if Select("TMPD3R") > 0 
	dbSelectArea("TMPD3R")
	TMPD3R->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", tcGenQry(, , cQD3R), "TMPD3R", .T., .T.)
Alert("Query1 Executada...")

nCount:= 0
dbSelectArea("TMPD3R")
TMPD3R->(dbGotop())
while !TMPD3R->(eof())
	AADD(aNSeq, {TMPD3R->D3_NUMSEQ})
	nCount++
	TMPD3R->(dbSkip())
enddo
Alert("TMPD3R ENCERRADA..."+cValToChar(nCount))

nCount:= 0
nCtLoc:= 0
nPos := 0
cRec  := ""
dbSelectArea("TMPD3")
TMPD3->(dbGotop())
while !TMPD3->(eof())
	cRec := TMPD3->D3_NUMSEQ
	nPos := AScan( aNSeq, {|x|x[1]== cRec }) 
//    nPos := Ascan(aNumSeq,{|x|x[1]== D5_NUMSEQ })	
	if nRec == 0
			AADD(aOPs, {TMPD3->D3_NUMSEQ, TMPD3->D3_COD, TMPD3->NREC} )
			nCount++
	endif
	TMPD3->(dbSkip())
enddo */

Alert("Iniciando..")


cQD3 := " Select D3_NUMSEQ, D3_COD, R_E_C_N_O_ NREC from SD3010 with (nolock) where D_E_L_E_T_ =' ' and D3_FILIAL ='09' "
cQD3 += " and D3_NUMSEQ in ('9F50VB') "
//cQD3 += " '9F3MBB','9F3MCI','9F3MB1','9F3JBF','9F3JGQ','9F3JHY','9F3JSE','9F3JSG','9F3JSM','9F3JYO','9F3JYK','9F3JB6','9F3JB8','9F3JBA','9F3JBC','9F3JYI','9F3LIS','9F3JYM','9F3JSI','9F3JHU','9F3JGD','9F3JYS','9F3LIX','9F3LLC','9F3MB9','9F3LKF','9F3MCK','9F3MBQ','9F3MBU','9F3LKB','9F3MBH','9F3LM0', "
//cQD3 += " '9F3LJ1','9F3LJ5','9F3JSK','9F3JYQ','9F3LIU','9F3OO2','9F3OO4','9F3Q2O','9F3Q2Q','9F3Q3B','9F3Q3D','9F3Q4R','9F3Q4V','9F3Q7F','9F3Q7D','9F3OO6','9F3OKE','9F3NHS','9F3OJG','9F3Q53','9F3Q6M','9F3Q6S','9F3OL8','9F3OOE','9F3ORM','9F3OLQ','9F3Q51', "
//cQD3 += " '9F3Q77','9F3R0Q','9F3OO0','9F3OKI','9F3OOB','9F3ONM','9F3NHW','9F3OJC','9F3OJE','9F3NHU') " 
cQD3 += " order by 1  " 
                        

if Select("TMPD3") > 0 
	dbSelectArea("TMPD3")
	TMPD3->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQD3), "TMPD3", .T., .T.)

nCount := 0
dbSelectArea("TMPD3")
TMPD3->(dbGotop())
while !TMPD3->(eof())
	AADD(aOPs, {TMPD3->D3_NUMSEQ, TMPD3->D3_COD, TMPD3->NREC} )
	nCount++
	
	TMPD3->(dbSkip())
enddo




/*
Procregua(0)
dbSelectArea("TMPD3")
nCount:= 0
nCtLoc:= 0
nRec  := 0
TMPD3->(dbGotop())
while !TMPD3->(eof())
	lRet := .F.
	nRec++
	dbSelectArea("SD3")
	dbSelectArea(1) //D3_FILIAL+D3_NUMSEQ+D3_CHAVE+D3_COD
	if SD3->(dbSeek(xFilial("SD3")+TMPD3->D3_OP))
		nCtLoc++
		while !SD3->(eof()).and.xFilial("SD3")=="09".and.SD3->D3_NUMSEQ == TMPD3->D3_NUMSEQ
			if SD3->D3_CF <> 'PR0'
				lRet := .T.
				nCount++
			endif
			SD3->(dbSkip())
		enddo
		if !lRet     
			Alert("Adicionando NUMSEQ => "+SD3->D3_NUMSEQ)
			AADD(aOPs, {SD3->D3_OP, SD3->D3_NUMSEQ, SD3->D3_QUANT} )
		endif
	endif
	IncProc("Registros analisados--> "+cValToChar(nCount)+" "+TMPD3->D3_NUMSEQ)
	TMPD3->(dbSkip())
enddo */
cNumSeq  := ""
for i:= 1 to len(aOPs)
	cNumSeq := cNumSeq+"'"+aOPs[i][1]+"',"
next i 
Alert("FOR Encerrado...."+cValToChar(nCount))
memowrite('E:\Protheus11\arqD3.txt', cNumSeq )
//alert('Executado com sucesso! '+cValToChar(len(aOPs))+ " ANALISADO -> "+cValToChar(nCount)+" LOCALIZADO-> "+cValToChar(nCtLoc)+" TOTAL REG-> "+cValToChar(nRec))

//	AADD(aOPs, {TMPD3->D3_NUMSEQ, TMPD3->D3_COD, TMPD3->NREC} )
for i:= 1 to len(aOPs)
	U_GERAD3(aOPS[i][1], aOPs[i][2],aOPs[i][3] )
next i 

return lRet

user function GERAD3(cNumSeq, cProd, nREC)
local cQSC2   := ""
local cTM     := "999"
local cCodPro := ""
local nQtde   := 0
local nQtdeAc := 0
local cCF     := "RE1" 
local cConta  := ""
local cOP     := ""
local cLocal  := ""
local dEmiss  := dDataBase
local cCC     := ""
local cNumSeq := ""
local cIdent  := ""
local cDoc    := ""
//D3_FILIAL, D3_TM, D3_COD, D3_UM, D3_QUANT, D3_CF, D3_CONTA, D3_OP, D3_LOCAL, D3_EMISSAO, D3_CC, D3_NUMSEQ, D3_TIPO, D3_IDENT, 
dbSelectArea("SD3")
SD3->(dbGoto(nREC))
nQtdeAc:= SD3->D3_QUANT
cOP    := SD3->D3_OP
dEmiss := SD3->D3_EMISSAO
cCC    := SD3->D3_CC
cNumSeq:= SD3->D3_NUMSEQ
cDoc   := SD3->D3_DOC

cIdent := SD3->D3_IDENT

cQSC2 := " SELECT G1_COMP, G1_QUANT, G1_FIXVAR FROM SG1010 SG1 WHERE D_E_L_E_T_ = ' ' AND G1_FILIAL = '"+xFilial("SG1")+"' AND G1_COD = '"+cProd+"' AND SUBSTRING(G1_FIM,1,6) >= '201410' " 
if Select("TMPG1") >0 
	dbSelectArea("TMPG1")
	TMPG1->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", TcGenQry(, , cQSC2), "TMPG1", .T., .T.)
//SELECT G1_COMP, G1_QUANT FROM SG1010 SG1 WHERE G1_FILIAL = '09' AND G1_COD = '037888' AND SUBSTRING(G1_FIM,1,6) >= '201410' 
dbSelectArea("TMPG1")
TMPG1->(dbGOtop())
while !TMPG1->(eof())
	cCodPro:= TMPG1->G1_COMP
	nQtde  := iif(TMPG1->G1_FIXVAR == 'F', TMPG1->G1_QUANT, TMPG1->G1_QUANT * nQtdeAc)
	RecLock("SD3",.T.)
	SD3->D3_FILIAL := xFilial("SD3")
	SD3->D3_COD    := cCodPro
	SD3->D3_TM     := cTM
	SD3->D3_UM     := Posicione("SB1",1, xFilial("SB1")+SG1->G1_COMP, "B1_UM")
	SD3->D3_QUANT  := nQtde 
	SD3->D3_CF     := cCF 
	SD3->D3_DOC    := cDoc
	SD3->D3_EMISSAO:= dEmiss
	SD3->D3_GRUPO  := Posicione("SB1",1, xFilial("SB1")+SG1->G1_COMP, "B1_GRUPO")
	SD3->D3_CONTA  := Posicione("SB1",1, xFilial("SB1")+SG1->G1_COMP, "B1_CONTA")
	SD3->D3_OP     := cOP
	SD3->D3_ITEMCTA:= xFilial("SD3")
	SD3->D3_LOCAL  := iif(Posicione("SBZ",1, xFilial("SBZ")+SG1->G1_COMP, "BZ_LOCPAD")<>space(2), Posicione("SBZ",1, xFilial("SBZ")+SG1->G1_COMP, "BZ_LOCPAD"), Posicione("SB1",1, xFilial("SB1")+SG1->G1_COMP, "B1_LOCPAD"))
	SD3->D3_CC     := cCC
	SD3->D3_NUMSEQ := cNumSeq
	SD3->D3_TIPO   := Posicione("SB1",1, xFilial("SB1")+SG1->G1_COMP, "B1_TIPO")
	SD3->D3_IDENT  := cIdent
	SD3->D3_USUARIO:= "ANESIO-ROTINA AUTOMATICA"
	MsUnLock("SD3")
	TMPG1->(dbSkip())
enddo





Alert("Itens incluido com sucesso..."+cNumSeq)


return