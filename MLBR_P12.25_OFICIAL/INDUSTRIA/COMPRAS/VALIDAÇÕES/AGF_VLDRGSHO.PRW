#include 'protheus.ch'

user function MT110LOK()
local lRet := .T.
Local nRingSho		:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_RINGSHO"})
Local nNumRing		:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_NUMRSHO"})
Local cFinalSC		:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_X_FINSC"})
Local cProduto		:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_PRODUTO"}) 
Local cLocal 		:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_LOCAL"})
Local nEmpilha		:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_EMPILHA"})
Local nNumEmpilha	:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_NEMPILH"})  
Local cCCusto		:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_CC"})
Local cImport		:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_IMPORT"})  
Local cMotivSC		:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_X_MOTIV"})  
Local cGrpCons		:= Getmv( 'MA_GRPSC01' )
Local cGrpProd		:= Getmv( 'MA_GRPSC02' )
Local cGrpCC02		:= Getmv( 'MA_CCSC02'  )
Local cGrpCC02b		:= Getmv( 'MA_CCSC02B' )
local lVldGr90 		:= GetMv( 'MA_VLDGR90' )

Local cRestr        := Posicione("SB1",1,xFilial("SB1")+aCols[n][cProduto],"B1_X_RESTR") //Restrição a compra

local cCodP			:= ""
local cGrupo        := ""

//Alert('Emissao -> ' + dToS(SC1->C1_EMISSAO))



//Bloco implementado para alertar os usuários quando for fazer uma SC 
//Caso o produto tenha restrição cadastrada em B1_X_RESTR 
//B1_X_RESTR == '1' Alerta o usuário para analisar o produto antes de solicitar
//B1_X_RESTR == '2' zera _nRet para que o usuário não faça a solicitação...
//Implementado por Anesio em 08/05/2015 - anesio@outlook.com
if cRestr == '1'
	ApMsgInfo('O produto '+ALLTRIM(Posicione("SB1",1,xFilial("SB1")+aCols[n][cProduto],"B1_DESC"))+CHR(13)+CHR(10)+;
		'está com restrição para solicitação de compras '+CHR(13)+CHR(10)+;
		'Favor verificar ', 'Atenção', {'Ok'})
elseif cRestr == '2'
	Alert('O produto '+ALLTRIM(Posicione("SB1",1,xFilial("SB1")+aCols[n][cProduto],"B1_DESC"))+CHR(13)+CHR(10)+;
		'está bloqueado para solicitação de compras '+CHR(13)+CHR(10)+;
		'Favor verificar ', 'Atenção')
	lRet := .F.
endif



//Posicionando no produto na SB1
dbSelectArea('SB1')
dbSetOrder(1)
if dbSeek(xFilial('SB1')+aCols[n][cProduto])
	cGrupo := SB1->B1_GRUPO
	cCodP := SB1->B1_COD
endif

//Validações de RingSho - Anesio
if aCols[n][nRingSho]  == "S"
	if Substr(aCols[n][nNumRing],1,1) == ' '
		Alert('Obrigatorio informar o numero do Ringi Sho!!')
		lRet := .F.
		Return lRet
	ElseIf Len(Alltrim(aCols[n][nNumRing])) < 8
	    Alert('Ringi-Sho informado invalido. Digite no formato 9999/9999')
		lRet := .F.
		Return lRet
	Endif   	
else
	if Substr(aCols[n][nNumRing],1,1) <> ' '
		Alert('Para informar numero de Ringi Sho você deve informar que o mesmo existe!!'+chr(13)+'Ringi Sho = "S" ')
		lRet := .F.
		Return lRet
	endif
endif	
//Fim validação RingSho

// Validação SC para Empilhadeira - Diego
// Solicit. Michelle Rodrigues - Motivo: Controle de gastos com manutenção/peças para empilhadeiras
if aCols[n][nEmpilha]  == "S"
	if aCols[n][nNumEmpilha] == 0
		Alert('SC para Empilhadeira. Obrigatorio informar o numero da Empilhadeira! [Num.Empilha]')
		lRet := .F.
		Return lRet
	Endif
endif	
// Fim validação empilhadeira

//Desenvolvida por Vinicius Schwartz/Diego Mafisolli em 02/08/2013
//Validação da finalidade da SC no campo C1_X_FINSC, onde será verificado a finalidade juntamente com o grupo do produto informado

	If aCols[n][cFinalSC] == "1"
		if cGrupo $ cGrpCons //.And. !AllTrim(aCols[n][cCCusto]) $ cGrpCC02
				lRet := .T.
		else
			Alert('O grupo do produto não está em conformidade. Por favor, ajustar os ítens conforme regra vigente ou entrar em contato com setor Fiscal/Compras!')
			lRet := .F.
			Return lRet
	
		endif 
	Else
		If aCols[n][cFinalSC] == "2"
			if cGrupo $ cGrpProd .And. AllTrim(aCols[n][cCCusto]) $ cGrpCC02 .Or. AllTrim(aCols[n][cCCusto]) $ cGrpCC02b
					lRet := .T.
			elseif cGrupo $ cGrpProd .And. substr(AllTrim(aCols[n][cCCusto]),1,2) == Substr(cGrpCC02,1,2) //Linha incluida para permitir todos os centros de custos Grp 32
																				  //conforme acertado com Thiago (alterado por Anesio)
				lRet := .T. 
			else
				Alert('O produto/finalidade/centro de custo não estão em conformidade. Por favor, ajustar os ítens conforme a regra vigente ou entrar em contato com setor Fiscal/Compras!')
				lRet := .F.
				Return lRet
			endif
		Else
			Alert('Favor informar uma Finalidade da solicitação!')
			lRet := .F.
			Return lRet
		Endif
	Endif
	
	// Validacao motivo SC x grupos de produto produtivo apenas ESTOQUE
	if cGrupo $ Getmv('MA_GRPR01') .And. !aCols[n][cMotivSC] == "E"
   		Alert('Produtos com finalidade produtiva permitido somente ESTOQUE. Corrigir campo MotivoSC')
		lRet := .F.
		Return lRet	
	Endif   
        

// Validacao SC Importacao para usuarios de outras filiais
// Permitir somente incluir em PNP1 - Diego Mafisolli 22/09/2016                                                                                               
If aCols[n][cImport] == "N" .And. xFilial("SC1") == '09' .And. RetCodUsr() $ GetMV('MA_IMPSCP1')
    Alert('Usuário possui permissão na filial PNP1 apenas para incluir SC de Importação')
	lRet := .F.     
	Return lRet
Elseif aCols[n][cImport] == "S" .And. xFilial("SC1") <> '09'
    Alert('Somente é permitido incluir SC de importação na filial PNP1. Por favor alterar a filial do sistema.')
	lRet := .F.     
	Return lRet
Else
	lRet := .T.  
Endif
//

if lRet .and. lVldGr90 .and. cGrupo $ '90  ' //Se todos os itens anteriores forem validos, faz a validação se o item é do ativo....
	lRet := U_VLDGRP90(cCodP)
	if !lRet 
		Alert('Produto já utilizado na aquisição de ativo, não poderá ser utilizado novamente!!!')
	endif
endif
       


return  lRet