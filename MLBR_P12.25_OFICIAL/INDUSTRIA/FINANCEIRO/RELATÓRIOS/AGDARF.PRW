#INCLUDE "FINRSRF.ch"
#INCLUDE "PROTHEUS.CH"
#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

Static lFWCodFil := FindFunction("FWCodFil")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FINRSRF   ³ Autor ³ Eduardo Riera         ³ Data ³26.06.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio de impressao do Darf grafico a partir dos titulos ³±±
±±³          ³de contas a pagar                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±                  
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user Function AGFINRSRF(cAlias,nReg,nOpc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Variaveis                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cPerg   := "FINSRF"  // Pergunta do Relatorio
LOCAL aParamBox := {}  
LOCAL cTitulo := "Emissão DARF"
Static aPergRet := {}            
LOCAL bOk := {|| .T.}
LOCAL aButtons := {}
LOCAL lCentered := .T.
LOCAL nPosx
LOCAL nPosy
LOCAL cLoad := "FINRSRF_01"
LOCAL lCanSave := .T.
LOCAL lUserSave := .T.
LOCAL dData	 := dDataBase  
Local nTamFilial:= IIf( lFWCodFil, FWGETTAMFILIAL, 2 )

Default cAlias := "FI9"
Default nReg	:= 0
Default nOpc	:= 2 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as Perguntas Seleciondas                                ³
//³---------------------------------                                ³
//³ aPergRet[1] - Vencimento Inicial ?                                 ³
//³ aPergRet[2] - Vencimento Final ?                                   ³
//³ aPergRet[3] - Codigo SRF Inicial ?                                 ³
//³ aPergRet[4] - Codigo SRF Final ?                                   ³
//³ aPergRet[5] - Agrupa por ? (Fornec./Cod.SRF - Apenas Cod. SRF )    ³
//³ aPergRet[6] - Período de Apuração                                  ³
//³ aPergRet[7] - Numero de referencia                                 ³
//³ aPergRet[8] - Filial centralizadora                                ³
//³ aPergRet[9] - Modelo ? Comum/Simples                               ³
//³ aPergRet[10] - Receita Bruta ?                                      ³
//³ aPergRet[11] - Percentual ?                                         ³
//³ aPergRet[12] - Periodicidade ?                                      ³
//³ aPergRet[13] - CNPJ da incorporadora ?                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aParamBox,{1, STR0005			   ,dData	  ,"" 	 		 			      ,""   ,""   ,""   ,50 ,.T.}) //Vencimento Inicial ?     
AADD(aParamBox,{1, STR0006			   ,dData	  ,"" 	 			 			  ,""   ,""	  ,""   ,50 ,.T.}) //Vencimento Final ?      			   
AADD(aParamBox,{1, STR0007 			   ,"    "	  ,"@!"					  		  , 	,"37" ,".T.",4  ,.F.}) //Codigo SRF Inicial ?
AADD(aParamBox,{1, STR0008 			   ,"ZZZZ"	  ,"@!"					  		  , 	,"37" ,".T.",4  ,.F.}) //Codigo SRF Final ?
AADD(aParamBox,{2, STR0009 			   ,STR0018	  ,{STR0018,STR0019}			  ,060	,""	  , .T.         }) //Agrupa por ? (Fornec./Cod.SRF - Apenas Cod. SRF )
AADD(aParamBox,{1, STR0010			   ,dData	  ,"" 	 		 			      ,""   ,""   ,""   ,50 ,.T.}) //Período de Apuração      			   
AADD(aParamBox,{1, STR0011			   ,Space(15) ,"@!"					  		  ,		,""	  ,".T.",60 ,.F.}) //Numero de referencia
AADD(aParamBox,{1, STR0012			   ,Space(nTamFilial),"@!"					  		  ,""	,"XM0",".T.",2  ,.T.}) //Filial centralizadora                                
AADD(aParamBox,{2, STR0013 			   ,STR0020   ,{STR0020,STR0021}			  ,060	,""	  , .T.		   }) //Modelo ? Comum/Simples                               
AADD(aParamBox,{1, STR0014 			   ,999.99    ,"@E 999,999,999.99" 		  	  ,		,""   ,".T.",60 ,.F.}) //Receita Bruta ? 
AADD(aParamBox,{1, STR0015 			   ,10.00     ,"@E 999.99" 		  			  , 	,""   ,".T.",10 ,.F.}) //Percentual ? 
AADD(aParamBox,{2, STR0016 			   ,STR0022	  ,{STR0022,STR0023,STR0024,STR0025,STR0026,STR0027,STR0028,STR0029,STR0030},060,"", .T.}) //Periodicidade ?                           
AADD(aParamBox,{1, STR0017 			   ,Space(14) ,"@R 99.999.999/9999-99" 		  ,     ,""   ,".T.",60 ,.F.}) //CNPJ da incorporadora ?

lRet := ParamBox(aParamBox, cTitulo, aPergRet, bOk, aButtons, lCentered, nPosx,nPosy, /*oMainDlg*/ , cLoad, lCanSave, lUserSave)

If lRet
	RptStatus({|lEnd| ImpDet(lEnd,cAlias,nReg,nOpc)},STR0001) //"Processando - DARF"
EndIf
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ ImpDet   ³ Autor ³ Eduardo Riera         ³ Data ³26.06.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Controle de Fluxo do Relatorio.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpDet(lEnd,cAlias,nReg,nOpc)

Local aDarf     := {}
Local aInfo     := {}
Local lQuery    := .F.
Local cAliasSE2 := "SE2"
Local dDataIni  := aPergRet[1]
Local dDataFim  := aPergRet[2]
Local nX        := 0
Local nValorImp := 0
Local cAliasAux
Local cCodIni   := aPergRet[3]
Local cCodFim   := aPergRet[4]
Local aAreaSm0  := SM0->(GetArea())    
Local nRegSE2
Local aInfoAux  := {}

#IFDEF TOP
	Local aStru     := {}
	Local cQuery    := ""
	Local cSepTxa		:= If("|"$MVTXA,"|",",")
	Local cSepTx		:= If("|"$MVTAXA,"|",",")
#ENDIF

If Val(SubStr(aPergRet[9],1,1)) == 1 // Modelo? Comum/Simples	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre o SE2 com outro alias para ser localizado o titulo 	 ³
	//³ principal do imposto                   							 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !( ChkFile("SE2",.F.,"NEWSE2") )
		Return(Nil)
	EndIf	
		
	dbSelectArea("SE2")
	SetRegua(LastRec())
	dbSetOrder(3)
	
	#IFDEF TOP
		lQuery := .T.
		aStru  := SE2->(dbStruct())
		cAliasSE2 := "IMPDET"
		
		cQuery := "SELECT * "
		cQuery += "FROM "+RetSqlName("SE2")+" SE2 "
		cQuery += "WHERE SE2.E2_FILIAL='"+xFilial("SE2")+"' AND "
		cQuery += "SE2.E2_VENCREA>='"+DTOS(dDataIni)+"' AND "
		cQuery += "SE2.E2_VENCREA<='"+DTOS(dDataFim)+"' AND "
		cQuery += "SE2.E2_CODRET<>'"+Space(Len(SE2->E2_CODRET))+"' AND "
		cQuery += "SE2.E2_CODRET>='"+cCodIni+"' AND "
		cQuery += "SE2.E2_CODRET<='"+cCodFim+"' AND " 				
		If FieldPos("E2_IDDARF") > 0
			cQuery += "SE2.E2_IDDARF='' AND " 						
		EndIf
		cQuery += "SE2.E2_SALDO > 0 AND "		
		cQuery += "( E2_TIPO IN " + FormatIn(MVTXA,cSepTxa)  + " OR "
		cQuery += "  E2_TIPO IN " + FormatIn(MVTAXA,cSepTx)  + " OR "
		cQuery += "  SE2.E2_ORIGEM = 'MATA996' ) AND "
		cQuery += "SE2.D_E_L_E_T_=' ' "
		cQuery += "ORDER BY "+SqlOrder(SE2->(IndexKey()))
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE2)
		For nX := 1 To Len(aStru)
			If aStru[nX][2]<>"C"
				TcSetField(cAliasSE2,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
	#ELSE
		MsSeek(xFilial("SE2")+DTOS(dDataIni),.T.)
	#ENDIF
	While ( !Eof() .And. xFilial("SE2")==(cAliasSE2)->E2_FILIAL .And.;
			(cAliasSE2)->E2_VENCREA <= dDataFim )
	
		If !Empty((cAliasSE2)->E2_CODRET) .And.;
			(cAliasSE2)->E2_CODRET >= cCodIni .And.;
			(cAliasSE2)->E2_CODRET <= cCodFim .And.;   
			(((cAliasSE2)->E2_TIPO $ MVTAXA+"/"+MVTXA) .Or. Alltrim((cAliasSE2)->E2_ORIGEM) == "MATA996") .And.;
			If((cAliasSE2)->(FieldPos("E2_IDDARF")) > 0,AllTrim((cAliasSE2)->E2_IDDARF)=='',.T.)
			
			// Posiciona no titulo pai para obter o valor total do titulo
			lAchouPai := FrSrfPai(cAliasSe2)
			cAliasAux := If(lAchouPai,"NEWSE2", cAliasSE2)
			dbSelectArea("SA2")
			MsSeek(xFilial("SA2")+(cAliasAux)->(E2_FORNECE+E2_LOJA))
			dbSelectArea(cAliasSE2)
			
			If Val(SubStr(aPergRet[5],1,1)) == 1   // Agrupa por fornecedor 
				nX := aScan(aDarf,{|x|	x[1] == (cAliasSE2)->E2_CODRET .And.;
												x[2] == (cAliasSE2)->E2_VENCREA .And.;
												x[4] == SA2->A2_COD })
			Else
				nX := aScan(aDarf,{|x| x[1] == (cAliasSE2)->E2_CODRET .And. x[2] == (cAliasSE2)->E2_VENCREA})
			Endif
			// Obtem o valor do imposto
			// Se nao achou o titulo pai, esta no proprio titulo pai e entao
			// o valor do imposto sera o valor do campo de imposto, senao sera
			// o valor do titulo de imposto (SE2->E2_VALOR)
			If !lAchouPai .And. !(cAliasAux)->E2_TIPO $ MVTAXA .And. Alltrim((cAliasSE2)->E2_ORIGEM) != "MATA996"
				Do Case 
				Case Alltrim((cAliasSE2)->E2_NATUREZ) $ AllTrim(GetMv("MV_PISNAT")) 
					nValorImp := NEWSE2->E2_PIS
				Case Alltrim((cAliasSE2)->E2_NATUREZ) $ AllTrim(GetMv("MV_COFINS")) 
					nValorImp := NEWSE2->E2_COFINS
				Case Alltrim((cAliasSE2)->E2_NATUREZ) $ AllTrim(GetMv("MV_CSLL")) 
					nValorImp := NEWSE2->E2_CSLL
				OtherWise
					nValorImp := NEWSE2->E2_IRRF
				EndCase	
			Else
				nValorImp := (cAliasSE2)->E2_VALOR
			Endif
			#IFDEF TOP 
				nRegSE2:= (cAliasSE2)->(R_E_C_N_O_)
			#ELSE
				nRegSE2:= (cAliasSE2)->(Recno())	
			#ENDIF						    
			If nX == 0
				aadd(aDarf,{(cAliasSE2)->E2_CODRET,;
								(cAliasSE2)->E2_VENCREA,;
								xMoeda(nValorImp,(cAliasSE2)->E2_MOEDA,1),;
								SA2->A2_COD,;
								SA2->A2_NOME,;
								lAchouPai,;
								(cAliasSE2)->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA),;
								{nRegSE2},;
								{nValorImp}})
			Else
				aDarf[nX][3] += xMoeda(nValorImp,(cAliasSE2)->E2_MOEDA,1)
				aAdd(aDarf[nx][8],nRegSE2)
				aAdd(aDarf[nx][9],nValorImp)				
			EndIf
		EndIf
		dbSelectArea(cAliasSE2)
		dbSkip()
		IncRegua()
		If lEnd
			Exit
		EndIf
	EndDo
	NEWSE2->(dbCloseArea())
	If lQuery
		dbSelectArea(cAliasSE2)
		dbCloseArea()
		dbSelectArea("SE2")
	EndIf 
	
	// Se for informada a filial centralizadora, posiciona nela para impressao dos dados como CGC, Nome, Etc.
	If !Empty(aPergRet[8])
		SM0->(MsSeek(cEmpAnt+aPergRet[8]))
	Endif
	For nX := 1 To Len(aDarf)
		aadd(aInfo,{{SM0->M0_NOMECOM,SM0->M0_TEL},;
			aPergRet[6],;
			TransForm(SM0->M0_CGC,"@r 99.999.999/9999-99"),;
			aDarf[nX][1],;
			aPergRet[7],;
			aDarf[nX][2],;
			aDarf[nX][3],;
			0,;
			0,;
			aDarf[nX][3],;
			aDarf[nX][5],;
			aDarf[nX][6],;
			aDarf[nX][7]})                        
		U_GInfDARF(aDarf[nX][8], aDarf[nX][3],aDarf[nX][1],nOpc,aDarf[nX][9],aInfo[nX][3],aDarf[nX][2])
	Next nX
Else
	aadd(aInfo,{{SM0->M0_NOMECOM,SM0->M0_TEL},;
			aPergRet[6],;
			TransForm(SM0->M0_CGC,"@r 99.999.999/9999-99"),;
			"6106",;                                 // Codigo da Receita
			aPergRet[10],;                           // Valor da Receita Bruta Acumulada
			aPergRet[11],;                           // Percentual
			( ( aPergRet[10] / 100 ) * aPergRet[11] ),; // Valor do Principal
			0,;                                  // Valor da multa
			0,;                                  // Valor dos juros
			"",;                                 // nao eh utilizado
			"",;                                 // nao eh utilizado
			""})                                 // nao eh utilizado
EndIf

aInfoAux := AClone(aInfo)      
If ExistBlock("FA373SCL")
	aInfo := ExecBlock("FA373SCL", .F., .F.,{aInfo})
	If ValType(aInfo) <> "A"
		aInfo := AClone(aInfoAux)
	Endif
Endif

If Len(aInfo) > 0
	U_PrtDarf(aInfo,aPergRet)
Else
	Aviso(STR0002,STR0003,{STR0004}) //"Mensagem"###"Nao há dados no periodo informado"###"Ok"
EndIf
SM0->(RestArea(aAreaSm0))
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PrtDarf   ³ Autor ³Eduardo Riera          ³ Data ³26/06/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do formulario DARF grafico conforme layout da SRF³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PrtDarf(aInfo)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1: [1][1] Nome                                         ³±±
±±³          ³        [1][2] Telefone                                     ³±±
±±³          ³        [2] Periodo de Apuracao ( DATA )                    ³±±
±±³          ³        [3] CNPJ                                            ³±±
±±³          ³        [4] Codigo da Receita                               ³±± 
±±³          ³        [5] Numero de Referencia                            ³±±
±±³          ³        [6] Data de Vencimento (Data)                       ³±±
±±³          ³        [7] Valor do Principal                              ³±±
±±³          ³        [8] Valor da Multa                                  ³±±
±±³          ³        [9] Valor dos Juros e/ou Encargos DL - 1.025/69     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function  PrtDarf(aInfo,aPergRet)

Local cBmp 		 := ""
Local cStartPath := GetSrvProfString("StartPath","")
Local nX         := 030
Local nY         := 0
Local nW         := 0
Local oFont07    := TFont():New("Arial",07,10,,.F.,,,,.T.,.F.)
Local oFont09    := TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)  
Local oFont09n   := TFont():New("Arial",09,09,,.T.,,,,.T.,.F.)
Local oFont10    := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
Local oFont10n   := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
Local oFont11    := TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
Local oFont15    := TFont():New("Arial",15,15,,.F.,,,,.T.,.F.)
Local oFont21n   := TFont():New("Arial",21,21,,.T.,,,,.T.,.F.)

Local oFont07n   := TFont():New("Arial",07,10,,.T.,,,,.T.,.F.)
Local oFont18n   := TFont():New("Arial",18,18,,.T.,,,,.T.,.F.)

Local oPrint
Local cSet  

cSet := Set(_SET_DATEFORMAT)
Set(_SET_DATEFORMAT,"dd/mm/yyyy")    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de Entrada: Recebe Informações DARF mais valores de Juros e Multa ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("DARFVAL")
   aInfo := ExecBlock("DARFVAL",.F.,.F.,{aInfo})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializacao do objeto grafico                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint 	:= TMSPrinter():New("DARF - Guia de Recolhimento DARF")
oPrint:Setup()
oPrint:SetPortrait()
cBmp := cStartPath + "Receita.BMP" //Logo da Receita Federal
For nW := 1 To Len(aInfo)
	oPrint:StartPage()
	nX := 030		
	For nY := 1 To 2
	
		If Val(SubStr(aPergRet[9],1,1)) == 1 // Modelo? Comum/Simples	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Box grafico                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Box(nX,0030,nX+1100,2350)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Inclusao do logotipo do Ministerio da Fazenda                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If File(cBmp)
				oPrint:SayBitmap(nX+10,040,cBmp,200,180)
			EndIf
			oPrint:Say(nX+020,250,"MINISTÉRIO DA FAZENDA",oFont15)
			oPrint:Say(nX+070,250,"Secretaria da Receita Federal do Brasil")
			oPrint:Say(nX+120,250,"Documento de Arrecadação de Receitas Federais",oFont10)
			oPrint:Say(nX+170,250,"DARF",oFont21n)
			oPrint:Line(nX,1300,nX+1100,1300)
			oPrint:Line(nX,1800,nX+810,1800)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 01                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+270,030,nX+270,1300) 
			oPrint:Say(nX+280,040,"01",oFont10)
			oPrint:Say(nX+290,110,"NOME / TELEFONE",oFont10)
			oPrint:Say(nX+350,110,Left(aInfo[nW][1][1],40),oFont10) 
			oPrint:Say(nX+380,110,aInfo[nW][1][2],oFont10)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 02                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+490,030,nX+490,1300)
			oPrint:Line(nX+650,030,nX+650,1300)
			oPrint:Say(nX+020,1305,"02",oFont10)
			oPrint:Say(nX+030,1360,"PERíODO DE APURACAO",oFont09)
			If Len(Dtoc(aInfo[nW][2])) > 8
				oPrint:Say(nX+030,2150,Dtoc(aInfo[nW][2]),oFont10)
			Else
				oPrint:Say(nX+030,2190,Dtoc(aInfo[nW][2]),oFont10)
			EndIf	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 03                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+090,1300,nX+90,2350)
			oPrint:Say(nX+120,1305,"03",oFont10)
			oPrint:Say(nX+130,1360,"NÚMERO DO CPF OU CNPJ",oFont09)
			oPrint:Say(nX+130,2010,aInfo[nW][3],oFont10)  
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 04                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+180,1300,nX+180,2350)
			oPrint:Say(nX+200,1305,"04",oFont10)
			oPrint:Say(nX+210,1360,"CODIGO DA RECEITA",oFont09)
			oPrint:Say(nX+210,2245,aInfo[nW][4],oFont10)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 05                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+270,1300,nX+270,2350)
			oPrint:Say(nX+290,1305,"05",oFont10)
			oPrint:Say(nX+300,1360,"NÚMERO DE REFERÊNCIA",oFont09)
			oPrint:Say(nX+300,2035,aInfo[nW][5],oFont10)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 06                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+360,1300,nX+360,2350)
			oPrint:Say(nX+380,1305,"06",oFont10)
			oPrint:Say(nX+390,1360,"DATA DE VENCIMENTO",oFont09)
			If Len(Dtoc(aInfo[nW][6])) > 8
				oPrint:Say(nX+390,2150,Dtoc(aInfo[nW][6]),oFont10)  
			Else	
				oPrint:Say(nX+390,2190,Dtoc(aInfo[nW][6]),oFont10)  
			EndIf	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 07                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+450,1300,nX+450,2350)
			oPrint:Say(nX+470,1305,"07",oFont10)
			oPrint:Say(nX+480,1360,"VALOR DO PRINCIPAL",oFont09)
			oPrint:Say(nX+480,2100,Transform(aInfo[nW][7],"@E 9,999,999,999.99"),oFont10)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 08                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+ 540,1300,nX+540,2350)
			oPrint:Say(nX+560,1305,"08",oFont10)
			oPrint:Say(nX+570,1360,"VALOR DA MULTA",oFont09)
			oPrint:Say(nX+570,2100,Transform(aInfo[nW][8],"@E 9,999,999,999.99"),oFont10)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 09                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+630,1300,nX+630,2350)
			oPrint:Say(nX+650,1305,"09",oFont10)
			oPrint:Say(nX+640,1360,"VALOR DOS JUROS E / OU",oFont09)
			oPrint:Say(nX+670,1370,"ENCARGOS DL 1025/69",oFont09)
			oPrint:Say(nX+670,2100,Transform(aInfo[nW][9],"@E 9,999,999,999.99"),oFont10)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 10                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+720,1300,nX+720,2350)
			oPrint:Say(nX+740,1305,"10",oFont10)
			oPrint:Say(nX+750,1360,"VALOR TOTAL",oFont09)
			oPrint:Say(nX+750,2100,Transform(aInfo[nW][7]+aInfo[nW][8]+aInfo[nW][9],"@E 9,999,999,999.99"),oFont10)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 11                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+810,1300,nX+810,2350)
			oPrint:Say(nX+830,1305,"11",oFont10)
			oPrint:Say(nX+830,1370,"AUTENTICAÇÃO BANCÁRIA (SOMENTE NAS 1 E 2 VIAS)",oFont09n)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro de aviso                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Say(nX+0680,600,"ATENÇÃO",oFont10n)
			oPrint:Say(nX+0740,040,"É vedado o recolhimento de tributos e contribuições administrados pela",oFont07)
			oPrint:Say(nX+0780,040,"Secretaria da Receita Federal cujo valor seja inferior a R$ 10,00. ",oFont07)
			oPrint:Say(nX+0820,040,"Ocorrendo tal situação, adicione esse valor ao tributo/contribuição de",oFont07)
			oPrint:Say(nX+0860,040,"mesmo código de períodos subsequentes, até que o total seja igual ou",oFont07)
			oPrint:Say(nX+0900,040,"superior a R$10,00.",oFont07)
			oPrint:Say(nX+0940,040,"Valores expressos em reais",oFont07)

			If Val(SubStr(aPergRet[5],1,1)) == 1 .And. aInfo[nW][12] .and. FUNNAME() <> "FINA373" // Se encontrou o titulo pai, imprime o nome do fornecedor do titulo pai
				oPrint:Say(nX+1030,040,"Recolhido em nome de " + aInfo[nW][11],oFont07)
			Else
				oPrint:Say(nX+1030,040,"DARF Manual",oFont07)
			Endif	
	
			If nY == 1
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Definicao do picote                                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oPrint:Say(nX+1250,000,Replicate("-",132),oFont11)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Segunda via do Darf                                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
				nX := 1480
			EndIf
	   Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Box grafico                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Box(nX,0030,nX+1100,2350)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Inclusao do logotipo do Ministerio da Fazenda                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If File(cBmp)
				oPrint:SayBitmap(nX+10,040,cBmp,200,180)
			EndIf
			oPrint:Say(nX+020,250,"MINISTÉRIO DA FAZENDA",oFont15)
			oPrint:Say(nX+080,250,"Secretaria da Receita Federal do Brasil",oFont15)
			oPrint:Say(nX+160,250,"Documento de Arrecadação",oFont07)
			oPrint:Say(nX+200,040,"do Sistema Integrado de Pagamento de Impostos e Contribuições",oFont07)
			oPrint:Say(nX+240,150,"das Microempresas e Empresas de Pequeno Porte",oFont07)
			oPrint:Say(nX+290,250,"DARF - SIMPLES",oFont18n)

			oPrint:Line(nX,1300,nX+1100,1300)
			oPrint:Line(nX,1800,nX+810,1800)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 01                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+360,030,nX+360,1300)
			oPrint:Say(nX+370,040,"01",oFont10)
			oPrint:Say(nX+380,110,"NOME DA EMPRESA / TELEFONE",oFont10)
			oPrint:Say(nX+440,110,Left(aInfo[nW][1][1],40),oFont10) 
			oPrint:Say(nX+470,110,aInfo[nW][1][2],oFont10)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 02                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+560,030,nX+560,1300) //d
			oPrint:Say(nX+020,1305,"02",oFont10)
			oPrint:Say(nX+030,1360,"PERíODO DE APURACAO",oFont09)

			If Len(Dtoc(aInfo[nW][2])) > 8
				oPrint:Say(nX+030,2150,Dtoc(aInfo[nW][2]),oFont10)
			Else	
				oPrint:Say(nX+030,2190,Dtoc(aInfo[nW][2]),oFont10)
			EndIf	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 03                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+090,1300,nX+90,2350)
			oPrint:Say(nX+120,1305,"03",oFont10)
			oPrint:Say(nX+130,1360,"NÚMERO DO CGC",oFont09)
			oPrint:Say(nX+130,2010,aInfo[nW][3],oFont10)  
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 04                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+180,1300,nX+180,2350)
			oPrint:Say(nX+200,1305,"04",oFont10)
			oPrint:Say(nX+210,1360,"CÓDIGO DA RECEITA",oFont09)
			oPrint:Say(nX+210,2245,aInfo[nW][4],oFont10)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 05                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+270,1300,nX+270,2350)
			oPrint:Say(nX+290,1305,"05",oFont10)
			oPrint:Say(nX+280,1360,"VALOR DA RECEITA",oFont09)
			oPrint:Say(nX+310,1360,"BRUTA ACUMULADA",oFont09)
			oPrint:Say(nX+300,2100,Transform(aInfo[nW][5],"@E 9,999,999,999.99"),oFont10)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 06                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+360,1300,nX+360,2350)
			oPrint:Say(nX+380,1305,"06",oFont10)
			oPrint:Say(nX+390,1360,"PERCENTUAL",oFont09)
			oPrint:Say(nX+390,2100,Transform(aInfo[nW][6],"@E 9,999,999,999.99"),oFont10)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 07                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+450,1300,nX+450,2350)
			oPrint:Say(nX+470,1305,"07",oFont10)
			oPrint:Say(nX+480,1360,"VALOR DO PRINCIPAL",oFont09)
			oPrint:Say(nX+480,2100,Transform(aInfo[nW][7],"@E 9,999,999,999.99"),oFont10)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 08                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+ 540,1300,nX+540,2350)
			oPrint:Say(nX+560,1305,"08",oFont10)
			oPrint:Say(nX+570,1360,"VALOR DA MULTA",oFont09)
			oPrint:Say(nX+570,2100,Transform(aInfo[nW][8],"@E 9,999,999,999.99"),oFont10)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 09                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+630,1300,nX+630,2350)
			oPrint:Say(nX+650,1305,"09",oFont10)
			oPrint:Say(nX+660,1360,"VALOR DOS JUROS",oFont09)
			oPrint:Say(nX+660,2100,Transform(aInfo[nW][9],"@E 9,999,999,999.99"),oFont10)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 10                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+720,1300,nX+720,2350)
			oPrint:Say(nX+740,1305,"10",oFont10)
			oPrint:Say(nX+750,1360,"VALOR TOTAL",oFont09)
			oPrint:Say(nX+750,2100,Transform(aInfo[nW][7]+aInfo[nW][8]+aInfo[nW][9],"@E 9,999,999,999.99"),oFont10)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro 11                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Line(nX+810,1300,nX+810,2350)
			oPrint:Say(nX+830,1305,"11",oFont10)
			oPrint:Say(nX+830,1370,"AUTENTICAÇÃO BANCÁRIA (SOMENTE NAS 1 E 2 VIAS)",oFont09n)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Definicao do Quadro de aviso                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Say(nX+0600,040,"ATENÇÃO para o preenchimento dos seguintes campos",oFont07n)
			oPrint:Say(nX+0660,040,"02 -",oFont07)
			oPrint:Say(nX+0660,110,"Informe a data de encerramento do período de apuração no formato",oFont07)
			oPrint:Say(nX+0700,110,"DD/MM/AA.",oFont07)
			oPrint:Say(nX+0740,110,"Ex.: periodo de apuração de janeiro de 1997 -> 31/01/97",oFont07)
			oPrint:Say(nX+0800,040,"05 -",oFont07)
			oPrint:Say(nX+0800,110,"Informe a soma das receitas brutas mensais de janeiro até o mes",oFont07)
			oPrint:Say(nX+0840,110,"de apuração.",oFont07)
			oPrint:Say(nX+0900,040,"06 -",oFont07)
			oPrint:Say(nX+0900,110,"Informe o percentual decorrente da receita bruta acumulada a ser ",oFont07)
			oPrint:Say(nX+0940,110,"aplicado sobre a receita mensal, com duas casas decimais.",oFont07)
			oPrint:Say(nX+1000,040,"07 -",oFont07)
			oPrint:Say(nX+1000,110,"Informe o resultado da aplicação do percentual do campo 06",oFont07)
			oPrint:Say(nX+1040,110,"sobre a receita bruta mensal.",oFont07)
			
			If nY == 1
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Definicao do picote                                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oPrint:Say(nX+1250,000,Replicate("-",132),oFont11)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Segunda via do Darf                                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
				nX := 1480
			EndIf	   
	   EndIf
	
	Next nY
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Finaliza a pagina                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 	
	oPrint:EndPage()
Next nW
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Finaliza a Impressão                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
oPrint:Preview()

Return(.T.)


Static Function FrSrfPai(cAliasSe2)
LOCAL nRegSE2:= NEWSE2->(Recno())
LOCAL lAchou:= .F.
LOCAL cPrefixo := (cAliasSe2)->E2_PREFIXO
LOCAL cNum		:= (cAliasSe2)->E2_NUM
LOCAL cParcela := (cAliasSe2)->E2_PARCELA
LOCAL cTipoPai	:= (cAliasSe2)->E2_TIPO
LOCAL cParcPai 
LOCAL cValorcPai 
Local aArea := GetArea()
Local lPai := .F.

If (cAliasSe2)->E2_TIPO $ MVTAXA+"/"+MVTXA
	If (cAliasSe2)->E2_FORNECE == GetMv("MV_MUNIC")
		cValorPai := "NEWSE2->E2_ISS" 
		cParcPai := "E2_PARCISS"
	Else
		Do Case 
		Case Alltrim((cAliasSe2)->E2_NATUREZ) $ AllTrim(GetMv("MV_PISNAT")) 
			cValorPai := "NEWSE2->E2_PIS"
			cParcPai := "E2_PARCPIS"
		Case Alltrim((cAliasSe2)->E2_NATUREZ) $ AllTrim(GetMv("MV_COFINS")) 
			cValorPai := "NEWSE2->E2_COFINS"
			cParcPai := "E2_PARCCOF"
		Case Alltrim((cAliasSe2)->E2_NATUREZ) $ AllTrim(GetMv("MV_CSLL")) 
			cValorPai := "NEWSE2->E2_CSLL"
			cParcPai := "E2_PARCSLL"
		OtherWise
			cValorPai := "NEWSE2->E2_IRRF"
			cParcPai := "E2_PARCIR"
		EndCase	
	Endif
Else
	lPai := .T.	                                                    	
Endif

// Se nao estiver no titulo pai, procura o titulo Pai.
If !lPai
	dbSelectArea("NEWSE2")
	dbSetOrder(1)
	nRegSE2:= Recno()
	If MsSeek(xFilial("SE2")+cPrefixo+cNum)
		While !Eof() .and. NEWSE2->(E2_FILIAL+E2_PREFIXO+E2_NUM) == xFilial("SE2")+cPrefixo+cNum
			If &(cParcPai) == cParcela .and. IIF(cTipoPai $ MVTXA,NEWSE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,.T.)
				If &(cValorPai) != 0
					lAchou := .T.
					Exit
				EndIf
			EndIf
			DbSkip()
		Enddo
	EndIf
Endif
	
dbSelectArea("NEWSE2")
// Se nao encontrou o registro pai, restaura o ponteiro do alias alternativo
// Pois o registro pode ja estar posicionado no titulo principal.
If !lAchou .And. !lPai
	dbGoto(nRegSE2)
Elseif !lAchou
	NEWSE2->(MsSeek(xFilial("SE2")+(cAliasSe2)->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
Endif	

Return lAchou

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GInfDARF ³ Autor ³Adrianne Furtado       ³ Data ³01/07/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gravacao as informações de controle da DARF - Tabela FI9   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GInfDARF()		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/	
user function GInfDARF(aRecno, nValorImp, cCodRet, nOpc, aVlr,cCNPJEst,dVenc)     
Local aFornec :=  {}  
Local nX            
Local cIdDArf 

If SE2->( FieldPos( "E2_IDDARF" )) > 0 .and. AliasIndic("FI9") //Select("FI9")>0
    FI9->(DBCloseArea())
	cIdDarf := GetSXENum("FI9", "FI9_IDDARF")
	ConfirmSX8()


	If nOpc == 2
		DbSelectArea("FI9")      
		For nx = 1 to Len(aRecno)
		
			SE2->(DBGoto(aRecno[nX]))
	   		If !Empty(SE2->E2_TITPAI)
				//No caso do titulo gerado ser um aglutinado, nao teremos um titulo pai cadastrado, pois podemos aglutinar titulos de N fornecedores
				aAdd(aFornec,{ TamSx3("E2_PREFIXO")[1] + TamSx3("E2_NUM")[1] + ;  
							   TamSx3("E2_PARCELA")[1] + TamSx3("E2_TIPO")[1] + 1, TamSx3("E2_FORNECE")[1]})
				aAdd(aFornec,{ aFornec[1,1] + TamSx3("E2_FORNECE")[1], TamSx3("E2_LOJA")[1]})  
	    		
				cFornec := SubStr(SE2->E2_TITPAI,aFornec[1,1],aFornec[1,2])
				cLoja   := SubStr(SE2->E2_TITPAI,aFornec[2,1],aFornec[2,2])
			Else
				cFornec := SE2->E2_FORNECE
				cLoja   := SE2->E2_LOJA
			Endif

			RecLock( "FI9", .T. )
			FI9->FI9_FILIAL	:= xFilial("FI9")
			FI9->FI9_IDDARF	:= cIdDarf
			FI9->FI9_EMISS	:= dDataBase
			FI9->FI9_PREFIX := SE2->E2_PREFIXO
			FI9->FI9_NUM	:= SE2->E2_NUM
			FI9->FI9_PARCEL := SE2->E2_PARCELA
			FI9->FI9_TIPO   := SE2->E2_TIPO
			FI9->FI9_FORNEC := cFornec
			FI9->FI9_LOJA  	:= cLoja
			FI9->FI9_VALOR  := aVlr[nX]
			FI9->FI9_STATUS	:= "A"
			FI9->FI9_CODRET	:= cCodRet
			FI9->FI9_FILCTR	:= aPergRet[8]	
			FI9->FI9_REFER	:= aPergRet[7]
			FI9->FI9_APURA  := aPergRet[6]
			FI9->FI9_PERIOD := SubStr(aPergRet[12],1,1)
			FI9->FI9_VENCIM := dVenc             
			FI9->FI9_INCORP := aPergRet[13]
			FI9->FI9_ESTABE := cCNPJEst            
			MsUnlock()
	
			RecLock( "SE2", .F. )
			SE2->E2_IDDARF	:= cIdDarf
			MsUnlock()   
		Next nX
	EndIf

	FI9->(DbCloseArea())
EndIf

Return
