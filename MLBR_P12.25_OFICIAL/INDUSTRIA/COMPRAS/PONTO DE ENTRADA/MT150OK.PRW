#Include 'protheus.ch'
#Include 'rwmake.ch'
                    
///////////////////////////////////////////////////////////////////////////
//Ponto de entrada chamado na atualizacao das cotacoes.
//Obriga ao usuario informar o tipo de frete.
///////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br - 28-11-2011
///////////////////////////////////////////////////////////////////////////

user function MT150OK() 
lOK := .T.    

//Procurando posicao do campo
nPosDesc   :=aScan(aHeader,{|x| AllTrim(x[2])=="C8_X_DESCO"})                                                                                                                                        

if !Substring(c150Frete,1,1) $ 'CFTS'
	Alert('Preencha o tipo de Frete')
	lOK := .F.
endif       

/*
PE para tratar a informacao do campo de Desconto Negociado de acordo com HDI 004542 do setor de compras (Marcio Grizoni)
Desenvolvido por Vinicius S. Schwartz - TI - Midori Atlantica 10/05/2012
*/

//Valida C8_X_DESCO
If Acols[N,nPosDesc] == 0

		If !MsgNoYes ("Desconto negociado não informado. Deseja continuar?")
			lOk := .F. 
		Endif
		
Endif

return lOK 