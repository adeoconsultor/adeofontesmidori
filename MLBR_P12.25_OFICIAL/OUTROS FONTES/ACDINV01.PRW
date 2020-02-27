#INCLUDE "TOTVS.ch"    
#INCLUDE "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACDINV01 ºAutor  ³Antonio Carlos Damaceno º Data ³  28/11/16º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de Leitura de etq de produtos para inventario - PNP1º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlterações³ Antonio - 04/2017 (alterar incluindo o Armazem no cod etq) º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
028019|APAPU13416|112401C
*/

User Function ACDINV01()

Local cData	 := dDataBase
Local oData
Local oCodCC
Local oQuant

Private oCodEtq
Private cCodEtq   := Space(30)
Private cCodLocal := Space(02)
Private cCodCC    := Space(09)  
Private nQuant    := 0

Private oDlg
Private nOpc
Private nLastKey:= 0 
Private oTButton1, oTButton2

//Monta interface com o usuário
//DEFINE MSDIALOG oDlg TITLE "Alteração de Campos do Plano de Produção" FROM C(164),C(182) TO C(325),C(409) PIXEL
DEFINE MSDIALOG oDlg TITLE "INVENTARIO PNP1" FROM C(010),C(010) TO C(425),C(509) PIXEL

// Cria as Groups do Sistema
@ C(003),C(003) TO C(260),C(360) LABEL "Informe os dados a serem inventariados" PIXEL OF oDlg

@ C(053),C(008) Say "Etiqueta:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(053),C(050) MsGet oCodEtq Var cCodEtq Size C(091),C(009) COLOR CLR_BLACK Picture "@!X" PIXEL OF oDlg VALID FS_XETQ(cCodEtq,SubStr(cCodEtq,1,2))

//@ C(073),C(008) Say "Centro Custo:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
//@ C(073),C(050) MsGet oCodCC Var cCodCC F3 'CTT' Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg

@ C(073),C(008) Say "Quantidade:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(073),C(050) MsGet oQuant Var nQuant Size C(041),C(009) COLOR CLR_BLACK Picture "999,999,999.9999" PIXEL OF oDlg VALID FS_XQtd()

//oTBrowseButton := TBrowseButton():New( 250,145,'Confirmar',oDlg,{||nOpc := 1,oDlg:End() },50,10,,,.F.,.T.,.F.,,.F.,,,)
//oTBrowseButton1 := TBrowseButton():New( 250,200,'Fechar',oDlg,{||nOpc := 2,oDlg:End() },50,10,,,.F.,.T.,.F.,,.F.,,,)

oTButton1 := TButton():New( 250, 145, 'Confirmar',oDlg,{||nOpc := 1,oDlg:End()}, 50,10,,,.F.,.T.,.F.,,.F.,,,.F. )   
oTButton2 := TButton():New( 250, 200, 'Fechar',oDlg,{||nOpc := 2,oDlg:End() }, 50,10,,,.F.,.T.,.F.,,.F.,,,.F. )   

ACTIVATE MSDIALOG oDlg CENTERED

If nOpc == 1

	cCodEtq := STRTRAN(cCodEtq,";","/")           //Foi feito este ajuste porque os leitores leem ";" ao invés de ler "/"

	ZZT->(dbSetOrder(1))
	If !ZZT->(dbSeek(xFilial("ZZT")+cCodEtq)  )
		Alert('Etiqueta não cadastrada !!!')
		cCodEtq   := Space(25)
		lRet:=.F.
		Return(lRet)  
	Else
		cCodLocal   := ZZT->ZZT_LOCAL
		cZZS_CODPRO := ZZT->ZZT_CODPRO
		cZZS_LOTE   := ZZT->ZZT_LOTE
		cZZS_CODETQ := ZZT->ZZT_SEQUEN 
		cCodCC      := ZZT->ZZT_CCUSTO
	EndIf
	
	dbSelectArea("ZZS")    //
	dbSetOrder(1)          //DOC+CODPROD+LOTE+CODETQ+ARMAZEM
//	If !dbSeek(xFilial("ZZS")+DtoS(dDataBase)+UPESQ(cCodEtq,'2')+UPESQ(cCodEtq,'3')+UPESQ(cCodEtq,'4')+cCodLocal) 
	If !dbSeek(xFilial("ZZS")+cZZS_CODPRO+cZZS_LOTE+cZZS_CODETQ+cCodLocal)
		Reclock("ZZS",.T.)

		ZZS->ZZS_FILIAL  := xFilial("ZZS")
		ZZS->ZZS_DOC     := DtoS(dDataBase)
		ZZS->ZZS_CODPRO  := cZZS_CODPRO   //UPESQ(cCodEtq,'2')
		ZZS->ZZS_LOTE    := cZZS_LOTE     //UPESQ(cCodEtq,'3')
		ZZS->ZZS_CODETQ  := cZZS_CODETQ   //UPESQ(cCodEtq,'4')
		ZZS->ZZS_LOCAL   := cCodLocal                              //BUSCAR DA ZZT_LOCAL
		ZZS->ZZS_CCUSTO  := cCodCC                                 //BUSCAR DA ZZT_CC
		ZZS->ZZS_DTINV   := dDataBase    //cData

		ZZS->ZZS_DTVALI  := dDataBase + 1780    //cData

		If Right(Alltrim(cCodEtq), 1) == 'A'
			ZZS->ZZS_LEITU  := "A"
		ElseIf Right(Alltrim(cCodEtq), 1) == 'B'
			ZZS->ZZS_LEITU  := "B"
		ElseIf Right(Alltrim(cCodEtq), 1) == 'C'
			ZZS->ZZS_LEITU  := "C"
		EndIf
			
		ZZS->ZZS_QTDE   := nQuant
		ZZS->ZZS_USR     := RetCodUsr()
		ZZS->ZZS_ENCERR  := "N"

		MsUnlock()
	Else

		Alert('Etiqueta já lida!!!')
		cCodEtq   := Space(30)
	EndIf

Else
	Alert("Processamento cancelado pelo usuário")
	cCodEtq   := Space(30)
	Return(.T.)  
EndIf

If (nLastKey == 27 )
	Alert("Processamento cancelado pelo usuário")
	cCodEtq   := Space(30)
	Return(.T.)  
EndIf

cCodEtq   := Space(30)

U_ACDINV01()
//FS_INVEN01()

Return(.T.)  
                                 
                                 


/////////////////////////////////////////////////
//Verifica se ETIQUETA JA FOI LIDA
//Antonio
//////////////////////////////////^///////////////
Static Function FS_XETQ(cCodEtq,cCodLocal)

Local lRet:=.T.
Local cAliasZZS   := GetNextAlias()
Local cAliasZZS1  := GetNextAlias()
Local cAliasZZS2  := GetNextAlias()
Local cAliasZZT1  := GetNextAlias()
Local cZZS_CODPRO := ""
Local cZZS_LOTE   := ""
Local cZZS_CODETQ := ""
Local dDataI      := SuperGetMV("MV_DTIINI",.F.,"")
Local dDataF      := SuperGetMV("MV_DTIFIM",.F.,"")

//Foi feito este ajuste porque os leitores leem ; ao invés de ler /    
cCodEtq := StrTran(cCodEtq,";","/")        
oCodEtq:Refresh()
oDlg:Refresh()                        

If nOPC == 2
	Alert("Processamento cancelado pelo usuário")
	cCodEtq   := Space(30)
	lRet:=.F.
	Return(lRet)  
EndIf

cData:='20'+SubStr(Right(Alltrim(dDataBase), 9),1,6)
// Insere                                                
//cData:= STUFF(cData, 3, 0, "/") // Resulta: XX/XXXX
//cData:= STUFF(cData, 6, 0, "/") // Resulta: XX/XX/XX   // desabilitado por Diego em 07/12 - Problema ao formar data, perda de caractere
cData:=StoD(cData)

If  dDataBase < dDataI .Or. dDataBase > dDataF
	Alert('Data da etiqueta inválida !!! Confira se a data da etiqueta corresponde ao periodo do Inventario Atual! ' )
	cCodEtq   := Space(30)
	lRet:=.F.
	Return(lRet)  
EndIf


If Len(cCodEtq) < 15
	Alert('Etiqueta não cadastrada !!!')
	cCodEtq   := Space(30)
	lRet:=.F.
	Return(lRet)  

EndIf              

dbSelectArea("ZZT")
dbSetOrder(1)
If !dbSeek(xFilial("ZZT")+cCodEtq)
	Alert('Etiqueta não cadastrada !!!')
	cCodEtq   := Space(25)
	lRet:=.F.
	Return(lRet)  
Else
	cCodLocal   := ZZT->ZZT_LOCAL
	cZZS_CODPRO := ZZT->ZZT_CODPRO
	cZZS_LOTE   := ZZT->ZZT_LOTE
	cZZS_CODETQ := ZZT->ZZT_SEQUEN
EndIf

SB1->(dbSetOrder(1))
If !SB1->(dbSeek(xFilial("SB1")+cZZS_CODPRO))
	Alert('Etiqueta não cadastrada, Leitura efetuada errada ou Produto: '+cZZS_CODPRO+' não Cadastrado !!!')
	cCodEtq   := Space(30)
	lRet:=.F.
	Return(lRet)  
EndIf


ZZT->(dbSetOrder(1))
If !ZZT->(dbSeek(xFilial("ZZT")+cCodEtq))

	cQuery := "SELECT ZZT_CODETQ , ZZT_LOCAL "
	cQuery += "  FROM " + RetSqlName("ZZT") + " ZZT  "
	cQuery += "  WHERE ZZT.ZZT_FILIAL  = '" + xFilial("ZZT") + "' AND "
	cQuery += "        ZZT.D_E_L_E_T_  = ' '                      AND " 
	cQuery += "        ZZT_CODPRO      = '" + cZZS_CODPRO    + "' AND "
	cQuery += "        ZZT_LOTE        = '" + cZZS_LOTE      + "' AND "
	cQuery += "        ZZT_SEQUEN      = '" + cZZS_CODETQ    + "' AND "
	cQuery += "        ZZT.ZZT_LOCAL   = '" + cCodLocal      + "' " 
	cQuery += "ORDER BY ZZT_CODETQ, ZZT_LOCAL "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZZT1,.T.,.T.) 
	dbSelectArea(cAliasZZT1)
			
	If (cAliasZZT1)->(Eof())

		Alert('Etiqueta não cadastrada !!!')
		cCodEtq   := Space(30)
		(cAliasZZT1)->(dbCloseArea())

		lRet:=.F.
		Return(lRet)  
	Else

		If Right(Alltrim(cCodEtq), 1) == 'B'
	
			cZZS_LEITU  := SubStr(cZZS_CODETQ,1,8)+"A"
	
			cQuery := " SELECT ZZS.ZZS_CODPRO, ZZS.ZZS_CODETQ, ZZS.ZZS_LOTE, ZZS.ZZS_ENCERR "
			cQuery += "  FROM " + RetSqlName("ZZS") + " ZZS  "
			cQuery += "  WHERE ZZS.ZZS_FILIAL  = '" + xFilial("ZZS") + "' AND "
			cQuery += "        ZZS.D_E_L_E_T_  = ' ' AND " 
			cQuery += "        ZZS.ZZS_CODPRO  = '" + cZZS_CODPRO + "' AND "
			cQuery += "        ZZS.ZZS_LOTE    = '" + cZZS_LOTE   + "' AND "
			cQuery += "        ZZS.ZZS_CODETQ  = '" + cZZS_LEITU  + "' AND "
			cQuery += "        ZZS.ZZS_LOCAL   = '" + cCodLocal   + "' "
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZZS1,.T.,.T.) 
			dbSelectArea(cAliasZZS1)
			
			If (cAliasZZS1)->ZZS_ENCERR == 'S'
				Alert('Etiqueta encerrada!')
				cCodEtq   := Space(30)
				(cAliasZZS1)->(dbCloseArea())
				lRet:=.F.
				Return(lRet)								
			Elseif (cAliasZZS1)->(Eof())
				Alert('Não foi feita a leitura da primeira contagem, faça a primeira contagem para iniciar a segunda/terceira contagem!!!')
				cCodEtq   := Space(30)
				(cAliasZZS1)->(dbCloseArea())
				lRet:=.F.
				Return(lRet)		
			EndIf
					
			(cAliasZZS1)->(dbCloseArea())
	
		ElseIf Right(Alltrim(cCodEtq), 1) == 'C'
	
			cZZS_LEITU  := SubStr(cZZS_CODETQ,1,8)+"B"
	
			cQuery := " SELECT ZZS.ZZS_CODPRO, ZZS.ZZS_CODETQ, ZZS.ZZS_LOTE, ZZS.ZZS_ENCERR "
			cQuery += "  FROM " + RetSqlName("ZZS") + " ZZS  "
			cQuery += "  WHERE ZZS.ZZS_FILIAL  = '" + xFilial("ZZS") + "' AND "
			cQuery += "        ZZS.D_E_L_E_T_  = ' ' AND " 
			cQuery += "        ZZS.ZZS_CODPRO  = '" + cZZS_CODPRO + "' AND "
			cQuery += "        ZZS.ZZS_LOTE    = '" + cZZS_LOTE   + "' AND "
			cQuery += "        ZZS.ZZS_CODETQ  = '" + cZZS_LEITU  + "' AND "
			cQuery += "        ZZS.ZZS_LOCAL   = '" + cCodLocal   + "' AND "
			cQuery += "        ZZS.ZZS_ENCERR  <> 'S' "
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZZS2,.T.,.T.) 
			dbSelectArea(cAliasZZS2)

			If (cAliasZZS2)->ZZS_ENCERR == 'S'
				Alert('Etiqueta encerrada!')
				cCodEtq   := Space(30)
				(cAliasZZS2)->(dbCloseArea())
				lRet:=.F.
				Return(lRet)											
			ElseIf (cAliasZZS2)->(Eof())
				Alert('Não foi feita a leitura a segunda contagem, faça a segunda contagem para iniciar a terceira contagem!!!')
				cCodEtq   := Space(30)
				(cAliasZZS2)->(dbCloseArea())
				lRet:=.F.
				Return(lRet)		
			EndIf
					
			(cAliasZZS2)->(dbCloseArea())
			
		EndIf

	EndIf

	(cAliasZZT1)->(dbCloseArea())

Else

//cCodLocal:=ZZT->ZZT_LOCAL

	If Right(Alltrim(cCodEtq), 1) == 'B'

		cZZS_LEITU  := SubStr(cZZS_CODETQ,1,8)+"A"

		cQuery := " SELECT ZZS.ZZS_CODPRO, ZZS.ZZS_CODETQ, ZZS.ZZS_LOTE, ZZS.ZZS_ENCERR "
		cQuery += "  FROM " + RetSqlName("ZZS") + " ZZS  "
		cQuery += "  WHERE ZZS.ZZS_FILIAL  = '" + xFilial("ZZS") + "' AND "
		cQuery += "        ZZS.D_E_L_E_T_  = ' ' AND " 
		cQuery += "        ZZS.ZZS_CODPRO  = '" + cZZS_CODPRO + "' AND "
		cQuery += "        ZZS.ZZS_LOTE    = '" + cZZS_LOTE   + "' AND "
		cQuery += "        ZZS.ZZS_CODETQ  = '" + cZZS_LEITU  + "' AND "
		cQuery += "        ZZS.ZZS_LOCAL   = '" + cCodLocal   + "' "

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZZS1,.T.,.T.) 
		dbSelectArea(cAliasZZS1)

		If (cAliasZZS1)->ZZS_ENCERR == 'S'
				Alert('Etiqueta encerrada!')
				cCodEtq   := Space(30)
				(cAliasZZS1)->(dbCloseArea())
				lRet:=.F.
				Return(lRet)										
		ElseIf (cAliasZZS1)->(Eof())
			Alert('Não foi feita a leitura da primeira contagem, faça a primeira contagem para iniciar a segunda/terceira contagem!!!')
			cCodEtq   := Space(30)
			(cAliasZZS1)->(dbCloseArea())
			lRet:=.F.
			Return(lRet)		
		EndIf
				
		(cAliasZZS1)->(dbCloseArea())

	ElseIf Right(Alltrim(cCodEtq), 1) == 'C'

		cZZS_LEITU  := SubStr(cZZS_CODETQ,1,8)+"B"

		cQuery := " SELECT ZZS.ZZS_CODPRO, ZZS.ZZS_CODETQ, ZZS.ZZS_LOTE, ZZS.ZZS_ENCERR "
		cQuery += "  FROM " + RetSqlName("ZZS") + " ZZS  "
		cQuery += "  WHERE ZZS.ZZS_FILIAL  = '" + xFilial("ZZS") + "' AND "
		cQuery += "        ZZS.D_E_L_E_T_  = ' ' AND " 
		cQuery += "        ZZS.ZZS_CODPRO  = '" + cZZS_CODPRO + "' AND "
		cQuery += "        ZZS.ZZS_LOTE    = '" + cZZS_LOTE   + "' AND "
		cQuery += "        ZZS.ZZS_CODETQ  = '" + cZZS_LEITU  + "' AND "
		cQuery += "        ZZS.ZZS_LOCAL   = '" + cCodLocal   + "' "

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZZS2,.T.,.T.) 
		dbSelectArea(cAliasZZS2)

		If (cAliasZZS2)->ZZS_ENCERR == 'S'
				Alert('Etiqueta encerrada!')
				cCodEtq   := Space(30)
				(cAliasZZS2)->(dbCloseArea())
				lRet:=.F.
				Return(lRet)										
		ElseIf (cAliasZZS2)->(Eof())
			Alert('Não foi feita a leitura a segunda contagem, faça a segunda contagem para iniciar a terceira contagem!!!')
			cCodEtq   := Space(30)
			(cAliasZZS2)->(dbCloseArea())
			lRet:=.F.
			Return(lRet)		
		EndIf
				
		(cAliasZZS2)->(dbCloseArea())
		
	EndIf

EndIf

cQuery := " SELECT ZZS.ZZS_CODPRO, ZZS.ZZS_CODETQ, ZZS.ZZS_LOTE "
cQuery += "  FROM " + RetSqlName("ZZS") + " ZZS  "
cQuery += "  WHERE ZZS.ZZS_FILIAL  = '" + xFilial("ZZS") + "' AND "
cQuery += "        ZZS.D_E_L_E_T_  = ' ' AND " 
cQuery += "        ZZS.ZZS_CODPRO  = '" + cZZS_CODPRO + "' AND "
cQuery += "        ZZS.ZZS_LOTE    = '" + cZZS_LOTE   + "' AND "
cQuery += "        ZZS.ZZS_CODETQ  = '" + cZZS_CODETQ + "' AND "
cQuery += "        ZZS.ZZS_LOCAL   = '" + cCodLocal + "' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZZS,.T.,.T.) 
dbSelectArea(cAliasZZS)

If (cAliasZZS)->(!Eof())

	Alert('Etiqueta já lida!!!')
	cCodEtq   := Space(30)
	lRet:=.F.

EndIf
                  
(cAliasZZS)->(dbCloseArea())
	
Return(lRet) 


//////////////////////////////////^///////////////
Static Function FS_XQtd()
	Local lRet:=.T.
	oTButton1:SetFocus()       
Return(lRet) 

               
 
//Pesquisa do CodPro/Lote/CodEtq
Static Function UPESQ(cEtq,cPosic)
	// cEtq  := "123456 AAMMSQA"
	// ARRAY 1 = 123456789012345     cod produto
	// ARRAY 2 = 1234567890          lote
	// ARRAY 3 = AAMMSQ (A/B ou C)   SEQ      (ONDE A-PRIMEIRA CONTAGEM, B-SEGUNDA, C-TERCEIRA
	Local cRet  := ""
    Local aRet  := {}
	Local cPesq := " "
	aRet:=StrTokArr(cEtq,cPesq)

	If Len(AllTrim(cEtq)) > 19
		If !Empty(cEtq)
			If cPosic == '1'
				cRet := aRet[1]
			ElseIf cPosic == '2'
				cRet := aRet[2]
			ElseIf cPosic == '3'
				cRet := aRet[3]
			ElseIf cPosic == '4'
			 	cRet := Right(Alltrim(cEtq), 8) 
			Else
				cRet := ""
			EndIf
		EndIf	
	Else
		If !Empty(cEtq)
			If cPosic == '1'
				cRet := aRet[1]
			ElseIf cPosic == '2'
				cRet := aRet[2]
			ElseIf cPosic == '3'
			 	cRet := ""
			ElseIf cPosic == '4'
				cRet := aRet[3]
			Else
				cRet := ""
			EndIf
		EndIf	
	EndIf	

Return(cRet)

