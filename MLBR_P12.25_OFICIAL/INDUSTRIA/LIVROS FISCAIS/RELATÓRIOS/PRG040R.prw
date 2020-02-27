#Include "Rwmake.Ch"
#include "TopConn.ch"
#include "Protheus.ch"
 
*****************************************************************************
*+-------------------------------------------------------------------------+*
*|Funcao      | PRG040R  | Autor |                                         |*
*+------------+------------------------------------------------------------+*
*|Data        | 01.03.2010                                                 |*
*+------------+------------------------------------------------------------+*
*|Descricao   | Relatorio DIRF - COMPRAS                                   |*
*+------------+------------------------------------------------------------+*
*|Arquivos    | SC6                                                        |*
*+-------------------------------------------------------------------------+*
*****************************************************************************
//FONTE PEGO EXTERNAMENTE PELA SIMONE EDUARDO
//DESENVOLVIDO POR PROGRAMADOR DA EMPRESA QUE A MESMA PRESTOU SERVICO ANTERIORMENTE
//ADICIONADO AO PROJETO E COMPILADO POR ANESIO FARIA - anesio@anesio.com.br

User Function PRG040R()


cDesc1      := "Relatorio de Conferencia DIRF - Compras"
cDesc2      := ""
cDesc3      := ""
cString     := ""
aReturn     := {"Zebrado",1,"Estoque",1,2,1,"",1}
nomeprog    := "PRG040R"
cPerg       := Padr("PRG040RA",Len(SX1->X1_Grupo))
nLastKey    := 0
Titulo      := "Relatorio de Conferencia DIRF - Compras"
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

Processa({|| PRG040X()},"Selecionando Registros...")

Return

*****************************************************************************
*+-------------------------------------------------------------------------+*
*|Funcao      | PRG040X  | Autor | Rodrigo Tomaz da Silva                  |*
*+------------+------------------------------------------------------------+*
*|Data        | 01.03.2010                                                 |*
*+------------+------------------------------------------------------------+*
*|Descricao   |                                                            |*
*+------------+------------------------------------------------------------+*
*|Arquivos    |                                                            |*
*+-------------------------------------------------------------------------+*
*****************************************************************************

Static Function PRG040X()

Local nLin        	:= 100                                                       
Local cQry        	:= ""
Local cDoc        	:= ""
Local nVaria01 		:= 0
Local nVaria02 		:= 0
Local nVaria03 		:= 0
Local nTot1			:= 0
Local nTot2			:= 0
Local nTot3			:= 0
Local nVaria01A		:= 0
Local nVaria02A		:= 0
Local nVaria03A		:= 0

Local cCab1       := "FORNECE     NOME                                      CGC/CPF                   EMISSAO    DOCUMENTO       DT.DIGITACAO      .               VLR. TOTAL         BASE IRRF    ALIQ. IRRF         VALOR IRRF   COD. RETENÇÃO"
                                                                                                                                                          
//                    AAAAAA-AA   AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   AAAAAAAAAAAAAAAAAAAAAAA  AA/AA/AA    AAA-AAAAAAAAA       AA/AA/AA   999,999,999.99  999,999,999.99    999,999,999.99        999.99     999,999,999.99           AAAA
//					  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234568901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//							    10	      20        30        40        50        60        70        80       90       100       110       120       130       140       150       160       170       180       190       200       210        220
Titulo := "Relatorio de Conferencia DIRF - Compras"


cQuery := " SELECT D1_FORNECE, D1_LOJA, D1_EMISSAO, D1_DOC, D1_SERIE,  D1_DTDIGIT, Sum(D1_TOTAL) D1_TOTAL, "
cQuery += " Sum(D1_BASEIRR) D1_BASEIRR, AVG(D1_ALIQIRR) D1_ALIQIRR, Sum(D1_VALIRR) D1_VALIRR FROM "
cQuery +=	RetSqlName("SD1")+" SD1 (NOLOCK), "
cQuery +=	RetSqlName("SF4")+" SF4 (NOLOCK) "
cQuery += " WHERE SD1.D_E_L_E_T_ <> '*' "
cQuery += " AND SF4.D_E_L_E_T_ <> '*' "
cQuery += " AND F4_CODIGO = D1_TES "
//cQuery += " AND F4_FILIAL = D1_FILIAL "  - Comentado por ter unificado as TES
//cQuery += " AND F4_ISS = 'S' " // Solicitação efetuada em 15.03.11 - Geraldo Alves
cQuery += " AND D1_FORNECE BETWEEN '"+mv_par04+"' AND '"+mv_par05+"' "
cQuery += " AND D1_LOJA BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
cQuery += " AND D1_VALIRR >=0 "
If mv_par03 == 1
	cQuery += " AND D1_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "
Else
	cQuery += " AND D1_DTDIGIT BETWEEN '"+DTOS(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "
Endif
cQuery += " GROUP BY D1_FORNECE, D1_LOJA, D1_EMISSAO, D1_DOC, D1_SERIE, D1_DTDIGIT "
If mv_par03 == 1
	cQuery += " ORDER BY D1_FORNECE, D1_LOJA, D1_EMISSAO, D1_SERIE, D1_DOC "
Else
	cQuery += " ORDER BY D1_FORNECE, D1_LOJA, D1_DTDIGIT, D1_SERIE, D1_DOC "
EndIf	
	
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TM1', .F., .T.)

cDtUso := If(mv_par03 == 1, "D1_EMISSAO", "D1_DTDIGIT")

Dbselectarea("TM1")
Dbgotop()
Do While !eof()
	IncProc()
	cCli := TM1->D1_FORNECE+TM1->D1_LOJA
	Do While !Eof() .and. TM1->D1_FORNECE+TM1->D1_LOJA == cCli
		dDtFlag := If(mv_par03 == 1,Substr(TM1->D1_EMISSAO,1,6),Substr(TM1->D1_DTDIGIT,1,6))
		Do While !Eof() .and. Substr(TM1->&(cDtUso),1,6) == dDtFlag .and. TM1->D1_FORNECE+TM1->D1_LOJA == cCli
			If empty(TM1->D1_DOC)
				Dbselectarea("TM1")
				Dbskip()
				Loop
			EndIf
	    	if TM1->D1_VALIRR < 10
				Dbselectarea("TM1")
				Dbskip()
				Loop
	    	endif

			cQuery := " SELECT * FROM "
			cQuery +=	RetSqlName("SE2")+" SE2 (NOLOCK) "
			cQuery += " WHERE SE2.D_E_L_E_T_ <> '*' "
			cQuery += " AND E2_EMISSAO = '"+TM1->D1_EMISSAO+"' "
			cQuery += " AND E2_NUM     = '"+TM1->D1_DOC+"' "
//			cQuery += " AND E2_FORNECE = '"+TM1->D1_FORNECE+"' "
//			cQuery += " AND E2_LOJA    = '"+TM1->D1_LOJA+"' "
			cQuery += " AND E2_TIPO    = 'TX' "
			cQuery += " AND E2_NATUREZ = 'IRF' " 
			cQuery += " AND E2_CODRET  <> '' "
	
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TM2', .F., .T.)
			
			cCodRet := ""
			
			Dbselectarea("TM2")
			Dbgotop()
			If !Eof()
				cCodRet := TM2->E2_CODRET
			EndIf

            TM2->(DbcloseArea())			

			If nLin > 56
				Cabec(titulo, cCab1, "", nomeprog, "G", GetMv("MV_COMP"))
				nLin := 9
			Endif
		    @ nLin, 000 Psay TM1->D1_FORNECE+"-"+TM1->D1_LOJA
            Dbselectarea("SA2")
            Dbsetorder(1)
            Dbgotop()
            DBseek(xFilial("SA2")+TM1->D1_FORNECE+TM1->D1_LOJA)
		    @ nLin, 012 Psay Substr(SA2->A2_NOME,1,40)
            @ nLin, 054 Psay SA2->A2_CGC						Picture "@R 99.999.999/9999-99"
		    @ nLin, 079 Psay Dtoc(Stod(TM1->D1_EMISSAO))
		    @ nLin, 092 Psay TM1->D1_SERIE+"-"+TM1->D1_DOC
		    @ nLin, 111 Psay Dtoc(Stod(TM1->D1_DTDIGIT))
//		    @ nLin, 123 Psay TM1->D1_VUNIT  					Picture "@e 999,999,999.99"
		    @ nLin, 137 Psay TM1->D1_TOTAL						Picture "@e 999,999,999.99"
		    @ nLin, 157 Psay TM1->D1_BASEIRR					Picture "@e 999,999,999.99"
		    @ nLin, 177 Psay TM1->D1_ALIQIRR					Picture "@e 999.99"
			@ nLin, 188 Psay TM1->D1_VALIRR						Picture "@e 999,999,999.99"
			@ nLin, 214 Psay cCodRet             
		    nLin     := nLin + 1
		    nVaria01 += TM1->D1_TOTAL
		    nVaria02 += TM1->D1_BASEIRR
	    	nVaria03 += TM1->D1_VALIRR
	    	nTot1	 += TM1->D1_TOTAL
	    	nTot2    += TM1->D1_BASEIRR
	    	nTot3	 += TM1->D1_VALIRR
	    	Dbselectarea("TM1")
	    	Dbskip()
    	EndDo
        If nVaria01 > 0 .or. nVaria02 > 0 .or. nVaria03 > 0
	    	nLin     := nLin + 1
		   	@ nLin, 000 Psay "Total de : "+Alltrim(MesExtenso(Val(Substr(dDtFlag,5,2))))+" - "+Substr(dDtFlag,1,4)
	    	@ nLin, 137 Psay nVaria01			Picture "@e 999,999,999.99"
	    	@ nLin, 157 Psay nVaria02			Picture "@e 999,999,999.99"
	    	@ nLin, 188 Psay nVaria03			Picture "@e 999,999,999.99"
	    	nLin     := nLin + 2
			nVaria01A		+= nVaria01 
			nVaria02A		+= nVaria02
			nVaria03A		+= nVaria03
			nVaria01 		:= 0
			nVaria02 		:= 0
			nVaria03 		:= 0
    	EndIf
	EndDo
    If nVaria01A > 0 .or. nVaria02A > 0 .or. nVaria03A > 0
		nLin     := nLin + 1
	    Dbselectarea("SA2")
	    Dbsetorder(1)
	    Dbgotop()
	 	Dbseek(xFilial("SA2")+cCli)
	   	@ nLin, 000 Psay "Total do Fornecedor: "+SA2->A2_COD+"-"+SA2->A2_LOJA+" / "+SA2->a2_NOME
	   	@ nLin, 137 Psay nVaria01A		Picture "@e 999,999,999.99"
	   	@ nLin, 157 Psay nVaria02A		Picture "@e 999,999,999.99"
	   	@ nLin, 188 Psay nVaria03A		Picture "@e 999,999,999.99"
		nVaria01A		:= 0
		nVaria02A		:= 0
		nVaria03A		:= 0
	    nLin := nLin + 1                 
	   	@ nLin, 000 Psay __PrtThinLine()
	    nLin := nLin + 1                 
	EndIf
EndDo

If nTot1 > 0 .Or. nTot2 > 0 .Or. nTot3 > 0
  	@ nLin, 000 Psay "Total de : "+dToc(mv_par01)+" a "+dToc(mv_par02)
   	@ nLin, 137 Psay nTot1			Picture "@e 999,999,999.99"
   	@ nLin, 157 Psay nTot2			Picture "@e 999,999,999.99"
   	@ nLin, 188 Psay nTot3			Picture "@e 999,999,999.99"
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
Local nXX

nXX      := 0
aPerg    := {}

aAdd(aPerg,{ "Do Data              ?" , "D" , 08 , 00 , "G" , "" , "" , "" , "" , "", "" })
aAdd(aPerg,{ "Ate a Data           ?" , "D" , 08 , 00 , "G" , "" , "" , "" , "" , "", "" })
aAdd(aPerg,{ "Considera Data       ?" , "N" , 01 , 00 , "C" , "Emissao" , "Digitação" , "" , "" , "", "" })
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

Return
