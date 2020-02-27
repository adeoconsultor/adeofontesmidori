#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*======= ======= ======= ======= ======= ======= ======= ======= ======= =======
 Programa  : CARTACORRE()           Autor: Claudinei E.Nascimento Data: 11/01/10
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Objetivo  : Gerenciamento das Cartas de Correcao
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Modulo(s) : FAT - Faturamento
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Tabela(s) : 
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Campos    : 
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Uso       : Modulo SIGAFAT
 Obs.      : 
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Ajustes   : 
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= */
user function CARTACORRE(xAutoCab,xAutoItens,nOpcAuto,lWhenGet,xAutoImp)
	Local nPos      := 0
	Local bBlock    := {|| Nil}
	Local nX	   	:= 0

	//Legenda utilizada para interpretar a situacao das cartas de correcao
	Local aCores    := {	{'(F2_DOC == "004313   ")' ,'BR_VERDE'		},;	// NF sem Carta de Correcao
							{'(F2_DOC == "017587   ")'  ,'BR_AZUL'   	};	// NF NF com Carta de Correcao
                        }	// NF cuja Carta Correcao foi Cancelada

	Local aCoresUsr  := {}
	PRIVATE l103Auto	:= (xAutoCab<>NIL .And. xAutoItens<>NIL)
	PRIVATE aAutoCab	:= {}
	PRIVATE aAutoImp    := {}
	PRIVATE aAutoItens 	:= {}
	PRIVATE aRotina 	:= MenuDef() // Foi modificado para o SIGAGSP.
	PRIVATE cCadastro	:= OemToAnsi("Cadastro de Carta de Correção")
	PRIVATE aBackSD1    := {}
	PRIVATE aBackSDE    := {}
	private aIndexSF2 := {}

	//³ Inicializa os parametros DEFAULTS da rotina                  ³
	DEFAULT lWhenGet := .F.

	cFiltraRh 	:= CHKRH("U_CARTACORRE","SZB","1") 
	bFiltraBrw 	:= {|| FilBrowse("SZB",@aIndexSF2,@cFiltraRH) } 
	Eval(bFiltraBrw)

	//³ Verifica a permissao do programa em relacao aos modulos      ³
	dbSelectArea("SF2")
	mBrowse(6,1,22,75,"SF2",,,,,,aCores)

	dbSelectArea("SZB")
	dbSetOrder(1)
		
	EndFilBrw("SF2",aIndexSF2)

//return(nil)



//Inclusao de dados
user function CCIncluir(cAlias,nReg,nOpcx)
	local aFldHdr := {"ZB_FILIAL","ZB_CODCORR","ZB_NOVADES","ZB_CODMINU","ZB_DTALTCC","ZB_USUINC","ZB_USUALT"}
	local aAdvSize := {}
	local aInfoAdvSize := {}
	local aObjSize := {}
	local aObjCoords := {}
	local cCodNF := SF2->F2_DOC
	local nSavRec := 0.00
	local oFont
	local oGroup
	local bSeekWhile := {|| SZB->ZB_FILIAL+SZB->ZB_NOTAFIS}
	local nSZBOrd := RetOrdem("SZB","ZB_FILIAL+ZB_NOTAFIS")

	nValLanc       := 0.00
	nValCalc       := 0.00

	aColsAnt       := {}
	nSavRec        := RecNo()
	cAlias         := "SZB"
	lInclu         := .T.

	dbSelectArea(cAlias) //Localiza primeiramente X2_PATH do arquivo SX2
	dbSetOrder(1)
	cCodCaCo := ZB_CARTCOR
	//Verifica se existe algum Valor                               ³
	If dbSeek(cFilial+cCodNF)
		Help(" ",1,"Valor já lançado.")
		dbSelectArea("SF2")
		dbGoTo( nSavRec )
		Return( .F. )
	Endif

	FillGetDados(nOpcx					 ,; //1-nOpcx - número correspondente à operação a ser executada, exemplo: 3 - inclusão, 4 alteração e etc;
				 cAlias				 	 ,; //2-cAlias - area a ser utilizada;
				 nSZBOrd				 ,; //3-nOrder - ordem correspondente a chave de indice para preencher o  acols;
				 xFilial(cAlias)+cCodNF	 ,; //4-cSeekKey - chave utilizada no posicionamento da area para preencher o acols;
				 bSeekWhile				 ,; //5-bSeekWhile - bloco contendo a expressão a ser comparada com cSeekKey na condição  do While
				 NIL					 ,; //6-uSeekFor - pode ser utilizados de duas maneiras:1- bloco-de-código, condição a ser utilizado para executar o Loop no While;2º - array bi-dimensional contendo N.. condições, em que o 1º elemento é o bloco condicional, o 2º é bloco a ser executado se verdadeiro e o 3º é bloco a ser executado se falso, exemplo {{bCondicao1, bTrue1, bFalse1}, {bCondicao2, bTrue2, bFalse2}.. bCondicaoN, bTrueN, bFalseN};
				 aFldHdr		   	     ,; //7-aNoFields - array contendo os campos que não estarão no aHeader;
				 NIL                     ,; //8-aYesFields - array contendo somente os campos que estarão no aHeader;
				 NIL                     ,; //9-lOnlyYes - se verdadeiro, exibe apenas os campos de usuário;
				 NIL                     ,; //10-cQuery - query a ser executada para preencher o acols(Obs. Nao pode haver MEMO);
				 NIL                     ,; //11-bMontCols - bloco contendo função especifica para preencher o aCols; Exmplo:{|| MontaAcols(cAlias)}
				 .T.                     ,; //12-lEmpty – Caso True ( default é false ), inicializa o aCols com somente uma linha em branco ( como exemplo na inclusão).
				 NIL     	             ,; //13-aHeaderAux, eh Caso necessite tratar o aheader e acols como variáveis locais ( várias getdados por exemplo; uso da MSNewgetdados )
				 NIL                     ,; //14-aColsAux eh Caso necessite tratar o aheader e acols como variáveis locais ( várias getdados por exemplo; uso da MSNewgetdados 
				 NIL					 ,;
				 NIL			  		 )

	nUsado	:= Len(aHeader)

	//Mostra o corpo dos valores variaveis
	nOpca := 0

	//Monta as Dimensoes dos Objetos
	aAdvSize		:= MsAdvSize()
	aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
	aAdd( aObjCoords , { 015 , 020 , .T. , .F. } )
	aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
	aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )
	
	SetaPilha()
		DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
		DEFINE MSDIALOG oDlg TITLE OemToAnsi( "Cadastro Carta de Correção" ) FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL
			@ aObjSize[1,1] , aObjSize[1,2] GROUP oGroup TO ( aObjSize[1,3] - 3 ),( ( aObjSize[1,4]/100*20 - 2 ) ) LABEL OemToAnsi("Nota Fiscal") OF oDlg PIXEL
			oGroup:oFont:= oFont
			@ aObjSize[1,1] , ( aObjSize[1,4]/100*20 ) GROUP oGroup TO ( aObjSize[1,3] - 3 ),aObjSize[1,4] LABEL OemToAnsi("Carta Correcao") OF oDlg PIXEL
			oGroup:oFont:= oFont

			@ ( ( aObjSize[1,3] ) - ( ( ( aObjSize[1,3] - 3 ) - aObjSize[1,2] ) / 2 ) ) , ( aObjSize[1,2] + 5 )				SAY OemToAnsi(cCodNF) SIZE 040,10 OF oDlg PIXEL FONT oFont
			@ ( ( aObjSize[1,3] ) - ( ( ( aObjSize[1,3] - 3 ) - aObjSize[1,2] ) / 2 ) ) , ( ( aObjSize[1,4]/100*20 ) + 5 )	SAY OemToAnsi(cCodCaCo) SIZE 046,10 OF oDlg PIXEL FONT oFont

			oGet := MsGetDados():New(aObjSize[2,1],aObjSize[2,2],aObjSize[2,3],aObjSize[2,4],nOpcx,,,"",.T.,,1,,4000)

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,If(oGet:TudoOk(),oDlg:End(),nOpca:=0)},{||oDlg:End()})
	SetaPilha()

	If nOpcA == 1
		Begin Transaction
			Gp100Grava(cAlias)
			//Processa Gatilhos
			EvalTrigger()
		End Transaction
	Endif

	//Restaura a integridade da janela
	lInclu := .F.
	dbSelectArea(cAlias)  //SZA
	dbSetOrder(1)
	cAlias := "SF2"
	dbSelectArea(cAlias)
	dbGoTo(nSavRec)


/*======= ======= ======= ======= ======= ======= ======= ======= ======= =======
 Programa  : MenuDef()           Autor: Claudinei E.Nascimento Data: 11/01/10
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Objetivo  : Menu com opcoes exibido ao usuario
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Modulo(s) : FAT - Faturamento
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Tabela(s) : 
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Campos    : 
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Uso       : Modulo SIGAFAT
 Obs.      : 
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Ajustes   : 
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= */
Static Function MenuDef()
	private aRotina	:= {}  
	//Inicializa aRotina para ERP/CRM ou SIGAGSP
	aAdd(aRotina,{OemToAnsi("Pesquisar"), "AxPesqui"   , 0 , 1, 0, .F.})
	aAdd(aRotina,{OemToAnsi("Visualizar"), "CCVisual", 0 , 2, 0, nil})
	aAdd(aRotina,{OemToAnsi("Incluir"), "U_CCIncluir", 0 , 3, 0, nil})
	aAdd(aRotina,{OemToAnsi("Cancelar"), "CCCancelar", 3 , 5, 0, nil})
	aAdd(aRotina,{OemToAnsi("Imprimir"), "CCImprimir"  , 0 , 4, 0, nil})
	aAdd(aRotina,{OemToAnsi("Legenda"), "CCLegenda", 0 , 2, 0, .F.})
return(aRotina)