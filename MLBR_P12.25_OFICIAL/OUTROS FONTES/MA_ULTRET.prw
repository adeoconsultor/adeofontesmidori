#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	MA_ULTRET()
// Autor 		Alexandre Dalpiaz
// Data			10/06/10
// Descricao  	Traz a data do último retorno de afastamento.
// Uso         	Midori Atlantica
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MA_ULTRET()
////////////////////////
Local _cEnter := chr(13) + chr(10)
Local _lRet   := .f.

If SRA->RA_SITFOLH == "A" .and. !SRA->RA_AFASFGT $ "Q8"

	_aAlias := GetArea()
		
	_cQuery := "SELECT SR8.*"
	_cQuery += _cEnter + " FROM " + RetSqlName("SR8") + " SR8,"
	_cQuery += _cEnter + " ("
	_cQuery += _cEnter + " SELECT MAX(R8_DATAINI) DATAINI"
	_cQuery += _cEnter + " FROM " + RetSqlName("SR8") + " SR8"
	_cQuery += _cEnter + " WHERE SR8.D_E_L_E_T_ <> '*'"
	_cQuery += _cEnter + " AND R8_FILIAL = '" + SRA->RA_FILIAL  + "'"
	_cQuery += _cEnter + " AND R8_MAT = '" 	  + SRA->RA_MAT 	+ "'"
	_cQuery += _cEnter + " ) A"
	_cQuery += _cEnter + " WHERE SR8.D_E_L_E_T_ <> '*'"
	_cQuery += _cEnter + " AND R8_FILIAL = '" + SRA->RA_FILIAL  + "'"
	_cQuery += _cEnter + " AND R8_MAT = '" 	  + SRA->RA_MAT 	+ "'"
	_cQuery += _cEnter + " AND R8_DATAINI = DATAINI"	
	MemoWrit("c:\spool\sql\MA_ULTRET.sql", _cQuery)    
	DbUseArea( .T., 'TOPCONN', TcGenQry(,,_cQuery), 'TMP', .f., .t.)
	
	If !eof()

		If empty(TMP->R8_DATAFIM) .or. TMP->R8_DATAFIM > dtos(dDataBase)
			_lRet := .t.
		EndIf
		
	EndIf
	                 
	DbCloseArea()
	RestArea(_aAlias)
	
EndIf

Return(_lRet)