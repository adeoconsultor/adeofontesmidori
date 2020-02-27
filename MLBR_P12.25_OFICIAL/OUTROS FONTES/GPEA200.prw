#INCLUDE "PROTHEUS.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "FWBROWSE.CH" 
#INCLUDE "FWMVCDEF.CH" 
#include "FONT.CH"
#include "COLORS.CH"
#INCLUDE "GPEA200.CH" 

#define Confirma 1
#define Redigita 2
#define Abandona 3
#define nColObg 7 
//Colunas utilizadas tanto para adicionais/obrigatorios = 
// 1- Legenda / 2- Campo / 3- Descricao / 4- Pos. Inicial / 5- Pos. Final / 6- Formula / 7- Ord. Gravacao do cpo

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao       ³ GPEA200  ³ Autor ³ Raquel Hager	       ³ Data ³ 18/06/13            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao    ³ Cadastro de Layout de Importacao de Variaveis			                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe      ³ GPEA200(ExpC1,ExpN1,ExpN2)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros   ³ cRotina = "V" Visualizacao                                            ³±±
±±³             ³           "I" Inclusao                                                ³±±
±±³             ³           "A" Alteracao                                               ³±±
±±³             ³           "E" Exclusao                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso          ³ GPEA200                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³			      ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³Programador  ³ Data     ³ FNC            ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³±±
±±³Raquel Hager ³18/06/2013³M12RH01    RQ006³Unificacao da Folha de Pagamento.		    ³±±
±±³Raquel Hager ³12/11/2013³M12RH01    RQ006³Alteracoes nas fun. Gp020LinOk/Gp020TudOk. ³±±
±±³Alberto M    ³17/10/2014³TQUTLF          ³Inclusao da tabela SRK para importacao     ³±±
±±³Alberto M    ³20/10/2014³TQUTLF          ³Alteraçao na Funcao gp200TudOk.            ³±±
±±³Alberto M    ³30/10/2014³TQUTLF          ³Alteracoes nos campos obrigatorios de SRK. ³±±
±±³Alberto M    ³06/11/2014³TQUTLF          ³Novas alteracoes nos campos obrigatorios   ³±±
±±³             ³          ³                ³ de SRK.                                   ³±±
±±³Allyson M    ³14/10/2015³TTMBH1          ³Ajuste p/ validar preenchimento da condicao³±±
±±³             ³          ³                ³de gravacao do registro.                   ³±±
±±³Mariana M.   ³18/12/2015³TUBRGI	    	³Ajuste na função Gp2001Atu no array aObgRHO³±±
±±³ 	        ³          ³     	    	³incluindo campo RHO_COMPPG como campo obri-³±±
±±³ 	        ³          ³     	    	³gatorio									³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function UGPEA200() 						                                  
Local	cFTerRFJ	:= ""  
Private oMBrowse
Private aRotina 	:= 	U_MenuDef()
Private lItemClVl   := SuperGetMv( "MV_ITMCLVL", .F., "2" ) $ "1*3" // Define se trabalha com item e classe contabil
	
	// OBSERVACAO IMPORTANTE
	// Na inclusao de novos alias, incluir campo no filtro
	// e variaveis conforme observacao na funcao Gp200Atu.
	cFTerRFJ    	:= "ALLTRIM(RFJ->RFJ_CPO) $ 'RGB_FILIAL*RHO_FILIAL*RK_FILIAL*RC_FILIAL'"    
               	
	oMBrowse:= FWMBrowse():New()  
	oMBrowse:SetDescription("Layout de Importacao")	// "Layout de Importacao"  
	oMBrowse:SetAlias('RFJ')
   	oMBrowse:SetMenuDef( 'UGPEA200' )  
   	oMBrowse:SetFilterDefault(cFTerRFJ)  
   	oMBrowse:SetChgAll(.F.)		 		
	oMBrowse:Activate()		
					
Return   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ Gp200Atu ³ Autor ³ Equipe RH          ³Data  ³  18/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua a manutencao no cadastro de layout de importacao.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GPEA200                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Gp200Atu( 	cAlias,;	// Alias do arquivo
					nReg,;		// Registro atual
					nOpc ;		// Opcao do menu
				  )
// Variaveis do tipo objetos  
Local oDlg			:= Nil			
Local oFont	 
Local oGroup1
Local oGroup2
Local oGroup3
Local oGroup4           
Local oCodRFJ
Local oDescRFJ
Local oTbDest
Local oCondRFJ          
Local oBtnCar
// Variaveis para controle de coordenadas da janela 
Local aAdvSize			:= {}
Local aInfoAdvSize		:= {}
Local aObjSize			:= {}
Local aObjCoords		:= {}
Local aAdv1Size			:= {}
Local aInfo1AdvSize		:= {}
Local aObj1Coords 		:= {}
Local aObj1Size			:= {} 
Local aAdv2Size			:= {}
Local aInfo2AdvSize		:= {}
Local aObj2Size			:= {}	
Local aObj2Coords 		:= {}		
Local aAdv3Size			:= {}
Local aInfo3AdvSize		:= {}
Local aObj3Size			:= {}	
Local aObj3Coords 		:= {}
// Variaveis utilizadas na tela
Local aButtons  		:=  {	{"GP200LEG",{||UGp200Leg()},OemtoAnsi("Legenda")}		}  
Local cCodRFJ		
Local cDescRFJ		      
Local cCondRFJ  
Local cCposAdi
Local cCposObg        
Local aCond 			:= { "Sim", "Nao"}//"1=Sim" //"2=Nao"   
//Variaveis auxliares
Local nX				:= 0			

Private Txt		  		:= Repli("X",200)
Private aCposAdi        := {}
Private aCposAdiSv		:= {}
Private aCposObg	    := {}
Private aCposObgSv		:= {}    
Private aDelCpos		:= {}	
Private aHeader			:= {} 
Private aAlter   		:= {"M200INI","M200FIM","M200CON"}
Private aCols			:= {} 
Private cTbDest   
Private cTbDestSv 
Private oCposAdi
Private oCposObg            
Private oGetObg			:= {}    
// Variaveis sobre legenda
Private oBCpoUser		:= LoadBitmap( GetResources(), "BR_VERDE" )  // Campo determinado pelo usuario 


// OBSERVACAO IMPORTANTE
// Na inclusao de novos alias, incluir campo no filtro
// e variaveis conforme observacoes abaixo:
//Alias utilizados na rotina
Private aTbDest 		:= { "RGB", "RHO", "SRK", "SRC"}        

//Para criacao de array com campos(aCps) configurados atraves
//do pergunte da rotina GPEA210, para novo alias utilizar
//nomenclatura abaixo 'aCps' + 'Alias'
Private aCpsRGB        	:= { "RGB_PROCES", "RGB_ROTEIR", "RGB_SEMANA", "RGB_PERIOD" }
Private aCpsRHO        	:= { "RHO_COMPPG","RHO_TPLAN" }   
Private aCpsSRK         := { "RK_PROCES", "RK_CC", "RK_VALORAR", "RK_VLJUROS",;
                             "RK_PCJUROS", "RK_VALORPA", "RK_DOCUMEN"}               
Private aCpsSRC        	:= { "RC_PROCES", "RC_ROTEIR", "RC_SEMANA", "RC_PERIOD" }                             


//Para criacao com array obrigatorio(aObg) para novo alias
//utilizar nomenclatura abaixo 'aObg' + 'Alias'	 
// Ao incluir/remover um campo, atualizar rotina GPEA210
Private aObgRGB			:= { 	{"RGB_FILIAL",TamSx3("RGB_FILIAL")[1]},{"RGB_MAT",TamSx3("RGB_MAT")[1]},;
								{"RGB_PD",TamSx3("RGB_PD")[1]};							
							}  
							
Private aObgRHO			:= { 	{"RHO_FILIAL",TamSx3("RHO_FILIAL")[1]}, 	{"RHO_MAT",TamSx3("RHO_MAT")[1]},;
						 		{"RHO_DTOCOR",TamSx3("RHO_DTOCOR")[1]}, 	{"RHO_TPFORN",TamSx3("RHO_TPFORN")[1]},;
						 		{"RHO_CODFOR",TamSx3("RHO_CODFOR")[1]},		{"RHO_CODIGO",TamSx3("RHO_CODIGO")[1]},;
						 	 	{"RHO_ORIGEM",TamSx3("RHO_ORIGEM")[1]},	{"RHO_PD",TamSx3("RHO_PD")[1]},;
						 	 	{"RHO_COMPPG",TamSx3("RHO_COMPPG")[1]};		
							}

Private aObgSRK			:= { 	{"RK_FILIAL",TamSx3("RK_FILIAL")[1]},{"RK_MAT",TamSx3("RK_MAT")[1]},;
					            {"RK_PD",TamSx3("RK_PD")[1]},{"RK_VALORTO",TamSx3("RK_VALORTO")[1]},;
								{"RK_PARCELA",TamSx3("RK_PARCELA")[1]},{"RK_DTVENC",TamSx3("RK_DTVENC")[1]},;
								{"RK_NUMPAGO",TamSx3("RK_NUMPAGO")[1]},{"RK_PERINI",TamSx3("RK_PERINI")[1]},;
								{"RK_DTMOVI",TamSx3("RK_DTMOVI")[1]};
							}             
							
Private aObgSRC			:= { 	{"RC_FILIAL",TamSx3("RC_FILIAL")[1]},{"RC_MAT",TamSx3("RC_MAT")[1]},;
								{"RC_PD",TamSx3("RC_PD")[1]};							
							}  							
			
	//Impede a importacao de Item e Classe de Valor.				
	If !lItemClVl
		AADD(aCpsRGB,"RGB_ITEM")
		AADD(aCpsRGB,"RGB_CLVL")
		AADD(aCpsSRK,"RK_ITEM")
		AADD(aCpsSRK,"RK_CLVL")     
		AADD(aCpsSRC,"RC_ITEM")
		AADD(aCpsSRC,"RC_CLVL")
	EndIf 

   	nOpcA	:= 0
   	              
 	AADD(aCposAdi, {oBCpoUser,"",""}) 
	aCposAdiSv 	:= aClone(aCposAdi)  
	     
	// Monta as Dimensoes dos Objetos.
	aAdvSize		:= MsAdvSize()
	aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 3 , 3 }					 
	aAdd( aObjCoords , { 000 , 025 , .T. , .F. } )		// 1-Cabecalho campos RFJ
	aAdd( aObjCoords , { 000 , 020 , .T. , .F. } )		// 2-Colunas de Selecao(titulos)   
	aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )		// 3-Colunas de Campos
	aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords ) 
		
	//Cabecalho
	aAdv1Size		:= aClone(aObjSize[1])
	aInfo1AdvSize	:= { aAdv1Size[2] , aAdv1Size[1] , aAdv1Size[4] , aAdv1Size[3] , 2 , 2 }
	aAdd( aObj1Coords , { 000 , 000 , .T. , .T. } )	// 1-Codigo
	aAdd( aObj1Coords , { 000 , 000 , .T. , .T. } )	// 2-Descricao
	aAdd( aObj1Coords , { 000 , 000 , .T. , .T. } )	// 3-Tabela destino
	aAdd( aObj1Coords , { 000 , 000 , .T. , .T. } )	// 4-Cond.Gravacao
	aObj1Size		:= MsObjSize( aInfo1AdvSize , aObj1Coords,,.T. )     
	
	aAdv2Size    	:= aClone(aObjSize[2])
	aInfo2AdvSize	:= { aAdv2Size[2] , aAdv2Size[1] , aAdv2Size[4] , aAdv2Size[3] , 2 , 2 }
	aAdd( aObj2Coords , { 000 , 000 , .T. , .T. } ) // Campos adicionais
	aAdd( aObj2Coords , { 020 , 000 , .F. , .T. } )
	aAdd( aObj2Coords , { 000 , 000 , .T. , .T. } ) // Campos obrigatorios
	aObj2Size := MsObjSize( aInfo2AdvSize , aObj2Coords,, .T. )  // Divisao em colunas
		
	aAdv3Size    	:= aClone(aObjSize[3]) 
	aInfo3AdvSize   := { aAdv3Size[2] , aAdv3Size[1] , aAdv3Size[4] , aAdv3Size[3] , 2 , 2 }
	aAdd( aObj3Coords , { 000 , 000 , .T. , .T. , .T. } )  // Coluna dos campos adicionais
	aAdd( aObj3Coords , { 020 , 000 , .F. , .T. } )
	aAdd( aObj3Coords , { 000 , 000 , .T. , .T. } )  // Coluna dos campos obrigatorios
	aObj3Size := MsObjSize( aInfo3AdvSize , aObj3Coords,, .T. ) // Divisao em colunas
    
	cCodRFJ		:= If(nOpc == 3, Space(TamSx3("RFJ_CODIGO")[1]), RFJ->RFJ_CODIGO)
	cDescRFJ	:= If(nOpc == 3, Space(TamSx3("RFJ_DESC")[1]), RFJ->RFJ_DESC)
	cTbDest		:= If(nOpc == 3, cTbDest, RFJ->RFJ_TBDEST)
	cCondRFJ	:= If(nOpc == 3, Space(TamSx3("RFJ_COND")[1]), RFJ->RFJ_COND) 
    
    // Monta cols com os campos obrigatorios 
	UGp200MontaCols(nOpc,xFilial("RFJ"),cCodRFJ,cTbDest)

	// Define quadro de dialogo.												
	DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
	DEFINE MSDIALOG oDlg FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] Title OemToAnsi( "Layout Importacao Variaveis Midori" ) PIXEL	
	
	   	@ aObj1Size[1,1] 	, aObj1Size[1,2]	GROUP oGroup1 TO aObj1Size[1,3]+5, aObj1Size[1,4]  LABEL OemToAnsi("Cod.Layt") OF oDlg PIXEL	//"Cod.Layt."
		@ aObj1Size[1,1]+10 , aObj1Size[1,2]+5 MSGET cCodRFJ PICTURE "@!" WHEN nOpc == 3  VALID UfValidCod(cCodRFJ) SIZE 45,10  OF oGroup1 PIXEL FONT oFont
	   	oGroup1:oFont:= oFont	 
	    
	   	@ aObj1Size[2,1] 	, aObj1Size[2,2]	GROUP oGroup2 	TO aObj1Size[2,3]+5, aObj1Size[2,4]  LABEL OemToAnsi("Desc.Layt") OF oDlg PIXEL //"Desc.Layt."
		@ aObj1Size[2,1]+10 , aObj1Size[2,2]+5 MSGET  cDescRFJ   	PICTURE "@!"  WHEN nOpc == 3  SIZE 105,10  PIXEL FONT oFont
	  	oGroup2:oFont:= oFont	
		                       
	   	@ aObj1Size[3,1] 	 , aObj1Size[3,2]		GROUP oGroup3      TO  aObj1Size[3,3]+5, aObj1Size[3,4] LABEL OemToAnsi("Tb.Dest") OF oDlg PIXEL	//"Tb.Dest."
	   	@ aObj1Size[3,1]+10 , aObj1Size[3,2]+5		MSCOMBOBOX cTbDest ITEMS aTbDest WHEN nOpc == 3 SIZE 45,10   PIXEL FONT oFont
	   	@ aObj1Size[3,1]+10	 , aObj1Size[3,2]+65	BUTTON oBtnCar Prompt OemToAnsi("Carregar") WHEN nOpc == 3	SIZE 45,10 PIXEL FONT oFont ACTION UfLoadCpos(cTbDest)	//"Carregar"
		oGroup3:oFont:= oFont	
				
		@ aObj1Size[4,1] 	, aObj1Size[4,2]	GROUP oGroup4 	TO aObj1Size[4,3]+5, aObj1Size[4,4]  LABEL OemToAnsi("Cond.Gravacao Registro") OF oDlg PIXEL	//"Cond.Gravacao Registro"
		@ aObj1Size[4,1]+10 , aObj1Size[4,2]+5	MSGET cCondRFJ	PICTURE "@!" WHEN If(nOpc == 2 .Or. nOpc == 5,.F.,.T.)  SIZE 90,10  PIXEL FONT oFont
		oGroup4:oFont:= oFont       
				
		// Exibe quadros de colunas de selecao
		@ aObj2Size[1,1],aObj2Size[1,2] Group oGroup To aObj2Size[1,3],aObj2Size[1,4]  Of oDlg Pixel
		@ aObj2Size[1,1]+5,aObj2Size[1,2]+5 Say OemToAnsi("Campos adicionais:") Size 75,10 Pixel Font oFont  //"Campos adicionais:"
	   
		@ aObj2Size[3,1],aObj2Size[3,2] Group oGroup To aObj2Size[3,3],aObj2Size[3,4]	 Of oDlg Pixel		
		@ aObj2Size[3,1]+5,aObj2Size[3,2]+5 Say OemToAnsi("Campos obrigatorios:") Size 75,10 Pixel Font oFont //"Campos obrigatorios:" 
	
	   	@ aObj3Size[1,1],aObj3Size[1,2] ListBox oCposAdi Var cCposAdi;
					Fields	Header	 "",; 					//Legenda 
									 OemToAnsi("Campo"),; 	//"Campo" 
								     OemToAnsi("Descricao"); 	//"Descricao"
							ColSizes GetTextWidth(0, Replicate("B", 1) ),;
									 GetTextWidth(0, Replicate("B", 6) ),;
									 GetTextWidth(0, Replicate("B", 25) );
					Size aObj3Size[1,3],aObj3Size[1,4] Of oDlg Pixel 
	   	oCposAdi:LHSCROLL := .F.   
	   	oCposAdi:SetArray(aCposAdi)		
		oCposAdi:bLine := { ||  {  oBCpoUser,;
									aCposAdi[oCposAdi:nAt,2],;
								   	aCposAdi[oCposAdi:nAt,3];
								 }; 
							}    
	   oGetObg 		:= MSGetDados():New(aObj3Size[3,1],aObj3Size[3,2] ,aObj3Size[3,3],aObj3Size[3,4],nOpc,"Ugp200LinOk()","Ugp200TudOk()","",.F.,aAlter,1,,Len(aCols))
	   aCposObgSv	:= aClone(aCols) 			
									     		                       
		// Exibe buttons de manipulacao apenas para inclusao/alteracao											 
		If nOpc != 2 .And. nOpc != 5
			@ aObj3Size[2,3]+5 ,(aObj3Size[2,2]*2)+10 	BtnBmp oNext    Resource 'NEXT'    Size 25,25 Design Action UgpMvtCpos( 1, .T., oCposAdi:nAt, cTbDest, nOpc ) 			Of oDlg 
			@ aObj3Size[2,3]+35 ,(aObj3Size[2,2]*2)+10 BtnBmp oPgNext Resource 'PGNEXT'  Size 25,25 Design Action UgpMvtCpos( 1, .F., oCposAdi:nAt, cTbDest, nOpc )  			Of oDlg
			@ aObj3Size[2,3]+65 ,(aObj3Size[2,2]*2)+10 BtnBmp oPrev   Resource 'PREV'    Size 25,25 Design Action UgpMvtCpos( 2, .T., oGetObg:oBrowse:nAt, cTbDest , nOpc ) 	Of oDlg
			@ aObj3Size[2,3]+95,(aObj3Size[2,2]*2)+10 BtnBmp oPgPrev  Resource 'PGPREV'  Size 25,25 Design Action UgpMvtCpos( 2, .F., oGetObg:oBrowse:nAt, cTbDest, nOpc ) 	Of oDlg
		EndIf 
				
		bSet15		:= {|| If ( gp200TudOk() .And. UfTudOk(nOpc, cCodRFJ, cCondRFJ), (nOpcA := If(nOpc==5,2,1),oDlg:End() ),) }					
		bSet24		:= { ||oDlg:End() }
   
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, bSet15 , bSet24 , Nil , aButtons ) CENTERED
	
 	If nOpc # 5  // Se for exclusao
        If nOpcA == 1 .And. nOpc # 2
            Begin Transaction
                // Gravacao
                UGp200Grava("RFJ",cCodRFJ,cDescRFJ,cTbDest,cCondRFJ)
            End Transaction
        EndIf
    // Se for Exclusao
    ElseIf nOpca = 2 
        Begin Transaction
            Ugp200Dele(xFilial("RFJ"),cCodRFJ,cTbDest)
        End Transaction
    EndIf 
    
    oMBrowse:Refresh(.T.)						

Return  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ fLoadCpos ³ Autor ³ Equipe RH         ³ Data ³  18/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta array com cpos adicionais da tb. destino escolhida.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GPEA200                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UfLoadCpos(cTab)
Local aArea		:= GetArea() 
Local aObgAux   := {}
Local cPosIni	:= ""
Local cPosFim	:= ""	
Local cFormSpc	:= Space(TamSx3("RFJ_FORM")[1])
Local nX		:= 0 
Local nPosIni	:= 0
Local nPosFim	:= 0     
	
    
    If !fCompArray(aCols, aCposObgSv)  
    	If !MsgYesNo( OemToAnsi( "Aviso" ),OemToAnsi( "Houve alteracoes na definicao do layout. Deseja mesmo alterar a tab. destino?" ) ) //"Aviso"###"Houve alteracoes na definicao do layout. Deseja mesmo alterar a tab. destino?" 	   	   	   						             
			cTbDest := cTbDestSv
			Return							
		EndIf  
    EndIf 
    
    cTbDestSv	:= cTbDest
        
	// Zero arrays
	aCposAdi 	:= {}
	aCposObg	:= {}  
	
	// 1- Legenda     	// 5- Pos. Final
	// 2- Campo			// 6- Formula
	// 3- Descricao		// 7- Ordem de gravacao
	// 4- Pos. Inicial

	dbSelectArea("SX3")
	dbSetOrder(1) // X3_ARQUIVO+X3_ORIGEM   
	If SX3->(dbSeek(cTab))
		While SX3->(!Eof()) .And. X3_ARQUIVO == cTab
			// Campos virtuais nao entram 
			If SX3->X3_CONTEXT != "V"			
				If aScan(&("aCps"+cTab), {|x| x == AllTrim(SX3->X3_CAMPO)}) == 0 .And. ;
					aScan(&("aObg"+cTab), {|x| x[1] == AllTrim(SX3->X3_CAMPO)}) == 0 .And.;
					X3Uso(X3_USADO)	 // Campos nao usados nao entram		
					AADD(aCposAdi, {oBCpoUser, SX3->X3_CAMPO, SX3->X3_TITULO,0,0,cFormSpc,0} )
				EndIf  
				If aScan(&("aObg"+cTab), {|x| x[1] == AllTrim(SX3->X3_CAMPO)}) > 0 				
					AADD(aCposObg, {"", SX3->X3_CAMPO,SX3->X3_TITULO,0,0,cFormSpc,0} ) 
				EndIf 	 
			EndIf   
			SX3->(dbSkip())
		End  
	EndIf  
	
	
	// Ordenar array para ficar na mesma ordem que o array aCposObg   
	aObgAux	:= Array(Len(aCposObg),nColObg) 
	For nX := 1 to Len(aCposObg)   		
		nPos := aScan(aCposObg, {|x| AllTrim(x[2]) == &("aObg"+cTab)[nX][1]}) 
		If nPos > 0 		
			aObgAux[nX][1] 	:= aCposObg[nPos][1]	// Legenda 
			aObgAux[nX][2] 	:= aCposObg[nPos][2]	// Campo    
			aObgAux[nX][3] 	:= aCposObg[nPos][3]	// Descricao   
			aObgAux[nX][4] 	:= nPosIni+1			// Pos. Inicial	 
			nPosFim			:= nPosIni + &("aObg"+cTab)[nX][2] 
			aObgAux[nX][5] 	:= nPosFim 				// Pos. Final			
			aObgAux[nX][6] 	:= aCposObg[nPos][6]	// Formula
			aObgAux[nX][7] 	:= aCposObg[nPos][7]	// Ordem de Gravacao
			nPosIni 			:= nPosFim		
		EndIf	
	Next nX
	aCposObg := aClone(aObgAux)
	   
	// Atualiza objetos ListBox 
	ASort(aCposAdi,,,{|x,y| x[3] < y[3]}) 	// Ordena pelo nome do campo
	oCposAdi:SetArray( aCposAdi ) 
   	oCposAdi:bLine := { ||  {  oBCpoUser,;
								aCposAdi[oCposAdi:nAt,2],;
							   	aCposAdi[oCposAdi:nAt,3];
							 }; 
						}    
   	aCols:= aClone( aCposObg )  
   	For nX := 1 to Len(aCols) 
   		aCols[nX][1] := "BR_VERMELHO"
   	Next nX
   	oGetObg:Refresh()  
						
	// Faz copia
	aCposAdiSv 	:= aClone(aCposAdi)
	aCposObgSv	:= aClone(aCols)      
	
	   	
RestArea(aArea)
		                                       
Return()   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ GP200MontaCols ³ Autor ³ Equipe RH        ³ Data ³  18/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta aCols com campos obrigatorios.					          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GPEA200 									                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
Static Function UGp200MontaCols(nOpc,cFiLRFJ,cCodigo,cTabela)      
// Variaveis auxiliares	   
Local aArea		:= GetArea() 
Local aObgAux	:= {}    
Local cFormSpc	:= Space(TamSx3("RFJ_FORM")[1])
Local lRetOK 	:= .T.        
Local nX		:= 0

	AADD(aHeader,{"" 	 	, "M200LEG"  , "@BMP"		, 2  , 0 ,  ""			, "" , "C" , ""  }) //Legenda
	AADD(aHeader,{"Campo"	, "M200CAM"  , "@!"		, 1  , 0 ,  "! EMPTY()"	, "û", "C" , " " }) //"Campo"
	AADD(aHeader,{"Descricao"	, "M200DES"  , ""	  		, 12 , 0 ,  " "	     	, "û" ,"C" , " " }) //"Descricao"
	AADD(aHeader,{"P.Inicio"	, "M200INI"  , "@E 999"	, 03 , 0 ,  " "     		, "û", "N" , " " }) //"P.Inicio"
	AADD(aHeader,{"P.Final"	, "M200FIM"  , "@E 999"	, 03 , 0 ,  " "       	, "û", "N" , " " }) //"P.Final"
	AADD(aHeader,{"Formula"	, "M200CON"  , "@!"   	, 58 , 0 ,  "UA200FORM()"	, "û", "C" , " " }) //"Formula"
	
	If nOpc != 3 // Alteracao, Visualizacao, Exclusao
		// Zero arrays
		aCposAdi := {}
		aCposObg	:= {}  
		 	
		// Carrega todos os campos gravados como obrigatorios
		dbSelectArea("RFJ")    
		If RFJ->(dbSeek(cFiLRFJ + cCodigo + cTabela))
			While RFJ->(!Eof()) .And. RFJ->RFJ_FILIAL == cFilRFJ .And. RFJ->RFJ_CODIGO == cCodigo 
			    // Carrega array auxiliar    
				AADD(aCposObg, {oBCpoUser, RFJ->RFJ_CPO,UfTitulo(AllTrim(RFJ->RFJ_CPO)),RFJ->RFJ_POSINI,RFJ->RFJ_POSFIN,RFJ->RFJ_FORM, RFJ_ORDEM } )						
				RFJ->(dbSkip())
			End 
		EndIf 
		
		// Ordena array de acordo com a ordem de gravacao
		ASort(aCposObg,,,{|x,y| x[7] < y[7]})  
				
		// Carrega campos adicionais que nao foram gravados
		dbSelectArea("SX3")
   		dbSetOrder(1) // X3_ARQUIVO+X3_ORIGEM   
		If SX3->(dbSeek(cTabela))
			While SX3->(!Eof()) .And. X3_ARQUIVO == cTabela   
				If X3Uso(X3_USADO) .And. SX3->X3_CONTEXT != "V" // Campos nao usados e virtuais nao entram			
					If aScan(&("aCps"+cTabela), {|x| AllTrim(x) == AllTrim(SX3->X3_CAMPO)}) == 0 .And. aScan(aCposObg, {|x| AllTrim(x[2]) == AllTrim(SX3->X3_CAMPO)}) == 0 			
						AADD(aCposAdi, {oBCpoUser, SX3->X3_CAMPO, SX3->X3_TITULO,0,0,cFormSpc,0} )
					EndIf   
				EndIf   
				SX3->(dbSkip())
			End  
		EndIf  
		
			
		// Caso seja um layout com todos os campos do alias
		If Len(aCposAdi) == 0		
			AADD( aCposAdi, {oBCpoUser,"","",0,0,cFormSpc,0 } ) 
	    Else
	    	// Ordena pelo nome do campo
	    	ASort(aCposAdi,,,{|x,y| x[3] < y[3]}) 
		EndIf                                          
		
		// Atualizo aCols com os campos de preenchimento 
		// obrigatorio de acordo com o array aObg+Alias
	   	aCols:= aClone( aCposObg )  
	   	For nX := 1 to Len(aCols)   	   	  
			If aScan(&("aObg"+cTabela), {|x| x[1] == AllTrim(aCols[nX][2])}) > 0 				
				aCols[nX][1] := "BR_VERMELHO" // Legenda para campos de preenchimento obrigatorio
			EndIf   		
	   	Next nX
  							
		// Faz copia
		aCposAdiSv 	:= aClone(aCposAdi)
		aCposObgSv	:= aClone(aCols)
		
	Else // Inclusao
		AADD(aCols,{"BR_VERMELHO", "","",0,0,"",0})
	EndIf
	
RestArea(aArea)
	     
Return( lRetOK )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fTitulo    ³ Autor ³ Equipe RH           ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Carrega titulo do campo de acordo com o SX3.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA200/GPEA210                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UfTitulo(cCampo)
Local aArea		:= GetArea()     
Local cTitulo	:= ""

	// Carrega campos adicionais que nao foram gravados
	dbSelectArea("SX3")
 	dbSetOrder(2) // X3_CAMPO 
	If SX3->(dbSeek(cCampo))
		cTitulo := SX3->X3_TITULO
	EndIf  

RestArea(aArea)

Return( cTitulo )  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ gp200LinOk ³ Autor ³ Equipe RH           ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Critica linha digitada.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Ugp200LinOk()
Local lRet 		:= .T.      
Local nPosCpo	:= GdFieldPos("M200CAM",aHeader) 
Local nLinha	:= oGetObg:oBrowse:nAt  
Local nLinAnt	:= nLinha - 1
	
	If nLinAnt > 0  
	   	If aCols[nLinha,4] # 0 .And. aCols[nLinha,5] # 0 .And. Empty(aCols[nLinha,6]) // Quando nao capturar conteudo por formula
			If aCols[nLinha,4] < aCols[nLinAnt,5]
				MsgInfo( OemToAnsi( "Pos.Ini. devera ser superior a Pos.Fin. da linha anterior" ) , "" ) // "Pos.Ini. devera ser superior a Pos.Fin. da linha anterior" 
				lRet := .F.
			EndIf 
		EndIf
	EndIf
	
	If aCols[nLinha,4] > aCols[nLinha,5]
		Help(" ",1,"A200POSIC") // "Posicao final deve ser maior que posicao inicial."
		lRet := .F.
	EndIf 
	
	If aCols[nLinha,4] > aCols[nLinha,5]
		Help(" ",1,"A200POSIC") // "Posicao final deve ser maior que posicao inicial."
		lRet := .F.
	EndIf   
	
	If nPosCpo > 0
		If (aCols[nLinha,5] - aCols[nLinha,4])+1 > TamSX3(AllTrim(aCols[nLinha][nPosCpo]))[1] 
			MsgInfo( OemToAnsi( "Tamanho excedido - Verifique tamanho do campo!."  ) , "" ) // "Tamanho excedido - Verifique tamanho do campo!." 
			lRet	:= .F.			
		EndIf 
	EndIf 
	
	If aCols[nLinha,4] # 0 .And. aCols[nLinha,5] # 0 .And. !Empty(aCols[nLinha,6]) 
		MsgInfo( OemToAnsi( "A coluna ref. a Formula nao devera ser preenchida quando as colunas ref. as posicoes com conteudo preenchido."  ) , "" ) // "A coluna ref. a Formula nao devera ser preenchida quando as colunas ref. as posicoes com conteudo preenchido." 
		lRet	:= .F.	
	EndIf

Return( lRet )     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ gp200TudOk ³ Autor ³ Equipe RH           ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Critica todas as linhas digitadas.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Ugp200TudOk(o)
Local cResp 	:= ""
Local cMsg  	:= "#Nao foi possivel a inclusao desta variavel, pois existem dados invalidos!" + Chr(13) + "#Conferir os dados digitados nas colunas: 'P.Inicio' e 'P.Final' ou 'Formula' no campo:" 
	//STR0032 #Nao foi possivel a inclusao desta variavel, pois existem dados invalidos!
	//STR0033 #Conferir os dados digitados nas colunas: 'P.Inicio' e 'P.Final' ou 'Formula' no campo:
Local lRet  	:= .T.
Local nI    	:= 0 
	
	For nI := 1 To Len (aCols)           
	    
		If nI > 1
			If aCols[nI,4] # 0 .And. aCols[nI,5] # 0 .And. Empty(aCols[nI,6])  // Quando nao capturar conteudo por formula
				If aCols[nI,4] < aCols[nI-1,5]  // P. Final > Pos. Inicial. entre linhas
					lRet := .F.
				EndIf  
			EndIf
		EndIf
		    
	 	If aCols[nI,4] > aCols[nI,5]  // P. Final > Pos. Inicial. na mesma linha
			lRet := .F.
		EndIf   
		
		If (aCols[nI][2]) # "" //Não utiliza a TamSX3 caso ainda nao tenha carregado nenhuma tabela no momento da inclusao.
			If (aCols[nI,5] - aCols[nI,4])+1 > TamSX3(AllTrim(aCols[nI][2]))[1] // Tamanho excedido 
				lRet	:= .F.			
			EndIf 
	 	EndIf
	 	
		If aCols[nI,4] # 0 .And. aCols[nI,5] # 0 .And. !Empty(aCols[nI,6]) // Todas as colunas preenchidas 
			lRet	:= .F.	
		EndIf  
		
		If aCols[nI,4] == 0 .And. aCols[nI,5] == 0 .And. Empty(aCols[nI,6])  // Nenhuma coluna preenchida (validacao apenas no TudOk)
			lRet	:= .F.	
		EndIf
	
		If !lRet 
			cResp := aCols[nI][3] 		
			Exit
		EndIf 							
	Next nI              
	
	If !lRet
		MsgAlert(cMsg + Chr(13) + Chr(13) + cResp)
	EndIf

Return( lRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fTudOk   ³ Autor ³ Equipe RH             ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³  Valida campos da enchoice.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UfTudOk(nOpc, cCodigo, cCond)
Local aArea	:= GetArea()  
Local lRet	:= .T.

Begin Sequence    
    If nOpc == 3 .Or. nOpc == 4 // Apenas para inclusao e alteracao
		// Codigo devera estar preenchido
		If Empty(cCodigo) 
			Help( ,, OemToAnsi("Atenção"),, OemToAnsi("Falha na carga de verbas"), 1, 0 ) //"Atenção" ## "Falha na carga de verbas"
			lRet := .F.
			Break
		EndIf 

		// Condicao devera estar preenchido
		If Empty(cCond) 
			Help( ,, OemToAnsi("Atenção"),, OemToAnsi("Informe a condição de gravação do registro"), 1, 0 ) //"Atenção" ## "Informe a condição de gravação do registro."
			lRet := .F.
			Break
		EndIf 
		
		// Objetos tem que estar preenchidos e com conteudo			
		If ( Len( acPosAdi ) == 1 .And. Empty( aCposAdi[1,2] ) ) .And. ( Len( aCposObg ) == 0 )
			Help( ,, OemToAnsi("Atenção"),, OemToAnsi("Carregue os campos da tabela destino!"), 1, 0 ) //"Atenção" ## "Carregue os campos da tabela destino!"
			lRet := .F.
			Break
		EndIf    
	EndIf
End Sequence

RestArea(aArea)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ gpMvtCpos  ³ Autor ³ Equipe RH        ³ Data ³  18/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Efetua movimentacao de campos entre os listboxes.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GPEA200                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UgpMvtCpos( 	nOrigem,;	// Indenticacao da movimentacao origem
							lUma,;		// Movimenta somente um campo?
							nPosicao,;	// Posicao atual do campo
							cTab	,;	// Tabela destino
							nOpc		)   
Local aOrigem 	:= If( nOrigem == 1, aCposAdi, aCols ) // Array origem da movimentacao
Local aDestino	:= If( nOrigem == 1, aCols, aCposAdi) 	// Array destino da movimentacao 
Local aCposAux	:= {}
Local cCampo	
Local nTamOri	:= Len( aOrigem )						// Tamanho da array de origem
Local nI												// Variavel para loop
	
	
	// Retorna caso esteja tentando mover de um objeto vazio				
	If ( Len( aOrigem ) == 1 .And. Empty( aOrigem[1,2] ) ) .Or. ( Len( aOrigem ) == 0 )
		Return .T.
	EndIf
	
	// Caso o objeto destino esteja vazio, exclui o elemento vazio
	If Len( aDestino ) == 1 .And. Empty( aDestino[1,1] )
		ADel( aDestino, 1 )
		ASize( aDestino, Len( aDestino ) - 1 )
	EndIf
	             
	// Caso objeto seja o dos campos obrigatorios e esteja
	// tentando mover campo obrigatorio, proibe
	cCampo	:= aOrigem[nPosicao,2]	// Campo a ser movida    
	If nOrigem == 2
		If aScan(&("aObg"+cTab), {|x| x[1] == AllTrim(cCampo)}) > 0 .And. aOrigem[nPosicao,1] == "BR_VERMELHO"		
			MsgAlert( OemToAnsi( "Aviso" ) , "Nao e possivel mover campos obrigatorios determinados pelo sistema!" )  // "Aviso"###"#"Nao e possivel mover campos obrigatorios determinados pelo sistema!"
			Return .T.
		EndIf  
	EndIf  
	  

	// Inclui na ListBox destino e exclui da origem	
	If lUma        
		aDestino	:= If(Empty(aDestino[1][2]), Eval({||ADel( aDestino, 1 ),ASize( aDestino, Len( aDestino ) - 1 )}), aDestino)
		
		/// Remocao de campos adicionais da estrutura original
		If nOpc  == 4 // Alterecao  
			If nOrigem == 2   
				// Guarda campo para exclusao
				AADD(aDelCpos , aOrigem[nPosicao][2] )
			EndIf
		EndIf 
		
		AADD( aDestino, aOrigem[nPosicao] )
		ADel( aOrigem, nPosicao )
		ASize( aOrigem, nTamOri - 1 )
	Else       
		If nOrigem == 1
			nQtde		:= 1
		Else         
			nQtde 	:= Len(&("aObg"+cTab))+1 
			If (nQtde > Len(aCols))
				Return .F.
			EndIf
		EndIf  
		aDestino	:= If(Empty(aDestino[1][2]), Eval({||ADel( aDestino, 1 ),ASize( aDestino, Len( aDestino ) - 1 )}), aDestino)	  
		For nI = nQtde To nTamOri
			AADD( aDestino, aOrigem[nI] )
		Next   
		If nOrigem == 1                                    
			aOrigem := {} 
		Else      
			For nI := nQtde To nTamOri  
				// Remocao de campos adicionais da estrutura original
			  	If nOpc  == 4 // Alterecao  
					If nOrigem == 2   
						// Guarda campo para exclusao
						AADD(aDelCpos ,aOrigem[nQtde][2] )
					EndIf
				EndIf 
				ADel( aOrigem, nQtde )
				ASize( aOrigem, Len(aOrigem) - 1 )
			Next 
		EndIf
	EndIf
	
	// Caso a ListBox origem tenha ficado vazia, inclui um elemento.			
	If Len( aOrigem ) == 0  
		AADD( aOrigem, {oBCpoUser,"","",0,0,"","1",.F. } ) 
	EndIf   
	
	If nOrigem <> 2  // Nao altera a ordem imposta nos campos obrigatorios
		ASort( aOrigem , , , { |x,y| x[3] < y[3] } )  
	EndIf
	
	// Posiciona o ListBox destino na verba movida a partir da orig.	
	If lUma
		If Len(aDestino) > 0
			If( nOrigem == 1, oGetObg:oBrowse:nAt := 1, oCposAdi:nAt := 1 )
		EndIf
	EndIf
	
	// Retorna o conteudo original da ListBox
	aCposAdi	:= If( nOrigem == 1, aOrigem, aDestino )  
	// Retoarna o conteudo original da GetDados
	aCposAux	:= If( nOrigem == 1, aDestino, aOrigem )
	
	// Atualiza ListBox						
	oCposAdi:AArray		:= aCposAdi
	// Atualiza GetDados
	aCols	:= aCposAux 
		

Return ( .T. ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Gp200Leg    ³ Autor ³ Equipe RH          ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Legenda de selecao de campo.			                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UGp200Leg() 
Local aArea := GetArea()
           //"Importacao de Variaveis" //"Definicao dos campos:"
BrwLegenda("Importacao de Variaveis" ,"Definicao dos campos:", {	{"BR_VERDE"		, OemToAnsi("Campos obrigatorios definidos pela rotina.")},; //"Campos obrigatorios definidos pela rotina."
								{"BR_VERMELHO"	, OemToAnsi("Campos adicionais definidos pela rotina.")}}) //"Campos adicionais definidos pela rotina."
									
RestArea(aArea)
									
Return()


/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Gp200Grava ³ Autor ³ Equipe RH           ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Grava layout de importacao de variaveis.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UGp200Grava(cAlias,cCodigo,cDesc,cTab,cCond) 
Local aArea		:= GetArea()
Local nX 		:= 0
  	
	Begin Transaction
		dbSelectArea("RFJ") 
		RFJ->( dbSetOrder( 1 ) )  // RFJ_FILIAL + RFJ_CODIGO + RFJ_TBDEST + RFJ_CPO
		
		For nX := 1 to Len(aCols)
		
			If !(dbSeek( xFilial("RFJ")+cCodigo+cTab+aCols[nX][2] )) 
				RecLock(cAlias,.T.,.T.)  // Inclui 	
			Else
				RecLock(cAlias,.F.,.T.)  // Altera
			EndIf
					
			RFJ->RFJ_FILIAL :=	xFilial("RFJ")
			RFJ->RFJ_CODIGO :=	cCodigo
			RFJ->RFJ_DESC 	:=	cDesc
			RFJ->RFJ_TBDEST :=	cTab
			RFJ->RFJ_COND 	:=	cCond
			
			RFJ->RFJ_CPO    := aCols[nX][2]  // Campo
			RFJ->RFJ_POSINI := aCols[nX][4]  // Formula
			RFJ->RFJ_POSFIN := aCols[nX][5]  // Pos. Inicial
			RFJ->RFJ_FORM   := aCols[nX][6]  // Pos. Final  
			RFJ->RFJ_ORDEM	:= nX
			
			MsUnlock()
			           
		Next nX    
		
		// Deleta itens
		For nX := 1 to Len(aDelCpos)  
			If dbSeek( xFilial("RFJ")+cCodigo+cTab+aDelCpos[nX] )   
				RecLock("RFJ",.F.,.T.)
				dbDelete()
				MsUnlock() 	
			EndIf
		Next nX
		
	End Transaction 
	
	RestArea(aArea)
	
Return

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ gp200Dele ³ Autor ³ Equipe RH            ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Deleta os registros de Import.Variaveis.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Ugp200Dele(cFiLRFJ,cCodigo,cTabela)
Local aArea	:= GetArea()   

	Begin Transaction
		dbSelectArea("RFJ") 
		RFJ->( dbSetOrder( 1 ) )  // RFJ_FILIAL + RFJ_CODIGO + RFJ_TBDEST + RFJ_CPO 
		If RFJ->(dbSeek(cFiLRFJ + cCodigo + cTabela))
			While RFJ->(!Eof()) .And. RFJ->RFJ_FILIAL == cFilRFJ .And. RFJ->RFJ_CODIGO == cCodigo .And. RFJ->RFJ_TBDEST == cTabela
				RecLock("RFJ",.F.,.T.)
				dbDelete()
				MsUnlock() 			    			
				RFJ->(dbSkip())
			End 
		EndIf 
				
		WriteSx2(cTabela) 
		   
	End Transaction   

RestArea(aArea)

Return( Nil )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ A200FORM ³ Autor ³ Equipe RH             ³ Data ³ 18/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina para tratamento da formula.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function UA200FORM( )
Local bErro      := ErrorBlock( { |e| UA200ERROR( e ) } )
Local lResult    := .T.
	
	cFormula := &(ReadVar()) 
	
	If Len(cFormula) > 0
	    lResult := UA200EXEC( cFormula )
	EndIf      
	
	ErrorBlock( bErro ) 

Return( lResult )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ A200EXEC ³ Autor ³ Equipe RH             ³ Data ³ 18/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Executa a formula e retorna o resultado.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function UA200EXEC( cFormula )
Local xRet 

	Begin Sequence
		    xRet := &(cFormula)
		    xRet := .T.
		RECOVER
		    xRet := .F.
	End Sequence  
	
	If xRet == Nil
		xRet := .F.
	EndIf 
	
Return( xRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ A200ERROR ³ Autor ³ Equipe RH            ³ Data ³ 18/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina para tratamento de erros da formula.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function UA200ERROR( oError )

	If oError:GenCode > 0
		Help(" ",1,"A200ERROFO") // "A formula esta com erro."
		BREAK
	EndIf  

Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fValidCod ³ Autor ³ Equipe RH            ³ Data ³ 18/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida se codigo ja foi cadastrado.		                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function UfValidCod(cCodigo)
Local aArea		:= GetArea()
Local lRet 		:= .T.

		dbSelectArea("RFJ") 
		RFJ->( dbSetOrder( 1 ) )  // RFJ_FILIAL + RFJ_CODIGO + RFJ_TBDEST + RFJ_CPO  
		If RFJ->(dbSeek(xFilial("RFJ") + cCodigo))
			While RFJ->(!Eof()) .And. RFJ->RFJ_FILIAL == xFilial("RFJ") .And. RFJ->RFJ_CODIGO == cCodigo 
				lRet := .F.
				Exit		    			
				RFJ->(dbSkip())
			End 
		EndIf 
	
	If !lRet	
   		MsgAlert( OemToAnsi( "Aviso" ) , OemToAnsi( "Codigo ja cadastrado" ) )  // "Aviso"###"#"Codigo ja cadastrado"   
 	EndIf

RestArea(aArea)

Return( lRet )   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ MenuDef  ³Autor  ³ Equipe RH          ³Data  ³  18/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Isola opcoes de menu para que as opcoes da rotina possam   º±±
±±º          ³ ser lidas pelas bibliotecas Framework da Versao 9.12.      º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ aRotina                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GPEA200                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
User Function MenuDef()	 
							
	Local aRotina :=  { 	{ "PesqBrw", 'PesqBrw' , 0, 1 , ,.F. },;	// Pesquisar 
						    { "Visualizar", 'U_Gp200Atu', 0, 2 },;			// Visualizar
							{ "Incluir", 'U_Gp200Atu', 0, 3 },;			// Incluir   
							{ "Alterar", 'U_Gp200Atu', 0, 4 },;			// Alterar						
							{ "Excluir", 'U_Gp200Atu', 0, 5 };	 		// Excluir
						 } 	

Return aRotina