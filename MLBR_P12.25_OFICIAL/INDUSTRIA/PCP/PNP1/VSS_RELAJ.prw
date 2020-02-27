#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VSS_RELAJ ºAutor  ³ Vinicius Schwartz  º Data ³  11/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de Ajuste de Empenho por Data Ref: VSS_AJEMP      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Lista todos os ajustes que foram feitos em uma data         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                               

User Function VSS_RELAJ(cData)
Local cQry := ""
Private cPerg := "VSS_RELAJ"

if Select("TMPSC2") > 0
	dbSelectArea("TMPSC2")
	TMPSC2->(dbCloseArea())
endif

//Filtra os Registros na SC2 que foram efetuados os ajustes de empenho de acordo com uma data
cQry := " SELECT SC2.C2_NUM, SC2.C2_PRODUTO, SB1.B1_DESC, SC2.C2_X_KG, SC2.C2_X_DTKG "
cQry += " FROM SC2010 SC2 "
cQry += " JOIN SB1010 SB1 "
cQry += " 	ON SB1.D_E_L_E_T_ <> '*' "
cQry += " 	AND SB1.B1_COD = SC2.C2_PRODUTO "
cQry += " WHERE SC2.D_E_L_E_T_ <> '*' "
cQry += " 	AND SC2.C2_X_DTKG = '"+dTos(cData)+"' "     
cQry += " ORDER BY SC2.C2_NUM "

cQry:=ChangeQuery(cQry)
dbUseArea (.T.,"TOPCONN", TcGenQry(,,cQry),"TMPSC2",.T.,.T.)

//Definindo campo C2_X_DTKG como tipo Data
TcSetField("TMPSC2", "C2_X_DTKG", "D")

//Arquivos temporarios para relatorios
aTMP:= {}
Aadd (aTMP,{"C2_NUM"		, "C", 06, 0 } )
Aadd (aTMP,{"C2_PRODUTO"	, "C", 06, 0 } )
Aadd (aTMP,{"B1_DESC"		, "C", 30, 0 } )
Aadd (aTMP,{"C2_X_KG"		, "N", 14, 4 } )
Aadd (aTMP,{"C2_X_DTKG"		, "D", 08, 0 } )
ctrTMP := CriaTrab(aTMP, .T.)
dbUseArea(.T.,,ctrTMP,"TMP",.F.,.F.)

dbSelectArea("TMPSC2")
TMPSC2->(dbGoTop())
while TMPSC2->(!Eof())
	dbSelectArea("TMP")
	RecLock("TMP",.T.)
	TMP->C2_NUM			:= TMPSC2->C2_NUM
	TMP->C2_PRODUTO		:= TMPSC2->C2_PRODUTO
	TMP->B1_DESC		:= TMPSC2->B1_DESC
	TMP->C2_X_KG		:= TMPSC2->C2_X_KG
	TMP->C2_X_DTKG		:= TMPSC2->C2_X_DTKG
	MsUnLock("TMP")    
	TMPSC2->(dbSkip())
	incProc("Pesquisando registros...")
enddo

If TRepInUse()
	//Gera as definicoes do relatorio
	oReport := ReportDef()
	//Monta interface com o usuário
	oReport:PrintDialog()
endif
//Retorno da funcao
TMP->(dbCloseArea())
Ferase(ctrTMP+".dbf")
Ferase(ctrTMP+".cdx")

Return()

//-------------------------
Static Function ReportDef()
//-------------------------
//Variaveis locais da funcao
Local oReport 	:= ""
Local oBreak	:= ""
Local oSection1	:= ""
Local nCount    := 0
//Inicio da funcao
//Monta o objeto do relatorio
oReport := TReport():New(cPerg,"Relatório de Ajuste de Empenho por Kg...",cPerg,{|oReport| Printreport(oReport)},;
				"Relatório de Ajuste de Empenho por Kg...")
				
//Cria a Seção do relatorio
oSection1 := TRSection():New(oReport,"Relatório de Ajuste de Empenho por Kg...",{"TMP"},/*Ordem*/)
	
	TMP->C2_NUM			:= TMP->C2_NUM
	TMP->C2_PRODUTO		:= TMP->C2_PRODUTO
	TMP->B1_DESC		:= TMP->B1_DESC
	TMP->C2_X_KG		:= TMP->C2_X_KG
	TMP->C2_X_DTKG		:= TMP->C2_X_DTKG
	
//Cria as celulas do relatório
	TRCell():New(oSection1,"C2_NUM"			,"TMP","Num OP"			,"@!"					,06,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"C2_PRODUTO"		,"TMP","Produto"		,"@!"					,06,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"B1_DESC"		,"TMP","Descrição" 		,"@!"					,30,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"C2_X_KG"		,"TMP","Kg"	  	   		,"@E 9,999,999.9999"	,14,/*TAMPIXEL*/,/*BLOCO*/)
	TRCell():New(oSection1,"C2_X_DTKG"		,"TMP","Data"			,"@!"					,08,/*TAMPIXEL*/,/*BLOCO*/)
	
Return(oReport)

//-------------------------
Static Function PrintReport()
//-------------------------
Private oSection1 := oReport:Section(1)
oReport:FatLine()
oSection1:Print()
Return()