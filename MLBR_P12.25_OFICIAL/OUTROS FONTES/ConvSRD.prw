#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONVSRD   ºAutor  ³Primainfo           º Data ³  06/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Converte informacoes Ficha Financeira                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - Midori                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ConvSRD()

Private	oDlgAM
Private cPerg	:= "CONVET"
Private aInfo	:= {}

fPriPerg()
pergunte(cPerg,.F.)

dbSelectArea("SRD")
dbSetOrder(2)

DEFINE MSDIALOG oDlgAM FROM  200,001 TO 410,480 TITLE OemToAnsi( "Importa Ficha Financeira" ) PIXEL

@ 002, 010 TO 095, 230 OF oDlgAM  PIXEL
@ 010, 018 SAY " Este programa ira importar os arquivos da ficha financeira    " SIZE 200, 007 OF oDlgAM PIXEL
@ 018, 018 SAY "conforme definicoes de tabelas de-para e cadastro funcionario. " SIZE 200, 007 OF oDlgAM PIXEL
@ 026, 018 SAY "                                                               " SIZE 200, 007 OF oDlgAM PIXEL

DEFINE SBUTTON FROM 070,128 TYPE 5 ENABLE OF oDlgAM ACTION (Pergunte(cPerg,.T.))
DEFINE SBUTTON FROM 070,158 TYPE 1 ENABLE OF oDlgAM ACTION (MigraSrd(),oDlgAM:End())
DEFINE SBUTTON FROM 070,188 TYPE 2 ENABLE OF oDlgAM ACTION (oDlgAM:End())

ACTIVATE MSDIALOG oDlgAM Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MigraSrd  ºAutor  ³PrimaInfo           º Data ³  10/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CONVSRD                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MigraSrd()

//1 = DESIS, 2 = WC1-PNP,3 = WC1-OUTR
Private ntpArq := Mv_par01
Private aArea   := GetArea()

pergunte(cPerg,.F.)

//Funcionarios
dbSelectArea("SRA")
dbSetOrder(1)
//Centro de Custo
dbSelectArea("CTT")
dbSetOrder(1)
//Verbas
dbSelectArea("SRV")
dbSetOrder(1)

If ntpArq == 1
	
	dbUseArea(.T.,,"\DATA\RHFFIN\desis.dbf","FFIN",.F.)  // Abrir exclusivo no Sigaadv
	dbSelectArea("FFIN")
	cArqNtx  := CriaTrab(NIL,.F.)
	cIndCond := "CCUSTO+CODFUN+CODITEM"
	IndRegua("FFIN",cArqNtx,cIndCond,,,"Selecionando registros.Ficha Financeira")
	
	dbUseArea(.T.,,"\DATA\RHFFIN\DP011016.dbf","DEPA",.F.)  // Abrir exclusivo no Sigaadv
	dbSelectArea("DEPA")
	cArqNtx  := CriaTrab(NIL,.F.)
	cIndCond := "COD_ORIGEM"
	IndRegua("DEPA",cArqNtx,cIndCond,,,"Selecionando registros.De-Para")
	
ElseIf ntpArq == 2
	
	dbUseArea(.T.,,"\DATA\RHFFIN\WCM1.dbf","FFIN",.F.)  // Abrir exclusivo no Sigaadv
	dbSelectArea("FFIN")
	cArqNtx  := CriaTrab(NIL,.F.)
	cIndCond := "FILIAL+MATR+VERBA"
	IndRegua("FFIN",cArqNtx,cIndCond,,,"Selecionando registros.Ficha Financeira")
	
	dbUseArea(.T.,,"\DATA\RHFFIN\DP0809.dbf","DEPA",.F.)  // Abrir exclusivo no Sigaadv
	dbSelectArea("DEPA")
	cArqNtx  := CriaTrab(NIL,.F.)
	cIndCond := "COD_ORI"
	IndRegua("DEPA",cArqNtx,cIndCond,,,"Selecionando registros.De-Para")
	
Else
	
	dbUseArea(.T.,,"\DATA\WCM2.dbf","FFIN",.F.)  // Abrir exclusivo no Sigaadv
	dbSelectArea("FFIN")
	cArqNtx  := CriaTrab(NIL,.F.)
	cIndCond := "FILIAL+MATR+VERBA"
	IndRegua("FFIN",cArqNtx,cIndCond,,,"Selecionando registros.Ficha Financeira")
	
	dbUseArea(.T.,,"\DATA\DP23457.dbf","DEPA",.F.)  // Abrir exclusivo no Sigaadv
	dbSelectArea("DEPA")
	cArqNtx  := CriaTrab(NIL,.F.)
	cIndCond := "COD_ORI"
	IndRegua("DEPA",cArqNtx,cIndCond,,,"Selecionando registros.De-Para")
	
EndIf

Processa({|| ImpSrd() },"Importando Ficha Financeira")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Impsrd    ºAutor  ³PrimaInfo           º Data ³  10/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CONVSRD                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Impsrd()

Local nx
Private _cNwFil  := ""
Private _aErro   := {}
Private _cVerSig := ""
Private _cNwCC   := ""
Private _cMatr   := ""
Private _cDtArq  := ""
Private	_cINSS   := ""
Private	_cIR     := ""
Private	_cFGTS   := ""
Private _nSeq    := 0

dbSelectArea("SRD")
dbSetOrder(2)

dbSelectArea("FFIN")
dbGoTop()

ProcRegua(RecCount())

Do While !FFIN->(Eof())
	
	IncProc()
	
	fTratFil()
	If _cNwFil ==""
		If ntpArq == 1
			If Ascan(_aErro, { |x| x[1] == FFIN->CCUSTO }) > 0
				aAdd(_aErro,{FFIN->CCUSTO,"Nao Existe DE-PARA - Filial",FFIN->CCUSTO})
			EndIf
		Else
			If Ascan(_aErro, { |x| x[1] == FFIN->FILIAL }) > 0
				aAdd(_aErro,{FFIN->DESCFIL,"Nao Existe DE-PARA - Filial ",FFIN->DESC_FIL})
			EndIf
		EndIf
		FFIN->(dbSkip())
		Loop
	EndIf
	
	fTratMat()
	If _cMatr == ""
		If ntpArq == 1
			If Ascan(_aErro, { |x| x[1] == FFIN->CODFUN}) = 0
				aAdd(_aErro,{FFIN->CODFUN,"Nao Existe MATRICULA",FFIN->CCUSTO})
			EndIf
		Else
			If Ascan(_aErro, { |x| x[1] == FFIN->MATR }) = 0
				aAdd(_aErro,{FFIN->MATR,"Nao Existe MATRICULA ",FFIN->DESC_FIL})
			EndIf
		EndIf
		
		FFIN->(dbSkip())
		Loop
	EndIf
	
	fTratVER()
	If _cVerSig ==""
		If ntpArq == 1
			If Ascan(_aErro, { |x| x[1] == FFIN->CODITEM}) = 0
				aAdd(_aErro,{FFIN->CODITEM,"Nao Existe de-para Verbas",FFIN->CCUSTO})
			EndIf
		Else
			If Ascan(_aErro, { |x| x[1] == FFIN->VERBA }) = 0
				aAdd(_aErro,{FFIN->VERBA,"Nao Existe de-para Verbas ",FFIN->DESC_FIL})
			EndIf
		EndIf
		
		FFIN->(dbSkip())
		Loop
	ElseIf _cVerSig == "XXX"
		If ntpArq == 1
			If Ascan(_aErro, { |x| x[1] == FFIN->CODITEM}) = 0
				aAdd(_aErro,{FFIN->CODITEM,"Nao importado Verba Adiantamento",FFIN->CCUSTO})
			EndIf
		EndIf
		
		FFIN->(dbSkip())
		Loop
		
	ElseIf _cVerSig == "ZZZ"
		If ntpArq == 1
			If Ascan(_aErro, { |x| x[1] == FFIN->CODITEM}) = 0
				aAdd(_aErro,{FFIN->CODITEM,"Nao importado Verba 131",FFIN->CCUSTO})
			EndIf
		EndIf
		
		FFIN->(dbSkip())
		Loop
		
	EndIf
	
	If ntpArq == 1
		_cDtArq := Left(DtoS(FFIN->DTCOMPETEN),6)
		If FFIN->DSFOLHA == "(13.SALAR)     " .And. FFIN->MES == "Dezembro       "
			_cDtArq := Left(DtoS(FFIN->DTCOMPETEN),4)+"13"
		EndIf
		
	Else
		_cDtArq := RIGHT(FFIN->PERIOD,4)+LEFT(FFIN->PERIOD,2)
	EndIf
	//UNICO
	//RD_FILIAL+RD_MAT+RD_CC+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ
	//INDICE(2)
	//                RD_FILIAL+RD_CC   +RD_MAT  +RD_DATARQ+RD_PD    +RD_SEMANA+RD_SEQ
	If !SRD->(dbSeek(_cNwFil  + _cNwCC + _cMatr + _cDtArq + _cVerSig  ))
		
		RecLock("SRD",.T.)
		SRD->RD_FILIAL	:= _cNwFil											//C	2		Filial
		SRD->RD_MAT		:= _cMatr											//C	6		Matricula
		SRD->RD_PD		:= _cVerSig											//C	3		Codigo Verba
		SRD->RD_DATARQ	:= _cDtArq											//C	6		Dt.Arq.
		SRD->RD_CC		:= _cNwCC											//C	9		Centro Custo
		SRD->RD_SEQ		:= Space(1)											//C	1		Seq. Verba
		SRD->RD_EMPRESA	:= ""  												//C	2		Empresa
		SRD->RD_TIPO2	:= "I"												//C	1		Origem
		SRD->RD_MES		:= Right(_cDtArq,2)									//C	2		Dez.Mes.Acum
		SRD->RD_INSS	:= _cINSS											//C	1		INSS
		SRD->RD_IR		:= _cIR	 											//C	1		IRRF
		SRD->RD_FGTS	:= _cFGTS											//C	1		FGTS
		SRD->RD_SEMANA  := Space(2)
		
		If ntpArq ==1
			SRD->RD_TIPO1	:= FFIN->TPINFORM								//C	1		Tipo
			SRD->RD_HORAS	:= FFIN->QTDE									//N	9	2	Horas/Dias
			SRD->RD_VALOR	:= FFIN->VALOR									//N	12	2	Valor
			SRD->RD_DATPGT	:= FFIN->DT_PAGTO								//D	8		Dt.Pagamento
		Else
			SRD->RD_TIPO1	:= FFIN->TIPO									//C	1		Tipo
			SRD->RD_HORAS	:= Val(FFIN->REF)								//N	9	2	Horas/Dias
			SRD->RD_VALOR	:= Val(FFIN->VALOR)								//N	12	2	Valor
			SRD->RD_DATPGT	:= CTOD( FFIN->DATAPGT )						//D	8		Dt.Pagamento
		EndIf
		msUnLock()
	Else
		For nx := 1 to 9
			_nSeq++
			//                        RD_FILIAL+RD_CC   +RD_MAT  +RD_DATARQ+RD_PD    +RD_SEMANA+RD_SEQ
			If !SRD->(dbSeek(_cNwFil  + _cNwCC + _cMatr + _cDtArq + _cVerSig+"  " + Str(_nSeq,1) ))
				nx:=9
			EndIf
		Next
		RecLock("SRD",.T.)
		SRD->RD_FILIAL	:= _cNwFil											//C	2		Filial
		SRD->RD_MAT		:= _cMatr											//C	6		Matricula
		SRD->RD_PD		:= _cVerSig											//C	3		Codigo Verba
		SRD->RD_DATARQ	:= _cDtArq											//C	6		Dt.Arq.
		SRD->RD_CC		:= _cNwCC											//C	9		Centro Custo
		SRD->RD_SEQ		:= Str(_nSeq,1)										//C	1		Seq. Verba
		SRD->RD_EMPRESA	:= ""  												//C	2		Empresa
		SRD->RD_TIPO2	:= "I"												//C	1		Origem
		SRD->RD_MES		:= Right(_cDtArq,2)									//C	2		Dez.Mes.Acum
		SRD->RD_INSS	:= _cINSS											//C	1		INSS
		SRD->RD_IR		:= _cIR	 											//C	1		IRRF
		SRD->RD_FGTS	:= _cFGTS											//C	1		FGTS
		SRD->RD_SEMANA  := Space(2)
		
		If ntpArq ==1
			SRD->RD_TIPO1	:= FFIN->TPINFORM								//C	1		Tipo
			SRD->RD_HORAS	:= FFIN->QTDE									//N	9	2	Horas/Dias
			SRD->RD_VALOR	:= FFIN->VALOR									//N	12	2	Valor
			SRD->RD_DATPGT	:= FFIN->DT_PAGTO								//D	8		Dt.Pagamento
		Else
			SRD->RD_TIPO1	:= FFIN->TIPO									//C	1		Tipo
			SRD->RD_HORAS	:= Val(FFIN->REF)								//N	9	2	Horas/Dias
			SRD->RD_VALOR	:= Val(FFIN->VALOR)								//N	12	2	Valor
			SRD->RD_DATPGT	:= CTOD( FFIN->DATAPGT )						//D	8		Dt.Pagamento
		EndIf
		msUnLock()
		
	EndIf
	
	_nSeq := 0
	FFIN->(dbSkip())
	
EndDo


FFIN->(dbCloseArea())	//fecha ficha financeira
SRD->(dbCloseArea())	//fecha arquivo acumulado
DEPA->(dbCloseArea())	//Fecha De-Para
RestArea(aArea)

If len(_aErro)>0 .AND. MsgYesNo("Imprime LOG de Erros?")
	//Gera Relatorio de Erros
	CONVREP()
Else
	MsgAlert ("Importacao Finalizada")
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fTratFil  ºAutor  ³PrimaInfo           º Data ³  10/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CONVSRD                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fTratFil

//1 = DESIS, 2 = WC1-PNP,3 = WC1-OUTR
If ntpArq == 1
	If StrZero(FFIN->CCUSTO,2) == "01"
		_cNwFil := "01"
	ElseIf StrZero(FFIN->CCUSTO,2) == "02"
		_cNwFil := "01"
	ElseIf StrZero(FFIN->CCUSTO,2) =="10"
		_cNwFil := "10"
	ElseIf StrZero(FFIN->CCUSTO,2) =="03"
		_cNwFil := "16"
	Else
		_cNwFil :=""
	EndIf
ElseIf ntpArq == 2
	If AllTrim(FFIN->DESC_FIL) =='PNPI'
		_cNwFil := "09"
	ElseIf AllTrim(FFIN->DESC_FIL) =='PNPII'
		_cNwFil := "08"
	Else
		_cNwFil :=""
	EndIf
Else
	If AllTrim(FFIN->DESC_FIL) =='ALTO ALEGRE'
		_cNwFil := "04"
	ElseIf AllTrim(FFIN->DESC_FIL) =='BARBOSA'
		_cNwFil := "03"
	ElseIf AllTrim(FFIN->DESC_FIL) =='BIRIGUI'
		_cNwFil := "15"
	ElseIf AllTrim(FFIN->DESC_FIL) =='CLEMENTINA'
		_cNwFil :="02"
	ElseIf AllTrim(FFIN->DESC_FIL) =='PROMISSAO'
		_cNwFil :="17"
	Else
		_cNwFil :=""
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fTratMat  ºAutor  ³PrimaInfo           º Data ³  10/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CONVSRD                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fTratMat()

If ntpArq == 1
	
	If SRA->(dbSeek(_cNwFil+ ("0"+Right(StrZero(FFIN->CODFUN,7),5))))
		_cNwCC := SRA->RA_CC
		_cMatr := SRA->RA_MAT
	Else
		_cNwCC  := ""
		_cMatr  := ""
	EndIf
	
Else
	If SRA->(dbSeek(_cNwFil+FFIN->MATR))
		_cNwCC := SRA->RA_CC
		_cMatr := SRA->RA_MAT
	ElseIf SRA->(dbSeek(_cNwFil+"0"+Substr(FFIN->MATR,2,5)))
		_cNwCC := SRA->RA_CC
		_cMatr := SRA->RA_MAT
	Else
		_cNwCC  := ""
		_cMatr  := ""
	EndIf
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fTratVER  ºAutor  ³PrimaInfo           º Data ³  10/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CONVSRD                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fTratVER

//COD_ORI	DESC_ORI	COD_SIGA
If ntpArq == 1
/*/ ANTES
	If FFIN->DSFOLHA =="(ADIANTA.)     " .And. AllTrim(Str(FFIN->CODITEM,3))$"997/998/999/900/10"
		_cVerSig := "XXX"
	ElseIf FFIN->DSFOLHA =="(RESCISAO)     " .And. AllTrim(Str(FFIN->CODITEM,3))=="999"
		_cVerSig := "428"
	ElseIf FFIN->DSFOLHA =="(13.SALAR)     " .And. AllTrim(Str(FFIN->CODITEM,3))$"900/997/999" .And. FFIN->MES == "Novembro       "
		_cVerSig := "ZZZ"
	ElseIf FFIN->DSFOLHA =="(13.SALAR)     " .And. FFIN->MES == "Novembro       " .And. AllTrim(Str(FFIN->CODITEM,3))$"100/120/180/182/222/230/232/302"
		_cVerSig := "107"
	ElseIf FFIN->DSFOLHA =="(13.SALAR)     " .And. AllTrim(Str(FFIN->CODITEM,3))$"999" .And. FFIN->MES == "Dezembro       "
		_cVerSig := "711"
	ElseIf DEPA->(dbSeek(AllTrim(Str(FFIN->CODITEM,3))))
		_cVerSig := DEPA->COD_SIGA
		If SRV->(dbSeek(xFilial("SRV")+_cVerSig))
			_cINSS   := SRV->RV_INSS
			_cIR     := SRV->RV_IR
			_cFGTS   := SRV->RV_FGTS
		EndIf
	Else
		_cVerSig := ""
	EndIf
/*/	
	If FFIN->DSFOLHA =="(ADIANTA.)     " .And. (FFIN->CODITEM == 997 .Or. FFIN->CODITEM == 998 .Or.;
	                                             FFIN->CODITEM == 999 .Or. FFIN->CODITEM == 900 .Or.;
	                                             FFIN->CODITEM == 10)
		_cVerSig := "XXX"
	ElseIf FFIN->DSFOLHA =="(RESCISAO)     " .And. FFIN->CODITEM == 999
		_cVerSig := "428"
	ElseIf FFIN->DSFOLHA =="(13.SALAR)     " .And. (FFIN->CODITEM ==900 .Or. FFIN->CODITEM == 997 .Or.;
	                                                 FFIN->CODITEM == 999) .And. FFIN->MES == "Novembro       "
		_cVerSig := "ZZZ"
	ElseIf FFIN->DSFOLHA =="(13.SALAR)     " .And. FFIN->MES == "Novembro       " .And. (FFIN->CODITEM == 100 .Or. FFIN->CODITEM == 120 .Or.;
	                                                                                       FFIN->CODITEM == 180 .Or. FFIN->CODITEM == 182 .Or.;
	                                                                                       FFIN->CODITEM == 222 .Or. FFIN->CODITEM == 230 .Or.;
	                                                                                       FFIN->CODITEM == 232 .Or. FFIN->CODITEM == 302)
		_cVerSig := "107"
	ElseIf FFIN->DSFOLHA =="(13.SALAR)     " .And. FFIN->CODITEM == 999 .And. FFIN->MES == "Dezembro       "
		_cVerSig := "711"
	ElseIf DEPA->(dbSeek(FFIN->CODITEM))
		_cVerSig := DEPA->COD_SIGA
		If SRV->(dbSeek(xFilial("SRV")+_cVerSig))
			_cINSS   := SRV->RV_INSS
			_cIR     := SRV->RV_IR
			_cFGTS   := SRV->RV_FGTS
		EndIf
	Else
		_cVerSig := ""
	EndIf

Else
	If DEPA->(dbSeek(FFIN->VERBA))
		_cVerSig := DEPA->COD_SIGA
		If SRV->(dbSeek(xFilial("SRV")+_cVerSig))
			_cINSS   := SRV->RV_INSS
			_cIR     := SRV->RV_IR
			_cFGTS   := SRV->RV_FGTS
		EndIf
	Else
		_cVerSig := ""
	EndIf
	
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fPriPerg  ºAutor  ³PrimaInfo           º Data ³  10/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CONVSRD                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fPriPerg()

Local aRegs := {}

aAdd(aRegs,{cPerg,'01' ,'Arquivo Origem?','','','mv_ch1', 'N',01,0,0,'C','','mv_par01','DESIS','','','','','WC1-PNP'  ,'','','','','WC1-OUTR','','','','','','','','','','','','','','',''})

ValidPerg(aRegs,cPerg)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONVREP   º Autor ³ PrimaInfo          º Data ³  13/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ IMPRIME ERROS NA Importacao DO ARQUIVO TEXTO Beneficio     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa Principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CONVREP

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Erros na Importação do Arquivo"
Local cPict        := ""
Local titulo       := "Erros na Importação do Arquivo"
Local nLin         := 80
Local Cabec1       := "Ocorrencia                         DESCRICAO ERRO"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}

Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 80
Private tamanho    := "P"
Private nomeprog   := "CONVSRD" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CONSRD" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString	   := "SRA"

dbSelectArea("SRA")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,_aErro) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  29/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,_aErro)

Local nOrdem
Local _nI

SetRegua(len(_aErro))

For _nI := 1 to len(_aErro)
	
	IncRegua()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	@ nLin,01 PSAY _aErro[_ni,1]
	@ nLin,12 PSAY _aErro[_ni,2]
	@ nLin,52 PSAY _aErro[_ni,3]
	nLin++
	
Next

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
