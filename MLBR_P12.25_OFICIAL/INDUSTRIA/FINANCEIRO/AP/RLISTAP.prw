#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "rwmake.ch"
/*--------------------------------------------------------- 
Funcao: RLISTAP
Autor : AOliveira
Descr : Rotina tem como objetivo realizar impressão de 
        listagem de pagto.
-----------------------------------------------------------
Alterações :
              12-03-2019 -- AOliveira
              Inclusão do MV_PAR02 para que seja possivel 
              realizar a listagem com data de vencimento
              de / ate. (Solicitado pela Tatiana Financeiro
               
-----------------------------------------------------------
---------------------------------------------------------*/

User Function RLISTAP() //chamada

Local oReport
Private cPerg   := "XRLISTAP"

CriaSX1(cPerg)
If !Pergunte(cPerg,.T.)
	Return
EndIf
		
//VALIDPERG(cPerg)
//Pergunte(cPerg,.T.)

oReport := ReportDef()
oReport:PrintDialog()

Return

Static Function ReportDef() // Titulo
Local oReport
Local oSection
Local oBreak
Local aOrdem    := {}

oReport := TReport():New("XRLISTAP","Listagem de Pagamento ","XRLISTAP",{|oReport| PrintReport(oReport,aOrdem)},"")
oReport:SetLandScape()

Return oReport


Static Function PrintReport(oReport,aOrdem)  //print


Local nOrdem   	:= oReport:GetOrder()
Local cPart, x

oSection := TRSection():New(oReport,OemToAnsi("Relatorio de Saldos"),,, .F., .F. )    

oSection1 := TRSection():New(oReport," ",,, .F., .F. )    
  
//  TRCell():New(/*oSection*/, /*X3_CAMPO*/, /*Tabela*/, /*Titulo*/, /*Picture*/, /*Tamanho*/, /*lPixel*/, /*{|| code-block de impressao }*/)

TRCell():New(oSection,"FPg"        ,"" ,"FPg"         ,PesqPict("SZW","ZW_FPAGT")	,03                                       ,/*lPixel*/,)
TRCell():New(oSection,"Num AP"     ,"" ,"Num AP"      ,PesqPict("SZW","ZW_NUMAP")	,TamSx3("ZW_NUMAP")[1]+1                     ,/*lPixel*/,)
TRCell():New(oSection,"Codigo"     ,"" ,"Codigo"      ,PesqPict("SZW","ZW_FORNECE")	,TamSx3("ZW_FORNECE")[1]+1                      ,/*lPixel*/,)
TRCell():New(oSection,"Loja"       ,"" ,"Loja"        ,PesqPict("SZW","ZW_LOJA")	,TamSx3("ZW_LOJA")[1]                    ,/*lPixel*/,)
TRCell():New(oSection,"Nome"       ,"" ,"Nome"        ,PesqPict("SZW","ZW_NOMFOR")	,TamSx3("ZW_NOMFOR")[1]                     ,/*lPixel*/,)
TRCell():New(oSection,"Fl"         ,"" ,"Fl"          ,PesqPict("SE2","E2_FILIAL")	,TamSx3("E2_FILIAL")[1]                     ,/*lPixel*/,)
TRCell():New(oSection,"Prf"        ,"" ,"Prf"         ,PesqPict("SE2","E2_PREFIXO")	,TamSx3("E2_PREFIXO")[1]                     ,/*lPixel*/,)
TRCell():New(oSection,"Num Tit"    ,"" ,"Num Tit"     ,PesqPict("SE2","E2_NUM")		,TamSx3("E2_NUM")[1] +1                    ,/*lPixel*/,)
TRCell():New(oSection,"Prc"        ,"" ,"Prc"         ,PesqPict("SE2","E2_PARCELA")	,TamSx3("E2_PARCELA")[1]                     ,/*lPixel*/,)
TRCell():New(oSection,"TP"         ,"" ,"TP"          ,PesqPict("SE2","E2_TIPO")	,04 /*TamSx3("E2_TIPO")[1] */                    ,/*lPixel*/,)
TRCell():New(oSection,"Vlr Titulo" ,"" ,"Vlr Titulo"  ,PesqPict("SE2","E2_VALOR")	,TamSx3("E2_VALOR")[1]                     ,/*lPixel*/,)
TRCell():New(oSection,"Vlr PIS"    ,"" ,"Vlr PIS"     ,PesqPict("SE2","E2_PIS")		,TamSx3("E2_PIS")[1]                     ,/*lPixel*/,)
TRCell():New(oSection,"Vlr COFINS" ,"" ,"Vlr COFINS"  ,PesqPict("SE2","E2_COFINS")	,TamSx3("E2_COFINS")[1]                     ,/*lPixel*/,)
TRCell():New(oSection,"Vlr CSLL"   ,"" ,"Vlr CSLL"    ,PesqPict("SE2","E2_CSLL")	,TamSx3("E2_CSLL")[1]                    ,/*lPixel*/,)
TRCell():New(oSection,"Vlr a Pagar","" ,"Vlr a Pagar" ,PesqPict("SE2","E2_VALOR")	,TamSx3("E2_VALOR")[1]                    ,/*lPixel*/,)
TRCell():New(oSection,"Emissao"    ,"" ,"Emissao"  ,,10,,)
TRCell():New(oSection,"Vecnto"     ,"" ,"Vecnto"   ,,10,,)
TRCell():New(oSection,"Dt Lib"     ,"" ,"Dt Lib"   ,,10,,)
TRCell():New(oSection,"Status"     ,"" ,"Status"   ,PesqPict("SZW","ZW_STATUS")		,TamSx3("ZW_STATUS")[1]                   ,/*lPixel*/,)
TRCell():New(oSection,"Num bor"    ,"" ,"Num Bor"  ,PesqPict("SE2","E2_NUMBOR")		,TamSx3("E2_NUMBOR")[1]                     ,/*lPixel*/,)

TRCell():New(oSection,"Naturez"    ,"" ,"Naturez"  ,PesqPict("SE2","E2_NATUREZ")	,TamSx3("E2_NATUREZ")[1] +1                     ,/*lPixel*/,)
TRCell():New(oSection,"Origem"     ,"" ,"Origem"   ,PesqPict("SE2","E2_X_ORIG")	    ,TamSx3("E2_X_ORIG")[1] +1                    ,/*lPixel*/,)

TRCell():New(oSection,"Bco"        ,"" ,"Bco"      ,PesqPict("SZW","ZW_BCOFV")	    ,03                   ,/*lPixel*/,)
TRCell():New(oSection,"AG FV"      ,"" ,"AG FV"    ,PesqPict("SE2","ZW_AGEFV")	    ,TamSx3("ZW_AGEFV")[1] +1                    ,/*lPixel*/,)
TRCell():New(oSection,"CTA FV"     ,"" ,"CTA FV"   ,PesqPict("SE2","ZW_CTAFV")	    ,TamSx3("ZW_CTAFV")[1] +1                    ,/*lPixel*/,)
TRCell():New(oSection,"TPCTA"      ,"" ,"TPCTA"    ,PesqPict("SE2","ZW_TPCTA")	    ,TamSx3("ZW_TPCTA")[1]                     ,/*lPixel*/,)

oBreak  := TRBreak():New(oSection,{ || oSection:Cell("FPg"):uPrint })

TRFunction():New(oSection:Cell("Vlr a Pagar"),NIL,"SUM",oBreak)


TRCell():New(oSection1,"Legenda"     ,"" ," "   ,"@!"		,200                     ,/*lPixel*/,)

//oBreak  := TRBreak():New(oSection,{ || oSection:Cell('Valor'):uPrint })

//TRFunction():New(oSection:Cell('Valor'),NIL,"SUM",oBreak)


//Processa a query que retorna os dados de vendas do vendedor -- Area Trb = QUERY

u_QryRel()

nCont:=0
QUERY->( dbEval( {|| nCont++ } ) )
QUERY->( dbGoTop() )
oReport:SetMeter(nCont)		// Total de Elementos da regua

oSection:Init()

While(!QUERY->(Eof()))
	oReport:IncMeter()   

	oSection:Cell("FPg")    	:SetBlock( { || QUERY->ZW_FPAGT	} )
	oSection:Cell("Num AP")		:SetBlock( { || QUERY->ZW_NUMAP	} )
	oSection:Cell("Codigo")		:SetBlock( { || QUERY->ZW_FORNECE	} )
	oSection:Cell("Loja")		:SetBlock( { || QUERY->ZW_LOJA	} )
	oSection:Cell("Nome")		:SetBlock( { || QUERY->ZW_NOMFOR	} )
	oSection:Cell("Fl")			:SetBlock( { || QUERY->E2_FILIAL	} )
	oSection:Cell("Prf")		:SetBlock( { || QUERY->E2_PREFIXO	} )
	oSection:Cell("Num Tit")	:SetBlock( { || QUERY->E2_NUM	} )
	oSection:Cell("Prc")		:SetBlock( { || QUERY->E2_PARCELA	} )
	oSection:Cell("TP")			:SetBlock( { || QUERY->E2_TIPO	} )

	oSection:Cell("Vlr Titulo")	:SetBlock( { || QUERY->E2_VALOR	} )  
	oSection:Cell("Vlr PIS")	:SetBlock( { || QUERY->E2_PIS } )  
	oSection:Cell("Vlr COFINS")	:SetBlock( { || QUERY->E2_COFINS } )  
	oSection:Cell("Vlr CSLL")	:SetBlock( { || QUERY->E2_CSLL	} )  
	oSection:Cell("Vlr a Pagar"):SetBlock( { || QUERY->VLRPAGAR	} )  
		   
	/*	
	oSection:Cell("Emissao")	:SetBlock( { || Dtoc(StoD(QUERY->E2_EMISSAO))	} )
	oSection:Cell("Vecnto")		:SetBlock( { || Dtoc(StoD(QUERY->E2_VENCREA))	} )
	oSection:Cell("Dt Lib")		:SetBlock( { || Dtoc(StoD(QUERY->E2_DATALIB))	} )  
	*/
	              
	oSection:Cell("Emissao")	:SetBlock( { || Day2Str(StoD(QUERY->E2_EMISSAO)) +'/'+ Month2Str(StoD(QUERY->E2_EMISSAO)) +'/'+ SubStr(Year2Str(StoD(QUERY->E2_EMISSAO)),3,2)	} )
	oSection:Cell("Vecnto")	:SetBlock( { || Day2Str(StoD(QUERY->E2_VENCREA)) +'/'+ Month2Str(StoD(QUERY->E2_VENCREA)) +'/'+ SubStr(Year2Str(StoD(QUERY->E2_VENCREA)),3,2)	} )
	oSection:Cell("Dt Lib")	:SetBlock( { || Iif(Day2Str(StoD(QUERY->E2_DATALIB)) == "00","  ",Day2Str(StoD(QUERY->E2_DATALIB)) ) +'/'+ Iif(Month2Str(StoD(QUERY->E2_DATALIB)) == "00","  ",Month2Str(StoD(QUERY->E2_DATALIB)) ) +'/'+ SubStr(  Iif(Year2Str(StoD(QUERY->E2_DATALIB)) == "0000","  ",Year2Str(StoD(QUERY->E2_DATALIB)) ) ,3,2)	} )
	
	
	oSection:Cell("Status")		:SetBlock( { || IIF(QUERY->ZW_STATUS == "A","BLQ","")	} )

	oSection:Cell("Num bor")    :SetBlock( { || Alltrim(QUERY->E2_NUMBOR)	} )
	oSection:Cell("Naturez")    :SetBlock( { || Alltrim(QUERY->E2_NATUREZ)	} )
	oSection:Cell("Origem")     :SetBlock( { || Alltrim(QUERY->E2_X_ORIG)	} )

	oSection:Cell("Bco")		:SetBlock( { || QUERY->ZW_BCOFV	} )
	oSection:Cell("AG FV")  :SetBlock( { || Alltrim(QUERY->ZW_AGEFV)	} )
	oSection:Cell("CTA FV") :SetBlock( { || Alltrim(QUERY->ZW_CTAFV)	} )
	oSection:Cell("TPCTA")  :SetBlock( { || Iif(Alltrim(QUERY->ZW_TPCTA) == "1" , "CC" ,"CP" )	} )

	oSection:PrintLine()
	QUERY->(DbSkip())
EndDo

QUERY->(DbCloseArea())

oSection:Finish()
oSection:Print()      
 
//
//     
x := 0
aLeng := {" ","Legenda: (FPag) "," ","1 = DOC/TED","2 = Boleto/DDA","3 = Cheque","4 = Dinheiro/Caixa","5 = Cnab a Pagar","6 = Cartao Corporativo"}
oSection1:Init()                                                                                                                                
For x := 1 To Len(aLeng)
	oSection1:Cell("Legenda")	:SetBlock( { || aLeng[x] } ) 
	oSection1:PrintLine()
Next x
oSection1:Finish()
oSection1:Print()  
//
// 
                
//
/*/
oSection1:Init()
oSection1:Cell("Legenda")	:SetBlock( { || "1=DOC/TED; 2=Boleto/DDA; 3=Cheque; 4=Dinheiro/Caixa; 5=Cnab a Pagar; 6=Cartao Corporativo"	} ) 
oSection1:PrintLine()
oSection1:Finish()
oSection1:Print()  
/*/
//

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Validperg ºAutor  ³º Data ³  03/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria as perguntas do SX1                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VALIDPERG(cPerg)

// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,;
// cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5

PutSx1(cPerg,"01","Periodo   ?"," "," ","mv_ch1","D",8,0,0, "G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo para a listagem"},{"Informe o periodo para a listagem"},{"Informe o periodo para a listagem"})


Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QryRel ºAutor André Jaar - ErpWorks ³º Data ³  14/04/12     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Query do relatório                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function QryRel()

Local cQuery	:= ""

If SELECT("QUERY") > 0     //Caso haja uma TRB em aberto, Fecha
	DbSelectArea("QUERY")
	DbCloseArea("QUERY")
EndIf

/*
cQuery := " SELECT ZW_FPAGT, ZW_BCOFV, ZW_NUMAP, ZW_FORNECE, ZW_LOJA, ZW_NOMFOR, "+CRLF
cQuery += "        E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_VALOR, E2_EMISSAO, E2_VENCREA, E2_DATALIB, ZW_STATUS "+CRLF
cQuery += " FROM "+RetSQLName("SE2") +" SE2 "+CRLF
cQuery += " INNER JOIN "+RetSQLName("SZW") +" SZW ON ZW_FILIAL = E2_FILIAL "+CRLF
cQuery += "                     AND ZW_PREFIXO = E2_PREFIXO "+CRLF
cQuery += "                     AND ZW_NUM = E2_NUM "+CRLF
cQuery += "                     AND ZW_PARCELA = E2_PARCELA "+CRLF
cQuery += "                     AND ZW_TIPO = E2_TIPO "+CRLF
cQuery += "                     AND ZW_FORNECE = E2_FORNECE "+CRLF
cQuery += "                     AND ZW_LOJA = E2_LOJA "+CRLF
cQuery += "                     --AND ZW_STATUS <> 'A' "+CRLF
cQuery += "                     AND SZW.D_E_L_E_T_ = '' "+CRLF
cQuery += " WHERE E2_FILIAL = ' ' "+CRLF
cQuery += " -- AND E2_EMISSAO >= '20180901' "+CRLF
cQuery += " AND E2_VENCREA = '"+ DtoS(MV_PAR01) +"' "+CRLF
cQuery += " AND E2_TIPO IN ('NF','FT') "+CRLF
cQuery += " -- AND E2_BAIXA = '' "+CRLF
cQuery += " AND E2_SALDO > 0 "+CRLF
cQuery += " AND SE2.D_E_L_E_T_ = '' "+CRLF
cQuery += " ORDER BY ZW_FPAGT, ZW_BCOFV ,ZW_NUMAP, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO  "+CRLF
*/                                                                                                

//cQuery := " SELECT ZW_FPAGT, ZW_BCOFV, ZW_NUMAP, ZW_FORNECE, ZW_LOJA, ZW_NOMFOR, 
cQuery := " SELECT E2_X_FPAGT AS ZW_FPAGT, ZW_BCOFV, ZW_NUMAP, ZW_FORNECE, ZW_LOJA, ZW_NOMFOR, "+CRLF
cQuery += "         E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_VALOR, "+CRLF
cQuery += "         E2_PIS,E2_COFINS,E2_CSLL,"+CRLF
cQuery += "         (((E2_VALOR + E2_ACRESC) + ( (E2_MULTA + E2_JUROS+ E2_CORREC) - E2_DECRESC )) - (E2_PIS+E2_COFINS+E2_CSLL)) AS VLRPAGAR"+CRLF
cQuery += "         ,E2_EMISSAO, E2_VENCREA, E2_DATALIB, ZW_STATUS, E2_NUMBOR, E2_NATUREZ,ED_DESCRIC, E2_X_ORIG "+CRLF
cQuery += "         , ZW_AGEFV, ZW_CTAFV, ZW_TPCTA "+CRLF
cQuery += " FROM "+RetSQLName("SE2") +" SE2 "+CRLF
cQuery += " INNER JOIN "+RetSQLName("SZW") +" SZW ON ZW_FILIAL = E2_FILIAL "+CRLF
cQuery += "                     AND ZW_NUMAP = E2_X_NUMAP "+CRLF
cQuery += "                     -- AND ZW_PREFIXO = E2_PREFIXO "+CRLF
cQuery += "                     -- AND ZW_NUM = E2_NUM "+CRLF
cQuery += "                     -- AND ZW_PARCELA = E2_PARCELA "+CRLF
cQuery += "                     -- AND ZW_TIPO = E2_TIPO "+CRLF
cQuery += "                     -- AND ZW_FORNECE = E2_FORNECE "+CRLF
cQuery += "                     -- AND ZW_LOJA = E2_LOJA "+CRLF
cQuery += "                     -- AND ZW_STATUS <> 'A' "+CRLF   
cQuery += "                     AND SZW.D_E_L_E_T_ = '' "+CRLF
cQuery += " INNER JOIN SED010 SED ON ED_FILIAL = '"+xFilial("SED")+"' "+CRLF
cQuery += "                      AND E2_NATUREZ = ED_CODIGO "+CRLF
cQuery += "                      AND SED.D_E_L_E_T_ = ''  "+CRLF
cQuery += " WHERE E2_FILIAL = '"+xFilial("SE2")+"' "+CRLF
cQuery += " -- AND E2_EMISSAO >= '20180901' "+CRLF
//cQuery += " AND E2_VENCREA = '"+ DtoS(MV_PAR01) +"' "+CRLF
cQuery += " AND E2_VENCREA BETWEEN '"+ DtoS(MV_PAR01) +"' AND '"+ DtoS(MV_PAR02) +"' "+CRLF
cQuery += " -- AND E2_TIPO IN ('NF','FT') "+CRLF
cQuery += " -- AND E2_BAIXA = '' "+CRLF
cQuery += " AND E2_SALDO > 0 "+CRLF
//
//Listar Bordero Sim / Nao / Ambos
//
If MV_PAR03 == 1  //Listar Bordero Sim
cQuery += " AND E2_NUMBOR <> '' "+CRLF   
ElseIf MV_PAR03 == 2  //Listar Bordero Sim
cQuery += " AND E2_NUMBOR = '' "+CRLF   
EndIf                                                            
//
cQuery += " AND SE2.D_E_L_E_T_ = '' "+CRLF
cQuery += " ORDER BY ZW_FPAGT, ZW_NOMFOR, ZW_BCOFV ,ZW_NUMAP, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO "+CRLF

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)

Return()


/*
ROTINA..................:CriaSX1
OBJETIVO................:Criar registros no arquivo de perguntas SX1
*/
Static Function CriaSX1(_cPerg)

Local _aArea := GetArea()
Local _aRegs := {}
Local i


_sAlias := Alias()
dbSelectArea("SX1")
SX1->(dbSetOrder(1))
_cPerg := padr(_cPerg,len(SX1->X1_GRUPO))

AADD(_aRegs,{_cPerg,"01" ,"Periodo de  ?"       ,"mv_ch1","D" ,08, 0, "G","mv_par01","","","","",""})
AADD(_aRegs,{_cPerg,"02" ,"Periodo ate ?"       ,"mv_ch2","D" ,08, 0, "G","mv_par02","","","","",""})
AADD(_aRegs,{_cPerg,"03" ,"Listar em Bordero ?" ,"mv_ch3","C" ,01, 0, "C","mv_par03","","Sim","Nao","Ambos",""})


DbSelectArea("SX1")
SX1->(DbSetOrder(1))

For i := 1 To Len(_aRegs)
	IF  !DbSeek(_aRegs[i,1]+_aRegs[i,2])
		RecLock("SX1",.T.)
		Replace X1_GRUPO   with _aRegs[i,01]
		Replace X1_ORDEM   with _aRegs[i,02]
		Replace X1_PERGUNT with _aRegs[i,03]
		Replace X1_VARIAVL with _aRegs[i,04]
		Replace X1_TIPO    with _aRegs[i,05]
		Replace X1_TAMANHO with _aRegs[i,06]
		Replace X1_PRESEL  with _aRegs[i,07]
		Replace X1_GSC     with _aRegs[i,08]
		Replace X1_VAR01   with _aRegs[i,09]
		Replace X1_F3      with _aRegs[i,10]
		Replace X1_DEF01   with _aRegs[i,11]
		Replace X1_DEF02   with _aRegs[i,12]
		Replace X1_DEF03   with _aRegs[i,13]
		Replace X1_VALID   with _aRegs[i,14]
		MsUnlock() 
	Else
		RecLock("SX1",.F.)
		Replace X1_GRUPO   with _aRegs[i,01]
		Replace X1_ORDEM   with _aRegs[i,02]
		Replace X1_PERGUNT with _aRegs[i,03]
		Replace X1_VARIAVL with _aRegs[i,04]
		Replace X1_TIPO    with _aRegs[i,05]
		Replace X1_TAMANHO with _aRegs[i,06]
		Replace X1_PRESEL  with _aRegs[i,07]
		Replace X1_GSC     with _aRegs[i,08]
		Replace X1_VAR01   with _aRegs[i,09]
		Replace X1_F3      with _aRegs[i,10]
		Replace X1_DEF01   with _aRegs[i,11]
		Replace X1_DEF02   with _aRegs[i,12]
		Replace X1_DEF03   with _aRegs[i,13]
		Replace X1_VALID   with _aRegs[i,14]
		MsUnlock() 	
	EndIF
Next i

RestArea(_aArea)

Return