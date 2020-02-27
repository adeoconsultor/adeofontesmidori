#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*---------------------------------------------------------
Funcao: REMSANFL   
Autor : AOliveira
Descr : rotina tem como objetivo retornar a sequencia de 
        remessa do CNAB 
Uso   : CNAB SANTANDER		
---------------------------------------------------------*/
User Function REMSANFL()
Local _NumArqu := Subs(GetMv("TV_SEQSANT"),1,6)
Local _Proximo := STRZERO(VAL(_NumArqu)+1,6)

dbSelectArea("SX6")
RecLock("SX6",.F.)
Replace X6_CONTEUD With _Proximo
MsUnlock()

Return(_NumArqu)