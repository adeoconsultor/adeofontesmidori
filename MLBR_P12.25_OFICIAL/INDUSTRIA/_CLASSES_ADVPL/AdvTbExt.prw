#include "totvs.ch"

//-------------------------------------------------------------        
// Classe para tratamento de tabelas externas ao Protheus
//-------------------------------------------------------------
      
Class AdvTbExt

Data cAlias 
Data aStruct  
Data aIndex
Data cTableName
Data lShared
Data cDescTab

Method New( cTableName, lEmpresa, cDescTab ) Constructor      
//-------------------------------------------------
// Métodos para trabalhar com arquivo temporário
// no banco de dados
//-------------------------------------------------
Method NewTmp( aStruct ) Constructor
Method AddIndex( cIndexKey )
Method DelTmp()

//-------------------------------------------------
//-------------------------------------------------
Method Alias()

Method Bof()

Method ClassName()
Method CloseArea() // fecha a area
Method CreateTable( aStruct, aIndex ) // Cria a tabela

Method dbDelete()
Method dbGoBottom()
Method dbGoto()
Method dbGoTop()
Method dbSeek()
Method dbSetOrder()
Method dbSkip()

Method Eof()

Method FieldPos()
Method FieldPut()

Method GetField()
Method Grava()

Method IndexKey()
Method IndexOrd()
Method IsOpen()    // .t. caso a area esteja aberta

Method LastRec()

Method Modify()    // Modifica uma tabela que já existe

Method Reindex()   // Reindexa a tabela criada pelo CreateTable
Method RecCount()
Method Recno()

Method SetIndex()           

Method Tam() // Retorna o tamanho do campo
Method TableName()

Method UseArea()   // abre a tabela em uma área

EndClass
               
************************************************************************************************
// Construtor da classe para tabelas temporárias
************************************************************************************************
Method NewTmp( aStruct, aIndex ) Class AdvTbExt
                       
Local cNext := Dtos(dDataBase)+"_"+StrTran(Time(),":","")+"_"+AllTrim( Str(Randomize(1,32767)) )
Default aIndex := {}
                      
Self:aStruct    := aStruct
Self:aIndex     := aIndex
Self:lShared    := .t.
Self:cAlias     := "ADTMP_"+cNext
Self:cTableName := Self:cAlias

//----------------------------------------------------
// Cria a tabela no banco e seus respectivos indices
//----------------------------------------------------
Self:CreateTable( aStruct, aIndex, .t. )

//----------------------------------------------------
// Fecha a área aberta exclusiva e a reabre em modo
// compartilhado
//----------------------------------------------------
Self:CloseArea()
Self:UseArea()
                         
Return( Self )

************************************************************************************************
// Apaga o arquivo temporário
************************************************************************************************
Method DelTmp() Class AdvTbExt

Self:CloseArea()
MsErase( Self:cTableName,nil,"TOPCONN")

Return( nil ) 


************************************************************************************************
// Construtor da Classe 
// cTableName - Nome desejado para a tabela. 
// lEmpresa   - .t. - adiciona o código da empresa no nome < default >
//              .f. - não adiciona o código da empresa no nome da tabela
// ESTA CLASSE CRIA TODAS AS TABELAS COM O PREFIXO AD_ + <cTableName> [ + <codigo da empresa> ] 
// ESTA CLASSE CRIA TODOS INDICES COM O PREFIXO AD_ + <cTableName> [ + <codigo da empresa> ] + "_" + <sequencial>
************************************************************************************************
Method New( cTableName, lEmpresa, cDescTab, cAlias ) Class AdvTbExt
                                 
Default lEmpresa  := .t.
Default cDescTab  := ""
Default cAlias    := Upper( Trim(cTableName) )

//------------------------------------------------
// Tabelas externas da ADVPL devem sempre ter
// o prefixo AD_
//------------------------------------------------
cTableName := Upper( Trim(cTableName) )

If SubStr( cTableName,1,3 ) <> "AD_" 
	cTableName := "AD_" + cTableName
EndIf                           

//------------------------------------------------
// Define o alias que será utilizado pela classe
//------------------------------------------------
Self:cAlias    := cTableName

//------------------------------------------------
// Cria a tabela de descrição de tabela AD_A01
// Similar ao SX2
//------------------------------------------------
If ! Empty( cDescTab )
	AdvTbTab()
	AdvAdTab( cAlias, cDescTab )
EndIf

//------------------------------------------------
// Cria a tabela de índices AD_INDEX
// Similar ao SINDEX
//------------------------------------------------
AdvTbInd()
  
//------------------------------------------------
// Verifica se deve ser adicionado o código da
// empresa corrente no nome da tabela
//------------------------------------------------
If lEmpresa
	cTableName := cTableName + "_" + FwCodEmp()
EndIf
      
Self:cTableName := cTableName
Self:aStruct    := {}
Self:aIndex     := AdvGetIndex( Self:Alias() )

Self:lShared    := .t.    


Return( Self )

************************************************************************************************
// Cria a tabela de dados
// o tamanho máximdo nome do campo deve obedecer a regra do Protheus. 10 bytes.
************************************************************************************************
Method CreateTable( aStruct, aIndex, lTemp ) Class AdvTbExt  

Local cTabela := Self:TableName()    
Local aArea   := GetArea()                   

Local nLoop

Local cIndexName
Local cIndexKey 

Default aIndex  := {}
Default aStruct := {}
Default lTemp   := .f.

//------------------------------------------
// Encerra o Protheus se estrutura vazia
//------------------------------------------
If Empty( aStruct )
	Final( "Array de Estrutura vazio" )
EndIf

If ! lTemp
	//------------------------------------------
	// Adiciona os índices em AD_INDEX
	//------------------------------------------
	For nLoop := 1 to Len( aIndex )
		AdvAdIndex( Self:Alias(), StrZero(nLoop,2), aIndex[nLoop] )
	Next nLoop
	Self:aIndex := AdvGetIndex( Self:Alias() )
Else
	//------------------------------------------
	// Indice de tabela temporária
	//------------------------------------------
	Self:aIndex := aClone( aIndex )
EndIf
                    
//---------------------------------------------
// Cria a tabela no banco de dados somente se
// não estiver criada
//---------------------------------------------
If ! MsFile(cTabela,,"TOPCONN")

	MsCreate( cTabela, aStruct, "TOPCONN" )

	If ! MsFile(cTabela,,"TOPCONN")
		Final("Tabela " + cTabela + "não foi criada.")
	Else                  
		//------------------
		// cria os índices  
		//------------------
		Self:Reindex()
	EndIf        
Else                                           
	//-----------------------------------------
	// Modifica a tabela somente se necessário
	//-----------------------------------------
	Self:Modify( aStruct )
Endif                     
                             
Self:CloseArea()
RestArea( aArea )

Return( nil ) 

************************************************************************************************
// Verifica a necessidade de modificação da estrutura da tabela
************************************************************************************************
Method Modify( aStruct ) Class AdvTbExt

Local aOldStru := {}
Local aNewStru := {}
Local nTopErr  := 0

Local nLoop

Self:UseArea(.f.,.f.)
aOldStru := dbStruct()
                    
If ValType( aStruct ) <> "A" .or. Empty( aStruct )
	aNewStru := dbStruct()
Else
	aNewStru := aStruct
EndIf

//---------------------------------------------------------
// fecha a tabela para que o TCAlter() possa ser executado
//---------------------------------------------------------
Self:CloseArea()

lRet := TCAlter( Self:cTableName, aOldStru, aNewStru, @nTopErr )

If !lRet
	ApMsgAlert(tcSqlError(),"AdvTbExt():Modify() - Erro")
	Final("Erro na alteração da tabela " + Self:cTableName )
Else                    
	//-----------------------
	// Recria os índices
	//-----------------------
	Self:Reindex()
Endif

Return( nil )

************************************************************************************************
// Cria os índices para as tabelas
// lForce - .t. indexa sempre <default>, .f. - somente se não existir
************************************************************************************************
Method Reindex() Class AdvTbExt
            
Local lHasIndex  // tem arquivo de indice
Local nLoop                
Local cIndexName
Local cIndexKey  
Local lShared   := .f.
Local lIndex    := .f.
Local aArea     := GetArea()

Self:CloseArea()
Self:UseArea(lShared,lIndex)
 
For nLoop := 1 to Len( Self:aIndex )

	cIndexName := Self:TableName()+"_"+StrZero( nLoop,2 ) 
	cIndexKey  := Self:aIndex[nLoop]
	lHasIndex  := MsFile( Self:TableName(), cIndexName, "TOPCONN" )
	                                       
	//----------------------------------------------------------------
	// Se não tem o índice criado para tabela
	//----------------------------------------------------------------
	If ! lHasIndex
		dbCreateIndex( cIndexName, cIndexKey, , .f. )
	EndIf
	
Next nLoop   

Self:CloseArea()
RestArea( aArea )

Return( nil )

************************************************************************************************
// Seta os índices na tabela para poder utilizar o dbSetOrder() 
************************************************************************************************
Method SetIndex() Class AdvTbExt

Local nLoop, cIndexName

For nLoop := 1 to Len( Self:aIndex )
	cIndexName := Self:TableName()+"_"+StrZero( nLoop,2 ) 
	dbSetIndex( cIndexName  )
Next nLoop   

Return( nil )
************************************************************************************************
// Abre uma área para a tabela 
************************************************************************************************
Method UseArea(lShared,lIndex) Class AdvTbExt
  
Local lNewArea   := .t.
Local cDriver    := "TOPCONN"
Local lReadOnly  := .f.

Default lShared  := .t. 
Default lIndex   := .t.

If ! lShared
	lReadOnly := .t.
EndIf                                                                                  

//--------------------------------------------------
// Verifica a necessidade de se rodar o update
// da Advpl para criação da tabela
//--------------------------------------------------
If ! MsFile( Self:cTableName,,"TOPCONN" )
	apMsgAlert("Tabela " +Self:cTableName+ " não foi criada. Execute o update da AdvPl Tecnologia" )
	Final( "Tabela " +Self:cTableName+ " não foi criada. Execute o update da Advpl Tecnologia" )
EndIf                 
                                                
//--------------------------------------------------
// Se o Alias estiver aberto, só seleciona a area
//--------------------------------------------------
If Self:IsOpen()

	If Self:lShared <> lShared
		Self:CloseArea()
		dbUseArea(lNewArea, cDriver, Self:cTableName, Self:cAlias, lShared, lReadOnly )
		If lIndex
			Self:SetIndex()
		EndIf
	EndIf                     
	
	dbSelectArea( Self:cAlias )	
	
Else
                                     
	//--------------------------------------
	// Se a área não estiver aberta, abre
	//--------------------------------------
	dbUseArea(lNewArea, cDriver, Self:TableName(), Self:Alias(), lShared, lReadOnly )
	If lIndex
		Self:SetIndex()
	EndIf
	
EndIf                          

Self:lShared := lShared

//---------------------------------------------------------------
	// Se não conseguiu abrir a área, fecha o Protheus para evitar
// erros.
//---------------------------------------------------------------
If Alias() <> Self:Alias()
	Final("Não foi possível abrir a tabela " + Self:TableName() )
EndIf

//dbGoTop()
                               
Return( nil )  

************************************************************************************************
// Fecha a área aberta pelo método usearea
************************************************************************************************
Method CloseArea() Class AdvTbExt

If Self:IsOpen()
	dbSelectArea( Self:cAlias )
	dbCloseArea()
EndIf

Return( nil )                

************************************************************************************************
// Verifica se a área está aberta
************************************************************************************************
Method IsOpen() Class AdvTbExt
Local lRet := ( Select( Self:cAlias ) > 0 )
Return( lRet )                   

************************************************************************************************
// Retorna o Alias
************************************************************************************************
Method Alias() Class AdvTbExt
Return( Self:cAlias )

************************************************************************************************
// Retorna o Alias
************************************************************************************************
Method dbSkip( nSkipper ) Class AdvTbExt
Default nSkipper := 1
(Self:cAlias)->(dbSkip(nSkipper))
Return( nil )

************************************************************************************************
// Vai para determinado registro
************************************************************************************************
Method dbGoto(nGoTo) Class AdvTbExt
Default nGoto := Self:Recno()
(Self:cAlias)->(dbGoTo(nGoTo))
Return( nil )

************************************************************************************************
// Verifica se está em EOF()
************************************************************************************************
Method Eof() Class AdvTbExt
Local lEof := (Self:cAlias)->(Eof())
Return( lEof )

************************************************************************************************
// Verifica se está em BOF()
************************************************************************************************
Method Bof() Class AdvTbExt
Local lBof := (Self:cAlias)->(Bof())
Return( lBof )

************************************************************************************************
// Verifica o registro posicionado
************************************************************************************************
Method Recno() Class AdvTbExt
Local nRecno := (Self:cAlias)->(Recno())
Return( nRecno )                  

************************************************************************************************
// Vai para o inicio da tabela
************************************************************************************************
Method dbGoTop() Class AdvTbExt
(Self:cAlias)->(dbGoTop())
Return( nil )       

************************************************************************************************
// Vai para o fim da tabela
************************************************************************************************
Method dbGoBottom() Class AdvTbExt
(Self:cAlias)->(dbGoBottom())
Return( nil )       
           
************************************************************************************************
// RecCount()
************************************************************************************************
Method RecCount() Class AdvTbExt
(Self:cAlias)->(RecCount())
Return( nil )       


************************************************************************************************
// LastRec()
************************************************************************************************
Method LastRec() Class AdvTbExt
(Self:cAlias)->(LastRec())
Return( nil )       
                       
************************************************************************************************
// FieldPos()
************************************************************************************************
Method FieldPos( cField ) Class AdvTbExt

Local nRet     := 0
Default cField := ""

nRet := (Self:cAlias)->(FieldPos( cField ))

Return( nRet )       

************************************************************************************************
// dbSetOrder()
************************************************************************************************
Method dbSetOrder( nOrder ) Class AdvTbExt 

(Self:cAlias)->(dbSetOrder( nOrder ))

Return( nil )

************************************************************************************************
// IndexOrd()
************************************************************************************************
Method IndexOrd() Class AdvTbExt 

(Self:cAlias)->(IndexOrd())

Return( nil )

************************************************************************************************
// IndexKey()
************************************************************************************************
Method IndexKey() Class AdvTbExt 

(Self:cAlias)->(IndexKey())

Return( nil )

************************************************************************************************
// IndexKey()
************************************************************************************************
Method dbSeek( cSeek, lSoftSeek ) Class AdvTbExt 

Default cSeek     := " "
Default lSoftSeek := .f.

(Self:cAlias)->(dbSeek(cSeek,lSoftSeek))

Return( nil )

************************************************************************************************
// IndexKey()
************************************************************************************************
Method ClassName( ) Class AdvTbExt 

Return( "AdvTbExt" )
                         
************************************************************************************************
// Retorna o nome físico da Tabela
************************************************************************************************
Method TableName() Class AdvTbExt 

Return( Self:cTableName )

************************************************************************************************
// Grava um campo
************************************************************************************************
Method Grava( cField, xValue ) Class AdvTbExt 

Local nField := Self:FieldPos( cField )

If Valtype( xValue ) == "D"
	xValue := DtoS( xValue )
EndIf

Self:FieldPut( nField, xValue )             

Return( nil )

************************************************************************************************
// FieldPut
************************************************************************************************
Method FieldPut( nField, xValue ) Class AdvTbExt 
                         
(Self:cAlias)->(FieldPut( nField, xValue ))                         
             
Return( nil )            

************************************************************************************************
// dbDelete
************************************************************************************************
Method dbDelete() Class AdvTbExt 
(Self:cAlias)->(dbDelete())
Return( nil )


************************************************************************************************
// GetField()
************************************************************************************************
Method GetField( cCampo ) Class AdvTbExt
Local nPos := 0
Local xRet := nil

cCampo := Upper(cCampo) 
nPos   := Self:FieldPos( cCampo )
xRet   := (Self:cAlias)->( FieldGet( nPos ) )

Return( xRet )

************************************************************************************************
// Tam() - Tamanho de um campo
************************************************************************************************
Method Tam( cCampo ) Class AdvTbExt

Local bBlock, nTam

Self:UseArea()

bBlock := "{|| Len( "+Self:cAlias+"->"+Upper(Trim(cCampo))+" ) }"
bBlock := &(bBlock)

nTam := Eval( bBlock )

Return( nTam )
//============================================================================
// AdvTbTab - Alessandro Freire - Fevereiro / 2016
//----------------------------------------------------------------------------
// Descrição
// Cria tabela para armazenar a descrição das tabelas da ADVPL
// ADVPL
//----------------------------------------------------------------------------
// Parâmetros
// nil
//----------------------------------------------------------------------------
// Retorno
// nil
//============================================================================
Static Function AdvTbTab()
	
	Local cTabela := "AD_A01"
	Local aArea   := GetArea()
	Local aStruct := {}
	Local cIndexName, cIndexKey
	
	//---------------------------------------------
	// Cria a tabela no banco de dados somente se
	// não estiver criada
	//---------------------------------------------
	If ! MsFile(cTabela,,"TOPCONN")
		
		AAdd( aStruct, {"A01_ALIAS" ,"C",  30,0} )
		AAdd( aStruct, {"A01_DESCRI","C", 254,0} )
	
		MsCreate( cTabela, aStruct, "TOPCONN" )
		
		If ! MsFile(cTabela,,"TOPCONN")
			Final("Tabela " + cTabela + "não foi criada.")
		EndIf
		
		cIndexName := cTabela+"_01"
		cIndexKey  := "A01_ALIAS"
		
		dbUseArea(.t., "TOPCONN", "AD_A01", "AD_A01", .F., .T. )
		dbCreateIndex( cIndexName, cIndexKey, , .f. )
		dbCloseArea()
		
	EndIf
	
	RestArea( aArea )
	
Return( nil )

//============================================================================
// AbreA01 - Alessandro Freire - Fevereiro / 2016
//----------------------------------------------------------------------------
// Descrição
// Abre a tabela AD_A01
//
//----------------------------------------------------------------------------
// Parâmetros
// nil
//----------------------------------------------------------------------------
// Retorno
// nil
//============================================================================
Static Function AbreA01()
	If Select("AD_A01") > 0
		dbSelectArea("AD_A01")
	Else
		dbUseArea(.t.,"TOPCONN","AD_A01","AD_A01",.T.,.F.)
		dbSetIndex("AD_A01_01")
	EndIf
	dbSetOrder(1)
Return(nil)


//============================================================================
// AdvAdTab - Alessandro Freire - Fevereiro / 2016
//----------------------------------------------------------------------------
// Descrição
// Adiciona um registro na tabela AD_A01
//----------------------------------------------------------------------------
// Parâmetros
// nil
//----------------------------------------------------------------------------
// Retorno
// nil
//============================================================================
Static Function AdvAdTab( cAlias, cDescricao )
	
	Local aArea  := GetArea()
	cAlias := Upper( cAlias )
	AbreA01()
	cAlias := PadR(Trim(cAlias),Len(AD_A01->A01_ALIAS)," " )
	If ! dbSeek( cAlias )
		RecLock("AD_A01",.T.)
		AD_A01->A01_ALIAS  := cAlias
		AD_A01->A01_DESCRI := cDescricao
		MsUnlock()
	EndIf
	
	RestArea( aArea )

Return( nil )

//============================================================================
// AdvTbInd - Alessandro Freire - Fevereiro / 2016
//----------------------------------------------------------------------------
// Descrição
// Cria tabela para gerenciamento dos índices das tabelas proprietárias da
// ADVPL
//----------------------------------------------------------------------------
// Parâmetros
// nil
//----------------------------------------------------------------------------
// Retorno
// nil
//============================================================================
Static Function AdvTbInd()
	
	Local cTabela := "AD_INDEX"
	Local aArea   := GetArea()
	Local aStruct := {}
	Local cIndexName, cIndexKey
	
	//---------------------------------------------
	// Cria a tabela no banco de dados somente se
	// não estiver criada
	//---------------------------------------------
	If ! MsFile(cTabela,,"TOPCONN")
		
		AAdd( aStruct, {"IND_ALIAS","C", 30,0} )
		AAdd( aStruct, {"IND_ORDEM","C",  2,0} )
		AAdd( aStruct, {"IND_CHAVE","C",254,0} )
	
		MsCreate( cTabela, aStruct, "TOPCONN" )
		
		If ! MsFile(cTabela,,"TOPCONN")
			Final("Tabela " + cTabela + "não foi criada.")
		EndIf
		
		cIndexName := cTabela+"_01"
		cIndexKey  := "IND_ALIAS+IND_ORDEM+IND_CHAVE"
		
		dbUseArea(.t., "TOPCONN", "AD_INDEX", "INDEX", .F., .T. )
		dbCreateIndex( cIndexName, cIndexKey, , .f. )
		dbCloseArea()
		
	EndIf
	
	RestArea( aArea )
	
Return( nil )

//============================================================================
// AdvAdInd - Alessandro Freire - Fevereiro / 2016
//----------------------------------------------------------------------------
// Descrição
// Adiciona um registro de índice na tabela AD_INDEX
//----------------------------------------------------------------------------
// Parâmetros
// nil
//----------------------------------------------------------------------------
// Retorno
// nil
//============================================================================
Static Function AdvAdIndex( cAlias, cOrdem, cChave )
	
	Local aArea  := GetArea()
	
	AbreIndex()
	cAlias := PadR(Trim(cAlias),Len(INDEX->IND_ALIAS)," " )
	If ! dbSeek( cAlias + cOrdem )
		RecLock("INDEX",.T.)
		INDEX->IND_ALIAS := cAlias
		INDEX->IND_ORDEM := cOrdem
		INDEX->IND_CHAVE := cChave
		MsUnlock()
	EndIf
	
	RestArea( aArea )

Return( nil )

//============================================================================
// AbreIndex - Alessandro Freire - Fevereiro / 2016
//----------------------------------------------------------------------------
// Descrição
// Abre a tabela de índices proprietária da ADVPL Tecnologia
//
//----------------------------------------------------------------------------
// Parâmetros
// nil
//----------------------------------------------------------------------------
// Retorno
// nil
//============================================================================
Static Function AbreIndex()
	If Select("INDEX") > 0
		dbSelectArea("INDEX")
	Else
		dbUseArea(.t.,"TOPCONN","AD_INDEX","INDEX",.T.,.F.)
		dbSetIndex("AD_INDEX_01")
	EndIf
	dbSetOrder(1)
Return(nil)

//============================================================================
// AdvGetInd - Alessandro Freire - Fevereiro / 2016
//----------------------------------------------------------------------------
// Descrição
// carrega os índices da tabela AD_INDEX
//----------------------------------------------------------------------------
// Parâmetros
// nil
//----------------------------------------------------------------------------
// Retorno
// nil
//============================================================================
Static Function AdvGetIndex( cAlias )

Local aArea := GetArea()
Local aRet  := {}

AbreIndex()
dbSeek( Trim(cAlias) )
While ! Eof() .and. Trim(cAlias) == Trim(INDEX->IND_ALIAS)
	AAdd( aRet, INDEX->IND_CHAVE )
	dbSkip()
Enddo

RestArea( aArea )
Return( aRet )