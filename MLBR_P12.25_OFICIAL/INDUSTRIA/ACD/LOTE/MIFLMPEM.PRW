#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MIFLMPEM  ³ Autor ³ Antonio C Damaceno    ³ Data ³ 19/05/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ponto de Entrada. Lote Automatico MP e EM                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±      
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data    ³ Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Antonio       ³ 13/10/16 ³ Alterações na geração do lote               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß  

Regra para criação do Lote de materia prima:

AAMMXXXX - Exemplo para o ano de 2016: ]
16050001
AA    - Ano corrente: Dois ultimos digitos do Ano
MM    - Mes corrente: Dois digitos do Mes
XXXX - Sequencial a cada MP ou Embalagem para identificar varios lotes do mesmo produto para a mesma data.

Incluir o gatilho na entrada da MP ou Embalagem DO PRODUTO (D1_COD) disparando no LOTE(D1_LOTECTL), a rotina MIFLMPEM()
e criar o campo CB0->CB0_LOTEFO(LOTE DO FORNECEDOR) C 18

/*/                                 

User Function MIFLMPEM(nParam)

Local aAreaSD1  := SD1->(GetArea()) 
Local cProduto  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
Local cLocal    := aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOCAL"})

Local cLoteCtl  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOTECTL"})
Local cLoteFor  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOTEFOR"})

Local cLote     := ""
Local cLtAA     := ""
Local cLtSS     := ""
Local cLtMM     := ""
Local cLtNE     := ""
Local cQuery    := ""
Local cAliasSD1 := GetNextAlias()
Local cLtFilP2  := SuperGetMV("MV_LTFILP2",.F.,'08|19')
Local cLtGruP2  := SuperGetMV("MV_LTGRUP2",.F.,'16')

Local nFor

Default nParam := n

If !aCols[nParam,len(aHeader) + 1]                                  // Linha nao deletada

	SB1->(dbSetOrder(1)) // B1_FILIAL + B1_COD
	If SB1->(dbSeek(xFilial("SB1") + aCols[nParam, cProduto] )) 

		If cTipo $ 'NB' .AND. xFilial("SD1") $ cLtFilP2 .And. AllTrim(SB1->B1_GRUPO) == cLtGruP2   // Nota Normal e de Beneficiamento a principio
	                                                                                                // empresas 08 e Grupo 16 (ver Parametros)
//			If SB1->B1_TIPO $ 'MP/EM'
	
				If SB1->B1_RASTRO == 'L'
		
					cLtMM   := SubStr(DtoC(dDataBase),4,2)   //Dois digitos para o MES
					cLtAA   := SubStr(DtoC(dDataBase),9,2)   //Dois digitos para o ano
				
					If nParam == 1 
						cQuery := " SELECT MAX(SD1.D1_LOTECTL) LOTE "
						cQuery += "  FROM " + RetSqlName("SD1") + " SD1  "
						cQuery += "  WHERE SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND SD1.D_E_L_E_T_ = '  ' " 
						cQuery += "   AND SUBSTRING(SD1.D1_LOTECTL,1,4)<= '" + cLtAA+cLtMM + "' "
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.T.,.T.) 
						dbSelectArea(cAliasSD1)
						If (cAliasSD1)->(!Eof())
							If !Empty((cAliasSD1)->LOTE)
								If SubStr(DtoC(dDataBase),9,2) <> SubStr((cAliasSD1)->LOTE,1,2)
									cLtSS   := '0001' 
								Else
									cLtSS := SubStr((cAliasSD1)->LOTE,5,4)
									cLtSS := STRZERO(VAL(cLtSS)+1,4)
								EndIf
							Else
								cLtSS   := '0001' 
							EndIf
						Else                       
							cLtSS   := '0001'                       // Nr sequencial para identificar varios lotes do mesmo produto para a mesma data.
						EndIf
						(cAliasSD1)->(dbCloseArea() )
	
					Else

						For nFor := 1 To Len(aCols)
							If (!Empty(aCols[nFor, cLoteCtl]) .And. !aCols[nFor,len(aHeader) + 1])
								cLtSS := SubStr(aCols[nFor, cLoteCtl],5,4)
							EndIf
						Next

						If Empty(cLtSS)
							cQuery := " SELECT MAX(SD1.D1_LOTECTL) LOTE "
							cQuery += "  FROM " + RetSqlName("SD1") + " SD1  "
							cQuery += "  WHERE SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND SD1.D_E_L_E_T_ = '  ' " 
							cQuery += "   AND SUBSTRING(SD1.D1_LOTECTL,1,4)<= '" + cLtAA+cLtMM + "' "
							dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.T.,.T.) 
							dbSelectArea(cAliasSD1)
							If (cAliasSD1)->(!Eof())
								If !Empty((cAliasSD1)->LOTE)
									If SubStr(DtoC(dDataBase),9,2) <> SubStr((cAliasSD1)->LOTE,1,2)
										cLtSS   := '0001' 
									Else
										cLtSS := SubStr((cAliasSD1)->LOTE,5,4)
										cLtSS := STRZERO(VAL(cLtSS)+1,4)
									EndIf
								Else
									cLtSS   := '0001' 
								EndIf
							Else
								cLtSS   := '0001'                       // Nr sequencial para identificar varios lotes do mesmo produto para a mesma data.
							EndIf
							(cAliasSD1)->(dbCloseArea() )


						EndIf

                    EndIf

					SBZ->(dbSetOrder(1)) // BZ_FILIAL + BZ_COD
					If SBZ->(dbSeek(xFilial("SBZ") + aCols[nParam, cProduto] )) 

						//ENTRADAS DE MATERIAIS PARA COSTURA (GRP 16) - REGRA - B1_GRP=16 / BZ_ZZIMPET=S / BZ_ZZQEACD<>" "
	                    If SBZ->BZ_ZZIMPET == 'S' .AND. SBZ->BZ_ZZQEACD > 0
		                    aCols[nParam, cLoteFor] := cNFiscal //+ cSerie
						//ENTRADAS DE MATERIAIS PARA COSTURA (GRP 16) - REGRA - B1_GRP=16 / BZ_ZZIMPET=S / BZ_ZZQEACD=" "
	                    ElseIf SBZ->BZ_ZZIMPET == 'S' .AND. SBZ->BZ_ZZQEACD == 0
	                    	//Neste caso abre a tela dos romaneios e os lotes de fornecedores são digitados para cada linha digitada.
	                    EndIf

                    EndIf
	  		
					cLote  := cLtAA + cLtMM + cLtSS			

//					cLote  := 'LOTEINICIO'             
					                                   
					                                   
				EndIf
	
  //		EndIf
	
		EndIf

	EndIf

EndIf	

If FUNNAME() == "MATA140"
	oGetDados:oBrowse:Refresh()
Endif

RestArea(aAreaSD1)

Return(cLote)