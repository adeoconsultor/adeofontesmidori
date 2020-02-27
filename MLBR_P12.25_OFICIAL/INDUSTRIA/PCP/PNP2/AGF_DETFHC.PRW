#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#include "COLORS.CH"
//---------------------------------
/*
Este Programa tem como objetivo consultar as fichas de corte a partir do plano informado
Desenvolvido por Anesio G.Faria 15-05-2012
Parametros:
01 - RECNO da Tabela SC2
*/
User Function AGF_DETFHC(  nRecSc2  )
//
Private oFontSay ,oFontSayB,oFontDad,obrProds,cBanco,obrfics,cfics,ochkAll
Private tchkAll := .T.
Private acPrds := {}
Private cMainOp := SZP->ZP_NUM   //  Ordem de Producao Principal
Private cPlano  := SZP->ZP_OPMIDO // Numero do Plano 
Private cAno    := SZP->ZP_ANO //Ano que foi gerado a OP
Private cConsLdo:= SZP->ZP_LADO // Considera Lado S ou N 
Private aGrpOps := {} // Array contendo os grupos de produtos
Private aGrpDispAux := {} // Array que acumulara as Materias Primas Por Produto Intermediario, quebrando as quantidades para cada um destes
Private aGrpAuxOps := {} // Array que acumulara as Materias Primas Por Produto Intermediario, quebrando as quantidades para cada um destes
Private aGrpPVC := {} // Array que vai armazenar as fichas de PVC do artigo 239L para fazer ao invez de multiplos de 10, multiplos de 50 - (desenvolvido por anesio) cfe HDi 003955 
Private aPrdPVC := {} // Array que vai armazenar o codigo do material de PVC (desenvolvido por anesio) cfe HDi 003955 
Private cGerFCPVC  := Getmv( 'MV_GRMUPVC' )
Private nQtMultPVC := Getmv( 'MV_QTMUPVC' )
Private nLotQuebra := 0 // Variavel que contem a quantidade de quebra por ficha
Private oOk := LoadBitmap( GetResources(), "LBOK")
Private oNo := LoadBitmap( GetResources(), "LBNO")
Private  aPisFic := {}
Private lTemFicha := .F. // Flag informando que ainda nao tem fichas de corte lancados para a ordem de producao
Private lTemFcApont := .f. // Flag indicando se ha alguma ficha ja apontada
Private nLin
Private wnrel   := "FICORTE"
Private aLados  := { 'A', 'B', 'C' } // Array contendo os lados para processamento, mesmo se houver necessidade de se abrir para outros lados, o sistema estara pronto para atender
Private lLado     := .F.
Private lCBxFicPcD:= .F.
Private cCtrl := ""
Private cDescKit := ""
Private cCodMat  := ""
Private cCodKit  := ""
Private cDescSZI := ""
Private cDescUM  := ""
Private lDescSZI := .F.
//
//
Private cEsc   :=Chr(27)
Private OnExp := cEsc + 'W1'
Private OffExp := cEsc + 'W0'
//
Private OnNeg := cEsc + 'G'
Private OffNeg := cEsc + 'H'
//
Private OnSubs := cEsc +'-1'
Private OffSubs := cEsc +'-0'
Private nQtPlano := 0   
//
//
// Ja posicionando na ordem de producao principal
DbSelectArea('SZP')
DbSetOrder(1)
DbSeek(   xFilial('SZP') + cMainOp )  //  Posicionando na OP Principal
lLado     := iif( SZP->ZP_lado == 'S', .T. , .F. )
//
//
nLotQuebra := SZP->ZP_MULTPLO // Aqui ja posicionando a quantidade por lote de quebra
nQtPlano   := SZP->ZP_QUANT
//
DEFINE FONT oFontSay     NAME "Arial"    SIZE 0,16  BOLD
DEFINE FONT oFontSayb   NAME "Arial"    SIZE 0,16  BOLD UNDERLINE
DEFINE FONT oFontDad     NAME "Arial"    SIZE 0,16
//
DEFINE MSDIALOG oDlgDet1 FROM 000,000 TO 600,1200  TITLE "FICHAS DE CORTE - Detalhes do Plano" PIXEL
//
//
/*
@ 01,01 	to 40, 602
@ 42,01 	to 295, 300
@ 42,301 	to	260, 602
@ 262,301 	to	295, 602
*/


@ 10, 5 say "Plano:" 			Color CLR_HBLUE object oObj1
@ 10, 80 say "Num.CTRLE:" 	Color CLR_HBLUE object oObj2
@ 10,170 say "Emissão:" 	Color CLR_HBLUE object oObj3
@ 10,240 say "Cliente: " 	Color CLR_HBLUE object oObj4
//
// @ 10,25  say SC2->C2_OPMIDO 			object oObj6
@ 07,25 BUTTON SZP->ZP_OPMIDO   SIZE 50 ,12  of oDlgDet1 Pixel // ACTION  e_fabric()


@ 10, 116 say SZP->ZP_NUM 	 			object oObj7
@ 10,200 say Dtoc( SZP->ZP_EMISSAO )		object oObj8
@ 07,265 BUTTON SZP->ZP_CLIENTE  + "/" + ZP_LOJA 	 + '-'+ Alltrim(Posicione('SA1' , 1 , xFilial('SA1') + SZP->ZP_CLIENTE + SZP->ZP_LOJA, 'A1_NOME'    )  );
SIZE 200,12  of oDlgDet1 Pixel // ACTION  e_fabric()

//
@ 10,475   say "Release: " 	Color CLR_HBLUE object oObj5
@ 10 ,500   say Alltrim(  SZP->ZP_RELEASE  )  +'-' +  Dtoc( ZP_DTRELEA) 	object oObj12
//
@ 25,05  say "Produto: " 	Color CLR_HBLUE object oObj9
@  23,35 BUTTON Alltrim(ZP_PRODUTO) + '-' +  Alltrim( ZP_DESCPRD  ) ;
SIZE 175,12  of oDlgDet1 Pixel // ACTION  e_fabric()

@ 25,220   say "Qtde. : " 	Color CLR_HBLUE object oObj10
@ 25,240   say Alltrim( Transform( SZP->ZP_QUANT , '@E 99,999,999.9999')  )   	object oObj11
@ 25,280   say "Previsão: " 	Color CLR_HBLUE object oObj13
@ 25,310   say Dtoc( SZP->ZP_DATPRF )  	object oObj14
@ 25,350   say "Multiplos : " 	Color CLR_HBLUE object oObj15
@ 25,383   say Alltrim( Transform( SZP->ZP_MULTPLO , '@E 99999999')  )  + '   Peça'+ iif(SZP->ZP_MULTPLO > 1, 's','' )  	object oObj16
oCBxFicPcD := TCheckBox():New( 024,450,"Gerar Fichas PCs Dubladas ",{|u| If(PCount()>0,lCBxFicPcD:=u,lCBxFicPcD)},oDlgDet1,080,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
@ 23,542   BUTTON "Gerar Fichas"       SIZE 56,12   ACTION  Processa( {|| GeraFic()}, 'Gerando Ficha de Corte...' )     of oDlgDet1 Pixel //
//
oObj1:setfont(oFontSay )
oObj2:setfont(oFontSay )
oObj3:setfont(oFontSay)
oObj4:setfont(oFontSay)
oObj5:setfont(oFontSay)
oObj9:setfont(oFontSay)
oObj10:setfont(oFontSay)
oObj13:setfont(oFontSay)
oObj15:setfont(oFontSay)
//
oObj7:setfont(oFontDad )
oObj8:setfont(oFontDad )
oObj11:setfont(oFontDad )
oObj12:setfont(oFontDad )
oObj14:setfont(oFontDad )
oObj16:setfont(oFontDad )
//
DbSelectArea('SZP')
DbSetOrder(1)
DbSeek(   xFilial('SZP') + cMainOp  )  //  Posicionando na OP Principal
//                                                               

Carr_GrOPS() // Carregando os itens por grupo de produtos na op
Carr_PrOPS() // fUNCAO QUE CARREGA OS ITENS DA OP
//

aGrpOps := aSort( aGrpOps,2,, { |x, y| x[1] < y[1] } )
//
IF LEN(acPrds ) == 0
	acPrds := { space( 15 ), space( 30 ) ,  0 , 0 , 0, '' }
Endif
// AAdd(acPrds, { 'Produto 1 ', 'Descri 1 '} )
//
acFics := {}
CARR_SZ3() // Verifica se ha fichas de corte ja geradas no Arquivo SZ3 para o plano

//
//
@ 45,05 LISTBOX obrProds VAR cBanco Fields HEADER "Codigo","Descricao" , "Qtde OP","Qtde M2"  ON CHANGE ChngGrpPrs() SIZE 290,117  pixel // ON CHANGE CHNG() ON DBLCLICK Ad_PrLst()
obrProds:SetArray(acPrds)
obrProds:bLine := { || { acPrds[obrProds:nAt,1],acPrds[obrProds:nAt,2],acPrds[obrProds:nAt,3],acPrds[obrProds:nAt,4]   }  }
//
AAdd( aGrpDispAux , {space(10),space(30),space(10)   }  )
//
@ 45,305 LISTBOX obrAuxProds VAR cPrsAux Fields HEADER  "Codigo","Descricao" , "Qtde OP", "Qtde M2", "Padrao M2" SIZE 290,117  pixel // ON CHANGE ChngGrpPrs()  ON DBLCLICK Ad_PrLst()
obrAuxProds:SetArray( aGrpDispAux )
obrAuxProds:bLine := { || { aGrpDispAux[obrAuxProds:nAt,1] , aGrpDispAux[obrAuxProds:nAt,2] , aGrpDispAux[obrAuxProds:nAt,3] , aGrpDispAux[obrAuxProds:nAt,4] }  }
//
//AAdd( aGrpAuxOps , { SG1->G1_COMP , ALLTRIM( SB1->B1_DESC ) , SC2->C2_PRODUTO , SC2->C2_QUANT, SG1->G1_QUANT,SC2->C2_QUANT * SG1->G1_QUANT  }  )
//

@ 165,05  LISTBOX obrfics VAR cFics Fields HEADER "   ",'Numero da Ficha','Dta Ficha','Tipo' ,'Dt Apont', 'Material' , "Faca","Descricao", "Qtde ","Total M2" ,"M2 Padrao", 'Num Cartao'  SIZE 589,113  ON DBLCLICK clk_LST() pixel // ON CHANGE CHNG() ON DBLCLICK Ad_PrLst()
obrfics:SetArray(acFics)
obrfics:bLine := { || { iif( acFics[obrfics:nAt,1], ook, oNo ) , acFics[obrfics:nAt,2],acFics[obrfics:nAt,3],acFics[obrfics:nAt,4],acFics[obrfics:nAt,5] , acFics[obrfics:nAt,6] , acFics[obrfics:nAt,7], acFics[obrfics:nAt,8], acFics[obrfics:nAt,9], acFics[obrfics:nAt,10], acFics[obrfics:nAt,11], acFics[obrfics:nAt,12] }  }

//
@ 285 , 05  CHECKBOX ochkAll VAR tchkAll PROMPT 'Todas as Fichas' ON CHANGE CHNG_LST()  OF  oDlgDet1  SIZE 60,12  FONT oFontSay COLOR CLR_BLUE   PIXEL
@  285 ,80  BUTTON "Imprimir Fichas"       SIZE 56,12  ACTION  Imp_Fch() of oDlgDet1 Pixel // ACTION  Imp_Fch()
//@  285 ,80  BUTTON "Imprimir Fichas"       SIZE 56,12  of oDlgDet1 Pixel // ACTION  Imp_Fch()
//@ 285  ,200 BUTTON 'Imp Grafico'  SIZE 56,12 ACTION U_MD1_GRFCORG(cMainOp, SZP->ZP_OPMIDO) of oDLGDet1 Pixel 
//@ 285  ,200 BUTTON 'Imp Grafico'  SIZE 56,12  of oDLGDet1 Pixel 
//

Activate Dialog oDlgDet1 Centered
//
Return()
//------------------------------------------------------------
Static Function clk_LST()
Local cFicMain := acFics[obrfics:nAt,2]
Local lFlagChk  := acFics[obrfics:nAt,1]
Local nn1

//
For nn1 := 1 to len( acFics )
	if acFics[nn1 , 2 ] == cFicMain
		if !  lFlagChk
			acFics[nn1 , 1 ]  := .t.
		Else
			acFics[nn1 ,1 ]  := .f.
		Endif
	Endif
Next
obrfics:REfresh()
//
Return()
//-------------------------------------------------------------
Static Function CHNG_LST()
Local nn1
//Alert('Tamanho do Array -> '+cValToChar(len(acFics)))
For nn1 := 1 to len( acFics )
	if tchkAll
		acFics[nn1 , 1 ]  := .t.
	Else
		acFics[nn1 ,1 ]  := .f.
	Endif
Next
obrfics:REfresh()
Return()
//-------------------------------------------------------------

/*
A funcao abaixo tem como objetivo carregar a Estrutura dos produtos com todas as ops carregadas, a partir do plano de producao gerado
*/
Static Function Carr_PrOPS()
//
Local nn1
acPrds := {}
//
DbSelectArea('SZP')
DbSetOrder(1)
if DbSeek(   xFilial('SZP') + cMainOp   )  //  Posicionando na OP Principal
	//
	AAdd( acPrds, {'TODOS', 'TODOS OS PRODUTOS             ' ,Transform( 0, '@E 999,999')  , Transform( 0 , '@E 99,999.9999') , Transform( 0, '@E 9,999.9999')  , ' '  }  )
	//
	// O bloco abaixo tem como objetivo descarregar os grupos de produtos
	For nn1 := 1 to len( aGrpOps )
		AAdd( acPrds, { aGrpOps[ nn1,1 ] ,   Substr( aGrpOps[ nn1,2 ],1,30 )  ,Transform( aGrpOps[ nn1 , 4  ] , '@E 999,999')  , Transform( aGrpOps[ nn1,3 ] , '@E 99,999.9999') , Transform( 0, '@E 9,999.9999')  , ' '  }  )
	Next
Endif
//

Return()
//------------------------------------------------------------
/*
A funcao abaixo tem como objetivo carregar os grupos de produtos que estao dentro da op
*/
Static Function Carr_GrOPS()
local cPlano := '' 
local cAno   := ''
Local nQtNivel

//
aGrpOps := {} // Array contendo os grupos de produtos
//
nRecSZP := SZP->( Recno() )

dbSelectArea('SZP')
dbSetOrder(1)
dbSeek(xFilial('SZP')+cMainOP)
	cPlano := SZP->ZP_OPMIDO
	cAno   := SZP->ZP_ANO

	//Verifica se a quantidade de Multiplo for igual a quantidade original, altera o PVC para multiplos iguais ao original.
	if SZP->ZP_QUANT == SZP->ZP_MULTPLO	
		nQtMultPVC := SZP->ZP_MULTPLO
	endif
                               

cQSC2 := " SELECT C2_FILIAL, C2_NUM, C2_OPMIDO, C2_PRODUTO, C2_QUANT, C2_EMISSAO FROM dbo.SC2010 WHERE D_E_L_E_T_ = ' ' "
cQSC2 += " AND C2_FILIAL = '"+xFILIAL("SC2")+"' AND C2_OPMIDO = '" +cPLANO+"' AND SUBSTRING(C2_EMISSAO,1,4) = '"+cAno+"' " 
cQSC2 += " ORDER BY C2_NUM " 

if select('TRBC2') > 0
	DbSelectArea( 'TRBC2' )
	DbCloseArea()
Endif
//
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQSC2),'TRBC2',.T.,.T. )

ncount := 0
dbSelectArea('TRBC2')
DbGoTop()
while !TRBC2->(eof())
	nCount++
	TRBC2->(dbSkip())
enddo
	
if nCount == 0 
	Alert('Op Principal do Plano nao Encontrada. Entre em contato com o Administrador do Sistema.')
	Return()
Endif
//
cProdPA := SZP->ZP_PRODUTO // Produto principal
//



dbSelectArea('SZP')
dbSetOrder(1)
dbSeek(xFilial('SZP')+cMainOP)
While !SZP->(eof()) .and. ZP_FILIAL == xFilial('SZP') .and.  ZP_NUM  == cMainOp
	//
	cNumSup1 :=  '' // Numero Superior do Lancamento
	cProdPI1    := SZP->ZP_PRODUTO // Produto principal
	//
	//
	if Select("TRBC2") > 0
		dbSelectArea("TRBC2")
		dbCloseArea()
	endif
	
	cQSC2 := " SELECT C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO, C2_QUANT FROM SC2010 where D_E_L_E_T_ = ' ' and C2_FILIAL = '"+xFilial("SC2")+"' and C2_OPMIDO = '"+SZP->ZP_OPMIDO+"' AND Substring(C2_EMISSAO,1,4)= '"+SZP->ZP_ANO+"' " 
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQSC2),'TRBC2',.T.,.T. )	
	

	while !TRBC2->(eof())
		cLadoAux := Posicione('SB1',1,xFilial('SB1')+TRBC2->C2_PRODUTO,"B1_LADO")
		cLadob1           := iif( !empty(cLadoAux), cLadoAux, 'A' )
		cComp := Posicione('SG1',1,xFilial('SG1')+TRBC2->C2_PRODUTO, "G1_COMP")
		nQuant := Posicione('SG1',1,xFilial('SG1')+TRBC2->C2_PRODUTO, "G1_QUANT")
//		Alert('PECA -> '+TRBC2->C2_PRODUTO+' COMPONENTE -> '+cCOMP+' QTDE -> '+cValToChar(nQuant))
			nRetPos := Ascan(  aGrpOps ,     {|x| x[1] == cComp }  )

				IF nRetPos == 0 
					AAdd( aGrpOps , { cComp, ALLTRIM( Posicione('SB1',1, xFilial('SB1')+cComp, "B1_DESC" )), TRBC2->C2_QUANT * nQuant, TRBC2->C2_QUANT, cLadob1   }  )

				Else
					aGrpOps[ nRetPos , 3  ]  += TRBC2->C2_QUANT * nQuant
					aGrpOps[ nRetPos , 4  ]  += TRBC2->C2_QUANT 
				Endif
//			if Substr(SC2->C2_OPC,1,7) <> space(7)
//				Alert("Adicionando...: GRUPO "+Substr(SC2->C2_OPC,1,3)+" ITEM-> "+Substr(SC2->C2_OPC,4,4))
//			endif                                 
			if Substr(SC2->C2_OPC,1,7) <> space(7)
				if Substr(SC2->C2_OPC,1,7) == SG1->G1_GROPC+SG1->G1_OPC
				   //AAdd( aGrpAuxOps , { SG1->G1_COMP , ALLTRIM( SB1->B1_DESC ) , SC2->C2_PRODUTO , SC2->C2_QUANT, SG1->G1_QUANT,SC2->C2_QUANT * nQtNivel , cLadob1, sc2->c2_ITEM, SC2->C2_SEQUEN, TRBC2->C2_NUM }  )
				   // Correcao erro variable nQtNivel does not exist
				   AAdd( aGrpAuxOps , { SG1->G1_COMP , ALLTRIM( SB1->B1_DESC ) , SC2->C2_PRODUTO , SC2->C2_QUANT, SG1->G1_QUANT,SC2->C2_QUANT * SG1->G1_QUANT , cLadob1, sc2->c2_ITEM, SC2->C2_SEQUEN, TRBC2->C2_NUM }  )
				endif
			else
				AAdd( aGrpAuxOps , { Posicione('SG1',1,xFilial('SG1')+TRBC2->C2_PRODUTO, "G1_COMP") , ALLTRIM( Posicione('SB1',1, xFilial('SB1')+TRBC2->C2_PRODUTO, "B1_DESC" )) , TRBC2->C2_PRODUTO , TRBC2->C2_QUANT, nQuant,TRBC2->C2_QUANT * nQuant , cLadob1, TRBC2->C2_ITEM, TRBC2->C2_SEQUEN, TRBC2->C2_NUM }  )
			endif
			//
		//
  		DbSelectArea('TRBC2')
		TRBC2->(DbSkip())
	Enddo
	*/
	//ENDIF
	//	//
	DbSelectArea('SZP')
	Dbskip()
Enddo

//
set filter to ZP_FILIAL== xFilial("SZP") .And. ZP_LIBER == "OK"
dbGoTo(  nRecSZP  )
//
// O bloco abaixo tem como objetivo validar se o plano considera lado e se tem algum produto com lado em branco
/*
if lLado
lErro      := .F.
cItensErro := ''
For nn1 := 1 to len(aGrpAuxOps)
if Alltrim( aGrpAuxOps[ nn1 , 7 ] ) == ''
lErro := .T.
cItensErro += aGrpAuxOps[ nn1 , 3 ]+ '-' + Posicione('SB1', 1, xFilial('SB1')+ aGrpAuxOps[ nn1 , 3 ] , 'B1_DESC') + chr(13) + chr(10)
Endif
//
NExt
//
if lerro
Alert( 'Atenção, há erro de estrutura, com produto(s) com lado não assignado' + chr(13) + chr(10) + cItensErro + 'Por Favor corrija')
MemoWrite('c:\Erro_Estrutura.txt','Atenção, há erro de estrutura, com produto(s) com lado não assignado' + chr(13) + chr(10) + cItensErro + 'Por Favor corrija')
REturn(.F. )
Endif
Endif
*/
Return()                                                     

////////////////////////////////////////////////////////////////////////////////////
//Funçao com objetivo de verificar se todas as peças do plano estao geradas 
//corretamente antes de gerar as fichas de corte.
////////////////////////////////////////////////////////////////////////////////////
static function chkPln()
local lRet := .T.
local cN1  := 'PC'
//aStru1 := {}
//aStru2 := {} 
dbSelectArea('SZP')
dbSetOrder(2)
if dbSeek(xFilial('SZP')+cPlano+cAno)
	if SZP->ZP_OPSOK == 'N' 
		lRet := .F. 
	endif
/*	cGetCodKit := SZP->ZP_PRODUTO
	nGetQtde   := SZP->ZP_QUANT
	if SZP->ZP_PLNPARC == 'N' //.and. Posicione('SB1',1,xFilial('SB1')+SZP->ZP_
		cQuery:= " SELECT G1_COMP, G1_QUANT FROM SG1010 WHERE D_E_L_E_T_ = ' ' AND G1_FILIAL='"+xFilial("SG1")+"' AND G1_COD = '"+cGetCodKit+"' AND SUBSTRING(G1_COMP,1,3) <> 'MOD' " 


		if select('TRBG1') > 0
			DbSelectArea( 'TRBG1' )
			DbCloseArea()
		Endif
	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBG1',.T.,.T. )
	
		dbSelectArea("TRBG1")
		DbGoTop()
	
		//Verifica se o produto solicitado eh KIT
		if Posicione('SB1',1,xFilial('SB1')+cGetCodKit,"B1_UM") =='KT' 
			//Verifica se o item empenhado eh material do grupo 16,40 ou 48 e gera Ordem de Producao do item lancado...
			if Posicione('SB1',1,xFilial('SB1')+TRBG1->G1_COMP,"B1_GRUPO") $ '16  |40  |48  |40A '
				AADD(aStru2, {cGetCodKit, nGetQtde})                                         
				cN1 := 'PC1'
				lPc := .T.
			else
			    while !TRBG1->(eof())
		    		AADD(aStru1, {TRBG1->G1_COMP, TRBG1->G1_QUANT})
		    		cCodAux := Posicione('SG1',1,xFilial('SG1')+TRBG1->G1_COMP,"G1_COD")
		    		if Posicione('SB1',1,xFilial('SB1')+SG1->G1_COMP,"B1_GRUPO") $ '16  |40  |48  |40A '
		    			cN1 := ''
		    		endif
		    		TRBG1->(dbSkip())
			    enddo 
			endif
			if cN1 == 'PC' 
				for i:=1  to len(aStru1)
		   			dbSelectArea('SG1')
			   		dbSetOrder(1)
				   	dbSeek(xFilial('SG1')+aStru1[i][1])
		   			while !SG1->(eof()).and.SG1->G1_COD == aStru1[i][1]
						incProc("Analisando pecas -> "+SG1->G1_COMP)
						AADD(aStru2, {SG1->G1_COMP, aStru1[i][2]*SG1->G1_QUANT})
			    		SG1->(dbSkip())
				   	enddo
			   	 next i
			endif
		else
			if Posicione('SB1',1,xFilial('SB1')+TRBG1->G1_COMP,"B1_GRUPO") $ '16  |40  |48  |40A '
				AADD(aStru2, {cGetCodKit, nGetQtde})                                         
					cN1 := 'PC1'
					lPc := .T.
			else
		    	while !TRBG1->(eof())
	   				AADD(aStru2, {TRBG1->G1_COMP, TRBG1->G1_QUANT})
		   			TRBG1->(dbSkip())
			    enddo 
		    	cN1 := 'PC' 
			endif 
		endif		
	endif
	//Rotina para remover as peças de material dublado....
	aStruAux := aStru2
	for i:= 1 to len(aStruAux)
		if i <= Len(aStruAux)
		    cCodAux := Posicione('SG1',1,xFilial('SG1')+aStruAux[i][1],"G1_COMP")
	    	if Posicione('SB1',1,xFilial('SB1')+cCodAux,'B1_GRUPO') $ '45  |21  |20  '
				nPos := aScan(aStru2, {|x| x[1] == aStruAux[i][1]})
				if nPos > 0 .and. nPos <= Len(aStru2)
					aDel(aStru2, nPos)
					ASIZE(aStru2,Len(aStru2)-1)
				endif
			endif
		endif
	next i                         

	cQuery := " SELECT COUNT(*) NPECAS FROM SC2010 WHERE D_E_L_E_T_ = ' ' AND C2_FILIAL = '"+xFilial('SC2')+"' AND SUBSTRING(C2_EMISSAO,1,4)='"+cAno+"' AND C2_OPMIDO = '"+cPlano+"' "
	if select('TMPC2') > 0 
		dbSelectArea('TMPC2')
		TMPC2->(dbCloseArea())
	endif
	dbUseArea(.T., 'TOPCONN', tcGenQry(,, cQuery), 'TMPC2', .T.,.F.)
//	Alert('TOTAL DE FICHAS-> '+cValToChar(TMPC2->NPECAS)+' Analisado no Array-> '+cValToChar(len(aStru2)))
	if TMPC2->NPECAS < Len(aStru2)
		lRet := .F. 
	endif */
endif
RETINDEX('SZP')
return lRet

// A funcao abaixo tem como objetivo carregar os itens de produtos intermediarios a partir das materias primas lancadas
Static Function ChngGrpPrs()
//
Local nn1
aGrpDispAux := {}
aFicsAux      := {}
cMPMain := acPrds[obrProds:nAt,1]
//Alert('Vai mudar de fichas...'+ cMPMain+' Tamanho do Array -> '+cValToChar(len(aPisFic)))
//nCount:= 0
//nCount1:= 0
//
For nn1 := 1 to len( aPisFic )
	if ( alltrim( aPisFic[ nn1 , 6  ]  ) == alltrim( cMPMain  )  ) .or.  ( alltrim( cMPMain  ) == 'TODOS' )
		//
		//
		AAdd( aFicsAux,{ aPisFic[nn1,1],aPisFic[nn1,2],aPisFic[nn1,3],aPisFic[nn1,4],aPisFic[nn1,5],aPisFic[nn1,6],aPisFic[nn1,7],aPisFic[nn1,8],aPisFic[nn1,9] ,aPisFic[nn1,10],aPisFic[nn1,11] ,aPisFic[nn1,12] }  )
		// 
	Endif
Next

//
if len(aFicsAux) == 0
	AAdd( aFicsAux,{ .f.,' ',' ',' ',' ',' ',' ',' ',' ',' ',' ' ,' ' }  )
Endif
//
//
acFics := aFicsAux

acFics := aSort( acFics,,, { |x, y| x[2] +x[7]  < y[2] +y[7]  } )


//
obrfics:SetArray(acFics)
obrfics:bLine := { || { iif( acFics[obrfics:nAt,1], ook, oNo ) , acFics[obrfics:nAt,2],acFics[obrfics:nAt,3],acFics[obrfics:nAt,4],acFics[obrfics:nAt,5] , acFics[obrfics:nAt,6] , acFics[obrfics:nAt,7], acFics[obrfics:nAt,8], acFics[obrfics:nAt,9], acFics[obrfics:nAt,10], acFics[obrfics:nAt,11], acFics[obrfics:nAt,12] }  }


obrfics:Refresh()
//
//
//Alert('Tamanho do Array-> '+cValToChar(len(aGrpAuxOps))+ ' cMPMain '+cMPMain)
For nn1 := 1 to len( aGrpAuxOps )
//	Alert('Posicao -> '+cValToChar(nn1)+' Valor do aGrpAuxOps -> '+aGrpAuxOps[ nn1 , 1  ]+ ' Comparando com '+cMPMain)
	if ( alltrim( aGrpAuxOps[ nn1 , 1  ]  ) == alltrim( cMPMain  )  ) .or.  ( alltrim( cMPMain  ) == 'TODOS' )
		//
		AAdd( aGrpDispAux , { Alltrim(aGrpAuxOps[ nn1 , 3  ] ) , Alltrim(Posicione( 'SB1', 1, xFilial('SB1') + aGrpAuxOps[ nn1 , 3  ], 'B1_DESC' ) ) , Alltrim(Transform( aGrpAuxOps[ nn1 , 4  ] ,'@E 99,999.9999' ) )  , Alltrim( Transform( aGrpAuxOps[ nn1 , 6  ] ,'@E 99,999.9999' )  ) ,Alltrim( Transform( aGrpAuxOps[ nn1 , 5  ] ,'@E 99,999.9999' )  )   }  )
//		nCount++
	Endif
Next
//
//Alert('Adicionado-> '+cValToChar(nCount))
if Len( aGrpDispAux ) == 0
	AAdd( aGrpDispAux , {space(10),space(20),space(10),space(10),space(10)    }  )
Endif
//
obrAuxProds:SetArray( aGrpDispAux )
obrAuxProds:bLine := { || { aGrpDispAux[obrAuxProds:nAt,1],aGrpDispAux[obrAuxProds:nAt,2],aGrpDispAux[obrAuxProds:nAt,3] ,aGrpDispAux[obrAuxProds:nAt,4 ] ,aGrpDispAux[obrAuxProds:nAt,5 ]   }  }
obrAuxProds:Refresh()
//
Return()
//-----------------------------------------------------------

//Funcao criada por Anesio para identificar se ja existe algum apontamento para a ficha, caso ja tenha sido apontodo alguma fase, 
//nao permite a exclusao das fichas e geracao de novas...

static Function VerAP_SZ7()
//          
ncont:= 0
DbSelectArea('SZ7')
DbSetOrder(1) // Ordenando por Z7_NUMFC + Z7_FASE

if Select('TRBZ7') > 0
	dbSelectArea('TRBZ7')
	TRBZ7->(dbCloseArea())
endif
	
cQuery := "Select R_E_C_N_O_ as Rec   from "+ RetSqlName( 'SZ7' ) + " where D_E_L_E_T_ =' ' and Z7_FILIAL = '" + xFilial('SZ7') + "' and Z7_PLANO ='"+ Alltrim( cPlano ) + "' AND Substring(Z7_DTAPON,1,4)='"+cAno+"' "

dbUseArea(.T.,"TOPCONN", tcGenQry(, , cQuery), "TRBZ7", .F.,.F.)
//
//
dbSelectArea('TRBZ7')
dbGotop()
while !eof()
	ncont++	  
	TRBZ7->(dbSkip())
enddo
if ncont > 0      
//	Alert("Total de PLANOS APONTADOS-> "+cValToChar(nCont))
	return .F.
endif	
          
return .T.


/*
A funcao abaixo tem como objetivo alimentar a base de dados das fichas de producao conforme for varrendo a estrutura do produto.
A metrica sera descer a partir do material ( MP ), varrendo todas os produtos intermediarios para depois quebrar as quantidades de
Acordo com os quantidades de quebra.
Desenvolvido por Rogerio Nunes , em 09/03/10.
*/
Static Function GeraFic()
//

if !chkPln()
	if !apmsgnoyes('Existem Peças Faltando no plano!'+chr(13)+'Deseja continuar a geração ? ';
		+chr(13)+chr(13)+'Sugiro que execute novamente a rotina de plano!!!')
		return()
	endif
endif
IF LtemFicha
	//
	
	if !VerAP_SZ7()
		Alert( 'Não é possível Gerar a(s) Ficha(s) de Corte.'+ chr(13) + chr(10)+'Motivo: Foi(ram) encontrado(s) apontamento(s) para este Plano!' )
		Return()
	endif                                       
	
	if lTemFcApont
		Alert(  'Não é possível Gerar a(s) Ficha(s) de Corte.'+ chr(13) + chr(10)+'Motivo: Foi(ram) encontrado(s) apontamento(s) para este Plano.' )
		Return()
	Endif
	//
	if ! msgyesno( 'Atenção' + chr(13) + chr(10)+ ' Já existe(m) Ficha(s) de Corte para Este Plano, e esta rotina substituirá a(s) ficha(s) já gravadas, de forma definitiva. Deseja Continuar ?' )
		Return()
	Else
		cQuery := "UPDATE "+ RetSqlName( 'SZ3' ) + " SET D_E_L_E_T_ = '*' where Z3_FILIAL = '" + xFilial('SZ3') + "' and Z3_PLANO ='"+ Alltrim( cPlano )
		cQuery +="' AND Substring(Z3_DTFICHA,1,4) = '"+cAno+"' "
		//
		nret1 := TcSqlExec( cQuery )
		CARR_SZ3()
		//
	Endif
	//
Endif
//          


aPisFic := {}
az3Fic  := {}
// O bloco abaixo varrera a array com as materias primas, para posicionar os produtos intermediarios e depois alimentar a base de dados
if ! lLado
	aLAdos  := {' '} // Resseta a variavel para que nao faca a geracao em duplicidade
Endif
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//o Bloco abaixo faz a geracao das fichas dos materiais de couro.... 
if Select('TRBD4') > 0
	dbSelectArea('TRBD4')
	dbCloseArea()
endif
/*
cQFC := " select C2_OPMIDO, C2_NUM, C2_PRODUTO, D4_COD, B1_GRUPO, Sum(C2_QUANT) C2_QUANT, Sum(C2_QTDLOTE) C2_QTDLOTE, Sum(D4_QTDEORI) D4_QTDEORI, Sum(D4_QUANT) D4_QUANT "
cQFC += " from SD4010 SD4, SC2010 SC2, SB1010 SB1 "
cQFC += " where SD4.D_E_L_E_T_ = ' ' and SC2.D_E_L_E_T_ = ' ' and SB1.D_E_L_E_T_ = ' ' "
cQFC += " and B1_COD = D4_COD " 
cQFC += " and C2_NUM = SUBSTRING(D4_OP,1,6) "
cQFC += " and C2_FILIAL = D4_FILIAL " 
cQFC += " and Substring(D4_COD,1,3) <> 'MOD' "
cQFC += " and C2_OPMIDO = '"+cPlano+"' " 
cQFC += " and Substring(C2_EMISSAO,1,4) = '"+cAno+"' "
cQFC += " and B1_GRUPO in ('40','40A','39') "
cQFC += " and C2_FILIAL = '"+xFilial('SC2')+"' " 
cQFC += " and D4_FILIAL = '"+xFilial('SD4')+"' " 
cQFC += " group by C2_OPMIDO, C2_NUM, C2_PRODUTO, D4_COD, B1_GRUPO "
cQFC += " order by B1_GRUPO, C2_PRODUTO " 
*/

	cQFC := " Select C2_OPMIDO, C2_EMISSAO,C2_NUM, C2_PRODUTO, D4_COD, B1_GRUPO, Sum(C2_QUANT) C2_QUANT, Sum(C2_QTDLOTE) C2_QTDLOTE, Sum(D4_QTDEORI) D4_QTDEORI, "
	cQFC += " Sum(D4_QUANT) D4_QUANT from ( "
	cQFC += " Select C2_OPMIDO, C2_EMISSAO,C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO, C2_QUANT, C2_QTDLOTE from SC2010 "
	cQFC += " where D_E_L_E_T_ =' ' "
	cQFC += " and C2_FILIAL ='"+xFilial('SC2')+"' " 
	cQFC += " and C2_OPMIDO = '"+cPlano+"' " 
	cQFC += " and Substring(C2_EMISSAO,1,4) = '"+cAno+"'  ) SC2, SD4010 SD4, SB1010 SB1 "
	cQFC += " where SD4.D_E_L_E_T_ = ' ' and SB1.D_E_L_E_T_ =' ' "
	cQFC += " and D4_FILIAL = '"+xFilial('SD4')+"' " 
	cQFC += " and D4_OP = C2_NUM+C2_ITEM+C2_SEQUEN "
	cQFC += " and B1_COD = D4_COD "
	cQFC += " and Substring(D4_COD,1,3) <> 'MOD' "	
	cQFC += " and B1_GRUPO in ('40','40A') "
	cQFC += " group by C2_OPMIDO, C2_NUM, C2_PRODUTO, D4_COD, B1_GRUPO,C2_EMISSAO "
	cQFC += " order by B1_GRUPO, C2_PRODUTO " 


memowrite('c:\temp\QDETFHC.txt', cQFC )


dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQFC),'TRBD4',.T.,.T. )	
nQtde := 0 
dbSelectArea('TRBD4')
dbGotop()               

dbSelectArea('SC2')
dbSetOrder(1)
if dbSeek(xFilial('SC2')+TRBD4->C2_NUM)
	while SC2->(eof()).and.SC2->C2_FILIAL == xFilial('SC2').and.SC2->C2_NUM == TRBD4->C2_NUM
		if SC2->C2_OPMIDO == space(12)
			APMSGINFO('Plano lancado pela rotina antiga, o sistema nao pode gerar fichas por essa rotina', 'ATENCAO!!!!!!' )
			return()
		endif
		SC2->(dbSkip())
	enddo
endif	 

dbSelectArea('TRBD4')
dbGotop()               

while !TRBD4->(eof())
if cConsLdo == 'S'
	cLado := Posicione('SB1',1,xFilial('SB1')+TRBD4->C2_PRODUTO,"B1_LADO")
	if cLado == " "
		cLado := 'A'
	endif
else
	cLado := ""
endif
	// Gravando os dados na SZ3
	nCount:= 1
	nQuant := TRBD4->C2_QUANT 
	nPerda := Posicione("SG1",1,xFilial("SG1")+TRBD4->C2_PRODUTO+TRBD4->D4_COD, "G1_PERDA")
	lUlt := .F.
	//Rotina para gravar o mesmo produto em 2 lados ( o mesmo deve estar preenchido com C) 
//Alert('Gerando ficha para o produto -> '+TRBD4->C2_PRODUTO+' '+cValToChar(nCNT1)+' Lado-> '+Posicione('SB1',1,xFilial('SB1')+TRBD4->C2_PRODUTO,"B1_LADO"))
//	if Posicione('SB1',1,xFilial('SB1')+TRBD4->C2_PRODUTO,"B1_LADO") == 'C'
	if cLado == 'C' 
//			Alert('Entrou para gravar....'+TRBD4->C2_PRODUTO+' '+cValToChar(nCNT1)+' Qtde -> '+cValToChar(nQuant))
		while nQuant > 0 
			DbSelectArea('SZ3' )
			Reclock('SZ3',.T. )
			Replace Z3_FILIAL 			WITH XFILIAL('SZ3')
			Replace Z3_PLANO		 		WITH TRBD4->C2_OPMIDO
			Replace Z3_NUMOP 				WITH TRBD4->C2_NUM 
			Replace Z3_NUMFC		 		WITH "A" + cMainOP+Substr(TRBD4->D4_COD,1,6) + STRZERO( nCount, 3 )
			Replace Z3_TPFCH 				WITH 'N'
			Replace Z3_DTFICHA 			WITH dDataBase
			Replace Z3_HRFICHA 			WITH Time()
			Replace Z3_MATERIA 			WITH TRBD4->D4_COD
			Replace Z3_PRODUTO 			WITH TRBD4->C2_PRODUTO
			if nQuant > TRBD4->C2_QTDLOTE
				Replace Z3_QTDE 		 		WITH Round(TRBD4->C2_QTDLOTE / 2, 0)
				nQuant := nQuant - TRBD4->C2_QTDLOTE
				nQtdeRnd := Round(TRBD4->C2_QTDLOTE / 2, 0)
			else
				Replace Z3_QTDE 		 		WITH Round(nQuant / 2, 0)
				lUlt := .T.
				nQtdeAnt := Round(nQuant / 2, 0 )
				nQtdeRnd := Round(nQuant / 2, 0 )
				nQuant := 0
			endif
			
			//Desconsidera Indice Perda PNP1 - Diego Mafisolli 21/12/2016 Chamado Nº 002378             
			if xFilial('SC2') == '09' 
		   		nProxQt := TRBD4->(D4_QTDEORI / C2_QUANT) - (((TRBD4->(D4_QTDEORI / C2_QUANT)) * nPerda)/100)
			Else                    
				nProxQt := TRBD4->(D4_QTDEORI / C2_QUANT) 
			Endif
		
	        //nProxQt := TRBD4->(D4_QTDEORI / C2_QUANT) 			
//			nProxQt := Posicione('SG1',1,xFilial('SG1')+TRBC2->C2_PRODUTO, "G1_QUANT") / ( 1 - (Posicione('SG1',1,xFilial('SG1')+TRBC2->C2_PRODUTO, "G1_PERDA")/100))
//			nProxQt := Posicione("SG1",1,xFilial("SG1")+TRBD4->C2_PRODUTO, "G1_QUANT")
			Replace Z3_M2PAD 		 		WITH nProxQt
			Replace Z3_M2TOT 		 		WITH iif(lUlt, nProxQt *  nQtdeAnt, nProxQt * nQtdeRnd)
			Replace Z3_SALDO 		 		WITH iif(lUlt, nQtdeAnt, TRBD4->C2_QTDLOTE)
			Replace Z3_SLDM2 				WITH iif(lUlt, nProxQt *  nQtdeAnt, nProxQt * nQtdeRnd)
			Replace Z3_STATUS 			WITH 'A'
			Replace Z3_VIAIMP 			WITH 1
			Replace Z3_ITEM      		WITH '01'
			Replace Z3_SEQUEN          WITH '001' //STRZERO( nCount,3)
			Replace Z3_OPAPONT 			WITH 'N'
			nCount++
			MsUnlock()
		//Adiciona parte do lado B			
			DbSelectArea('SZ3' )
			Reclock('SZ3',.T. )
			Replace Z3_FILIAL 			WITH XFILIAL('SZ3')
			Replace Z3_PLANO		 		WITH TRBD4->C2_OPMIDO
			Replace Z3_NUMOP 				WITH TRBD4->C2_NUM 
			Replace Z3_NUMFC		 		WITH "B" + cMainOP+Substr(TRBD4->D4_COD,1,6) + STRZERO( nCount, 3 )
			Replace Z3_TPFCH 				WITH 'N'
			Replace Z3_DTFICHA 			WITH dDataBase
			Replace Z3_HRFICHA 			WITH Time()
			Replace Z3_MATERIA 			WITH TRBD4->D4_COD
			Replace Z3_PRODUTO 			WITH TRBD4->C2_PRODUTO
			Replace Z3_QTDE		 		WITH iif(lUlt, nQtdeRnd, TRBD4->C2_QTDLOTE - nQtdeRnd)

	        //nProxQt := TRBD4->(D4_QTDEORI / C2_QUANT) 
	        //Desconsidera Indice Perda PNP1 - Diego Mafisolli 21/12/2016 Chamado Nº 002378             
			if xFilial('SC2') == '09'
		   		nProxQt := TRBD4->(D4_QTDEORI / C2_QUANT) - (((TRBD4->(D4_QTDEORI / C2_QUANT)) * nPerda)/100)
			Else                    
				nProxQt := TRBD4->(D4_QTDEORI / C2_QUANT) 
			Endif
	
			Replace Z3_M2PAD 		 		WITH nProxQt
			Replace Z3_M2TOT 		 		WITH iif(lUlt, nProxQt *  nQtdeAnt, nProxQt * (TRBD4->C2_QTDLOTE - nQtdeRnd))
			Replace Z3_SALDO 		 		WITH iif(lUlt, nQtdeAnt, TRBD4->C2_QTDLOTE)
			Replace Z3_SLDM2 				WITH iif(lUlt, nProxQt *  nQtdeAnt, nProxQt * (TRBD4->C2_QTDLOTE - nQtdeRnd))
			Replace Z3_STATUS 			WITH 'A'
			Replace Z3_VIAIMP 			WITH 1
			Replace Z3_ITEM      		WITH '01'
			Replace Z3_SEQUEN          WITH '001' //STRZERO( nCount,3)
			Replace Z3_OPAPONT 			WITH 'N'
			nCount++
			MsUnlock()
			
		enddo
      nQuant := 0
//		TRBD4->(dbSkip())
	endif                                                   
//Fim da rotina qdo o produto considerar 2 lados

	while nQuant > 0 
		DbSelectArea('SZ3' )
		Reclock('SZ3',.T. )
		Replace Z3_FILIAL 			WITH XFILIAL('SZ3')
		Replace Z3_PLANO		 		WITH TRBD4->C2_OPMIDO
		Replace Z3_NUMOP 				WITH TRBD4->C2_NUM 
		Replace Z3_NUMFC		 		WITH cLado + cMainOP+Substr(TRBD4->D4_COD,1,6) + STRZERO( nCount, 3 )
		Replace Z3_TPFCH 				WITH 'N'
		Replace Z3_DTFICHA 			WITH dDataBase
		Replace Z3_HRFICHA 			WITH Time()
		Replace Z3_MATERIA 			WITH TRBD4->D4_COD
		Replace Z3_PRODUTO 			WITH TRBD4->C2_PRODUTO
		if nQuant > TRBD4->C2_QTDLOTE
			Replace Z3_QTDE 		 		WITH TRBD4->C2_QTDLOTE
			nQuant := nQuant - TRBD4->C2_QTDLOTE
			
		else
			Replace Z3_QTDE 		 		WITH nQuant
			lUlt := .T.
			nQtdeAnt := nQuant
			nQuant := 0
		endif
	
        //nProxQt := TRBD4->(D4_QTDEORI / C2_QUANT) 
        //Desconsidera Indice Perda PNP1 - Diego Mafisolli 21/12/2016 Chamado Nº 002378             
		if xFilial('SC2') == '09'
			nProxQt := TRBD4->(D4_QTDEORI / C2_QUANT) - (((TRBD4->(D4_QTDEORI / C2_QUANT)) * nPerda)/100)
		Else                    
			nProxQt := TRBD4->(D4_QTDEORI / C2_QUANT) 
		Endif
        
		Replace Z3_M2PAD 		 		WITH nProxQt
		Replace Z3_M2TOT 		 		WITH iif(lUlt, nProxQt *  nQtdeAnt, nProxQt * TRBD4->C2_QTDLOTE)
		Replace Z3_SALDO 		 		WITH iif(lUlt, nQtdeAnt, TRBD4->C2_QTDLOTE)
		Replace Z3_SLDM2 				WITH iif(lUlt, nProxQt *  nQtdeAnt, nProxQt * TRBD4->C2_QTDLOTE)
		Replace Z3_STATUS 			WITH 'A'
		Replace Z3_VIAIMP 			WITH 1
		Replace Z3_ITEM      		WITH '01'
		Replace Z3_SEQUEN          WITH '001' //STRZERO( nCount,3)
		Replace Z3_OPAPONT 			WITH 'N'
		nCount++
		MsUnlock()
	enddo

	TRBD4->(dbSkip())
enddo
     

///////////////////////////////////////////////////////////////////////////////////////////////
//O Bloco abaixo tem objetivo de gerar as fichas dos materiais de PVC
if Select('TRBD4') > 0
	dbSelectArea('TRBD4')
	dbCloseArea()
endif

/*
cQFC := " select  C2_OPMIDO, C2_NUM, C2_PRODUTO, D4_COD, B1_GRUPO, C2_QUANT, C2_QTDLOTE, D4_QTDEORI, D4_QUANT "
cQFC += " from SD4010 SD4, SC2010 SC2, SB1010 SB1 "
cQFC += " where SD4.D_E_L_E_T_ = ' ' and SC2.D_E_L_E_T_ = ' ' and SB1.D_E_L_E_T_ = ' ' "
cQFC += " and B1_COD = D4_COD " 
cQFC += " and C2_NUM = SUBSTRING(D4_OP,1,6) "
cQFC += " and C2_FILIAL = D4_FILIAL " 
cQFC += " and Substring(D4_COD,1,3) <> 'MOD' "
cQFC += " and C2_OPMIDO = '"+cPlano+"' " 
cQFC += " and Substring(C2_EMISSAO,1,4) = '"+cAno+"' "
if lCBxFicPcD
	cQFC += " and B1_GRUPO not in ('40','40A','39') "
else
	cQFC += " and B1_GRUPO in ('16','48') "
endif
cQFC += " and C2_FILIAL = '"+xFilial('SC2')+"' " 
cQFC += " and D4_FILIAL = '"+xFilial('SD4')+"' " 
cQFC += " order by B1_GRUPO, D4_COD " 
  */
  

	cQFC := " select  C2_OPMIDO, C2_NUM, C2_PRODUTO, D4_COD, B1_GRUPO, C2_QUANT, C2_QTDLOTE, D4_QTDEORI, D4_QUANT FROM ( "

	cQFC += " Select C2_OPMIDO, C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO, C2_QUANT, C2_QTDLOTE from SC2010 "
	cQFC += " where D_E_L_E_T_ =' ' "
	cQFC += " and C2_FILIAL ='"+xFilial('SC2')+"' " 
	cQFC += " and C2_OPMIDO = '"+cPlano+"' " 
	cQFC += " and Substring(C2_EMISSAO,1,4) = '"+cAno+"'  ) SC2, SD4010 SD4, SB1010 SB1 "
	cQFC += " where SD4.D_E_L_E_T_ = ' ' and SB1.D_E_L_E_T_ =' ' "
	cQFC += " and D4_FILIAL = '"+xFilial('SD4')+"' " 
	cQFC += " and D4_OP = C2_NUM+C2_ITEM+C2_SEQUEN "
	cQFC += " and B1_COD = D4_COD "
	cQFC += " and Substring(D4_COD,1,3) <> 'MOD' " 
	
	If !Alltrim(SZP->ZP_PRODUTO) $ '062927'
		if lCBxFicPcD
			cQFC += " and B1_GRUPO not in ('40','40A') "
		else
			cQFC += " and B1_GRUPO in ('16','48') "
		endif 
	else                                   
		cQFC += " and B1_GRUPO in ('18') "
	Endif 
//	cQFC += " group by C2_OPMIDO, C2_NUM, C2_PRODUTO, D4_COD, B1_GRUPO "
	cQFC += " order by B1_GRUPO, C2_PRODUTO " 

 Memowrite("C:\TEMP\QDETFCH_PVC.TXT", cQFC) 

  
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQFC),'TRBD4',.T.,.T. )	
nQtde := 0 
dbSelectArea('TRBD4')
dbGotop()
while !TRBD4->(eof())
if cConsLdo == 'S'
	cLado := Posicione('SB1',1,xFilial('SB1')+TRBD4->C2_PRODUTO,"B1_LADO")
	if cLado == " "
		cLado := 'A'
	endif
else
	cLado := ""
endif
	// Gravando os dados na SZ3
	nCount:= 1
	nQuant := TRBD4->C2_QUANT
	lUlt := .F.

	///////////////////////////////////////////////////////////////////////////////////////////////////////
	//ROTINA PARA TRATAR LADOS NO PVC - IMPLEMENTADO POR ANESIO EM 25/11/2013
	///////////////////////////////////////////////////////////////////////////////////////////////////////
		if cLado == 'C' 
//			Alert('Entrou para gravar PVC....'+TRBD4->C2_PRODUTO+' Qtde -> '+cValToChar(nQuant))
		while nQuant > 0 
			DbSelectArea('SZ3' )
			Reclock('SZ3',.T. )
			Replace Z3_FILIAL 			WITH XFILIAL('SZ3')
			Replace Z3_PLANO		 		WITH TRBD4->C2_OPMIDO
			Replace Z3_NUMOP 				WITH TRBD4->C2_NUM 
			Replace Z3_NUMFC		 		WITH "A" + cMainOP+Substr(TRBD4->D4_COD,1,6) + STRZERO( nCount, 3 )
//			cAlertPC := "A" + cMainOP+Substr(TRBD4->D4_COD,1,6) + STRZERO( nCount, 3 )
//			Alert('FICHA PVC: '+cAlertPC+' QTDE -> '+cValToChar(nQuant))
			Replace Z3_TPFCH 				WITH 'N'
			Replace Z3_DTFICHA 			WITH dDataBase
			Replace Z3_HRFICHA 			WITH Time()
			Replace Z3_MATERIA 			WITH TRBD4->D4_COD
			Replace Z3_PRODUTO 			WITH TRBD4->C2_PRODUTO
			if nQuant > nQTMultPVC
				Replace Z3_QTDE 		 		WITH Round(nQTMultPVC / 2, 0)
				nQuant := nQuant - nQTMultPVC
				nQtdeRnd := Round(nQTMultPVC / 2, 0)
			else
				Replace Z3_QTDE 		 		WITH Round(nQuant / 2, 0)
				lUlt := .T.
				nQtdeAnt := Round(nQuant / 2, 0 )
				nQtdeRnd := Round(nQuant / 2, 0 )
				nQuant := 0
			endif

	        nProxQt := TRBD4->(D4_QTDEORI / C2_QUANT) 

			Replace Z3_M2PAD 		 		WITH nProxQt
			Replace Z3_M2TOT 		 		WITH iif(lUlt, nProxQt *  nQtdeAnt, nProxQt * nQtdeRnd)
			Replace Z3_SALDO 		 		WITH iif(lUlt, nQtdeAnt, nQTMultPVC)
			Replace Z3_SLDM2 				WITH iif(lUlt, nProxQt *  nQtdeAnt, nProxQt * nQtdeRnd)
			Replace Z3_STATUS 			WITH 'A'
			Replace Z3_VIAIMP 			WITH 1
			Replace Z3_ITEM      		WITH '01'
			Replace Z3_SEQUEN          WITH '001' //STRZERO( nCount,3)
			Replace Z3_OPAPONT 			WITH 'N'
			nCount++
			MsUnlock()
		//Adiciona parte do lado B			
			DbSelectArea('SZ3' )
			Reclock('SZ3',.T. )
			Replace Z3_FILIAL 			WITH XFILIAL('SZ3')
			Replace Z3_PLANO		 		WITH TRBD4->C2_OPMIDO
			Replace Z3_NUMOP 				WITH TRBD4->C2_NUM 
			Replace Z3_NUMFC		 		WITH "B" + cMainOP+Substr(TRBD4->D4_COD,1,6) + STRZERO( nCount, 3 )
			Replace Z3_TPFCH 				WITH 'N'
			Replace Z3_DTFICHA 			WITH dDataBase
			Replace Z3_HRFICHA 			WITH Time()
			Replace Z3_MATERIA 			WITH TRBD4->D4_COD
			Replace Z3_PRODUTO 			WITH TRBD4->C2_PRODUTO
			Replace Z3_QTDE		 		WITH iif(lUlt, nQtdeRnd, nQTMultPVC - nQtdeRnd)

			nProxQt := Posicione("SG1",1,xFilial("SG1")+TRBD4->C2_PRODUTO, "G1_QUANT") + (Posicione("SG1",1,xFilial("SG1")+TRBD4->C2_PRODUTO, "G1_QUANT") * (Posicione("SG1",1,xFilial("SG1")+TRBD4->C2_PRODUTO, "G1_PERDA")/100))
//			nProxQt := Posicione("SG1",1,xFilial("SG1")+TRBD4->C2_PRODUTO, "G1_QUANT")

			Replace Z3_M2PAD 		 		WITH nProxQt
			Replace Z3_M2TOT 		 		WITH iif(lUlt, nProxQt *  nQtdeAnt, nProxQt * (nQTMultPVC - nQtdeRnd))
			Replace Z3_SALDO 		 		WITH iif(lUlt, nQtdeAnt, TRBD4->C2_QTDLOTE)
			Replace Z3_SLDM2 				WITH iif(lUlt, nProxQt *  nQtdeAnt, nProxQt * (nQTMultPVC - nQtdeRnd))
			Replace Z3_STATUS 			WITH 'A'
			Replace Z3_VIAIMP 			WITH 1
			Replace Z3_ITEM      		WITH '01'
			Replace Z3_SEQUEN          WITH '001' //STRZERO( nCount,3)
			Replace Z3_OPAPONT 			WITH 'N'
			nCount++
			MsUnlock()
		enddo
      nQuant := 0
	endif                                                   

	///////////////////////////////////////////////////////////////////////////////////////////////////////
	//FIM DA ROTINA PARA TRATAR LADOS NO PVC 
	///////////////////////////////////////////////////////////////////////////////////////////////////////
	while nQuant > 0 
		DbSelectArea('SZ3' )
		Reclock('SZ3',.T. )
		Replace Z3_FILIAL 			WITH XFILIAL('SZ3')
		Replace Z3_PLANO		 		WITH TRBD4->C2_OPMIDO
		Replace Z3_NUMOP 				WITH TRBD4->C2_NUM 
		Replace Z3_NUMFC		 		WITH cLado + cMainOP+Substr(TRBD4->D4_COD,1,6) + STRZERO( nCount, 3 )
		Replace Z3_TPFCH 				WITH 'N'
		Replace Z3_DTFICHA 			WITH dDataBase
		Replace Z3_HRFICHA 			WITH Time()
		Replace Z3_MATERIA 			WITH TRBD4->D4_COD
		Replace Z3_PRODUTO 			WITH TRBD4->C2_PRODUTO
		if nQuant > nQTMultPVC
			Replace Z3_QTDE 		 		WITH nQTMultPVC
			nQuant := nQuant - nQTMultPVC
			
		else
			Replace Z3_QTDE 		 		WITH nQuant
			lUlt := .T.
			nQtdeAnt := nQuant
			nQuant := 0
		endif

        nProxQt := TRBD4->(D4_QTDEORI / C2_QUANT) 
//		nProxQt := Posicione("SG1",1,xFilial("SG1")+TRBD4->C2_PRODUTO, "G1_QUANT") + (Posicione("SG1",1,xFilial("SG1")+TRBD4->C2_PRODUTO, "G1_QUANT") * (Posicione("SG1",1,xFilial("SG1")+TRBD4->C2_PRODUTO, "G1_PERDA")/100))
//		nProxQt := Posicione("SG1",1,xFilial("SG1")+TRBD4->C2_PRODUTO, "G1_QUANT")

		Replace Z3_M2PAD 		 		WITH nProxQt
		Replace Z3_M2TOT 		 		WITH iif(lUlt, nProxQt *  nQtdeAnt, nProxQt * nQTMultPVC)
		Replace Z3_SALDO 		 		WITH iif(lUlt, nQtdeAnt, nQTMultPVC)
		Replace Z3_SLDM2 				WITH iif(lUlt, nProxQt *  nQtdeAnt, nProxQt * nQTMultPVC)
		Replace Z3_STATUS 			WITH 'A'
		Replace Z3_VIAIMP 			WITH 1
		Replace Z3_ITEM      		WITH '01'
		Replace Z3_SEQUEN          WITH '001' //STRZERO( nCount,3)
		Replace Z3_OPAPONT 			WITH 'N'
		nCount++
		MsUnlock()
	enddo

	TRBD4->(dbSkip())
	
	

enddo
Alert('Planos Gerado com sucesso...')
CARR_SZ3()
acFics := aPisFic
acFics := aSort( acFics,,, { |x, y| x[2] +x[7]  < y[2] +y[7]  } )
//
obrfics:SetArray(acFics)
obrfics:bLine := { || { iif( acFics[obrfics:nAt,1], ook, oNo ) , acFics[obrfics:nAt,2],acFics[obrfics:nAt,3],acFics[obrfics:nAt,4],acFics[obrfics:nAt,5] , acFics[obrfics:nAt,6] , acFics[obrfics:nAt,7], acFics[obrfics:nAt,8], acFics[obrfics:nAt,9], acFics[obrfics:nAt,10], acFics[obrfics:nAt,11], acFics[obrfics:nAt,12] }  }

// Fim do bloco que Varre a Array das Materias Primas e produtos intermediarios
//
Return()
//---------------------------------------------------------------------------------
// A funcao abaixo tem como objetivo pesquisar a tabela SZ3 para validar se ja existe registros ref a fichas de corte
//
//
Static Function CARR_SZ3()
//                        

aPisFic := {}
//

DbSelectArea('SZ3')
DbSetOrder(4) // Ordenando por Z3_NUMFC + Z3_PRODUTO
//
//Alert('cMainOp -> '+cPlano)
//cQuery := "Select R_E_C_N_O_ as Rec   from "+ RetSqlName( 'SZ3' ) + " where D_E_L_E_T_ =' ' and Z3_FILIAL = '" + xFilial('SC2') + "' and Z3_NUMOP LIKE('%"+ Alltrim( cMainOp ) + "%') "
cQuery := " Select R_E_C_N_O_ as Rec   from "+ RetSqlName( 'SZ3' ) + " where D_E_L_E_T_ =' ' and Z3_FILIAL = '" + xFilial('SC2') + "' "
cQuery += " AND Z3_PLANO ='"+ Alltrim( cPlano ) + "' AND SUBSTRING(Z3_DTFICHA,1,4) = '"+cAno+"' "
//
if select('TRBZ3') > 0
	DbSelectArea( 'TRBZ3' )
	DbCloseArea()
Endif
//
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZ3',.T.,.T. )
DbGoTop()
//
If ! eof()
	LtemFicha := .T. // Flag informando que ainda nao tem fichas de corte lancados para a ordem de producao
	//
	While !eof()
		DbSelectArea('SZ3')
		DbGoTo( TRBZ3->REC ) // POSICIONO NO SZ3
		// While ! eof() .and. substr( Z3_NUMFC, iif( lLado, 2 ,1 ) , 6 ) == cMainOp
		// While ! eof() .and.  Z3_NUMFC $  cMainOp // verifca se contem ou nao o numero da op
		//
		if !empty( Z3_DTAPON )
			lTemFcApont := .T. // Flag indicando se ha alguma ficha ja apontada
		Endif

		AAdd( aPisFic,  {   .t. , ;   // flag
		SZ3->Z3_NUMFC  , ; // numero da ficha
		SZ3->Z3_DTFICHA,; // Data Base da Geracao da Ficha
		SZ3->Z3_TPFCH,; // Tipo da Ficha ( N- Normal; C- Complementar )
		DTOC( SZ3->Z3_DTAPON   ),; //  Data do Apontamento da Ficha
		ALLTRIM(SZ3->Z3_MATERIA)  ,; // Materia Prima
		ALLTRIM(SZ3->Z3_PRODUTO) ,; // Poduto Intermediario no qual sera produzido
		Alltrim( Posicione('SB1' , 1 , xFilial('SB1') + Alltrim( SZ3->Z3_PRODUTO  ) , 'B1_DESC'    )  ) ,; //  Descricao do Produto Intermediario
		TRansform( SZ3->Z3_QTDE ,'@E 9999999' ) , ; // Quantidade do Lote          
		TRansform( SZ3->Z3_M2TOT  , '@E 99,999.9999' )  , ; // Metros Quadrados utilizados
		TRansform( SZ3->Z3_M2PAD , '@E 99,999.9999' ) ,; // M2 Padrao
		SZ3->Z3_NUMOP,;  //  numero da OP
		ALLTRIM( SZ3->Z3_CARTAO ) })  // Numero do Cartao
		//
		//
		DbSelectArea('TRBZ3')
		Dbskip()
	Enddo
	//
Endif
//
if len(aPisFic) == 0
	AAdd( aPisFic,{ .f.,' ',' ',' ',' ',' ',' ',' ',' ',' ',' ' , ' ', ' ' }  )
Endif
//
acFics := aPisFic
acFics := aSort( acFics,,, { |x, y| x[2] +x[6] +x[7]  < y[2] +y[6]+ y[7]  } )
//
//obrfics:SetArray(acFics)
//obrfics:bLine := { || { iif( acFics[obrfics:nAt,1], ook, oNo ) , acFics[obrfics:nAt,2],acFics[obrfics:nAt,3],acFics[obrfics:nAt,4],acFics[obrfics:nAt,5] , acFics[obrfics:nAt,6] , acFics[obrfics:nAt,7], acFics[obrfics:nAt,8], acFics[obrfics:nAt,9], acFics[obrfics:nAt,10], acFics[obrfics:nAt,11], acFics[obrfics:nAt,12] }  }
//
Return()
//---------------------------------------------------------------------------------
Static Function Imp_Fch()
//
Private titulo  := "Ficha de Corte"
Private cString := "SC2"
Private cDesc   := "Esta Rotina fara a Impressao da Ficha de Corte"
Private aOrd    := {}	//"Por Numero"###"Por Produto"###"Por Centro de Custo"###"Por Prazo de Entrega"
Private tamanho := "M"
Private aReturn  := {"Zebrado",3,"Administracao", 1, 2,1, "",1 }	//"Zebrado"###"Administracao"
//Private cPerg    :="MDRLPL"
Private nLastKey := 0
Private lItemNeg := .F.
Private nomeprog := 'FCORTE'
Private m_pag    := 0
Private Li       := 60
//
//AjustaSx1()
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//pergunte(cPErg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Do PLano                                ³
//³ mv_par02            // Ate o Plano                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//-- Verifica se o SH8 esta locado para atualizacao por outro processo
wnrel:=SetPrint(cString,wnrel,"",@titulo,cDesc,"","",.F.,aOrd,.F.,Tamanho)

//
If nLastKey == 27
	Return()
Endif
//
SetDefault(aReturn,cString)
//
//
RptStatus({|lEnd| Imp_Ficlaser() },titulo)

*/
/*
if cfilant == '08'
RptStatus({|lEnd| ImpFc_08() },titulo)
Endif
*/
//
Return()
//---------------------------------------------------------------------------------
// A funcao abaixo tem como objetivo imprimir a ficha de corte para a filial 08 - PNP II
Static Function ImpFc_08()
*/
Local nn1,nk1
//
//  No primeiro plano, a rotina varre a array de fichas para selecao daquelas prontas.
aOkFics := {} // Array que contera as fichas escolhidas para a impressao
For nn1 := 1 to len( acFics )
	if  acFics[nn1 , 1 ]
		nRetPos := Ascan(  aOkFics ,  acFics[ nn1, 2  ]  )
		//
		if nRetPos  == 0
			Aadd( aOkFics ,   acFics[ nn1, 2  ] )
		Endif
	Endif
Next
Alert('Total de registro a ser impresso...'+cValToChar(len(aOkFics)))
//
nContador := 0 // Esse contador ajustara automaticamente a pagina, devido ao desajuste que o codigo de barras causa na impressao
SetPrc(0,0)
For nn1 := 1 to len( aOkFics )
	//
	nlin := 00
	//
	BCode1(  Alltrim( aOkFics[ nn1 ] )  )
	setprc(0,0)
	//
	dbSelectArea('SZ3')
	DbSetorder( 4 ) // Por ordem de Ficha de Corte ja gerada
	//
	// o Bloco abaixo tem como objetivo calcular todas as quantidades para a ficha atual, conforme as metricas lancadas
	//
	DbSeek( xFilial('SZ3') + Alltrim( aOkFics[ nn1 ] ) )
	//
	nqtde    := 	0
	nM2Tot  := 	0
	nM2Pad := 	0
	While !eof() .and. Alltrim(Z3_NUMFC) == Alltrim( aOkFics[ nn1 ] )
		nqtde    += 	Z3_QTDE
		nM2Tot  +=   Z3_M2TOT
		nM2Pad +=	Z3_M2PAD
		DbSkip()
	Enddo
	//
	DbSeek( xFilial('SZ3') + Alltrim( aOkFics[ nn1 ] ) )
	//
	cStr1 :=  OnSubs + 'PNPII         F I C H A   D E   C O R T E              Num.: '+ OnNeg   + Alltrim( aOkFics[ nn1 ] ) + OFFNeg + OffSubs
	@ nLin, 00 psay cStr1
	nLin ++
	//
	SB1->( DbSeek( xFilial( 'SB1' ) + SC2->C2_PRODUTO  )  )
	//
	@ nlin,00 psay   OnExp + Substr( sb1->b1_desc,1,38 ) +  OffExp
	//
	nLin += 2
	
	@ nlin, 00 psay  'Plano: ' +   OnNeg  + aLLTRIM( SC2->C2_OPMIDO  ) + OFFNeg
	@ nlin, 35 psay  'OP Protheus: ' +  OnNeg  + aLLTRIM( SC2->C2_NUM  ) + OFFNeg
	@ nLin, 58 psay 'Data: _____/_____/____'
	nLin ++
	//
	cStr1 := 'Cliente: ' + OnNeg + 	Alltrim(Posicione('SA1' , 1 , xFilial('SA1') + SC2->C2_CLIENTE + SC2->C2_LOJA, 'A1_NOME'    )  ) + OffNeg
	cStr1 += '  RELEASE: ' + OnNeg + ALLTRIM( SC2->C2_RELEASE ) + OffNeg  + ' - ' + OnNeg + DTOC( SC2->C2_DTRELE ) + OffNeg
	@ nLin, 00 psay cStr1
	nLin +=2
	//
	SB1->( DbSeek( xFilial( 'SB1' ) + SZ3->Z3_MATERIA )  )
	//
	cDscMat := Alltrim( sb1->b1_desc )
	cGrpMat := SB1->B1_GRUPO
	@ nlin,00 psay   Substr( aOkFics[ nn1 ],  7, 6 ) + '-' +  OnExp + substr(cDscMat, 1,33 ) +  OffExp
	//
	if len( cDscMat ) > 33
		nlin ++
		@ nlin,02 psay   OnExp + substr(cDscMat, 34 ) +  OffExp
	Endif
	//
	//
	nlin +=2
	//
	// Nesse bloco o sistema fara a pesquisa de onde se encontra o material dentro da array de produtos, para descarregar qual o montante separado
	//
	nSeq := Val( substr( aOkFics[ nn1 ]  , 13,3 ) )
	//
	cLado := substr(Alltrim( aOkFics[ nn1 ] ), 1,1  )
	cLado := iif( clado $'AB', CLADO,'')
	nMultiFCH := SC2->C2_QTDLOTE
//	Alert('Grupo -> '+cGrpMat)
	if cGrpMat <> '40  '      
//			Alert('Grupo -> '+cGrpMat+ 'Multiplo-> '+cValToChar(nqtMultPVC))
		if SC2->C2_QUANT < nQtMultPVC
			nQtMultPVC := SC2->C2_QUANT
		endif
		nMultiFCH := nQtMultPVC
	endif
	//
	cStr1 := 'KIT    M2 FICHA: ' + OnNeg + ALLTRIM(  Transform( nM2Tot , '@E 99,999.9999')  ) + OffNeg + '   PADRAO: ' + OnNeg + ALLTRIM( Transform( nM2Pad  , '@E 99,999.9999')  ) + OffNeg
//	cStr1 += '  MULTIPLO : ' +   OnNeg + ALLTRIM( STR( SC2->C2_QTDLOTE )  )  + OffNeg + IIF( lLado, '    LADO : ' + OnExp + cLado +  OffExp,'' )
	cStr1 += '  MULTIPLO : ' +   OnNeg + ALLTRIM( STR( nMultFCH )  )  + OffNeg + IIF( lLado, '    LADO : ' + OnExp + cLado +  OffExp,'' )
	//
	// cStr1 += '  ATUAL : ' +    OnNeg +ALLTRIM( STR( SZ3->Z3_QTDE  )  ) + '/' + ALLTRIM(  STR(SC2->C2_QUANT  ) ) + OffNeg
	@ nlin, 00 psay cStr1
	nlin ++
	@ nlin,00 psay 'CORTADOR:                     NOME INSP.:                      LOTE:'
	nLin ++
	cCabecItem :=  'Num.OP   Produto a ser Cortado                         Qtd Pcs. Total M2 Padrao'
	lPrimCabItem := .T.
	nlin++
	//
	nCont1 := 0 // Variavel de controle na impressao das colunas
	nMultCol := 1
	//
	aItensPrn := {} // Array que contera a impressao em duas colunas.
	//
	For nk1 := 1 to len( acFics )
		if Alltrim( acFics[nK1 , 2 ] )  == Alltrim( aOkFics[ nn1 ] )  .AND.  Alltrim( acFics[nK1 , 6 ] ) == Alltrim( SZ3->Z3_MATERIA )
			//
			//
			cQuery := "Select *  from "+ RetSqlName( 'SC2' ) + " where D_E_L_E_T_ =' ' and C2_FILIAL = '" + xFilial('SC2') + "' and C2_NUM ='"+ Alltrim( cMainOp )
			cQuery +="' And C2_PRODUTO = '" + Alltrim(  acFics[nK1 , 7 ]  ) + "'"
			//
			if select('TRBC2') > 0
				DbSelectArea( 'TRBC2' )
				DbCloseArea()
			Endif
			//
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBC2',.T.,.T. )
			//
			nvQtdeAux := StrTran( acFics[nK1 ,9 ], ',' , '.'  )
			nvQtde := Val( nvQtdeAux )
			//
			cDscPr := Alltrim( acFics[nK1 , 7 ] ) + '-' + Alltrim( acFics[nK1 , 8 ] )
			//
			nCont1 ++
			if nCont1 > 14
				if lPrimCabItem
					cCabecItem += 'Num.OP   Produto a ser Cortado                         Qtd Pcs. Total M2 Padrao'
					lPrimCabItem := .f.
				Endif
				//
				// Alert( 'nCont1 ' + Alltrim( Str(nCont1 )  ) +  '   nCont1 - 14  ' +  Alltrim( Str( nCont1 - 14  )  )  )
				//
				if nCont1 > 28
					PrtItms( .T. )
					//
					nLin := 0
					@ nLin, 00 psay 'C0NTINUACAO DA FICHA DE CORTE  ' + OnNeg   +  Alltrim( aOkFics[ nn1 ] ) + OFFNeg
					nLin += 6
					//
					aItensPrn := {}
					AAdd( aItensPrn ,  padr( alltrim(acFics[nK1 ,12 ] ) , 7  ) + ' ' + padr( substr(cDscPr, 1,50 ), 50 ) + Transform(nvQtde, '@E 9999' ) + ' ' + padr( alltrim( acFics[nK1 ,10 ] ) , 7)  +' '  + padr( alltrim(acFics[nK1 ,11 ] ) , 7  )   )
					nCont1 := 1
					nContador := 0
					*/
					//
				Else
					aItensPrn[  nCont1 - 14        ] +=   '  '  + padr( alltrim(acFics[nK1 ,13 ] ) , 7  ) + ' ' + padr(substr(cDscPr, 1,50 ),50 )  + Transform(nvQtde, '@E 9999' ) + ' ' + padr( alltrim( acFics[nK1 ,10 ] ) , 7)  +' '  + padr( alltrim(acFics[nK1 ,11 ] ) , 7  )
				Endif
			Else
				AAdd( aItensPrn ,  padr( alltrim(acFics[nK1 ,12 ] ) , 7  ) + ' ' + padr( substr(cDscPr, 1,50 ), 50 ) + Transform(nvQtde, '@E 9999' ) + ' ' + padr( alltrim( acFics[nK1 ,10 ] ) , 7)  +' '  + padr( alltrim(acFics[nK1 ,11 ] ) , 7  )   )
			Endif
			//
		Endif
	Next
	//
	// O bloco abaixo descarrega a impressao dos itens, conforme preenchimento da array acima
	PrtItms( .F. )
	/*
	@ nlin,00 psay OnSubs +chr(15) +  cCabecItem + OffSubs
	nlin ++
	For nk1 := 1 to len( aItensPrn )
	@ nlin, 00  psay  aItensPrn[ nk1 ]
	//
	nlin++
	Next
	//
	//
	nlin := 27
	@ NLIN, 00 PSAY chr(18) + 'CT-20'
	//
	nContador ++  // Esse contador ajustara automaticamente a pagina, devido ao desajuste que o codigo de barras causa na impressao
	
	if nContador == 1
	@ 33,00 psay '.'			// voltar
	Else
	@ 30,00 psay '.'			// voltar
	//
	nContador := 0
	//
	Endif
	//
	SETPRC( 0,0 )
	//
	//
	*/
Next
//
//
//
If aReturn[5] = 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return()
//---------------------------------------------------------------------------------
/*
A funcao abaixo tem como objetivo imprimir os itens da ficha de producao
*/
Static Function PrtItens( lContinua ,nM2Tot, nM2Pad)

Local nz1
// O bloco abaixo descarrega a impressao dos itens, conforme preenchimento da array acima

For nz1 := 1 to len( aItensPrn )
	@ li, 00  psay  aItensPrn[ nz1 ]
	
	//
	li++
	if aItensPrn[ nz1 ] == "-" 
		@ li,000 PSAY __PrtThinLine()
		li++
		nz1++
		@ li,59 psay Transform( nM2Tot , '@E 99,999.9999')
		@ li,70 psay Transform( nM2Pad  ,'@E 9,999.9999')
		nz1++
	endif
Next
//
//
/*
li := 27
@ LI, 00 PSAY chr(18) + 'CT-20' + iif( lContinua, '     Continua ... ' , '' )
//
nContador ++  // Esse contador ajustara automaticamente a pagina, devido ao desajuste que o codigo de barras causa na impressao

if nContador == 1
@ 33,00 psay '.'			// voltar
Else
@ 30,00 psay '.'			// voltar
//
nContador := 0
//
Endif
//
*/
//
Return
//---------------------------------------------------------------------------------
Static  Function bCode1( cMensagem )
Private esc := CHR(27)
Private null := ""
Private PRINTER  := "E"
Private height    := 2
Private nb,wb,ns,ws,n1,n2
Private  char, chars
Private code := ""
Private nLin := 0
//
ns := CHR(0) + CHR(0)
ws := CHR(0) + CHR(0) + CHR(0) + CHR(0)
nb := CHR(255)
wb := CHR(255) + CHR(255) + CHR(255)
//
cols 	:= 21
n1 	:= cols % 256                               && modulus
n2 	:= INT(cols/256)
//
Alert('Gerando o codigo de barras...')
char := Array( 44 )
chars := "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ-. *$/+%"
char[01] := wb+ns+nb+ws+nb+ns+nb+ns+wb       && "1"
char[02] := nb+ns+wb+ws+nb+ns+nb+ns+wb       && "2"
char[03] := wb+ns+wb+ws+nb+ns+nb+ns+nb       && "3"
char[04] := nb+ns+nb+ws+wb+ns+nb+ns+wb       && "4"
char[05] := wb+ns+nb+ws+wb+ns+nb+ns+nb       && "5"
char[06] := nb+ns+wb+ws+wb+ns+nb+ns+nb       && "6"
char[07] := nb+ns+nb+ws+nb+ns+wb+ns+wb       && "7"
char[08] := wb+ns+nb+ws+nb+ns+wb+ns+nb       && "8"
char[09] := nb+ns+wb+ws+nb+ns+wb+ns+nb       && "9"
char[10] := nb+ns+nb+ws+wb+ns+wb+ns+nb       && "0"
char[11] := wb+ns+nb+ns+nb+ws+nb+ns+wb       && "A"
char[12] := nb+ns+wb+ns+nb+ws+nb+ns+wb       && "B"
char[13] := wb+ns+wb+ns+nb+ws+nb+ns+nb       && "C"
char[14] := nb+ns+nb+ns+wb+ws+nb+ns+wb       && "D"
char[15] := wb+ns+nb+ns+wb+ws+nb+ns+nb       && "E"
char[16] := nb+ns+wb+ns+wb+ws+nb+ns+nb       && "F"
char[17] := nb+ns+nb+ns+nb+ws+wb+ns+wb       && "G"
char[18] := wb+ns+nb+ns+nb+ws+wb+ns+nb       && "H"
char[19] := nb+ns+wb+ns+nb+ws+wb+ns+nb       && "I"
char[20] := nb+ns+nb+ns+wb+ws+wb+ns+nb       && "J"
char[21] := wb+ns+nb+ns+nb+ns+nb+ws+wb       && "K"
char[22] := nb+ns+wb+ns+nb+ns+nb+ws+wb       && "L"
char[23] := wb+ns+wb+ns+nb+ns+nb+ws+nb       && "M"
char[24] := nb+ns+nb+ns+wb+ns+nb+ws+wb       && "N"
char[25] := wb+ns+nb+ns+wb+ns+nb+ws+nb       && "O"
char[26] := nb+ns+wb+ns+wb+ns+nb+ws+nb       && "P"
char[27] := nb+ns+nb+ns+nb+ns+wb+ws+wb       && "Q"
char[28] := wb+ns+nb+ns+nb+ns+wb+ws+nb       && "R"
char[29] := nb+ns+wb+ns+nb+ns+wb+ws+nb       && "S"
char[30] := nb+ns+nb+ns+wb+ns+wb+ws+nb       && "T"
char[31] := wb+ws+nb+ns+nb+ns+nb+ns+wb       && "U"
char[32] := nb+ws+wb+ns+nb+ns+nb+ns+wb       && "V"
char[33] := wb+ws+wb+ns+nb+ns+nb+ns+nb       && "W"
char[34] := nb+ws+nb+ns+wb+ns+nb+ns+wb       && "X"
char[35] := wb+ws+nb+ns+wb+ns+nb+ns+nb       && "Y"
char[36] := nb+ws+wb+ns+wb+ns+nb+ns+nb       && "Z"
char[37] := nb+ws+nb+ns+nb+ns+wb+ns+wb       && "-"
char[38] := wb+ws+nb+ns+nb+ns+wb+ns+nb       && "."
char[39] := nb+ws+wb+ns+nb+ns+wb+ns+nb       && " "
char[40] := nb+ws+nb+ns+wb+ns+wb+ns+nb       && "*"
char[41] := nb+ws+nb+ws+nb+ws+nb+ns+nb       && "$"
char[42] := nb+ws+nb+ws+nb+ns+nb+ws+nb       && "/"
char[43] := nb+ws+nb+ns+nb+ws+nb+ws+nb       && "+"
char[44] := nb+ns+nb+ws+nb+ws+nb+ws+nb       && "%"
//
message := "*"+TRIM( cMensagem )+"*"
//
@ nlin,00 psay esc+CHR(51)+CHR(2)
impCode( message, 50  )
//
RETURN
//--------------------------
Static FUNCTION impCode( message, ncol  )
//
Local I,H

lPrim := .T.

FOR H := 1 TO height
	code := ""
	FOR I := 1 TO LEN(message)
		letter := SUBSTR(message,I,1)
		code := IF(AT(letter,chars)=0,letter,char[at(letter,chars)]) + ns
		//
		SetPrc(0,0)
		//
		if lPrim
			ncoluna :=  50
			lPrim := .F.
		Else
			ncoluna := pcol()
		Endif
		//
		@ nlin, ncoluna  psay (esc + CHR(76) + CHR(n1) + CHR(n2) + code )
	NEXT
	//
	@ nlin, 00 psay (esc+CHR(74)+CHR(23)+CHR(13))
	lPrim := .T.
NEXT

* perform 5/216 line feed
@ nlin, 00 psay  (esc+CHR(74)+CHR(5) + esc+"@" )
nlin ++
//
RETURN code
//---------------------------------------------------------------------------------
/*
A funcao abaixo tem como objetivo imprimir a Ficha de Corte na Impressora LAser, conforme solicitacao Yukio
*/
Static Function Imp_Ficlaser()
Local nn1,nk1
//
cbtxt   := SPACE(10)
cbcont  := 0
m_pag   := 1
nTipo   := 15
Li 		:= 60
nLiB       := 2
aTrab      := {}
Private Opr
//

//
//cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
//alert('ok')
//
aOkFics := {} // Array que contera as fichas escolhidas para a impressao
nTotFichas := 0 // Quantidade Total de Fichas Emitidas
cItens := "" 
For nn1 := 1 to len( acFics )
	if  acFics[nn1 , 1 ]
		nRetPos := Ascan(  aOkFics ,  acFics[ nn1, 2  ]  )

		if nRetPos  == 0
			Aadd( aOkFics ,   acFics[ nn1, 2  ] )
			nTotFichas ++
		Endif
		
	Endif
Next

//MemoWrite('D:\ANESIO\Itens.txt','Atenção par os Itens' + chr(13) + chr(10) + cItens + 'Itens Gravados')


//
//Alert('Total de itens na ficha-> '+cValToChar(len(aOKFics)))
nContador := 0 // Esse contador ajustara automaticamente a pagina, devido ao desajuste que o codigo de barras causa na impressao
//
For nn1 := 1 to len( aOkFics )
	//
	//
	// BCode1(  Alltrim( aOkFics[ nn1 ] )  )
	//
	dbSelectArea('SZ3')
	DbSetorder( 4 ) // Por ordem de Ficha de Corte ja gerada
	//
	// o Bloco abaixo tem como objetivo calcular todas as quantidades para a ficha atual, conforme as metricas lancadas
	//
	DbSeek( xFilial('SZ3') + Alltrim( aOkFics[ nn1 ] ) )
	//
	nqtde  := 	0
	nM2Tot := 	0
	nM2Pad := 	0
	While !eof() .and. Alltrim(Z3_NUMFC) == Alltrim( aOkFics[ nn1 ] )
		nqtde  += 	Z3_QTDE
		nM2Tot += Z3_M2TOT
		nM2Pad +=	Z3_M2PAD                                                           
		DbSkip()
	Enddo
	//
	DbSeek( xFilial('SZ3') + Alltrim( aOkFics[ nn1 ] ) )

//	Alert('NUMERO DA FICHA-> '+Alltrim( aOkFics[ nn1 ] ))
	cCtrl := iif(substr(aOkFics[nn1],1,1) $ 'AB', substr(aOkFics[nn1],2,6), substr(aOkFics[nn1],1,6))

	SB1->( DbSeek( xFilial( 'SB1' ) + SC2->C2_PRODUTO  )  )
	//
	
//	Titulo    := 'FICHA DE CORTE  - Plano  ' + aLLTRIM( SC2->C2_OPMIDO  )
	Titulo    := 'FICHA DE CORTE  - PLANO  ' + aLLTRIM( Posicione('SZP',1,xFilial('SZP')+cCtrl,"ZP_OPMIDO")  )
//	Cabec1    := 'Controle Protheus: '   + aLLTRIM( SC2->C2_NUM  ) + '          Qtde. do Plano: ' + alltrim( str( nQtPlano ) )
	Cabec1    := 'Controle Protheus: '   + aLLTRIM( cCTrl  ) + '          Qtde. do Plano: ' + alltrim( str( nQtPlano ) )
	Cabec2    := 'Num. FICHA: ' + Alltrim( aOkFics[ nn1 ] )  + '   Data: _____/_____/____'
	// Cabec2    := alltrim( SB1->B1_COD )  + '-' + sb1->b1_desc
	//
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	//
	//
	Private opr
	Private  nLiB       := 1.1
	oPr := ReturnPrtObj()
	MSBAR3("CODE128",  nLib  ,  07 ,Alltrim( aOkFics[ nn1 ] ),oPr,,,,,0.8,,,"A")
	//
	SB1->( DbSeek( xFilial( 'SB1' ) + Posicione('SZP',1,xFilial('SZP')+cCtrl,"ZP_PRODUTO")  )  )
	//
	Li --
	@ li,00 psay 'Material do Plano: ' + alltrim( SB1->B1_COD )  + '-' + sb1->b1_desc
	cCodKit  := ALLTRIM(SB1->B1_COD )
	cDescKit := ALLTRIM(SB1->B1_DESC)
	do case
		case ALLTRIM(SB1->B1_UM) == "KT"
			cDescUM  := "KITs"
		case ALLTRIM(SB1->B1_UM) == "CM"
			cDescUM  := "COMPONENTES"
		case ALLTRIM(SB1->B1_UM) == "PC"
			cDescUM  := "PECAS"
		otherwise
			cDescUM  := "UNIDADES"
	endcase 

	//
	Li ++
	//
	cCli := Posicione('SZP',1,xFilial('SZP')+cCtrl,"ZP_CLIENTE")
	cLj  := Posicione('SZP',1,xFilial('SZP')+cCtrl,"ZP_LOJA")
	nMultp:= Posicione('SZP',1,xFilial('SZP')+cCtrl,"ZP_MULTPLO")
	cStr1 := 'Cliente: '   +	Alltrim(Posicione('SA1' , 1 , xFilial('SA1') + cCli + cLj, 'A1_NOME'    )  )
	cStr1 += '  RELEASE: '  + ALLTRIM( Posicione('SZP',1,xFilial('SZP')+cCtrl,"ZP_RELEASE") ) //+ ' - ' + DTOC( SC2->C2_DTRELE )
	@ Li, 00 psay cStr1
	Li +=2
	//
	SB1->( DbSeek( xFilial( 'SB1' ) + SZ3->Z3_MATERIA )  )
	//
	cGrpMat := SB1->B1_GRUPO
	cDscMat := Alltrim( sb1->b1_desc )

	@ li,00 psay   'Material da Ficha: ' + ALLTRIM( SZ3->Z3_MATERIA ) + '-' +  Alltrim( cDscMat )
	cCouro:= iif(Posicione("SB1",1,xFilial("SB1")+SZ3->Z3_MATERIA,"B1_GRUPO")=='40  ','COURO','PVC')

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para identificar a numeração de camadas de cada tipo de material no KIT
	cCodMat  := ALLTRIM(SZ3->Z3_MATERIA)
	lDescSZI := .F.
	//Rotina para identificar se existe cadastro na tabela SZI e se o cadastro é realizado generico ou exclusivamente para o KIT
	dbSelectArea("SZI")
	dbSetOrder(2)
	if SZI->(dbSeek(xFilial("SZI")+cCodMat))
		if SZI->ZI_CODKIT == space(15)
			cDescSZI := SZI->ZI_DESCREZ+" - QCAM: "+alltrim( str( SZI->ZI_QTDCAMA ) ) + " - COMP: " + alltrim( str( SZI->ZI_COMPRIM ) ) + " - Q.CARR: " + alltrim( str( SZI->ZI_QTDCARR ) ) + " - EMENDAS: "+SZI->ZI_EMENDAS
			lDescSZI := .T.
		endif
		While !SZI->(eof()).and.ALLTRIM(SZI->ZI_MATERIA) == ALLTRIM(cCodMat)
			if ALLTRIM(SZI->ZI_CODKIT) == ALLTRIM( cCodKit )
				cDescSZI := SZI->ZI_DESCREZ+" - QCAM: "+alltrim( str( SZI->ZI_QTDCAMA ) ) + " - COMP: " + alltrim( str( SZI->ZI_COMPRIM ) ) + " - Q.CARR: " + alltrim( str( SZI->ZI_QTDCARR ) ) + " - EMENDAS: "+SZI->ZI_EMENDAS
				lDescSZI := .T.
			endif
			SZI->(dbSkip())
		enddo	
	endif

//ZI_FILIAL ZI_CODKIT       ZI_MATERIA      ZI_DESCREZ      ZI_QTDCAMA             ZI_COMPRIM             ZI_QTDCARR             ZI_EMENDAS

//FIM - Rotina para identificar a numeração de camadas de cada tipo de material no KIT
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	
	
	
	//
	li ++
	//
	// Nesse bloco o sistema fara a pesquisa de onde se encontra o material dentro da array de produtos, para descarregar qual o montante separado
	//
	nSeq := Val( substr( aOkFics[ nn1 ]  , 13,3 ) )
	//
	cLado := substr(Alltrim( aOkFics[ nn1 ] ), 1,1  )
	cLado := iif( clado $'AB', CLADO,'')
	nMultiFCH := SC2->C2_QTDLOTE
//	Alert('Grupo -> '+cGrpMat)
	if cGrpMat <> '40  '      
///			Alert('Grupo -> '+cGrpMat+ 'Multiplo-> '+cValToChar(nqtMultPVC))
		if SC2->C2_QUANT < nQtMultPVC
			nQtMultPVC := SC2->C2_QUANT
		endif

		nMultiFCH := nQtMultPVC
	endif

	//
	cStr1 := 'KIT    M2 FICHA: '  + ALLTRIM(  Transform( nM2Tot , '@E 99,999.9999')  )  + '   PADRAO: '  + ALLTRIM( Transform( nM2Pad  , '@E 99,999.9999')  )
//	cStr1 += '  MULTIPLO : '  + ALLTRIM( STR( SC2->C2_QTDLOTE )  )   + IIF( lLado, '    LADO : ' + cLado ,'' )
	cStr1 += '  MULTIPLO : '  + ALLTRIM( STR( nMultp )  )   + IIF( lLado, '    LADO : ' + cLado ,'' )
	//
	// cStr1 += '  ATUAL : ' +    OnNeg +ALLTRIM( STR( SZ3->Z3_QTDE  )  ) + '/' + ALLTRIM(  STR(SC2->C2_QUANT  ) ) + OffNeg
	@ li, 00 psay cStr1                           
	li += 2
	@ li,00 psay 'CORTADOR:                     NOME INSP.:                      LOTE:'
	Li ++
	@ li,000 PSAY __PrtThinLine()
	li++
	@ li,000 psay 'Num.OP   Produto a ser Cortado...                                       Qtd Pcs.    Total M2    Padrao'
	Li ++
	@ li,000 PSAY __PrtThinLine()
	lPrimCabItem := .T.
	li++
	//
	nCont1 := 0 // Variavel de controle na impressao das colunas
	nMultCol := 1
	//
	aItensPrn := {} // Array que contera a impressao em duas colunas.
	//
	For nk1 := 1 to len( acFics )
		if Alltrim( acFics[nK1 , 2 ] )  == Alltrim( aOkFics[ nn1 ] )  .AND.  Alltrim( acFics[nK1 , 6 ] ) == Alltrim( SZ3->Z3_MATERIA )
			//
			//
			cQuery := "Select *  from "+ RetSqlName( 'SC2' ) + " where D_E_L_E_T_ =' ' and C2_FILIAL = '" + xFilial('SC2') + "' and C2_NUM ='"+ Alltrim( cMainOp )
			cQuery +="' And C2_PRODUTO = '" + Alltrim(  acFics[nK1 , 7 ]  ) + "'"
			//
			if select('TRBC2') > 0
				DbSelectArea( 'TRBC2' )
				DbCloseArea()
			Endif
			//
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBC2',.T.,.T. )
			//
			nvQtdeAux := StrTran( acFics[nK1 ,9 ], ',' , '.'  )
			nvQtde := Val( nvQtdeAux )
			//
			cDscPr := Alltrim( acFics[nK1 , 7 ] ) + '-' + Alltrim( acFics[nK1 , 8 ] )
			//
			nCont1 ++
			/*
			if nCont1 > 14
			if lPrimCabItem
			cCabecItem := 'Num.OP   Produto a ser Cortado                      Qtd Pcs. Total M2 Padrao'
			lPrimCabItem := .f.
			Endif
			//
			// Alert( 'nCont1 ' + Alltrim( Str(nCont1 )  ) +  '   nCont1 - 14  ' +  Alltrim( Str( nCont1 - 14  )  )  )
			//
			*/
			if nCont1 > 26
			//
			//   PrtItms( .T. )
			//                 
			PrtItens(.F.)
			
			Li := 0
			@ Li, 00 psay 'C0NTINUACAO DA FICHA DE CORTE  ' +   Alltrim( aOkFics[ nn1 ] ) 
			Li += 6
			//
			aItensPrn := {}
			AAdd( aItensPrn ,  padr( alltrim(acFics[nK1 ,12 ] ) , 7  ) + ' ' + padr( substr(cDscPr, 1,67 ), 67 ) + Transform(nvQtde, '@E 99999' ) + '   ' + padr( alltrim( acFics[nK1 ,10 ] ) , 8)  + padr( alltrim(acFics[nK1 ,11 ] ) , 8  ) )
			nCont1 := 1
			nContador := 0
			//
//			Else
//			aItensPrn[  nCont1 - 14        ] +=   '  '  + padr(substr(cDscPr, 1,43 ),43 )  + Transform(nvQtde, '@E 99999999' ) + '  ' + padr( alltrim( acFics[nK1 ,10 ] ) , 7)  +' '  + padr( alltrim(acFics[nK1 ,11 ] ) , 7  )

			Else
//			Alert('QUANTIDADE -> '+cValToChar(nvQtde))
			AAdd( aItensPrn ,  padr( alltrim(acFics[nK1 ,12 ] ) , 7  ) + ' ' + padr( substr(cDscPr, 1,67 ), 67 ) + Transform(nvQtde, '@E 9999999' )+ '      ' + padr( alltrim( acFics[nK1 ,10 ] ) , 8) +'     ' + padr( alltrim(acFics[nK1 ,11 ] ) , 7  )   )
			
			//Bloco para incluir o cartao de processo direto na ficha...Chamado HDi 003704
/*			if nCont1 = 31
			
				if cCouro == 'COURO'
					AAdd( aItensPrn ,"|----------------------- C A R T A O  D E  P R O C E S S O -----------------------|" )
					AAdd( aItensPrn ,"|  SETOR     |   DATA  |  RESPONSAVEL   ||  SETOR      |   DATA  |  RESPONSAVEL   |" )
					AAdd( aItensPrn ,"|ALMOXARIFADO|__/__/___|________________||MARC.DEFEITOS|__/__/___|________________|" )
					AAdd( aItensPrn ,"|RISCAGEM    |__/__/___|________________||CORTE        |__/__/___|________________|" )
					AAdd( aItensPrn ,"|LIMPEZA     |__/__/___|________________||1ºINSPECAO   |__/__/___|________________|" )
					AAdd( aItensPrn ,"|COLOC.MESA  |__/__/___|________________||PERFURACAO   |__/__/___|________________|" )
					AAdd( aItensPrn ,"|CARIMBO     |__/__/___|________________||2ºINSPECAO   |__/__/___|________________|" )
					AAdd( aItensPrn ,"|EMBALAGEM   |__/__/___|________________||EXPEDICAO    |__/__/___|________________|" )
					AAdd( aItensPrn ,"|---------------------------------------------------------------------------------|" )
				else
					AAdd( aItensPrn ,"|----------------------- C A R T A O  D E  P R O C E S S O -----------------------|" )
					AAdd( aItensPrn ,"|  SETOR     |   DATA  |  RESPONSAVEL   ||  SETOR      |   DATA  |  RESPONSAVEL   |" )
					AAdd( aItensPrn ,"|ALMOXARIFADO|__/__/___|________________||CORTE        |__/__/___|________________|" )
					AAdd( aItensPrn ,"|EMBALAGEM   |__/__/___|________________||1ºCONTAGEM   |__/__/___|________________|" )
					AAdd( aItensPrn ,"|2ºCONTAGEM  |__/__/___|________________||EXPEDICAO    |__/__/___|________________|" )
					AAdd( aItensPrn ,"|                                                                                 |" )
					AAdd( aItensPrn ,"|                                                                                 |" )
					AAdd( aItensPrn ,"|                                                                                 |" )
					AAdd( aItensPrn ,"|---------------------------------------------------------------------------------|" )
				endif				
 			   nCont1 += 10 */
//			 endif
			if nCont1 == 26
				AAdd( aItensPrn , "- - - C-O-N-T-I-N-U-A - N-A - P-R-O-X-I-M-A - P-A-G-I-N-A - - -")
				nCont1++
			endif
			Endif
			//
		Endif
	Next
  /*  cPLin := "S" //Marca a primeira linha em branco                                                                 
	if nCont1 < 33     
		for i:=1 to 31 - nCont1 
			if cPlin == 'S'
				AAdd( aItensPrn ,"-" )
				cPlin := 'N'
			else
				AAdd( aItensPrn ,"   " )
			endif
		next i
			/*	if cCouro == 'COURO'
					AAdd( aItensPrn ,"|----------------------- C A R T A O  D E  P R O C E S S O -----------------------|" )
					AAdd( aItensPrn ,"|  SETOR     |   DATA  |  RESPONSAVEL   ||  SETOR      |   DATA  |  RESPONSAVEL   |" )
					AAdd( aItensPrn ,"|ALMOXARIFADO|__/__/___|________________||MARC.DEFEITOS|__/__/___|________________|" )
					AAdd( aItensPrn ,"|RISCAGEM    |__/__/___|________________||CORTE        |__/__/___|________________|" )
					AAdd( aItensPrn ,"|LIMPEZA     |__/__/___|________________||1ºINSPECAO   |__/__/___|________________|" )
					AAdd( aItensPrn ,"|COLOC.MESA  |__/__/___|________________||PERFURACAO   |__/__/___|________________|" )
					AAdd( aItensPrn ,"|CARIMBO     |__/__/___|________________||2ºINSPECAO   |__/__/___|________________|" )
					AAdd( aItensPrn ,"|EMBALAGEM   |__/__/___|________________||EXPEDICAO    |__/__/___|________________|" )
					AAdd( aItensPrn ,"|---------------------------------------------------------------------------------|" )
				else
					AAdd( aItensPrn ,"|----------------------- C A R T A O  D E  P R O C E S S O -----------------------|" )
					AAdd( aItensPrn ,"|  SETOR     |   DATA  |  RESPONSAVEL   ||  SETOR      |   DATA  |  RESPONSAVEL   |" )
					AAdd( aItensPrn ,"|ALMOXARIFADO|__/__/___|________________||CORTE        |__/__/___|________________|" )
					AAdd( aItensPrn ,"|EMBALAGEM   |__/__/___|________________||1ºCONTAGEM   |__/__/___|________________|" )
					AAdd( aItensPrn ,"|2ºCONTAGEM  |__/__/___|________________||EXPEDICAO    |__/__/___|________________|" )
					AAdd( aItensPrn ,"|                                                                                 |" )
					AAdd( aItensPrn ,"|                                                                                 |" )
					AAdd( aItensPrn ,"|                                                                                 |" )
					AAdd( aItensPrn ,"|---------------------------------------------------------------------------------|" )
				endif				 */
	//endif	
	
	//
	// O bloco abaixo descarrega a impressao dos itens, conforme preenchimento da array acima
	

//	PrtItens(.F.)
	PrtItens(.F., nM2Tot,nM2Pad)
	//
	Li++
	@ li,000 PSAY __PrtThinLine()
	li++
	@ li,59 psay Transform( nM2Tot , '@E 99,999.9999')
	@ li,70 psay Transform( nM2Pad  ,'@E 9,999.9999')
	/*
	@ nlin,00 psay OnSubs +chr(15) +  cCabecItem + OffSubs
	nlin ++
	For nk1 := 1 to len( aItensPrn )
	@ nlin, 00  psay  aItensPrn[ nk1 ]
	//
	nlin++
	Next
	//
	//
	nlin := 27
	@ NLIN, 00 PSAY chr(18) + 'CT-20'
	//
	nContador ++  // Esse contador ajustara automaticamente a pagina, devido ao desajuste que o codigo de barras causa na impressao
	
	if nContador == 1
	@ 33,00 psay '.'			// voltar
	Else
	@ 30,00 psay '.'			// voltar
	//
	nContador := 0
	//
	Endif
	//
	SETPRC( 0,0 )
	//
	//
	*/

	if cCouro == 'COURO'
		@ 051, 00 Psay "|----------------------- C A R T A O  D E  P R O C E S S O -----------------------|" 
		@ 052, 00 Psay "|  SETOR     |   DATA  |  RESPONSAVEL   ||  SETOR      |   DATA  |  RESPONSAVEL   |" 
		@ 053, 00 Psay "|ALMOXARIFADO|__/__/___|________________||MARC.DEFEITOS|__/__/___|________________|" 
		@ 054, 00 Psay "|RISCAGEM    |__/__/___|________________||CORTE        |__/__/___|________________|" 
		@ 055, 00 Psay "|LIMPEZA     |__/__/___|________________||1ºINSPECAO   |__/__/___|________________|" 
		@ 056, 00 Psay "|COLOC.MESA  |__/__/___|________________||PERFURACAO   |__/__/___|________________|" 
		@ 057, 00 Psay "|CARIMBO     |__/__/___|________________||2ºINSPECAO   |__/__/___|________________|" 
		@ 058, 00 Psay "|EMBALAGEM   |__/__/___|________________||EXPEDICAO    |__/__/___|________________|" 
		@ 059, 00 Psay "|---------------------------------------------------------------------------------|" 
	elseif lDescSZI 
		@ 045, 00 Psay "|---------------------------------------------------------------------------------|"
		@ 045, 84 Psay "|-------------------------------------|"		
		@ 046, 00 Psay "|"+cDescKit+" --------- "+alltrim( str( nQtPlano ) )+" " + cDescUM
		@ 046, 82 Psay "|" 
		@ 046, 84 Psay "|--C A R T A O  D E  P R O C E S S O--|"		
		@ 047, 00 Psay "|"+cDescSZI
		@ 047, 82 Psay "|"
		@ 047, 84 Psay "|  SETOR     |   DATA  |  RESPONSAVEL |"		
		@ 048, 00 Psay "|---------------------------------------------------------------------------------|"
		@ 048, 84 Psay "|            |         |              |"
		@ 049, 00 Psay "|                                                                                 |"
		@ 049, 02 Psay "PADRÃO: "+ALLTRIM(  Transform( nM2Tot , '@E 99,999.9999'))
		@ 049, 28 Psay "|"
		@ 049, 30 Psay "METRAGEM: "
		@ 049, 56 Psay "|"
		@ 049, 58 Psay "% APROV.:"
		@ 049, 84 Psay "|ALMOXARIFADO|__/__/___|______________|"
		@ 050, 00 Psay "|---------------------------------------------------------------------------------|"
		@ 050, 28 Psay "|"
		@ 050, 56 Psay "|"
		@ 050, 84 Psay "|-------------------------------------|"
		@ 051, 00 Psay "|                                                                                 |"
		@ 051, 02 Psay "REAL: "
		@ 051, 28 Psay "|"
		@ 051, 56 Psay "|"
		@ 051, 84 Psay "|            |         |              |"
		@ 052, 00 Psay "|---------------------------------------------------------------------------------|"
		@ 052, 28 Psay "|"
		@ 052, 56 Psay "|"
		@ 052, 84 Psay "|CORTE       |__/__/___|______________|"
		@ 053, 00 Psay "|                                                                                 |"
		@ 053, 02 Psay "ADICIONAL: "		
		@ 053, 28 Psay "|"
		@ 053, 56 Psay "|"
		@ 053, 84 Psay "|-------------------------------------|"
		@ 054, 00 Psay "|---------------------------------------------------------------------------------|"
		@ 054, 28 Psay "|"
		@ 054, 56 Psay "|"
		@ 055, 00 Psay "|                                                                                 |"
		@ 055, 02 Psay "QTDE PCs: "
		@ 055, 28 Psay "|"
		@ 055, 56 Psay "|"
		@ 056, 00 Psay "|---------------------------------------------------------------------------------|"
		@ 056, 28 Psay "|"
		@ 056, 56 Psay "|"
		@ 057, 00 Psay "|MOTIVO:                                                                          |"
		@ 058, 00 Psay "|                                                                                 |"
		@ 059, 00 Psay "|---------------------------------------------------------------------------------|"
	else
		@ 045, 84 Psay "|-------------------------------------|"
		@ 046, 84 Psay "|--C A R T A O  D E  P R O C E S S O--|"
		@ 047, 84 Psay "|  SETOR     |   DATA  |  RESPONSAVEL |"
		@ 048, 84 Psay "|            |         |              |"
		@ 049, 84 Psay "|ALMOXARIFADO|__/__/___|______________|"
		@ 050, 84 Psay "|-------------------------------------|"
		@ 051, 84 Psay "|CORTE       |__/__/___|______________|"
		@ 052, 84 Psay "|-------------------------------------|"  
	endif
	
	if xFilial('SZ3') == '08'
		@ 054, 84 Psay "|-----------------------------------------|"
		@ 055, 84 Psay "|        FICHA ENFESTO / CORTE            |"
		@ 056, 84 Psay "|-----------------------------------------|"  
		@ 057, 84 Psay "| MESA |   NUM.ENFESTO   | QTDE CONSUMIDA |"
		@ 058, 84 psay "|---------------------------------------- |" 
		@ 059, 84 Psay "|  1   |                |                 |"
		@ 060, 84 Psay "|-----------------------------------------|"
		@ 061, 84 Psay "|  2   |                |                 |"
		@ 062, 84 Psay "|-----------------------------------------|"
		@ 063, 84 Psay "|  3   |                |                 |"
		@ 064, 84 Psay "|-----------------------------------------|"             
		@ 065, 84 Psay "|  4   |                |                 |"
		@ 066, 84 Psay "|-----------------------------------------|"
		@ 067, 84 Psay "|  5   |                |                 |"
		@ 068, 84 Psay "|-----------------------------------------|"
		@ 069, 84 Psay "|  6   |                |                 |"
		@ 070, 84 Psay "|-----------------------------------------|"
	endif                                                          
					
   		//@ 071, 00 psay  'CARACTERISTICA ESPECIAL: S' // Aguardar abertura de chamado - teste
   		@ 071, 84 psay  'CT - 20    ' + alltrim( Str( m_pag - 1  ) ) + '/' + alltrim( str(nTotFichas) )
Next
//
//
//
If aReturn[5] = 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return()
//---------------------------------------------------------------------------------