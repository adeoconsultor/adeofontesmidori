#include 'protheus.ch'
#include 'TopConn.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA050INC ºAutor  ³Sandro Albuquerque  º Data ³  05/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada acionado na inclusão do titulo a pagar     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA050INC()
                                   
Local _lRet := .T. 
Local cMV_X_PANAT := GetMV("MV_X_PANAT") // Natureza para titulos de PA.        
Local aDadosTit := {}

If FunName()$ "EICDI500|EICDI501|EICDI502|FINA340"	//Chamado HD No. 1050 - Não exibe tela de AP para usuários do EIC
	Return (.T.)  // Incluso pelo Luiz em 18/08/2010
EndIf  

If  IsInCallStack( "FA340COMP" ) 
	Return(.T.)
EndIf
                                                              
// Valida o preenchimento dos campos de Centro de Custos e Unid. de origem 
If !FunName() $ "GFEA070"
	If Empty(M->E2_CCD) .or. Empty(M->E2_ITEMD)
		Alert('Obrigatorio o preenchimento dos campos CENTRO DE CUSTOS e ITEM CONTABIL a DEBITO')
		Return(.F.) 
	EndIf                   
Endif         
     
// Cadastro de Fatura GFE nao grava E2_PREFIXO
If FunName() $ "GFEA070"
	M->E2_PREFIXO := cFilant
	M->E2_FILORI := cFilant
Endif
 
//AOliveira 06-11-2018
//Incluir Novo numero de AP, para titulos com origem igual a TOTVSGFE
If M->E2_ORIGEM == "TOTVSGFE"
	
	//Alterado pois foi informado pelo que esta gerando numeração existente
	//M->E2_X_NUMAP := GETNUGFE()

	M->E2_X_NUMAP := u_XGETNAP() /*AOliveira 18-07-2019*/
	
EndIf 
                                        
// Valida a data de emissao e vencimento para titulos tipo PA.
IF ALLTRIM(M->E2_TIPO) == 'PA' .and. (M->E2_VENCREA <> dDatabase .or. M->E2_VENCTO <> dDatabase)
	Alert('O Vencimento real do titulo tipo PA deve ser igual a DATA BASE do sistema...!!!')
	Return(.F.) 
Endif 
       
// Valida a natureza para titulos tipo PA. 
IF ALLTRIM(M->E2_TIPO) == 'PA' .and. !(alltrim(M->E2_NATUREZ) $ cMV_X_PANAT)
	Alert('Para titulos tipo PA utilize as naturezas - '+Alltrim(cMV_X_PANAT))
	Return(.F.) 
Endif                                                 

Return(_lRet)        

/*
* Funcao: GETNUGFE
* Autor : AOliveira
* Data  : 08-01-2019
* OBS   : Rotina tem como objetivo retornar um numero valido qdo
*         E2_ORIGEM == "TOTVSGFE". Evitando assim erro de registro
*         duplicado no processo da rotina de APS, conforme informou
*         o Sr. Diego.
*/
Static Function GETNUGFE()
Local cRet   := ""
Local cQry   := ""
Local _nQtde := 0
Local lSeek  := .T.
 
While lSeek
	
	cRet := GETSXENUM('SE2','E2_X_NUMAP','E2_X_NUMAP') 
	ConfirmSx8()
	
	cQry    := ""
	cQry += " SELECT * "
	cQry += " FROM "+ RetSQLName("SE2")+" "
	cQry += " WHERE E2_X_NUMAP = '"+ cRet +"' "
	cQry += " AND D_E_L_E_T_ = '' "
                      
	TCQUERY cQry ALIAS "TRB" NEW
	
	_nQtde := 0	
	DbSelectArea("TRB")
	TRB->(DbGoTop())        
	TRB->( dBEval({|| _nQtde++}) )  
	TRB->(DbGoTop())	
		
	If _nQtde == 0
		lSeek := .F.
	EndIf              
	
	TRB->(DbCloseArea())
	
	//Validar na SZW  
	If !(lSeek)
	
		cQry := ""
		cQry += " SELECT * "
		cQry += " FROM "+ RetSQLName("SZW")+" "
		cQry += " WHERE ZW_NUMAP = '"+ ALLTRIM(cRet) +"' "
		cQry += " AND D_E_L_E_T_ = '' "
	                      
		TCQUERY cQry ALIAS "TRB" NEW
		
		_nQtde := 0	
		DbSelectArea("TRB")
		TRB->(DbGoTop())        
		TRB->( dBEval({|| _nQtde++}) )  
		TRB->(DbGoTop())	
			
		If _nQtde == 0
			lSeek := .F.
		EndIf              
	
	EndIf
	
	TRB->(DbCloseArea())	

EndDo

Return(cRet)