#include "protheus.ch"
#include "topconn.ch"

User Function RELEEC()
Local oReport

If TRepInUse()
	Pergunte("RELEEC",.F.)
	
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf
Return

Static Function ReportDef()
Local oReport
Local oSection1  

oReport := TReport():New("RELEEC","Relatório de Averbação","RELEEC",{|oReport| PrintReport(oReport)},"Relatório de Averbação.")
oReport:SetLandscape()
oReport:lOnPageBreak:=.T.
oSection1  := TRSection():New(oReport,"Dados",{})
      
/*
oParent		Objeto da classe TRSection que a célula pertence
cName		Nome da célula
cAlias		Tabela utilizada pela célula
cTitle		Título da célula
cPicture	Máscara da célula
nSize		Tamanho da célula
lPixel			Aponta se o tamanho foi informado em pixel
bBlock			Bloco de código com o retorno do campo
cAlign			Alinhamento da célula. "LEFT", "RIGHT" e "CENTER"
lLineBreak		Quebra linha se o conteúdo estourar o tamanho do campo
cHeaderAlign	Alinhamento do cabeçalho da célula. "LEFT", "RIGHT" e "CENTER"
lCellBreak	Compatibilidade - Não utilizado
nColSpace	Espaçamento entre as células
lAutoSize	Ajusta o tamanho da célula com base no tamanho da página e as Informações impressas
nClrBack	Cor de fundo da célula
nClrFore	Cor da fonte da célula
lBold		Imprime a fonte em negrito
*/
//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)
                                       
aTam := TAMSX3("EEC_FILIAL")
TRCell():New(oSection1," "," ","Fl"              ,,aTam[1],.F.,{||TEMP1->FILIAL },,,,,1,.F.,,,)   
aTam := TAMSX3("EEC_NRINVO")
TRCell():New(oSection1," "," ","Invoice"         ,,aTam[1],.F.,{||TEMP1->INVOICE},,,,,1,.F.,,,)     
aTam := TAMSX3("EE9_NF")
TRCell():New(oSection1," "," ","N.Fiscal"        ,,aTam[1],.F.,{||TEMP1->NOTA},,,,,1,.F.,,,)     
TRCell():New(oSection1," "," ","DT.Proc."        ,,10,.F.,{||TEMP1->DT_PROC},,,,,1,.F.,,,)
//TRCell():New(oSection1," "," ","Decl. Despacho"  ,,14,.F.,{||TEMP1->DESPACHO},,,,,1,.F.,,,)
//TRCell():New(oSection1," "," ","DT.Declara"      ,,10,.F.,{||TEMP1->DT_DECLAR},,,,,1,.F.,,,)
//TRCell():New(oSection1," "," ","TP.Exportação"   ,,13,.F.,{||TEMP1->TP_EXPORT},,,,,1,.F.,,,)
//TRCell():New(oSection1," "," ","Reg.Exporta"     ,,12,.F.,{||TEMP1->REG_EXPORT},,,,,1,.F.,,,)
//TRCell():New(oSection1," "," ","DT.Reg."         ,,10,.F.,{||TEMP1->DT_REG_EXP},,,,,1,.F.,,,)
//TRCell():New(oSection1," "," ","DSE"             ,,12,.F.,{||TEMP1->DSE},,,,,1,.F.,,,)
//TRCell():New(oSection1," "," ","DT.DSE"          ,,10,.F.,{||TEMP1->DT_DSE},,,,,1,.F.,,,)       
aTam := TAMSX3("EEC_NRCONH")
TRCell():New(oSection1," "," ","Conhec. Embarque",,aTam[1],.F.,{||TEMP1->CONHEC_EMB},,,,,1,.F.,,,)
TRCell():New(oSection1," "," ","DT.Conhec."      ,,10,.F.,{||TEMP1->DT_CONHEC},,,,,1,.F.,,,)
TRCell():New(oSection1," "," ","DT.Averb."       ,,10,.F.,{||TEMP1->DT_AVERB},,,,,1,.F.,,,)
//TRCell():New(oSection1," "," ","DT.Averb DSE."   ,,10,.F.,{||TEMP1->DT_AVERBDS},,,,,1,.F.,,,) 
aTam := TAMSX3("EEC_NRODUE")
TRCell():New(oSection1," "," ","Num. DUE"   	 ,,aTam[1],.F.,{||TEMP1->NRO_DUE},,,,,1,.F.,,,)
TRCell():New(oSection1," "," ","Data DUE"   	 ,,10,.F.,{||TEMP1->DT_DUE},,,,,1,.F.,,,)
aTam := TAMSX3("EEC_NRORUC")
TRCell():New(oSection1," "," ","Num. RUC"   	 ,,aTam[1],.F.,{||TEMP1->NRO_RUC},,,,,1,.F.,,,)
TRCell():New(oSection1," "," ","País Dest."      ,,10,.F.,{||TEMP1->PAIS},,,,,1,.F.,,,)   


Return oReport

Static Function PrintReport(oReport)                                                                     

Local oSection1  := oReport:Section(1)

Private aStruc:={}

Private cTemp1:=""
Private cInd1 :=""


//AOliveira 22-08-2011. 
If Select("TEMP1") > 0
 DbSelectArea("TEMP1")
 DbCloseArea("TEMP1")
EndIf

aTam := TAMSX3("EEC_FILIAL")
AADD(aStruc,{"FILIAL"    ,aTam[3],aTam[1],aTam[2]})
aTam := TAMSX3("EEC_NRINVO")
AADD(aStruc,{"INVOICE"   ,aTam[3],aTam[1],aTam[2]})
aTam := TAMSX3("EE9_NF")
AADD(aStruc,{"NOTA"       ,aTam[3],aTam[1],aTam[2]})
aTam := TAMSX3("EEC_DTPROC")
AADD(aStruc,{"DT_PROC"    ,aTam[3],aTam[1],aTam[2]})
aTam := TAMSX3("EE9_NRSD")
//AADD(aStruc,{"DESPACHO"   ,aTam[3],aTam[1],aTam[2]})
//aTam := TAMSX3("EE9_DTDDE")
//AADD(aStruc,{"DT_DECLAR"  ,aTam[3],aTam[1],aTam[2]})
//aTam := TAMSX3("EEC_EMBARC")
//AADD(aStruc,{"TP_EXPORT"  ,aTam[3],aTam[1],aTam[2]})
//aTam := TAMSX3("EE9_RE")
//AADD(aStruc,{"REG_EXPORT" ,aTam[3],aTam[1],aTam[2]})
//aTam := TAMSX3("EE9_DTRE")
//AADD(aStruc,{"DT_REG_EXP" ,aTam[3],aTam[1],aTam[2]})
aTam := TAMSX3("EEC_NRCONH")
AADD(aStruc,{"CONHEC_EMB" ,aTam[3],aTam[1],aTam[2]})
aTam := TAMSX3("EEC_DTCONH")
AADD(aStruc,{"DT_CONHEC"  ,aTam[3],aTam[1],aTam[2]})
aTam := TAMSX3("EE9_DTAVRB")
AADD(aStruc,{"DT_AVERB"   ,aTam[3],aTam[1],aTam[2]})
//aTam := TAMSX3("EXL_AVRBDS")
//AADD(aStruc,{"DT_AVERBDS",aTam[3],aTam[1],aTam[2]})

aTam := TAMSX3("EEC_NRODUE")
AADD(aStruc,{"NRO_DUE",aTam[3],aTam[1],aTam[2]})

aTam := TAMSX3("EEC_DTDUE")
AADD(aStruc,{"DT_DUE",aTam[3],aTam[1],aTam[2]})

aTam := TAMSX3("EEC_NRORUC")
AADD(aStruc,{"NRO_RUC",aTam[3],aTam[1],aTam[2]})


aTam := TAMSX3("EEC_PAISET")
AADD(aStruc,{"PAIS"       ,aTam[3],aTam[1],aTam[2]})
//aTam := TAMSX3("EXL_DSE")
//AADD(aStruc,{"DSE"       ,aTam[3],aTam[1],aTam[2]})
//aTam := TAMSX3("EXL_DTDSE")
//AADD(aStruc,{"DT_DSE"    ,aTam[3],aTam[1],aTam[2]})                                 

cTemp1:= CriaTrab(aStruc,.T.)
dbUseArea(.T.,,cTemp1,"TEMP1",.F.,.F.)

cChave := "FILIAL+INVOICE"
cInd1  := CriaTrab(NIL,.F.)
IndRegua("TEMP1",cInd1,cChave,,,"Selecionando Registros...")


#IFDEF TOP
	//AOliveira 23-08-2011 -- Chamado 003767
	/*Em atendimento ao chamado foi realizado as seguintes inclusões;
	  - Relacionamento das tabelas EEC e EXL
	  - Inclusao dos campos EXL_DSE e EXL_DTDSE*/
	  
	cQuery:= "SELECT DISTINCT"
	cQuery+= " EEC_FILIAL	FILIAL,"
	cQuery+= " EEC_NRINVO	INVOICE,"
	cQuery+= " EE9_NF		NOTA,"
	cQuery+= " EEC_DTPROC	DATA_PROC,"
	cQuery+= " EE9_NRSD	    DECLAR_DESPACHO,"
	cQuery+= " EE9_DTDDE	DATA_DECLARACAO,"
	cQuery+= " EEC_EMBARC	TIPO_EXPORT,"
	cQuery+= " EE9_RE		REGISTRO_EXPORT,"
	cQuery+= " EE9_DTRE	    DATA_REGISTRO,"
	cQuery+= " EEC_NRCONH	CONHECIMENTO_EMBARQUE,"
	cQuery+= " EEC_DTCONH	DATA_CONHECIMENTO,"
	cQuery+= " EE9_DTAVRB	DT_AVERB,"
	cQuery+= " EXL_AVRBDS	DT_AVERBDSE,"
	cQuery+= " EEC_NRODUE	NRO_DUE,"
	cQuery+= " EEC_DTDUE	DT_DUE,"
	cQuery+= " EEC_NRORUC	NRO_RUC,"
	cQuery+= " EEC_PAISET	PAIS, "
	cQuery+= " EXL_DSE		DSE, "
	cQuery+= " EXL_DTDSE	DT_DSE "
	cQuery+= " FROM EEC010, EE9010, EXL010 "
	cQuery+= " WHERE EE9_PEDIDO = EEC_PEDREF "
	cQuery+= " AND EEC_PREEMB = EXL_PREEMB "               
	If MV_PAR03 == 1
		cQuery+= " AND EEC_DTPROC BETWEEN '"+DTOS(MV_PAR01)+"' AND'"+DTOS(MV_PAR02)+"' 
	ElseIf MV_PAR03 == 2
		cQuery+= " AND EE9_DTAVRB BETWEEN '"+DTOS(MV_PAR01)+"' AND'"+DTOS(MV_PAR02)+"' 
	Else
		cQuery+= " AND EXL_AVRBDS BETWEEN '"+DTOS(MV_PAR01)+"' AND'"+DTOS(MV_PAR02)+"' 
	EndIf
	cQuery+= " AND EEC010.D_E_L_E_T_ = ' ' AND EE9010.D_E_L_E_T_ = ' ' "
	cQuery+= " AND EXL010.D_E_L_E_T_ = ' ' "
	cQuery+= " AND EXL010.EXL_FILIAL = EE9010.EE9_FILIAL "
	cQuery+= " AND EXL010.EXL_FILIAL = EEC010.EEC_FILIAL "
	cQuery+= " AND EE9010.EE9_FILIAL = EEC010.EEC_FILIAL "

	
	dbUseArea(.T., "TOPCONN", tcGenQry(,, cQuery), 'EXPORTACAO', .T.,.T.)	
//	TcQuery cQuery New Alias "EXPORTACAO"
	
	
#ENDIF
/*AADD(aStruc,{"FILIAL"    ,"C",2 ,0})
AADD(aStruc,{"INVOICE"   ,"C",20,0})
AADD(aStruc,{"NOTA"      ,"C",9 ,0})
AADD(aStruc,{"DT_PROC"   ,"D",8 ,0})
AADD(aStruc,{"DESPACHO"  ,"C",20,0})
AADD(aStruc,{"DT_DECLAR" ,"D",8 ,0})
AADD(aStruc,{"TP_EXPORT" ,"C",25,0})
AADD(aStruc,{"REG_EXPORT","C",12,0})
AADD(aStruc,{"DT_REG_EXP","D",8 ,0})
AADD(aStruc,{"CONHEC_EMB","C",20,0})
AADD(aStruc,{"DT_CONHEC" ,"D",8 ,0})
AADD(aStruc,{"DT_AVERB"  ,"D",8 ,0})
AADD(aStruc,{"PAIS"      ,"C",3 ,0})*/


dbSelectArea('EXPORTACAO')
EXPORTACAO->(dbGotop())
While EXPORTACAO->(!EOF())

	Reclock("TEMP1",.T.)

		TEMP1->FILIAL     := Alltrim(EXPORTACAO->FILIAL)
		TEMP1->INVOICE    := Alltrim(EXPORTACAO->INVOICE)
		TEMP1->NOTA       := Alltrim(EXPORTACAO->NOTA)
		TEMP1->DT_PROC    := STOD(EXPORTACAO->DATA_PROC)
		//TEMP1->DESPACHO   := Alltrim(EXPORTACAO->DECLAR_DESPACHO)
		//TEMP1->DT_DECLAR  := STOD(EXPORTACAO->DATA_DECLARACAO)
		//TEMP1->TP_EXPORT  := Alltrim(EXPORTACAO->TIPO_EXPORTACAO)
		//TEMP1->REG_EXPORT := Alltrim(EXPORTACAO->REGISTRO_EXPORTACAO)
		//TEMP1->DT_REG_EXP := STOD(EXPORTACAO->DATA_REGISTRO)
		TEMP1->CONHEC_EMB := Alltrim(EXPORTACAO->CONHECIMENTO_EMBARQUE)              
		TEMP1->DT_CONHEC  := STOD(EXPORTACAO->DATA_CONHECIMENTO)     
		
		If !Empty(EXPORTACAO->DT_AVERB)
			TEMP1->DT_AVERB   := STOD(EXPORTACAO->DT_AVERB)
		Else
			TEMP1->DT_AVERB   := STOD(EXPORTACAO->DT_AVERBDS)
		Endif
		
		//TEMP1->DT_AVERBDS := STOD(EXPORTACAO->DT_AVERBDSE)
		TEMP1->NRO_DUE 	  := Alltrim(EXPORTACAO->NRO_DUE)
		TEMP1->DT_DUE 	  := STOD(EXPORTACAO->DT_DUE)
		TEMP1->NRO_RUC 	  := Alltrim(EXPORTACAO->NRO_RUC)
		TEMP1->PAIS       := Alltrim(EXPORTACAO->PAIS)
		//TEMP1->DSE        := Alltrim(EXPORTACAO->DSE)
		//TEMP1->DT_DSE     := STOD(EXPORTACAO->DT_DSE)

	
	MsUnlock("TEMP1")
	    

EXPORTACAO->(dbSkip())

EndDo                                                                          
                      
EXPORTACAO->(dbCloseArea())


TEMP1->(dbGoTop())
                                   
While TEMP1->(!EOF())

	oSection1:Init()
	oSection1:PrintLine()
	oSection1:Finish()
	oSection1:HeaderBreak(.T.) 
	oSection1:SetHeaderSection(.F.) 
	TEMP1->(dbSkip())                                                            

EndDo

TEMP1->(dbCloseArea())

Return
