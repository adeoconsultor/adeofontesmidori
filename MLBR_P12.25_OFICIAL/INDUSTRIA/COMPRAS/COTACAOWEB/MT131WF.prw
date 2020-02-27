#include "Protheus.ch"
#include "rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
/*---------------------------------------------------------
Funcao: XMNTAPS()  |Autor: AOliveira    |Data: 21/11/2017
-----------------------------------------------------------
Descr.: Ponto de entrada para envio de Workflow na cotação
de compras
-----------------------------------------------------------
Uso:    MIDIRI
---------------------------------------------------------*/
User Function MT131WF(oProcess)

Local _aArea    := GetArea()
Local _aAreaSC8 := SC8->(GetArea())
Local _aAreaSY1 := SY1->(GetArea())
Local _aAreaSA2 := SA2->(GetArea())

Local cUserCod  := RetCodUsr()   
Local _cCodigo  := ""
                       
Local _cCOMCOD	:= ""
Local _cCNOME	:= ""
Local _cCEMAIL	:= "" 
Local _cCTEL	:= ""           

Local _ccNOMEF	 := ""
Local _ccCEMAILF := ""
Local _ccENDF	 := ""
Local _ccTELF	 := "" 
  
Local _nCont  := 1

Local _cFORNECE := ""
Local _cLOJA    := ""  

Local _lOBSFOR   := .t.
    
//atualiza quando nao for rotina automatica do configurador
/*
If len(PswRet()) # 0
	cUserCod  := PswRet()[1][1]
	cUsermail := PswRet()[1][14]
EndIF
*/

  
//
// AOliveira / 07-08-2018
// Inclusão de validação para confirmar o envio da cotação
//
IF ( Aviso("Atenção","Confirma o envio da cotação WEB ao Fornecedor?",{"Não","Sim"},1) == 2 )  
              
	_cCodigo := XGETNUM()
	
	dbSelectArea("SC8")
	SC8->(dbSetOrder(1))  //C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_ITEMGRD
	SC8->(dbSeek(xFilial("SC8")+ParamIXB[1]))
	While !SC8->(eof()) .and. (xFilial("SC8") + ParamIXB[1] == SC8->C8_FILIAL+SC8->C8_NUM )
		                                         
			                   
		                   
		If _lOBSFOR 
			IF (Aviso("Observação","Deseja incluir alguma observação ao Fornecedor?",{"Não","Sim"},1) == 2)
				COBSFOR()    //Inclui a Observação ao Fornecedor.
				_lOBSFOR   := .F.                                                                               
			Else                                                                                                
				_lOBSFOR   := .F.                                                                               		
			EndIf
		EndIf                                
			 
		If (_cFORNECE <> SC8->C8_FORNECE) .And. (_cLOJA <> SC8->C8_LOJA)
			_cFORNECE := SC8->C8_FORNECE 
			_cLOJA    := SC8->C8_LOJA  
			_cCodigo  := XGETNUM()
		EndIf
	
		If (_nCont == 1)
		//	_cCodigo := XGETNUM()  
		//	_nCont ++
		EndIf
		                                 
		DbSelectArea("SA2")
		SA2->(DbSetOrder(1)) //A2_FILIAL+A2_COD+A2_LOJA
		SA2->(DbGoTop())  
		If SA2->(DbSeek( xFilial("SA2")+SC8->(C8_FORNECE+C8_LOJA) ))
			_ccNOMEF   := SA2->A2_NOME
			_ccCEMAILF := SA2->A2_CEMAIL
			_ccENDF	   := SA2->A2_END
			_ccTELF	   := SA2->A2_TEL
		EndIf
		
		DbSelectArea("SY1")
		SY1->(DbSetOrder(3)) //Y1_FILIAL+Y1_USER
		SY1->(DbGoTop())  
		If SY1->( DbSeek( xFilial("SY1")+cUserCod ) )
			_cCOMCOD := SY1->Y1_COD //""
			_cCNOME	 := SY1->Y1_NOME
			_cCEMAIL := SY1->Y1_EMAIL
			_cCTEL	 := SY1->Y1_TEL 	
		EndIf
	
		//
		DbSelectArea("ZZ3")
		RecLock("ZZ3",.T.)
		ZZ3->ZZ3_FILIAL	:= xFilial("ZZ3")
		ZZ3->ZZ3_CHVWEB	:= _cCodigo
		ZZ3->ZZ3_EMP	:= FWCodEmp()
		ZZ3->ZZ3_RECNO	:= Alltrim( Str( SC8->(Recno()) ) )
		ZZ3->ZZ3_SITWEB	:= ""
	  
		ZZ3->ZZ3_COMCOD	:= _cCOMCOD
		ZZ3->ZZ3_CNOME	:= _cCNOME
		ZZ3->ZZ3_CEMAIL	:= _cCEMAIL
		ZZ3->ZZ3_CTEL	:= _cCTEL
	  
		ZZ3->ZZ3_CCOTA	:= SC8->C8_NUM
		ZZ3->ZZ3_CVECTO	:= SC8->C8_VALIDA  //SC8->C8_PRAZO
		ZZ3->ZZ3_CPROPO	:= SC8->C8_NUMPRO
		ZZ3->ZZ3_FCOD	:= SC8->C8_FORNECE
		ZZ3->ZZ3_FLOJA	:= SC8->C8_LOJA
		ZZ3->ZZ3_FNOME	:= _ccNOMEF
		ZZ3->ZZ3_FCONT	:= SC8->C8_CONTATO
		ZZ3->ZZ3_FEMAIL	:= _ccCEMAILF
		ZZ3->ZZ3_FEND	:= _ccENDF
		ZZ3->ZZ3_FTEL	:= _ccTELF
		ZZ3->ZZ3_ITEM	:= SC8->C8_ITEM
		ZZ3->ZZ3_PRD	:= SC8->C8_PRODUTO
		ZZ3->ZZ3_PRDDES	:= ALLTRIM(Posicione("SB1",1,xFilial("SB1")+SC8->C8_PRODUTO,"B1_DESC")) //SC8->C8_DESCRI
		ZZ3->ZZ3_PRDQDE	:= SC8->C8_QUANT
		ZZ3->ZZ3_PRDUN	:= SC8->C8_UM
		ZZ3->ZZ3_OBSFOR := SC8->C8_XOBSFOR  //Observacao ao fornecedor
					
		//ZZ3->ZZ3_PRDPRC  :=
		//ZZ3->ZZ3_PRDTOT  :=
		//ZZ3->ZZ3_IPI	   :=
		//ZZ3->ZZ3_VLRIPI  :=
		//ZZ3->ZZ3_ICMS	   :=
		//ZZ3->ZZ3_VLRICM  :=
		
		ZZ3->ZZ3_DTENT1	:= SC8->C8_DATPRF
		
		//ZZ3->ZZ3_DTENT2	:=
		//ZZ3->ZZ3_SUBTOT	:=
		//ZZ3->ZZ3_DESCO	:=
		//ZZ3->ZZ3_TOTIPI	:=
		//ZZ3->ZZ3_TOTICM	:=
		//ZZ3->ZZ3_TPFRET	:=
		//ZZ3->ZZ3_VLRFRE	:=
		//ZZ3->ZZ3_TOTPED	:=
		
		//ZZ3->ZZ3_LOCENT	:=
		//ZZ3->ZZ3_ENDENT	:=
		//ZZ3->ZZ3_CONTEN	:=
		
		//ZZ3->ZZ3_MOEDA	:=
		//ZZ3->ZZ3_CONDPG	:=
		//ZZ3->ZZ3_OBSYN	:=
		//ZZ3->ZZ3_OBS	    :=
		ZZ3->(MsUnlock())  
		
		SC8->(DbSkip())
		
	EndDo             
EndIf
RestArea(_aArea)
RestArea(_aAreaSC8)
RestArea(_aAreaSY1)
RestArea(_aAreaSA2)

Return()

/*---------------------------------------------------------
Funcao: COBSFOR()  |Autor: AOliveira    |Data: 18/04/2018
-----------------------------------------------------------
Descr.: Rotina tem como objetivo informar a observação ao 
        fornecedor.
-----------------------------------------------------------
Uso:    MT130WF
---------------------------------------------------------*/
Static Function COBSFOR()
                               
Local aAreaSC8 := SC8->(getArea())                                              
Local cMGet := ""                               
Local _nOpc := 0

Private oDlg    := Nil
Private oGrpObs := Nil
Private oMGet   := Nil
Private oBtnOK  := Nil
Private oBtnCan := Nil

oDlg       := MSDialog():New( 092,232,310,711,"Observ ao Fornecedor",,,.F.,,,,,,.T.,,,.T. )
oGrpObs    := TGroup():New( 000,004,080,227,"  Observacao ao Fornecedor  ",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
oMGet      := TMultiGet():New( 010,010,{|u| If(PCount()>0,cMGet:=u,cMGet)},oGrpObs,211,065,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oBtnOK     := TButton():New( 085,146,"Confirmar",oDlg,{|| oDlg:End(), _nOpc := 1/*bAction*/},037,012,,,,.T.,,"",,{||/*bWhen*/},{|| /*bValid*/},.F. )
oBtnCan    := TButton():New( 085,190,"Cancelar" ,oDlg,{|| oDlg:End() /*bAction*/},037,012,,,,.T.,,"",,{||/*bWhen*/},{|| /*bValid*/},.F. )

oDlg:Activate(,,,.T.)

If _nOpc == 1                  

	DbSelectArea("SC8") 
	SC8->(dbSetOrder(1))  //C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_ITEMGRD
	SC8->(dbSeek(xFilial("SC8")+ParamIXB[1]))
	While !SC8->(eof()) .and. (xFilial("SC8") + ParamIXB[1] == SC8->C8_FILIAL+SC8->C8_NUM )

		DbSelectArea("SC8")
		RecLock("SC8",.F.) 
		SC8->C8_XOBSFOR := Alltrim(Upper(cMGet))
		SC8->(MsUnlock())  
		
		SC8->(DbSkip())
	EndDo		

EndIf
      
RestArea(aAreaSC8)

Return()   

/*---------------------------------------------------------
Funcao: XGETNUM()  |Autor: AOliveira    |Data: 18/04/2018
-----------------------------------------------------------
Descr.: Rotina tem como objetivo retornar numeração unica
para controle do campo ( ZZ3_CHVWEB )
-----------------------------------------------------------
Uso:    MT130WF
---------------------------------------------------------*/
Static Function XGETNUM()
Local cRet := ""

Local cLetras  := "ABCDEFGHIJKLMNOPQRSTUWVYXZ"
Local cSeq     := "LNLNLNLNLNLNLNLNLNLNLLNLNL"
Local nSorteio := 0
Local lSeek    := .T.
Local _cCodigo :=  ""
Local _nTamanho := TamSX3("ZZ3_CHVWEB")[1]
Local x

While lSeek //.and. (!Empty(_cCodigo))
	
	_cCodigo :=  ""
	
	For x:=1 To _nTamanho
		nSorteio := Randomize( 1, Len(cSeq)+1 )
		If ( Alltrim(SubStr(cSeq,nSorteio,1)) ) ==  'L'
			nSorteio := Randomize( 1, Len(cLetras)+1 )
			_cCodigo +=  Alltrim(SubStr(cLetras,nSorteio,1))
		Else
			nSorteio := Randomize( 1, 10 )
			_cCodigo +=  Alltrim(Str(nSorteio))
		EndIf
	Next x
	
	_cCodigo := Alltrim(_cCodigo)
	
	DbSelectArea("ZZ3")
	//ZZ3->(DbSetOrder(1)) //ZZ3_FILIAL+ZZ3_CHVWEB
	ZZ3->(DbSetOrder(1)) //ZZ3_FILIAL+ZZ3_CHVWEB+ZZ3_FCOD+ZZ3_FLOJA+ZZ3_ITEM+ZZ3_PRD
	ZZ3->(DbGoTop())
	If !ZZ3->(DbSeek(xFilial("ZZ3")+_cCodigo))
		lSeek:= .f.
	EndIf
	
EndDo

cRet := _cCodigo

Return(cRet)