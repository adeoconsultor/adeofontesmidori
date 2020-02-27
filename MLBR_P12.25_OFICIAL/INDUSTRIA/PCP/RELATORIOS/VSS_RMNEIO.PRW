#include "RWMAKE.CH"
#include "PROTHEUS.CH"
#include "TOPCONN.CH" 
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH

///////////////////////////////////////////////////////////////////////////////
//Romaneio de exportacao para geracao do Packing-List
//Gera um relatorio com as informacoes das Ops que foram abertas para exportacao
//pela rotina customizada VSS_MSEC2.PRW.
//As informacoes do Romaneio sao buscadas na tabela SD3, onde foram gravadas
//pela rotina customizada (acima)
//A partir da geracao do romaneio, serao gravados os dados na tabela customizada ZZL,
//onde, os dados estarao separados conforme necessario para geracao do pedido de exportacao (feito pelo IMPEX).
//A gravacao destes dados na tabela ZZL substituira a digitacao manual do mesmo na preparacao do documento.
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Vinicius de S. Schwartz - TI Midori Atlantica  -20-08-2012
//Chamado HDi 004882 aberto por Thiago Amorim
///////////////////////////////////////////////////////////////////////////////

User Function VSS_RMNEIO(cGetCodPro,cGetPlt,cGetAlt,cGetLarg,cGetComp,cGetPes,cGetCli,cSayCli,cSayLj,cSayDesc1,cSayDPais,cFina)

//Local _cNumOP := Substr(cNumOP,1,6)

Local wnrel
Local tamanho		:= "G"
Local titulo		:= "ROMANEIO"
Local cDesc1		:= "ROMANEIO"
Local cDesc2		:= ""
Local aSays     	:= {}, aButtons := {}, nOpca := 0

Private _aArea      := GetArea()
Private nomeprog 	:= "MD_GRFCORG"
Private nLastKey 	:= 0
Private cPerg    	:= "GRFCORG"
Private oPrint       

//Declaracao das fontes
Private oFontAr8	:= TFont():New("Arial", 8, 8,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr9	:= TFont():New("Arial", 9, 9,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr11	:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr14	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr16	:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr20	:= TFont():New("Arial",20,20,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr24	:= TFont():New("Arial",24,24,,.F.,,,,.T.,.F.)	//Normal

Private oFontAr8n	:= TFont():New("Arial", 8, 8,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr9n	:= TFont():New("Arial", 9, 9,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr10n	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr11n	:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr12n	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr13n	:= TFont():New("Arial",13,13,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr14n	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr16n	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr20n	:= TFont():New("Arial",20,20,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr24n	:= TFont():New("Arial",24,24,,.T.,,,,.T.,.F.)	//Negrito

oPrint:=TMSPrinter():New()	
oPrint:SetPortrait()					
oPrint:SetPaperSize(9)					

ApMsgAlert("Tecle OK para imprimir o Romaneio...Pallet->" +cGetPlt)

oDlg3:End()

//Processa( {|lEnd| FICHMED(@lEnd, cNum)}, "Aguarde...","Calculando Itens gerados na medideira.", .T. )
RptStatus({|lEnd| ImpGraf(cGetPlt)},Titulo)

Return(.T.)


/*
----------------------------------------------------------------------
Funcao   : ImpGraf()
Descricao: Impressao da ficha de processo da medideira Semi-Acabado
----------------------------------------------------------------------*/
Static Function ImpGraf(cGetPlt)

Private cLogo := '\system\lgl010.bmp'

Processa({|| ImprGraf(cGetPlt), 'Gerando Romaneio...Pallet->'+cGetPlt } )
	
/*
----------------------------------------------------------------------
Funcao   : RImpAutPag()
Descricao: Impressão da Autorizacao de Pagamento             
----------------------------------------------------------------------*/
Static Function IMprGraf(cGetPlt)
ProcREgua( Reccount() )


Processa( {|lEnd| GrRom(@lEnd, cGetPlt)}, "Aguarde...","Imprimindo Romaneio...Pallet->"+cGetPlt, .T. )

return

static function GrRom(lEnd, cGetPlt)

//Local cDescArt 	:= Posicione('SB1',1,xFilial('SB1')+cGetCodPro),"B1_DESC")
//Local cNoCli	:= Posicione('SA1',1,xFilial('SA1')+cGetCli),"A1_NOME")
//Local cLjCli	:= Posicione('SA1',1,xFilial('SA1')+cGetCli),"A1_LOJA")

Local cQuery := ""   

//Declaracao das variaveis
Local nLin    := 30	//60    
Local nLin2
Local nLin3
Local nLinUlt := 600
Local nColIni := 100    
Local nCol1   := 370
Local nCol2   := 850
Local nCol3   := 1100
Local nCol4   := 1350
Local nCol5   := 1600
Local nCol6   := 1850
Local nCol7   := 2100
Local nColFim := 2350
Local nCount  := 0   

Local nVC   := 0
Local nVD   := 0
Local nVE   := 0
Local nVER  := 0
Local nVT   := 0
Local nMC   := 0
Local nMD   := 0
Local nME   := 0
Local nMER  := 0
Local nMT   := 0

Local nVC2   := 0
Local nVD2   := 0
Local nVE2   := 0
Local nVER2  := 0
Local nVT2   := 0
Local nMC2   := 0
Local nMD2   := 0
Local nME2   := 0
Local nMER2  := 0
Local nMT2   := 0

Local LotC   := Space(50)
Local LotD   := Space(50)
Local LotE   := Space(50)
Local LotER  := Space(50)

nBClassV := 0
nBClassM := 0          

nPltVq := 0
nPltM2 := 0

nPesC  := 0
nPesD  := 0
nPesE  := 0
nPesER := 0
nPesT  := 0              

cCod     := Space(6)
nPeso    := 0
nVQ      := 0
nM2      := 0
cLote    := Space(50)
cClass   := Space(2)
nPesoPlt := GetMv ('MA_PESOPLT')

ProcREgua( Reccount() )

//Verifica se tabelas temporias existem e encerra as mesmas antes de executar as novas
if Select("TMPD3") > 0 
	dbSelectArea("TMPD3")
	TMPD3->(dbCloseArea())
endif

//cGetCodPro,cGetPlt,cGetAlt,cGetLarg,cGetComp,cGetPes,cGetCli,cSayLj,cSayDesc1,cSayDPais

cQuery := " SELECT D3_X_NPLT, D3_PARTIDA, D3_LOTECTL, SUBSTRING(D3_OP,1,6) D3_OP, D3_EMISSAO, D3_X_VC, D3_X_VD, D3_X_VE, D3_X_VER, D3_X_MC, D3_X_MD, D3_X_ME, D3_X_MER "
cQuery += " FROM SD3010 "
cQuery += " WHERE   D3_FILIAL = '"+xFilial("SD3")+"' "
cQuery += " 	AND D3_X_NPLT = '"+cGetPlt+"' "
cQuery += " 	AND (D3_X_TPROD = 'E')"
cQuery += " 	AND D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY D3_X_NPLT, D3_PARTIDA, D3_OP "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN", tcGenQry(,,cQuery),"TMPD3",.F.,.T.)

TcSetField("TMPD3", "D3_EMISSAO", "D")

dbSelectArea("TMPD3")
TMPD3->(dbGotop())

//Imprime o Cabecalho do Romaneio
oPrint:SayBitmap(nLin,120,cLogo,150,155) //Print Logo Midori
oPrint:Say(nLin,400,"MIDORI AUTO LEATHER BRASIL LTDA / FILIAL: PENÁPOLIS 1",oFontAr14)
oPrint:Say(nLin+90,600,"PALLET PACKING-LIST - CRUST LEATHER EXPORT",oFontAr14n)
oPrint:Say(nLin+170,150,"ARTICLE:",oFontAr16)
oPrint:Say(nLin+160,500,cSayDesc1,oFontAr20n)
oPrint:Say(nLin+290,150,"CODE:",oFontAr16)
oPrint:Say(nLin+290,500,cGetCodPro,oFontAr20n)  
oPrint:Say(nLin+290,1000,"COD CLIENTE:",oFontAr14)  
oPrint:Say(nLin+290,1400,cGetCli,oFontAr14)  
oPrint:Say(nLin+290,1700,"LOJA:",oFontAr14)  
oPrint:Say(nLin+290,1900,cSayLj,oFontAr14)  
oPrint:Say(nLin+400,150,"DESTINATION:",oFontAr14n)
oPrint:Say(nLin+400,530,cSayCli,oFontAr14n)
oPrint:Say(nLin+500,500,cSayDPais,oFontAr20n)    

//Inicio do loop para impressao por lotes, ordenados por OP e separados por classificacao
While TMPD3->(!EOF())

	nVC  := 0
	nVD  := 0
	nVE  := 0
	nVER := 0
	
	nMC  := 0
	nMD  := 0
	nME  := 0
	nMER := 0

	//Inicio da impressao dos lotes
	cOldLote := TMPD3->D3_PARTIDA
	crtLote  :=TMPD3->D3_LOTECTL
	
	//Antes de imprimir o cabecalho do lote
	if nLinUlt >= 3000
		oPrint:EndPage()
		nLinUlt :=150
	endif
	
	nLin := nLinUlt

	//Inicio da impressao do lote
	nLin += 25
	oPrint:Line(nLin,nColIni,nlin,nColFim)//horizontal
	nLin += 86
	oPrint:Line(nLin,nColIni,nlin,nColFim)//horizontal
	oPrint:Say(nLin-50,nColIni+10,"Nº PARTIDA:",oFontAr14n)
	oPrint:Say(nLin-50,nColIni+400,TMPD3->D3_PARTIDA,oFontAr14n) 
	oPrint:Say(nLin-50,nCol4+125,"CLASS",oFontAr14n)
	nLin += 86
	oPrint:Line(nLin-172,nColIni,nLin,nColIni)//vertical
	oPrint:Say(nLin-50,nColIni+10,"OP",oFontAr14n)
	oPrint:Line(nLin-86 ,nCol1,nLin,nCol1) //vertical
	oPrint:Say(nLin-50,nCol1+10,"PRODUCTION DATE",oFontAr13n)
	oPrint:Line(nLin-172,nCol2,nLin,nCol2) //vertical
	oPrint:Line(nLin-86 ,nCol3,nLin,nCol3) //vertical   
	oPrint:Say(nLin-50,nCol3+10,"C",oFontAr14n)
	oPrint:Line(nLin-86 ,nCol4,nLin,nCol4) //vertical
	oPrint:Say(nLin-50,nCol4+10,"D",oFontAr14n)
	oPrint:Line(nLin-86 ,nCol5,nLin,nCol5) //vertical
	oPrint:Say(nLin-50,nCol5+10,"E",oFontAr14n)
	oPrint:Line(nLin-86 ,nCol6,nLin,nCol6) //vertical
	oPrint:Say(nLin-50,nCol6+10,"ER",oFontAr14n)
	oPrint:Line(nLin-86 ,nCol7,nLin,nCol7) //vertical
	oPrint:Say(nLin-50,nCol7+10,"TOTAL",oFontAr14n)
	oPrint:Line(nLin-172,nColFim,nLin,nColFim)//vertical 
	oPrint:Line(nLin,nColIni,nlin,nColFim)//horizontal

	//Apos imprimir o cabecalho do lote
	//Verifica se esta no final da folha, e se estiver pula para a proxima pagina
	if nlin >= 3000
		oPrint:EndPage()
		nLinUlt :=150
		nLin := nLinUlt   
		
		//Impressao do cabecalho novamente caso houver a quebra de pag. apos a impressao do mesmo
		nLin += 25
		oPrint:Line(nLin,nColIni,nlin,nColFim)//horizontal
		nLin += 86
		oPrint:Line(nLin,nColIni,nlin,nColFim)//horizontal
		oPrint:Say(nLin-50,nColIni+30,"Nº LOT:",oFontAr14n)
		oPrint:Say(nLin-50,nColIni+250,TMPD3->D3_PARTIDA,oFontAr14n)
		oPrint:Say(nLin-50,nCol4+125,"CLASS",oFontAr14n)
		nLin += 86
		oPrint:Line(nLin-172,nColIni,nLin,nColIni)//vertical
		oPrint:Say(nLin-50,nColIni+10,"OP",oFontAr14n)
		oPrint:Line(nLin-86 ,nCol1,nLin,nCol1) //vertical
		oPrint:Say(nLin-50,nCol1+10,"PRODUCTION DATE",oFontAr13n)
		oPrint:Line(nLin-172,nCol2,nLin,nCol2) //vertical
		oPrint:Line(nLin-86 ,nCol3,nLin,nCol3) //vertical   
		oPrint:Say(nLin-50,nCol3+10,"C",oFontAr14n)
		oPrint:Line(nLin-86 ,nCol4,nLin,nCol4) //vertical
		oPrint:Say(nLin-50,nCol4+10,"D",oFontAr14n)
		oPrint:Line(nLin-86 ,nCol5,nLin,nCol5) //vertical
		oPrint:Say(nLin-50,nCol5+10,"E",oFontAr14n)
		oPrint:Line(nLin-86 ,nCol6,nLin,nCol6) //vertical
		oPrint:Say(nLin-50,nCol6+10,"ER",oFontAr14n)
		oPrint:Line(nLin-86 ,nCol7,nLin,nCol7) //vertical
		oPrint:Say(nLin-50,nCol7+10,"TOTAL",oFontAr14n)
		oPrint:Line(nLin-172,nColFim,nLin,nColFim)//vertical 
		oPrint:Line(nLin,nColIni,nlin,nColFim)//horizontal
	endif

	//Inicio das impressoes das OPs
	nLin2:=nLin
	nLin += 86
	
	//Inicio do loop de impressao das OPs -> verifica se ha mais de uma OP por lote e ordena
	While cOldLote == TMPD3->D3_PARTIDA
	
		//Antes de imprimir as OPs
		if nlin >= 3000
			oPrint:EndPage()
			nLinUlt :=150
			nLin := nLinUlt 
//			nLin2 := nLin
		endif
	
		//Impressao de cada OP
		oPrint:Line(nLin-86,nColIni,nLin,nColIni)//vertical
		oPrint:Say(nLin-50,nColIni+10,TMPD3->D3_OP,oFontAr14)
		oPrint:Say(nLin-50,nCol1+10  ,DTOC(TMPD3->D3_EMISSAO),oFontAr14)
		oPrint:Line(nLin-86,nCol2,nLin,nCol2)//vertical
		oPrint:Line(nLin-86,nCol2,nLin,nCol2)//vertical

		//Variaveis iniciadas em 0 e somadas para cada OP por classificacao -> essas variaveis sao zeradas a cada loop por lote
		nVC  += D3_X_VC
		nVD  += D3_X_VD
		nVE  += D3_X_VE
		nVER += D3_X_VER
		
		nMC  += D3_X_MC
		nMD  += D3_X_MD
		nME  += D3_X_ME
		nMER += D3_X_MER
		
		//Variaveis iniciadas em 0 e somadas a cada OP -> essas variaveis sao cumulativas, ou seja, nao eh zerada a cada loop
		nVC2  += D3_X_VC
		nVD2  += D3_X_VD
		nVE2  += D3_X_VE
		nVER2 += D3_X_VER
		
		nMC2  += D3_X_MC
		nMD2  += D3_X_MD
		nME2  += D3_X_ME
		nMER2 += D3_X_MER
		
		//Pula para o proximo registro e verifica se a OP pertence ao mesmo lote
		TMPD3->(dbSkip())

		If cOldLote == TMPD3->D3_PARTIDA
			nLin += 86

			//Antes de imprimir a proxima OP caso haja mais de uma OP por lote
			//Verifica se esta no final da folha e se tiver pula para a proxima pagina
			if nlin >= 3000
				oPrint:EndPage()
				nLinUlt :=150   
				nLin := nLinUlt

				//Impressao do cabecalho novamente caso houver a quebra de pag. no meio da impressao do lote
				nLin += 25
				oPrint:Line(nLin,nColIni,nlin,nColFim)//horizontal
				nLin += 86
				oPrint:Line(nLin,nColIni,nlin,nColFim)//horizontal
				oPrint:Say(nLin-50,nColIni+30,"Nº LOT:",oFontAr14n)
				oPrint:Say(nLin-50,nColIni+250,TMPD3->D3_PARTIDA,oFontAr14n)
				oPrint:Say(nLin-50,nCol4+125,"CLASS",oFontAr14n)
				nLin += 86
				oPrint:Line(nLin-172,nColIni,nLin,nColIni)//vertical
				oPrint:Say(nLin-50,nColIni+10,"OP",oFontAr14n)
				oPrint:Line(nLin-86 ,nCol1,nLin,nCol1) //vertical
				oPrint:Say(nLin-50,nCol1+10,"PRODUCTION DATE",oFontAr13n)
				oPrint:Line(nLin-172,nCol2,nLin,nCol2) //vertical
				oPrint:Line(nLin-86 ,nCol3,nLin,nCol3) //vertical   
				oPrint:Say(nLin-50,nCol3+10,"C",oFontAr14n)
				oPrint:Line(nLin-86 ,nCol4,nLin,nCol4) //vertical
				oPrint:Say(nLin-50,nCol4+10,"D",oFontAr14n)
				oPrint:Line(nLin-86 ,nCol5,nLin,nCol5) //vertical
				oPrint:Say(nLin-50,nCol5+10,"E",oFontAr14n)
				oPrint:Line(nLin-86 ,nCol6,nLin,nCol6) //vertical
				oPrint:Say(nLin-50,nCol6+10,"ER",oFontAr14n)
				oPrint:Line(nLin-86 ,nCol7,nLin,nCol7) //vertical
				oPrint:Say(nLin-50,nCol7+10,"TOTAL",oFontAr14n)
				oPrint:Line(nLin-172,nColFim,nLin,nColFim)//vertical 
				oPrint:Line(nLin,nColIni,nlin,nColFim)//horizontal

				nLin2 := nLin
				nLin  += 86
			endif			
			  
		//Caso o registro (OP) nao pertenca ao mesmo lote, o lote eh finalizado e iniciado o novo bloco de lote
		Else
		    //Antes de imprimir as qtds de SIDES e SQM
		    //Verifica se esta no final da folha e se tiver pula para a proxima pagina
		    if nlin >= 3000
				oPrint:EndPage()
				nLinUlt :=150
				nLin2 := nLinUlt
			endif
			
		    //Imprime os valores acumulados das variaveis. Eh impresso por classificacao ao final da verificacao de cada lote
		    oPrint:Line(nLin,nColIni,nLin,nCol2)//horizontal apos ultima OP
		    nLin2 += 86
			oPrint:Say(nLin2-50,nCol2+10,"SIDES",oFontAr14n)
			oPrint:Say(nLin2-50,nCol3+10,cValToChar(nVC),oFontAr14)
			oPrint:Say(nLin2-50,nCol4+10,cValToChar(nVD),oFontAr14)
			oPrint:Say(nLin2-50,nCol5+10,cValToChar(nVE),oFontAr14)
			oPrint:Say(nLin2-50,nCol6+10,cValToChar(nVER),oFontAr14)
			oPrint:Say(nLin2-50,nCol7+10,cValToChar(nVC+nVD+nVE+nVER),oFontAr14n)
			oPrint:Line(nLin2,nCol2,nLin2,nColFim)//horizontal
			nLin2 += 86                       
			oPrint:Say(nLin2-50,nCol2+10,"SQM",oFontAr14n)
			oPrint:Say(nLin2-50,nCol3+10,cValToChar(nMC),oFontAr14)
			oPrint:Say(nLin2-50,nCol4+10,cValToChar(nMD),oFontAr14)
			oPrint:Say(nLin2-50,nCol5+10,cValToChar(nME),oFontAr14)
			oPrint:Say(nLin2-50,nCol6+10,cValToChar(nMER),oFontAr14)
			oPrint:Say(nLin2-50,nCol7+10,cValToChar(nMC+nMD+nME+nMER),oFontAr14n)
			oPrint:Line(nLin2-172,nCol2,nLin2,nCol2)//vertical
			oPrint:Line(nLin2-172,nCol3,nLin2,nCol3)//vertical
			oPrint:Line(nLin2-172,nCol4,nLin2,nCol4)//vertical
			oPrint:Line(nLin2-172,nCol5,nLin2,nCol5)//vertical
			oPrint:Line(nLin2-172,nCol6,nLin2,nCol6)//vertical
			oPrint:Line(nLin2-172,nCol7,nLin2,nCol7)//vertical
			oPrint:Line(nLin2-172,nColFim,nLin2,nColFim)//vertical
			oPrint:Line(nLin2,nCol2,nLin2,nColFim)//horizontal
//			oPrint:Say(nLin2+50,nCol1+10, StrZero(nLin,5), oFontAr10)

			//Apos imprimir as qtds de SIDES e SQM
			//Verifica se esta no final da folha e se tiver pula para a proxima pagina
			if nlin >= 3000
				oPrint:EndPage()
				nLinUlt :=150
				nLin := nLinUlt
			endif		

			//Inicia variavel com os lotes pertencentes a cada classificacao
			If nVC > 0
				LotC := StrTran((LotC + '/' + cOldLote),' ','')
			Endif
			
			If nVD > 0
				LotD := StrTran((LotD + '/' + cOldLote),' ','')
			Endif

			If nVE > 0
				LotE := StrTran((LotE + '/' + cOldLote),' ','')
			Endif			

			If nVER > 0
				LotER := StrTran((LotER + '/' + cOldLote),' ','')
			Endif			

		EndIf 
		
		//Apos loop total de cada lote
		//Verifica se esta no final da folha e se tiver pula para a proxima pagina
		if nlin >= 3000
			oPrint:EndPage()
			nLinUlt :=150
		endif     
		
		//Guarda na variavel nLinUlt a ultima linha impressa para o proximo lote ser iniciado em seguida
		If nLin == nLin2
			nLinUlt := nLin
			elseif nLin < nLin2
				nLinUlt := nLin2
			elseif nLin > nLin2
				nLinUlt := nLIn
		endif
		
	EndDo //Fim das impressoes OPs
EndDo //Fim da impressao dos lotes


//Inicio da impressao do rodape
//Verifica se esta no final da folha, e se estiver pula para a proxima pagina
if nlin >= 3000
	oPrint:EndPage()
	nLinUlt :=150
	nLin := nLinUlt
endif

//Inicio da impressao do Total By Class		
nLin := nLinUlt

	nLin += 25
	oPrint:Line(nLin,nColIni,nlin,nColFim)//horizontal
	nLin += 86
	oPrint:Line(nLin,nCol2,nlin,nColFim)//horizontal
	oPrint:Say(nLin,nCol1,"TOTAL BY",oFontAr16n)
	oPrint:Say(nLin-60,nCol4+125,"CLASS",oFontAr16n)
	nLin += 86
	oPrint:Line(nLin-172,nColIni,nLin+172,nColIni)//vertical
	oPrint:Say(nLin,nCol1+10,"CLASS",oFontAr16n) //TOTAL BY CLASS
	oPrint:Line(nLin-172,nCol2,nLin,nCol2) //vertical
	oPrint:Line(nLin-86 ,nCol3,nLin,nCol3) //vertical   
	oPrint:Say(nLin-60,nCol3+10,"C",oFontAr16n)
	oPrint:Line(nLin-86 ,nCol4,nLin,nCol4) //vertical
	oPrint:Say(nLin-60,nCol4+10,"D",oFontAr16n)
	oPrint:Line(nLin-86 ,nCol5,nLin,nCol5) //vertical
	oPrint:Say(nLin-60,nCol5+10,"E",oFontAr16n)
	oPrint:Line(nLin-86 ,nCol6,nLin,nCol6) //vertical
	oPrint:Say(nLin-60,nCol6+10,"ER",oFontAr16n)
	oPrint:Line(nLin-86 ,nCol7,nLin,nCol7) //vertical
	oPrint:Say(nLin-60,nCol7+10,"TOTAL",oFontAr16n)
	oPrint:Line(nLin-172,nColFim,nLin,nColFim)//vertical 
	oPrint:Line(nLin,nCol2,nlin,nColFim)//horizontal
	nLin2 := nLin
	nLin += 172
	oPrint:Line(nLin,nColIni,nlin,nCol2)//horizontal


if nlin >= 3000
	oPrint:EndPage()
	nLinUlt :=150
	nLin := nLinUlt

	//Impressao do cabecalho TOTAL BY CLASS
	nLin += 25
	oPrint:Line(nLin,nColIni,nlin,nColFim)//horizontal
	nLin += 86
	oPrint:Line(nLin,nCol2,nlin,nColFim)//horizontal
	oPrint:Say(nLin,nCol1,"TOTAL BY",oFontAr16n)
	oPrint:Say(nLin-60,nCol4+125,"CLASS",oFontAr16n)
	nLin += 86
	oPrint:Line(nLin-172,nColIni,nLin+172,nColIni)//vertical
	oPrint:Say(nLin,nCol1+10,"CLASS",oFontAr16n) //TOTAL BY CLASS
	oPrint:Line(nLin-172,nCol2,nLin,nCol2) //vertical
	oPrint:Line(nLin-86 ,nCol3,nLin,nCol3) //vertical   
	oPrint:Say(nLin-60,nCol3+10,"C",oFontAr16n)
	oPrint:Line(nLin-86 ,nCol4,nLin,nCol4) //vertical
	oPrint:Say(nLin-60,nCol4+10,"D",oFontAr16n)
	oPrint:Line(nLin-86 ,nCol5,nLin,nCol5) //vertical
	oPrint:Say(nLin-60,nCol5+10,"E",oFontAr16n)
	oPrint:Line(nLin-86 ,nCol6,nLin,nCol6) //vertical
	oPrint:Say(nLin-60,nCol6+10,"ER",oFontAr16n)
	oPrint:Line(nLin-86 ,nCol7,nLin,nCol7) //vertical
	oPrint:Say(nLin-60,nCol7+10,"TOTAL",oFontAr16n)
	oPrint:Line(nLin-172,nColFim,nLin,nColFim)//vertical 
	oPrint:Line(nLin,nColIni,nlin,nColFim)//horizontal
	nLin2 := nLin
	nLin += 172
	oPrint:Line(nLin,nColIni,nlin,nCol2)//horizontal

endif

//Imprime os valores acumulados das variaveis. Eh impresso por classificacao ao final da verificacao de todos os  lotes
oPrint:Line(nLin,nCol2,nLin,nColFim)//horizontal
nLin2 += 86
oPrint:Say(nLin2-60,nCol2+10,"SIDES",oFontAr16n)
oPrint:Say(nLin2-50,nCol3+10,cValToChar(nVC2),oFontAr14)
oPrint:Say(nLin2-50,nCol4+10,cValToChar(nVD2),oFontAr14)
oPrint:Say(nLin2-50,nCol5+10,cValToChar(nVE2),oFontAr14)
oPrint:Say(nLin2-50,nCol6+10,cValToChar(nVER2),oFontAr14) 

nBClassV := (nVC2+nVD2+nVE2+nVER2)

oPrint:Say(nLin2-50,nCol7+10,cValToChar(nBClassV),oFontAr14n)
oPrint:Line(nLin2,nCol2,nLin2,nColFim)//horizontal
nLin2 += 86                       
oPrint:Say(nLin2-60,nCol2+10,"SQM",oFontAr16n)
oPrint:Say(nLin2-50,nCol3+10,cValToChar(nMC2),oFontAr14)
oPrint:Say(nLin2-50,nCol4+10,cValToChar(nMD2),oFontAr14)
oPrint:Say(nLin2-50,nCol5+10,cValToChar(nME2),oFontAr14)
oPrint:Say(nLin2-50,nCol6+10,cValToChar(nMER2),oFontAr14) 

nBClassM := (nMC2+nMD2+nME2+nMER2)

oPrint:Say(nLin2-50,nCol7+10,cValToChar(nBClassM),oFontAr14n)
oPrint:Line(nLin2-172,nCol2,nLin2,nCol2)//vertical
oPrint:Line(nLin2-172,nCol3,nLin2,nCol3)//vertical
oPrint:Line(nLin2-172,nCol4,nLin2,nCol4)//vertical
oPrint:Line(nLin2-172,nCol5,nLin2,nCol5)//vertical
oPrint:Line(nLin2-172,nCol6,nLin2,nCol6)//vertical
oPrint:Line(nLin2-172,nCol7,nLin2,nCol7)//vertical
oPrint:Line(nLin2-172,nColFim,nLin2,nColFim)//vertical
oPrint:Line(nLin2,nCol2,nLin2,nColFim)//horizontal
//oPrint:Say(nLin2+50,nCol1+10, StrZero(nLin,5), oFontAr10)

//Apos imprimir as qtds de SIDES e SQM por TATAL BY CLASS
//Verifica se esta no final da folha e se tiver pula para a proxima pagina
if nlin >= 3000
	oPrint:EndPage()
	nLinUlt :=150
	nLin := nLinUlt
endif

//Impressao de TOTAL PALLET 
nPltVq := (nVC2+nVD2+nVE2+nVER2)
nPltM2 := (nMC2+nMD2+nME2+nMER2)
 
nLin += 25
oPrint:Line(nLin,nColIni,nlin,nColFim)//horizontal
nLin += 86
oPrint:Line(nLin,nCol2,nlin,nColFim)//horizontal
oPrint:Say(nLin-86,nCol1,"TOTAL",oFontAr16n)
oPrint:Say(nLin-60,nCol2+10,"SIDES",oFontAr16n)
oPrint:Say(nLin-60,nCol5+10,"SQM",oFontAr16n)
nLin += 86
oPrint:Line(nLin-172,nColIni,nLin,nColIni)//vertical
oPrint:Say(nLin-86,nCol1+10,"PALLET",oFontAr16n)
oPrint:Line(nLin-172,nCol2,nLin,nCol2) //vertical
oPrint:Say(nLin-60,nCol2+10,cValToChar(nPltVq),oFontAr16n)
oPrint:Line(nLin-172 ,nCol5,nLin,nCol5) //vertical
oPrint:Say(nLin-60,nCol5+10,cValToChar(nPltM2),oFontAr16n)
oPrint:Line(nLin-172,nColFim,nLin,nColFim)//vertical 
oPrint:Line(nLin,nColIni,nlin,nColFim)//horizontal   

if nlin >= 3000
	oPrint:EndPage()
	nLinUlt :=150
	nLin := nLinUlt
endif           

//Impressao do peso por classificacao (Media Ponderada)
//Variaveis de vaqueta por class (totalizadora)-> nVC2 / nVD2 / nVE2 / nVER2 / nPltVq
// (Peso_total * Qtd_vq_class) / Qtd_vq_tot

nPesC  := Round(((cGetPes * nVC2) / nPltVq),2)
nPesD  := Round(((cGetPes * nVD2) / nPltVq),2)
nPesE  := Round(((cGetPes * nVE2) / nPltVq),2)
nPesER := Round(((cGetPes * nVER2) / nPltVq),2)
nPesT  := (nPesC+nPesD+nPesE+nPesER)

//Contando quantas classificações existem no pallet para fazer cálculo de peso do pallet e distribuição por class na gravação de ZZL_PESOL.
If nPesC > 0
	nCount ++
Endif
If nPesD > 0
	nCount ++
Endif
If nPesE > 0
	nCount ++
Endif
If nPesER > 0
	nCount ++
Endif 
//////////////////////////////////

nLin += 25
nLin3 := nLin
oPrint:Line(nLin,nColIni,nlin+350,nColIni)//vertical
oPrint:Line(nLin,nCol2-100,nlin+350,nCol2-100)//vertical
oPrint:Line(nLin,nColIni,nlin,nCol2-100)//horizontal  
oPrint:Say(nLin+10,nColIni+100,"PESO POR CLASSIFICAÇÃO",oFontAr10n)
oPrint:Say(nLin+50,nColIni+140,"WEIGHT PER CLASS",oFontAr10n)
nLin += 100
oPrint:Line(nLin,nColIni+140,nLin+250,nColIni+140)//vertical
oPrint:Line(nLin,nColIni,nlin,nCol2-100)//horizontal  
oPrint:Say(nLin+10,nColIni+10,"C",oFontAr10n)
oPrint:Say(nLin+10,nColIni+150,cValToChar(nPesC),oFontAr10)
nLin += 50
oPrint:Line(nLin,nColIni,nlin,nCol2-100)//horizontal  
oPrint:Say(nLin+10,nColIni+10,"D",oFontAr10n)
oPrint:Say(nLin+10,nColIni+150,cValToChar(nPesD),oFontAr10)
nLin += 50                                   
oPrint:Line(nLin,nColIni,nlin,nCol2-100)//horizontal  
oPrint:Say(nLin+10,nColIni+10,"E",oFontAr10n)
oPrint:Say(nLin+10,nColIni+150,cValToChar(nPesE),oFontAr10)
nLin += 50                                   
oPrint:Line(nLin,nColIni,nlin,nCol2-100)//horizontal  
oPrint:Say(nLin+10,nColIni+10,"ER",oFontAr10n)
oPrint:Say(nLin+10,nColIni+150,cValToChar(nPesER),oFontAr10)
nLin += 50                                   
oPrint:Line(nLin,nColIni,nlin,nCol2-100)//horizontal  
oPrint:Say(nLin+10,nColIni+10,"TOTAL",oFontAr10n)
oPrint:Say(nLin+10,nColIni+150,cValToChar(nPesT),oFontAr10)
nLin += 50          
oPrint:Line(nLin,nColIni,nlin,nCol2-100)//horizontal  

//Impressao dos dados de altura/largura/comprimento -> cGetAlt,cGetLarg,cGetComp,cGetPes 
nLin3 += 100
oPrint:Line(nLin3,nCol4,nlin3+150,nCol4)//vertical
oPrint:Line(nLin3,nCol7,nlin3+150,nCol7)//vertical
oPrint:Line(nLin3,nCol4,nlin3,nCol7)//horizontal 
oPrint:Line(nLin3,nCol6,nlin3+150,nCol6)//vertical
oPrint:Say(nLin3+10,nCol4+10,"ALTURA(HEIGHT)",oFontAr10n)
oPrint:Say(nLin3+10,nCol6+10,cValToChar(cGetAlt),oFontAr10n)
nLin3 += 50
oPrint:Line(nLin3,nCol4,nlin3,nCol7)//horizontal 
oPrint:Say(nLin3+10,nCol4+10,"LARGURA(WIDTH)",oFontAr10n)
oPrint:Say(nLin3+10,nCol6+10,cValToChar(cGetLarg),oFontAr10n)
nLin3 += 50
oPrint:Line(nLin3,nCol4,nlin3,nCol7)//horizontal 
oPrint:Say(nLin3+10,nCol4+10,"COMPRIMENTO(LENGTH)",oFontAr10n)
oPrint:Say(nLin3+10,nCol6+10,cValToChar(cGetComp),oFontAr10n)
nLin3 += 50
oPrint:Line(nLin3,nCol4,nlin3,nCol7)//horizontal           

if nlin >= 4500
	oPrint:EndPage()
	nLinUlt :=150
	nLin := nLinUlt
endif           

//Impressao do num. do pallet no final da folha
nLin += 25                                        
oPrint:Line(nLin,nColIni,nlin+150,nColIni)//vertical
oPrint:Line(nLin,nColIni,nlin,nColFim)//horizontal  
oPrint:Say(nLin+10,nCol2,"PALLET Nº: ",oFontAr24n)
oPrint:Say(nLin+10,nCol4,cGetPlt,oFontAr24n)      

oPrint:Say(nLin+100,nCol2,"LOTE:",oFontAr24n)
oPrint:Say(nLin+100,nCol4,crtLote,oFontAr24n)
	
nLin += 200
oPrint:Line(nLin,nColIni,nlin,nColFim)//horizontal
oPrint:Line(nLin-150,nColFim,nlin,nColFim)//vertical

//Fim da impressao do rodape



//Sera executado somente se for inclusao ou alteracao
If cFina == "I" .Or. cFina == "A"
/*
Alert ('Lote C: ' + LotC)
Alert ('Lote D: ' + LotD)
Alert ('Lote E: ' + LotE)
Alert ('Lote ER: ' + LotER)
*/      
	//Verifica se tabelas temporias existem e encerra as mesmas antes de executar as novas
	if Select("TMPB1") > 0 
		dbSelectArea("TMPB1")
		TMPB1->(dbCloseArea())
	endif
	
	//Filtrando todos os codigos filhos a partir do código de producao
	cQuery := " SELECT B1_COD, B1_X_ARTPR, B1_X_CLASS "
	cQuery += " FROM SB1010 "
	cQuery += " WHERE   B1_FILIAL = '"+xFilial("SB1")+"' "
	cQuery += " 	AND B1_X_ARTPR = '"+cGetCodPro+"' "
	cQuery += " 	AND D_E_L_E_T_ <> '*' "
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN", tcGenQry(,,cQuery),"TMPB1",.F.,.T.)
	
	dbSelectArea("TMPB1")
	TMPB1->(dbGotop())
	
	//Filtrando os códigos de exportacao (por classificacao) a partir do código de producao
	While TMPB1->(!EOF())

		Do Case
			Case TMPB1->B1_X_CLASS == 'C '
				cCod  := TMPB1->B1_COD
				nPeso := nPesC
				nVQ   := nVC2
				nM2   := nMC2
				cLote := LotC
				cClass:= TMPB1->B1_X_CLASS
			Case TMPB1->B1_X_CLASS == 'D '
				cCod  := TMPB1->B1_COD
				nPeso := nPesD
				nVQ   := nVD2
				nM2   := nMD2
				cLote := LotD
				cClass:= TMPB1->B1_X_CLASS
			Case TMPB1->B1_X_CLASS == 'E '
				cCod  := TMPB1->B1_COD
				nPeso := nPesE
				nVQ   := nVE2
				nM2   := nME2
				cLote := LotE 
				cClass:= TMPB1->B1_X_CLASS
			Case TMPB1->B1_X_CLASS == 'ER'
				cCod  := TMPB1->B1_COD
				nPeso := nPesER
				nVQ   := nVER2
				nM2   := nMER2
				cLote := LotER
				cClass:= TMPB1->B1_X_CLASS
		EndCase  
		
	
		//Inicio da gravacao dos registros na tabela ZZL
	    DbSelectArea('ZZL')
	    DbSetOrder(1)
	    
	    If !ZZL->(DbSeek(xFilial('ZZL')+cGetPlt+cCod))//Se nao localizar o registro sera incluido
	    
		    If nVQ > 0
	
				RecLock('ZZL',.T.)//Inclui
				
				ZZL->ZZL_FILIAL := xFilial('ZZL')
				ZZL->ZZL_ARTPRO := cGetCodPro
				ZZL->ZZL_ARTEXP := cCod
				ZZL->ZZL_NPLT   := cGetPlt
				ZZL->ZZL_PESOB  := nPeso
				ZZL->ZZL_PESOL  := nPeso - (nPesoPlt / nCount) //Peso bruto menos peso do pallet dividido pelo qtde de class existentes
				ZZL->ZZL_HEIGHT := cGetAlt
				ZZL->ZZL_WIDTH  := cGetLarg
				ZZL->ZZL_LENGTH := cGetComp
				ZZL->ZZL_SIDES  := nVQ
				ZZL->ZZL_SQM1   := nM2
				ZZL->ZZL_LOTE   := cLote
				ZZL->ZZL_SQMTOT := nM2
				ZZL->ZZL_CLIENT := cGetCli
				ZZL->ZZL_LOJACL := cSayLj
				ZZL->ZZL_EMISSA := dDatabase
				ZZL->ZZL_PESOTP := nPesT
				ZZL->ZZL_CLASS  := cClass				

				MsUnlock('ZZL')
			Endif
		Else                      						//Caso encontre sera alterado
		    If nVQ > 0
			    
				RecLock('ZZL',.F.)//Altera
				
				ZZL->ZZL_FILIAL := xFilial('ZZL')
				ZZL->ZZL_ARTPRO := cGetCodPro
				ZZL->ZZL_ARTEXP := cCod
				ZZL->ZZL_NPLT   := cGetPlt
				ZZL->ZZL_PESOB  := nPeso
				ZZL->ZZL_PESOL  := nPeso - (nPesoPlt / nCount) ///Peso bruto menos peso do pallet dividido pelo qtde de class existentes
				ZZL->ZZL_HEIGHT := cGetAlt
				ZZL->ZZL_WIDTH  := cGetLarg
				ZZL->ZZL_LENGTH := cGetComp
				ZZL->ZZL_SIDES  := nVQ
				ZZL->ZZL_SQM1   := nM2
				ZZL->ZZL_LOTE   := cLote
				ZZL->ZZL_SQMTOT := nM2
				ZZL->ZZL_CLIENT := cGetCli
				ZZL->ZZL_LOJACL := cSayLj
				ZZL->ZZL_EMISSA := dDatabase
				ZZL->ZZL_PESOTP := nPesT				
				ZZL->ZZL_CLASS  := cClass
				
				MsUnlock('ZZL')				
			Endif
	    Endif
	    
		TMPB1->(dbSkip())

    Enddo			    
	   
Endif

oPrint:EndPage()
oPrint:Preview()  		// Visualizar todos antes de enviar para impressora

Return 

//Inicio da funcao para input das informacoes para gerar o romaneio
User Function VSS_GROM

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cGetAlt    := 0
Private cGetCli    := Space(6)
Private cGetCodPro := Space(6)
Private cGetComp   := 0
Private cGetLarg   := 0
Private cGetPes    := 0
Private cGetPlt    := Space(14)
Private cSayAlt    := Space(10)
Private cSayCli    := Space(10)
Private cSayLj 	   := Space(2)
Private cSayDPais  := Space(25)
Private cSayDesc1  := Space(50)
Private cSayLarg   := Space(10)
Private cSayLarg   := Space(10)
Private cSayPes    := Space(10)
Private cSayPes    := Space(10)
Private cSayPlt    := Space(10)
Private cSayPro    := Space(10)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlg3","oSayPro","oSayPlt","oSayAlt","oSayLarg","oSay2","oSayPes","oSay3","oSayDesc1","oSayLj","oSayDPais")
SetPrvt("oGetCodPro","oGetPlt","oGetAlt","oGetLarg","oGetComp","oGetPes","oGetCli","oBtn1","oBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg3      := MSDialog():New( 122,378,381,1123,"Emissão de Romaneio",,,.F.,,,,,,.T.,,,.T. )
oSayPro    := TSay():New( 008,009,{||"ARTIGO:"},oDlg3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,010)
oSayPlt    := TSay():New( 022,009,{||"PALETE:"},oDlg3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,010)
oSayAlt    := TSay():New( 035,009,{||"ALTURA:"},oDlg3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,010)
oSayLarg   := TSay():New( 048,009,{||"LARGURA:"},oDlg3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,010)
oSay2      := TSay():New( 060,009,{||"COMPRIMENTO:"},oDlg3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,059,010)
oSayPes    := TSay():New( 072,009,{||"PESO:"},oDlg3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,059,010)
oSay3      := TSay():New( 084,009,{||"CLIENTE:"},oDlg3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,059,010)
oSayDesc1  := TSay():New( 008,156,{|u| If(PCount()>0, cSayDesc1:=u, cSayDesc1)},oDlg3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_LIGHTGRAY,201,012)
oGetCodPro := TGet():New( 008,068,{|u| If(PCount()>0,cGetCodPro:=u,cGetCodPro)},oDlg3,090,010,'',{|| RefreDesc()},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ARTEXP","cGetCodPro",,)
oGetPlt    := TGet():New( 020,068,{|u| If(PCount()>0,cGetPlt:=u,cGetPlt)},oDlg3,090,010,'',{|| Vld_plt()},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"PLTEXP","cGetPlt",,)
oGetAlt    := TGet():New( 032,068,{|u| If(PCount()>0,cGetAlt:=u,cGetAlt)},oDlg3,048,010,'@E 99,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetAlt",,)
oGetLarg   := TGet():New( 044,068,{|u| If(PCount()>0,cGetLarg:=u,cGetLarg)},oDlg3,048,010,'@E 99,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetLarg",,)
oGetComp   := TGet():New( 056,068,{|u| If(PCount()>0,cGetComp:=u,cGetComp)},oDlg3,048,010,'@E 99,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetComp",,)
oGetPes    := TGet():New( 068,068,{|u| If(PCount()>0,cGetPes:=u,cGetPes)},oDlg3,048,010,'@E 99,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetPes",,)
oGetCli    := TGet():New( 080,068,{|u| If(PCount()>0,cGetCli:=u,cGetCli)},oDlg3,048,010,'',{|| RefreCli()},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CLIEXP","cGetCli",,)
oSayLj     := TSay():New( 082,120,{|u| If(PCount()>0, cSayLj:=u, cSayLj)},oDlg3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_LIGHTGRAY,237,010)
oSayCli    := TSay():New( 082,150,{|u| If(PCount()>0, cSayCli:=u, cSayCli)},oDlg3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_LIGHTGRAY,237,010)
oSayDPais  := TSay():New( 092,150,{|u| If(PCount()>0, cSayDPais:=u, cSayDPais)},oDlg3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_LIGHTGRAY,237,010)
oBtn1      := TButton():New( 110,252,"Gera Romaneio",oDlg3,{|| Ger_Rom()},044,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 110,308,"Cancelar",oDlg3,{|| oDlg3:End()},041,012,,,,.T.,,"",,,,.F. )

oDlg3:Activate(,,,.T.)

Return

//Atualiza a Descricao do produto
Static function RefreDesc()
	DbSelectArea('SB1')
	DbSetOrder(1)
	
	If DbSeek(xFilial('SB1')+cGetCodPro)
		cSayDesc1 := SB1->B1_DESC
		oSayDesc1:Refresh()
		
		If SB1->B1_X_DEST <> 'E'
			Alert ('Este produto não está parametrizado para ser exportado. Favor informar o administrador do sistema ou verificar o campo Destino de produção no cadastro do produto.')
			oGetCodPro:SetFocus()
			Return
		Endif
		
		If SB1->B1_X_SIGLA == Space(4)
			Alert('Favor informar o responsável para verificar o cadastro do produto e informar uma sigla para montagem do pallet...')
			oGetCodPro:SetFocus()
			Return
		Endif
		
	Else
		Alert('Produto informado inválido...')
		oGetCodPro:SetFocus()
		Return
	Endif
	
Return

//Valida Num Palete
Static function Vld_plt    

Local PltStat := 'N' //Status do Pallet -> Se concluido "S" ou não concluido "N"

//Finalidade do Romaneio-> V=Visualizar(Só monta as informacoes) / I=Incluir (Add um novo na Tabela ZZL) / A=Alterar (Altera um existente na tabela ZZL)
Public cFina

	DbSelectArea('SD3')
	SD3->(DbOrderNickName("PLT_OP_DOC"))
//	DbSetOrder(12)
	
	If SD3->(DbSeek(xFilial('SD3')+cGetPlt))
		If SD3->D3_COD <> cGetCodPro
			Alert('O Pallet selecionado não corresponde ao Artigo informado. Favor verificar!')
			oGetCodPro:SetFocus()
			Return
		endif  
		
		//Verifica se ja existe um romaneio gravado na tabela ZZL
		DbSelectArea('ZZL')
		ZZL->(DbSetOrder(1))
		If ZZL->(DbSeek(xFilial('ZZL')+cGetPlt))
			If MsgNoYes ('Já existe um Romaneio gerado para o Pallet '+ cGetPlt +'. Clique em SIM para Alterar o romaneio existente, ou clique em NÃO para visualizar o romaneio existente.')
				cFina := "A" //Alterar romaneio
				
				cGetAlt  := ZZL->ZZL_HEIGHT
				cGetLarg := ZZL->ZZL_WIDTH
				cGetComp := ZZL->ZZL_LENGTH
				cGetPes  := ZZL->ZZL_PESOTP
				cGetCli  := ZZL->ZZL_CLIENT
				
				oGetAlt:Enable()
				oGetLarg:Enable()
				oGetComp:Enable()
				oGetPes:Enable()
				oGetCli:Enable()
				RefreCli()
				
				oGetAlt:Refresh()
				oGetLarg:Refresh()
				oGetComp:Refresh()
				oGetPes:Refresh()
				oGetCli:Refresh()
			else
				cFina := "V" //Visualizar romaneio
				
				cGetAlt  := ZZL->ZZL_HEIGHT
				cGetLarg := ZZL->ZZL_WIDTH
				cGetComp := ZZL->ZZL_LENGTH
				cGetPes  := ZZL->ZZL_PESOTP
				cGetCli  := ZZL->ZZL_CLIENT
				
				oGetAlt:Disable()
				oGetLarg:Disable()
				oGetComp:Disable()
				oGetPes:Disable()
				oGetCli:Disable()
				RefreCli()				
				
				oGetAlt:Refresh()
				oGetLarg:Refresh()
				oGetComp:Refresh()
				oGetPes:Refresh()
				oGetCli:Refresh()
								
			endif
		Else
			DbSelectArea('SD3')
			SD3->(DbOrderNickName("PLT_CONCL"))
//			DbSetOrder(13)
			If SD3->(DbSeek(xFilial('SD3')+cGetPlt+PltStat))
				If MsgNoYes ('O Pallet selecionado ainda não foi concluído. Clique em SIM para continuar em modo visualização, ou em NÃO para abortar o processo."')
					cFina := "V" //Visualizar romaneio
					
					cGetAlt  := 0
					cGetLarg := 0
					cGetComp := 0
					cGetPes  := 0
					cGetCli  := Space(6)
					
					oGetAlt:Disable()
					oGetLarg:Disable()
					oGetComp:Disable()
					oGetPes:Disable()
					oGetCli:Disable()
					
					oGetAlt:Refresh()
					oGetLarg:Refresh()
					oGetComp:Refresh()
					oGetPes:Refresh()
					oGetCli:Refresh()
				else
					Return
				endif
			Else
				cFina := "I" //Incluir romaneio
				
				oGetAlt:Enable()
				oGetLarg:Enable()
				oGetComp:Enable()
				oGetPes:Enable()
				oGetCli:Enable()
				
				oGetAlt:Refresh()
				oGetLarg:Refresh()
				oGetComp:Refresh()
				oGetPes:Refresh()
				oGetCli:Refresh()
			Endif
		EndIf
	Else
		Alert('O Pallet Informado não é válido. Favor verificar!')
		oGetPlt:SetFocus()
		Return
	Endif
Return


//Atualiza a Loja, Nome e Descricao do cliente
Static function RefreCli()
	DbSelectArea('SA1')
	DbSetOrder(1)
	
	If Dbseek(xFilial('SA1')+cGetCli)
		cSayCli := SA1->A1_NOME
		cSayLj := Sa1->A1_LOJA
		cSayDPais:= SA1->A1_X_DPAIS
		oSayCli:Refresh()     
		oSayLj:Refresh()
		oSayDPais:Refresh()
		
		If SA1->A1_X_CLIEX <> 'S'
			Alert ('Este cliente não está parametrizado para exportação. Favor informar ao administrador do sistema ou verificar o cadastro do cliente.')
			oGetCli:SetFocus()
			Return
		endif
	else
		Alert('Campo cliente está em branco ou o código digitado não está cadastrado. Favor informar um cliente válido para exportação!')
		oGetCli:SetFocus()
		Return
	Endif
Return

//Inicia a geração do romaneio
Static function Ger_Rom()

//Verifica se algum dos campos abaixo esta zerado, e pergunta se deseja continuar mesmo assim   

If cFina == 'I' .Or. cFina == 'A'
	If cGetAlt == 0 .Or. cGetLarg == 0 .Or. cGetComp == 0 .Or. cGetPes == 0
		If MsgNoYes ("Faltou preencher algumas informações na tela(Altura, Largura, Comprimento ou Peso). Deseja continuar mesmo assim?")
			U_VSS_RMNEIO (cGetCodPro,cGetPlt,cGetAlt,cGetLarg,cGetComp,cGetPes,cGetCli,cSayCli,cSayLj,cSayDesc1,cSayDPais,cFina)
		Else              
			Return
		endif
	Else    
		U_VSS_RMNEIO (cGetCodPro,cGetPlt,cGetAlt,cGetLarg,cGetComp,cGetPes,cGetCli,cSayCli,cSayLj,cSayDesc1,cSayDPais,cFina)
	endif
Else                          
	U_VSS_RMNEIO (cGetCodPro,cGetPlt,cGetAlt,cGetLarg,cGetComp,cGetPes,cGetCli,cSayCli,cSayLj,cSayDesc1,cSayDPais,cFina)
EndIf

Return