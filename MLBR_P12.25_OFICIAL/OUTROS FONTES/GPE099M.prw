#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "ap5mail.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GPE099M  Autor ³ Willer Trindade  º Data ³  17/08/15-10:45 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa Schedule envia email responsaveis RH sobre aprova º±±
±±º          ³ ção do portal pendentes			                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GPE099M(_cEmpAtu,_cFilAtu) 

Local _aTabela 	 	:= {'RH3'}
Local cQuery1 		:= ""
Local _aCodSol	 	:= {}
Local aDados	 	:= {}
Local aDados1	 	:= {}
Local cEnt		 	:= CHR(13)+CHR(10)
Local n

Private _aDados	 	:= {}         
Private _aDados1	:= {}

Default _cEmpAtu := '01'
Default _cFilAtu := '01'   

RpcSetType(3)
RpcSetEnv('01','01', "","","","",_aTabela )

Conout("---                     INICIO                   ---")
Conout("--- Rotina de Envio de Emails Aprovacao Portal ---")


cQuery1 := "SELECT * FROM "
cQuery1 += RetSqlName("RH3")+" RH3 "
cQuery1 += " WHERE "
cQuery1 += " RH3.RH3_STATUS = '4' AND"
cQuery1 += " RH3.D_E_L_E_T_ = ''"
cQuery1 += " ORDER BY RH3_MAT, RH3_DTSOLI"

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TRB",.F.,.F.)   

DbSelectArea("TRB")
TRB->(DbGotop())
While TRB->(!Eof())
	
	AADD(_aCodSol,TRB->RH3_CODIGO)
	
	TRB->(DbSkip())
EndDo

If Len(_aCodSol) > 0
	For n:=1 To Len(_aCodSol)
		
		DbSelectArea("RH3")
		RH3->(DbSetOrder(1)) //RH3_FILIAL+RH3_NUMCHA
		RH3->(DbSeek(xFilial("RH3")+_aCodSol[n]))
		
		If RH3->RH3_TIPO $ ("8-F") .And. RH3->RH3_TIPO <> " "
			aDados:={RH3->RH3_FILIAL,; 	
			RH3->RH3_CODIGO,;		
			RH3->RH3_MAT,;		
			RH3->RH3_TIPO,;		
			RH3->RH3_DTSOLI,;		
			RH3->RH3_STATUS}		
	
			AADD(_aDados,aDados)
		ElseIf	!RH3->RH3_TIPO $ ("8-F") .And. RH3->RH3_TIPO <> " "
		    	aDados1:={RH3->RH3_FILIAL,; 	
				RH3->RH3_CODIGO,;		
				RH3->RH3_MAT,;		
				RH3->RH3_TIPO,;		
				RH3->RH3_DTSOLI,;		
				RH3->RH3_STATUS}
		   
				AADD(_aDados1,aDados1)
		EndIf
	
	Next
		
	Aviso_Encer(_aDados,_aDados1)
EndIf	  
DbCloseArea()                
RpcClearEnv()                        
Conout("---                      FIM                    ---")
Conout("---------------------------------------------------")
Return()

/*-------------------------------------------------------------------------------------------------------------------------*/
Static Function Aviso_Encer(_aDados,_aDados1)

                     
Local oHtml,x
Local oProcess
Local cEmlFor 	:= GetMv ('MV_EMRHPOR')//RH
Local _cEmlFor	:= GetMv ('MV_EMRHPO1')//Ponto
Local cProc 	:= "Aviso Pendencias Solicitações Portal RH/Ponto Eletronico"
Local _cProc 	:= "Aviso Pendencias Solicitações Portal RH/Gestao de Pessoal"

/*If Len(_aDados) = 0 
	aAdd( oHtml:ValByName( "it.desc" ), "*******************************************************************************************")
	aAdd( oHtml:ValByName( "it.desc" ), "Não há Solicitações Pendentes de Aprovação pelo RH/Ponto Eletronico")
	aAdd( oHtml:ValByName( "it.desc" ), "*******************************************************************************************") 

EndIf	*/
If Len(_aDados) > 0 
	
	SETMV("MV_WFMLBOX","WORKFLOW")
	cProcess := OemToAnsi("001090")
	cStatus  := OemToAnsi("001090")
	

	oProcess:= TWFProcess():New( '001090', cProc )
	oProcess:NewTask( cStatus, "\WORKFLOW\HTM\aviso_portal.htm" )
	oHtml    := oProcess:oHTML
	oHtml:ValByName("Data"			,DTOC(DDATABASE))
	oHtml:ValByName("acao"			,cProc)

	aAdd( oHtml:ValByName( "it.desc" ), "***********************************************************************************************")
	aAdd( oHtml:ValByName( "it.desc" ), "Abaixo as solicitações efetuadas via Portal RH pendentes ate esta data")
	aAdd( oHtml:ValByName( "it.desc" ), "***********************************************************************************************")

	For x:=1 To Len(_aDados)
			aAdd( oHtml:ValByName( "it.desc" ), "Pendencias para Aprovação Ponto Eletronico")
	   		aAdd( oHtml:ValByName( "it.desc" ), "*******************************************************************************************")		
	  		aAdd( oHtml:ValByName( "it.desc" ), "Filial " 	 + _aDados[x][1])
			aAdd( oHtml:ValByName( "it.desc" ), "Matrícula : " + _aDados[x][3])
			aAdd( oHtml:ValByName( "it.desc" ), "Nome : " + Posicione("SRA",1,xFilial("SRA")+_aDados[x][3],"RA_NOME") )
			aAdd( oHtml:ValByName( "it.desc" ), "Cod Solicitacao: " + _aDados[x][2])
			aAdd( oHtml:ValByName( "it.desc" ), "Tipo Solicitacao: "+ RetDados(_aDados[x][4],"cStatus") )
			aAdd( oHtml:ValByName( "it.desc" ), "Data Solicitacao: "+ DTOC( _aDados[x][5]))
			aAdd( oHtml:ValByName( "it.desc" ), "Status Solicitacao: "+ _aDados[x][6] + "-"+ Space(3)+"Pendente Aprovação RH")
			aAdd( oHtml:ValByName( "it.desc" ), "*******************************************************************************************")	
	Next
	
oProcess:cSubject := cProc 
oProcess:cTo      := _cEmlFor
oProcess:Start()
oProcess:Finish()	
	
EndIf		

/*If Len(_aDados1) = 0
	aAdd( oHtml:ValByName( "it.desc" ), "*******************************************************************************************")
	aAdd( oHtml:ValByName( "it.desc" ), "Não há Solicitações Pendentes de Aprovação pelo RH/Gestão de Pessoal")
	aAdd( oHtml:ValByName( "it.desc" ), "*******************************************************************************************")
	
EndIf   */
If Len(_aDados1) > 0

	SETMV("MV_WFMLBOX","WORKFLOW")
	cProcess := OemToAnsi("001091")
	cStatus  := OemToAnsi("001091")


	oProcess:= TWFProcess():New( '001091', _cProc )
	oProcess:NewTask( cStatus, "\WORKFLOW\HTM\aviso_portal.htm" )
	oHtml    := oProcess:oHTML
	oHtml:ValByName("Data"			,DTOC(DDATABASE))
	oHtml:ValByName("acao"			,_cProc) 

	aAdd( oHtml:ValByName( "it.desc" ), "***********************************************************************************************")
	aAdd( oHtml:ValByName( "it.desc" ), "Abaixo as solicitações efetuadas via Portal RH pendentes ate esta data")
	aAdd( oHtml:ValByName( "it.desc" ), "***********************************************************************************************")
			
	For x:=1 To Len(_aDados1)	
			aAdd( oHtml:ValByName( "it.desc" ), "Pendencias para Aprovação Gestão de Pessoal")
			aAdd( oHtml:ValByName( "it.desc" ), "*******************************************************************************************")		
	   		aAdd( oHtml:ValByName( "it.desc" ), "Filial " 	 + _aDados1[x][1])
			aAdd( oHtml:ValByName( "it.desc" ), "Matrícula : " + _aDados1[x][3])
			aAdd( oHtml:ValByName( "it.desc" ), "Nome : " + Posicione("SRA",1,xFilial("SRA")+_aDados1[x][3],"RA_NOME") )
			aAdd( oHtml:ValByName( "it.desc" ), "Cod Solicitacao: " + _aDados1[x][2])
			aAdd( oHtml:ValByName( "it.desc" ), "Tipo Solicitacao: "+ RetDados(_aDados1[x][4],"cStatus") )
			aAdd( oHtml:ValByName( "it.desc" ), "Data Solicitacao: "+ DTOC( _aDados1[x][5]))
			aAdd( oHtml:ValByName( "it.desc" ), "Status Solicitacao: "+ _aDados1[x][6] + "-"+ Space(3)+"Pendente Aprovação RH")
			aAdd( oHtml:ValByName( "it.desc" ), "*******************************************************************************************")  
	Next


oProcess:cSubject := _cProc 
oProcess:cTo      := cEmlFor
oProcess:Start()
oProcess:Finish()
EndIf
Return(Nil)
/*-------------------------------------------------------------------------------------------------------------------------*/
Static Function RetDados(_cDado,_cVar)
Local cRet := ""

If Alltrim(_cVar) == "cStatus"
	Do Case
		Case _cDado == 'B'
			cRet := "Férias"
		Case _cDado == '8'
			cRet := "Justificativa de Horário"
		Case _cDado == '6'
			cRet := "Desligamento"
		Case _cDado == '4'
			cRet := "Transferência"
		Case _cDado == '5'
			cRet := "Admissão"
		Case _cDado == '2'
			cRet := "Alteração Cadastral"
		Case _cDado == 'F'
			cRet := "Espelho de Ponto"
		Case _cDado == '7'
			cRet := "Ação Salarial"
		OtherWise
			cRet := ""
	EndCase
EndIf
Return(cRet)