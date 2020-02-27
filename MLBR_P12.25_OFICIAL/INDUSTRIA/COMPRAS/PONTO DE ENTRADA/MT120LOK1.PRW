#include 'rwmake.ch'
#include 'protheus.ch'

//Ponto de entrada para fazer a validação dos produtos digitados diretamente no pedido de compras que nao precisao de solicitação de compras
//Essa rotina vai pegar o código do produto digitado, pesquisar na SB1 e verificar se o campo B1_X_SEMSC está como 'S'
//Caso positivo permite a digitação, caso esteja como N ou em Branco não será permitido a digitação do item diretamente no compras.

//A ativação desse parametro vai depender do parametro MV_SEMSC, podendo ser ativado ou desativado seu uso, para facilitar a manutenção.

user function MT120LOK()
local lRet := .T.
local cNumSc := "" 
local lValid := GetMv('MV_SEMSC')
local lVldGr90 := GetMv('MA_VLDGR90')

nPosCodP   :=aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRODUTO"})
nPosNumSC  :=aScan(aHeader,{|x| AllTrim(x[2])=="C7_NUMSC"})

cCodP := aCols[n,nPosCodP]
cNumSc:= aCols[n,nPosNumSC]



if lValid .and. cNumSc == space(6)
//	lRet := Posicione('SB1',1,xFilial('SB1')+SC7->C7_PRODUTO,"B1_X_SEMSC") == 'S'
	lRet := Posicione('SB1',1,xFilial("SB1")+cCodP,"B1_X_SEMSC") == '1'
	if !lRet
		Alert('O Produto '+chr(13)+cCodP+'-'+ALLTRIM(Posicione('SB1',1,xFilial('SB1')+cCodP,"B1_DESC"))+chr(13)+;
		'Não está habilitado para permitir inclusão sem solicitação de compras'+chr(13)+;
		'Por favor consultar departamento de custos/contábil'+chr(13)+chr(13)+;
		'Parametro MV_SEMSC ativado')
	endif
endif

if lRet .and. lVldGr90 .and. CA120FORN <> '000148' .and. AllTrim(Posicione("SB1",1,xFilial("SB1")+cCodP, "B1_GRUPO")) == '90'
	lRet := U_VLDGRP90(cCodP)
	if !lRet 
		Alert('Produto já utilizado na aquisição de ativo, não poderá ser utilizado novamente!!!')
	endif 
endif

return lRet
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FIM DO PONTO DE ENTRADA
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                  
/*
//Ponto de entrada para fazer a liberaçao automatica dos pedidos que sao inseridos direto no pedido de compras
//Os pedidos que nao possuem solicitacao de compras serao liberados diretamente por essa funcao, sem a necessidade de aprovacao superior.
//Funcao desenvolvida por Anesio G.Faria (anesio@anesio.com.br) em 06/01/2014
user function MT120FIM()
local cQuery := " " 
local cNumPed:= SC7->C7_NUM
local lValid := GetMv('MV_SEMSC')
local lApScAut := GetMv('MA_APSCAUT') //Variável para verificar se aprova automático ou se depende de aprovação do superior.
if SC7->C7_NUMSC == space(6).and.lValid //Apenas pedidos que nao tem solicitacao de compras e se o controle de itens permitidos estiver ativo
	if lApScAut
		dbSelectArea('SC7')
		dbSetOrder(1)
		if dbSeek(xFilial('SC7')+cNumPed)
			while !SC7->(eof()).and.SC7->C7_NUM == cNumPed //Loop para verificar se existe + de 1 item no pedido
			    reclock('SC7',.F.)
				    replace C7_CONAPRO with 'L'
				msunlock('SC7')
			SC7->(dbSkip())
			enddo
			//Query para apagar os registros de liberacao gerado no SCR (para que nao apareca na tela dos aprovadores....
			cQuery := " Update SCR010 set D_E_L_E_T_ = '*'where D_E_L_E_T_ =' ' and CR_FILIAL = '"+xFilial("SC7")+"' and CR_NUM = '"+cNumPed+space(44)+"' " 
			TcSqlExec(cQuery)
		endif
	else
		Alert("Os PEDIDOS sem Solicitações agora também precisam de aprovação!!!"+chr(13)+chr(13)+"Solicite ao seu superior a liberação do mesmo e passe o numero "+cNumPed+chr(13)+chr(13)+"Parametro MA_APSCAUT ativado...")
	endif
endif
return                  
*/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Funcao com o objetivo de bloquear a digitacao de pedidos do grupo 90 
//Esse grupo nao pode ter + do que 1 nota fiscal de entrada pois no ativo sempre deve existir 1 codigo para cada bem
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
user function VLDGRP90(cCodP)
local lRet := .T.                             
local cQuery := ""
local nReg := 0

cQuery := " SELECT Count(*) NREG from SD1010 WHERE D_E_L_E_T_ = ' ' and D1_COD = '"+cCodP+"' " 

if Select("TMPD1") > 0
	dbSelectArea("TMPD1")
	TMPD1->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", tcGenQry( , , cQuery), 'TMPD1', .T., .T. )

dbSelectArea('TMPD1')
TMPD1->(dbGotop())

while !TMPD1->(eof())
	nReg += TMPD1->NREG
	TMPD1->(dbSkip())
enddo

if nReg > 0 
	lRet := .F.
endif

return lRet

