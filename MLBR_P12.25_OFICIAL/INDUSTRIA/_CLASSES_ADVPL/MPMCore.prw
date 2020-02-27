#include "totvs.ch"
CLASS uCore
Method New() Constructor
Method Translate()  // Substitui as tags SQL ADVPL
Method ParseSql()   // Substitui as strings mais comuns
Method X3Label()    // Retorna o Label do campo no SX3  
Method X3Picture()  // Retorna o picture do campo no SX3  

ENDCLASS                                   

Method New() class uCore
Return( Self )

//============================================================================================
// uCore():ParseSql() -             Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Substitui as strings mais comuns nas querys de acordo com o banco de dados utilizado
// Concatenação deve ser sempre com ||
// Substring() pode ser tanto substr() quanto() substring()
//--------------------------------------------------------------------------------------------
// Parâmetros
// cSql - String com a query
//--------------------------------------------------------------------------------------------
// Retorno
// cRet - String com a query corrigida
//============================================================================================
Method ParseSql( cSql, aParam ) Class uCore

Local cRet     := cSql           

Default aParam := {}

If TCGetDb() == "MSSQL"
	cRet := StrTran(cRet,"SUBSTR(","SUBSTRING(") 
	cRet := StrTran(cRet,"NVL(","ISNULL(") 
	cRet := StrTran(cRet,"||","+")
EndIf                                    

If TCGetDb() == "ORACLE"
	cRet := StrTran(cRet,"SUBSTRING(","SUBSTR(") 
	cRet := StrTran(cRet,"ISNULL(","NVL(")
EndIf                                    

If TCGetDb() == "DB2"
	cRet := StrTran(cRet,"SUBSTRING(","SUBSTR(") 
	cRet := StrTran(cRet,"ISNULL(","COALESCE(")
EndIf              

cRet := Self:Translate( cRet, aParam )                      
                                      
Return( cRet )

//============================================================================================
// uCore():x3label() -             Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Retorna o X3_TITULO do campo informado
//--------------------------------------------------------------------------------------------
// Parâmetros
// cCampo - nome do campo
//--------------------------------------------------------------------------------------------
// Retorno
// cRet - label do campo
//============================================================================================
Method x3Label( cCampo ) Class uCore

Local aArea   := GetArea()
Local aAreaX3 := SX3->( GetArea() )
Local cRet    := " "

SX3->(dbSetOrder(2))
If SX3->( dbSeek( AllTrim(cCampo) ) )
	cRet := SX3->X3_TITULO
EndIf              

RestArea( aAreaX3 )
RestArea( aArea )
Return( cRet )  

//============================================================================================
// uCore():x3Picture() -             Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Retorna o X3_PICTURE do campo informado
//--------------------------------------------------------------------------------------------
// Parâmetros
// cCampo - nome do campo
//--------------------------------------------------------------------------------------------
// Retorno
// cRet - picture do campo
//============================================================================================
Method x3Picture( cCampo ) Class uCore

Local aArea   := GetArea()
Local aAreaX3 := SX3->( GetArea() )
Local cRet    := " "

SX3->(dbSetOrder(2))
If SX3->( dbSeek( AllTrim(cCampo) ) )
	cRet := SX3->X3_PICTURE
EndIf              

RestArea( aAreaX3 )
RestArea( aArea )
Return( cRet )

//============================================================================================
// uCore():Translate() -               Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Substitui as tags SQL ADVPL na string SQL
//--------------------------------------------------------------------------------------------
// Parâmetros
// cSql - String com a query ORIGINAL
//--------------------------------------------------------------------------------------------
// Retorno
// cRet - String com a query CORRIGIDA
//--------------------------------------------------------------------------------------------
// TAGS SQL ADVPL
// :PARAM:<NPARAM>    - Dado do parâmetro, convertido para string
// :TABLE:<CALIAS>    - RetSqlName( cAlias )
// :FILIAL:<CALIAS>   - xFilial( cAlias )
// :FIELD:<CFIELD>    - Nome do Campo
// :NODEL             - D_E_L_E_T_ = ' '
// :ISDEL             - D_E_L_E_T_ <> ' '
//============================================================================================
Method Translate( cSql, aParams ) Class uCore
           
Local cRet       := cSql           
Local cStr       := ""
Local cSubstitui := ""
Local cTable     := ""

Local nLoop      := 0
Local nPos       := 0

Default aParams  := {}

//-----------------------------   
// Faz o parse de :PARAM:
//-----------------------------
For nLoop := 1 to Len( aParams )
	Do Case
		Case ValType( aParams[nLoop] ) == "C"
			aParams[nLoop] := "'" + aParams[nLoop] + "'"
		Case ValType( aParams[nLoop] ) == "D"                
			aParams[nLoop] := "'" + DtoS( aParams[nLoop] ) + "'"
		Case ValType( aParams[nLoop] ) == "N"
			aParams[nLoop] := AllTrim(Str(aParams[nLoop]))
		Case ValType( aParams[nLoop] ) == "L"
			aParams[nLoop] := iif( aParams[nLoop], "true", "false" )
	EndCase            
                                                              
	// Substitui todas as partes contendo :PARAM:01, por exemplo, para o conteúdo de aParam[1]
	While ( nPos := At( ":PARAM:"+StrZero(nLoop,2), Upper(cRet) ) ) > 0
		cRet := SubStr(cRet, 1, nPos-1) + aParams[nLoop] + SubStr(cRet,nPos+9)
	Enddo
	
Next nLoop

//-----------------------------   
// Faz o parse de :TABLE:
//-----------------------------
While .t.

	nPos := At( ":TABLE:", Upper(cRet) )

	If Empty( nPos )
		Exit
	EndIf
	     
	cTable := SubStr( cRet, nPos+7,3 )
	cRet   := SubStr(cRet, 1, nPos-1) + u_AdvSqlName( cTable ) + SubStr(cRet,nPos+10 )

Enddo
             
//-----------------------------   
// Faz o parse de :FILIAL:
//-----------------------------
While .t.

	nPos := At( ":FILIAL:", Upper(cRet) )

	If Empty( nPos )
		Exit
	EndIf

	cTable := SubStr( cRet, nPos+8,3 )
	cRet   := SubStr(cRet, 1, nPos-1) + "'"+xFilial( u_AdvAlias( cTable ) )+"'" + SubStr(cRet,nPos+11 )

Enddo

//-----------------------------   
// Faz o parse de :FIELD:
//-----------------------------
        
While .t. 

	nPos := At( ":FIELD:", Upper(cRet) ) 
                                        
	If Empty( nPos )
		Exit
	EndIf

	cField := ""
	nPosA  := nPos+7

	While .t.           

		cField += SubStr(cRet,nPosA,1)
		nPosA  += 1 
		
		If nPosA > Len( cRet )
			Exit
		EndIf
		
		If SubStr( cRet, nPosA,1 ) $ " ()[]*+-/{}<>!@$%|&=^"
			Exit
		EndIf  

	Enddo 

	cField := Upper( Trim(cField) )      
	cField := u_AdvField( cField )
	cRet   := SubStr(cRet, 1, nPos-1) + cField + Iif( nPosA > Len(cRet),"", SubStr(cRet,nPosA ) )
   
	dummy  := nil 
	
Enddo

//-----------------------------   
// Faz o parse de :NODEL
//-----------------------------
While .t.

	nPos := At( ":NODEL", Upper(cRet) )

	If Empty( nPos )
		Exit
	EndIf

	cRet := SubStr(cRet, 1, nPos-1) + "D_E_L_E_T_ = ' '" + SubStr(cRet,nPos+6 )
Enddo

//-----------------------------   
// Faz o parse de :ISDEL
//-----------------------------
While .t.

	nPos := At( ":ISDEL", Upper(cRet) ) 

	If Empty( nPos )
		Exit
	EndIf

	cRet := SubStr(cRet, 1, nPos-1) + "D_E_L_E_T_ = '*'" + SubStr(cRet,nPos+6 )
Enddo


Return( cRet )                                      

//============================================================================================
// AdvAlias -                           Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Retorna o Alias real de uma tabela da ADVPL
//--------------------------------------------------------------------------------------------
// Parâmetros
// cAliasAdv - Alias original da ADVPL
//--------------------------------------------------------------------------------------------
// Retorno
// cAliasReal - Alias correspondente utilizado no sistema
//============================================================================================
User Function AdvAlias( cAliasAdv )

Local aArea      := GetArea()                   
Local cAliasReal := cAliasAdv
Local cTabAlias  := Trim(SuperGetMv( "ADVPLSX501",.f.,"  XXX" ))

dbSelectArea("SX5")
dbSetOrder(1)
If ! dbSeek( xFilial("SX5") + cTabAlias + cAliasAdv )
	// Assume que é uma tabela padrão do Protheus
	cAliasReal := cAliasAdv
Else
	// Esta tabela é criada pelo U_ADVPLUPD()
	cAliasReal := Trim( SX5->X5_DESCRI )                             
//	dbSelectArea( cAliasReal )
//	dbSeek( xFilial( cAliasReal ) )
EndIf                      

RestArea( aArea )

Return( cAliasReal )

//============================================================================================
// AdvField -                           Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Retorna o campo com o prefixo correto
//--------------------------------------------------------------------------------------------
// Parâmetros
// cCampo - Campo com o alias original ADVPL - Exemplo "ZZ1_CUSTO"
//--------------------------------------------------------------------------------------------
// Retorno
// cRet   - Campo com o alias utilizado no cliente. Exemplo "ZZ2_CUSTO"
//============================================================================================
User Function AdvField( cCampo )
                  
Local cPrefixo   := SubStr( cCampo, 1, At("_",cCampo)-1 )
Local cRealAlias := u_AdvAlias( cPrefixo )
Local cRet       := cRealAlias + SubStr( cCampo, At("_",cCampo) )

cRet := Upper( cRet )

Return( cRet )

//============================================================================================
// AdvSqlName -                        Alessandro Freire                        - Abril / 2015
//--------------------------------------------------------------------------------------------
// Descrição
// Retorna o RetSqlName() com o Alias Correto
//--------------------------------------------------------------------------------------------
// Parâmetros
// cAlias - Alias original da ADVPL - EX.: U_UADVSQL( "ZZ1" )
//--------------------------------------------------------------------------------------------
// Retorno
// cRet   - Nome da tabela com o nome correto. - EX.: "ZZ2010"
//============================================================================================
User Function AdvSqlName( cAlias )
                                                              
Local cRealAlias := u_AdvAlias( cAlias ) 
Local cRet       := RetSqlName( cRealAlias )

Return( cRet )