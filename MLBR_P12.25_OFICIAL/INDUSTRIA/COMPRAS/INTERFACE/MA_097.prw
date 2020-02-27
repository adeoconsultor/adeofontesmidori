#INCLUDE "PROTHEUS.CH"
#INCLUDE "MATA097.CH"
#include "rwmake.ch"

// 	Programa:	MA_097
//	Autor:		Alexandre Dalpiaz
//	Data:		26/05/10
//	Uso:		Frigorifico Mercosul
//	Funcao:		Tela de browse para liberacao de pedidos de compra.
//              Mostra os pedidos bloqueados de todas as filiais

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MA_097()
//////////////////////

Local aCores    := {}
aAdd(aCores, { 'CR_STATUS== "02"', 'DISABLE' })
aAdd(aCores, { 'CR_STATUS== "01" .and. CR_NIVEL = "02" ', 'BR_AMARELO' })
aAdd(aCores, { 'CR_STATUS== "03"', 'ENABLE'  })
aAdd(aCores, { 'CR_STATUS== "04"', 'BR_PRETO'})
aAdd(aCores, { 'CR_STATUS== "05"', 'BR_CINZA'})

Private cFiltraSCR
PRIVATE aIndexSCR  := {}
PRIVATE bFilSCRBrw := {|| Nil}
PRIVATE cXFiltraSCR
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aRotina := {}
aAdd(aRotina, {"Pesquisar"				,"PesqBrw"		, 0 , 1})
aAdd(aRotina, {"Consulta Pedido"		,"A097Visual"	, 0 , 2})
aAdd(aRotina, {"Consulta Saldos"		,"A097Consulta"	, 0 , 2})
aAdd(aRotina, {"Liberar"				,"A097Libera"	, 0 , 4})
aAdd(aRotina, {"Estornar"				,"A097Estorna"	, 0 , 4})
aAdd(aRotina, {"Superior"				,"A097Superi"	, 0 , 4})
aAdd(aRotina, {"Transf. para Superior"	,"A097Transf"	, 0 , 4})
aAdd(aRotina, {"Conhecimento"			,"U_Documents"	, 0 , 4, 0, Nil }) //"Conhecimento"
aAdd(aRotina, {"Ausência Temporária"	,"A097Ausente"	, 0 , 3})
aAdd(aRotina, {"Legenda"				,"A097Legend"	, 0 , 2})

PRIVATE cCadastro := "Liberacao do PC"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o usuario possui direito de liberacao.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ca097User := RetCodUsr()
dbSelectArea("SAK")
dbSetOrder(2)

If !(ca097User $ GetMv('MA_POWER')) .and. !MsSeek(xFilial("SAK")+ca097User)
	Help(" ",1,"A097APROV")
	dbSelectArea("SCR")
	dbSetOrder(1)
Else
	
	If Pergunte("MTA097",.T.)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Controle de Aprovacao : CR_STATUS -->                ³
		//³ 01 - Bloqueado p/ sistema (aguardando outros niveis) ³
		//³ 02 - Aguardando Liberacao do usuario                 ³
		//³ 03 - Pedido Liberado pelo usuario                    ³
		//³ 04 - Pedido Bloqueado pelo usuario                   ³
		//³ 05 - Pedido Liberado por outro usuario               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicaliza a funcao FilBrowse para filtrar a mBrowse          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		/*dbSelectArea("SCR")
		DbOrderNickName('MASCR01')*/
		dbSelectArea("SCR")
		dbSetOrder(1)
		cFiltraSCR  := 'empty(CR_DATALIB) .and. '
		If !(ca097User $ GetMv('MA_POWER'))
			cFiltraSCR  := 'CR_USER=="' + ca097User + '" .and. '
		EndIf
		Do Case
			Case mv_par01 == 1
				cFiltraSCR += ' CR_STATUS=="02"'
			Case mv_par01 == 2
				cFiltraSCR += ' (CR_STATUS=="03".OR.CR_STATUS=="05")'
			Case mv_par01 == 3
				cFiltraSCR += ' CR_STATUS!="01"'
			OtherWise
				cFiltraSCR += ' (CR_STATUS=="01".OR.CR_STATUS=="04")'
		EndCase
		
		bFilSCRBrw 	:= {|| FilBrowse("SCR",@aIndexSCR,@cFiltraSCR) }
		Eval(bFilSCRBrw)
		mBrowse( 6, 1,22,75,"SCR",,,,,,aCores)		
		EndFilBrw("SCR",aIndexSCR)
		
	EndIf
	
EndIf

user function Documents()
dbSelectArea('SC7')
dbSetOrder(1)
Alert('Vai buscar o pedido '+SCR->CR_NUM+' da Filial '+SCR->CR_FILIAL)
if dbSeek(SCR->(CR_FILIAL+Substr(CR_NUM,1,6)))
	dbSelectArea('AC9')
	dbSetOrder(2)
	dbSeek(xFilial('AC9')+'SC7'+SCR->CR_FILIAL+SCR->CR_FILIAL+Substr(SCR->CR_NUM,1,6)+'0001')
		dbSelectArea('ACB')
		dbSetOrder(1)
		if dbSeek(xFilial('ACB')+AC9->AC9_CODOBJ)   
			Ft340Altera( "ACB", ACB->( Recno() ), 2 )  
		EndIf 	
endIf 	


return


Return Nil 


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function MERC012Leg()
////////////////////////////

aLegenda := {}
aAdd(aLegenda, {"BR_AZUL"   , "Bloqueado (Aguardando outros niveis)"   })
aAdd(aLegenda, {"DISABLE"   , "Aguardando Liberacao do usuario"        })
aAdd(aLegenda, {"BR_AMARELO", "Aguardando Liberacao do Nivel Superior" })
aAdd(aLegenda, {"ENABLE"    , "Pedido Liberado pelo usuario"           })
aAdd(aLegenda, {"BR_PRETO"  , "Pedido Bloqueado pelo usuario"          })
aAdd(aLegenda, {"BR_CINZA"  , "Pedido Liberado por outro usuario"      })

BrwLegenda(cCadastro,aLegenda)

Return(.T.)