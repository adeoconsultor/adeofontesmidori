#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MIDCINV2 ºAutor  ³ Antonio             º Data ³  29/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso.      ³Rotina de inclusao de Intervalo de Datas para Inventario.   º±±
±±º          MIDCINV2                                   				  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MIDCINV2()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Private cSayDTI    := dDatabase
Private cSayDTF    := dDatabase
Private cSayNoU    := Space(15)
Private cSayNoU1   := cUsuario
Private cSayCodU   := Space(15)
Private cSayCodU1  := RetCodUsr()
//Private cSayOP1    := 'INSERINDO...'
Private cSayProc   := Space(8)
Private SayMedSec  := ""

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oSayProc","oSayMedSec","oSayDTI","oSayDTI1","oSayDTF","oSayDTF2")
SetPrvt("oBtn1","oBtn2","oFont1","oFont2","oFont3")
SetPrvt("oPanel1","oSayNoU","oSayNoU1","oSayCodU","oSayCodU1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-14,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
oFont3     := TFont():New( "MS Sans Serif",0,-14,,.T.,0,,400,.F.,.F.,,,,,, )

cSayDTI    := SuperGetMV("MV_DTIINI",.F.,dDataBase)
cSayDTF    := SuperGetMV("MV_DTIFIM",.F.,dDataBase)

oDlg1      := MSDialog():New( 145,459,685,1185,"PERIODO DE DATAS A INVENTARIAR",,,.F.,,,,,,.T.,,oFont1,.T. )
oSayProc   := TSay():New( 003,003,{||"PROCESSO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,057,010)
oSayMedSec := TSay():New( 003,061,{||"INVENTARIO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,251,010)
oSayDTI    := TSay():New( 027,003,{||"DATA INICIAL:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,010)
oSayDTI1   := TGet():New( 027,058,{|u| If(PCount()>0,cSayDTI:=u,cSayDTI)},oDlg1,086,012,'',{|| Vld_Dti(cSayDTI) },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,,"cSayDTI",,)
oSayDTF    := TSay():New( 027,156,{||"DATA FINAL:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,010)
oSayDTF1   := TGet():New( 027,211,{|u| If(PCount()>0,cSayDTF:=u,cSayDTF)},oDlg1,086,012,'',{|| Vld_Dtf(cSayDTF) },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,,"cSayDTF",,)

oBtn2      := TButton():New( 242,256,"CONFIRMAR",oDlg1,{|| VSS_GRVDTA() },057,014,,oFont1,,.T.,,"",,,,.F. )
oBtn1      := TButton():New( 242,188,"CANCELAR",oDlg1,{|| oDlg1:End()},057,014,,oFont1,,.T.,,"",,,,.F. )
oPanel1    := TPanel():New( 257,000,"",oDlg1,,.F.,.F.,,,316,013,.T.,.F. )
oSayCodU   := TSay():New( 003,010,{||"CÓDIGO USUÁRIO:"},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,007)
oSayCodU1  := TSay():New( 003,053,{|u| If(PCount()>0, cSayCodU1:=u, cSayCodU1)},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,027,007)
oSayNoU    := TSay():New( 003,103,{||"NOME USUÁRIO:"},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,007)
oSayNoU1   := TSay():New( 003,143,{|u| If(PCount()>0, cSayNoU1:=u, cSayNoU1)},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,060,007)

oDlg1:Activate(,,,.T.)

Return
                      

                 

//////////////////////////////////////////////////////////////////////////////////
//Inicia validacoes e o processo de geracao da OP ao confirmar
//////////////////////////////////////////////////////////////////////////////////
Static Function VSS_GRVDTA()

If Empty(cSayDTI) .and. Empty(cSayDTF)
	Alert('Data Inicial ou Final não foi informada...')
	oSayDTI:SetFocus()
	Return
EndIf

//Grava datas no parametro
If !Empty(cSayDTI) .and. !Empty(cSayDTF)
	
	IncProc("Incluindo Datas a Inventariar -> ")
	
	If !Empty(GetMV("MV_DTIINI"))
		dbGotop()
		dbSelectArea('SX6')
		dbSetOrder(1)
		If dbSeek(xFilial('SX6')+'MV_DTIINI')
			RecLock("SX6",.F.)          
			SX6->X6_FIL      := xFilial("SX6")
			SX6->X6_CONTEUDO := DtoC(cSayDTI)
		EndIf
	Else
		RecLock("SX6",.T.)
		SX6->X6_FIL      := xFilial("SX6")
		SX6->X6_VAR      := 'MV_DTIINI'
		SX6->X6_TIPO     := 'D'
		SX6->X6_DESCRIC  := 'Data Inicial a inventariar'
		SX6->X6_CONTEUDO := DtoC(cSayDTI)
	EndIf

	MsUnLock("SX6")

	If !Empty(GetMV("MV_DTIFIM"))
		dbGotop()
		dbSelectArea('SX6')
		dbSetOrder(1)
		If dbSeek(xFilial('SX6')+'MV_DTIFIM')
			RecLock("SX6",.F.)          
			SX6->X6_FIL      := xFilial("SX6")
			SX6->X6_CONTEUDO := DtoC(cSayDTF)
		EndIf
	Else
		RecLock("SX6",.T.)
		SX6->X6_FIL      := xFilial("SX6")
		SX6->X6_VAR      := 'MV_DTIFIM'
		SX6->X6_TIPO     := 'D'
		SX6->X6_DESCRIC  := 'Data Final a inventariar'
		SX6->X6_CONTEUDO := DtoC(cSayDTF)
	EndIf

//	oSayOP1:Refresh()
//	oSayOP1 := TSay():New( 015,200,{|u| 'INSERINDO...' },oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,151,010)
//	oSayOP1:Refresh()
	APMsgInfo('Data Inserida com sucesso...')

EndIf

oDlg1:End()

Return          


//////////////////////////////////////////////////////////////////////////////////
//Valida Datas - 29/03/17
//////////////////////////////////////////////////////////////////////////////////
Static Function Vld_DTI(cSayDTI)

Local lRet := .T.

If cSayDTI > dDataBase
	
	oSayDTI1:Refresh()

	Alert('Data Inicial não pode ser maior que a data base!')
	oSayDTI1:SetFocus()

	lRet := .F.

EndIf             

Return lRet                                        


Static Function Vld_DTF(cSayDTF)

Local lRet := .T.

If cSayDTF < cSayDTI 
	
	oSayDTF1:Refresh()

	Alert('Data Final não pode ser menor que a data inicial!')
	oSayDTF1:SetFocus()

	lRet := .F.

EndIf             


Return lRet                                        
