#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MATOTNFE º Autor ³ Sandro Albuquerque º Data ³  01/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retornar o valor total do titulo no  momento da conta-     º±±
±±º          ³ bilizacao do movimento de compras conforme cliente.		  º±±
±±º          ³ 															  º±±
±±º          ³ MATOTNFE => Funcao para retornar o valor do titulo serviço º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º   Uso    ³ PROTHEUS 10 - Midori                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß        
*/
//
//
User Function MATOTNFE(cParam)
// Variavel cVal é indicação do tipo do imposto a ser somado na variavel _nValImp
// cParam = 'RET'Abate valor de retenção PCC
// cParam = 'APU'Abate valor de Pis/Cof de apuração
// cParam = 'ALL"' Abate todos os impostos e desconto

Local _nValNF  := 0 
Local _nValImp := 0 
Local aAreaAnt := GetArea()

IF Alltrim(cParam) $ 'FOR'
	_nValimp := U_MACTBPCC(SF1->F1_FORNECE,SF1->F1_FILIAL+" ",SF1->F1_DOC,'ALL') // retenção de impostos PCC
	_nValNF  := SF1->(F1_VALMERC + F1_ICMSRET + F1_VALIPI + F1_DESPESA + F1_FRETE + F1_SEGURO) - (SF1->F1_DESCONT + _nValImp)
	//_nValNF  := SF1->(F1_VALMERC + F1_VALIPI + F1_DESPESA + F1_FRETE + F1_SEGURO) - (SF1->F1_DESCONT + _nValImp)
	
Endif 

RestArea(aAreaAnt)
Return(_nValNF) // Retorna o valor da Nota Fiscal de Entrada sem impostos
