#include 'protheus.ch'



user function AGF_CTB001(cCod, cGrupo, cTM)
Local _lRet   := .F.

//if substr(cOP,1,1) == space(1)
	IF ( AllTrim(SD3->D3_GRUPO)  <> '71' .AND. AllTrim(SD3->D3_GRUPO)  <> '72';
		.AND. AllTrim(SD3->D3_GRUPO)  <> '75' .AND. AllTrim(SD3->D3_GRUPO)  <> '91';
		.AND. AllTrim(SD3->D3_GRUPO)  <> '99')
		_lRet := .T.
	endif
//endif


return _lRet                             
                                         
user function _CTB002(cCod, cGrupo)
Local _cCod   := cCod
Local _lRet   := .F.
                                                                                          
	IF ( AllTrim(Substr(SD2->D2_GRUPO,3,2)) <> 'EX' .AND. AllTrim(SD2->D2_GRUPO)  <> '71';
		.AND. AllTrim(SD2->D2_GRUPO)  <> '72' .AND. AllTrim(SD2->D2_GRUPO)  <> '75';
		.AND. AllTrim(SD2->D2_GRUPO)  <> '91' .AND. AllTrim(SD2->D2_GRUPO)  <> '99' )
		_lRet := .T.
	endif


return _lRet                             


user function _CTB003(cTES)
Local _cTES   := cTES
Local _lRet   := .F.
                                                                                          
		_lRet := Posicione('SF4',1,xFilial('SF4')+_cTES,"F4_DUPLIC") = 'S'

return _lRet  


user function AG_CTB004(cCod, cGrupo, cTM)
Local _lRet   := .F.
Alert("ENTROU FUNÇÃO|"+ALLTRIM(cGrupo)+"|")
//if substr(cOP,1,1) == space(1)
	IF ( AllTrim(cGrupo)  = '71' .OR. AllTrim(cGrupo) = '72'.OR. AllTrim(cGrupo) = '75' .OR. AllTrim(cGrupo) = '91'.OR. AllTrim(cGrupo) = '99')
		_lRet := .T.
		Alert("grupo validado")
	endif
//endif


return _lRet                               


