#include "totvs.ch"   
//========================================================================================================
// Mta410Mnu - Alessandro Freire - OUTUBRO / 2015
//--------------------------------------------------------------------------------------------------------
// Descrição
// Adiciona a rotina de impressão de etiquetas no menú da mbrowse da pré nota
//--------------------------------------------------------------------------------------------------------
// Parametros
// nil
//--------------------------------------------------------------------------------------------------------
// Retorno
// nil
//========================================================================================================

USER FUNCTION MTA140MNU()
                  
AADD(aRotina,{ "Etiquetas Pré-Nota"       , "U_ETQACD"   , 0 , 3, 0, Nil})
AADD(aRotina,{ "Etiquetas Estoque "       , "U_MDRACD01" , 0 , 3, 0, Nil})
AADD(aRotina,{ "Rel.Conferência   "       , "U_MIDR0002" , 0 , 3, 0, Nil})
AADD(aRotina,{ "Imprime ETQ Couro PNP1"   , "U_ETQACDP1" , 0 , 3, 0, Nil})
AADD(aRotina,{ "Imprime ETQ Quimicos PNP1", "U_UETQAC2" , 0 , 3, 0, Nil})

Return( nil )

//========================================================================================================
// EtqAcd - Alessandro Freire - OUTUBRO / 2015
//--------------------------------------------------------------------------------------------------------
// Descrição
// Imprime as etiquetas da pré-nota de entrada
//--------------------------------------------------------------------------------------------------------
// Parametros
// nil
//--------------------------------------------------------------------------------------------------------
// Retorno
// nil
//========================================================================================================
User Function EtqAcd(oPlano,oParSN)                    

Local aArea      := GetArea()
Local aAreaSF1   := SF1->(GetArea())
Local cEstruCar  := ""
Local aEstruCar  := {}
Local axEstruCar := {}
Local cProduto   := ""
Local cLocApt    := ""
Local nI

dbSelectArea("CB0")
dbSetOrder(6)
DbSeek(xFilial("CB0")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
             
// VERIFICA SE A ETIQUETA TEM MOVIMENTOS
While CB0->(! Eof() .and. xFilial("CB0")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ==;
	CB0_FILIAL+CB0_NFENT+CB0_SERIEE+CB0_FORNEC+CB0_LOJAFO)

	If ! Empty( CB0->CB0_NUMSEQ )
		MsgInfo( "As etiquetas da Nota:"+SF1->F1_DOC+'-'+SF1->F1_SERIE+' '+;
				 SF1->F1_FORNECE+'-'+SF1->F1_LOJA+" tem registro de movimento interno. Impossível Imprimí-las" )
		RestArea( aArea )
		Return( nil )
	EndIf
		
	CB0->(dbSkip())

Enddo
	
// Se a etiqueta não tiver movimento, apaga
DbSeek(xFilial("CB0")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

While DbSeek(xFilial("CB0")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

    //CB0->(! Eof() .and. xFilial("CB0")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ==;
	//CB0_FILIAL+CB0_NFENT+CB0_SERIEE+CB0_FORNEC+CB0_LOJAFO)

	If CB0->CB0_XCARRI <> 'S'
		RecLock("CB0",.F.)
		dbDelete()
		MsUnlock()
	EndIf

	CB0->(dbSkip())             

Enddo
              
RestArea( aArea )
RestArea( aAreaSF1 )

//ACDI10NF(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,.T.,.F.)            //geram todas etiquetas do padrão do acd

//--------------------------------------------
// Impressão das Etiquetas
//--------------------------------------------

SD1->(dbSetOrder(1))
SD1->(dbGoTop(1))
SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA) )

While SD1->(! Eof()) .And. (xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ==;
	SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)

    SBZ->( dbSetOrder(1) )
    SBZ->( dbSeek( xFilial("SBZ") + SD1->D1_COD ) )
	nQtNaEtiq := SD1->D1_QUANT / SBZ->BZ_ZZQTCXA   //072215                 // quantidade na etiquetas

    SB1->( dbSetOrder(1) )
    SB1->( dbSeek( xFilial("SB1") + SD1->D1_COD ) )
        
	ExecBlock("IMG01",,,{nQtNaEtiq,,,(SD1->D1_QUANT/nQtNaEtiq),SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_LOCAL,,SD1->D1_NUMSEQ,SD1->D1_LOTECTL,SD1->D1_NUMLOTE,SD1->D1_DTVALID,,,,,,,,0,SD1->D1_ITEM,oPlano,oParSN})

	SD1->(dbSkip())
EndDo



DbSeek(xFilial("CB0")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
cLocApt:=CB0->CB0_LOCAL

	////////////momento em que ira gerar a etiqueta de kit(carrinho) caso seja carrinho(lectra) - antonio 05/06/18

	cQuery := " SELECT SD1.D1_COD, SD1.D1_QUANT "
	cQuery += "  FROM "+RetSqlName("SD1")+" SD1 "
	cQuery += " WHERE "
	cQuery += " 	SD1.D1_FILIAL  = '"+ xFilial("SD1")   + "' AND "
	cQuery += " 	SD1.D1_DOC     = '" + SF1->F1_DOC     + "' AND "
	cQuery += " 	SD1.D1_SERIE   = '" + SF1->F1_SERIE   + "' AND "
	cQuery += " 	SD1.D1_FORNECE = '" + SF1->F1_FORNECE + "' AND "
	cQuery += " 	SD1.D1_LOJA    = '" + SF1->F1_LOJA    + "' AND "
	cQuery += " 	SD1.D_E_L_E_T_ = '' "
	cQuery += " ORDER BY SD1.D1_COD "

	If Select('TMPD1') > 0
		dbSelectArea('TMPD1')
		TMPD1->(dbCloseArea())                            
	EndIf
		
	dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), 'TMPD1', .T.,.T.)

	While TMPD1->(!Eof())

		aAdd(aEstruCar,{AllTrim(TMPD1->D1_COD)+"','"})

		aAdd(axEstruCar,{TMPD1->D1_COD,TMPD1->D1_QUANT})

		nQtde := TMPD1->D1_QUANT

		TMPD1->(dbSkip())

	EndDo

	If Len(aEstruCar) > 0 
	
		cQuery := " SELECT SG1.G1_COD,B.B1_DESC, SG1.G1_COMP, A.B1_DESC, SG1.G1_UM, SG1.G1_QUANT "
		cQuery += "  FROM "+RetSqlName("SG1")+" SG1 "
		cQuery += " INNER JOIN "+RetSqlName("SB1")+"  A ON "
		cQuery += " 	A.B1_COD = SG1.G1_COMP "
		cQuery += " INNER JOIN "+RetSqlName("SB1")+"  B ON "
		cQuery += " 	B.B1_COD = SG1.G1_COD "
		cQuery += " INNER JOIN "+RetSqlName("SBZ")+"  BZ ON "
		cQuery += " 	BZ.BZ_COD = SG1.G1_COD AND BZ.BZ_XCARRI = 'S' "
		cQuery += " WHERE "
		cQuery += " 	SG1.G1_FILIAL = '"+xFilial("SG1")+"' AND "    //voltado o xfilial, pois em barbosa teremos estrutura q antes pegava a da filial 08
                                                                      //antonio 21/09/18
//		cQuery += " 	SG1.G1_FILIAL = '08' AND "    // SE pegarmos o xFilial, ele pegara a filial atual que não tem estrutura
                                                      // por isso esta chumbada a filial pq tem que buscar a estrutura na filial 08 (antonio)

		For nI := 1 to Len(aEstruCar)
		//			cQuery += " 	SG1.G1_COMP IN('059116','059117','059118','059119','059120','059125','071158','071160','071161','071162')  AND "
			cEstrucar += aEstruCar[nI,1]
		Next
		cQuery += " 	SG1.G1_COMP IN('" + cEstruCar + "')  AND "
		cQuery += " 	SG1.G1_FIM > '20170101' AND "
		cQuery += " 	SG1.D_E_L_E_T_ = '' "
		cQuery += " ORDER BY SG1.G1_COD, SG1.G1_COMP "

		If Select('TMPG1') > 0
			dbSelectArea('TMPG1')
			TMPG1->(dbCloseArea())                            
		EndIf
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), 'TMPG1', .T.,.T.)
		
		dbSelectArea('TMPG1')
		dbGotop()
		If !TMPG1->(Eof())
			cProduto:=TMPG1->G1_COD
		EndIf
            
		If !Empty(cProduto)

		    SBZ->( dbSetOrder(1) )
		    IF SBZ->( dbSeek( '08' + cProduto ) )            //esta chumbada a filial porque tem que buscar a estrutura na filial 08

				If MsgYesNo('Emitir etiqueta de Carrinho(Kit) (S/N)?' )
		
				    //--------------------------------------------
				    // Impressão das Etiquetas de kit (carrinho)
				    //--------------------------------------------        
				    SB1->( dbSetOrder(1) )
				    SB1->( dbSeek( xFilial("SB1") + cProduto ) )

//					cLocApt := SB1->B1_LOCPAD    //'01'    //usado somente para teste (verificar se posso buscar o armazem padrão MSMO)
                                                           //Confirmado com Thiago, buscar o armazem do que foi informado na nf de transferencia.(antonio)
				 	aParam    := {}                  
//					nQtOpEtiq := SBZ->BZ_ZZQTPRD  / nQtde             //072215
					nQtOpEtiq := SBZ->BZ_ZZQTPRD  / SBZ->BZ_ZZQEACD   //072215                 // quantidade de etiquetas
					AAdd( aParam, SBZ->BZ_ZZQTPRD / nQtOpEtiq   )                              // quantidade por etiqueta
					AAdd( aParam, nil           	) // Codigo do separador
					AAdd( aParam, nil           	) // Código da etiqueta, no caso de uma reimpressão
					AAdd( aParam, nQtOpEtiq         ) // Quantidade de etiquetas
					AAdd( aParam, SF1->F1_DOC     	) // nota de entrada
					AAdd( aParam, SF1->F1_SERIE    	) // Serie da nota de entrada
					AAdd( aParam, SF1->F1_FORNECE 	) // Codigo do fornecedor da nota de entrada
					AAdd( aParam, SF1->F1_LOJA 		) // Loja do fornecedor da nota de entrada
					AAdd( aParam, cLocApt       	) // Armazem
					AAdd( aParam, nil           	) // Numero da OP
					AAdd( aParam, nil           	) // Numero sequencial da etiqueta quando for reimpressao
					AAdd( aParam, If(SB1->B1_RASTRO=="L", NIL, nil ) ) // Numero do Lote. Neste caso deve ser o mesmo numero da OP
					AAdd( aParam, nil          		) // Sublote
					AAdd( aParam, nil           	) // Data de Validade
					AAdd( aParam, nil           	) // Centro de Custos
					AAdd( aParam, cLocApt       	) // Local de Origem
					AAdd( aParam, nil           	) // Local cOPREQ    := If(len(paramixb) >=17,paramixb[17],NIL)
					AAdd( aParam, nil           	) // Local cNumSerie := If(len(paramixb) >=18,paramixb[18],NIL)
					AAdd( aParam, nil           	) // Local cOrigem   := If(len(paramixb) >=19,paramixb[19],NIL)
					AAdd( aParam, nil           	) // Local cEndereco := If(len(paramixb) >=20,paramixb[20],NIL)
					AAdd( aParam, nil           	) // Local cPedido   := If(len(paramixb) >=21,paramixb[21],NIL)
					AAdd( aParam, 0             	) // Local nResto    := If(len(paramixb) >=22,paramixb[22],0)
					AAdd( aParam, nil           	) // Local cItNFE    := If(len(paramixb) >=23,paramixb[23],NIL)            
					AAdd( aParam, oPlano           	) // Plano Transf.Fil - Midori   := If(len(paramixb) >=24,paramixb[24],NIL)            
					AAdd( aParam, oParSN           	) // Conferencia Etiqueta   := If(len(paramixb) >=25,paramixb[25],NIL)            
		            
					If SX6->(dbSeek(xFilial("CB0")+'MV_NUMKIT' ))
						RecLock('SX6', .F.)
						nCONTEUDO:=VAL(SX6->X6_CONTEUD)+1
						cConteudo:=Alltrim(str(nCONTEUDO))
						SX6->X6_CONTEUD := cConteudo
						MsUnlock()
					EndIf

					ExecBlock("IMG11",,,aParam )               	

				EndIf

			EndIf

		EndIf

  	EndIf
	
////////////momento em que ira gerar a etiqueta de kit(carrinho) caso seja carrinho(lectra) - antonio 05/06/18

Return( nil )




//========================================================================================================
// EtqAcdP1 - Antonio Carlos Damaceno - maio / 2019
//--------------------------------------------------------------------------------------------------------
// Descrição
// Imprime as etiquetas da pré-nota de entrada (pnp1) etiquetas de pallet de Couro
//--------------------------------------------------------------------------------------------------------
// Parametros
// nil
//--------------------------------------------------------------------------------------------------------
// Retorno
// nil
//========================================================================================================
User Function ETQACDP1()                    

	Local aArea    := GetArea()
	Local cProduto := ""
	Local cLocApt  := ""
	Local cEndere  := '  '
	Local cPallet  := ""
	Local oPerg

	Private cPerg    := "ETQACDP1"

	oPerg := AdvplPerg():New( cPerg )

/*	oPerg:AddPerg( "Nota Fiscal De..,: " , "C", 6 , )
	oPerg:AddPerg( "Nota Fiscal Até..: " , "C", 6 , )
	oPerg:AddPerg( "Pallet...........: " , "C", 20, )
	oPerg:SetPerg()
 
	Pergunte( cPerg , .T.)
	
	cNotaDe   := MV_PAR01
	cSerieDe  := MV_PAR02
	cNotaAte  := MV_PAR03
	cSerieAte := MV_PAR04
	cPallet   := MV_PAR05

	SD1->(dbSetOrder(1))
	SD1->(DbSeek(xFilial("SD1")+cNotaDe+cSerieDe) )*/

	oPerg:AddPerg( "Endereço..: " , "C", 02, )
	oPerg:AddPerg( "Pallet....: " , "C", 14, )
	oPerg:SetPerg()
 
	Pergunte( cPerg , .T.)
	
	cEndere := MV_PAR01
	cPallet := MV_PAR02

	SD1->(dbSetOrder(1))
	SD1->(dbGoTop(1))
	SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA) )
	
	If (xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ==;
		SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)

        cLocApt:= SD1->D1_LOCAL

		CB0->(dbSetOrder(6))
		If CB0->( DbSeek (xFilial("CB0")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ))

			While (CB0->CB0_NFENT + CB0->CB0_SERIEE + CB0->CB0_FORNEC + CB0->CB0_LOJAFO) == (SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

				If !Empty(cPallet)
					If cPallet <> CB0->CB0_PALSZO
						CB0->(dbSkip())
						Loop
					EndIf
				EndIf

				nqtde 	 := CB0->CB0_QTDE
				cCodSep  := CB0->CB0_USUARIO
				cCodId   := CB0->CB0_CODETI
				cNFEnt   := CB0->CB0_NFENT
				cSeriee  := CB0->CB0_SERIEE
				cFornec  := CB0->CB0_FORNEC
				cLojafo  := CB0->CB0_LOJAFO
				cArmazem := CB0->CB0_LOCAL
				cOP      := CB0->CB0_OP
				cNumSeq  := CB0->CB0_NUMSEQ
				cLote    := CB0->CB0_LOTE
				dValid   := CB0->CB0_DTVLD
				cSLote   := CB0->CB0_SLOTE
				cCC      := CB0->CB0_CC
				cLocOri  := CB0->CB0_LOCORI
				cOPReq	 := CB0->CB0_OPREQ
				cNumserie:= CB0->CB0_NUMSER		
				cOrigem  := CB0->CB0_ORIGEM
				cEndereco:= CB0->CB0_LOCALI
				cPedido  := CB0->CB0_PEDCOM
				cItNFE 	 := CB0->CB0_ITNFE
				cNumPlt  := CB0->CB0_PALSZO
				cLoteFor := CB0->CB0_LOTEFO

			    SB1->( dbSetOrder(1) )
			    SB1->( dbSeek( xFilial("SB1") + CB0->CB0_CODPRO ) )

				IF (AllTrim(SB1->B1_GRUPO) $ '11')                    //produtos couro

				                  //       1   2  3       4                       5            6             7               8            9          10    11            12               13             14            15     16     17 18 19 20 21 22    23    24          25             26      27
					ExecBlock("IMG12",,,{nQtde,,cCodId   ,1                    ,cNFEnt     ,cSeriee      ,cFornec        ,cLojafo     ,cArmazem     ,cOp,cNumSeq       ,cLote          ,cSLote         ,dValid         , , cArmazem ,  ,  ,  ,  ,  , 0 ,cItNFE,cNumPlt,CB0->CB0_CODPRO , cLotefor, ''   })
	
					cQuery := " UPDATE "+RetSqlName("SZO")+" "
					cQuery += " SET ZO_SITUACA     =  '1' "                                
					cQuery += "    ,ZO_ENDERE      =  '" + cEndere         + "' "                                
					cQuery += "    ,ZO_DATAALT     =  '" + DtoS(dDataBase) + "' "
					cQuery += "    ,ZO_USUARIO     =  '" + RetCodUsr()     + "' " 
					cQuery += " WHERE   ZO_FILIAL  =  '" + xFilial('SZO')  + "' "
					cQuery += "     AND ZO_NFORI   =  '" + cNFEnt          + "' "
					cQuery += "     AND ZO_SERIE   =  '" + cSeriee         + "' "
					cQuery += " 	AND ZO_CODFOR  =  '" + cFornec         + "' "         
					cQuery += "     AND ZO_LJFOR   =  '" + cLojafo         + "' "
					cQuery += " 	AND ZO_NUMPLT  =  '" + cNumPlt         + "' "
	//				cQuery += " 	AND ZO_SITUACA =  '  ' "
					cQuery += " 	AND D_E_L_E_T_ <> '*' "
					TcSqlExec( cQuery )

	            Else

					MsgInfo("Produto não pertence ao grupo 11 Couro - Produto:" +SB1->B1_COD + " Grupo: " + SB1->B1_GRUPO,"Atenção","Gerar e Imprimir Etiquetas dos Produtos Couro")
	            
	            EndIf

				CB0->(dbSkip())

			EndDo

		Else

			cQuery := " SELECT * FROM "+RetSqlName("SZO")+" "
			cQuery += " WHERE   ZO_FILIAL  =  '" + xFilial('SZO')   + "' "
			cQuery += "     AND ZO_NFORI   =  '" + SF1->F1_DOC      + "' "
			cQuery += "     AND ZO_SERIE   =  '" + SF1->F1_SERIE    + "' "
			cQuery += " 	AND ZO_CODFOR  =  '" + SF1->F1_FORNECE  + "' "         
			cQuery += "     AND ZO_LJFOR   =  '" + SF1->F1_LOJA     + "' "
			If !Empty(cPallet)
				cQuery += " AND ZO_NUMPLT  =  '" + cPallet          + "' "
			EndIf
			cQuery += " 	AND D_E_L_E_T_ <> '*' "
		
			If Select ('TMPSZO') > 0
				DbSelectArea('TMPSZO')
				DbCloseArea()
			EndIf
					
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TMPSZO',.T.,.T.)

			While !TMPSZO->(Eof())   
		
			    SB1->( dbSetOrder(1) )
			    SB1->( dbSeek( xFilial("SB1") + TMPSZO->ZO_PRODUTO ) )

				IF (AllTrim(SB1->B1_GRUPO) $ '11')        //produtos couro

				 	aParam    := {}                  
					nQtOpEtiq := 1                      
					AAdd( aParam, TMPSZO->ZO_QTDEM2 ) // quantidade da etiqueta                                          1
					AAdd( aParam, nil               ) // Codigo do separador                                             2
					AAdd( aParam, nil               ) // Código da etiqueta, no caso de uma reimpressão                  3
					AAdd( aParam, nQtOpEtiq         ) // Quantidade de etiquetas                                         4
					AAdd( aParam, TMPSZO->ZO_NFORI  ) // nota de entrada                                                 5
					AAdd( aParam, TMPSZO->ZO_SERIE  ) // Serie da nota de entrada                                        6
					AAdd( aParam, TMPSZO->ZO_CODFOR ) // Codigo do fornecedor da nota de entrada                         7
					AAdd( aParam, TMPSZO->ZO_LJFOR  ) // Loja do fornecedor da nota de entrada                           8
					AAdd( aParam, cLocApt           ) // Armazem                                                         9
					AAdd( aParam, nil               ) // Numero da OP                                                   10
					AAdd( aParam, nil               ) // Numero sequencial da etiqueta quando for reimpressao           11
					AAdd( aParam, If(SB1->B1_RASTRO=="L", TMPSZO->ZO_NUMLOTE, nil ) )   //lote                          12
					AAdd( aParam, nil               ) // Sublote                                                        13
//					AAdd( aParam, If(SB1->B1_RASTRO=="L", /*dDataBase+1824*/ TMPSZO->ZO_DTVALID    , nil ) )   // Data de Validade            14
					AAdd( aParam, /*dDataBase+1824*/ StoD(TMPSZO->ZO_DTVALID)     )   // Data de Validade            14
					AAdd( aParam, nil               ) // Centro de Custos                                               15
					AAdd( aParam, cLocApt           ) // Local de Origem                                                16
					AAdd( aParam, nil               ) // Local cOPREQ    := If(len(paramixb) >=17,paramixb[17],NIL)     17
					AAdd( aParam, nil               ) // Local cNumSerie := If(len(paramixb) >=18,paramixb[18],NIL)     18
					AAdd( aParam, nil               ) // Local cOrigem   := If(len(paramixb) >=19,paramixb[19],NIL)     19
					AAdd( aParam, nil               ) // Local cEndereco := If(len(paramixb) >=20,paramixb[20],NIL)     20
					AAdd( aParam, nil               ) // Local cPedido   := If(len(paramixb) >=21,paramixb[21],NIL)     21
					AAdd( aParam, 0                 ) // Local nResto    := If(len(paramixb) >=22,paramixb[22],0)       22
					AAdd( aParam, nil               ) // Local cItNFE    := If(len(paramixb) >=23,paramixb[23],NIL)     23   
					AAdd( aParam, TMPSZO->ZO_NUMPLT ) // Local cPallet   := If(len(paramixb) >=24,paramixb[24],"")      24       
					AAdd( aParam, TMPSZO->ZO_PRODUTO) // Local           := If(len(paramixb) >=24,paramixb[24],"")      25       
					AAdd( aParam, TMPSZO->ZO_NUMLOTE) // Local           := If(len(paramixb) >=24,paramixb[24],"") 		26       
					AAdd( aParam, nil) // Local           := If(len(paramixb) >=24,paramixb[24],"")      				27       
	
					ExecBlock("IMG12",,,aParam )               	
	
					cQuery := " UPDATE "+RetSqlName("SZO")+" "
					cQuery += " SET ZO_SITUACA     =  '1' "                                
					cQuery += "    ,ZO_ENDERE      =  '" + cEndere           + "' "                                
					cQuery += "    ,ZO_DATAALT     =  '" + DtoS(dDataBase)   + "' "
					cQuery += "    ,ZO_USUARIO     =  '" + RetCodUsr()       + "' " 
					cQuery += " WHERE   ZO_FILIAL  =  '" + xFilial('SZO')    + "' "
					cQuery += "     AND ZO_NFORI   =  '" + TMPSZO->ZO_NFORI  + "' "
					cQuery += "     AND ZO_SERIE   =  '" + TMPSZO->ZO_SERIE  + "' "
					cQuery += " 	AND ZO_CODFOR  =  '" + TMPSZO->ZO_CODFOR + "' "         
					cQuery += "     AND ZO_LJFOR   =  '" + TMPSZO->ZO_LJFOR  + "' "
					cQuery += " 	AND ZO_NUMPLT  =  '" + TMPSZO->ZO_NUMPLT + "' "
	//				cQuery += " 	AND ZO_SITUACA =  '  ' "
					cQuery += " 	AND D_E_L_E_T_ <> '*' "
					TcSqlExec( cQuery )

	            Else

					MsgInfo("Produto não pertence ao grupo 11 Couro - Produto:" +SB1->B1_COD + " Grupo: " + SB1->B1_GRUPO,"Atenção","Gerar e Imprimir Etiquetas dos Produtos Couro")
	            
	            EndIf
	            
				TMPSZO->(dbSkip())

			EndDo
		
		EndIf

	EndIf

Return( nil )





//========================================================================================================
// UETQAC2 - Antonio Carlos Damaceno - maio / 2019
//--------------------------------------------------------------------------------------------------------
// Descrição
// Imprime as etiquetas da pré-nota de entrada (pnp1) etiquetas de pallet de quimicos
//--------------------------------------------------------------------------------------------------------
// Parametros
// nil
//--------------------------------------------------------------------------------------------------------
// Retorno
// nil
//========================================================================================================
User Function UETQAC2()                    

	Local aArea    := GetArea()
	Local cProduto := ""
	Local cLocApt  := ""
	Local cEndere  := '  '
	Local cPallet  := ""
	Local oPerg

	Private cPerg    := "UETQAC2"

	oPerg := AdvplPerg():New( cPerg )

//	oPerg:AddPerg( "Nota Fiscal De...: " , "C", 09 , )
//	oPerg:AddPerg( "Nota Fiscal Até..: " , "C", 09 , )
//	oPerg:AddPerg( "Serie De.........: " , "C", 03 , )
//	oPerg:AddPerg( "Serie Até........: " , "C", 03 , )

	oPerg:AddPerg( "Endereço.........: " , "C", 02 , )
	oPerg:AddPerg( "Pallet...........: " , "C", 14 , )
	oPerg:SetPerg()
 
	Pergunte( cPerg , .T.)
	
//	cNotaDe   := MV_PAR01
//	cSerieDe  := MV_PAR02
//	cNotaAte  := MV_PAR03
//	cSerieAte := MV_PAR04
	cEndere   := MV_PAR01
	cPallet   := MV_PAR02

	SD1->(dbSetOrder(1))
	SD1->(dbGoTop(1))
	SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA) )
	
	If (xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ==;
		SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)

        cLocApt:= SD1->D1_LOCAL

		CB0->(dbSetOrder(6))
		If CB0->( DbSeek (xFilial("CB0")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ))

			While (CB0->CB0_NFENT + CB0->CB0_SERIEE + CB0->CB0_FORNEC + CB0->CB0_LOJAFO) == (SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

				If !Empty(cPallet)
					If cPallet <> CB0->CB0_PALSZO
						CB0->(dbSkip())
						Loop
					EndIf
				EndIf

				nqtde 	 := CB0->CB0_QTDE
				cCodSep  := CB0->CB0_USUARIO
				cCodId   := CB0->CB0_CODETI
				cNFEnt   := CB0->CB0_NFENT
				cSeriee  := CB0->CB0_SERIEE
				cFornec  := CB0->CB0_FORNEC
				cLojafo  := CB0->CB0_LOJAFO
				cArmazem := CB0->CB0_LOCAL
				cOP      := CB0->CB0_OP
				cNumSeq  := CB0->CB0_NUMSEQ
				cLote    := CB0->CB0_LOTE
				dValid   := CB0->CB0_DTVLD
				cSLote   := CB0->CB0_SLOTE
				cCC      := CB0->CB0_CC
				cLocOri  := CB0->CB0_LOCORI
				cOPReq	 := CB0->CB0_OPREQ
				cNumserie:= CB0->CB0_NUMSER		
				cOrigem  := CB0->CB0_ORIGEM
				cEndereco:= CB0->CB0_LOCALI
				cPedido  := CB0->CB0_PEDCOM
				cItNFE 	 := CB0->CB0_ITNFE
				cNumPlt  := CB0->CB0_PALSZO
				cLoteFor := CB0->CB0_LOTEFO            //LOTE DO FORNECEDOR

			    SB1->( dbSetOrder(1) )
			    SB1->( dbSeek( xFilial("SB1") + CB0->CB0_CODPRO ) )

				IF (AllTrim(SB1->B1_GRUPO) $ '12-14')                    //produtos quimicos
				                  //       1   2  3       4                       5            6             7               8            9          10    11            12               13             14            15     16     17 18 19 20 21 22    23    24          25           26     27
					ExecBlock("IMG12",,,{nQtde,,cCodId   ,1                    ,cNFEnt     ,cSeriee      ,cFornec        ,cLojafo     ,cArmazem     ,cOp,cNumSeq       ,cLote          ,cSLote         ,dValid         , , cArmazem ,  ,  ,  ,  ,  , 0 ,cItNFE,cNumPlt,CB0->CB0_CODPRO,cLoteFor,'' })
	
					cQuery := " UPDATE "+RetSqlName("SZO")+" "
					cQuery += " SET ZO_SITUACA    =  '1' "                                
					cQuery += "    ,ZO_ENDERE     =   '" + cEndere        + "' "                                
					cQuery += "     ,ZO_DATAALT    =  '" + DtoS(dDataBase) + "' "
					cQuery += "     ,ZO_USUARIO    =  '" + RetCodUsr()     + "' " 
					cQuery += " WHERE   ZO_FILIAL  =  '" + xFilial('SZO') + "' "
					cQuery += "     AND ZO_NFORI   =  '" + cNFEnt   + "' "
					cQuery += "     AND ZO_SERIE   =  '" + cSeriee  + "' "
					cQuery += " 	AND ZO_CODFOR  =  '" + cFornec  + "' "         
					cQuery += "     AND ZO_LJFOR   =  '" + cLojafo  + "' "
					cQuery += " 	AND ZO_NUMPLT  =  '" + cNumPlt  + "' "
					cQuery += " 	AND D_E_L_E_T_ <> '*' "
					TcSqlExec( cQuery )
	
	            Else

					MsgInfo("Produto não pertence ao grupo 12/14 Químicos - Produto:" +SB1->B1_COD + " Grupo: " + SB1->B1_GRUPO,"Atenção","Gerar e Imprimir Etiquetas dos Produtos Químicos")
	            
	            EndIf

				CB0->(dbSkip())

			EndDo

		Else

			cQuery := " SELECT * FROM "+RetSqlName("SZO")+" "
			cQuery += " WHERE   ZO_FILIAL  =  '" + xFilial('SZO')   + "' "
			cQuery += "     AND ZO_NFORI   =  '" + SF1->F1_DOC      + "' "
			cQuery += "     AND ZO_SERIE   =  '" + SF1->F1_SERIE    + "' "
			cQuery += " 	AND ZO_CODFOR  =  '" + SF1->F1_FORNECE  + "' "         
			cQuery += "     AND ZO_LJFOR   =  '" + SF1->F1_LOJA     + "' "
			If !Empty(cPallet)
				cQuery += " AND ZO_NUMPLT  =  '" + cPallet          + "' "
			EndIf
			cQuery += " 	AND D_E_L_E_T_ <> '*' "
		
			If Select ('TMPSZO') > 0
				DbSelectArea('TMPSZO')
				DbCloseArea()
			EndIf
					
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TMPSZO',.T.,.T.)

			While !TMPSZO->(Eof())   
		
			    SB1->( dbSetOrder(1) )
			    SB1->( dbSeek( xFilial("SB1") + TMPSZO->ZO_PRODUTO ) )

				IF (AllTrim(SB1->B1_GRUPO) $ '12-14')        //produtos quimicos

				 	aParam    := {}                  
					nQtOpEtiq := 1                      
					AAdd( aParam, TMPSZO->ZO_QTDEM2  ) // quantidade da etiqueta                                              1
					AAdd( aParam, nil                ) // Codigo do separador                                                 2
					AAdd( aParam, nil                ) // Código da etiqueta, no caso de uma reimpressão                      3
					AAdd( aParam, nQtOpEtiq          ) // Quantidade de etiquetas                                             4
					AAdd( aParam, TMPSZO->ZO_NFORI   ) // nota de entrada                                                     5
					AAdd( aParam, TMPSZO->ZO_SERIE   ) // Serie da nota de entrada                                            6
					AAdd( aParam, TMPSZO->ZO_CODFOR  ) // Codigo do fornecedor da nota de entrada                             7
					AAdd( aParam, TMPSZO->ZO_LJFOR   ) // Loja do fornecedor da nota de entrada                               8
					AAdd( aParam, cLocApt            ) // Armazem                                                             9
					AAdd( aParam, nil                ) // Numero da OP                                                       10
					AAdd( aParam, nil                ) // Numero sequencial da etiqueta quando for reimpressao               11
					AAdd( aParam, If(SB1->B1_RASTRO=="L", TMPSZO->ZO_NUMLOTE ,nil ) )   //lote                                    12
					AAdd( aParam, nil                ) // Sublote                                                            13
					AAdd( aParam, /*dDataBase+1824*/ StoD(TMPSZO->ZO_DTVALID)       )   // Data de Validade                       14
					AAdd( aParam, nil                ) // Centro de Custos                                                   15
					AAdd( aParam, cLocApt            ) // Local de Origem                                                    16
					AAdd( aParam, nil                ) // Local cOPREQ    := If(len(paramixb) >=17,paramixb[17],NIL)         17
					AAdd( aParam, nil                ) // Local cNumSerie := If(len(paramixb) >=18,paramixb[18],NIL)         18
					AAdd( aParam, nil                ) // Local cOrigem   := If(len(paramixb) >=19,paramixb[19],NIL)         19
					AAdd( aParam, nil                ) // Local cEndereco := If(len(paramixb) >=20,paramixb[20],NIL)         20
					AAdd( aParam, nil                ) // Local cPedido   := If(len(paramixb) >=21,paramixb[21],NIL)         21
					AAdd( aParam, 0                  ) // Local nResto    := If(len(paramixb) >=22,paramixb[22],0)           22
					AAdd( aParam, nil                ) // Local cItNFE    := If(len(paramixb) >=23,paramixb[23],NIL)         23   
					AAdd( aParam, TMPSZO->ZO_NUMPLT  ) // Local cPallet   := If(len(paramixb) >=24,paramixb[24],"")          24       
					AAdd( aParam, TMPSZO->ZO_PRODUTO ) // Local           := If(len(paramixb) >=25,paramixb[25],"")          25       
					AAdd( aParam, TMPSZO->ZO_NUMLOTE ) // Lote do Fornecedor  := If(len(paramixb) >=26,paramixb[26],"")      26       
					AAdd( aParam, nil ) // Lote do Fornecedor  := If(len(paramixb) >=26,paramixb[26],"")      				 27       

	
					ExecBlock("IMG12",,,aParam )               	
	
					cQuery := " UPDATE "+RetSqlName("SZO")+" "
					cQuery += " SET ZO_SITUACA     =  '1' "                                
					cQuery += "    ,ZO_ENDERE      =  '" + cEndere           + "' "                                
					cQuery += "    ,ZO_DATAALT     =  '" + DtoS(dDataBase)   + "' "
					cQuery += "    ,ZO_USUARIO     =  '" + RetCodUsr()       + "' " 
					cQuery += " WHERE   ZO_FILIAL  =  '" + xFilial('SZO')    + "' "
					cQuery += "     AND ZO_NFORI   =  '" + TMPSZO->ZO_NFORI  + "' "
					cQuery += "     AND ZO_SERIE   =  '" + TMPSZO->ZO_SERIE  + "' "
					cQuery += " 	AND ZO_CODFOR  =  '" + TMPSZO->ZO_CODFOR + "' "         
					cQuery += "     AND ZO_LJFOR   =  '" + TMPSZO->ZO_LJFOR  + "' "
					cQuery += " 	AND ZO_NUMPLT  =  '" + TMPSZO->ZO_NUMPLT + "' "
	//				cQuery += " 	AND ZO_SITUACA =  '  ' "
					cQuery += " 	AND D_E_L_E_T_ <> '*' "
					TcSqlExec( cQuery )
	
	            Else

					MsgInfo("Produto não pertence ao grupo 12/14 Químicos - Produto:" +SB1->B1_COD + " Grupo: " + SB1->B1_GRUPO,"Atenção","Gerar e Imprimir Etiquetas dos Produtos Químicos")
	            
	            EndIf

				TMPSZO->(dbSkip())

			EndDo
		
		EndIf

	EndIf

Return( nil )
