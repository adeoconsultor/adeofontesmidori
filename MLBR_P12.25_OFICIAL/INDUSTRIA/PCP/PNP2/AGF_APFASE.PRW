#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
Esta rotina tem como objetivo apontar as fichas de corte de acordo com a fase atual destas.
*/
 
User Function AGF_APFICFASE()   

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private nOpc 				:= GD_INSERT+GD_DELETE+GD_UPDATE
Private nOpcFacas			:= GD_UPDATE
Private nOpcFasesFacas		:= GD_UPDATE
Private aCoBrFacas 			:= {}
Private aCoBrFasesFaca 		:= {}
Private aCoBrLotes 			:= {}
Private aHoBrFacas			:= {}
Private aHoBrFasesFaca 		:= {}
Private aHoBrLotes 			:= {}
Private cGDPrFicha 			:= Space(1)
Private cGdPrPl    			:= Space(1)
Private cGdtApont  			:= dDataBase
Private cGEmissao  			:= Space(1)
Private cGetPrFich 			:= Space(1)
Private cGFaseAtu  			:= Space(1)
Private cGFicha    			:= Space(20)
Private cGIniFic   			:= CTOD('  /  /  ')
Private cGnRecurso 			:= Space(30)
Private cGOpProt   			:= Space(20)
Private cOPSD4				:= Space(13)
Private cgPlano    			:= Space(20)
Private cGprPl     			:= Space(15)
Private cGQtFic     		:= 0
Private cGQtPrpl   			:= 0
Private cGRecurso  			:= Space(6)
Private cGStatusFi 			:= Space(30)
Private cGUmFic       		:= Space(3)
Private cGUmPrPl   			:= Space(3)
Private cGCliente 			:= Space(50)
Private cSayFicha  			:= Space(1)
Private noBrFacas  			:= 0
Private noBrFasesFaca  		:= 0
Private noBrLotes  			:= 0
Private cGFimFic 			:= CTOD('  /  /  ')
Private cGQtdFic 			:= 0
Private cGQtmFic 			:= 0
Private aFases              := {}
Private cFaseAtu            := '' // Flag indicando qual a fase atual
Private lFinaliza           := .F. // flag que indica se a finalizacao esta ativada nesse momento
Private lConsulta           := .T.
Private nMtTot				:= 0
Private nMtPad				:= 0
Private cLoteFic            := space(30)
Private cNumLinha           := space(06)
Private lF9                 := .F.
Private cOrdFic             := ''
Private __n_Lin             := 034            //nLinha da tela de leitura dos QRCode (Antonio)
Private __n_Col             := 0
Private noBrw1  := 0
Private aCoBrw1 := {}
Private aHoBrw1 := {}
Private nXXOpc		:= GD_INSERT+GD_DELETE+GD_UPDATE
Private nxOpc     := 0


SetKey(VK_F9, { || LigaF9() } )

SetKey(VK_F8, { || LigaF8() } )             //antonio Leitura cod barras (QRCOD)

// SetKey(VK_F8, { || Vrf_APPA( .T. )  } )

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFontTitulo","oFontLabel","oDlgApont","oGrpMain","oSayFicha","oSay2","oSay3","oSay4","oSay5")
SetPrvt("oSay7","oSay8","oSay9","oSay13","oSay15","oSay19","oSay22","oSay23","oSay24","oGFicha","ogPlano")
SetPrvt("OGCliente","oGOpProt","oGQtFic","oGUmFic","oGDPrFicha","oGetPrFicha","oGQtdMFic","oGQtPl","oGQtPrpl")
SetPrvt("oGdPrPl","oGprPl","oGrpItens","oSay14","oSay16","oSay17","oSay18","oBrFasesFaca","oBrFacas")
SetPrvt("oGFaseAtu","oGRecurso","oGnRecurso","oGdtApont","oGrp2","oSay10","oSay11","oSay12","oSay13","oGIniFic", "ogMtTot", "ogMtTPad")
SetPrvt("oGStatusFic","oGrpRoda","oBtnAct",	"ObtPa", "oBtnOk","oBtnCanc","oBtnCalc")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFontTitul 	:= TFont():New( "Arial",0,-12,,.F.,0,,400,.F.,.F.,,,,,, )
oFontLabel 	:= TFont():New( "Arial",0,-12,,.F.,0,,400,.F.,.F.,,,,,, )
oFontAbert 	:= TFont():New( "Arial",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oFontFecha 	:= TFont():New( "Arial",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oFontSub    := TFont():New('Courier new',,-16,.T.)

//
oDlgApont  							:= MSDialog():New( 138,316,679,1104,"Apontamento de Ficha de Corte",,,.F.,,,,,,.T.,,,.T. )
oGrpMain   							:= TGroup():New( 000,001,065,390,"",oDlgApont,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayFicha  							:= TSay():New( 004,005,{||"Ficha"},oGrpMain,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,017,008)
oSay2      							:= TSay():New( 004,077,{||"Plano"},oGrpMain,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,019,008)
oSay3      							:= TSay():New( 004,157,{||"Emissão"},oGrpMain,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,030,008)
oSay4      							:= TSay():New( 004,205,{||"Cliente"},oGrpMain,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,072,008)
oSay5      							:= TSay():New( 004,119,{||"OP Interna"},oGrpMain,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,033,008)
oSay6      							:= TSay():New( 044,344,{||"M2 Ficha"},oGrpMain,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,033,008)
oSay8      							:= TSay():New( 044,077,{||"Descrição do Material"},oGrpMain,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,077,008)
oSay9      							:= TSay():New( 044,005,{||"Material da Ficha"},oGrpMain,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,064,008)
//oSay7      						:= TSay():New( 044,248,{||"U.M."},oGrpMain,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,014,008)
oSay7      							:= TSay():New( 044,275,{||"U.M."},oGrpMain,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,014,008)
//oSay13     						:= TSay():New( 044,275,{||"Pçs Ficha"},oGrpMain,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,029,008)
oSay15     							:= TSay():New( 044,309,{||"Pçs Ficha"},oGrpMain,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay19     							:= TSay():New( 024,343,{||"Quantidade  OP"},oGrpMain,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,046,008)
oSay22     							:= TSay():New( 024,322,{||"U.M."},oGrpMain,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,014,008)
oSay23     							:= TSay():New( 024,077,{||"Descrição do Produto do Plano"},oGrpMain,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,172,008)
oSay24     							:= TSay():New( 024,005,{||"Produto do Plano"},oGrpMain,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,064,008)
//
oGFicha    							:= TGet():New( 013,005,{|u| If(PCount()>0,cGFicha:=u,cGFicha)},oGrpMain,065,009,'',{|| Vld_Fic()},CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZ3","cGFicha",,)
ogPlano    							:= TGet():New( 013,077,{|u| If(PCount()>0,cgPlano:=u,cgPlano)},oGrpMain,037,009,'',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cgPlano",,)
oGOpProt   							:= TGet():New( 013,119,{|u| If(PCount()>0,cGOpProt:=u,cGOpProt)},oGrpMain,033,009,'',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGOpProt",,)
oGEmissao  							:= TGet():New( 013,157,{|u| If(PCount()>0,cGEmissao:=u,cGEmissao)},oGrpMain,036,009,'',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGEmissao",,)
OGCliente  							:= TGet():New( 013,205,{|u| If(PCount()>0,cGCliente:=u,cGCliente)},oGrpMain,182,009,'',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGCliente",,)
//
oGprPl     							:= TGet():New( 033,005,{|u| If(PCount()>0,cGprPl:=u,cGprPl)},oGrpMain,065,009,'',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGprPl",,)
oGdPrPl    							:= TGet():New( 033,077,{|u| If(PCount()>0,cGdPrPl:=u,cGdPrPl)},oGrpMain,240,009,'',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGdPrPl",,)
oGUmPrPl   							:= TGet():New( 033,322,{|u| If(PCount()>0,cGUmPrPl:=u,cGUmPrPl)},oGrpMain,018,009,'@!',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGUmPrPl",,)
oGQtPrpl   							:= TGet():New( 033,344,{|u| If(PCount()>0,cGQtPrpl:=u,cGQtPrpl)},oGrpMain,043,009,'@E 99,999,999',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGQtPrpl",,)
//
oGetPrFich 							:= TGet():New( 053,005,{|u| If(PCount()>0,cGetPrFicha:=u,cGetPrFicha)},oGrpMain,065,009,'',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGetPrFicha",,)
oGDPrFicha 							:= TGet():New( 053,077,{|u| If(PCount()>0,cGDPrFicha:=u,cGDPrFicha)},oGrpMain,189,009,'',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGDPrFicha",,)
oGUmFic       						:= TGet():New( 053,275,{|u| If(PCount()>0,cGUmFic:=u,cGUmFic)},oGrpMain,023,009,'@!',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGUmFic",,)
//
// oGQtdFic  						:= TGet():New( 053,275,{|u| If(PCount()>0,cGQtdFic:=u,cGQtdFic)},oGrpMain,030,009,'@e 99,999,999.9999',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGQtdFic",,)
oGQtfIC     						:= TGet():New( 053,309,{|u| If(PCount()>0,cGQtFic:=u,cGQtFic)},oGrpMain,031,009,'@E 99,999,999',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGQtFic",,)
oGQtmFic    						:= TGet():New( 053,344,{|u| If(PCount()>0,cGQtmFic:=u,cGQtmFic)},oGrpMain,042,009,'@e 99,999,999.9999',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGQtmFic",,)
//
//
oGrpItens  							:= TGroup():New( 065,001,238,390,"",oDlgApont,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay14     							:= TSay():New( 070,005,{||"FASE ATUAL"},oGrpItens,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,037,008)
oSay16     							:= TSay():New( 070,141,{||"Recurso"},oGrpItens,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,026,008)
oSay17     							:= TSay():New( 070,181,{||"Nome"},oGrpItens,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,026,008)
oSay18     							:= TSay():New( 070,339,{||"Dt. Apontamento"},oGrpItens,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,049,008)
//
oGFaseAtu  							:= TGet():New( 078,005,{|u| If(PCount()>0,cGFaseAtu:=u,cGFaseAtu)},oGrpItens,127,009,'',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGFaseAtu",,)
oGFaseAtu:SetColor(  CLR_HBLUE  , CLR_YELLOW )
//
oGRecurso  							:= TGet():New( 078,141,{|u| If(PCount()>0,cGRecurso:=u,cGRecurso)},oGrpItens,037,009,'',{|| VldRecurso()},CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SH1","cGRecurso",,)
oGnRecurso 							:= TGet():New( 078,181,{|u| If(PCount()>0,cGnRecurso:=u,cGnRecurso)},oGrpItens,153,009,'',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGnRecurso",,)
oGdtApont  							:= TGet():New( 078,339,{|u| If(PCount()>0,cGdtApont:=u,cGdtApont)},oGrpItens,046,009,'@r 99/99/9999',{|| ! empty( cGdtApont ) .and. VldtApon()},CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGdtApont",,)
//
//MHoBrLotes()
//MCoBrLotes()
//oBrLotes   := MsNewGetDados():New(093,004,236,127,nOpc,'lLinhaok','lTudok','',{"Z3_M2PAD"},0,9999,'AllwaysTrue()','','AllwaysTrue()',oGrpItens,aHoBrLotes,aCoBrLotes )
//
MHoBrFacas()
MCoBrFacas()
//oBrFacas   := MsNewGetDados():New(093,004,175,387 ,nOpcFacas , 'U_LLINFACAOK','lTudok','',{"Z7_QTAPON", "Z3_M2TOT"},0,9999,'AllwaysTrue()','','AllwaysTrue()',oGrpItens,aHoBrFacas,aCoBrFacas )
oBrFacas   := MsNewGetDados():New(093,004,155,387 ,nOpcFacas , 'U__LINFACAOK','lTudok','',{"Z7_QTAPON", "Z3_M2TOT"},0,9999,'AllwaysTrue()','','AllwaysTrue()',oGrpItens,aHoBrFacas,aCoBrFacas )
//
oSLotFic    := TSay():New( 163,10,{||"Lote Ficha"},oGrpItens,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,049,008)
//ogLote      := TGet():New( 160,40,{|u| If(PCount()>0,cLoteFic:=u,cLoteFic)},oGrpItens,046,009,'@!',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cLoteFic",,)
ogLote      := TGet():New( 160,40,{|u| If(PCount()>0,cLoteFic:=u,cLoteFic)},oGrpItens,063,009,'@!',{|| VldLote()},CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cLoteFic",,)
//
oSLinha    := TSay():New( 163,110,{||"Linha"},oGrpItens,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,049,008)
ognLin     := TGet():New( 160,130 ,{|u| If(PCount()>0,cNumLinha:=u,cNumLinha)},oGrpItens,026,009,'@!',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNumLinha",,)
//
oSaTot     := TSay():New( 163,170,{||"Total M2 Padrão"},oGrpItens,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,049,008)
ogMtTPad   := TGet():New( 160,220,{|u| If(PCount()>0,nMtPad:=u,nMtPad)},oGrpItens,046,009,'@E 99,999.9999',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMtPad",,)
ogMtTPad:Disable()
//
oSaTotlct  := TSay():New( 163,280,{||"Total M2 Lançado"},oGrpItens,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,049,008)
ogMtTot    := TGet():New( 160,330,{|u| If(PCount()>0,nMtTot:=u,nMtTot)},oGrpItens,046,009,'@E 99,999.9999',{|| Vld_Totlctm()},CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMtTot",,)
//
// oBrFacas:oBrowse:bChange := {|| MudalFaca(),.T. }

//
MHoBrFasesFaca()
MCoBrFasesFaca()
oBrFasesFa := MsNewGetDados():New(176,004,237,387,nOpcFasesFacas,,,'',{"Z3_ROGNUNES"},0,9999,'AllwaysTrue()','','AllwaysTrue()',oGrpItens,aHoBrFasesFaca,aCoBrFasesFaca )
//
oGrp2      							:= TGroup():New( 238,001,262,199,"",oDlgApont,CLR_BLACK,CLR_WHITE,.T.,.F. )
//
oSay10     							:= TSay():New( 242,004,{||"Inicio da Ficha"},oGrp2,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,045,008)
oSay11     							:= TSay():New( 241,052,{||"Encerramento"},oGrp2,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,045,008)
oSay12     							:= TSay():New( 242,100,{||"Status da Ficha"},oGrp2,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,096,008)

oSay13     							:= TSay():New( 265,320,{||"F8-Leitura QRCode TM2"},oGrp2,,oFontTitulo,.F.,.F.,.F.,.T.,CLR_GRAY     ,CLR_WHITE,096,008)

oGIniFic    						:= TGet():New( 250,003,{|u| If(PCount()>0,cGIniFic:=u,cGIniFic)},oGrp2,047,009,'@r 99/99/9999',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGIniFic",,)
oGFimFic  							:= TGet():New( 249,052,{|u| If(PCount()>0,cGFimFic:=u,cGFimFic)},oGrp2,047,009,'@r 99/99/9999',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGFimFic",,)
oGStatusFi 							:= TGet():New( 249,100,{|u| If(PCount()>0,cGStatusFic:=u,cGStatusFic)},oGrp2,097,009,'@!',,CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.T.,.F.,,"cGStatusFic",,)
//
oGrpRoda   							:= TGroup():New( 238,200,262,390,"",oDlgApont,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBtnAct    							:= TButton():New( 248,211,"Etiqueta",oGrpRoda,{|| Imp_Etiq()},029,010,,,,.T.,,"",,,,.F. )

oBtnPln    							:= TButton():New( 248,255,"St Plano",oGrpRoda,{|| U_MD_CNSTPL(  sc2->( Recno() ) , .T. ) },029,010,,,,.T.,,"",,,,.F. )
oBtnPln:Disable()
//
//oBtnTransf                          := TButton():New( 248,292,"Trf.Almox",oGrpRoda,{|| U_ATUEMP(), U_TRANSLOC(Alltrim(cgFicha)) },029,010,,,,.T.,,"",,,,.F. )
oBtnTransf                          := TButton():New( 248,292,"Trf.Almox",oGrpRoda,{|| U_ATUEMP()},029,010,,,,.T.,,"",,,,.F. )
oBtnTransf:Disable()
oBtnOk    							:= TButton():New( 248,327,"Ok",oGrpRoda,{|| OkPRoc()  },029,010,,,,.T.,,"",,,,.F. )
// oBtnOk     							:= SButton():New( 247,327,1,{|| OkPRoc() },oGrpRoda,,"", )
oBtnOk:Disable()
//
oBtnCanc   							:= SButton():New( 247,359,2,{|| CancPRoc() },oGrpRoda,,"", )

oDlgApont:Activate(,,,.T.)

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MHoBrFasesFaca() - Monta aHeader da MsNewGetDados para o Alias: SZ3
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrFasesFaca()

Local nn1

noBrFasesFaca := 0
aCpos :=  {  	{'Fase'							,'Z7_FASE'	,06,0	,'@!'					,	'AllwaysTrue()'			},;
{'Descrição'				,'B1_DESC'			,30,0		,'@!'							,	'AllwaysTrue()'			},;
{'Dt Apont.'				,'Z7_DTAPON'		,10,0		,'@r 99/99/9999'				,	'AllwaysTrue()' 		},;
{'Usuário'					,'Z7_OPERADO'		,15,0		,'@!'							,	'AllwaysTrue()'			},;
{'Qtde. Apont.'				,'Z7_QTAPON'		,7,0		,'@e 999.999'					, 	'AllwaysTrue()'  		},;
{'M2 Padrao'				,'Z3_M2PAD'			,8,4		,'@e 999.9999'					,	'AllwaysTrue()' 		},;
{'Total M2'					,'Z3_M2TOT'			,8,4		,'@e 999.9999'					, 	'AllwaysTrue()'  		}}
//
DbSelectArea("SX3")
DbSetOrder(2)
//
For nn1 := 1 to len( aCpos )
	if DbSeek( aCpos[ nn1,2 ] )
		//	If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
		noBrFasesFaca++
		
		Aadd(aHoBrFasesFaca,{Trim( aCpos[ nn1,1 ] ),;
		aCpos[ nn1,2 ],;
		aCpos[ nn1,5 ],;
		aCpos[ nn1,3 ],;
		aCpos[ nn1,4 ],;
		aCpos[ nn1,6 ],;
		"",;
		SX3->X3_TIPO,;
		"",;
		"" } )
		//
		//	EndIf
	Endif
Next
//
DbSelectArea("SX3")
DbSetOrder(1)
//
Return
//------------------------------------------------------------------
/*
A funcao abaixo tem como objetivo calcular e ratear as metragens excedentes para cad faca lancada
*/
Static Function Vld_Totlctm()
Local nIndAum:= Getmv( 'MA_MPDMLIB'  )
Local nIndRed:= Getmv( 'MA_MIPDLIB'  )
Local cLibQtd:= ""
Local i
Local nnk1
//                                                                                                                    
if nmttot < 0 
	Alert("Valor nao pode ser negativo..."+chr(13)+"Será mantido o valor padrao...")
	nmttot := nMtPad
	oBtnOk:Disable()
	oSaTotlct:SetFocus()
	Return(.T.)
endif	
                    
//Rotina com função de calcular o valor máximo que o usuario pode informar numa Ficha
if nmtTot > nMtPad * nIndAum 
	dbSelectArea("SH1")
	DbSetOrder(1)
	if SH1->( DbSeek( xFilial('SH1') + cGRecurso  )  )
		for i:= 1 to 7 
			if Substr(SH1->H1_APFASE,i,1) == '7'
				cLibQtd := 'S'
			endif
		next               
	endif
	if cLibQtd <> 'S'
		Alert("Valor máximo permitido para a ficha é de "+cValToChar(nMtPad * nIndAum)+chr(13)+chr(13)+"Contate alguem que tenha permissão para liberar qtde a maior.")
		nmttot := nMtPad
		oBtnOk:Disable()
		oSaTotlct:SetFocus()
		Return(.T.)
	else
		if !APMSGNoYes("Valor máximo permitido para a ficha é de "+cValToChar(nMtPad * nIndAum)+chr(13)+;
		 				"Confirma o lançamento da quantidade informada ? ","ATENÇÃO AO LANÇAMENTO")
			nmttot := nMtPad
			oBtnOk:Disable()
			oSaTotlct:SetFocus()
			Return(.T.)
		endif
	endif
						
endif	

//Rotina com função de calcular o valor minimo que o usuario pode informar numa Ficha 
//Alert("Metros Total: "+cValToChar(nmtTot)+" Liberando: "+cValToChar(nMtPad * nIndRed))
if nmtTot < nMtPad * nIndRed
	dbSelectArea("SH1")
	DbSetOrder(1)
	if SH1->( DbSeek( xFilial('SH1') + cGRecurso  )  )
		for i:= 1 to 7 
			if Substr(SH1->H1_APFASE,i,1) == '7'
				cLibQtd := 'S'
			endif
		next               
	endif
	if cLibQtd <> 'S'
		Alert("Valor minimo permitido para a ficha é de "+cValToChar(nMtPad * nIndRed)+chr(13)+chr(13)+"Contate alguem que tenha permissão para liberar qtde a maior.")
		nmttot := nMtPad
		oBtnOk:Disable()
		oSaTotlct:SetFocus()
		Return(.T.)
	else
		if !APMSGNoYes("Valor minimo permitido para a ficha é de "+cValToChar(nMtPad * nIndRed)+chr(13)+;
		 				"Confirma o lançamento da quantidade informada ? ","ATENÇÃO AO LANÇAMENTO")
			nmttot := nMtPad
			oBtnOk:Disable()
			oSaTotlct:SetFocus()
			Return(.T.)
		endif
	endif
endif	

if nmttot == nMtPad
	oBtnok:SetFocus()
	Return(.T.)
Endif
//
if nmttot == 0
	nmttot := nMtPad
	nDiferenca := 0
Else
	nDiferenca := nmttot - nMtPad
Endif
//
For nnk1 := 1 to len(AcoBrFacas)
	nperc1 := (( AcoBrFacas[ nnk1, 7 ] / nMtPad) * 100 )
	//
	nValAtu1 := AcoBrFacas[ nnk1, 3 ] * AcoBrFacas[ nnk1, 6 ] // apurando o total em m2 lancado
	nDif2    := ( ( nDiferenca * nperc1) / 100 )
	//
	nValAtu1 := nValAtu1 + nDif2
	AcoBrFacas[ nnk1, 7 ]  := nValAtu1
	nDiferenca -= nDif2
	//
Next
//
// Alert('To Dentro')
oBrFacas:SetArray(aCoBrFacas)
oBrFacas:oBrowse:Refresh()
oBrFacas:oBrowse:nColpos := 6
oBtnok:SetFocus()
//
Return(.T.)
//------------------------------------------------------------------
Static Function MCoBrFasesFaca()

Local aAux := {}
Local nI

Aadd(aCoBrFasesFaca,Array(noBrFasesFaca+1))
For nI := 1 To noBrFasesFaca
	aCoBrFasesFaca[1][nI] := CriaVar(aHoBrFasesFaca[nI][2])
Next
aCoBrFasesFaca[1][noBrFasesFaca+1] := .F.

Return
//-----------------------------------------------------------------------------------------
/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MHoBrFacas() - Monta aHeader da MsNewGetDados para o Alias: SZ3
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrFacas()

Local nn1
//
// aCpos :=  { 'Z3_PRODUTO', 'B1_DESC' ,'Z3_QTDE', 'Z3_M2TOT', 'Z3_M2PAD' }
aCpos :=  {  	{'Faca'						,'Z3_PRODUTO'		,10,0	,'@!'					,	'AllwaysTrue()'	},;
{'Descrição'				,'B1_DESC'			,30,0	,'@!'					,	'AllwaysTrue()'	},;
{'M2 Padrao'				,'Z3_M2PAD'			,8,4	,'@e 999.9999'	,	'AllwaysTrue()' 	},;
{'Ult Qtde.'				,'Z3_QTDE'			,9,3	,'@e 999.999'		,	'AllwaysTrue()'	},;
{'Total M2'					,'Z3_SLDM2'			,8,4	,'@e 999.9999'	, 	'AllwaysTrue()'  	},;
{'Qtde Apontada'			,'Z7_QTAPON'		,9,3	,'@e 999.999'		,	'U_VldQtAp()'},;
{'M2 Apontados'				,'Z3_M2TOT'			,8,4	,'@e 999.9999'	,	'AllwaysTrue()'	} }
//
DbSelectArea("SX3")
DbSetOrder(2)
//
For nn1 := 1 to len( aCpos )
	if DbSeek( aCpos[ nn1,2 ] )
		If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
			noBrFacas++
			
			
			Aadd(aHoBrFacas,{Trim( aCpos[ nn1,1 ] ),;
			aCpos[ nn1,2 ],;
			aCpos[ nn1,5 ],;
			aCpos[ nn1,3 ],;
			aCpos[ nn1,4 ],;
			aCpos[ nn1,6 ],;
			"",;
			SX3->X3_TIPO,;
			"",;
			"" } )
			/*
			Aadd(aHoBrFacas,{Trim(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			"",;
			"",;
			SX3->X3_TIPO,;
			"",;
			"" } )
			*/
		EndIf
	Endif
Next
//
DbSelectArea("SX3")
DbSetOrder(1)
//

Return
//-------------------------------------------------------------------------------

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MCoBrFacas() - Monta aCols da MsNewGetDados para o Alias: SZ3
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MCoBrFacas()

Local aAux := {}
Local nI

Aadd(aCoBrFacas,Array(noBrFacas+1))
For nI := 1 To noBrFacas
	aCoBrFacas[1][nI] := CriaVar(aHoBrFacas[nI][2])
Next
aCoBrFacas[1][noBrFacas+1] := .F.

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MHoBrLotes() - Monta aHeader da MsNewGetDados para o Alias: SD3
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrLotes()
Local nn1

aCpos :=  {  	{'Fase'						,'Z7_FASE'			,03,0	,'@!'					,	'AllwaysTrue()'	},;
{'Descrição'				,'B1_DESC'			,15,0	,'@!'					,	'AllwaysTrue()'	},;
{'Dt Apont.'				,'Z7_DTAPON'		,10,0	,'@r 99/99/9999'	,	'AllwaysTrue()' 	},;
{'Usuário'					,'Z7_OPERADO'		,15,0	,'@!'					,	'AllwaysTrue()'	},;
{'Qtde. Apont.'			,'Z7_QTAPON'		,7,0	,'@e 999.999'	, 	'AllwaysTrue()'  		} }
//
DbSelectArea("SX3")
DbSetOrder(2)
//
For nn1 := 1 to len( aCpos )
	DbSeek("SZ3")
	if DbSeek( aCpos[ nn1,2 ] )
		If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
			noBrFacas++
			
			
			Aadd(aHoBrFacas,{Trim( aCpos[ nn1,1 ] ),;
			aCpos[ nn1,2 ],;
			aCpos[ nn1,5 ],;
			aCpos[ nn1,3 ],;
			aCpos[ nn1,4 ],;
			aCpos[ nn1,6 ],;
			"",;
			SX3->X3_TIPO,;
			"",;
			"" } )
			/*
			Aadd(aHoBrFacas,{Trim(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			"",;
			"",;
			SX3->X3_TIPO,;
			"",;
			"" } )
			*/
		EndIf
	Endif
Next
//
DbSelectArea("SX3")
DbSetOrder(1)
//
Return()
//----------------------------------------------------------------
/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MCoBrLotes() - Monta aCols da MsNewGetDados para o Alias: SD3
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MCoBrLotes()

Local aAux := {}
Local nI
//
Aadd(aCoBrLotes,Array(noBrLotes+1))
For nI := 1 To noBrLotes
	aCoBrLotes[1][nI] := CriaVar(aHoBrLotes[nI][2])
Next
aCoBrLotes[1][noBrLotes+1] := .F.
//

Return

//-------------------------------------------------------------------------
Static Function Vld_Fic( lGrava )

dbSelectArea('SZP')
dbSetOrder(1)
dbSeek(xFilial('SZP')+iif(Substr(cGFicha,1,1)$'AB',Substr(cGFicha,2,6),Substr(cGFicha,1,6)))

dbSelectArea('SC2')
dbSetOrder(10)
dbSeek(xFilial('SC2')+SZP->ZP_OPMIDO)
while !SC2->(eof()) .and. SC2->C2_OPMIDO == SZP->ZP_OPMIDO
	if SC2->C2_TPOP <> 'F' 
		Alert('Plano nao firmado!'+chr(13)+'Por favor FIRMAR o plano antes de apontar as fichas.')
		oGFicha:SetFocus()
		return
	endif
	SC2->(dbSkip())
enddo
	

DbSelectArea('SZ3')
DbSetOrder(4)
//
if lGrava <> .T.
	lGrava := .F.
Endif
//

IF ! DbSeek( xFilial('SZ3') + Padr(cGFicha, 20 ) )
	Alert( 'Ficha de Corte Não encontrado. Por favor, corrija. ')
	//
	cgPlano			:= space( len( SZ3->Z3_PLANO 		))
	cGOpProt		:= space( len( SZ3->Z3_NUMOP 	))
	cGEmissao		:= ctod('  /  /  ')
	cGetPrFicha		:= space( len( SZ3->Z3_MATERIA	))
	cGDprFicha		:= space( len( SB1->B1_DESC		))
	cGUmFic			:= space( len( SB1->B1_UM 			))
	cGQtFic        	:= 0
	cGQtMFic 		:= 0
	cGprPl          := space( len(  SC2->C2_PRODUTO ))
	cGQtPrpl		:= 0
	cGdPrPl			:= space( len(   SB1->B1_DESC )  )
	cGUmPrPl    	:= space( len(  SB1->B1_UM ))
	cGCliente	    := space( 50 )
	cFaseaTu 		:= ''
	cNumLinha  		:= SPACE(06)
	//
	oGFicha:Refresh()
	ogPlano:Refresh()
	oGOpProt:Refresh()
	oGEmissao:Refresh()
	OGCliente:Refresh()
	//
	oGprPl:Refresh()
	oGdPrPl:Refresh()
	oGUmPrPl:Refresh()
	oGQtPrpl:Refresh()
	//
	oGetPrFich:Refresh()
	oGDPrFicha:Refresh()
	oGUmFic:Refresh()
	//
	oGQtfIC:Refresh()
	oGQtmFic:Refresh()
	//
	//
	oGrpItens:Refresh()
	oGFaseAtu:Refresh()
	oGRecurso:Refresh()
	oGnRecurso:Refresh()
	oGdtApont:Refresh()
	//
	//
	Return( .F. )
Else
	//
	u__Rt_FcLct( SZ3->Z3_NUMFC )
	//
	cgPlano			:= SZ3->Z3_PLANO
	cGOpProt			:= SZ3->Z3_NUMOP
	cOPSD4			:= Substr(SZ3->Z3_NUMOP,1,6) + SZ3->(Z3_ITEM+Z3_SEQUEN)
	cGEmissao	   := SZ3->Z3_DTFICHA
	cLoteFic       := SZ3->Z3_LOTE
	cNumLinha      := SZ3->Z3_CORTADO
	//
	// o Bloco abaixo pesquisa a OP pra chamar o produto principal
	DbSelectArea('SZP')
	DbSetORder(1)
	//
	cOrdFic := SUBSTR( cGFicha , iif( Substr( cGFicha , 1,1 ) $ 'AB', 2 , 1 )  , 6 )
	//
	if ! DbSeek( xFilial('SZP') + cOrdFic )
		Alert( 'Ordem de Produção  ' +  cOrdFic  + '01001' + '   Não Encontrada. Por favor, entre em Contato com o Administrador do Sistema.')
		oBtnPln:Disable()
		Return(.F.)
	Else
		//
		IF SZP->ZP_LIBER <> 'OK'
			Alert( 'Atencao! o Plano ' + SZP->ZP_NUM  + ' Esta BLOQUEADO para Lancamentos das Fichas de Corte.' + chr(13)+ chr(10) + ' Por favor, entre em Contato com o Administrador do Sistema.')
			oBtnPln:Disable()
			Return(.F.)
			
		ENDIF
		//
		//
		SB1->( DbSeek( xFilial('SB1' ) + SZP->ZP_PRODUTO ))
		//
		cGprPl      := SZP->ZP_PRODUTO
		cGQtPrpl		:= SZP->ZP_QUANT
		cGdPrPl		:= alltrim( SB1->B1_DESC )
		cGUmPrPl    := SB1->B1_UM
		//
		//
		SB1->( DbSetOrder(1) )
		SB1->( DbSeek( xFilial('SB1') + SZ3->Z3_MATERIA  ) )
		//
		cGetPrFicha	:= SZ3->Z3_MATERIA
		cGDprFicha	:= SB1->B1_DESC
		cGUmFic		:= SB1->B1_UM
		cGQtFic        := SZ3->Z3_QTDE
		//
		if ! TRZ_FASES( SZP->ZP_PRODUTO )
			Return( .F. )
		Endif
		//                                 ?
		NTOTFICHA := 0
		//
		aCoBrFacas := {}
		DbSelectArea('SZ3')
		While !eof() .and. Z3_FILIAL == XFILIAL('SZ3') .AND. Z3_NUMFC == Padr(cGFicha, 20 )
			//
			AAdd( aCoBrFacas,  { Z3_PRODUTO, POSICIONE( 'SB1', 1, XFILIAL('SB1') + SZ3->Z3_PRODUTO, 'B1_DESC' ),  Z3_M2PAD , Z3_QTDE, Z3_M2PAD * Z3_QTDE  ,  Z3_SALDO  , Z3_SLDM2 , .F.  } )  // Populando a array das facas
			//
			NTOTFICHA  += Z3_SLDM2
			DBSKIP()
		ENDDO
		//
		nMtPAd := NTOTFICHA
		NmtTot := NTOTFICHA
		DbSeek( xFilial('SZ3') + Padr(cGFicha, 20 ) )  // reposicionando no numero da ficha inicial
		//
		oBrFacas:SetArray(aCoBrFacas)
		oBrFacas:oBrowse:Refresh()
		oBrFacas:oBrowse:nColpos := 6
		//
		//
		// cGM2Ficha	:= NTOTFICHA
		cGQtMFic := NTOTFICHA
		//
		oBtnPln:Enable()
//		oBtnTransf:Enable()
		//
		TRZ_Aponts()
		//
		cGCliente	:= SC2->C2_CLIENTE + '/' + SC2->C2_LOJA + '-'+ POSICIONE( 'SA1',1,XFILIAL('SA1')+  SC2->C2_CLIENTE + SC2->C2_LOJA, 'A1_NOME' )
		//
		if ! lGrava
			oGRecurso:SetFocus()
		endif
		//
	Endif
	*/
	//
Endif
//
Return( .t. )
//----------------------------------------------------
Static Function CancProc()
Close(   oDlgApont )
Return()
//----------------------------------------------------
Static Function VldREcurso()
local cFase := ""
local clib := 'N'
Local i
//
if Empty( cGRecurso )
	Return(.F. )
Endif
//Rotina desenvolvida para bloquear que FASEs sejam apontadas por recursos de outras linhas
dbSelectArea("SZ7")
dbSetOrder(1)
if !dbSeek(xFilial("SZ7")+cGFicha)
	cFase := "0"
else
	while !SZ7->(eof()) .and. SZ7->Z7_NUMFC == cGFicha
		cFase := cValToChar(Val(SZ7->Z7_FASE)+1)
		SZ7->(dbSkip())
	enddo
endif		       
//Fim da Rotina de bloqueio de apontamentos de FASES
//
SH1->(DbSetOrder(1))
if ! SH1->( DbSeek( xFilial('SH1') + cGRecurso  )  )
	Alert( 'Recurso Não Encontrado. Por favor corrija.')
	cGnRecurso := space(30)
	oGnRecurso:Refresh()
	Return( .F. )
Else
	//Este bloco faz parte da rotina de bloqueio de FASEs para recursos não autorizados.
	for i:= 1 to 7 
		if Substr(SH1->H1_APFASE,i,1) == Substr(cFase,1,1)
			cLib := 'S'
		endif
	next               
	if cLib = 'S'
		if cGRecurso == '399   ' .and. RetCodUsr() <> '000416'
			Alert('Usuário não autorizado a utilizar a senha do Recurso '+cGRecurso+chr(13)+'Favor solicitar diretamente ao Recurso para efetuar o lançamento')
			cLib := 'NT'
			Return( .F. )
		endif
	endif
	if cLib <> 'S'
		Alert('Esta FASE deve ser apontada por outro recurso!! Por favor verifique.')
		Return( .F. )
	endif
	//Fim do Bloco 		                                                                                
	cGnRecurso := SH1->H1_DESCRI
	oGnRecurso:Refresh()
	oGdtApont:SetFOcus()
	Return( .T.  )
Endif
//
Return()
//----------------------------------------------------
// A funcao abaixo tem como objetivo validar se a linha dobrowse das facas esta ok .
//-----------------------------------------------
User  Function _LINFACAOK()
Return(.T. )
//-----------------------------------------------
User Function VldQtAp()

If lConsulta
	Return( .F. )
Endif
//
if m->Z7_QTAPON > aCoBrFacas[ oBrFacas:oBrowse:nAt, 4 ]
	// Alert( 'linha ')
	Return( .F. )
	/*
	Else
	// ALERT( m->Z7_QTAPON * aCoBrFacas[ oBrFacas:oBrowse:nAt, 3 ]   )
	aCoBrFacas[ oBrFacas:oBrowse:nAt, 6 ]   :=  m->Z7_QTAPON
	aCoBrFacas[ oBrFacas:oBrowse:nAt, 7 ]   :=  m->Z7_QTAPON * aCoBrFacas[ oBrFacas:oBrowse:nAt, 3 ]
	M->Z3_M2TOT := m->Z7_QTAPON * aCoBrFacas[ oBrFacas:oBrowse:nAt, 3 ]
	Endif
	//
	oBrFacas:SetArray(aCoBrFacas)
	//oBrFacas:oBrowse:Refresh()
	oBrFacas:oBrowse:nColpos := 6
	//
	*/
Endif
Return(.T. )
//---------------------------------------------------------------------
Static  Function TRZ_Aponts()

Local nnk
//
cAliasAtu := Alias()
//
cFaseAtu  := ''
cGFaseAtu := ''
aCoBrFasesFaca := {}
//
DbSelectArea('SZ7')
if DbSeek(xFilial('SZ7') + Padr( cGFicha,20  ) )
	
	While !eof() .and. Z7_FILIAL = xFilial('SZ7') .and. Z7_NUMFC == Padr( cGFicha,20  )
		//
		IF Alltrim( Z7_FASE ) = '00'
			cGIniFic := Z7_DTAPON
			oGIniFic:Refresh()
		Endif
		//
		nRetPos := Ascan( aFases, {|x| Alltrim( x[1] ) == Alltrim( Z7_FASE )  } )
		//
		nfase01 := 0
		if  Alltrim( Z7_FASE ) = '01'
			nfase01 :=  Z7_M2APONT
		Endif
		//
		ntotm2  := iif( Alltrim( Z7_FASE ) >= '01', nfase01, Z7_M2APONT )
		//
		AAdd( aCoBrFasesFaca, {Z7_FASE, iif( nRetPos > 0, aFases[nRetPos, 2 ],space(len(SG2->G2_DESCRI )  )  )  , Z7_DTAPON, ALLTRIM( POSICIONE( 'SH1',1,XFILIAL('SH1') + SZ7->Z7_OPERADO, 'H1_DESCRI' )  ), Z7_QTAPON,IIF( Z7_M2APONT == 0 , cGqtmFic, ntotm2  ) / Z7_QTAPON, IIF( ntotm2 == 0 , cGqtmFic, ntotm2 ),.f.} )
		//
		cFaseAtu := Alltrim( Z7_FASE )
		//
		DbSelectArea('SZ7')
		DbSkip()
		//
		//
	Enddo
	//
	// Else
	//	 AAdd( aCoBrFasesFaca, {space(Len(Z7_FASE)), space(len(SB1->B1_DESC)), ctod('  /  /  ') , space(len(Z7_OPERADO)), 0, 0,0,.f.} )
Endif
// Apos alimentar o browse de fases, correr a array de fases para verificar se ha alguma que ja foi apontada
//
For nnk := 1 to len( aFases )
	//
	nRetPos := Ascan( aCoBrFasesFaca, {|x| Alltrim( x[1] ) == Alltrim(  aFases[ nnk , 1 ] )  } )
	//
	if nRetPos == 0
		AAdd( aCoBrFasesFaca, { aFases[ nnk , 1 ]   , aFases[ nnk ,  2 ]  , ctod('  /  /  ') , space(  Len( Z7_OPERADO ) ), 0 , 0 , 0 , .f. } )
	Endif
	//
Next
//
//
// O bloco aponta a fase atual
If cFaseAtu == ''
	cFaseAtu := strzero( 0 , 2 )
	lFinaliza                 := .F.
	lConsulta               := .F.
Else
	//
	// Agora a Fase atual sera auferida a partir da array de fases... Se estiver na ultima fase e a posicao for maior que o tamanho da array, o sistema entendera que e o apontamento final da ficha
	nRetPos := Ascan( aFases, {|x| Alltrim( x[1] ) == Alltrim( cFaseAtu )  } )
	//
	if nRetPos + 1  =  len( aFases ) // se for igual ao tamanho da array quer dizer que ta na ultima fase
		lFinaliza                := .T.  // Permite que seja apontada com finalizacao da ficha de corte.
		cFaseAtu 				:= aFases[ nRetPos + 1, 1 ]
		lConsulta               := .F.
	Elseif nRetPos + 1  >   len( aFases ) // se for igual ao tamanho da array quer dizer que ta na ultima fase
		lFinaliza                 := .F.
		cFaseAtu 				:= 'ZZ'
		lConsulta               := .T.
	Else
		cFaseAtu 				:= aFases[ nRetPos + 1, 1 ]
		lFinaliza                 := .F.
		lConsulta               := .F.
	Endif
	//
	// cGFaseAtu :=  cFaseAtu + ' - ' + aFases[ Ascan( aFases, {|x| Alltrim( x[1] ) == Alltrim( cFaseAtu )  } ) , 2  ]
	//
Endif
//
DbSelectArea('SZ3')
//
//
// O bloco abaixo tem como objetivo verificar a data de efetivacao do apontamento da ficha de corte
//
if Z3_STATUS == 'A'
	oGStatusFi:SetFont( 	oFontAbert )
	oGStatusFi:SetColor( CLR_WHITE , CLR_GREEN  )
	cGStatusFic := 'EM ABERTO'
	// oGStatusFi
	cGFimFic    := '  /  /  '
	oGFimFic:Refresh()
	
ELSE
	oGStatusFi:SetFont( 	oFontFecha  )
	oGStatusFi:SetColor(  CLR_WHITE  ,CLR_HRED )
	cGStatusFic := 'BAIXADA'
	cGFimFic    := Dtoc( SZ3->Z3_DTAPON )
	oGFimFic:Refresh()
Endif
oGStatusFi:Refresh()
//
IF cFaseAtu == 'ZZ'
	cGFaseAtu :=  'APONTADA EM TODAS AS FASES'
	oGRecurso:lReadOnly := .T.
	oGnRecurso:lReadOnly := .T.
	oGdtApont:lReadOnly := .T.
	//
	//
Else
	oGRecurso:lReadOnly := .F.
	oGnRecurso:lReadOnly := .F.
	oGdtApont:lReadOnly := .F.
	//
	cGFaseAtu :=  cFaseAtu + ' - ' + aFases[ Ascan( aFases, {|x| Alltrim( x[1] ) == Alltrim( cFaseAtu )  } ) , 2  ]
Endif
//
oGFaseAtu:Refresh()
oBrFasesFa:SetArray( aCoBrFasesFaca )
oBrFasesFa:oBrowse:Refresh()
//
Return()
//-----------------------------------------------
/*
A Funcao abaixo tem como objetivo buscar as operacoes a partir de um determinado produto
*/
Static Function TRZ_FASES( cProduto )
//
Local cAliAtu := Alias()
//
aFases :=  {}
DbSelectArea('SG2')
dBsETorDER( 1 )
if DbSeek( xFilial('SG2') + padr(cProduto, 15 )  )
	//
	While ! eof() .and. G2_FILIAL == xFilial('SG2') .AND. G2_PRODUTO ==  padr(cProduto, 15 )
		AAdd(  aFases , { G2_OPERAC, G2_DESCRI } )
		DbSkip()
	Enddo
	//
	aFases := aSort( aFases,2,, { |x, y| x[1] < y[1] } )
	//
Else
	Alert( 'Não foram encontradas Fases para o Produto '  + Alltrim( cProduto ) + '. Por favor, corrija' )
	Return( .F. )
Endif
//
Return(.T. )
//----------------------------------------------
/*
A Funcao abaixo tem como objetivo fazer a gravacao do apontamento para a fase da ficha de corte.
Sera verificada a fase para atualizacao
*/
Static Function OkProc()
//
local cProd := ""
local cFase := ""
local cZ3NumOP    := ""
Local nn1
//Local cParTot := ""

if ! msgYesNo( 'Confirma a gravação das Informações ?')
	Return()
Endif
//Rotina construida para verificar se há disponibilidade de estoque no sistema para liberação da ficha.
dbSelectArea("SZ7")
dbSetOrder(1)
if !dbSeek(xFilial("SZ7")+cGFicha)
	cFase := "0"
else
	while !SZ7->(eof()) .and. SZ7->Z7_NUMFC == cGFicha
		cFase := cValToChar(Val(SZ7->Z7_FASE)+1)
		SZ7->(dbSkip())
	enddo
endif		       

if cFase == '0' .or. cFase == '1'
	cProd := SUBSTR( cGFicha , iif( Substr( cGFicha , 1,1 ) $ 'AB', 8 , 7 )  , 6 )
	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(xFilial("SB2")+Padr(cProd, 15)+'01')
	if SB2->B2_QATU < nMtTot
		Alert("Estoque disponivel: "+cValToChar(SB2->B2_QATU)+ " é menor que o estoque solicitado "+cValToChar(nMtTot)+ chr(13)+ chr(10)+"Verifique se houve sucesso na transferencia..." )
//		Return() //Comentada para evitar que impeça o usuario de apontar a FASE 01 caso já tenha feito a transferencia do estoque...a
				// A mensagem acima será apenas informativa....
	endif
endif               
//Fim da Rotina de verificação de saldo de estoque no sistema....

//
lMsErroAuto := .F.
//
// Neste bloco, a tabela SZ3 sera alimentada com a array das facas. Essa atualizacao e necessaria pra correcao
//
/*
For nn2 := 1 to len( aCoBrFacas )

Next
*/
//
//
if lFinaliza
	aCab := {} // array que contera os campos a serem preenchidos no apontamento da Ordem de Producao
	//		DbSelectArea('SZ3')
	DbSelectArea('SZ3')
	DbSetORder(5)
	//
	IF ! DbSeek( xFilial('SZ3') + Padr(cGFicha, 20 ) )
		Alert( 'Ficha de Corte não encontrada. Entre em contato com o Administrador.')
		Return( .F. )
	Else
		aPrdsFc := {}
		While !eof() .and. Z3_FILIAL == XFILIAL('SZ3') .AND. Z3_NUMFC == Padr(cGFicha, 20 )
			//
			if EMPTY( SZ3->Z3_DTAPON )
				AAdd( aPrdsFc, {sz3->Z3_PRODUTO	, ALLTRIM(SZ3->Z3_NUMOP) + ALLTRIM(SZ3->Z3_ITEM )  + ALLTRIM(SZ3->Z3_SEQUEN ) , ALLTRIM(SZ3->Z3_NUMOP)  +  ALLTRIM(SZ3->Z3_ITEM) , SZ3->Z3_NUMFC , SZ3->Z3_MATERIA, SZ3->Z3_M2TOT   }  )
			Endif
			//
			DbSelectArea('SZ3')
			DBSKIP()
		ENDDO
		//
		For nn1 := 1 to len(aPrdsFc)
			//
			nAcho := ASCAN( aCoBrFacas, {|x| Alltrim( x[1] ) == Alltrim( aPrdsFc[nn1,1] )  } )
			//
			if nacho == 0
				alert('nao achei nada ')
				return()
			endif
			//
			//
			// NO BLOCO ABAIXO SERA TRATADO O RATEIO PARA AJUSTE DE EMPENHO
			//
			/*
			*/
			//
//			DbSelectArea('SZ3')
//			DbSetORder(5)
			//
//			DbSeek( xFilial('SZ3') + Padr( aPrdsFc[nn1,4 ] , 20 ) )
			//
				DbSelectArea('SZ3')
				DbSetOrder(5)
				// Z3_FILIAL+Z3_NUMOP+Z3_ITEM+Z3_SEQUEN+Z3_PRODUTO
				IF DbSeek( xFilial('SZ3') + aPrdsFc[ nn1,4 ] + aPrdsFc[ nn1,2 ] + aPrdsFc[ nn1,1 ] )
					Reclock('SZ3', .f. )
					Replace Z3_SALDO 		WITH Z3_SALDO -  aCoBrFacas[ nAcho , 6 ]
					Replace Z3_SLDM2		WITH Z3_SALDO  * Z3_M2PAD
					Replace Z3_STATUS		WITH 'B'
					Replace Z3_DTAPON		WITH DDATABASE
					Replace Z3_HRAPON		WITH TIME()
					MsUnlock()
				Endif
			//
			// alert(  aPrdsFc[nn1,1] )
			//
		NExt
		//
	Endif
	//
	// SE O PROCESSAMENTO VIA EXECAUTO DO APONTAMENTO DER CERTO, O SISTEMA PASSARA A ATUALIZAR OS STATUS DAS FICHAS DE CORTE
	//
	//
	
	// Alert('A Ficha será finalizada ')
Else
	// Nesse bloco devera ser verificado sobre o lancamento dos itens solicitados a mais para o ajuste de empenho e carga posterior dos lancamentos
	if cFaseAtu == '01' .or. lF9  // e a fase indicada pra fazer o rateio das quantidades lancadas, que sera lancada no SZ3
		//
		AltM2()
		U__Rt_FcLct(  Padr( cGFicha,20  )  )
		//
	Endif 
	if cFaseAtu <> '06'
//		alert('Vai ajustar o empenho...')
//		U_ATUEMP()
	endif
	*/
Endif
//
if ! lMsErroAuto .and. !lF9
	// if !lF9
	
	DbSelectArea('SZ7')
	RecLock('SZ7', .t. )
	Replace Z7_FILIAL 		WITH xFilial('SZ7')
	Replace Z7_NUMFC 		WITH cgFicha
	Replace Z7_FASE 			WITH cFaseAtu
	Replace Z7_OPERADO	WITH cGRecurso
	Replace Z7_USDIGIT		WITH substr( cUsuario,7,15 )
	Replace Z7_DTAPON		WITH cGdtApont
	Replace Z7_DTDIGIT		WITH dDataBase
	Replace Z7_QTAPON		WITH aCoBrFacas[  1 , 6 ] // Quantidade Apontada
	Replace Z7_PLANO		WITH cGPlano
	Replace Z7_M2APONT		WITH nMtTot
	MsUnlock()
	//
	DbSelectArea('SZ3') // POSICIONANDO NA FICHA DE CORTE
	DbSetOrder(4)
	//
	IF DbSeek( xFilial('SZ3') + Padr(cGFicha, 20 ) )
		While !eof() .and. Z3_FILIAL == XFILIAL('SZ3') .AND. Z3_NUMFC == Padr(cGFicha, 20 )
			cZ3NumOP:= SZ3->Z3_NUMOP
			Reclock( 'SZ3' , .F. )
			//
			Replace Z3_LOTE 	WITH cLoteFic
			Replace Z3_CORTADO	WITH  cNumLinha
			IF lFinaliza
				Replace Z3_STATUS  	with 	'B'
				Replace Z3_DTAPON		with	dDataBase
				Replace Z3_USUAPON	with	cGRecurso
				Replace Z3_HRAPON		with	Time()
				Replace Z3_SALDO 		with  0 // Zerando o Saldo do Produto para o lancamento das fichas de corte
			Endif
			MsUnlock()
			//
			DbSkip()
		Enddo
	Endif
	_ATUEMP()
	// Rotina desenvolvida para fazer apontamento do PA ao final do apontamento da ultima ficha
Else
	if lF9
		lOkComp:= APMsgYesNo("Esta atualização é um complemento?","Atenção")
		lCompPer := APMsgNoYes("É um complemento de Perfuração ?","Atenção")
		DbSelectArea('SZ7')
		if DbSeek(xFilial('SZ7') + Padr( cGFicha,20  ) + '01')
			Reclock( 'SZ7',.F. )
			if lOkComp .and. !lCompPer 
				if nMtTot - Z7_M2APONT > 0
					SZ7->Z7_M2COMPL += nMtTot - Z7_M2APONT
				endif
			endif
			Replace Z7_M2APONT		WITH nMtTot
			//
			MsUnlock()
		Endif
		if lCompPer 
			if DbSeek(xFilial('SZ7') + Padr( cGFicha,20  ) + '02')
				Reclock( 'SZ7',.F. )
				if nMtTot - Z7_M2APONT > 0
					SZ7->Z7_M2COMPL += nMtTot - Z7_M2APONT
				endif
				MsunLock('SZ7')
			endif
		endif
		//
		// alterando o numero da linha e lote
		//  
		DbSelectArea('SZ3')
		IF DbSeek( xFilial('SZ3') + Padr(cGFicha, 20 ) )
			While !eof() .and. Z3_FILIAL == XFILIAL('SZ3') .AND. Z3_NUMFC == Padr(cGFicha, 20 )
				Reclock( 'SZ3' , .F. )
				//
				Replace Z3_LOTE 	WITH cLoteFic
				Replace Z3_CORTADO	WITH  cNumLinha
				MsUnlock()
				//
				DbSkip()
			Enddo
		Endif
		//
	endif
	//
//	U_ATUEMP()
	//
Endif
//

//
lF9 := .F.
//
if ! lMsErroAuto
	if cFaseAtu == '06' //Verifica se está sendo apontado na expedição
		cQSZ3 := " Select Z3_PLANO, Z3_NUMOP, Z3_STATUS from SZ3010 where D_E_L_E_T_ = ' ' and Z3_FILIAL = '";
				+xFilial("SZ3")+"' and Z3_PLANO = '"+cGPlano+"' and Z3_NUMOP = '"+cZ3NumOP+"' and Z3_STATUS = 'A' "
			if Select("Z3TMP") > 0 
				dbSelectArea("Z3TMP")
				dbCloseArea()
			endif
			ncntd:=0
			dbUseArea(.T., "TOPCONN", TCGenQry(,, cQSZ3), 'Z3TMP', .F., .T.)
			
			dbSelectArea("Z3TMP")
			dbGotop()
			while !Z3TMP->(eof())
				ncntd++
				Z3TMP->(dbskip())
			enddo
	endif	
	// Vrf_APPA( .F. ) // Chamada da Funcao de Checagem das Fichas para o Apontamento do PA
	// Alert( 'Apontamento  efetuado com Sucesso')
	oBtnOk:Disable()
	Vld_Fic( .T. )
Else
	Alert( 'Ficha Apontada, embora haja alertas no Apontamento.')
Endif
//
// Endif
oGFicha:setfocus()
Return()
//------------------------------------------------------------------------------
Static Function Imp_Etiq()
Local 	cOpFic := SUBSTR( cGFicha , iif( Substr( cGFicha , 1,1 ) $ 'AB', 2 , 1 )  , 6 )+'-'+Substr(alltrim(cgfaseatu),1,2)
local cQuery := ""                                                                                                                              
local cQuery2:= ""
local nctLan := 0 //Variável para contar o numero de lançamentos do da mesma ficha... Evitar duplicidade e lançamento com DOC do MV_DOCSEQ
local nQuant := 0
local nQtdZ7 := 0
local lDocOk := .F.
Local lTrfAut := Getmv('MV_TRFAUT') //Parametro que identifica se deve ou nao fazer as transferencias automáticas entre os almoxarifados
//
cLinha := ''
cLinha +=  chr( 15 )
cLinha +=  Padr( 'Recurso: ' + Alltrim(cgrecurso) + '-'+ Substr( cgnREcurso,1,27 ) , 45 )+ 'Data: ' + Dtoc( acobrfasesFaca[ oBrFasesFacas:oBrowse:nAt, 3 ] )
cLinha +=  Chr(13) + chr( 10 )
cLinha +=  'Plano: '+ Alltrim( cgPlano )
cLinha +=  Chr(13) + chr( 10 )
cLinha +=  'Cliente: '+alltrim( cgcliente )
cLinha +=  Chr(13) + chr( 10 )
cLinha += Padr( 'Ficha : ' + alltrim( cgFicha ), 45 ) + 'Qt. Ficha: ' + Alltrim( Str( cGqtFic ) )
cLinha +=  Chr(13) + chr( 10 )
cLinha +=  'Material: '+ Alltrim(cGetPrFicha) +'-'+alltrim( cgdprFicha )
cLinha +=  Chr(13) + chr( 10 )
cLinha +=  Padr( 'M2 Padrao: ' + Alltrim( Transform( cgQtmFic, '@e 99,999.999' ) ) , 45 ) + 'M2 Apontado: '+ Alltrim( Transform( nMtTot, '@e 99,999.999' ) )
cLinha +=  Chr(13) + chr( 10 )
cLinha +=  'Mat. Plano: '+ Alltrim(cgPrPl) +'-'+ Alltrim( cgdPrPl )
cLinha +=  Chr(13) + chr( 10 )
cLinha +=  Padr(  'Qtde. Plano: ' + Alltrim( Str( cGqtPrPl )) , 45 ) + 'Lote : ' + Alltrim( cLoteFic )
cLinha +=  Chr(13) + chr( 10 )
cLinha +=  Padr( 'Fase Atual: ' + alltrim(cgfaseatu),45 ) + 'Linha: ' + Alltrim( cNumLinha )
cLinha +=  Chr(13) + chr( 10 ) + Chr(13) + chr( 10 )+ Chr(13) + chr( 10 )+ Chr(13) + chr( 10 )
//
memowrite('c:\temp\tmpprt.txt', cLinha )
copy File c:\temp\tmpprt.txt to lpt1
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina de Transferencia automática de produtos do almoxarifado 01 para 02
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if lTrfAut // Verifica se vai ou não transferir automático...
	cQuery := " Select D3_DOC, D3_COD, D3_QUANT, D3_LOCAL, D3_ATLOBS from SD3010 where D_E_L_E_T_ = ' ' and D3_FILIAL = '";
			+xFilial("SD3")+"' and D3_CF = 'RE4' and D3_DOC like '"+Substr(cOpFic,1,6)+"%' and D3_ATLOBS = '"+cgFicha+;
			 "' and D3_LOCAL in ('01','03') and D3_COD ='"+cGetPrFicha+"' AND D3_ESTORNO <> 'S'  "


//cQuery := " Select Max(D3_DOC) D3_DOC from SD3010 where D_E_L_E_T_ = ' ' and D3_FILIAL = '";
//			+xFilial("SD3")+"' and D3_CF = 'RE4' and D3_DOC like '"+Substr(cOpFic,1,6)+"%' and D3_ATLOBS = '"+cgFicha+;
//			 "' and D3_LOCAL = '01' and D3_COD ='"+cGetPrFicha+"'  "


			
	if Select("TMPD3") > 0
		dbSelectArea("TMPD3")
		dbCloseArea() 
	endif

	dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), 'TMPD3', .F., .T.)
		
	cQryInc := " Select Max(D3_DOC) D3_DOC from SD3010 where D_E_L_E_T_ = ' ' and D3_FILIAL = '";
			+xFilial("SD3")+"' and D3_CF = 'RE4' and D3_DOC like '"+Substr(cOpFic,1,6)+"%' and D3_LOCAL in ('01','03') AND D3_ESTORNO <> 'S'  "

	if Select("TMPINC") > 0
		dbSelectArea("TMPINC") 
		dbCloseArea()
	endif	

	dbUseArea(.T., "TOPCONN", TCGenQry(,, cQryInc), "TMPINC", .F., .T.)
	
    dbSelectArea("TMPINC")
    dbGotop()

    cOpFic := TMPINC->D3_DOC
    cOpFic := Soma1(cOpFic)
/*    dbSelectArea('SD3')
    dbSetOrder(1)
    for i:= 1 to 20
    	Alert('Gerando numero da ficha...')
    	if !dbSeek(xFilial('SD3')+Substr(cOpFic,6))
    		i:= 20
    		Alert('Nao encontrado...')
    	else
    		cOpFic := Soma1(cOpFic)   
    	endif
    next i
  */
//	Alert('Encontrado-> ' +cOpFic)
	dbSelectArea("TMPD3")
	dbGOtop()
	while !TMPD3->(eof())
//		Alert('TMPD3-> |'+Substr(TMPD3->D3_DOC,1,6)+'| cOpFic-> |'+Substr(cOpFic,1,6)+'|')
		if Substr(TMPD3->D3_DOC,1,6) == Substr(cOpFic,1,6)
			nctLan++
			nQuant += TMPD3->D3_QUANT
//			cOpFic := Substr(cOpFic,1,6)+'AD'+cValToChar(nctLan+1)
//			alert('Documento -> ' +cOpFic)
		endif
		TMPD3->(dbSkip())
	enddo                            


	cQuery2 := " SELECT Z7_NUMFC, Z7_M2APONT from SZ7010 where D_E_L_E_T_ = ' ' and Z7_FILIAL = '"+xFilial("SZ7")+;
				"' and Z7_NUMFC = '"+cgFicha+"' and Z7_FASE = '01' "

	if Select("TMPZ7") > 0
		dbSelectArea("TMPZ7")
		dbCloseArea()
	endif
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery2), 'TMPZ7', .F., .F.)

	dbSelectArea("TMPZ7")
	TMPZ7->(dbGotop())
	while !TMPZ7->(eof())
		nQtdZ7 += TMPZ7->Z7_M2APONT
	TMPZ7->(dbSkip())
	enddo
/*
//	Alert("Qtde Transferido-> "+cValToChar(nQuant)+" Qtde Z7-> "+cValToChar(nQtdZ7))
cQuery := "Select MAX( D3_DOC ) as D3_DOC from SD3010 WHERE D3_COD = '"+cGetPrFicha+"' AND D3_ATLOBS = '"+cGFicha+"' AND D_E_L_E_T_  = ' ' " 
cQuery += " AND D3_FILIAL = '"+xFilial("SD3")+"' " 

//
IF SELECT( 'TMPD3' ) > 0
	DbSelectArea( 'TMPD3' )
	DbcloseArea()
ENDIF
//
dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQuery ), 'TMPD3' , .F. , .T. )
nc := 0
dbSelectArea('TMPD3')
dbgotop()
while !TMPD3->(eof())
	nc++
	TMPD3->(dbSkip())
enddo
	
*/
/*
	lDocOk := U_ValidDoc(cOpFic,cGetPrFicha)
	while lDocOk <> .T.
		if nctLan >= 0  .and. nctLan < 10
			cOpFic := Substr(cOpFic,1,6)+cValTochar(nctLan)+Substr(TIME(),7,2)
		elseif 	nctLan >= 10 .and. nctLan < 100
			cOpFic := Substr(cOpFic,1,6)+cValToChar(nctLan)+Substr(cOpFic,9,1)	
		elseif nctLan >= 100
			cOpFic := Substr(cOpFic,1,6)+cValToChar(nctLan)
		endif
		lDocOk := U_ValidDoc(cOpFic,cGetPrFicha)	
	enddo
*/
	if  nQuant < nMtTot
		if substr(cgfaseatu,1,2)='01'
			TrfArm(cOpFic, nMtTot, cGetPrFicha, cgdprFicha, cgFicha)
//			Alert('Transferiu fase 001...'+chr(13);
//			+'Qtde a Transf-> '+cValToChar(nQuant)+' Qtde transferido-> '+cValToChar(nQtdZ7)+chr(13);
//			+'Codigo-> '+Substr(cGetPrFicha,1,6)+'-'+cgdprFicha+chr(13);
//			+'Ficha-> '+cgFicha)
		else 
			TrfArm(cOpFic, nMtTot - nQuant, cGetPrFicha, cgdprFicha, cgFicha)	
//			Alert('Transferiu em outra fase...'+chr(13);
//			+'Qtde a Transf-> '+cValToChar(nQuant)+' Qtde transferido-> '+cValToChar(nQtdZ7)+chr(13);
//			+'Codigo-> '+Substr(cGetPrFicha,1,6)+'-'+cgdprFicha+chr(13);
//			+'Ficha-> '+cgFicha)
		endif
	elseif nQuant > nQtdZ7
		Alert("A Transf está maior que a necessidade favor conferir..."+chr(13);
		+'Qtde a Transf-> '+cValToChar(nQtdZ7)+' Qtde transferido-> '+cValToChar(nQuant)+chr(13);
		+'Codigo-> '+Substr(cGetPrFicha,1,6)+'-'+cgdprFicha+chr(13);
		+'Ficha-> '+cgFicha)
		u__mailprbtrf(cgFicha)
	endif
//else
//	Alert("Rotina de transferencia desabilitada....")
endif
//
return()

//---------------------------------------------------------------------------------
// A funcao abaixo tem como objetivo imprimir a ficha de corte para a filial 08 - PNP II
Static Function ImpEt_08()
//
//  No primeiro plano, a rotina varre a array de fichas para selecao daquelas prontas.

SetPrc(0,0)
/*

nlin := 0
@ nLin, 00 psay chr( 15 )+ 'Recurso : ' + Alltrim(cgrecurso) + '-'+ Alltrim( cgnREcurso )
@ nlin, 48 psay 'Data: ' + Dtoc( acobrfasesFaca[ oBrFasesFacas:oBrowse:nAt, 3 ] )
nLin ++
@ nlin, 00 psay 'Plano: '+ Alltrim( cgPlano )
nlin++
@ nlin, 00 psay 'Cliente: '+alltrim( cgcliente )
nlin++
@ nlin, 00 PSAY 'Ficha : ' + alltrim( cgFicha )
@ nlin, 40 psay 'Qt. Ficha: ' + Alltrim( Str( cGqtFic ) )
nLin++
@ nlin, 00 psay 'Material: '+ Alltrim(cGetPrFicha) +'-'+alltrim( cgdprFicha )
nlin++
@ nlin, 00 psay 'M2 Padrao: ' + Alltrim( Transform( cgQtmFic, '@e 99,999.999' ) )
@ nlin, 40 psay 'M2 Apontado: '+ Alltrim( Transform( nMtTot, '@e 99,999.999' ) )
nlin++
@ nlin, 00 psay 'Mat. Plano: '+ Alltrim(cgPrPl) +'-'+ Alltrim( cgdPrPl )
nlin++
'@ nlin, 00 psay 'Qtde. Plano: ' + Alltrim( Str( cGqtPrPl ))
@ nlin, 40 psay 'Lote : ' + Alltrim( cLoteFic )
nLin ++
@ nlin, 00 psay 'Fase Atual: ' + alltrim(cgfaseatu)
nLin += 3
@ nlin,00 psay '.'
setprc( 0,0 )
//
//
If aReturn[5] = 1
Set Printer TO
dbCommitall()
ourspool(wnrel)
Endif

// MS_FLUSH()
*/
cLinha := "Esta linha está comprimida na Epson" + chr(13 ) + chr(10)
cLinha += "to na segunda linha  comprimida na Epson" + chr(13 ) + chr(10)
cLinha += "to na terceira  linha  comprimida na Epson" + chr(13 ) + chr(10)
cLinha += "to na quarta  linha  comprimida na Epson" + chr(13 ) + chr(10)
//
memowrite('c:\tmpprt.txt', cLinha )
//cComaImp := 'type c:\tmpprt.txt > lpt1'

/*
@ 01,01 psay 'linha'
@ 02,01 psay 'linha 2 '
SetPrc(0,0
*/
Return()
//---------------------------------------------------------------------------------
Static Function VlDLote()

// ogMtTot:SetFocus()
if ! lConsulta
	oBtnOk:Enable()
Endif

REturn(.t.)
//---------------------------------------------------
Static Function VldtApon()
OgLote:SetFocus()
REturn(.T.)
//--------------------------------------------------
/* A funcao abaixo tem como objetivo verificar se todas as ordens de producao ref aos niveis foram apontadas
em sua integralidade. Se for o caso, buscar a apontar a OP Principal.

O escopo para processamento sera o seguinte:

1 - Posiciona-se nas OPs;
2 - Varre-se a tabela SD3 para verificar se houve apontamento e qual a quantidade desse apontamento ;
3 - SE estiver ok, mantem o flag indicativo para o apontamento do Produto Principal  - PA
*/
Static Function Vrf_APPA( lTela )
//
lTodosOk := .T. // flag indicando se todas OPs foram devidamente apontadas e esta tudo ok
cPends   := ''
DbSelectArea('SD3')
nOrdSd3 := Indexord() // armazenando o indice para restauracao futura
DbSetORder(1) // Setando a ordem para op + Produto + local
//
DbSelectArea('SC2')
nOrdSc2 := Indexord() // armazenando o indice para restauracao futura
DbSetORder(1) // Setando a ordem para op + Produto + local
set filter to
DbGoTop()
//
if ! DbSeek(   xFilial('SC2') + substr( cgopProt, 1 , 6 ) + '01001'   )  //  Posicionando na OP Principal
	Alert(' OP '+ cgopProt + ' Nao Encontrada.')
	Return()
Else
	if C2_QUANT  == C2_QUJE
		Alert( ' Plano ja apontado anteriormente.')
		Return()
	Endif
Endif
//
cProdPA := SC2->C2_PRODUTO // Produto principal
//
While ! eof() .and. C2_FILIAL == xFilial('SC2') .and.  C2_NUM  == substr( cgopProt,1 , 6 )
	//
	if C2_ITEM + C2_SEQUEN == '01001'  // o PRIMEIRO PRODUTO NAO INTERESSA NESSA LISTA
		Dbskip()
		Loop
	Endif
	//
	cNumSup1 :=  '' // Numero Superior do Lancamento
	cProdPI1    := SC2->C2_PRODUTO // Produto principal
	//
	//
	//IF Alltrim( C2_UM ) <> 'M2'
	//
	IF ALLTRIM( C2_UM ) == 'PC' .AND. C2_QUANT > C2_QUJE
		lTodosOk := .f.
		cPends   += 'OP Protheus: ' + C2_NUM + C2_ITEM + C2_SEQUEN + '  Produto: ' + Alltrim( C2_PRODUTO ) + '  Qtde OP: '+alltrim(Str(C2_QUANT)) + '  Apontados: '+alltrim(Str(C2_QUJE)) + CHR(13) + CHR(10)
	Endif
	//Endif
	
	//
	DbSelectArea('SC2')
	Dbskip()
Enddo
//
if lTodosOk
	DbSeek(   xFilial('SC2') + substr( cgopProt, 1 , 6 ) + '01001'   )
	//
	aCab := {}
	//
	AAdd( aCab, {'D3_FILIAL'		,		 XFILIAL('SD3' ),nil 																					})
	AAdd( aCab, {'D3_TM'			,		 '500' ,nil																								})
	AAdd( aCab, {'D3_COD'			,		 sc2->c2_produto	,nil																				})
	AAdd( aCab, {'D3_OP'			,		 sc2->c2_num + sc2->c2_item + sc2->c2_sequen ,nil														})
	AAdd( aCab, {'D3_QUANT'		    ,		 sc2->c2_quant 					,nil 																	})
	AAdd( aCab, {'D3_LOCAL'		    ,		 SC2->C2_LOCAL	,nil																					})
	AAdd( aCab, {'D3_DOC'			,		 sc2->c2_num + sc2->c2_item + sc2->c2_sequen,nil 														})
	AAdd( aCab, {'D3_EMISSAO'	    ,		 dDataBase ,nil																							})
	AAdd( aCab, {'D3_CC'			,		 '320700' ,nil																								})
	AAdd( aCab, {'D3_PARCTOT'	    ,		 'T' ,nil																								})
	AAdd( aCab, {'D3_ATLOBS'	    ,	     SZ3->Z3_NUMFC ,	nil																					})
	//
	DbSelectArea('SC2')
	DbSeek( xFilial('SC2') + SZ3->Z3_NUMOP + SZ3->Z3_ITEM + SZ3->Z3_SEQUEN )
	//
	// lREt := Mata250( aCab , 3 ) // chama a rotina de apontamento de Ordem de Produção
	lMsErroAuto := .f.
//	U_ATUEMP() //Faz ajuste dos empenhos antes de fazer o apontamento da ficha....
	msExecAuto({|x,Y| Mata250(x,Y)},aCab,3)
	//
	If lMsErroAuto
		// Alert( 'Erro no apontamento da Ordem de Produção ' + aPrdsFc[nn1,2])
		If lMsErroAuto
			MostraErro()
		EndIf
	Endif
	//
	/*
	alert( ' O sistema deve agora Gerar o Apontamento do PA Automaticamente ')
	*/
Else
	// Alert( 'Atenção ! Existe(m) OP(s) que não foi(ram) apontada(s) Totalmente.')
	MemoWRite('c:\fichas_corte\ItensApont' + substr( cgopProt,1 , 6 ) + '.txt', cPends )
	// Winexec('Notepad.exe c:\ItensApont.txt' )
Endif
//
if ltela
	Winexec('Notepad.exe c:\ItensApont.txt' )
Endif
//
DbSelectArea('SD3')
DbSetORder( nOrdSd3 ) // Setando a ordem para op + Produto + local
//
DbSelectArea('SC2')
DbSetORder( nOrdSc2 ) // Setando a ordem para op + Produto + local
//
Return()
//------------------------------------------
*/
Static Function LigaF9()
//
lF9 := .F.
if msgyesno('Deseja Realmente alterar as metragens ?')
	lF9 := .T.
	lFinaliza := .F.
Endif
Return()
//-----------------------------------------
Static Function AltM2()

Local nnk1
// Nesse bloco devera ser verificado sobre o lancamento dos itens solicitados a mais para o ajuste de empenho e carga posterior dos lancamentos
//if cFaseAtu == '01'  // e a fase indicada pra fazer o rateio das quantidades lancadas, que sera lancada no SZ3
//
DbSelectArea('SZ3')
nORdAtuZ3 := IndexOrd()
nRegAtu := REcno()
DbSetOrder(4)
//
For nnk1 := 1 to len( AcoBrFacas )
	//
	if DbSeek(xFilial('SZ3') + Padr( cGFicha , 20 ) +  AcoBrFacas[ nnk1,1 ]  ) // PUXANDO PELO MATERIAL PARA ATUALIZAR O EMPENHO
		//
		Reclock('SZ3' , .f. )
		Replace Z3_M2TOT with AcoBrFacas[ nnk1,7  ]
		Replace Z3_SLDM2 with Z3_M2TOT
		MsUnlock()
	Endif
	//
Next
//
DbSelectArea('SZ3')
DbSetOrder(nORdAtuZ3 )
DbGoTo( nRegAtu )
//
// Endif
//
Return()
//-------------------------------

/*
A funcao abaixo tem como objetivo reatear a metragem lancada na ficha de corte, lancando as informacoes correlatas
para cada item, de acordo com o ajuste realizado pelo operador na operacao 01 - Saida do Couro no Almox
*/
User Function _Rt_FcLct( cFicha )
//
//
//
// cFicha := '079319009124001'
if cFIcha == Nil
	REturn()
Endif
//
// O bloco abaixo realizara as pesquisas para verificacao quando a ficha e os lancamentos
//
DbSelectArea('SZ7')
DbSetOrder(1)
if ! DbSeek( xFilial('SZ7') + PADR( cFicha , 20 ) + '01'  )
	RETURN()
Endif
//
nM2Apont := SZ7->Z7_M2APONT // PRODUTO PARADIGMA PARA O RATEIO DAS QUANTIDADES
//
cQrZ3Tot := "Select Sum( Z3_SLDM2 ) as TotM2,Sum( Z3_M2TOT ) as TOTPADRAO FROM " + RETSQLNAME("SZ3") + " WITH( NOLOCK ) WHERE Z3_FILIAL ='"+XFILIAL('SZ3') +"' AND "
cQrZ3Tot += " D_E_L_E_T_ = ' ' AND Z3_NUMFC = '" + cFicha + "'"

//
//
IF SELECT( 'TotSZ3' ) > 0
	DbSelectArea( 'TotSZ3' )
	DbcloseArea()
ENDIF
//
dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQrZ3Tot ), 'TotSZ3' , .F. , .T. )
//
DbSelectArea( 'TotSZ3' )
Dbgotop()
if eof()
	Return()
Endif
//
// nM2Apont   := TOTPADRAO
nDiferenca :=  nM2Apont  - TotSz3->TOTPADRAO
//
if round( TotM2 , 4 ) == round( nM2Apont, 4 )
	return()
Endif
*/
//
DbSelectArea('SZ3')
nREcAtu := Recno()
nOrdAtu := Indexord()
DbSetOrder(4) // Ordem 4 -> Por ficha de Corte
//
if DbSeek( xFilial('SZ3') + PADR( cFicha , 20 )  )
	
	While !eof() .and. Z3_FILIAL = XFILIAL('SZ3') .AND. Z3_NUMFC == PADR( cficha , 20 )
		//
		nRepres 	 := ( Z3_M2TOT /  TotSz3->TOTPADRAO ) * 100  // o quanto a metragem apontada representa do total lancado
		nM2TotPad    :=  Z3_QTDE * Z3_M2PAD
		nm2Rat  	 :=  nM2TotPad + ( ( nDiferenca  * nRepres )  / 100 )
		//
		Reclock('SZ3',.f.)
		Replace Z3_M2TOT 	WITH nM2TotPad
		Replace Z3_SLDM2 	WITH nm2Rat
		MsUnlock()
		//
		DbSelectArea('SZ3')
		DbSkip()
	Enddo
Endif
//
DbSelectArea('SZ3')
DbGoto( nREcAtu  )
DbSetOrder( nOrdAtu  )
//
REturn()
//-------------------------------
/*
A Funcao abaixo tem como objetivo excluir as ORdens de PRoducao que nao foram apontadas e que estaso mexendo no estoque
//-------------------------------
*/

// Faz o Ajuste dos empenhos.....
//	Alert("Iniciando ajuste dos empenhos..")
Static Function _ATUEMP()
//Alert('Atualizando empenho...')
U__Rt_FcLct( Padr( cGFicha,20  ) )                                          

cOrdFic := SUBSTR( cGFicha , 1, iif( Substr( cGFicha , 1,1 ) $ 'AB', 13 , 12 ) )
dbSelectArea("SZ3")
dbSetOrder(4) // Numero da Ficha
dbSeek(xFilial("SZ3")+cGFicha) // +AcoBrFacas[ 1,1 ])

//Busca produtos que estão preenchidos no parametros MA_043247, caso o produto esteja informado lá, nao faz ajuste nos empenhos
cPrd043 := getMV('MA_043247')
if Alltrim(SZ3->Z3_MATERIA) $ cPrd043
 	Return
endif

if SZ3->(Z3_QTDE * Z3_M2PAD) <> Z3_SLDM2
	dbSelectArea("SZ7")
	dbSetOrder(1)
	if dbSeek(xFilial("SZ7")+SZ3->Z3_NUMFC+'02')     
  //		Alert("Entrou para ajustar")
		dbSelectArea("SD4")
		dbSetOrder(1)
		nQtdeAc := 0
		nQtdeD4 := 0
		nAtuSB2 := 0
		cLocal  := ''                  
		cProdSD4:= SZ3->Z3_MATERIA
		cOP     := Substr(SZ3->Z3_NUMOP,1,6)
		dbSeek(xFilial("SD4")+Substr(SZ3->Z3_NUMOP,1,6))
		cQuery1 := " select  Sum(D4_QTDEORI) QTDEORI, Sum(D4_QUANT) quant from SD4010 where D_E_L_E_T_ = ' ' and Substring(D4_OP,1,6)='";
			+cOP+"' AND D4_COD = '"+SZ3->Z3_MATERIA+"' AND D4_FILIAL = '"+xFilial("SD4")+"' "
	
		IF SELECT( 'TRBD4' ) > 0
			DbSelectArea( 'TRBD4' )
			DbcloseArea()
		ENDIF
		dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQuery1  ), 'TRBD4' , .F. , .T. )
    
  	    nQtdeD4 := TRBD4->Quant
  	//    Alert('nQTdeD4 -> '+cValToChar(nQtdeD4))
		dbSelectArea("SZ3")
		dbSetOrder(4) // Numero da Ficha
		dbSeek(xFilial("SZ3")+cGFicha)
		while !eof() .and. SZ3->Z3_NUMFC == cGFicha 
			dbSelectArea("SD4")
			dbSetOrder(2)                                                               
			if dbSeek(xFilial("SD4")+Padr(Substr(SZ3->Z3_NUMOP,1,6)+SZ3->(Z3_ITEM+Z3_SEQUEN),14)+SZ3->Z3_MATERIA)
 	
				cQuery1 := " select  Sum(D4_QTDEORI) QTDEORI, Sum(D4_QUANT) quant from SD4010 where D_E_L_E_T_ = ' ' and Substring(D4_OP,1,6)='";
				+Substr(SZ3->Z3_NUMOP,1,6)+"' AND D4_COD = '"+SZ3->Z3_MATERIA+"' AND D4_FILIAL = '"+xFilial("SD4")+"' "
			
				IF SELECT( 'TRBD4' ) > 0
					DbSelectArea( 'TRBD4' )
					DbcloseArea()
				ENDIF
				dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQuery1  ), 'TRBD4' , .F. , .T. )
			    
			    nQtdeD4 := TRBD4->Quant
				
				// Loop para considera situacoes em que ocorre empenho multiplo(divisao por lote) de um produto
				// para uma mesma OP.
				// Ajuste necessario na lectra apos ordem de separacao, porem nao afeta baixas do corte couro
				// Diego Mafisolli - 26/07/18
				while !eof() .And. Alltrim(SD4->D4_COD) == Alltrim(SZ3->Z3_MATERIA)
					cLocal   := SD4->D4_LOCAL
					cProdSD4 := SD4->D4_COD
					if SD4->D4_QUANT > 0 .or. SD4->D4_QTDEORI == 0
						cQueryAtD4 := " Select Substring(Z3_NUMFC,1,13) FICHA, Z3_ITEM, Z3_SEQUEN, Sum(Z3_SLDM2) Z3_SLDM2, Sum(Z3_M2TOT) Z3_M2TOT from SZ3010 "
						cQueryAtD4 += " where D_E_L_E_T_ =  ' ' "                   
						if Substr( cOrdFic , 1,1 ) $ 'AB'
							cQueryAtD4 += " and Substring(Z3_NUMFC,1,13) = '"+cOrdFic+"' "
						else
							cQueryAtD4 += " and Substring(Z3_NUMFC,1,12) = '"+cOrdFic+"' "
						endif						
						cQueryAtD4 += " and Z3_ITEM = '"+SZ3->Z3_ITEM+"' "
						cQueryAtD4 += " and Z3_SEQUEN = '"+SZ3->Z3_SEQUEN+"' "
						cQueryAtD4 += " and Z3_NUMOP = '"+SZ3->Z3_NUMOP+"' " 
						cQueryAtD4 += " and Z3_MATERIA = '"+SZ3->Z3_MATERIA+"' "
						cQueryAtD4 += " group By Substring(Z3_NUMFC,1,13), Z3_ITEM, Z3_SEQUEN 	"
	                    
	                    if SELECT( 'TRBATU' ) > 0
	                    	DbSelectArea( 'TRBATU') 
	                    	dbCloseArea()
	                    endif
	                    dbUseArea(.T.,"TOPCONN", TCGenQry( , , cQueryAtD4 ), 'TRBATU', .F., .T. )
	                    if !ALLTRIM(SD4->D4_COD) $ cPrd043
							Reclock('SD4',.F.) 
							//SD4->D4_QUANT := TRBATU->Z3_SLDM2 - (SD4->(D4_QTDEORI-D4_QUANT))

							// Ajusta total da ficha baixada no empenho
							// considera situacoes em que ocorre empenho multiplo(divisao por lote) de um produto
							// Ajuste de empenho rateado entre as linhas multiplas da mesma OP
							SD4->D4_QUANT := ((SD4->D4_QTDEORI - SD4->(D4_QTDEORI-D4_QUANT))/TRBD4->Quant) * TRBATU->Z3_SLDM2 
							
							//If xFilial("SD4") <> '08' 
								Replace SD4->D4_QTDEORI with TRBATU->Z3_SLDM2
							//Endif
							
							
							Msunlock()
						endif
						nQtdeAc:= 0
					else
						nQtdeAc:= (SZ3->Z3_SLDM2 - SD4->D4_QTDEORI)
					endif                     
					FErase("TRBATU"+GetDBExtension())
					SD4->(dbSkip())
				enddo
			endif
		SZ3->(dbSkip())
		enddo                               

		dbSeek(xFilial("SD4")+cOP)
		cQuery1 := " select  Sum(D4_QTDEORI) QTDEORI, Sum(D4_QUANT) quant from SD4010 where D_E_L_E_T_ = ' ' and Substring(D4_OP,1,6)='";
			+cOP+"' AND D4_COD = '"+cProdSD4+"' AND D4_FILIAL = '"+xFilial("SD4")+"' "
	
		IF SELECT( 'TRBD4C' ) > 0
			DbSelectArea( 'TRBD4C' )
			DbcloseArea()
		ENDIF
		dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQuery1  ), 'TRBD4C' , .F. , .T. )
//		   Alert('TRBD4C->QUANT: '+cValToChar(TRBD4C->Quant)+' nQtdeD4: '+cValToChar(nQtdeD4))
		   if TRBD4C->Quant <> nQtdeD4
		   		nQtdeD4 :=  TRBD4C->Quant - nQtdeD4
		   else
		   		nQtdeD4 := 0
		   endif

		dbSelectArea("SB2")               
		dbSetOrder(1) //Produto + Armazem
		if dbSeek(xFilial("SB2")+cProdSD4+cLocal,.T.)
			RecLock('SB2',.F.)
			SB2->B2_QEMP += nQtdeD4
			MsUnlock('SB2')
		endif
	endif 
endif
Return
//----------------------------------------


*------------------------------------*
Static Function TrfArm(cOpFic ,nMtTot, cCodProd, cDescrPrd, cGFicha)
*------------------------------------*
//Alert("Transferencia a ser realizada ->"+chr(13)+"Documento: "+cOpFic+" qtde-> "+cValToChar(nMtTot)+" FICHA: "+cgFicha+" Produto: "+cCodProd)
aLin = {}
aCab = {}
aAdd (aCab,{ cOpFic, ddatabase})

				aadd (aLin, cCodProd) // Produto origem
				aadd (aLin, Substr(Alltrim(cDescrPrd),1,30)) // Descricao produto origem
				aadd (aLin, Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_UM")) // UM origem
				if Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_GRUPO") == '40  ' 
					aadd (aLin, Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_LOCPAD")) // Almox origem caso seja couro
				else
					aadd (aLin, "03") // Almox origem caso seja pvc
				endif
				aadd (aLin, Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_LOCPAD")) // Endereco origem
				aadd (aLin, cCodProd) // Produto destino  a
				aadd (aLin, Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_DESC")) // Descricao produto origem
				aadd (aLin, Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_UM")) // UM destino
				aadd (aLin, Posicione("SBZ",1,xFilial("SBZ")+cCodProd,"BZ_LOCPAD")) // Almox destino
				aadd (aLin, '02') // Endereco destino
				aadd (aLin, '') // Num serie
				aadd (aLin, '') // Lote
				aadd (aLin, '') // Sublote
				aadd (aLin, criavar('D3_DTVALID'))
				aadd (aLin, 0) // Potencia
				aadd (aLin, nMtTot) // Quantidade
				nQtdeSeg := Iif(Posicione(("SB1"),1,xFilial("SB1")+cCodProd,"B1_TIPCONV")=='M', nMtTot*Posicione(("SB1"),1,xFilial("SB1")+cCodProd,"B1_CONV"),nMtTot / Posicione(("SB1"),1,xFilial("SB1")+cCodProd,"B1_CONV"))
				aadd (aLin, nQtdeSeg) // Qt seg.UM
				aadd (aLin, '') //criavar("D3_ESTORNO")) // Estornado
				aadd (aLin, criavar("D3_NUMSEQ")) // Sequencia (D3_NUMSEQ)
				aadd (aLin, '') //criavar("D3_LOTECTL")) // Lote destino
				aadd (aLin, criavar("D3_DTVALID")) // Validade
				aadd (aLin, criavar("D3_ITEMGRD")) // Item da Grade
				aadd (aCab, aclone (aLin))
                                                  
			lMSErroAuto = .F.
			cNumSeq:= GetMv ('MV_DOCSEQ') 
			cNumSeq:= Soma1(cNumSeq)
//		    Alert('NumSEQ de transferencia-> ' +cNumSeq)			
	   		msexecauto({|x| Mata261(x)}, aCab, 2)
		   If lMsErroAuto
				MostraErro ()
				Alert("A Transferencia desse produto não foi realizada, favor verificar e transferir manualmente para evitar divergencias","Atenção")
				u__mailprbtrf(cgFicha)
		   else
		   dbSelectArea("SD3")     
		   dbSetOrder(4)
		   if dbSeek(xFilial("SD3")+cNumSeq)
		   		while !SD3->(eof()) .and. SD3->D3_NUMSEQ == cNumSEQ
		   			if SD3->D3_ATLOBS == space(20)
		   				RecLock("SD3",.F.)
		   				SD3->D3_ATLOBS := cgFicha
		   				MsUnlock("SD3")
		   			endif
		   			SD3->(dbSkip())
		   		enddo
		   endif
//		   		Alert("Transferencia realizada com sucesso...."+chr(13)+"Documento: "+cOpFic+" qtde-> "+cValToChar(nMtTot)+" FICHA: "+cgFicha+" Produto: "+cCodProd)
		   endif
return


user function _mailprbtrf(cFicha)

     Local _cEmlFor := 'agfaria@taggs.com.br' //; marcos.falaschi@midoriatlantica.com.br'
     Local oProcess 
     Local oHtml
     Local nCont := 0
     //RA_VCTOEXP
     //RA_VCTEXP2                                      
//	 RpcSetEnv("01","04","","","","",{"SRA"})
     SETMV("MV_WFMLBOX","WORKFLOW") 
     oProcess := TWFProcess():New( "000005", "Problema na transferencia entre almoxarifado" )
     oProcess :NewTask( "Problema na transferencia entre almoxarifado", "\WORKFLOW\HTM\trfautalmox.HTM" )
     oHtml    := oProcess:oHTML
     	oHtml:ValByName( "data", dtoc(ddatabase))
     	oHtml:ValByName( "numOP", cGOpProt)
     	oHtml:ValByName( "NumFicha", cFicha)
     	oHtml:ValByName( "NumPlano", cgPlano)
	 	aAdd( oHtml:ValByName( "it.desc" ), "Houve problema na transferencia de estoque entre armazens da ficha acima" )
   	 	aAdd( oHtml:ValByName( "it.desc" ), "favor analisar para evitar divergencias ao final do mes.")
   	 	aAdd( oHtml:ValByName( "it.desc" ), "o erro ocorreu na senha do usuario "+Substr(cUsuario,1,20)+ " e o mesmo " )
   	 	aAdd( oHtml:ValByName( "it.desc" ), "tambem recebeu uma mensagem na tela informando sobre o fato..." )

		oProcess:cSubject := "Problema com transferencia automatica entre armazens " + dToc(dDatabase)



	oProcess:cTo      := _cEmlFor     


oProcess:Start()                    
	       //WFSendMail()
	       //WFSendMail()	       
oProcess:Finish()


return                                     



    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Tela de leitura via QRCode para contagem da metragem para ser lançado no campo: Total M2
// ANTONIO 27/02/18
//
// OBS.: 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////




Static Function LigaF8()

	/*Declaração das variáveis locais*/
	Local oButton1
	Local oButton2
	Local oSim    := LoadBitmap(GetResources(), "ENABLE")
	Local oNao    := LoadBitmap(GetResources(), "DISABLE")
	Local oPedido
 
	/*Declaração das variáveis privadas*/
	Private oPedido
	Private oPedidos
	Private cPedido 	:= Space(17)
	Private aPedidos    := {}

	Private nTotEtq  := 0
	Private nTotEtq1 := ""
	Private nTotEtq2 := ""
	Private nTotEtq3 := ""
	Private nLastKey := 0 
	Private nAPF_Pos := 0
	Private aEtqFic  := {}
	
	/*Declaração das variáveis estáticas*/
	Static oDlg

	oFont := TFont():New('Courier new',,-18,.T.)
	nMtTot:=0

	DEFINE DIALOG oDlg TITLE "Leitura Etiquetas para Calculo M2" FROM 000, 000  TO 400, 500 PIXEL
	
	@ 003, 005 SAY oSay1 PROMPT "Etiqueta" SIZE 030, 007 OF oDlg PIXEL

    oTMultiget1:= TGet():New( 013,005,{|u| If(PCount()>0,cPedido:=u,cPedido)} ,oDlg,065,009,  , {|| U_X_XOK(cPedido) } ,CLR_BLACK,CLR_WHITE,oFontLabel,  ,   ,.T.,"",  ,  ,.F.,.F.,   ,.F.,.F.,   ,"cPedido",  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,.t.  )

	
	//Usando o TCBrowse para gerenciar individualmente cada coluna
//                               1  2    3    4  5678   9101112        13             141516171819 20     21  22   23  24   252627
	oPedidos := TCBrowse():New(067, 005,238, 100,,,,oDlg,,,,,{|| U_APAGA(oPedidos:nAt) }, , , , , , ,.F.,,.T.,,.F.,,,)
//	oPedidos:AddColumn(TCColumn():New(" "       , {|| If(aPedidos[oPedidos:nAt,01],oSim,oNao) },,,,,,.T.,.F.,,,,.F., ) )
	oPedidos:AddColumn(TCColumn():New("Produto" , {|| aPedidos[oPedidos:nAt,01]},"@!"               ,,,"LEFT", 025,.F.,.T.,,,,.F., ) )
	oPedidos:AddColumn(TCColumn():New("Valor"  	, {|| aPedidos[oPedidos:nAt,02]},"@E 999,999,999.99",,,"LEFT", 040,.F.,.T.,,,,.F., ) )
	oPedidos:AddColumn(TCColumn():New("M2"  	, {|| aPedidos[oPedidos:nAt,03]},"@!"               ,,,"LEFT", 080,.F.,.T.,,,,.F., ) )
	oPedidos:AddColumn(TCColumn():New("Total M2", {|| aPedidos[oPedidos:nAt,04]},"@E 999,999,999.99",,,"LEFT", 040,.F.,.T.,,,,.F., ) )
		
	oPedidos:SetArray(aPedidos)  //Define um array para o browse
	
	oPedidos:bWhen     := { || Len(aPedidos) > 0 } //Se o array estiver vazio, o browse fica desabilitado
	oPedidos:Refresh()

	oSayFicE4 := TSay():New( 013,160,{|| "Total M2: " + Transform(nTotEtq,"@E 999.9999") },oDlg,,oFontSub,.F.,.F.,.F.,.T.,CLR_GREEN ,CLR_WHITE,260,092)

	@ 181, 207 BUTTON oButton2 PROMPT "Fechar" SIZE 037, 012 OF oDlg ACTION oDlg:End() PIXEL
	@ 173, 005 SAY oSay1 PROMPT "Duplo Clique na Linha Para Apagar" SIZE 150, 007 OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED
Return


User Function X_XOK(cQRCETQ)

    Local aMatRet  := {}

	If !Empty(cQRCETQ)
		aMatRet := STRTOKARR(cQRCETQ, ' ')
	
		If (nLastKey == 27 )
			cPedido := Space(17)
			oPedidos:Refresh()
			//oTMultiget1:CtrlRefresh()
			oTMultiget1:SetFocus()
			Return(.T.)
		Endif

		If Len(aMatRet) < 3
			HS_MsgInf("Valor lido inválido ! Leia a Etiqueta Novamente!","Atenção","Fases OP")
			cPedido := Space(17)
			oPedidos:Refresh()
			//oTMultiget1:CtrlRefresh()
			oTMultiget1:SetFocus()
			Return(.T.)
		EndIf

		If Val(aMatRet[2]) < 0
			HS_MsgInf("Valor lido inválido ! Leia a Etiqueta Novamente!","Atenção","Fases OP")
			cPedido := Space(17)
			oPedidos:Refresh()
			//oTMultiget1:CtrlRefresh()
			oTMultiget1:SetFocus()
			Return(.T.)
		EndIf
	
		If (Len(aMatRet[1]) < 6 .Or. Len(aMatRet[1]) > 6) .Or. Len(aMatRet[2]) <> 4 .Or. aMatRet[3] <> 'm2'
			HS_MsgInf("Valor lido inválido ! Leia a Etiqueta Novamente!","Atenção","Fases OP")
			cPedido := Space(17)
			oPedidos:Refresh()
			//oTMultiget1:CtrlRefresh()
			oTMultiget1:SetFocus()
			Return(.T.)
		EndIf
	
		If (Len(aMatRet[1]) < 6 .Or. Len(aMatRet[1]) > 6) .And. Len(aMatRet[2]) <> 4 .And. aMatRet[3] <> 'm2'
			HS_MsgInf("Valor lido inválido ! Leia a Etiqueta Novamente!","Atenção","Fases OP")
			cPedido := Space(17)
			oPedidos:Refresh()
			//oTMultiget1:CtrlRefresh()
			oTMultiget1:SetFocus()
			Return(.T.)
		EndIf
	
		If Len(aEtqFic) > 0
			If ASCAN(aEtqFic[nAPF_Pos], Val(aMatRet[2]) ) > 0    //verifica se etiqueta atual tem o mesmo valor da etiqueta anterior
				If !MsgYesNo("Valor já foi lido em outra Etiqueta! Continuar? " )
					cPedido := Space(17)
					oPedidos:Refresh()
					//oTMultiget1:CtrlRefresh()
					oTMultiget1:SetFocus()
					Return(.T.)
				EndIf
			EndIf
		EndIf


		aAdd(aEtqFic,{aMatRet[1],Val(aMatRet[2])})           //armazena informações no array para comparar na proxima leitura se ja foi lida a etiqueta
	                                                         //com este valor. (leitura de etiquetas repetidas) (linha acima)
	

		nMtTot  := nMtTot + Val(aMatRet[2])
		nTotEtq := nMtTot
	
		nTotEtq1 := aMatRet[1]
		nTotEtq2 := Val(aMatRet[2])
		nTotEtq3 := aMatRet[3]

		aadd(aPedidos,{nTotEtq1,nTotEtq2,nTotEtq3,nTotEtq})
	
		cPedido := Space(17)
		oPedidos:GoBottom()
		oPedidos:Refresh()
		oTMultiget1:SetFocus()

		nAPF_Pos++

	EndIf
	
Return



User Function APAGA(nLin)

	Local nI

	If MsgYesNo("Apagar a Linha?")

		nMtTot:=0

		ADel(aPedidos,nLin) 

		ASize(aPedidos,LEN(aPedidos)-1) // muda o tamanho do array acertando o browse:nAt

		If Len(aPedidos)==0 //se for zero criar um com elemento vazio
			oPedidos:SetArray(aPedidos)
		Else
		
			aPedidos[1,4]:=0     ///zero a primeira linha para ajustar todos valores da coluna de total
	
			For nI := 1 to Len(aPedidos)
	
				aPedidos[nI,4] := nMtTot + aPedidos[nI,2]
				nMtTot:=aPedidos[nI,4]
			Next
	
			nTotEtq := nMtTot
		EndIf

		nAPF_Pos:= nAPF_Pos - 1
				
		oSayFicE4:Refresh()
		oPedidos:Refresh()
		oTMultiget1:SetFocus()         //volta o foco para a digitação

	EndIf

Return

//A040601064091001    


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: 
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrw1()

Local nn1
noBrw1:=0

aCpos :=  	{	{'Cod. Produto' ,'ZO_PRODUTO'	,15,0	,'@!'			, 'AllwaysTrue()' },;
				{'Valor'		,'ZO_QTDCOUR'	,09,2	,'@E 999,999.99', 'AllwaysTrue()' },;
				{'Medida'	    ,'ZO_PRODUTO'	,02,0	,'@!'			, 'AllwaysTrue()' },;
				{'Total M²'	    ,'ZO_M2VQPLT'	,09,2	,'@E 999,999.99', 'AllwaysTrue()' } }

DbSelectArea("SX3")
DbSetOrder(2)

For nn1 := 1 to len( aCpos )
	If DbSeek( aCpos[ nn1,2 ] )
		If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
		
			noBrw1++
			
			Aadd(aHoBrw1,{Trim( aCpos[ nn1,1 ] ),;
			aCpos[ nn1,2 ],;
			aCpos[ nn1,5 ],;
			aCpos[ nn1,3 ],;
			aCpos[ nn1,4 ],;
			aCpos[ nn1,6 ],;
			"",;
			SX3->X3_TIPO,;
			"",;
			"" } )
		EndIf
	Endif
Next

DbSelectArea("SX3")
DbSetOrder(1)

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MCoBrw1() - Monta aCols da MsNewGetDados para o Alias: 
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
                                                     


Static Function ZZ_OK()

Local nLin:=1

If !Empty(aCoBrw1[nLin,1])
	nLin:=Len(aCoBrw1)+1
	Aadd(aCoBrw1,Array(noBrw1+1))
EndIf

aCoBrw1[nLin,1] := nTotEtq1
aCoBrw1[nLin,2] := nTotEtq2
aCoBrw1[nLin,3] := nTotEtq3
aCoBrw1[nLin,4] := nTotEtq
aCoBrw1[nLin,5] := .F.

oBrw1:SetArray(aCoBrw1)
oBrw1:oBrowse:Refresh()
oBrw1:oBrowse:GoBottom()

Return