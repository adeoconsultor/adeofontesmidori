#include 'Protheus.ch'
#include 'rwmake.ch'


//Funcão para validação de grupos no PCO
//Solicitado por Sr.Amadeu em 20/01/2015 
//Desenvolvido por Anesio G.Faria - 20/01/2015 - anesio@anesio.com.br

user function AG_GRPPCO(cGRP, cTesM)
local lRet := .F.                                                        
local lEst := .F. 
local cQuery := ""

//lEst := Posicione("SF4", 1, xFilial("SF4")+cTesM, "F4_ESTOQUE") == "S"


cQuery := " SELECT F4_ESTOQUE  FROM "+RetSQLNAME("SF4")+ " SF4 WHERE SF4.D_E_L_E_T_ = ' ' AND F4_FILIAL = '"+xFilial("SF4")+"' "
cQuery += " AND F4_CODIGO = '"+cTesM+"' " 
if Select("TMPF4") > 0 
	dbSelectArea("TMPF4")
	TMPF4->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", TcGenQry(, , cQuery), "TMPF4", .T., .T.)

dbSelectArea("TMPF4")
TMPF4->(dbGotop())
lEst := TMPF4->F4_ESTOQUE == 'S'


if cFilant == "09" .and. lEst
	if cGRP $ '11  |12  |14  |18  |71  |72  |75  |'
		lRet := .T. 
		return lRet
	endif
elseif cFilant == "08" .and. lEst
	if cGRP $ '16  |75  |'
		lRet := .T.
		return lRet
	endif
Elseif cFilant $ "04|19" .and. lEst
	if cGRP $ '16  |18  |71  |72  |75  |'
		lRet := .T. 
		return lRet
	endif
Endif

return lRet
