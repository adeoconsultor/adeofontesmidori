#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MAPOSBCO º Autor ³ Sandro Albuquerque º Data ³  01/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retornar a conta contabil do banco de acordo com a regra   º±±
±±º          ³ estabelecida pelo cliente. 			 					  º±±
±±º          ³ 															  º±±
±±º          ³ MAPOSBCO -> Funcao para retornar a conta contabil do banco º±±
±±º          ³     cTab =  Tabela a ser pesquisada                        º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º   Uso    ³ PROTHEUS 10- Midori                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±            
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//
//
User Function MAPOSBCO(cLP)  // Posiciona na conta banco de acordo com o lançamento padronizado.

Local _cRet := ''
Local aAreaAnt := GetArea()

DbselectArea("CTL")
DbSetOrder(1)

IF dbSeek(xFilial("CTL")+cLP)
	
	IF CTL->CTL_ALIAS $ "SE1"    		// INCLUSAO DE TITULOS A RECEBER/ RA
		
		IF ALLTRIM(SE1->E1_TIPO) == "RA"
			DbselectArea("SE1")
			DbSetOrder(2)
			IF dbSeek( SE1->&(CTL->CTL_KEY) )
				_cRet := POSICIONE("SA6",1,XFILIAL("SE1")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,"A6_CONTA")
				IF Empty(_cRet)
					_cRet := "BANCO SEM CTA"
				Endif
			Endif                                                  
		Endif
		
	ELSEIF CTL->CTL_ALIAS $ "SE2"    		// INCLUSAO DE TITULOS A PAGAR / PA
		DbselectArea("SE5")
		DbSetOrder(7) //E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
		//DbSetOrder(2) //E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ
		              
		IF dbSeek( SE2->&(Alltrim(CTL->CTL_KEY)) )
			
			_cRet := POSICIONE("SA6",1,XFILIAL("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA,"A6_CONTA")
			IF Empty(_cRet)
				_cRet := "BANCO SEM CTA"
			Endif
		Endif
		
		
	ElseIF CTL->CTL_ALIAS $ "SE5"
		
		DbselectArea("SA6")
		DbSetOrder(1)
		IF dbSeek( xFilial("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA )
			_cRet := SA6->A6_CONTA
		Endif
		_cRet := POSICIONE("SA6",1,XFILIAL("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA,"SA6->A6_CONTA")
		IF Empty(_cRet)
			_cRet := "BANCO SEM CTA "
		Endif       
		
		
	ElseIF CTL->CTL_ALIAS $ "SEH"  	   // APLICACOES
		_cRet := POSICIONE("SA6",1,XFILIAL("SA6")+SEH->EH_BANCO+SEH->EH_AGENCIA+SEH->EH_CONTA,"A6_CONTA")
		
		IF Empty(_cRet)
			_cRet := "BCO APL SEM CTA"
		Endif
		
	ElseIF CTL->CTL_ALIAS $ "SEF" 	   // CHEQUES
		_cRet := POSICIONE("SA6",1,XFILIAL("SA6")+SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA,"SA6->A6_CONTA")
		IF Empty(_cRet)
			_cRet := "BCO CHQ SEM CTA"
		Endif
		
	EndIF
Endif
if Empty(_cRet)
	_cRet := '1110221'
endif
// Valida tamanho do campo CT5 para criacao da regra de CC / Item / Classe"
If Len(_cRet) > 150
	Alert("Verificar regra CC / Item / Classe do lançamento padrão => "+cLp)
Endif

RestArea(aAreaAnt)
Return(_cRet)
