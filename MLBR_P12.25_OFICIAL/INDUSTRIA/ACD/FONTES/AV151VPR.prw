#INCLUDE "TOTVS.CH" 
#INCLUDE "TOPCONN.CH" 

/////////////////////////////////////////////////////////////////////////////////
// Ponto de entrada para validar a leitura da etiqueta de Pallet Pnp1
// Antonio - 26/04/19
/////////////////////////////////////////////////////////////////////////////////

User Function AV151VPR()

Local aArea   := GetArea()
Local lRet    := .T.
Local cEtiqta := ParamixB
Local cProd   := ''
Local cPallet := ''
Local cSayNF  := ''
Local cSaySer := ''
Local cSayFor := ''
Local cSayLj  := ''
Local cQuery  := ''
Local cMA_EXCCQM := SuperGetMV('MA_EXCCQM',.F.,'066641','066642')    //EXCEÇÃO DE PRODUTOS QUE SÃO QUIMICOS, MAS DE OUTRO GRUPO DIFERENTE DE 12/14

If xFilial("CB0") == '09'         //Esta Rotina funcionará exclusivamente para PNP1

	CB0->(DbSetOrder(1))
	If CB0->(DbSeek(xFilial("CB0") + cEtiqta ))

		cProd    := CB0->CB0_CODPRO
		cPallet  := CB0->CB0_PALSZO
		cSayNF   := CB0->CB0_NFENT
		cSaySer  := CB0->CB0_SERIEE
		cSayFor  := CB0->CB0_FORNEC
		cSayLj   := CB0->CB0_LOJAFO	
		cLote    := CB0->CB0_LOTE
		dDtValid := CB0->CB0_DTVLD
		dDtrValid := CB0->CB0_DTRVLD

		SB1->(DbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1") + cProd ))

			If AllTrim(SB1->B1_GRUPO) $ '11-12-14' .OR. SB1->B1_COD $ cMA_EXCCQM         //11 -> COURO   (12-14) -> QUIMICOS

				If AllTrim(SB1->B1_GRUPO) $ '12-14' .OR. SB1->B1_COD $ cMA_EXCCQM        // (12-14) -> QUIMICOS

					If !Empty(dDtValid)         // alterado validacao para data validade dif. vazio, 12/14 nao controla lote - Diego
						If dDtValid < dDataBase

							If dDtRValid < dDataBase
								VTALERT("Produto com Data Validade Lote VENCIDO! Favor contactar o responsável, pois não será transferido!" ,"Aviso",.T.,,3)
								lRet := .F.
	
								cQuery := " UPDATE "+RetSqlName("SZO")+" "                     //volta a situação normal (2-Disponivel) pois na execução da 
								cQuery += " SET "                                              //transferencia, antes de entrar na PE ele altera a Situação para 
								cQuery += "      ZO_SITUACA    =  '" + '2'             + "' "  //3-Consumido - Antonio 06/08/19                              
								cQuery += "     ,ZO_DATAALT    =  '" + DtoS(dDataBase) + "' "
								cQuery += "     ,ZO_USUARIO    =  '" + RetCodUsr()     + "' " 
								cQuery += " WHERE   ZO_FILIAL  =  '" + xFilial('SZO')  + "' "
								cQuery += "     AND ZO_NFORI   =  '" + cSayNF          + "' "
								cQuery += "     AND ZO_SERIE   =  '" + cSaySer         + "' "
								cQuery += " 	AND ZO_CODFOR  =  '" + cSayFor         + "' "         
								cQuery += "     AND ZO_LJFOR   =  '" + cSayLj          + "' "
								cQuery += " 	AND ZO_NUMPLT  =  '" + cPallet         + "' "
								cQuery += " 	AND D_E_L_E_T_ <> '*' "
								TcSqlExec( cQuery )    
								RestArea(aArea)
	
								Return(lRet)                                                    // Antonio 06/08/19  

							EndIf

						EndIf

					EndIf

				EndIf
	
				cQuery := " SELECT * FROM "+RetSqlName("SZO")+" "
				cQuery += " WHERE   ZO_FILIAL  =  '" + xFilial('SZO')  + "' "
				cQuery += "     AND ZO_NFORI   =  '" + cSayNF          + "' "
				cQuery += "     AND ZO_SERIE   =  '" + cSaySer         + "' "
				cQuery += " 	AND ZO_CODFOR  =  '" + cSayFor         + "' "         
				cQuery += "     AND ZO_LJFOR   =  '" + cSayLj          + "' "
				cQuery += " 	AND ZO_NUMPLT  =  '" + cPallet         + "' "
				cQuery += " 	AND D_E_L_E_T_ <> '*' "
			
				If Select ('TMPSZO1') > 0
					DbSelectArea('TMPSZO1')
					DbCloseArea()
				EndIf
						
				DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TMPSZO1',.T.,.T.)
			
				If !TMPSZO1->(Eof())   
		
					If TMPSZO1->ZO_SITUACA <> "2" .And. TMPSZO1->ZO_SITUACA <> "5" //1-Analise/2-Disponivel/3-Consumido/4-Reprovado/5-Parcial/6-Devolvido

						VTALERT("Produto Encontra-se : "+IIf( TMPSZO1->ZO_SITUACA == '1',"em Analise", IIf( TMPSZO1->ZO_SITUACA == '3',"Consumido", IIf( TMPSZO1->ZO_SITUACA == '6',"Devolvido",'Reprovado'  ) ) ) ,"Aviso",.T.,,3)
						lRet := .F.
						RestArea(aArea)       // Antonio 06/08/19 
	                    Return(lRet)          // Antonio 06/08/19 
					Else
                                                                                              
						
						If !Empty(dDtValid) // alterado validacao para data validade dif. vazio, 12/14 nao controla lote - Diego
						
							If AllTrim(SB1->B1_GRUPO) $ '12-14' .OR. SB1->B1_COD $ cMA_EXCCQM             // (12-14) -> QUIMICOS

								//Query para CHECAR O FIFO Dos pallets
								cQuery := " SELECT * FROM "+RetSqlName("SZO")+" "
								cQuery += " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND D_E_L_E_T_ <> '*' AND " 
								cQuery += "       ZO_SITUACA IN('2','5')   AND "
								cQuery += "       ZO_PRODUTO = '"+cProd+"' AND "
								cQuery += "       ZO_RVALID <> ' '        AND "
								cQuery += "       ZO_RVALID > '"+DtoS(dDataBase)+"') AND "  //não pode estar vencido - Antonio 06/08/19 
								cQuery += "       ZO_NUMPLT <> '" + cPallet         + "' "
								cQuery += "       UNION ALL "
								cQuery := " SELECT * FROM "+RetSqlName("SZO")+" "
								cQuery += " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND D_E_L_E_T_ <> '*' AND " 
								cQuery += "       ZO_SITUACA IN('2','5')   AND "
								cQuery += "       ZO_PRODUTO = '"+cProd+"' AND "
								cQuery += "       ZO_DTVALID <> ' '        AND "
								cQuery += "       ZO_DTVALID < '"+DtoS(dDtValid) +"' AND "
								cQuery += "       ZO_DTVALID > '"+DtoS(dDataBase)+"' AND "  //não pode estar vencido - Antonio 06/08/19 
								cQuery += "       ZO_NUMPLT  <> '" + cPallet         + "' "
					
								If Select ('TMPSZO') > 0
									DbSelectArea('TMPSZO')
									DbCloseArea()
								EndIf
								
								DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TMPSZO',.T.,.T.)
								DbSelectArea("TMPSZO")
								DbGoTop()
							
		                        If TMPSZO->(!Eof())
		
									VTALERT("Existe produto com Data de Validade mais Antiga, favor obedecer o FIFO ! Pallet FIFO: "+ TMPSZO->ZO_NUMPLT + " Rua: " + TMPSZO->ZO_ENDERE,"Aviso",.T.,,3)

									cQuery := " UPDATE "+RetSqlName("SZO")+" "                     //volta a situação normal (2-Disponivel) pois na execução da 
									cQuery += " SET "                                              //transferencia, antes de entrar na PE ele altera a Situação para 
									cQuery += "      ZO_SITUACA    =  '" + '2'             + "' "  //3-Consumido - Antonio 06/08/19                               
									cQuery += "     ,ZO_DATAALT    =  '" + DtoS(dDataBase) + "' "
									cQuery += "     ,ZO_USUARIO    =  '" + RetCodUsr()     + "' " 
									cQuery += " WHERE   ZO_FILIAL  =  '" + xFilial('SZO')  + "' "
									cQuery += "     AND ZO_NFORI   =  '" + cSayNF          + "' "
									cQuery += "     AND ZO_SERIE   =  '" + cSaySer         + "' "
									cQuery += " 	AND ZO_CODFOR  =  '" + cSayFor         + "' "         
									cQuery += "     AND ZO_LJFOR   =  '" + cSayLj          + "' "
									cQuery += " 	AND ZO_NUMPLT  =  '" + cPallet         + "' "
									cQuery += " 	AND D_E_L_E_T_ <> '*' "
									TcSqlExec( cQuery )    

									lRet := .F.
									RestArea(aArea)      // Antonio 06/08/19

				                    Return(lRet)         // Antonio 06/08/19  
		
		    					Else
		
									cQuery := " UPDATE "+RetSqlName("SZO")+" "
									cQuery += " SET "
									cQuery += "      ZO_SITUACA    =  '" + '3'             + "' "                                
									cQuery += "     ,ZO_DATAALT    =  '" + DtoS(dDataBase) + "' "
									cQuery += "     ,ZO_USUARIO    =  '" + RetCodUsr()     + "' " 
									cQuery += "     ,ZO_SQTDEM2    =  0 " 
									cQuery += " WHERE   ZO_FILIAL  =  '" + xFilial('SZO')  + "' "
									cQuery += "     AND ZO_NFORI   =  '" + cSayNF          + "' "
									cQuery += "     AND ZO_SERIE   =  '" + cSaySer         + "' "
									cQuery += " 	AND ZO_CODFOR  =  '" + cSayFor         + "' "         
									cQuery += "     AND ZO_LJFOR   =  '" + cSayLj          + "' "
									cQuery += " 	AND ZO_NUMPLT  =  '" + cPallet         + "' "
									cQuery += " 	AND D_E_L_E_T_ <> '*' "
									TcSqlExec( cQuery )    
			
								EndIf

							Else

								cQuery := " UPDATE "+RetSqlName("SZO")+" "
								cQuery += " SET "
								cQuery += "      ZO_SITUACA    =  '" + '3'             + "' "                                
								cQuery += "     ,ZO_DATAALT    =  '" + DtoS(dDataBase) + "' "
								cQuery += "     ,ZO_USUARIO    =  '" + RetCodUsr()     + "' " 
								cQuery += "     ,ZO_SQTDEM2    =  0 " 
								cQuery += " WHERE   ZO_FILIAL  =  '" + xFilial('SZO')  + "' "
								cQuery += "     AND ZO_NFORI   =  '" + cSayNF          + "' "
								cQuery += "     AND ZO_SERIE   =  '" + cSaySer         + "' "
								cQuery += " 	AND ZO_CODFOR  =  '" + cSayFor         + "' "         
								cQuery += "     AND ZO_LJFOR   =  '" + cSayLj          + "' "
								cQuery += " 	AND ZO_NUMPLT  =  '" + cPallet         + "' "
								cQuery += " 	AND D_E_L_E_T_ <> '*' "
								TcSqlExec( cQuery )    
							
							Endif

                        Else

							cQuery := " UPDATE "+RetSqlName("SZO")+" "
							cQuery += " SET "
							cQuery += "      ZO_SITUACA    =  '" + '3'             + "' "                                
							cQuery += "     ,ZO_DATAALT    =  '" + DtoS(dDataBase) + "' "
							cQuery += "     ,ZO_USUARIO    =  '" + RetCodUsr()     + "' " 
							cQuery += "     ,ZO_SQTDEM2    =  0 " 
							cQuery += " WHERE   ZO_FILIAL  =  '" + xFilial('SZO')  + "' "
							cQuery += "     AND ZO_NFORI   =  '" + cSayNF          + "' "
							cQuery += "     AND ZO_SERIE   =  '" + cSaySer         + "' "
							cQuery += " 	AND ZO_CODFOR  =  '" + cSayFor         + "' "         
							cQuery += "     AND ZO_LJFOR   =  '" + cSayLj          + "' "
							cQuery += " 	AND ZO_NUMPLT  =  '" + cPallet         + "' "
							cQuery += " 	AND D_E_L_E_T_ <> '*' "
							TcSqlExec( cQuery )    

						EndIf

					EndIf

				EndIf
			
//			ElseIf Alltrim(SB1->B1_GRUPO) == '12' .OR. Alltrim(SB1->B1_GRUPO) == '14'         //QUIMICOS    (12-interno / 14-importação)
			
// 				///EXECUÇÃO DO QUIMICO - 21/05/19
			
			EndIf

		EndIf

	EndIf

EndIf

RestArea(aArea)

Return(lRet)
