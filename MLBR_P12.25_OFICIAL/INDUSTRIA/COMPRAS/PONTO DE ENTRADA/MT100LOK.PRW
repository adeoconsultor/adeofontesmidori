#include 'rwmake.ch'
#include 'protheus.ch'

//Ponto de entrada para fazer a validação dos produtos digitados diretamente no pedido de compras que nao precisao de solicitação de compras
//Essa rotina vai bloquear que usuarios possam informar outra TES que seja diferente de 408
//Caso o usuario seja do departamento fiscal ou T.I podera informar qualquer TES, caso contrario apenas a 408

//A ativação desse parametro vai depender do parametro MA_TES408, podendo ser ativado ou desativado seu uso, para facilitar a manutenção.
//Desenvolvido por Anesio G.Faria em 22/01/14 anesio@anesio.com.br

user function MT100LOK()
local lRet := .T.
local lValid := GetMv('MA_TES408')
local cUsrT408 := GetMV('MA_USRT408')
local cUsr408A := GetMV('MA_USR408A')
local cTESP    := GetMV('MA_TES408P')

nPosPed   :=aScan(aHeader,{|x| AllTrim(x[2])=="D1_PEDIDO"})
nPosItP   := AScan(aHeader,{|x|AllTrim(x[2])=="D1_ITEMPC"}) //Item do Pedido de compras
nPosTes	  :=aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
nPosPrd   :=aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
nPosDesc  :=aScan(aHeader,{|x| AllTrim(x[2])=="D1_X_DESCR"})
nPosCC	  :=aScan(aHeader,{|x| Alltrim(x[2])=="D1_CC"})
nPosPrj	:= Ascan(aHeader,{|x|Alltrim(x[2]) == "D1_X_CODEV"})


cPed := aCols[n,nPosPed]
//If !FunName() == "GFEA065"
	cTes := aCols[n,nPosTes]  
//Endif
cPrd := aCols[n,nPosPrd]
cCC	 := aCols[n,nPosCC]   

//If !FunName() == "GFEA065"
cPrj := aCols[N][nPosPrj]
//Endif

//If !FunName() == "GFEA065"
aCols[n,nPosDesc] := Posicione('SB1',1,xFilial("SB1")+cPrd,"B1_DESC")
//Endif

//If !FunName() == "GFEA065"
aCols[n,nPosPrj]  := iif(aCols[n,nPosPrj]==space(6), Posicione("SC7",1,xFilial("SC7")+aCols[n,nPosPed]+aCols[n,nPosItP],"C7_X_CODEV"), aCols[n,nPosPrj])
//Endif
//alert('Usuario:'+cUsrT408+'| Usuario retornado:'+Alltrim( RetCodUsr()+'|'))
 
///////////////////////////////////////////////////////////////////////////////////////////////////////
if inclui
	if !u_ag_blqctt(cCC,cPrj,cTes) //Valida o centro de custo para nao utilizar C.Custo diferente do permitido a partir de ABR/2014
		Return .F.
	endif
endif

//////////////////////////////////////////////////////////////////////////////////////////////////////

if lValid .and. inclui     
//	Alert('Incluindo')
//	lRet := Posicione('SB1',1,xFilial('SB1')+SC7->C7_PRODUTO,"B1_X_SEMSC") == 'S'
	lRet1 := Posicione('SC7',1,xFilial("SC7")+cPed,"C7_NUMSC") == space(6)
	if lRet1 
	//	Alert('Pedido sem solicitacao')
		if (Alltrim(RetCodUsr()) $ cUsrT408 .or. Alltrim(RetCodUsr()) $ cUsr408A ) .and. !cTes $ cTESP //cTes <> '408' 
			Alert('Você só tem permissao para utilizar a TES 408 e 156...'+chr(13);
			+'Por favor utilize a TES permitida ou solicite auxilio do dpto Fiscal...'+chr(13);
			+chr(13)+'Bloqueado no parametro MA_TES408')
			Return .F.
		endif
	endif
endif

return lRet

///////////////////////////////////////////////////////////////////////////////////////////////
//Funcao para ser chamado em gatilho no SD1 D1_TES para incluir o código do projeto
//Caso o mesmo esteja cadastrado no pedido de compra....
//Desenvolvido por Anesio G.Faria - (anesio@anesio.com.br) - 29-04-2014	
///////////////////////////////////////////////////////////////////////////////////////////////
user function agPrj(cPed, cItemPc)
local cCodPrj := ""
cCodPrj := Posicione("SC7",1,xFilial("SC7")+cPed+cItemPc,"C7_X_CODEV")
return cCodPrj
