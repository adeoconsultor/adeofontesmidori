#include "totvs.ch"
#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ 			บ Autor ณWiller Trindade       บ Data ณ 03/06/04  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ                       								      บฑฑ
ฑฑบ          ณ              										      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ             									         	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function mBrwCCY()



Local cAlias := "CCY"
Local   aCores     := {} , aIndices := {} , _cFiltro
Private cCadastro  := OemToAnsi("*Creditos de PIS*")
Private aRotina     := { }



AADD(aRotina, { "Pesquisar"		, "AxPesqui", 0, 1 })
AADD(aRotina, { "Visualizar"	, "AxVisual"  , 0, 2 })
AADD(aRotina, { "Incluir"    	, "AxInclui"   , 0, 3 })
AADD(aRotina, { "Alterar"    	, "AxAltera"  , 0, 4 })
AADD(aRotina, { "Excluir"   	, "AxDeleta" , 0, 5 })



Aadd(aCores,{"CCY_COD == '308'","ENABLE"})  		//Nao Atendido
Aadd(aCores,{"CCY_COD <> '308'","BR_PRETO" })			//Encerrado

dbSelectArea(cAlias)
dbSetOrder(1)
//_cFiltro := "ZY_STATUS $'13456789'" 

//bFilBrw	:=	{|| FilBrowse(cAlias,@aIndices,_cFiltro)}    //Filtra o MBrowse
//Eval( bFilBrw )
mBrowse( 6,1,22,75,cAlias,,,,,,aCores)

//mBrowse(6, 1, 22, 75, cAlias)

Return NIL
