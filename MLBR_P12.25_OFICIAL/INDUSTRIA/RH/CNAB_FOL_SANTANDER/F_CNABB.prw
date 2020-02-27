#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*---------------------------------------------------------
Funcao: F_CNABA   
Autor : AOliveira
Descr : era numero sequencial para a linha detalhe "B"
Uso   : CNAB SANTANDER		
---------------------------------------------------------*/
User Function F_CNABB(cNum)

If PCOUNT()==0  
	nSeq:=nSeq+1
	cNum:=StrZero(nSeq,6)
EndIf           

Return Val(cNum)