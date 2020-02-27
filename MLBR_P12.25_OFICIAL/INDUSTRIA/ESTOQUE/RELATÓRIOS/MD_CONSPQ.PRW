#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE PICVAL  "@E 999,999,999.99"


User Function MD_CONSPQ()


Local titulo 	:= "Relatorio de Consumo de Produtos Quimicos "
Local cString	:= ""
Local wnrel		:= "MD_CONSPQ"
Local cDesc		:= "Este programa ira imprimir a relacao de Produtos QUIMICOS consumidos na OP "
Local aOrd    	:= ""
Local tamanho	:= "G"
Local lRet      := .T.
Private aReturn := {" ",1," ", 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
Private cPerg   := "MD_CONSPQ"
Private nLastKey:= 0


//Exclusivo para gerar para Excel
Private aConteud:= {}       
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab        := "" 


Pergunte("MD_CONSPQ",.F.)
	
AjustaSx1()
If ! Pergunte(cPerg,.T.)
	Return
Endif



//wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd,,Tamanho)
wnrel := SetPrint(cString,wnrel,,@titulo,cDesc,"","",.T.,,,Tamanho)
//msgbox("Ok Relatorio....")
If aReturn[4] == 1
	Tamanho := "M"
EndIf
If nLastKey == 27
	Set Filter To
	lRet := .F.
EndIf

If lRet
	SetDefault(aReturn,cString)
EndIf

If lRet .And. nLastKey == 27
	Set Filter To
	lRet := .F.
EndIf

If lRet

if APMsgNoYes("Deseja Gerar para Excel", "Gerar Excel")
	aDir := MDirArq()
	If Empty(aDir[1]) .OR. Empty(aDir[2])
		Return
	Else                      
		U_GeraExcPQ()
		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif
else

	RptStatus({|lEnd| MntRel1(@lEnd,wnRel,titulo,tamanho)},titulo)

endif

EndIf
Return NIL

//msgbox("Chamado Relatorio...")
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥ MntPlt1  ≥ Autor ≥ Waldemiro L. Lustosa  ≥ Data ≥ 13.11.95 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Chamada do Relat¢rio                                       ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ MATR850			                                          ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function MntRel1(lEnd,wnRel,titulo,tamanho)

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Define Variaveis                                             ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
Local CbTxt
Local CbCont,cabec1,cabec2
Local limite   := If(aReturn[4] == 1,132,180)
Local nomeprog := "RELMNTPLT"
Local cAliasQry    := GetNextAlias()      
Local cAliasQMv := GetNextAlias()

//Local nTipo    := 0
//Local cProduto := Space(Len(SC2->C2_PRODUTO))
//Local cStatus,nOrdem,cSeek
//Local cTotal   := "",nTotOri:= 0,nTotSaldo:=0 // Totalizar qdo ordem for por produto


U_CriaTMPPQ(cAliasQry,cAliasQMv) //Chama a funcao para criar a tabela tempor·ria


//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
cbtxt  := Space(10)
cbcont := 0
li     := 79
m_pag  := 1

nTipo  := IIf(aReturn[4]==1,15,18)
nOrdem := aReturn[8]
lTipo  := IIf(aReturn[4]==1,.T.,.F.)

if mv_par10 == 2
	cabec1 := " CODIGO DESCRICAO                                    DATA   TM   COD.      QTDE           CUSTO     ORDEM DE   PRODUTO INTERMEDI¡RIO               QTDE   PRODUTO ACABADO                  QTDE"
	cabec2 := "                                                  EMISSAO        FISC     SAIDA                     PRODUCAO "
	//				 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789
	//             1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20     21       22         23
	//                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
else
	cabec1 := " CODIGO DESCRICAO                                           TM   COD.  TIPO  UM             QTDE                           CUSTO   ARTIGO"
	cabec2 := "                                                                 FISC                                                                    "
endif	

cProdPA := cProdPI := ""
nProdPA := nProdPI := 0
nProdM2 := 0
nCustoPA := nCustoPI := 0                      


SetRegua(RecCount())
(cAliasQry)->(dbGotop())   
if mv_par10 == 2
	cProdAnt  := (cAliasQry)->D3_COD
	nProdAcum := nProdAnt := 0
	nCustAcum := nCustAnt := 0
	While !(cAliasQry)->(EoF())
		IncRegua()
		If lEnd
			@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
			Exit
		EndIf
		If li > 58
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIf         
		@Li ,000 PSay Substr((cAliasQry)->D3_COD,1,6)
		@Li ,008 PSay Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->D3_COD, "B1_DESC")
		@Li ,048 Psay dToc((cAliasQry)->D3_EMISSAO)            
		@Li ,060 PSay (cAliasQry)->D3_TM
		@Li ,066 PSay (cAliasQry)->D3_CF
		@Li ,070 Psay (cAliasQry)->D3_QUANT Picture "@E 999,999.99"
		nProdAnt += (cAliasQry)->D3_QUANT

		@Li ,084 Psay (cAliasQry)->D3_CUSTO1 Picture "@E 999,999.9999"
		nCustAnt += (cAliasQry)->D3_CUSTO1
		@Li ,098 Psay Substr((cAliasQry)->D3_OP,1,11)
		dbSelectArea("SD3")
		dbSetOrder(1)                           
		dbSeek(xFilial("SD3")+Substr((cAliasQry)->D3_OP,1,8),.T.)
		while !SD3->(eof()).and.Substr(SD3->D3_OP,1,8)== Substr((cAliasQry)->D3_OP,1,8)
			if SD3->D3_CF == 'PR0'       
				if SD3->D3_TM = '500' .and. Substr(SD3->D3_OP,9,3)=='001'.and. SD3->D3_ESTORNO == ' '
					cProdPA := SD3->D3_COD
					nProdPA += SD3->D3_QUANT
					nProdM2 += SD3->D3_QTDEM2
				elseif SD3->D3_TM == '500' .and. Substr(SD3->D3_OP,9,3) == '002' .and. SD3->D3_ESTORNO == ' '
					cProdPI := SD3->D3_COD
					nProdPI += SD3->D3_QUANT
				endif
			endif
		SD3->(dbSkip())                   
		enddo               
		if nProdPI > 0
			@Li , 112 Psay Substr(cProdPI,1,6) + ' '+Substr(Posicione("SB1",1,xFilial("SB1")+cProdPI, "B1_DESC"),1,20)
			@Li , 142 PSay nProdPi Picture "@E 99,999.99"                                            
		else
			@Li , 112 Psay "N√O HOUVE P.I. NESTA O.P."
		endif
		if nProdPA > 0 
			@Li , 154 PSay Substr(cProdPA,1,6) + ' '+Substr(Posicione("SB1",1,xFilial("SB1")+cProdPA, "B1_DESC"),1,20)
			@Li , 184 Psay nProdPa Picture "@E 99,999.99"
		else
			@Li , 154 Psay "N√O HOUVE P.A. NESTA O.P."
		endif
		nProdPI := nProdPA := nProdM2 := 0
	    Li++
	 (cAliasQry)->(dbSkip())
 		if cProdAnt <> (cAliasQry)->D3_COD
			@Li, 001 Psay "TOTAL DO PRODUTO--> "+Substr(Posicione("SB1",1,xFilial("SB1")+cProdAnt,"B1_DESC"),1,40)
			@Li, 069 Psay nProdAnt Picture "@E 999,999.99"
			@Li, 083 Psay nCustAnt Picture "@E 999,999.9999"
			nProdAcum += nProdAnt
			nCustAcum += nCustAnt
			cProdAnt := (cAliasQry)->D3_COD
			nProdAnt := nCustAnt := 0
			Li++                     
			Li++			
		endif

	enddo                        

	//Imprimir total geral
			@Li, 001 Psay "TOTAL GERAL --> "
			@Li, 069 Psay nProdAcum Picture "@E 999,999.99"
			@Li, 083 Psay nCustAcum Picture "@E 999,999.9999"

	
else                       
cOpAnt:= (cAliasQry)->D3_OP
	While !(cAliasQry)->(EoF())
		dbSelectArea("TMP")
		if dbSeek((cAliasQry)->D3_COD) 
			RecLock("TMP",.F.)
			TMP->D3_QUANT	+= (cAliasQry)->D3_QUANT
			TMP->D3_CUSTO1	+= (cAliasQry)->D3_CUSTO1
			TMP->D3_QTDEM2  += (cAliasQry)->D3_QTDEM2
		else
			RecLock("TMP",.T.)
			TMP->D3_COD		:= (cAliasQry)->D3_COD
			TMP->D3_TM		:= (cAliasQry)->D3_TM
			TMP->D3_CF		:= (cAliasQry)->D3_CF
			TMP->D3_QUANT	:= (cAliasQry)->D3_QUANT
			TMP->D3_QTDEM2  := (cAliasQry)->D3_QTDEM2
			TMP->D3_CUSTO1	:= (cAliasQry)->D3_CUSTO1
			TMP->D3_TIPO	:= "PQ"
		endif
		MsUnLock("TMP")
	(cAliasQry)->(dbSkip())

		if cOpAnt <> (cAliasQry)->D3_OP
			nProdPA := nProdPI := nCustoPA := nCustoPI := nPesoPQ:= nProdM2 := 0
			dbSelectArea("SD3")
			dbSetOrder(1)                           
			dbSeek(xFilial("SD3")+Substr(cOpAnt,1,8),.T.)
			while !SD3->(eof()).and.Substr(SD3->D3_OP,1,8)== Substr(cOpAnt,1,8)
				if SD3->D3_CF == 'PR0'       
					if SD3->D3_TM = '500' .and. Substr(SD3->D3_OP,9,3)=='001' .and. SD3->D3_ESTORNO == ' '
						cProdPA  := SD3->D3_COD
						nProdPA  += SD3->D3_QUANT
						nProdM2  += SD3->D3_QTDEM2
					elseif SD3->D3_TM == '500' .and. Substr(SD3->D3_OP,9,3) == '002' .and. SD3->D3_ESTORNO == ' '
						cProdPI  := SD3->D3_COD
						nProdPI  += SD3->D3_QUANT
						nCustoPI += SD3->D3_CUSTO1
					endif
				elseif Substr(SD3->D3_OP,9,3)=='002' .and. SD3->D3_ESTORNO == ' ' .and. SD3->D3_CF='RE1' .and. (SD3->D3_GRUPO == '12  ' .or. SD3->D3_GRUPO == '14  ')
//						Alert("Gravando custo na P.A.-> "+cValToChar(SD3->D3_CUSTO1))
						nCustoPA += SD3->D3_CUSTO1 //Grava o custo de produto quimico 
						if SD3->D3_UM = 'KG'
							nPesoPQ  += SD3->D3_QUANT
						endif
				endif
			SD3->(dbSkip())
			enddo              

            dbSelectArea("TMP")        
            	//Gravar o PA no resumo...
				if dbSeek(cProdPA) 
					RecLock("TMP",.F.)
					TMP->D3_QUANT	+= nProdPA
					TMP->D3_CUSTO1	+= nCustoPA
					
					TMP->PESOPQ  += nPesoPQ
				else
					RecLock("TMP",.T.)
					TMP->D3_COD		:= cProdPA
					TMP->D3_TM		:= '500'
					TMP->D3_CF		:= 'PR0'
					TMP->D3_QUANT	:= nProdPA
					TMP->D3_CUSTO1	:= nCustoPA
					TMP->PESOPQ  += nPesoPQ
					TMP->D3_TIPO	:= "PA"
					if Substr(Posicione("SB1",1,xFilial("SB1")+cProdPA, "B1_TPCLASS"),1,2)=="CV"
						TMP->ARTIGO := "CROMO VOLANTE"	
					elseif Substr(Posicione("SB1",1,xFilial("SB1")+cProdPI, "B1_TPCLASS"),1,2)=="CR"
						TMP->ARTIGO := "CROMO"
					elseif Substr(Posicione("SB1",1,xFilial("SB1")+cProdPI, "B1_TPCLASS"),1,2)=="CF"
						TMP->ARTIGO := "CROMO FREE"
					elseif Substr(Posicione("SB1",1,xFilial("SB1")+cProdPI, "B1_TPCLASS"),1,2)=="CT"
						TMP->ARTIGO := "CROMO TIRA TINTA"
					elseif Substr(Posicione("SB1",1,xFilial("SB1")+cProdPI, "B1_TPCLASS"),1,2)=="FT"
						TMP->ARTIGO := "CROMO FREE T.TIN"
					elseif Substr(Posicione("SB1",1,xFilial("SB1")+cProdPI, "B1_TPCLASS"),1,2)=="HT"
						TMP->ARTIGO := "VOLANTE T.TINTA"
					endif
				endif             
				MsUnLock("TMP")
				//Gravar o PI no Resumo...
				if dbSeek(cProdPI) 
					RecLock("TMP",.F.)
					TMP->D3_QUANT	+= nProdPI
					TMP->D3_CUSTO1	+= nCustoPI
				else
					RecLock("TMP",.T.)
					TMP->D3_COD		:= cProdPI
					TMP->D3_TM		:= '500'
					TMP->D3_CF		:= 'PR0'
					TMP->D3_QUANT	:= nProdPI
					TMP->D3_CUSTO1	:= nCustoPI
					TMP->D3_TIPO	:= "PI"
				endif             
				MsUnLock("TMP")
		endif
		cOpAnt := (cAliasQry)->D3_OP		

	enddo


dbSelectArea('TRBPA')
dbGotop()
while !TRBPA->(eof())                                            
	incproc('Gravando metro quadrado dos produtos....'+ TRBPA->D3_COD)
	dbSelectArea('TMP')
	TMP->(dbGotop())    
//	Alert("Pesquisando produto...:|"+TRBPA->D3_COD+ '| Qtde '+cValToChar(TRBPA->D3_QTDEM2))
	if dbSeek(Padr(TRBPA->D3_COD,20))
//		Alert("Produto Encontrado...:"+TRBPA->D3_COD+ ' Qtde '+cValToChar(TRBPA->D3_QTDEM2))
		RecLock('TMP',.F.)
		TMP->D3_QTDEM2 := TRBPA->D3_QTDEM2
		MsUnlock('TMP')
	endif
	TRBPA->(dbSkip())
enddo

                                
	//Imprimir o Resumo...
	dbSelectArea("TMP")
	cArquivo := CriaTrab(,.F.)    
	INDREGUA("TMP",cArquivo,"D3_TIPO+D3_COD",,)
	TMP->(dbGotop())
	cTipoAnt := TMP->D3_TIPO
	nTipoAnt := 0
	nCustAnt := 0
	While !TMP->(EoF())
		IncRegua()
		If lEnd
			@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
			Exit
		EndIf
		If li > 58
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIf         
		@Li ,000 PSay Substr(TMP->D3_COD,1,6)
		@Li ,008 PSay Posicione("SB1",1,xFilial("SB1")+TMP->D3_COD, "B1_DESC")
		@Li ,060 PSay TMP->D3_TM
		@Li ,066 PSay TMP->D3_CF                    
		@LI ,073 PSay TMP->D3_TIPO
		@Li ,079 PSay Posicione("SB1",1,xFilial("SB1")+TMP->D3_COD, "B1_UM")
		@Li ,084 Psay TMP->D3_QUANT Picture "@E 99,999,999.99"
		@Li ,114 Psay TMP->D3_CUSTO1 Picture "@E 99,999,999.9999"
		@Li ,132 PSay TMP->ARTIGO
		nTipoAnt += TMP->D3_QUANT
		nCustAnt += TMP->D3_CUSTO1
	    Li++
	 TMP->(dbSkip())              
	 if cTipoAnt <> TMP->D3_TIPO
	 	@Li ,001 Psay "TOTAIS DE "+cTipoAnt
	 	@Li ,083 Psay nTipoAnt Picture "@E 99,999,999.99"
	 	@Li ,113 Psay nCustAnt Picture "@E 99,999,999.9999"
	 	if cTipoAnt == 'PA'
	 		nVlrCAjTot := nCustAnt
	 	endif
	 	nTipoAnt := nCustAnt := 0
	 	cTipoAnt := TMP->D3_TIPO
	 	Li++
	 	Li++
	 endif
	enddo
nTotAJVTM := 0
    TMPD3->(dbGotop())                  
	While !TMPD3->(eof())
        nTotAJVTM += iif(Substr(TMPD3->D3_CF,1,2)=='RE', TMPD3->D3_CUSTO1, TMPD3->D3_CUSTO1 * -1)
		TMPD3->(dbSkip())
	enddo



//Imprimir resumo do ARTIGO
	dbSelectArea("TMP")
	cArquivo := CriaTrab(,.F.)    
	INDREGUA("TMP",cArquivo,"ARTIGO",,)
	TMP->(dbGotop())
	cArtigoAnt := ' '
	nArtigoAnt := 0
	nCustAnt   := 0
	nPesoAnt   := 0
	nArtigoTot := 0
	nCustTot   := 0
	nPesoTot   := 0 
	nM2Ant     := 0
	nM2Tot     := 0
	nTotQTM    := 0
	nTotVTM    := 0 
	Li := 59
	nCont:=0
	cabec1 := "                           KG TOTAL  |        R$ TOTAL  |       QTDE  |      R$ / VAQ  |        QTDE M2 |     R$/M2 | CODIGO     | DESCRICAO "
	cabec2 := "                                     |                  |        VAQ  |                |                |           "
    TMP->(dbGotop())
	While !TMP->(EoF())
		IncRegua()
		If lEnd
			@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
			Exit
		EndIf
		If li > 58
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			@Li, 000 Psay "RESUMO DE ARTIGOS"
			Li++
		EndIf
		if Substr(TMP->ARTIGO,1,1) <> ' '
			if nCont == 0     
				@Li, 000 Psay "ARTIGO: " + TMP->ARTIGO
				Li++
			endif
			@Li ,024 PSay TMP->PESOPQ Picture "@E 999,999.99"
			@Li ,044 Psay TMP->D3_CUSTO1 Picture "@E 999,999.99"
			@Li ,061 Psay TMP->D3_QUANT Picture "@E 999,999"
			@Li ,073 Psay TMP->D3_CUSTO1 / TMP->D3_QUANT Picture "@E 999,999.9999"                      
			@Li ,089 Psay TMP->D3_QTDEM2 Picture "@E 999,999,999.99"
			@Li ,105 Psay TMP->D3_CUSTO1 / TMP->D3_QTDEM2 Picture "@E 999,999.99"
			@Li ,118 PSay Substr(TMP->D3_COD,1,6)
			@Li ,131 PSay Posicione("SB1",1,xFilial("SB1")+TMP->D3_COD, "B1_DESC")
			nArtigoAnt += TMP->D3_QUANT
			nCustAnt   += TMP->D3_CUSTO1
			nPesoAnt   += TMP->PESOPQ
			nM2Ant     += TMP->D3_QTDEM2
			nCont++
	    	Li++
	  	endif
	 TMP->(dbSkip())
	 if cArtigoAnt <> ' '
		if cArtigoAnt <> TMP->ARTIGO
			@Li ,001 Psay "TOTAL DO ARTIGO-> "
			@Li ,021 Psay nPesoAnt Picture "@E 99,999,999.99"
		 	@Li ,041 Psay nCustAnt Picture "@E 99,999,999.99"
		 	@Li ,058 Psay nArtigoAnt Picture "@E 99,999,999"
		 	@Li ,074 Psay nCustAnt / nArtigoAnt Picture "@E 99,999.9999" 
		 	@Li ,105 Psay nCustAnt / nM2Ant Picture "@E 999,999.99"
	 		nArtigoTot += nArtigoAnt
			nCustTot   += nCustAnt
			nPesoTot   += nPesoAnt
			nM2Tot     += nM2Ant
		 	cTipoAnt := TMP->D3_TIPO                                     
		 	Li++
		 	@Li, 001 Psay "TOTAL COM AJUSTE->" 
		 	@Li, 071 Psay ((nVlrCAjTOT+nTotAJVTM)/nVlrCAjTOT) * (nCustAnt / nArtigoAnt)  Picture "@E 999,999,999.99 " 
		 	@Li, 101 Psay ((nVlrCAjTOT+nTotAJVTM)/nVlrCAjTOT) * nCustAnt / nM2Ant Picture "@E 999,999,999.99 " 
	 		Li++

		 	nTipoAnt := nCustAnt := nPesoAnt := nArtigoAnt := nM2Ant := 0
	 		nCont:=0

	 	endif
	 endif  


	 cArtigoAnt := TMP->ARTIGO
	enddo
		//Imprimir totais dos artigos
		 	@Li ,001 Psay __PrtThinLine()
		 	Li++
			@Li ,001 Psay "TOTAL GERAL---> "
			@Li ,021 Psay nPesoTot Picture "@E 99,999,999.99"
		 	@Li ,041 Psay nCustTot Picture "@E 99,999,999.99"
		 	@Li ,058 Psay nArtigoTot Picture "@E 99,999,999"
		 	@Li ,074 Psay nCustTot / nArtigoTot Picture "@E 99,999.9999"
		 	@Li ,105 Psay nCustTot / nM2Tot Picture "@E 999,999.99"     
		 	Li++
		 	@Li, 001 Psay "TOTAL COM AJUSTE->"               
		 	@Li ,041 Psay nCustTot + nTotAJVTM  Picture "@E 99,999,999.99"		 	    
		 	@Li, 071 Psay ((nVlrCAjTOT+nTotAJVTM)/nVlrCAjTOT) * (nCustTot / nArtigoTot)  Picture "@E 999,999,999.99 " 
		 	@Li, 101 Psay ((nVlrCAjTOT+nTotAJVTM)/nVlrCAjTOT) * (nCustTot / nM2Tot) Picture "@E 999,999,999.99 " 
	 		Li++
		 	
        Li++
        Li++
       	@Li ,  0 PSay __PrtThinLine()
       	Li++
        @Li, 001 Psay "MOVIMENTACOES INTERNA" 
        @Li++
		@Li, 001 Psay "UN.MED.|   LOCAL|  COD.FISC.|               QTDE|   CUSTO TOTAL|     TIPO MOV| "
		Li++


	TMPD3->(dbGotop())

	While !TMPD3->(eof())
		@Li, 003 PSay TMPD3->D3_UM
		@Li, 013 Psay TMPD3->D3_LOCAL
		@Li, 022 Psay TMPD3->D3_CF
		@Li, 035 Psay iif(Substr(TMPD3->D3_CF,1,2)=='RE', TMPD3->D3_QUANT, TMPD3->D3_QUANT * -1) Picture "@E 999,999,999.99"
		@Li, 050 Psay iif(Substr(TMPD3->D3_CF,1,2)=='RE', TMPD3->D3_CUSTO1, TMPD3->D3_CUSTO1 * -1) Picture "@E 999,999,999.99"
		@Li, 070 Psay TMPD3->D3_TM+'-'+Posicione("SF5",1,xFilial("SF5")+TMPD3->D3_TM,"F5_TEXTO")
		Li++
        nTotQTM += iif(Substr(TMPD3->D3_CF,1,2)=='RE', TMPD3->D3_QUANT, TMPD3->D3_QUANT * -1)
        nTotVTM += iif(Substr(TMPD3->D3_CF,1,2)=='RE', TMPD3->D3_CUSTO1, TMPD3->D3_CUSTO1 * -1)
		TMPD3->(dbSkip())
	enddo
	@Li, 001 PSay "TOTAL -->> "
	@Li, 035 Psay nTotQTM Picture "@E 999,999,999.99"
	@Li, 050 Psay nTotVTM Picture "@E 999,999,999.99"
		 	
		 	
		 	
	
endif 



If Li != 80
	Roda(cbcont,cbtxt)
EndIf


If aReturn[5] == 1
	Set Printer To
	OurSpool(wnrel)
EndIf

MS_FLUSH()
Return NIL

//+-----------------------------------------------------------------------------------//
//|Funcao....: MDirArq
//|Descricao.: Defini DiretÛrio e nome do arquivo a ser gerado
//|Retorno...: aRet[1] = DiretÛrio de gravaÁ„o
//|            aRet[2] = Nome do arquivo a ser gerado
//|ObservaÁ„o:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MDirArq()
*-----------------------------------------*
Local aRet := {"",""}
Private bFileFat:={|| cDir:=UZXChoseDir(),If(Empty(cDir),cDir:=Space(250),Nil)}
Private cArq    := Space(10)
Private cDir    := Space(250)
Private oDlgDir := Nil
Private cPath   := "Selecione diretÛrio"
Private aArea   := GetArea()
Private lRetor  := .T.
Private lSair   := .F.

//+-----------------------------------------------------------------------------------//
//| DefiniÁ„o da janela e seus conte˙dos
//+-----------------------------------------------------------------------------------//
While .T.
	DEFINE MSDIALOG oDlgDir TITLE "DefiniÁ„o de Arquivo e DiretÛrio" FROM 0,0 TO 175,368 OF oDlgDir PIXEL
	
	@ 06,06 TO 65,180 LABEL "Dados do arquivo" OF oDlgDir PIXEL
	
	@ 15, 10 SAY   "Nome do Arquivo"  SIZE 45,7 PIXEL OF oDlgDir
	@ 25, 10 MSGET cArq               SIZE 50,8 PIXEL OF oDlgDir
	
	@ 40, 10 SAY "Diretorio de gravaÁ„o"  SIZE  65, 7 PIXEL OF oDlgDir
	@ 50, 10 MSGET cDir PICTURE "@!"      SIZE 150, 8 WHEN .F. PIXEL OF oDlgDir
	@ 50,162 BUTTON "..."                 SIZE  13,10 PIXEL OF oDlgDir ACTION Eval(bFileFat)
	
	DEFINE SBUTTON FROM 70,10 TYPE 1  OF oDlgDir ACTION (UZXValRel("ok")) ENABLE
	DEFINE SBUTTON FROM 70,50 TYPE 2  OF oDlgDir ACTION (UZXValRel("cancel")) ENABLE
	
	ACTIVATE MSDIALOG oDlgDir CENTER
	
	If lRetor
		Exit
	Else
		Loop
	EndIf
EndDo

If lSair
	Return(aRet)
EndIf

aRet := {cDir,cArq}

Return(aRet)



*-----------------------------------------*
Static Function UZXChoseDir()
*-----------------------------------------*
Local cTitle:= "GeraÁ„o de arquivo"
Local cMask := "Formato *|*.*"
Local cFile := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions:= GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY

cFile:= cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,.F., nOptions)

Return(cFile)


//+-----------------------------------------------------------------------------------//
//|Funcao....: UZXValRel()
//|Descricao.: Valida informaÁıes de gravaÁ„o
//|Uso.......: U_UZXDIRARQ
//|ObservaÁ„o:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function UZXValRel(cValida)
*-----------------------------------------*

Local lCancela

If cValida = "ok"
	If Empty(Alltrim(cArq))
		MsgInfo("O nome do arquivo deve ser informado","AtenÁ„o")
		lRetor := .F.
	ElseIf Empty(Alltrim(cDir))
		MsgInfo("O diretÛrio deve ser informado","AtenÁ„o")
		lRetor := .F.
		//	ElseIf Len(Alltrim(cDir)) <= 3
		//		MsgInfo("N„o se pode gravar o arquivo no diretÛrio raiz, por favor, escolha um subdiretÛrio.","AtenÁ„o")
		//		lRetor := .F.
	Else
		oDlgDir:End()
		lRetor := .T.
	EndIf
Else
	lCancela := MsgYesNo("Deseja cancelar a geraÁ„o do RelatÛrio / Documento?","AtenÁ„o")
	If lCancela
		oDlgDir:End()
		lRetor := .T.
		lSair  := .T.
	Else
		lRetor := .F.
	EndIf
EndIf

Return(lRetor)


//+-----------------------------------------------------------------------------------//
//|Funcao....: MCSV
//|Descricao.: Gera Arvquivo do tipo csv
//|Retorno...: .T. ou .F.
//|ObservaÁ„o:
//+-----------------------------------------------------------------------------------//

*-------------------------------------------------*
Static Function MCVS(axVet,cxCab,cxArqTxt,PICTUSE)
*-------------------------------------------------*

Local cEOL       := CHR(13)+CHR(10)
Local nTamLin    := 2
Local cLin       := Space(nTamLin)+cEOL
Local cDadosCSV  := ""
Local lRet       := .T.
Local nHdl       := 0
Local nt 		 := 0
Local jk		 := 0

If Len(axVet) == 0
	MsgInfo("Dados n„o informados","Sem dados")
	lRet := .F.
	Return(lRet)
ElseIf Empty(cxArqTxt)
	MsgInfo("DiretÛrio e nome do arquivo n„o informados corretamente","DiretÛrio ou Arquivo")
	lRet := .F.
	Return(lRet)
EndIf

cxArqTxt := cxArqTxt+".csv"
nHdl := fCreate(cxArqTxt)

If nHdl == -1
	MsgAlert("O arquivo de nome "+cxArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

nTamLin := 2
cLin    := Space(nTamLin)+cEOL

ProcRegua(Len(axVet))

If !Empty(cxCab)
	cLin := Stuff(cLin,01,02,cxCab)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no CabeÁalho. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		Endif
	Endif
EndIf

For jk := 1 to Len(axVet)
	nTamLin   := 2
	cLin      := Space(nTamLin)+cEOL
	cDadosCSV := ""
	IncProc("Gerando arquivo CSV")
	For nt := 1 to Len(axVet[jk])
		If ValType(axVet[jk,nt]) == "C"
			cDadosCSV += axVet[jk,nt]+Iif(nt = Len(axVet[jk]),"",";")
		ElseIf ValType(axVet[jk,nt]) == "N"
			cDadosCSV += Transform(axVet[jk,nt],PICTUSE)+Iif(nt = Len(axVet[jk]),"",";")
		ElseIf ValType(axVet[jk,nt]) == "U"
			cDadosCSV += +Iif(nt = Len(axVet[jk]),"",";")
		Else
			cDadosCSV += axVet[jk,nt]+Iif(nt = Len(axVet[jk]),"",";")
		EndIf
	Next
	cLin := Stuff(cLin,01,02,cDadosCSV)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo nos Itens. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		Endif
	Endif
Next
fClose(nHdl)
Return(lOk)

//+-----------------------------------------------------------------------------------//
//|Funcao....: MExcel
//|Descricao.: Abre arquivo csv em excel
//|ObservaÁ„o:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MExcel(cxDir,cxArq)
*-----------------------------------------*
Local cArqTxt := cxDir+cxArq+".csv"
Local cMsg    := "Relatorio gerado com sucesso!"+CHR(13)+CHR(10)+"O arquivo "+cxArq+".csv"
cMsg    += " se encontra no diretÛrio "+cxDir

MsgInfo(cMsg,"AtenÁ„o")

If MsgYesNo("Deseja Abrir o arquivo em Excel?","AtenÁ„o")
	If ! ApOleClient( 'MsExcel' )
		MsgStop(" MsExcel nao instalado ")
		Return
	EndIf
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cArqTxt)
	oExcelApp:SetVisible(.T.)
EndIf

Return


User function GeraExcPQ()

Local cQuery   := "",cIndex := CriaTrab("",.F.),nIndex:=0
Local cQryMov:= "",cIndexMov:= CriaTrab("",.F.),nIndexMov:=0  //Query para gravar todos os movimentos sem OP.
Local lQuery   := .F.                                                                                          
Local lQueryMov:= .F.
//Local aStruSC2 := {}
//Local cAliasSC2:= "(cAliasQry)"
Local cAliasQry    := GetNextAlias()                                                                                              
Local cAliasQMv := GetNextAlias()
Local cGrupo := ""
Local cProdPI := cProdPA := "" 
Local i := 0
Local iArt := 0
cArtigoAnt := ' '
nArtigoAnt := 0
nCustAnt   := 0
nPesoAnt   := 0
nArtigoTot := 0
nCustTot   := 0
nPesoTot   := 0
nCont      := 0 



for i:=1 to 40
	if Substr(mv_par03,i,1) == ';' .or. Substr(mv_par03,i,1) == '/'
		cGrupo:= cGrupo+"','"
	else
		cGrupo:= cGrupo+Substr(mv_par03,i,1)
	endif
	if Substr(mv_par03,i,1) == " "
		i:= 40
	endif
next              

U_CriaTMPPQ(cAliasQry,cAliasQMv) 

/*
cQuery1 := " SELECT D3_FILIAL, D3_COD, D3_TM, D3_UM, D3_QUANT, D3_CF, D3_OP, "
cQuery1 += " D3_LOCAL, D3_DOC, D3_GRUPO, D3_EMISSAO, D3_CUSTO1, D3_TIPO "
cQuery1 += " FROM "+ RetSQLName( "SD3" ) + " SD3 "
cQuery1 += " where SD3.D_E_L_E_T_ = ' ' AND SD3.D3_ESTORNO <> 'S' "
cQuery1 += " AND SD3.D3_FILIAL = '"+xFilial("SD3")+"' "
cQuery1 += " AND SD3.D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
cQuery1 += "	AND SD3.D3_GRUPO in ('"+cGrupo+"') "
cQuery1 += " AND Substring(SD3.D3_OP,1,6) BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
cQuery1 += " AND SD3.D3_LOCAL BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "    
cQuery1 += " AND Substring(SD3.D3_CF,1,1) in ('P','R') "
cQuery1 += " AND D3_OP <> '' "
if mv_par10 == 1
	cQuery1 += " ORDER BY SD3.D3_OP "
else
	cQuery1 += " ORDER BY SD3.D3_COD " 
endif

cQuery1 := ChangeQuery(cQuery1)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery1),cAliasQMV, .F., .T.)
TcSetField(cAliasQry, "D3_EMISSAO", "D")
*/



(cAliasQry)->(dbGotop())   
ProcREgua( Reccount() )
if mv_par10 == 2

	//Adicionando linhas no array da planilha para gerar arquivo Excel
	aAdd(aConteud,{"","CONSUMO DE PRODUTOS QUIMICOS...","","","","","","","","","",""})
	aAdd(aConteud,{"","","","","","","","","","","",""}) //12 colunas
	//CabeÁalho
	//TabulaÁao     1             2           3             4    5        6      7        8           9        10       11        12   
	aAdd(aConteud,{"CODIGO","DESCRICAO","DATA DE EMISSAO","TM","COD."," QTDE","CUSTO","ORDEM DE","DESCRICAO","QTDE","DESCRICAO","QTDE"}) //12 colunas
	aAdd(aConteud,{"      ","         ","               ","  ","FISC","SAIDA","     ","PRODUCAO","       PI","P.I.","       PA","P.A."}) //12 colunas

	cProdAnt  := (cAliasQry)->D3_COD
	nProdAcum := nProdAnt := 0
	nCustAcum := nCustAnt := 0
	While !(cAliasQry)->(EoF())
	incproc('Processando relatorio....'+ (cAliasQry)->D3_COD)
		aAdd(aConteud,{"","","","","",0,0,"","",0,"",0}) //12 colunas
		aConteud [len(aConteud),1] := Substr((cAliasQry)->D3_COD,1,6)
		aConteud [len(aConteud),2] := Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->D3_COD, "B1_DESC")
		aConteud [len(aConteud),3] := dToc((cAliasQry)->D3_EMISSAO)
		aConteud [len(aConteud),4] := (cAliasQry)->D3_TM
		aConteud [len(aConteud),5] := (cAliasQry)->D3_CF
		aConteud [len(aConteud),6] := (cAliasQry)->D3_QUANT 
		aConteud [len(aConteud),7] := (cAliasQry)->D3_CUSTO1
		aConteud [len(aConteud),8] := Substr((cAliasQry)->D3_OP,1,11)
		nProdPA := nProdPI := 0
		dbSelectArea("SD3")
		dbSetOrder(1)                           
		dbSeek(xFilial("SD3")+Substr((cAliasQry)->D3_OP,1,8),.T.)
		while !SD3->(eof()).and.Substr(SD3->D3_OP,1,8)== Substr((cAliasQry)->D3_OP,1,8)
			if SD3->D3_CF == 'PR0'       
				if SD3->D3_TM = '500' .and. Substr(SD3->D3_OP,9,3)=='001'.and. SD3->D3_ESTORNO == ' '
					cProdPA := SD3->D3_COD
					nProdPA += SD3->D3_QUANT
				elseif SD3->D3_TM == '500' .and. Substr(SD3->D3_OP,9,3) == '002' .and. SD3->D3_ESTORNO == ' '
					cProdPI := SD3->D3_COD
					nProdPI += SD3->D3_QUANT
				endif
			endif
		SD3->(dbSkip())                   
		enddo               
		if nProdPI > 0
			aConteud [len(aConteud),9] := Substr(cProdPI,1,6) + ' - '+Substr(Posicione("SB1",1,xFilial("SB1")+cProdPI, "B1_DESC"),1,20)
			aConteud [len(aConteud),10]:= nProdPi 
		else
			aConteud [len(aConteud),9] := "N√O HOUVE P.I. NESTA O.P."
			aConteud [len(aConteud),10]:= 0
		endif
		if nProdPA > 0 
			aConteud [len(aConteud),11]:= Substr(cProdPA,1,6) + ' - '+Substr(Posicione("SB1",1,xFilial("SB1")+cProdPA, "B1_DESC"),1,20)
			aConteud [len(aConteud),12]:= nProdPa 
		else
			aConteud [len(aConteud),11]:= "N√O HOUVE P.A. NESTA O.P."
			aConteud [len(aConteud),12]:= 0
		endif
	
	(cAliasQry)->(dbSkip())

	enddo 
else

	//Adicionando linhas no array da planilha para gerar arquivo Excel
//	aAdd(aConteud,{"","CONSUMO DE PRODUTOS QUIMICOS...","","","","","","","","","",""})
//	aAdd(aConteud,{"","","","","","","","","","","",""}) //12 colunas
	//CabeÁalho
	//TabulaÁao     1             2           3             4    5        6      7        8           9        10       11        12   
//	aAdd(aConteud,{"CODIGO","DESCRICAO","DATA DE EMISSAO","TM","COD."," QTDE","CUSTO","ORDEM DE","DESCRICAO","QTDE","DESCRICAO","QTDE"}) //12 colunas
//	aAdd(aConteud,{"      ","         ","               ","  ","FISC","SAIDA","     ","PRODUCAO","       PI","P.I.","       PA","P.A."}) //12 colunas

cOpAnt:= (cAliasQry)->D3_OP
	While !(cAliasQry)->(EoF())                              
		incproc('Calculando produto....'+ (cAliasQry)->D3_COD)
		dbSelectArea("TMP")
		if dbSeek((cAliasQry)->D3_COD) 
			RecLock("TMP",.F.)
			TMP->D3_QUANT	+= (cAliasQry)->D3_QUANT
			TMP->D3_CUSTO1	+= (cAliasQry)->D3_CUSTO1
		else
			RecLock("TMP",.T.)
			TMP->D3_COD		:= (cAliasQry)->D3_COD
			TMP->D3_TM		:= (cAliasQry)->D3_TM
			TMP->D3_CF		:= (cAliasQry)->D3_CF
			TMP->D3_QUANT	:= (cAliasQry)->D3_QUANT
			TMP->D3_CUSTO1	:= (cAliasQry)->D3_CUSTO1
			TMP->D3_TIPO	:= "PQ"
		endif
		MsUnLock("TMP")
	(cAliasQry)->(dbSkip())

		if cOpAnt <> (cAliasQry)->D3_OP
			nProdPA := nProdPI := nCustoPA := nCustoPI := nPesoPQ:= 0
			dbSelectArea("SD3")
			dbSetOrder(1)                           
			dbSeek(xFilial("SD3")+Substr(cOpAnt,1,8),.T.)
			while !SD3->(eof()).and.Substr(SD3->D3_OP,1,8)== Substr(cOpAnt,1,8)
			incproc('Calculando movimentacao do produto....'+ SD3->D3_COD)
				if SD3->D3_CF == 'PR0'       
					if SD3->D3_TM = '500' .and. Substr(SD3->D3_OP,9,3)=='001' .and. SD3->D3_ESTORNO == ' '
						cProdPA  := SD3->D3_COD
						nProdPA  += SD3->D3_QUANT
					elseif SD3->D3_TM == '500' .and. Substr(SD3->D3_OP,9,3) == '002' .and. SD3->D3_ESTORNO == ' '
						cProdPI  := SD3->D3_COD
						nProdPI  += SD3->D3_QUANT
						nCustoPI += SD3->D3_CUSTO1
					endif
				elseif Substr(SD3->D3_OP,9,3)=='002' .and. SD3->D3_ESTORNO == ' ' .and. SD3->D3_CF='RE1' .and. (SD3->D3_GRUPO == '12  ' .or. SD3->D3_GRUPO == '14  ')
						nCustoPA += SD3->D3_CUSTO1 //Grava o custo de produto quimico 
						if SD3->D3_UM = 'KG'
							nPesoPQ  += SD3->D3_QUANT
						endif
				endif
			SD3->(dbSkip())
			enddo              

            dbSelectArea("TMP")        
            	//Gravar o PA no resumo...
				if dbSeek(cProdPA) 
					RecLock("TMP",.F.)
//					if Substr(cProdPA,1,6) == '023735'
//						Alert("Adicionando PA: "+cProdPA+" Qtde-> "+cValToChar(nProdPA)+" OP Ant: "+cOpAnt)
//					endif
					TMP->D3_QUANT	+= nProdPA
					TMP->D3_CUSTO1	+= nCustoPA
					TMP->PESOPQ  += nPesoPQ
				else
					RecLock("TMP",.T.)
					TMP->D3_COD		:= cProdPA
					TMP->D3_TM		:= '500'
					TMP->D3_CF		:= 'PR0'                      
//					if Substr(cProdPA,1,6) == '023735'
//						Alert("Incluindo PA: "+cProdPA+" Qtde-> "+cValToChar(nProdPA)+" OP Ant: "+cOpAnt)
//					endif
					TMP->D3_QUANT	:= nProdPA
					TMP->D3_CUSTO1	:= nCustoPA
					TMP->PESOPQ  += nPesoPQ
					TMP->D3_TIPO	:= "PA"
					if cProdPI == "" 
						cProdPI := cProdPA
					endif
					if Substr(Posicione("SB1",1,xFilial("SB1")+cProdPA, "B1_TPCLASS"),1,2)=="CV"
						TMP->ARTIGO := "CROMO VOLANTE"	
					elseif Substr(Posicione("SB1",1,xFilial("SB1")+cProdPI, "B1_TPCLASS"),1,2)=="CR"
						TMP->ARTIGO := "CROMO"
					elseif Substr(Posicione("SB1",1,xFilial("SB1")+cProdPI, "B1_TPCLASS"),1,2)=="CF"
						TMP->ARTIGO := "CROMO FREE"
					elseif Substr(Posicione("SB1",1,xFilial("SB1")+cProdPI, "B1_TPCLASS"),1,2)=="CT"
						TMP->ARTIGO := "CROMO TIRA TINTA"
					elseif Substr(Posicione("SB1",1,xFilial("SB1")+cProdPI, "B1_TPCLASS"),1,2)=="FT"
						TMP->ARTIGO := "CROMO FREE T.TIN"
					elseif Substr(Posicione("SB1",1,xFilial("SB1")+cProdPI, "B1_TPCLASS"),1,2)=="HT"
						TMP->ARTIGO := "VOLANTE T.TINTA"
					endif
						
				endif              
				dbSelectArea("TMP")
				MsUnLock("TMP")
				//Gravar o PI no Resumo...
				if dbSeek(cProdPI) 
					RecLock("TMP",.F.)
					TMP->D3_QUANT	+= nProdPI
					TMP->D3_CUSTO1	+= nCustoPI
				else
					RecLock("TMP",.T.)
					TMP->D3_COD		:= cProdPI
					TMP->D3_TM		:= '500'
					TMP->D3_CF		:= 'PR0'
					TMP->D3_QUANT	:= nProdPI
					TMP->D3_CUSTO1	:= nCustoPI
					TMP->D3_TIPO	:= "PI"
				endif             
				MsUnLock("TMP")
		endif
		cOpAnt := (cAliasQry)->D3_OP		

	enddo

dbSelectArea('TRBPA')
dbGotop()
while !TRBPA->(eof())                                            
	incproc('Gravando metro quadrado dos produtos....'+ TRBPA->D3_COD)
	dbSelectArea('TMP')
	TMP->(dbGotop())    
//	Alert("Pesquisando produto...:|"+TRBPA->D3_COD+ '| Qtde '+cValToChar(TRBPA->D3_QTDEM2))
	if dbSeek(Padr(TRBPA->D3_COD,20))
//		Alert("Produto Encontrado...:"+TRBPA->D3_COD+ ' Qtde '+cValToChar(TRBPA->D3_QTDEM2))
		RecLock('TMP',.F.)
		TMP->D3_QTDEM2 := TRBPA->D3_QTDEM2
		MsUnlock('TMP')
	endif
	TRBPA->(dbSkip())
enddo


	//Gerar o Resumo em excel 
	dbSelectArea("TMP")
	cArquivo := CriaTrab(,.F.)    
	INDREGUA("TMP",cArquivo,"ARTIGO",,)
	TMP->(dbGotop())
	cArtigoAnt := ' '
	nArtigoAnt := 0
	nCustAnt   := 0      
	nPesoAnt   := 0                                            
	nArtigoTot := 0
	nM2Ant     := 0
	nM2TotAnt  := 0
	nCustTot   := 0
	nPesoTot   := 0
	Li := 59
	nCont:=0                                              
	aAdd(aConteud,{"EMITENTE: "+cUserName,"","","","","","",""})
	aAdd(aConteud,{"DATA:"+dToc(ddatabase),"","","","","","",""})
	aAdd(aConteud,{"UNIDADE: "+xFilial("SD3"),"","","","","","",""})
	aAdd(aConteud,{"PERIODO DE "+dToc(mv_par01)+" AT… "+dToc(mv_par02),"","","","","",""})
	aAdd(aConteud,{"","","","","","","",""})
	cabec1 := "                           KG TOTAL  |        R$ TOTAL  |       QTDE  |      R$ / VAQ  | CODIGO     | DESCRICAO "
	cabec2 := "                                     |                  |        VAQ  |                |            |           "

	aAdd(aConteud,{"","CONSUMO DE PRODUTOS QUIMICOS - COURO SEMI-ACABADO","","","","","",""})
	aAdd(aConteud,{"","","","","","","",""}) //8 colunas
	aAdd(aConteud,{"KG TOTAL","R$ TOTAL","QTDE VAQ","R$ / VAQ","QTDE M2", "R$/M2", "CODIGO","DESCRICAO"}) //8 colunas	

	
	While !TMP->(EoF())
//		If lEnd
//			@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
//			Exit
//		EndIf

		if Substr(TMP->ARTIGO,1,1) <> ' '
			if nCont == 0                             
				aAdd(aConteud,{"","","","","","","",""})
				aConteud [len(aConteud),1] := "ARTIGO: "+TMP->ARTIGO

			endif                              
			aAdd(aConteud,{0,0,0,0,0,0,"",""})			
			aConteud [len(aConteud),1] := TMP->PESOPQ
			aConteud [len(aConteud),2] := TMP->D3_CUSTO1
			aConteud [len(aConteud),3] := TMP->D3_QUANT
			aConteud [len(aConteud),4] := TMP->D3_CUSTO1 / TMP->D3_QUANT     
			aConteud [len(aConteud),5] := TMP->D3_QTDEM2
			aConteud [len(aConteud),6] := TMP->D3_CUSTO1 / TMP->D3_QTDEM2
			aConteud [len(aConteud),7] := "'"+Substr(TMP->D3_COD,1,6)
			aConteud [len(aConteud),8] := Posicione("SB1",1,xFilial("SB1")+TMP->D3_COD, "B1_DESC")
            nCont++
			nArtigoAnt += TMP->D3_QUANT
			nCustAnt   += TMP->D3_CUSTO1
			nM2Ant     += TMP->D3_QTDEM2
			nPesoAnt   += TMP->PESOPQ
	  	endif
	 TMP->(dbSkip())
	 if cArtigoAnt <> ' '
		if cArtigoAnt <> TMP->ARTIGO
			aAdd(aConteud,{0,0,0,0,0,0,"",""})			
			aConteud [len(aConteud),1] := nPesoAnt
			aConteud [len(aConteud),2] := nCustAnt
			aConteud [len(aConteud),3] := nArtigoAnt
			aConteud [len(aConteud),4] := nCustAnt / nArtigoAnt
			aConteud [len(aConteud),5] := nM2Ant
			aConteud [len(aConteud),6] := nCustAnt / nM2Ant   //nM2TotAnt
			aConteud [len(aConteud),7] := "<<<--- TOTAL DO ARTIGO "+cArtigoAnt
			aConteud [len(aConteud),8] := " "     
			aAdd(aConteud,{"","","","","","","",""}) //Linha vazia
	 		nArtigoTot += nArtigoAnt
			nCustTot   += nCustAnt
			nPesoTot   += nPesoAnt
			nM2TotAnt  += nM2Ant
			nCont    := 0
		 	nTipoAnt := nCustAnt := nPesoAnt := nArtigoAnt := nM2Ant := 0
		 	cTipoAnt := TMP->D3_TIPO                                     
	 	endif
	 endif  
	 cArtigoAnt := TMP->ARTIGO
	enddo
			aAdd(aConteud,{0,0,0,0,0,0,"",""})			
			aConteud [len(aConteud),1] := nPesoTot
			aConteud [len(aConteud),2] := nCustTot
			aConteud [len(aConteud),3] := nArtigoTot
			aConteud [len(aConteud),4] := nCustTot / nArtigoTot
			aConteud [len(aConteud),5] := nM2TotAnt
			aConteud [len(aConteud),6] := nCustTot / nM2TotAnt
			aConteud [len(aConteud),7] := "<<<--- TOTAL GERAL"
			aConteud [len(aConteud),8] := " "     
	                                                

		aAdd(aConteud,{"","","","","","","",""})			
		aAdd(aConteud,{"MOVIMENTA«’ES INTERNA","","","","","","",""})
		aAdd(aConteud,{"UN.MED.","LOCAL","COD.FISC","QTDE","CUSTO TOTAL","TP MOV","",""})
	nTotQTM:= 0
	nTotVTM:= 0                                     

	TMPD3->(dbGotop())
	While !TMPD3->(eof())
		aAdd(aConteud,{"","","","","","",0,0})
		aConteud [len(aConteud),1] := TMPD3->D3_UM
		aConteud [len(aConteud),2] := "'"+TMPD3->D3_LOCAL+"'"
		aConteud [len(aConteud),3] := "'"+TMPD3->D3_CF+"'"
		aConteud [len(aConteud),4] := iif(Substr(TMPD3->D3_CF,1,2)=='RE', TMPD3->D3_QUANT, TMPD3->D3_QUANT * -1)
		aConteud [len(aConteud),5] := iif(Substr(TMPD3->D3_CF,1,2)=='RE', TMPD3->D3_CUSTO1, TMPD3->D3_CUSTO1 * -1)
		aConteud [len(aConteud),6] := TMPD3->D3_TM+'-'+Posicione("SF5",1,xFilial("SF5")+TMPD3->D3_TM,"F5_TEXTO")
		aConteud [len(aConteud),7] := 0
		aConteud [len(aConteud),8] := 0
        nTotQTM += iif(Substr(TMPD3->D3_CF,1,2)=='RE', TMPD3->D3_QUANT, TMPD3->D3_QUANT * -1)
        nTotVTM += iif(Substr(TMPD3->D3_CF,1,2)=='RE', TMPD3->D3_CUSTO1, TMPD3->D3_CUSTO1 * -1)
		TMPD3->(dbSkip())
	enddo
	aAdd(aConteud,{"TOTAL -->>","","",nTotQTM,nTotVTM,"","",""})

//	aAdd(aConteud,{"","","","","",""}) //6 colunas
//	aAdd(aConteud,{"TOTAL FINAL DO CONSUMO/CUSTOS","","","",""}) //5 colunas
//	aAdd(aConteud,{"DESCRICAO","KG TOTAL","R$ TOTAL","QTDE VAQ","R$ / VAQ"}) // 5 colunas	



	                                                 
    aAdd(aConteud,{"","","","","","","",""})
	aAdd(aConteud,{"RESUMO","VALOR TOTAL", "% TOTAL", "VALOR C/AJUST","QTDE VAQ", "R$/VAQ C/AJUST","",""})
		for iArt:= 1 to len(aConteud) 
			if Substr(cValToChar(aConteud [iArt,5]),1,22) == "<<<--- TOTAL DO ARTIGO"
				aAdd(aConteud,{"",0,"@E 999.99%",0,0,0,0,0}) 
				aConteud [len(aConteud),1] := Substr(cValToChar(aConteud [iArt,5]),23,15)
				aConteud [len(aConteud),2] := aConteud [iArt,2]
				aConteud [len(aConteud),3] := aConteud [iArt,2] / nCustTot
				aConteud [len(aConteud),4] := (aConteud [iArt,2]+((aConteud [iArt,2]/nCustTot)*nTotVTM))
				aConteud [len(aConteud),5] := aConteud [iArt,3]
				aConteud [len(aConteud),6] := (aConteud [iArt,2]+((aConteud [iArt,2]/nCustTot)*nTotVTM))/(aConteud [iArt,3])
				aConteud [len(aConteud),7] := ""
				aConteud [len(aConteud),8] := ""
			endif
		next
			aAdd(aConteud,{"TOTAL GERAL",nCustTot,100, nCustTot+nTotVTM, nArtigoTot,(nCustTot+nTotVTM)/nArtigoTot,"",""})
			aAdd(aConteud,{"OUTROS MVTOS",nTotVTM,0,0,0,"","",""})
			aAdd(aConteud,{"TOTAL GER.C/ACERTOS",nCustTot+nTotVTM,100,nCustTot+nTotVTM, nArtigoTot,(nCustTot+nTotVTM)/nArtigoTot,"",""})



//alert("Tamanho do Array: "+cValToChar(len(AConteud)))
for iArt:= 1 to len(aConteud)                                                           
//	alert("Fazendo linha..."+cValToChar(iArt))
	if Substr(cValToChar(aConteud [iArt,7]),1,22) == "<<<--- TOTAL DO ARTIGO"
		aConteud [iArt+1, 4] := (aConteud [iArt,2]+((aConteud [iArt,2]/nCustTot)*nTotVTM))/(aConteud [iArt,3])
		aConteud [iArt+1, 6] := (aConteud [iArt,2]+((aConteud [iArt,2]/nCustTot)*nTotVTM))/(aConteud [iArt,5])
		aConteud [iArt+1, 7] := "<<-- TOTAL DO ARTIGO C/AJUSTE"
	elseif Substr(cValToChar(aConteud [iArt,7]),1,18) == "<<<--- TOTAL GERAL"
		aConteud [iArt+1, 4] := (aConteud [iArt,2]+((aConteud [iArt,2]/nCustTot)*nTotVTM))/(aConteud [iArt,3])		
		aConteud [iArt+1, 6] := (aConteud [iArt,2]+((aConteud [iArt,2]/nCustTot)*nTotVTM))/(aConteud [iArt,5])
	endif
	next
	

			

endif

	//Apagar indice tempor·rio.... 

//DbSelectArea( 'TRBPA' ) //Selecionando a area
//fErase( cIndPA + OrdBagExt() ) //Deletando arquivo de trabalho



Return()


user function CriaTMPPQ(cAliasQry,cAliasQMv)

Local aCampos := {} 
Local cQuery   := "",cIndex := CriaTrab("",.F.),nIndex:=0
Local cQryMov:= "",cIndexMov:= CriaTrab("",.F.),nIndexMov:=0  //Query para gravar todos os movimentos sem OP.
Local lQuery   := .F.                                         
Local lQueryMov:= .F.
Local cGrupo := ""
Local i := 0

	AADD(aCampos,{"D3_COD"    , "C", 15})
	AADD(aCampos,{"D3_TM"     , "C", 3})
	AADD(aCampos,{"D3_CF"     , "C", 3})
	AADD(aCampos,{"D3_QUANT"  , "N", 14,2})
	AADD(aCampos,{"D3_CUSTO1" , "N", 14,4})
	AADD(aCampos,{"D3_TIPO"   , "C", 2})
	AADD(aCampos,{"D3_QTDEM2" , "N", 14,2})
	AADD(aCampos,{"ARTIGO"    , "C", 15})
	AADD(aCampos,{"PESOPQ"    , "N", 14,2})

	//AADD(aCampos,{"D3_EMISSAO", "D", 8})

	cNome := CriaTrab(aCampos,.T.)
	If (Select("TMP") <> 0)
		dbSelectArea("TMP")
		dbCloseArea("TMP")
	Endif
	dbUseArea(.T.,,cNome,"TMP",Nil,.F.)

	DbSelectArea("TMP")
	cArquivo := CriaTrab(,.F.)    
	INDREGUA("TMP",cArquivo,"D3_COD",,)



for i:=1 to 40
	if Substr(mv_par03,i,1) == ';' .or. Substr(mv_par03,i,1) == '/'
		cGrupo:= cGrupo+"','"
	else
		cGrupo:= cGrupo+Substr(mv_par03,i,1)
	endif
	if Substr(mv_par03,i,1) == " "
		i:= 40
	endif
next                                




cQuery := " SELECT D3_FILIAL, D3_COD, D3_TM, D3_UM, D3_QUANT, D3_CF, D3_OP, "
cQuery += " D3_LOCAL, D3_DOC, D3_GRUPO, D3_EMISSAO, D3_CUSTO1, D3_TIPO, D3_QTDEM2 "
cQuery += " FROM "+ RetSQLName( "SD3" ) + " SD3 "
cQuery += " where SD3.D_E_L_E_T_ = ' ' AND SD3.D3_ESTORNO <> 'S' "
cQuery += " AND SD3.D3_FILIAL = '"+xFilial("SD3")+"' "
cQuery += " AND SD3.D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
cQuery += "	AND SD3.D3_GRUPO in ('"+cGrupo+"') "
cQuery += " AND Substring(SD3.D3_OP,1,6) BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
cQuery += " AND SD3.D3_LOCAL BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "    
cQuery += " AND Substring(SD3.D3_CF,1,1) in ('P','R') "
cQuery += " AND D3_OP <> '' "
if mv_par10 == 1
	cQuery += " ORDER BY SD3.D3_OP "
else
	cQuery += " ORDER BY SD3.D3_COD " 
endif

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)

TcSetField(cAliasQry, "D3_EMISSAO", "D")



cQryMov := " SELECT D3_TM, D3_UM, Sum(D3_QUANT) D3_QUANT, D3_CF,  "
cQryMov += " D3_LOCAL, Sum(D3_CUSTO1) D3_CUSTO1, Sum(D3_QTDEM2) D3_QTDEM2 "
cQryMov += " FROM "+ RetSQLName( "SD3" ) + " SD3 "
cQryMov += " where SD3.D_E_L_E_T_ = ' ' AND SD3.D3_ESTORNO <> 'S' "
cQryMov += " AND SD3.D3_FILIAL = '"+xFilial("SD3")+"' "
cQryMov += " AND SD3.D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
cQryMov += " AND SD3.D3_GRUPO in ('"+cGrupo+"') "                              
cQryMov += " AND SD3.D3_LOCAL BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "    
cQryMov += " AND SD3.D3_CF <> 'DE4' AND SD3.D3_CF <> 'RE4' "
cQryMov += " AND SD3.D3_CF <> 'DE7' AND SD3.D3_CF <> 'RE7' "
cQryMov += " AND D3_OP = ''"
cQryMov += " group by D3_FILIAL, D3_TM, D3_UM, D3_CF, D3_LOCAL "
                       
If Select('TMPD3') > 0 
	dbSelectArea('TMPD3')
	dbclosearea()
endif

dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQryMov  ), 'TMPD3' , .F. , .T. )
	
	

cQryPA := " SELECT Substring(D3_COD,1,6) D3_COD, Sum(D3_QTDEM2) D3_QTDEM2 from SD3010 SD3 "
cQryPA += " where D_E_L_E_T_ = ' ' "
cQryPA += " and D3_FILIAL = '"+xFilial("SD3")+"' "
cQryPA += " and D3_QTDEM2 > 0 "
cQryPA += " AND SD3.D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
cQryPA += " and Substring(D3_OP,9,3) = '001' "
cQryPA += " and D3_ESTORNO <> 'S' "
cQryPA += " and D3_CF = 'PR0' "
cQryPA += " group by Substring(D3_COD,1,6) "

if Select('TRBPA') > 0
	dbSelectArea('TRBPA')
	dbclosearea()
endif

dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQryPA ), 'TRBPA', .F. , .T. )
	

//Criar indice tempor·rio para a consulta do PA                                       
//DbSelectArea('TRBPA')
//cChavePA := "D3_COD"
//cIndPA := CriaTrab(Nil,.F.)                                  
//IndRegua("TRBPA", cIndPA, cChavePA, , , "Selecionando Itens PA...")

//cQryMov := ChangeQuery(cQryMov)                               
//dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQryMov),cAliasQMv, .F., .T.)



return




/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ-ø±±
±±≥FunáÖo    ≥ AjustaSX1    ≥Autor ≥  Anesio G.Faria -    ≥    02.08.2010 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ-¥±±
±±≥DescriáÖo ≥ Ajusta perguntas do SX1                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function AjustaSX1()

Local aArea := GetArea()
PutSx1(cPerg,"01","Periodo de                    ?"," "," ","mv_ch1","D",8,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo inicial"},{"Informe o periodo inicial"},{"Informe o periodo inicial"})
PutSx1(cPerg,"02","Periodo ate                   ?"," "," ","mv_ch2","D",8,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo final"},{"Informe o periodo final"},{"Informe o periodo final"})
PutSx1(cPerg,"03","Grupos                        ?"," "," ","mv_ch3","C",40,0,0,"G","","   ","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe os grupos a serem filtrados, separado por ; ou /, sem espaÁos entre os grupos"},{"Informe os grupos a serem filtrados, separado por ; ou /"},{"Informe os grupos a serem filtrados, separado por ; ou /"})
PutSx1(cPerg,"04","Produto de                    ?"," "," ","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto inicial"},{"Informe o produto inicial"},{"Informe o produto inicial"})
PutSx1(cPerg,"05","Produto ate                   ?"," "," ","mv_ch5","C",15,0,0,"G","","SB1","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto final"},{"Informe o produto final"},{"Informe o produto final"})
PutSx1(cPerg,"06","Ordem de Producao de          ?"," "," ","mv_ch6","C",6,0,0, "G","","SC2","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a OP Inicial        "},{"Informe a OP Inicial        "},{"Informe a OP Inicial        "})
PutSx1(cPerg,"07","Ordem de Producao ate         ?"," "," ","mv_ch7","C",6,0,0, "G","","SC2","","","mv_par07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a OP Final        "},{"Informe a OP Final        "},{"Informe a OP Final        "})
PutSx1(cPerg,"08","Armazem de                    ?"," "," ","mv_ch8","C",2,0,0, "G","","   ","","","mv_par08"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o Armazem inicial           "},{"Informe o Armazem inicial           "},{"Informe o Armazem inicial           "})
PutSx1(cPerg,"09","Armazem ate                   ?"," "," ","mv_ch9","C",2,0,0, "G","","   ","","","mv_par09"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o Armazem Final           "},{"Informe o Armazem final           "},{"Informe o Armazem final           "})
PutSx1(cPerg,"10","Imprimir Resumo               ?"," "," ","mv_cha","N",1,0,2, "C","","   ","","","mv_par10","Sim","Si","Yes", " ","Nao","No","No"," "," "," ", " "," "," "," ",	" ","",{"Imprimir resumo ao final do relatorio"},{"Imprimir resumo ao final do relatorio"},{"Imprimir resumo ao final do relatorio"})
RestArea(aArea)
Return



