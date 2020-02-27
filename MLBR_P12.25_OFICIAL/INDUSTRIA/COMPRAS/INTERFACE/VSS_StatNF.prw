#Include 'protheus.ch'
#Include 'rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VSS_StatNFºAutor  ³Vinicius Schwartz   º Data ³  29/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Pontos de entrada para tratar a classificacao das notas,	  º±±
±±º          ³exclusão da pre-nota e documento de entrada.				  º±±
±±º          ³Atualiza o status da informacao do campo ZO_STATUS, utili-  º±±
±±º          ³zado para liberar a utilizacao dos pallets incluidos ao dar º±±
±±º          ³entrada em uma pre-nota.									  º±±
±±º          ³Solicitante: Thiago/Fabio - HDI 004883					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COMPRAS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function VSS_StatNF (cStat)
Local cQuery := ""

DbSelectArea('SZO')
DbSetOrder(1)

If cStat == 'CLA'
	If DbSeek (xFilial('SZO')+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
		
		cQuery:= " UPDATE SZO010 "
		cQuery+= " SET ZO_NFCLASS = 'S' "
		cQuery+= " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NFORI = '"+SF1->F1_DOC+"' AND ZO_SERIE = '"+SF1->F1_SERIE+"' AND ZO_CODFOR = '"+SF1->F1_FORNECE+"' AND ZO_LJFOR = '"+SF1->F1_LOJA+"' AND D_E_L_E_T_ <> '*' "
		nret1 := TcSqlExec( cQuery )
		
	Endif
Endif

If cStat == 'EXC'
	If DbSeek (xFilial('SZO')+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
		
		cQuery:= " UPDATE SZO010 "
		cQuery+= " SET ZO_NFCLASS = 'N', ZO_STATUS = 'EXC' "
		cQuery+= " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NFORI = '"+SF1->F1_DOC+"' AND ZO_SERIE = '"+SF1->F1_SERIE+"' AND ZO_CODFOR = '"+SF1->F1_FORNECE+"' AND ZO_LJFOR = '"+SF1->F1_LOJA+"' AND D_E_L_E_T_ <> '*' "
		nret1 := TcSqlExec( cQuery )
		
	Endif
Endif

Return()