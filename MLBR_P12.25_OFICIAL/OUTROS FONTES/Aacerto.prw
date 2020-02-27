#INCLUDE "TOTVS.ch"
/*
*/

User Function Aacerto() 

Local cAlias := "ZZT"
Local cCodEtq    := ""
Local cCodEtqEsp := ""

dbSelectArea(cAlias)
dbSetOrder(1)
dbGoTop()

While !Eof()

	cCodEtq    := ZZT->ZZT_CODETQ
	cCodEtqEsp := SubStr(ZZT->ZZT_CODETQ,7,2)
	
	If SubStr(ZZT->ZZT_CODETQ,7,2) == "  "

		//MsgAlert( STUFF(“Clipper”, 4, 2, “ff”) )     // Resulta “Cliffer”
 
//		cCodEtq:=Stuff(cCodEtq,7,2, " ")  

		cCodEtq1:=SubStr(cCodEtq,1,6)+' '+SubStr(cCodEtq,9,17)  


		Reclock("ZZT",.F.)
		ZZT->ZZT_CODETQ  := cCodEtq1
		MsUnlock()

	EndIf

	dbSkip()
End

Return
