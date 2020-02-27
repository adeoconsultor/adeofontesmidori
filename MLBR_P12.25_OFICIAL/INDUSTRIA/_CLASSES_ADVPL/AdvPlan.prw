#include "totvs.ch"
//=================================================================================================================
// AdvPlan   -                                   Alessandro Freire                                  - Abril / 2015
//-----------------------------------------------------------------------------------------------------------------
// Exporta um grid para o Excel
//-----------------------------------------------------------------------------------------------------------------
// Parametros
// nil
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
User Function AdvPlan( oMyGrid, cFileName, cPerg, aParam )            
Processa( {||GeraPlan( oMyGrid, cFileName, cPerg, aParam )},"Gerando Planilha. Aguarde...")
Return(nil)                            

Static Function GeraPlan( oMyGrid, cFileName, cPerg, aParam  )
Local aCols    := {}                                                   
Local aHeader  := {}
Local aFormatH := {}
Local aFormatP := {}
Local aFormatI := {}       
Local aSheet   := { "Planilha" }

Local nLoop, nX
Local nCol
Local oGrid, oHmFont, oHmAlign, oHmInt, oHMNumber, oExcel
Local bBlockGrd    

Default cFileName := ""
Default cPerg     := ""
Default aParam    := {}

If ValType( oMyGrid ) == "U"
	MsgInfo( "Atualize os grids" )
	Return(nil)
EndIf                         
            
oExcel    := UExcel():new(aSheet)

aCols     := aClone( oMyGrid:oGrid:aCols )
aHeader   := aClone( oMyGrid:oGrid:aHeader )

ProcRegua( Len(aCols) )

aStyles   := DefStyle( @oExcel ) 

oExcel:setActiveWorkSheet( 1 )

//------------------------------------------------
// Impressão dos cabeçalhos
//------------------------------------------------
For nX := 1 to Len( aHeader )
	oExcel:offset(0, 1):setValue( aHeader[nX,1] ):SetStyle(aStyles[1] ) 
Next nX 
oExcel:NextRow()                                                                    

//------------------------------------------------
// Impressão dos itens
//------------------------------------------------
For nX := 1 to Len( aCols )
	IncProc( "Linha " + AllTrim(nX) + " de " + AllTrim(Len(aCols)) ) 
	For nCol := 1 to Len( aCols[nX] ) - 1                                            
		If nX < Len( aCols )
			If Mod( nX, 2 ) > 0
				oExcel:offset(0, 1):setValue(aCols[nX,nCol]):SetStyle( aStyles[2] ) 
			Else
				oExcel:offset(0, 1):setValue(aCols[nX,nCol]):SetStyle( aStyles[3] ) 
			EndIf
		Else
			oExcel:offset(0, 1):setValue(aCols[nX,nCol]):SetStyle( aStyles[1] ) 
		EndIf
	Next nCol 
	oExcel:NextRow()
Next nX                                                                     

//------------------------------------------------
// Encerramento do arquivo, salvando-o
//------------------------------------------------
cPath := cGetFile( '*.xls', 'Selecione diretório para salvar arquivo', 1, 'C:\', .T., nOR( GETF_LOCALHARD, GETF_RETDIRECTORY ),.T., .T. )
cNome := cFileName + "_" + DtoS( dDataBase ) + "_" + StrTran(Time(),":","") + ".xls"
ProcRegua(0)
IncProc("Salvando planilha...")
oExcel:save(cPath + cNome)
oExcel:Show()

Return( nil )                   

//=============================================================================================================
// DefStyle() - Alessandro de Barros Freire - Abril / 2015
//-------------------------------------------------------------------------------------------------------------
// Define os styles do header e das linhas de dados da planilha
//-------------------------------------------------------------------------------------------------------------
// Parametros                                                                                                  
// oExcel - Objeto excel passado por parâmetro
//-------------------------------------------------------------------------------------------------------------
// Retorno
// aRet { aStHead1, aStCols1, aStCols2 }
//=============================================================================================================
Static Function DefStyle( oExcel )

Local aRet       := {}
Local oHmFont    := nil
Local oHmAlign   := nil
Local oHmInt     := nil
Local oHMNumber  := nil

//------------------------------------------------
// Style para a 1a linha do cabeçalho da tabela
//------------------------------------------------
oHmFont    := THash():New()
oHmAlign   := THash():New()
oHmInt     := THash():New()
oHMNumber  := THash():New()
                          
oHmFont:Put("Color","#FFFFFF")
oHmFont:put("Bold", "1") 
oHmInt:Put("Color","#1F4E78")   
oHmInt:Put("Pattern","Solid")
oHmNumber:put("Format", "_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-")		

AAdd( aRet, oExcel:NewStyle( oHmFont, oHmAlign, oHmInt, oHmNumber ) )

//------------------------------------------------
// Style para a 1a linha de dados
//------------------------------------------------
oHmFont    := THash():New()
oHmAlign   := THash():New()
oHmInt     := THash():New()
oHMNumber  := THash():New()
                                  
oHmAlign:Put("Vertical"  ,"Bottom")
oHmInt:Put("Color","#DDEBF7")   
oHmInt:Put("Pattern","Solid")
oHmNumber:put("Format", "_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-")		

AAdd( aRet, oExcel:NewStyle( oHmFont, oHmAlign, oHmInt, oHmNumber ) )

//------------------------------------------------
// Style para a 2a linha de dados
//------------------------------------------------
oHmFont    := THash():New()
oHmAlign   := THash():New()
oHmInt     := THash():New()
oHMNumber  := THash():New()

oHmAlign:Put("Vertical"  ,"Bottom")
oHmInt:Put("Color","#9BC2E6")   
oHmInt:Put("Pattern","Solid")
oHmNumber:put("Format", "_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-")		

AAdd( aRet, oExcel:NewStyle( oHmFont, oHmAlign, oHmInt, oHmNumber ) )

Return( aRet )
