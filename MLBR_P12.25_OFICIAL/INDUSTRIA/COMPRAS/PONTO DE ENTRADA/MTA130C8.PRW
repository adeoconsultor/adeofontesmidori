#include "RWMAKE.CH"
#include 'protheus.ch' 

//Ponto de entrada para alinhar a necessidade de entrega com o prazo de entrega de acordo com HDI 004550, onde
//a Marcia Kobayashi (Compras) solicitou que o prazo de entrega seja igual ao prazo de necessidade, porem, respeitando
//o prazo do fornecedor no cadastro do produto (B1_PE)
//Vinicius de Sousa Schwartz - TI - Midori Atlantica em 16/05/2012

User Function MTA130C8()

//Alert ('Prazo Necessidade!!! '+cValToChar(SC8->C8_DATPRF-DDATABASE)+' Prazo Orige!!!! '+cValToChar(SC8->C8_PRAZO))

If SC8->C8_DATPRF <> (SC8->C8_EMISSAO + SC8->C8_PRAZO)
	If (SC8->C8_EMISSAO + SC8->C8_PRAZO) < SC8->C8_DATPRF
		SC8->C8_PRAZO := SC8->C8_DATPRF - SC8->C8_EMISSAO
	Elseif (SC8->C8_EMISSAO + SC8->C8_PRAZO) > SC8->C8_DATPRF
		SC8->C8_DATPRF := SC8->C8_EMISSAO + SC8->C8_PRAZO
	endif
Endif  

///////////////////////////////////////////////////////////////////////////////
//Ponto de entrada para Gravar o TIPO DE FRETE no Arquivo de COTACAO
//Busca o tipo de FRETE no CAMPO AIA_X_TPFR (campo customizado)
//Solicitacao feita via chamado HDi.004394
//Posiciona na primeira tabela de preco que tiver para o fornecedor, pois nesse 
//momento nao existe um codigo de tabela no arquivo SC8
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br -21-02-2012
///////////////////////////////////////////////////////////////////////////////
//user function MTA130C8()
If Substr(SC8->C8_TPFRETE,1,1) == ' '
	reclock('SC8',.F.)
	SC8->C8_TPFRETE:=Posicione('AIA',1,xFilial('AIA')+SC8->(C8_FORNECE+C8_LOJA),"AIA_X_TPFR")
	msunlock('SC8')
EndIf

Return ()

///////////////////////////////////////////////////////////////////////////////
//Ponto de entrada para Gravar o TIPO DE FRETE no Arquivo de COTACAO
//Busca o tipo de FRETE no CAMPO AIA_X_TPFR (campo customizado)
//Solicitacao feita via chamado HDi.004394
//Trabalha em conjunto com o ponto de entrada anterior, porem nesse momento 
//utiliza exatamente a tabela que o usuario selecionou
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br -21-02-2012
///////////////////////////////////////////////////////////////////////////////
user function MT150GRV() 

If Substr(SC8->C8_TPFRETE,1,1) == ' '
	reclock('SC8',.F.)
	SC8->C8_TPFRETE:=Posicione('AIA',1,xFilial('AIA')+SC8->(C8_FORNECE+C8_LOJA+C8_CODTAB),"AIA_X_TPFR")
	msunlock('SC8')                  
EndIf

Return