#INCLUDE "PROTHEUS.CH"

#define STR0001  "Um momento por favor..."
#define STR0002  "Recalculo dos Saldos do Caixinha"
#define STR0003  "Este programa recalcula os saldos dos Caixinhas"
#define STR0004  "em aberto, considerando os comprovantes de reembolso"
#define STR0005  "e de adiantamento."
#define STR0006  "Executando o recalculo dos Saldos dos Caixinhas..."
#define STR0007  "Par�metros"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FINA570  � Autor � Leonardo Ruben        � Data � 19.06.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Recalculo dos Saldos dos Caixinhas                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � Void FINA570(void)                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Localizacoes                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//Alterado por Anesio - Fun��o do microsiga n�o funciona desde 31-05-2010 - CHAMADO SCRHBQ

user Function mFINA570

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������

Local cKey, cCondicao, nIndex
Local aArea := GetArea()
Private cIndice, cIndex

//������������������������������������������������������������Ŀ
//� Parametros do Grupo FIA570 no SX1                          �
//� De Caixinha          mv_par01                              �
//� A Caixinha           mv_par02                              �
//��������������������������������������������������������������
//������������������������������������������������������������Ŀ
//� Carrega funcao Pergunte									   �
//��������������������������������������������������������������
SetKey (VK_F12,{|a,b| AcessaPerg("FIA570",.T.)})

If !Pergunte("FIA570",.T.)
	Set Key VK_F12 To
	Return
Endif

//�������������������������������������������������������Ŀ
//� Cria indice condicianal                               �
//���������������������������������������������������������
cCondicao := 'ET_FILIAL=="'+xFilial("SET")+'"'
cCondicao := cCondicao + '.AND.ET_CODIGO>="'+mv_par01+'".AND.ET_CODIGO<="'+mv_par02+'"'
cIndex  := CriaTrab(Nil,.F.)
cKey    := "ET_FILIAL+ET_CODIGO"
IndRegua("SET",cIndex,cKey,,cCondicao,OemToAnsi(STR0001))  //"Un Momento por favor..."
nIndex  := RetIndex("SET")
dbSelectArea("SET")
#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)
dbGoTop()

//�������������������������������������������������������Ŀ
//� Monta tela para chamada da funcao de processamento    �
//���������������������������������������������������������
nOpca:=2
DEFINE MSDIALOG oDlg FROM  96,9 TO 310,392 TITLE OemToAnsi(STR0002) PIXEL	 //"Rec�lculo dos Saldos dos Caixinhas"
@ 18, 6 TO 66, 187 LABEL "" OF oDlg  PIXEL
@ 29, 15 SAY OemToAnsi(STR0003) SIZE 168, 8 OF oDlg PIXEL					 //"Este programa recalcula os saldos dos Caixinhas"
@ 38, 15 SAY OemToAnsi(STR0004) SIZE 168, 8 OF oDlg PIXEL					 //"em aberto, considerando os comprovantes de reembolso"
@ 48, 15 SAY OemToAnsi(STR0005) SIZE 168, 8 OF oDlg PIXEL	                 //"e de adiantamento."
DEFINE SBUTTON FROM 80, 093 TYPE 5 ACTION Pergunte("FIA570",.T.) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 123 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 153 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED
If nOpca == 1
	Processa({|lEnd| mFA570Process(@lEnd)},STR0002,STR0006,.F.) 		//"Rec�lculo dos Saldos dos Caixinhas"###"Efetuando Rec�lculo dos Saldos dos Caixinhas..."
EndIf

dbSelectArea("SET")
dbClearFil()
RetIndex("SET")
#IFNDEF TOP
	FErase(cIndex+OrdBagExt())
#ENDIF

RestArea(aArea)

Set Key VK_F12 To

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FA570Process� Autor � Leonardo Ruben        � Data �19/06/00���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processa o recalculo dos saldos dos caixinhas              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINA570                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function mFA570Process(lEnd)
Local aArea := GetArea()
Local nSaldo := 0

dbSelectArea("SET")
While !Eof()  // varre o filtro
	nSaldo := U_mFa570AtuSld(ET_CODIGO)
	dbSelectArea("SET")
	RecLock("SET",.F.)    
	REPLACE ET_SALDO WITH nSaldo
	MsUnlock()
	dbSkip()
EndDo

RestArea(aArea)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Fa570Comp  � Autor � Leonardo Ruben        � Data �19/06/00���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o valor total dos comprovantes de um caixinha      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINA570                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//user Function mFa570Comp(cCaixa)
user function nRecal(cCaixa)
Local nTotComp 	:= 0, nTotRep := 0
Local cSeqCxa
Local lF570Cal 	:=	ExistBlock("F570CAL")                  
Local nSalAnt	:= 0
Local lRepCxV	:= (GetNewPar("MV_RPCXMN","2")== "1" ).And. SET->(FieldPos('ET_SALANT')) > 0   // Verifica se trabalha com reposicao variavel
//�������������������������������������������������������Ŀ
//�Posiciona-se no caixinha                               �
//���������������������������������������������������������
dbSelectArea("SET")
dbSetOrder(1)
dbSeek( xFilial()+cCaixa)
nSalAnt:= Iif(lRepCxV,SET->ET_SALANT,0)
//�������������������������������������������������������Ŀ
//�Retorna a sequencia atual do caixinha                  �
//���������������������������������������������������������
cSeqCxa := Fa570SeqAtu( cCaixa)

dbSelectArea("SEU")
dbSetOrder(5)  // filial + caixa + sequencia + num
dbSeek( xFilial()+ cCaixa + cSeqCxa)
While !Eof() .And. xFilial()+cCaixa+cSeqCxa == EU_FILIAL+EU_CAIXA+EU_SEQCXA
	
	If EU_TIPO == "10"
		//��������������������������������������������������Ŀ
		//�Reposicao incial da ultima sequencia (abertura)   �
		//����������������������������������������������������
		If lRepCxV
			nTotRep:= SEU->EU_VALOR
		Else
			nTotRep := SET->ET_VALOR  //(a sequencia comeca sempre com o valor total do caixinha)
		EndIf 
		
		dbSkip()
		Loop
	ElseIf EU_TIPO == "11"
		//��������������������������������������������������Ŀ
		//�fechou-se a sequencia (caixa fechado, pois esta   �
		//�eh a ultimia sequencia). Saldo zero.              �
		//����������������������������������������������������
		nTotRep  := 0      
		nTotComp := 0
		Exit
	ElseIf EU_TIPO == "00" .AND. !Empty(EU_NROADIA)
		//�������������������������������������������������������Ŀ
		//�Se o tipo for despesa e representar prestacao de contas�
		//�de adiantamento, devo ignorar pois neste caso somente  �
		//�os movimentos do tipo 01(Adiantamento)  e 02(devolucao �
		//�de adiantamento devem ser considerados.                �
		//���������������������������������������������������������
		dbSkip()
		Loop
	ElseIf EU_TIPO == "02"
		//�������������������������������������������������������Ŀ
		//�Se o tipo for devolucao de adiantamento, o mesmo foi   �
		//�rendido/baixado, logo considero o quanto foi devolvido �
		//�como reposicao para o caixinha. Desconto do total de   �
		//�comprovantes (pois considerei o adiantamento inicial)  �
		//���������������������������������������������������������
		nTotComp -= EU_VALOR
		dbSkip()
		Loop
	ElseIf EU_TIPO>="90"
		//�������������������������������������������������������Ŀ
		//�Reposicoes canceladas, aguardando autorizacao, cheques �
		//�aguardando compensacao etc.                            �
		//���������������������������������������������������������
		dbSkip()
		Loop
	Endif
	
	//�������������������������������������������������������Ŀ
	//�Aqui estao sendo somados   :                           �
	//�- Gastos/despesas em aberto (tipo 00)                  �
	//�- Adiantamentos fechados/rendidos (tipo 01)            �
	//���������������������������������������������������������
	nTotComp += EU_VALOR 
	
	//Ponto de entrada F570CAL
	//Ponto de entrada utilizado para tratamentos diferenciados do calculo
	//do saldo do caixinha
	If lF570Cal                                      
    	
		nTotComp := ExecBlock("F570CAL",.F.,.F.,{nTotComp})
	Endif

	dbSkip()
EndDo
Return ((nSalAnt+nTotRep)-nTotComp)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Fa570SeqAtu� Autor � Leonardo Ruben        � Data �03/07/01���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna a sequencia atual do caixinha                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAFIN                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user Function mFa570SeqAtu( cCaixa)
Local cSeqAtu := ""
Local cFilSEU := ""

//��������������������������������������������������������������Ŀ
//� Posiciona-se no ultimo registro da ultima sequencia          �
//����������������������������������������������������������������
dbSelectArea("SEU")
dbSetOrder(5)  // FILIAL+CAIXA+SEQCXA+NUMERO
DbSeek(xFilial()+cCaixa+"999999",.T.)
If !Found()
	dbSkip(-1)
EndIf                        
If Bof() .or. cCaixa <> EU_CAIXA  // nao ha registros para esse caixinha
	cSeqAtu := "000001"
Else
	If ExistBlock("FA550VERIF",.T.) .And. Fa550Verif()
		cFilSEU:=xFilial("SEU")
		While SEU->EU_TIPO>="90" .And. SEU->EU_FILIAL==cFilSEU .And. SEU->EU_CAIXA==cCaixa .And. !SEU->(Bof())
			SEU->(DbSkip(-1))
		Enddo
	Endif
	cSeqAtu := EU_SEQCXA
EndIf

Return cSeqAtu

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Fa570AtuSld� Autor � Leonardo Ruben        � Data �19/06/00���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o valor do saldo do caixinha                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINA570                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user Function mFa570AtuSld(cCaixa) ////Alterado por Anesio - Fun��o do microsiga n�o funciona desde 31-05-2010 - CHAMADO SCRHBQ
Local nSaldo
Local aArea := GetArea()

nSaldo := U_nRecal(cCaixa)  //Alterado por Anesio - Fun��o do microsiga n�o funciona desde 31-05-2010 - CHAMADO SCRHBQ

RestArea(aArea)
Return nSaldo

