#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

//////////////////////////////////////////////////////////////////////////////////////////////
//Programa com o objetivo de gerar Pedido de Couro para PNP1
//Utilizado nas filiais PNP2 e BRB
//Desenvolvido por Diego Mafisolli em 04/04/2017
//Solicitante Renato Bertelli
//////////////////////////////////////////////////////////////////////////////////////////////


User Function DMPEDCOU()

Private cGetnPln   := space(20)
Private cGetStPed  := '...'
Private cGetTES    := Space(03)
Private CGETTXTES  := space(40)
Private cSayNPln   := Space(20)
Private cSayNPln   := Space(20)
Private cSayStApto := Space(20)
Private cSayStPed  := Space(20)
Private nCBoxTrf
Private aItens := {}
Private nGetQtdKit := 0
Private cGetCC := space(6)
Private cGetLoc := space(2)
Private cGetDtPrv := CTOD('  /  /  ')

SetPrvt("oFontStatus","oDlgPedTrf","oGrpPln","oSayNPln","oSayStApto","oSayStPed","oGetnPln")
SetPrvt("oGrpTES","oSay3","oGetTES","oBtn1","oBtn2","oGet1","oCBoxTrf","oGetQtdKit","oGetCC","oSayCC","oGetDtPrv","oSayDtPrv")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

if cFilant $ '08|19'
	oFontStatu := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
 	oDlgPedTrf := MSDialog():New( 155,208,388,899,"Gera Pedido de Couro baseado na Estrutura....",,,.F.,,,,,,.T.,,,.T. )
	oGrpPln    := TGroup():New( 004,004,76,336,"Dados para Pedido...",oDlgPedTrf,CLR_BLACK,CLR_WHITE,.T.,.F. ) 
	oSayNPln   := TSay():New( 020,008,{||"Código Kit PNP1: "},oGrpPln,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,012)
	oGetnPln   := TGet():New( 030,008,{|u| If(PCount()>0,cGetnPln:=u,cGetnPln)},oGrpPln,108,012,'@!',{|| Iif(cGetnPln <> space(20),VldKit(),"")},CLR_BLACK,CLR_WHITE,oFontStatus‰,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SG1","cGetnPln",,)      
	oSayStPed  := TSay():New( 020,130,{||"Descrição Kit"},oGrpPln,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
	oGetStPed  := TGet():New( 030,130,{|u| If(PCount()>0,cGetStPed:=u,cGetStPed)},oGrpPln,180,012,'@!',,CLR_BLACK,CLR_WHITE,oFontStatus,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cGetStPed",,)
	oGetStPed:Disable()
	oSay4      := TSay():New( 046,008,{||"Quant. Kit: "},oGrpPln,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,059,012)
	oGetQtdKit := TGet():New( 056,008,{|u| If(PCount()>0,nGetQtdKit:=u,nGetQtdKit)},oGrpPln,048,012,'@E 9,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetQtdKit",,)      
	oSayCC      := TSay():New( 046,058,{||"C. Custo: "},oGrpPln,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,059,012)
	oGetCC 		:= TGet():New( 056,058,{|u| If(PCount()>0,cGetCC:=u,cGetCC)},oGrpPln,048,012,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetCC",,)      
	oSayLoc   	:= TSay():New( 046,112,{||"Armazém: "},oGrpPln,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,059,012)
	oGetLoc		:= TGet():New( 056,112,{|u| If(PCount()>0,cGetLoc:=u,cGetLoc)},oGrpPln,048,012,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetLoc",,)      
	oSayDtPrv  	:= TSay():New( 046,164,{||"Data P/ Entrega: "},oGrpPln,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,059,012)
	oGetDtPrv  := TGet():New( 056,164,{|u| If(PCount()>0,cGetDtPrv:=u,cGetDtPrv)},oGrpPln,064,012,'@R 99/99/9999',{|| ! empty( cGetDtPrv )},CLR_BLACK,CLR_WHITE,oFontStatus,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDtPrv",,)
	oSayNumPed  := TSay():New( 062,250,,oGrpPln,,oFontStatus,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,150,012)
    //oGrpTES    := TGroup():New( 053,005,104,337,"Dados da TES...",oDlgPedTrf,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oSay3      := TSay():New( 069,009,{||"TES:"},oGrpTES,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
    //oGetTES    := TGet():New( 067,025,{|u| If(PCount()>0,cGetTES:=u,cGetTES)},oGrpTES,032,008,'@!',{|| vldTes(cGetTES) },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF4","cGetTES",,)
   // oSay4      := TSay():New( 086,010,{||"Qtde Kit: "},oGrpPln,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,059,008)
	oBtn1      := TButton():New( 090,200,"GERAR PEDIDO",oGrpPln,{||vldPln()},060,020,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 090,269,"SAIR",oGrpPln,{||oDlgPedTrf:End()},060,020,,,,.T.,,"",,,,.F. )
   //oGet1      := TGet():New( 067,069,{|u| If(PCount()>0,cGetTxTES:=u,cGetTxTES)},oGrpTES,104,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cGetTxTES",,)	
   //oCBoxTrf   := TComboBox():New( 069,209,{|u| If(PCount()>0,nCBoxTrf:=u,nCBoxTrf)},{"01-B.Funda","04-Alto Alegre","08-PNP 2","19-Barbosa"},056,010,oGrpTES,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nCBoxTrf )
	//oGetPlano  := TGet():New( 068,060,{|u| If(PCount()>0,cGetPlano:=u,cGetPlano)},oGrpEntrega,076,014,'@!',{|| iif(VldNumPln(cGetPlano),oGetLocal:SetFocus(),oGetPlano:SetFocus())},CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetPlano",,)
	//oGetLocal  := TGet():New( 068,189,{|u| If(PCount()>0,cGetLocal:=u,cGetLocal)},oGrpEntrega,031,014,'',{|| U_AGFLOC() },CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetLocal",,)
	
	
	oDlgPedTrf:Activate(,,,.T.)
else
	//Alert("Rotina disponivel apenas para as filiais de costura!")
	MsgInfo( "Rotina disponivel apenas para as filiais de costura!", "Gera Ped.Couro Automatico" )
endif

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Funcao de validação do plano
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static function vldPln()  

Local lRet := .T.

if cGetnPln == space(20)
	//Alert("Não foi informado nenhum código de estrutura! "+chr(13)+chr(13)+"Digite um código válido!")      
	MsgInfo( "Não foi informado nenhum código de estrutura! "+chr(13)+"Digite um código válido!", "Aviso" )
	oGetnPln:setfocus()
	lRet := .F.
endif           

If nGetQtdKit == 0   .Or. nGetQtdKit < 0
   	MsgInfo( "Quantidade informada é inválida", "Aviso" )       
   	oGetQtdKit:setfocus()  
	lRet := .F.
endif
//cGetStPed := "ANALISANDO..."
//oGetStPed:refresh()   

If lRet 
	ConfPed()
Endif

return 
         
//////////////////////////////////////////////////////////////////////////////////////
//FUNCAO PARA VALIDAR INFORMACOES DO KIT INFORMADAS
//////////////////////////////////////////////////////////////////////////////////////
static function VldKit()       

cQuery := "SELECT G1_COD, G1_COMP, G1_QUANT, G1_UM, G1_PERDA, G1_QUANT, G1_INI, G1_FIM "
cQuery += "FROM SG1010 "
cQuery += "WHERE "
cQuery += "G1_FILIAL = '09' AND "
cQuery += "G1_COD IN ('"+cGetnPln+"') AND "       
cQuery += "SG1010.D_E_L_E_T_ = '' "
cQuery += "ORDER BY G1_COD, G1_COMP"

if Select("TMPG1") > 0
	dbSelectArea("TMPG1")
 	TMPG1->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(,, cQuery), "TMPG1",.T., .T.)

COUNT TO nRec

If nRec > 0
	cGetStPed:= Posicione("SB1",1,xFilial("SB1")+cGetnPln,"B1_DESC")
	oGetStPed:refresh() 
Else
	MsgInfo( "O código informado não possui estrutura.", "Aviso" ) 
	oGetnPln:setfocus()  
Endif

return
   

//////////////////////////////////////////////////////////////////////////////////////
//ROTINA PARA VALIDAR O INICIO DA GERACAO DO PEDIDO DE TRANSFERENCIA
//////////////////////////////////////////////////////////////////////////////////////
static function ConfPed()
if APMSGYESNO("Confirma a geração do pedido de couro"+chr(13)+"? ","ATENÇÃO")
	processa({|| geraped(), "Gerando pedido de couro..." })
endif

return

//////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////
static function geraped()

Local nCount     := 0
Local cNumPed    := space(6)
Local aCab 		 :={} 
Local aItem		 :={}    
Local aAux       := {}
Local nCount     := 0
Local cQuery 	 := ""
Local cData 	 := dtos(ddatabase)

cQuery := "SELECT G1_COD, G1_COMP, G1_QUANT, G1_UM, G1_PERDA, G1_QUANT, G1_INI, G1_FIM "
cQuery += "FROM SG1010 "
cQuery += "WHERE "
cQuery += "G1_FILIAL = '09' AND "
cQuery += "G1_COD IN ('"+cGetnPln+"') AND "       
cQuery += "G1_INI <= '"+dTos(dDataBase)+"' AND G1_FIM >= '"+dTos(dDataBase)+"' AND "
cQuery += "SG1010.D_E_L_E_T_ = '' "
cQuery += "ORDER BY G1_COD, G1_COMP"

if Select("TRBG1") > 0
	dbSelectArea("TRBG1")
 	TRBG1->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(,, cQuery), "TRBG1",.T., .T.)
//ApMsgInfo("TECLE OK para Iniciar a geração do pedido...")
ProcRegua(595300)
dbSelectArea("TRBG1")
TRBG1->(dbGotop())

cNumPed := GetSxeNum('SC7','C7_NUM')   

aCab:={{"C7_NUM"  ,cNumPed    ,Nil},; // Numero do Pedido 
	{"C7_EMISSAO" ,dDataBase     ,Nil},; // Data de Emissao 
	{"C7_FORNECE" ,"000148"     ,Nil},; // Fornecedor 
	{"C7_LOJA"    ,"09"          ,Nil},; // Loja do Fornecedor 
	{"C7_CONTATO" ,""			 ,Nil},; // Contato 
	{"C7_COND"    ,"001"		 ,Nil},; // Condicao de pagamento  
	{"C7_FILENT"  ,cFilAnt       ,Nil}}  
	
	If cGetLoc == space(2)
		cGetLoc = "01"
	Endif
		        
while !TRBG1->(eof())
	    IncProc("Gerando Pedido de Couro...")
//		IndRegua("Gerando Pedido de Transferencia..."+TRBC2->C2_PRODUTO)
			//cItem := soma1(cItem)
			nValor:= round(U_AGF_SHCUS(TRBG1->G1_COMP, '01', ''),6)
		   	//Alert("PRODUTO:"+TRBG1->G1_COMP+" | Valor: "+cValToChar(nValor))							     
			nQtde:= TRBG1->G1_QUANT*nGetQtdKit
			
			AAdd(aItem,{{"C7_TIPO"      ,"1",													,NIL},;
				{"C7_PRODUTO"	,TRBG1->G1_COMP            										,NIL},;
				{"C7_DESCRI"    ,Posicione("SB1",1,xFilial("SB1")+TRBG1->G1_COMP,"B1_DESC")		,NIL},;
				{"C7_UM"   		,Posicione("SB1",1,xFilial("SB1")+TRBG1->G1_COMP,"B1_UM")		,NIL},;
				{"C7_QUANT" 	,nQtde															,NIL},;
				{"C7_PRECO"		,nValor			   								   				,NIL},;
				{"C7_TOTAL"		,Round(nQtde*nValor,2) 			  								,NIL},;	
				{"C7_LOCAL"		,cGetLoc														,NIL},;
				{"C7_OBS"    	,"PEDIDO GERADO AUTOMATICO"										,NIL},;									   
				{"C7_CC"   		,cGetCC															,NIL},;			   			   		   
				{"C7_MOEDA"   	,"1"															,NIL},; 
				{"C7_DATPRF"    ,cGetDtPrv		 												,Nil},;
				{"C7_APROV"     ,"000024"		 												,Nil},;
				{"C7_TXMOEDA"  	,"1"															,NIL}})
															
  TRBG1->(dbSkip())
enddo

	lMsErroAuto := .F.
	MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCab,aItem,3) 

		If lMsErroAuto
			Mostraerro()
			RollBackSX8()			
		Else
			ConfirmSX8()  
			aItem   := {}
			aCab    := {}
			Alert("Pedido de Compra Gerado-> "+SC7->C7_NUM)
			oSayNumPed:SetText("NUM. PEDIDO: "+SC7->C7_NUM)
		   	oBtn1:Disable()			
		EndIf

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Validar o Centro de Custos
static function VldCC(cCC)
if Substr(cCC,1,1) <> '3'
	if Substr(cCC,1,1) == ' '
		Alert("Informe um centro de custo válido!!")
	else
		Alert("Centro de Custo "+cCC+" não pertence a um centro de custo produtivo")
	endif
	oGetCC:SetFocus()
	Return.F.
endif

	if !u_ag_blqctt(cCC,"","") //Valida o centro de custo para nao utilizar C.Custo diferente do permitido a partir de ABR/2014
		oGetCC:SetFocus()
		Return .F.
	endif
return