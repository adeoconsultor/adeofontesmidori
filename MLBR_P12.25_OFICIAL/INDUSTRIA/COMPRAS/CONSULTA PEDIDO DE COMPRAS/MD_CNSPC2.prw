#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
/*
A funcao abaixo tem como objetivo apresentar as informacoes do pedido de compras para a consulta
*/
User Function DetpCompra( cPedCom )

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
//
Private cPedido     := cPedCom
Private cA2_END    	:= Space(1)
Private cA2_END    	:= Space(1)
Private cAprovado  	:= Space(1)
Private cBloqueado 	:= Space(1)
Private cC7_CGC    	:= Space(1)
Private cC7_CGC    	:= Space(1)
Private cC7_COMPRA 	:= Space(1)
Private cC7_COMPRA 	:= Space(1)
Private cC7_EMISSA 	:= Space(1)
Private cC7_EMISSA 	:= Space(1)
Private cC7_FORNEC 	:= Space(1)
Private cC7_FORNEC 	:= Space(1)
Private cC7_MUN    	:= Space(1)
Private cC7_MUN    	:= Space(1)
Private cC7_NUMERO 	:= Space(1)
Private cC7_STATUS 	:= Space(1)
Private cCondPgt   	:= Space(1)
Private cCondPgt   	:= Space(1)
Private cFrete     	:= Space(1)
Private cIE        	:= Space(1)
Private cIE        	:= Space(1)
//
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFontTitulo","oFontDados","oDlgDetPed","oc7_numero","oC7_EMISSAO","oC7_COMPRAD","oC7_STATUS")
SetPrvt("oAprovado","oC7_FORNECE","oC7_CGC","oC7_MUN","cC7_NUMERO","cC7_EMISSAO","cC7_COMPRAD","cC7_FORNECE")
SetPrvt("cC7_MUN","cA2_END","oA2_END","cCondPgt","oCondPgt","cFrete","oFrete","oIE","cIE","oBrwSc7","oBtnOk")
//
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
//
SC7->( DbSetOrder(1) )
if ! Sc7->( DbSeek( xFilial( 'SC7') + cPedido ) )
	Alert( 'Pedido nao encontrado.')
	Return()
Endif
//
oFontTitul 		:= TFont():New( "Arial",0,-19,,.F.,0,,400,.F.,.F.,,,,,, )
oFontDados 		:= TFont():New( "MS Sans Serif",0,-17,,.T.,0,,700,.F.,.T.,,,,,, )
oDlgDetPed 		:= MSDialog():New( 007,016,604,1025,"Midori Atlântica - Consulta de Pedidos de Compras",,,.T.,,,,,,.T.,,,.T. )
//
oc7_numero 		:= TSay():New( 010,008,{||"Número Pedido :"},oDlgDetPed,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,010)
oC7_EMISSA 		:= TSay():New( 010,124,{||"Emissão :"},oDlgDetPed,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,043,010)
oC7_COMPRA 		:= TSay():New( 010,216,{||"Solicitante :"},oDlgDetPed,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,054,010)
oC7_CMPR	 	:= TSay():New( 010,368,{||"Comprador :"},oDlgDetPed,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,054,010)
//
oC7_FORNEC 		:= TSay():New( 030,007,{||"Fornecedor :"},oDlgDetPed,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,010)
oC7_CGC    		:= TSay():New( 030,290,{||"CNPJ :"},oDlgDetPed,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,031,010)
oIE       		:= TSay():New( 030,413,{||"I.E. :"},oDlgDetPed,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,023,010)
oC7_MUN    		:= TSay():New( 050,330,{||"Cidade/UF :"},oDlgDetPed,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,010)
oFrete     		:= TSay():New( 069,250,{||"Frete :"},oDlgDetPed,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,031,010)
oC7_STATUS 		:= TSay():New( 069,395,{||"Situação :"},oDlgDetPed,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,010)

oDsCPgt   		:= TSay():New( 069,006,{||"Cond. Pagto. :"},oDlgDetPed,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,063,010)
oA2_END    		:= TSay():New( 050,007,{||"Endereço :"},oDlgDetPed,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,010)

//
SA2->(DbSetORder() )
SA2->( DbSeek( xFilial('SA2') +  SC7->C7_FORNECE + SC7->C7_LOJA  )  )
//
SE4->(dbSetOrder(1))
SE4->(dbSeek(xFilial("SE4")+SC7->C7_COND))
SC1->(dbSetOrder(1))
SC1->( DbSeek( xFilial('SC1') + SC7->C7_NUMSC ) )
//
cC7_NUMERO 		:= TSay():New( 010,083,{|| SC7->C7_NUM }																	,oDlgDetPed,,oFontDados,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,045,010)
cC7_EMISSA 		:= TSay():New( 010,167,{|| DTOC( SC7->C7_EMISSAO ) }											,oDlgDetPed,,oFontDados,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,052,010)
cC7_COMPRA 		:= TSay():New( 010,266,{|| IIF( SC1->( Found() ), Alltrim( SC1->C1_SOLICIT ),'' )  }			,oDlgDetPed,,oFontDados,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,166,010)
oC7_CMPR	 	:= TSay():New( 010,422,{|| Alltrim( UsrFullName( SC7->C7_USER ) ) }							,oDlgDetPed,,oFontDados,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,166,010)
//
cC7_FORNEC 		:= TSay():New( 030,068,{|| Substr(Alltrim( SA2->A2_NOME ),1,38)+"..." }													,oDlgDetPed,,oFontDados,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,294,010)
cC7_CGC    		:= TSay():New( 030,321,{|| TRansform(SA2->A2_CGC, '@r 99.999.999/9999-99' ) } 			,oDlgDetPed,,oFontDados,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,093,010)
cIE        		:= TSay():New( 029,437,{|| alltrim(SA2->A2_INSCR ) }													,oDlgDetPed,,oFontDados,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,093,010)
cC7_MUN    		:= TSay():New( 050,394,{|| ALLTRIM( SA2->A2_MUN ) + ' - ' + SA2->A2_EST }				,oDlgDetPed,,oFontDados,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,147,010)
cA2_END    		:= TSay():New( 050,058,{|| ALLTRIM( SA2->A2_END ) }												,oDlgDetPed,,oFontDados,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,270,010)
cCondPgt   		:= TSay():New( 069,069,{|| IIF(  SE4->( FOUND() ), ALLTRIM( SE4->E4_DESCRI ),'' )   }	,oDlgDetPed,,oFontDados,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,197,010)
cFrete     		:= TSay():New( 069,293,{|| IIF( SC7->C7_TPFRETE == 'C',"CIF", "FOB" ) }						,oDlgDetPed,,oFontDados,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,022,010)
//
If SC7->C7_CONAPRO != "B"
	oAprovado  	:= TSay():New( 069,438,{||"APROVADO"}																,oDlgDetPed,,oFontDados , .F. , .F. , .F.,.T.,CLR_HGREEN,CLR_WHITE,088,011)
	oBtnImp     := TButton():New( 328,424,"Imprimir Pedido",oDlgDetPed, {|| Imped() } ,088,020,,oFontTitulo,,.T.,,"",,,,.F. )
Else
	oBloqueado 	:= TSay():New( 069,438,{||"BLOQUEADO"}																,oDlgDetPed,,oFontDados , .F. , .F. , .F.,.T.,CLR_HRED    ,CLR_WHITE,088,011)
Endif
//
//
// Este bloco alimentara  os objetos com as informacoes necessarias a serem apresentadas ao usuario.
//
//
DbSelectArea("SC7")
Set Filter to C7_NUM == cPedido
DbGoTop()
oBrwSc7    := MsSelect():New( "SC7","","",{{"C7_ITEM","","Item",""},{"C7_PRODUTO","","Produto",""},{"C7_DESCRI","","Descricao",""},{"C7_UM","","UM",""},{"C7_QUANT","@E 999999","Qtde Pedida","@E 999,999.99"},{"C7_QUJE","","Qtde Entregue","@E 999,999.99"},{"C7_PRECO","","Prc Unitario","@E 99,999.99"},{"C7_TOTAL","","Vlr.Total","@E 999,999.99"},{"C7_OBS","","Observacoes",""}},.F.,,{093,007,256,496},,, oDlgDetPed )
//
If SC7->C7_CONAPRO != "B"
	oBtnImp     := TButton():New( 268,224,"Imprimir Pedido",oDlgDetPed, {|| Imped() } ,088,020,,oFontTitulo,,.T.,,"",,,,.F. )
Endif
//
oBtnOk     		:= TButton():New( 268,327,"OK",oDlgDetPed, {|| OkEntrada() } ,088,020,,oFontTitulo,,.T.,,"",,,,.F. )
//
//
oDlgDetPed:Activate(,,,.T.)

Return



//----------------------------------
Static Function ImPed()
//
//U_ATLR001('SC7', SC7->( Recno() ) ,  1 )  // desativado em 11/09/19
U_RELPCGRF(.F.,cPedido)                       // nova rotina impressao pedido
//
DbSelectArea("SC7")
Set Filter to C7_NUM == cPedido
DbGoTop()
//
Return()



//-----------------------------------------------------------
Static Function OkEntrada()
Close( oDlgDetPed )
Return()
//-----------------------------------------------------------
