#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

User Function AG_OPMOLH()

Private cDescrRP1  := Space(50)
Private cGet998E   := 0
Private cGet998L   := 0
Private cGet998P   := 0
Private cGet9985   := 0 //Criado para MOD998L5 ITEM - DROPS LEVE 5- INTERMEDIARIO
Private cGet998G   := 0 //Criado para MOD998E16+ ITEM - DROPS EXTRA 16+ INTERMEDIARIO 
Private cGetCartao := Space(6)
Private cGetCodPrd := Space(6)
Private cGetLT1    := Space(12)
Private cGetLT2    := Space(12)
Private cGetLT3    := Space(12)
Private cGetLT4    := Space(12)
Private cGetM2     := 0
Private cGetM2F1   := 0
Private cGetM2F2   := 0
Private cGetM2F3   := 0
Private cGetM2F4   := 0
Private cGetM2R1   := 0
Private cGetM2R2   := 0
Private cGetM2R3   := 0
Private cGetM2R4   := 0
Private cGetPCs    := 0
Private cGetPrd2   := Space(6)
Private cGetPC1	   := Space(12)
Private cGetPC2    := Space(12)
Private cGetPC3    := Space(12)
Private cGetPC4    := Space(12)
Private cGetPrdCon := Space(12)
Private cGetPrdCon := Space(12)
Private cGetPrdCon := Space(6)
Private cGetPrdCon := Space(6)
Private cGetPrdCon := Space(6)
Private cGetPrdCon := Space(6)
Private cGetPrdCon := Space(6)
Private cGetPrdCon := Space(6)
Private cMOD998E   := Space(50)
Private cMOD998L   := Space(50)
Private cMOD998P   := Space(50)
Private cSayCartao := Space(10)
Private cSayCod1   := Space(10)
Private cSayCod2   := Space(10)
Private cSayCodC2  := Space(10)
Private cSayCodPrd := Space(1)
Private cSaydescPr := Space(50)
Private cSayLT1    := Space(10)
Private cSayLT2    := Space(10)
Private cSayLT3    := Space(10)
Private cSayLT4    := Space(10)
Private cSayM2     := Space(10)
Private cSayM2F1   := Space(10)
Private cSayM2F1   := Space(10)
Private cSayM2F1   := Space(10)
Private cSayM2F2   := Space(10)
Private cSayM2F3   := Space(10)
Private cSayM2F4   := Space(10)
Private cSayMR1    := Space(10)
Private cSayMR1    := Space(10)
Private cSayMR1    := Space(10)
Private cSayMR2    := Space(10)
Private cSayMR3    := Space(10)
Private cSayMR4    := Space(10)
Private cSayNumOP  := Space(50)
Private cSayOP     := Space(1)
Private cSayOP1    := Space(1)
Private cSayPCs    := Space(10)
Private cSayPrdC1  := Space(50)
Private cSayPrdC2  := Space(50)
Private cSayPrdC3  := Space(50)
Private cSayPrdC4  := Space(50)
Private cSayPrdCon := Space(50)
Private cSayPrdCon := Space(50)
Private cSayQtdRP  := Space(50)
Private cPrd       := " "
Private cPrd2	   := " "
Private cPrd1      := " " 
Private cPrdL1     := ""
Private cPrdL2     := ""
Private cPrdL3     := ""
Private cPrdL4     := ""
Private cSayRebaix := Space(12)
Private nCBRebaix 

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oFont2","oFont3","oDlg1","oGrp1","oSayOP","oSayOP1","oSayCodPrd","oSaydescPrd","oSayNumOP")
SetPrvt("oGrp2","oSayCartao","oSayPCs","oSayM2","oSayCod2","oGetCartao","oGetPCs","oGetM2","oGetPrd2")
SetPrvt("oSayCod1","oSayLT1","oSayPrdC1","oSayM2F1","oSayMR1","oGetPrdCons1","oGetLT1","oGetM2F1","oGetM2R1")
SetPrvt("oSayCodC2","oSayLT2","oSayPrdC2","oSayM2F2","oSayMR2","oGetPrdCons2","oGetLT2","oGetM2F2","oGetM2R2")
SetPrvt("oSay13","oSay14","oSay15","oSay16","oSay17","oGet13","oGet14","oGet15","oGet16","oGrp5","oSay8")
SetPrvt("oSayPrdC3","oSayM2F3","oSayMR3","oGetPrdCons3","oGetLT3","oGetM2F3","oGetM2R3","oGrp7","oSay18")
SetPrvt("oSayPrdC4","oSayM2F4","oSayMR4","oGetPrdCons4","oGetLT4","oGetM2F4","oGetM2R4","oGrp8","oSay23")
SetPrvt("oSay25","oSay26","oSay27","oGet21","oGet22","oGet23","oGet24","oGrpRaspa","MOD998L","DescrRP1")
SetPrvt("MOD998P","MOD998E","oGet998L","oGet998P","oGet998E","oBtnConfirm","oBtnPrint")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oFont3     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oFont4     := TFont():New( "MS Sans Serif",0,-10,,.T.,0,,700,.F.,.F.,,,,,, )

oDlg1      := MSDialog():New( 055,343,664,1073,"Lançamento Molhado",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 004,004,060,356,"Dados da Ordem de Producao...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayOP     := TSay():New( 008,204,{||"Numero da OP"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,016)
oSayOP1    := TSay():New( 008,284,{||""},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,016)
oSayCodPrd := TSay():New( 028,008,{||"Código"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,012)
oSaydescPr := TSay():New( 042,064,{||cPrd1},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,292,016)
oSayNumOP  := TSay():New( 020,204,{||"NUMOP"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,120,008)
oGetCodPrd := TGet():New( 040,008,{|u| If(PCount()>0,cGetCodPrd:=u,cGetCodPrd)},oGrp1,048,014,'@!',{|| BuscaPrd1(cGetCodPrd)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetCodPrd",,)

oSayRebaix := TSay():New( 036,300,{||"Divisora"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oCBRebaix  := TComboBox():New( 044,300,{|u| If(PCount()>0,nCBRebaix:=u,nCBRebaix)},{" ","D1","D2","D3"},052,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nCBRebaix )

oGrp2      := TGroup():New( 064,004,096,356,"Dados do Cartão...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayCartao := TSay():New( 072,008,{||"Número Cartão"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oSayPCs    := TSay():New( 072,077,{||"Qtde Peças"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oSayM2     := TSay():New( 072,146,{||"Qtde M²"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oSayPr2    := TSay():New( 085,256,{||cPrd2}, oGrp2,, oFont4,.F.,.F.,.F.,.T.,CLR_BLUE, CLR_WHITE, 292, 016)
oSayCod2   := TSay():New( 072,205,{||"Código Produto 2"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,060,008)
oGetCartao := TGet():New( 080,008,{|u| If(PCount()>0,cGetCartao:=u,cGetCartao)},oGrp2,052,010,'@!',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetCartao",,)
oGetPCs    := TGet():New( 081,077,{|u| If(PCount()>0,cGetPCs:=u,cGetPCs)},oGrp2,052,010,'@E 99,999,999',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetPCs",,)
oGetM2     := TGet():New( 081,146,{|u| If(PCount()>0,cGetM2:=u,cGetM2)},oGrp2,052,010,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetM2",,)
oGetPrd2   := TGet():New( 081,205,{|u| If(PCount()>0,cGetPrd2:=u,cGetPrd2)},oGrp2,051,010,'@!',{|| BuscaPrd2(cGetPrd2)},CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetPrd2",,)
oGrp3      := TGroup():New( 100,004,160,176,"Dados Consumo 1...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayCod1   := TSay():New( 109,008,{||"Código"},oGrp3,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,009)
oSayLT1    := TSay():New( 136,008,{||"Lote 01"},oGrp3,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayPrdC1  := TSay():New( 120,052,{||cPrdL1},oGrp3,,oFont2,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,120,012)
oSayM2F1   := TSay():New( 136,057,{||"M² Real"},oGrp3,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oSayMR1    := TSay():New( 137,118,{||"M² Fornecedor"},oGrp3,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oGetPCo1   := TGet():New( 120,008,{|u| If(PCount()>0,cGetPC1:=u,cGetPC1)},oGrp3,040,010,'@!',{||BuscaPd1(cGetPC1) },CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetPC1",,)
oGetLT1    := TGet():New( 145,008,{|u| If(PCount()>0,cGetLT1:=u,cGetLT1)},oGrp3,040,010,'@!',{||ExistLT(cGetLT1, cGetPC1)} ,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetLT1",,)

//oGetQtVM1  := TGet():New( 090,004,{|u| If(PCount()>0, cGetQtVM1:=u, cGetQtVM1)},oDlg1,096,014,'@E 99,999,999.99',{|| RefreMedM(), CalcMedM(cGetQtMM1,cGetQtVM1)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtVM1",,)


oGetM2F1   := TGet():New( 145,057,{|u| If(PCount()>0,cGetM2F1:=u,cGetM2F1)},oGrp3,051,010,'@E 99,999,999.9999',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetM2F1",,)
oGetM2R1   := TGet():New( 145,118,{|u| If(PCount()>0,cGetM2R1:=u,cGetM2R1)},oGrp3,051,010,'@E 99,999,999.9999',{||ChecLT01(cGetLT1, cGetPC1, cGetM2R1) },CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetM2R1",,)
oGrp4      := TGroup():New( 100,181,160,356,"Dados Consumo 2...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayCodC2  := TSay():New( 109,185,{||"Código"},oGrp4,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,009)
oSayLT2    := TSay():New( 136,185,{||"Lote 02"},oGrp4,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayPrdC2  := TSay():New( 120,229,{||cPrdL2},oGrp4,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,120,012)
oSayM2F2   := TSay():New( 136,234,{||"M² Real"},oGrp4,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oSayMR2    := TSay():New( 137,295,{||"M² Fornecedor"},oGrp4,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oGetPCo2 := TGet():New( 120,185,{|u| If(PCount()>0,cGetPC2:=u,cGetPC2)},oGrp4,040,010,'@!',{||BuscaPdL1(cGetPC2)},CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetPC2",,)
oGetLT2    := TGet():New( 145,185,{|u| If(PCount()>0,cGetLT2:=u,cGetLT2)},oGrp4,040,010,'@!',{||ExistLT(cGetLT2, cGetPC2)},CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetLT2",,)
oGetM2F2   := TGet():New( 145,234,{|u| If(PCount()>0,cGetM2F2:=u,cGetM2F2)},oGrp4,052,010,'@E 99,999,999.9999',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetM2F2",,)
oGetM2R2   := TGet():New( 145,295,{|u| If(PCount()>0,cGetM2R2:=u,cGetM2R2)},oGrp4,052,010,'@E 99,999,999.9999',{||ChecLT01(cGetLT2, cGetPC2, cGetM2R2) },CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetM2R2",,)
oGrp5      := TGroup():New( 161,004,220,176,"Dados Consumo 3...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay8      := TSay():New( 170,008,{||"Código"},oGrp5,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,009)
oSayLT3    := TSay():New( 197,008,{||"Lote 03"},oGrp5,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayPrdC3  := TSay():New( 181,052,{||cPrdL3},oGrp5,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,120,012)
oSayM2F3   := TSay():New( 197,057,{||"M² Real"},oGrp5,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oSayMR3    := TSay():New( 198,118,{||"M² Fornecedor"},oGrp5,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oGetPCo3 := TGet():New( 181,008,{|u| If(PCount()>0,cGetPC3:=u,cGetPC3)},oGrp5,040,010,'@!',{||BuscaPdL3(cGetPC3)},CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetPC3",,)
oGetLT3    := TGet():New( 206,008,{|u| If(PCount()>0,cGetLT3:=u,cGetLT3)},oGrp5,040,010,'@!',{||ExistLT(cGetLT3, cGetPC3)},CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetLT3",,)
oGetM2F3   := TGet():New( 206,057,{|u| If(PCount()>0,cGetM2F3:=u,cGetM2F3)},oGrp5,052,010,'@E 99,999,999.9999',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetM2F3",,)
oGetM2R3   := TGet():New( 206,118,{|u| If(PCount()>0,cGetM2R3:=u,cGetM2R3)},oGrp5,052,010,'@E 99,999,999.9999',{||ChecLT01(cGetLT3, cGetPC3, cGetM2R3) },CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetM2R3",,)
oGrp7      := TGroup():New( 161,181,221,356,"Dados Consumo SILASTOL...002987|057646|064042",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay18     := TSay():New( 170,185,{||"Código"},oGrp7,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,009)
//oSayLT4    := TSay():New( 197,185,{||"Lote 04"},oGrp7,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayPrdC4  := TSay():New( 181,229,{||cPrdL4},oGrp7,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,120,012)
oSayM2F4   := TSay():New( 197,185,{||"Qtde KG"},oGrp7,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
//oSayMR4    := TSay():New( 198,295,{||"M² Fornecedor"},oGrp7,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,055,008)
oGetPCo4 := TGet():New( 181,185,{|u| If(PCount()>0,cGetPC4:=u,cGetPC4)},oGrp7,040,010,'@!',{||BuscaSLT(cGetPC4)},CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetPC4",,)
//oGetLT4    := TGet():New( 206,185,{|u| If(PCount()>0,cGetLT4:=u,cGetLT4)},oGrp7,040,010,'@!',{||ExistLT(cGetLT4, cGetPC4)},CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetLT4",,)
oGetM2F4   := TGet():New( 206,185,{|u| If(PCount()>0,cGetM2F4:=u,cGetM2F4)},oGrp7,051,010,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetM2F4",,)
//oGetM2F4   := TGet():New( 206,234,{|u| If(PCount()>0,cGetM2F4:=u,cGetM2F4)},oGrp7,051,010,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetM2F4",,)
//oGetM2R4   := TGet():New( 206,295,{|u| If(PCount()>0,cGetM2R4:=u,cGetM2R4)},oGrp7,051,010,'@E 99,999,999.99',{||ChecLT01(cGetLT4, cGetPC4, cGetM2R4) },CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetM2R4",,)
//oGrpRaspa  := TGroup():New( 224,004,292,228,"Informações de Raspa....",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrpRaspa  := TGroup():New( 224,004,292,265,"Informações de Raspa....",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
MOD998L    := TSay():New( 248,008,{||"MOD998L - Drops Leve"},oGrpRaspa,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,120,008)
DescrRP1   := TSay():New( 233,008,{||"Descrição"},oGrpRaspa,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,120,012)
oSayQtdRP  := TSay():New( 233,110,{||"Quantidade"},oGrpRaspa,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,012)
MOD998P    := TSay():New( 263,008,{||"MOD998P - Drops Pesado"},oGrpRaspa,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,120,008)
MOD998E    := TSay():New( 276,008,{||"MOD998E - Drops Extra"},oGrpRaspa,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,120,008)
MOD9985    := TSay():New( 248,166,{||"MOD998 5-"},oGrpRaspa,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,120,008)
MOD998G    := TSay():New( 263,166,{||"MOD998 16+"},oGrpRaspa,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,120,008)
oGet998L   := TGet():New( 246,111,{|u| If(PCount()>0,cGet998L:=u,cGet998L)},oGrpRaspa,051,010,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet998L",,)
oGet998P   := TGet():New( 260,111,{|u| If(PCount()>0,cGet998P:=u,cGet998P)},oGrpRaspa,051,010,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet998P",,)
oGet998E   := TGet():New( 274,111,{|u| If(PCount()>0,cGet998E:=u,cGet998E)},oGrpRaspa,051,010,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet998E",,)
oGet9985   := TGet():New( 246,210,{|u| If(PCount()>0,cGet9985:=u,cGet9985)},oGrpRaspa,051,010,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet9985",,)
oGet998G   := TGet():New( 260,210,{|u| If(PCount()>0,cGet998G:=u,cGet998G)},oGrpRaspa,051,010,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet998G",,)


oBtnConfir := TButton():New( 228,268,"&Confirmar Lançamento",oDlg1,{|| AGConfOP(), oDlg1:End()},085,020,,oFont2,,.T.,,"",,,,.F. )
oBtnPrint  := TButton():New( 253,268,"&Imprimir OP",oDlg1,{||AGAJU()},085,019,,oFont2,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return


///////////////////////////////////////////////////////////////////////////
//Validar se o total de MOD está condizente com o total de peças 
static function VLDMOD()
lRet := .T.
nTotMod := cGet998L + cGet998P + cGet998E + cGet9985 + cGet998G
if nTotMod > (cGetPCs / 2)
	Alert("O Total de RASPA é maior do que o devido..., Favor conferir!")
	lRet := .F.
endif

return lRet


///////////////////////////////////////////////////////////////////////////
//Função para buscar a descricao do produto....
static function BuscaPrd1(cGetCod)
cPrd1 := Alltrim(Posicione("SB1", 1, xFilial("SB1")+cGetCod, "B1_DESC"))
if !ALLTRIM(Posicione("SB1",1, xFilial("SB1")+cGetCod, "B1_GRUPO")) $ '31|31A'
	Alert("Produto acabado nao pertence ao grupo do recurtimento...")
	oGetCodPrd:SetFocus()
endif
oSaydescPr:Refresh()
return 


///////////////////////////////////////////////////////////////////////////
//Função para buscar a descricao do produto....
static function BuscaPrd2(cGetCod)
//alert("Num Rebaixadeira: "+cValToChar(nCBRebaix))
cPrd2 := Alltrim(Posicione("SB1", 1, xFilial("SB1")+cGetCod, "B1_DESC"))
oSaydescPr:Refresh()
return 

///////////////////////////////////////////////////////////////////////////
//Função para buscar a descricao do produto 2....
static function BuscaPd1(cGetCod)
cPrdL1 := Alltrim(Posicione("SB1", 1, xFilial("SB1")+cGetCod, "B1_DESC"))
if !ValProd(cGetCod)
	oGetPCo1:SetFocus()
endif
oSayPr2:Refresh()
return 

///////////////////////////////////////////////////////////////////////////
//Função para buscar a descricao do produto 2....
static function BuscaPdL1(cGetCod)
cPrdL2 := Alltrim(Posicione("SB1", 1, xFilial("SB1")+cGetCod, "B1_DESC"))
if !ValProd(cGetCod)
	oGetPCo2:SetFocus()
endif
oSayPrdC2:Refresh()
return 
             

///////////////////////////////////////////////////////////////////////////
//Função para buscar a descricao do produto 3....
static function BuscaPdL3(cGetCod)
cPrdL3 := Alltrim(Posicione("SB1", 1, xFilial("SB1")+cGetCod, "B1_DESC"))
if !ValProd(cGetCod)
	oGetPCo3:SetFocus()
endif
oSayPrdC3:Refresh()
return 


///////////////////////////////////////////////////////////////////////////
//Função para buscar a descricao do produto 4....
static function BuscaPdL4(cGetCod)
cPrdL4 := Alltrim(Posicione("SB1", 1, xFilial("SB1")+cGetCod, "B1_DESC"))
if !ValProd(cGetCod)
	oGetPCo4:SetFocus()
endif
oSayPrdC4:Refresh()
return 

///////////////////////////////////////////////////////////////////////////
//Função para buscar a descricao do produto 4.... (Consumo de Silastol)
static function BuscaSLT(cGetPC4)
cPrdL4 := Alltrim(Posicione("SB1", 1, xFilial("SB1")+cGetPC4, "B1_DESC"))
if !ValSLT(cGetPC4)
	oGetPCo4:SetFocus()
endif
oSayPrdC1:Refresh()
return 


////////////////////////////////////////////////////////////////////////////
//Funcao para validar produto - apenas produto do grupo 11 pode ser utilizado
static function ValSLT(cGetPC4)
lRet := .T.
if !ALLTRIM(cGetPC4) $ '002987|057646|064042'
	lRet := .F.
	Alert("O Produto "+ALLTRIM(cGetPC4)+" não é SILASTOL"+chr(13)+ALLTRIM(cGetPC4)+"-"+ALLTRIM(Posicione("SB1",1,xFilial("SB1")+cGetPC4, "B1_DESC")))
endif

return lRet


////////////////////////////////////////////////////////////////////////////
//Funcao para validar produto - apenas produto do grupo 11 pode ser utilizado
static function ValProd(cGetCod)
lRet := .T.
if cGetCod <> space(6)

	if !Posicione("SB1",1, xFilial("SB1")+cGetCod, "B1_GRUPO") $ '11  '
		lRet := .F.
		Alert("Apenas produto do grupo 11 é permitido nesse consumo...")
	endif
endif

return lRet

////////////////////////////////////////////////////////////////////////////
//Funcao para verificar se o lote existe
static function ExistLT(cGetLT1, cGetCod)
local lRet := .T.
/*Local aAreaSB8 := GetArea("SB8")
//Indice (3)
//B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE
dbSelectArea("SB8")
dbSetOrder(3)

if !dbSeek(xFilial("SB8")+cGetCod+space(9)+"02"+cGetLT1)
	Alert("Lote não existe....")
	lRet := .F. 
endif

restArea(aAreaSB8)
  */
return lRet

////////////////////////////////////////////////////////////////////////////
//Funcao para validar estoque por lote
static function ChecLT01(cGetLT1, cGetCod, nGetM2)
local lRet := .T.
local cQuery := ""
local nSaldo := 0
local cLot   := ""
cQuery := " Select B8_PRODUTO, B8_LOTECTL, B8_SALDO, B8_EMPENHO FROM "+RetSqlName("SB8")+" SB8 "
cQuery += " where D_E_L_E_T_ =' ' and B8_FILIAL = '"+xFilial("SB8")+"' AND B8_LOCAL = '03' "
cQuery += " and B8_PRODUTO = '"+cGetCod+"' AND B8_LOTECTL = '"+cGetLT1+"' "

if Select("TMPB8") > 0 
	dbSelectArea("TMPB8")
	TMPB8->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", TcGenQry(, , cQuery), "TMPB8", .T.,.T.)

dbSelectArea("TMPB8")
TMPB8->(dbGotoP())
while !TMPB8->(eof())
     nSaldo += TMPB8->B8_SALDO - TMPB8->B8_EMPENHO
     cLot := TMPB8->B8_LOTECTL
     TMPB8->(dbSkip())
enddo 
/*if nSaldo = 0 
	Alert("Você nao possui saldo no lote selecionado")
	lRet := .F.
endif */

if nSaldo < nGetM2
	Alert("Você nao possui saldo no LOTE para esse apontamento..."+chr(13)+"SALDO DO LOTE "+cLot+": "+cValToChar(nSaldo))
	lRet := .F.
endif

if !lRet
	oGetM2R1:SetFocus()
endif

return lRet

static function VldDuplic(cGetLoT1, cGetLoT2, cGetLoT3, cGetLoT4, cGetPC1, cGetPC2, cGetPC3, cGetPC4)
local lRet := .T.
if cGetLoT1 == space(12)
	cGetLoT1 := "LT1"
endif
if cGetLoT2 == space(12)
	cGetLoT2 := "LT2"
endif

if cGetLoT3 == space(12)
	cGetLoT3 := "LT3"
endif

if cGetLoT4 == space(12)
	cGetLoT4 := "LT4"
endif


if cGetLoT1+cGetPC1 == cGetLoT2+cGetPC2 .or. cGetLoT1+cGetPC1 == cGetLoT3+cGetPC3 .or. cGetLoT1+cGetPC1 == cGetLoT4+cGetPC4
	lRet := .F.
endif
if cGetLoT2+cGetPC2 == cGetLoT3+cGetPC3 .or. cGetLoT2+cGetPC2 == cGetLoT4+cGetPC4
	lRet := .F.
endif
if cGetLoT3+cGetPC3 == cGetLoT4+cGetPC4
	lRet := .F.
endif

//Alert("Existe lote lançado em duplicidade"+chr(13)+"Por favor corrigir antes de continuar!!")

return lRet

////////////////////////////////////////////////////////////////////////////
//Funcao para validar a quantidade de raspa que está sendo gerado
static function AGQTDROP(cGet998L, cGet998P, cGet998E, cGetPCs, cGet9985, cGet998G)
local lRet     := .T.
local nTotDrp  :=  cGetPCs / 2

if (cGet998L + cGet998P + cGet998E + cGet9985 + cGet998G) -1  > nTotDrp
   Alert("O Total de DROPS está divergente em relação à quantidade de VAQUETAS"+chr(13)+"Por favor Corrigir")
   lRet := .F.
endif
return lRet

////////////////////////////////////////////////////////////////////////////
//Funcao para validar se está sendo empenhado WET BLUE
static function AGEMP(cGetPCs, cGetM2R1, cGetM2R2, cGetM2R3, cGetM2R4)
local lRet     := .T.
if cGetPCs <= 0
    Alert("A Quantidade de VAQUETAS informada está errada!!"+chr(13)+"Por favor conferir")
    lRet := .F.
endif
if lRet
    if cGetM2R1 + cGetM2R2 + cGetM2R3 + cGetM2R4 <= 0
    	Alert("A Quantidade de WET BLUE empenhado está errada!!"+chr(13)+"Por favor conferir")
    	lRet := .F.
    endif
endif


return lRet



////////////////////////////////////////////////////////////////////////////
//Funcao para gerar a confirmar a geração de producao
static function AGConfOP()
if APMSGNOYES("Confirma a geração da OP ?", "Atenção - AG_OPMOLH")
	if VldDuplic(cGetLT1, cGetLT2, cGetLT3, cGetLT4, cGetPC1, cGetPC2, cGetPC3, cGetPC4)
		if AGQTDROP(cGet998L, cGet998P, cGet998E, cGetPCs, cGet9985, cGet998G)
			if AGEMP(cGetPCs, cGetM2R1, cGetM2R2, cGetM2R3, cGetM2R4)
		   		Processa({|| AGGEROP() }, "Gerando OP...AG_MOLH")
		 	endif
	 	endif
	else
		Alert("Existem lotes duplicados no consumo"+chr(13)+"Por favor corrigir!")
	endif
else
	Alert("Rotina abortada...")
endif

return 

//Gerar ordem de producao....
static function AGGEROP()
Local aArea := GetArea()
Local lRet  	:= .T.
Local nCount    := 0

				aCab := {}     
				
				//cNumOP := GetSXeNum('SC2','C2_NUM') //Alterado funcao retorna numeracao automatica				
				cNumOP := GetNumSC2()               
				
				Alert("OP: "+cNumOP)
				AAdd( aCab, {'C2_FILIAL'		,		 xFilial("SC2")			   		,			nil					})
				AAdd( aCab, {'C2_NUM' 			, 		 cNumOP							,			nil					})
				AAdd( aCab, {'C2_ITEM'			,		 '01' 							,			nil					})
				AAdd( aCab, {'C2_SEQUEN'		,	     '001'							,			nil					})
				AAdd( aCab, {'C2_PRODUTO'		,		 cGetCodPrd						,			nil					})
				AAdd( aCab, {'C2_QUANT'			,	 	 cGetPCs	   					, 			nil					})
				AAdd( aCab, {'C2_LOCAL'		    ,		 '02'							,			nil					})
				AAdd( aCab, {'C2_CC'		  	,	 	 '320001'						,			nil 				})
				AAdd( aCab, {'C2_DATPRI'	    ,		 dDataBase 						,			nil					})
				AAdd( aCab, {'C2_DATPRF'		,		 dDataBase+10					,			nil					})
				AAdd( aCab, {'C2_EMISSAO'	    ,	     dDataBase						,			nil					})
				AAdd( aCab, {'C2_OPMIDO'	    ,		 cGetCartao						,			nil		  			})
				AAdd( aCab, {'C2_CLIENTE'	    ,		 '000001'						,			nil		  			})
				AAdd( aCab, {'C2_LOJA' 			, 		 '01'							,  			nil					})
				AAdd( aCab, {'C2_LADO'			,		 "A"					   		, 			nil					})
				AAdd( aCab, {'C2_RELEASE' 		,		 cGetCartao   					, 			nil 				})
				AAdd( aCab, {'C2_OPC' 			,        '001009 /'						,			nil					})
				AAdd( aCab, {'C2_DTRELE'		, 		 dDataBase						, 			nil 				})
				AAdd( aCab, {'C2_ITEMCTA'		,		 xFilial("SC2")					, 			nil 				})
				AAdd( aCab, {'C2_QTDLOTE'	    ,	     cGetPCs						,			nil					})
				AAdd( aCab, {'C2_X_PRODU'		, 		 cGetPrd2						,           nil					})
				AAdd( aCab, {'C2_QTDM2'		    ,	     cGetM2							,			nil					})	
				AAdd( aCab, {'C2_OBS'           ,        "OP MOLHADO - "+cGetCartao 	,			nil        			})
				AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
				AAdd( aCab, {"AUTEXPLODE"       ,        'S'							,			NIL 			   	})

				incProc("Gerando plano - Por Favor Aguarde.... ")
				lMsErroAuto := .f.
				msExecAuto({|x,y| Mata650(x,Y)},aCab,3)
		//
		If lMsErroAuto
			// Alert( 'Erro no apontamento da Ordem de Produção ' + aPrdsFc[nn1,2])
			If lMsErroAuto
				MostraErro()
			EndIf
		else         
			//ConfirmSX8()
//			Alert("Ordem de producao "+cNumOP+" Gerado com Sucesso...")
			AGAJUEMP(cNumOP)
			AGAPRASPA(cNumOP)
			Alert("Rotina finalizada com sucesso....OP"+cNumOP)
		Endif

static function AGAJU()
if apmsgnoYes("Confirma o ajuste de empenho ?", "Atenção - setor molhado")
//Processa({|| AGGEROP() }, "Gerando OP...AG_MOLH")
	Processa( { || AGAJUEMP('472013') }, "Ajustando empenho...")
endif

return
////////////////////////////////////////////////////////////////////////////////
//Funcao para ajustar a ordem de producao de acordo com a quantidade informada
static function AGAJUEMP(cOP)
local aVetor := {}
local cQD4 := ""
cQD4 := " SELECT D4_COD, D4_OP, D4_TRT, D4_LOCAL, D4_QUANT, D4_QTDEORI FROM "+RetSqlName("SD4")+" SD4 "
cQD4 += " WHERE SD4.D_E_L_E_T_ = ' ' AND D4_FILIAL = '"+xFilial("SD4")+"' AND Substring(D4_OP,1,6) = '"+cNUMOP+"' "
cQD4 += " AND ( D4_COD in ('MOD998P', 'MOD998L','MOD998E','MOD998L5-','MOD998E16+') OR SUBSTRING(D4_COD,1,3) <> 'MOD') "
cQD4 += " ORDER BY D4_COD " 

Memowrite("C:\temp\QOPMOLH.TXT", cQD4)
if Select("TMPD4") > 0 
	dbSelectArea("TMPD4")
	TMPD4->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQD4), "TMPD4", .T., .T.)

dbSelectArea("TMPD4")
TMPD4->(dbGotop())
while !TMPD4->(eof())
cOP := TMPD4->D4_OP
cTR := TMPD4->D4_TRT
//3 = Incluir, 4 = Alterar , 5 = Excluir
	aVetor:={{"D4_COD"     		,TMPD4->D4_COD			,NIL},;
    	      {"D4_OP"     		,TMPD4->D4_OP			,NIL},;
        	  {"D4_TRT"     	,TMPD4->D4_TRT			,NIL},;
	          {"D4_LOCAL"     	,TMPD4->D4_LOCAL		,NIL},;
    	      {"D4_QTDEORI"		,TMPD4->D4_QTDEORI		,NIL},;
        	  {"D4_QUANT"     	,TMPD4->D4_QUANT		,NIL},;
	          {"ZERAEMP"     	,"S"					,NIL}} //Zera empenho 

		  lMSHelpAuto := .T.
          lMSErroAuto := .F.
          MSExecAuto({|x,y| MATA380(x,y)},aVetor,5)
 		if lMSErroAuto
 			MostraErro()
 		endif
	TMPD4->(dbSkip())
enddo 				
//Adicionar os empenhos relacionado às informacoes da tela
	//Informacoes do Item 01 - Couro WET BLUE
//cGetPC2, cGetLT2, cGetM2F2, cGetM2R2
//B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE

if cGetM2F1 > 0 
	//				Posicione("SB1",1, xFilial("SB1")+CodProd,"B1_X_RESTR") //Restrição a compra
	cQB8 := " SELECT B8_PRODUTO, B8_LOTECTL, B8_LOCAL, B8_DTVALID FROM "+RetSqlName("SB8")+" SB8 WHERE D_E_L_E_T_ = ' ' AND B8_FILIAL = '"+xFilial("SB9")+"' "
	cQB8 += " AND B8_PRODUTO = '"+cGetPC1+"' AND B8_LOTECTL = '"+cGetLT1+"' AND B8_SALDO > 0 and B8_LOCAL = '03' " 
	if Select("TMPB8") > 0 
		dbSelectArea("TMPB8")
		TMPB8->(dbCloseArea())
	endif
	memowrite("C:\TEMP\SALDOB801.TXT", cQB8)
	dbUseArea(.T., "TOPCONN", TcGenQry(, , cQB8), "TMPB8", .T., .T.)
	dbSelectArea("TMPB8")
	
	TMPB8->(dbGotop())
	while !TMPB8->(eof())
		cPrd 	 := TMPB8->B8_PRODUTO
		cArm 	 := TMPB8->B8_LOCAL
		cGetLT1  := TMPB8->B8_LOTECTL
		dDtValid := ""//sTod(TMPB8->B8_DTVALID)
		TMPB8->(dbSkip())
	enddo
	//alert("query executada..."+cGetLT1)
	dDtValid := Posicione("SB8",3, xFilial("SB8")+cPrd+'03'+cGetLT1, "B8_DTVALID")
	//	alert("DATA:" +dTos(dDtValid)+" Busca realizada:"+Posicione("SB8",3, xFilial("SB8")+cGetPC1+space(9)+'02'+cGetLT1, "B8_DTVALID")+"|")
		aVetor:={{"D4_COD"     		,cPrd					,NIL},;
	    	      {"D4_OP"     		,cOP					,NIL},;
	        	  {"D4_TRT"     	,cTR	  				,NIL},;
		          {"D4_LOCAL"     	,cArm					,NIL},;
	    	      {"D4_QTDEORI"		,cGetM2R1	   			,NIL},;
	        	  {"D4_QUANT"     	,cGetM2R1				,NIL},;
	        	  {"D4_DATA"     	,dDatabase				,NIL},;
	        	  {"D4_LOTECTL"		,cGetLT1				,NIL},;
	        	  {"D4_DTVALID"     ,dDtValid				,NIL},;
		          {"D4_X_QTORI"     ,cGetM2F1				,NIL},;	          
		          {"ZERAEMP"     	,"S"					,NIL}} //Zera empenho 
	
			  lMSHelpAuto := .T.
	          lMSErroAuto := .F.
	          MSExecAuto({|x,y| MATA380(x,y)},aVetor,3)
	 		if lMSErroAuto
	 			MostraErro()
	 		endif
endif

	
//Adicionar os empenhos relacionado às informacoes da tela
	//Informacoes do Item 01 - Couro WET BLUE
//cGetPC2, cGetLT2, cGetM2F2, cGetM2R2
if cGetM2F2 > 0 
	
	cQB8 := " SELECT B8_PRODUTO, B8_LOTECTL, B8_LOCAL, B8_DTVALID FROM "+RetSqlName("SB8")+" SB8 WHERE D_E_L_E_T_ = ' ' AND B8_FILIAL = '"+xFilial("SB9")+"' "
	cQB8 += " AND B8_PRODUTO = '"+cGetPC2+"' AND B8_LOTECTL = '"+cGetLT2+"' AND B8_SALDO > 0 and B8_LOCAL = '03' " 
	if Select("TMPB8") > 0 
		dbSelectArea("TMPB8")
		TMPB8->(dbCloseArea())
	endif
	memowrite("C:\TEMP\SALDOB801.TXT", cQB8)
	dbUseArea(.T., "TOPCONN", TcGenQry(, , cQB8), "TMPB8", .T., .T.)
	dbSelectArea("TMPB8")
	
	TMPB8->(dbGotop())
	while !TMPB8->(eof())
		cPrd 	 := TMPB8->B8_PRODUTO
		cArm 	 := TMPB8->B8_LOCAL
		cGetLT2  := TMPB8->B8_LOTECTL
		dDtValid := ""//sTod(TMPB8->B8_DTVALID)
		TMPB8->(dbSkip())
	enddo
	
	
		dDtValid := Posicione("SB8",3, xFilial("SB8")+cPrd+'03'+cGetLT2, "B8_DTVALID")
		aVetor:={{"D4_COD"     		,cPrd					,NIL},;
	    	      {"D4_OP"     		,cOP					,NIL},;
	        	  {"D4_TRT"     	,cTR	  				,NIL},;
		          {"D4_LOCAL"     	,cArm					,NIL},;
	    	      {"D4_QTDEORI"		,cGetM2R2	   			,NIL},;
	        	  {"D4_QUANT"     	,cGetM2R2				,NIL},;
	        	  {"D4_LOTECTL"		,cGetLT2				,NIL},;
	        	  {"D4_DTVALID"     ,dDtValid				,NIL},;
		          {"D4_X_QTORI"     ,cGetM2F2				,NIL}} //Zera empenho 
	
			  lMSHelpAuto := .T.
	          lMSErroAuto := .F.
	          MSExecAuto({|x,y| MATA380(x,y)},aVetor,3)
	 		if lMSErroAuto
	 			MostraErro()
	 		endif
endif


//Adicionar os empenhos relacionado às informacoes da tela
//Informacoes do Item 01 - Couro WET BLUE
//cGetPC2, cGetLT2, cGetM2F2, cGetM2R2
if cGetM2F3 > 0 
	
	cQB8 := " SELECT B8_PRODUTO, B8_LOTECTL, B8_LOCAL, B8_DTVALID FROM "+RetSqlName("SB8")+" SB8 WHERE D_E_L_E_T_ = ' ' AND B8_FILIAL = '"+xFilial("SB9")+"' "
	cQB8 += " AND B8_PRODUTO = '"+cGetPC3+"' AND B8_LOTECTL = '"+cGetLT3+"' AND B8_SALDO > 0 and B8_LOCAL = '03' " 
	if Select("TMPB8") > 0 
		dbSelectArea("TMPB8")
		TMPB8->(dbCloseArea())
	endif
	memowrite("C:\TEMP\SALDOB801.TXT", cQB8)
	dbUseArea(.T., "TOPCONN", TcGenQry(, , cQB8), "TMPB8", .T., .T.)
	dbSelectArea("TMPB8")
	
	TMPB8->(dbGotop())
	while !TMPB8->(eof())
		cPrd 	 := TMPB8->B8_PRODUTO
		cArm 	 := TMPB8->B8_LOCAL
		cGetLT3  := TMPB8->B8_LOTECTL
		dDtValid := ""//sTod(TMPB8->B8_DTVALID)
		TMPB8->(dbSkip())
	enddo
	
	
		dDtValid := Posicione("SB8",3, xFilial("SB8")+cPrd+'03'+cGetLT3, "B8_DTVALID")
		aVetor:={{"D4_COD"     		,cPrd					,NIL},;
	    	      {"D4_OP"     		,cOP					,NIL},;
	        	  {"D4_TRT"     	,cTR	  				,NIL},;
		          {"D4_LOCAL"     	,cArm					,NIL},;
	    	      {"D4_QTDEORI"		,cGetM2R3	   			,NIL},;
	        	  {"D4_QUANT"     	,cGetM2R3				,NIL},;
	        	  {"D4_LOTECTL"		,cGetLT3				,NIL},;
	        	  {"D4_DTVALID"     ,dDtValid				,NIL},;
		          {"D4_X_QTORI"     ,cGetM2F3				,NIL}} //Zera empenho 
	
			  lMSHelpAuto := .T.
	          lMSErroAuto := .F.
		          MSExecAuto({|x,y| MATA380(x,y)},aVetor,3)
		 		if lMSErroAuto
		 			MostraErro()
		 		endif
endif

//Adicionar os empenhos relacionado às informacoes da tela
//Informacoes do Item 04 - SILASTOL
//cGetPC2, cGetLT2, cGetM2F2, cGetM2R2
if cGetM2F4 > 0 

	cGetLT4 := ""
	cQB2 := " SELECT B2_COD, B2_QATU - B2_QEMP ESTOQ, B2_LOCAL FROM "+RetSqlName("SB2")+" SB2 WHERE D_E_L_E_T_ = ' ' AND B2_FILIAL = '"+xFilial("SB2")+"' "
	cQB2 += " AND B2_COD = '"+cGetPC4+"' AND B2_QATU  > 0 and B2_LOCAL = '03' " 
	if Select("TMPB2") > 0 
		dbSelectArea("TMPB2")
		TMPB2->(dbCloseArea())
	endif
	memowrite("C:\TEMP\SALDOB201.TXT", cQB2)
	dbUseArea(.T., "TOPCONN", TcGenQry(, , cQB2), "TMPB2", .T., .T.)
	dbSelectArea("TMPB2")
	
	TMPB2->(dbGotop())    
	cCount:= 0
	while !TMPB2->(eof())
		cPrd 	 := TMPB2->B2_COD
		cArm 	 := TMPB2->B2_LOCAL
//		dDtValid := ""//sTod(TMPB8->B8_DTVALID)
		cCount++
		TMPB2->(dbSkip())
	enddo
	
	    if cCount  > 0 
			dDtValid := Posicione("SB8",3, xFilial("SB8")+cPrd+'03'+cGetLT4, "B8_DTVALID")

			aVetor:={{"D4_COD"     		,cPrd					,NIL},;
	    	      {"D4_OP"     		,cOP					,NIL},;
	        	  {"D4_TRT"     	,cTR	  				,NIL},;
		          {"D4_LOCAL"     	,cArm					,NIL},;
	    	      {"D4_QTDEORI"		,cGetM2F4	   			,NIL},;
	        	  {"D4_QUANT"     	,cGetM2F4				,NIL},;
		          {"D4_X_QTORI"     ,cGetM2F4				,NIL}} //Zera empenho 

			  lMSHelpAuto := .T.
	          lMSErroAuto := .F.
	          MSExecAuto({|x,y| MATA380(x,y)},aVetor,3)
	 		if lMSErroAuto
	 			MostraErro()
	 		endif
		else
			Alert("Sem estoque de Silastol, a OP estará sem o produto quimico")
		endif
endif

//cGet998L
//cGet998P
//cGet998E

//Gerar empenho de Drops Leve5-
if cGet9985 > 0 
		aVetor:={{"D4_COD"     		,'MOD998L5-      '		,NIL},;
	    	      {"D4_OP"     		,cOP					,NIL},;
	        	  {"D4_TRT"     	,cTR	  				,NIL},;
		          {"D4_LOCAL"     	,'01'					,NIL},;
	    	      {"D4_QTDEORI"		,cGet9985 *-1  			,NIL},;
	        	  {"D4_QUANT"     	,cGet9985 *-1			,NIL},;
		          {"D4_X_QTORI"     ,cGet9985 *-1			,NIL}} 
		
			  lMSHelpAuto := .T.
	          lMSErroAuto := .F.
	          MSExecAuto({|x,y| MATA380(x,y)},aVetor,3)
	 		if lMSErroAuto
	 			MostraErro()
			endif
endif


//Gerar empenho de Drops Leve
if cGet998L > 0 
		aVetor:={{"D4_COD"     		,'MOD998L        '		,NIL},;
	    	      {"D4_OP"     		,cOP					,NIL},;
	        	  {"D4_TRT"     	,cTR	  				,NIL},;
		          {"D4_LOCAL"     	,'01'					,NIL},;
	    	      {"D4_QTDEORI"		,cGet998L *-1  			,NIL},;
	        	  {"D4_QUANT"     	,cGet998L *-1			,NIL},;
		          {"D4_X_QTORI"     ,cGet998L *-1			,NIL}} 
		
			  lMSHelpAuto := .T.
	          lMSErroAuto := .F.
	          MSExecAuto({|x,y| MATA380(x,y)},aVetor,3)
	 		if lMSErroAuto
	 			MostraErro()
			endif
endif

//Gerar empenho de Drops Pesado
if cGet998P > 0 
		aVetor:={{"D4_COD"     		,'MOD998P        '		,NIL},;
	    	      {"D4_OP"     		,cOP					,NIL},;
	        	  {"D4_TRT"     	,cTR	  				,NIL},;
		          {"D4_LOCAL"     	,'01'					,NIL},;
	    	      {"D4_QTDEORI"		,cGet998P *-1  			,NIL},;
	        	  {"D4_QUANT"     	,cGet998P *-1			,NIL},;
		          {"D4_X_QTORI"     ,cGet998P *-1			,NIL}} 
		
			  lMSHelpAuto := .T.
	          lMSErroAuto := .F.
	          MSExecAuto({|x,y| MATA380(x,y)},aVetor,3)
	 		if lMSErroAuto
	 			MostraErro()
			endif
endif

//Gerar empenho de Drops Extra
if cGet998E > 0 
		aVetor:={{"D4_COD"     		,'MOD998E        '		,NIL},;
	    	      {"D4_OP"     		,cOP					,NIL},;
	        	  {"D4_TRT"     	,cTR	  				,NIL},;
		          {"D4_LOCAL"     	,'01'					,NIL},;
	    	      {"D4_QTDEORI"		,cGet998E *-1  			,NIL},;
	        	  {"D4_QUANT"     	,cGet998E *-1			,NIL},;
		          {"D4_X_QTORI"     ,cGet998E *-1			,NIL}} 
		
			  lMSHelpAuto := .T.
	          lMSErroAuto := .F.
	          MSExecAuto({|x,y| MATA380(x,y)},aVetor,3)
	 		if lMSErroAuto
	 			MostraErro()
			endif
endif

//Gerar empenho de Drops Leve5-
if cGet998G > 0 
		aVetor:={{"D4_COD"     		,'MOD998E16+     '		,NIL},;
	    	      {"D4_OP"     		,cOP					,NIL},;
	        	  {"D4_TRT"     	,cTR	  				,NIL},;
		          {"D4_LOCAL"     	,'01'					,NIL},;
	    	      {"D4_QTDEORI"		,cGet998G *-1  			,NIL},;
	        	  {"D4_QUANT"     	,cGet998G *-1			,NIL},;
		          {"D4_X_QTORI"     ,cGet998G *-1			,NIL}} 
		
			  lMSHelpAuto := .T.
	          lMSErroAuto := .F.
	          MSExecAuto({|x,y| MATA380(x,y)},aVetor,3)
	 		if lMSErroAuto
	 			MostraErro()
			endif
endif


//	APMsgInfo("Rotina finalizada com sucesso...")
//	oGet1:SetFoc
return

////////////////////////////////////////////////////////////////////
//Rotina para fazer o apontamento da Ordem de Produção
static function AGAPRASPA(cNumOP)
	dbSelectArea("SC2")
	dbSetOrder(1)
	if DbSeek(   xFilial('SC2') + cNumOP   )  //  Posicionando na OP Principal
		cProdPA := SC2->C2_PRODUTO // Produto principal 
		
		If empty(nCBRebaix)
			nCBRebaix := "  "
		Endif
		
		aCab := {}
		//
		AAdd( aCab, {'D3_FILIAL'		,		 XFILIAL('SD3' )					,nil				})
		AAdd( aCab, {'D3_TM'			,		 '500' 								,nil				})
		AAdd( aCab, {'D3_COD'			,		 cProdPA							,nil				})
		AAdd( aCab, {'D3_OP'			,		 SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)   	,nil				})
		AAdd( aCab, {'D3_QUANT'		    ,		 SC2->C2_QUANT 						,nil 				})
		AAdd( aCab, {'D3_LOCAL'		    ,		 SC2->C2_LOCAL						,nil				})
		AAdd( aCab, {'D3_DOC'			,		 SC2->C2_NUM						,nil 				})
		AAdd( aCab, {'D3_EMISSAO'	    ,		 dDataBase 							,nil				})
		AADD( aCab, {'D3_X_COD'			,		cGetPrd2							,nil				})
		AADD( aCab, {'D3_X_MT2I'		,       cGetM2								,nil				})
		AADD( aCab, {'D3_PARTIDA'		, 		cGetCartao							,nil				})
		AADD( aCab, {'D3_LOTECTL'		, 		cGetCartao							,nil				})
		AADD( aCab, {'D3_X_REBAI'		,       nCBRebaix							,nil				})
		AAdd( aCab, {'D3_CC'			,		 '320001' 							,nil				})
		AAdd( aCab, {'D3_PARCTOT'	    ,		 'T' 								,nil				})
		//
		lMsErroAuto := .f.
		msExecAuto({|x,Y| Mata250(x,Y)},aCab,3)
		If lMsErroAuto
   //			Alert( 'Erro no apontamento da Ordem de Produção ' + aPrdsFc[nn1,2])
			If lMsErroAuto
				MostraErro()
			EndIf
		Endif
		//
	else
		alert( 'op nao encontrada' )
	Endif



return