#include 'protheus.ch'
#include 'rwmake.ch'


///////////////////////////////////////////////////////////////////////////////////////////////////
//Função para atualizar as novas MODs no SG1
//
///////////////////////////////////////////////////////////////////////////////////////////////////
user function AG_ATUMDG1()
local aProd := {}
local cQuery := ''
Local i
if ApMsgYesNo("Confirma a inclusão das Mao de Obra para os itens digitados ? ","Atenção")

	//Rotina para filtrar as Pecas, jogar no array e depois fazer a segunda consulta..
	if cFilant == '09'
		cQAnt := " Select distinct Substring(D3_COD,1,6) COD_PRO, B1_DESC, B1_GRUPO from SD3010 SD3, SB1010 SB1 "
		cQAnt += " where SD3.D_E_L_E_T_ =' '  and SB1.D_E_L_E_T_ =' ' "
		cQAnt += " and D3_COD = B1_COD and D3_FILIAL = '09' and Substring(D3_EMISSAO,1,4)='2014' and D3_CF = 'PR0' " //
		cQAnt += " and Substring(D3_COD,1,6) in ('042728','042729','042730','042731','042732','042733','042734','042735','042736','042737','042738','042739','042988','043285','043849','043850','027135','044214','038212','038206','041801','041796','042908','042959','030566','030567','030568','013339','013340','032685' )"
//		and D3_GRUPO in ('45','55OM') "

//		cQAnt += " and B1_DESC not like '%PERFURADO%' "
		if select("QANT") > 0 
			dbSelectArea("QANT")
			QANT->(dbCloseArea())
		endif
		dbUseArea(.T., "TOPCONN", tcGenQry(, , cQAnt), "QANT", .T.,.T.)
		dbSelectArea("QANT")
		QANT->(dbGotop())
		cArPrd := "'"
		nCont  := 0
		while !QANT->(eof())
			 cArPrd := cArPrd + QANT->COD_PRO+"','"
			 nCont++
			QANT->(dbSkip())
		enddo
		Alert("Inserido "+cValToChar(ncont)+" Registros...")
		nCont := 0
		cArPrd := Substr(cArPrd,1,len(cArPrd) -2)
		for i := 1 to len(cArPrd)
			if substr(cArPrd,i,1) == ","
				nCont++
			endif
		next i 
		Alert(cValToChar(nCont)+ " Produtos na variável...")
	endif

	if cFilant == '09' 
		cQuery := "Select distinct G1_COMP from SG1010 SG1, SB1010 SB1 where SG1.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' and G1_FILIAL = '09'  "
		cQuery += " and B1_COD = G1_COMP " //and B1_DESC not like '%DUBLADO%' " 
		cQuery += " and Substring(G1_COMP,1,3) <> 'MOD' " 
		cQuery += " AND G1_COMP in ('042728','042729','042730','042731','042732','042733','042734','042735','042736','042737','042738','042739','042988','043285','043849','043850','027135','044214','038212','038206','041801','041796','042908','042959','030566','030567','030568','013339','013340','032685' )"
	endif

	if Select("TMPG1") > 0 
		dbSelectArea("TMPG1")
		TMPG1->(dbCloseArea())
	endif
	
	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPG1", .T., .T.)
	cprod:= ",013375,024539,027136,027137,027138,027139,030567,030568,032686,032687,038200,038201,038202,038204,038207,038208,038209,038210,041797,041798,041799,041800,041802,041803,041804,041805,042598,042599,042600,042601,042602,042603,042604,042606,042607,042608,042609,042610,042611,042612,042613,042614,042615,042616,042617,042618,042619,042620,042621,042622,042623,042624,042625,042626,042627,042628,042629,042630,042631,042632,042633,042634,042635,042636,042637,042639,042640,042906,042907,042955,042956,042957,042958,042984,043284,043839,043841,043842,043844,043846,043848,044210,044211,044212,044213"
	/*dbSelectArea("TMPG1")
	TMPG1->(dbGotop())
	while !TMPG1->(eof())
		aadd(aProd, {TMPG1->G1_COMP})
		TMPG1->(dbSkip())
	enddo                 
	*/
	ncount:= 0
	for i:= 1 to len(cprod)
		if substr(cprod,i,1) ==','
			aadd(aProd, {substr(cprod,i+1,6)})
			ncount++
		endif
	next i 
	alert('Adicionado '+cValTochar(ncount)+' pecas')
	processa( {||AG_ATUMOD(aProd) }, "Atualizando Estrutura de Mão de Obra...")
endif 
return
	
static function AG_ATUMOD(aProd)
local cQPeca 	:= ""
local aMod 		:= {}
Local nMod,i


aadd(aMod, {'MOD320501      '})
aadd(aMod, {'MOD350004      '})
aadd(aMod, {'MOD360004      '})
aadd(aMod, {'MOD370004      '})
aadd(aMod, {'MOD370104      '})
aadd(aMod, {'MOD370403      '})
aadd(aMod, {'MOD380004      '})
aadd(aMod, {'MOD380104      '})
aadd(aMod, {'MOD380204      '})
aadd(aMod, {'MOD380404      '})
//aadd(aMod, {      '})
//aadd(aMod, {'      '})


nCount := 0

dbSelectArea("SG1")
dbSetOrder(2)
for i:= 1 to len(aProd)
	cQPeca := " SELECT G1_COD, G1_COMP, G1_QUANT, B1_GRUPO, G1_INI, G1_FIM, G1_NIV, G1_NIVINV  from SG1010 SG1, SB1010 SB1 "
	cQPeca += " WHERE SB1.D_E_L_E_T_ =' ' and SG1.D_E_L_E_T_ =' ' AND G1_COMP = B1_COD "
	cQPeca += " and G1_COD = '"+aProd[i][1]+"' "
	cQPeca += " and G1_COMP = B1_COD " 
	cQPeca += " and G1_FILIAL = '"+xFilial("SG1")+"' and B1_GRUPO in ('16','48','40','40A') " 
	cQPeca += " Order by B1_GRUPO "
	
	if select("TMP") > 0 
		dbSelectArea("TMP")
		TMP->(dbCloseArea())
	endif
	
    dbUseArea(.T., "TOPCONN", tcGenQry(, , cQPeca), 'TMP', .T.,.T.)
    nQt 	:= 0
    cDtIni 	:= ""
    cDtFim	:= ""
    cNiv	:= ""
    cNivInv := ""
    cCod	:= ""
    cComp   := ""
    lInc 	:= .F.
    dbSelectArea("TMP")
    TMP->(dbGotop())
    while !TMP->(eof())
		if nQt == 0 
	    	if AllTrim(TMP->B1_GRUPO) == "16" 
	    		nQt 	:= TMP->G1_QUANT
			    cDtIni 	:= TMP->G1_INI
			    cDtFim	:= TMP->G1_FIM
			    cNiv	:= TMP->G1_NIV
			    cNivInv := TMP->G1_NIVINV
			    cCod	:= TMP->G1_COD
			    cComp   := TMP->G1_COMP
			    lInc 	:= .T.
	    	elseif AllTrim(TMP->B1_GRUPO) == "40" 
	    		nQt 	:= TMP->G1_QUANT
			    cDtIni 	:= TMP->G1_INI
			    cDtFim	:= TMP->G1_FIM
			    cNiv	:= TMP->G1_NIV
			    cNivInv := TMP->G1_NIVINV
			    cCod	:= TMP->G1_COD
			    cComp   := TMP->G1_COMP
			    lInc 	:= .T.
	    	else
	    		nQt 	:= TMP->G1_QUANT
			    cDtIni 	:= TMP->G1_INI
			    cDtFim	:= TMP->G1_FIM
			    cNiv	:= TMP->G1_NIV
			    cNivInv := TMP->G1_NIVINV
			    cCod	:= TMP->G1_COD
			    cComp   := TMP->G1_COMP
			    lInc 	:= .T.
	    	endif
	 	endif
    	TMP->(dbSkip())
    enddo
	
	for nMod := 1 to len(aMod)
		if lInc 
			dbSelectArea("SG1")
			dbSetOrder(2)
			if !dbSeek(xFilial("SG1")+aMod[nMod][1]+cCod)
				recLock("SG1",.T.)
				SG1->G1_FILIAL	:= xFilial("SG1")
				SG1->G1_COD		:= cCod
				SG1->G1_COMP	:= aMod[nMod][1]
				SG1->G1_QUANT	:= nQt
				SG1->G1_TRT		:= ''
				SG1->G1_PERDA	:= 0
				SG1->G1_INI		:= stod('20140401')
				SG1->G1_FIM		:= stod('20491231') //stod(cDtFim)
				SG1->G1_OBSERV	:= ''
				SG1->G1_FIXVAR	:= 'V'
				SG1->G1_GROPC	:= ''
				SG1->G1_OPC		:= ''
				SG1->G1_REVFIM	:= ''
				SG1->G1_NIV		:= cNiv
				SG1->G1_NIVINV	:= cNivInv
				SG1->G1_POTENCI := 0
				SG1->G1_VLCOMPE	:= 'N'
				SG1->G1_UM		:= 'UN'
				MsUnlock("SG1")
				nCount++
			endif
		endif
	next nMod
next i 
Alert('inclusão realizada com sucesso de '+cValToChar(nCount)+' Registros' )
return

