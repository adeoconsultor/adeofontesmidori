#include "protheus.ch"
#include "topconn.ch"

User Function RELCCAN
Local oReport

If TRepInUse()
	Pergunte("PCTBCCSEM",.F.)
	
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf
Return

Static Function ReportDef()
Local oReport
Local oSection1 // Filial
Local oSection2 // Centro de Custo
Local oSection3 // Conta Contábil

oReport := TReport():New("CCXCCSEM","Relatorio Comparativo Centro de Custo x Conta Contábil","PCTBCCSEM",{|oReport| PrintReport(oReport)},"Relatorio Comparativo entre Centro de Custos e Conta Contábil")

oSection1 := TRSection():New(oReport,"Filial",{})
oSection2 := TRSection():New(oReport,"Centro_Custo",{})
oSection3 := TRSection():New(oReport,"Conta_Contabil",{})


TRCell():New(oSection1,"SM0_CODFIL","SM0","FILIAL",,,, {|| _cFilial+" "+POSICIONE("SM0",1,+"01"+_cFilial,"M0_FILIAL") })

TRCell():New(oSection2,"CTT_CUSTO","CTT","Centro de Custo",,,, {||TEMP2->C_CUSTO})
TRCell():New(oSection2,"CTT_DESC01","CTT","Descrição Centro de Custo",,,,{||Posicione('CTT', 1, xFilial('CTT')+TEMP2->C_CUSTO,'CTT_DESC01')})

TRCell():New(oSection3," "," ","Conta Contábil",,,,{||TEMP2->CONTA})
TRCell():New(oSection3," "," ","Descrição da Conta",,,,{||Posicione('CT1',1,xFilial('CT1')+TEMP2->CONTA,'CT1_DESC01')})

Return oReport

Static Function PrintReport(oReport)
Local cQueryDeb := ""
Local cQueryCred:= "" 
Local cQryDeb2 := ""
Local cQryCred2:= ""
Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local oSection3 := oReport:Section(3)
Local nX        := 0

Private _cFilial     :=""
Private cCentroCusto :=""

Private cMes1    :=""
Private cMes2    :=""
Private cMes3    :=""
Private cMes4    :=""
Private cMes5    :=""
Private cMes6    :=""

Private nMes1    :=0
Private nMes2    :=0
Private nMes3    :=0
Private nMes4    :=0
Private nMes5    :=0
Private nMes6    :=0

Private nResul1:=0
Private nResul2:=0
Private nResul3:=0
Private nResul4:=0
Private nResul5:=0
Private nResul6:=0
Private nTotal :=0

Private aStruc:={}

Private cTemp1:=""
Private cTemp2:=""
Private cInd1 :=""
Private cInd2 :=""


#IFDEF TOP
	
	cQueryDeb:= "SELECT CT2_ITEMD ITEM_DEBITO,CT2_CCD CUSTO_DEBITO, CT2_DEBITO CONTA_DEBITO, SUBSTRING (CT2_DATA,1,6)DATA_DEBITO,  "
	cQueryDeb+= "SUM(CT2_VALOR) AS VALOR_DEBITO "
	cQueryDeb+= "FROM CT2010  WHERE D_E_L_E_T_ <> '*' "
	cQueryDeb+= "AND  CT2_DATA   BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
	cQueryDeb+= "AND  CT2_ITEMD  BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
	cQueryDeb+= "AND  CT2_CCD    BETWEEN '"+MV_PAR03+" ' AND  '"+MV_PAR04+"'"
	cQueryDeb+= "AND  CT2_DEBITO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
	cQueryDeb+= "GROUP BY CT2_ITEMD,CT2_CCD,CT2_DEBITO,SUBSTRING (CT2_DATA,1,6)"
	cQueryDeb+= "ORDER BY CT2_ITEMD,CT2_CCD,CT2_DEBITO,SUBSTRING (CT2_DATA,1,6)"
	
	TcQuery cQueryDeb New Alias "DEBITOS"
	
#ENDIF

IF  Month(mv_par01)=Month(mv_par02)
	cMes1:= MesExtenso(Month(mv_par01))
	nMes1:= Month(mv_par01)
Else
	cMes1:= MesExtenso(Month(mv_par01))
	nMes1:= Month(mv_par01)
	nX:= Month(mv_par01)
	
	//Coluna do Mês 2
	If nX+1 = Month(mv_par02)
		cMes2:= MesExtenso(Month(mv_par02))
		nMes2:= Month(mv_par02)
	ElseIf nX+1 > Month(mv_par02)
		cMes2:=""
		nMes2:=0
	Else
		cMes2:= MesExtenso(Month(mv_par01)+1)
		nMes2:= Month(mv_par01)+1
	EndIf
	
	//Coluna do Mes 3
	If nX+2 = Month(mv_par02)
		cMes3:= MesExtenso(Month(mv_par02))
		nMes3:= Month(mv_par02)
	ElseIf nX+2 > Month(mv_par02)
		cMes3:=""
		nMes3:=0
	Else
		cMes3:= MesExtenso(Month(mv_par01)+2)
		nMes3:= Month(mv_par01)+2
	EndIf
	
	//Coluna do Mes 4
	If nX+3 = Month(mv_par02)
		cMes4:= MesExtenso(Month(mv_par02))
		nMes4:= Month(mv_par02)
	ElseIf nX+3 > Month(mv_par02)
		cMes4:=""
		nMes4:=0
	Else
		cMes4:= MesExtenso(Month(mv_par01)+3)
		nMes4:= Month(mv_par01)+3
	EndIf
	
	//Coluna do Mes 5
	If nX+4 = Month(mv_par02)
		cMes5:= MesExtenso(Month(mv_par02))
		nMes5:= Month(mv_par02)
	ElseIf nX+4 > Month(mv_par02)
		cMes5:=""
		nMes5:=0
	Else
		cMes5:= MesExtenso(Month(mv_par01)+4)
		nMes5:= Month(mv_par01)+4
	EndIf
	
	//Coluna do Mes 6
	If nX+5 = Month(mv_par02)
		cMes6:= MesExtenso(Month(mv_par02))
		nMes6:= Month(mv_par02)
	ElseIf nX+5 > Month(mv_par02)
		cMes6:=""
		nMes6:=0
	Else
		cMes6:= MesExtenso(Month(mv_par01)+5)
		nMes6:= Month(mv_par01)+5
	EndIf
EndIf

AADD(aStruc,{"FILIAL" ,"C",9,0})
AADD(aStruc,{"C_CUSTO","C",9,0})
AADD(aStruc,{"CONTA"  ,"C",20,0})

If !Empty(cMes1)
	AADD(aStruc,{"MES1","C",6,0})
	AADD(aStruc,{"VLR1","N",15,2})
EndIf

If !Empty(cMes2)
	AADD(aStruc,{"MES2","C",6,0})
	AADD(aStruc,{"VLR2","N",15,2})
EndIf

If !Empty(cMes3)
	AADD(aStruc,{"MES3","C",6,0})
	AADD(aStruc,{"VLR3","N",15,2})
EndIf

If !Empty(cMes4)
	AADD(aStruc,{"MES4","C",6,0})
	AADD(aStruc,{"VLR4","N",15,2})
EndIf

If !Empty(cMes5)
	AADD(aStruc,{"MES5","C",6,0})
	AADD(aStruc,{"VLR5","N",15,2})
EndIF

If !Empty(cMes6)
	AADD(aStruc,{"MES6","C",6,0})
	AADD(aStruc,{"VLR6","N",15,2})
EndIF

AADD(aStruc,{"TOTAL","N",15,2})


cTemp1:= CriaTrab(aStruc,.T.)
dbUseArea(.T.,,cTemp1,"TEMP1",.F.,.F.)

cChave := "FILIAL+C_CUSTO+CONTA"
cInd1  := CriaTrab(NIL,.F.)
IndRegua("TEMP1",cInd1,cChave,,,"Selecionando Registros...")

While DEBITOS->(!EOF())
	
	nResul1:=0
	nResul2:=0
	nResul3:=0
	nResul4:=0
	nResul5:=0
	nResul6:=0
	
	
	cQueryCred:= "SELECT CT2_ITEMC ITEM_CREDITO,CT2_CCC CUSTO_CREDITO,CT2_CREDIT CREDITO,SUBSTRING(CT2_DATA,1,6)DATA_CREDITO, "
	cQueryCred+= "SUM(CT2_VALOR) AS VALOR_CREDITO  "
	cQueryCred+= "FROM CT2010 WHERE D_E_L_E_T_ <> '*' "
	cQueryCred+= "AND  SUBSTRING(CT2_DATA,1,6) BETWEEN '"+DEBITOS->DATA_DEBITO+"' AND '"+DEBITOS->DATA_DEBITO+"' "
	cQueryCred+= "AND  CT2_ITEMC  BETWEEN '"+DEBITOS->ITEM_DEBITO+"' AND '"+DEBITOS->ITEM_DEBITO+"' "
	cQueryCred+= "AND  CT2_CCC    BETWEEN '"+DEBITOS->CUSTO_DEBITO+"' AND  '"+DEBITOS->CUSTO_DEBITO+"' "
	cQueryCred+= "AND  CT2_CREDIT BETWEEN '"+DEBITOS->CONTA_DEBITO+"' AND '"+DEBITOS->CONTA_DEBITO+"' "
	cQueryCred+= "GROUP BY CT2_ITEMC,CT2_CCC,CT2_CREDIT,SUBSTRING (CT2_DATA,1,6) "
	cQueryCred+= "ORDER BY CT2_ITEMC,CT2_CCC,CT2_CREDIT,SUBSTRING (CT2_DATA,1,6) "
	
	TcQuery cQueryCred New Alias "CREDITOS"
	
	If CREDITOS->(!EOF())
		If !TEMP1->(dbSeek(DEBITOS->(ITEM_DEBITO+CUSTO_DEBITO+CONTA_DEBITO)))
			Reclock("TEMP1",.T.)
			FILIAL := DEBITOS->ITEM_DEBITO
			C_CUSTO:= DEBITOS->CUSTO_DEBITO
			CONTA  := DEBITOS->CONTA_DEBITO
			                                                                                  
			If Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes1
				MES1:= DEBITOS->DATA_DEBITO
				VLR1:= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
				nResul1:= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes2
				MES2:= DEBITOS->DATA_DEBITO
				VLR2:= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
				nResul2:= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes3
				MES3:= DEBITOS->DATA_DEBITO
				VLR3:= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
				nResul3:= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes4
				MES4:= DEBITOS->DATA_DEBITO
				VLR4:= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
				nResul4:= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes5
				MES5:= DEBITOS->DATA_DEBITO
				VLR5:= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
				nResul5:= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes6
				MES6:= DEBITOS->DATA_DEBITO
				VLR6:= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
				nResul6:= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
			EndIf
			
			
			TOTAL:= nResul1+nResul2+nResul3+nResul4+nResul5+nResul6
			
			MsUnlock()
			
		Else
			Reclock("TEMP1",.F.)
			
			If Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes1
				MES1:= DEBITOS->DATA_DEBITO
				VLR1+= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes2
				MES2:= DEBITOS->DATA_DEBITO
				VLR2+= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes3
				MES3:= DEBITOS->DATA_DEBITO
				VLR3+= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes4
				MES4:= DEBITOS->DATA_DEBITO
				VLR4+= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes5
				MES5:= DEBITOS->DATA_DEBITO
				VLR5+= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes6
				MES6:= DEBITOS->DATA_DEBITO
				VLR6+= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
			EndIf
			
			TOTAL+= DEBITOS->VALOR_DEBITO-CREDITOS->VALOR_CREDITO
			
			MsUnlock()
			
		EndIf
	Else
		If !TEMP1->(dbSeek(DEBITOS->(ITEM_DEBITO+CUSTO_DEBITO+CONTA_DEBITO)))
			
			Reclock("TEMP1",.T.)
			FILIAL := DEBITOS->ITEM_DEBITO
			C_CUSTO:= DEBITOS->CUSTO_DEBITO
			CONTA  := DEBITOS->CONTA_DEBITO
			
			If Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes1
				MES1:= DEBITOS->DATA_DEBITO
				VLR1:= DEBITOS->VALOR_DEBITO
				nResul1:= DEBITOS->VALOR_DEBITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes2
				MES2:= DEBITOS->DATA_DEBITO
				VLR2:= DEBITOS->VALOR_DEBITO
				nResul2:= DEBITOS->VALOR_DEBITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes3
				MES3:= DEBITOS->DATA_DEBITO
				VLR3:= DEBITOS->VALOR_DEBITO
				nResul3:= DEBITOS->VALOR_DEBITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes4
				MES4:= DEBITOS->DATA_DEBITO
				VLR4:= DEBITOS->VALOR_DEBITO
				nResul4:= DEBITOS->VALOR_DEBITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes5
				MES5:= DEBITOS->DATA_DEBITO
				VLR5:= DEBITOS->VALOR_DEBITO
				nResul5:= DEBITOS->VALOR_DEBITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes6
				MES6:= DEBITOS->DATA_DEBITO
				VLR6:= DEBITOS->VALOR_DEBITO
				nResul6:= DEBITOS->VALOR_DEBITO
			EndIf
			
			TOTAL:= nResul1+nResul2+nResul3+nResul4+nResul5+nResul6
			
			MsUnlock()
		Else
			Reclock("TEMP1",.F.)
			
			If Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes1
				MES1:= DEBITOS->DATA_DEBITO
				VLR1+= DEBITOS->VALOR_DEBITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes2
				MES2:= DEBITOS->DATA_DEBITO
				VLR2+= DEBITOS->VALOR_DEBITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes3
				MES3:= DEBITOS->DATA_DEBITO
				VLR3+= DEBITOS->VALOR_DEBITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes4
				MES4:= DEBITOS->DATA_DEBITO
				VLR4+= DEBITOS->VALOR_DEBITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes5
				MES5:= DEBITOS->DATA_DEBITO
				VLR5+= DEBITOS->VALOR_DEBITO
				
			Elseif Val(Substr(DEBITOS->DATA_DEBITO,5,2))=nMes6
				MES6:= DEBITOS->DATA_DEBITO
				VLR6+= DEBITOS->VALOR_DEBITO
			EndIf
			
			TOTAL+= DEBITOS->VALOR_DEBITO
			
			MsUnlock()
		EndIf
	EndIf
	
	CREDITOS->(dbCloseArea())
	
	DEBITOS->(dbSkip())                     
EndDo
                                                                  
DEBITOS->(dbCloseArea())
                                                 

// Trecho para tratamento das contas que possuem apenas credito e não possuem débito

cQryCred2:= "SELECT CT2_ITEMC ITEM_CREDITO,CT2_CCC CUSTO_CREDITO,CT2_CREDIT CONTA_CREDITO,SUBSTRING(CT2_DATA,1,6)DATA_CREDITO, "
cQryCred2+= "SUM(CT2_VALOR) AS VALOR_CREDITO  "
cQryCred2+= "FROM CT2010 WHERE D_E_L_E_T_ <> '*' "
cQryCred2+= "AND  CT2_DATA   BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
cQryCred2+= "AND  CT2_ITEMC  BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
cQryCred2+= "AND  CT2_CCC    BETWEEN '"+MV_PAR03+" ' AND  '"+MV_PAR04+"'"
cQryCred2+= "AND  CT2_CREDIT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
cQryCred2+= "GROUP BY CT2_ITEMC,CT2_CCC,CT2_CREDIT,SUBSTRING (CT2_DATA,1,6) "            
cQryCred2+= "ORDER BY CT2_ITEMC,CT2_CCC,CT2_CREDIT,SUBSTRING (CT2_DATA,1,6) "

TcQuery cQryCred2 New Alias "CRED2"

CRED2->(dbGoTop())

While CRED2->(!EOF())
	
	nResul1:=0
	nResul2:=0
	nResul3:=0
	nResul4:=0
	nResul5:=0                                     
	nResul6:=0
	                                        
	                                                
	
	cQryDeb2:= "SELECT CT2_ITEMD ITEM_DEBITO,CT2_CCD CUSTO_DEBITO, CT2_DEBITO CONTA_DEBITO, SUBSTRING (CT2_DATA,1,6)DATA_DEBITO,  "
	cQryDeb2+= "SUM(CT2_VALOR) AS VALOR_DEBITO "
	cQryDeb2+= "FROM CT2010  WHERE D_E_L_E_T_ <> '*' "
	cQryDeb2+= "AND  SUBSTRING(CT2_DATA,1,6) BETWEEN '"+CRED2->DATA_CREDITO+"'  AND '"+CRED2->DATA_CREDITO+"' "
	cQryDeb2+= "AND  CT2_ITEMD  BETWEEN '"+CRED2->ITEM_CREDITO+"'  AND '"+CRED2->ITEM_CREDITO+"' "
	cQryDeb2+= "AND  CT2_CCD    BETWEEN '"+CRED2->CUSTO_CREDITO+"' AND '"+CRED2->CUSTO_CREDITO+"' "
	cQryDeb2+= "AND  CT2_DEBITO BETWEEN '"+CRED2->CONTA_CREDITO+"' AND '"+CRED2->CONTA_CREDITO+"' "
	cQryDeb2+= "GROUP BY CT2_ITEMD,CT2_CCD,CT2_DEBITO,SUBSTRING (CT2_DATA,1,6)"
	cQryDeb2+= "ORDER BY CT2_ITEMD,CT2_CCD,CT2_DEBITO,SUBSTRING (CT2_DATA,1,6)"
	
	TcQuery cQryDeb2 New Alias "DEB2"
	
   	If DEB2->(EOF())
		If !TEMP1->(dbSeek(CRED2->(ITEM_CREDITO+CUSTO_CREDITO+CONTA_CREDITO)))
			
			Reclock("TEMP1",.T.)
			FILIAL := CRED2->ITEM_CREDITO
			C_CUSTO:= CRED2->CUSTO_CREDITO
			CONTA  := CRED2->CONTA_CREDITOS
			
			If Val(Substr(CRED2->DATA_CREDITO,5,2))=nMes1
				MES1:= CRED2->DATA_CREDITO
				VLR1:= CRED2->VALOR_CREDITO*-1
				nResul1:= CRED2->VALOR_CREDITO*-1
				                                                                  
			Elseif Val(Substr(CRED2->DATA_CREDITO,5,2))=nMes2
				MES2:= CRED2->DATA_CREDITO
				VLR2:= CRED2->VALOR_CREDITO*-1
				nResul2:= CRED2->VALOR_CREDITO*-1
				
			Elseif Val(Substr(CRED2->DATA_CREDITO,5,2))=nMes3
				MES3:= CRED2->DATA_CREDITO
				VLR3:= CRED2->VALOR_CREDITO*-1
				nResul3:= CRED2->VALOR_CREDITO*-1
				
			Elseif Val(Substr(CRED2->DATA_CREDITO,5,2))=nMes4
				MES4:= CRED2->DATA_CREDITO
				VLR4:= CRED2->VALOR_CREDITO*-1
				nResul4:= CRED2->VALOR_CREDITO*-1
				
			Elseif Val(Substr(CRED2->DATA_CREDITO,5,2))=nMes5
				MES5:= CRED2->DATA_CREDITO
				VLR5:= CRED2->VALOR_CREDITO*-1
				nResul5:= CRED2->VALOR_CREDITO*-1
				
			Elseif Val(Substr(CRED2->DATA_CREDITO,5,2))=nMes6
				MES6:= CRED2->DATA_CREDITO
				VLR6:= CRED2->VALOR_CREDITO*-1
				nResul6:= CRED2->VALOR_CREDITO*-1
			EndIf
			
			TOTAL:= nResul1+nResul2+nResul3+nResul4+nResul5+nResul6
			
			MsUnlock()
			
			
		Else
			Reclock("TEMP1",.F.)
			
			If Val(Substr(CRED2->DATA_CREDITO,5,2))=nMes1
				MES1:= CRED2->DATA_CREDITO
				VLR1+= CRED2->VALOR_CREDITO*-1
				
			Elseif Val(Substr(CRED2->DATA_CREDITOS,5,2))=nMes2
				MES2:= CRED2->DATA_CREDITO
				VLR2+= CRED2->VALOR_CREDITO*-1
				
			Elseif Val(Substr(CRED2->DATA_CREDITO,5,2))=nMes3
				MES3:= CRED2->DATA_CREDITO
				VLR3+= CRED2->VALOR_CREDITO*-1
				
			Elseif Val(Substr(CRED2->DATA_CREDITO,5,2))=nMes4
				MES4:= CRED2->DATA_CREDITO
				VLR4+= CRED2->VALOR_CREDITO*-1
				
			Elseif Val(Substr(CRED2->DATA_CREDITO,5,2))=nMes5
				MES5:= CRED2->DATA_CREDITO
				VLR5+= CRED2->VALOR_CREDITO*-1
				
			Elseif Val(Substr(CRED2->DATA_CREDITO,5,2))=nMes6
				MES6:= CRED2->DATA_CREDITO
				VLR6+= CRED2->VALOR_CREDITO*-1
			EndIf
			
			TOTAL+= CRED2->VALOR_CREDITO*-1
			
			MsUnlock()
		EndIf
	EndIf
	
	DEB2->(dbcloseArea())
	
	CRED2->(dbSkip())
	
EndDo

CRED2->(dbCloseArea())

//  Final do Trecho para tratamento das contas que possuem apenas credito e não possuem débito


cTemp2:= CriaTrab(aStruc,.T.)
dbUseArea(.T.,,cTemp2,"TEMP2",.F.,.F.)

cInd12  := CriaTrab(NIL,.F.)
IndRegua("TEMP2",cInd12,cChave,,,"Selecionando Registros...")

TEMP1->(dbGoTop())

While TEMP1->(!EOF())
	
	RecLock("TEMP2",.T.)
	FILIAL := TEMP1->FILIAL
	C_CUSTO:= TEMP1->C_CUSTO
	CONTA  := TEMP1->CONTA
	
	If !Empty(nMes1)
		MES1:= TEMP1->MES1
		VLR1:= TEMP1->VLR1
	EndIf
	
	If !Empty(nMes2)
		MES2:= TEMP1->MES2
		VLR2:= TEMP1->VLR2
	EndIf
	
	If !Empty(nMes3)
		MES3:= TEMP1->MES3
		VLR3:= TEMP1->VLR3
	EndIf
	
	If !Empty(nMes4)
		MES4:= TEMP1->MES4
		VLR4:= TEMP1->VLR4
	EndIf
	
	If !Empty(nMes5)
		MES5:= TEMP1->MES5
		VLR5:= TEMP1->VLR5
	EndIf
	
	If !Empty(nMes6)
		MES6:= TEMP1->MES6
		VLR6:= TEMP1->VLR6
	EndIf
	
	TOTAL:= TEMP1->TOTAL
	
	MsUnlock()
	
	
	CT1->(dbSeek(xFilial("CT1")+TEMP1->CONTA))
	If !Empty(CT1->CT1_CTASUP)
		If !TEMP2->(dbSeek(TEMP1->(FILIAL+C_CUSTO)+CT1->CT1_CTASUP))
			RecLock("TEMP2",.T.)
			FILIAL := TEMP1->FILIAL
			C_CUSTO:= TEMP1->C_CUSTO
			CONTA  := CT1->CT1_CTASUP
			
			If !Empty(nMes1)
				MES1:= TEMP1->MES1
				VLR1:= TEMP1->VLR1
			EndIf
			
			If !Empty(nMes2)
				MES2:= TEMP1->MES2
				VLR2:= TEMP1->VLR2
			EndIf
			
			If !Empty(nMes3)
				MES3:= TEMP1->MES3
				VLR3:= TEMP1->VLR3
			EndIf
			
			If !Empty(nMes4)
				MES4:= TEMP1->MES4
				VLR4:= TEMP1->VLR4
			EndIf
			
			If !Empty(nMes5)
				MES5:= TEMP1->MES5
				VLR5:= TEMP1->VLR5
			EndIf
			
			If !Empty(nMes6)
				MES6:= TEMP1->MES6
				VLR6:= TEMP1->VLR6
			EndIf
			
			TOTAL:= TEMP1->TOTAL
			
			MsUnlock()
			
		Else
			RecLock("TEMP2",.F.)
			
			If !Empty(nMes1)
				MES1+= TEMP1->MES1
				VLR1+= TEMP1->VLR1
			EndIf
			
			If !Empty(nMes2)
				MES2+= TEMP1->MES2
				VLR2+= TEMP1->VLR2
			EndIf
			
			If !Empty(nMes3)
				MES3+= TEMP1->MES3
				VLR3+= TEMP1->VLR3
			EndIf
			
			If !Empty(nMes4)
				MES4+= TEMP1->MES4
				VLR4+= TEMP1->VLR4
			EndIf
			
			If !Empty(nMes5)
				MES5+= TEMP1->MES5
				VLR5+= TEMP1->VLR5
			EndIf
			
			If !Empty(nMes6)
				MES6+= TEMP1->MES6
				VLR6+= TEMP1->VLR6
			EndIf
			
			TOTAL+= TEMP1->TOTAL
			
			MsUnlock()
		EndIf
	EndIF
	
	CT1->(dbSeek(xFilial("CT1")+TEMP1->CONTA))
	CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
	If !Empty(CT1->CT1_CTASUP)
		If !TEMP2->(dbSeek(TEMP1->(FILIAL+C_CUSTO)+CT1->CT1_CTASUP))
			RecLock("TEMP2",.T.)
			FILIAL := TEMP1->FILIAL
			C_CUSTO:= TEMP1->C_CUSTO
			CONTA  := CT1->CT1_CTASUP
			
			If !Empty(nMes1)
				MES1:= TEMP1->MES1
				VLR1:= TEMP1->VLR1
			EndIf
			
			If !Empty(nMes2)
				MES2:= TEMP1->MES2
				VLR2:= TEMP1->VLR2
			EndIf
			
			If !Empty(nMes3)
				MES3:= TEMP1->MES3
				VLR3:= TEMP1->VLR3
			EndIf
			
			If !Empty(nMes4)
				MES4:= TEMP1->MES4
				VLR4:= TEMP1->VLR4
			EndIf
			
			If !Empty(nMes5)
				MES5:= TEMP1->MES5
				VLR5:= TEMP1->VLR5
			EndIf
			
			If !Empty(nMes6)
				MES6:= TEMP1->MES6
				VLR6:= TEMP1->VLR6
			EndIf
			
			TOTAL:= TEMP1->TOTAL
			
			MsUnlock()
			
		Else
			RecLock("TEMP2",.F.)
			
			If !Empty(nMes1)
				MES1+= TEMP1->MES1
				VLR1+= TEMP1->VLR1
			EndIf
			
			If !Empty(nMes2)
				MES2+= TEMP1->MES2
				VLR2+= TEMP1->VLR2
			EndIf
			
			If !Empty(nMes3)
				MES3+= TEMP1->MES3
				VLR3+= TEMP1->VLR3
			EndIf
			
			If !Empty(nMes4)
				MES4+= TEMP1->MES4
				VLR4+= TEMP1->VLR4
			EndIf
			
			If !Empty(nMes5)
				MES5+= TEMP1->MES5
				VLR5+= TEMP1->VLR5
			EndIf
			
			If !Empty(nMes6)
				MES6+= TEMP1->MES6
				VLR6+= TEMP1->VLR6
			EndIf
			
			TOTAL+= TEMP1->TOTAL
			
			MsUnlock()
		EndIf
	EndIf
	
	CT1->(dbSeek(xFilial("CT1")+TEMP1->CONTA))
	CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
	CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
	If !Empty(CT1->CT1_CTASUP)
		If !TEMP2->(dbSeek(TEMP1->(FILIAL+C_CUSTO)+CT1->CT1_CTASUP))
			RecLock("TEMP2",.T.)
			FILIAL := TEMP1->FILIAL
			C_CUSTO:= TEMP1->C_CUSTO
			CONTA  := CT1->CT1_CTASUP
			
			If !Empty(nMes1)
				MES1:= TEMP1->MES1
				VLR1:= TEMP1->VLR1
			EndIf
			
			If !Empty(nMes2)
				MES2:= TEMP1->MES2
				VLR2:= TEMP1->VLR2
			EndIf
			
			If !Empty(nMes3)
				MES3:= TEMP1->MES3
				VLR3:= TEMP1->VLR3
			EndIf
			
			If !Empty(nMes4)
				MES4:= TEMP1->MES4
				VLR4:= TEMP1->VLR4
			EndIf
			
			If !Empty(nMes5)
				MES5:= TEMP1->MES5
				VLR5:= TEMP1->VLR5
			EndIf
			
			If !Empty(nMes6)
				MES6:= TEMP1->MES6
				VLR6:= TEMP1->VLR6
			EndIf
			
			TOTAL:= TEMP1->TOTAL
			
			MsUnlock()
			
		Else
			RecLock("TEMP2",.F.)
			
			If !Empty(nMes1)
				MES1+= TEMP1->MES1
				VLR1+= TEMP1->VLR1
			EndIf
			
			If !Empty(nMes2)
				MES2+= TEMP1->MES2
				VLR2+= TEMP1->VLR2
			EndIf
			
			If !Empty(nMes3)
				MES3+= TEMP1->MES3
				VLR3+= TEMP1->VLR3
			EndIf
			
			If !Empty(nMes4)
				MES4+= TEMP1->MES4
				VLR4+= TEMP1->VLR4
			EndIf
			
			If !Empty(nMes5)
				MES5+= TEMP1->MES5
				VLR5+= TEMP1->VLR5
			EndIf
			
			If !Empty(nMes6)
				MES6+= TEMP1->MES6
				VLR6+= TEMP1->VLR6
			EndIf
			
			TOTAL+= TEMP1->TOTAL
			
			MsUnlock()
		EndIf
	EndIf
	
	CT1->(dbSeek(xFilial("CT1")+TEMP1->CONTA))
	CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
	CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
	CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
	If !Empty(CT1->CT1_CTASUP)
		If !TEMP2->(dbSeek(TEMP1->(FILIAL+C_CUSTO)+CT1->CT1_CTASUP))
			RecLock("TEMP2",.T.)
			FILIAL := TEMP1->FILIAL
			C_CUSTO:= TEMP1->C_CUSTO
			CONTA  := CT1->CT1_CTASUP
			
			If !Empty(nMes1)
				MES1:= TEMP1->MES1
				VLR1:= TEMP1->VLR1
			EndIf
			
			If !Empty(nMes2)
				MES2:= TEMP1->MES2
				VLR2:= TEMP1->VLR2
			EndIf
			
			If !Empty(nMes3)
				MES3:= TEMP1->MES3
				VLR3:= TEMP1->VLR3
			EndIf
			
			If !Empty(nMes4)
				MES4:= TEMP1->MES4
				VLR4:= TEMP1->VLR4
			EndIf
			
			If !Empty(nMes5)
				MES5:= TEMP1->MES5
				VLR5:= TEMP1->VLR5
			EndIf
			
			If !Empty(nMes6)
				MES6:= TEMP1->MES6
				VLR6:= TEMP1->VLR6
			EndIf
			
			TOTAL:= TEMP1->TOTAL
			
			MsUnlock()
			
		Else
			RecLock("TEMP2",.F.)
			
			If !Empty(nMes1)
				MES1+= TEMP1->MES1
				VLR1+= TEMP1->VLR1
			EndIf
			
			If !Empty(nMes2)
				MES2+= TEMP1->MES2
				VLR2+= TEMP1->VLR2
			EndIf
			
			If !Empty(nMes3)
				MES3+= TEMP1->MES3
				VLR3+= TEMP1->VLR3
			EndIf
			
			If !Empty(nMes4)
				MES4+= TEMP1->MES4
				VLR4+= TEMP1->VLR4
			EndIf
			
			If !Empty(nMes5)
				MES5+= TEMP1->MES5
				VLR5+= TEMP1->VLR5
			EndIf
			
			If !Empty(nMes6)
				MES6+= TEMP1->MES6
				VLR6+= TEMP1->VLR6
			EndIf
			
			TOTAL+= TEMP1->TOTAL
			
			MsUnlock()
		EndIf
	EndIf
	
	CT1->(dbSeek(xFilial("CT1")+TEMP1->CONTA))
	CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
	CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
	CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
	CT1->(dbSeek(xFilial("CT1")+CT1->CT1_CTASUP))
	If !Empty(CT1->CT1_CTASUP)
		If !TEMP2->(dbSeek(TEMP1->(FILIAL+C_CUSTO)+CT1->CT1_CTASUP))
			RecLock("TEMP2",.T.)
			FILIAL := TEMP1->FILIAL
			C_CUSTO:= TEMP1->C_CUSTO
			CONTA  := CT1->CT1_CTASUP
			
			If !Empty(nMes1)
				MES1:= TEMP1->MES1
				VLR1:= TEMP1->VLR1
			EndIf
			
			If !Empty(nMes2)
				MES2:= TEMP1->MES2
				VLR2:= TEMP1->VLR2
			EndIf
			
			If !Empty(nMes3)
				MES3:= TEMP1->MES3
				VLR3:= TEMP1->VLR3
			EndIf
			
			If !Empty(nMes4)
				MES4:= TEMP1->MES4
				VLR4:= TEMP1->VLR4
			EndIf
			
			If !Empty(nMes5)
				MES5:= TEMP1->MES5
				VLR5:= TEMP1->VLR5
			EndIf
			
			If !Empty(nMes6)
				MES6:= TEMP1->MES6
				VLR6:= TEMP1->VLR6
			EndIf
			
			TOTAL:= TEMP1->TOTAL
			
			MsUnlock()
			
		Else
			RecLock("TEMP2",.F.)
			
			If !Empty(nMes1)
				MES1+= TEMP1->MES1
				VLR1+= TEMP1->VLR1
			EndIf
			
			If !Empty(nMes2)
				MES2+= TEMP1->MES2
				VLR2+= TEMP1->VLR2
			EndIf
			
			If !Empty(nMes3)
				MES3+= TEMP1->MES3
				VLR3+= TEMP1->VLR3
			EndIf
			
			If !Empty(nMes4)
				MES4+= TEMP1->MES4
				VLR4+= TEMP1->VLR4
			EndIf
			
			If !Empty(nMes5)
				MES5+= TEMP1->MES5
				VLR5+= TEMP1->VLR5
			EndIf
			
			If !Empty(nMes6)
				MES6+= TEMP1->MES6
				VLR6+= TEMP1->VLR6
			EndIf
			
			TOTAL+= TEMP1->TOTAL
			
			MsUnlock()
		EndIf
	EndIF
	
	
	TEMP1->(dbSkip())
	
EndDo

                                      
TEMP1->(dbCloseArea())

If !Empty(cMes1)
	TRCell():New(oSection3,"Coluna01",,cMes1,,,,{||TEMP2->VLR1})
EndIf

If !Empty(cMes2)
	TRCell():New(oSection3,"Coluna02",,cMes2,,,,{||TEMP2->VLR2})
EndIf

If !Empty(cMes3)
	TRCell():New(oSection3,"Coluna03",,cMes3,,,,{||TEMP2->VLR3})
EndIf

If !Empty(cMes4)
	TRCell():New(oSection3,"Coluna04",,cMes4,,,,{||TEMP2->VLR4})
EndIf

If !Empty(cMes5)
	TRCell():New(oSection3,"Coluna05",,cMes5,,,,{||TEMP2->VLR5})
EndIf

If !Empty(cMes6)
	TRCell():New(oSection3,"Coluna06",,cMes6,,,,{||TEMP2->VLR6})
EndIf

TRCell():New(oSection3,"Coluna7",,"Valor Total do Periodo",,,,{||TEMP2->TOTAL})



TEMP2->(dbGoTop())

While TEMP2->(!EOF())
	
	
	If Empty(_cFilial)
		_cFilial := TEMP2->FILIAL
		oSection1:Init()
		oSection1:PrintLine()
		oSection1:Finish()
	ElseIf !Empty(_cFilial) .and. _cFilial <> TEMP2->FILIAL
		_cFilial := TEMP2->FILIAL
		oSection1:Init()
		oSection1:PrintLine()
		oSection1:Finish()
	EndIf
	
	
	If Empty(cCentroCusto)
		cCentroCusto:= TEMP2->C_CUSTO
		oSection2:Init()
		oSection2:PrintLine()
		oSection2:Finish()
	ElseIf !Empty(cCentroCusto) .and. cCentroCusto <> TEMP2->C_CUSTO
		oSection3:Finish()
		oReport:SkipLine()
		oReport:SkipLine()
		
		cCentroCusto:= TEMP2->C_CUSTO
		oSection2:Init()
		oSection2:PrintLine()
		oSection2:Finish()
	EndIf
	
	oSection3:Init()
	oSection3:Printline()
	
	
	TEMP2->(dbSkip())
	
EndDo

TEMP2->(dbCloseArea())

Return