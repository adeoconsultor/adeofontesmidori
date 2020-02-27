#INCLUDE "TOTVS.CH"

User Function TESTE001()
Local lRet 			:= 	.t.
Local lCanSave		:=	.F.
Local lUserSave		:=	.F.
Local lCentered		:= 	.t.
Local aPergs		:=	{}  
Local aRetParam		:=	{}        
Local bError 	:= ErrorBlock( { |e| MsgInfo( e:Description ) } )


aAdd( aPergs , { 01 , "Fornecedor de" , Space(TamSx3('A2_COD')[1])		, ''		, '.t.' ,'SA2'  , '.t.' , 50 , .f. } )
aAdd( aPergs , { 01 , "Loja de" , Space(TamSx3('A2_LOJA')[1])			, ''		, '.t.' ,''     , '.t.' , 25 , .f. } )
aAdd( aPergs , { 01 , "Fornecedor ate" , Space(TamSx3('A2_COD')[1])		, ''		, '.t.' ,'SA2'  , '.t.' , 50 , .f. } )
aAdd( aPergs , { 01 , "Loja ate" , Space(TamSx3('A2_LOJA')[1])			, ''		, '.t.' ,''     , '.t.' , 25 , .f. } )
aAdd( aPergs , { 01 , "Data de" , dDataBase								, ''		, '.t.' , 		, '.t.' , 50 , .F. } )
aAdd( aPergs , { 01 , "Data ate" , dDataBase                     		, ''		, '.t.' , 		, '.t.' , 50 , .T. } )
aAdd( aPergs , { 02 , "Tipo Exportação" ,'Data Emissão', {"Data Emissão","Data Digitação"}		, 100 ,'.t.' , .T. } )
aAdd( aPergs , { 06 , "Diretório de Gravação" 							, ""		, '' 	, '' 	,'' 	, 90 , .t., ""	,"", GETF_LOCALHARD+GETF_RETDIRECTORY } )
aAdd( aPergs , { 02 , "Exportar XML ou Danfe?" ,'XML', {"XML","DANFE","AMBOS"}					, 100 ,'.t.' , .T. } )
aAdd( aPergs , { 02 , "Tipo Documento" ,'Todos', {"Todos","NF-e","CANC","CC-e","CT-e","CTEC"}	, 100 ,'.t.' , .T. } )
    
If ParamBox( aPergs , "Exportação em Lote" , @aRetParam , { || .t. } , , lCentered , 0 , 0 , , 'MONNF001' , lCanSave , lUserSave )
    cFoExpLD := aRetParam[01]
    cLoExpLD := aRetParam[02]
    cFoExpLA := aRetParam[03]
    cLoExpLA := aRetParam[04]
    dDtExpLD := aRetParam[05]
    dDtExpLA := aRetParam[06]
    cTpExp   := aRetParam[07]
    cDirExpL := aRetParam[08]
    cTpArq 	 := aRetParam[09]
    cTpDoc	 := aRetParam[10]		
Else
    lRet := .F.    	
EndIf

ErrorBlock(bError)

Return( Nil )