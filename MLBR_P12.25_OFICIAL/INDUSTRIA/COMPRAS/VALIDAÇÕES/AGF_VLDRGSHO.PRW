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

Local cRestr        := Posicione("SB1",1,xFilial("SB1")+aCols[n][cProduto],"B1_X_RESTR") //Restri��o a compra

local cCodP			:= ""
local cGrupo        := ""

//Alert('Emissao -> ' + dToS(SC1->C1_EMISSAO))



//Bloco implementado para alertar os usu�rios quando for fazer uma SC 
//Caso o produto tenha restri��o cadastrada em B1_X_RESTR 
//B1_X_RESTR == '1' Alerta o usu�rio para analisar o produto antes de solicitar
//B1_X_RESTR == '2' zera _nRet para que o usu�rio n�o fa�a a solicita��o...
//Implementado por Anesio em 08/05/2015 - anesio@outlook.com
if cRestr == '1'
	ApMsgInfo('O produto '+ALLTRIM(Posicione("SB1",1,xFilial("SB1")+aCols[n][cProduto],"B1_DESC"))+CHR(13)+CHR(10)+;
		'est� com restri��o para solicita��o de compras '+CHR(13)+CHR(10)+;
		'Favor verificar ', 'Aten��o', {'Ok'})
elseif cRestr == '2'
	Alert('O produto '+ALLTRIM(Posicione("SB1",1,xFilial("SB1")+aCols[n][cProduto],"B1_DESC"))+CHR(13)+CHR(10)+;
		'est� bloqueado para solicita��o de compras '+CHR(13)+CHR(10)+;
		'Favor verificar ', 'Aten��o')
	lRet := .F.
endif



//Posicionando no produto na SB1
dbSelectArea('SB1')
dbSetOrder(1)
if dbSeek(xFilial('SB1')+aCols[n][cProduto])
	cGrupo := SB1->B1_GRUPO
	cCodP := SB1->B1_COD
endif

//Valida��es de RingSho - Anesio
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
		Alert('Para informar numero de Ringi Sho voc� deve informar que o mesmo existe!!'+chr(13)+'Ringi Sho = "S" ')
		lRet := .F.
		Return lRet
	endif
endif	
//Fim valida��o RingSho

// Valida��o SC para Empilhadeira - Diego
// Solicit. Michelle Rodrigues - Motivo: Controle de gastos com manuten��o/pe�as para empilhadeiras
if aCols[n][nEmpilha]  == "S"
	if aCols[n][nNumEmpilha] == 0
		Alert('SC para Empilhadeira. Obrigatorio informar o numero da Empilhadeira! [Num.Empilha]')
		lRet := .F.
		Return lRet
	Endif
endif	
// Fim valida��o empilhadeira

//Desenvolvida por Vinicius Schwartz/Diego Mafisolli em 02/08/2013
//Valida��o da finalidade da SC no campo C1_X_FINSC, onde ser� verificado a finalidade juntamente com o grupo do produto informado

	If aCols[n][cFinalSC] == "1"
		if cGrupo $ cGrpCons //.And. !AllTrim(aCols[n][cCCusto]) $ cGrpCC02
				lRet := .T.
		else
			Alert('O grupo do produto n�o est� em conformidade. Por favor, ajustar os �tens conforme regra vigente ou entrar em contato com setor Fiscal/Compras!')
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
				Alert('O produto/finalidade/centro de custo n�o est�o em conformidade. Por favor, ajustar os �tens conforme a regra vigente ou entrar em contato com setor Fiscal/Compras!')
				lRet := .F.
				Return lRet
			endif
		Else
			Alert('Favor informar uma Finalidade da solicita��o!')
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
    Alert('Usu�rio possui permiss�o na filial PNP1 apenas para incluir SC de Importa��o')
	lRet := .F.     
	Return lRet
Elseif aCols[n][cImport] == "S" .And. xFilial("SC1") <> '09'
    Alert('Somente � permitido incluir SC de importa��o na filial PNP1. Por favor alterar a filial do sistema.')
	lRet := .F.     
	Return lRet
Else
	lRet := .T.  
Endif
//

if lRet .and. lVldGr90 .and. cGrupo $ '90  ' //Se todos os itens anteriores forem validos, faz a valida��o se o item � do ativo....
	lRet := U_VLDGRP90(cCodP)
	if !lRet 
		Alert('Produto j� utilizado na aquisi��o de ativo, n�o poder� ser utilizado novamente!!!')
	endif
endif
       


return  lRet