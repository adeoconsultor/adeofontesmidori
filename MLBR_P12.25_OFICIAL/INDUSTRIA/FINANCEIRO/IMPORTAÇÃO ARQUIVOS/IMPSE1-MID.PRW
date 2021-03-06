#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � IMPSE1   � Autor � Paulo R. Trivellato� Data �  28/06/2009 ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 10                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function IMPSE1

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg       := "SE1111"
Private oLeTxt

Private cString := "SE1"

dbSelectArea("SE1")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say " SE1                                                           "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oLeTxt Centered

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � AP6 IDE            � Data �  28/06/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function OkLeTxt

//���������������������������������������������������������������������Ŀ
//� Abertura do arquivo texto                                           �
//�����������������������������������������������������������������������

Private cArqTxt := "C:\TOTVS\ARQUIVO.TXT"
Private nHdl    := fOpen(cArqTxt,68)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
	Return
Endif

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

Processa({|| RunCont() },"Processando...")

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  28/06/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunCont

Local nTamFile, nTamLin, cBuffer, nBtLidos
Local aVetor := {}
Local _cCGCCli := ""
Local _cCodCli := Space(6)
Local _cLojCli := Space(2)

//�����������������������������������������������������������������ͻ
//� Lay-Out do arquivo Texto gerado:                                �
//�����������������������������������������������������������������͹
//�Campo           � Inicio � Tamanho                               �
//�����������������������������������������������������������������Ķ
//� E1_FILIAL      � 01     � 02                                    �
//� E1_PREFIXO     � 03     � 03                                    �
//� E1_NUM	       � 06     � 09                                    �
//� E1_PARC        � 15     � 02                                    �
//� E1_TIPO        � 17     � 03                                    �
//� E1_CLIENTE     � 20     � 06                                    �
//� E1_LOJA        � 26     � 02                                    �
//� E1_VALOR       � 28     � 17                                    �
//� E1_EMISSAO     � 45     � 08                                    �
//� E1_VENCTO      � 53     � 08                                    �
//� E1_VENCREA     � 61     � 08                                    �
//� E1_SALDO       � 69     � 17                                    �
//�����������������������������������������������������������������ͼ

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 441+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua(nTamFile) // Numero de registros a processar

While nBtLidos >= nTamLin
	
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������
	
	IncProc()
	
	//���������������������������������������������������������������������Ŀ
	//� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	//�����������������������������������������������������������������������
	//	dbSelectArea(cString)
	//	RecLock(cString,.T.)

	//_cEmissao := STOD(Substr(cBuffer,69,04)+Substr(cBuffer,67,02)+Substr(cBuffer,65,02))
	//_cVencto  := STOD(Substr(cBuffer,77,04)+Substr(cBuffer,75,02)+Substr(cBuffer,73,02))
	//_cVencRea := STOD(Substr(cBuffer,85,04)+Substr(cBuffer,83,02)+Substr(cBuffer,81,02))

	_cCGCCli := Substr(cBuffer,428,14)
	dbSelectArea("SA1")
	dbSetOrder(3)
	If dbSeek(xFilial("SA1") + _cCGCCli )
		_cCodCli := SA1->A1_COD
		_cLojCli := SA1->A1_LOJA
	Else
		_cCodCli := "999999"
		_cLojCli := "01"
	EndIf

	aVetor:= {{"E1_PREFIXO" ,Substr(cBuffer,03,03),Nil},;
		  		{"E1_NUM"	  ,Substr(cBuffer,06,09),Nil},;
				{"E1_PARCELA" ,Substr(cBuffer,15,01),Nil},;
				{"E1_TIPO"	  ,IIF(Substr(cBuffer,16,03)=="NC","NCC",Substr(cBuffer,16,03)),Nil},;
				{"E1_NATUREZ" ,"IMP"           ,Nil},;
	    	    {"E1_CLIENTE" ,_cCodCli        ,Nil},;
            	{"E1_LOJA"	  ,_cLojCli        ,Nil},;
            	{"E1_NOMECLI" ,Substr(cBuffer,45,20),Nil},;
		        {"E1_EMISSAO" ,STOD(Substr(cBuffer,69,04)+Substr(cBuffer,67,02)+Substr(cBuffer,65,02)),Nil},;
			    {"E1_VENCTO"  ,STOD(Substr(cBuffer,77,04)+Substr(cBuffer,75,02)+Substr(cBuffer,73,02)),Nil},;
			    {"E1_VENCREA" ,STOD(Substr(cBuffer,85,04)+Substr(cBuffer,83,02)+Substr(cBuffer,81,02)),Nil},;
		    	{"E1_VALOR"	  ,NoRound(Val(Substr(cBuffer,89,17)),02),Nil},;
			    {"E1_SALDO"	  ,NoRound(Val(Substr(cBuffer,301,17)),02),Nil},;
			    {"E1_LA"	  ,"S",Nil},;
			    {"E1_HIST"	  ,"IMPORTA��O SISTEMA LEGADO - WK",Nil},;
			    {"E1_ORIGEM"  ,"IMPSE1",Nil}}


/*
		{"E1_EMISSAO" ,CTOS(Substr(cBuffer,65,08)),Nil},;
		{"E1_VENCTO"  ,CTOS(Substr(cBuffer,73,08)),Nil},;
		{"E1_VENCREA" ,CTOS(Substr(cBuffer,81,08)),Nil},;

	SE1->E1_FILIAL	:= Substr(cBuffer,01,02)
	SE1->E1_PREFIXO	:= Substr(cBuffer,03,03)
	SE1->E1_NUM		:= Substr(cBuffer,06,09)
	SE1->E1_PARC	:= Substr(cBuffer,15,02)
	SE1->E1_TIPO	:= Substr(cBuffer,17,03)
	SE1->E1_CLIENTE	:= Substr(cBuffer,20,06)
	SE1->E1_LOJA	:= Substr(cBuffer,26,02)
	SE1->E1_VALOR	:= NoRound(Val(Substr(cBuffer,28,17)),02)
	SE1->E1_EMISSAO	:= CTOD(Substr(cBuffer,45,08))
	SE1->E1_VENCTO	:= CTOD(Substr(cBuffer,53,08))
	SE1->E1_VENCREA	:= CTOD(Substr(cBuffer,61,08))
	SE1->E1_SALDO	:= NoRound(Val(Substr(cBuffer,69,17)),02)
	MSUnLock()
*/
	
	//���������������������������������������������������������������������Ŀ
	//� Leitura da proxima linha do arquivo texto.                          �
	//�����������������������������������������������������������������������

	MSExecAuto({|x,y| Fina040(x,y)},aVetor,3) //3-Inclusao  /5-Exclusao
	
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	
	dbSkip()
EndDo

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������

fClose(nHdl)
Close(oLeTxt)

Return