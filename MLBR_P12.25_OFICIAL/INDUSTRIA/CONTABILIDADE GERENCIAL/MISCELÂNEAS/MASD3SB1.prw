#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
//
//
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MASD3SB1 � Autor � Sandro Albuquerque � Data �  15/03/10   ���
�������������������������������������������������������������������������͹��
���          � GATILHO SD3->D3_CC                                         ���
���Desc.     � Retornar a conta contabil de acordo com a regra de centro  ���
���          � de custos estabelecida pelo cliente.  					  ���
���          � 															  ���
���          � MASD3CTA    => Funcao para retornar a conta contabil       ���
���          � 		cCod   => Codigo do Produto                           ���
���          � 		cCC    => Centro de Custos                            ���
���          � 		cGrupo => Grupo de Produtos                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���   Uso    � PROTHEUS 10- Midori  									  ���
��������������������������������������������������������������������������ͱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//
//
User Function MASD3SB1(cCod,cCC,cGrupo)

Local aAreaAnt := GetArea()
Local _cRet   := "FALTA CONTA-Prod.:"+Alltrim(cCod)
Local _cCod   := cCOD
Local _cCc    := cCC
Local _cGrupo := cGrupo

_cGrupo := Posicione("SB1",1,xFilial("SB1") + _cCod,"B1_GRUPO")

Do Case
	
	CASE AllTrim(SD3->D3_CC) >= "300" .And. AllTrim(SD3->D3_CC) <= "399"
		_cRet 	:=SB1->B1_ESTIND
	Otherwise
		_cRet 	:= SB1->B1_GERAIS
		
EndCase

RestArea(aAreaAnt)
Return(_cRet) // Retorna a conta contabil.


//IIF(SA1->A1_TIPO == "X",SB1->B1_CPVEXT,SB1->B1_CPV) 


