#Include 'protheus.ch'
#include 'rwmake.ch'

///////////////////////////////////////////////////////////////////////////////////////////////////////////
//Função com o objetivo de validar o valor de transferencia calculado pelo sistema com o valor informado
//pelo usuário.
//Para os pedidos de transferencia entre filiais onde o produto tenha custo calculado no ultimo fechamento,
//O sistema não estará permitindo informar valor diferente do valor que foi calculado
//Desenvolvido por Anesio G.Faria - anesio@outlook.com
//Solicitacao feita pelo Sr.Carlos (Contabilidade) em 22/05/2013 por e-mail.
///////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina de analise item a item
///////////////////////////////////////////////////////////////////////////////////////////////////////////
user function M410LIOK()
Local nPosPrc 	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_PRCVEN"})
Local nPosIt   	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_ITEM"})
Local nPosLoc	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_LOCAL"})
Local nPosPrd	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_PRODUTO"})
Local nPosTes	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_TES"})
Local nPosQtd	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_QTDVEN"})
Local nPosVlr	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_VALOR"})
Local nPosCC	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_CCUSTO"})

Local nPosItB	:= aScan(aHeader,{|x|AllTrim(x[2]) == "C6_ITEMPC"})
Local nPosPoB 	:= aScan(aHeader,{|x|AllTrim(x[2]) == "C6_NUMPCOM"})
Local nPosCfo 	:= aScan(aHeader,{|x|AllTrim(x[2]) == "C6_CF"})    

Local nPosQtdVQ	:= aScan(aHeader,{|x|AllTrim(x[2]) == "C6_QTDVQ"})    

Local cItem 	:= ""
Local nVlrPrc  	:= 0
Local nVlrSug	:= 0
Local nQtdVen	:= 0
Local cLocal 	:= ""
Local cProd		:= ""
Local cTes		:= ""
Local cCC		:= ""
Local lRet 		:= .T.
Local lCount	:= .F.
Local nX        := 0
Local aArea := GetArea()


If Funname() == "MATA410" /// Para nao contemplar o modulo de Exportacao - Willer
	
	If  IsInCallStack( "A410Deleta" ) .OR. IsInCallStack( "A410ProcDv" ) .OR. IsInCallStack( "A410Devol" )
		Return (lRet)
	EndIf

	If M->C5_TIPO $ 'N'
		IF !IsInCallStack( "{|| SELF:DELOK()}")
						
			nPos:= Ascan( aHeader, {|x| AllTrim(x[2]) == "C6_PRUNIT" })
			nPos1:= Ascan( aHeader, {|x| AllTrim(x[2]) == "C6_PRCVEN" })
			
			If !Empty(M->C5_TABELA) .And. aCols[n,nPos] <> 0
				If aCols[n,nPos1] <> aCols[n,nPos]
					MsgAlert("O preço informado é diferente do preço cadastrado na tabela.")
					lRet := .F.
				EndIf
			EndIf
		EndIf
	EndIf    
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Rotina para validar se usuario digitou Qtde VQ [C6_QTDVQ]
	// Solicitante: Jairson Ramalho	- Diego Mafisolli 10/04/2017
	//////////////////////////////////////////////////////////////////////////////////////////////////////////   
	If Rtrim(aCols[n,nPosPrd]) $ GetMv('MA_QTDVQPV') .And. aCols[n,nPosQtdVQ] == 0
		ApMsgInfo('Para o produto '+Rtrim(aCols[n,nPosPrd])+' é necessário informar a Qtde de Vaquetas.')
		lRet := .F.	     	
	Endif
	//


	//validação para checar se no cadastro do complemento do produto o cliente possui PPAP(BZ_X_PPAP='1' (Sim)) para as filiais 08 E 19
	//ANTONIO - 30/01/18
	If AllTrim(xFilial("SC6")) == "08" .Or. AllTrim(xFilial("SC6")) == "19"

		If Posicione("SB1",1,xFilial("SB1")+Rtrim(aCols[n,nPosPrd]),"B1_GRUPO") $ '51OM|51AF'		
			SBZ->(dbSetOrder(1))  
			If SBZ->( !dbSeek(xFilial("SC2") + Rtrim(aCols[n,nPosPrd]) ) )
				HS_MSGINF("Produto não possui PPAP, favor entrar em contato com o Depto de Qualidade/PNP2!!!","Atenção","Inclusão do Pedido de Vendas")
				lRet := .F.
				Return(lRet)
			Else
				If SBZ->BZ_X_PPAP == '2'
					HS_MSGINF('Produto '+Rtrim(aCols[n,nPosPrd])+' não possui PPAP, favor entrar em contato com o Depto de Qualidade/PNP2!!!',"Atenção","Inclusão do Pedido de Vendas")
					lRet := .F.
					Return(lRet)
				EndIf
			EndIf
	    Endif
	EndIf
	
//	Return(lRet)           ///comentado por Antonio em conversa com Diego para ver se estava correto ou não, caso de algum problema verificar 30/01/18
	
	If M->C5_CLIENTE $ '000001'
		For nx := 1 to len(aCols)
			nVlrPrc := aCols[nx][nPosPrc]
			cItem 	:= aCols[nx][nPosIt]
			cLocal	:= aCols[nx][nPosLoc]
			cProd	:= aCols[nx][nPosPrd]
			cTes	:= aCols[nx][nPosTes]
			nQtdVen := aCols[nx][nPosQtd]
			cCC		:= aCols[nx][nPosCC]
			
			
			If !Posicione('SB1',1,xFilial('SB1')+aCols[nx][nPosPrd], "B1_GRUPO") $ '60  |71  |72  |75  |90  |89  |99  '
				vldPrcTrf(nVlrPrc, cItem, cLocal, cProd, cTes, nQtdVen,nx, nPosPrc, nPosVlr)
			elseif Posicione('SB1',1,xFilial('SB1')+aCols[nx][nPosPrd], "B1_GRUPO") $ '71  |72  |75  ' .and. aCols[nx][nPosTes] $ '606'
				vldPrcTrf(nVlrPrc, cItem, cLocal, cProd, cTes, nQtdVen,nx, nPosPrc, nPosVlr)
			endif
		Next nx
	endif
	
	If M->C5_CLIENTE $ '000003' .And. M->C5_TIPO $ 'N'
		
		For nx := 1 to len(aCols)
			
			cItB2B	:= aCols[nx][nPosItB]
			cPoB2B	:= aCols[nx][nPosPoB]
			cItem 	:= aCols[nx][nPosIt]
			cPosCFO	:= aCols[nx][nPosCfo]
			
			If ! Alltrim(cPosCFO) $ ("5920-5921-6920-6921")
				
				If lCount == .F.
					
					If IsInCallStack( " A410Copia " )
						ApMsgInfo( " Ao efetuar a copia do pedido lembre-se de alterar" +chr(13)+;
						'as informações de Item do Cliente e PO Cliente'+chr(13)+;
						'nos respectivos campos'+chr(13)+;
						'"Item Ped.Com." e "Num.Ped.Comp"')
						lCount := .T.
					EndIf
				EndIf
				If Empty(cItB2B) .Or. Empty(cPoB2B)
					ApMsgInfo('Para o cliente Faurecia, favor verificar digitação' +chr(13)+;
					'das informações de Item do Cliente e PO Cliente'+chr(13)+;
					'nos respectivos campos'+chr(13)+;
					'"Item Ped.Com." e "Num.Ped.Comp"'+chr(13)+;
					'no item '+cItem+' do pedido de venda.')
					nx := len(aCols)
					Return .F.
				EndIf
			EndIf
		Next nx
	EndIf


EndIf
//U_ag_blqctt(cCC)

//Return(.T.)    ///comentado por Antonio em conversa com Diego para ver se estava correto ou não, caso de algum problema verificar 30/01/18                               
Return(lRet)     ///Return da linha 97 que foi movido pra cá.


///////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina de validação no momento de confirmacao do pedido
///////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function M410TOK()
Local cItem 	:= ""
Local nVlrPrc,nx,nXX  	:= 0
Local nVlrSug	:= 0
Local cLocal 	:= ""
Local cProd		:= ""
Local cTes		:= ""
Local lRet		:= .T.
Local nPosPrc	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_PRCVEN"})
Local nPosIt 	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_ITEM"})
Local nPosLoc	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_LOCAL"})
Local nPosPrd	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_PRODUTO"})
Local nPosTes	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_TES"}) 
Local nPosQtdVQ	:= aScan(aHeader,{|x|AllTrim(x[2]) == "C6_QTDVQ"}) 



If M->C5_CLIENTE $ '000001'
	For nx := 1 to len(aCols)
		nVlrPrc := aCols[nx][nPosPrc]
		cItem 	:= aCols[nx][nPosIt]
		cLocal	:= aCols[nx][nPosLoc]
		cProd	:= aCols[nx][nPosPrd]
		cTes	:= aCols[nx][nPosTes]
		nVlrSug := U_AGF_SHCUS(cProd, cLocal,cTes)
		//		Alert('VLD ugerido-> '+cValToChar(round(nVlrSug,6))+' Valor informado-> '+cValToChar(nVlrPrc)+' Tam-> '+cValToChar(nx)+'/'+cValToChar(len(aCols)))
			If nVlrSug > 0 .and. Round(nVlrSug,6) <> Round(nVlrPrc,6) .And. cTes <> '621'
				ApMsgInfo('O Item '+cItem+ ' Produto '+cProd+chr(13)+'Está com valor de '+cValToChar(nVlrPrc)+chr(13)+;
				'Sendo que o valor calculado pelo ultimo fechamento é de '+cValToChar(nVlrSug)+chr(13)+chr(13)+;
				'O Pedido não poderá ser confirmado')
				nx := len(aCols)
				Return .F.
			EndIf
	Next nx
EndIf          
   
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Rotina para validar se usuario digitou Qtde VQ [C6_QTDVQ]
// Solicitante: Jairson Ramalho	- Diego Mafisolli 10/04/2017
//////////////////////////////////////////////////////////////////////////////////////////////////////////  
If Funname() == "MATA410"
	For nx := 1 to len(aCols) 
		If Rtrim(aCols[nx,nPosPrd]) $ GetMv('MA_QTDVQPV') .And. aCols[nx,nPosQtdVQ] == 0
			ApMsgInfo('Para o produto '+Rtrim(aCols[nx,nPosPrd])+' é necessário informar a Qtde de Vaquetas.')
			lRet := .F.	     	
		Endif
	Next nx

	//validação para checar se no cadastro do complemento do produto o cliente possui PPAP(BZ_X_PPAP='1' (Sim)) para as filiais 08 E 19
	//ANTONIO - 30/01/18
	If lRet 

		If AllTrim(xFilial("SC6")) == "08" .Or. AllTrim(xFilial("SC6")) == "19"

			For nXX := 1 to Len(aCols) 
				
				SBZ->(dbSetOrder(1))  
				If SBZ->( !dbSeek(xFilial("SC2") + Rtrim(aCols[nXX,nPosPrd]) ) )
					HS_MSGINF("Produto não possui PPAP, favor entrar em contato com o Depto de Qualidade/PNP2!!!","Atenção","Inclusão do Pedido de Vendas")
					lRet := .F.
				Else
					If SBZ->BZ_X_PPAP == '2'
						HS_MSGINF('Produto '+Rtrim(aCols[nXX,nPosPrd])+' não possui PPAP, favor entrar em contato com o Depto de Qualidade/PNP2!!!',"Atenção","Inclusão do Pedido de Vendas")
						lRet := .F.
					EndIf
				EndIf

			Next nXX			

		EndIf

	EndIf

Endif
//

Return lRet



static function vldPrcTrf(nVlrPrc, cItem, cLocal, cProd, cTes, nQtdVen)

Local nPosPrc	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_PRCVEN"})
Local nPosIt 	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_ITEM"})
Local nPosLoc	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_LOCAL"})
Local nPosPrd	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_PRODUTO"})
Local nPosTes	:= AScan(aHeader,{|x|AllTrim(x[2]) == "C6_TES"})
Local nPosVlr   := AScan(aHeader,{|x|AllTrim(x[2]) == "C6_VALOR"})


nVlrSug := U_AGF_SHCUS(cProd, cLocal,cTes)
//	alert('Validando....Item '+cValToChar(nx))
if nVlrSug > 0 .and. round(nVlrSug,6) <> Round(nVlrPrc,6) .And. cTes <> '621'
	MsgStop('O Item '+cItem+ ' Produto '+cProd+chr(13)+'Está com valor de '+cValToChar(Round(nVlrPrc,6))+chr(13)+;
	'Sendo que o valor calculado pelo ultimo fechamento é de '+cValToChar(round(nVlrSug,6))+chr(13)+chr(13)+;
	'O Pedido não poderá ser confirmado','Atenção')
	If ApmsgYesNo('Deseja alterar o valor unitário informado para o valor unitário sugerido e prosseguir ?','Importante para continuar')
		aCols[nx][nPosPrc] := nVlrSug
		M->C6_PRCVEN := nVlrSug
		aCols[nx][nPosVlr] := nVlrSug * nQtdVen
		M->C6_VALOR := nVlrSug * nQtdVen
		ApmsgInfo('Favor entrar no valor unitário do item '+cItem+' Produto '+cProd+chr(13)+'Teclar enter para atualizar o valor total !!!!!!','Atenção')
	else
		Return .F.
		nx := len(aCols)
	endif
elseif nVlrSug == 0
	Apmsginfo('O produto informado não tem histórico de custo'+chr(13)+chr(13)+'Por favor consultar o departamento de fiscal e/ou custos...','Atenção...')
endif
return
