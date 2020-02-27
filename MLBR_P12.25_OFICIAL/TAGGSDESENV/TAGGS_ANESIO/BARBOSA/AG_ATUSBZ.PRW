#include 'protheus.ch'
#include 'rwmake.ch'


//Funcao com objetivo de gravar os produtos cadastrados na SG1 da filial 19 
//na tabela SBZ de acordo com os campos padroes da tabela SB1
//BZ_COD 		:= B1_COD
//BZ_LOCPAD 	:= B1_LOCPAD
//BZ_MCUSTD 	:= B1_MCUSTD
//BZ_DESC 		:= B1_DESC
//BZ_ESTSEG 	:= B1_ESTSEG
//BZ_PE			:= B1_PE
//BZ_TIPE		:= B1_TIPE
//BZ_LE			:= B1_LE
//BZ_LM			:= B1_LM
//BZ_MRP		:= B1_MRP
//BZ_TIPOCQ		:= B1_TIPOCQ
//BZ_EMAX		:= B1_EMAX
//BZ_PICM		:= B1_PICM
//BZ_IPI		:= B1_IPI
//BZ_ORIGEM		:= B1_ORIGEM
//BZ_GRTRIB		:= B1_GRTRIB
//BZ_PIS		:= B1_PIS
//BZ_COFINS		:= B1_COFINS
//BZ_CSLL		:= B1_CSLL


user function AG_AGUSBZ() 
	If ApMsgNoYes("Confirma a execução da rotina de cadastro da tabela SBZ ? ", "Atenção")
	
		Processa({||AtuBZ()},"Aguarde Processamento...")

	endif
return  

Static function AtuBZ()
local cQuery := ""
local nCount := 0
//Filtrar os componentes cadastrados na filial 19
cQuery := " Select distinct G1_COMP, B1_DESC from SG1010 SG1, SB1010 SB1 "
cQuery += " where SB1.D_E_L_E_T_ =' ' and SG1.D_E_L_E_T_ =' ' "
cQuery += " and B1_COD = G1_COMP and G1_FILIAL ='19' and Substring(B1_COD,1,3) <>'MOD' "
cQuery += " order by 1 " 

if Select("TMPG1") > 0 
	dbSelectArea("TMPG1")
	TMPG1->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPG1", .T., .T.)
dbSelectArea("TMPG1")
TMPG1->(dbGotop())


ProcRegua(0)
while !TMPG1->(eof())
	dbSelectArea("SBZ")
	dbSetOrder(1)
	if !dbSeek(xFilial("SBZ")+TMPG1->G1_COMP)
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+TMPG1->G1_COMP)
		RecLock("SBZ",.T.)
		SBZ->BZ_FILIAL  := xFilial("SBZ")
		SBZ->BZ_COD 	:= SB1->B1_COD
		SBZ->BZ_LOCPAD 	:= '02'
		SBZ->BZ_MCUSTD 	:= SB1->B1_MCUSTD
		SBZ->BZ_DESCR 	:= SB1->B1_DESC
		SBZ->BZ_ESTSEG 	:= SB1->B1_ESTSEG
		SBZ->BZ_PE		:= SB1->B1_PE
		SBZ->BZ_TIPE	:= SB1->B1_TIPE
		SBZ->BZ_LE		:= SB1->B1_LE
		SBZ->BZ_LM		:= SB1->B1_LM
		SBZ->BZ_MRP		:= SB1->B1_MRP
		SBZ->BZ_TIPOCQ	:= SB1->B1_TIPOCQ
		SBZ->BZ_EMAX	:= SB1->B1_EMAX
		SBZ->BZ_PICM	:= SB1->B1_PICM
		SBZ->BZ_IPI		:= SB1->B1_IPI
		SBZ->BZ_ORIGEM	:= SB1->B1_ORIGEM
		SBZ->BZ_GRTRIB	:= SB1->B1_GRTRIB
		SBZ->BZ_PIS		:= SB1->B1_PIS
		SBZ->BZ_COFINS	:= SB1->B1_COFINS
		SBZ->BZ_CSLL	:= SB1->B1_CSLL
		MsUnLock("SBZ")
		nCount++
	endif
	incProc("Aguarde Processamento...."+ALLTRIM(TMPG1->G1_COMP))
	TMPG1->(dbSkip())
enddo
Alert("Rotina finalizada com sucesso...atualizado "+cValToChar(nCount)+" registros..")
return