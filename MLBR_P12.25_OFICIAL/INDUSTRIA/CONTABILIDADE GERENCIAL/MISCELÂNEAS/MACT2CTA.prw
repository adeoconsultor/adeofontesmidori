#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MACT2CTA º Autor ³ Sandro Albuquerque º Data ³  01/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retornar a conta contabil de acordo com a regra de centro  º±±
±±º          ³ de custos estabelecida pelo cliente.  					  º±±
±±º          ³ 															  º±±
±±º          ³ MACT2CTA => Funcao para retornar a conta contabil          º±±
±±º          ³       Lp => Lancamento PAdrao em uso.                      º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º   Uso    ³ PROTHEUS 10- Midori  									  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//
//
User Function MACT2CTA(cLP)

Local _cRet 	:= "FALTA CONTA "
Local _cGrupo
Local aAreaAnt 	:= GetArea()
Local _cCod 	:= ' '
Local _cCc  	:= ' '
Local _cEstoque := ' '
Local _cGrupo   := ' '
Local lMV_X_FTPRO
DbselectArea("CTL")
DbSetOrder(1)

IF dbSeek(xFilial("CTL")+cLP)
	
	IF CTL->CTL_ALIAS $ "SE2"
//ANT		If(Alltrim(SE2->E2_CCD) >= '300' .And. Alltrim(SE2->E2_CCD) <= '399')
		If(Alltrim(SE2->E2_CCD) >= '350000' .And. Alltrim(SE2->E2_CCD) <= '399999')
			_cRet :=  Posicione("SED",1,xFilial("SED")+SE2->E2_NATUREZ,"SED->ED_INDIRET")
		Else
			_cRet :=  Posicione("SED",1,xFilial("SED")+SE2->E2_NATUREZ,"SED->ED_GERAIS")
		Endif
		
	ElseIF CTL->CTL_ALIAS $ "SE5" .and. !cLp $ '562|563' // Movimentação bancaria Receber/Pagar e a origem do lancamento não for 562 nem 563
		//  Em 01/11/11 - Conforme usuario Mauri esse tipo de natureza deve retornar branco por nao saber a origem do lançamento
		IF Alltrim(SE5->E5_RECPAG) $ 'P' // Movimentação Bancaria a Pagar
			IF Alltrim(SE2->E2_ORIGEM) == "FINA050" .and. SE5->E5_NUMERO == SE2->E2_NUM  .and. cLP $ "530/532" .or. cLP $ "562"
//ANT			_cRet := IIf(AllTrim(SE2->E2_CCD) >= "300" .And. AllTrim(SE2->E2_CCD) <= "399" ,SED->ED_INDIRET ,SED->ED_GERAIS)
				_cRet := IIf(AllTrim(SE2->E2_CCD) >= "350000" .And. AllTrim(SE2->E2_CCD) <= "399999" ,SED->ED_INDIRET ,SED->ED_GERAIS)
			Else
				_cRet := SA2->A2_CONTA
				
			Endif
		Else
			IF Alltrim(SE5->E5_RECPAG) $ 'R' // Contas a Receber
				IF Alltrim(cLP) $ "563"  // Movimentação Bancaria a Receber
//ANT				_cRet := IIf(AllTrim(SE2->E2_CCD) >= "300" .And. AllTrim(SE2->E2_CCD) <= "399" ,SED->ED_INDIRET ,SED->ED_GERAIS)
					_cRet := IIf(AllTrim(SE2->E2_CCD) >= "350000" .And. AllTrim(SE2->E2_CCD) <= "399999" ,SED->ED_INDIRET ,SED->ED_GERAIS)
					if substr(_cRet,1,1) == space(1)
						_cRet := SED->ED_CONTA
					endif
					
				Else
					_cRet := SA1->A1_CONTA

				Endif
			Endif
		Endif 

	ElseIF CTL->CTL_ALIAS $ "SE5" .and. cLp $ '562|563' // Movimentação bancaria Receber/Pagar e a origem do lancamento for 562 ou 563
//ANT	_cRet := IIf(AllTrim(SE5->E5_CCD) >= "300" .And. AllTrim(SE5->E5_CCD) <= "399" ,SED->ED_INDIRET ,SED->ED_GERAIS)
		_cRet := IIf(AllTrim(SE5->E5_CCD) >= "350000" .And. AllTrim(SE5->E5_CCD) <= "399999" ,SED->ED_INDIRET ,SED->ED_GERAIS)
		      
	// Lançamento do Caixinha 	
	ElseIF CTL->CTL_ALIAS $ "SEU"
//ANT		IF (Alltrim(SEU->EU_CCD) >= '300' .And. Alltrim(SEU->EU_CCD) <= '399')
		IF (Alltrim(SEU->EU_CCD) >= '350000' .And. Alltrim(SEU->EU_CCD) <= '399999')
			_cRet :=  Posicione("SED",1,xFilial("SED")+SEU->EU_NATUREZ,"SED->ED_INDIRET")
			
		Else
			_cRet :=  Posicione("SED",1,xFilial("SED")+SEU->EU_NATUREZ,"SED->ED_GERAIS")
			
		Endif
		
	ElseIf CTL->CTL_ALIAS $ "SD1"  //  ITEM DA NOTA FISCAL DE ENTRADA
		_cRet 	    := SB1->B1_ESTDIR
		_cCod 	    := SB1->B1_COD
		_cCc  	    := SD1->D1_CC
		_cEstoque   := Alltrim(SF4->F4_ESTOQUE)
		_cGrupo     := Posicione("SB1",1,xFilial("SB1") + _cCod,"B1_GRUPO")
		_cPRDFrete  := GETMV("MV_X_FTPRO")
		_cTipo		:= SD1->D1_TIPO
        _cOrigLan	:= SD1->D1_ORIGLAN
		
		//INLCUIDO CONFORME SOLICITACAO HELPDESK 5336
		If Alltrim(_cTipo) $ "C" .And. Alltrim(_cOrigLan) $ ("FR") 
			_cRet := SB1->B1_CONTA     
		EndIf
		
		//A -  (quando o grupo = 93 e centro de custo = 301 a 399 = B1_CONIND) - CHAMADO 001229
//ANT		IF Alltrim(_cGrupo) $ "93" .And. Alltrim(_cCc) >= "301" .And. Alltrim(_cCc) <= "399"
		IF Alltrim(_cGrupo) $ "93" .And. Alltrim(_cCc) >= "350000" .And. Alltrim(_cCc) <= "399999"
			If _cEstoque == "N"
				_cRet := SB1->B1_CONIND
				
			Endif
		Endif
		
		//C - (quando grupo = 93 e produto (Frete) = 018777|018778 = B1_CONDIR)- Conforme parametro MV_X_FTPRO - CHAMADO 001229
		IF Alltrim(_cGrupo) $ "93" .And. Alltrim(SD1->D1_COD) $ Alltrim(_cPRDFrete) // Produto Frete
			If _cEstoque == "N"
				_cRet := SB1->B1_CONDIR
				
			Endif
		Endif
		
		//C - Caso a filial seja 01-Guarulhos ou 18-São Paulo
//ANT	IF Alltrim(_cGrupo) $ "93" .And. Alltrim(_cCc) >="400" //.And. cFilAnt $ "01|18" // Produto Frete
		IF Alltrim(_cGrupo) $ "93" .And. Alltrim(_cCc) >="400000" //.And. cFilAnt $ "01|18" // Produto Frete
			If _cEstoque == "N"
				_cRet := SB1->B1_GERAIS
				
			Endif
		Else
			Do Case
				
				//Chamado 03818 - (quando grupo = 95/96/97) - Solicitante Mauri
				Case Alltrim(_cGrupo) $ "96"
//ANT				IF Alltrim(_cCc) >= "321" .AND. Alltrim(_cCc) <= "327" .or. Alltrim(_cCc) >= "329" .AND. Alltrim(_cCc) <= "349"
					IF Alltrim(_cCc) >= "320000" .AND. Alltrim(_cCc) <= "320999" //.or. Alltrim(_cCc) >= "320700" .AND. Alltrim(_cCc) <= "360007"
						_cRet := SB1->B1_CONDIR

//ANT				ElseIF Alltrim(_cCc) $ "301|311|312|328" .or. Alltrim(_cCc) >= "351" .AND. Alltrim(_cCc) <= "399"						
					ElseIF Alltrim(_cCc) >= "350000" .AND. Alltrim(_cCc) <= "399999"
						_cRet := SB1->B1_CONIND

//ANT				ElseIF Alltrim(_cCc) $ "101|111|121|131|141" .or. Alltrim(_cCc) >= "401" .AND. Alltrim(_cCc) <= "599"						
					ElseIF Alltrim(_cCc) >= "410000" .AND. Alltrim(_cCc) <= "410999"
						_cRet := SB1->B1_GERAIS
						
					EndIf
				Case Alltrim(_cGrupo) $ "95|97"     // Até Chamado 03818 - Até aqui.
					_cRet := SB1->B1_GERAIS
					
				Case Alltrim(_cGrupo) $ "71|72|75|91|93|99|" .And. Alltrim(_cEstoque) == "S"  //incluido por Willer a pedido Carlos Aguiar 13/04/15
					_cRet := SB1->B1_CONTA	

//ANT			Case Alltrim(_cGrupo) $ "71|72" .And. Alltrim(_cCc) >= "321" .AND. Alltrim(_cCc) <= "327"					
				Case Alltrim(_cGrupo) $ "71|72|75|91|93|99|" .And. Alltrim(_cCc) >= "320000" .AND. Alltrim(_cCc) <= "320999"
					If _cEstoque == "N"
						_cRet := SB1->B1_CONDIR
					Endif
						
					//A -  (Quando o centro de custo = 301 a 399 = B1_CONIND) - CHAMADO 001229
//ANT			Case Alltrim(_cGrupo) $ "75/91/99" .And. Alltrim(_cCc) >= "301" .And. Alltrim(_cCc) <= "399"
				Case Alltrim(_cGrupo) $ "75/91/99/93" .And. Alltrim(_cCc) >= "350000" .And. Alltrim(_cCc) <= "399999"
					If _cEstoque == "N"
						_cRet := SB1->B1_CONIND
						
					Endif
					
					//B - (quando grupo = 93 e centro de custo # 301 a 399 = B1_GERAIS) - CHAMADO 001229
//ANT			Case Alltrim(_cGrupo) $ "75/91/99" .And. !(Alltrim(_cCc) >= "301" .AND. Alltrim(_cCc) <= "399")// Se for diferente.
				Case Alltrim(_cGrupo) $ "75/91/99" .And. !(Alltrim(_cCc) >= "320000" .AND. Alltrim(_cCc) <= "399999")// Se for diferente.
					If _cEstoque == "N"
						_cRet := SB1->B1_GERAIS
						
					Endif
					
					//D - (quando grupo = 94 = B1_TRANS) - CHAMADO 001229
				Case Alltrim(_cGrupo) $ "94"
					If _cEstoque == "N"
						_cRet := SB1->B1_TRANS
						
					Endif
			EndCase
		Endif
	//TESTAR NOTA FISCAL DE SAIDA
	ElseIf CTL->CTL_ALIAS $ "SD2"  //  ITEM DA NOTA FISCAL DE SAIDA
		_cRet 	    := SB1->B1_ESTDIR
		_cCod 	    := SB1->B1_COD
		_cCc  	    := SD2->D2_CCUSTO
		_cEstoque   := Alltrim(SF4->F4_ESTOQUE)
		_cGrupo     := Posicione("SB1",1,xFilial("SB1") + _cCod,"B1_GRUPO")
		_cPRDFrete  := GETMV("MV_X_FTPRO")
		
		//A -  (quando o grupo = 93 e centro de custo = 301 a 399 = B1_CONIND) - CHAMADO 001229
//ANT	IF Alltrim(_cGrupo) $ "93" .And. Alltrim(_cCc) >= "301" .And. Alltrim(_cCc) <= "399"
		IF Alltrim(_cGrupo) $ "93" .And. Alltrim(_cCc) >= "350000" .And. Alltrim(_cCc) <= "399999"
			If _cEstoque == "N"
				_cRet := SB1->B1_CONIND
				
			Endif
		Endif
		
		//C - (quando grupo = 93 e produto (Frete) = 018777|018778 = B1_CONDIR)- Conforme parametro MV_X_FTPRO - CHAMADO 001229
		IF Alltrim(_cGrupo) $ "93" .And. Alltrim(SD2->D2_COD) $ Alltrim(_cPRDFrete) // Produto Frete
			If _cEstoque == "N"
				_cRet := SB1->B1_CONDIR
				
			Endif
		Endif
		
		//C - Caso a filial seja 01-Guarulhos ou 18-São Paulo
//ANT	IF Alltrim(_cGrupo) $ "93" .And. Alltrim(_cCc) >="400" //.And. cFilAnt $ "01|18" // Produto Frete
		IF Alltrim(_cGrupo) $ "93" .And. Alltrim(_cCc) >="410000" //.And. cFilAnt $ "01|18" // Produto Frete
			If _cEstoque == "N"
				_cRet := SB1->B1_GERAIS
				
			Endif
		Else
			Do Case
				
				//Chamado 03818 - (quando grupo = 95/96/97) - Solicitante Mauri
				Case Alltrim(_cGrupo) $ "96"
//ANT				IF Alltrim(_cCc) >= "321" .AND. Alltrim(_cCc) <= "327" .or. Alltrim(_cCc) >= "329" .AND. Alltrim(_cCc) <= "349"
					IF Alltrim(_cCc) >= "320000" .AND. Alltrim(_cCc) <= "320999"  // .or. Alltrim(_cCc) >= "329" .AND. Alltrim(_cCc) <= "349"
						_cRet := SB1->B1_CONDIR
//ANT*				ElseIF Alltrim(_cCc) $ "301|311|312|328" .or. Alltrim(_cCc) >= "351" .AND. Alltrim(_cCc) <= "399"
					ElseIF Alltrim(_cCc) >= "350000" .AND. Alltrim(_cCc) <= "399999"
						_cRet := SB1->B1_CONIND
//ANT*				ElseIF Alltrim(_cCc) $ "101|111|121|131|141" .or. Alltrim(_cCc) >= "401" .AND. Alltrim(_cCc) <= "599"						
					ElseIF Alltrim(_cCc) >= "410000" .AND. Alltrim(_cCc) <= "410999"
						_cRet := SB1->B1_GERAIS
						
					Endif
					
				Case Alltrim(_cGrupo) $ "95|97"     // Até Chamado 03818 - Até aqui.
					_cRet := SB1->B1_GERAIS
//ANT*			Case Alltrim(_cGrupo) $ "71|72" .And. Alltrim(_cCc) >= "321" .AND. Alltrim(_cCc) <= "327"					
				Case Alltrim(_cGrupo) $ "71|72" .And. Alltrim(_cCc) >= "320000" .AND. Alltrim(_cCc) <= "320999"
					If 	 _cEstoque == "N"
							_cRet := SB1->B1_CONDIR
					Endif
					
					
					//A -  (Quando o centro de custo = 301 a 399 = B1_CONIND) - CHAMADO 001229
//ANT*				Case Alltrim(_cGrupo) $ "75/91/99" .And. Alltrim(_cCc) >= "301" .And. Alltrim(_cCc) <= "399"
				Case Alltrim(_cGrupo) $ "75/91/99" .And. Alltrim(_cCc) >= "350000" .And. Alltrim(_cCc) <= "399999"
					If _cEstoque == "N"
						_cRet := SB1->B1_CONIND
						
					Endif
					
					//B - (quando grupo = 93 e centro de custo # 301 a 399 = B1_GERAIS) - CHAMADO 001229
//ANT*			Case Alltrim(_cGrupo) $ "75/91/99" .And. !(Alltrim(_cCc) >= "301" .AND. Alltrim(_cCc) <= "399")// Se for diferente.
				Case Alltrim(_cGrupo) $ "75/91/99" .And. !(Alltrim(_cCc) >= "320000" .AND. Alltrim(_cCc) <= "399999")// Se for diferente.
					If _cEstoque == "N"
						_cRet := SB1->B1_GERAIS
						
					Endif
					
					//D - (quando grupo = 94 = B1_TRANS) - CHAMADO 001229
				Case Alltrim(_cGrupo) $ "94"
					If _cEstoque == "N"
						_cRet := SB1->B1_TRANS
						
					Endif
					
			EndCase
		Endif
		
		//FIM DAS NOTAS DE SAIDA
		
	Endif
Endif

IF Empty(_cRet) .And. CTL->CTL_ALIAS $ "SE2/SE5/SEU"
	_cRet := "VER NATUREZA "+SE5->E5_NATUREZ	
Endif
RestArea(aAreaAnt)
Return(_cRet) // Retorna a conta contabil.
                                          

//Função para contabilizar amostra/brinde/testes e bonificacao
//
user function AGMACT2(cLp, cSeq)
local _cCC 		:= ""
local _cConta 	:= ""

DbselectArea("CTL")
DbSetOrder(1)
IF dbSeek(xFilial("CTL")+cLP)
	IF CTL->CTL_ALIAS $ "SD2"
		_cCC := SD2->D2_CCUSTO

		if Substr(_cCC,1,3) = space(3)
			_cCC := Posicione("SC6", 1, xFilial("SC6")+SD2->(D2_PEDIDO+D2_ITEM+D2_COD),"C6_CCUSTO")
		endif

//ANT*	if _cCC >= '301' .and. _cCC <= '399'		
		if _cCC >= '320000' .and. _cCC <= '329999'
			if cSeq == "120"
				_cConta := "3521281"
			elseif 	cSeq == "121"
				_cConta := "3521193"
			else
				_cConta := "3521192"
			endif
		elseif _cCC >= '350000' .and. _cCC <= '399999'
			if cSeq == "120"
				_cConta := "3621281"
			elseif 	cSeq == "121"
				_cConta := "3621193"
			else
				_cConta := "3621192"
			endif
		else
			if cSeq == "120"
				_cConta := "4521281"
			elseif 	cSeq == "121"
				_cConta := "4521193"
			else
				_cConta := "4521192"
			endif
		endif
	endif
endif

return (_cConta)