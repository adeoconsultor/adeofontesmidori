#INCLUDE "Rwmake.ch"
#INCLUDE "Average.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � EECRom � Autor � Robson S. Dias 			� Data � 11.03.09 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Dados da Declaracao de Importacao	                          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � DI210(void)                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEIC                                                    ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function EECROM

Private cPedido:=""
Private _cContLote := Space(10)
Private _cContAlt  := Space(03)
Private _cContLarg := Space(03)
Private _cContComp := Space(03)          

If ! TelaGets()
   Return 
Endif


Private aRotina := { 	{ OemToAnsi("Pesquisar"  ), "AxPesqui", 	0, 1},; 	//"Pesquisar"
						{ OemToAnsi("Preparar")   , "U_PREPROM", 	0, 3},;  	//"Preparar"
						{ OemToAnsi("Imprimir")   , "U_IMPROM", 	0, 1}}  	//"Imprimir"
						
//���������������������������������������������������������������������������Ŀ
//� Define o cabecalho da tela de atualizacoes                                �
//�����������������������������������������������������������������������������
Private cCadastro 	:= OemToAnsi("Planilha Romaneio") //"Aprovacao de Aparencia"

Private aSize	  := MsAdvSize(,.F.,430)
Private aObjects  := {} 
Private aPosObj   := {} 
Private aSizeAut  := MsAdvSize() // devolve o tamanho da tela atualmente no micro do usuario

AAdd( aObjects, { 315,  70, .T., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )

aInfo   := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 

Private aTela[0][0],aGets[0]

Private nTamLin		:= 75
Private cAlias2     := ""
Private cAlias1     := ""
DbSelectArea("EE8")                                 
DbSetOrder(1)
                                                       
EE7->(dbsetorder(1))
EE7->(dbseek(xFilial('EE7')+cPedido))
                 
SET FILTER TO EE8->EE8_PEDIDO == cPedido .AND. EE8->EE8_XITROM == "N"
mBrowse( 6, 1, 22, 75,"EE8",,,,,,)
SET FILTER TO
Return

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao    �PrepRom     � Autor � Robson Ramiro A.Olivei� Data �23.07.01  ���
���������������������������������������������������������������������������Ĵ��
���Descricao � Funcao para Inclusao                                         ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � Void PrepRom(ExpC1,ExpN1,ExpN2)                              ���
���������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                     ���
���          � ExpN1 = Numero do registro                                   ���
���          � ExpN2 = Numero da opcao                                      ���
���������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                     ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PREPROM(cAlias,nReg,nOpc)

Local oDlg		:= NIL
Local lOk 		:= .F.
Local aCposVis	:= {}
Local aCposNao	:= {}
Local aButtons	:= {}

Private aHeader	:= {}
Private aCols	:= {}
Private nUsado	:=	0
Private oGet	:= NIL         

Private aTela[0][0],aGets[0]

DbSelectArea("ZZA")   
ZZA->(DBSEEK(xFilial('ZZA')+cPedido+EE8->EE8_COD_I+EE8->EE8_SEQUEN)) 
SET FILTER TO ZZA_FILIAL+ZZA_PEDIDO+ZZA_ARTIGO+ZZA_SEQUEN == xFilial('ZZA')+cPedido+EE8->EE8_COD_I+EE8->EE8_SEQUEN 
dbgotop()

cAlias:="ZZA"
cAlias1:="ZZA"
cAlias2:="ZZB"

//��������������������������������������������������������������Ŀ
//� Monta Enchoice Modelo3                                       �
//����������������������������������������������������������������

_cContAlt  := "27 "
_cContLarg := "40 "
_cContComp := "147"

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Preparacao do Romaneio") ; //"Aprovacao de Aparencia"
						FROM aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL


//��������������������������������������������������������������Ŀ
//� Monta vetor aHeader a ser utilizado na getdados              �
//����������������������������������������������������������������
ROMAhead(cAlias2)

nUsado	:= Len(aHeader)

ROMAcols(nOpc)
								
RegToMemory(cAlias,.T.)						

M->ZZA_PEDIDO :=cPedido
M->ZZA_CLIENT :=EE7->EE7_CLIENT
M->ZZA_NOME   :=POSICIONE("SA1",1,XFILIAL("SA1")+EE7->EE7_CLIENT+EE7->EE7_CLLOJA,"A1_NOME")
M->ZZA_ARTIGO :=EE8->EE8_COD_I
M->ZZA_DESC   :=EECIniPad("EE8_VM_DES")
M->ZZA_SEQUEN :=EE8->EE8_SEQUEN
M->ZZA_SLDINI :=EE8->EE8_SLDINI
M->ZZA_TOTROM :=ZZA->ZZA_TOTROM
 
Enchoice(cAlias,nReg,nOpc, , , , ,aPosObj[1]/*{14,03,83,332}*/, , , , ,)

 aButtons:={}
//aButtons := {	{"EDIT", { || QPP210APRO(nOpc) }, OemToAnsi( STR0007 )}} //"Aprovar/Limpar"

DbSelectArea(cAlias2)						

cCampoInc:="+"+cAlias2+"_ITEM"      

oGet := MSGetDados():New(aPosObj[2,1]-80,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"U_RomLinOk","",cCampoInc,.T.,,,,999) 

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||lOk := TudoOk(), Iif(Obrigatorio(aGets,aTela) .and. lOk,If(MsgYesno("Confirma a Gravacao?","Aten��o"),oDlg:End(),lOk:=.F.),)},{||If(MsgYesno("Deseja Sair?","Aten��o"),(lOk:=.f.,oDlg:End()),)}, , aButtons)

If lOk
	Processa({ ||RomGrava(nOpc) })
	nOpc:=0
Endif

Return



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �RomAcols� Autor � Robson Ramiro A. Olive� Data � 10.08.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Carrega vetor aCols para a GetDados                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RomAcols()                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 = Opcao                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � DI210                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RomAcols(nOpc)
Local nCnt, n, nI, nPos

//������������������������������������������������������Ŀ
//� Montagem do aCols               					 �
//��������������������������������������������������������

DbSelectArea(cAlias2)    
DbSetOrder(1)
If !DbSeek(xFilial(cAlias2)+ZZA->ZZA_PEDIDO+ZZA->ZZA_ARTIGO+ZZA->ZZA_SEQUEN)
   nOpc:=3
Endif

If nOpc == 3
	
	aCols := Array(1,nUsado+1)
	
	For nI = 1 To Len(aHeader)
		If aHeader[nI,8] == "C"
			aCols[1,nI] := Space(aHeader[nI,4])
		ElseIf aHeader[nI,8] == "N"
			aCols[1,nI] := 0
		ElseIf aHeader[nI,8] == "D"
			aCols[1,nI] := CtoD(" / / ")
		ElseIf aHeader[nI,8] == "M"
			aCols[1,nI] := ""
		Else
			aCols[1,nI] := .F.
		EndIf
	Next nI
	
	nPos			:= aScan(aHeader,{ |x| AllTrim(x[2])== cAlias2+"_ITEM" })
	aCols[1,nPos]	:= StrZero(1,Len(aCols[1,nPos]))
	
	aCols[1,nUsado+1] := .F.
	
Else
	
	Do While !ZZB->(EOF()) .and. ZZB->(ZZB_FILIAL+ZZB_PEDIDO+ZZB_ARTIGO+ZZB_SEQUEN) == xFilial('ZZB')+ZZA->ZZA_PEDIDO+ZZA->ZZA_ARTIGO+ZZA->ZZA_SEQUEN
		
		//If Empty(Alltrim(ZZB->ZZB_USADO)
			aAdd(aCols,Array(nUsado+1))
			
			For nI := 1 to nUsado
				
				If Upper(AllTrim(aHeader[nI,10])) != "V" 	// Campo Real
					aCols[Len(aCols),nI] := FieldGet(FieldPos(aHeader[nI,2]))
				Else										// Campo Virtual
					cCpo := AllTrim(Upper(aHeader[nI,2]))
					aCols[Len(aCols),nI] := CriaVar(aHeader[nI,2])
				Endif
				
			Next nI
		
			aCols[Len(aCols),nUsado+1] := .F.
		//EndIf	

		ZZB->(DbSkip())
		
	Enddo
	
Endif


Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �DI210Ahead� Autor � Robson Ramiro A. Olive� Data � 10.08.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Monta Ahead para aCols                                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � DI210Ahead()                                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 : Alias                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � DI210                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ROMAhead(cAlias)

aHeader := {}
nUsado 	:= 0

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek(cAlias)

Do While !Eof() .and. (X3_ARQUIVO == cAlias)

	//��������������������������������������������������
	//�Ignora campos que nao devem aparecer na getdados�
	//��������������������������������������������������

	If 	Upper(AllTrim(X3_CAMPO)) $ "ZZB_PEDIDO/ZZB_ARTIGO/ZZB_SEQUEN"
		DbSkip()
		Loop
	Endif      

	If X3USO(X3_USADO) .and. cNivel >= X3_NIVEL
		nUsado++
			Aadd(aHeader,{ AllTrim(X3Titulo()),;                                                                                         
				SX3->X3_CAMPO	,;                                                                                                       
				SX3->X3_PICTURE,;                                                                                                       
				SX3->X3_TAMANHO,;                                                                                                       
				SX3->X3_DECIMAL,;                                                                                                       
				SX3->X3_VALID	,;                                                                                                       
				SX3->X3_USADO	,;                                                                                                       
				SX3->X3_TIPO	,;                                                                                                       
				SX3->X3_F3 		,;                                                                                                       
				SX3->X3_CONTEXT,;                                                                                                       
				SX3->X3_CBOX	,;                                                                                                       
				SX3->X3_RELACAO})                                                                                                       

	Endif

	DbSkip()

Enddo 

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � RomGrava � Autor � Robson Ramiro A Olivei� Data � 10.08.01 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Programa de Gravacao - Incl./Alter.                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RomGrava(ExpC1)                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Exp1N = Opcao                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EEC_ROM                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RomGrava(nOpc)

Local nIt,nCpo     
Local nCont
Local nNumItem
Local nPosDel 		:= Len(aHeader) + 1
Local bCampo		:= { |nCPO| Field(nCPO) }
Local lGraOk 		:= .T.   // Indica se todas as gravacoes obtiveram sucesso
Local cAtividade	:= "11    " // Definido no SX5 - QF
Local aAVAP1		:= {}  // Array para converter o texto


//Local aCposChaves   :={"_REF","_PROC"}

ProcRegua(Len(aCols))


Begin Transaction
                               
DbSelectArea(cAlias1)
DbSetOrder(1)
     
lInclui:=.f.
If ! ZZA->(dbseek(xFilial('ZZA')+cPedido+EE8->EE8_COD_I+EE8->EE8_SEQUEN))
   lInclui:= .t.
Endif

If lInclui
	RecLock(cAlias1,.T.)
Else
	RecLock(cAlias1,.F.)
Endif

For nCont := 1 To (cAlias1)->(FCount())

	IncProc("Gravando registros...")

	If "FILIAL"$(cAlias1)->(Field(nCont))
		(cAlias1)->(FieldPut(nCont,xFilial(cAlias1)))
	Else                                 
	   (cAlias1)->(FieldPut(nCont,M->&(EVAL(bCampo,nCont))))
    Endif
Next nCont

MsUnLock()

DbSelectArea(cAlias2)
DbSetOrder(1)

nNumItem := 1  // Contador para os Itens
nTotRom:=0
	
For nIt := 1 To Len(aCols)

	IncProc("Gravando registros...")

    cItem:=aCols[nIt,1]             

	If !aCols[nIt, nPosDel]  // Verifica se o item foi deletado
       
       lIncluiDet:=.F.
       If !ZZB->(dbseek(xFilial('ZZB')+M->ZZA_PEDIDO+M->ZZA_ARTIGO+M->ZZA_SEQUEN+cItem))
          lIncluiDet:=.T.
       Endif
       
       If !lIncluiDet
  		  RecLock(cAlias2,.F.)
	   Else
		  RecLock(cAlias2,.T.)
	   Endif

	   For nCpo := 1 To Len(aHeader)
	       If aHeader[nCpo, 10] <> "V"
		      (cAlias2)->(FieldPut(FieldPos(Trim(aHeader[nCpo, 2])),aCols[nIt, nCpo]))
		   EndIf
	   Next nCpo
  
       ZZB->ZZB_FILIAL:=xFilial('ZZB')
       ZZB->ZZB_PEDIDO:=M->ZZA_PEDIDO
       ZZB->ZZB_ARTIGO:=M->ZZA_ARTIGO
       ZZB->ZZB_SEQUEN:=M->ZZA_SEQUEN
       ZZB->ZZB_ITEM  :=cItem
       nTotRom+=ZZB->ZZB_SQMTOT  // Total do Romaneio
    Else
       If ZZB->(dbseek(xFilial('ZZB')+M->ZZA_PEDIDO+M->ZZA_ARTIGO+M->ZZA_SEQUEN+cItem))
          ZZB->(RecLock(cAlias2,.F.))
          ZZB->(dbdelete())          
       Endif
    Endif             
    (cAlias2)->(MsUnlock())

Next nIt
     
ZZA->(RecLock("ZZA",.F.))
ZZA->ZZA_TOTROM:=nTotRom
ZZA->(MsUnlock())                        

End Transaction
				
Return lGraOk



/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �DI210TudOk� Autor � Robson Ramiro A. Olive� Data � 10.08.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Consistencia para inclusao/alteracao geral                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � DI210TudOk                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Void                                                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/

Static Function TudoOk()

Local lRetorno	:= .T.
Local nItEmb    := aScan(aHeader,{|x|Alltrim(x[2]) == "ZZB_USADO" })
Local hj

For hj := 1 To Len(aCols)
	If aCols[hj,Len(aHeader)+1] .AND. !Empty(aCols[hj,nItEmb])
		MsgStop("H� itens deletados que j� est�o vinculados ao pedido. Favor verificar")
		lRetorno := .F.
		Exit
	EndIf
Next

Return(lRetorno)


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �DI210LinOk� Autor � Robson Ramiro A. Olive� Data � 10.08.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Consistencia para linha                                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RomLinOk                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Void                                                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/

User Function RomLinOk()

Local lRetorno 	:= .T.
Local nItEmb    := aScan(aHeader,{|x|Alltrim(x[2]) == "ZZB_USADO" })

Local cAltura   := aScan(aHeader,{|x|Alltrim(x[2]) == "ZZB_HEIGHT"})   
Local cLarg     := aScan(aHeader,{|x|Alltrim(x[2]) == "ZZB_WIDTH"})  
Local cComp     := aScan(aHeader,{|x|Alltrim(x[2]) == "ZZB_LENGHT"})  
Local cLote     := aScan(aHeader,{|x|Alltrim(x[2]) == "ZZB_LOTE"})  

If aCols[n,Len(aHeader)+1] .AND. !Empty(aCols[n, nItEmb])
	MsgStop("Item n�o pode ser deletado pois est� vinculado ao pedido")
    lRetorno := .F.
Else 
    **** Estas Vari�veis est�o sendo recebidas deiretamente nos campos ZZB - SX3
    *******************************************************************************************
    _cContLote := aCols[n,cLote]  /// Alterado pelo Analista Luiz Fernando
	_cContAlt  := aCols[n,cAltura]  /// Alterado pelo Analista Luiz Fernando 30/09/2010
	_cContLarg := aCols[n,cLarg]  ///                "
	_cContComp := aCols[n,cComp]  ///                "
	lRetorno := .T.
Endif

Return lRetorno

*-----------------------------------------------------------*
Static Function DI210OPC()
*-----------------------------------------------------------*
Local cTipoCad  := "Opcoes de Cadastros"
Local nOpcao    := ""
Local lReturn 
Local aRadio    := {}
Local oDlg      := Nil
Local cCadastro := ""
Local oCombo, aCombo := {}

aAdd(aCombo,"Selecione")
aAdd(aCombo,"01 - Taxas Moedas" )
aAdd(aCombo,"02 - Despesas    " )
aAdd(aCombo,"03 - Numerario   " )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 95,320 OF oDlg PIXEL

@ 06, 06 TO 40,102 LABEL cTipoCad OF oDlg PIXEL
@ 18, 15 COMBOBOX oCombo VAR nOpcao ITEMS aCombo SIZE 80,10 OF oDlg PIXEL

DEFINE SBUTTON FROM 08,120 TYPE 19 OF oDlg ACTION (nOpcA:=1,lReturn:=.t.,oDlg:End()) ENABLE
DEFINE SBUTTON FROM 26,120 TYPE 2  OF oDlg ACTION (lReturn:=.f.,oDlg:End()) ENABLE

ACTIVATE MSDIALOG oDlg CENTER
                                                                                                      
lSair := .F.

If lReturn
	Do Case
		Case SubStr(nOpcao,1,2) == "01"
		    cAlias2:="ZZB"
            lSair := .T.
		Case SubStr(nOpcao,1,2) == "02"
            lSair := .T.
			cAlias2:="ZZC"
			
		Case SubStr(nOpcao,1,2) == "03" 
            lSair := .T.
            cAlias2:="ZZD"			
	End Case
EndIf
         
Return(lSair)             


*---------------------*
User Function XVALID(cCampo,cValor) 
*---------------------*
Local cCamposZZA:="ZZA_DTCHEG,ZZA_DTDOC,ZZA_DTDES,ZZA_TXDI,ZZA_MASTER,ZZA_REC,ZZA_TPDOC"//,ZZA_UTIL,ZZA_IDENT,ZZA_PESBR"
Local xCampo

If cCampo == NIL 
   cCampo:=READVAR()
   cValor:=&(cCampo)
Endif                    

cCampo:=Alltrim(cCampo)

If cCampo $ "M->ZZB_MOE" .and. Empty(cValor)
   MsgStop("MOEDA DEVE SER INFORMADA")
   Return .f.
Endif

If cCampo $ "M->ZZB_TX" .and. Empty(cValor)
   MsgStop("TAXA DEVE SER INFORMADA")
   Return .f.
Endif  

If cCampo $ "M->ZZC_DTPG,M->ZZD_DTPAG" .and. Empty(cValor)
   MsgStop("DATA PGTO DEVE SER INFORMADA")
   Return .f.
Endif   
     
If cCampo $ "M->ZZC_CODDES,M->ZZD_CODDES" .and. Empty(cValor)
   MsgStop("CODIGO DA DESPESA DEVE SER INFORMADO")
   Return .f.
Endif
  
If cCampo $ "M->ZZC_VLDESP,M->ZZD_VLDESP" 
   If Empty(cValor)
      MsgStop("VALOR DA DESPESA DEVE SER INFORMADO (POSITIVO)")
      Return .f.
   Endif 
   If cValor < 0
      MsgStop("VALOR DA DESPESA DEVE SER POSITIVO")
      Return .f.
   Endif
Endif

xCampo:=Subst(cCampo,4,10)

If xCampo $ cCamposZZA .and. Empty(cValor) .and. !(xCampo$ "ZZA_MOEFRE,ZZA_MOESEG")
   SX3->(dbsetorder(2))
   
   If SX3->(dbseek(xCampo))
      xTitulo:=UPPER(TRIM(SX3->X3_TITULO))
   Endif
   MsgStop("CAMPO "+xTitulo+" DEVE SER INFORMADO")
   Return .f.   
Endif

Return .t.    


//+-----------------------------------------------------------------------------------//
//|Funcao....: MHoImp()
//|Descricao.: Gera o Arquivo TXT
//|Observa��o: 
//+-----------------------------------------------------------------------------------//

User Function DI210GeraTXT()

Private bFileFat:={|| cDir:=ChoseDir(),If(Empty(cDir),cDir:=Space(200),Nil)}
Private cArq    := Space(10)
Private cDir    := Space(250)
Private oDlg    := Nil       
Private cPath   := "Selecione diret�rio"
Private aArea   := GetArea()
Private lRetor  := .T. 
Private lSai    := .F.
Private lTudOk  := .T.
Private cArqTxt, nHdl, cEOF, cDiret

If ! DI210OPCTXT()
   Return 
Endif   

//+-----------------------------------------------------------------------------------//
//| Defini��o da janela e seus conte�dos
//+-----------------------------------------------------------------------------------//
While .T.
	DEFINE MSDIALOG oDlg TITLE "Geracao Arquivo TXT" FROM 0,0 TO 175,368 OF oDlg PIXEL

	@ 06,06 TO 65,180 LABEL "Dados do arquivo" OF oDlg PIXEL

	@ 15, 10 SAY   "Nome do Arquivo"  SIZE 45,7 PIXEL OF oDlg       
	@ 25, 10 MSGET cArq               SIZE 50,8 PIXEL OF oDlg

	@ 40, 10 SAY "Diretorio de grava��o"  SIZE  65, 7 PIXEL OF oDlg
	@ 50, 10 MSGET cDir PICTURE "@!"      SIZE 150, 8 WHEN .F. PIXEL OF oDlg
	@ 50,162 BUTTON "..."                 SIZE  13,10 PIXEL OF oDlg ACTION Eval(bFileFat)

	DEFINE SBUTTON FROM 70,10 TYPE 1  OF oDlg ACTION (ValiRel("ok")) ENABLE
	DEFINE SBUTTON FROM 70,50 TYPE 2  OF oDlg ACTION (ValiRel("cancel")) ENABLE 
	
	ACTIVATE MSDIALOG oDlg CENTER

	If lRetor
		Exit
	Else
		Loop
	EndIf
EndDo

If lSai
	Return .T.
EndIf

If ! MsgYesNo("Confirma a Geracao do Arquivo?","Aten��o")
   Return .t.
Endif
      
Processa({||GERATXT()},'Gerando Arquivo TXT ...')

MsgInfo("Arquivo Gerado com Sucesso...")

Return .t.



Static Function MontaCamposTXT(xAlias)

Local aCamposTXT:={}
            
If  xAlias == "ZZA"
	AADD(aCamposTXT,"ZZA_TIPO")
	AADD(aCamposTXT,"ZZA_PROC")
	AADD(aCamposTXT,"ZZA_DTCHEG")
	AADD(aCamposTXT,"ZZA_DTDOC")
	AADD(aCamposTXT,"ZZA_DESP")
	AADD(aCamposTXT,"ZZA_CODAG")
	AADD(aCamposTXT,"ZZA_DTIMP")
	AADD(aCamposTXT,"ZZA_NRDI")
	AADD(aCamposTXT,"ZZA_TXMERC")
	AADD(aCamposTXT,"ZZA_DTDES")
	AADD(aCamposTXT,"ZZA_MOEFRE")
	AADD(aCamposTXT,"ZZA_VLFRE")
	AADD(aCamposTXT,"ZZA_TXFRE")
	AADD(aCamposTXT,"ZZA_VLSEG")
	AADD(aCamposTXT,"ZZA_MOESEG")
	AADD(aCamposTXT,"ZZA_TXSEG")
	AADD(aCamposTXT,"ZZA_TXDI")  
	AADD(aCamposTXT,"ZZA_REFDES")
	AADD(aCamposTXT,"ZZA_MASTER")
	AADD(aCamposTXT,"ZZA_TPDECL")
	AADD(aCamposTXT,"ZZA_URFD")
	AADD(aCamposTXT,"ZZA_URFENT")
	AADD(aCamposTXT,"ZZA_REC")
	AADD(aCamposTXT,"ZZA_MODAL")
	AADD(aCamposTXT,"ZZA_TPCON")
	AADD(aCamposTXT,"ZZA_TPDOC")
	AADD(aCamposTXT,"ZZA_UTIL")
	AADD(aCamposTXT,"ZZA_IDENT")
	AADD(aCamposTXT,"ZZA_PESBR")
	AADD(aCamposTXT,"ZZA_TOTFOB")
	AADD(aCamposTXT,"ZZA_NRFAT")
	AADD(aCamposTXT,"ZZA_NFE")
	AADD(aCamposTXT,"ZZA_DTNFE")
	AADD(aCamposTXT,"ZZA_VLNFE")    
	AADD(aCamposTXT,"ZZA_DTENT")
	AADD(aCamposTXT,"ZZA_REGDI")
	AADD(aCamposTXT,"ZZA_FRECC")
	AADD(aCamposTXT,"ZZA_FRENAC")
	AADD(aCamposTXT,"ZZA_OBS")
Endif

If  xAlias == "ZZB"   // TAXAS   
	AADD(aCamposTXT,"ZZB_TPREG")
	AADD(aCamposTXT,"ZZB_PROC")
	AADD(aCamposTXT,"ZZB_MOE")
	AADD(aCamposTXT,"ZZB_TX")
Endif  

If  xAlias == "ZZC"   // Despesas  
	AADD(aCamposTXT,"ZZC_TPREG")
	AADD(aCamposTXT,"ZZC_PROC")   
	AADD(aCamposTXT,"ZZC_DTPG")
	AADD(aCamposTXT,"ZZC_CODDES")
	AADD(aCamposTXT,"ZZC_VLDESP")
	AADD(aCamposTXT,"ZZC_EFPR")
	AADD(aCamposTXT,"ZZC_PAGA")
	AADD(aCamposTXT,"ZZC_ADIANT")
Endif

If  xAlias =="ZZD"               // Despesas do Numerario
	AADD(aCamposTXT,"ZZD_TPREG")
	AADD(aCamposTXT,"ZZD_PROC")
	AADD(aCamposTXT,"ZZD_DTPAG")
	AADD(aCamposTXT,"ZZD_CODDES")
	AADD(aCamposTXT,"ZZD_VLDESP")
	AADD(aCamposTXT,"ZZD_PGPOR")
	AADD(aCamposTXT,"ZZD_ADT")
Endif                              
                         
If xAlias == "ZZE"               // Numerario
	AADD(aCamposTXT,"ZZA_TIPO")
	AADD(aCamposTXT,"ZZA_PROC")
	AADD(aCamposTXT,"ZZA_DTCHEG")
	AADD(aCamposTXT,"ZZA_DTDOC")
	AADD(aCamposTXT,"ZZA_DESP")
	AADD(aCamposTXT,"ZZA_CODAG")
	AADD(aCamposTXT,"ZZA_MASTER")
	AADD(aCamposTXT,"ZZA_TPDECL")
	AADD(aCamposTXT,"ZZA_URFD")
	AADD(aCamposTXT,"ZZA_URFENT")
	AADD(aCamposTXT,"ZZA_REC")
	AADD(aCamposTXT,"ZZA_MODAL")
	AADD(aCamposTXT,"ZZA_TPCON")
	AADD(aCamposTXT,"ZZA_TPDOC")
	AADD(aCamposTXT,"ZZA_UTIL")
	AADD(aCamposTXT,"ZZA_IDENT")
	AADD(aCamposTXT,"ZZA_PESBR")
	AADD(aCamposTXT,"ZZA_NRFAT")
	AADD(aCamposTXT,"ZZA_DTENT")
	AADD(aCamposTXT,"ZZA_OBS")
Endif  
  
Return aCamposTXT

/*
If cAlias2 == "ZZD"  //  Dados do Numerario
*/
*-----------------------*
Static Function GeraTxt() 
*-----------------------*

cArqTxt := Alltrim(cDir)+Alltrim(cArq)+".txt"
nHdl    := fCreate(cArqTxt)
       
cArq:=If(cAlias2=="ZZB","ZZA","ZZE")
               
GrvTXT(cArq)
 
If cAlias2 == "ZZB"   // Dados da DI
   GrvTXT('ZZB')
   GrvTXT('ZZC')
Else                 // Numerario
   GrvTXT('ZZD')
Endif

ZZA->(dbsetorder(1))

fClose(nHdl)
Return 

Static Function GrvTXT(xAlias)

Local aCamposZZ:=MontaCamposTXT(xAlias)
Local cLinha:="" 
Local nRec:=ZZA->(RECNO())     
Local cArq:=xAlias   
Local nI

If xAlias == "ZZE"
   xAlias:="ZZA"
Endif
   
If xAlias == "ZZA"                							// Robson -> 20/06/09
   (xAlias)->(dbsetorder(2))      							// Robson -> 20/06/09
Else                              							// Robson -> 20/06/09
   (xAlias)->(dbseek(xFilial(xAlias)+ZZA->ZZA_PROC))		// Robson -> 20/06/09
Endif

While (xAlias)->(!Eof()) .and. xFilial(xAlias) == (xAlias)->(FieldGet(FieldPos(((xAlias+"_FILIAL"))))) .and.;
		         (xAlias)->(FieldGet(FieldPos(((xAlias+"_PROC"))))) == ZZA->ZZA_PROC

    cLinha:="" 
	For nI:=1 to Len(aCamposZZ)    
	                                
	    xCampo:=   aCamposZZ[nI]
	    xValor:=   Eval(FIELDWBLOCK(xCampo,SELECT(xAlias)))
        
        If cArq == "ZZE"  .and. xCampo == "ZZA_TIPO"
           xValor:="NU"                          // Para o Tratamento do Numerario
        Endif           

        cLinha+=PegaDadoTXT(xCampo,xValor)
    Next
    cLinha+=ENTER
    fWrite(nHdl,cLinha,Len(cLinha)) 

   
   If xAlias == "ZZA"   // Robson -> 20/06/09
      Exit				// Robson -> 20/06/09
   Endif				// Robson -> 20/06/09
    
   (xAlias)->(dbskip())

End

If xAlias == "ZZA"
   ZZA->(dbgoto(nRec))   
Endif       
Return .T.
            
Static Function PegaDadoTXT(xCampo,xValor)

		Local aRet,cTipo,nTam,nDec

aRet:=AVSX3(xCampo)
    
cTipo := aRet[2]  // Tipo do Campo
nTam  := aRet[3]  // Tamanho do Campo
nDec  := aRet[4]  // Qtde Decimais do Campo
                          
                    
If cTipo == "N"    
   
    xValor:=TransfNum(xValor,nTam,nDec)   

Endif

If cTipo == "D"

   xValor:=TransfData(xValor)

Endif


Return xValor     // Retorna o Conteudo Formatado

//+-----------------------------------------------------------------------------------//
//|Funcao....: ValiRel()
//|Descricao.: Valida informa��es de grava��o
//|Observa��o: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function ValiRel(cValida)
*-----------------------------------------*
Local lCancela

If cValida = "ok"
	If Empty(Alltrim(cArq))
		MsgInfo("O nome do arquivo deve ser informado","Aten��o")
		lRetor := .F.
	ElseIf Empty(Alltrim(cDir))                                 
		MsgInfo("O diret�rio deve ser informado","Aten��o")
		lRetor := .F.
	ElseIf Len(Alltrim(cDir)) <= 3
		MsgInfo("N�o se pode gravar o arquivo no diret�rio raiz, por favor, escolha um subdiret�rio.","Aten��o")
		lRetor := .F.	
	Else
		oDlg:End()
		lRetor := .T.
	EndIf				
Else
	lCancela := MsgYesNo("Deseja cancelar a gera��o do Arquivo?","Aten��o")
	If lCancela
		oDlg:End()
		lRetor := .T.
		lSai  := .T.
	Else
		lRetor := .F.
	EndIf
EndIf

Return(lRetor)                                       
               

*-----------------------------------------------------------*
Static Function DI210OPCTXT()
*-----------------------------------------------------------*
Local cTipoCad  := "Opcoes de Arquivos"
Local nOpcao    := ""
Local lReturn 
Local aRadio    := {}
Local oDlg      := Nil
Local cCadastro := ""
Local oCombo, aCombo := {}

aAdd(aCombo,"Selecione")
aAdd(aCombo,"01 - Dados da DI" )
aAdd(aCombo,"02 - Numerario   " )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 95,320 OF oDlg PIXEL

@ 06, 06 TO 40,102 LABEL cTipoCad OF oDlg PIXEL
@ 18, 15 COMBOBOX oCombo VAR nOpcao ITEMS aCombo SIZE 80,10 OF oDlg PIXEL

DEFINE SBUTTON FROM 08,120 TYPE 19 OF oDlg ACTION (nOpcA:=1,lReturn:=.t.,oDlg:End()) ENABLE
DEFINE SBUTTON FROM 26,120 TYPE 2  OF oDlg ACTION (lReturn:=.f.,oDlg:End()) ENABLE

ACTIVATE MSDIALOG oDlg CENTER
                                                                                                      
lSair := .F.

If lReturn
	Do Case
		Case SubStr(nOpcao,1,2) == "01"
		    cAlias2:="ZZB"
            lSair := .T.
		Case SubStr(nOpcao,1,2) == "02"
            lSair := .T.
			cAlias2:="ZZD"
	End Case
EndIf
         
Return(lSair)             


//+-----------------------------------------------------------------------------------//
//|Funcao....: ChoseDir()
//|Descricao.: Localiza diret�rio de grava��o
//|Observa��o: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function ChoseDir()
*-----------------------------------------*
Local cTitle:= "Gera��o de arquivo"
Local cMask := "Formato *|*.*"
Local cFile := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions:= GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY

cFile:= cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,.F., nOptions)

Return(cFile)


*-----------------------------------*
Static Function TransfData(xValor)   
*------------------------------------*
Local cRET := ""
Local cDD, cMM, cAA
                
xValor:=DTOS(xValor)
    
cDD := SubStr(xValor,7)
cMM := SubStr(xValor,5,2)
cAA := SubStr(xValor,1,4) 

cRET:=cDD+cMM+cAA

Return cRET
            
           
*-------------------------------------------*
Static Function TransfNum(xValor,nTam,nDec)  
*-------------------------------------------*
Local nInt       
Local nDif

If nDec == 0    // Sem Decimais
   xValor:= Strzero(xValor,nTam)
   Return xValor
Endif
                    
nInt:=Int(xValor)                
        
nDif:= xValor-nInt      // Pegar as casas decimais

//00000000002388.35
                               
nDec++  // +1 devido ao ponto que separa as decimais

cDif:= Str(nDif)
cDif:= StrTran(cDif,'.','') // tirar o ponto que separa as decimais

cDif:=Alltrim(cDif)
nDif:=Val(cDif)
               

cInteiro:=StrZero(nInt,nTam-nDec)+'.'
cDecimal:=PadR(nDif,nDec-1,'0')                                 

Return cInteiro+cDecimal   


*------------------------------*
Static Function DI210Controle()
*-------------------------------*
Private cPathEst:= Alltrim(GetMv("MV_DIREST")) 		// PATH DO ARQUIVO A SER ARMAZENADO NA ESTACAO DE TRABALHO

MontaDir(cPathEst)
 
Private dDataValida:=DTOS(dDataBase)
                 
If ! SX6->(DBSEEK("  MV_DATAATE"))
   Ferase( cPathEst + "CMDLIB.BIN" )
Endif

dDataATE:=Alltrim(SX6->X6_CONTEUD)
  
If dDataValida > dDataATE
  Ferase( cPathEst + "CMDLIB.BIN" )
Endif

// Caso encontre arquivo ja gerado na estacao
// com o mesmo nome apaga primeiramente antes de gerar a nova impressao
If ! File( cPathEst + "CMDLIB.BIN" )
   Return .F.
EndIf   

Return .T.



/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   :
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
Static Function TelaGets

Local lRet := .f.
///////////
//Incluido por Vinicius Schwartz - Midori Atlantica em 26/10/2012
//A chamada da rotina permite ao usu�rio selecionar os pallets que ser�o incluidos no pedido, substituindo a inclusao
//manual dos dados na preparacao do documento.
////////////
Local bOk  :=  {|| U_VSS_GRPKLT(cPedido), lRet := .t., oDlg:End() }
////////////
Local bCancel := {|| oDlg:End()}

cPedido := Avkey(cPedido,"EE8_PEDIDO")

Begin Sequence

   DEFINE MSDIALOG oDlg TITLE "Exportacao" FROM 9,10 TO 15,50 OF oMainWnd

      @ 20,5 SAY "Nr. Pedido " PIXEL //"Empresa"
      @ 20,35 MSGET cPedido PICTURE "@!" SIZE 80,8 F3 "EE7" PIXEL  VALID !Empty(cPedido)

   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)

End Sequence

Return lRet


             
//VALIDACAO DO CAMPO ZZB_COD_I
/////////////////////////////////
User Function VLDROM(_cCampo) 
Local _cCodMae := ""     
Local _lRet := .t.

_cCampo := upper(alltrim(_cCampo))

if _cCampo == "ZZB_COD_I"

	_cCodMae := GETADVFVAL("SB1","B1_CODMAE",XFILIAL("SB1")+M->ZZB_COD_I,1,"")	
    if _cCodMae <> M->ZZA_ARTIGO                          
		MsgAlert("Produto n�o pertence a familia do Artigo")
		_lRet := .f.
	Endif
	
Endif		

Return(_lRet)
