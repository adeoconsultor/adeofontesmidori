#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³         ³ Autor ³ Willer                ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
#xcommand @ <nRow>, <nCol> COMBOBOX [ <oCbx> VAR ] <cVar> ;
[ <items: ITEMS, PROMPTS> <aItems> ] ;
[ SIZE <nWidth>, <nHeight> ] ;
[ <dlg:OF,WINDOW,DIALOG> <oWnd> ] ;
[ <help:HELPID, HELP ID> <nHelpId> ] ;
[ ON CHANGE <uChange> ] ;
[ VALID <uValid> ] ;
[ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
[ <pixel: PIXEL> ] ;
[ FONT <oFont> ] ;
[ <update: UPDATE> ] ;
[ MESSAGE <cMsg> ] ;
[ WHEN <uWhen> ] ;
[ <design: DESIGN> ] ;
[ BITMAPS <acBitmaps> ] ;
[ ON DRAWITEM <uBmpSelect> ] ;
=> ;
[ <oCbx> := ] TComboBox():New( <nRow>, <nCol>, bSETGET(<cVar>),;
<aItems>, <nWidth>, <nHeight>, <oWnd>, <nHelpId>,;
[{|Self|<uChange>}], <{uValid}>, <nClrText>, <nClrBack>,;
<.pixel.>, <oFont>, <cMsg>, <.update.>, <{uWhen}>,;
<.design.>, <acBitmaps>, [{|nItem|<uBmpSelect>}] )
//
User Function AVEMBTOY()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cNmArq     := Space( 200 )
Private lCbTodos   := .T.
cNmArq     := Alltrim(GetMv('MV_TOYENT') )
cNmArq     += PADR( IIF( substr( cNmArq  , len(cNmArq) -1,1) == '/','','/' ),200)

//
SetPrvt("oFont1","oDlgNfs","oSay1","oSay2","oCBox1","oLbx1","oNmArq","oBtn1","oBtn2","oCbTodos")

Private oOk := LoadBitmap( GetResources(), "LBOK")
Private oNo := LoadBitmap( GetResources(), "LBNO")
Private obrfics
Private cPedsCli
Private tchkAll 		:= .T.
Private cCliente 		:= ''
Private dDataDe  	:= dDataBase
Private dDataAte 	:= dDataBase
Private aErro 			:= {}
Private cArquivo    := ''
//

oFont1     := TFont():New( "Arial",0,-15,,.F.,0,,700,.F.,.F.,,,,,, )
oDlgNfs    := MSDialog():New( 121,325,660,1105,"Aviso de Embarque - EDI Toyota",,,.F.,,,,,,.T.,,oFont1,.T. )
//
oSay1      := TSay():New( 010,150,{||"Cliente: "},oDlgNfs,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayPEr    := TSay():New( 010,005,{||"Periodo: "},oDlgNfs,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 227,096,{||"Arquivo :"},oDlgNfs,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,038,008)
//
oDataDe    := TGet():New( 008,035 ,{|u| If(PCount()>0,dDataDe:=u,dDatade)},oDlgNfs,50,011,'',,CLR_HBLUE,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDataDe",,)
oDataAte   := TGet():New( 008,097 ,{|u| If(PCount()>0,dDataAte:=u,dDataAte)},oDlgNfs,50,011,'',,CLR_HBLUE,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDataAte",,)
//
aItems := { "","00037512 - TOYOTA TDB PFZ" }
@ 008,183  COMBOBOX oCBox1  VAR cCliente ITEMS aItems   SIZE 200,013  ON CHANGE MsAguarde( {||U_MudaItem()},'Carregando Informacoes...' )  OF oDlgNfs PIXEL
//
acFics := {}
Aadd( acFics,  { .F., ' ',' ',' ',' ',' ',' ',' ', ' ',' ',' ','  ','  ','' } )
//
@ 32,05  LISTBOX obrfics VAR cFics Fields HEADER "   ",'Nota Fiscal','Serie', ' Emissao ' ,'Valor NF ' , 'Unidade Entrega' ,'Pedido Cliente'  SIZE 378,190  ON DBLCLICK Chng_Lst() pixel // ON CHANGE CHNG() ON DBLCLICK Ad_PrLst()
obrfics:SetArray(acFics)
obrfics:bLine := { || { IIF( acFics[obrfics:nAt,1], ook, oNo ) , acFics[obrfics:nAt,2],acFics[obrfics:nAt,3],acFics[obrfics:nAt,4],acFics[obrfics:nAt,5] , acFics[obrfics:nAt,6] , acFics[obrfics:nAt,7] }  }
//
@ 227 , 05  CHECKBOX ochkAll VAR tchkAll PROMPT 'Todas as Notas' ON CHANGE clk_LST()  OF  oDlgNfs  SIZE 100,12  COLOR CLR_BLUE   PIXEL
//
oNmArq     := TGet():New( 225,132,{|u| If(PCount()>0,cNmArq:=u,cNmArq)},oDlgNfs,252,011,'',,CLR_HBLUE,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNmArq",,)
//
oBtn1      := TButton():New( 248,196,"Gerar Aquivo",oDlgNfs,{|| PRocessa( {|| GERFILE() } , 'Gerando Arquivo ' + Alltrim( cNmArq )   )  },056,012,,oFont1,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 248,274,"Retornar",oDlgNfs,{|| Fecha() },056,012,,oFont1,,.T.,,"",,,,.F. )
//
oDlgNfs:Activate(,,,.T.)

Return                         

//---------------------------------------------------------------------------
/*
A funcao abaixo tem como objetivo carregar a listbox com as notas fiscais de saida para o cliente escolhido.
*/
User Function MudaItem()

if empty(  cCliente)
	acFics := {}
	Aadd( acFics,  { .F., '','','','','','','','','','','','','' } )
Else
	//
	cQuery :=' Select R_E_C_N_O_ as REC from ' + RetSqlName('SF2') + " Where D_E_L_E_T_ = ' ' and F2_CLIENTE = '" + substr( cCliente, 1, 6 ) + "' And F2_LOJA ='" +  substr( cCliente, 7, 2 ) + "' And "
	cQuery +=" F2_FILIAL = '"+XFILIAL('SF2') +"' AND F2_EMISSAO >='"+ DTOS( dDataDe )  + "' And F2_EMISSAO <= '"+ DTOS( dDataAte )  + "' "
	cQuery +=" AND F2_TIPO = 'N' Order By F2_EMISSAO "
	//
	//
	if select('F2TRB') > 0
		DbSelectaRea('F2TRB')
		DbCloseArea()
	Endif
	//
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'F2TRB',.T.,.T.)
	//
	acFics := {}
	//
	F2TRB->(DbGoTop())
	While !F2TRB->(eof())
		
		DbSelectArea('SF2')
		SF2->(DbGoTo( F2TRB->REC ))
		//
		lTemPc := .T.
		//
		DbSelectArea('SC6')
		SC6->(DbSetOrder(4)) //C6_FILIAL+C6_NOTA+C6_SERIE
		SC6->(DbSeek(xFilial('SC6') + SF2->F2_DOC + SF2->F2_SERIE ))
		//
		cPedsCli := ''
		While !SC6->(eof()) .and. SC6->C6_NOTA == SF2->F2_DOC .AND. SC6->C6_SERIE == SF2->F2_SERIE
			//
			IF !EMPTY( SC6->C6_PEDCLI )
				nAt := At( cPedsCli, alltrim( SC6->C6_PEDCLI ) )
				if nAt == 0
					cPedsCli +=  Alltrim(SC6->C6_PEDCLI) +' / '
				Endif
			Endif
			//
			DbSelectArea('SC6')
			SC6->(DbSkip())
		Enddo
		//
		cPedsCli := IIF( ! empty( cPedsCli ), substr( cPedsCli , 1, len( cPedsCli ) -1 ), '')
		//
		DbSelectArea('SD2')
		SD2->(DbSetOrder( 3 )) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		SD2->( DbSeek( xFilial( 'SD2' ) + SF2->F2_DOC + SF2->F2_SERIE ) )
		While !SD2->(eof()) .and. SD2->D2_FILIAL == xFilial('SD2') .and. SD2->D2_DOC == SF2->F2_DOC .AND. SD2->D2_SERIE == SF2->F2_SERIE
			//
			// AOliveira verificar com o Willer           
			//
			DbSelectArea('SD2')
			SD2->(DbSkip())
		Enddo
		//
		Aadd( acFics,  { .T., SF2->F2_DOC ,SF2->F2_SERIE,DTOC(SF2->F2_EMISSAO),TRANSFORM(SF2->F2_VALBRUT,'@e 99,999,999.99') ,'', cPedsCli ,'','','','','','','' } )
		//
		DbSelectArea('F2TRB')
		F2TRB->(DbSkip())
	Enddo
	//
	IF LEN( acFics ) == 0
		Aadd( acFics,  { .F., '','','','','','','','','','','','','' } )
	ENDIF
	//
Endif

obrfics:SetArray(acFics)
obrfics:bLine := { || { IIF( acFics[obrfics:nAt,1], ook, oNo ) , acFics[obrfics:nAt,2],acFics[obrfics:nAt,3],acFics[obrfics:nAt,4],acFics[obrfics:nAt,5] , acFics[obrfics:nAt,6] , acFics[obrfics:nAt,7] }  }
obrfics:Refresh()
//

Return()

//---------------------------------------------------------------------------
Static Function Fecha()
Close( oDlgNfs )
Return()
//---------------------------------------------------------------------------

Static Function clk_LST()
//
Local nn1
Local lFlagChk  := tchkAll
//
/*
if !  lFlagChk
acFics[obrfics:nAt, 1 ]  := .t.
Else
acFics[obrfics:nAt,1 ]  := .f.
Endif
obrfics:REfresh()
*/
//
For nn1 := 1 to len( acFics )
	if lFlagChk
		acFics[nn1 , 1 ]  := .t.
	Else
		acFics[nn1 ,1 ]  := .f.
	Endif
Next
obrfics:REfresh()
//
Return()

//-------------------------------------------------------------
Static Function Chng_Lst()
Local lFlagChk  := acFics[obrfics:nAt, 1 ]
//
if !  lFlagChk
	acFics[obrfics:nAt, 1 ]  := .t.
Else
	acFics[obrfics:nAt,1 ]  := .f.
Endif
obrfics:REfresh()

Return()

//-------------------------------------------------------------
/*
A funcao abaixo tem como objetivo gerar o arquivo de aviso de embarque para as programacoes
*/
Static Function GERFILE()
Local nn1
//
cNmArq := Alltrim(cNmArq)
//
if LEn( acFics   ) == 1 .and. Empty( acFics[1,2] )
	Alert('Não há dados a serem processados.')
	Return()
Endif
//
if substr(cNmArq, len(cNmArq) , 1 ) == '\'
	Alert('Informe o nome do Arquivo a ser Gerado.')
	Return()
Endif
//
if ! MsgYesNo('Confirma o Processamento ? ' )
	Return()
Endif
//
//
cArquivo := cNmArq
cLin := ''
cTime := Time()
nREgs := 0

// Tipo ITP
//                                             
DbSelectArea("SA1")
SA1->( DbSetOrder( 1 ) )
SA1->( DbSeek( xFilial('SA1') + SF2->F2_CLIENTE + SF2->F2_LOJA    )  )
//
SF2->( DbSetOrder( 1 ) )


cLin += 'ITP00417'+; //ITP - POSICAO 1 A 3 // PROCESSO 4 A 6 //NUM VERSAO TRANS 7 A 8
PADR( SZ5->Z5_NCONTRO , 5 )+;//SPACE(05) +;//NUM CONTROLE TRANSM 9 A 13 *******IMPLEMENTAR
PADR( Substr( Dtos(dDataBase), 3 ) + substr(cTime,1,2 ) + substr(cTime,4,2 )+'00' , 12  ) + ; //IDENT GERACAO DOC 14 A 25
PADR( Alltrim( SM0->M0_CGC) , 14 ) +; //IDENT TRANSMISSOR POSICAO 26 A 39
PADR( Alltrim( SA1->A1_CGC)  , 14 )+; //IDENT RECEPTOR POSICAO 40 A 53
PADR( '70797' , 8 ) +;//COD INTERNO NO RECEPTOR - POS 54 A 61
PADR( '154900' , 8 ) + UPPER(SUBSTR(SM0->M0_NOMECOM,1,25))+;//space(33) +; //CODIGO INTERNO DO RECEPTOR  62 A 69 // NOME TRANSMSISSOR 70 A 94
PADR( 'TOYOTA DO BRASIL LTDA',25 ) +;//NOME DO RECEPTOR 95 119
SPACE( 09 ) + chr(13) + chr(10)//ESPACO 120 128
//
nREgs ++
//
//
ProcRegua( len( acFics )  )
For nn1 := 1 to len( acFics )
	if acFics[nn1,1]
		//
		DbSelectArea('SF2')
		SF2->(DbSetOrder(1)) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
		SF2->(DbSeek( xFilial( 'SF2') + PADR( Alltrim(acFics[nn1,2]), TamSx3("F2_DOC" )[1] ) + PADR( alltrim(acFics[nn1,3]), TamSx3("F2_SERIE" )[1] )   ))
		//
		nTotItens 	:= 0
		cCfo       	:= ''
		cTes        := ''
		cNumpCli 	:= ''
		//
		DbSelectArea('SD2')
		SD2->(DbSetOrder( 3 )) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		SD2->(DbSeek(  xFilial('SD2') + SF2->F2_DOC + SF2->F2_SERIE ))
		While !SD2->(eof()) .and. SD2->D2_FILIAL == xFilial('SD2') .and. SD2->D2_DOC == SF2->F2_DOC .AND. SD2->D2_SERIE == SF2->F2_SERIE
			//
			nTotItens ++
			cCfo       	:= SD2->D2_CF
			cTes      	:= SD2->D2_TES
			cTit		:= StrZero(Val(SF2->F2_SERIE),2) + Space(1)+Alltrim(SF2->F2_DOC )
			//
			DbSelectArea('SC6')
			SC6->(DbSetOrder( 1 ))  //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
			SC6->(DbSeek( xFilial( 'SC6' ) + Padr(Alltrim(SD2->D2_PEDIDO),TamSx3("C6_NUM" )[1]) + Padr(Alltrim(SD2->D2_ITEMPV),TamSx3("C6_ITEM" )[1]) + Padr(Alltrim(SD2->D2_COD),TamSx3("C6_PRODUTO" )[1])  ))
			//
			cNumpCli := ""
			if !empty( SC6->C6_PEDCLI  )
				//
				cNumpCli := SC6->C6_PEDCLI
				//
			Endif
			//
			
			//
			//
			If Empty( cNumpCli )
				//
				AAdd( aErro ,  'Nota Fiscal : ' + SF2->F2_DOC + '/' + SF2->F2_SERIE + ' Emissão : '+ Dtoc( SF2->F2_EMISSAO ) + '   Pedido de Vendas: '  + SC6->C6_NUM   )
				AAdd( aErro ,  'Erro Detectado:  Pedido de Compra do Cliente NAO Digitado no Pedido de Vendas.' )
				AAdd( aErro ,  'Entrar em contato com o Administrador do Sistema. '  )
				AAdd( aErro ,  '    '  )
				//
			Else
				DbSelectArea('SZ5')
				SZ5->( DbSetOrder( 4 ) ) //Z5_FILIAL+Z5_NUMPC
				If !SZ5->(DbSeek( xFilial('SZ5') + PADR( Alltrim(cNumpCli) ,TamSx3("Z5_NUMPC" )[1] )  ))
					//
					AAdd( aErro ,  'Nota Fiscal : ' + SF2->F2_DOC + '/' + SF2->F2_SERIE + ' Emissão : '+ Dtoc( SF2->F2_EMISSAO )   )
					AAdd( aErro ,  'Erro Detectado:  Pedido de Compra do Cliente não Encontrado: ' +  cNumpCli )
					AAdd( aErro ,  '    '  )
					//
				Else
					// Alimentando os detalhes dos itens
					//
					DbSelectArea( 'SF2' )
					
					DbSelectArea( 'SF4')
					SF4->(DbSetOrder(1)) //F4_FILIAL+F4_CODIGO
					SF4->( DbSeek( xFilial('SF4')  +  cTes ) )
					
					DbSelectArea( 'SE1')
					SE1->(DbsetOrder(1))
					SE1->(DbGotop())
					SE1->( DbSeek( xFilial('SE1') + cTit  ))
					//
					// AE1
					cLin += 'AE1'+StrZero( Val( SF2->F2_DOC ), 6)  			+ 	PADR( SF2->F2_SERIE,4) +;
					SUBSTR( DTOS( SF2->F2_EMISSAO ) , 3 ) 	+ 	STRZERO( nTotItens, 3) +;
					StrZero( SF2->F2_VALBRUT * 100 , 17 ) 			+	'2' + PADR( cCfo, 5  ) +;
					StrZero( SF2->F2_VALICM * 100 , 17 ) 			+	 Substr( Dtos( SE1->E1_VENCREA ), 3 )  +;
					'00' + StrZero( SF2->F2_VALIPI * 100 , 17 )     +;
					IIF( SA1->A1_COD + SA1->A1_LOJA == '00037512', PADR('J',3), Space(3) ) + SUBSTR( DTOS(dDatabase) , 3 ) + ; //*******IMPLEMENTAR data embarque
					space(4) + PADR( SF4->F4_TEXTO,15 ) + SUBSTR( DTOS( dDataBase  ) , 3 ) + substr(cTime,1,2 ) + substr(cTime,4,2 ) +  space(3) +Chr(13) + Chr(10)
					
					//
					nREgs ++
					//
					//
					// Chave da nota Fiscal Eletronica - A Ser Implementado
					//
					// IF !EMPTY( SF2->F2_CHVNFE )
					//   cLin += 'NF6' +  PADR( SF2->F2_CHVNFE , 44 ) +SPACE( 81) +Chr(13) + Chr(10)
					//   nREgs ++
					// Endif
					//
					// nREgs ++
					//
					
					cLin += 'NF2' +  StrZero( SF2->F2_DESPESA * 100 , 12 ) +; //despesas acessoarias
					StrZero( SF2->F2_FRETE * 100 , 12 ) +; //frete
					StrZero( SF2->F2_SEGURO * 100 , 12 ) +; //seguro
					StrZero( SF2->F2_DESCONT * 100 , 12 ) +; //desconto
					StrZero( SF2->F2_BASEICM * 100 , 12 ) +; //base icms
					StrZero( 0 , 12 ) + ;//desconto icms
					StrZero( 0 , 6 ) + ;
					StrZero( 0 , 6 ) + ;
					StrZero( 0 , 12 ) + ;
					StrZero( 0 , 12 ) + ;
					SPACE( 17 )  + Chr(13) + Chr(10)
					//
					nREgs ++
					//
					//
					//DbSelectArea('SD2')
					//SD2->(DbSetOrder( 3 ))
					//SD2->(DbSeek(  xFilial('SD2') + SF2->F2_DOC + SF2->F2_SERIE )
					
					//While !SD2->(eof()) .and. SD2->D2_FILIAL == xFilial('SD2') .and. SD2->D2_DOC == SF2->F2_DOC .AND. SD2->D2_SERIE == SF2->F2_SERIE
					//
					
					//
					DbSelectArea('SZ6')
					SZ6->(DbSetOrder( 1 ))
					SZ6->(DbSeek( xFilial('SZ6') + SZ5->Z5_NUMERO + SD2->D2_COD ))  // Posicionando no item do pedido de compras do cliente
					//
					DbSelectArea("SB1")
					SB1->( DbSetOrder( 1 ) )
					SB1->( DbSeek( xFilial('SB1') + SD2->D2_COD    )  )
					
					cLin += 'AE2' + PADR(SD2->D2_ITEM,3)  + PADR( SZ5->Z5_NUMPC,12 )  + PADR(SZ6->Z6_PNUMBER,30 )  + StrZero( SD2->D2_QUANT  * 100 , 9 ) + ;
					'PC'/*PADR(SD2->D2_UM,2)*/  + '00' + PADR(( SB1->B1_POSIPI) , 8 ) + StrZero( SD2->D2_IPI  * 100 ,4 ) + ;//*IMPLEMTAR NCM PRODUTO
					PADR( SD2->D2_PRCVEN  * 100 , 12 ) + STRZERO( 0 , 9 ) + SPACE( 13 ) + 'R' +;
					StrZero( 0 , 15 ) + space( 5 )  +Chr(13) + Chr(10)
					
					nREgs ++
					//
					cLin += 'AE4' + StrZero( SD2->D2_PICM  * 100 , 4 ) + StrZero( SD2->D2_BASEICM  * 100 , 17 ) +;
					StrZero( SD2->D2_VALICM  * 100 , 17 ) +StrZero( SD2->D2_VALIPI  * 100 , 17 ) +;
					SUBSTR( SD2->D2_CLASFIS, 1, 2 ) + SPACE( 30 ) + STRZERO(0,6) + SPACE( 18 ) + '1' +;
					STRZERO( SD2->D2_TOTAL  * 100 , 12 ) + SPACE( 1 )  +Chr(13) + Chr(10)
					nREgs ++
					
					DbSelectArea('SC6')
					SC6->(DbSetOrder( 1 )) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
					SC6->(DbSeek( xFilial( 'SC6' ) + SD2->D2_PEDIDO + SD2->D2_ITEMPV  ))
					
					cLin += 'AE9' + PADR( Alltrim(SC6->C6_NCHKAN), 12 ) + Substr( Dtos( SC6->C6_DTCHKAN ), 3 ) + StrZero( VAL(SC6->C6_QTEMBCH) , 9 ) + StrZero(Val( SC6->C6_QTIEMCH) * 100 ,9 ) + ; //implementar data
					space( 89 )  +Chr(13) + Chr(10)
					nREgs ++
					
					cLin += 'AE7' + strzero( 0,12) + strzero( VAL(SD2->D2_CF) , 5 ) + STRZERO( 0 , 48 ) + ;
					SPACE( 05 ) + strzero( 0 , 12 ) + space( 43 )  +Chr(13) + Chr(10)
					nREgs ++
					
					cLin += 'AE3' + 	StrZero( 0 , 28 )	+ PADR( IIF( SA1->A1_COD + SA1->A1_LOJA == '00037512', '9DG', ' ' ),14 )  + SPACE( 83 ) +Chr(13) + Chr(10)
					nREgs ++
					
					//
					//	DbSelectArea('SD2')
					//	SD2->(DbSkip())
					//Enddo
					//
					//
				Endif
			Endif
			//
			//
			DbSelectArea('SD2')
			SD2->(DbSkip())
		Enddo
	Endif
Next

//
nREgs ++  // deve ser incrementado incluindo o ftp
cLin += 'FTP' +PADR( SZ5->Z5_NCONTRO , 5 ) + Strzero( nREgs, 5  ) + StrZero( 0 , 17 ) + space(1) + space( 97 )  +Chr(13) + Chr(10)
//
nREgs := 0  // Zera o contador
//
//
if len(aErro) > 0
	U_MsgErro( aErro )
	Return()
Endif
//
MemoWrite( cArquivo, cLin )
//
MsgAlert( 'Arquivo ' + Alltrim( cArquivo ) + '  Gerado com Sucesso !!!' )
Return()
//------------------------------------------------------------