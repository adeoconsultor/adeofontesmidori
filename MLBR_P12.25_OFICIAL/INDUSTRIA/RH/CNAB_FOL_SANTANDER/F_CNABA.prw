#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*---------------------------------------------------------
Funcao: F_CNABA   
Autor : AOliveira
Descr : era numero sequencial para a linha detalhe "A"
Uso   : CNAB SANTANDER		
---------------------------------------------------------*/
User Function F_CNABA(cNum)

If PCOUNT()==0        
	cNum:=StrZero(nSeq,6)
EndIf

Return Val(cNum) 