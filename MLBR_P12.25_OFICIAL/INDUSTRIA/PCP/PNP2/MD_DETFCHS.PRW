#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#include "COLORS.CH"
//---------------------------------
/*
Este Programa tem como objetivo consultar as fichas de corte a partir do plano informado
Desenvolvido por Rogerio Nunes - 24/02/10
Parametros:
01 - RECNO da Tabela SC2
*/
User Function MD_DTFHCOR(  nRecSc2  )
//
Private oFontSay ,oFontSayB,oFontDad,obrProds,cBanco,obrfics,cfics,ochkAll
Private tchkAll := .T.
Private acPrds := {}
Private cMainOp := SC2->C2_NUM   //  Ordem de Producao Principal
Private cPlano  := SC2->C2_OPMIDO // Numero do Plano 
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
Private aLados  := { 'A', 'B' } // Array contendo os lados para processamento, mesmo se houver necessidade de se abrir para outros lados, o sistema estara pronto para atender
Private lLado     := .F.
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
DbSelectArea('SC2')
DbSetOrder(1)
DbSeek(   xFilial('SC2') + cMainOp + '01001'   )  //  Posicionando na OP Principal
lLado     := iif( sc2->c2_lado == 'S', .T. , .F. )
//
//
nLotQuebra := SC2->C2_QTDLOTE // Aqui ja posicionando a quantidade por lote de quebra
nQtPlano   := SC2->C2_QUANT
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
@ 10, 80 say "OP Siga:" 	Color CLR_HBLUE object oObj2
@ 10,170 say "Emissão:" 	Color CLR_HBLUE object oObj3
@ 10,240 say "Cliente: " 	Color CLR_HBLUE object oObj4
//
// @ 10,25  say SC2->C2_OPMIDO 			object oObj6
@ 07,25 BUTTON SC2->C2_OPMIDO   SIZE 50 ,12  of oDlgDet1 Pixel // ACTION  e_fabric()


@ 10, 108 say SC2->C2_NUM 	 			object oObj7
@ 10,200 say Dtoc( SC2->C2_EMISSAO )		object oObj8
@ 07,265 BUTTON SC2->C2_CLIENTE  + "/" + C2_LOJA 	 + '-'+ Alltrim(Posicione('SA1' , 1 , xFilial('SA1') + SC2->C2_CLIENTE + SC2->C2_LOJA, 'A1_NOME'    )  );
SIZE 200,12  of oDlgDet1 Pixel // ACTION  e_fabric()
//
@ 10,475   say "Release: " 	Color CLR_HBLUE object oObj5
@ 10 ,500   say Alltrim(  SC2->C2_RELEASE  )  +'-' +  Dtoc( C2_DTRELE) 	object oObj12
//
@ 25,05  say "Produto: " 	Color CLR_HBLUE object oObj9
@  23,35 BUTTON Alltrim(C2_PRODUTO) + '-' +  Alltrim( Posicione('SB1' , 1 , xFilial('SB1') + SC2->C2_PRODUTO, 'B1_DESC'    )  ) ;
SIZE 175,12  of oDlgDet1 Pixel // ACTION  e_fabric()

@ 25,220   say "Qtde. : " 	Color CLR_HBLUE object oObj10
@ 25,240   say Alltrim( Transform( SC2->C2_QUANT , '@E 99,999,999.9999')  )   	object oObj11
@ 25,280   say "Previsão: " 	Color CLR_HBLUE object oObj13
@ 25,310   say Dtoc( SC2->C2_DATPRF )  	object oObj14
@ 25,350   say "Multiplos : " 	Color CLR_HBLUE object oObj15
@ 25,383   say Alltrim( Transform( SC2->C2_QTDLOTE , '@E 99999999')  )  + '   Peça'+ iif(SC2->C2_QTDLOTE > 1, 's','' )  	object oObj16
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
DbSelectArea('SC2')
DbSetOrder(1)
DbSeek(   xFilial('SC2') + cMainOp + '01001'   )  //  Posicionando na OP Principal
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
@ 285  ,200 BUTTON 'Imp Grafico'  SIZE 56,12 ACTION U_MD1_GRFCORG(cMainOp, SC2->C2_OPMIDO) of oDLGDet1 Pixel 
//

Activate Dialog oDlgDet1 Centered
//
Return()
//------------------------------------------------------------
Static Function clk_LST()
Local cFicMain := acFics[obrfics:nAt,2]
Local lFlagChk  := acFics[obrfics:nAt,1]
Local nn1 := 0
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
Local nn1 := 0

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
Local nQtNivel
Local nn1 := 0
acPrds := {}
//
DbSelectArea('SC2')
DbSetOrder(1)
if DbSeek(   xFilial('SC2') + cMainOp + '01001'   )  //  Posicionando na OP Principal
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
//
aGrpOps := {} // Array contendo os grupos de produtos
//
nRecSc2 := SC2->( Recno() )
DbSelectArea('SC2')
DbSetOrder(1)
set filter to
DbGoTop()
if ! DbSeek(   xFilial('SC2') + cMainOp + '01001'   )  //  Posicionando na OP Principal
	Alert('Op Princopal do PLano nao Encontrada. Entre em contato com o Administrador do Sistema.')
	Return()
Endif
//
cProdPA := SC2->C2_PRODUTO // Produto principal
//
  
While ! eof() .and. C2_FILIAL == xFilial('SC2') .and.  C2_NUM  == cMainOp

	//
	//	if C2_ITEM + C2_SEQUEN == '01001'  // o PRIMEIRO PRODUTO NAO INTERESSA NESSA LISTA
	//	   Dbskip()
	//	   Loop
	//	Endif
	*/
	//
	cNumSup1 :=  '' // Numero Superior do Lancamento
	cProdPI1    := SC2->C2_PRODUTO // Produto principal
	//
	//
//	Alert('Pesquisando -> '+cProdPI1)
	DbSelectArea('SB1')
	DbSeek( xFilial('SB1') + SC2->C2_PRODUTO )
	DbSelectArea('SC2')
	cLadob1           := iif( !empty(sb1->b1_lado), sb1->b1_lado, 'A' )
	//
	//
	DbSelectArea('SG1')
	DbSetORder(1)
	DbSeek( xFilial( 'SG1' ) + SC2->C2_PRODUTO  )
	While ! eof() .and. G1_FILIAL = XFILIAL('SG1') .AND. G1_COD = SC2->C2_PRODUTO
		nRecAtu := Recno()
//	Alert('Prod. principal-> '+cProdPA+' OP: -> '+cMainOP+' SC2->C2_NUM-> '+SC2->(C2_NUM+C2_SEQUEN) )  
		//
		nRecNivel      :=  SG1->( Recno() )
		cCompoNivel := SG1->G1_COMP
		// cUmCompnivel := Posicione('SB1',1,xFilial('SB1') + cCompoNivel, 'B1_UM' )
		//
		// Descendo a um nivel abaixo
		DbSelectArea( 'SG1' )
		DbSetORder( 1 )
		DbSeek( xFilial( 'SG1' ) + cCompoNivel  )
		//
		SB1->( DbSeek( xFilial('SB1') + cCompoNivel )  )
		//
		// if ! DbSeek( xFilial( 'SG1' ) + cCompoNivel  )
		if !found() .or. SB1->B1_UM == 'M2'
			//
			SG1->(  DbGoTo( nRecNivel )  )
			nQtNivel        := SG1->G1_QUANT
			//
			DbSelectArea('SB1')
			DbSeek( xFilial('SB1') + SG1->G1_COMP  )
			//
			nRetPos := Ascan(  aGrpOps ,     {|x| x[1] == SG1->G1_COMP    }  )
			//
			//
			if Substr(SG1->G1_COMP,1,2) <> 'MO' //Verifica se o produto é do tipo Mao de Obra e nao adiciona nas fichas.... - Anesio - Taggs Consultoria
				IF nRetPos == 0
					AAdd( aGrpOps , { SG1->G1_COMP , ALLTRIM( SB1->B1_DESC ) , SC2->C2_QUANT * nQtNivel , SC2->C2_QUANT , cLadob1   }  )
				Else
					aGrpOps[ nRetPos , 3  ]  += SC2->C2_QUANT * nQtNivel
					aGrpOps[ nRetPos , 4  ]  += SC2->C2_QUANT
				Endif
			Endif
//			if Substr(SC2->C2_OPC,1,7) <> space(7)
//				Alert("Adicionando...: GRUPO "+Substr(SC2->C2_OPC,1,3)+" ITEM-> "+Substr(SC2->C2_OPC,4,4))
//			endif                                 
			if Substr(SC2->C2_OPC,1,7) <> space(7)
				if Substr(SC2->C2_OPC,1,7) == SG1->G1_GROPC+SG1->G1_OPC
					AAdd( aGrpAuxOps , { SG1->G1_COMP , ALLTRIM( SB1->B1_DESC ) , SC2->C2_PRODUTO , SC2->C2_QUANT, SG1->G1_QUANT,SC2->C2_QUANT * nQtNivel , cLadob1, sc2->c2_ITEM, SC2->C2_SEQUEN }  )
				endif
			else
				AAdd( aGrpAuxOps , { SG1->G1_COMP , ALLTRIM( SB1->B1_DESC ) , SC2->C2_PRODUTO , SC2->C2_QUANT, SG1->G1_QUANT,SC2->C2_QUANT * nQtNivel , cLadob1, sc2->c2_ITEM, SC2->C2_SEQUEN }  )
			endif
			//
		Endif
		//
		DbSelectArea('SG1')
		DbGoTo( nREcAtu )
		DbSkip()
	Enddo
	*/
	//ENDIF
	//	//
	DbSelectArea('SC2')
	Dbskip()
Enddo

//
set filter to C2_FILIAL== xFilial("SC2") .And. C2_TPOP == "F" .And. C2_LIBER == "OK"
dbGoTo(  nRecSc2  )
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
//------------------------------------------------------------
User Function xxx1()
//
//  Lembrando que o sistema, por contingencia do cliente, utilizar 3 degraus fixamente.
aNivel1 := {}
aNivel2 := {}
aNivel3 := {}
//
cEmpAnt := '01'
RpcSetType(3)
RpcSetEnv(cEmpAnt, '08','09',,,, { "SG1", "SB1", "SC2" } )
//
// aNivel1  :=  Explode1( '002345         ' , 0 , 0   )
// aUsers := TRZUsers() // AllUsers()//Usuarios

u_Mandaport()
//U_PegaSenhas()
//------------------------

// cPsw := __Decript(aSession[2])
//
/*
cUs := ''
For nn1 := 1 to len( aUsers )
for nn2 := 1 to len(aUsers[nn1] )
cUs +=  aUsers[nn1, nn2,1 ] + ' psw: ' + __Decript( aUsers[nn1, nn2,3 ] )
Next
Next
*/
return()
//
//------------------------------------------------------------------------------------------------------------------
Static Function  TRZUsers(lSerie,lAlfa)
aReturn	:= {}
lGetPsw	:= .t. // Trim(FunName()) == "APCFG30" .or. __Ap5GetPsw()
cMemo		:= ""
cUser		:= ""
cUserName	:= ""
cUserPsw	:= ""
private nPos
private nRet
private nOrder
cPswFile := 'SIGAADV.PSS'

lSerie	:= If(lSerie==Nil,.F.,lSerie)
lAlfa 	:= If(lAlfa==Nil,.F.,lAlfa)
nOrder  := If(lAlfa,2,1)

hFPsw :=PSW_FUSE(cPswFile)

nRet := SPF_SEEK( cPswFile, "1U000000", 1 )
If nRet > 0	// Administrador
	Aadd(aReturn,AdmInfo())
EndIf

nRet :=  SPF_GOTOP( cPswFile, nOrder)
While nRet > 0
	
	SPF_GETFIELDS( cPswFile, nRet, @cUser, @cUserName, @cUserPsw, @cMemo)
	
	If ( AllTrim(cUser) == "1U000000" .Or. Subs(cUser,1,2) $ "1G|2U|1S" )
		nRet := SPF_SKIP( cPswFile, nRet, nOrder )
		Loop
	EndIf
	
	If !Empty( cMemo )
		Aadd( aReturn, aClone(Str2Array(cMemo)) )
		nPos := Len(aReturn)
		Asize(aReturn[nPos][1],23)
		aReturn[nPos][1][3] := If(lGetPsw,__Encript(aReturn[nPos][1][3]),Replicate("*",20))
		aReturn[nPos][1][22] := If(aReturn[nPos][1][22] == NIL, Space(10), aReturn[nPos][1][22])
		// Range dDataBase
		aReturn[nPos][1][23] := If(aReturn[nPos][1][23] == NIL,{.F.,0,0},aReturn[nPos][1][23])
		
		aReturn[nPos][2][12] := LTrim(Padr(aReturn[nPos][2][12],50))
		
		If !lSerie
			Adel(aReturn[nPos],4)
			Asize(aReturn[nPos],Len(aReturn[nPos])-1)
		Else
			If Len(aReturn[nPos]) < 5
				Aadd( aReturn[nPos], {} )
			EndIf
			If Len(aReturn[nPos]) < 6
				Aadd( aReturn[nPos], {} )
			EndIf
		EndIf
	EndIf
	
	nRet := SPF_SKIP( cPswFile, nRet, nOrder )
End

__Ap5GetPsw(.F.)

Return aReturn

// ------------------------------------------------------

// Funcao que explode a estrutura de acordo com o codigo do produto que pediu
Static Function Explode1( cProduto, nNivelPai, nPosPai  )
//
Local aArray1 := {}
//
DbSelectArea( 'SG1' )
DbSeek( xFilial( 'SG1' ) + cProduto  )
While ! eof() .and. G1_FILIAL == XFILIAL('SG1') .AND. G1_COD  == cProduto
	//
	DBSELECTAREA('SB1')
	DBSETORDER(1)
	DBSEEK( XFILIAL('SB1') + SG1->G1_COMP )
	//
	DBSELECTAREA('SG1')
	AAdd( aArray1 ,  { G1_COD,G1_COMP,G1_QUANT , SB1->B1_UM, nNivelPai, nPosPai  }  )
	DBSKIP()
ENDDO
RETURN( aArray1 )
//-----------------------------------------------------------
// A funcao abaixo tem como objetivo carregar os itens de produtos intermediarios a partir das materias primas lancadas
Static Function ChngGrpPrs()
Local nn1 := 0
//
aGrpDispAux := {}
aFicsAux      := {}
cMPMain := acPrds[obrProds:nAt,1]
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
//
obrfics:SetArray(acFics)
obrfics:bLine := { || { iif( acFics[obrfics:nAt,1], ook, oNo ) , acFics[obrfics:nAt,2],acFics[obrfics:nAt,3],acFics[obrfics:nAt,4],acFics[obrfics:nAt,5] , acFics[obrfics:nAt,6] , acFics[obrfics:nAt,7], acFics[obrfics:nAt,8], acFics[obrfics:nAt,9], acFics[obrfics:nAt,10], acFics[obrfics:nAt,11], acFics[obrfics:nAt,12] }  }


obrfics:Refresh()
//
//
For nn1 := 1 to len( aGrpAuxOps )
	if ( alltrim( aGrpAuxOps[ nn1 , 1  ]  ) == alltrim( cMPMain  )  ) .or.  ( alltrim( cMPMain  ) == 'TODOS' )
		//
		AAdd( aGrpDispAux , { Alltrim(aGrpAuxOps[ nn1 , 3  ] ) , Alltrim(Posicione( 'SB1', 1, xFilial('SB1') + aGrpAuxOps[ nn1 , 3  ], 'B1_DESC' ) ) , Alltrim(Transform( aGrpAuxOps[ nn1 , 4  ] ,'@E 99,999.9999' ) )  , Alltrim( Transform( aGrpAuxOps[ nn1 , 6  ] ,'@E 99,999.9999' )  ) ,Alltrim( Transform( aGrpAuxOps[ nn1 , 5  ] ,'@E 99,999.9999' )  )   }  )
	Endif
Next
//
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

user Function VerAP_SZ7()
Local nn1 := 0
Local nn2 := 0
//          
ncont:= 0
DbSelectArea('SZ7')
DbSetOrder(1) // Ordenando por Z7_NUMFC + Z7_FASE

cQuery := "Select R_E_C_N_O_ as Rec   from "+ RetSqlName( 'SZ7' ) + " where D_E_L_E_T_ =' ' and Z7_FILIAL = '" + xFilial('SZ7') + "' and Z7_PLANO ='"+ Alltrim( cPlano ) + "' "

//
if select('TRBZ7') > 0
	DbSelectArea( 'TRBZ7' )
	DbCloseArea()
Endif
//
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZ7',.T.,.T. )
DbGoTop()
//

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
local cGpCort := GetMv( 'MA_GPCORT' )
Local nquebra1 := 0
Local nn1 := 0
Local nn2 := 0
Local nz1 := 0
Local iPVC := 0
//
IF LtemFicha
	//
	
	if !U_VerAP_SZ7()
		Alert( 'Não é possível Gerar a(s) Ficha(s) de Corte.'+ chr(13) + chr(10)+'Motivo: Foi(ram) encontrado(s) apontamento(s) para este Plano.' )
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
		cQuery := "UPDATE "+ RetSqlName( 'SZ3' ) + " SET D_E_L_E_T_ = '*' where Z3_FILIAL = '" + xFilial('SZ3') + "' and Z3_NUMOP ='"+ Alltrim( cMainOp )
		cQuery +="' "
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
Else
	// O bloco abaixo tem como objetivo validar se o plano considera lado e se tem algum produto com lado em branco
	/*
	lErro      := .F.
	cItensErro := ''
	For nn1 := 1 to len(aGrpAuxOps)
	if Alltrim( aGrpAuxOps[ nn1 , 7 ] ) == ''
	lErro := .T.
	cErro += aGrpAuxOps[ nn1 , 3 ] + chr(13) + chr(10)
	Endif
	//
	NExt
	//
	if lerro
	Alert( 'Atenção, há erro de estrutura, com produto(s) com lado não assignado' + chr(13) + chr(10) + cErro + 'Por Favor corrija')
	REturn(.F. )
	Endif
	*/
Endif
//
For nz1 := 1 to Len( aLAdos )
	ProcRegua( len( acPrds ) )
	For nn2 := 1 to len( acPrds )
		//
		IncProc()
		cMPMain := acPrds[ nn2,1 ]
		
		//
		//
		For nn1 := 1 to len( aGrpAuxOps )
			//
			/*
			if alltrim( aGrpAuxOps[ nn1 , 3  ] ) $ '014482|014481'
			alert(  'cMpMain :' + alltrim( cMPMain  ) + chr(13) +  ' - Produto PI :' +  alltrim( aGrpAuxOps[ nn1 , 3  ]  ) + chr(13) +  ' Lado aLAdos :' + aLAdos[nz1] + chr(13) +   '  Lado aGrpAuxops  : ' +  alltrim( aGrpAuxOps[ nn1 , 7  ]  )  )
			Endif
			*/
			//
			if alltrim( aGrpAuxOps[ nn1 , 7  ]  ) ==''
				aLAdos[nz1] == ' '
			Endif
			//
			if   ( alltrim( aGrpAuxOps[ nn1 , 1  ]  ) == alltrim( cMPMain  )   )  .and. (  aLAdos[nz1] == ' '  .or.       alltrim( aGrpAuxOps[ nn1 , 7  ]  ) == aLAdos[ nz1 ] )
				// if (   (alltrim( cMPMain  ) == 'TODOS' ) .or. ( alltrim( aGrpAuxOps[ nn1 , 1  ]  ) == alltrim( cMPMain  )  ) )  .and. (  aLAdos[nz1] == ' '  .or.       alltrim( aGrpAuxOps[ nn1 , 7  ]  ) == aLAdos[ nz1 ] )
				
				//
				/*
				if alltrim( aGrpAuxOps[ nn1 , 3  ] ) $ '014482|014481'
				alert(  'Ta Dentro '+ Chr(13) + 'cMpMain :' + alltrim( cMPMain  ) + chr(13) +  ' - Produto PI :' +  alltrim( aGrpAuxOps[ nn1 , 3  ]  ) + chr(13) +  ' Lado aLAdos :' + aLAdos[nz1] + chr(13) +   '  Lado aGrpAuxops  : ' +  alltrim( aGrpAuxOps[ nn1 , 7  ]  )  )
				Endif
				*/
				//
				cQuery := "Select *  from "+ RetSqlName( 'SC2' ) + " where D_E_L_E_T_ =' ' and C2_FILIAL = '" + xFilial('SC2') + "' and C2_NUM ='"+ Alltrim( cMainOp )
				cQuery +="' And C2_PRODUTO = '" + Alltrim( aGrpAuxOps[nn1  ,3 ]  ) + "'"
				//
				if select('TRBC2') > 0
					DbSelectArea( 'TRBC2' )
					DbCloseArea()
				Endif
				//
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBC2',.T.,.T. )
				//
				// Abaixo a tabela sera alimentada de fato
				// Aqui neste laco serao feitas as quebras de quantidades para a alimentacao do SZ3. La somente sera descarregada e lancada no arquivo ja preparado
				cNFicha := Alltrim(  aLAdos[ nz1 ]  ) +   SC2->C2_NUM
				//
				// O bloco abaixo tem como objetivo verificar se a quantidade em Lote lancada no plano for > que a qtde. da op, considera a quantidade da op
				if  aGrpAuxOps[ nn1 , 4  ] <  nLotQuebra
					nQuebra   := 1
				Else
					//
					nQuebra   := iif( aGrpAuxOps[ nn1 , 4  ] / nLotQuebra < 1 , 0 , aGrpAuxOps[ nn1 , 4  ] / nLotQuebra )
					if nQuebra - Int( nQuebra )  > 0
						nQuebra  ++
					Endif
					//
				Endif
				//
				//
				nTdPrfull := aGrpAuxOps[ nn1 , 4  ]
				//
				nSeqFc := 0 // Sequencia
				nSaldo  := aGrpAuxOps[ nn1 , 4  ]  *  aGrpAuxOps[ nn1 , 5  ] // Saldo em metros quadrados
				//
				For nquebra1 := 1 to nQuebra // Subindo a quantidade quebrada
					//
					// O bloco abaixo tem como objetivo pegar a sequencia da ficha e incrementar de acordo com a quebra do item, verificando qual a posicao deste na array auxiliar de pis
					//
					nSeqFc ++
					//
					cFicNum := cNFicha + Strzero( nSeqFc , 3 )
					//
					if nLotQuebra  > aGrpAuxOps[ nn1 , 4  ]
						nTdPrfull -=  aGrpAuxOps[ nn1 , 4  ]
						nProxQt :=  aGrpAuxOps[ nn1 , 4  ]
						//
						nSaldo  -= aGrpAuxOps[ nn1 , 4  ]  *  aGrpAuxOps[ nn1 , 5  ] // Saldo em metros quadrados
					Else
						nQtExtrair := iif( nTdPrfull >= nLotQuebra,  nLotQuebra, nTdPrfull )
						//
						nTdPrfull -=  nQtExtrair
						//
						// nProxQt := iif(  ( nTdPrfull + nLotQuebra ) -   nLotQuebra >= 0, nLotQuebra, nTdPrfull )
						nProxQt :=  nQtExtrair
						// nSaldo  -= aGrpAuxOps[ nn1 , 4  ]  *  aGrpAuxOps[ nn1 , 5  ] // Saldo em metros quadrados
					Endif
					//
					//
					if cGerFCPVC <> 'S' // Só adiciona se nao gerar multiplos de PVC diferenciado....
						AAdd( aPisFic,  {   .t. , ;   // flag
						cNFicha + ALLTRIM(cMPMain) + STRZERO( nSeqFc, 3 ) , ; // numero da ficha
						Dtoc( dDataBase ),; // Data Base da Geracao da Ficha
						'N',; // Tipo da Ficha ( N- Normal; C- Complementar )
						'',; // Data do Apontamento da Ficha
						cMPMain ,; // Materia Prima
						Alltrim(aGrpAuxOps[ nn1 , 3  ] ) ,; // Poduto Intermediario no qual sera produzido
						Alltrim( Posicione('SB1' , 1 , xFilial('SB1') + Alltrim( aGrpAuxOps[ nn1 , 3  ]  ) , 'B1_DESC'    )  ) ,; //  Descricao do Produto Intermediario
						TRansform( nProxQt,'@E 99,999.9999' ) , ; // Quantidade do Lote
						TRansform( nProxQt *  aGrpAuxOps[ nn1 , 5  ] , '@E 99,999.9999' )  , ; // Metros Quadrados utilizados
						TRansform( aGrpAuxOps[ nn1 , 5  ] , '@E 99,999.9999' ) ,; // M2 Padrao
						' ' }  )  // Numero do Cartao
						//
						AAdd( az3Fic ,;
						{   .t. , ;   // flag
						cNFicha + ALLTRIM(cMPMain) + STRZERO( nSeqFc, 3 ) , ; // numero da ficha
						dDataBase ,; // Data Base da Geracao da Ficha
						'N',; // Tipo da Ficha ( N- Normal; C- Complementar )
						'',; // Data do Apontamento da Ficha
						cMPMain ,; // Materia Prima
						Alltrim(aGrpAuxOps[ nn1 , 3  ] ) ,; // Poduto Intermediario no qual sera produzido
						Alltrim( Posicione('SB1' , 1 , xFilial('SB1') + Alltrim( aGrpAuxOps[ nn1 , 3  ]  ) , 'B1_DESC'    )  ) ,; //  Descricao do Produto Intermediario
						nProxQt, ; // Quantidade do Lote
						nProxQt *  aGrpAuxOps[ nn1 , 5  ]  , ; // Metros Quadrados utilizados
						aGrpAuxOps[ nn1 , 5  ]  ,; // M2 Padrao
						' ' }  )  // Numero do Cartao
					else
						if Posicione("SB1",1,xFilial("SB1")+Padr(cMPMain,15),"B1_GRUPO") $ cGpCort
							AAdd( aPisFic,  {   .t. , ;   // flag
							cNFicha + ALLTRIM(cMPMain) + STRZERO( nSeqFc, 3 ) , ; // numero da ficha
							Dtoc( dDataBase ),; // Data Base da Geracao da Ficha
							'N',; // Tipo da Ficha ( N- Normal; C- Complementar )
							'',; // Data do Apontamento da Ficha
							cMPMain ,; // Materia Prima
							Alltrim(aGrpAuxOps[ nn1 , 3  ] ) ,; // Poduto Intermediario no qual sera produzido
							Alltrim( Posicione('SB1' , 1 , xFilial('SB1') + Alltrim( aGrpAuxOps[ nn1 , 3  ]  ) , 'B1_DESC'    )  ) ,; //  Descricao do Produto Intermediario
							TRansform( nProxQt,'@E 99,999.9999' ) , ; // Quantidade do Lote
							TRansform( nProxQt *  aGrpAuxOps[ nn1 , 5  ] , '@E 99,999.9999' )  , ; // Metros Quadrados utilizados
							TRansform( aGrpAuxOps[ nn1 , 5  ] , '@E 99,999.9999' ) ,; // M2 Padrao
							' ' }  )  // Numero do Cartao
							//
							AAdd( az3Fic ,;
							{   .t. , ;   // flag
							cNFicha + ALLTRIM(cMPMain) + STRZERO( nSeqFc, 3 ) , ; // numero da ficha
							dDataBase ,; // Data Base da Geracao da Ficha
							'N',; // Tipo da Ficha ( N- Normal; C- Complementar )
							'',; // Data do Apontamento da Ficha
							cMPMain ,; // Materia Prima
							Alltrim(aGrpAuxOps[ nn1 , 3  ] ) ,; // Poduto Intermediario no qual sera produzido
							Alltrim( Posicione('SB1' , 1 , xFilial('SB1') + Alltrim( aGrpAuxOps[ nn1 , 3  ]  ) , 'B1_DESC'    )  ) ,; //  Descricao do Produto Intermediario
							nProxQt, ; // Quantidade do Lote
							nProxQt *  aGrpAuxOps[ nn1 , 5  ]  , ; // Metros Quadrados utilizados
							aGrpAuxOps[ nn1 , 5  ]  ,; // M2 Padrao
							' ' }  )  // Numero do Cartao
						endif
					endif
						//
					//Rotina para testar se o produto eh 239L e gerar multiplos de 50 nas fichas de PVC - implementado por Anesio

					cPAcabado := Posicione("SC2",1,xFilial("SC2")+cMainOP,"C2_PRODUTO")
					lPVC := .F.
					nRetPosPRD := 0 
//					if Substr(cPAcabado,1,6)=='013303' .or. Substr(cPAcabado,1,6)=='013304'
						if !Posicione("SB1",1,xFilial("SB1")+Padr(cMPMain,15),"B1_GRUPO") $ cGpCort 
//							nRetPosPrd := Ascan(  aPrdPVC ,     {|x| x == Padr(cMPMain,15)    }  )
//							if nRetPosPrd == 0
								Aadd(AprdPVC, { Padr(cMPMain,15) } )
//							else
//								Alert("Diferente")
//							endif
							Aadd(AgrpPVC, {XFILIAL('SZ3'), SC2->C2_OPMIDO, cMainOp, cNFicha + ALLTRIM(cMPMain), 'N', dDataBase, Time(), cMPMain, Alltrim(aGrpAuxOps[ nn1 , 3  ] ), nProxQt, aGrpAuxOps[ nn1 , 5  ], nProxQt *  aGrpAuxOps[ nn1 , 5  ], nProxQt, nProxQt *  aGrpAuxOps[ nn1 , 5  ],'A', 1,aGrpAuxOps[ NN1, LEN(aGrpAuxOps[ NN1 ] ) -1  ],aGrpAuxOps[ NN1, LEN(aGrpAuxOps[ NN1 ] )  ]})
							lPVC := .T.
						endif
//					endif
					
						
//  					if !lPVC
					// Gravando os dados na SZ3
					DbSelectArea('SZ3' )
					Reclock('SZ3',.T. )
					Replace Z3_FILIAL 			WITH XFILIAL('SZ3')
					Replace Z3_PLANO			WITH SC2->C2_OPMIDO
					Replace Z3_NUMOP 			WITH cMainOp
					Replace Z3_NUMFC			WITH cNFicha + ALLTRIM(cMPMain) + STRZERO( nSeqFc, 3 )
					Replace Z3_TPFCH 			WITH 'N'
					Replace Z3_DTFICHA 			WITH dDataBase
					Replace Z3_HRFICHA 			WITH Time()
					Replace Z3_MATERIA 			WITH cMPMain
					Replace Z3_PRODUTO 			WITH Alltrim(aGrpAuxOps[ nn1 , 3  ] )
					Replace Z3_QTDE 			WITH nProxQt
					Replace Z3_M2PAD 			WITH aGrpAuxOps[ nn1 , 5  ]
					Replace Z3_M2TOT 			WITH nProxQt *  aGrpAuxOps[ nn1 , 5  ]
					Replace Z3_SALDO 			WITH nProxQt
					Replace Z3_SLDM2 			WITH nProxQt *  aGrpAuxOps[ nn1 , 5  ]
					Replace Z3_STATUS 			WITH 'A'
					Replace Z3_VIAIMP 			WITH 1
					Replace Z3_ITEM      		WITH aGrpAuxOps[ NN1, LEN(aGrpAuxOps[ NN1 ] ) -1  ]
					Replace Z3_SEQUEN           WITH aGrpAuxOps[ NN1, LEN(aGrpAuxOps[ NN1 ] )  ]
					
					MsUnlock()
//					endif           
					lPVC := .F.
					lTemFicha := .T. // Flag informando que ainda nao tem fichas de corte lancados para a ordem de producao
					//
				Next
				//
			Endif
		Next
		//
		//
	Next
Next
//

	//Adicionar as fichas de PVC        
	        if cGerFCPVC == 'S'                 
//	        	aPisFic := {}
//	        	aZ3Fic  := {} 
				if len(AgrpPVC) > 0 
//					Alert('Comecando o processo....'+Substr(AgrpPVC[1,4],1,1))
					nCaracter := 0
					if Substr(AgrpPVC[1,4],1,4) $ 'A|B' 
						nCaracter := 13
					else
						nCaracter := 12
					endif

					cPrdPVC := "'"+aPrdPVC[1][1]+"',"
					cPrdOld := aPrdPVC[1][1]
					aPrdPVC := aSort(aPrdPvc, 1,, {|x,y| x[1]<y[1]} )

					for iPVC := 1 to len (aPrdPvc)
						if cPrdOld <> aPrdPVC[iPVC][1]                     
							cPrdPvc := cPrdPVC + "'"+aPrdPVC[iPVC][1]+"',"
							cPrdOld := aPrdPVC[iPVC][1]
						endif
					next iPVC                      

					cPrdPVC := Substr(cPrdPVC,1,len(cPrdPVC)-1)
//					Alert("cPrd-> "+cPrdPVC)
					cQryPVC := " Select Z3_FILIAL, Z3_PLANO, Z3_NUMOP, Substring(Z3_NUMFC,1,13) Z3_NUMFC, Z3_TPFCH, Z3_DTFICHA, "
					cQryPVC += " Z3_HRFICHA, Z3_CORTADO, Z3_MATERIA, Z3_PRODUTO, Sum(Z3_QTDE) Z3_QTDE, AVG(Z3_M2PAD) Z3_M2PAD, "
					cQryPVC += " Sum(Z3_M2TOT) Z3_M2TOT, Sum(Z3_SLDM2) Z3_SLDM2, SUM(Z3_SALDO) Z3_SALDO, Z3_STATUS, Z3_VIAIMP, Z3_LADO,  "
					cQryPVC += " Z3_ITEM, Z3_SEQUEN, Z3_LOTE from SZ3010 where D_E_L_E_T_ = ' ' "
					cQryPVC += " and Z3_NUMOP = '"+cMainOp+"' and Z3_MATERIA in ("+cPrdPVC+") "
					cQryPVC += " group by Z3_FILIAL, Z3_PLANO, Z3_NUMOP, Substring(Z3_NUMFC,1,13), Z3_TPFCH, Z3_DTFICHA, "
					cQryPVC += " Z3_HRFICHA, Z3_CORTADO, Z3_MATERIA, Z3_PRODUTO, Z3_STATUS, Z3_VIAIMP, Z3_LADO, Z3_ITEM, Z3_SEQUEN, Z3_LOTE "

					if Select("TRPVC") > 0
						dbSelectArea("TRPVC")
						dbCloseArea()
					endif

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryPVC),'TRPVC',.T.,.T. )					

					cQDelPVC := "UPDATE "+ RetSqlName( 'SZ3' ) + " SET D_E_L_E_T_ = '*' where Z3_FILIAL = '" + xFilial('SZ3') + "' and Z3_NUMOP ='"+ Alltrim( cMainOp )+"' and  Z3_MATERIA in ("+cPrdPVC+") "
					nretPVC  := TcSqlExec( cQDelPVC )
 					nCount   := 0  
 					nTotalPrd := Posicione("SC2",1,xFilial("SC2")+cMainOP, "C2_QUANT")
 					if nQTMultPVC > nTotalPrd
 						nQtMultPVC := nTotalPrd
 					endif

 					nQtdePorFc:= nQTMultPVC
 					nMultPrd  := 1 //Variavel armazena o multiplo da peça
 					if nQtdePorFc >  nTotalPrd
 						nQtdePorFc := nTotalPrd
 					endif
 					dbSelectArea("TRPVC")
 					TRPVC->(dbGotop())
// 					Alert("Iniciando...nPercPRD-> "+cValTochar(nPercPrd)+" nPercAc-> "+cValToChar(nPercAc))
 					while !TRPVC->(eof())
 						nValorAcu   := 0 
 						nSeqFc := 1
 						nQtdePorFc :=nQTMultPVC
 						nMultPrd := TRPVC->Z3_QTDE / nTotalPrd
 						while nValorAcu < nTotalPRD
							DbSelectArea('SZ3' )
							Reclock('SZ3',.T. )
							  Z3_FILIAL 	:= TRPVC->Z3_FILIAL
							  Z3_PLANO		:= TRPVC->Z3_PLANO
							  Z3_NUMOP 		:= TRPVC->Z3_NUMOP
							  Z3_NUMFC		:= TRPVC->Z3_NUMFC + STRZERO( nSeqFc, 3 )
							  Z3_TPFCH 		:= 'N'
							  Z3_DTFICHA 	:= dDataBase
							  Z3_HRFICHA 	:= Time()
							  Z3_MATERIA 	:= TRPVC->Z3_MATERIA
							  Z3_PRODUTO 	:= TRPVC->Z3_PRODUTO
							  Z3_M2PAD 		:= TRPVC->Z3_M2PAD
						  	  Z3_QTDE 		:= nQtdePorFc * nMultPrd //TRPVC->Z3_QTDE
							  Z3_M2TOT 		:= (nQtdePorFc / nTotalPrd) * TRPVC->Z3_M2TOT // ((nQtdePorFc / nMultPrd) / nTotalPrd) * TRPVC->Z3_M2TOT
							  Z3_SALDO 		:= (nQtdePorFc / nTotalPrd) * TRPVC->Z3_SALDO //((nQtdePorFc / nMultPrd) / nTotalPrd) * TRPVC->Z3_SALDO
							  Z3_SLDM2 		:= (nQtdePorFc / nTotalPrd) * TRPVC->Z3_SLDM2 //((nQtdePorFc / nMultPrd) / nTotalPrd) * TRPVC->Z3_SLDM2
							  Z3_STATUS 	:= 'A'
							  Z3_VIAIMP 	:= 1
							  Z3_ITEM      	:= TRPVC->Z3_ITEM
							  Z3_SEQUEN     := TRPVC->Z3_SEQUEN
							MsUnlock()

								AAdd( aPisFic,  {   .t. , ;   // flag
								TRPVC->Z3_NUMFC + STRZERO( nSeqFc, 3 ) , ; // numero da ficha
								Dtoc( dDataBase ),; // Data Base da Geracao da Ficha
								'N',; // Tipo da Ficha ( N- Normal; C- Complementar )
								'',; // Data do Apontamento da Ficha
								TRPVC->Z3_MATERIA ,; // Materia Prima
								TRPVC->Z3_PRODUTO ,; // Poduto Intermediario no qual sera produzido
								Alltrim( Posicione('SB1' , 1 , xFilial('SB1') + Padr(TRPVC->Z3_PRODUTO,15) , 'B1_DESC'    )  ) ,; //  Descricao do Produto Intermediario
								TRansform( nQtdePorFc * nMultPrd,'@E 99,999.9999' ) , ; // Quantidade do Lote
								TRansform( (nQtdePorFc / nTotalPrd) * TRPVC->Z3_M2TOT , '@E 99,999.9999' )  , ; // Metros Quadrados utilizados
								TRansform( (nQtdePorFc / nTotalPrd) * TRPVC->Z3_SLDM2 , '@E 99,999.9999' ) ,; // M2 Padrao
								' ' }  )  // Numero do Cartao
								//
								AAdd( az3Fic , {   .t. , ;   // flag
								TRPVC->Z3_NUMFC + STRZERO( nSeqFc, 3 ) , ; // numero da ficha
								dDataBase ,; // Data Base da Geracao da Ficha
								'N',; // Tipo da Ficha ( N- Normal; C- Complementar )
								'',; // Data do Apontamento da Ficha
								TRPVC->Z3_MATERIA ,; // Materia Prima
								TRPVC->Z3_PRODUTO ,; // Poduto Intermediario no qual sera produzido
								Alltrim( Posicione('SB1' , 1 , xFilial('SB1') + Padr(TRPVC->Z3_PRODUTO,15) , 'B1_DESC'    )  ) ,; //  Descricao do Produto Intermediario
								nQtdePorFc * nMultPrd, ; // Quantidade do Lote
								(nQtdePorFc / nTotalPrd) * TRPVC->Z3_M2TOT  , ; // Metros Quadrados utilizados
								(nQtdePorFc / nTotalPrd) * TRPVC->Z3_SLDM2  ,; // M2 Padrao
								' ' }  )  // Numero do Cartao


   						    nValorAcu  += nQtdePorFc
							nSeqFc++
							if nValorAcu + nQtdePorFc > nTOtalPrd
								nQtdePorFc := nTotalPrd - nValorAcu
							endif

							
							
						enddo
//							Alert("Total de Registros Atualizadoa -> "+TRPVC->Z3_PRODUTO+'Contador '+cValToChar(nCount))
 						TRPVC->(dbSkip())
 					enddo

				endif
			endif
/*                    nCount := 0
					for iPVC := 1 to Len(AgrpPVCAux) 	
  						DbSelectArea('SZ3' )
						Reclock('SZ3',.T. )
						Z3_FILIAL 			:=  AgrpPVCAux[iPVC, 1]
						Z3_PLANO			:=  AgrpPVCAux[iPVC, 2]
						Z3_NUMOP 			:=  AgrpPVCAux[iPVC, 3]
						Z3_NUMFC			:=  AgrpPVCAux[iPVC, 4]
						Z3_TPFCH 			:=  AgrpPVCAux[iPVC, 5]
						Z3_DTFICHA 			:=  AgrpPVCAux[iPVC, 6]
						Z3_HRFICHA 			:=  AgrpPVCAux[iPVC, 7]
						Z3_MATERIA 			:=  AgrpPVCAux[iPVC, 8]
						Z3_PRODUTO 			:=  AgrpPVCAux[iPVC, 9]
						Z3_QTDE 			:=  AgrpPVCAux[iPVC, 10]
						Z3_M2PAD 			:=  AgrpPVCAux[iPVC, 11]
						Z3_M2TOT 			:=  AgrpPVCAux[iPVC, 12]
						Z3_SALDO 			:=  AgrpPVCAux[iPVC, 13]
						Z3_SLDM2 			:=  AgrpPVCAux[iPVC, 14]
						Z3_STATUS 			:=  AgrpPVCAux[iPVC, 15]
						Z3_VIAIMP 			:=  AgrpPVCAux[iPVC, 16]
						Z3_ITEM      		:=  AgrpPVCAux[iPVC, 17]
						Z3_SEQUEN           :=  AgrpPVCAux[iPVC, 18]
						MsUnlock('SZ3')
						nCount++
					next iPVC   
					Alert("Total de Registros atualizados-> "+cValToChar(nCount))
  */					

//
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
//cQuery := "Select R_E_C_N_O_ as Rec   from "+ RetSqlName( 'SZ3' ) + " where D_E_L_E_T_ =' ' and Z3_FILIAL = '" + xFilial('SC2') + "' and Z3_NUMOP LIKE('%"+ Alltrim( cMainOp ) + "%') "
cQuery := "Select R_E_C_N_O_ as Rec   from "+ RetSqlName( 'SZ3' ) + " where D_E_L_E_T_ =' ' and Z3_FILIAL = '" + xFilial('SC2') + "' and Z3_NUMOP ='"+ Alltrim( cMainOp ) + "' "
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
		//
		AAdd( aPisFic,  {   .t. , ;   // flag
		SZ3->Z3_NUMFC  , ; // numero da ficha
		SZ3->Z3_DTFICHA,; // Data Base da Geracao da Ficha
		SZ3->Z3_TPFCH,; // Tipo da Ficha ( N- Normal; C- Complementar )
		DTOC( SZ3->Z3_DTAPON   ),; //  Data do Apontamento da Ficha
		ALLTRIM(SZ3->Z3_MATERIA)  ,; // Materia Prima
		ALLTRIM(SZ3->Z3_PRODUTO) ,; // Poduto Intermediario no qual sera produzido
		Alltrim( Posicione('SB1' , 1 , xFilial('SB1') + Alltrim( SZ3->Z3_PRODUTO  ) , 'B1_DESC'    )  ) ,; //  Descricao do Produto Intermediario
		TRansform( SZ3->Z3_QTDE ,'@E 99,999.9999' ) , ; // Quantidade do Lote
		TRansform( SZ3->Z3_M2TOT   , '@E 99,999.9999' )  , ; // Metros Quadrados utilizados
		TRansform( SZ3->Z3_M2PAD , '@E 99,999.9999' ) ,; // M2 Padrao
		ALLTRIM( SZ3->Z3_CARTAO )  }   )  // Numero do Cartao
		//
		//
		DbSelectArea('TRBZ3')
		Dbskip()
	Enddo
	//
Endif
//
if len(aPisFic) == 0
	AAdd( aPisFic,{ .f.,' ',' ',' ',' ',' ',' ',' ',' ',' ',' ' , ' ' }  )
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
Private tamanho := "P"
Private aReturn  := {"Zebrado",3,"Administracao", 1, 2,1, "",1 }	//"Zebrado"###"Administracao"
//Private cPerg    :="MDRLPL"
Private nLastKey := 0
Private lItemNeg := .F.
Private nomeprog := 'FCORTE1'
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
Local nn1 := 0
Local nk1 := 0
*/
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
	cCabecItem :=  'Produto a ser Cortado                      Qtd Pcs.  Total M2  Padrao'
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
					cCabecItem += '   Produto a ser Cortado                      Qtd Pcs.      Total M2       Padrao'
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
					AAdd( aItensPrn ,  padr( substr(cDscPr, 1,43 ), 43 ) + Transform(nvQtde, '@E 99,999,999' ) + '       ' + padr( alltrim( acFics[nK1 ,10 ] ) , 7)  +' '  + padr( alltrim(acFics[nK1 ,11 ] ) , 7  )   )
					nCont1 := 1
					nContador := 0
					*/
					//
				Else
					aItensPrn[  nCont1 - 14        ] +=   '  '  + padr(substr(cDscPr, 1,43 ),43 )  + Transform(nvQtde, '@E 99.999.999' ) + '  ' + padr( alltrim( acFics[nK1 ,10 ] ) , 7)  +' '  + padr( alltrim(acFics[nK1 ,11 ] ) , 7  )
				Endif
			Else
				AAdd( aItensPrn ,  padr( substr(cDscPr, 1,43 ), 43 ) + Transform(nvQtde, '@E 99,999,999' ) + '    ' + padr( alltrim( acFics[nK1 ,10 ] ) , 7)  +' '  + padr( alltrim(acFics[nK1 ,11 ] ) , 7  )   )
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
Local nz1 := 0
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
Local I, H := 0
//
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
Local nn1, nk1 := 0
//
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
For nn1 := 1 to len( acFics )
	if  acFics[nn1 , 1 ]
		nRetPos := Ascan(  aOkFics ,  acFics[ nn1, 2  ]  )
		//
		if nRetPos  == 0
			Aadd( aOkFics ,   acFics[ nn1, 2  ] )
			nTotFichas ++
		Endif
		
	Endif
Next
//
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
	SB1->( DbSeek( xFilial( 'SB1' ) + SC2->C2_PRODUTO  )  )
	//
	Titulo    := 'FICHA DE CORTE  - Plano  ' + aLLTRIM( SC2->C2_OPMIDO  )
	Cabec1    := 'OP Protheus: '   + aLLTRIM( SC2->C2_NUM  ) + '          Qtde. do Plano: ' + alltrim( str( nQtPlano ) )
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
	SB1->( DbSeek( xFilial( 'SB1' ) + SC2->C2_PRODUTO  )  )
	//
	Li --
	@ li,00 psay 'Material do Plano: ' + alltrim( SB1->B1_COD )  + '-' + sb1->b1_desc
	//
	Li ++
	//
	cStr1 := 'Cliente: '   +	Alltrim(Posicione('SA1' , 1 , xFilial('SA1') + SC2->C2_CLIENTE + SC2->C2_LOJA, 'A1_NOME'    )  )
	cStr1 += '  RELEASE: '  + ALLTRIM( SC2->C2_RELEASE ) + ' - ' + DTOC( SC2->C2_DTRELE )
	@ Li, 00 psay cStr1
	Li +=2
	//
	SB1->( DbSeek( xFilial( 'SB1' ) + SZ3->Z3_MATERIA )  )
	//
	cGrpMat := SB1->B1_GRUPO
	cDscMat := Alltrim( sb1->b1_desc )
	@ li,00 psay   'Material da Ficha: ' + ALLTRIM( SZ3->Z3_MATERIA ) + '-' +  Alltrim( cDscMat )
	cCouro:= iif(Posicione("SB1",1,xFilial("SB1")+SZ3->Z3_MATERIA,"B1_GRUPO")=='40  ','COURO','PVC')
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
	cStr1 += '  MULTIPLO : '  + ALLTRIM( STR( nMultiFCH )  )   + IIF( lLado, '    LADO : ' + cLado ,'' )
	//
	// cStr1 += '  ATUAL : ' +    OnNeg +ALLTRIM( STR( SZ3->Z3_QTDE  )  ) + '/' + ALLTRIM(  STR(SC2->C2_QUANT  ) ) + OffNeg
	@ li, 00 psay cStr1
	li += 2
	@ li,00 psay 'CORTADOR:                     NOME INSP.:                      LOTE:'
	Li ++
	@ li,000 PSAY __PrtThinLine()
	li++
	@ li,000 psay 'Produto a ser Cortado                          Qtd Pcs.          Total M2       Padrao'
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
			cCabecItem := '   Produto a ser Cortado                      Qtd Pcs. Total M2 Padrao'
			lPrimCabItem := .f.
			Endif
			//
			// Alert( 'nCont1 ' + Alltrim( Str(nCont1 )  ) +  '   nCont1 - 14  ' +  Alltrim( Str( nCont1 - 14  )  )  )
			//
			*/
			if nCont1 > 31
			//
			//   PrtItms( .T. )
			//                 
			PrtItens(.F.)
			
			Li := 0
			@ Li, 00 psay 'C0NTINUACAO DA FICHA DE CORTE  ' +   Alltrim( aOkFics[ nn1 ] ) 
			Li += 6
			//
			aItensPrn := {}
			AAdd( aItensPrn ,  padr( substr(cDscPr, 1,55 ), 55 ) + Transform(nvQtde, '@E 9999' ) + '     ' + padr( alltrim( acFics[nK1 ,10 ] ) , 8)  + padr( alltrim(acFics[nK1 ,11 ] ) , 8  )   )
			nCont1 := 1
			nContador := 0
			//
//			Else
//			aItensPrn[  nCont1 - 14        ] +=   '  '  + padr(substr(cDscPr, 1,43 ),43 )  + Transform(nvQtde, '@E 99999999' ) + '  ' + padr( alltrim( acFics[nK1 ,10 ] ) , 7)  +' '  + padr( alltrim(acFics[nK1 ,11 ] ) , 7  )

			Else
			
			AAdd( aItensPrn ,  padr( substr(cDscPr, 1,55 ), 55 ) + Transform(nvQtde, '@E 9,999,999' ) + '     ' + padr( alltrim( acFics[nK1 ,10 ] ) , 8)  + padr( alltrim(acFics[nK1 ,11 ] ) , 8  )   )
			
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
			if nCont1 == 31
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
		@ 059, 00 Psay "|---------------------------------------------------------------------------------|" +'  CT - 20    ' + alltrim( Str( m_pag - 1  ) ) + '/' + alltrim( str(nTotFichas) )
	else
		@ 051, 00 Psay "|----------------------- C A R T A O  D E  P R O C E S S O -----------------------|" 
		@ 052, 00 Psay "|  SETOR     |   DATA  |  RESPONSAVEL   ||  SETOR      |   DATA  |  RESPONSAVEL   |" 
		@ 053, 00 Psay "|ALMOXARIFADO|__/__/___|________________||CORTE        |__/__/___|________________|" 
		@ 054, 00 Psay "|EMBALAGEM   |__/__/___|________________||1ºCONTAGEM   |__/__/___|________________|" 
		@ 055, 00 Psay "|2ºCONTAGEM  |__/__/___|________________||EXPEDICAO    |__/__/___|________________|" 
		@ 056, 00 Psay "|                                                                                 |" 
		@ 057, 00 Psay "|                                                                                 |" 
		@ 058, 00 Psay "|                                                                                 |" 
		@ 059, 00 Psay "|---------------------------------------------------------------------------------|" 
	endif				


//	@ 60, 60 psay  'CT - 20    ' + alltrim( Str( m_pag - 1  ) ) + '/' + alltrim( str(nTotFichas) )
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
