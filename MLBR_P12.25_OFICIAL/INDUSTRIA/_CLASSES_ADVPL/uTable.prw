#include "totvs.ch"
//============================================================================================
// CLASSE uTField - PROPRIEDADES DE CAMPOS
//============================================================================================
CLASS uTField
          
// Propriedades básicas
Data cField 
Data cLabel
Data cType
Data nSize
Data nDec
Data cPicture
Data cFieldGrp  // Captura o grupo do campo informado nesse parametro
Data cFieldProp // captura tipo, tamanho, decimal, picture e grupo do campo informado nesse parametro
                       
// Propriedades de utilização
Data lReadOnly
Data lUsado
Data lObrigat 
Data lBrowse
Data lVirtual 
Data cCBox

// Propriedade para controle do Log                                      
Data cLog

// Propriedades de Validação e chave estrangeira
Data cValid
Data cF3 

Method New() Constructor

ENDCLASS                                            
//============================================================================================
// uTField():New() -                   Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Construtor da Classe de propriedades de campo
//--------------------------------------------------------------------------------------------
// Parâmetros
// cField - Nome do Campo sem o Alias. Ex.: "_FILIAL"
//--------------------------------------------------------------------------------------------
// Retorno
// self
//============================================================================================
Method New( cField ) Class uTField

::cField     := iif( ValType( cField ) == "U", "", cField )
::cLabel     := ""
::cType      := ""
::nSize      := 1
::nDec       := 0
::cPicture   := ""
::cFieldGrp  := "" 
::cCBox      := ""
::cFieldProp := "" // captura tipo, tamanho, decimal, picture e grupo do campo informado nesse parametro

::lReadOnly  := .f.
::lUsado     := .t.
::lObrigat   := .f.
::lBrowse    := .t.
::lVirtual   := .f.

::cValid     := ""
::cF3        := ""
::cCBox      := ""

::cLog       := ""
Return( Self )                                                                                                  

//============================================================================================
// CLASSE uTTable - TRATAMENTO DE TABELAS E INDICES
//============================================================================================
CLASS uTTable
                
Data cAlias
Data cRealAlias
Data aFields      
Data aIndex
Data cFile                    
Data cModo
Data cDescr
Data cLog
         
Method New() Constructor
Method AddField()
Method AddIndex()
Method Update()
Method Apply()

ENDCLASS         

//============================================================================================
// uTTable():New() -                   Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Construtor da Classe de tratamento de tabelas e indices
//--------------------------------------------------------------------------------------------
// Parâmetros
// cAlias - Alias ADVPL ( Como a tabela é identificada pelas rotinas da ADVPL )
// cModo  - Modo de Acesso - "E"xclusivo ou  "C"ompartilhado
// cDescr - Descrição que será gravada no SX2
//--------------------------------------------------------------------------------------------
// Retorno
// self
//============================================================================================
Method New( cAlias, cModo, cDescr ) Class uTTable

Local cNextSX5 := ""                   
Local cTabSX5  := ""                   
Local aArea    := GetArea()
Local cParam   := "ADVPLSX501"

Default cDescr := ""

::cAlias     := cAlias
::cRealAlias := cAlias
::aFields    := {}
::aIndex     := {}
::cDescr     := ""                  
::cModo      := cModo
::cLog       := ""

//---------------------------------------------------------------
// Verifica se o parâmetro que contém o código da tabela no SX5
// com os alias das tabelas personalizadas ADVPL existe.
//---------------------------------------------------------------
dbSelectArea("SX6")
dbSetOrder(1)

If ! dbSeek("  "+cParam )
	
	// Captura a próxima tabela livre no SX5
	cNextSX5 := GetNextSX5()
	
	// Grava o parâmetro no SX6
	RecLock("SX6",.T.)
	SX6->X6_FIL     := " "
	SX6->X6_VAR     := cParam
	SX6->X6_TIPO    := "C"
	SX6->X6_CONTEUD := cNextSx5
	SX6->X6_DESCRIC := "Tabela SX5 ADVPL - Tabelas personalizadas"
	MsUnlock()
	
	RecLock("SX5",.T.)
	SX5->X5_FILIAL := xFilial("SX5")
	SX5->X5_TABELA := "00"
	SX5->X5_CHAVE  := cNextSx5
	SX5->X5_DESCRI := "ADVPL - Tabelas Personalizadas "
	MsUnlock()
EndIf

cTabSX5 := GetMv(cParam)

//---------------------------------------------------------------
// Pesquisa nas tabelas personalizadas se este alias já existe
// Se não existir, cria.
//---------------------------------------------------------------
dbSelectArea("SX5")
dbSetOrder(1)
If ! dbSeek( xFilial("SX5") + cTabSX5 + ::cAlias )
	
	::cRealAlias := GetNextSX2(::cAlias)
	
	RecLock("SX5",.T.)
	SX5->X5_FILIAL := xFilial("SX5")
	SX5->X5_TABELA := cTabSx5
	SX5->X5_CHAVE  := ::cAlias 
	SX5->X5_DESCRI := ::cRealAlias
	MsUnlock()

Else
	::cRealAlias := Trim(SX5->X5_DESCRI)

EndIf

RestArea( aArea )

Return( Self )

//============================================================================================
// uTTable():AddField() -              Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Adiciona os campos que devem ser tratados no dicionario de dados
//--------------------------------------------------------------------------------------------
// Parâmetros
// oField - Objeto da classe uTField
//--------------------------------------------------------------------------------------------
// Retorno
// nil
//============================================================================================
Method AddField( oField ) Class uTTable            

oField:cField     := Trim( Upper( oField:cField     ) )
oField:cFieldProp := Trim( Upper( oField:cFieldProp ) )
                          
If oField:lObrigat
	oField:lUsado := .t.
EndIf

IF oField:cField == "_FILIAL"
	oField:lReadOnly := .t.
	oField:nSize     := FWSizeFilial()
	oField:cType     := "C"
	oField:lUsado    := .f.
	oField:lBrowse   := .f.
	oField:lObrigat  := .f.
EndIf

If oField:cType <> "N"
	oField:nDec := 0
EndIf

If oField:cType == "C" .and. Empty( oField:cPicture ) .and. oField:cField <> "_FILIAL"
	oField:cPicture := "@!"
EndIf

If oField:cType == "D"
	oField:nSize    := 8
	oField:cPicture := "@D"
EndIf                   

If oField:cType == "M"
	oField:nSize    := 10
	oField:cPicture := " "
EndIf

If oField:cType == "L"
	oField:nSize    := 1
	oField:cPicture := " "
EndIf              
                              
// Copia as propriedades do campo informado
If ! Empty( oField:cFieldProp )
	dbSelectArea("SX3")
	dbSetOrder(2) 
	If dbSeek( oField:cFieldProp )
		oField:cType     := SX3->X3_TIPO
		oField:nSize     := SX3->X3_TAMANHO
		oField:nDec      := SX3->X3_DECIMAL
		oField:cPicture  := SX3->X3_PICTURE
		oField:cFieldGrp := Trim(SX3->X3_CAMPO)
	EndIf
EndIf

AAdd( ::aFields, oField )

Return( nil )

//============================================================================================
// uTTable():AddIndex() -              Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Adiciona os indices que serão tratados no SINDEX para a tabela utilizada na classe
//--------------------------------------------------------------------------------------------
// Parâmetros
// cIndex - Ordem do índice
// cChave - Chave de indice, sem o alias. Ex.: _FILIAL+_COD+DTOS(_VIGINI)
// cDescr - Descrição da chave de pesquisa
//--------------------------------------------------------------------------------------------
// Retorno
// nil
//============================================================================================
Method AddIndex( cIndex, cChave, cDescr ) Class uTTable
AAdd( ::aIndex, {cIndex, cChave, cDescr } )
Return( nil )                             

//============================================================================================
// uTTable():Update() -                Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Atualiza o SX2, SX3 e SIX
//--------------------------------------------------------------------------------------------
// Parâmetros
// nil
//--------------------------------------------------------------------------------------------
// Retorno
// nil
//============================================================================================
Method Update() Class uTTable 
                      
Local cOrdem := "00"
Local cCampo := "" 
Local cChave := ""
Local cOrdem := ""
Local aArea  := GetArea() 
Local lNovo  := .t.
Local nLoop  
Local oField 

//--------------------------------------------------
// atualiza os registro do SX2
//--------------------------------------------------
dbSelectArea("SX2")
dbSetOrder(1)
If ! dbSeek( ::cRealAlias )
	RecLock("SX2",.T.)      
	SX2->X2_CHAVE   := ::cRealAlias
	SX2->X2_ARQUIVO := ::cRealAlias + SM0->M0_CODIGO + "0"
	SX2->X2_NOME    := ::cDescr
	SX2->X2_MODO    := ::cModo
	SX2->X2_MODOUN  := ::cModo
	SX2->X2_MODOEMP := ::cModo
	MsUnlock()                     
	
	::cLog += "INSERIDA TABELA " + ::cRealAlias + " no SX2 " + CRLF
	
EndIf

//--------------------------------------------------
// atualiza os registro do SX3
//--------------------------------------------------

dbSelectArea("SX3")
dbSetOrder(2) 
dbSeek("B1_COD")
cX3Obrigat := SX3->X3_OBRIGAT

// Captura a próxima ordem do registro
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek( ::cRealAlias )

While ! Eof() .and. SX3->X3_ARQUIVO == ::cRealAlias
	cOrdem := SX3->X3_ORDEM
	dbSkip()
Enddo
                                      
For nLoop := 1 to Len( ::aFields )
	
	oField := ::aFields[nLoop]
	cCampo := ::cRealAlias + oField:cField
   
   dbSelectArea("SX3")                
	dbSetOrder(2)
 	lNovo := ! dbSeek( cCampo )
   
	If lNovo
		cOrdem := Soma1( cOrdem ) 
	Else
		cOrdem := SX3->X3_ORDEM
	EndIf
	
	RecLock( "SX3", lNovo )
   SX3->X3_ARQUIVO := ::cRealAlias
   SX3->X3_ORDEM   := cOrdem
   SX3->X3_CAMPO   := cCampo
   SX3->X3_TIPO    := oField:cType
   SX3->X3_TAMANHO := oField:nSize
   SX3->X3_DECIMAL := oField:nDec
   SX3->X3_TITULO  := oField:cLabel
   SX3->X3_DESCRIC := oField:cLabel
   SX3->X3_PICTURE := oField:cPicture
   SX3->X3_VALID   := oField:cValid
   SX3->X3_F3      := oField:cF3
   SX3->X3_NIVEL   := 0                                                  
   SX3->X3_USADO   := if( oField:cField == "_FILIAL", "€€€€€€€€€€€€€€€", "€€€€€€€€€€€€€€" )
   SX3->X3_PROPRI  := "U"          
  	SX3->X3_RESERV  := "þÀ"
   
	If ! oField:lUsado   
   	SX3->X3_USADO := "€€€€€€€€€€€€€€€"
 	EndIf 
  
   SX3->X3_OBRIGAT := iif( oField:lObrigat , "€", " " )
   SX3->X3_BROWSE  := iif( oField:lBrowse  , "S", "N" )
   SX3->X3_VISUAL  := iif( oField:lReadOnly, "V", "A" ) 
   SX3->X3_CONTEXT := iif( oField:lVirtual , "V", "R" )
   SX3->X3_CBOX    := oField:cCBox 
   SX3->X3_GRPSXG  := Posicione("SX3",2,oField:cFieldGrp,"X3_GRPSXG")                 
	SX3->X3_ORTOGRA := "N"
	SX3->X3_IDXFLD  := "N"
	
	MsUnlock()
	
	If lNovo
		::cLog += "INCLUIDO CAMPO " + cCampo + " no SX3 " + CRLF
	Else
		::cLog += "ALTERADO CAMPO " + cCampo + " no SX3 " + CRLF
	EndIf
			
Next nLoop
                                  
//--------------------------------------------------
// atualiza sindex
//--------------------------------------------------
dbSelectArea("SIX")
dbSetOrder(1)
For nLoop := 1 to Len( ::aIndex )
	cChave := ::aIndex[nLoop,2]   
	cChave := StrTran( cChave, "_", ::cRealAlias+"_" )
	lNovo  := ! dbSeek( ::cRealAlias + ::aIndex[nLoop,1] ) 
	IF lNovo
		RecLock( "SIX", lNovo ) 
		SIX->INDICE    := ::cRealAlias
		SIX->ORDEM     := ::aIndex[nLoop,1]
		SIX->CHAVE     := cChave
		SIX->DESCRICAO := ::aIndex[nLoop,3]
		SIX->PROPRI    := "U"
		SIX->SHOWPESQ  := "S"
		MsUnlock()
		
		::cLog += "INCLUIDA CHAVE " + ::aIndex[nLoop,1]+" - "+cChave + " no SINDEX." + CRLF
	EndIf
	
Next nLoop

::cLog += CRLF

Return( nil ) 

//============================================================================================
// uTTable():Apply() -                 Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Aplica as atualizações no dicionario de dados ( SX2, SX3 e SINDEX )
//--------------------------------------------------------------------------------------------
// Parâmetros
// NIL
//--------------------------------------------------------------------------------------------
// Retorno
// nil
//============================================================================================
Method Apply() Class uTTable
                                       
__SetX31Mode( .F. )

// Garante que a tabela estará fechada
If Select( ::cRealAlias ) > 0
	dbSelectArea( ::cRealAlias )
	dbCloseArea()
EndIf
                             
X31UpdTable( ::cRealAlias )

If __GetX31Error()
	Alert( __GetX31Trace() )
	ApMsgStop( "Ocorreu um erro desconhecido durante a atualização da tabela : " + ::cRealAlias + ". Verifique a integridade do dicionário e da tabela.", "ATENÇÃO" ) 
	::cLog += "Ocorreu um erro desconhecido durante a atualização da estrutura da tabela : " + ::cRealAlias + CRLF
Else
	::cLog += "Tabela " + ::cRealAlias + " - " + ::cDescr + " atualizada com sucesso! " + CRLF
EndIf
		                                                                                                    
Return( nil )

//============================================================================================
// GetNextSx5() -                      Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Retorna a próxima tabela livre no SX5
// Funcionalidade semelhante a GetNextAlias()
//--------------------------------------------------------------------------------------------
// Parâmetros
// NIL
//--------------------------------------------------------------------------------------------
// Retorno
// Próximo código livre da tabela no SX5
//============================================================================================
Static Function GetNextSx5()

Local aArea    := GetArea()      
Local aAreaSX5 := SX5->(GetArea())
Local cRet     := ""

dbSelectArea("SX5")
dbSetOrder(1)
dbSeek( xFilial("SX5") + "00" )
While ! Eof() .and. xFilial("SX5") == SX5->X5_FILIAL .and. SX5->X5_TABELA == "00"

	If SubStr( SX5->X5_CHAVE,1,1 ) == "Z" 
		cRet := SubStr( SX5->X5_CHAVE,1,2 )
		Exit
	EndIf
	
	dbSkip()
	
Enddo                          

If ! Empty( cRet )
	cRet := "Z0"
Else
	While dbSeek( xFilial("SX5") + "00" + cRet )
		cRet := Soma1( cRet )
	Enddo
EndIf

RestArea( aAreaSX5 )
RestArea( aArea )

Return( cRet )

//============================================================================================
// GetNextSx2() -                      Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Retorna a próxima tabela livre no SX2
// Funcionalidade semelhante a GetNextAlias()
//--------------------------------------------------------------------------------------------
// Parâmetros
// NIL
//--------------------------------------------------------------------------------------------
// Retorno
// Próximo código livre da tabela no SX2
//============================================================================================
Static Function GetNextSX2( cAlias )

Local aArea := GetArea()
Local cRet  := cAlias
                       
dbSelectArea("SX2")
dbSetOrder(1)
While dbSeek( cRet )
	cRet := Soma1( cRet )
Enddo              

RestArea( aArea )
Return( cRet )

