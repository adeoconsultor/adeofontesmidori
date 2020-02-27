#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RelNovoMapa³Autor ³ Luiz Fernando        ³ Data ³ 29.08.10  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório Novo Mapa de Importações                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ RelNovoMapa                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gera Planilha Excel                  		               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/
user Function RelNovoMapa()

Local   aPergs 	  := {}
Local   nTpRel    := 2
Private bFileFat  :={|| cDir:=ChoseMapDir(),If(Empty(cDir),cDir:=Space(200),Nil)}
Private oDlg      := Nil
Private cArq      := Space(10), cRel:="Relatorio Novo Mapa de Importacao"
Private cDir      := Space(250)
Private cPerg     := ""
Private aArea     := GetArea()
Private lRetor    := .T.
Private lSair     := .F.
Private lTudOk    := .T.
Private aStru     := {}
private cArqTrb2  := CriaTrab(NIL,.F.)
Private cCamposCSV:= ""
Private cDadosCSV := ""
Private cMsg      := ""
Private cArqTxt   := ""
Private dDtaEntrF1:= CtoD("  /  /  ")
Private cNfes     := ""
Private nValNFE   := 0
Private _cSW5_Hawb:= ""
Private cW5Qtd := 0

Private _nAliqII  := 0
Private	_nValII   := 0
Private _nAliqIPI := 0
Private _nValIPI  := 0
Private _nAliqPIS := 0
Private _nValPIS  := 0
Private _nAliqCOF := 0
Private _nValCOF  := 0
Private _nAliqICMS:= 0
Private _nValICMS := 0

lEnd := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cPerg := Avkey("RELMAP","X1_GRUPO")

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

Processa({||GEREXCEL()},"Gerando Relatorio Novo Mapa ") //+cRel+' ...')

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
//³ mv_par03             // Data Processo de:                    ³
//³ mv_par04             // Data Processo Ate:                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function GEREXCEL()

// monta arquivo analitico

aAdd(aStru,{"FILIAL"  ,"C",02,0})  // Filial Midori
aAdd(aStru,{"GRUPO"   ,"C",04,0})
aAdd(aStru,{"REFCLI"  ,"C",20,0})  // Refetencia do Cliente no PO
aAdd(aStru,{"PROCESS" ,"C",15,0})  // nº Processo Embarque
aAdd(aStru,{"DTPO"    ,"D",08,0})  // Data do PO
aAdd(aStru,{"MESPO"    ,"C",2,0})  // Mes PO
aAdd(aStru,{"NRPO"    ,"C",15,0})  // nº do PO
aAdd(aStru,{"NEXPORT" ,"C",30,0})  // Nome do exportador/Fornecedor
aAdd(aStru,{"PAISORI" ,"C",25,0})  // Nome do Pais de Origem
aAdd(aStru,{"QTDEPO"  ,"N",11,3})  // Quantidade Solicitada no PO
aAdd(aStru,{"CODPRO"  ,"C",15,0})  // Codigo do Produto Comprado
aAdd(aStru,{"UNIDADE" ,"C",04,0})  // unidade de medida
aAdd(aStru,{"DESCPRO" ,"C",30,0})  // Descrição do produto em Ingles
aAdd(aStru,{"NRINV"   ,"C",15,0})  // Numero da Invoice
aAdd(aStru,{"INCOTERM","C",03,0})  // Incoterm
aAdd(aStru,{"DTINV"   ,"D",08,0})  // Data de Invoice
aAdd(aStru,{"MOED"    ,"C",03,0})  // Moeda de importação
aAdd(aStru,{"VALUNIM" ,"N",16,4})  // Valor unitário do item de importação em moeda estrangeira
aAdd(aStru,{"VALTTIM" ,"N",16,4})  // Valor Total do item de importação em moeda estrangeira
aAdd(aStru,{"CONDPAG" ,"C",05,0})  // Condicao de Pagamento Numero
aAdd(aStru,{"NRDI"    ,"C",10,0})  // Numero da DI
aAdd(aStru,{"DTDI"    ,"D",08,0})  // Data de Registro DI
aAdd(aStru,{"NDESP"   ,"C",40,0})  // Nome Despachante
aAdd(aStru,{"REFDESP" ,"C",10,0})  // Referencia do Despachante
aAdd(aStru,{"VIATRAN" ,"C",30,0})  // Descricao da Via de Transporte
aAdd(aStru,{"NRBL"    ,"C",16,0})  // Numero do BL / AWB / HAWB
aAdd(aStru,{"DTETD"   ,"D",08,0})  // Data de ETD
aAdd(aStru,{"DTETA"   ,"D",08,0})  // Data de ETA
aAdd(aStru,{"DTEMB"   ,"D",08,0})  // Data Efetiva do Embarque
aAdd(aStru,{"LOCENT"  ,"C",10,0})  // Descricao Local de Entrega / Destino
aAdd(aStru,{"NRNFE"   ,"C",09,0})  // Numero nota fiscal de entrada
aAdd(aStru,{"VLRNFE"  ,"N",14,2})  // Valor total da nota de entrada
aAdd(aStru,{"DTNFEMP" ,"D",08,0})  // Data de entrada da nota fiscal na empresa
aAdd(aStru,{"NRNFCOM" ,"C",09,0})  // Numero nota fiscal de entrada // W6_NF_COMP
aAdd(aStru,{"VLNFCOM" ,"N",14,2})  // Valor total da nota de entrada // W6_VL_NFC
aAdd(aStru,{"DTNFCOM" ,"D",08,0})  // Data emissao da nota fiscal // Posicione SWN- ACHAR DATA
aAdd(aStru,{"DTVCAMB" ,"D",08,0})  // Data Vencimento do Cambio
aAdd(aStru,{"MESCAMB" ,"C",02,0})  // Mes Vencimento Cambio
aAdd(aStru,{"TXMOE"	  ,"N",08,5})  // Taxa Fechamento Cambio
aAdd(aStru,{"NRCAMB"  ,"C",10,0})  // Numero do Contrato de Cambio
aAdd(aStru,{"DPGCAMB" ,"D",08,0})  // Data Pagamento do Cambio

************** Novas Informações - 03/09/2010
aAdd(aStru,{"AGCARG"  ,"C",40,0}) // Ag. Carga    - (Puxar do PO) // W2_AGENTE - Y4_NOME
aAdd(aStru,{"ALIQII"  ,"N",06,2}) // Aliquota II  - (Puxar do desembaraço)
aAdd(aStru,{"VLII" 	  ,"N",16,4}) // Valor do II  - (Puxar do desembaraço)
aAdd(aStru,{"ALIQIPI" ,"N",06,2}) // Aliquoto IPI - (Puxar do desembaraço)
aAdd(aStru,{"VLIPI"   ,"N",16,4}) // Valor IPI    - (Puxar do desembaraço)
aAdd(aStru,{"ALIQPIS" ,"N",06,2}) // Aliquota PIS - (Puxar do desembaraço)
aAdd(aStru,{"VLPIS"	  ,"N",16,4}) // Valor PIS    - (Puxar do desembaraço)
aAdd(aStru,{"ALIQCOF" ,"N",06,2}) // Aliquota COF - (Puxar do desembaraço)
aAdd(aStru,{"VLCOF"   ,"N",16,4}) // Valor COF    - (Puxar do desembaraço)
aAdd(aStru,{"ALIQICMS","N",06,2}) // Aliquota ICMS- (Puxar do desembaraço)
aAdd(aStru,{"VLICMS"  ,"N",16,4}) // Valor ICMS   - (Puxar do desembaraço)
aAdd(aStru,{"CCUSTO"  ,"C",20,0}) // Centro Custo - (Puxar da SC) // W0__CC - Y3_DESC
aAdd(aStru,{"NCM" 	  ,"C",10,0}) // Nr. NCSM     - (Puxar do PO) // W3_TEC
aAdd(aStru,{"NFABR"   ,"C",30,0}) // Nome Fabr    - (Puxar do PO)
aAdd(aStru,{"FORW"    ,"C",30,0}) // Nme Forwar   - (Puxar do PO)
aAdd(aStru,{"MOESEG"  ,"C",03,0}) // Moeda Segur  - (Puxar do PO)
aAdd(aStru,{"VLRSEG"  ,"N",15,2}) // Valor Seguro - (Puxar do PO)
aAdd(aStru,{"TXSEG"	  ,"N",08,5}) // Taxa Segur   - (Puxar do desembaraço)
aAdd(aStru,{"TXDI"	  ,"N",08,5}) // Taxa DI      - (Puxar do desembaraço)
aAdd(aStru,{"NRSC" 	  ,"C",06,0}) // Numero SC    - (Puxar da SC) // W0_C1_NUM
aAdd(aStru,{"DTSC"    ,"D",08,0}) // Dta SC       - (Puxar da SC) // W0_DT
aAdd(aStru,{"DTNESC"  ,"D",08,0}) // Dta Necess SC- (Puxar da SC) // W1_DTENTR_
aAdd(aStru,{"PLQ" 	  ,"N",15,8}) // Peso Liquido - (Puxar do desembraço) // W7_PESO
aAdd(aStru,{"PBR" 	  ,"N",17,8}) // Peso Bruto   - (Puxar do desembaraço)// W7_PESO*W7_QTDE
aAdd(aStru,{"PORTDEST","C",20,0}) // PORT/AER DEST- (Puxar do PO) - BuscaTudo("SYR",SW2->W2_TIPO_EMB+SW2->W2_ORIGEM+SW2->W2_DEST,"YR_DESTINO")
aAdd(aStru,{"MOEFRE"  ,"C",03,0}) // Moeda Frete  - (Puxar do PO)
aAdd(aStru,{"TXFRE"	  ,"N",08,5}) // Taxa Frete   - (Puxar do desembaraço)
aAdd(aStru,{"FREPP"   ,"N",15,2}) // Valor Fret PP- (Puxar do desembaraço) // W6_VLFREEPP
aAdd(aStru,{"FRECC"   ,"N",15,2}) // Valor Fret CC- (Puxar do desembaraço) // W6_VLFREEPP
aAdd(aStru,{"FREMN"   ,"N",15,2}) // Val Fret Nac - (Puxar do desembaraço) // W6_VLFRETN
aAdd(aStru,{"VLRINVPO","N",15,2}) // Valor Fob PO - (Puxar do PO) // W2_FOB_TOT

aAdd(aStru,{"NRCONT"  ,"C",15,0}) // Num Contain  - (Puxar do controle de container) // JD_CONTAIN
aAdd(aStru,{"QTD20"   ,"N",04,0}) // Qtd Cont 20  - (Puxar do controle de container) // W6_CONTA20
aAdd(aStru,{"QTD40"   ,"N",04,0}) // Qtd Cont 40  - (Puxar do controle de container) // W6_CONTA40
aAdd(aStru,{"QTD40H"  ,"N",04,0}) // Qtd Cont 40HC- (Puxar do controle de container) // W6_CONTA40HC
aAdd(aStru,{"QTDOUT"  ,"N",04,0}) // Qtd Cont Outr- (Puxar do controle de container) // W6_OUTROS
aAdd(aStru,{"NRLCR"	  ,"C",15,0}) // Numero Lacre - (Puxar do controle de container) // JD_LACRE

aAdd(aStru,{"FIM" 	  ,"C",01,0})  // Fim

dbcreate(cArqTrb2,aStru)
dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)
index on FILIAL+DtoS(DTPO)+PROCESS to &(cArqTrb2+"1")

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

cAliasSW3:="SW3"
dbSelectArea("SW3")
cIndex := CriaTrab("",.F.)
cKey := 'W3_FILIAL+W3_PO_NUM'

cCondicao := 'W3_FILIAL>="'+mv_par01+'".And.W3_FILIAL<="'+mv_par02+'"'
//cCondicao += '.AND. W3_SEQ = 1'
//cCondicao += '.OR. W3_SEQ = 0 .AND. W3_SALDO_Q <> 0'

IndRegua("SW3",cIndex,cKey,,cCondicao)

dbSelectArea("SW3")

#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#ENDIF

dbGoTop()
ProcRegua(LastRec())

cAliasSW5:="SW5"
dbSelectArea("SW5")
cIndex := CriaTrab("",.F.)
cKey := 'W5_FILIAL+W5_PGI_NUM+W5_PO_NUM+W5_POSICAO'

cCondicao := 'W5_FILIAL>="'+mv_par01+'".And.W5_FILIAL<="'+mv_par02+'"'
//cCondicao += '.AND. W5_SEQ >= 1'

IndRegua("SW5",cIndex,cKey,,cCondicao)

nIndex := RetIndex("SW5")

dbSelectArea("SW5")

#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#ENDIF

dbSelectArea("SW5")
dbSetOrder(nIndex+1)

dbGoTop()
ProcRegua(LastRec())

cAliasSW2:="SW2"
dbSelectArea("SW2")
cIndex := CriaTrab("",.F.)
cKey := 'W2_FILIAL+DtoS(W2_PO_DT)'

cCondicao := 'W2_FILIAL>="'+mv_par01+'".And.W2_FILIAL<="'+mv_par02+'"'
cCondicao += '.And.DTOS(W2_PO_DT)>="'+DTOS(mv_par03)+'".And.DTOS(W2_PO_DT)<="'+DTOS(mv_par04)+'"'

IndRegua("SW2",cIndex,cKey,,cCondicao)

dbSelectArea("SW2")

#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#ENDIF

dbGoTop()
ProcRegua(LastRec())

While !Eof()
	
	dbSelectArea("SW2")
	_cPONum := SW2->W2_PO_NUM

	DbselectArea("SW3")
	//Set Filter to SW3->W3_SEQ == 1
	DbSeek(SW2->W2_FILIAL+_cPONum)
	
	_FlagW3 := .F.
	
	If !Eof()
		
		_FlagW3 := .T.
		
		While SW3->W3_FILIAL == SW2->W2_FILIAL .AND. SW3->W3_PO_NUM == _cPONum .and. !Eof()
			
			If SW3->W3_SEQ == 0  .AND. SW3->W3_FLUXO == "7"
				DbSkip()
				Loop
			Endif
			*** Alteração 16/12/10
			If SW3->W3_SEQ == 0  .AND. SW3->W3_FLUXO == "1" .AND. SW3->W3_SALDO_Q == 0
				DbSkip()
				Loop
			Endif

			
			_nAliqII  := 0
			_nValII   := 0
			_nAliqIPI := 0
			_nValIPI  := 0
			_nAliqPIS := 0
			_nValPIS  := 0
			_nAliqCOF := 0
			_nValCOF  := 0
			_nAliqICMS:= 0
			_nValICMS := 0
			nValNFE   := 0
			
			IncProc("PO: "+Alltrim(_cPONum)+" Prod: "+AllTrim(SW3->W3_COD_I))
			
			DbSelectArea("SW5")
			DbSetOrder(8)
			DbSeek(SW2->W2_FILIAL+SW3->W3_PGI_NUM+_cPONum+SW3->W3_POSICAO)
			
			_FlagW5 := .F.
			
			_cSW5_Hawb:= ""
			
			If !Eof()
				
				_FlagW5 := .T.
				
				While SW5->W5_FILIAL == SW2->W2_FILIAL .AND. SW5->W5_PGI_NUM == SW3->W3_PGI_NUM .and. SW5->W5_PO_NUM == _cPONum .and. SW5->W5_POSICAO == SW3->W3_POSICAO
					
					IncProc("PO: "+Alltrim(_cPONum)+" Prod: "+AllTrim(SW5->W5_COD_I))
					
					If SW5->W5_SALDO_Q != 0 .and. SW5->W5_SEQ == 0
						cW5Qtd := SW5->W5_SALDO_Q
					Endif
					
					If SW5->W5_SALDO_Q == 0 .and. SW5->W5_SEQ == 0
						DbSkip()
						Loop
					Endif
					
					If SW5->W5_SALDO_Q == 0 .and. SW5->W5_SEQ != 0
						cW5Qtd := SW5->W5_QTDE
					Endif
					
					_cSW5_Hawb := SW5->W5_HAWB //Posicione("SW5",8,SW2->W2_FILIAL+SW3->W3_PGI_NUM+SW3->W3_PO_NUM+SW3->W3_POSICAO,"W5_HAWB")
					
					**********
					GravaTrb2()
					**********
					
					
					
					DbSelectArea("SW5")
					DbSkip()
					
				Enddo
				
			Endif
			
			If _FlagW3 .and. !_FlagW5
				cW5Qtd := SW3->W3_QTDE
				**********
				GravaTrb2()
				**********
				
				
			Endif
			
			DbSelectArea("SW3")
			DbSkip()
			
		Enddo
	Endif
	
	dbSelectArea("SW2")
	dbSkip()
	
Enddo
//Set Filter to

GeraExcel()

DbSelectArea("SW2")
Set Filter To
DbSetOrder(1)

DbSelectArea("SW3")
Set Filter To
DbSetOrder(1)

DbSelectArea("SW5")
Set Filter To
DbSetOrder(1)


RestArea(aArea)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraExcel ºAutor  ³Luiz                º Data ³  29/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Arquivo em Excel e abre                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function GeraExcel()

MsAguarde({||GeraCSV()},"Aguarde","Gerando Planilha Relatorio Novo Mapa de Importações",.F.)

return .T.

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

aAdd(aRegs,{cPerg,"01","Filial De"         ,"","","mv_ch1","C",02,0,0,"G","U_ValPergNov ('01')","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
aAdd(aRegs,{cPerg,"02","Filial Ate"        ,"","","mv_ch2","C",02,0,0,"G","U_ValPergNov ('02')","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
aAdd(aRegs,{cPerg,"03","Data Processo De " ,"","","mv_ch3","D",08,0,0,"G","U_ValPergNov ('03')","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""  ,"","","","@D",""})
aAdd(aRegs,{cPerg,"04","Data Processo Ate" ,"","","mv_ch4","D",08,0,0,"G","U_ValPergNov ('04')","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""  ,"","","","@D",""})

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
//|Funcao....: U_ValPergNov()
//|Descricao.: Valida datas informadas nas perguntas
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function ValPergNov(cMV)
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
			Aviso( cTitulo, "Data do Processo Inicial deve ser informada", {"Ok"} )
			cRet:=.F.
		Endif
		
		If !Empty(MV_PAR04) .AND. MV_PAR03 > MV_PAR04
			Aviso( cTitulo, "Data do Processo Inicial não pode ser maior que a Final", {"Ok"} )
			cRet := .F.
		EndIf
	Case cMV == '04'
		
		If Empty(MV_PAR04)
			Aviso( cTitulo, "Data do Processo Final deve ser informada", {"Ok"} )
			cRet:=.F.
		Endif
		
		If !Empty(MV_PAR03) .AND. MV_PAR03 > MV_PAR04
			Aviso( cTitulo, "Data do Processo Final não pode ser menor que a Inicial", {"Ok"} )
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
	
	cCamposCSV := "FILIAL;GRUPO;REF CLI;EMBARQUE;DTA PO;MES;PO;EXPORTADOR;ORIGEM;QUATIDADE;COD PRODUTO;UN;DESCRICAO;N.INVOICE;INCOTERMS;DT INVOICE;MOEDA;VLR UNI FOB;VLR TOT FOB;COND PGTO;N.DI;DT REG DI;"
	cCamposCSV +="DESPACHANTE;REF DESPACHANTE;MODAL;No. BL / AWB / HAWB;ETD;ETA;EMBARQUE;DESTINO;N.NFE;VRL NFE;NF EMISSAO;NFE COMP;VRL NFE COMP;DT COMP;"
	cCamposCSV +="VNCTO CAMBIO;MES CAMBIO;TX CAMBIO;No. CONTRADO;DT PGTO CAMBIO;AGENTE;% II;VR II;% IPI;VR IPI;% PIS;VR PIS;% COF;VR COF;% ICMS;VR ICMS;"
	cCamposCSV +="C.CUSTO;NCM;FABR;FORWAR;MOED SEG;VR SEG;TX SEG;TX DI;NR SC;DT SC;DT SOLIC SC;P.LIQ;P.BR;PORT/AER DEST;MOE FRE;TX M.FRE;VR FRE PP;VR FRE CC;VR FRE NAC;"
	cCamposCSV +="VR FOB PO;NR CONTAINER; QTD 20;QTD 40;QTD 40HC;QTD OUT;NR LACRE"
	
	
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
	
	cTitRel:=";;;;;"+cRel+" - Filial De: "+MV_PAR01+" Até "+ MV_PAR02 + " - Data Processo De: "+DTOC(MV_PAR03)+" Até "+ DTOC(MV_PAR04)+cEOL
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
				If cCpoDest $ "DTPO,DTETD,DTETA,DTEMB,DTNFEMP,DTVCAMB,DPGCAMB,DTINV,DTSC,DTNESC,DTNFCOM,DTDI"
					cValor:= DtoC(TRB2->(&cCpoDest))
				Endif
				
				If ValType(TRB2->(&cCpoDest)) == "N"
					Do Case
						Case cCpoDest $ "QTDEPO,QTD020,QTD040,QTD040H,QTDOUT"
							cPict:= "@E 999,999.999"
						Case cCpoDest $ "PLQ,PBR"
							cPict:= "@E 9999,999.999999"
							//cPict:=	AvSx3("W7_PESO",6)
							//cValor:=TRANS(cValor,cPict)
						Case cCpoDest $ "TXMOE,TXSEG,TXDI,TXFRE"
							cPict:= "@E 99.99999"
						Case cCpoDest $ "VALUNIM,VLRNFE,VLNFCOM,VLII,VLIPI,VLPIS,VLCOF,VLICM,VLRSEG,VLRINVPO,FREPP,FREMN"
							cPict:= "@E 99,999,999.99"
						Case cCpoDest == "VALTTIM"
							cPict:= "@E 99,999,999.99"
					EndCase
					cDadosCSV += TRANSFORM(cValor,cPict)+Iif(nInd = TRB2->(fCount()),"",";")
				Else
					If cCpoDest $ "NRDI"
						cPict:= AvSx3("W6_DI_NUM",6)
						cValor:=TRANS(cValor,cPict)
					Endif
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
		
		//nTotReais+=TRB2->VALTOTN
		
		Do Case
			Case TRB2->MOED == "US$"
				nTotUSD += TRB2->VALTTIM
			Case TRB2->MOED == "JPY"
				nTotYEN += TRB2->VALTTIM
			Case TRB2->MOED == "EUR"
				nTotEUR += TRB2->VALTTIM
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
		//cTitRel:=""
		//cTitRel+=";; TOTAL IN REAL;"+TRANS(nTotReais,AvSx3("W9_FOB_TOT",6))+cEOL
		//fWrite(nHdl,cTitRel,Len(cTitRel))
		//fWrite(nHdl,cLin,Len(cLin))
	Endif
	
	Return
	
	//+-----------------------------------------------------------------------------------//
	//|Funcao....: AchaNfesMapa()
	//|Descricao.: Verifica as Notas de Entrada do processo
	//|Observação:
	//+-----------------------------------------------------------------------------------//
	
	*-----------------------------------------*
	Static Function AchaNfesMapa()
	*-----------------------------------------*
	
	Local cSql  := ""
	cNFes       := ""
	
	cSQL+=" SELECT SWN.WN_DOC, SWN.WN_SERIE, SWN.WN_FILIAL, SWN.WN_FORNECE, SWN.WN_LOJA "
	cSQL+=" FROM "+RETSQLNAME("SWN")+" SWN "
	cSQL+=" WHERE SWN.WN_FILIAL  = '"+TRB2->FILIAL+"' AND "
	cSQL+="       SWN.WN_HAWB    = '"+_cSW5_Hawb+"' AND "
	cSQL+="       SWN.WN_PRODUTO = '"+SW3->W3_COD_I+"' AND "
	cSQL+="       SWN.WN_ITEM    = '"+SW3->W3_POSICAO+"' AND "
	cSQL+="       SWN.WN_TIPO_NF = '1' AND "
	cSQL+="       SWN.D_E_L_E_T_ = '' "
	
	if Select('SQLWN') > 0 
		dbSelectArea('SQLWN')
		SQLWN->(dbCloseArea())
	endif

	TcQuery cSql New Alias "SQLWN"
	
	SQLWN->(dbgotop())
	
	dDtaEntrF1 := CtoD("  /  /  ")                                         
	
	cStatus := Posicione("SF1",1,TRB2->FILIAL+SQLWN->WN_DOC+SQLWN->WN_SERIE,"F1_STATUS")
	If cStatus == "A"
		cNfes      := SQLWN->WN_DOC
		dDtaEntrF1 := Posicione("SF1",1,TRB2->FILIAL+SQLWN->WN_DOC+SQLWN->WN_SERIE+SQLWN->WN_FORNECE,"F1_EMISSAO")
		//nValNFE   :=  Posicione("SF1",1,TRB2->FILIAL+SQLWN->WN_DOC+SQLWN->WN_SERIE,"F1_VALMERC")
		
	ENDIF
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Bloco implementado por Anesio para tratar NFs que tem problemas no EIC e nao sao localizadas nos docs de entrada SF1
//Data da Implementacao: 22/11/2012
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	if len(cNfes) <> 9
		if Select('TMPF1') > 0 
			dbSelectArea('TMPF1')
			TMPF1->(dbCloseArea())
		endif

		cQSF1T := " SELECT F1_DOC, F1_EMISSAO, F1_STATUS FROM SF1010 WHERE D_E_L_E_T_ = ' ' AND F1_FILIAL = '"+TRB2->FILIAL+"' AND SUBSTRING(F1_EMISSAO,1,4)= '"+Substr(DTOS(TRB2->DTPO),1,4)+"' "
		cQSF1T += " AND F1_HAWB = '"+_cSW5_Hawb+"' AND F1_TIPO = 'N' " 
		dbUseArea(.T., "TOPCONN", tcGenQry(, , cQSF1T), 'TMPF1',.T.,.T.) 
		
		dbSelectArea('TMPF1')
		TMPF1->(dbGotop())
		
		cNfes := TMPF1->F1_DOC
		if TMPF1->F1_STATUS == 'A'
			dDtaEntrF1 := sTod(TMPF1->F1_EMISSAO)
		endif
	
		if len(cNfes) <> 9 .or. cNfes == space(9)
				if Select('TMPF1') > 0 
					dbSelectArea('TMPF1')
					TMPF1->(dbCloseArea())
				endif
			cQSF1T := " SELECT F1_DOC, F1_EMISSAO, F1_STATUS FROM SF1010 WHERE D_E_L_E_T_ = ' ' AND F1_FILIAL = '"+TRB2->FILIAL+"' AND SUBSTRING(F1_EMISSAO,1,4)= '"+Substr(DTOS(TRB2->DTEMB),1,4)+"' "
			cQSF1T += " AND F1_HAWB = '"+_cSW5_Hawb+"' AND F1_TIPO = 'N' " 
			dbUseArea(.T., "TOPCONN", tcGenQry(, , cQSF1T), 'TMPF1',.T.,.T.) 
		
			dbSelectArea('TMPF1')
			TMPF1->(dbGotop())
	
			cNfes := TMPF1->F1_DOC
			if TMPF1->F1_STATUS == 'A'
				dDtaEntrF1 := sTod(TMPF1->F1_EMISSAO)
			endif
		endif
	endif
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Final do bloco implementado por Anesio.....anesio@anesio.com.br
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



	_nAliqII  := Posicione("SWN",1,TRB2->FILIAL+SQLWN->WN_DOC+SQLWN->WN_SERIE,"WN_IITX")
	_nValII   := Posicione("SWN",1,TRB2->FILIAL+SQLWN->WN_DOC+SQLWN->WN_SERIE,"WN_IIVAL")
	_nAliqIPI := Posicione("SWN",1,TRB2->FILIAL+SQLWN->WN_DOC+SQLWN->WN_SERIE,"WN_IPITX")
	_nValIPI  := Posicione("SWN",1,TRB2->FILIAL+SQLWN->WN_DOC+SQLWN->WN_SERIE,"WN_IPIVAL")
	_nAliqPIS := Posicione("SWN",1,TRB2->FILIAL+SQLWN->WN_DOC+SQLWN->WN_SERIE,"WN_PERPIS")
	_nValPIS  := Posicione("SWN",1,TRB2->FILIAL+SQLWN->WN_DOC+SQLWN->WN_SERIE,"WN_VLRPIS")
	_nAliqCOF := Posicione("SWN",1,TRB2->FILIAL+SQLWN->WN_DOC+SQLWN->WN_SERIE,"WN_PERCOF")
	_nValCOF  := Posicione("SWN",1,TRB2->FILIAL+SQLWN->WN_DOC+SQLWN->WN_SERIE,"WN_VLRCOF")
	_nAliqICMS:= Posicione("SWN",1,TRB2->FILIAL+SQLWN->WN_DOC+SQLWN->WN_SERIE,"WN_ICMS_A")
	_nValICMS := Posicione("SWN",1,TRB2->FILIAL+SQLWN->WN_DOC+SQLWN->WN_SERIE,"WN_VALICM")
	
	SQLWN->(E_EraseArq("SQLWN"))
	
	Return(cNFes)
	
	Static Function GravaTrb2()
	DbSelectArea("TRB2")
	RecLock("TRB2",.T.)
	
	_cSW8_INV  := Posicione("SW8",3,SW2->W2_FILIAL+_cSW5_Hawb+SW3->W3_PGI_NUM+SW3->W3_PO_NUM+SW3->W3_SI_NUM+SW3->W3_CC+SW3->W3_COD_I,"W8_INVOICE")
	_cSW8_DTA  := Posicione("SW8",3,SW2->W2_FILIAL+_cSW5_Hawb+SW3->W3_PGI_NUM+SW3->W3_PO_NUM+SW3->W3_SI_NUM+SW3->W3_CC+SW3->W3_COD_I,"W8_DT_EMIS")
	
	TRB2->FILIAL	:= SW2->W2_FILIAL   											// Filial Midori
	TRB2->GRUPO	 	:= Posicione("SB1",1,xFilial("SB1")+SW3->W3_COD_I,"B1_GRUPO")   // Grupo do produto - inserido por Anesio
	TRB2->REFCLI	:= SW2->W2_REFCLI    											// Referencia do Cliente no PO
	TRB2->PROCESS	:= _cSW5_Hawb 	    											// nº Processo Embarque
	TRB2->DTPO		:= SW2->W2_PO_DT  												// Data do PO
	TRB2->MESPO 	:= StrZero(Month(SW2->W2_PO_DT),2,0)							// Mes do PO
	TRB2->NRPO		:= SW2->W2_PO_NUM   											// nº do PO - W2_PO_NUM
	TRB2->NEXPORT	:= Posicione("SA2",1,xFilial("SA2")+SW3->W3_FORN,"A2_NOME") 	// Nome do exportador/Fornecedor
	_cCodPais := Posicione("SYR",3,xFilial("SYR")+SW2->W2_ORIGEM,"YR_PAIS_OR") 		// Procura Codigo Origem Via Transporte
	_cDescPais:= Posicione("SYA",1,xFilial("SYA")+_cCodPais,"YA_DESCR")        		// Busca Descricao Porto Origem
	TRB2->PAISORI	:= _cDescPais									 				// Nome do Pais de Origem
	TRB2->QTDEPO	:= cW5Qtd //SW3->W3_QTDE										// Quantidade Solicitada no PO
	TRB2->CODPRO	:= SW3->W3_COD_I 												// Codigo do Produto Comprado
	TRB2->UNIDADE	:= Posicione("SB1",1,xFilial("SB1")+SW3->W3_COD_I,"B1_UM")  	// unidade de medida
	IF SB1->(DBSEEK(xFilial()+ SW3->W3_COD_I))
		TRB2->DESCPRO	:=MSMM(SB1->B1_DESC_I,AVSX3("B1_VM_I",3),1 )				// Descrição do produto em Ingles
	Endif
	if Substr(_cSW8_INV,1,1) <> space(1)
		TRB2->NRINV		:= _cSW8_INV  													// Numero da Invoice
	else
		cQW8 := " SELECT DISTINCT W8_INVOICE, W8_DT_EMIS FROM SW8010 WHERE D_E_L_E_T_ = ' ' AND W8_FILIAL = '"+SW2->W2_FILIAL+"' "
		cQW8 += " AND W8_HAWB = '"+ _cSW5_Hawb+"' "
		if Select("TMPW8") > 0 
			dbSelectArea("TMPW8")
			TMPW8->(dbCloseArea())
		endif
		dbUseArea(.T., "TOPCONN", tcGenQry (, , cQW8), 'TMPW8',.T.,.T.)
		dbSelectArea("TMPW8")
		TMPW8->(dbGotop())
		TRB2->NRINV := TMPW8->W8_INVOICE
		_cSW8_INV   := TMPW8->W8_INVOICE
		_cSW8_DTA   := stod(W8_DT_EMIS)
	endif
	
	TRB2->INCOTERM	:= SW2->W2_INCOTERM                                   			// Incoterm
	TRB2->DTINV		:= _cSW8_DTA 													// Data de Invoice
	TRB2->MOED		:= SW2->W2_MOEDA												// Moeda de importação
	TRB2->VALUNIM	:= SW3->W3_PRECO												// Valor unitário do Item de importação em moeda estrangeira
	TRB2->VALTTIM	:= cW5Qtd*SW3->W3_PRECO//SW3->W3_QTDE*SW3->W3_PRECO				// Valor Total do item de importação em moeda estrangeira
	TRB2->CONDPAG	:= SW2->W2_COND_PA                      						// Condicao de Pagamento
	If !Empty(_cSW5_Hawb)
		TRB2->NRDI		:= Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_DI_NUM") 	// Numero da DI
		TRB2->DTDI		:= Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_DTREG_D") 	// Data Registro da DI - Luiz 21/09/2010
	Endif
	TRB2->NDESP		:= Posicione("SY5",1,xFilial("SY5")+SW2->W2_DESP,"Y5_NOME")		// Nome Despachante
	If !Empty(_cSW5_Hawb)
		TRB2->REFDESP	:= Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_REF_DES")	// Referencia do Despachante
	Endif
	TRB2->VIATRAN	:= E_Field("W2_TIPO_EM","YQ_DESCR") 							// Descricao da Via de Transporte
	If !Empty(_cSW5_Hawb)
		TRB2->NRBL		:= Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_HOUSE")		// Numero do BL / AWB / HAWB
	Endif
	TRB2->DTETD		:= SW3->W3_DT_EMB												// Data de ETD
	TRB2->DTETA		:= SW3->W3_DT_ENTR												// Data de ETA
	If !Empty(_cSW5_Hawb)
		TRB2->DTEMB		:= Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_DT_EMB")		// Data Efetiva do Embarque
	Endif
	TRB2->LOCENT	:= Posicione("SYT",1,xFilial("SYT")+SW2->W2_CONSIG,"YT_NOME_RE")// Descricao Local de Entrega / Destino
	If !Empty(_cSW5_Hawb)
		AchaNfesMapa()
		TRB2->NRNFE    	:= cNfEs        											  	// Numero nota fiscal de entrada
		TRB2->VLRNFE    := IIf(!Empty(cNfEs),Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_VL_NF"),0)														// Valor total da nota de entrada
		TRB2->DTNFEMP  	:= dDtaEntrF1 	   									  			// Data de entrada da nota fiscal na empresa
		cNfCom      := Substr(Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_NF_COMP"),1,9)
		TRB2->NRNFCOM   := cNfCom														// Numero nota fiscal de entrada Complementar
		TRB2->VLNFCOM   := Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_VL_NFC")		// Valor total da nota de entrada Complementar
		TRB2->DTNFCOM   := Posicione("SF1",5,SW2->W2_FILIAL+_cSW5_Hawb+"2","F1_EMISSAO")// Data emissao da nota fiscal  															// Data de entrada da nota fiscal na empresa
	Endif
//	_cLojaFor := Posicione("SA2",1,xFilial("SA2")+SW3->W3_FORN,"A2_LOJA")
	If !Empty(_cSW5_Hawb)
		_dDtaVenCamb  	:= Posicione("SWB",7,SW2->W2_FILIAL+_cSW5_Hawb+_cSW8_INV,"WB_DT_VEN")
		if Substr(dtoc(_dDtaVenCamb),1,1) == space(1)
			cQSWB := " SELECT DISTINCT WB_DT_VEN FROM SWB010 WHERE D_E_L_E_T_ = ' ' and WB_FILIAL = '"+SW2->W2_FILIAL+"' "
			cQSWB += " AND WB_HAWB = '"+_cSW5_Hawb+"' AND WB_INVOICE = '"+_cSW8_INV+"' "
			if Select('TMPWB') > 0 
				dbSelectArea('TMPWB')
				TMPWB->(dbCloseArea())
			endif
			dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQSWB), 'TMPWB', .T.,.T.)
			dbSelectArea('TMPWB')
			TMPWB->(dbGotop())
			_dDtaVenCamb := cTod(TMPWB->WB_DT_VEN)
		endif

		//	_dDtaVenCamb  	:= Posicione("SWB",1,SW2->W2_FILIAL+_cSW5_Hawb+"D"+_cSW8_INV+SW3->W3_FORN+_cLojaFor+SW3->W3_POSICAO,"WB_DT_VEN")
		_cMesCamb       := StrZero(Month(_dDtaVenCamb),2,0)
		TRB2->DTVCAMB  	:= _dDtaVenCamb  				   								// Data Vencimento do Cambio
		TRB2->MESCAMB  	:= _cMesCamb	  				   								// Mes Vencimento do Cambio
		//_nTxMoed 	   	:= Posicione("SWB",1,SW2->W2_FILIAL+_cSW5_Hawb+"D"+_cSW8_INV+SW3->W3_FORN+_cLojaFor+SW3->W3_POSICAO,"WB_CA_TX")
		_nTxMoed 	   	:= Posicione("SWB",7,SW2->W2_FILIAL+_cSW5_Hawb+_cSW8_INV,"WB_CA_TX")
		TRB2->TXMOE	   	:= _nTxMoed														// Taxa Fechamento Cambio
		_cNrContr 	   	:= Posicione("SWB",7,SW2->W2_FILIAL+_cSW5_Hawb+_cSW8_INV,"WB_CA_NUM")
		//Posicione("SWB",1,SW2->W2_FILIAL+_cSW5_Hawb+"D"+_cSW8_INV+SW3->W3_FORN+_cLojaFor+SW3->W3_POSICAO,"WB_CA_NUM")
		TRB2->NRCAMB   	:= _cNrContr													// Numero do Contrato de Cambio
		_dDtPagCamb   	:= Posicione("SWB",7,SW2->W2_FILIAL+_cSW5_Hawb+_cSW8_INV,"WB_DT_DESE")
		//Posicione("SWB",1,SW2->W2_FILIAL+_cSW5_Hawb+"D"+_cSW8_INV+SW3->W3_FORN+_cLojaFor+SW3->W3_POSICAO,"WB_DT_DESE")
		TRB2->DPGCAMB  	:= _dDtPagCamb  												// Data Pagamento do Cambio
	Endif
	**** Novos Campos **********************************************************
	TRB2->AGCARG  	:=  BuscaAgente(SW2->W2_AGENTE) 								// Ag. Carga    - (Puxar do PO) // W2_AGENTE - Y4_NOME
	If !Empty(_cSW5_Hawb)
		TRB2->ALIQII	:= _nAliqII 													// Aliquota II  - (Puxar do desembaraço)
		TRB2->VLII		:= _nValII  													// Valor do II  - (Puxar do desembaraço)
		TRB2->ALIQIPI   := _nAliqIPI 													// Aliquoto IPI - (Puxar do desembaraço)
		TRB2->VLIPI		:= _nValIPI  													// Valor IPI    - (Puxar do desembaraço)
		TRB2->ALIQPIS   := _nAliqPIS 													// Aliquota PIS - (Puxar do desembaraço)
		TRB2->VLPIS		:= _nValPIS 													// Valor PIS    - (Puxar do desembaraço)
		TRB2->ALIQCOF	:= _nAliqCOF													// Aliquota COF - (Puxar do desembaraço)
		TRB2->VLCOF		:= _nValCOF 													// Valor COF    - (Puxar do desembaraço)
		TRB2->ALIQICMS  := _nAliqICMS 													// Aliquota ICMS- (Puxar do desembaraço)
		TRB2->VLICMS	:= _nValICMS													// Valor ICMS   - (Puxar do desembaraço)
	Endif
	TRB2->CCUSTO    := BuscaCCusto(SW3->W3_CC)										// Centro Custo - (Puxar da SC) // W0__CC - Y3_DESC
	TRB2->NCM		:= SW3->W3_TEC													// Nr. NCSM     - (Puxar do PO) // W3_TEC
	TRB2->NFABR		:= BuscaFabr_Forn(SW3->W3_FABR) 								// Nome Fabr    - (Puxar do PO)
	TRB2->FORW		:= Posicione("SY4",1,xFilial("SY4")+SW2->W2_FORWARD,"Y4_NOME")  // Nme Forwar   - (Puxar do PO)
	If !Empty(_cSW5_Hawb)
		TRB2->MOESEG    := Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_SEGMOED") 	// Moeda Segur  - (Puxar do PO)
		TRB2->VLRSEG	:= Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_VL_USSE")	// Valor Seguro - (Puxar do PO)
		TRB2->TXSEG		:= Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_TX_SEG")		// Taxa Segur   - (Puxar do desembaraço)
		TRB2->TXDI		:= Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_TX_US_D")	// Taxa DI      - (Puxar do desembaraço)
	Endif
	_cNrSC 			:= Posicione("SW0",1,xFilial("SW0")+SW3->W3_CC+SW3->W3_SI_NUM,"W0_C1_NUM")     // Numero SC    - (Puxar da SC) // W0_C1_NUM
	TRB2->NRSC      := _cNrSC
	TRB2->DTSC		:= Posicione("SW0",1,xFilial("SW0")+SW3->W3_CC+SW3->W3_SI_NUM,"W0__DT")        // Dta SC       - (Puxar da SC) // W0_DT
	//_dDtaNess     := CtoD("  /  /  ")
	TRB2->DTNESC	:= Posicione("SC1",2,SW2->W2_FILIAL+SW3->W3_COD_I+_cNrSC+SW3->W3_POSICAO,"C1_DATPRF")        // Dta Necessidade SC       - (Puxar da SC)
	//C1_FILIAL+C1_PRODUTO+C1_NUM+C1_ITEM+C1_FORNECE+C1_LOJA (2)
	//W1_FILIAL+W1_PO_NUM+W1_POSICAO+W1_CC+W1_SI_NUM (2)
	If !Empty(_cSW5_Hawb)
		TRB2->PLQ       := Posicione("SW7",4,SW2->W2_FILIAL+_cSW5_Hawb+SW3->W3_PO_NUM+SW3->W3_POSICAO+SW3->W3_PGI_NUM,"SW7->W7_PESO") // Peso Liquido - (Puxar do desembraço) // W7_PESO
		TRB2->PBR		:= Posicione("SW7",4,SW2->W2_FILIAL+_cSW5_Hawb+SW3->W3_PO_NUM+SW3->W3_POSICAO+SW3->W3_PGI_NUM,"SW7->W7_PESO")*SW3->W3_QTDE // Peso Bruto   - (Puxar do desembaraço)// W7_PESO*W7_QTDE
	Endif
	_cDest   := Posicione("SYR",4,xFilial("SYR")+SW2->W2_DEST,"YR_DESTINO") 		// Procura Codigo Origem Via Transporte
	_cDescCid:= Posicione("SY9",1,xFilial("SY9")+_cDest,"Y9_CIDADE")         		// Busca Descricao Porto Destino/Cidade
	
	TRB2->PORTDEST	:= _cDescCid 																  // PORT/AER DEST- (Puxar do PO) -
	If !Empty(_cSW5_Hawb)
		TRB2->MOEFRE	:= Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_FREMOED")				  // Moeda Frete  - (Puxar do PO)
		TRB2->TXFRE     := Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_TX_FRET")				  // Taxa Frete   - (Puxar do desembaraço)
		TRB2->FREPP		:= Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_VLFREPP") 				  // Valor Fret PP- (Puxar do desembaraço) // W6_VLFREEPP
		TRB2->FRECC   	:= Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_VLFRECC") 				  // Valor Fret CC- (Puxar do desembaraço) // W6_VLFREECC
		TRB2->FREMN		:= Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_VLFRETN")				  // Val Fret Nac - (Puxar do desembaraço) // W6_VLFRETN
	Endif
	TRB2->VLRINVPO  := SW2->W2_FOB_TOT 															  // Valor Fob PO - (Puxar do PO) // W2_FOB_TOT
	If !Empty(_cSW5_Hawb)
		TRB2->NRCONT	:= Posicione("SJD",1,xFilial("SJD")+_cSW5_Hawb,"JD_CONTAIN")				  // Num Contain  - (Puxar do controle de container) // JD_CONTAIN
		TRB2->QTD20		:= Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_CONTA20")				  // Qtd Cont 20  - (Puxar do controle de container) // W6_CONTA20
		TRB2->QTD40		:= Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_CONTA40")				  // Qtd Cont 40  - (Puxar do controle de container) // W6_CONTA40
		TRB2->QTD40H	:= Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_CONTA40HC")				  // Qtd Cont 40HC- (Puxar do controle de container) // W6_CONTA40HC
		TRB2->QTDOUT	:= Posicione("SW6",1,SW2->W2_FILIAL+_cSW5_Hawb,"W6_OUTROS") 				  // Qtd Cont Outr- (Puxar do controle de container) // W6_OUTROS
		TRB2->NRLCR		:= Posicione("SJD",1,xFilial("SJD")+_cSW5_Hawb,"JD_LACRE") 					  // Numero Lacre - (Puxar do controle de container) // JD_LACRE
	Endif
	MsUnlock()
	Return
