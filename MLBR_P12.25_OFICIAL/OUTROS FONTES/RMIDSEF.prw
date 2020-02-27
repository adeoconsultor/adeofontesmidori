#INCLUDE "rwmake.ch"
/*
----------------------------------------------------------------
PROGRAMA: RMIDSEF
----------------------------------------------------------------
Objetivo: Verifica se haverá registros duplicados no SEF se essa
          tabela passar a ser compartilhada 
----------------------------------------------------------------          
*/
User Function RMIDSEF()

Private oGeraTxt
Private cString := "SEF"

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Análise do SEF-Cheques")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa tem como objetivo avaliar a tabela de Contas a Pagar"
@ 18,018 Say " para identificar possiveis registros duplicados."
@ 26,018 Say " Gera arquivo SEFUNIC.LOG                                          "

@ 70,128 BMPBUTTON TYPE 01 ACTION ProcSEF()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)

Activate Dialog oGeraTxt Centered

Return
/*
------------------------------------------------------------------------
PROGRAMA: ProcSEF
------------------------------------------------------------------------*/

Static Function ProcSEF

Private cArqTxt := "\systemtst\SEFUNIC.LOG"
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

Processa({|| ProcTabSEF() },"Processando...")

Return

/*
----------------------------------------------------------------------
Funcao: ProcTabSEF
----------------------------------------------------------------------
*/
Static Function ProcTabSEF()

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
cQuery := " SELECT EF_FILIAL,EF_BANCO,EF_AGENCIA,EF_CONTA,EF_NUM,EF_FILORIG,EF_PREFIXO,EF_TITULO,EF_PARCELA,EF_TIPO, R_E_C_N_O_ "
cQuery += " FROM "  
cQuery += RetSqlName("SEF")
cQuery += " WHERE D_E_L_E_T_ = ' '"  
cQuery += " ORDER BY EF_FILIAL,EF_BANCO,EF_AGENCIA,EF_CONTA,EF_NUM,EF_FILORIG,EF_PREFIXO,EF_TITULO,EF_PARCELA,EF_TIPO"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)

dbSelectArea("TMP") 
dbGoTop()

dbSelectArea("SEF")
dbSetOrder(1)

While TMP->(!Eof()) 
    cLin    := Space(nTamLin)+cEOL 
	nRecno  := TMP->R_E_C_N_O_	//Recno()
	cPrfxNew:= TMP->EF_FILIAL + SPACE(1)	//PARA MONTAR A CHAVE CORRETAMENTE
		     
	nLidos += 1
    
	cRegistro := TMP->(EF_FILIAL+EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)
    IncProc("Registro lido: "+Alltrim(Transform(nLidos, "@e 999999")))		//StrZero(nLidos))       
			                  
	If Empty(TMP->EF_FILIAL)
	    TMP->(dbSkip())
    	Loop
	EndIf		
		
	cChave := TMP->(EF_FILIAL+EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)  			//chave unica no banco
	cNewKey:= Space(2) + cPrfxNew + TMP->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)             //Filial compartilhada

	//dbGoTop()		
	lAchou := SEF->(MsSeek(cNewKey))

	If lAchou
		If nLin == 1 
			nLin += 1
		    fWrite(nHdl,cHead01)
		EndIf
		//Registro Lido - duplicado quando alterar prefixo=filial
		cLin := StrZero(nRecno,6)+Space(6)
		cLin += TMP->EF_FILIAL+Space(5)
		cLin += TMP->EF_BANCO+Space(4)
		cLin += TMP->EF_AGENCIA+Space(2)
		cLin += TMP->EF_CONTA+Space(4)
		cLin += TMP->EF_NUM+Space(3)
		cLin += "Reg. Lido"+cEOL  
		
	    fWrite(nHdl,cLin)

		//Registro Pesquisado - duplicado quando alterar prefixo=filial
		cLin := StrZero(nRecno,6)+Space(6)
		cLin += SEF->EF_FILIAL+Space(5)
		cLin += SEF->EF_BANCO+Space(2)
		cLin += SEF->EF_AGENCIA+Space(4)
		cLin += SEF->EF_CONTA+Space(3)
		cLin += SEF->EF_NUM+Space(2)
		cLin += "Pesquisado"+cEOL  
		           
	    fWrite(nHdl,cLin)
	    fWrite(nHdl,cHead01)

		nRegLog += 1
	Else
		dbGoTo(nRecno)
    	/*--- Regrava o registro com NOVA FILIAL/PREFIXO/FILORIG ---*/
    	RecLock('SEF',.F.)                                                                
		 If TMP->EF_PREFIXO != 'EIC'
    		SEF->EF_PREFIXO := cPrfxNew
    	 EndIf
	   	 SEF->EF_FILORIG := If(Empty(Substr(cPrfxNew,1,2)),TMP->EF_FILORIG,Substr(cPrfxNew,1,2))
    	 SEF->EF_FILIAL  := ""
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
