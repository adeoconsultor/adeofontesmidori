#INCLUDE "protheus.ch"
#Include "RwMake.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MAGPM03   ³ Autor ³ PrimaInfo             ³ Data ³ 25.02.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para limpeza da tabela SRZ                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Midori                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MAGPM03() 

SetPrvt("cQuery, cQuery_, cQuery1,")

	cQuery_ := "TRUNCATE TABLE " + RETSQLNAME("SRZ") 
	TcSqlExec(cQuery_)

Processa({|| Gerando() }, "Verificando Itens Contabilização")	
/*-----------------------------------------------
Verifica RA_ITEM preenchimento igual RA_ATLFLTR
-------------------------------------------------*/
Static Function Gerando()

Local ncont := 0

cQuery1 := "SELECT R_E_C_N_O_ NRECNO,* FROM "
cQuery1 += RetSqlName("SRA")+" SRA "
cQuery1 += " WHERE "
//cQuery1 += " SRA.RA_FILIAL <> RA_ATLFLTR AND "
cQuery1 += " SRA.RA_SITFOLH  IN ('','A','F') AND "
cQuery1 += " SRA.RA_ITEM <> RA_ATLFLTR AND "
cQuery1 += " SRA.RA_ATLFLTR <> '' AND "
cQuery1 += " SRA.D_E_L_E_T_ = ''"

If Select("TRB") > 0 
	dbSelectArea("TRB") 
	TRB->(dbCloseArea())
Endif
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TRB",.F.,.F.)   
	
	DbSelectArea("TRB")
	ProcRegua(RecCount())
	DbGotop()
	
	Do While !eof() 
		IncProc('Verificando Itens....')	
		ncont++	  
		TRB->(dbSkip())
		
	Enddo
	
If ncont > 0
	cQuery      := "BEGIN TRANSACTION  "
	cQuery      += "UPDATE  "
	cQuery      += +RetSqlName("SRA")+" "
	cQuery 		+= "SET RA_ITEM = RA_ATLFLTR "
	cQuery 		+= " WHERE "
	//cQuery		+= " RA_FILIAL <> RA_ATLFLTR AND "
	cQuery 		+= " RA_SITFOLH  IN ('','A','F') AND "
	cQuery 		+= " RA_ITEM <> RA_ATLFLTR AND "
	cQuery 		+= " RA_ATLFLTR <> '' AND "
	cQuery 		+= " D_E_L_E_T_ = ''"
	cQuery      += "COMMIT "
	TcSqlExec(cQuery)
EndIf	
IncProc("Finalizado....")
sleep( 5000 )				
Processa({|| GPEM110() }, "Processando Contabilização")	
	
//   	U_AG_CALCDES()
//Return

//Static Function GP110APL()
//   	U_AG_CALCDES()	
	
//Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Funcao adicionada por Anesio...  05/11/2012.
//Objetivo gerar os lançamentos da desoneracao da folha.
//Vai pegar o total da verba 989 dividir pelo total da verba 747 e multiplicar pela verba do funcionario.
////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*user function AG_CALCDES()
local cQRZ := ""
Local cQRZ747 := ""
Local cQRZFNC := ""
Local nIndice := 0
Local nCount  := 0

//Alert('Chamou a função de geracao VERBA 989') 
//Verifica se já existe o arquivo Temporário em memoria e faz a exclusão do mesmo...
if Select('TMPRZ') > 0
	dbSelectArea('TMPRZ')
	TMPRZ->(dbCloseArea())
endif

cQRZ := " SELECT RZ_FILIAL, RZ_CC, RZ_MAT, RZ_PD, RZ_VAL, RZ_OCORREN, RZ_TIPO, RZ_TPC FROM SRZ010 "
cQRZ += " WHERE D_E_L_E_T_ = ' ' AND RZ_FILIAL <> 'ZZ' AND RZ_CC = 'ZZZZZZZZZ' "

dbUseArea(.T., 'TOPCONN', tcGenQry( , , cQRZ), 'TMPRZ', .T.,.T.)

//Varrer a tabela Temporária criada e fazer a soma da verba 747 da tabela SRZ.
dbSelectArea('TMPRZ')
TMPRZ->(dbGotop())
while !TMPRZ->(eof())
nCount := 0  
	//Verifica se já existe o arquivo Temporário em memoria e faz a exclusão do mesmo...	
	if Select('TMP747') > 0 
		dbSelectArea('TMP747')
		TMP747->(dbCloseArea())
	endif
	
	cQRZ747 := " SELECT SUM(RZ_VAL) RZ_VAL FROM SRZ010 WHERE D_E_L_E_T_ = ' ' AND RZ_FILIAL ='"+TMPRZ->RZ_FILIAL+"' "
	//cQRZ747 += " AND RZ_CC = 'zzzzzzzzz' and RZ_MAT = 'zzzzzz' 
	cQRZ747 += " and RZ_PD = '747' and RZ_FILIAL <> 'zz'	"
	
	dbUseArea(.T., 'TOPCONN', tcGenQry(,, CQRZ747), 'TMP747',.T.,.T.)
	
	dbSelectArea('TMP747')
	//Verifica se a somatória é maior que 0 para evitar divisao por zero...
	if TMP747->RZ_VAL > 0 
		nIndice := TMPRZ->RZ_VAL / TMP747->RZ_VAL
	else
		nIndice := 0
	endif
//	Alert(' FILIAL -> '+TMPRZ->RZ_FILIAL+' VALOR VERBA 989 -> '+cValToChar(TMPRZ->RZ_VAL)+ ' VALOR VERBA 747 -> '+cValToChar(TMP747->RZ_VAL)+'Valor do Indice '+cValToChar(nIndice))
	//Verifica se já existe o arquivo Temporário em memoria e faz a exclusão do mesmo...
	if Select('TMPFNC') > 0 
		dbSelectArea('TMPFNC')
		TMPFNC->(dbCloseArea())
	endif
	
	cQRZFNC := " SELECT RZ_FILIAL, RZ_CC, RZ_MAT, RZ_PD, RZ_VAL, RZ_OCORREN, RZ_TIPO, RZ_TPC FROM SRZ010 "
	cQRZFNC += " WHERE D_E_L_E_T_ = ' ' AND RZ_FILIAL <> 'zz' AND RZ_CC <> 'zzzzzzzzz' AND RZ_PD <> 'zzz' AND RZ_PD = '747' "
	cQRZFNC += " AND RZ_FILIAL = '"+TMPRZ->RZ_FILIAL+"' AND RZ_MAT <> 'zzzzzz' " 
	cQRZFNC += " ORDER BY RZ_MAT ."
				  
	dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQRZFNC), 'TMPFNC', .T.,.T.)

	dbSelectArea('TMPFNC')
	dbGotop()
	
	while !TMPFNC->(eof())
//		Alert('FILIAL -> '+TMPFNC->RZ_FILIAL+' MATRICULA -> '+TMPFNC->RZ_MAT+' VALOR VERBA 747 -> '+cValToChar(TMPFNC->RZ_VAL))
		if Upper(TMPFNC->RZ_FILIAL) <>'ZZ' .and. UPPER(Substr(TMPFNC->RZ_CC,1,3)) <> 'ZZZ'
			RecLock('SRZ',.T.)
			SRZ->RZ_FILIAL 	:= TMPFNC->RZ_FILIAL
			SRZ->RZ_CC		:= TMPFNC->RZ_CC
			SRZ->RZ_MAT		:= TMPFNC->RZ_MAT
			SRZ->RZ_PD		:= TMPRZ->RZ_PD
			SRZ->RZ_HRS		:= 0
			SRZ->RZ_VAL 	:= nIndice * TMPFNC->RZ_VAL
			SRZ->RZ_OCORREN := TMPFNC->RZ_OCORREN
			SRZ->RZ_TIPO	:= 'FL'
			SRZ->RZ_ITEM	:= TMPRZ->RZ_FILIAL
			SRZ->RZ_CLVL 	:= '999999999' 
			SRZ->RZ_TPC		:= TMPFNC->RZ_TPC
			MsUnLock('SRZ')
		endif
			TMPFNC->(dbSkip())
			nCount++
		enddo
//	Alert('Atualizado -> '+cValToChar(nCount)+' registros...para a filial '+TMPRZ->RZ_FILIAL)
	TMPRZ->(dbskip())

enddo

if Select('TMPFNC') > 0 
	dbSelectArea('TMPFNC')
	TMPFNC->(dbCloseArea())
endif
	
cQRZFNC := " SELECT RZ_FILIAL, RZ_CC, RZ_ITEM, Sum(RZ_VAL) RZ_VAL " 
cQRZFNC += " FROM SRZ010  WHERE D_E_L_E_T_ = ' ' AND RZ_FILIAL <> 'ZZ' " 
cQRZFNC += " and RZ_PD = '989'  and RZ_OCORREN = 1 and RZ_CC <> 'ZZZZZZZZZ' " 
cQRZFNC += " and RZ_MAT <> '990039' "
cQRZFNC += " group by RZ_FILIAL, RZ_CC, RZ_ITEM " 

dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQRZFNC), 'TMPFNC', .T.,.T.)

dbSelectArea("TMPFNC")
TMPFNC->(dbGotop())
nCount:= 0
while !TMPFNC->(eof())
	if Upper(TMPFNC->RZ_FILIAL) <>'ZZ'.and. UPPER(Substr(TMPFNC->RZ_CC,1,3)) <> 'ZZZ'.and.UPPER(Substr(TMPFNC->RZ_ITEM,1,1)) <> 'Z'
		RecLock('SRZ',.T.)
		SRZ->RZ_FILIAL 	:= TMPFNC->RZ_FILIAL
		SRZ->RZ_CC		:= TMPFNC->RZ_CC
		SRZ->RZ_MAT		:= 'zzzzzz' 
		SRZ->RZ_PD		:= '989'
		SRZ->RZ_HRS		:= 0
		SRZ->RZ_VAL 	:= TMPFNC->RZ_VAL
		SRZ->RZ_OCORREN := 3
		SRZ->RZ_TIPO	:= 'FL'
		SRZ->RZ_ITEM	:= TMPFNC->RZ_ITEM
		SRZ->RZ_CLVL 	:= '999999999' 
		SRZ->RZ_TPC		:= '1'
		MsUnLock('SRZ')
	endif		
		nCount++
	//	Alert('Acrescentando Registro '+cValToChar(nCount)+' Matricula '+SRZ->RZ_MAT+' C.CUSTO: '+SRZ->RZ_CC)
		TMPFNC->(dbSkip())

enddo
//Alert('Acrescentando '+cValToChar(nCount)+' registros...')

return
