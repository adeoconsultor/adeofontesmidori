#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE          cEol         CHR(13)+CHR(10)
#DEFINE          cSep         ";"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGPAMNPP4  บ Autor ณ Prima Info         บ Data ณ  24/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera Planilha excel Head Count Area                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10 - Atlantica Midori                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GPAMNPP4

Private cString, cPerg, oGeraTxt
Private _cFiltroRA

cPerg       := "GPAMNPP4"
CriaSx1(cPerg)

Pergunte(cPerg, .F.)
dbSelectArea("SRA")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oGeraTxt FROM  200,001 TO 410,480 TITLE OemToAnsi( "Head Count Area" ) PIXEL

@ 002, 010 TO 095, 230 OF oGeraTxt  PIXEL

@ 010, 018 SAY " Este programa ira gerar o arquivo integrado ao Excel da       " SIZE 200, 007 OF oGeraTxt PIXEL
@ 018, 018 SAY " Planilha Head Count Area.                                     " SIZE 200, 007 OF oGeraTxt PIXEL
@ 026, 018 SAY " Conforme parametros selecionados pelo usuario.                " SIZE 200, 007 OF oGeraTxt PIXEL

DEFINE SBUTTON FROM 070,098 TYPE 5 ENABLE OF oGeraTxt ACTION (fFiltro())
DEFINE SBUTTON FROM 070,128 TYPE 5 ENABLE OF oGeraTxt ACTION (Pergunte(cPerg,.T.))
DEFINE SBUTTON FROM 070,158 TYPE 1 ENABLE OF oGeraTxt ACTION (OkGeraTxt(),oGeraTxt:End())
DEFINE SBUTTON FROM 070,188 TYPE 2 ENABLE OF oGeraTxt ACTION (oGeraTxt:End())

ACTIVATE MSDIALOG oGeraTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณOKGERATXT บ Autor ณ AP5 IDE            บ Data ณ  28/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkGeraTxt
Processa({|| RunCont() },"Processando...")
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RunCont  บ Autor ณ AP5 IDE            บ Data ณ  17/03/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ /*/
Static Function RunCont

Local lSetCentury := __SetCentury( "on" )
Local cDirDocs    := MsDocPath()
Local cPath       := AllTrim( GetTempPath() )
Local oExcelApp
Local cLin, nTotReg, nContReg
Local cNomeArq

Private aInfo	  := {}
Private cFilAnt   := "@@"
Private cUTAnt    := "@@"
Private cDescFil  := ""
Private cDescUT   := ""
Private nHdl
Private cMatDe,cMatAte,dDtInic,dDtFim,cCatFolh,nTpRel
Private cTpAfast
Private nFE1 := nFLD1 := nFLM1 := nFPNE1 := nFMA1 := 0
Private nFE2 := nFLD2 := nFLM2 := nFPNE2 := nFMA2 := 0
Private nFE3 := nFLD3 := nFLM3 := nFPNE3 := nFMA3 := 0
Private nTFE1 := nTFLD1 := nTFLM1 := nTFPNE1 := nTFMA1 := 0
Private nTFE2 := nTFLD2 := nTFLM2 := nTFPNE2 := nTFMA2 := 0
Private nTFE3 := nTFLD3 := nTFLM3 := nTFPNE3 := nTFMA3 := 0


Pergunte(cPerg,.F.)

dDtInic  := Substr(DtoS(mv_par01),1,6)+"01"
dDtFim   := Substr(DtoS(mv_par01),1,6)+StrZero(f_UltDia(mv_par01),2)
cMatDe   := mv_par02
cMatAte  := mv_par03
cCatFolh := StrTran(MV_PAR04,"*","")
nTpRel   := mv_par05

// Cria Arquivo Texto
MsAguarde( {|| fMtaQuery()}, "Processando...", "Selecao de Registros" )

If Select( "SRANPP4" ) == 0
	Return
EndIf

cNomeArq  := CriaTrab(,.F.) + ".CSV"

nHdl := fCreate( cDirDocs + "\" + cNomeArq )

If nHdl == -1
	MsgAlert("O arquivo de nome "+cNomeArq+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
EndIf

//Grava cabe็alho da planilha
fGrvCab()
fGrvCab1()
fGrvCab2()

nTotReg  := 1
nContReg := 1
dbSelectArea( "SRANPP4" )
nTotReg := fLastReg( 8 )
dbGoTop()
ProcRegua( nTotReg )

If nTpRel == 1
	
	While !SRANPP4->(Eof())
		
		IncProc( "Processando: "+StrZero(nContReg,6)+" de "+StrZero(nTotReg,6))
		nContReg++
		
		If SRANPP4->RC_FILIAL # cFilAnt
			fMntPlan()
			cFilAnt  := SRANPP4->RC_FILIAL
		EndIf
		
		cTpAfast := " "
		fBscAfast()
		
		//Trata Menor Aprendiz
		If SRANPP4->RA_TIPOADM $ "3A*3B*3C"
			
			If SRANPP4->CTT_MTIPOC == "1"
				nFMA1 ++
				nTFMA1 ++
			ElseIf SRANPP4->CTT_MTIPOC == "2"
				nFMA2 ++
				nTFMA2 ++
			ElseIf SRANPP4->CTT_MTIPOC == "3"
				nFMA3 ++
				nTFMA3 ++
			EndIf
			//Trata portador necessidades especiais
		ElseIf SRANPP4->RA_DEFIFIS == "1"
			
			If SRANPP4->CTT_MTIPOC == "1"
				nFPNE1 ++
				nTFPNE1 ++
			ElseIf SRANPP4->CTT_MTIPOC == "2"
				nFPNE2 ++
				nTFPNE2 ++
			ElseIf SRANPP4->CTT_MTIPOC == "3"
				nFPNE3 ++
				nTFPNE3 ++
			EndIf
			//Funcionarios normal
		ElseIf cTpAfast == " "
			
			If SRANPP4->CTT_MTIPOC == "1"
				nFE1 ++
				nTFE1 ++
			ElseIf SRANPP4->CTT_MTIPOC == "2"
				nFE2 ++
				nTFE2 ++
			ElseIf SRANPP4->CTT_MTIPOC == "3"
				nFE3 ++
				nTFE3 ++
			EndIf
			//Funcionarios afastados menos maternidade
		ElseIf cTpAfast <> "Q"
			
			If SRANPP4->CTT_MTIPOC == "1"
				nFLD1 ++
				nTFLD1 ++
			ElseIf SRANPP4->CTT_MTIPOC == "2"
				nFLD2 ++
				nTFLD2 ++
			ElseIf SRANPP4->CTT_MTIPOC == "3"
				nFLD3 ++
				nTFLD3 ++
			EndIf
			//Funcionarios afastados maternidade
		ElseIf cTpAfast == "Q"
			
			If SRANPP4->CTT_MTIPOC == "1"
				nFLM1 ++
				nTFLM1 ++
			ElseIf SRANPP4->CTT_MTIPOC == "2"
				nFLM2 ++
				nTFLM2 ++
			ElseIf SRANPP4->CTT_MTIPOC == "3"
				nFLM3 ++
				nTFLM3 ++
			EndIf
			
		EndIf
		
		SRANPP4->(dbSkip())
		
	EndDo
	
	fMntPlan()
	
	cLin := "" + cSep
	cLin += "Grand Total" + cSep
	
	cLin += StrZero(nTFE1,4) + cSep
	cLin += StrZero(nTFLD1,4) + cSep
	cLin += StrZero(nTFLM1,4) + cSep
	cLin += StrZero(nTFPNE1,4) + cSep
	cLin += StrZero(nTFMA1,4) + cSep
	cLin += StrZero((nTFE1 + nTFLD1 + nTFLM1 + nTFPNE1 + nTFMA1),4) + cSep
	
	cLin += StrZero(nTFE2,4) + cSep
	cLin += StrZero(nTFLD2,4) + cSep
	cLin += StrZero(nTFLM2,4) + cSep
	cLin += StrZero(nTFPNE2,4) + cSep
	cLin += StrZero(nTFMA2,4) + cSep
	cLin += StrZero((nTFE2 + nTFLD2 + nTFLM2 + nTFPNE2 + nTFMA2),4) + cSep
	
	cLin += StrZero((nTFE3),4) + cSep
	cLin += StrZero((nTFLD3),4) + cSep
	cLin += StrZero((nTFLM3),4) + cSep
	cLin += StrZero((nTFPNE3),4) + cSep
	cLin += StrZero((nTFMA3),4) + cSep
	cLin += StrZero((nTFE3 + nTFLD3 + nTFLM3 + nTFPNE3 + nTFMA3),4) + cSep
	
	cLin += StrZero(nTFE1+nTFE2+nTFE3,4) + cSep
	cLin += StrZero(nTFLD1+nTFLD2+nTFLD3,4) + cSep
	cLin += StrZero(nTFLM1+nTFLM2+nTFLM3,4) + cSep
	cLin += StrZero(nTFPNE1+nTFPNE2+nTFPNE3,4) + cSep
	cLin += StrZero(nTFMA1+nTFMA2+nTFMA3,4) + cSep
	cLin += StrZero( ( nTFE1 + nTFLD1 + nTFLM1 + nTFPNE1 + nTFMA1 ) +;
	( nTFE2 + nTFLD2 + nTFLM2 + nTFPNE2 + nTFMA2 ) +;
	( nTFE3 + nTFLD3 + nTFLM3 + nTFPNE3 + nTFMA3 ) ,4) + cSep
	
	cLin += cEol
	
	fGravaTxt( cLin )
	
ElseIf nTpRel == 2
	
	While !SRANPP4->(Eof())
		
		IncProc( "Processando: "+StrZero(nContReg,6)+" de "+StrZero(nTotReg,6))
		nContReg++
		
		If SRANPP4->RC_ITEM # cUTAnt
			fMntPlan()
			cUTAnt  := SRANPP4->RC_ITEM
		EndIf
		
		cTpAfast := " "
		fBscAfast()
		
		//Trata Menor Aprendiz
		If SRANPP4->RA_TIPOADM $ "3A*3B*3C"
			
			If SRANPP4->CTT_MTIPOC == "1"
				nFMA1 ++
				nTFMA1 ++
			ElseIf SRANPP4->CTT_MTIPOC == "2"
				nFMA2 ++
				nTFMA2 ++
			ElseIf SRANPP4->CTT_MTIPOC == "3"
				nFMA3 ++
				nTFMA3 ++
			EndIf
			//Trata portador necessidades especiais
		ElseIf SRANPP4->RA_DEFIFIS == "1"
			
			If SRANPP4->CTT_MTIPOC == "1"
				nFPNE1 ++
				nTFPNE1 ++
			ElseIf SRANPP4->CTT_MTIPOC == "2"
				nFPNE2 ++
				nTFPNE2 ++
			ElseIf SRANPP4->CTT_MTIPOC == "3"
				nFPNE3 ++
				nTFPNE3 ++
			EndIf
			//Funcionarios normal
		ElseIf cTpAfast == " "
			
			If SRANPP4->CTT_MTIPOC == "1"
				nFE1 ++
				nTFE1 ++
			ElseIf SRANPP4->CTT_MTIPOC == "2"
				nFE2 ++
				nTFE2 ++
			ElseIf SRANPP4->CTT_MTIPOC == "3"
				nFE3 ++
				nTFE3 ++
			EndIf
			//Funcionarios afastados menos maternidade
		ElseIf cTpAfast <> "Q"
			
			If SRANPP4->CTT_MTIPOC == "1"
				nFLD1 ++
				nTFLD1 ++
			ElseIf SRANPP4->CTT_MTIPOC == "2"
				nFLD2 ++
				nTFLD2 ++
			ElseIf SRANPP4->CTT_MTIPOC == "3"
				nFLD3 ++
				nTFLD3 ++
			EndIf
			//Funcionarios afastados maternidade
		ElseIf cTpAfast == "Q"
			
			If SRANPP4->CTT_MTIPOC == "1"
				nFLM1 ++
				nTFLM1 ++
			ElseIf SRANPP4->CTT_MTIPOC == "2"
				nFLM2 ++
				nTFLM2 ++
			ElseIf SRANPP4->CTT_MTIPOC == "3"
				nFLM3 ++
				nTFLM3 ++
			EndIf
			
		EndIf
		
		SRANPP4->(dbSkip())
		
	EndDo
	
	fMntPlan()
	
	cLin := "" + cSep
	cLin += "Grand Total" + cSep
	
	cLin += StrZero(nTFE1,4) + cSep
	cLin += StrZero(nTFLD1,4) + cSep
	cLin += StrZero(nTFLM1,4) + cSep
	cLin += StrZero(nTFPNE1,4) + cSep
	cLin += StrZero(nTFMA1,4) + cSep
	cLin += StrZero((nTFE1 + nTFLD1 + nTFLM1 + nTFPNE1 + nTFMA1),4) + cSep
	
	cLin += StrZero(nTFE2,4) + cSep
	cLin += StrZero(nTFLD2,4) + cSep
	cLin += StrZero(nTFLM2,4) + cSep
	cLin += StrZero(nTFPNE2,4) + cSep
	cLin += StrZero(nTFMA2,4) + cSep
	cLin += StrZero((nTFE2 + nTFLD2 + nTFLM2 + nTFPNE2 + nTFMA2),4) + cSep
	
	cLin += StrZero((nTFE3),4) + cSep
	cLin += StrZero((nTFLD3),4) + cSep
	cLin += StrZero((nTFLM3),4) + cSep
	cLin += StrZero((nTFPNE3),4) + cSep
	cLin += StrZero((nTFMA3),4) + cSep
	cLin += StrZero((nTFE3 + nTFLD3 + nTFLM3 + nTFPNE3 + nTFMA3),4) + cSep
	
	cLin += StrZero(nTFE1+nTFE2+nTFE3,4) + cSep
	cLin += StrZero(nTFLD1+nTFLD2+nTFLD3,4) + cSep
	cLin += StrZero(nTFLM1+nTFLM2+nTFLM3,4) + cSep
	cLin += StrZero(nTFPNE1+nTFPNE2+nTFPNE3,4) + cSep
	cLin += StrZero(nTFMA1+nTFMA2+nTFMA3,4) + cSep
	cLin += StrZero( ( nTFE1 + nTFLD1 + nTFLM1 + nTFPNE1 + nTFMA1 ) +;
	( nTFE2 + nTFLD2 + nTFLM2 + nTFPNE2 + nTFMA2 ) +;
	( nTFE3 + nTFLD3 + nTFLM3 + nTFPNE3 + nTFMA3 ) ,4) + cSep
	
	cLin += cEol
	
	fGravaTxt( cLin )
	
Else
	
	While !SRANPP4->(Eof())
		
		IncProc( "Processando: "+StrZero(nContReg,6)+" de "+StrZero(nTotReg,6))
		nContReg++
		
		If SRANPP4->RC_FILIAL # cFilAnt
			fMntPlan()
			cFilAnt  := SRANPP4->RC_FILIAL
		EndIf
		
		If SRANPP4->RC_ITEM # cUTAnt
			fMntPlan()
			cUTAnt  := SRANPP4->RC_ITEM
		EndIf
		
		cTpAfast := " "
		fBscAfast()
		
		//Trata Menor Aprendiz
		If SRANPP4->RA_TIPOADM $ "3A*3B*3C"
			
			If SRANPP4->CTT_MTIPOC == "1"
				nFMA1 ++
				nTFMA1 ++
			ElseIf SRANPP4->CTT_MTIPOC == "2"
				nFMA2 ++
				nTFMA2 ++
			ElseIf SRANPP4->CTT_MTIPOC == "3"
				nFMA3 ++
				nTFMA3 ++
			EndIf
			//Trata portador necessidades especiais
		ElseIf SRANPP4->RA_DEFIFIS == "1"
			
			If SRANPP4->CTT_MTIPOC == "1"
				nFPNE1 ++
				nTFPNE1 ++
			ElseIf SRANPP4->CTT_MTIPOC == "2"
				nFPNE2 ++
				nTFPNE2 ++
			ElseIf SRANPP4->CTT_MTIPOC == "3"
				nFPNE3 ++
				nTFPNE3 ++
			EndIf
			//Funcionarios normal
		ElseIf cTpAfast == " "
			
			If SRANPP4->CTT_MTIPOC == "1"
				nFE1 ++
				nTFE1 ++
			ElseIf SRANPP4->CTT_MTIPOC == "2"
				nFE2 ++
				nTFE2 ++
			ElseIf SRANPP4->CTT_MTIPOC == "3"
				nFE3 ++
				nTFE3 ++
			EndIf
			//Funcionarios afastados menos maternidade
		ElseIf cTpAfast <> "Q"
			
			If SRANPP4->CTT_MTIPOC == "1"
				nFLD1 ++
				nTFLD1 ++
			ElseIf SRANPP4->CTT_MTIPOC == "2"
				nFLD2 ++
				nTFLD2 ++
			ElseIf SRANPP4->CTT_MTIPOC == "3"
				nFLD3 ++
				nTFLD3 ++
			EndIf
			//Funcionarios afastados maternidade
		ElseIf cTpAfast == "Q"
			
			If SRANPP4->CTT_MTIPOC == "1"
				nFLM1 ++
				nTFLM1 ++
			ElseIf SRANPP4->CTT_MTIPOC == "2"
				nFLM2 ++
				nTFLM2 ++
			ElseIf SRANPP4->CTT_MTIPOC == "3"
				nFLM3 ++
				nTFLM3 ++
			EndIf
			
		EndIf
		
		SRANPP4->(dbSkip())
		
	EndDo
	
	fMntPlan()
	
	cLin := "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "Grand Total" + cSep
	
	cLin += StrZero(nTFE1,4) + cSep
	cLin += StrZero(nTFLD1,4) + cSep
	cLin += StrZero(nTFLM1,4) + cSep
	cLin += StrZero(nTFPNE1,4) + cSep
	cLin += StrZero(nTFMA1,4) + cSep
	cLin += StrZero((nTFE1 + nTFLD1 + nTFLM1 + nTFPNE1 + nTFMA1),4) + cSep
	
	cLin += StrZero(nTFE2,4) + cSep
	cLin += StrZero(nTFLD2,4) + cSep
	cLin += StrZero(nTFLM2,4) + cSep
	cLin += StrZero(nTFPNE2,4) + cSep
	cLin += StrZero(nTFMA2,4) + cSep
	cLin += StrZero((nTFE2 + nTFLD2 + nTFLM2 + nTFPNE2 + nTFMA2),4) + cSep
	
	cLin += StrZero((nTFE3),4) + cSep
	cLin += StrZero((nTFLD3),4) + cSep
	cLin += StrZero((nTFLM3),4) + cSep
	cLin += StrZero((nTFPNE3),4) + cSep
	cLin += StrZero((nTFMA3),4) + cSep
	cLin += StrZero((nTFE3 + nTFLD3 + nTFLM3 + nTFPNE3 + nTFMA3),4) + cSep
	
	cLin += StrZero(nTFE1+nTFE2+nTFE3,4) + cSep
	cLin += StrZero(nTFLD1+nTFLD2+nTFLD3,4) + cSep
	cLin += StrZero(nTFLM1+nTFLM2+nTFLM3,4) + cSep
	cLin += StrZero(nTFPNE1+nTFPNE2+nTFPNE3,4) + cSep
	cLin += StrZero(nTFMA1+nTFMA2+nTFMA3,4) + cSep
	cLin += StrZero( ( nTFE1 + nTFLD1 + nTFLM1 + nTFPNE1 + nTFMA1 ) +;
	( nTFE2 + nTFLD2 + nTFLM2 + nTFPNE2 + nTFMA2 ) +;
	( nTFE3 + nTFLD3 + nTFLM3 + nTFPNE3 + nTFMA3 ) ,4) + cSep
	
	cLin += cEol
	
	fGravaTxt( cLin )
	
EndIf

SRANPP4->(dbCloseArea())

fClose( nHdl )

MsAguarde( {|| fStartExcel( cDirDocs, cNomeArq, cPath )}, "Aguarde...", "Integrando Planilha ao Excel..." )

If !lSetCentury
	__SetCentury( "off" )
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfStartExcelบAutor  ณPrimaInfo           บ Data ณ  15/04/09   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                             บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Para uso do programa principal	                           บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fStartExcel( cDirDocs, cNomeArq, cPath )

CpyS2T( cDirDocs + "\" + cNomeArq , cPath, .T. )

If !ApOleClient( 'MsExcel' )
	MsgAlert( 'MsExcel nao instalado' )
Else
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cNomeArq ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	oExcelApp:Destroy()
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMtaQuery บAutor  ณPrimaInfo           บ Data ณ  24/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณPrograma Princiapal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fMtaQuery()

Local cQuery   := ""
Local cArqMvto := ""

If Substr(Dtos(mv_par01),1,6) == GetMv("MV_FOLMES")
	cArqMvto := RetSqlName( "SRC" )
Else
	cArqMvto := "RC"+cEmpAnt+Substr(Dtos(mv_par01),3,4)
EndIf

If nTpRel == 1 //Trata subquery quando a selecao for por filial
	
	cQuery := "SELECT RC_FILIAL,RC_MAT,CTT_MTIPOC,RA_DEMISSA,RA_TIPOADM,RA_DEFIFIS"
	cQuery += "  FROM " + RetSqlName( "SRA" ) + " RA," +RetSqlName( "CTT" ) + " CTT,"+ cArqMvto + " RC"
	cQuery += " WHERE RA.D_E_L_E_T_ <>'*'"
	cQuery += "   AND CTT.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RC.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RC_CC = CTT_CUSTO"
	cQuery += "   AND RC_FILIAL = RA_FILIAL"
	cQuery += "   AND RC_MAT = RA_MAT"
	cQuery += "   AND RC_PD ='890'"
	cQuery += "   AND RC_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
	If !Empty(_cFiltroRA)
		cQuery += "     AND ("+_cFiltroRA+")"
	Endif
	cQuery += "   AND RA_CATFUNC LIKE'["+cCatFolh+"]'"
	cQuery += "   AND (RA_DEMISSA = '' OR RA_DEMISSA > '"+ dDtFim +"')"	
	cQuery += " ORDER BY RC_FILIAL,CTT_MTIPOC,RA_TIPOADM,RA_DEFIFIS"
	
ElseIf nTpRel == 2  //Trata subquery quando a selecao for por unid Trabalho
	
	cQuery := "  SELECT RC_ITEM,RC_FILIAL,RC_MAT,CTT_MTIPOC,RA_DEMISSA,RA_TIPOADM,RA_DEFIFIS"
	cQuery += "  FROM " + RetSqlName( "SRA" ) + " RA," +RetSqlName( "CTT" ) + " CTT,"+ cArqMvto + " RC"
	cQuery += " WHERE RA.D_E_L_E_T_ <>'*'"
	cQuery += "   AND CTT.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RC.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RC_CC = CTT_CUSTO"
	cQuery += "   AND RC_FILIAL = RA_FILIAL"
	cQuery += "   AND RC_MAT = RA_MAT"
	cQuery += "   AND RC_PD ='890'"
	cQuery += "   AND RC_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
	If !Empty(_cFiltroRA)
		cQuery += "     AND ("+_cFiltroRA+")"
	Endif
	cQuery += "   AND RA_CATFUNC LIKE'["+cCatFolh+"]'"
	cQuery += "   AND (RA_DEMISSA = '' OR RA_DEMISSA > '"+ dDtFim +"')"
	cQuery += " ORDER BY RC_ITEM,CTT_MTIPOC,RA_TIPOADM,RA_DEFIFIS"
	
Else //Trata subquery quando a selecao for por filial + unid Trabalho
	cQuery := "  SELECT RC_ITEM,RC_FILIAL,RC_MAT,CTT_MTIPOC,RA_DEMISSA,RA_TIPOADM,RA_DEFIFIS"
	cQuery += "  FROM " + RetSqlName( "SRA" ) + " RA," +RetSqlName( "CTT" ) + " CTT,"+ cArqMvto + " RC"
	cQuery += " WHERE RA.D_E_L_E_T_ <>'*'"
	cQuery += "   AND CTT.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RC.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RC_CC = CTT_CUSTO"
	cQuery += "   AND RC_FILIAL = RA_FILIAL"
	cQuery += "   AND RC_MAT = RA_MAT"
	cQuery += "   AND RC_PD ='890'"
	cQuery += "   AND RC_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
	If !Empty(_cFiltroRA)
		cQuery += "     AND ("+_cFiltroRA+")"
	Endif
	cQuery += "   AND RA_CATFUNC LIKE'["+cCatFolh+"]'"
	cQuery += "   AND (RA_DEMISSA = '' OR RA_DEMISSA > '"+ dDtFim +"')"
	cQuery += " ORDER BY RC_FILIAL,RC_ITEM,CTT_MTIPOC,RA_TIPOADM,RA_DEFIFIS"
EndIf

TCQuery cQuery New Alias "SRANPP4"

TcSetField("SRANPP4","RA_DEMISSA","D",8,0)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGrvCab   บAutor  ณPrimaInfo           บ Data ณ  24/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Para uso do programa principal                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGrvCab()

Local cLin := ""

cLin := "HEADCOUNT  " + cSep
cLin += AllTrim(MesExtenso(mv_par01))+" / "+StrZero(Year(mv_par01),4)+ cSep
cLin += cEol

fGravaTxt( cLin )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGrvCab1  บAutor  ณPrimaInfo           บ Data ณ  24/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Para uso do programa principal                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGrvCab1()

Local cLin := ""

If nTpRel == 1
	
	cLin := "" + cSep
	cLin += "" + cSep
	cLin += "INDUSTRIAL" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	
	cLin += "INDIRETO" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	
	cLin += "ADM" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	
	cLin += "TOTAL GERAL" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	
ElseIf nTpRel == 2
	
	cLin := "" + cSep
	cLin += "" + cSep
	cLin += "INDUSTRIAL" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	
	cLin += "INDIRETO" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	
	cLin += "ADM" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	
	cLin += "TOTAL GERAL" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	
Else
	
	cLin := "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "INDUSTRIAL" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	
	cLin += "INDIRETO" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	
	cLin += "ADM" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	
	cLin += "TOTAL GERAL" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	cLin += "" + cSep
	
EndIf

cLin += cEol

fGravaTxt( cLin )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGrvCab2  บAutor  ณPrimaInfo           บ Data ณ  24/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Para uso do programa principal                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGrvCab2()

Local cLin := ""

If nTpRel == 1
	
	cLin := "FILIAL" + cSep
	cLin += "DESC_FILIAL" + cSep
	
	cLin += "EFETIVO" + cSep
	cLin += "LIC DOENCA" + cSep
	cLin += "LIC MATERNIDADE" + cSep
	cLin += "PNE" + cSep
	cLin += "MENOR APRENDIZ" + cSep
	cLin += "TOTAL" + cSep
	
	cLin += "EFETIVO" + cSep
	cLin += "LIC DOENCA" + cSep
	cLin += "LIC MATERNIDADE" + cSep
	cLin += "PNE" + cSep
	cLin += "MENOR APRENDIZ" + cSep
	cLin += "TOTAL" + cSep
	
	cLin += "EFETIVO" + cSep
	cLin += "LIC DOENCA" + cSep
	cLin += "LIC MATERNIDADE" + cSep
	cLin += "PNE" + cSep
	cLin += "MENOR APRENDIZ" + cSep
	cLin += "TOTAL" + cSep
	
	cLin += "EFETIVO" + cSep
	cLin += "LIC DOENCA" + cSep
	cLin += "LIC MATERNIDADE" + cSep
	cLin += "PNE" + cSep
	cLin += "MENOR APRENDIZ" + cSep
	cLin += "TOTAL" + cSep
	
ElseIf nTpRel == 2
	
	cLin := "UN TRABALHO" + cSep
	cLin += "DESC_UT" + cSep
	
	cLin += "EFETIVO" + cSep
	cLin += "LIC DOENCA" + cSep
	cLin += "LIC MATERNIDADE" + cSep
	cLin += "PNE" + cSep
	cLin += "MENOR APRENDIZ" + cSep
	cLin += "TOTAL" + cSep
	
	cLin += "EFETIVO" + cSep
	cLin += "LIC DOENCA" + cSep
	cLin += "LIC MATERNIDADE" + cSep
	cLin += "PNE" + cSep
	cLin += "MENOR APRENDIZ" + cSep
	cLin += "TOTAL" + cSep
	
	cLin += "EFETIVO" + cSep
	cLin += "LIC DOENCA" + cSep
	cLin += "LIC MATERNIDADE" + cSep
	cLin += "PNE" + cSep
	cLin += "MENOR APRENDIZ" + cSep
	cLin += "TOTAL" + cSep
	
	cLin += "EFETIVO" + cSep
	cLin += "LIC DOENCA" + cSep
	cLin += "LIC MATERNIDADE" + cSep
	cLin += "PNE" + cSep
	cLin += "MENOR APRENDIZ" + cSep
	cLin += "TOTAL" + cSep
	
Else
	
	cLin := "FILIAL" + cSep
	cLin += "DESC_FILIAL" + cSep
	
	cLin += "UN TRABALHO" + cSep
	cLin += "DESC_UT" + cSep
	
	cLin += "EFETIVO" + cSep
	cLin += "LIC DOENCA" + cSep
	cLin += "LIC MATERNIDADE" + cSep
	cLin += "PNE" + cSep
	cLin += "MENOR APRENDIZ" + cSep
	cLin += "TOTAL" + cSep
	
	cLin += "EFETIVO" + cSep
	cLin += "LIC DOENCA" + cSep
	cLin += "LIC MATERNIDADE" + cSep
	cLin += "PNE" + cSep
	cLin += "MENOR APRENDIZ" + cSep
	cLin += "TOTAL" + cSep
	
	cLin += "EFETIVO" + cSep
	cLin += "LIC DOENCA" + cSep
	cLin += "LIC MATERNIDADE" + cSep
	cLin += "PNE" + cSep
	cLin += "MENOR APRENDIZ" + cSep
	cLin += "TOTAL" + cSep
	
	cLin += "EFETIVO" + cSep
	cLin += "LIC DOENCA" + cSep
	cLin += "LIC MATERNIDADE" + cSep
	cLin += "PNE" + cSep
	cLin += "MENOR APRENDIZ" + cSep
	cLin += "TOTAL" + cSep
	
EndIf

cLin += cEol

fGravaTxt( cLin )

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
ฑฑบUso       ณ Para uso do Programa princial                              บฑฑ
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
ฑฑบPrograma  ณfGravaTxt บAutor  ณPrimaInfo           บ Data ณ  24/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Para uso do programa principal                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGravaTxt( cLin )

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return
	Endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfLastReg  บAutor  ณPrimaInfo           บ Data ณ  24/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso do programa principal                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fLastReg( nSkip )

Local nReg := 0

dbGoTop()
Do While !Eof()
	dbSkip( nSkip )
	If !Eof()
		nReg := Recno()
	EndIf
EndDo
dbGoTop()

Return( nReg )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMntPlan  บ Autor ณ Prima Info         บ Data ณ  05/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณMonta planilha.                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fMntPlan


If nTpRel == 1
	
	If ( nFE1 + nFLD1 + nFLM1 + nFPNE1 + nFMA1 ) +;
		( nFE2 + nFLD2 + nFLM2 + nFPNE2 + nFMA2 ) +;
		( nFE3 + nFLD3 + nFLM3 + nFPNE3 + nFMA3 ) > 0
		
		If fInfo(@aInfo,cFilAnt)
			cDescFil := aInfo[01]
		EndIf
		
		cLin := cFilAnt + cSep
		cLin += cDescFil + cSep
		
		cLin += StrZero( nFE1,4) + cSep
		cLin += StrZero( nFLD1,4) + cSep
		cLin += StrZero( nFLM1,4) + cSep
		cLin += StrZero( nFPNE1,4) + cSep
		cLin += StrZero( nFMA1,4) + cSep
		cLin += StrZero((nFE1 + nFLD1 + nFLM1 + nFPNE1 + nFMA1),4) + cSep
		
		cLin += StrZero( nFE2,4) + cSep
		cLin += StrZero( nFLD2,4) + cSep
		cLin += StrZero( nFLM2,4) + cSep
		cLin += StrZero( nFPNE2,4) + cSep
		cLin += StrZero( nFMA2,4) + cSep
		cLin += StrZero((nFE2 + nFLD2 + nFLM2 + nFPNE2 + nFMA2),4) + cSep
		
		cLin += StrZero( nFE3,4) + cSep
		cLin += StrZero( nFLD3,4) + cSep
		cLin += StrZero( nFLM3,4) + cSep
		cLin += StrZero( nFPNE3,4) + cSep
		cLin += StrZero( nFMA3,4) + cSep
		cLin += StrZero((nFE3 + nFLD3 + nFLM3 + nFPNE3 + nFMA3),4) + cSep
		
		cLin += StrZero( nFE1+nFE2+nFE3,4) + cSep
		cLin += StrZero( nFLD1+nFLD2+nFLD3,4) + cSep
		cLin += StrZero( nFLM1+nFLM2+nFLM3,4) + cSep
		cLin += StrZero( nFPNE1+nFPNE2+nFPNE3,4) + cSep
		cLin += StrZero( nFMA1+nFMA2+nFMA3,4) + cSep
		
		cLin += StrZero( ( nFE1 + nFLD1 + nFLM1 + nFPNE1 + nFMA1 ) +;
		( nFE2 + nFLD2 + nFLM2 + nFPNE2 + nFMA2 ) +;
		( nFE3 + nFLD3 + nFLM3 + nFPNE3 + nFMA3 ) ,4) + cSep
		
		cLin += cEol
		
		fGravaTxt( cLin )
		
		nFE1 := nFLD1 := nFLM1 := nFPNE1 := nFMA1 := 0
		nFE2 := nFLD2 := nFLM2 := nFPNE2 := nFMA2 := 0
		nFE3 := nFLD3 := nFLM3 := nFPNE3 := nFMA3 := 0
		
	EndIf
	
ElseIf nTpRel == 2
	
	If ( nFE1 + nFLD1 + nFLM1 + nFPNE1 + nFMA1 ) +;
		( nFE2 + nFLD2 + nFLM2 + nFPNE2 + nFMA2 ) +;
		( nFE3 + nFLD3 + nFLM3 + nFPNE3 + nFMA3 ) > 0
		
		If fInfo(@aInfo,cUTAnt)
			cDescUT := aInfo[01]
		EndIf
		
		cLin := cUTAnt + cSep
		cLin += cDescUT + cSep
		
		cLin += StrZero( nFE1,4) + cSep
		cLin += StrZero( nFLD1,4) + cSep
		cLin += StrZero( nFLM1,4) + cSep
		cLin += StrZero( nFPNE1,4) + cSep
		cLin += StrZero( nFMA1,4) + cSep
		cLin += StrZero((nFE1 + nFLD1 + nFLM1 + nFPNE1 + nFMA1),4) + cSep
		
		cLin += StrZero( nFE2,4) + cSep
		cLin += StrZero( nFLD2,4) + cSep
		cLin += StrZero( nFLM2,4) + cSep
		cLin += StrZero( nFPNE2,4) + cSep
		cLin += StrZero( nFMA2,4) + cSep
		cLin += StrZero((nFE2 + nFLD2 + nFLM2 + nFPNE2 + nFMA2),4) + cSep
		
		cLin += StrZero( nFE3,4) + cSep
		cLin += StrZero( nFLD3,4) + cSep
		cLin += StrZero( nFLM3,4) + cSep
		cLin += StrZero( nFPNE3,4) + cSep
		cLin += StrZero( nFMA3,4) + cSep
		cLin += StrZero((nFE3 + nFLD3 + nFLM3 + nFPNE3 + nFMA3),4) + cSep
		
		cLin += StrZero( nFE1+nFE2+nFE3,4) + cSep
		cLin += StrZero( nFLD1+nFLD2+nFLD3,4) + cSep
		cLin += StrZero( nFLM1+nFLM2+nFLM3,4) + cSep
		cLin += StrZero( nFPNE1+nFPNE2+nFPNE3,4) + cSep
		cLin += StrZero( nFMA1+nFMA2+nFMA3,4) + cSep
		
		cLin += StrZero( ( nFE1 + nFLD1 + nFLM1 + nFPNE1 + nFMA1 ) +;
		( nFE2 + nFLD2 + nFLM2 + nFPNE2 + nFMA2 ) +;
		( nFE3 + nFLD3 + nFLM3 + nFPNE3 + nFMA3 ) ,4) + cSep
		
		cLin += cEol
		
		fGravaTxt( cLin )
		
		nFE1 := nFLD1 := nFLM1 := nFPNE1 := nFMA1 := 0
		nFE2 := nFLD2 := nFLM2 := nFPNE2 := nFMA2 := 0
		nFE3 := nFLD3 := nFLM3 := nFPNE3 := nFMA3 := 0
		
	EndIf
	
ElseIf nTpRel == 3
	
	
	If ( nFE1 + nFLD1 + nFLM1 + nFPNE1 + nFMA1 ) +;
		( nFE2 + nFLD2 + nFLM2 + nFPNE2 + nFMA2 ) +;
		( nFE3 + nFLD3 + nFLM3 + nFPNE3 + nFMA3 ) > 0
		
		If fInfo(@aInfo,cFilAnt)
			cDescFil := aInfo[01]
		EndIf
		
		If fInfo(@aInfo,cUTAnt)
			cDescUT := aInfo[01]
		EndIf
		
		
		cLin := cFilAnt + cSep
		cLin += cDescFil + cSep
		
		cLin += cUTAnt + cSep
		cLin += cDescUT + cSep
		
		cLin += StrZero( nFE1,4) + cSep
		cLin += StrZero( nFLD1,4) + cSep
		cLin += StrZero( nFLM1,4) + cSep
		cLin += StrZero( nFPNE1,4) + cSep
		cLin += StrZero( nFMA1,4) + cSep
		cLin += StrZero((nFE1 + nFLD1 + nFLM1 + nFPNE1 + nFMA1),4) + cSep
		
		cLin += StrZero( nFE2,4) + cSep
		cLin += StrZero( nFLD2,4) + cSep
		cLin += StrZero( nFLM2,4) + cSep
		cLin += StrZero( nFPNE2,4) + cSep
		cLin += StrZero( nFMA2,4) + cSep
		cLin += StrZero((nFE2 + nFLD2 + nFLM2 + nFPNE2 + nFMA2),4) + cSep
		
		cLin += StrZero( nFE3,4) + cSep
		cLin += StrZero( nFLD3,4) + cSep
		cLin += StrZero( nFLM3,4) + cSep
		cLin += StrZero( nFPNE3,4) + cSep
		cLin += StrZero( nFMA3,4) + cSep
		cLin += StrZero((nFE3 + nFLD3 + nFLM3 + nFPNE3 + nFMA3),4) + cSep
		
		cLin += StrZero( nFE1+nFE2+nFE3,4) + cSep
		cLin += StrZero( nFLD1+nFLD2+nFLD3,4) + cSep
		cLin += StrZero( nFLM1+nFLM2+nFLM3,4) + cSep
		cLin += StrZero( nFPNE1+nFPNE2+nFPNE3,4) + cSep
		cLin += StrZero( nFMA1+nFMA2+nFMA3,4) + cSep
		
		cLin += StrZero( ( nFE1 + nFLD1 + nFLM1 + nFPNE1 + nFMA1 ) +;
		( nFE2 + nFLD2 + nFLM2 + nFPNE2 + nFMA2 ) +;
		( nFE3 + nFLD3 + nFLM3 + nFPNE3 + nFMA3 ) ,4) + cSep
		
		cLin += cEol
		
		fGravaTxt( cLin )
		
		nFE1 := nFLD1 := nFLM1 := nFPNE1 := nFMA1 := 0
		nFE2 := nFLD2 := nFLM2 := nFPNE2 := nFMA2 := 0
		nFE3 := nFLD3 := nFLM3 := nFPNE3 := nFMA3 := 0
		
	EndIf
	
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfBscAfast บ Autor ณ Prima Info         บ Data ณ  05/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณVerifica os afastamentos do periodo.                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fBscAfast

Local cQuery

cQuery := "SELECT R8_TIPO"
cQuery += "  FROM " + RetSqlName("SR8")
cQuery += " WHERE D_E_L_E_T_ <> '*'"
cQuery += "   AND R8_FILIAL = '" + SRANPP4->RC_FILIAL + "'"
cQuery += "   AND R8_MAT = '" + SRANPP4->RC_MAT + "'"
cQuery += "   AND R8_TIPO <>'F'"
cQuery += "   AND R8_DATAINI BETWEEN '' AND '" + dDtInic + "'"
cQuery += "   AND (R8_DATAFIM >= '" + dDtFim + "'"
cQuery += "    OR R8_DATAFIM ='')"

TCQuery cQuery New Alias "EPAFA"

EPAFA->(dbGoTop())

While !EPAFA->(Eof())
	cTpAfast := EPAFA->R8_TIPO
	EPAFA->(dbSkip())
EndDo

EPAFA->(dbCloseArea())

Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaSX1   บ Autor ณ PrimaInfo          บ Data ณ  24/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณObjetivo desta funcao e verificar se existe o grupo de      บฑฑ
ฑฑบ          ณperguntas, se nao existir a funcao ira cria-lo.             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณcPerg -> Nome com  grupo de perguntas em questใo.           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function CriaSx1(cPerg)

Local aHelp := {}

PutSx1(cPerg,"01","Data Base ?"          ,"","","mv_ch1","D",08,00,00,"G","naovazio"  ,""   ,"","","mv_par01",""        ,"","","",""          ,"","",""       ,"","","","","","","","","","","","")
PutSx1(cPerg,"02","Matricula De ? "      ,"","","mv_ch2","C",06,00,00,"G",""          ,"SRA","","","mv_par02",""        ,"","","",""          ,"","",""       ,"","","","","","","","","","","","")
PutSx1(cPerg,"03","Matricula At้ ?"      ,"","","mv_ch3","C",06,00,00,"G",""          ,"SRA","","","mv_par03",""        ,"","","",""          ,"","",""       ,"","","","","","","","","","","","")
PutSx1(cPerg,"04","Categoria ?"          ,"","","mv_ch4","C",15,00,00,"G","fCategoria",""   ,"","","mv_par04",""        ,"","","",""          ,"","",""       ,"","","","","","","","","","","","")
PutSx1(cPerg,"05","Trata ?"              ,"","","mv_ch5","N",01,00,00,"C",""          ,""   ,"","","mv_par05","1-Filial","","","","2-UnidTrab","","","3-Ambos","","","","","","","","","","","","")

Return Nil
