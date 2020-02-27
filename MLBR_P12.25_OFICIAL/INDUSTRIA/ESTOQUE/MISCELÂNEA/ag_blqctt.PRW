#include 'protheus.ch'
#include 'rwmake.ch'

/////////////////////////////////////////////////////////////////////////////////////////////////
//Programa com o objetivo de bloquear os centros de custos padrao antigo de ser utilizado
//a partir do dia 01/04/2014
//Faz parte do projeto de implantação de custos segunda fase
//Desenvolvido por Anesio G.Faria - anesio@anesio.com.br 25/03/2014
/////////////////////////////////////////////////////////////////////////////////////////////////

user function ag_blqctt(cCusto,cPrj,cTes)
local _cCusto := AllTrim(cCusto)
local _cPrj   := cPrj
local _cTes   := cTes
local lRet := .T.
local cUsuarios := GetMv('MA_USRCTT')
local lVld 		:= GetMv('MA_BLQCTT')
//Alert("VALIDANDO C.CUSTO |"+AllTrim(_cCusto)+"|")
//Alert("ATENÇÃO !!!!!"+chr(13)+chr(13)+"SOLICITACOES COM PREVISAO DE ENTREGA POSTERIOR AO DIA 01/04/2014"+chr(13)+"DEVEM SER UTILIZIADOS OS NOVOS CENTROS DE CUSTOS"+chr(13);
//	+chr(13)+"DÚVIDAS ENTRAR EM CONTATO COM CARLOS JULIO (B.FUNDA) OU MARCELO FREITAS (PNP1) ")


if lVld .and. dDatabase > stod('20140331')
	if len(alltrim(_cCusto)) < 6 .and. len(alltrim(_cCusto)) > 0 //Valida a qtde de caracter, todos os c.custos novos possuem 6 caracteres
		lRet := .F.
		Alert('Esse centro de custo '+ALLTRIM(_cCusto)+' está em desuso!!! '+chr(13)+chr(13)+'Por favor consultar o departamento Fiscal/Custos')
	endif
endif

/*if cFilant == '09'
	if _cPrj == space(6).and._cTes <> space(3)
		if Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_DUPLIC") == 'S'
			lRet := .F.
			Alert('Por favor informar um numero de projeto relacionado a este lançamento!!!'+chr(13)+chr(13)+"Campo Even/Projeto")
		endif
	endif
endif
*/

return lRet
