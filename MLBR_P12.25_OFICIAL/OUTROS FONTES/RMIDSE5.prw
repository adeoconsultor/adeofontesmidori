#INCLUDE "rwmake.ch"
/*
----------------------------------------------------------------
PROGRAMA: RMIDSE5
----------------------------------------------------------------
Objetivo: Verifica se haverá registros duplicados no SE5 se essa
          tabela passar a ser compartilhada 
----------------------------------------------------------------          
*/
User Function RMIDSE5()

Private oGeraTxt
Private cString := "SE5"

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Análise do SE5-Movimento Bancario")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa tem como objetivo avaliar a tabela do Modulo Financeiro"
@ 18,018 Say " para identificar possiveis registros duplicados."
@ 26,018 Say " Gera arquivo SE5UNIC.LOG                                          "

@ 70,128 BMPBUTTON TYPE 01 ACTION ProcSE5()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)

Activate Dialog oGeraTxt Centered

Return
/*
------------------------------------------------------------------------
PROGRAMA: ProcSE5
------------------------------------------------------------------------*/

Static Function ProcSE5

Private cArqTxt := "\systemtst\SE5UNIC.LOG"
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

Processa({|| ProcTabSE5() },"Processando...")

Return

/*
----------------------------------------------------------------------
Funcao: ProcTabSE5
----------------------------------------------------------------------
*/
Static Function ProcTabSE5()

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
(1)-E5_FILIAL+DTOS(E5_DATA)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ
-------------------------------------------*/
cQuery := " SELECT E5_FILIAL,E5_PREFIXO, E5_NUMERO,E5_PARCELA,E5_TIPO,E5_CLIFOR,E5_LOJA,E5_FILORIG,E5_DATA,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_NUMCHEQ,R_E_C_N_O_"
cQuery += " FROM "  
cQuery += RetSqlName("SE5")
cQuery += " WHERE D_E_L_E_T_ = ' '"  
//cQuery += " AND E5_FILIAL = ''"
cQuery += " ORDER BY E5_FILIAL,E5_PREFIXO, E5_NUMERO,E5_PARCELA,E5_TIPO,E5_CLIFOR,E5_LOJA,E5_FILORIG,R_E_C_N_O_"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)

dbSelectArea("TMP") 
dbGoTop()

dbSelectArea("SE5")
dbSetOrder(1)

While TMP->(!Eof()) 
    cLin    := Space(nTamLin)+cEOL 
	nRecno  := TMP->R_E_C_N_O_	//Recno()
	cPrfxNew:= TMP->E5_FILIAL + SPACE(1)	//PARA MONTAR A CHAVE CORRETAMENTE
		     
	nLidos += 1

	cRegistro := TMP->(E5_FILIAL+E5_DATA+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
    IncProc("Registro lido: "+Alltrim(Transform(nLidos, "@e 999999")))		//StrZero(nLidos))       
			                  
	If Empty(TMP->E5_FILIAL)
	    TMP->(dbSkip())
    	Loop
	EndIf		
		
	cChave := TMP->(E5_FILIAL+E5_DATA+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)  			//chave unica no banco
	cNewKey:= Space(2) + cPrfxNew + TMP->(E5_DATA+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)             //Filial compartilhada

	//dbGoTop()		
	lAchou := SE5->(MsSeek(cNewKey))

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
		cLin += TMP->E5_FILIAL+Space(5)
		cLin += TMP->E5_DATA+Space(4)
		cLin += TMP->E5_BANCO+Space(2)
		cLin += TMP->E5_AGENCIA+Space(4)
		cLin += TMP->E5_CONTA+Space(3)
		cLin += TMP->E5_NUMCHEQ+Space(2)
		cLin += "Reg. Lido"+cEOL  
		
	    fWrite(nHdl,cLin)

		//Registro Pesquisado - duplicado quando alterar prefixo=filial
		cLin := StrZero(nRecno,6)+Space(6)
		cLin += SE5->E5_FILIAL+Space(5)
		cLin += SE5->E5_DATA+Space(2)
		cLin += SE5->E5_BANCO+Space(4)
		cLin += SE5->E5__AGENCIA+Space(3)
		cLin += SE5->E5_CONTA+Space(2)
		cLin += SE5->E5_NUMCHEQ+Space(4)
		cLin += "Pesquisado"+cEOL  
		
	    fWrite(nHdl,cLin)
	    fWrite(nHdl,cHead01)

		nRegLog += 1
	Else
		dbGoTo(nRecno)
    	/*--- Regrava o registro com NOVA FILIAL/PREFIXO/FILORIG ---*/
    	RecLock('SE5',.F.)                                                                
		 If TMP->E5_PREFIXO != 'EIC' //.AND. TMP->E5_PREFIXO != '  '
    		SE5->E5_PREFIXO := cPrfxNew
    	 EndIf
	   	 SE5->E5_FILORIG := If(Empty(Substr(cPrfxNew,1,2)),TMP->E5_FILORIG,Substr(cPrfxNew,1,2))
    	 SE5->E5_FILIAL  := ""
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
