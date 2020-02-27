#Include 'Protheus.ch'
#include 'rwmake.ch'
                         
//Função com objetivo de alimentar as alteracoes de produtos na tabela AIF
//Tentar resolver um erro que tem ocorrido na CAT83 para produtos que nao tem informacao nessa tabela.
//Desenvolvido por Anesio (anesio@anesio.com.br) em 25/04/2014

user function AG_INCAIF()
if APMSGNOYES("Confirmar a inclusao dos registros na tabela AIF para o campo B1_DESC ?","ATENCAO")
	Processa( { ||, INCAIF(),"Gerando lançamentos....." } )
else
	Alert("ROTINA ABORTADA")
endif
return 

//Funcao para gravar os registros na tabela AIF
static function INCAIF()

dbSelectArea("SB1")
dbSetOrder(1)
SB1->(dbGotop())
while !SB1->(eof())// .and. SB1->B1_COD < '000010'
	if !AG_VLDAIF(SB1->B1_COD)
		RecLock("AIF",.T.)
		AIF->AIF_TABELA := "SB1"
		AIF->AIF_CODPRO := SB1->B1_COD
		AIF->AIF_CAMPO  := "B1_DESC"
		AIF->AIF_CONTEU := SB1->B1_DESC
		AIF->AIF_DATA   := stod('20140423')
		AIF->AIF_HORA   := '12:00'
		MsUnlock("AIF")
//		Alert("Atualizando codigo....")
	endif
	SB1->(dbSkip())
enddo 


return

static function AG_VLDAIF(cCod)
local cQuery := ""
local lRet := .F. //Falso identifica que nao existe o cadastro em AIF
//Identificar quais produtos já possui o campo AIF_CONTEUD preenchido para B1_DESC
cQuery := " SELECT distinct AIF_CODPRO FROM AIF010 WHERE D_E_L_E_T_ =' ' AND AIF_CAMPO = 'B1_DESC' "
cQuery += " AND AIF_CODPRO = '"+cCod+"' " 
if select("TMP") > 0 
	dbSelectArea("TMP")
	TMP->(dbCloseArea())
endif
    
dbUseArea(.T.,"TOPCONN", tcGenQry(, , cQuery), "TMP", .T., .T.)
nCount := 0
dbSelectArea("TMP")
TMP->(dbGotop())
while !TMP->(eof())
   nCount++
   TMP->(dbSkip())
enddo

if nCount > 0
	lRet := .T.
endif
return lRet