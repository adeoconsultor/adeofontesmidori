#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VSS_MEDSECºAutor  ³ Vinicius Schwartz  º Data ³  27/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Projeto Tela Medideira Semi-Acabado                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso.      ³Rotina de inclusao de OP na Medideira Secagem.              º±±
±±º          ³Permite ao usuario selecionar um produto que contenha estru-º±±
±±º          ³tura, gera automaticamente a OP e faz o apontamento para o  º±±
±±º          ³mesmo automaticamente.                                      º±±
±±º          ³Solicitacao Thiago.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

User Function VSS_MEDSEC()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Private cGetCodFor := Space(30)
Private cGetCodPro := Space(6)
Private cGetLjFor  := Space(2)
Private cGetNPart  := Space(11)
Private cGetQtMI1  := 0
Private cGetQtMM1  := 0
Private cGetQtVI1  := 0
Private cGetQtVM1  := 0
Private cSayCodFor := Space(10)
Private cSayCodPro := Space(6)
Private cSayCodU   := Space(15)
Private cSayCodU1  := RetCodUsr()
Private cSayData   := Space(5)
Private cSayData1  := dDatabase
Private cSayDesc   := Space(10)
Private cSayDesc1  := Space(50)
Private cSayFor    := Space(10)
Private cSayFor1   := Space(11)
Private cSayGrupo  := Space(5)
Private cSayGrupo1 := Space(4)
Private cSayLjFor  := Space(4)
Private cSayLote   := Space(7)
Private cSayLote1  := Space(11)
Private cSayMedSec := Space(25)
Private cSayMVI    := Space(7)
Private cSayMVI1   := '0,00'
Private cSayMVM    := Space(7)
Private cSayMVM1   := '0,00'
Private cSayNoU    := Space(15)
Private cSayNoU1   := cUsuario
Private cSayNPart  := Space(12)
Private cSayOP     := Space(6)
Private cSayOP1    := 'INSERINDO...' // Soma1(GetSxeNum('SC2'))
Private cSayProc   := Space(8)
Private cSayQtMI   := Space(15)
Private cSayQtMM   := Space(15)
Private cSayQtVI   := Space(17)
Private cSayQtVM   := Space(17)
Private cSayUM     := Space(2)
Private cSayUM1    := Space(2) 
Private cSayArm	   := Space(10)
Private nTProd                
Private nCBoxArm

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlg1","oSayProc","oSayMedSec","oSayData","oSayData1","oSayOP","oSayOP1","oSayCodPro")
SetPrvt("oSayDesc1","oSayUM","oSayUM1","oSayGrupo","oSayGrupo1","oSayQtVM","oSayQtMM","oSayMVM","oSayMVM1")
SetPrvt("oSayQtMI","oSayMVI","oSayMVI1","oSayCodFor","oSayLjFor","oSayFor","oSayFor1","oSayNPart","oSayLote")
SetPrvt("oGetCodPro","oGetQtVM1","oGetQtMM1","oGetQtVI1","oGetQtMI1","oTProd","oGetCodFor","oGetLjFor")
SetPrvt("oBtn1","oBtn2","oPanel1","oSayCodU","oSayCodU1","oSayNoU","oSayNoU1","oCBoxArm","oBtn2Via","oSayArm")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oFont1     := TFont():New( "MS Sans Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 098,253,600,900,"Processo Medideira Semi-Acabado",,,.F.,,,,,,.T.,,,.T. )
oSayProc   := TSay():New( 005,004,{||"PROCESSO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,011)
oSayMedSec := TSay():New( 005,100,{||"MEDIDEIRA SEMI-ACABADO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,290,016)
oSayData   := TSay():New( 020,004,{||"DATA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,012)
oSayData1  := TSay():New( 020,036,{|u| If(PCount()>0, cSayData1:=u, cSayData1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,076,016)
oSayOP     := TSay():New( 020,128,{||"OP Nº"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,012)
oSayOP1    := TSay():New( 020,160,{|u| If(PCount()>0, cSayOP1:=u, cSayOP1) },oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,168,016)
oSayCodPro := TSay():New( 035,004,{||"CODIGO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,012)
oSayDesc   := TSay():New( 035,096,{||"DESCRIÇÃO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,232,012)
oSayDesc1  := TSay():New( 045,096,{|u| If(PCount()>0, cSayDesc1:=u, cSayDesc1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,250,016)
oSayUM     := TSay():New( 065,004,{||"UM"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,012)
oSayUM1    := TSay():New( 065,024,{|u| If(PCount()>0, cSayUM1:=u, cSayUM1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,060,016)
oSayGrupo  := TSay():New( 065,096,{||"GRUPO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,012)
oSayGrupo1 := TSay():New( 065,136,{|u| If(PCount()>0, cSayGrupo1:=u, cSayGrupo1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,064,016)
oSayQtVM   := TSay():New( 080,004,{||"QTD VQ S.A."},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,012)
oSayQtMM   := TSay():New( 080,108,{||"QTD M2 S.A."},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,012)
oSayMVM    := TSay():New( 080,232,{||"M2 / VQ"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,088,012)
oSayMVM1   := TSay():New( 090,232,{|u| If(PCount()>0, cSayMVM1:=u, cSayMVM1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,096,016)
oSayQtVI   := TSay():New( 110,004,{||"QTDE VQ WB/WW"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,096,012)
oSayQtMI   := TSay():New( 110,108,{||"QTD M2 WB/WW"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,096,012)
oSayMVI    := TSay():New( 110,232,{||"M2 / VQ"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,088,012)
oSayMVI1   := TSay():New( 120,232,{|u| If(PCount()>0, cSayMVI1:=u, cSayMVI1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,096,016)
oSayCodFor := TSay():New( 142,072,{||"FORNECEDOR"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,156,012)
//oSayLjFor  := TSay():New( 208,136,{||"LOJA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,012)
//oSayFor    := TSay():New( 208,172,{||"FORNECEDOR"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,156,016)
//oSayFor1   := TSay():New( 220,172,{|u| If(PCount()>0, cSayFor1:=u, cSayFor1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,156,016)
oSayNPart  := TSay():New( 175,004,{||"Nº PARTIDA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,160,016)
oSayLote   := TSay():New( 175,168,{||"Nº LOTE"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,160,012)
oSayLote1  := TSay():New( 185,168,{|u| If(PCount()>0, cSayLote1:=u, cSayLote1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,160,016)
oGetCodPro := TGet():New( 045,004,{|u| If(PCount()>0, cGetCodPro:=u, cGetCodPro)},oDlg1,072,014,'',{|| Vld_Prd(cGetCodPro)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetCodPro",,)
oGetQtVM1  := TGet():New( 090,004,{|u| If(PCount()>0, cGetQtVM1:=u, cGetQtVM1)},oDlg1,096,014,'@E 99,999,999.99',{|| RefreMedM(), CalcMedM(cGetQtMM1,cGetQtVM1)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtVM1",,)
oGetQtMM1  := TGet():New( 090,108,{|u| If(PCount()>0, cGetQtMM1:=u, cGetQtMM1)},oDlg1,096,014,'@E 99,999,999.99',{|| RefreMedM(), CalcMedM(cGetQtMM1,cGetQtVM1)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtMM1",,)
oGetQtVI1  := TGet():New( 120,004,{|u| If(PCount()>0, cGetQtVI1:=u, cGetQtVI1)},oDlg1,096,014,'@E 99,999,999.99',{|| RefreMedI(), CalcMedI(cGetQtMI1,cGetQtVI1)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtVI1",,)
oGetQtMI1  := TGet():New( 120,108,{|u| If(PCount()>0, cGetQtMI1:=u, cGetQtMI1)},oDlg1,096,014,'@E 99,999,999.99',{|| RefreMedI(), CalcMedI(cGetQtMI1,cGetQtVI1)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtMI1",,)
GoTProd    := TGroup():New( 140,004,170,064,"Tipo Produto",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oTProd     := TRadMenu():New( 148,010,{"NORMAL","CARTAO AZUL"},{|u| If(PCount()>0,nTProd:=u,nTProd)},oDlg1,,,CLR_BLACK,CLR_WHITE,"",,,040,20,,.F.,.F.,.T. )
oGetCodFor := TGet():New( 152,072,{|u| If(PCount()>0,cGetCodFor:=u,cGetCodFor)},oDlg1,156,014,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetCodFor",,)
//oGetLjFor  := TGet():New( 220,136,{|u| If(PCount()>0,cGetLjFor:=u,cGetLjFor)},oDlg1,028,014,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetLjFor",,)
oGetNPart  := TGet():New( 185,004,{|u| If(PCount()>0,cGetNPart:=u,cGetNPart)},oDlg1,160,014,'',{|| RefreLot(cGetNPart)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetNPart",,)
oSayCodFor := TSay():New( 142,236,{||"SEL. ARMAZEM"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,156,012)
oCBoxArm   := TComboBox():New( 154,236,{|u| If(PCount()>0,nCBoxArm:=u,nCBoxArm)},{"01 - Prod. Normal","04 - Prod. Venda"},072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"Selecione o Armazem",,,,,,,nCBoxArm )
oBtn2Via   := TButton():New( 216,004,"Imp. 2ª Via",oDlg1,{|| VSS_SEGVIA()},037,012,,,,.T.,,"",,,,.F. )
oBtn1      := TButton():New( 207,144,"CANCE&LAR",oDlg1,{|| oDlg1:End()},084,020,,oFont1,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 207,236,"&CONFIRMAR",oDlg1,{|| VSS_GEROP()},084,020,,oFont1,,.T.,,"",,,,.F. )
oPanel1    := TPanel():New( 230,-001,"",oDlg1,,.F.,.F.,,,332,016,.T.,.F. )
oSayCodU   := TSay():New( 004,012,{||"CODIGO USUARIO:"},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSayCodU1  := TSay():New( 004,064,{|u| If(PCount()>0, cSayCodU1:=u, cSayCodU1)},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSayNoU    := TSay():New( 004,124,{||"NOME USUARIO:"},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSayNoU1   := TSay():New( 004,172,{|u| If(PCount()>0, cSayNoU1:=u, cSayNoU1)},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,072,008)

oDlg1:Activate(,,,.T.)

Return                   

//Valida produto e se tem cadastro de estrutura
Static Function Vld_Prd(cCod)
local lRet := .F.
DbSelectArea('SB1')
DbSetOrder(1)

If DbSeek(xFilial('SB1') + cCod)
	cSayDesc1		:=SB1->B1_DESC
	cSayUM1			:=SB1->B1_UM
	cSayGrupo1		:=SB1->B1_GRUPO
	
	oSayDesc1:Refresh()
	oSayUM1:Refresh()
	oSayGrupo1:Refresh()
endif

lRet := SubStr(Posicione('SG1',1,xFilial('SG1')+cCod,'G1_COD'),1,6)==SubStr(cCod,1,6)

If !lRet
	Alert('O produto informado nao tem estrutura cadastrada!')
	oGetCodPro:SetFocus()
endif

return lRet   

//Valida Fornecedor
//Static Function Vld_CodFor(cFor)
//local lFor := .F.
//DbSelectArea('SA2')
//DbSetOrder(1)

//If DbSeek(xFilial('SA2') + cFor)
//	cGetLjFor	:=SA2->A2_LOJA
//	cSayFor1	:=SA2->A2_NREDUZ
	
//	oGetLjFor:Refresh()
//	oSayFor1:Refresh()
//endif

//Return

//Dispara Num Lote = Partida
Static Function RefreLot(cGetNPart)
public cLote := cGetNPart 	
	cSayLote1 := cLote
	oSayLote1:Refresh()
Return 

//Calculo de media da medideira
Static Function CalcMedM(cGetQtMM1,cGetQtVM1)    
public cMediaMed := 0
if cGetQtVM1 > 0
	cMediaMed := cGetQtMM1 / cGetQtVM1
	cSayMVM1 := cValToChar(cMediaMed)
else
	cMediaMed := 0 
	cSayMVM1 := cValToChar(cMediaMed)
endif
return       

Static Function RefreMedM()
	oSayMVM1:Refresh()
return

//Calculo de media inicial
Static Function CalcMedI(cGetQtMI1,cGetQtVI1)
public cMediaIni := 0
if cGetQtVI1 > 0
	cMediaIni := cGetQtMI1 / cGetQtVI1
	cSayMVI1 := cValToChar(cMediaIni)  
else
	cMediaIni := 0 
	cSayMVI1 := cValToChar(cMediaIni)
endif
return

Static Function RefreMedI()
	oSayMVI1:Refresh()
return    


//Inicia validacoes e o processo de geracao da OP ao confirmar
Static Function VSS_GEROP()
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
if nTProd == 2
	cGetQtVI1 := 0
	
	oGetQtVI1:Refresh()

elseif cGetQtVI1  == 0
	Alert('Quantidade de VQ Inicial não foi informada...')
	oGetQtVI1:SetFocus()
	Return
endif

//Valida Qtd inicial de M2 - Cartao Azul ou Normal
if nTProd == 2
	cGetQtMI1 := 0
	cSayMVI1 := '0,00'
	
	OSayMVI1:Refresh()
	oGetQtMI1:Refresh()

elseif cGetQtMI1  == 0
	Alert ('Quantidade de M² Inicial não foi informada...')
	oGetQtMI1:SetFocus()
	Return
endif


//Valida Num partida
if cGetNPart  == Space(11)
	Alert ('Nenhum número de partida foi informado...')
	oGetNPart:SetFocus()
	Return
endif

//Valida se eh cartao normal ou azul
//Normal informa fornecedor, Azul = 2 ignora
if nTProd == 2
	cGetCodFor := Space(30)
//	cGetLjFor := Space(02)
//	cSayFor1 := Space(50) 
	
	oGetCodFor:Refresh()
//	oGetLjFor:Refresh()
//	oSayFor1:Refresh()
elseif cGetCodFor == Space(30) 
	Alert ('Nenhum Fornecedor foi informado...')
	oGetCodFor:SetFocus()
	Return
//elseif cGetLjFor = Space(2)
//	Alert ('Nenhuma loja de fornecedor foi informada...')
//	oGetLjFor:SetFocus()
// 	Return
endif

//Valida armazem 01 ou 04
if nCBoxArm == '01 - Prod. Normal'
	public vArm := '01'
elseif nCBoxArm == '04 - Prod. Venda'
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
AAdd( aCab, {'C2_CC'			,		 '320202',nil 											})
AAdd( aCab, {'C2_DATPRI'	    ,		 dDataBase ,nil										})
AAdd( aCab, {'C2_DATPRF'		,		 dDataBase + 10,nil									})
AAdd( aCab, {'C2_OPMIDO'	    ,		 cGetNPart,		nil		  			       			})
AAdd( aCab, {'C2_EMISSAO'	    ,	     dDataBase,	nil										})
AAdd( aCab, {'C2_QTDLOTE'	    ,	     cGetQtVM1,			nil								})
AAdd( aCab, {'C2_OBS'		    ,		 cGetNPart,		nil		  			       			})
AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
AAdd( aCab, {"AUTEXPLODE"       ,        'S',NIL 										    })
	
	incProc("Gerando plano -> ")
	
	lMsErroAuto := .f.
	msExecAuto({|x,Y| Mata650(x,Y)},aCab,3)
	dbGotop()
	dbSelectArea('SC2')
	dbSetOrder(1)
	dbSeek(xFilial('SC2')+cNumOP)
	RecLock("SC2",.F.)
	SC2->C2_ITEMCTA := xFilial("SC2")
	MsUnLock("SC2")


	If lMsErroAuto
		RollBackSx8()
		MostraErro()
	else
		//ConfirmSx8()
		cSayOP1 := SC2->C2_NUM
		oSayOP1:Refresh()
		Alert('OP Inserida com sucesso...'+SC2->C2_NUM)
		cOP 	:= SC2->C2_NUM
		dbGotop()
		dbSelectArea('SC2')
		dbSetOrder(1)
		dbSeek(xFilial('SC2')+cOP)

//Prepara para fazer o apontamento da OP		
        aItens  := {}
			AAdd( aItens, {'D3_FILIAL'		,		 XFILIAL('SD3' ),nil 								})
			AAdd( aItens, {'D3_TM'			,		 '500' ,nil											})
			AAdd( aItens, {'D3_COD'			,		 SC2->C2_PRODUTO	,nil							})
			AAdd( aItens, {'D3_OP'			,		 SC2->(C2_NUM+C2_ITEM+C2_SEQUEN) ,nil         		})
			AAdd( aItens, {'D3_QUANT'		,	 	 SC2->(C2_QUANT-C2_QUJE),nil 					   	})
			AAdd( aItens, {'D3_LOCAL'		,		 SC2->C2_LOCAL	,nil								})
			AAdd( aItens, {'D3_DOC'			,		 'OP'+SC2->C2_NUM ,nil 								})
			AAdd( aItens, {'D3_EMISSAO'	    ,		 dDataBase ,nil										})
			AAdd( aItens, {'D3_CC'			,		 '320202' ,nil											})
			AAdd( aItens, {'D3_CF'			,		 'PR0' ,nil											})
			AAdd( aItens, {'D3_PARCTOT'	    ,		 'T' ,nil										    })
			AAdd( aItens, {'D3_PARTIDA'	    ,	     SC2->C2_OPMIDO ,nil								})
			lMsErroAuto := .f.
			msExecAuto({|x,Y| Mata250(x,Y)},aItens,3)

			If lMsErroAuto
				MostraErro()
				AGF_ENVMAIL(cOP, SC2->C2_EMISSAO, cSayDesc1, SC2->C2_QUANT)
			else
				dbSelectArea('SD3')
				dbSetOrder(1)
				dbSeek(xFilial('SD3')+PADR(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN),13)+SC2->C2_PRODUTO)
				RecLock('SD3',.F.)
				SD3->D3_QTDEM2 := cGetQtMM1  
				SD3->D3_MEDIAM2:= cMediaMed
				SD3->D3_X_QTI  := cGetQtVI1  
				SD3->D3_X_MT2I := cGetQtMI1
				SD3->D3_X_MD2I := Val(cSayMVI1)
				SD3->D3_X_FORN := cGetCodFor             
				MsUnLock('SD3')
				APMsgInfo(" OP Numero "+SC2->C2_NUM+" foi apontado com sucesso ")
				U_VSS_FICHMED(cOP)
//				AGF_ENVMAIL(cOP, SC2->C2_EMISSAO, cSayDesc1, SC2->C2_QUANT)	
			endif
		endif

oDlg1:End()
U_VSS_MEDSEC()
Return

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