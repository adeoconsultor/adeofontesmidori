#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VSS_MSEC2 ºAutor  ³ Vinicius Schwartz  º Data ³  18/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Projeto Tela Medideira Semi-Acabado - 2                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso.      ³Rotina de inclusao de OP na Medideira Secagem.              º±±
±±º          ³Permite ao usuario selecionar um produto que contenha estru-º±±
±±º          ³tura, gera automaticamente a OP e faz o apontamento para o  º±±
±±º          ³mesmo automaticamente.                                      º±±
±±º          ³Foi desenvolvida essa nova rotina para gravar algumas infor-º±±
±±º          ³macoes a mais a serem utilizadas na emissao de romaneio uti-º±±
±±º          ³lizado para exportacao (EEC)                                º±±
±±º          ³Solicitacao Thiago.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VSS_MSEC2()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cGetCM     := 0
Private cGetCodPro := Space(6)
Private cGetCV     := 0
Private cGetDM     := 0
Private cGetDV     := 0
Private cGetEM     := 0
Private cGetERM    := 0
Private cGetERV    := 0
Private cGetEV     := 0
Private cGetNPart  := Space(11)
Private cGetPlt    := Space(14)
Private cGetQtMI1  := 0
Private cGetQtMM1  := 0
Private cGetQtVI1  := 0
Private cGetQtVM1  := 0
Private cSayC      := Space(1)
Private cSayClas   := Space(14)
Private cSayCodFor := Space(10)
Private cGetPr2    := Space(6)
Private cSayCodPro := Space(6)
Private cSayCodU   := Space(15)
Private cSayCodU1  := RetCodUsr()
Private cSayCPld   := Space(16)
Private cSayD      := Space(1)
Private cSayData   := Space(5)
Private cSayData1  := dDatabase
Private cSayDesc   := Space(10)
Private cSayDesc1  := Space(50)
Private cSayE      := Space(1)
Private cSayER     := Space(2)
Private cSayGrupo  := Space(5)
Private cSayGrupo1 := Space(4)
Private cSayLote   := Space(7)
Private cSayLote1  := Space(11)
Private cSayMedSec := Space(25)
Private cSayMt     := Space(2)
Private cSayMVI    := Space(7)
Private cSayMVI1   := '0,00'
Private cSayMVM    := Space(7)
Private cSayMVM1   := '0,00'
Private cSayMed	   := '0,00' //(cSayMVM1 / cSayMVI1)
Private cSayNoU    := Space(15)
Private cSayNoU1   := cUsuario
Private cSayNPart  := Space(12)
Private cSayOP     := Space(6)
Private cSayOP1    := 'INSERINDO...'
Private cSayPlt    := Space(16)
Private cSayProc   := Space(8)
Private cSayQtMI   := Space(15)
Private cSayQtMM   := Space(15)
Private cSayQtVI   := Space(17)
Private cSayQtVM   := Space(17)
Private cSayTM     := '0,00'
Private cSayTot    := Space(5)
Private cSayTProd  := Space(16)
Private cSayTV     := '0,00'
Private cSayUM     := Space(2)
Private cSayUM1    := Space(2)
Private cSayVq     := Space(2)
Private cSayNovFor := Space(50)
Private nSeqPlt    := Space(4) // Sequencia lote Pallet
//Drawback
//Private cSayLtdb1  := " " 
//Private cSayLtdbk  := " "
Private obrfics 
Private cFics      := {}
Private acFics     := {}
Private oOk := LoadBitmap( GetResources(), "LBOK")
Private oNo := LoadBitmap( GetResources(), "LBNO")

Private lDrawBack := GetMv( "MA_DRAWBAK" )


Private nCFor     
Private nCPlt     
Private nTCx      
Private nTProd1   
Private nTProd2   

vCor1	   := CLR_WHITE 
Public nFor	   := "01=Outro For ->"
Public cSiglaArt:= Space(4)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlg1","oSayProc","oSayMedSec","oSayData","oSayData1","oSayOP","oSayOP1","oSayCodPro")
SetPrvt("oSayDesc1","oSayUM","oSayUM1","oSayGrupo","oSayGrupo1","oSayQtVM","oSayQtMM","oSayMVM","oSayMVM1")
SetPrvt("oSayQtMI","oSayMVI","oSayMVI1", "oSayPR2","oSayCodFor","oSayNPart","oSayLote","oSayLote1","oSayTProd","oSayPlt")
SetPrvt("oSayVq","oSayMt","oSayC","oSayD","oSayE","oSayER","oSayTot","oSayTV","oSayTM","oSayCPld","oGetCodPro")
SetPrvt("oGetQtMM1","oGetQtVI1","oGetQtMI1","oTProd2","oGetNPart","oBtn1","oBtn2","oPanel1","oSayCodU","oSayNovFor")
SetPrvt("oSayNoU","oSayNoU1","oTProd1","oTCx","oGetPlt","oGetCV","oGetDV","oGetEV","oGetERV","oGetCM","oSayPR2")
SetPrvt("oGetEM","oGetERM","oCPlt","oBtn3","oBtn4","oCFor", "oSayMed", "nSeqPlt")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-14,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
oFont3     := TFont():New( "MS Sans Serif",0,-14,,.T.,0,,400,.F.,.F.,,,,,, )
//oDlg1      := MSDialog():New( 145,459,685,1085,"MEDIDEIRA SECAGEM",,,.F.,,,,,,.T.,,oFont1,.T. )
oDlg1      := MSDialog():New( 145,459,685,1185,"MEDIDEIRA SECAGEM",,,.F.,,,,,,.T.,,oFont1,.T. )
oSayProc   := TSay():New( 003,003,{||"PROCESSO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,057,010)
oSayMedSec := TSay():New( 003,061,{||"MEDIDEIRA SECAGEM"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,251,010)
oSayData   := TSay():New( 015,003,{||"DATA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,023,010)
oSayData1  := TSay():New( 015,038,{|u| If(PCount()>0, cSayData1:=u, cSayData1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,066,010)
oSayOP     := TSay():New( 015,126,{||"OP Nº"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,027,010)
oSayOP1    := TSay():New( 015,161,{|u| If(PCount()>0, cSayOP1:=u, cSayOP1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,151,010)
oSayCodPro := TSay():New( 027,184,{||"CODIGO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,010)
oSayDesc   := TSay():New( 045,003,{||"DESCRIÇÃO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,177,010)
oSayDesc1  := TSay():New( 053,003,{|u| If(PCount()>0, cSayDesc1:=u, cSayDesc1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,201,019)
oSayUM     := TSay():New( 045,210,{||"UM"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,017,010)
oSayUM1    := TSay():New( 045,248,{|u| If(PCount()>0, cSayUM1:=u, cSayUM1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,064,014)
oSayGrupo  := TSay():New( 053,210,{||"GRUPO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,034,010)
oSayGrupo1 := TSay():New( 053,248,{|u| If(PCount()>0, cSayGrupo1:=u, cSayGrupo1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,064,014)

oSayDPR2   := TSay():New( 045,280,{||"Cod.Prod.2"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,010)

oSayQtVM   := TSay():New( 097,003,{||"QTD VQ MEDIDEIRA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,089,010)
oSayQtMM   := TSay():New( 097,111,{||"QTD M2 MEDIDEIRA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,088,010)
oSayMVM    := TSay():New( 097,217,{||"M2 / VQ"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,010)
oSayMVM1   := TSay():New( 107,218,{|u| If(PCount()>0, cSayMVM1:=u, cSayMVM1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,094,010)
oSayQtVI   := TSay():New( 122,003,{||"QTDE VQ INICIAL"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,010)
oSayQtMI   := TSay():New( 122,111,{||"QTD M2 INICIAL"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,010)
oSayMVI    := TSay():New( 122,217,{||"M2 / VQ"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,010)
oSayMVI1   := TSay():New( 132,218,{|u| If(PCount()>0, cSayMVI1:=u, cSayMVI1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,094,010)
//oSayPor    := TSay():New( 112,255,{||"Aprov Metragem"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,010)
oSayPor    := TSay():New( 097,265,{||"Aprov Metragem"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,010)
oSayMed    := TSay():New( 107,285,{|u| If(PCount()>0, cSayMed:=u, cSayMed)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,094,010)
oSayCodFor := TSay():New( 071,099,{||"FORNECEDOR"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,010)
oSayNPart  := TSay():New( 147,003,{||"Nº PARTIDA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,133,010)
oSayLote   := TSay():New( 147,160,{||"Nº LOTE"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,134,010)

if lDrawBack
	aadd(acFics, {.F., " ", 0})

	@ 117,250  LISTBOX obrfics VAR cFics Fields HEADER "   ",'Lot.Drawback','Qtde' SIZE 114,56  ON DBLCLICK clk_LST() pixel // ON CHANGE CHNG() ON DBLCLICK Ad_PrLst()
	obrfics:SetArray(acFics)
	obrfics:bLine := { || { iif( acFics[obrfics:nAt,1], ook, oNo ) , acFics[obrfics:nAt,2],acFics[obrfics:nAt,3], }  }
	obrfics:hide()
	obrfics:disable()
endif

oSayLote1  := TSay():New( 157,160,{|u| If(PCount()>0, cSayLote1:=u, cSayLote1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,144,011)
oSayTProd  := TSay():New( 027,003,{||"TIPO DE PRODUÇÃO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,089,012)
oSayPlt    := TSay():New( 172,090,{||"NÚMERO DO PALETE"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,090,010)
//oSayClas   := TSay():New( 220,110,{||"CLASSIFICAÇÃO:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,072,010)
oSayVq     := TSay():New( 206,003,{||"VQ"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,009)
oSayMt     := TSay():New( 220,003,{||"MT"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSayC      := TSay():New( 198,035,{||"C"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,010,011)
oSayD      := TSay():New( 198,100,{||"D"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,010,011)
oSayE      := TSay():New( 198,165,{||"E"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,010,011)
oSayER     := TSay():New( 198,230,{||"ER"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,013,011)
oSayTot    := TSay():New( 198,275,{||"TOTAL"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,011)
oSayTV     := TSay():New( 206,275,{|u| If(PCount()>0, cSayTV:=u, cSayTV)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,060,010)
oSayTM     := TSay():New( 221,275,{|u| If(PCount()>0, cSayTM:=u, cSayTM)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,060,010)
oSayCPld   := TSay():New( 172,203,{||"PALETE CONCLUIDO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,098,009)
oTProd1    := TComboBox():New( 027,094,{|u| If(PCount()>0,nTProd1:=u,nTProd1)},{"01=INTERNA","02=VENDA","03=EXPORTAÇÃO"},082,014,oDlg1,,,{|| Vld_TProd()},CLR_BLACK,CLR_WHITE,.T.,oFont3,"",,,,,,,nTProd1 )
oGetCodPro := TGet():New( 027,227,{|u| If(PCount()>0,cGetCodPro:=u,cGetCodPro)},oDlg1,086,012,'',{|| iif(lDrawBack, {Vld_Prd(cGetCodPro), ag_chamalot(cGetCodPro)},Vld_Prd(cGetCodPro)) },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetCodPro",,)

oSayPR2    := TGet():New( 053,280,{|u| If(PCount()>0, cGetPR2:=u, cGetPR2    )},oDlg1,045,012,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetPR2",,)


GoTProd2   := TGroup():New( 075,030,095,085,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oTProd2    := TRadMenu():New( 075,037,{"NORMAL","CARTAO AZUL"},{|u| If(PCount()>0,nTProd2:=u,nTProd2)},oDlg1,,{|| Vld_Cart()},CLR_BLACK,CLR_WHITE,"",,,045,11,,.F.,.F.,.T. )
oCFor      := TComboBox():New( 080,100,{|u| If(PCount()>0,nCFor:=u,nCFor)},{"00=",nFor,"02=CUBATÃO","03=QUATRO PATAS","04=MINERVA","05=MARFRIG","06=VIPOSA","07=VANZELA","08=HUMAITÁ","09=JANGADA","10=PANORAMA"},100,014,oDlg1,,{|| Vld_OFor(nCFor)},,CLR_BLACK,CLR_WHITE,.T.,oFont3,"",,,,,,,nCFor )
oSayNovFor := TSay():New( 080,210,{|u| If(PCount()>0, cSayNovFor:=u, cSayNovFor)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,100,014)
oGetQtVM1  := TGet():New( 105,003,{|u| If(PCount()>0,cGetQtVM1:=u,cGetQtVM1)},oDlg1,085,012,'@E 99,999.99',{|| RefreMedM(), CalcMedM(cGetQtMM1,cGetQtVM1)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtVM1",,)
oGetQtMM1  := TGet():New( 105,111,{|u| If(PCount()>0,cGetQtMM1:=u,cGetQtMM1)},oDlg1,088,012,'@E 99,999.99',{|| RefreMedM(), CalcMedM(cGetQtMM1,cGetQtVM1)},CLR_BLACK,vCor1,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtMM1",,)
oGetQtVI1  := TGet():New( 130,003,{|u| If(PCount()>0,cGetQtVI1:=u,cGetQtVI1)},oDlg1,085,012,'@E 99,999.99',{|| RefreMedI(), CalcMedI(cGetQtMI1,cGetQtVI1)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtVI1",,)
oGetQtMI1  := TGet():New( 130,111,{|u| If(PCount()>0,cGetQtMI1:=u,cGetQtMI1)},oDlg1,088,012,'@E 99,999.99',{|| RefreMedI(), CalcMedI(cGetQtMI1,cGetQtVI1)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtMI1",,)
oGetNPart  := TGet():New( 155,003,{|u| If(PCount()>0, cGetNPart:=u,cGetNPart)},oDlg1,145,012,'',{|| If(nTProd1 <> '03',RefreLot(cGetNPart),'')},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetNPart",,)
GoTCx      := TGroup():New( 176,007,194,072,"",oDlg1,CLR_BLACK,vCor1,.T.,.F. )
oTCx       := TRadMenu():New( 176,013,{"CAIXA ABERTA","CAIXA NOVA"},{|u| If(PCount()>0,nTCx:=u,nTCx)},oDlg1,,{|| Num_Plt(),GeraLote()},CLR_BLACK,vCor1,"",,,045,11,,.F.,.F.,.T. )
oGetPlt    := TGet():New( 180,090,{|u| If(PCount()>0,cGetPlt:=u,cGetPlt)},oDlg1,096,014,'',,CLR_BLACK,vCor1,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"TMPLT","cGetPlt",,)
oGetPlt:bLostFocus :={||GeraLote()}
oCPlt      := TComboBox():New( 180,204,{|u| If(PCount()>0,nCPlt:=u,nCPlt)},{"","NÃO","SIM"},104,014,oDlg1,,,,CLR_BLACK,vCor1,.T.,oFont3,"",,,,,,,nCPlt )
oGetCV     := TGet():New( 206,016,{|u| If(PCount()>0,cGetCV:=u,cGetCV)},oDlg1,040,012,'@E 9,999.99',{|| CalcTV ()},CLR_BLACK,vCor1,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetCV",,)
oGetCM     := TGet():New( 220,016,{|u| If(PCount()>0,cGetCM:=u,cGetCM)},oDlg1,040,012,'@E 9,999.99',{|| CalcTM ()},CLR_BLACK,vCor1,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetCM",,)
oGetDV     := TGet():New( 206,081,{|u| If(PCount()>0,cGetDV:=u,cGetDV)},oDlg1,040,012,'@E 9,999.99',{|| CalcTV ()},CLR_BLACK,vCor1,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDV",,)
oGetDM     := TGet():New( 220,081,{|u| If(PCount()>0,cGetDM:=u,cGetDM)},oDlg1,040,012,'@E 9,999.99',{|| CalcTM ()},CLR_BLACK,vCor1,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDM",,)
oGetEV     := TGet():New( 206,146,{|u| If(PCount()>0,cGetEV:=u,cGetEV)},oDlg1,040,012,'@E 9,999.99',{|| CalcTV ()},CLR_BLACK,vCor1,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetEV",,)
oGetEM     := TGet():New( 220,146,{|u| If(PCount()>0,cGetEM:=u,cGetEM)},oDlg1,040,012,'@E 9,999.99',{|| CalcTM ()},CLR_BLACK,vCor1,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetEM",,)
oGetERV    := TGet():New( 206,211,{|u| If(PCount()>0,cGetERV:=u,cGetERV)},oDlg1,040,012,'@E 9,999.99',{|| CalcTV ()},CLR_BLACK,vCor1,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetERV",,)
oGetERM    := TGet():New( 220,211,{|u| If(PCount()>0,cGetERM:=u,cGetERM)},oDlg1,040,012,'@E 9,999.99',{|| CalcTM ()},CLR_BLACK,vCor1,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetERM",,)
oBtn2      := TButton():New( 242,256,"CONFIRMAR",oDlg1,{|| VSS_GEROP()},057,014,,oFont1,,.T.,,"",,,,.F. )
oBtn1      := TButton():New( 242,188,"CANCELAR",oDlg1,{|| oDlg1:End()},057,014,,oFont1,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( 245,003,"Imp. 2ª Via",oDlg1,{|| VSS_SEGVIA()},031,010,,oFont2,,.T.,,"",,,,.F. )
oBtn4      := TButton():New( 245,048,"Emitir Romaneio",oDlg1,{|| U_VSS_GROM()},044,010,,oFont2,,.T.,,"",,,,.F. )
oPanel1    := TPanel():New( 257,000,"",oDlg1,,.F.,.F.,,,316,013,.T.,.F. )
oSayCodU   := TSay():New( 003,010,{||"CÓDIGO USUÁRIO:"},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,007)
oSayCodU1  := TSay():New( 003,053,{|u| If(PCount()>0, cSayCodU1:=u, cSayCodU1)},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,027,007)
oSayNoU    := TSay():New( 003,103,{||"NOME USUÁRIO:"},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,007)
oSayNoU1   := TSay():New( 003,143,{|u| If(PCount()>0, cSayNoU1:=u, cSayNoU1)},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,060,007)

oDlg1:Activate(,,,.T.)

Return


//////////////////////////////////////////////////////////////////////////////////
//Atualiza status do check box
//////////////////////////////////////////////////////////////////////////////////
Static Function clk_LST()
Local cFicMain := acFics[obrfics:nAt,2]
Local lFlagChk  := acFics[obrfics:nAt,1]
Local nn1
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


//////////////////////////////////////////////////////////////////////////////////
//Valida o Tipo de producao                                                       
//////////////////////////////////////////////////////////////////////////////////
Static Function Vld_TProd()
	//Producao Interna
	If nTProd1 == '01' .Or. nTProd1 == '02'

			//Desabilita o objeto
			GoTCx:Disable()
			oTCx:Disable()
			oGetPlt:Disable()
			oCPlt:Disable()
			oGetCV:Disable()
			oGetDV:Disable()
			oGetEV:Disable()
			oGetERV:Disable()
			oGetCM:Disable()
			oGetDM:Disable()
			oGetEM:Disable()
			oGetERM:Disable()
			//Habilita se estiver desabilitado
			oGetQtVM1:Enable()
			oGetQtMM1:Enable()
			//Zera campos
			cGetQtMI1  := 0
			cGetQtMM1  := 0
			cGetQtVI1  := 0
			cGetQtVM1  := 0
			cSayMVI1   := '0,00'
			cSayMVM1   := '0,00'
			cGetCV := 0
			cGetDV := 0
			cGetEV := 0
			cGetERV := 0
			cGetCM := 0
			cGetDM := 0
			cGetEM := 0
			cGetERM := 0
			cSayTV := '0,00'
			cSayTM := '0,00'
			cSayMed := '0,00'

			if lDrawBack
				obrfics:hide()
				obrfics:disable()
			endif
			
			//Atualiza o objeto 
			oGetQtMI1:Refresh()
			oGetQtMM1:Refresh()
			oGetQtVI1:Refresh()
			oGetQtVM1:Refresh()
			oSayMVI1:Refresh()
			oSayMVM1:Refresh()
			oGetQtVM1:Refresh()
			oGetQtMM1:Refresh()
			oSayMVI1:Refresh()
			oSayMVM1:Refresh()
			GoTCx:Refresh()
			oTCx:Refresh()
			oGetPlt:Refresh()
			oCPlt:Refresh()
			oGetCV:Refresh()
			oGetDV:Refresh()
			oGetEV:Refresh()
			oGetERV:Refresh()
			oGetCM:Refresh()
			oGetDM:Refresh()
			oGetEM:Refresh()
			oGetERM:Refresh()
			oSayTV:Refresh()
			oSayTM:Refresh()         
			oSayMed:Refresh()

			
			oGetCodPro:SetFocus()
	Else
        If nTProd1 == '03'
			//Desabilita o objeto
			oGetQtVM1:Disable()
			oGetQtMM1:Disable()
			//Habilita se estiver desabilitado
			GoTCx:Enable()
			oTCx:Enable()
			oGetPlt:Enable()
			oCPlt:Enable()
			oGetCV:Enable()
			oGetDV:Enable()
			oGetEV:Enable()
			oGetERV:Enable()
			oGetCM:Enable()
			oGetDM:Enable()
			oGetEM:Enable()
			oGetERM:Enable()
			//Zera campos
			cGetQtMI1  := 0
			cGetQtMM1  := 0
			cGetQtVI1  := 0
			cGetQtVM1  := 0
			cSayMVI1   := '0,00'
			cSayMVM1   := '0,00'
			cGetCV := 0
			cGetDV := 0
			cGetEV := 0
			cGetERV := 0
			cGetCM := 0
			cGetDM := 0
			cGetEM := 0
			cGetERM := 0
			cSayTV := '0,00'
			cSayTM := '0,00' 
			cSayMed := '0,00'
			//Atualiza variável do Drawback
    		if lDrawBack
				obrfics:show()
				obrfics:enable()
			endif 
			
			//Atualiza o objeto 
			oGetQtMI1:Refresh()
			oGetQtMM1:Refresh()
			oGetQtVI1:Refresh()
			oGetQtVM1:Refresh()
			oSayMVI1:Refresh()
			oSayMVM1:Refresh()
			oGetQtVM1:Refresh()
			oGetQtMM1:Refresh()
			oSayMVI1:Refresh()
			oSayMVM1:Refresh()
			GoTCx:Refresh()
			oTCx:Refresh()
			oGetPlt:Refresh()
			oCPlt:Refresh()
			oGetCV:Refresh()
			oGetDV:Refresh()
			oGetEV:Refresh()
			oGetERV:Refresh()
			oGetCM:Refresh()
			oGetDM:Refresh()
			oGetEM:Refresh()
			oGetERM:Refresh()
			oSayTV:Refresh()
			oSayTM:Refresh() 
			oSayMed:Refresh()

			oGetCodPro:SetFocus()
		endif
	Endif

Return

//////////////////////////////////////////////////////////////////////////////////
//Valida produto e se tem cadastro de estrutura
//////////////////////////////////////////////////////////////////////////////////
Static Function Vld_Prd(cCod)
local lRet := .F.
Public _cCod := cCod

DbSelectArea('SB1')
DbSetOrder(1)

If DbSeek(xFilial('SB1') + cCod)
	cSayDesc1		:=SB1->B1_DESC
	cSayUM1			:=SB1->B1_UM
	cSayGrupo1		:=SB1->B1_GRUPO
	cSiglaArt		:=RTRIM(SB1->B1_X_SIGLA)
	
	oSayDesc1:Refresh()
	oSayUM1:Refresh()
	oSayGrupo1:Refresh()
endif             

If cSiglaArt == Space(6)
	Alert('O produto informado não possui sigla de artigo cadastrada. Favor verificar!')
	Return
endif
                                 
lRet := SubStr(Posicione('SG1',1,xFilial('SG1')+cCod,'G1_COD'),1,6)==SubStr(cCod,1,6)

If !lRet
	Alert('O produto informado nao tem estrutura cadastrada!')
	oGetCodPro:SetFocus()
endif   

return lRet                                        

//////////////////////////////////////////////////////////////////////////////////
//Valida Cartao Azul ou Normal
//////////////////////////////////////////////////////////////////////////////////
Static Function Vld_Cart()
If nTProd2 == 2
	//Desabilita o objeto
	oGetQtVI1:Disable()
	oGetQtMI1:Disable()
	oCFor:Disable()  
	cGetQtVI1:=0  
	cGetQtMI1:=0  
	cSayMVI1:='0,00'
	cSayMed := '0,00'
	nCFor:='00'
	Else
	oGetQtVI1:Enable()
	oGetQtMI1:Enable()  
	oCFor:Enable()
Endif  

oGetQtVI1:Refresh()
oGetQtMI1:Refresh()
oCFor:Refresh()
oSayMVI1:Refresh()
oSayMed:Refresh()

Return
                  
//////////////////////////////////////////////////////////////////////////////////
//Calcula total de classificacao de vaqueta                                       
//////////////////////////////////////////////////////////////////////////////////
Static Function CalcTV ()
	cSayTV := cGetCV + cGetDV + cGetEV + cGetERV
	cGetQtVM1 := cSayTV

	CalcMedM(cGetQtMM1,cGetQtVM1) 

	oSayTV:Refresh() 
	oGetQtVM1:Refresh()
	oSayMVM1:Refresh() 
	oSayMed:Refresh()
Return

//////////////////////////////////////////////////////////////////////////////////
//Calcula total de classificacao de metragem                                      
//////////////////////////////////////////////////////////////////////////////////
Static Function CalcTM ()
	cSayTM := cGetCM + cGetDM + cGetEM + cGetERM
	cGetQtMM1 := cSayTM
	
	CalcMedM(cGetQtMM1,cGetQtVM1) 	
	
	oSayTM:Refresh()  
	oGetQtMM1:Refresh()
	oSayMVM1:Refresh()
	oSayMed:Refresh()
Return

//////////////////////////////////////////////////////////////////////////////////
//Dispara Num Lote = Partida                                                      
//////////////////////////////////////////////////////////////////////////////////
Static Function RefreLot(cGetLote)
public cLote := cGetLote 	
	cSayLote1 := cLote
	//Alert("Aviso1 - Lote: "+cLote)	
	PUTMV("MA_LOTEMED", cLote) //Grava o numero do Lote no parametro MA_LOTEMED para ser buscado pela formula
	PUTMV("MV_FORMLOT", "507") //Grava o codigo da Formula no parametro que vai buscar o valor....
	oSayLote1:Refresh()
Return 

//////////////////////////////////////////////////////////////////////////////////
//Calculo de media da medideira
//////////////////////////////////////////////////////////////////////////////////
Static Function CalcMedM(cGetQtMM1,cGetQtVM1)    
public cMediaMed := '0,00'
public nPerc
if cGetQtVM1 > 0
	cMediaMed := Round((cGetQtMM1 / cGetQtVM1),2)
	cSayMVM1 := cValToChar(cMediaMed)
	nPerc := Round(((Val(cSayMVM1) / Val(cSayMVI1)) * 100),2)
	cSayMed := cValToChar(nPerc)
else
	cMediaMed := '0,00' 
	nPerc := '0,00'
	cSayMVM1 := cValToChar(cMediaMed)
	cSayMed := cValToChar(nPerc)
endif
return       

Static Function RefreMedM()
	oSayMVM1:Refresh()
	oSayMed:Refresh()
return

//////////////////////////////////////////////////////////////////////////////////
//Calculo de media inicial                                                        
//////////////////////////////////////////////////////////////////////////////////
Static Function CalcMedI(cGetQtMI1,cGetQtVI1)
public cMediaIni := '0,00'
public nPerc2
if cGetQtVI1 > 0
	cMediaIni := Round((cGetQtMI1 / cGetQtVI1),2)
	cSayMVI1 := cValToChar(cMediaIni)
	nPerc2 := Round(((Val(cSayMVM1) / Val(cSayMVI1)) *100),2)
	cSayMed := cValToChar(nPerc2)
else
	cMediaIni := '0,00' 
	nPerc2 := '0,00'
	cSayMVI1 := cValToChar(cMediaIni)
	cSayMed := cValToChar(nPerc2)
endif
return

Static Function RefreMedI()
	oSayMVI1:Refresh()
	oSayMed:Refresh()
return    

// Sequencial de Lote do Pallet(Somente Exportacao)
// Solicit. Anesio/Jairson
// Diego H. Mafisolli - 16/02/2016
Static Function GeraLote()                       
local ctrLote := Posicione("SB1",1,xFilial("SB1")+cGetCodPro,"B1_RASTRO") 

If nTProd1 == '03' .And. ctrLote == 'L' 	
	If nTCx == 2
		cQry:= "SELECT TOP 1 D3_X_SQPLT SQPLT "
		cQry+= "FROM SD3010 "
		cQry+= "WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_COD = '"+cGetCodPro+"' AND SUBSTRING(D3_EMISSAO,1,4) = '"+Substr(DTOS(ddatabase),1,4)+"' AND "
		cQry+= "D3_X_SQPLT <> '' ORDER BY D3_X_SQPLT DESC "
	Else
		cQry:= "SELECT TOP 1 D3_X_SQPLT SQPLT "
		cQry+= "FROM SD3010 "
		cQry+= "WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_COD = '"+cGetCodPro+"' AND D3_X_NPLT = '"+Alltrim(cGetPlt)+"' AND D3_X_SQPLT <> '' AND D_E_L_E_T_ = ''"
	Endif
	
	If Select("TMPSD3") > 0
		dbSelectArea("TMPSD3")                                                
		TMPSD3->(dbCloseArea())
	Endif
	
	cQry:= ChangeQuery(cQry)
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry),"TMPSD3",.T.,.T.)
	dbSelectArea("TMPSD3")
	
	// Gera nova sequencia de lote - caixa nova
	If nTCx == 2
		If TMPSD3->SQPLT == Space(4)
			nSeqPlt := '0001'
			RefreLot(nSeqPlt+'-'+Substr(DTOS(ddatabase),3,2))
		Else
			nMax := Val(TMPSD3->SQPLT)+1
			nSeqPlt := StrZero(nMax,4)
			RefreLot(nSeqPlt+'-'+Substr(DTOS(ddatabase),3,2))
		Endif
		PUTMV("MA_LOTEMED", nSeqPlt+'-'+Substr(DTOS(ddatabase),3,2)) //Grava o numero do Lote no parametro MA_LOTEMED para ser buscado pela formula
		// Utiliza sequencia de lote existente - caixa aberta
	Else
		nSeqPlt := TMPSD3->SQPLT
		RefreLot(nSeqPlt+'-'+Substr(DTOS(ddatabase),3,2))
		PUTMV("MA_LOTEMED", nSeqPlt+'-'+Substr(DTOS(ddatabase),3,2)) //Grava o numero do Lote no parametro MA_LOTEMED para ser buscado pela formula
	Endif
Endif

return

//////////////////////////////////////////////////////////////////////////////////
//Inicia validacoes e o processo de geracao da OP ao confirmar
//////////////////////////////////////////////////////////////////////////////////
Static Function VSS_GEROP()
local nMatPri := 0
local lDrbFifo:= GetMv ("MA_DRBFIFO")
local nMatAux, i := 0
 
// Ajuste solicitado pelo depto de custos
// Forcar a preencher o campo com SIM ou NAO para correto consumo dos produtos de embalagem.
// Diego Mafisolli em 27/08/18                                
If nTProd1 == '03' .And. nCPlt == Nil
	Alert("Campo PALETE CONCLUIDO Obrigatório não preenchido. Informe SIM ou NÃO")
	return
Endif

if nTProd1 == "03" .and. lDrawBack
	for i:=1 to len(acFics)
		if lDrbFifo .and. !acFics[i][1] .and. cGetQtVI1 > nMatAux // Verificar se está consumindo dos primeiros lotes disponiveis...
			Alert("Você deve consumir em sequencia de entrada..."+chr(13)+"Padrao FIFO! First IN First OUT...")
			return
		endif
		if acFics[i][1]
			nMatPri += acFics[i][3]
			nMatAux := nMatPri
		endif
	next i
endif
if lDrawBack
	if cGetQtVI1 > nMatPri	
		Alert("A quantidade "+cValToChar(cGetQtVI1)+ " é maior que a soma de lotes selecionados para apontamento "+cValToChar(nMatPri))
		return
	endif
endif

if cGetCodPro == Space(6)
	Alert('Nenhum produto foi informado...')
	oGetCodPro:SetFocus()
	Return
endif

if cGetQtVM1 == 0
	Alert('Quantidade de VQ Medideira não foi informada...')
	oGetQtVM1:SetFocus()
	Return
endif

if cGetQtMM1  == 0
	Alert('Quantidade de M² Medideira não foi informada...')
	oGetQtMM1:SetFocus()
	Return
endif

//Valida Qtd inicial de VQ - Cartao Azul ou Normal
If nTProd2 <> 2
	if cGetQtVI1  == 0
		Alert('Quantidade de VQ Inicial não foi informada...')
		oGetQtVI1:SetFocus()
		Return
	endif
Endif

//Valida Qtd inicial de M2 - Cartao Azul ou Normal
If nTProd2 <> 2
	if cGetQtMI1  == 0
		Alert ('Quantidade de M² Inicial não foi informada...')
		oGetQtMI1:SetFocus()
		Return
	endif          
Endif

//Valida Num partida
if cGetNPart  == Space(11)
	Alert ('Nenhum número de partida foi informado...')
	oGetNPart:SetFocus()
	Return
endif                    

//Valida Num palete
if nTProd1 == '03' .and. cGetPlt == Space(14)
	Alert ('Nenhum número de Palete informado...')
	oGetPlt:SetFocus()
	Return
endif

//Valida se eh cartao normal ou azul
//Normal informa fornecedor, Azul = 2 ignora
if nTProd2 == 2
	nCFor := '00'

elseif nCFor == '00'
	Alert ('Nenhum Fornecedor foi informado...')
	oCFor:SetFocus()
	Return
endif

//Valida se o produto do pallet selecionado eh o mesmo que esta sendo produzido
If nTCx = 1 .And. nTProd1 == '03'
	DbSelectArea('SD3')
	DbOrderNickNAme("PLT_OP_DOC")
//	DbSetOrder(12)
	If DbSeek(xFilial('SD3') + cGetPlt)
		If SD3->D3_COD <> cGetCodPro
			Alert ('O Palete selecionado não corresponde ao produto informado...')
			Return
		endif
	Else
		Alert ('O Palete informado não foi localizado. Favor informar um Palete válido...')
	endif
Endif

//Valida armazem 01 ou 04
if nTProd1 == '01' .Or. nTProd1 == '03'
	public vArm := '04'
elseif nTProd1 == '02'
	public vArm := '04'
endif



//Gera OP
aCab := {}                           

//cNumOP := GetSXeNum('SC2','C2_NUM') //Alterado funcao retorna numeracao automatica				
cNumOP := GetNumSC2()                
 
AAdd( aCab, {'C2_FILIAL'		,		 XFILIAL('SC2' ),nil 								})
AAdd( aCab, {'C2_NUM'			,		 cNumOP, nil										})   
AAdd( aCab, {'C2_ITEM'			,		 '01' ,nil											})
AAdd( aCab, {'C2_SEQUEN'		,	     '001',nil											})
AAdd( aCab, {'C2_PRODUTO'		,		 cGetCodPro		,nil								})
AAdd( aCab, {'C2_QUANT'		    ,		 cGetQtVM1		,nil								})
AAdd( aCab, {'C2_LOCAL'		    ,		 vArm	,nil										})
AAdd( aCab, {'C2_CC'			,		 '320101',nil 										})
AAdd( aCab, {'C2_DATPRI'	    ,		 dDataBase ,nil										})
AAdd( aCab, {'C2_DATPRF'		,		 dDataBase + 10,nil									})
AAdd( aCab, {'C2_OPMIDO'	    ,		 cGetNPart,		nil		  			       			})
AAdd( aCab, {'C2_EMISSAO'	    ,	     dDataBase,	nil										})
AAdd( aCab, {'C2_QTDLOTE'	    ,	     cGetQtVM1,			nil								})
AAdd( aCab, {'C2_X_PRODU'       ,        cGetPR2,           nil								})
AAdd( aCab, {'C2_OBS'		    ,		 cGetNPart,		nil		  			       			})   
AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
AAdd( aCab, {"AUTEXPLODE"       ,        'S',NIL 										    })
	
	incProc("Gerando plano -> ")
	
	lMsErroAuto := .F.
	msExecAuto({|x,Y| Mata650(x,Y)},aCab,3) 
	
	dbGotop()
	dbSelectArea('SC2')
	dbSetOrder(1)
	if dbSeek(xFilial('SC2')+cNumOP)
		RecLock("SC2",.F.)
		SC2->C2_ITEMCTA := xFilial("SC2")
		MsUnLock("SC2")
	endif


	If lMsErroAuto
		RollBackSx8()
		MostraErro()
	else
		//ConfirmSx8() 
		cSayOP1 := SC2->C2_NUM
		oSayOP1:Refresh()
		APMsgInfo('OP Inserida com sucesso...'+SC2->C2_NUM)
		cOP 	:= SC2->C2_NUM
		cItem	:= SC2->C2_ITEM
		cSeq	:= SC2->C2_SEQUEN
		nQuant	:= SC2->C2_QUANT
				
//		CtrLote := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_RASTRO")
//		Alert("RASTRO->"+Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_RASTRO")+"<-")
		If Rtrim(SC2->C2_PRODUTO) $ '045078|045079|045081|074818|073924|073931'
			nMedTub	:= 20 //A cada 20 vaquetas é utilizado 1 tubo de papelao
		Elseif Rtrim(SC2->C2_PRODUTO) $ '058137|058141|058145'
			nMedTub	:= 25 //A cada 25 vaquetas é utilizado 1 tubo de papelao
		Else
			nMedTub	:= 19 //A cada 19 vaquetas é utilizado 1 tubo de papelao
		Endif	
		nQtdTub := 0

		//1 - Caso o patele esteja concluído filtra qtde de VQ para calcular qtde de tubo de papelão utilizado
		//2 - Caso o palete ainda não esteja concluido os empenhos da embalagem são deletados
		//Solicitação Fabio/Thiago para controle de consumo de embalagem no palete - 29/04/2013
		//Vinicius Schwartz - TI
		
		//Se for exportação e estiver concluído o palete
		If nTProd1 == '03' .And. nCPlt = 'SIM'
		
			//Filtra Qtde de VQ já produzidas
			cQry1 := " SELECT SUM (D3_QUANT) AS SOMA_VQ "
			cQry1 += " FROM SD3010 "
			cQry1 += " WHERE D3_FILIAL = '"+xFilial('SD3')+"' "
			cQry1 += " AND D3_X_NPLT = '"+cGetPlt+"' "
			cQry1 += " AND D3_CF = 'PR0' "
			cQry1 += " AND D_E_L_E_T_ <> '*' "
			
			If Select("TMPD3") > 0
				dbSelectArea("TMPD3")
		   		TMPD3->(dbCloseArea())
			Endif
	
			cQry1:= ChangeQuery(cQry1)
			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry1),"TMPD3",.T.,.T.)
	
			dbSelectArea("TMPD3")
			
			//Calculando qtde de tubos utilizados
			nQtdTub := (SC2->C2_QUANT+TMPD3->SOMA_VQ)/nMedTub
			nQtdTub := Round(nQtdTub,0)//Arredondamento

			//Grava qtde de tubos utilizados considerando qtde de vaquetas das OPs produzidas + qtde da OP atual
			cQry2 := " UPDATE "+RetSqlName ( 'SD4' )+" "
			cQry2 += " SET D4_QTDEORI = '"+cValToChar(nQtdTub)+"', D4_QUANT = '"+cValToChar(nQtdTub)+"' "
			cQry2 += " WHERE D4_OP = '"+cOP+"'+'"+cItem+"'+'"+cSeq+"' "
			cQry2 += " AND D4_COD IN ('020392','074642')"  ////Codigo do tubo de papelão
			cQry2 += " AND D_E_L_E_T_ <> '*' "
			nret1 := TcSqlExec( cQry2 )

		Endif
		
		//Se for exportação e não estiver concluído o palete
		If nTProd1 == '03' .And. nCPlt = 'NÃO'

			cQuery := " UPDATE "+ RetSqlName( 'SD4' ) +" "
			cQuery += " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
			cQuery += " WHERE D4_FILIAL = '"+xFilial('SD4')+"' "
			cQuery += " AND D4_OP = '"+cOP+"'+'"+cItem+"'+'"+cSeq+"' "
			cQuery += " AND D4_COD IN (SELECT B1_COD FROM SB1010 WHERE D_E_L_E_T_ <> '*' AND (B1_X_USEMB = 'S' OR B1_GRUPO = '19')) "
			cQuery += " AND D_E_L_E_T_ <> '*' "
			nret1 := TcSqlExec( cQuery )
			
		Endif
		
		dbGotop()
		dbSelectArea('SC2')
		dbSetOrder(1)
		dbSeek(xFilial('SC2')+cOP)

	//Prepara para fazer o apontamento da OP  
		// Adicionado AAdd D3_LOTECTL como correcao apontamentos com lote diferente partida (multiplas telas simultaneas) - Diego 20/10/2016
		PUTMV("MV_FORMLOT", "") //Limpa a formula do parametro para continuar com o padrao
		PUTMV("MA_LOTEMED", "") //Limpa a formula do parametro para continuar com o padrao	
	   //	Alert("Aviso2 - Lote: "+cLote)						
        aItens  := {}
			AAdd( aItens, {'D3_FILIAL'		,		 XFILIAL('SD3' ),nil 								})
			AAdd( aItens, {'D3_TM'			,		 '500' ,nil											})
			AAdd( aItens, {'D3_COD'			,		 SC2->C2_PRODUTO	,nil							})
			AAdd( aItens, {'D3_OP'			,		 SC2->(C2_NUM+C2_ITEM+C2_SEQUEN) ,nil         		})
			AAdd( aItens, {'D3_QUANT'		,	 	 SC2->(C2_QUANT-C2_QUJE),nil 					   	})
			AAdd( aItens, {'D3_LOCAL'		,		 SC2->C2_LOCAL	,nil								})
			AAdd( aItens, {'D3_DOC'			,		 'OP'+SC2->C2_NUM ,nil 								})
			AAdd( aItens, {'D3_EMISSAO'	    ,		 dDataBase ,nil										}) 
			AAdd( aItens, {'D3_X_SQPLT'	    ,		 nSeqPlt ,nil										})
			AAdd( aItens, {'D3_CC'			,		 '320101' ,nil										})
			AAdd( aItens, {'D3_CF'			,		 'PR0' ,nil											})
			AAdd( aItens, {'D3_PARCTOT'	    ,		 'T' ,nil										    })
			AAdd( aItens, {'D3_ATLOBS' 		, 		 'VSS_MSEC2', nil									})
			AAdd( aItens, {'D3_PARTIDA'	    ,	     SC2->C2_OPMIDO ,nil								}) 
			// Adicionado AAdd D3_LOTECTL como correcao apontamentos com lote diferente partida (multiplas telas simultaneas) - Diego 20/10/2016
			If Posicione("SB1",1,xFilial("SB1")+cGetCodPro,"B1_RASTRO") == 'L' 
			AAdd( aItens, {'D3_LOTECTL'	    ,	     cLote ,nil							   				}) 
			Endif
			
			lMsErroAuto := .f.
			msExecAuto({|x,Y| Mata250(x,Y)},aItens,3)
			PUTMV("MV_FORMLOT", "") //Limpa a formula do parametro para continuar com o padrao
			If lMsErroAuto
				MostraErro()
				AGF_ENVMAIL(cOP, SC2->C2_EMISSAO, cSayDesc1, SC2->C2_QUANT)
			else
				dbSelectArea('SD3')
				dbSetOrder(1)
				If SD3->(dbSeek(xFilial('SD3')+PADR(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN),14)+SC2->C2_PRODUTO))
					cOpDrw   := SC2->C2_NUM
					cNSeqDrw := SD3->D3_NUMSEQ
					RecLock('SD3',.F.)
					SD3->D3_QTDEM2 := cGetQtMM1  
					SD3->D3_MEDIAM2:= cMediaMed
					SD3->D3_X_QTI  := cGetQtVI1  
					SD3->D3_X_MT2I := cGetQtMI1
					SD3->D3_X_MD2I := Val(cSayMVI1)
					SD3->D3_X_FORN := Ret_For(nCFor)
					SD3->D3_X_APMET:= Val(cSayMed)

				//Normal ou Cartao Azul
				If nTProd2 == 2 
					SD3->D3_X_TPRD2 := 'A'
				Else
					SD3->D3_X_TPRD2 := 'N'
				Endif
				//Interna, Venda ou Externa
				If nTProd1 == '01'
					SD3->D3_X_TPROD := 'I'
				Else
					If nTProd1 == '02'
						SD3->D3_X_TPROD := 'V'
					Else
						SD3->D3_X_TPROD := 'E'
                        SD3->D3_X_VC := cGetCV
						SD3->D3_X_VD := cGetDV
						SD3->D3_X_VE := cGetEV
						SD3->D3_X_VER:= cGetERV
						SD3->D3_X_MC := cGetCM
						SD3->D3_X_MD := cGetDM
						SD3->D3_X_ME := cGetEM
						SD3->D3_X_MER:= cGetERM
						SD3->D3_X_VT := cSayTV
						SD3->D3_X_MT := cSayTM
						//Tipo de Caixa
						If nTCx == 2
							SD3->D3_X_TCX := 'N'
						Elseif nTCx == 1   
							SD3->D3_X_TCX := 'A' //Retorna para continuar gravacao
							Acrt_Plt(cGetPlt) //Chama funcao para acertar os outros paletes abertos
						EndIf
						SD3->D3_X_NPLT := cGetPlt
						SD3->D3_X_PLT := nCPlt
					EndIf

					///////////////////////////////////////////////////////////////////////////////////////
					//Alimentar informações da tabela SZC (drawback - Anesio 15/10/2014)
					///////////////////////////////////////////////////////////////////////////////////////
					if nTProd1 == "03" .and. lDrawBack
						ag_gravaSZC(cGetQtVI1, acFics, cGetCodPro, cOpDrw, cNSeqDrw)
					endif
				
				EndIf 
			endif
				MsUnLock('SD3')
				APMsgInfo(" OP Numero "+SC2->C2_NUM+" foi apontada com sucesso ")
				U_VSS_FICHMED(cOP)
//				AGF_ENVMAIL(cOP, SC2->C2_EMISSAO, cSayDesc1, SC2->C2_QUANT)	
			endif
		endif

oDlg1:End()
U_VSS_MSEC2()

Return


//////////////////////////////////////////////////////////////////////////////////
//Funcao para envio de e-mail em caso de erro no apontamento
//////////////////////////////////////////////////////////////////////////////////
Static Function AGF_ENVMAIL(cOP, dData, cDescProd, nQtde)

     Local _cEmlFor := 'jairson.ramalho@midoriautoleather.com.br,waldelino.junior@midoriautoleather.com.br'
     Local oProcess 
     Local oHtml
     Local nCont := 0
//	 RpcSetEnv("01","04","","","","",{"SRA"})
//     Alert('Iniciando envido e e-mail...')
     SETMV("MV_WFMLBOX","WORKFLOW") 
     oProcess := TWFProcess():New( "000004", "Problema com apontamento de OP - MEDIDEIRA" )
     oProcess:NewTask( "Problema com apontamento", "\WORKFLOW\HTM\ApontOP.HTM" )
     oHtml    := oProcess:oHTML
	 oHtml:ValByName("Data"			,dToc(dData))
	 oHtml:ValByName("numOP"   		,cOP)
	 
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	 aAdd( oHtml:ValByName( "it.desc" ), "HOUVE PROBLEMA NO APONTAMENTO DA ORDEM DE PRODUCAO "+Substr(cOP,1,6)+" DA MEDIDEIRA")
   	 aAdd( oHtml:ValByName( "it.desc" ), "PRODUTO: "+cDescProd )
   	 aAdd( oHtml:ValByName( "it.desc" ), "QUANTIDADE: "+cValToChar(nqtde) )
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	 aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
	 aAdd( oHtml:ValByName( "it.desc" ), "USUARIO QUE FEZ A INCLUSAO: "+substr(cUsuario,1,35))
   	 aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	 
   	    	                                 
oProcess:cSubject := "Problema com apontamento de OP - MEDIDEIRA - OP NUMERO: " + cOP



	oProcess:cTo      := _cEmlFor     


oProcess:Start()                    
	       //WFSendMail()
	       //WFSendMail()	       
oProcess:Finish()
//Alert('Email enviado com sucesso...')
Return


//////////////////////////////////////////////////////////////////////////////////
//Funcao para informar o nome de outro fornecedor                                 
//////////////////////////////////////////////////////////////////////////////////
Static Function Vld_OFor(NovFor)

If NovFor == '01'	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de cVariable dos componentes                                 ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	Private cOFor   := Space(40)
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oDlg3","oOFor","oGet1","oBtnOK")
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlg3      := MSDialog():New( 091,232,203,392,"Fornecedor",,,.F.,,,,,,.T.,,,.T. )
	oOFor      := TSay():New( 008,012,{||"Informe o Fornecedor:"},oDlg3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
	oGet1      := TGet():New( 020,008,{|u| If(PCount()>0, cOFor:=u, cOFor)},oDlg3,056,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oBtnOK     := TButton():New( 032,008,"OK",oDlg3,{|| oDlg3:End(),Nov_For(cOFor,NovFor)},056,012,,,,.T.,,"",,,,.F. )

	oDlg3:Activate(,,,.T.)  
	
EndIf

Return          

//Chamado pela funcao anterior (Vld_OFor) no botao OK
Static Function Nov_For(cOFor,NovFor)
	nFor:="01="+cOFor
	
	If NovFor == '01'
		cSayNovFor:=nFor
		oSayNovFor:Refresh()
	Else
		cSayNovFor:=Space(50)
		oSayNovFor:Refresh()
	Endif
Return

//////////////////////////////////////////////////////////////////////////////////
//Funcao que retorna o nome do fornecedor a ser gravado na tabela em vez do cod. do campo nCFor
//////////////////////////////////////////////////////////////////////////////////
Static Function Ret_For(cFor)
Public cNome

Do Case
	Case cFor == "00"
		cNome:=Space(50)
	Case cFor == "01"
		cNome:=cSayNovFor
	Case cFor == "02"
		cNome:="02=CUBATÃO"
	Case cFor == "03"
		cNome:="03=QUATRO PATAS"
	Case cFor == "04"
		cNome:="04=MINERVA"
	Case cFor == "05"
		cNome:="05=MARFRIG"
	Case cFor == "06"
		cNome:="06=VIPOSA"
	Case cFor == "07"
		cNome:="07=VANZELA"
	Case cFor == "08"
		cNome:="08=HUMAITÁ"		
EndCase

Return(cNome)  


//////////////////////////////////////////////////////////////////////////////////
//Funcao para calcular Num Palete
//////////////////////////////////////////////////////////////////////////////////
Static Function Num_Plt()
Public nMes

//Se caixa nova
If nTCx = 2
	//Encontrar ultimo palete
	cQry:= "	SELECT MAX(D3_X_NPLT) NPLT "
	cQry+= "	FROM SD3010 "
	cQry+= "	WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_COD = '"+cGetCodPro+"' AND SUBSTRING(D3_EMISSAO,1,6) = '"+Substr(DTOS(ddatabase),1,6)+"' AND D3_X_TCX = 'N' AND D_E_L_E_T_ = ''"
	
	If Select("TMPSD3") > 0
		dbSelectArea("TMPSD3")
		TMPSD3->(dbCloseArea())
	Endif
	
	cQry:= ChangeQuery(cQry)
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry),"TMPSD3",.T.,.T.)
	
	dbSelectArea("TMPSD3")      
	
	//Se nao existir nenhum palete no mes corrente
	If TMPSD3->NPLT == Space(14)
		Do Case
			Case Substr(DTOS(ddatabase),5,2) == "01"                                                 
				cGetPlt:= (Substr(DTOS(ddatabase),3,2)+"JAN"+cSiglaArt+"001")
			Case Substr(DTOS(ddatabase),5,2) == "02"
				cGetPlt:= (Substr(DTOS(ddatabase),3,2)+"FEV"+cSiglaArt+"001")
			Case Substr(DTOS(ddatabase),5,2) == "03"
				cGetPlt:= (Substr(DTOS(ddatabase),3,2)+"MAR"+cSiglaArt+"001")
			Case Substr(DTOS(ddatabase),5,2) == "04"
				cGetPlt:= (Substr(DTOS(ddatabase),3,2)+"ABR"+cSiglaArt+"001")
			Case Substr(DTOS(ddatabase),5,2) == "05"
				cGetPlt:= (Substr(DTOS(ddatabase),3,2)+"MAI"+cSiglaArt+"001")
			Case Substr(DTOS(ddatabase),5,2) == "06"
				cGetPlt:= (Substr(DTOS(ddatabase),3,2)+"JUN"+cSiglaArt+"001") 
			Case Substr(DTOS(ddatabase),5,2) == "07"
				cGetPlt:= (Substr(DTOS(ddatabase),3,2)+"JUL"+cSiglaArt+"001")      
			Case Substr(DTOS(ddatabase),5,2) == "08"
				cGetPlt:= (Substr(DTOS(ddatabase),3,2)+"AGO"+cSiglaArt+"001")
			Case Substr(DTOS(ddatabase),5,2) == "09"
				cGetPlt:= (Substr(DTOS(ddatabase),3,2)+"SET"+cSiglaArt+"001")
			Case Substr(DTOS(ddatabase),5,2) == "10"
				cGetPlt:= (Substr(DTOS(ddatabase),3,2)+"OUT"+cSiglaArt+"001")
			Case Substr(DTOS(ddatabase),5,2) == "11"
				cGetPlt:= (Substr(DTOS(ddatabase),3,2)+"NOV"+cSiglaArt+"001")
			Case Substr(DTOS(ddatabase),5,2) == "12"
				cGetPlt:= (Substr(DTOS(ddatabase),3,2)+"DEZ"+cSiglaArt+"001")
		EndCase   
		oGetPlt:Disable()
		oGetPlt:Refresh()
		GoTCx:Disable()
		oTCx:Disable()
		GoTCx:Refresh()
		oTCx:Refresh()		
	//Senao pega o ultimo palete e soma 1
	Else 
				//Alert(TMPSD3->NPLT) 
				//Alert(Len(TMPSD3->NPLT))
				//Alert(Len(Rtrim(TMPSD3->NPLT)))
		
		If Len(Rtrim(TMPSD3->NPLT)) = 12 //15JUNCRBL001 
			cGetPlt:=Substr(TMPSD3->NPLT,1,9) 	 
			cMax := Substr(TMPSD3->NPLT,10,3)
			nMax := Val(cMax)+1		
			cGetPlt := cGetPlt+StrZero(nMax,3)
		ElseIF Len(TMPSD3->NPLT) = 14	//15JUNCRWVBL001 
	   		cGetPlt:=Substr(TMPSD3->NPLT,1,11)     
			cMax := Substr(TMPSD3->NPLT,12,3)   
			nMax := Val(cMax)+1		
			cGetPlt := cGetPlt+StrZero(nMax,3)
		Endif
		
		oGetPlt:Disable()
		oGetPlt:Refresh()
		GoTCx:Disable()
		oTCx:Disable()
		GoTCx:Refresh()
		oTCx:Refresh()
	Endif 
Endif
           

If nTCx = 1	
	oGetPlt:Enable()
	oGetPlt:Refresh()	

Endif

Return


//////////////////////////////////////////////////////////////////////////////////
//Funcao para filtrar Pallets que ainda nao foram concluidos, essa funcao eh aplicada
//na consulta padrao chamada no campo D3_X_NPLT
//////////////////////////////////////////////////////////////////////////////////
User Function Plt_Concl()
	Local cD3Filter := ""
	cD3Filter += "@#"
	cD3Filter += "SD3->("
	cD3Filter += "D3_FILIAL == '"+xFilial("SD3")+"'"
	cD3Filter += " .AND. "
	cD3Filter += "DTOS(D3_EMISSAO) >= '"+Dtos(dDatabase-30)+"'"
//	cD3Filter += " .AND. "
//	cD3Filter += "D3_COD == '"+_cCod+"'"
	cD3Filter += " .AND. "
	cD3Filter += "D3_X_PLT == 'N'"
	cD3Filter += ")"
	cD3Filter += "@#"
Return (cD3Filter)
	
/*                             
Alert ('Chamou Plt_Concl !!!')
	
//Verifica se tabelas temporarias existem e se existir encerra as mesmas
If Select("TMPPLT") > 0
	dbSelectArea("TMPPLT")
	TMPPLT->(dbCloseArea())
Endif

cQry2:= " SELECT D3_X_NPLT, D3_EMISSAO "
cQry2+= " FROM SD3010 "
cQry2+= " WHERE D3_X_PLT = 'N' AND D3_X_NPLT <> '' AND D3_FILIAL = '"+xFilial("SD3")+"' AND D_E_L_E_T_ <> '*' AND D3_EMISSAO >= '"+dtos(dDatabase-10)+"' "
	

cQry2:= ChangeQuery(cQry2)
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry2),"TMPPLT",.T.,.T.)  

//Define campo data de emissao para o tipo data
TcSetField("TMPPLT", "D3_EMISSAO", "D")
	
//Arquivos temporario da funcao para geracao do relatorio
aTMP	:={}
//AADD(aTMP,{"D3_FILIAL"		, "C", 02, 0 } )
AADD(aTMP,{"D3_X_NPLT"		, "C", 06, 0 } )
AADD(aTMP,{"D3_EMISSAO"		, "D", 08, 0 } )
ctrTMP := CriaTrab(aTMP, .T.)
dbUseArea(.T.,,ctrTMP,"TMPLT",.F.,.F.)       

dbSelectArea("TMPPLT")
TMPPLT->(dbGoTop())
while !TMPPLT->(eof())
	dbSelectArea("TMPLT")
	RecLock("TMPLT",.T.)  
//	TMPLT->D3_FILIAL	:= TMPPLT->D3_FILIAL
	TMPLT->D3_X_NPLT  := TMPPLT->D3_X_NPLT
	TMPLT->D3_EMISSAO := TMPPLT->D3_EMISSAO
	Alert ('Palete: '+TMPLT->D3_X_NPLT)
	MsUnLock("TMPLT")
	TMPPLT->(dbSkip())
	incProc("Pesquisando Registros...")
enddo

Return
*/       

//////////////////////////////////////////////////////////////////////////////////
//Funcao para deixar somente a ultima OP aberta com com palete nao concluido,
//ou seja, "Caixa Aberta" com o campo igual a "N" (nao concluido)
//////////////////////////////////////////////////////////////////////////////////
Static Function Acrt_Plt(NumPlt)

 cQuery := "UPDATE "+ RetSqlName( 'SD3' ) + " "
 cQuery += "SET D3_X_PLT = 'S' "
 cQuery += "WHERE D3_X_NPLT = '"+NumPlt+"' AND D3_X_PLT = 'N' AND D3_FILIAL = '"+xFilial("SD3")+"' AND D_E_L_E_T_ <> '*' AND D3_EMISSAO >= '"+dtos(dDatabase-20)+"' "
 nret1 := TcSqlExec( cQuery )

Return

/*
Alert ('Chamou acerto de plt concluido')

//Verifica se tabelas temporarias existem e se existir encerra as mesmas
If Select("TMPPLT") > 0
	dbSelectArea("TMPPLT")
	TMPPLT->(dbCloseArea())
Endif

cQry2:= " SELECT D3_FILIAL, D3_X_NPLT, D3_X_PLT "
cQry2+= " FROM SD3010 "
cQry2+= " WHERE D3_X_NPLT = '"+NumPlt+"' AND D3_X_PLT = 'N' AND D3_FILIAL = '"+xFilial("SD3")+"' AND D_E_L_E_T_ <> '*' AND D3_EMISSAO >= '"+dtos(dDatabase-20)+"' "

cQry2:= ChangeQuery(cQry2)
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry2),"TMPPLT",.T.,.T.)  
dbGoTop()
While !Eof()                                   
   // Marca registros como concluido = "S"
   BEGIN TRANSACTION
   	DbSelectArea("SD3")
   	DBSetOrder(12)
   	If DbSeek(TMPPLT->D3_FILIAL + TMPPLT->D3_X_NPLT)
	Alert('Palete que sera concluido: '+TMPPLT->D3_X_NPLT)
   			Reclock("SD3",.F.)
   			SD3->D3_X_PLT := "S"
	   		MsUnlock()
   	Endif
   END TRANSACTION
   TMPPLT->(DbSkip())
Enddo
Alert('Alert antes do close area TMPPLT')
TMPPLT->(DbCloseArea())                 
Alert('Alert apos do close area TMPPLT')

Return
*/

//////////////////////////////////////////////////////////////////////////////////////////////
//Funcao para carregar os lotes disponiveis para apontamento....
//////////////////////////////////////////////////////////////////////////////////////////////
static function ag_chamalot(cProd)
if nTProd1 == "03" 
	ag_lotdrw(cProd)
endif

return 

static function ag_lotdrw(cProd)
local cQ32 		:= ""
local cQ35 		:= "" 
local aLtDrwD 	:= {}
local nPos	    := 0
local nSaldo  	:= 0



cGrpLt := Posicione("SB1", 1, xFilial("SB1")+cProd, "B1_X_35T32")

//////////////////////////////////////////////////////////////////////////////////////////////
//Query para filtrar os lotes de drawback do produto 
cQ32 := " Select ZC_LTDRAWB, SUM(ZC_QTDENTR-ZC_QTDSAID) SALDO from "+RetSqlName("SZC")+" with (nolock) " 
cQ32 += " where D_E_L_E_T_ =' ' and ZC_FILIAL ='"+xFilial("SZC")+"' " 
cQ32 += " and ZC_PRODUTO = '"+cGrpLt+"' " 
cQ32 += " and ZC_QTDENTR-ZC_QTDSAID > 0 " 
cQ32 += " GROUP by ZC_LTDRAWB " 
cQ32 += " order by 1 "

if Select("TMPZC") > 0 
	dbSelectArea("TMPZC")
	TMPZC->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", tcGenQry(, , cQ32), "TMPZC", .T., .T. )

//alert("query1 atualizada....")

//////////////////////////////////////////////////////////////////////////////////////////////
//Varrer a query dos lotes do produto do grupo 32 que será consumido e gravar no array
acFics := {}
nCount := 0
dbSelectArea("TMPZC")
TMPZC->(dbGotop())
while !TMPZC->(eof())
	AADD(acFics, {.F., TMPZC->ZC_LTDRAWB, TMPZC->SALDO }) 
	nCount++
	TMPZC->(dbSkip())	
enddo
//alert("CONTADOR -> "+cValToChar(nCount))
//acFics := aLtDrwD
obrfics:SetArray(acFics)
obrfics:bLine := { || { iif( acFics[obrfics:nAt,1], ook, oNo ) , acFics[obrfics:nAt,2],acFics[obrfics:nAt,3], }  }
obrfics:REfresh()
if nCount == 0 
	Alert('O produto informado não tem lote de drawback para dar continuidade!'+chr(13)+"Favor verificar antes de continuar!")
	oGetCodPro:SetFocus()
endif   

//alert("query1 encerrado....")
return aLtDrwD


//////////////////////////////////////////////////////////////////////////////////
//Funcao para emissao de segunda via do FichMed                                   
//////////////////////////////////////////////////////////////////////////////////
Static Function VSS_SEGVIA()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cBuscaOP   := Space(6)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg2","oBuscaOP","oGet1","oBtnprint")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg2      := MSDialog():New( 091,232,203,392,"Busca OP",,,.F.,,,,,,.T.,,,.T. )
oBuscaOP   := TSay():New( 008,012,{||"Informe o Num da OP:"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGet1      := TGet():New( 020,008,{|u| If(PCount()>0, cBuscaOP:=u, cBuscaOP)},oDlg2,056,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SC2","",,)
oBtnprint  := TButton():New( 032,008,"Imprimir",oDlg2,{|| oDlg2:End(),U_VSS_FICHMED(cBuscaOP)},056,012,,,,.T.,,"",,,,.F. )

oDlg2:Activate(,,,.T.)

Return

//////////////////////////////////////////////////////////////////////////////////
//Funcao para Gravar informacoes do lote de drawback consumido na tabela SZC
//////////////////////////////////////////////////////////////////////////////////
static function ag_gravaSZC(cGetQtVI1, acFics, cGetCodPro, cOpDrw, cNSeqDrw)
local nQtde := cGetQtVI1
local acFicAux := {}
local nQtdAux, i  := 0
 
for i:= 1 to len(acFics)
	if acFics[i][1]
		aadd( acFicAux, {acFics[i][1], acFics[i][2], acFics[i][3] })
	endif
next i

	for i:= 1 to len(acFicAux)
		dbSelectArea("SZC")
		dbSetOrder(2)
		if dbSeek(xFilial("SZC")+acFicAux[i][2])
			while !SZC->(eof()).and.SZC->ZC_LTDRAWB == acFicAux[i][2]
				if SZC->ZC_QTDENTR > SZC->ZC_QTDSAID
					if nQtde > SZC->(ZC_QTDENTR - ZC_QTDSAID) .and. nQtde > 0 //Caso a quantidade solicitada seja maior que o lote selecionado
						nQtdAux := SZC->(ZC_QTDENTR - ZC_QTDSAID)
						//Gravar informacoes na SZD - Consumo por lote
						RecLock("SZD",.T.)
						SZD->ZD_FILIAL  := xFilial("SZD")
						SZD->ZD_PRDCONS := cGetCodProd
						SZD->ZD_NUMOP   := cOpDrw
						SZD->ZD_LTDRAWB := SZC->ZC_LTDRAWB
						SZD->ZD_NSEQORI := SZC->ZC_NUMSEQ
						SZD->ZD_NUMSEQ  := cNSeqDrw
						SZD->ZD_QTDE    := nQtdAux 
						MsUnLock("SZD")
						//Gravar informacoes na SZC - Saldo por lote
						RecLock("SZC")
						SZC->ZC_QTDSAID := SZC->ZC_QTDENTR
						SZC->ZC_PRDCONS := AllTrim(SZC->ZC_PRDCONS)+cGetCodPro+"|"
						SZC->ZC_OP      := AllTrim(SZC->ZC_OP)+cOpDrw+"|"
						SZC->ZC_NSEQD   := AllTrim(SZC->ZC_NSEQD)+cNSeqDrw+"-"+PADL(nQtdAux,4,"0")+"|"
						MsUnLock("SCZ")
						nQtde -= nQtdAux
					else
						if nQtde > 0 
							//Gravar informacoes na SZD - Consumo por lote
							RecLock("SZD",.T.)
							SZD->ZD_FILIAL  := xFilial("SZD")
							SZD->ZD_PRDCONS := cGetCodProd
							SZD->ZD_NUMOP   := cOpDrw
							SZD->ZD_LTDRAWB := SZC->ZC_LTDRAWB
							SZD->ZD_NSEQORI := SZC->ZC_NUMSEQ
							SZD->ZD_NUMSEQ  := cNSeqDrw
							SZD->ZD_QTDE    := nQtde 
							MsUnLock("SZD")
							//Gravar informacoes na SZC - Saldo por lote
							RecLock("SZC",.F.)
							SZC->ZC_QTDSAID += nQtde
							SZC->ZC_PRDCONS := AllTrim(SZC->ZC_PRDCONS)+cGetCodPro+"|"
		   					SZC->ZC_OP      := AllTrim(SZC->ZC_OP)+cOpDrw+"|"
							SZC->ZC_NSEQD   := AllTrim(SZC->ZC_NSEQD)+cNSeqDrw+"-"+PADL(nQtde,4,"0")+"|"
							MsUnLock("SCZ")
							nQtde -= acFicAux[i][3]
						endif
					endif
				endif
				SZC->(dbSkip())
			enddo
		endif
	next i
return