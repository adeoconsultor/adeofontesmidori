#include 'protheus.ch'
#include 'rwmake.ch'

///////////////////////////////////////////////////////////////////////////////
//Função para busca do custo medio do produto em SB9 após o fechamento de cada mes
//
//Será chamada via gatilho na digitacao dos pedidos
//O Objetivo é buscar o custo médio dos produtos para ser utilizado nas transferencias
//entre filiais.
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br, angfaria@hotmail.com - 14-02-2012
///////////////////////////////////////////////////////////////////////////////
User function AGF_SHCUS(cProd, cArmz, cTes)
local _cProd := cProd
local _cArmz := cArmz
local lCouro := .F.
local cDesc := Posicione('SB1',1,xFilial('SB1')+_cProd,'B1_DESC')
local dUlMes := Getmv ( 'MV_ULMES' ) 
local cCpBusca := Getmv( 'MA_VLRTRAN' ) 
local nRet,i := 0
                
cCpBusca := Substr(cCpBusca,1,6)

dbSelectArea("SB9") 
dbSetOrder(1)

if cCpBusca == 'B9_CM1'
	nRet := Posicione('SB9',1,xFilial('SB9')+_cProd+_cArmz+dTos(dUlMes),'B9_CM1')
Elseif cCpBusca == 'B2_CM1' 
	nRet := Posicione('SB2',1,xFilial('SB2')+_cProd+_cArmz,'B2_CM1')
else
	nRet := Posicione('SB9',1,xFilial('SB9')+_cProd+_cArmz+dTos(dUlMes),'B9_X_CMTRF')
endif              

nRetOld := nRet //Variavel utilizada para retornar ao valor original quando o produto pertencer a um dos seguintes grupos:
				// 60, 71, 72, 75, 89 e 99 e a TES for 606
if nRet == 0 
	nRet := Posicione('SB9',1,xFilial('SB9')+_cProd+_cArmz+dTos(dUlMes),'B9_CM1')
endif

//Caso nao foi encontrado custo no ultimo fechamento para os parametros acima, o sistema busca no SB2
if nRet == 0
	nRet := Posicione('SB2',1,xFilial('SB2')+_cProd+_cArmz,'B2_CM1')
endif 

for i:= 1 to len(cDesc)
	if Substr(cDesc,i,5) == 'COURO' 
		lCouro := .T.
	endif
next i	



if Posicione('SB1',1,xFilial('SB1')+_cProd,'B1_GRUPO') =='40  ' 
	nRet := nRet / 0.93
//elseif lCouro 
//	nRet := nRet / 0.93
elseif  cTes == '602' .or. cTes == '604' .or. cTes == '643' 
	nRet := nRet / 0.82
elseif cTes == '564' .or. cTes == '567' .or. cTes == '565' .or. cTes =='570' 
	nRet := nRet / 0.93 
else
	dbSelectArea('SF4')
	dbSetOrder(1)
	dbSeek(xFilial('SF4')+cTes)
	if SF4->F4_BASEICM > 0
		nRet := nRet / (1 -(18 *  (SF4->F4_BASEICM / 100))/100) 
	else
		nRet := nRet / 0.82
	endif
endif

//Conforme e-mail enviado por Viviane, não deverá considerar 
//imposto para os grupos 60, 71, 72, 75, 89 e 99 quando a TES for 606
if cTes == '606'
	if Posicione('SB1',1,xFilial('SB1')+_cProd,'B1_GRUPO') $'60  |71  |72  |75  |89  |99  ' 
		nRet := nRetOld 
	endif
endif 

If cTes == '621'
	nRet := nRetOld
Endif

nRet := round(nRet,4)

return nRet
