#INCLUDE "AvPrint.ch"
#INCLUDE "Font.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "PROTHEUS.CH" 

#define NUMLINPAG  23
#DEFINE XENTER     CHR(13)+CHR(10)

//Static aMarcados := {}, nMarcados
//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: SOLRE
//|Autor.....: Robson Sanchez Dias - robson@dqzafra.com.br
//|Data......: 10/07/09
//|Uso.......: SIGAEIC
//|Versao....: Protheus - 10.1
//|Descricao.: Impressão do PO em Crystal
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function EECSOLRE()
*-----------------------------------------*
Local W

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

cMensagem := "- Favor observar a quantidade de anexo acima solicitada para emissão da D.U.E. "+XENTER
cMensagem += "- Ao emitir a D.U.E. basear-se nos dados da invoice e não somente aos dados da solicitação."+XENTER
cMensagem += ""+XENTER
                                                                                                      

//cMarca      := GetMark()
//aMarcados   := {}
lInverte    := .F.
aPos        := {8,4,11,74}
bFuncao     := {|| PO150Impr() }
nCont       := 0
nTotal      := 0
nTotalGeral := 0

PRIVATE nLin :=0,nPag := 1

EXP->(dbsetorder(1))
EXP->(dbSeek(xfilial("EXP")+EEC->EEC_PREEMB))

EEB->(dbsetorder(1))
EEC->(dbsetorder(1))

EEB->(dbseek(xfilial("EEB")+EEC->EEC_PEDREF))

nRecEEC:=EEC->(RECNO())

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
HEADER_P->AVG_CHAVE :=mv_par01 //nr. da Invoice


SA2->(dbSetOrder(1))
IF !EMPTY(EEC->EEC_EXPORT) .AND. ;
	SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
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
HEADER_P->AVG_C03_60:=ALLTRIM(SA2->A2_EST+" - "+AllTrim(BuscaPais(SA2->A2_PAIS))+" - CEP"+Transf(SA2->A2_CEP,AVSX3("A2_CEP",6)))
HEADER_P->AVG_C01_30:=ALLTRIM('Tel - '+AllTrim(cEXP_FONE)+'/Fax - '+AllTrim(cEXP_FAX)) //"TEL.: "###" FAX: "
HEADER_P->AVG_C02_30:=TRANSFORM(Posicione("SA2",1,xFILIAL("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_CGC"),AVSX3("A2_CGC",6))


// IMPORTADOR
SA1->(DBSEEK(xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))
cIMP_NOME := IF(!EMPTY(EEC->EEC_IMPODE),EEC->EEC_IMPODE,SA1->A1_NOME)
cIMP_END1 := IF(!EMPTY(EEC->EEC_ENDIMP),EEC->EEC_ENDIMP,SA1->A1_END+" "+SA1->A1_BAIRRO)
cIMP_END2 := IF(!EMPTY(EEC->EEC_END2IM),EEC->EEC_END2IM,SA1->A1_MUN+" "+SA1->A1_EST)

// EMBARQUE/DESTINO
IF !EMPTY(EEC->EEC_ORIGEM)
	cEMBARQUE := Posicione("SY9",2,xFilial("SY9")+EEC->EEC_ORIGEM,"Y9_DESCR")
ELSE
	cEMBARQUE := SPACE(AVSX3("Y9_DESCR",3))
EndIf

cNOPADES := ""
IF !EMPTY(EEC->EEC_ORIGEM) .AND. !EMPTY(EEC->EEC_DEST)
	cPAISDES := Posicione("SYR",1,xFilial("SYR")+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA,"YR_PAIS_DE")
	cDESTINO := Posicione("SYR",1,xFilial("SYR")+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA,"YR_CID_DES")
	SYA->(DBSEEK(xFilial("SYA")+cPAISDES))
	cNOPADES := Posicione("SYA",1,xFilial("SYA")+cPAISDES,"YA_DESCR")
ELSE
	cDESTINO := SPACE(AVSX3("Y9_DESCR",3))
ENDIF

// PAIS DESTINO
cPAISDT := Posicione("SYA",1,xFilial("SYA")+EEC->EEC_PAISDT,"YA_DESCR")

RepFile("H","04","60",cImp_Nome)   // "H" ->HEADER_P, AVG_X04_60, Valor
RepFile("H","01","100",cImp_End1)   // "H" ->HEADER_P, AVG_X04_60, Valor
RepFile("H","02","100",Alltrim(cImp_End2)+'/'+Alltrim(cDestino)+'/'+Alltrim(cNoPaDes))

// ENQUADRAMENTO
cENQ	:= EEC->(ALLTRIM(EEC_ENQCOD)+"  "+ALLTRIM(EEC_ENQCO1)+"  "+ALLTRIM(EEC_ENQCO2)+"  "+ALLTRIM(EEC_ENQCO3)+"  "+ALLTRIM(EEC_ENQCO4)+"  "+ALLTRIM(EEC_ENQCO5)+"  ")
RepFile("H","06","30",cEnq)

// Data da Invoice
RepFile("H","05","10",DTOC(EXP->EXP_DTINVO))

// Urf Despacho / Embarque
RepFile("H","01","20",Alltrim(EEC->EEC_URFDSP)+'/'+Alltrim(EEC->EEC_URFENT))

// Pais de Destino
RepFile("H","07","30",cPaisDt)

// Instr. Negociacao
RepFile("H","01","10",EEC->EEC_INSCOD)

// Cond. Venda
RepFile("H","06","10",EEC->EEC_INCOTE)

// Esquema Pagamento
cEsqPagto:=E_FIELD2(EEC->EEC_CONDPA+STR(EEC->EEC_DIASPA,3),"SY6",1,,"SY6->Y6_DESC_P",60)
RepFile("H","07","60",cEsqPagto)


// MOEDA
cMOEDA := EEC->EEC_MOEDA+" "+Posicione("SYF",1,xFilial("SYF")+EEC->EEC_MOEDA,"YF_DESC_SI")//+"  "+ Posicione("SYF",1,xFilial("SYF")+EEC->EEC_MOEDA,"YF_DESC_SI")
RepFile("H","08","60",cMoeda)

EE9->(dbOrderNickName("EE9_XUNIT"))
If EE9->(dbseek(xFilial('EE9')+EEC->EEC_PREEMB))
	// Ato Concessorio
	RepFile("H","02","20",TRANSF(EE9->EE9_ATOCON,AVSX3("EE9_ATOCON",6)))
	
	// Unidade Medida
	RepFile("H","08","10",EE9->EE9_UNIDAD)
Endif

// Comissao no Registro de Embarque
//_nComissao := TRANS(EEB->EEB_VALCOM,AVSX3("EE9_SLDINI",AV_PICTURE))
_nComissao := TRANS(EEB->EEB_TOTCOM,AVSX3("EE9_SLDINI",6))

RepFile("H","03","10",_nComissao)

// Tipo Embalagem
RepFile("H","03","20",EEC->EEC_EMBAFI)

// Marcacao
RepFile("H","03","100",MSMM(EEC->EEC_CODMAR,20))

// Modalidade de Pagamento
cModPag := E_FIELD("EE7_MPGEXP","EEF_DESC")
RepFile("H","03","30",Alltrim(cModPag))
//RepFile("H","04","100",cMensagem)

cLinha:=""

cMensagem:=RTRIM(STRTRAN(cMensagem,CHR(13)+CHR(10)," "))
//nCol:=AVSX3("EEC_OBS",AV_TAMANHO)
nCol:=80 // Diego
nTotLin:=MLCOUNT(cMensagem,nCol)

nTotLin:=If(nTotLin>15,15,nTotLin)

FOR W := 1 TO nTotLin
	If !EMPTY(MEMOLINE(cMensagem,nCol,W))
		//If W == nTotLin
		//	cLinha:=MEMOLINE(cMensagem,nCol,W)
		//Else
			cLinha:=AV_Justifica(MEMOLINE(cMensagem,nCol,W))+CHR(13)+CHR(10)
		//EndIf
		RepFile("H",STRZERO(W+3,2),"150",Alltrim(cLinha))
	EndIf
NEXT


//correcao em 11-01-11  - Luis Henrique ( igualar ao Comercial INVOICE )
nTaxa:=IF(EEC->EEC_MOEDA <> "R$ ",BuscaTaxa(EEC->EEC_MOEDA,dDataBase),1)
nFreteR  :=EEC->EEC_FRPREV
//nFreteR := nFrete * nTaxa
nFobValue 	:= (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
nSubTotR 	:= nFobValue + nFreteR
/////////////////////////////////////////

GravaItens()

//   AppendDet()

//   UnlockDet()


HEADER_P->(dbUnlock())


End Sequence


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
//Local bCond  := IF(lNcm,{|| EE9->EE9_POSIPI == cNcm },{|| .t. })
Local cNcm     := "",lDescUnid:=.f., i:=0, gi_W:=0
Local nPos     :=0
Local mPri     :=.t.

Local nTotEmb  :=0
Local nTotQtde :=0
Local nTotPeso :=0
Local nTotFob  :=0
Local nTotCif  :=0
Local _nPos 	:= 0
Local _aNcm	:= {}
Local _nCod := 0
Local _nx
Local _aUnit	:= {}


PRIVATE nLin :=0,nPag := 1

If EE9->(dbseek(xFilial("EE9")+EEC->EEC_PREEMB))
	
	While !ee9->(eof()) .and. ee9->(ee9_filial+ee9_preemb) == (xFilial("EE9")+eec->eec_preemb)
		
		cItem    :=Soma1(cItem)
		
		//TOTALIZA NCM
		_nPos := 0
		_nPos := ascan(_aNcm,{|x| EE9->EE9_POSIPI == x[1]})
		
		if _nPos == 0
			
			_nCod :=_nCod + 1 
			aadd(_aNcm,{EE9->EE9_POSIPI,alltrim(str(_nCod)) })
			_nPos := len(_aNcm)
			
		Endif
		
		
		//TOTALIZA POR UNIDADE
		_nPos2 := 0
		_nPos2 := ascan(_aUnit,{|x| EE9->EE9_UNIDAD == x[1]})
		if _nPos2 == 0
			
			_nCod := _nCod + 1
			aadd(_aUnit,{EE9->EE9_UNIDAD,EE9->EE9_SLDINI })
			
		Else
			
			_aUnit[_nPos2][2]+= EE9->EE9_SLDINI
			
		Endif
		
		
		//cNcm     :=Alltrim(TRANS(EE9->EE9_POSIPI,AVSX3("EE9_POSIPI",6)))+'/'+Alltrim(TRANS(EE9->EE9_NLNCCA,AVSX3("EE9_NLNCCA",6)))+'/'+Alltrim(TRANS(EE9->EE9_NALSH,AVSX3("EE9_NALSH",6)))
		cNcm := _aNcm[_nPos][2]
		        
		dbSelectArea("SYP")
		cMemo    :=MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))
		cProduto :=MemoLine(cMemo,AVSX3("EE9_VM_DES",3),1)
		cQtde    :=TRANS(ee9->ee9_sldini,AVSX3("EE9_SLDINI",6))
		cUnit	 := EE9->EE9_UNIDAD
		cPesoLiq :=TRANS(EE9->EE9_PSLQTO,AVSX3("EE9_PSLQTO",6))
		cPrcFob  :=Transform(ee9->ee9_sldini*ee9->ee9_precoi,AVSX3("EEC_TOTPED",6))
		cPrcCif  :=Transform(ee9->ee9_sldini*ee9->ee9_preco,AVSX3("EEC_TOTPED",6))
		
		cSql := " SELECT ISNULL(COUNT(*),0) AS QTDE FROM "+RetSqlName("ZZB")
		cSql += " WHERE ZZB_USADO = '"+EE9->EE9_SEQUEN+"' AND ZZB_COD_I = '"+EE9->EE9_COD_I+"' "
		cSql += " 	AND ZZB_PEDIDO = '"+EE9->EE9_PEDIDO+"' "
		Iif(Select("TMPXX") # 0,TMPXX->(dbCloseArea()),.T.)
		TcQuery cSql New Alias "TMPXX"
		dbSelectArea("TMPXX")
		cEmb     := Transform(TMPXX->QTDE,"@E 999")
		
		nTotQtde += ee9->ee9_sldini
		nTotPeso += ee9->ee9_pslqun
		nTotFob  += ee9->ee9_sldini*ee9->ee9_precoi
		nTotCif  += ee9->ee9_sldini*ee9->ee9_preco
		nTotEmb  += TMPXX->QTDE
		
		TMPXX->(dbCloseArea())
		
		AppendDet()
		// Anexo
		RepFile("D","03","10",cItem)
		// NCM
		RepFile("D","02","10",cNcm)
		// Produto
		RepFile("D","01","100",cProduto)
		//Quantidade
		RepFile("D","02","20",cQtde)
		//Unidade
		RepFile("D","04","10",cUnit)
		//Embalagem
		RepFile("D","01","10",cEmb)
		//Peso Liquido
		RepFile("D","03","20",cPesoLiq)
		//Valor Fob
		RepFile("D","04","20",cPrcFob)
		//Valor CIF
		RepFile("D","05","20",cPrcCif)
		
		DETAIL_P->AVG_LINHA	:='A'
		UnlockDet()
		
		ee9->(dbskip())
	EndDo
Endif


// totalizadores
AppendDet()
DETAIL_P->AVG_LINHA	:='A'
UnlockDet()

AppendDet()
DETAIL_P->AVG_LINHA	:='A'

DETAIL_P->AVG_C01100:=SPACE(35)+"TOTAL "
//Quantidade
RepFile("D","02","20",TRANS(_aUnit[1][2],AVSX3("EE9_SLDINI",6))   )
//Unidade
RepFile("D","04","10",_aUnit[1][1])

//Embalagem
RepFile("D","01","10",STR(nTotEmb,AVSX3("EE9_EMB",3)))
//Peso Liquido
RepFile("D","03","20",TRANS(nTotPeso,AVSX3("EE9_PSLQUN",6))   )
//Valor Fob
//RepFile("D","04","20",Trans(nTotFob,AVSX3("EEC_TOTPED",AV_PICTURE)))
RepFile("D","04","20",Trans(nFobValue,AVSX3("EEC_TOTPED",6)))
//Valor Cif
//RepFile("D","05","20",Trans(nTotCif,AVSX3("EEC_TOTPED",AV_PICTURE)))
RepFile("D","05","20",Trans(nSubTotR,AVSX3("EEC_TOTPED",6)))

UnlockDet()

For _nx := 2 to len(_aUnit)
	AppendDet()
	DETAIL_P->AVG_LINHA	:='A'
	
	//Quantidade
	RepFile("D","02","20",TRANS(_aUnit[_nx][2],AVSX3("EE9_SLDINI",6))   )
	//Unidade
	RepFile("D","04","10",_aUnit[_nx][1])
	
	UnlockDet()
Next


AppendDet()
DETAIL_P->AVG_LINHA	:='Z'
UnlockDet()


AppendDet()
DETAIL_P->AVG_LINHA	:='Z'
RepFile("D","05","10","CODIGO")
RepFile("D","01","20","     NCM      ")
RepFile("D","06","20","    NALADI    ")
RepFile("D","07","20","   NBM / SH   ")
RepFile("D","01","60","   DESCRICAO    ")
UnlockDet()


For _nx := 1 to len(_aNcm)
	
	AppendDet()
	DETAIL_P->AVG_LINHA	:='Z'
	RepFile("D","05","10",_aNcm[_nx][2])
	RepFile("D","01","20",_aNcm[_nx][1])
	RepFile("D","01","60",Posicione("SYD",1,xFilial("SYD")+_aNcm[_nx][1],"YD_DESC_P"))
	UnlockDet()
	                     
	
Next





/*
If ee2->(dbseek(xFilial('EE2')+"3"+"*"+eec->eec_idioma+ee9->ee9_cod_i))
cMemo := MSMM(EE2->EE2_TEXTO,AVSX3("EE2_VM_TEX")[AV_TAMANHO])
cProduto:= cMemo//MemoLine(cMemo,AVSX3("EE2_VM_TEX")[AV_TAMANHO],1)
Endif
*/

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

//EEC->(dbseek(xFilial('EEC')+exp->exp_preemb))

//cMensagem := MSMM(EEC->EEC_CODMEM,AVSX3("EEC_OBS",AV_TAMANHO))

DEFINE MSDIALOG oDlg TITLE "Observacao RE" FROM 200,1 TO 520,455 OF oMainWnd PIXEL

oDLG:SetFont(oFont)
@17,15 GET cMensagem MEMO HSCROLL SIZE 203,100 OF oDLG PIXEL

SButton():New(147,50,1,{||lRet:=.T.,oDlg:End()},oDlg,.T.,,)
SButton():New(147,110,2,{||oDlg:End()}, oDlg,.T.,,)

ACTIVATE MSDIALOG oDlg CENTERED

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

//aAdd(aRegistro,{cPerg,     "01"      ,"Data Invoice De " ,"mv_ch1"    ,"D"      ,08          ,0           ,0          ,"G"     ,"U_ShipData('01')","mv_par01",""})
//aAdd(aRegistro,{cPerg,     "02"      ,"Data Invoice Ate" ,"mv_ch2"    ,"D"      ,08          ,0           ,0          ,"G"     ,"U_ShipData('02')","mv_par02",""})
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



Static Function Repfile(cSigla,cPar1,cPar2,cValor)

Local cFile:="HEADER_P"

cCampo:="AVG_"+VALTYPE(cValor)+cPar1+If(Len(cPar2)<=2,"_","")+cPar2

If Valtype(cValor) == "C"
	cValor:=Alltrim(cValor)
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
DETAIL_P->AVG_CHAVE  := mv_par01 //nr. do processo
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
