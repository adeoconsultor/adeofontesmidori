#INCLUDE "rwmake.ch"
#include "PROTHEUS.CH"
#include "TOPCONN.CH" 
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#DEFINE PICVAL  "@E 999,999,999.99"



User Function AG_CADRELE


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Cadastro de Release. . ."
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","U_SZSINC()",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} ,;
             {"Imprimir Ficha","U_FCRASPA( SZS->(RECNO()) )",0,1} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZS"

dbSelectArea("SZS")
dbSetOrder(1)


dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return

//////////////////////////////////////////////////////////////////////////////////////////
//Funcao de inclui itens do release
//Desenvolvido por Anesio em 28/06/2015 - anesio@outlook.com
//////////////////////////////////////////////////////////////////////////////////////////
user function SZSINC()
Local nOpc := GD_INSERT+GD_DELETE+GD_UPDATE
Private aCoBrw1 := {}
Private aHoBrw1 := {}
Private cGetDesc   := Space(50)
Private cGetObs    := Space(40)
Private cGetProd   := Space(15)
Private cGetReleas := Space(10)
Private cSayAno    := Space(8)
Private cSayDom    := Space(8)
Private cSayDtPlan := Space(10)
Private cSayMes    := Space(8)
Private cSayObs    := Space(8)
Private cSayPrd    := Space(8)
Private cSayQua    := Space(8)
Private cSayQui    := Space(8)
Private cSaySab    := Space(8)
Private cSaySeg    := Space(8)
//Private cSaySemana := Space(8)
Private cSaySex    := Space(8)
Private cSayTer    := Space(8)
Private cSayVersao := Space(8)
//Private dGetDtGPln := dDataBase
Private nCBoxAno  
Private nCBoxMes  
Private nCBoxSeman
Private nCBoxVersa
Private nGetDom    := 0
Private nGetQua    := 0
Private nGetQui    := 0
Private nGetSab    := 0
Private nGetSeg    := 0
Private nGetSex    := 0
Private nGetTer    := 0
Private nGetD08 	   := 0
Private nGetD09 	   := 0
Private nGetD10 	   := 0
Private nGetD11 	   := 0
Private nGetD12 	   := 0
Private nGetD13 	   := 0
Private nGetD14 	   := 0
Private nGetD15 	   := 0
Private nGetD16 	   := 0
Private nGetD17 	   := 0
Private nGetD18 	   := 0
Private nGetD19 	   := 0
Private nGetD20 	   := 0
Private nGetD21 	   := 0
Private nGetD22 	   := 0
Private nGetD23 	   := 0
Private nGetD24 	   := 0
Private nGetD25 	   := 0
Private nGetD26 	   := 0
Private nGetD27 	   := 0
Private nGetD28 	   := 0
Private nGetD29 	   := 0
Private nGetD30 	   := 0
Private nGetD31 	   := 0
Private noBrw1  := 0
Private obrProds
Private cProd
Private acPrds := {}

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSayAno","oSayMes","oSaySemana","oSay1","oSayVersao","oSayDtPlano","oCBoxAno")
SetPrvt("oCBoxSemana","oGetRelease","oCBoxVersao","oGetDtGPln","oGrp2","oSayPrd","oSayDom","oSaySeg")
SetPrvt("oSayQua","oSayQui","oSaySex","oSaySab","oSayObs","oGetProd","oGetDesc","oGetDom","oGetSeg","oGetTer")
SetPrvt("oGetQui","oGetSex","oGetSab")
SetPrvt("nGetD08","nGetD09","nGetD10","nGetD11","nGetD12","nGetD13","nGetD14","nGetD15")
SetPrvt("nGetD16","nGetD17","nGetD18","nGetD19","nGetD20","nGetD21","nGetD22","nGetD23")
SetPrvt("nGetD24","nGetD25","nGetD26","nGetD27","nGetD28","nGetD29","nGetD30","nGetD31")
SetPrvt("oGetObs","oBtnSalva","oGrpLista","oBrw1","oBtnExclui","oBtnPrint")


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 117,240,650,1252,"Planejamento de Release ",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 004,004,036,508,"Cabeçalho....",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayAno    := TSay():New( 012,012,{||"ANO"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayMes    := TSay():New( 012,060,{||"MES"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSaySemana := TSay():New( 012,112,{||"SEMANA"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay1      := TSay():New( 012,160,{||"Release"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayVersao := TSay():New( 012,228,{||"Versão"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayDtPlan := TSay():New( 012,264,{||"Data Gerar Plano"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oCBoxAno   := TComboBox():New( 020,012,{|u| If(PCount()>0,nCBoxAno:=u,nCBoxAno)},{"2015","2016","2017","2018","2019","2020"},040,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nCBoxAno )
oCBoxMes   := TComboBox():New( 020,060,{|u| If(PCount()>0,nCBoxMes:=u,nCBoxMes)},{"01-Janeiro","02-Fevereiro","03-Mar?o","04-Abril","05-Maio","06-Junho","07-Julho","08-Agosto","09-Setembro","10-Outubro","11-Novembro","12-Dezembro"},044,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nCBoxMes )
//oCBoxSeman := TComboBox():New( 020,112,{|u| If(PCount()>0,nCBoxSemana:=u,nCBoxSemana)},{"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53"},040,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nCBoxSemana )
oGetReleas := TGet():New( 020,160,{|u| If(PCount()>0,cGetReleas:=u,cGetReleas)},oGrp1,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetReleas",,)
oCBoxVersa := TComboBox():New( 020,228,{|u| If(PCount()>0,nCBoxVersa:=u,nCBoxVersa)},{"01","02","03","04","05","06","07","08","09","10"},032,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nCBoxVersa )
//oGetDtGPln := TGet():New( 020,264,{|u| If(PCount()>0,dGetDtGPln:=u,dGetDtGPln)},oGrp1,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dGetDtGPln",,)
oGrp2      := TGroup():New( 040,004,112,508,"Digitação de Itens...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayPrd    := TSay():New( 048,008,{||"Produto"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayDom    := TSay():New( 048,184,{||"Dia 01"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSaySeg    := TSay():New( 048,217,{||"Dia 02"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayTer    := TSay():New( 048,246,{||"Dia 03"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayQua    := TSay():New( 048,275,{||"Dia 04"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayQui    := TSay():New( 048,304,{||"Dia 05"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSaySex    := TSay():New( 048,333,{||"Dia 06"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSaySab    := TSay():New( 048,362,{||"Dia 07"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSaySab    := TSay():New( 048,391,{||"Dia 08"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD09    := TSay():New( 048,420,{||"Dia 09"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD10    := TSay():New( 048,449,{||"Dia 10"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD11    := TSay():New( 068,008,{||"Dia 11"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD12    := TSay():New( 068,037,{||"Dia 12"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD13    := TSay():New( 068,066,{||"Dia 13"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD14    := TSay():New( 068,095,{||"Dia 14"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD15    := TSay():New( 068,124,{||"Dia 15"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD16    := TSay():New( 068,153,{||"Dia 16"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD17    := TSay():New( 068,182,{||"Dia 17"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD18    := TSay():New( 068,211,{||"Dia 18"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD19    := TSay():New( 068,240,{||"Dia 19"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD20    := TSay():New( 068,269,{||"Dia 20"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD21    := TSay():New( 068,298,{||"Dia 21"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD22    := TSay():New( 068,337,{||"Dia 22"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD23    := TSay():New( 068,356,{||"Dia 23"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD24    := TSay():New( 068,385,{||"Dia 24"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD25    := TSay():New( 068,414,{||"Dia 25"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD26    := TSay():New( 068,443,{||"Dia 26"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD27    := TSay():New( 088,008,{||"Dia 27"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD28    := TSay():New( 088,037,{||"Dia 28"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD29    := TSay():New( 088,066,{||"Dia 29"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD30    := TSay():New( 088,095,{||"Dia 30"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayD31    := TSay():New( 088,124,{||"Dia 31"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

//oSayObs    := TSay():New( 048,404,{||"Obs"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetProd   := TGet():New( 056,008,{|u| If(PCount()>0,cGetProd:=u,cGetProd)},oGrp2,032,008,'@!',{|| BuscPrd(cGetProd)},CLR_BLACK,CLR_WHITE,,,,.T.,"Informe o código do produto",,,.F.,.F.,,.F.,.F.,"SB1","cGetProd",,)
//oGetDesc   := TGet():New( 056,056,{|u| If(PCount()>0,cGetDesc:=u,cGetDesc)},oGrp2,124,008,'@!',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDesc",,)
oGetDesc   := TSay():New( 060,040,{|| cGetDesc},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,124,008)
oGetDom    := TGet():New( 056,184,{|u| If(PCount()>0,nGetDom:=u,nGetDom)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetDom",,)
oGetSeg    := TGet():New( 056,213,{|u| If(PCount()>0,nGetSeg:=u,nGetSeg)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetSeg",,)
oGetTer    := TGet():New( 056,242,{|u| If(PCount()>0,nGetTer:=u,nGetTer)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetTer",,)
oGetQua    := TGet():New( 056,271,{|u| If(PCount()>0,nGetQua:=u,nGetQua)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetQua",,)
oGetQui    := TGet():New( 056,300,{|u| If(PCount()>0,nGetQui:=u,nGetQui)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetQui",,)
oGetSex    := TGet():New( 056,329,{|u| If(PCount()>0,nGetSex:=u,nGetSex)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetSex",,)
oGetSab    := TGet():New( 056,358,{|u| If(PCount()>0,nGetSab:=u,nGetSab)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetSab",,)
oGetD08    := TGet():New( 056,387,{|u| If(PCount()>0,nGetD08:=u,nGetD08)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD08",,)
oGetD09    := TGet():New( 056,416,{|u| If(PCount()>0,nGetD09:=u,nGetD09)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD09",,)
oGetD10    := TGet():New( 056,445,{|u| If(PCount()>0,nGetD10:=u,nGetD10)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD10",,)
oGetD11    := TGet():New( 076,008,{|u| If(PCount()>0,nGetD11:=u,nGetD11)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD11",,)
oGetD12    := TGet():New( 076,037,{|u| If(PCount()>0,nGetD12:=u,nGetD12)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD12",,)
oGetD13    := TGet():New( 076,066,{|u| If(PCount()>0,nGetD13:=u,nGetD13)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD13",,)
oGetD14    := TGet():New( 076,095,{|u| If(PCount()>0,nGetD14:=u,nGetD14)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD14",,)
oGetD15    := TGet():New( 076,124,{|u| If(PCount()>0,nGetD15:=u,nGetD15)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD15",,)
oGetD16    := TGet():New( 076,153,{|u| If(PCount()>0,nGetD16:=u,nGetD16)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD16",,)
oGetD17    := TGet():New( 076,182,{|u| If(PCount()>0,nGetD17:=u,nGetD17)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD17",,)
oGetD18    := TGet():New( 076,211,{|u| If(PCount()>0,nGetD18:=u,nGetD18)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD18",,)
oGetD19    := TGet():New( 076,240,{|u| If(PCount()>0,nGetD19:=u,nGetD19)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD19",,)
oGetD20    := TGet():New( 076,269,{|u| If(PCount()>0,nGetD20:=u,nGetD20)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD20",,)
oGetD21    := TGet():New( 076,298,{|u| If(PCount()>0,nGetD21:=u,nGetD21)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD21",,)
oGetD22    := TGet():New( 076,327,{|u| If(PCount()>0,nGetD22:=u,nGetD22)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD22",,)
oGetD23    := TGet():New( 076,356,{|u| If(PCount()>0,nGetD23:=u,nGetD23)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD23",,)
oGetD24    := TGet():New( 076,385,{|u| If(PCount()>0,nGetD24:=u,nGetD24)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD24",,)
oGetD25    := TGet():New( 076,414,{|u| If(PCount()>0,nGetD25:=u,nGetD25)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD25",,)
oGetD26    := TGet():New( 076,443,{|u| If(PCount()>0,nGetD26:=u,nGetD26)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD26",,)
oGetD27    := TGet():New( 096,008,{|u| If(PCount()>0,nGetD27:=u,nGetD27)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD27",,)
oGetD28    := TGet():New( 096,038,{|u| If(PCount()>0,nGetD28:=u,nGetD28)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD28",,)
oGetD29    := TGet():New( 096,066,{|u| If(PCount()>0,nGetD29:=u,nGetD29)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD29",,)
oGetD30    := TGet():New( 096,095,{|u| If(PCount()>0,nGetD30:=u,nGetD30)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD30",,)
oGetD31    := TGet():New( 096,124,{|u| If(PCount()>0,nGetD31:=u,nGetD31)},oGrp2,027,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetD31",,)



//oGetObs    := TGet():New( 056,387,{|u| If(PCount()>0,cGetObs:=u,cGetObs)},oGrp2,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetObs",,)
oBtnSalva  := TButton():New( 094,170,"Confirmar",oGrp2,{|| Confirma(), BuscPrd(cGetProd) },035,012,,,,.T.,,"",,,,.F. )
//oGrpLista  := TGroup():New( 076,004,204,508,"Lista do Release...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrpLista  := TGroup():New( 116,004,235,508,"Lista do Release...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
MHoBrw1()
MCoBrw1()

//cGetDesc, cGetObs cGetProd,cGetReleas cSayAno cSayDom cSayDtPlan cSayMes cSayObs cSayPrd cSayQua cSayQui cSaySab cSaySeg cSaySemana cSaySex cSayTer 

//@ 084,008 LISTBOX obrProds VAR cProd Fields HEADER "Ano","Mes","Semana","Codigo","Descricao","Dom","Seg","Ter","Qua","Qui","Sex","Sab", "Observacao", "Chave" ON CHANGE Prds() SIZE 494, 110  pixel // ON CHANGE CHNG() ON DBLCLICK Ad_PrLst()
@ 124,008 LISTBOX obrProds VAR cProd Fields HEADER "Ano","Mes","Codigo","Descricao","Dia01","Dia02","Dia03","Di04","Dia05","Dia06","Dia07", "Dia08", "Dia09", "Dia10", "Dia11", "Dia12", "Dia13", "Dia14", "Dia15", "Dia16", "Dia17", "Dia18", "Dia19", "Dia20", "Dia21", "Dia22", "Dia23", "Dia24", "Dia25", "Dia26", "Dia27", "Dia28", "Dia29", "Dia30", "Dia31", "Chave" ON CHANGE FltPrds() SIZE 494, 110  pixel // ON CHANGE CHNG() ON DBLCLICK Ad_PrLst()
//Para evitar valor zerado...
if len(acPrds) == 0
	//				01	   02   03   04   05  06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 
	AADD(acPrds, {"2015", "00", "00", "", "0", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 } )
endif
obrProds:SetArray(acPrds)
//									D01					D02						D03						D04						D05
//									D06					D07						D08						D09						D10						 
//									D11					D12						D13						D15						D15						 
//									D16					D17						D18						D19						D20						 
//									D21					D22						D23						D24						D25						 
//									D26					D27						D28						D29						D30							  D31						 
obrProds:bLine := { || { acPrds[obrProds:nAt,1],  acPrds[obrProds:nAt,2],  acPrds[obrProds:nAt,3],   acPrds[obrProds:nAt,4], acPrds[obrProds:nAt,5], ;
						 acPrds[obrProds:nAt,6],  acPrds[obrProds:nAt,7],  acPrds[obrProds:nAt,8],   acPrds[obrProds:nAt,9], acPrds[obrProds:nAt,10], ;
						 acPrds[obrProds:nAt,11], acPrds[obrProds:nAt,12], acPrds[obrProds:nAt,13],  acPrds[obrProds:nAt,14], acPrds[obrProds:nAt,15],;
						 acPrds[obrProds:nAt,16], acPrds[obrProds:nAt,17], acPrds[obrProds:nAt,18],  acPrds[obrProds:nAt,19], acPrds[obrProds:nAt,20], ;
						 acPrds[obrProds:nAt,21], acPrds[obrProds:nAt,22], acPrds[obrProds:nAt,23],  acPrds[obrProds:nAt,24], acPrds[obrProds:nAt,25], ;
						 acPrds[obrProds:nAt,26], acPrds[obrProds:nAt,27], acPrds[obrProds:nAt,28],  acPrds[obrProds:nAt,29], acPrds[obrProds:nAt,30], ;
						 acPrds[obrProds:nAt,31], acPrds[obrProds:nAt,32], acPrds[obrProds:nAt,33],  acPrds[obrProds:nAt,34],  acPrds[obrProds:nAt,35] ,  acPrds[obrProds:nAt,36] }  }

//oBrw1      := MsNewGetDados():New(084,008,200,504,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrpLista,aHoBrw1,aCoBrw1 )
oBtnExclui := TButton():New( 252,456,"E&xcluir Item",oDlg1,{|| Exclui() },049,012,,,,.T.,,"",,,,.F. )
oBtnPrint  := TButton():New( 252,400,"&Ver Release",oDlg1,{|| VRelease(acPrds)},049,012,,,,.T.,,"",,,,.F. )
oBtnGCM32  := TButton():New( 252,344,"&Gera CM32",oDlg1,{|| GERACM32(acPrds)},049,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return
      
//Funcao de exclusao
static function Exclui()
Local cQCHKPRD := ""

	cQCHKPRD := " SELECT R_E_C_N_O_ nReg FROM SZS010 WHERE D_E_L_E_T_ = ' ' AND ZS_FILIAL = '"+xFilial("SZS")+"' " 
	cQCHKPRD += " AND ZS_ANO = '"+nCBoxAno+"' AND ZS_MES = '"+Substr(nCBoxMes,1,2)+"' AND ZS_VERSAO = '"+nCBoxVersa+"' "
	cQCHKPRD += " AND ZS_RELEASE = '"+cGetReleas+"' AND ZS_PRODUTO = '"+acPrds[obrProds:nAt,3]+"' "
	
	if Select("TMPPRD") > 0 
		dbSelectArea("TMPPRD")
		TMPPRD->(dbCloseArea())
	endif

	dbUseArea(.T., "TOPCONN", TcGenQry(, , cQCHKPRD), "TMPPRD", .T., .T.)

	dbSelectArea("TMPPRD")
	TMPPRD->(dbGotop())
	nChave := TMPPRD->nREG


If ApMsgNoYes("Confirma a exclusão do registro "+cValToChar(nChave), "Atençao para exclusao...")
	dbSelectArea("SZS")
	SZS->(dbGoto(nChave))
	RecLock("SZS",.F.)
	dbDelete()
	MsUnLock("SZS")
	
/*	cQDel := "UPDATE "+ RetSqlName( 'SZS' ) + " SET D_E_L_E_T_ = '*' where ZS_FILIAL = '" + xFilial('SZS') + "' and R_E_C_N_O_  = "+cValToChar(acPrds[obrProds:nAt,14])
	MemoWrite("C:\Temp\cQDelRELEASE.TXT", cQDel)	
	nret1 := TcSqlExec( cQDel ) */
	Alert("Deletado com sucesso...")
	FltPrds()
	obrProds:SetArray(acPrds)
//	obrProds:bLine := { || { acPrds[obrProds:nAt,1],acPrds[obrProds:nAt,2],acPrds[obrProds:nAt,3],acPrds[obrProds:nAt,4], acPrds[obrProds:nAt,5], acPrds[obrProds:nAt,6], acPrds[obrProds:nAt,7], acPrds[obrProds:nAt,8], acPrds[obrProds:nAt,9],; 
//						 acPrds[obrProds:nAt,10], acPrds[obrProds:nAt,11], acPrds[obrProds:nAt,12], acPrds[obrProds:nAt,13], acPrds[obrProds:nAt,14] }  }
//									D01					D02						D03						D04						D05
//									D06					D07						D08						D09						D10						 
//									D11					D12						D13						D15						D15						 
//									D16					D17						D18						D19						D20						 
//									D21					D22						D23						D24						D25						 
//									D26					D27						D28						D29						D30							  D31						 
obrProds:bLine := { || { acPrds[obrProds:nAt,1],acPrds[obrProds:nAt,2],acPrds[obrProds:nAt,3],acPrds[obrProds:nAt,4], acPrds[obrProds:nAt,5], ;
						 acPrds[obrProds:nAt,6], acPrds[obrProds:nAt,7], acPrds[obrProds:nAt,8], acPrds[obrProds:nAt,9], acPrds[obrProds:nAt,10], ;
						 acPrds[obrProds:nAt,11], acPrds[obrProds:nAt,12], acPrds[obrProds:nAt,13], acPrds[obrProds:nAt,14],  acPrds[obrProds:nAt,15], ;
						 acPrds[obrProds:nAt,16], acPrds[obrProds:nAt,17], acPrds[obrProds:nAt,18],  acPrds[obrProds:nAt,19], acPrds[obrProds:nAt,20], ;
						 acPrds[obrProds:nAt,21], acPrds[obrProds:nAt,22], acPrds[obrProds:nAt,23],  acPrds[obrProds:nAt,24], acPrds[obrProds:nAt,25], ;
						 acPrds[obrProds:nAt,26], acPrds[obrProds:nAt,27], acPrds[obrProds:nAt,28],  acPrds[obrProds:nAt,29], acPrds[obrProds:nAt,30], ;
						 acPrds[obrProds:nAt,31], acPrds[obrProds:nAt,32], acPrds[obrProds:nAt,33],  acPrds[obrProds:nAt,34],  acPrds[obrProds:nAt,35] ,  acPrds[obrProds:nAt,36] }  }
	obrProds:Refresh()
	
endif

return

//Função de confirmar
static function Confirma()
if Valida()
	Grava()
endif
return

//Funcao de gravacao
static function Grava()
RecLock("SZS",.T.)
SZS->ZS_FILIAL 		:= xFilial("SZS")
SZS->ZS_ANO 		:= nCBoxAno
SZS->ZS_MES			:= nCBoxMes 
//SZS->ZS_SEMANA 		:= nCBoxSemana
SZS->ZS_VERSAO 		:= nCBoxVersa
//SZS->ZS_DTGPLN 		:= dGetDtGPln
SZS->ZS_QTDPPLN 	:= 0
SZS->ZS_PRODUTO		:= cGetProd
SZS->ZS_PRODACA  	:= cGetProd
SZS->ZS_DIA01 		:= nGetDom
SZS->ZS_DIA02 		:= nGetSeg
SZS->ZS_DIA03 		:= nGetTer
SZS->ZS_DIA04 		:= nGetQua
SZS->ZS_DIA05 		:= nGetQui
SZS->ZS_DIA06		:= nGetSex
SZS->ZS_DIA07		:= nGetSab
SZS->ZS_DIA08		:= nGetD08
SZS->ZS_DIA09		:= nGetD09
SZS->ZS_DIA10		:= nGetD10
SZS->ZS_DIA11		:= nGetD11
SZS->ZS_DIA12		:= nGetD12
SZS->ZS_DIA13		:= nGetD13
SZS->ZS_DIA14		:= nGetD14
SZS->ZS_DIA15		:= nGetD15
SZS->ZS_DIA16		:= nGetD16
SZS->ZS_DIA17		:= nGetD17
SZS->ZS_DIA18		:= nGetD18
SZS->ZS_DIA19		:= nGetD19
SZS->ZS_DIA20		:= nGetD20
SZS->ZS_DIA21		:= nGetD21
SZS->ZS_DIA22		:= nGetD22
SZS->ZS_DIA23		:= nGetD23
SZS->ZS_DIA24		:= nGetD24
SZS->ZS_DIA25		:= nGetD25
SZS->ZS_DIA26		:= nGetD26
SZS->ZS_DIA27		:= nGetD27
SZS->ZS_DIA28		:= nGetD28
SZS->ZS_DIA29		:= nGetD29
SZS->ZS_DIA30		:= nGetD30
SZS->ZS_DIA31		:= nGetD31

SZS->ZS_PLNGERA		:= "N"
SZS->ZS_PLANO 		:= ""
SZS->ZS_RELEASE 	:= cGetReleas
SZS->ZS_OBSERV 		:= cGetObs
MsUnlock("SZS")	
Alert("Gravado com sucesso...")
	FltPrds()
	obrProds:SetArray(acPrds)
//	obrProds:bLine := { || { acPrds[obrProds:nAt,1],acPrds[obrProds:nAt,2],acPrds[obrProds:nAt,3],acPrds[obrProds:nAt,4], acPrds[obrProds:nAt,5], acPrds[obrProds:nAt,6], acPrds[obrProds:nAt,7], acPrds[obrProds:nAt,8], acPrds[obrProds:nAt,9],; 
//						 acPrds[obrProds:nAt,10], acPrds[obrProds:nAt,11], acPrds[obrProds:nAt,12], acPrds[obrProds:nAt,13], acPrds[obrProds:nAt,14] }  }
//									D01					D02						D03						D04						D05
//									D06					D07						D08						D09						D10						 
//									D11					D12						D13						D15						D15						 
//									D16					D17						D18						D19						D20						 
//									D21					D22						D23						D24						D25						 
//									D26					D27						D28						D29						D30							  D31						 
obrProds:bLine := { || { acPrds[obrProds:nAt,1],acPrds[obrProds:nAt,2],acPrds[obrProds:nAt,3],acPrds[obrProds:nAt,4], acPrds[obrProds:nAt,5], ;
						 acPrds[obrProds:nAt,6], acPrds[obrProds:nAt,7], acPrds[obrProds:nAt,8], acPrds[obrProds:nAt,9], acPrds[obrProds:nAt,10], ;
						 acPrds[obrProds:nAt,11], acPrds[obrProds:nAt,12], acPrds[obrProds:nAt,13], acPrds[obrProds:nAt,14],  acPrds[obrProds:nAt,15], ;
						 acPrds[obrProds:nAt,16], acPrds[obrProds:nAt,17], acPrds[obrProds:nAt,18],  acPrds[obrProds:nAt,19], acPrds[obrProds:nAt,20], ;
						 acPrds[obrProds:nAt,21], acPrds[obrProds:nAt,22], acPrds[obrProds:nAt,23],  acPrds[obrProds:nAt,24], acPrds[obrProds:nAt,25], ;
						 acPrds[obrProds:nAt,26], acPrds[obrProds:nAt,27], acPrds[obrProds:nAt,28],  acPrds[obrProds:nAt,29], acPrds[obrProds:nAt,30],;
						 acPrds[obrProds:nAt,31], acPrds[obrProds:nAt,32], acPrds[obrProds:nAt,33],  acPrds[obrProds:nAt,34],  acPrds[obrProds:nAt,35], acPrds[obrProds:nAt,36] }  }
	obrProds:Refresh()
	
	ClsField()
return 

//Função para limpar os campos de produtos
static function ClsField()
cGetProd := space(15)
cGetDesc := space(50)
nGetDom  := 0
nGetSeg  := 0
nGetTer  := 0
nGetQua  := 0
nGetQui  := 0
nGetSex  := 0
nGetSab  := 0
nGetD08 	   := 0
nGetD09 	   := 0
nGetD10 	   := 0
nGetD11 	   := 0
nGetD12 	   := 0
nGetD13 	   := 0
nGetD14 	   := 0
nGetD15 	   := 0
nGetD16 	   := 0
nGetD17 	   := 0
nGetD18 	   := 0
nGetD19 	   := 0
nGetD20 	   := 0
nGetD21 	   := 0
nGetD22 	   := 0
nGetD23 	   := 0
nGetD24 	   := 0
nGetD25 	   := 0
nGetD26 	   := 0
nGetD27 	   := 0
nGetD28 	   := 0
nGetD29 	   := 0
nGetD30 	   := 0
nGetD31 	   := 0


cGetObs  := space(40)

oGetProd:Refresh()
oGetDesc:Refresh()
oGetDom:Refresh()
oGetSeg:Refresh()
oGetTer:Refresh()
oGetQua:Refresh()
oGetQui:Refresh()
oGetSex:Refresh()
oGetSab:Refresh()
oGetD08:Refresh()
oGetD09:Refresh()
oGetD10:Refresh()
oGetD11:Refresh()
oGetD12:Refresh()
oGetD13:Refresh()
oGetD14:Refresh()
oGetD15:Refresh()
oGetD16:Refresh()
oGetD17:Refresh()
oGetD18:Refresh()
oGetD19:Refresh()
oGetD20:Refresh()
oGetD21:Refresh()
oGetD22:Refresh()
oGetD23:Refresh()
oGetD24:Refresh()
oGetD25:Refresh()
oGetD26:Refresh()
oGetD27:Refresh()
oGetD28:Refresh()
oGetD29:Refresh()
oGetD30:Refresh()
oGetD31:Refresh()

//oGetObs:Refresh()
oGetProd:SetFocus()

return

//Funcao de validacao
static function Valida()
Local cQCHKPRD := ""

cQCHKPRD := " SELECT R_E_C_N_O_ nReg FROM SZS010 WHERE D_E_L_E_T_ = ' ' AND ZS_FILIAL = '"+xFilial("SZS")+"' " 
cQCHKPRD += " AND ZS_ANO = '"+nCBoxAno+"' AND ZS_MES = '"+Substr(nCBoxMes,1,2)+"' AND ZS_VERSAO = '"+nCBoxVersa+"' "
cQCHKPRD += " AND ZS_RELEASE = '"+cGetReleas+"' AND ZS_PRODUTO = '"+cGetProd+"' "
if Select("TMPPRD") > 0 
	dbSelectArea("TMPPRD")
	TMPPRD->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", TcGenQry(, , cQCHKPRD), "TMPPRD", .T., .T.)

dbSelectArea("TMPPRD")
TMPPRD->(dbGotop())
nCT := 0
while !TMPPRD->(eof())
	nCT ++
	TMPPRD->(dbSkip())
enddo

if nCT > 0 
	Alert("Produto já lançado neste RELEASE")
	return .F.
endif




if nCBoxAno == space(4)
	Alert("Ano nao preenchido")
	return .F.
endif
if nCBoxMes == space(2)
	Alert("Mes nao preenchido")
	return .F.
endif
//if nCBoxSemana == space(2)
//	Alert("Semana nao preenchida")
//	return .F.
//endif
if cGetreleas == space(10)
	Alert("Release não preenchido")
	return .F.
endif
if nCBoxVersa == space(2)
	Alert("Versão nao preenchida")
	return .F.
endif

if cGetProd == space(15)
	Alert("Produto não preenchido...")
	return .F.
endif
dbSelectArea("SB1")
dbSetOrder(1)
	if !dbSeek(xFilial("SB1")+cGetProd)
		Alert("Produto não preenchido corretamente...")
		return .F.
	endif          

return .T.

//Funcao para buscar o produto
static function BuscPrd(cGetProd)
cGetDesc := Posicione("SB1",1, xFilial("SB1")+cGetProd, "B1_DESC")
oGetDesc:Refresh()
return

//Query para filtrar os produtos da programação
static function FltPrds()
Local cQuery := ""
acPrds := {} 
//				01	   02   03   04   05  06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 
AADD(acPrds, {"2015", "00", "00", "", "0", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 } )
//AADD(acPrds, {"2015", "00", "00", "", "", 0, 0, 0, 0, 0, 0, 0, "Cabecalho...",0} )
cQuery := " SELECT ZS_FILIAL, ZS_ANO, ZS_MES, ZS_VERSAO, ZS_QTDPPLN, ZS_PRODUTO, "
cQuery += " ZS_DIA01, ZS_DIA02, ZS_DIA03, ZS_DIA04, ZS_DIA05, ZS_DIA06, ZS_DIA07, ZS_DIA08, ZS_DIA09, ZS_DIA10, ZS_DIA11, "
cQuery += " ZS_DIA12, ZS_DIA13, ZS_DIA14, ZS_DIA15, ZS_DIA16, ZS_DIA17, ZS_DIA18, ZS_DIA19, ZS_DIA20, ZS_DIA21, ZS_DIA22, "
cQuery += " ZS_DIA23, ZS_DIA24, ZS_DIA25, ZS_DIA26, ZS_DIA27, ZS_DIA28, ZS_DIA29, ZS_DIA30, ZS_DIA31,  ZS_PLNGERA, ZS_PLANO, ZS_RELEASE, ZS_OBSERV, R_E_C_N_O_ nReg "
cQuery += " FROM "+RetSqlName("SZS")+" SZS WHERE D_E_L_E_T_ = ' ' and ZS_FILIAL = '"+xFilial("SZS")+"' "
cQuery += " AND ZS_ANO = '"+nCBoxAno+"' AND ZS_MES = '"+Substr(nCBoxMes,1,2)+"' AND ZS_VERSAO = '"+nCBoxVersa+"' "
cQuery += " AND ZS_RELEASE = '"+cGetReleas+"' AND ZS_TIPO <> 'M' " 
cQuery += " ORDER BY 2, 3, 4, 8 "
MemoWrite("C:\TEMP\CADRELE.TXT", cQuery)

if Select("TMPZS") > 0 
	dbSelectArea("TMPZS")
	TMPZS->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPZS", .T., .T.)
dbSelectArea("TMPZS")
TMPZS->(dbGotop())
while !TMPZS->(eof())
	AADD(acPrds, {TMPZS->ZS_ANO, TMPZS->ZS_MES, TMPZS->ZS_PRODUTO, Posicione("SB1", 1, xFilial("SB1")+TMPZS->ZS_PRODUTO, "B1_DESC"), ;
					TMPZS->ZS_DIA01, TMPZS->ZS_DIA02, TMPZS->ZS_DIA03, TMPZS->ZS_DIA04, TMPZS->ZS_DIA05, TMPZS->ZS_DIA06, TMPZS->ZS_DIA07, ;
					TMPZS->ZS_DIA08, TMPZS->ZS_DIA09, TMPZS->ZS_DIA10, TMPZS->ZS_DIA11, TMPZS->ZS_DIA12, TMPZS->ZS_DIA13, TMPZS->ZS_DIA14, ;
					TMPZS->ZS_DIA15, TMPZS->ZS_DIA16, TMPZS->ZS_DIA17, TMPZS->ZS_DIA18, TMPZS->ZS_DIA19, TMPZS->ZS_DIA20, TMPZS->ZS_DIA21, ;
					TMPZS->ZS_DIA22, TMPZS->ZS_DIA23, TMPZS->ZS_DIA24, TMPZS->ZS_DIA25, TMPZS->ZS_DIA26, TMPZS->ZS_DIA27, TMPZS->ZS_DIA28, ;
					TMPZS->ZS_DIA29, TMPZS->ZS_DIA30, TMPZS->ZS_DIA31, TMPZS->nReg} )
	TMPZS->(dbSkip())
enddo

return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: SZS
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrw1()

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SZS")
While !Eof() .and. SX3->X3_ARQUIVO == "SZS"
   If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
      noBrw1++
      Aadd(aHoBrw1,{Trim(X3Titulo()),;
           SX3->X3_CAMPO,;
           SX3->X3_PICTURE,;
           SX3->X3_TAMANHO,;
           SX3->X3_DECIMAL,;
           "",;
           "",;
           SX3->X3_TIPO,;
           "",;
           "" } )
   EndIf
   DbSkip()
End

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MCoBrw1() - Monta aCols da MsNewGetDados para o Alias: SZS
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MCoBrw1()

Local aAux := {}
Local nI

Aadd(aCoBrw1,Array(noBrw1+1))
For nI := 1 To noBrw1
   aCoBrw1[1][nI] := CriaVar(aHoBrw1[nI][2])
Next
aCoBrw1[1][noBrw1+1] := .F.

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////
//Gerar o Registro do CM32
static function GERACM32(acPrds)
	Processa({ || CM32(acPrds), "Aguarde....processando CM32" })
return

static function CM32(acPrds)
local cQuery    := ""
local cQZ3      := ""
local nPos      := 1
local cPrd3     := GetMV ('MA_RELE3')
local dUlMes		:= GetMV ('MV_ULMES')
Local it,i
Private aAux		:= {}
Private lMsErroAuto := .F.
Private nRat		:= 0

                        
//Verificar se já existe release cadastrado
cQVR  := " Select ZS_PRODACA+ZS_TIPO+ZS_PRODUTO, ZS_PRODUTO, R_E_C_N_O_ nREG from SZS010 "
cQVR  += " where D_E_L_E_T_ =' ' AND ZS_RELEASE = '"+cGetReleas+"' AND ZS_ANO = '"+nCBoxAno+"' AND ZS_MES = '"+substr(nCBoxMes,1,2)+"' AND ZS_VERSAO = '"+nCBoxVersa+"' "
cQVR  += " AND ZS_FILIAL = '"+xFilial("SZS")+"' AND ZS_TIPO = 'M' "
cQVR  += " order by 1, R_E_C_N_O_  "

if Select("TMPC32") > 0
 	dbSelectArea("TMPC32")
 	TMPC32->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", TcGenQry(, , cQVR), "TMPC32", .T., .T.)

dbSelectArea("TMPC32")
TMPC32->(dbGotop())

procregua(0)
while !TMPC32->(eof())
	dbSelectArea("SZS")
	SZS->(dbGoto(TMPC32->nREG))
	RecLock("SZS", .F.)
	dbDelete()
	MsUnlock("SZS")
//	cQDel := "UPDATE "+ RetSqlName( 'SZS' ) + " SET D_E_L_E_T_ = '*' where ZS_FILIAL = '" + xFilial('SZS') + "' and R_E_C_N_O_  = "+cValToChar(TMPZS->nREG)
//	MemoWrite("C:\Temp\cQDelRELEASE.TXT", cQDel)	
//	nret1 := TcSqlExec( cQDel )
	incProc("DELETANDO CM32 Anterior....","Aguarde....")
	TMPC32->(dbSkip())
enddo


procregua(0)
for i:= 2 to len(acPrds)                  
    aAux := u_buscacp(acPrds[i][3])
	for it := 1 to len(aAux)
		cQZ3 := " Select Z3_MATERIA, SUM(Z3_M2TOT) IDEAL, SUM(Z3_SLDM2) VLRREAL from SZ3010 SZ3, SB1010 SB1 " 
		cQZ3 += " where SZ3.D_E_L_E_T_ =' '  and SB1.D_E_L_E_T_ = ' ' and B1_FILIAL = '"+xFilial("SB1")+"' and Z3_FILIAL ='"+xFilial("SZ3")+"' "
		cQZ3 += " and Z3_MATERIA = '"+aAux[it][1]+"' AND Z3_MATERIA = B1_COD " //and B1_GRUPO not in ('45') "
		cQZ3 += " and Substring(Z3_DTFICHA,1,6) ='"+Substr(dTos(dUlMes),1,6)+"' " 
		cQZ3 += " group by Z3_MATERIA "
		memowrite("C:\TEMP\QRY_APROVEITAMENTO.TXT", cQZ3)
			if Select("TMPZ3") > 0 
				dbSelectArea("TMPZ3")
				TMPZ3->(dbCloseArea())
			endif
			dbUseArea(.T., "TOPCONN", TcGenQry(, , cQZ3), "TMPZ3", .T., .T.)
			dbSelectArea("TMPZ3")
			TMPZ3->(dbGotop())
			nAprov := TMPZ3->IDEAL / TMPZ3->VLRREAL
			if nAprov == 0 
				nAprov := 1
			endif
			dbSelectArea("SZS")
			RecLock("SZS",.T.)
			SZS->ZS_FILIAL	 := xFIlial("SZS")
			SZS->ZS_ANO		 := acPrds[i][1]
			SZS->ZS_MES		 := acPrds[i][2]
			SZS->ZS_VERSAO	 := nCBoxVersa
			SZS->ZS_QTDPPLN	 := 0
			SZS->ZS_PRODUTO  := aAux[it][1]
			SZS->ZS_PLNGERA  := "N"
			SZS->ZS_PLANO    := ""
			SZS->ZS_RELEASE  := cGetReleas
			SZS->ZS_PRODACA  := acPrds[i][3]
			SZS->ZS_TIPO	 := "MATERIAL"	
			SZS->ZS_DIA01    := (aAux[it][4]*acPrds[i][5]) / nAprov
			SZS->ZS_DIA02    := (aAux[it][4]*acPrds[i][6]) / nAprov
			SZS->ZS_DIA03    := (aAux[it][4]*acPrds[i][7]) / nAprov
			SZS->ZS_DIA04    := (aAux[it][4]*acPrds[i][8]) / nAprov
			SZS->ZS_DIA05    := (aAux[it][4]*acPrds[i][9]) / nAprov
			SZS->ZS_DIA06    := (aAux[it][4]*acPrds[i][10]) / nAprov
			SZS->ZS_DIA07    := (aAux[it][4]*acPrds[i][11]) / nAprov
			SZS->ZS_DIA08    := (aAux[it][4]*acPrds[i][12]) / nAprov
			SZS->ZS_DIA09    := (aAux[it][4]*acPrds[i][13]) / nAprov
			SZS->ZS_DIA10    := (aAux[it][4]*acPrds[i][14]) / nAprov
			SZS->ZS_DIA11    := (aAux[it][4]*acPrds[i][15]) / nAprov
			SZS->ZS_DIA12    := (aAux[it][4]*acPrds[i][16]) / nAprov
			SZS->ZS_DIA13    := (aAux[it][4]*acPrds[i][17]) / nAprov
			SZS->ZS_DIA14    := (aAux[it][4]*acPrds[i][18]) / nAprov
			SZS->ZS_DIA15    := (aAux[it][4]*acPrds[i][19]) / nAprov
			SZS->ZS_DIA16    := (aAux[it][4]*acPrds[i][20]) / nAprov
			SZS->ZS_DIA17    := (aAux[it][4]*acPrds[i][21]) / nAprov
			SZS->ZS_DIA18    := (aAux[it][4]*acPrds[i][22]) / nAprov
			SZS->ZS_DIA19    := (aAux[it][4]*acPrds[i][23]) / nAprov
			SZS->ZS_DIA20    := (aAux[it][4]*acPrds[i][24]) / nAprov
			SZS->ZS_DIA21    := (aAux[it][4]*acPrds[i][25]) / nAprov
			SZS->ZS_DIA22    := (aAux[it][4]*acPrds[i][26]) / nAprov
			SZS->ZS_DIA23    := (aAux[it][4]*acPrds[i][27]) / nAprov
			SZS->ZS_DIA24    := (aAux[it][4]*acPrds[i][28]) / nAprov
			SZS->ZS_DIA25    := (aAux[it][4]*acPrds[i][29]) / nAprov
			SZS->ZS_DIA26    := (aAux[it][4]*acPrds[i][30]) / nAprov
			SZS->ZS_DIA27    := (aAux[it][4]*acPrds[i][31]) / nAprov
			SZS->ZS_DIA28    := (aAux[it][4]*acPrds[i][32]) / nAprov
			SZS->ZS_DIA29    := (aAux[it][4]*acPrds[i][33]) / nAprov
			SZS->ZS_DIA30    := (aAux[it][4]*acPrds[i][34]) / nAprov
			SZS->ZS_DIA31    := (aAux[it][4]*acPrds[i][35]) / nAprov
			SZS->ZS_TOTMES   := 0
			MsUnLock("SZS")
		 	incProc("Aguarde...gerando CM32...")
 	next it
next i

return


////////////////////////////////////////////////////////////////////////////////////////////////////////
//Visualizar release calculando necessidade...
Static Function VRelease(acPrds)
Private obrPrs
Private cPr
private acRelea := {}


SetPrvt("oDlgReleas","oGrp1","oBrwReleas","oBtnCSV")

oDlgReleas := MSDialog():New( 105,231,583,1235,"Release...",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 004,004,208,492,"Release...",oDlgReleas,CLR_BLACK,CLR_WHITE,.T.,.F. )
//oBrwReleas := MsSelect():New( "SZS","","",{{"","","",""}},.F.,,{016,008,204,488},,, oGrp1 ) 
oBtnCSV    := TButton():New( 212,424,"Exportar para CSV",oDlgReleas,{|| ExpCSV(acRelea)},060,012,,,,.T.,,"",,,,.F. )

@ 016,008 LISTBOX obrPrs VAR cProd1 Fields HEADER "Ano|Mes","TIPO","Codigo","Descricao","Dia01","Dia02","Dia03","Di04","Dia05","Dia06","Dia07", "Dia08", "Dia09", "Dia10", "Dia11", "Dia12", "Dia13", "Dia14", "Dia15", "Dia16", "Dia17", "Dia18", "Dia19", "Dia20", "Dia21", "Dia22", "Dia23", "Dia24", "Dia25", "Dia26", "Dia27", "Dia28", "Dia29", "Dia30", "Dia31", "Aprov.Padrao" ON CHANGE CalcRelease(acPrds) SIZE 470, 180  pixel // ON CHANGE CHNG() ON DBLCLICK Ad_PrLst()
//Para evitar valor zerado...      
acRelea := acPrds
if len(acRelea) == 0
	AADD(acRelea, {"ANO|MES|VERSAO", "TIPO DE PRODUTO", "CODIGO", "DESCRICAO DO PRODUTO", "Dia01","Dia02","Dia03","Di04","Dia05","Dia06","Dia07", "Dia08", "Dia09", "Dia10", "Dia11", "Dia12", "Dia13", "Dia14", "Dia15", "Dia16", "Dia17", "Dia18", "Dia19", "Dia20", "Dia21", "Dia22", "Dia23", "Dia24", "Dia25", "Dia26", "Dia27", "Dia28", "Dia29", "Dia30", "Dia31", "%APROVEITAMENTO",0} )
endif
obrPrs:SetArray(acRelea)
obrPrs:bLine := { || { acRelea[obrPrs:nAt,1],acRelea[obrPrs:nAt,2],acRelea[obrPrs:nAt,3],acRelea[obrPrs:nAt,4], acRelea[obrPrs:nAt,5], acRelea[obrPrs:nAt,6], acRelea[obrPrs:nAt,7], acRelea[obrPrs:nAt,8], acRelea[obrPrs:nAt,9],; 
						 acRelea[obrPrs:nAt,10], acRelea[obrPrs:nAt,11],acRelea[obrPrs:nAt,12], acRelea[obrPrs:nAt,13],acRelea[obrPrs:nAt,14], acRelea[obrPrs:nAt,15], acRelea[obrPrs:nAt,16], acRelea[obrPrs:nAt,17], acRelea[obrPrs:nAt,18], acRelea[obrPrs:nAt,19],;
						 acRelea[obrPrs:nAt,20], acRelea[obrPrs:nAt,21], acRelea[obrPrs:nAt,22], acRelea[obrPrs:nAt,23], acRelea[obrPrs:nAt,24], acRelea[obrPrs:nAt,25], acRelea[obrPrs:nAt,26], acRelea[obrPrs:nAt,27], acRelea[obrPrs:nAt,28], acRelea[obrPrs:nAt,29], acRelea[obrPrs:nAt,30], acRelea[obrPrs:nAt,31]}  }




oDlgReleas:Activate(,,,.T.)


//Funcao para calcular os materiais necessários no release
static function CalcRelease(acPrds)
local cQuery    := ""
local cQZ3      := ""
local nPos      := 1
local cPrd3     := GetMV ('MA_RELE3')
local dUlMes		:= GetMV ('MV_ULMES')
Private AcRelea := {}
Private aAux		:= {}
Private lMsErroAuto := .F.
Private nRat		:= 0

cQuery := " SELECT ZS_PRODACA+ZS_TIPO+ZS_PRODUTO CHAVE, ZS_FILIAL, ZS_ANO, ZS_MES, ZS_VERSAO, ZS_QTDPPLN, ZS_PRODUTO, ZS_TIPO, "
cQuery += " ZS_DIA01, ZS_DIA02, ZS_DIA03, ZS_DIA04, ZS_DIA05, ZS_DIA06, ZS_DIA07, ZS_DIA08, ZS_DIA09, ZS_DIA10, ZS_DIA11, "
cQuery += " ZS_DIA12, ZS_DIA13, ZS_DIA14, ZS_DIA15, ZS_DIA16, ZS_DIA17, ZS_DIA18, ZS_DIA19, ZS_DIA20, ZS_DIA21, ZS_DIA22, "
cQuery += " ZS_DIA23, ZS_DIA24, ZS_DIA25, ZS_DIA26, ZS_DIA27, ZS_DIA28, ZS_DIA29, ZS_DIA30, ZS_DIA31,  ZS_PLNGERA, ZS_PLANO, ZS_RELEASE, ZS_OBSERV, R_E_C_N_O_ nReg "
cQuery += " FROM "+RetSqlName("SZS")+" SZS WHERE D_E_L_E_T_ = ' ' and ZS_FILIAL = '"+xFilial("SZS")+"' "
cQuery += " AND ZS_ANO = '"+nCBoxAno+"' AND ZS_MES = '"+Substr(nCBoxMes,1,2)+"' AND ZS_VERSAO = '"+nCBoxVersa+"' "
cQuery += " AND ZS_RELEASE = '"+cGetReleas+"' " 
cQuery += " ORDER BY 1, 2, 7 "

Memowrite("C:\TEMP\CAD_RELEA_CONSUMO.TXT", cQuery)

if Select("TMPZS1")  > 0 
	dbSelectArea("TMPZS1")
	TMPZS1->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", TcGenQry(, , cQuery), "TMPZS1", .T., .T.)


nCount := 0
dbSelectArea("TMPZS1")
TMPZS1->(dbGotop())
while !TMPZS1->(eof())
  	//AADD(acRelea, {"ANO|MES|VERSAO",                        "TIPO DE PRODUTO",                                 "CODIGO",  "             DESCRICAO DO PRODUTO",                                                      "Dia01",    "Dia02","Dia03","Di04","Dia05","Dia06","Dia07", "Dia08", "Dia09", "Dia10", "Dia11", "Dia12", "Dia13", "Dia14", "Dia15", "Dia16", "Dia17", "Dia18", "Dia19", "Dia20", "Dia21", "Dia22", "Dia23", "Dia24", "Dia25", "Dia26", "Dia27", "Dia28", "Dia29", "Dia30", "Dia31", "%APROVEITAMENTO",0} )
	aadd(acRelea, {TMPZS1->(ZS_ANO+"|"+ZS_MES+"|"+ZS_VERSAO), iif(TMPZS1->ZS_TIPO == "M", "MATERIAL", "ACABADO"), TMPZS1->ZS_PRODUTO, ALLTRIM(Posicione("SB1",1, xFilial("SB1")+TMPZS1->ZS_PRODUTO,"B1_DESC")), TMPZS1->ZS_DIA01, TMPZS1->ZS_DIA02, TMPZS1->ZS_DIA03, TMPZS1->ZS_DIA04, TMPZS1->ZS_DIA05, TMPZS1->ZS_DIA06, TMPZS1->ZS_DIA07, TMPZS1->ZS_DIA08, TMPZS1->ZS_DIA09, TMPZS1->ZS_DIA10, TMPZS1->ZS_DIA11, TMPZS1->ZS_DIA12, TMPZS1->ZS_DIA13, TMPZS1->ZS_DIA14, TMPZS1->ZS_DIA15, TMPZS1->ZS_DIA16, TMPZS1->ZS_DIA17, TMPZS1->ZS_DIA18, TMPZS1->ZS_DIA19, TMPZS1->ZS_DIA20, TMPZS1->ZS_DIA21, TMPZS1->ZS_DIA22, TMPZS1->ZS_DIA23, TMPZS1->ZS_DIA24, TMPZS1->ZS_DIA25, TMPZS1->ZS_DIA26, TMPZS1->ZS_DIA27, TMPZS1->ZS_DIA28, TMPZS1->ZS_DIA29, TMPZS1->ZS_DIA30, TMPZS1->ZS_DIA31, 0, 0})
	nCount++
	TMPZS1->(dbSkip())
enddo
//Alert("Adicionado "+cValToChar(nCount))
/*
procregua(0)
for i:= 2 to len(acPrds)                  
	///								01								   02          03             04          05             06            07              08             09           10               11     12
	aadd(acRelea, {acPrds[i][1]+"|"+acPrds[i][2]+"|"+acPrds[i][3], "ACABADO", acPrds[i][3], acPrds[i][4], acPrds[i][5], acPrds[i][6], acPrds[i][7], acPrds[i][8], acPrds[i][9], acPrds[i][10], acPrds[i][11], acPrds[i][12], 0 })
    
//    Alert("BUSCANDO...> "+acPrds[i][3])
    aAux := u_buscacp(acPrds[i][3], nPos)
//    Alert("Tamanho array -> "+cValToChar(len(aAux))+"MV_ULMES: "+Substr(dTos(dUlMes),1,6))
	for it := 1 to len(aAux)
		cQZ3 := " Select Z3_MATERIA, SUM(Z3_M2TOT) IDEAL, SUM(Z3_SLDM2) VLRREAL from SZ3010 SZ3, SB1010 SB1 " 
		cQZ3 += " where SZ3.D_E_L_E_T_ =' '  and SB1.D_E_L_E_T_ = ' ' and B1_FILIAL = '"+xFilial("SB1")+"' and Z3_FILIAL ='"+xFilial("SZ3")+"' "
		cQZ3 += " and Z3_MATERIA = '"+aAux[it][1]+"' AND Z3_MATERIA = B1_COD " //and B1_GRUPO not in ('45') "
		cQZ3 += " and Substring(Z3_DTFICHA,1,6) ='"+Substr(dTos(dUlMes),1,6)+"' " 
		cQZ3 += " group by Z3_MATERIA "
		memowrite("C:\TEMP\QRY_APROVEITAMENTO.TXT", cQZ3)
			if Select("TMPZ3") > 0 
				dbSelectArea("TMPZ3")
				TMPZ3->(dbCloseArea())
			endif
			dbUseArea(.T., "TOPCONN", TcGenQry(, , cQZ3), "TMPZ3", .T., .T.)
			dbSelectArea("TMPZ3")
			TMPZ3->(dbGotop())
			nAprov := TMPZ3->IDEAL / TMPZ3->VLRREAL
			if nAprov == 0 
				nAprov := 1
			endif
//			"Ano|Mes|Semana","TIPO","Codigo","Descricao","Dom","Seg","Ter","Qua","Qui","Sex","Sab", "Aprov.Padrao"

	///								01								          02          03             04           05        06 07 08 09 10 11     12
//			aadd(acRelea, {acPrds[i][1]+"|"+acPrds[i][2]+"|"+acPrds[i][3], "MATERIAL", TMPG1->COMP2, TMPG1->DESC2, (TMPG1->QTDE2*acPrds[i][6] / nAprov, (TMPG1->QTDE2*acPrds[i][7]), (TMPG1->QTDE2*acPrds[i][7]), (TMPG1->QTDE2*acPrds[i][8]), (TMPG1->QTDE2*acPrds[i][9]), (TMPG1->QTDE2*acPrds[i][10]), 0, nAprov})
//			if acPrds[i][4] == aAux[it][1]
				aadd(acRelea, {acPrds[i][1]+"|"+acPrds[i][2]+"|"+acPrds[i][3], "MATERIAL", aAux[it][1], ALLTRIM(Posicione("SB1",1, xFilial("SB1")+aAux[it][1],"B1_DESC"))+" - "+aAux[it][6], (aAux[it][4]*acPrds[i][6]) / nAprov, (aAux[it][4]*acPrds[i][7]) / nAprov, (aAux[it][4]*acPrds[i][8]) / nAprov, (aAux[it][4]*acPrds[i][9]) / nAprov, (aAux[it][4]*acPrds[i][10]) / nAprov, (aAux[it][4]*acPrds[i][11]) / nAprov, (aAux[it][4]*acPrds[i][12]) / nAprov, nAprov})
//			endif
		 	nPos := aAux[it][7]
 	next it
next i
*/
return


return




//////////////////////////////////////////////////////////////////////////////////////////////
static function ExpCSV(acRelea)

//Exclusivo para gerar Excel...
Private aConteud:= acRelea
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab := ""

if APMsgNoYes("Deseja Gerar para Excel", "Gerar Excel")
	aDir := MDirArq()

		If Empty(aDir[1]) .OR. Empty(aDir[2])
		Return
	Else                      
//		AjustaSx1()
//		If ! Pergunte(cPerg,.T.)
//			Return
//		Endif


//		U_GeraArqExcel()
		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif
else

	Alert("Rotina cancelada...")

endif



Return 



//////////////////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------------//
//|Funcao....: MDirArq
//|Descricao.: Define Diretório e nome do arquivo a ser gerado
//|Retorno...: aRet[1] = Diretório de gravação
//|            aRet[2] = Nome do arquivo a ser gerado
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MDirArq()
*-----------------------------------------*
Local aRet := {"",""}
Private bFileFat:={|| cDir:=UZXChoseDir(),If(Empty(cDir),cDir:=Space(250),Nil)}
Private cArq    := Space(10)
Private cDir    := Space(250)
Private oDlgDir := Nil
Private cPath   := "Selecione diretório"
Private aArea   := GetArea()
Private lRetor  := .T.
Private lSair   := .F.

//+-----------------------------------------------------------------------------------//
//| Definição da janela e seus conteúdos
//+-----------------------------------------------------------------------------------//
While .T.
	DEFINE MSDIALOG oDlgDir TITLE "Definição de Arquivo e Diretório" FROM 0,0 TO 175,368 OF oDlgDir PIXEL
	
	@ 06,06 TO 65,180 LABEL "Dados do arquivo" OF oDlgDir PIXEL
	
	@ 15, 10 SAY   "Nome do Arquivo"  SIZE 45,7 PIXEL OF oDlgDir
	@ 25, 10 MSGET cArq               SIZE 50,8 PIXEL OF oDlgDir
	
	@ 40, 10 SAY "Diretorio de gravação"  SIZE  65, 7 PIXEL OF oDlgDir
	@ 50, 10 MSGET cDir PICTURE "@!"      SIZE 150, 8 WHEN .F. PIXEL OF oDlgDir
	@ 50,162 BUTTON "..."                 SIZE  13,10 PIXEL OF oDlgDir ACTION Eval(bFileFat)
	
	DEFINE SBUTTON FROM 70,10 TYPE 1  OF oDlgDir ACTION (UZXValRel("ok")) ENABLE
	DEFINE SBUTTON FROM 70,50 TYPE 2  OF oDlgDir ACTION (UZXValRel("cancel")) ENABLE
	
	ACTIVATE MSDIALOG oDlgDir CENTER
	
	If lRetor
		Exit
	Else
		Loop
	EndIf
EndDo

If lSair
	Return(aRet)
EndIf

aRet := {cDir,cArq}

Return(aRet)

*-----------------------------------------*
Static Function UZXChoseDir()
*-----------------------------------------*
Local cTitle:= "Geração de arquivo"
Local cMask := "Formato *|*.*"
Local cFile := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions:= GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY

cFile:= cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,.F., nOptions)

Return(cFile)


//+-----------------------------------------------------------------------------------//
//|Funcao....: UZXValRel()
//|Descricao.: Valida informações de gravação
//|Uso.......: U_UZXDIRARQ
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function UZXValRel(cValida)
*-----------------------------------------*

Local lCancela

If cValida = "ok"
	If Empty(Alltrim(cArq))
		MsgInfo("O nome do arquivo deve ser informado","Atenção")
		lRetor := .F.
	ElseIf Empty(Alltrim(cDir))
		MsgInfo("O diretório deve ser informado","Atenção")
		lRetor := .F.
		//	ElseIf Len(Alltrim(cDir)) <= 3
		//		MsgInfo("Não se pode gravar o arquivo no diretório raiz, por favor, escolha um subdiretório.","Atenção")
		//		lRetor := .F.
	Else
		oDlgDir:End()
		lRetor := .T.
	EndIf
Else
	lCancela := MsgYesNo("Deseja cancelar a geração do Relatório / Documento?","Atenção")
	If lCancela
		oDlgDir:End()
		lRetor := .T.
		lSair  := .T.
	Else
		lRetor := .F.
	EndIf
EndIf

Return(lRetor)


//+-----------------------------------------------------------------------------------//
//|Funcao....: MCSV
//|Descricao.: Gera Arvquivo do tipo csv
//|Retorno...: .T. ou .F.
//|Observação:
//+-----------------------------------------------------------------------------------//

*-------------------------------------------------*
Static Function MCVS(axVet,cxCab,cxArqTxt,PICTUSE)
*-------------------------------------------------*

Local cEOL       := CHR(13)+CHR(10)
Local nTamLin    := 2
Local cLin       := Space(nTamLin)+cEOL
Local cDadosCSV  := ""
Local lRet       := .T.
Local nHdl,nt,jk       := 0

If Len(axVet) == 0
	MsgInfo("Dados não informados","Sem dados")
	lRet := .F.
	Return(lRet)
ElseIf Empty(cxArqTxt)
	MsgInfo("Diretório e nome do arquivo não informados corretamente","Diretório ou Arquivo")
	lRet := .F.
	Return(lRet)
EndIf

cxArqTxt := cxArqTxt+".csv"
nHdl := fCreate(cxArqTxt)

If nHdl == -1
	MsgAlert("O arquivo de nome "+cxArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

nTamLin := 2
cLin    := Space(nTamLin)+cEOL

ProcRegua(Len(axVet))

If !Empty(cxCab)
	cLin := Stuff(cLin,01,02,cxCab)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no Cabeçalho. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		Endif
	Endif
EndIf
For jk := 1 to Len(axVet)
	nTamLin   := 2
	cLin      := Space(nTamLin)+cEOL
	cDadosCSV := ""
	IncProc("Gerando arquivo CSV")
	For nt := 1 to Len(axVet[jk])
		If ValType(axVet[jk,nt]) == "C"
			cDadosCSV += axVet[jk,nt]+Iif(nt = Len(axVet[jk]),"",";")
		ElseIf ValType(axVet[jk,nt]) == "N"
			cDadosCSV += Transform(axVet[jk,nt],PICTUSE)+Iif(nt = Len(axVet[jk]),"",";")
		ElseIf ValType(axVet[jk,nt]) == "U"
			cDadosCSV += +Iif(nt = Len(axVet[jk]),"",";")
		Else
			cDadosCSV += axVet[jk,nt]+Iif(nt = Len(axVet[jk]),"",";")
		EndIf
	Next
	cLin := Stuff(cLin,01,02,cDadosCSV)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo nos Itens. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		Endif
	Endif
Next
fClose(nHdl)
Return(lOk)

//+-----------------------------------------------------------------------------------//
//|Funcao....: MExcel
//|Descricao.: Abre arquivo csv em excel
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MExcel(cxDir,cxArq)
*-----------------------------------------*
Local cArqTxt := cxDir+cxArq+".csv"
Local cMsg    := "Relatorio gerado com sucesso!"+CHR(13)+CHR(10)+"O arquivo "+cxArq+".csv"
cMsg    += " se encontra no diretório "+cxDir

MsgInfo(cMsg,"Atenção")

If MsgYesNo("Deseja Abrir o arquivo em Excel?","Atenção")
	If ! ApOleClient( 'MsExcel' )
		MsgStop(" MsExcel nao instalado ")
		Return
	EndIf
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cArqTxt)
	oExcelApp:SetVisible(.T.)
EndIf

Return



///////////////////////////////////////////////////////////////////////////////////////////////////////
//Função para buscar os materiais utilizados na estrutura...
user function buscacp(cComp, nPos)
local aAux 		:= {}
local cCompAux 	:= cComp
Private nEstru	:= 0
if select("ESTMP") > 0 
	dbSelectArea("ESTMP")
	ESTMP->(dbCloseArea())
endif 
//dbSelectArea("ESTRUT")
//cProduto	Caracter	Código do Produto a ser pesquisado.	X	
//nQuantidade	Numérico	Quantidade a ser explodida.	X	
//cAliasTRB	Caracter	Alias do Arquivo de Trabalho a ser criado (Default=ESTRUT).	X	
//cArquivoTRB	Caracter	Nome do Arquivo de Trabalho a ser criado (pode ser Nil).		
//lAsShow	Lógico	Monta a estrutura exatamente como visualizado na tela (pode ser Nil).		
//lPreEstru	Lógico	Determina se será considerada uma pré-estrutura (SGG) em vez de uma estrutura (SG1) (pode ser Nil).	

//Alert("Posicao...."+cValToChar(nPos))
cArqNome :=	ESTRUT2( cComp, 1, "ESTMP", "TMP", .T., .F. )
	dbSelectArea("ESTMP")
	ESTMP->(dbGotop())
	procregua(0)
	nCount := 0
	While !ESTMP->(EoF())
		nCount++
			if Alltrim(Posicione("SB1", 1, xFilial("SB1")+ESTMP->COMP, "B1_GRUPO")) $ '40|40A'
				nPosCod    :=	aScan(aAux,{|x|x[1]==ESTMP->COMP })
				if nPosCod == 0 
					// 				01									02															03										04				04				
			        AAdd(aAux,{ESTMP->COMP, ALLTRIM(Posicione("SB1", 1, xFilial("SB1")+ESTMP->COMP, "B1_DESC")), Posicione("SB1", 1, xFilial("SB1")+ESTMP->COMP, "B1_GRUPO"), ESTMP->QUANT, "'"+ESTMP->NIVEL, cCompAux, ESTMP->COMP } )
			 	else
			 		aAux[nPosCod][4] := aAux[nPosCod][4] + ESTMP->QUANT
			 		nQtde := aAux[nPosCod][5]
			 	endif
		    endif
		ESTMP->(dbSkip())
			incProc("Gerando arquivo temporário....")
	EndDo
//	Alert("TOTAL DE REGISTROS LIDOS -> "+cValToChar(nCount))
//	ExpCSV(aAux)
//	if len(aAux) > 0
//		aAux[len(aAux)][7] := nCount
//	endif
return aAux
