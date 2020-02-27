#include "totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "RwMake.ch"

User Function ATUCOTA()

Local aTables := {"SB1","SBM"}
Local _cEmp   := "01"
Local _cFil   := "01"
Local lExec   := .T.
Local cResult := ""

Local cFunName   := Alltrim(ProcName())
Local cArqLckNfe := "\logLCKNfe\"
Local cArqLock   := " "

Local cUrlBase := "https://www.midoriautoleather.com.br/cotacao/rest.php?class=CotacaoRest&method=getMethod" ///"http://cotacaoweb.midoriautoleather.com.br/rest.php?class=CotacaoRest&method=getMethod"  /////http://www.midoriautoleather.com.br/cotacao
Local oJson
Local cQry := ""

Local cSITUAWEB := ""
 
Local nX

Local _DTRECEMAIL := '20491231' //Data para acompanhamento de e-mail de envio de cotação
Local _DTRECEMAI2 := '20181221' //Data para acompanhamento de e-mail de envio de cotação
//Private cEmailCopy := IIf( DtoS(Date()) <= _DTRECEMAIL ,"andre@adeoconsultor.com.br;marcos.oliveira@midoriautoleather.com.br;","")
Private cEmailCopy := IIf( DtoS(Date()) <= _DTRECEMAIL ,"marcos.oliveira@midoriautoleather.com.br;","")                             

cResult := ""
cUrlBase := "https://www.midoriautoleather.com.br/cotacao/rest.php?class=CotacaoRest&method=getMethod" 
cSITUAWEB := ""
nX := 0
oJson := NIL

cEmailCopy := IIf( DtoS(Date()) <= _DTRECEMAI2 ,"andre@sigasp.com;","")

MakeDir(cArqLckNfe)

cArqLock := Alltrim(cFunName + ".lck" )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Efetua o Lock de gravacao da Rotina - Monousuario            ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FErase(cArqLock)
nHdlLock := MsFCreate(cArqLock)
IF nHdlLock < 0
	Conout("")
	Conout("**  Rotina "+ cFunName +" em uso...")
	Conout("")
	Return(.T.)
EndIF

//Preparando Ambiente
//RpcSetType(3)
lRetEnv := RpcSetEnv( _cEmp, _cFil, ,, 'COM', , aTables,  ,.f. , , )

If lRetEnv
	CONOUT("INICIANDO ROTINA (RESTCOTA)")
	                    	  
	cQry := " SELECT ZZ3_CHVWEB FROM "+RetSQLName("ZZ3")+" WHERE ZZ3_SITWEB = 'A'  AND D_E_L_E_T_ = '' GROUP BY ZZ3_CHVWEB "
	//cQry := " SELECT * FROM ZZ3010 WHERE ZZ3_CCOTA = '042830' "
	TCQUERY cQry ALIAS "TB1" NEW
	
	lExec := .t.
	DbSelectArea("TB1")
	TB1->(DbGoTop())
	While !TB1->(EOf()) .And. lExec
	    //CONOUT("PROCESSANDO REGISTRO ( "+ Alltrim(TB1->ZZ3_CHVWEB) +" )")
	    
	    StartJob("u_xPROCREG",GetEnvServer(),.T.,TB1->ZZ3_CHVWEB)                 
	     
		TB1->(DbSkip())
	EndDo	
	
	TB2->(DbCloseArea())	
	CONOUT("TERMINANDO ROTINA (RESTCOTA)")
EndIf	

//Cancela o Lock de gravacao da rotina
FClose(nHdlLock)
FErase(cArqLock)

Return()    

/**
*
*/
User Function xPROCREG(_cCHVWEB)

Local lRet  

Local aTables := {}
Local _cEmp   := "01"
Local _cFil   := "01"
Local lExec   := .T.
Local cResult := ""

Local cFunName   := Alltrim(ProcName())
Local cArqLckNfe := "\logLCKNfe\"
Local cArqLock   := " "

Local cUrlBase := "https://www.midoriautoleather.com.br/cotacao/rest.php?class=CotacaoRest&method=getMethod" //"http://cotacaoweb.midoriautoleather.com.br/rest.php?class=CotacaoRest&method=getMethod"
Local oJson
Local cQry := ""

Local cSITUAWEB := ""
 
Local nX

Local _DTRECEMAIL := '20491231' //Data para acompanhamento de e-mail de envio de cotação
Local _DTRECEMAI2 := '20181227' //Data para acompanhamento de e-mail de envio de cotação
//Private cEmailCopy := IIf( DtoS(Date()) <= _DTRECEMAIL ,"andre@adeoconsultor.com.br;marcos.oliveira@midoriautoleather.com.br;","")
Private cEmailCopy := IIf( DtoS(Date()) <= _DTRECEMAIL ,"marcos.oliveira@midoriautoleather.com.br;","")                             
            
Private lContE := .T.

cEmailCopy := IIf( DtoS(Date()) <= _DTRECEMAI2 ,"andre@sigasp.com;","")

Default _cCHVWEB := ""

cFunName   := Alltrim(ProcName())

MakeDir(cArqLckNfe)
cArqLock := Alltrim(cArqLckNfe+"xPROCREG_"+Alltrim(_cCHVWEB)+".lck" )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua o Lock de gravacao da Rotina - Monousuario            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FErase(cArqLock)
nHdlLock := MsFCreate(cArqLock)
IF nHdlLock < 0
	Conout("")
	Conout("**  Registro ( "+_cCHVWEB+" ), ja esta sendo processado...")
	Conout("")
	Return(.T.)
EndIF

//-->Preparando Ambiente na Filial
//RpcSetType(3)
lRetEnv := RpcSetEnv( _cEmp, _cFil, ,, 'COM', , aTables,  ,.f. , , )

If lRetEnv
	CONOUT("PROCESSANDO REGISTRO ( "+ Alltrim(_cCHVWEB) +" )")
		
	aHeader := {}
	Aadd(aHeader, "Content-Type: application/json")
	
	cQry := " SELECT * FROM "+RetSQLName("ZZ3")+" WHERE ZZ3_SITWEB = 'A'  AND D_E_L_E_T_ = '' AND ZZ3_CHVWEB = '"+ Alltrim(_cCHVWEB) +"' "
	//cQry := " SELECT * FROM ZZ3010 WHERE ZZ3_CCOTA = '042830' "
	TCQUERY cQry ALIAS "TB1" NEW
	
	DbSelectArea("TB1")
	TB1->(DbGoTop())
	While !TB1->(EOf()) .And. lExec
		    
		CONOUT("PROCESSANDO RECNO ( "+ Alltrim(STR(TB1->R_E_C_N_O_)) +" )")
        
		/*Finalizar o registro caso já tenha enviado um email (ZZ3_ENVMAI == 'S')*/
		lJaEmail := .F.
		DbSelectArea("ZZ3")
		ZZ3->(DbSetOrder(1)) //ZZ3_FILIAL+ZZ3_CHVWEB
		ZZ3->(DbGoTo(TB1->R_E_C_N_O_))
		If (Alltrim(ZZ3->ZZ3_ENVMAI) == 'X')                                                                           
			RecLock("ZZ3",.f.)
			ZZ3->ZZ3_SITWEB  := 'F' // Conclui a recepção do registro
			ZZ3->ZZ3_OBS     := CRLF + Alltrim(ZZ3->ZZ3_OBS)+CRLF+"JA HOUVE ENVIO DE E-MAIL ANTERIORMENTE."
			ZZ3->(MsUnlock())
			ConOut("JA HOUVE ENVIO DE E-MAIL ANTERIORMENTE")
			lJaEmail := .T.
		EndIf   		                                   
		
		If !(lJaEmail)
			//
			DbSelectArea("ZZ3")
			ZZ3->(DbSetOrder(1)) //ZZ3_FILIAL+ZZ3_CHVWEB
			ZZ3->(DbGoTo(TB1->R_E_C_N_O_))
			If (ZZ3->ZZ3_CVECTO < dDataBase  )                                                                           
				RecLock("ZZ3",.f.)
				ZZ3->ZZ3_SITWEB  := 'F' // Conclui a recepção do registro
				ZZ3->ZZ3_OBS     := Alltrim(ZZ3->ZZ3_OBS)+CRLF+"REGISTRO COM DATA DE VECTO EXPIRADA, NAO SERA PROCESSADO."
				ZZ3->(MsUnlock())
				ConOut("REGISTRO COM DATA DE VECTO EXPIRADA")
			EndIf   
	    
			oRestClient := Nil
			oRestClient := FWRest():New(cUrlBase)
			//cUrlBase := "https://www.midoriautoleather.com.br/cotacao/rest.php?class=CotacaoRest&method=getMethod&key="+Alltrim(TB1->ZZ3_CHVWEB)
			cUrlBase := "https://www.midoriautoleather.com.br"
			aHeader := {"Content-Type: application/json"}
			oRestClient:setPath("/cotacao/rest.php?class=CotacaoRest&method=getMethod&key="+Alltrim(TB1->ZZ3_CHVWEB))
			oRestClient:cHost := cUrlBase
			If oRestClient:Get(aHeader)
				
				Sleep( 500 )
				
				cResult := oRestClient:CRESULT
				
				If AT( "registro nao encontrado" , cResult) == 0
				        
				   	loJson := .F.
					_nLoop := 0    
					oJson := NIL  
					While !loJson   .And. _nLoop <= 10
						_nLoop ++
						If FWJsonDeserialize(oRestClient:cResult, @oJson)
							loJson := .T.
						EndIf 
						Sleep( 100 )
					EndDo
					
					//If FWJsonDeserialize(oRestClient:cResult, @oJson)
					If loJson //FWJsonDeserialize(oRestClient:cResult, @oJson)
						
						If .t. //( XmlChildEx ( oJson:DATA[1], "COTACAORECORD" ) != Nil )
							
							If !(Valtype(oJson:DATA[1]:COTACAORECORD) == "A")
								XmlNode2Arr( oJson:DATA[1]:COTACAORECORD, "COTACAORECORD" )
							EndIf
							
							For nX := 1 To Len( oJson:DATA[1]:COTACAORECORD )
								
								cSITUAWEB := Iif(Empty(oJson:DATA[1]:COTACAORECORD[nX]:SITUAWEB)," " , Alltrim(oJson:DATA[1]:COTACAORECORD[nX]:SITUAWEB) )
								cRECNOERP := Iif(Empty(oJson:DATA[1]:COTACAORECORD[nX]:RECNOERP)," " , Alltrim(oJson:DATA[1]:COTACAORECORD[nX]:RECNOERP) )
	    
								cRECNOZZ3 := "" 
								  							
								If (cSITUAWEB == "A")
									
									cQry1 := " SELECT * FROM "+RetSQLName("ZZ3")+" WHERE ZZ3_RECNO = '"+ cRECNOERP +"' "
									TCQUERY cQry1 ALIAS "TB3" NEW
									DbSelectArea("TB3")
									TB3->(DbGoTop())								
									
									cRECNOZZ3 := TB3->R_E_C_N_O_ 
									
									TB3->(DbCloseArea())

									DbSelectArea("ZZ3")
									ZZ3->(DbSetOrder(1)) //ZZ3_FILIAL+ZZ3_CHVWEB
									ZZ3->(DbGoTo(cRECNOZZ3))
									//ZZ3->(DbGoTop())
									//If ZZ3->(DbSeek( TB1->ZZ3_FILIAL+TB1->ZZ3_CHVWEB+TB1->ZZ3_FCOD+TB1->ZZ3_FLOJA+TB1->ZZ3_ITEM+TB1->ZZ3_PRD )) //ZZ3_FILIAL+ZZ3_CHVWEB+ZZ3_FCOD+ZZ3_FLOJA+ZZ3_ITEM+ZZ3_PRD
										
										//
										//Validando os campos do objeto
										_cPRC      := Iif(Empty(oJson:DATA[1]:COTACAORECORD[nX]:PRODUTO_PRECO),"0", oJson:DATA[1]:COTACAORECORD[nX]:PRODUTO_PRECO)
										_cDESC     := Iif(Empty(oJson:DATA[1]:COTACAORECORD[nX]:TOTAL_DESCONTO),"", oJson:DATA[1]:COTACAORECORD[nX]:TOTAL_DESCONTO)
										_cIPI      := Iif(Empty(oJson:DATA[1]:COTACAORECORD[nX]:PRODUTO_IPI),"0", oJson:DATA[1]:COTACAORECORD[nX]:PRODUTO_IPI)
										_cICMS     := Iif(Empty(oJson:DATA[1]:COTACAORECORD[nX]:PRODUTO_ICMS),"0", oJson:DATA[1]:COTACAORECORD[nX]:PRODUTO_ICMS)
										_cDTENT2   := Iif(Empty(oJson:DATA[1]:COTACAORECORD[nX]:PRODUTO_DTENTREGA02),"", oJson:DATA[1]:COTACAORECORD[nX]:PRODUTO_DTENTREGA02)
										_cFRETP    := Iif(Empty(oJson:DATA[1]:COTACAORECORD[nX]:TOTAL_FRETETIPO),"", oJson:DATA[1]:COTACAORECORD[nX]:TOTAL_FRETETIPO)
										_cFREVLR   := Iif(Empty(oJson:DATA[1]:COTACAORECORD[nX]:TOTAL_FRETEVALOR),"0", oJson:DATA[1]:COTACAORECORD[nX]:TOTAL_FRETEVALOR)
										_cMOEDA    := Iif(Empty(oJson:DATA[1]:COTACAORECORD[nX]:OUTRAS_MOEDA),"", oJson:DATA[1]:COTACAORECORD[nX]:OUTRAS_MOEDA)
										_cCONDPGTO := Iif(Empty(oJson:DATA[1]:COTACAORECORD[nX]:OUTRAS_CONDPGTO),"", oJson:DATA[1]:COTACAORECORD[nX]:OUTRAS_CONDPGTO)
										_cOBS      := Iif(Empty(oJson:DATA[1]:COTACAORECORD[nX]:OBS_OBSERVACAO),"", oJson:DATA[1]:COTACAORECORD[nX]:OBS_OBSERVACAO)
										//

										RecLock("ZZ3",.f.)
										
										_nPRDPRC := Round(Val(StrTran( _cPRC ,",",".")),6)
										_nDESCO  := Round(Val(StrTran( _cDESC ,",",".")),6)
										_nPRDTOT := Round((ZZ3->ZZ3_PRDQDE * _nPRDPRC),2)
										_nIPI    := Round(Val(StrTran( _cIPI ,",",".")),2)
										_nICMS   := Round(Val(StrTran( _cICMS ,",",".")),2)
										
										ZZ3->ZZ3_PRDPRC	 := _nPRDPRC     //C8_PRECO
										ZZ3->ZZ3_PRDTOT	 := _nPRDTOT     //C8_TOTAL
										ZZ3->ZZ3_IPI	 := _nIPI        //C8_ALIPI
										ZZ3->ZZ3_VLRIPI  := Round(((_nPRDTOT / 100)*_nIPI),2)
										ZZ3->ZZ3_ICMS    := _nICMS       //C8_PICM
										ZZ3->ZZ3_VLRICM	 := Round(((_nPRDTOT / 100)*_nICMS),2)
										ZZ3->ZZ3_DTENT2  := CtoD(_cDTENT2 )
										ZZ3->ZZ3_DESCO   := _nDESCO       //                                                                //oJson:DATA[1]:COTACAORECORD[1]:TOTAL_DESCONTO
										ZZ3->ZZ3_TPFRET	 := Alltrim(_cFRETP)
										ZZ3->ZZ3_VLRFRE	 := Round(Val(StrTran( _cFREVLR ,",",".")),6) //oJson:DATA[1]:COTACAORECORD[1]:TOTAL_FRETEVALOR
										ZZ3->ZZ3_MOEDA   := Alltrim(_cMOEDA)
										ZZ3->ZZ3_CONDPG  := Alltrim(_cCONDPGTO)
										ZZ3->ZZ3_OBS	 := Alltrim(_cOBS)
										 
										If (ZZ3->ZZ3_CVECTO < dDataBase  ) 
											// Fora da data de Vencimento
											ZZ3->ZZ3_SITWEB  := 'F' // Conclui a recepção do registro 
											ZZ3->ZZ3_OBS     := Alltrim(ZZ3->ZZ3_OBS)+CRLF+"REGISTRO COM DATA DE VECTO EXPIRADA, NAO SERA PROCESSADO."										
											ZZ3->(MsUnlock())  
											ConOut("GET"+CRLF+ "REGISTRO COM DATA DE VECTO EXPIRADA")									
										Else
											ZZ3->ZZ3_SITWEB  := 'C' // Conclui a recepção do registro										
											ZZ3->(MsUnlock())
										    XXMAT150(ZZ3->ZZ3_RECNO) //ATUALIZA A COTAÇÃO.									
										EndIf									

		                                ZZ3->(DbCloseArea())
									
									//EndIf
								Else
								   //	ConOut("ATUWEB", "AGUARDANDO ATUALIZACAO WEB ") Alltrim(TB1->ZZ3_CHVWEB)	
								EndIf
							Next nX
						EndIf
					Else
						ConOut("GET"+CRLF+ "ERRO NA LEITURA DO JSON")
					EndIf
				Else
					ConOut("GET"+CRLF+ "REGISTRO NAO ENCONTRADO NA WEB")
				EndIf			
			Else
				ConOut("GET"+CRLF+oRestClient:GetLastError())
			EndIf
			//
	  	EndIf
		TB1->(DbSkip())
	EndDo
	TB1->(DbCloseArea())
                
    //return()
                          
    //
    //Envio de e-mail de aviso de atualização de cotação.
    //
	lExec := .T.
	cQry  := " SELECT ZZ3_CHVWEB, COUNT(*) AS QTD FROM "+RetSQLName("ZZ3")+" WHERE ZZ3_SITWEB = 'D' GROUP BY ZZ3_CHVWEB "
	TCQUERY cQry ALIAS "TB2" NEW

	DbSelectArea("TB2")
	TB2->(DbGoTop())
	While !TB2->(EOf()) .And. lExec
		
		lEnvMail := .T.
		lAtuZZ3	 := .F.
		nCont := 0
		
		DbSelectArea("ZZ3")
		ZZ3->(DbSetOrder(1)) //ZZ3_FILIAL+ZZ3_CHVWEB
		ZZ3->(DbGoTop())
		//If ZZ3->(DbSeek( XFILIAL("ZZ3")+TB2->ZZ3_CHVWEB )) //ZZ3_FILIAL+ZZ3_CHVWEB+ZZ3_FCOD+ZZ3_FLOJA+ZZ3_ITEM+ZZ3_PRD
		ZZ3->(DbSeek( XFILIAL("ZZ3")+TB2->ZZ3_CHVWEB )) //ZZ3_FILIAL+ZZ3_CHVWEB+ZZ3_FCOD+ZZ3_FLOJA+ZZ3_ITEM+ZZ3_PRD
		While !Eof() .And.   ZZ3->ZZ3_FILIAL+ZZ3->ZZ3_CHVWEB == XFILIAL("ZZ3")+TB2->ZZ3_CHVWEB 
		   
			nCont ++             
			If Alltrim(Upper(ZZ3->ZZ3_ENVMAI)) == 'X'
				lEnvMail := .F.
				lAtuZZ3	:= .T.
			EndIf                                    
			
			If lAtuZZ3
				RecLock("ZZ3",.F.)
				ZZ3->ZZ3_ENVMAI  := 'X' 
				ZZ3->(MsUnlock())
			EndIf				
			
			ZZ3->(DbSkip())
			
        EndDo

        If lEnvMail .And. TB2->QTD == nCont

			DbSelectArea("ZZ3")
			ZZ3->(DbSetOrder(1)) //ZZ3_FILIAL+ZZ3_CHVWEB
			ZZ3->(DbGoTop())
			If ZZ3->(DbSeek( XFILIAL("ZZ3")+TB2->ZZ3_CHVWEB )) //ZZ3_FILIAL+ZZ3_CHVWEB+ZZ3_FCOD+ZZ3_FLOJA+ZZ3_ITEM+ZZ3_PRD
			
				//lContE := .T.
				//While !ZZ3->(Eof()) .And. (ZZ3->ZZ3_FILIAL+ZZ3->ZZ3_CHVWEB ==  XFILIAL("ZZ3")+TB2->ZZ3_CHVWEB)
				
				//	If lContE
				//Envio de e-mail de notificação da atualização
				_XCEMAIL := Alltrim(ZZ3->ZZ3_CEMAIL)+";"+Alltrim(cEmailCopy) //"andre@adeoconsultor.com.br;marcos.oliveira@midoriautoleather.com.br;" // "andre@sigasp.com;"+Alltrim(ZZ3->ZZ3_CEMAIL)
				//_XCEMAIL := "andre@adeoconsultor.com.br" // "andre@sigasp.com;"+Alltrim(ZZ3->ZZ3_CEMAIL)
				VSS_ENVMAIL(ZZ3->ZZ3_CCOTA, ZZ3->ZZ3_FNOME,_XCEMAIL)
				lContE := .F.
				//	    EndIf
				
				//RecLock("ZZ3",.F.)
				//ZZ3->ZZ3_SITWEB  := 'F' // Concluiu envio de e-mail.
				//ZZ3->(MsUnlock())
				//		ZZ3->(DbSkip()) 
				//cUPD := "UPDATE ZZ3010 SET ZZ3_SITWEB = 'F', ZZ3_ENVMAI = 'X'  WHERE ZZ3_SITWEB = 'D' AND ZZ3_CHVWEB = '"+aLLTRIM(TB2->ZZ3_CHVWEB)+"' "
				//TcSqlExec(cUPD)
	
				cUPD := "UPDATE ZZ3010 SET ZZ3_SITWEB = 'F', ZZ3_ENVMAI = 'X'  WHERE ZZ3_CHVWEB = '"+aLLTRIM(TB2->ZZ3_CHVWEB)+"' "
				TcSqlExec(cUPD)
							
				// EndDo
			EndIf
		EndIf               
		
		If !(lEnvMail) .And. TB2->QTD == nCont
			cUPD := "UPDATE ZZ3010 SET ZZ3_SITWEB = 'F', ZZ3_ENVMAI = 'X'  WHERE ZZ3_CHVWEB = '"+aLLTRIM(TB2->ZZ3_CHVWEB)+"' "
			TcSqlExec(cUPD)		
		EndIf
		
		TB2->(DbSkip())
		
	EndDo
	
	TB2->(DbCloseArea())

	
	CONOUT("TERMINANDO ROTINA (RESTCOTA)")

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cancela o Lock de gravacao da rotina                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FClose(nHdlLock)
FErase(cArqLock)

Return(lRet)


/*
* Funcao: XXMAT150
* Autor:  AOliveira
* Data:   10-07-2018
* Desc.:  Atualização de pre? via MATA150
*/
Static Function XXMAT150(_nxRec)
Local aArea := GetArea()
Local cChave := ""

Default _nxRec := 0
      

dbSelectArea("SC8")
SC8->(dbSetOrder(1)) //C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_ITEMGRD
SC8->(DbGoto( Val(_nxRec) ))
cChave := SC8->C8_FILIAL+SC8->C8_NUM+SC8->C8_FORNECE+SC8->C8_LOJA+SC8->C8_ITEM+SC8->C8_NUMPRO+SC8->C8_ITEMGRD

dbSelectArea("SC8")
SC8->(dbSetOrder(1)) //C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_ITEMGRD
If SC8->(dbSeek(cChave))
	
	DbSelectArea("SC8")
	RecLock("SC8",.f.)
	
	SC8->C8_PRECO  :=  ZZ3->ZZ3_PRDPRC
	SC8->C8_TOTAL  :=  ZZ3->ZZ3_PRDTOT
	SC8->C8_ALIIPI :=  ZZ3->ZZ3_IPI
	SC8->C8_PICM   :=  ZZ3->ZZ3_ICMS
	
	SC8->C8_BASEIPI := ZZ3->ZZ3_PRDTOT
	SC8->C8_BASEICM := ZZ3->ZZ3_PRDTOT
	SC8->C8_VALIPI  := ZZ3->ZZ3_VLRIPI
	SC8->C8_VALICM  := ZZ3->ZZ3_VLRICM
	
	SC8->(MsUnlock())
	
	DbSelectArea("ZZ3")
	RecLock("ZZ3",.f.)
	ZZ3->ZZ3_SITWEB  := 'D' // Concluiu a atualizacao do pre?
	ZZ3->(MsUnlock())
	
EndIf


RestArea(aArea)
Return()

/*
* VSS_ENVMAIL
*
*@versao: 1.0
*@autor : AOliveira
*@Data  : 2018-02-06
*@Descr.: Inicia WF de envio de e-mail
*/
Static Function VSS_ENVMAIL(_cAP, _cForn, _cEmlAP)

Local oHtml
Local oProcess
Local cProcess

SETMV("MV_WFMLBOX","WORKFLOW")
cProcess := OemToAnsi("001001")
cStatus  := OemToAnsi("001001")
//_cProc  := OemToAnsi(cProc)

oProcess:= TWFProcess():New( '001001', _cAP )
oProcess:NewTask( cStatus, "\WORKFLOW\HTM\VldPro.htm" )
oHtml    := oProcess:oHTML
oHtml:ValByName("Data"	    ,DTOC(DDATABASE))
oHtml:ValByName("AP"   		,_cAP)

aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
aAdd( oHtml:ValByName( "it.desc" ), "Cotacao: "+ Alltrim(_cAP) +" ")
aAdd( oHtml:ValByName( "it.desc" ), "Fornecedor: "+ Alltrim(_cForn) +" ")
aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
aAdd( oHtml:ValByName( "it.desc" ), "| COTACAO ATUALIZADA PELO FORNECEDOR                                                   |")
aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")

oProcess:cSubject := "COTACAO: "+_cAP+"   ( ATUALIZADA ) "

oProcess:cTo      := _cEmlAP

oProcess:Start()
oProcess:Finish()
Return()