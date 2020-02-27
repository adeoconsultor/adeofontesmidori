#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RelMensImp ³Autor ³ Luiz Fernando        ³ Data ³ 07.08.10  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório Mensal de Importações                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ RelMensImp                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gera Planilha Excel para Informacoes Suframa                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/
user Function RelMensImp()

Local aPergs     := {}
//Local nTpRel   := TipoRelat()
Local nTpRel     := 2
Private bFileFat :={|| cDir:=ChoseMapDir(),If(Empty(cDir),cDir:=Space(200),Nil)}
Private oDlg     := Nil
Private cArq     := Space(10), cRel:="Relatorio Mensal de Importacao"
Private cDir     := Space(250)
Private cPerg    := ""
Private aArea    := GetArea()
Private lRetor   := .T.
Private lSair    := .F.
Private lTudOk   := .T.
Private aStru    := {}
private cArqTrb2 := CriaTrab(NIL,.F.)
Private cCamposCSV:= ""
Private cDadosCSV := ""
Private cMsg      := ""
Private cArqTxt   := ""
Private dDtaEntrF1:= CtoD("  /  /  ")
Private cNfes     := ""

lEnd := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//If Empty(nTpRel)
//	Return
//Else
cPerg := Avkey("RELMIM","X1_GRUPO")
//EndIf

ValidPerg(nTpRel)
If !Pergunte(cPerg)
	Return (.T.)
EndIf

//+-----------------------------------------------------------------------------------//
//| Definição da janela e seus conteúdos
//+-----------------------------------------------------------------------------------//

DEFINE MSDIALOG oDlg TITLE cRel FROM 0,0 TO 175,368 OF oDlg PIXEL

@ 06,06 TO 65,180 LABEL "Dados do arquivo" OF oDlg PIXEL

@ 15, 10 SAY   "Nome do Arquivo"  SIZE 45,7 PIXEL OF oDlg
@ 25, 10 MSGET cArq               SIZE 50,8 PIXEL OF oDlg

@ 40, 10 SAY "Diretorio de gravação"  SIZE  65, 7 PIXEL OF oDlg
@ 50, 10 MSGET cDir PICTURE "@!"      SIZE 150, 8 WHEN .F. PIXEL OF oDlg
@ 50,162 BUTTON "..."                 SIZE  13,10 PIXEL OF oDlg ACTION Eval(bFileFat)

DEFINE SBUTTON FROM 70,10 TYPE 1  OF oDlg ACTION (ValiRel("ok")) ENABLE
DEFINE SBUTTON FROM 70,50 TYPE 2  OF oDlg ACTION (ValiRel("cancel")) ENABLE

ACTIVATE MSDIALOG oDlg CENTER

If lSair
	Return .T.
EndIf

//If nTpRel == 2    // Relatorio em Excel
Processa({||GEREXCEL()},"Gerando Relatorio de ") //+cRel+' ...')
//Endif


If lTudOk
	MsgInfo(cMsg,"Atenção")
	lAbre := MsgYesNo("Deseja Abrir o arquivo em Excel?","Atenção")
	
	If lAbre
		If ! ApOleClient( 'MsExcel' )
			MsgStop(" MsExcel nao instalado ")
			Return
		EndIf
		
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cArqTxt)
		
		oExcelApp:SetVisible(.T.)
	EndIf
EndIf

Return .T.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // De  Filial                           ³
//³ mv_par02             // Ate Filial                           ³
//³ mv_par03             // Dta Ent.Almox De                     ³
//³ mv_par04             // Dta Ent.Almox Ate                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function GEREXCEL()

// monta arquivo analitico

aAdd(aStru,{"FILIAL"  ,"C",02,0})  // Filial Midori                                 b
//aAdd(aStru,{"DTPROC"  ,"D",08,0})  // Data do Processo de Embarque
aAdd(aStru,{"PROCESS" ,"C",15,0})  // nº Processo
aAdd(aStru,{"NEXPORT" ,"C",30,0})  // Nome do exportador
aAdd(aStru,{"DTNFEMP" ,"D",08,0})  // Data de entrada da nota fiscal na empresa
aAdd(aStru,{"NRNFE"   ,"C",09,0})  // Numero nota fiscal de entrada
aAdd(aStru,{"NCM"	  ,"C",10,0})  // Numero da NCM
aAdd(aStru,{"QTDE"	  ,"N",11,3})  // Quantidade por produto importado
aAdd(aStru,{"UNIDADE" ,"C",04,0})  // unidade de medida
aAdd(aStru,{"CODIGO"  ,"C",15,0})  // Codigo do Produto
aAdd(aStru,{"GRUPO"   ,"C",04,0})  // Codigo do Grupo do Produto
aAdd(aStru,{"DESCPRO" ,"C",30,0})  // Descrição do produto
aAdd(aStru,{"MOED"    ,"C",03,0})  // Moeda de importação
aAdd(aStru,{"TXMOE"	  ,"N",15,8})  // Taxa da moeda de importação
aAdd(aStru,{"VALUNIM" ,"N",16,4})  // Valor unitário de importação em moeda estrangeira
aAdd(aStru,{"VALTOTM" ,"N",16,4})  // Valor total Fob em moeda estrangeira
aAdd(aStru,{"VALUNIN" ,"N",16,2})  // Valor unitário em moeda nacional
aAdd(aStru,{"VALTOTN" ,"N",16,2})  // Valor  total Fob em moeda nacional
aAdd(aStru,{"FIM" 	  ,"C",01,0})  // Fim

dbcreate(cArqTrb2,aStru)
dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)
index on FILIAL+DtoS(DTNFEMP)+PROCESS to &(cArqTrb2+"1")
//index on CODIGO+NCM+DESTAQUE to &(cArqTrb2+"1")

set index to &(cArqTrb2+"1")

Processa({|lEnd|GeraRel()})

TRB2->(dbclosearea())

Return .T.

***********************************
Static Function GeraRel()
***********************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice de Trabalho                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


cAliasSW7:="SW7"
dbSelectArea("SW7")
cIndex := CriaTrab("",.F.)
cKey := 'W7_HAWB'

cCondicao := 'W7_FILIAL>="'+mv_par01+'".And.W7_FILIAL<="'+mv_par02+'"'

IndRegua("SW7",cIndex,cKey,,cCondicao)

dbSelectArea("SW7")

#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#ENDIF

dbGoTop()
ProcRegua(LastRec())

cAliasSF1:="SF1"
dbSelectArea("SF1")
cIndex := CriaTrab("",.F.)
cKey := 'F1_FILIAL+DtoS(F1_DTDIGIT)'

cCondicao := 'F1_FILIAL>="'+mv_par01+'".And.F1_FILIAL<="'+mv_par02+'"'
cCondicao += '.And.DTOS(F1_DTDIGIT)>="'+DTOS(mv_par03)+'".And.DTOS(F1_DTDIGIT)<="'+DTOS(mv_par04)+'"'
cCondicao += '.AND.F1_STATUS = "A"'
cCondicao += '.AND.F1_TIPO = "N"'
cCondicao += '.AND.!Empty(F1_HAWB)'

IndRegua("SF1",cIndex,cKey,,cCondicao)

dbSelectArea("SF1")

#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#ENDIF

dbGoTop()
ProcRegua(LastRec())

While !Eof()
	
	dbSelectArea("SF1")
	_cEmbNum := SF1->F1_HAWB
	_cFilial := SF1->F1_FILIAL
		
	DbselectArea("SW7")
	DbSeek(_cEmbNum)
	
	If !Eof()
		
		While SW7->W7_HAWB == _cEmbNum .and. !Eof()
			
			IncProc("Emb: "+Alltrim(_cEmbNum)+" Prod: "+AllTrim(SW7->W7_COD_I))
			
			DbSelectArea("TRB2")
			RecLock("TRB2",.T.)
			
			TRB2->FILIAL   := _cFilial       											  // Filial Midori
			TRB2->PROCESS  := SW7->W7_HAWB     											  // N. Processo
			TRB2->NEXPORT  := Posicione("SA2",1,xFilial("SA2")+SW7->W7_FORN,"A2_NOME")    // Nome do exportador
			TRB2->DTNFEMP  := SF1->F1_DTDIGIT 			 								  // Data de entrada da nota fiscal na empresa
			TRB2->NRNFE    := SF1->F1_DOC												  // Numero nota fiscal de entrada
			TRB2->NCM 	   := SW7->W7_NCM      											  // Numero da NCM
			TRB2->QTDE     := SW7->W7_QTDE     											  // Quantidade por produto importado
			TRB2->UNIDADE  := Posicione("SB1",1,xFilial("SB1")+SW7->W7_COD_I,"B1_UM")     // unidade de medida
			TRB2->CODIGO   := SW7->W7_COD_I                                               // Codigo do Produto   
			TRB2->GRUPO    := Posicione("SB1",1,xFilial("SB1")+SW7->W7_COD_I,"B1_GRUPO")  // Codigo do Grupo do Produto
			TRB2->DESCPRO  := Posicione("SB1",1,xFilial("SB1")+SW7->W7_COD_I,"B1_DESC")   // Descrição do produto
			TRB2->MOED     := Posicione("SW9",3,_cFilial+_cEmbNum,"W9_MOE_FOB")     	  // Moeda de importação
                 _nTxFob   := Posicione("SW9",3,_cFilial+_cEmbNum,"W9_TX_FOB")            // Busca Taxa da Invoice
			TRB2->TXMOE    := _nTxFob												      // Taxa da moeda de importação
			TRB2->VALUNIM  := SW7->W7_PRECO                    							  // Valor unitário de importação em moeda estrangeira
			TRB2->VALTOTM  := SW7->W7_QTDE * SW7->W7_PRECO     							  // Valor total Fob em moeda estrangeira
			TRB2->VALUNIN  := (SW7->W7_PRECO*_nTxFob)  							          // Valor unitário em moeda nacional
			TRB2->VALTOTN  := ((SW7->W7_QTDE*SW7->W7_PRECO)*_nTxFob)  			          // Valor  total Fob em moeda nacional
			
			MsUnlock()
			
			DbSelectArea("SW7")
			DbSkip()
			
		Enddo
		
	Endif
	
	dbSelectArea("SF1")
	dbSkip()
	
Enddo

GeraExcel()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraExcel ºAutor  ³Luiz                º Data ³  01/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Arquivo em Excel e abre                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function GeraExcel()

MsAguarde({||GeraCSV()},"Aguarde","Gerando Planilha Relatorio Mensal de Importações",.F.)

return .T.

//+-----------------------------------------------------------------------------------//
//|Funcao....: TipoRelat()
//|Autor.....: Luiz Fernando - luiz@dqzafra.com.br
//|Descricao.: Seleciona o Tipo de relatório
//|Observação:
//+-----------------------------------------------------------------------------------//
*------------------------------------------------*
Static Function TipoRelat()
*------------------------------------------------*

Local cTipoCad  := "Seleção"
Local cCadastr  := "Relatórios"
Local oDlg      := Nil
Local oCamb     := Nil
Local cCamb     := ""
Local aCamb     := {}
Local lRet      := .F.
Local cRet      := 0

aAdd(aCamb,"1=Impressão")
aAdd(aCamb,"2=Planilha")

DEFINE MSDIALOG oDlg TITLE cCadastr FROM 0,0 TO 95,320 OF oDlg PIXEL

@ 06, 06 TO 40,102 LABEL cTipoCad OF oDlg PIXEL
@ 18, 15 COMBOBOX oCamb VAR cCamb ITEMS aCamb SIZE 70,10 OF oDlg PIXEL

DEFINE SBUTTON FROM 08,120 TYPE 19 OF oDlg ACTION (lRet:=.T.,oDlg:End()) ENABLE
DEFINE SBUTTON FROM 26,120 TYPE 2  OF oDlg ACTION (lRet:=.F.,oDlg:End()) ENABLE

ACTIVATE MSDIALOG oDlg CENTER

If lRet
	cRet := Val(cCamb)
EndIf

Return(cRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: ValidPerg()
//|Descricao.: Valida a existencia das perguntas, criando caso não exista
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function ValidPerg(xTp)
*-----------------------------------------*

Local sAlias := Alias()
Local aRegs := {}
Local i,j

aAdd(aRegs,{cPerg,"01","Filial De"         ,"","","mv_ch1","C",02,0,0,"G","U_ValPerg ('01')","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
aAdd(aRegs,{cPerg,"02","Filial Ate"        ,"","","mv_ch2","C",02,0,0,"G","U_ValPerg ('02')","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
aAdd(aRegs,{cPerg,"03","Dta Ent.Almox De " ,"","","mv_ch3","D",08,0,0,"G","U_ValPerg ('03')","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""  ,"","","","@D",""})
aAdd(aRegs,{cPerg,"04","Dta Ent.Almox Ate" ,"","","mv_ch4","D",08,0,0,"G","U_ValPerg ('04')","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""  ,"","","","@D",""})

dbSelectArea("SX1")
SX1->(dbSetOrder(1))

For i:=1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[i,2]))
		SX1->(RecLock("SX1",.T.))
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		SX1->(MsUnlock())
	Endif
Next

dbSelectArea(sAlias)

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: U_ValPerg()
//|Descricao.: Valida datas informadas nas perguntas
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function ValPerg(cMV)
*-----------------------------------------*
Local cRet     := .T.
Local cTitulo  := "Inconsistencia de Dados"

Do Case
	Case cMV == '01'
		
		If Empty(MV_PAR01)
			Aviso( cTitulo, "Filial inicial deve ser informada", {"Ok"} )
			cRet:=.F.
		Endif
		
		If !Empty(MV_PAR02) .AND. MV_PAR01 > MV_PAR02
			Aviso( cTitulo, "Filial inicial não pode ser maior que o Final", {"Ok"} )
			cRet := .F.
		EndIf
		
	Case cMV == '02'
		
		If Empty(MV_PAR02)
			Aviso( cTitulo, "Filial final deve ser informada", {"Ok"} )
			cRet:=.F.
		Endif
		
		
		If !Empty(MV_PAR01) .AND. MV_PAR01 > MV_PAR02
			Aviso( cTitulo, "Filial final não pode ser menor que o Inicial", {"Ok"} )
			cRet := .F.
		EndIf
		
	Case cMV == '03'
		If Empty(MV_PAR03)
			Aviso( cTitulo, "Dta Ent. Almoxarifado Inicial deve ser informada", {"Ok"} )
			cRet:=.F.
		Endif
		
		If !Empty(MV_PAR04) .AND. MV_PAR03 > MV_PAR04
			Aviso( cTitulo, "Dta Ent. Almoxarifado Inicial não pode ser maior que a Final", {"Ok"} )
			cRet := .F.
		EndIf
	Case cMV == '04'
		
		If Empty(MV_PAR04)
			Aviso( cTitulo, "Dta Ent. Almoxarifado Final deve ser informada", {"Ok"} )
			cRet:=.F.
		Endif
		
		If !Empty(MV_PAR03) .AND. MV_PAR03 > MV_PAR04
			Aviso( cTitulo, "Dta Ent. Almoxarifado Final não pode ser menor que a Inicial", {"Ok"} )
			cRet := .F.
		EndIf
		
	End Case
	
	Return(cRet)
	
	//+-----------------------------------------------------------------------------------//
	//|Funcao....: ChoseMapDir()
	//|Descricao.: Localiza diretório de gravação
	//|Observação:
	//+-----------------------------------------------------------------------------------//
	*-----------------------------------------*
	Static Function ChoseMapDir()
	*-----------------------------------------*
	Local cTitle:= "Geração de arquivo"
	Local cMask := "Formato *|*.*"
	Local cFile := ""
	Local nDefaultMask := 0
	Local cDefaultDir  := "C:\"
	Local nOptions:= GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY
	
	cFile:= cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,.F., nOptions)
	
	Return(cFile)
	
	//+-----------------------------------------------------------------------------------//
	//|Funcao....: ValiRel()
	//|Descricao.: Valida informações de gravação
	//|Observação:
	//+-----------------------------------------------------------------------------------//
	*-----------------------------------------*
	Static Function ValiRel(cValida)
	*-----------------------------------------*
	Local lCancela
	
	If cValida = "ok"
		If Empty(Alltrim(cArq))
			MsgInfo("O nome do arquivo deve ser informado","Atenção")
			lRetor := .F.
		ElseIf Empty(Alltrim(cDir))
			MsgInfo("O diretório deve ser informado","Atenção")
			lRetor := .F.
		ElseIf Len(Alltrim(cDir)) <= 3
			MsgInfo("Não se pode gravar o arquivo no diretório raiz, por favor, escolha um subdiretório.","Atenção")
			lRetor := .F.
		Else
			oDlg:End()
			lRetor := .T.
		EndIf
	Else
		lCancela := MsgYesNo("Deseja cancelar a geração da View de Importação?","Atenção")
		If lCancela
			oDlg:End()
			lRetor := .T.
			lSair  := .T.
		Else
			lRetor := .F.
		EndIf
	EndIf
	
	Return(lRetor)
	
	
	//+-----------------------------------------------------------------------------------//
	//|Funcao....: GeraCSV()
	//|Descricao.: Gera Arquivo CSV
	//|Observação:
	//+-----------------------------------------------------------------------------------//
	*-----------------------------------------*
	Static Function GeraCSV()
	*-----------------------------------------*
	
	cArqTxt := Alltrim(cDir)+Alltrim(cArq)+".csv"
	nHdl    := fCreate(cArqTxt)
	
	cEOL    := "CHR(13)+CHR(10)"
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
	
	Processa({|| RunCont() },"Processando...")
	
	fClose(nHdl)
	
	Return
	
	//+-----------------------------------------------------------------------------------//
	//|Funcao....: RunCont()
	//|Descricao.: Chama função para gerar CSV
	//|Observação:
	//+-----------------------------------------------------------------------------------//
	*-----------------------------------------*
	Static Function RunCont()
	*-----------------------------------------*
	
	Local nTamLin, cLin, cCpo
	Local nFlag := 0, nTotReais:=0
	Local nTotUSD:=0, nTotYEN:=0, nTotEUR:=0
	Local nTXUSD :=0, nTxYEN :=0, nTxEUR :=0
	Local nInd
	
	//cCamposCSV := "Filial;Dta Proc;No. Processo;Nome Exportador;Dt Ent NF Almox;No. NF Entr.;NCM;"
    cCamposCSV := "Filial;No. Processo;Nome Exportador;Dt Ent NF Almox;No. NF Entr.;NCM;"
	cCamposCSV +="Quantidade;Un;Codigo Prod;Grupo;Descrição Produto;Moeda;Tx Moeda;Vlr Unit Moe;Vlr Tot Moe;"
	cCamposCSV +="Vlr Unit Nac;Vlr Tot Nac"
	
	cMsg := "Relatorio gerado com sucesso!"+CHR(13)+CHR(10)
	cMsg += "O arquivo "+Alltrim(cArq)+".csv"+" se encontra no diretório "+Alltrim(cDir)
	
	nTamLin := 2
	cLin    := Space(nTamLin)+cEOL
	
	ProcRegua(RecCount("TRB2"))
	
	TRB2->(dbgotop())
	
	cTitRel:=";;;;;;;;;;;;;DATE;"+DTOC(dDataBase)+cEOL
	fWrite(nHdl,cTitRel,Len(cTitRel))
	fWrite(nHdl,cLin,Len(cLin))
	fWrite(nHdl,cLin,Len(cLin))
	
	//cTitRel:=";EXCHANGE RATES"+cEOL
	//fWrite(nHdl,cTitRel,Len(cTitRel))
	//fWrite(nHdl,cLin,Len(cLin))
	
	//nTxUSD:=BuscaTaxa("US$",dDataBase,.T.,.F.,.T.)
	//nTxYEN:=BuscaTaxa("JPY",dDataBase,.T.,.F.,.T.)
	//nTxEUR:=BuscaTaxa("EUR",dDataBase,.T.,.F.,.T.)
	
	//cTitRel:="US$; "+TRANS(nTxUSD,'@E 999,999.99999999')+cEOL
	//fWrite(nHdl,cTitRel,Len(cTitRel))
	
	//cTitRel:="YEN; "+TRANS(nTxYEN,'@E 999,999.99999999')+cEOL
	//fWrite(nHdl,cTitRel,Len(cTitRel))
	
	//cTitRel:="EUR; "+TRANS(nTXEUR,'@E 999,999.99999999')+cEOL
	//fWrite(nHdl,cTitRel,Len(cTitRel))
	//fWrite(nHdl,cLin,Len(cLin))
	
	cTitRel:=";;;;;"+cRel+" - Filial De: "+MV_PAR01+" Até "+ MV_PAR02 + " - Dta Ent. Almoxarifado De: "+DTOC(MV_PAR03)+" Até "+ DTOC(MV_PAR04)+cEOL
	fWrite(nHdl,cTitRel,Len(cTitRel))
	fWrite(nHdl,cLin,Len(cLin))
	fWrite(nHdl,cLin,Len(cLin))
	
	cLin := Stuff(cLin,01,02,cCamposCSV)
	fWrite(nHdl,cLin,Len(cLin))
	
	TRB2->(DBGOTOP())
	While ! TRB2->(EOF())
		IncProc("Gerando arquivo CSV")
		
		nTamLin := 2
		cLin    := Space(nTamLin)+cEOL
		cDadosCSV := ""
		
		For nInd := 1 To TRB2->(fCount())
			cCpoDest := TRB2->(FieldName(nInd))
			If TRB2->(FieldPos(cCpoDest)) > 0
				
				cValor:=TRB2->(FieldGet(FieldPos(cCpoDest)))
				If cCpoDest $ "DTNFEMP" //$ "DTNFEMP,DTPROC"
					cValor:= DtoC(TRB2->(&cCpoDest))
				Endif
				
				If ValType(TRB2->(&cCpoDest)) == "N"
					
					Do Case
						Case cCpoDest == "QTDE"
							cPict:= "@E 999,999.999"
						Case cCpoDest == "TXMOE"
							cPict:= "@E 9.99999999"
						Case cCpoDest == "VALUNIM"
							cPict:= "@E 99,999,999.9999"
						Case cCpoDest == "VALTOTM"
							cPict:= "@E 99,999,999.9999"
						Case cCpoDest == "VALUNIN"
							cPict:= "@E 99,999,999.99"
						Case cCpoDest == "VALTOTN"
							cPict:= "@E 99,999,999.99"
					EndCase
					
					
					cDadosCSV += TRANSFORM(cValor,cPict)+Iif(nInd = TRB2->(fCount()),"",";")
				Else
					cDadosCSV+= " "+cValor+Iif(nInd = TRB2->(fCount()),"",";")
				EndIf
				
			EndIf
		Next
		
		cLin := Stuff(cLin,01,02,cDadosCSV)
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo nos Itens. Continua?","Atencao!")
				lTudOk := .F.
				Exit
			Endif
		Endif
		
		nTotReais+=TRB2->VALTOTN
		
		Do Case
			Case TRB2->MOED == "US$"
				nTotUSD += TRB2->VALTOTM
			Case TRB2->MOED == "JPY"
				nTotYEN += TRB2->VALTOTM
			Case TRB2->MOED == "EUR"
				nTotEUR += TRB2->VALTOTM
		EndCase
		
		TRB2->(dbSkip())
		
	EndDo
	
	If lTudOk
		cLin := Space(nTamLin)+cEOL
		fWrite(nHdl,cLin,Len(cLin))
		fWrite(nHdl,cLin,Len(cLin))
		fWrite(nHdl,cLin,Len(cLin))
		cTitRel:=";; TOTAL IN US$;"+TRANS(nTotUSD,AvSx3("W9_FOB_TOT",6))//+cEOL
		fWrite(nHdl,cTitRel,Len(cTitRel))
		fWrite(nHdl,cLin,Len(cLin))
		cTitRel:=""
		cTitRel+=";; TOTAL IN YEN;"+TRANS(nTotYEN,AvSx3("W9_FOB_TOT",6))
		fWrite(nHdl,cTitRel,Len(cTitRel))
		fWrite(nHdl,cLin,Len(cLin))
		cTitRel:=""
		cTitRel+=";; TOTAL IN EUR;"+TRANS(nTotEUR,AvSx3("W9_FOB_TOT",6))
		fWrite(nHdl,cTitRel,Len(cTitRel))
		fWrite(nHdl,cLin,Len(cLin))
		cTitRel:=""
		cTitRel+=";; TOTAL IN REAL;"+TRANS(nTotReais,AvSx3("W9_FOB_TOT",6))+cEOL
		fWrite(nHdl,cTitRel,Len(cTitRel))
		fWrite(nHdl,cLin,Len(cLin))
	Endif
	
	Return
	
	//+-----------------------------------------------------------------------------------//
	//|Funcao....: AchaNfes()
	//|Descricao.: Verifica as Notas de Entrada do processo
	//|Observação:
	//+-----------------------------------------------------------------------------------//
	*-----------------------------------------*
	Static Function AchaNfes()
	*-----------------------------------------*
	
	Local cSql  := ""
	cNFes       := ""
	
	cSQL+=" SELECT SWN.WN_DOC, SWN.WN_SERIE, SWN.WN_FILIAL, SWN.WN_FORNECE, SWN.WN_LOJA "
	cSQL+=" FROM "+RETSQLNAME("SWN")+" SWN "
	cSQL+=" WHERE SWN.WN_FILIAL  = '"+TRB2->FILIAL+"' AND "
	cSQL+="       SWN.WN_HAWB    = '"+SW7->W7_HAWB+"' AND "
	cSQL+="       SWN.WN_PRODUTO = '"+SW7->W7_COD_I+"' AND "
	cSQL+="       SWN.WN_ITEM    = '"+SW7->W7_POSICAO+"' AND "
	cSQL+="       SWN.WN_TIPO_NF = '1' AND "
	cSQL+="       SWN.D_E_L_E_T_ = '' "
	
	TcQuery cSql New Alias "SQLWN"
	
	SQLWN->(dbgotop())
	
	dDtaEntrF1 := CtoD("  /  /  ")
	cStatus := Posicione("SF1",1,TRB2->FILIAL+SQLWN->WN_DOC+SQLWN->WN_SERIE,"F1_STATUS")
	If cStatus == "A"
		cNfes      := SQLWN->WN_DOC //Posicione("SF1",1,TRB2->FILIAL+SQLWN->WN_DOC+SQLWN->WN_SERIE,"F1_DOC")
		dDtaEntrF1 := Posicione("SF1",1,TRB2->FILIAL+SQLWN->WN_DOC+SQLWN->WN_SERIE,"F1_DTDIGIT")
	ENDIF
	
	SQLWN->(E_EraseArq("SQLWN"))
	
	Return(cNFes) 		