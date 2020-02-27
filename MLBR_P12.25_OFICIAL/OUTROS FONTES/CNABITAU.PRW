#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CNABITAU ³ Autor ³ Carlos R. Moreira      ³ Data ³ 15.01.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera o CNAB para envio ao  Banco ITAU Salarios              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Obs.:     ³ Chamada a partir dos menu SIGAGPE.MNU                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CNABITAU()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define as variaveis utilizadas na rotina                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCadastro := "Gera CNAB do Itau Salarios"
cPerg     :=  "CNABIT    "
nOpca     := 0

//aRegs := {}

//aAdd(aRegs,{cPerg,"01","Matricula De      ?","","","mv_ch1","C"   ,06    ,00      ,0   ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
//aAdd(aRegs,{cPerg,"02","Matricula Ate     ?","","","mv_ch2","C"   ,06    ,00      ,0   ,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
//aAdd(aRegs,{cPerg,"03","Arquivo Destino   ?","","","mv_ch3","C"   ,40    ,00      ,0   ,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"04","Data de Pagamento ?","","","mv_ch4","D"   , 8    ,00      ,0   ,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"05","Gera CNAB         ?","","","mv_ch5","N"   ,01    ,00      ,1   ,"C","","mv_par05","Folha","","","","","Adiantamento","","","","","1a Parc 13o","","","","","2a Parc. 13","","","","","","","","","",""})

ValidPerg()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega perguntas do programa                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg)

//If !Pergunte(cPerg,.t.)
//	Return
//EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a tela principal do programa                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 000,000 TO 140,460 DIALOG oDlg2 TITLE cCadastro

@ 012,012 SAY " Este programa gera o Arquivo que sera enviado        "
@ 022,012 SAY " ao Banco Itau com os detalhes do Holerite            "
@ 012,200 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg,.t.)
@ 026,200 BMPBUTTON TYPE 1 ACTION ProcTxT(oDlg2)
@ 040,200 BMPBUTTON TYPE 2 ACTION Close(oDlg2)

ACTIVATE DIALOG oDlg2 CENTERED

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ProcTxt    ³ Autor ³ Carlos R. Moreira     ³ Data ³ Abr/03   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao que chama a rotina de processamento efetivo           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Escola Graduada                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ProcTxt(oDlg2)

Processa({|| CNABENVIO()},"Gerando o Arquivo para Envio" )

Close(oDlg2)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³EGFIN26X  ³ Autor ³ Carlos R. Moreira     ³ Data ³ ABR/02   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Checa a movimentacao para gerar o lancamentos              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³           Especifico Escola Graduada                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CNABENVIO()

If File( MV_PAR03 )
	If MsgYesNo("O arquivo ja Existe Deseja Substituir")
		nHdlArq := MsFCreate(Alltrim(MV_PAR03),0)
	Else
		Return
	EndIf
Else
	nHdlArq := MsFCreate(Alltrim(MV_PAR03),0)
EndIf

cNumLote := GetMv("MV_LOTCNAB")

lPri := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gerando o Cabecalho do Arquivo³ (Header)
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBuffer := "341"
cBuffer += "0000"
cBuffer += "0"
cBuffer += Space(6)
cBuffer += "080"
cBuffer += "2"
cBuffer += SM0->M0_CGC
cBuffer += Space(20)
cBuffer += "00239" //Numero da Agencia
cBuffer += Space(1)
If SM0->M0_CODIGO == "01"
	cBuffer += "000000045262" //Numero da Conta da Empresa
	cBuffer += Space(1)
	cBuffer += "6" //Digito da Conta da Emresa
ElseIf SM0->M0_CODIGO == "04"
	cBuffer += "000000045629" //Numero da Conta da Empresa
	cBuffer += Space(1)
	cBuffer += "6" //Digito da Conta da Emresa
ElseIf SM0->M0_CODIGO == "05"
	cBuffer += "000000069175" //Numero da Conta da Empresa
	cBuffer += Space(1)
	cBuffer += "1" //Digito da Conta da Emresa
EndIf
cBuffer += Substr(SM0->M0_NOMECOM,1,30) //Nome da Empresa
cBuffer += "BANCO ITAU"+Space(30-Len("BANCO ITAU"))
cBuffer += Space(10)
cBuffer += "1"
cBuffer += GravaData(dDatabase,.F.,5)
cBuffer += Substr(Time(),1,2)+Substr(Time(),4,2)+Substr(Time(),7,2)
cBuffer += "000000000"
cBuffer += "00000"   //Densidade
cBuffer += Space(69)+Chr(13)+Chr(10)

Fwrite(nHdlArq,cBuffer)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gerando o Cabecalho do Lote³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBuffer := "341"
cBuffer += "0001" //cNumLote
cBuffer += "1"
cBuffer += "C"
cBuffer += "30"
cBuffer += "01"
cBuffer += "040"
cBuffer += Space(1)
cBuffer += "2"
cBuffer += SM0->M0_CGC
cBuffer += Space(20)
cBuffer += "00239" // Numero da Agencia
cBuffer += Space(1)
If SM0->M0_CODIGO == "01"
	cBuffer += "000000045262" //Numero da Conta da Empresa
	cBuffer += Space(1)
	cBuffer += "6" //Digito da Conta da Emresa
ElseIf SM0->M0_CODIGO == "04"
	cBuffer += "000000045629" //Numero da Conta da Empresa
	cBuffer += Space(1)
	cBuffer += "6" //Digito da Conta da Emresa
ElseIf SM0->M0_CODIGO == "05"
	cBuffer += "000000069175" //Numero da Conta da Empresa
	cBuffer += Space(1)
	cBuffer += "1" //Digito da Conta da Emresa
EndIf
cBuffer += Substr(SM0->M0_NOMECOM,1,30) //Nome da Empresa
If MV_PAR05 == 1
   cBuffer += "01" //Finalidade de Pagamento - Folha Mensal
ElseIf MV_PAR05 == 2
   cBuffer += "02" //Finalidade de Pagamento - Folha Quinzenal
ElseIf MV_PAR05 == 3 .Or. MV_PAR05 == 4
   cBuffer += "04"
EndIf
cBuffer += Space(28)
cBuffer += Space(10)
cBuffer += Substr(SM0->M0_ENDCOB,1,30)
cBuffer += "02319"
cBuffer += Space(15)
cBuffer += Substr(SM0->M0_CIDCOB,1,20)
cBuffer += SM0->M0_CEPCOB
cBuffer += SM0->M0_ESTCOB
cBuffer += Space(08)
cBuffer += Space(10)+Chr(13)+Chr(10)

Fwrite(nHdlArq,cBuffer)

DbSelectArea("SRA")
DbSetOrder(1)
DbSeek(xFilial("SRA")+MV_PAR01,.T.)

nSeq := 1
nVlrTot := 0
nSeqTot := 0

ProcRegua( RecCount())

While SRA->(!Eof()) .And. SRA->RA_MAT <= MV_PAR02
	
	IncProc( "Processando o Funcionario "+SRA->RA_MAT )
	
	
	If MV_PAR05 # 4
		DbSelectArea("SRC")
		If ! DbSeek(xFilial("SRC")+SRA->RA_MAT )
			DbSelectArea("SRA")
			DbSkip()
			Loop
		EndIf
	Else
		DbSelectArea("SRI")
		If ! DbSeek(xFilial("SRI")+SRA->RA_MAT )
			DbSelectArea("SRA")
			DbSkip()
			Loop
		EndIf
		
	EndIf
	
	//Totaliza o valor Liquido a ser pago
	nValor := 0
	nCredito := nDebito := 0
	//aCredito := {}
	//aDebito := {}
	nFGTS    := nBaseIR := nBaseFGTS := nBaseINSS := 0
	

	If MV_PAR05 # 4
		
		DbSelectArea("SRC")
		DbSeek(xFilial("SRC")+SRA->RA_MAT )
		
		While SRC->(!Eof()) .And. SRC->RC_MAT == SRA->RA_MAT
			
			
			SRV->(DbSeek(xFilial("SRV")+SRC->RC_PD ))
			
			If SRV->RV_TIPOCOD == "3"
				If MV_PAR05 == 1   //Folha de Pagamento
					If SRV->RV_COD == "766" //Valor do FGTS
						nFGTS :=SRC->RC_VALOR
					ElseIf SRV->RV_COD == "706"  //Base IRRF
						nBaseIR := SRC->RC_VALOR
					ElseIf SRV->RV_COD == "731"  //Base FGTS
						nBaseFGTS := SRC->RC_VALOR
					ElseIf SRV->RV_COD $ "721*722"  //Base INSS
						nBaseINSS := SRC->RC_VALOR
					EndIf
				ElseIf MV_PAR05 == 2 //Adiantamento de Salario
					If SRV->RV_CODFOL == "010"  //IRRF Adto
						nBaseIR := SRC->RC_VALOR
					ElseIf Srv->RV_CODFOL == "012"
					    nValor -= SRC->RC_VALOR 
				        nDebito += SRC->RC_VALOR
					EndIf
					
				ElseIf MV_PAR05 == 3 //1 Parc 13o
					If SRV->RV_CODFOL == "109" //Valor do FGTS
						nFGTS :=SRC->RC_VALOR
					ElseIf SRV->RV_CODFOL == "108"  //Base FGTS
						nBaseFGTS := SRC->RC_VALOR
					EndIf
					
				EndIf
				
				DbSelectArea("SRC")
				DbSkip()
				Loop
			EndIf
			
			If MV_PAR05 == 2
				If SRV->RV_CODFOL == "007" .Or. SRV->RV_CODFOL == "008"
					nValor   += SRC->RC_VALOR
					nCredito += SRC->RC_VALOR
					//	  Aadd(aCredito,{SRV->RV_DESC,SRC->RC_VALOR} )
				EndIf                          
				/*
				IF SRV->RV_CODFOL == "012" //Desconto
					nValor  -= SRC->RC_VALOR
					nDebito += SRC->RC_VALOR
					//					Aadd(aDebito,{SRV->RV_DESC,SRC->RC_VALOR} )
				EndIf
				  */
				
			ElseIf MV_PAR05 == 3
				If SRV->RV_CODFOL == "022"
					nValor   += SRC->RC_VALOR
					nCredito += SRC->RC_VALOR
					//	  Aadd(aCredito,{SRV->RV_DESC,SRC->RC_VALOR} )
				EndIf
				
			Else
				If SRV->RV_TIPOCOD =="1" //Proventos
					nValor   += SRC->RC_VALOR
					nCredito += SRC->RC_VALOR
					//	Aadd(aCredito,{SRV->RV_DESC,SRC->RC_VALOR} )
				EndIF
				
				IF SRV->RV_TIPOCOD == "2" //Desconto
					nValor -= SRC->RC_VALOR
					nDebito += SRC->RC_VALOR
					//Aadd(aDebito,{SRV->RV_DESC,SRC->RC_VALOR} )
				EndIf
			EndIf
			DbSelectArea("SRC")
			DbSkip()
			
		End
		
	Else  //2a Parcela do 13o
		
		DbSelectArea("SRI")
		DbSeek(xFilial("SRI")+SRA->RA_MAT )
		
		While SRI->(!Eof()) .And. SRI->RI_MAT == SRA->RA_MAT
			
			
			SRV->(DbSeek(xFilial("SRV")+SRI->RI_PD ))
			
			If SRV->RV_TIPOCOD == "3"
				
				If SRV->RV_CODFOL == "109" //Valor do FGTS
					nFGTS :=SRI->RI_VALOR
				ElseIf SRV->RV_CODFOL == "027"  //Base IRRF
					nBaseIR := SRI->RI_VALOR
				ElseIf SRV->RV_CODFOL == "108"  //Base FGTS
					nBaseFGTS := SRI->RI_VALOR
				ElseIf SRV->RV_CODFOL $ "019*020"  //Base INSS
					nBaseINSS := SRI->RI_VALOR
				EndIf
				
				DbSelectArea("SRI")
				DbSkip()
				Loop
			EndIf
			
			If SRV->RV_TIPOCOD =="1" //Proventos
				nValor   += SRI->RI_VALOR
				nCredito += SRI->RI_VALOR
				//	Aadd(aCredito,{SRV->RV_DESC,SRC->RC_VALOR} )
			EndIF
			
			IF SRV->RV_TIPOCOD == "2" //Desconto
				nValor -= SRI->RI_VALOR
				nDebito += SRI->RI_VALOR
				//Aadd(aDebito,{SRV->RV_DESC,SRC->RC_VALOR} )
			EndIf
			
			DbSelectArea("SRI")
			DbSkip()
			
		End
		
	EndIf
	nVlrTot += nValor
	//If nValor > 0
		
		//************************************
		//Registro Detalhe - Segmento A
		//************************************
		cBuffer := "341"
		cBuffer += "0001" //cNumLote
		cBuffer += "3"
		cBuffer += StrZero(nSeq,5)
		cBuffer += "A"
		cBuffer += "001"
		cBuffer += "000"
		cBuffer += Subs(SRA->RA_BCDEPSA,1,3)        //Banco do Favorecido
		cBuffer += "0"
		cBuffer += Subs(SRA->RA_BCDEPSA,4,4)        //Agência do Favorecido
		cBuffer += " 0000000"  //Space(08)
		cBuffer += Subs(SRA->RA_CTDEPSA,1,5)
		cBuffer += " "
		cBuffer += Subs(SRA->RA_CTDEPSA,7,1)
		cBuffer += Substr(SRA->RA_NOME,1,30)
		cBuffer += Space(20)
		//	cBuffer += Subs(DtoC(SRC->RC_DATA,1,2))+Subs(DtoC(SRC->RC_DATA,4,2))+Subs(DtoC(SRC->RC_DATA,7,4)) //xFilial("SRA")+SRA->RA_MAT+Dtos(dDataBase)+Space(20 - Len(xFilial("SRA")+SRA->RA_MAT+Dtos(dDataBase)))	                             //Numero do Documento
		cBuffer += GravaData(MV_PAR04,.F.,5)
		cBuffer += "REA"
		cBuffer += "000000000000000"
		cBuffer += StrZero(nValor*100,15)     //Valor do Pagto
		cBuffer += Space(20)
		cBuffer += "00000000" //GravaData(MV_PAR04,.F.,5)
		cBuffer += "000000000000000"
		cBuffer += Space(18)
		cBuffer += Space(02)
		cBuffer += "000000"
		cBuffer += StrZero(Val(SRA->RA_CIC),14)  //Replicate("0",14)
		cBuffer += Space(2)
		cBuffer += "00004" //Space(5)
		cBuffer += Space(5)
		cBuffer += Space(1)
		cBuffer += Space(10)+Chr(13)+Chr(10)
		
		Fwrite(nHdlArq,cBuffer)
		nSeqTot += 1
		
		SRJ->(DbSeek(XFilial("SRJ")+SRA->RA_CODFUNC ))
		
		//Gera o Registro Tipo D
		cBuffer := "341"
		cBuffer += "0001" //cNumLote
		cBuffer += "3"
		cBuffer += StrZero(nSeq,5)
		cBuffer += "D"
		cBuffer += Space(3)
		cBuffer += StrZero(Month(dDataBase),2)+StrZero(Year(dDataBase),4)
		cBuffer += SRA->RA_CC+Space(15-Len(SRA->RA_CC))
		cBuffer += SRA->RA_MAT+Space(15-Len(SRA->RA_MAT))
		cBuffer += SRJ->RJ_DESC+Space(30-Len(SRJ->RJ_DESC))  //cargo
		cBuffer += "00000000"
		cBuffer += "00000000"
		cBuffer += StrZero(Val(SRA->RA_DEPIR),2)
		cBuffer += StrZero(Val(SRA->RA_DEPSF),2)
		cBuffer += StrZero(SRA->RA_HRSEMAN,2)
		cBuffer += StrZero(nBaseINSS*100,15)
		cBuffer += StrZero(nFGTS*100,15)
		cBuffer += StrZero(nCredito*100,15)
		cBuffer += StrZero(nDebito*100,15)
		cBuffer += StrZero((nCredito-nDebito)*100,15)
		//If SRA->RA_CATFUNC == "M"
		// nSalar := SRA->RA_SALARIO
		//Else
		// nSalar := SRA->RA_SALARIO * SRA->RA_HRSMES
		//	EndIf
		cBuffer += StrZero(SRA->RA_SALARIO*100,15)
		cBuffer += StrZero(nBaseIR*100,15)
		cBuffer += StrZero(nBaseFGTS*100,15)
		cBuffer += Space(5)
		cBuffer += Space(10)+Chr(13)+Chr(10)
		
		Fwrite(nHdlArq,cBuffer)
		nSeqTot += 1
		
		//nSeq += 2
		//Imprime os creditos
		If MV_PAR05 # 4
			DbSelectArea("SRC")
			DbSeek(xFilial("SRC")+SRA->RA_MAT )
			
			While SRC->(!Eof()) .And. SRC->RC_MAT == SRA->RA_MAT
				
				aCredito := Array(4)
				aDesCre  := Array(4)
				Afill(aCredito,0)
				Afill(aDesCre,Space(30))
				nX := 1
				lImp := .F.
				While nX < 5 .And. SRC->(!Eof()) .And. SRC->RC_MAT == SRA->RA_MAT
					SRV->(DbSeek(xFilial("SRV")+SRC->RC_PD ))
					If MV_PAR05 == 2
						If !SRV->RV_CODFOL $ "007/008"
							DbSelectArea("SRC")
							DbSkip()
							Loop
						EndIf
					ElseIf MV_PAR05 == 3
						If !SRV->RV_CODFOL $ "022/108"
							DbSelectArea("SRC")
							DbSkip()
							Loop
						EndIf
					Else
						If SRV->RV_TIPOCOD # "1"
							DbSelectArea("SRC")
							DbSkip()
							Loop
						EndIf
					EndIf
					
					If MV_PAR05 == 2
						If SRV->RV_CODFOL == "007"
							nRecno := SRV->(Recno())
							SRV->(DbSetOrder(2))
							SRV->(DbSeek(xFilial("SRV")+"006"))
							aCredito[nX] := SRC->RC_VALOR
							aDesCre[nX] := SRV->RV_DESC+Space(30-Len(SRV->RV_DESC))
							SRV->(DbSetOrder(1))
							SRV->(DbGoTo(nRecno))
						ElseIf SRV->RV_CODFOL $ "008"
							aCredito[nX] := SRC->RC_VALOR
							aDesCre[nX] := SRV->RV_DESC+Space(30-Len(SRV->RV_DESC))
						Else
							DbSelectArea("SRC")
							DbSkip()
							Loop
						EndIf
						
					Else
						aCredito[nX] := SRC->RC_VALOR
						aDesCre[nX]  := SRV->RV_DESC+Space(30-Len(SRV->RV_DESC))
					EndIf
					lImp := .T.
					nX++
					DbSelectArea("SRC")
					DbSkip()
					
				End
				
				If lImp
					//Gera o Registro Tipo E
					cBuffer := "341"
					cBuffer += "0001" //cNumLote
					cBuffer += "3"
					cBuffer += StrZero(nSeq,5)
					cBuffer += "E"
					cBuffer += Space(3)
					cBuffer += "1"
					
					cBuffer += aDesCre[1]+Space(5)+StrZero(aCredito[1]*100,15)
					cBuffer += aDesCre[2]+Space(5)+StrZero(aCredito[2]*100,15)
					cBuffer += aDesCre[3]+Space(5)+StrZero(aCredito[3]*100,15)
					cBuffer += aDesCre[4]+Space(5)+StrZero(aCredito[4]*100,15)
					
					cBuffer += SPACE(12)
					cBuffer += Space(10)+Chr(13)+Chr(10)
					Fwrite(nHdlArq,cBuffer)
					nSeqTot += 1
					
				EndIF
				
			End
			
			
			//Imprime os debitos
			DbSelectArea("SRC")
			DbSeek(xFilial("SRC")+SRA->RA_MAT )
			
			While SRC->(!Eof()) .And. SRC->RC_MAT == SRA->RA_MAT
				
				aDebito := Array(4)
				aDesDeb := Array(4)
				Afill(aDebito,0)
				Afill(aDesDeb,Space(30))
				nX := 1
				lImp := .F.
				While nX < 5 .And. SRC->(!Eof()) .And. SRC->RC_MAT == SRA->RA_MAT
					
					SRV->(DbSeek(xFilial("SRV")+SRC->RC_PD ))

					If MV_PAR05 == 2
						If !SRV->RV_CODFOL $ "012"
							DbSelectArea("SRC")
							DbSkip()
							Loop
						EndIf
					ElseIf MV_PAR05 == 3
						DbSelectArea("SRC")
						DbSkip()
						Loop
					Else
						If SRV->RV_TIPOCOD # "2"
							DbSelectArea("SRC")
							DbSkip()
							Loop
						EndIf
					EndIf

					aDebito[nX] := SRC->RC_VALOR
					aDesDeb[nX] := SRV->RV_DESC+Space(30-Len(SRV->RV_DESC))
					lImp := .T.
					
					nX++
					DbSelectArea("SRC")
					DbSkip()
					
				End
				
				If lImp
					//Gera o Registro Tipo E
					cBuffer := "341"
					cBuffer += "0001" //cNumLote
					cBuffer += "3"
					cBuffer += StrZero(nSeq,5)
					cBuffer += "E"
					cBuffer += Space(3)
					cBuffer += "2"
					
					cBuffer += aDesDeb[1]+Space(5)+StrZero(aDebito[1]*100,15)
					cBuffer += aDesDeb[2]+Space(5)+StrZero(aDebito[2]*100,15)
					cBuffer += aDesDeb[3]+Space(5)+StrZero(aDebito[3]*100,15)
					cBuffer += aDesDeb[4]+Space(5)+StrZero(aDebito[4]*100,15)
					
					cBuffer += SPACE(12)
					cBuffer += Space(10)+Chr(13)+Chr(10)
					Fwrite(nHdlArq,cBuffer)
					nSeqTot += 1
					
				EndIF
				
			End
		Else //2a Parcela do 13o Terceiro
			
			
			DbSelectArea("SRI")
			DbSeek(xFilial("SRI")+SRA->RA_MAT )
			
			While SRI->(!Eof()) .And. SRI->RI_MAT == SRA->RA_MAT
				
				aCredito := Array(4)
				aDesCre  := Array(4)
				Afill(aCredito,0)
				Afill(aDesCre,Space(30))
				nX := 1
				lImp := .F.
				While nX < 5 .And. SRI->(!Eof()) .And. SRI->RI_MAT == SRA->RA_MAT
					SRV->(DbSeek(xFilial("SRV")+SRI->RI_PD ))
					If SRV->RV_TIPOCOD # "1"
						DbSelectArea("SRI")
						DbSkip()
						Loop
					EndIf
					
					aCredito[nX] := SRI->RI_VALOR
					aDesCre[nX] := SRV->RV_DESC+Space(30-Len(SRV->RV_DESC))
					lImp := .T.
					nX++
					DbSelectArea("SRI")
					DbSkip()
					
				End
				
				If lImp
					//Gera o Registro Tipo E
					cBuffer := "341"
					cBuffer += "0001" //cNumLote
					cBuffer += "3"
					cBuffer += StrZero(nSeq,5)
					cBuffer += "E"
					cBuffer += Space(3)
					cBuffer += "1"
					
					cBuffer += aDesCre[1]+Space(5)+StrZero(aCredito[1]*100,15)
					cBuffer += aDesCre[2]+Space(5)+StrZero(aCredito[2]*100,15)
					cBuffer += aDesCre[3]+Space(5)+StrZero(aCredito[3]*100,15)
					cBuffer += aDesCre[4]+Space(5)+StrZero(aCredito[4]*100,15)
					
					cBuffer += SPACE(12)
					cBuffer += Space(10)+Chr(13)+Chr(10)
					Fwrite(nHdlArq,cBuffer)
					nSeqTot += 1
					
				EndIF
				
			End
			
			
			//Imprime os debitos
			DbSelectArea("SRI")
			DbSeek(xFilial("SRI")+SRA->RA_MAT )
			
			While SRI->(!Eof()) .And. SRI->RI_MAT == SRA->RA_MAT
				
				aDebito := Array(4)
				aDesDeb := Array(4)
				Afill(aDebito,0)
				Afill(aDesDeb,Space(30))
				nX := 1
				lImp := .F.
				While nX < 5 .And. SRI->(!Eof()) .And. SRI->RI_MAT == SRA->RA_MAT
					
					SRV->(DbSeek(xFilial("SRV")+SRI->RI_PD ))
					If SRV->RV_TIPOCOD # "2"
						DbSelectArea("SRI")
						DbSkip()
						Loop
					EndIf
					
					aDebito[nX] := SRI->RI_VALOR
					aDesDeb[nX] := SRV->RV_DESC+Space(30-Len(SRV->RV_DESC))
					lImp := .T.
					
					nX++
					DbSelectArea("SRI")
					DbSkip()
					
				End
				
				If lImp
					//Gera o Registro Tipo E
					cBuffer := "341"
					cBuffer += "0001" //cNumLote
					cBuffer += "3"
					cBuffer += StrZero(nSeq,5)
					cBuffer += "E"
					cBuffer += Space(3)
					cBuffer += "2"
					
					cBuffer += aDesDeb[1]+Space(5)+StrZero(aDebito[1]*100,15)
					cBuffer += aDesDeb[2]+Space(5)+StrZero(aDebito[2]*100,15)
					cBuffer += aDesDeb[3]+Space(5)+StrZero(aDebito[3]*100,15)
					cBuffer += aDesDeb[4]+Space(5)+StrZero(aDebito[4]*100,15)
					
					cBuffer += SPACE(12)
					cBuffer += Space(10)+Chr(13)+Chr(10)
					Fwrite(nHdlArq,cBuffer)
					nSeqTot += 1
					
				EndIF
				
			End
			
		EndIf
		nSeq += 1
	//EndIf   
	//nSeq += 1
	
	DbSelectArea("SRA")
	DbSkip()
	
End

//***************************
//Trailer de Lote
//***************************
cBuffer := "341"
cBuffer += "0001" //cNumLote
cBuffer += "5"
cBuffer += Space(9)
nSeqTot := nSeqTot + 2
cBuffer += StrZero(nSeqTot,6)  //Qtde Registro de Lote
cBuffer += StrZero(nVlrTot*100,18)
cBuffer += Replicate("0",18)
cBuffer += Space(171)
cBuffer += Space(10)+Chr(13)+Chr(10)

Fwrite(nHdlArq,cBuffer)

//*************************
//Trailer de Arquivo
//*************************
cBuffer := "341"
cBuffer += "9999"
cBuffer += "9"
cBuffer += Space(09)
cBuffer += "000001" //Qtde Lotes do Arquivo
nSeqTot := nSeqTot + 2
cBuffer += StrZero(nSeqTot,6) //Qtde Registros do Arquivo
cBuffer += Space(211)+Chr(13)+Chr(10)

Fwrite(nHdlArq,cBuffer)

Fclose( nHdlArq )

DbSelectArea("SX6")
DbSetOrder(1)
DbSeek("  "+"MV_LOTCNAB" )
RecLock("SX6",.F.)
SX6->X6_CONTEUD := StrZero(Val(cNumLote)+1,6)
MsUnlock()

Return


//****************************************

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValidPerg  ³ Autor ³                     ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()

Local j,i

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg     :=  "CNABIT    "
aRegs:={}


aAdd(aRegs,{cPerg,"01","Matricula De      ?","","","mv_ch1","C"   ,06    ,00      ,0   ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{cPerg,"02","Matricula Ate     ?","","","mv_ch2","C"   ,06    ,00      ,0   ,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{cPerg,"03","Arquivo Destino   ?","","","mv_ch3","C"   ,40    ,00      ,0   ,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data de Pagamento ?","","","mv_ch4","D"   , 8    ,00      ,0   ,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Gera CNAB         ?","","","mv_ch5","N"   ,01    ,00      ,1   ,"C","","mv_par05","Folha","","","","","Adiantamento","","","","","1a Parc 13o","","","","","2a Parc. 13","","","","","","","","","",""})


For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return

