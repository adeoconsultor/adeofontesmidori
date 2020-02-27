
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.ch"
/*
----------------------------------------------------------------------------------------
Funcao: A010TOK														    Data: 18.04.2012
Autor : Anesio G.Faria    - TAGGs Consultoria - agfaria@taggs.com.br
----------------------------------------------------------------------------------------
Objetivo: PONTO DE ENTRADA PARA BARRAR A INSERCAO DE PRODUTOS SEM NCM
LOCALIZAÇÃO : Function A010TudoOK - Função de Validação para inclusão ou alteração
do Produto.
EM QUE PONTO: No início das validações após a confirmação da inclusão ou alteração,
antes da gravação do Produto; deve ser utilizado para validações adicionais para a
INCLUSÃO ou ALTERAÇÃO do Produto.
-------------------------------------------------------------------------------------- */


User Function A010TOK()

Local lRet := .T.
Local cVldNcm := GetMv ('MA_VLDNCM') //Valores validos S/N/A
Local cGrp	  := GetMv ('MA_GRPPER') //Grupo de compras permitidos
Local _cEmlFor
Local cProc
Local cRetMail
Local cBlq
Local cGrupoM
Local cDesc1
Local cDesc2
Local nNcm
Local nIPI
Local cUM
Local cB5OK := 'N'
Local cOrig

Local cGrp1 := GetMv ('MA_GRPR01') //Grupos que serao considerados -> Workflow: Cadastro->Compras->Fiscal->Cadastro - Email para Fiscal
Local cGrp2 := GetMv ('MA_GRPR02') //Grupos que serao considerados -> Workflow: Cadastro->Compras->Fiscal->Cadastro - Email para Fiscal/Contab1
Local cGrp3 := GetMv ('MA_GRPR03') //Grupos que serao considerados -> Workflow: Cadastro->Compras->Fiscal->Cadastro - Email para Fiscal/Contab2
Local cGrp4 := GetMv ('MA_GRPR04') //Grupos que nao entraram no workflow - Excecao
Local cGrp5 := GetMv ('MA_GRPR05') //Grupos 100,91

local cGrMid := getmv('MA_GRPMIDO') //Os grupos que constarem nesse parametro deve ser obrigatorio o preenchimento
//do campo B1_MIGRMID


Private	cCodUs	:= UsrFullName(RetCodUsr() )
Private lBloq
/*
Local cEmail1 := GetMv ('MA_EMAIL01') //Emails Fiscal
Local cEmail2 := GetMv ('MA_EMAIL02') //Emails Fiscal/Contab 1
Local cEmail3 := GetMv ('MA_EMAIL03') //Emails Fiscal/Contab 2
Local cEmail4 := GetMv ('MA_EMAIL04') //Emails Compras
*/




//Bloco para verificar se o grupo é exige o preenchimento do campo B1_MIGRMID
//Implantado por Anesio em 07.08.2014 a pedido de Viviane (Dpto Fiscal)
if Alltrim(M->B1_GRUPO) $ cGrMid
	if M->B1_MIGRMID == space(4)
		Alert("O Grupo "+ALLTRIM(M->B1_GRUPO)+" está como obrigatório preenchimento do Grupo Midori no parametro MA_GRPMIDO "+chr(13)+"Favor preenche-lo."+chr(13)+chr(13)+"PASTA OUTROS")
		lRet := .F.
	endif
endif
//Fim do bloco



//Inicio Valida NCM
if cVldNcm $ 'S|A'
	if M->B1_POSIPI == space(10)
		if !M->B1_GRUPO $ cGrp
			Alert('Codigo nao pode ser utilizado, esta faltando NCM'+chr(13);
			+'Favor preencher o campo NCM'+chr(13))
			if cVldNcm == 'S'
				lRet := .F.
			endif
		endif
	endif
endif

DbSelectArea('SYD')      //implementado verificação ncm conforme hdi 005191
DbSetOrder(1)
If DbSeek(xFilial('SYD')+ M->B1_POSIPI)
	If SYD->YD_RETOPER == '1'
		M->B1_PIS   	:= '1'
		M->B1_COFINS 	:= '1'
		M->B1_RETOPER	:= '1'
	EndIf
EndIf
//dbCloseArea()

/*-----------------------------------------------------------------------------------------
Data: 31.07.2012
Autor : Vinicius S. Schwartz - Midori Atlantica - vinicius.schwartz@midoriatlantica.com.br
-------------------------------------------------------------------------------------------
Objetivo: PONTO DE ENTRADA NA INCLUSAO E ALTERACAO DE PRODUTOS - DEPENDENDO DO GRUPO DO
PRODUTO SERA DISPARADO UM E-MAIL PARA O COMPRAS/FISCAL EFETUAR OS DEVIDOS ACERTOS
(PRAZO DE ENTREGA / LIBERACAO) E DEVOLVER UM OUTRO E-MAIL AO USUARIO INFORMANDO
QUE O CADASTRO ESTA LIBERADO PARA USO. REF AO HDI 004716.
Ps.: Os e-mails serao enviados aos responsaveis de cada grupo (parametros->variaveis acima)
-----------------------------------------------------------------------------------------*/
//Em caso de inclusao
If Inclui
    //Bloco para verificar se o grupo é exige o preenchimento do campo B1_MIGRMID
	//Implantado por Anesio em 07.08.2014 a pedido de Viviane (Dpto Fiscal)
	if Alltrim(M->B1_GRUPO) $ cGrMid
   		if M->B1_MIGRMID == space(4)
		Alert("O Grupo "+ALLTRIM(M->B1_GRUPO)+" está como obrigatório preenchimento do Grupo Midori no parametro MA_GRPMIDO "+chr(13)+"Favor preenche-lo."+chr(13)+chr(13)+"PASTA OUTROS")
		lRet := .F.
		endif
	endif
	//Fim do bloco
	//Inicio Valida NCM
	if cVldNcm $ 'S|A'
   		if M->B1_POSIPI == space(10)
	   		if !M->B1_GRUPO $ cGrp
		   		Alert('Codigo nao pode ser utilizado, esta faltando NCM'+chr(13);
		   		+'Favor preencher o campo NCM'+chr(13))
		   		if cVldNcm == 'S'
			   		lRet := .F.
		   		endif
			endif
   		endif
	endif
    DbSelectArea('SYD')      //implementado verificação ncm conforme hdi 005191
	DbSetOrder(1)
	If DbSeek (xFilial('SYD')+ M->B1_POSIPI)
		If SYD->YD_RETOPER == '1'
			M->B1_PIS   	:= '1'
			M->B1_COFINS 	:= '1'
			M->B1_RETOPER	:= '1'
		EndIf
	EndIf
	dbCloseArea()
	// Atribui prazo de entrega automatico caso valor < 15 DIAS
	// Solicitante: Marcos Oliveira HDI 4228
	// Diego Mafisolli 06/07/2017
	If M->B1_PE < 15 .And. Rtrim(M->B1_GRUPO) $ '71,72,75'
		M->B1_PE := 15
		
	ElseIf Rtrim(M->B1_GRUPO) $ '18' .And. M->B1_PE < 15
		M->B1_PE := 15	
	ElseIf Rtrim(M->B1_GRUPO) $ '19' .And. M->B1_PE < 25
		M->B1_PE := 25
	ElseIf Rtrim(M->B1_GRUPO) $ '16' .And. M->B1_PE < 30
		M->B1_PE := 30
	Endif
	
	
	//Validação cadastro importado/---helpdesk 4834- rodrigo fiscal
	If Alltrim(M->B1_IMPORT) $ 'S'
		If !M->B1_ORIGEM $ '1|6'
	   		Alert('Quando produto importado, origem'+chr(13);
			+'deve ser 1-6'+chr(13))
			lRet := .F.
			Return (lRet)
		EndIf
	ElseIf Alltrim(M->B1_IMPORT) $ 'N'
		If M->B1_ORIGEM $ '1|6'
	   		Alert('Quando produto Nacional, origem'+chr(13);
			+'deve ser 0-2-3-4-5-7-8'+chr(13))
			lRet := .F.
			Return (lRet)
		EndIf
	EndIf	
	
	If (Alltrim(M->B1_GRUPO) $ Alltrim(cGrp1) .Or. Alltrim(M->B1_GRUPO) $ Alltrim(cGrp2) .Or. Alltrim(M->B1_GRUPO) $ Alltrim(cGrp3)) .And. M->B1_X_EMSOL == Space(50)
		If MsgNoYes ('Nao Foi informado nenhum e-mail de solicitante. Clique em SIM para informar (Ver aba "Outros") e incluí-lo aos e-mails automaticos, ou em NÃO para continuar assim mesmo!')
			lRet := .F.
			Return (lRet)
		endif
	Endif
	
	//Envia e-mail se cadastro for origem 3/5/8---helpdesk 4725- rodrigo fiscal
	If Alltrim(M->B1_ORIGEM) $ '3|5|8'
		_cEmlFor := GetMv('MA_EMAIL01') + ',' + StrTran(UsrRetMail( RetCodUsr() ),'','') //compras + quem cadastrou
		cProc := "Cadastro Origem 3|5|8 necessita FCI"
		VSS_ENVMAIL(M->B1_COD,M->B1_GRUPO,M->B1_DESC,_cEmlFor, cProc)
	EndIf
	
	//Envia e-mail se pertencer aos grupos abaixo
	If Alltrim(M->B1_GRUPO) $ Alltrim(cGrp1) .Or. Alltrim(M->B1_GRUPO) $ Alltrim(cGrp2) .Or. Alltrim(M->B1_GRUPO) $ Alltrim(cGrp3)
		M->B1_MSBLQL := '1'
		_cEmlFor := GetMv('MA_EMAIL04') + ',' + StrTran(UsrRetMail( RetCodUsr() ),' ','') //compras + quem cadastrou
		
		If Alltrim(M->B1_GRUPO) $ Alltrim(cGrp2)
			_cEmlFor := _cEmlFor + ',' + GetMv('MA_EMAIL02')
		Endif
		
		If Alltrim(M->B1_GRUPO) $ Alltrim(cGrp3)
			_cEmlFor := GetMv('MA_EMAIL02') // cadastro de ativo envia email contabilidade - Diego 16/11/2016 - Solicit. Elizanjala
		Endif
		
		// Inclui Impex se produto importado
		If Alltrim(M->B1_IMPORT) == 'S'
			_cEmlFor := _cEmlFor + ',' + GetMv('MA_EMAIL03')
		Endif
		
		//if M->B1_GRUPO == '16' .Or. Alltrim(M->B1_GRUPO) == '20' .Or. Alltrim(M->B1_GRUPO) == '21'
		//	_cEmlFor := _cEmlFor + ',marcos.oliveira@midoriatlantica.com.br,roberto.klizas@midoriatlantica.com.br,'
		//Endif
		
		cProc := "Cadastro"
		VSS_ENVMAIL(M->B1_COD,M->B1_GRUPO,M->B1_DESC,_cEmlFor, cProc)
		/*
		Alert ('Cadastrou!!! + e-mail para compras!!!')
		cCodUsr  := RetCodUsr() //Retorna cod do usuario
		UsrRetMail( RetCodUsr() ) //Retorna e-mail do usuario passando como par o cod
		*/
	endif
	//Grupo 100, 91
	if Alltrim(M->B1_GRUPO) $ Alltrim(cGrp5)
		M->B1_MSBLQL := '1'
		_cEmlFor := GetMv ('MA_EMAIL06')  + ',' +  StrTran(UsrRetMail( RetCodUsr() ),' ','')
		cProc := "Cadastro"
		VSS_ENVMAIL(M->B1_COD,M->B1_GRUPO,M->B1_DESC,_cEmlFor, cProc)
	endif
	
	//Envia e-mail se nao pertencer aos grupos abaixo (inclusive excecao)
	if !Alltrim(M->B1_GRUPO) $ Alltrim(cGrp1) .And. !Alltrim(M->B1_GRUPO) $ Alltrim(cGrp2) .And. !Alltrim(M->B1_GRUPO) $ Alltrim(cGrp3) .And. !Alltrim(M->B1_GRUPO) $ Alltrim(cGrp5)//.And. !M->B1_GRUPO $ cGrp4 .And. !M->B1_GRUPO $ cGrp5
		M->B1_MSBLQL := '2'
		_cEmlFor := GetMv ('MA_EMAIL05') + ',' + StrTran(UsrRetMail( RetCodUsr() ),' ','') //fiscal + quem cadastrou
		cProc := "Cadastro/Liberado Automatico"
		VSS_ENVMAIL(M->B1_COD,M->B1_GRUPO,M->B1_DESC,_cEmlFor, cProc)
		//		Alert ('Cadastrou!!! + e-mail direto pro fiscal!!!')
	endif
EndIf
//Em casao de alteracao
If Altera
	//RegToMemory("SB1", .F.) 
	
	cBlq	:= SB1->B1_MSBLQL
	cGrupoM := SB1->B1_GRUPO
	cDesc1  := SB1->B1_DESC
	nNcm    := SB1->B1_POSIPI
	nIPI	:= SB1->B1_IPI
	cUM		:= SB1->B1_UM
	cOrig	:= SB1->B1_ORIGEM
	cMotBlq	:= M->B1_MOTIV
	
	cProd	:= SB1->B1_COD
	
	// Atribui prazo de entrega automatico caso valor < 15 DIAS
	// Solicitante: Marcos Oliveira HDI 4228
	// Diego Mafisolli 06/07/2017
	If M->B1_PE < 15 .And. Rtrim(M->B1_GRUPO) $ '71,72,75'
		M->B1_PE := 15
		
	ElseIf Rtrim(M->B1_GRUPO) $ '18' .And. M->B1_PE < 15
		M->B1_PE := 15		
	ElseIf Rtrim(M->B1_GRUPO) $ '19' .And. M->B1_PE < 25
		M->B1_PE := 25
	ElseIf Rtrim(M->B1_GRUPO) $ '16' .And. M->B1_PE < 30
		M->B1_PE := 30	
	Endif
	
	//Validação cadastro importado/---helpdesk 4834- rodrigo fiscal
	If Alltrim(M->B1_IMPORT) $ 'S'
		If !M->B1_ORIGEM $ '1|6'
			MsgAlert('Quando produto importado, origem'+chr(13);
			+'deve ser 1|6'+chr(13))
			lRet := .F.
			Return (lRet)
		EndIf
	ElseIf Alltrim(M->B1_IMPORT) $ 'N'
		If M->B1_ORIGEM $ '1|6'
			MsgAlert('Quando produto Nacional, origem'+chr(13);
			+'deve ser 0|2|3|4|5|7|8'+chr(13))
			lRet := .F.
			Return (lRet)
		EndIf
	EndIf	
	
	DbSelectArea('SB5')
	DbSetOrder(1)
	If DbSeek (xFilial('SB5')+SB1->B1_COD)
		cDesc2  := SB5->B5_CEME
		cB5OK := 'S'
	Endif
	
	/*DbSelectArea('SBZ')      //implementado verificação ncm conforme HELPDESK 4815
	DbSetOrder(1)
	If DbSeek(xFilial('SBZ')+ Alltrim(cProd))
		If  M->B1_IPI <> SBZ->BZ_IPI
			SBZ->BZ_IPI := M->B1_IPI
		ElseIf
			M->B1_ORIGEM <> SBZ->BZ_ORIGEM
			SBZ->BZ_ORIGEM := M->B1_ORIGEM
		ElseIf
			M->B1_PISI <> SB1->B1_PIS
			SB1->B1_PIS := M->B1_PISI
		ElseIf
			M->B1_COFINS <> SB1->B1_COFINS
			SB1->B1_COFINS := M->B1_COFINS
		Else
			M->B1_RETOPER <> SB1->B1_RETOPER
			SB1->B1_RETOPER := M->B1_RETOPER		
		EndIf
	EndIf	
	*/	
		//Inicio de validacao de alteracao de cadastro de produto - envia e-mail para fiscal
		
		//Alert ('Parametro -> ' + cValToChar(mv_par02))
	If cBlq == '2' .And. M->B1_MSBLQL == '1'
		If  Empty(cMotBlq)
			Alert('No bloqueio do produto, favor informar'+chr(13);
			+'motivo no campo Motivo Bloqueio'+chr(13))
			lRet := .F.
			Return (lRet)		
		EndIf
			If lRet     // Confirmou
			    
				M->B1_HISTBLQ	:= Alltrim(M->B1_HISTBLQ) +CRLF+ ALLTRIM(cMotBlq) +CRLF+ "BLOQUEIO REALIZADO "+DtoC(dDataBase)+" - "+Time()+", USUARIO:"+ Alltrim(RetCodUsr()) +" - "+Alltrim(USRFULLNAME(RETCODUSR()))
				
				/*Begin Transaction
		
				DbSelectArea("SB1")
			
				RecLock("SB1", .F.)
				SB1->B1_HISTBLQ	:= Alltrim(SB1->B1_HISTBLQ) +chr(13)+ ALLTRIM(cMotBlq) +CRLF+ "BLOQUEIO REALIZADO "+DtoC(dDataBase)+" - "+Time()+", USUARIO:"+ Alltrim(RetCodUsr()) +" - "+Alltrim(USRFULLNAME(RETCODUSR()))
				SB1->B1_MOTIV := " "
				SB1->(MSUnlock())
						
				End Transaction
			    */
			EndIf
		//M->B1_MOTIV := " "	
	   	_cEmlFor := GetMv ('MA_EMAIL07') + ',' + StrTran(UsrRetMail( RetCodUsr() ),' ','') 
	   	//_cEmlFor := StrTran(UsrRetMail( RetCodUsr() ),' ','')
		cProc := 'Bloqueio do produto ' + M->B1_COD
		VSS_ENVMAIL(M->B1_COD,M->B1_GRUPO,M->B1_DESC,_cEmlFor, cProc)
	Endif
	
	
	
	If cGrupoM <> M->B1_GRUPO .And. M->B1_MSBLQL == '2' .And. cBlq == '2'
			//Alert ('Foi alterado o grupo deste produto!!!')
			_cEmlFor := GetMv ('MA_EMAIL01')//fiscal
			cProc := "Alteracao"
			VSS_EMAIL(M->B1_COD, M->B1_DESC, _cEmlFor, cProc, "GRUPO", cGrupoM, M->B1_GRUPO)
	Endif
	If cDesc1 <> M->B1_DESC .And. M->B1_MSBLQL == '2' .And. cBlq == '2'
			//Alert ('Foi alterada a descricao 1 deste produto!!!')
			_cEmlFor := GetMv ('MA_EMAIL01')//fiscal
			cProc := "Alteracao"
			VSS_EMAIL(M->B1_COD, M->B1_DESC, _cEmlFor, cProc, "DESCRICAO", cDesc1, M->B1_DESC)
	Endif
		/*If cB5OK == 'S' .And. mv_par02 == 1
		If cDesc2 <> M->B5_CEME .And. M->B1_MSBLQL == '2' .And. cBlq == '2'
		//Alert ('Foi alterada a descricao complementar deste produto!!!')
		_cEmlFor := GetMv ('MA_EMAIL01')//fiscal
		cProc := "Alteracao"
		VSS_EMAIL(M->B1_COD, M->B1_DESC, _cEmlFor, cProc, "DESCRICAO COMPLEMENTAR", cDesc2, M->B5_CEME)
		endif
		Endif*/ 
	If nNcm <> M->B1_POSIPI .And. M->B1_MSBLQL == '2' .And. cBlq == '2'
		//Alert ('Foi alterado o NCM deste produto!!!')
		_cEmlFor := GetMv ('MA_EMAIL01')//fiscal
		cProc := "Alteracao"
		VSS_EMAIL(M->B1_COD, M->B1_DESC, _cEmlFor, cProc, "NCM", nNcm, M->B1_POSIPI)
	Endif
	If nIPI <> M->B1_IPI .And. M->B1_MSBLQL == '2' .And. cBlq == '2'
		//Alert ('Foi alterada a alíquota de IPI deste produto!!!')
		_cEmlFor := GetMv ('MA_EMAIL01')//fiscal
		cProc := "Alteracao"
		VSS_EMAIL(M->B1_COD, M->B1_DESC, _cEmlFor, cProc, "ALIQ IPI", cValToChar(nIPI), cValToChar(M->B1_IPI))
	Endif
	If cUM <> M->B1_UM .And. M->B1_MSBLQL == '2' .And. cBlq == '2'
		//Alert ('Foi alterado a UM deste produto!!!')
		_cEmlFor := GetMv ('MA_EMAIL01')//fiscal
		cProc := "Alteracao"
		VSS_EMAIL(M->B1_COD, M->B1_DESC, _cEmlFor, cProc, "UM", cGrupoM, M->B1_UM)
	Endif
	If cOrig <> M->B1_ORIGEM .And. M->B1_MSBLQL == '2' .And. cBlq == '2'//Envia e-mail se cadastro for origem 3/5/8 altera---helpdesk 4725- rodrigo fiscal
		//Alert ('Foi alterado o NCM deste produto!!!')
		_cEmlFor := GetMv ('MA_EMAIL01')//fiscal
		cProc := "Alteracao"
		VSS_EMAIL(M->B1_COD, M->B1_DESC, _cEmlFor, cProc, "ORIGEM", cOrig, M->B1_ORIGEM)
	EndIf
	//Fim da validacao de alteracao de cadastro de produto
	
	//Inicio validacao de cadastro de prazo de entrega feito por compras
	//Caso grupo for igual ao 01
	If M->B1_PE <> 0 .And. M->B1_MSBLQL == '1' .And. M->B1_MSBLQL == cBlq .And. M->B1_GRUPO $ cGrp1
		M->B1_MSBLQL := '2'
		_cEmlFor := GetMv ('MA_EMAIL01')//fiscal
		cProc := "Cadastro/Liberado por Compras"
		VSS_ENVMAIL(M->B1_COD,M->B1_GRUPO,M->B1_DESC,_cEmlFor, cProc)
		//		Alert('Compras Alterou 1!!! + e-mail para o fiscal!!!')
	endif
	//Caso grupo for igual ao 02
	If M->B1_PE <> 0 .And. M->B1_MSBLQL == '1' .And. M->B1_MSBLQL == cBlq .And. M->B1_GRUPO $ Alltrim(cGrp2)
		_cEmlFor := GetMv ('MA_EMAIL02')//contab/fiscal
		cProc := "Cadastro/Liberado Prazo Entrega Compras/Verificação Contabilidade"
		VSS_ENVMAIL(M->B1_COD,M->B1_GRUPO,M->B1_DESC,_cEmlFor, cProc)
		//		Alert('Compras Alterou 2!!! + e-mail para o fiscal!!!')
	endif
	//Caso grupo for igual ao 03
	If M->B1_PE <> 0 .And. M->B1_MSBLQL == '1' .And. M->B1_MSBLQL == cBlq .And. M->B1_GRUPO $ Alltrim(cGrp3)
		_cEmlFor := GetMv ('MA_EMAIL02')//contab/fiscal
		cProc := "Cadastro"
		VSS_ENVMAIL(M->B1_COD,M->B1_GRUPO,M->B1_DESC,_cEmlFor, cProc)
		//		Alert('Compras Alterou 3!!! + e-mail para o fiscal!!!')
	endif
	//Fim de validacao do PE feito por compras
	
	//Inicio validacao de liberacao de produto feito por fiscal
	//If (cBlq == '1' .And. cBlq <> M->B1_MSBLQL .And. M->B1_PE <> 0 .And. (M->B1_GRUPO $ cGrp1 .Or. M->B1_GRUPO $ Alltrim(cGrp2) .Or. M->B1_GRUPO $ Alltrim(cGrp3) .Or. M->B1_GRUPO $ Alltrim(cGrp4))) .Or.  (cBlq == '1' .And. cBlq <> M->B1_MSBLQL .And. M->B1_PE == 0 .And. (!M->B1_GRUPO $ cGrp1 .And. !M->B1_GRUPO $ Alltrim(cGrp2) .And. !M->B1_GRUPO $ Alltrim(cGrp3) .And. !M->B1_GRUPO $ Alltrim(cGrp4))) 
	If (cBlq == '1' .And. cBlq <> M->B1_MSBLQL .And. (M->B1_GRUPO $ cGrp1 .Or. M->B1_GRUPO $ Alltrim(cGrp2) .Or. M->B1_GRUPO $ Alltrim(cGrp3) .Or. M->B1_GRUPO $ Alltrim(cGrp4))) .Or.  (cBlq == '1' .And. cBlq <> M->B1_MSBLQL .And. (!M->B1_GRUPO $ cGrp1 .And. !M->B1_GRUPO $ Alltrim(cGrp2) .And. !M->B1_GRUPO $ Alltrim(cGrp3) .And. !M->B1_GRUPO $ Alltrim(cGrp4)))
		//		_cEMlFor := StrTran(UsrRetMail( SubStr(B1_XINCLUI,1,6) ),' ','') + ',' + StrTran(UsrRetMail( RetCodUsr() ),' ','') //usuario que cadastrou e o atual
		Do Case
			Case M->B1_GRUPO $ cGrp1 .And. !M->B1_GRUPO $ Alltrim(cGrp2)
				_cEMlFor := GetMv ('MA_EMAIL01')  + GetMv ('MA_EMAIL02')  + ';' + StrTran(UsrRetMail( SubStr(B1_XINCLUI,1,6) ),' ','') + ',' + M->B1_X_EMSOL
			Case M->B1_GRUPO $ Alltrim(cGrp2)
				_cEMlFor := GetMv ('MA_EMAIL02') + ',' +StrTran(UsrRetMail( SubStr(B1_XINCLUI,1,6) ),' ','') + ',' + M->B1_X_EMSOL
				//	Case M->B1_GRUPO $ cGrp3
				//	_cEMlFor := GetMv ('MA_EMAIL03')  + ',' + StrTran(UsrRetMail( SubStr(B1_XINCLUI,1,6) ),' ','') + ',' + M->B1_X_EMSOL
			Case M->B1_GRUPO $ Alltrim(cGrp4)
				_cEMlFor := GetMv ('MA_EMAIL01')  + GetMv ('MA_EMAIL05')
			Case M->B1_GRUPO $ Alltrim(cGrp5)
				_cEMlFor := GetMv ('MA_EMAIL06')   + ',' + StrTran(UsrRetMail( SubStr(B1_XINCLUI,1,6) ),' ','') + ',' + M->B1_X_EMSOL
			Case !M->B1_GRUPO $ cGrp1 .And. !M->B1_GRUPO $ Alltrim(cGrp2) .And. !M->B1_GRUPO $ Alltrim(cGrp3) .And. !M->B1_GRUPO $ Alltrim(cGrp4) .And. !M->B1_GRUPO $ Alltrim(cGrp5)
				_cEMlFor := GetMv ('MA_EMAIL01')   + ',' + StrTran(UsrRetMail( SubStr(B1_XINCLUI,1,6) ),' ','') + ',' + M->B1_X_EMSOL
		EndCase
		
		cProc := "Liberacao"
		VSS_ENVMAIL(M->B1_COD,M->B1_GRUPO,M->B1_DESC,_cEmlFor, cProc)
		//		Alert('Fiscal Liberou 1!!! + e-mail de volta ao usuario + quem alterou!!')
	Else
		If (cBlq == '1' .And. cBlq <> M->B1_MSBLQL .And. M->B1_PE == 0 .And. (M->B1_GRUPO $ cGrp1 .Or. M->B1_GRUPO $ Alltrim(cGrp2) .Or. M->B1_GRUPO $ Alltrim(cGrp3)))
			Alert('Para este produto é obrigatório a informacao de prazo de entrega. Favor entrar em contato com o Depto. de Suprimentos antes da liberacao.')
			lRet := .F.
		Endif
	Endif
	
	DbSelectArea('SYD')      //implementado verificação ncm conforme hdi 005191
	DbSetOrder(1)
	If DbSeek (xFilial('SYD')+ M->B1_POSIPI)
		If SYD->YD_RETOPER == '1'
			M->B1_PIS   	:= '1'
			M->B1_COFINS 	:= '1'
			M->B1_RETOPER	:= '1'
		EndIf
	EndIf
	dbCloseArea()
	//Fim de validacao de liberacao feito por fiscal
Endif

//_cEmlFor := _cEmlFor + ',' + GetMv('MA_EMAIL06')

Return lRet

/*--------------------------------------------
------Inicio de envio de e-mail----------
--------------------------------------------*/
Static Function VSS_ENVMAIL(cProd, cGrupo, cDescProd, _cEmlFor, cProc)



Local oHtml
Local nCont := 0
Local oProcess
//	 RpcSetEnv("01","04","","","","",{"SRA"})
//     Alert('Iniciando envido e e-mail...')

//RpcSetEnv("01","04","","","","",{"SRA"})
//Alert('Iniciando envido e e-mail...')

//*Destativado por Anesio em 26-05-2014- Motivo a atualizacao....precisa resolver e voltar
//oProcess:Finish()/
SETMV("MV_WFMLBOX","WORKFLOW")
cProcess := OemToAnsi("001001")
cStatus  := OemToAnsi("001001")
_cProc  := OemToAnsi(cProc)
//oP := TWFProcess():New('PEDCOM','Aprovacao do Pedido de Compras')
oProcess:= TWFProcess():New( '001001', _cProc )
oProcess:NewTask( cStatus, "\WORKFLOW\HTM\VldPro.htm" )
oHtml    := oProcess:oHTML
oHtml:ValByName("Data"			,DTOC(DDATABASE))
oHtml:ValByName("Prod"   		,cProd)
oHtml:ValByName("acao"			,_cProc)

aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
aAdd( oHtml:ValByName( "it.desc" ), "PRODUTO: "+cProd+" DO GRUPO: "+cGrupo)
aAdd( oHtml:ValByName( "it.desc" ), "DESCRICAO: "+cDescProd )
// 	 aAdd( oHtml:ValByName( "it.desc" ), "QUANTIDADE: "+cValToChar(nqtde) )
aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
aAdd( oHtml:ValByName( "it.desc" ), "USUARIO : "+cCodUs)
aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")


oProcess:cSubject := _cProc + "- Produto: " + cProd + "- Grupo: " + cGrupo



oProcess:cTo      := _cEmlFor

oProcess:Start()
//WFSendMail()
//WFSendMail()
oProcess:Finish()
//Alert('Email enviado com sucesso...')
Return()

/*--------------------------------------------
------Inicio de envio de e-mail----------
--------------------------------------------*/
Static Function VSS_EMAIL(cProd, cDescProd, _cEmlFor, cProc, cItem, cItemAnt, cItemApo)
//VSS_EMAIL(M->B1_COD, M->B1_DESC, _cEmlFor, cProc, "DESCRICAO COMPLEMENTAR", cDesc2, M->B5_CEME)
Local oProcess
Local oHtml
Local nCont := 0
//	 RpcSetEnv("01","04","","","","",{"SRA"})
//     Alert('Iniciando envido e e-mail...')

//RpcSetEnv("01","04","","","","",{"SRA"})
//Alert('Iniciando envido e e-mail...')


//*Destativado por Anesio em 26-05-2014- Motivo a atualizacao....precisa resolver e voltar
SETMV("MV_WFMLBOX","WORKFLOW")
oProcess := TWFProcess():New( "000004", cProc )
oProcess:NewTask( cProc, "\WORKFLOW\HTM\AltPro.htm" )
oHtml    := oProcess:oHTML
oHtml:ValByName("Data"			,DTOC(DDATABASE))
oHtml:ValByName("Prod"   		,cProd)
oHtml:ValByName("acao"			,cProc)

aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
aAdd( oHtml:ValByName( "it.desc" ), "PRODUTO: "+cProd )
aAdd( oHtml:ValByName( "it.desc" ), "DESCRICAO: "+cDescProd )
aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
aAdd( oHtml:ValByName( "it.desc" ), "ALTERACAO DE "+cItem+":" )
aAdd( oHtml:ValByName( "it.desc" ), "ANTES DA ALTERACAO -> "+cItemAnt )
aAdd( oHtml:ValByName( "it.desc" ), "APOS A ALTERACAO -> "+cItemApo )
aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
aAdd( oHtml:ValByName( "it.desc" ), "USUARIO : "+cCodUs)
aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")


oProcess:cSubject := cProc + "- Produto: " + cProd + "- Alterado: " + cItem



oProcess:cTo      := _cEmlFor
oProcess:Start()
//WFSendMail()
//WFSendMail()
oProcess:Finish()
//Alert ('E-mail enviado com sucesso!!!')
Return