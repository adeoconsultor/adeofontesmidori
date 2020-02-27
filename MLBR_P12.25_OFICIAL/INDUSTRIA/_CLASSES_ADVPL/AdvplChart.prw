#INCLUDE "TOTVS.CH"
CLASS ADVPLCHART
Data oFolder

Data aFolder
Data aTitle
Data aChart 

Data oDlg
Data oBar
Data oHead

Method New() Constructor
Method SetHeaderTitle()
Method SetFolder()
Method AddSerie()
Method Show()
ENDCLASS
******************************************************************************************************************
Method New() Class AdvplChart

Self:aTitle  := {"Gráfico",""}     
Self:aFolder := {"Gráfico"}
Self:aChart  := {}


Return(Self)          
******************************************************************************************************************
Method AddSerie( nFolder, cLabel, aSerie ) Class AdvplChart

aChart[nFolder]:AddSerie( cLabel, aSerie )
******************************************************************************************************************
Method SetHeaderTitle( cTitle, nLinha ) Class AdvplChart

Default nLinha := 1          

Self:aTitle[nLinha] := cTitle

If ValType( Self:oHead ) == "O"
	Self:oHead:SetText( Self:aTitle[nLinha], nLinha )
EndIf

Return( nil )
******************************************************************************************************************
// Cria o array com os folders que devem ser criados
Method SetFolder( aFolders ) Class AdvplChart

Local nLoop, oChart

Self:aFolder := aFolders

Self:aChart := {}
For nLoop := 1 to Len( aFolder )
                       
	oChart:=FWChartFactory():New()
	oChart:setLegend( CONTROL_ALIGN_LEFT ) 

	AAdd( Self:aChart,  oChart )
	
Next nLoop

Return(nil)
******************************************************************************************************************
Method Show() Class AdvplChart // Static Function Grafico( oMyGrid, cTipo, cStyle )
                        
Local oGrp 
Local aSize   := MSAdvSize()
Local nLinha  := oMyGrid:GetAt()
Local nLinhas := Len( oMyGrid:aCols )
Local cTitulo := ""
Local nLoop
// Criando a Janela       

Do Case
	Case cStyle == "1" // Por contrato   
		If nLinha <> nLinhas
			cTitulo := "Contrato: "       
			cTitulo += GDFieldGet ( "TMP_CONTRA", nLinha, .f., oMyGrid:aHeader, oMyGrid:aCols ) 
		Else
			cTitulo := "Total por Contrato"
		EndIf

	Case cStyle == "2" // Por produto 

		If nLinha <> nLinhas
			cTitulo := "Produto: "       
			cTitulo += AllTrim(GDFieldGet ( "TMP_PRODUT", nLinha, .f., oMyGrid:aHeader, oMyGrid:aCols )) + ": "
			cTitulo += Posicione( "SB1",;
			                      1,;
			                      xFilial("SB1")+;
			                      GDFieldGet ( "TMP_PRODUT", nLinha, .f., oMyGrid:aHeader, oMyGrid:aCols ) ,;
			                      "B1_DESC" )
			
		Else
			cTitulo := "Total por Produto"
		EndIf

	Case cStyle == "3" // Por Cliente

		If nLinha <> nLinhas
			cTitulo := "Cliente : "       
			cTitulo += GDFieldGet ( "TMP_CLI", nLinha, .f., oMyGrid:aHeader, oMyGrid:aCols ) + "-" 
			cTitulo += GDFieldGet ( "TMP_LOJ", nLinha, .f., oMyGrid:aHeader, oMyGrid:aCols ) + ":"
			cTitulo += Posicione( "SA1",;
			                      1,;
			                      xFilial("SA1")+;
			                      GDFieldGet ( "TMP_CLI", nLinha, .f., oMyGrid:aHeader, oMyGrid:aCols ) + ; 
			                      GDFieldGet ( "TMP_LOJ", nLinha, .f., oMyGrid:aHeader, oMyGrid:aCols ) , ; 
			                      "A1_NREDUZ" )         
			                               
		Else
			cTitulo := "Total por Cliente"
		EndIf
	Case cStyle == "4" // Por Item de contrato

		If nLinha <> nLinhas
			cTitulo := "Produto: "       
			cTitulo += AllTrim(GDFieldGet ( "TMP_PRODUT", nLinha, .f., oMyGrid:aHeader, oMyGrid:aCols )) + "-"
			cTitulo += GDFieldGet ( "TMP_ITEM"  , nLinha, .f., oMyGrid:aHeader, oMyGrid:aCols ) + ":"
			cTitulo += Posicione( "SB1",;
			                      1,;
			                      xFilial("SB1")+;
			                      GDFieldGet ( "TMP_PRODUT", nLinha, .f., oMyGrid:aHeader, oMyGrid:aCols ) ,;
			                      "B1_DESC" )                                                           
		Else	
			cTitulo := "Total por Item de Contrato"
		EndIf 

EndCase     

cTitulo := AllTrim( cTitulo )

DEFINE MSDIALOG oDlg TITLE "Gráfico" FROM 000, 000  TO aSize[6], aSize[5] COLORS 0, 16777215 PIXEL

oHead := DlgHead():New( oDlg, "Previsto x Realizado", "Gráfico por " + iif(cTipo == "Q","Quantidade","Valor") )    

oBar:= AdvPlBar():New( oDlg )
oBar:AddButton( "Fechar", {||oDlg:End()} )

// Criando o gráfico
oChart := FWChartFactory():New()
oChart := oChart:getInstance( LINECHART ) // cria objeto FWChartBar

//Valores do getInstance:
//BACHART      -  cria objeto FWChartBar
//BARCOMPCHART -  cria objeto FWChartBarComp
//LINECHART    -  cria objeto FWChartLine
//PIECHART     - cria objeto FWChartPie

oChart:SetTitle( cTitulo, CONTROL_ALIGN_CENTER )
oChart:setMask( "R$ *@* " )
oChart:setPicture( "@E 999,999,999.99" )			
oChart:setLegend( CONTROL_ALIGN_LEFT ) 
oChart:init( oDlg, .T. ) 

aSerieP := {}
aSerieR := {}
                                                                                          
For nLoop := 1 to Len( oMyGrid:aHeader )
	// Previsto
	If SubStr(oMyGrid:aHeader[nLoop,2],3,2) == "20" .and. SubStr(oMyGrid:aHeader[nLoop,2],9,2) == Upper(cTipo)+"P"
		AAdd( aSerieP, { SubStr(oMyGrid:aHeader[nLoop,2],7,2)+"/"+SubStr(oMyGrid:aHeader[nLoop,2],3,4),;
						oMyGrid:aCols[oMyGrid:GetAt(),nLoop] } )
	EndIf      
	
	// Realizado
	If SubStr(oMyGrid:aHeader[nLoop,2],3,2) == "20" .and. SubStr(oMyGrid:aHeader[nLoop,2],9,2) == Upper(cTipo)+"R"
		AAdd( aSerieR, { SubStr(oMyGrid:aHeader[nLoop,2],7,2)+"/"+SubStr(oMyGrid:aHeader[nLoop,2],3,4),;
						 oMyGrid:aCols[oMyGrid:GetAt(),nLoop] } )
	EndIf


Next nLoop           

oChart:addSerie( "Previsto" , aSerieP )
oChart:addSerie( "Realizado", aSerieR )
                                     
oChart:Build()

// Exibindo a janela.
ACTIVATE DIALOG oDlg CENTERED

Return( nil )
