#include 'protheus.ch'
#include 'rwmake.ch'

/////////////////////////////////////////////////////////////////////////////////////////////////
//Funcao desenvolvida para ser utilizada no campo C2_X_DRWBK para ordens de produção do 
//grupo 32 de PNP1. 
//Quando a OP for de produtos do grupo 32 será obrigatório o preenchimento do campo C2_X_DRWBK
/////////////////////////////////////////////////////////////////////////////////////////////////
user function vlddrwbk()
local lRet := .T.
local cGrupo := ""
if cfilant == "09"
	cGrupo := Posicione("SB1",1, xFilial("SB1")+M->C2_PRODUTO, "B1_GRUPO")
	if cGrupo == "32  "
		if !M->C2_X_DRWBK $ "SN"
			lRet := .F.
		endif
	endif
	if !lRet 
		Alert("Produto do grupo 32 precisa ser informado o campo de DRAWBACK")
		return lRet
	endif
	if lRet .and. M->C2_X_DRWBK == "S"
		if Posicione("SB1",1,xFIlial("SB1")+M->C2_PRODUTO, "B1_X_SGLDB") == space(4)
			Alert("O Produto selecionado não tem SIGLA DE LOTE"+chr(13)+"Para gerar lote você precisa preencher essa sigla no cadastro de produtos!")
			M->C2_X_DRWBK := ''
		else
			M->C2_X_LTDRW := u_ag_lotdrw(M->C2_PRODUTO)
			M->C2_X_PRODU := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO, "B1_X_35T32")
        endif
	endif
endif	
return lRet

/////////////////////////////////////////////////////////////////////////////////////////////////
//Funçao para gerar o Lote de Drawback conforme cadastrado no produto
/////////////////////////////////////////////////////////////////////////////////////////////////
user function ag_lotdrw(cProd)
local cLotDrw := " " 
local cQuery  := " "
cQuery := " SELECT MAX(Substring(C2_X_LTDRW,7,4)) cLOTE FROM "+RetSqlName("SC2")+" SC2 "
cQuery += " Where D_E_L_E_T_ = ' ' AND C2_FILIAL = '"+xFilial("SC2")+"' "
cQuery += " AND C2_PRODUTO = '"+cProd+"' " 

if Select("TMPC2") > 0 
	dbSelectArea("TMPC2")
	TMPC2->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPC2", .T., .T.)
dbSelectArea("TMPC2")
TMPC2->(dbGotop())

//cLotDrw := "DB"+Posicione("SB1",1,xFIlial("SB1")+cProd, "B1_X_SGLDBW")+SOMA1(PADL(TMPC2->cLOTE,4,"0"))
cLotDrw := "DB"+Posicione("SB1",1,xFIlial("SB1")+cProd, "B1_X_SGLDB")+SOMA1(PADL(TMPC2->cLOTE,4,"0"))
//Alert("Valor do Lote -> "+cLotDrw)

return cLotDrw


/////////////////////////////////////////////////////////////////////////////////////////////////
//Funçao para recalcular o saldo de estoque de drawback
//desenvolvido por Anesio (anesio@anesio.com.br) 
//Nenhum parametro implementado, apenas faz o recalculo geral partindo do inicio de utilização de lotes drawback
/////////////////////////////////////////////////////////////////////////////////////////////////
user function AG_RECDRB()
local cQuery := " " 
local pGrpDrb := GetMv( "MA_GRPDRB" )
local cGrpDrb := "'"
Local i

if APMSGNOYES("Confirma o recalculo dos saldos de lotes de DRAWBACK ? "+chr(13)+"ESTA ROTINA DEVE SER EXECUTADO EM MODO EXCLUSIVO!!!","ATENCAO -RECALCULO DRAWBACK")
	
	for i:= 1 to len(pGrpDrb)
		if substr(pGrpDrb,i,1) == "|" 
			cGrpDrb := cGrpDrb+Substr(pGrpDrb,i-4,4)+"','"
		endif
	next i 
	Alert("Grupos "+cGrpDrb)	
	cGrpDrb := Substr(cGrpDrb,1,len(cGrpDrb)-2)
	Alert("Grupos "+cGrpDrb)
	
	//Query para filtrar todos as producoes que controlam lotes de drawback
	cQuery := " Select D3_X_LTDRW, D3_NUMSEQ, D3_QUANT from "+RetSqlName("SD3")+" with (nolock) "
	cQuery += " where D_E_L_E_T_ =' ' and D3_FILIAL ='"+xFilial("SD3")+"' "
	cQuery += " and D3_GRUPO in ("+cGrpDrb+") and D3_CF= 'PR0' and D3_X_LTDRW <> '' AND D3_ESTORNO <> 'S' " 
	
	if Select("TMPD3") > 0 
		dbSelectArea("TMPD3")
		TMPD3->(dbCloseArea())
	endif
	
	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPD3", .T., .T.)
	
	aRestSZC := SZC->(GetArea())
	dbSelectArea("SZC")
	dbSetOrder(4) //Ordena pelo ZC_NUMSEQ o mesmo NUMSEQ do apontamento na SD3
	
	aRestSZD := SZD->(GetArea())
	dbSelectArea("SZD")
	dbSetOrder(4) //Ordena pelo ZD_NUMSEQ o mesmo NUMSEQ do lote na SZC

	nQtdZD := 0
	dbSelectArea("TMPD3")
	TMPD3->(dbGotop())
	while !TMPD3->(eof())
		if SZC->(dbSeek(xFilial("SZC")+TMPD3->D3_NUMSEQ))
			nQtdZD := 0
			if SZD->(dbSeek(xFilial("SZD")+SZC->ZC_NUMSEQ))
				while !SZD->(eof()).and.SZD->ZD_FILIAL == SZC->ZC_FILIAL .and. SZD->ZD_NSEQORI == SZC->ZC_NUMSEQ
					nQtdZD += SZD->ZD_QTDE
					SZD->(dbSkip())
				enddo
			endif
			RecLock("SZC",.F.)
			SZC->ZC_QTDENTR := TMPD3->D3_QUANT
			SZC->ZC_QTDSAID := nQtdZD
			MsUnLock("SZC")
		endif
		TMPD3->(dbSkip())
	enddo
	
	RestArea(aRestSZC)
	RestArea(aRestSZD)
	
	Alert("Rotina recalculada com sucesso....")
else
	Alert("ROTINA ABORTADA")
endif	
return


