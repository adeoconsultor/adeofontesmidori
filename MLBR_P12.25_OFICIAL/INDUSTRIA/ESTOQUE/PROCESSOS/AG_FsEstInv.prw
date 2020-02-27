#INCLUDE "PROTHEUS.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "MATA950.CH"                        
#INCLUDE "SHELL.CH"
STATIC cXMLStatic := ""

User Function AG_FsEstInv(aAlias,nTipo,lCliFor,lMovimen,dUltFec,lNCM,lST,lSelB5,cFiltraB5,aNFsProc,aProcCod,cFiltraB1,aProd,aProcesso)
Local aCampos   := {}
Local aSaldo    := {}
Local aTam		:= {}
Local cAliasSB1 := "SB1"
Local cQuery    := ""
Local cCNPJ     := ""
Local cInsc 	:= ""
Local cUf	  	:= ""
Local lQuery    := .F.
Local lCodPro   := .F.
Local nX        := 0
Local cMvEstado := GetMv("MV_ESTADO")
Local cAliasNCM := ""
Local cArqNCM   := ""
Local cNome		:= ""
Local cCodNome	:= ""
Local aUltMov	:= {}
Local cCodInv	:= GetNewPar("MV_CODINV","")
Local lA950PRD	:= Existblock("A950PRD")
Local aICMS		:= {}
Local c88Ind	:= ""
Local cProdIni  := ""
Local cProdFim  := ""
Local lProdNeg  := .F.
Local lProdZera := .F.
Local lCustZero := .F.
Local lProcesso := .F.
Local nProc		:= 0
Local cAliasProc:= ""    
Local nQtdProc 	:= 0
Local nCustoProc:= 0

#IFDEF TOP
	Local aStru     := {}
#ELSE
	Local c88Chave	:= ""
	Local c88Filtro	:= ""
	Local cIndSB6   := ""
	Local cChave    := ""
#ENDIF

Local lRgEspSt	:= GetNewPar("MV_RGESPST",.F.)
Local lUsaSFT	:= AliasInDic("SFT") .And. SFT->(FieldPos("FT_RGESPST")) > 0
Local aNCM		:= {}
Local cCorte88 	:= GetNewPar("MV_88CORTE","")
Local nCorte88 	:= Iif(!Empty(cCorte88),SB1->(FieldPos(cCorte88)),0)
Local dDTSTMG	:= GetNewPar("MV_DTSTMG",cTod("//"))


DEFAULT lCliFor 	:= .F.
DEFAULT lMovimen	:= .T.
DEFAULT dUltFec 	:= SuperGetMV("MV_ULMES")
DEFAULT lNCM    	:= .F.
DEFAULT lST			:= .F.
DEFAULT lSelB5		:= .F.
DEFAULT cFiltraB5	:= ""
DEFAULT cFiltraB1	:= ""
DEFAULT	aNFsProc	:= {}
DEFAULT	aProcCod	:= {}
DEFAULT aProd 	    := {}  
DEFAULT aProcesso	:= {}


//Alimento as variaveis dos filtros colocados para o registro de inventario quando são passados
//Algumas rotinas nao passam esse array como parametro para função FSESTINV acima e por isso só alimento
//as variaveis quando o parametro e diferente de vazio.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³aProd[01] = Produto de                                            ³
//³aProd[02] = Produto ate                                           ³
//³aProd[03] = Armazem de                                            ³
//³aProd[04] = Armazem ate                                           ³
//³aProd[05] = Saldo Negativo                                        ³
//³aProd[06] = Saldo Zerado                                          ³
//³aProd[07] = Saldo Terceiros (Sim, Nao, de terceiros, em terceiros)³
//³aProd[08] = Custo Zerado                                          ³
//³aProd[09] = Em processo                                           ³
//³aProd[10] = Data de Fechamento                                    ³
//³aProd[11] = MOD no Processo                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(aProd)
	cProdIni  := aProd[1]
	cProdFim  := aProd[2]
	lProdNeg  := (aProd[5]==1)
	lProdZera := (aProd[6]==1)
	lCustZero := (aProd[8]==1)             
	If Len(aProd) >= 11
		lProcesso := (aProd[9]==1)
	Endif 
EndIf

If !Empty(cFiltraB5) 
	lSelB5 := .T.
Endif                                                                           

If nTipo==1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica os saldos em processo quando a rotina solicitar³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lProcesso
		cAliasProc := FsProcesso(aProd,dUltFec,@aNCM,@aProcesso)	
	Endif
	
	If lST
		#IFNDEF TOP                         
			dbSelectArea("SD1")
			c88Ind		:=	CriaTrab(NIL,.F.)
			c88Chave	:=	"D1_NFORI+D1_SERIORI+D1_ITEMORI"
			c88Filtro	:=	"D1_FILIAL == '" + xFilial("SD1") + "' .And. "
			If !lRgEspSt
				c88Filtro	+=	"D1_TIPO $ 'P/I/C' .And. D1_ICMSRET > 0 .And. Dtos(D1_DTDIGIT) < '" + Dtos(dUltFec) + "'"
			Else
				c88Filtro	+=	"D1_TIPO $ 'P/I/C' .And. Dtos(D1_DTDIGIT) < '" + Dtos(dUltFec) + "'"
			Endif
			IndRegua("SD1",c88Ind,c88Chave,,c88Filtro,Nil,.F.)
			dbClearIndex()	
			RetIndex("SD1")
			dbSetIndex(c88Ind+OrdBagExt())
			dbSetOrder(1)
		#ENDIF
	Endif

	PRIVATE nIndSb6 := 0
	#IFNDEF TOP
		dbSelectArea("SB6")
		cIndSB6 := CriaTrab(Nil,.F.)
		cChave := "B6_FILIAL+B6_PRODUTO+B6_LOCAL+B6_TIPO+DTOS(B6_DTDIGIT)"
		cQuery := 'B6_FILIAL="'+xFilial("SB6")+'" .And. DtoS(B6_DTDIGIT)<="'+Dtos(dUltFec)+'"'
		IndRegua("SB6",cIndSB6,cChave,,cQuery,Nil,.F.)
		nIndSB6:=RetIndex("SB6")
		dbSetIndex(cIndSB6+OrdBagExt())
		dbSetOrder(nIndSB6 + 1)
		dbGoTop()
	#ENDIF
	
	aadd(aCampos,{"CODIGO" ,"C",TamSx3("B1_COD")[1],0})
	aadd(aCampos,{"CODPRD" ,"C",TamSx3("B1_COD")[1],0})
	aadd(aCampos,{"NCM"    ,"C",14,0})
	aadd(aCampos,{"UM"     ,"C",02,0})
	aadd(aCampos,{"SITUACA","C",01,0})
	aadd(aCampos,{"QUANT"  ,"N",19,3})
	aadd(aCampos,{"CUSTO"  ,"N",19,3})
	aadd(aCampos,{"CNPJ"   ,"C",14,0})
	aTam:=TamSX3("A2_INSCR")
	aadd(aCampos,{"INSCR"  ,"C",aTam[1],0})
	aadd(aCampos,{"UF"     ,"C",02,0})
	aadd(aCampos,{"NOME"   ,"C",40,0})
	aadd(aCampos,{"CODNOME","C",06,0})
	aadd(aCampos,{"BASEST" ,"N",14,2})
	aadd(aCampos,{"VALST"  ,"N",14,2})
	aadd(aCampos,{"VALICMS","N",14,2})	//Valor do ICMS Operacao Propria
	aadd(aCampos,{"ICMSRET","N",14,2})	//Valor do ICMS ST
	aadd(aCampos,{"ALIQST" ,"N",05,2})
	aadd(aCampos,{"CODINV" ,"C",01,0})		//Campo utilizado pelo o SEF-PE
	aadd(aCampos,{"TIPO"   ,"C",TamSX3("B1_TIPO")[1],0}) //Campo com o tipo do produto
	aadd(aCampos,{"DESC_PRD" ,"C",50,0})	//Descricao produto
	aadd(aCampos,{"CLASSFIS" ,"C",02,0})	//Classificacao Fiscal
	aadd(aCampos,{"BASEICMS" ,"N",14,2})   //Base ICMS Proprio
	aAlias[2] := CriaTrab(aCampos,.T.)
	dbUseArea(.T.,__LocalDrive,aAlias[2],aAlias[1],.F.,.F.)

	dbSelectArea("SB1")
	dbSetOrder(1)
	#IFDEF TOP
		aStru     := SB1->(dbStruct())
		cAliasSB1 := "FSESTINV"
		lQuery    := .T.

		cQuery := "SELECT B1_FILIAL, B1_TIPO, B1_COD, B1_DESC, B1_UM, B1_POSIPI, B1_PICMENT, B1_PICM, B1_CLASFIS, B1_CODBAR "
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica a data de corte para consideracao do Sintegra-MG³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nCorte88 > 0
			cQuery += ", " + Alltrim(cCorte88) + " "
		Endif
		cQuery += "FROM "+RetSqlName("SB1")+" SB1 "               
		If lSelB5
			cQuery += " , "+RetSqlName("SB5")+" SB5 "               
		Endif
		cQuery += "WHERE SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
		
		cQuery += "SB1.D_E_L_E_T_=' ' "
		If lSelB5
			cQuery += " AND SB5.B5_FILIAL = '"+xFilial("SB5")+"'"
			cQuery += " AND SB5.B5_COD = SB1.B1_COD "
			cQuery += " AND SB5.D_E_L_E_T_=' ' "
		Endif
		If !Empty(cFiltraB5)			
			cQuery += cFiltraB5 + ' ' 
		Endif
		cQuery += "ORDER BY "+SqlOrder(SB1->(IndexKey()))

		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1)

		For nX := 1 To Len(aStru)
			If aStru[nX][2] <> "C"
				TcSetField(cAliasSB1,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX

	#ELSE
		MsSeek(xFilial("SB1"))
	#ENDIF
	While !Eof() .And. (cAliasSB1)->B1_FILIAL == xFilial("SB1")

		If !Empty(cFiltraB1) .And. !(cAliasSB1)->B1_TIPO $cFiltraB1 
			(cAliasSB1)->(dbSkip())
			Loop
		EndIf
		If !Empty(aProd)   
			If !((cAliasSB1)->B1_COD>=cProdIni .And. (cAliasSB1)->B1_COD<=cProdFim)
				(cAliasSB1)->(dbSkip())
				Loop
			EndIf 
		EndIf	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se devera ser considerado o SB5 na geracao do estoque³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lSelB5 .And. !lQuery
			SB5->(dbSetOrder(1))
			If !(SB5->(dbSeek(xFilial("SB5")+(cAliasSB1)->B1_COD)))
				(cAliasSB1)->(dbSkip())
				Loop
			Endif
			If !Empty(cFiltraB5)
				If !(&cFiltraB5)
					(cAliasSB1)->(dbSkip())
					Loop
				Endif
			Endif
		Endif
		If !lCodPro .And. Len(AllTrim((cAliasSB1)->B1_COD))>=15 .And. !lA950PRD
			lCodPro := .T.
		EndIf

		If lST
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica a data de corte pelo produto ou mantem pelo parametro³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nCorte88 > 0 .And. !Empty((cAliasSB1)->&(cCorte88))
				dDtStMG := (cAliasSB1)->&(cCorte88)
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Apenas processa o saldo dos produtos que estiverem dentro           ³
			//³da data de corte estipulada, no caso do processamento do Sintegra MG³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If dDtStMG > dUltFec
				(cAliasSB1)->(dbSkip())
				Loop
			Endif
		Endif
		aSaldo := U_AG_FsPrdInv((cAliasSB1)->B1_COD,lCliFor,dUltFec,aProd,.T.)
		//		FsPrdInv((cAliasSB1)->B1_COD,lCliFor,dUltFec,aProd,.T.)

        //Se aSaldo retornar vazio é pq o produto nao existe no estoque e portanto nao sera considerado pois o Len de aSaldo retornará 0 e não irá incluir o produto
        //Mas se o parametro lMoviment estiver como True devo considerar o produto como a rotina funcionava antes
        If lMovimen
        	If Empty(aSaldo)
				aSaldo := {{0,0,1,""},{0,0,2,""},{0,0,3,""}}
			EndIf
        EndIf
        
		For nX := 1 To Len(aSaldo)
			If aSaldo[nX][1]<>0 .Or. aSaldo[nX][3]==1
				If !Empty(aSaldo[nX][4])
					If SubStr(aSaldo[nX][4],1,1)=="C"
						dbSelectArea("SA1")
						dbSetOrder(1)
						MsSeek(xFilial("SA1")+SubStr(aSaldo[nX][4],2))
						cCNPJ 		:= SA1->A1_CGC
						cInsc 		:= SA1->A1_INSCR
						cUf	  		:= SA1->A1_EST
						cNome		:= SubStr(SA1->A1_NOME,1,40)
						cCodNome 	:= SA1->A1_COD
					Else
						dbSelectArea("SA2")
						dbSetOrder(1)
						MsSeek(xFilial("SA2")+SubStr(aSaldo[nX][4],2))
						cCNPJ		:= SA2->A2_CGC
						cInsc 		:= SA2->A2_INSCR
						cUf	  		:= SA2->A2_EST
						cNome 		:= SubStr(SA2->A2_NOME,1,40)
						cCodNome 	:= SA1->A1_COD
					EndIf
				Else
					cCNPJ := SM0->M0_CGC
					cINSC := SM0->M0_INSC
					cUf	  := cMvEstado
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Busca no temporario o saldo em processo do produto - se existir³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			    nQtdProc 	:= 0
			    nCustoProc 	:= 0
				If lProcesso  
				   (cAliasProc)->(dbSetOrder(2))
				   If (cAliasProc)->(dbSeek((cAliasSB1)->B1_COD))
					   nQtdProc 	:= 0 //(cAliasProc)->QUANTIDADE
					   nCustoProc 	:= 0 //(cAliasProc)->TOTAL
				   Endif
				Endif
				
				If lMovimen
					RecLock(aAlias[1],.T.)
					(aAlias[1])->DESC_PRD := (cAliasSB1)->B1_DESC
					(aAlias[1])->CODIGO := IIf(lA950PRD,Execblock("A950PRD",.F.,.F.,{cAliasSB1}),(cAliasSB1)->B1_COD)
					(aAlias[1])->CODPRD := (cAliasSB1)->B1_COD
					(aAlias[1])->UM     := (cAliasSB1)->B1_UM
					(aAlias[1])->SITUACA:= StrZero(aSaldo[nX][3],1)
					(aAlias[1])->QUANT  := aSaldo[nX][1] + nQtdProc
					(aAlias[1])->CUSTO  := aSaldo[nX][2] + nCustoProc
					(aAlias[1])->CNPJ   := cCNPJ
					(aAlias[1])->INSCR  := cINSC
					(aAlias[1])->UF   	 := cUF
					(aAlias[1])->NCM   	 := (cAliasSB1)->B1_POSIPI
					(aAlias[1])->NOME  	 := cNome
					(aAlias[1])->CODNOME := cCodNome
					(aAlias[1])->TIPO	:= (cAliasSB1)->B1_TIPO
					If At((cAliasSB1)->B1_TIPO+"=",cCodInv) > 0
						(aAlias[1])->CODINV := Substr(cCodInv,At((cAliasSB1)->B1_TIPO+"=",cCodInv)+3,1)
					Else
						(aAlias[1])->CODINV := "1"	//Mercadorias
					Endif
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica o valor do ICMS Subst. Tributaria da ultima entrada, de acordo com o parametro³
					//³Apenas para os produtos que possuem a aliquota do ICMS ST entrada em seu cadastro.     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lST .And. ((!lRgEspSt .And. (cAliasSB1)->B1_PICMENT > 0) .Or. lRgEspSt)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0
						//³Somente verifica as ultimas entradas de composicao do estoque³
						//³se existirem movimentos de saida (processados pelo Mata940 - ³
						//³funcao a94088MG).                                            ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0
						nProc := aScan(aProcCod,{|x| x[1]==(aAlias[1])->CODPRD})
						If nProc > 0 .And. aProcCod[nProc][3]
							aICMS := RetTotICMS((cAliasSB1)->B1_COD,dUltFec,aSaldo[nX][1],c88Ind,@aNFsProc,lRgEspSt,lUsaSFT,(cAliasSB1)->B1_PICMENT,dDtStMG)
							(aAlias[1])->VALICMS := aICMS[1]	//ICMS Proprio
							(aAlias[1])->ICMSRET := aICMS[2]	//ICMS ST
							(aAlias[1])->BASEST  := aICMS[3]
							(aAlias[1])->BASEICMS:= aICMS[4]
						Endif
					Endif
					(aAlias[1])->CLASSFIS	:= (cAliasSB1)->B1_CLASFIS
					MsUnLock()
				Else
					If aSaldo[nX][1]>0 .And. aSaldo[nX][2]>0 .OR. (lProdNeg .And. aSaldo[nX][1]< 0)  .OR. (lProdZera .And. aSaldo[nX][1]==0) .OR. (lCustZero .And. aSaldo[nX][2]==0) .OR. (lProcesso .And. nQtdProc > 0)
						RecLock(aAlias[1],.T.)
						(aAlias[1])->DESC_PRD := (cAliasSB1)->B1_DESC
						(aAlias[1])->CODIGO := IIf(lA950PRD,Execblock("A950PRD",.F.,.F.,{cAliasSB1}),(cAliasSB1)->B1_COD)
						(aAlias[1])->CODPRD := (cAliasSB1)->B1_COD
						(aAlias[1])->UM     := (cAliasSB1)->B1_UM
						(aAlias[1])->SITUACA:= StrZero(aSaldo[nX][3],1)
						(aAlias[1])->QUANT  := aSaldo[nX][1] + nQtdProc
						(aAlias[1])->CUSTO  := aSaldo[nX][2] + nCustoProc
						(aAlias[1])->CNPJ   := cCNPJ
						(aAlias[1])->INSCR  := cINSC
						(aAlias[1])->UF   	 := cUF
						(aAlias[1])->NCM     := (cAliasSB1)->B1_POSIPI
						(aAlias[1])->NOME  	  := cNome
						(aAlias[1])->CODNOME := cCodNome
						(aAlias[1])->TIPO	:= (cAliasSB1)->B1_TIPO
						If At((cAliasSB1)->B1_TIPO+"=",cCodInv) > 0
							(aAlias[1])->CODINV := Substr(cCodInv,At((cAliasSB1)->B1_TIPO+"=",cCodInv)+3,1)
						Else
							(aAlias[1])->CODINV := "1"	//Mercadorias
						Endif
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica o valor do ICMS Subst. Tributaria da ultima entrada, de acordo com o parametro³
						//³Apenas para os produtos que possuem a aliquota do ICMS ST entrada em seu cadastro.     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lST .And. ((!lRgEspSt .And. (cAliasSB1)->B1_PICMENT > 0) .Or. lRgEspSt)   
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0
							//³Somente verifica as ultimas entradas de composicao do estoque³
							//³se existirem movimentos de saida (processados pelo Mata940 - ³
							//³funcao a94088MG).                                            ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0
							nProc := aScan(aProcCod,{|x| x[1]==(aAlias[1])->CODPRD})
							If nProc > 0 .And. aProcCod[nProc][3]
								aICMS := RetTotICMS((cAliasSB1)->B1_COD,dUltFec,aSaldo[nX][1],c88Ind,@aNFsProc,lRgEspSt,lUsaSFT,(cAliasSB1)->B1_PICMENT,dDtStMG)
								(aAlias[1])->VALICMS := aICMS[1]	//ICMS Proprio
								(aAlias[1])->ICMSRET := aICMS[2]	//ICMS ST							
								(aAlias[1])->BASEST  := aICMS[3]   //Base ICMS ST
								(aAlias[1])->BASEICMS := aICMS[4]	//Base ICMS Proprio
							Endif
						Endif
						(aAlias[1])->CLASSFIS	:= (cAliasSB1)->B1_CLASFIS
						MsUnLock()
					Endif
				Endif
			EndIf
		Next nX
		dbSelectArea(cAliasSB1)
		dbSkip()
	EndDo
	If lQuery
		dbSelectArea(cAliasSB1)
		dbCloseArea()
		dbSelectArea("SB1")
	EndIf
	#IFNDEF TOP
		dbSelectArea("SB6")
		RetIndex("SB6")
		Ferase(cIndSB6+OrdBagExt())
	#ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se os produtos devem ser aglutinados por NCM                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lNCM
		cAliasNCM := GetNextAlias()
		cArqNCM   := CriaTrab(aCampos,.T.)
		dbUseArea(.T.,__LocalDrive,cArqNCM,cAliasNCM,.F.,.F.)

		If lCodPro
			IndRegua(cAliasNCM,cArqNCM,"NCM+SITUACA+CNPJ+INSCR",,,Nil,.F.)	//?Por NCM
		Else
			IndRegua(cAliasNCM,cArqNCM,"CODIGO+SITUACA+CNPJ+INSCR",,,Nil,.F.)	//Por codigo produto
		EndIf

		dbSelectArea(aAlias[1])
		dbGotop()
		While !Eof()      
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Busca no array de aglutinacao dos NCMs os saldos em processo³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    nQtdProc 	:= 0
		    nCustoProc 	:= 0
			If lProcesso  
				nPosNCM := aScan(aNCM,{|x| x[1] == (aAlias[1])->NCM}) 
				If nPosNCM > 0
				    nQtdProc 	:= aNCM[nPosNCM][02]
				    nCustoProc 	:= aNCM[nPosNCM][03]
				Endif
			Endif
		
			dbSelectArea(cAliasNCM)
			If MsSeek(Iif (lCodPro, (aAlias[1])->NCM, (aAlias[1])->CODIGO)+(aAlias[1])->SITUACA+(aAlias[1])->CNPJ+(aAlias[1])->INSCR)
				RecLock(cAliasNCM,.F.)
			Else
				RecLock(cAliasNCM,.T.)
			EndIf
			(cAliasNCM)->DESC_PRD	:=	(aAlias[1])->DESC_PRD
			(cAliasNCM)->CODIGO 	:= Iif (lCodPro, (aAlias[1])->NCM, (aAlias[1])->CODIGO)
			(cAliasNCM)->CODPRD 	:= (aAlias[1])->CODPRD
			(cAliasNCM)->UM     	:= (aAlias[1])->UM
			(cAliasNCM)->SITUACA	:= (aAlias[1])->SITUACA
			(cAliasNCM)->QUANT  	+= (aAlias[1])->QUANT + nQtdProc
			(cAliasNCM)->CUSTO  	+= (aAlias[1])->CUSTO + nCustoProc
			(cAliasNCM)->CNPJ   	:= (aAlias[1])->CNPJ
			(cAliasNCM)->INSCR  	:= (aAlias[1])->INSCR
			(cAliasNCM)->UF   		:= (aAlias[1])->UF
			(cAliasNCM)->NCM   		:= (aAlias[1])->NCM
			(cAliasNCM)->NOME   	:= (aAlias[1])->NOME
			(cAliasNCM)->CODNOME	:= (aAlias[1])->CODNOME
			(cAliasNCM)->BASEST 	+= (aAlias[1])->BASEST
			(cAliasNCM)->VALST		+= (aAlias[1])->VALST
			(cAliasNCM)->ALIQST		:= (aAlias[1])->ALIQST
			(cAliasNCM)->TIPO		:= (aAlias[1])->TIPO
			(cAliasNCM)->VALICMS	+= (aAlias[1])->VALICMS	//ICMS Operacoes Proprias
			(cAliasNCM)->ICMSRET	+= (aAlias[1])->ICMSRET	//ICMS ST
			If At((aAlias[1])->TIPO+"=",cCodInv) > 0
				(cAliasNCM)->CODINV := Substr(cCodInv,At((aAlias[1])->TIPO+"=",cCodInv)+3,1)
			Else
				(cAliasNCM)->CODINV := "1"	//Mercadorias
			Endif
			(cAliasNCM)->CLASSFIS	:= (aAlias[1])->CLASSFIS
			MsUnLock()
			dbSelectArea(aAlias[1])
			dbSkip()
		EndDo
		dbSelectArea(aAlias[1])
		dbCloseArea()
		dbSelectArea(cAliasNCM)
		dbCloseArea()
		FErase(cAliasNCM+OrdBagExt())
		FErase(aAlias[2]+GetDbExtension())
		aAlias[2] := cArqNCM
		dbUseArea(.T.,__LocalDrive,aAlias[2],aAlias[1],.F.,.F.)
	EndIf
	If lST
		#IFNDEF TOP
			dbSelectArea("SD1")
			RetIndex("SD1")
			FErase(c88Ind+OrdBagExt())
		#ENDIF		
	Endif
Else
	dbSelectArea(aAlias[1])
	dbCloseArea()
	FErase(aAlias[2]+GetDbExtension())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exclui temporario criado para gerar os saldos em processo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aProcesso) > 0
		dbSelectArea(aProcesso[2])
		dbCloseArea()
		FErase(aProcesso[1]+GetDbExtension())
	Endif               
	
	dbSelectArea("SM0")
EndIf
Return(.T.)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function AG_FsPrdInv(cCodPro,lCliFor,dUltFec,aProd,lValidEst)

Local aArea     := GetArea()
Local aSaldo    :={}
Local aRetorno  := {}
Local cQuery    :=""
Local cAliasSB9 := "SB9"
Local lQuery    := .F.
Local nX        := 0
Local nY        := 0
Local lProdTerc := .F.

DEFAULT lValidEst := .F.
DEFAULT aProd 	  := {}
dUltFec := Iif(Empty(dUltFec),SuperGetMv("MV_ULMES"),dUltfec)

//Alimento as variaveis dos filtros colocados para o registro de inventario quando são passados
//Algumas rotinas nao passam esse array como parametro para função FsPrdInv acima e por isso só alimento
//as variaveis quando o parametro e diferente de vazio.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³aProd[01] = Produto de                                            ³
//³aProd[02] = Produto ate                                           ³
//³aProd[03] = Armazem de                                            ³
//³aProd[04] = Armazem ate                                           ³
//³aProd[05] = Saldo Negativo                                        ³
//³aProd[06] = Saldo Zerado                                          ³
//³aProd[07] = Saldo Terceiros (Sim, Nao, de terceiros, em terceiros)³
//³aProd[08] = Custo Zerado                                          ³
//³aProd[09] = Em processo                                           ³
//³aProd[10] = Data de Fechamento                                    ³
//³aProd[11] = MOD no Processo                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(aProd)
	cAlmoxIni := aProd[3]
	cAlmoxFim := aProd[4]
	lProdTerc := .F.//(aProd[7]<>2)
EndIf

dbSelectArea("SB9")
dbSetOrder(1)

#IFDEF TOP  
	If TcSrvType()<>"AS/400"
		lQuery := .T.
	Endif
#ENDIF

If lQuery
   	cAliasSB9 := "FSPRDINV"
	cQuery := "SELECT B9_FILIAL,B9_COD,B9_LOCAL,B9_QINI,B9_VINI1,B9_DATA "
	cQuery += "FROM "+RetSqlName("SB9")+" SB9 "
	cQuery += "WHERE SB9.B9_FILIAL='"+xFilial("SB9")+"' AND "
	cQuery += "SB9.B9_COD='"+cCodPro+"' AND "
	If !Empty(aProd)
		cQuery += "SB9.B9_LOCAL>='"+cAlmoxIni+"' AND "	
		cQuery += "SB9.B9_LOCAL<='"+cAlmoxFim+"' AND "
	EndIf
	cQuery += "SB9.B9_DATA='"+Dtos(dUltFec)+"' AND "
	cQuery += "SB9.D_E_L_E_T_=' ' "
   	If ExistBlock("MA950QRY")
		cQuery := ExecBlock("MA950QRY",.F.,.F.,{cQuery})  // adiciona campos na query
	EndIf  
	cQuery += "ORDER BY "+SqlOrder(SB9->(IndexKey()))

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB9)
	TcSetField(cAliasSB9,"B9_DATA","D",8,0)
	TcSetField(cAliasSB9,"B9_QINI","N",TamSx3("B9_QINI")[1],TamSx3("B9_QINI")[2])
	TcSetField(cAliasSB9,"B9_VINI1","N",TamSx3("B9_VINI1")[1],TamSx3("B9_VINI1")[2])

Else
	MsSeek(xFilial("SB9")+cCodPro)
Endif

While (!Eof() .And. IIf(lQuery,.T.,(cAliasSB9)->B9_FILIAL == xFilial("SB9") .And.;
		(cAliasSB9)->B9_COD == cCodPro .And. Iif(!Empty(aProd),(cAliasSB9)->B9_LOCAL >= cAlmoxIni .And.;
		(cAliasSB9)->B9_LOCAL<=cAlmoxFim,.T.)))

	If (cAliasSB9)->B9_DATA == dUltFec
		If ExistBlock('MA950INV')
            aRetorno:= ExecBlock( 'MA950INV', .F., .F., {cAliasSB9}) // Implementa array conforme regra do cliente
            If ValType(aRetorno)<>'A'
                aRetorno := {(cAliasSB9)->B9_QINI,(cAliasSB9)->B9_VINI1}
            EndIf 
        Else
			aRetorno := {(cAliasSB9)->B9_QINI,(cAliasSB9)->B9_VINI1}
		EndIf
		nY := aScan(aSaldo,{|x| x[3] == 1 .And. x[4]==""})
		If nY==0
			aadd(aSaldo,{aRetorno[1],aRetorno[2],1,""})
		Else
			aSaldo[nY][1] += aRetorno[1]
			aSaldo[nY][2] += aRetorno[2]
			aSaldo[nY][3] := 1
			aSaldo[nY][4] := ""
		EndIf
		If lProdTerc //Considera Terceiro
			If Empty(aProd)//Senao foi passado nenhum parametro considero tudo
				aRetorno := SaldoTerc(cCodPro,(cAliasSB9)->B9_LOCAL,"T",dUltFec,(cAliasSB9)->B9_LOCAL,lCliFor) //De terceiro
				If lCliFor
					For nX := 1 To Len(aRetorno)
						nY := aScan(aSaldo,{|x| x[3] == 2 .And. x[4]==aRetorno[nX][1]})
						If nY==0
							aadd(aSaldo,{aRetorno[nX][2],aRetorno[nX][3],2,aRetorno[nX][1]})
						Else
							aSaldo[nY][1] += aRetorno[nX][2]
							aSaldo[nY][2] += aRetorno[nX][3]
							aSaldo[nY][3] := 2
							aSaldo[nY][4] := aRetorno[nX][1]
						EndIf
					Next nX
				Else
					nY := aScan(aSaldo,{|x| x[3] == 2 })
					If nY == 0
						aadd(aSaldo,{aRetorno[1],aRetorno[2],2,""})
					Else
						aSaldo[nY][1] += aRetorno[1]
						aSaldo[nY][2] += aRetorno[2]
					EndIf
				EndIf
				aRetorno := SaldoTerc(cCodPro,(cAliasSB9)->B9_LOCAL,"D",dUltFec,(cAliasSB9)->B9_LOCAL,lCliFor) //Em terceiro
				If lCliFor
					For nX := 1 To Len(aRetorno)
						nY := aScan(aSaldo,{|x| x[3] == 3 .And. x[4]==aRetorno[nX][1]})
						If nY==0
							aadd(aSaldo,{aRetorno[nX][2],aRetorno[nX][3],3,aRetorno[nX][1]})
						Else
							aSaldo[nY][1] += aRetorno[nX][2]
							aSaldo[nY][2] += aRetorno[nX][3]
							aSaldo[nY][3] := 3
							aSaldo[nY][4] := aRetorno[nX][1]
						EndIf
					Next nX
				Else
					nY := aScan(aSaldo,{|x| x[3] == 3 })
					If nY == 0
						aadd(aSaldo,{aRetorno[1],aRetorno[2],3,""})
					Else
						aSaldo[nY][1] += aRetorno[1]
						aSaldo[nY][2] += aRetorno[2]
					EndIf
				EndIf
			Else
				If aProd[7]==1 .OR. aProd[7]==3
					aRetorno := SaldoTerc(cCodPro,(cAliasSB9)->B9_LOCAL,"T",dUltFec,(cAliasSB9)->B9_LOCAL,lCliFor) //De terceiro
					If lCliFor
						For nX := 1 To Len(aRetorno)
							nY := aScan(aSaldo,{|x| x[3] == 2 .And. x[4]==aRetorno[nX][1]})
							If nY==0
								aadd(aSaldo,{aRetorno[nX][2],aRetorno[nX][3],3,aRetorno[nX][1]})
							Else
								aSaldo[nY][1] += aRetorno[nX][2]
								aSaldo[nY][2] += aRetorno[nX][3]
								aSaldo[nY][3] := 2
								aSaldo[nY][4] := aRetorno[nX][1]
							EndIf
						Next nX
					Else
						nY := aScan(aSaldo,{|x| x[3] == 2 })
						If nY == 0
							aadd(aSaldo,{aRetorno[1],aRetorno[2],2,""})
						Else
							aSaldo[nY][1] += aRetorno[1]
							aSaldo[nY][2] += aRetorno[2]
						EndIf
					EndIf
				EndIf
				If aProd[7]==1 .OR. aProd[7]==4
					aRetorno := SaldoTerc(cCodPro,(cAliasSB9)->B9_LOCAL,"D",dUltFec,(cAliasSB9)->B9_LOCAL,lCliFor) //Em terceiro
					If lCliFor
						For nX := 1 To Len(aRetorno)
							nY := aScan(aSaldo,{|x| x[3] == 3 .And. x[4]==aRetorno[nX][1]})
							If nY==0
								aadd(aSaldo,{aRetorno[nX][2],aRetorno[nX][3],2,aRetorno[nX][1]})
							Else
								aSaldo[nY][1] += aRetorno[nX][2]
								aSaldo[nY][2] += aRetorno[nX][3]
								aSaldo[nY][3] := 3
								aSaldo[nY][4] := aRetorno[nX][1]
							EndIf
						Next nX
					Else
						nY := aScan(aSaldo,{|x| x[3] == 3 })
						If nY == 0
							aadd(aSaldo,{aRetorno[1],aRetorno[2],3,""})
						Else
							aSaldo[nY][1] += aRetorno[1]
							aSaldo[nY][2] += aRetorno[2]
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf	
	EndIf
	dbSelectArea(cAliasSB9)
	dbSkip()
EndDo
If lQuery
	dbSelectArea(cAliasSB9)
	dbCloseArea()
	dbSelectArea("SB9")
EndIf

//Se Valido a Existencia do produto em Estoque e o mesmo não é encontrado Retorno o Saldo vazio
//Senao retorno o Saldo com zero.
If !lValidEst
	If Empty(aSaldo)
		aSaldo := {{0,0,1,""},{0,0,2,""},{0,0,3,""}}
	EndIf
EndIf
		
RestArea(aArea)
Return(aSaldo)


