#include 'Protheus.ch'
#include 'rwmake.ch'
/*---------------------------------------------------------------------------------------
Funcao: MA650EMP														Data: 11.07.2012
Autor : Vinicius Schwartz - TI - Midori Atlantica
-----------------------------------------------------------------------------------------
Objetivo: PONTO DE ENTRADA PARA EFETUAR O AJUSTE DE EMPENHO NO MOMENTO DA ABERTURA DA OP.
---------------------------------------------------------------------------------------*/

User Function MA650EMP()
local lTransArm := .T.
local lTrans    := GetMv ("MA_TRFLOC")
//lTransArm := SC2->C2_X_TRFLC == "N"
	//Alert ('Teste novo PE - OP: '+ SC2->C2_NUM + 'KG: '+ cValToChar(SC2->C2_X_KG))
	//Chamada da funcao abaixo

    //Chegar se houve duplicidade no empenho....
	AG_D4DPLIC(SC2->C2_NUM)
	
	AtD4B2(SC2->C2_NUM,SC2->C2_X_KG,SC2->C2_X_KGTI)

//	AG_ATUD4(SC2->C2_NUM)
	if lTransArm .and. lTrans  
		if U_AG_TRFLOC(SC2->C2_NUM)
			RecLock("SC2",.F.)
			SC2->C2_X_TRFLC := "S"
			MsUnLock("SC2")
		endif
	endif
Return


/*-------------------------------------------------------
------------Funcao que fara o ajuste do empenho----------
-------------------------------------------------------*/

Static Function AtD4B2(cOP,nKg,nKgTI)
//Variaveis locais da funcao
Local cQry := ""
Local nWet		:= 0 //WW ou WB 8
Local nQtdVq	:= 0 //Qtde de VQ SC2
Local nQtdAnt	:= 0 //Qtde na SD4 antes da alteracao
Local nQtdAtu	:= 0 //Qtde da SD4 apos o calc 
Local cCodPro	:= Space(6)
Local cTpClass	:= Space(2)

Local cGrupo
Local dData

//Variaveis para envio de e-mail
Local _cEmlFor := 'diego.mafisolli@midoriatlantica.com.br;thiago.cruz@midoriatlantica.com.br'
Local oProcess 
Local oHtml
Local nCont := 0 

aLstProd :={}

//Inicio
If cFilAnt == '09'
        
			//Descobrindo o TP de Class do produto para tratar WW ou WB
	        //Posiciona em SC2 para pegar Cod do Protudo
	        dbSelectArea('SC2')
	        dbSetOrder(1)
	        dbSeek(xFilial('SC2')+cOP)
	        cCodPro := SC2->C2_PRODUTO  
	        dData := SC2->C2_EMISSAO
	        cRetra := SC2->C2_OPRETRA
	                
	        //Posiciona em SB1 para pegar o Tipo de Class.
			dbSelectArea('SB1')
			dbSetOrder(1)
			dbSeek(xFilial('SB1')+cCodPro)
			cTpClass := SB1->B1_TPCLASS        
			cGrupo := SB1->B1_GRUPO
	        
    //Se produto da OP for do grupo 32 ou 32A
    If cGrupo == '32  ' .OR. cGrupo == '32A '

				//Verifica se WB ou WW
				if (cTpClass == 'CF') .Or. (cTpClass == 'CV')  //WW = 3Kg
					nWet := 3
				Elseif cTpClass == 'CR'  //WB = 3.5Kg
					nWet := 3.5
				Endif
			
		
		//Verifica se tabelas temporias existem e encerra as mesmas antes de executar as novas
		if Select("TMPSD4") > 0 
			dbSelectArea("TMPSD4")
			TMPSD4->(dbCloseArea())
		endif
		
		
		//Monta a query
		
		cQry := " SELECT D4.D4_FILIAL, D4.D4_COD, D4.D4_LOCAL, D4.D4_OP, D4.D4_QTDEORI, D4.D4_QUANT, "
		cQry += "		B2.B2_FILIAL, B2.B2_COD, B2.B2_LOCAL, B2.B2_QEMP, B1.B1_COD, B1.B1_TPCLASS, "
		cQry += " 		C2.C2_NUM, C2.C2_QUANT, C2.C2_QUJE "
		cQry += " FROM SD4010 D4 "
		cQry += " JOIN SB1010 B1 "
		cQry += "	ON B1.D_E_L_E_T_ <> '*' "
		cQry += "	AND B1.B1_COD = D4.D4_COD "
		cQry += "	AND (B1.B1_GRUPO = '12' OR B1.B1_GRUPO = '14') "
		cQry += " JOIN SB2010 B2 "
		cQry += "	ON B2.D_E_L_E_T_ <> '*' "
		cQry += "	AND B2.B2_FILIAL = D4.D4_FILIAL "
		cQry += "	AND B2.B2_LOCAL = D4.D4_LOCAL "
		cQry += "	AND B2.B2_COD = D4.D4_COD " 
		cQry += " JOIN SC2010 C2 "
		cQry += " 	ON C2.D_E_L_E_T_ <> '*' "
		cQry += " 	AND C2.C2_FILIAL = D4.D4_FILIAL "
		cQry += "	AND C2.C2_NUM = SUBSTRING(D4.D4_OP,1,6) "
		cQry += " WHERE D4.D_E_L_E_T_ <> '*' "
		cQry += "	AND SUBSTRING(D4.D4_OP,1,6) = '"+cOP+"' " 
		cQry += "	AND D4_FILIAL = '"+xFilial("SD4")+"' " 
		cQry += " 	ORDER BY D4.D4_OP "  
		
		cQry:= ChangeQuery(cQry)
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry),"TMPSD4",.T.,.T.) 
		
			//Inicia a transacao
		Begin Transaction  
			
			//Posiciona tabela temporaria no primeiro registro
			TMPSD4->(dbGoTop())
			
			//Loop de processamento
			While !TMPSD4->(EOF())
			
				//Verifica Qtd de VQ na SC2
				nQtdVq := TMPSD4->C2_QUANT
		
				dbSelectArea('SC2')
				SC2->(dbSetOrder(1))
				dbSeek(xFilial('SC2')+cOP)

				nKgAnt := SC2->C2_QUANT * nWet
		
				If nKg > 0
					//Faz alteracao SD4   
					dbSelectArea('SD4')		
					SD4->(dbSetOrder(1))
					If SD4->(dbSeek(xFilial("SD4")+TMPSD4->D4_COD+cOP))
						//Trava registro para gravar   
						RecLock("SD4",.F.)
							//so efetua o ajuste caso nao for retrabalho
							If cRetra == "N"
                                //Inicia o ajuste
								nQtdAnt := SD4->D4_QUANT  
								AADD(aLstProd, {SD4->D4_COD, nQtdAnt, 0 })
								SD4->D4_QUANT := TMPSD4->D4_QUANT * (nKg / nKgAnt)			//Saldo
								nQtdAtu := SD4->D4_QUANT                                                              
								aLstProd[len(aLstProd),3]:=nQtdAtu
								SD4->D4_QTDEORI := (TMPSD4->D4_QTDEORI - nQtdAnt) +  nQtdAtu		//Qtde Ori	
							Else
								nQtdAnt := SD4->D4_QUANT  
								AADD(aLstProd, {SD4->D4_COD, nQtdAnt, 0 })
 								nQtdAtu := SD4->D4_QUANT                                                              
 								aLstProd[len(aLstProd),3]:=nQtdAtu
							endif
						SD4->(MsUnlock()) 
					EndIf
					
					//So altera SB2 se caso nao for retrabalho
					If cRetra == "N"
						//Faz alteracao SB2
						dbSelectArea('SB2')
						SB2->(dbSetOrder(1))
						If SB2->(dbSeek(xFilial("SB2")+TMPSD4->D4_COD+TMPSD4->D4_LOCAL))
							//Trava registro para gravar
							RecLock("SB2",.F.)
								SB2->B2_QEMP := SB2->B2_QEMP + (nQtdAtu - nQtdAnt)
							SB2->(MsUnlock())		                                                
						EndIf
					endif
		        EndIf
						
			    TMPSD4->(dBSkip())   

			EndDo                   
					
			//Fecha a tabela temporaria
			TMPSD4->(dbCloseArea())
			

			/*--------------------------------------------
			------Inicio de envio de e-mail----------
			--------------------------------------------*/
			
		   	//RpcSetEnv("01","04","","","","",{"SRA"})
			//Alert('Iniciando envido e e-mail...')
/*
	    	oProcess := TWFProcess():New( "000004", "Itens que Foram Ajustados Empenhos" )
	     	oProcess:NewTask( "Itens que Foram Ajustados Empenhos", "\WORKFLOW\HTM\AJUEMP.HTM" )
		    oHtml    := oProcess:oHTML
			oHtml:ValByName("Data"			,dToc(dData))
			oHtml:ValByName("numOP"   		,cOP)
		                                     
		 	for i:= 1 to len(aLstProd)
		 		aAdd( oHtml:ValByName( "it.cod" ), aLstProd[i][1])
		 		aAdd( oHtml:ValByName( "it.qtde" ), aLstProd[i][2])
		 		aAdd( oHtml:ValByName( "it.qtdealt" ), aLstProd[i][3])
		 	next i
	   	 
	   	    	                                 
			oProcess:cSubject := "Itens Ajustados Empenhos - OP: " + cOP + " - KG: " + cValToChar(nKg) + " - Retra: " +cRetra
		
		
		
			oProcess:cTo      := _cEmlFor     
		
		
			oProcess:Start()                    
			       WFSendMail()
			       WFSendMail()	       
			oProcess:Finish()
			//Alert('Email enviado com sucesso...')
  */
		End Transaction    
	endif
	
    /*----------------------------------------------------------------------------------------------------------
      AJUSTE EMPENHO TINTA: Verificacao para realizar o ajuste de empenho dos grupos 39T e 39TI
      Author: Diego Henrique Mafisolli															Data: 19/08/2013
      ----------------------------------------------------------------------------------------------------------*/
       
    //Se produto da OP pertence ao grupo 38B - 38B - 38C - 38D - 38F - 39B - 39C - 39D - 39F
    If (cGrupo == '38B ' .OR. cGrupo == '38C ' .OR. cGrupo == '38D ' .OR. cGrupo == '38F ' .OR. cGrupo == '39B ' .OR.;
    	cGrupo == '39C ' .OR. cGrupo == '39D ' .OR. cGrupo == '39F ')

		//Verifica se tabelas temporias existem e encerra as mesmas antes de executar as novas
		if Select("TMPSD4") > 0 
			dbSelectArea("TMPSD4")
			TMPSD4->(dbCloseArea())
		endif
		
		//Monta a query
		
		cQry := " SELECT D4.D4_FILIAL, D4.D4_COD, D4.D4_LOCAL, D4.D4_OP, D4.D4_QTDEORI, D4.D4_QUANT, "
		cQry += "		B2.B2_FILIAL, B2.B2_COD, B2.B2_LOCAL, B2.B2_QEMP, B1.B1_COD, B1.B1_TPCLASS, "
		cQry += " 		C2.C2_NUM, C2.C2_QUANT, C2.C2_QUJE "
		cQry += " FROM SD4010 D4 "
		cQry += " JOIN SB1010 B1 "
		cQry += "	ON B1.D_E_L_E_T_ <> '*' "
		cQry += "	AND B1.B1_COD = D4.D4_COD "
		cQry += "	AND (B1.B1_GRUPO = '39T' OR B1.B1_GRUPO = '39TI') "
		cQry += " JOIN SB2010 B2 "
		cQry += "	ON B2.D_E_L_E_T_ <> '*' "
		cQry += "	AND B2.B2_FILIAL = D4.D4_FILIAL "
		cQry += "	AND B2.B2_LOCAL = D4.D4_LOCAL "
		cQry += "	AND B2.B2_COD = D4.D4_COD " 
		cQry += " JOIN SC2010 C2 "
		cQry += " 	ON C2.D_E_L_E_T_ <> '*' "
		cQry += " 	AND C2.C2_FILIAL = D4.D4_FILIAL "
		cQry += "	AND C2.C2_NUM = SUBSTRING(D4.D4_OP,1,6) "
		cQry += " WHERE D4.D_E_L_E_T_ <> '*' "
		cQry += "	AND SUBSTRING(D4.D4_OP,1,6) = '"+cOP+"' " 
		cQry += "	AND D4_FILIAL = '"+xFilial("SD4")+"' " 
		cQry += " 	ORDER BY D4.D4_OP "  
		
		cQry:= ChangeQuery(cQry)
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry),"TMPSD4",.T.,.T.) 
		
		//Inicia a transacao
		Begin Transaction  
			
			//Posiciona tabela temporaria no primeiro registro
			TMPSD4->(dbGoTop())
			
			//Loop de processamento
			While !TMPSD4->(EOF())
			
				//Verifica Qtd de VQ na SC2
		
				dbSelectArea('SC2')
				SC2->(dbSetOrder(1))
				dbSeek(xFilial('SC2')+cOP)
		         
				If nKgTI > 0
					//Faz alteracao SD4   
					dbSelectArea('SD4')		
					SD4->(dbSetOrder(1))
					If SD4->(dbSeek(xFilial("SD4")+TMPSD4->D4_COD+cOP))
						//Trava registro para gravar   
						RecLock("SD4",.F.)
                                //Inicia o ajuste
								nQtdAnt := SD4->D4_QUANT  
								AADD(aLstProd, {SD4->D4_COD, nQtdAnt, 0 })
								SD4->D4_QUANT := nKgTI	//Saldo
								nQtdAtu := SD4->D4_QUANT                                                              
								aLstProd[len(aLstProd),3]:=nQtdAtu
								SD4->D4_QTDEORI := nKgTI //Qtde Ori	
						SD4->(MsUnlock()) 
					EndIf
					
						//Faz alteracao SB2
						dbSelectArea('SB2')
						SB2->(dbSetOrder(1))
						If SB2->(dbSeek(xFilial("SB2")+TMPSD4->D4_COD+TMPSD4->D4_LOCAL))
							//Trava registro para gravar
							RecLock("SB2",.F.)
								SB2->B2_QEMP := SB2->B2_QEMP + (nQtdAtu - nQtdAnt)
							SB2->(MsUnlock())		                                                
						EndIf
		        EndIf
						
			    TMPSD4->(dBSkip())   

			EndDo                   
					
			//Fecha a tabela temporaria
			TMPSD4->(dbCloseArea())
			

			/*--------------------------------------------
			------Inicio de envio de e-mail----------
			--------------------------------------------*/
			/*
		   	//RpcSetEnv("01","04","","","","",{"SRA"})
			
			//Alert('Iniciando envido e e-mail...')
	    	oProcess := TWFProcess():New( "000004", "Itens que Foram Ajustados Empenhos" )
	     	oProcess:NewTask( "Itens que Foram Ajustados Empenhos", "\WORKFLOW\HTM\AJUEMP.HTM" )
		    oHtml    := oProcess:oHTML
			oHtml:ValByName("Data"			,dToc(dData))
			oHtml:ValByName("numOP"   		,cOP)
     
		 	for i:= 1 to len(aLstProd)
		 		aAdd( oHtml:ValByName( "it.cod" ), aLstProd[i][1])
		 		aAdd( oHtml:ValByName( "it.qtde" ), aLstProd[i][2])
		 		aAdd( oHtml:ValByName( "it.qtdealt" ), aLstProd[i][3])
		 	next i
	   	 
	   	    	                                 
			oProcess:cSubject := "Itens Ajustados Empenhos - OP: " + cOP + " - KG: " + cValToChar(nKgTI)
		
		
		
			oProcess:cTo      := _cEmlFor     
		
		
			oProcess:Start()                    
			       WFSendMail()
			       WFSendMail()	       
			oProcess:Finish()
			*/

		End Transaction    
	endif
	/*----------------------------------------------------------------------------------------------------------*/
Endif


//Retorno da rotina
Return


//Funcao para verificar se o SD4 das unidades de costura está duplicado...
//Função desenvolvida por Anesio - 12/06/2015
static function AG_D4DPLIC(cNumOP)
lRet := .F.
cQuery := " "
//if Substr(M->D3_OP,9,3) == '001'                      
	dbSelectArea("SC2")
	dbSeek(xFilial("SC2")+cNumOP,.F.)
	cCodPA := SC2->C2_PRODUTO
	nQtde  := SC2->C2_QUANT

	cQuery := " Select G1_COMP, G1_QUANT * "+cValToChar(nQtde)+ " QTDREAL, D4_QUANT, D4_QTDEORI, (D4_QTDEORI - (G1_QUANT * "+cValToChar(nQtde)+" )) DIF "
	cQuery += " from SG1010 SG1 with (nolock), SD4010 SD4 with (nolock), SB1010 SB1 with (nolock) "
	cQuery += " where SD4.D_E_L_E_T_ =' ' and SG1.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' "
	cQuery += " and G1_FILIAL = D4_FILIAL and G1_COMP = D4_COD "
	cQuery += " and G1_COMP = B1_COD  "
	cQuery += " and D4_FILIAL ='"+xFilial("SD4")+"' and G1_FILIAL ='"+xFilial("SD4")+"' "
	cQuery += " and Substring(D4_OP,1,6) ='"+cNumOP+"' "
	cQuery += " and G1_COD ='"+cCodPA+"' "
	cQuery += " and Substring(G1_COMP,1,3) <> 'MOD' " 
	
	MemoWrite("C:\TEMP\MD650EMP_SD4DUPLI.TXT", cQuery)
	
	if Select("TMPG1") > 0 
		dbSelectArea("TMPG1")
		TMPG1->(dbCloseArea())
	endif
	dbUseArea(.T., "TOPCONN", TcGenQry(, , cQuery), "TMPG1", .T., .T.)
	
	dbSelectArea("TMPG1")
	TMPG1->(dbGotop())
	ProcRegua(0)
	while !TMPG1->(eof())
		if TMPG1->DIF == TMPG1->QTDREAL
			Alert("OP "+cNumOP+" Produto "+ALLTRIM(TMPG1->G1_COMP)+ " DUPLICADO o empenho na estrutura...")
			lRet := .T.
		endif
		incProc("Analisando consistencia dos empenhos...")
		TMPG1->(dbSkip())
	enddo
//endif
Return lRet
