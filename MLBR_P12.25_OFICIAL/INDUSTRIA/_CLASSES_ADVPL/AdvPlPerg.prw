#INCLUDE "PROTHEUS.CH"
Class AdvPlPerg
	Data aPerg 
	Data cPerg 
	Method New( cPerg ) Constructor
	Method AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
	Method SetPerg()

EndClass
****************************************************************************************************************************
// Método construtor da classe
****************************************************************************************************************************                                                                                                                            
Method New( cPerg ) Class AdvPlPerg
::cPerg := PadR( cPerg, Len(SX1->X1_GRUPO) )
::aPerg := {}
Return( ::Self )                 

****************************************************************************************************************************
// Adiciona as perguntas no array
****************************************************************************************************************************                                                                                                                            
Method AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid ) Class AdvPlPerg
             
aCombo := iif( aCombo == nil, {}, aCombo )
cF3    := iif( cF3 == nil, "", cF3 )
cValid := iif( cValid == nil, "", cValid )
cTipo  := iif( cTipo == nil, "C",  cTipo )

If ! Empty(aCombo)
	cTipo := "N"
	nTam  := 1
	nDec  := 0
EndIf                    

If cTipo == "C"
	nDec := 0
EndIf

If cTipo == "D"
	nTam := 8
	nDec := 0
EndIf

AAdd( ::aPerg, { cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid } )

Return( nil )            
****************************************************************************************************************************                                                                                                                            
// Grava as perguntas no SX1
****************************************************************************************************************************                                                                                                                            
Method SetPerg() Class AdvPlPerg

Local cOrdem
Local lContinua   
Local lNovo
Local aArea := GetArea()

Local nPosCaption := 1
Local nPosTipo    := 2
Local nPosTam     := 3
Local nPosDec     := 4
Local nPosCombo   := 5
Local nPosF3      := 6
Local nPosValid   := 7
Local cSoma       := "0"
Local nX
Local nLoop

dbSelectArea("SX1")
dbSetOrder(1)

For nLoop := 1 to Len( ::aPerg )

	lContinua := .f.
	lNovo     := .t.
	cOrdem    := StrZero( nLoop, Len(SX1->X1_ORDEM) )
          
	// Se a pergunta já existe, verifica se algo mudou
	If dbSeek( ::cPerg + cOrdem )
		lNovo := .f.
		If Upper( Trim(SX1->X1_PERGUNT) ) <> Upper( Trim( ::aPerg[nLoop,nPosCaption] ) )
			lContinua := .t.
		EndIf
		
		If SX1->X1_TIPO <> ::aPerg[nLoop,nPosTipo]
			lContinua := .t.
		EndIf              
		
		If SX1->X1_TAMANHO <> ::aPerg[nLoop,nPosTam]
			lContinua := .t.
		EndIf
		
		If SX1->X1_DECIMAL <> ::aPerg[nLoop,nPosDec]
			lContinua := .t.
		EndIf
	                
		If Upper(Trim(SX1->X1_VALID)) <> Upper(Trim(::aPerg[nLoop,nPosValid]))
			lContinua := .t.
		EndIf
		
		If Upper(Trim(SX1->X1_F3)) <> Upper( Trim( ::aPerg[nLoop,nPosF3] ) )
			lContinua := .t.
		EndIf
		
		If ! Empty( ::aPerg[nLoop,nPosCombo] )
		
			For nX := 1 to Len( ::aPerg[nLoop,nPosCombo] )
		
				If Upper( Trim( ::aPerg[nLoop,nPosCombo][nX] ) ) <> Upper(Trim( &("X1_DEF"+StrZero(nX,2)) ))
					lContinua := .t.
					Exit
				EndIf
		
			Next nX
		
		EndIf
		
		If ! lContinua
			Loop
		EndIf
	Else
		lContinua := .t.
	EndIf
	
	If ! lContinua
		Loop
	EndIf  
	                            
	cSoma := soma1(cSoma,1)
	
	RecLock("SX1",lNovo)
	SX1->X1_GRUPO    := ::cPerg
	SX1->X1_ORDEM    := cOrdem
	SX1->X1_PERGUNT  := ::aPerg[nLoop,nPosCaption]
	SX1->X1_PERSPA   := ::aPerg[nLoop,nPosCaption]
	SX1->X1_PERENG   := ::aPerg[nLoop,nPosCaption]
	SX1->X1_VARIAVL  := "mv_ch"+cSoma
	SX1->X1_TIPO     := ::aPerg[nLoop,nPosTipo]
	SX1->X1_TAMANHO  := ::aPerg[nLoop,nPosTam]
	SX1->X1_DECIMAL  := ::aPerg[nLoop,nPosDec]
	SX1->X1_GSC      := If( Empty( ::aPerg[nLoop,nPosCombo]) , "G", "C" )
	SX1->X1_VALID    := ::aPerg[nLoop,nPosValid]
	SX1->X1_VAR01    := "MV_PAR"+StrZero(nLoop,2)
	SX1->X1_F3       := ::aPerg[nLoop,nPosF3]
	
	For nX := 1 to Len( ::aPerg[nLoop,nPosCombo] )
					
		nPosCpo := FieldPos( "X1_DEF"+StrZero(nX,2) )
		If Empty( nPosCpo )
			Exit
		EndIf
		FieldPut( nPosCpo, SubStr( ::aPerg[nLoop,nPosCombo][nX], 1, Len(SX1->X1_DEF01) )  )
		
	Next nX
	
	MsUnlock()
	
Next nLoop                      

RestArea( aArea )
Return( nil )
****************************************************************************************************************************                                                                                                                            
