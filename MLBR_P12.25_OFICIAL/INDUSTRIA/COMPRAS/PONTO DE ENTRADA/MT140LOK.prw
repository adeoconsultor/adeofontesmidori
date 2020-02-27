#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT140LOK  บAutor  ณBruno M. Mota       บ Data ณ  01/19/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjusta a descricao dos produtos com base nos seus respecti- บฑฑ
ฑฑบ          ณvos c๓diogs (Solicitacao via Help-Desk)                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MT140LOK()

//Variaveis locais da funcao
Local nPosCod 	:= AScan(aHeader,{|x|AllTrim(x[2]) == "D1_COD"})
Local nPosDesc  := AScan(aHeader,{|x|AllTrim(x[2]) == "D1_X_DESCR"})
Local nPosCC    := AScan(aHeader,{|x|AllTrim(x[2]) == "D1_CC"})      // Para valida็ใo pela rotina MAVALCCD() - Por Sandro
Local nPosItem  := AScan(aHeader,{|x|AllTrim(x[2]) == "D1_ITEMCTA"}) // Para valida็ใo pela rotina MAVALCCD() - Por Sandro
Local nPosEven  := AScan(aHeader,{|x|AllTrim(x[2]) == "D1_X_CODEV"}) //Codigo do Evento cadastrado no pedido de compra
Local nPosPed   := AScan(aHeader,{|x|AllTrim(x[2]) == "D1_PEDIDO"}) //Localizar o numero do pedido para buscar o codigo do evento
Local nPosItP   := AScan(aHeader,{|x|AllTrim(x[2]) == "D1_ITEMPC"}) //Item do Pedido de compras
Local nPosCta	:= Ascan(aHeader,{|x|AllTrim(x[2]) == "D1_CONTA"}) 	//Para validar a conta contabil informada, conforme e-mail passado pelo
Local nPosTes	:= Ascan(aHeader,{|x|AllTrim(x[2]) == "D1_TES" })
Local nPosPrj	:= Ascan(aHeader,{|x|Alltrim(x[2]) == "D1_X_CODEV"})
//Sr.Carlos (Contador B.F)
//C.Contabil iniciadas com 4 aceitar apenas C.C. iniciados por 1,4 e 5
//C.Contabil iniciadas com 3 aceitar apenas C.C. iniciados por 3
Local nX 		:= 0
Local cVar      := ' '
Local lRet2		:= ''
Local cCodP     := ''
local cGrupo 	:= ''

local lVldGr90 		:= GetMv( 'MA_VLDGR90' ) //Parametro que informa se valida inclusao de ativos


Local lRet  := .T.

If FunName() <> "EICDI154"
	cCC  := aCols[N][nPosCC]
	cTes := iif(nPosTes > 0,aCols[N][nPosTes],"")
	cPrj := iif(nPosPrj > 0,aCols[N][nPosPrj],"")
	if !u_ag_blqctt(cCC,cPrj, cTes) //Valida o centro de custo para nao utilizar C.Custo diferente do permitido a partir de ABR/2014
		Return
	endif





	
	//Loop de processamento
	For nX := 1 To Len(aCols)
		
		//Ajusta conteudo
		aCols[nX][nPosDesc] := Posicione("SB1",1,xFilial("SB1")+aCols[nX][nPosCod],"SB1->B1_DESC")
		aCols[nX][nPosEven] := Posicione("SC7",1,xFilial("SC7")+aCols[nX][nPosPed]+aCols[nX][nPosItP],"C7_X_CODEV")
		//		Alert("EVENTO: "+Posicione("SC7",1,xFilial("SC7")+aCols[nX][nPosPed]+aCols[nX][nPosItP],"C7_X_CODEV") )
		//Rotina para validar produto do grupo 90 que nao poderแ dar entrada + de 1 vez se nao for o fornecedor 000148
		cCodP  := Posicione("SB1",1,xFilial("SB1")+aCols[nX][nPosCod],"SB1->B1_COD")
		cGrupo := Posicione("SB1",1,xFilial("SB1")+aCols[nX][nPosCod],"SB1->B1_GRUPO")
		if lRet .and. lVldGr90 .and. cGrupo $ '90  ' .and. CA100FOR <> '000148' //Se todos os itens anteriores forem validos, faz a valida็ใo se o item ้ do ativo....
			lRet := U_VLDGRP90(cCodP)
			Alert('Produto jแ utilizado na aquisi็ใo de ativo, nใo poderแ ser utilizado novamente!!!')
			return lRet
		endif
		
		
		
		
		//******************************************************************************************************************
		// INCLUIDO POR SANDRO em 27/01/2011 - Conforme HELP DESK - 002584 - Izabel
		// MAVALCCD(cCCD, cITC) - Funcใo criada para o Titulos a pagar manual, solicita็ใo de compras e pr้ nota de entrada.
		//******************************************************************************************************************
		
		// Conteudo do Acols de cada campo
		cCC  := aCols[nX][nPosCC]     // Centro de Custos
		cIT  := aCols[nX][nPosItem]   // Unidade de Origem
		cCta := aCols[nX][nPosCta] 	   // Conta Contabil
		
		// Retorno da valida็ใo do Centro de Custos
		//			cVar := U_MAVALCCD(cCC, cIT) 	// RETIRADO POR ANESIO CFE SOLICITACAO DO SR.MAURI PARA REMODELAR OS LANCAMENTOS
		// EM CENTRO DE CUSTOS DAS UNIDADES
		
		//	if !u_ag_blqctt(cCC) //Valida o centro de custo para nao utilizar C.Custo diferente do permitido a partir de ABR/2014
		//			Return
		//		endif
		
		
		IF Empty(cVar)
			aCols[nX][nPosCC] := cCC
			lRet := .F.
		Else
			lRet := .T.
			
		Endif
		
	Next nX

	//***************************************************************************************
	// INCLUIDO POR AOliveira em 26/07/2011 - Conforme HELP DESK - 003262 - Marcos|Suprimento
	//***************************************************************************************
	lRet2 := U_xPercEntr()
	If !lRet2
		lRet := .F.
	Endif
	
EndIf
//lRet := u_ag_VldCC(cCC, cIT, cCta)
lRet := .T.
//Sempre vai retornar TRUE depois que mudou a rotina de C.Custo CFE obs acima // ANESIO - 09/01/2012
//Retorno da rotina
Return(lRet)

/*---------------------------------------------------------
Fun็ใo: xPercEntr 	|Autor: AOliveira  |Data: 25-07-2011
-----------------------------------------------------------
Descr.: PE tem como objetivo realizar valida็ใo da Qtd
Un. de Produtos da NFE, contra Qdt Un. de produtos
do PC.
Regra;
SE Qtd. Un. da NFE for at้ 4% > que a Qtd. do PC
permitir a Entrada da NFE.
SE Qtd. Un. for > 4% que Qtd. do PC bloquear a
entrada e exibir MSG ao usuแrio (Solicitar
libera็ใo da entrada ao setor de SUPRIMENTOS).
---------------------------------------------------------*/
User Function xPercEntr()
Local aAreaSC7 := SC7->(GetArea())
Local aAreaSD1 := SD1->(GetArea())
Local lRet	   := .F.
Local nVLRPerc := GetNewPar("EP_PERCENTR","4")

Local cProdNfe := GdFieldGet("D1_COD",n)
Local cQdUnNfe := GdFieldGet("D1_QUANT",n)
Local cNumPC   := GdFieldGet("D1_PEDIDO",n)
Local cItemPC  := GdFieldGet("D1_ITEMPC",n)
Local cVlUnit  := GdFieldGet("D1_VUNIT",n)
Local cVarQtde
Local cVarPrec
Local nPosiCod		:= aScan(aHeader,{|x|Alltrim(x[2])=="D1_COD"})
Local cGrupo1


If FunName() == 'MATA140'  //S๓ executa para a rotina de PRE-NOTA
	
	nVLRPerc := IF(ValType(nVLRPerc)<>"N",Val(nVLRPerc),nVLRPerc)
	
	DbSelectArea("SC7")
	SC7->(DbSetOrder(1)) //C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
	SC7->(DbSeek(xFilial("SC7")+cNumPC+cItemPC))
	
	//**********************************************************************
	//Manuten็ใo por Vinicius Schwartz - TI - Midori Atlantica em 28/11/2012
	//Ref ao HDI 004933 - Marcos - BFU (Suprimentos)
	//**********************************************************************
	
	DbSelectArea("AIC")
	DbGoTop()
	
	If SC7->C7_PRODUTO == cProdNfe
		//Buscando % permitido para posteriormente poder comparar com o que foi informado.
		/*
		//Achando a varia็ใo entre o pedido e a pre-nota em % e se negativo transforma em positivo
		cVarQtde := ((cQdUnNfe / SC7->C7_QUANT) - 1) * 100
		cVarPrec := ((cVlUnit / SC7->C7_PRECO) -1)*100
		
		//Transforma valor em positivo em caso de valor negativo
		If cVarQtde < 0
		cVarQtde := cVarQtde * (-1)
		endif
		
		If cVarPrec < 0
		cVarPrec := cVarPrec * (-1)
		endif
		*/
		DbSelectArea('SB1')
		DbSetOrder(1)
		
		If DbSeek(xFilial('SB1') + aCols[n][nPosiCod])
			cGrupo1		:=SB1->B1_GRUPO
		endif
		
		//Loop para procurar uma regra que atenda o que foi informado de tolerโncia
		//Alert ('Fornece SD1 ->' + CA100FOR + ' Lj D1 -> ' + CLOJA + ' Produto D1 ->' + aCols[n][nPosiCod] + ' Grupo D1 -> ' + cGrupo1)
		While !AIC->(Eof())
			If ((cQdUnNfe + SC7->C7_QUJE) <= (SC7->C7_QUANT * ((AIC->AIC_PQTDE / 100) + 1))) .And. (cVlUnit <= (SC7->C7_PRECO * ((AIC->AIC_PPRECO / 100) +1)))
				//If (cVarQtde <= AIC->AIC_PQTDE) .And. (cVarPrec <= AIC->AIC_PPRECO)
				If  (CA100FOR == AIC->AIC_FORNEC .Or. AIC->AIC_FORNEC == Space(6)) .And. (CLOJA == AIC->AIC_LOJA .Or. AIC->AIC_LOJA == Space(2)) .And. (aCols[n][nPosiCod] == AIC->AIC_PRODUT .Or. AIC->AIC_PRODUT == Space(15)) .And. (cGrupo1 == AIC->AIC_GRUPO .Or. AIC->AIC_GRUPO == Space(4))
					lRet := .T.
					//Alert ('Satisfez todas as condi็๕es e atribuiu .T. no retorno!!!')
				endif
				AIC->(DbSkip())
			Else
				AIC->(DbSkip())
			endif
		Enddo
		
		//If para tratar os 4% padrใo caso nใo tenha nenhuma regra
		If !lRet
			If ((cQdUnNfe + SC7->C7_QUJE) > SC7->C7_QUANT * ((nVLRPerc / 100) + 1)) .Or. ((cVlUnit <> SC7->C7_PRECO) .And. (SC7->C7_MOEDA == 1))
				Aviso("Atencao","Qtde informada maior que % Permitido e/ou Valor unitario diferente do Pedido. Solicite Libera็ใo ao Setor de SUPRIMENTOS...",{"OK"})
			Else
				lRet := .T.
			endif
		endIf
	Else
		//Alert ('nใo existe pedido e serแ atribuido .T. para lRet!!!')
		lRet := .T.
	EndIf
	
	SC7->(DbCloseArea())
	AIC->(dbCloseArea())
Else
	lRet := .T.
	
EndIf

RestArea(aAreaSC7)
RestArea(aAreaSD1)

Return(lRet)




//////////////////////////////////////////////////////////////////////////////////////////////////////
//Ponto de entrada para validar se na classificacao o usuario estแ respeitando a mesma regra do C.CUSTO
//feito no lan็amento da PRษ-NOTA
//////////////////////////////////////////////////////////////////////////////////////////////////////
User Function xVldCC()
//Variaveis locais da funcao
Local nPosCod 	:= AScan(aHeader,{|x|AllTrim(x[2]) == "D1_COD"})
Local nPosDesc  := AScan(aHeader,{|x|AllTrim(x[2]) == "D1_X_DESCR"})
Local nPosCC    := AScan(aHeader,{|x|AllTrim(x[2]) == "D1_CC"})      // Para valida็ใo pela rotina MAVALCCD() - Por Sandro
Local nPosItem  := AScan(aHeader,{|x|AllTrim(x[2]) == "D1_ITEMCTA"}) // Para valida็ใo pela rotina MAVALCCD() - Por Sandro
Local nX 		:= 0
Local cVar      := ' '
Local lRet2		:= ''

lRet  := .T.

//Alert('Chamou funcao...')
If FunName() <> "EICDI154"
	
	//Loop de processamento
	For nX := 1 To Len(aCols)
		
		//Ajusta conteudo
		aCols[nX][nPosDesc] := Posicione("SB1",1,xFilial("SB1")+aCols[nX][nPosCod],"SB1->B1_DESC")
		
		
		//******************************************************************************************************************
		// INCLUIDO POR SANDRO em 27/01/2011 - Conforme HELP DESK - 002584 - Izabel
		// MAVALCCD(cCCD, cITC) - Funcใo criada para o Titulos a pagar manual, solicita็ใo de compras e pr้ nota de entrada.
		//******************************************************************************************************************
		
		// Conteudo do Acols de cada campo
		cCC  := aCols[nX][nPosCC]     // Centro de Custos
		cIT  := aCols[nX][nPosItem]   // Unidade de Origem
		
		// Retorno da valida็ใo do Centro de Custos
		//		Alert('CC -> '+cCC+' Item -> '+cValToChar(cIT))
		//		cVar := U_MAVALCCD(cCC, cIT)  	// RETIRADO POR ANESIO CFE SOLICITACAO DO SR.MAURI PARA REMODELAR OS LANCAMENTOS
		// EM CENTRO DE CUSTOS DAS UNIDADES
		
		IF Empty(cVar)
			aCols[nX][nPosCC] := cCC
			lRet := .F.
		Else
			lRet := .T.
			
		Endif
		
	Next nX
	
	//***************************************************************************************
	// INCLUIDO POR AOliveira em 26/07/2011 - Conforme HELP DESK - 003262 - Marcos|Suprimento
	//***************************************************************************************
	lRet2 := U_xPercEntr()
	If !lRet2
		lRet := .F.
	Endif
	
EndIf
lRet:=.T.
//Retorno da rotina
Return(lRet)



//*****************************************************************************************
// INCLUIDO POR ANESIO CFE SOLICITACAO DO SR.CARLOS (CONTADOR BF.) VIA EMAIL EM 25/02/2013
//*****************************************************************************************
user function ag_vldCC(cCC, cIT, cCta)
local lRet := .T.

If FunName() <> "EICDI154"
	
	if Substr(cIT,1,2) $ '01'
		if !Substr(cCC,1,1) $ '145 '
			Alert('Lan็amento com unidade de ORIGEM 01'+chr(13)+'Utilize apenas C.Custos Iniciados com 1, 4 ou 5 !!')
			lRet := .F.
			Return(lRet)
		endif
	endif
	if Substr(cCta,1,1) == '4'
		if !Substr(cCC,1,1) $ '145'
			Alert('Conta Contabil iniciada por 4'+chr(13)+'Utilize apenas C.Custos Iniciados com 1, 4 ou 5 !!')
			lRet := .F.
			Return(lRet)
		endif
	endif
	
	if Substr(cCta,1,1) == '3'
		if !Substr(cCC,1,1) $ '3'
			Alert('Conta Contabil iniciada por 3'+chr(13)+'Utilize apenas C.Custos Iniciados com 3 !!')
			lRet := .F.
			Return(lRet)
		endif
	endif
EndIf
Return (lRet)


//*****************************************************************************************
// INCLUIDO POR ANESIO CFE SOLICITACAO DO SR.CARLOS (CONTADOR BF.) VIA EMAIL EM 25/02/2013
//*****************************************************************************************
// PONTO DE ENTRADA CHAMADO NO MOMENTO DA CLASSIFICAO DA NF. VALIDA A LINHA
//*****************************************************************************************
user function MT100TOK()
//Variaveis locais da funcao
Local nPosCC    := AScan(aHeader,{|x|AllTrim(x[2]) == "D1_CC"})
Local nPosItem  := AScan(aHeader,{|x|AllTrim(x[2]) == "D1_ITEMCTA"})
Local nPosCta	:= Ascan(aHeader,{|x|AllTrim(x[2]) == "D1_CONTA"})

Local nPosProd	:= Ascan(aHeader, {|x| Alltrim(x[2]) = "D1_COD"})							// Posicao do codigo do produto
Local nPosMes	:= Ascan(aHeader, {|x| Alltrim(x[2]) = "D1_X_MCLAS"})							// Posicao do Mes ref classificadores
Local nPosNomC	:= Ascan(aHeader, {|x| Alltrim(x[2]) = "D1_X_NCLAS"})							// Posicao do nome do classificador	
Local cPrdY		:= GetMv('MV_PRODCON')
Local lRet 		:= .T.
Local nx

//aNfeDanfe//aRecSF1Ori//aCodR
If FunName() <> "EICDI154" .And. FunName() <> "SPEDNFE"
    /*
  	If cTipo $ "N/I/P/C" 
		If Alltrim(CESPECIE)$"CTE|CTEOS" .And. Empty(SF1->F1_UFORITR)
      		MsgAlert(" Para CTE/CTEOS verificar UF/Municipio Origem/Destino","Atencao")
      		lRet := .F.
      		Return(lRet)
		ElseIf Alltrim(CESPECIE)$"CTE|CTEOS" .And. Empty(SF1->F1_MUORITR)
      		MsgAlert(" Para CTE/CTEOS verificar UF/Municipio Origem/Destino","Atencao")
      		lRet := .F. 
      		Return(lRet)
      	ElseIf Alltrim(CESPECIE)$"CTE|CTEOS" .And. Empty(SF1->F1_UFDESTR)
      		MsgAlert(" Para CTE/CTEOS verificar UF/Municipio Origem/Destino","Atencao")
      		lRet := .F. 
      		Return(lRet)
      	ElseIf Alltrim(CESPECIE)$"CTE|CTEOS" .And. Empty(SF1->F1_MUDESTR)
      		MsgAlert(" Para CTE/CTEOS verificar UF/Municipio Origem/Destino","Atencao")
      		lRet := .F.
      		Return(lRet)		
		Endif  
	EndIf
	
	*/
	for nx := 1 to len(aCols)
		cCC  := aCols[nX][nPosCC]     // Centro de Custos
		cIT  := aCols[nX][nPosItem]   // Unidade de Origem
		cCta := aCols[nX][nPosCta]    // Conta Contabil
		lRet := u_ag_VldCC(cCC, cIT, cCta)
		if !lRet
			nx := len(aCols)
		endif
		
		If  Alltrim(aCols[nx][nPosProd]) $ cPrdY
			If Empty(aCols[nx][nPosNomC])
				ApMsgAlert("Favor informar o nome classificador(couro) no campo "+ chr(13)+"'Nome Classif' para o produto " +(aCols[nx][nPosProd])+"","Aten็ใo")
				lRet := .F.
			EndIf
		
			If	Empty(aCols[nx][nPosMes])
				ApMsgAlert("Favor informar o mes referente ao classificador(couro) no campo "+ chr(13)+"'Mes Ref Class' para o produto" +(aCols[nx][nPosProd])+"","Aten็ใo")
				lRet := .F.
			EndIf
		EndIf	
	next nx
	
	
EndIF	
	
return (lRet)
