#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MD_RASTR01 ³ Autor ³ Antonio           ³ Data ³  01/11/2017  ³±±           
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Rastreabilidade PNP2                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MD_RASTR01                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³      ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³          ³ 2017 ³ relatorio personalizado.	                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MD_RASTR01()
                                   
Local aArea := GetArea()
Local oReport, oPerg

Private cPerg   := 'RASTR01A'
Private cAliasX	:= "SF2"

//Executa a pergunta do relatório
oPerg := AdvplPerg():New( cPerg )

//-------------------------------------------------------------------
//    AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
// Parametriza as perguntas
//-------------------------------------------------------------------
oPerg:AddPerg( "Nota Fiscal.: " ,"C",TamSx3("F2_DOC")[1]   , , , "SF2")
oPerg:AddPerg( "Série.......: " ,"C",TamSx3("F2_SERIE")[1] , , , )
oPerg:AddPerg( "(S)intético/(A)nalítico.: " ,"N", 1 , , {"S","A"} , )
oPerg:SetPerg()

If ! Pergunte( cPerg, .T. )
	Return( nil )
EndIf


//Processa o relatorio usando a classe tReport (Release 4)
//Verifica se esta utilizando release 4   

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
//	oReport := UReportDef()
//	oReport:PrintDialog()
	U_UMD_RASTR3()
Else
	U_UMD_RASTR3()
EndIf

RestArea( aArea )

Return



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef() ³ Autor ³                     ³ Data ³ 01,11,17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Definicao do Componente de Impressao do Relatorio           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UReportDef()

Local oReport
Local oSection1	
Local oSection2         
Local oSection3
Local oSection4
Local aOrdem    := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:=TReport():New("MD_RASTR01","Relatório de Rastreabilidade PNP2","RASTR01A",{|oReport| PrintReport(oReport)},"Será impresso de acordo com os parametros solicitados pelo usuario")
oReport:SetLandscape()

/*Aadd( aOrdem, STR0004)	// "Matricula"
Aadd( aOrdem, STR0005)	// "Nome"
Aadd( aOrdem, STR0006)	// "Centro de Custo" 
Aadd( aOrdem, STR0007)	// "Cargo" 
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Primeira Secao: Nota Fiscal de Saida        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
oSection1 := TRSection():New(oReport,"Dados da NF de Saida",{"SF2","SA1"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection1:SetTotalInLine(.F.)  
oSection1:ShowHeader(.T.) 	//Imprime Cabecalho da Secao
oSection1:SetHeaderBreak()   

TRCell():New(oSection1,"F2_FILIAL" ,"SF2")
TRCell():New(oSection1,"F2_DOC"    ,"SF2")
TRCell():New(oSection1,"F2_SERIE"  ,"SF2")
TRCell():New(oSection1,"F2_CLIENTE","SF2")
TRCell():New(oSection1,"A1_NOME"   ,"SA1")
TRCell():New(oSection1,"F2_LOJA"   ,"SF2")
TRCell():New(oSection1,"F2_EMISSAO","SF2")
TRCell():New(oSection1,"D2_PEDIDO" ,"SD2")
TRCell():New(oSection1,"F2_VALBRUT","SF2")

//TRPosition():New(oSection1,"SI3",1,{|| xFilial("SI3", (cAliasX)->RA_FILIAL) + (cAliasX)->RA_CC})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Segunda Secao: Itens Nota Fiscal de Saida ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1,"Itens da Nf de Saida",{"SF2","SD2","SB1"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection2:SetTotalInLine(.F.)  
oSection2:ShowHeader(.T.) 	//Imprime Cabecalho da Secao
oSection2:SetHeaderBreak()
oSection2:SetLeftMargin(3)	//Identacao da Secao      

TRCell():New(oSection2,"D2_ITEM "  ,"SD2")
TRCell():New(oSection2,"D2_COD"    ,"SD2")
TRCell():New(oSection2,"B1_DESC"   ,"SB1")
TRCell():New(oSection2,"D2_UM"     ,"SD2")
TRCell():New(oSection2,"D2_QUANT"  ,"SD2",,"@E 999,999.99")
TRCell():New(oSection2,"D2_PRCVEN" ,"SD2",,"@E 999,999.99")
TRCell():New(oSection2,"D2_TOTAL"  ,"SD2",,"@E 999,999.99")

//TRPosition():New(oSection2,"SQV",1,{|| xFilial("SQV",SQ8->Q8_FILIAL) + SQ8->Q8_FATOR + SQ8->Q8_GRAU })

oSection2:SetLineStyle() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Terceira Secao: Plano MP                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection3 := TRSection():New(oSection2,"Itens do Plano MP",{"SC2"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection3:SetTotalInLine(.F.)  
oSection3:ShowHeader(.T.) 	//Imprime Cabecalho da Secao
oSection3:SetHeaderBreak()
oSection3:SetLeftMargin(3)	//Identacao da Secao      

TRCell():New(oSection3,"C2_PLANOMP"  ,"SC2")
//TRCell():New(oSection3,"D4_PRODUTO"  ,"SD4")
//TRCell():New(oSection3,"D4_QTDEORI"    ,"SD4")
//TRCell():New(oSection3,"D4_LOTECTL"  ,"SD4")
TRCell():New(oSection3,"C2_OPMIDO"   ,"SC2")

//TRCell():New(oSection3,"D1_DOC"      ,"SD1")
//TRCell():New(oSection3,"D1_SERIE"    ,"SD1")
//TRCell():New(oSection3,"D1_LOTEFOR"  ,"SD1")

//TRPosition():New(oSection3,"SC2",11,{|| xFilial("SC2",SC2->C2_FILIAL) + SC2->C2_OPMIDO })


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Terceira Secao: Materiais Consumidos MP   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection4 := TRSection():New(oSection3,"Itens do Plano Couro",{"SC2"/*,"SD4"*/},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection4:SetTotalInLine(.F.)  
oSection4:ShowHeader(.T.) 	//Imprime Cabecalho da Secao
oSection4:SetHeaderBreak()
oSection4:SetLeftMargin(3)	//Identacao da Secao      

TRCell():New(oSection4,"C2_PLANOCO"  ,"SC2")
//TRCell():New(oSection4,"D4_PRODUTO"  ,"SD4")
//TRCell():New(oSection4,"D4_QTDEORI"  ,"SD4")
//TRCell():New(oSection4,"D4_LOTECTL"  ,"SD4")


//TRCell():New(<oParent>, <cName>, [ <cAlias> ], [ <cTitle> ],;
//							[ <cPicture> ], [ <nSize> ], [ <.lPixel.> ], [ <bBlock> ],;
//							[ <"cAlign"> ], [ <.lLineBreak.> ], [ <"cHeaderAlign"> ], [ <.lCellBreak.> ],;
//							[ <nColSpace> ], [<.lAutoSize.>], [ <nClrBack> ], [ <nClrFore> ])


Return oReport   
      

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef() ³ Autor ³ Eduardo Ju          ³ Data ³ 28.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Relatorio                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)  
Local oSection3 := oReport:Section(1):Section(1):Section(1) 
Local oSection4 := oReport:Section(1):Section(1):Section(1):Section(1)  

Local cFiltro 	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ MV_PAR01        //  Nota Fiscal:                             ³ 
//³ MV_PAR02        //  Serie                                    ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// filtro do relatorio

	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	MakeSqlExpr("RASXXX")
	cAliasX	:= GetNextAlias()

	oSection3:BeginQuery()

	cOrdem := "%F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,D2_COD, D2_ITEM%"

	cCond	:= ""

	//³ MV_PAR01        //  Filial                                   ³ 
	If !Empty(MV_PAR01)
		cCond += MV_PAR01 + MV_PAR02 
	EndIf                 

	BeginSql alias cAliasX  //"SF2"              

	SELECT F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_EMISSAO, F2_VALBRUT, D2_COD, D2_ITEM, B1_DESC, D2_UM, D2_QUANT,
	       D2_PRCVEN, D2_TOTAL, D2_PEDIDO , C5_X_PLANO
	FROM %table:SF2% SF2 

	JOIN %Table:SD2% SD2 
	ON SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA
	AND SD2.D2_FILIAL = %xFilial:SD2% AND SD2.%notDel%

	JOIN %Table:SC5% SC5 
	ON SC5.C5_NOTA = SF2.F2_DOC AND SC5.C5_SERIE = SF2.F2_SERIE AND SC5.C5_CLIENTE = SF2.F2_CLIENTE AND SC5.C5_LOJACLI = SF2.F2_LOJA
	AND SC5.C5_FILIAL = %xFilial:SC5% AND SC5.%notDel%         

	JOIN %Table:SC2% SC2 
	ON SC2.C2_OPMIDO = C5_X_PLANO AND SC2.C2_FILIAL = %xFilial:SC2% AND SC2.%notDel%         

	JOIQN %Table:SB1% SB1 
	ON SB1.B1_COD = SD2.D2_COD AND SB1.B1_FILIAL = %xFilial:SB1% AND SB1.%notDel%
	
	WHERE	SF2.F2_DOC+SF2.F2_SERIE = %exp:cCond% AND
			SF2.%notDel% AND
			SF2.F2_FILIAL = %xFilial:SF2% 
			ORDER BY %exp:cOrdem%

	EndSql
//	END REPORT QUERY oSection3 //PARAM MV_PAR01, MV_PAR02

	oSection2:EndQuery()

dbSelectArea( cAliasX )                              
   		    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Condicao para Impressao   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//oSection3:SetRelation({|| xFilial("SC2", xFilial("SC2") + (cAliasX)->C5_X_PLANO  } ,"SC2",11,.T.)
//oSection4:SetRelation({|| xFilial("SD4", (cAliasX)->F2_FILIAL) + (cAliasX)->C5_X_PLANO  } ,"SD4",3,.T.)
//oSection3:SetParentFilter({|cParam| xFilial("SC5") + SC5->C5_X_PLANO == cParam},{|| xFilial("SC5") + (cAliasX)->C5_X_PLANO })

//oSection2:SetRelation({|| xFilial("SC2", xFilial("SC2")) + (cAliasX)->C5_X_PLANO  } ,"SC2",11,.T.)
//oSection2:SetParentFilter({|cParam| SC2->C2_OPMIDO == cParam},{|| (cAliasX)->C5_X_PLANO })

		                              
oReport:SetMeter((cAliasX)->(LastRec()))	
oSection1:Print() //Imprimir 

Return Nil       




 
//Relatorio R3 ->
//////////////////////////////////////////////////////////////////////////////////////////
// Função: MD_RASTR3() Autor: Antonio C Damaceno - Data: 10/11/17
// Objetivo: Relatorio de Rastreabilidade

User Function UMD_RASTR3()

Local cString 	:= "SF2"
Local cDesc1  	:= IIf( MV_PAR03 == 2 /*"A"*/,"Relatório de Rastreabilidade (A)nalítico - PNP2","Relatório de Rastreabilidade (S)intético - PNP2")
Local cDesc2  	:= "Será impresso de acordo com os parâmetros solicitados pelo"
Local cDesc3  	:= " usuário."
//Local aOrd    	:= {"Matricula","Nome","Centro Custo","Cargo"}

Private aReturn  := {"Zebrado",1,"Administração",2,2,1,"",1 }
Private NomeProg := "MD_RASTR01"
Private nLastKey := 0
Private Titulo   := IIf( MV_PAR03 == 2 /*'A'*/ ,"Relatório de Rastreabilidade (A)nalítico - PNP2","Relatório de Rastreabilidade (S)intético - PNP2")
Private Colunas  := 132 
Private cCabec1  := ""
Private cCabec2  := ""
Private cCabec3  := ""
Private cCabec4  := ""
Private cCabec5  := ""
Private cCabec6  := ""
Private nLin     := 60
Private nTamanho := "G" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
m_pag    := 1

wnrel:="MD_RASTR01"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,/*aOrd*/,,nTamanho)

If nLastKey = 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
EndIf

RptStatus({|lEnd| Rastr01Imp(@lEnd,wnRel,cString)},Titulo)

Return
                        

//////////////////////////////////////////////////////
//Interface de Impressão - 17/11/17
//////////////////////////////////////////////////////
Static Function Rastr01Imp(lEnd,wnRel,cString)
                                              
	Local cQuery      := ""
	Local cQuery1     := ""
	Local cQuery2     := ""
	Local cQuery3     := ""
	Local cAlTMP      := GetNextAlias()
	Local cAlTMP1     := GetNextAlias()
	Local cAlTMP2     := GetNextAlias()
	Local cAlTMP3     := GetNextAlias()
	Local cTdCabec1A  := '( '
	Local cTdCabec1B  := '( '
	Local cTdCabec1C  := '( '
	Local cTdCabec5A  := '( '
	Local cTdCabec5B  := '( '
	Local nTdCabec    := 1
	Local aOPMIDO     := {}
	Local cTOPMIDO    := ""
	Local aAlTMP2     := {}
	Local nI          := 0 
	Local cD4_COD     := ""
	Local cB1_DESC    := ""
	Local cD1_UM      := ""
	Local cD4_X_LOTE  := ""
	Local cD4_X_DTVLL := ""
	Local cD1_DOC     := ""
	Local cD1_SERIE   := ""
	Local cD1_LOTEFOR := ""
	Local cCodPro     := ""
	Local lImpre

	cQuery := " SELECT Y.F2_DOC, Y.F2_SERIE, Y.F2_CLIENTE, Y.F2_LOJA, Y.F2_EMISSAO, Y.C2_OPMIDO, Y.C2_PLANOMP, Y.C2_PLANOCO "
	cQuery += " FROM ( "
	cQuery += " SELECT SF2.F2_DOC,    SF2.F2_SERIE,   SF2.F2_CLIENTE, SF2.F2_LOJA,   SF2.F2_EMISSAO, SF2.F2_VALBRUT,  "
	cQuery += "        SD2.D2_COD,    SD2.D2_ITEM,    SB1.B1_DESC,    SD2.D2_UM,     SD2.D2_QUANT,   "       //SD2.D2_PRCVEN,  SD2.D2_TOTAL,   "
	cQuery += "        SD2.D2_PEDIDO, CBL.CBL_CODETI, CB0.CB0_OP,     SC2.C2_OPMIDO, SC2.C2_PLANOMP, SC2.C2_PLANOCO,  "
	cQuery += "        SD4.D4_COD,    SD4.D4_LOTECTL, SD4.D4_DTVALID, SD1.D1_DOC,    SD1.D1_SERIE,   SD1.D1_LOTEFOR	  "
	cQuery += " FROM " + RetSqlName("SF2") + " SF2 "
	cQuery += " JOIN " + RetSqlName("SD2") + " SD2 "
	cQuery += "		ON  SD2.D2_DOC     = SF2.F2_DOC               AND SD2.D2_SERIE   = SF2.F2_SERIE "
	cQuery += "		AND SD2.D2_CLIENTE = SF2.F2_CLIENTE           AND SD2.D2_LOJA    = SF2.F2_LOJA  "
	cQuery += "		AND SD2.D2_FILIAL  = '" + xFilial("SD2") + "' AND SD2.D_E_L_E_T_ = ' '          "
	cQuery += " JOIN " + RetSqlName("CBL") + " CBL "
	cQuery += "		ON  CBL.CBL_DOC    = SF2.F2_DOC               AND CBL.CBL_SERIE  = SF2.F2_SERIE "
	cQuery += "     AND CBL.CBL_CLIENT = SF2.F2_CLIENTE           AND CBL.CBL_LOJA   = SF2.F2_LOJA  "
	cQuery += "     AND CBL.CBL_FILIAL = '" + xFilial("CBL") + "' AND CBL.D_E_L_E_T_ = ' '          "
	cQuery += " JOIN " + RetSqlName("CBK") + " CBK "
	cQuery += "		ON  CBK.CBK_DOC    = SF2.F2_DOC               AND CBK.CBK_SERIE  = SF2.F2_SERIE " 
	cQuery += "     AND CBK.CBK_CLIENT = SF2.F2_CLIENTE           AND CBK.CBK_LOJA   = SF2.F2_LOJA  " 
	cQuery += "     AND CBK.CBK_FILIAL = '" + xFilial("CBK") + "' AND CBK.D_E_L_E_T_ = ' ' "
	cQuery += " JOIN " + RetSqlName("CB0") + " CB0 "
	cQuery += "		ON  CB0.CB0_PALLET = CBL.CBL_CODETI "
	cQuery += "     AND CB0.CB0_FILIAL = '" + xFilial("CBL") + "' AND CB0.D_E_L_E_T_ = ' ' "
	cQuery += " JOIN " + RetSqlName("SC2") + " SC2 "
	cQuery += "		ON  SC2.C2_NUM     = CB0.CB0_OP "
	cQuery += "		AND SC2.C2_FILIAL  = '" + xFilial("SC2") + "' AND SC2.D_E_L_E_T_ = ' ' "
	cQuery += " JOIN " + RetSqlName("SB1") + " SB1 "
	cQuery += "		ON SB1.B1_COD      = SD2.D2_COD "
	cQuery += "		AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "	JOIN " + RetSqlName("SD4") + " SD4 "
	cQuery += "		ON SUBSTRING(SD4.D4_OP,1,6) = SC2.C2_NUM "
	cQuery += "	    AND SD4.D4_FILIAL  = '" + xFilial("SD4") + "' AND SD4.D_E_L_E_T_ = ' ' "
	cQuery += "	JOIN " + RetSqlName("SD1") + " SD1 "
	cQuery += "		ON SD1.D1_COD = SD4.D4_COD AND SD4.D4_LOTECTL = SD1.D1_LOTECTL "
	cQuery += "	    AND SD1.D1_FILIAL  = '" + xFilial("SD1") + "' AND SD1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE SF2.F2_DOC       = '" + MV_PAR01 + "' AND SF2.F2_SERIE   = '" + MV_PAR02 + "' "
	cQuery += "		AND SF2.D_E_L_E_T_ = ' '                AND SF2.F2_FILIAL  = '" + xFilial("SF2") + "' "
	cQuery += "		AND SUBSTRING(SD4.D4_COD,1,3) <> 'MOD'  AND SD4.D4_LOTECTL <> ' ' "
	cQuery += "		AND CBK.CBK_STATUS = '2' "
	cQuery += " GROUP BY SF2.F2_DOC,     SF2.F2_SERIE,   SF2.F2_CLIENTE, SF2.F2_LOJA,    SF2.F2_EMISSAO, SF2.F2_VALBRUT, "
	cQuery += "          SD2.D2_COD,     SD2.D2_ITEM,    SB1.B1_DESC,    SD2.D2_UM,      SD2.D2_QUANT,   SD2.D2_PEDIDO,  "
	cQuery += "          CBL.CBL_CODETI, CB0.CB0_OP,     SC2.C2_OPMIDO,  SC2.C2_PLANOMP, SC2.C2_PLANOCO, SD4.D4_COD,     "
	cQuery += "          SD4.D4_LOTECTL, SD4.D4_DTVALID, SD1.D1_DOC,     SD1.D1_SERIE,   SD1.D1_LOTEFOR	"
  	cQuery += " ) AS Y "
	cQuery += " GROUP BY Y.F2_DOC, Y.F2_SERIE, Y.F2_CLIENTE, Y.F2_LOJA, Y.F2_EMISSAO, Y.C2_OPMIDO, Y.C2_PLANOMP, Y.C2_PLANOCO "
	cQuery += " ORDER BY Y.F2_DOC, Y.F2_SERIE, Y.F2_CLIENTE, Y.F2_LOJA, Y.F2_EMISSAO, Y.C2_OPMIDO, Y.C2_PLANOMP, Y.C2_PLANOCO"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlTMP,.T.,.T.) 

	SetRegua((cAlTMP)->(RecCount()))

	While (cAlTMP)->(! Eof())
        
		(cAlTMP)->(IncRegua())

		If nTdCabec <= 8
			cTdCabec1A += AllTrim((cAlTMP)->C2_OPMIDO) + " / "
		ElseIF nTdCabec > 8 .AND. nTdCabec < 17
			cTdCabec1B += AllTrim((cAlTMP)->C2_OPMIDO) + " / "
		Else
			cTdCabec1C += AllTrim((cAlTMP)->C2_OPMIDO) + " / "
    	EndIf

		aadd(aOPMIDO,(cAlTMP)->C2_OPMIDO)

		cTdCabec5A +=  AllTrim((cAlTMP)->C2_PLANOMP) + " / "
		cTdCabec5B +=  AllTrim((cAlTMP)->C2_PLANOCO) + " / "

		nTdCabec++

		(cAlTMP)->(dbSkip())
	EndDo

	cTOPMIDO := "'"
	For nI:= 1 to Len(aOPMIDO)
		cTOPMIDO += aOPMIDO[nI] + "','"
	Next
	cTOPMIDO += "'"

	cTdCabec1A += ')'
	cTdCabec1B += ')'
	cTdCabec1C += ')'
	cTdCabec5A += ')'
	cTdCabec5B += ')'

            //           1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9
			//  1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	cCabec1 := "DADOS DA NF DE SAIDA"
	cCabec1A:= "PLANOS DE COSTURA - "+ cTdCabec1A
	cCabec2 := "NF Saida/Série      Cliente/Loja                                                   Emissão      Pedido       Valor Bruto  "
	cCabec3 := "ITENS DA NF SAIDA"
	cCabec4 := "MODELO                                                                          UM               Quantidade"
	cCabec5 := "ITENS: PLANO (MP) - "    + AllTrim(cTdCabec5A)
	cCabec6 := "       PLANO (Couro) - " + AllTrim(cTdCabec5B)

	cQuery1 := " SELECT SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_CLIENTE, SF2.F2_LOJA, SF2.F2_EMISSAO, SF2.F2_VALBRUT, "
	cQuery1 += "	    SD2.D2_COD, SD2.D2_ITEM,  SB1.B1_DESC,    SD2.D2_UM,   SD2.D2_QUANT,   SD2.D2_PEDIDO   "
	cQuery1 += " FROM " + RetSqlName("SF2") + " SF2 "
	cQuery1 += " JOIN " + RetSqlName("SD2") + " SD2 "
	cQuery1 += "		ON  SD2.D2_DOC     = SF2.F2_DOC               AND SD2.D2_SERIE   = SF2.F2_SERIE "
	cQuery1 += "		AND SD2.D2_CLIENTE = SF2.F2_CLIENTE           AND SD2.D2_LOJA    = SF2.F2_LOJA  "
	cQuery1 += "		AND SD2.D2_FILIAL  = '" + xFilial("SD2") + "' AND SD2.D_E_L_E_T_ = ' '          "
	cQuery1 += " JOIN " + RetSqlName("SB1") + " SB1 "
	cQuery1 += "		ON SB1.B1_COD      = SD2.D2_COD "
	cQuery1 += "		AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = ' ' "
	cQuery1 += " WHERE      SF2.F2_DOC     = '" + MV_PAR01 + "'       AND SF2.F2_SERIE   = '" + MV_PAR02 + "' "
	cQuery1 += "		AND SF2.D_E_L_E_T_ = ' '                      AND SF2.F2_FILIAL  = '" + xFilial("SF2") + "' "
	cQuery1 += " GROUP BY SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_CLIENTE, SF2.F2_LOJA, SF2.F2_EMISSAO, SF2.F2_VALBRUT, "
	cQuery1 += "	      SD2.D2_COD, SD2.D2_ITEM,  SB1.B1_DESC,    SD2.D2_UM,   SD2.D2_QUANT,   SD2.D2_PEDIDO   "
	cQuery1 += " ORDER BY SD2.D2_ITEM,SD2.D2_COD,  SB1.B1_DESC,    SD2.D2_UM"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlTMP1,.T.,.T.) 

	SetRegua((cAlTMP1)->(RecCount()))

	If MV_PAR03 == 2 //'A'
		cCabec7 := "Cód/Descrição                                                                   UM                 Qtde      Lote Midori    Data Validade    NF Entrada/Serie     Lote Fornecedor       Ordem Produção"
	Else
		cCabec7 := "Cód/Descrição                                                                   UM                 Qtde      Lote Midori    Data Validade    NF Entrada/Serie     Lote Fornecedor"
	EndIf

	cItem:=""

	While (cAlTMP1)->(! Eof())
        
		(cAlTMP1)->(IncRegua())

		If lEnd
			@Prow()+1,0 PSAY "Cancelado Pelo Operador!!!"
			Exit
		EndIf

		If nLin > 55
			Cabec(Titulo,"","",Nomeprog,nTamanho,15)
			nLin:=6
//	cCabec1 := "DADOS DA NF DE SAIDA"
			@ nLin,000 Psay cCabec1
			nLin:=nLin+1
			@ nLin,000 Psay cCabec1A
			If !Empty(cTdCabec1B)
				nLin:=nLin+1
				@ nLin,000 Psay Space(20) + cTdCabec1B
        	EndIf
			If !Empty(cTdCabec1C)
				nLin:=nLin+1
				@ nLin,000 Psay Space(20) + cTdCabec1C
        	EndIf
			nLin:=nLin+2
			//	cCabec2 := "NF Saida/Série      Cliente/Loja                                                   Emissão      Pedido       Valor Bruto  "
			@ nLin,000 Psay cCabec2
			nLin:=nLin+1
			@ nLin,000 Psay Repli('-', 200)
			nLin:=nLin+1
			@ nLin,000 Psay (cAlTMP1)->F2_DOC + " " + (cAlTMP1)->F2_SERIE
			@ nLin,021 Psay (cAlTMP1)->F2_CLIENTE + " " +(cAlTMP1)->F2_LOJA + " " + Posicione("SA1",1,xFilial("SA1")+(cAlTMP1)->F2_CLIENTE+(cAlTMP1)->F2_LOJA,"A1_NOME")
			@ nLin,084 Psay StoD((cAlTMP1)->F2_EMISSAO)
			@ nLin,097 Psay (cAlTMP1)->D2_PEDIDO
			@ nLin,105 Psay Transform((cAlTMP1)->F2_VALBRUT,"@E 999,999,999.99")
			nLin:=nLin+2

			//	cCabec5 := "ITENS: PLANO (MP) - "    + AllTrim(cTdCabec5A)
			@ nLin,000 Psay cCabec5
			nLin:=nLin+1
			//	cCabec6 := "       PLANO (Couro) - " + AllTrim(cTdCabec5B)
			@ nLin,000 Psay cCabec6
			//nLin:=nLin+2
			//		cCabec7 := "Produto                                                                        UM            Qtde            Lote Midori    Data Validade    NF Entrada/Serie     Lote Fornecedor       Ordem Produção"
			nLin:=nLin+1
			@ nLin,000 Psay Repli('-', 200)
			nLin:=nLin+1
			//	cCabec3 := "ITENS DA NF SAIDA"
			@ nLin,000 Psay cCabec3
			nLin:=nLin+2
		EndIf

		If AllTrim((cAlTMP1)->D2_ITEM) <> cItem 
			//	cCabec4 := "Produto                                                                        UM             Quantidade"
			@ nLin,000 Psay cCabec4
			nLin:=nLin+1
			@ nLin,000 Psay Repli('-', 200)
			nLin:=nLin+1

			@ nLin,000 Psay AllTrim((cAlTMP1)->D2_ITEM) + " " + AllTrim((cAlTMP1)->D2_COD) + " " + Posicione("SB1",1,xFilial("SB1")+(cAlTMP1)->D2_COD,"B1_DESC")
			@ nLin,080 Psay (cAlTMP1)->D2_UM
			@ nLin,090 Psay Transform((cAlTMP1)->D2_QUANT,"@E 999,999,999.99")
			nLin:=nLin+2
			cItem:=(cAlTMP1)->D2_ITEM

			cQuery2 := " 	SELECT SF2.F2_DOC,     SF2.F2_SERIE, SF2.F2_CLIENTE, SF2.F2_LOJA,    "
			cQuery2 += " 	       SD4.D4_COD,   SB1.B1_DESC,    SD4.D4_X_LOTE,  SD4.D4_X_DTVLL,"
			cQuery2 += "	       SD4.D4_QTDEORI, SD1.D1_DOC,   SD1.D1_SERIE,   SD1.D1_UM, SD1.D1_LOTEFOR "      //SD1.D1_LOTEFOR,
			
			cQuery2 += " 	FROM " + RetSqlName("SF2") + " SF2 "
		
			cQuery2 += " 	JOIN " + RetSqlName("CBL") + " CBL "
			cQuery2 += "             ON  CBL.CBL_DOC    = SF2.F2_DOC               AND CBL.CBL_SERIE  = SF2.F2_SERIE "
			cQuery2 += "             AND CBL.CBL_CLIENT = SF2.F2_CLIENTE           AND CBL.CBL_LOJA   = SF2.F2_LOJA  "
			cQuery2 += "             AND CBL.CBL_FILIAL = '" + xFilial("CBL") + "' AND CBL.D_E_L_E_T_ = ' '          "
		
			cQuery2 += " 	JOIN " + RetSqlName("CBK") + " CBK "
			cQuery2 += "		     ON  CBK.CBK_DOC    = SF2.F2_DOC               AND CBK.CBK_SERIE  = SF2.F2_SERIE " 
			cQuery2 += "             AND CBK.CBK_CLIENT = SF2.F2_CLIENTE           AND CBK.CBK_LOJA   = SF2.F2_LOJA  " 
			cQuery2 += "             AND CBK.CBK_FILIAL = '" + xFilial("CBK") + "' AND CBK.D_E_L_E_T_ = ' ' "

			cQuery2 += " 	JOIN " + RetSqlName("CB0") + " CB0 "
			cQuery2 += "		     ON  CB0.CB0_PALLET = CBL.CBL_CODETI "
			cQuery2 += "             AND CB0.CB0_FILIAL = '" + xFilial("CBL") + "' AND CB0.D_E_L_E_T_ = ' '          "

			cQuery2 += "	JOIN " + RetSqlName("SD4") + " SD4 "
			cQuery2 += "		     ON SUBSTRING(SD4.D4_OP,1,6) = CB0.CB0_OP "
			cQuery2 += "	         AND SD4.D4_FILIAL  = '" + xFilial("SD4") + "' AND SD4.D_E_L_E_T_ = ' '   "

			cQuery2 += " 	JOIN " + RetSqlName("SC2") + " SC2 "
			cQuery2 += "		     ON  SC2.C2_NUM     = SUBSTRING(SD4.D4_OP,1,6) "
			cQuery2 += "		     AND SC2.C2_FILIAL  = '" + xFilial("SC2") + "' AND SC2.D_E_L_E_T_ = ' ' "
		 		
			cQuery2 += " 	JOIN " + RetSqlName("SB1") + " SB1 "
			cQuery2 += "		     ON SB1.B1_COD      = SD4.D4_COD "
			cQuery2 += "		     AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = ' ' "
		
			cQuery2 += "	JOIN " + RetSqlName("SD1") + " SD1 "
			cQuery2 += "		     ON SD1.D1_COD = SD4.D4_COD AND SD4.D4_X_LOTE = SD1.D1_LOTECTL "
			cQuery2 += "	         AND SD1.D1_FILIAL  = '" + xFilial("SD1") + "'  AND SD1.D_E_L_E_T_ = ' '   "

			cQuery2 += " 	WHERE SF2.F2_DOC       = '" + MV_PAR01 + "' AND SF2.F2_SERIE   = '" + MV_PAR02 + "'       "
			cQuery2 += "		     AND SF2.D_E_L_E_T_ = ' '                AND SF2.F2_FILIAL  = '" + xFilial("SF2") + "' "
			cQuery2 += "             AND SD4.D4_PRODUTO        = '" + AllTrim((cAlTMP1)->D2_COD) + "' "
			cQuery2 += "		     AND SUBSTRING(SD4.D4_COD,1,3) <> 'MOD'  AND SD4.D4_X_LOTE <> ' ' "
			cQuery2 += "		     AND CBK.CBK_STATUS = '2' "
		
			cQuery2 += " 	GROUP BY SF2.F2_DOC,     SF2.F2_SERIE,   SF2.F2_CLIENTE, SF2.F2_LOJA, "
			cQuery2 += " 	         SD4.D4_COD,     SB1.B1_DESC,  SD4.D4_X_LOTE ,"
			cQuery2 += "	         SD4.D4_X_DTVLL, SD4.D4_QTDEORI, SD1.D1_DOC,     SD1.D1_SERIE, SD1.D1_UM, SD1.D1_LOTEFOR "   //SD1.D1_LOTEFOR,
                                     
			cQuery2 += " 	ORDER BY SD4.D4_COD,  SD4.D4_X_LOTE "			

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAlTMP2,.T.,.T.) 
		
			SetRegua((cAlTMP2)->(RecCount()))                          //TRB->(RECCOUNT())
//		    cItemLote:="" 
		    aAlTMP2:={}

			While (cAlTMP2)->(! Eof())
		
				(cAlTMP2)->(IncRegua())
		        If  cD4_COD		== AllTrim((cAlTMP2)->D4_COD)  .And.;
					cB1_DESC	== (cAlTMP2)->B1_DESC          .And.;
					cD1_UM		== (cAlTMP2)->D1_UM            .And.;
					cD4_X_LOTE	== (cAlTMP2)->D4_X_LOTE        .And.;
					cD4_X_DTVLL	== (cAlTMP2)->D4_X_DTVLL       .And.;
					cD1_DOC		== (cAlTMP2)->D1_DOC           .And.;
					cD1_SERIE	== (cAlTMP2)->D1_SERIE         .And.;
					cD1_LOTEFOR	<> (cAlTMP2)->D1_LOTEFOR
 
					aAdd(aAlTMP2,{ " "              ,;       //1
					               " "              ,;       //2
					               " "              ,;       //3
			                       " "              ,;       //4
			                       StoD(" ")        ,;       //5
			                       " "              ,;       //6
			                       " "              ,;       //7
								   (cAlTMP2)->D1_LOTEFOR }) //8
				Else

/*				ElseIf  cD4_COD		<> AllTrim((cAlTMP2)->D4_COD)  .And.;
						cB1_DESC	<> (cAlTMP2)->B1_DESC          .And.;
						cD1_UM		<> (cAlTMP2)->D1_UM            .And.;
						cD4_X_LOTE	<> (cAlTMP2)->D4_X_LOTE        .And.;
						cD4_X_DTVLL	<> (cAlTMP2)->D4_X_DTVLL       .And.;
						cD1_DOC		<> (cAlTMP2)->D1_DOC           .And.;
						cD1_SERIE	<> (cAlTMP2)->D1_SERIE         .And.;
						cD1_LOTEFOR	<> (cAlTMP2)->D1_LOTEFOR*/
				
					aAdd(aAlTMP2,{ AllTrim((cAlTMP2)->D4_COD)    ,;       //1
					                       (cAlTMP2)->B1_DESC    ,;       //2
					                       (cAlTMP2)->D1_UM      ,;       //3
			                               (cAlTMP2)->D4_X_LOTE  ,;       //4
			                          StoD((cAlTMP2)->D4_X_DTVLL),;       //5
			                       AllTrim((cAlTMP2)->D1_DOC)    ,;       //6
			                               (cAlTMP2)->D1_SERIE   ,;       //7
									       (cAlTMP2)->D1_LOTEFOR    })    //8

				EndIf

				cD4_COD		:= AllTrim((cAlTMP2)->D4_COD)
				cB1_DESC	:= (cAlTMP2)->B1_DESC
				cD1_UM		:= (cAlTMP2)->D1_UM
				cD4_X_LOTE	:= (cAlTMP2)->D4_X_LOTE
				cD4_X_DTVLL	:= (cAlTMP2)->D4_X_DTVLL
				cD1_DOC		:= (cAlTMP2)->D1_DOC
				cD1_SERIE	:= (cAlTMP2)->D1_SERIE
				cD1_LOTEFOR	:= (cAlTMP2)->D1_LOTEFOR
						       
				(cAlTMP2)->(IncRegua())
				(cAlTMP2)->(dbSkip())
			EndDo                            

			cD4_COD		:= " "
			cB1_DESC	:= " "
			cD1_UM		:= " "
			cD4_X_LOTE	:= " "
			cD4_X_DTVLL	:= " "
			cD1_DOC		:= " " 
			cD1_SERIE	:= " " 
			cD1_LOTEFOR	:= " "
	
			SetRegua((cAlTMP2)->(RecCount()))                          //TRB->(RECCOUNT())

			lImpre  := .T.
			cCodPro :=""
		
			For nI := 1 to Len(aAlTMP2)
		
				(cAlTMP2)->(IncRegua())
		
				If lEnd
					@Prow()+1,0 PSAY "Cancelado Pelo Operador!!!"
					Exit
				EndIf
		
				If nLin > 55 .Or. lImpre == .T.
		
					If nLin > 55
						Cabec(Titulo,"","",Nomeprog,nTamanho,15)
						nLin:=5
					EndIf	
		
					nLin:=nLin+1
					//	cCabec5 := "ITENS: PLANO (MP) - "    + AllTrim(cTdCabec5A)
					//					@ nLin,000 Psay cCabec5
					//					nLin:=nLin+1
					//	cCabec6 := "       PLANO (Couro) - " + AllTrim(cTdCabec5B)
					//					@ nLin,000 Psay cCabec6
					//					nLin:=nLin+2
					//		cCabec7 := "Produto                                                                        UM            Qtde            Lote Midori    Data Validade    NF Entrada/Serie     Lote Fornecedor       Ordem Produção"
					@ nLin,005 Psay cCabec7
					nLin:=nLin+1
					@ nLin,005 Psay Repli('-', 200)
					nLin:=nLin+1
					lImpre := .F.
				EndIf	
		
				@ nLin,005 Psay aAlTMP2[nI,1] + " " + aAlTMP2[nI,2]
				@ nLin,085 Psay aAlTMP2[nI,3]
		
				cQuery3 := " SELECT WSD4.D4_COD, WSD4.D4_X_LOTE, SUM(WSD4.D4_QTDEORI) D4_QTDTOT " 
				cQuery3 += " FROM " + RetSqlName("SD4") + " WSD4 "  
				cQuery3 += " JOIN " + RetSqlName("SC2") + " WSC2 ON WSC2.C2_NUM     = SUBSTRING(WSD4.D4_OP,1,6) "
				cQuery3 += "                                   AND WSC2.C2_FILIAL  = '" + xFilial("SC2") + "' AND WSC2.D_E_L_E_T_ = ' ' "   
				cQuery3 += " AND WSC2.C2_OPMIDO IN(" + cTOPMIDO + ") "
				cQuery3 += " WHERE WSD4.D4_COD       = '" + aAlTMP2[nI,1] + "' AND WSD4.D4_X_LOTE = '" + aAlTMP2[nI,4] + "' " 
				cQuery3 += "	         AND WSD4.D4_FILIAL  = '" + xFilial("SD4") + "' AND WSD4.D_E_L_E_T_ = ' '   "
				cQuery3 += " GROUP BY WSD4.D4_COD, WSD4.D4_X_LOTE "
				cQuery3 += " ORDER BY WSD4.D4_COD, WSD4.D4_X_LOTE "
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),cAlTMP3,.T.,.T.) 
		
				If (cAlTMP3)->(!Eof())
					@ nLin,095 Psay Transform((cAlTMP3)->D4_QTDTOT , "@E 999,999,999.99")
				EndIf
				(cAlTMP3)->(dbCloseArea())
		
				@ nLin,115 Psay aAlTMP2[nI,4]
				@ nLin,130 Psay DtoC(aAlTMP2[nI,5])
				@ nLin,147 Psay AllTrim(aAlTMP2[nI,6]) + " " + aAlTMP2[nI,7]
				@ nLin,168 Psay aAlTMP2[nI,8]
		
				If MV_PAR03 == 2 //'A'
					@ nLin,190 Psay aAlTMP2[nI,9]
				EndIf
		
				nLin:=nLin+1
				
			Next

			nLin:=nLin+1                 
	
			(cAlTMP2)->(dbCloseArea())

		EndIf

		(cAlTMP1)->(dbSkip())
	EndDo                            
  


/////Impressão dos Itens (MP/CO)
/*
	lImpre  := .T.
	cCodPro :=""

	cQuery2 := " SELECT X.F2_DOC,     X.F2_SERIE, X.F2_CLIENTE, X.F2_LOJA,    X.F2_EMISSAO, X.D1_DOC,         X.D1_SERIE,  "
	If MV_PAR03 == 2 //'A'  -> Analítico
		cQuery2 += "        X.D1_LOTEFOR, X.D1_UM, X.D4_COD, YSB1.B1_DESC, X.CB0_OP,     X.D4_LOTECTL, X.D4_DTVALID"     //, SUM(X.D4_QTDEORI) D4_QTDTOT "
    Else            //      -> Sintético 
		cQuery2 += "        X.D1_LOTEFOR, X.D1_UM, X.D4_COD, YSB1.B1_DESC,               X.D4_LOTECTL, X.D4_DTVALID"     //, SUM(X.D4_QTDEORI) D4_QTDTOT "
    EndIf

	cQuery2 += " FROM ( "

	cQuery2 += " 	SELECT SF2.F2_DOC,    SF2.F2_SERIE,   SF2.F2_CLIENTE, SF2.F2_LOJA,   SF2.F2_EMISSAO, SF2.F2_VALBRUT, "
	cQuery2 += "	       SD2.D2_COD,    SD2.D2_ITEM,    SB1.B1_DESC,    SD2.D2_UM,     SD2.D2_QUANT,   "  //SD2.D2_PRCVEN,  SD2.D2_TOTAL,   "
	cQuery2 += "           SD2.D2_PEDIDO, CBL.CBL_CODETI, CB0.CB0_OP,     SC2.C2_OPMIDO, SC2.C2_PLANOMP, SC2.C2_PLANOCO,  "
	cQuery2 += "	       SD4.D4_COD,    SD4.D4_LOTECTL, SD4.D4_DTVALID, SD4.D4_QTDEORI, SD1.D1_DOC,    SD1.D1_SERIE,   SD1.D1_LOTEFOR, SD1.D1_UM"
	
	cQuery2 += " 	FROM " + RetSqlName("SF2") + " SF2 "

	cQuery2 += " 	JOIN " + RetSqlName("SD2") + " SD2 "
	cQuery2 += "		     ON  SD2.D2_DOC     = SF2.F2_DOC               AND SD2.D2_SERIE   = SF2.F2_SERIE "
	cQuery2 += "		     AND SD2.D2_CLIENTE = SF2.F2_CLIENTE           AND SD2.D2_LOJA    = SF2.F2_LOJA  "
	cQuery2 += "		     AND SD2.D2_FILIAL  = '" + xFilial("SD2") + "' AND SD2.D_E_L_E_T_ = ' '          "

	cQuery2 += " 	JOIN " + RetSqlName("CBL") + " CBL "
	cQuery2 += "             ON  CBL.CBL_DOC    = SF2.F2_DOC               AND CBL.CBL_SERIE  = SF2.F2_SERIE "
	cQuery2 += "             AND CBL.CBL_CLIENT = SF2.F2_CLIENTE           AND CBL.CBL_LOJA   = SF2.F2_LOJA  "
	cQuery2 += "             AND CBL.CBL_FILIAL = '" + xFilial("CBL") + "' AND CBL.D_E_L_E_T_ = ' '          "

	cQuery2 += " 	JOIN " + RetSqlName("CBK") + " CBK "
	cQuery2 += "		     ON  CBK.CBK_DOC    = SF2.F2_DOC               AND CBK.CBK_SERIE  = SF2.F2_SERIE " 
	cQuery2 += "             AND CBK.CBK_CLIENT = SF2.F2_CLIENTE           AND CBK.CBK_LOJA   = SF2.F2_LOJA  " 
	cQuery2 += "             AND CBK.CBK_FILIAL = '" + xFilial("CBK") + "' AND CBK.D_E_L_E_T_ = ' ' "

	cQuery2 += " 	JOIN " + RetSqlName("CB0") + " CB0 "
	cQuery2 += "		     ON  CB0.CB0_PALLET = CBL.CBL_CODETI "
	cQuery2 += "             AND CB0.CB0_FILIAL = '" + xFilial("CBL") + "' AND CB0.D_E_L_E_T_ = ' '          "

	cQuery2 += " 	JOIN " + RetSqlName("SC2") + " SC2 "
	cQuery2 += "		     ON  SC2.C2_NUM     = CB0.CB0_OP "
	cQuery2 += "		     AND SC2.C2_FILIAL  = '" + xFilial("SC2") + "' AND SC2.D_E_L_E_T_ = ' ' "

	cQuery2 += " 	JOIN " + RetSqlName("SB1") + " SB1 "
	cQuery2 += "		     ON SB1.B1_COD      = SD2.D2_COD "
	cQuery2 += "		     AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = ' ' "

	cQuery2 += "	JOIN " + RetSqlName("SD4") + " SD4 "
	cQuery2 += "		     ON SUBSTRING(SD4.D4_OP,1,6) = SC2.C2_NUM "
	cQuery2 += "	         AND SD4.D4_FILIAL  = '" + xFilial("SD4") + "' AND SD4.D_E_L_E_T_ = ' '   "

	cQuery2 += "	JOIN " + RetSqlName("SD1") + " SD1 "
	cQuery2 += "		     ON SD1.D1_COD = SD4.D4_COD AND SD4.D4_LOTECTL = SD1.D1_LOTECTL "
	cQuery2 += "	         AND SD1.D1_FILIAL  = '" + xFilial("SD1") + "' AND SD1.D_E_L_E_T_ = ' '   "
	          
	cQuery2 += " 	WHERE SF2.F2_DOC       = '" + MV_PAR01 + "' AND SF2.F2_SERIE   = '" + MV_PAR02 + "'       "
	cQuery2 += "		     AND SF2.D_E_L_E_T_ = ' '                AND SF2.F2_FILIAL  = '" + xFilial("SF2") + "' "
	cQuery2 += "		     AND SUBSTRING(SD4.D4_COD,1,3) <> 'MOD'  AND SD4.D4_LOTECTL <> ' ' "
	cQuery2 += "		     AND CBK.CBK_STATUS = '2' "

	cQuery2 += " 	GROUP BY SF2.F2_DOC,     SF2.F2_SERIE,   SF2.F2_CLIENTE, SF2.F2_LOJA,    SF2.F2_EMISSAO,  SF2.F2_VALBRUT, "
	cQuery2 += "	         SD2.D2_COD,     SD2.D2_ITEM,    SB1.B1_DESC,    SD2.D2_UM,      SD2.D2_QUANT,    SD2.D2_PEDIDO,"
	cQuery2 += "             CBL.CBL_CODETI, CB0.CB0_OP,     SC2.C2_OPMIDO,  SC2.C2_PLANOMP, SC2.C2_PLANOCO,  SD4.D4_COD,"
	cQuery2 += "	         SD4.D4_LOTECTL, SD4.D4_DTVALID, SD4.D4_QTDEORI, SD1.D1_DOC,     SD1.D1_SERIE,    SD1.D1_LOTEFOR, SD1.D1_UM "
  
	cQuery2 += "	) AS X

	cQuery2 += " 	JOIN " + RetSqlName("SB1") + " YSB1 "
	cQuery2 += "		     ON  YSB1.B1_COD     = X.D4_COD "
	cQuery2 += "		     AND YSB1.B1_FILIAL  = '" + xFilial("SB1") + "' AND YSB1.D_E_L_E_T_ = ' ' "

	If MV_PAR03 ==  2 //'A'  -> Analítico
		cQuery2 += "	GROUP BY X.F2_DOC,   X.F2_SERIE,   X.F2_CLIENTE, X.F2_LOJA, X.F2_EMISSAO, X.D1_DOC, " 
		cQuery2 += "	         X.D1_SERIE, X.D1_LOTEFOR, X.D1_UM,      X.D4_COD,  YSB1.B1_DESC, X.CB0_OP, X.D4_LOTECTL, X.D4_DTVALID "
    Else              //     -> Sintético
		cQuery2 += "	GROUP BY X.F2_DOC,   X.F2_SERIE,   X.F2_CLIENTE, X.F2_LOJA, X.F2_EMISSAO, X.D1_DOC, " 
		cQuery2 += "	         X.D1_SERIE, X.D1_LOTEFOR, X.D1_UM,      X.D4_COD,  YSB1.B1_DESC, X.D4_LOTECTL, X.D4_DTVALID "
    EndIf

	cQuery2 += "	ORDER BY X.D4_COD,   X.D4_LOTECTL, X.D4_DTVALID "
  
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAlTMP2,.T.,.T.) 

	SetRegua((cAlTMP2)->(RecCount()))                          //TRB->(RECCOUNT())

	While (cAlTMP2)->(! Eof())

		(cAlTMP2)->(IncRegua())

		aAdd(aAlTMP2,{ AllTrim((cAlTMP2)->D4_COD)    ,;
		                       (cAlTMP2)->B1_DESC    ,;
		                       (cAlTMP2)->D1_UM      ,;
                               (cAlTMP2)->D4_LOTECTL ,;
                          StoD((cAlTMP2)->D4_DTVALID),;
                       AllTrim((cAlTMP2)->D1_DOC)    ,;
                               (cAlTMP2)->D1_SERIE   ,;
                               (cAlTMP2)->D1_LOTEFOR    })
		(cAlTMP2)->(IncRegua())
		(cAlTMP2)->(dbSkip())
	EndDo                            

	SetRegua((cAlTMP2)->(RecCount()))                          //TRB->(RECCOUNT())

	For nI = 1 to Len(aAlTMP2)

		(cAlTMP2)->(IncRegua())

		If lEnd
			@Prow()+1,0 PSAY "Cancelado Pelo Operador!!!"
			Exit
		EndIf

		If nLin > 55 .Or. lImpre == .T.

			If nLin > 55
				Cabec(Titulo,"","",Nomeprog,nTamanho,15)
				nLin:=5
			EndIf	

			nLin:=nLin+1
			@ nLin,000 Psay cCabec5
			nLin:=nLin+1
			@ nLin,000 Psay cCabec6
			nLin:=nLin+2
			@ nLin,000 Psay cCabec7
			nLin:=nLin+1
			@ nLin,000 Psay Repli('-', 200)
			nLin:=nLin+1
			lImpre := .F.
		EndIf	

		@ nLin,000 Psay aAlTMP2[nI,1] + " " + aAlTMP2[nI,2]
		@ nLin,080 Psay aAlTMP2[nI,3]

		cQuery3 := " SELECT WSD4.D4_COD, WSD4.D4_LOTECTL, SUM(WSD4.D4_QTDEORI) D4_QTDTOT " 
		cQuery3 += " FROM " + RetSqlName("SD4") + " WSD4 "  
		cQuery3 += " JOIN " + RetSqlName("SC2") + " WSC2 ON WSC2.C2_NUM     = SUBSTRING(WSD4.D4_OP,1,6) "
		cQuery3 += "                                   AND WSC2.C2_FILIAL  = '" + xFilial("SC2") + "' AND WSC2.D_E_L_E_T_ = ' ' "   
		cQuery3 += " AND WSC2.C2_OPMIDO IN(" + cTOPMIDO + ") "
		cQuery3 += " WHERE WSD4.D4_COD       = '" + aAlTMP2[nI,1] + "' AND WSD4.D4_LOTECTL = '" + aAlTMP2[nI,4] + "' " 
		cQuery3 += "	         AND WSD4.D4_FILIAL  = '" + xFilial("SD4") + "' AND WSD4.D_E_L_E_T_ = ' '   "
		cQuery3 += " GROUP BY WSD4.D4_COD, WSD4.D4_LOTECTL "
		cQuery3 += " ORDER BY WSD4.D4_COD, WSD4.D4_LOTECTL "
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),cAlTMP3,.T.,.T.) 

		If (cAlTMP3)->(!Eof())
			@ nLin,090 Psay Transform((cAlTMP3)->D4_QTDTOT , "@E 999,999,999.99")
		EndIf
		(cAlTMP3)->(dbCloseArea())

		@ nLin,110 Psay aAlTMP2[nI,4]
		@ nLin,125 Psay DtoC(aAlTMP2[nI,5])
		@ nLin,142 Psay AllTrim(aAlTMP2[nI,6]) + " " + aAlTMP2[nI,7]
		@ nLin,163 Psay aAlTMP2[nI,8]

		If MV_PAR03 == 2 //'A'
			@ nLin,185 Psay aAlTMP2[nI,9]
		EndIf

		nLin:=nLin+1
		
	Next
*/	
	(cAlTMP)->(dbCloseArea())
	(cAlTMP1)->(dbCloseArea())
//	(cAlTMP2)->(dbCloseArea())

	Set Filter to 
	
	If aReturn[5] = 1
		Set Printer To
		Commit
		ourspool(wnrel)
	Endif
	
	MS_FLUSH()
			
Return Nil       


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³        º Data ³      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastra perguntas do relatorio                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP R4 ou 10.1 - Especifico Midori                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg(cPerg)
//Variaveis locais
Local aRegs := {}
Local i,j
//Inicio da funcao
dbSelectArea("SX1")
dbSetOrder(1)
                                                                                                                                                                                                                                                                     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//   1          2        3           4            5           6       7       8             9        10      11     12       13        14        15         16       17       18       19        20          21        22      23        24       25         26        27       28       29       30          31        32       33       34        35          36        37     38     39       40       41        42
//³ Grupo  	  Ordem	 Pergunta  P  Pergunta                            E   Pergunta I   Variavel 	 Tipo  	 Tamanho  Decimal  Presel    GSC   	Valid        Var01       Def01               DefSPA1        	DefEng1      	     Cnt01               Var02   Def02    		     DefSpa2             DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	 XF3   GrgSxg  cPyme aHelpPor	aHelpEng	aHelpSpa    cHelp  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//         X1_GRUPO/ X1_ORDEM /X1_PERGUNT        / X1_PERSPA/ X1_PERENG/ X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01   /X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3  /X1_PYME/X1_GRPSXG/X1_HELP/X1_PICTURE
Aadd(aRegs,{cPerg  , "01"    ,"Informe a NF   ? ",""        , ""       , "MV_CH1"  ,"C"    ,09        ,0         ,0        ,"G"   ,""      ,"MV_PAR01" ,""      ,""        ,""         ,""      ,""      ,""      ,""        ,""        ,""      ,""     ,""       ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,"SF2" ,"S" })
Aadd(aRegs,{cPerg  , "02"    ,"Informe a Série? ",""        , ""       , "MV_CH2"  ,"C"    ,03        ,0         ,0        ,"G"   ,""      ,"MV_PAR02" ,""      ,""        ,""         ,""      ,""      ,""      ,""        ,""        ,""      ,""     ,""       ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""    ,"S" })

//Loop de armazenamento
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])             ////inicio
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif     
Next
//Retorno da funcao
Return()




/*
SELECT SF2.F2_DOC,    SF2.F2_SERIE,   SF2.F2_CLIENTE, SF2.F2_LOJA,   SF2.F2_EMISSAO, SF2.F2_VALBRUT, 	       SD2.D2_COD,    SD2.D2_ITEM,    SB1.B1_DESC,    SD2.D2_UM,     SD2.D2_QUANT,   SD2.D2_PRCVEN,  SD2.D2_TOTAL,           SD2.D2_PEDIDO, CBL.CBL_CODETI, CB0.CB0_OP,     SC2.C2_OPMIDO, SC2.C2_PLANOMP, SC2.C2_PLANOCO,  	       SD4.D4_COD,    SD4.D4_LOTECTL, SD4.D4_QTDEORI, SD1.D1_DOC,    SD1.D1_SERIE,   SD1.D1_LOTEFOR	 FROM SF2010 SF2  JOIN SD2010 SD2 		ON  SD2.D2_DOC     = SF2.F2_DOC               AND SD2.D2_SERIE   = SF2.F2_SERIE 		AND SD2.D2_CLIENTE = SF2.F2_CLIENTE           AND SD2.D2_LOJA    = SF2.F2_LOJA  		AND SD2.D2_FILIAL  = '08' AND SD2.D_E_L_E_T_ = ' '           JOIN CBL010 CBL 		ON  CBL.CBL_DOC    = SF2.F2_DOC               AND CBL.CBL_SERIE  = SF2.F2_SERIE      AND CBL.CBL_CLIENT = SF2.F2_CLIENTE           AND CBL.CBL_LOJA   = SF2.F2_LOJA       AND CBL.CBL_FILIAL = '08' AND CBL.D_E_L_E_T_ = ' '           JOIN CBK010 CBK 		ON  CBK.CBK_DOC    = SF2.F2_DOC               AND CBK.CBK_SERIE  = SF2.F2_SERIE      AND CBK.CBK_CLIENT = SF2.F2_CLIENTE           AND CBK.CBK_LOJA   = SF2.F2_LOJA       AND CBK.CBK_FILIAL = '08' AND CBK.D_E_L_E_T_ = ' '  JOIN CB0010 CB0 		ON  CB0.CB0_PALLET = CBL.CBL_CODETI      AND CB0.CB0_FILIAL = '08' AND CB0.D_E_L_E_T_ = ' '           JOIN SC2010 SC2 		ON  SC2.C2_NUM     = CB0.CB0_OP 		AND SC2.C2_FILIAL  = '08' AND SC2.D_E_L_E_T_ = ' '  JOIN SB1010 SB1 		ON SB1.B1_COD      = SD2.D2_COD 		AND SB1.B1_FILIAL  = '  ' AND SB1.D_E_L_E_T_ = ' ' 	JOIN SD4010 SD4 		ON SUBSTRING(SD4.D4_OP,1,6) = SC2.C2_NUM 	    AND SD4.D4_FILIAL  = '08' AND SD4.D_E_L_E_T_ = ' '   	JOIN SD1010 SD1 		ON SD1.D1_COD = SD4.D4_COD AND SD4.D4_LOTECTL = SD1.D1_LOTECTL 	    AND SD1.D1_FILIAL  = '08' AND SD1.D_E_L_E_T_ = ' '    WHERE SF2.F2_DOC       = '000049184' AND SF2.F2_SERIE   = '1  '       		AND SF2.D_E_L_E_T_ = ' '                AND SF2.F2_FILIAL  = '08' 		AND SUBSTRING(SD4.D4_COD,1,3) <> 'MOD'  AND SD4.D4_LOTECTL <> ' ' 		AND CBK.CBK_STATUS = '2'  GROUP BY SF2.F2_DOC,    SF2.F2_SERIE,   SF2.F2_CLIENTE, SF2.F2_LOJA,   SF2.F2_EMISSAO, SF2.F2_VALBRUT, 	         SD2.D2_COD,    SD2.D2_ITEM,    SB1.B1_DESC,    SD2.D2_UM,     SD2.D2_QUANT,   SD2.D2_PRCVEN,  SD2.D2_TOTAL,             SD2.D2_PEDIDO, CBL.CBL_CODETI, CB0.CB0_OP,     SC2.C2_OPMIDO, SC2.C2_PLANOMP, SC2.C2_PLANOCO,  	         SD4.D4_COD,    SD4.D4_LOTECTL, SD4.D4_QTDEORI, SD1.D1_DOC,    SD1.D1_SERIE,   SD1.D1_LOTEFOR	 ORDER BY SF2.F2_DOC,    SF2.F2_SERIE,   SF2.F2_CLIENTE, SF2.F2_LOJA,   SF2.F2_EMISSAO, SF2.F2_VALBRUT, 	         SD2.D2_COD,    SD2.D2_ITEM,    SB1.B1_DESC,    SD2.D2_UM,     SD2.D2_QUANT,   SD2.D2_PRCVEN,  SD2.D2_TOTAL,             SD2.D2_PEDIDO, CBL.CBL_CODETI, CB0.CB0_OP,     SC2.C2_OPMIDO, SC2.C2_PLANOMP, SC2.C2_PLANOCO,  	         SD4.D4_COD,    SD4.D4_LOTECTL, SD4.D4_QTDEORI, SD1.D1_DOC,    SD1.D1_SERIE,   SD1.D1_LOTEFOR	

SELECT SF2.F2_DOC,     SF2.F2_SERIE, SF2.F2_CLIENTE, SF2.F2_LOJA,    SF2.F2_EMISSAO, SF2.F2_VALBRUT,
 	   SD2.D2_COD,     SD2.D2_ITEM,    SB1.B1_DESC,  SD2.D2_UM,      SD2.D2_QUANT,   SD2.D2_PRCVEN,  SD2.D2_TOTAL,
 	   SD2.D2_PEDIDO,  CBL.CBL_CODETI, CB0.CB0_OP,   SC2.C2_OPMIDO,  SC2.C2_PLANOMP, SC2.C2_PLANOCO,
 	   SD4.D4_COD,     SD4.D4_LOTECTL, SD1.D1_DOC,   SD1.D1_SERIE	 
FROM SF2010 SF2  
JOIN SD2010 SD2 		ON  SD2.D2_DOC     = SF2.F2_DOC               AND SD2.D2_SERIE   = SF2.F2_SERIE
 		AND SD2.D2_CLIENTE = SF2.F2_CLIENTE           AND SD2.D2_LOJA    = SF2.F2_LOJA
 		AND SD2.D2_FILIAL  = '08' AND SD2.D_E_L_E_T_ = ' '           
JOIN CBL010 CBL 		ON  CBL.CBL_DOC    = SF2.F2_DOC               AND CBL.CBL_SERIE  = SF2.F2_SERIE
      AND CBL.CBL_CLIENT = SF2.F2_CLIENTE           AND CBL.CBL_LOJA   = SF2.F2_LOJA       AND CBL.CBL_FILIAL = '08'
      AND CBL.D_E_L_E_T_ = ' '           
JOIN CBK010 CBK 		ON  CBK.CBK_DOC    = SF2.F2_DOC               AND CBK.CBK_SERIE  = SF2.F2_SERIE
                        AND CBK.CBK_CLIENT = SF2.F2_CLIENTE           AND CBK.CBK_LOJA   = SF2.F2_LOJA
                        AND CBK.CBK_FILIAL = '08' AND CBK.D_E_L_E_T_ = ' '  
JOIN CB0010 CB0 		ON  CB0.CB0_PALLET = CBL.CBL_CODETI      AND CB0.CB0_FILIAL = '08' AND CB0.D_E_L_E_T_ = ' '           
JOIN SC2010 SC2 		ON  SC2.C2_NUM     = CB0.CB0_OP 		AND SC2.C2_FILIAL  = '08' AND SC2.D_E_L_E_T_ = ' '  
JOIN SB1010 SB1 		ON SB1.B1_COD      = SD2.D2_COD 		AND SB1.B1_FILIAL  = '  ' AND SB1.D_E_L_E_T_ = ' ' 	
JOIN SD4010 SD4 		ON SUBSTRING(SD4.D4_OP,1,6) = SC2.C2_NUM 	    AND SD4.D4_FILIAL  = '08' AND SD4.D_E_L_E_T_ = ' '   	
JOIN SD1010 SD1 		ON SD1.D1_COD = SD4.D4_COD AND SD4.D4_LOTECTL = SD1.D1_LOTECTL 	    AND SD1.D1_FILIAL  = '08' AND SD1.D_E_L_E_T_ = ' '    
WHERE SF2.F2_DOC       = '000049184' AND SF2.F2_SERIE   = '1  '
      AND SF2.D_E_L_E_T_ = ' ' AND SF2.F2_FILIAL  = '08'
      AND SUBSTRING(SD4.D4_COD,1,3) <> 'MOD'  AND SD4.D4_LOTECTL <> ' ' 		AND CBK.CBK_STATUS = '2'  
GROUP BY SF2.F2_DOC,     SF2.F2_SERIE, SF2.F2_CLIENTE, SF2.F2_LOJA,    SF2.F2_EMISSAO, SF2.F2_VALBRUT,
         SD2.D2_COD,     SD2.D2_ITEM,    SB1.B1_DESC,  SD2.D2_UM,      SD2.D2_QUANT,   SD2.D2_PRCVEN,  SD2.D2_TOTAL,
         SD2.D2_PEDIDO,  CBL.CBL_CODETI, CB0.CB0_OP,   SC2.C2_OPMIDO,  SC2.C2_PLANOMP, SC2.C2_PLANOCO,
         SD4.D4_COD,     SD4.D4_LOTECTL, SD1.D1_DOC,   SD1.D1_SERIE	 
ORDER BY SF2.F2_DOC,     SF2.F2_SERIE, SF2.F2_CLIENTE, SF2.F2_LOJA,    SF2.F2_EMISSAO, SF2.F2_VALBRUT, 	         
         SD2.D2_COD,     SD2.D2_ITEM,    SB1.B1_DESC,  SD2.D2_UM,      SD2.D2_QUANT,   SD2.D2_PRCVEN,  SD2.D2_TOTAL,             
         SD2.D2_PEDIDO,  CBL.CBL_CODETI, CB0.CB0_OP,   SC2.C2_OPMIDO,  SC2.C2_PLANOMP, SC2.C2_PLANOCO,  	         
         SD4.D4_COD,     SD4.D4_LOTECTL, SD1.D1_DOC,   SD1.D1_SERIE
                                                                    
      
SELECT  X.F2_DOC, X.F2_SERIE,  X.F2_CLIENTE, X.F2_LOJA,  X.F2_EMISSAO, X.D1_DOC, X.D1_SERIE, X.D1_LOTEFOR,  
X.D4_COD, X.D4_LOTECTL,  SUM(X.D4_QTDEORI) FROM (
SELECT SF2.F2_DOC,    SF2.F2_SERIE,   SF2.F2_CLIENTE, SF2.F2_LOJA,   SF2.F2_EMISSAO, SF2.F2_VALBRUT, 	       
SD2.D2_COD,    SD2.D2_ITEM,    SB1.B1_DESC,    SD2.D2_UM,     SD2.D2_QUANT,   SD2.D2_PRCVEN,  SD2.D2_TOTAL,           
SD2.D2_PEDIDO, CBL.CBL_CODETI, CB0.CB0_OP,     SC2.C2_OPMIDO, SC2.C2_PLANOMP, SC2.C2_PLANOCO,  	       
SD4.D4_COD,    SD4.D4_LOTECTL, SD4.D4_QTDEORI, SD1.D1_DOC,    SD1.D1_SERIE,   SD1.D1_LOTEFOR	 
FROM SF2010 SF2  
JOIN SD2010 SD2 		ON  SD2.D2_DOC     = SF2.F2_DOC               AND SD2.D2_SERIE   = SF2.F2_SERIE 		AND SD2.D2_CLIENTE = SF2.F2_CLIENTE           
AND SD2.D2_LOJA    = SF2.F2_LOJA  		AND SD2.D2_FILIAL  = '08' AND SD2.D_E_L_E_T_ = ' '           
JOIN CBL010 CBL 		ON  CBL.CBL_DOC    = SF2.F2_DOC               AND CBL.CBL_SERIE  = SF2.F2_SERIE      AND CBL.CBL_CLIENT = SF2.F2_CLIENTE           
AND CBL.CBL_LOJA   = SF2.F2_LOJA       AND CBL.CBL_FILIAL = '08' AND CBL.D_E_L_E_T_ = ' '           
JOIN CBK010 CBK 		ON  CBK.CBK_DOC    = SF2.F2_DOC               AND CBK.CBK_SERIE  = SF2.F2_SERIE      AND CBK.CBK_CLIENT = SF2.F2_CLIENTE           
AND CBK.CBK_LOJA   = SF2.F2_LOJA       AND CBK.CBK_FILIAL = '08' AND CBK.D_E_L_E_T_ = ' '  
JOIN CB0010 CB0 		ON  CB0.CB0_PALLET = CBL.CBL_CODETI      AND CB0.CB0_FILIAL = '08' AND CB0.D_E_L_E_T_ = ' '           
JOIN SC2010 SC2 		ON  SC2.C2_NUM     = CB0.CB0_OP 		AND SC2.C2_FILIAL  = '08' AND SC2.D_E_L_E_T_ = ' '  
JOIN SB1010 SB1 		ON SB1.B1_COD      = SD2.D2_COD 		AND SB1.B1_FILIAL  = '  ' AND SB1.D_E_L_E_T_ = ' ' 	
JOIN SD4010 SD4 		ON SUBSTRING(SD4.D4_OP,1,6) = SC2.C2_NUM 	    AND SD4.D4_FILIAL  = '08' AND SD4.D_E_L_E_T_ = ' '   	
JOIN SD1010 SD1 		ON SD1.D1_COD = SD4.D4_COD AND SD4.D4_LOTECTL = SD1.D1_LOTECTL 	    AND SD1.D1_FILIAL  = '08' AND SD1.D_E_L_E_T_ = ' '    
WHERE SF2.F2_DOC       = '000049184' AND SF2.F2_SERIE   = '1  '       		AND SF2.D_E_L_E_T_ = ' '                AND SF2.F2_FILIAL  = '08' 		
AND SUBSTRING(SD4.D4_COD,1,3) <> 'MOD'  AND SD4.D4_LOTECTL <> ' ' 		AND CBK.CBK_STATUS = '2'  
GROUP BY SF2.F2_DOC,    SF2.F2_SERIE,   SF2.F2_CLIENTE, SF2.F2_LOJA,   SF2.F2_EMISSAO, SF2.F2_VALBRUT, 	         
SD2.D2_COD,    SD2.D2_ITEM,    SB1.B1_DESC,    SD2.D2_UM,     SD2.D2_QUANT,   SD2.D2_PRCVEN,  SD2.D2_TOTAL,             
SD2.D2_PEDIDO, CBL.CBL_CODETI, CB0.CB0_OP,     SC2.C2_OPMIDO, SC2.C2_PLANOMP, SC2.C2_PLANOCO,  	         
SD4.D4_COD,    SD4.D4_LOTECTL, SD4.D4_QTDEORI, SD1.D1_DOC,    SD1.D1_SERIE,   SD1.D1_LOTEFOR	 ) AS X
GROUP BY X.F2_DOC, X.F2_SERIE,  X.F2_CLIENTE, X.F2_LOJA,  X.F2_EMISSAO, X.D1_DOC, X.D1_SERIE, X.D1_LOTEFOR,  X.D4_COD, X.D4_LOTECTL
ORDER BY X.D4_COD, X.D4_LOTECTL
                                    
      
SELECT SF2.F2_DOC,    SF2.F2_SERIE,   SF2.F2_CLIENTE, SF2.F2_LOJA,   SF2.F2_EMISSAO, SF2.F2_VALBRUT,
       SD2.D2_COD,    SD2.D2_ITEM,    SB1.B1_DESC,    SD2.D2_UM,     SD2.D2_QUANT,           
       SD2.D2_PEDIDO, CBL.CBL_CODETI, CB0.CB0_OP,     SC2.C2_OPMIDO, SC2.C2_PLANOMP, SC2.C2_PLANOCO,  	       
       SD4.D4_COD,    SD4.D4_LOTECTL, SD4.D4_DTVALID, SD4.D4_QTDEORI, SD1.D1_DOC,    SD1.D1_SERIE,   SD1.D1_LOTEFOR	   
FROM SF2010 SF2  
JOIN SD2010 SD2 		ON  SD2.D2_DOC     = SF2.F2_DOC
                        AND SD2.D2_SERIE   = SF2.F2_SERIE
                        AND SD2.D2_CLIENTE = SF2.F2_CLIENTE           
                        AND SD2.D2_LOJA    = SF2.F2_LOJA  		
                        AND SD2.D2_FILIAL  = '08' AND SD2.D_E_L_E_T_ = ' '           
JOIN CBL010 CBL 		ON  CBL.CBL_DOC    = SF2.F2_DOC               
                        AND CBL.CBL_SERIE  = SF2.F2_SERIE      
                        AND CBL.CBL_CLIENT = SF2.F2_CLIENTE           
                        AND CBL.CBL_LOJA   = SF2.F2_LOJA       
                        AND CBL.CBL_FILIAL = '08' AND CBL.D_E_L_E_T_ = ' '           
JOIN CBK010 CBK 		ON  CBK.CBK_DOC    = SF2.F2_DOC               
                        AND CBK.CBK_SERIE  = SF2.F2_SERIE      
                        AND CBK.CBK_CLIENT = SF2.F2_CLIENTE           
                        AND CBK.CBK_LOJA   = SF2.F2_LOJA       
                        AND CBK.CBK_FILIAL = '08' AND CBK.D_E_L_E_T_ = ' '  
JOIN CB0010 CB0 		ON  CB0.CB0_PALLET = CBL.CBL_CODETI      
                        AND CB0.CB0_FILIAL = '08' AND CB0.D_E_L_E_T_ = ' '  
JOIN SC2010 SC2 		ON  SC2.C2_NUM     = CB0.CB0_OP 		
                        AND SC2.C2_FILIAL  = '08' AND SC2.D_E_L_E_T_ = ' '  
JOIN SB1010 SB1 		ON SB1.B1_COD      = SD2.D2_COD 		
                        AND SB1.B1_FILIAL  = '  ' AND SB1.D_E_L_E_T_ = ' ' 	
JOIN SD4010 SD4 		ON SUBSTRING(SD4.D4_OP,1,6) = SC2.C2_NUM 	    
                        AND SD4.D4_FILIAL  = '08' AND SD4.D_E_L_E_T_ = ' ' 	
JOIN SD1010 SD1 		ON SD1.D1_COD = SD4.D4_COD AND SD4.D4_LOTECTL = SD1.D1_LOTECTL 	    
                        AND SD1.D1_FILIAL  = '08' AND SD1.D_E_L_E_T_ = ' '  
WHERE SF2.F2_DOC       = '000049184' AND SF2.F2_SERIE   = '1  ' AND SF2.D_E_L_E_T_ = ' ' AND SF2.F2_FILIAL  = '08' 		
  AND SUBSTRING(SD4.D4_COD,1,3) <> 'MOD'  AND SD4.D4_LOTECTL <> ' ' 		AND CBK.CBK_STATUS = '2'  
GROUP BY SF2.F2_DOC,    SF2.F2_SERIE,   SF2.F2_CLIENTE, SF2.F2_LOJA,   SF2.F2_EMISSAO, SF2.F2_VALBRUT, 	         
         SD2.D2_COD,    SD2.D2_ITEM,    SB1.B1_DESC,    SD2.D2_UM,     SD2.D2_QUANT,             
         SD2.D2_PEDIDO, CBL.CBL_CODETI, CB0.CB0_OP,     SC2.C2_OPMIDO, SC2.C2_PLANOMP, SC2.C2_PLANOCO,  	         
         SD4.D4_COD,    SD4.D4_LOTECTL, SD4.D4_DTVALID, SD4.D4_QTDEORI, SD1.D1_DOC,    SD1.D1_SERIE,   SD1.D1_LOTEFOR	 
ORDER BY SF2.F2_DOC,    SF2.F2_SERIE,   SF2.F2_CLIENTE, SF2.F2_LOJA,   SF2.F2_EMISSAO, SF2.F2_VALBRUT, 	         
         SD2.D2_COD,    SD2.D2_ITEM,    SB1.B1_DESC,    SD2.D2_UM,     SD2.D2_QUANT,             
         SD2.D2_PEDIDO, CBL.CBL_CODETI, CB0.CB0_OP,     SC2.C2_OPMIDO, SC2.C2_PLANOMP, SC2.C2_PLANOCO,  	         
         SD4.D4_COD,    SD4.D4_LOTECTL, SD4.D4_DTVALID, SD4.D4_QTDEORI, SD1.D1_DOC,    SD1.D1_SERIE,   SD1.D1_LOTEFOR	   
         
         
         
         
SELECT  X.F2_DOC,     X.F2_SERIE,  X.F2_CLIENTE, X.F2_LOJA,    X.F2_EMISSAO, X.C2_OPMIDO,x.C2_PLANOMP, x.C2_PLANOCO
FROM (
SELECT SF2.F2_DOC,    SF2.F2_SERIE,   SF2.F2_CLIENTE, SF2.F2_LOJA,   SF2.F2_EMISSAO, SF2.F2_VALBRUT,
       SD2.D2_COD,    SD2.D2_ITEM,    SB1.B1_DESC,    SD2.D2_UM,     SD2.D2_QUANT,           
       SD2.D2_PEDIDO, CBL.CBL_CODETI,      SC2.C2_OPMIDO, SC2.C2_PLANOMP, SC2.C2_PLANOCO,  	       
       SD4.D4_COD,    SD4.D4_LOTECTL, SD4.D4_DTVALID,  SD1.D1_DOC,    SD1.D1_SERIE,   SD1.D1_LOTEFOR	   
FROM SF2010 SF2  
JOIN SD2010 SD2 		ON  SD2.D2_DOC     = SF2.F2_DOC
                        AND SD2.D2_SERIE   = SF2.F2_SERIE
                        AND SD2.D2_CLIENTE = SF2.F2_CLIENTE           
                        AND SD2.D2_LOJA    = SF2.F2_LOJA  		
                        AND SD2.D2_FILIAL  = '08' AND SD2.D_E_L_E_T_ = ' '           
JOIN CBL010 CBL 		ON  CBL.CBL_DOC    = SF2.F2_DOC               
                        AND CBL.CBL_SERIE  = SF2.F2_SERIE      
                        AND CBL.CBL_CLIENT = SF2.F2_CLIENTE           
                        AND CBL.CBL_LOJA   = SF2.F2_LOJA       
                        AND CBL.CBL_FILIAL = '08' AND CBL.D_E_L_E_T_ = ' '           
JOIN CBK010 CBK 		ON  CBK.CBK_DOC    = SF2.F2_DOC               
                        AND CBK.CBK_SERIE  = SF2.F2_SERIE      
                        AND CBK.CBK_CLIENT = SF2.F2_CLIENTE           
                        AND CBK.CBK_LOJA   = SF2.F2_LOJA       
                        AND CBK.CBK_FILIAL = '08' AND CBK.D_E_L_E_T_ = ' '  
JOIN CB0010 CB0 		ON  CB0.CB0_PALLET = CBL.CBL_CODETI      
                        AND CB0.CB0_FILIAL = '08' AND CB0.D_E_L_E_T_ = ' '  
JOIN SC2010 SC2 		ON  SC2.C2_NUM     = CB0.CB0_OP 		
                        AND SC2.C2_FILIAL  = '08' AND SC2.D_E_L_E_T_ = ' '  
JOIN SB1010 SB1 		ON SB1.B1_COD      = SD2.D2_COD 		
                        AND SB1.B1_FILIAL  = '  ' AND SB1.D_E_L_E_T_ = ' ' 	
JOIN SD4010 SD4 		ON SUBSTRING(SD4.D4_OP,1,6) = SC2.C2_NUM 	    
                        AND SD4.D4_FILIAL  = '08' AND SD4.D_E_L_E_T_ = ' ' 	
JOIN SD1010 SD1 		ON SD1.D1_COD = SD4.D4_COD AND SD4.D4_LOTECTL = SD1.D1_LOTECTL 	    
                        AND SD1.D1_FILIAL  = '08' AND SD1.D_E_L_E_T_ = ' '  
WHERE SF2.F2_DOC       = '000049184' AND SF2.F2_SERIE   = '1  ' AND SF2.D_E_L_E_T_ = ' ' AND SF2.F2_FILIAL  = '08' 		
  AND SUBSTRING(SD4.D4_COD,1,3) <> 'MOD'  AND SD4.D4_LOTECTL <> ' ' 		AND CBK.CBK_STATUS = '2'  
GROUP BY SF2.F2_DOC,    SF2.F2_SERIE,   SF2.F2_CLIENTE, SF2.F2_LOJA,   SF2.F2_EMISSAO, SF2.F2_VALBRUT, 	         
         SD2.D2_COD,    SD2.D2_ITEM,    SB1.B1_DESC,    SD2.D2_UM,     SD2.D2_QUANT,             
         SD2.D2_PEDIDO, CBL.CBL_CODETI,      SC2.C2_OPMIDO, SC2.C2_PLANOMP, SC2.C2_PLANOCO,  	         
         SD4.D4_COD,    SD4.D4_LOTECTL, SD4.D4_DTVALID,  SD1.D1_DOC,    SD1.D1_SERIE,   SD1.D1_LOTEFOR
)    AS   X
GROUP BY X.F2_DOC,    X.F2_SERIE,   X.F2_CLIENTE, X.F2_LOJA,   X.F2_EMISSAO,  X.C2_OPMIDO,x.C2_PLANOMP, x.C2_PLANOCO
ORDER BY X.F2_DOC,    X.F2_SERIE,   X.F2_CLIENTE, X.F2_LOJA,   X.F2_EMISSAO,  X.C2_OPMIDO,x.C2_PLANOMP, x.C2_PLANOCO         
                                                                                                                       
      
SELECT WSD4.D4_COD, WSD4.D4_LOTECTL, SUM(WSD4.D4_QTDEORI) D4_QTDTOT 
FROM  WSD4  JOIN  WSC2 ON WSC2.C2_NUM     = SUBSTRING(WSD4.D4_OP,1,6)                                    AND WSC2.C2_FILIAL  = '08' AND WSC2.D_E_L_E_T_ = ' '  AND WSC2.C2_OPMIDO IN('204BG WK42-2017PNP3 ','204BG WK43-2017PNP6 ','204BG WK44-2017PNP1 ','204BG WK44-2017PNP2 ','204BG WK45-2017PNP1 ','204BG WK45-2017PNP2 ','204BG WK45-2017PNP3 ','204BG WK45-2017PNP4 ','204BG WK45-2017PNP5 ','204BG WK46-2017PNP1 ','")  WHERE WSD4.D4_COD       = '001449         ' AND WSD4.D4_LOTECTL = '17080003  '  GROUP BY WSD4.D4_COD, WSD4.D4_LOTECTL ORDER BY WSD4.D4_COD, WSD4.D4_LOTECT
       