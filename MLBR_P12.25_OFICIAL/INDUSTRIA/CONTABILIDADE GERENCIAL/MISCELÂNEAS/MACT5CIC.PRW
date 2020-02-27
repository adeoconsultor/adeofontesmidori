#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³  MACT5CIC.PRW   ºAutor³ Microsiga                  º Data ³ 21/01/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Retorna a sintaxe da funcao "POSICIONE()", nas linhas  C=Centro Custos,º±±
±±º         ³ I=Item Contabil e C=Classe de Valor. 									 º±±
±±º         ³ Ativado pelos gatilhos do campo CT5_DEBITO e CT5_CREDITO				 º±±
±±º         ³ Exemplo do retorno de um Item Contabil:								 º±±
±±º         ³ IIF(Posicione("CT1",1, xFilial("CT1")+"2130503", "CT1_CCOBRG") ;       º±±
±±º         ³ $ "1", SD1->D1_CC ," ")                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe  ³ CT5CIC(1,.T.) 		                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro³ CT5CIC(cCont, cLp, nTp) - Ativado atraves de gatilho		             º±±
±±º         ³ cConta = Conta contabil 							            		 º±±
±±º         ³ cLp = Lancamento Padrao em uso										 º±±
±±º         ³ cEntidade = Tipo do lançamento (1=CC, 2=Item, 3=Classe)   			 º±±
±±º         ³ nDebCre = Campo a carregar 1=DEBITO ou 2=CREDITO 						 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ Generico                                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  Programador  ³  Data   ³ Motivo da Alteracao                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º               ³         ³                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MACT5CIC(cConta, cLP, nEntidade, nDebCre)

Local _cAS := ""
Local _cRet

Local _aCC := {}
Local _aIT := {}
Local _aCL := {}

Local _cCusto
Local _cItem
Local _cClasse
Local _lCria   := .T.
Local aAreaAnt := GetArea()

DbselectArea("CTL")
DbSetOrder(1)
IF dbSeek(xFilial("CTL")+cLP)
	
	IF Substr(Alltrim(cConta),1,1) $ "1234567890"
		_cAS := '"'
	EndIF
	
	Do Case
		Case CTL->CTL_ALIAS $ "SD1/SF1"     // NOTAS FISCAIS DE ENTRADA
			aAdd(_aCC, {'SD1->D1_CC', ' '      })
			aAdd(_aIT, {'SD1->D1_ITEMCTA', ' ' })
			aAdd(_aCL, {'SD1->D1_CLVL',' '     })
			nDebCre := 1
			
		Case CTL->CTL_ALIAS $ "SD2/SF2"     // NOTAS FISCAIS DE SAIDA
			aAdd(_aCC, {'SD2->D2_CCUSTO',' ' })
			aAdd(_aIT, {'cFilAnt', ' '       })   //_cIT   := {'"CT1_ITOBRG"','SD2->D2_ITEMCC' }
			aAdd(_aCL, {'SD2->D2_CLVL', ' '  })
			nDebCre := 1
			
			
		Case CTL->CTL_ALIAS $ "SE1" .AND. cLP $ '500/501/502/505/544/545/546/555'  // CONTAS A RECEBER
			aAdd(_aCC, {'SE1->E1_CCD'      ,'SE1->E1_CCC'     })
			aAdd(_aIT, {'SE1->E1_FILORIG'  ,'SE1->E1_FILORIG' })   //_cIT   := {'SE2->E2_ITEMD'  ,'SE2->E2_ITEMC' }
			aAdd(_aCL, {'SE1->E1_CLVLDB'   ,'SE1->E1_CLVLCR'  })
			
			
		Case CTL->CTL_ALIAS $ "SE2" .AND. cLP $ '508/509/510/512/513/514/515/577/578/587/592/599'  // CONTAS A PAGAR
			aAdd(_aCC, {'SE2->E2_CCD'      ,'SE2->E2_CCC'     })
			aAdd(_aIT, {'SE2->E2_FILORIG'  ,'SE2->E2_FILORIG' })   //_cIT   := {'SE2->E2_ITEMD'  ,'SE2->E2_ITEMC' }
			aAdd(_aCL, {'SE2->E2_CLVLDB'   ,'SE2->E2_CLVLCR'  })
			
			
		Case CTL->CTL_ALIAS $ "SE5"   // MOVIMENTAÇÃO BANCARIA
			
			IF cLP $ '520/521/527/588/596'   // CONTAS A RECEBER - OK
				aAdd(_aCC, {'SE1->E1_CCD'     ,'SE1->E1_CCD'     })
				aAdd(_aIT, {'SE1->E1_FILORIG' ,'SE1->E1_FILORIG' })
				aAdd(_aCL, {'SE1->E1_CLVLDB'  ,'SE1->E1_CLVDB'   })
				
				
			ElseIF cLP $ '530/531/532/589/594/597'   // CONTAS A PAGAR - OK
				aAdd(_aCC, {'SE2->E2_CCD'     ,'SE2->E2_CCD'     })    // _cCC   := {'SE5->E5_CCD'    ,'SE5->E5_CCC'   }
				aAdd(_aIT, {'SE2->E2_FILORIG' ,'SE2->E2_FILORIG' })    // _cIT   := {'SE5->E5_ITEMD'  ,'SE5->E5_ITEMC' }
				aAdd(_aCL, {'SE2->E2_CLVLDB'  ,'SE2->E2_CLVDB'   })    // _cCL   := {'SE5->E5_CLVLDB' ,'SE5->E5_CLVCR' }
				
				
			ElseIF cLP $ '560/561/562/563/564/565'  // MOVIMENTAÇÃO BANCARIA - CAMPOS OBRIGATORIOS NO SE5
				aAdd(_aCC, {'SE5->E5_CCD'     ,'SE5->E5_CCD'     })
				aAdd(_aIT, {'SE5->E5_FILORIG' ,'SE5->E5_FILORIG' })
				aAdd(_aCL, {'SE5->E5_CLVLDB'  ,'SE5->E5_CLVDB'   })
				
			EndIf
			
			
		Case CTL->CTL_ALIAS $ "SEF" .AND. cLP $ '566/567/568/574/590/591'  // CHEQUES
			aAdd(_aCC, {'SEF->EF_CCD'      ,'SEF->EF_CCC'     })
			aAdd(_aIT, {'SEF->EF_PREFIXO'  ,'SEF->EF_PREFIXO' })   //_cIT   := {'SE2->E2_ITEMD'  ,'SE2->E2_ITEMC' }
			aAdd(_aCL, {'SEF->EF_CLVLDB'   ,'SEF->EF_CLVLCR'  })
			
					
		Case CTL->CTL_ALIAS $ "SEH"    .AND. cLP $ '580/582/585'  // APLICAÇÃO FINANCEIRA
			aAdd(_aCC, {'SEH->EH_CCD'     ,'SEH->EH_CCC'   })
			aAdd(_aIT, {'SEH->EH_ITEMD'   ,'SEH->EH_ITEMC' })
			aAdd(_aCL, {'SEH->EH_CLVLDB'  ,'SEH->EH_CLVLCR'})
			
			
		Case CTL->CTL_ALIAS $  "SEU"    .AND. cLP $ '572/573/579' // MOVIMENTO DO CAIXINHA
			aAdd(_aCC, {'SEU->EU_CCD'     ,'SEU->EU_CCC'   })
			aAdd(_aIT, {'SEU->EU_ITEMD'   ,'SEU->EU_ITEMC' })
			aAdd(_aCL, {'SEU->EU_CLVLDB'  ,'SEU->EU_CLVLCR'})
			
			
		Case CTL->CTL_ALIAS $ "SD3"      .AND. cLP $ '666/668/670/672'   // MOVIMENTAÇÃO DO ESTOQUE / ORDEM DE PRODUÇÃO
			aAdd(_aCC, {'SD3->D3_CC'      ,'SD3->D3_CC'      })
			aAdd(_aIT, {'SD3->D3_ITEMCTA' ,'SD3->D3_ITEMCTA' })
			aAdd(_aCL, {'SD3->D3_CLVL'    ,'SD3->D3_CLVL'	 })
			
			
		Case CTL->CTL_ALIAS $ "SET"         			// NAO ESTA SENDO USADO - MANUTENCAO CAIXINHA - TRANSFERENCIA DE NUMERARIO
			aAdd(_aCC, {'SET->ET_CCD'     ,'SET->ET_CCC'   })
			aAdd(_aIT, {'SET->ET_ITEMD'   ,'SET->ET_ITEMC' })
			aAdd(_aCL, {'SET->ET_CLVLDB'  ,'SET->ET_CLVLCR'}) 
			
		
		Case CTL->CTL_ALIAS $ "SN1/SN3"         			// ATIVO FIXO 
			aAdd(_aCC, {'SN3->N3_CUSTBEM' ,'SN3->N3_CCUSTO' })
			aAdd(_aIT, {'SN3->N3_FILIAL'  ,'SN3->N3_FILIAL' })
			aAdd(_aCL, {'SN3->N3_CLVLCON' ,'SN3->N3_CLVLCR'})
			
			
		OtherWise
			Alert("Rotina MACT5CIC não preparada para o Lançamento Padrão => "+cLp )
			_cRet := ' '
			RestArea(aAreaAnt)
			Return(_cRet)
			
	EndCase	// Cria o posicione() e retorna ao gatilho.
	
	_cRet := 'IIF(Posicione("CT1",1, xFilial("CT1")+'
	_cRet += Alltrim(_cAs)+ALLTRIM(cConta)+Alltrim(_cAs)+', '
	
	IF nEntidade == 1		  // 1=Centro de Custos
		_cRet += '"CT1_CCOBRG"' + ') $ "1", ' + _aCC[1,nDebCre]+ ' ," ")'
		
	ElseIF nEntidade == 2	  // 2=Item Contabil
		_cRet += '"CT1_ITOBRG"' + ') $ "1", ' + _aIT[1,nDebCre]+ ' ," ")'
		
	ElseIF nEntidade  == 3	  // 3=Classe de Valor
		_cRet += '"CT1_CLOBRG"' + ') $ "1", ' + _aCL[1,nDebCre]+ ' ," ")'
		
	EndIF
	
Else
	Alert("Lançamento Padrão => "+cLp+" não possui relacionamento Contabil")
	_cRet := ' '
	
Endif

// Valida tamanho do campo CT5 - regra CC / Item / Classe do lançamento padrão
If Len(_cRet) > 200
	Alert("Ver Tamanho da regra CC / Item / Classe do lançamento padrão => "+cLp)
	
Endif

RestArea(aAreaAnt)
Return(_cRet)
