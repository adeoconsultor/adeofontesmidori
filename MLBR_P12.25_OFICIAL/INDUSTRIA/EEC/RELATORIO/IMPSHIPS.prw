#INCLUDE "EECRDM.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH" 

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: IMPSHIPS
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Data......: 01 de Março de 2010, 07:00
//|Uso.......: SIGAEEC
//|Versao....: Protheus - 10        `
//|Descricao.: Impressão de Shipping Schedule
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function IMPSHIPS(xFoc)
*-----------------------------------------*  

Local cTipoCad  := "Dados de Cabeçalho"
Local cCadastr  := "Shipping Schedule"
Local oDlg      := Nil
Local oGrpSCH   := Nil
Local lRet      := .F.
Local nLin1     := 5
Local nLin2     := 64
Local nCol1     := 5
Local nCol2     := 133

Private cCustumer := Space(35)
Private cTo       := Space(20)
Private cFrom     := Space(20)
Private cFaxNum   := 0
Private cSEQREL   := ""

If Empty(xFoc)
	MsgInfo("Não há Shipping Schedule para Impressão")
	Return(lRet)
EndIf

DEFINE MSDIALOG oDlg TITLE cCadastr FROM 0,0 TO 130,340 OF oDlg PIXEL

oGrpSCH := TGroup():New( nLin1,nCol1,nLin2,nCol2,cTipoCad,oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )

@ nLin1+=9 ,nCol1+=5 SAY "Customer:"  SIZE 35,7 PIXEL OF oDlg
@ nLin1    ,nCol1+35 MSGET cCustumer  PICTURE "@!" SIZE 80,8 PIXEL OF oDlg
@ nLin1+=12,nCol1    SAY "To:"  SIZE 35,7 PIXEL OF oDlg
@ nLin1    ,nCol1+35 MSGET cTo  PICTURE "@!" SIZE 55,8 PIXEL OF oDlg
@ nLin1+=12,nCol1    SAY "From:"  SIZE 35,7 PIXEL OF oDlg
@ nLin1    ,nCol1+35 MSGET cFrom  PICTURE "@!" SIZE 55,8 PIXEL OF oDlg
@ nLin1+=12,nCol1    SAY "Fax No.:"  SIZE 35,7 PIXEL OF oDlg
@ nLin1    ,nCol1+35 MSGET cFaxNum   PICTURE "@!" SIZE 10,8 PIXEL OF oDlg

DEFINE SBUTTON FROM 08,137 TYPE 19 OF oDlg ACTION (lRet:=.T.,oDlg:End()) ENABLE
DEFINE SBUTTON FROM 26,137 TYPE 2  OF oDlg ACTION (lRet:=.F.,oDlg:End()) ENABLE

ACTIVATE MSDIALOG oDlg CENTER

If lRet
	Processa({ || Imprime(aVetSCH[xFoc]) })
	AvgCrw32("ShipSched.RPT",AllTrim(cCadastr),cSEQREL)
EndIf
         
Return(lRet)

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Descricao.: Chama Impressão
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function Imprime(xShipp)
*-----------------------------------------*

Local cSql := ""

cSql := " SELECT ZE.ZZE_SCHEDU,ZE.ZZE_INVOIC,ZE.ZZE_DTINV,ZE.ZZE_VIA, "
cSql += " 	ZE.ZZE_CONTAI,ZE.ZZE_PACK,ZE.ZZE_CUBAGE,ZE.ZZE_PORTO,ZE.ZZE_FACMES,ZE.ZZE_FACDT, "
cSql += " 	ZE.ZZE_ETDMES,ZE.ZZE_ETD,ZE.ZZE_ETAMES,ZE.ZZE_ETA,ZE.ZZE_VESSEL,ZE.ZZE_DTSCHE, "
cSql += " 	ZE.ZZE_SCDTRE,ZE.ZZE_NRRSCH, "
cSql += " 	ZF.ZZF_PEDIDO,ZF.ZZF_SEQUEN,ZF.ZZF_COD_I,ZF.ZZF_QUANT,ZF.ZZF_NRPLAN,ZF.ZZF_DTREAD,ZF.ZZF_ETDREQ "
cSql += " FROM "+RetSqlName("ZZE")+" ZE, "+RetSqlName("ZZF")+" ZF "
cSql += " WHERE ZE.D_E_L_E_T_ <> '*' AND ZF.D_E_L_E_T_ <> '*' "
cSql += " 	AND ZE.ZZE_FILIAL = '"+xFilial("ZZE")+"' AND ZF.ZZF_FILIAL = '"+xFilial("ZZF")+"' "
cSql += " 	AND ZE.ZZE_SCHEDU = '"+Alltrim(xShipp)+"' "
cSql += " 	AND ZE.ZZE_INVOIC = ZF.ZZF_INVOIC "
cSql += " GROUP BY ZE.ZZE_SCHEDU,ZE.ZZE_INVOIC,ZE.ZZE_DTINV,ZE.ZZE_VIA, "
cSql += " 	ZE.ZZE_CONTAI,ZE.ZZE_PACK,ZE.ZZE_CUBAGE,ZE.ZZE_PORTO,ZE.ZZE_FACMES,ZE.ZZE_FACDT, "
cSql += " 	ZE.ZZE_ETDMES,ZE.ZZE_ETD,ZE.ZZE_ETAMES,ZE.ZZE_ETA,ZE.ZZE_VESSEL,ZE.ZZE_DTSCHE, "
cSql += " 	ZE.ZZE_SCDTRE,ZE.ZZE_NRRSCH, "
cSql += " 	ZF.ZZF_PEDIDO,ZF.ZZF_SEQUEN,ZF.ZZF_COD_I,ZF.ZZF_QUANT,ZF.ZZF_NRPLAN,ZF.ZZF_DTREAD,ZF.ZZF_ETDREQ "
cSql += " ORDER BY ZE.ZZE_INVOIC "

Iif(Select("TMIMP") # 0, TMIMP->(dbCloseArea()), .T.)
TcQuery cSql New Alias "TMIMP"
dbSelectArea("TMIMP")
TMIMP->(dbGoTop()) 

If TMIMP->(EOF()) .AND. TMIMP->(BOF())
	MsgInfo("Não há invoices para impressão")
	TMIMP->(dbCloseArea())
	Return
EndIf

EE7->(dbSetOrder(1))
SA2->(dbSetOrder(1))

E_ARQCRW(.T.,.F.,.F.)

cSEQREL:=GETSXENUM("SY0","Y0_SEQREL")    
ConfirmSX8()

HEADER_P->(dbAppend())
HEADER_P->AVG_FILIAL := xFilial("ZZE")
HEADER_P->AVG_SEQREL := cSEQREL
HEADER_P->AVG_CHAVE  := Alltrim(TMIMP->ZZE_SCHEDU)

EE7->(dbSeek(xFilial("EE7")+TMIMP->ZZF_PEDIDO))
SA2->(dbSeek(xFilial("SA2")+EE7->EE7_FORN+EE7->EE7_FOLOJA))

HEADER_P->AVG_C01_60 := Alltrim(SA2->A2_NOME)
HEADER_P->AVG_C02_60 := Alltrim(SA2->A2_END)
HEADER_P->AVG_C03_60 := Alltrim(SA2->A2_EST+" "+AllTrim(BuscaPais(SA2->A2_PAIS))+" CEP: "+Transf(SA2->A2_CEP,AVSX3("A2_CEP",6)))
HEADER_P->AVG_C04_60 := Alltrim("TEL.: "+AllTrim(SA2->A2_TEL)+" FAX: "+AllTrim(SA2->A2_FAX))
HEADER_P->AVG_C07_60 := Alltrim(cCustumer)
HEADER_P->AVG_C08_60 := Alltrim(cTo)
HEADER_P->AVG_C09_60 := Alltrim(cFrom)
HEADER_P->AVG_C10_60 := Alltrim(DtoC(StoD(TMIMP->ZZE_DTSCHE)))
HEADER_P->AVG_C11_60 := Alltrim(Transform(cFaxNum,"@E 99"))
HEADER_P->AVG_C12_60 := Alltrim(Transform(TMIMP->ZZE_NRRSCH,"@E 99"))
HEADER_P->AVG_C19_20 := Transform(SA2->A2_CGC,AVSX3("A2_CGC",AV_PICTURE))

HEADER_P->(MsUnLock())

GravaItens(TMIMP->ZZE_SCHEDU)
Historico()

TMIMP->(dbCloseArea())

Return

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: GravaItens
//|Descricao.: Grava Itens
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function GravaItens(xShipp)
*-----------------------------------------*

Local cInv   := ""
Local aOutCp := {}

TMIMP->(dbGoTop()) 
While TMIMP->(!EOF())

	If Empty(cInv)
		//Fatura
		AppendDet(xShipp)
		cInv := TMIMP->ZZE_INVOIC
		DETAIL_P->AVG_C01_20 := Alltrim(TMIMP->ZZE_INVOIC)
		DETAIL_P->AVG_C01_60 := ""
		UnlockDet()
		aOutCp := {Alltrim(TMIMP->ZZE_VIA),Alltrim(TMIMP->ZZE_CONTAI),Alltrim(TMIMP->ZZE_PACK),Alltrim(TMIMP->ZZE_CUBAGE),;
				   Alltrim(TMIMP->ZZE_PORTO),Alltrim(TMIMP->ZZE_FACMES),DtoC(StoD(TMIMP->ZZE_FACDT)),;
				   Alltrim(TMIMP->ZZE_ETDMES),DtoC(StoD(TMIMP->ZZE_ETD)),Alltrim(TMIMP->ZZE_ETAMES),;
				   DtoC(StoD(TMIMP->ZZE_ETA)),Alltrim(TMIMP->ZZE_VESSEL)}		

	ElseIf cInv <> TMIMP->ZZE_INVOIC
		//Dados de Embarque
		AppendDet(xShipp)
		DETAIL_P->AVG_C01_60 := "Z"
		DETAIL_P->AVG_C03_10 := Alltrim(aOutCp[1]) //Via
		DETAIL_P->AVG_C04_20 := Alltrim(aOutCp[2]) //Container
		DETAIL_P->AVG_C05_20 := Alltrim(aOutCp[3]) //Packages
		DETAIL_P->AVG_C04_10 := Alltrim(aOutCp[4]) //Cubage
		DETAIL_P->AVG_C06_20 := Alltrim(aOutCp[5]) //Porto
		DETAIL_P->AVG_C07_20 := Alltrim(aOutCp[6]) //Ex-Factory MES
		DETAIL_P->AVG_C08_20 := Alltrim(aOutCp[7]) //Ex-Factory Data
		DETAIL_P->AVG_C09_20 := Alltrim(aOutCp[8]) //ETD Mes		
		DETAIL_P->AVG_C10_20 := Alltrim(aOutCp[9]) //ETD Data
		DETAIL_P->AVG_C02_60 := Alltrim(aOutCp[10])//ETA Mes
		DETAIL_P->AVG_C03_60 := Alltrim(aOutCp[11])//ETA Data
		DETAIL_P->AVG_C04_60 := Alltrim(aOutCp[12])//Vessel
		UnlockDet()
		
		//Fatura
		AppendDet(xShipp)
		cInv := TMIMP->ZZE_INVOIC
		DETAIL_P->AVG_C01_20 := Alltrim(TMIMP->ZZE_INVOIC)
		UnlockDet()
		aOutCp := {Alltrim(TMIMP->ZZE_VIA),Alltrim(TMIMP->ZZE_CONTAI),Alltrim(TMIMP->ZZE_PACK),Alltrim(TMIMP->ZZE_CUBAGE),;
				   Alltrim(TMIMP->ZZE_PORTO),Alltrim(TMIMP->ZZE_FACMES),DtoC(StoD(TMIMP->ZZE_FACDT)),;
				   Alltrim(TMIMP->ZZE_ETDMES),DtoC(StoD(TMIMP->ZZE_ETD)),Alltrim(TMIMP->ZZE_ETAMES),;
				   DtoC(StoD(TMIMP->ZZE_ETA)),Alltrim(TMIMP->ZZE_VESSEL)}		
	EndIf           
	
	//Itens
	AppendDet(xShipp)	
	DETAIL_P->AVG_C01_60 := ""
	DETAIL_P->AVG_C05_60 := Alltrim(TMIMP->ZZF_PEDIDO)
	cDesc := Posicione("EE8",1,xFilial("EE8")+TMIMP->ZZF_PEDIDO+TMIMP->ZZF_SEQUEN,"EE8_DESC")
	cDesc := Alltrim(MsMM(cDesc))
	DETAIL_P->AVG_C01100 := cDesc
	DETAIL_P->AVG_C02_20 := Alltrim(Transform(TMIMP->ZZF_QUANT,"@E 99,999.99"))+" M2"
	DETAIL_P->AVG_C03_20 := Alltrim(TMIMP->ZZF_NRPLAN)
	DETAIL_P->AVG_C01_10 := DtoC(StoD(TMIMP->ZZF_DTREAD))
	DETAIL_P->AVG_C02_10 := Alltrim(Str(TMIMP->ZZF_ETDREQ))
	UnlockDet()
	
	TMIMP->(dbSkip())
EndDo

AppendDet(xShipp)
DETAIL_P->AVG_C01_60 := "Z"
DETAIL_P->AVG_C03_10 := Alltrim(aOutCp[1]) //Via
DETAIL_P->AVG_C04_20 := Alltrim(aOutCp[2]) //Container
DETAIL_P->AVG_C05_20 := Alltrim(aOutCp[3]) //Packages
DETAIL_P->AVG_C04_10 := Alltrim(aOutCp[4]) //Cubage
DETAIL_P->AVG_C06_20 := Alltrim(aOutCp[5]) //Porto
DETAIL_P->AVG_C07_20 := Alltrim(aOutCp[6]) //Ex-Factory MES
DETAIL_P->AVG_C08_20 := Alltrim(aOutCp[7]) //Ex-Factory Data
DETAIL_P->AVG_C09_20 := Alltrim(aOutCp[8]) //ETD Mes		
DETAIL_P->AVG_C10_20 := Alltrim(aOutCp[9]) //ETD Data
DETAIL_P->AVG_C02_60 := Alltrim(aOutCp[10])//ETA Mes
DETAIL_P->AVG_C03_60 := Alltrim(aOutCp[11])//ETA Data
DETAIL_P->AVG_C04_60 := Alltrim(aOutCp[12])//Vessel
UnlockDet()

Return

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: AppendDet
//|Descricao.: Adiciona registros no arquivo de detalhes
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function AppendDet(xShipp)
*-----------------------------------------*

DETAIL_P->(dbAppend())
DETAIL_P->AVG_FILIAL := xFilial("ZZE")
DETAIL_P->AVG_SEQREL := cSEQREL
DETAIL_P->AVG_CHAVE  := xShipp

Return

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: UnlockDet
//|Descricao.: Desaloca registros no arquivo de detalhes
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function UnlockDet()
*-----------------------------------------*

DETAIL_P->(dbUnlock())

Return                                           

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: Historico
//|Descricao.: Grava Historico
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function Historico()
*-----------------------------------------*

HEADER_H->(dbAppend())
AvReplace("HEADER_P","HEADER_H")
HEADER_H->(MsUnLock())

DETAIL_P->(dbSetOrder(0))
DETAIL_P->(DbGoTop())
While DETAIL_P->(!EOF())
	DETAIL_H->(DbAppend())
	AvReplace("DETAIL_P","DETAIL_H")
	DETAIL_H->(MsUnLock())
	DETAIL_P->(DbSkip())
EndDo
	
DETAIL_P->(dbSetOrder(1))

Return