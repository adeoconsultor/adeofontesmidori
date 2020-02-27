//Verifica se o funcionário que esta sendo demitido tem mais de 45 anos.

USER FUNCTION FChekData()
LOCAL _lRet  := .T.
LOCAL _cDia  := STRZERO(DAY(SRA->RA_NASC),2)
LOCAL _cMes  := STRZERO(MONTH(SRA->RA_NASC),2)
LOCAL _cAno  := STRZERO(YEAR(SRA->RA_NASC)+45,4)
LOCAL _d45An := CTOD(_cDia+'/'+_cMes+'/'+_cAno)

	IF DDATADEM >= _d45an
		AVISO('Específico MIDORI - ATENÇÃO!','O Funcionário '+SRA->RA_MAT+' - '+SRA->RA_NOME+' possui mais de 45 anos, neste caso o aviso prévio deve ser diferenciado, verifique a quantidade de dias do aviso prévio!',{'Ok'},1,'Mais de 45 anos!')
	ENDIF

_lRet  := .T.

RETURN(_lRet)