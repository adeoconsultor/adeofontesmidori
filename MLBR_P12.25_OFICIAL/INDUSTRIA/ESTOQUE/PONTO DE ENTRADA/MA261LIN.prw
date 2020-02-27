User Function MA261LIN( )
Local lRet := .T.
Local lTrans := GETMV ('MA_TRFCOD')
Local cGrup  := GETMV ('MA_TRFGRP')
Local cGrpOrig := ""
Local cGrpDest := ""
Local nLinha := PARAMIXB[1]  // numero da linha do aCols
//Local dValidDest := aCols[nlinha,21]
//Local dValidOri  := aCols[nlinha,14]                                                  
//Local cLoteOri   := aCols[nlinha,12]                                                 
//Local cLoteDest  := aCols[nlinha,20]                                                  
Local cProdOri   := aCols[nlinha,01]
Local cProdDest  := aCols[nlinha,06]


if !lTrans 
	/* IF cLoteOri <>  cLoteDest
	   lRet:= .F.
	   MsgAlert("Lote destino difere do lote origem. Verifique...")
	 ENDIF
	
	 IF dValidOri <>  dValidDest
	   lRet:= .F.
	   MsgAlert("Data de validade destino difere da data de validade origem. Verifique...")
	 ENDIF        
	 */
//Permite transferencia apenas dentro do mesmo grupo
cGrpOrig := Posicione("SB1",1, xFilial("SB1")+cProdOri, "B1_POSIPI")
cGrpDest := Posicione("SB1",1, xFilial("SB1")+cProdDest, "B1_POSIPI")

	if cGrpOrig <> cGrpDest 
	   lRet:= .F.
	   MsgAlert("Produto destino difere do produto origem. Verifique..."+chr(13)+chr(13)+"Esse tipo de movimentaçao impacta nos Estoques/Custos"+chr(13)+"CONVERSE COM SEU SUPERIOR!!!"+chr(13)+"Parametro MA_TRFCOD ativado")
	   return lRet
	endif
	
	if !cGrpOrig $ cGrup
		 IF cProdOri <>  cProdDest
		   lRet:= .F.
		   MsgAlert("Produto destino difere do produto origem. Verifique..."+chr(13)+chr(13)+"Esse tipo de movimentaçao impacta nos Estoques/Custos"+chr(13)+"CONVERSE COM SEU SUPERIOR!!!"+chr(13)+"Parametro MA_TRFCOD ativado")
		 ENDIF
	endif
endif

Return lRet

//Ponto de entrada para validar o codigo de transf. origem x destino
user function MT260TOK()
Local lRet := .T.
Local lTrans := GETMV ('MA_TRFCOD')
Local cGrup  := GETMV ('MA_TRFGRP')
Local cGrpOrig := ""
Local cGrpDest := ""

if !lTrans 
//Permite transferencia apenas dentro do mesmo grupo
cGrpOrig := Posicione("SB1",1, xFilial("SB1")+cCodOrig, "B1_POSIPI")
cGrpDest := Posicione("SB1",1, xFilial("SB1")+cCodDest, "B1_POSIPI")

	if cGrpOrig <> cGrpDest 
	   lRet:= .F.
	   MsgAlert("Produto destino difere do produto origem. Verifique..."+chr(13)+chr(13)+"Esse tipo de movimentaçao impacta nos Estoques/Custos"+chr(13)+"CONVERSE COM SEU SUPERIOR!!!"+chr(13)+"Parametro MA_TRFCOD ativado")
	   return lRet
	endif
	
	if !cGrpOrig $ cGrup

		 IF cCodOrig <>  cCodDest
		   lRet:= .F.
		   MsgAlert("Produto destino difere do produto origem. Verifique..."+chr(13)+chr(13)+"Esse tipo de movimentaçao impacta nos Estoques/Custos"+chr(13)+"CONVERSE COM SEU SUPERIOR!!!"+chr(13)+"Parametro MA_TRFCOD ativado")
		 ENDIF
		 
	endif
endif

return lRet


