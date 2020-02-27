#include "totvs.ch" 
#Include "Protheus.ch"
#Include "TopConn.ch" 
#Include "RwMake.ch"

User Function RESTCOTA()
 
Local cUrlBase := "https://cotacaoweb.midoriautoleather.com.br/rest.php?class=CotacaoRest&method=getMethod"
Local oJson
Local cJson := ""
Local cQry := ""
 
Local aTables := {"SB1","SBM"}
Local _cEmp   := "01"
Local _cFil   := "01"
Local lExec   := .T.
Local cResult := ""
                             
Local cFunName   := Alltrim(ProcName())
Local cArqLckNfe := "\logLCKNfe\"
Local cArqLock   := " " 

Local _cUpd     := ""
Local _nQtde    := 0
Local nAtu      := 0 

local nERR
Local nAENV
Local nEMAIL

Private	lModoTst  := .F.
Private cFrom     := ""
Private cTo       := ""
Private cCc       := ""
Private cBcc      := ""
Private cSubject  := ""
Private nEnvOk    := 0

Private _DTRECEMAIL := '20491231' //Data para acompanhamento de e-mail de envio de cotação
Private _DTRECEMAI2 := '20181221' //Data para acompanhamento de e-mail de envio de cotação
//Private cEmailCopy  := IIf( DtoS(Date()) <= _DTRECEMAIL ,"andre@adeoconsultor.com.br;marcos.oliveira@midoriautoleather.com.br;","")
Private cEmailCopy  := IIf( DtoS(Date()) <= _DTRECEMAIL ,"marcos.oliveira@midoriautoleather.com.br;","")

cEmailCopy  += IIf( DtoS(Date()) <= _DTRECEMAI2 ,"andre@sigasp.com;","")

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
             
	lExec := .T. 
	_nQtde := 0
	Sleep(1000)
	cQry := " SELECT * FROM "+RetSQLName("ZZ3")+" WHERE ZZ3_SITWEB = ''  AND D_E_L_E_T_ = '' ORDER BY ZZ3_CCOTA DESC "  
	//cQry := " SELECT * FROM "+RetSQLName("ZZ3")+" WHERE D_E_L_E_T_ = '' ORDER BY ZZ3_CCOTA DESC "  
	TCQUERY cQry ALIAS "TBX" NEW
	
	DbSelectArea("TBX")
	TBX->(DbGoTop())
	TBX->( dBEval({|| _nQtde++}) )  
	TBX->(DbGoTop())
	
	If _nQtde <= 0 
		CONOUT("SEM DADOS...")
	Else  
	   
		_cCHVWEB := ""
		_cxupd := ""
		While !TBX->(EOf()) .And. lExec    
		    If Empty(TBX->ZZ3_CHVWOK)
				If (_cCHVWEB <> TBX->ZZ3_CCOTA+TBX->ZZ3_FCOD+TBX->ZZ3_FLOJA)
					_cCHVWEB := TBX->ZZ3_CCOTA+TBX->ZZ3_FCOD+TBX->ZZ3_FLOJA			
					_XCHVWEB := XGETNUM()
				EndIf
	
				_cUpd := " "
				_cUpd := " UPDATE "+RetSqlName("ZZ3")+" SET ZZ3_CHVWEB = '"+ _XCHVWEB +"', ZZ3_CHVWOK = 'S' WHERE  R_E_C_N_O_ = '"+ Alltrim(sTR(TBX->R_E_C_N_O_)) +"' " 
				_cxupd += CRLF+_cUpd
				TcSqlExec(_cUpd)  
			EndIf              			
			TBX->(DbSkip())		
		EndDo	
			    
    EndIf
    TBX->(DbCloseArea())
    //Return()   

	CONOUT("INICIANDO ROTINA (RESTCOTA)")
	oRestClient := FWRest():New(cUrlBase)
	
	aHeader := {}
	Aadd(aHeader, "Content-Type: application/json")

	_nQtde := 0	
	lExec := .t.
	Sleep(1000)
	cQry := " SELECT * FROM "+RetSQLName("ZZ3")+" WHERE ZZ3_SITWEB = ''  AND D_E_L_E_T_ = '' ORDER BY R_E_C_N_O_ DESC "
	TCQUERY cQry ALIAS "TBX" NEW
	
	DbSelectArea("TBX")
	TBX->(DbGoTop())
	TBX->( dBEval({|| _nQtde++}) )  
	TBX->(DbGoTop())
	
	If _nQtde <= 0 
		CONOUT("SEM DADOS...")
	Else  
		
		While !TBX->(EOf()) .And. lExec
			       
			DbSelectArea("ZZ3")
			ZZ3->(DbGoTop())
			ZZ3->(DbSeek( TBX->(ZZ3_FILIAL+ZZ3_CHVWEB+ZZ3_FCOD+ZZ3_FLOJA+ZZ3_ITEM+ZZ3_PRD) ))
			  
			conout("Processando Recno: "+ Alltrim(Str(ZZ3->(Recno()))))
			  
			             
			_cOBSFOR := ALLTRIM(ZZ3->ZZ3_OBSFOR)

		    //Quebrando o Array, conforme -Enter-
		    aAux:= StrTokArr(_cOBSFOR,Chr(13))
		     
		    //Correndo o Array e retirando o tabulamento
		    For nAtu:=1 TO Len(aAux)
		        aAux[nAtu]:=StrTran(aAux[nAtu],Chr(10),'')
		    Next			
			
			_cOBSFOR := ""
		    //Correndo o Array e retirando o tabulamento
		    For nAtu:=1 TO Len(aAux)
		        _cOBSFOR += ALLTRIM( aAux[nAtu] )+"  "
		    Next  
		    
		    // 
		    //Aoliveira - 2018-09-13
		    //Implentação para incluir o endereço de entrega com base na Loja de entrega do orçamento
		    //solicitanto Marcos|Suprimento
		    //
		    _aAreaSM0 := SM0->(GetArea())  //Salvar Area da SM0
		    
		    DbSelectArea("SC8")
		    SC8->(DbSetOrder(1))
		    SC8->(DbGoTo(Val(TBX->ZZ3_RECNO))) 
		    
			SM0->(dbSetOrder(1))
			SM0->(dbSeek(cEmpAnt+AllTrim(SC8->C8_FILENT)))		    			
			
			_cLOCENT := Alltrim(SM0->M0_CODFIL)+ " - " + Alltrim(SM0->M0_FILIAL)
			_cLocEnd := Alltrim(SM0->M0_ENDENT)+ " - " 
			_cLocEnd += Alltrim(SM0->M0_CIDENT)+ " " 
			_cLocEnd += "CEP: "+ Transform(Alltrim(SM0->M0_CEPENT),"@R 99999-999")+" - "+  Alltrim(SM0->M0_ESTENT)
			_cLocCGC := Transform( Alltrim( SM0->M0_CGC ), alltrim("@R 99.999.999/9999-99"))
			
			RestArea(_aAreaSM0)  //Restaurar Area SM0
			//
			//
			
			cJson := ''
			cJson += ' { '
			cJson += ' "CHAVE_ID_WEB": "'+ Alltrim(TBX->ZZ3_CHVWEB) +'", '
			cJson += ' "RECNOERP": "'+ Alltrim(TBX->ZZ3_RECNO) +'", '
			cJson += ' "COMPRADOR_COD": "'+ Alltrim(TBX->ZZ3_COMCOD) +'", '
			cJson += ' "COMPRADOR_NOME": "'+ Alltrim(TBX->ZZ3_CNOME) +'", '
			cJson += ' "COMPRADOR_EMAIL": "'+ Alltrim(TBX->ZZ3_CEMAIL) +'", '
			cJson += ' "COMPRADOR_TEL": "'+ Alltrim(TBX->ZZ3_CTEL) +'", '
			cJson += ' "COMPRADOR_COTACAO": "'+ Alltrim(TBX->ZZ3_CCOTA) +'", '
			cJson += ' "COMPRADOR_VENCIMENTO": "'+Alltrim(Year2Str(StoD(TBX->ZZ3_CVECTO))+"-"+Month2Str(StoD(TBX->ZZ3_CVECTO))+"-"+Day2Str(StoD(TBX->ZZ3_CVECTO)))+'", '
			cJson += ' "COMPRADOR_PROPOSTA": "'+ Alltrim(TBX->ZZ3_CPROPO) +'", '
			cJson += ' "FORNECEDOR_COD": "'+ Alltrim(TBX->ZZ3_FCOD +' - '+ ZZ3->ZZ3_FLOJA) +'", '
			cJson += ' "FORNECEDOR_NOME": "'+ Alltrim(TBX->ZZ3_FNOME) +'", '
			cJson += ' "FORNECEDOR_CONTATO": "'+ Alltrim(TBX->ZZ3_FCONT) +'", '
			cJson += ' "FORNECEDOR_EMAIL": "'+ Alltrim(TBX->ZZ3_FEMAIL) +'", '
			cJson += ' "FORNECEDOR_END": "'+ Alltrim(TBX->ZZ3_FEND) +' ", '
			cJson += ' "FORNECEDOR_TEL": "'+ Alltrim(TBX->ZZ3_FTEL) +'", '
			cJson += ' "FORNECEDOR_OBS": "'+ Alltrim(_cOBSFOR) +'", '
			cJson += ' "PRODUTO_ITEM": "'+ Alltrim(TBX->ZZ3_ITEM) +'", '
			cJson += ' "PRODUTO_CODIGO": "'+ Alltrim(TBX->ZZ3_PRD) +'", '
			cJson += ' "PRODUTO_DESCRICAO": "'+ Alltrim(TBX->ZZ3_PRDDES) +'", '
			cJson += ' "PRODUTO_QTDE": "'+ Alltrim(Transform( TBX->ZZ3_PRDQDE ,"@E 999999999.99"))  +'", '
			cJson += ' "PRODUTO_UN": "'+ Alltrim(TBX->ZZ3_PRDUN) +'", '
			cJson += ' "PRODUTO_DTENTREGA01": "'+Alltrim(Year2Str(StoD(TBX->ZZ3_DTENT1))+"-"+Month2Str(StoD(TBX->ZZ3_DTENT1))+"-"+Day2Str(StoD(TBX->ZZ3_DTENT1)))+'", '
			cJson += ' "OUTRAS_LOCALENTREGA": "'+ _cLOCENT +'", '   // Verificar
			cJson += ' "OUTRAS_ENDENTREGA": "'+ _cLocEnd +'", '      // Verificar
			cJson += ' "OUTRAS_CONTATO": "'+ _cLocCGC +'" '        // Verificar
			cJson += ' }   '   
			
			//cUrlBase := "http://cotacaoweb.midoriautoleather.com.br"
			cUrlBase := "https://www.midoriautoleather.com.br/cotacao"
			aHeader := {"Content-Type: application/json"} 
	 
			oRestClient:setPath("/rest.php?class=CotacaoRest&method=getMethod")
										//rest.php?class=CotacaoRest&method=getMethod 
			oRestClient:cHost := cUrlBase
			oRestClient:SetPostParams(EncodeUtf8(cJson))
			Sleep( 500 )
			If oRestClient:Post(aHeader)  
					
				cResult := oRestClient:CRESULT

			    lCont:= .t.
			    lCont2:= .t.
                lObjRest := .F.        
                nCont := 0
                
				While lCont .and. nCont <= 10
					nCont ++
					lCont2:= FWJsonDeserialize(oRestClient:cResult, @oJson)
				    If lCont2  
				    	lCont := .F.
				    	lObjRest := .T.
				    EndIf
				    Sleep( 500 )
				EndDo

				lObjRest := IIf(oJson:DATA[1] == NIL,.F., lObjRest) 

				If lObjRest
				
					cMSGJson := oJson:DATA[1][1]:MSG	
					
					
					If (Alltrim(cMSGJson) $ 'UPDATE_OK|INSERT_OK')
	                    
						_cUpd := " UPDATE "+RetSqlName("ZZ3")+" SET ZZ3_SITWEB = 'G' WHERE  R_E_C_N_O_ = '"+ Alltrim(Str(TBX->R_E_C_N_O_)) +"' "
						TcSqlExec(_cUpd)	
	
						/*
						DbSelectArea("ZZ3")
						ZZ3->(DbSetOrder(1)) //ZZ3_FILIAL+ZZ3_CHVWEB                                    
						ZZ3->(DbGoTop())
						If ZZ3->(DbSeek( TBX->ZZ3_FILIAL+TBX->ZZ3_CHVWEB+TBX->ZZ3_FCOD+TBX->ZZ3_FLOJA+TBX->ZZ3_ITEM+TBX->ZZ3_PRD )) //ZZ3_FILIAL+ZZ3_CHVWEB+ZZ3_FCOD+ZZ3_FLOJA+ZZ3_ITEM+ZZ3_PRD
							//If ZZ3->( DbGoTo( Val(TBX->ZZ3_RECNO) ) )             
							//ZZ3->( DbGoTo( Val(TBX->ZZ3_RECNO) ) )                  
		                    
							If _cSeekKey <> Alltrim(TBX->ZZ3_CHVWEB) 
								
								_cSeekKey := Alltrim(TBX->ZZ3_CHVWEB)
								
								_cUpd := " UPDATE "+RetSqlName("ZZ3")+" SET ZZ3_SITWEB = 'G' WHERE  R_E_C_N_O_ = '"+ Alltrim(Str(ZZ3->(Recno()))) +"' "
							 	TcSqlExec(_cUpd)
								
								//Return()

							EndIf
						EndIf					
					    */
					
					
					Else
						Conout("Retorno de ERRO do REST")
						DbSelectArea("ZZ3")
						ZZ3->(DbSetOrder(1)) //ZZ3_FILIAL+ZZ3_CHVWEB                                    
						ZZ3->(DbGoTop())
						If ZZ3->(DbSeek( TBX->ZZ3_FILIAL+TBX->ZZ3_CHVWEB+TBX->ZZ3_FCOD+TBX->ZZ3_FLOJA+TBX->ZZ3_ITEM+TBX->ZZ3_PRD )) //ZZ3_FILIAL+ZZ3_CHVWEB+ZZ3_FCOD+ZZ3_FLOJA+ZZ3_ITEM+ZZ3_PRD				
		                         					
							_cUpd := " UPDATE "+RetSqlName("ZZ3")+" SET ZZ3_SITWEB = 'E' WHERE  R_E_C_N_O_ = '"+ Alltrim(Str(ZZ3->(Recno()))) +"' "
							TcSqlExec(_cUpd)
		
						EndIf							
					EndIf 
					
				Else
	
					ConOut( "ERRO NA LEITURA DO JSON")				
					
					_cUpd := " UPDATE "+RetSqlName("ZZ3")+" SET ZZ3_SITWEB = 'E' WHERE  R_E_C_N_O_ = '"+ Alltrim( Str(TBX->R_E_C_N_O_) ) +"' "
					TcSqlExec(_cUpd)	               
	               	 
	               
					/*
					DbSelectArea("ZZ3")
					ZZ3->(DbSetOrder(1)) //ZZ3_FILIAL+ZZ3_CHVWEB                                    
					ZZ3->(DbGoTop())
					If ZZ3->(DbSeek( TBX->ZZ3_FILIAL+TBX->ZZ3_CHVWEB+TBX->ZZ3_FCOD+TBX->ZZ3_FLOJA+TBX->ZZ3_ITEM+TBX->ZZ3_PRD )) //ZZ3_FILIAL+ZZ3_CHVWEB+ZZ3_FCOD+ZZ3_FLOJA+ZZ3_ITEM+ZZ3_PRD				
	                         					
						_cUpd := " UPDATE "+RetSqlName("ZZ3")+" SET ZZ3_SITWEB = 'E' WHERE  R_E_C_N_O_ = '"+ Alltrim(Str(ZZ3->(Recno()))) +"' "
						_cUpd := " UPDATE "+RetSqlName("ZZ3")+" SET ZZ3_SITWEB = 'E' WHERE  R_E_C_N_O_ = '"+ Alltrim(Str(ZZ3->(Recno()))) +"' "
						TcSqlExec(_cUpd)
	
					EndIf
	                */
				EndIf		
			
			Else
	   			ConOut("ERRO de POST"+CRLF+oRestClient:GetLastError())	
			EndIf
			
			TBX->(DbSkip())
			
		EndDo
		
	EndIf    
	TBX->(DbCloseArea())
	
	//
	//
	//   
	cQry := " "+CRLF	
	cQry += " SELECT ZZ3A.ZZ3_CHVWEB, "+CRLF	
	cQry += "        (SELECT COUNT(*) FROM "+RetSQLName("ZZ3")+" ZZ3B WHERE ZZ3B.ZZ3_SITWEB = '' AND  ZZ3B.ZZ3_CHVWEB = ZZ3A.ZZ3_CHVWEB AND ZZ3B.D_E_L_E_T_ = '') AS AENV, "+CRLF	
	cQry += "        (SELECT COUNT(*) FROM "+RetSQLName("ZZ3")+" ZZ3C WHERE ZZ3C.ZZ3_SITWEB = 'G' AND  ZZ3C.ZZ3_CHVWEB = ZZ3A.ZZ3_CHVWEB AND ZZ3C.D_E_L_E_T_ = '') AS ENV, "+CRLF	
	cQry += "        (SELECT COUNT(*) FROM "+RetSQLName("ZZ3")+" ZZ3D WHERE ZZ3D.ZZ3_SITWEB = 'E' AND  ZZ3D.ZZ3_CHVWEB = ZZ3A.ZZ3_CHVWEB AND ZZ3D.D_E_L_E_T_ = '') AS ERR, "+CRLF	
	cQry += "        (SELECT COUNT(*) FROM "+RetSQLName("ZZ3")+" ZZ3E WHERE ZZ3E.ZZ3_CHVWEB = ZZ3A.ZZ3_CHVWEB AND ZZ3E.D_E_L_E_T_ = '') AS TOL, "+CRLF	
	cQry += "        (SELECT COUNT(*) FROM "+RetSQLName("ZZ3")+" ZZ3F WHERE ZZ3F.ZZ3_CHVWEB = ZZ3A.ZZ3_CHVWEB AND ZZ3F.ZZ3_ENVMAI <> '' AND ZZ3F.D_E_L_E_T_ = '') AS EMAIL "+CRLF	
	cQry += " FROM "+RetSQLName("ZZ3")+" ZZ3A WHERE ZZ3A.ZZ3_SITWEB IN ('G') AND ZZ3A.D_E_L_E_T_ = '' GROUP BY ZZ3A.ZZ3_CHVWEB	 "+CRLF	
	
	
	TCQUERY cQry ALIAS "TBY" NEW
	
	DbSelectArea("TBY")
	TBY->(DbGoTop())	
    While !TBY->(Eof())
		nAENV  := TBY->AENV  //A Enviar
		nENV   := TBY->ENV   //Enviados
		nTOL   := TBY->TOL   //Total
		nERR   := TBY->ERR   //Com Erro
		nEMAIL := TBY->EMAIL //Com Erro
		
		If (nTOL == nENV )
			
			cQry := " SELECT TOP 1 * FROM "+RetSqlName("ZZ3")+" WHERE ZZ3_CHVWEB = '"+ Alltrim(TBY->ZZ3_CHVWEB) +"' "
			TCQUERY cQry ALIAS "TBW" NEW
			DbSelectArea("TBW")
			TBW->(DbGoTop())		
		              
			lModoTst  := .F.
			cFrom     := "andre@sigasp.com"
			//cTo     := "marcos.oliveira@midoriautoleather.com.br;andre@adeoconsultor.com.br" //;marcos.oliveira@midoriautoleather.com.br;willer.trindade@midoriautoleather.com.br"
			//cTo       := "andre@adeoconsultor.com.br"
			cTo       := Alltrim(TBW->ZZ3_FEMAIL)+";"+ Alltrim(cEmailCopy) // "andre@adeoconsultor.com.br;marcos.oliveira@midoriautoleather.com.br;" //+Alltrim(TBX->ZZ3_CEMAIL) //;willer.trindade@midoriautoleather.com.br"
			cCc       := ""
			cBcc      := ""
			cSubject  := "[Midori] -- Cotacao de Preco "		
		
			nEnvOk :=	VSS_ENVMAIL(cTo, cSubject,  Alltrim(TBW->ZZ3_CCOTA), Alltrim(TBW->ZZ3_CNOME), Alltrim(TBW->ZZ3_CTEL),Alltrim(TBW->ZZ3_CEMAIL), Alltrim(TBW->ZZ3_CHVWEB) )
			If nEnvOk == 0
				
				_cUpd := " UPDATE "+RetSqlName("ZZ3")+" SET ZZ3_SITWEB = 'A' , ZZ3_ENVMAI = 'S' , ZZ3_DTENV = '"+DtoS(dDataBase)+"' "
				_cUpd += " WHERE  ZZ3_CHVWEB = '"+ Alltrim(TBW->ZZ3_CHVWEB) +"' "
				TcSqlExec(_cUpd)

			Else
				Conout("ERRO AO ENVIAR EMAIL")
			EndIf 	
	         
	        TBW->(DbCloseArea())                  
	
	    EndIf
    	TBY->(DbSkip())
	EndDo
	//
	TBY->(DbCloseArea())
	
	CONOUT("TERMINANDO ROTINA (RESTCOTA)")
	
EndIf

//Cancela o Lock de gravacao da rotina
FClose(nHdlLock)
FErase(cArqLock)
    
Return()    


/*
* VSS_ENVMAIL
*
*@versao: 1.0
*@autor : AOliveira
*@Data  : 2018-02-06
*@Descr.: Inicia WF de envio de e-mail
*/     
Static Function VSS_ENVMAIL(_cTo, _cSubject, _xcCCOTA,_xcCNOME,_xcCTEL,_xcCEMAIL, _xcKey)
 
Local nRet := 0
Local oHtml
Local oProcess
Local cProcess

Default _xcCCOTA  := ""
Default _xcCNOME  := ""
Default _xcCTEL   := ""
Default _xcCEMAIL := ""
Default _xcKey    := "" 


SETMV("MV_WFMLBOX","WORKFLOW")
cProcess := OemToAnsi("001001")
cStatus  := OemToAnsi("RESTCOTA")
//_cProc  := OemToAnsi(cProc)

oProcess:= TWFProcess():New( '001001', _xcKey )
oProcess:NewTask( cStatus, "\WORKFLOW\HTM\COTPRC.htm" )
oHtml    := oProcess:oHTML

oHtml:ValByName("cccota"	, Alltrim(_xcCCOTA) )
oHtml:ValByName("ccnome"	, Alltrim(_xcCNOME) )
oHtml:ValByName("cctel"	    , Alltrim(_xcCTEL) )
oHtml:ValByName("ccemail"	, Alltrim(_xcCEMAIL) )
oHtml:ValByName("ckey"	    , Alltrim(_xcKey) )
oProcess:cSubject := _cSubject

oProcess:cTo      := _cTo

oProcess:Start()
oProcess:Finish()
Return(nRet)




/*---------------------------------------------------------
Funcao: XGETNUM()  |Autor: AOliveira    |Data: 18/04/2018
-----------------------------------------------------------
Descr.: Rotina tem como objetivo retornar numeração unica
para controle do campo ( ZZ3_CHVWEB )
-----------------------------------------------------------
Uso:    RESTCOTA
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