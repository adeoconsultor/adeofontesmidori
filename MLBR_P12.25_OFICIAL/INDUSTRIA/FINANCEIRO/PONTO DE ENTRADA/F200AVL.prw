#Include 'Protheus.ch'
#Include 'TOTVS.CH'
#include 'rwmake.ch'
//====================================================================================================================\\
/*/{Protheus.doc}F200AVL
  ====================================================================================================================
	@description
	Ponto-de-Entrada: F200AVL - Preve retorno de valor lógico V/F

	Descrição:
	O Array passado como parâmetro permitirá que qualquer exceção ou necessidade seja tratada através do ponto de entrada.
	No momento da chamada do ponto de entrada, as tabelas SEE e SA6 estão posicionadas.
	O ponto de entrada prevê retorno de um valor lógico (verdadeiro ou falso) sendo: quando retorno for verdadeiro,
	continua a execução da rotina normalmente; quando retorno for falso, a rotina executará um "Loop", ou seja,
	o processamento da linha atual do arquivo de retorno será abortado e a rotina continuará executando a partir da
	linha seguinte.
	Estrutura do Array:
		[01] - Número do Título
		[02] - Data da Baixa
		[03] - Tipo do Título
		[04] - Nosso Número
		[05] - Valor da Despesa
		[06] - Valor do Desconto
		[07] - Valor do Abatimento
		[08] - Valor Recebido
		[09] - Juros
		[10] - Multa
		[11] - Outras Despesas
		[12] - Valor do Crédito
		[13] - Data Crédito
		[14] - Ocorrência
		[15] - Motivo da Baixa
		[16] - Linha Inteira
		[17] - Data de Vencto
		[18] - aBuffer

	@author		WILLER TRINDADE
	@version	1.0
	@since		31/08/2015
	@return		lRet : Define se continua ou nao a baixa normal do CNAB
	@param

	@obs 		31/08/2015- WILLER TRINDADE
	Áreas utilizadas: "SE1"

	@sample	U_F200AVL()

/*/
//===================================================================================================================\\


User Function F200AVL()

Local lRet		:= .T.
Local cSeekTit	:= xFilial("SE1")
Local cCliente
Local cLoja
Local cPref
Local cNum

Private aClient := {}
Private aValores:= PARAMIXB[1]

cSeekTit+=  If( (ValType(aValores)=="A" .And. Len(aValores)>=1 .And. ValType(aValores[1])=="C") ;
, Substr(aValores[1],1,10) ;
, space(10))

SE1->(dbSetOrder(16)) // Filial+IdCnab

If AllTrim(aValores[14]) $ "06#09#36#37" ; // Verifica se é uma ocorrência de baixa
	.And. SE1->(MsSeek(cSeekTit)) ; // Busca por IdCnab
	.And. ("NF" $ SE1->E1_TIPO);  // Verifica se o título é o principal
	.And. (SE1->E1_CLIENTE $ "000008")      //Alterado somente para Takata via cnab
	//.And. (SE1->E1_CLIENTE $ "000008#000479#001489#001532")
	
	
	cCliente	:= SE1->E1_CLIENTE
	cLoja		:= SE1->E1_LOJA
	cPref 		:= SE1->E1_PREFIXO
	cNum		:= SE1->E1_NUM
	
	
	AADD(aClient,{cCliente,cLoja,cPref,cNum } )
	
	FINRT01(aClient,aValores)
	
EndIf

Return (lRet)

//--------------------------------------------------------------------------------------------------------
// {Protheus.doc} FINRT001

//--------------------------------------------------------------------------------------------------------

Static Function FINRT01(aClient,aValores)

Local lRet		:= .T.
Local aAreaBkp	:= {}
Local aAreaSE1  := {}  
Local xFilial



//--------------------------------------------------
// Backup das áreas atuais
aEval({"SE1"}, { |area| aAdd(aAreaBkp, (area)->(GetArea()) ) } )
aAdd(aAreaBkp, GetArea())

DbSelectArea("SE1")
DbSetOrder(2)
If DbSeek(xFilial("SE1")+(aClient[1][1])+(aClient[1][2])+(aClient[1][3])+(aClient[1][4])+" "+"CF-")
	
			RecLock("SE1",.F.)
			SE1->E1_BAIXA		:= aValores[02]
			SE1->E1_HIST     	:= "BXAUTO"	
			SE1->E1_SALDO   	:= 0
			SE1->E1_VALLIQ  	:= SE1->E1_VALOR
			//SE1->E1_LA			:= "S"
			//SE1->E1_OK			:= "ok"

			MsUnLock("SE1")

EndIf
DbSelectArea("SE1")
DbSetOrder(2)
If DbSeek(xFilial("SE1")+(aClient[1][1])+(aClient[1][2])+(aClient[1][3])+(aClient[1][4])+" "+"PI-")
	
			RecLock("SE1",.F.)
			SE1->E1_BAIXA		:= aValores[02]
			SE1->E1_HIST     	:= "BXAUTO"	
			SE1->E1_SALDO   	:= 0
			SE1->E1_VALLIQ  	:= SE1->E1_VALOR
			//SE1->E1_LA			:= "S"
			//SE1->E1_OK			:= "ok"

			MsUnLock("SE1")

EndIf

/*-------------------------------------------------*/

aEval(aAreaBkp, {|area| RestArea(area)}) // Restaura as áreas anteriores
Return (lRet)
