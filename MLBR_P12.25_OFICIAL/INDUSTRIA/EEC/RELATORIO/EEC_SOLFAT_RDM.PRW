#INCLUDE "AvPrint.ch"  
#INCLUDE "Font.ch"  
#INCLUDE "rwmake.ch"       
#INCLUDE "topconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

#define NUMLINPAG 48



//Static aMarcados := {}, nMarcados  
//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: EECSOLFAT
//|Autor.....: Luis Henrique de Oliveira ( luishenrique@dqzafra.com.br )
//|Data......: 10/12/10
//|Uso.......: SIGAEEC   
//|Versao....: Protheus - 10.1    
//|Descricao.: Impressao de Solicitacao de Faturamento
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function EECSOLFAT()        
*-----------------------------------------*

SetPrvt("CPOINT1P,LPOINT1P,CPOINT2P,LPOINT2P,CMARCA,LINVERTE")
//SetPrvt("APOS,AROTINA,BFUNCAO,NCONT")
SetPrvt("APOS,BFUNCAO,NCONT")
SetPrvt("NTOTAL,NTOTALGERAL,NIDIOMA,CCADASTRO,NPAGINA,ODLGIDIOMA")
SetPrvt("NVOLTA,ORADIO1,LEND,OPRINT>,LINHA,PTIPO")
SetPrvt("CINDEX,CCOND,NINDEX,NOLDAREA,OFONT1")
SetPrvt("OFONT2,OFONT3,OFONT4,OFONT5,OFONT6,OFONT7")
SetPrvt("OFONT8,OFONT9,OPRN,AFONTES,CCLICOMP,ACAMPOS")
SetPrvt("CNOMARQ,AHEADER,LCRIAWORK,CPICTQTDE,CPICT1TOTAL")
SetPrvt("CPICT2TOTAL,CQUERY,OFONT10,OFNT,C2ENDSM0,C2ENDSA2")
SetPrvt("CCOMMISSION,C2ENDSYT,CTERMS,CDESTINAT,CREPR,CCGC")
SetPrvt("CNR,CPOINTS,I,N1,N2,NNUMERO")
SetPrvt("BACUMULA,BWHILE,LPULALINHA,NTAM,CDESCRITEM,CREMARKS")
SetPrvt("XLINHA,Per01,Per02,Per03,Per04,Per05,Per06,Per07,Per08","cSEQREL")

Private cPerg     := Avkey("EECLIST","X1_GRUPO")

Private aButtons  := {}
Private csim      := ""
Private _PictPo   := "@!"

Private cMensagem := ""

lInverte    := .F.
aPos        := {8,4,11,74}
nCont       := 0 
nTotal      := 0  
nTotalGeral := 0 

PRIVATE nLin :=0,nPag := 1

EXP->(dbsetorder(2))                            
EEB->(dbsetorder(1))
EEC->(dbsetorder(1))
        
EEB->(dbseek(xfilial("EEB")+EEC->EEC_PEDREF))

nRecEEC:=EEC->(RECNO())

//E_ARQCRW(.T.,.T.,.T.)                   

Begin Sequence
	
	// dar get do titulo e das mensagens ...
	IF ! TelaGets()
		lRet := .f.
		Break
	Endif
	
	cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
	CONFIRMSX8()
	
	// adicionar registro no HEADER_P
	HEADER_P->(DBAPPEND())
	HEADER_P->AVG_FILIAL:=xFilial("SY0")
	HEADER_P->AVG_SEQREL:=cSEQREL
	HEADER_P->AVG_CHAVE :=EEC->EEC_PREEMB
	
	SA2->(dbSetOrder(1))
	IF !EMPTY(EEC->EEC_EXPORT) .AND. SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
		cExp_Cod     := EEC->EEC_EXPORT+EEC->EEC_EXLOJA
		cEXP_NOME    := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
		cEXP_CONTATO := EECCONTATO("X",EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1)  //nome do contato seq 1
		cEXP_FONE    := EECCONTATO("X",EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",4)  //fone do contato seq 1
		cEXP_FAX     := EECCONTATO("X",EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",7)  //fax do contato seq 1
		cEXP_CARGO   := EECCONTATO("X",EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",2)  //CARGO
		M->cSEEKEXF  :=EEC->EEC_EXPORT
		M->cSEEKLOJA :=EEC->EEC_EXLOJA
	ELSE
		SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA))
		cExp_Cod     := EEC->EEC_FORN+EEC->EEC_FOLOJA
		cEXP_NOME    := SA2->A2_NOME
		cEXP_CONTATO := EECCONTATO("X",EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
		cEXP_FONE    := EECCONTATO("X",EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
		cEXP_FAX     := EECCONTATO("X",EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
		cEXP_CARGO   := EECCONTATO("X",EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",2,EEC->EEC_RESPON)  //CARGO
		M->cSEEKEXF  :=EEC->EEC_FORN
		M->cSEEKLOJA :=EEC->EEC_FOLOJA
	ENDIF
	
	// Dados do Exportador/Fornecedor
	HEADER_P->AVG_C01_60:=ALLTRIM(cEXP_NOME) // TITULO 1
	HEADER_P->AVG_C02_60:=ALLTRIM(SA2->A2_END)
	HEADER_P->AVG_C03_60:=ALLTRIM(SA2->A2_EST+" "+AllTrim(BuscaPais(SA2->A2_PAIS))+" CEP: "+Transf(SA2->A2_CEP,AVSX3("A2_CEP",6)))
	HEADER_P->AVG_C01_30:=ALLTRIM('FONE: '+AllTrim(cEXP_FONE)+'FAX: '+AllTrim(cEXP_FAX)) //"TEL.: "###" FAX: "
	HEADER_P->AVG_C02_30:=TRANSFORM(Posicione("SA2",1,xFILIAL("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_CGC"),AVSX3("A2_CGC",6))
	                
	dbSelectArea("EEC")
	dbSetOrder(1)
	dbSeek(xfilial("EE7")+EEC->EEC_PEDREF)
	
	HEADER_P->AVG_C02_10 := EE7->EE7_PEDFAT
	//HEADER_P->AVG_C02_10 := GETADVFVAL("EE7","E7_PEDFAT",XFILIAL("EE7")+EEC->EEC_PEDREF,1,"")	    --DESATIVADO POR WILLER 16/01
	
	// IMPORTADOR
	SA1->(DBSEEK(xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))
	cIMP_NOME := IF(!EMPTY(EEC->EEC_IMPODE),EEC->EEC_IMPODE,SA1->A1_NOME)
	
	cNOPADES := ""
	IF !EMPTY(EEC->EEC_ORIGEM) .AND. !EMPTY(EEC->EEC_DEST)
		cPAISDES := Posicione("SYR",1,xFilial("SYR")+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA,"YR_PAIS_DE")
		cDESTINO := Posicione("SYR",1,xFilial("SYR")+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA,"YR_CID_DES")
		SYA->(DBSEEK(xFilial("SYA")+cPAISDES))
		cNOPADES := Posicione("SYA",1,xFilial("SYA")+cPAISDES,"YA_DESCR")
	ELSE
		cDESTINO := SPACE(AVSX3("Y9_DESCR",3))
	ENDIF
	
	//TRANSPORTE
	nNomeTrans := Iif(!Empty(EEC->EEC_XTRANS),Alltrim(Posicione("SA4",1,xFilial("SA4")+EEC->EEC_XTRANS,"A4_NOME")),"")
	HEADER_P->AVG_C03_30 := nNomeTrans
	HEADER_P->AVG_C01_10 := EEC->EEC_XPLACA
	
	// PAIS DESTINO
	cPAISDT := Posicione("SYA",1,xFilial("SYA")+EEC->EEC_PAISDT,"YA_DESCR")
	
	RepFile("H","04","60",cImp_Nome)   // "H" ->HEADER_P, AVG_X04_60, Valor
	
	// Data Processo
	RepFile("H","05","10",DTOC(EEC->EEC_DTPROC))
	
	// Peso Liquido
	RepFile("H","05","20",TRANSF(EEC->EEC_PESLIQ,AVSX3("EEC_PESLIQ",6)))
	
	// Peso Bruto
	RepFile("H","06","20",TRANSF(EEC->EEC_PESBRU,AVSX3("EEC_PESBRU",6)))
	
	// Pais de Destino
	RepFile("H","07","30",cPaisDt)
	
	// Invoice
	RepFile("H","01","20",mv_par01)
	
	// Via de Transporte
	RepFile("H","06","30",Posicione("SYQ",1,xFilial("SYQ")+EEC->EEC_VIA,"YQ_DESCR"))
	
	// Volume/Especie
	RepFile("H","09","60",Alltrim(EEC->EEC_EMBAFI)+'/'+Alltrim(EEC->EEC_PACKAG))
	
	
	// Condicao Pagamento
	
	cEsqPagto:=E_FIELD2(EEC->EEC_CONDPA+STR(EEC->EEC_DIASPA,3),"SY6",1,,"SY6->Y6_DESC_P",60)
	RepFile("H","07","60",cEsqPagto)
	
	// MOEDA
	cMOEDA := EEC->EEC_MOEDA+" "+Posicione("SYF",1,xFilial("SYF")+EEC->EEC_MOEDA,"YF_DESC_SI")//+"  "+ Posicione("SYF",1,xFilial("SYF")+EEC->EEC_MOEDA,"YF_DESC_SI")
	RepFile("H","08","60",cMoeda)
	RepFile("H","09","10",EEC->EEC_MOEDA)
	
	// Valor Frete
	nFrete  :=EEC->EEC_FRPREV
	cVlFrete:=TRANS(nFrete,AVSX3("EEC_FRPREV",6))
	RepFile("H","02","20",cVlFrete)
	
	// Taxa Conversao
	nTaxa:=IF(EEC->EEC_MOEDA <> "R$ ",BuscaTaxa(EEC->EEC_MOEDA,dDataBase),1)
	RepFile("H","03","20",TRANS(nTaxa,AVSX3("YE_TX_COMP",6)))
	
	// Comissao
	nComissao:=EEB->EEB_TOTCOM
	RepFile("H","04","20",TRANS(nComissao,AVSX3("EEC_FRPREV",6)))

	cNcm:=""
	ee9->(dbsetorder(4))
	If EE9->(dbseek(xFilial('EE9')+EEC->EEC_PREEMB))
		cNcm:=EE9->EE9_POSIPI
		// Ncm
		RepFile("H","10","60","NCM: "+TRANSF(EE9->EE9_POSIPI,AVSX3("EE9_POSIPI",6)) + " - "+Posicione("SYD",1,xFilial("SYD")+EE9->EE9_POSIPI,"YD_DESC_P"))
		// Ato Concessorio
		RepFile("H","11","60",'Ato Concessorio: '+TRANSF(EE9->EE9_ATOCON,AVSX3("EE9_ATOCON",6)))
		// Unidade Medida
		RepFile("H","08","10",EE9->EE9_UNIDAD)
	Endif
	
	GravaItens()
	
	HEADER_P->(dbUnlock())
	
	
End Sequence


//AvgCrw32("SOLFAT.RPT","SOLICITACAO FATURAMENTO" + AllTrim(EEC->EEC_PREEMB),cSEQREL,,,.F.)


EEC->(dbgoto(nRecEEC))
Return  


/*
Funcao      : GravaItens
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function GravaItens

Local cItem    := "000"
Local cUnidade := ""
//Local bCond    := IF(lNcm,{|| EE9->EE9_POSIPI == cNcm },{|| .t. })
//Local cNcm     := "",lDescUnid:=.f., i:=0, gi_W:=0
Local cFilEE9:=xFilial('EE9')
Local nPos     :=0
Local mPri:=.t.

Local nTotEmb  :=0
Local nTotQtde :=0
Local nTotPeso :=0
Local nTotFob  :=0

PRIVATE nLin :=0,nPag := 1

ee9->(dbseek(cFilEE9+EEC->EEC_PREEMB))

nFOB :=0
nFOBR:=0
                  
While ! ee9->(eof()) .and. ee9->ee9_filial == cFilee9 .and. ee9->ee9_preemb == eec->eec_preemb
  
  /*
  If !Empty(cNcm) .and. cNcm <> ee9->ee9_posipi
     exit
  Endif
  */
  nPreco   :=ee9->ee9_precoi
  nPrecoR  :=nPreco*nTaxa
  nQtde    :=ee9->ee9_sldini
  nTotItem :=nPreco * nQtde
  nTotItemR:=nTotItem * nTaxa
  
  cMemo    :=MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))
  cProduto :=MemoLine(cMemo,AVSX3("EE9_VM_DES",3),1)
  cQtde    :=TRANS(nQtde,AVSX3("EE9_SLDINI",6))   
  cPreco   :=TRANS(nPreco,AVSX3("EE9_PRECOI",6))   
  cTotItem :=TRANS(nTotItem,AVSX3("EEC_TOTPED",6))

  cPrecoR  :=TRANS(nPrecoR,AVSX3("EE9_PRECOI",6))   
  cTotItemR:=TRANS(nTotItemR,AVSX3("EEC_TOTPED",6))
    
  nFOB += nTotItem
  nFOBR+= nTotItemR  
  
  AppendDet()  
  // Produto
  RepFile("D","01","100",cProduto)   
  //Quantidade
  RepFile("D","02","20",cQtde) 
  //Valor Unitario
  RepFile("D","03","20",cPreco) 
  //Valor Unitario Total
  RepFile("D","04","20",cTotItem)
  
  //Valor Unitario R$
  RepFile("D","05","20",cPrecoR)
  //Valor Unitario R$ Total
  RepFile("D","06","20",cTotItemR)   
   
  UnlockDet()
      
  ee9->(dbskip())
End   

nFreteR := nFrete *nTaxa
nSubTot := nFrete+nFob
nSubTotR:= nSubTot * nTaxa
nComisR := nComissao * nTaxa 
nTotal  := nSubTot+nComissao
nTotalR := nSubTotR-nComisR


RepFile("H","12","60",EEC->EEC_MOEDA+' '+Alltrim(TRANS(nTaxa,AVSX3("YE_TX_COMP",6))))   // TAXA

//correcao em 11-01-11  - Luis Henrique ( igualar ao Comercial INVOICE )
//nFreteR 	:= EEC->EEC_FRPREV
nFob := (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
nSubTot := nFob + nFrete
nTotal  := nSubTot-nComissao
/////////////////////////////////////////

RepFile("H","15","60",TRANS(nFOBR,AVSX3("EEC_TOTPED",6)),"N")   // FOB R$
RepFile("H","18","60",TRANS(nFreteR,AVSX3("EEC_TOTPED",6)),"N")   // FRETE R$
RepFile("H","21","60",TRANS(nSubTotR,AVSX3("EEC_TOTPED",6)),"N")   // SUB-TOTAL R$
RepFile("H","24","60",TRANS(nComisR,AVSX3("EEC_TOTPED",6)),"N")   // COMISSAO R$
RepFile("H","27","60",TRANS(nTotalR,AVSX3("EEC_TOTPED",6)),"N")   // TOTAL R$

RepFile("H","14","60",TRANS(nFOB,AVSX3("EEC_TOTPED",6)),"N")    // FOB MOEDA
RepFile("H","17","60",TRANS(nFRETE,AVSX3("EEC_TOTPED",6)),"N")    // FRETE MOEDA
RepFile("H","20","60",TRANS(nSubTot,AVSX3("EEC_TOTPED",6)),"N")    // SUB-TOTAL MOEDA
RepFile("H","23","60",TRANS(nComissao,AVSX3("EEC_TOTPED",6)),"N")    // COMISSAO MOEDA
RepFile("H","26","60",TRANS(nTotal,AVSX3("EEC_TOTPED",6)),"N")    // TOTAL MOEDA

If Alltrim(EEC->EEC_MOEDA) <> "US$"

	nParidade:= BuscaTaxa("US$",dDataBase)/BuscaTaxa(EEC->EEC_MOEDA,dDataBase)
	
	RepFile("H","13","60","US$"+' '+Alltrim(TRANS(BuscaTaxa("US$",dDataBase),AVSX3("YE_TX_COMP",6))))   // TAXA
	
	RepFile("H","16","60",TRANS(nFOB/nParidade,AVSX3("EEC_TOTPED",6)),"N")    // FOB MOEDA
	RepFile("H","19","60",TRANS(nFRETE/nParidade,AVSX3("EEC_TOTPED",6)),"N")    // FRETE MOEDA
	RepFile("H","22","60",TRANS(nSubTot/nParidade,AVSX3("EEC_TOTPED",6)),"N")    // SUB-TOTAL MOEDA
	RepFile("H","25","60",TRANS(nComissao/nParidade,AVSX3("EEC_TOTPED",6)),"N")    // COMISSAO MOEDA
	RepFile("H","28","60",TRANS(nTotal/nParidade,AVSX3("EEC_TOTPED",6)),"N")    // TOTAL MOEDA
	
	RepFile("H","29","60","TX DOLLAR (US$) // "+Alltrim(EEC->EEC_MOEDA)+': '+Alltrim(TRANS(nParidade,AVSX3("YE_TX_COMP",6))))    // PARIDADE
		
Endif

Return .t.

//+-----------------------------------------------------------------------------------//
//|Funcao....: DATA_MES(<x>)
//|Descricao.: Função para traz a a data e o mes.
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function DATA_MES(x) 
*-----------------------------------------*

Local lRet := ""
  
lRet := SUBSTR(DTOC(x),1,2)+" "+IIF(nIdioma == INGLES,SUBSTR(CMONTH(x),1,3),SUBSTR(Nome_Mes(MONTH(x)),1,3))+" "+LEFT(DTOS(x),4)

Return(lRet)



/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function TelaGets
   
Local lRet := .f.

  
DEFINE FONT oFont NAME "Courier New" SIZE 0,15

Begin Sequence

   VERPERGSX1()
    
   IF ! Pergunte(cPerg,.T.)
      Break
   Endif
                  
   lRet:=.t.
    /*
	EEC->(dbSetOrder(1))
   If !EEC->(dbseek(xFilial('EEC')+exp->exp_preemb))
   		lRet:=.f.
   		MsgInfo("Processo não encontrado para invoice")
   EndIf
   */
End Sequence

Return lRet


//+-----------------------------------------------------------------------------------//
//|Funcao....: VERPERGSX1()
//|Descricao.: Inclusão de Parametros no arquivo SX1
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static FUNCTION VERPERGSX1()
*-----------------------------------------*

Local nX,nY,j := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aRegistro := {}

aRegistro:= {}
            
AADD(aRegistro,{cPerg,     "01"      ,"Invoice No:  "    ,"mv_ch1"    ,"C"      ,20          ,0           ,0          ,"G"     ,"U_ListData('03')","mv_par01","ZZC"})
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



Static Function Repfile(cSigla,cPar1,cPar2,cValor,cTipo)

Local cFile:="HEADER_P"

cCampo:="AVG_"+VALTYPE(cValor)+cPar1+If(Len(cPar2)<=2,"_","")+cPar2

If Valtype(cValor) == "C"
   cValor:=Alltrim(cValor)
Endif

cTipo:=If(cTipo==NIL,"C",cTipo)

If cTipo == "N" .and. Val(cValor) == 0
   Return .t.
Endif

If cSigla == "D"   // Grava Detail_P
   cFile:="DETAIL_P"
Endif

(cFile)->(FIELDPUT(FIELDPOS(cCampo),cValor))

Return .t.


/*
Funcao      : AppendDet
Parametros  : 
Retorno     : 
Objetivos   : Adiciona registros no arquivo de detalhes
Autor       : Cristiano A. Ferreira 
Data/Hora   : 05/05/2000
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
   DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB //nr. do processo
   DETAIL_P->AVG_CONT   := STRZERO(nPag,6,0)
End Sequence


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

