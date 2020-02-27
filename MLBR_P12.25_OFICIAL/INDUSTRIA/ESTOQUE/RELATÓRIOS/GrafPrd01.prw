#INCLUDE "PROTHEUS.CH"    
#INCLUDE "MSGRAPHI.CH"           
#INCLUDE "RWMAKE.CH"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GRAFPRD01 ³Autor ³ ANESIO - TAGGS        ³ Data ³ 27-07-10  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ MIDORI           ³Contato ³  TAGGS CONSULTORIA             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ PROGRAMA PARA GERAR GRAFICO CONSUMO PRODUDOS SD3 (A.ALEGRE)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ MV_PAR01, 02, 03, 04, 05, 06                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³ GRAFICO CONSUMO / QUANTIDADE E VALOR                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ESTOQUE/PCP                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GRAFPRD01()
Local nTpGraf := 5    
Local oRadioGrp1
Local nRadioGrp1 	:= 1 
Local oRadioGrp2
Local nRadioGrp2 	:= 1 
Local oRadioGrp3
Local nRadioGrp3 	:= 1 


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oRMenu1","oBtn1","oBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Tela para o usuario selecionar o tipo de gráfico que quer gerar         ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oDlg1      := MSDialog():New( 034,329,375,713,"Tipo de Gráfico",,,.F.,,,,,,.T.,,,.T. )
GoRMenu1   := TGroup():New( 004,004,164,096,"Selecione o tipo de Gráfico...",oDlg1,CLR_BLUE,CLR_WHITE,.T.,.F. )
@ C(010),C(007) Radio oRadioGrp1 Var nRadioGrp1 Items "01 Linha","02 Area","03 Pontos","04 Barras","05 Piramide",;
	"06 Cilindro","07 Barras Horintais","08 Piramide Horizontal","09 Cilindro Horizontal","10 Pizza","11 Forma",;
	"12 Linha rapida","13 Flexas","14 GANTT","15 Bolha" 3D Size C(40),C(010) PIXEL OF oDlg1 // Permite ao usuário selecionar o tipo de gráfico que deseja

GoRMenu2   := TGroup():New( 004,109,056,185,"3D / 2D",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
@ C(010),C(090) Radio oRadioGrp2 Var nRadioGrp2 Items "3D","2D" 3D Size C(56),C(026) PIXEL OF oDlg1                

GoRMenu3   := TGroup():New( 061,109,113,185,"Qtde/Valor",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
@ C(054),C(090) Radio oRadioGrp3 Var nRadioGrp3 Items "Quantidade","Valor" 3D Size C(56),C(026) PIXEL OF oDlg1                

oBtn1      := TButton():New( 120,108,"&Confirmar",oDlg1,{ || U_MNTGRAF(nRadioGrp1,nRadioGrp2,nRadioGrp3) },076,020,,,,.T.,,"Confirmar o tipo de Grafico",,,,.F. )
oBtn2      := TButton():New( 144,108,"Ca&ncelar",oDlg1,{||oDlg1:End()},076,020,,,,.T.,,"Cancelar tudo",,,,.F. )



oDlg1:Activate(,,,.T.)

Return


                              
User Function MNTGRAF(nRadioGrp1, nRadioGrp2, nRadioGrp3)
local ncont,ncont1:=0                                                                  
Local cAliasQry    := GetNextAlias()
Local cAliasQrySD3 := GetNextAlias()
Local cQuery 		:= ''               
Local cQuerySD3 := ''
Local cMsg := ""
                                 

PRIVATE cPerg	:= "GRFEST"

AjustaSx1()
If ! Pergunte(cPerg,.T.)
	Return
Endif
                                                 

cArq := CriaTrab(NIL, .F.)
cIndice := "CODIGO" 
aStru := {}
AADD(aStru,{ "CODIGO" , "C", 6, 0})
AADD(aStru,{ "QUANT" , "N", 16, 4})
cArqTrab := CriaTrab(aStru, .T.)

If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea("TRB")
Endif
dbUseArea(.T.,,cArqTrab,"TRB",Nil,.F.)


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Rotina pré definida, caso queiram incluir no gráfico os produtos do     ±±
±± Faturamento também SD2                                                  ±± 
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*
cQuery := "SELECT D2_COD, Sum(SD2.D2_QUANT) D2_QUANT "
cQuery += "FROM " + RetSQLName( "SD2" ) + " SD2, " + RetSqlName("SF4") + " SF4 "
cQuery += "WHERE "
cQuery += "SD2.D2_FILIAL = '"+xFilial("SD2") + "' AND "
cQuery += "SF4.F4_FILIAL = '"+xFilial("SF4") + "' AND "
cQuery += "SD2.D2_TES = SF4.F4_CODIGO AND "
//cQuery += "SD2.D2_FILIAL = SF4.F4_FILIAL AND " - Comentado por ter unificado as TES                     
cQuery += "SF4.F4_ESTOQUE = 'S' AND "
cQuery += "SD2.D2_EMISSAO BETWEEN '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' AND "
cQuery += "SD2.D2_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND "
cQuery += "SD2.D2_COD BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQuery += " AND SD2.D_E_L_E_T_ <> '*' AND SF4.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY SD2.D2_COD "

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)

ncont:=0
While !(cAliasQry)->(EoF())
	RecLock("TRB",.T.)
	TRB->CODIGO := (cAliasQry)->D2_COD
	TRB->QUANT := (cAliasQry)->D2_QUANT
 	ncont++
	MsUnlock("TRB") 
(cAliasQry)->(dbSkip())
enddo 
msgbox("Total Inserido-->> "+cValToChar(nCont))
*/                              

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Filtra os itens do SD3, tudo o que for > 500 é tratado como item        ±±
±± consumido de saída                                                      ±± 
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
if nRadioGrp3 == 1                          
	cMsg:= "(Consumo por Quantidade)"
	cQuerySD3 := "SELECT D3_COD, Sum(SD3.D3_QUANT) D3_QUANT "
	cQuerySD3 += "FROM " + RetSQLName( "SD3" ) + " SD3, "
	cQuerySD3 += "WHERE "
	cQuerySD3 += "SD3.D3_FILIAL = '"+xFilial("SD3") + "' AND "
	cQuerySD3 += "SD3.D3_EMISSAO BETWEEN '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' AND "
	cQuerySD3 += "SD3.D3_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND "
	cQuerySD3 += "SD3.D3_COD BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND "
	cQuerySD3 += "SD3.D3_TM > '500' "
	cQuerySD3 += "AND SD3.D_E_L_E_T_ <> '*' "
	cQuerySD3 += "GROUP BY SD3.D3_COD "
else                     
	cMsg:= "(Consumo por Valor)"
	cQuerySD3 := "SELECT D3_COD, Sum(SD3.D3_CUSTO1) D3_QUANT "
	cQuerySD3 += "FROM " + RetSQLName( "SD3" ) + " SD3, "
	cQuerySD3 += "WHERE "
	cQuerySD3 += "SD3.D3_FILIAL = '"+xFilial("SD3") + "' AND "
	cQuerySD3 += "SD3.D3_EMISSAO BETWEEN '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' AND "
	cQuerySD3 += "SD3.D3_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND "
	cQuerySD3 += "SD3.D3_COD BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND "
	cQuerySD3 += "SD3.D3_TM > '500' "
	cQuerySD3 += "AND SD3.D_E_L_E_T_ <> '*' "
	cQuerySD3 += "GROUP BY SD3.D3_COD "
endif
ncont:=0

cQuerySD3 := ChangeQuery(cQuerySD3)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuerySD3),cAliasQrySD3, .F., .T.)
While !(cAliasQrySD3)->(EoF())
  dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->CODIGO := (cAliasQrySD3)->D3_COD
	TRB->QUANT := (cAliasQrySD3)->D3_QUANT
	ncont++
	MsUnlock("TRB") 
(cAliasQrySD3)->(dbSkip())
enddo 
ncont1 := ncont
ncont:= ncont * 19.6
if ncont < 570 
  ncont := 570                           
elseif ncont > 1100
  ncont := 1100
endif
  
DEFINE MSDIALOG oDlg TITLE iif(nRadioGrp3 == 2, "Grafico de consumo de produto por valor", "Grafico de consumo de produto por quantidade") FROM 0,0 TO 550,1150 PIXEL
  
@ 001, 001 MSGRAPHIC oGraphic SIZE ncont, 250 OF oDlg
oGraphic:SetTitle('Perido de ' +DTOC(MV_PAR01)+' até '+DTOC(MV_PAR02)+ ' Grupo de '+MV_PAR03+' até '+MV_PAR04+' Produto de ';
+MV_PAR05+' até '+MV_PAR06+ ' total de '+cValToChar(ncont1)+' itens no gráfico '+cMsg , , CLR_BLACK, A_LEFTJUST, GRP_TITLE )
oGraphic:SetMargins(2,8,8,8)
oGraphic:SetGradient(GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE)
oGraphic:SetLegenProp(GRP_SCRRIGHT, CLR_HGRAY, GRP_AUTO,.T.)
nSerie := oGraphic:CreateSerie( nRadioGrp1 )
if nRadioGrp2 == 1 
	oGraphic:l3D := .T. // Grafico em 3D
else
	oGraphic:l3D := .F. // Grafico em 2D	
endif
oGraphic:lAxisVisib := .T. // Mostra os eixos
// Itens do Grafico 
dbSelectArea("TRB")
TRB->(dbgotop())                           
While !TRB->(EoF())
 	oGraphic:Add(nSerie, TRB->QUANT, TRB->CODIGO, CLR_BLUE )
 	nCont++
	TRB->(dbSkip())
enddo                                         
                
@ 260, 050 BUTTON "Salva Grafico" SIZE 40,14 OF oDlg PIXEL ACTION GrafSavBmp( oGraphic ) MESSAGE "Salva BMP" //oGraphic:SaveToBMP('GrafProd.bmp','c:\')
@ 260, 120 BUTTON 'Zoom IN' SIZE 40,14 OF oDlg PIXEL ACTION oGraphic:ZoomIn()
@ 260, 190 BUTTON 'Zoom OUT' SIZE 40,14 OF oDlg PIXEL ACTION oGraphic:ZoomOut()
ACTIVATE MSDIALOG oDlg CENTERED


//Excluir a tabela TEMPORÁRIA CRIADA
DbSelectArea( "TRB" )
DbCloseArea()
If Select("cArq") = 0
	FErase(cArq+GetDBExtension())
EndIf
Return                              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Anesio G.Faria -    ³    21.07.2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aArea := GetArea()
PutSx1(cPerg,"01","Periodo de                    ?"," "," ","mv_ch1","D",8,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a data inicial"},{"Informe a data inicial"},{"Informe a data inicial"})
PutSx1(cPerg,"02","Periodo ate                   ?"," "," ","mv_ch2","D",8,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a data final"},{"Informe a data final"},{"Informe a data final"})
PutSx1(cPerg,"03","Grupo de                      ?"," "," ","mv_ch3","C",4,0,0,	"G","","SBM","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","SBM",{"Informe o grupo inicial"},{"Informe o grupo inicial"},{"Informe o grupo inicial"})
PutSx1(cPerg,"04","Grupo ate                     ?"," "," ","mv_ch4","C",4,0,0,	"G","","SBM","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","SBM",{"Informe o grupo final"},{"Informe o grupo final"},{"Informe o grupo final"})
PutSx1(cPerg,"05","Produto de                    ?"," "," ","mv_ch5","C",15,0,0,"G","","SB1","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","SB1",{"Informe o produto inicial"},{"Informe o produto inicial"},{"Informe o produto inicial"})
PutSx1(cPerg,"06","Produto ate                   ?"," "," ","mv_ch6","C",15,0,0,"G","","SB1","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","SB1",{"Informe o produto final"},{"Informe o produto final"},{"Informe o produto final"})

RestArea(aArea)
Return