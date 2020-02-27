#INCLUDE "rwmake.ch"
/*
----------------------------------------------------------------
PROGRAMA: RMIDSEA
----------------------------------------------------------------
Objetivo: Verifica se haverá registros duplicados no SEA se essa
          tabela passar a ser compartilhada 
----------------------------------------------------------------          
*/
User Function RMIDSEA()

Private oGeraTxt
Private cString := "SEA"

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Análise do SEA-Bordero de Titulos")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa tem como objetivo avaliar a tabela do Modulo Financeiro"
@ 18,018 Say " para identificar possiveis registros duplicados."
@ 26,018 Say " Gera arquivo SEAUNIC.LOG                                          "

@ 70,128 BMPBUTTON TYPE 01 ACTION ProcSEA()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)

Activate Dialog oGeraTxt Centered

Return
/*
------------------------------------------------------------------------
PROGRAMA: ProcSEA
------------------------------------------------------------------------*/

Static Function ProcSEA

Private cArqTxt := "\systemtst\SEAUNIC.LOG"
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

Processa({|| ProcTabSEA() },"Processando...")

Return

/*
----------------------------------------------------------------------
Funcao: ProcTabSEA
----------------------------------------------------------------------
*/
Static Function ProcTabSEA()

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
(1)-EA_FILIAL+EA_NUMBOR+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA
-------------------------------------------*/
cQuery := " SELECT EA_FILIAL,EA_NUMBOR,EA_PREFIXO,EA_NUM,EA_PARCELA,EA_TIPO,EA_FORNECE,EA_LOJA,EA_FILORIG,R_E_C_N_O_ "    
cQuery += " FROM "  
cQuery += RetSqlName("SEA")
cQuery += " WHERE D_E_L_E_T_ = ' '"  
//cQuery += " AND EA_FILIAL = ''"
cQuery += " ORDER BY EA_FILIAL,EA_NUMBOR,EA_PREFIXO,EA_NUM,EA_PARCELA,EA_TIPO,EA_FORNECE,EA_LOJA"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)

dbSelectArea("TMP") 
dbGoTop()

dbSelectArea("SEA")
dbSetOrder(1)

While TMP->(!Eof()) 
    cLin    := Space(nTamLin)+cEOL 
	nRecno  := TMP->R_E_C_N_O_	//Recno()
	cPrfxNew:= TMP->EA_FILIAL + SPACE(1)	//PARA MONTAR A CHAVE CORRETAMENTE
		     
	nLidos += 1

	cRegistro := TMP->(EA_FILIAL+EA_NUMBOR+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA)
    IncProc("Registro lido: "+Alltrim(Transform(nLidos, "@e 999999")))		//StrZero(nLidos))       
			                  
	If Empty(TMP->EA_FILIAL)
	    TMP->(dbSkip())
    	Loop
	EndIf		
		
	cChave := TMP->(EA_FILIAL+EA_NUMBOR+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA)  			//chave unica no banco
	cNewKey:= Space(2) + TMP->(EA_NUMBOR+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA)             //Filial compartilhada

	//dbGoTop()		
	lAchou := SEA->(MsSeek(cNewKey))

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
		cLin += TMP->EA_FILIAL+Space(5)
		cLin += TMP->EA_NUMBOR+Space(2)
		cLin += TMP->EA_PREFIXO+Space(4)
		cLin += TMP->EA_NUM+Space(3)
		cLin += TMP->EA_PARCELA+Space(2) 
		cLin += TMP->EA_TIPO+Space(2)
		cLin += TMP->EA_FORNECE+Space(2)
		cLin += TMP->EA_LOJA+Space(2)
		cLin += "Reg. Lido"+cEOL  
		          
	    fWrite(nHdl,cLin)
	    fWrite(nHdl,cHead01)

		//Registro Pesquisado - duplicado quando alterar prefixo=filial
		cLin := StrZero(nRecno,6)+Space(6)
		cLin += SEA->EA_FILIAL+Space(5)
		cLin += SEA->EA_NUMBOR+Space(2)
		cLin += SEA->EA_PREFIXO+Space(4)
		cLin += SEA->EA_NUM+Space(3)
		cLin += SEA->EA_PARCELA+Space(2) 
		cLin += SEA->EA_TIPO+Space(2)
		cLin += SEA->EA_FORNECE+Space(2)
		cLin += SEA->EA_LOJA+Space(2)

		cLin += "Pesquisado"+cEOL  
		
	    fWrite(nHdl,cLin)

		nRegLog += 1
	Else
		dbGoTo(nRecno)
    	/*--- Regrava o registro com NOVA FILIAL/PREFIXO/FILORIG ---*/
    	RecLock('SEA',.F.)                                                                
		 If TMP->EA_PREFIXO != 'EIC'
    		SEA->EA_PREFIXO := cPrfxNew
    	 EndIf
	   	 SEA->EA_FILORIG := If(Empty(Substr(cPrfxNew,1,2)),TMP->EA_FILORIG,Substr(cPrfxNew,1,2))
    	 SEA->EA_FILIAL  := ""
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
