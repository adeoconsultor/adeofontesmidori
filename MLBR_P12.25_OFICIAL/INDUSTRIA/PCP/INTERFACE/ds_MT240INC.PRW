#include 'Protheus.ch' 
#include 'rwmake.ch'
/////////////////////////////////
/*
NOME DO PROGRAMA:DS_MT240INC.PRW
AUTOR     		:DIEGO SILVA
DATA			:26/07/2012
FUNCAO			:MAILTMAJUS()
OBJETIVO		:A PARTIR DO PONTO DE ENTRADA 'MT240INC' OU 'MT241SD3'
				(Estoque/Custos > Atualizacoes > Movmtos. Internos > Internos ou Internos (mod 2)), 
				ENVIAR AOS INTERESSADOS, UM E-MAIL COM OS DADOS DO AJUSTE DE ESTOQUE.
*/
user function MT240INC() // Internos
	U_MAILTMAJUS(SD3->D3_EMISSAO, SD3->D3_ATLOBS, SD3->D3_COD, SD3->D3_TM, SD3->D3_CF, SD3->D3_GRUPO, SD3->D3_LOCAL, SD3->D3_NUMSEQ, SD3->D3_UM, SD3->D3_QUANT, SD3->D3_CUSTO1, SD3->D3_USUARIO, 'MOV. INTERNOS')
return   

/*PONTO DE ENTRADA DESATIVADO POR DIEGO MAFISOLLI EM 20/05/2016
 *MOTIVO: LENTIDAO ROTINA BAIXA REQUISICAO ARMAZEM 
 */
//user function MT241SD3() // Internos (Mod. 2)
//	U_dsMAILTM(SD3->D3_DOC, SD3->D3_EMISSAO, 'MOV. INTERNOS (Mod. 2)')
//return

//---------------------------------------------------------------------------------- 
user function dsMAILTM(cDoc, dEmissao, cModulo)
	// Declaracao de Variaveis
	local nCusto := 0
	local aMatriz := {}
	local bEnvia := .F.
	Local i
	                 
	local _cEmails  := GetMV('MA_MAILTM')
	local oProcess 
	local oHtml

	//--------------------------------------------------------
	// INSTANCIANDO O OBJETO DE ENVIO DE EMAIL
	SETMV("MV_WFMLBOX","WORKFLOW") 
	oProcess := TWFProcess():New( "000003", "Item de TM" )
	oProcess :NewTask( "TM CADASTRADA", "\WORKFLOW\HTM\AjustEstoque.htm" )
	oHtml    := oProcess:oHTML
	
	//--------------------------------------------------------	
	// PROCURAR TODOS OS REGISTROS INSERIDOS NA SD3, COM ESTE
	// DOCUMENTO	 
	dbSelectArea('SD3')
	dbSetOrder(2)
	dbSeek(xFilial('SD3')+cDoc)
	while !SD3->(eof()).and.SD3->D3_DOC == cDOC
		if SD3->D3_EMISSAO == dEmissao  
			if SD3->D3_TM == '006'.or.SD3->D3_TM == '506'
				bEnvia := .T.
				// ADICIONAR UMA NOVA LINHA A MATRIZ 'aMatriz'
	            //              1  2  3  4  5  6  7   8  9  10 11 12 13
				AAdd(aMatriz, {'','','','','','','','','','','', 0, 0})
				aMatriz[len(aMatriz),1]  := dToc(dEmissao)
				aMatriz[len(aMatriz),2]  := SD3->D3_USUARIO
				aMatriz[len(aMatriz),3]  := SD3->D3_ATLOBS
				aMatriz[len(aMatriz),4]  := SD3->D3_COD
				aMatriz[len(aMatriz),5]  := ''
				aMatriz[len(aMatriz),6]  := SD3->D3_TM
				aMatriz[len(aMatriz),7]  := SD3->D3_CF
				aMatriz[len(aMatriz),8]  := SD3->D3_GRUPO
				aMatriz[len(aMatriz),9]  := SD3->D3_LOCAL
				aMatriz[len(aMatriz),10] := SD3->D3_NUMSEQ
				aMatriz[len(aMatriz),11] := SD3->D3_UM
				aMatriz[len(aMatriz),12] := cValToChar(SD3->D3_QUANT)
				aMatriz[len(aMatriz),13] := cValToChar(Transform(SD3->D3_CUSTO1,"@E 9,999,999.99"))
            endif
			// SOMA DO CUSTO DOS LANCAMENTOS
			nCusto := nCusto + D3_CUSTO1
		endif
		// PROXIMO REGISTRO
		if SD3->D3_GRUPO == '58  ' .and. xFilial('SD3') == '09' 
			_cEmails += ';maite.souza@midoriatlantica.com.br;'
		endif
		SD3->(dbSkip())
	END DO


	DbSelectArea('SB1')
	DbSetOrder(1)  
	
		 for i:= 1 to len(aMatriz)
			//--------------------------------------------------------
			// BUSCAR A DESCRICAO DO PRODUTO NA TABELA SB1
			If DbSeek(xFilial('SB1') + aMatriz[i,4])
				aMatriz[i,5]  :=SB1->B1_DESC
			endif                                                   
			
			// INSERIR NA TABELA DE LANCAMENTOS, TODOS OS REGISTROS ENCONTRADOS COM ESTE DOCUMENTO
			aAdd( oHtml:ValByName( "it.data" ), aMatriz[i,1])
			aAdd( oHtml:ValByName( "it.usu" ), aMatriz[i,2])
			aAdd( oHtml:ValByName( "it.obs" ), aMatriz[i,3])
			aAdd( oHtml:ValByName( "it.cod" ), aMatriz[i,4])
			aAdd( oHtml:ValByName( "it.desc" ), aMatriz[i,5])
			aAdd( oHtml:ValByName( "it.tm" ), aMatriz[i,6])
			aAdd( oHtml:ValByName( "it.cf" ), aMatriz[i,7])
			aAdd( oHtml:ValByName( "it.grupo" ), aMatriz[i,8])
			aAdd( oHtml:ValByName( "it.arm" ), aMatriz[i,9])
			aAdd( oHtml:ValByName( "it.numseq" ), aMatriz[i,10])
			aAdd( oHtml:ValByName( "it.um" ), aMatriz[i,11])
			aAdd( oHtml:ValByName( "it.qtde" ), aMatriz[i,12])
			aAdd( oHtml:ValByName( "it.custo" ), aMatriz[i,13])
		 next i
	//--------------------------------------------------------

	oHtml:ValByName("cHoje"		,dToc(dDatabase)+' - '+cModulo)
	oHtml:ValByName("cFilial"   	,cFilant)
	oHtml:ValByName("ctotal"   	,cValToChar(Transform(nCusto,"@E 9,999,999.99")))

		 
	// ASSUNTO ----------------------------------------------
	oProcess:cSubject := "AJUSTE ESTOQUE | FILIAL "+cFilAnt
	
	// PARA:
	oProcess:cTo      := _cEmails  
	// COM COPIA PARA:
	//oProcess:cCC := aluno@microsiga.com.br
	// COM COPIA OCULTA PARA:
	//oProcess:cBCC := 'diego.mafisolli@midoriatlantica.com.br'
	
	if bEnvia
		oProcess:Start()                    
	    //WFSendMail()    
		oProcess:Finish()
	endif
	//Alert('E-mail enviado...')
return
//--------------------------------------------------------------------------------------------------
user function MAILTMAJUS(dEmissao, cObs,cCod, cTM, cCF, cGrupo, cLocal, cNumseq, cUM, nQtde, nCusto, cUsu, cModulo)
	local cDesc    
	               
	//local _cEmails  := 'drawbox@midoriatlantica.com.br'
	local _cEmails  := GetMV('MA_MAILTM')
	local oProcess 
	local oHtml
	                                                          
   		if cGrupo == '58  ' .and. cFilAnt == '09' 
			_cEmails += ';maite.souza@midoriatlantica.com.br;'
	  	endif
	//--------------------------------------------------------
	// BUSCAR A DESCRICAO DO PRODUTO NA TABELA SB1
	//--------------------------------------------------------
	DbSelectArea('SB1')
	DbSetOrder(1)
	
	If DbSeek(xFilial('SB1') + cCod)
	  cDesc  :=SB1->B1_DESC
	endif
	//--------------------------------------------------------
	SETMV("MV_WFMLBOX","WORKFLOW") 
	oProcess := TWFProcess():New( "000003", "Item de TM" )
	oProcess :NewTask( "TM CADASTRADA", "\WORKFLOW\HTM\AjustEstoque.htm" )
	oHtml    := oProcess:oHTML
	// CORPO DO EMAIL ----------------------------------------	
		 oHtml:ValByName("cHoje"		,dToc(dDatabase)+' - '+cModulo)
		 oHtml:ValByName("cFilial"   	,cFilant)
		 oHtml:ValByName("ctotal"   	,cValToChar(Transform(nCusto,"@E 9,999,999.99")))
		 
	   	 aAdd( oHtml:ValByName( "it.data" ), dToc(dEmissao))
	   	 aAdd( oHtml:ValByName( "it.usu" ), cUsu)
	  	 aAdd( oHtml:ValByName( "it.obs" ), cObs)
	   	 aAdd( oHtml:ValByName( "it.cod" ), cCod)
	   	 aAdd( oHtml:ValByName( "it.desc" ), cDesc)
	   	 aAdd( oHtml:ValByName( "it.tm" ), cTM)
		 aAdd( oHtml:ValByName( "it.cf" ), cCF)
	   	 aAdd( oHtml:ValByName( "it.grupo" ), cGrupo)
	   	 aAdd( oHtml:ValByName( "it.arm" ), cLocal)
	   	 aAdd( oHtml:ValByName( "it.numseq" ), cNumseq)
	   	 aAdd( oHtml:ValByName( "it.um" ), cUM)
	   	 aAdd( oHtml:ValByName( "it.qtde" ), cValToChar(nQtde))
	   	 //aAdd( oHtml:ValByName( "it.custo" ), cValToChar(ROUND(nCusto,2)))
	   	 aAdd( oHtml:ValByName( "it.custo" ), cValToChar(Transform(nCusto,"@E 9,999,999.99")))
	   	    
		// ASSUNTO ----------------------------------------------
	oProcess:cSubject := "AJUSTE ESTOQUE | FILIAL "+cFilAnt
	
	oProcess:cTo      := _cEmails  
	//oProcess:cCC := aluno@microsiga.com.br
    //oProcess:cBCC := 'diego.mafisolli@midoriatlantica.com.br'
	
	if cTM == '006' .or. cTM == '506'
		oProcess:Start()                    
	    //WFSendMail()      
		oProcess:Finish()             
	endif
	//Alert('E-mail enviado...')
Return