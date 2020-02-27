#INCLUDE "Eicpo150.ch"  
#INCLUDE "AvPrint.ch"  
#INCLUDE "Font.ch"  
#INCLUDE "rwmake.ch"       
#INCLUDE "topconn.ch"

#DEFINE INGLES                     1
#DEFINE PORTUGUES                  2 
#DEFINE DLG_CHARPIX_H              15.1
#DEFINE DLG_CHARPIX_W              7.9   

Static aMarcados := {}, nMarcados  
//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: POCRYSTAL
//|Autor.....: Robson Sanchez Dias - robson@dqzafra.com.br
//|Data......: 24/06/09
//|Uso.......: SIGAEIC   
//|Versao....: Protheus - 10.1    
//|Descricao.: Impressão do PO em Crystal
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function POCRYSTAL()        
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

Private cPerg     := Avkey("EICPO1","X1_GRUPO")
Private aButtons  := {}
Private csim      := ""
Private _PictPo   := "@!"

cMarca      := GetMark()
aMarcados   := {}  
lInverte    := .F.
aPos        := {8,4,11,74}
bFuncao     := {|| PO150Impr() }
nCont       := 0 
nTotal      := 0  
nTotalGeral := 0 
nIdioma     := INGLES
cCadastro   := STR0032 //"Seleção de Purchase Order" 
//aRotina     := {{ STR0029,"AxPesqui"     , 0 , 1},; 
//                { STR0030,"Eval(bFuncao)", 0 , 0}}  
  

SC7->(dbsetorder(1))
                          
lBloqueado:=.f.
SC7->(dbseek(xFilial('SC7')+SW2->W2_PO_SIGA))
While ! sc7->(eof()) .and. sc7->c7_filial == xFilial('SC7') .and. sc7->c7_num = sw2->w2_po_siga 
  If SC7->C7_CONAPRO=="B" .And. SC7->C7_QUJE < SC7->C7_QUANT
    lBloqueado:=.t.
    Exit
 Endif
 sc7->(dbskip())
End    

//If lBloqueado
//    MsgStop("PEDIDO DE COMPRA NR: "+Alltrim(SW2->W2_PO_SIGA)+" ESTA BLOQUEADO NO MODULO DE COMPRAS","Atenção")
//    Return .f.
//Endif

nRecSW2:=SW2->(Recno())
SA5->(DBSETORDER(2))

E_ARQCRW(.T.,.T.,.T.)                   

aAdd(aMarcados,SW2->(Recno()))

Eval(bFuncao)

/*                         
dbSelectArea("SW2")     
dbgotop()

set filter to w2_filial <> ''

SW2->(MarkBrow("SW2","W2_OK",,,,cMarca,,,,,"U_POMarca()")) //EMISSAO

set filter to
*/

SW2->(dbgoto(nRecSW2))
SA5->(DBSETORDER(1))
                                    

Return                    

//+-----------------------------------------------------------------------------------//
//|Funcao....: POMarca()
//|Descricao.: Marca de desmarca pedido para impressão
//|Observação: 
//+-----------------------------------------------------------------------------------//  
*-----------------------------------------*
User Function POMarca()
*-----------------------------------------*

Local nPos := aScan(aMarcados,SW2->(RecNo()))

If SoftLock("SW2")
	If SW2->W2_OK == cMarca
		SW2->W2_OK := ""
		If nPos > 0
			aDel(aMarcados,nPos)
			aSize(aMarcados,Len(aMarcados)-1)
		Endif
	Else
		SW2->W2_OK := cMarca
		If nPos = 0
			aAdd(aMarcados,SW2->(Recno()))
		Endif
	Endif
Endif
   
Return    

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Impr()
//|Descricao.: Tela para impressão.
//|Observação: 
//+-----------------------------------------------------------------------------------//  
*-----------------------------------------*
Static FUNCTION PO150Impr()
*-----------------------------------------*

VERPERGSX1()
Pergunte(cPerg,.T. )

oDlgIdioma := nVolta := oRadio1 := Nil
lEnd := nil

@ (9*DLG_CHARPIX_H),(10*DLG_CHARPIX_W) TO (17*DLG_CHARPIX_H),(45*DLG_CHARPIX_W) DIALOG oDlgIdioma TITLE AnsiToOem(STR0033) //"Seleção"

@  8,10 TO 48,80 TITLE STR0034 //"Selecione o Idioma"

nVolta:=0

oRadio1 := oSend( TRadMenu(), "New", 17, 13, {STR0035,STR0036},{|u| If(PCount() == 0, nIdioma, nIdioma := u)}, oDlgIdioma,,,,,, .F.,, 55, 13,, .F., .T., .T. ) //"Inglês"###"Idioma Corrente"

oSend( SButton(), "New", 01, 90,5, {|| Pergunte(cPerg,.T. )})
oSend( SButton(), "New", 18, 90,1, {|| nVolta:=1, oSend(oDlgIdioma, "End")}, oDlgIdioma, .T.,,)
oSend( SButton(), "New", 37, 90,2, {|| oSend(oDlgIdioma,"End")}, oDlgIdioma, .T.,,)

ACTIVATE DIALOG oDlgIdioma CENTERED

Per01 := mv_par01
Per02 := mv_par02
Per03 := mv_par03
Per04 := mv_par04
Per05 := mv_par05
Per06 := mv_par06
Per07 := mv_par07
Per08 := mv_par08

IF nVolta == 1
   PO150Report()
Endif

Return(NIL)

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Report()
//|Descricao.: Verifica se há pedidos marcados para inicio da impressão
//|Observação: 
//+-----------------------------------------------------------------------------------//        
*-----------------------------------------*
Static FUNCTION PO150Report()
*-----------------------------------------*

cIndex    := cCond := nIndex := Nil
nOldArea  := ALIAS()
cCliComp  := ""
aCampos   := {}
cNomArq   := Nil
aHeader   := {}
lCriaWork :=.T.

cPictQtde   := '@E 999,999,999.99'
cPict1Total := '@E 999,999,999,999.99'
cPict2Total := '@E 99,999,999,999,999.99'

nMarcados := Len(aMarcados)

If nMarcados == 0
	MsgInfo(STR0037,STR0038) 
Else
	dbSelectArea("SW2")
	
	Processa({|| PO150Det() })
	
	dbSelectArea("SW2")
	SW2->(dbGoTop())
EndIf

aMarcados := {}

Return .T.

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Det()
//|Descricao.: Verifica pedidos marcados para chamada da função de Impressão
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function PO150Det()
Local nMarcados
*-----------------------------------------*

//ProcRegua(nMarcados)

For nMarcados:=1 To Len(aMarcados)
	
	SW2->(dbGoTo(aMarcados[nMarcados]))
	IncProc("Imprimindo...") 
	
	nTotal  := nTotalGeral := 0
	nPagina := 1
	nCont   := 0
	cSEQREL := GETSXENUM("SY0","Y0_SEQREL")    
	
	PO150Cabec()
	
	dbSelectArea("SW3")
	SW3->(dbSetOrder(1))
	SW3->(dbSeek(xFilial()+SW2->W2_PO_NUM))
	
	nCount := 0
	While SW3->(!Eof()) .AND.;
		SW3->W3_FILIAL == XFILIAL("SW3") .AND. ;
		SW3->W3_PO_NUM == SW2->W2_PO_NUM
		            

		If SW3->W3_SEQ #0
			SW3->(dbSkip())
			LOOP
		Endif    
		
		If SW3->W3_SEQ == 0
			nCount++
		Endif
		
		PO150Item()		
		SW3->(dbSkip())
	Enddo
	
    //	If SW2->W2_PACKING <> 0
    //		PO150Pack()
    //	EndIf
	
	cCliComp:=IF(GetMv("MV_ID_CLI")='S',SA1->A1_NOME,SY1->Y1_NOME)
	
	PO150Totais()
	PO150Doc()
	PO150Remarks()
	
	/*
	If !lBloqueado
		PO150Aprov()
		PO150Cargo()
	EndIf
	*/

	HEADER_P->AVG_C08_60 := Alltrim(DATA_MES(SW2->W2_PO_DT))
	HEADER_P->(dbUnlock())
	HEADER_P->(dbCommit())	
	dbSelectArea("SW2")
	
	SW2->(RecLock("SW2",.F.))
	SW2->W2_EMITIDO := "S" //PO Impresso
	SW2->W2_OK      := ""  //PO Desmarcado
	SW2->(MsUnLock())
	
	If nCount > 12
		cNewLayout := .T.     
	Else                 
		cNewLayout := .F.
	Endif
	
	
	If cNewLayout
		AvgCrw32("POMID2.RPT","PURCHASE ORDER - " + AllTrim(SW2->W2_PO_NUM),cSEQREL,,,.F.)
	Else
		AvgCrw32("POMID1.RPT","PURCHASE ORDER - " + AllTrim(SW2->W2_PO_NUM),cSEQREL,,,.F.)
	EndIf

	
Next 

‡Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Cabec()
//|Descricao.: Preenche dados do cabeçalho
//|Observação: 
//+-----------------------------------------------------------------------------------// 
*-----------------------------------------*
Static FUNCTION PO150Cabec()
*-----------------------------------------*

c2EndSM0 := c2EndSA2 := cCommission := c2EndSYT := cTerms := ""
cDestinat := cRepr := cCGC := cNr := cDestino := cPais := cOrigem := ""

HEADER_P->(dbAppend())
HEADER_P->AVG_SEQREL := cSEQREL
HEADER_P->AVG_CHAVE  := SW2->W2_PO_NUM

IF GetMv("MV_ID_CLI") == 'S'
//-----------> Cliente.
   SA1->( DBSETORDER( 1 ) )
   SA1->( DBSEEK( xFilial("SA1")+SW2->W2_CLIENTE ) )
ELSE
// --------->  Comprador.
   SY1->( DBSETORDER(1) )
   SY1->( DBSEEK( xFilial("SY1")+SW2->W2_COMPRA ) )
ENDIF

//----------->  Fornecedor.
SA2->( DBSETORDER( 1 ) )
SA2->( DBSEEK( xFilial()+SW2->W2_FORN ) )
cNome 	 := SW2->W2_FORN+'-'+SA2->A2_NOME
cEndA2	 := SA2->A2_END                                            
cContato := SA2->A2_CONTATO
cTel	 := SA2->A2_TEL
cFax	 := SA2->A2_FAX
cEmail	 := Alltrim(SA2->A2_EMAIL)

//----------->  Paises.
SYA->( DBSETORDER( 1 ) )
SYA->( DBSEEK( xFilial()+SA2->A2_PAIS ) )    

cEstado:=If(Left(SA2->A2_ESTADO,2)=="EX","",SA2->A2_ESTADO)
cMun   :=If(Alltrim(SA2->A2_MUN)=="ESTRANGEIRO","",SA2->A2_MUN)

c2EndSA2 := c2EndSA2 + IF( !EMPTY(cMun   ), ALLTRIM(cMun   )+' - ', "" )
c2EndSA2 := c2EndSA2 + IF( !EMPTY(SA2->A2_BAIRRO), ALLTRIM(SA2->A2_BAIRRO)+' - ', "" )
c2EndSA2 := c2EndSA2 + IF( !EMPTY(cEstado), ALLTRIM(cEstado)+' - ', "" )
c2EndSA2 := c2EndSA2 + IF( !EMPTY(SYA->YA_PAIS_I ), ALLTRIM(SYA->YA_PAIS_I )+' - ', "" )
c2EndSA2 := LEFT( c2EndSA2, LEN(c2EndSA2)-2 )
                                   
//c2EndSA2:=STRTRAN(c2EndSA2,"ESTRANGEIRO","")
//c2EndSA2:=STRTRAN(c2EndSA2,"EX","")

//-----------> Pedidos.
IF SW2->W2_COMIS $ cSim
   cCommission :=SW2->W2_MOEDA+" "+TRANS(SW2->W2_VAL_COM,E_TrocaVP(nIdioma,'@E 9,999,999,999.9999'))
   IF( SW2->W2_TIP_COM == "1", cCommission:=TRANS(SW2->W2_PER_COM,E_TrocaVP(nIdioma,'@E 999.99'))+"%", )
   IF( SW2->W2_TIP_COM == "4", cCommission:=SW2->W2_OUT_COM, )
ENDIF      

//----------->  Fornecedor.
SA2->( DBSETORDER( 1 ) )
SA2->( DBSEEK( xFilial()+SW2->W2_FORN ) )

IF GetMv("MV_ID_EMPR") == 'S'
   c2EndSM0 := c2EndSM0 +IF( !EMPTY(SM0->M0_CIDCOB), ALLTRIM(SM0->M0_CIDCOB)+' - ', "" )
   c2EndSM0 := c2EndSM0 +IF( !EMPTY(SM0->M0_ESTCOB), ALLTRIM(SM0->M0_ESTCOB)+' - ', "" )
   c2EndSM0 := c2EndSM0 +IF( !EMPTY(SM0->M0_CEPCOB), TRANS(SM0->M0_CEPCOB,"@R 99999-999")+' - ', "" )
   c2EndSM0 := LEFT( c2EndSM0, LEN(c2EndSM0)-2 )
ELSE
   c2EndSM0 := c2EndSM0 +IF( !EMPTY(SYT->YT_CIDADE), ALLTRIM(SYT->YT_CIDADE)+' - ', "" )
   c2EndSM0 := c2EndSM0 +IF( !EMPTY(SYT->YT_ESTADO), ALLTRIM(SYT->YT_ESTADO)+' - ', "" )
   c2EndSM0 := c2EndSM0 +IF( !EMPTY(SYT->YT_CEP), TRANS(SYT->YT_CEP,"@R 99999-999")+' - ', "" )
   c2EndSM0 := LEFT( c2EndSM0, LEN(c2EndSM0)-2 )
ENDIF

//-----------> Portos.
SY9->( DBSETORDER( 2 ) )
SY9->( DBSEEK( xFilial()+SW2->W2_DEST ) )

cDestinat := ALLTRIM(SW2->W2_DEST) + " - " + ALLTRIM(SY9->Y9_DESCR)

//-----------> Agentes Embarcadores.
SY4->( DBSETORDER( 1 ) )
SY4->( DBSEEK( xFilial('SY4')+SW2->W2_FORWARD ) )

//-----------> Agentes Compradores.
SY1->(DBSEEK(xFilial()+SW2->W2_COMPRA))

//-----------> Produtos X Fornecedor.        
dbSelectArea("SW3")
SW3->(dbSetOrder(1))
SW3->(dbSeek(xFilial()+SW2->W2_PO_NUM))

SA5->( DBSETORDER( 1 ) )
SA5->( DBSEEK( xFilial()+SW3->W3_FABR+"01"+SW3->W3_COD_I ) )
cCodFor := SA5->A5_FABR

If TRIM(cCodFor) == ""
	SA2->( DBSETORDER( 1 ) )
	SA2->( DBSEEK( xFilial()+SW3->W3_FABR+"01" ) )
	cPais := SA2->A2_PAIS
Else
	SA2->( DBSETORDER( 1 ) )
	SA2->( DBSEEK( xFilial()+cCodFor ) )
	cPais := SA2->A2_PAIS
EndIf
	
SYA->( DBSETORDER( 1 ) )
SYA->( DBSEEK( xFilial()+cPais ) )
cOrigem := SYA->YA_PAIS_I	

//-----------> País Origem
SYR->(DBSETORDER(1))
SYR->(DBSEEK(xFilial("SYR")+SW2->W2_TIPO_EM+SW2->W2_ORIGEM)) 
cCodOr := SYR->YR_PAIS_OR            

SYA->( DBSETORDER( 1 ) )
SYA->( DBSEEK( xFilial()+cCodOr ) )
cPOrigem := SYA->YA_PAIS_I	//SIGLA

// Fornecedor
HEADER_P->AVG_C01_60 := Alltrim(cNome)
HEADER_P->AVG_C02_60 := Alltrim(cEndA2)
HEADER_P->AVG_C03_60 := Alltrim(c2EndSA2)+" ,"+" "+Alltrim(Transform(SA2->A2_CEP,"99999999"))
HEADER_P->AVG_C08_30 := Alltrim(cContato)
HEADER_P->AVG_C01_20 := Alltrim(cTel)
HEADER_P->AVG_C02_20 := Alltrim(cFax)
HEADER_P->AVG_C01_30 := Alltrim(cEmail)
HEADER_P->AVG_C04_30 := Alltrim(cOrigem)

// Supplier (Fabricante)
// Diego 24/04/18
dbSelectArea("SW3")
SW3->(dbSetOrder(1))                    
SW3->(dbSeek(xFilial()+SW2->W2_PO_NUM)) 
SW3->(dbGoBottom())

dbSelectArea("SA2")
SA2->(dbSetOrder(1))
If SW2->W2_X_FABR == space(6)
	SA2->(dbSeek( xFilial()+SW3->W3_FABR+SW3->W3_FABLOJ ) )
Else
	SA2->(dbSeek( xFilial()+SW2->W2_X_FABR+SW2->W2_FORLOJ) )
Endif


SYA->( DBSETORDER( 1 ) )
SYA->( DBSEEK( xFilial()+SA2->A2_PAIS ) )    

cEstado:=If(Left(SA2->A2_ESTADO,2)=="EX","",SA2->A2_ESTADO)
cMun   :=If(Alltrim(SA2->A2_MUN)=="ESTRANGEIRO","",SA2->A2_MUN)

c2EndSA2 := IF( !EMPTY(cMun   ), ALLTRIM(cMun   )+' - ', "" )
c2EndSA2 := c2EndSA2 + IF( !EMPTY(SA2->A2_BAIRRO), ALLTRIM(SA2->A2_BAIRRO)+' - ', "" )
c2EndSA2 := c2EndSA2 + IF( !EMPTY(cEstado), ALLTRIM(cEstado)+' - ', "" )
c2EndSA2 := c2EndSA2 + IF( !EMPTY(SYA->YA_PAIS_I ), ALLTRIM(SYA->YA_PAIS_I )+' - ', "" )
c2EndSA2 := LEFT( c2EndSA2, LEN(c2EndSA2)-2 )


HEADER_P->AVG_C07_60 := Alltrim(SA2->A2_COD)+'-'+Alltrim(SA2->A2_NOME)
HEADER_P->AVG_C06_60 := Alltrim(SA2->A2_END)
HEADER_P->AVG_C12_60 := Alltrim(c2EndSA2)   
HEADER_P->AVG_C01_10 := Alltrim(SA2->A2_TEL)



// ForWarder
//-----------> Agentes Embarcadores.
SY4->( DBSETORDER( 1 ) )
SY4->( DBSEEK( xFilial('SY4')+SW2->W2_FORWARD ) )

HEADER_P->AVG_C04_60 := SW2->W2_FORWARD+'-'+Alltrim(SY4->Y4_NOME)
HEADER_P->AVG_C05_60 := Alltrim(SY4->Y4_END)
HEADER_P->AVG_C05_20 := Alltrim(SY4->Y4_CONTATO)
HEADER_P->AVG_C01100 := "TEL: "+SY4->Y4_FONE+' / '+'FAX: '+SY4->Y4_FAX
HEADER_P->AVG_C15_60 := Alltrim(SY4->Y4_EMAIL)
cRepr:=IF(nIdioma==INGLES,cContato,cContato)

/*
HEADER_P->AVG_C08_30 := Alltrim(cContato)
HEADER_P->AVG_C01_20 := Alltrim(cTel)
HEADER_P->AVG_C02_20 := Alltrim(cFax)
HEADER_P->AVG_C01_30 := Alltrim(cEmail)
HEADER_P->AVG_C04_30 := Alltrim(cOrigem)
*/

_cQrySya := "SELECT SYA.YA_DESCR "
_cQrySya += "FROM " + RetSqlName("SYA") + " SYA "
_cQrySya += "WHERE	SYA.D_E_L_E_T_ = '' "
_cQrySya += "AND SYA.YA_FILIAL = '" + xFilial("SYA") + "' "
_cQrySya += "AND SYA.YA_CODGI = (	SELECT SYR.YR_PAIS_DE "
_cQrySya += "						FROM " + RetSqlName("SYR") + " SYR "
_cQrySya += "						WHERE	SYR.D_E_L_E_T_ = '' "
_cQrySya += "								AND SYR.YR_FILIAL = '" + xFilial("SYR") + "' " 
_cQrySya += "								AND SYR.YR_VIA = '" + SW2->W2_TIPO_EMB + "' "  // Tipo via de tranporte - linha add por Diego M. em 13/10/14 para corrigir erro consulta
_cQrySya += "								AND SYR.YR_ORIGEM = '" + SW2->W2_ORIGEM + "' "
_cQrySya += "								AND SYR.YR_DESTINO = '" + SW2->W2_DEST + "' ) "

If Select("TRBSYA") > 0
	TRBSYA->(DbCloseArea())
Endif
	
Tcquery	_cQrySya New Alias "TRBSYA"	

HEADER_P->AVG_C05_30 := Alltrim(SW2->W2_DEST)+" - BRAZIL "//+Alltrim(TRBSYA->YA_DESCR) //"Country of Final Destination: "
HEADER_P->AVG_C06_30 := Alltrim(SW2->W2_ORIGEM)+" - "+Alltrim(cPOrigem) //"Country of Shipment: "
HEADER_P->AVG_C02_30 := Alltrim(SY1->Y1_NOME) //
HEADER_P->AVG_C03_20 := Alltrim(SY1->Y1_TEL) //"Telephone: "
HEADER_P->AVG_C04_20 := Alltrim(SY1->Y1_FAX) //"Fax: "
//HEADER_P->AVG_C04_30 := Alltrim(SY1->Y1_EMAIL)
HEADER_P->AVG_C13_60 := Alltrim(SY1->Y1_EMAIL)
Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Item()
//|Descricao.: Preenche dados dos itens
//|Observação: 
//+-----------------------------------------------------------------------------------// 
*-----------------------------------------*
Static FUNCTION PO150Item()
*-----------------------------------------*

cDescrItem := "" 

DETAIL_P->(dbAppend())
DETAIL_P->AVG_SEQREL := cSEQREL
DETAIL_P->AVG_CHAVE  := SW2->W2_PO_NUM

//-----------> Unidade Requisitante (C.Custo).
SY3->( DBSETORDER( 1 ) )
SY3->( DBSEEK( xFilial()+SW3->W3_CC ) )

//-----------> Fornecedores.
SA2->( DBSETORDER( 1 ) )
SA2->( DBSEEK( xFilial()+SW3->W3_FABR ) )

//-----------> Reg. Ministerio.
SYG->( DBSETORDER( 1 ) )
SYG->( DBSEEK( xFilial()+SW2->W2_IMPORT+SW3->W3_FABR+SW3->W3_COD_I ) )

//-----------> Produtos (Itens) e Textos.
SB1->( DBSETORDER( 1 ) )
SB1->( DBSEEK( xFilial()+SW3->W3_COD_I ) )
cCodItem := SB1->B1_COD

nCont := nCont+1

cDescrItem := MSMM(IF( nIdioma==INGLES, SB1->B1_DESC_I, SB1->B1_DESC_P ),240)

//----------> TEC NCM
DETAIL_P->AVG_C05_20 := SW3->W3_TEC
DETAIL_P->AVG_C06_20 := Alltrim(SB1->B1_UM)


DETAIL_P->AVG_C01_20 := Alltrim(cCodItem)
DETAIL_P->AVG_C03_10 := STRZERO(nCont,3)
DETAIL_P->AVG_C01100 := Alltrim(cDescrItem)
DETAIL_P->AVG_C04_20 := Alltrim(TRANS(SW3->W3_QTDE,E_TrocaVP(nIdioma,'@E 9,999,999,999.9999')))
DETAIL_P->AVG_C02_20 := Alltrim(TRANS(SW3->W3_PRECO,E_TrocaVP(nIdioma,'@E 9,999,999.999999')))
//alert('PRECO'+cValToChar(SW3->W3_PRECO))
DETAIL_P->AVG_C03_20 := Alltrim(TRANS(SW3->W3_QTDE*SW3->W3_PRECO,E_TrocaVP(nIdioma,cPict1Total)))

DETAIL_P->AVG_C04_10 := TRANS(SW3->W3_DT_EMB, '@D') 
DETAIL_P->AVG_C01_10 := TRANS(SW3->W3_X_DTPOR,'@D') 
DETAIL_P->AVG_C02_10 := TRANS(SW3->W3_DT_ENTR,'@D')

nTotal := nTotal + SW3->W3_QTDE*SW3->W3_PRECO

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Pack()
//|Descricao.: Preenche valor do Packing do PO
//|Observação: 
//+-----------------------------------------------------------------------------------//      
*-----------------------------------------*
Static FUNCTION PO150Pack()
*-----------------------------------------*

DETAIL_P->(dbAppend())
DETAIL_P->AVG_SEQREL := cSEQREL
DETAIL_P->AVG_CHAVE  := SW2->W2_PO_NUM

nCont := nCont+1

DETAIL_P->AVG_C01_10 := STRZERO(nCont,3)
DETAIL_P->AVG_C01100 := "Packing"
DETAIL_P->AVG_C02_20 := Alltrim(TRANS(SW2->W2_PACKING,E_TrocaVP(nIdioma,'@E 999,999,999.999')))
DETAIL_P->AVG_C03_20 := Alltrim(TRANS(SW2->W2_PACKING,E_TrocaVP(nIdioma,cPict1Total)))

nTotal := nTotal + SW2->W2_PACKING

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Remarks()
//|Descricao.: Preenche Observações do PO
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static FUNCTION PO150Remarks()
*-----------------------------------------*
Local nTam:=150                                          

cRemarks := ""
cRemarks := MSMM(SW2->W2_OBS,900)

HEADER_P->AVG_C01150:=MEMOLINE(cRemarks,nTam,1)
HEADER_P->AVG_C02150:=MEMOLINE(cRemarks,nTam,2)  
HEADER_P->AVG_C03150:=MEMOLINE(cRemarks,nTam,3)  
HEADER_P->AVG_C04150:=MEMOLINE(cRemarks,nTam,4)  
HEADER_P->AVG_C05150:=MEMOLINE(cRemarks,nTam,5)  
HEADER_P->AVG_C06150:=MEMOLINE(cRemarks,nTam,6)  
/*HEADER_P->AVG_C05150:=MEMOLINE(cRemarks,nTam,6)  
HEADER_P->AVG_C05150:=MEMOLINE(cRemarks,nTam,7)  
HEADER_P->AVG_C05150:=MEMOLINE(cRemarks,nTam,8)  
HEADER_P->AVG_C06150:=MEMOLINE(cRemarks,nTam,9)  
HEADER_P->AVG_C06150:=MEMOLINE(cRemarks,nTam,10)  
HEADER_P->AVG_C06150:=MEMOLINE(cRemarks,nTam,11)  
HEADER_P->AVG_C06150:=MEMOLINE(cRemarks,nTam,12)
*/  

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Totais()
//|Descricao.: Preenche total do PO
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static FUNCTION PO150Totais()
*-----------------------------------------*                                                
Local nTotalGer:=(nTotal+sw2->w2_inland+sw2->w2_packing+sw2->w2_fretein)-sw2->w2_descont

HEADER_P->AVG_C20_60 := Alltrim(TRANS(nTotal,E_TrocaVP(nIdioma,cPict2Total)))
HEADER_P->AVG_C16_60 := Alltrim(TRANS(sw2->w2_inland,E_TrocaVP(nIdioma,cPict2Total)))  // Inland 
HEADER_P->AVG_C17_60 := Alltrim(TRANS(sw2->w2_packing,E_TrocaVP(nIdioma,cPict2Total)))  // Packing
HEADER_P->AVG_C18_60 := Alltrim(TRANS(sw2->w2_descont,E_TrocaVP(nIdioma,cPict2Total)))  // Descont  
HEADER_P->AVG_C21_60 := Alltrim(TRANS(sw2->w2_fretein,E_TrocaVP(nIdioma,cPict2Total)))  // frete internacional
HEADER_P->AVG_C19_60 := Alltrim(TRANS(nTotalGer,E_TrocaVP(nIdioma,cPict2Total)))  // Total

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Doc()
//|Descricao.: Informações complementares do Rodapé do PO
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static FUNCTION PO150Doc()
*-----------------------------------------*

cTerms := ""
DtEmb  := ""
DtETA  := ""

//-----------> Condicoes de Pagamento.
SY6->( DBSETORDER( 1 ) )
SY6->( DBSEEK( xFilial()+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0) ) )
      
IF nIdioma == INGLES
	cTerms := MSMM(SY6->Y6_DESC_I,48)
ELSE
	cTerms := MSMM(SY6->Y6_DESC_P,48)
ENDIF
STRTRAN(cTerms, CHR(13)+CHR(10), " ")

//-----------> Importador.
SYT->( DBSETORDER( 1 ) )
SYT->( DBSEEK( xFilial()+SW2->W2_IMPORT ) )
  
//-----------> Agentes Embarcadores.    
SYQ->( DBSETORDER( 1 ) )
SYQ->( DBSEEK( xFilial()+SW2->W2_TIPO_EMB ) )

//-----------> Embarque.
SW3->( DBSETORDER( 1 ) )
SW3->( DBSEEK( xFilial()+SW2->W2_PO_NUM ) )
DtEmb := SW3->W3_DT_EMB
DtETA := SW3->W3_DT_ENTR  

SY4->(dbseek(xFilial('SY4')+SW2->W2_AGENTE))
HEADER_P->AVG_C03_30 := Alltrim(cTerms)          //"Payment Terms: 
HEADER_P->AVG_C02_10 := Alltrim(SW2->W2_INCOTER) //"Delivery Terms: 
HEADER_P->AVG_D04_08 := DtEmb                    //"Delivery Time: 
HEADER_P->AVG_C03_10 := Alltrim(SYQ->YQ_DESC_I) // "Packing: 
//HEADER_P->AVG_C03_10 := Alltrim(SW2->W2_AGENTE)  //"Transport Company: 
HEADER_P->AVG_C14_60 := Alltrim(SW2->W2_AGENTE)+'-'+Alltrim(SY4->Y4_NOME)    //"Transport Company: 
//HEADER_P->AVG_C07_20 := Alltrim(SYT->YT_NOME)    //"Importer: 
HEADER_P->AVG_D05_08 := DtETA                    //"ETA: 
HEADER_P->AVG_C04_10 := Alltrim(SW2->W2_MOEDA)  // "Simbolo da Moeda


//-----------> Consignatario.
SYT->( DBSETORDER( 1 ) )
SYT->( DBSEEK( xFilial()+SW2->W2_CONSIG ) )

HEADER_P->AVG_C09_60 := SYT->YT_NOME                                      //Nome
HEADER_P->AVG_C10_60 := Alltrim(SYT->YT_ENDE)+', '+Alltrim(STR(SYT->YT_NR_END))          //Endereco , Numero

SYA->( DBSEEK( xFilial("SYA")+SYT->YT_PAIS ) )


HEADER_P->AVG_C11_60 := Alltrim(SYT->YT_CIDADE)+' - '+Alltrim(SYT->YT_ESTADO)+' - '+Alltrim(SYA->YA_DESCR)+" CEP: "+SYT->YT_CEP         
//Alterado por Anesio em 10/10/2012 para incluir o BAIRRO - LINHA ORIGINAL = 	HEADER_P->AVG_C12_60 := "CNPJ: "+TRANS(SYT->YT_CGC,'@R 99.999.999/9999-99')
if Len(AllTrim (SYT->YT_BAIRRO)) > 0
	HEADER_P->AVG_C02_20 := AllTrim(SYT->YT_BAIRRO)
endif

HEADER_P->AVG_C04_30 := "CNPJ "+TRANS(SYT->YT_CGC,'@R 99.999.999/9999-99')



Return 

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Aprov()
//|Descricao.: Verifica aprovador
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static FUNCTION PO150Aprov()
*-----------------------------------------*
Local xAprov:="", aAprov:=Array(4)

cAprov    := ""           

AFILL(aAprov,SPACE(30))

//-----------> Cadastro de Aprovadores
SAL->(DBSETORDER(1))

If SAL->(DBSEEK(xFilial("SAL")+Per01))
	cAprov := SAL->AL_COD      
	
	//aAprov:={} 
	nAprov:=1
	Do While !SAL->(EOF()) .and. cAprov == SAL->AL_COD .AND. nAprov <= 4

	    xAprov:=Posicione("SAK", 2, xFilial("SAK")+SAL->AL_USER,"AK_NOME")
	          
	    //aadd(aAprov,xAprov) 
	    aAprov[nAprov]:=xAprov
	    
	    nAprov++
	    
		SAL->(dbskip())
	EndDo
	
	//HEADER_P->AVG_C02150 := xAprov 
	
	Header_P->AVG_C09_30:= aAprov[1]
	Header_P->AVG_C26_60:= aAprov[2]
	Header_P->AVG_C28_60:= aAprov[3]
	Header_P->AVG_C30_60:= aAprov[4]
	
EndIf


Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Cargo(
//|Descricao.: Verifica Cargo
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static FUNCTION PO150Cargo()
*-----------------------------------------*
Local aCargos:=Array(4)

cCodAprov := ""
cCargo	  := ""

//-----------> Cadastro de Cargo de Aprovadores
SAL->( DBSETORDER(1))
If SAL->( DBSEEK( xFilial()+Per01))
	cAprov := SAL->AL_COD                        
	nCargo:=1
	Do While !SAL->(EOF()) .and. cAprov == SAL->AL_COD .AND. nCargo <= 4
		cCodAprov := SAL->AL_APROV
		SAK->(DBSETORDER(1))
		If SAK->(DBSEEK(xFilial()+cCodAprov))
			cCargo := SAK->AK_CARGO
			
			//AADD(aCargos,cCargo)
			aCargos[nCArgo]:=cCargo  
			nCargo++
		EndIf
		SAL->(dbskip())
	EndDo
      
	Header_P->AVG_C25_60:= aCargos[1]
	Header_P->AVG_C27_60:= aCargos[2]
	Header_P->AVG_C29_60:= aCargos[3]
	Header_P->AVG_C31_60:= aCargos[4]


	//HEADER_P->AVG_C03150 := xCargos

EndIf

Return

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

//+-----------------------------------------------------------------------------------//
//|Funcao....: VERPERGSX1()
//|Descricao.: Inclusão de Parametros no arquivo SX1
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static FUNCTION VERPERGSX1()
*-----------------------------------------*

Local nX := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aRegistro := {}
Local j

aRegistro:= {}
/*
AADD(aRegistro,{cPerg,"01","Invoice Original","mv_ch1","C", 2,0,0,"G","","mv_par01"})
AADD(aRegistro,{cPerg,"02","Copia Invoice   ","mv_ch2","C", 2,0,0,"G","","mv_par02"})
AADD(aRegistro,{cPerg,"03","Packing List    ","mv_ch3","C", 2,0,0,"G","","mv_par03"})
AADD(aRegistro,{cPerg,"04","AWB/BL Original ","mv_ch4","C", 2,0,0,"G","","mv_par04"})
AADD(aRegistro,{cPerg,"05","Copia AWB/BL    ","mv_ch5","C", 2,0,0,"G","","mv_par05"})
*/
AADD(aRegistro,{cPerg,"01","Grupo Aprovação ","mv_ch1","C", 6,0,0,"G","","mv_par01","SAL"})
aAdd(aRegistro,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_F3"})

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
