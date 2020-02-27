#include "totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "RwMake.ch"
/*
* Funcao: XDWEB
* Autor:  AOliveira
* Data:   10-07-2018
* Descr.:
*/
User Function XDWEB()

Local cRet    := "" 
Local _nQtde  := 0
Local _nRecno := 0 //aCols[n][Len(aCols[n])-1]
Local cQry    := ""

Local _aArea := GetArea()

Local _stru:={}
Local aCpoBro := {}
Local oDlg
Local aCores := {}
Local carq := ""
    
Local oBrw
Local oBtnOK
Local oGrpGer
Local oGrpObs
Local oMGetObsF
Local cMGetObsF := ""

Private lInverte := .F.
Private cMark   := GetMark()   
Private oMark
         
_nRecno := Iif( TYPE("aCols") <> "U" ,aCols[n][Len(aCols[n])-1],SC8->(Recno()) )

cQry := " SELECT * FROM "+RetSQLName("ZZ3")+" WHERE ZZ3_RECNO = '"+ Alltrim(Str(_nRecno)) +"'  AND D_E_L_E_T_ = '' "
TCQUERY cQry ALIAS "TB1" NEW
	
DbSelectArea("TB1")
TB1->(DbGoTop())        
TB1->( dBEval({|| _nQtde++}) )  
TB1->(DbGoTop())	
	
If _nQtde > 0

	AADD(_stru,{"OK"      ,"C" ,2	,0	})
	AADD(_stru,{"PRDPRC"  ,"N" ,TamSx3("ZZ3_PRDPRC" )[1] ,TamSx3("ZZ3_PRDPRC" )[2] 	}) //ZZ3->ZZ3_PRDPRC	 := _nPRDPRC     //C8_PRECO
	AADD(_stru,{"PRDTOT"  ,"N" ,TamSx3("ZZ3_PRDTOT" )[1] ,TamSx3("ZZ3_PRDTOT" )[2]	}) //ZZ3->ZZ3_PRDTOT	 := _nPRDTOT     //C8_TOTAL
	AADD(_stru,{"IPI"     ,"N" ,TamSx3("ZZ3_IPI" )[1]	 ,TamSx3("ZZ3_IPI" )[2]		}) //ZZ3->ZZ3_IPI	 := _nIPI        //C8_ALIPI
	AADD(_stru,{"VLRIPI"  ,"N" ,TamSx3("ZZ3_VLRIPI" )[1] ,TamSx3("ZZ3_VLRIPI" )[2]	}) //ZZ3->ZZ3_VLRIPI  := Round(((_nPRDTOT / 100)*_nIPI),2)
	AADD(_stru,{"ICMS"    ,"N" ,TamSx3("ZZ3_ICMS" )[1]	 ,TamSx3("ZZ3_ICMS" )[2]	}) //ZZ3->ZZ3_ICMS    := _nICMS       //C8_PICM
	AADD(_stru,{"VLRICM"  ,"N" ,TamSx3("ZZ3_VLRICM" )[1] ,TamSx3("ZZ3_VLRICM" )[2]	}) //ZZ3->ZZ3_VLRICM	 := Round(((_nPRDTOT / 100)*_nICMS),2)
	AADD(_stru,{"DTENT2"  ,"D" ,TamSx3("ZZ3_DTENT2" )[1] ,TamSx3("ZZ3_DTENT2" )[2]	}) //ZZ3->ZZ3_DTENT2  := CtoD(_cDTENT2 )
	AADD(_stru,{"DESCO"   ,"N" ,TamSx3("ZZ3_DESCO" )[1]	 ,TamSx3("ZZ3_DESCO" )[2]	}) //ZZ3->ZZ3_DESCO   := _nDESCO       //                                                                //oJson:DATA[1]:COTACAORECORD[1]:TOTAL_DESCONTO
	AADD(_stru,{"TPFRET"  ,"C" ,TamSx3("ZZ3_TPFRET" )[1] ,TamSx3("ZZ3_TPFRET" )[2]	}) //ZZ3->ZZ3_TPFRET	 := Alltrim(_cFRETP)
	AADD(_stru,{"VLRFRE"  ,"N" ,TamSx3("ZZ3_VLRFRE" )[1] ,TamSx3("ZZ3_VLRFRE" )[2]	}) //ZZ3->ZZ3_VLRFRE	 := Round(Val(StrTran( _cFREVLR ,",",".")),6) //oJson:DATA[1]:COTACAORECORD[1]:TOTAL_FRETEVALOR
	AADD(_stru,{"MOEDA"   ,"C" ,TamSx3("ZZ3_MOEDA" )[1]	 ,TamSx3("ZZ3_MOEDA" )[2]	}) //ZZ3->ZZ3_MOEDA   := Alltrim(_cMOEDA)
	AADD(_stru,{"CONDPG"  ,"C" ,TamSx3("ZZ3_CONDPG" )[1] ,TamSx3("ZZ3_CONDPG" )[2]	}) //ZZ3->ZZ3_CONDPG  := Alltrim(_cCONDPGTO)
	//AADD(_stru,{"OBS"     ,"M" ,TamSx3("ZZ3_OBS" )[1]	 ,TamSx3("ZZ3_OBS" )[2]		}) //ZZ3->ZZ3_OBS	 := Alltrim(_cOBS)

	cArq:=Criatrab(_stru,.T.)
	DBUSEAREA(.t.,,carq,"TTRB")
		
	DbSelectArea("ZZ3")
	ZZ3->(DbSetOrder(1)) //ZZ3_FILIAL+ZZ3_CHVWEB
	ZZ3->(DbGoTop())
	ZZ3->(DbSeek( TB1->ZZ3_FILIAL+TB1->ZZ3_CHVWEB )) //ZZ3_FILIAL+ZZ3_CHVWEB+ZZ3_FCOD+ZZ3_FLOJA+ZZ3_ITEM+ZZ3_PRD
    While !ZZ3->(Eof()) .And.  (ZZ3->ZZ3_FILIAL+ZZ3->ZZ3_CHVWEB == TB1->ZZ3_FILIAL+TB1->ZZ3_CHVWEB)
		
		DbSelectArea("TTRB")	
		RecLock("TTRB",.T.)		
		TTRB->PRDPRC  := ZZ3->ZZ3_PRDPRC
		TTRB->PRDTOT  := ZZ3->ZZ3_PRDTOT
		TTRB->IPI     := ZZ3->ZZ3_IPI
		TTRB->VLRIPI  := ZZ3->ZZ3_VLRIPI
		TTRB->ICMS    := ZZ3->ZZ3_ICMS
		TTRB->VLRICM  := ZZ3->ZZ3_VLRICM
		TTRB->DTENT2  := ZZ3->ZZ3_DTENT2
		TTRB->DESCO   := ZZ3->ZZ3_DESCO
		TTRB->TPFRET  := ZZ3->ZZ3_TPFRET
		TTRB->VLRFRE  := ZZ3->ZZ3_VLRFRE
		TTRB->MOEDA   := ZZ3->ZZ3_MOEDA 
		TTRB->CONDPG  := ZZ3->ZZ3_CONDPG
		//TTRB->OBS     := ZZ3->ZZ3_OBS
		TTRB->(MsunLock())
		
	    cMGetObsF :=  ZZ3->ZZ3_OBS
		
		ZZ3->(DbSkip())
	
	EndDo

	//Define as cores dos itens de legenda.
	aCores := {}
	
	//Define quais colunas (campos da TTRB) serao exibidas na MsSelect
	aCpoBro	:= {{"OK"	   ,, "Mark"        ,"@!"},;
				{"PRDPRC"  ,, "Prc Produto" ,X3Picture( "ZZ3_PRDPRC" )},;
				{"PRDTOT"  ,, "Total Prod"  ,X3Picture( "ZZ3_PRDTOT" )},;
				{"IPI"     ,, "Aliq IPI"    ,X3Picture( "ZZ3_IPI" )},;
				{"VLRIPI"  ,, "Vlr IPI"     ,X3Picture( "ZZ3_VLRIPI" )},;
				{"ICMS"    ,, "Aliq ICMS"   ,X3Picture( "ZZ3_ICMS" )},;
				{"VLRICM"  ,, "Vlr ICMS"    ,X3Picture( "ZZ3_VLRICM" )},;
				{"DTENT2"  ,, "DT Ent 02"   ,X3Picture( "ZZ3_DTENT2" )},;
				{"DESCO"   ,, "Desconto"    ,X3Picture( "ZZ3_DESCO" )},;
				{"TPFRET"  ,, "Tipo Frete"  ,X3Picture( "ZZ3_TPFRET" )},;
				{"VLRFRE"  ,, "Vlr Frete"   ,X3Picture( "ZZ3_VLRFRE" )},;
				{"MOEDA"   ,, "Moeda"       ,X3Picture( "ZZ3_MOEDA" )},;
				{"CONDPG"  ,, "Cond Pgto"   ,X3Picture( "ZZ3_CONDPG" )}}
				//,;
				//{"OBS"     ,, "Observacao"  ,X3Picture( "ZZ3_OBS" )}}
				
	//Cria uma Dialog
	/*
	DEFINE MSDIALOG oDlg TITLE "Dadso Web" From 9,0 To 315,800 PIXEL
	DbSelectArea("TTRB")
	DbGotop()
	//Cria a MsSelect
	oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{17,1,150,400},,,,,aCores)
	//oMark:bMark := {| | Disp()} 
	
	//Exibe a Dialog
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| oDlg:End()},{|| oDlg:End()})
    */              
    
	//oDlg       := MSDialog():New( 092,232,271,901,"Dados Web",,,.F.,,,,,,.T.,,,.T. )
	//oBrw       := MsSelect():New( "ZZ3","","",{{"ZZ3_FILIAL","","Filial","@!"},{"ZZ3_CCOTA","","Num Cotacao","@!"}},.F.,,{001,005,061,323},,, oDlg ) 
	//oBrw       := MsSelect():New( "TTRB","","",aCpoBro,.F.,,{001,005,061,323},,, oDlg ) 
	//oBtnOK     := TButton():New( 064,272,"Confirmar",oDlg,{|| oDlg:End() /*bAction*/},051,012,,,,.T.,,"",,{|| /*bWhen*/},{|| /**bValid*/},.F. )
 	
	//cMGetObsF :=  TTRB->OBS
	
	oDlg       := MSDialog():New( 092,232,473,901,"Dados Web",,,.F.,,,,,,.T.,,,.T. )
	oGrpGer    := TGroup():New( 000,004,069,324,"  Dados Gerais  ",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oBrw       := MsSelect():New( "TTRB","","",aCpoBro,.F.,,{008,007,065,319},,, oGrpGer ) 
	oGrpObs    := TGroup():New( 075,004,161,324,"  Obs Fornecedor  ",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oMGetObsF  := TMultiGet():New( 084,008,{|u| If(PCount()>0,cMGetObsF:=u,cMGetObsF)},oGrpObs,312,072,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,  )
	
	oBtnOK     := TButton():New( 165,271,"Fechar",oDlg,{||  oDlg:End() /*bAction*/},051,012,,,,.T.,,"",,{|| /*bWhen*/},{|| /**bValid*/},.F. )
 	
	oDlg:Activate(,,,.T.)



	
	//Fecha a Area e elimina os arquivos de apoio criados em disco.
	TTRB->(DbCloseArea())
	Iif(File(cArq + GetDBExtension()),FErase(cArq  + GetDBExtension()) ,Nil)	
Else
	Aviso("Atencao","Registro da cotação não tem vinculo com a WEB...",{"OK"})	
EndIf
TB1->(DbCloseArea())   
RestArea(_aArea)
Return(cRet) 