#INCLUDE "MATR820.CH"
#INCLUDE "FIVEWIN.CH"

Static cAliasTop

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR820  � Autor � Felipe Nunes Toledo   � Data � 26/09/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ordens de Producao                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
User Function AGMATR820()
Local oReport

//-- Verifica se o SH8 esta locado para atualizacao por outro processo                
If !IsLockSH8()
	
	If FindFunction("TRepInUse") .And. TRepInUse()
		//������������������������������������������������������������������������Ŀ
		//�Interface de impressao                                                  �
		//��������������������������������������������������������������������������
		oReport:= ReportDef()
		If !oReport:PrintDialog()
	   		dbSelectArea("SH8")
			dbClearFilter()
			dbCloseArea()
			Return Nil
		EndIf
	Else
		AGMATR820R3()
	EndIf

EndIf
	
Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Felipe Nunes Toledo    � Data �27/09/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       �MATR820                                                     ���
��������������������������������������������������������������������������ٱ�
������������������������������������[�����������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()
Local oReport
Local oSection1, oSection2, Section3
Local aOrdem	:= {STR0002,STR0003,STR0004,STR0005}	//"Por Numero"###"Por Produto"###"Por Centro de Custo"###"Por Prazo de Entrega"
Local cTitle	:= STR0039 //"Ordens de Producao"
Local lVer116   := (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.))  > 11)

#IFDEF TOP
	cAliasTop := GetNextAlias()
#ELSE
	cAliasTop := "SC2"
#ENDIF

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport:= TReport():New("AGMATR820",cTitle,"MTR820", {|oReport| ReportPrint(oReport, cAliasTop)},OemToAnsi(STR0001)) //"Este programa ira imprimir a Rela��o das Ordens de Produ��o"
oReport:SetPortrait()     // Define a orientacao de pagina do relatorio como retrato.
oReport:HideParamPage()   // Desabilita a impressao da pagina de parametros.
oReport:nFontBody	:= 9  // Define o tamanho da fonte.
oReport:nLineHeight	:= 50 // Define a altura da linha.
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas - MTR820                  �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01            // Da OP                                 �
//� mv_par02            // Ate a OP                              �
//� mv_par03            // Da data                               �
//� mv_par04            // Ate a data                            �
//� mv_par05            // Imprime roteiro de operacoes          �
//� mv_par06            // Imprime codigo de barras              �
//� mv_par07            // Imprime Nome Cientifico               �
//� mv_par08            // Imprime Op Encerrada                  �
//� mv_par09            // Impr. por Ordem de                    �
//� mv_par10            // Impr. OP's Firmes, Previstas ou Ambas �
//� mv_par11            // Impr. Item Negativo na Estrutura      �
//� mv_par12            // Imprime Lote/Sub-Lote                 �
//� mv_par14            // Produto De			                 �
//� mv_par15            // Produto Ate			                 �
//� mv_par16            // Plano  			                     �
//����������������������������������������������������������������
AjustaSX1()
Pergunte(oReport:GetParam(),.F.)
//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da secao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a secao.                   �
//�ExpA4 : Array com as Ordens do relatorio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//��������������������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Sessao 1 (oSection1)                                         �
//����������������������������������������������������������������
oSection1 := TRSection():New(oReport,STR0050,{"SC2","SB1","SC5","SA1"},aOrdem) // "Ordens de Produ��o"
oSection1:SetLineStyle() //Define a impressao da secao em linha
oSection1:SetReadOnly()                                       

TRCell():New(oSection1,'C2_NUM'		,'SC2',STR0073   ,PesqPict('SC2','C2_NUM')	 	,TamSX3('C2_NUM')[1]	  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'C2_PRODUTO'	,'SC2',/*Titulo*/,/*Picture*/					,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_DESC' 	,'SB1',/*Titulo*/,/*Picture*/					,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'Emissao'   	,'SC2',STR0040   ,PesqPict("SC2","C2_EMISSAO")	,10						,/*lPixel*/,{|| DTOC(dDataBase) })
TRCell():New(oSection1,'C5_CLIENTE'	,'SC5',/*Titulo*/,/*Picture*/					,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'C5_LOJACLI'	,'SC5',/*Titulo*/,/*Picture*/					,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'A1_NOME'  	,'SA1',/*Titulo*/,/*Picture*/					,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'QtdeProd'	,'SC2',STR0041   ,PesqPict("SC2","C2_QUANT")	,TamSX3("C2_QUANT")[1]	,/*lPixel*/,{|| aSC2Sld(cAliasTop) })
TRCell():New(oSection1,'C2_QUANT'	,'SC2',STR0042   ,/*Picture*/					,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'OpQuant'  	,'SC2',STR0043   ,PesqPict("SC2","C2_QUANT")	,TamSX3("C2_QUANT")[1]	,/*lPixel*/,{|| (cAliasTop)->C2_QUANT - (cAliasTop)->C2_QUJE })
TRCell():New(oSection1,'B1_UM'	 	,'SB1',/*Titulo*/,/*Picture*/					,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'C2_CC'		,'SC2',/*Titulo*/,/*Picture*/					,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'C2_STATUS'	,'SC2',/*Titulo*/,/*Picture*/					,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'C2_DATPRI'	,'SC2','Prev. Inicio',/*Picture*/				,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'C2_DATPRF'	,'SC2','Prev. Entrega',/*Picture*/				,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'C2_OPMIDO'	,'SC2','Plano',/*Picture*/				   		,/*Tamanho*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'C2_OBS'		,'SC2',/*Titulo*/,/*Picture*/					,/*Tamanho*/			,/*lPixel*/,{|| (cAliasTop)->C2_OPMIDO })

oSection1:Cell('C2_NUM'  ):SetCellBreak()
oSection1:Cell('B1_DESC'  ):SetCellBreak()
oSection1:Cell('Emissao'  ):SetCellBreak()
oSection1:Cell('A1_NOME'  ):SetCellBreak()
oSection1:Cell('C2_QUANT' ):SetCellBreak()
oSection1:Cell('OpQuant'  ):SetCellBreak()
oSection1:Cell('B1_UM'    ):SetCellBreak()
oSection1:Cell('C2_CC'    ):SetCellBreak()
oSection1:Cell('C2_STATUS'):SetCellBreak()
oSection1:Cell('C2_DATPRF'):SetCellBreak()
oSection1:Cell('C2_OPMIDO'):SetCellBreak()

//��������������������������������������������������������������Ŀ
//� Sessao 2 (oSection2)                                         �
//����������������������������������������������������������������
oSection2 := TRSection():New(oSection1,STR0051,{"SD4","SB1","NNR"},/*Ordem*/) //"Empenhos"
oSection2:SetHeaderBreak()
oSection2:SetReadOnly()

TRCell():New(oSection2,'D4_COD'	 	,'SD4',STR0058   ,PesqPict('SD4','D4_COD')    ,TamSX3('D4_COD')[1]+2    ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,.F./*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
TRCell():New(oSection2,'B1_DESC' 	,'SB1',STR0059   ,PesqPict('SB1','B1_DESC')   ,30 ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
oSection2:Cell("B1_DESC"):SetLineBreak() 
TRCell():New(oSection2,'D4_QUANT' 	,'SD4',STR0043   ,PesqPict('SD4','D4_QUANT')  ,TamSX3('D4_QUANT')[1]  ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
TRCell():New(oSection2,'B1_UM'   	,'SB1',STR0061   ,PesqPict('SB1','B1_UM')     ,TamSX3('B1_UM')[1]     ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
TRCell():New(oSection2,'D4_LOCAL'	,'SD4',STR0072   ,PesqPict('SD4','D4_LOCAL')  ,TamSX3('D4_LOCAL')[1]  ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
If lVer116
	TRCell():New(oSection2,'NNR_DESCRI'	,'NNR',/*Titulo*/,PesqPict('NNR','NNR_DESCRI'),TamSX3('NNR_DESCRI')[1],/*lPixel*/,{||Posicione("NNR",1,xFilial("NNR")+SD4->D4_LOCAL,"NNR_DESCRI")},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
Else
	TRCell():New(oSection2,'B2_LOCALIZ'	,'SB2',/*Titulo*/,PesqPict('SB2','B2_LOCALIZ'),TamSX3('B2_LOCALIZ')[1],/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
EndIf
TRCell():New(oSection2,'D4_TRT'  	,'SD4',STR0064   ,PesqPict('SD4','D4_TRT')    ,TamSX3('D4_TRT')[1]    ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
TRCell():New(oSection2,'D4_LOTECTL'	,'SD4',/*Titulo*/,PesqPict('SD4','D4_LOTECTL'),TamSX3('D4_LOTECTL')[1],/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
TRCell():New(oSection2,'D4_NUMLOTE'	,'SD4',/*Titulo*/,PesqPict('SD4','D4_NUMLOTE'),TamSX3('D4_NUMLOTE')[1],/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
TRCell():New(oSection2,'D4_OP'  	,'SD4',/*Titulo*/,PesqPict('SD4','D4_OP')     ,TamSX3('D4_OP')[1]     ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)

//��������������������������������������������������������������Ŀ
//� Sessao 3 (oSection3)                                         �
//����������������������������������������������������������������
oSection3 := TRSection():New(oSection1,STR0052,{"SG2","SH8","SH1","SH4"},/*Ordem*/) //"Opera��es"
oSection3:SetHeaderBreak()
oSection3:SetReadOnly()

TRCell():New(oSection3,'G2_RECURSO','SG2',/*Titulo*/,/*Picture*/,10 		   ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'H1_DESCRI'	,'SH1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'G2_FERRAM'	,'SG2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'H4_DESCRI'	,'SH4',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/)
TRCell():New(oSection3,'G2_OPERAC'	,'SG2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/)
TRCell():New(oSection3,'G2_DESCRI'	,'SG2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,.T.)

oSection3:Cell('H1_DESCRI'):HideHeader()
oSection3:Cell('H4_DESCRI'):HideHeader()
oSection3:Cell('G2_DESCRI'):HideHeader()

//��������������������������������������������������������������Ŀ
//� Sessao 4 (oSection4)                                         �
//����������������������������������������������������������������
oSection4 := TRSection():New(oSection3,STR0053,{"SG2","SH8","SH1","SH4"},/*Ordem*/) //"Tempo Rot. Oper."
oSection4:SetLineStyle() //Define a impressao da secao em linha
oSection4:SetReadOnly()

TRCell():New(oSection4,'H8_DTINI'	,'SH8',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,'H8_HRINI'	,'SH8',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,'H8_DTFIM'	,'SH8',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,'H8_HRFIM'	,'SH8',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,'IniAloc'	,'SH8',STR0046   ,'@!'  , 24        ,/*lPixel*/,{|| " ____/ ____/____ ___:___" })
TRCell():New(oSection4,'FimAloc'	,'SH8',STR0047   ,'@!'  , 24        ,/*lPixel*/,{|| " ____/ ____/____ ___:___" })
TRCell():New(oSection4,'H8_QUANT'	,'SH8',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,'QtdeProd'	,'SH8',STR0048   ,/*Picture*/, 12       ,/*lPixel*/,{|| Space(12) })
TRCell():New(oSection4,'QtdPerda'	,'SH8',STR0049   ,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| Space(12) })

oSection4:Cell('H8_HRFIM'):SetCellBreak()
oSection4:Cell('FimAloc' ):SetCellBreak()

oSection1:SetNoFilter({"SA1","SC5"})
oSection2:SetNoFilter({"SD4","SB1","SB2","SC2"})
oSection3:SetNoFilter({"SG2","SH8","SH1","SH4"})
oSection4:SetNoFilter({"SG2","SH8","SH1","SH4"})

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor �Felipe Nunes Toledo  � Data �27/09/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
�������������������������������������������������������������������������Ĵ��
���Uso       �MATR820                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport, cAliasTop)
Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(1):Section(1)
Local oSection3	:= oReport:Section(1):Section(2)
Local oSection4	:= oReport:Section(1):Section(2):Section(1)
Local oSection5
Local nOrdem    := oSection1:GetOrder()
Local oBreak
Local cIndex	:= ""
Local cCondicao	:= ""
Local cCode    	:= ""
Local nCntFor   := 0
Local nLinBar	:= 0
Local cWhere01, cWhere02, cWhere03
Local cSqlPlano, cSqlOP
Local cOrderBy
Local lVer116   := (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.))  > 11)
Local lPlanilha := oReport:nDevice == 4
Private aArray	 := {}
Private lItemNeg := GetMv("MV_NEGESTR") .And. mv_par11 == 1

If !lPlanilha .Or. len(oReport:aXlsTable) == 0
	oSection1:Cell("C2_NUM"):Disable()
Endif	

// Definindo quebra para secao 2 e ocultando celula utilizada somente para quebra
oBreak := TRBreak():New(oSection2,oSection2:Cell("D4_OP"),Nil,.F.)
oSection2:Cell("D4_OP"):Disable()

If lPlanilha
	oSection5 := TRSection():New(oReport,'',{"SC2"},/*Ordem*/)
	TRCell():New(oSection5,'C2_NUM'  	,'SC2',/*Titulo*/,PesqPict('SC2','C2_NUM')     ,TamSX3('C2_NUM')[1]     ,/*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/)
Endif

If mv_par12 == 2
	oSection2:Cell("D4_LOTECTL"):Disable()
	oSection2:Cell("D4_NUMLOTE"):Disable()
ElseIf !oReport:oPage:IsLandScape()
	oSection2:Cell("B1_DESC"):SetSize(19)
	If lVer116
		oSection2:Cell("NNR_DESCRI"):SetSize(10)	
	Else
		oSection2:Cell("B2_LOCALIZ"):SetSize(10)
	EndIf
	oSection2:Cell("D4_NUMLOTE"):SetTitle(STR0057)
EndIf

//������������������������������������������������������������������������Ŀ
//�Filtragem do relatorio                                                  �
//��������������������������������������������������������������������������
#IFDEF TOP

   	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:GetParam())
	
	//��������������������������������������������������������������Ŀ
	//� Condicao Where para filtrar OP's                             �
	//����������������������������������������������������������������
	cWhere01 := "%'"+mv_par01+"'%"
	cWhere02 := "%'"+mv_par02+"'%"
	
	cWhere03 := "%"
	If mv_par08 == 2
		cWhere03 += "AND SC2.C2_DATRF = ' '"
	Endif
	cWhere03 += "%"
	
	cOrderBy := "%"
	If nOrdem == 4
		cOrderBy += "SC2.C2_FILIAL, SC2.C2_DATPRF"
	Else                                  
		cOrderBy += SqlOrder(SC2->(IndexKey(nOrdem)))
	EndIf
	cOrderBy += "%" 
	
	cSqlPlano := "%"
	If !EMPTY(mv_par16)
		cSqlPlano += "SC2.C2_OPMIDO ='"+mv_par16+"' AND "
	Endif
	cSqlPlano += "%" 
	
	cSqlOP := "%"
	If !EMPTY(mv_par01) .And. !EMPTY(mv_par02) 
		cSqlOP += "SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN || SC2.C2_ITEMGRD >= '"+mv_par01+"' AND "
		cSqlOP += "SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN || SC2.C2_ITEMGRD <= '"+mv_par02+"' AND "
	Endif
	cSqlOP += "%"

	//������������������������������������������������������������������������Ŀ
	//�Query do relatorio da secao 1                                           �
	//��������������������������������������������������������������������������
	oSection1:BeginQuery()
	
	BeginSql Alias cAliasTop

	SELECT SC2.C2_FILIAL, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_ITEMGRD, SC2.C2_DATPRF,
	       SC2.C2_DATRF, SC2.C2_PRODUTO, SC2.C2_DESTINA, SC2.C2_PEDIDO, SC2.C2_ROTEIRO, SC2.C2_QUJE,
	       SC2.C2_PERDA, SC2.C2_QUANT, SC2.C2_DATPRI, SC2.C2_CC, SC2.C2_DATAJI, SC2.C2_DATAJF,
	       SC2.C2_STATUS, SC2.C2_OBS, SC2.C2_TPOP, SC2.C2_OPMIDO, 
	       SC2.R_E_C_N_O_  SC2RECNO
	
	FROM %table:SC2% SC2
	
	WHERE SC2.C2_FILIAL = %xFilial:SC2% AND
		  %Exp:cSqlOP%  
	      SC2.C2_PRODUTO >= %Exp:mv_par14% and SC2.C2_PRODUTO <= %Exp:mv_par15% AND  
	      SC2.C2_DATPRF BETWEEN %Exp:mv_par03% AND %Exp:mv_par04% AND
		  %Exp:cSqlPlano%  
		  SC2.%NotDel%                                  
		  %Exp:cWhere03% 
		  
	
	ORDER BY %Exp:cOrderby%
	
	EndSql
	oSection1:EndQuery()     
	
	
#ELSE
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao ADVPL                          �
	//��������������������������������������������������������������������������      
	MakeAdvplExpr(oReport:GetParam())

	dbSelectArea(cAliasTop)
	
	If nOrdem == 4
		cIndex := "C2_FILIAL+DTOS(C2_DATPRF)"
	Else
		dbSetOrder(nOrdem)
	EndIf

	cCondicao := "C2_FILIAL=='"+xFilial("SC2")+"'"
	If !EMPTY(mv_par01) .And. !EMPTY(mv_par02)
   		cCondicao += ".And.C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD>='"+mv_par01+"'"
		cCondicao += ".And.C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD<='"+mv_par02+"'" 
	Endif
	
	If !EMPTY(mv_par14) .And. !EMPTY(mv_par15)
		cCondicao += ".And.C2_PRODUTO >='"+mv_par14+"'"
		cCondicao += ".And.C2_PRODUTO <='"+mv_par15+"'"   
	Endif  
	If !EMPTY(mv_par16)
		cCondicao += ".And.C2_OPMIDO ='"+mv_par16+"'"
	Endif
	
	cCondicao += ".And.DTOS(C2_DATPRF)>='"+DTOS(mv_par03)+"'"
	cCondicao += ".And.DTOS(C2_DATPRF)<='"+DTOS(mv_par04)+"'"
	If mv_par08 == 2
		cCondicao += ".And.Empty(C2_DATRF)"
	EndIf                           
	
	MemoWrite("C:\TEMP\MTR820.TXT", cCondicao)

	oReport:Section(1):SetFilter(cCondicao,If(nOrdem==4,cIndex,IndexKey()))
#ENDIF

//��������������������������Ŀ
//�Posicionamento das tabelas�
//����������������������������
TRPosition():New(oSection1,"SB1",1,{|| xFilial("SB1")+(cAliasTop)->C2_PRODUTO })
TRPosition():New(oSection1,"SC5",1,{|| xFilial("SC5")+(cAliasTop)->C2_PEDIDO })
TRPosition():New(oSection1,"SA1",1,{|| xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI })

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relatorio                               �
//��������������������������������������������������������������������������
oReport:SetMeter(SC2->(LastRec()))
oSection1:Init()
oSection2:Init()
oSection3:Init()
oSection4:Init()
If lPlanilha
	oSection5:Init()
Endif

dbSelectArea(cAliasTop)
ncountpg := 0             

While !oReport:Cancel() .And. !(cAliasTop)->(Eof())
	//-- Valida se a OP deve ser Impressa ou nao
	If !MtrAValOP(mv_par10,"SC2",cAliasTop)
		dbSkip()
		Loop
	EndIf    
	
	//Definindo a descricao do produto
	MR820Desc(oReport, cAliasTop)

	//���������������������������������������������������������Ŀ
	//� Desabilitando celulas que nao deverao serem impressas   �
	//�����������������������������������������������������������
	If (cAliasTop)->C2_DESTINA <> "P"
    	oSection1:Cell('C5_CLIENTE'):Disable()
    	oSection1:Cell('C5_LOJACLI'):Disable()
    	oSection1:Cell('A1_NOME'   ):Disable()
 	EndIf
	If Empty((cAliasTop)->C2_STATUS)
		oSection1:Cell("C2_STATUS"):SetValue("Normal")
	EndIf
	If (cAliasTop)->C2_QUJE + (cAliasTop)->C2_PERDA > 0
		oSection1:Cell('OpQuant'):Disable()
	Else
		oSection1:Cell('QtdeProd'):Disable()
		oSection1:Cell('C2_QUANT'):Disable()
	Endif
	If (Empty((cAliasTop)->C2_OBS))
		oSection1:Cell('C2_OBS'):Disable()	
	EndIf

	//�������������������������������Ŀ
	//�Definindo o titulo do Relatorio�
	//���������������������������������
	oReport:SetTitle(STR0010+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)) //"        O R D E M   D E   P R O D U C A O       NRO :"
//	oReport:SetTitle(STR0010)+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)) //"        O R D E M   D E   P R O D U C A O       NRO :"
   
	// Define imagem geometrica conforme componente da OP
	// Diego Mafisolli 21/03/2018  
	// MODELO 204
	If cFilAnt == '08'
		If Alltrim((cAliasTop)->C2_PRODUTO) $ GetMV("MA_BMP_AD")
			oReport:SayBitmap(580, 1700, "BMP_AD.BMP", 450, 450)
		Elseif Alltrim((cAliasTop)->C2_PRODUTO) $ GetMV("MA_BMP_ED")    
			oReport:SayBitmap(580, 1700, "BMP_ED.BMP", 450, 450)  
		Elseif Alltrim((cAliasTop)->C2_PRODUTO) $ GetMV("MA_BMP_AT")    
			oReport:SayBitmap(580, 1700, "BMP_AT.BMP", 450, 450)		
		Elseif Alltrim((cAliasTop)->C2_PRODUTO) $ GetMV("MA_BMP_ET")    
			oReport:SayBitmap(580, 1700, "BMP_ET.BMP", 450, 450)		
		EndIf   
				
	// MODELO 360
		If Alltrim((cAliasTop)->C2_PRODUTO) $ "074062|074610|074611|074612|074613|074614|074616|074617"
			oReport:SayBitmap(580, 1700, "074251-360B.BMP", 450, 450)
		Elseif Alltrim((cAliasTop)->C2_PRODUTO) $ "074075|074076|074079|074081|074087|074088|074089|074093"    
			oReport:SayBitmap(580, 1700, "073392-360B.BMP", 450, 450)   
		Elseif Alltrim((cAliasTop)->C2_PRODUTO) $ "074058|074059|074060|074061|074062|074063|074064|074065"    
			oReport:SayBitmap(580, 1700, "072865-360B.BMP", 450, 450)   
		Elseif Alltrim((cAliasTop)->C2_PRODUTO) $ "077811|077812|077813|077814|077815|077816|077817|077818|077819"
			oReport:SayBitmap(580, 1700, "078425-SUMY20.BMP", 450, 450)   
		Elseif Alltrim((cAliasTop)->C2_PRODUTO) $ "072366"    
			oReport:SayBitmap(580, 1700, "072366-046B.BMP", 450, 450)   
		Elseif Alltrim((cAliasTop)->C2_PRODUTO) $ "043220|053498|053499|053500|053501|053502|063029|063030"    
			oReport:SayBitmap(580, 1700, "053541-ZCPT.BMP", 450, 450)   
		Elseif Alltrim((cAliasTop)->C2_PRODUTO) $ "068292|068293|068294|068295|074972|074973|074974|074975"
			oReport:SayBitmap(580, 1700, "068229-ZC45BG.BMP", 450, 450)   
		Elseif Alltrim((cAliasTop)->C2_PRODUTO) $ "068563"    
			oReport:SayBitmap(580, 1700, "068563-ZC45BG_AB.BMP", 450, 450)   
		Elseif Alltrim((cAliasTop)->C2_PRODUTO) $ "074075|074076|074079|074081|074087|074088|074089|074090"    
			oReport:SayBitmap(580, 1700, "073391-360B.BMP", 450, 450)   
		Elseif Alltrim((cAliasTop)->C2_PRODUTO) $ "074059|074060|074061|074062|074063|074064|074091|074092"
			oReport:SayBitmap(580, 1700, "072945-360B.BMP", 450, 450)   
		Endif	
	Endif


	If mv_par06 == 1 
		nLinBar := 0.95
		
		oReport:PrintText("")
		For nCntFor := 1 to 5
			oReport:SkipLine()
		Next nCntFor

		cCode := (cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)

		If oReport:lHeaderVisible .And. oReport:nEnvironment == 2
			nLinBar += 1
		EndIf
		
		If oReport:GetOrientation()== 1
			nLinBar += 0.2
		EndIf
		MSBAR3("CODE128",nLinBar,0.5,Trim(cCode),@oReport:oPrint,Nil,Nil,Nil,Nil ,1.5 ,Nil,Nil,Nil,.F.)
	EndIf
	
	If lPlanilha
		oReport:SkipLine()
		oSection5:Cell("C2_NUM"):SetValue((cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))
		oSection5:Cell('C2_NUM'):Enable()	
		If len(oReport:aXlsTable) > 0
			oSection1:Cell("C2_NUM"):SetValue((cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))
			oSection1:Cell('C2_NUM'):Enable()
		Endif
		//Impressao da Section 5
		oSection5:PrintLine()
		oReport:IncMeter()
	Endif
	
	//Impressao da Section 1
	oSection1:PrintLine()
	oReport:IncMeter()

	//���������������������
	//�Habilitando celulas�
	//���������������������
	If (cAliasTop)->C2_DESTINA <> "P"
    	oSection1:Cell('C5_CLIENTE'):Enable()
    	oSection1:Cell('C5_LOJACLI'):Enable()
    	oSection1:Cell('A1_NOME'   ):Enable()
 	EndIf
	If (cAliasTop)->C2_QUJE + (cAliasTop)->C2_PERDA > 0
		oSection1:Cell('OpQuant'):Enable()
	Else
		oSection1:Cell('QtdeProd'):Enable()
		oSection1:Cell('C2_QUANT'):Enable()
	Endif
	If (Empty((cAliasTop)->C2_OBS))
		oSection1:Cell('C2_OBS'):Enable()	
	EndIf
	
	//--- Inicio fluxo impressao secao 2
	SB1->(dbSeek(xFilial("SB1")+(cAliasTop)->C2_PRODUTO))
	
	aArray := {}
	MontStruc((cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))
	
	If mv_par09 == 1
		aSort( aArray,1,, { |x, y| (x[1]+x[8]) < (y[1]+y[8]) } )
	Else
		aSort( aArray,1,, { |x, y| (x[8]+x[1]) < (y[8]+y[1]) } )
	ENDIF
	
	If substr((cAliasTop)->C2_CC,1,4) <> '3204'                         
	For nCntFor := 1 TO Len(aArray)

	    SB1->(dbSetOrder(1))
	    SB1->(MsSeek(xFilial("SB1")+aArray[nCntFor][1]))

	    SD4->(dbSetOrder(2))
	    SD4->(MsSeek(xFilial("SD4")+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)+aArray[nCntFor][1]+aArray[nCntFor][6]))

		oSection2:Cell("D4_COD"    ):SetValue(aArray[nCntFor][1])
		oSection2:Cell("B1_DESC"   ):SetValue(aArray[nCntFor][2])
		oSection2:Cell("D4_QUANT"  ):SetValue(aArray[nCntFor][5])
		oSection2:Cell("B1_UM"     ):SetValue(aArray[nCntFor][4])
		oSection2:Cell("D4_LOCAL"  ):SetValue(aArray[nCntFor][6])
		If lVer116
			oSection2:Cell("NNR_DESCRI"):SetValue(aArray[nCntFor][7])
		Else
			oSection2:Cell("B2_LOCALIZ"):SetValue(aArray[nCntFor][7])
		EndIf
		oSection2:Cell("D4_TRT"    ):SetValue(aArray[nCntFor][8])
		oSection2:Cell("D4_OP"     ):SetValue((cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))
		If mv_par12 == 1
			oSection2:Cell("D4_LOTECTL"):SetValue(aArray[nCntFor][10])
			oSection2:Cell("D4_NUMLOTE"):SetValue(aArray[nCntFor][11])
		EndIf
	    
	    //Impressao da Section 2
		oSection2:PrintLine()
	Next nCntFor
	Endif
	
	If mv_par05 == 1
		Mr820Ope(oReport, cAliasTop) //Impressao da Section 3 e Section 4
	EndIf

//  if ncountpg == 3	
	oReport:EndPage() //-- Salta Pagina
//  endif
	dbSelectArea(cAliasTop)
	dbSkip()
    ncountpg++
EndDo

If lPlanilha
	oSection5:Finish()
Endif
oSection4:Finish()
oSection3:Finish()
oSection2:Finish()
oSection1:Finish()
(cAliasTop)->(DbCloseArea())
dbSelectArea("SH8")
dbClearFilter()
dbCloseArea()

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MR820Desc   � Autor �Felipe Nunes Toledo  � Data �28/09/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Atribui a descricao do produto conforme opcao selecionada   ���
���          �no parametro mv_par07 (Descricao do Produto ?).             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
���          �ExpC1: Alias do arquivo Ordem de Producao                   ���
�������������������������������������������������������������������������Ĵ��
���Uso       �MATR820                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MR820Desc(oReport, cAliasTop)
Local oSection1 := oReport:Section(1)
Local lSB1Desc 	:= .T.
 
If mv_par07 == 1
	SB5->(dbSetOrder(1))
	If SB5->(dbSeek(xFilial("SB5")+(cAliasTop)->C2_PRODUTO) .And. !Empty(B5_CEME))
		oSection1:Cell("B1_DESC"):GetFieldInfo("B5_CEME")
		oSection1:Cell("B1_DESC"):SetValue(SB5->B5_CEME)
		lSB1Desc := .F.		
	EndIf
ElseIf mv_par07 == 3
	If (cAliasTop)->C2_DESTINA == "P"
		SC6->(dbSetOrder(1))
		If SC6->(dbSeek(xFilial("SC6")+(cAliasTop)->C2_PEDIDO+(cAliasTop)->C2_ITEM))
			If !Empty(SC6->C6_DESCRI) .and. SC6->C6_PRODUTO == (cAliasTop)->C2_PRODUTO
				oSection1:Cell("B1_DESC"):GetFieldInfo("C6_DESCRI")
				oSection1:Cell("B1_DESC"):SetValue(SC6->C6_DESCRI)
				lSB1Desc := .F.
			EndIf
		EndIf
	EndIf
EndIf

If (mv_par07 <> 2) .And. lSB1Desc
	SB1->(dbSetOrder(1))
	If SB1->( dbSeek(xFilial("SB1")+(cAliasTop)->C2_PRODUTO) )
		oSection1:Cell("B1_DESC"):GetFieldInfo("B1_DESC")
		oSection1:Cell("B1_DESC"):SetValue(SB1->B1_DESC)
	EndIf
EndIf

Return Nil

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � Mr820Ope � Autor � Felipe Nunes Toledo   � Data � 18/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime Roteiro de Operacoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � Mr820Ope()                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function Mr820Ope(oReport, cAliasTop)
Local oSection3 := oReport:Section(1):Section(2)
Local oSection4	:= oReport:Section(1):Section(2):Section(1)
Local oBreak                                  �
Local cRoteiro	:= ""                 
Local cSeekWhile:= ""
Local lSH8 		:= .F.
Local aArea   	:= GetArea()

oBreak:= TRBreak():New(oSection3,oSection3:Cell("G2_RECURSO"),Nil,.F.)  

//�����������������������������������������������������������Ŀ
//� Verifica se imprime ROTEIRO da OP ou PADRAO do produto    �
//�������������������������������������������������������������
If !Empty((cAliasTop)->C2_ROTEIRO)
	cRoteiro:=(cAliasTop)->C2_ROTEIRO
Else
	If !Empty(SB1->B1_OPERPAD)
		cRoteiro:=SB1->B1_OPERPAD
	Else
		If a630SeekSG2(1,(cAliasTop)->C2_PRODUTO,xFilial("SG2")+(cAliasTop)->C2_PRODUTO+"01")
			cRoteiro:="01"
		EndIf
	EndIf
EndIf

cSeekWhile := "SG2->(G2_FILIAL+G2_PRODUTO+G2_CODIGO)"
If a630SeekSG2(1,(cAliasTop)->C2_PRODUTO,xFilial("SG2")+(cAliasTop)->C2_PRODUTO+cRoteiro,@cSeekWhile) 

	While SG2->(!Eof()) .And. Eval(&cSeekWhile)
		SH8->(dbSetOrder(1))
		If SH8->(dbSeek(xFilial("SH8")+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)+SG2->G2_OPERAC))
			lSH8 := .T.
		EndIf
		
		If lSH8
			While SH8->(!Eof()) .And. SH8->(H8_FILIAL+H8_OP+H8_OPER) == xFilial("SH8")+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)+SG2->G2_OPERAC
				SH1->(dbSeek(xFilial("SH1")+SH8->H8_RECURSO))
				SH4->(dbSeek(xFilial("SH4")+SG2->G2_FERRAM))
				
				oSection3:Cell('G2_RECURSO'):SetValue(SH8->H8_RECURSO)
				oSection3:Cell('H1_DESCRI' ):SetValue(SH1->H1_DESCRI)
				oSection3:Cell('G2_FERRAM' ):SetValue(SG2->G2_FERRAM)
				oSection3:Cell('H4_DESCRI' ):SetValue(SH4->H4_DESCRI)
				oSection3:Cell('G2_OPERAC' ):SetValue(SG2->G2_OPERAC)
				oSection3:Cell('G2_DESCRI' ):SetValue(SG2->G2_DESCRI)

				oSection3:PrintLine()
				oSection4:PrintLine()
				oReport:ThinLine()
				SH8->(dbSkip())
			EndDo
		Else
			SH1->(dbSeek(xFilial("SH1")+SG2->G2_RECURSO))
			SH4->(dbSeek(xFilial("SH4")+SG2->G2_FERRAM))
		
			oSection3:Cell('G2_RECURSO'):SetValue(SG2->G2_RECURSO)
			oSection3:Cell('H1_DESCRI' ):SetValue(SH1->H1_DESCRI)
			oSection3:Cell('G2_FERRAM' ):SetValue(SG2->G2_FERRAM)
			oSection3:Cell('H4_DESCRI' ):SetValue(SH4->H4_DESCRI)
			oSection3:Cell('G2_OPERAC' ):SetValue(SG2->G2_OPERAC)
			oSection3:Cell('G2_DESCRI' ):SetValue(SG2->G2_DESCRI)
			oSection3:PrintLine()
			
			oSection4:Cell('H8_DTINI'):Disable()
			oSection4:Cell('H8_HRINI'):Disable()
			oSection4:Cell('H8_DTFIM'):Disable()
			oSection4:Cell('H8_HRFIM'):Disable()
			oSection4:Cell('H8_QUANT'):SetValue(aSC2Sld(cAliasTop))
			oSection4:PrintLine()
			oReport:ThinLine()

			oSection4:Cell('H8_DTINI'):Enable()
			oSection4:Cell('H8_HRINI'):Enable()
			oSection4:Cell('H8_DTFIM'):Enable()
			oSection4:Cell('H8_HRFIM'):Enable()
		Endif
		SG2->(dbSkip())
	EndDo
Endif

RestArea(aArea)
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR820  � Autor � Paulo Boschetti       � Data � 07.07.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ordens de Producao                                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR820(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function AGMATR820R3()
Local titulo  := STR0039 //"Ordens de Producao"
Local cString := "SC2"
Local wnrel   := "AGMATR820"
Local cDesc   := STR0001	//"Este programa ira imprimir a Rela��o das Ordens de Produ��o"
Local aOrd    := {STR0002,STR0003,STR0004,STR0005}	//"Por Numero"###"Por Produto"###"Por Centro de Custo"###"Por Prazo de Entrega"
Local tamanho := "P"

Private aReturn  := {STR0006,1,STR0007, 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
Private cPerg    :="MTR820"
Private nLastKey := 0
Private lItemNeg := .F.

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
AjustaSX1()
pergunte("MTR820",.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01            // Da OP                                 �
//� mv_par02            // Ate a OP                              �
//� mv_par03            // Da data                               �
//� mv_par04            // Ate a data                            �
//� mv_par05            // Imprime roteiro de operacoes          �
//� mv_par06            // Imprime codigo de barras              �
//� mv_par07            // Imprime Nome Cientifico               �
//� mv_par08            // Imprime Op Encerrada                  �
//� mv_par09            // Impr. por Ordem de                    �
//� mv_par10            // Impr. OP's Firmes, Previstas ou Ambas �
//� mv_par11            // Impr. Item Negativo na Estrutura      �
//� mv_par12            // Imprime Lote/Sub-Lote                 �
//����������������������������������������������������������������
//-- Verifica se o SH8 esta locado para atualizacao por outro processo                
If !IsLockSH8()
	//��������������������������������������������������������������Ŀ
	//� Envia controle para a funcao SETPRINT                        �
	//����������������������������������������������������������������
	
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd,.F.,Tamanho)
	
	lItemNeg := GetMv("MV_NEGESTR") .And. mv_par11 == 1
	
	If nLastKey == 27
		dbSelectArea("SH8")
		dbClearFilter()
		dbCloseArea()
		dbSelectArea("SC2")
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		dbSelectArea("SH8")
		dbClearFilter()
		dbCloseArea()
		dbSelectArea("SC2")
		Return
	Endif
	
	RptStatus({|lEnd| R820Imp(@lEnd,wnRel,titulo,if(mv_par12 == 2,"P","M"))},titulo)

EndIf
	
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R820Imp  � Autor � Waldemiro L. Lustosa  � Data � 13.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relat�rio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R820Imp(lEnd,wnRel,titulo,tamanho)

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local CbCont,cabec1,cabec2
Local limite     := 80
Local nQuant     := 1
Local nomeprog   := "AGMATR820"
Local nPagina	 := 1
Local nTipo      := 18
Local cPictQuant := PesqPictQt("D4_QUANT",TamSX3("D4_QUANT")[1])
Local cProduto   := SPACE(LEN(SC2->C2_PRODUTO))
Local cQtd,i,nBegin
Local cIndSC2    := CriaTrab(NIL,.F.), nIndSC2

#IFDEF TOP
	Local bBlockFiltro := {|| .T.}
#ENDIF	

Private aArray   := {}
Private li       := 80     

cAliasTop  := "SC2"

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
m_pag    := 1
//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������
cabec1 := ""
cabec2 := ""

dbSelectArea("SC2")

#IFDEF TOP
	cAliasTop := GetNextAlias()
	cQuery := "SELECT SC2.C2_FILIAL, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_ITEMGRD, SC2.C2_DATPRF, "
	cQuery += "SC2.C2_DATRF, SC2.C2_PRODUTO, SC2.C2_DESTINA, SC2.C2_PEDIDO, SC2.C2_ROTEIRO, SC2.C2_QUJE, "
	cQuery += "SC2.C2_PERDA, SC2.C2_QUANT, SC2.C2_DATPRI, SC2.C2_CC, SC2.C2_DATAJI, SC2.C2_DATAJF, "
	cQuery += "SC2.C2_STATUS, SC2.C2_OBS, SC2.C2_TPOP, "
	cQuery += "SC2.R_E_C_N_O_  SC2RECNO FROM "+RetSqlName("SC2")+" SC2 WHERE "
	cQuery += "SC2.C2_FILIAL='"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_=' ' AND "
	If	Upper(TcGetDb()) $ 'ORACLE,DB2,POSTGRES,INFORMIX'
		cQuery += "SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN || SC2.C2_ITEMGRD >= '" + mv_par01 + "' AND "
		cQuery += "SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN || SC2.C2_ITEMGRD <= '" + mv_par02 + "' AND "
	Endif
	cQuery += "SC2.C2_DATPRF BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "' "
	If mv_par08 == 2
		cQuery += "AND SC2.C2_DATRF = ' '"
	Endif	
	If aReturn[8] == 4
		cQuery += "ORDER BY SC2.C2_FILIAL, SC2.C2_DATPRF"
	Else
		cQuery += "ORDER BY " + SqlOrder(SC2->(IndexKey(aReturn[8])))
	EndIf
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
	aEval(SC2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
	dbSelectArea(cAliasTop)
#ELSE
	If aReturn[8] == 4
		IndRegua("SC2",cIndSC2,"C2_FILIAL+DTOS(C2_DATPRF)",,,STR0008)	//"Selecionando Registros..."
	Else
		dbSetOrder(aReturn[8])
	EndIf
	dbSeek(xFilial("SC2"))
#ENDIF

If ! Empty(aReturn[7])
	bBlockFiltro := &("{|| " + aReturn[7] + "}")
Endif	

SetRegua(SC2->(LastRec()))

While !Eof()
	
	IF lEnd
		@ Prow()+1,001 PSay STR0009	//"CANCELADO PELO OPERADOR"
		Exit
	EndIF
	
	IncRegua()
	

	If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD < xFilial('SC2')+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD > xFilial('SC2')+mv_par02
		dbSkip()
		Loop
	EndIf   
		
	#IFNDEF TOP		
		If  C2_DATPRF < mv_par03 .Or. C2_DATPRF > mv_par04
			dbSkip()
			Loop
		Endif
		
		If !(Empty(C2_DATRF)) .And. mv_par08 == 2
			dbSkip()
			Loop
		Endif
	#ENDIF

	If !Empty(aReturn[7])
		#IFDEF TOP
			SC2->(dbGoto((cAliasTop)->SC2RECNO))
		#ENDIF	

		If !(SC2->(Eval(bBlockFiltro)))
			(cAliasTop)->(dbSkip())
			Loop                 
		EndIf	
	Endif	

	//-- Valida se a OP deve ser Impressa ou n�o
	If !MtrAValOP(mv_par10,"SC2",cAliasTop)
		dbSkip()
		Loop
	EndIf
	
	cProduto  := C2_PRODUTO
	nQuant    := aSC2Sld(cAliasTop)
	
	dbSelectArea("SB1")
	dbSeek(xFilial()+cProduto)
	
	//��������������������������������������������������������������Ŀ
	//� Adiciona o primeiro elemento da estrutura , ou seja , o Pai  �
	//����������������������������������������������������������������
	AddAr820(nQuant)
	
	MontStruc((cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD),nQuant)
	
	If mv_par09 == 1
		aSort( aArray,2,, { |x, y| (x[1]+x[8]) < (y[1]+y[8]) } )
	Else
		aSort( aArray,2,, { |x, y| (x[8]+x[1]) < (y[8]+y[1]) } )
	ENDIF
	
	//���������������������������������������������������������Ŀ
	//� Imprime cabecalho                                       �
	//�����������������������������������������������������������
	nPagina := 1
	cabecOp(Tamanho, nPagina)
	
	For I := 2 TO Len(aArray)
		@Li,   0 PSay substr(aArray[I][1],1,tamsx3('B1_COD')[1])
		//@Li,   0 PSay aArray[I][1]    	 				   	// CODIGO PRODUTO
		For nBegin := 1 To Len(Alltrim(aArray[I][2])) Step 31
			@li,017 PSay Substr(aArray[I][2],nBegin,31)

			li++
		Next nBegin
		Li--
		
		cQtd := Alltrim(Transform(aArray[I][5],cPictQuant))
		@Li , (46+11-Len(cQtd)) PSay cQtd					// QUANTIDADE
		
		//@Li ,46 PSay substr(aArray[I][5],1,tamsx3("D4_QUANT")[1]) 
		
		If mv_par12 == 2
			@Li ,  58 PSay "|"+aArray[I][4]+"|"			  	// UNIDADE DE MEDIDA
			@li ,  62 PSay aArray[I][6]+"|"                  	// ALMOXARIFADO
			@li ,  65 PSay Substr(aArray[I][7],1,12)         	// LOCALIZACAO
			@li ,  75 PSay "  |"+aArray[I][8]                  	// SEQUENCIA
		Else
			@Li ,  59 PSay "| "+aArray[I][4]+" |"			  	// UNIDADE DE MEDIDA
			@li ,  65 PSay aArray[I][6]+"  |"                  	// ALMOXARIFADO
			@li ,  70 PSay Substr(aArray[I][7],1,12)         	// LOCALIZACAO
			@li ,  83 PSay " | "+aArray[I][8]                  	// SEQUENCIA
			@li ,  89 PSay " | "+aArray[I][10]                  	// LOTE
			@li , 102 PSay " | "+aArray[I][11]                  	// SUB-LOTE
		EndIf
		Li++
		@Li ,  00 PSay __PrtThinLine()
		Li++
		   
		//���������������������������������������������������������Ŀ
		//� Se nao couber, salta para proxima folha              ADMIN   �
		//�����������������������������������������������������������
		IF li > 59
			Li := 0
			nPagina++
			m_pag++
			CabecOp(Tamanho, nPagina)		// imprime cabecalho da OP
		EndIF
		
	Next I
	
	If mv_par05 == 1
		RotOper()   	// IMPRIME ROTEIRO DAS OPERACOES
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� Imprimir Relacao de medidas para Cliente == HUNTER DOUGLAS.  �
	//����������������������������������������������������������������
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SMX")
	If Found() .And. (cAliasTop)->C2_DESTINA == "P"
		R820Medidas()
	EndIf
	
	Li := 0					// linha inicial - ejeta automatico
	aArray:={}
	
	dbSelectArea(cAliasTop)
	dbSkip()
	
EndDO

dbSelectArea("SH8")
dbCloseArea()

dbSelectArea("SC2")
#IFDEF TOP
	(cAliasTop)->(dbCloseArea())
#ELSE	
	If aReturn[8] == 4
		RetIndex("SC2")
		Ferase(cIndSC2+OrdBagExt())
	EndIf
#ENDIF
dbClearFilter()
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return NIL

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � AddAr820 � Autor � Paulo Boschetti       � Data � 07/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Adiciona um elemento ao Array                              ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � AddAr820(ExpN1)                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 = Quantidade da estrutura                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function AddAr820(nQuantItem)
Local cDesc   := SB1->B1_DESC
Local cLocal  := ""
Local cKey    := ""
Local cRoteiro:= ""   
Local nQtdEnd    
Local lExiste

Local lVer116   := (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.))  > 11)   

//�����������������������������������������������������������Ŀ
//� Verifica se imprime nome cientifico do produto. Se Sim    �
//� verifica se existe registro no SB5 e se nao esta vazio    �
//�������������������������������������������������������������
If mv_par07 == 1
	dbSelectArea("SB5")
	dbSeek(xFilial()+SB1->B1_COD)
	If Found() .and. !Empty(B5_CEME)
		cDesc := B5_CEME
	EndIf
ElseIf mv_par07 == 2
	cDesc := SB1->B1_DESC
Else
	//�����������������������������������������������������������Ŀ
	//� Verifica se imprime descricao digitada ped.venda, se sim  �
	//� verifica se existe registro no SC6 e se nao esta vazio    �
	//�������������������������������������������������������������
	If (cAliasTop)->C2_DESTINA == "P"
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial()+(cAliasTop)->C2_PEDIDO+(cAliasTop)->C2_ITEM)
		If Found() .and. !Empty(C6_DESCRI) .and. C6_PRODUTO==SB1->B1_COD
			cDesc := C6_DESCRI
		ElseIf C6_PRODUTO # SB1->B1_COD
			dbSelectArea("SB5")
			dbSeek(xFilial()+SB1->B1_COD)
			If Found() .and. !Empty(B5_CEME)
				cDesc := B5_CEME
			EndIf
		EndIf
	EndIf
EndIf

//�����������������������������������������������������������Ŀ
//� Verifica se imprime ROTEIRO da OP ou PADRAO do produto    �
//�������������������������������������������������������������
If !Empty((cAliasTop)->C2_ROTEIRO)
	cRoteiro:=(cAliasTop)->C2_ROTEIRO
Else
	If !Empty(SB1->B1_OPERPAD)
		cRoteiro:=SB1->B1_OPERPAD
	Else
		dbSelectArea("SG2")
		If dbSeek(xFilial()+(cAliasTop)->C2_PRODUTO+"01")
			cRoteiro:="01"
		EndIf
	EndIf
EndIf
 
If lVer116
	dbSelectArea("NNR")
	dbSeek(xFilial()+SD4->D4_LOCAL)
Else
	dbSelectArea("SB2")
	dbSeek(xFilial()+SB1->B1_COD+SD4->D4_LOCAL) 
EndIf

dbSelectArea("SD4")
cKey:=SD4->D4_COD+SD4->D4_LOCAL+SD4->D4_OP+SD4->D4_TRT+SD4->D4_LOTECTL+SD4->D4_NUMLOTE
cLocal:=SB2->B2_LOCALIZ
                                  
lExiste := .F.

If !lVer116
	DbSelectArea("SDC")
	DbSetOrder(2)
	DbSeek(xFilial("SDC")+cKey)
	//If !Eof() .And. SDC->(DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE) == cKey 
		While !Eof().And. SDC->(DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE) == cKey 
			cLocal  :=DC_LOCALIZ      
			nQtdEnd :=DC_QTDORIG 
		
			AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQtdEnd,SD4->D4_LOCAL,cLocal,SD4->D4_TRT,cRoteiro,If(mv_par12 == 1,SD4->D4_LOTECTL,""),If(mv_par12 == 1,SD4->D4_NUMLOTE,"") } )
			lExiste := .T. 
			dbSkip()
		end
	//EndIf
endif 

dbSelectArea("SD4")

if !lExiste 
	If lVer116
		AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,SD4->D4_LOCAL,NNR->NNR_DESCRI,SD4->D4_TRT,cRoteiro,If(mv_par12 == 1,SD4->D4_LOTECTL,""),If(mv_par12 == 1,SD4->D4_NUMLOTE,"") } )
	Else
		AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,SD4->D4_LOCAL,cLocal,SD4->D4_TRT,cRoteiro,If(mv_par12 == 1,SD4->D4_LOTECTL,""),If(mv_par12 == 1,SD4->D4_NUMLOTE,"") } )
	EndIf
endif

Return
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � MontStruc� Autor � Ary Medeiros          � Data � 19/10/93 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Monta um array com a estrutura do produto                  ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � MontStruc(ExpC1,ExpN1,ExpN2)                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo do produto a ser explodido                  ���
���          � ExpN1 = Quantidade base a ser explodida                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function MontStruc(cOp,nQuant)

dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial()+cOp)

While !Eof() .And. D4_FILIAL+D4_OP == xFilial()+cOp
	//���������������������������������������������������������Ŀ
	//� Posiciona no produto desejado                           �
	//�����������������������������������������������������������
	dbSelectArea("SB1")
	If dbSeek(xFilial()+SD4->D4_COD)
		If SD4->D4_QUANT > 0 .Or. (lItemNeg .And. SD4->D4_QUANT < 0)
			AddAr820(SD4->D4_QUANT)
		EndIf
	Endif
	dbSelectArea("SD4")
	dbSkip()
Enddo

dbSetOrder(1)

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � CabecOp  � Autor � Paulo Boschetti       � Data � 07/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Monta o cabecalho da Ordem de Producao                     ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � CabecOp()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function CabecOp(Tamanho, nPagOp)

Local cTitulo := If(mv_par12 == 2,STR0010,STR0054)+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
Local cCabec1 := STR0066+RTrim(SM0->M0_NOME)+" / "+STR0067+Alltrim(SM0->M0_FILIAL)
Local cCabec2 := If(mv_par12 == 2,STR0011,STR0055)	//"  C O M P O N E N T E S                                  |  |  |            |   "
Local cCabec3 := If(mv_par12 == 2,STR0012,STR0056)	//"CODIGO          DESCRICAO                      QUANTIDADE|UM|AL|LOCALIZACAO |SEQ"
													// 012345678901234567890123456789012345678901234567890123456789012345678901234567890
                      						  		//	       1         2         3         4         5         6         7         8
Local nBegin
Local nLinha   := 0
Local nomeprog := "AGMATR820"
Local cPictQuant := PesqPictQt("C2_QUANT",TamSX3("C2_QUANT")[1])
//����������������������������������������������Ŀ
//�Verificar se o ambiente � cliente ou servidor.�
//������������������������������������������������
//If SetPrintEnv() == 1
	nLinha := 2.0
//Else
//	nLinha := 0.8
//EndIf

If li # 5
	li := 0
Endif

Cabec(cTitulo,cCabec1,"",NomeProg,Tamanho,18,,.F.)

Li+=2
IF (mv_par06 == 1) .And. aReturn[5] # 1
	//���������������������������������������������������������Ŀ
	//� Imprime o codigo de barras do numero da OP              �
	//�����������������������������������������������������������
	oPr := ReturnPrtObj()   
	cCode := (cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
	MSBAR3("CODE128",nLinha,0.5,Alltrim(cCode),oPr,Nil,Nil,Nil,nil ,1.5 ,Nil,Nil,Nil)
	Li += 5
ENDIF
@Li,00 PSay STR0013+aArray[1][1]+ " " +aArray[1][2]	//"Produto: "
Li++
@Li,00 PSay STR0014+DTOC(dDatabase)						//"Emissao:"
@Li,73 PSay STR0015+TRANSFORM(nPagOp,'999')				//"Fol:"
Li++

//���������������������������������������������������������Ŀ
//� Imprime nome do cliente quando OP for gerada            �
//� por pedidos de venda                                    �
//�����������������������������������������������������������
If (cAliasTop)->C2_DESTINA == "P"
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek(xFilial()+(cAliasTop)->C2_PEDIDO,.F.)
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
		@Li,00 PSay STR0016	//"Cliente :"
		@Li,10 PSay SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI+" "+A1_NOME
		dbSelectArea("SG1")
		Li++
	EndIf
EndIf

//���������������������������������������������������������Ŀ
//� Imprime a quantidade original quando a quantidade da    �
//� Op for diferente da quantidade ja entregue              �
//�����������������������������������������������������������
If (cAliasTop)->C2_QUJE + (cAliasTop)->C2_PERDA > 0
	@Li,00 PSay STR0017                 //"Qtde Prod.:"
	@Li,11 PSay aSC2Sld(cAliasTop)		PICTURE cPictQuant
	@Li,26 PSay STR0018                 //"Qtde Orig.:"
	@Li,37 PSay (cAliasTop)->C2_QUANT	PICTURE cPictQuant
Else
	@Li,00 PSay STR0019			//"Quantidade :"
	@Li,15 PSay (cAliasTop)->C2_QUANT - (cAliasTop)->C2_QUJE	PICTURE cPictQuant
Endif

@Li,56 PSay STR0020	//"INICIO             F I M"
Li++
@Li,00 PSay STR0021+aArray[1][4]			//"Unid. Medida : "
@Li,42 PSay STR0022+DTOC((cAliasTop)->C2_DATPRI)	//"Prev. : "
@Li,62 PSay STR0022+DTOC((cAliasTop)->C2_DATPRF)	//"Prev. : "
Li++
@Li,00 PSay STR0023+(cAliasTop)->C2_CC				//"C.Custo: "
@Li,42 PSay STR0024+DTOC((cAliasTop)->C2_DATAJI)	//"Ajuste: "
@Li,62 PSay STR0024+DTOC((cAliasTop)->C2_DATAJF)	//"Ajuste: "
Li++
If (cAliasTop)->C2_STATUS == "S"
	@Li,00 PSay STR0025						//"Status: OP Sacramentada"
ElseIf (cAliasTop)->C2_STATUS == "U"
	@Li,00 PSay STR0026						//"Status: OP Suspensa"
ElseIf (cAliasTop)->C2_STATUS $ " N"
	@Li,00 PSay STR0027						//"Status: OP Normal"
EndIf
@Li,42 PSay STR0028							//	"Real  :   /  /      Real  :   /  / "
Li++

If !(Empty((cAliasTop)->C2_OBS))
	@Li,00 PSay STR0029						//"Observacao: "
	For nBegin := 1 To Len(Alltrim((cAliasTop)->C2_OBS)) Step 65
		@li,012 PSay Substr((cAliasTop)->C2_OBS,nBegin,65)
		li++
	Next nBegin
EndIf

@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay cCabec2
Li++
@Li,00 PSay cCabec3
Li++
@Li,00 PSay __PrtFatLine()
Li++

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � RotOper  � Autor � Paulo Boschetti       � Data � 18/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime Roteiro de Operacoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � RotOper()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function RotOper()
Local cSeekWhile := "SG2->(G2_FILIAL+G2_PRODUTO+G2_CODIGO)"
dbSelectArea("SG2")
If a630SeekSG2(1,aArray[1][1],xFilial("SG2")+aArray[1][1]+aArray[1][9],@cSeekWhile) 
	
	cRotOper()
	
	While !Eof() .And. Eval(&cSeekWhile)
		
		dbSelectArea("SH4")
		dbSeek(xFilial()+SG2->G2_FERRAM)
		
		dbSelectArea("SH8")
		dbSetOrder(1)
		dbSeek(xFilial()+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)+SG2->G2_OPERAC)
		lSH8 := IIf(Found(),.T.,.F.)
		
		If lSH8
			While !Eof() .And. SH8->H8_FILIAL+SH8->H8_OP+SH8->H8_OPER == xFilial()+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)+SG2->G2_OPERAC
				ImpRot(lSH8)
				dbSelectArea("SH8")
				dbSkip()
			End
		Else
			ImpRot(lSH8)
		Endif
		
		dbSelectArea("SG2")
		dbSkip()
		
	EndDo
	
Endif

Return Li

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � ImpRot   � Autor � Marcos Bregantim      � Data � 10/07/95 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime Roteiro de Operacoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � ImpRot()                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function ImpRot(lSH8)
Local nBegin

dbSelectArea("SH1")
dbSeek(xFilial()+IIf(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO))

Verilim()

@Li,00 PSay IIF(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO)+" "+SUBS(SH1->H1_DESCRI,1,25)
@Li,33 PSay SG2->G2_FERRAM+" "+SUBS(SH4->H4_DESCRI,1,20)
@Li,61 PSay SG2->G2_OPERAC

For nBegin := 1 To Len(Alltrim(SG2->G2_DESCRI)) Step 16
	@li,064 PSay Substr(SG2->G2_DESCRI,nBegin,16)
	li++

   IF li > 60
		Li := 0
		cRotOper()
	EndIF
Next nBegin

Li+=1
@Li,00 PSay STR0032+IIF(lSH8,DTOC(SH8->H8_DTINI),Space(8))+" "+IIF(lSH8,SH8->H8_HRINI,Space(5))+" "+STR0033+" ____/ ____/____ ___:___"	//"INICIO  ALOC.: "###" INICIO  REAL :"
Li++
@Li,00 PSay STR0034+IIF(lSH8,DTOC(SH8->H8_DTFIM),Space(8))+" "+IIF(lSH8,SH8->H8_HRFIM,Space(5))+" "+STR0035+" ____/ ____/____ ___:___"	//"TERMINO ALOC.: "###" TERMINO REAL :"
Li++
@Li,00 PSay STR0019	//"Quantidade :"
@Li,13 PSay IIF(lSH8,SH8->H8_QUANT,aSC2Sld(cAliasTop)) PICTURE PesqPictQt("H8_QUANT",14)
@Li,28 PSay STR0036	//"Quantidade Produzida :               Perdas :"
Li++
@Li,00 PSay __PrtThinLine()
Li++

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � RotOper  � Autor � Paulo Boschetti       � Data � 18/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime Roteiro de Operacoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � RotOper()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function cRotOper()

Local cCabec1 := SM0->M0_NOME+STR0030	//"              ROTEIRO DE OPERACOES              NRO :"
Local cCabec2 := STR0031					//"RECURSO                       FERRAMENTA               OPERACAO"

Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay cCabec1
@Li,67 PSay (cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay STR0013+aArray[1][1]	//"Produto: "
ImpDescr(aArray[1][2])

//���������������������������������������������������������Ŀ
//� Imprime a quantidade original quando a quantidade da    �
//� Op for diferente da quantidade ja entregue              �
//�����������������������������������������������������������
If (cAliasTop)->C2_QUJE + (cAliasTop)->C2_PERDA > 0
	@Li,00 PSay STR0017                 //"Qtde Prod.:"
	@Li,11 PSay aSC2Sld(cAliasTop)      PICTURE PesqPictQt("C2_QUANT",TamSX3("C2_QUANT")[1])
	@Li,26 PSay STR0018                 //"Qtde Orig.:"
	@Li,37 PSay (cAliasTop)->C2_QUANT   PICTURE PesqPictQt("C2_QUANT",TamSX3("C2_QUANT")[1])
Else
	@Li,00 PSay STR0019            //"Quantidade :"
	@Li,15 PSay aSC2Sld(cAliasTop)	PICTURE PesqPictQt("C2_QUANT",TamSX3("C2_QUANT")[1])
Endif

Li++
@Li,00 PSay STR0023+(cAliasTop)->C2_CC	//"C.Custo: "
Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay cCabec2
Li++
@Li,00 PSay __PrtFatLine()
Li++
Return Li

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � Verilim  � Autor � Paulo Boschetti       � Data � 18/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � Verilim()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 			                                          		  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function Verilim()

//����������������������������������������������������������������������Ŀ
//� Verifica a possibilidade de impressao da proxima operacao alocada na �
//� mesma folha.																			 �
//� 7 linhas por operacao => (total da folha) 66 - 7 = 59					 �
//������������������������������������������������������������������������
IF Li > 59						// Li > 55
	Li := 0
	cRotOper(0)					// Imprime cabecalho roteiro de operacoes
Endif
Return Li

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpDescr � Autor � Marcos Bregantim      � Data � 31.08.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir descricao do Produto.                             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpProd(Void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpDescr(cDescri)
Local nBegin

For nBegin := 1 To Len(Alltrim(cDescri)) Step 50
	@li,025 PSay Substr(cDescri,nBegin,50)
	li++
Next nBegin

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R820Medidas� Autor � Jose Lucas           � Data � 25.01.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o registros referentes as medidas do Pedido Filho. ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � R820Medidas(Void)                                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R820Medidas()
Local aArrayPro := {}, lImpItem := .T.
Local nCntArray := 0,a01 := "",a02 := ""
Local nX:=0,nI:=0,nL:=0,nY:=0
Local cNum:="", cItem:="",lImpCab := .T.
Local nBegin, cProduto:="", cDesc, cDescri, cDescri1, cDescri2

//������������������������������������������������������������Ŀ
//� Imprime Relacao de Medidas do cliente quando OP for gerada �
//� por pedidos de vendas.                                     �
//��������������������������������������������������������������
dbSelectArea("SC5")
dbSetOrder(1)
If dbSeek(xFilial()+(cAliasTop)->C2_PEDIDO,.F.)
	cNum := (cAliasTop)->C2_NUM
	cItem := (cAliasTop)->C2_ITEM
	cProduto := (cAliasTop)->C2_PRODUTO
	//��������������������������������������������������������������Ŀ
	//� Imprimir somente se houver Observacoes.                      �
	//����������������������������������������������������������������
	IF !Empty(SC5->C5_OBSERVA)
		IF li > 53
			@ 03,001 PSay "HUNTER DOUGLAS DO BRASIL LTDA"
			@ 05,008 PSay "CONFIRMACAO DE PEDIDOS  -  "+IIF( SC5->C5_VENDA=="01","ASSESSORIA","DISTRIBUICAO")
			@ 05,055 PSay "No. RMP    : "+SC5->C5_NUM+"-"+SC5->C5_VENDA
			@ 06,055 PSay "DATA IMPRES: "+DTOC(dDataBase)
			li := 07
		EndIF
		li++
		@ li,001 PSay "--------------------------------------------------------------------------------"
		li++
		cDescri := SC5->C5_OBSERVA
		@ li,001 PSay " OBSERVACAO: "
		@ li,018 PSay SubStr(cDescri,1,60)
		For nBegin := 61 To Len(Trim(cDescri)) Step 60
			li++
			cDesc:=Substr(cDescri,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		li++
		cDescri1 := SC5->C5_OBSERV1
		@ li,018 PSay SubStr(cDescri1,1,60)
		For nBegin := 61 To Len(Trim(cDescri1)) Step 60
			li++
			cDesc:=Substr(cDescri1,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		Li++
		cDescri2 := SC5->C5_OBSERV2
		@ li,018 PSay SubStr(cDescri2,1,60)
		For nBegin := 61 To Len(Trim(cDescri2)) Step 60
			li++
			cDesc:=Substr(cDescri2,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		li++
		@ li,001 PSay "--------------------------------------------------------------------------------"
		li++
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Carregar as medidas em array para impressao.                 �
	//����������������������������������������������������������������
	dbSelectArea("SMX")
	dbSetOrder(2)
	dbSeek(xFilial()+cNum+cProduto)
	While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+cProduto
		IF M6_ITEM == cItem
			AADD(aArrayPro,M6_ITEM+" - "+M6_PRODUTO)
			nCntArray++
			cCnt := StrZero(nCntArray,2)
			aArray&cCnt := {}
			While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+cProduto
				If M6_ITEM == cItem
					AADD(aArray&cCnt,{ Str(M6_QUANT,9,2)," PECAS COM ",M6_COMPTO})
				EndIf
				dbSkip()
			End
		Else
			dbSkip()
		EndIF
	End
	cCnt := StrZero(nCntArray+1,2)
	aArray&cCnt := {}
	
	For nX := 1 TO Len(aArrayPro)
		If li > 58
			R820CabMed()
		EndIF
		@ li,009 PSay aArrayPro[nx]
		Li++
		Li++
		dbSelectArea("SMX")
		dbSetOrder(2)
		dbSeek( xFilial()+cNum+Subs(aArrayPro[nX],06,15) )
		While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+Subs(aArrayPro[nX],06,15)
			If li > 58
				R820CabMed()
			EndIF
			IF M6_ITEM == Subs(aArrayPro[nX],1,2)
				@ li,002 PSay M6_QUANT
				@ li,013 PSay "PECAS COM"
				@ li,023 PSay M6_COMPTO
				@ li,035 PSay M6_OBS
				li ++
			EndIF
			dbSkip()
		End
		li++
	Next nX
	@ li,001 PSay "--------------------------------------------------------------------------------"
EndIf
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R820CabMed � Autor � Jose Lucas           � Data � 25.01.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o cabecalho referentes as medidas do Pedido Filho. ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � R820CabMed(Void)                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R820CabMed()
Local cCabec1 := SM0->M0_NOME+STR0037	//"               RELACAO DE MEDIDAS             NRO :"

Li := 0

Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay cCabec1
@Li,67 PSay (cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
Li++
@Li,00 PSay __PrtFatLine()
Li++
Li++
Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaSX1 � Autor � Ricardo Berti         � Data �21/02/2008���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Cria pergunta para o grupo			                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustaSX1()

Local aHelpPor := {	'Opcao para a impressao do produto com  ','rastreabilidade por Lote ou Sub-Lote.  '}
Local aHelpEng := {	'Option to print the product with       ','trackability by Lot or Sub-lot.        '}
Local aHelpSpa := {	'Opcion para la impresion del producto  ','con trazabilidad por Lote o Sublote.   '}

PutSx1("MTR820","12","Imprime Lote/S.Lote ?","�Imprime Lote/Subl. ?","Print Lot/Sublot ?",;
"mv_chc","N",1,0,2,"C","","","","","mv_par12","Sim","Si","Yes","" ,"Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa) 

Return