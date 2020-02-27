#include 'RWMAKE.CH'

///////////////////////////////////////////////////////////////////////
//Função com o objetivo de buscar o nome do CLIENTE e/ou FORNECEDOR
//na nota fiscal de entrada...
//Trata o tipo de nota fiscal 
//	quando for D ou B busca o nome no cadastro de cliente
//	quando for os demais busca o nome no cadastro de fornecedores
///////////////////////////////////////////////////////////////////////
user function ATUNR()
if apmsgYesNo("Deseja Atualizar o nome de todos os fornecedores ? ", "Atencao para atualizacao!!!")
	Processa({|| AG_ATUNREDUZ()}, "Processando notas fiscais...")
endif
return      


static function AG_ATUNREDUZ()
	dbSelectArea("SF1")
	dbSetOrder(1)
	SF1->(dbGotop())
	while !SF1->(eof())
		RecLock("SF1",.F.)
			SF1->F1_NREDUZ := U_AGF_SHNREDUZ(F1_FORNECE, F1_LOJA, F1_TIPO)
			IncProc("Processando Filial+Nota+Serie-> "+SF1->F1_FILIAL+'-'+SF1->F1_DOC+'/'+SF1->F1_SERIE)
		msUnLock('SF1')
		SF1->(dbSkip())
	enddo
	Alert('Encerrado com sucesso....')
return


user function AGF_SHNREDUZ(cCod, cLoja, cTipo)
local cRetNome := "" 
//	Alert('TIPO-> '+cTipo)
	IF cTipo $ 'DB'
		cRetNome := Posicione("SA1",1,xFilial("SA1")+cCod+cLoja,"A1_NREDUZ")	
	else
		cRetNome := POSICIONE("SA2",1,XFILIAL("SA2")+cCod+cLoja,"A2_NREDUZ")
	endif	
return cRetNome