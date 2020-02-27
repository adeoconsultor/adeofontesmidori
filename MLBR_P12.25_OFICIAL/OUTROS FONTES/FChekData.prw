//Verifica se o funcion�rio que esta sendo demitido tem mais de 45 anos.

USER FUNCTION FChekData()
LOCAL _lRet  := .T.
LOCAL _cDia  := STRZERO(DAY(SRA->RA_NASC),2)
LOCAL _cMes  := STRZERO(MONTH(SRA->RA_NASC),2)
LOCAL _cAno  := STRZERO(YEAR(SRA->RA_NASC)+45,4)
LOCAL _d45An := CTOD(_cDia+'/'+_cMes+'/'+_cAno)

	IF DDATADEM >= _d45an
		AVISO('Espec�fico MIDORI - ATEN��O!','O Funcion�rio '+SRA->RA_MAT+' - '+SRA->RA_NOME+' possui mais de 45 anos, neste caso o aviso pr�vio deve ser diferenciado, verifique a quantidade de dias do aviso pr�vio!',{'Ok'},1,'Mais de 45 anos!')
	ENDIF

_lRet  := .T.

RETURN(_lRet)