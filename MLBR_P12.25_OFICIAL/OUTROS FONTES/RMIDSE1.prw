#INCLUDE "rwmake.ch"
/*
----------------------------------------------------------------
PROGRAMA: RMIDSE1
----------------------------------------------------------------
Objetivo: Verifica se haverá registros duplicados no SE1 se essa
          tabela passar a ser compartilhada 
----------------------------------------------------------------          
*/
User Function RMIDSE1()

Private oGeraTxt
Private cString := "SE1"

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Análise do SE1-Contas a Receber")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa tem como objetivo avaliar a tabela do Modulo Financeiro"
@ 18,018 Say " para identificar possiveis registros duplicados."
@ 26,018 Say " Gera arquivo SE1UNIC.LOG                                          "

@ 70,128 BMPBUTTON TYPE 01 ACTION ProcSE1()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)

Activate Dialog oGeraTxt Centered

Return
/*
------------------------------------------------------------------------
PROGRAMA: ProcSE1
------------------------------------------------------------------------*/

Static Function ProcSE1

Private cArqTxt := "\systemtst\SE1UNIC.LOG"
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

Processa({|| ProcTabSE1() },"Processando...")

Return

/*
----------------------------------------------------------------------
Funcao: ProcTabSE1
----------------------------------------------------------------------
*/
Static Function ProcTabSE1()

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
cQuery := " SELECT E1_FILIAL,E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO,E1_CLIENTE,E1_LOJA, E1_FILORIG, R_E_C_N_O_ "
cQuery += " FROM "  
cQuery += RetSqlName("SE1")+" SE1 "
cQuery += " WHERE SE1.D_E_L_E_T_ = ' '"  
cQuery += " ORDER BY SE1.E1_FILIAL,SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO,SE1.E1_CLIENTE,SE1.E1_LOJA"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)

dbSelectArea("TMP") 
dbGoTop()

dbSelectArea("SE1")
dbSetOrder(1)

While TMP->(!Eof()) 
    cLin    := Space(nTamLin)+cEOL 
	nRecno  := TMP->R_E_C_N_O_	//Recno()
	cPrfxNew:= TMP->E1_FILIAL + SPACE(1)	//PARA MONTAR A CHAVE CORRETAMENTE
		     
	nLidos += 1

	cRegistro := TMP->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
    IncProc("Registro lido: "+Alltrim(Transform(nLidos, "@e 999999")))		//StrZero(nLidos))       
			                  
	If Empty(TMP->E1_FILIAL)
	    TMP->(dbSkip())
    	Loop
	EndIf		
		
	cChave := TMP->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)  			//chave unica no banco
	cNewKey:= Space(2) + cPrfxNew + TMP->(E1_NUM+E1_PARCELA+E1_TIPO)             //Filial compartilhada

	//dbGoTop()		
	lAchou := SE1->(MsSeek(cNewKey))

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
		cLin += TMP->E1_FILIAL+Space(5)
		cLin += TMP->E1_PREFIXO+Space(4)
		cLin += TMP->E1_NUM+Space(2)
		cLin += TMP->E1_PARCELA+Space(4)
		cLin += TMP->E1_TIPO+Space(3)
		cLin += TMP->E1_CLIENTE+Space(2)
		cLin += TMP->E1_LOJA+Space(4)
		cLin += "Reg. Lido"+cEOL  
		
	    fWrite(nHdl,cLin)

		//Registro Pesquisado - duplicado quando alterar prefixo=filial
		cLin := StrZero(nRecno,6)+Space(6)
		cLin += SE1->E1_FILIAL+Space(5)
		cLin += cPrfxNew+Space(5)
		cLin += SE1->E1_NUM+Space(2)
		cLin += SE1->E1_PARCELA+Space(4)
		cLin += SE1->E1_TIPO+Space(3)
		cLin += SE1->E1_CLIENTE+Space(2)
		cLin += SE1->E1_LOJA+Space(4)
		cLin += "Pesquisado"+cEOL  
		
	    fWrite(nHdl,cLin)
	    fWrite(nHdl,cHead01)

		nRegLog += 1
	Else
		dbGoTo(nRecno)
    	/*--- Regrava o registro com NOVA FILIAL/PREFIXO/FILORIG ---*/
    	RecLock('SE1',.F.)                                                                
		 If TMP->E1_PREFIXO != 'EIC'
    		SE1->E1_PREFIXO := cPrfxNew
    	 EndIf
	   	 SE1->E1_FILORIG := If(Empty(Substr(cPrfxNew,1,2)),TMP->E1_FILORIG,Substr(cPrfxNew,1,2))
    	 SE1->E1_FILIAL  := ""
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
