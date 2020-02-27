#include 'protheus.ch'
#include 'rwmake.ch'

user function MA331OK()
local lOk 	:= .T.
local nctlc := 0

//Alert('executando programa')
//Verifica se query já está em memoria e exclui...
if Select('TMPD3') > 0
	dbSelectArea('TMPD3')
	TMPD3->(dbCloseArea())
endif

//Joga a QUERY do SD3 na variavel para executar no banco
cQSD3 := " SELECT D3_NUMSEQ, D3_CC, D3_DOC, D3_COD, D3_LOTECTL from SD3010 "
cQSD3 += " where D_E_L_E_T_ = ' ' and D3_FILIAL ='"+xFilial("SD3")+"' and Substring(D3_EMISSAO,1,6)='"+Substr(dTos(dDatabase),1,6)+"' "
cQSD3 += " and D3_DOC ='INVENT' and D3_CC = '' "

dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQSD3), 'TMPD3', .T., .T.)

//Faz o loop no na query para atualizar o campo D3_CC 
dbSelectArea("TMPD3")
TMPD3->(dbGotop())
while !TMPD3->(eof())
	//Verifica se a query temporária do SB7 já está em memoria e exclui...
	if Select('TMPB7') > 0
		dbSelectArea('TMPB7')
		TMPB7->(dbCloseArea())
	endif
	
	//Joga a QUERY do SB7 na variavel para executar no banco
	cQSB7 := " SELECT B7_CC FROM SB7010 WHERE D_E_L_E_T_ = ' ' AND B7_FILIAL = '"+xFilial("SB7")+"' "
	cQSB7 += " AND B7_COD = '"+TMPD3->D3_COD+"' AND B7_LOTECTL ='"+TMPD3->D3_LOTECTL+"' "
	cQSB7 += " AND Substring(B7_DATA,1,6)='"+Substr(dTos(dDatabase),1,6)+"' "
	
	dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQSB7), 'TMPB7', .T., .T.)
	
	//Bloco para verificar se existe o registro no arquivo SB7
    nCount 	:= 0
    cCC 	:= "" 
  	dbSelectArea('TMPB7')
  	TMPB7->(dbGotop())
  	while !TMPB7->(eof())
  		nCount++
  		cCC := TMPB7->B7_CC
  		TMPB7->(dbSkip())
  	enddo
  	//Caso exista o registro, faz a atualizacao no arquivo SD3
  	//Efetua a busca pelo D3_NUMSEQ
  	if nCount > 0 
		dbSelectArea('SD3')
		dbSetOrder(4) //D3_FILIAL+D3_NUMSEQ+D3_CHAVE+D3_COD 
		if dbSeek(xFilial('SD3')+TMPD3->D3_NUMSEQ)
			RecLock('SD3', .F.)
			SD3->D3_CC := cCC
			MsUnlock('SD3')
		endif
	endif
	TMPD3->(dbSkip())
	nctlc++
enddo
if nctlc > 0 
	Alert('Atualizado '+cValToChar(nctlc)+' itens de Centro de Custos ref.Inventário...')
endif
//alert('encerrado....')
return lOk