#include "totvs.ch"

#define POS_RECNO      1
#define POS_ALIAS      2
#define POS_FIELDNAME  3
#define POS_OLDVALUE   4
#define POS_NEWVALUE   5
#define POS_FIELDPOS   6
#define POS_KEY        7
#define POS_ORDER      8

CLASS uLogField                                     

Data aSavRecs
Data cId
        
Method New() Constructor
Method SetId() // Gera o ID da Transação
Method GetRecs() // Captura os registros e os salva em ::aSavRecs
Method SaveRecs() // Salva as Alterações efetuadas nos registros
Method ClearRecs() // Limpa o array ::aSavRecs
Method Show() // Mostra a dialog 
ENDCLASS

//===================================================================================================
// Construtor do método
//===================================================================================================
Method New() Class uLogField

::aSavRecs:= {}
::cID     := "" 

Return( Self )
              
//===================================================================================================
// Pega o conteúdo de um campo e o salva em um array
//===================================================================================================
Method GetRecs( lAfter, cAlias, nOrdem ) Class uLogField

Local aRet      := {} 
Local aArea     := GetArea()
Local aAreaTab  := {}
Local nPos      := 0                   
Local bBlock  
Local nLoop 
       
Default lAfter  := .f. 
Default cAlias  := Alias()
Default nOrdem  := 1

aAreaTab := (cAlias)->(GetArea())

// Define o ID da Transação
::SetId()      

( cAlias )->(dbSetOrder(nOrdem))

For nLoop := 1 to (cAlias)->( FCount() )
	
	// Verifica se já existe a informação. Se já existir, grava somente o novo valor.
	// Se não existir, grava os dados do registro.
	bBlock := {|x| x[POS_RECNO] == (cAlias)->(Recno()) .and. x[POS_ALIAS] == cAlias .and. x[POS_FIELDNAME] == (cAlias)->(FieldName(nLoop)) }
	nPos   := aScan( ::aSavRecs, bBlock )
	If Empty( nPos )
		AAdd( ::aSavRecs, { Recno()              ,; // registro
              cAlias                             ,; // alias
		      FieldName(nLoop)                   ,; // nome do campo
		      iif( lAfter, nil, FieldGet(nLoop) ),; // conteudo anterior
		      iif( lAfter, FieldGet(nLoop), nil ),; // conteudo novo
		      nLoop                              ,; // posição do campo na tabela - FieldPos()
		      &(IndexKey())                      ,; // Chave de pesquisa
		      nOrdem } )                            // Ordem da chave de pesquisa
	Else
		If lAfter
			::aSavRecs[nPos,POS_NEWVALUE] := FieldGet(nLoop)
		EndIf
	EndIf
	
Next nLoop

RestArea( aAreaTab )
RestArea( aArea )  
                                                 
Return( nil )

//===================================================================================================
// SaveRecs - Salva as alterações no registro de Log
//===================================================================================================
Method SaveRecs(nOperation,cTxtLog) Class uLogField

Local cChave  := ""                        
Local cTitulo := ""
Local cStr    := ""                          
Local cAlias  := Alias()
Local cKey    := &(IndexKey())     
Local nOrder  := IndexOrd()
Local nLoop   := 1

Local aArea   := GetArea()
Local lNewRec := .t.
  
Default cTxtLog   := "" 

// Define o ID da Transação
::SetId()      
                   
// Se o valor anterior estiver igual a nil significa que é uma inclusão
If Empty( cTxtLog )
	If Empty(::aSavRecs) .or. ValType(::aSavRecs[1,POS_OLDVALUE]) == "U"
		nOperation := 3
	EndIf
EndIf

Do Case
	Case nOperation == 3                           
		cStr    := "+=====================+" + CRLF
		cStr    += "|  Registro Incluído  |"+CRLF
		cStr    += "+=====================+" + CRLF
	Case nOperation == 5             
		cStr    := "+=====================+" + CRLF
		cStr    += "|  Registro Excluído  |"+CRLF
		cStr    += "+=====================+" + CRLF
	Case nOperation == 4                    
		cStr    := "+=====================+" + CRLF
		cStr    += "|  Registro Alterado  |"+CRLF        
		cStr    += "+=====================+" + CRLF 
EndCase
                                          
// Quando for uma inclusão, grava direto no ZB3,
// sem ter que verificar ::aSavRecs
If ! Empty( cTxtLog ) .or. nOperation == 3
	cTxtLog := cStr + cTxtLog
EndIf

If Empty( cTxtLog )
	For nLoop := 1 to Len( ::aSavRecs )
            
		// Se os campos forem iguais, não faz nada
		If ::aSavRecs[nLoop,POS_OLDVALUE] == ::aSavRecs[nLoop,POS_NEWVALUE]
			Loop
		EndIf                                                 
	            
		// Edição em campo memo não salva
		If ValType( ::aSavRecs[nLoop, POS_OLDVALUE ] ) == "M" .or. ValType( ::aSavRecs[nLoop, POS_NEWVALUE ] ) == "M"
			Loop
		EndIf

		// Grava os campos que sofreram alteração, foram incluídos ou excluídos
		If Str(::aSavRecs[nLoop,POS_RECNO])+::aSavRecs[nLoop,POS_ALIAS]+::aSavRecs[nLoop,POS_KEY] <> cChave
		    
			// Destrava o registro de log
			ZB3->(MsUnLock())
		
			cChave := Str(::aSavRecs[nLoop,POS_RECNO])+::aSavRecs[nLoop,POS_ALIAS]+::aSavRecs[nLoop,POS_KEY]
			
		    dbSelectArea("ZB3")
		    dbSetOrder(1)
		    lNewRec := .t.
		    If dbSeek( xFilial("ZB3") + ::cId + ::aSavRecs[nLoop,POS_ALIAS] + Trim(::aSavRecs[nLoop,POS_KEY]) )
		    	lNewRec := .f.
		    EndIf

			RecLock("ZB3",lNewREc)
			ZB3->ZB3_FILIAL := xFilial("ZB3")
			ZB3->ZB3_ID     := ::cId
			ZB3->ZB3_ALIAS  := ::aSavRecs[ nLoop, POS_ALIAS ]
			ZB3->ZB3_ORDER  := ::aSavRecs[ nLoop, POS_ORDER ]
			ZB3->ZB3_CHAVE  := Trim( ::aSavRecs[ nLoop, POS_KEY ] )
			ZB3->ZB3_USNAME := cUserName
			ZB3->ZB3_DATA   := dDataBase
			ZB3->ZB3_HORA   := SubStr(Time(),1,5)
		EndIf                                                

	    SX3->( dbSetOrder(2) ) 
	    cTitulo := ""
	    If SX3->( dbSeek( ::aSavRecs[nLoop, POS_FIELDNAME] ) )
	    	cTitulo := "("+Trim(SX3->X3_TITULO)+")"
	    EndIf
	
		If ::aSavRecs[nLoop,POS_OLDVALUE] <> ::aSavRecs[nLoop,POS_NEWVALUE]
		    cStr += Repl("_",60) + CRLF
			cStr += "Campo : " + ::aSavRecs[nLoop,POS_FIELDNAME] + " " + cTitulo + CRLF
			cStr += "Antigo: "                                  
			xVarNew := ::aSavRecs[nLoop,POS_NEWVALUE]
			Do Case
				Case ValType( ::aSavRecs[nLoop,POS_OLDVALUE] ) == "C"
					xVarNew := if(ValType(xVarNew)=="U","", xVarNew)
					cStr += ::aSavRecs[nLoop,POS_OLDVALUE]       + CRLF
					cStr += "Novo  : "
					cStr += xVarNew       + CRLF 
					
				Case ValType( ::aSavRecs[nLoop,POS_OLDVALUE] ) == "N"    
					xVarNew := if(ValType(xVarNew)=="U",0, xVarNew)
					cStr += Str(::aSavRecs[nLoop,POS_OLDVALUE])  + CRLF
					cStr += "Novo  : "
					cStr += Str(xVarNew)  + CRLF   
					
				Case ValType( ::aSavRecs[nLoop,POS_OLDVALUE] ) == "D"    
					xVarNew := if(ValType(xVarNew)=="U",CtoD(""), xVarNew)
					cStr += DtoC(::aSavRecs[nLoop,POS_OLDVALUE]) + CRLF
					cStr += "Novo  : "
					cStr += DtoC(xVarNew) + CRLF
			EndCase
			cStr += CRLF
			ZB3->ZB3_TEXTO := cStr
		EndIf
	
	Next nLoop                
Else 
                             
    dbSelectArea("ZB3")
    dbSetOrder(1)
    lNewRec := .t.
    If dbSeek( xFilial("ZB3") + ::cId + cAlias + cKey )
    	lNewRec := .f.
    EndIf
	RecLock("ZB3",lNewREc)
	ZB3->ZB3_FILIAL := xFilial("ZB3")
	ZB3->ZB3_ID     := ::cId
	ZB3->ZB3_ALIAS  := cAlias
	ZB3->ZB3_ORDER  := nOrder
	ZB3->ZB3_CHAVE  := cKey
	ZB3->ZB3_USNAME := cUserName
	ZB3->ZB3_DATA   := dDataBase
	ZB3->ZB3_HORA   := SubStr(Time(),1,5)
    ZB3->ZB3_TEXTO  := cTxtLog

EndIf     

ZB3->( MsUnLock() )
          
RestArea( aArea )
    
::ClearRecs()

Return( nil )


//===================================================================================================
// Limpa o array ::aSavRecs
//===================================================================================================
Method ClearRecs() Class uLogField
::aSavRecs := {}
::cId      := ""
Return( nil )

//===================================================================================================
// Mostra o log do registro
//===================================================================================================
Method Show( cAlias, nOrder, cSeek ) Class uLogField 

Processa( { || ShowLog( cAlias, nOrder, cSeek ) }, "Aguarde..." )

Return( nil )

Static Function ShowLog( cAlias, nOrder, cSeek )  

Local aArea := GetArea()
Local aSize := {}

Local oBtnFechar
Local cSql   := ""

Local oFont1 := TFont():New("Arial"      ,,022,,.T.,,,,,.F.,.F.)
Local oFont2 := TFont():New("Courier New",,016,,.f.,,,,,.f.,.f.)
Local oGd
Local oGetLog
Local cGetLog := "Define variable value"
Local oPanel1
Local oPnlBottom
Local oSay1
Local oDlg
Local oBar, oHead                                     
Local cTxt2
                      
Default cAlias := Alias()
Default nOrder := 1
                       
ProcRegua(0)           

dbSelectArea( "SX2" )
dbSetOrder(1)
dbSeek( cAlias )
cTxt2 := "Tabela:" + cAlias + " - " + Capital( SX2->X2_NOME ) 

dbSelectArea(cAlias)
dbSetOrder(nOrder)                
If ValType( cSeek ) == "C"
	dbSeek( cSeek )
EndIf

cSql := "SELECT ZB3.ZB3_DATA, ZB3.ZB3_HORA, ZB3.ZB3_USNAME,  "
If TCGetDb() == "MSSQL"
	cSql += " CONVERT( VARBINARY(1024),ZB3.ZB3_TEXTO) ) ZB3_TEXTO"
Else
	cSql += " UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(ZB3_TEXTO, 32000, 1)) ZB3_TEXTO "
EndIf
cSql += "  FROM " +RetSqlName("ZB3")+ " ZB3 "
cSql += " WHERE ZB3.ZB3_FILIAL = '" +xFilial("ZB3")+ "' "
cSql += "   AND ZB3.ZB3_ALIAS = '" +cAlias+ "' "
cSql += "   AND ZB3.ZB3_CHAVE = '" + &(IndexKey()) + "' "
cSql += "   AND ZB3.D_E_L_E_T_ = ' ' " 
cSql += " ORDER BY ZB3.ZB3_DATA DESC, ZB3.ZB3_HORA DESC"
                                                                                   
aSize := MSAdvSize()
DEFINE MSDIALOG oDlg TITLE "Log" FROM 000, 000  TO aSize[6]/100*70, aSize[5]/100*70 PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP)

oHead := DlgHead():New( oDlg, "Log de Registro", cTxt2 )    

oBar:= AdvPlBar():New( oDlg )
oBar:AddButton( "Fechar", {||oDlg:End()} )

oGd := MyGrid():New( 000, 000, 50, 50, 0,,,,,, 99999,,,, oDlg)

oGd:AddColumn( { "Data"     , "ZB3_DATA"  , ""    , TamSx3("ZB3_DATA"  )[1], TamSx3("ZB3_DATA"  )[2], "", "", "D", "", "R", "", "", "", "V", "" } )
oGd:AddColumn( { "Hora"     , "ZB3_HORA"  , ""    , TamSx3("ZB3_HORA"  )[1], TamSx3("ZB3_HORA"  )[2], "", "", "C", "", "R", "", "", "", "V", "" } )
oGd:AddColumn( { "Usuário"  , "ZB3_USNAME", ""    , TamSx3("ZB3_USNAME")[1], TamSx3("ZB3_USNAME")[2], "", "", "C", "", "R", "", "", "", "V", "" } )
oGd:AddColumn( { "Log"      , "ZB3_TEXTO" , "@S1" , 1024                   , 0                      , "", "", "C", "", "R", "", "", "", "V", "" } )

oGd:Load()
oGd:FromSql( cSql )
oGd:SetChange( {|| cGetLog := GDFieldGet( "ZB3_TEXTO", oGd:oBrowse:nAt, .f., oGd:aHeader, oGd:aCols), oGetLog:Refresh() } )
oGd:SetAlignTop()
                                               
cGetLog := GDFieldGet ( "ZB3_TEXTO", oGd:oBrowse:nAt, .f., oGd:aHeader, oGd:aCols )

@ 000, 000 GET oGetLog VAR cGetLog OF oDlg MULTILINE SIZE 350, 115 COLORS 0, 16777215 HSCROLL FONT oFont2 PIXEL
oGetLog:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTERED
                  
RestArea( aArea )

Return(nil)
                                                                                       
Method SetId() Class uLogField
If Empty( ::cId )
	::cId := PadR( Dtos( dDataBase )+StrTran( Time(), ":" ,"" ), TamSx3("ZB3_ID")[1], " " )
EndIf
Return( nil )