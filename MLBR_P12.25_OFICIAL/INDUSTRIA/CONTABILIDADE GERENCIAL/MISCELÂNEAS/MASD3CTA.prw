#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MASD3CTA º Autor ³ Sandro Albuquerque º Data ³  15/03/10   º±±
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
User Function MASD3CTA(cCod,cCC,cGrupo)

Local aAreaAnt := GetArea()
Local _cRet   := "FALTA CONTA NO PROD:"+Alltrim(cCod)
Local _cCod   := cCOD
Local _cCc    := cCC
Local _cGrupo := cGrupo

_cGrupo := Posicione("SB1",1,xFilial("SB1") + _cCod,"B1_GRUPO")
 
Do Case    
//ANT    Case SD3->D3_TM $ "001|005" .And. Alltrim(SD3->D3_GRUPO) $ "71|72" .And. Alltrim(SD3->D3_CC) >= "321" .AND. Alltrim(SD3->D3_CC) <= "327"
    Case SD3->D3_TM $ "001|005" .And. Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. Alltrim(SD3->D3_CC) >= "320000" .AND. Alltrim(SD3->D3_CC) <= "320999"
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_CONDIR")
//ANT    Case SD3->D3_TM $ "001|005" .And. Alltrim(SD3->D3_GRUPO) $ "71|72" .And. Alltrim(SD3->D3_CC) >= "328" .AND. Alltrim(SD3->D3_CC) <= "399"
    Case SD3->D3_TM $ "001|005" .And. Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. Alltrim(SD3->D3_CC) >= "350000" .AND. Alltrim(SD3->D3_CC) <= "399999"
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_CONIND")
//ANT    Case SD3->D3_TM $ "001|005" .And. Alltrim(SD3->D3_GRUPO) $ "75|91|99" .And. Alltrim(SD3->D3_CC) >= "321" .AND. Alltrim(SD3->D3_CC) <= "399"
//    Case SD3->D3_TM $ "001|005" .And. Alltrim(SD3->D3_GRUPO) $ "75|91|99" .And. Alltrim(SD3->D3_CC) >= "350000" .AND. Alltrim(SD3->D3_CC) <= "399999"
//		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_CONIND")
//ANT	Case SD3->D3_TM $ "001|005" .And. Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. !Alltrim(SD3->D3_CC) >= "321" .AND. Alltrim(SD3->D3_CC) <= "399"
	Case SD3->D3_TM $ "001|005" .And. Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. !Alltrim(SD3->D3_CC) >= "320000" .AND. Alltrim(SD3->D3_CC) <= "399999"
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_GERAIS")
//ANT     Case SD3->D3_TM $ "002" .And. !Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. Alltrim(SD3->D3_CC) >= "321" .AND. Alltrim(SD3->D3_CC) <= "399"

     Case SD3->D3_TM $ "002" .And. !Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. Alltrim(SD3->D3_CC) >= "350000" .AND. Alltrim(SD3->D3_CC) <= "399999"
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_CONIND")
     Case SD3->D3_TM $ "002" .And. !Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. Alltrim(SD3->D3_CC) >= "320000" .AND. Alltrim(SD3->D3_CC) <= "320999"
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_CONDIR")
		
//ANT     Case SD3->D3_TM $ "002" .And. !Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. ((Alltrim(SD3->D3_CC) >= "101" .AND. Alltrim(SD3->D3_CC) <= "149").OR.;
//        (Alltrim(SD3->D3_CC) >= "401" .AND. Alltrim(SD3->D3_CC) <= "599"))
     Case SD3->D3_TM $ "002" .And. !Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. ((Alltrim(SD3->D3_CC) >= "410000" .AND. Alltrim(SD3->D3_CC) <= "410999")) //.OR.;
//        (Alltrim(SD3->D3_CC) >= "401" .AND. Alltrim(SD3->D3_CC) <= "599"))
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_GERAIS")

//ANT      Case SD3->D3_TM $ "501|502" .And. Alltrim(SD3->D3_GRUPO) $ "71|72" .And. Alltrim(SD3->D3_CC) >= "321" .AND. Alltrim(SD3->D3_CC) <= "327"
     Case SD3->D3_TM $ "501|502" .And. Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. Alltrim(SD3->D3_CC) >= "320000" .AND. Alltrim(SD3->D3_CC) <= "320999"
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_CONDIR")
//ANT*     Case SD3->D3_TM $ "501|502" .And. Alltrim(SD3->D3_GRUPO) $ "71|72" .And. Alltrim(SD3->D3_CC) >= "328" .AND. Alltrim(SD3->D3_CC) <= "399"
//     Case SD3->D3_TM $ "501|502" .And. Alltrim(SD3->D3_GRUPO) $ "71|72" .And. Alltrim(SD3->D3_CC) >= "328" .AND. Alltrim(SD3->D3_CC) <= "399"
     Case SD3->D3_TM $ "501|502" .And. Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. Alltrim(SD3->D3_CC) >= "320000" .AND. Alltrim(SD3->D3_CC) <= "329999"
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_CONDIR")
//ANT     Case SD3->D3_TM $ "501|502" .And. Alltrim(SD3->D3_GRUPO) $ "75|91|99" .And. Alltrim(SD3->D3_CC) >= "321" .AND. Alltrim(SD3->D3_CC) <= "399"
     Case SD3->D3_TM $ "501|502" .And. Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. Alltrim(SD3->D3_CC) >= "350000" .AND. Alltrim(SD3->D3_CC) <= "399999"
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_CONIND")
//ANT*     Case SD3->D3_TM $ "501|502" .And. Alltrim(SD3->D3_GRUPO) $ "75|91|99" .And. Alltrim(Substr(SD3->D3_CC,1,1)) $ '1|4|5|'
     Case SD3->D3_TM $ "501|502" .And. Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. Alltrim(Substr(SD3->D3_CC,1,1)) $ '4'

		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_GERAIS") //Alterado conforme instrução passada pelo Sr.Carlos em 05/06/2013
//ANT     Case SD3->D3_TM $ "501|502" .And. !Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. Alltrim(SD3->D3_CC) >= "321" .AND. Alltrim(SD3->D3_CC) <= "399"
     Case SD3->D3_TM $ "501|502" .And. !Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. Alltrim(SD3->D3_CC) >= "320000" .AND. Alltrim(SD3->D3_CC) <= "320999"
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_CONDIR")
     Case SD3->D3_TM $ "501|502" .And. !Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. Alltrim(SD3->D3_CC) >= "350000" .AND. Alltrim(SD3->D3_CC) <= "399999"
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_CONIND")


//ANT     Case SD3->D3_TM $ "501|502" .And. !Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. ((Alltrim(SD3->D3_CC) >= "101" .AND. Alltrim(SD3->D3_CC) <= "149").OR.;
     Case SD3->D3_TM $ "501|502" .And. !Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. ((Alltrim(SD3->D3_CC) >= "410000" .AND. Alltrim(SD3->D3_CC) <= "410999")) //.OR.;
//        (Alltrim(SD3->D3_CC) >= "401" .AND. Alltrim(SD3->D3_CC) <= "599"))
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_GERAIS")
	

//Inativado conforme instrucao do Sr.Mauri em alteracoes realizadas nas regras....
//Substituido pelas regras acima....
/*	
	Case SD3->D3_TM $ "001|005|501|502" .And. Alltrim(SD3->D3_GRUPO) $ "71|72" .And. Alltrim(SD3->D3_CC) >= "321" .AND. Alltrim(SD3->D3_CC) <= "349"
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_CONDIR")
		
	Case SD3->D3_TM $ "001|005|501|502" .And. Alltrim(SD3->D3_GRUPO) $ "75|91|99" .And. Alltrim(SD3->D3_CC) >= "301" .And. Alltrim(SD3->D3_CC) <= "399"
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_CONIND")
		
	Case SD3->D3_TM $ "001|005|501|502" .And. Alltrim(SD3->D3_GRUPO) $ "75|91|99" .And. !(Alltrim(SD3->D3_CC) >= "301" .AND. Alltrim(SD3->D3_CC) <= "399") // // Se for diferente.
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_GERAIS")
	
	Otherwise
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_ESTDIR")      */
EndCase                              

RestArea(aAreaAnt)
Return(_cRet) // Retorna a conta contabil.
  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para contabilizar o inventario...
//Implementado por Anesio G.Faria em 07-03-2012
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MASD3INV(cCod,cCC,cGrupo)

Local aAreaAnt := GetArea()
Local _cRet   := "FALTA CONTA NO PROD:"+Alltrim(cCod)
Local _cCod   := cCOD
Local _cCc    := cCC
Local _cGrupo := cGrupo

_cGrupo := Posicione("SB1",1,xFilial("SB1") + _cCod,"B1_GRUPO")
 
Do Case
//ANT	Case SD3->D3_TM $ "499|999" .And. Alltrim(SD3->D3_GRUPO) $ "71|72" .And. Alltrim(SD3->D3_CC) >= "321" .AND. Alltrim(SD3->D3_CC) <= "349"	
	Case SD3->D3_TM $ "499|999" .And. Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. Alltrim(SD3->D3_CC) >= "320000" .AND. Alltrim(SD3->D3_CC) <= "320999"
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_CONDIR")
//ANT	Case SD3->D3_TM $ "499|999" .And. Alltrim(SD3->D3_GRUPO) $ "75|91|99" .And. Alltrim(SD3->D3_CC) >= "301" .And. Alltrim(SD3->D3_CC) <= "399"		
	Case SD3->D3_TM $ "499|999" .And. Alltrim(SD3->D3_GRUPO) $ "71|72|75|91|99" .And. Alltrim(SD3->D3_CC) >= "350000" .And. Alltrim(SD3->D3_CC) <= "399999"
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_CONIND")
//ANT* 	Case SD3->D3_TM $ "499|999" .And. (Alltrim(SD3->D3_CC) < "301" .AND. Alltrim(SD3->D3_CC) > "399")// .And. Alltrim(SD3->D3_GRUPO) $ "75|91|99"  Se for diferente.		
	Case SD3->D3_TM $ "499|999" .And. (Alltrim(SD3->D3_CC) >= "410000")
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_GERAIS")
	
	Otherwise
//		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_ESTDIR")
		_cRet := Posicione("SB1",1,xFilial("SB1") + Alltrim(SD3->D3_COD),"B1_CONIND")		
EndCase                              

RestArea(aAreaAnt)
Return(_cRet) // Retorna a conta contabil.