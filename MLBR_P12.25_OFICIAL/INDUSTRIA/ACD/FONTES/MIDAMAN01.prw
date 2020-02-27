#INCLUDE "TOPCONN.ch" 
#INCLUDE "TOTVS.Ch"

// Define dos modos das rotinas
#DEFINE VISUALIZAR	2
#DEFINE INCLUIR		3
#DEFINE ALTERAR		4
#DEFINE EXCLUIR		5
#DEFINE OK			1
#DEFINE CANCELA		2
#DEFINE ENTER		Chr(13)+Chr(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MIDAMAN01 � Autor � Antonio - ADVPL TEC  � Data � 17.09.15 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina para Manuten��o do Kit                              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MIDAMAN01()                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Midori                                                     ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � MOTIVO DA ALTERACAO                           ���
�������������������������������������������������������������������������Ĵ��
���              �        �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

Criadas as tabelas SZT E SZU, caso ja tenha no cliente, criaremos outras posteriores.

SZT
ZT_CODKIT - Produto Kit Fardo C 15
ZT_DSCKIT - Dscri��o Prd Kit Fardo C 45

SZU

ZU_CODKIT   - Produto Kit Fardo C 15    R/V  (n�o aparece nos itens)
ZU_ITEM     - Item              C 04    R/A
ZU_PRODUTO  - Cod Produto       C 15    R/A
ZU_DSCPRD   - Descri��o Produto C 45    R/V
ZU_UMPRD    - Unidade de Medida C 02    R/V
ZU_QTDE     - Qtde              N 05 02 R/A
ZU_PRATEIO  - % Rateio          N 05 02 

Incluir valida��o U_DURAPRD() no campo (ZU_PRODUTO)


/*/
User Function MIAMAN01()

Private cCadastro	:= "Manuten��o em KIT FARDO"
Private cAlias		:= "SZT"
Private aRotina		:= MenuDef()

dbSelectArea(cAlias)
SZT->(dbSetOrder(1)) // ZT_FILIAL+ZT_CODMAN
SZT->(dbGotop())
mBrowse(,,,,cAlias )  

Return()          


/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef  � Autor � Antonio Carlos Damaceno � Data �17/09/15 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �		1 - Pesquisa e Posiciona em um Banco de Dados     ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

Static Function MenuDef()
Local aRotina := {}

aAdd( aRotina ,{"Pesquisar"  , "AxPesqui"	,0,1 }) //"Pesquisar"
aAdd( aRotina ,{"Visualizar" , "U_UInclui"	,0,2 }) //"Visualizar"
aAdd( aRotina ,{"Incluir"    , "U_UInclui"	,0,3 }) //"Incluir"
aAdd( aRotina ,{"Alterar"    , "U_UInclui"	,0,4 }) //"Alterar"
aAdd( aRotina ,{"Excluir"    , "U_UInclui"	,0,5 }) //"Excluir"

Return(aRotina)





/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �UInclui �Autor  �Antonio               � Data �  17/09/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o de manutn��o Dados do KIT FARDO                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Fat                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function UInclui(cAlias,nRecNo,nOpc)

Local aHeader 		:= {}
Local aCols   		:= {}
Local cCPOs			:= ""		      // Campos que aparecer�o na getdados
Local cChav			:= ""
Private oEnch		:= Nil
Private oDlg		:= Nil
Private oGet		:= Nil

//�����������������������������������Ŀ
//� Variaveis internas para a MsMGet()�
//�������������������������������������
Private aTELA[0][0]
Private aGETS[0]

//��������������������������������������Ŀ
//�Variaveis para a MsAdvSize e MsObjSize�
//����������������������������������������
Private lEnchBar	:= .F.            // Se a janela de di�logo possuir� enchoicebar (.T.)
Private lPadrao 	:= .F.            // Se a janela deve respeitar as medidas padr�es do Protheus (.T.) ou usar o m�ximo dispon�vel (.F.)
Private nMinY	   	:= 400            // Altura m�nima da janela

Private aSize		:= MsAdvSize(lEnchBar, lPadrao, nMinY)
Private aInfo	   	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3} // Coluna Inicial, Linha Inicial
Private aObjects   	:= {}
Private aPosObj	   	:= {}

aAdd(aObjects,{100,100,.T.,.F.})      // Definicoes para a Enchoice
aAdd(aObjects,{150,150,.T.,.F.})      // Definicoes para a Getdados
aAdd(aObjects,{100,025,.T.,.F.})

aPosObj := MsObjSize(aInfo,aObjects)  // Mantem proporcao - Calcula Horizontal


// Valida��o da inclus�o
If SZT->(RecCount()) == 0 .And. !(nOpc==INCLUIR)
	Return .T.
Endif

cCPOs := "ZU_CODKIT"

aHeader	:= CriaHeader(NIL,cCPOs,aHeader,"SZU")
aCols	:= CriaAcols(aHeader,"SZU",1,xFilial("SZU")+SZT->ZT_CODKIT,nOpc,aCols)
MontaTela(aHeader,aCols,nRecNo,nOpc)

Return nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CriaHeader�Autor  �ANTONIO                    �  19/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria o Aheader da getdados                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FAT                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CriaHeader(cCampos,cExcessao,aHeader,cAliasG)
Local   aArea		:= (cAliasG)->(GetArea())
Default aHeader 	:= {}
DEFAULT cCampos 	:= "" // Campos a serem considerados
DEFAULT cExcessao	:= "" // Campos que n�o considerados

SX3->(dbSetOrder(1))
SX3->(dbSeek(cAliasG))
While SX3->(!EOF()) .And.  SX3->X3_ARQUIVO == cAliasG
	If (cNivel >= SX3->X3_NIVEL) .AND. !(AllTrim(SX3->X3_CAMPO) $ Alltrim(cExcessao)) .And. (X3USO(SX3->X3_USADO))
		aAdd( aHeader, { AlLTrim( X3Titulo() ), ; // 01 - Titulo
		SX3->X3_CAMPO	, ;				// 02 - Campo
		SX3->X3_Picture	, ;				// 03 - Picture
		SX3->X3_TAMANHO	, ;				// 04 - Tamanho
		SX3->X3_DECIMAL	, ;				// 05 - Decimal
		SX3->X3_Valid  	, ;				// 06 - Valid
		SX3->X3_USADO  	, ;				// 07 - Usado
		SX3->X3_TIPO   	, ;				// 08 - Tipo
		SX3->X3_F3		, ;				// 09 - F3
		SX3->X3_CONTEXT , ;	    	   	// 10 - Contexto
		SX3->X3_CBOX	, ; 	  		// 11 - ComboBox
		SX3->X3_RELACAO , } )   		// 12 - Relacao
	Endif
	SX3->(dbSkip())
End
RestArea(aArea)
Return(aHeader)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CriaAcols�Autor  �ANTONIO                    �  19/11/14   ���
���Desc.     �Func�a que cria Acols                                       ���
�������������������������������������������������������������������������͹��
���Parametros�aHeader : aHeader aonde o aCOls ser� baseado                ���
���          �cAlias  : Alias da tabela                                   ���
���          �nIndice : Indice da tabela que sera usado para              ���
���          �cComp   : Informacao dos Campos para ser comparado no While ���
���          �nOpc    : Op��o do Cadastro                                 ���
���          �aCols   : Opcional caso queira iniciar com algum elemento   ���
�������������������������������������������������������������������������͹��
���Uso       � FIN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CriaAcols(aHeader,cAliasG,nIndice,cComp,nOpc,aCols)
Local 	nX			:= 0
Local 	nCols     	:= 0
Local   aArea		:= (cAliasG)->(GetArea())
DEFAULT aCols 		:= {}

IF nOpc == INCLUIR
	aAdd(aCols,Array(Len(aHeader)+1))
	aCols[1][Len(aHeader)+1] := .F.

	For nX := 1 To Len(aHeader)
//		aCols[1][nX] := CriaVar(aHeader[nX][2])

		IF AllTrim(aHeader[nX,2]) == "ZU_ITEM"			
			aCols[1,nX]:= Soma1("0000")		
		ELSE			
			aCols[1,nX]:=CriaVar(aHeader[nX,2])		
		ENDIF	
	
	Next nX
//	aCols[1][Len(aHeader)+1] := .F.
Else

	(cAliasG)->(dbSetOrder(nIndice))
	(cAliasG)->(dbSeek(cComp))
	While (cAliasG)->(!Eof()) .And. ALLTRIM((cAliasG)->(ZU_FILIAL+ZU_CODKIT)) == ALLTRIM(cComp)
		aAdd(aCols,Array(Len(aHeader)+1))
		nCols ++
		For nX := 1 To Len(aHeader)
			If ( aHeader[nX][10] != "V")
				aCols[nCols][nX] := (cAliasG)->(FieldGet(FieldPos(aHeader[nX][2])))
			Else
				aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
			Endif
		Next nX
		aCols[nCols][Len(aHeader)+1] := .F.
		(cAliasG)->(dbSkip())
	End
EndIf
RestArea(aArea)
Return(aCols)


    
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontaTela �Autor  ��ANTONIO            � Data �  17/09/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Func��o respons�vel por montar a tela                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FIN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MontaTela(aHeader,aCols,nReg,nOpc)
//�����������������������������������Ŀ
//� Variaveis da MsNewGetDados()      �
//�������������������������������������
Local nOpcX			:= 0                                 // Op��o da MsNewGetDados
Local cLinhaOk     	:= "U_MAN001LOK()" 					 // Funcao executada para validar o contexto da linha atual do aCols (Localizada no Fonte GS1008)
Local cTudoOk      	:= "AllwaysTrue()" 					// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos     	:= ""                       		// Nome dos campos do tipo caracter que utilizarao incremento automatico.
Local nFreeze      	:= 000              				// Campos estaticos na GetDados.
Local nMax         	:= 999              				// Numero maximo de linhas permitidas.
Local aAlter    	:= {}                               // Campos a serem alterados pelo usuario
Local cFieldOk     	:= "AllwaysTrue"					// Funcao executada na validacao do campo
Local cSuperDel    	:= "AllwaysTrue"          			// Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cDelOk       	:= "AllwaysTrue"    				// Funcao executada para validar a exclusao de uma linha do aCols
//�����������������������������������Ŀ
//� Variaveis da MsMGet()             �
//�������������������������������������

Local aAlterEnch	:= {}                  // Campos que podem ser editados na Enchoice
Local aPos		  	:= {000,000,120,400}   // Dimensao da MsMget em relacao ao Dialog  (LinhaI,ColunaI,LinhaF,ColunaF)
Local nModelo		:= 3     			   // Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local lF3 		  	:= .F.				   // Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria		:= .T.	   	 	       // Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lColumn		:= .F.				   // Indica se a apresentacao dos campos sera em forma de coluna
Local caTela 		:= "" 				   // Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lNoFolder		:= .F.				   // Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty		:= .F.				   // Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes

//�����������������������������������Ŀ
//� Variaveis da EnchoiceBar()        �
//�������������������������������������
Local nOpcA			:= 0										// Bot�o Ok ou Cancela
Local nCont			:= 0
Local aArea			:= GetArea()
Local lExistGet
Local oCodKit := Nil
Local oDescri := Nil

Private cCodKit := ""
Private cDescri := ""

If nOpc != INCLUIR

	cCodKit := SZT->ZT_CODKIT
	cDescri := SZT->ZT_DSCKIT

Else
	cCodKit := CriaVar("ZT_CODKIT")
	cDescri := Posicione("SB1",1,xFilial("SB1")+cCodKit,"B1_DESC")
EndIf


//����������������������������������������������������������������������
//�Adiciona os campos a serem atualizados pelo usuario na MsNewGetDados�
//����������������������������������������������������������������������
For nCont := 1 to Len(aHeader)

	aAlter := {"ZU_ITEM","ZU_PRODUTO","ZU_QTDE","ZU_PRATEIO"}

	If ( aHeader[nCont][10] != "V") .And. X3USO(aHeader[nCont,7])
		aAdd(aAlter,aHeader[nCont,2])
	EndIf
Next nCont

//����������������������Ŀ
//�Defini��od dos Objetos�
//������������������������
oDlg := MSDIALOG():New(aSize[7],aSize[2],aSize[6],aSize[5],cCadastro,,,,,,,,,.T.)

If nOpc == INCLUIR .Or. nOpc == ALTERAR
	nOpcX	:= GD_INSERT+GD_UPDATE+GD_DELETE
Else
	nOpcX	:= 0
EndIf

oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,36,.T.,.F.)
oTPane1:Align := CONTROL_ALIGN_TOP
@ 004, 006 SAY "Produto Kit Fardo: " SIZE 90,7 PIXEL OF oTPane1 
@ 004, 250 SAY "Descri��o: " SIZE 90,7 PIXEL OF oTPane1

@ 003, 066 MSGET oCodKit VAR cCodKit  Picture "@!" When INCLUI Valid NaoVazio(cCodKit) .And. U_EnchMan(cCodKit,nOpc)  SIZE 50,7 PIXEL OF oTPane1 F3 "SB1"
@ 4.1, 300 SAY   cDescri SIZE 230,7 PIXEL OF oTPane1


//�������������Ŀ
//�MsNewGetDados�
//���������������
oGet			:= MsNewGetDados():New(aPosObj[2][1],aPosObj[2][2],aPosObj[2][3],aPosObj[2][4],nOpcX,;
cLinhaOk ,cTudoOk,"+ZU_ITEM" /*cIniCpos*/,aAlter,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oDLG,aHeader,aCols)
oGet:obrowse:align:= CONTROL_ALIGN_ALLCLIENT

oDlg:bInit 		:= EnchoiceBar(oDlg,{||IIF( IIF(nOpc == INCLUIR .Or. nOpc == ALTERAR, U_MAN001TOK(nOpc) , .T.) ,(nOpcA:=1,oDlg:End()), )},{|| oDlg:End()})
oDlg:lCentered	:= .T.
oDlg:Activate()

If nOpcA == OK .AND. !(nOpc == VISUALIZAR)
	Begin Transaction
	MAN001Grava(nOpc)
	ConfirmSX8()
	End Transaction
Else
	RollBackSX8()
Endif

RestArea(aArea)
Return(nOpcA)

User Function XTeste(cCodKit)
	cDescri := Posicione("SB1",1,xFilial("SB1")+cCodKit,"B1_DESC")
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � EnchMan  �Autor  �ANTONIO             � Data �  20/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao para o campo Kit Fardo                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FIN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EnchMan(cCodKit,nOpc)
Local lRet	:= .T.

If lRet .and. nOpc==3
	lRet := ExistChav("SZT", cCodKit ) 
	cDescri := Posicione("SB1",1,xFilial("SB1")+cCodKit,"B1_DESC")
EndIf

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MAN001LOK �Autor  �ANTONIO � Data �  20/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o LinOK da rotina                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FIN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MAN001LOK(nLinha,lHelp)
Local lRet 			:= .T.
Local nX			:= 0
Local aCols 		:= oGet:aCols
Local aHeader		:= oGet:aHeader
Local nPosItem		:= aScan(aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_ITEM")})
Local nPosChav		:= aScan(aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_PRODUTO")})
Local nTRateio		:= 0

Default nLinha := oGet:nAt
Default lHelp := .T.

For nX:= 1 to Len(aCols)

	If !aCols[nX][Len(aHeader)+1] .And. nX != nLinha .And.;
		ALLTRIM(aCols[nX][nPosChav]) == ALLTRIM(aCols[nLinha][nPosChav])
		If lHelp
			Help(" ",1,"FR0LINDUP" , , "Linha Duplicada" ,3,0 )
		EndIf
		lRet := .F.
		Exit
	EndIf 

	nTRateio:=nTRateio+oGet:aCols[nX,GdFieldPos("ZU_PRATEIO",aHeader)]
	
Next nX

If nTRateio > 100
	If lHelp
		Help(" ",1,"FR0LINDUP" , , "Total do Rateio n�o pode ser maior que 100% !!!" ,3,0 )
	EndIf
	lRet := .F.
	
EndIf


If nLinha == Len(aCols) + 1
	oGet:aCols[nLinha+1,GdFieldPos("ZU_ITEM",aHeader)]:= Soma1(Str(nLinha+1))
EndIf

Return lRet



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MAN001Grava �Autor  �ANTONIO � Data �  19/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para efetuar a grava��o nas tabelas                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FIN                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MAN001Grava(nOpc)
Local nX			:= 0
Local nI 			:= 0
//Local nPosChav		:= aScan(oGet:aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_CODMAN")})
Local nPosChav		:= cCodKit
Local nPosChvAux	:= aScan(oGet:aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_ITEM")})

Local nPosProd		:= aScan(oGet:aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_PRODUTO")})

Local nPosDesc      := aScan(oGet:aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_DSCPRD")})
Local nPosUM        := aScan(oGet:aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_UMPRD")})

Local nPosQtde		:= aScan(oGet:aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_QTDE")})
Local nPosPRat      := aScan(oGet:aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_PRATEIO")})

Local lGrava		:= .F.
Local cArquivo		:= ""
Local cChave		:= ""
Local nIndex		:= 0
Local aArea			:= GetArea()
Local aAreaSZT		:= SZT->(GetArea())
Local cAliasG		:= "SZU"

If nOpc == INCLUIR .Or. nOpc == ALTERAR
	
	//���������������������������Ŀ
	//�Grava o cabe�alho da tabela�
	//�����������������������������
	lGrava := ( SZT->(dbSeek(xFilial("SZT")+cCodKit)) )
	RecLock("SZT",!lGrava)
	SZT->ZT_FILIAL  := xFilial("SZT")
	SZT->ZT_CODKIT  := cCodKit
	SZT->ZT_DSCKIT  := cDescri

	MsUnLock()
	
	//������������������������Ŀ
	//�Grava os Itens da Tabela�
	//��������������������������
	For nX:= 1 to Len(oGet:aCols)
		lGrava := ( (cAliasG)->(dbSeek(xFilial(cAliasG)+cCodKit+oGet:Acols[nX,nPosChvAux])) )
		If oGet:Acols[nX,Len(oGet:aHeader)+1] .And. lGrava .And. U_MAN001LOK(nX,.F.)
			RecLock(cAliasG,!lGrava)
			( cAliasG )->( dbDelete() )
			MsUnlock()
		ElseIf !oGet:Acols[nX,Len(oGet:aHeader)+1] .And. (!Empty(cCodKit) .Or. !Empty(oGet:Acols[nX,nPosChvAux]))
			RecLock(cAliasG,!lGrava)
			(cAliasG)->ZU_FILIAL := xFilial(cAliasG)
			(cAliasG)->ZU_CODKIT := cCodKit
			For nI:= 1 to Len(oGet:aHeader)
				(cAliasG)->(FieldPut(FieldPos(Trim(oGet:aHeader[nI,2])),oGet:aCols[nX,nI]))
			Next nI

			nPosProd	:= oGet:aCols[nX,GdFieldPos("ZU_PRODUTO", oGet:aHeader)]
			nPosDesc	:= oGet:aCols[nX,GdFieldPos("ZU_DSCPRD" , oGet:aHeader)]
			nPosUM  	:= oGet:aCols[nX,GdFieldPos("ZU_UMPRD"  , oGet:aHeader)]
			nPosQtde	:= oGet:aCols[nX,GdFieldPos("ZU_QTDE"   , oGet:aHeader)]
			nPosPRat 	:= oGet:aCols[nX,GdFieldPos("ZU_PRATEIO", oGet:aHeader)]

			MsUnLock()
		EndIf
	Next nX
	
ElseIf nOpc == EXCLUIR
	//���������������Ŀ
	//�Deleta os Itens�
	//�����������������
	SZT->(dbSetOrder(1)) // ZT_FILIAL + ZT_CODMAN
	If SZT->(dbSeek(xFilial("SZT")+ cCodKit))
		RecLock(cAlias,.F.)
		( cAlias )->( dbDelete() )
		MsUnlock()
	EndIf
		
	(cAliasG)->(dbSeek(xFilial(cAliasG)+cCodKit))
	While (cAliasG)->(!EOF()) .And. (cAliasG)->(ZU_FILIAL + ZU_CODMAN ) == xFilial(cAliasG)+cCodKit
		RecLock(cAliasG,.F.)
		( cAliasG )->( dbDelete() )
		MsUnlock()
		(cAliasG)->(dbSkip())
	EndDo


	For nX:= 1 to Len(oGet:aCols)

		nPosProd := oGet:aCols[nX,GdFieldPos("ZU_PRODUTO", oGet:aHeader)]
		nPosDesc := oGet:aCols[nX,GdFieldPos("ZU_DSCPRD" , oGet:aHeader)]
		nPosUM   := oGet:aCols[nX,GdFieldPos("ZU_UMPRD"  , oGet:aHeader)]
		nPosQtde := oGet:aCols[nX,GdFieldPos("ZU_QTDE"   , oGet:aHeader)]
		nPosPRat := oGet:aCols[nX,GdFieldPos("ZU_PRATEIO", oGet:aHeader)]
	
	Next	

EndIf

dbSetOrder(1)

RestArea(aAreaSZT)
RestArea(aArea)
Return .T.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MAN001TOK �Autor  �ANTONIO � Data �  20/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o TudoOK da rotina                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FIN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MAN001TOK(nOpc)
Local lRet 			:= .T.
Local nX	  		:= 0
Local aCols 		:= oGet:aCols
Local aHeader		:= oGet:aHeader
Local nPosChav		:= aScan(aHeader,{|x|AllTrim(Upper(x[2]))==Upper("ZU_PRODUTO")})
Local nItens		:= 0
Local nPos			:= 0
Local nTRateio      := 0

lRet := NaoVazio(cCodKit) .And. U_EnchMan(cCodKit,nOpc)

If lRet
	For nX:= 1 to Len(aCols)
		If !aCols[nX][Len(aHeader)+1]
			If !U_MAN001LOK(nX)
				lRet := .F.
				Exit
			ElseIF !Empty(aCols[nX][nPosChav])
				nItens++
			EndIf
		EndIf

		nTRateio:=nTRateio+oGet:aCols[nX,GdFieldPos("ZU_PRATEIO",aHeader)]

	Next nX
EndIf

If lRet .And. nItens == 0
	Help(" ",1,"FR0NOLIN" , , "Por favor, crie pelo menos um item" ,3,0 )
	lRet := .F.
EndIf

If lRet	
	If nTRateio <> 100
//		If lHelp
			Help(" ",1,"FR0LINDUP" , , "Total do Rateio n�o pode ser maior ou menor que 100% !!!" ,3,0 )
//		EndIf
		lRet := .F.
	EndIf
EndIf

Return lRet

     
   
/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   � DURAPRD  � Autor � Antonio                 � Data �26/11/2014���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Buscar nome do Produto/Unidade na getdados do cCodKit        ���
����������������������������������������������������������������������������Ĵ��
���Parametros � oObjeto := Objeto da NewGetDados                             ���
���           � nLinha  := Linha da GetDados, caso o parametro nao seja      ���
���           �            preenchido o Default sera o nAt da NewGetDados    ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
User Function DURAPRD() 

	Local lRet  := .T.
	Local cProduto, nPosProd

	nPosProd := oGet:aCols[oGet:nAt,GdFieldPos("ZU_PRODUTO",oGet:aHeader)]

	If Empty(cProduto)

		If Alltrim(Readvar()) == "M->ZU_PRODUTO"
			nPosProD := M->ZU_PRODUTO
		Else
			nPosProD := oGet:aCols[oGet:nAt,GdFieldPos("ZU_PRODUTO",oGet:aHeader)]
		EndIf

		SB1->(dbSetOrder(1)) // B1_FILIAL + B1_COD
		If SB1->(dbSeek(xFilial("SB1") + nPosProd ))

			If !oGet:aCols[oGet:nAt,Len(oGet:aHeader)+1]

				oGet:aCols[oGet:nAt,GdFieldPos("ZU_DSCPRD",oGet:aHeader)]:=SB1->B1_DESC
				oGet:aCols[oGet:nAt,GdFieldPos("ZU_UMPRD",oGet:aHeader)]:=SB1->B1_UM

				cDescPRD := SB1->B1_DESC
			    cUMPRD   := SB1->B1_UM
			
				oGet:Refresh()
			EndIf
		EndIf
	EndIf


	If !oGet:aCols[oGet:nAt,Len(oGet:aHeader)+1]

		If Alltrim(Readvar()) == "M->ZU_PRODUTO"
			nPosProD := M->ZU_PRODUTO
		Else
			nPosProD := oGet:aCols[oGet:nAt,GdFieldPos("ZU_PRODUTO",oGet:aHeader)]
		EndIf

		SB1->(dbSetOrder(1)) // B1_FILIAL + B1_COD
		If SB1->(dbSeek(xFilial("SB1") + nPosProd ))

			If !oGet:aCols[oGet:nAt,Len(oGet:aHeader)+1]

				oGet:aCols[oGet:nAt,GdFieldPos("ZU_DSCPRD",oGet:aHeader)]:=SB1->B1_DESC
				oGet:aCols[oGet:nAt,GdFieldPos("ZU_UMPRD",oGet:aHeader)]:=SB1->B1_UM

				cDescPRD := SB1->B1_DESC
			    cUMPRD   := SB1->B1_UM
			
				oGet:Refresh()
			EndIf
		EndIf

//		oGet:aCols[oGet:nAt,GdFieldPos("ZU_NOMCLI",oGet:aHeader)]:=Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NOME")

	EndIf

	oGet:ForceRefresh()
	oGet:obrowse:Refresh()

Return(lRet)


