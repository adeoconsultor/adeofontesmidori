#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMAGPM01   บAutor  ณPrimaInfo           บ Data ณ  10/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza cadastro do funcionario conforme as regras de     บฑฑ
ฑฑบ          ณde Cesta Basica campo utilizado RA_CESTAB                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10 -                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MAGPM01

Private cString  := "SRA"
Private oGeMRACB
Private _cFiltroRA
Private cPerg    := "MAGPM01"
Private _aArea   := GetArea()

fPriPerg()
pergunte(cPerg,.F.)

dbSelectArea( "SRA" )
dbSetOrder( 1 )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oGeMRACB FROM  200,001 TO 410,480 TITLE OemToAnsi( "cesta Basica" ) PIXEL

@ 002, 010 TO 095, 230 OF oGeMRACB  PIXEL

@ 010, 018 SAY " Este programa ira gerar atualizar o cadastro do funcionario   " SIZE 200, 007 OF oGeMRACB PIXEL
@ 018, 018 SAY " com os dados sobre a cesta basica, conforme as regras e para- " SIZE 200, 007 OF oGeMRACB PIXEL
@ 026, 018 SAY " metros defidos.                                               " SIZE 200, 007 OF oGeMRACB PIXEL

DEFINE SBUTTON FROM 070,098 TYPE 5 ENABLE OF oGeMRACB ACTION (fFiltro())
DEFINE SBUTTON FROM 070,128 TYPE 5 ENABLE OF oGeMRACB ACTION (Pergunte(cPerg,.T.))
DEFINE SBUTTON FROM 070,158 TYPE 1 ENABLE OF oGeMRACB ACTION (OkGeMRACB(),oGeMRACB:End())
DEFINE SBUTTON FROM 070,188 TYPE 2 ENABLE OF oGeMRACB ACTION (oGeMRACB:End())

ACTIVATE MSDIALOG oGeMRACB Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณOKGEMRACB  บ Autor ณ AP5 IDE            บ Data ณ  28/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkGeMRACB
Processa({|| RunCont() },"Processando...")
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  28/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunCont

Private cFilDe, cFilAte
Private cMatDe, cMatAte, cCcDe, cCcAte
Private cLctDe, cLctAte,cSitFol
Private cPerApont
Private aPerApon := {}
Private aPerCest := {}
Private lCont    := .T.

pergunte(cPerg,.F.)

cFilDe   := mv_par01
cFilAte  := mv_par02
cMatDe   := mv_par03
cMatAte  := mv_par04
cCcDe    := mv_par05
cCcAte   := mv_par06
cSitFol  := StrTran(mv_par07,"*","")
cLctDe   := mv_par08
cLctAte  := mv_par09
cPerApont:= Dtos(mv_par10)+Dtos(mv_par11)

// Monta a Query Principal a Partir do Cadastro de Funcionarios
MsAguarde( {|| lCont := fMtaQuery()}, "Processando...", "Selecionado Registros no Banco de Dados..." )

If lCont

	// Trata o ponto para saber se perde o direito
	MsAguarde( {||fPsqPonto()}, "Processando...", "Tratanto o ponto " )

     msgAlert("Manutencao concluida com sucesso, conforme os parametros selecionados.!!")

Else
	msgAlert("Nao foi possivel selecionar nenhum registo,Verifique os Parametros!!")
EndIf

MRACB->(dbCloseArea())
RestArea(_aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMtaQuery บAutor  ณPrima Info          บ Data ณ  19/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fMtaQuery()

Local lRet    := .T.
Local cQuery

cQuery := "UPDATE "+RetSqlName( "SRA" )
cQuery += " SET RA_CESTAB ='S'"
cQuery += " WHERE D_E_L_E_T_ <>'*'"
cQuery += "   AND RA_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
cQuery += "   AND RA_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
cQuery += "   AND RA_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
cQuery += "   AND RA_SITFOLH LIKE '["+cSitFol+"]'"
cQuery += "   AND RA_ITEM BETWEEN '" + cLctDe + "' AND '" + cLctAte + "'"
If !Empty(_cFiltroRA)
	cQuery += "   AND ("+_cFiltroRA+")"
Endif

If TcSqlExec( cQuery ) < 0
	lRet := .F.
EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPsqPonto บAutor  ณMicrosiga           บ Data ณ  10/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fPsqPonto

Local cQuery     := ""
Local nLenFaltas := 3
Local nLimite    := 0.01
Local lPerde     := .F.
Local cPontoMes  := GETMV("MV_PONMES")//20100816/20100915
Local nTotReg  := 1
Local nContReg := 1
Local nX

cQuery := "SELECT RA_FILIAL,RA_ITEM,RA_MAT,RA_CC,RA_SITFOLH,RA_CESTAB"
cQuery += "  FROM " + RetSqlName( "SRA" ) + " SRA"
cQuery += " WHERE SRA.D_E_L_E_T_ <>'*'"
cQuery += "   AND RA_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
cQuery += "   AND RA_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
cQuery += "   AND RA_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
cQuery += "   AND RA_SITFOLH LIKE '["+cSitFol+"]'"
cQuery += "   AND RA_ITEM BETWEEN '" + cLctDe + "' AND '" + cLctAte + "'"
If !Empty(_cFiltroRA)
	cQuery += "   AND ("+_cFiltroRA+")"
Endif

TCQuery cQuery New Alias "MRACB"

dbSelectArea( "MRACB" )
nTotReg := fLastReg( 11 )
dbGoTop()
ProcRegua( nTotReg )

// Define os Parametros para Leitura das Faltas no Ponto Eletronico
aPerApon := { Stod(Left(cPontoMes,8)), Stod(Right(cPontoMes,8)) }
//20100816/20100915
//SPO->(dbSetOrder( 2 ))
//SPO->(dbSeek( xFilial("SPO") + Left(cPerApont,8) ))
//If !(SPO->(Eof())) .Or. !(SPO->(Bof()))
//	aPerApon := { SPO->PO_DATAINI, SPO->PO_DATAFIM }
//EndIf

dbSelectArea("MRACB")
dbGotop()

While !MRACB->(Eof())

	IncProc( "Processando: "+StrZero(nContReg,6)+" de "+StrZero(nTotReg,6))
	nContReg++
	
	If Left( cPerApont,8 ) < Dtos( aPerApon[1] )
		For nX := 1 To nLenFaltas
			If     nX == 1
				cPdFalta := "452"//FALTAS
			ElseIf nX == 2
				cPdFalta := "414"//ATRASOS
			Elseif nX == 3
				cPdFalta := "979"//Abono Beneficio
			EndIf
			
			If SPL->(dbSeek( MRACB->(RA_FILIAL + RA_MAT) + cPdFalta ))
				Do While !(SPL->(Eof())) .And. SPL->(PL_FILIAL + PL_MAT + PL_PD) == MRACB->(RA_FILIAL + RA_MAT) + cPdFalta
					If SPL->PL_DATA < aPerApon[1] .Or. SPL->PL_DATA > aPerApon[2]
						SPL->(dbSkip())
						Loop
					EndIf
					If SPL->PL_HORAS >= nLimite
						lPerde := .T.
					EndIf
					
					SPL->(dbSkip())
				EndDo
			EndIf
		Next nX
		
	Else
		For nX := 1 To nLenFaltas
			If     nX == 1
				cPdFalta := "452"//FALTAS
			ElseIf nX == 2
				cPdFalta := "414"//ATRASOS
			Elseif nX == 3
				cPdFalta := "979"//Abono Beneficio
			EndIf
			If SPB->(dbSeek( MRACB->(RA_FILIAL + RA_MAT) + cPdFalta ))
				While !(SPB->(Eof())) .And. SPB->(PB_FILIAL + PB_MAT + PB_PD) == MRACB->(RA_FILIAL + RA_MAT) + cPdFalta
					If SPB->PB_HORAS >= nLimite
						lPerde := .T.
					EndIf
					SPB->(dbSkip())
				EndDo
			EndIf
		Next nX
		
	EndIf
	
	If lPerde
        SRA->(dbSeek(MRACB->(RA_FILIAL+RA_MAT)))
        RecLock("SRA",.F.)
        SRA->RA_CESTAB := "N"
        msUnlock()
		lPerde := .F.
	EndIf
	
	MRACB->(dbSkip())
	
EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fFiltro  บAutor  ณMicrosiga           บ Data ณ  12/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */

Static Function fFiltro

_cFiltroRA := BuildExpr("SRA",,_cFiltroRA,.T.)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณfPriPerg  บ Autor ณ AP5 IDE            บ Data ณ  27/10/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fPriPerg()

Local aRegs := {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{ cPerg,'01','Filial De ?                  ','','','mv_ch1','C',02,0,0,'G','             ','mv_par01','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'02','Filial Ate ?                 ','','','mv_ch2','C',02,0,0,'G','NaoVazio     ','mv_par02','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'03','Matricula De ?               ','','','mv_ch3','C',06,0,0,'G','             ','mv_par03','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'04','Matricula Ate ?              ','','','mv_ch4','C',06,0,0,'G','NaoVazio     ','mv_par04','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'05','Centro Custo De ?            ','','','mv_ch5','C',10,0,0,'G','             ','mv_par05','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT','' })
aAdd(aRegs,{ cPerg,'06','Centro Custo Ate ?           ','','','mv_ch6','C',10,0,0,'G','NaoVazio     ','mv_par06','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT','' })
aAdd(aRegs,{ cPerg,'07','Situacao                     ','','','mv_ch7','C',05,0,0,'G','fSituacao'    ,'mv_par07',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','',''    ,'' })
aAdd(aRegs,{ cPerg,'08','Unidade Trabalho De?         ','','','mv_ch8','C',02,0,0,'G','             ','mv_par08','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'09','Unidade Trabalho Ate?        ','','','mv_ch9','C',02,0,0,'G','NaoVazio     ','mv_par09','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'10','Periodo Ponto De?            ','','','mv_cha','D',08,0,0,'G','(PutPerMvPar("MAGPR01","10","11") .and. NaoVazio() )','mv_par10','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'11','Periodo Ponto Ate?           ','','','mv_chb','D',08,0,0,'G','NaoVazio     ','mv_par11','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'   ','' })

ValidPerg(aRegs,cPerg)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfLastReg  บAutor  ณMicrosiga           บ Data ณ  08/23/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fLastReg( nSkip )

 Local nReg := 0
 
 DEFAULT nSkip := 20
 
 dbGoTop()
 Do While !Eof()
    dbSkip( nSkip )
    If !Eof()
       nReg := Recno()
    EndIf
 EndDo
 dbGoTop()

Return( nReg )