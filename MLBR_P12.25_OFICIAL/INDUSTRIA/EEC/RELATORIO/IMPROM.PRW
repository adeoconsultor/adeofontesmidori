#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"



/*
CRIACAO
ROTINA.........: IMPROM
DATA INICIO....: 08/04/2011
DATA FIM.......: 10/04/2011
SOLICITANTE....: ANA CLAUDIA ( EXPORTACAO )
OBJETIVO.......: Listar Romaneio Couro
CRIADO POR.....: EXTERNO-Luis Henrique de Oliveira - Dqzafra
*/


User Function IMPROM()
Local _aArea   := GetArea()
Local oReport  
	Private _cArq := ""
Private _cCOD_IANT := ""                  
Private _cCod_I := ""       

If FindFunction("TRepInUse") //.And. TRepInUse()

DbSelectArea("ZZA")   
dbSetOrder(1)
dbSeek(xfilial("ZZA")+cPedido)
	
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
                                      	
DbSelectArea("ZZA")   
SET FILTER TO

Endif

RestArea(_aArea)
Return

/*
ROTINA..................:ReportDef
OBJETIVO................:Definicao da estrutura do relatorio em TREPORT
*/
Static Function ReportDef()
Local oReport
Local oSection1
Local oTot
Local oBreak1  


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("EECROM","Romaneio - Pedido no. "+alltrim(cPedido),"EECROM", {|oReport| ReportPrint(oReport)},"")
oReport:SetLandScape()
oReport:SetTotalInLine(.F.)
oReport:lParamPage:= .f.

oSection0 := TRSection():New(oreport,"Packing List")
oSection0:SetHeaderSection(.T.)
oSection0:SetHeaderPage(.T.)

TRCell():New(oSection0,"DESC"      	,"EECROM",""				,/*Picture*/                	,50        ,/*lPixel*/  ,{|| _cCOD_IANT} )
//oSection0:Cell("DESC"):Hide()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oSection0,"",{"EECROM"},/*{""}*/,/*Campos do SX3*/,/*Campos do SIX*/,,,,.T./*lHeaderBreak*/,,.F./*lLineBreak*/)
//oSection1:SetLineStyle()

	oSection1:SetCellBorder("ALL",,,.T.)
	oSection1:SetCellBorder("TOP")
	oSection1:SetCellBorder("BOTTOM")
	oSection1:SetCellBorder("RIGHT")
	oSection1:SetCellBorder("LEFT")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TRCell():New(oSection1,"ARTIGO" ,"EECROM",""				,/*Picture*/                	,0        ,/*lPixel*/  ,/*{|| EECROM->ROTEIRO}*/ )
oSection1:Cell("ARTIGO"):Hide()
oSection1:Cell("ARTIGO"):Disable()


TRCell():New(oSection1,"CAIXA" ,"EECROM",""				,/*Picture*/                	,0        ,/*lPixel*/  ,/*{|| EECROM->ROTEIRO}*/ )
oSection1:Cell("CAIXA"):Hide()
oSection1:Cell("CAIXA"):Disable()

TRCell():New(oSection1,"COD_I" ,"EECROM",""				,/*Picture*/                	,0        ,/*lPixel*/  ,/*{|| EECROM->ROTEIRO}*/ )
oSection1:Cell("COD_I"):Hide()
oSection1:Cell("COD_I"):Disable()


TRCell():New(oSection1,"ITEM"      	,"EECROM","No."				,/*Picture*/                	,16        ,/*lPixel*/  ,/**/ )
TRCell():New(oSection1,"PESOB"    	,"EECROM","GROSS WEIGHT"	,PesqPict("ZZB","ZZB_SQMTOT")	,10         ,/*lPixel*/  ,/**/ )
TRCell():New(oSection1,"PESOL"   	,"EECROM","NET WEIGHT"		,PesqPict("ZZB","ZZB_SQMTOT")	,10         ,/*lPixel*/  ,/* */ )
TRCell():New(oSection1,"HEIGHT"   	,"EECROM","Height Packing"	,PesqPict("ZZB","ZZB_HEIGHT")	,10         ,/*lPixel*/  ,/* */ )
TRCell():New(oSection1,"WIDTH"    	,"EECROM","Width Packing"	,PesqPict("ZZB","ZZB_WIDTH")	,10         ,/*lPixel*/  , )
TRCell():New(oSection1,"LENGHT"    	,"EECROM","Lenght Packing"	,PesqPict("ZZB","ZZB_LENGHT")	,10         ,/*lPixel*/  ,/*{|| EECROM->QUILOS}*/)
TRCell():New(oSection1,"SIDES"	    ,"EECROM","SIDES / PACKAGE"	,"@E 99,999"					,10         ,/*lPixel*/  ,/*{|| EECROM->METROS }*/)
TRCell():New(oSection1,"SQM1" 		,"EECROM","SQ.M/ROLL"		,PesqPict("ZZB","ZZB_SQM1")		,10         ,/*lPixel*/  , )
TRCell():New(oSection1,"LOTE" 		,"EECROM","lote"			,PesqPict("ZZB","ZZB_LOTE")		,70         ,/*lPixel*/  , )
TRCell():New(oSection1,"SQM2"     	,"EECROM","SQ.M/ROLL"		,PesqPict("ZZB","ZZB_SQM2")		,10         ,/*lPixel*/  ,/*{|| EECROM->QUILOS}*/)
TRCell():New(oSection1,"SQM3"     	,"EECROM","SQ.M/ROLL"		,PesqPict("ZZB","ZZB_SQM3")		,10         ,/*lPixel*/  ,/*{|| EECROM->QUILOS}*/)
TRCell():New(oSection1,"SQMTOT" 	,"EECROM","SQ.M"			,PesqPict("ZZB","ZZB_SQMTOT")	,10         ,/*lPixel*/  ,/*{|| EECROM->QUILOS}*/)

oSection1:Cell("ITEM"):SetAlign("CENTER")
oSection1:Cell("PESOB"):SetAlign("CENTER")
oSection1:Cell("PESOL"):SetAlign("CENTER")
oSection1:Cell("HEIGHT"):SetAlign("CENTER")
oSection1:Cell("WIDTH"):SetAlign("CENTER")
oSection1:Cell("LENGHT"):SetAlign("CENTER")
oSection1:Cell("SIDES"):SetAlign("RIGHT")
oSection1:Cell("SQM1"):SetAlign("RIGHT")
oSection1:Cell("LOTE"):SetAlign("CENTER")
oSection1:Cell("SQM2"):SetAlign("RIGHT")
oSection1:Cell("SQM3"):SetAlign("RIGHT")
oSection1:Cell("SQMTOT"):SetAlign("RIGHT")


oSection1:Cell("ITEM"):nHeaderAlign  := 2
oSection1:Cell("PESOB"):nHeaderAlign  := 2
oSection1:Cell("PESOL"):nHeaderAlign  := 2
oSection1:Cell("HEIGHT"):nHeaderAlign  := 2
oSection1:Cell("WIDTH"):nHeaderAlign  := 2
oSection1:Cell("SIDES"):nHeaderAlign  := 2
oSection1:Cell("SQM1"):nHeaderAlign  := 2
oSection1:Cell("LOTE"):nHeaderAlign  := 2
oSection1:Cell("SQM2"):nHeaderAlign  := 2
oSection1:Cell("SQM3"):nHeaderAlign  := 2
oSection1:Cell("SQMTOT"):nHeaderAlign  := 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao das quebras e totalizadores que serao Impressos.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oBreak1 := TRBreak():New(oSection1    ,oSection1:Cell("CAIXA")       ,{|| "TOTAL  "+_cCod_I },.f.,"",.t.)

oTot  := TRFunction():New(oSection1:Cell("PESOB")	,/* cID */,"SUM",oBreak1, ,"@E 999,999,999.99"	,/*uFormula*/,.t./*lEndSection*/,.f./*lEndReport*/,.f./*lEndPage*/)
oTot  := TRFunction():New(oSection1:Cell("PESOL")	,/* cID */,"SUM",oBreak1, ,"@E 999,999,999.99"	,/*uFormula*/,.t./*lEndSection*/,.f./*lEndReport*/,.f./*lEndPage*/)
oTot  := TRFunction():New(oSection1:Cell("SIDES")	,/* cID */,"SUM",oBreak1, ,"@E 999,999,999"		,/*uFormula*/,.t./*lEndSection*/,.f./*lEndReport*/,.f./*lEndPage*/)
oTot  := TRFunction():New(oSection1:Cell("SQMTOT")	,/* cID */,"SUM",oBreak1, ,"@E 999,999,999.99"	,/*uFormula*/,.t./*lEndSection*/,.f./*lEndReport*/,.f./*lEndPage*/)

oBreak11 := TRBreak():New(oSection1    ,oSection1:Cell("ARTIGO")       ,{|| "TOTAL  "+EECROM->ARTIGO },.f.,"",.t.)

oTot  := TRFunction():New(oSection1:Cell("PESOB")	,/* cID */,"SUM",oBreak11, ,"@E 999,999,999.99"	,/*uFormula*/,.t./*lEndSection*/,.f./*lEndReport*/,.f./*lEndPage*/)
oTot  := TRFunction():New(oSection1:Cell("PESOL")	,/* cID */,"SUM",oBreak11, ,"@E 999,999,999.99"	,/*uFormula*/,.t./*lEndSection*/,.f./*lEndReport*/,.f./*lEndPage*/)
oTot  := TRFunction():New(oSection1:Cell("SIDES")	,/* cID */,"SUM",oBreak11, ,"@E 999,999,999"		,/*uFormula*/,.t./*lEndSection*/,.f./*lEndReport*/,.f./*lEndPage*/)
oTot  := TRFunction():New(oSection1:Cell("SQMTOT")	,/* cID */,"SUM",oBreak11, ,"@E 999,999,999.99"	,/*uFormula*/,.t./*lEndSection*/,.f./*lEndReport*/,.f./*lEndPage*/)

//oSection1:SetHeaderBreak(.t.)
oSection1:SetPageBreak(.f.) 
oReport:lPageBreak:= .f.                                               
oSection1:SetHeaderBreak(.t.)
oReport:SetTotalInLine(.f.)


//////////////////////SECTION2

oSection2 := TRSection():New(oReport,"",{"EECROM2"},/*{""}*/,/*Campos do SX3*/,/*Campos do SIX*/,,,,.T./*lHeaderBreak*/,,.F./*lLineBreak*/)

	oSection2:SetCellBorder("ALL",,,.T.)
	oSection2:SetCellBorder("TOP")
	oSection2:SetCellBorder("BOTTOM")
	oSection2:SetCellBorder("RIGHT")
	oSection2:SetCellBorder("LEFT")

TRCell():New(oSection2,"ARTIGO"    	,"EECROM2","ARTIGO"			,/*Picture*/                	,06        ,/*lPixel*/  ,/**/ )
//oSection2:Cell("ARTIGO"):Hide()
//oSection2:Cell("ARTIGO"):Disable()

TRCell():New(oSection2,"DESC"      	,"EECROM2","CLASS"			,/*Picture*/                	,06        ,/*lPixel*/  ,/**/ )
TRCell():New(oSection2,"SIDES"	    ,"EECROM2","(VAQ)"			,"@E 99,999"					,10         ,/*lPixel*/  ,/*{|| EECROM->METROS }*/)
TRCell():New(oSection2,"SQMTOT" 	,"EECROM2","(M2)"			,PesqPict("ZZB","ZZB_SQMTOT")	,10         ,/*lPixel*/  ,/*{|| EECROM->QUILOS}*/)

oSection2:Cell("DESC"):SetAlign("CENTER")
oSection2:Cell("SIDES"):SetAlign("RIGHT")
oSection2:Cell("SQMTOT"):SetAlign("RIGHT")

oSection2:Cell("DESC"):nHeaderAlign  := 3
oSection2:Cell("SIDES"):nHeaderAlign  := 2
oSection2:Cell("SQMTOT"):nHeaderAlign  := 2

//oBreak2 := TRBreak():New(oSection2    ,oSection2:Cell("ARTIGO")       ,{|| "TOTAL  " },.f.,"",.t.)

//oTot  := TRFunction():New(oSection2:Cell("SIDES")	,/* cID */,"SUM",oBreak2, ,"@E 999,999,999.99"	,/*uFormula*/,.f./*lEndSection*/,.f./*lEndReport*/,.f./*lEndPage*/)
//oTot  := TRFunction():New(oSection2:Cell("SQMTOT")	,/* cID */,"SUM",oBreak2, ,"@E 999,999,999.99"	,/*uFormula*/,.f./*lEndSection*/,.f./*lEndReport*/,.f./*lEndPage*/)

oSection2:SetPageBreak(.f.) 
                                      
//////////////////////////////////////


//////////////////////SECTION3

oSection3 := TRSection():New(oReport,"",{"EECROM3"},/*{""}*/,/*Campos do SX3*/,/*Campos do SIX*/,,,,.T./*lHeaderBreak*/,,.F./*lLineBreak*/)

	oSection3:SetCellBorder("ALL",,,.T.)
	oSection3:SetCellBorder("TOP")
	oSection3:SetCellBorder("BOTTOM")
	oSection3:SetCellBorder("RIGHT")
	oSection3:SetCellBorder("LEFT")

TRCell():New(oSection3,"DESC"      	,"EECROM3","PALLET No."			,/*Picture*/                	,12        ,/*lPixel*/  ,/**/ )
TRCell():New(oSection3,"SIDES"	    ,"EECROM3","(VAQ)"			,"@E 999,999",10         ,/*lPixel*/  ,/*{|| EECROM->METROS }*/)
TRCell():New(oSection3,"SQMTOT" 	,"EECROM3","(M2)"			,PesqPict("ZZB","ZZB_SQMTOT")	,10         ,/*lPixel*/  ,/*{|| EECROM->QUILOS}*/)
TRCell():New(oSection3,"PESOB"	 	,"EECROM3","KG / PALLET"	,PesqPict("ZZB","ZZB_PESOB")	,10         ,/*lPixel*/  ,/*{|| EECROM->QUILOS}*/)
TRCell():New(oSection3,"LOTE" 		,"EECROM3","No. PARTIDAS"			,/*Picture*/					,70         ,/*lPixel*/  ,/*{|| EECROM->QUILOS}*/)

oSection3:Cell("DESC"):SetAlign("CENTER")
oSection3:Cell("SIDES"):SetAlign("RIGHT")
oSection3:Cell("SQMTOT"):SetAlign("RIGHT")
oSection3:Cell("PESOB"):SetAlign("RIGHT")
oSection3:Cell("LOTE"):SetAlign("CENTER")


oSection3:Cell("DESC"):nHeaderAlign  := 3
oSection3:Cell("SIDES"):nHeaderAlign  := 2
oSection3:Cell("SQMTOT"):nHeaderAlign  := 2
oSection3:Cell("PESOB"):nHeaderAlign  := 2
oSection3:Cell("LOTE"):nHeaderAlign  := 2

oSection3:SetPageBreak(.f.) 
                                      
//////////////////////////////////////



Return(oReport)


/*
ROTINA..................:ReportPrint
OBJETIVO................:Rotina de Impressao TREPORT utilizando o objeto oReport
*/

Static Function ReportPrint(oReport)
Local oSection0 := oReport:Section(1)
Local oSection1 := oReport:Section(1):Section(1)
Local oSection2 := oReport:Section(2)
Local oSection3 := oReport:Section(3)

Local _nPage := 0
Private _aCOD_I := {}

GERAEECROM()  // gera arquivo temporario

                
oSection0:Init()
      
DbSelectArea("EECROM")
dbGoTop()
           
_n := 1                   
_cCod_I := _aCOD_I[_n]
_cCod_I := EECROM->COD_I

oReport:SetMeter(RecCount())
oSection1:Init()

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf

//    if oReport:Page() <> _nPage
    if EECROM->COD_I <> _cCod_I
         
		dbSkip(-1)
		_cCOD_IANT := EECROM->DESC
		dbSkip()       
		
		if _cCod_I <> ""
			oReport:SkipLine()
		Endif	

		oSection0:PrintLine()
		_nPage := oReport:page()
     
/*		_n++
		if _n <= len(_aCOD_I)
			_cCod_I := _aCOD_I[_n]
		Else
			_cCod_I := "X"
		Endif		    
*/  
				
		_cCod_I := EECROM->COD_I
	Endif	
	                             
	oSection1:PrintLine()
	
	DbSelectArea("EECROM")
	DbSkip()
	
	oReport:IncMeter()
End


dbSkip(-1)
_cCOD_IANT := EECROM->DESC
		
if _cCod_I <> ""
	oReport:SkipLine()
Endif	


oSection0:PrintLine()
oSection1:Finish()
oSection0:Finish()

//////////////////////////SECTION2

DbSelectArea("EECROM2")
dbGoTop()
oReport:SetMeter(RecCount())
oReport:SkipLine(3)

oSection2:Init()                


         
While !Eof()
	
	oSection2:PrintLine()
   
	DbSelectArea("EECROM2")
	DbSkip()


End

oSection2:Finish()
////////////////////////////////////////////


//////////////////////////SECTION3

DbSelectArea("EECROM3")
dbGoTop()
oReport:SetMeter(RecCount())
oReport:SkipLine(3)

oSection3:Init()                


         
While !Eof()
	
	oSection3:PrintLine()
   
	DbSelectArea("EECROM3")
	DbSkip()


End

oSection3:Finish()
////////////////////////////////////////////


IF !EMPTY(_cARQ)
	DBSELECTAREA("EECROM")
	USE
	DBSELECTAREA("EECROM2")
	USE
	DBSELECTAREA("EECROM3")
	USE


	FERASE((_cArq+".DBF"))
	FERASE((_cArq+".CDX"))
ENDIF

Return



/*
ROTINA..................:fGeraTabEECROM
OBJETIVO................:Gerar Arquivo de trabalho temporario para utilizacao pelo TREPORT
*/
Static Function GeraEECROM()

Local _lRet    := .f.
Local _aEstru  := {}
Local _aEstru2 := {}
Local _aEstru3 := {}

Local _aTam    := {}
Local _cIndex, _cKey, _nIndex

Local _cClass := ""
Local _aClass := {}     

Local _aPallet := {}
Local _cPallet := ""            

Local nCount,_nx := 0

// CRIACAO E ORDENACAO DE TABELA TEMPORARIA
///////////////////////////////////////////

_aTam:=TamSX3("ZZB_COD_I")
AADD(_aEstru,{"COD_I","C",_aTam[1]})
_aTam:=TamSX3("B1_DESC")
AADD(_aEstru,{"DESC","C",_aTam[1]})

_aTam:=TamSX3("ZZB_ITEM")
//AADD(_aEstru,{"ITEM","C",_aTam[1]})
AADD(_aEstru,{"ITEM","C",12})

_aTam:=TamSX3("ZZB_PESOB")
AADD(_aEstru,{"PESOB","N",_aTam[1],_aTam[2]})
_aTam:=TamSX3("ZZB_PESOL")
AADD(_aEstru,{"PESOL","N",_aTam[1],_aTam[2]})

_aTam:=TamSX3("ZZB_HEIGHT")
AADD(_aEstru,{"HEIGHT","C",_aTam[1]})
_aTam:=TamSX3("ZZB_WIDTH")
AADD(_aEstru,{"WIDTH","C",_aTam[1]})
_aTam:=TamSX3("ZZB_LENGHT")
AADD(_aEstru,{"LENGHT","C",_aTam[1]})

_aTam:=TamSX3("ZZB_LOTE")
AADD(_aEstru,{"LOTE","C",_aTam[1]})

_aTam:=TamSX3("ZZB_SQM1")
AADD(_aEstru,{"SQM1","N",_aTam[1],_aTam[2]})
_aTam:=TamSX3("ZZB_SQM2")
AADD(_aEstru,{"SQM2","N",_aTam[1],_aTam[2]})
_aTam:=TamSX3("ZZB_SQM3")
AADD(_aEstru,{"SQM3","N",_aTam[1],_aTam[2]})
_aTam:=TamSX3("ZZB_SQMTOT")
AADD(_aEstru,{"SQMTOT","N",_aTam[1],_aTam[2]})

AADD(_aEstru,{"SIDES","N",_aTam[1],_aTam[2]}) //converter caracter para numerico para totalizar
AADD(_aEstru,{"CAIXA","C",4,0})
AADD(_aEstru,{"ARTIGO","C",20,0})


_cArq := CriaTrab(_aEstru,.T.)
dbUseArea(.t.,,_cArq,"EECROM",.T.,.F.)

_cIndex:= CriaTrab("EECROM",.F.)
_cKey := "ITEM"
IndRegua("EECROM",_cIndex,_cKey,,,"Selecionando Registros...")

EECROM->(DbSetOrder(1))



/////////////////////////////////SECTION2

_aTam:=TamSX3("B1_DESC")
AADD(_aEstru2,{"DESC","C",_aTam[1]})

_aTam:=TamSX3("ZZB_SQMTOT")
AADD(_aEstru2,{"SQMTOT","N",_aTam[1],_aTam[2]})

AADD(_aEstru2,{"SIDES","N",_aTam[1],_aTam[2]}) //converter caracter para numerico para totalizar
AADD(_aEstru2,{"ARTIGO","C",20,0})


_cArq := CriaTrab(_aEstru2,.T.)
dbUseArea(.t.,,_cArq,"EECROM2",.T.,.F.)

_cIndex:= CriaTrab("EECROM2",.F.)
_cKey := "ARTIGO"
IndRegua("EECROM2",_cIndex,_cKey,,,"Selecionando Registros...")

EECROM2->(DbSetOrder(1))


/////////////////////////////////


/////////////////////////////////SECTION3

_aTam:=TamSX3("B1_DESC")
AADD(_aEstru3,{"LOTE","C",_aTam[1]})
AADD(_aEstru3,{"DESC","C",12,0})

_aTam:=TamSX3("ZZB_SQMTOT")
AADD(_aEstru3,{"SQMTOT","N",_aTam[1],_aTam[2]})

AADD(_aEstru3,{"SIDES","N",_aTam[1],_aTam[2]}) //converter caracter para numerico para totalizar

_aTam:=TamSX3("ZZB_PESOB")
AADD(_aEstru3,{"PESOB","N",_aTam[1],_aTam[2]})



_cArq := CriaTrab(_aEstru3,.T.)
dbUseArea(.t.,,_cArq,"EECROM3",.T.,.F.)

_cIndex:= CriaTrab("EECROM3",.F.)
_cKey := "DESC"
IndRegua("EECROM3",_cIndex,_cKey,,,"Selecionando Registros...")

EECROM3->(DbSetOrder(1))


/////////////////////////////////

                        
_nCaixa := 1

SB1->(DBSETORDER(1))

dbSelectArea("ZZB")
ZZB->(dbSetOrder(1))
dbSeek(xfilial("ZZB")+ZZA->ZZA_PEDIDO)

while ! ZZB->(eof()) .and. ZZB->ZZB_FILIAL+ZZB->ZZB_PEDIDO == xfilial("ZZB")+ZZA->ZZA_PEDIDO
	                                                      
	
	//ZZB->ZZB_ARTIGO+ZZB->ZZB_SEQUEN  == ZZA->ZZA_ARTIGO+ZZA->ZZA_SEQUEN
	
	SB1->(DBSEEK(xFILIAL("SB1")+ZZB->ZZB_COD_I))
	_cSB1_Desc := SB1->B1_DESC                  
	
	dbSelectArea("EECROM")
		
	Reclock("EECROM",.T.)
	EECROM->COD_I 	  	:= ZZB->ZZB_COD_I
	EECROM->DESC      	:= _cSB1_Desc
//	EECROM->ITEM 	  	:= strzero(val(ZZB->ZZB_NRPCTE),3)
	EECROM->ITEM 	  	:= ZZB->ZZB_NRPCTE
	EECROM->PESOB	  	:= ZZB->ZZB_PESOB
	EECROM->PESOL	  	:= ZZB->ZZB_PESOL
	EECROM->HEIGHT   	:= ZZB->ZZB_HEIGHT
	EECROM->WIDTH    	:= ZZB->ZZB_WIDTH
	EECROM->LENGHT    	:= ZZB->ZZB_LENGHT
	EECROM->SIDES	   	:= val(ZZB->ZZB_SIDES)
	EECROM->LOTE	    := ZZB->ZZB_LOTE
	EECROM->SQM1     	:= ZZB->ZZB_SQM1
	EECROM->SQM2		:= ZZB->ZZB_SQM2
	EECROM->SQM3      	:= ZZB->ZZB_SQM3
	EECROM->SQMTOT    	:= ZZB->ZZB_SQMTOT
	EECROM->CAIXA    	:= strzero(_nCaixa,4)
	EECROM->ARTIGO		:= ZZB->ZZB_ARTIGO	
	
	MsUnlock()
	                 
	if ascan(_aCOD_I, EECROM->COD_I   ) == 0
	
		AADD(_aCOD_I,EECROM->COD_I)	
	
	Endif                                                
	    
	//EXTRAI CLASSE DENTRO DA DESCRICAO
	////////////////////////////////////////////////////////
	_cClass := ""
	_nPos := at("CLASS", _cSB1_Desc)			
	For _nx := _nPos+6 to len(_cSB1_Desc)
		IF substr(_cSB1_Desc,_nx,1) <> space(1) 				
			_cClass += substr(_cSB1_Desc,_nx,1)
		Else	
			if ! empty(_cClass)
				exit
			Endif				
		Endif	
	Next
         
	//TOTALIZA (VAQ) e (M2) NO VETOR _ACLASS
//	_nPos := ascan(_aClass,{|x| x[1] ==_cClass})
	_nPos := ascan(_aClass,{|x| x[4] ==_cClass+"-"+ZZB->ZZB_ARTIGO})
	if _nPos == 0 
		AADD(_aClass,{_cClass,val(ZZB->ZZB_SIDES),ZZB->ZZB_SQMTOT, _cClass+"-"+ZZB->ZZB_ARTIGO })
	Else
		_aClass[_nPos][2] += val(ZZB->ZZB_SIDES)
		_aClass[_nPos][3] += ZZB->ZZB_SQMTOT
	Endif
	////////////////////////////////////////////////////////


	//TOTALIZA (VAQ),(M2), KG/PALLET, No.PARTIDAS     NO VETOR _APALLET
	////////////////////////////////////////////////////////
	_cPallet := ZZB->ZZB_NRPCTE
	_nPos := ascan(_aPallet,{|x| x[1] ==_cPallet})
	if _nPos == 0
		AADD(_aPallet,{_cPallet,val(ZZB->ZZB_SIDES),ZZB->ZZB_SQMTOT,ZZB->ZZB_PESOB,alltrim(ZZB->ZZB_LOTE) })
	Else
		_aPallet[_nPos][2] += val(ZZB->ZZB_SIDES)
		_aPallet[_nPos][3] += ZZB->ZZB_SQMTOT
		_aPallet[_nPos][4] += ZZB->ZZB_PESOB
//		_aPallet[_nPos][5] += alltrim(ZZB->ZZB_LOTE)
	Endif
    ////////////////////////////////////////////////////////     
	    
	_cNrPcte := ZZB->ZZB_NRPCTE
	_cProduto := ZZB->ZZB_COD_I
	_cArtigo := ZZB->ZZB_ARTIGO		
	
	dbSelectArea("ZZB")
	ZZB->(dbSkip())
	
	if (ZZB->ZZB_COD_I <> _cProduto .and. ZZB->ZZB_NRPCTE <> _cNrPcte ) .or. ZZB->ZZB_ARTIGO <> _cArtigo
		_cProduto := ZZB->ZZB_COD_I
		_cArtigo := ZZB->ZZB_ARTIGO		

		_nCaixa += 1 
	Endif	
	
	
End
    
//////////TOTAL POR CLASSE
For _nx := 1 to len(_aClass)

	dbSelectArea("EECROM2")
		
	Reclock("EECROM2",.T.)
	EECROM2->DESC      	:= _aClass[_nx][1]
	EECROM2->SIDES	   	:= _aClass[_nx][2]
	EECROM2->SQMTOT    	:= _aClass[_nx][3]	           
	
	_nPos := at("-",_aClass[_nx][4])
	EECROM2->ARTIGO		:= substr(_aClass[_nx][4],_nPos+1,len(_aClass[_nx][4])-_npos)
	MsUnlock()

Next
                     

_aClass := {}
aadd(_aClass,{0,0,0,0})
aSort(_aPallet,,,{|x,y| y[1] > x[1] })
//////////TOTAL POR PALLET
For _nx := 1 to len(_aPallet)

	dbSelectArea("EECROM3")
		
	Reclock("EECROM3",.T.)
	EECROM3->DESC      	:= _aPallet[_nx][1]
	EECROM3->SIDES	   	:= _aPallet[_nx][2]
	EECROM3->SQMTOT    	:= _aPallet[_nx][3]	
	EECROM3->PESOB    	:= _aPallet[_nx][4]	
	EECROM3->LOTE    	:= _aPallet[_nx][5]	
	MsUnlock()
   
	_aClass[1][2] += _aPallet[_nx][2] //TOTAL VAQ
	_aClass[1][3] += _aPallet[_nx][3] //TOTAL M2
	_aClass[1][4] += _aPallet[_nx][4] //TOTAL KG
	
	nCount ++
	
Next
    
_aClass[1][1] := cValToChar(nCount) //_aPallet[_nx-1][1] //PALLET

//////GRAVA TOTAL
Reclock("EECROM3",.T.)
EECROM3->DESC      	:= _aClass[1][1]
EECROM3->SIDES	   	:= _aClass[1][2]
EECROM3->SQMTOT    	:= _aClass[1][3]	
EECROM3->PESOB		:= _aClass[1][4]
MsUnlock()
/////////////

dbSelectArea("EECROM")

Return(_lRet)