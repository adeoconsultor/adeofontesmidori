#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#include "COLORS.CH"
/*
Funcao para importacao do arquivo TXT EDI Toyota
Desenvolvido por Willer Nery.
*/
//--------------------------------------------------------------------------------------------
User Function ImpEdiToy()
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?


SetPrvt("Z6_DTENT1,Z6_DTENT2,Z6_DTENT3,Z6_DTENT4,Z6_DTENT5")
SetPrvt("Z6_QTDENT1,Z6_QTDENT2,Z6_QTDENT3,Z6_QTDENT4,Z6_QTDENT5")

Private oDlgProc,oGrp,oBtnProc,oBtnCanc,oSay5,oCmbCli,oSay7,oGet8,oBtnAbrArq
Private cArquivo := space(50)
Private cCliArq  := space( 30 )
Private aErros   := {}  // Variavel que contera os erros encontrados no processamento
Private lErros    := .F.  // Flag indicativa de que nao houveram erros no processamento.
Private aArqs    := {}   //  Array que contera os arquivos a partir do parametro indicado, ou do diretorio escolhido
Private cArqDir  := Alltrim( GetMv('MV_TOYIMP') )
//
//
oDlgProc := MSDIALOG():Create()
oDlgProc:cName := "oDlgProc"
oDlgProc:cCaption := "Importacao de Arquivos EDI Toyota do Brasil"
oDlgProc:nLeft := 0
oDlgProc:nTop := 0
oDlgProc:nWidth := 368
oDlgProc:nHeight := 214
oDlgProc:lShowHint := .F.
oDlgProc:lCentered := .T.

oGrp := TGROUP():Create(oDlgProc)
oGrp:cName := "oGrp"
oGrp:nLeft := 3
oGrp:nTop := 5
oGrp:nWidth := 354
oGrp:nHeight := 132
oGrp:lShowHint := .F.
oGrp:lReadOnly := .F.
oGrp:Align := 0
oGrp:lVisibleControl := .T.
//
oSay5 := TSAY():Create(oDlgProc)
oSay5:cName := "oSay5"
oSay5:cCaption := "Cliente"
oSay5:nLeft := 15
oSay5:nTop := 17
oSay5:nWidth := 50
oSay5:nHeight := 17
oSay5:lShowHint := .F.
oSay5:lReadOnly := .F.
oSay5:Align := 0
oSay5:lVisibleControl := .T.
oSay5:lWordWrap := .F.
oSay5:lTransparent := .F.
//
//
aItems := { "","000375 - Toyota do Brasil" }
@ 05  , 43   COMBOBOX oClientes VAR cCliArq  ITEMS aItems SIZE 133,21 OF oDlgProc PIXEL
//
oSay7 := TSAY():Create(oDlgProc)
oSay7:cName := "oSay7"
oSay7:cCaption := "Arquivo TXT"
oSay7:nLeft := 12
oSay7:nTop := 55
oSay7:nWidth := 64
oSay7:nHeight := 17
oSay7:lShowHint := .F.
oSay7:lReadOnly := .F.
oSay7:Align := 0
oSay7:lVisibleControl := .T.
oSay7:lWordWrap := .F.
oSay7:lTransparent := .F.
//
oSay8 := TSAY():Create(oDlgProc)
oSay8:cName := "oSay8"
oSay8:cCaption := "Diretorio"
oSay8:nLeft := 12
oSay8:nTop := 95
oSay8:nWidth := 64
oSay8:nHeight := 17
oSay8:lShowHint := .F.
oSay8:lReadOnly := .F.
oSay8:Align := 0
oSay8:lVisibleControl := .T.
oSay8:lWordWrap := .F.
oSay8:lTransparent := .F.
//
aArqs    := Carr_Arqs( cArqDir  )
@ 27  , 43   COMBOBOX oArquivos VAR cArquivo  ITEMS aArqs SIZE 133,21 OF oDlgProc PIXEL
@ 47 , 43  get cArqDir  size 133,21  object oGetArq
//
oGetArq:Disable()
//

oBtnAbrArq := SBUTTON():Create(oDlgProc)
oBtnAbrArq:cName := "oBtnAbrArq"
oBtnAbrArq:cCaption := "Buscar Arquivo"
oBtnAbrArq:nLeft := 136
oBtnAbrArq:nTop := 148
oBtnAbrArq:nWidth := 52
oBtnAbrArq:nHeight := 22
oBtnAbrArq:lShowHint := .T.
oBtnAbrArq:lReadOnly := .F.
oBtnAbrArq:Align := 0
oBtnAbrArq:lVisibleControl := .T.
oBtnAbrArq:nType := 14
oBtnAbrArq:bAction := {|| AbreArq() }

//
oBtnProc := SBUTTON():Create(oDlgProc)
oBtnProc:cName := "oBtnProc"
oBtnProc:cCaption := "Processar"
oBtnProc:nLeft := 219
oBtnProc:nTop := 148
oBtnProc:nWidth := 72
oBtnProc:nHeight := 22
oBtnProc:lShowHint := .T.
oBtnProc:lReadOnly := .F.
oBtnProc:Align := 0
oBtnProc:lVisibleControl := .T.
oBtnProc:nType := 1
oBtnProc:bAction := {|| Processa( {|| ProcArq() },'Processando Arquivo ' + cArquivo  ) }
//
oBtnCanc := SBUTTON():Create(oDlgProc)
oBtnCanc:cName := "oBtnCanc"
oBtnCanc:nLeft := 301
oBtnCanc:nTop := 148
oBtnCanc:nWidth := 52
oBtnCanc:nHeight := 22
oBtnCanc:lShowHint := .F.
oBtnCanc:lReadOnly := .F.
oBtnCanc:Align := 0
oBtnCanc:lVisibleControl := .T.
oBtnCanc:nType := 2
oBtnCanc:bAction := {|| Fecha() }
//
oDlgProc:Activate()
Return
//---------------------------------------------------------------------------
Static Function Fecha()
Close( oDlgProc )
Return()
//---------------------------------------------------------------------------
Static Function AbreArq()
//cArqAux  := cGetFile("Texto | *.*" , "Informe o arquivo") //
cArqAux  := MsDocPAth()
//
if  ! empty( cArqAux )
	cArquivo := cArqAux
Endif
//
Return()
//---------------------------------------------------------------------------
// O bloco abaixo realizara a criacao do dbf das naturezas sinteticas por dia/mes/ano

Static Function ProcArq()
// User  Function ProcArq()
Local nk1,nn1,kk1
Private 		M->Z6_TEXTO1		:=	  ''
Private 		M->Z6_TEXTO2		:=	  ''
Private 		M->Z6_TEXTO3		:=	  ''
//
// cCodCli := '000003'
// cArquivo := 'C:\faurecia\arqfau_01.txt'

cArquivo :=  cArqDir + '\' +  cArquivo


if ! File( Alltrim( cArquivo) )
	Alert( ' Arquivo ' + cArquivo + ' Nao encontrado. Por favor corrija.')
	return()
Endif
//
nTamArq := 0  // Variavel que define qual o tamanho da linha do arquivo TXT
//
cCodCli := Substr( cCliArq , 1 , 6 )
if  cCodCli == '000375'
	//
	//SA1->( DbSeek( xFilial( 'SA1') + cCodCli ))
	nTamArq := 128  // Variavel que define qual o tamanho da linha do arquivo TXT
	//
Endif
//
// Aqui devera ser inserido um bloco que comparara qual o codigo escolhido para saber qual o tamanho da linha de codigo do arquivo txt do cliente
//
aStruArq := {}
AADD( aStruArq , { "LINHA"  		,"C"	, nTamArq	,0 	}  ) // linha
//
cArqTrab := CriaTrab(aStruArq,.T.)
IF SELECT( 'ARQTRB' ) > 0
	DBSELECTAREA('ARQTRB')
	DBCLOSEAREA()
ENDIF
dbUseArea(.T.,,cArqTrab,"ARQTRB",.T.,.F.)
//
cArqTrab += '.DBF'
cDest := 'C:\TOYOTA\' + cArqTrab
//
append from &cArquivo SDF
//
//
cIni      := '' // Linha Inicial do LayOut
cFinal  	:= '' // Linha final do LayOut
//
cNumPedido := '' // Essa variavel sera o nome do arquivo texto que serao gravados os arquivos dbfs para eventuais reimportacoes.
cNumCont	:= ''	
//
DBSELECTAREA('ARQTRB')
DbGotop()
//
ProcRegua( Reccount() )
//
if eof()
	Alert( ' O arquivo ' + cArquivo + ' Nao tem dados a serem importados. Por favor corrija.')
	return()
Endif
//
// o bloco abaixo fara a leitura do arquivo texto, lancando os itens e lendo as posicoes apenas apos a separacao de item por item, identificando possiveis inconsistencias ou alimentando
// a tabela que contera os pre pedidos do cliente
//
aItens := {}
lPrim  := .T.
aItensAux := {}
lErro  := .F.  // VARIAVEL QUE CONTROLARA O ERRO DE LANCAMENTO
lFirm := .F.

if  cCodCli == '000375' .and. Substr( linha,1,3  ) <>  'ITP'
	Alert( 'O arquivo '+ alltrim( cArquivo ) + ' Nao esta no padrao Toyota para importacao. Por favor, corrija. ')
	Return()
Endif
//
//
DBSELECTAREA('ARQTRB')
//
If (Substr( linha, 4, 3 ) == '012')
	lFirm := .T.
	If !MsgYesNo( 'O arquivo '+ alltrim( cArquivo ) + chr(13)+' Refere-se a Pedidos Tipo (FIRM ORDERS)'+ chr(13)+' Portanto efetivara o Pedido de Vendas, Continuar?. ')
		cArquivo := ''
		Return
	EndIf
Else
	If!MsgYesNo( 'O arquivo '+ alltrim( cArquivo ) + chr(13)+' Refere-se a Previsao Pedidos Mensal (FORECAST)'+ chr(13)+' ao fim exibira tela com os dados, Continuar?. ')
		cArquivo := ''
		Return  
	EndIf    
EndIf
While ! eof()
	//
	IncProc( 'Lendo Linha ' + Alltrim( Str( recno() ) ) )
	//
	cIdLinha 	:= Substr( linha,1,3  ) // id tipo do registro
	
	If cIdLinha == 'ITP'
		cIni      		:= LINHA
		cNumCont		:= Substr( cIni, 9, 5  )
		M->Z5_CNPJEMI	:= Substr( cIni, 26, 14  )
		cCodCli 		:= U_TrzCorr(  xFilial('SZ4'), '000375', 'CNPJ',  M->Z5_CNPJEMI  )
		//
		if !SA1->( DbSeek( xFilial( 'SA1') + cCodCli ) ) //  Reposicionando o codigo do cliente para o do CNPJ informado
			AAdd( aErros,  'ERRO: Cliente Codigo '  + cCodCli + ' Nao Encontrado.' )
		Endif
		
		DBSELECTAREA('ARQTRB')
		dbskip()
		loop
	ElseIf cIdLinha == 'FTP'
		cFinal      := LINHA
		AAdd( aItens , aItensAux )  // Agregando a array de itens por pedido, levando em conta que o pedido sera o mesmo
		dbskip()
		loop
	Elseif cIdLinha == 'PE1'
		//
		if lPrim
			lPrim := .F.
		Else
			AAdd( aItens , aItensAux )  // Agregando a array de itens por pedido, levando em conta que o pedido sera o mesmo
			aItensAux := {}
		Endif
	Elseif cIdLinha == 'PD1'
		//
		if lPrim
			lPrim := .F.
		Else
			AAdd( aItens , aItensAux )  // Agregando a array de itens por pedido, levando em conta que o pedido sera o mesmo
			aItensAux := {}
		Endif
		//
	Endif
	Aadd( aItensAux, linha )
	//
	//
	DBSELECTAREA('ARQTRB')
	DbSkip()
	//
Enddo
//
// O bloco abaixo tem como objetivo verificar os erros

If len(aItensAux ) > 0
	aItens := {}
	AAdd( aItens , aItensAux )  // Agregando a array de itens por pedido, levando em conta que o pedido sera o mesmo
Endif
//
lPrim := .T.
//
//
M->Z5_FILIAL	:= xFilial('SZ5')
M->Z5_CLIENTE	:= Substr( cCodCli,1,6 )
M->Z5_LOJA		:= Substr( cCodCli,7,2 )
M->Z5_NCONTRO	:= Substr( cIni, 9, 5 )
M->Z5_CNPJEMI	:= Substr( cIni, 26, 14  )
M->Z5_CODRECE	:= Substr( cIni, 95, 25  )
M->Z5_DATA		:= CTOD(  Substr( cIni , 18, 2  ) +'/' + Substr( cIni , 16, 2  ) +'/' + Substr( cIni , 14, 2  )   )
M->Z5_STATUS	:= '2' // 2 = PENDENTE
M->Z5_USUPROC	:= RetCodUsr()
M->Z5_NUMERO	:= space( 06 ) //GetSxeNum( 'SZ5' , 'Z5_NUMERO'  ) // implementar
M->Z5_DTPROC	:= dToc( dDataBase ) + Space(1)+time()
//
//
nREgs 			:= 0
aClient 		:= {}
cCliente		:= M->Z5_CLIENTE
cLoja			:= M->Z5_LOJA

AADD(aClient, { cCliente,;
cLoja } )

aItensZ6 	:= {} // Array que contem os itens que serao gravados na tabela SZ6
aItensPV	:= {}
aPedido 	:= {}
cPedCli		:= ''

For nn1 := 1 to len( aItens )
	For nk1 := 1 to len( aItens[ nn1 ]  )
		cIdLinha := Substr( aItens[ nn1, nk1  ], 1, 3 ) // identificador da linha
		//
		If cIdLinha == 'PE1'
			//
			cNumPCli	    := Substr( aItens[ nn1, nk1  ], 97, 12  )
			//
			// O bloco abaixo consiste se ja existe um pedido de compras do cliente
			DbSelectArea('SZ5')
			DbSetOrder(4)
			//
			If DbSeek( xFilial('SZ5' ) + cNumPCli )
				//
				if  M->Z5_DATA < SZ5->Z5_DATA
					lErro := .T.
					AAdd( aErros,  'Ja existe arquivo com a data de ' + dtoc( Z5_DATA ) + '  com numero interno ' + Z5_NUMERO   )
				Endif
				//
				nRecZ5 := Recno()
				lTemZ5 := .T.
				M->Z5_NUMERO := SZ5->Z5_NUMERO
				//
				DbSetOrder(1) // Somente troca  a chave mas continua no mesmo recno
				//
			Endif
			DbSelectArea('SZ5')
			DbSetOrder(1) // Somente troca  a chave mas continua no mesmo recno
			//
			//
			M->Z6_FILIAL	:= xFilial( 'SZ6' )
			M->Z6_NUMERO	:= M->Z5_NUMERO
			M->Z6_CLIENTE	:= M->Z5_CLIENTE
			M->Z6_LOJA		:= M->Z5_LOJA
			M->Z6_NCONTRO	:= M->Z5_NCONTRO
			M->Z6_DATA		:= M->Z5_DATA
			M->Z6_CNPJEMI	:= M->Z5_CNPJEMI
			M->Z6_PNUMBER	:= Substr( aItens[ nn1, nk1  ], 37, 30  )
			//
			// IMPLEMENTAR A CRITICA DO ERRO TAMBEM PARA O CODIGO DO PRODUTO
			cCodPrd := U_TrzCorr(  xFilial('SZ4'), '000375', 'CODPRO',  M->Z6_PNUMBER  )
			//
			if ! SB1->(DbSeek( xFilial('SB1' ) + cCodPrd ) )
				AAdd( aErros,  'Item ' + Alltrim( Str( nn1 )  )  + ' :' )
				AAdd( aErros, ' Part Number do Cliente '+Alltrim(M->Z6_PNUMBER) + ' com o codigo Midori ' + Alltrim(cCodPrd) +'  nao encontrado no cadastro de Produtos.'  )
			Endif
			//
			M->Z6_COD			:=  cCodPrd // implementar aqui o codigo do produto na base de dados midori atraves da tabela de correspondencias
			M->Z6_NUMPC			:=  cNumPCli
			M->Z6_LOCDEST		:=  Substr( aItens[ nn1, nk1  ], 109, 5  ) // Verificar na tabela de correspondencias
			M->Z6_UM			:=  Substr( aItens[ nn1, nk1  ], 125, 2  )
			M->Z6_DECIMAL		:=  Val(  Substr( aItens[ nn1, nk1  ], 127,1 )  )
			M->Z6_STATUS		:= '2'
			M->Z6_TFORNEC 		:=  Substr( aItens[ nn1, nk1  ], 128, 1  )
			M->Z6_DTRELE    	:=  cTod(  Substr( aItens[ nn1, nk1  ], 16, 2  ) + '/' + Substr( aItens[ nn1, nk1  ], 18, 2  ) + '/' + Substr( aItens[ nn1, nk1  ], 20, 2  )   )
			M->Z6_PROGANT 		:=  Substr( aItens[ nn1, nk1  ], 22, 9  )
			//
		Elseif cIdLinha == 'PE2'
			M->Z6_NFORIG		:=  StrZero( Val( Substr( aItens[ nn1, nk1  ], 10, 6  )  )  , 9 )
			M->Z6_SERIORI		:=  Substr( aItens[ nn1, nk1  ], 16, 4  )
		Elseif cIdLinha == 'TE1'
			//
			M->Z6_TEXTO1		:=	Substr( aItens[ nn1, nk1  ], 04, 40  )
			M->Z6_TEXTO2		:=	Substr( aItens[ nn1, nk1  ], 44, 40  )
			M->Z6_TEXTO3		:=	Substr( aItens[ nn1, nk1  ], 84, 40  )
			//
		Elseif cIdLinha == 'PE3' .AND. nREgs == 0
			//
			M->Z6_DTENT1	:=	 CTOD(  SUBSTR( aItens[ nn1, nk1  ]  , 8, 2  ) +'/' + SUBSTR( aItens[ nn1, nk1  ]  , 6, 2  ) +'/' + SUBSTR( aItens[ nn1, nk1  ]  , 4, 2  )   )
			M->Z6_QTDENT1	:=	Val( SUBSTR( aItens[ nn1, nk1  ]  , 12 , 9 - M->Z6_DECIMAL  ) + '.' +  SUBSTR( aItens[ nn1, nk1  ]  , 12  + ( 9 - M->Z6_DECIMAL ) ,  M->Z6_DECIMAL  ) )
		
			nREgs ++
		
		Elseif cIdLinha == 'PE3' .AND. nREgs == 1			
			
			M->Z6_DTENT2	:=	 CTOD(  SUBSTR( aItens[ nn1, nk1  ]  , 8, 2  ) +'/' + SUBSTR( aItens[ nn1, nk1  ]  , 6, 2  ) +'/' + SUBSTR( aItens[ nn1, nk1  ]  , 4, 2  )   )
			M->Z6_QTDENT2	:=	Val( SUBSTR( aItens[ nn1, nk1  ]  , 12 , 9 - M->Z6_DECIMAL  ) + '.' +  SUBSTR( aItens[ nn1, nk1  ]  , 12  + ( 9 - M->Z6_DECIMAL ) ,  M->Z6_DECIMAL  ) )
		
			nREgs ++
			
		Elseif cIdLinha == 'PE3' .AND. nREgs == 2	
			
			M->Z6_DTENT3	:=	 CTOD(  SUBSTR( aItens[ nn1, nk1  ]  , 8, 2  ) +'/' + SUBSTR( aItens[ nn1, nk1  ]  , 6, 2  ) +'/' + SUBSTR( aItens[ nn1, nk1  ]  , 4, 2  )   )
			M->Z6_QTDENT3	:=	Val( SUBSTR( aItens[ nn1, nk1  ]  , 12 , 9 - M->Z6_DECIMAL  ) + '.' +  SUBSTR( aItens[ nn1, nk1  ]  , 12  + ( 9 - M->Z6_DECIMAL ) ,  M->Z6_DECIMAL  ) )
			
			nREgs ++
			
		Elseif cIdLinha == 'PE3' .AND. nREgs == 3		
			
			M->Z6_DTENT4	:=	 CTOD(  SUBSTR( aItens[ nn1, nk1  ]  , 8, 2  ) +'/' + SUBSTR( aItens[ nn1, nk1  ]  , 6, 2  ) +'/' + SUBSTR( aItens[ nn1, nk1  ]  , 4, 2  )   )
			M->Z6_QTDENT4	:=	Val( SUBSTR( aItens[ nn1, nk1  ]  , 12 , 9 - M->Z6_DECIMAL  ) + '.' +  SUBSTR( aItens[ nn1, nk1  ]  , 12  + ( 9 - M->Z6_DECIMAL ) ,  M->Z6_DECIMAL  ) )
			
			nREgs ++
		
		Elseif cIdLinha == 'PE3' .AND. nREgs == 4		
			
			M->Z6_DTENT5	:=	 CTOD(  SUBSTR( aItens[ nn1, nk1  ]  , 8, 2  ) +'/' + SUBSTR( aItens[ nn1, nk1  ]  , 6, 2  ) +'/' + SUBSTR( aItens[ nn1, nk1  ]  , 4, 2  )   )
			M->Z6_QTDENT5	:=	Val( SUBSTR( aItens[ nn1, nk1  ]  , 12 , 9 - M->Z6_DECIMAL  ) + '.' +  SUBSTR( aItens[ nn1, nk1  ]  , 12  + ( 9 - M->Z6_DECIMAL ) ,  M->Z6_DECIMAL  ) )
			
			
			//
		Elseif cIdLinha == 'PE5'
			//
			M->Z6_IDPROG1	:= Substr( aItens[ nn1, nk1  ], 10	, 1  )
			M->Z6_IDPROG2	:= Substr( aItens[ nn1, nk1  ], 26	, 1  )
			M->Z6_IDPROG3	:= Substr( aItens[ nn1, nk1  ], 42	, 1  )
			M->Z6_IDPROG4	:= Substr( aItens[ nn1, nk1  ], 58	, 1  )
			M->Z6_IDPROG5	:= Substr( aItens[ nn1, nk1  ], 74	, 1  )
			M->Z6_IDPROG6	:= Substr( aItens[ nn1, nk1  ], 90	, 1  )
			M->Z6_IDPROG7	:= Substr( aItens[ nn1, nk1  ],106	, 1  )
			
		Elseif cIdLinha == 'PD1'	//pedidos firm, nao grava tabelas, gera pedido de venda direto.
			
			cCodPrC	:= Substr( aItens[ nn1, nk1  ], 4, 30  )
			cCodPrd := U_TrzCorr(  xFilial('SZ4'), '000375', 'CODPRO',  cCodPrC  )
			
			
			If ! SB1->(DbSeek( xFilial('SB1' ) + cCodPrd ) )
				AAdd( aErros,  'Item ' + Alltrim( Str( nn1 )  )  + ' :' )
				AAdd( aErros, ' Part Number do Cliente '+Alltrim(cCodPrC) + ' com o codigo Midori ' + Alltrim(cCodPrd) +'  Nao encontrado no cadastro de Produtos.'  )
			EndIf
			cResEmb	:= Substr( aItens[ nn1, nk1  ], 34, 1  )
			cLocDes	:= Substr( aItens[ nn1, nk1  ], 65, 4  )
				
			AADD(aItensPV, cCodPrd)
			
			
		Elseif cIdLinha == 'EP1'	//pedidos firm, nao grava tabelas, gera pedido de venda direto.
			
			cCodFab	:= Substr( aItens[ nn1, nk1  ], 4, 3  )
			cPrgAtu	:= Substr( aItens[ nn1, nk1  ], 7, 9  )
			dPrgAtu	:= Substr( aItens[ nn1, nk1  ], 16, 6  )
			dPrgAnt	:= Substr( aItens[ nn1, nk1  ], 31, 6  )
			cQtdAtu	:= Substr( aItens[ nn1, nk1  ], 37, 14  )
			
			AADD(aItensPV, cQtdAtu)
			
		Elseif cIdLinha == 'PD5'	//pedidos firm, nao grava tabelas, gera pedido de venda direto.
			
			cChmKan	:= Substr( aItens[ nn1, nk1  ], 18, 12  ) //C6_NCHKAN
			dDtaKan	:= Substr( aItens[ nn1, nk1  ]  , 34, 2  ) + Substr( aItens[ nn1, nk1  ]  , 32, 2  ) + Substr( aItens[ nn1, nk1  ]  , 30, 2  ) //C6_DTCHKAN//
			cTpCart	:= Substr( aItens[ nn1, nk1  ], 36, 1  )
			cNumCat	:= Substr( aItens[ nn1, nk1  ], 37, 3  )
			dDtaEnt	:= Substr( aItens[ nn1, nk1  ], 40, 6  )
			cQtdEmb	:= Substr( aItens[ nn1, nk1  ], 50, 9  )//C6_QTEMBCH
			cQtdEIt	:= Substr( aItens[ nn1, nk1  ], 59, 9  )//C6_QTIEMCH
			cCodEnt	:= Substr( aItens[ nn1, nk1  ], 101, 12  )
			
			AADD(aItensPV,cChmKan)
			AADD(aItensPV,dDtaKan)
			AADD(aItensPV,cQtdEmb)
			AADD(aItensPV,cQtdEIt)
			
			If lFirm
				DbSelectArea('SZ5')
				DbSetOrder(5)
				If DbSeek( xFilial('SZ5' ) + cNumCont )
					cPedCli := SZ5->Z5_NUMPC 
				EndIf
			EndIf			
			
			AADD(aItensPV, cPedCli)
			
		EndIf
	Next
	
	AADD(aPedido, aItensPV)
	
	If !lFirm
		
		// Gravar na tabela SZ5 e SZ6
		aItZ6Aux  := {}
		Aadd( aItZ6Aux, {'Z6_FILIAL'			, M->Z6_FILIAL			})
		Aadd( aItZ6Aux, {'Z6_NUMERO'			, M->Z6_NUMERO			})
		Aadd( aItZ6Aux, {'Z6_CLIENTE'			, M->Z6_CLIENTE			})
		Aadd( aItZ6Aux, {'Z6_LOJA'				, M->Z6_LOJA			})
		Aadd( aItZ6Aux, {'Z6_NCONTRO'			, M->Z6_NCONTRO			})
		Aadd( aItZ6Aux, {'Z6_DATA'				, M->Z6_DATA			})
		Aadd( aItZ6Aux, {'Z6_CNPJEMI'			, M->Z6_CNPJEMI			})
		Aadd( aItZ6Aux, {'Z6_PNUMBER'			, M->Z6_PNUMBER			})
		Aadd( aItZ6Aux, {'Z6_COD'				, M->Z6_COD				})
		Aadd( aItZ6Aux, {'Z6_NUMPC'				, M->Z6_NUMPC			})
		Aadd( aItZ6Aux, {'Z6_LOCDEST'			, M->Z6_LOCDEST			})
		Aadd( aItZ6Aux, {'Z6_UM'				, M->Z6_UM				})
		Aadd( aItZ6Aux, {'Z6_DECIMAL'			, M->Z6_DECIMAL			})
		Aadd( aItZ6Aux, {'Z6_NFORIG'			, M->Z6_NFORIG			})
		Aadd( aItZ6Aux, {'Z6_SERIORI'			, M->Z6_SERIORI			})
		Aadd( aItZ6Aux, {'Z6_STATUS'			, M->Z6_STATUS			})
		Aadd( aItZ6Aux, {'Z6_TEXTO1'			, M->Z6_TEXTO1			})
		Aadd( aItZ6Aux, {'Z6_TEXTO2'			, M->Z6_TEXTO2			})
		Aadd( aItZ6Aux, {'Z6_TEXTO3'			, M->Z6_TEXTO3			})
		If !Empty(M->Z6_DTENT1)
		Aadd( aItZ6Aux, {'Z6_DTENT1'			, M->Z6_DTENT1			})
		EndIf
		If !Empty(M->Z6_QTDENT1)
		Aadd( aItZ6Aux, {'Z6_QTDENT1'			, M->Z6_QTDENT1			})
		EndIf
		If !Empty(M->Z6_DTENT2)
		Aadd( aItZ6Aux, {'Z6_DTENT2'			, M->Z6_DTENT2			})
		EndIf
		If !Empty(M->Z6_QTDENT2)
		Aadd( aItZ6Aux, {'Z6_QTDENT2'			, M->Z6_QTDENT2			})
		EndIf
		If !Empty(M->Z6_DTENT3)
		Aadd( aItZ6Aux, {'Z6_DTENT3'			, M->Z6_DTENT3			})
		EndIf
		If !Empty(M->Z6_QTDENT3)
		Aadd( aItZ6Aux, {'Z6_QTDENT3'			, M->Z6_QTDENT3			})
		EndIf
		If !Empty(M->Z6_DTENT4)
		Aadd( aItZ6Aux, {'Z6_DTENT4'			, M->Z6_DTENT4			})
		EndIf
		If !Empty(M->Z6_QTDENT4)
		Aadd( aItZ6Aux, {'Z6_QTDENT4'			, M->Z6_QTDENT4			})
		EndIf
		If !Empty(M->Z6_DTENT5)
		Aadd( aItZ6Aux, {'Z6_DTENT5'			, M->Z6_DTENT5			})
		EndIf
		If !Empty(M->Z6_QTDENT5)
		Aadd( aItZ6Aux, {'Z6_QTDENT5'			, M->Z6_QTDENT5			})
		EndIf
		/*If cIdLinha == 'PE5'
			Aadd( aItZ6Aux, {'Z6_IDPROG1'			, M->Z6_IDPROG1			})
			Aadd( aItZ6Aux, {'Z6_IDPROG2'			, M->Z6_IDPROG2			})
			Aadd( aItZ6Aux, {'Z6_IDPROG3'			, M->Z6_IDPROG3			})
			Aadd( aItZ6Aux, {'Z6_IDPROG4'			, M->Z6_IDPROG4			})
			Aadd( aItZ6Aux, {'Z6_IDPROG5'			, M->Z6_IDPROG5			})
			Aadd( aItZ6Aux, {'Z6_IDPROG6'			, M->Z6_IDPROG6			})
			Aadd( aItZ6Aux, {'Z6_IDPROG7'			, M->Z6_IDPROG7			})
		EndIf*/
		Aadd( aItZ6Aux, {'Z6_TFORNEC' 			, M->Z6_TFORNEC  		})
		Aadd( aItZ6Aux, {'Z6_DTRELE' 			, M->Z6_DTRELE     		})
		Aadd( aItZ6Aux, {'Z6_PROGANT'			, M->Z6_PROGANT 		})
		//
		AAdd( aItensZ6, aItZ6Aux )  //  Adicionando o item a Array que alimentara a tabela SZ6
		//
		//Endif
		//
	Else//Next
		U_GerPVT(aClient,aPedido)
		MsgAlert( 'O arquivo '+ alltrim( cArquivo ) + ' foi importado e gerado o pedido de vendas ')
		Return()
	EndIf
	//
	// O bloco abaixo fara a validacao dos dados imputados pelo arquivo texto para cada item. E nesse momento que os itens de erro serao alimentados, ou a array definitiva sera lancada para depois
	lNovo := .T.
	//
	if lErro
		exit
	Endif
	//
Next
//
// O bloco abaixo tem como objetivo validar os campos a serem gravados pela Tabela SZ5
aCab := {}
//
AAdd( aCab, {'Z5_FILIAL'		, M->Z5_FILIAL			} )
AAdd( aCab, {'Z5_CLIENTE'		, M->Z5_CLIENTE		} )
AAdd( aCab, {'Z5_LOJA'			, M->Z5_LOJA			} )
AAdd( aCab, {'Z5_NCONTRO'		, M->Z5_NCONTRO	} )
AAdd( aCab, {'Z5_CODRECE'		, M->Z5_CODRECE	} )
AAdd( aCab, {'Z5_DATA'			, M->Z5_DATA			} )
AAdd( aCab, {'Z5_STATUS'		, M->Z5_STATUS		} )
AAdd( aCab, {'Z5_USUPROC'		, M->Z5_USUPROC	} )
AAdd( aCab, {'Z5_NUMPC'			, cNumPCli		} )
AAdd( aCab, {'Z5_DTPROC'		, M->Z5_DTPROC		} )
AAdd( aCab, {'Z5_CNPJEMI'		, M->Z5_CNPJEMI		} )
//
//
// Finalizacao do processo , gravando as tabelas SZ5 e SZ6.
IF Len( aErros ) > 0
	u_MsgErro( aErros )
	Return()
Endif
//
//
// O bloco abaixo consiste se ja existe um pedido de compras do cliente
DbSelectArea('SZ5')
DbSetOrder(4)
//
lTemZ5 := .F.
//
If DbSeek( xFilial('SZ5' ) + cNumPCli )
	nRecZ5 := Recno()
	lTemZ5 := .T.
	M->Z5_NUMERO := Z5_NUMERO
	//
	DbSetOrder(1) // Somente troca  a chave mas continua no mesmo recno
	//
Endif
//
DbSetOrder(1) // Retorna ao indice por numero interno
//
DbSelectArea('SZ5')
if lTemZ5
	DbSeek( xFilial('SZ5') + M->Z5_NUMERO )
	Reclock('SZ5', .F. )
Else
	Reclock('SZ5', .T. )
	M->Z5_NUMERO	:=GetSxeNum( 'SZ5' , 'Z5_NUMERO'  ) // implementar
	ConfirmSx8()
Endif
//
For nn1 := 1 to len( aCab )
	//
	cCpoAlim := aCab[ nn1, 1  ]
	//
	Replace &cCpoAlim with aCab[ nn1, 2   ]
	//
Next
//
if ! lTemZ5
	Replace Z5_NUMERO	With  M->Z5_NUMERO
Endif
//
MsUnlock()
//
//
// Exclui todos os itens pra lancar novamente
DbSelectArea('SZ6')
DbSetOrder( 1 )
//
While DbSeek( xFilial('SZ6') + SZ5->Z5_NUMERO )
	Reclock('SZ6',.f.)
	DbDelete()
	MsUnlock()
Enddo
//
// O bloco abaixo tem como objetivo alimentar as tabelas Z5 e Z6 quanto as programacoes de entrega.
For nn1 := 1 to len( aItensZ6 )
	//
	DbSelectArea('SZ6')
	//
	Reclock('SZ6', .T. )
	//
	For kk1 := 1 to len( aItensZ6[ nn1 ]  )
		cCpoAlim := aItensZ6[ nn1, kk1, 1  ]
		//
		Replace &cCpoAlim with aItensZ6[ nn1, kk1, 2   ]
		//
	Next
	//
	Replace Z6_NUMERO with SZ5->Z5_NUMERO
	//
	MsUnlock()
	//
Next
//
//
MsgAlert('Arquivo ' + cArquivo +chr(13)+' Importado Com Sucesso.'+chr(13)+'Sera aberta a tela de consulta, referente as informacoes importadas.' )
//
DBSELECTAREA('ARQTRB')
DBCLOSEAREA()
fErase( cArqTrab )
//
SZ5->( DbSeek( xFilial('SZ5') + M->Z5_NUMERO )  )
u_ConsZ5( sz5->( REcno() ) )
//
Return()
//--------------------------------------------------------------
//    A funcao abaixo tem como objetivo buscar as correspondencias a partir da necessidade do usuario
User Function TrzCorr(  cFil, cCli, cCod, cChv  )
//
Local cTabAtu := Alias()
//
DbSelectArea( 'SZ4' )
DbSetOrder(1)
//
If DbSeek( cFil + cCli + Padr( cCod,20 ) + Alltrim( cChv )  )
	cFunc1 := alltrim( SZ4->Z4_ITEMMID )
	cFuncREt := &cFunc1
	Return( cFuncREt )
	//
Else
	AAdd( aErros,  'ERRO : Chave de Correspondencia nao encontrado.' + cChv  )
	Return('')
Endif
//
Return('')
//---------------------------------
Static Function FechaMsg()
Close( oDlgErro )
Return()

/*---------------------------------------------------------
Funcao: GerPVT()|Autor: Willer Trindade| Data: 30/11/2014
-----------------------------------------------------------
Descr.: Inclusao Pedido Venda Automatico Toyota
---------------------------------------------------------*/
User Function GerPVT(aClient,aPedido)

Local cItemC6			:= "00"
Local cNum				:= GetSxeNum( 'SC5' , 'C5_NUM'  )
Local nZ,nW,nX
//Private aClient 		:= {}
//Private aPedido 		:= {}
Private aSC5   			:= {}
Private aSC6   			:= {}
Private cArqLog  		:= "\logimp\"	//Log de erro de rotina autom?ica
Private cFileLog 		:= "log.txt" 			//Controle de Log

For nW:= 1 To Len(aClient)
	
	AAdd(aSC5,{"C5_NUM"   	,cNum			                				,Nil})
	AAdd(aSC5,{"C5_TIPO"   	,'N'			                				,Nil})
	AAdd(aSC5,{"C5_CLIENTE"	,Alltrim(aClient[nW][1])			 			,Nil})
	AAdd(aSC5,{"C5_LOJACLI"	,Alltrim(aClient[nW][2])		       			,Nil})
	AAdd(aSC5,{"C5_CONDPAG"	,'009'	                        				,Nil})
	AAdd(aSC5,{"C5_TIPOCLI"	,'R'	                        				,Nil})
   //	AAdd(aSC5,{"C5_TIPOCLI"	,'R'	                        				,Nil})
	
	For nZ := 1 to Len( aSC5 )
		If ValType(aSC5[nZ,2]) == "C"
			aSC5[nZ,2] := PadR(Alltrim(aSC5[nZ,2]),TamSX3(aSC5[nZ,1])[1])
		EndIf
	Next nZ
	
Next nW

For nX:= 1 To Len(aPedido)
	
	cItemC6 := Soma1(cItemC6)
	 
	nDia:= Substr(aPedido[nX][4],1,2) 
	nMes:= Substr(aPedido[nX][4],3,2)
	nAno:= Substr(aPedido[nX][4],5,2)
	
	dData 	:= CtoD(nDia+'/'+nMes+'/'+nAno)
	
	aLinha := {}
	AAdd(aLinha,{"C6_ITEM"		,Alltrim(cItemC6)					,Nil})
	AAdd(aLinha,{"C6_PRODUTO"	,Alltrim(aPedido[nX][1])			,Nil})
	AAdd(aLinha,{"C6_QTDVEN"	,Val(aPedido[nX][2])	 			,Nil})
	AAdd(aLinha,{"C6_PRCVEN"	,1									,Nil})
	AAdd(aLinha,{"C6_TES"		,'502'								,Nil})
	AAdd(aLinha,{"C6_CCUSTO"	,'410205'							,Nil}) 	
	AAdd(aLinha,{"C6_NCHKAN"	,Alltrim(aPedido[nX][3])			,Nil})
	AAdd(aLinha,{"C6_DTCHKAN"	,dData								,Nil})
	AAdd(aLinha,{"C6_QTEMBCH"	,Val(aPedido[nX][5])				,Nil}) 
	AAdd(aLinha,{"C6_QTIEMCH"	,Val(aPedido[nX][6])				,Nil})
	AAdd(aLinha,{"C6_PEDCLI"	,Alltrim(aPedido[nX][7])			,Nil})	
	//Para evitar problemas de truncamento
	For nZ := 1 to Len( aLinha )
		If ValType(aLinha[nZ,2]) == "C"
			aLinha[nZ,2] := PadR(Alltrim(aLinha[nZ,2]),TamSX3(aLinha[nZ,1])[1])
		EndIf
	Next nZ
	
	AAdd(aSC6,aLinha)
Next nX

//Inclusao do Pedido de Venda
lMsErroAuto := .F.
lErroImp    := .F.
dbSelectArea("SC5")

MsExecAuto({|x,y,z| MATA410(x,y,z)}, aSC5, aSC6, 3)

If lMsErroAuto
	MostraErro()
	Conout("ERRO na Geracao do Pedido de Venda...  - "+DtoC(Date())+" "+Time())
	cErro := MostraErro(cArqLog,cFileLog)
	RollBackSX8()
	
	
Else
	ConfirmSX8()
	Conout("Pedido de Venda Gravado com sucesso! "+ Alltrim(SC5->C5_NUM) +" - "+DtoC(Date())+" "+Time())
	IncProc( "Gravando Pedido de Venda : "+ Alltrim(SC5->C5_NUM))
EndIf
SC5->(DbCloseArea())
SC6->(DbCloseArea())

Return ()

//---------------------------------
/*
A funcao abaixo tem como objetivo mostrar os registros gerados
*/

User Function ConsZ5( nRecZ5 )

/*컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇 Declara豫o de cVariable dos componentes                                 굇
袂굼컴컴컴컴컴컴컴좔컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴*/
Local aAlterEnch := {}  //Vetor com nome dos campos que poderao ser editados
Local aCpoEnch   := {}// Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
Local aPos       := {014,002,75,388}  //Vetor com coordenadas para criacao da enchoice no formato <top>, <left>, <bottom>, <right>
Local cAliasE    := "SZ5"  //Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
Local caTela     := ""  // Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lColumn    := .F.  //Indica se a apresentacao dos campos sera em forma de coluna
Local lF3        := .F.  //Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria   := .T.  //Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lNoFolder  := .F.  //Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty  := .T.  //Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local nCntFor
Local nModelo    := 3  //Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local nOpcE      := 1  //Numero da linha do aRotina que definira o tipo de edicao (Inclusao, Alteracao, Exclucao, Visualizacao)
Local nRegE      := nRecZ5  //Numero do Registro a ser Editado/Visualizado (Em caso de Alteracao/Visualizacao)
Private ALTERA   := .F.
Private bCampo   := {|nCPO| Field(nCPO)}
Private DELETA   := .F.
Private INCLUI   := .F.
Private VISUAL   := .T.
Private aErros   :=  {}

/*컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇 Declara豫o de Variaveis Private dos Objetos                             굇
袂굼컴컴컴컴컴컴컴좔컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴*/
SetPrvt("DlgcProg","oBrwz6_1","oBrwz6_2")

/*컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇 Definicao do Dialog e todos os seus componentes.                        굇
袂굼컴컴컴컴컴컴컴좔컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴*/
SZ5->( DbGoTo( nRecZ5 ) )

DlgcProg   := MSDialog():New( 002,099,470,885,"Programacao de Entrega",,,.F.,,,,,,.T.,,,.T. )
DlgcProg:bInit := {||EnchoiceBar(DlgcProg,{|| FechaProc() },{|| FechaProc()},.F.,{{'AUTOM',{|| Imp_Prog()},'Imprimir Programacao'}})}
//
cAliasE := 'SZ5'
DbSelectArea( cAliasE )
DbGoTo( nRegE  )
RegToMemory('SZ5', .F. , .F.)
//
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAliasE)
while !Eof().and.(x3_arquivo==cAliasE)
	if X3USO(x3_usado).and.cNivel>=x3_nivel
		AADD(aCpoEnch,x3_campo)
		if X3_VISUAL # "V"
			AADD(aAlterEnch,x3_campo)
		endif
	endif
	&("M->"+Alltrim(x3_campo) ) := CriaVar(x3_campo)
	dbSkip()
end

for nCntFor := 1 TO FCount()
	M->&(EVAL(bCampo,nCntFor)) := FieldGet(nCntFor)
next
//
Enchoice( cAliasE,nRegE,nOpcE,{},/*cLetra*/,/*cTexto*/,aCpoEnch,aPos,aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,/*cTudoOk*/,,,,,/*caTela*/,,)
//
aCampos := {}
//
AADD(aCampos,{ "PNUMBER"  ,"C",30,0   } ) // Z6_PNUMBER
AADD(aCampos,{ "CODIGO"  	,"C",15,0 } ) // RETORNO DA CORRESPONDENCIA DO CAMPO Z6_PNUMBER
AADD(aCampos,{ "DESCRI"  		,"C",50,0 } ) //  POSICIONE DO Z6_COD
AADD(aCampos,{ "UM"  			,"C",03,0 } ) // Z6_UM
AADD(aCampos,{ "LOCAENT"	,"C",10,0 } ) // CORRESPONDENCIA DO CAMPO Z6_LOCDEST
//
if Select( "TRBZ61" ) > 0
	DbSelectARea("TRBZ61")
	DbCloseArea()
Endif
//
cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRBZ61",.T.,.F.)
IndRegua("TRBZ61",cArqTrab,"CODIGO" , , ,"Selecionando Registros..." )  //"Selecionando Registros..."
//
//
aCampos := {}
//
AADD(aCampos,{ "CODIGO  " 				,"C",15,0 } ) //
AADD(aCampos,{ "PROGANT" 				,"C",09,0 } ) //
AADD(aCampos,{ "DTENT1"  				,"D",08,0 } ) //
AADD(aCampos,{ "QTENT1"  				,"N",14,2 } ) //
AADD(aCampos,{ "IDPROG1"				,"C",03,0 } ) //
AADD(aCampos,{ "DTENT2"  				,"D",08,0 } ) //
AADD(aCampos,{ "QTENT2"  				,"N",14,2 } ) //
AADD(aCampos,{ "IDPROG2"				,"C",03,0 } ) //
AADD(aCampos,{ "DTENT3"  				,"D",08,0 } ) //
AADD(aCampos,{ "QTENT3"  				,"N",14,2 } ) //
AADD(aCampos,{ "IDPROG3"				,"C",03,0 } ) //
AADD(aCampos,{ "DTENT4"  				,"D",08,0 } ) //
AADD(aCampos,{ "QTENT4"  				,"N",14,2 } ) //
AADD(aCampos,{ "IDPROG4"				,"C",03,0 } ) //
AADD(aCampos,{ "DTENT5"  				,"D",08,0 } ) //
AADD(aCampos,{ "QTENT5"  				,"N",14,2 } ) //
AADD(aCampos,{ "IDPROG5"				,"C",03,0 } ) //
AADD(aCampos,{ "DTENT6"  				,"D",08,0 } ) //
AADD(aCampos,{ "QTENT6"  				,"N",14,2 } ) //
AADD(aCampos,{ "IDPROG6"				,"C",03,0 } ) //
AADD(aCampos,{ "DTENT7"  				,"D",08,0 } ) //
AADD(aCampos,{ "QTENT7"  				,"N",14,2 } ) //
AADD(aCampos,{ "IDPROG7"				,"C",03,0 } ) //
//
//
if Select( "TRBZ62" ) > 0
	DbSelectARea("TRBZ62")
	DbCloseArea()
Endif
//
cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRBZ62",.T.,.F.)
IndRegua("TRBZ62",cArqTrab,"CODIGO + DTOS( DTENT1 ) " , , ,"Selecionando Registros..." )  //"Selecionando Registros..."
//
//
DbSelectArea('SZ6')
DbSetORder(1)
//
DbGoTop()
DbSeek( xFilial('SZ6') + SZ5->Z5_NUMERO )
While ! eof() .and. z6_filial == xFilial('SZ6') .and. Z6_NUMERO == SZ5->Z5_NUMERO
	//
	cLocal := U_TrzCorr(  xFilial('SZ4'), SZ6->Z6_CLIENTE, 'UNIDADE',  upper( SZ6->Z6_LOCDEST ) )
	cDesc :=  Posicione('SB1',1, xFilial('SB1') + SZ6->Z6_COD, 'B1_DESC' )
	//
	//  O bloco abaixo tem como objetivo alimentar as tabelas sz6_1 e sz6_2, para apresentacao das informacoes
	//
	DbSelectArea('TRBZ61')
	if !dbseek( sz6->z6_cod )
		Reclock('TRBZ61', .t. )
		Replace PNUMBER		WITH SZ6->Z6_PNUMBER
		Replace CODIGO 		WITH SZ6->Z6_COD
		Replace DESCRI 		WITH cDesc
		Replace UM	 	   	WITH SZ6->Z6_UM
		Replace LOCAENT 	WITH cLocal
		MsUnlock()
	Endif
	//
	// O proximo bloco fara a gravacao da tabela auxiliar de itens somente com as datas de previsao de entrega
	//
	//
	DbSelectArea('TRBZ62')
	if !dbseek( sz6->z6_cod + dtos( sz6->z6_dtent1 )  )
		Reclock('TRBZ62', .t. )
		PROGANT		:= 	ALLTRIM(SZ6->Z6_PROGANT)
		CODIGO		:= 	SZ6->Z6_COD
		DTENT1		:= 	SZ6->Z6_DTENT1
		QTENT1		:=  	SZ6->Z6_QTDENT1
		IDPROG1		:=  	IIF( SZ6->Z6_IDPROG1 == '1','FIR','PREV' )
		DTENT2		:=		SZ6->Z6_DTENT2
		QTENT2		:=  	SZ6->Z6_QTDENT2
		IDPROG2		:=		IIF( SZ6->Z6_IDPROG2 == '1','FIR','PREV' )
		DTENT3		:=		SZ6->Z6_DTENT3
		QTENT3		:=  	SZ6->Z6_QTDENT3
		IDPROG3		:=		IIF( SZ6->Z6_IDPROG3 == '1','FIR','PREV' )
		DTENT4		:=		SZ6->Z6_DTENT4
		QTENT4		:=  	SZ6->Z6_QTDENT4
		IDPROG4		:=		IIF( SZ6->Z6_IDPROG4 == '1','FIR','PREV' )
		DTENT5		:=		SZ6->Z6_DTENT5
		QTENT5		:=  	SZ6->Z6_QTDENT5
		IDPROG5		:=		IIF( SZ6->Z6_IDPROG5 == '1','FIR','PREV' )
		DTENT6		:=		SZ6->Z6_DTENT6
		QTENT6		:=  	SZ6->Z6_QTDENT6
		IDPROG6		:=		IIF( SZ6->Z6_IDPROG6 == '1','FIR','PREV' )
		DTENT7		:=		SZ6->Z6_DTENT7
		QTENT7		:=  	SZ6->Z6_QTDENT7
		IDPROG7		:=		IIF( SZ6->Z6_IDPROG7 == '1','FIR','PREV' )
		MsUnlock()
	Endif
	//
	DbSelectArea('SZ6')
	DbSkip()
Enddo
//
//
//
DbSelectArea("TRBZ61")
DBGOTOP()
//
oBrwz6_1   := MsSelect():New( "TRBZ61","","",{	{"PNUMBER"	,"","Part Number",""},;
{"CODIGO"		,"","Codigo",""},;
{"DESCRI"			,"","Descricao",""},;
{"UM"				,"","UM",""},;
{"LOCAENT"		,"","Local Entrega",""} },.F.,,{080,002,160,388},,, DlgcProg )
oBrwz6_1:oBrowse:bChange := {|| mudalinha() }
//
DbSelectArea("TRBZ62")
oBrwz6_2   := MsSelect():New( "TRBZ62","","",{	{"CODIGO"   ,""							,"Produto"		  ,""} ,;
{"PROGANT",""							,"Prog Anterior",""} ,;
{"DTENT1"		,"@r 99/99/99"     	,"Entrega 1"		,""} ,;
{"QTENT1"	,"@E 999,999.99"	,"Quantidade 1"	,""} ,;
{"IDPROG1"	,"@!"					  	,"Tipo 1"				,""} ,;
{"DTENT2"		,"@r 99/99/99"     	,"Entrega 2"		,""} ,;
{"QTENT2"	,"@E 999,999.99"	,"Quantidade 2"	,""} ,;
{"IDPROG2"	,"@!"					  	,"Tipo 2"				,""} ,;
{"DTENT3"		,"@r 99/99/99"     	,"Entrega 3"		,""} ,;
{"QTENT3"	,"@E 999,999.99"	,"Quantidade 3"	,""} ,;
{"IDPROG3"	,"@!"					  	,"Tipo 3"				,""} ,;
{"DTENT4"		,"@r 99/99/99"     	,"Entrega 4"		,""} ,;
{"QTENT4"	,"@E 999,999.99"	,"Quantidade 4"	,""} ,;
{"IDPROG4"	,"@!"					  	,"Tipo 4"				,""} ,;
{"DTENT5"		,"@r 99/99/99"     	,"Entrega 5"		,""} ,;
{"QTENT4"	,"@E 999,999.99"	,"Quantidade 5"	,""} ,;
{"IDPROG5"	,"@!"					  	,"Tipo 5"				,""} ,;
{"DTENT6"		,"@r 99/99/99"     	,"Entrega 6"		,""} ,;
{"QTENT6"	,"@E 999,999.99"	,"Quantidade 6"	,""} ,;
{"IDPROG6"	,"@!"					  	,"Tipo 6"				,""} ,;
{"DTENT7"		,"@r 99/99/99"     	,"Entrega 7"		,""} ,;
{"QTENT7"	,"@E 999,999.99"	,"Quantidade 7"	,""} ,;
{"IDPROG7"	,"@!"					  	,"Tipo 7"				,""}  },.F.,,{162,002,230,388},,, DlgcProg )
//
DBGOTOP()
//

DlgcProg:Activate(,,,.T.)

Return
//--------------------------------
Static Function mudalinha()
//
DbSelectArea('TRBZ62' )
SET FILTER TO CODIGO == TRBZ61->CODIGO
DBGOTOP()
DbSelectArea('TRBZ61' )
oBrwz6_2:oBrowse:Refresh()
//
Return
//--------------------------------
Static Function FechaProc()
Close( DlgcProg )
Return()
//--------------------------------
Static Function Imp_Prog()
//
Private titulo  := "Programacao de Entrega "+ SZ5-> Z5_NUMERO
Private cString := "SZ5"
Private cDesc   := "Esta Rotina fara a Impressao da Programacao gerada pela importacao do arquivo TXT"
Private aOrd    := {}	//"Por Numero"###"Por Produto"###"Por Centro de Custo"###"Por Prazo de Entrega"
Private tamanho := "G"
//
Private aReturn  := {"Zebrado",3,"Administracao", 1, 2,1, "",1 }	//"Zebrado"###"Administracao"
Private nLastKey := 0
Private lItemNeg := .F.
Private WnRel    :='MDRLPRG2'
Private nomeprog :='RL_PRG'
//
wnrel:=SetPrint(cString,wnrel,"",@titulo,cDesc,"","",.F.,aOrd,.F.,Tamanho)
//
If nLastKey == 27
	Return()
Endif
//
SetDefault(aReturn,cString)
//
//
RptStatus({|lEnd| Imp_detprg() },titulo)
//
Return()
//---------------------------------------------------------------------------------
Static Function Imp_detprg()
//
Local nn1,kk1,zz1
cbtxt   := SPACE(10)
cbcont  := 0
m_pag   := 1
nTipo   := 15
Li 		:= 60
//
SA1->( DbSeek( xFilial('SA1') +  sz5->z5_cliente + sz5->z5_loja )  )
//
if type('cArquivo') == 'U'
	cArquivo := ''
Endif
//
Cabec1 	:='CLIENTE: ' + SA1->A1_COD + '-'+SA1->A1_LOJA + '   ' + Transform( SA1->A1_CGC,'@r 99.999.999/9999-99') +alltrim( SA1->A1_NOME )  + ;
iif( !empty( cArquivo ),'   ARQUIVO: ' + cArquivo, ''  ) + '  DATA: ' + dToc( SZ5->Z5_DATA )   + '   NUM PC CLIENTE: ' + SZ5->Z5_NUMPC +;
'   DT PROTHEUS: ' + Substr(  SZ5->Z5_DTPROC, 7,2 ) +'/' + Substr(  SZ5->Z5_DTPROC, 5,2 ) + '/' + Substr(  SZ5->Z5_DTPROC, 1,4 ) + '   ' + Substr(  SZ5->Z5_DTPROC, 9 )
//
Cabec2 	:=''
//
DbSelectArea('TRBZ61')
DbGoTop()
While !eof()
	//
	// O bloco abaixo imprime os dados dos produto importado com suas caracteristicas tecnicas e depois com suas programacoes de entrega
	ImpProd()
	//
	aCb := Cab1()
	//
	For nn1 := 1 to len(aCb )
		@ li,00 psay aCb[ nn1 ]
		Li++
	Next
	//
	//
	aIts := {}
	DbSelectArea('TRBZ62')
	set filter to
	SET FILTER TO CODIGO == TRBZ61->CODIGO
	DbGoTop()
	//
	nrec := 1
	While !eof()
		//
		cLin1 := '|'+ StrZero( nrec,  4 )  +'|'+padr( progant , 20 ) + '|'
		For kk1 := 1 to 7
			//
			cDt  		:= 'Transform( dToc( DTENT' + Alltrim( Str(kk1 ) ) +'), "@r 99/99/9999" )
			cQtde 	:= 'Transform(  QTENT' + Alltrim( Str(kk1 ) ) +', "@e 99999.99" )
			cTpE  	:= 'IDPROG'+ Alltrim( Str(kk1 ) )
			//
			cLin1 += &cDt +'|' + &cQtde + '|' + &cTpE +' |'
			//Alert( cLin1 )
		Next
		//
		Aadd( aIts, cLin1 )
		//
		nrec ++
		DbSelectArea('TRBZ62')
		DbSkip()
	Enddo
	//
	For zz1 :=1  to len( aIts )
		//
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			//
			For nn1 := 1 to len(aCb )
				@ li,00 psay aCb[ nn1 ]
				Li++
			Next
			//
		EndIF
		//
		@ li,00 Psay aIts[ zz1 ]
		Li++
	Next
	//
	@ li,00 pSay '+----+--------------------+----------+--------+----+----------+--------+----+----------+--------+----+----------+--------+----+----------+--------+----+----------+--------+----+----------+--------+----+'
	Li += 2
	//
	DbSelectArea( 'TRBZ61' )
	DbSkip()
Enddo
//
/*
For nn1 := 1 to 3
@ li,00 psay aCb[ nn1 ]
Li++
Next
*/
//
//
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif
//
DbSelectArea('TRBZ61')
DbGoTop()
//
DbSelectArea('TRBZ62')
set filter to
SET FILTER TO CODIGO == TRBZ61->CODIGO
DbGoTop()
//
MS_FLUSH()
//
Return()
//--------------------------------
Static Function Cab1()
Local aCab1 := {}
//
AAdd(aCab1, '+----+--------------------+------------------------+------------------------+------------------------+------------------------+------------------------+------------------------+------------------------+' )
AAdd(aCab1, '|    |                    |       ENTREGA 1        |       ENTREGA 2        |       ENTREGA 3        |       ENTREGA 4        |       ENTREGA 5        |       ENTREGA 6        |       ENTREGA 7        |' )
AAdd(aCab1, '|    |  Num. Programacao  |----------+--------+----|----------+--------+----|----------+--------+----|----------+--------+----|----------+--------+----|----------+--------+----|----------+--------+----|' )
AAdd(aCab1, '|Seq.|     Anterior       |   DATA   |  QTDE. |TIPO|   DATA   |  QTDE. |TIPO|   DATA   |  QTDE. |TIPO|   DATA   |  QTDE. |TIPO|   DATA   |  QTDE. |TIPO|   DATA   |  QTDE. |TIPO|   DATA   |  QTDE. |TIPO|' )
AAdd(aCab1, '+----+--------------------+----------+--------+----+----------+--------+----+----------+--------+----+----------+--------+----+----------+--------+----+----------+--------+----+----------+--------+----+' )
//
//           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                     1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20
//           |0000|00000000000000000000|99/99/9999|99999.99|PREV|99/99/9999|99999.99|PREV|99/99/9999|99999.99|PREV|99/99/9999|99999.99|PREV|99/99/9999|99999.99|PREV|99/99/9999|99999.99|PREV|99/99/9999|99999.99|PREV|
//
Return( aCab1 )
//------------------
Static Function ImpProd()
//
IF li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	//
EndIF
//
@ li,00 psay 	'+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+'
li++
IF li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	//
EndIF
//
cPt1 := "Part Number: "+ TRBZ61->PNUMBER + '   Codigo Protheus: '+TRBZ61->Codigo + '   ' + Alltrim( Posicione('SB1',1,xFilial('SB1') +TRBZ61->Codigo, 'B1_DESC' ) ) + '     LOCAL ENTREGA: ' + TRBZ61->LOCAENT
//
cPt2 := '|' + cPt1 + space( 200- len(cPt1) ) + '|'
@ Li, 00 psay cPt2

Li++
IF li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	//
EndIF

Return()
//--------------------------------
Static Function Carr_Arqs( cDiretorio )
Local xa1
// cDiretorio := 'C:\FAURECIA\*.* '
cDiretorio += '\*.*'
aFiles1 := Directory( cDiretorio )
aNmFiles := {}
//
Aadd( aNmFiles, '' )
For xa1 :=1 to len( aFiles1 )
	Aadd( aNmFiles, aFiles1[ xa1 , 1 ] )
Next
//
Return( aNmFiles )
//-----------------------------------------------------------------
/*
A funcao abaixo tem como objetivo demonstrar o caso de erro
*/
User  Function MsgErro( aErroMens )

/*컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇 Declara豫o de Variaveis Private dos Objetos                             굇
袂굼컴컴컴컴컴컴컴좔컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴*/
SetPrvt("oFont1","oDlgErro","oSay1","oLBox1","oBtnOk","oBtnImp")
Private ErroMens := aErroMens
//
oFont1     := TFont():New( "Arial",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oDlgErro   := MSDialog():New( 089,270,583,755,"Erro de Processamento",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 004,008,{||"Atencao ! Ocorreu(ram) erro(s) no processamento do arquivo " + cArquivo },oDlgErro,,oFont1,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,220,020)
oLBox1     := TListBox():New( 028,004,, aErroMens ,232,188,,oDlgErro,,CLR_BLACK,CLR_WHITE,.T.,,,,"",,,,,,, )
oBtnOk     := SButton():New( 223,209,1,{|| FechaMsg()} ,oDlgErro,,"", )
oBtnImp    := SButton():New( 224,164,6,{|| Imp_Erro()  } ,oDlgErro,,"", )
//
oDlgErro:Activate(,,,.T.)
//
Return
//---------------------------------------------------------------------
Static Function Imp_Erro()
//
Private titulo  := "LOG DE PROCESSAMENTO DE ARQUIVO TEXTO"
Private cString := "SZ5"
Private cDesc   := "Esta Rotina fara a impressao das mensagens de erro no processamento do arquivo Texto"
Private aOrd    := {}	//"Por Numero"###"Por Produto"###"Por Centro de Custo"###"Por Prazo de Entrega"
Private tamanho := "P"
//
Private aReturn  := {"Zebrado",3,"Administracao", 1, 2,1, "",1 }	//"Zebrado"###"Administracao"
Private nLastKey := 0
Private lItemNeg := .F.
Private WnRel    :='MDRLERR2'
Private nomeprog :='RL_ERR'
//
wnrel:=SetPrint(cString,wnrel,"",@titulo,cDesc,"","",.F.,aOrd,.F.,Tamanho)
//
If nLastKey == 27
	Return()
Endif
//
SetDefault(aReturn,cString)
//
//
RptStatus({|lEnd| Imp_deterr() },titulo)
//
Return()
//---------------------------------------------------------------------------------
Static Function Imp_deterr
//
Local nn1
cbtxt   := SPACE(10)
cbcont  := 0
m_pag   := 1
nTipo   := 15
Li 		:= 60
//
Cabec1 	:='Data do Processamento : ' + dToc( dDataBase)
Cabec2 	:='Erros no Processamento do Arquivo: ' + cArquivo
//
For nn1 := 1 to len( ErroMens )
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		//
		//
	EndIf
	//
	@ Li, 00 psay ErroMens[ nn1 ]
	Li ++
	//
Next
//
//
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif
//
MS_FLUSH()
//
Return()
//--------------------------------
