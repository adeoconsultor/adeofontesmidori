#include "RwMake.Ch"
#include "TopConn.ch"


*****************************************************************************
*+-------------------------------------------------------------------------+*
*|Funcao      | PRG041R  | Autor |                                         |*
*+------------+------------------------------------------------------------+*
*|Data        | 01.03.2010                                                 |*
*+------------+------------------------------------------------------------+*
*|Descricao   | Relatorio DIRF - FINANCEIRO                                |*
*+------------+------------------------------------------------------------+*
*|Arquivos    | SC6                                                        |*
*+-------------------------------------------------------------------------+*
*****************************************************************************
//FONTE PEGO EXTERNAMENTE PELA SIMONE EDUARDO
//DESENVOLVIDO POR PROGRAMADOR DA EMPRESA QUE A MESMA PRESTOU SERVICO ANTERIORMENTE
//ADICIONADO AO PROJETO E COMPILADO POR ANESIO FARIA - anesio@anesio.com.br

User Function PRG041R()


cDesc1      := "Relatorio de Conferencia DIRF - Financeiro"
cDesc2      := ""
cDesc3      := ""
cString     := ""
aReturn     := {"Zebrado",1,"Estoque",1,2,1,"",1}
nomeprog    := "PRG041R"
cPerg       := Padr("PRG041RB",Len(SX1->X1_Grupo))
nLastKey    := 0
Titulo      := "Relatorio de Conferencia DIRF - Financeiro"
wnrel       := NomeProg
tamanho     := "G"
aOrd        := {}
li          := 0
lDic        := .F.
lComp       := .T.
lFiltro     := .F.
CbTxt       := ""
CbCont      := 0
nLin        := 80
m_pag       := 1
lEnd        := .F.
lAbortPrint := .F.
limite      := 220
cDesc       := ""
cCpo        := ""

CriaSX1()

Pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg ,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrd,lComp,Tamanho,,lFiltro)

If nLastKey == 27; Return; Endif

SetDefault(aReturn,cString)

If nLastKey == 27; Return; Endif

Processa({|| PRG041X()},"Selecionando Registros...")

Return

*****************************************************************************
*+-------------------------------------------------------------------------+*
*|Funcao      | PRG041X  | Autor | Rodrigo Tomaz da Silva                  |*
*+------------+------------------------------------------------------------+*
*|Data        | 01.03.2010                                                 |*
*+------------+------------------------------------------------------------+*
*|Descricao   |                                                            |*
*+------------+------------------------------------------------------------+*
*|Arquivos    |                                                            |*
*+-------------------------------------------------------------------------+*
*****************************************************************************

Static Function PRG041X()

Local nLin        	:= 100                                                       
Local cQry        	:= ""
Local cDoc        	:= ""
Local nVaria01 		:= 0
Local nVaria02 		:= 0
Local nVaria03 		:= 0
Local nVaria04 		:= 0
Local nVaria05 		:= 0
Local nVaria06 		:= 0

Local nTot1			:= 0
Local nTot2			:= 0
Local nTot3			:= 0
Local nTot4			:= 0
Local nTot5			:= 0
Local nTot6			:= 0

Local nVaria01A		:= 0
Local nVaria02A		:= 0
Local nVaria03A		:= 0
Local nVaria04A		:= 0
Local nVaria05A		:= 0
Local nVaria06A		:= 0

Local cCab1       := "FORNECEDOR NOME                                   CNPJ               TITULO         DT BAIXA        VLR TITULO          BASE         COFINS          PIS             CSLL            TOTAL      COD.RET.COF/PIS/CSLL"
//                    AAAAAA-AA    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA  UUU-999999999   AA/AA/AA   999,999,999.99   999,999,999.99    999,999,999.99    999,999,999.99    999,999,999.99   999,999,999.99
//					  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234568901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//							    10	      20        30        40        50        60        70        80       90       100       110       120       130       140       150       160       170       180       190       200       210        220
Titulo := "Relatorio de Conferencia DIRF - Financeiro"

cQuery := " SELECT * FROM "
cQuery +=	RetSqlName("SE2")+" SE2 (NOLOCK) "
cQuery += " WHERE SE2.D_E_L_E_T_ <> '*' "
cQuery += " AND E2_BAIXA BETWEEN '"+DTOS(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "
cQuery += " AND E2_FORNECE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
cQuery += " AND E2_LOJA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
cQuery += " AND E2_TIPO = 'NF' "
cQuery += " AND (E2_COFINS > 0 OR E2_PIS > 0 OR E2_CSLL > 0) "
cQuery += " ORDER BY E2_FORNECE, E2_LOJA, E2_BAIXA, E2_PREFIXO, E2_NUM "
	
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TM1', .F., .T.)

Dbselectarea("TM1")
Dbgotop()
Do While !eof()
	IncProc()
	cCli := TM1->E2_FORNECE+TM1->E2_LOJA
	Do While !Eof() .and. TM1->E2_FORNECE+TM1->E2_LOJA == cCli
		dDtFlag := Substr(TM1->E2_BAIXA,1,6)
		Do While !Eof() .and. Substr(TM1->E2_BAIXA,1,6) == dDtFlag .and. TM1->E2_FORNECE+TM1->E2_LOJA == cCli
			If empty(TM1->E2_NUM)
				Dbselectarea("TM1")
				Dbskip()
				Loop
			EndIf
			If nLin > 56
				Cabec(titulo, cCab1, "", nomeprog, "G", GetMv("MV_COMP"))
				nLin := 9
			Endif
		    @ nLin, 000 Psay TM1->E2_FORNECE+"-"+TM1->E2_LOJA
            Dbselectarea("SA2")
            Dbsetorder(1)
            Dbgotop()
            DBseek(xFilial("SA2")+TM1->E2_FORNECE+TM1->E2_LOJA)
            
            nBase  := 0
            nTotal := 0
            
            Dbselectarea("SD1")
            Dbsetorder(1)
            Dbgotop()
            Dbseek(TM1->E2_FILIAL+TM1->E2_NUM+TM1->E2_PREFIXO+TM1->E2_FORNECE+TM1->E2_LOJA)
            Do While !Eof() .and. TM1->E2_FILIAL+TM1->E2_NUM+TM1->E2_PREFIXO+TM1->E2_FORNECE+TM1->E2_LOJA == SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
	           	nBase += SD1->D1_TOTAL
            	Dbselectarea("SD1")
            	Dbskip()
            EndDo
		    
		    @ nLin, 011 Psay Substr(SA2->A2_NOME,1,37)
		    @ nLin, 050 Psay maskCNPJ(SA2->A2_CGC)
			@ nLin, 069 Psay TM1->E2_PREFIXO+"-"+TM1->E2_NUM
		    @ nLin, 086 Psay Dtoc(Stod(TM1->E2_BAIXA))
			@ nLin, 098 Psay TM1->E2_VALOR					   										Picture "@e 9,999,999.99"
//			@ nLin, 112 Psay nBase          					Picture "@e 9,999,999.99"
			@ nLin, 112 Psay bscbseir(TM1->E2_PREFIXO, TM1->E2_NUM, TM1->E2_FORNECE, TM1->E2_LOJA)	Picture "@e 9,999,999.99"
			@ nLin, 127 Psay TM1->E2_COFINS															Picture "@e 9,999,999.99"
			@ nLin, 140 Psay TM1->E2_PIS   															Picture "@e 9,999,999.99"
			@ nLin, 157 Psay TM1->E2_CSLL															Picture "@e 9,999,999.99"
			nTotal := TM1->E2_COFINS+TM1->E2_PIS+TM1->E2_CSLL
			@ nLin, 173 Psay nTotal							   										Picture "@e 99,999,999.99"
			@ nLin, 198 Psay TM1->E2_CODRCOF+'/'+TM1->E2_CODRPIS+'/'+TM1->E2_CODRCSL
		    nLin     := nLin + 1
		    nVaria01 += TM1->E2_VALOR
		    nVaria02 += nBase
	    	nVaria03 += TM1->E2_COFINS
		    nVaria04 += TM1->E2_PIS
		    nVaria05 += TM1->E2_CSLL
	    	nVaria06 += nTotal
	    	
	    	nTot1	 += TM1->E2_VALOR
	    	nTot2    += nBase
	    	nTot3	 += TM1->E2_COFINS
	    	nTot4	 += TM1->E2_PIS
	    	nTot5    += TM1->E2_CSLL
	    	nTot6	 += nTotal

	    	Dbselectarea("TM1")
	    	Dbskip()           
    	EndDo
        If nVaria01 > 0 .or. nVaria02 > 0 .or. nVaria03 > 0 .Or. nVaria04 > 0 .or. nVaria05 > 0 .or. nVaria06 > 0

		    nLin     := nLin + 1
	    	@ nLin, 000 Psay "Total de : "+Alltrim(MesExtenso(Val(Substr(dDtFlag,5,2))))+" - "+Substr(dDtFlag,1,4)
	    	@ nLin, 098 Psay nVaria01			Picture "@e 9,999,999.99"
	    	@ nLin, 112 Psay nVaria02			Picture "@e 9,999,999.99"
	    	@ nLin, 127 Psay nVaria03			Picture "@e 9,999,999.99"
	    	@ nLin, 140 Psay nVaria04			Picture "@e 9,999,999.99"
	    	@ nLin, 157 Psay nVaria05			Picture "@e 9,999,999.99"
	    	@ nLin, 174 Psay nVaria06			Picture "@e 9,999,999.99"
			nLin     := nLin + 2
			nVaria01A		+= nVaria01
			nVaria02A		+= nVaria02 
			nVaria03A		+= nVaria03
			nVaria04A		+= nVaria04
			nVaria05A		+= nVaria05
			nVaria06A		+= nVaria06
			
			nVaria01 		:= 0
			nVaria02 		:= 0
			nVaria03 		:= 0
			nVaria04 		:= 0
			nVaria05 		:= 0
			nVaria06 		:= 0
    	EndIf
	EndDo    
    If nVaria01A > 0 .or. nVaria02A > 0 .or. nVaria03A > 0

		nLin     := nLin + 1
	    Dbselectarea("SA2")
	    Dbsetorder(1)
	    Dbgotop()
	 	Dbseek(xFilial("SA2")+cCli)


	   	@ nLin, 000 Psay "Total do Fornecedor: "+SA2->A2_COD+"-"+SA2->A2_LOJA+" / "+SA2->a2_NOME
	   	@ nLin, 098 Psay nVaria01A		Picture "@e 9,999,999.99"
	   	@ nLin, 112 Psay nVaria02A		Picture "@e 9,999,999.99"
	   	@ nLin, 127 Psay nVaria03A		Picture "@e 9,999,999.99"
	   	@ nLin, 140 Psay nVaria04A		Picture "@e 9,999,999.99"
	   	@ nLin, 157 Psay nVaria05A		Picture "@e 9,999,999.99"
	   	@ nLin, 174 Psay nVaria06A		Picture "@e 9,999,999.99"
	
		nVaria01A		:= 0
		nVaria02A		:= 0
		nVaria03A		:= 0
		nVaria04A		:= 0
		nVaria05A		:= 0
		nVaria06A		:= 0
	
	    nLin := nLin + 1                 
	   	@ nLin, 000 Psay __PrtThinLine()
	    nLin := nLin + 1                 
	EndIf
EndDo

If nTot1 > 0 .Or. nTot2 > 0 .Or. nTot3 > 0 .Or. nTot4 > 0 .Or. nTot5 > 0 .Or. nTot6 > 0
  	@ nLin, 000 Psay "Total de : "+dToc(mv_par01)+" a "+dToc(mv_par02)
   	@ nLin, 082 Psay nTot1			Picture "@e 999,999,999.99"
   	@ nLin, 100 Psay nTot2			Picture "@e 999,999,999.99"
   	@ nLin, 118 Psay nTot3			Picture "@e 999,999,999.99"
   	@ nLin, 136 Psay nTot4			Picture "@e 999,999,999.99"
   	@ nLin, 154 Psay nTot5			Picture "@e 999,999,999.99"
   	@ nLin, 171 Psay nTot6			Picture "@e 999,999,999.99"
EndIf


TM1->(DbcloseArea())

If aReturn[5] == 1
	Set Printer To
	DbCommitAll()
	Ourspool(wnrel)
Endif

Ms_Flush()

Return


*****************************************************************************
*+-------------------------------------------------------------------------+*
*|Funcao      | CriaSx1  | Autor | Rodrigo Tomaz (Symm Consultoria)        |*
*+------------+------------------------------------------------------------+*
*|Data        | 09.11.2006                                                 |*
*+------------+------------------------------------------------------------+*
*|Descricao   | Cria Arquivo de Perguntas					     	       |*
*+------------+------------------------------------------------------------+*
*|Arquivos    | SX1                                                        |*
*+-------------------------------------------------------------------------+*
*****************************************************************************

Static Function CriaSX1()

Local nXX      := 0
aPerg    := {}


aAdd(aPerg,{ "Do Data              ?" , "D" , 08 , 00 , "G" , "" , "" , "" , "" , "", "" })
aAdd(aPerg,{ "Ate a Data           ?" , "D" , 08 , 00 , "G" , "" , "" , "" , "" , "", "" })
aAdd(aPerg,{ "Do Fornecedor        ?" , "C" , 06 , 00 , "G" , "" , "" , "" , "" , "", "SA2" })
aAdd(aPerg,{ "Ate o Fornecedor     ?" , "C" , 06 , 00 , "G" , "" , "" , "" , "" , "", "SA2" })
aAdd(aPerg,{ "Da Loja              ?" , "C" , 02 , 00 , "G" , "" , "" , "" , "" , "", "" })
aAdd(aPerg,{ "Ate a Loja           ?" , "C" , 02 , 00 , "G" , "" , "" , "" , "" , "", "" })


For nXX := 1 to Len( aPerg )
	If !SX1->( DbSeek( cPerg + StrZero( nXX , 2 ) ) )
		RecLock( "SX1" , .T. )
		SX1->X1_GRUPO     := cPerg  
		SX1->X1_ORDEM     := StrZero( nXX , 2 )
		SX1->X1_VARIAVL   := "mv_ch"  + Chr( nXX + 96 )
		SX1->X1_VAR01     := "mv_par" + Strzero( nXX , 2 )
		SX1->X1_PRESEL    := 1
		SX1->X1_PERGUNT   := aPerg[ nXX , 01 ]
		SX1->X1_TIPO      := aPerg[ nXX , 02 ]
		SX1->X1_TAMANHO   := aPerg[ nXX , 03 ]
		SX1->X1_DECIMAL   := aPerg[ nXX , 04 ]
		SX1->X1_GSC       := aPerg[ nXX , 05 ]
		SX1->X1_DEF01     := aPerg[ nXX , 06 ]
		SX1->X1_DEF02     := aPerg[ nXX , 07 ]
		SX1->X1_DEF03     := aPerg[ nXX , 08 ]
		SX1->X1_DEF04     := aPerg[ nXX , 09 ]
		SX1->X1_DEF05     := aPerg[ nXX , 10 ]
		SX1->X1_F3        := aPerg[ nXX , 11 ]
		SX1->( MsUnlock() )
	EndIf
Next nXX

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Cria a mascara do CNPJ/CPF (criado por anesio em 21/02/2014)
static function maskCNPJ(cCNPJ)
local _cCnpj := cCNPJ
if len(cCNPJ) == 14
	_cCnpj := Substr(cCNPJ,1,2)+'.'+Substr(cCNPJ,3,3)+'.'+Substr(cCNPJ,6,3)+'/'+Substr(cCNPJ,9,4)+'-'+Substr(cCNPJ,13,2)
elseif len(cCNPJ) == 11
	_cCnpj := Substr(cCNPJ,1,3)+'.'+Substr(cCNPJ,4,3)+'.'+Substr(cCNPJ,7,3)+'-'+Substr(cCNPJ,10,2)
else
	_cCnpj := cCNPJ
endif

return _cCnpj


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Busca a base do IR no arquivo SD1 (criado por anesio em 21/02/2014)
static function bscbseir(cPrefixo, cTit, cFornece, cLoja)
local nValor := 0
local cQuery := ""

cQuery := " Select D1_FORNECE, D1_LOJA, D1_DOC, D1_SERIE, Sum(D1_BASEIRR) D1_BASEIRR, Sum(D1_VALIRR) D1_VALIRR "
cQuery += " from SD1010 SD1 "
cQuery += " where SD1.D_E_L_E_T_ =' ' "
cQuery += " and D1_DOC ='"+cTit+"' AND D1_FILIAL = '"+cPrefixo+"' AND D1_FORNECE = '"+cFornece+"' AND D1_LOJA = '"+cLoja+"' " 
cQuery += " group by D1_FORNECE, D1_LOJA, D1_DOC, D1_SERIE "

if Select("TMPD1") > 0
	dbSelectArea("TMPD1")
	TMPD1->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPD1", .T., .T.)

dbSelectArea("TMPD1")
TMPD1->(dbGotop())
nValor := TMPD1->D1_BASEIRR

return nValor


Return
