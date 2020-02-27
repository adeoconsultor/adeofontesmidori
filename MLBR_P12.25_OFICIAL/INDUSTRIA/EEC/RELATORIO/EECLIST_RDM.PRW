#INCLUDE "EECPEM11.ch"
#include "EECRDM.CH"
#define NUMLINPAG  23
#define TAMDESC    29

/*
Programa        : EECLIST.PRW
Objetivo        : Impressao do Packing List - Couro
Autor           : Robson Luiz S. Dias
Data/Hora       : 05/08/09
Obs.            : 
*/
User Function EECLIST1

Local lRet    := .t.
Local nAlias  := Select()
Local aOrd    := SaveOrd({"EXP","EXR","EE9","SA2","EE2","DETAIL_P"})
Private cPerg := Avkey("EECLIST","X1_GRUPO")

Begin Sequence
	
	IF !TelaGets()
		lRet := .f.
		Break
	Endif

	EXP->(dbSetOrder(2))
	EXP->(dbSeek(xFilial("EXP")+MV_PAR01))
	
	
	If EEC->(DBSEEK(XFILIAL('EEC')+EXP->EXP_PREEMB))
		
		cSEQREL := GetSXENum("SY0","Y0_SEQREL")
		CONFIRMSX8()
		
		HEADER_P->(DBAPPEND())
		HEADER_P->AVG_FILIAL:= xFilial("SY0")
		HEADER_P->AVG_SEQREL:= cSEQREL
		HEADER_P->AVG_CHAVE := mv_par01 //nr. da Invoice
		
		SA2->(dbSetOrder(1))
		IF !EMPTY(EEC->EEC_EXPORT) .AND. ;
			SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
			cExp_Cod     := EEC->EEC_EXPORT+EEC->EEC_EXLOJA
			cEXP_NOME    := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
			cEXP_CONTATO := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1)  //nome do contato seq 1
			cEXP_FONE    := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",4)  //fone do contato seq 1
			cEXP_FAX     := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",7)  //fax do contato seq 1
			cEXP_CARGO   := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",2)  //CARGO
		ELSE
			SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA))
			cExp_Cod     := EEC->EEC_FORN+EEC->EEC_FOLOJA
			cEXP_NOME    := SA2->A2_NOME
			cEXP_CONTATO := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
			cEXP_FONE    := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
			cEXP_FAX     := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
			cEXP_CARGO   := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",2,EEC->EEC_RESPON)  //CARGO
		ENDIF
		
		// Dados do Exportador/Fornecedor
		HEADER_P->AVG_C01_60:=ALLTRIM(cEXP_NOME) // TITULO 1
		HEADER_P->AVG_C02_60:=ALLTRIM(SA2->A2_END)
		HEADER_P->AVG_C03_60:=ALLTRIM(SA2->A2_EST+" "+AllTrim(BuscaPais(SA2->A2_PAIS))+" CEP: "+Transf(SA2->A2_CEP,AVSX3("A2_CEP",6)))
		HEADER_P->AVG_C04_60:=ALLTRIM(STR0001+AllTrim(cEXP_FONE)+STR0002+AllTrim(cEXP_FAX)) //"TEL.: "###" FAX: "
		HEADER_P->AVG_C19_20:=TRANSFORM(Posicione("SA2",1,xFILIAL("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_CGC"),AVSX3("A2_CGC",AV_PICTURE))
		
		// Informacoes do Cabecalho
		HEADER_P->AVG_C02_20 := exp->exp_nrinvo
		
		// TO
		HEADER_P->AVG_C07_60 := EEC->EEC_IMPODE
		HEADER_P->AVG_C08_60 := EEC->EEC_ENDIMP
		HEADER_P->AVG_C09_60 := strtran(UPPER(EEC->EEC_END2IM),"ESTRANGEIRO","")
		
		GravaItens()
		
		HEADER_P->(dbUnlock())		
		HEADER_H->(dbAppend())
		AvReplace("HEADER_P","HEADER_H")
		
		DETAIL_P->(dbSetOrder(0))
		DETAIL_P->(DbGoTop())
		Do While ! DETAIL_P->(Eof())
			DETAIL_H->(DbAppend())
			AvReplace("DETAIL_P","DETAIL_H")
			DETAIL_P->(DbSkip())
		EndDo
		
		DETAIL_P->(dbSetOrder(1))
	EndIf
	
End Sequence 
 
RestOrd(aOrd)
Select(nAlias)

Return lRet

/*
Funcao      : GravaItens
Parametros  : 
Retorno     : 
Objetivos   : 
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function GravaItens

Local aSubTotal := {}
Local nPos      := 0 
Local aIts      := {}
Local _nCount   := 0 
Local gh,nI

Private nLin   := 0
Private nPag   := 1


EE9->(dbSetOrder(3))
ZZB->(dbsetorder(3))
EXR->(dbsetorder(1))

If EXR->(dbSeek(xFilial("EXR")+EXP->EXP_PREEMB+EXP->EXP_NRINVO))
	While EXR->(!EOF()) .AND. (xFilial("EXR")+EXP->EXP_PREEMB+EXP->EXP_NRINVO) == EXR->(EXR_FILIAL+EXR_PREEMB+EXR_NRINVO)
		If EE9->(dbSeek(xFilial("EE9")+EXP->EXP_PREEMB+EXR->EXR_SEQEMB))
			aAdd(aIts,XFILIAL("ZZB")+EE9->EE9_PEDIDO+EE9->EE9_SEQUEN+EE9->EE9_COD_I)
		EndIf					
		EXR->(dbSkip())							
	EndDo
EndIf

_nMin := 9999
_nMax := 0		

For gh := 1 To Len(aIts)	
	IF ZZB->(DBSEEK(aIts[gh]))

		LDESCPROD := .T.

		CPRODUTO  := ZZB->ZZB_COD_I
		NPOS:= ASCAN(ASUBTOTAL,{|X|X[1]==ZZB->ZZB_COD_I})

		IF NPOS == 0
			AADD(ASUBTOTAL,{ZZB->ZZB_COD_I,0,0,0,0,0,""})
			NPOS:=LEN(ASUBTOTAL)
		ENDIF		
		
		//Manutencao no contador de pallets para atender a nova nomenclatura dos pallets
		//Antes era verificado (_nMin e _nMax) o pallet com numeracao maior e atribuia ele a quantidade de pallets
		//Agora foi feito um contador diretamente na base para qtde de pallets
		//Vinicius Schwartz - TI - Midori Atlantica 10/10/2012
		
		If Select("TMPZZB") > 0
			dbSelectArea("TMPZZB")
			TMPZZB->(dbCloseArea())
		Endif

		cQry:= " SELECT COUNT(*) PLT FROM "
		cQry+= " (SELECT DISTINCT ZZB_NRPCTE "
		cQry+= " FROM ZZB010 "
		cQry+= " WHERE ZZB_PEDIDO = '"+ZZB->ZZB_PEDIDO+"' AND D_E_L_E_T_ <> '*' ) PALLET "
		
		cQry:= ChangeQuery(cQry)
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry),"TMPZZB",.T.,.T.)
	
		dbSelectArea("TMPZZB")
		
		_nCount := TMPZZB->PLT
		
		//Fim cont
	
		
		WHILE ZZB->(!EOF()) .AND. (aIts[gh]) == ZZB->(ZZB_FILIAL+ZZB_PEDIDO+ZZB_USADO+ZZB_COD_I)
		
/*			if val(ZZB->ZZB_NRPCTE) > _nMax
				_nMax := val(ZZB->ZZB_NRPCTE)
			Endif
			
			if val(ZZB->ZZB_NRPCTE) < _nMin
				_nMin := val(ZZB->ZZB_NRPCTE)
			Endif		
*/
			
			ASUBTOTAL[NPOS,2] += 1
			ASUBTOTAL[NPOS,3] += ZZB->ZZB_PESOB      // TOTALIZA PESO BRUTO (GROSS)
			ASUBTOTAL[NPOS,4] += ZZB->ZZB_PESOL      // TOTALIZA PESO LIQUIDO (NET)
			ASUBTOTAL[NPOS,5] += VAL(ZZB->ZZB_SIDES) // TOTALIZA SIDES
			ASUBTOTAL[NPOS,6] += ZZB->ZZB_SQMTOT     // TOTALIZA SQMTOT
			ASUBTOTAL[NPOS,7] += ZZB->ZZB_ARTIGO

			APPENDDET()
			                        
			/*
			//ALTERADO POR LUIS HENRIQUE - DQZAFRA
        	//ALTERADO POR SOLICITACAO DA SRA. JANETE EM 05-10-11 PARA UTILIZACAO DA DESCRICAO PADRAO DO PRODUTO

			IF EE2->(DBSEEK(XFILIAL('EE2')+"3"+"*"+EEC->EEC_IDIOMA+ZZB->ZZB_COD_I)) .AND. LDESCPROD
				CMEMO := MSMM(EE2->EE2_TEXTO,AVSX3("EE2_VM_TEX")[AV_TAMANHO])
				DETAIL_P->AVG_C01_60 := MEMOLINE(CMEMO,AVSX3("EE2_VM_TEX")[AV_TAMANHO],1)
				LDESCPROD:=.F.
			ENDIF
            */
                
            IF LDESCPROD
	            DETAIL_P->AVG_C01_60 := GETADVFVAL("SB1","B1_DESC",XFILIAL("SB1")+ZZB->ZZB_COD_I,1,"")	
    			LDESCPROD := .F.
    		ENDIF	
            
			DETAIL_P->AVG_C04_20 := ""			
			DETAIL_P->AVG_N01_04 := VAL(ZZB->ZZB_NRPCTE)  
			DETAIL_P->AVG_C08_20 := ZZB->ZZB_NRPCTE // Linha incluida em 09/10/12 - Para impressao do pallet novo -> Anesio/Vinicius
			DETAIL_P->AVG_N02_15 := ZZB->ZZB_PESOB
			DETAIL_P->AVG_N03_15 := ZZB->ZZB_PESOL
			DETAIL_P->AVG_C01_20 := ALLTRIM(ZZB->ZZB_HEIGHT)+'X'+ALLTRIM(ZZB->ZZB_WIDTH)+'X'+ALLTRIM(ZZB->ZZB_LENGHT)
			DETAIL_P->AVG_C05_20 := ALLTRIM(ZZB->ZZB_SIDES)
			//DETAIL_P->AVG_C06_20 := ALLTRIM(ZZB->ZZB_LOTE) //Luiz Alterado em 30/09/2010 aumento do campo para 50 casas
            DETAIL_P->AVG_C05_60 := ALLTRIM(ZZB->ZZB_LOTE) //Luiz
//			DETAIL_P->AVG_C07_20 := TROCAVP(ALLTRIM(TRANS(ZZB->ZZB_SQMTOT,AVSX3("ZZB_SQMTOT")[AV_PICTURE])))
			DETAIL_P->AVG_N04_15 := ZZB->ZZB_SQMTOT
			
			UNLOCKDET()
			ZZB->(DBSKIP())
		ENDDO		
		APPENDDET()
		DETAIL_P->AVG_C04_20 := ALLTRIM(CPRODUTO)		

		//ALTERADO POR LUIS HENRIQUE - DQZAFRA
   		//ALTERADO POR SOLICITACAO DA SRA. JANETE EM 05-10-11 PARA OCULTAR SUB TOTAL DE PALLET		
		//DETAIL_P->AVG_N01_04 := ASUBTOTAL[NPOS,2]
		DETAIL_P->AVG_N01_04 := 0
		DETAIL_P->AVG_N02_15 := ASUBTOTAL[NPOS,3]
		DETAIL_P->AVG_N03_15 := ASUBTOTAL[NPOS,4]
		DETAIL_P->AVG_C05_20 := Alltrim(STR(ASUBTOTAL[NPOS,5]))
//		DETAIL_P->AVG_C07_20 := TROCAVP(ALLTRIM(TRANS(ASUBTOTAL[NPOS,6],AVSX3("ZZB_SQMTOT")[AV_PICTURE])))
		DETAIL_P->AVG_N04_15 := ASUBTOTAL[NPOS,6]
		UNLOCKDET()
	EndIf
Next

//nTotPcte := (_nMax - _nMin) + 1 
nTotPcte :=_nCount
nTotPesoB:=0
nTotPesoL:=0
nTotSide :=0
nTotSqm  :=0

For nI:=1 to Len(aSubTotal)     

    //nTotPcte +=aSubTotal[nI,2]
	//ALTERADO POR LUIS HENRIQUE - DQZAFRA
   	//ALTERADO POR SOLICITACAO DA SRA. JANETE EM 05-10-11 PARA TOTALIZACAO POR PALLET
	
    nTotPesoB+=aSubTotal[nI,3]
    nTotPesoL+=aSubTotal[nI,4]
    nTotSide +=aSubTotal[nI,5]
    nTotSqm  +=aSubTotal[nI,6]                                              
Next
 
HEADER_P->AVG_N01_04 := nTotPcte
HEADER_P->AVG_N02_15 := nTotPesoB
HEADER_P->AVG_N03_15 := nTotPesoL
HEADER_P->AVG_C03_20 := Alltrim(STR(nTotSide))
HEADER_P->AVG_N04_15 := nTotSqm

Return

/*
Funcao      : AppendDet
Parametros  : 
Retorno     : 
Objetivos   : Adiciona registros no arquivo de detalhes
Revisao     : 
Obs.        :
*/
Static Function AppendDet()

Begin Sequence
   nLin := nLin+1
   IF nLin > NUMLINPAG
      nLin := 1
      nPag := nPag+1
   ENDIF
   DETAIL_P->(dbAppend())
   DETAIL_P->AVG_FILIAL := xFilial("SY0")
   DETAIL_P->AVG_SEQREL := cSEQREL
   DETAIL_P->AVG_CHAVE  := mv_par01 //nr. do processo
   DETAIL_P->AVG_CONT   := STRZERO(nPag,6,0)
End Sequence

Return NIL

/*
Funcao      : UnlockDet
Parametros  : 
Retorno     : 
Objetivos   : Desaloca registros no arquivo de detalhes
Autor       : Cristiano A. Ferreira 
Data/Hora   : 05/05/2000
Revisao     : 
Obs.        :
*/
Static Function UnlockDet()

Begin Sequence
   DETAIL_P->(dbUnlock())
End Sequence

Return NIL

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Robson Sanchez
Data/Hora   : 
Revisao     : 
Obs.        :
*/
Static Function TelaGets()


VERPERGSX1()
If !Pergunte(cPerg,.T. )
   Return .f.
Endif

Return .t.        

//+-----------------------------------------------------------------------------------//
//|Funcao....: VERPERGSX1()
//|Descricao.: Inclusão de Parametros no arquivo SX1
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static FUNCTION VERPERGSX1()
*-----------------------------------------*

Local nX,nY,j:= 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aRegistro := {}

aRegistro:= {}
            
AADD(aRegistro,{cPerg,     "01"      ,"Invoice No:  "    ,"mv_ch1"    ,"C"      ,20          ,0           ,0          ,"G"     ,"U_ListData('01')","mv_par01","ZZC"})
aAdd(aRegistro,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT"       ,"X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID"        ,"X1_VAR01","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)
For ny:=1 to Len(aRegistro)-1
	If !dbSeek(aRegistro[ny,1]+aRegistro[ny,2])
		SX1->(RecLock("SX1",.T.))
		For j:=1 to Len(aRegistro[ny])
			FieldPut(FieldPos(aRegistro[Len(aRegistro)][j]),aRegistro[ny,j])
		Next j
		SX1->(MsUnlock())
	EndIf
Next ny
RestArea(aAreaSX1)
RestArea(aAreaAnt)

Return


//+-----------------------------------------------------------------------------------//
//|Funcao....: U_ShipData()
//|Descricao.: Valida datas informadas nas perguntas
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function ListData(cMV)
*-----------------------------------------*
Local cRet     := .T.
Local cTitulo  := "Inconsistencia de Dados"

Do Case
	Case cMV == '01'    
         EXP->(dbSetOrder(2))
         If ! EXP->(dbSeek(xFilial("EXP")+MV_PAR01))
           Aviso( cTitulo, "Invoice nao Encontrado com este codigo",{"Ok"} )
           cRet:=.f.
        Endif
End Case
Return (cRet)


Static Function TrocaVP(cValor)

Return StrTran(cValor,',','.')
//+-----------------------------------------------------------------------------------//
//|FIM DO PROGRAMA EECSHIP.PRW                                                  
//+-----------------------------------------------------------------------------------//
