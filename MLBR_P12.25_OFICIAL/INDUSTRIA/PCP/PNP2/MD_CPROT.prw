#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
   Esta rotina tem como objetivo copiar o roteiro de operacoes entre produtos. Especifico Midori Atlantica
   Desenvolvido por Rogério Nunes em 22/07/10
*/
User Function MD_CPROT()
//
Private cGProd     			:= Space(15)
Private cGdProd    			:= Space(50)
Private cGRoteiro  			:= Space(2)
Private cGdRoteiro 		:= Space(50)
//
Private cgProdDest 		:= Space(15)
Private cGdProdDes 		:= Space(50)
Private cGRotDest  		:= Space(02)
Private cGdRotDest 		:= Space(50)
//
SetPrvt("oDlgRot","oGrp1","oSay1","oSay2","oSay3","oSay4","oGdProd","oGProd","oGRoteiro","oGdRoteiro")
SetPrvt("oSay5","oSay6","oSay7","oSay8","oGdProdDest","ogProdDest","oGRotDest","oGdRotDest","oBtnOk")
//
oDlgRot    						:= MSDialog():New( 151,265,423,901,"Cópia de Roteiro de Operações Por Produto",,,.F.,,,,,,.T.,,,.T. )
oGrp1      						:= TGroup():New( 002,001,053,312,"Origem",oDlgRot,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      						:= TSay():New( 011,006,{||"Produto"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay2      						:= TSay():New( 011,075,{||"Descrição do Produto"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,235,008)
oSay3      						:= TSay():New( 030,005,{||"Roteiro"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay4      						:= TSay():New( 030,075,{||"Descrição do Roteiro de Operações"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,235,008)
oGProd     					:= TGet():New( 018,005,{|u| If(PCount()>0,cGProd:=u,cGProd)},oGrp1,068,008,'',{|| Vld_Prod()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGProd",,)
oGdProd    					:= TGet():New( 018,075,{|u| If(PCount()>0,cGdProd:=u,cGdProd)},oGrp1,235,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cGdProd",,)
oGRoteiro  					:= TGet():New( 038,005,{|u| If(PCount()>0,cGRoteiro:=u,cGRoteiro)},oGrp1,068,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cGRoteiro",,)
oGdRoteiro 					:= TGet():New( 038,075,{|u| If(PCount()>0,cGdRoteiro:=u,cGdRoteiro)},oGrp1,235,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cGdRoteiro",,)
//
oGrp2      						:= TGroup():New( 057,002,108,313,"Destino",oDlgRot,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay5      						:= TSay():New( 066,007,{||"Produto"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay6      						:= TSay():New( 066,076,{||"Descrição do Produto"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,235,008)
oSay7      						:= TSay():New( 085,006,{||"Roteiro"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay8      						:= TSay():New( 085,076,{||"Descrição do Roteiro de Operações"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,235,008)
ogProdDest 					:= TGet():New( 073,006,{|u| If(PCount()>0,cgProdDest:=u,cgProdDest)},oGrp2,068,008,'',{|| Vld_PrdEST()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cgProdDest",,)
oGdProdDes 					:= TGet():New( 073,076,{|u| If(PCount()>0,cGdProdDest:=u,cGdProdDest)},oGrp2,235,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cGdProdDest",,)
oGRotDest  					:= TGet():New( 093,006,{|u| If(PCount()>0,cGRotDest:=u,cGRotDest)},oGrp2,068,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cGRotDest",,)
oGdRotDest 					:= TGet():New( 093,076,{|u| If(PCount()>0,cGdRotDest:=u,cGdRotDest)},oGrp2,235,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cGdRotDest",,)
//
oBtnOk     					:= SButton():New( 116,248,1,{|| OkProc()},oDlgRot,,"", )
oBtncanc   					:= SButton():New( 116,284,2,{|| CancProc()},oDlgRot,,"", )
//
oDlgRot:Activate(,,,.T.)

Return
//--------------------------------------------------------------------
Static Function Vld_Prod()
	//
	SB1->( DbSetOrder(1) )
	if ! SB1->( DbSeek( xFilial('SB1') + Padr( cGProd , 15 )  ) )
	    Alert( 'Produto não Encontrado. Por favor, corrija.')
	    cGdProd  := SPACE( 50 ) 
	    oGdProd:Refresh()
	    Return( .F. )	    	   
	Endif 
	//
	SG2->( DbSetOrder(1) )
	if ! SG2->( DbSeek( xFilial('SG2') + Padr( cGProd , 15 )  ) )
	    Alert( 'Produto não possui Roteiros Cadastrados. Por favor, corrija.')
	    cGdProd  := SPACE( 50 ) 
    	cGRoteiro  	:= SPACE(2)
   	    cGdRoteiro 	:= SPACE(50)
   	    //
	    oGdProd:Refresh()
	    oGRoteiro:Refresh()
	    oGdRoteiro:Refresh()
	    //
	    Return( .F. )	    	   
	Endif 
	//
	cGdProd   		:= SB1->B1_DESC
	cGRoteiro  	:= SG2->G2_CODIGO 
	cGdRoteiro 	:= 'ROTEIRO PARA O PRODUTO ' + SB1->B1_COD
    ogProdDest:SetFocus()
	//
Return(.T.)
//--------------------------------------------------------------------
Static Function Vld_PrDest()
	//	
	if Alltrim( cgProdDest )  == Alltrim( cGProd )
	   Alert( 'Produto de Destino não pode ser o mesmo da Origem. Por favor, corrija.')   
	   Return( .F. )
	Endif 
	//	
	SB1->( DbSetOrder(1) )
	if ! SB1->( DbSeek( xFilial('SB1') + Padr( cgProdDest , 15 )  ) )
	    Alert( 'Produto não Encontrado. Por favor, corrija.')
	    cGdProdDes  := SPACE( 50 ) 
	    oGdProdDes:Refresh()
	    Return( .F. )	    	   
	Endif 
	//
		//
	SG2->( DbSetOrder(1) )
	if  SG2->( DbSeek( xFilial('SG2') + Padr( cgProdDest, 15 )  ) )
	    //
	    iF ! MsgYesNo( 'Produto já possui Roteiro Cadastrado. Deseja Continuar ?')
	    		cGRotDest			:= SPACE( 02 )
				cGdRotDest			:= SPACE( 50 )
				//                                    
				oGRotDest:refresh()
				oGdRotDest:refresh()
                //
	    		Return( .F. )	    	   	    		 
	    Endif 
	    //
	Endif 
	//
	cGdProdDes   		:= SB1->B1_DESC
	cGRotDest			:= cGRoteiro
	cGdRotDest			:= 'ROTEIRO PARA O PRODUTO ' + SB1->B1_COD
	//
Return(.T.)
//--------------------------------------------------------------------
Static Function CancProc()
    Close(   oDlgRot  )
Return()
//--------------------------------------------------------------------
Static Function OkProc()
  	Local aRegs_G2 := {}
    //
    if ! MsgYesno('Confirma o Processamento ? ')
         Return()
    Else
         MsAguarde( {|| Processar() },'Efetuando Copia de Roteiro...'  )
    Endif 
    //
Return()
//--------------------------------------------------------------------
Static Function Processar()
  	Local aRegs_G2 := {}
  	Local nn1 := 0
  	Local nn2 := 0
  	Local nn3 := 0
  	//
	SB1->( DbSeek( xFilial('SB1') + Padr( cGProd , 15 )  ) )
	//
	DbSelectArea( 'SG2' )
	SG2->( DbSetOrder(1) )
	SG2->( DbSeek( xFilial('SG2') + Padr( cGProd , 15 )  ) )
	//
    aStruG2 := DbStruct() // Puxando a Estrutura da Tabela SG2 
    //
	While !eof()  .and. G2_FILIAL == xFilial('SG2')  .and. G2_PRODUTO == Padr( cGProd , 15 )
	    //
	    aCposG2 := {}
	    For nn1 := 1 to len( aStruG2 )
	         //
	         cNomCampo := Alltrim( aStruG2[ nn1,1 ] )
	         cConteudo    := cNomCampo
	         cConteudo    := &cConteudo
	         //
	         // AAdd( aCposG2 , { "'" + cNomCampo + "'",  iif( cNomCampo <> 'G2_PRODUTO', cConteudo , cgProdDest )    } )
	         AAdd( aCposG2 , { cNomCampo ,  iif( cNomCampo <> 'G2_PRODUTO', cConteudo , cgProdDest )    } )
	         //
	    Next 	    
	    AAdd( aRegs_G2 , aCposG2 ) 
	    //
	  	DbSkip()
	Enddo 
	//
	//
    // Primeiro passo : Excluir todos os Roteiros do Produto Destino se Tiver 
    //
    DbSelectArea('SG2')
    While DbSeek( xFilial('SG2') + Padr( cgProdDest, 15 ) ) 
         Reclock('SG2',  .F. )
              DbDelete()
         MsUnlock()
    Enddo
    //
    //
    For nn2 := 1 to len( aRegs_G2 )
          //
          Reclock('SG2' , .T. )
          For nn3 := 1 to Len( aRegs_G2[ nn2 ] )                
               //
               cCpoDes   := aRegs_G2[ nn2 , nn3, 1 ]
               cConteudo := aRegs_G2[ nn2 , nn3, 2 ]
               //
               Replace &cCpoDes 	With cConteudo
               //
          Next      
          MsUnlock()
          //
    Next 
    //        
    MsgAlert('Cópia Efetuada com Sucesso.')
    //
Return()
//--------------------------------------------------------------------