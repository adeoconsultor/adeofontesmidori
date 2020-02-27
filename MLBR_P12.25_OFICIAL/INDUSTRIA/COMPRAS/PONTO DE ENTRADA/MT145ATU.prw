#INCLUDE "RWMAKE.CH"    
#INCLUDE "PROTHEUS.ch"
/*
----------------------------------------------------------------------------------------
Funcao: MT145ATU														Data: 20.09.2017
Autor : Diego Mafisolli
----------------------------------------------------------------------------------------
Objetivo: Ponto de entrada para enviar notificacao quando incluir Aviso Recbto. de Ativo
--------------------------------------------------------------------------------------*/
User Function MT145ATU
	Local cGrupo
	Local cDescProd	
	Local _cEmlFor
	Local cNf
	Local cForn, nI
	Local cNumAvrc := DB3->DB3_NRAVRC
	Local aItens   := {}

	If Inclui

		_cEmlFor := GetMv ('MA_EMAIL06')+",diego.mafisolli@midoriautoleather.com.br"

		cNf      := DB2->DB2_DOC    + '-' + DB2->DB2_SERIE    
		cForn    := DB2->DB2_CLIFOR + '-' + DB2->DB2_LOJA

		For nI := 1 to Len(aCols2)

			cPosCodPro := aScan(aHeader2,{|x| AllTrim(x[2]) == 'DB3_CODPRO'})
			cGrupo     := Posicione("SB1", 1, xFilial("SB1") + aCols2[nI,cPosCodPro], "B1_GRUPO")
			cDescProd  := Posicione("SB1", 1, xFilial("SB1") + aCols2[nI,cPosCodPro], "B1_DESC")

			If Alltrim(cGrupo) $ '90'   
				aAdd(aItens,{aCols2[nI,cPosCodPro], cDescProd, cGrupo})		
			EndIf
		Next
	
		If Len(aItens) > 0
			U_145ENVMAIL(aItens,_cEmlFor,cNf,cForn,DB1->DB1_X_SOL, DB1->DB1_NRAVRC)
		EndIf    
		//Alert("Entrou no ponto de entrada MT145ATU")
	Endif 
             
Return(Nil)
                          

/*--------------------------------------------
------Inicio de envio de e-mail----------
--------------------------------------------*/
User Function 145ENVMAIL(aItens , _cEmlFor, cNf, cForn, cSolic, cNumAvrc)
 
	Local oHtml
    Local nCont, nI := 0
    Local oProcess   
    Local cProc := "Entrada de Ativo/Fixo"
    
    SETMV("MV_WFMLBOX","WORKFLOW")
	cProcess := OemToAnsi("001001")
	cStatus  := OemToAnsi("001001") 
	_cProc  := OemToAnsi(cProc) 
	
	oProcess:= TWFProcess():New( '001001', _cProc )
	oProcess:NewTask( cStatus, "\WORKFLOW\HTM\GRP90AVRC.htm" )
	oHtml    := oProcess:oHTML
	oHtml:ValByName("Data"			,DTOC(DDATABASE))
	oHtml:ValByName("navrc"		,cFilAnt)

   	aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	aAdd( oHtml:ValByName( "it.desc" ), "PRODUTO - DESCRICAO - GRUPO")

	For nI := 1 to Len(aItens)	                                     
	   	aAdd( oHtml:ValByName( "it.desc" ), aItens[nI,1] + " - " + aItens[nI,2] + " - " + aItens[nI,3] )
	Next

   	aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
   	aAdd( oHtml:ValByName( "it.desc" ), "NOTA: "+cNf )
	aAdd( oHtml:ValByName( "it.desc" ), "FORNECE: "+cForn) 
	aAdd( oHtml:ValByName( "it.desc" ), "Num.Aviso Receb.: "+cNumAvrc)
   	aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
   	aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
	   	 
	oProcess:cSubject := "Entrada de Ativo/Fixo"		
	oProcess:cTo      := _cEmlFor     
			
	oProcess:Start()                    	       
	oProcess:Finish() 
   //	Aviso("Concluído","O E-Mail enviado com Sucesso.",{"Ok"}) 
	
Return()