#INCLUDE "PROTHEUS.CH"

#define STR0001 "Relacao Das Ordens de Producao"
		#define STR0002 "Este programa ira imprimir a Rela��o das Ordens de Produ��o."
 		#define STR0003 "Por O.P.       "
		#define STR0004 "Por Produto    "
		#define STR0005 "Por C. de Custo"
		#define STR0006 "Zebrado"
		#define STR0007 "Administracao"
		#define STR0008 " - Por O.P."
		#define STR0009 " - Por Produto"
		#define STR0010 " - Por Centro de Custo"
		#define STR0011 "NUMERO        P R O D U T O                                      OBSERV       CENTRO    EMISSAO      ENTREGA       QUANTIDADE          SALDO A      ST TP          QTDE M�	  QTDE KG"
		#define STR0012 "                                                                            DE CUSTO                    REAL         ORIGINAL         ENTREGAR"
		#define STR0013 "CANCELADO PELO OPERADOR"
		#define STR0014 "Total ---->"
		#define STR0015 "NUMERO        P R O D U T O                     OBSERV                         CENTRO    EMISSAO      ENTREGA     ENTREGA       QUANTIDADE          SALDO A     "
		#define STR0016 "NUMERO        P R O D U T O                     OBSERV       CENTRO  EMISSAO      ENTREGA     QUANTIDADE        SALDO A ST TP         QTD M�	   QTDE KG"
		#define STR0017  "                                                           DE CUSTO                  REAL       ORIGINAL       ENTREGAR"
		#define STR0018  "NUMERO        P R O D U T O                     OBSERV       CENTRO  EMISSAO  ENTREGA  ENTREGA     QUANTIDADE        SALDO A      "
		#define STR0019  "NUMERO"
		#define STR0020  "PRODUTO"
		#define STR0021  "DESCRI��O"
		#define STR0022  "CENTRO CUSTO"
		#define STR0023  "EMISS�O"
		#define STR0024  "DT.PREVISTA"
		#define STR0025  "DT. REAL"
		#define STR0026  "QUANT. ORIGINAL"
		#define STR0027  "SALDO A ENTREGAR"
		#define STR0028  "STATUS"
		#define STR0029  "TIPO"
		#define STR0030  "Ordens de Produ��o"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR850R3� Autor � Paulo Boschetti       � Data � 13.08.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relacao Das Ordens de Producao                              ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR850(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Edson   M.  �19/01/98�XXXXXX� Inclusao do Campo C2_SLDOP.              ���
���Edson   M.  �02/02/98�XXXXXX� Subst. do Campo C2_SLDOP p/ Funcao.      ���
���Rodrigo Sart�24/03/98�08929A� Inclusao da Coluna Termino Real da OP.   ���
���Rodrigo Sart�05/10/98�15995A� Acerto na filtragem das filiais          ���
���Rodrigo Sart�03/11/98�XXXXXX� Acerto p/ Bug Ano 2000                   ���
���Fernando J. �07/02/99�META  �Imprimir OP's Firmes, Previstas ou Ambas. ���
���Cesar       �31/03/99�XXXXXX�Manutencao na SetPrint()                  ���
���Anesio G.Far�05/07/10�XXXXXX�Inclsusao campo C2_Obs  (especif.Midori)  ���
���ViniciusS.S.�20/04/12�XXXXXX�Inclsusao campo C2_X_KG (especif.Midori)  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function OPsMDPNP1()
Local titulo 	:= STR0001 								//"Relacao Das Ordens de Producao"
Local cString	:= "SC2"
Local wnrel		:= "OPsMDPNP1"
Local cDesc		:= STR0002								//"Este programa ira imprimir a Rela��o das Ordens de Produ��o."
Local aOrd    	:= {STR0003,STR0004,STR0005}			//"Por O.P.       "###"Por Produto    "###"Por Centro de Custo"
Local tamanho	:= "G"
Local lRet      := .T.
Private aReturn := {STR0006,1,STR0007, 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
Private cPerg   := "MTR850"
Private nLastKey:= 0

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte("MTR850",.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        	// Da OP                                 �
//� mv_par02        	// Ate a OP                              �
//� mv_par03        	// Do Produto                            �
//� mv_par04        	// Ate o Produto                         �
//� mv_par05        	// Do Centro de Custo                    �
//� mv_par06        	// Ate o Centro de Custo                 �
//� mv_par07        	// Da data                               �
//� mv_par08        	// Ate a data                            �
//� mv_par09        	// 1-EM ABERTO 2-ENCERRADAS  3-TODAS     �
//� mv_par10        	// 1-SACRAMENTADAS 2-SUSPENSA 3-TODAS    �
//� mv_par11            // Impr. OP's Firmes, Previstas ou Ambas �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd,,Tamanho)

If aReturn[4] == 1
	Tamanho := "M"
EndIf
If nLastKey == 27
	Set Filter To
	lRet := .F.
EndIf

If lRet
	SetDefault(aReturn,cString)
EndIf

If lRet .And. nLastKey == 27
	Set Filter To
	lRet := .F.
EndIf

If lRet
	RptStatus({|lEnd| R850Imp(@lEnd,wnRel,titulo,tamanho)},titulo)
EndIf
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R850Imp  � Autor � Waldemiro L. Lustosa  � Data � 13.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relat�rio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR850			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R850Imp(lEnd,wnRel,titulo,tamanho)

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local CbTxt
Local CbCont,cabec1,cabec2
Local limite   := If(aReturn[4] == 1,132,180)
Local nomeprog := "OPSMDPNP1"
Local nTipo    := 0
Local cProduto := Space(Len(SC2->C2_PRODUTO))
Local cStatus,nOrdem,cSeek
Local cTotal   := "",nTotOri:= 0,nTotSaldo:=0 // Totalizar qdo ordem for por produto
Local cQuery   := "",cIndex := CriaTrab("",.F.),nIndex:=0
Local lQuery   := .F.
Local aStruSC2 := {}
Local cAliasSC2:= "SC2"
Local cTPOP    := ""
Local lTipo    := .F.
#IFDEF TOP
	Local nX 
	Local lAS400	 := TcSrvType() == "AS/400"
#ENDIF

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt  := Space(10)
cbcont := 0
li     := 80
m_pag  := 1

nTipo  := IIf(aReturn[4]==1,15,18)
nOrdem := aReturn[8]
lTipo  := IIf(aReturn[4]==1,.T.,.F.)

//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������
titulo += IIf(nOrdem==1,STR0008,IIf(nOrdem==2,STR0009,STR0010))	//" - Por O.P."###" - Por Produto"###" - Por Centro de Custo"
cabec1 := If(!__lPyme, IIf(lTipo,STR0016,STR0011), IIf(lTipo,STR0018,STR0015))//"NUMERO         P R O D U T O                                                  CENTRO    EMISSAO      ENTREGA     ENTREGA       QUANTIDADE          SALDO A      ST TP"
cabec2 := IIf(lTipo,STR0017,STR0012)	//"                                                                            DE CUSTO                PREVISTA        REAL         ORIGINAL         ENTREGAR"
//					   1234567890123  123456789012345  1234567890123456789012345678901234567890  1234567890  1234567890  1234567890  1234567890  123456789012345  123456789012345       1  1
//                               1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17
//                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
// 1a Linha Posicoes:000/015/032/074/086/098/110/122/139/161/164

dbSelectArea("SC2")
dbSetOrder( nOrdem )

//��������������������������������������������������������������Ŀ
//� Inicializa variavel para controle do filtro                  �
//����������������������������������������������������������������
#IFDEF TOP 
	If !lAS400 ///SE NAO FOR AS/400
		If mv_par10 == 1
			cStatus := "'S'"
		ElseIf mv_par10 == 2
			cStatus := "'U'"
		ElseIf mv_par10 == 3
			cStatus := "'S','U','D','N',' '"
		EndIf
		If mv_par11 == 1
			cTPOP := "'F'"
		ElseIf mv_par11 == 2
			cTPOP := "'P'"
		ElseIf mv_par11 == 3
			cTPOP := "'F','P'"
		EndIf	
		lQuery 	  := .T.
		aStruSC2  := SC2->(dbStruct())
		cAliasSC2 := "R850IMP"
		cQuery    := "SELECT SC2.C2_FILIAL,SC2.C2_PRODUTO,SC2.C2_NUM,SC2.C2_ITEM,SC2.C2_SEQUEN,SC2.C2_ITEMGRD, "
		cQuery    += "SC2.C2_DATRF,SC2.C2_CC,SC2.C2_EMISSAO,SC2.C2_DATPRF,SC2.C2_QUANT,SC2.C2_QUJE,SC2.C2_PERDA, "
		cQuery    += "SC2.C2_STATUS,SC2.C2_TPOP, SC2.C2_OBS, SC2.C2_QTDM2, SC2.C2_X_KG,"
		cQuery    += "SC2.R_E_C_N_O_ SC2RECNO "
		cQuery    += "FROM "
		cQuery    += RetSqlName("SC2")+" SC2 "
		cQuery    += "WHERE "
		cQuery    += "SC2.C2_FILIAL = '"+xFilial("SC2")+"' AND "
	
		//��������������������������������������������������������������Ŀ
		//� Condicao para filtrar OP's                           		 �
		//����������������������������������������������������������������
		cQuery 	  += "SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN||SC2.C2_ITEMGRD >= '"+mv_par01+"' AND "
		cQuery 	  += "SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN||SC2.C2_ITEMGRD <= '"+mv_par02+"' AND "
	
		cQuery    += "SC2.C2_PRODUTO >= '"+mv_par03+"' And SC2.C2_PRODUTO <= '"+mv_par04+"' And "
		cQuery    += "SC2.C2_CC  >= '"+mv_par05+"' And SC2.C2_CC  <= '"+mv_par06+"' And "
		cQuery    += "SC2.C2_EMISSAO  >= '"+DtoS(mv_par07)+"' And SC2.C2_EMISSAO  <= '"+DtoS(mv_par08)+"' And "
		cQuery    += "SC2.C2_STATUS IN ("+cStatus+") And "
		cQuery    += "SC2.C2_TPOP IN ("+cTPOP+") And "
		cQuery    += "SC2.D_E_L_E_T_ = ' ' "
	
		cQuery    += "ORDER BY "+SqlOrder(SC2->(IndexKey()))
	
		cQuery    := ChangeQuery(cQuery)
	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC2,.T.,.T.)
	
		For nX := 1 To Len(aStruSC2)
			If ( aStruSC2[nX][2] <> "C" ) .And. FieldPos(aStruSC2[nX][1]) > 0
				TcSetField(cAliasSC2,aStruSC2[nX][1],aStruSC2[nX][2],aStruSC2[nX][3],aStruSC2[nX][4])
			EndIf
		Next nX
	Else
#ENDIF 
	If mv_par10 == 1
		cStatus := "S"
	ElseIf mv_par10 == 2
		cStatus := "U"
	ElseIf mv_par10 == 3
		cStatus := "SUDN "
	EndIf	
	cQuery 	:= "C2_FILIAL=='"+xFilial("SC2")+"'"
	cQuery  += ".And. C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD >= '"+mv_par01+"' "
	cQuery  += ".And. C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD <= '"+mv_par02+"' "	
	cQuery  += ".And.C2_PRODUTO>='"+mv_par03+"'.And.C2_PRODUTO<='"+mv_par04+"'"
	cQuery  += ".And.C2_STATUS$'"+cStatus+"'
	cQuery  += ".And.C2_CC>='"+mv_par05+"'.And.C2_CC<='"+mv_par06+"'"
	cQuery  += ".And.DtoS(C2_EMISSAO)>='"+DtoS(mv_par07)+"'.And.DtoS(C2_EMISSAO)<='"+DtoS(mv_par08)+"'"
	dbSelectArea("SC2")
	dbSetOrder(1)
	dbSetFilter({|| &cQuery},cQuery)
	cAliasSC2 := "SC2"
#IFDEF TOP
	EndIF
#ENDIF

SetRegua(RecCount())		// Total de Elementos da regua
dbGoTop()
While !Eof()
	IncRegua()
	If lEnd
		@ Prow()+1,001 PSay STR0013	//	"CANCELADO PELO OPERADOR"
		Exit
	EndIf

	If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD < xFilial('SC2')+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD > xFilial('SC2')+mv_par02
		dbSkip()
		Loop
	EndIf

	If mv_par09 == 1  // O.P.s EM ABERTO
		If !Empty(C2_DATRF)
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par09 == 2 //O.P.S ENCERRADAS
		If Empty(C2_DATRF)
			dbSkip()
			Loop
		EndIf
	EndIf

	//-- Valida se a OP deve ser Impressa ou n�o
	#IFDEF TOP
		If	! Empty(aReturn[7])
			SC2->(MsGoTo((cAliasSC2)->SC2RECNO))
			If SC2->( ! &(aReturn[7]) )
				(cAliasSC2)->(DbSkip())
				Loop
			EndIf
		EndIf			
	#ELSE
		If !MtrAValOP(mv_par11, 'SC2')
			dbSkip()
			Loop
		EndIf
		//�������������������Ŀ
		//� Filtro do Usuario �
		//���������������������
		If !Empty(aReturn[7])
			If !&(aReturn[7])
				dbSkip()
				Loop
			EndIf
		EndIf
	#ENDIF	


	//��������������������������������������������������������������Ŀ
	//� Termina filtragem e grava variavel p/ totalizacao            �
	//����������������������������������������������������������������
	cTotal  := IIf(nOrdem==2,xFilial("SC2")+C2_PRODUTO,xFilial("SC2"))
	nTotOri := nTotSaldo:=0
	Do While !Eof() .And. cTotal == IIf(nOrdem==2,C2_FILIAL+C2_PRODUTO,C2_FILIAL)
		IncRegua()

		If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD < xFilial('SC2')+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD > xFilial('SC2')+mv_par02
			dbSkip()
			Loop
		EndIf

		If mv_par09 == 1  // O.P.s EM ABERTO
			If !Empty(C2_DATRF)
				dbSkip()
				Loop
			EndIf
		Elseif mv_par09 == 2 //O.P.S ENCERRADAS
			If Empty(C2_DATRF)
				dbSkip()
				Loop
			EndIf
		EndIf

		//-- Valida se a OP deve ser Impressa ou n�o
		#IFDEF TOP
			If	! Empty(aReturn[7])
				SC2->(MsGoTo((cAliasSC2)->SC2RECNO))
				If SC2->( ! &(aReturn[7]) )
					(cAliasSC2)->(DbSkip())
					Loop
				EndIf
			EndIf
		#ELSE
			If !MtrAValOP(mv_par11, 'SC2')
				dbSkip()
				Loop
			EndIf
			//�������������������Ŀ
			//� Filtro do Usuario �
			//���������������������
			If !Empty(aReturn[7])
				If !&(aReturn[7])
					dbSkip()
					Loop
				EndIf
			EndIf
		#ENDIF


		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+(cAliasSC2)->C2_PRODUTO))

		If li > 58
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIf

		// 1a Linha Posicoes:000/012/020/062/072/084/097/109/123/140
		@Li ,000 PSay C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
		@Li ,012 PSay Substr(C2_PRODUTO,1,6)
		If lTipo
			@Li ,020 PSay SubStr(SB1->B1_DESC,1,25)
			@Li ,047 PSay SubStr(C2_OBS,1,9)
			@Li ,060 PSay C2_CC
			@Li ,068 PSay C2_EMISSAO
//			@Li ,077 PSay C2_DATPRF
			@Li ,077 PSay C2_DATRF
			@Li ,087 PSay C2_QUANT Picture PesqPictQt("C2_QUANT",15)
			@Li ,101 PSay IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0) Picture PesqPictQt("C2_QUANT",15)
//			@Li ,110 PSay IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0) Picture PesqPictQt("C2_QUANT",15)
		Else
			@Li ,020 PSay SubStr(SB1->B1_DESC,1,40)
			@Li ,062 PSay SubStr(C2_OBS,1,9)
			@Li ,074 PSay C2_CC
			@Li ,086 PSay C2_EMISSAO
//			@Li ,099 PSay C2_DATPRF
			@Li ,099 PSay C2_DATRF
			@Li ,111 PSay C2_QUANT Picture PesqPictQt("C2_QUANT",15)
			@Li ,129 PSay IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0) Picture PesqPictQt("C2_QUANT",15)
//			@Li ,140 PSay IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0) Picture PesqPictQt("C2_QUANT",15)
		EndIf
		If ! __lPyme
			IF lTipo
				@Li ,126 PSay C2_STATUS
				@Li ,129 PSay C2_TPOP
			Else
				@Li ,147 PSay C2_STATUS
				@Li ,150 PSay C2_TPOP
			EndIf
		EndIf
			@Li , 154 Psay C2_QTDM2 Picture PesqPictQt("C2_QTDM2",14)
			@Li , 170 Psay C2_X_KG Picture PesqPictQt("C2_X_KG",14)			
		Li++
		If nOrdem # 2 .And. !lTipo
			@Li ,  0 PSay __PrtThinLine()
			Li++
		Else
			nTotOri	 += C2_QUANT
			nTotSaldo+= IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0)
		EndIf
		dbSkip()
	EndDo
	If nOrdem == 2
		Li++
		@Li ,000 PSay STR0014	//"Total ---->"
		@Li ,015 PSay Substr(cTotal,3)
		If lTipo
			@Li ,089 PSay nTotOri	Picture PesqPictQt("C2_QUANT",15)
			@Li ,103 PSay nTotSaldo	Picture PesqPictQt("C2_QUANT",15)
			Li++
			@Li ,  0 PSay __PrtThinLine()
		Else
			@Li ,113 PSay nTotOri	Picture PesqPictQt("C2_QUANT",15)
			@Li ,131 PSay nTotSaldo	Picture PesqPictQt("C2_QUANT",15)
			Li++
			@Li ,  0 PSay __PrtThinLine()
		EndIf
		Li++
	EndIf
EndDo

#IFDEF TOP
	If lAS400
		SC2->(dbClearFilter())
	EndIf
#ELSE
	SC2->(dbClearFilter())
#ENDIF

If Li != 80
	Roda(cbcont,cbtxt)
EndIf

If lQuery
	dbSelectArea(cAliasSC2)
	dbCloseArea()
EndIf

dbSelectArea("SC2")
Set Filter To
dbSetOrder(1)

If File(cIndex+OrdBagExt())
	Ferase(cIndex+OrdBagExt())
EndIf

If aReturn[5] == 1
	Set Printer To
	OurSpool(wnrel)
EndIf

MS_FLUSH()
Return NIL