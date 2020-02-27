#INCLUDE "EECPEM09.ch"

/*
Programa        : EECPEM09.PRW
Objetivo        : Impressao de Remessa Documentos REM00001.RPT
Autor           : Heder M Oliveira
Data/Hora       : 27/09/99
Revisao         : Jeferson Barros Jr.
Data/Hora       : 05/12/03 - 15:00.
Obs.            :
*/

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

/*
Funcao      : MDBORD01
Parametros  :
Retorno     :
Objetivos   : Emissao de Bordero em Crystal
Autor       : Luis Henrique de Oliveira
Data/Hora   : 02/12/01 09:37
Revisao     :
Obs.        :
*/
User Function MDBORD01()

Local lRet := .t.
Local _aArea := getArea()
Local _cMercadoria := ""
Local _aMensagem := {}
Local _nTotCom := 0
Local _aCambio := {}
Local W,z

Private aDocumentos:={}  // Array com as informações dos documentos a serem anexados a carta remessa.

AADD(aDocumentos,{"INVOICE",1,0,.F.})
AADD(aDocumentos,{"PACKING LIST",1,0,.F.})
AADD(aDocumentos,{"B/L OU AWB",1,0,.F.})
AADD(aDocumentos,{"SAQUE",1,0,.F.})

cFileMen:=""

EEC->(dbsetorder(1))

Begin Sequence

IF ! TelaGets()
	Break
Endif

cSeqRel := GetSXENum("SY0","Y0_SEQREL")
ConfirmSX8()


HEADER_P->(Add())

//CABECALHO DA FILIAL
dbSelectArea("SM0")
dbSetOrder(1)
dbSeek(cEmpAnt+cFilAnt)

HEADER_P->AVG_C03_60 := ALLTRIM(SM0->M0_ENDCOB) + " - " + ALLTRIM(SM0->M0_CIDCOB)+" - "+ALLTRIM(SM0->M0_ESTCOB)
HEADER_P->AVG_C07_20 := ALLTRIM(SM0->M0_CEPCOB)+" - BRASIL"
HEADER_P->AVG_C06_30 := "Fone : "+ALLTRIM(SM0->M0_TEL)
HEADER_P->AVG_C07_30 :=+" - Fax : "+ALLTRiM(SM0->M0_FAX)
HEADER_P->AVG_C08_30 := "CNPJ : "+ALLTRIM(SM0->M0_CGC)
HEADER_P->AVG_C09_30 :=+" - Inscr Estadual : "+ALLTRIM(SM0->M0_INSC)


// ** Nome do Beneficiario.
IF !Empty(EEC->EEC_EXPORT)
	SA2->(DbSeek(xFilial("SA2")+EEC->EEC_EXPORT))
Else
	SA2->(DbSeek(xFilial("SA2")+EEC->EEC_FORN))
Endif

cExpMun := Alltrim(SA2->A2_MUN)
cExpMun := "Sao Paulo"

//   	HEADER_P->AVG_C01_60	:= IncSpace(AllTrim(cExpMun)+", "+Upper(cMonth(EEC->EEC_DTCONH))+" "+AllTrim(Str(Day(EEC->EEC_DTCONH)))+", "+Str(Year(EEC->EEC_DTCONH),4),60,.f.)
HEADER_P->AVG_C01_60	:= IncSpace(AllTrim(cExpMun)+", "+Upper(cMonth(dDataBase))+" "+AllTrim(Str(Day(dDataBase)))+", "+Str(Year(dDataBase),4),60,.f.)

//BANCO OPERADOR DE CAMBIO
dbSelectArea("EEJ")
dbSetOrder(1)
dbSeek(xfilial("EEJ")+EEC->EEC_PEDREF)
While ! EEJ->(eof()) .and. xfilial("EEJ")+EEC->EEC_PEDREF == EEJ->EEJ_FILIAL+EEJ->EEJ_PEDIDO
	
	if substr(EEJ->EEJ_TIPOBC,1,1) == "I"
		HEADER_P->AVG_C02_60 := EEJ->EEJ_NOME
		exit
	Endif
	
	EEJ->(dbSkip())
End

//NUMERO DA OPERACAO DE CAMBIO
dbSelectArea("EEQ")
dbSetOrder(1)  


dbSeek(xfilial("EEQ")+EEC->EEC_PREEMB)
_nTotCamb := 0
_cMoeda := EEQ->EEQ_MOEDA
While ! eof() .and. 	xfilial("EEQ")+EEC->EEC_PREEMB  == EEQ->EEQ_FILIAL+EEQ->EEQ_PREEMB
	                   
	IF EEQ->EEQ_TIPO $ "AR"
	
		_cNrOP := if(empty(EEQ->EEQ_NROP),"A FECHAR",EEQ->EEQ_NROP)
		_cDtNego := if(empty(EEQ->EEQ_DTNEGO),"",dtoc(EEQ->EEQ_DTNEGO))	          
		aadd(_aCambio,{_cNrOP,_cDtNego,alltrim(_cMoeda)+" "+Transform(EEQ->EEQ_VL - EEQ->EEQ_CGRAFI, "999,999,999.99")})
		_nTotCamb 	+= EEQ->EEQ_VL
		_nTotCom 	+= EEQ->EEQ_CGRAFI
	ENDIF	
	
	EEQ->(dbSkip())
	
End                       


if len(_aCambio) == 3

	HEADER_P->AVG_C09_20 	:= _aCambio[3][1]
	HEADER_P->AVG_C04_10	:= _aCambio[3][2]
	HEADER_P->AVG_C11_20 	:= _aCambio[3][3]
	
Endif	
		
if len(_aCambio) >= 2

	HEADER_P->AVG_C08_20 	:= _aCambio[2][1]
	HEADER_P->AVG_C03_10	:= _aCambio[2][2]
	HEADER_P->AVG_C10_20 	:= _aCambio[2][3]
				
Endif
	
if len(_aCambio) >= 1

	HEADER_P->AVG_C01_20 	:= _aCambio[1][1]
	HEADER_P->AVG_C01_10	:= _aCambio[1][2]
	HEADER_P->AVG_C02_20 	:= _aCambio[1][3]
				
Endif
                                                 
_nSaldoCambio := EEC->EEC_TOTPED - _nTotCamb
if  _nSaldoCambio > 0  .and.  len(_aCambio) < 3

	if len(_aCambio) = 0
		HEADER_P->AVG_C01_20 	:= "CAMBIO PRONTO"
		HEADER_P->AVG_C02_20 	:= alltrim(_cMoeda)+" "+Transform(_nSaldoCambio, "999,999,999.99")
	Endif     

	if len(_aCambio) = 1
		HEADER_P->AVG_C08_20 	:= "CAMBIO PRONTO"
		HEADER_P->AVG_C10_20 	:= alltrim(_cMoeda)+" "+Transform(_nSaldoCambio, "999,999,999.99")	
	Endif     

	if len(_aCambio) = 2
		HEADER_P->AVG_C09_20 	:= "CAMBIO PRONTO"
		HEADER_P->AVG_C11_20 	:= alltrim(_cMoeda)+" "+Transform(_nSaldoCambio, "999,999,999.99")	
	Endif     

Endif	

cCondPagto := Padr(SY6Descricao(EEC->EEC_CONDPA+STR(EEC->EEC_DIASPA,AVSX3("Y6_DIAS_PA",3)),"INGLES-INGLES"),60)
HEADER_P->AVG_C05_30	:= cCondPagto

dbSelectArea("EE9")
dbSetOrder(2)
if dbSeek(xfilial("EE9")+EEC->EEC_PREEMB)
	HEADER_P->AVG_C01_30	:= EE9->EE9_RE       //NR. RE
	HEADER_P->AVG_C02_30	:= EE9->EE9_NRSD	//NR. SD
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	if dbSeek(xfilial("SB1")+EE9->EE9_COD_I)
		
		dbSelectArea("SYD")   //ncm
		dbSetOrder(1)
		if dbSeek(xfilial("SYD")+SB1->B1_POSIPI)
			_cMercadoria := SYD->YD_DESC_P
		Endif
		
	Endif
	
Endif


HEADER_P->AVG_C06_20 := alltrim(_cMoeda)+" "+Transform(_nTotCamb , "999,999,999.99")  //IMPORTANCIA


HEADER_P->AVG_C03_20:= EEC->EEC_PREEMB   //SAQUE
HEADER_P->AVG_C03_30:= EEC->EEC_IMPODE	//SACADO
HEADER_P->AVG_C04_30:= _cMercadoria 	//MERCADORIA
HEADER_P->AVG_C04_20:= EEC->EEC_VIAGEM	//NAVIO

//DESTINO
dbSelectArea("SY9")
dbSetOrder(2)
if dbSeek(xfilial("SY9")+EEC->EEC_DEST)
	HEADER_P->AVG_C05_20:= SY9->Y9_CIDADE
Endif

If !EOF("EEB") .and. _nTotCom > 0
//If Alltrim(_cMoeda) <> "US$" .AND.   ! EOF("EEB")
	
	_cDeduzir := "DEDUZIR DOS PRODUTOS A QUANTIA DE :   "
	_cDeduzir += alltrim(_cMoeda)+" "+Transform(_nTotCom, "999,999,999.99") //COMISSAO DA INSTRUCAO ESPECIAL
	HEADER_P->AVG_C01100:= _cDeduzir
	
	dbSelectArea("EEB")
	dbSetOrder(1)
	dbSeek(xFilial("EEB")+EEC->EEC_PREEMB)

//	Alert('COD AGENTE: '+EEB->EEB_CODAGE+ " PROCESSO "+EEB->EEB_PEDIDO)
	dbSelectARea("SY5")
	dbSetOrder(1)
	dbseek(xfilial("SY5")+EEB->EEB_CODAGE)
	
	_cTexto := SY5->Y5_XTXTBOR
	
	nCol:=100
	
	nTotLin:=MLCOUNT(_cTexto,nCol)
	
	FOR W := 1 TO nTotLin
		If !EMPTY(MEMOLINE(_cTexto,nCol,W))
			aadd(_aMensagem,MEMOLINE(_cTexto,nCol,W))
		EndIf
	NEXT
	
	
	HEADER_P->AVG_C02100:= "E pagar a : "+SY5->Y5_NOME
	HEADER_P->AVG_C03100:= "            "+SY5->Y5_END
	HEADER_P->AVG_C04100:= "            "+SY5->Y5_BAIRRO
	
	
	HEADER_P->AVG_C02150:= if(len(_aMensagem) >= 1,_aMensagem[1],"")
	HEADER_P->AVG_C03150:= if(len(_aMensagem) >= 2,_aMensagem[2],"")
	HEADER_P->AVG_C04150:= if(len(_aMensagem) >= 3,_aMensagem[3],"")
	HEADER_P->AVG_C05150:= if(len(_aMensagem) >= 4,_aMensagem[4],"")
	HEADER_P->AVG_C06150:= if(len(_aMensagem) >= 5,_aMensagem[5],"")
	
ENDIF

HEADER_P->(dbUnlock())


// ** Tratamento para o sub-relatório de documentos.
If Len(aDocumentos) > 0
	For z:=1 To Len(aDocumentos)
		If !(aDocumentos[z][4])
			
			Detail_p->(add())
			Detail_p->AVG_C01_10  := "_DOC"
			Detail_p->AVG_C01_60  := Memoline(AllTrim(aDocumentos[z][1]),60,1)
			Detail_p->AVG_C01_20  := Str(aDocumentos[z][2],2,0)+" / "+Str(aDocumentos[z][3],2,0)
			Detail_P->(dbUnlock())
			
		EndIf
	Next
EndIf



//*** JBJ - 19/06/01 - 11:56 - Gravar histórico de documentos - (INICIO)

HEADER_H->(dbAppend())
AvReplace("HEADER_P","HEADER_H")

DETAIL_P->(DBSETORDER(0),DbGoTop())
Do While ! DETAIL_P->(Eof())
	DETAIL_H->(DbAppend())
	AvReplace("DETAIL_P","DETAIL_H")
	DETAIL_P->(DbSkip())
EndDo
DETAIL_P->(DBSETORDER(1))
//*** (FIM)
HEADER_P->(DBCOMMIT())
DETAIL_P->(DBCOMMIT())




End Sequence


RestArea(_aArea)
Return lRet

/*
Funcao      : TelaGets
Parametros  :
Retorno     :
Objetivos   :
Autor       : Heder M Oliveira
Data/Hora   :
Revisao     : Jeferson Barros Jr.
Data/Hora   : 05/12/03 - 15:00.
Obs.        :
*/
*-----------------------*
Static Function TelaGets
*-----------------------*
Local lRet := .f.
Local oDlg, oMark, oFldF,oFld
Local aFld, aButtons:={}
Local xx := ""

/*Local bHide := {|| oMark:oBrowse:Hide() },;
//bShow := {|o| dbSelectArea("Work_Men"),;
o := oMark:oBrowse,;
o:Show(),o:SetFocus() }
*/
Local bOk := {|| If(ValDocs(),(oDlg:End(), lRet:=.t.),nil)},;
bCancel := {|| oDlg:End()}

Begin Sequence

aAdd(aButtons,{"EDITABLE",{|| aDocumentos:=EECSelDocs(aDocumentos)},STR0054}) //"Documentos Anexos"

DEFINE MSDIALOG oDlg TITLE "BORDERO" FROM 200,1 TO 580,600 PIXEL OF oMainWnd //620,600

//      oFLDF:=aFLD[3] //MENSAGENS

oMark := EECMensagem(EEC->EEC_IDIOMA,"5",{28,3,150,296},,,,oDlg) //150/300

//      Eval(bHide)

//      oFld:bChange := {|nOption,nOldOption| if(nOption==3,Eval(bShow),Eval(bHide)) }

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel,,aButtons) CENTERED

End Sequence

Return lRet

/*
Funcao      : ValDocs().
Parametros  : Nenhum.
Objetivos   : Validar os documentos em anexo.
Retorno     : .t./.f.
Autor       : Jeferson Barros Jr.
Data/Hora   : 08/12/03 - 08:35
Obs.        :
*/
*-----------------------*
Static Function ValDocs()
*-----------------------*
Local lRet:=.t.
// Local aAux:={}, cMsg:="", j:=0, z:=0

Begin Sequence

If Len(aDocumentos) = 0 // Verifica se algum documento já foi anexado a carta remessa.
	MsgStop(STR0055,STR0056) //"Informe os documentos anexos !"###"Atenção"
	lRet:=.f.
	Break
EndIf

End Sequence

Return lRet

/*
Funcao      : Add
Parametros  :
Retorno     :
Objetivos   :
Autor       : Cristiano A. Ferreira
Data/Hora   : 21/01/2000 16:37
Revisao     :
Obs.        :
*/
Static Function Add

Begin Sequence
dbAppend()

bAux:=FieldWBlock("AVG_FILIAL",Select())

IF ValType(bAux) == "B"
	Eval(bAux,xFilial("SY0"))
Endif

bAux:=FieldWBlock("AVG_CHAVE",Select())

IF ValType(bAux) == "B"
	Eval(bAux,EEC->EEC_PREEMB)
Endif

bAux:=FieldWBlock("AVG_SEQREL",Select())

IF ValType(bAux) == "B"
	Eval(bAux,cSeqRel)
Endif
End Sequence

Return NIL



******************************************************************************************************************
*   FIM DO RDMAKE EECPEM09_RDM																					 *
******************************************************************************************************************


