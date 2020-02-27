#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "topconn.ch"

#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

///////////////////////////////////////////////////////////////////////////////
//Rotina para geracao de PLANOS 
//Este programa vai fazer a geracao de planos de pecas baseado no Kit lancado
//O objetivo eh desativar o parametro MV_GERAOPI "Gera OP do produto Intermediario a Partir de OP do Produto Principal" 
//e assim gerar OPs apenas das pecas, caso precise apontar o Kit, o mesmo de devera ser lancado em OP posterior.
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br -03-05-2012
///////////////////////////////////////////////////////////////////////////////
User Function DM_PLANOS()


//Declaracao de Variaveis

Private cCadastro := "Digita��o de Planos para Costura"


PRIVATE aRotina	:= {}
AaDd( aRotina	,	{"&Pesquisar"            		,"aXPesqui"	,0,1,0,.f.} )
AaDd( aRotina	,	{'&Visualizar ' 				,"AxVisual"	,0,2,0,.f.} ) 
AaDd( aRotina	,	{'&Incluir' 	      		    ,"U_DM_INCPLN()" ,0,3,0,.f.} )
AaDd( aRotina   ,   {'&Alterar'                     ,"U_DM_ALTPLN()" ,0,4,0,.f.} )
AaDd( aRotina   ,   {'&Excluir'						,"u_exclPL_COS()",0,5,0,.f.})
AaDd( aRotina	,	{'&Legenda '					,"u_Mid_LegPlP"   ,0,5,0,.f.} )
             
             

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZP"

dbSelectArea("SZP")
dbSetOrder(1)
//dbSeek(xFilial("SZP"

dbSelectArea(cString)


mBrowse( 6,1,22,75,cString,,"ZP_NUM")

Return


///////////////////////////////////////////////////////////////////////////////
//Rotina para inclusao de planos novos...
///////////////////////////////////////////////////////////////////////////////
User Function DM_INCPLN()
///////////////////////////////////////////////////////////////////////////////
// Declaracao de Variaveis dos componentes                                   //
///////////////////////////////////////////////////////////////////////////////
Private cN1     := space(2)// Varialvel que serah utilizada para informar se o KIT tem Componente CM ou apenas Pecas PC
Private cGetCodKit := Space(6)
Private cGetCCusto := Space(9)
Private nGetQtde   := 0
Private nGetMult   := 0
Private cGetCodCli := Space(6)
Private cGetLjCli  := Space(2)
Private cGetNomeCli:= Space(50)
Private cGetDescPr := Space(50)
Private cGetDtEmis := dDatabase //CTOD('  /  /  ')
Private cGetDtEntr := CTOD('  /  /  ')
Private cGetDtIni  := dDataBase //CTOD('  /  /  ')
Private cGetObs    := Space(30)
Private cGetLocal  := '01'
Private cGetPlano  := Space(20)
Private cGetUmPrd  := Space(2)
Private cGetRelea  := Space(20)
Private nCBoxLado  := ' ' 
Private lCBoxParc  := .F.
Private cGetStatus := 'INSERINDO...'
/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
SetPrvt("oFont3","oFont4","oFont2","oFont1","oDlg1","oGrpModelo","oCodKit","oCodKit","oSayUm","oGetDescPr")
SetPrvt("oGetUmPrd","oGrpEntrega","oSayPlano","oSayLocal","oSayCCusto","oSayMultp","oSayQtde","oSayConsLado")
SetPrvt("oGetLocal","oGetCCusto","oGetQtde","oGetMultp","oCBoxLado","oGrpDts","oSayDtIni","oSayDtEntrega","oSayDtEmissao")
SetPrvt("oGetDtIni","oGetDtEntrega","oGetDtEmissao","oGetObs","oGrpModel","oSayNomCli","oSayCodCli","oSayLjCli")
SetPrvt("oGetCodCli","oGetRelea","oBtnGerPln","oBtnFechar","oCBoxParc","oBtnGerPln","oBtnFechar", "oGetStatus")

/*������������������������������������������������������������������������ٱ�
�� Definicao do Dialog e todos os seus componentes.                        ��
ٱ�������������������������������������������������������������������������*/
//cEmpAnt := '01'
//RpcSetType(3)
//RpcSetEnv(cEmpAnt, xfilial('SZP'),,,,, { "SG1", "SB1", "SC2", "SZP"	 } )

oFont3     := TFont():New( "MS Sans Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oFont4     := TFont():New( "Times New Roman",0,-15,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oFont1     := TFont():New( "MS Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 105,332,671,1071,"Gera��o de Planos - Costura",,,.F.,,,,,,.T.,,,.T. )
oGrpModelo := TGroup():New( 004,004,056,360,"Modelo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayCodKit := TSay():New( 012,008,{||"C�digo do Kit:"},oGrpModelo,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,012)
oSayDescKit:= TSay():New( 012,081,{||"Descri�ao do Kit"},oGrpModelo,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,079,012)
oSayUm     := TSay():New( 012,325,{||"UM"},oGrpModelo,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,012)
oGetDescPr := TGet():New( 024,080,{|u| If(PCount()>0,cGetDescPr:=u,cGetDescPr)},oGrpModelo,244,014,'',,CLR_BLACK,CLR_LIGHTGRAY,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDescPr",,)
oGetDescPr:Disable()
oGetCodKit := TGet():New( 024,008,{|u| If(PCount()>0,cGetCodKit:=u,cGetCodKit)},oGrpModelo,056,014,'',{|| Vld_Kit_COS()} ,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetCodKit",,)
oGetUmPrd  := TGet():New( 024,326,{|u| If(PCount()>0,cGetUmPrd:=u,cGetUmPrd)},oGrpModelo,023,014,'',,CLR_BLACK,CLR_LIGHTGRAY,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetUmPrd",,)
oGetUmPrd:Disable()
oGrpEntreg := TGroup():New( 060,004,116,360,"Dados do Plano...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayPlano  := TSay():New( 072,008,{||"Num Plano"},oGrpEntrega,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oSayLocal  := TSay():New( 072,141,{||"Armazem"},oGrpEntrega,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oSayCCusto := TSay():New( 072,234,{||"C.Custo"},oGrpEntrega,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oSayQtde   := TSay():New( 097,008,{||"Quantidade"},oGrpEntrega,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oSayMultp  := TSay():New( 097,141,{||"Multiplos"},oGrpEntrega,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,047,012)
oSayConsLa := TSay():New( 096,230,{||"Cons.Lado"},oGrpEntrega,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,047,012)
oGetPlano  := TGet():New( 068,060,{|u| If(PCount()>0,cGetPlano:=u,cGetPlano)},oGrpEntrega,076,014,'@!',{|| iif(VldNumPln(cGetPlano),oGetLocal:SetFocus(),oGetPlano:SetFocus())},CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetPlano",,)
oGetLocal  := TGet():New( 068,189,{|u| If(PCount()>0,cGetLocal:=u,cGetLocal)},oGrpEntrega,031,014,'',{|| U_DM_LOC() },CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetLocal",,)
oGetCCusto := TGet():New( 068,276,{|u| If(PCount()>0,cGetCCusto:=u,cGetCCusto)},oGrpEntrega,060,014,'@!',{|| CTB105CC()},CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CTT","cGetCCusto",,)
oGetQtde   := TGet():New( 093,060,{|u| If(PCount()>0,nGetQtde:=u,nGetQtde)},oGrpEntrega,076,014,'@E 99,999,999.99',{|| U_DM_QTDE() },CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtde",,)
oGetMultp  := TGet():New( 093,189,{|u| If(PCount()>0,nGetMult:=u,nGetMult)},oGrpEntrega,031,014,'@E 9,999',{|| U_DM_MULT() },CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetMult",,)
oCBoxLado  := TComboBox():New( 094,280,{|u| If(PCount()>0,nCBoxLado:=u,nCBoxLado)},{"Nao","Sim"},060,016,oGrpEntrega,,,,CLR_BLACK,CLR_WHITE,.T.,oFont2,"",,,,,,,nCBoxLado )
oGrpDts      := TGroup():New( 120,004,176,360,"Datas de Producao...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayDtIni  := TSay():New( 132,008,{||"Previsao Ini"},oGrpDts,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oSayDtEntr := TSay():New( 132,128,{||"Entrega"},oGrpDts,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,012)
oSayDtEmis := TSay():New( 132,231,{||"DT Emissao"},oGrpDts,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oSayObs    := TSay():New( 157,008,{||"Observa��o"},oGrpDts,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oGetDtIni  := TGet():New( 128,061,{|u| If(PCount()>0,cGetDtIni:=u,cGetDtIni)},oGrpDts,064,014,'@r 99/99/9999',{|| ! empty( cGetDtIni )},CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDtIni",,)
oGetDtEntr := TGet():New( 128,164,{|u| If(PCount()>0,cGetDtEntr:=u,cGetDtEntr)},oGrpDts,064,014,'@r 99/99/9999',{|| ! empty( cGetDtEntr )},CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDtEntr",,)
oGetDtEmis := TGet():New( 128,285,{|u| If(PCount()>0,cGetDtEmis:=u,cGetDtEmis)},oGrpDts,064,014,'@r 99/99/9999',{|| ! empty( cGetDtEmis )},CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDtEmis",,)
oGetObs    := TGet():New( 153,060,{|u| If(PCount()>0,cGetObs:=u,cGetObs)},oGrpDts,289,014,'@!',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetObs",,)
oGrpModel  := TGroup():New( 177,004,240,360,"Modelo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayNomCli := TSay():New( 185,088,{||"Nome do Cliente"},oGrpModel,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,079,012)
oSayCodCli := TSay():New( 185,008,{||"Cliente"},oGrpModel,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,012)
oSayLjCli  := TSay():New( 185,062,{||"Loja"},oGrpModel,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,027,012)
oSayRelea  := TSay():New( 225,008,{||"Release"},oGrpModel,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oGetCodCli := TGet():New( 197,008,{|u| If(PCount()>0,cGetCodCli:=u,cGetCodCli)},oGrpModel,036,014,'',{|| DM_BUSCACLI() },CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1","cGetCodCli",,)
oGetLjCli  := TGet():New( 197,062,{|u| If(PCount()>0,cGetLjCli:=u,cGetLjCli)},oGrpModel,014,014,'',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetCodCli",,)
oGetNomeCl := TGet():New( 197,087,{|u| If(PCount()>0,cGetNomeCli:=u,cGetNomeCli)},oGrpModel,265,014,'',,CLR_BLACK,CLR_LIGHTGRAY,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetNomeCli",,)
oCBoxParc  := TCheckBox():New( 221,290,"PARCIAL",{|u| If(PCount()>0,lCBoxParc:=u,lCBoxParc)},oGrpModel,080,012,,{|| vldGPParc(lCBoxParc) },oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oGetNomeCli:Disable()
oGetRelea  := TGet():New( 221,054,{|u| If(PCount()>0,cGetRelea:=u,cGetRelea)},oGrpModel,120,014,'@!',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetRelea",,)
oGetStatus := TGet():New( 221,176,{|u| If(PCount()>0,cGetStatus:=u,cGetStatus)},oGrpModel,110,014,'@!',,CLR_BLACK,CLR_YELLOW,oFont2,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cGetStatus",,)
oGetStatus:Disable()
oBtnGerPln := TButton():New( 249,268,"Gerar Plano",oDlg1,{|| VLDGer('INC') },090,020,,oFont3,,.T.,,"",,,,.F. )
oBtnPcs    := TButton():New( 249,166,"Inserir Pe�as",oDlg1,{||iif(lCBoxParc, {SalvaPln_COS(), ICPC(cGetCodKit)},Alert('Plano Parcial nao ativado!')) },090,020,,oFont3,,.T.,,"",,,,.F. )
oBtnPcs:Disable()
oBtnFechar := TButton():New( 249,066,"Cancelar",oDlg1,{|| oDlg1:end()},090,020,,oFont3,,.T.,,"",,,,.F. )
//oBtnFechar := TButton():New( 249,066,"Cancelar",oDlg1,{|| CancPRoc()},090,020,,oFont3,,.T.,,"",,,,.F. )
//oBtnFechar  := SButton():New( 249,066,2,{|| CancPRoc()}, oDlg1 ,,"",)



oDlg1:Activate(,,,.T.)
Return
                      

Static Function CancProc_COS()
Close(   oDlg1 )
Return()


Static Function Vld_Kit_COS()
local lRet := .T.
local cKitBloc := GetMv ("MA_KITBLOC")

if ALLTRIM(cGetCodKit) $ cKitBloc
	Alert("O Produto "+Alltrim(cGetCodKit)+" est� bloqueado para inserir planos..."+chr(13)+"Favor consultar PPCP")
	Return .F.
endif

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+cGetCodKit)
if SB1->B1_UM <> 'KT' .and.Substr(SB1->B1_COD,1,6) <> '002424' 
	if !APMSGNOYES('O codigo informado nao pertence � KIT!'+chr(13)+'Deseja continuar ? ','ATENCAO...')
		Alert('O Codigo informado nao esta na estrutura como KIT'+chr(13)+'Favor verificar')
		lRet := .F.
		oGetCodKit:SetFocus()
	else
		cGetDescPr := SB1->B1_DESC
		cGetUmPrd  := SB1->B1_UM
//		cGetLocal  := SB1->B1_LOCPAD
//		cGetCCusto := '324' 
	//	nQtde      := 5
		Atu_Lado()
		oGetDescPr:Refresh() 
		oGetUmPrd:Refresh()
		oGetLocal:Refresh() 
		oGetCCusto:Refresh()
		oCBoxLado:Refresh()
		oGetPlano:SetFocus()
	endif
else
	cGetDescPr := SB1->B1_DESC
	cGetUmPrd  := SB1->B1_UM
//	cGetLocal  := SB1->B1_LOCPAD
//	cGetCCusto := '324' 
//	nQtde      := 5
	Atu_Lado()
	oGetDescPr:Refresh() 
	oGetUmPrd:Refresh()
	oGetLocal:Refresh() 
	oGetCCusto:Refresh()
	oCBoxLado:Refresh()
	oGetPlano:SetFocus()
 endif
return lRet


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Funcao para verificar se o Acabado digitado considera lado na linha de producao...
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static function Atu_Lado()
local lLado := .F. 
local aProd := {}
local aPeca := {}
local aMaterial := {}
Local ip
Local im
Local i

cN1 := 'CM' //space(2)
cQuery:= "SELECT G1_COMP FROM SG1010 WHERE D_E_L_E_T_ = ' ' AND G1_FILIAL='"+xFilial("SG1")+"' AND G1_COD = '"+cGetCodKit+"' " 
	if select('TRBG1') > 0
		DbSelectArea( 'TRBG1' )
		DbCloseArea()
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBG1',.T.,.T. )

	dbSelectArea("TRBG1")
	DbGoTop()
    while !TRBG1->(eof())
    	lLado:= Posicione("SB1",1,xFilial("SB1")+TRBG1->G1_COMP,"B1_LADO") $ 'A|B'
    	AADD(aProd, {TRBG1->G1_COMP})
    	TRBG1->(dbSkip())
    enddo 
    for ip := 1 to len(aProd)
		dbSelectArea('SG1')
		dbSetOrder(1)
		dbSeek(xFilial('SG1')+aProd[ip][1])
			while !SG1->(eof()).and.SG1->G1_FILIAL == xFilial('SG1').and.SG1->G1_COD == aProd[ip][1]
				AADD(aPeca, {SG1->G1_COMP})	
				SG1->(dbSkip())
			enddo
	next ip
	for im := 1 to len(aPeca)
		dbSelectArea('SG1')
		dbSetOrder(1)
		dbSeek(xFilial('SG1')+aPeca[im][1])
			while !SG1->(eof()).and.SG1->G1_FILIAL == xFilial('SG1').and.SG1->G1_COD == aPeca[im][1]
				AADD(aMaterial, {SG1->G1_COMP})	
				SG1->(dbSkip())
			enddo
	next im	
    if !lLado
	    for i:=1  to len(aProd)
    		dbSelectArea('SG1')
    		dbSetOrder(1)
	    	dbSeek(xFilial('SG1')+aProd[i][1])
    		while !SG1->(eof()).and.SG1->G1_COD == aProd[i][1]
				if !lLado
					lLado := Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_LADO") $ 'A|B'
				endif
    		SG1->(dbSkip())
    	   	enddo
    	 next i
    endif
	if len(aMaterial) > 0
//		Alert("MATERIAL")
		cN1 := 'PC'     
    else
    	cN1 := 'CM' 
    endif

//Alert('Nivel-> ' +cN1)
if lLado 
//	Alert('Considera lado-> '+nCBoxLado)
	nCBoxLado := 'Sim'
else
//	Alert('Nao considera lado')
	nCBoxLado := 'Nao' 
endif
return

///////////////////////////////////////////////////////////////////////////////
//Rotina para validar o armazem selecionado, so permite 01, 02 e 03
//Parametro MA_LOCVLD para informar quais armazens poderao receber produtos acabados
///////////////////////////////////////////////////////////////////////////////
user function DM_LOC()
local lRet := .T.
local cLocVld := GetMv ('MA_LOCVLD')
if !cGetLocal $ cLocVld
	Alert('Armazem nao permitido'+chr(13)+'Permitido apenas armazem '+AllTrim(cLocVld))
	lRet := .F.
	oGetLocal:SetFocus()
endif
return lRet

///////////////////////////////////////////////////////////////////////////////
//Rotina para validar a quantidade digitada, nao permitir ser menor q 0
///////////////////////////////////////////////////////////////////////////////
user function DM_QTDE()
local lRet := .T.
if nGetQtde <= 0
	Alert('Quantidade nao pode ser menor que zero')
	lRet := .F.
	oGetQtde:SetFocus()
endif
return lRet

///////////////////////////////////////////////////////////////////////////////
//Rotina para validar os multiplos de fichas
///////////////////////////////////////////////////////////////////////////////
user function DM_MULT()
local lRet := .T.
if nGetMult < 1 
	Alert('Multiplos nao pode ser menor que 1')
	lRet := .F.
	oGetMultp:SetFocus()
endif
if nGetMult > nGetQtde
	Alert('Multiplos nao pode ser maior que a quantidade')
	lRet := .F.
	oGetMultp:SetFocus()
endif
return lRet

///////////////////////////////////////////////////////////////////////////////
//Rotina para buscar e preencher o codigo do cliente....
///////////////////////////////////////////////////////////////////////////////
static function DM_BUSCACLI()
local lRet := .T.
if cGetCodCli <> space(6)
	dbSelectArea('SA1')
	dbSetOrder(1)
	dbSeek(xFilial('SA1')+cGetCodCli)
	if cGetLjCli == space(2)
		cGetLjCli := SA1->A1_LOJA
		oGetLjCli:Refresh()
	endif
	dbSeek(xFilial('SA1')+cGetCodCli+cGetLjCli)
	cGetNomeCli := SA1->A1_NOME
	oGetNomeCl:Refresh()
else
	Alert('Favor preencher o codigo do cliente')
	lRet := .F.
	oGetCodCli:SetFocus()
endif
return lRet

///////////////////////////////////////////////////////////////////////////////
//Rotina para validar os apontamentos...
///////////////////////////////////////////////////////////////////////////////
static function VLDGer(cIncAlt)
if lCBoxParc
//	Alert('Rotina de plano parcial ainda nao disponivel....')
	if Select('TMPZH') > 0
		dbSelectArea('TMPZH')
		TMPZH->(dbCloseArea())
	endif
	cQZH := " SELECT ZH_PLANO FROM SZH010 WHERE D_E_L_E_T_ = ' ' AND ZH_FILIAL = '"+xFilial("SZH")+"' AND SUBSTRING(ZH_DATA,1,4) = '"+SUBSTR(DTOS(cGetDtEmis),1,4)+"' "
	cQZH += " AND ZH_PLANO = '"+cGetPlano+"' " 

	dbUseArea(.T.,"TOPCONN",tcGenQry(,, cQZH ),"TMPZH",.T.,.T. )
 	nCount:= 0
 	dbSelectArea('TMPZH')
 	dbGotop()
 	while !TMPZH->(eof())
 		nCount++
 		TMPZH->(dbSkip())
 	enddo   
	if nCount > 0 		
		Processa({|| GERAPARCIAL_COS(cN1,cIncAlt)},"Aguarde","Gravando plano parcial....", .T.)
	else
		Alert('Voc� selecionou plano parcial porem n�o digitou nenhuma pe�a!'+chr(13)+'Favor verificar.')
	endif
else
	if Vld_Kit_COS()
		if 	U_DM_LOC()	
			if U_DM_QTDE()
				if U_DM_MULT()
					if  DM_BUSCACLI()	
						//Aqui vai chamar a funcao para gerar as OPS
//						Alert('Pronto para gerar o plano....'+cN1)
//						Processa({|| GERPLANOS_COS(cN1)},"Gravando plano.......")
						Processa({|| GERPLANOS_COS(cN1,cIncAlt)},"Aguarde", "Gravando plano.......", .T.)
					endif
				endif
			endif
		endif
	endif
endif
return 

///////////////////////////////////////////////////////////////////////////////
//Rotina para gerar as ordens de producao baseado no plano
//Execudada quando o plano � gerado total pelo KIT
///////////////////////////////////////////////////////////////////////////////
static function GERPLANOS_COS(cN1,cIncAlt)

//local nGetMult := 10
local aStru1 := {}
local aStru2 := {}
local cQuery := ""
local lPc	 := .F. //Variavel que identifica se o item lancado eh peca direto na tela principal
local cKtCort :=GetMV( 'MA_KTCORT')+GetMV( 'MA_KTCORT2')
local cKtNew  := GetMV( 'MA_KTNEW' )+GetMV( 'MA_KTNEW1' )+GetMV( 'MA_KTNEW2' ) //Variavel para conter os produtos que j� estao reestruturado [para o novo modelo de corte
local nCtOP  := 1
local _cOpc := "" 
local nCount := 0
Local i
Local ixop

if cIncAlt == 'ALT'
	u_excALT_COS()
else 
	SalvaPln_COS()
endif


	cQuery := " SELECT G1_COMP, G1_QUANT, G1_OPC FROM SG1010 SG1, SB1010 SB1 WHERE SG1.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' " 
	cQuery += " AND G1_FILIAL='"+xFilial("SG1")+"' "
	cQuery += " AND G1_COMP = B1_COD "//AND B1_DESC not like '%DUBLAD%' "
	cQuery += " AND G1_COD = '"+cGetCodKit+"' AND SUBSTRING(G1_COMP,1,3) <> 'MOD' " 
	cQuery += " AND G1_INI <= '"+dTos(cGetDtEmis)+"' AND G1_FIM >= '"+dTos(cGetDtEmis)+"' "
	if select('TRBG1') > 0
		DbSelectArea( 'TRBG1' )
		DbCloseArea()
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBG1',.T.,.T. )

	dbSelectArea("TRBG1")
	DbGoTop()

	if alltrim(cGetCodKit) $ cKtNew
	    while !TRBG1->(eof())
	    	//Alert(TRBG1->G1_COMP)
    		AADD(aStru1, {TRBG1->G1_COMP, TRBG1->G1_QUANT, TRBG1->G1_OPC})
    		TRBG1->(dbSkip())
	    enddo 
	    aStru2 := aStru1
	else

			//	//Verifica se o item empenhado eh material do grupo 16,40 ou 48 e gera Ordem de Producao do item lancado...
			//	Alert('COMPONENTE: '+TRBG1->G1_COMP+' GRUPO-> '+Posicione('SB1',1,xFilial('SB1')+TRBG1->G1_COMP,"B1_GRUPO"))
				if Posicione('SB1',1,xFilial('SB1')+TRBG1->G1_COMP,"B1_GRUPO") $ '16  |40  |48  '
					AADD(aStru2, {cGetCodKit, nGetQtde})                                         
			//		Alert('Adicionado no array...')
					cN1 := 'PC1'
					lPc := .T.
				else
					
				    while !TRBG1->(eof())
			    		AADD(aStru1, {TRBG1->G1_COMP, TRBG1->G1_QUANT, TRBG1->G1_OPC})
			//    		Alert("Add... "+ALLTRIM(TRBG1->G1_COMP))
			    		TRBG1->(dbSkip())
				    enddo 
				endif
			//    Alert('Iniciar geracao '+cN1)
			nCount:=1
			cVldStru := ""
			ProcRegua(0)
			if cN1 == 'PC' .or. cGetCodKit == '051314' .or. alltrim(cGetCodKit) $ cKtCort
				for i:=1  to len(aStru1)
			   		dbSelectArea('SG1')
			   		dbSetOrder(1)
				   	dbSeek(xFilial('SG1')+aStru1[i][1])
			   		while !SG1->(eof()).and.SG1->G1_COD == aStru1[i][1]
			   			if 	SG1->G1_INI <= cGetDtEmis .AND. SG1->G1_FIM >= cGetDtEmis  //Implementado por Anesio para n�o considerar pe�as fora do prazo
							incProc("Adicionando peca -> "+SG1->G1_COMP+" Contador-> "+cValToChar(nCount))
							AADD(aStru2, {SG1->G1_COMP, aStru1[i][2]*SG1->G1_QUANT,SG1->G1_OPC})
				//			Alert("Adicionando...-> "+ALLTRIM(SG1->G1_COMP), cValToChar(aStru1[i][2]*SG1->G1_QUANT))
							If Posicione("SB1",1,xFilial("SB1")+aStru1[i][1],"B1_UM") $ "PC" 
								cVldStru := "PC"
							endif
						endif
			    		SG1->(dbSkip())
			    		nCount++
				   	enddo
			   	 next i
			endif
				 
			if cN1 == 'PC1' 
				cN1 := 'PC'
			endif
		
		if cVldStru == "PC"
		  cN1 := "PC1"
		endif
		
		if alltrim(cGetCodKit) == '051314'.or.alltrim(cGetCodKit) $ cKtCort
			aStru1 := aStru2
		endif
	endif	
dbSelectArea("SZP")
RecLock('SZP',.F.)
Replace ZP_OPGERAD with 'G' //Informa G para que o plano fique em status de gera��o e nao permita que outro usu�rio altere
Replace ZP_NMLIB2 	WITH  UsrRetname(RetCodUsr())//+'-'+Time()
MsUnlock('SZP')
     

if cN1 == 'PC' .or. alltrim(cGetCodKit) == '051314' .or. alltrim(cGetCodKit) $ cKtCort                      
	aOps := {}
	for ixop:=1 to len(aStru2)
		nSeq:= ixop
		/////////////////////////////////DIVISAO DE MULTIPLOS////////////////////////////////////////////////////
		if lPc
			nQuant := nGetQtde
		else
			nQuant := aStru2[ixop][2]*nGetQtde
		endif
		
		while nQuant > 0
			aCab := {}    
			
			//cNumOP := GetSXeNum('SC2','C2_NUM') //Alterado funcao retorna numeracao automatica				
			cNumOP := GetNumSC2()    
			
			If Empty(_cOpc)
				_cOpc := SeleOpc(4,"DM_GERAPLN_COS",aStru2[ixop][1])
			EndIf            
				
			AAdd( aCab, {'C2_FILIAL'		,		 xFilial("SC2")			   		,			nil					})
			AAdd( aCab, {'C2_NUM' 			, 		 cNumOP							,			nil					})
			AAdd( aCab, {'C2_ITEM'			,		 '01' 							,			nil					})
			AAdd( aCab, {'C2_SEQUEN'		,	     '001'							,			nil					})
			AAdd( aCab, {'C2_PRODUTO'		,		 aStru2[ixop][1]				,			nil					})
			if nQuant > nGetMult
				AAdd( aCab, {'C2_QUANT'		,	 	 nGetMult  						, 			nil					})   
				nQuant := nQuant - nGetMult
			else
				AAdd( aCab, {'C2_QUANT'		,	 	 nQuant	   						, 			nil					})   
				nQuant := 0
			endif
			AAdd( aCab, {'C2_LOCAL'		    ,		 cGetLocal						,			nil					})
			AAdd( aCab, {'C2_CC'		  	,	 	 cGetCCusto						,			nil 				})
			AAdd( aCab, {'C2_DATPRI'	    ,		 cGetDtIni  					,			nil					})
			AAdd( aCab, {'C2_DATPRF'		,		 cGetDtEntr						,			nil					})
			AAdd( aCab, {'C2_EMISSAO'	    ,	     cGetDtEmis						,			nil					})
			AAdd( aCab, {'C2_OPMIDO'	    ,		 cGetPlano						,			nil		  			})
			AAdd( aCab, {'C2_CLIENTE'	    ,		 cGetCodCli						,			nil		  			})
			AAdd( aCab, {'C2_LOJA' 			, 		 cGetLjCli						,  			nil					})
			AAdd( aCab, {'C2_LADO'			,		 nCBoxLado						, 			nil					})
			AAdd( aCab, {'C2_RELEASE' 		,		 cGetRelea						, 			nil 				})
			AAdd( aCab, {'C2_DTRELE'		, 		 cGetDtEmis						, 			nil 				})
			AAdd( aCab, {'C2_ITEMCTA'		,		 xFilial("SC2")					, 			nil 				})
			AAdd( aCab, {'C2_QTDLOTE'	    ,	     nGetMult						,			nil					})
			AAdd( aCab, {'C2_OBS'           ,        cGetObs+" STR2"				,			nil        			})
			AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
			AAdd( aCab, {"AUTEXPLODE"       ,        'S'							,			NIL 			   	})
			If !Empty(_cOpc)
			AAdd( aCab, {"C2_OPC"       	,        _cOpc							,			NIL 			   	})				
			Endif
						
			incProc("Gerando plano - Por Favor Aguarde.... ")
			lMsErroAuto := .f.
			msExecAuto({|x,y| Mata650(x,Y)},aCab,3)
			
			If lMsErroAuto
				MostraErro()
			Else
				//ConfirmSX8()
			Endif
			
			nCount++
			MsUnlock()
		enddo
		nQuant := 0
		///////////////////////////////////////////////////////////////////////////////////////////////		         
	next iXop 
	//_cOpc := "" // reset variavel   //antonio   07/02/17
		
else
	aOps := {}
	for ixop:=1 to len(aStru1)
 		nSeq:= ixop
 		/////////////////////////////////DIVISAO DE MULTIPLOS///////////////////////////////////////////////////
		nQuant := aStru1[ixop][2]*nGetQtde
		
		while nQuant > 0
			aCab := {}
			
			//cNumOP := GetSXeNum('SC2','C2_NUM') //Alterado funcao retorna numeracao automatica				
			cNumOP := GetNumSC2() 
			
			If Empty(_cOpc)
				_cOpc := SeleOpc(4,"DM_GERAPLN_COS",aStru1[ixop][1])
			EndIf               
			
			AAdd( aCab, {'C2_FILIAL'		,		 xFilial("SC2")					,			nil					})
			AAdd( aCab, {'C2_NUM' 			, 		 cNumOP							,			nil					})
			AAdd( aCab, {'C2_ITEM'			,		 '01' 							,			nil					})
			AAdd( aCab, {'C2_SEQUEN'		,	     '001'							,			nil					})						
/*			AAdd( aCab, {'C2_ITEMCTA'	    ,        xFilial('SC2')					,			nil					})
			AAdd( aCab, {'C2_DESTINA'		,		 'E'							,			nil 				})
			if ixop == 2
				AAdd( aCab, {'C2_SEQPAI'	, 		 '001'							,			nil					})
			endif
			if ixop > 2 
				AAdd( aCab, {'C2_SEQPAI'	, 		 '002'							,			nil					})
			endif
			AAdd( aCab, {'C2_NIVEL'			,		 '97'							,			nil					})
			AAdd( aCab, {'C2_SEQUEN'		,	     strzero(nSeq,3)				,			nil					})  */
			AAdd( aCab, {'C2_PRODUTO'		,		 aStru1[ixop][1]				,			nil					})    
			if nQuant > nGetMult
				AAdd( aCab, {'C2_QUANT'		,	 	 nGetMult  						, 			nil					})   
				nQuant := nQuant - nGetMult                                                                            
			else
				AAdd( aCab, {'C2_QUANT'		,	 	 nQuant	   						, 			nil					})   
				nQuant := 0
			endif
			AAdd( aCab, {'C2_LOCAL'		    ,		 cGetLocal						,			nil					})
			AAdd( aCab, {'C2_CC'		  	,	 	 cGetCCusto						,			nil 				})
			AAdd( aCab, {'C2_DATPRI'	    ,		 cGetDtIni  					,			nil					})
			AAdd( aCab, {'C2_DATPRF'		,		 cGetDtEntr						,			nil					})
			AAdd( aCab, {'C2_EMISSAO'	    ,	     cGetDtEmis						,			nil					})
			AAdd( aCab, {'C2_OPMIDO'	    ,		 cGetPlano						,			nil		  			})
			AAdd( aCab, {'C2_CLIENTE'	    ,		 cGetCodCli						,			nil		  			})
			AAdd( aCab, {'C2_LOJA' 			, 		 cGetLjCli						,  			nil					})
			AAdd( aCab, {'C2_LADO'			,		 nCBoxLado						, 			nil					})
			AAdd( aCab, {'C2_RELEASE' 		,		 cGetRelea						, 			nil 				})
			AAdd( aCab, {'C2_DTRELE'		, 		 cGetDtEmis						, 			nil 				})
			AAdd( aCab, {'C2_ITEMCTA'		,		 xFilial("SC2")					, 			nil 				})
			AAdd( aCab, {'C2_QTDLOTE'	    ,	     nGetMult						,			nil					})
			AAdd( aCab, {'C2_OBS'           ,        cGetObs+" STR1"				,			nil        			})
			AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
			AAdd( aCab, {"AUTEXPLODE"       ,        'S'							,			nil 			   	})
			If !Empty(_cOpc) 
		   	AAdd( aCab, {"C2_OPC"       	,        _cOpc							,			NIL 			   	})				
			EndIf
	
			incProc("Gerando plano - Por Favor Aguarde.... ")
			lMsErroAuto := .f.
			msExecAuto({|x,Y| Mata650(x,Y)},aCab,3)
            If lMsErroAuto
				MostraErro()  
			Else
			//ConfirmSX8()	
			Endif
			
			nCount++
			MsUnlock()
		enddo
   	nQuant := 0 
	///////////////////////////////////////////////////////////////////////////////////////////////
//        begin transaction
		  /*	 	
            nSeq:= ixop
			aCab := {}    
			 
			//cNumOP := GetSXeNum('SC2','C2_NUM') Alterado funcao retorna numeracao automatica				
			//cNumOP := GetNumSC2()                
				
			AAdd( aCab, {'C2_FILIAL'		,		 xFilial("SC2")					,			nil					})
			AAdd( aCab, {'C2_NUM' 			, 		 cNumOP							,			nil					})
			AAdd( aCab, {'C2_ITEM'			,		 '01' 							,			nil					})
			AAdd( aCab, {'C2_SEQUEN'		,	     '001'							,			nil					})			
			
//			AAdd( aCab, {'C2_ITEMCTA'	    ,        xFilial('SC2')					,			nil					})
//			AAdd( aCab, {'C2_DESTINA'		,		 'E'							,			nil 				})
//			if ixop == 2
//				AAdd( aCab, {'C2_SEQPAI'	, 		 '001'							,			nil					})
//			endif
//			if ixop > 2 
//				AAdd( aCab, {'C2_SEQPAI'	, 		 '002'							,			nil					})
//			endif
//			AAdd( aCab, {'C2_NIVEL'			,		 '97'							,			nil					})
//			AAdd( aCab, {'C2_SEQUEN'		,	     strzero(nSeq,3)				,			nil					})
//			AAdd( aCab, {'C2_PRODUTO'		,		 aStru1[ixop][1]				,			nil					})
			AAdd( aCab, {'C2_QUANT'		    ,		 aStru1[ixop][2]*nGetQtde		, 			nil					})
			AAdd( aCab, {'C2_LOCAL'		    ,		 cGetLocal						,			nil					})
			AAdd( aCab, {'C2_CC'		  	,	 	 cGetCCusto						,			nil 				})
			AAdd( aCab, {'C2_DATPRI'	    ,		 cGetDtEntr 					,			nil					})
			AAdd( aCab, {'C2_DATPRF'		,		 cGetDtIni						,			nil					})
			AAdd( aCab, {'C2_EMISSAO'	    ,	     cGetDtEmis						,			nil					})
			AAdd( aCab, {'C2_OPMIDO'	    ,		 cGetPlano						,			nil		  			})
			AAdd( aCab, {'C2_CLIENTE'	    ,		 cGetCodCli						,			nil		  			})
			AAdd( aCab, {'C2_LOJA' 			, 		 cGetLjCli						,  			nil					})
			AAdd( aCab, {'C2_LADO'			,		 nCBoxLado						, 			nil					})
			AAdd( aCab, {'C2_RELEASE' 		,		 cGetRelea						, 			nil 				})
			AAdd( aCab, {'C2_DTRELE'		, 		 cGetDtEmis						, 			nil 				})
			AAdd( aCab, {'C2_ITEMCTA'		,		 xFilial("SC2")					, 			nil 				})
			AAdd( aCab, {'C2_QTDLOTE'	    ,	     nGetMult						,			nil					})
			AAdd( aCab, {'C2_OBS'           ,        cGetObs+" STR1"				,			nil        			})
			AAdd( aCab, {"AUTEXPLODE"       ,        'S'							,			nil 			   	})
			
	
			incProc("Gerando plano - Por Favor Aguarde.... ")
			lMsErroAuto := .f.
			msExecAuto({|x,Y| Mata650(x,Y)},aCab,3)
            If lMsErroAuto
				MostraErro()  
			Else
			//ConfirmSX8()	
			Endif
			*/
//	  end transaction 
	next iXop
//	_cOpc := "" // reset variavel   //antonio   07/02/17
	
endif

dbSelectArea("SZP")
RecLock('SZP',.F.)
Replace ZP_OPGERAD with 'S' 
Replace ZP_OPSOK with 'S'
MsUnlock('SZP')       
Alert('Plano gerado com sucesso...')
oDlg1:end()
//CancProc_COS()
U_DM_INCPLN()
return

///////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para insercao parcial de plano
//Apos inserir algum item como parcial, nao sera mais possivel gerar o plano total
///////////////////////////////////////////////////////////////////////////////////////////////
static function ICPC(cCodKit)
//////////////////////////////////////////////////////////////////////////////
//Declara��o de cVariable dos componentes
//////////////////////////////////////////////////////////////////////////////
Local nOpc := GD_INSERT+GD_DELETE+GD_UPDATE
Private aCoBrw1 := {}
Private aHoBrw1 := {}
Private cGetCodPc  := Space(15)
Private cGetDescPr := Space(50)
Private cGetQtPc   := Space(12)
Private cSayCodPc  := Space(10)
Private cSayDescPr := Space(10)
Private cSayQtde   := Space(12)
Private cCodPeca   := space(6)
Private cNomePeca  := space(60)
Private cGetTTPC   := Space(10)
Private cSayTtPc   := Space(30)
Private cCodKit    := cCodKit
Private noBrw1  := 0
Private nRMenuCmP 
Private nRMenuCP  

//////////////////////////////////////////////////////////////////////////////
//Declaracao de Variaveis Private dos Objetos
//////////////////////////////////////////////////////////////////////////////
SetPrvt("oFont1","oFont2","oFont3","oFont4","oDlg1","oRMenuCmP","oRMenuCP","oGrpItens","oBrw1","oGrpPCs")
SetPrvt("oSayDescPrd","oSayQtde","oGetCodPc","oGetNomePeca","oGetQtPC","oBtnOkPc","oBtn2")
SetPrvt("oDlg1","oSayTtPc","oGetTTPC")
//////////////////////////////////////////////////////////////////////////////
//Definicao do Dialog e todos os seus componentes.
//////////////////////////////////////////////////////////////////////////////
oFont1     := TFont():New( "MS Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oFont3     := TFont():New( "MS Sans Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oFont4     := TFont():New( "Times New Roman",0,-15,,.T.,0,,700,.F.,.F.,,,,,, )
oDlgIT      := MSDialog():New( 090,257,639,979,"Geracao de Planos Parciais",,,.F.,,,,,,.T.,,,.T. )
MHoBrw1_COS()
MCoBrw1_COS()
lMat:= CarrParc()
if lMat
	nRMenuCmP := 1
else
	nRMenuCmP := 2
endif
GoRMenuCmP := TGroup():New( 008,004,044,088,"Couro / Mat.Prima",oDlgIT,CLR_BLACK,CLR_WHITE,.T.,.F. )
oRMenuCmP  := TRadMenu():New( 012,010,{"Couro","Materia Prima"},{|u| If(PCount()>0,nRMenuCmP:=u,nRMenuCmP)},oDlgIT,,,CLR_BLACK,CLR_WHITE,"Gerar Plano de Couro e/ou Materia Prima",,,064,18,,.F.,.F.,.T. )
if ExistIt()
	//oRMenuCmP:Disable()
endif
GoRMenuCP  := TGroup():New( 009,093,045,177,"Pe�a / Componente",oDlgIT,CLR_BLACK,CLR_WHITE,.T.,.F. )
oRMenuCP   := TRadMenu():New( 013,099,{"Peca","Componente"},{|u| If(PCount()>0,nRMenuCP:=u,nRMenuCP)},oDlgIT,,,CLR_BLACK,CLR_WHITE,"Gerar plano a partir dos componentes e/ou das pecas",,,064,18,,.F.,.F.,.T. )
oGrpItens  := TGroup():New( 085,004,255,352,"Itens a serem gerado planos...",oDlgIT,CLR_BLACK,CLR_WHITE,.T.,.F. )
//oBrw1      := MsSelect():New( "SB1","","",{{"","","",""}},.F.,,{028,028,088,168},,, oDlg1 )

oBrw1      := MsNewGetDados():New(095,008,250,348,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','ALLWaysTrue()',{|| MarcaDel()},oGrpItens,aHoBrw1,aCoBrw1 )


oGrpPCs    := TGroup():New( 048,004,084,348,"Digitacao do item...",oDlgIT,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayCodPc  := TSay():New( 056,008,{||"Codigo"},oGrpPCs,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayDescPr := TSay():New( 057,049,{||"Descricao"},oGrpPCs,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayQtde   := TSay():New( 057,248,{||"Qtde"},oGrpPCs,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,034,008)
//oGetCodPc  := TGet():New( 065,008,{|u| If(PCount()>0,cGetCodPc:=u,cGetCodPc)},oGrpPCs,032,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetCodPc",,)
oGetCodPc  := TGet():New( 065,008,{|u| If(PCount()>0,cCodPeca:=u,cCodPeca)},oGrpPCs,032,014,'@!',{||Vld_Peca_COS(cCodKit)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cCodPeca",,)
oGetNomePeca := TGet():New( 065,048,{|u| If(PCount()>0,cNomePeca:=u,cNomePeca)},oGrpPCs,196,014,'@!',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDescPrd",,)
oGetNomePeca:Disable()
oGetQtPC  := TGet():New( 065,248,{|u| If(PCount()>0,cGetQtPC:=u,cGetQtPC)},oGrpPCs,044,014,'@E 9999.999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtde",,)
oSayTtPc   := TSay():New( 258,024,{||"TOTAL DE PECAS LANCADAS: "},oDlgIT,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,104,012)
oGetTTPC   := TGet():New( 256,120,{|u| If(PCount()>0,cGetTTPC:=u,cGetTTPC)},oDlgIT,076,013,'',,CLR_BLACK,CLR_LIGHTGRAY,oFont3,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetTTPC",,)
oGetTTPC:Disable()
oBtnOkPc   := TButton():New( 063,300,"&Confirmar",oGrpPCs,{||Inc_Peca(cCodKit)},044,016,,oFont4,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 010,228,"Confirmar &Total",oDlgIT,{|| oCBoxParc:Disable(), oDlgIT:End() },116,022,,oFont3,,.T.,,"",,,,.F. )
oPtnExcl   := TButton():New( 034,228,"Excluir Pecas",oDlgIT, {|| ConfEx() }, 116, 15,, oFont4,, .T.,,"",,,,.F. )

oDlgIT:Activate(,,,.T.)

Return

//////////////////////////////////////////////////////////////////////////////
//Function  � MHoBrw1_COS() - Monta aHeader da MsNewGetDados para o Alias: SZH
//////////////////////////////////////////////////////////////////////////////
Static Function MHoBrw1_COS()

Local nn1
aCpos :=  	{	{'Codigo'					,'ZH_PRODUTO'		,08,0	,'@!'						,	'AllwaysTrue()'		},;
				{'Descri��o'				,'ZH_DESCR'			,60,0	,'@!'						,	'AllwaysFalse()'	},;
				{'Plano'					,'ZH_PLANO'			,20,0   ,'@!'						,	'AllwaysTrue()'		},;
				{'Qtde Produz'				,'ZH_QUANT'			,6,0	,'@E 999,999'			,	'AllwaysTrue()' 	} } 


DbSelectArea("SX3")
DbSetOrder(2)

For nn1 := 1 to len( aCpos )
	if DbSeek( aCpos[ nn1,2 ] )
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


//Preencher a grid com os valores caso o usuario ja tenha feito o lan�amento de algumas pe�as...
/*
cQZH := " Select * from SZH010 where D_E_L_E_T_ = ' ' and ZH_STATUS = 'N' and ZH_FILIAL = '"+xFilial("SZH")+"' "
cQZH += " AND ZH_PLANO = '"+cGetPlano+"' AND Substring(ZH_DATA,1,4) = '"+Substr(DTOS(cGetDtEmis),1,4)+"' "
	
if Select('TRBZH') > 0
	dbSelectArea('TRBZH')
	dbCloseArea()
endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQZH),'TRBZH',.T.,.T.)
dbSelectArea("TRBZH")
dbGotop()
nCount:=0

while !TRBZH->(eof()) // .and. xFilial("SZH")==SZH->ZH_FILIAL .and. SZH->ZH_PLANO == Padr(cNomePlan,12) 
	Aadd(aCoBrw1, {TRBZH->ZH_PRODUTO, TRBZH->ZH_DESCR, TRBZH->ZH_PLANO, TRBZH->ZH_QUANT, .F. }) 
 		
	TRBZH->(dbSkip())
	nCount++
enddo

//oBrw1:SetArray(aCoBrw1)
//oBrw1:oBrowse:Refresh()

 */
Return


//////////////////////////////////////////////////////////////////////////////
//Function  � MCoBrw1_COS() - Monta aCols da MsNewGetDados para o Alias: SZH
//////////////////////////////////////////////////////////////////////////////
Static Function MCoBrw1_COS()

Local aAux := {}
Local nI

Aadd(aCoBrw1,Array(noBrw1+1))
For nI := 1 To noBrw1
   aCoBrw1[1][nI] := CriaVar(aHoBrw1[nI][2])
Next
aCoBrw1[1][noBrw1+1] := .F.

Return

//////////////////////////////////////////////////////////////////////////////
//Funcao para carregar as fichas parciais j� lancandos anteriormente, 
//caso seja alteracao
//////////////////////////////////////////////////////////////////////////////
static function CarrParc()
lRet   := .T. 
cStat  := 'N'
nCTTPC := 0
FiltPP(cStat)

		dbSelectArea("TRBZH")
		dbGotop()
		nCount:=0

	 	aCoBrw1 := {} 
 		while !TRBZH->(eof()) // .and. xFilial("SZH")==SZH->ZH_FILIAL .and. SZH->ZH_PLANO == Padr(cNomePlan,12) 
 			Aadd(aCoBrw1, {TRBZH->ZH_PRODUTO, TRBZH->ZH_DESCR, TRBZH->ZH_PLANO, TRBZH->ZH_QUANT, .F. }) 
 			nCTTPC+= TRBZH->ZH_QUANT
	 		TRBZH->(dbSkip())
 			nCount++
 		enddo
		 	cGetTTPC:= cValToChar(nCTTPc)
//			oGetTTPC:Refresh()
 	
	 	if nCount > 0
	 		TRBZH->(dbGotop())

			cQSG1 := " Select G1_COD, G1_COMP, B1_DESC, B1_GRUPO from SG1010 SG1, SB1010 SB1 "
			cQSG1 += " where SB1.D_E_L_E_T_ = ' ' and SG1.D_E_L_E_T_ = ' ' "
			cQSG1 += " and G1_COMP = B1_COD "
			cQSG1 += " and G1_FILIAL ='"+xFilial("SG1")+"' "
			cQSG1 += " and Substring(G1_COMP,1,3) <> 'MOD' "
			cQSG1 += " AND G1_INI <= '"+dTos(cGetDtEmis)+"' AND G1_FIM >= '"+dTos(cGetDtEmis)+"' " //Implementado por Anesio para desconsiderar p�s fora do prazo
			cQSG1 += " and G1_COD = '"+TRBZH->ZH_PRODUTO+"' "

			if Select("TMPG1")  > 0 
				dbSelectArea("TMPG1")
				TMPG1->(dbCloseArea())
			endif
			dbUseArea(.T., "TOPCONN", tcGenQry(, , cQSG1), 'TMPG1', .T., .T.)

	 		dbSelectArea('TMPG1')
			TMPG1->(dbGotop())
			if TMPG1->B1_GRUPO == '40  '
	 			lRet := .T.
			else
 				lRet := .F.
			endif
		else 
			u_excALT_COS()
			FiltPP('G')
		endif

//////////////////////////////////////////////////////////////////////////////
//Funcao para filtrar os planos conforme parametros
//////////////////////////////////////////////////////////////////////////////
static function FiltPP(cStat)
local cCnt := 0
	cQuery := " Select Substring(ZH_PRODUTO,1,6) ZH_PRODUTO, ZH_DESCR, ZH_PLANO, ZH_QUANT from SZH010 where D_E_L_E_T_ = ' '  " 
	cQuery += " and ZH_STATUS = '"+cStat+"' and ZH_FILIAL = '"+xFilial("SZH")+"' "
	cQuery += " AND ZH_PLANO = '"+cGetPlano+"' AND Substring(ZH_DATA,1,4) = '"+Substr(DTOS(cGetDtEmis),1,4)+"' "

	if Select('TRBZH') > 0
		dbSelectArea('TRBZH')
		dbCloseArea()
	endif
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZH',.T.,.T.)

if cStat == 'G'
	dbSelectArea('TRBZH')
	dbGotop()
	while !TRBZH->(eof())
		cCnt++
		TRBZH->(dbSkip())
    enddo
endif

if cCnt > 0 
	cQUp := " UPDATE SZH010 set ZH_STATUS = 'N' WHERE D_E_L_E_T_ = ' ' AND ZH_FILIAL ='"+xFilial("SZH")+"' "
	cQUp += " AND ZH_PLANO = '"+cGetPlano+"' AND Substring(ZH_DATA,1,4) = '"+Substr(DTOS(cGetDtEmis),1,4)+"' "		

	nret1 := TcSqlExec( cQUp )
	CarrParc()
endif	
	
return 

return lRet

//////////////////////////////////////////////////////////////////////////////
//Funcao para verificar se existem itens na ficha
//caso exista o checkbox ser� bloqueado para alteracao
//////////////////////////////////////////////////////////////////////////////
static function ExistIt()

Local i
lRet 	:= .F.
nCount 	:= 0

for i:=1 to len(aCoBrw1)
	nCount++
next i	

lRet := nCount > 0 

return lRet

//////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para ativar/desativar a insercao de planos parciais
//////////////////////////////////////////////////////////////////////////////////////////////
static function VldGPParc(lAtiva)
if lAtiva
	oBtnPcs:Enable()
else
	oBtnPcs:Disable()
endif

return

////////////////////////////////////////////////////////////////////////////
//Rotina para salvar o plano digitado antes de iniciar o registro das pecas
////////////////////////////////////////////////////////////////////////////
static function SalvaPln_COS()
local cQNUM

if select('TRBN') > 0
	DbSelectArea( 'TRBN' )
		DbCloseArea()
	Endif


cQNUM := " SELECT MAX(ZP_NUM) ZP_NUM from SZP010 where D_E_L_E_T_ = ' ' and ZP_FILIAL = '"+xFilial('SZP')+"' " 

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQNUM),'TRBN',.T.,.T. )

dbSelectArea('TRBN')

//cZPNUM := Val(TRBN->ZP_NUM) + 1 //Alterar para GETSXENUM('SZP','ZP_NUM')
cZPNUM := getsxenum('SZP', 'ZP_NUM')
if Substr(cGetStatus,1,5) # 'CTRLE'

	dbSelectArea('SZP')
	dbSetOrder(1)
		RecLock('SZP',.T.)
		SZP->ZP_FILIAL := xFilial('SZP') //cFilant
		SZP->ZP_NUM    :=  cZPNUM //StrZero(cZPNUM,6)
		SZP->ZP_OPMIDO := cGetPlano
		SZP->ZP_ANO    := cValToChar(year(cGetDtEmis))
		SZP->ZP_PRODUTO:= cGetCodKit
		SZP->ZP_DESCPRD:= cGetDescPr
		SZP->ZP_LOCAL  := cGetLocal
		SZP->ZP_CC     := cGetCCusto
		SZP->ZP_QUANT  := nGetQtde
		SZP->ZP_DATPRI := cGetDtIni 
		SZP->ZP_DATPRF := cGetDtEntr 
		SZP->ZP_OBS	   := cGetObs
		SZP->ZP_EMISSAO:= cGetDtEmis
		SZP->ZP_CLIENTE:= cGetCodCli
		SZP->ZP_LOJA   := cGetLjCli
	 	SZP->ZP_NOMCLIE:= cGetNomeCli
		SZP->ZP_RELEASE:= cGetRelea
		SZP->ZP_MULTPLO:= nGetMult
		SZP->ZP_LADO   := nCBoxLado 
		SZP->ZP_OPGERAD:= 'N'
		SZP->ZP_LIBER  := 'OK'
		SZP->ZP_PLNPARC:= iif(lCBoxParc,'S','N')
		MsUnLock('SZP')
		
	cGetStatus := 'CTRLE: '+	cZPNUM //StrZero(cZPNUM,6)
	//ConfirmSX8()
	oGetStatus:Refresh()
endif

return

////////////////////////////////////////////////////////////////////////////////////////
//Funcao para validar se esta' tudo OK com os itens digitados
////////////////////////////////////////////////////////////////////////////////////////
static function TudoOK()
local tOk := .T.
local cMsg:= ""

if VAl(cGetQtPC) <=0
	cMsg:= 'A quantidade precisa ser maior que zero!'
	tOk := .F.
endif
if cGetCodCli == space(6) .or. cGetLjCli == space(2)
	cMsg:= 'Codigo/Loja do cliente inv�lido!'
	tOk := .F.
endif

if cMsg <> ""
	Alert(cMsg+chr(13)+'Aten��o!')
	oBtnOkPc:disable()
endif
/*else
	oGet1:Disable()
	oRMenuCmP:Disable()
	oRMenuCP:Disable()
	oGet7:Disable()
    oGet9:Disable()
    oGet10:Disable()
    oBtn1:enable()
endif
  */


return tOk


////////////////////////////////////////////////////////////////////////////////////////
//Marca registro na grid para ser deletado.
////////////////////////////////////////////////////////////////////////////////////////
static function MarcaDel()
//	if !aCoBrw1[n][5]
//		Alert(aCoBrw1[n][1]+' ATIVO')
//	endif
nOld := n
	iif(aCoBrw1[n][5],aCoBrw1[n][5]:=.F.,aCoBrw1[n][5]:=.T.)
/*
	if aCoBrw1[n][5]
		Alert(aCoBrw1[n][1]+' DELETADO')
	endif
*/
oBrw1:SetArray(aCoBrw1)
oBrw1:oBrowse:Refresh()

//oBrw1:oBrowse:nOld:SetFocus()

return

////////////////////////////////////////////////////////////////////////////////////////
//Funcao para excluir os itens da grid que foram marcados como deletado
////////////////////////////////////////////////////////////////////////////////////////                                                            
static function ConfEx()
local nCTTPC := 0
Local i

Aviso('Ref.aos itens marcados para excluir', 'Se houver c�digos e quantidades repetido, ambos ser�o excluidos!', {"OK"} )
	for i:= 1 to len(aCoBrw1)
//		Alert('CODIGO-> '+aCoBrw1[i][1])
		if aCoBrw1[i][5] 
			cQuery := " UPDATE "+ RetSqlName( 'SZH')+ " SET D_E_L_E_T_ = '*' WHERE D_E_L_E_T_ = ' ' AND ZH_FILIAL='"+xFIlial("SZH")+"' "
			cQuery += " AND ZH_PLANO ='"+aCoBrw1[i][3]+"' AND ZH_PRODUTO = '"+aCoBrw1[i][1]+"' "
			cQuery += " AND ZH_QUANT = "+cValToChar(aCoBrw1[i][4])
			nret1 := TcSqlExec( cQuery )									

		endif
	next i

		cQuery := " Select Substring(ZH_PRODUTO,1,8) ZH_PRODUTO, ZH_DESCR, ZH_PLANO, ZH_QUANT from SZH010 where D_E_L_E_T_ = ' '  " 
		cQuery += " and ZH_STATUS = 'N' and ZH_FILIAL = '"+xFilial("SZH")+"' "
		cQuery += " AND ZH_PLANO = '"+cGetPlano+"' AND Substring(ZH_DATA,1,4) = '"+Substr(DTOS(cGetDtEmis),1,4)+"' "

		if Select('TRBZH') > 0
			dbSelectArea('TRBZH')
			dbCloseArea()
		endif
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZH',.T.,.T.)
 		dbSelectArea("TRBZH")
	 	dbGotop()
 		nCount:=0
	 	aCoBrw1 := {} 
 		while !TRBZH->(eof()) // .and. xFilial("SZH")==SZH->ZH_FILIAL .and. SZH->ZH_PLANO == Padr(cNomePlan,12) 
 			Aadd(aCoBrw1, {TRBZH->ZH_PRODUTO, TRBZH->ZH_DESCR, TRBZH->ZH_PLANO, TRBZH->ZH_QUANT, .F. }) 
 			nCTTPC+= TRBZH->ZH_QUANT
	 		TRBZH->(dbSkip())
 			nCount++
	 	enddo
			oBrw1:SetArray(aCoBrw1)
			oBrw1:oBrowse:Refresh()
		 	oGetCodPc:SetFocus()
		 	cGetTTPC:= cValToChar(nCTTPc)
			oGetTTPC:Refresh()


return

////////////////////////////////////////////////////////////////////////////////////////
//Funcao para adicionar a peca na tabela para geracao do plano de pecas...
////////////////////////////////////////////////////////////////////////////////////////
Static function Inc_Peca(cCodKit)
local cQuery := ""
local nTtPc  :=0 
local lRet := .T.          


if TudoOK()
	
	dbSelectArea("SZH")
	dbSetOrder(1)
		RecLock("SZH",.T.)
		SZH->ZH_FILIAL  := cFilant
		SZH->ZH_PRODUTO := cCodPeca
		SZH->ZH_DESCR   := cNomePeca
		SZH->ZH_QUANT   := VAl(cGetQtPC)
		SZH->ZH_PLANO   := cGetPlano
		SZH->ZH_DATA    := dDatabase
		SZH->ZH_STATUS  := 'N'
		SZH->ZH_MODELO  := cCodKit
		MsUnLock("SZH")
	    
		cQuery := " Select Substring(ZH_PRODUTO,1,8) ZH_PRODUTO, ZH_DESCR, ZH_PLANO, ZH_QUANT, R_E_C_N_O_ from SZH010 where D_E_L_E_T_ = ' '  " 
		cQuery += " and ZH_STATUS = 'N' and ZH_FILIAL = '"+xFilial("SZH")+"' "
		cQuery += " AND ZH_PLANO = '"+cGetPlano+"' AND Substring(ZH_DATA,1,4) = '"+Substr(DTOS(cGetDtEmis),1,4)+"' "
		cQuery += " ORDER BY R_E_C_N_O_ desc " 

		if Select('TRBZH') > 0
			dbSelectArea('TRBZH')
			dbCloseArea()
		endif
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZH',.T.,.T.)
 		dbSelectArea("TRBZH")
	 	dbGotop()
 		nCount:=0
	 	aCoBrw1 := {} 
 		while !TRBZH->(eof()) // .and. xFilial("SZH")==SZH->ZH_FILIAL .and. SZH->ZH_PLANO == Padr(cNomePlan,12) 
 			Aadd(aCoBrw1, {TRBZH->ZH_PRODUTO, TRBZH->ZH_DESCR, TRBZH->ZH_PLANO, TRBZH->ZH_QUANT, .F. }) 
 			nTTPc+= TRBZH->ZH_QUANT
	 		TRBZH->(dbSkip())
 			nCount++
	 	enddo
	 	
			oBrw1:SetArray(aCoBrw1)
			oBrw1:oBrowse:Refresh()
		 	oGetCodPc:SetFocus()
		 	cGetTTPC:= cValToChar(nTTPc)
			oGetTTPC:Refresh()

cNomePeca := Space(50)
cGetQtPC  := Space(12)


	oBtnOkPc:Disable()
	cCodPeca  := Space(15)
	oRMenuCmP:Disable()
	oRMenuCP:Disable()
	cNomePeca := space(60)
	oGetNomePeca:Refresh()
	cCodPeca  := space(6)
	nQtde     := 0
	oGetCodPc:Refresh()
	oGetCodPc:SetFocus()
endif		
return 


///////////////////////////////////////////////////////////////////////////////////////
//Rotina para validar a insercao da peca, identifica se podera dar continuidade
//baseado nos parametros selecionado pelo usuario
//se for escolhido pecas de couro, o usuario podera inserir apenas pecas de couro
//se for escolhido materia prima, o usuario podera inserir apenas pecas <> de couro
///////////////////////////////////////////////////////////////////////////////////////
Static Function Vld_Peca_COS(cCodKit)
local aComp  := {}
local lOk    := .F.
local lOkEx  := .F.
local cGrupo := ''
local cProd  := ''                          
//Busca os KITs que j� est� com estrutura reformulada
//Permite a inser��o de qualquer tipo de pe�a
local cKtMdNew := GetMV( 'MA_KTMDNEW')+GetMV( 'MA_KTMDNE1') 
Local i
             
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+cCodPeca)
	cNomePeca := SB1->B1_DESC
	cGrupo    := SB1->B1_GRUPO
	oGetNomePeca:Refresh() 
	if nRMenuCP == 1
		dbSelectArea("SG1")
		dbSetOrder(1)
		dbSeek(xFilial("SG1")+Padr(cCodKit,15))
			while !SG1->(eof()) .and. xFilial("SG1")==SG1->G1_FILIAL .and. SG1->G1_COD == Padr(cCodKit,15)
				Aadd(aComp, {SG1->G1_COMP})
				SG1->(dbSkip())                
			enddo
		for i:=1 to Len(aComp)
			dbSelectArea("SG1")
			dbSetOrder(1)                     
			dbGotop()
			dbSeek(xFilial("SG1")+aComp[i][1])
				while !SG1->(eof()) .and. xFilial("SG1")==SG1->G1_FILIAL .and. SG1->G1_COD == Padr(aComp[i][1],15)
					if SG1->G1_COMP == Padr(cCodPeca,15)
						cProd := SG1->G1_COMP
						oBtnOkPc:Enable()
						oGetQtPC:SetFocus()
						i:= Len(aComp)  
						lOkEx := .T.
					endif
					SG1->(dbSkip())
				enddo
		next i
		if lOkEx == .T.
			if nRMenuCmP == 1
				for i:= 1 to len(cNomePeca)
					if Substr(cNomePeca,i,5)== 'COURO'
						lOk := .T.
						i:= len(cNomePeca)
					endif
				next i
				dbSelectArea("SG1")
				dbSetOrder(1)
				dbSeek(xFilial("SG1")+Padr(cProd,15))
				if Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_GRUPO") == '40  '
					lOk:=.T.
				endif

            else         
            	lOk := .T.
				for i:= 1 to len(cNomePeca)
					if Substr(cNomePeca,i,5)== 'COURO'
						lOk := .F.
						i:= len(cNomePeca)
					endif
				next i
            endif
    	endif
    	    
    		/*
    		// Valida se codigo da peca pertence a estrutura                                                                            
			 nVldCodKit = Posicione("SG1",1,xFilial("SG1")+cCodKit+cCodPeca,"G1_COD")
			 if nVldCodKit <> cCodKit
			   //	Alert("A pe�a informada n�o pertence � estrutura do modelo.")
			   //	oBtnOkPc:Disable()
			   // 	oGetCodPc:SetFocus()
			   //	if !lOkEx
					Alert('A peca nao pertence a estrutura do modelo.')
					oBtnOkPc:Disable()
				    oGetCodPc:SetFocus()
			   //   endif
			 else
		 		oBtnOkPc:Enable()
			 	oGetQtPC:SetFocus()
			 endif
		    */
		if !alltrim(cCodKit) $ cKtMdNew  //Se for estrutura de consumo no modelo novo n�o entra nessa valida��o
			if lOk == .F.    
				if cCodPeca <> space(6)
					if !lOkEx
						Alert('A peca informada nao pertence a estrutura do modelo')
						oBtnOkPc:Disable()
				    	oGetCodPc:SetFocus()
					else 
						Alert('A peca informada nao � couro ou nao est� na estrutura do modelo.')
						oBtnOkPc:Disable()
					    oGetCodPc:SetFocus()
			 		endif
				 endif
			
			 else
			 	oBtnOkPc:Enable()
			 	oGetQtPC:SetFocus()
			 endif
		else
		 	oBtnOkPc:Enable()
		 	oGetQtPC:SetFocus()
		endif 
	else //Validar se o plano eh de componente ou nivel 02
		dbSelectArea("SG1")
		dbSetOrder(1)
		dbSeek(xFilial("SG1")+Padr(cCodKit,15))
			while !SG1->(eof()) .and. xFilial("SG1")==SG1->G1_FILIAL .and. SG1->G1_COD == Padr(cCodKit,15)
				if SG1->G1_COMP == Padr(cCodPeca,15)
					oBtnOkPc:Enable()
					oGetQtPC:SetFocus()
					i:= Len(aComp)  
					lOkEx := .T.
				endif
				SG1->(dbSkip())
			enddo
		if lOkEx == .T.
			lOk := lOkEx
		endif 
		    
			/*
			// Valida se componente da peca pertence a estrutura                                                                            
			 nVldCodKit = Posicione("SG1",1,xFilial("SG1")+cCodKit+cCodPeca,"G1_COD")
			 if nVldCodKit <> cCodKit
			   //	Alert("A pe�a informada n�o pertence � estrutura do modelo.")
			   //	lOk := .F.
			   //	oBtnOkPc:Disable()
			   // oGetCodPc:SetFocus()
			 	if !lOkEx
					Alert('O componente informado nao pertence a estrutura do modelo.')
					oBtnOkPc:Disable()
				    oGetCodPc:SetFocus()
			 	endif
			 else
		 		oBtnOkPc:Enable()
			 	oGetQtPC:SetFocus()
			 endif
			*/
		if !alltrim(cCodKit) $ cKtMdNew //Se for estrutura de consumo no modelo novo n�o entra nessa valida��o
			/*
			if lOk == .F.    
				//if cCodPeca <> space(6)
				//	Alert('O componente informado nao pertence a estrutura do modelo')
				//	oBtnOkPc:Disable()
			    //	oGetCodPc:SetFocus()
				// endif
			else
			 	oBtnOkPc:Enable()
		 		oGetQtPC:SetFocus()
			endif
			*/
		else
			oBtnOkPc:Enable()
		 	oGetQtPC:SetFocus()
		endif  
		
	endif
				        
return



////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para validacao do PLANO digitado, permite apenas 1 numero de Kit repetido por ano
//Chave de validacao ZP_PLANO + ZP_ANO
////////////////////////////////////////////////////////////////////////////////////////////////////
static function VldNumPln(cGetPlano)
local cQZP := " "
local lRet := .T.
//Alert('Chamou a rotina...')
if Select("TRBZP") > 0 
	dbSelectArea("TRBZP")
	TRBZP->(dbCloseArea())
endif
cQZP := " SELECT COUNT(*) QTDPLN FROM SZP010 WHERE D_E_L_E_T_ = ' ' AND ZP_OPMIDO = '"+cGetPlano+"' AND ZP_ANO = '"+Substr(DTOS(dDatabase),1,4)+"' AND ZP_FILIAL = '"+xFilial('SZP')+"' "

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQZP), 'TRBZP',.T.,.T.)
                
dbSelectArea('TRBZP')
                     
if TRBZP->QTDPLN > 0 
	lRet := .F.
	Alert("J� existe o PLANO '"+cGetPlano+"' para o ano de '"+Substr(DTOS(dDatabase),1,4)+"' digitado"+chr(13)+"Favor informar outro PLANO.")
endif

return lRet



///////////////////////////////////////////////////////////////////////////////
//Rotina para gerar as ordens de producao baseado no plano
//Execudada quando o plano � gerado parcial e as informacoes foram lancadas no arquivo SZH
///////////////////////////////////////////////////////////////////////////////
static function GERAPARCIAL_COS(cN1,cIncAlt)

//local nGetMult := 10
local aStru1 := {}
local aStru2 := {}
local cQuery := "" 

if cIncAlt == 'ALT'
	if !u_excALT_COS()
		Alert('Houve problema com a exclusao dos planos antigos'+chr(13)+'N�o ser� gerado novos planos!'+chr(13)+'Favor entrar em contato com o Administrador do sistema.')
	endif
endif 

	cQuery:= "SELECT ZH_PRODUTO, ZH_QUANT, ZH_PLANO, ZH_DATA, ZH_MODELO FROM SZH010 WHERE D_E_L_E_T_ = ' ' AND ZH_FILIAL='"+xFilial("SZH")+"' AND ZH_PLANO = '"+cGetPlano+"' " 
	if select('TRBZH') > 0
		DbSelectArea( 'TRBZH' )
		DbCloseArea()
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZH',.T.,.T. )

dbSelectArea("SZP")
RecLock('SZP',.F.)
Replace ZP_OPGERAD with 'G'  //Informa que o plano est� em gera��o por outro usu�rio e n�o poder� ser alterado
Replace ZP_NMLIB2 	WITH  UsrRetname(RetCodUsr())//+'-'+Time()
MsUnlock('SZP')

	
dbSelectArea('TRBZH')
dbGotop()
		
while !TRBZH->(eof())
	
	nQuant := TRBZH->ZH_QUANT
	
	while nQuant > 0           
	
	//cNumOP := GetSXeNum('SC2','C2_NUM') //Alterado funcao retorna numeracao automatica				
	cNumOP := GetNumSC2() 
	
	If Empty(_cOpc)                                                     //antonio 07/02/17
		_cOpc := SeleOpc(4,"DM_GERAPLN_COS",TRBZH->ZH_PRODUTO)
	EndIf               
	
	aCab := {}
	AAdd( aCab, {'C2_FILIAL'		,		 XFILIAL('SC2' )				,			nil					})
	AAdd( aCab, {'C2_NUM' 			, 		 cNumOP							,			nil					})
	AAdd( aCab, {'C2_ITEM'			,		 '01' 							,			nil					})
	AAdd( aCab, {'C2_SEQUEN'		,	     '001'							,			nil					})
	AAdd( aCab, {'C2_PRODUTO'		,		 TRBZH->ZH_PRODUTO				,			nil					})
	
	if nQuant > nGetMult
		AAdd( aCab, {'C2_QUANT'		,	 	 nGetMult  						, 			nil					})   
		nQuant := nQuant - nGetMult
	else
		AAdd( aCab, {'C2_QUANT'		,	 	 nQuant	   						, 			nil					})   
		nQuant := 0
	endif

	//AAdd( aCab, {'C2_QUANT'		    ,		 TRBZH->ZH_QUANT				, 			nil					})
	AAdd( aCab, {'C2_LOCAL'		    ,		 cGetLocal						,			nil					})
	AAdd( aCab, {'C2_CC'		  	,	 	 cGetCCusto						,			nil 				})
	AAdd( aCab, {'C2_DATPRI'	    ,		 cGetDtIni  					,			nil					})
	AAdd( aCab, {'C2_DATPRF'		,		 cGetDtEntr						,			nil					})
	AAdd( aCab, {'C2_EMISSAO'	    ,	     cGetDtEmis						,			nil					})
	AAdd( aCab, {'C2_OPMIDO'	    ,		 cGetPlano						,			nil		  			})
	AAdd( aCab, {'C2_CLIENTE'	    ,		 cGetCodCli						,			nil		  			})
	AAdd( aCab, {'C2_LOJA' 			, 		 cGetLjCli						,  			nil					})
	AAdd( aCab, {'C2_LADO'			,		 nCBoxLado						, 			nil					})
	AAdd( aCab, {'C2_RELEASE' 		,		 cGetRelea						, 			nil 				})
	AAdd( aCab, {'C2_DTRELE'		, 		 cGetDtEmis						, 			nil 				})
	AAdd( aCab, {'C2_ITEMCTA'		,		 xFilial("SC2")					, 			nil 				})
	AAdd( aCab, {'C2_QTDLOTE'	    ,	     nGetMult						,			nil					})
	AAdd( aCab, {'C2_OBS'           ,       cGetObs							,			nil        			})
	AAdd( aCab, {"AUTEXPLODE"       ,        'S'							,			NIL 			   	})
	AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
	AAdd( aCab, {"C2_OPC"       	,        _cOpc							,			NIL 			   	})				
	
	incProc("Gerando plano Parcial - Por Favor Aguarde.... ")
	lMsErroAuto := .f.
	msExecAuto({|x,Y| Mata650(x,Y)},aCab,3)

		If lMsErroAuto
			MostraErro()
		else
		//ConfirmSX8()
//		Alert('NUMERO REGISTRO' +cValToChar(TRBZH->REGISTRO))
		cQuery := "UPDATE "+ RetSqlName( 'SZH' ) + " SET ZH_STATUS = 'G' where ZH_FILIAL = '" + xFilial('SZH') + "' " 
		cQuery += " AND ZH_PRODUTO = '"+TRBZH->ZH_PRODUTO+"' AND ZH_PLANO = '"+TRBZH->ZH_PLANO+"' AND ZH_STATUS <> 'G' " 
		//ZH_PRODUTO, ZH_QUANT, ZH_PLANO, ZH_DATA, ZH_MODELO
		nret1 := TcSqlExec( cQuery )			
		Endif
	enddo
	TRBZH->(dbSkip())
enddo
dbSelectArea("SZP")
RecLock('SZP',.F.)
Replace ZP_OPGERAD with 'S' 
Replace ZP_OPSOK with 'S'
MsUnlock('SZP')

oDlg1:end()
U_DM_INCPLN()

return

User Function GeraC2_COS(cProduto,nQuant,dInicio,dEntrega,dAjusFim,cCpoProj,cSeqPai,cPrior,lLocPad,lPedido,cLocal,cOpcionais,cTpOp,cRevisao,nQtde2UM,cNumOp,cItemOp,cSeqC2,cRoteiro,cObs)
Local nPrazo
Local cPerProj
Local lProj   :=.F.
Local aRetEsp := {}
Local nVerifica := 0

//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao dos fontes      �
//� SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        �
//�������������������������������������������������������������������
If !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
	Final("Atualizar SIGACUS.PRW")	//"Atualizar SIGACUS.PRW !!!"
EndIf
If !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
	Final("Atualizar SIGACUSA.PRW")	//"Atualizar SIGACUSA.PRX !!!"
EndIf
If !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
	Final("Atualizar SIGACUSB.PRW")	//"Atualizar SIGACUSB.PRX !!!"
EndIf

nPrazo     := CalcPrazo(cProduto,nQuant)
dInicio    := IIf( dInicio  == NIL, SomaPrazo(dEntrega, - nPrazo),dInicio)
dEntrega   := IIf( dEntrega == NIL, SomaPrazo(dInicio, nPrazo),dEntrega)
dAjusFim   := IIf( dAjusFim == NIL, "" , dAjusFim)
cRevisao   := IIf( cRevisao == NIL ,"" , cRevisao)
lLocPad    := IIf( lLocPad  == NIL, .T., lLocPad )
lPedido    := IIf( lPedido  == NIL, .F., lPedido )
cTpOp      := IIf( cTpOp == NIL .Or. Empty(cTpOp),"F",cTpOp)
cOpcionais := IIf( cOpcionais == NIL ,"" , cOpcionais)
nQtde2UM   := IIf( nQtde2UM   == NIL ,0 , nQtde2UM)
cItemGrd   := IF(Type("cItemGrd") == "U", "", cItemGrd)
cGrade     := IF(Type("cGrade")   == "U", "", cGrade)
cStatus    := IF(Type("cStatus")  == "U", "", cStatus)

//���������������������������������������������������������Ŀ
//� Grava nas Ops filhas o numero da sequencia da Op Pai    �
//�����������������������������������������������������������
cSeqPai := IIf(cSeqPai != NIL,cSeqPai,"000")
cPrior  := IIf(cPrior != NIL,cPrior,"500")

//���������������������������������������������������������������Ŀ
//� Verifica se a rotina esta sendo chamada da Proj.Estoques NOVA �
//�����������������������������������������������������������������
lProj711:=If(Type("lProj711") == "L",lProj711,.F.)

//���������������������������������������������������������������������Ŀ
//� Tratamento da variavel "aSav650", que armazena as perguntas MTA650  �
//�����������������������������������������������������������������������
If !(Type('aSav650')=='A') .Or. !Empty(AsCan(aSav650,{|x|x == NIL}))
	aSav650 := Array(20)
//	MTA650PERG(.F.)
EndIf

//������������������������������������������������������������Ŀ
//� Verifica se a rotina esta sendo chamada da Proj.Estoques   �
//��������������������������������������������������������������
If cCpoProj != NIL
	lProj := .T.
endif

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+cProduto)
cRoteiro:= SB1->B1_OPERPAD

dbSelectArea("SC2")

//���������������������������������������������������������Ŀ
//� Atualiza dados padroes do arquivo de O.P.s              �
//�����������������������������������������������������������
IF inclui
	RecLock("SC2",.T.)
Else
	dbSeek(xFilial("SC2")+cNumOp+cItemOp+cSeqC2+cGrade)
	IF Found()
		dbSelectArea("SB2")
		dbSetOrder(1)
		If !dbSeek(xFilial("SB2")+cProduto+IIf(lLocPad,RetFldProd(SB1->B1_COD,"B1_LOCPAD"),cLocal))
			CriaSB2(cProduto,IIf(lLocPad,RetFldProd(SB1->B1_COD,"B1_LOCPAD"),cLocal))
			MsUnlock()
		EndIf
		GravaB2Pre("-",SC2->C2_QUANT,SC2->C2_TPOP,SC2->C2_QTSEGUM)
		dbSelectArea("SC2")
		RecLock("SC2",.F.)
	Else
		RecLock("SC2",.T.)
	Endif
Endif
Replace	C2_FILIAL	With xFilial("SC2")
Replace C2_PRODUTO	With cProduto
Replace	C2_NUM		With cNumOp
Replace	C2_ITEM		With cItemOp
Replace	C2_SEQUEN	With cSeqC2
Replace	C2_EMISSAO	With dDataBase
Replace	C2_LOCAL	With IIf(lLocPad,RetFldProd(SB1->B1_COD,"B1_LOCPAD"),cLocal)
Replace	C2_CC		With SB1->B1_CC
Replace	C2_UM		With SB1->B1_UM
Replace	C2_QUANT	With nQuant
Replace	C2_QTSEGUM	With ConvUm(cProduto,nQuant,nQtde2UM,2)
Replace	C2_DATPRF	With dEntrega
Replace	C2_DESTINA	With IIF(lPedido,"P","E")
Replace	C2_PRIOR	With cPrior
Replace	C2_SEGUM	With SB1->B1_SEGUM
Replace	C2_DATPRI	With dInicio
Replace	C2_SEQPAI	With cSeqPai
Replace	C2_ROTEIRO	With A650VldRot(SC2->C2_PRODUTO,cRoteiro)
Replace	C2_IDENT	With IIF(lProj.Or.lProj711,"P"," ")
Replace	C2_PEDIDO	With IIF(lPedido,cPedido,"")
Replace	C2_ITEMPV	With IIF(lPedido,cItemPv,"")
Replace	C2_OPC		With cOpcionais
Replace	C2_TPOP		With cTpop
Replace C2_REVISAO  With cRevisao
Replace C2_ITEMGRD  With cItemGrd
Replace C2_GRADE    With cGrade

//�����������������������������������������������������������Ŀ
//�Atualizacao dos campos utilizados pelo processo de geracao �
//�em BATCH das OP's intermediarias.                          �
//�������������������������������������������������������������
If FieldPos("C2_BATCH") > 0
	Replace C2_BATCH   With "�"
	Replace C2_BATUSR  With RetCodUsr()
	Replace C2_BATROT  With FunName()
EndIf

//�����������������������������������������������������������Ŀ
//� Caso usuario deseje, grava Observacao nas OPs Intermed.   �
//�������������������������������������������������������������
If aSav650[09] == 1
	Replace C2_OBS	With cObs
EndIf
//�����������������������������������������������������������Ŀ
//� Caso usuario deseje, grava Status nas OPs Intermed.       �
//�������������������������������������������������������������
If aSav650[16] == 1
	Replace C2_STATUS With cStatus
EndIf

//�����������������������������������������������������������Ŀ
//� Atualiza data de ajuste caso a OP PAI tenha sido ajustada �
//�������������������������������������������������������������
If !Empty(dAjusFim)
	Replace C2_DATAJF  With dAjusFim	, C2_DATAJI With SomaPrazo(dAjusFim, -nPrazo)
EndIf

//�����������������������������������������������������������������Ŀ
//� Gera integracao com Inspecao de Processos (QIP), caso exista    �
//| Obs: funcao OPGeraQIP esta programada no PCPXFUN.				�	
//�������������������������������������������������������������������
If FindFunction("OPGeraQIP") .And. GetMV("MV_QPOPINT",.F.,.T.) // Parametro identifica se o usu�rio deseja inspecionar OPs intermedi�rias.
	OPGeraQIP()
EndIf

If (ExistBlock( "MTA650I" ) )
	ExecBlock("MTA650I",.F.,.F.)
Endif
MsUnLock()

//����������������������������������������������������������������Ŀ
//� Atualiza Necessidade da Projecao de Estoques                   �
//������������������������������������������������������������������
If lProj
	cPerProj := nil //'' //U_DtoPer_COS(C2_DATPRF)
	if !Empty(cPerProj)
		cCpoProj := "H5_PER"+cPerProj
		dbSelectArea("SH5")
		dbSetOrder(1)
		If dbSeek(cProduto+"2")
			RecLock("SH5",.F.)
			Replace &(cCpoProj) with &(cCpoProj)+nQuant
			MsUnlock()
		EndIf
		If dbSeek(cProduto+"5")
			dbSetOrder(2)
			RecLock("SH5",.F.)
			Replace &(cCpoProj) with &(cCpoProj)-nQuant
			If &(cCpoProj) < .005
				Replace &(cCpoProj) with 0
			EndIf
			MsUnlock()
		EndIf
	endif
ElseIf lProj711
	A711CriSH5(SC2->C2_DATPRF,SC2->C2_PRODUTO,SC2->C2_OPC,SC2->C2_REVISAO,"SC2",SC2->(Recno()),SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD),"",If(!Empty(SC2->C2_PEDIDO),SC2->C2_PEDIDO+"/"+SC2->C2_ITEMPV,""),Max(0,SC2->(C2_QUANT-C2_QUJE)),"2",.T.,NIL,NIL,.T.)
EndIf

dbSelectArea("SB2")
dbSetOrder(1)
If !dbSeek(xFilial("SB2")+cProduto+IIf(lLocPad,RetFldProd(SB1->B1_COD,"B1_LOCPAD"),cLocal))
	CriaSB2(cProduto,IIf(lLocPad,RetFldProd(SB1->B1_COD,"B1_LOCPAD"),cLocal))
	MsUnlock()
EndIf
GravaB2Pre("+",SC2->C2_QUANT,SC2->C2_TPOP,SC2->C2_QTSEGUM)
return



/////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////
user Function DtoPer_COS(dData,aParPeriodos,nParTipo)
Local i, cRet, dFimProj
Local nSomaDia := 0                   

If ValType(aParPeriodos) == "A"
	aPeriodos:=ACLONE(aParPeriodos)
else
	aPeriodos:= {}
	AADD(aPeriodos, {dDatabase})
	nTipo := 0
EndIf

If ValType(nParTipo) == "N"
	nTipo:=nParTipo
EndIf

//����������������������������������������������������������������Ŀ
//�dFimProj - Data limite para ultimo periodo -> Len(aperiodos) + 1�
//������������������������������������������������������������������
If Len(aPeriodos) > 1 .And. nTipo # 1 .And. nTipo # 7 .And. nTipo # 2
	dFimProj := aPeriodos[Len(aPeriodos)] + (aPeriodos[Len(aPeriodos)] - aPeriodos[Len(aPeriodos)-1])
	If nTipo == 4 .And. Month(dFimProj-30)==2
		nSomaDia := 30- Day(CTOD("01/03/"+Substr(Str(Year(aPeriodos[Len(aPeriodos)-1]),4),3,2))-1)
		dFimProj := aPeriodos[Len(aPeriodos)] + (aPeriodos[Len(aPeriodos)] - aPeriodos[Len(aPeriodos)-1])+nSomaDia
	EndIf
Else
	If nTipo == 1 .or. nTipo == 7		// Projecao Diaria ou Periodos Variaveis
		dFimProj := aPeriodos[Len(aPeriodos)]
	ElseIf nTipo == 2	// Projecao Semanal
		dFimProj := aPeriodos[Len(aPeriodos)] + 6
	ElseIf nTipo == 3	// Projecao Quinzenal
		dFimProj := CtoD(If(Substr(DtoC(aPeriodos[Len(aPeriodos)]),1,2)="01","15"+Substr(DtoC(aPeriodos[Len(aPeriodos)]),3,6),;
			"01/"+If(Month(aPeriodos[Len(aPeriodos)])+1<=12,StrZero(Month(aPeriodos[Len(aPeriodos)])+1,2)+"/"+;
			SubStr(DtoC(aPeriodos[Len(aPeriodos)]),7,2),"01/"+Substr(Str(Year(aPeriodos[Len(aPeriodos)])+1,4),3,2))),"ddmmyy")
	ElseIf nTipo == 4	// Projecao Mensal
		dFimProj := CtoD("01/"+If(Month(aPeriodos[Len(aPeriodos)])+1<=12,StrZero(Month(aPeriodos[Len(aPeriodos)])+1,2)+;
			"/"+Substr(Str(Year(aPeriodos[Len(aPeriodos)]),4),3,2),"01/"+Substr(Str(Year(aPeriodos[Len(aPeriodos)])+1,4),3,2)),"ddmmyy")
	ElseIf nTipo == 5	// Projecao Trimestral
		dFimProj := CtoD("01/"+If(Month(aPeriodos[Len(aPeriodos)])+3<=12,StrZero(Month(aPeriodos[Len(aPeriodos)])+3,2)+;
			"/"+Substr(Str(Year(aPeriodos[Len(aPeriodos)]),4),3,2),"01/"+Substr(Str(Year(aPeriodos[Len(aPeriodos)])+1,4),3,2)),"ddmmyy")
	ElseIf nTipo == 6	// Projecao Semestral
		dFimProj := CtoD("01/"+If(Month(aPeriodos[Len(aPeriodos)])+6<=12,StrZero(Month(aPeriodos[Len(aPeriodos)])+6,2)+;
			"/"+Substr(Str(Year(aPeriodos[Len(aPeriodos)]),4),3,2),"01/"+Substr(Str(Year(aPeriodos[Len(aPeriodos)])+1,4),3,2)),"ddmmyy")
	EndIf
EndIf

If dData <= aPeriodos[1][1]
	cRet := "001"
EndIf
If Len(aPeriodos) >= 2
	For i:= 2 To Len(aPeriodos)
		If dData < aPeriodos[i] .and. dData >= aPeriodos[i-1]
			cRet := StrZero(i-1,3)
			Exit
		EndIf
	Next
EndIf
If dData >= aPeriodos[Len(aPeriodos)] .And. dData <= dFimProj
	cRet := StrZero(Len(aPeriodos),3)
ElseIf dData > dFimProj
	cRet := ""
EndIf

//Tratamento para geracao de OP's e SC's via MATA711, onde o periodo tem apenas 2 posicoes
If FunName() = "MATA711"
	cRet := Right(cRet,2)
EndIf

RETURN cRet



static Function MontEstru_COS(cProduto,nQuantPai,dEntrega,cCpoProj,cSeqPai,cPrior,lConsEst,cOpcionais,lOne,cTpOp,cRevisao,cStrOpc)
Static l650LocEmp

Local nR		:= 0
Local nRegSC2	:= 0
Local nQuantItem:= 0
Local nQtyStok	:= 0
Local nQtdBack	:= 0
Local nAchoOpc	:= 0
Local nNecessid := 0
Local nToler	:= 0
Local nQtdeTot	:= 0
Local nSG1		:= 0
Local nRecSD4	:= 0
Local nRecOpc	:= 0
Local nRecSB1	:= 0
Local nAchoSeq	:= 0
Local nBaixa    := 0
Local nEstSeg   := 0
Local i         := 0
Local nPeriodo  := 0
Local nSaldoSB2 := 0
Local nQtdSC    := 0
Local nCount    := 0
Local nQtdPrj   := 0
Local nOpca		:= 3

Local aAlter    := {}
Local aObjects  := {}
Local aPosObj   := {}
Local aScAglu   := {}
Local aQtdes    := {}
Local aSalvRot	:= {}
Local aSalvCols	:= {}
Local aSeq		:= {}
Local aOps		:= {}
Local aTravas	:= {}
Local aButtons  := {}

Local cLocalSC1	 := ""
Local cPeriodoOpc:= ""
Local cOldTipo   := ""
Local cLocAnt    := ""

Local lLocaliza	:= .F.
Local lPrevista := .F.
Local lRastroLoc:= .T.
Local lRetBlock	:= .T.
Local lOkPeri   := .T.

Local cDesc		 := SB1->B1_DESC
Local nSalB1     := SB1->(Recno())
Local lAltEmp    := (SubStr( cAcesso,37,1 ) == "S")
Local lA650CCF   := ExistBlock("A650CCF")
Local lExistBlkT := ExistTemplate("A650SALDO")
Local lExistBlock:= ExistBlock("A650SALDO")
Local lBlockOPI  := ExistBlock("A650OPI")
Local lMA650SAL  := ExistBlock("MA650SAL")
Local cLocProc   := GETMV("MV_LOCPROC")
Local lEstNeg    := IF(GETMV("MV_ESTNEG")=="S",.T.,.F.)
Local lEmpPrj    := SuperGetMV("MV_EMPPRJ",.F.,.T.)
Local lEmpBN 	 := SuperGetMV("MV_EMPBN",.F.,.F.)
Local lEstMax    := .F. //lProj711 .And. aPergs711[19] == 2 .And. aPergs711[1] == 1
Local aSize      := MsAdvSize()
Local aInfo      := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local lEvento001 := MExistMail("001")
Local aNegEst	 := {}

Local nX,cOp,nSavSC2,cTipo,lProjIni,nNecQe,nY
Local aComplCols, lMTA650AC
Local lGeraSc,lGeraOPI
Local oGet,oDlg2
Local cTitulo
Local lProj

Private cLocCQ    := GetMV('MV_CQ')
Private aCols     := {}
Private aColsDele := {}

//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao dos fontes      �
//� SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        �
//�������������������������������������������������������������������
If !(FindFunction("SIGACUS_V")	.And. SIGACUS_V() >= 20050512)
	Final("Atualizar SIGACUS")	//"Atualizar SIGACUS.PRW !!!"
EndIf
If !(FindFunction("SIGACUSA_V")	.And. SIGACUSA_V() >= 20050512)
	Final("Atualizar SIGACUSA")	//"Atualizar SIGACUSA.PRX !!!"
EndIf
If !(FindFunction("SIGACUSB_V")	.And. SIGACUSB_V() >= 20050512)
	Final("Atualizar SIGACUSB")	//"Atualizar SIGACUSB.PRX !!!"
EndIf

lAltEmp 	:= If( (ValType( lAltEmp ) # "L"),.F.,lAltEmp )
l650LocEmp 	:= If(ValType(l650LocEmp)#"L",ExistBlock("A650LEMP"),l650LocEmp)

IF TYPE("aRotina") == "A"
	aSalvRot := aClone(aRotina)
Endif

//���������������������������������������������������������������������Ŀ
//� Tratamento da variavel "aSav650", que armazena as perguntas MTA650  �
//�����������������������������������������������������������������������
If !(Type('aSav650')=='A') .Or. !Empty(AsCan(aSav650,{|x|x == NIL}))
	aSav650 := Array(20)
//	MTA650PERG(.F.)
EndIf

//���������������������������������������������������������������Ŀ
//� Verifica se a rotina esta sendo chamada da Proj.Estoques NOVA �
//�����������������������������������������������������������������
lProj711:=If(Type("lProj711") == "L",lProj711,.F.)

//���������������������������������������������������������Ŀ
//� Se a chamada da funcao vier da projecao, verifica se    �
//� e' Projecao pelo inicio :                               �
//� Se Sim nao gera op dos filhos e solicitacao de compra.  �
//�����������������������������������������������������������
lProj	 := If(  cCpoProj == NIL ,.F.,.T.)
lProjIni := .F.//If( (cCpoProj == NIL),.F.,If(cCpoProj == "INICIO",.T.,.F.) )
lConsEst := If( (lConsEst == NIL),(GetMV("MV_CONSEST") == "S"),lConsEst )

lGeraOPI:= GETMV("MV_GERAOPI")


//���������������������������������������������������������Ŀ
//� Grava nas Ops filhas o numero da sequencia da Op Pai    �
//�����������������������������������������������������������
cSeqPai := IIf(cSeqPai != NIL,cSeqPai,"000")
cPrior  := IIf(cPrior != NIL,cPrior,"500")

//���������������������������������������������������������Ŀ
//� Pega o numero da OP que serao gerados os empenhos       �
//�����������������������������������������������������������
cOp := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD

//���������������������������������������������������������Ŀ
//� Verifica se utiliza OP Prevista                         |
//�����������������������������������������������������������
lPrevista := SC2->C2_TPOP == 'P'

//���������������������������������������������������������Ŀ
//� Monta o array aCols verificando se existem produtos     �
//� fantasma na estrutura.                                  �
//�����������������������������������������������������������
aRotina   := { { "" , "        ", 0 , 3}}
//��������������������������������������������������������������Ŀ
//� Montagem do AHeader.                                         �
//����������������������������������������������������������������
PRIVATE aHeader := {}
aTam:=TamSX3("G1_COMP")	//1
Aadd(aHeader,{"Componente","G1_COMP" ,PesqPict("SG1","G1_COMP" ,atam[1]),aTam[1],aTam[2],"NaoVazio() .And. ExistCpo('SB1') .And. M->G1_COMP != '"+cProduto+"' .And. A650IniPrd()",USADO, "C" ,"SG1"," " })	//"Componente"
aTam:=TamSX3("D4_QUANT")//2
Aadd(aHeader,{"Qtde Empenho","D4_QUANT",PesqPict("SD4","D4_QUANT",atam[1]),aTam[1],aTam[2],"A650ConvUM(2) .And. M->D4_QUANT # 0 .And. A650VlQtNg() .And. A380TipDec(aCols[n,1],aCols[n,2],aCols[n,2],2)",USADO, "N" ,"SD4"," " })	//"Quantidade Empenho"
aTam:=TamSX3("D4_LOCAL")//3
Aadd(aHeader,{"Armaz�m","D4_LOCAL",PesqPict("SD4","D4_LOCAL",atam[1]),aTam[1],aTam[2],"NaoVazio() .And. existcpo('SB2',aCols[n,1]+M->D4_LOCAL) .And. M->D4_LOCAL <> cLocCQ .And. ValLocProc(aCols[n,1])",USADO, "C" ,"SD4"," " })	//"Local"
aTam:=TamSX3("G1_TRT")	//4
Aadd(aHeader,{"Sequ�ncia","G1_TRT"  ,PesqPict("SG1","G1_TRT"  ,atam[1]),aTam[1],aTam[2],"A650Seq()",USADO, "C" ,"SG1"," " })	//"Sequencia"
aTam:=TamSX3("D4_NUMLOTE")//5
Aadd(aHeader,{"Sub-lote","D4_NUMLOTE",PesqPict("SD4","D4_NUMLOTE",atam[1]),aTam[1],aTam[2],"A650LotCTL()",USADO, "C" ,"SD4"," " })	//"Sub-Lote"
aTam:=TamSX3("D4_LOTECTL")//6
Aadd(aHeader,{"Lote","D4_LOTECTL",PesqPict("SD4","D4_LOTECTL",atam[1]),aTam[1],aTam[2],"A650LotCTL()",USADO, "C" ,"SD4"," " })	//"Lote"
aTam:=TamSX3("D4_DTVALID")//7
Aadd(aHeader,{"Dt.Validade","D4_DTVALID",PesqPict("SD4","D4_DTVALID",atam[1]),aTam[1],aTam[2]," ",USADO, "D" ,"SD4"," " })	//"Data de Validade"
aTam:=TamSX3("D4_POTENCI")//8
Aadd(aHeader,{"Pot�ncia","D4_POTENCI",PesqPict("SD4","D4_POTENCI",atam[1]),aTam[1],aTam[2]," ",USADO, "N" ,"SD4"," " })	//"Potencia"
//���������������������������������������Ŀ
//� Tratamento Utilizado para o Siga Pyme �
//�����������������������������������������
If !__lPyme
	aTam:=TamSX3("DC_LOCALIZ")//9
	Aadd(aHeader,{"Localiza��o","DC_LOCALIZ",PesqPict("SDC","DC_LOCALIZ" ,atam[1]),aTam[1],aTam[2],"Vazio() .Or. (ExistCpo('SBE',aCols[n,3]+M->DC_LOCALIZ) .And. A650VldLoclz(." + If(lConsEst, "T", "F") + ".))",USADO, "C" ,"SBE"," " })	//"Localizacao"
	aTam:=TamSX3("DC_NUMSERI")//10
	Aadd(aHeader,{"Num.Serie","DC_NUMSERI",PesqPict("SDC","DC_NUMSERI" ,atam[1]),aTam[1],aTam[2],"",USADO, "C" ,""," " })	//"Num de Serie"
EndIf
aTam:=TamSX3("B1_UM")//11
Aadd(aHeader,{"1a. UM","B1_UM",PesqPict("SB1","B1_UM",atam[1]),aTam[1],aTam[2],,USADO, "C" ,"SB1","V" })	//" 1a. UM 		
aTam:=TamSX3("D4_QTSEGUM")//12
Aadd(aHeader,{"Qtde Empenho 2a. UM","D4_QTSEGUM",PesqPict("SD4","D4_QTSEGUM",atam[1]),aTam[1],aTam[2],"A650ConvUM(1)",USADO, "N" ,"SD4"," " })	//"Quantidade Empenho 2a. UM"		
aTam:=TamSX3("B1_SEGUM")//13
Aadd(aHeader,{"2a. UM","B1_SEGUM",PesqPict("SB1","B1_SEGUM",atam[1]),aTam[1],aTam[2],,USADO, "N" ,"SB1"," " })	// "2a. UM"			
aTam:=TamSX3("B1_DESC")	//14
Aadd(aHeader,{"Descri��o","B1_DESC" ,PesqPict("SB1","B1_DESC" ,atam[1]),aTam[1],aTam[2],,USADO, "C" ,"SB1"," " })	//"Descri��o"

//���������������������������������������������������������Ŀ
//� Execblock Para Inserir Campo em aCols - MTA650AC        �
//� 1 - Complemento do aHeader                              �
//� 2 - Conteudo do aCols                                   �
//�����������������������������������������������������������
If (lMTA650AC:=ExistBlock('MTA650AC'))
	aComplCols := ExecBlock('MTA650AC',.F.,.F.)
Else
	aComplCols := {{},}
EndIf

If Len(aComplCols[1]) != 0
	Aadd(aHeader,aComplCols[1])
EndIf

nPosCod    :=aScan(aHeader,{|x| AllTrim(x[2])=="G1_COMP"})
nPosQuant  :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_QUANT"})
nPosLocal  :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_LOCAL"})
nPosTrt    :=aScan(aHeader,{|x| AllTrim(x[2])=="G1_TRT"})
nPosLote   :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_NUMLOTE"})
nPosLotCTL :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_LOTECTL"})
nPosDValid :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_DTVALID"})
nPosPotenc :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_POTENCI"})
nPosLocLz  :=aScan(aHeader,{|x| AllTrim(x[2])=="DC_LOCALIZ"})
nPosnSerie :=aScan(aHeader,{|x| AllTrim(x[2])=="DC_NUMSERI"})
nPosUM     :=aScan(aHeader,{|x| AllTrim(x[2])=="B1_UM"})
nPosQtSegum:=aScan(aHeader,{|x| AllTrim(x[2])=="D4_QTSEGUM"})
nPos2UM    :=aScan(aHeader,{|x| AllTrim(x[2])=="B1_SEGUM"})
nPosDescr  :=aScan(aHeader,{|x| AllTrim(x[2])=="B1_DESC"})

	U_A650ACols(cProduto,nQuantPai,cOpcionais,lConsEst,cRevisao,aComplCols[2],aHeader,cLocProc)

//���������������������Ŀ
//� Pontos de Entrada   �
//�����������������������
If (ExistTemplate( "EMP650" ) )
	ExecTemplate("EMP650",.F.,.F.,{cStrOpc})
EndIf

If (ExistBlock( "EMP650" ) )
	ExecBlock("EMP650",.F.,.F.,{cStrOpc})
EndIf

//���������������������������������������������������������Ŀ
//� Varre o array aCols verificando se existem produtos     �
//� com o mesmo nivel e sequencia na estrutura. Caso isso   �
//� ocorra, soma o nivel do segundo para n�o gerar divergen �
//� cias na hora da producao.                               �
//�����������������������������������������������������������
//���������������������������������������Ŀ
//� Tratamento Utilizado para o Siga Pyme �
//�����������������������������������������
If !__lPyme
	For i:=1 To Len(aCols)
		If !aCols[i,Len(aCols[i])]
			nAchoSeq:=ASCAN(aSeq,aCols[i,nPosCod]+aCols[i,nPosTrt]+aCols[i,nPosLote]+aCols[i,nPosLotCtl]+aCols[i,nPosLocLz]+aCols[i,nPosnSerie])
			IF nAchoSeq > 0
				aCols[i,nPosTrt]:=Soma1(aCols[i,nPosTrt])
				nAchoSeq:=ASCAN(aSeq,aCols[i,nPosCod]+aCols[i,nPosTrt]+aCols[i,nPosLote]+aCols[i,nPosLotCtl]+aCols[i,nPosLocLz]+aCols[i,nPosnSerie])
				While nAchoSeq > 0
					aCols[i,nPosTrt]:=Soma1(aCols[i,nPosTrt])
					nAchoSeq:=ASCAN(aSeq,aCols[i,nPosCod]+aCols[i,nPosTrt]+aCols[i,nPosLote]+aCols[i,nPosLotCtl]+aCols[i,nPosLocLz]+aCols[i,nPosNserie])
				EndDo
				AADD(aSeq,aCols[i,nPosCod]+aCols[i,nPosTrt]+aCols[i,nPosLote]+aCols[i,nPosLotCtl]+aCols[i,nPosLocLz]+aCols[i,nPosnSerie])
			Else
				AADD(aSeq,aCols[i,nPosCod]+aCols[i,nPosTrt]+aCols[i,nPosLote]+aCols[i,nPosLotCtl]+aCols[i,nPosLocLz]+aCols[i,nPosnSerie])
			Endif
		EndIf
	Next i
Else
	For i:=1 To Len(aCols)
		If !aCols[i,Len(aCols[i])]
			nAchoSeq:=ASCAN(aSeq,aCols[i,nPosCod]+aCols[i,nPosTrt]+aCols[i,nPosLote]+aCols[i,nPosLotCtl])
			IF nAchoSeq > 0
				aCols[i,nPostrt]:=Soma1(aCols[i,nPosTrt])
				nAchoSeq:=ASCAN(aSeq,aCols[i,nPosCod]+aCols[i,nPosTrt]+aCols[i,nPosLote]+aCols[i,nPosLotCtl])
				While nAchoSeq > 0
					aCols[i,nPostrt]:=Soma1(aCols[i,nPosTrt])
					nAchoSeq:=ASCAN(aSeq,aCols[i,nPosCod]+aCols[i,nPosTrt]+aCols[i,nPosLote]+aCols[i,nPosLotCtl])
				EndDo
				AADD(aSeq,aCols[i,nPosCod]+aCols[i,nPosTrt]+aCols[i,nPosLote]+aCols[i,nPosLotCtl])
			Else
				AADD(aSeq,aCols[i,nPosCod]+aCols[i,nPosTrt]+aCols[i,nPosLote]+aCols[i,nPosLotCtl])
			Endif
		EndIf
	Next i
EndIf
//��������������������������������������������������������������Ŀ
//� Salva em aSalvCols o array aCols para copia de seguranca.    �
//����������������������������������������������������������������
aSalvCols := AClone(aCols)

//��������������������������������������������������������������Ŀ
//� PE para alterar a qtde. de empenho antes da tela             �
//����������������������������������������������������������������
If ExistBlock("A650ALTD4")
	ExecBlock("A650ALTD4",.F.,.F.,{cStrOpc})
EndIf

//��������������������������������������������������������������Ŀ
//� Caso usuario deseje alterar empenho, monta GetDados.         �
//����������������������������������������������������������������
If lAltEmp .And. Len(aCols) > 0 .And. aSav650[13] == 1 .And. (!Type('l650Auto')=='L' .Or. !l650Auto)
	Private aTELA[0,0],aGETS[0]
	Private nUsado := 5
	nPosAtu:=0
	nPosAnt:=9999
	nColAnt:=9999
	//��������������������������������������������������������������Ŀ
	//� Ativa tecla F4 para comunicacao com Saldos dos Lotes         �
	//����������������������������������������������������������������
	Set Key VK_F4 TO ShowF4()
	If lMTA650AC
		cTitulo:=OemToAnsi("Altera��o de Empenho"+Trim(cProduto)+ " - "+Trim(cDesc)+" / "+cOp)	//"Altera��o de Empenho - "
	Else
		cTitulo:=OemToAnsi("Altera��o de Empenho"+AllTrim(cProduto)+" / "+cOp)	//"Altera��o de Empenho - "
	EndIf
	//��������������������������������������������������������������Ŀ
	//� Executa ponto de entrada para montar array com botoes a      �
	//� serem apresentados na tela de alteracao de empenho           �
	//����������������������������������������������������������������
	If (ExistBlock( "M650BUT" ) )
		aButtons:=ExecBlock("M650BUT",.F.,.F.)
		If ValType(aButtons) # "A"
			aButtons:={}
		EndIf
	Endif
	//���������������������������������������������������������Ŀ
	//� Botao para exportar dados para EXCEL                    �
	//�����������������������������������������������������������
	If FindFunction("RemoteType") .And. RemoteType() == 1
		aAdd(aButtons   , {PmsBExcel()[1],{|| DlgToExcel({ {"GETDADOS",cTitulo,aHeader,aCols}})},PmsBExcel()[2],PmsBExcel()[3]})
	EndIf
	If ( Type("l650Auto") # "L" .or. !l650Auto )
		For i := 1 to Len(aHeader)
			If ! aHeader[i,2] $ "B1_UM, B1_SEGUM"
				Aadd(aAlter, aHeader[i,2])
			Endif
		Next
		nOpca := 0
		AADD(aObjects,{100,100,.T.,.T.,.F.})
		aPosObj:=MsObjSize(aInfo,aObjects)
		DEFINE MSDIALOG oDlg2 TITLE ctitulo OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
		oGet := MSGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],1,"A650LinOk","A650AETdOk","",.T.,,,,1024) // Aumentado numero maximo de linhas na GetDados
		oGet:oBrowse:aAlter := aAlter
		ACTIVATE MSDIALOG oDlg2 ON INIT (EnchoiceBar(oDlg2,{||If(A650AETdOk(),(nopca:=1,oDlg2:End()),.F.)},{||oDlg2:End()},,aButtons),A650DelCols(oGet:oBrowse))
	Else
		nopca:=1
	EndIF
	If nOpca == 0
		aCols := AClone(aSalvCols)
	Else
		aSalvCols:=AClone(aCols)
	EndIf
	Set Key VK_F4 TO
EndIf

For nSG1 := 1 to Len(aSalvCols)
	If aSalvCols[nSG1,Len(aSalvCols[nSG1])] .Or. Empty(aSalvCols[nSG1,1])
		Loop
	Endif
	aQtdes     := {}
	nQuantItem := aSalvCols[nSG1,nPosQuant]
	//����������������������������������������Ŀ
	//� Posiciona SB1                          �
	//������������������������������������������
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+aSalvCols[nSG1,nPosCod])
	cRoteiro:= SB1->B1_OPERPAD
	
	If QtdComp(nQuantItem,.T.) == QtdComp(0)
		Loop
	EndIf
	//����������������������������������������Ŀ
	//� Valida Armazem de CQ                   �
	//������������������������������������������
	If aSalvCols[nSG1,nPosLocal] == cLocCQ
		aSalvCols[nSG1,nPosLocal] := RetFldProd(SB1->B1_COD,"B1_LOCPAD")
	EndIf
	//����������������������������������������Ŀ
	//� Posiciona SB2                          �
	//������������������������������������������
	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(xFilial("SB2")+aSalvCols[nSG1,nPosCod]+If (SB1->B1_APROPRI == 'I', SB1->B1_LOCPAD, aSalvCols[nSG1,nPosLocal]))	
	If Eof()
		CriaSB2(aSalvCols[nSG1,nPosCod],aSalvCols[nSG1,nPosLocal])
		MsUnlock()
	EndIf
/*	If mv_par02 = 1 .And. cCpoProj == NIL .And. !lProj711
		If lConsEst
			If !lEmpPrj
				nQtdPrj := SB2->B2_QEMPPRJ
			EndIf
			nQtyStok := SaldoSB2(.T., , ,lConsTerc,lConsNPT,,,nQtdPrj)+SB2->B2_SALPEDI-SB2->B2_QEMPN+AvalQtdPre("SB2",2)
			If lPrevista .And. ( nQtyStok > SB2->B2_QEMPPRE )
				nQtyStok -= SB2->B2_QEMPPRE
			Endif
			nQtyStok += A650Prev(SB2->B2_COD)			
			//���������������������������������������������������������������Ŀ
			//� Executa P.E. para tratar saldo disponivel.                    �
			//�����������������������������������������������������������������
			If lExistBlkT
				nQtdBack:=nQtyStok	
				nQtyStok:=ExecTemplate("A650SALDO",.F.,.F.,nQtyStok)
				If ValType(nQtyStok) != "N"
					nQtyStok:=nQtdBack
				EndIf
			EndIf
			If lExistBlock
				nQtdBack:=nQtyStok	
				nQtyStok:=ExecBlock("A650SALDO",.F.,.F.,nQtyStok)
				If ValType(nQtyStok) != "N"
					nQtyStok:=nQtdBack
				EndIf
			EndIf
		Else
			nQtyStok := 0
		Endif
	Else
  */		//����������������������������������������Ŀ
		//� Posiciona SB2                          �
		//������������������������������������������
		nQtyStok := 0
		If cCpoProj <> NIL
			nQtyStok:=U_A650SldMRP_COS(.F.,.T.,aSalvCols[nSG1,nPosCod],dEntrega)
		ElseIf lProj711 .And. nQuantItem > 0
			nQtyStok:=Max(U_A650SldMRP_COS(.T.,.F.,aSalvCols[nSG1,nPosCod],dEntrega)+nQuantItem,0)
		ElseIf lConsEst
			dbSelectArea("SB2")
			dbSetOrder(1)
			dbSeek(xFilial("SB2")+aSalvCols[nSG1,nPosCod]+mv_par03,.T.)
			While !Eof() .And. SB2->B2_FILIAL+SB2->B2_COD+SB2->B2_LOCAL <= xFilial("SB2")+aSalvCols[nSG1,nPosCod]+mv_par04
				If !lEmpPrj
					nQtdPrj := SB2->B2_QEMPPRJ
				EndIf
				nQtyStok += SaldoSB2(.T., , ,lConsTerc,lConsNPT,,,nQtdPrj)+SB2->B2_SALPEDI-SB2->B2_QEMPN+AvalQtdPre("SB2",2)
				nQtyStok += A650Prev(SB2->B2_COD)			
				//���������������������������������������������������������������Ŀ
				//� Executa P.E. para tratar saldo disponivel.                    �
				//�����������������������������������������������������������������
				If lExistBlkT
					nQtdBack:=nQtyStok
					nQtyStok:=ExecTemplate("A650SALDO",.F.,.F.,nQtyStok)
					If ValType(nQtyStok) != "N"
						nQtyStok:=nQtdBack
					EndIf
				EndIf

				If lExistBlock
					nQtdBack:=nQtyStok
					nQtyStok:=ExecBlock("A650SALDO",.F.,.F.,nQtyStok)
					If ValType(nQtyStok) != "N"
						nQtyStok:=nQtdBack
					EndIf
				EndIf
				dbSkip()
			End
			dbSelectArea("SB2")
			dbSetOrder(1)
			MsSeek(xFilial("SB2")+aSalvCols[nSG1,nPosCod]+aSalvCols[nSG1,nPosLocal])
		Endif
	//Endif

	//����������������������������������������Ŀ
	//� Calcula necessidade para o produto     �
	//������������������������������������������
	nEstSeg := 0
	If !lProj711
		// --- Verifica Estoque de Seguranca (B1_ESTSEG)
		nEstSeg := CalcEstSeg( RetFldProd(SB1->B1_COD,"B1_ESTFOR") )
		nQtyStok -= nEstSeg

		//������������������������������������������������������������������Ŀ
		//�Tratamento para considerar somente uma vez o Estoque de Seguranca �
		//�quando parametrizado para Aglut. SCs "Por OP" ou "Por Data Nece"  �
		//��������������������������������������������������������������������
		If QtdComp(nEstSeg) > QtdComp(0) .And. aSav650[06] <> 1
			If aSav650[06] == 2
				aScAglu := aClone(aOpc1)
			ElseIf aSav650[06] == 3
				aScAglu := aClone(aDataOpC1)
			EndIf
			nQtdSC := 0
			//�������������������������������������������������Ŀ
			//�Verifica se ja existe qtde a ser solicitada para �
			//�o produto e adiciona ao saldo em estoque         �
			//���������������������������������������������������
			If aScan(aScAglu,{|x| x[1] == aSalvCols[nSG1, nPosCod]}) > 0
	 			For nCount:= 1 To Len(aScAglu)
					If aScAglu[nCount][1] == aSalvCols[nSG1, nPosCod]
						nQtdSC += aScAglu[nCount][2]
					EndIf
				Next nCount
				nQtyStok += nQtdSC
			EndIf
		EndIf
	EndIf    

	If nQuantItem < 0
		nNecessid := nQuantItem
	Else
		nNecessid := IIF(nQtyStok >= nQuantItem,0,nQuantItem - nQtyStok)
	EndIf

	//����������������������������������������������������Ŀ
	//� Verifica se envia e-mail ref. PONTO DE PEDIDO - 001�
	//������������������������������������������������������
	If lEvento001 .And. nQuantItem > 0 .And. !(SB2->B2_LOCAL == cLocCQ) .And. !Empty(RetFldProd(SB1->B1_COD,"B1_EMIN"))
		nSaldoSB2 := SALDOSB2(.T.,.T.,dDataBase)+SB2->B2_SALPEDI+SB2->B2_QACLASS
		nSaldoSB2 += A650Prev(SB2->B2_COD)
		//���������������������������������������������������������Ŀ
		//� Ponto de Entrada para validar saldo em TODOS os armazens�
		//�����������������������������������������������������������
		If lMA650SAL
			nSaldoSB2 := ExecBlock('MA650SAL',.F.,.F.)
			nSaldoSB2 := IIf(Valtype(nSaldoSB2) <> "N", 0, nSaldoSB2)					
		EndIf
		If (nSaldoSB2 - nQuantItem) <= RetFldProd(SB1->B1_COD,"B1_EMIN")
			MEnviaMail("001",{SB1->B1_COD,SB1->B1_DESC,SB2->B2_LOCAL,(nSaldoSB2 - nQuantItem),RetFldProd(SB1->B1_COD,"B1_EMIN")})
		EndIf
	EndIf

	dbSelectArea("SG1")
	If dbSeek(xFilial("SG1")+aSalvCols[nSG1,nPosCod])
		cTipo := "F"
	ElseIf !lProj711 .And. IF(FindFunction("IsNegEstr"),IsNegEstr(aSalvCols[nSG1,nPosCod])[1],.F.) //Sub-produto
		cTipo := "S"
	Else
		cTipo := "C"
	Endif
	If cTipo $ "FS" .And. !GetMv("MV_GERAPI") .And. SB1->B1_MRP == "N"
		cTipo := "I"
	Endif
	//�����������������������������������������Ŀ
	//� Executa execblock para verificar se     �
	//� produto sera fabricado ou comprado      �
	//� "COMPONENTE FABRICADO OU COMPRADO"      �
	//�������������������������������������������
	If lA650CCF
		cOldTipo:=cTipo
		cTipo:=ExecBlock("A650CCF",.F.,.F.,{aSalvCols[nSG1,nPosCod],cTipo,SC2->C2_DATPRI,nSG1})
		If !(ValType(cTipo) == "C") .Or. !(cTipo $ "FCI")
			cTipo:=cOldtipo
		EndIf
	EndIf
	
	//�����������������������������������������Ŀ
	//� Verifica se o produto eh intermediario  �
	//� e se deve ou nao considerar o armazem de�
	//� processo na geracao de SCs              �
	//�������������������������������������������
	If SB1->B1_APROPRI == "I"
		If SuperGetMV("MV_GRVLOCP",.F.,.T.)
			cLocalSC1:= cLocProc
		Else
			cLocalSC1:= RetFldProd(SB1->B1_COD,"B1_LOCPAD")
		EndIf
	Else
		cLocalSC1:= aSalvCols[nSG1,nPosLocal]
	EndIf
    
	nRecSB1:=SB1->(Recno())
	//�����������������������������������������Ŀ
	//� Permite alterar o local atraves de P.E. �
	//�������������������������������������������
	If l650LocEmp
		cLocAnt:=ExecBlock("A650LEMP",.F.,.F.,aSalvCols[nSG1])
		If ValType(cLocAnt) == "C" .And. Len(cLocAnt) == Len(aSalvCols[nSG1,nPosLocal])
			aSalvCols[nSG1,nPosLocal]:=cLocAnt
		EndIf
	EndIf
	//����������������������������������������������������Ŀ
	//� Verifica se Lote do Empenho ja foi preenchido ou   �
	//� se a Localizacao do Empenho ja foi preenchida      �
	//� Caso ja tenha sido, o estoque ja foi verificado.   �
	//������������������������������������������������������
	lRastroLoc:=.T.
	If Rastro(aCols[nSG1,nPosCod],"S")
		lRastroLoc:=Empty(aCols[nSG1,nPosLote]).And.Empty(aCols[nSG1,nPosLotCtl])
	ElseIf Rastro(aCols[nSG1,nPosCod],"L")
		lRastroLoc:=Empty(aCols[nSG1,nPosLotCtl])
	EndIf
	If lRastroLoc .And. Localiza(aCols[nSG1,nPosCod])
		lRastroLoc:=Empty(aCols[nSG1,nPosLocLz]).And.Empty(aCols[nSG1,nPosNSerie])
	EndIf

	If lProj711
		nPeriodo := Val(U_DtoPer_COS(dEntrega))
		If cTipo == "C" .And. lGeraSC
			lOkPeri := Substr(cSelPerSC,nPeriodo,1) == "�"
		Endif
		If cTipo == "F" .And. lGeraOPI
			lOkPeri :=  Substr(cSelPer,nPeriodo,1)   == "�"
		Endif
	Endif

	//����������������������������������������������������Ŀ
	//� Gera Solicitacoes de Compras ou OPs intermediarias �
	//� caso haja necessidade.                             �
	//������������������������������������������������������
	If nNecessid > 0 .And. lRastroLoc .And. lOkPeri
		If cTipo == "F"
			nAchoOpc:=ASCAN(aRetorOpc,{|x| x[1] == cStrOpc+aCols[nSG1,nPosCod]+aCols[nSG1,nPosTRT] })
			If nAchoOpc > 0
				cOpcionais:=aRetorOpc[nAchoOpc,2]
			EndIf
			//����������������������������������������������������Ŀ
			//� Verifica ponto de entrada para gerar ou nao OPs    �
			//� intermediarias                                     �
			//������������������������������������������������������
			If lBlockOPI
				lRetBlock:=ExecBlock("A650OPI",.F.,.F.,nSG1)
				If ValType(lRetBlock) # "L"
					lRetBlock:=.T.
				EndIf
			EndIf
			If lGeraOPI .And. lRetBlock .And. SB1->B1_FANTASM != "S"
				aOps:={}
				aQtdes := CalcLote(aSalvCols[nSG1,nPosCod],nNecessid,"F")
				If lEstMax
					aQtdes := A711LotMax(aSalvCols[nSG1,nPosCod], nNecessid, aQtdes)
				Endif
				nRegSC2 := SC2->(RecNo())
				SB1->(dbGoto(nRecSB1))
				For nX := 1 To Len(aQtdes)
					If !((SB1->B1_FANTASM == "S") .Or. (cTipo == "F" .And. !GetMv("MV_GERAPI")))
						IF (cCpoProj != NIL .and. SB1->B1_MRP$" S") .or. cCpoProj = NIL
							//������������������������������������������Ŀ
							//� Caso gere Ordem de Producao pela projecao�
							//��������������������������������������������
							If lProj .And. nPar10 == 2
								cPeriodoOpc:=U_DtoPer_COS(dEntrega)
								dbSelectArea("OPC")
								dbSetOrder(2)
								If dbSeek(cPeriodoOpc+cProduto+aSalvCols[nSG1,nPosCod]+cOpcionais)
									RecLock("OPC",.F.)
									Replace QUANTIDADE With QUANTIDADE - aQtdes[nx]
									MsUnlock()
								EndIf
							EndIf
							cSeqC2:=Soma1(cSeqC2,Len(SC2->C2_SEQUEN))
							cItemGrd := SC2->C2_ITEMGRD
							cGrade := SC2->C2_GRADE
							If !lOne
								A650GeraC2(aSalvCols[nSG1,nPosCod],aQtdes[nX],,dEntrega,SC2->C2_DATAJI,cCpoProj,cSeqPai,cPrior,.F.,,If(SuperGetMv("MV_OPIPROC",.F.,.T.),aSalvCols[nSG1,nPosLocal],RetFldProd(SB1->B1_COD,"B1_LOCPAD")),cOpcionais,cTpOp,SB1->B1_REVATU,NIL,cNumOp,cItemOp,cSeqC2,cRoteiro,cObs)
								AADD(aOps,SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD)
								dbSelectArea("SG1")
								nR := RecNo()
								MontEstru_COS(aSalvCols[nSG1,nPosCod],aQtdes[nX],SC2->C2_DATPRI,cCpoProj,cSeqC2,SC2->C2_PRIOR,lConsEst,cOpcionais,lOne,cTpOp,SB1->B1_REVATU,cStrOpc+aCols[nSG1,nPosCod]+aCols[nSG1,nPosTRT])
							EndIf
						EndIf
					EndIf
				Next nX
				SC2->(dbGoTo(nRegSC2))
			EndIf
		ElseIf cTipo == "C" .And. (SB1->B1_TIPO # "BN" .Or. MatBuyBN())
			//����������������������������������������������Ŀ
			//� Verifica se deve quebrar pelo Lote Economico �
			//������������������������������������������������

			If lEstMax
				nNecessid := Min(nNecessid, A711Lote(nQuantItem,aSalvCols[nSG1,nPosCod]) + AReadSha(aSalvCols[nSG1,nPosCod], dEntrega, "1") - nQuantItem)
			Endif

			// Aglutina SC por OP
			If aSav650[06] == 2
				aQtdes := { nNecessid }
			Else
				aQtdes := CalcLote(aSalvCols[nSG1,nPosCod],nNecessid,"C")
			EndIf
			If lEstMax
				aQtdes := A711LotMax(aSalvCols[nSG1,nPosCod], nNecessid, aQtdes)
			Endif	
			If !IsProdMod(aSalvCols[nSG1,nPosCod])
				If lGeraSc
					IF (cCpoProj != NIL .and. SB1->B1_MRP$" S") .Or. cCpoProj = NIL
						For nX := 1 To Len(aQtdes)
							//������������������������������������������������Ŀ
							//� Baixa quantidade do arquivo de opcionais       �
							//��������������������������������������������������
							If lProj .And. nPar10 == 2
								dbSelectArea("OPC")
								dbSetOrder(2)
								If dbSeek(U_DtoPer_COS(dEntrega)+cProduto+aSalvCols[nSG1,nPosCod]+cOpcionais)
									RecLock("OPC",.F.)
									Replace QUANTIDADE With QUANTIDADE - aQtdes[nx]
									MsUnlock()
								EndIf
							EndIf
							A650GeraC1(aSalvCols[nSG1,nPosCod],aQtdes[nX],cOp,dEntrega,cCpoProj,nx,nNecessid,cLocalSC1,cTpOp)
						Next nX
					Endif
				Endif
			EndIf
			dbSelectArea("SG1")
		ElseIf cTipo == "S"
			aNegEst := IsNegEstr(aSalvCols[nSG1,nPosCod],SC2->C2_DATPRI,nNecessid)
			SB1->(dbSeek(xFilial("SB1")+aNegEst[2]))
			For nX := 1 To aNegEst[5]
				aQtdes := CalcLote(aNegEst[2],aNegEst[4],"F")
				If lEstMax
					aQtdes := A711LotMax(aNegEst[2],nNecessid,aQtdes)
				Endif	
				For nY := 1 To Len(aQtdes)
					cSeqC2:=Soma1(cSeqC2,Len(SC2->C2_SEQUEN))
					A650GeraC2(aNegEst[2],aQtdes[nY],,SC2->C2_DATPRI,SC2->C2_DATAJI,cCpoProj,cSeqPai,cPrior,.F.,,If(SuperGetMv("MV_OPIPROC",.F.,.T.),aSalvCols[nSG1,nPosLocal],RetFldProd(SB1->B1_COD,"B1_LOCPAD")),RetFldProd(SB1->B1_COD,"B1_OPC"),cTpOp,SB1->B1_REVATU,NIL,cNumOP,cItemOP,cSeqC2,cRoteiro,cObs)
					dbSelectArea("SG1")
					nR := RecNo()
					MontEstru_COS(aNegEst[2],aQtdes[nY],SC2->C2_DATPRI,cCpoProj,cSeqC2,SC2->C2_PRIOR,lConsEst,RetFldProd(SB1->B1_COD,"B1_OPC"),lOne,cTpOp,SB1->B1_REVATU)
					SG1->(dbGoTo(nR))
				Next nY
			Next nX
		Endif
	EndIf
	If nQuantItem > 0 .Or. nQuantItem < 0
		//��������������������������������������������Ŀ
		//� Amarra empenhos com OPs geradas            �
		//����������������������������������������������
		If nQuantItem > 0 .And. cTipo # "C" .And. nNecessid > 0 .And. lGeraOPI .And. SB1->B1_FANTASM != "S" .And. (SB1->B1_TIPO != "BN" .Or. lEmpBN)
			For nx:=1 To Len(aQtdes)
				nBaixa:=Min(nQuantItem,aQtdes[nx])

				//��������������������������������������������Ŀ
				//� Atualiza arquivo de empenhos               �
				//����������������������������������������������
				If !__lPyme
					GravaEmp(	aSalvCols[nSG1,nPosCod],;
								aSalvCols[nSG1,nPosLocal],;
								nBaixa,;
								aSalvCols[nSG1,nPosQtSegum],;
								aSalvCols[nSG1,nPosLotCtl],;
								aSalvCols[nSG1,nPosLote],;
								aSalvCols[nSG1,nPosLocLz],;
								aSalvCols[nSG1,nPosnSerie],;
								cOp,;
								aSalvCols[nSG1,nPosTrt],;
								NIL,;
								NIL,;
								"SC2",;
								If(Len(aOps)>0,aOps[nx],NIL),;
								dEntrega,;
								@aTravas,;
								.F.,;
								lProj,;
								.T.,;
								.T.,;
								NIL,;
								NIL,;
								!lRastroLoc,;
								,;
								,;
								aClone(aSalvCols),;
								nSG1)
				Else
					GravaEmp(	aSalvCols[nSG1,nPosCod],;
								aSalvCols[nSG1,nPosLocal],;
								nBaixa,;
								aSalvCols[nSG1,nPosQtSegum],;
								aSalvCols[nSG1,nPosLotCtl],;
								aSalvCols[nSG1,nPosLote],;
								NIL,;
								NIL,;
								cOp,;
								aSalvCols[nSG1,nPosTrt],;
								NIL,;
								NIL,;
								"SC2",;
								If(Len(aOps)>0,aOps[nx],NIL),;
								dEntrega,;
								@aTravas,;
								.F.,;
								lProj,;
								.T.,;
								.T.,;
								NIL,;
								NIL,;
								!lRastroLoc,;
								,;
								,;
								aClone(aSalvCols),;
								nSG1)
				EndIf
				nQuantItem-=Min(nQuantItem, nBaixa)

			Next nx
		EndIf
		//��������������������������������������������Ŀ
		//� Gera Empenho de qtd que ja existente ou    �
		//� quantidade que nao precisa ser produzida.  �
		//����������������������������������������������
		If nQuantItem # 0 .And. (SB1->B1_TIPO != "BN" .Or. lEmpBN)
			//��������������������������������������������Ŀ
			//� Atualiza arquivo de empenhos               �
			//����������������������������������������������
			If !__lPyme
				GravaEmp(	aSalvCols[nSG1,nPosCod],;
							aSalvCols[nSG1,nPosLocal],;
							nQuantItem,;
							aSalvCols[nSG1,nPosQtSegum],;
							aSalvCols[nSG1,nPosLotCtl],;
							aSalvCols[nSG1,nPosLote],;
							aSalvCols[nSG1,nPosLocLz],;
							aSalvCols[nSG1,nPosnSerie],;
							cOp,;
							aSalvCols[nSG1,nPosTrt],;
							NIL,;
							NIL,;
							"SC2",;
							NIL,;
							dEntrega,;
							@aTravas,;
							.F.,;
							lProj,;
							.T.,;
							.T.,;
							NIL,;
							NIL,;
							!lRastroLoc,;
							,;
							,;
							aClone(aSalvCols),;
							nSG1)
			Else
				GravaEmp(	aSalvCols[nSG1,nPosCod],;
							aSalvCols[nSG1,nPosLocal],;
							nQuantItem,;
							aSalvCols[nSG1,nPosQtSegum],;
							aSalvCols[nSG1,nPosLotCtl],;
							aSalvCols[nSG1,nPosLote],;
							NIL,;
							NIL,;
							cOp,;
							aSalvCols[nSG1,nPosTrt],;
							NIL,;
							NIL,;
							"SC2",;
							NIL,;
							dEntrega,;
							@aTravas,;
							.F.,;
							lProj,;
							.T.,;
							.T.,;
							NIL,;
							NIL,;
							!lRastroLoc,;
							,;
							,;
							aClone(aSalvCols),;
							nSG1)
			EndIf
		EndIf
	EndIf
Next

SB1->(dbGoTo(nSalB1))
If aSalvRot != NIL
	aRotina:=aClone(aSalvRot)
EndIf

If (ExistBlock( 'MA650EMP' ) )
	ExecBlock('MA650EMP',.F.,.F.)
EndIf
Return


////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para exclusao dos planos do sistema
//Faz a checagem das fichas geradas, verifica se existe apontamento das mesmas
//caso afirmativo nao permite exclusao
//Verifica se existe algum apontamento para o plano e tambem barra a exclusao.
////////////////////////////////////////////////////////////////////////////////////////////////
user function exclPL_COS()
local cPlano := SZP->ZP_OPMIDO
local cAno   := SZP->ZP_ANO
local nCount := 0


if !APMSGNOYES('Confirma a exclusao do plano '+cPlano+' ? '+chr(13)+'Operacao nao poder� ser revertida!','ATENCAO...')
	Alert('Operacao Cancelada!!!!!!')
	Return
endif

Alert('Clique OK para iniciar a exclusao'+chr(13)+'Esse processo pode demorar um pouco para finalizar todas as verificacoes/exclusoes.')

//Verificar se existem fichas apontadas para o plano
qSZ7 := " SELECT Z7_PLANO FROM SZ7010 WHERE D_E_L_E_T_ = ' ' AND Z7_FILIAL = '"+xFilial('SZ7')+"' AND Z7_PLANO = '"+cPlano+"' AND Substring(Z7_DTAPON,1,4)='"+cAno+"' " 
if Select("TRBZ7") > 0
	dbSelectArea('TRBZ7')
	TRBZ7->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", tcGenQry( ,, qSZ7), "TRBZ7", .T.,.T.)

dbSelectArea('TRBZ7')
dbGotop()
while !TRBZ7->(eof())
	nCount++
	TRBZ7->(dbSkip())
enddo

if nCount > 0 
	ApmsgInfo('O Plano ja possui fichas apontadas!'+chr(13)+chr(13)+'Exclusao nao permitida.','ATENCAO...!')
	return
endif

//Verificar se existe alguma Ordem de Producao que foi apontada que nao seja por ficha de producao
if Select("TRBC2") > 0 
	dbSelectArea("TRBC2")
	dbCloseArea()
endif

cQSC2 := " SELECT C2_NUM from SC2010 WHERE C2_FILIAL = '"+xFilial('SC2')+"' AND C2_OPMIDO = '"+cPlano+"' AND SUBSTRING(C2_EMISSAO,1,4)= '"+cAno+"' AND D_E_L_E_T_ = ' ' "
cQSC2 += " AND C2_QUJE > 0 " 

dbUseArea(.T., "TOPCONN", TcGenQry(,,cQSC2), "TRBC2", .T.,.T.)

nCount := 0
dbSelectArea("TRBC2")
dbGotop()
while !TRBC2->(eof())
	nCount++
	TRBC2->(dbSkip())
enddo

if nCount > 0
	Alert('J� existe apontamento de pe�as para este plano, exclus�o n�o permitida! ')
	Return
endif

//Faz a exclusao das fichas geradas no arquivo SZ3 
	
cQSZ3 := " UPDATE SZ3010 SET D_E_L_E_T_ = '*' where D_E_L_E_T_ = ' ' AND Z3_PLANO = '"+cPlano+"' AND Substring(Z3_DTFICHA,1,4) = '"+cAno+"' "
cQSZ3 += " AND Z3_FILIAL = '"+xFilial("SZ3")+"' "
		
nret1 := TcSqlExec( cQSZ3 )
				
//Faz a exclusao das OPS no arquivo SC2
if Select("TRBC2") > 0 
	dbSelectArea("TRBC2")
	TRBC2->(dbCloseArea())
endif

cQSC2 := " SELECT C2_NUM from SC2010 WHERE C2_FILIAL = '"+xFilial('SC2')+"' AND C2_OPMIDO = '"+cPlano+"' AND SUBSTRING(C2_EMISSAO,1,4)= '"+cAno+"' AND D_E_L_E_T_ = ' ' "

dbUseArea(.T., "TOPCONN", TcGenQry(,,cQSC2), "TRBC2", .T.,.T.)

nCount := 0
dbSelectArea("TRBC2")
dbGotop()
ProcRegua(0) 

dbSelectArea('SC2')
dbSetOrder(1)

while !TRBC2->(eof())
	if dbSeek(xFilial('SC2')+TRBC2->C2_NUM)
		aCab := {}
		AAdd( aCab, {'C2_FILIAL'		,		 XFILIAL('SC2' )				,			nil					})
		AAdd( aCab, {'C2_NUM' 			, 		 SC2->C2_NUM					,			nil					})
		AAdd( aCab, {'C2_ITEM'			,		 '01' 							,			nil					})
		AAdd( aCab, {'C2_SEQUEN'		,	     '001'							,			nil					})
		AAdd( aCab, {'C2_PRODUTO'		,		 SC2->C2_PRODUTO				,			nil					})
		AAdd( aCab, {'C2_QUANT'		    ,		 SC2->C2_QUANT					, 			nil					})
		AAdd( aCab, {'C2_LOCAL'		    ,		 SC2->C2_LOCAL					,			nil					})
		AAdd( aCab, {'C2_CC'		  	,	 	 SC2->C2_CC						,			nil 				})
		AAdd( aCab, {'C2_DATPRI'	    ,		 SC2->C2_DATPRI					,			nil					})
		AAdd( aCab, {'C2_DATPRF'		,		 SC2->C2_DATPRF					,			nil					})
		AAdd( aCab, {'C2_EMISSAO'	    ,	     SC2->C2_EMISSAO				,			nil					})
		AAdd( aCab, {'C2_OPMIDO'	    ,		 SC2->C2_OPMIDO					,			nil		  			})
		AAdd( aCab, {'C2_CLIENTE'	    ,		 SC2->C2_CLIENTE				,			nil		  			})
		AAdd( aCab, {'C2_LOJA' 			, 		 SC2->C2_LOJA					,  			nil					})
		AAdd( aCab, {'C2_LADO'			,		 SC2->C2_LADO					, 			nil					})
		AAdd( aCab, {'C2_RELEASE' 		,		 SC2->C2_RELEASE				, 			nil 				})
		AAdd( aCab, {'C2_DTRELE'		, 		 SC2->C2_DTRELE					, 			nil 				})
		AAdd( aCab, {'C2_ITEMCTA'		,		 xFilial("SC2")					, 			nil 				})
		AAdd( aCab, {'C2_QTDLOTE'	    ,	     SC2->C2_QTDLOTE				,			nil					})
		AAdd( aCab, {'C2_OBS'           ,       SC2->C2_OBS						,			nil        			})         
		AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
		AAdd( aCab, {"AUTEXPLODE"       ,        'S'							,			NIL 			   	})
		
		
		lMsErroAuto := .f.
		msExecAuto({|x,Y| Mata650(x,Y)},aCab,5)
	
			If lMsErroAuto
				MostraErro()
			endif
	endif
	TRBC2->(dbSkip())
	incProc("Excluindo plano - Por Favor Aguarde.... OP: "+SC2->C2_NUM)
enddo
cExSZP := " UPDATE SZP010 SET D_E_L_E_T_ = '*' where D_E_L_E_T_ = ' ' AND ZP_OPMIDO = '"+cPlano+"' AND ZP_ANO = '"+cAno+"' "
cExSZP += " AND ZP_FILIAL = '"+xFilial("SZP")+"' "
		
nret1 := TcSqlExec( cExSZP )
Alert('Plano '+cPlano+' excluido com Sucesso....')

//Alert('Vai excluir o plano:' +cPlano+' gerado no ano de '+cAno)
return


////////////////////////////////////////////////////////////////////////////////////////////////
//FUNCAO PARA ALTERAR UM PLANO DE PRODUCAO....
////////////////////////////////////////////////////////////////////////////////////////////////
User Function DM_ALTPLN()
///////////////////////////////////////////////////////////////////////////////
// Declaracao de Variaveis dos componentes                                   //
///////////////////////////////////////////////////////////////////////////////
if !SZP->ZP_PLNPARC == "S"
	if !APMSGNOYES('DESEJA ALTERAR UM PLANO TOTAL?','ATENCAO...')
		Alert('Alteracao permitida apenas para planos de recorte...')
		Return()
	endif
endif
//Alert("PLANO-> "+SZP->ZP_OPMIDO+" VALOR "+SZP->ZP_OPGERAD)
if ZP_OPGERAD == 'G' 
	Alert("O Plano j� est� sendo gerado pelo usu�rio "+ALLTRIM(SZP->ZP_NMLIB2)+chr(13)+"ALTERA��O NAO PERMITIDA"+chr(13)+chr(13)+"Aguarde at� que o mesmo encerre!!")
	return()
endif

Private cN1     := space(2)// Varialvel que serah utilizada para informar se o KIT tem Componente CM ou apenas Pecas PC
Private cGetCodKit := SZP->ZP_PRODUTO
Private cGetCCusto := SZP->ZP_CC
Private nGetQtde   := SZP->ZP_QUANT
Private nGetMult   := SZP->ZP_MULTPLO
Private cGetCodCli := SZP->ZP_CLIENTE
Private cGetLjCli  := SZP->ZP_LOJA
Private cGetNomeCli:= Posicione('SA1',1,xFilial('SA1')+SZP->(ZP_CLIENTE+ZP_LOJA),"A1_NOME")
Private cGetDescPr := Posicione('SB1',1,xFilial('SB1')+SZP->ZP_PRODUTO,"B1_DESC")
Private cGetDtEmis := iif(SZP->ZP_EMISSAO >= dDatabase, SZP->ZP_EMISSAO, dDataBase)
Private cGetDtEntr := iif(SZP->ZP_DATPRF >= dDatabase, SZP->ZP_DATPRF, dDatabase)
Private cGetDtIni  := iif(SZP->ZP_DATPRI >= dDatabase, SZP->ZP_DATPRI, dDatabase)
Private cGetObs    := SZP->ZP_OBS
Private cGetLocal  := SZP->ZP_LOCAL
Private cGetPlano  := SZP->ZP_OPMIDO
Private cGetUmPrd  := Posicione('SB1',1,xFilial('SB1')+SZP->ZP_PRODUTO,"B1_UM")
Private cGetRelea  := SZP->ZP_RELEASE
Private nCBoxLado  := SZP->ZP_LADO
Private lCBoxParc  := iif(SZP->ZP_PLNPARC=="S",.T.,.F.)
Private cGetStatus := SZP->ZP_NUM+' ALTERANDO...'
/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
SetPrvt("oFont3","oFont4","oFont2","oFont1","oDlg1","oGrpModelo","oCodKit","oCodKit","oSayUm","oGetDescPr")
SetPrvt("oGetUmPrd","oGrpEntrega","oSayPlano","oSayLocal","oSayCCusto","oSayMultp","oSayQtde","oSayConsLado")
SetPrvt("oGetLocal","oGetCCusto","oGetQtde","oGetMultp","oCBoxLado","oGrpDts","oSayDtIni","oSayDtEntrega","oSayDtEmissao")
SetPrvt("oGetDtIni","oGetDtEntrega","oGetDtEmissao","oGetObs","oGrpModel","oSayNomCli","oSayCodCli","oSayLjCli")
SetPrvt("oGetCodCli","oGetRelea","oBtnGerPln","oBtnFechar","oCBoxParc","oBtnGerPln","oBtnFechar", "oGetStatus")


oFont3     := TFont():New( "MS Sans Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oFont4     := TFont():New( "Times New Roman",0,-15,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oFont1     := TFont():New( "MS Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 105,332,671,1071,"Gera��o de Planos...",,,.F.,,,,,,.T.,,,.T. )
oGrpModelo := TGroup():New( 004,004,056,360,"Modelo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayCodKit := TSay():New( 012,008,{||"C�digo do Kit:"},oGrpModelo,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,012)
oSayDescKit:= TSay():New( 012,081,{||"Descri�ao do Kit"},oGrpModelo,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,079,012)
oSayUm     := TSay():New( 012,325,{||"UM"},oGrpModelo,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,012)
oGetDescPr := TGet():New( 024,080,{|u| If(PCount()>0,cGetDescPr:=u,cGetDescPr)},oGrpModelo,244,014,'',,CLR_BLACK,CLR_LIGHTGRAY,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDescPr",,)
oGetDescPr:Disable()
oGetCodKit := TGet():New( 024,008,{|u| If(PCount()>0,cGetCodKit:=u,cGetCodKit)},oGrpModelo,056,014,'', ,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetCodKit",,)
oGetUmPrd  := TGet():New( 024,326,{|u| If(PCount()>0,cGetUmPrd:=u,cGetUmPrd)},oGrpModelo,023,014,'',,CLR_BLACK,CLR_LIGHTGRAY,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetUmPrd",,)
oGetUmPrd:Disable()
oGrpEntreg := TGroup():New( 060,004,116,360,"Dados do Plano...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayPlano  := TSay():New( 072,008,{||"Num Plano"},oGrpEntrega,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oSayLocal  := TSay():New( 072,141,{||"Armazem"},oGrpEntrega,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oSayCCusto := TSay():New( 072,234,{||"C.Custo"},oGrpEntrega,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oSayQtde   := TSay():New( 097,008,{||"Quantidade"},oGrpEntrega,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oSayMultp  := TSay():New( 097,141,{||"Multiplos"},oGrpEntrega,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,047,012)
oSayConsLa := TSay():New( 096,230,{||"Cons.Lado"},oGrpEntrega,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,047,012)
oGetPlano  := TGet():New( 068,060,{|u| If(PCount()>0,cGetPlano:=u,cGetPlano)},oGrpEntrega,076,014,'@!',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetPlano",,)
oGetPlano:Disable()
oGetLocal  := TGet():New( 068,189,{|u| If(PCount()>0,cGetLocal:=u,cGetLocal)},oGrpEntrega,031,014,'',{|| U_DM_LOC() },CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetLocal",,)
oGetLocal:Disable()
oGetCCusto := TGet():New( 068,276,{|u| If(PCount()>0,cGetCCusto:=u,cGetCCusto)},oGrpEntrega,060,014,'@!',{|| CTB105CC()},CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CTT","cGetCCusto",,)
oGetCCusto:Disable()
oGetQtde   := TGet():New( 093,060,{|u| If(PCount()>0,nGetQtde:=u,nGetQtde)},oGrpEntrega,076,014,'@E 99,999,999.99',{|| U_DM_QTDE() },CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtde",,)
oGetQtde:Disable()
oGetMultp  := TGet():New( 093,189,{|u| If(PCount()>0,nGetMult:=u,nGetMult)},oGrpEntrega,031,014,'@E 9,999',{|| U_DM_MULT() },CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetMult",,)
oGetMultp:Disable()
oCBoxLado  := TComboBox():New( 094,280,{|u| If(PCount()>0,nCBoxLado:=u,nCBoxLado)},{"Nao","Sim"},060,016,oGrpEntrega,,,,CLR_BLACK,CLR_WHITE,.T.,oFont2,"",,,,,,,nCBoxLado )
oCBoxLado:Disable()
oGrpDts      := TGroup():New( 120,004,176,360,"Datas de Producao...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayDtIni  := TSay():New( 132,008,{||"Previsao Ini"},oGrpDts,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oSayDtEntr := TSay():New( 132,128,{||"Entrega"},oGrpDts,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,012)
oSayDtEmis := TSay():New( 132,231,{||"DT Emissao"},oGrpDts,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oSayObs    := TSay():New( 157,008,{||"Observa��o"},oGrpDts,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oGetDtIni  := TGet():New( 128,061,{|u| If(PCount()>0,cGetDtIni:=u,cGetDtIni)},oGrpDts,064,014,'@r 99/99/9999',{|| ! empty( cGetDtIni )},CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDtIni",,)
oGetDtIni:Disable()
oGetDtEntr := TGet():New( 128,164,{|u| If(PCount()>0,cGetDtEntr:=u,cGetDtEntr)},oGrpDts,064,014,'@r 99/99/9999',{|| ! empty( cGetDtEntr )},CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDtEntr",,)
oGetDtEntr:Disable()
oGetDtEmis := TGet():New( 128,285,{|u| If(PCount()>0,cGetDtEmis:=u,cGetDtEmis)},oGrpDts,064,014,'@r 99/99/9999',{|| ! empty( cGetDtEmis )},CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDtEmis",,)
oGetDtEmis:Disable()
oGetObs    := TGet():New( 153,060,{|u| If(PCount()>0,cGetObs:=u,cGetObs)},oGrpDts,289,014,'@!',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetObs",,)
oGrpModel  := TGroup():New( 177,004,240,360,"Modelo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayNomCli := TSay():New( 185,088,{||"Nome do Cliente"},oGrpModel,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,079,012)
oSayCodCli := TSay():New( 185,008,{||"Cliente"},oGrpModel,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,012)
oSayLjCli  := TSay():New( 185,062,{||"Loja"},oGrpModel,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,027,012)
oSayRelea  := TSay():New( 225,008,{||"Release"},oGrpModel,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oGetCodCli := TGet():New( 197,008,{|u| If(PCount()>0,cGetCodCli:=u,cGetCodCli)},oGrpModel,036,014,'',{|| DM_BUSCACLI() },CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1","cGetCodCli",,)
oGetLjCli  := TGet():New( 197,062,{|u| If(PCount()>0,cGetLjCli:=u,cGetLjCli)},oGrpModel,014,014,'',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetCodCli",,)
oGetNomeCl := TGet():New( 197,087,{|u| If(PCount()>0,cGetNomeCli:=u,cGetNomeCli)},oGrpModel,265,014,'',,CLR_BLACK,CLR_LIGHTGRAY,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetNomeCli",,)
oGetNomeCli:Disable()
oCBoxParc  := TCheckBox():New( 221,290,"PARCIAL",{|u| If(PCount()>0,lCBoxParc:=u,lCBoxParc)},oGrpModel,080,012,,{|| vldGPParc(lCBoxParc) },oFont2,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBoxParc:Disable()
oGetRelea  := TGet():New( 221,054,{|u| If(PCount()>0,cGetRelea:=u,cGetRelea)},oGrpModel,120,014,'@!',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetRelea",,)
oGetStatus := TGet():New( 221,176,{|u| If(PCount()>0,cGetStatus:=u,cGetStatus)},oGrpModel,110,014,'@!',,CLR_BLACK,CLR_YELLOW,oFont2,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cGetStatus",,)
oGetStatus:Disable()
oBtnGerPln := TButton():New( 249,268,"Gerar Plano",oDlg1,{|| VLDGer('ALT') },090,020,,oFont3,,.T.,,"",,,,.F. )
oBtnPcs    := TButton():New( 249,166,"Inserir Pe�as",oDlg1,{||iif(lCBoxParc, {ICPC(cGetCodKit)},Alert('Plano Parcial nao ativado!')) },090,020,,oFont3,,.T.,,"",,,,.F. )
if !lCBoxParc
	oBtnPcs:Disable()
endif
oBtnFechar := TButton():New( 249,066,"Cancelar",oDlg1,{|| oDlg1:end()},090,020,,oFont3,,.T.,,"",,,,.F. )
//oBtnFechar := TButton():New( 249,066,"Cancelar",oDlg1,{|| CancPRoc()},090,020,,oFont3,,.T.,,"",,,,.F. )
//oBtnFechar  := SButton():New( 249,066,2,{|| CancPRoc()}, oDlg1 ,,"",)

oDlg1:Activate(,,,.T.)

Return


////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para exclusao dos planos do sistema antes de gerar novos planos na alteracao do mesmo
//Faz a checagem das fichas geradas, verifica se existe apontamento das mesmas
//caso afirmativo nao permite exclusao e nova geracao
//Verifica se existe algum apontamento para o plano e tambem barra a exclusao.
////////////////////////////////////////////////////////////////////////////////////////////////
user function excALT_COS()
local cPlano := SZP->ZP_OPMIDO
local cAno   := SZP->ZP_ANO
local nCount := 0
local lRet   := .F. 

if !APMSGNOYES('O plano '+cPlano+' ser� excluido e gerado novamente! '+chr(13)+'Confirma a Operacao ?','ATENCAO...')
	Alert('Operacao Cancelada!!!!!!')
	Return
endif

Alert('Clique OK para iniciar o processo'+chr(13)+'Esse processo pode demorar um pouco para finalizar todas as verificacoes/exclusoes.')

//Verificar se existem fichas apontadas para o plano
qSZ7 := " SELECT Z7_PLANO FROM SZ7010 WHERE D_E_L_E_T_ = ' ' AND Z7_FILIAL = '"+xFilial('SZ7')+"' AND Z7_PLANO = '"+cPlano+"' AND Substring(Z7_DTAPON,1,4)='"+cAno+"' " 
if Select("TRBZ7") > 0
	dbSelectArea('TRBZ7')
	TRBZ7->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", tcGenQry( ,, qSZ7), "TRBZ7", .T.,.T.)

dbSelectArea('TRBZ7')
dbGotop()
while !TRBZ7->(eof())
	nCount++
	TRBZ7->(dbSkip())
enddo

if nCount > 0 
	ApmsgInfo('O Plano ja possui fichas apontadas!'+chr(13)+chr(13)+'Exclusao nao permitida.','ATENCAO...!')
	return
endif

//Verificar se existe alguma Ordem de Producao que foi apontada que nao seja por ficha de producao
if Select("TRBC2") > 0 
	dbSelectArea("TRBC2")
	dbCloseArea()
endif

cQSC2 := " SELECT C2_NUM from SC2010 WHERE C2_FILIAL = '"+xFilial('SC2')+"' AND C2_OPMIDO = '"+cPlano+"' AND SUBSTRING(C2_EMISSAO,1,4)= '"+cAno+"' AND D_E_L_E_T_ = ' ' "
cQSC2 += " AND C2_QUJE > 0 " 

dbUseArea(.T., "TOPCONN", TcGenQry(,,cQSC2), "TRBC2", .T.,.T.)

nCount := 0
dbSelectArea("TRBC2")
dbGotop()
while !TRBC2->(eof())
	nCount++
	TRBC2->(dbSkip())
enddo

if nCount > 0
	Alert('J� existe apontamento de pe�as para este plano, exclus�o n�o permitida! ')
	Return
endif

//Faz a exclusao das fichas geradas no arquivo SZ3 
	
cQSZ3 := " UPDATE SZ3010 SET D_E_L_E_T_ = '*' where D_E_L_E_T_ = ' ' AND Z3_PLANO = '"+cPlano+"' AND Substring(Z3_DTFICHA,1,4) = '"+cAno+"' "
cQSZ3 += " AND Z3_FILIAL = '"+xFilial("SZ3")+"' "
		
nret1 := TcSqlExec( cQSZ3 )
				

cQUPDZP := " UPDATE SZP010 SET ZP_LIBER = space(2), ZP_USLIB1 =space(6), ZP_USLIB2=space(6), ZP_DTLIB1 =space(8), ZP_DTLIB2 =space(8), ZP_HRLIB1=space(5), ZP_HRLIB2 = space(5), ZP_OK = space(2) WHERE D_E_L_E_T_ = ' ' AND ZP_FILIAL = '"+xFilial("SZP")+"' AND ZP_OPMIDO = '"+cPlano+"' AND ZP_ANO = '"+cAno+"' " 
nret1 := TcSqlExec ( cQUPDZP ) 

//Faz a exclusao das OPS no arquivo SC2
if Select("TRBC2") > 0 
dbSelectArea("TRBC2")
dbCloseArea()
endif


cQSC2 := " SELECT C2_NUM from SC2010 WHERE C2_FILIAL = '"+xFilial('SC2')+"' AND C2_OPMIDO = '"+cPlano+"' AND SUBSTRING(C2_EMISSAO,1,4)= '"+cAno+"' AND D_E_L_E_T_ = ' ' "

dbUseArea(.T., "TOPCONN", TcGenQry(,,cQSC2), "TRBC2", .T.,.T.)

nCount := 0
dbSelectArea("TRBC2")
dbGotop()
ProcRegua(0)
dbSelectArea('SC2')
dbSetOrder(1)
while !TRBC2->(eof())
	if SC2->(dbSeek(xFilial('SC2')+TRBC2->C2_NUM))
		aCab := {}
		AAdd( aCab, {'C2_FILIAL'		,		 XFILIAL('SC2' )				,			nil					})
		AAdd( aCab, {'C2_NUM' 			, 		 SC2->C2_NUM					,			nil					})
		AAdd( aCab, {'C2_ITEM'			,		 '01' 							,			nil					})
		AAdd( aCab, {'C2_SEQUEN'		,	     '001'							,			nil					})
		AAdd( aCab, {'C2_PRODUTO'		,		 SC2->C2_PRODUTO				,			nil					})
		AAdd( aCab, {'C2_QUANT'		    ,		 SC2->C2_QUANT					, 			nil					})
		AAdd( aCab, {'C2_LOCAL'		    ,		 SC2->C2_LOCAL					,			nil					})
		AAdd( aCab, {'C2_CC'		  	,	 	 SC2->C2_CC						,			nil 				})
		AAdd( aCab, {'C2_DATPRI'	    ,		 SC2->C2_DATPRI					,			nil					})
		AAdd( aCab, {'C2_DATPRF'		,		 SC2->C2_DATPRF					,			nil					})
		AAdd( aCab, {'C2_EMISSAO'	    ,	     SC2->C2_EMISSAO				,			nil					})
		AAdd( aCab, {'C2_OPMIDO'	    ,		 SC2->C2_OPMIDO					,			nil		  			})
		AAdd( aCab, {'C2_CLIENTE'	    ,		 SC2->C2_CLIENTE				,			nil		  			})
		AAdd( aCab, {'C2_LOJA' 			, 		 SC2->C2_LOJA					,  			nil					})
		AAdd( aCab, {'C2_LADO'			,		 SC2->C2_LADO					, 			nil					})
		AAdd( aCab, {'C2_RELEASE' 		,		 SC2->C2_RELEASE				, 			nil 				})
		AAdd( aCab, {'C2_DTRELE'		, 		 SC2->C2_DTRELE					, 			nil 				})
		AAdd( aCab, {'C2_ITEMCTA'		,		 xFilial("SC2")					, 			nil 				})
		AAdd( aCab, {'C2_QTDLOTE'	    ,	     SC2->C2_QTDLOTE				,			nil					})
		AAdd( aCab, {'C2_OBS'           ,       SC2->C2_OBS						,			nil        			}) 
		AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
		AAdd( aCab, {"AUTEXPLODE"       ,        'S'							,			NIL 			   	})
		
		
		lMsErroAuto := .f.
		msExecAuto({|x,Y| Mata650(x,Y)},aCab,5)
	
			If lMsErroAuto
				MostraErro()
				lRet:= .F.
			endif
	endif
	TRBC2->(dbSkip())
	incProc("Excluindo plano - Por Favor Aguarde.... OP: "+SC2->C2_NUM)
	lRet :=.T.
enddo

if nCount == 0
	lRet := .T.
endif
//Alert('Plano '+cPlano+' anterior excluido com Sucesso....'+chr(13)+'Clique em OK para gerar os novos planos...')

//Alert('Vai excluir o plano:' +cPlano+' gerado no ano de '+cAno)
return lRet