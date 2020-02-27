#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'PROTHEUS.CH'

/////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para gerar embarque dos planos conforme layout novo.
//Desenvolvido por Anesio G.Faria - Setembro/2012
/////////////////////////////////////////////////////////////////////////////////////////////    

user function PLANOS_MVC()
Local oBrowse
oBrowse := FWMarkBrowse():New()
oBrowse:SetAlias('SZP')
oBrowse:SetFieldMark( 'ZP_OK' )
oBrowse:AddLegend( "ZP_EMBARC=='P'", "YELLOW", "Embarque Parcial" )
oBrowse:AddLegend( "ZP_EMBARC<>'P'", "BLUE" , "Ainda não embarcado" )
oBrowse:SetFilterDefault("ZP_EMBARC <> 'S' ")
oBrowse:SetDescription('Geracao de Embarque de Planos')
oBrowse:Activate()
Return Nil

 
/////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////    
Static Function MenuDef()
Local aRotina := {}                                                                      
	ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.PLANOS_MVC' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Gerar Embarque' ACTION 'U_MVCGEREMB()' OPERATION 2 ACCESS 0
//	ADD OPTION aRotina Title 'Alterar' Action 'VIEWDEF.PLANOS_MVC' OPERATION 4 ACCESS 0
//	ADD OPTION aRotina Title 'Excluir' Action 'VIEWDEF.PLANOS_MVC' OPERATION 5 ACCESS 0
//	ADD OPTION aRotina Title 'Imprimir' Action 'VIEWDEF.PLANOS_MVC' OPERATION 8 ACCESS 0
//	ADD OPTION aRotina Title 'Copiar' Action 'VIEWDEF.PLANOS_MVC' OPERATION 9 ACCESS 0
Return aRotina

/////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////
Static Function ModelDef()

Local oStruZP := FWFormStruct(1,'SZP')
Local oStruZG := FWFormStruct(1,'SZG' )
Local oModel
oModel := MPFormModel():New('SZP_001')
oModel:AddFields('SZPMASTER',/*cOwner*/,oStruZP)
oModel:AddGrid( 'SZGDETAIL', 'SZPMASTER', oStruZG )



oModel:SetRelation( 'SZGDETAIL', { { 'ZG_FILIAL', 'xFilial( "SZG" )' }, { 'ZG_PLANO', 'ZP_OPMIDO' } }, SZG->( IndexKey( 1 ) ) )

oModel:SetDescription('Embarque de Planos')
oModel:GetModel('SZPMASTER'):SetDescription('Embarque de Planos...')
oModel:GetModel( 'SZGDETAIL' ):SetDescription( 'Planos a embarcar' )
Return oModel 


/////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////
Static Function ViewDef()
//Local oModel := FWLoadModel( 'PLANOS_MVC' )
Local oModel := FWFormModelGrid( 'PLANOS_MVC' )
Local oStruSZP := FWFormStruct( 2, 'SZP' )
Local oStruSZG := FWFormStruct( 2, 'SZG' )
Local oViewDef := FWFormView():New()

oViewDef:SetModel( oModel )
oViewDef:AddGrid( 'VIEW_SZP', oStruSZP, 'SZPMASTER' )
oViewDef:AddGrid( 'VIEW_SZG', oStruSZG, 'SZGDETAIL' )

//oViewDef:CreateHorizontalBox( 'TELA' , 100 )
oViewDef:CreateHorizontalBox( 'SUPERIOR', 40 )
oViewDef:CreateHorizontalBox( 'INFERIOR', 60 )

//oViewDef:SetOwnerView( 'VIEW_SZP', 'TELA' )
oViewDef:SetOwnerView( 'VIEW_SZP', 'SUPERIOR' )
oViewDef:SetOwnerView( 'VIEW_SZG', 'INFERIOR' )


Return oViewDef


/////////////////////////////////////////////////////////////////////////////////////////////
//Funcao para gerar o embarque
/////////////////////////////////////////////////////////////////////////////////////////////
User function MVCGEREMB()
Local aArea  := GetArea()
Local cMarca := oMark:Mark()
Local cMarca1:= oMark:Mark()
Local nCnt   := 0
Local cNum   := ""
Local cInvoice := space(10)
Local oNum
Local lInverte := .F.
Local lEmbarque:= .F.
Local oMarkbrw
Local cChave 
Local lMostra := .F. 
Local aArea := GetArea()
Local lInverte := .F.
LOCAL aDBF:={{"ZG_OK"			 ,"C",02,00},; 
		     {"ZG_FILIAL"		 ,"C",02,00},;
             {"ZG_NUMEMB"  		 ,"C",06,00},;
             {"ZG_PLANO"    	 ,"C",12,00},;
             {"ZG_SEQUEN"		 ,"C",02,00},;
             {"ZG_QTDEPLA"		 ,"N",14,02},;
             {"ZG_DATA" 		 ,"D",8,00},;
             {"ZG_DTEMBAR"		 ,"D",8,00},;
             {"ZG_QTDEEMB"		 ,"N",12,02},;
             {"ZG_QTDISPE"		 ,"N",12,02},;
             {"ZG_USUARIO"		 ,"C",12,00},;
             {"ZG_EMBARCA"		 ,"C",1,00}}

LOCAL TB_Campos:={{"ZG_OK","",""},;
			 {"ZG_FILIAL"	 ,"" ,"FILIAL"  },;
             {"ZG_NUMEMB"  		 ,"","NUM.EMBARC"},;
             {"ZG_PLANO"    	 ,"","PLANO"},;
             {"ZG_SEQUEN"		 ,"","SEQUENC"},;
             {"ZG_QTDEPLA"		 ,"","QTDE PLAN"},;
             {"ZG_DATA" 		 ,"","EMISSAO"},;
             {"ZG_DTEMBAR"		 ,"","DT.EMBARQ"},;
             {"ZG_QTDEEMB"		 ,"","QTD EMBARC"},;
             {"ZG_QTDISPE"		 ,"","QTD DISP"},;
             {"ZG_USUARIO"		 ,"","USUARIO"},;
             {"ZG_EMBARCA"		 ,"","EMBARC"}}


PRIVATE aHeader[0],aCampos:={}//E_CriaTrab utiliza

PROCREGUA(2)
INCPROC("Criando Arquivos Temporarios","Aguarde")
cNomArq:=E_CriaTrab(,aDBF,"WORK_IN")


IF !USED()
   MSGINFO("Nao foi possivel criar Temporario")
   RETURN .F.
ENDIF   

INCPROC()
INDREGUA("WORK_IN",cNomArq+OrdBagExt(),"ZG_NUMEMB+ZG_PLANO")



	AADD(aCampos,{"ZG_OK","","  ",""})
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek ("SZG")
	While !EOF() .And. (x3_arquivo == "SZG")
		IF  (X3USO(x3_usado)  .AND. cNivel >= x3_nivel .and. SX3->X3_context # "V") .Or.;
			(X3_PROPRI == "U" .AND. X3_CONTEXT!="V" .AND. X3_TIPO<>'M').and.X3_CAMPO =="ZG_NUMEMB"
			AADD(aCampos,{X3_CAMPO,"",X3Titulo(),X3_PICTURE, x3_tamanho, x3_decimal, x3_valid,x3_usado, x3_tipo, "TMP", x3_context})
		Endif
		dbSkip()
	Enddo

                   
Private aCores := {{"","BR_AMARELO"}, ;
					{"","BR_VERDE"}}

if ApmsgNoYes('Confirma a geração do embarque referente aos planos selecionados ? ')
	cQuery := " SELECT MAX(ZG_NUMEMB) ZG_NUM FROM SZG010 WHERE D_E_L_E_T_ = ' ' AND ZG_FILIAL ='"+xFilial('SZG')+"' "
	if Select('TMPZG') > 0 
		dbSelectArea('TMPZG')
		TMPZG->(dbCloseArea())
	endif
	
	dbUseArea(.T., 'TOPCONN', tcGenQry( , , cQuery), 'TMPZG',.F.,.F.)
	

////////////////////////////


////////////////////////////
	cNum := Soma1(TMPZG->ZG_NUM) 
	dbSelectArea('SZG')
	SZP->(dbGotop())
	While !SZP->(eof())
		if oMark:IsMark(cMarca).and.SZP->ZP_EMBARC <> 'S'
			cQuery := " SELECT SUM(ZG_QTDEEMB) QTDEMB FROM SZG010 WHERE D_E_L_E_T_ = ' ' AND ZG_FILIAL = '"+xFilial('SZG')+"' AND SUBSTRING(ZG_DTEMBAR,1,4) = '"+Substr(DTOS(SZP->ZP_EMISSAO),1,4)+"' AND ZG_PLANO = '"+SZP->ZP_OPMIDO+"' "
			if Select('TMPZG') > 0 
				dbSelectArea('TMPZG')
				TMPZG->(dbCloseArea())
			endif 
			dbUseArea(.T., 'TOPCONN', TcGenQry(, , cQuery), 'TMPZG', .F.,.F.)
			
			dbSelectArea('TMPZG')
			if SZP->ZP_QUANT - TMPZG->QTDEMB > 0
				lMostra:=.T.
				nCnt++
			
				RecLock('WORK_IN',.T.)
				WORK_IN->ZG_FILIAL   := xFilial('SZG')
				WORK_IN->ZG_NUMEMB   := cNum
				WORK_IN->ZG_PLANO    := SZP->ZP_OPMIDO
				WORK_IN->ZG_SEQUEN   := StrZero(nCnt,2)
				WORK_IN->ZG_QTDEPLA  := SZP->ZP_QUANT
				WORK_IN->ZG_DATA     := dDatabase
				WORK_IN->ZG_DTEMBAR  := dDatabase
				WORK_IN->ZG_EMBARCA  := 'S'
				
				WORK_IN->ZG_QTDEEMB  := SZP->ZP_QUANT - TMPZG->QTDEMB
				
				WORK_IN->ZG_QTDISPE  := SZP->ZP_QUANT - TMPZG->QTDEMB
				WORK_IN->ZG_USUARIO  := Substr(cUsuario,7,15)
				MsUnLock('WORK_IN')
			endif
		endif
		SZP->(dbSkip()) 
	enddo 

	if lMostra
		cMoeda:= "1"
		aSize := MSADVSIZE()
		aMoedas := FDescMoed()  
		
	//////////////////////////////////////////////////////////////////////////////////////////////////////		    	
		DEFINE MSDIALOG oDlg TITLE "TESTE DE TELA" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL // "Informe Fornecedor e Loja"
	    	
			oDlg:lMaximized := .T.
			oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,25,25,.T.,.T.)
			oPanel:Align := CONTROL_ALIGN_TOP   
			cCodigo:= cLoja:= ""          
			aButtons:= {}
			nOpca := 0
			@ 008,003 Say "EMBARQUE"																PIXEL Of oPanel	// "N§ T¡tulos Selecionados: "
			@ 008,040 Say oNum VAR cNum Picture "@!"  FONT oDlg:oFont		PIXEL Of oPanel
			@ 008,200 Say "INVOICE"																PIXEL Of oPanel	// "N§ T¡tulos Selecionados: "
			@ 008,240 MSGET cInvoice Picture "@!" SIZE 80,08  FONT oDlg:oFont		PIXEL Of oPanel
			@ 008,350 CheckBox oEmbarque Var lEmbarque Prompt "Embarcar ?" Size C(056),C(004) PIXEL FONT oDlg:oFont COLOR CLR_BLUE OF oPanel
			
	
	
			WORK_IN->(dbGotop())
			oMarkbrw:= MsSelect():New("WORK_IN",,,TB_Campos,@lInverte,@cMarca1,{34,1,(oDlg:nHeight-30)/2,(oDlg:nClientWidth-4)/2})		
	
			If nOpca == 0
				Aadd( aButtons, {"S4WB010N",{ || SlvEmb(cNum, cInvoice, lEmbarque, nCnt), MVC_PRINT(cNum) }, OemToAnsi("IMPRIMIR")+" "+OemToAnsi("IMPRIMIR"), OemToAnsi("IMPRIMIR")} )
				Aadd( aButtons, {"EDIT",{ || MVC_ALTERA() }, OemToAnsi("ALT.QTDE")+" "+OemToAnsi("ALT.QTDE"), OemToAnsi("ALT.QTDE")} )
			Endif
	
	
	
	//		DEFINE SBUTTON FROM 003,420 TYPE 1 ENABLE OF oPanel ;
	
	 		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| SlvEmb(cNum, cInvoice, lEmbarque, nCnt),oDlg:End()},{|| nOpca := 0,oDlg:End()},,aButtons) CENTERED
	// 		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| If(f040SubOk(@nOpca,nValorS,oDlg),oDlg:End(),.T.)},{|| nOpca := 0,oDlg:End()},,aButtons) CENTERED
	
	
	/*
				SZP->ZP_EMBARC := 'S'
				MsUnLock('SZP')
			endif
	*/
	
	else
		ApMsgInfo('Nenhum plano selecionado...')
	endif
endif
 WORK_IN->(E_EraseArq(cNomArq))
RestArea(aArea) 


static function SlvEmb(cNum,cInvoice, lEmbarque, nCnt)
if Apmsgnoyes('Confirma a geracao do embarque '+cNum)
	dbSelectArea('SZG')
	WORK_IN->(dbGotop())
	while !WORK_IN->(eof())
			RecLock('SZG',.T.)
			SZG->ZG_FILIAL 	:= WORK_IN->ZG_FILIAL
			SZG->ZG_NUMEMB 	:= WORK_IN->ZG_NUMEMB
			SZG->ZG_PLANO 	:= WORK_IN->ZG_PLANO
			SZG->ZG_SEQUEN 	:= WORK_IN->ZG_SEQUEN
			SZG->ZG_QTDEPLA := WORK_IN->ZG_QTDEPLA
			SZG->ZG_DATA 	:= WORK_IN->ZG_DATA
			SZG->ZG_DTEMBAR := WORK_IN->ZG_DTEMBAR
			if lEmbarque
				SZG->ZG_EMBARCA := WORK_IN->ZG_EMBARCA
			else
				SZG->ZG_EMBARCA := 'N'
			endif
			SZG->ZG_QTDEEMB := WORK_IN->ZG_QTDEEMB
			SZG->ZG_QTDISPE := WORK_IN->ZG_QTDISPE
			SZG->ZG_INVOICE := cInvoice
			SZG->ZG_USUARIO := Substr(cUsuario,7,15)
			MsUnlock('SZG')
			
			dbSelectArea('SZP')
			dbSetOrder(2)
			if SZP->(dbSeek(xFilial('SZP')+WORK_IN->ZG_PLANO+Substr(DTOS(WORK_IN->ZG_DATA),1,4)))
				cQuery := " SELECT SUM(ZG_QTDEEMB) QTDEMB FROM SZG010 WHERE D_E_L_E_T_ = ' ' AND ZG_FILIAL = '"+xFilial('SZG')+"' AND SUBSTRING(ZG_DTEMBAR,1,4) = '"+Substr(DTOS(WORK_IN->ZG_DATA),1,4)+"' AND ZG_PLANO = '"+WORK_IN->ZG_PLANO+"' "
				if Select('TMPZG') > 0 
					dbSelectArea('TMPZG')
					TMPZG->(dbCloseArea())
				endif 
				dbUseArea(.T., 'TOPCONN', TcGenQry(, , cQuery), 'TMPZG', .F.,.F.)
				
				dbSelectArea('TMPZG')

				if SZP->ZP_QUANT <= TMPZG->QTDEMB
					RecLock('SZP',.F.)
					SZP->ZP_EMBARC := 'S'
					MsUnLock('SZP')
				else
					RecLock('SZP',.F.)
					SZP->ZP_EMBARC := 'P'
					MsUnLock('SZP')
				endif
			endif
		WORK_IN->(dbSKip())
		
	enddo
	ApMsgInfo('Gerado embarque numero '+cNum+chr(13)+'Total de '+AllTrim( Str (nCnt) ) + ' Planos no embarque' ) 	
//	Alert('Embarque gerado com sucesso....')
endif
return


return nil 


///////////////////////////
static function MVC_PRINT(cNum)
U_AG_RELEMBPL(cNum)
oDlg:End()
return

//////////////////////////
static function MVC_ALTERA()
Private cSayPlnAlt := 'PLANO: '+WORK_IN->ZG_PLANO
Private nSayQtdDes := WORK_IN->ZG_QTDISPE
Private nSayQtdDis := WORK_IN->ZG_QTDISPE

SetPrvt("oFontAltQtde","oDlgAltQtd","oSayPlnAlt","oSayQtdDesc","oSayQtdDisp","oSay1","oBtnConfirm")

oFontAltQt := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oDlgAtlQtd := MSDialog():New( 160,343,324,610,"Alterar quantidade de Embarque...",,,.F.,,,,,,.T.,,,.T. )
oSayPlnAlt := TSay():New( 008,008,{||cSayPlnAlt},oDlgAtlQtd,,oFontAltQtde,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,112,008)
oSayQtdDes := TSay():New( 024,008,{||"Qtde Disp: "},oDlgAtlQtd,,oFontAltQtde,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSayQtdDis := TSay():New( 024,060,{||Transform( nSayQtdDes , '@E 99,999.99')},oDlgAtlQtd,,oFontAltQtde,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)
oSay1      := TSay():New( 044,008,{||"Alterar para: "},oDlgAtlQtd,,oFontAltQtde,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oDlgAlttd  := TGet():New( 056,008,{|u| If(PCount()>0,nSayQtdDis:=u,nSayQtdDis)},oDlgAtlQtd,056,010,'@E 99,999.99',,CLR_BLUE,CLR_WHITE,oFontAltQtde,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nSayQtdDis",,)


oBtnConfir := TButton():New( 056,076,"&Confirmar",oDlgAtlQtd,{|| ConfAlt(), oDlgAtlQtd:end() },037,012,,,,.T.,,"",,,,.F. )

oDlgAtlQtd:Activate(,,,.T.)

static function ConfAlt()
	if nSayQtdDis > 0 .and. nSayQtdDis < WORK_IN->ZG_QTDISPE
		RecLock('WORK_IN',.F.)
		WORK_IN->ZG_QTDEEMB := nSayQtdDis
		MsUnLock('WORK_IN')
	else
		ApMsgInfo('Quantidade informada é inválida...!')
		return .F. 
	endif
return

Return

return



///////////////////////////////////////////////////////////////////////////////////////////
//Relatorio de Embarque
///////////////////////////////////////////////////////////////////////////////////////////

User Function AG_RELEMBPL(cNumEmb)

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario"
Local cDesc3         := "Relatorio de Embarque de Planos"
Local cPict          := ""
Local titulo       := "Relatorio de Embarque de Planos"
Local nLin         := 80

//Local Cabec1       := "0123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 "
//Local Cabec2       := "     1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18    "
Local Cabec1       := "   PLANO      SEQUENCIA          DATA   QTDE PLANO       QTDE DISP             QTDE     INVOICE              PRODUTO                                           CLIENTE"
Local Cabec2       := "                             EMBARQUE                     EMBARQUE        EMBARCADO              "
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "G"
Private nomeprog         := "MD_RELEMBPL" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "MDEMBPL"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "MD_RELEMBPL" // Coloque aqui o nome do arquivo usado para impressao em disco

Public lImpresso


AjustaSx1()
//If ! Pergunte(cPerg,.T.)
//	Return
//Endif

cString := ""


//wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin, cNumEmb) },Titulo)
Return



Static Function RunReport(Cabec1,Cabec2,Titulo,nLin, cNumEmb)

cQuery := " SELECT ZG_NUMEMB, ZG_PLANO, ZG_SEQUEN, ZG_DATA, ZG_QTDEPLA, ZG_DTEMBAR, ZG_EMBARCA, ZG_QTDEEMB, ZG_QTDISPE, ZG_INVOICE "
cQuery += " FROM SZG010 Where D_E_L_E_T_ = ' ' AND ZG_FILIAL = '"+xFilial("SZG")+"' AND ZG_NUMEMB = '"+cNumEmb+"' "
cQuery += " Order By ZG_PLANO "
	
IF SELECT( 'TMPZG' ) > 0
	DbSelectArea( 'TMPZG' )
	DbcloseArea()
ENDIF
	dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQuery  ), 'TMPZG' , .F. , .T. )
                                                
	TcSetField("TMPZG", "ZG_DATA", "D")
	TcSetField("TMPZG", "ZG_DTEMBAR", "D")

SetRegua(RecCount())                                               



dbSelectArea("TMPZG")
TMPZG->(dbGotop())
While !SZG->(EoF()) .and. TMPZG->ZG_NUMEMB == cNumEmb
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
   		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	    nLin := 9                                              
  	    @nLin, 001 Psay "EMBARQUE NUMERO: "+cNumEmb + "     DATA DE LANÇAMENTO: "+cValToChar(TMPZG->ZG_DATA)
	    nLin++
	    nLin++
   Endif
//Local Cabec1       := "0123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789"
//Local Cabec2       := "     1         2         3         4         5         6         7         8         9         10        11        12        13        14"
//Local Cabec1       :=   "PLANO      SEQUENCIA             DATA   QTDE PLANO       QTDE DISP             QTDE     INVOICE  "
//Local Cabec2       :=   "                             EMBARQUE                     EMBARQUE        EMBARCADO              "

//cQuery := " SELECT ZG_NUMEMB, ZG_PLANO, ZG_SEQUEN, ZG_DATA, ZG_QTDEPLA, ZG_DTEMBAR, ZG_EMBARCA, ZG_QTDEEMB, ZG_QTDISPE, ZG_INVOICE "


    @nLin,003 Psay TMPZG->ZG_PLANO   
    @nLin,018 Psay TMPZG->ZG_SEQUEN
    @nLin,028 Psay TMPZG->ZG_DTEMBAR
    @nLin,041 Psay TMPZG->ZG_QTDEPLA Picture "@E 999,999.99"
    @nLin,057 Psay TMPZG->ZG_QTDISPE Picture "@E 999,999.99"
    @nLin,074 PSay TMPZG->ZG_QTDEEMB Picture "@E 999,999.99"
    @nLin,089 Psay TMPZG->ZG_INVOICE                     
    dbSelectArea("SZP")
    dbSetOrder(2)                              
    dbGotop()
    dbSeek(xFilial("SZP")+Substr(TMPZG->ZG_PLANO,1,12))
    	@nLin,110 Psay Substr(SZP->ZP_PRODUTO,1,6)+'-'+Substr(Posicione("SB1",1,xFilial("SB1")+SZP->ZP_PRODUTO,"B1_DESC"),1,41)
    @nLin, 160 Psay SZP->ZP_CLIENTE + '-'+SZP->ZP_LOJA
    @nLin, 170 Psay Posicione("SA1",1,xFilial("SA1")+SZP->(ZP_CLIENTE+ZP_LOJA),"A1_NOME")

    nLin := nLin + 1 
	
	TMPZG->(dbSkip())                 
   		
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()                          
//RetIndex('TMPZG')

lImpresso := .T.
Return lImpresso 



Static Function AjustaSX1()

Local aArea := GetArea()
PutSx1(cPerg,"01","Numero do Embarque            ?"," "," ","mv_ch1","C",6,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Numero do Embarque"},{"Informe o Numero do Embarque"},{"Informe o Numero do Embarque"})
RestArea(aArea)
Return
