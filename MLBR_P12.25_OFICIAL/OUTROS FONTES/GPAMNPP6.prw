#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE          cEol         CHR(13)+CHR(10)
#DEFINE          cSep         ";"

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?GPAMNPP6  ? Autor ? Prima Info         ? Data ?  04/08/10   ???
????????????????????????????????????????????????????????????????????????????
???Descricao ? Gera Planilha excel Folha e Encargos Sociais               ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? MP10 - Atlantica Midori                                    ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/


User Function GPAMNPP6

Private cString, cPerg, oGeraTxt
Private _cFiltroRA

cPerg       := "GPAMNPP6"
CriaSx1(cPerg)

Pergunte(cPerg, .F.)
dbSelectArea("SRA")
dbSetOrder(1)

//??????????????????????????????????????????????????????????????????????
//? Montagem da tela de processamento.                                  ?
//???????????????????????????????????????????????????????????????????????
DEFINE MSDIALOG oGeraTxt FROM  200,001 TO 410,480 TITLE OemToAnsi( "Relat?rio sint?tico da Folha de Pagamento e Encargos Sociais" ) PIXEL

@ 002, 010 TO 095, 230 OF oGeraTxt  PIXEL
@ 010, 018 SAY " Este programa ira gerar o arquivo integrado ao Excel da       " SIZE 200, 007 OF oGeraTxt PIXEL
@ 018, 018 SAY " Relat?rio sint?tico da Folha de Pagamento e Encargos Sociais  " SIZE 200, 007 OF oGeraTxt PIXEL
@ 026, 018 SAY " Conforme parametros selecionados pelo usuario.                " SIZE 200, 007 OF oGeraTxt PIXEL

DEFINE SBUTTON FROM 070,128 TYPE 5 ENABLE OF oGeraTxt ACTION (Pergunte(cPerg,.T.))
DEFINE SBUTTON FROM 070,158 TYPE 1 ENABLE OF oGeraTxt ACTION (OkGeraTxt(),oGeraTxt:End())
DEFINE SBUTTON FROM 070,188 TYPE 2 ENABLE OF oGeraTxt ACTION (oGeraTxt:End())

ACTIVATE MSDIALOG oGeraTxt Centered

Return

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Fun??o    ?OKGERATXT ? Autor ? AP5 IDE            ? Data ?  28/12/04   ???
????????????????????????????????????????????????????????????????????????????
???Descri??o ? Funcao chamada pelo botao OK na tela inicial de processamen???
???          ? to. Executa a geracao do arquivo texto.                    ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Programa principal                                         ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

Static Function OkGeraTxt
Processa({|| RunCont() },"Processando...")
Return

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Fun??o    ? RunCont  ? Autor ? AP5 IDE            ? Data ?  17/03/02   ???
????????????????????????????????????????????????????????????????????????????
???Descri??o ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Programa principal                                         ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????? /*/
Static Function RunCont

Local lSetCentury := __SetCentury( "on" )
Local cDirDocs    := MsDocPath()
Local cPath       := AllTrim( GetTempPath() )
Local oExcelApp
Local cLin, nTotReg, nContReg
Local cNomeArq,nReg,nx

Private aInfo	  := {}
Private nHdl
Private dDtRela,cCatFolh
Private cFxIni    := ""
Private cFxFim    := ""
Private cSeqFX    := ""
Private nLenVezes := 5
Private cSitQuery := ""
Private nTpPlan   := ""
Private nINSSEmp :=   20.0000 /100
Private nTerEmp  :=    5.8000 /100
Private nAcidEmp :=    4.7400 /100
Private nfgtsEmp :=    8.0000 /100
Private nPFer    := 0
Private nP13Fer  := 0
Private nPFerINS := 0
Private npFerFGT := 0
Private nP13Sal  := 0
Private nP13SINS := 0
Private np13SFGT := 0


Pergunte(cPerg,.F.)

dDtRela    := DtoS(mv_par01)
cCatFolh   := StrTran(mv_par02,"*","")
cNomeArq   := CriaTrab(,.F.) + ".CSV"
nHdl       := fCreate( cDirDocs + "\" + cNomeArq )
nTpPlan    := mv_par04

For nReg:=1 to Len(MV_PAR03)
	cSitQuery += "'"+Subs(MV_PAR03,nReg,1)+"'"
	If ( nReg+1 ) <= Len(MV_PAR03)
		cSitQuery += ","
	Endif
Next nReg

If nHdl == -1
	MsgAlert("O arquivo de nome "+cNomeArq+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
EndIf

For nx := 1 To nLenVezes
	If nTpPlan <> 3
		//Grava cabe?alho da planilha
		If nx == 1
			fGrCab01()
		ElseIf nx == 2
			fGrCab02()
		ElseIf nx == 3
			fGrCab03()
		ElseIf nx == 4
			fGrCab04()
		ElseIf nx == 99
			fGrCab05() 
		Else	       
			fGrCab06() 
		EndIf
	Else 
		//Grava cabe?alho da planilha
		If nx == 1
			fGrCab21()
		ElseIf nx == 2
			fGrCab22()
		ElseIf nx == 3
			fGrCab23()
		ElseIf nx == 4
			fGrCab24()
		ElseIf nx == 99
			fGrCab25()
		Else
			fGrCab26()
		EndIf
	EndIf          
	
	dbSelectArea("RCC")
	dbSetOrder(1)
	If dbSeek(xFilial("RCC")+"U004")
		
		While !RCC->(Eof()) .And. RCC->RCC_CODIGO =="U004"
			
			cFxIni    := Substr(RCC->RCC_CONTEU,1,12)
			cFxFim    := Substr(RCC->RCC_CONTEU,13,12)
			cSeqFX    := RCC->RCC_SEQUEN
			
			// Cria Arquivo Texto
			If nTpPlan == 1
				MsAguarde( {|| fMt0Query(nx)}, "Processando... ", "Selecao de Registros" )
			ElseIf nTpPlan == 2
				MsAguarde( {|| fMt1Query(nx)}, "Processando... ", "Selecao de Registros" )
			Else
				MsAguarde( {|| fMt2Query(nx)}, "Processando... ", "Selecao de Registros" )
			EndIf
			
			If Select( "SRANPP6" ) == 0
				Return
			EndIf
			
			nTotReg  := 1
			nContReg := 1
			dbSelectArea( "SRANPP6" )
			nTotReg := fLastReg( 1 )
			dbGoTop()
			ProcRegua( nTotReg )
			
			While !SRANPP6->(Eof())
				
				IncProc( "Processando faixa: "+cSeqFX+"-"+StrZero(nContReg,6)+" de "+StrZero(nTotReg,6))
				nContReg++
				
				fMntPlan(nx)
				SRANPP6->(dbSkip())
				
			EndDo
			
			SRANPP6->(dbCloseArea())
			RCC->(dbSkip())
			
		EndDo
		
	EndIf
	
Next nx

fClose( nHdl )

MsAguarde( {|| fStartExcel( cDirDocs, cNomeArq, cPath )}, "Aguarde...", "Integrando Planilha ao Excel..." )

If !lSetCentury
	__SetCentury( "off" )
EndIf

Return

/*
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
???Programa  ?fStartExcel?Autor  ?PrimaInfo           ? Data ?  15/04/09   ???
?????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                             ???
???          ?                                                             ???
?????????????????????????????????????????????????????????????????????????????
???Uso       ? Para uso do programa principal	                           ???
?????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????? */
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
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fMt0Query ?Autor  ?PrimaInfo           ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ?Programa Princiapal                                         ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function fMt0Query(nx)

Local cQuery    := ""
Local cArqMvto  := ""
Local cArqVerba := RetSqlName( "SRV" )
Local cArqFunci := RetSqlName( "SRA" )
Local cArqProv  := RetSqlName( "SRT" )
Local cPerProAn := "" //Periodo provisao anterior
Local cPerProAt := "" //Periodo Provisao Atual
                                      
If Substr(Dtos(mv_par01),1,6) >= GetMv("MV_FOLMES")
	cArqMvto := RetSqlName( "SRC" )
Else
	cArqMvto := "RC"+cEmpAnt+Substr(Dtos(mv_par01),3,4)
EndIf

If nx == 1
	cQuery := "SELECT RA_FILIAL,RA_CC,COUNT(1) FUNCIONA,SUM(SAL_BS)SAL_BS,SUM(SAL_PG)SAL_PG,SUM(HR_EXTRA)HR_EXTRA,SUM(SAL_13)SAL_13,SUM(FERIAS)FERIAS,SUM(GRATIF)GRATIF,SUM(OUT_PROV)OUT_PROV"
	cQuery += "  FROM(SELECT DISTINCT SRA.RA_FILIAL,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_CODFOL = '318'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_BS,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '01'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_PG,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '02'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS HR_EXTRA,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '03'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_13,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '04'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS FERIAS,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '05'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS GRATIF,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '06'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS OUT_PROV"
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "      WHERE SRA.D_E_L_E_T_ <> '*'"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE (SAL_BS+SAL_PG+HR_EXTRA+SAL_13+FERIAS+GRATIF+OUT_PROV)  > 0"
	cQuery += " GROUP BY RA_FILIAL,RA_CC"
	cQuery += " ORDER BY RA_FILIAL,RA_CC"
	
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","SAL_PG"   ,"N",15,2)
	TcSetField("SRANPP6","HR_EXTRA" ,"N",15,2)
	TcSetField("SRANPP6","SAL_13"   ,"N",15,2)
	TcSetField("SRANPP6","FERIAS"   ,"N",15,2)
	TcSetField("SRANPP6","GRATIF"   ,"N",15,2)
	TcSetField("SRANPP6","OUT_PROV" ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA" ,"N",4,0)
	
ElseIf nx == 2
	cQuery := "SELECT RA_FILIAL,RA_CC,COUNT(1) FUNCIONA,SUM(SAL_BS)SAL_BS,"
	cQuery += "SUM(INSS_F)INSS_F,SUM(VREFE_F)VREFE_F,SUM(VTRANSP_F)VTRANSP_F,SUM(IMP_SIND)IMP_SIND,SUM(IRRF)IRRF,SUM(OUT_DESC)OUT_DESC,SUM(ADIANT)ADIANT,"
	cQuery += "SUM(LIQ_FOL)LIQ_FOL"
	cQuery += "  FROM(SELECT DISTINCT SRA.RA_FILIAL,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_CODFOL = '318'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_BS,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '07'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS INSS_F,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '08'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS VREFE_F,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '09'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS VTRANSP_F,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '10'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS IMP_SIND,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '11'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS IRRF,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '12'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS OUT_DESC,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '13'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS ADIANT,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '14'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS LIQ_FOL"
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "      WHERE SRA.D_E_L_E_T_ <> '*'"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE (SAL_BS+INSS_F+VREFE_F+VTRANSP_F+IMP_SIND+IRRF+OUT_DESC+ADIANT+LIQ_FOL)  > 0"
	cQuery += " GROUP BY RA_FILIAL,RA_CC"
	cQuery += " ORDER BY RA_FILIAL,RA_CC"
	
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","SAL_PG"   ,"N",15,2)
	TcSetField("SRANPP6","INSS_F"   ,"N",15,2)
	TcSetField("SRANPP6","VREFE_F"  ,"N",15,2)
	TcSetField("SRANPP6","VTRANSP_F","N",15,2)
	TcSetField("SRANPP6","IMP_SIND" ,"N",15,2)
	TcSetField("SRANPP6","IRRF"     ,"N",15,2)
	TcSetField("SRANPP6","OUT_DESC" ,"N",15,2)
	TcSetField("SRANPP6","ADIANT"   ,"N",15,2)
	TcSetField("SRANPP6","LIQ_FOL"  ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA" ,"N",4,0)
	
ElseIf nx == 3
	cQuery := "SELECT RA_FILIAL,RA_CC,COUNT(1) FUNCIONA,SUM(SAL_BS)SAL_BS,"
	cQuery += "SUM(INSS_EMP)INSS_EMP,SUM(FGTS_EMP)FGTS_EMP,SUM(OUTR_ENC )OUTR_ENC,SUM(FGTS_RES)FGTS_RES,SUM(SENAI)SENAI"
	cQuery += "  FROM(SELECT DISTINCT SRA.RA_FILIAL,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_CODFOL = '318'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_BS,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '15'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS INSS_EMP,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '16'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS FGTS_EMP,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '19'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS OUTR_ENC,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '20'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS FGTS_RES,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '21'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SENAI"
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "      WHERE SRA.D_E_L_E_T_ <> '*'"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE (SAL_BS+INSS_EMP+FGTS_EMP+FGTS_RES+OUTR_ENC+SENAI)  > 0"
	cQuery += " GROUP BY RA_FILIAL,RA_CC"
	cQuery += " ORDER BY RA_FILIAL,RA_CC"
	
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","SAL_PG"   ,"N",15,2)
	TcSetField("SRANPP6","INSS_EMP" ,"N",15,2)
	TcSetField("SRANPP6","FGTS_EMP" ,"N",15,2)
	TcSetField("SRANPP6","OUTR_ENC" ,"N",15,2)
	TcSetField("SRANPP6","FGTS_RES" ,"N",15,2)
	TcSetField("SRANPP6","SENAI"    ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA" ,"N",4,0)
	
ElseIf nx == 4
	
	cQuery := "SELECT RA_FILIAL,RA_CC,COUNT(1) FUNCIONA,SUM(SAL_BS)SAL_BS,"
	cQuery += "SUM(VTRANSP_E)VTRANSP_E,SUM(VREFE_E)VREFE_E,SUM(SEG_VIDA )SEG_VIDA,SUM(CES_BAS)CES_BAS,SUM(ASS_MED )ASS_MED"
	cQuery += "  FROM(SELECT DISTINCT SRA.RA_FILIAL,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_CODFOL = '318'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_BS,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '22'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SEG_VIDA,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '23'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS CES_BAS,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '17'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS VTRANSP_E,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '18'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS VREFE_E,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '24'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS ASS_MED""
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "      WHERE SRA.D_E_L_E_T_ <> '*'"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE (SAL_BS+ASS_MED+CES_BAS+VTRANSP_E+VREFE_E+SEG_VIDA)  > 0"
	cQuery += " GROUP BY RA_FILIAL,RA_CC"
	cQuery += " ORDER BY RA_FILIAL,RA_CC"
	
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","SAL_PG"   ,"N",15,2)
	TcSetField("SRANPP6","ASS_MED" ,"N",15,2)
	TcSetField("SRANPP6","CES_BAS" ,"N",15,2)
	TcSetField("SRANPP6","VTRANSP_E","N",15,2)
	TcSetField("SRANPP6","VREFE_E"  ,"N",15,2)
	TcSetField("SRANPP6","SEG_VIDA" ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA" ,"N",4,0)
	
ElseIf nx == 4 //antes Provisao
	cPerProAt := Substr(dDtRela,1,6)                   
	
	If Substr(dDtRela,5,2) == "12"
		cPerProAn := Str(Val(Substr(dDtRela,1,4))-1,4)+"11"
	Else
		cPerProAn := Substr(dDtRela,1,4)+StrZero(Val(Substr(dDtRela,5,2))-1,2)
	EndIf

	cQuery := "SELECT RA_FILIAL,RA_CC,COUNT(1) FUNCIONA,SUM((ATUAL_FERIAS+BAIXA_FERIAS)-ANTES_FERIAS) AS PR_FERIAS,"
	cQuery += "           SUM((ATUAL_FERIAS_ADIC+BAIXA_FERIAS_ADIC)-ANTES_FERIAS_ADIC) AS PR_FER_ADIC,"
	cQuery += "           SUM((ATUAL_FERIAS_1TER+BAIXA_FERIAS_1TER)-ANTES_FERIAS_1TER) AS PR_FER_1TER,"
	cQuery += "           SUM((ATUAL_FERIAS_INSS+BAIXA_FERIAS_INSS)-ANTES_FERIAS_INSS) AS P_FER_INSS,"
	cQuery += "           SUM((ATUAL_FERIAS_FGTS+BAIXA_FERIAS_FGTS)-ANTES_FERIAS_FGTS) AS P_FER_FGTS,"
	cQuery += "           SUM((ATUAL_13SAL     +BAIXA_13SAL     )-(ANTES_13SAL     +ATUAL_13SAL_ADI)) AS PR_13SAL,"
	cQuery += "           SUM((ATUAL_13SAL_ADIC+BAIXA_13SAL_ADIC)-(ANTES_13SAL_ADIC)) AS PR_13SAL_ADIC,"
	cQuery += "           SUM((ATUAL_13SAL_INSS+BAIXA_13SAL_INSS)-ANTES_13SAL_INSS) AS P_13S_INSS,"
	cQuery += "           SUM((ATUAL_13SAL_FGTS+BAIXA_13SAL_FGTS)-ANTES_13SAL_FGTS) AS P_13S_FGTS"
	cQuery += "  FROM(SELECT SRA.RA_FILIAL,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('729')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_FERIAS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('801')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_FERIAS_ADIC,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('802')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_FERIAS_1TER,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('729')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_FERIAS,"
	
	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('801')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_FERIAS_ADIC,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('802')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_FERIAS_1TER,"
	
	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('790','807')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_FERIAS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('803','808')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_FERIAS_ADIC,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('804','809')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_FERIAS_1TER,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('730')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_FERIAS_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('730')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_FERIAS_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('810','791')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_FERIAS_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('731')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_FERIAS_FGTS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('731')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_FERIAS_FGTS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('792','811')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_FERIAS_FGTS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('735')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_13SAL,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('812')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_13SAL_ADIC,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('735')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_13SAL,"  
	
	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('812')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_13SAL_ADIC,"  

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('819','840')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_13SAL,"   
	
	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('820','841')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_13SAL_ADIC,"   

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('736')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_13SAL_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('736')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_13SAL_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('813')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_13SAL_ADI,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('821','843')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_13SAL_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('737')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_13SAL_FGTS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('737')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_13SAL_FGTS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('822','844')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_13SAL_FGTS"
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "        WHERE SRA.D_E_L_E_T_ = ' '"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE ((ATUAL_FERIAS+BAIXA_FERIAS)-ANTES_FERIAS)+((ATUAL_FERIAS_INSS+BAIXA_FERIAS_INSS)-ANTES_FERIAS_INSS)+
	cQuery += "((ATUAL_FERIAS_FGTS+BAIXA_FERIAS_FGTS)-ANTES_FERIAS_FGTS)+((ATUAL_13SAL+BAIXA_13SAL)-(ANTES_13SAL+ATUAL_13SAL_ADI))+
	cQuery += "((ATUAL_13SAL_INSS+BAIXA_13SAL_INSS)-ANTES_13SAL_INSS)+((ATUAL_13SAL_FGTS+BAIXA_13SAL_FGTS)-ANTES_13SAL_FGTS) <>0
	cQuery += " GROUP BY RA_FILIAL,RA_CC"
	cQuery += " ORDER BY RA_FILIAL,RA_CC"
	
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","PR_FERIAS"  ,"N",15,2)
	TcSetField("SRANPP6","PR_FER_ADIC"  ,"N",15,2)
	TcSetField("SRANPP6","PR_FER_1TER"  ,"N",15,2)		
	TcSetField("SRANPP6","P_FER_INSS" ,"N",15,2)
	TcSetField("SRANPP6","P_FER_FGTS" ,"N",15,2)
	TcSetField("SRANPP6","PR_13SAL"   ,"N",15,2)
	TcSetField("SRANPP6","PR_13SAL_ADIC"   ,"N",15,2)
	TcSetField("SRANPP6","P_13S_INSS" ,"N",15,2)
	TcSetField("SRANPP6","P_13S_FGTS" ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA"   ,"N",4,0)
Else //Provisao Agora
	cQuery := "SELECT RA_FILIAL,RA_CC,COUNT(1) FUNCIONA,SUM(SAL_BS)SAL_BS"
	cQuery += "  FROM(SELECT DISTINCT SRA.RA_FILIAL,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_CODFOL = '318'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_BS"
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "      WHERE SRA.D_E_L_E_T_ <> '*'"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE (SAL_BS)  > 0"
	cQuery += " GROUP BY RA_FILIAL,RA_CC"
	cQuery += " ORDER BY RA_FILIAL,RA_CC"
	
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","SAL_BS"   ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA"   ,"N",4,0)
	
EndIf

Return
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fMt1Query ?Autor  ?PrimaInfo           ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ?Programa Princiapal                                         ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function fMt1Query(nx)

Local cQuery    := ""
Local cArqMvto  := ""
Local cArqVerba := RetSqlName( "SRV" )
Local cArqFunci := RetSqlName( "SRA" )
Local cArqProv  := RetSqlName( "SRT" )
Local cPerProAn := "" //Periodo provisao anterior
Local cPerProAt := "" //Periodo Provisao Atual
                     

If Substr(Dtos(mv_par01),1,6) >= GetMv("MV_FOLMES")
	cArqMvto := RetSqlName( "SRC" )
Else
	cArqMvto := "RC"+cEmpAnt+Substr(Dtos(mv_par01),3,4)
EndIf

If nx == 1
	cQuery := "SELECT RA_ITEM,RA_CC,COUNT(1) FUNCIONA,SUM(SAL_BS)SAL_BS,SUM(SAL_PG)SAL_PG,SUM(HR_EXTRA)HR_EXTRA,SUM(SAL_13)SAL_13,SUM(FERIAS)FERIAS,SUM(GRATIF)GRATIF,SUM(OUT_PROV)OUT_PROV"
	cQuery += "  FROM(SELECT DISTINCT SRA.RA_ITEM,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_CODFOL = '318'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_BS,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '01'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_PG,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '02'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS HR_EXTRA,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '03'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_13,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '04'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS FERIAS,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '05'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS GRATIF,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '06'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS OUT_PROV"
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "      WHERE SRA.D_E_L_E_T_ <> '*'"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE (SAL_BS+SAL_PG+HR_EXTRA+SAL_13+FERIAS+GRATIF+OUT_PROV)  > 0"
	cQuery += " GROUP BY RA_ITEM,RA_CC"
	cQuery += " ORDER BY RA_ITEM,RA_CC"
	
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","SAL_PG"   ,"N",15,2)
	TcSetField("SRANPP6","HR_EXTRA" ,"N",15,2)
	TcSetField("SRANPP6","SAL_13"   ,"N",15,2)
	TcSetField("SRANPP6","FERIAS"   ,"N",15,2)
	TcSetField("SRANPP6","GRATIF"   ,"N",15,2)
	TcSetField("SRANPP6","OUT_PROV" ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA" ,"N",4,0)
	
ElseIf nx == 2
	cQuery := "SELECT RA_ITEM,RA_CC,COUNT(1) FUNCIONA,SUM(SAL_BS)SAL_BS,"
	cQuery += "SUM(INSS_F)INSS_F,SUM(VREFE_F)VREFE_F,SUM(VTRANSP_F)VTRANSP_F,SUM(IMP_SIND)IMP_SIND,SUM(IRRF)IRRF,SUM(OUT_DESC)OUT_DESC,SUM(ADIANT)ADIANT,"
	cQuery += "SUM(LIQ_FOL)LIQ_FOL"
	cQuery += "  FROM(SELECT DISTINCT SRA.RA_ITEM,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_CODFOL = '318'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_BS,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '07'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS INSS_F,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '08'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS VREFE_F,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '09'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS VTRANSP_F,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '10'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS IMP_SIND,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '11'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS IRRF,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '12'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS OUT_DESC,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '13'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS ADIANT,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '14'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS LIQ_FOL"
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "      WHERE SRA.D_E_L_E_T_ <> '*'"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE (SAL_BS+INSS_F+VREFE_F+VTRANSP_F+IMP_SIND+IRRF+OUT_DESC+ADIANT+LIQ_FOL)  > 0"
	cQuery += " GROUP BY RA_ITEM,RA_CC"
	cQuery += " ORDER BY RA_ITEM,RA_CC"
	
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","SAL_PG"   ,"N",15,2)
	TcSetField("SRANPP6","INSS_F"   ,"N",15,2)
	TcSetField("SRANPP6","VREFE_F"  ,"N",15,2)
	TcSetField("SRANPP6","VTRANSP_F","N",15,2)
	TcSetField("SRANPP6","IMP_SIND" ,"N",15,2)
	TcSetField("SRANPP6","IRRF"     ,"N",15,2)
	TcSetField("SRANPP6","OUT_DESC" ,"N",15,2)
	TcSetField("SRANPP6","ADIANT"   ,"N",15,2)
	TcSetField("SRANPP6","LIQ_FOL"  ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA" ,"N",4,0)
	
ElseIf nx == 3
	cQuery := "SELECT RA_ITEM,RA_CC,COUNT(1) FUNCIONA,SUM(SAL_BS)SAL_BS,"
	cQuery += "SUM(INSS_EMP)INSS_EMP,SUM(FGTS_EMP)FGTS_EMP,SUM(OUTR_ENC )OUTR_ENC,SUM(FGTS_RES)FGTS_RES,SUM(SENAI)SENAI"
	cQuery += "  FROM(SELECT DISTINCT SRA.RA_ITEM,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_CODFOL = '318'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_BS,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '15'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS INSS_EMP,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '16'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS FGTS_EMP,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '19'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS OUTR_ENC,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '20'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS FGTS_RES,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '21'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SENAI"
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "      WHERE SRA.D_E_L_E_T_ <> '*'"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE (SAL_BS+INSS_EMP+FGTS_EMP+FGTS_RES+OUTR_ENC+SENAI)  > 0"
	cQuery += " GROUP BY RA_ITEM,RA_CC"
	cQuery += " ORDER BY RA_ITEM,RA_CC"
	
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","SAL_PG"   ,"N",15,2)
	TcSetField("SRANPP6","INSS_EMP" ,"N",15,2)
	TcSetField("SRANPP6","FGTS_EMP" ,"N",15,2)
	TcSetField("SRANPP6","OUTR_ENC" ,"N",15,2)
	TcSetField("SRANPP6","FGTS_RES" ,"N",15,2)
	TcSetField("SRANPP6","SENAI"    ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA" ,"N",4,0)
	
ElseIf nx == 4
	
	cQuery := "SELECT RA_ITEM,RA_CC,COUNT(1) FUNCIONA,SUM(SAL_BS)SAL_BS,"
	cQuery += "SUM(VTRANSP_E)VTRANSP_E,SUM(VREFE_E)VREFE_E,SUM(SEG_VIDA )SEG_VIDA,SUM(CES_BAS)CES_BAS,SUM(ASS_MED )ASS_MED"
	cQuery += "  FROM(SELECT DISTINCT SRA.RA_ITEM,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_CODFOL = '318'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_BS,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '22'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SEG_VIDA,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '23'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS CES_BAS,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '17'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS VTRANSP_E,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '18'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS VREFE_E,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '24'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS ASS_MED""
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "      WHERE SRA.D_E_L_E_T_ <> '*'"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE (SAL_BS+ASS_MED+CES_BAS+VTRANSP_E+VREFE_E+SEG_VIDA)  > 0"
	cQuery += " GROUP BY RA_ITEM,RA_CC"
	cQuery += " ORDER BY RA_ITEM,RA_CC"
	
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","SAL_PG"   ,"N",15,2)
	TcSetField("SRANPP6","ASS_MED" ,"N",15,2)
	TcSetField("SRANPP6","CES_BAS" ,"N",15,2)
	TcSetField("SRANPP6","VTRANSP_E","N",15,2)
	TcSetField("SRANPP6","VREFE_E"  ,"N",15,2)
	TcSetField("SRANPP6","SEG_VIDA" ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA" ,"N",4,0)
	
ElseIf nx == 99 //Provisao Antes
	cPerProAt := Substr(dDtRela,1,6)                   
	If Substr(dDtRela,5,2) == "12"
		cPerProAn := Str(Val(Substr(dDtRela,1,4))-1,4)+"11"
	Else
		cPerProAn := Substr(dDtRela,1,4)+StrZero(Val(Substr(dDtRela,5,2))-1,2)
	EndIf

	cQuery := "SELECT RA_ITEM,RA_CC,COUNT(1) FUNCIONA,SUM((ATUAL_FERIAS+BAIXA_FERIAS)-ANTES_FERIAS) AS PR_FERIAS,"
	cQuery += "           SUM((ATUAL_FERIAS_ADIC+BAIXA_FERIAS_ADIC)-ANTES_FERIAS_ADIC) AS PR_FER_ADIC,"
	cQuery += "           SUM((ATUAL_FERIAS_1TER+BAIXA_FERIAS_1TER)-ANTES_FERIAS_1TER) AS PR_FER_1TER,"
	cQuery += "           SUM((ATUAL_FERIAS_INSS+BAIXA_FERIAS_INSS)-ANTES_FERIAS_INSS) AS P_FER_INSS,"
	cQuery += "           SUM((ATUAL_FERIAS_FGTS+BAIXA_FERIAS_FGTS)-ANTES_FERIAS_FGTS) AS P_FER_FGTS,"
	cQuery += "           SUM((ATUAL_13SAL     +BAIXA_13SAL     )-(ANTES_13SAL     +ATUAL_13SAL_ADI)) AS PR_13SAL,"
	cQuery += "           SUM((ATUAL_13SAL_ADIC+BAIXA_13SAL_ADIC)-(ANTES_13SAL_ADIC)) AS PR_13SAL_ADIC,"
	cQuery += "           SUM((ATUAL_13SAL_INSS+BAIXA_13SAL_INSS)-ANTES_13SAL_INSS) AS P_13S_INSS,"
	cQuery += "           SUM((ATUAL_13SAL_FGTS+BAIXA_13SAL_FGTS)-ANTES_13SAL_FGTS) AS P_13S_FGTS"
	cQuery += "  FROM(SELECT SRA.RA_ITEM,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('729')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_FERIAS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('801')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_FERIAS_ADIC,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('802')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_FERIAS_1TER,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('729')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_FERIAS,"
	
	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('801')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_FERIAS_ADIC,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('802')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_FERIAS_1TER,"
	
	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('790','807')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_FERIAS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('803','808')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_FERIAS_ADIC,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('804','809')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_FERIAS_1TER,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('730')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_FERIAS_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('730')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_FERIAS_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('810','791')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_FERIAS_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('731')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_FERIAS_FGTS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('731')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_FERIAS_FGTS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('792','811')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_FERIAS_FGTS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('735')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_13SAL,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('812')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_13SAL_ADIC,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('735')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_13SAL,"  
	
	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('812')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_13SAL_ADIC,"  

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('819','840')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_13SAL,"   
	
	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('820','841')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_13SAL_ADIC,"   

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('736')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_13SAL_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('736')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_13SAL_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('813')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_13SAL_ADI,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('821','843')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_13SAL_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('737')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_13SAL_FGTS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('737')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_13SAL_FGTS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('822','844')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_13SAL_FGTS"
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "        WHERE SRA.D_E_L_E_T_ = ' '"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE ((ATUAL_FERIAS+BAIXA_FERIAS)-ANTES_FERIAS)+((ATUAL_FERIAS_INSS+BAIXA_FERIAS_INSS)-ANTES_FERIAS_INSS)+
	cQuery += "((ATUAL_FERIAS_FGTS+BAIXA_FERIAS_FGTS)-ANTES_FERIAS_FGTS)+((ATUAL_13SAL+BAIXA_13SAL)-(ANTES_13SAL+ATUAL_13SAL_ADI))+
	cQuery += "((ATUAL_13SAL_INSS+BAIXA_13SAL_INSS)-ANTES_13SAL_INSS)+((ATUAL_13SAL_FGTS+BAIXA_13SAL_FGTS)-ANTES_13SAL_FGTS) <>0
	cQuery += " GROUP BY RA_ITEM,RA_CC"
	cQuery += " ORDER BY RA_ITEM,RA_CC"
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","PR_FERIAS"  ,"N",15,2)
	TcSetField("SRANPP6","PR_FER_ADIC"  ,"N",15,2)
	TcSetField("SRANPP6","PR_FER_1TER"  ,"N",15,2)		
	TcSetField("SRANPP6","P_FER_INSS" ,"N",15,2)
	TcSetField("SRANPP6","P_FER_FGTS" ,"N",15,2)
	TcSetField("SRANPP6","PR_13SAL"   ,"N",15,2)
	TcSetField("SRANPP6","PR_13SAL_ADIC"   ,"N",15,2)
	TcSetField("SRANPP6","P_13S_INSS" ,"N",15,2)
	TcSetField("SRANPP6","P_13S_FGTS" ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA"   ,"N",4,0)

Else //Provisao Agora
	cQuery := "SELECT RA_ITEM,RA_CC,COUNT(1) FUNCIONA,SUM(SAL_BS)SAL_BS"
	cQuery += "  FROM(SELECT DISTINCT SRA.RA_ITEM,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_CODFOL = '318'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_BS"
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "      WHERE SRA.D_E_L_E_T_ <> '*'"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE (SAL_BS)  > 0"
	cQuery += " GROUP BY RA_ITEM,RA_CC"
	cQuery += " ORDER BY RA_ITEM,RA_CC"
	
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","SAL_BS"   ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA"   ,"N",4,0)
	
EndIf

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fMt2Query ?Autor  ?PrimaInfo           ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ?Programa Princiapal                                         ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function fMt2Query(nx)

Local cQuery    := ""
Local cArqMvto  := ""
Local cArqVerba := RetSqlName( "SRV" )
Local cArqFunci := RetSqlName( "SRA" )
Local cArqProv  := RetSqlName( "SRT" )
Local cPerProAn := "" //Periodo provisao anterior
Local cPerProAt := "" //Periodo Provisao Atual

If Substr(Dtos(mv_par01),1,6) >= GetMv("MV_FOLMES")
	cArqMvto := RetSqlName( "SRC" )
Else
	cArqMvto := "RC"+cEmpAnt+Substr(Dtos(mv_par01),3,4)
EndIf

If nx == 1
	cQuery := "SELECT COUNT(1) FUNCIONA,SUM(SAL_BS)SAL_BS,SUM(SAL_PG)SAL_PG,SUM(HR_EXTRA)HR_EXTRA,SUM(SAL_13)SAL_13,SUM(FERIAS)FERIAS,SUM(GRATIF)GRATIF,SUM(OUT_PROV)OUT_PROV"
	cQuery += "  FROM(SELECT DISTINCT SRA.RA_FILIAL,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_CODFOL = '318'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_BS,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '01'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_PG,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '02'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS HR_EXTRA,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '03'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_13,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '04'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS FERIAS,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '05'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS GRATIF,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '06'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS OUT_PROV"
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "      WHERE SRA.D_E_L_E_T_ <> '*'"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE (SAL_BS+SAL_PG+HR_EXTRA+SAL_13+FERIAS+GRATIF+OUT_PROV)  > 0"
	
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","SAL_PG"   ,"N",15,2)
	TcSetField("SRANPP6","HR_EXTRA" ,"N",15,2)
	TcSetField("SRANPP6","SAL_13"   ,"N",15,2)
	TcSetField("SRANPP6","FERIAS"   ,"N",15,2)
	TcSetField("SRANPP6","GRATIF"   ,"N",15,2)
	TcSetField("SRANPP6","OUT_PROV" ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA" ,"N",4,0)
	
ElseIf nx == 2
	cQuery := "SELECT COUNT(1) FUNCIONA,SUM(SAL_BS)SAL_BS,"
	cQuery += "SUM(INSS_F)INSS_F,SUM(VREFE_F)VREFE_F,SUM(VTRANSP_F)VTRANSP_F,SUM(IMP_SIND)IMP_SIND,SUM(IRRF)IRRF,SUM(OUT_DESC)OUT_DESC,SUM(ADIANT)ADIANT,"
	cQuery += "SUM(LIQ_FOL)LIQ_FOL"
	cQuery += "  FROM(SELECT DISTINCT SRA.RA_FILIAL,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_CODFOL = '318'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_BS,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '07'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS INSS_F,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '08'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS VREFE_F,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '09'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS VTRANSP_F,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '10'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS IMP_SIND,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '11'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS IRRF,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '12'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS OUT_DESC,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '13'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS ADIANT,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '14'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS LIQ_FOL"
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "      WHERE SRA.D_E_L_E_T_ <> '*'"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE (SAL_BS+INSS_F+VREFE_F+VTRANSP_F+IMP_SIND+IRRF+OUT_DESC+ADIANT+LIQ_FOL)  > 0"
	
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","SAL_PG"   ,"N",15,2)
	TcSetField("SRANPP6","INSS_F"   ,"N",15,2)
	TcSetField("SRANPP6","VREFE_F"  ,"N",15,2)
	TcSetField("SRANPP6","VTRANSP_F","N",15,2)
	TcSetField("SRANPP6","IMP_SIND" ,"N",15,2)
	TcSetField("SRANPP6","IRRF"     ,"N",15,2)
	TcSetField("SRANPP6","OUT_DESC" ,"N",15,2)
	TcSetField("SRANPP6","ADIANT"   ,"N",15,2)
	TcSetField("SRANPP6","LIQ_FOL"  ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA" ,"N",4,0)
	
ElseIf nx == 3
	cQuery := "SELECT COUNT(1) FUNCIONA,SUM(SAL_BS)SAL_BS,"
	cQuery += "SUM(INSS_EMP)INSS_EMP,SUM(FGTS_EMP)FGTS_EMP,SUM(OUTR_ENC )OUTR_ENC,SUM(FGTS_RES)FGTS_RES,SUM(SENAI)SENAI"
	cQuery += "  FROM(SELECT DISTINCT SRA.RA_FILIAL,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_CODFOL = '318'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_BS,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '15'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS INSS_EMP,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '16'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS FGTS_EMP,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '19'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS OUTR_ENC,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '20'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS FGTS_RES,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '21'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SENAI"
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "      WHERE SRA.D_E_L_E_T_ <> '*'"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE (SAL_BS+INSS_EMP+FGTS_EMP+FGTS_RES+OUTR_ENC+SENAI)  > 0"
	
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","SAL_PG"   ,"N",15,2)
	TcSetField("SRANPP6","INSS_EMP" ,"N",15,2)
	TcSetField("SRANPP6","FGTS_EMP" ,"N",15,2)
	TcSetField("SRANPP6","OUTR_ENC" ,"N",15,2)
	TcSetField("SRANPP6","FGTS_RES" ,"N",15,2)
	TcSetField("SRANPP6","SENAI"    ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA" ,"N",4,0)
	
ElseIf nx == 4
	
	cQuery := "SELECT COUNT(1) FUNCIONA,SUM(SAL_BS)SAL_BS,"
	cQuery += "SUM(VTRANSP_E)VTRANSP_E,SUM(VREFE_E)VREFE_E,SUM(SEG_VIDA )SEG_VIDA,SUM(CES_BAS)CES_BAS,SUM(ASS_MED )ASS_MED"
	cQuery += "  FROM(SELECT DISTINCT SRA.RA_FILIAL,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_CODFOL = '318'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_BS,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '22'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SEG_VIDA,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '23'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS CES_BAS,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '17'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS VTRANSP_E,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '18'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS VREFE_E,"
	cQuery += "        (SELECT ISNULL(Sum(SRC.RC_VALOR),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_AGRFPES = '24'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS ASS_MED""
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "      WHERE SRA.D_E_L_E_T_ <> '*'"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE (SAL_BS+ASS_MED+CES_BAS+VTRANSP_E+VREFE_E+SEG_VIDA)  > 0"
	
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","SAL_PG"   ,"N",15,2)
	TcSetField("SRANPP6","ASS_MED" ,"N",15,2)
	TcSetField("SRANPP6","CES_BAS" ,"N",15,2)
	TcSetField("SRANPP6","VTRANSP_E","N",15,2)
	TcSetField("SRANPP6","VREFE_E"  ,"N",15,2)
	TcSetField("SRANPP6","SEG_VIDA" ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA" ,"N",4,0)
	
ElseIf nx == 99 //Provisao antes
	cPerProAt := Substr(dDtRela,1,6)                   
	If Substr(dDtRela,5,2) == "12"
		cPerProAn := Str(Val(Substr(dDtRela,1,4))-1,4)+"11"
	Else
		cPerProAn := Substr(dDtRela,1,4)+StrZero(Val(Substr(dDtRela,5,2))-1,2)
	EndIf

	cQuery := "SELECT COUNT(1) FUNCIONA,SUM((ATUAL_FERIAS+BAIXA_FERIAS)-ANTES_FERIAS) AS PR_FERIAS,"
	cQuery += "           SUM((ATUAL_FERIAS_ADIC+BAIXA_FERIAS_ADIC)-ANTES_FERIAS_ADIC) AS PR_FER_ADIC,"
	cQuery += "           SUM((ATUAL_FERIAS_1TER+BAIXA_FERIAS_1TER)-ANTES_FERIAS_1TER) AS PR_FER_1TER,"
	cQuery += "           SUM((ATUAL_FERIAS_INSS+BAIXA_FERIAS_INSS)-ANTES_FERIAS_INSS) AS P_FER_INSS,"
	cQuery += "           SUM((ATUAL_FERIAS_FGTS+BAIXA_FERIAS_FGTS)-ANTES_FERIAS_FGTS) AS P_FER_FGTS,"
	cQuery += "           SUM((ATUAL_13SAL     +BAIXA_13SAL     )-(ANTES_13SAL     +ATUAL_13SAL_ADI)) AS PR_13SAL,"
	cQuery += "           SUM((ATUAL_13SAL_ADIC+BAIXA_13SAL_ADIC)-(ANTES_13SAL_ADIC)) AS PR_13SAL_ADIC,"
	cQuery += "           SUM((ATUAL_13SAL_INSS+BAIXA_13SAL_INSS)-ANTES_13SAL_INSS) AS P_13S_INSS,"
	cQuery += "           SUM((ATUAL_13SAL_FGTS+BAIXA_13SAL_FGTS)-ANTES_13SAL_FGTS) AS P_13S_FGTS"
	cQuery += "  FROM(SELECT SRA.RA_FILIAL,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('729')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_FERIAS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('801')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_FERIAS_ADIC,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('802')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_FERIAS_1TER,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('729')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_FERIAS,"
	
	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('801')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_FERIAS_ADIC,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('802')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_FERIAS_1TER,"
	
	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('790','807')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_FERIAS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('803','808')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_FERIAS_ADIC,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('804','809')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_FERIAS_1TER,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('730')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_FERIAS_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('730')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_FERIAS_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('810','791')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_FERIAS_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('731')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_FERIAS_FGTS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('731')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_FERIAS_FGTS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('792','811')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_FERIAS_FGTS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('735')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_13SAL,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('812')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_13SAL_ADIC,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('735')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_13SAL,"  
	
	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('812')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_13SAL_ADIC,"  

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('819','840')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_13SAL,"   
	
	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL "
	cQuery += "                               AND RT_MAT = RA_MAT "
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                               AND RT_VERBA IN('820','841')"
	cQuery += "                               AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_13SAL_ADIC,"   

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('736')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_13SAL_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('736')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_13SAL_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('813')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_13SAL_ADI,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('821','843')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_13SAL_INSS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                              AND Substring(RT_DATACAL,1,6) = '" + cPerProAn +"'"
	cQuery += "                              AND RT_VERBA IN('737')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ANTES_13SAL_FGTS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR) "
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('737')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))ATUAL_13SAL_FGTS,"

	cQuery += "              CAST(ISNULL((SELECT SUM(RT_VALOR)"
	cQuery += "                             FROM  " + cArqProv
	cQuery += "                            WHERE RT_FILIAL = RA_FILIAL"
	cQuery += "                              AND RT_MAT = RA_MAT"
	cQuery += "                               AND Substring(RT_DATACAL,1,6) = '"+ cPerProAt +"' "
	cQuery += "                              AND RT_VERBA IN('822','844')"
	cQuery += "                              AND D_E_L_E_T_ = ' '),0)  AS NUMERIC(12,2))BAIXA_13SAL_FGTS"
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "        WHERE SRA.D_E_L_E_T_ = ' '"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE ((ATUAL_FERIAS+BAIXA_FERIAS)-ANTES_FERIAS)+((ATUAL_FERIAS_INSS+BAIXA_FERIAS_INSS)-ANTES_FERIAS_INSS)+
	cQuery += "((ATUAL_FERIAS_FGTS+BAIXA_FERIAS_FGTS)-ANTES_FERIAS_FGTS)+((ATUAL_13SAL+BAIXA_13SAL)-(ANTES_13SAL+ATUAL_13SAL_ADI))+
	cQuery += "((ATUAL_13SAL_INSS+BAIXA_13SAL_INSS)-ANTES_13SAL_INSS)+((ATUAL_13SAL_FGTS+BAIXA_13SAL_FGTS)-ANTES_13SAL_FGTS) <>0
	
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","PR_FERIAS"  ,"N",15,2)
	TcSetField("SRANPP6","PR_FER_ADIC"  ,"N",15,2)
	TcSetField("SRANPP6","PR_FER_1TER"  ,"N",15,2)		
	TcSetField("SRANPP6","P_FER_INSS" ,"N",15,2)
	TcSetField("SRANPP6","P_FER_FGTS" ,"N",15,2)
	TcSetField("SRANPP6","PR_13SAL"   ,"N",15,2)
	TcSetField("SRANPP6","PR_13SAL_ADIC"   ,"N",15,2)
	TcSetField("SRANPP6","P_13S_INSS" ,"N",15,2)
	TcSetField("SRANPP6","P_13S_FGTS" ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA"   ,"N",4,0)
Else
	cQuery := "SELECT COUNT(1) FUNCIONA,SUM(SAL_BS)SAL_BS"
	cQuery += "  FROM(SELECT DISTINCT SRA.RA_FILIAL,SRA.RA_MAT,RA_CC,CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SAL_NORM,"
	cQuery += "        (SELECT ISNULL(ISNULL(Sum(SRC.RC_VALOR),0),0)"
	cQuery += "   	       FROM " + cArqMvto + " SRC ," +cArqVerba + " SRV"
	cQuery += "          WHERE SRC.RC_PD = SRV.RV_COD"
	cQuery += "            AND SRA.RA_FILIAL = SRC.RC_FILIAL"
	cQuery += "            AND SRA.RA_MAT = SRC.RC_MAT"
	cQuery += "            AND SRV.RV_CODFOL = '318'"
	cQuery += "            AND SRC.D_E_L_E_T_ <>'*'"
	cQuery += "            AND SRV.D_E_L_E_T_ <>'*') AS SAL_BS"
	cQuery += "       FROM " + cArqFunci + " SRA"
	cQuery += "      WHERE SRA.D_E_L_E_T_ <> '*'"
	cQuery += "        AND CASE WHEN RA_CATFUNC IN('G','H') THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END BETWEEN " + cFxIni + " AND " + cFxFim
	cQuery += "        AND RA_SITFOLH IN(" + cSitQuery +") "
	cQuery += ") TMP"
	cQuery += " WHERE (SAL_BS)  > 0"
	
	TCQuery cQuery New Alias "SRANPP6"
	
	TcSetField("SRANPP6","SAL_BS"   ,"N",15,2)
	TcSetField("SRANPP6","FUNCIONA"   ,"N",4,0)
	
EndIf

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fGrCab01  ?Autor  ?PrimaInfo           ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Para uso do programa principal                             ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????? */
Static Function fGrCab01()

Local cLin := ""

cLin := "PROVENTOS" + cSep
cLin += cEol

fGravaTxt( cLin )

cLin := "FAIXA SALARIAL" + cSep
cLin += "FAIXA" + cSep
cLin += "FILIAL" + cSep
cLin += "DESCRICAO" + cSep
cLin += "CENTRO DE CUSTO" + cSep
cLin += "QTDE FUNCIONARIO" + cSep
cLin += "SALARIO NOMINAL" + cSep
cLin += "SALARIO PAGO" + cSep
cLin += "HORA EXTRA" + cSep
cLin += "13 SALARIO" + cSep
cLin += "FERIAS" + cSep
cLin += "GRATIFICACAO" + cSep
cLin += "OUTROS PROVENTOS" + cSep
cLin += cEol

fGravaTxt( cLin )

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fGrCab02  ?Autor  ?PrimaInfo           ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Para uso do programa principal                             ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????? */
Static Function fGrCab02()

Local cLin := ""

cLin := "DESCONTOS" + cSep
cLin += cEol

fGravaTxt( cLin )

cLin := "FAIXA SALARIAL" + cSep
cLin += "FAIXA" + cSep
cLin += "FILIAL" + cSep
cLin += "DESCRICAO" + cSep
cLin += "CENTRO DE CUSTO" + cSep
cLin += "QTDE FUNCIONARIO" + cSep
cLin += "SALARIO NOMINAL" + cSep
cLin += "INSS FUNCIONARIO" + cSep
cLin += "VALE REFEICAO" + cSep
cLin += "VALE TRANSPORTE" + cSep
cLin += "IMPOSTO SINDICAL" + cSep
cLin += "IRRPF" + cSep
cLin += "OUTROS DESCONTOS" + cSep
cLin += "ADIANTAMENTO" + cSep
cLin += "LIQUIDO DA FOLHA" + cSep
cLin += cEol

fGravaTxt( cLin )

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fGrCab03  ?Autor  ?PrimaInfo           ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Para uso do programa principal                             ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????? */
Static Function fGrCab03()

Local cLin := ""

cLin := "BASES" + cSep
cLin += cEol

fGravaTxt( cLin )

cLin := "FAIXA SALARIAL" + cSep
cLin += "FAIXA" + cSep
cLin += "FILIAL" + cSep
cLin += "DESCRICAO" + cSep
cLin += "CENTRO DE CUSTO" + cSep
cLin += "QTDE FUNCIONARIO" + cSep
cLin += "SALARIO NOMINAL" + cSep
cLin += "INSS EMPRESA" + cSep
cLin += "FGTS" + cSep
cLin += "FGTS RESCISAO" + cSep
cLin += "SENAI" + cSep
cLin += "OUTROS ENCARGOS" + cSep
cLin += cEol

fGravaTxt( cLin )

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fGrCab04  ?Autor  ?PrimaInfo           ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Para uso do programa principal                             ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????? */
Static Function fGrCab04()

Local cLin := ""

cLin := "CUSTOS" + cSep
cLin += cEol

fGravaTxt( cLin )

cLin := "FAIXA SALARIAL" + cSep
cLin += "FAIXA" + cSep
cLin += "FILIAL" + cSep
cLin += "DESCRICAO" + cSep
cLin += "CENTRO DE CUSTO" + cSep
cLin += "QTDE FUNCIONARIO" + cSep
cLin += "SALARIO NOMINAL" + cSep
cLin += "VALE TRANSPORTE EMPRESA" + cSep
cLin += "VALE REFEICAO EMPRESA" + cSep
cLin += "SEGURO VIDA EMPRESA" + cSep
cLin += "CESTA BASICA EMPRESA" + cSep
cLin += "ASSIST.MEDICA EMPRESA" + cSep

cLin += cEol

fGravaTxt( cLin )

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fGrCab05  ?Autor  ?PrimaInfo           ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Para uso do programa principal                             ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????? */
Static Function fGrCab05()

Local cLin := ""

cLin := "PROVISOES" + cSep
cLin += cEol

fGravaTxt( cLin )

cLin := "FAIXA SALARIAL" + cSep
cLin += "FAIXA" + cSep
cLin += "FILIAL" + cSep
cLin += "DESCRICAO" + cSep
cLin += "CENTRO DE CUSTO" + cSep
cLin += "QTDE FUNCIONARIO" + cSep
cLin += "PROVISAO DE FERIAS" + cSep
cLin += "ADICIONAL DE FERIAS" + cSep
cLin += "1/3 DE FERIAS" + cSep
cLin += "PROV INSS FERIAS" + cSep
cLin += "PROV FGTS FERIAS" + cSep
cLin += "PROVISAO 13SALARIO" + cSep
cLin += "ADICIONAL 13SALARIO" + cSep
cLin += "PROV INSS 13SAL" + cSep
cLin += "PROV FGTS 13SAL" + cSep

cLin += cEol

fGravaTxt( cLin )

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fGrCab05  ?Autor  ?PrimaInfo           ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Para uso do programa principal                             ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????? */
Static Function fGrCab06()

Local cLin := ""

cLin := "PROVISOES" + cSep
cLin += cEol

fGravaTxt( cLin )

cLin := "FAIXA SALARIAL" + cSep
cLin += "FAIXA" + cSep
cLin += "FILIAL" + cSep
cLin += "DESCRICAO" + cSep
cLin += "CENTRO DE CUSTO" + cSep
cLin += "QTDE FUNCIONARIO" + cSep
cLin += "SALARIO NOMINAL" + cSep
cLin += "PROVISAO DE FERIAS" + cSep
cLin += "1/3 DE FERIAS" + cSep
cLin += "PROV INSS FERIAS" + cSep
cLin += "PROV FGTS FERIAS" + cSep
cLin += "PROVISAO 13SALARIO" + cSep
cLin += "PROV INSS 13SAL" + cSep
cLin += "PROV FGTS 13SAL" + cSep

cLin += cEol

fGravaTxt( cLin )

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fGrCab21  ?Autor  ?PrimaInfo           ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Para uso do programa principal                             ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????? */
Static Function fGrCab21()

Local cLin := ""

cLin := "PROVENTOS" + cSep
cLin += cEol

fGravaTxt( cLin )

cLin := "FAIXA SALARIAL" + cSep
cLin += "FAIXA" + cSep
cLin += "QTDE FUNCIONARIO" + cSep
cLin += "SALARIO NOMINAL" + cSep
cLin += "SALARIO PAGO" + cSep
cLin += "HORA EXTRA" + cSep
cLin += "13 SALARIO" + cSep
cLin += "FERIAS" + cSep
cLin += "GRATIFICACAO" + cSep
cLin += "OUTROS PROVENTOS" + cSep
cLin += cEol

fGravaTxt( cLin )

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fGrCab22  ?Autor  ?PrimaInfo           ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Para uso do programa principal                             ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????? */
Static Function fGrCab22()

Local cLin := ""

cLin := "DESCONTOS" + cSep
cLin += cEol

fGravaTxt( cLin )

cLin := "FAIXA SALARIAL" + cSep
cLin += "FAIXA" + cSep
cLin += "QTDE FUNCIONARIO" + cSep
cLin += "SALARIO NOMINAL" + cSep
cLin += "INSS FUNCIONARIO" + cSep
cLin += "VALE REFEICAO" + cSep
cLin += "VALE TRANSPORTE" + cSep
cLin += "IMPOSTO SINDICAL" + cSep
cLin += "IRRPF" + cSep
cLin += "OUTROS DESCONTOS" + cSep
cLin += "ADIANTAMENTO" + cSep
cLin += "LIQUIDO DA FOLHA" + cSep
cLin += cEol

fGravaTxt( cLin )

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fGrCab23  ?Autor  ?PrimaInfo           ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Para uso do programa principal                             ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????? */
Static Function fGrCab23()

Local cLin := ""

cLin := "BASES" + cSep
cLin += cEol

fGravaTxt( cLin )

cLin := "FAIXA SALARIAL" + cSep
cLin += "FAIXA" + cSep
cLin += "QTDE FUNCIONARIO" + cSep
cLin += "SALARIO NOMINAL" + cSep
cLin += "INSS EMPRESA" + cSep
cLin += "FGTS" + cSep
cLin += "FGTS RESCISAO" + cSep
cLin += "SENAI" + cSep
cLin += "OUTROS ENCARGOS" + cSep
cLin += cEol

fGravaTxt( cLin )

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fGrCab24  ?Autor  ?PrimaInfo           ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Para uso do programa principal                             ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????? */
Static Function fGrCab24()

Local cLin := ""

cLin := "CUSTOS" + cSep
cLin += cEol

fGravaTxt( cLin )

cLin := "FAIXA SALARIAL" + cSep
cLin += "FAIXA" + cSep
cLin += "QTDE FUNCIONARIO" + cSep
cLin += "SALARIO NOMINAL" + cSep
cLin += "VALE TRANSPORTE EMPRESA" + cSep
cLin += "VALE REFEICAO EMPRESA" + cSep
cLin += "SEGURO VIDA EMPRESA" + cSep
cLin += "CESTA BASICA EMPRESA" + cSep
cLin += "ASSIST.MEDICA EMPRESA" + cSep

cLin += cEol

fGravaTxt( cLin )

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fGrCab25  ?Autor  ?PrimaInfo           ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Para uso do programa principal                             ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????? */
Static Function fGrCab25()

Local cLin := ""

cLin := "PROVISOES" + cSep
cLin += cEol

fGravaTxt( cLin )

cLin := "FAIXA SALARIAL" + cSep
cLin += "FAIXA" + cSep
cLin += "QTDE FUNCIONARIO" + cSep
cLin += "PROVISAO DE FERIAS" + cSep
cLin += "ADICIONAL DE FERIAS" + cSep
cLin += "1/3 DE FERIAS" + cSep
cLin += "PROV INSS FERIAS" + cSep
cLin += "PROV FGTS FERIAS" + cSep
cLin += "PROVISAO 13SALARIO" + cSep
cLin += "ADICIONAL 13SALARIO" + cSep
cLin += "PROV INSS 13SAL" + cSep
cLin += "PROV FGTS 13SAL" + cSep

cLin += cEol

fGravaTxt( cLin )

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fGrCab26  ?Autor  ?PrimaInfo           ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Para uso do programa principal                             ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????? */
Static Function fGrCab26()

Local cLin := ""

cLin := "PROVISOES" + cSep
cLin += cEol

fGravaTxt( cLin )

cLin := "FAIXA SALARIAL" + cSep
cLin += "FAIXA" + cSep
cLin += "QTDE FUNCIONARIO" + cSep
cLin += "SALARIO NOMINAL" + cSep
cLin += "PROVISAO DE FERIAS" + cSep
cLin += "1/3 DE FERIAS" + cSep
cLin += "PROV INSS FERIAS" + cSep
cLin += "PROV FGTS FERIAS" + cSep
cLin += "PROVISAO 13SALARIO" + cSep
cLin += "PROV INSS 13SAL" + cSep
cLin += "PROV FGTS 13SAL" + cSep

cLin += cEol

fGravaTxt( cLin )

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fGravaTxt ?Autor  ?PrimaInfo           ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Para uso do programa principal                             ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????? */
Static Function fGravaTxt( cLin )

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return
	Endif
Endif

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fLastReg  ?Autor  ?PrimaInfo           ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Uso do programa principal                                  ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????? */
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
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?fMntPlan  ? Autor ? Prima Info         ? Data ?  05/05/10   ???
????????????????????????????????????????????????????????????????????????????
???Descricao ?Monta planilha.                                             ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ?                                                            ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/
Static Function fMntPlan(nx)

If nTpPlan == 1
	If fInfo(@aInfo,SRANPP6->RA_FILIAL)
		cDescFil := aInfo[01]
	EndIf
	If nx == 1        
	
		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += SRANPP6->RA_FILIAL + cSep
		cLin += cDescFil + cSep
		cLin += SRANPP6->RA_CC + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep
		cLin += Transform(SRANPP6->SAL_BS   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->SAL_PG   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->HR_EXTRA ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->SAL_13   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->FERIAS   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->GRATIF   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->OUT_PROV ,"@E 999,999,999.99") + cSep
		cLin += cEol
		
	ElseIf nx == 2

		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += SRANPP6->RA_FILIAL + cSep
		cLin += cDescFil + cSep
		cLin += SRANPP6->RA_CC + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep
		cLin += Transform(SRANPP6->SAL_BS   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->INSS_F   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->VREFE_F  ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->VTRANSP_F,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->IMP_SIND ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->IRRF     ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->OUT_DESC ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->ADIANT   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->LIQ_FOL  ,"@E 999,999,999.99") + cSep
		cLin += cEol
		
	ElseIf nx == 3
		
		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += SRANPP6->RA_FILIAL + cSep
		cLin += cDescFil + cSep
		cLin += SRANPP6->RA_CC + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep
		cLin += Transform(SRANPP6->SAL_BS   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->INSS_EMP ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->FGTS_EMP ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->FGTS_RES ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->SENAI,"@E 999,999,999.99")     + cSep
		cLin += Transform(SRANPP6->OUTR_ENC ,"@E 999,999,999.99") + cSep
		cLin += cEol
		
	ElseIf nx == 4
		
		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += SRANPP6->RA_FILIAL + cSep
		cLin += cDescFil + cSep
		cLin += SRANPP6->RA_CC + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep
		cLin += Transform(SRANPP6->SAL_BS   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->VTRANSP_E,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->VREFE_E  ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->SEG_VIDA ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->CES_BAS ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->ASS_MED ,"@E 999,999,999.99") + cSep
		cLin += cEol
		
	ElseIf nx == 99
		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += SRANPP6->RA_FILIAL + cSep
		cLin += cDescFil + cSep
		cLin += SRANPP6->RA_CC + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep
		//	cLin += Transform(SRANPP6->SAL_BS   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->PR_FERIAS ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->PR_FER_ADIC ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->PR_FER_1TER ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->P_FER_INSS ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->P_FER_FGTS,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->PR_13SAL,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->PR_13SAL_ADIC,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->P_13S_INSS,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->P_13S_FGTS,"@E 999,999,999.99") + cSep
		cLin += cEol
	
	Else
		dbSelectArea("SRX")
		dbSetOrder(1)	 
		If SRX->(dbseek("  14"))
			nINSSEmp :=  Val(SubStr(SRX->RX_TXT,01,08)) /100
			nTerEmp  :=  Val(SubStr(SRX->RX_TXT,09,08)) /100
			nAcidEmp :=  Val(SubStr(SRX->RX_TXT,16,08)) /100
			nfgtsEmp :=  Val(SubStr(SRX->RX_TXT,23,07)) /100
        EndIf
        
        nPFer    := SRANPP6->SAL_BS/12
        nP13Fer  := nPFer /3
        nPFerINS := (nPFer+nP13Fer) *(nINSSEmp+nTerEmp+nAcidEmp)
        npFerFGT := (nPFer+nP13Fer) *(nfgtsEmp)
        nP13Sal  := SRANPP6->SAL_BS/12
        nP13SINS := nP13Sal *(nINSSEmp+nTerEmp+nAcidEmp)
        np13SFGT := nP13Sal *(nfgtsEmp)
        

		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += SRANPP6->RA_FILIAL + cSep
		cLin += cDescFil + cSep
		cLin += SRANPP6->RA_CC + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep         
		cLin += Transform(SRANPP6->SAL_BS ,"@E 999,999,999.99") + cSep
		cLin += Transform(nPFer ,"@E 999,999,999.99") + cSep
		cLin += Transform(nP13Fer ,"@E 999,999,999.99") + cSep
		cLin += Transform(nPFerINS ,"@E 999,999,999.99") + cSep
		cLin += Transform(npFerFGT ,"@E 999,999,999.99") + cSep		
		cLin += Transform(nP13Sal ,"@E 999,999,999.99") + cSep
		cLin += Transform(nP13SINS ,"@E 999,999,999.99") + cSep
		cLin += Transform(np13SFGT ,"@E 999,999,999.99") + cSep		
		cLin += cEol
	EndIf
	
ElseIf nTpPlan == 2

	If fInfo(@aInfo,SRANPP6->RA_ITEM)
		cDescFil := aInfo[01]
	EndIf

	If nx == 1
		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += SRANPP6->RA_ITEM + cSep
		cLin += cDescFil + cSep
		cLin += SRANPP6->RA_CC + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep
		cLin += Transform(SRANPP6->SAL_BS   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->SAL_PG   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->HR_EXTRA ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->SAL_13   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->FERIAS   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->GRATIF   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->OUT_PROV ,"@E 999,999,999.99") + cSep
		cLin += cEol
		
	ElseIf nx == 2
		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += SRANPP6->RA_ITEM + cSep
		cLin += cDescFil + cSep
		cLin += SRANPP6->RA_CC + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep
		cLin += Transform(SRANPP6->SAL_BS   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->INSS_F   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->VREFE_F  ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->VTRANSP_F,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->IMP_SIND ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->IRRF     ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->OUT_DESC ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->ADIANT   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->LIQ_FOL  ,"@E 999,999,999.99") + cSep
		cLin += cEol
		
	ElseIf nx == 3
		
		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += SRANPP6->RA_ITEM + cSep
		cLin += cDescFil + cSep
		cLin += SRANPP6->RA_CC + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep
		cLin += Transform(SRANPP6->SAL_BS   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->INSS_EMP ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->FGTS_EMP ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->FGTS_RES ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->SENAI,"@E 999,999,999.99")     + cSep
		cLin += Transform(SRANPP6->OUTR_ENC ,"@E 999,999,999.99") + cSep
		cLin += cEol
		
	ElseIf nx == 4
		
		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += SRANPP6->RA_ITEM + cSep
		cLin += cDescFil + cSep
		cLin += SRANPP6->RA_CC + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep
		cLin += Transform(SRANPP6->SAL_BS   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->VTRANSP_E,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->VREFE_E  ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->SEG_VIDA ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->CES_BAS ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->ASS_MED ,"@E 999,999,999.99") + cSep
		cLin += cEol
		
	ElseIf nx == 99
		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += SRANPP6->RA_ITEM + cSep
		cLin += cDescFil + cSep
		cLin += SRANPP6->RA_CC + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep
		//	cLin += Transform(SRANPP6->SAL_BS   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->PR_FERIAS ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->PR_FER_ADIC ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->PR_FER_1TER ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->P_FER_INSS ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->P_FER_FGTS,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->PR_13SAL,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->PR_13SAL_ADIC,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->P_13S_INSS,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->P_13S_FGTS,"@E 999,999,999.99") + cSep
		cLin += cEol
	Else
		dbSelectArea("SRX")
		dbSetOrder(1)	 
		If SRX->(dbseek("  14"))
			nINSSEmp :=  Val(SubStr(SRX->RX_TXT,01,08)) /100
			nTerEmp  :=  Val(SubStr(SRX->RX_TXT,09,08)) /100
			nAcidEmp :=  Val(SubStr(SRX->RX_TXT,18,08)) /100
			nfgtsEmp :=  Val(SubStr(SRX->RX_TXT,26,07)) /100
        EndIf

        nPFer    := SRANPP6->SAL_BS/12
        nP13Fer  := nPFer /3
        nPFerINS := (nPFer+nP13Fer) *(nINSSEmp+nTerEmp+nAcidEmp)
        npFerFGT := (nPFer+nP13Fer) *(nfgtsEmp)
        nP13Sal  := SRANPP6->SAL_BS/12
        nP13SINS := nP13Sal *(nINSSEmp+nTerEmp+nAcidEmp)
        np13SFGT := nP13Sal *(nfgtsEmp)
        
		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += SRANPP6->RA_ITEM + cSep
		cLin += cDescFil + cSep
		cLin += SRANPP6->RA_CC + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep
		cLin += Transform(SRANPP6->SAL_BS ,"@E 999,999,999.99") + cSep
		cLin += Transform(nPFer ,"@E 999,999,999.99") + cSep
		cLin += Transform(nP13Fer ,"@E 999,999,999.99") + cSep
		cLin += Transform(nPFerINS ,"@E 999,999,999.99") + cSep
		cLin += Transform(npFerFGT ,"@E 999,999,999.99") + cSep		
		cLin += Transform(nP13Sal ,"@E 999,999,999.99") + cSep
		cLin += Transform(nP13SINS ,"@E 999,999,999.99") + cSep
		cLin += Transform(np13SFGT ,"@E 999,999,999.99") + cSep		
		cLin += cEol
		
	EndIf
Else
	If nx == 1
		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep
		cLin += Transform(SRANPP6->SAL_BS   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->SAL_PG   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->HR_EXTRA ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->SAL_13   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->FERIAS   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->GRATIF   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->OUT_PROV ,"@E 999,999,999.99") + cSep
		cLin += cEol
		
	ElseIf nx == 2
		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep
		cLin += Transform(SRANPP6->SAL_BS   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->INSS_F   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->VREFE_F  ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->VTRANSP_F,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->IMP_SIND ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->IRRF     ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->OUT_DESC ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->ADIANT   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->LIQ_FOL  ,"@E 999,999,999.99") + cSep
		cLin += cEol
		
	ElseIf nx == 3
		
		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep
		cLin += Transform(SRANPP6->SAL_BS   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->INSS_EMP ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->FGTS_EMP ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->FGTS_RES ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->SENAI,"@E 999,999,999.99")     + cSep
		cLin += Transform(SRANPP6->OUTR_ENC ,"@E 999,999,999.99") + cSep
		cLin += cEol
		
	ElseIf nx == 4
		
		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep
		cLin += Transform(SRANPP6->SAL_BS   ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->VTRANSP_E,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->VREFE_E  ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->SEG_VIDA ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->CES_BAS ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->ASS_MED ,"@E 999,999,999.99") + cSep
		cLin += cEol
		
	ElseIf nx == 99
		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep
		cLin += Transform(SRANPP6->PR_FERIAS ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->PR_FER_ADIC ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->PR_FER_1TER ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->P_FER_INSS ,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->P_FER_FGTS,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->PR_13SAL,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->PR_13SAL_ADIC,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->P_13S_INSS,"@E 999,999,999.99") + cSep
		cLin += Transform(SRANPP6->P_13S_FGTS,"@E 999,999,999.99") + cSep
		cLin += cEol
	Else
		dbSelectArea("SRX")
		dbSetOrder(1)	 
		If SRX->(dbseek("  14"))
			nINSSEmp :=  Val(SubStr(SRX->RX_TXT,01,08)) /100
			nTerEmp  :=  Val(SubStr(SRX->RX_TXT,09,08)) /100
			nAcidEmp :=  Val(SubStr(SRX->RX_TXT,18,08)) /100
			nfgtsEmp :=  Val(SubStr(SRX->RX_TXT,26,07)) /100
        EndIf

        nPFer    := SRANPP6->SAL_BS/12
        nP13Fer  := nPFer /3
        nPFerINS := (nPFer+nP13Fer) *(nINSSEmp+nTerEmp+nAcidEmp)
        npFerFGT := (nPFer+nP13Fer) *(nfgtsEmp)
        nP13Sal  := SRANPP6->SAL_BS/12
        nP13SINS := nP13Sal *(nINSSEmp+nTerEmp+nAcidEmp)
        np13SFGT := nP13Sal *(nfgtsEmp)
        
		cLin := "FAIXA " + cSeqFX + cSep
		cLin += cFxIni + " - " + cFxFim + cSep
		cLin += StrZero(SRANPP6->FUNCIONA,4) + cSep         
		cLin += Transform(SRANPP6->SAL_BS ,"@E 999,999,999.99") + cSep
		cLin += Transform(nPFer ,"@E 999,999,999.99") + cSep
		cLin += Transform(nP13Fer ,"@E 999,999,999.99") + cSep
		cLin += Transform(nPFerINS ,"@E 999,999,999.99") + cSep
		cLin += Transform(npFerFGT ,"@E 999,999,999.99") + cSep		
		cLin += Transform(nP13Sal ,"@E 999,999,999.99") + cSep
		cLin += Transform(nP13SINS ,"@E 999,999,999.99") + cSep
		cLin += Transform(np13SFGT ,"@E 999,999,999.99") + cSep		
		cLin += cEol
	
	EndIf

EndIf

fGravaTxt( cLin )

Return

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?CriaSX1   ? Autor ? PrimaInfo          ? Data ?  24/04/10   ???
????????????????????????????????????????????????????????????????????????????
???Descricao ?Objetivo desta funcao e verificar se existe o grupo de      ???
???          ?perguntas, se nao existir a funcao ira cria-lo.             ???
????????????????????????????????????????????????????????????????????????????
???Uso       ?cPerg -> Nome com  grupo de perguntas em quest?o.           ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

Static Function CriaSx1(cPerg)

Local aHelp := {}

PutSx1(cPerg,"01","Data Base ?"          ,"","","mv_ch1","D",08,00,00,"G","naovazio"  ,""   ,"","","mv_par01",""        ,"","","",""          ,"","",""         ,"","","","","","","","","","","","")
PutSx1(cPerg,"02","Categoria ?"          ,"","","mv_ch2","C",15,00,00,"G","fCategoria",""   ,"","","mv_par02",""        ,"","","",""          ,"","",""         ,"","","","","","","","","","","","")
PutSx1(cPerg,"03","Situacao ?"           ,"","","mv_ch3","C",05,00,00,"G","fsituacao" ,""   ,"","","mv_par03",""        ,"","","",""          ,"","",""         ,"","","","","","","","","","","","")
PutSx1(cPerg,"04","Trata ?"              ,"","","mv_ch4","N",01,00,00,"C",""          ,""   ,"","","mv_par04","1-Filial","","","","2-UnidTrab","","","3-Empresa","","","","","","","","","","","","")

Return Nil

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?GPamnpp6  ?Autor  ?PrimaInfo           ? Data ?  16/08/10   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? AP                                                        ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function fAMNPP6Vld()

Local lRet := .F.

lRet := ( Alltrim(M->RV_AGRFPES) $ "01#02#03#04#05#06#07#08#09#10#11#12#13#14#15#16#17#18#19#20#21#22#23#24" )

Return lRet
