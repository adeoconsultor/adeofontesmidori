#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE          cEol         CHR(13)+CHR(10)
#DEFINE          cSep         ";"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPAMNPP3  º Autor ³ Prima Info         º Data ³  28/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera Planilha excel com o resumo da folha de pagamento     º±±
±±º          ³sintetico                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10 - Atlantica Midori                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GPAMNPP3

Private cString, cPerg, oGeraTxt
Private _cFiltroRC

cPerg       := "GPAMNPP3"
CriaSx1(cPerg)

Pergunte(cPerg, .F.)
dbSelectArea("SRA")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oGeraTxt FROM  200,001 TO 410,480 TITLE OemToAnsi( "Planilha Folha de Pagamento/Sintetica" ) PIXEL

@ 002, 010 TO 095, 230 OF oGeraTxt  PIXEL
@ 010, 018 SAY " Este programa ira gerar o arquivo integrado ao Excel da       " SIZE 200, 007 OF oGeraTxt PIXEL
@ 018, 018 SAY " Planilha da Folha de Pagamento/Sintetica por mes.             " SIZE 200, 007 OF oGeraTxt PIXEL
@ 026, 018 SAY " Conforme selecao dos parametros usuario.                      " SIZE 200, 007 OF oGeraTxt PIXEL

DEFINE SBUTTON FROM 070,098 TYPE 5 ENABLE OF oGeraTxt ACTION (fFiltro())
DEFINE SBUTTON FROM 070,128 TYPE 5 ENABLE OF oGeraTxt ACTION (Pergunte(cPerg,.T.))
DEFINE SBUTTON FROM 070,158 TYPE 1 ENABLE OF oGeraTxt ACTION (OkGeraTxt(),oGeraTxt:End())
DEFINE SBUTTON FROM 070,188 TYPE 2 ENABLE OF oGeraTxt ACTION (oGeraTxt:End())

ACTIVATE MSDIALOG oGeraTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³OKGERATXT º Autor ³ AP5 IDE            º Data ³  28/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkGeraTxt
Processa({|| RunCont() },"Processando...")
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RunCont  º Autor ³ AP5 IDE            º Data ³  17/03/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß /*/
Static Function RunCont

Local lSetCentury := __SetCentury( "on" )
Local cDirDocs    := MsDocPath()
Local cPath       := AllTrim( GetTempPath() )
Local oExcelApp
Local cLin, nTotReg, nContReg
Local cNomeArq
Local aInfo	      := {}
Local cDescFil    := ""
Local cDescUT     := ""
Local cFilAnt     := ""
Local cUTAnt      := ""

Private nHdl
Private cFilDe,cFilAte,cMatDe,cMatAte,cPeriodo,nTpRel,cSituac,cCatFolh,nTpFol

Pergunte(cPerg,.F.)

cFilDe   := mv_par01
cFilAte  := mv_par02
cCCDe    := mv_par03
cCCAte   := mv_par04
cMatDe   := mv_par05
cMatAte  := mv_par06
cPeriodo := Substr(DtoS(mv_par07),1,6)
nTpRel   := mv_par08
cSituac  := StrTran(mv_par09,"*","")
cCatFolh := StrTran(mv_par10,"*","")
nTpFol   := mv_par11

// Cria Arquivo Texto   
If nTpFol == 1
	MsAguarde( {|| fMtaQuery()}, "Processando...", "Selecao de Registros" )
Else
	MsAguarde( {|| fMta13Query()}, "Processando...", "Selecao de Registros" )
EndIf

If Select( "SRCFOL" ) == 0
	Return
EndIf

cNomeArq  := CriaTrab(,.F.) + ".CSV"

nHdl := fCreate( cDirDocs + "\" + cNomeArq )

If nHdl == -1
	MsgAlert("O arquivo de nome "+cNomeArq+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
EndIf

//Grava cabeçalho da planilha
fGrvCab()

//CENTRO DE CUSTO
dbSelectArea( "CTT" )
dbSetOrder(1)
dbgotop()

nTotReg  := 1
nContReg := 1
dbSelectArea( "SRCFOL" )
nTotReg := fLastReg( 11 )
dbGoTop()
ProcRegua( nTotReg )

While !SRCFOL->(Eof())
	
	IncProc( "Processando: "+StrZero(nContReg,6)+" de "+StrZero(nTotReg,6))
	nContReg++
If nTpFol == 1
	If nTpRel == 1
	
		If SRCFOL->RC_FILIAL # cFilAnt
			If fInfo(@aInfo,SRCFOL->RC_FILIAL)
				cDescFil := aInfo[01]
			EndIf
			cFilAnt  := SRCFOL->RC_FILIAL
		EndIf

		cLin := SRCFOL->RC_FILIAL + cSep
		cLin += cDescFil + cSep
		cLin += SRCFOL->RC_CC + cSep
		cLin += AllTrim(Posicione("CTT",1,xFilial("CTT")+SRCFOL->RC_CC,"CTT_DESC01")) + cSep
		cLin += AllTrim(SRCFOL->RC_PD) + cSep
		cLin += AllTrim(SRCFOL->RV_DESC) + cSep
		cLin += AllTrim(SRCFOL->RC_TIPO1) + cSep
		cLin += Transform(SRCFOL->RC_HORAS,"@E 999,999,999,999.99") + cSep
		cLin += Transform(SRCFOL->RC_VALOR,"@E 999,999,999,999,999.99") + cSep
		cLin += Transform(SRCFOL->QUANT,"@E 999,999,999,999,999.99") + cSep
		cLin += cEol    
		
	ElseIf  nTpRel == 2

		If SRCFOL->RC_ITEM # cUtAnt
			If fInfo(@aInfo,SRCFOL->RC_ITEM)
				cDescUT := aInfo[01]
			EndIf
			cUTAnt  := SRCFOL->RC_ITEM
		EndIf

		cLin := SRCFOL->RC_ITEM + cSep
		cLin += cDescUT + cSep		
		cLin += SRCFOL->RC_CC + cSep
		cLin += AllTrim(Posicione("CTT",1,xFilial("CTT")+SRCFOL->RC_CC,"CTT_DESC01")) + cSep
		cLin += AllTrim(SRCFOL->RC_PD) + cSep
		cLin += AllTrim(SRCFOL->RV_DESC) + cSep
		cLin += AllTrim(SRCFOL->RC_TIPO1) + cSep
		cLin += Transform(SRCFOL->RC_HORAS,"@E 999,999,999,999.99") + cSep
		cLin += Transform(SRCFOL->RC_VALOR,"@E 999,999,999,999,999.99") + cSep
		cLin += Transform(SRCFOL->QUANT,"@E 999,999,999,999,999.99") + cSep
		cLin += cEol
	Else

		If SRCFOL->RC_FILIAL # cFilAnt
			If fInfo(@aInfo,SRCFOL->RC_FILIAL)
				cDescFil := aInfo[01]
			EndIf
			cFilAnt  := SRCFOL->RC_FILIAL
		EndIf
	
		If SRCFOL->RC_ITEM # cUtAnt
			If fInfo(@aInfo,SRCFOL->RC_ITEM)
				cDescUT := aInfo[01]
			EndIf
			cUTAnt  := SRCFOL->RC_ITEM
		EndIf
                                         
		cLin := SRCFOL->RC_FILIAL + cSep
		cLin += cDescFil + cSep
		cLin += SRCFOL->RC_ITEM + cSep
		cLin += cDescUT + cSep
		cLin += SRCFOL->RC_CC + cSep
		cLin += AllTrim(Posicione("CTT",1,xFilial("CTT")+SRCFOL->RC_CC,"CTT_DESC01")) + cSep
		cLin += AllTrim(SRCFOL->RC_PD) + cSep
		cLin += AllTrim(SRCFOL->RV_DESC) + cSep
		cLin += AllTrim(SRCFOL->RC_TIPO1) + cSep
		cLin += Transform(SRCFOL->RC_HORAS,"@E 999,999,999,999.99") + cSep
		cLin += Transform(SRCFOL->RC_VALOR,"@E 999,999,999,999,999.99") + cSep
		cLin += Transform(SRCFOL->QUANT,"@E 999,999,999,999,999.99") + cSep
		cLin += cEol
	EndIf
	
	fGravaTxt( cLin )
	
	SRCFOL->(dbSkip())
Else
	If nTpRel == 1
	
		If SRCFOL->RI_FILIAL # cFilAnt
			If fInfo(@aInfo,SRCFOL->RI_FILIAL)
				cDescFil := aInfo[01]
			EndIf
			cFilAnt  := SRCFOL->RI_FILIAL
		EndIf

		cLin := SRCFOL->RI_FILIAL + cSep
		cLin += cDescFil + cSep
		cLin += SRCFOL->RI_CC + cSep
		cLin += AllTrim(Posicione("CTT",1,xFilial("CTT")+SRCFOL->RI_CC,"CTT_DESC01")) + cSep
		cLin += AllTrim(SRCFOL->RI_PD) + cSep
		cLin += AllTrim(SRCFOL->RV_DESC) + cSep
		cLin += AllTrim(SRCFOL->RI_TIPO1) + cSep
		cLin += Transform(SRCFOL->RI_HORAS,"@E 999,999,999,999.99") + cSep
		cLin += Transform(SRCFOL->RI_VALOR,"@E 999,999,999,999,999.99") + cSep
		cLin += Transform(SRCFOL->QUANT,"@E 999,999,999,999,999.99") + cSep
		cLin += cEol    
		
	ElseIf  nTpRel == 2

		If SRCFOL->RI_ITEM # cUtAnt
			If fInfo(@aInfo,SRCFOL->RI_ITEM)
				cDescUT := aInfo[01]
			EndIf
			cUTAnt  := SRCFOL->RI_ITEM
		EndIf

		cLin := SRCFOL->RI_ITEM + cSep
		cLin += cDescUT + cSep		
		cLin += SRCFOL->RI_CC + cSep
		cLin += AllTrim(Posicione("CTT",1,xFilial("CTT")+SRCFOL->RI_CC,"CTT_DESC01")) + cSep
		cLin += AllTrim(SRCFOL->RI_PD) + cSep
		cLin += AllTrim(SRCFOL->RV_DESC) + cSep
		cLin += AllTrim(SRCFOL->RI_TIPO1) + cSep
		cLin += Transform(SRCFOL->RI_HORAS,"@E 999,999,999,999.99") + cSep
		cLin += Transform(SRCFOL->RI_VALOR,"@E 999,999,999,999,999.99") + cSep
		cLin += Transform(SRCFOL->QUANT,"@E 999,999,999,999,999.99") + cSep
		cLin += cEol
	Else

		If SRCFOL->RI_FILIAL # cFilAnt
			If fInfo(@aInfo,SRCFOL->RI_FILIAL)
				cDescFil := aInfo[01]
			EndIf
			cFilAnt  := SRCFOL->RI_FILIAL
		EndIf
	
		If SRCFOL->RI_ITEM # cUtAnt
			If fInfo(@aInfo,SRCFOL->RI_ITEM)
				cDescUT := aInfo[01]
			EndIf
			cUTAnt  := SRCFOL->RI_ITEM
		EndIf
                                         
		cLin := SRCFOL->RI_FILIAL + cSep
		cLin += cDescFil + cSep
		cLin += SRCFOL->RI_ITEM + cSep
		cLin += cDescUT + cSep
		cLin += SRCFOL->RI_CC + cSep
		cLin += AllTrim(Posicione("CTT",1,xFilial("CTT")+SRCFOL->RI_CC,"CTT_DESC01")) + cSep
		cLin += AllTrim(SRCFOL->RI_PD) + cSep
		cLin += AllTrim(SRCFOL->RV_DESC) + cSep
		cLin += AllTrim(SRCFOL->RI_TIPO1) + cSep
		cLin += Transform(SRCFOL->RI_HORAS,"@E 999,999,999,999.99") + cSep
		cLin += Transform(SRCFOL->RI_VALOR,"@E 999,999,999,999,999.99") + cSep
		cLin += Transform(SRCFOL->QUANT,"@E 999,999,999,999,999.99") + cSep
		cLin += cEol
	EndIf
	
	fGravaTxt( cLin )
	
	SRCFOL->(dbSkip())
EndIf
	
EndDo

SRCFOL->(dbCloseArea())
CTT->(dbCloseArea())

fClose( nHdl )

MsAguarde( {|| fStartExcel( cDirDocs, cNomeArq, cPath )}, "Aguarde...", "Integrando Planilha ao Excel..." )

If !lSetCentury
	__SetCentury( "off" )
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fStartExcelºAutor  ³PrimaInfo           º Data ³  15/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                             º±±
±±º          ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Para uso do programa principal	                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fMtaQuery ºAutor  ³PrimaInfo           º Data ³  28/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Programa Principal                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fMtaQuery()

Local cQuery   := ""
Local cArqPesq := ""

If cPeriodo >= GetMv("MV_FOLMES")
	cArqPesq := RetSqlName( "SRC")
Else
	cArqPesq := "RC"+cEmpAnt+Substr(cPeriodo,3,4)
EndIf

If nTpRel ==1
	cQuery := "SELECT RC_FILIAL,RC_CC,RC_PD,RV_DESC,RC_TIPO1,SUM(RC_VALOR) AS RC_VALOR,SUM(RC_HORAS) AS RC_HORAS,COUNT(1) AS QUANT"
	cQuery += "  FROM "+cArqPesq+" RC, "+ RetSqlName( "SRV") +" RV, "+ RetSqlName( "SRA") +" RA"
	cQuery += " WHERE RC.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RV.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RA.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RC_PD = RV_COD"
	cQuery += "   AND RC_FILIAL = RA_FILIAL"
	cQuery += "   AND RC_MAT = RA_MAT"
	If !Empty(_cFiltroRC)
		cQuery += "   AND ("+_cFiltroRC+")"
	Endif
	cQuery += "   AND RC_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
	cQuery += "   AND RC_CC BETWEEN '" + cCCDe + "' AND '" + cCCAte + "'"
	cQuery += "   AND RC_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
	cQuery += "   AND RA_CATFUNC LIKE'["+cCatFolh+"]'"
	cQuery += "   AND RA_SITFOLH LIKE'["+cSituac+"]'"
	cQuery += " GROUP BY RC_FILIAL,RC_CC,RC_PD,RV_DESC,RC_TIPO1"
	cQuery += " ORDER BY RC_FILIAL,RC_CC,RC_PD,RV_DESC"
	
ElseIf nTpRel ==2
	
	cQuery := "SELECT RC_ITEM,RC_CC,RC_PD,RV_DESC,RC_TIPO1,SUM(RC_VALOR) AS RC_VALOR,SUM(RC_HORAS) AS RC_HORAS,COUNT(1) AS QUANT"
	cQuery += "  FROM "+cArqPesq+" RC, "+ RetSqlName( "SRV") +" RV, "+ RetSqlName( "SRA") +" RA"
	cQuery += " WHERE RC.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RV.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RA.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RC_PD = RV_COD"
	cQuery += "   AND RC_FILIAL = RA_FILIAL"
	cQuery += "   AND RC_MAT = RA_MAT"
	If !Empty(_cFiltroRC)
		cQuery += "   AND ("+_cFiltroRC+")"
	Endif
	cQuery += "   AND RC_ITEM BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
	cQuery += "   AND RC_CC BETWEEN '" + cCCDe + "' AND '" + cCCAte + "'"
	cQuery += "   AND RC_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
	cQuery += "   AND RA_CATFUNC LIKE'["+cCatFolh+"]'"
	cQuery += "   AND RA_SITFOLH LIKE'["+cSituac+"]'"
	cQuery += " GROUP BY RC_ITEM,RC_CC,RC_PD,RV_DESC,RC_TIPO1"
	cQuery += " ORDER BY RC_ITEM,RC_CC,RC_PD,RV_DESC"
Else
	cQuery := "SELECT RC_FILIAL,RC_CC,RC_ITEM,RC_PD,RV_DESC,RC_TIPO1,SUM(RC_VALOR) AS RC_VALOR,SUM(RC_HORAS) AS RC_HORAS,COUNT(1) AS QUANT"
	cQuery += "  FROM "+cArqPesq+" RC, "+ RetSqlName( "SRV") +" RV, "+ RetSqlName( "SRA") +" RA"
	cQuery += " WHERE RC.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RV.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RA.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RC_PD = RV_COD"
	cQuery += "   AND RC_FILIAL = RA_FILIAL"
	cQuery += "   AND RC_MAT = RA_MAT"
	If !Empty(_cFiltroRC)
		cQuery += "   AND ("+_cFiltroRC+")"
	Endif
	cQuery += "   AND RC_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
	cQuery += "   AND RC_CC BETWEEN '" + cCCDe + "' AND '" + cCCAte + "'"
	cQuery += "   AND RC_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
	cQuery += "   AND RA_CATFUNC LIKE'["+cCatFolh+"]'"
	cQuery += "   AND RA_SITFOLH LIKE'["+cSituac+"]'"
	cQuery += " GROUP BY RC_FILIAL,RC_CC,RC_ITEM,RC_PD,RV_DESC,RC_TIPO1"
	cQuery += " ORDER BY RC_FILIAL,RC_CC,RC_ITEM,RC_PD,RV_DESC"
EndIf
TCQuery cQuery New Alias "SRCFOL"

TcSetField( "SRCFOL", "RC_VALOR"   , "N", 15, 2 )
TcSetField( "SRCFOL", "RC_HORAS"   , "N", 12, 2 )
TcSetField( "SRCFOL", "QUANT"      , "N", 12, 2 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fMta13Query ºAutor  ³PrimaInfo         º Data ³  28/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Programa Principal                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fMta13Query()

Local cQuery   := ""
Local cArqPesq := ""

If cPeriodo >= GetMv("MV_FOLMES")
	cArqPesq := RetSqlName( "SRI")
Else
	cArqPesq := "RI"+cEmpAnt+Substr(cPeriodo,3,2)+"13"
EndIf

If nTpRel ==1
	cQuery := "SELECT RI_FILIAL,RI_CC,RI_PD,RV_DESC,RI_TIPO1,SUM(RI_VALOR) AS RI_VALOR,SUM(RI_HORAS) AS RI_HORAS,COUNT(1) AS QUANT"
	cQuery += "  FROM "+cArqPesq+" RI, "+ RetSqlName( "SRV") +" RV, "+ RetSqlName( "SRA") +" RA"
	cQuery += " WHERE RI.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RV.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RA.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RI_PD = RV_COD"
	cQuery += "   AND RI_FILIAL = RA_FILIAL"
	cQuery += "   AND RI_MAT = RA_MAT"
	If !Empty(_cFiltroRC)
		cQuery += "   AND ("+_cFiltroRC+")"
	Endif
	cQuery += "   AND RI_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
	cQuery += "   AND RI_CC BETWEEN '" + cCCDe + "' AND '" + cCCAte + "'"
	cQuery += "   AND RI_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
	cQuery += "   AND RA_CATFUNC LIKE'["+cCatFolh+"]'"
	cQuery += "   AND RA_SITFOLH LIKE'["+cSituac+"]'"
	cQuery += " GROUP BY RI_FILIAL,RI_CC,RI_PD,RV_DESC,RI_TIPO1"
	cQuery += " ORDER BY RI_FILIAL,RI_CC,RI_PD,RV_DESC"
	
ElseIf nTpRel ==2
	
	cQuery := "SELECT RI_ITEM,RI_CC,RI_PD,RV_DESC,RI_TIPO1,SUM(RI_VALOR) AS RI_VALOR,SUM(RI_HORAS) AS RI_HORAS,COUNT(1) AS QUANT"
	cQuery += "  FROM "+cArqPesq+" RI, "+ RetSqlName( "SRV") +" RV, "+ RetSqlName( "SRA") +" RA"
	cQuery += " WHERE RI.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RV.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RA.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RI_PD = RV_COD"
	cQuery += "   AND RI_FILIAL = RA_FILIAL"
	cQuery += "   AND RI_MAT = RA_MAT"
	If !Empty(_cFiltroRC)
		cQuery += "   AND ("+_cFiltroRC+")"
	Endif
	cQuery += "   AND RI_ITEM BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
	cQuery += "   AND RI_CC BETWEEN '" + cCCDe + "' AND '" + cCCAte + "'"
	cQuery += "   AND RI_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
	cQuery += "   AND RA_CATFUNC LIKE'["+cCatFolh+"]'"
	cQuery += "   AND RA_SITFOLH LIKE'["+cSituac+"]'"
	cQuery += " GROUP BY RI_ITEM,RI_CC,RI_PD,RV_DESC,RI_TIPO1"
	cQuery += " ORDER BY RI_ITEM,RI_CC,RI_PD,RV_DESC"
Else
	cQuery := "SELECT RI_FILIAL,RI_CC,RI_ITEM,RI_PD,RV_DESC,RI_TIPO1,SUM(RI_VALOR) AS RI_VALOR,SUM(RI_HORAS) AS RI_HORAS,COUNT(1) AS QUANT"
	cQuery += "  FROM "+cArqPesq+" RI, "+ RetSqlName( "SRV") +" RV, "+ RetSqlName( "SRA") +" RA"
	cQuery += " WHERE RI.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RV.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RA.D_E_L_E_T_ <>'*'"
	cQuery += "   AND RI_PD = RV_COD"
	cQuery += "   AND RI_FILIAL = RA_FILIAL"
	cQuery += "   AND RI_MAT = RA_MAT"
	If !Empty(_cFiltroRC)
		cQuery += "   AND ("+_cFiltroRC+")"
	Endif
	cQuery += "   AND RI_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
	cQuery += "   AND RI_CC BETWEEN '" + cCCDe + "' AND '" + cCCAte + "'"
	cQuery += "   AND RI_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
	cQuery += "   AND RA_CATFUNC LIKE'["+cCatFolh+"]'"
	cQuery += "   AND RA_SITFOLH LIKE'["+cSituac+"]'"
	cQuery += " GROUP BY RI_FILIAL,RI_CC,RI_ITEM,RI_PD,RV_DESC,RI_TIPO1"
	cQuery += " ORDER BY RI_FILIAL,RI_CC,RI_ITEM,RI_PD,RV_DESC"
EndIf

TCQuery cQuery New Alias "SRCFOL"

TcSetField( "SRCFOL", "RI_VALOR"   , "N", 15, 2 )
TcSetField( "SRCFOL", "RI_HORAS"   , "N", 12, 2 )
TcSetField( "SRCFOL", "QUANT"      , "N", 12, 2 )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGrvCab   ºAutor  ³PrimaInfo           º Data ³  14/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Para uso do programa principal                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function fGrvCab()

Local cLin    

If nTpFol == 1
	cLin := "Folha Pagamento" + cSep
	cLin += cEol
Else 
	cLin := "13 Salario" + cSep
	cLin += cEol
EndIf                  

fGravaTxt( cLin )

If nTpRel == 1
	cLin := "Filial" + cSep
	cLin += "Desc_Filial" + cSep
	cLin += "Centro de Custo" + cSep
	cLin += "Desc_CCusto" + cSep
	cLin += "Verba" + cSep
	cLin += "Desc_Verba" + cSep
	cLin += "Tipo" + cSep
	cLin += "Referencia" + cSep
	cLin += "Valor" + cSep
	cLin += "Ocorrencias" + cSep
	cLin += cEol
ElseIf nTpRel == 2
	cLin := "Unid_Trabalho" + cSep
	cLin += "Desc_UnidTrab" + cSep
	cLin += "Centro de Custo" + cSep
	cLin += "Desc_CCusto" + cSep
	cLin += "Verba" + cSep
	cLin += "Desc_Verba" + cSep
	cLin += "Tipo" + cSep
	cLin += "Referencia" + cSep
	cLin += "Valor" + cSep
	cLin += "Ocorrencias" + cSep
	cLin += cEol
Else
	cLin := "Filial" + cSep
	cLin += "Desc_Filial" + cSep
	cLin += "Unid.Trabalho" + cSep
	cLin += "Desc_UnidTrab" + cSep
	cLin += "Centro de Custo" + cSep
	cLin += "Desc_CCusto" + cSep
	cLin += "Verba" + cSep
	cLin += "Desc_Verba" + cSep
	cLin += "Tipo" + cSep
	cLin += "Referencia" + cSep
	cLin += "Valor" + cSep
	cLin += "Ocorrencias" + cSep
	cLin += cEol
	
EndIf
fGravaTxt( cLin )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fFiltro  ºAutor  ³Microsiga           º Data ³  12/08/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fFiltro

_cFiltroRc := BuildExpr("SRC",,_cFiltroRc,.T.)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGravaTxt ºAutor  ³PrimaInfo           º Data ³  14/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Para uso do progrma principal                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function fGravaTxt( cLin )

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return
	Endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fLastReg  ºAutor  ³PrimaInfo           º Data ³  24/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Uso do programa principal                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaSX1   º Autor ³ Microsiga          º Data ³  09/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Objetivo desta funcao e verificar se existe o grupo de      º±±
±±º          ³perguntas, se nao existir a funcao ira cria-lo.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³cPerg -> Nome com  grupo de perguntas em questão.           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CriaSx1(cPerg)

Local aHelp := {}

PutSx1(cPerg,"01","Filial/Un.Trb De ? "  ,"","","mv_ch1","C",02,00,00,"G",""          ,"XM0","","","mv_Par01",""        ,"","","",""          ,"","",""       ,"","","","","","","","","","","","")
PutSx1(cPerg,"02","Filial/Un.Trb Até ?"  ,"","","mv_ch2","C",02,00,00,"G","NaoVazio"  ,"XM0","","","mv_Par02",""        ,"","","",""          ,"","",""       ,"","","","","","","","","","","","")
PutSx1(cPerg,"03","Centro Custo De ? "   ,"","","mv_ch3","C",10,00,00,"G",""          ,"CTT","","","mv_par03",""        ,"","","",""          ,"","",""       ,"","","","","","","","","","","","")
PutSx1(cPerg,"04","Centro Custo Até ?"   ,"","","mv_ch4","C",10,00,00,"G","NaoVazio"  ,"CTT","","","mv_par04",""        ,"","","",""          ,"","",""       ,"","","","","","","","","","","","")
PutSx1(cPerg,"05","Matricula De ? "      ,"","","mv_ch5","C",06,00,00,"G",""          ,"SRA","","","mv_par05",""        ,"","","",""          ,"","",""       ,"","","","","","","","","","","","")
PutSx1(cPerg,"06","Matricula Até ?"      ,"","","mv_ch6","C",06,00,00,"G",""          ,"SRA","","","mv_par06",""        ,"","","",""          ,"","",""       ,"","","","","","","","","","","","")
PutSx1(cPerg,"07","Data ?"               ,"","","mv_ch7","D",08,00,00,"G","naovazio"  ,""   ,"","","mv_par07",""        ,"","","",""          ,"","",""       ,"","","","","","","","","","","","")
PutSx1(cPerg,"08","Trata ?"              ,"","","mv_ch8","N",01,00,00,"C",""          ,""   ,"","","mv_par08","1-Filial","","","","2-UnidTrab","","","3-Ambos","","","","","","","","","","","","")
PutSx1(cPerg,"09","Situacao ?"           ,"","","mv_ch9","C",05,00,00,"G","fSituacao" ,""   ,"","","mv_par09",""        ,"","","",""          ,"","",""       ,"","","","","","","","","","","","")
PutSx1(cPerg,"10","Categoria ?"          ,"","","mv_cha","C",15,00,00,"G","fCategoria",""   ,"","","mv_par10",""        ,"","","",""          ,"","",""       ,"","","","","","","","","","","","")
PutSx1(cPerg,"11","Tipo ?"               ,"","","mv_chb","N",01,00,00,"C",""          ,""   ,"","","mv_par11","Folha"   ,"","","","13Salario" ,"","",""       ,"","","","","","","","","","","","")

Return Nil
