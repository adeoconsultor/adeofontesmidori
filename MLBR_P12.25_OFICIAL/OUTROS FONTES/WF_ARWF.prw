#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "ap5mail.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ WF_ARWF  Autor ณ Willer Trindade  บ Data ณ  17/08/16       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa Schedule envia email responsaveis                 บฑฑ
ฑฑบ          ณ aviso recebimento nao homologados                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function WF_ARWF(_cEmpAtu,_cFilAtu) 
Local _aTabela 	 	:= {'DB1'}
Local aDados	 	:= {}
Local aDados1	 	:= {}
Local cEnt		 	:= CHR(13)+CHR(10)
Local _aNAviso	 	:= {}

Local cFunName   := Alltrim(ProcName())
Local cArqLckNfe := "\logLCKNfe\"
Local cArqLock   := " "
Local n

Private _aDados	 	:= {}         
Private _aDados1	:= {}

Default _cEmpAtu 	:= '01'
Default _cFilAtu 	:= '09'   

 
MakeDir(cArqLckNfe)  

cArqLock := Alltrim(cFunName + ".lck" )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//?Efetua o Lock de gravacao da Rotina - Monousuario            ?
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
FErase(cArqLock)
nHdlLock := MsFCreate(cArqLock)
IF nHdlLock < 0
	Conout("")
	Conout("**  Rotina "+ cFunName +" em uso...")
	Conout("")
	Return(.T.)
EndIF

RpcSetType(3)
lRetEnv := RpcSetEnv('01','09', "","","","",_aTabela )

If lRetEnv

	//Tratativa para executar no horario 
	cHrAtu := time()
	cHrIni := "07:00:00" 
	cHrTer := "07:10:00"
	If !((cHrAtu >= cHrIni) .And. (cHrAtu  <= cHrTer))
		return()
	EndIf
	
	//Controle da executar a rotina somente uma vez ao dia  
	lGravou := .F.
	cDTCRG := GetMv("ES_ARWF") //Data da Ultima Gera็ใo de Carga do Sistema OffLine.
	If DtoS(dDataBase) == Alltrim(cDTCRG)
		Return()
	Else
		lGravou := .T. //PutMV("ES_DTCRG", DtoS(dDataBase))  //Grv Data atual no parametro
	EndIf

	Conout("---                     INICIO                   ---")
	Conout("--- Rotina de Envio de Emails Aviso Recebimento Nao Homologados ---")

	/*If ( Select( "TRB" ) > 0 )
				( "TRB" )->( dbCloseArea() ) 
	EndIf			
	*/
	BeginSql Alias "TRB"
		%NoParser%
		SELECT   DB1_FILIAL,
	         F1_DOC,
	         C1_PEDIDO,
	         C7_NUM,
	         DB1_NRDOC,
	         DB1_CLIFOR,
	         DB1_LOJA,
	         C7_USER,
	         C1_NUM,
	         C1_USER,
	         C1_SOLICIT,
	         DB1_FILIAL,
	         DB1_NRAVRC,
	         DB1_ENTREG,
	         DB1_HORA1,
	         C7_OBS
		FROM     DB1010 AS DB1
	         INNER JOIN
	         dbo.DB2010 AS DB2
	         ON DB1.DB1_NRAVRC = DB2.DB2_NRAVRC
	            AND DB1.DB1_FILIAL = DB2.DB2_FILIAL
	            AND DB2.%notDel%
	         INNER JOIN
	         dbo.DB3010 AS DB3
	         ON DB3.DB3_NRAVRC = DB2.DB2_NRAVRC
	            AND DB3_FILIAL = DB2_FILIAL
	            AND DB3.%notDel%
	         LEFT OUTER JOIN
	         SF1010 AS SF1
	         ON F1_FILIAL = DB1_FILIAL
	            AND F1_DOC = DB1_NRDOC
	            AND F1_FORNECE = DB1_CLIFOR
	            AND F1_LOJA = DB1_LOJA
	            AND SF1.%notDel%
	         LEFT OUTER JOIN
	         SC7010 AS SC7
	         ON DB3_NUMPC = C7_NUM
	            AND DB3_ITEMPC = C7_ITEM
	            AND DB3_FILIAL = C7_FILIAL
	            AND SC7.%notDel%
	         LEFT OUTER JOIN
	         SC1010 AS SC1
	         ON C7_NUMSC = C1_NUM
	            AND C7_ITEMSC = C1_ITEM
	            AND C7_FILIAL = C1_FILIAL
	            AND SC1.%notDel%
		WHERE    DB1.%notDel%
	         AND DB1.DB1_HOMOLO = '1'
	         AND DB3.DB3_ITEM = '001'
	         AND [DB1].[DB1_CLIFOR] <> '000148'
	         AND [C7_IMPORT] <> 'S'
	         AND DATEDIFF(DAY,DB1_ENTREG,GetDate()) >= 5
	         AND DATEDIFF(DAY,DB1_EMISSA,GetDate()) <= 30
	         AND F1_DOC IS NULL
		GROUP BY DB1_NRAVRC, F1_DOC, C1_PEDIDO, C7_NUM, C7_USER, C1_NUM, C1_USER, C1_SOLICIT, DB1_FILIAL, DB1_ENTREG, DB1_HORA1, C7_OBS, DB1.DB1_NRDOC, DB1_CLIFOR, DB1_LOJA
		ORDER BY DB1.DB1_NRAVRC, DB1.DB1_NRDOC, DB1.DB1_ENTREG
	EndSql
	TcSetField("TRB","DB1_ENTREG","D",8,0)
	
	DbSelectArea("TRB")
	TRB->(DbGotop())
	While TRB->(!Eof())
				
		If !Empty(TRB->F1_DOC)
			
			AADD(_aNAviso,TRB->DB1_NRAVRC)
			
			If Len(_aNAviso) > 0
				For n:=1 To Len(_aNAviso)
					DbSelectArea("DB1")
					DB1->(DbSetOrder(1)) 
					If DB1->(DBSeek(xFilial("DB1")+Alltrim(_aNAviso[n])))
				//+ PadR(Upper(Alltrim(_aNAviso[n])),nTamAR,"")
						Reclock("DB1",.F.)
						DB1->DB1_HOMOLO := '3'
						MSUnlock("DB1")
						DB1->(dbCloseArea()) 
						//( "TRB" )->( dbCloseArea() ) 
						_aNAviso := {}
					EndIf
				Next
			EndIf		
			//TRB->(DbSkip())
		ElseIf !Empty(TRB->C7_NUM) .And. Len(_aNAviso) == 0
				aDados:={TRB->DB1_FILIAL,;//1 	
				TRB->DB1_NRDOC,;	//2	
				TRB->DB1_NRAVRC,;//3		
				TRB->DB1_ENTREG,;//4		
				TRB->DB1_HORA1,;//5
				TRB->DB1_CLIFOR,;//6
				TRB->DB1_LOJA,;//7
				TRB->C7_NUM,;//8
				TRB->C7_USER,;//9
				TRB->C1_NUM,;//10
				TRB->C1_USER,;//11
				TRB->C1_SOLICIT,;//12
				TRB->C7_OBS,;		//13	
				TRB->C1_PEDIDO}		//14
		
				AADD(_aDados,aDados)
		Else
				aDados1:={TRB->DB1_FILIAL,;//1 	
				TRB->DB1_NRDOC,;	//2	
				TRB->DB1_NRAVRC,;//3		
				TRB->DB1_ENTREG,;//4		
				TRB->DB1_HORA1,;//5
				TRB->DB1_CLIFOR,;//6
				TRB->DB1_LOJA,;//7
				TRB->C7_NUM,;//8
				TRB->C7_USER,;//9
				TRB->C1_NUM,;//10
				TRB->C1_USER,;//11
				TRB->C1_SOLICIT,;//12
				TRB->C7_OBS,;		//13	
				TRB->C1_PEDIDO}		//14
			   
				AADD(_aDados1,aDados1)
		EndIf
			Aviso_Encer(_aDados,_aDados1)
			
		TRB->(DbSkip())
	EndDo
	DbCloseArea()                
	RpcClearEnv()                        
	Conout("---                      FIM                    ---")
	Conout("---------------------------------------------------")
	
	If lGravou
		PutMV("ES_ARWF", DtoS(dDataBase))  //Grv Data atual no parametro
	EndIf 
		
EndIf
//Cancela o Lock de gravacao da rotina
FClose(nHdlLock)
FErase(cArqLock)

Return()

/*-------------------------------------------------------------------------------------------------------------------------*/
Static Function Aviso_Encer(_aDados,_aDados1)

Local oHtml
Local oProcess
Local cEmlFor 	//:= GetMv ('MV_EMAILWAR')//
Local _cEmlFor	:= GetMv ('MV_EMAILWF')//
Local cProc 	
Local _cProc 
Local x	


/*If Len(_aDados) = 0 
	aAdd( oHtml:ValByName( "it.desc" ), "*******************************************************************************************")
	aAdd( oHtml:ValByName( "it.desc" ), "Nใo hแ Solicita็๕es Pendentes de Aprova็ใo pelo RH/Ponto Eletronico")
	aAdd( oHtml:ValByName( "it.desc" ), "*******************************************************************************************") 

EndIf	*/
If Len(_aDados) > 0 
	
	SETMV("MV_WFMLBOX","WORKFLOW")
	cProcess := OemToAnsi("001050")
	cStatus  := OemToAnsi("001050")
	

	oProcess:= TWFProcess():New( '001090', cProc )
	oProcess:NewTask( cStatus, "\WORKFLOW\HTM\wf_ar.htm" )
	oHtml    := oProcess:oHTML
	oHtml:ValByName("Data"			,DTOC(DDATABASE))
	oHtml:ValByName("acao"			,cProc)

	aAdd( oHtml:ValByName( "it.desc" ), "***********************************************************************************************")
	aAdd( oHtml:ValByName( "it.desc" ), "Aviso de Recebimento - NF nao homologadas ๚ltimos 30 dias ate esta data")
	aAdd( oHtml:ValByName( "it.desc" ), "***********************************************************************************************")

	For x:=1 To Len(_aDados)
			cProc:="Aviso Recebimento/Notas Fiscais Nใo Homologadas"+ Space(2)+ "Nota Fiscal : " + _aDados[x][2]
			_cEmail  := UsrRetmail(_aDados[x][11])
			aAdd( oHtml:ValByName( "it.desc" ), "Abaixo mercadoria e/ou servi็o solicitado que foi entregue a mais de 5 dias, favor providenciar Pr้-Nota ")
	   		aAdd( oHtml:ValByName( "it.desc" ), "*********************************************************************************************************")		
	  		aAdd( oHtml:ValByName( "it.desc" ), "Filial " 	 + _aDados[x][1])
			aAdd( oHtml:ValByName( "it.desc" ), "Nota Fiscal : " + _aDados[x][2])
			aAdd( oHtml:ValByName( "it.desc" ), "Fornecedor : "+ Posicione("SA2",1,xFilial("SA2")+(_aDados[x][6] +_aDados[x][7]),"A2_NOME") + Space(3)+(_aDados[x][6]+_aDados[x][7]) )
			aAdd( oHtml:ValByName( "it.desc" ), "Nบ Aviso Receb: " + _aDados[x][3])
			aAdd( oHtml:ValByName( "it.desc" ), "Solicitacao Compras: "+ _aDados[x][10] )
			aAdd( oHtml:ValByName( "it.desc" ), "Pedido Compras: "+ _aDados[x][8] )
			aAdd( oHtml:ValByName( "it.desc" ), "Data Entrega: "+ DTOC( _aDados[x][4]))
			aAdd( oHtml:ValByName( "it.desc" ), "Solicitante: "+ _aDados[x][12] )
			aAdd( oHtml:ValByName( "it.desc" ), "Observa็๕es: "+ _aDados[x][13] )
			aAdd( oHtml:ValByName( "it.desc" ), "*********************************************************************************************************")	
	Next
	
	oProcess:cSubject := cProc 
	oProcess:cTo      := _cEmail //+";"+_cEmlFor
	oProcess:Start()
	oProcess:Finish()	
	_aDados := {}
EndIf		

/*If Len(_aDados1) = 0
	aAdd( oHtml:ValByName( "it.desc" ), "*******************************************************************************************")
	aAdd( oHtml:ValByName( "it.desc" ), "Nใo hแ Solicita็๕es Pendentes de Aprova็ใo pelo RH/Gestใo de Pessoal")
	aAdd( oHtml:ValByName( "it.desc" ), "*******************************************************************************************")
	
EndIf */  
If Len(_aDados1) > 0

	SETMV("MV_WFMLBOX","WORKFLOW")
	cProcess := OemToAnsi("001051")
	cStatus  := OemToAnsi("001051")


	oProcess:= TWFProcess():New( '001051', _cProc )
	oProcess:NewTask( cStatus, "\WORKFLOW\HTM\wf_ar.htm" )
	oHtml    := oProcess:oHTML
	oHtml:ValByName("Data"			,DTOC(DDATABASE))
	oHtml:ValByName("acao"			,_cProc) 

	aAdd( oHtml:ValByName( "it.desc" ), "***********************************************************************************************")
	aAdd( oHtml:ValByName( "it.desc" ), "Aviso de Recebimento - NF nao homologadas ate esta data/ Sem Solicita็ใo de Compra")
	aAdd( oHtml:ValByName( "it.desc" ), "***********************************************************************************************")
			
	For x:=1 To Len(_aDados1)	
			_cProc:="Aviso Recebimento/Notas Fiscais Nใo Homologadas"+ Space(2)+ "Nota Fiscal : " + _aDados1[x][2]
			aAdd( oHtml:ValByName( "it.desc" ), "Abaixo mercadoria e/ou servi็o solicitado que foi entregue, favor providenciar Pr้-Nota")	
	   		aAdd( oHtml:ValByName( "it.desc" ), "*******************************************************************************************")		
	  		aAdd( oHtml:ValByName( "it.desc" ), "Filial " 	 + _aDados1[x][1])
			aAdd( oHtml:ValByName( "it.desc" ), "Nota Fiscal : " + _aDados1[x][2])
			aAdd( oHtml:ValByName( "it.desc" ), "Fornecedor : "+ Posicione("SA2",1,xFilial("SA2")+(_aDados1[x][6] +_aDados1[x][7]),"A2_NOME") + Space(3)+(_aDados1[x][6]+_aDados1[x][7]) )
			aAdd( oHtml:ValByName( "it.desc" ), "Nบ Aviso Receb: " + _aDados1[x][3])
		   //	aAdd( oHtml:ValByName( "it.desc" ), "Solicitacao Compras: "+ _aDados[x][10] )
		   //	aAdd( oHtml:ValByName( "it.desc" ), "Pedido Compras: "+ _aDados[x][8] )
		   	aAdd( oHtml:ValByName( "it.desc" ), "Data Entrega: "+ DTOC( _aDados1[x][4]))
		   //	aAdd( oHtml:ValByName( "it.desc" ), "Solicitante: "+ _aDados[x][12] )
		   //	aAdd( oHtml:ValByName( "it.desc" ), "Observa็๕es: "+ _aDados[x][13] )
			aAdd( oHtml:ValByName( "it.desc" ), "*******************************************************************************************")	  
	Next


oProcess:cSubject := _cProc 
oProcess:cTo      := _cEmlFor
oProcess:Start()
oProcess:Finish()
_aDados1:= {}
EndIf
Return(Nil)
/*-------------------------------------------------------------------------------------------------------------------------*/