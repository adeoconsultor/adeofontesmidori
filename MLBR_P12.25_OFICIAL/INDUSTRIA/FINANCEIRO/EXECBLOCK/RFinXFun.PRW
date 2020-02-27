#include 'protheus.ch'
/*
----------------------------------------------------------------------------
Programa : RFINXFUN                            				Data: 06/07/2010
Descricao: Funcoes especificas do FINANCEIRO
----------------------------------------------------------------------------
Funcao   : RFINXF01()                          				Data: 06/07/2010
Descricao: Retorna campos do cadastro de Empresas (SM0)
----------------------------------------------------------------------------
Uso : Arquivo de Configuraçao pagto tributos Bradesco
----------------------------------------------------------------------------
Parametros: cExpr = 1 --> Nome Comercial
					2 --> Endereco
					3 --> Cep                   
					4 --> Estado
					5 --> Cidade
					6 --> Bairro
					7 --> CNPJ
----------------------------------------------------------------------------
*/
User Function RFinXF01(cPar)
Local cRet := ""

SM0->(MsSeek(cEmpAnt + SE2->E2_PREFIXO)) 	//PEGA A FILIAL DO TITULO
                
If 	   cPar == '1'
	cRet := Substr(SM0->M0_NOMECOM,1,40)
ElseIf cPar == '2'
	cRet := Substr(SM0->M0_ENDENT,1,40)
ElseIf cPar == '3'	
	cRet := Substr(SM0->M0_CEPENT,1,8)
ElseIf cPar == '4'	
	cRet := SM0->M0_ESTENT                            
ElseIf cPar == '5'	
	cRet := Substr(SM0->M0_CIDENT,1,20)
ElseIf cPar == '6'	
	cRet := Substr(SM0->M0_BAIRENT,1,20) 
ElseIf cPar == '7'	
	If SE2->E2_X_CODRE == '2631' .OR. SE2->E2_X_CODRE == '2658'
	 	cRet :=	Posicione("SA2",1,xFilial("SA2")+Substr(SE2->E2_X_FORIG,1,6)+Substr(SE2->E2_X_FORIG,9,2),"A2_CGC")
	 	//cRet :=	STRZERO(VAL(Posicione("SA2",1,xFilial("SA2")+Substr(SE2->E2_X_FORIG,1,6)+Substr(SE2->E2_X_FORIG,9,2),"A2_CGC"),15))
	 Else
	 	cRet := STRZERO(VAL(SM0->M0_CGC),15)
     EndIf
ElseIf cPar == '8'
	cRet := STRZERO(VAL(SM0->M0_CGC),15)                                
EndIf                                                   

Return(cRet)  
/*
------------------------------------------------------------------------------------------------------
Funcao..: RFINX01()								  						Data: 09/06/10
Autor...: GILDESIO CAMPOS
------------------------------------------------------------------------------------------------------
Objetivo: Retorna codigo de barra ajustado conforme layout - Pagto tributos Bradesco 
------------------------------------------------------------------------------------------------------
*/
User Function RFinX01()
Local cCodBar := Alltrim(SE2->E2_CODBAR)

If Len(Alltrim(SE2->E2_CODBAR))==44
	cCodBar := "0000" + cCodBar
EndIf

Return(cCodBar) 
/*
----------------------------------------------------------------------------
Funcao   : RFINXF02()                          				Data: 13/07/2010
Descricao: Retorna dados do titulo do INSS
----------------------------------------------------------------------------
Uso : Arquivo de Configuraçao pagto tributos Bradesco
----------------------------------------------------------------------------
Parametros: cExpr = 1 --> Calcula valor total do pagamento
					2 --> Nome do Recolhedor
----------------------------------------------------------------------------
*/
User Function RFinXF02(cPar)
Local cRet 

SM0->(MsSeek(cEmpAnt + SE2->E2_PREFIXO)) 	//PEGA A FILIAL DO TITULO
                
If 	   cPar == '1'
	cRet := StrZero(SE2->(E2_SALDO + E2_ACRESC - E2_DECRESC + E2_MULTA + E2_JUROS + E2_CORREC)*100,15) 
ElseIf cPar == '2'	
	If SE2->E2_X_CODRE == "2631" .OR. SE2->E2_CODINS == "2658"
		cRet := Substr(SE2->E2_X_FORIG,11,40)
	Else 
		cRet := Space(40)
	EndIf
EndIf

Return(cRet)  
                            

/*
------------------------------------------------------------------------------------
Funcao   : RFINXF03()                          				Data: 06/12/2010
Descricao: Retorna a data de competência das faturas geradas para titulos do INSS
------------------------------------------------------------------------------------
Uso : Arquivo de Configuraçao pagto tributos Bradesco
------------------------------------------------------------------------------------
Parametros: cExpr = 1 --> Calcula valor total do pagamento
					2 --> Nome do Recolhedor
------------------------------------------------------------------------------------
Atualizações: 
				AOliveira  18-07-2011 - Chamado: 003616
				Realizado inclusão da Seguinte regra; 
				SE Modalidade = 67, MES/ANO da Competencia = DT. Apuração  
------------------------------------------------------------------------------------
*/                   
User Function RFinXF03(cPar)

Local cRet:= ""                                          
Local _aArea := GetArea()

DbSelectArea("SEA") 
SEA->(DbSetOrder(2))    //EA_FILIAL+EA_NUMBOR+EA_CART+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA
SEA->(MsSeek(xFilial("SEA")+MV_PAR01+'P'))                  

If cPar == '1'  
	If SubStr(SEA->EA_MODELO,1,2) == '67'
		cRet := STRZERO(YEAR(SE2->E2_APURAC),4)
	Else
		IF(MONTH(dDatabase)== 01)
			cRet := STRZERO(YEAR(dDatabase)-1,4)
		Else
			cRet := STRZERO(YEAR(dDatabase),4)
		Endif
	EndIf
	
ElseIf cPar == '2'
	If SubStr(SEA->EA_MODELO,1,2) == '67'
		cRet := STRZERO(Month(SE2->E2_APURAC),2)
	Else
		IF(MONTH(dDatabase)== 01)
			cRet := "12"
		Else
			cRet := STRZERO(MONTH(dDatabase)-1,2)
		Endif
	EndIf
Endif
                                              
RestArea(_aArea)

Return(cRet)