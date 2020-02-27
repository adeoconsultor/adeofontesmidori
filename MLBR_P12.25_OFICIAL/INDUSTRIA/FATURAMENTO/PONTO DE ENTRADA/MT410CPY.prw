User Function MT410CPY()
Local aArea := GetArea()
Local lRet := .T.
Local nPosQTDVEN := GDFIELDPOS("C6_QTDVEN")
Local nPosPRCVEN := GDFIELDPOS("C6_PRCVEN")
Local nPosTOTAL := GDFIELDPOS("C6_VALOR")
Local nx := 0

For nx := 1 To Len(aCols)		
	aCols[nx][nPosQTDVEN] = 0		
	aCols[nx][nPosPRCVEN] = 0
	aCols[nx][nPosTOTAL] = 0		
	//aCols[nx][nPosTES] = ' '		
   	//aCols[nx][nPosCF] = ' '		
Next nx

RestArea(aArea)  
	
RETURN lRet