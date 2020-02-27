#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MASD3SB1 º Autor ³ Sandro Albuquerque º Data ³  15/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ GATILHO SD3->D3_CC                                         º±±
±±ºDesc.     ³ Retornar a conta contabil de acordo com a regra de centro  º±±
±±º          ³ de custos estabelecida pelo cliente.  					  º±±
±±º          ³ 															  º±±
±±º          ³ MASD3CTA    => Funcao para retornar a conta contabil       º±±
±±º          ³ 		cCod   => Codigo do Produto                           º±±
±±º          ³ 		cCC    => Centro de Custos                            º±±
±±º          ³ 		cGrupo => Grupo de Produtos                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º   Uso    ³ PROTHEUS 10- Midori  									  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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


