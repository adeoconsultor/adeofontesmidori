#INCLUDE "EECPEM09.ch"
#include "EECRDM.CH"

/*
Funcao      : MD0010
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Luis Henrique de Oliveira
Data/Hora   : 02/12/01 09:37
Revisao     :
Obs.        :
*/
User Function MD0010()

Local lRet := .t.
Local _aArea := getArea()
Local _cMercadoria := ""
Local _aMensagem := {}
Local z
Private mDet := ""
Private mDetalhe:= ""

Private aDocumentos:={}  // Array com as informações dos documentos a serem anexados a carta remessa.

AADD(aDocumentos,{"INVOICE",1,0,.F.})	
AADD(aDocumentos,{"PACKING LIST",1,0,.F.})	
AADD(aDocumentos,{"B/L OU AWB",1,0,.F.})	
AADD(aDocumentos,{"SAQUE",1,0,.F.})	

cFileMen:=""

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

HEADER_P->AVG_C05_60 := ALLTRIM(SM0->M0_ENDCOB) + " - " + ALLTRIM(SM0->M0_CIDCOB)+" - "+ALLTRIM(SM0->M0_ESTCOB)
HEADER_P->AVG_C04_20 := ALLTRIM(SM0->M0_CEPCOB)+" - BRASIL"
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
                       
   	HEADER_P->AVG_C01_60	:= Upper(cMonth(dDataBase))+" "+AllTrim(Str(Day(dDataBAse)))+", "+Str(Year(dDataBase),4)
                        
	IF EMPTY(EEC->EEC_CONSIG)
		HEADER_P->AVG_C02_60	:= EEC->EEC_IMPODE // IMPORTADOR
    ELSE
		HEADER_P->AVG_C02_60	:= GETADVFVAL("SA1","A1_NOME",XFILIAL("SA1")+EEC->EEC_CONSIG+EEC->EEC_COLOJA,1,"") // CONSIGNATARIO   
    ENDIF
                              	
	HEADER_P->AVG_C01_20 	:= EEC->EEC_NRCONH // AWB NUMBER
	HEADER_P->AVG_C02_20	:= EEC->EEC_VIAGEM // VESSEL NAME         
	
	dbSelectArea("EXP")
	dbSetOrder(1)
	if dbSeek(xfilial("EXP")+EEC->EEC_PREEMB)
		HEADER_P->AVG_C03_20 	:= EXP->EXP_NRINVO // INVOICE NUMBER
	Endif
	
	HEADER_P->AVG_C03_60 	:= EEC->EEC_REFIMP // CUSTOMER ORDER NUMBER

    
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

   //executar rotina de manutencao de caixa de texto
	//   lRet := E_AVGLTT("M",WORKID->EEA_TITULO,"AVG_C01150")

	
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
                                                        
IF(SELECT("Work_Men")>0,Work_Men->(E_EraseArq(cFileMen)),)

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

Local bHide := {|| oMark:oBrowse:Hide() },;
      bShow := {|o| dbSelectArea("Work_Men"),;
                    o := oMark:oBrowse,;
                    o:Show(),o:SetFocus() }

Local bOk := {|| If(ValDocs(),(oDlg:End(), lRet:=.t.),nil)},;
      bCancel := {|| oDlg:End()}
      
Begin Sequence

   aAdd(aButtons,{"EDITABLE",{|| aDocumentos:=EECSelDocs(aDocumentos)},STR0054}) //"Documentos Anexos"

   DEFINE MSDIALOG oDlg TITLE AllTrim(WorkId->EEA_TITULO) FROM 200,1 TO 580,600 PIXEL OF oMainWnd //620,600

//      oFLDF:=aFLD[3] //MENSAGENS             
      
//      oMark := EECMensagem(EEC->EEC_IDIOMA,"5",{28,3,150,296},,,,oDlg) //150/300

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


