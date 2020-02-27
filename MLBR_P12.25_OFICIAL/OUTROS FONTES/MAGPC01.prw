
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAGPC01   ºAutor  ³PrimaInfo           º Data ³  10/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Calculo customizado para ATS, utiliza tabela RCC e        º±±
±±º          ³ relaciona com o codigo do Sindicato                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - Midori                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User FuncTion MAGPC01()

Local nCarenc := 0
Local nTpCasa := 0
Local dDtIni  := Ctod(" /  /    ")
Local nPerc   := 0
Local nTeto   := 0
Local aAtArea := GetAREA()
Local nValor  := 0
Local nIdade  := 0
Local nTotPer := 0
Local dDtCare := Ctod(" /  /    ")
Local cVerPg  := ""

dbSelectArea("RCC")
dbSetOrder(1)
dbSeek(xFilial("RCC")+"U003")

While !RCC->(Eof())
	
	If Substr(RCC->RCC_CONTEU,1,2)==SRA->RA_SINDICA
		nCarenc := Val(Substr(RCC->RCC_CONTEU,3,2))
		nTpCasa := Val(Substr(RCC->RCC_CONTEU,5,2))
		dDtIni  := Stod(Substr(RCC->RCC_CONTEU,7,8))
		nPerc   := Val(Substr(RCC->RCC_CONTEU,15,6))
		nTeto   := Val(Substr(RCC->RCC_CONTEU,21,6))
		cVerPg  := Substr(RCC->RCC_CONTEU,27,3)
	EndIf
	
	RCC->(dbSkip())
	
EndDo

If nPerc > 0 .And. dDtIni = CtoD(" /  /    ") .And. cVerPg <>""
	//Calcula Tempo de Casa
	nIdade := Int((dDataBase - SRA->RA_ADMISSA)/365.25)
	//Verifica se tem o minimo de tempo de casa
	If nIdade >= nCarenc
		nTotPer += nPerc
		//Verifica o percentual total
		If Int((nIdade - nCarenc)/nTpCasa) > 0
			nTotPer += (nPerc * Int((nIdade - nCarenc)/nTpCasa))
		EndIf
	EndIf
	
	If nTotPer > 0
		//Verifica o teto
		nTotPer := Min(nTotPer,nTeto)
		nValor  := SalMes * (nTotPer /100)
	EndIf
	
	If nValor > 0
		FGERAVERBA(cVerPg,nValor,nTotPer,,,,,,,,.F.,)
	EndIf
	
EndIf

If nPerc > 0 .And. dDtIni <> CtoD(" /  /    ").And. cVerPg <>""
	//Monta nova data de inicio
	dDtCare := Ctod(Substr(DTOS(SRA->RA_ADMISSA),7,2)+"/"+Substr(DTOS(SRA->RA_ADMISSA),5,2)+"/"+StrZero((Year(SRA->RA_ADMISSA)+nCarenc),4))
	//se admissao antes da carencia
	If dDtCare <= dDtIni
		//Calcula Tempo de Casa
		nIdade := Int((dDataBase-dDtIni)/365.25)
		//Verifica se tem o minimo de tempo de casa
		If nIdade >= nTpCasa
			nTotPer += nPerc
			//Verifica o percentual total
			If Int((nIdade - nTpCasa)/nTpCasa) > 0
				nTotPer += (nPerc * Int((nIdade - nTpCasa)/nTpCasa))
			EndIf
		EndIf
		
		If nTotPer > 0
			//Verifica o teto
			nTotPer := Min(nTotPer,nTeto)
			nValor  := SalMes * (nTotPer /100)
		EndIf
		//Grava a verba no movimento
		If nValor > 0
			FGERAVERBA(cVerPg,nValor,nTotPer,,,,,,,,.F.,)
		EndIf
	
	Else	//se admissao antes da carencia		
		//Calcula tempo de casa
		nIdade := Int((dDataBase-SRA->RA_ADMISSA)/365.25)
		
		If nIdade >= nCarenc
			nTotPer += 0//nPerc
			//Verifica o percentual total
			If Int((nIdade - nCarenc)/nTpCasa) > 0
				nTotPer += (nPerc * Int((nIdade - nCarenc)/nTpCasa))
			EndIf
		EndIf
		If nTotPer > 0
			//Verifica o teto
			nTotPer := Min(nTotPer,nTeto)
			nValor  := SalMes * (nTotPer /100)
		EndIf
		//grava valor
		If nValor > 0
			FGERAVERBA(cVerPg,nValor,nTotPer,,,,,,,,.F.,)
		EndIf
		
	EndIf
	
EndIf


RestArea(aAtArea)

Return(0)
