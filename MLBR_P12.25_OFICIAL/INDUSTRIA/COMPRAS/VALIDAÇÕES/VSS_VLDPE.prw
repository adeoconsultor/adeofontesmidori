#INCLUDE "RWMAKE.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VSS_VldPE ºAutor  ³ Vinicius Schwartz  º Data ³  17/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Trata obrigatoriedade de inf. de prazo de entrega do prod.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso.      ³A rotina eh iniciada na validacao de usuario do campo       º±±
±±º          ³C1_PRODUTO onde fara a verificacao se o produto pertence a  º±±
±±º          ³algum grupo informado no par. MA_GRPPE, caso pertenca sera  º±±
±±º          ³obrigatorio no cadastro do produto a informacao de prazo de º±±
±±º          ³entrega B1_PE e sera enviado um e-mail aos usuarios do Deptoº±±
±±º          ³de compras informando que esta sendo inclusa uma solicitacaoº±±
±±º          ³de compras com produtos sem a informacao de PE, onde eles   º±±
±±º          ³deverao proceder com o devido acerto.                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VSS_VldPE (cProd)
	 Local cGrupo
	 Local cDescProd    
	 Local cGrp	  := GetMv ('MA_GRPPE')  //Grupo de compras obrigados a ter prazo de entrega
	 
     Local _cEmlFor := 'patricia.alves@midoriatlantica.com.br, roberto.klizas@midoriatlantica.com.br,'
     Local oProcess 
     Local oHtml
     Local nCont := 0
//	 RpcSetEnv("01","04","","","","",{"SRA"})

//Posicionando no produto na SB1
dbSelectArea('SB1')
dbSetOrder(1)
if dbSeek(xFilial('SB1')+cProd)
	cGrupo := SB1->B1_GRUPO
	cDescProd := SB1->B1_DESC  
	nPrz := SB1->B1_PE
	
	//Envio de e-mail caso o produto pertenca aos grupos do parametro 	
	if nPrz == 0 .and. cGrupo $ cGrp
		If Alltrim(cGrupo) == '16' .OR. Alltrim(cGrupo) == '20' .OR. Alltrim(cGrupo) == '21'
			 _cEmlFor += 'marcos.oliveira@midoriatlantica.com.br'			
		Endif
	
		//     Alert('Iniciando envio e-mail...')   
		SETMV("MV_WFMLBOX","WORKFLOW")   
		oProcess := TWFProcess():New( "000004", "Solicitação com produto sem prazo de entrega" )
		oProcess:NewTask( "Solicitação com produto sem prazo de entrega", "\WORKFLOW\HTM\ProSol.htm" )
		oHtml    := oProcess:oHTML
		oHtml:ValByName("Data"			,DTOC(DDATABASE))
		oHtml:ValByName("Prod"   		,cProd)
			                                     
		   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
		   	 aAdd( oHtml:ValByName( "it.desc" ), "PRODUTO SEM PRAZO DE ENTREGA: "+cProd+" DO GRUPO: "+cGrupo)
		   	 aAdd( oHtml:ValByName( "it.desc" ), "PRODUTO: "+cDescProd )
		// 	 aAdd( oHtml:ValByName( "it.desc" ), "QUANTIDADE: "+cValToChar(nqtde) )
		   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
		   	 aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
			 aAdd( oHtml:ValByName( "it.desc" ), "USUARIO QUE FEZ A INCLUSAO: "+substr(cUsuario,1,35))
		   	 aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
		   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
			   	 
			   	    	                                 
		oProcess:cSubject := "Solicitação com produto sem prazo de entrega: " + cProd + "- Grupo: " + cGrupo
				
				
				
		oProcess:cTo      := _cEmlFor     
				
		oProcess:Start()                    
		       //WFSendMail()
		       //WFSendMail()	       
		oProcess:Finish()
		//Alert('Email enviado com sucesso...')
	
	endif

endif
    

Return .t.