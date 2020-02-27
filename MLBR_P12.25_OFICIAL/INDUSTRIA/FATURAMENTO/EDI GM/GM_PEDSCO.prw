#INCLUDE "rwmake.ch"
/* TAGGs - CONSULTORIA    
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Cliente      ³ MIDORI ATLANTICA                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programa     ³ GM_PEDSCO        ³ Responsavel ³ REGINALDO NASCIMENTO   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o    ³ IMPORTACAO DE ARQUIVO TXT - PEDIDO DE VENDA             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Data        ³ 04/08/11         ³ Implantacao ³                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador ³ ANESIO G.FARIA                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user Function GM_PEDSCO
********************
Private cPerg       := "GM_ARQ"
                                                                           

AjustaSx1()         


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,480 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto para Importação")
@ 02,10 TO 085,230
@ 10,018 Say " Este programa ira ler o conteudo do arquivo txt com o pedido feito "
@ 18,018 Say " pela GM (GENERAL MOTORS), Importando os arquivos e gerando o pedido"
@ 26,018 Say " de venda no sistema                                        "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oLeTxt Centered

//Close(oLeTxt)

return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKLETXT  º Autor ³ AP6 IDE            º Data ³  04/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a leitura do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkLeTxt
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo texto                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



Private nHdl    := fOpen(mv_par01,68)



Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+mv_par01+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    Return
Endif



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| RunCont() },"Processando...")



Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  04/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function RunCont

Local nTamFile, nTamLin, cBuffer, nBtLidos
Local GM_PECA    := ""
Local GM_CLI     := ""
Local GM_PEDCLI  := ""
Local GM_QUANT   := 0
Local GM_DATA    := dDatabase
Local GM_FORNEC  := ""
Local GM_TPDSO   := ""
Local GM_PEDSAP  := ""
Local GM_HORA    := ""
Local GM_LINPED  := ""
Local GM_USOFUT  := ""
Local GM_FIM     := ""
Local nCount,nX     := 0
Local aItemPV    := {}   
Local aAux       := {}
Local nCount,icab     := 0
Local lGravaPed  := .T.
Local cCondPag   := space(3)
Local cCodLoja   := space(8)

Local cArq,cInd
Local cString := "TRB"
Local aStru := {}
Private oLeTxt
Private cTabela := MV_PAR04
Private cData := dtos(MV_PAR06)
aAdd(aStru,{"COD_PECA"  ,"C",  15,00})
aAdd(aStru,{"COD_CLI"   ,"C",  06,00})
aAdd(aStru,{"LOJA_CLI"  ,"C",  02,00})
aAdd(aStru,{"NUM_PED"   ,"C",  06,00})
aAdd(aStru,{"QUANT"     ,"N",  05,00})
aAdd(aStru,{"DATA_PED"  ,"D",  08,00})
aAdd(aStru,{"COD_FOR"   ,"C",  09,00})
aAdd(aStru,{"GM_LINPED" ,"C",  05,00})
aAdd(aStru,{"GM_CODCLI" ,"C",  06,00})
aAdd(aStru,{"FLAG"      ,"C",  01,00})

cInd := "NUMPED"
cArq := CriaTrab(aStru,.T.)
dbUseArea(.T.,,cArq,cString,.T.)
//IndRegua(cString, cArq, cInd, , , "Selecionando Itens...")


nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 78+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

//alert('DATA ESCOLHIDA-> '+dToc(MV_PAR06))
//alert('DATA ESCOLHIDA-> '+dtos(MV_PAR06)+' DATA ATUAL-> '+dtos(dDatabase))   


ProcRegua(nTamFile) // Numero de registros a processar
//Alert("Iniciando leitura")
While nBtLidos >= nTamLin


    IncProc()
                   
    GM_PECA := Substr(cBuffer,01,08)
    GM_CLI := Substr(cBuffer,09,06)
    
    GM_PEDCLI := Substr(cBuffer,15,06)
    GM_QUANT := NoRound(Val(Substr(cBuffer,21,05)),00)
//    GM_DATA := CTOD(Substr(cBuffer,26,08))
    GM_DATA := Substr(cBuffer,26,08)
//    Alert('DATA-> ' +GM_DATA)
    GM_FORNEC := Substr(cBuffer,34,09)
    GM_TPDSO := Substr(cBuffer,41,01)
    GM_PEDSAP := Substr(cBuffer,44,09)
    GM_HORA := Substr(cBuffer,53,06)
    GM_LINPED := Substr(cBuffer,59,05)
    GM_USOFUT := Substr(cBuffer,64,15)
    GM_FIM := Substr(cBuffer,79,02)
if GM_PECA <> 'HEADERPE' .and. GM_PECA <> 'TRAILLER' 
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
		TRB->COD_PECA := GM_PECA
//		cCodLoja := Posicione("SZK",1,xFilial("SZK")+GM_CLI,"ZK_CLIENTE")+Posicione("SZK",1,xFilial("SZK")+GM_CLI,"ZK_LOJA")
//		IF cCodLoja <> MV_PAR02+MV_PAR03
//			if apmsgyesno("Codigo do cliente no arquivo diferente do codigo selecionado para importar", +chr(13)+;
//				"Deseja manter o codigo selecionado?" )
//				TRB->COD_CLI  := MV_PAR02  
//				TRB->LOJA_CLI := MV_PAR03  
//			else
//				TRB->COD_CLI  := Substr(cCodLoja,1,6)
//				TRB->LOJA_CLI := Substr(cCodLoja,7,2)
//			endif
//		else
			TRB->COD_CLI  := MV_PAR02  
			TRB->LOJA_CLI := MV_PAR03  
//		endif
		TRB->NUM_PED  := GM_PEDCLI
		TRB->QUANT    := GM_QUANT
		TRB->DATA_PED := CTOD(GM_DATA)
		TRB->COD_FOR  := GM_FORNEC
		TRB->GM_LINPED:= GM_LINPED    
		TRB->GM_CODCLI:= GM_CLI
		TRB->FLAG     := 'N'
	MsUnlock("TRB")
//	Alert('DATA-> '+GM_DATA)
	Aadd(aAux, {GM_PECA, MV_PAR02, MV_PAR03,;
	 GM_PEDCLI, GM_QUANT, GM_DATA, GM_FORNEC, GM_TPDSO, GM_PEDSAP, GM_HORA, GM_LINPED, GM_USOFUT,  GM_FIM, GM_CLI})

endif

    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
    nCount++
    dbSkip()
EndDo

     
	
//Monta a variavel de itens do PV                      
cItem := "00"
nTst  := 0
cCab :=''
for icab:= 1 to len(aAux)
 	cCab:= cCab+aAux[iCab][1]+";"+aAux[iCab][1]+";"+aAux[iCab][2]+";"+aAux[iCab][3]+";"+aAux[iCab][4]+";"+StrZero(aAux[iCab][5],6);
 	+";"+aAux[iCab][6]+";"+aAux[iCab][7]+";"+aAux[iCab][8]+";"+aAux[iCab][9]+";";
 	+aAux[iCab][10]+";"+aAux[iCab][11]+";"+aAux[iCab][12]+";"+aAux[iCab][13]+";"+aAux[iCab][14]+";FIM;"
next icab
memowrite('c:\temp\arqped.txt', cCab )
//alert('GERADO TXT')

cCab :=''
aCabPV := {}
cCondPag := mv_par05
cNum := space(6)
cObs := "" 
nCountPed := 0
For nX := 1 To Len(aAux)
//	Alert("Cliente-> " +aAux[nX][2]+" Loja-> "+ aAux[nX][3])
//begin transaction 
	if lGravaPed //verifica se é para gerar cabeçalho


		lGravaPed := .F.     

		cObs := sBuscConc(aAux[nX][14])
 		cNum:=""

		dbSelectArea("TRB")
		dbGotop()        
		nPLiq := 0
		nPBru := 0
		while !TRB->(eof())
			if aAux[nX, 4] == TRB->NUM_PED .and. TRB->FLAG == 'N' .and. aAux[nX,14]==TRB->GM_CODCLI
				nPLiq += TRB->QUANT * Posicione('SB1',1,xFilial('SB1')+Posicione('SA7',3,xFilial('SA7')+TRB->(COD_PECA+COD_CLI+LOJA_CLI),'A7_PRODUTO'),"B1_PESO")
				nPBru += TRB->QUANT * Posicione('SB1',1,xFilial('SB1')+Posicione('SA7',3,xFilial('SA7')+TRB->(COD_PECA+COD_CLI+LOJA_CLI),'A7_PRODUTO'),"B1_PESBRU")
			endif
		  TRB->(dbSkip())
		enddo				

		aCabPV := {	{"C5_TIPO"		,"N"						,NIL},;
					{"C5_CLIENTE"	,aAux[nX][2]				,NIL},;
					{"C5_LOJACLI"	,aAux[nX][3]        		,NIL},;				
					{"C5_CONDPAG"	,cCondPag					,NIL},;
					{"C5_TIPOCLI"	,'F'						,NIL},;
					{"C5_PEDCLI"    ,aAux[nX][4]                ,NIL},;
					{"C5_TABELA"    ,cTabela 					 ,NIL},;
					{"C5_EMISSAO"   ,stod(cData)				 ,NIL},;
					{"C5_CODFORN"   ,aAux[nX][7]                ,NIL},;
					{"C5_PEDSAP"    ,aAux[nX][9]                ,NIL},;
					{"C5_HORA"      ,aAux[nX][10]               ,NIL},;
					{"C5_LNSAP"     ,aAux[nX][11]               ,NIL},;
					{"C5_LOJAGM"    ,aAux[nX][14]               ,NIL},;
					{"C5_TPFRETE" 	,"S"						,NIL},;
					{"C5_PESOL"		,nPLiq						 ,NIL},;
					{"C5_PBRUTO"	,nPBru						 ,NIL},;
					{"C5_MENNOTA"   ,cObs						,Nil} }

//		cCab := cCab+chr(13)+cNum+';'+"N"+';'+aAux[nX][2]+';'+aAux[nX][3]+';'+cCondPag+';'+'F'+';'+aAux[nX][4]+';'
		cCab := cNum+';'+"N"+';'+aAux[nX][2]+';'+aAux[nX][3]+';'+cCondPag+';'+'F'+';'+aAux[nX][4]+';';
			+cTabela +';'+aAux[nX][7]+';'+aAux[nX][9]+';'+;
			 aAux[nX][10]+';'+aAux[nX][11]+';'+aAux[nX][14]
	endif                                            

dbSelectArea("TRB")
dbGotop()        
aItemPV := {}     
cItem := '00' 
cDet  := '' 
while !TRB->(eof())
//		Alert("Gerando pedido..."+aAux[nX, 3] + " TRB-> "+TRB->NUM_PED)
	if aAux[nX, 4] == TRB->NUM_PED .and. TRB->FLAG == 'N' .and. aAux[nX,14]==TRB->GM_CODCLI
//		Alert("Gerando pedido IF ...")
		nCount ++
			////////////////////////////////////////////////////////////////////

			////////////////////////////////////////////////////////////////////
		cPeca := Posicione('SA7',3,xFilial('SA7')+TRB->(COD_PECA+COD_CLI+LOJA_CLI),'A7_PRODUTO') //Precisa criar o indice 3 no SA7 para buscar pelo código do produto no cliente
		nValor:= 0
		if cPeca == space(15)
			Alert("A Peça "+TRB->COD_PECA+" inclusa no pedido do clente não está disponivel no cadastro de amarração"+chr(13)+;
				"Favor verificar para nao enviar pedido incompleto!!!")
		else
			cItem := soma1(cItem)
//			Alert("Indice de busca: "+TRB->(COD_PECA+COD_CLI+LOJA_CLI)+" ITEM RETORNADO: "+cPeca+ ' Parametro:' +cTabela)
			nValor:= Posicione("DA1",1,xFilial("DA1")+cTabela+cPeca,"DA1_PRCVEN") 
			if nValor = 0 
				Alert("Produto "+Substr(cPeca,1,8)+Posicione("SB1",1,xFilial("SB1")+cPeca,"B1_DESC")+chr(13)+"Não está cadastrado na tabela "+cTabela+;
				chr(13)+chr(13)+"Será lançado valor de 1,00 no pedido, favor corrigir posterior")
				nValor := 1
			endif
//			Alert('cItem->'+cItem+' cPeca-> '+cPeca+' DESCR->'+Posicione("SB1",1,xFilial("SB1")+cPeca,"B1_DESC"))
//			Alert('Qtde->'+cValToChar(TRB->QUANT)+' PrcVen->'+cValToChar(nValor)+' TOTAL-> '+cValToChar(TRB->QUANT*nValor))
			AAdd(aItemPV,{		{"C6_ITEM"      ,cItem,												,NIL},;
								{"C6_PRODUTO"	,cPeca            									,NIL},;
								{"C6_DESCRI"    ,Posicione("SB1",1,xFilial("SB1")+cPeca,"B1_DESC")	,NIL},;
								{"C6_QTDVEN"	,TRB->QUANT        									,NIL},;
								{"C6_PRCVEN"	,nValor			   									,NIL},;
								{"C6_VALOR"		,round(TRB->QUANT*nValor,2)    						,NIL},;
								{"C6_TES"		,'614'												,NIL},;
								{"C6_CCUSTO"    ,'410205'												,NIL},;
								{"C6_LNSAP"     ,TRB->GM_LINPED										,NIL}})
					cDet := cDet+chr(13)+cItem+";"+cPeca+";"+Posicione("SB1",1,xFilial("SB1")+cPeca,"B1_DESC");
					+";"+strzero(TRB->QUANT,6)+";"+strzero(nValor,6)+";"+strzero(TRB->QUANT*nValor,10)+";"+'614'+";"+'410205'+";"+TRB->GM_LINPED
								
		endif
		RecLock("TRB",.F.)
		TRB->FLAG := 'S'
	endif

  TRB->(dbSkip())
enddo
	lMsErroAuto := .F.
	if nCount > 0 .and. Len(aItemPV) > 0// Verifica se há pedido no array
//		ConfirmSX8()                                         
//		Alert('Pedido o pedido sera gerado....')
//		if nTst >= 3
//			alert('tamanho cabecalho '+cValToChar(len(aCabPV))+' - tamanho dos itens '+cValToChar(len(aItemPV)))
			cCab := cCab +chr(13)+cDet			
			memowrite('c:\temp\cabec.txt', cCab )
			cCab := '' 
			MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabPV,aItemPV,3)
			cNum := space(6)
//		endif
//		Alert('Pedido gerado...')
//		ConfirmSX8()

		If lMsErroAuto
			Mostraerro()
			RollBackSX8()
//			cNum := GetSX8Num("SC5","C5_NUM")			
		Else
//			ConfirmSX8()  
			nCount    := 0
			lGravaPed := .T.
//			aItemPV   := {}
			aCabPV    := {}
			cItem     := '00'
			nTst++
			nCountPed++
//			Alert("Numero do Pedido de Vendas GM Gerado-> "+cNum)
//			cNum := GetSXENum("SC5","C5_NUM")			
		EndIf
	else
		lGravaPed := .T.
	endif
//end transaction 
next nX
Alert("Importado "+cValToChar(nCountPed)+" com sucesso!")
fClose(nHdl)
//cNome := mv_par01
//alert(cValToChar(len(cNome)))
//cNnome := Substr(mv_par01,1,len(mv_par01))//+"#"
//fRename(nHdl, cNnome, 68)

Ft_fUse()
//Close(oLeTxt)
DbSelectArea("TRB")
DbCloseArea()
IF File(cArq+OrdBagExt())
	FErase(cArq+OrdBagExt())
ENDIF

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Anesio G.Faria -    ³    02.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aArea := GetArea()
PutSx1(cPerg,"01","Caminho do Arquivo            ?"," "," ","mv_ch1","C",40,0,0,"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o caminho do arquivo "},{"Informe o caminho do arquivo "},{"Informe o caminho do arquivo "})
PutSx1(cPerg,"02","Selecione o cliente           ?"," "," ","mv_ch2","C",06,0,0,"G","","SA1","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o cliente a ser utilizado"},{"Informe o cliente a ser utilizado"},{"Informe o cliente a ser utilizado"})
PutSx1(cPerg,"03","Selecione a loja              ?"," "," ","mv_ch3","C",02,0,0,"G","","   ","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a loja do cliente        "},{"Informe a loja do cliente        "},{"Informe a loja do cliente        "})
PutSx1(cPerg,"04","Selecione a tabela de preço   ?"," "," ","mv_ch4","C",03,0,0,"G","","DA0","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a tabela de preço        "},{"Informe a tabela de preco        "},{"Informe a tabela de preço        "})
PutSx1(cPerg,"05","Selecione a condicao de pgto  ?"," "," ","mv_ch5","C",03,0,0,"G","","SE4","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a condicao de pgto       "},{"Informe a condicao de pgto       "},{"Informe a condicao de pgto       "})
PutSx1(cPerg,"06","Data para emissão do pedido   ?"," "," ","mv_ch6","D",08,0,0,"G","","   ","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data que será gravado o pedido   "},{"Data que será gravado o pedido       "},{"Data que será gravado o pedido       "})
RestArea(aArea)
Return

///////////////////////////////////////////////////////////////////////////////////////////
//Funcao para buscar a concessionaria para a qual o pedido esta sendo realizado
///////////////////////////////////////////////////////////////////////////////////////////
static function sBuscConc(cCliExt)
cMsg:="" 
if Select('TRCLI') > 0 
	dbSelectArea('TRCLI')
    TRCLI->(dbCloseArea())
endif
 	cQCODGM := " SELECT A1_COD, A1_LOJA FROM SA1010 WHERE D_E_L_E_T_ = ' ' AND A1_CODEXTC = '"+cCliExt+"' " 

dbUseArea(.T., "TOPCONN", TcGenQry( ,, cQCODGM), 'TRCLI', .T.,.T.)

dbSelectArea('SA1')
dbSetOrder(1)
if dbSeek(xFilial('SA1')+TRCLI->(A1_COD+A1_LOJA))
	cMsg :='ENTREGA NA CONCESSIONARIA '+SA1->A1_CODEXTC+' '+ALLTRIM(SA1->A1_NOME)+' CNPJ: '+TRANSFORM(SA1->A1_CGC,"@R 99.999.999/9999-99")
endif


return cMsg