#INCLUDE "PROTHEUS.CH"
//#INCLUDE "MATA512.CH"
/*/                
���Programa  �XFAT512   � Autor � Paulo R. Trivellato   � Data � 19.06.09 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Inclusao e/ou alteracao de Transportadora e Veiculo         ���
/*/
User Function XFAT512()

return

//��������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �
//� 4. Tipo de Transa��o a ser efetuada                          �
//�    1 - Pesquisa e Posiciona em um Banco de Dados             �
//�    2 - Simplesmente Mostra os Campos                         �
//�    3 - Inclui registros no Bancos de Dados                   �
//�    4 - Altera o registro corrente                            �
//�    5 - Remove o registro corrente do Banco de Dados          �
//����������������������������������������������������������������
Private aRotina	:= MenuDef()

//��������������������������������������������������������������Ŀ
//� Define o cabecalho da tela de atualizacoes                   �
//����������������������������������������������������������������
Private cCadastro	:= OemtoAnsi("Expedicao")

dbSelectArea("SF2")
dbSetOrder(1)
MsSeek(xFilial("SF2"))
mBrowse(6,1,22,75,"SF2")

Return Nil
/*/                
Programa  A512Manut � Autor � Sergio S. Fuzinaka    � Data � 14.12.05 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Inclusao e/ou alteracao de Transportadora e Veiculo         ���
/*/
User Function FAT512C()

Local aArea		:= GetArea()
Local aTitles	:= {OemtoAnsi("Nota Fiscal")} 
Local nCntFor	:= 0
Local nOpc		:= 0
Local nX        := 0
Local lVeiculo	:= (SF2->(FieldPos("F2_VOLUME1"))>0 .And. SF2->(FieldPos("F2_PLIQUI"))>0 .And. SF2->(FieldPos("F2_PBRUTO"))>0)
Local cTransp	:= ""
Local cPLACA	:= ""
Local cVOLUME1	:= ""
Local cpLIQUI	:= ""
Local cpBRUTO	:= ""
Local oDlg
Local oFolder
Local oList
Local lM512Agr := ExistBlock("M512AGRV")

Private aHeader	  := {}
Private aCols	  := {}

Private oTransp
Private cPLACA
Private oVOLUME1
Private opLIQUI
Private opBRUTO

If lVeiculo

	RegToMemory("SF2",.F.)
	
	cTransp	:= Posicione("SA4",1,xFilial("SA4")+SF2->F2_TRANSP,"A4_NOME")
	cPLACA	:= SF2->F2_PLACA
	cVOLUME1:= SF2->F2_VOLUME1
	cpLIQUI := SF2->F2_PLIQUI
	cpBRUTO := SF2->F2_PBRUTO

	//������������������������������������������������������Ŀ
	//� Montagem do aHeader                                  �
	//��������������������������������������������������������
	dbSelectArea("SX3")
	dbSetOrder(1)                                                                             
	If dbSeek("SF2")
		While ( !Eof() .And. (SX3->X3_ARQUIVO == "SF2") )
			If ( X3USO(SX3->X3_USADO) .And. ;
				AllTrim(SX3->X3_CAMPO) $ "F2_DOC|F2_SERIE|F2_CLIENTE|F2_LOJA|F2_EMISSAO" .And. ;
				cNivel >= SX3->X3_NIVEL )
				
				Aadd(aHeader,{ TRIM(X3Titulo()),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_VALID,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_ARQUIVO,;
					SX3->X3_CONTEXT } )
			EndIf
			dbSelectArea("SX3")
			dbSkip()
		EndDo
	EndIf                     
	
	//������������������������������������������������������Ŀ
	//� Montagem do aCols                                    �
	//��������������������������������������������������������
	dbSelectArea("SF2")
	AADD(aCols,Array(Len(aHeader)))
	For nCntFor:=1 To Len(aHeader)
		If ( aHeader[nCntFor,10] <>  "V" )
			aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
		Else			
			aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
		EndIf
	Next nCntFor
	
	//���������������������������������������������Ŀ
	//�Monta a tela de exibicao dos dados           �
	//�����������������������������������������������
//	DEFINE MSDIALOG oDlg TITLE "Manutencao de Transportadoras, Volume e Peso" FROM 09,00 TO 28.2,80
	DEFINE MSDIALOG oDlg TITLE "Manutencao de Transportadoras, Volume e Peso" FROM 09,00 TO 29.7,80
	
	oFolder	:= TFolder():New(001,001,aTitles,{"HEADER"},oDlg,,,, .T., .F.,315,156)
	oList 	:= TWBrowse():New( 5, 1, 310, 42,,{aHeader[1,1],aHeader[2,1],aHeader[3,1],aHeader[4,1],aHeader[5,1]},{30,90,50,30,50},oFolder:aDialogs[1],,,,,,,,,,,,.F.,,.T.,,.F.,,, ) //"Numero"###"Serie"###"Cliente"###"Loja"###"DT Emissao"
	oList:SetArray(aCols)
	oList:bLine	:= {|| {aCols[oList:nAt][1],aCols[oList:nAt][2],aCols[oList:nAt][3],aCols[oList:nAt][4],aCols[oList:nAt][5]}}
	oList:lAutoEdit	:= .F.
	
	@ 051,005 SAY RetTitle("F2_TRANSP")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 066,005 SAY RetTitle("F2_PLACA")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 081,005 SAY RetTitle("F2_VOLUME1")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 096,005 SAY RetTitle("F2_PLIQUI")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]	
	@ 110,005 SAY RetTitle("F2_PBRUTO")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]		
	
	@ 051,050 MSGET M->F2_TRANSP	PICTURE PesqPict("SF2","F2_TRANSP")		F3 CpoRetF3("F2_TRANSP")	SIZE 50,07 PIXEL OF oFolder:aDialogs[1] VALID IIf(Vazio(),(cTransp:="",.T.),.F.) .Or. (ExistCpo("SA4").And.A512Disp(@cTransp))
	@ 066,050 MSGET M->F2_PLACA		PICTURE PesqPict("SF2","F2_PLACA")		F3 CpoRetF3("F2_PLACA")		SIZE 50,07 PIXEL OF oFolder:aDialogs[1] VALID IIf(Vazio(),(cPLACA:="",.T.),.F.) 	.Or. A512Disp(@cPLACA)
	@ 081,050 MSGET M->F2_VOLUME1	PICTURE PesqPict("SF2","F2_VOLUME1")	F3 CpoRetF3("F2_VOLUME1")	SIZE 50,07 PIXEL OF oFolder:aDialogs[1] VALID IIf(Vazio(),(cVOLUME1:=0,.T.),.F.) .Or. M->F2_VOLUME1 >= 0 .And. A512Disp(@cVOLUME1)
	@ 096,050 MSGET M->F2_PLIQUI	PICTURE PesqPict("SF2","F2_PLIQUI")		F3 CpoRetF3("F2_PLIQUI")	SIZE 50,07 PIXEL OF oFolder:aDialogs[1] VALID IIf(Vazio(),(cpLIQUI :=0,.T.),.F.) .Or. M->F2_PLIQUI >= 0 .And. A512Disp(@cpLIQUI)
	@ 110,050 MSGET M->F2_PBRUTO	PICTURE PesqPict("SF2","F2_PBRUTO")		F3 CpoRetF3("F2_PBRUTO")	SIZE 50,07 PIXEL OF oFolder:aDialogs[1] VALID IIf(Vazio(),(cpBRUTO :=0,.T.),.F.) .Or. M->F2_PBRUTO >= 0 .And. A512Disp(@cpBRUTO)
	
	@ 051,105 MSGET oTransp		VAR cTransp		PICTURE PesqPict("SF2","F2_TRANSP")		WHEN .F. SIZE 150,07 PIXEL OF oFolder:aDialogs[1]
	@ 066,105 MSGET oPLACA		VAR cPLACA		PICTURE PesqPict("SF2","F2_PLACA")		WHEN .F. SIZE 150,07 PIXEL OF oFolder:aDialogs[1]
	@ 081,105 MSGET oVOLUME1	VAR cVOLUME1	PICTURE PesqPict("SF2","F2_VOLUME1")	WHEN .F. SIZE 150,07 PIXEL OF oFolder:aDialogs[1]
	@ 096,105 MSGET opLIQUI		VAR cpLIQUI		PICTURE PesqPict("SF2","F2_PLIQUI")		WHEN .F. SIZE 150,07 PIXEL OF oFolder:aDialogs[1]	
	@ 110,105 MSGET opBRUTO		VAR cpBRUTO		PICTURE PesqPict("SF2","F2_PBRUTO")		WHEN .F. SIZE 150,07 PIXEL OF oFolder:aDialogs[1]		
	
	@ 125,005 TO 111,310 PIXEL OF oFolder:aDialogs[1]
	@ 128,225 BUTTON OemToAnsi("Confirmar")	SIZE 040,13 FONT oFolder:aDialogs[1]:oFont ACTION (nOpc:=1,oDlg:End())	OF oFolder:aDialogs[1] PIXEL	//"Confirmar"
	@ 128,270 BUTTON OemToAnsi("Cancelar")	SIZE 040,13 FONT oFolder:aDialogs[1]:oFont ACTION oDlg:End()			OF oFolder:aDialogs[1] PIXEL	//"Cancelar"
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpc == 1
		RecLock("SF2",.F.)
		SF2->F2_TRANSP	:= M->F2_TRANSP
		SF2->F2_PLACA	:= M->F2_PLACA
		SF2->F2_VOLUME1	:= M->F2_VOLUME1
//		SF2->F2_VEICUL2	:= M->F2_VEICUL2		
//		SF2->F2_VEICUL3	:= M->F2_VEICUL3
		SF2->F2_PLIQUI	:= M->F2_PLIQUI
		SF2->F2_PBRUTO	:= M->F2_PBRUTO
//		SF2->F2_VOLUME1	:= M->F2_VOLUME1
		MsUnlock()
	Endif
	
	//������������������������������������������������������������������������Ŀ
	//� Ponto de entrada antes da gravacao da manutencao                       �
	//��������������������������������������������������������������������������
	If lM512Agr
		ExecBlock("M512AGRV",.F.,.F.)
	EndIf

Else

	MsgAlert(OemToAnsi("Criar os campos F2_VEICUL1, F2_VEICUL2 e F2_VEICUL3 ou executar o RdMake UPDFIS"))

Endif

RestArea(aArea)

Return Nil

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Marco Bianchi         � Data �12/05/2008���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �		1 - Pesquisa e Posiciona em um Banco de Dados         ���
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
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()

Private aRotina	:= {	{ "Pesquisar" ,"AxPesqui"  , 0 , 1,0,.F.},;	//"Pesquisar"
						{ "Visualizar" ,"AxVisual"  , 0 , 2,0,NIL},;	//"Visualizar"
						{ "Manutencao","U_FAT512C()", 0 , 4,0,NIL} }	//"Manutencao"

If ExistBlock("MA512MNU")
	ExecBlock("MA512MNU",.F.,.F.)
EndIf

Return(aRotina)
/*/                
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �A512Disp  � Autor � Sergio S. Fuzinaka    � Data � 14.12.05 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Display do Campo                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function A512Disp(cCampo)

Local aArea	:= GetArea()
Local cCpo	:= ReadVar()

Do Case
	Case cCpo == "M->F2_TRANSP"
		cCampo := Posicione("SA4",1,xFilial("SA4")+M->F2_TRANSP,"A4_NOME")
		oTransp:Refresh()
	Case cCpo == "M->F2_VOLUME1"
		cCampo	:= M->F2_VOLUME1
		oVOLUME1:Refresh()	
	Case cCpo == "M->F2_PLIQUI"
		campo	:= M->F2_PLIQUI
		opLIQUI:Refresh()
	Case cCpo == "M->F2_PBRUTO"
		cCampo	:= M->F2_PBRUTO
		opBRUTO:Refresh()
EndCase

RestArea(aArea)

Return(.T.)