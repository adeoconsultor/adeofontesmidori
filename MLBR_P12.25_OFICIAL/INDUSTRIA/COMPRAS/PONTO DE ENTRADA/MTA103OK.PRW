#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
Ponto de Entrada para validar TES x Motivo SC
antes confirmar classificação da NF.
Solicitante: Viviane Berdusco
Diego Mafisolli - 27/05/2019
*/
user function MTA103OK()
                              
Local cEstCon          
Local cTipoTes
Local lRet := .T.
                                                 
dbSelectArea('SD1')
dbSetOrder(1) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM  

// Valida TES somente se existe registro de pre nota na SD1
// Para documentos incluídos diretamente na rotina MATA103 nao é necessário validar, porque não existe SC
If dbSeek(xFilial('SD1')+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
	while !SD1->(eof()).and.SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)==SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
	   
		cEstCon := Posicione("SC1", 1, SC7->C7_FILIAL+SC7->C7_NUMSC+SC7->C7_ITEMSC,"C1_X_MOTIV")              
		cTipoTes := Posicione("SF4", 1, xFilial("SF4")+aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})],"F4_ESTOQUE")
		                                                                        
		If (cEstCon $ 'E' .And. cTipoTes = 'N') .Or.(cEstCon $ 'C' .And. cTipoTes = 'S')
			MsgInfo("Problema TES escolhida item "+aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEM"})]+". Selecione TES correspondente ao Ped.Compra")
			lRet := .F.
		Else
			lRet := .T.
		Endif
		
		SD1->(dbSkip())
	enddo
Endif
Return(lRet) 