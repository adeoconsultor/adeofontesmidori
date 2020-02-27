#INCLUDE "Eicdi155.ch"            
//#INCLUDE "FONT.CH"
#INCLUDE "AVPRINT.CH"
//#INCLUDE "PRINT.CH"
#include "rwmake.ch"
#include "average.ch"

/*
Autor:		Alexandre da Costa
Função:		EICPCS01
Descrição:	Emissão do Relatório do Custo Realizado do Processo / Solicitação da N.F.E.
Sintaxe:    #EICDI155
Condições:	D.I. informada na tela de embarque/desembaraco
Taxas FOB e US$ D.I. informadas na tela de emb./desembaraço
Data:			02/Jun/2000
*/
//----------------------------------------------------------------------------//
// Printer
#xcommand TRACO_NORMAL  => oPrn:Line(nxLinha,  0050,nxLinha,  2300);
						;  oPrn:Line(nxLinha+1,0050,nxLinha+1,2300) 
#xcommand TRACO_REDU_01 => oPrn:Box(nxLinha+nxIncrem,0050,nxLinha+nxIncrem+1,0950)
#xcommand TRACO_REDU_02 => oPrn:Box(nxLinha,1270,nxLinha+1,2300)
#xcommand TRACO_REDU_03 => oPrn:Box(nxLinha,0750,nxLinha+1,2300)
#xcommand TRACO_VERT_01 => oPrn:Line(nxLinha,0049,nxLinha+nxIncrem,0049);
						;  oPrn:Line(nxLinha,0050,nxLinha+nxIncrem,0050);
						;  oPrn:Line(nxLinha,2299,nxLinha+nxIncrem,2299);
						;  oPrn:Line(nxLinha,2300,nxLinha+nxIncrem,2300)
#xcommand TRACO_VERT_02 => oPrn:Box(nxLinha,0950,nxLinha+nxIncrem,0951)
#xcommand COMECA_PAGINA => AVNEWPAGE; nxLinha:=0; ++nxPagina; ICus_INICPG()
#xcommand ENCERRA_PAGINA => TRACO_NORMAL  
//----------------------------------------------------------------------------//
// Definicao de Fontes
#xtranslate :ARIAL_08       => \[1\]
#xtranslate :ARIAL_08_BOLD  => \[2\]
#xtranslate :ARIAL_09_BOLD  => \[3\]
#xtranslate :ARIAL_10       => \[4\]
#xtranslate :ARIAL_10_BOLD  => \[5\]
#xtranslate :ARIAL_13_BOLD  => \[6\]
#xtranslate :ARIAL_18_BOLD  => \[7\]
#DEFINE COURIER_09 oFont8
#define DESPESA_PIS     "204"
#define DESPESA_COFINS  "205"
#define TOT_CIF         "199"   // EOS 13/05
#define TOT_IMPOSTOS    "299"
#define DESPS_TOTS      "199."+TOT_IMPOSTOS  // EOS 13/05
#define DESP_SEM_COD    "105"
#define SOMA_PIS_COFINS IF(lMV_PIS_EIC,(EI2->EI2_VLRPIS+EI2->EI2_VLRCOF),0)

//----------------------------------------------------------------------------//
// Definição de Apresentação de Datas
#xtranslate DATA_MES(<x>)   => SUBS(DTOC(<x>),1,2)+" "+SUBS(MesExtenso(<x>),1,3)+" "+SUBS(DTOC(<x>),7,2)

*===================================*
//Function EICDI155(ParamIXB)
USER FUNCTION ICPADFI3()
*===================================*
PRIVATE cPictPeso:= AVSX3('B1_PESO',6)
PRIVATE lExisteCampoW6 :=lCposAdto:=.F.
PRIVATE lExiste_Midia:= GETMV("MV_SOFTWAR",,"N") $ cSim


Alert("passou")

//lCposAdto->Se existir os campos referente a pagamento antecipado, tratar Seek
//e While com um campo a mais o WA_PO_DI/WB_PO_DI que, nas parcelas de cambio de DI tera
//como conteudo a letra "D"

lCposAdto:=GETMV("MV_PG_ANT",,.F.)

nRelTipo:=ParamIXB
lRelCustomizado := .F.
IF ExistBlock("EICDI155")
   ExecBlock("EICDI155",.F.,.F.,nRelTipo)
ENDIF
IF lRelCustomizado
  RETURN .T.
ENDIF
//OBS.: QUANDO ESTE PROGRAMA FOR PASSADO P/ RDMAKE, TIRAR ESTA CHAMADA P/ NAO OCORRER LOOP//
//IF ExistBlock("ICPADFI3")
//   ExecBlock("ICPADFI3",.F.,.F.,nRelTipo)
//   RETURN .T.
//ENDIF
//----------------------------------------------------------------------------------------//

IF nRelTipo == NIL            
   cProcesso:=SPACE(LEN(SW6->W6_HAWB))
   nOpc:=0
   @ 000,000 TO 095,340 DIALOG oDlg TITLE STR0001 //"Relatorio de Custo Realizado"
  	
   @ 010,010 SAY STR0002 SIZE 50,10 //"Processo:"
   @ 010,040 GET cProcesso   SIZE 70,10 F3 'SW6' 
   @ 005,130 BMPBUTTON TYPE 01	ACTION (IF(DI155Valid(),(nOpc:=1,oDlg:End()),))
   @ 020,130 BMPBUTTON TYPE 02	ACTION (nOpc:=0,oDlg:End())
	  
   ACTIVATE DIALOG oDlg CENTERED
   If nOpc==0
      RETURN .F.
   EndIf
   nRelTipo:=4
ENDIF

IF VALTYPE(nRelTipo) == "C" .OR. nRelTipo == 99 //"EICIN86"
   EICIN86(VALTYPE(nRelTipo) == "C")
   RETURN .T.
ENDIF

IF nRelTipo == 4				//--- Emissão do Custo Realizado
   DI155Custo()
ELSE
   DI155NFE(nRelTipo)
Endif

RETURN .T.
*----------------------------*
Static Function DI155Valid()
*----------------------------*
SW6->(DBSETORDER(1))
IF !SW6->(DBSEEK(xFiliaL('SW6')+cProcesso))
   MSGINFO(STR0003,STR0004) //"Processo não cadastrado"###"Atenção"
   RETURN .F.
ENDIF

EI1->(DBSETORDER(1))
EI2->(DBSETORDER(1))
If !EI1->(dBSeek(xFilial('EI1')+SW6->W6_HAWB)).or.;
   !EI2->(dBSeek(xFilial('EI2')+SW6->W6_HAWB))
   MsgInfo(STR0005,STR0006) //"Não existe CUSTO gravado nesse Processo para ser impresso."###"Custo Realizado"
   Return .F.
EndIf

RETURN .T.
*----------------------------*
Static Function DI155Custo()
*----------------------------*
Local axSimNao	:={STR0007,STR0008} //"S-Sim"###"N-Não"
Local axTipoRel	:={STR0009,STR0010} //"P-Por P.O."###"I-Por Item"
Local axStru1	:={}
//Local axStru2	:={}
Local cxArqTrab1:=''
Local cxArqTrab2:=''
Local cxTitulo	:=STR0006 //"Custo Realizado"
Local nxOpc		:=0     

lMV_PIS_EIC:=GETMV("MV_PIS_EIC",,.F.) .AND. EI2->(FIELDPOS("EI2_VLRPIS")) # 0 .AND. SYD->(FIELDPOS("YD_PER_PIS")) # 0

// Configuração do Relatório e Definição/Carga de variáveis
lxCusPO		:=.T.
lxCusIte	:=.T.
lxDespDet	:=.T.
lxResPO		:=.T.
lxResCC		:=.T.
lxResDV		:=.T.
nxIncrem	:=50
nxPagina	:=0
nxLinha		:=0
nxTcIPIICM	:=0		//---	Total com IPI e ICM
nxTsIPIICM	:=0		//---	Total sem IPI e ICM
nxTsPIScIPI :=0
nxTsPISsIPI :=0
nxRotinas	:=0
cxPicQtde	:='@E 99,999,999.99'
cxPicValor	:='@E 999,999,999.99'
cxPicPerc	:='@E 9999.999'
dxVencto	:=AVCTOD("  /  /  ")
dxLiquid	:=AVCTOD("  /  /  ")
dxContrat	:=AVCTOD("  /  /  ")
lTamDespesa :=LEN(SWD->WD_DESPESA)
lLote       := GETMV("MV_LOTEEIC") $ cSim
//--- Verifica qual será a configuração do lay-Out de Impressão dentre os 
//--- 32 possíveis quando existir o campo Y3_DIVIS ou entre os 16 posíveis
//--- quando não existir o campo Y3_DIVIS no SY3.
                  
DEFINE MSDIALOG oDlg TITLE cxTitulo+STR0011+SW6->W6_HAWB From 9,0 To 23,45 OF oMainWnd

//@ 002,005 TO 070,135

@ 05,02 TO 85,178 LABEL "Selecao" OF oDlg PIXEL 

@ 15,10 CHECKBOX lxDespDet PROMPT STR0012 SIZE 150,10 OF oDlg PIXEL//"Despesas detalhadas"
@ 25,10 CHECKBOX lxCusPO   PROMPT STR0013 SIZE 150,10 OF oDlg PIXEL //"Custo por P.O."
@ 35,10 CHECKBOX lxCusIte  PROMPT STR0014 SIZE 150,10 OF oDlg PIXEL//"Custo por Item"
@ 45,10 CHECKBOX lxResPO   PROMPT STR0015 SIZE 150,10 OF oDlg PIXEL//"Resumo por P.O."
@ 55,10 CHECKBOX lxResCC   PROMPT STR0016 SIZE 150,10 OF oDlg PIXEL//"Resumo por Centro Custo"
@ 65,10 CHECKBOX lxResDV   PROMPT STR0017 SIZE 150,10 OF oDlg PIXEL//"Resumo por Divisão"
@ 010,145 BMPBUTTON TYPE 01	ACTION (nxOpc:=1,oDlg:End())
@ 025,145 BMPBUTTON TYPE 02	ACTION (nxOpc:=0,oDlg:End())
ACTIVATE DIALOG oDlg CENTERED
If nxOpc==0
   RETURN .F.//EXIT
EndIf
nxRotinas	:=3
If lxCusPO
   ++nxRotinas
EndIf
If lxCusIte
   ++nxRotinas
EndIf
If lxResPO
   ++nxRotinas
EndIf
If lxResCC
   ++nxRotinas
EndIf
If lxResDV
   ++nxRotinas
EndIf
//----------------------------------------------------------------------------//
// Posiciona os arquivos de CUSTO
EI1->(DBSETORDER(1))
EI2->(DBSETORDER(1))
If EI1->(!dBSeek(xFilial('EI1')+SW6->W6_HAWB)).or.;
   EI2->(!dBSeek(xFilial('EI2')+SW6->W6_HAWB))
   MsgInfo(STR0018,STR0006) //"É necessário que o CUSTO esteja gravado para ser impresso!."###"Custo Realizado"
   Return
EndIf
nxNR_EI1:=0
nxNR_EI2:=0
EI1->(dBEval({|| nxNR_EI1++},,{|| EI1_FILIAL+EI1_HAWB==xFilial('EI1')+SW6->W6_HAWB}))
EI2->(dBEval({|| nxNR_EI2++},,{|| EI2_FILIAL+EI2_HAWB==xFilial('EI2')+SW6->W6_HAWB}))
EI1->(dBSeek(xFilial('EI1')+SW6->W6_HAWB))
EI2->(dBSeek(xFilial('EI2')+SW6->W6_HAWB))
//----------------------------------------------------------------------------//
// Arquivo termporário
IF GETMV("MV_DIVIS",,.T.)
   xxAux:=If(AvSX3('Y3_COD',3)>AvSX3('Y3_DIVIS',3),AvSX3('Y3_COD',3),AvSX3('Y3_DIVIS',3))
ELSE
   xxAux:=AvSX3('Y3_COD',3)
ENDIF
//
aAdd(axStru1,{"WK1TIPO",	"C",1,0})		  				// 1=PO+CC 2=Centro de Custo 3=Divisao
aAdd(axStru1,{"WK1PEDIDO",	"C",AvSX3('W2_PO_NUM',3),0})	// Número do PO
aAdd(axStru1,{"WK1CODIGO",	"C",xxAux,0})  					// Centro de Custo/Divisao
aAdd(axStru1,{"WK1ITEM",	"C",AvSX3('B1_COD',3),0})		// Código Item
aAdd(axStru1,{"WK1POSICA",	"C",AvSX3('W3_POSICA',3),0})	// Posição Item
aAdd(axStru1,{"WK1DESP",	"C",40,0})		  				// Despesa
aAdd(axStru1,{"WK1VALSEM",	"N",14,2})  					// Valor sem impostos
aAdd(axStru1,{"WK1VALCOM",	"N",14,2})  					// Valor com impostos/Valor Despesa
aAdd(axStru1,{"WK1SPISSIP",	"N",14,2})  					// Valor sem impostos
aAdd(axStru1,{"WK1SPISCIP",	"N",14,2})  					// Valor com impostos/Valor Despesa
aAdd(axStru1,{"WK1VALDES",	"N",14,2})  					// Valor Despesa da variacao cambial para nao gerar o valor em Dolar.(701.702.703)//FCD OS.:0080/02 SO.:0015/02
aAdd(axStru1,{"WK1UN",		"C",02,0})		  				// Unidade
aAdd(axStru1,{"WK1QTDE",	"N",AvSX3('W3_QTDE',3),AvSX3('W3_QTDE',4)})	// Quantidade
aAdd(axStru1,{"WK1FABR",	"C",AvSX3('W3_FABR',3),0})      // Valor com impostos/Valor Despesa  //SO0026/02 SO.:0214/02  FCD
aAdd(axStru1,{"WK1POSIPI",	"C",AvSX3('B1_POSIPI',3),0})	// N.C.M.
aAdd(axStru1,{"WK1EX_NCM",	"C",AvSX3('B1_EX_NCM',3),0})	// EX-NCM
aAdd(axStru1,{"WK1EX_NBM",	"C",AvSX3('B1_EX_NBM',3),0})	// EX_NBM
//Segundo Rogeiro o no. da GI e' igual o no. da PLI - AWR
//Solucao do erro de duplicar as despesas: tamanho do campo
aAdd(axStru1,{"WK1GI_NUM",	"C",AvSX3('W4_PGI_NUM',3),0})	// Número da L.I. do item
nTam:=AvSX3('WN_LOTECTL',3)
aAdd(axStru1,{"WK1_LOTE" ,	"C",nTam,0})	// Número de Lote
aAdd(axStru1,{"WK1_DTVAL",	"D",08,0})	// Validade do Lote
AADD(axStru1,{"WK1PESO", "N",AVSX3("EI2_PESOL",3),AVSX3("EI2_PESOL",4)})
//
//         1         2         3         4         5         6         7         8         9         0
//123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789
//1TOT            PRC                                                                  99999999999999           - Total do Processo
//2XXXXXXXXXXXXXXXXXXXXXXXXX                                                           99999999999999           - Total PO+CC
//3XXXXXXXXXXXXXXXPED                                                                  99999999999999           - Total do PO
//4TOTCC          XXXXXXXXXX                                                           99999999999999           - Total do CC
//5TOTDV          XXXXXXXXXX                                                           99999999999999           - Total da Divisão
//6                                            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX99999999999999           - Despesas do Processo
//7XXXXXXXXXXXXXXX                             XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX99999999999999           - Despesas do PO
//8XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX9999XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX99999999999999XX99999999 - Despesas do Item/CC/PO
//9XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX9999XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX99999999999999XX99999999 -
//
//aAdd(axStru2,{'WK2DOC',		'C',AvSX3('EI1_DOC',3),0})		// Documentos
//
cxArqTrab1 := CriaTrab(axStru1,.T.)

if Select('TRB1') > 0 
	dbSelectArea('TRB1')
	TRB1->(dbCloseArea())
endif

dBUseArea(.T.,, cxArqTrab1,'TRB1',.F.,.F.)

If NetErr()
   MsgBox(STR0019,STR0020,"STOP") //"ERRO DE REDE!."###"Criação de arquivo temporário"
   Return
EndIf
IndRegua('TRB1',(cxArqTrab1+OrdBagExt()),'WK1TIPO+WK1PEDIDO+WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM+LEFT(WK1DESP,3)')

EI2->(Processa({|| MontaTRBa()}))
EI1->(Processa({|| MontaTRBb()}))
//
//----------------------------------------------------------------------------//
// Posiciona os arquivos que serao trabalhados
SW7->(dBSeek(xFilial('SW7')+SW6->W6_HAWB))								//--- Item Desembaraco
SW1->(dBSeek(xFilial('SW1')+SW7->(W7_CC+W7_SI_NUM+W7_COD_I)))			//--- Item SI
SW2->(dBSeek(xFilial('SW2')+SW7->W7_PO_NUM))							//--- PO
SYT->(dBSeek(xFilial('SYT')+SW2->W2_IMPORT))							//--- Importadores
SA2->(dBSeek(xFilial('SA2')+SW2->W2_FORN))								//--- Fornecedores
SYQ->(dBSeek(xFilial('SYQ')+SW6->W6_VIA_TRA))							//--- Vias de Transporte
SYR->(dBSeek(xFilial('SYR')+SW6->(W6_VIA_TRA+W6_ORIGEM+W6_DEST)))
xxAux:=SY9->(IndexOrd())
SY9->(dBSetOrder(2))
SY9->(dBSeek(xFilial('SY9')+SYR->YR_DESTINO))							//--- Portos/Aeroportor
SY9->(dBSetOrder(xxAux))
SY4->(dBSeek(xFilial('SY4')+SW6->W6_AGENTE))							//--- Agente
SY5->(dBSeek(xFilial('SY5')+SW6->W6_DESP))								//--- Despachante
If !Empty(SW2->W2_EMISCCA).or.!Empty(SW2->W2_NRCCAMB).or.!Empty(SW2->W2_RECCCAM)
   SA6->(dBSeek(xFilial('SA6')+SW2->(W2_BANCO+W2_AGENCIA)))			//--- BANCOS
   dxVencto	:=	SW2->W2_EMISCCA
   dxContrat	:=	AVCTOD('')
   dxLiquid	:=	SW2->W2_RECCCAM
Else
   SWB->(dBSeek(xFilial('SWB')+SW6->W6_HAWB+If(lCposAdto,"D","")))							//--- CAMBIO
   SA6->(dBSeek(xFilial('SA6')+SWB->(WB_BANCO+WB_AGENCIA)))			//--- BANCOS
   dxVencto	:=	SWB->WB_DT_VEN
   dxContrat:=	SWB->WB_DT_CONT
   dxLiquid	:=	SWB->WB_CA_DT
EndIf
IF !EMPTY(SW6->W6_COND_PA)
   SY6->(dBSeek(xFilial('SY6')+SW6->W6_COND_PA+STR(SW6->W6_DIAS_PA,3,0)))	//--- CONDICAO DE PAGAMENTO
ELSE
   SY6->(dBSeek(xFilial('SY6')+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0)))	//--- CONDICAO DE PAGAMENTO
ENDIF

//--- Continua rotina...
oFont1 :=oFont2 :=oFont3:=oFont4 :=oFont5 :=oFont6 :=NIL
oFont7 :=oFont8 :=oFont9:=oFont10:=oFont11:=aFontes:=NIL
oPrn   :=NIL

PRINT oPrn NAME ""
      oPrn:SetPortrait()
ENDPRINT

AVPRINT oPrn NAME STR0021 //"Emissão do Custo Realizado"
	oFont1 :=oSend(TFont(),'NEW','Arial',      0,08 ,,.F.,,,,,.F.,,,,,,oPrn)
	oFont2 :=oSend(TFont(),'NEW','Arial',      0,08 ,,.T.,,,,,.F.,,,,,,oPrn)
	oFont3 :=oSend(TFont(),'NEW','Arial',      0,09 ,,.T.,,,,,.F.,,,,,,oPrn)
	oFont4 :=oSend(TFont(),'NEW','Arial',      0,10 ,,.F.,,,,,.F.,,,,,,oPrn)
	oFont5 :=oSend(TFont(),'NEW','Arial',      0,10 ,,.T.,,,,,.F.,,,,,,oPrn)
	oFont6 :=oSend(TFont(),'NEW','Arial',      0,13 ,,.T.,,,,,.F.,,,,,,oPrn)
	oFont7 :=oSend(TFont(),'NEW','Arial',      0,18 ,,.T.,,,,,.F.,,,,,,oPrn)
	oFont8 :=oSend(TFont(),'NEW','Courier New',0,09 ,,.T.,,,,,.F.,,,,,,oPrn)
	aFontes:={oFont1,oFont2,oFont3,oFont4,oFont5,oFont6,oFont7}
	AVPAGE
		Processa({|x| lEnd:=x, ICus_CUSTO()})
	AVENDPAGE
	oSend(oFont1,'END')
	oSend(oFont2,'END')
	oSend(oFont3,'END')
	oSend(oFont4,'END')
	oSend(oFont5,'END')
	oSend(oFont6,'END')
	oSend(oFont7,'END')
AVENDPRINT

TRB1->(E_EraseArq(cxArqTrab1))

Return
*=========================*
Static Function MontaTRBa()
*=========================*
LOCAL cLote:=""          
Local nSomPed := 0.00
Local nSomCC := 0.00
Local nSomPRC := 0.00
Local nTxInv  := 1.00 // JBS - 14/12/2004
Local cFilSB1 := xFILIAL("SB1") // JBS - 14/12/2004
Private nValMid:= 0 // JBS - 15/12/2004

ProcRegua(nxNR_EI2)
SW9->(DBSETORDER(1))
Do While EI2->(!Eof()).and.EI2->EI2_FILIAL+EI2->EI2_HAWB==xfilial("EI2")+SW6->W6_HAWB
   nValMid:= 0  // JBS - 15/12/2004
   SW2->(DBSETORDER(1))
   SW2->(DBSEEK(xFILIAL("SW2")+EI2->EI2_PO_NUM))  // LDR - DEVIDO A ALTERACAO DE MIDIA - 19/01/05

   IncProc(STR0022) //"Montando o Arquivo de Trabalho 01/02..."
   cLote   := EI2->EI2_LOTECT
   dDataVal:= EI2->EI2_DTVALI
   //--- Totaliza Processo
   If TRB1->(!dBSeek('1TOT'+Spac(Len(TRB1->WK1PEDIDO)-3)+"PRC"))
      TRB1->(DBAPPEND())
      TRB1->WK1TIPO   :='1'
      TRB1->WK1PEDIDO :='TOT'
      TRB1->WK1CODIGO :='PRC'
   EndIf   
   If TRB1->WK1TIPO == "1"
      If SWW->(DBSeek(xFilial("SWW")+EI2->EI2_DOC+EI2->EI2_SERIE+EI2->EI2_FORNEC+EI2->EI2_LOJA+EI2->EI2_PO_NUM+EI2->EI2_POSICA))
         nSomPRC := 0.00
         Do While !SWW->(EOF()) .AND. xFilial("SWW") == SWW->WW_FILIAL .AND. ;
            SWW->WW_NF_COMP == EI2->EI2_DOC .AND. SWW->WW_SE_NFC == EI2->EI2_SERIE .AND.;
            SWW->WW_FORNECE == EI2->EI2_FORNEC .AND. SWW->WW_LOJA == EI2->EI2_LOJA .AND. ;
            SWW->WW_PO_NUM  == EI2->EI2_PO_NUM .AND. SWW->WW_NR_CONT == EI2->EI2_POSICA
   
            IF SWW->WW_HAWB # SW6->W6_HAWB .OR. SWW->WW_TIPO_NF # "4" .OR. SWW->WW_LOTECTL # cLote 
               SWW->(DBSKIP())
               LOOP
            ENDIF   

            If Left(SWW->WW_DESPESA,3)$"701.702.703"
               nSomPRC += SWW->WW_VALOR 
   	      Endif       
   	      
   	      // EOS - 13/05
           IF SYB->(DbSeek(xFilial("SYB")+LEFT(SWW->WW_DESPESA,AVSX3("WD_DESPESA",3)))).AND.;
             SYB->YB_BASEICM $ cSim
             TRB1->WK1VALCOM  += SWW->WW_VALOR
             TRB1->WK1VALSEM  += SWW->WW_VALOR
             TRB1->WK1SPISCIP += SWW->WW_VALOR
             TRB1->WK1SPISSIP += SWW->WW_VALOR
           ENDIF
   	      
   	     SWW->(DBSKIP())
         EndDo             	
 	     TRB1->WK1VALDES := nSomPRC		   
	     nSomPRC := 0.00		   
	  Endif
   Endif
   TRB1->WK1VALCOM  += EI2->(EI2_VALOR + EI2_VALIPI + EI2_VALICM)+SOMA_PIS_COFINS
   TRB1->WK1VALSEM  += EI2->EI2_VALOR+SOMA_PIS_COFINS
   TRB1->WK1SPISCIP += EI2->(EI2_VALOR + EI2_VALIPI + EI2_VALICM)
   TRB1->WK1SPISSIP += EI2->EI2_VALOR

   //--- Totaliza Centros de Custos dentro do PO

   If TRB1->(!dBSeek('2'+EI2->(EI2_PO_NUM+PadR(EI2_CC,Len(TRB1->WK1CODIGO)))))
      TRB1->(DBAPPEND())
      TRB1->WK1TIPO   :='2'
      TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
      TRB1->WK1CODIGO :=EI2->EI2_CC
   Endif
   If TRB1->WK1TIPO == "2"
      If SWW->(DBSeek(xFilial("SWW")+EI2->EI2_DOC+EI2->EI2_SERIE+EI2->EI2_FORNEC+EI2->EI2_LOJA+EI2->EI2_PO_NUM+EI2->EI2_POSICA))
         nSomCC := 0.00
         Do While !SWW->(EOF()) .AND. xFilial("SWW") == SWW->WW_FILIAL .AND. ;
            SWW->WW_NF_COMP == EI2->EI2_DOC .AND. SWW->WW_SE_NFC == EI2->EI2_SERIE .AND.;
            SWW->WW_FORNECE == EI2->EI2_FORNEC .AND. SWW->WW_LOJA == EI2->EI2_LOJA .AND. ;
            SWW->WW_PO_NUM  == EI2->EI2_PO_NUM .AND. SWW->WW_NR_CONT == EI2->EI2_POSICA
 
            IF SWW->WW_HAWB # SW6->W6_HAWB .OR. SWW->WW_TIPO_NF # "4" .OR. SWW->WW_LOTECTL # cLote// AWR - 22/09/2004 - Estava sem o Teste do Lote
               SWW->(DBSKIP())
               LOOP
            ENDIF   
            If Left(SWW->WW_DESPESA,3)$"701.702.703"
               nSomCC += SWW->WW_VALOR 
            Endif
         
            // EOS - 13/05
            IF SYB->(DbSeek(xFilial("SYB")+LEFT(SWW->WW_DESPESA,AVSX3("WD_DESPESA",3)))).AND.;
               SYB->YB_BASEICM $ cSim
               TRB1->WK1VALCOM  += SWW->WW_VALOR
               TRB1->WK1VALSEM  += SWW->WW_VALOR
               TRB1->WK1SPISCIP += SWW->WW_VALOR
               TRB1->WK1SPISSIP += SWW->WW_VALOR
            ENDIF
         
            SWW->(DBSKIP())
         EndDo             	
         TRB1->WK1VALDES := TRB1->WK1VALDES+nSomCC		   
         nSomCC:= 0.00		   
      Endif
   Endif
   TRB1->WK1VALCOM  += EI2->(EI2_VALOR + EI2_VALIPI + EI2_VALICM)+SOMA_PIS_COFINS
   TRB1->WK1VALSEM  += EI2->EI2_VALOR+SOMA_PIS_COFINS
   TRB1->WK1SPISCIP += EI2->(EI2_VALOR + EI2_VALIPI + EI2_VALICM)
   TRB1->WK1SPISSIP += EI2->EI2_VALOR
   
		
   //--- Totaliza PO
   If TRB1->(!dBSeek('3'+EI2->EI2_PO_NUM+'PED'))
      TRB1->(DBAPPEND())
      TRB1->WK1TIPO   :='3'
      TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
      TRB1->WK1CODIGO :='PED'
   Endif
   If TRB1->WK1TIPO == "3"
      If SWW->(DBSeek(xFilial("SWW")+EI2->EI2_DOC+EI2->EI2_SERIE+EI2->EI2_FORNEC+EI2->EI2_LOJA+EI2->EI2_PO_NUM+EI2->EI2_POSICA))
         nSomped := 0.00 //FCD		
         Do While !SWW->(EOF()) .AND. xFilial("SWW") == SWW->WW_FILIAL .AND. ;
            SWW->WW_NF_COMP == EI2->EI2_DOC .AND. SWW->WW_SE_NFC == EI2->EI2_SERIE .AND.;
            SWW->WW_FORNECE == EI2->EI2_FORNEC .AND. SWW->WW_LOJA == EI2->EI2_LOJA .AND. ;
            SWW->WW_PO_NUM  == EI2->EI2_PO_NUM .AND. SWW->WW_NR_CONT == EI2->EI2_POSICA
 
            IF SWW->WW_HAWB # SW6->W6_HAWB .OR. SWW->WW_TIPO_NF # "4" .OR. SWW->WW_LOTECTL # cLote
               SWW->(DBSKIP())
               LOOP
            ENDIF   
            If Left(SWW->WW_DESPESA,3)$"701.702.703"
               nSomPed += SWW->WW_VALOR 
            Endif
  	         // EOS - 13/05
            IF SYB->(DbSeek(xFilial("SYB")+LEFT(SWW->WW_DESPESA,AVSX3("WD_DESPESA",3)))).AND.;
               SYB->YB_BASEICM $ cSim
               TRB1->WK1VALCOM  += SWW->WW_VALOR
               TRB1->WK1VALSEM  += SWW->WW_VALOR
               TRB1->WK1SPISCIP += SWW->WW_VALOR
               TRB1->WK1SPISSIP += SWW->WW_VALOR
            ENDIF
            SWW->(DBSKIP())
         EndDo             	
         TRB1->WK1VALDES := nSomPed		   
         nSomped := 0.00		   
      Endif
   EndIf
   TRB1->WK1VALCOM  += EI2->(EI2_VALOR + EI2_VALIPI + EI2_VALICM)+SOMA_PIS_COFINS
   TRB1->WK1VALSEM  += EI2->EI2_VALOR+SOMA_PIS_COFINS
   TRB1->WK1SPISCIP += EI2->(EI2_VALOR + EI2_VALIPI + EI2_VALICM)
   TRB1->WK1SPISSIP += EI2->EI2_VALOR


   //--- Totaliza CC
   If lxResCC
      If TRB1->(!dBSeek('4TOTCC'+Space(Len(TRB1->WK1PEDIDO)-5)+EI2->EI2_CC))
         TRB1->(DBAPPEND())
	     TRB1->WK1TIPO   :='4' 
		 TRB1->WK1PEDIDO :='TOTCC'
		 TRB1->WK1CODIGO :=EI2->EI2_CC
      EndIf
      If TRB1->WK1TIPO == "4"
         If SWW->(DBSeek(xFilial("SWW")+EI2->EI2_DOC+EI2->EI2_SERIE+EI2->EI2_FORNEC+EI2->EI2_LOJA+EI2->EI2_PO_NUM+EI2->EI2_POSICA))
            nSomCC := 0.00
            Do While !SWW->(EOF()) .AND. xFilial("SWW") == SWW->WW_FILIAL .AND. ;
               SWW->WW_NF_COMP == EI2->EI2_DOC .AND. SWW->WW_SE_NFC == EI2->EI2_SERIE .AND.;
               SWW->WW_FORNECE == EI2->EI2_FORNEC .AND. SWW->WW_LOJA == EI2->EI2_LOJA .AND. ;
               SWW->WW_PO_NUM  == EI2->EI2_PO_NUM  .AND. SWW->WW_NR_CONT == EI2->EI2_POSICA

               IF SWW->WW_HAWB # SW6->W6_HAWB .OR. SWW->WW_TIPO_NF # "4" .OR. SWW->WW_LOTECTL # cLote 
                  SWW->(DBSKIP())
                  LOOP
               ENDIF   

               If Left(SWW->WW_DESPESA,3)$"701.702.703"
                  nSomCC += SWW->WW_VALOR 
      	      Endif       
   	        
               // EOS - 13/05
               IF SYB->(DbSeek(xFilial("SYB")+LEFT(SWW->WW_DESPESA,AVSX3("WD_DESPESA",3)))).AND.;
                  SYB->YB_BASEICM $ cSim
                  TRB1->WK1VALCOM  += SWW->WW_VALOR // JBS 17/06/2004
                  TRB1->WK1VALSEM  += SWW->WW_VALOR // JBS 17/06/2004
                  TRB1->WK1SPISCIP += SWW->WW_VALOR
                  TRB1->WK1SPISSIP += SWW->WW_VALOR
               ENDIF
               SWW->(DBSKIP())
            EndDo             	
 	         TRB1->WK1VALDES := nSomCC		   
	         nSomCC := 0.00		   
   	   Endif
	  Endif
      TRB1->WK1VALCOM  += EI2->(EI2_VALOR + EI2_VALIPI + EI2_VALICM)+SOMA_PIS_COFINS
      TRB1->WK1VALSEM  += EI2->EI2_VALOR+SOMA_PIS_COFINS
      TRB1->WK1SPISCIP += EI2->(EI2_VALOR + EI2_VALIPI + EI2_VALICM)
      TRB1->WK1SPISSIP += EI2->EI2_VALOR
   EndIf
   //--- Totaliza Divisão
   If lxResDV
      SY3->(dBSeek(xFilial('SY3')+EI2->EI2_CC))
	  If TRB1->(!dBSeek('5TOTDV'+Space(Len(TRB1->WK1PEDIDO)-5)+SY3->Y3_DIVIS))
         TRB1->(DBAPPEND())
	     TRB1->WK1TIPO   :='5'
         TRB1->WK1PEDIDO :='TOTDV'
         TRB1->WK1CODIGO :=SY3->Y3_DIVIS
      EndIf
	  TRB1->WK1VALCOM  += EI2->(EI2_VALOR + EI2_VALIPI + EI2_VALICM)+SOMA_PIS_COFINS
	  TRB1->WK1VALSEM  += EI2->EI2_VALOR+SOMA_PIS_COFINS
      TRB1->WK1SPISCIP += EI2->(EI2_VALOR + EI2_VALIPI + EI2_VALICM)
      TRB1->WK1SPISSIP += EI2->EI2_VALOR
   EndIf
   
   //--- Descreve FOB/FRETE/SEGURO/CIF/II/IPI/ICMS/TOTAL IMPOSTOS por Processo
   If TRB1->(!dBSeek('6'+TRB1->(Space(Len(WK1PEDIDO+WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+'101'))
      TRB1->(DBAPPEND())
      TRB1->WK1TIPO :='6'
	  TRB1->WK1DESP	:=STR0023 //"101-F.O.B."
   EndIf
   TRB1->WK1VALCOM += EI2->EI2_FOB_R
   If EI2->EI2_FRETE > 0
      If TRB1->(!dBSeek('6'+TRB1->(Space(Len(WK1PEDIDO+WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+"102"))
         TRB1->(DBAPPEND())
         TRB1->WK1TIPO  :='6'
		 TRB1->WK1DESP	:=STR0024 //"102-FRETE"
      EndIf
      TRB1->WK1VALCOM += EI2->EI2_FRETE
   EndIf
   
   If EI2->EI2_SEGURO > 0
      If TRB1->(!dBSeek('6'+TRB1->(Space(Len(WK1PEDIDO+WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+"103"))
         TRB1->(DBAPPEND())
	     TRB1->WK1TIPO  :='6'
		 TRB1->WK1DESP	:=STR0025 //"103-SEGURO"
      EndIf
      TRB1->WK1VALCOM += EI2->EI2_SEGURO
   Endif
   
   If TRB1->(!dBSeek("6"+TRB1->(Space(Len(WK1PEDIDO+WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+TOT_CIF))
      TRB1->(DBAPPEND())                                                                          
      TRB1->WK1TIPO :="6"
	  TRB1->WK1DESP	:=TOT_CIF+"-C.I.F."  //STR0026 //"104-C.I.F."
   EndIf
   TRB1->WK1VALCOM += EI2->EI2_CIF
   
   If EI2->EI2_IIVAL > 0
      If TRB1->(!dBSeek("6"+TRB1->(Space(Len(WK1PEDIDO+WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+"201"))
         TRB1->(DBAPPEND())
	     TRB1->WK1TIPO  :="6"
		 TRB1->WK1DESP	:=STR0027 //"201-I.I."
	  EndIf
      TRB1->WK1VALCOM += EI2->EI2_IIVAL
   EndIf

   If EI2->EI2_IPIVAL > 0
      If TRB1->(!dBSeek("6"+TRB1->(Space(Len(WK1PEDIDO+WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+"202"))
         TRB1->(DBAPPEND())
	     TRB1->WK1TIPO  :="6"
		 TRB1->WK1DESP	:=STR0028 //"202-I.P.I."
      EndIf
      TRB1->WK1VALCOM += EI2->EI2_IPIVAL
   EndIf

   If EI2->EI2_VL_ICM > 0
      If TRB1->(!dBSeek("6"+TRB1->(Space(Len(WK1PEDIDO+WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+"203"))
         TRB1->(DBAPPEND())
	     TRB1->WK1TIPO  :="6"
		 TRB1->WK1DESP	:=STR0029 //"203-I.C.M.S."
	  EndIf
      TRB1->WK1VALCOM += EI2->EI2_VL_ICM
   EndIf

   IF lMV_PIS_EIC
      If !EMPTY(EI2->EI2_VLRPIS)
        If TRB1->(!dBSeek("6"+TRB1->(Space(Len(WK1PEDIDO+WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+DESPESA_PIS))
            TRB1->(DBAPPEND())
	        TRB1->WK1TIPO:="6"
            TRB1->WK1DESP:=DESPESA_PIS+"-P.I.S."
         EndIf
         TRB1->WK1VALCOM += EI2->EI2_VLRPIS
      EndIf
      If !EMPTY(EI2->EI2_VLRCOF)
         If TRB1->(!dBSeek("6"+TRB1->(Space(Len(WK1PEDIDO+WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+DESPESA_COFINS))
            TRB1->(DBAPPEND())
 	        TRB1->WK1TIPO:="6"
 	     TRB1->WK1DESP:=DESPESA_COFINS+"-COFINS"
         EndIf
         TRB1->WK1VALCOM += EI2->EI2_VLRCOF
      EndIf
   ENDIF

   If EI2->(EI2_IIVAL+EI2_IPIVAL+EI2_VL_ICM+SOMA_PIS_COFINS) > 0
      If TRB1->(!dBSeek("6"+TRB1->(Space(Len(WK1PEDIDO+WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+TOT_IMPOSTOS))
         TRB1->(DBAPPEND())
         TRB1->WK1TIPO  :="6"
         TRB1->WK1DESP	:=TOT_IMPOSTOS+"-TOTAL IMPOSTOS"
       EndIf
       TRB1->WK1VALCOM += EI2->(EI2_IIVAL+EI2_IPIVAL+EI2_VL_ICM)+SOMA_PIS_COFINS
   EndIf
   
   SB1->(DbSeek(cFilSB1+EI2->EI2_PRODUT)) // JBS - 14/12/2004
   
   IF lExiste_Midia .and. SB1->B1_MIDIA $ cSim  // JBS - 14/12/2004
      IF SW9->(DBSEEK(xFilial("SW9")+EI2->EI2_INVOIC+EI2->EI2_FORNEC))
         nTxInv := SW9->W9_TX_FOB
      ENDIF   
      nValMid := ((EI2->EI2_QUANT*EI2->EI2_PRECO) - (SB1->B1_QTMIDIA * EI2->EI2_QUANT * SW2->W2_VLMIDIA))*nTxInv   //EI2->EI2_FOB_R
      IF nValMid > 0
         xxAux := "MID-FOB MIDIA"
         If TRB1->(!dBSeek("6"+Spac(Len(TRB1->(WK1PEDIDO+WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+Left(xxAux,3)))
            TRB1->(DBAPPEND())
            TRB1->WK1TIPO :="6"
            TRB1->WK1DESP :=xxAux
            TRB1->WK1VALCOM := nValMid
         Else
            TRB1->WK1VALCOM += nValMid
         EndIf
      ENDIF  // JBS - 14/12/2004  
   ENDIF

   //--- Descreve FOB/FRETE/SEGURO/CIF/II/IPI/ICMS/TOTAL IMPOSTOS por P.O.
   If TRB1->(!dBSeek("7"+EI2->EI2_PO_NUM+Space(Len(TRB1->(WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+"101"))
      TRB1->(DBAPPEND())
      TRB1->WK1TIPO   :="7"
	  TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
	  TRB1->WK1DESP	  :=STR0023 //"101-F.O.B."
	EndIf

    TRB1->WK1VALCOM += EI2->EI2_FOB_R

	If EI2->EI2_FRETE > 0
	   If TRB1->(!dBSeek("7"+EI2->EI2_PO_NUM+Space(Len(TRB1->(WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+"102"))
          TRB1->(DBAPPEND())
	      TRB1->WK1TIPO   :="7"
		  TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
		  TRB1->WK1DESP	  :=STR0024 //"102-FRETE"
	   EndIf
       TRB1->WK1VALCOM += EI2->EI2_FRETE
	EndIf                
	
	If EI2_SEGURO > 0
 	   If TRB1->(!dBSeek("7"+EI2->EI2_PO_NUM+Space(Len(TRB1->(WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+"103"))
          TRB1->(DBAPPEND())
          TRB1->WK1TIPO   :="7"
	      TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
		  TRB1->WK1DESP   :=STR0025 //"103-SEGURO"
	   EndIf
	   TRB1->WK1VALCOM += EI2->EI2_SEGURO
	EndIf
	
	If TRB1->(!dBSeek("7"+EI2->EI2_PO_NUM+Space(Len(TRB1->(WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+TOT_CIF))
       TRB1->(DBAPPEND())
	   TRB1->WK1TIPO   :="7"
	   TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
	   TRB1->WK1DESP   :=TOT_CIF+"-C.I.F." //STR0026 //"104-C.I.F."
	EndIf
	TRB1->WK1VALCOM += EI2->EI2_CIF
	
	If EI2->EI2_IIVAL > 0
	   If TRB1->(!dBSeek("7"+EI2->EI2_PO_NUM+Space(Len(TRB1->(WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+"201"))
          TRB1->(DBAPPEND())
		  TRB1->WK1TIPO   :="7"
		  TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
		  TRB1->WK1DESP	  :=STR0027 //"201-I.I."
		EndIf
		TRB1->WK1VALCOM += EI2->EI2_IIVAL
	EndIf                 
	
	If EI2->EI2_IPIVAL > 0
	   If TRB1->(!dBSeek("7"+EI2->EI2_PO_NUM+Space(Len(TRB1->(WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+"202"))
          TRB1->(DBAPPEND())
	 	  TRB1->WK1TIPO   :="7"
		  TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
		  TRB1->WK1DESP	  :=STR0028 //"202-I.P.I."
	   EndIf
       TRB1->WK1VALCOM += EI2->EI2_IPIVAL
	EndIf                
	
	If EI2->EI2_VL_ICM > 0
	   If TRB1->(!dBSeek("7"+EI2->EI2_PO_NUM+Space(Len(TRB1->(WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+"203"))
          TRB1->(DBAPPEND())
	      TRB1->WK1TIPO   :="7"
		  TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
		  TRB1->WK1DESP	  :=STR0029 //"203-I.C.M.S."
	   EndIf
	   TRB1->WK1VALCOM += EI2->EI2_VL_ICM
	EndIf

    IF lMV_PIS_EIC
       If !EMPTY(EI2->EI2_VLRPIS)
          If TRB1->(!dBSeek("7"+EI2->EI2_PO_NUM+Space(Len(TRB1->(WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+DESPESA_PIS))
             TRB1->(DBAPPEND())
 	         TRB1->WK1TIPO  :="7"
             TRB1->WK1PEDIDO:=EI2->EI2_PO_NUM
             TRB1->WK1DESP  :=DESPESA_PIS+"-P.I.S."
           EndIf
           TRB1->WK1VALCOM += EI2->EI2_VLRPIS
       EndIf
       If !EMPTY(EI2->EI2_VLRCOF)
          If TRB1->(!dBSeek("7"+EI2->EI2_PO_NUM+Space(Len(TRB1->(WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+DESPESA_COFINS))
             TRB1->(DBAPPEND())
  	         TRB1->WK1TIPO  :="7"
             TRB1->WK1PEDIDO:=EI2->EI2_PO_NUM
             TRB1->WK1DESP  :=DESPESA_COFINS+"-COFINS"
          EndIf
          TRB1->WK1VALCOM += EI2->EI2_VLRCOF
       EndIf
    ENDIF

	If EI2->(EI2_IIVAL+EI2_IPIVAL+EI2_VL_ICM+SOMA_PIS_COFINS) > 0
	   If TRB1->(!dBSeek("7"+EI2->EI2_PO_NUM+Space(Len(TRB1->(WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+TOT_IMPOSTOS))
          TRB1->(DBAPPEND())
		  TRB1->WK1TIPO   :="7"
		  TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
		  TRB1->WK1DESP   :=TOT_IMPOSTOS+"-TOTAL IMPOSTOS"
		EndIf
	    TRB1->WK1VALCOM += EI2->(EI2_IIVAL+EI2_IPIVAL+EI2_VL_ICM)+SOMA_PIS_COFINS
	EndIf
    IF lExiste_Midia .and. SB1->B1_MIDIA $ cSim  // JBS - 14/12/2004
      IF SW9->(DBSEEK(xFilial("SW9")+EI2->EI2_INVOIC+EI2->EI2_FORNEC))
         nTxInv := SW9->W9_TX_FOB
      ENDIF   
       nValMid := ((EI2->EI2_QUANT*EI2->EI2_PRECO) - (SB1->B1_QTMIDIA * EI2->EI2_QUANT * SW2->W2_VLMIDIA))*nTxInv   //EI2->EI2_FOB_R
       IF nValMid > 0
          xxAux := "MID-FOB MIDIA"
          If TRB1->(!dBSeek("7"+EI2->EI2_PO_NUM+Space(Len(TRB1->(WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+Left(xxAux,3)))
             TRB1->(DBAPPEND())
             TRB1->WK1TIPO   :="7"
	   	     TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
             TRB1->WK1DESP   :=xxAux
             TRB1->WK1VALCOM := nValMid
          Else
             TRB1->WK1VALCOM += nValMid
          EndIf
       ENDIF // JBS - 14/12/2004
    ENDIF   
	
	//--- Descreve FOB/FRETE/SEGURO/CIF/II/IPI/ICMS/TOTAL IMPOSTOS por Item
	SW3->(dBSetOrder(8))
	SW3->(dBSeek(xFilial("SW3")+EI2->(EI2_PO_NUM+EI2_POSICA)))
	SW3->(dBSetOrder(1))
	If TRB1->(!dBSeek("8"+EI2->EI2_PO_NUM+PadR(EI2->EI2_CC,Len(TRB1->WK1CODIGO))+SW3->W3_COD_I+EI2->EI2_POSICA+cLote+EI2->EI2_PGI_NU+"101"))
       TRB1->(DBAPPEND())
	   TRB1->WK1TIPO   :="8"
	   TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
	   TRB1->WK1CODIGO :=EI2->EI2_CC
	   TRB1->WK1ITEM   :=SW3->W3_COD_I
	   TRB1->WK1POSICA :=EI2->EI2_POSICA
	   TRB1->WK1_LOTE  :=cLote
	   TRB1->WK1DESP   :=STR0023 //"101-F.O.B."
	   TRB1->WK1GI_NUM :=EI2->EI2_PGI_NU
	EndIf
    TRB1->WK1PESO   += EI2->EI2_PESOL
      TRB1->WK1VALCOM += EI2->EI2_FOB_R
	
	If EI2->EI2_FRETE > 0
	   If TRB1->(!dBSeek("8"+EI2->EI2_PO_NUM+PadR(EI2->EI2_CC,Len(TRB1->WK1CODIGO))+SW3->W3_COD_I+EI2->EI2_POSICA+cLote+EI2->EI2_PGI_NU+"102"))
          TRB1->(DBAPPEND())
	 	  TRB1->WK1TIPO   :="8"
		  TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
		  TRB1->WK1CODIGO :=EI2->EI2_CC
		  TRB1->WK1ITEM   :=SW3->W3_COD_I
		  TRB1->WK1POSICA :=EI2->EI2_POSICA
          TRB1->WK1_LOTE  :=cLote
		  TRB1->WK1DESP	  :=STR0024 //"102-FRETE"
   		  TRB1->WK1GI_NUM :=EI2->EI2_PGI_NU
		EndIf
		TRB1->WK1VALCOM += EI2->EI2_FRETE
        TRB1->WK1PESO   += EI2->EI2_PESOL
	EndIf                  
	
	If EI2->EI2_SEGURO > 0
	   If TRB1->(!dBSeek("8"+EI2->EI2_PO_NUM+PadR(EI2->EI2_CC,Len(TRB1->WK1CODIGO))+SW3->W3_COD_I+EI2->EI2_POSICA+cLote+EI2->EI2_PGI_NU+"103"))
          TRB1->(DBAPPEND())
		  TRB1->WK1TIPO   :="8"
		  TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
		  TRB1->WK1CODIGO :=EI2->EI2_CC
		  TRB1->WK1ITEM   :=SW3->W3_COD_I
		  TRB1->WK1POSICA :=EI2->EI2_POSICA
          TRB1->WK1_LOTE  :=cLote
		  TRB1->WK1DESP	  :=STR0025 //"103-SEGURO"
		  TRB1->WK1GI_NUM :=EI2->EI2_PGI_NU
		EndIf
		TRB1->WK1VALCOM += EI2->EI2_SEGURO
        TRB1->WK1PESO   += EI2->EI2_PESOL
	EndIf
	
	If TRB1->(!dBSeek("8"+EI2->EI2_PO_NUM+PadR(EI2->EI2_CC,Len(TRB1->WK1CODIGO))+SW3->W3_COD_I+EI2->EI2_POSICA+cLote+EI2->EI2_PGI_NU+TOT_CIF))
       TRB1->(DBAPPEND())
	   TRB1->WK1TIPO   :="8"
	   TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
	   TRB1->WK1CODIGO :=EI2->EI2_CC
	   TRB1->WK1ITEM   :=SW3->W3_COD_I
	   TRB1->WK1POSICA :=EI2->EI2_POSICA
       TRB1->WK1_LOTE  :=cLote
	   TRB1->WK1DESP   :=TOT_CIF+"-C.I.F"        //STR0026 //"104-C.I.F."
	   TRB1->WK1GI_NUM :=EI2->EI2_PGI_NU
	EndIf
	TRB1->WK1VALCOM += EI2->EI2_CIF
    TRB1->WK1PESO   +=EI2->EI2_PESOL

	If EI2->EI2_IIVAL > 0
	   If TRB1->(!dBSeek("8"+EI2->EI2_PO_NUM+PadR(EI2->EI2_CC,Len(TRB1->WK1CODIGO))+SW3->W3_COD_I+EI2->EI2_POSICA+cLote+EI2->EI2_PGI_NU+"201"))
          TRB1->(DBAPPEND())
		  TRB1->WK1TIPO   :="8"
		  TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
		  TRB1->WK1CODIGO :=EI2->EI2_CC
		  TRB1->WK1ITEM   :=SW3->W3_COD_I
		  TRB1->WK1POSICA :=EI2->EI2_POSICA
          TRB1->WK1_LOTE  :=cLote
		  TRB1->WK1DESP	  :=STR0031+(Alltrim(Str(EI2->EI2_IITX,6,2)))+")" //"201-I.I.  ("
	   	  TRB1->WK1GI_NUM :=EI2->EI2_PGI_NU
	   EndIf
	   TRB1->WK1VALCOM += EI2->EI2_IIVAL
       TRB1->WK1PESO   += EI2->EI2_PESOL
	EndIf                  
	
	If EI2->EI2_IPIVAL > 0
	   If TRB1->(!dBSeek("8"+EI2->EI2_PO_NUM+PadR(EI2->EI2_CC,Len(TRB1->WK1CODIGO))+SW3->W3_COD_I+EI2->EI2_POSICA+cLote+EI2->EI2_PGI_NU+"202"))
          TRB1->(DBAPPEND())
	      TRB1->WK1TIPO   :="8"
		  TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
		  TRB1->WK1CODIGO :=EI2->EI2_CC
		  TRB1->WK1ITEM   :=SW3->W3_COD_I
		  TRB1->WK1POSICA :=EI2->EI2_POSICA
          TRB1->WK1_LOTE  :=cLote
		  TRB1->WK1DESP	  :=STR0032+(Alltrim(Str(EI2->EI2_IPITX,6,2)))+")" //"202-I.P.I.  ("
		  TRB1->WK1GI_NUM :=EI2->EI2_PGI_NU
	   EndIf
       TRB1->WK1VALCOM += EI2->EI2_IPIVAL
  	   TRB1->WK1PESO   += EI2->EI2_PESOL
	EndIf                 
	
	If EI2->EI2_VL_ICM > 0
	   If TRB1->(!dBSeek("8"+EI2->EI2_PO_NUM+PadR(EI2->EI2_CC,Len(TRB1->WK1CODIGO))+SW3->W3_COD_I+EI2->EI2_POSICA+cLote+EI2->EI2_PGI_NU+"203"))
          TRB1->(DBAPPEND())
		  TRB1->WK1TIPO   :="8"
		  TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
		  TRB1->WK1CODIGO :=EI2->EI2_CC
		  TRB1->WK1ITEM   :=SW3->W3_COD_I
		  TRB1->WK1POSICA :=EI2->EI2_POSICA
          TRB1->WK1_LOTE  :=cLote
		  TRB1->WK1DESP	  :=STR0033+(Alltrim(Str(EI2->EI2_ICMS_A,6,2)))+")" //"203-I.C.M.S.  ("
		  TRB1->WK1GI_NUM :=EI2->EI2_PGI_NU
	   EndIf
	   TRB1->WK1VALCOM += EI2->EI2_VL_ICM
	   TRB1->WK1PESO   += EI2->EI2_PESOL
	EndIf                 

    IF lMV_PIS_EIC
       If !EMPTY(EI2->EI2_VLRPIS)
	      If TRB1->(!dBSeek("8"+EI2->EI2_PO_NUM+PadR(EI2->EI2_CC,Len(TRB1->WK1CODIGO))+SW3->W3_COD_I+EI2->EI2_POSICA+cLote+EI2->EI2_PGI_NU+DESPESA_PIS))
             TRB1->(DBAPPEND())
 	         TRB1->WK1TIPO  :="8"
             TRB1->WK1PEDIDO:=EI2->EI2_PO_NUM
             TRB1->WK1CODIGO:=EI2->EI2_CC
             TRB1->WK1ITEM  :=SW3->W3_COD_I
             TRB1->WK1POSICA:=EI2->EI2_POSICA
             TRB1->WK1_LOTE :=cLote
             TRB1->WK1GI_NUM:=EI2->EI2_PGI_NU
             TRB1->WK1DESP  :=DESPESA_PIS+"-P.I.S."
           EndIf
           TRB1->WK1VALCOM += EI2->EI2_VLRPIS
     	    TRB1->WK1PESO   += EI2->EI2_PESOL
       EndIf
       If !EMPTY(EI2->EI2_VLRCOF)
          If TRB1->(!dBSeek("8"+EI2->EI2_PO_NUM+PadR(EI2->EI2_CC,Len(TRB1->WK1CODIGO))+SW3->W3_COD_I+EI2->EI2_POSICA+cLote+EI2->EI2_PGI_NU+DESPESA_COFINS))
             TRB1->(DBAPPEND())
  	         TRB1->WK1TIPO  :="8"
             TRB1->WK1PEDIDO:=EI2->EI2_PO_NUM
             TRB1->WK1CODIGO:=EI2->EI2_CC
             TRB1->WK1ITEM  :=SW3->W3_COD_I
             TRB1->WK1POSICA:=EI2->EI2_POSICA
             TRB1->WK1_LOTE :=cLote
             TRB1->WK1GI_NUM:=EI2->EI2_PGI_NU
             TRB1->WK1DESP  :=DESPESA_COFINS+"-COFINS"
          EndIf
          TRB1->WK1VALCOM += EI2->EI2_VLRCOF
          TRB1->WK1PESO   += EI2->EI2_PESOL
       EndIf
    ENDIF
	
	If EI2->(EI2_IIVAL+EI2_IPIVAL+EI2_VL_ICM+SOMA_PIS_COFINS) > 0
	   If TRB1->(!dBSeek("8"+EI2->EI2_PO_NUM+PadR(EI2->EI2_CC,Len(TRB1->WK1CODIGO))+SW3->W3_COD_I+EI2->EI2_POSICA+cLote+EI2->EI2_PGI_NU+TOT_IMPOSTOS))
          TRB1->(DBAPPEND())
		  TRB1->WK1TIPO   :="8"
		  TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
		  TRB1->WK1CODIGO :=EI2->EI2_CC
		  TRB1->WK1ITEM   :=SW3->W3_COD_I
		  TRB1->WK1POSICA :=EI2->EI2_POSICA
          TRB1->WK1_LOTE  :=cLote
		  TRB1->WK1DESP	  :=TOT_IMPOSTOS+"-TOTAL IMPOSTOS"
		  TRB1->WK1GI_NUM :=EI2->EI2_PGI_NU
       EndIf
	   TRB1->WK1VALCOM += EI2->(EI2_IIVAL+EI2_IPIVAL+EI2_VL_ICM)+SOMA_PIS_COFINS
  	   TRB1->WK1PESO   += EI2->EI2_PESOL
	EndIf
	// JBS - 15/12/2004 - Inicio
    IF lExiste_Midia .and. SB1->B1_MIDIA $ cSim
      IF SW9->(DBSEEK(xFilial("SW9")+EI2->EI2_INVOIC+EI2->EI2_FORNEC))
         nTxInv := SW9->W9_TX_FOB
      ENDIF   
       nValMid := ((EI2->EI2_QUANT*EI2->EI2_PRECO) - (SB1->B1_QTMIDIA * EI2->EI2_QUANT * SW2->W2_VLMIDIA))*nTxInv   //EI2->EI2_FOB_R
       IF nValMid > 0
          xxAux := "MID-FOB MIDIA"
          If TRB1->(!dBSeek("8"+EI2->EI2_PO_NUM+PadR(EI2->EI2_CC,Len(TRB1->WK1CODIGO))+SW3->W3_COD_I+EI2->EI2_POSICA+cLote+EI2->EI2_PGI_NU+Left(xxAux,3)))
             TRB1->(DBAPPEND())
		     TRB1->WK1TIPO   :="8"
		     TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
		     TRB1->WK1CODIGO :=EI2->EI2_CC
		     TRB1->WK1ITEM   :=SW3->W3_COD_I
		     TRB1->WK1POSICA :=EI2->EI2_POSICA
             TRB1->WK1_LOTE  :=CLOTE
             TRB1->WK1DESP   :=xxAux
		     TRB1->WK1GI_NUM :=EI2->EI2_PGI_NU
             TRB1->WK1VALCOM :=nValMid
             TRB1->WK1PESO   :=EI2->EI2_PESOL
         Else
             TRB1->WK1VALCOM +=nValMid
    	     TRB1->WK1PESO   +=EI2->EI2_PESOL
       ENDIF 
    ENDIF // JBS - 15/12/2004 - Fim
   ENDIF
	If TRB1->(!dBSeek("9"+EI2->EI2_PO_NUM+PadR(EI2->EI2_CC,Len(TRB1->WK1CODIGO))+SW3->W3_COD_I+EI2->EI2_POSICA+cLote+EI2->EI2_PGI_NU))
       TRB1->(DBAPPEND())
       TRB1->WK1TIPO   :="9"
	   TRB1->WK1PEDIDO :=EI2->EI2_PO_NUM
	   TRB1->WK1CODIGO :=EI2->EI2_CC
	   TRB1->WK1ITEM   :=SW3->W3_COD_I
	   TRB1->WK1POSICA :=EI2->EI2_POSICA
       TRB1->WK1_LOTE  :=cLote
	   TRB1->WK1_DTVAL :=dDataVal
	   TRB1->WK1UN	   :=BUSCA_UM(SW3->W3_COD_I+SW3->W3_FABR +SW3->W3_FORN,SW3->W3_CC+SW3->W3_SI_NUM)//EI2->EI2_UNI
	   TRB1->WK1FABR   :=SW3->W3_FABR
	   TRB1->WK1POSIPI :=EI2->EI2_TEC
	   TRB1->WK1EX_NCM :=EI2->EI2_EX_NCM
	   TRB1->WK1EX_NBM :=EI2->EI2_EX_NBM
  	   TRB1->WK1GI_NUM :=EI2->EI2_PGI_NU
   EndIf
   If TRB1->WK1TIPO == "9"
       SWW->(DBSETORDER(1))
       If SWW->(DBSeek(xFilial("SWW")+EI2->EI2_DOC+EI2->EI2_SERIE+EI2->EI2_FORNEC+EI2->EI2_LOJA+EI2->EI2_PO_NUM+EI2->EI2_POSICA))
	      nVlrSom := 0.00
         Do While !SWW->(EOF()) .AND. xFilial("SWW") == SWW->WW_FILIAL .AND. ;
            SWW->WW_NF_COMP == EI2->EI2_DOC .AND. SWW->WW_SE_NFC == EI2->EI2_SERIE .AND.;
            SWW->WW_FORNECE == EI2->EI2_FORNEC .AND. SWW->WW_LOJA == EI2->EI2_LOJA .AND. ;
            SWW->WW_PO_NUM  == EI2->EI2_PO_NUM .AND. SWW->WW_NR_CONT == EI2->EI2_POSICA
 
            IF SWW->WW_HAWB # SW6->W6_HAWB .OR. SWW->WW_TIPO_NF # "4" .OR. SWW->WW_LOTECTL # cLote// AWR - 22/09/2004 - Estava sem o Teste do Lote
                SWW->(DBSKIP())
                LOOP
             ENDIF
                
	         If Left(SWW->WW_DESPESA,3)$"701.702.703"
	            nVlrSom += SWW->WW_VALOR 
   	         Endif
	         SWW->(DBSKIP())
	      EndDo             
	      TRB1->WK1VALDES := nVlrSom
	      nVlrSom := 0.00
	   Endif                  
	Endif
    TRB1->WK1VALCOM  += EI2->(EI2_CIF + EI2_IIVAL + EI2_VALIPI + EI2_VALICM) + SOMA_PIS_COFINS+IF(lExiste_Midia,nValMid,0)
    TRB1->WK1VALSEM  += EI2->(EI2_CIF + EI2_IIVAL )+ SOMA_PIS_COFINS+IF(lExiste_Midia,nValMid,0)
    TRB1->WK1SPISCIP += EI2->(EI2_CIF + EI2_IIVAL + EI2_VALIPI + EI2_VALICM)+IF(lExiste_Midia,nValMid,0) 
    TRB1->WK1SPISSIP += EI2->(EI2_CIF + EI2_IIVAL )+IF(lExiste_Midia,nValMid,0)
    TRB1->WK1QTDE    += EI2->EI2_QUANT
    TRB1->WK1PESO    += EI2->EI2_PESOL

   IF(ExistBlock("EICDI155"),ExecBlock("EICDI155",.F.,.F.,"MONTA_TRB_A"),) // JBS - 21/05/2004
	EI2->(dBSkip())
EndDo
Return

*=========================*
Static Function MontaTRBb()
*=========================*
LOCAL cLote
ProcRegua(nxNR_EI1)
DO While !EI1->(EOF()) .AND. EI1->(EI1_FILIAL+EI1_HAWB)==xFilial("EI1")+SW6->W6_HAWB
   IncProc(STR0034) //"Montando o Arquivo de Trabalho 02/02..."
   SWW->(dBSeek(xFilial("SWW")+EI1->EI1_DOC))
   Do While SWW->(!Eof()).and.SWW->(WW_FILIAL+WW_NF_COMP)==xFilial("SWW")+EI1->EI1_DOC
      IF SWW->WW_HAWB # SW6->W6_HAWB
         SWW->(DBSKIP())
         LOOP
      ENDIF   
      If SWW->WW_TIPO_NF=="4" //--- Gravado pelo CUSTO
		 xxAux:=If(lxDespDet,SWW->WW_DESPESA,STR0035) //"XXX-OUTRAS DESPESAS"
		 cLote:=SWW->WW_LOTECTL

        // EOS - 13/05
       IF SYB->(DbSeek(xFilial("SYB")+LEFT(SWW->WW_DESPESA,AVSX3("WD_DESPESA",3)))).AND.;
          SYB->YB_BASEIMP $ cSim
          xxAux:="105-DESPESA BASE II"
       ENDIF
			
		 If TRB1->(!dBSeek("6"+Spac(Len(TRB1->(WK1PEDIDO+WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+Left(xxAux,3)))
            TRB1->(DBAPPEND())
		    TRB1->WK1TIPO :="6"
		    TRB1->WK1DESP :=xxAux
		 EndIf
		 TRB1->WK1VALCOM += SWW->WW_VALOR
		 If !lxDespDet
  		    If left(SWW->WW_DESPESA,3)$"701.702.703"
  		       TRB1->WK1VALDES += SWW->WW_VALOR
  		    Endif
		 Endif
			//
		 If TRB1->(!dBSeek("7"+SWW->WW_PO_NUM+Space(Len(TRB1->(WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM)))+Left(xxAux,3)))
            TRB1->(DBAPPEND())
		    TRB1->WK1TIPO   :="7"
		    TRB1->WK1PEDIDO :=SWW->WW_PO_NUM
		    TRB1->WK1DESP	:=xxAux
         EndIf
	     TRB1->WK1VALCOM += SWW->WW_VALOR
			
		 If !lxDespDet
  		    If left(SWW->WW_DESPESA,3)$"701.702.703"
  		       TRB1->WK1VALDES += SWW->WW_VALOR
  		    Endif
         Endif

		 SW3->(dBSetOrder(8))
		 SW3->(dBSeek(xFilial("SW3")+SWW->(WW_PO_NUM+WW_NR_CONT)))
		 SW3->(dBSetOrder(1))
		 If TRB1->(!dBSeek("8"+SWW->WW_PO_NUM+PadR(SW3->W3_CC,Len(TRB1->WK1CODIGO))+SW3->W3_COD_I+SWW->WW_NR_CONT+cLote+SWW->WW_PGI_NUM+Left(xxAux,3)))
            TRB1->(DBAPPEND())
		    TRB1->WK1TIPO   :="8"
		    TRB1->WK1PEDIDO :=SWW->WW_PO_NUM
		    TRB1->WK1CODIGO :=SW3->W3_CC
		    TRB1->WK1ITEM 	:=SW3->W3_COD_I
		    TRB1->WK1POSICA :=SWW->WW_NR_CONT
            TRB1->WK1_LOTE  :=cLote
            TRB1->WK1DESP	:=xxAux        
		    TRB1->WK1GI_NUM :=SWW->WW_PGI_NUM
		 EndIf
		 TRB1->WK1VALCOM += SWW->WW_VALOR
		 If !lxDespDet
  		    If left(SWW->WW_DESPESA,3)$"701.702.703"
  		       TRB1->WK1VALDES += SWW->WW_VALOR
  		    Endif
         Endif
			
		 If TRB1->(!dBSeek("9"+SWW->WW_PO_NUM+PadR(SW3->W3_CC,Len(TRB1->WK1CODIGO))+SW3->W3_COD_I+SWW->WW_NR_CONT+cLote+SWW->WW_PGI_NUM))
          TRB1->(DBAPPEND())
          TRB1->WK1TIPO   :="9"
		    TRB1->WK1PEDIDO :=SWW->WW_PO_NUM
		    TRB1->WK1CODIGO :=SW3->W3_CC
		    TRB1->WK1ITEM 	:=SW3->W3_COD_I
            TRB1->WK1_LOTE  :=cLote
		    TRB1->WK1POSICA :=SWW->WW_NR_CONT
          TRB1->WK1GI_NUM :=SWW->WW_PGI_NUM
		 EndIf
		 IF !(SYB->YB_BASEIMP $ cSim)
  		    TRB1->WK1VALCOM  += SWW->WW_VALOR
 		    TRB1->WK1VALSEM  += SWW->WW_VALOR
          TRB1->WK1SPISCIP += SWW->WW_VALOR
          TRB1->WK1SPISSIP += SWW->WW_VALOR
 		 Endif
	  EndIf
	  SWW->(dBSkip())
   EndDo
   EI1->(dBSkip())
EndDo
Return

*==========================*
Static FUNCTION ICus_CUSTO()
*==========================*
Local   axDespach	:={0,0,0}
Local	cxObserv	:=MSMM(SW6->W6_OBS,57)
Local	nxLoop		:=0
Private nxTotPrc	:=0.00
Private nxPrcDes    := 0.00 //FCD
Private nVLrDolar:= 0.00,nVlrSom := 0.00 //FCD  OS.: 0080/02 SO.: 0015/02 
//
TRB1->(dBSeek("1TOT"+Space(Len(TRB1->WK1PEDIDO)-3)+"PRC"))
nxTotPrc	:=TRB1->WK1VALCOM  //--- Total do processo com IPI e ICMS
nxPrcDes    :=TRB1->WK1VALDES   //FCD
nxTcIPIICM	:=TRB1->WK1VALCOM  //--- Total do processo com IPI e ICMS
nxTsIPIICM	:=TRB1->WK1VALSEM  //--- Total do processo sem IPI e ICMS
nxTsPIScIPI :=TRB1->WK1SPISCIP  //--- Total do processo com IPI e ICMS
nxTsPISsIPI :=TRB1->WK1SPISSIP  //--- Total do processo sem IPI e ICMS

//
ProcRegua(nxRotinas)
IncProc(STR0036) //"Imprimindo Cabeçalho do Custo..."
If nxPagina #0
   COMECA_PAGINA
Else
   nxLinha	:=0
   nxPagina:=nxPagina+1
   ICus_INICPG()
EndIf
TRACO_NORMAL
ICus_CABEC()
TRACO_NORMAL
nxLinha+=nxIncrem
TRACO_NORMAL
//
IncProc(STR0037) //"Imprimindo Despesas do Processo..."
ICus_DETDESP()
TRACO_NORMAL
If lxCusPO		//--- Custo por P.O.
   IncProc(STR0038) //"Imprimindo Custo por PO..."
   nxLinha+=nxIncrem
   ICus_TitRel(STR0013) //"Custo por P.O."
   nxLinha+=nxIncrem
   TRACO_NORMAL
   ICus_CusPO()
   TRACO_NORMAL
EndIf	
If lxCusIte		//--- Custo por Item
   IncProc(STR0039) //"Imprimindo Custo por Item..."
   nxLinha+=nxIncrem
   ICus_TitRel(STR0014) //"Custo por Item"
   nxLinha+=nxIncrem
   ICus_CusItem()
   TRACO_NORMAL
EndIf
If lxResPO
   IncProc(STR0040) //"Imprimindo Detalhamento do PO..."
   nxLinha+=nxIncrem
   ICus_TitRel(STR0041) //"Detalhe de P.O."
   nxLinha+=nxIncrem
   ICus_DetPO()
   TRACO_NORMAL
EndIf
If lxResCC
   IncProc(STR0042) //"Imprimindo Resumo por Centro de Custo..."
   nxLinha+=nxIncrem
   ICus_TitRel(STR0043) //"Resumo C.C."
   nxLinha+=nxIncrem
   ICus_Resumo("C")
   TRACO_NORMAL
EndIf
If lxResDV
   IncProc(STR0044) //"Imprimindo Resumo por Divisão..."
   nxLinha+=nxIncrem
   ICus_TitRel(STR0045) //"Resumo Divisão"
   nxLinha+=nxIncrem
   ICus_Resumo("D")
   TRACO_NORMAL
EndIf
nxLinha+=nxIncrem
If nxLinha > 3000
   ICus_IMPCAB(" ")
EndIf
IncProc(STR0046) //"Imprimindo Observações..."
TRACO_NORMAL
TRACO_VERT_01
oPrn:Say(nxLinha, 1150, STR0047, aFontes:ARIAL_10_BOLD,,,,2) //"Observações Gerais"
nxLinha+=nxIncrem
TRACO_NORMAL
TRACO_VERT_01
//
If SWD->(dBSeek(xFilial("SWD")+SW6->W6_HAWB+"901"))
   DO WHILE ! SWD->(EOF()) .AND. SWD->WD_FILIAL == xFilial("SWD") .AND.;
      SWD->WD_HAWB == SW6->W6_HAWB .AND. SWD->WD_DESPESA == "901" 
      axDespach[01]+=SWD->WD_VALOR_R
      SWD->(DBSKIP())
   ENDDO
EndIf
If SWD->(dBSeek(xFilial("SWD")+SW6->W6_HAWB+"902"))
   DO WHILE ! SWD->(EOF()) .AND. SWD->WD_FILIAL == xFilial("SWD") .AND.;
      SWD->WD_HAWB == SW6->W6_HAWB .AND. SWD->WD_DESPESA == "902" 
      axDespach[02]+=SWD->WD_VALOR_R
      SWD->(DBSKIP())
   ENDDO
EndIf
If SWD->(dBSeek(xFilial("SWD")+SW6->W6_HAWB+"903"))
   DO WHILE ! SWD->(EOF()) .AND. SWD->WD_FILIAL == xFilial("SWD") .AND.;
      SWD->WD_HAWB == SW6->W6_HAWB .AND. SWD->WD_DESPESA == "903" 
      axDespach[03] +=SWD->WD_VALOR_R
      SWD->(DBSKIP())
   ENDDO
EndIf
//
oPrn:Say(nxLinha,230,STR0048,             aFontes:ARIAL_08_BOLD) //"Adiantamento ao Despachante (R$)"
oPrn:Say(nxLinha,1200,Transf(axDespach[01],"@E 999,999,999,999.99"),aFontes:ARIAL_10_BOLD,,,,1)
nxLinha+=nxIncrem
If nxLinha > 3000
   TRACO_NORMAL
   ICus_IMPCAB("3")
EndIf
//
TRACO_VERT_01
oPrn:Say(nxLinha,230,STR0049,             aFontes:ARIAL_08_BOLD) //"Complementos ao Despachante (R$)"
oPrn:Say(nxLinha,1200,Transf(axDespach[02],"@E 999,999,999,999.99"),aFontes:ARIAL_10_BOLD,,,,1)
nxLinha+=nxIncrem
If nxLinha > 3000
   TRACO_NORMAL
   ICus_IMPCAB("3")
EndIf
//
TRACO_VERT_01
oPrn:Say(nxLinha,230,STR0050,               aFontes:ARIAL_08_BOLD) //"Devoluções do Despachante (R$)"
oPrn:Say(nxLinha,1200,Transf(axDespach[03],"@E 999,999,999,999.99"),aFontes:ARIAL_10_BOLD,,,,1)
nxLinha+=nxIncrem
If nxLinha > 3000
   TRACO_NORMAL
   ICus_IMPCAB("3")
EndIf
TRACO_VERT_01
oPrn:Say(nxLinha,230,STR0051,                                    aFontes:ARIAL_08_BOLD) //"Valor trabalhado com o Despachante (R$)"
oPrn:Say(nxLinha,1200,Transf((axDespach[01]+axDespach[02]-axDespach[03]),"@E 999,999,999,999.99"),aFontes:ARIAL_10_BOLD,,,,1)
nxLinha+=nxIncrem
//
If !Empty(cxObserv)
   For nxLoop:=1 to MlCount(cxObserv,57)
       If !empty(MemoLine(cxObserv,57,nxLoop))
          If nxLinha > 3000
	         TRACO_NORMAL
	         ICus_IMPCAB("3")
          EndIf
	      TRACO_VERT_01
	      If mlCount(cxObserv,57)==nxLoop
	         oPrn:Say(nxLinha,230,MemoLine(cxObserv,57,nxLoop),aFontes:ARIAL_10_BOLD)
          Else
             oPrn:Say(nxLinha,230,AV_Justifica(MemoLine(cxObserv,57,nxLoop)),aFontes:ARIAL_10_BOLD)
	      EndIf
	      nxLinha+=nxIncrem
       EndIf
   Next
EndIf
TRACO_NORMAL
Return

*===========================*
Static FUNCTION ICus_INICPG()
*===========================*
If !Empty(SYT->YT_LOGO) //--- LOGOTIPO do Importador
   oPrn:SayBitmap(nxLinha,0100,AllTrim(SYT->YT_LOGO)+".BMP",0400,0300)
EndIf

oPrn:BOX(nxLinha,     1500,(nxLinha+160),2300)
oPrn:Say((nxLinha+70),1520,STR0052,aFontes:ARIAL_08) //"No.Processo"
oPrn:Say((nxLinha+70),1700,SW6->W6_HAWB            ,aFontes:ARIAL_13_BOLD)
nxLinha+=200
oPrn:Say(nxLinha,     0100,"IE-19",aFontes:ARIAL_09_BOLD) //"CONFORME HDI 001631 P/ WILLER"
oPrn:Say(nxLinha,     1000,STR0006,aFontes:ARIAL_18_BOLD) //"Custo Realizado"
oPrn:Say(nxLinha+30,  1600,STR0053+DATA_MES(dDataBase)+Space(28)+; //"Emitido em "
										STR0054+StrZero(nxPagina,3),	aFontes:ARIAL_09_BOLD) //"Pag."
nxLinha+=100
Return

*==========================*
Static FUNCTION ICus_CABEC()
*==========================*
//Local nxLoop	:=0
//Local cxInvoice	:=''
//Local nxTotInv	:=0
Local cxCondPA
Local xxAux,I,ICOL
TRACO_VERT_01
nxLinha+=nxIncrem
TRACO_VERT_01
oPrn:Say(nxLinha, 055, STR0055,	aFontes:ARIAL_08) //"Importador"
oPrn:Say(nxLinha, 230, SYT->YT_NOME,	aFontes:ARIAL_08_BOLD)
oPrn:Say(nxLinha,1270, STR0056   ,	aFontes:ARIAL_08) //"Embarque"
oPrn:Say(nxLinha,1490, DATA_MES(SW6->W6_DT_EMB),aFontes:ARIAL_08_BOLD)
nxLinha+=nxIncrem
TRACO_VERT_01
//oPrn:Say(nxLinha, 055, STR0057 ,	aFontes:ARIAL_08) //"Fornecedor"
//oPrn:Say(nxLinha, 230, SA2->A2_NOME,	aFontes:ARIAL_08_BOLD)
oPrn:Say(nxLinha,1270, STR0058,	aFontes:ARIAL_08) //"Vcto.Câmbio"
If SWB->(!Eof())
   oPrn:Say(nxLinha,1490, DATA_MES(dxVencto),aFontes:ARIAL_08_BOLD)
EndIf
//nxLinha+=nxIncrem
TRACO_VERT_01
oPrn:Say(nxLinha, 055, STR0059,aFontes:ARIAL_08) //"Via Transp."
oPrn:Say(nxLinha, 230, Alltrim(SYQ->YQ_DESCR)+" from "+AllTrim(SYR->YR_CID_ORI)+;
		" to "+SY9->Y9_DESCR+"    ("+SYR->(YR_ORIGEM+" - "+YR_DESTINO)+")",aFontes:ARIAL_08_BOLD)
nxLinha+=nxIncrem
TRACO_VERT_01
oPrn:Say(nxLinha, 055, STR0061      ,aFontes:ARIAL_08) //"Agente"
oPrn:Say(nxLinha, 230, SY4->Y4_NOME             ,aFontes:ARIAL_08_BOLD)                          
oPrn:Say(nxLinha,1270, STR0060,aFontes:ARIAL_08) //"Dt.Contrato"
If SWB->(!Eof())
   oPrn:Say(nxLinha,1490, DATA_MES(dxContrat),aFontes:ARIAL_08_BOLD)
EndIf
nxLinha+=nxIncrem
TRACO_VERT_01
oPrn:Say(nxLinha,0055, STR0063,aFontes:ARIAL_08) //"Despachante"
oPrn:Say(nxLinha,0230, SY5->Y5_NOME            ,aFontes:ARIAL_08_BOLD)
oPrn:Say(nxLinha,1270, STR0062,aFontes:ARIAL_08) //"Banco Câmbio"
If SWB->(!Eof())
   oPrn:Say(nxLinha,1490, SA6->A6_NOME          ,aFontes:ARIAL_08_BOLD)
EndIf
nxLinha+=nxIncrem
TRACO_VERT_01
//oPrn:Say(nxLinha, 055, STR0065+AllTrim(SW6->W6_INCOTER),												aFontes:ARIAL_08) //"Total "
//oPrn:Say(nxLinha, 230, "("+SW6->W6_FOBMOE+")  "+Transf(SW6->(W6_FOB_TOT+W6_PACKING+W6_INLAND-W6_DESCONTO),"@E 999,999,999,999.99"),			aFontes:ARIAL_08_BOLD)
//oPrn:Say(nxLinha,1270, STR0066,aFontes:ARIAL_08) //"Tx.Moeda"
//oPrn:Say(nxLinha,1490, "("+SW6->W6_FOBMOE+")  "+Transf(SW6->W6_TX_FOB,"@E 999,999.99999999")   ,aFontes:ARIAL_08_BOLD)
//nxLinha+=nxIncrem
//TRACO_VERT_01                       

//IF !EMPTY(SW6->W6_VL_FRET)
IF SW6->(W6_VlFrePP+W6_VlFreCC) > 0		//Johann - 02/07/2005
   oPrn:Say(nxLinha, 055, STR0067,																		aFontes:ARIAL_08) //"Frete"
   oPrn:Say(nxLinha, 230, "("+SW6->W6_FREMOED+")  "+Transf(ValorFrete(SW6->W6_HAWB,,,2,),"@E 999,999,999,999.99"),	aFontes:ARIAL_08_BOLD)
   oPrn:Say(nxLinha,1270, STR0068,aFontes:ARIAL_08) //"Tx.Frete"
   oPrn:Say(nxLinha,1490, "("+SW6->W6_FREMOED+")  "+Transf(SW6->W6_TX_FRET,"@E 999,999.99999999")   ,aFontes:ARIAL_08_BOLD)
   nxLinha+=nxIncrem
   TRACO_VERT_01
ENDIF
IF !EMPTY(SW6->W6_VL_USSE)
   oPrn:Say(nxLinha, 055, STR0069,																	aFontes:ARIAL_08) //"Seguro"
   oPrn:Say(nxLinha, 230, "("+SW6->W6_SEGMOED+")  "+Transf(SW6->W6_VL_USSE,"@E 999,999,999,999.99"),	aFontes:ARIAL_08_BOLD)
   oPrn:Say(nxLinha,1270, STR0070,																	aFontes:ARIAL_08) //"Tx.Seguro"
   oPrn:Say(nxLinha,1490, Transf(SW6->W6_TX_SEG,"@E 999,999.99999999"),aFontes:ARIAL_08_BOLD)
   nxLinha+=nxIncrem
   TRACO_VERT_01
EndIf
oPrn:Say(nxLinha, 055, STR0071,						aFontes:ARIAL_08) //"D.I."
oPrn:Say(nxLinha, 230, SW6->W6_DI_NUM,				aFontes:ARIAL_08_BOLD)    
oPrn:Say(nxLinha,1270, STR0064,aFontes:ARIAL_08) //"Dt.Liq.Câmbio"
oPrn:Say(nxLinha,1490, DATA_MES(dxLiquid)   ,aFontes:ARIAL_08_BOLD)	
nxLinha+=nxIncrem
TRACO_VERT_01
If !Empty(SW6->W6_NF_ENT)
   oPrn:Say(nxLinha, 055, STR0073,					aFontes:ARIAL_08) //"NFE/Série"
   oPrn:Say(nxLinha, 230, SW6->(W6_NF_ENT+"/"+W6_SE_NF),aFontes:ARIAL_08_BOLD)
   oPrn:Say(nxLinha,1270, STR0074,					aFontes:ARIAL_08) //"Dt.NFE"
   oPrn:Say(nxLinha,1490, DtoC(SW6->W6_DT_NF),aFontes:ARIAL_08_BOLD)
   nxLinha+=nxIncrem
   TRACO_VERT_01
EndIf	
//nxLinha+=nxIncrem
//TRACO_VERT_01
oPrn:Say(nxLinha,0055, STR0171,aFontes:ARIAL_08) //"Transportadora"
oPrn:Say(nxLinha,0230, E_FIELD("W6_TRANS","A4_NOME") ,aFontes:ARIAL_08_BOLD)
oPrn:Say(nxLinha,1270, STR0072,				aFontes:ARIAL_08) //"Tx.US$ D.I."
oPrn:Say(nxLinha,1490, Transf(SW6->W6_TX_US_D,"@E 999,999.99999999"),aFontes:ARIAL_08_BOLD)
nxLinha+=nxIncrem                                                                          
TRACO_VERT_01
oPrn:Say(nxLinha,1270, STR0172,aFontes:ARIAL_08) //"N.F.Transp."
oPrn:Say(nxLinha,1490, SW6->W6_NF_TRAN   ,aFontes:ARIAL_08_BOLD)	
nxLinha+=nxIncrem
TRACO_VERT_01
/*
oPrn:Say(nxLinha, 055, STR0075,aFontes:ARIAL_08) //"Cond.Pagto."
If !Empty(	SW6->W6_DT_ENTR)
	oPrn:Say(nxLinha,1270, STR0076,		aFontes:ARIAL_08) //"Dt.Entrega"
	oPrn:Say(nxLinha,1490, DtoC(SW6->W6_DT_ENTR),aFontes:ARIAL_08_BOLD)
EndIf
For xxAux:=1 to MlCount(cxCondPA,48)
    If !empty(MemoLine(cxCondPA,48,xxAux))
       If xxAux>1
	      TRACO_VERT_01
       EndIf
	   If mlCount(cxCondPA,48)==xxAux
	      oPrn:Say(nxLinha,230,MemoLine(cxCondPA,48,xxAux),aFontes:ARIAL_08_BOLD)
	   Else
	      oPrn:Say(nxLinha,230,AV_Justifica(MemoLine(cxCondPA,48,xxAux)),aFontes:ARIAL_08_BOLD)
	   EndIf
	   nxLinha+=nxIncrem
    EndIf
Next
*/

//
TRACO_VERT_01
nxLinha+=nxIncrem
TRACO_VERT_01

SW9->(dBSetOrder(3))
SW9->(dBSeek(xFilial("SW9")+SW6->W6_HAWB))
Do While !SW9->(Eof()).and.SW9->W9_FILIAL+SW9->W9_HAWB==xFilial("SW9")+SW6->W6_HAWB
   
   //JAP - INVOICE
   oPrn:Say(nxLinha, 230, SW9->W9_INVOICE,	aFontes:ARIAL_08_BOLD) 
   oPrn:Say(nxLinha, 055,STR0077,aFontes:ARIAL_08)
   
   //JAP - FORNECEDOR 
   TRACO_VERT_01
   //nxLinha+=nxIncrem 
   SA2->(dBSetOrder(1))
   IF SA2->(dBSeek(xFilial("SA2")+SW9->W9_FORN))
      oPrn:Say(nxLinha, 849, STR0057 ,	aFontes:ARIAL_08) //"Fornecedor"
      oPrn:Say(nxLinha, 1010, SA2->A2_NOME,	aFontes:ARIAL_08_BOLD)
   ENDIF 
   SA2->(dBSkip())
                  
   //JAP - CONDICAO DE PAGAMENTO
   TRACO_VERT_01
   nxLinha+=nxIncrem
   oPrn:Say(nxLinha, 055, STR0075,aFontes:ARIAL_08) //"Cond.Pagto."
   //oPrn:Say(nxLinha, 230, SW9->W9_COND_PA,	aFontes:ARIAL_08_BOLD)
   
   IF SY6->(dBSeek(xFilial("SY6")+SW9->W9_COND_PA))
      cxCondPA	:=MSMM(SY6->Y6_DESC_P,96)
      For xxAux:=1 to MlCount(cxCondPA,96)
         If !empty(MemoLine(cxCondPA,96,xxAux))
            If xxAux>1
	           TRACO_VERT_01
            EndIf
	      If mlCount(cxCondPA,96)==xxAux
	         oPrn:Say(nxLinha,230,MemoLine(cxCondPA,96,xxAux),aFontes:ARIAL_08_BOLD)
	         TRACO_VERT_01
	      Else
	         oPrn:Say(nxLinha,230,AV_Justifica(MemoLine(cxCondPA,96,xxAux)),aFontes:ARIAL_08_BOLD)
             TRACO_VERT_01
	      EndIf
	      nxLinha+=nxIncrem
       EndIf
      Next
   ENDIF          
   SY6->(dBSkip())
    
   
   //JAP - DT DE ENTREGA
   TRACO_VERT_01
   nxLinha+=nxIncrem
   If !Empty(SW6->W6_DT_ENTR)
      oPrn:Say(nxLinha,1270, STR0076,		aFontes:ARIAL_08) //"Dt.Entrega"
	  oPrn:Say(nxLinha,1490, DtoC(SW6->W6_DT_ENTR),aFontes:ARIAL_08_BOLD)
   EndIf

   SW9->(dBSkip())
   
   
EndDo

//cxInvoice:= LEFT(cxInvoice,LEN(cxInvoice)-2)
//oPrn:Say(nxLinha, 055,STR0077,aFontes:ARIAL_08) //"No.Invoices"
//For nxLoop:=1 To MlCount(Memoline(cxInvoice,40))
//	If !Empty(Memoline(cxInvoice,40,nxLoop))
//		oPrn:Say(nxLinha, 230, Memoline(cxInvoice,40,nxLoop),aFontes:ARIAL_08_BOLD)
//		nxLinha+=nxIncrem
//		TRACO_VERT_01
//	EndIf
//Next                                        

nxLinha-=nxIncrem
aINV:= ConvDespFobMoeda( SW6->W6_HAWB, , ,"FOB_TUDO")
oPrn:Say(nxLinha,1270, STR0078,aFontes:ARIAL_08_BOLD) //"Total das Invoices"
FOR ICOL:=1 TO LEN(aInv)
   FOR I:=1 TO LEN(aInv[ICOL])
     oPrn:Say(nxLinha,1530,aInv[icol,I,1] +" "+Transf(aInv[ICOL,I,2],"@E 999,999,999.99"),aFontes:ARIAL_08_BOLD)
     nxLinha+=nxIncrem
   NEXT                  
NEXT
//TRACO_VERT_01
Return

*============================*
Static FUNCTION ICus_DETDESP()
*============================*
Local nxFOB:=0
If nxLinha >= 3000+nxIncrem
   COMECA_PAGINA
ENDIF
TRACO_NORMAL
TRACO_VERT_01
oPrn:Say(nxLinha,2140, STR0079, aFontes:ARIAL_08_BOLD,,,,1) //"% s/ IPI"
oPrn:Say(nxLinha,2290, STR0080, aFontes:ARIAL_08_BOLD,,,,1) //"% c/ IPI"
nxLinha+=nxIncrem
TRACO_VERT_01
oPrn:Say(nxLinha, 300, STR0081,    aFontes:ARIAL_10_BOLD) //"Despesas"
oPrn:Say(nxLinha,1530, STR0082, aFontes:ARIAL_08_BOLD,,,,1) //"Valor em R$"
oPrn:Say(nxLinha,1790, STR0083,aFontes:ARIAL_08_BOLD,,,,1) //"Valor em US$"
oPrn:Say(nxLinha,1990, STR0084,       aFontes:ARIAL_08_BOLD,,,,1) //"% FOB"
oPrn:Say(nxLinha,2140, STR0085,        aFontes:ARIAL_08_BOLD,,,,1) //"ICMS"
oPrn:Say(nxLinha,2290, STR0085,        aFontes:ARIAL_08_BOLD,,,,1) //"ICMS"
nxLinha+=nxIncrem
TRACO_NORMAL
TRB1->(dBSeek("6"))
nVlrSom := 0.00 //FCD OS.: 0080/02 SO.:0015/02
While TRB1->(!Eof()).and.TRB1->WK1TIPO=="6"
	If nxLinha >= 3000
       TRACO_NORMAL
       ICus_IMPCAB("5")
	EndIf
	TRACO_VERT_01
    RetCamb()//FCD OS.:0080/02 SO.:0015/02	        
    If !lxDespDet
      nVlrDolar := nVlrDolar - TRB1->WK1VALDES
    Endif
	oPrn:Say(nxLinha,  55, TRB1->(If(Left(WK1DESP,3)$ DESPS_TOTS .OR. Left(WK1DESP,3) $ DESP_SEM_COD ,Subs(WK1DESP,5),WK1DESP)),   If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_10_BOLD,aFontes:ARIAL_10))
	oPrn:Say(nxLinha,1530, Transf(TRB1->WK1VALCOM,"@E 999,999,999.99"),                    If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)
	oPrn:Say(nxLinha,1790, Transf(ROUND(nVlrDolar/SW6->W6_TX_US_D,2),"@E 999,999,999.99"),  If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)
	If LEFT(TRB1->WK1DESP,3) == "101"
		oPrn:Say(nxLinha,1990, STR0086,														aFontes:ARIAL_10_BOLD,,,,1) //"BASE"
		nxFOB:=TRB1->WK1VALCOM
	Else
		oPrn:Say(nxLinha,1990, Transf(((TRB1->WK1VALCOM/nxFOB)*100),"@E 9999.999"),			If(LEFT(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)
	EndIf
	If LEFT(TRB1->WK1DESP,3) $ "202.203."+TOT_IMPOSTOS
		oPrn:Say(nxLinha,2140, "- * -",                                                     If(LEFT(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)
	Else
		oPrn:Say(nxLinha,2140, Transf(ROUND((TRB1->WK1VALCOM/nxTsIPIICM)*100,2),"@E 9999.999"),    If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)//s/ ICMS
	EndIf
	oPrn:Say(nxLinha,2290, Transf(((TRB1->WK1VALCOM/nxTcIPIICM)*100),"@E 9999.999"),        If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)//c/ICMS
	nxLinha+=nxIncrem
	If Left(TRB1->WK1DESP,3)$ DESPS_TOTS 
		TRACO_NORMAL
	EndIf
    If !lxDespDet.AND.Left(TRB1->WK1DESP,3)$"XXX"            
       nVlrSom := TRB1->WK1VALDES
    Endif
	TRB1->(dBSkip())
EndDo
If TRB1->WK1TIPO=="9"
   nVlrSom := TRB1->WK1VALDES
Endif
TRACO_NORMAL
TRACO_VERT_01
oPrn:Say(nxLinha,  55, STR0087,                                  aFontes:ARIAL_10_BOLD) //"Total Geral sem IPI/ICMS"
oPrn:Say(nxLinha,1530, Transf(nxTsIPIICM,"@E 999,999,999.99"),                   	aFontes:ARIAL_08_BOLD,,,,1)
oPrn:Say(nxLinha,1790, Transf(ROUND((nxTsIPIICM-nVlrSom)/SW6->W6_TX_US_D,2),"@E 999,999,999.99"), 	aFontes:ARIAL_08_BOLD,,,,1)
oPrn:Say(nxLinha,1990, Transf(((nxTsIPIICM/nxFOB)*100),"@E 9999.999"),     			aFontes:ARIAL_08_BOLD,,,,1)
oPrn:Say(nxLinha,2140, Transf(((nxTsIPIICM/nxTsIPIICM)*100),"@E 9999.999"),       	aFontes:ARIAL_08_BOLD,,,,1)
oPrn:Say(nxLinha,2290, Transf(((nxTsIPIICM/nxTcIPIICM)*100),"@E 9999.999"),       	aFontes:ARIAL_08_BOLD,,,,1)
nxLinha+=nxIncrem
TRACO_VERT_01
oPrn:Say(nxLinha,  55, STR0088, 									aFontes:ARIAL_10_BOLD) //"Total Geral com IPI/ICMS"
oPrn:Say(nxLinha,1530, Transf(nxTcIPIICM,"@E 999,999,999.99"),                   	aFontes:ARIAL_08_BOLD,,,,1)
oPrn:Say(nxLinha,1790, Transf(ROUND((nxTcIPIICM-nVlrSom)/SW6->W6_TX_US_D,2),"@E 999,999,999.99"), 	aFontes:ARIAL_08_BOLD,,,,1)
oPrn:Say(nxLinha,1990, Transf(((nxTcIPIICM/nxFOB)*100),"@E 9999.999"),     			aFontes:ARIAL_08_BOLD,,,,1)
oPrn:Say(nxLinha,2290, Transf(((nxTcIPIICM/nxTcIPIICM)*100),"@E 9999.999"),       	aFontes:ARIAL_08_BOLD,,,,1)

IF lMV_PIS_EIC
   nxLinha+=nxIncrem
   TRACO_VERT_01
   oPrn:Say(nxLinha,  55, "Total Geral sem IPI/ICMS sem PIS/COFINS",	aFontes:ARIAL_10_BOLD) //"Total Geral com IPI/ICMS"
   oPrn:Say(nxLinha,1530, Transf(nxTsPISsIPI,"@E 999,999,999.99"),                   	aFontes:ARIAL_08_BOLD,,,,1)
   oPrn:Say(nxLinha,1790, Transf(ROUND((nxTsPISsIPI-nVlrSom)/SW6->W6_TX_US_D,2),"@E 999,999,999.99"), 	aFontes:ARIAL_08_BOLD,,,,1)
   oPrn:Say(nxLinha,1990, Transf(((nxTsPISsIPI/nxFOB)*100),"@E 9999.999"),     			aFontes:ARIAL_08_BOLD,,,,1)
   oPrn:Say(nxLinha,2140, Transf(((nxTsPISsIPI/nxTsPISsIPI)*100),"@E 9999.999"),       	aFontes:ARIAL_08_BOLD,,,,1)
   oPrn:Say(nxLinha,2290, Transf(((nxTsPISsIPI/nxTsPIScIPI)*100),"@E 9999.999"),       	aFontes:ARIAL_08_BOLD,,,,1)
   nxLinha+=nxIncrem
   TRACO_VERT_01
   oPrn:Say(nxLinha,  55, "Total Geral com IPI/ICMS sem PIS/COFINS", 									aFontes:ARIAL_10_BOLD) //"Total Geral com IPI/ICMS"
   oPrn:Say(nxLinha,1530, Transf(nxTsPIScIPI,"@E 999,999,999.99"),                   	aFontes:ARIAL_08_BOLD,,,,1)
   oPrn:Say(nxLinha,1790, Transf(ROUND((nxTsPIScIPI-nVlrSom)/SW6->W6_TX_US_D,2),"@E 999,999,999.99"), 	aFontes:ARIAL_08_BOLD,,,,1)
   oPrn:Say(nxLinha,1990, Transf(((nxTsPIScIPI/nxFOB)*100),"@E 9999.999"),     			aFontes:ARIAL_08_BOLD,,,,1)
   oPrn:Say(nxLinha,2290, Transf(((nxTsPIScIPI/nxTsPIScIPI)*100),"@E 9999.999"),       	aFontes:ARIAL_08_BOLD,,,,1)
ENDIF

nxLinha+=nxIncrem
Return

*==========================*
Static FUNCTION ICus_DetPO()
*==========================*
Local cxPedAnt	:=Spac(Len(TRB1->WK1PEDIDO))
Local cxCCAnt	:=Spac(05)
Local nxTotPed	:=0.00
Local nxTotCC	:=0.00
Local nxCCDes   :=0.00
Local nVlrSomC  :=0.00
Local nVlrSomP  :=0.00

If nxLinha >= 3000
   COMECA_PAGINA
EndIf
ICus_IMPCAB("4")
//
TRB1->(dBSeek("9"))
nVlrSom:= 0.00 //FCD OS.:0080/02 SO.:0015/02
While TRB1->(!Eof()).and.TRB1->WK1TIPO=="9"
	If nxLinha >= 3000-nxIncrem
       TRACO_NORMAL
       COMECA_PAGINA
       ICus_IMPCAB("4")
	EndIf                                                            
	lImprimiu:=.F.
	If !Empty(cxCCAnt).and.cxCCAnt #TRB1->WK1CODIGO .and. nxTotCC > 0
        lImprimiu:=.T.
		TRACO_REDU_02
		TRACO_VERT_01
		oPrn:Say(nxLinha,1270, STR0089+AllTrim(cxCCAnt), aFontes:ARIAL_10_BOLD,,,,1) //"Total do C.Custo - "
		oPrn:Say(nxLinha,1530, Transf(nxTotCC,"@E 999,999,999.99"), aFontes:ARIAL_10_BOLD,,,,1)
		oPrn:Say(nxLinha,1790, Transf(ROUND((nxTotCC-nVlrSomC)/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), aFontes:ARIAL_10_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
		oPrn:Say(nxLinha,2290, Transf(((nxTotCC/nxTotPrc)*100),"@E 999.99"), aFontes:ARIAL_10_BOLD,,,,1)
		oPrn:Say(nxLinha,1990, Transf(((nxTotCC/nxTotCC)*100),"@E 999.99"), aFontes:ARIAL_10_BOLD,,,,1)
		oPrn:Say(nxLinha,2140, Transf(((nxTotCC/nxTotPed)*100),"@E 999.99"), aFontes:ARIAL_10_BOLD,,,,1)
		oPrn:Say(nxLinha,2290, Transf(((nxTotCC/nxTotPrc)*100),"@E 999.99"), aFontes:ARIAL_10_BOLD,,,,1)
		nxLinha+=nxIncrem
		cxCCAnt:=TRB1->WK1CODIGO
		//
		xxAux:=TRB1->(RecNo())
		TRB1->(dBSeek("2"+TRB1->(WK1PEDIDO+WK1CODIGO)))
        nxTotCC:=TRB1->WK1VALCOM  //--- Total do Centro de Custo com IPI e ICMS
        nxCCDes:= TRB1->WK1VALDES //FCD
		TRB1->(dBGoTo(xxAux))
		nVlrSomC := 0.00 //FCD
		//
	EndIf
	If Empty(cxPedAnt).or.cxPedAnt #TRB1->WK1PEDIDO
		If !Empty(cxPedAnt)
			If nxTotCC > 0 .AND. !lImprimiu
				TRACO_REDU_02
				TRACO_VERT_01
				oPrn:Say(nxLinha,1270, STR0089+AllTrim(cxCCAnt), aFontes:ARIAL_10_BOLD,,,,1) //"Total do C.Custo - "
				oPrn:Say(nxLinha,1530, Transf(nxTotCC,"@E 999,999,999.99"), aFontes:ARIAL_10_BOLD,,,,1)
				oPrn:Say(nxLinha,1790, Transf(ROUND((nxTotCC-nxCCDes)/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), aFontes:ARIAL_10_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
				oPrn:Say(nxLinha,2290, Transf(((nxTotCC/nxTotPrc)*100),"@E 999.99"), aFontes:ARIAL_10_BOLD,,,,1)
				oPrn:Say(nxLinha,1990, Transf(((nxTotCC/nxTotCC)*100),"@E 999.99"), aFontes:ARIAL_10_BOLD,,,,1)
				oPrn:Say(nxLinha,2140, Transf(((nxTotCC/nxTotPed)*100),"@E 999.99"), aFontes:ARIAL_10_BOLD,,,,1)
				oPrn:Say(nxLinha,2290, Transf(((nxTotCC/nxTotPrc)*100),"@E 999.99"), aFontes:ARIAL_10_BOLD,,,,1)
				nxLinha+=nxIncrem
			EndIf
			TRACO_REDU_02
			TRACO_VERT_01
			oPrn:Say(nxLinha,1270, STR0090+AllTrim(cxPedAnt), aFontes:ARIAL_10_BOLD,,,,1) //"Total do Pedido - "
			oPrn:Say(nxLinha,1530, Transf(nxTotPed,"@E 999,999,999.99"), aFontes:ARIAL_10_BOLD,,,,1)
			oPrn:Say(nxLinha,1790, Transf(ROUND((nxTotPed-nVlrSomP)/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), aFontes:ARIAL_10_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
			oPrn:Say(nxLinha,2140, Transf(((nxTotPed/nxTotPed)*100),"@E 999.99"), aFontes:ARIAL_10_BOLD,,,,1)
			oPrn:Say(nxLinha,2290, Transf(((nxTotPed/nxTotPrc)*100),"@E 999.99"), aFontes:ARIAL_10_BOLD,,,,1)
			nxLinha+=nxIncrem
			nVlrSomP := 0.00 //FCD
		EndIf
		//
		TRACO_NORMAL
		TRACO_VERT_01
		TRACO_VERT_02
		TRACO_REDU_01
		SW2->(dBSeek(xFilial("SW2")+TRB1->WK1PEDIDO))
		oPrn:Say(nxLinha,0055, STR0091+TRB1->WK1PEDIDO, aFontes:ARIAL_10_BOLD,,,,) //"Pedido   "
		oPrn:Say(nxLinha,0945, STR0092+DtoC(SW2->W2_PO_DT), 	aFontes:ARIAL_10_BOLD,,,,1) //"Dt."
		nxLinha+=nxIncrem
		//
		xxAux:=TRB1->(RecNo())
		TRB1->(dBSeek("2"+TRB1->(WK1PEDIDO+WK1CODIGO)))
		nxTotCC:=TRB1->WK1VALCOM  //--- Total do Centro de Custo com IPI e ICMS
		nVlrSomC:= TRB1->WK1VALDES //FCD
		//
		TRB1->(dBSeek("3"+TRB1->WK1PEDIDO+"PED"))
		nxTotPed:=TRB1->WK1VALCOM  //--- Total do Pedido com IPI e ICMS
		nVlrSomP:= TRB1->WK1VALDES //FCD 
   	TRB1->(dBGoTo(xxAux))
		//
		cxPedAnt:=TRB1->WK1PEDIDO
		cxCCAnt :=TRB1->WK1CODIGO
	EndIf
	TRACO_VERT_01
	oPrn:Say(nxLinha,0055, TRB1->WK1CODIGO,						aFontes:ARIAL_08,,,,)
    SY3->(dBSeek(xFilial("SY3")+TRB1->WK1CODIGO))
    oPrn:Say(nxLinha,0325, SY3->Y3_DIVIS,					aFontes:ARIAL_08,,,,)
	RetCamb()//FCD OS.:0080/02 SO.:0015/02
	nVlrSom := TRB1->WK1VALDES
	oPrn:Say(nxLinha,0595,TRB1->WK1ITEM,											aFontes:ARIAL_08,,,,)
	oPrn:Say(nxLinha,1000,TRB1->WK1UN,												aFontes:ARIAL_08,,,,1)
	oPrn:Say(nxLinha,1270,Transf(TRB1->WK1QTDE,"@E 99,999,999.999"),				aFontes:ARIAL_08,,,,1)
	oPrn:Say(nxLinha,1530,Transf(TRB1->WK1VALCOM,"@E 999,999,999.99"),				aFontes:ARIAL_08,,,,1)
	
	oPrn:Say(nxLinha,1790,Transf(ROUND((nVlrDolar-nVlrSom)/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), aFontes:ARIAL_08,,,,1)//FCD OS.:0080/02 SO.:0015/02
	oPrn:Say(nxLinha,1990,Transf(((TRB1->WK1VALCOM/nxTotCC)*100),"@E 999.99"), 	aFontes:ARIAL_08,,,,1)
	oPrn:Say(nxLinha,2140,Transf(((TRB1->WK1VALCOM/nxTotPed)*100),"@E 999.99"),	aFontes:ARIAL_08,,,,1)
	oPrn:Say(nxLinha,2290,Transf(((TRB1->WK1VALCOM/nxTotPrc)*100),"@E 999.99"),	aFontes:ARIAL_08,,,,1)
	nxLinha+=nxIncrem
	TRB1->(dBSkip())
EndDo
If nxTotPed #0
	If !Empty(cxPedAnt)
		If nxTotCC > 0
			TRACO_REDU_02
			TRACO_VERT_01
			oPrn:Say(nxLinha,1270, STR0089+AllTrim(cxCCAnt),        aFontes:ARIAL_10_BOLD,,,,1) //"Total do C.Custo - "
			oPrn:Say(nxLinha,1530, Transf(nxTotCC,"@E 999,999,999.99"), aFontes:ARIAL_10_BOLD,,,,1)
			oPrn:Say(nxLinha,1790, Transf(ROUND((nxTotCC-nVlrSom)/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), aFontes:ARIAL_10_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
			oPrn:Say(nxLinha,1990, Transf(((nxTotCC/nxTotCC)*100),"@E 999.99"), aFontes:ARIAL_10_BOLD,,,,1)
			oPrn:Say(nxLinha,2140, Transf(((nxTotCC/nxTotPed)*100),"@E 999.99"), aFontes:ARIAL_10_BOLD,,,,1)
			oPrn:Say(nxLinha,2290, Transf(((nxTotCC/nxTotPrc)*100),"@E 999.99"), aFontes:ARIAL_10_BOLD,,,,1)
			nxLinha+=nxIncrem
		EndIf
		TRACO_REDU_02
		TRACO_VERT_01
		oPrn:Say(nxLinha,1270, STR0090+AllTrim(cxPedAnt), aFontes:ARIAL_10_BOLD,,,,1) //"Total do Pedido - "
		oPrn:Say(nxLinha,1530, Transf(nxTotPed,"@E 999,999,999.99"), aFontes:ARIAL_10_BOLD,,,,1)
		oPrn:Say(nxLinha,1790, Transf(((nxTotPed-nVlrSomP)/SW6->W6_TX_US_D),"@E 99,999,999.99"), aFontes:ARIAL_10_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
		oPrn:Say(nxLinha,2140, Transf(((nxTotPed/nxTotPed)*100),"@E 999.99"), aFontes:ARIAL_10_BOLD,,,,1)
		oPrn:Say(nxLinha,2290, Transf(((nxTotPed/nxTotPrc)*100),"@E 999.99"), aFontes:ARIAL_10_BOLD,,,,1)
		nxLinha+=nxIncrem
		TRACO_REDU_02
		TRACO_VERT_01
		oPrn:Say(nxLinha,1270, STR0093+AllTrim(SW6->W6_HAWB),    aFontes:ARIAL_10_BOLD,,,,1) //"Total do Processo - "
		oPrn:Say(nxLinha,1530, Transf(nxTotPrc,"@E 999,999,999.99"),                  aFontes:ARIAL_10_BOLD,,,,1)
		oPrn:Say(nxLinha,1790, Transf((((nxTotPrc-nxPrcDes ))/SW6->W6_TX_US_D),"@E 99,999,999.99"), aFontes:ARIAL_10_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
		oPrn:Say(nxLinha,2290, Transf(((nxTotPrc/nxTotPrc)*100),"@E 999.99"),       aFontes:ARIAL_10_BOLD,,,,1)
		nxLinha+=nxIncrem
	EndIf
EndIf
Return

*==================================*
Static FUNCTION ICus_Resumo(cxTpRes)
*==================================*
If nxLinha > 3000-nxIncrem
   COMECA_PAGINA
EndIf
TRACO_NORMAL
TRACO_VERT_01
oPrn:Say(nxLinha, 300, If(cxTpRes=="C",STR0094,STR0095),		  aFontes:ARIAL_10_BOLD) //"Centros de Custo"###"Divisão"
oPrn:Say(nxLinha,1530, STR0082,      aFontes:ARIAL_08_BOLD,,,,1) //"Valor em R$"
oPrn:Say(nxLinha,1790, STR0083,     aFontes:ARIAL_08_BOLD,,,,1) //"Valor em US$"
oPrn:Say(nxLinha,2290, STR0096,            aFontes:ARIAL_08_BOLD,,,,1) //"%Proc"
nxLinha+=nxIncrem
TRACO_NORMAL
TRB1->(dBSeek(If(cxTpRes=="C","4","5")))
nVlrSom:= 0.00//FCD OS.:0080/02 SO.:0015/02
While TRB1->(!Eof()).and.TRB1->WK1TIPO==If(cxTpRes=="C","4","5")
	If nxLinha > 3000
		ICus_IMPCAB(If(cxTpRes=="C","1","2"))
	EndIf
	TRACO_VERT_01
	RETCAMB() //FCD OS.:0080/02 SO.:0015/02
	oPrn:Say(nxLinha,  55, TRB1->WK1CODIGO,													aFontes:ARIAL_10)
	oPrn:Say(nxLinha,1530, Transf(TRB1->WK1VALCOM,"@E 999,999,999.99"),					aFontes:ARIAL_08,,,,1)
	oPrn:Say(nxLinha,1790, Transf(ROUND((nVlrDolar-TRB1->WK1VALDES)/SW6->W6_TX_US_D,2),"@E 999,999,999.99"),	aFontes:ARIAL_08,,,,1)//FCD OS.:0080/02 SO.:0015/02
	oPrn:Say(nxLinha,2290, Transf(((TRB1->WK1VALCOM/nxTotPrc)*100),"@E 9999.999"),			aFontes:ARIAL_08,,,,1)
	nxLinha   :=nxLinha+nxIncrem
	TRB1->(dBSkip())
EndDo
TRACO_REDU_02
TRACO_VERT_01
oPrn:Say(nxLinha,1270, STR0093+AllTrim(SW6->W6_HAWB),	aFontes:ARIAL_10_BOLD,,,,1) //"Total do Processo - "
oPrn:Say(nxLinha,1530, Transf(nxTotPrc,"@E 999,999,999.99"),					aFontes:ARIAL_10_BOLD,,,,1)
oPrn:Say(nxLinha,1790, Transf(round((nxTotPrc-nxPrcDes )/SW6->W6_TX_US_D,2),"@E 99,999,999.99"),	aFontes:ARIAL_10_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
oPrn:Say(nxLinha,2290, Transf(((nxTotPrc/nxTotPrc)*100),"@E 999.99"),			aFontes:ARIAL_10_BOLD,,,,1)
nxLinha+=nxIncrem
Return

*==========================*
Static FUNCTION ICus_CusPO()
*==========================*
Local cxPedAnt	:=Spac(Len(TRB1->WK1PEDIDO))
Local nxCTotPed	:=0.00
Local nxSTotPed	:=0.00
Local nxSPISsIP	:=0.00
Local nxSPIScIP	:=0.00
Local nxFOB		:=0.00
Local cWK1PEDIDO
//
If nxLinha >= 3000-nxIncrem-nxIncrem
   COMECA_PAGINA
EndIf
TRACO_NORMAL
TRACO_VERT_01
oPrn:Say(nxLinha,2140, STR0079, aFontes:ARIAL_08_BOLD,,,,1) //"% s/ IPI"
oPrn:Say(nxLinha,2290, STR0080, aFontes:ARIAL_08_BOLD,,,,1) //"% c/ IPI"
nxLinha+=nxIncrem
TRACO_VERT_01
oPrn:Say(nxLinha, 300, STR0081,    aFontes:ARIAL_10_BOLD) //"Despesas"
oPrn:Say(nxLinha,1530, STR0082, aFontes:ARIAL_08_BOLD,,,,1) //"Valor em R$"
oPrn:Say(nxLinha,1790, STR0083,aFontes:ARIAL_08_BOLD,,,,1) //"Valor em US$"
oPrn:Say(nxLinha,1990, STR0084,       aFontes:ARIAL_08_BOLD,,,,1) //"% FOB"
oPrn:Say(nxLinha,2140, STR0085,        aFontes:ARIAL_08_BOLD,,,,1) //"ICMS"
oPrn:Say(nxLinha,2290, STR0085,        aFontes:ARIAL_08_BOLD,,,,1) //"ICMS"
nxLinha+=nxIncrem
TRACO_NORMAL
TRB1->(dBSeek("7"))
nVlrSom := 0.00 //FCD OS.: 0080/02 SO.:0015/02
While TRB1->(!Eof()).and.TRB1->WK1TIPO=="7"
	If nxLinha >= 3000-nxIncrem
       TRACO_NORMAL
       ICus_IMPCAB("5")
	EndIf
	If Empty(cxPedAnt).or.cxPedAnt #TRB1->WK1PEDIDO
		If !Empty(cxPedAnt)
			TRACO_REDU_02
			TRACO_VERT_01
			oPrn:Say(nxLinha,1270, STR0097+AllTrim(cxPedAnt)+STR0098, 	aFontes:ARIAL_10_BOLD,,,,1) //"Total do Pedido "###" sem IPI/ICMS - "
			oPrn:Say(nxLinha,1530, Transf(nxSTotPed,"@E 999,999,999.99"), 					aFontes:ARIAL_10_BOLD,,,,1)
			oPrn:Say(nxLinha,1790, Transf(round((nxSTotPed-nVlrSom)/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), aFontes:ARIAL_10_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
			oPrn:Say(nxLinha,1990, Transf(((nxSTotPed/nxFOB)*100),"@E 9999.999"),     		aFontes:ARIAL_08_BOLD,,,,1)
			oPrn:Say(nxLinha,2140, Transf(((nxSTotPed/nxSTotPed)*100),"@E 9999.999"),      aFontes:ARIAL_08_BOLD,,,,1)
			oPrn:Say(nxLinha,2290, Transf(((nxSTotPed/nxCTotPed)*100),"@E 9999.999"),      aFontes:ARIAL_08_BOLD,,,,1)
			nxLinha+=nxIncrem
			TRACO_VERT_01
			oPrn:Say(nxLinha,1270, STR0097+AllTrim(cxPedAnt)+STR0099,aFontes:ARIAL_10_BOLD,,,,1) //"Total do Pedido "###" com IPI/ICMS - "
			oPrn:Say(nxLinha,1530, Transf(nxCTotPed,"@E 999,999,999.99"),aFontes:ARIAL_10_BOLD,,,,1)
			oPrn:Say(nxLinha,1790, Transf(round((nxCTotPed-nVlrSom)/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), aFontes:ARIAL_10_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
			oPrn:Say(nxLinha,1990, Transf(((nxCTotPed/nxFOB)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
			oPrn:Say(nxLinha,2290, Transf(((nxCTotPed/nxCTotPed)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)

         IF lMV_PIS_EIC
            nxLinha+=nxIncrem
            TRACO_VERT_01
            oPrn:Say(nxLinha,1270, "Total Pedido sem IPI/ICMS s/ PIS/COFINS ",aFontes:ARIAL_10_BOLD,,,,1) //"Total Geral com IPI/ICMS"
            oPrn:Say(nxLinha,1530, Transf(nxSPISsIP,"@E 999,999,999.99"),aFontes:ARIAL_10_BOLD,,,,1)
            oPrn:Say(nxLinha,1790, Transf(ROUND((nxSPISsIP-nVlrSom)/SW6->W6_TX_US_D,2),"@E 999,999,999.99"), 	aFontes:ARIAL_10_BOLD,,,,1)
            oPrn:Say(nxLinha,1990, Transf(((nxSPISsIP/nxFOB)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
            oPrn:Say(nxLinha,2140, Transf(((nxSPISsIP/nxSPISsIP)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
            oPrn:Say(nxLinha,2290, Transf(((nxSPISsIP/nxSPIScIP)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
            nxLinha+=nxIncrem
            TRACO_VERT_01
            oPrn:Say(nxLinha,1270, "Total Pedido com IPI/ICMS s/ PIS/COFINS ",aFontes:ARIAL_10_BOLD,,,,1) //"Total Geral com IPI/ICMS"
            oPrn:Say(nxLinha,1530, Transf(nxSPIScIP,"@E 999,999,999.99"),aFontes:ARIAL_10_BOLD,,,,1)
            oPrn:Say(nxLinha,1790, Transf(ROUND((nxSPIScIP-nVlrSom)/SW6->W6_TX_US_D,2),"@E 999,999,999.99"), 	aFontes:ARIAL_10_BOLD,,,,1)
            oPrn:Say(nxLinha,1990, Transf(((nxSPIScIP/nxFOB)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
            oPrn:Say(nxLinha,2290, Transf(((nxSPIScIP/nxSPIScIP)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
         ENDIF

			nxLinha+=nxIncrem
			nVlrSom := 0.00 //FCD
		EndIf
		//
		TRACO_NORMAL
		TRACO_VERT_01
		TRACO_VERT_02
		TRACO_REDU_01
		SW2->(dBSeek(xFilial("SW2")+TRB1->WK1PEDIDO))
		oPrn:Say(nxLinha,0055, STR0091+TRB1->WK1PEDIDO, aFontes:ARIAL_10_BOLD,,,,) //"Pedido   "
		oPrn:Say(nxLinha,0945, STR0092+DtoC(SW2->W2_PO_DT), 	aFontes:ARIAL_10_BOLD,,,,1) //"Dt."
		nxLinha+=nxIncrem
		//
		xxAux:=TRB1->(RecNo())
		
		
      cWK1PEDIDO:=TRB1->WK1PEDIDO
		TRB1->(dBSeek("3"+cWK1PEDIDO+"PED"))
		nxCTotPed:=TRB1->WK1VALCOM  //--- Total do Pedido com IPI e ICMS
		nxSTotPed:=TRB1->WK1VALSEM  //--- Total do Pedido sem IPI e ICMS
      nxSPISsIP:=TRB1->WK1SPISSIP
      nxSPIScIP:=TRB1->WK1SPISCIP

		TRB1->(dBGoTo(xxAux))
		//
		cxPedAnt:=TRB1->WK1PEDIDO
	EndIf
	TRACO_VERT_01
	RetCamb()//FCD OS.:0080/02 SO.:0015/02	    
	oPrn:Say(nxLinha,  55, TRB1->(If(Left(WK1DESP,3)$ DESPS_TOTS ,Subs(WK1DESP,5),WK1DESP)),   If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_10_BOLD,aFontes:ARIAL_10))
	oPrn:Say(nxLinha,1530,Transf(TRB1->WK1VALCOM,"@E 999,999,999.99"),If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)
	oPrn:Say(nxLinha,1790,Transf(round(If(lxDespDet,nVlrDolar,(nVlrDolar-nVlrSom))/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), 	If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)//FCD OS.:0080/02 SO.:0015/02
	If Left(TRB1->WK1DESP,3)=="101"
		oPrn:Say(nxLinha,1990, STR0086,	aFontes:ARIAL_10_BOLD,,,,1) //"BASE"
		nxFOB:=TRB1->WK1VALCOM
	Else
		oPrn:Say(nxLinha,1990, Transf(((TRB1->WK1VALCOM/nxFOB)*100),"@E 9999.999"),If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)
	EndIf
	
	If Left(TRB1->WK1DESP,3) $ "202.203."+TOT_IMPOSTOS
		oPrn:Say(nxLinha,2140, "- * -", If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)
	Else
	   // %c/IPI
		oPrn:Say(nxLinha,2140, Transf(((TRB1->WK1VALCOM/nxSTotPed)*100),"@E 9999.999"),If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)
	EndIf
	// %s/IPI
	oPrn:Say(nxLinha,2290, Transf(((TRB1->WK1VALCOM/nxCTotPed)*100),"@E 9999.999"), If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)
	nxLinha+=nxIncrem
	TRB1->(dBSkip())
EndDo
If nxSTotPed #0
	If !Empty(cxPedAnt)
		TRACO_REDU_02
		TRACO_VERT_01
		oPrn:Say(nxLinha,1270, STR0097+AllTrim(cxPedAnt)+STR0098,aFontes:ARIAL_10_BOLD,,,,1) //"Total do Pedido "###" sem IPI/ICMS - "
		oPrn:Say(nxLinha,1530, Transf(nxSTotPed,"@E 999,999,999.99"),aFontes:ARIAL_10_BOLD,,,,1)
		oPrn:Say(nxLinha,1790, Transf(round((nxSTotPed-nVlrSom)/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), aFontes:ARIAL_10_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
		oPrn:Say(nxLinha,1990, Transf(((nxSTotPed/nxFOB)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
		oPrn:Say(nxLinha,2140, Transf(((nxSTotPed/nxSTotPed)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
		oPrn:Say(nxLinha,2290, Transf(((nxSTotPed/nxCTotPed)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
		nxLinha+=nxIncrem
		TRACO_VERT_01
		oPrn:Say(nxLinha,1270, STR0097+AllTrim(cxPedAnt)+STR0099,aFontes:ARIAL_10_BOLD,,,,1) //"Total do Pedido "###" com IPI/ICMS - "
		oPrn:Say(nxLinha,1530, Transf(nxCTotPed,"@E 999,999,999.99"),aFontes:ARIAL_10_BOLD,,,,1)
		oPrn:Say(nxLinha,1790, Transf(round((nxCTotPed-nVlrSom)/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), aFontes:ARIAL_10_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
		oPrn:Say(nxLinha,1990, Transf(((nxCTotPed/nxFOB)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
		oPrn:Say(nxLinha,2290, Transf(((nxCTotPed/nxCTotPed)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)

		IF lMV_PIS_EIC
         nxLinha+=nxIncrem
         TRACO_VERT_01
         oPrn:Say(nxLinha,1270, "Total Pedido sem IPI/ICMS s/ PIS/COFINS ",aFontes:ARIAL_10_BOLD,,,,1) //"Total Geral com IPI/ICMS"
         oPrn:Say(nxLinha,1530, Transf(nxSPISsIP,"@E 999,999,999.99"),aFontes:ARIAL_10_BOLD,,,,1)
         oPrn:Say(nxLinha,1790, Transf(ROUND((nxSPISsIP-nVlrSom)/SW6->W6_TX_US_D,2),"@E 999,999,999.99"), 	aFontes:ARIAL_10_BOLD,,,,1)
         oPrn:Say(nxLinha,1990, Transf(((nxSPISsIP/nxFOB)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
         oPrn:Say(nxLinha,2140, Transf(((nxSPISsIP/nxSPISsIP)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
         oPrn:Say(nxLinha,2290, Transf(((nxSPISsIP/nxSPIScIP)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
         nxLinha+=nxIncrem
         TRACO_VERT_01
         oPrn:Say(nxLinha,1270, "Total Pedido com IPI/ICMS s/ PIS/COFINS ",aFontes:ARIAL_10_BOLD,,,,1) //"Total Geral com IPI/ICMS"
         oPrn:Say(nxLinha,1530, Transf(nxSPIScIP,"@E 999,999,999.99"),aFontes:ARIAL_10_BOLD,,,,1)
         oPrn:Say(nxLinha,1790, Transf(ROUND((nxSPIScIP-nVlrSom)/SW6->W6_TX_US_D,2),"@E 999,999,999.99"), 	aFontes:ARIAL_10_BOLD,,,,1)
         oPrn:Say(nxLinha,1990, Transf(((nxSPIScIP/nxFOB)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
         oPrn:Say(nxLinha,2290, Transf(((nxSPIScIP/nxSPIScIP)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
      ENDIF

		nxLinha+=nxIncrem
	EndIf
EndIf
Return

*============================*
Static FUNCTION ICus_CusItem()
*============================*
Local cxPedAnt	:=Spac(Len(TRB1->WK1PEDIDO))
Local cxPosAnt	:=Spac(Len(TRB1->WK1POSICA))
Local cxLotAnt  :=Spac(Len(TRB1->WK1_LOTE ))
LOCAL cxPgiAnt  :=Spac(Len(TRB1->WK1GI_NUM))
Local nxQtdIte	 :=0
Local nxCTotIte :=0.00
Local nxSTotIte :=0.00
Local nxsPISsIP :=0.00
Local nxsPIScIP :=0.00

Local nxVlr701  :=0.00
Local nxFOB		:=0.00
Local cxDesc	:=''
//
If nxLinha >= 3000-nxIncrem-nxIncrem
   COMECA_PAGINA
EndIf
TRACO_NORMAL
TRACO_VERT_01
oPrn:Say(nxLinha,2140, STR0079, aFontes:ARIAL_08_BOLD,,,,1) //"% s/ IPI"
oPrn:Say(nxLinha,2290, STR0080, aFontes:ARIAL_08_BOLD,,,,1) //"% c/ IPI"
nxLinha+=nxIncrem
TRACO_VERT_01
oPrn:Say(nxLinha, 300, STR0081,    aFontes:ARIAL_10_BOLD) //"Despesas"
oPrn:Say(nxLinha,1010, STR0100, aFontes:ARIAL_08_BOLD,,,,1) //"Val.Unit.R$"
oPrn:Say(nxLinha,1270, STR0101,aFontes:ARIAL_08_BOLD,,,,1) //"Val.Unit.US$"
oPrn:Say(nxLinha,1530, STR0102, aFontes:ARIAL_08_BOLD,,,,1) //"Val.Tot. R$"
oPrn:Say(nxLinha,1790, STR0103,aFontes:ARIAL_08_BOLD,,,,1) //"Val.Tot. US$"
oPrn:Say(nxLinha,1990, STR0084,       aFontes:ARIAL_08_BOLD,,,,1) //"% FOB"
oPrn:Say(nxLinha,2140, STR0085,        aFontes:ARIAL_08_BOLD,,,,1) //"ICMS"
oPrn:Say(nxLinha,2290, STR0085,        aFontes:ARIAL_08_BOLD,,,,1) //"ICMS"
nxLinha+=nxIncrem
TRACO_NORMAL
TRB1->(dBSeek("8"))
nVlrSom:= 0.00//FCD OS.:0080/02 SO.:0015/02
While TRB1->(!Eof()).and.TRB1->WK1TIPO=="8"
	If nxLinha >= 3000-nxIncrem
		TRACO_NORMAL
		ICus_IMPCAB("6")
	EndIf
	If 	Empty(cxPedAnt)			.or.Empty(cxPosAnt)	.or.;
		cxPedAnt#TRB1->WK1PEDIDO.or.cxPosAnt#TRB1->WK1POSICA.or.;
		cxLotAnt#TRB1->WK1_LOTE  .OR. cxPgiAnt # TRB1->WK1GI_NUM
		If !Empty(cxPedAnt).And.!Empty(cxPosAnt)
			TRACO_REDU_03
			TRACO_VERT_01
			oPrn:Say(nxLinha,0750, STR0104,aFontes:ARIAL_10_BOLD,,,,1) //"Tot.Item s/ IPI/ICMS - "
			oPrn:Say(nxLinha,1010, Transf((nxSTotIte/nxQtdIte),"@E 999,999,999.9999"),aFontes:ARIAL_08_BOLD,,,,1)
         oPrn:Say(nxLinha,1270, Transf(((nxSTotIte-nxVlr701)/nxQtdIte)/SW6->W6_TX_US_D,"@E 999,999,999.9999"),aFontes:ARIAL_08_BOLD,,,,1) //FCD OS.:0078/02 SO.:0015/02
			oPrn:Say(nxLinha,1530, Transf(nxSTotIte,"@E 999,999,999.99"),aFontes:ARIAL_08_BOLD,,,,1)
			oPrn:Say(nxLinha,1790, Transf(round((nxSTotIte-nxVlr701)/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), 			aFontes:ARIAL_08_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
			oPrn:Say(nxLinha,1990, Transf(((nxSTotIte/nxFOB)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
			oPrn:Say(nxLinha,2140, Transf(((nxSTotIte/nxSTotIte)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
			oPrn:Say(nxLinha,2290, Transf(((nxSTotIte/nxCTotIte)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
			nxLinha+=nxIncrem
			TRACO_VERT_01
			oPrn:Say(nxLinha,0750, STR0105,aFontes:ARIAL_10_BOLD,,,,1) //"Tot.Item c/ IPI/ICMS - "
			oPrn:Say(nxLinha,1010, Transf((nxCTotIte/nxQtdIte),"@E 999,999,999.9999"),aFontes:ARIAL_08_BOLD,,,,1)
         oPrn:Say(nxLinha,1270, Transf((nxCTotIte/nxQtdIte)/SW6->W6_TX_US_D,"@E 999,999,999.9999"),aFontes:ARIAL_08_BOLD,,,,1)//FCD OS.:0078/02 SO.:0015/02
			oPrn:Say(nxLinha,1530, Transf(nxCTotIte,"@E 999,999,999.99"),aFontes:ARIAL_08_BOLD,,,,1)
			oPrn:Say(nxLinha,1790, Transf(round((nxCTotIte-nVlrSom)/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), 			aFontes:ARIAL_08_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
			oPrn:Say(nxLinha,1990, Transf(((nxCTotIte/nxFOB)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
			oPrn:Say(nxLinha,2290, Transf(((nxCTotIte/nxCTotIte)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)

   	IF lMV_PIS_EIC
         nxLinha+=nxIncrem
         TRACO_VERT_01
         oPrn:Say(nxLinha,0750, "Tot.Item sem IPI/ICMS sem PIS/COFINS",	aFontes:ARIAL_10_BOLD,,,,1) 
   		oPrn:Say(nxLinha,1010, Transf((nxsPISsIP/nxQtdIte),"@E 999,999,999.9999"),aFontes:ARIAL_08_BOLD,,,,1)
         oPrn:Say(nxLinha,1270, Transf(((nxsPISsIP-nxVlr701)/nxQtdIte)/SW6->W6_TX_US_D,"@E 999,999,999.9999"),aFontes:ARIAL_08_BOLD,,,,1)//FCD OS.:0078/02 SO.:0015/02
   		oPrn:Say(nxLinha,1530, Transf(nxsPISsIP,"@E 999,999,999.99"),aFontes:ARIAL_08_BOLD,,,,1)
		   oPrn:Say(nxLinha,1790, Transf(round((nxsPISsIP-nxVlr701)/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), 			aFontes:ARIAL_08_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
   		oPrn:Say(nxLinha,1990, Transf(((nxsPISsIP/nxFOB)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
	   	oPrn:Say(nxLinha,2140, Transf(((nxsPISsIP/nxsPISsIP)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
   		oPrn:Say(nxLinha,2290, Transf(((nxsPISsIP/nxsPIScIP)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
   		nxLinha+=nxIncrem
	   	TRACO_VERT_01
   		oPrn:Say(nxLinha,0750, "Tot.Item com IPI/ICMS sem PIS/COFINS",aFontes:ARIAL_10_BOLD,,,,1)
	   	oPrn:Say(nxLinha,1010, Transf((nxsPIScIP/nxQtdIte),"@E 999,999,999.9999"),aFontes:ARIAL_08_BOLD,,,,1)
         oPrn:Say(nxLinha,1270, Transf(((nxsPIScIP-nxVlr701)/nxQtdIte)/SW6->W6_TX_US_D,"@E 999,999,999.9999"),aFontes:ARIAL_08_BOLD,,,,1)//FCD OS.:0078/02 SO.:0015/02
	   	oPrn:Say(nxLinha,1530, Transf(nxsPIScIP,"@E 999,999,999.99"),aFontes:ARIAL_08_BOLD,,,,1)
   		oPrn:Say(nxLinha,1790, Transf(round((nxsPIScIP-nxVlr701)/SW6->W6_TX_US_D,2),"@E 99,999,999.99"),aFontes:ARIAL_08_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
	   	oPrn:Say(nxLinha,1990, Transf(((nxsPIScIP/nxFOB)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
   		oPrn:Say(nxLinha,2290, Transf(((nxsPIScIP/nxsPIScIP)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
      ENDIF

			nxLinha+=nxIncrem
			nVlrSom := 0.00 //FCD
		EndIf
		//
        If nxLinha >= 3000-nxIncrem-nxIncrem
		   TRACO_NORMAL
           ICus_IMPCAB("6")
		EndIf
		TRACO_NORMAL
		TRACO_VERT_01
		TRACO_VERT_02
		TRACO_REDU_01
		SW2->(dBSeek(xFilial("SW2")+TRB1->WK1PEDIDO))
		SB1->(dBSeek(xFilial("SB1")+TRB1->WK1ITEM))
		cxDesc:=MSMM(SB1->B1_DESC_P,36)
		cxDesc:=StrTRAN(cxDesc,CHR(13)+CHR(10)," ")
		oPrn:Say(nxLinha,0055, STR0091+TRB1->WK1PEDIDO, aFontes:ARIAL_10_BOLD,,,,) //"Pedido   "
		oPrn:Say(nxLinha,0945, STR0092+DtoC(SW2->W2_PO_DT), 	aFontes:ARIAL_10_BOLD,,,,1) //"Dt."
		//
		xxAux:=TRB1->(RecNo())
		TRB1->(dBSeek("9"+WK1PEDIDO+WK1CODIGO+WK1ITEM+WK1POSICA+WK1_LOTE+WK1GI_NUM))
		SA2->(dBSeek(xFilial("SA2")+TRB1->WK1FABR))
		nxCTotIte:=TRB1->WK1VALCOM  //--- Total do Pedido com IPI e ICMS
		nxSTotIte:=TRB1->WK1VALSEM  //--- Total do Pedido sem IPI e ICMS
		nxsPISsIP:=TRB1->WK1SPISSIP
		nxsPIScIP:=TRB1->WK1SPISCIP
		nxQtdIte :=TRB1->WK1QTDE    //--- Quantidade
		nxVlr701 :=TRB1->WK1VALDES
		//
		oPrn:Say(nxLinha,1000, STR0106,				aFontes:ARIAL_08,,,,) //"Prod.: "
		oPrn:Say(nxLinha,1090, TRB1->WK1ITEM,aFontes:ARIAL_10_BOLD,,,,)
		oPrn:Say(nxLinha,1490, MemoLine(cxDesc,40,1),COURIER_09)
		nxLinha+=nxIncrem
		If !Empty(MemoLine(cxDesc,40,2))
			TRACO_VERT_01
			oPrn:Say(nxLinha,1490, MemoLine(cxDesc,40,2),COURIER_09)
			nxLinha+=nxIncrem
		EndIf                     
		IF lLote .AND. !EMPTY(TRB1->WK1_LOTE)
           TRACO_VERT_01
           oPrn:Say(nxLinha,1000, AVSX3("WN_LOTECTL",5)+".:",aFontes:ARIAL_08,,,,)
           oPrn:Say(nxLinha,1200, TRB1->WK1_LOTE            ,aFontes:ARIAL_08_BOLD,,,,)
           oPrn:Say(nxLinha,1530, AVSX3("WN_DTVALID",5)+".:",aFontes:ARIAL_08,,,,)
           oPrn:Say(nxLinha,2000, DTOC(TRB1->WK1_DTVAL)     ,aFontes:ARIAL_08_BOLD,,,,)
           nxLinha+=nxIncrem
        endif
		TRACO_VERT_01
		oPrn:Say(nxLinha,1000, STR0107, 						aFontes:ARIAL_08,,,,) //"Fabr.: "
		oPrn:Say(nxLinha,1100, TRB1->WK1FABR+" - "+SA2->A2_NOME,aFontes:ARIAL_08_BOLD,,,,)
		nxLinha+=nxIncrem
		TRACO_VERT_01
		oPrn:Say(nxLinha,1000, STR0108, 						aFontes:ARIAL_08,,,,) //"Qtde.: "
		oPrn:Say(nxLinha,1100, Transf(nxQtdIte,"@E 99,999,999.999")+" "+TRB1->WK1UN, 	aFontes:ARIAL_08_BOLD,,,,)
		oPrn:Say(nxLinha,1530, STR0109,			aFontes:ARIAL_08,,,,) //"NCM/Ex-NCM/Ex-NBM:"
		oPrn:Say(nxLinha,2000, TRB1->(AllTrim(WK1POSIPI)+"/"+WK1EX_NCM+"/"+WK1EX_NBM), 	aFontes:ARIAL_08_BOLD,,,,)
		nxLinha+=nxIncrem                      
		TRACO_VERT_01                      
		oPrn:Say(nxLinha,1095, STR0110,						aFontes:ARIAL_08,,,,1) //"Peso Líq Unit.: "
		oPrn:Say(nxLinha,1100, Transf((TRB1->WK1PESO/nxQtdIte),cPictPeso),	aFontes:ARIAL_08_BOLD,,,,)
		oPrn:Say(nxLinha,1530, STR0111,								aFontes:ARIAL_08,,,,) //"Total:"
        oPrn:Say(nxLinha,2000, Transf(TRB1->WK1PESO,cPictPeso),	aFontes:ARIAL_08_BOLD,,,,)
		nxLinha+=nxIncrem
		If Left(TRB1->WK1GI_NUM,1)#"*"
			TRACO_VERT_01
			oPrn:Say(nxLinha,1000, STR0112, 					aFontes:ARIAL_08,,,,) //"L.I..: "
			oPrn:Say(nxLinha,1100, TRB1->WK1GI_NUM,				aFontes:ARIAL_08_BOLD,,,,)
			nxLinha+=nxIncrem
		EndIf
		TRACO_NORMAL
		TRB1->(dBGoTo(xxAux))
		//
		cxPedAnt:=TRB1->WK1PEDIDO
		cxPosAnt:=TRB1->WK1POSICA
		cxLotAnt:=TRB1->WK1_LOTE            
		cxPgiAnt:=TRB1->WK1GI_NUM
	EndIf
	If nxLinha >= 3000-nxIncrem
		TRACO_NORMAL
		ICus_IMPCAB("6")
	EndIf
	TRACO_VERT_01
    RetCamb()	                       
	oPrn:Say(nxLinha,  55,TRB1->(If(Left(WK1DESP,3)$ DESPS_TOTS ,Subs(WK1DESP,5),WK1DESP)),	If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_10_BOLD,aFontes:ARIAL_10))
	oPrn:Say(nxLinha,1010,Transf((TRB1->WK1VALCOM/nxQtdIte),"@E 999,999,999.9999"), 					If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)
   oPrn:Say(nxLinha,1270,Transf((If(lxDespDet,nVlrDolar,(nVlrDolar-nVlrSom))/nxQtdIte)/SW6->W6_TX_US_D,"@E 999,999,999.9999"),    If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)//FCD OS.:0078/02 SO.:0015/02
	oPrn:Say(nxLinha,1530,Transf(TRB1->WK1VALCOM,"@E 999,999,999.99"),						If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)
	oPrn:Say(nxLinha,1790,Transf(round(If(lxDespDet,nVlrDolar,(nVlrDolar-nVlrSom))/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), 	If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)
	If Left(TRB1->WK1DESP,3)=="101"
		oPrn:Say(nxLinha,1990, STR0086,aFontes:ARIAL_10_BOLD,,,,1) //"BASE"
		nxFOB:=TRB1->WK1VALCOM
	Else
		oPrn:Say(nxLinha,1990, Transf(((TRB1->WK1VALCOM/nxFOB)*100),"@E 9999.999"),			If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)
	EndIf
	If Left(TRB1->WK1DESP,3) $ "202.203."+TOT_IMPOSTOS
		oPrn:Say(nxLinha,2140, "- * -",                                                     If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)
	Else
		oPrn:Say(nxLinha,2140, Transf(((TRB1->WK1VALCOM/nxSTotIte)*100),"@E 9999.999"),    	If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)
	EndIf
	oPrn:Say(nxLinha,2290, Transf(((TRB1->WK1VALCOM/nxCTotIte)*100),"@E 9999.999"),        	If(Left(TRB1->WK1DESP,3)$ DESPS_TOTS ,aFontes:ARIAL_08_BOLD,aFontes:ARIAL_08),,,,1)
	nxLinha+=nxIncrem
	TRB1->(dBSkip())
EndDo
If nxLinha >= 3000-nxIncrem
	TRACO_NORMAL
	ICus_IMPCAB("6")
EndIf
If nxSTotIte #0
	If !Empty(cxPedAnt).or.!Empty(cxPosAnt)
		TRACO_REDU_03
		TRACO_VERT_01
		oPrn:Say(nxLinha,0750, STR0104, 											aFontes:ARIAL_10_BOLD,,,,1) //"Tot.Item s/ IPI/ICMS - "
		oPrn:Say(nxLinha,1010, Transf((nxSTotIte/nxQtdIte),"@E 999,999,999.9999"), 				aFontes:ARIAL_08_BOLD,,,,1)
        oPrn:Say(nxLinha,1270, Transf(((nxSTotIte-nxVlr701)/nxQtdIte)/SW6->W6_TX_US_D,"@E 999,999,999.9999"),aFontes:ARIAL_08_BOLD,,,,1)//FCD OS.:0078/02 SO.:0015/02
		oPrn:Say(nxLinha,1530, Transf(nxSTotIte,"@E 999,999,999.99"), 								aFontes:ARIAL_08_BOLD,,,,1)
		oPrn:Say(nxLinha,1790, Transf(round((nxSTotIte-nxVlr701)/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), 			aFontes:ARIAL_08_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
		oPrn:Say(nxLinha,1990, Transf(((nxSTotIte/nxFOB)*100),"@E 9999.999"),     					aFontes:ARIAL_08_BOLD,,,,1)
		oPrn:Say(nxLinha,2140, Transf(((nxSTotIte/nxSTotIte)*100),"@E 9999.999"),     				aFontes:ARIAL_08_BOLD,,,,1)
		oPrn:Say(nxLinha,2290, Transf(((nxSTotIte/nxCTotIte)*100),"@E 9999.999"),      				aFontes:ARIAL_08_BOLD,,,,1)
		nxLinha+=nxIncrem
		TRACO_VERT_01
		oPrn:Say(nxLinha,0750, STR0105,aFontes:ARIAL_10_BOLD,,,,1) //"Tot.Item c/ IPI/ICMS - "
		oPrn:Say(nxLinha,1010, Transf((nxCTotIte/nxQtdIte),"@E 999,999,999.9999"), aFontes:ARIAL_08_BOLD,,,,1)
      oPrn:Say(nxLinha,1270, Transf(((nxCTotIte-nxVlr701)/nxQtdIte)/SW6->W6_TX_US_D,"@E 999,999,999.9999"),aFontes:ARIAL_08_BOLD,,,,1)//FCD OS.:0078/02 SO.:0015/02
		oPrn:Say(nxLinha,1530, Transf(nxCTotIte,"@E 999,999,999.99"), 					aFontes:ARIAL_08_BOLD,,,,1)
		oPrn:Say(nxLinha,1790, Transf(round((nxCTotIte-nxVlr701)/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), 			aFontes:ARIAL_08_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
		oPrn:Say(nxLinha,1990, Transf(((nxCTotIte/nxFOB)*100),"@E 9999.999"),     	aFontes:ARIAL_08_BOLD,,,,1)
		oPrn:Say(nxLinha,2290, Transf(((nxCTotIte/nxCTotIte)*100),"@E 9999.999"),  aFontes:ARIAL_08_BOLD,,,,1)

   	IF lMV_PIS_EIC
         nxLinha+=nxIncrem
         TRACO_VERT_01
         oPrn:Say(nxLinha,0750, "Tot.Item sem IPI/ICMS sem PIS/COFINS",	aFontes:ARIAL_10_BOLD,,,,1) 
   		oPrn:Say(nxLinha,1010, Transf(nxsPISsIP/nxQtdIte,"@E 999,999,999.9999"),aFontes:ARIAL_08_BOLD,,,,1)
         oPrn:Say(nxLinha,1270, Transf(((nxsPISsIP-nxVlr701)/nxQtdIte)/SW6->W6_TX_US_D,"@E 999,999,999.9999"),aFontes:ARIAL_08_BOLD,,,,1)//FCD OS.:0078/02 SO.:0015/02
   		oPrn:Say(nxLinha,1530, Transf(nxsPISsIP,"@E 999,999,999.99"),aFontes:ARIAL_08_BOLD,,,,1)
		   oPrn:Say(nxLinha,1790, Transf(round((nxsPISsIP-nxVlr701)/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), 			aFontes:ARIAL_08_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
   		oPrn:Say(nxLinha,1990, Transf(((nxsPISsIP/nxFOB)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
	   	oPrn:Say(nxLinha,2140, Transf(((nxsPISsIP/nxsPISsIP)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
   		oPrn:Say(nxLinha,2290, Transf(((nxsPISsIP/nxsPIScIP)*100),"@E 9999.999"),aFontes:ARIAL_08_BOLD,,,,1)
   		nxLinha+=nxIncrem
	   	TRACO_VERT_01
   		oPrn:Say(nxLinha,0750, "Tot.Item com IPI/ICMS sem PIS/COFINS",aFontes:ARIAL_10_BOLD,,,,1) //"Tot.Item c/ IPI/ICMS - "
	   	oPrn:Say(nxLinha,1010, Transf(nxsPIScIP/nxQtdIte,"@E 999,999,999.9999"),aFontes:ARIAL_08_BOLD,,,,1)
         oPrn:Say(nxLinha,1270, Transf(((nxsPIScIP-nxVlr701)/nxQtdIte)/SW6->W6_TX_US_D,"@E 999,999,999.9999"),aFontes:ARIAL_08_BOLD,,,,1)//FCD OS.:0078/02 SO.:0015/02
	   	oPrn:Say(nxLinha,1530, Transf(nxsPIScIP,"@E 999,999,999.99"),aFontes:ARIAL_08_BOLD,,,,1)
   		oPrn:Say(nxLinha,1790, Transf(round((nxsPIScIP-nxVlr701)/SW6->W6_TX_US_D,2),"@E 99,999,999.99"), 			aFontes:ARIAL_08_BOLD,,,,1)//FCD OS.:0080/02 SO.:0015/02
	   	oPrn:Say(nxLinha,1990, Transf(((nxsPIScIP/nxFOB)*100),"@E 9999.999"), aFontes:ARIAL_08_BOLD,,,,1)
   		oPrn:Say(nxLinha,2290, Transf(((nxsPIScIP/nxsPIScIP)*100),"@E 9999.999"), aFontes:ARIAL_08_BOLD,,,,1)
      ENDIF

		nxLinha+=nxIncrem
	EndIf
EndIf
Return

*==================================*
Static FUNCTION ICus_IMPCAB(cxCabec)
*==================================*
IF cxCabec # '4'
   COMECA_PAGINA
ENDIF   
If cxCabec $ "12"  //--- Cabecalho de Resumo de Centro de Custos/Divisão
	TRACO_NORMAL
	TRACO_VERT_01
	oPrn:Say(nxLinha, 300, If(cxCabec=="1",;
							STR0094,; //"Centros de Custo"
							STR0095),	aFontes:ARIAL_10_BOLD) //"Divisão"
	oPrn:Say(nxLinha,1530, STR0082,	aFontes:ARIAL_08_BOLD,,,,1) //"Valor em R$"
	oPrn:Say(nxLinha,1790, STR0083,	aFontes:ARIAL_08_BOLD,,,,1) //"Valor em US$"
	oPrn:Say(nxLinha,2290, STR0096,			aFontes:ARIAL_08_BOLD,,,,1) //"%Proc"
	nxLinha+=nxIncrem
	TRACO_NORMAL
ElseIf cxCabec=="3"
	TRACO_NORMAL
	TRACO_VERT_01
	oPrn:Say(nxLinha, 1150, STR0047, aFontes:ARIAL_10_BOLD,,,,2) //"Observações Gerais"
	nxLinha+=nxIncrem
	TRACO_NORMAL
ElseIf cxCabec=="4"
	TRACO_NORMAL
	TRACO_VERT_01
	oPrn:Say(nxLinha,0055, STR0113,	aFontes:ARIAL_08_BOLD,,,,) //"Centro Custo"
    oPrn:Say(nxLinha,0325, STR0095,	aFontes:ARIAL_08_BOLD,,,,) //"Divisão"
	oPrn:Say(nxLinha,0595, STR0114,aFontes:ARIAL_08_BOLD,,,,) //"Codigo Produto"
	oPrn:Say(nxLinha,1000, STR0115,			aFontes:ARIAL_08_BOLD,,,,1) //"UN"
	oPrn:Say(nxLinha,1270, STR0116,	aFontes:ARIAL_08_BOLD,,,,1) //"Qtde.Total"
	oPrn:Say(nxLinha,1530, STR0082,	aFontes:ARIAL_08_BOLD,,,,1) //"Valor em R$"
	oPrn:Say(nxLinha,1790, STR0083,	aFontes:ARIAL_08_BOLD,,,,1) //"Valor em US$"
	oPrn:Say(nxLinha,1990, STR0117,			aFontes:ARIAL_08_BOLD,,,,1) //"%C.C."
	oPrn:Say(nxLinha,2140, STR0118,			aFontes:ARIAL_08_BOLD,,,,1) //"%Ped."
	oPrn:Say(nxLinha,2290, STR0119,		aFontes:ARIAL_08_BOLD,,,,1) //"%Proc."
	nxLinha+=nxIncrem	
	TRACO_NORMAL
ElseIf cxCabec=="5"
	TRACO_NORMAL
	TRACO_VERT_01
	oPrn:Say(nxLinha,2140, STR0079, aFontes:ARIAL_08_BOLD,,,,1) //"% s/ IPI"
	oPrn:Say(nxLinha,2290, STR0080, aFontes:ARIAL_08_BOLD,,,,1) //"% c/ IPI"
	nxLinha+=nxIncrem
	TRACO_VERT_01
	oPrn:Say(nxLinha, 300, STR0081,    aFontes:ARIAL_10_BOLD) //"Despesas"
	oPrn:Say(nxLinha,1530, STR0082, aFontes:ARIAL_08_BOLD,,,,1) //"Valor em R$"
	oPrn:Say(nxLinha,1790, STR0083,aFontes:ARIAL_08_BOLD,,,,1) //"Valor em US$"
	oPrn:Say(nxLinha,1990, STR0084,       aFontes:ARIAL_08_BOLD,,,,1) //"% FOB"
	oPrn:Say(nxLinha,2140, STR0085,        aFontes:ARIAL_08_BOLD,,,,1) //"ICMS"
	oPrn:Say(nxLinha,2290, STR0085,        aFontes:ARIAL_08_BOLD,,,,1) //"ICMS"
	nxLinha+=nxIncrem
	TRACO_NORMAL
ElseIf cxCabec=="6"
	TRACO_NORMAL
	TRACO_VERT_01
	oPrn:Say(nxLinha,2140, STR0079, aFontes:ARIAL_08_BOLD,,,,1) //"% s/ IPI"
	oPrn:Say(nxLinha,2290, STR0080, aFontes:ARIAL_08_BOLD,,,,1) //"% c/ IPI"
	nxLinha+=nxIncrem
	TRACO_VERT_01
	oPrn:Say(nxLinha, 300, STR0081,    aFontes:ARIAL_10_BOLD) //"Despesas"
	oPrn:Say(nxLinha,1010, STR0100, aFontes:ARIAL_08_BOLD,,,,1) //"Val.Unit.R$"
	oPrn:Say(nxLinha,1270, STR0101,aFontes:ARIAL_08_BOLD,,,,1) //"Val.Unit.US$"
	oPrn:Say(nxLinha,1530, STR0102, aFontes:ARIAL_08_BOLD,,,,1) //"Val.Tot. R$"
	oPrn:Say(nxLinha,1790, STR0103,aFontes:ARIAL_08_BOLD,,,,1) //"Val.Tot. US$"
	oPrn:Say(nxLinha,1990, STR0084,       aFontes:ARIAL_08_BOLD,,,,1) //"% FOB"
	oPrn:Say(nxLinha,2140, STR0085,        aFontes:ARIAL_08_BOLD,,,,1) //"ICMS"
	oPrn:Say(nxLinha,2290, STR0085,        aFontes:ARIAL_08_BOLD,,,,1) //"ICMS"
	nxLinha+=nxIncrem
	TRACO_NORMAL
EndIf
Return


*===================================*
Static FUNCTION ICus_TitRel(cxTitRel)
*===================================*
If nxLinha >= 3000-160
   COMECA_PAGINA
ENDIF
oPrn:BOX(nxLinha,1600,(nxLinha+150),2300)
oPrn:BOX((nxLinha+5),(1600+5),((nxLinha+150)-5),(2300-5))
oPrn:Say((nxLinha+55),1800,cxTitRel,aFontes:ARIAL_13_BOLD)
nxLinha+=150	
Return

*===================================*
Static Function DI155NFE(nTipoNF)
*===================================*
PRIVATE cTitulo:=STR0120  //"Solicitação de "

lMV_PIS_EIC:=GETMV("MV_PIS_EIC",,.F.) .AND. EI2->(FIELDPOS("EI2_VLRPIS")) # 0 .AND. SYD->(FIELDPOS("YD_PER_PIS")) # 0 .AND. WORK1->(FIELDPOS("WKVLUPIS")) # 0

DO CASE
   CASE nTipoNF == 1 ; cTitulo += STR0121 //"N.F.E. (Primeira)"
   CASE nTipoNF == 2 ; cTitulo += STR0122 //"N.F.E. (Complementar)"
   CASE nTipoNF == 3 ; cTitulo += STR0123	 //"N.F.E. (Única)"
EndCASE

IF(ExistBlock("EICDI155"),Execblock("EICDI155",.F.,.F.,"TITULO"),)   

#DEFINE COURIER_07  oFont1
#DEFINE COURIER_N   oFont2
#DEFINE COURIER_08  oFont3
#DEFINE COURIER_10  oFont4
#DEFINE COURIER_12  oFont5  


PRINT oPrn NAME ''
      oPrn:SetLandsCape()
ENDPRINT

AVPRINT oPrn NAME cTitulo

   DEFINE FONT oFont1  NAME 'Courier New' SIZE 0,07 OF  oPrn
   DEFINE FONT oFont2  NAME 'Courier New' SIZE 0,08 OF  oPrn BOLD
   DEFINE FONT oFont3  NAME 'Courier New' SIZE 0,08 OF  oPrn
   DEFINE FONT oFont4  NAME 'Courier New' SIZE 0,10 OF  oPrn
   DEFINE FONT oFont5  NAME 'Courier New' SIZE 0,12 OF  oPrn

   AVPAGE

      oPrn:oFont:=COURIER_07
      
      Processa( {||DI155RelNFE(nTipoNF)} ,STR0124,,.T.) //"Impressao da Nota Fiscal..."

   AVENDPAGE

AVENDPRINT

oFont1:End()
oFont2:End()
oFont3:End()
oFont4:End()
oFont5:End()
Work1->(DBSETORDER(1))
Work1->(DBGOTOP())

RETURN .T.
*----------------------------------------------------------------------------------*
Static Function DI155RelNFE(nTipoNF)
*----------------------------------------------------------------------------------*
PRIVATE lAbortPrint:=.F.
PRIVATE nItem:= nValMerc := nFrete:= nSeguro:= nCIF:= nIIVal:= nIPIVal:= nPISVal:= nCOFVal:= nICMSVal:= 0
PRIVATE nBaseICMS :=0
PRIVATE cPictNotaF:=IF(!EMPTY(AVSX3("WN_DOC",6)),AVSX3("WN_DOC",6),"@!")
PRIVATE cPictItem:= AVSX3('B1_COD',6)
PRIVATE cPictTec := AVSX3('B1_POSIPI',6)
PRIVATE cPictFre := '@E 9,999,999,999.99'
PRIVATE cPictSeg := '@E 999,999,999.99'
PRIVATE cPICT15_2:= '@E 99,999,999.99' //'@E 9,999,999,999.99'
PRIVATE cPICT06_2:= '@E 999.99'
PRIVATE cPICT09_4:= '@E 9,999.9999'
PRIVATE cPICTICMS:= AVSX3('YD_ICMS_RE',6)
PRIVATE cTitem   := AVSX3('WN_PRODUTO',5)

ProcRegua( SF1->(LASTREC()) + 10 )

IncProc(STR0125) //"Iniciando variaveis do relatorio, Aguarde..."
lPrimPag:= .T.
nLimPage:= 2150  //2200
nColFim := 2980  //3180
nLin    := 99999 
nPag    := 0 
cChave  := ''
cNFChave:= ''

IncProc(STR0125) //"Iniciando variaveis do relatorio, Aguarde..."
nCol01 := 0
nCol03 := nCol01
nCol05 := nCol01+145
nCol07 := nCol05+305
nCol08 := nCol07+265
nCol09 := nCol08+255
nCol10 := nCol09+230
nCol11 := nCol10+215
nCol12 := nCol11+115
nCol13 := nCol12+205
nCol14 := nCol13+235
nCol15 := nCol14+115
nCol16 := nCol15+205
IF lMV_PIS_EIC
   nCol17 := nCol16+185//120
   nCol18 := nCol17+205
   nCol19 := nCol18+185//120
   nCol20 := nCol19+205
   nCol21 := nCol20+115
ELSE
   nCol21 := nCol16+115
ENDIF
nCol22 := nCol21+205
nColFim:=nCol22

IncProc(STR0126) //"Ajustando arquivos, Aguarde..."
SF1->(DBSETORDER(5))
SWN->(DBSETORDER(2))
SW7->(DBSETORDER(1))
SW2->(DBSETORDER(1))

SW7->(DbSeek(xFILIAL('SW7')+SW6->W6_HAWB))
SW2->(DbSeek(xFilial("SW2")+SW7->W7_PO_NUM))

ProcRegua( Work1->(LASTREC()) )
Work1->(DBSETORDER(4))
Work1->(DBGOTOP())
Work1->(DBEVAL( {||DI155DetRel(.T.,nTipoNF)} ))
Work1->(DBGOTOP())

DI155Totais(nTipoNF)

SF1->(DBSETORDER(1))
SWN->(DBSETORDER(1))
SWZ->(DBSETORDER(1))
RETURN .T.
*----------------------------------*
STATIC FUNCTION DI155CabRel(lWork)
*----------------------------------*

IF lPrimPag
   lPrimPag:=.F.
   cNFChave:=TRANS(cNotaF,cPictNotaF)+" "+cSerie
ELSE
   AVNEWPAGE
ENDIF

nLin:= 100
nPag++

oPrn:Box( nLin,01,nLin+1,nColFim)
nLin+=25

oPrn:Say(nLin,01,SM0->M0_NOME,COURIER_12)
oPrn:Say(nLin,nColFim/2,cTitulo,COURIER_12,,,,2)
oPrn:Say(nLin,nColFim,STR0132+STR(nPag,8),COURIER_12,,,,1) //"Pagina..: "
nLin+=50

oPrn:Say(nLin,01,STR0133,COURIER_12) //"SIGAEIC"
oPrn:Say(nLin,nColFim/2,STR0134,COURIER_12,,,,2) //"Analítico"
oPrn:Say(nLin,nColFim,STR0135+DTOC(dDataBase),COURIER_12,,,,1) //"Emissao.: "
nLin+=50

oPrn:Box( nLin,01,nLin+1,nColFim)
nLin +=25

SYT->(DBSEEK(XFILIAL('SYT')+SW2->W2_IMPORT))

oPrn:Say(nLin,0001,STR0136+SW2->W2_IMPORT+" - "+ALLTRIM(SYT->YT_NOME)+" - "+ALLTRIM(SYT->YT_ENDE),COURIER_08) //"Empresa ..........: "
nLin+=45
oPrn:Say(nLin,0001,STR0137+SW6->W6_HAWB,COURIER_08) //"Processo..........: "
//oPrn:Say(nLin,0800,STR0138+SA2->A2_COD+" - "+ALLTRIM(SA2->A2_NREDUZ),COURIER_08) //"Fornecedor ............: "
oPrn:Say(nLin,0800,STR0139+SW6->W6_HOUSE,COURIER_08) //"Conhecimento.........: " //2400
oPrn:Say(nLin,1600,STR0143+DTOC(SW6->W6_DT_ENTR),COURIER_08) //"Dt. Entrega..........: "
nLin+=45
oPrn:Say(nLin,0001,STR0140+DTOC(SW6->W6_DT_HAWB),COURIER_08) //"Dt. Processo......: "
oPrn:Say(nLin,0800,STR0141+TRANS(SW6->W6_DI_NUM,'@R 99/9999999-9'),COURIER_08) //"D.I....................: "
oPrn:Say(nLin,1600,STR0142+DTOC(SW6->W6_DT),COURIER_08) //"Dt. D.I.............: "
nLin+=45
//oPrn:Say(nLin,0001,STR0144+TRANS(SW6->W6_TX_FOB ,AVSX3('W6_TX_FOB',6)),COURIER_08) //"Tx. Conversao FOB.: "
oPrn:Say(nLin,0001,STR0145+TRANS(SW6->W6_TX_US_D,AVSX3('W6_TX_US_D',6)),COURIER_08) //"Tx. Conversao US$ D.I..: "
oPrn:Say(nLin,0800,STR0146+TRANS(SW6->W6_TX_FRET,AVSX3('W6_TX_FRET',6)),COURIER_08) //"Tx. Conversao Frete.: "
oPrn:Say(nLin,1600,STR0147+TRANS(SW6->W6_TX_SEG,AVSX3('W6_TX_SEG',6)),COURIER_08) //"Tx. Conversao Seguro.: " //2400
nLin+=50

oPrn:Box( nLin,01,nLin+1,nColFim)
nLin +=25

//oPrn:Say( nLin,nCol03,STR0148,COURIER_07) //"Cod. Item"
oPrn:Say( nLin,nCol05,STR0149,COURIER_07,,,,1) //"Peso Líq."
oPrn:Say( nLin,nCol07,STR0151,COURIER_07,,,,1) //"Quantidade"
oPrn:Say( nLin,nCol08,STR0152,COURIER_07,,,,1) //"Preco"
oPrn:Say( nLin,nCol09,STR0153,COURIER_07,,,,1) //"Vlr Frete"
oPrn:Say( nLin,nCol10,STR0154,COURIER_07,,,,1) //"Vlr Seguro"
oPrn:Say( nLin,nCol11,STR0155,COURIER_07,,,,1) //"Vlr C.I.F."
oPrn:Say( nLin,nCol12,STR0156,COURIER_07,,,,1) //"%II"
oPrn:Say( nLin,nCol13,STR0157,COURIER_07,,,,1) //"Vlr II"
oPrn:Say( nLin,nCol14,STR0158,COURIER_07,,,,1) //"Vlr Mercadoria"
oPrn:Say( nLin,nCol15,STR0159,COURIER_07,,,,1) //"%IPI"
oPrn:Say( nLin,nCol16,STR0160,COURIER_07,,,,1) //"Vlr IPI"
IF lMV_PIS_EIC
   oPrn:Say( nLin,nCol17,"%/V Uni PIS"      ,COURIER_07,,,,1)
   oPrn:Say( nLin,nCol18,AVSX3("W8_VLRPIS",5),COURIER_07,,,,1)
   oPrn:Say( nLin,nCol19,"%/V Uni COF"      ,COURIER_07,,,,1)
   oPrn:Say( nLin,nCol20,AVSX3("W8_VLRCOF",5),COURIER_07,,,,1)
ENDIF
oPrn:Say( nLin,nCol21,STR0161,COURIER_07,,,,1) //"%ICMS"
oPrn:Say( nLin,nCol22,STR0162,COURIER_07,,,,1) //"Vlr ICMS"

nLin +=40
//oPrn:Say( nLin,nCol03,REPL('=',20           ),COURIER_07)
oPrn:Say( nLin,nCol05,REPL('=',LEN(cPeso   )),COURIER_07,,,,1)
oPrn:Say( nLin,nCol07,REPL('=',LEN(cUni+cQtde)),COURIER_07,,,,1)
oPrn:Say( nLin,nCol08,REPL('=',LEN(cPreco  )),COURIER_07,,,,1)
oPrn:Say( nLin,nCol09,REPL('=',LEN(cFrete  )),COURIER_07,,,,1)
oPrn:Say( nLin,nCol10,REPL('=',LEN(cSeguro )),COURIER_07,,,,1)
oPrn:Say( nLin,nCol11,REPL('=',LEN(cCIF    )),COURIER_07,,,,1)
oPrn:Say( nLin,nCol12,REPL('=',LEN(cIITx   )),COURIER_07,,,,1)
oPrn:Say( nLin,nCol13,REPL('=',LEN(cIIVal  )),COURIER_07,,,,1)
oPrn:Say( nLin,nCol14,REPL('=',LEN(cValMerc)+1),COURIER_07,,,,1)
oPrn:Say( nLin,nCol15,REPL('=',LEN(cIPITx  )),COURIER_07,,,,1)
oPrn:Say( nLin,nCol16,REPL('=',LEN(cIPIVal )),COURIER_07,,,,1)
IF lMV_PIS_EIC
   oPrn:Say( nLin,nCol17,REPL('=',LEN(cPISUni )+1),COURIER_07,,,,1)
   oPrn:Say( nLin,nCol18,REPL('=',LEN(cPISVal ))  ,COURIER_07,,,,1)
   oPrn:Say( nLin,nCol19,REPL('=',LEN(cCOFUni )+1),COURIER_07,,,,1)
   oPrn:Say( nLin,nCol20,REPL('=',LEN(cCOFVal ))  ,COURIER_07,,,,1)
ENDIF
oPrn:Say( nLin,nCol21,REPL('=',LEN(cICMS_A )),COURIER_07,,,,1)
oPrn:Say( nLin,nCol22,REPL('=',LEN(cICMSVal)),COURIER_07,,,,1)
nLin +=35

RETURN .T.
*----------------------------------------------------------------------------------*
Static Function DI155DetRel(lWork,nTipoNF)
*----------------------------------------------------------------------------------*
LOCAL lPassou:=.F.

cNotaF  := IF(lWork, Work1->WK_NFE    , SWN->WN_DOC     )
cSerie  := IF(lWork, Work1->WK_SE_NFE , SWN->WN_SERIE   )
cCFO    := IF(lWork, Work1->WK_CFO    , SWN->WN_CFO     )
cOperac := IF(lWork, Work1->WK_OPERACA, SWN->WN_OPERACA )
cPedido := IF(lWork, Work1->WKPO_NUM  , SWN->WN_PO_EIC  )
cForn   := Work1->WKFORN
cCod_I  := ALLTRIM(TRAN( Work1->WKCOD_I ,cPictItem))
cDescr  := LEFT( IF(lWork, Work1->WKDESCR   , SWN->WN_DESCR   ) ,25)
cUni    := BUSCA_UM(WORK1->WKCOD_I+WORK1->WKFABR +WORK1->WKFORN,WORK1->WK_CC+WORK1->WKSI_NUM)//IF(lWork, Work1->WKUNI, SWN->WN_UNI )
cPeso   := TRAN( DI155Valor(0,lWork,nTipoNF), cPictPeso)
cQtde   := TRAN( DI155Valor(1,lWork,nTipoNF),'@E 999,999,999.999' )
cPreco  := TRAN( DI155Valor(2,lWork,nTipoNF),'@E 999,999,999.9999')
cFrete  := TRAN( IF(lWork, Work1->WKFRETE   , SWN->WN_FRETE   ) ,cPictFre)
cSeguro := TRAN( IF(lWork, Work1->WKSEGURO  , SWN->WN_SEGURO  ) ,cPictSeg)
cCIF    := TRAN( IF(lWork, Work1->WKCIF     , SWN->WN_CIF     ) ,cPICT15_2)
cIITx   := TRAN( IF(lWork, Work1->WKIITX    , SWN->WN_IITX    ) ,cPICT06_2)
cIIVal  := TRAN( IF(lWork, Work1->WKIIVAL   , SWN->WN_IIVAL   ) ,cPICT15_2)
cValMerc:= TRAN( IF(lWork, Work1->WKVALMERC , SWN->WN_VALOR   ) ,cPICT15_2)
cIPITx  := TRAN( IF(lWork, Work1->WKIPITX   , SWN->WN_IPITX   ) ,cPICT06_2)
cIPIVal := TRAN( IF(lWork, Work1->WKIPIVAL  , SWN->WN_IPIVAL  ) ,cPICT15_2)
cICMS_A := TRAN( IF(lWork, Work1->WKICMS_A  , SWN->WN_ICMS_A  ) ,cPICTICMS)
cICMSVal:= TRAN( IF(lWork, Work1->WKVL_ICM  , SWN->WN_VL_ICM  ) ,cPICT15_2)
cTec    := TRAN( IF(lWork, Work1->WKTEC     , SWN->WN_TEC     ) ,cPictTec)
cEx_Ncm :=   "/"+IF(lWork, Work1->WKEX_NCM  , SWN->WN_EX_NCM  )
cEx_Nbm :=   "/"+IF(lWork, Work1->WKEX_NBM  , SWN->WN_EX_NBM  )
IF lMV_PIS_EIC
   cPISUni := TRAN( Work1->WKVLUPIS, cPICT09_4)
   cPISTx  := IF( EMPTY(Work1->WKVLUPIS) ,TRAN( Work1->WKPERPIS, cPICT06_2)+" %", cPISUni )
   cPISVal := TRAN( Work1->WKVLRPIS, cPICT15_2)
   cCOFUni := TRAN( Work1->WKVLUCOF, cPICT09_4)
   cCOFTx  := IF( EMPTY(Work1->WKVLUCOF) ,TRAN( Work1->WKPERCOF, cPICT06_2)+" %", cCOFUni )
   cCOFVal := TRAN( Work1->WKVLRCOF, cPICT15_2)
ENDIF

IncProc(STR0163+Work1->WKCOD_I) //"Imprimindo Item: "


IF nLin > nLimPage
   DI155CabRel(lWork)
   lPassou:=.T.
ENDIF                            

IF cChave # cNotaF+cSerie+cOperac+cTec+cEx_Ncm+cEx_Nbm+cPedido

   IF cNFChave # TRANS(cNotaF,cPictNotaF)+" "+cSerie
      IF(lPassou,nLin+=40,)
      DI155Totais(nTipoNF)
      cNFChave:= TRANS(cNotaF,cPictNotaF)+" "+cSerie
      lPassou := .F.
   ENDIF   

   IF nLin > nLimPage
      DI155CabRel(lWork)
      lPassou:=.T.
   ENDIF                            

   IF !lPassou 
      oPrn:Box( nLin,01,nLin+1,nColFim)
      nLin +=15
   ENDIF   
   SA2->(dBSeek(xFilial("SA2")+cForn))
   oPrn:Say( nLin,nCol01,STR0164+TRANS(cNotaF,cPictNotaF)+" "+cSerie+;//"Nota Fiscal: "
                         STR0165+cCFO+" - "+cOperac+;  //"        C.F.O.: "
                         STR0166+cTec+cEx_Ncm+cEx_Nbm+;//"      N.C.M.: "
                         STR0167+cPedido+;             //"         Pedido: "
                         LEFT(STR0138,11)+': '+SA2->A2_COD+" - "+ALLTRIM(SA2->A2_NREDUZ),COURIER_N)//"Fornecedor ............: "

   cChave  := cNotaF+cSerie+cOperac+cTec+cEx_Ncm+cEx_Nbm+cPedido
   nLin+=40
   oPrn:Box( nLin,01,nLin+1,nColFim)
   nLin +=15

   IF nLin > nLimPage
      DI155CabRel(lWork)
   ENDIF                            
ENDIF
IF(ExistBlock("EICDI155"),ExecBlock("EICDI155",.F.,.F.,"IMPRIMINDO_NOTA_FISCAL"),) // JBS - 21/05/2004
nItem++
//oPrn:Say( nLin,nCol03,cCod_I  ,COURIER_07)
oPrn:Say( nLin,nCol03, cTitem+": "+cCod_I+" - "+ALLTRIM(Work1->WKDESCR),COURIER_N)
nLin+=40             
oPrn:Say( nLin,nCol05,cPeso   ,COURIER_07,,,,1)
oPrn:Say( nLin,nCol07,cUni+cQtde   ,COURIER_07,,,,1)
oPrn:Say( nLin,nCol08,cPreco  ,COURIER_07,,,,1)
oPrn:Say( nLin,nCol09,cFrete  ,COURIER_07,,,,1)
oPrn:Say( nLin,nCol10,cSeguro ,COURIER_07,,,,1)
oPrn:Say( nLin,nCol11,cCIF    ,COURIER_07,,,,1)
oPrn:Say( nLin,nCol12,cIITx   ,COURIER_07,,,,1)
oPrn:Say( nLin,nCol13,cIIVal  ,COURIER_07,,,,1)
oPrn:Say( nLin,nCol14,cValMerc,COURIER_07,,,,1)
oPrn:Say( nLin,nCol15,cIPITx  ,COURIER_07,,,,1)
oPrn:Say( nLin,nCol16,cIPIVal ,COURIER_07,,,,1)
IF lMV_PIS_EIC
   oPrn:Say( nLin,nCol17,cPISTx  ,COURIER_07,,,,1)
   oPrn:Say( nLin,nCol18,cPISVal ,COURIER_07,,,,1)
   oPrn:Say( nLin,nCol19,cCOFTx  ,COURIER_07,,,,1)
   oPrn:Say( nLin,nCol20,cCOFVal ,COURIER_07,,,,1)
ENDIF
oPrn:Say( nLin,nCol21,cICMS_A ,COURIER_07,,,,1)
oPrn:Say( nLin,nCol22,cICMSVal,COURIER_07,,,,1)
nLin+=40             
   
nValMerc+= VAL(STR( IF(lWork, Work1->WKVALMERC , SWN->WN_VALOR   ) ,15,2))
nFrete  += VAL(STR( IF(lWork, Work1->WKFRETE   , SWN->WN_FRETE   ) ,15,2))
nSeguro += VAL(STR( IF(lWork, Work1->WKSEGURO  , SWN->WN_SEGURO  ) ,15,2))
nCIF    += VAL(STR( IF(lWork, Work1->WKCIF     , SWN->WN_CIF     ) ,15,2))
nIIVal  += VAL(STR( IF(lWork, Work1->WKIIVAL   , SWN->WN_IIVAL   ) ,15,2))
nIPIVal += VAL(STR( IF(lWork, Work1->WKIPIVAL  , SWN->WN_IPIVAL  ) ,15,2))
IF lMV_PIS_EIC
   nPISVal += Work1->WKVLRPIS
   nCOFVal += Work1->WKVLRCOF
ENDIF
nICMSVal+= VAL(STR( IF(lWork, Work1->WKVL_ICM  , SWN->WN_VL_ICM  ) ,15,2))
nBaseICMS+=VAL(STR( Work1->WKBASEICMS,15,2))

RETURN .T.
*----------------------------------------------------------------------------------*
Static Function DI155Valor(nTipo,lWork,nTipoNF)
*----------------------------------------------------------------------------------*
LOCAL nValor:=0

IF nTipoNF # 2//NFE_COMPLEMEN
   IF nTipo==0
      nValor:=IF(lWork,Work1->WKPESOL,SWN->WN_PESOL)
   ELSEIF nTipo==1
      nValor:=IF(lWork,Work1->WKQTDE ,SWN->WN_QUANT)
   ELSEIF nTipo==2
      nValor:=IF(lWork,Work1->WKPRUNI,SWN->WN_PRUNI)
   ENDIF
ENDIF

RETURN nValor

*---------------------------------------------------------------------------------*
Static FUNCTION DI155Totais(nTipoNF)
*---------------------------------------------------------------------------------*
IF nItem > 1
   oPrn:Say( nLin,nCol09,REPL('=',LEN(cPictFre)-3),COURIER_07,,,,1)
   oPrn:Say( nLin,nCol10,REPL('=',LEN(cPictSeg)-3),COURIER_07,,,,1)
   oPrn:Say( nLin,nCol11,REPL('=',LEN(cPICT15_2)-3),COURIER_07,,,,1)
   oPrn:Say( nLin,nCol13,REPL('=',LEN(cPICT15_2)-3),COURIER_07,,,,1)
   oPrn:Say( nLin,nCol14,REPL('=',LEN(cPICT15_2)-2),COURIER_07,,,,1)
   oPrn:Say( nLin,nCol16,REPL('=',LEN(cPICT15_2)-3),COURIER_07,,,,1)
   IF lMV_PIS_EIC
      oPrn:Say( nLin,nCol18,REPL('=',LEN(cPICT15_2)-3),COURIER_07,,,,1)
      oPrn:Say( nLin,nCol20,REPL('=',LEN(cPICT15_2)-3),COURIER_07,,,,1)
   ENDIF
   oPrn:Say( nLin,nCol22,REPL('=',LEN(cPICT15_2)-3),COURIER_07,,,,1)
   nLin +=30
   oPrn:Say( nLin,nCol09,TRAN(nFrete  ,cPictFre),COURIER_07,,,,1)
   oPrn:Say( nLin,nCol10,TRAN(nSeguro ,cPictSeg),COURIER_07,,,,1)
   oPrn:Say( nLin,nCol11,TRAN(nCIF    ,cPICT15_2),COURIER_07,,,,1)
   oPrn:Say( nLin,nCol13,TRAN(nIIVal  ,cPICT15_2),COURIER_07,,,,1)
   oPrn:Say( nLin,nCol14,TRAN(nValMerc,cPICT15_2),COURIER_07,,,,1)
   oPrn:Say( nLin,nCol16,TRAN(nIPIVal ,cPICT15_2),COURIER_07,,,,1)
   IF lMV_PIS_EIC
      oPrn:Say( nLin,nCol18,TRAN(nPISVal ,cPICT15_2),COURIER_07,,,,1)
      oPrn:Say( nLin,nCol20,TRAN(nCOFVal ,cPICT15_2),COURIER_07,,,,1)
   ENDIF
   oPrn:Say( nLin,nCol22,TRAN(nICMSVal,cPICT15_2),COURIER_07,,,,1)
   nLin +=40
ENDIF
oPrn:Say( nLin,nCol14,STR0168+cNFChave+STR0169+TRAN(nValMerc+nIPIVal,cPICT15_2),COURIER_10,,,,1) //"TOTAL N.F.E.: "###" (Vlr. Mercadoria + Vlr. I.P.I.).: "
nLin+=45
IF nTipoNF # 2
   oPrn:Say( nLin,nCol14,"Base do I.C.M.S.: "+TRAN(nBaseICMS,cPICT15_2),COURIER_10,,,,1)
   nLin+=45
ENDIF
nBaseICMS:=0
nItem:= nValMerc := nFrete:= nSeguro:= nCIF:= nIIVal:= nIPIVal:= nICMSVal :=nCOFVal:= nPISVal:= 0

RETURN .T.
*----------------------------------------*
Static Function RetCamb()
*----------------------------------------*	
nVLrDolar:= 0.00  //FCD  OS.: 0080/02 SO.: 0015/02	
nVlrDolar:= If(Left(TRB1->WK1DESP,3)$"701.702.703",0.00,TRB1->WK1VALCOM)//FCD  OS.: 0080/02 SO.: 0015/02
If Left(TRB1->WK1DESP,3)$"701.702.703"//FCD  OS.: 0080/02 SO.: 0015/02
   nVlrSom := nVlrSom+TRB1->WK1VALCOM//FCD  OS.: 0080/02 SO.: 0015/02
Endif            
If !lxDespDet.AND.Left(TRB1->WK1DESP,3)$"XXX"            
   nVlrSom := TRB1->WK1VALDES
Endif

Return(.T.)                 

*--------------------------------*
STATIC FUNCTION EICIN86(lDatas)
*--------------------------------*
LOCAL oDlg,nOpc:=0,cSerieDoc
LOCAL bArqValid:={||IF(IN86VALID("Arquivo",cModeloDoc) .AND.IN86VALID("Diretorio",cDir) ,.T.,.F.)}
LOCAL bOk,bCancel:={||nOpc:=0,oDlg:End()}
LOCAL dDataInicio:=dDataFinal:=CTOD(""),aEscolha:={"1-Enviar","2-Reenviar"}
LOCAL TB_Campos:={ {"MODELO" ,"","Modelo do Documento"},;
                   {"SERIE"  ,"","Serie/Sub. Documento"},;
                   {"DOC"    ,"","Nr. Nota Fiscal"},;
                   {"NRDINUM","","D.I."},;
                   {"IMPORTA","","Importador"},;
                   {"ARQUIVO","","Arquivo Gerado"}}
                   
PRIVATE cFilSW6:=xFilial("SW6"),cFilSF1:=xFilial("SF1")
PRIVATE cFilSW2:=xFilial("SW6"),cFilSW7:=xFilial("SF1")
PRIVATE cMarca := GetMark(), lInverte := .F.,cNomArq,lOk,cModeloDoc:=SPACE(02),cDir
cEscolha:=aEscolha[1]  

IF EMPTY(GETNEWPAR("MV_NF_IN86"," "))
   MSGINFO("Parametro MV_NF_IN86 nao cadastrado ou nao preenchido","Atencao" )
   RETURN .F.
ENDIF

IF Empty((cDir:=ALLTRIM(GETMV("MV_PATH_IN"))))
   cDir := Padr(CurDir(),30)
ENDIF                       

IF RIGHT(cDir,1) # "\"
   cDir := cDir+"\"
ENDIF                                             

cDir := Alltrim(cDir)+Space(30-Len(Alltrim(cDir)))

IF lDatas
   
   bOk:={||IF(E_PERIODO_OK(@dDataInicio,@dDataFinal),(nOpc:=1,oDlg:End()),)} 
   nOpc:=0
   
   DEFINE MSDIALOG oDlg TITLE "Data de Emissao" From 9,0 To 20,50 OF oMainWnd
      
   @ 28,03 SAY "Data Inicial" PIXEL
   @ 41,03 SAY "Data Final"   PIXEL
   @ 54,03 SAY "Notas"        PIXEL
      
   @ 28,45 GET dDataInicio SIZE 40,05 PIXEL
   @ 41,45 GET dDataFinal  SIZE 40,05 PIXEL
   

   @ 54,45 COMBOBOX cEscolha ITEMS aEscolha SIZE 55,05 PIXEL
   
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED      
     
   IF nOpc==0      
      RETURN .T.
   ENDIF
   
ENDIF                                              


bOk:={||IF(EVAL(bArqValid),(nOpc:=1,oDlg:End()),)} 
nOpc:=0

DO WHILE .T.

   DEFINE MSDIALOG oDlg TITLE "Gera Arquivo" From 9,0 To 18,50 OF oMainWnd 

   @ 28,03 SAY "Modelo Doc."  PIXEL
   @ 41,03 SAY "Diretorio"    PIXEL

   @ 28,45 GET cModeloDoc SIZE 30,8              VALID IN86VALID("Modelo",cModeloDoc)  PIXEL
   @ 41,45 GET cDir    SIZE 95,8 PICTURE '@!' VALID IN86VALID("Diretorio",cDir) PIXEL


   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED
   
   IF nOpc==0
      EXIT
   ENDIF   
   
   PROCESSA({||lOk:=DI155CriaArq(lDatas,dDataInicio,dDataFinal)})
   
   IF !lOk
      EXIT
   ENDIF

   WORK_IN->(DBGOTOP())
   oMainWnd:ReadClientCoors()
	DEFINE MSDIALOG oDlg TITLE "Arquivo(s) Gerado(s)" ;
	   FROM oMainWnd:nTop+125,oMainWnd:nLeft+5 TO oMainWnd:nBottom-60,oMainWnd:nRight-10 OF oMainWnd PIXEL	   
   	oMark:= MsSelect():New("WORK_IN",,,TB_Campos,@lInverte,@cMarca,{34,1,(oDlg:nHeight-30)/2,(oDlg:nClientWidth-4)/2})
  	   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},;
	                                                  {||oDlg:End()})	
	                                                  
	  WORK_IN->(E_EraseArq(cNomArq))
	  EXIT                                                

ENDDO   
SF1->(DBSETORDER(1))

RETURN .T.   

*-------------------------------------------------------------*
STATIC FUNCTION DI155CriaArq(lDatas,dDataInicio,dDataFinal)
*-------------------------------------------------------------*
LOCAL cWhile,lSeek,nRegua:=10,nCont:=0//,ENTER:=CHR(13)+CHR(10)
LOCAL cArquivo,cTexto,cFilSX6:=xFilial("SX6"),nSeq:=0,cNome
LOCAL cParametro,cMensagem:="Nao foi encontrada nenhuma Nota Fiscal para "+SUBSTR(cEscolha,3)+" no Periodo de "+DTOC(dDataInicio)+" a "+DTOC(dDataFinal)

LOCAL aDBF:={{"MODELO" ,"C",02,00},;
             {"SERIE"  ,"C",05,00},;
             {"DOC"    ,"C",06,00},;
             {"EMISSAO","C",08,00},;
             {"ARQUIVO","C",50,00},;
             {"RECSW6" ,"N",7,00},;
             {"IMPORTA","C",AVSX3("YT_COD_IM",3),0},;
             {"NRDINUM","C",10,00}}
             
PRIVATE aHeader[0],aCampos:={}//E_CriaTrab utiliza


cParametro:=GETNEWPAR("MV_NF_IN86","1") 


nSeq:=VAL(RIGHT(cParametro,4))

PROCREGUA(2)
INCPROC("Criando Arquivos Temporarios","Aguarde")
cNomArq:=E_CriaTrab(,aDBF,"WORK_IN")

IF !USED()
   MSGINFO("Nao foi possivel criar Temporario")
   RETURN .F.
ENDIF   

INCPROC()
INDREGUA("WORK_IN",cNomArq+OrdBagExt(),"NRDINUM+EMISSAO")

IF lDatas 
   nRegua:=SF1->(LASTREC())
   SF1->(DBSEEK(cFilSF1))
   bWhile:={||.T.}
ELSE                                         
   SF1->(DBSETORDER(5))//F1_FILIAL+F1_HAWB+F1_TIPO_NF
   SF1->(DBSEEK(cFilSF1+SW6->W6_HAWB))   
   bWhile:={||SF1->F1_FILIAL+SF1->F1_HAWB==cFilSF1+SW6->W6_HAWB}
   
ENDIF
SW2->(DBSETORDER(1))
SW7->(DBSETORDER(1))

PROCREGUA(nRegua)
   
DO WHILE SF1->(!EOF()) .AND. EVAL(bWhile)

   INCPROC("Lendo Nota "+SF1->F1_DOC)
   nCont++
   
   IF nRegua==nCont
      PROCREGUA(nRegua)
      nCont:=0
   ENDIF
   
   IF lDatas
   
      IF !(SF1->F1_EMISSAO>=dDataInicio .AND. SF1->F1_EMISSAO<=dDataFinal)
         SF1->(DBSKIP())
         LOOP   
      ENDIF
      
      IF SW6->(DBSEEK(cFilSW6+SF1->F1_HAWB)) 
        IF (LEFT(cEscolha,1)=="1" .AND. !EMPTY(SW6->W6_NORMATI)) .OR. (LEFT(cEscolha,1)=="2" .AND. EMPTY(SW6->W6_NORMATI))
           SF1->(DBSKIP())
           LOOP
        ENDIF
      ELSE
        SF1->(DBSKIP())
        LOOP           
      ENDIF
   ENDIF
   

   
   cSerieDoc:=SF1->F1_SERIE+SPACE(5-LEN(SF1->F1_SERIE))         
   SW7->(DBSEEK(cFilSW7+SW6->W6_HAWB))
   SW2->(DBSEEK(cFilSW2+SW7->W7_PO_NUM ))
   
   WORK_IN->(DBAPPEND())
   WORK_IN->MODELO :=cModeloDoc
   WORK_IN->SERIE  :=cSerieDoc
   WORK_IN->DOC    :=SF1->F1_DOC
   WORK_IN->EMISSAO:=Subs(DTOC(SF1->F1_EMISSAO),1,2)+Subs(DTOC(SF1->F1_EMISSAO),4,2)+Str(Year(SF1->F1_EMISSAO),4)
   WORK_IN->IMPORTA:=SW2->W2_IMPORT
   WORK_IN->NRDINUM:=SW6->W6_DI_NUM
   WORK_IN->RECSW6 :=SW6->(RECNO())
   
   IF(ExistBlock("EICDI155"),ExecBlock("EICDI155",.F.,.F.,"APOS_GRV_WORK"),)
   
   SF1->(DBSKIP())    

ENDDO

IF WORK_IN->(RECCOUNT())==0
   IF YEAR(dDataInicio)==1950 .AND. YEAR(dDataFinal)==2999
      cMensagem:="Nao foi encontrada nenhuma Nota Fiscal para "+SUBSTR(cEscolha,3)+" entre o Periodo Geral"
   ENDIF   
   MSGINFO(cMensagem)   
   WORK_IN->(E_EraseArq(cNomArq))
   RETURN .F.   
ENDIF

PROCREGUA(WORK_IN->(RECCOUNT()))
cArquivo:=Alltrim(cDir)+If(Right(Alltrim(cDir),1)="\","","\")

   
WORK_IN->(DBGOTOP())
DO WHILE WORK_IN->(!EOF())
   cImportador:=WORK_IN->IMPORTA
   nSeq++   
   cNome:=LEFT(cParametro,LEN(cParametro)-4)+ALLTRIM(cImportador)+STRZERO(nSeq,4)   
   hFile:= FCreate(cArquivo+cNome+".TXT",0)
   
   IF hFile==-1
      MsgStop("Erro na criacao do arquivo: "+cArquivo+cNome+".TXT","Atencao")
      EXIT
   ENDIF  

   DO WHILE WORK_IN->(!EOF()) .AND. cImportador==WORK_IN->IMPORTA
     WORK_IN->ARQUIVO:=cArquivo+cNome+".TXT"
     cTexto:=WORK_IN->MODELO+WORK_IN->SERIE+WORK_IN->DOC+WORK_IN->EMISSAO+WORK_IN->NRDINUM+ENTER
     Fwrite(hFile,cTexto)          
     
     SW6->(DBGOTO(WORK_IN->RECSW6))     
     SW6->(RECLOCK("SW6",.F.))
     SW6->W6_NORMATI:="1"
     SW6->(MSUNLOCK())     
         
     WORK_IN->(DBSKIP())
   ENDDO
   
   FClose(hFile)
ENDDO
cNome:=LEFT(cParametro,LEN(cParametro)-4)+STRZERO(nSeq,4)
SETMV("MV_NF_IN86",cNome)
RETURN .T.
*-------------------------------------*
STATIC FUNCTION IN86VALID(cTipo,cVar)
*-------------------------------------*
DO CASE 

   CASE  cTipo =="Modelo"
         IF EMPTY(cVar)
            MsgInfo("Modelo Doc. não informado","Informacao")
            RETURN .F.
         ENDIF

   CASE cTipo =="Diretorio"
        IF EMPTY(cVar)
           MsgInfo("Diretorio não informado.","Informação")
           RETURN .F. 
        ENDIF              
        
ENDCASE

RETURN .T.                 

*======================================================================================*
*                            FIM DO PROGRAMA EICDI155.PRW                              *
*======================================================================================*
