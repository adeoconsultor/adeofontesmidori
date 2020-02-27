#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MAGPR01  � Autor � PrimaInfo          � Data � 19/09/2009  ���
�������������������������������������������������������������������������͹��
���Descricao � Recibo de entrega da cesta basica.                         ���
���          � Listagem de entrega de cesta basica.                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP10 Midori Atlantica                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MAGPR01

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cDesc1         := "Este programa tem como objetivo imprimir recibo e ou"
Local cDesc2         := "Listagem da Cesta Basica de acordo com os parametros"
Local cDesc3         := "informados pelo usuario."
Local cPict          := ""
Local Titulo         := "Cesta Basica"
Local nLin           := 03
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.

Private aOrd         := { "Unidade Trabalho","Filial" }
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "MAGPR01"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "MAGPR01"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "MAGPR01"
Private cString      := "SRA"

fPriPerg()
pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
wnrel := SetPrint(cString,NomeProg,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  11/02/03   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem   := aReturn[8]
Local lCont    := .F.
Local aInfo    := {}
Local cChave   := "@@"
Local cOldInfo := "@@"
Local nTotCC   := 0
Local dPeriodo := dDataBase

Private cFilDe, cFilAte
Private cMatDe, cMatAte, cCcDe, cCcAte
Private cLctDe, cLctAte,cSitFol,nCesta,cCatFol

pergunte(cPerg,.F.)

cFilDe   := mv_par01
cFilAte  := mv_par02
cMatDe   := mv_par03
cMatAte  := mv_par04
cCcDe    := mv_par05
cCcAte   := mv_par06
cSitFol  := StrTran(mv_par07,"*","")
cAnaSin  := mv_par08
cLctDe   := mv_par09
cLctAte  := mv_par10
nCesta   := mv_par11
cCatFol  := StrTran(mv_par12,"*","")

// Monta a Query Principal a Partir do Cadastro de Funcionarios
MsAguarde( {|| lCont := fMtaQuery(nOrdem)}, "Processando...", "Selecionado Registros no Banco de Dados..." )

If !lCont
	Aviso("ATENCAO","Nao Existem Dados para Este Relatorio",{"Sair"})
	Return
EndIf

If cAnaSin == 1 .Or. cAnaSin == 3
	
	nTotal := 1
	nLin   := 1
	
	dbSelectArea( "RRACB" )
	dbGoTop()
	Do While !Eof()
		dbSkip( 15 )
		If !Eof()
			nTotal := Recno()
		EndIf
	EndDo
	
	dbGoTop()
	
	SetRegua( nTotal )
	
	While !RRACB->(Eof())
		
		IncRegua()
		
		// Busca Informacoes da Filial
		If cOldInfo # RRACB->RA_FILIAL
			fInfo(aInfo,RRACB->RA_FILIAL)
			cOldInfo := RRACB->RA_FILIAL
		EndIf
		
		If nLin >= 58
			@ 0,00 Psay ""
			SetPrc(0,0)
			nLin := 1
		EndIf
		
		If cChave <> If(nOrdem==1,RRACB->(RA_ITEM+RA_CC),RRACB->(RA_FILIAL+RA_CC))
			
			If nOrdem == 1
				cChave := RRACB->(RA_ITEM+RA_CC)
			Else
				cChave := RRACB->(RA_FILIAL+RA_CC)
			EndIf
			
			@ 0,00 Psay ""
			SetPrc(0,0)
			nLin := 1
			
		EndIf
		
		@ nLin,030 PSAY chr(18) + " C E S T A  B A S I C A "
		nLin++
		@ nLin,026 PSAY Replicate("=",30)
		nLin+=3
		@ nLin,010 PSAY "FUNCIONARIO : " + RRACB->RA_MAT
		@ nLin,035 PSAY RRACB->RA_NOME
		nLin++
		@ nLin,010 PSAY "SETOR       : " + RRACB->RA_CC + " - " + RRACB->CTT_DESC01
		nLin+=3
		@ nLin,010 PSAY "Recebi da " + aInfo[3]
		nLin++
		@ nLin,010 PSAY "uma (01) Cesta Basica referente ao mes de "
		@ nLin,053 PSAY MesExtenso(dPeriodo)+"/"+Left(Dtos(dPeriodo),4)+"."
		nLin+=3
		@ nLin,010 PSAY aInfo[5]+",______de___________________________de________."
		nLin+=4
		@ nLin,025 PSAY Replicate("-",30)
		nLin++
		@ nLin,035 PSAY "NOME DO FUNCION�RIO (POR EXTENSO)"
		nLin+=2
		@ nLin,001 PSAY "Obs:A Cesta Basica sera entregue exclusivamente nos dias estabelecidos em circular."
		nLin++
		@ nLin,001 PSAY Replicate("-",80)
		
		nLin+=13
		// nLin := 31 
		//SetPrc(0,0)
		
		RRACB->(dbSkip())
		
	Enddo
	
EndIf

If cAnaSin == 2 .Or. cAnaSin == 3
	
	dbSelectArea( "RRACB" )
	dbGoTop()
	nLin := 59
	
	While !RRACB->(Eof())
		
		// Busca Informacoes da Filial
		If cOldInfo # RRACB->RA_FILIAL
			fInfo(aInfo,RRACB->RA_FILIAL)
			cOldInfo := RRACB->RA_FILIAL
		EndIf
		
		If nLin >= 58
			@ 0,00 Psay ""
			SetPrc(0,0)
			nLin := 3
			@ nLin,020 PSAY aInfo[3]
			nLin+=3
			@ nLin,017 PSAY "Lista de Entrega da Cesta Basica "+MesExtenso(dPeriodo)+"/"+Left(dtos(dPeriodo),4)
			nLin+=3
		EndIf
		
		If cChave <> If(nOrdem==1,RRACB->(RA_ITEM+RA_CC),RRACB->(RA_FILIAL+RA_CC))
			
			If nOrdem == 1
				cChave := RRACB->(RA_ITEM+RA_CC)
			Else
				cChave := RRACB->(RA_FILIAL+RA_CC)
			EndIf
			
			If nTotCC > 0
				nLin++
				@ nLin,001 PSAY "Quant. Funcionarios " + Str(nTotCC,3)
				@ 0,00 Psay ""
				SetPrc(0,0)
				nLin := 3
				@ nLin,020 PSAY aInfo[3]
				nLin+=3
				@ nLin,017 PSAY "Lista de Entrega da Cesta Basica "+MesExtenso(dPeriodo)+"/"+Left(dtos(dPeriodo),4)
				nLin+=3
				nTotCC := 0
			EndIf
			
			@ nLin,010 PSAY RRACB->CTT_DESC01
			nLin+=4
			@ nLin,001 PSAY "Func.   Nome                                              Assinatura"
			nLin+=3
		EndIf
		
		@ nLin,001 PSAY RRACB->RA_MAT
		@ nLin,008 PSAY RRACB->RA_NOME
		@ nLin,050 PSAY Replicate("_",30)
		
		nLin+=3
		nTotCC++
		
		RRACB->(dbSkip())
		
	EndDo
	
EndIf

If nTotCC > 0
	@ nLin,001 PSAY "Quant. Funcionarios " + Str(nTotCC,3)
EndIf

RRACB->(dbCloseArea())

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fMtaQuery �Autor  �Prima Info          � Data �  19/09/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fMtaQuery(nOrdem)

Local lRet    := .F.
Local cQuery

cQuery := "SELECT RA_FILIAL,RA_ITEM,RA_MAT,RA_NOME,RA_CC,RA_SITFOLH,RA_CESTAB"
cQuery += ",CTT_DESC01,'S' AS TEM_CESTA"
cQuery += "  FROM " + RetSqlName( "SRA" ) + " SRA," + RetSqlName( "CTT" ) + " CTT"
cQuery += " WHERE SRA.D_E_L_E_T_ <>'*'"
cQuery += "   AND CTT.D_E_L_E_T_ <>'*'"
cQuery += "   AND RA_CC = CTT_CUSTO"
cQuery += "   AND RA_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
cQuery += "   AND RA_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
cQuery += "   AND RA_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
cQuery += "   AND RA_SITFOLH LIKE '["+cSitFol+"]'"
cQuery += "   AND RA_CATFUNC LIKE '["+cCatFol+"]'"
//cQuery += "   AND RA_ITEM BETWEEN '" + cLctDe + "' AND '" + cLctAte + "'"
If nCesta == 1
	cQuery += "   AND RA_CESTAB ='S'"
ElseIf nCesta == 2
	cQuery += "   AND RA_CESTAB ='N'"
EndIf

If nOrdem == 1
	cQuery += " ORDER BY RA_ITEM, RA_CC, RA_NOME"
Else
	cQuery += " ORDER BY RA_FILIAL, RA_CC, RA_NOME"
EndIf

cQuery := ChangeQuery( cQuery )

TCQuery cQuery New Alias "RRACB"

dbSelectArea( "RRACB" )

If Used()
	lRet := .T.
EndIf

Return( lRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor � AP5 IDE            � Data �  27/10/01   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fPriPerg()

Local aRegs := {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{ cPerg,'01','Filial De ?                  ','','','mv_ch1','C',02,0,0,'G','             ','mv_par01','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'02','Filial Ate ?                 ','','','mv_ch2','C',02,0,0,'G','NaoVazio     ','mv_par02','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'03','Matricula De ?               ','','','mv_ch3','C',06,0,0,'G','             ','mv_par03','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'04','Matricula Ate ?              ','','','mv_ch4','C',06,0,0,'G','NaoVazio     ','mv_par04','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'05','Centro Custo De ?            ','','','mv_ch5','C',10,0,0,'G','             ','mv_par05','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT','' })
aAdd(aRegs,{ cPerg,'06','Centro Custo Ate ?           ','','','mv_ch6','C',10,0,0,'G','NaoVazio     ','mv_par06','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT','' })
aAdd(aRegs,{ cPerg,'07','Situacao                     ','','','mv_ch7','C',05,0,0,'G','fSituacao'    ,'mv_par07',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','',''    ,'' })
aAdd(aRegs,{ cPerg,'08','Tipo de Relatorio ?          ','','','mv_ch8','N',01,0,0,'C','             ','mv_par08','Recibo           ','','','','','Listagem         ','','','','','Ambos'               ,'','','','',''                 ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'09','Unidade Trabalho De?         ','','','mv_ch9','C',02,0,0,'G','             ','mv_par09','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'10','Unidade Trabalho Ate?        ','','','mv_cha','C',02,0,0,'G','NaoVazio     ','mv_par10','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'11','Cesta Basica ?               ','','','mv_chb','N',01,0,0,'C','NaoVazio     ','mv_par11','Sim              ','','','','','Nao              ','','','','','Ambos'               ,'','','','',''                 ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'12','Categoria                    ','','','mv_chc','C',15,0,0,'G','fCategoria'   ,'mv_par12',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','',''    ,'' })

ValidPerg(aRegs,cPerg)

Return
