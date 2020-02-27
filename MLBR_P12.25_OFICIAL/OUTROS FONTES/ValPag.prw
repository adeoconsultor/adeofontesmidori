#include "rwmake.ch"
#Include "Topconn.ch"
/*-------------------------------------------------------------------
Função: ValPag       |Autor: HUMBERTO GARCIA  | 25/11/2009
---------------------------------------------------------------------
Objetivo: Este programa informa o valor que sera pago para um titulo
no arquivo de remessa do CNAB a pagar, de acordo com as
especificacoes:
---------------------------------------------------------------------
USO: DEPARTAMENTO FINANCEIRO MIDORI ATLANTICA
---------------------------------------------------------------------
Atualização: Realizado Melhorias no fonte pelo analista AOliveira, em
27-06-11 (Melhorias na estrutura do fonte, e inclusão de
funnção para verificar valores de NDF.

AOliveira 20-07-2011, realizado inclusão da seguinte
regra (SE VLR do Boleto e Titulos são iguais e existe VLR
de Descressimo ou Acressimo,  _nValor := nSaldo + _nValor
-------------------------------------------------------------------*/
/*
PROGRAMA:          VALPAG
AUTOR:             HUMBERTO GARCIA
DATA DE CRIACAO:   25/11/2009
UTILIZACAO:        DEPARTAMENTO FINANCEIRO MIDORIA ATALNTICA
FINALIDADE E DESCRICAO: Este programa informa o valor que sera pago para um titulo no arquivo de remessa do CNAB a pagar, de acordo com as especificacoes:
*/
User Function ValPag()

Local aArea	:= GetArea()

Local nRet 		:= 0
Local SomaAbat
Local nVlrBar 	:= Val(Substr(SE2->E2_CODBAR,10,10))
Local nSALDO   	:= SE2->E2_SALDO*100

Local nAcresc  := ((SE2->E2_MULTA + SE2->E2_JUROS + SE2->E2_CORREC + SE2->E2_ACRESC)*100)
Local nTXBANC  := SE2->E2_TXBANC*100
Local nDECRESC := SE2->((E2_DECRESC*100)+(E2_TXBANC*100))
Local nVlrNDF  := u_ValNDF(SE2->E2_FILIAL,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_FORNECE,SE2->E2_LOJA)  //AOliveira 27-06-2011
Local nAbatim  := SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,dDataBase,SE2->E2_FORNECE,SE2->E2_LOJA) 
//Local _nAbatim  := ((nDECRESC + SE2->E2_DESCONT)*100)

//Calcular o total de abatimentos do título - SomaAbat ( [ cPrefixo ] [ cNumero ] [ cParcela ] [ cCart ] [ nMoeda ] [ dData ] 
//[ cFornCli ] [ cLoja ] [ cFilAbat ] [ dDataRef ] ) --> nTotAbat - Utiliza procedure do financeiro a rotina SomaAbat - Willer/27/05/14

_nAbatim := (nAbatim * 100)

/**/
//nDECRESC := If(nDECRESC == 1,0,nDECRESC)
//nAcresc	 := If(nAcresc == 1,0,nAcresc)

Private _nValor := (nAcresc + nTXBanc)-(nDecresc+_nAbatim) // + nVlrNDF)


If Substr(SE2->E2_CODBAR,1,3) == "   "
	_nValor := nSaldo + _nValor
Else
	
	If nVlrBar <> nSALDO
		
		_nValor := nSaldo + _nValor
		
	ElseIf  SE2->E2_VALLIQ > 0  //Casos de Abatimentos
		
		_nValor := ((SE2->E2_VALOR - SE2->E2_VALLIQ) *100 ) - (nDECRESC + _nAbatim)
		
	ElseIF nVlrBar == nSALDO .And. _nValor < 0  .OR. _nValor > 0 //Casos que VLR do Boleto e titulos são iguais e exite VLR de Decressimo ou Acrescimo.
		
		_nValor := nSaldo + _nValor
		
	Else
		_nValor := nVlrBar
		
	EndIf
	
Endif


nRET := Strzero(_nValor,15,0)
RestArea(aArea)
Return(nRET)


/*-------------------------------------------------
Programa: DTLimDesc |Autor: AOliveira | 02/06/2011
---------------------------------------------------
Objetivo: Retornar DT Limite do Desconto
Posição 182 A 189 CNAB Bradesco.
Obrigatório, quando informado valor do
Desconto nas posições 220 a 234
-------------------------------------------------*/
User Function DTLimDesc()

Local aArea		:= GetArea()
Local nDecrec := u_VLRDECRESC()
Local nRet := StrZero(0,8)

If Val(nDecrec) > 0
	nRet := DTOS(SE2->E2_VENCREA)
EndIf

RestArea(aArea)

Return(nRet)

/*-------------------------------------------------
Programa: ValNDF    |Autor: AOliveira | 27/06/2011
---------------------------------------------------
Objetivo: Retornar Vlr das NDF referente ao titulo
posicionado.
-------------------------------------------------*/
User Function ValNDF(E2_FILIAL,E2_PREFIXO,E2_NUM,E2_FORNECE,E2_LOJA)
Local nRet, cQry

cQry := ""
cQry += " SELECT SUM(E5_VALOR) E5_VALOR FROM "+ RetSqlname("SE5")
cQry += " WHERE E5_FILIAL = '"+E2_FILIAL+"' AND E5_PREFIXO = '"+E2_PREFIXO+"' AND E5_NUMERO = '"+ E2_NUM+" 'AND E5_CLIFOR = '"+E2_FORNECE+"' AND E5_LOJA = '"+E2_LOJA+"'  "
cQry += " AND E5_TIPODOC = 'CP' AND E5_DOCUMEN LIKE '%NDF%' AND D_E_L_E_T_ = ' ' "

TCQuery cQry Alias NDF New

DBSelectArea("NDF")
nRet := If(Empty(NDF->E5_VALOR),0,NDF->E5_VALOR)

DbCloseArea("NDF")

Return(nRet)

/*------------------------------------------------------------------------
Programa: VLRDECRESC       | Autor: AOliveira            |Data: 13/07/11
--------------------------------------------------------------------------
Objetivo: Retornar Vlr de Acrecimo do CNAB a Pagar
--------------------------------------------------------------------------
Uso: DEPARTAMENTO FINANCEIRO MIDORIA ATALNTICA
--------------------------------------------------------------------------
Parametros: Nenhum
--------------------------------------------------------------------------
Regra:  E2_DESCRESC + E2_TXBANC = VLR DECRESCIMO
------------------------------------------------------------------------*/
User Function VLRDECRESC()

Local aArea		:= GetArea()
Local nRet      := Replicate("0",15)
Local nDecresc  := (SE2->E2_DECRESC)+(SE2->E2_TXBANC)

Local nVlrDoc := u_PagVal()
Local nVlrPag := u_ValPag()

If nDecresc == 0.01
	nDecresc := 0
ElseIf SubStr(nVlrDoc,6) == SubStr(nVlrPag,6) //03-08-2011 -Vlr do Doc igual ao Vlr pago.
	nDecresc := 0
EndIf

nRet := StrZero(nDecresc*100,15)

RestArea(aArea)
Return(nRet)
