#INCLUDE "MATA106.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"
#INCLUDE "TOPCONN.CH"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	MT107GRV
// Autor 		Alexandre Dalpiaz
// Data 		29/05/10
// Descricao  	Gera pré-requisição na liberação da solicitação ao armazém.
// Uso         	Midori Atlantica
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MT107GRV()
////////////////////////

cAlias := 'SCP'
cMarca := GetMark()
cFiltraSCP := ""

Pergunte('MTA106',.f.)
If FunName() == "MATA107"
	
   	Processa({|lEnd| MaSaPreReq(.f.,MV_PAR01==1, {|| .T.},MV_PAR02==1,MV_PAR03==1,MV_PAR04==1,MV_PAR05,MV_PAR06,MV_PAR07==1,MV_PAR08==1,MV_PAR09,.T.)})
	
Else
              
	_cChave := SCP->CP_FILIAL + SCP->CP_NUM
    DbSeek(_cChave,.F.)
    Do While !eof() .and. _cChave == SCP->CP_FILIAL + SCP->CP_NUM
    	Processa({|lEnd| MaSaPreReq(.T.,MV_PAR01==1, {|| .T.},MV_PAR02==1,MV_PAR03==1,MV_PAR04==1,MV_PAR05,MV_PAR06,MV_PAR07==1,MV_PAR08==1,MV_PAR09)})
		DbSkip()
	EndDo
	
EndIf	
	
Pergunte('MTA107',.f.)

Return()