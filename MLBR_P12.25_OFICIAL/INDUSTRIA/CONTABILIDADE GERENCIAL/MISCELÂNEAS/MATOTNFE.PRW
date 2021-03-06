#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
//
//
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MATOTNFE � Autor � Sandro Albuquerque � Data �  01/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retornar o valor total do titulo no  momento da conta-     ���
���          � bilizacao do movimento de compras conforme cliente.		  ���
���          � 															  ���
���          � MATOTNFE => Funcao para retornar o valor do titulo servi�o ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���   Uso    � PROTHEUS 10 - Midori                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������        
*/
//
//
User Function MATOTNFE(cParam)
// Variavel cVal � indica��o do tipo do imposto a ser somado na variavel _nValImp
// cParam = 'RET'Abate valor de reten��o PCC
// cParam = 'APU'Abate valor de Pis/Cof de apura��o
// cParam = 'ALL"' Abate todos os impostos e desconto

Local _nValNF  := 0 
Local _nValImp := 0 
Local aAreaAnt := GetArea()

IF Alltrim(cParam) $ 'FOR'
	_nValimp := U_MACTBPCC(SF1->F1_FORNECE,SF1->F1_FILIAL+" ",SF1->F1_DOC,'ALL') // reten��o de impostos PCC
	_nValNF  := SF1->(F1_VALMERC + F1_ICMSRET + F1_VALIPI + F1_DESPESA + F1_FRETE + F1_SEGURO) - (SF1->F1_DESCONT + _nValImp)
	//_nValNF  := SF1->(F1_VALMERC + F1_VALIPI + F1_DESPESA + F1_FRETE + F1_SEGURO) - (SF1->F1_DESCONT + _nValImp)
	
Endif 

RestArea(aAreaAnt)
Return(_nValNF) // Retorna o valor da Nota Fiscal de Entrada sem impostos
