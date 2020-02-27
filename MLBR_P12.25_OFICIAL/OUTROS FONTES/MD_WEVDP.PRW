#include "rwmake.ch" 
#include "TbiConn.ch"
#include "TbiCode.ch"

/*-----------------------------------------------------------------------------+
 * Programa  * MD_WEVDP   º  ANESIO G.FARIA - TAGGs       * Data ³  24/03/2011 *
 *-----------------------------------------------------------------------------*
 * Objetivo  * Programa que envia e-mail com os eventos que precisam ser acomp *
 *           * anhados pelo dpto pessoal de Alto Alegre e Barbosa              * 
 *-----------------------------------------------------------------------------*
 * Uso       * WorkFlow/MP10 - MIDORI ATLANTICA - ALTO ALEGRE                  *
 *-----------------------------------------------------------------------------+
 | Starting  | Ponto de Entrada                                                |
 +-----------------------------------------------------------------------------*/

User Function MD_WEVDP()
     
/*     Local _cEmlFor := 'agfaria@taggs.com.br; milene.adario@midoriatlantica.com.br'
//     Local _cEmlFor := 'milene.adario@midoriatlantica.com.br'
     Local oProcess 
     Local oHtml
     Local nCont := 0
     //RA_VCTOEXP
     //RA_VCTEXP2                                      
	 RpcSetEnv("01","04", "19","","","",{"SRA"})
     oProcess := TWFProcess():New( "000003", "Relação de Funcionarios" )
     oProcess :NewTask( "Relacao de Funcionarios", "\WORKFLOW\HTM\EventosDP.HTM" )
     oHtml    := oProcess:oHTML
                                                               

   	 aAdd( oHtml:ValByName( "it.func" ), "************************************************************************")     
   	 aAdd( oHtml:ValByName( "it.func" ), "FUNCIONARIOS COM VENCIMENTO DA PRIMEIRA EXPERIENCIA")

     dbSelectArea("SRA")  
     dbSetOrder(1)
     dbGotop()    
     while !eof()
     	if SRA->RA_FILIAL $ '0419'
     	
  		   if dTos(SRA->RA_VCTOEXP) <> space(8)     
//	     		Alert("DATA ATUAL: "+dTos(SRA->RA_VCTOEXP)+" DATA ATUAL: "+dTos(date())+" DIFERENÇA: "+	cValToChar(Val(dTos(SRA->RA_VCTOEXP)) - Val(dTos(date())))+" LINHA DATA: "+cValToChar(nCont))
 		   
    	 		if Val(dTos(SRA->RA_VCTOEXP)) - Val(dTos(date())) <= 10  .and. Val(dTos(SRA->RA_VCTOEXP)) - Val(dTos(date())) >= 0 
			    	 aAdd( oHtml:ValByName( "it.func" ), SRA->RA_MAT + "-"+ SRA->RA_NOME + "   Vence experiencia em: "+dtoc(SRA->RA_VCTOEXP))
			    	 nCont++
		    	endif
		    endif
		endif
    	 SRA->(dbSkip())
     enddo                                                                                    
   	 aAdd( oHtml:ValByName( "it.func" ), "************************************************************************")     
   	 aAdd( oHtml:ValByName( "it.func" ), "FUNCIONARIOS COM VENCIMENTO DA SEGUNDA EXPERIENCIA")
     dbSelectArea("SRA")  
     dbSetOrder(1)
     dbGotop()    
     while !eof()
     	if SRA->RA_FILIAL $ '041909'
			if dTos(SRA->RA_VCTEXP2) <> space(8)
    	 		if Val(dTos(SRA->RA_VCTOEXP)) - Val(dTos(date())) <= 50 .and. Val(dTos(SRA->RA_VCTOEXP)) - Val(dTos(date())) >= 0 
				     aAdd( oHtml:ValByName( "it.func" ), SRA->RA_MAT+'-'+SRA->RA_NOME + "   Vence experiencia em: "+dtoc(SRA->RA_VCTEXP2))
			    	 nCont++
		    	endif
		    endif
		endif
    	 SRA->(dbSkip())
     enddo
                                
oProcess:cSubject := "Relação de Fun de Alto Alegre " + dToc(dDatabase)



	oProcess:cTo      := _cEmlFor     


oProcess:Start()                    
	       WFSendMail()
	       WFSendMail()	       
oProcess:Finish() */
Return
