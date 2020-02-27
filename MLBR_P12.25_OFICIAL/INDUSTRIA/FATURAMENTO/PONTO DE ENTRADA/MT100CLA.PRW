#Include 'protheus.ch'
#Include 'rwmake.ch'



user function MT100CLA()
Local cStat := "CLA" //Classificada

dbSelectArea('SD1')
dbSetOrder(1) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
dbSeek(xFilial('SD1')+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
while !SD1->(eof()).and.SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)==SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
	RecLock('SD1',.F.)                                                                                      
	SD1->D1_DTCLASS := Date()
	SD1->D1_HORAENT := Substr(TIME(),1,2)+':'+Substr(TIME(),4,2)   //SF1->F1_HORA
	SD1->D1_HORACLS := Substr(TIME(),1,2)+':'+Substr(TIME(),4,2)
	MsUnLock('SD1')
	
	SD1->(dbSkip())
enddo

//Chama funcao VSS_StatNF para atualizar tabela SZO caso NF seja entrada de couros (grupo 11)
If cFilant == '09'
	U_VSS_StatNF(cStat)
endif

return 