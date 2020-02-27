#INCLUDE "rwmake.ch"
/*
----------------------------------------------------------------
PROGRAMA: RMIDSE2
----------------------------------------------------------------
Objetivo: Verifica se haverá registros duplicados no SE2 se essa
          tabela passar a ser compartilhada 
----------------------------------------------------------------          
*/
User Function RMIDSE2()

Private oGeraTxt
Private cString := "SE2"

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Análise do SE2-Contas a Pagar")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa tem como objetivo avaliar a tabela de Contas a Pagar"
@ 18,018 Say " para identificar possiveis registros duplicados."
@ 26,018 Say " Gera arquivo SE2UNIC.LOG                                          "

@ 70,128 BMPBUTTON TYPE 01 ACTION ProcSE2()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)

Activate Dialog oGeraTxt Centered

Return
/*
------------------------------------------------------------------------
PROGRAMA: ProcSE2
------------------------------------------------------------------------*/

Static Function ProcSE2

Private cArqTxt := "\systemtst\SE2UNIC.LOG"
Private nHdl    := fCreate(cArqTxt)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif

Processa({|| ProcTabSE2() },"Processando...")

Return

/*
----------------------------------------------------------------------
Funcao: ProcTabSE2
----------------------------------------------------------------------
*/
Static Function ProcTabSE2()

Local nTamLin, cLin, cCpo 
Local cHeader, cHead01, cTrailler

nRegs := RecCount()
ProcRegua(nRegs) // Numero de registros a processar

/*	----------------------------------------               
 	Lay-Out do arquivo Texto gerado:        */

cHead01:= "-----------------------------------------------------------------------------"+cEOL
cHeader:= "Registro  FILIAL PREFIXO NUM       PARC TIPO  FORNECE LOJA	Observ  "+cEOL
/*   	   999999x-x-x-99-x-x-99-x-x999999999x-9-x-xXXX-x-999999-x99-x-xXXXXXXXXXXXXXXXX
	       -----------------------------------------------------------------------------
*/
nTamLin := 100
cFiller := Space(2)
cPrfxNew:= ""
nLin    := 1
nRegLog := 0
nGravados := 0
nLidos   := 0
/*	
-------------------------------------------
Pesquisa Titulo a Pagar
-------------------------------------------*/
cQuery := " SELECT E2_FILIAL,E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO,E2_FORNECE,E2_LOJA, E2_FILORIG, R_E_C_N_O_ "
cQuery += " FROM "  
cQuery += RetSqlName("SE2")+" SE2 "
cQuery += " WHERE SE2.D_E_L_E_T_ = ' '"  
cQuery += " ORDER BY SE2.E2_FILIAL,SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO,SE2.E2_FORNECE,SE2.E2_LOJA"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)

dbSelectArea("TMP") 
dbGoTop()

dbSelectArea("SE2")
dbSetOrder(1)

While TMP->(!Eof()) 
    cLin    := Space(nTamLin)+cEOL 
	nRecno  := TMP->R_E_C_N_O_	//Recno()
	cPrfxNew:= TMP->E2_FILIAL + SPACE(1)	//PARA MONTAR A CHAVE CORRETAMENTE
		     
	nLidos += 1
    
	cRegistro := TMP->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
    IncProc("Registro lido: "+Alltrim(Transform(nLidos, "@e 999999")))		//StrZero(nLidos))       
			                  
	If Empty(TMP->E2_FILIAL)
	    TMP->(dbSkip())
    	Loop
	EndIf		
		
	cChave := TMP->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)  			//chave unica no banco
	cNewKey:= Space(2) + cPrfxNew + TMP->(E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)             //Filial compartilhada

	//dbGoTop()		
	lAchou := SE2->(MsSeek(cNewKey))

	If lAchou
		If nLin == 1 
			nLin += 1
		    fWrite(nHdl,cHead01)
		    fWrite(nHdl,cHeader)
		    fWrite(nHdl,cHead01)
		EndIf
		//Registro Lido - duplicado quando alterar prefixo=filial
	   //	dbGoTo(nRecno)

		cLin := StrZero(nRecno,6)+Space(6)
		cLin += TMP->E2_FILIAL+Space(5)
		cLin += TMP->E2_PREFIXO+Space(4)
		cLin += TMP->E2_NUM+Space(2)
		cLin += TMP->E2_PARCELA+Space(4)
		cLin += TMP->E2_TIPO+Space(3)
		cLin += TMP->E2_FORNECE+Space(2)
		cLin += TMP->E2_LOJA+Space(4)
		cLin += "Reg. Lido"+cEOL  
		
	    fWrite(nHdl,cLin)

		//Registro Pesquisado - duplicado quando alterar prefixo=filial
		cLin := StrZero(nRecno,6)+Space(6)
		cLin += SE2->E2_FILIAL+Space(5)
		cLin += cPrfxNew+Space(5)
		cLin += SE2->E2_NUM+Space(2)
		cLin += SE2->E2_PARCELA+Space(4)
		cLin += SE2->E2_TIPO+Space(3)
		cLin += SE2->E2_FORNECE+Space(2)
		cLin += SE2->E2_LOJA+Space(4)
		cLin += "Pesquisado"+cEOL  
		
	    fWrite(nHdl,cLin)
	    fWrite(nHdl,cHead01)

		nRegLog += 1
	Else
		dbGoTo(nRecno)
    	/*--- Regrava o registro com NOVA FILIAL/PREFIXO/FILORIG ---*/
    	RecLock('SE2',.F.)                                                                
		 If TMP->E2_PREFIXO != 'EIC'
    		SE2->E2_PREFIXO := cPrfxNew
    	 EndIf
	   	 SE2->E2_FILORIG := If(Empty(Substr(cPrfxNew,1,2)),TMP->E2_FILORIG,Substr(cPrfxNew,1,2))
    	 SE2->E2_FILIAL  := ""
		MsUnlock()    
		
		nGravados += 1
    Endif
	//Proximo Registro
    TMP->(dbSkip())
EndDo
cTrailler := "Data Proc.: "+DtoC(dDataBase)+Space(10)+"Reg. Processados: "+StrZero(nRegs,6)+Space(10)+"Reg. Duplicados: "+StrZero(nRegLog,6)+cEOL  
fWrite(nHdl,cTrailler)  

cTrailler := "Registros Alterados: "+StrZero(nGravados,6)+cEOL  
fWrite(nHdl,cTrailler)  

fClose(nHdl)
Close(oGeraTxt)

TMP->(dbCloseArea())

Return
