#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MAIMPCT2 บAutor  ณSandro Albuquerque  บ Data ณ  10/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Programa para importar planilha Excel para a tabela CT2   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 10                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MAIMPCT2()

Local aAreaCT1	:= CT1->(GetArea())
Local aAreaCT2	:= CT2->(GetArea())
Local _cPathLog := ""

Private aCMPCT2		:= {}
Private aBRWCT2		:= {}
Private cARQTRB
Private cMarca		:= GetMark()
Private cCaminho	:= ""
Private _cArqLog 	:= ""
Private cPathTemp 	:= GetTempPath()
Private _nQtdLin	:= Space(6)
Private _cNumDoc    := CriaVar("CT2_DOC")
Private _nOpc		:= 0
Private _nLog       := 0
Private _cTexLin    := " "
Private _cCampos    := {}//Array com a Posicao dos capos a Serem Importados

If Select("TRB") <> 0
	dbSelectArea("TRB")
	dbCloseArea()
	
EndIf

//CRIA ARQUIVO SENAO EXISTE
CHKFILE("CTG")
CHKFILE("CTE")
CHKFILE("DAK")

// Campos que serao utilizados para selecao
aAdd(aCMPCT2,{"OK"			,"C",002,000})
aAdd(aCMPCT2,{"CAMPO"		,"C",010,000})
aAdd(aCMPCT2,{"DESCRI"		,"C",050,000})
aAdd(aCMPCT2,{"TIPO"		,"C",001,000})
aAdd(aCMPCT2,{"TAMAN"		,"N",003,000})
aAdd(aCMPCT2,{"DECIM"		,"N",001,000})
aAdd(aCMPCT2,{"COLUNA"		,"N",003,000})
aAdd(aCMPCT2,{"POSICAO"		,"N",003,000})

aAdd(aBRWCT2,{"OK"			,"  "			})
aAdd(aBRWCT2,{"CAMPO"		,"CAMPO SIGA"	})
aAdd(aBRWCT2,{"DESCRI"		,"DESCRICAO"	})
aAdd(aBRWCT2,{"TIPO"		,"TIPO CAMPO"	})
aAdd(aBRWCT2,{"TAMAN"		,"TAMANHO"		})
aAdd(aBRWCT2,{"DECIM"		,"DECIMAL"		})
aAdd(aBRWCT2,{"COLUNA"		,"COLUNA EXCEL"	})

cARQTRB := CriaTrab(aCMPCT2,.T.)
dbUseArea(.T.,,cArqTrb,"TRB")

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("CT2")

While SX3->(!EOF()) .And. SX3->X3_ARQUIVO = "CT2"
	If  Alltrim(SX3->X3_CAMPO) $("CT2_FILIAL/CT2_DATA/CT2_VALOR/CT2_CCC/CT2_CCD/CT2_CREDIT/CT2_DEBITO/CT2_HIST/CT2_ITEMC/CT2_ITEMD/CT2_CLVLDB/CT2_CLVLCR") //X3USO(SX3->X3_USADO)
		RecLock("TRB",.T.)
		TRB->OK		:= GetMark()
		TRB->CAMPO 	:= SX3->X3_CAMPO
		TRB->DESCRI	:= SX3->X3_DESCRIC
		TRB->TIPO 	:= SX3->X3_TIPO
		TRB->TAMAN	:= SX3->X3_TAMANHO
		TRB->DECIM	:= SX3->X3_DECIMAL
		//
		//Grava a Posicoes Fixas das Colunas
		If Alltrim(SX3->X3_CAMPO) == "CT2_FILIAL"
			TRB->COLUNA := 1
			
		Elseif Alltrim(SX3->X3_CAMPO) == "CT2_DATA"
			TRB->COLUNA := 2
			
		ElseIf Alltrim(SX3->X3_CAMPO) == "CT2_HIST"
			TRB->COLUNA := 3
			
		ElseIf Alltrim(SX3->X3_CAMPO) == "CT2_DEBITO"
			TRB->COLUNA := 4
			
		ElseIf Alltrim(SX3->X3_CAMPO) == "CT2_CREDIT"
			TRB->COLUNA := 5
			
		ElseIf Alltrim(SX3->X3_CAMPO) == "CT2_VALOR"
			TRB->COLUNA := 6
			
		ElseIf Alltrim(SX3->X3_CAMPO) == "CT2_CCD"
			TRB->COLUNA := 7
			
		ElseIf Alltrim(SX3->X3_CAMPO) == "CT2_CCC"
			TRB->COLUNA := 8
			
		ElseIf Alltrim(SX3->X3_CAMPO) == "CT2_ITEMD"
			TRB->COLUNA := 9
			
		ElseIf Alltrim(SX3->X3_CAMPO) == "CT2_ITEMC"
			TRB->COLUNA := 10
			
		ElseIf Alltrim(SX3->X3_CAMPO) == "CT2_CLVLDB"
			TRB->COLUNA := 11
			
		ElseIf Alltrim(SX3->X3_CAMPO) == "CT2_CLVLCR"
			TRB->COLUNA := 12
			
		EndIf
		MsUnlock()
		
	Endif
	SX3->(dbSkip())
	
EndDo
//
//
//Grava Array com as Posicoes dos Campos
DbSelectArea("TRB")
DbGotop()
While !Eof()
	//Grava a Posicao do Campo
	aAdd(_cCampos,{TRB->CAMPO})
	
	DbSkip()
Enddo

DbSelectArea("TRB")
DbGotop()

@ 000,000 TO 280,440 DIALOG oDLG TITLE "Selecione os Campos a Importar"
@ 005,005 SAY OemToAnsi("Campos...") 	OBJECT oLABEL1
@ 015,005 TO 100,218 BROWSE "TRB" FIELDS aBRWCT2 MARK "OK" OBJECT oGrid
//
oGrid:oBrowse:lCanAllmark := .T.
oGrid:oBrowse:lhasMark    := .F.
//
@ 105,080 Get oDoc Var _cNumDoc  Size 030,010 Picture "@E 999999"  Pixel Message OemToAnsi("Informe o numero do DOCTO que sera gravado neste movimento")
@ 120,080 Get oQtd Var _nQtdLin	 Size 030,010 Picture "@E 999999"   Pixel Message OemToAnsi("Caso seja colocado uma quantidade maior que a real ocorrerแ erro de chave ๚nica!")
//
@ 108,025 say OemToAnsi("Documento : ") 		   OBJECT olabel1
@ 123,025 Say OemToAnsi("Linhas da planilha : ")   OBJECT olabel1
//
@ 120,150 Button OemToAnsi("OK") 		Size 030,013 Action  (_nOpc := 1,Close(oDLG)) 	Pixel
@ 120,190 Button OemToAnsi("Cancelar") 	Size 030,013 Action  (_nOpc := 0,Close(oDLG))  Pixel

Activate Dialog oDLG Centered

If Empty(_cNumDoc)
	If _nOpc <> 2
		MsgInfo(OemToAnsi("Informar o numero do documento para importa็ใo do arquivo!"))
	Endif
	Return
Endif

If Empty(_nQtdLin)
	If _nOpc <> 2
		MsgInfo(OemToAnsi("Informar o numero do documento para importa็ใo do arquivo!"))
	Endif
	Return
Endif

If _nOpc == 1
	
	Define FONT oFnt1 Name "Arial Narrow" Size 10,16 Bold
	Define FONT oFnt2 Name "Book Antiqua" Size 09,16 Bold
	//
	Define MsDialog oDlg3 Title OemToAnsi("Sele็ใo de arquivo...") From 00,00 To 07,50 of oMainWnd
	//
	@ 005,005 Say OemToAnsi("Informe o caminho:") Font oFnt1 				 				Pixel
	@ 015,005 Get oCaminho VAR cCaminho		Size 150,010 									Pixel
	@ 015,150 Button OemToAnsi("...") 		Size 012,012 Action (ChangeFile())				Pixel
	@ 035,120 Button OemToAnsi("OK")		Size 036,010 Action (_nOpc := 1,Close(oDlg3)) 	Pixel
	@ 035,160 Button OemToAnsi("Cancel")	Size 036,010 Action (_nOpc := 2,Close(oDlg3)) 	Pixel
	
	Activate Dialog oDlg3 Centered
	
	If _nOpc = 1
		If !File(cCaminho)
			MsgInfo(OemToAnsi("O arquivo especificado nใo existe!"),OemToAnsi("Arquivo Excel"))
			Return
		EndIf
		
		// Se existir o arquivo de script deleta
		If File(cPathTemp + "\ImpCT2.vbs")
			FErase(cPathTemp + "\ImpCT2.vbs")
			
		EndIf
		
		// Se existir o arquivo de txt deleta
		If File(cPathTemp + "\CT2.txt")
			FErase(cPathTemp + "\CT2.txt")
			
		EndIf
		
		_cPathLog  := Substr(cCaminho,1,Len(alltrim(cCaminho))-4)+"-LOG.TXT"
		// Se existir o arquivo de txt deleta
		If File(_cPathLog)
			FErase(_cPathLog)
			
		EndIf
		
		// Cria arquivo de Log de importacao Planilha Excel - CT2.
		_cArqLog := UPPER(_cPathLog)
		nHandle  := GeraLog(_cArqLog,,"C",)
		
		// Abre arquivo de Log para gravacao das ocorrencias
		GeraLog(_cArqLog,,"A",)
		
		MsgRun("Importando dados da Planilha","CT2",{||ProcCT2(cCaminho,cPathTemp)})
		
		If _nLog == 0
			MsgInfo(OemToAnsi("Atualizado com SUCESSO - Fim do Processo !!!"),OemToAnsi("Importa็ใo"))
			
		Else
			MsgInfo(OemToAnsi("Gerou Log de divergencias - PLANILHA nใo foi importada"),OemToAnsi("Importa็ใo"))
			
		Endif
		GeraLog(_cArqLog,,"F",)
	EndIf
	
EndIf
//
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChangeFileบAutor  ณ Sandro Albuquerque บ Data ณ  10/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para selecao do arquivo (Planilha Excel)            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ChangeFile()

Private cRET 	:= ""
Private cTYPE   := "Planilha | *.xls"

cRet 	 := cGetFile(cType,"Selecione arquivo")
cCaminho := cRet

oDlg3:Refresh()
Return // Retorno da rotina ChangeFile()
//
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcCT2   บAutor  ณ Sandro Albuquerque บ Data ณ  11/20/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta o arquivo selecionado para a tabela CT2.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcCT2(cCaminho,cPathTemp)

Private nCont 	 := 1
Private cLn		 := Chr(13) + Chr(10)
Private lOk		 := .T.
Private nLastKey := 0
Private cArqInd
Private nPosReg

//Leitura do arquivo XLS e criacao do TXT
oFile	:= FCreate(cPathTemp + "\ImpCT2.vbs")
FWrite(oFile,'Set objExcel = CreateObject("Excel.Application")'	  + cLn)
FWrite(oFile,'sFile = ""'									      + cLn)
FWrite(oFile,'objExcel.Workbooks.Open("'+cCaminho+'")'			  + cLn)
FWrite(oFile,'sStr = ""'										  + cLn)
FWrite(oFile,'For i = 2 to ' + AllTrim(Str(2 + (Val(_nQtdLin)-1))) + cLn)
FWrite(oFile,'if sStr = "" then'								  + cLn)
FWrite(oFile,'sStr = sStr & "{' + "'"							       )

cArqInd	:= CriaTrab(Nil,.F.)
dbSelectArea("TRB")
IndRegua("TRB",cArqInd,"Str(COLUNA,3,0)+CAMPO",,,"Indexando Registros...")
dbGoTop()

While TRB->(!EOF())
	nPosReg := TRB->(RecNo())
	If nCont = 1
		FWrite(oFile,'" & objExcel.cells(i,' + Str(TRB->COLUNA,3,0) + ').Value & "' + "'"   			)
		nCont ++
	Else
		FWrite(oFile,',' + "'" + '" & objExcel.cells(i,' + Str(TRB->COLUNA,3,0) + ').Value & "' + "'" 	)
		nCont ++
	EndIf
	
	RecLock("TRB",.F.)
	TRB->POSICAO := nCont
	MsUnlock()
	TRB->(dbGoTo(nPosReg))
	TRB->(dbSkip())
EndDo

FWrite(oFile,'}"' 																																							+ cLn)
FWrite(oFile,'	else'																																						+ cLn)
FWrite(oFile,'  	sStr = sStr & ",{' + "'"																														)
nCont := 1
dbSelectArea("TRB")
dbGoTo(1)
While TRB->(!EOF())
	nPosReg := TRB->(RecNo())
	If nCont = 1
		FWrite(oFile,'" & objExcel.cells(i,' + AllTrim(Str(TRB->COLUNA,3,0)) +').Value & "' + "'" 				)
		nCont ++
	Else
		FWrite(oFile,',' + "'" + '" & objExcel.cells(i,' + Alltrim(Str(TRB->COLUNA,3,0)) + ').Value & "' + "'" 	)
		nCont ++
	EndIf
	
	RecLock("TRB",.F.)
	TRB->POSICAO := nCont
	MsUnlock()
	TRB->(dbGoTo(nPosReg))
	TRB->(dbSkip())
EndDo

FWrite(oFile,'}"' 																+ cLn)
FWrite(oFile,'	end if'				 											+ cLn)
FWrite(oFile,'Next'																+ cLn)
FWrite(oFile,'if sStr <> "" then'												+ cLn)
FWrite(oFile,'		sFile = sFile & "{" & sStr & "}"'							+ cLn)
FWrite(oFile,'end if'															+ cLn)
FWrite(oFile,'objExcel.Quit'							 						+ cLn)
FWrite(oFile,'Set fs = CreateObject("Scripting.FileSystemObject")'				+ cLn)
FWrite(oFile,'Set a = fs.CreateTextFile("'+cPathTemp+'CT2.txt", True)'			+ cLn)
FWrite(oFile,'a.WriteLine(sFile)'												+ cLn)
FWrite(oFile,'a.Close')
FClose(oFile)

WinExec("wscript "+cPathTemp+"ImpCT2.vbs")

While !File(cPathTemp+"CT2.txt") .and. lOk
	if nLastKey == 27
		lOk := .F.
	endif
enddo

if !lOk
	ApMsgInfo("Opera็ใo Abortada")
	Return
endif

oFile  := FOpen(cPathTemp+"CT2.txt")
cLinha := FReadStr(oFile,1000000)
FClose(oFile)
aArray := &(SubStr(cLinha,1,At(Chr(13),cLinha)-1))

Processa({|| VLDEXCEL(@aArray)})  // Chamada da funcao de validacao das contas contabeis da planilha Excel

If _nLog == 0
	Processa({|| GRVCT2(@aArray)})  // Chamada da funcao de gravacao
	
Endif

Return //Retorno da rotina ProcCT2()
//
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VLDEXCEL บAutor  ณ Sandro Albuquerque บ Data ณ  11/20/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida conteudo da planilha Eletronica                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VLDEXCEL(aReg)

Local _dDataLanc
Local _aCab		:= {}
Local _aItens	:= {}
Local _nLinha	:= 1
Local _lcheca   := .T.
Local _cTexto 	:= ""
Local _cFilUso  := ""
Local _cDeb     := ""
Local _cCre     := ""
Local i


Private aTRBCT2 := TRB->(dbStruct())

ProcRegua(Len(aReg))

// ROTINA DE VALIDACAO E GERACAO DE LOG
For i := 1 To Len(aReg)
	dbSelectArea("TRB")
	dbGoTop()
	
	While TRB->(!EOF())
		If (TRB->CAMPO) = "CT2_FILIAL"  // 1 - FILIAL
			_cFilUso   := TrataCampo(aReg[i,1],TRB->(TRB->CAMPO))
			
		ElseIf (TRB->CAMPO) = "CT2_DATA" //2 - DATA DO LANCAMENTO
			_dDataLanc  := cTod(TrataCampo(aReg[i,2],TRB->(TRB->CAMPO)))
			
		Elseif (TRB->CAMPO) = "CT2_HIST" //3 - HISTORICO
			_cHist := TrataCampo(aReg[i,3],TRB->(TRB->CAMPO))
			
		Elseif (TRB->CAMPO) = "CT2_DEBITO" // 4 - CONTA DEBITO
			_cContaD := TrataCampo(aReg[i,4],TRB->(TRB->CAMPO))
			
		Elseif (TRB->CAMPO) = "CT2_CREDIT" //5 - CONTA CREDITO
			_cContaC := TrataCampo(aReg[i,5],TRB->(TRB->CAMPO))
			
		Elseif (TRB->CAMPO) = "CT2_VALOR"	// 6 - VALOR DO LANCAMENTO
			_nValor	:= Val(StrTran(StrTran(aReg[i,6]," ",""),",","."))
			
		Elseif (TRB->CAMPO) = "CT2_CCD" //7 - CENTRO DE CUSTOS DEBITO
			_cCD	:= TrataCampo(aReg[i,7],TRB->(TRB->CAMPO))
			
		Elseif (TRB->CAMPO) = "CT2_CCC" //8 - CENTRO DE CUSTOS CREDITO
			_cCC	:= TrataCampo(aReg[i,8],TRB->(TRB->CAMPO))
			
		Elseif (TRB->CAMPO) ="CT2_ITEMD" // 9 - ITEM CONTABIL DEBITO
			_cItemd := TrataCampo(aReg[i,9],TRB->(TRB->CAMPO))
			
		Elseif (TRB->CAMPO) ="CT2_ITEMC" // 10 - ITEM CONTA CONTABIL CREDITO
			_cItemc := TrataCampo(aReg[i,10],TRB->(TRB->CAMPO))
			
		Elseif (TRB->CAMPO) = "CT2_CLVLDB" // 11 - CLASSE DE VALOR DEBITO
			_cClvlDB := TrataCampo(aReg[i,11],TRB->(TRB->CAMPO))
			
		Elseif (TRB->CAMPO) = "CT2_CLVLCR" // 12 - CLASSE DE VALOR CREDITO
			_cClvlCR := TrataCampo(aReg[i,12],TRB->(TRB->CAMPO))
			
		Endif
		
		TRB->(dbSkip())
	EndDo
	
	// Verifica o tipo de contabilizacao
	If !Empty(_cContaD) .and. !Empty(_cContaC)
		_cDeb := "D"
		_cCre := "C"
		
	ElseIf !Empty(_cContaD) .and. Empty(_cContaC)
		_cDeb := "D"
		_cCre := " "
		
	ElseIf Empty(_cContaD) .and. !Empty(_cContaC)
		_cDeb := " "
		_cCre := "C"
		
	Endif
	
	// Linha da planilha para geracao de log se necessario
	_cTexLin :=  _cFilUso+" "+Dtoc(_dDataLanc)+" "+_cHist+" "+_cDeb+" "+_cContaD+" "+_cCre+" "+_cContaC+" "+Transform(_nValor,"@E 999,999,999.99")+" "+;
	_cCD+" "+_cCC+" "+_cItemd+" "+_cItemc+" "+_cClvlDB+" "+_cClvlCR
	
	// Checa a existencia de documento igual na primeira passada
	IF _lCheca
		dbSelectArea("CT2")
		dbSetOrder(1)
		// Verifica se jแ existe o documento com a mesma linha para evitar duplicadade de chave.
		IF CT2->(Dbseek( _cFilUso + DTOS(_dDataLanc) + "008888" + "001" + _cNumDoc)) .and. _nLinha == 1
			Aviso( "Aten็ใo!", "Este DOCUMENTO jแ foi importado. Efetue a EXCLUSรO pelo Sistema para importar novamente - "+_cNumDoc, { "OK" } )
			_nLog ++
			Return()
		Endif
		_lCheca := .F.
	Endif  
	
	//
	//AOliveira  -  13-09-2018
	//Validar Calendario Contabil 
	//
	_lErro   := .F.
	_cEXERC  := Padr(Year2Str(_dDataLanc),TamSx3("CTG_EXERC")[1] )  
	_cPERIOD := Padr(Month2Str(_dDataLanc),TamSx3("CTG_PERIOD")[1] ) 
	
	DbSelectArea("CTG")
	CTG->(DbSetOrder(4)) //CTG_FILIAL+CTG_EXERC+CTG_PERIOD
	CTG->(DbGoTop())                                      
	If CTG->(DbSeek( xFilial("CTG")+ _cEXERC +  _cPERIOD ))	
		If Alltrim(CTG->CTG_STATUS) <> "1"
			_lErro := .T.	
		EndIf	
	Else
		_lErro := .T.
	EndIf
	
	If _lErro
		Aviso( "Aten็ใo!", "Verifique o Calendแrio contแbil para o perํodo ( "+_cPERIOD+"/"+_cEXERC+" ). E efetue novamente os procedimentos. ", { "OK" } ) 
		_nLog ++
		Return()
	EndIf
	//                     
	//
	//
	
	// Valida se a filial e uso eh a mesma da planilha
	If _cFilUso <> cFilAnt
		_nLog ++
		_cTexto := strzero(_nLog,6)+" - Filial nใo corresponde com a filial da planilha -> "+_cTexLin
		GeraLog( ,_cTexto,"G",nHandle)
		
	Endif
	
	// Valida Plano de Contas
	If !Empty(_cContaD) .and. !Empty(_cContaC)
		// Valida Conta contabil a Debito
		ValidaCta(_cContaD, _nValor, _cCD, _cItemD, _cClvlDB)
		
		// Valida Conta contabil a Credito
		ValidaCta(_cContaC, _nValor, _cCC, _cItemC, _cClvlCR)
		
	ElseIf !Empty(_cContaD) .and. Empty(_cContaC)
		// Valida Conta contabil a Debito
		ValidaCta(_cContaD, _nValor, _cCD, _cItemD, _cClvlDB)
		
	ElseIf Empty(_cContaD) .and. !Empty(_cContaC)
		// Valida Conta contabil a Debito
		ValidaCta(_cContaC, _nValor, _cCC, _cItemC, _cClvlCR)
		
	Else
		_nLog ++
		_cTexto := strzero(_nLog,6)+" - Faltam contas DEBITO/CREDITO ver planilha Excel --> "+_cTexLin
		GeraLog( ,_cTexto,"G",nHandle)
		
	Endif
	
	IncProc()
	
Next i
Return() // Final da rotina de valida็ใo das entidades contabeis - VLDEXCEL()
//
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  GRVCT2  บAutor  ณ Sandro Albuquerque บ Data ณ  11/20/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava o movimento importado no CT2.                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GRVCT2(aReg)

Local _aCab		:= {}
Local _aItens	:= {}
Local _nLinha	:= 1
Local _dDataLanc
Local _cFilUso  := ""
Local i

Private aTRBCT2 := TRB->(dbStruct())

ProcRegua(Len(aReg)) // Rotina de Gravacao apos validacao.

IF _nLog == 0  //  Se o log for igual a zero nใo gerou erro na validacao.
	For i := 1 To Len(aReg)
		dbSelectArea("TRB")
		dbGoTop()
		
		While TRB->(!EOF())
			
			// 1        2       3           4       5        6      7       8        9          10          11          12
			// FILIAL	DATA	DESCRICAO	DEBITO	CREDITO	 VALOR	CC_DEB	CC_CRED	 ITEM_DEB	ITEM_CRED	CLASSE_DEB	CLASSE_CRE
			
			// Grava as informacoes no arquivo de trabalho
			If (TRB->CAMPO) = "CT2_FILIAL"  // 1 - FILIAL
				_cFilUso   := TrataCampo(aReg[i,1],TRB->(TRB->CAMPO))
				
			ElseIf (TRB->CAMPO) = "CT2_DATA" //2 - DATA DO LANCAMENTO
				_dDataLanc  := cTod(TrataCampo(aReg[i,2],TRB->(TRB->CAMPO)))
				
			Elseif (TRB->CAMPO) = "CT2_HIST" //3 - HISTORICO
				_cHist := TrataCampo(aReg[i,3],TRB->(TRB->CAMPO))
				
			Elseif (TRB->CAMPO) = "CT2_DEBITO" // 4 - CONTA DEBITO
				_cContaD := TrataCampo(aReg[i,4],TRB->(TRB->CAMPO))
				
			Elseif (TRB->CAMPO) = "CT2_CREDIT" //5 - CONTA CREDITO
				_cContaC := TrataCampo(aReg[i,5],TRB->(TRB->CAMPO))
				
			Elseif (TRB->CAMPO) = "CT2_VALOR"	// 6 - VALOR DO LANCAMENTO
				_nValor	:= Val(StrTran(StrTran(aReg[i,6]," ",""),",","."))
				
			Elseif (TRB->CAMPO) = "CT2_CCD" //7 - CENTRO DE CUSTOS DEBITO
				_cCD	:= TrataCampo(aReg[i,7],TRB->(TRB->CAMPO))
				
			Elseif (TRB->CAMPO) = "CT2_CCC" //8 - CENTRO DE CUSTOS CREDITO
				_cCC	:= TrataCampo(aReg[i,8],TRB->(TRB->CAMPO))
				
			Elseif (TRB->CAMPO) ="CT2_ITEMD" // 9 - ITEM CONTABIL DEBITO
				_cItemd := TrataCampo(aReg[i,9],TRB->(TRB->CAMPO))
				
			Elseif (TRB->CAMPO) ="CT2_ITEMC" // 10 - ITEM CONTA CONTABIL CREDITO
				_cItemc := TrataCampo(aReg[i,10],TRB->(TRB->CAMPO))
				
			Elseif (TRB->CAMPO) = "CT2_CLVLDB" // 11 - CLASSE DE VALOR DEBITO
				_cClvlDB := TrataCampo(aReg[i,11],TRB->(TRB->CAMPO))
				
			Elseif (TRB->CAMPO) = "CT2_CLVLCR" // 12 - CLASSE DE VALOR CREDITO
				_cClvlCR := TrataCampo(aReg[i,12],TRB->(TRB->CAMPO))
				
			Endif
			
			TRB->(dbSkip())
			
		EndDo
		
		// Busca as Informacoes de data, doc, lote, etc
		_cLote		:= "008888"
		_cSubLote	:= "001"
		//
		// Verifica o tipo de contabilizacao
		If !Empty(_cContaD) .and. !Empty(_cContaC)
			_cDebCre := "3"
			
		ElseIf !Empty(_cContaD) .and. Empty(_cContaC)
			_cDebCre := "1"
			
		ElseIf Empty(_cContaD) .and. !Empty(_cContaC)
			_cDebCre := "2"
			
		Endif
		
		//Trava tabela CT2 para gravar
		Reclock("CT2",.T.)
		// Gravacao da Chave
		CT2->CT2_FILIAL     := _cFilUso
		CT2->CT2_DATA       := _dDataLanc
		CT2->CT2_LOTE       := _cLote
		CT2->CT2_SBLOTE     := _cSubLote
		CT2->CT2_DOC        := _cNumDoc
		CT2->CT2_LINHA      := StrZero(_nLinha,3)
		CT2->CT2_MOEDLC     := "01"
		//
		CT2->CT2_DC			:= _cDebCre
		CT2->CT2_DEBITO		:= Iif(!Empty(_cContaD),_cContaD, "")
		CT2->CT2_CREDIT		:= Iif(!Empty(_cContaC),_cContaC, "")
		CT2->CT2_CCD		:= Iif(!Empty(_cContaD),_cCD, "")
		CT2->CT2_CCC		:= Iif(!Empty(_cContaC),_cCC, "")
		CT2->CT2_VALOR		:= _nValor
		CT2->CT2_ITEMD		:= Iif(!Empty(_cContaD),_cItemD, "")
		CT2->CT2_ITEMC		:= Iif(!Empty(_cContaC),_cItemc, "")
		CT2->CT2_CLVLDB		:= Iif(!Empty(_cContaD),_cClvlDB, "")
		CT2->CT2_CLVLCR		:= Iif(!Empty(_cContaC),_cClvlCR, "")
		CT2->CT2_ORIGEM		:= "IMP. EXCEL - "+Upper(SubSTR(cUsuario,7,15))
		CT2->CT2_HP			:= ""
		CT2->CT2_HIST		:= _cHist
		//CT2->CT2_TPSALD		:= "1"
		
		//AOliveira
		//Alterado para Atender a nova rotina de Aprova็ใo de LAn็amento. 
		CT2->CT2_TPSALD	:= "9"                              //   pre-lan็amento  
		CT2->CT2_XSITUA := "N"                              //-  Situa     
		CT2->CT2_XUSR   := Alltrim(RetCodUsr())             //-  Usuario Inclui
		CT2->CT2_XUSRN1 := Alltrim(UsrRetName(RetCodUsr())) //-  Nome user Inclui
		CT2->CT2_XDTINI := dDataBase                        //-  Data Inclui
		//

		MsUnlock()
		
		_nLinha ++
		
		IncProc()
		
	Next i
Else
	Aviso( "Aten็ใo!", "Foi gerado um arquivo de LOG para as diverg๊ncias encontras na Planilha EXEL - "+_cNumDoc, { "OK" } )
	
Endif

GeraLog(_cArqLog,,"F",) // Fecha aquivo de Log visualizado.

Return() //Retorno da rotina GrvCT2
//
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GeraLog  บAutor  ณ Sandro Albuquerque บ Data ณ  05/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerar arquivo texto                                        บฑฑ
ฑฑบ          ณ Parametros:                                                บฑฑ
ฑฑบ          ณ cArqTxt -> nome e path do arquivo a ser gerado             บฑฑ
ฑฑบ          ณ cLin    -> texto com o conteudo a ser gravado              บฑฑ
ฑฑบ          ณ cOpc    -> opcao A : Abertura de arquivo para gravacao     บฑฑ
ฑฑบ			 ณ					C : Criar o arquivo com cArqTxt           บฑฑ
ฑฑบ          ณ                  G : Gravar o cLin no cArqTxt              บฑฑ
ฑฑบ          ณ                  V : chamar o NotePad e Exibe o conteudo   บฑฑ
ฑฑบ          ณ                      de cArqTxt                            บฑฑ
ฑฑบ          ณ                  F : Fechar o arquivo pelo handle          บฑฑ
ฑฑบ          ณ nHdl    -> Handle do cArqtxt criado para poder ser gravado บฑฑ
ฑฑบ          ณ            cLin                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap 10.01 - Midori                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraLog(cArqTxt, cLinha, cOpc, nHdl )

//Define varivel com o ASCII do CR/LF
Local cEol	:= (CHR(13)+CHR(10))
Local lLog := .T.

If cOpc == "C"    //Verifica se ira criar o arquivo
	nHdl := fCreate( cArqTxt )
	If ( nHdl == -1 ) // Se houve erro na criacao do texto no sistema operacional.
		lLog := .F.
	End
	
ElseIf cOpc == "A" //Verifica se ira abrir o arquivo
	// Abrir com acesso a escrita
	nHdl := fOpen( cArqTxt, 1 )
	// Se houve erro na criacao do texto no sistema operacional.
	If ( nHdl == -1 )
		lLog := .F.
	EndIf
	FSeek( nHdl, 0, 2 )
	
ElseIf cOpc == "G"  // Gravar o texto
	// Se houve erro na criacao do texto no sistema operacional.
	If ( Empty(nHdl) .or. nHdl == -1 )
		lLog := .F.
	Else
		cLinha += cEOL
		fWrite( nHdl, cLinha, Len( cLinha ) ) // Grava o conteudo do parametro
	EndIf
	
ElseIf cOpc == "V" // Visualizao arquivo Txt
	fClose( nHdl )
	fOpen( cArqTxt, 1 )
	//Chama a winexec para abertura do log via wordpad
	WinExec("NotePad.exe "+cArqtxt, 1)
	
ElseIf cOpc == "F"
	//Fechando arquivo texto apos geracao.
	fClose( nHdl )
	
EndIf

//If !(lLog)
//	MsgAlert( ( "O arquivo de nome " + cArqTxt + " nao pode ser criado! Verifique autorizacoes de gravacao e leitura." ), "Atencao!" )
//Endif

Return(nHdl)
//
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidaCta บ Autor ณ Sandro Albuquerque บ Data ณ  11/20/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTratamento dos campos a serem importados para o CT2         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidaCta(_cConta, _nValor, _cCC, _cItem, _cClvl)

Local _cTexto := ' '

dbSelectArea("CT1")
dbSetOrder(1)

If CT1->(Dbseek(xFilial("CT1")+_cConta))
	
	If _nValor <= 0
		_nLog ++
		_cTexto := strzero(_nLog,6)+" - O Valor deve ser maior que zero ---> "+_cTexLin
		GeraLog( ,_cTexto,"G",nHandle)
	Endif
	
	//Verifica CENTRO DE CUSTOS
	If CT1->CT1_CCOBRG=='1' .and. Empty(_cCC)
		_nLog ++
		_cTexto := strzero(_nLog,6)+" - Centro de Custo nใo informado -----> "+_cTexLin
		GeraLog( ,_cTexto,"G",nHandle)
		
	ElseIF CT1->CT1_CCOBRG=='2'.and. !(Empty(_cCC))
		_nLog ++
		_cTexto := strzero(_nLog,6)+" - Centro de Custo indevido ----------> "+_cTexLin
		GeraLog( ,_cTexto,"G",nHandle)
		
	Endif
	
	// Verifica UNIDADE DE ORIGEm
	If CT1->CT1_ITOBRG=='1' .and. Empty(_cItem)
		_nLog ++
		_cTexto := strzero(_nLog,6)+" - Unidade de Origem nใo informada ---> "+_cTexLin
		GeraLog( ,_cTexto,"G",nHandle)
		
	ElseIF CT1->CT1_ITOBRG=='2' .and. !(Empty(_cItem))
		_nLog ++
		_cTexto := strzero(_nLog,6)+" - Unidade de Origem indevida --------> "+_cTexLin
		GeraLog( ,_cTexto,"G",nHandle)
		
	Endif
	
	//Verifica CLASSE DE VALOR
	If CT1->CT1_CLOBRG=='1' .and. Empty(_cCLvl)
		_nLog ++
		_cTexto := strzero(_nLog,6)+" - Classe de Valor nใo informada ----> "+_cTexLin
		GeraLog( ,_cTexto,"G",nHandle)
		
	ElseIF CT1->CT1_CLOBRG=='2' .and. !(Empty(_cCLvl))
		_nLog ++
		_cTexto := strzero(_nLog,6)+" - Classe de Valor indevida ----------> "+_cTexLin
		GeraLog( ,_cTexto,"G",nHandle)
		
	Endif
	
	
Else
	_nLog ++
	_cTexto := strzero(_nLog,6)+" - Cta Contแbil nใo existe no Plano --> "+_cTexLin
	GeraLog( ,_cTexto,"G",nHandle)
Endif
Return()
//
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTratacampoบ Autor ณ Sandro Albuquerque บ Data ณ  11/20/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTratamento dos campos a serem importados para o CT2         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TrataCampo(xCampo,xGrava)

Local cRet

Do Case
	
	Case ValType(xGrava) = ValType(xCampo)
		cRet := xCampo
		
	Case ValType(xGrava) = "N" .And. ValType(xCampo) = "C"
		xCampo := StrTran(xCampo,",",".")
		cRet := Val(xCampo)
		
	Case ValType(xGrava) = "C" .And. ValType(xCampo) = "N"
		cRet := AllTrim(Str(xCampo))
		
	Case ValType(xGrava) = "C" .And. ValType(xCampo) = "D"
		cRet := DtoC(xCampo)
		
	Case ValType(xGrava) = "D" .And. ValType(xCampo) = "C"
		cRet := CtoD(xCampo)
		
	Case ValType(xGrava) = "M"
		cRet := xGrava
EndCase

Return(cRet)

RestArea(aAreaCT2)
RestArea(aAreaCT1)

RETURN() //Retorno da rotina IMPCT2
