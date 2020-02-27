#include 'Protheus.ch'
#include 'rwmake.ch'

user function AG_ATUSRC()
local cQuery := ""

///cQuery := " Select RC_FILIAL, RC_MAT, round(sum((RC_VALOR / 26) * 5),2) nV116 from SRC010 "
cQuery := " Select RC_FILIAL, RC_MAT, round(Sum((RC_VALOR) * 0.043209),2) nV949 FROM SRC010 "
cQuery += " where D_E_L_E_T_ =' ' "
cQuery += " and RC_FILIAL = '"+xFilial("SRC")+"' "
cQuery += " and RC_PD in ('703','704','709','710') "
cQuery += " group by RC_FILIAL, RC_MAT  "
cQuery += " order by 1,2 "

if Select("TMPSRC") > 0
	dbSelectArea("TMPS		RC")
	TMPSRC->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", tcGenQry(,, cQuery), 'TMPSRC', .T., .T.)

dbSelectArea("TMPSRC")
TMPSRC->(dbGotop())
dbSelectArea('SRC')
dbSetOrder(1)

while !TMPSRC->(eof())
	if dbSeek(xFilial("SRC")+TMPSRC->(RC_MAT)+"749")
//		If ApMsgYesNo("Confirma alteração da verda para o funcionario "+SRC->RC_MAT+" Verba "+SRC->RC_PD+chr(13)+;
//			"Soma verba 018 + 051 = "+cValToChar(TMPSRC->nV949))
			RecLock("SRC",.F.)
				replace RC_VALOR with TMPSRC->nV949
//				replace RC_TIPO1 with 'V'
//				replace RC_HORAS with 0
//				replace RC_TIPO2 with 'I'
		    MsUnLock("SRC")
//		endif

	endif
	TMPSRC->(dbSkip())
enddo

Alert('Rotina finalizada com sucesso')



return