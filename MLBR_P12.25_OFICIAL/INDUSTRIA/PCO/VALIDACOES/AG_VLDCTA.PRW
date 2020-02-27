#Include 'rwmake.ch'
#include 'protheus.ch'

user function ag_vldcta()
local cMsg := ''
local _cRet := '3110106'

if !ALTERA //Verificar se o usuario estiver fazendo alteracao nao chamar a função

	if FunName() $ "MATA121"
		nPosCodP	:=aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRODUTO"})
		nPosCC		:=aScan(aHeader,{|x| Alltrim(x[2])=="C7_CC"})
		nPosSC		:=aScan(aHeader,{|x| Alltrim(x[2])=="C7_NUMSC"})
		nPosItSC	:=aScan(aHeader,{|x| Alltrim(x[2])=="C7_ITEMSC"})
	
	
		cCodP		:= aCols[n,nPosCodP]
		_cCC		:= aCols[n,nPosCC]
		_cGrupo		:= Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_GRUPO")
		_cNumSC		:= aCols[n,nPosSC]
		_cItemSC	:= aCols[n,nPosItSC]
	else
		cCodP := SC7->C7_PRODUTO
		_cCC  := SC7->C7_CC
		_cGrupo		:= Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_GRUPO")
		_cNumSC		:= SC7->C7_NUMSC
		_cItemSC	:= SC7->C7_ITEMSC
	endif
	
	_cPRDFrete  := GETMV("MV_X_FTPRO")
	
	if _cNumSC == space(6)
		_cEstoque := "N"
	else
		if Posicione("SC1",1,xFilial("SC1")+_cNumSC+_cItemSC,"C1_X_MOTIV") == "C"
			_cEstoque := "N"
		elseIF Posicione("SC1",1,xFilial("SC1")+_cNumSC+_cItemSC,"C1_X_MOTIV") == "E"
			_cEstoque := "S"
		else
			_cEstoque := "N" 
		endif
	endif
	
	//Alert("PEDIDO "+CA120NUM)
	//cMsg := 'Chamou rotina de preenchimento de conta '
	
	//Alert('Pedido '+SC7->C7_NUM+' Produto '+cCodP)
	
	//A -  (quando o grupo = 93 e centro de custo = 301 a 399 = B1_X_INDIR) - CHAMADO 001229
	IF Alltrim(_cGrupo) $ "93" .And. Alltrim(_cCc) >= "301" .And. Alltrim(_cCc) <= "399"
		If _cEstoque == "N"
			_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_INDIR")
		endif
	Endif
	
	//C - (quando grupo = 93 e produto (Frete) = 018777|018778 = B1_X_DIRET)- Conforme parametro MV_X_FTPRO - CHAMADO 001229
	IF Alltrim(_cGrupo) $ "93" .And. Alltrim(SD1->D1_COD) $ Alltrim(_cPRDFrete) // Produto Frete
		If _cEstoque == "N"
			_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_DIRET")
		endif
	Endif
	
	//C - Caso a filial seja 01-Guarulhos ou 18-São Paulo
	IF Alltrim(_cGrupo) $ "93" .And. Alltrim(_cCc) >="400" //.And. cFilAnt $ "01|18" // Produto Frete
		If _cEstoque == "N"
			_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_GERAI")
		endif
	Else
		Do Case
			//Chamado 03818 - (quando grupo = 95/96/97) - Solicitante Mauri
			Case Alltrim(_cGrupo) $ "96"
				IF Alltrim(_cCc) >= "321" .AND. Alltrim(_cCc) <= "327" .or. Alltrim(_cCc) >= "329" .AND. Alltrim(_cCc) <= "349"
					_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_DIRET")
				ElseIF Alltrim(_cCc) $ "301|311|312|328" .or. Alltrim(_cCc) >= "351" .AND. Alltrim(_cCc) <= "399"
					_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_INDIR")
				ElseIF Alltrim(_cCc) $ "101|111|121|131|141" .or. Alltrim(_cCc) >= "401" .AND. Alltrim(_cCc) <= "599"
					_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_GERAI")
				Endif
				
			Case Alltrim(_cGrupo) $ "95|97"     // Até Chamado 03818 - Até aqui.
				_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_GERAI")
			Case Alltrim(_cGrupo) $ "71|72" .And. Alltrim(_cCc) >= "321" .AND. Alltrim(_cCc) <= "327"
				If _cEstoque == "N"
					_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_DIRET")
				Endif
				
				
				//A -  (Quando o centro de custo = 301 a 399 = B1_X_INDIR) - CHAMADO 001229
			Case Alltrim(_cGrupo) $ "75/91/99" .And. Alltrim(_cCc) >= "301" .And. Alltrim(_cCc) <= "399"
				If _cEstoque == "N"
					_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_INDIR")
				Endif
				
				//B - (quando grupo = 93 e centro de custo # 301 a 399 = B1_X_GERAI) - CHAMADO 001229
			Case Alltrim(_cGrupo) $ "75/91/99" .And. !(Alltrim(_cCc) >= "301" .AND. Alltrim(_cCc) <= "399")// Se for diferente.
				If _cEstoque == "N"
					_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_GERAI")
				Endif
				
				//D - (quando grupo = 94 = B1_TRANS) - CHAMADO 001229
			Case Alltrim(_cGrupo) $ "94"
				If _cEstoque == "N"
					_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_TRANS")
				Endif
				
		EndCase
	Endif
	
	//alert(cMsg+ ' '+_cRet)
endif //Fim do TESTE se Altera
	
return _cRet
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Fim da funcao
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Funcao para recuperar a conta no reprocessamento do PCO
//Desenvolvido por Anesio G.Faria - Em 09-01-2014 
//Funcao chamada no parametro 000055 do PCO
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
user function AG_VLDAPR()
local cMsg := ''
local _cRet := '3110106'


cCodP		:= SC7->C7_PRODUTO
_cCC		:= SC7->C7_CC
_cGrupo		:= Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_GRUPO")
_cPRDFrete  := GETMV("MV_X_FTPRO")
_cNumSC		:= SC7->C7_NUMSC
_cItemSC	:= SC7->C7_ITEMSC
if _cNumSC == space(6)
	_cEstoque := "N"
else
	if Posicione("SC1",1,xFilial("SC1")+_cNumSC+_cItemSC,"C1_X_MOTIV") == "C"
		_cEstoque := "N"
	elseIF Posicione("SC1",1,xFilial("SC1")+_cNumSC+_cItemSC,"C1_X_MOTIV") == "E"
		_cEstoque := "S"
	else
		_cEstoque := "N" 
	endif
endif

//A -  (quando o grupo = 93 e centro de custo = 301 a 399 = B1_X_INDIR) - CHAMADO 001229
IF Alltrim(_cGrupo) $ "93" .And. Alltrim(_cCc) >= "301" .And. Alltrim(_cCc) <= "399"
	If _cEstoque == "N"
		_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_INDIR")
	endif
Endif

//C - (quando grupo = 93 e produto (Frete) = 018777|018778 = B1_X_DIRET)- Conforme parametro MV_X_FTPRO - CHAMADO 001229
IF Alltrim(_cGrupo) $ "93" .And. Alltrim(SD1->D1_COD) $ Alltrim(_cPRDFrete) // Produto Frete
	If _cEstoque == "N"
		_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_DIRET")
	endif
Endif

//C - Caso a filial seja 01-Guarulhos ou 18-São Paulo
IF Alltrim(_cGrupo) $ "93" .And. Alltrim(_cCc) >="400" //.And. cFilAnt $ "01|18" // Produto Frete
	If _cEstoque == "N"
		_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_GERAI")
	endif
Else
	Do Case
		//Chamado 03818 - (quando grupo = 95/96/97) - Solicitante Mauri
		Case Alltrim(_cGrupo) $ "96"
			IF Alltrim(_cCc) >= "321" .AND. Alltrim(_cCc) <= "327" .or. Alltrim(_cCc) >= "329" .AND. Alltrim(_cCc) <= "349"
				_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_DIRET")
			ElseIF Alltrim(_cCc) $ "301|311|312|328" .or. Alltrim(_cCc) >= "351" .AND. Alltrim(_cCc) <= "399"
				_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_INDIR")
			ElseIF Alltrim(_cCc) $ "101|111|121|131|141" .or. Alltrim(_cCc) >= "401" .AND. Alltrim(_cCc) <= "599"
				_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_GERAI")
			Endif
			
		Case Alltrim(_cGrupo) $ "95|97"     // Até Chamado 03818 - Até aqui.
			_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_GERAI")
		Case Alltrim(_cGrupo) $ "71|72" .And. Alltrim(_cCc) >= "321" .AND. Alltrim(_cCc) <= "327"
			If _cEstoque == "N"
				_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_DIRET")
			Endif
			
			
			//A -  (Quando o centro de custo = 301 a 399 = B1_X_INDIR) - CHAMADO 001229
		Case Alltrim(_cGrupo) $ "75/91/99" .And. Alltrim(_cCc) >= "301" .And. Alltrim(_cCc) <= "399"
			If _cEstoque == "N"
				_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_INDIR")
			Endif
			
			//B - (quando grupo = 93 e centro de custo # 301 a 399 = B1_X_GERAI) - CHAMADO 001229
		Case Alltrim(_cGrupo) $ "75/91/99" .And. !(Alltrim(_cCc) >= "301" .AND. Alltrim(_cCc) <= "399")// Se for diferente.
			If _cEstoque == "N"
				_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_X_GERAI")
			Endif
			
			//D - (quando grupo = 94 = B1_TRANS) - CHAMADO 001229
		Case Alltrim(_cGrupo) $ "94"
			If _cEstoque == "N"
				_cRet := Posicione("SB1",1,xFilial("SB1")+cCodP,"B1_TRANS")
			Endif
			
	EndCase
Endif
return _cRet