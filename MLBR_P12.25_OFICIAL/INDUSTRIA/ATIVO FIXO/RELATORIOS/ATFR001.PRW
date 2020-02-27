#include "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออออออัออออออออออออออออออออออหอออออออออออออัออออออออออออออออออออออออออออออออออออออออหออออออออัอออออออออออออออออปฑฑ
ฑฑบPrograma          ณ ATFR001             บ Analista    ณ Willer Trindade                         บ  Data  ณ     24/10/12    บฑฑ
ฑฑบ										    บ Analista    ณ Willer Trindade                        บ  Data  ณ     24/10/12    บฑฑ
ฑฑฬออออออออออออออออออุออออออออออออออออออออออสอออออออออออออฯออออออออออออออออออออออออออออออออออออออออสออออออออฯอออออออออออออออออนฑฑ
ฑฑบDescricao         ณ Relatorio Conferencia Ativo Fixo                                                                       บฑฑ
ฑฑบ                  ณ                                                                                                        บฑฑ
ฑฑบ                  ณ                                                                                                        บฑฑ
ฑฑบ                  ณ                                                                                                        บฑฑ
ฑฑฬออออออออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso               ณ Exclusivo :                                                                                     บฑฑ
ฑฑบ                  ณ                                                                                                        บฑฑ
ฑฑศออออออออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ATFR001()                                                    

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Declaracao de variaveis                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Local l_Con
Local a_Par := {}

l_Con := ATFR01B(@a_Par)

If l_Con
	MsgRun("Aguarde... Gerando Dados...","Confer๊ncia Ativo Fixo",{|| ATFR01A(a_Par)})
EndIf

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ษออออออออออออออออออัออออออออออออออออออออออหอออออออออออออัออออออออออออออออออออออออออออออออออออออออออออหออออออออัอออออออออออออออออป
บPrograma          ณ ATFR01A             บ Analista    ณ Willer Trindade                            บ  Data  ณ     24/10/12    บ
ฬออออออออออออออออออุออออออออออออออออออออออสอออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออสออออออออฯอออออออออออออออออน
บDescricao         ณ Monta a estrutura do relatorio e obtem os dados                                                            บ
ฬออออออออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
บUso               ณ Exclusivo : ATFR001                                                                                       บ
ศออออออออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ATFR01A(aPar)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Declaracao de variaveis                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Local c_Arq := "c:\relato\confatfixo.xml"
Local n_Han := 0
Local c_Tab := ""
Local c_Lin := "0"
Local c_Cam := "11"
Local c_Fim := Chr(13) + Chr(10)
Local c_Per := AllTrim(aPar[2])+AllTrim(aPar[1])
Local c_Mes := Substr(Cmonth(Stod(AllTrim(aPar[2])+AllTrim(aPar[1])+"01")),1,3)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Executa a query para retornar os dados                                                                                      //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

If Select("A_AUX") > 0
	DbSelectArea("A_AUX")
	DbCloseArea()
EndIf

BeginSql Alias "A_AUX"
	SELECT	COUNT(N1_CBASE) AS RGS
	FROM	SN1010 AS SN1
	INNER	JOIN SN3010 AS SN3 ON  SN1.N1_CBASE = SN3.N3_CBASE AND SN3.%NotDel%
	WHERE	LEFT(SN1.N1_AQUISIC,6) <= %exp:c_Per% AND
	SN1.N1_BAIXA = SPACE(8) AND
	SN1.%NotDel%
EndSql

DbSelectArea("A_AUX")
c_Lin := AllTrim(Str(A_AUX->RGS+3))
DbCloseArea()

If Select("A_AUX") > 0
	DbSelectArea("A_AUX")
	DbCloseArea()
EndIf


/*	LEFT	JOIN	(SELECT	N4_CBASE AS CBAS,
SUM(CASE WHEN LEFT(N4_DATA,6) = %exp:c_Per% THEN N4_VLROC1 ELSE 0 END) AS DMES,
SUM(CASE WHEN LEFT(N4_DATA,6) <> %exp:c_Per% THEN N4_VLROC1 ELSE 0 END) AS DACM
FROM	SN4010 AS SN4
WHERE	LEFT(N4_DATA,6) <= %exp:c_Per% AND
SN4.%NotDel%
GROUP	BY N4_CBASE) AS ATF ON SN1.N1_CBASE = ATF.CBAS */

BeginSql Alias "A_AUX"
	SELECT	N1_GRUPO AS CGRUPO,
			N3_CCONTAB AS CTABEM,
			N3_CUSTBEM AS CTADEP,
			CONVERT(CHAR(10),CONVERT(DATETIME,N1_AQUISIC,103),103) AS DAQUIS,
			N3_VORIG1 AS VCUSTO,
			N1_CBASE AS CODIGO,
			N1_DESCRIC AS DESCRI,
			N3_TXDEPR1 AS TAXDEP,
			DMES AS DEPMES,
			DACM AS DEPACU,
			N3_VORIG1-(DMES+DACM) AS VRESID
	FROM	SN1010 AS SN1
	INNER JOIN SN3010 AS SN3 ON SN1.N1_FILIAL = SN3.N3_FILIAL AND SN1.N1_CBASE = SN3.N3_CBASE AND SN1.N1_ITEM = SN3.N3_ITEM AND SN3.%NotDel%
	LEFT JOIN (SELECT N4_CBASE AS CBAS,
		N4_ITEM AS CITE,
		SUM(CASE WHEN LEFT(N4_DATA,6) = %exp:c_Per% THEN N4_VLROC1 ELSE 0 END) AS DMES,
		SUM(CASE WHEN LEFT(N4_DATA,6) < %exp:c_Per% THEN N4_VLROC1 ELSE 0 END) AS DACM
	FROM SN4010 AS SN4
		WHERE LEFT(N4_DATA,6) <= %exp:c_Per% AND
			SN4.N4_TIPOCNT = '4' AND
			SN4.N4_OCORR = '06' AND
			SN4.%NotDel%
		GROUP BY N4_CBASE,N4_ITEM) AS ATF ON SN1.N1_FILIAL = SN3.N3_FILIAL AND SN1.N1_CBASE = ATF.CBAS AND SN1.N1_ITEM = ATF.CITE
		WHERE LEFT(SN1.N1_AQUISIC,6) <= %exp:c_Per% AND
			SN1.N1_BAIXA = SPACE(8) AND
			SN1.%NotDel%
EndSql

If Select("A_AUX") > 0
	DbSelectArea("A_AUX")
	DbGoTop()
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Verifica a existencia do arquivo                                                                                            //
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	If File(c_Arq)
		Ferase(c_Arq)
	EndIf
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Cria o arquivo                                                                                                              //
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	n_Han := Fcreate(c_Arq,0)
	
	If Ferror() != 0
		ApMsgInfo("Nใo foi possํvel abrir ou criar o arquivo !","Gera็ใo Confer๊ncia Ativo Fixo")
	Else
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Define a aplicacao para abertura do arquivo                                                                                 //
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		c_Tab += '<?xml version="1.0"?>'																														+ c_Fim
		c_Tab += '<?mso-application progid="Excel.Sheet"?>'																										+ c_Fim
		c_Tab += '<Workbook	xmlns="urn:schemas-microsoft-com:office:spreadsheet"'                                                                               + c_Fim
		c_Tab += '			xmlns:o="urn:schemas-microsoft-com:office:office"'                                                                                  + c_Fim
		c_Tab += '			xmlns:x="urn:schemas-microsoft-com:office:excel"'                                                                                   + c_Fim
		c_Tab += '			xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'                                                                            + c_Fim
		c_Tab += '			xmlns:html="http://www.w3.org/TR/REC-html40">'                                                                                      + c_Fim                                                                                      + c_Fim
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Define os estilos que serao usados no arquivo                                                                               //
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		c_Tab += '	<Styles>'                                                                                                                                   + c_Fim
		c_Tab += '		<Style ss:ID="st1">'                                                                                                                    + c_Fim
		c_Tab += '			<Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'                                                                           + c_Fim
		c_Tab += '			<Borders>'                                                                                                                          + c_Fim
		c_Tab += '				<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'                                                         + c_Fim
		c_Tab += '			</Borders>'                                                                                                                         + c_Fim
		c_Tab += '			<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000" ss:Bold="1"/>'                                          + c_Fim
		c_Tab += '			<Interior ss:Color="#FFFF00" ss:Pattern="Solid"/>'                                                                                  + c_Fim
		c_Tab += '			<NumberFormat ss:Format="@"/>'			                                                                                            + c_Fim
		c_Tab += '		</Style>'                                                                                                                               + c_Fim
		c_Tab += '		<Style ss:ID="st2">'																													+ c_Fim
		c_Tab += '			<Borders>'                                                                                                                          + c_Fim
		c_Tab += '				<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'                                                          + c_Fim
		c_Tab += '				<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'                                                            + c_Fim
		c_Tab += '			</Borders>'                                                                                                                         + c_Fim
		c_Tab += '			<Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>'                                                      + c_Fim
		c_Tab += '			<Interior ss:Color="#D8D8D8" ss:Pattern="Solid"/>'                                                                                  + c_Fim
		c_Tab += '		</Style>'																																+ c_Fim
		c_Tab += '		<Style ss:ID="st3">'																													+ c_Fim
		c_Tab += '			<Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                                                                             + c_Fim
		c_Tab += '			<Borders>'                                                                                                                          + c_Fim
		c_Tab += '				<Border ss:Position="Right" ss:LineStyle="Continuous"/>'                      				                                    + c_Fim
		c_Tab += '			</Borders>'                                                                                                                         + c_Fim
		c_Tab += '			<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'				                                        + c_Fim
		c_Tab += '			<Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'                                                                                  + c_Fim
		c_Tab += '		</Style>'                                                                                                                               + c_Fim
		c_Tab += '		<Style ss:ID="st4">'																													+ c_Fim
		c_Tab += '			<Alignment ss:Vertical="Bottom"/>'                                                                                                  + c_Fim
		c_Tab += '			<Borders>'                                                                                                                          + c_Fim
		c_Tab += '				<Border ss:Position="Right" ss:LineStyle="Continuous"/>'                                                                        + c_Fim
		c_Tab += '			</Borders>'                                                                                                                         + c_Fim
		c_Tab += '			<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'                                                      + c_Fim
		c_Tab += '			<Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'                                                                                  + c_Fim
		c_Tab += '			<NumberFormat ss:Format="_-&quot;R$&quot;\ * #,##0_-;\-&quot;R$&quot;\ * #,##0_-;_-&quot;R$&quot;\ * &quot;-&quot;_-;_-@_-"/>'	    + c_Fim
		c_Tab += '		</Style>'                                                                                                                               + c_Fim
		c_Tab += '		<Style ss:ID="st5">'																													+ c_Fim
		c_Tab += '			<Borders>'																															+ c_Fim
		c_Tab += '				<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'															+ c_Fim
		c_Tab += '				<Border ss:Position="Right" ss:LineStyle="Continuous"/>'																		+ c_Fim
		c_Tab += '				<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'															+ c_Fim
		c_Tab += '			</Borders>'																															+ c_Fim
		c_Tab += '			<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="8" ss:Color="#000000" ss:Bold="1"/>'											+ c_Fim
		c_Tab += '			<Interior ss:Color="#D8D8D8" ss:Pattern="Solid"/>'																					+ c_Fim
		c_Tab += '			<NumberFormat ss:Format="_-&quot;R$&quot;\ * #,##0_-;\-&quot;R$&quot;\ * #,##0_-;_-&quot;R$&quot;\ * &quot;-&quot;_-;_-@_-"/>'		+ c_Fim
		c_Tab += '		</Style>'																																+ c_Fim
		c_Tab += '		<Style ss:ID="st6">'                                                                                                                    + c_Fim
		c_Tab += '			<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'                                                      + c_Fim
		c_Tab += '			<Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'                                                                                  + c_Fim
		c_Tab += '		</Style>'                                                                                                                               + c_Fim
		c_Tab += '	</Styles>'                                              	                                                                         		+ c_Fim
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Define os cabecalhos do arquivo                                                                                             //
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		c_Tab += '	<Worksheet ss:Name="Ativo">'																												+ c_Fim
		c_Tab += '		<Table ss:ExpandedColumnCount="' + c_Cam + '" ss:ExpandedRowCount="' + c_Lin + '" ss:StyleID="st6">'									+ c_Fim
		c_Tab += '			<Column ss:Index="1" ss:Width="120.00"/>'																							+ c_Fim
		c_Tab += '			<Column ss:Index="2" ss:Width="110.00"/>'																							+ c_Fim
		c_Tab += '			<Column ss:Index="3" ss:Width="110.00"/>'                                                                                           + c_Fim
		c_Tab += '			<Column ss:Index="4" ss:Width="100.00"/>'                                                                                           + c_Fim
		c_Tab += '			<Column ss:Index="5" ss:Width="60.00"/>'																							+ c_Fim
		c_Tab += '			<Column ss:Index="6" ss:Width="60.00"/>'																							+ c_Fim
		c_Tab += '			<Column ss:Index="7" ss:Width="200.00"/>'																							+ c_Fim
		c_Tab += '			<Column ss:Index="8" ss:Width="100.00"/>'																							+ c_Fim
		c_Tab += '			<Column ss:Index="9" ss:Width="120.00"/>'                                                                                           + c_Fim
		c_Tab += '			<Column ss:Index="10" ss:Width="120.00"/>'																							+ c_Fim
		c_Tab += '			<Column ss:Index="11" ss:Width="120.00"/>'																							+ c_Fim
		c_Tab += '			<Row ss:Index="2">'                                                                                                                 + c_Fim
		c_Tab += '				<Cell ss:Index="1" ss:StyleID="st1"><Data ss:Type="String">Nome do Grupo</Data></Cell>'											+ c_Fim
		c_Tab += '				<Cell ss:StyleID="st1"><Data ss:Type="String">Conta Contabil</Data></Cell>'														+ c_Fim
		c_Tab += '				<Cell ss:StyleID="st1"><Data ss:Type="String">Centro de Custo</Data></Cell>'												+ c_Fim
		c_Tab += '				<Cell ss:StyleID="st1"><Data ss:Type="String">Data de Aquisicao</Data></Cell>'													+ c_Fim
		c_Tab += '				<Cell ss:StyleID="st1"><Data ss:Type="String">Custo</Data></Cell>'																+ c_Fim
		c_Tab += '				<Cell ss:StyleID="st1"><Data ss:Type="String">Codigo</Data></Cell>'																+ c_Fim
		c_Tab += '				<Cell ss:StyleID="st1"><Data ss:Type="String">Itens Historico</Data></Cell>'													+ c_Fim
		c_Tab += '				<Cell ss:StyleID="st1"><Data ss:Type="String">% da Depreciacao</Data></Cell>'													+ c_Fim
		c_Tab += '				<Cell ss:StyleID="st1"><Data ss:Type="String">Depreciacao Mes</Data></Cell>'													+ c_Fim
		c_Tab += '				<Cell ss:StyleID="st1"><Data ss:Type="String">Depreciacao Acumulada</Data></Cell>'												+ c_Fim
		c_Tab += '				<Cell ss:StyleID="st1"><Data ss:Type="String">Saldo Residual</Data></Cell>'														+ c_Fim
		c_Tab += '			</Row>'																																+ c_Fim
		
		If(Fwrite(n_Han,c_Tab) == 0)
			ApMsgInfo("Nใo foi possํvel salvar o arquivo !","Gera็ใo Confer๊ncia Ativo Fixo")
			Return
		EndIf
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Define os detalhes do arquivo                                                                                               //
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		Do While A_AUX->(!EoF())
			
			c_Tab := '			<Row>'																															+ c_Fim
			c_Tab += '				<Cell ss:Index="1" ss:StyleID="st3"><Data ss:Type="String">' + AllTrim(A_AUX->CGRUPO) + '</Data></Cell>'					+ c_Fim
			c_Tab += '				<Cell ss:StyleID="st3"><Data ss:Type="String">' + AllTrim(A_AUX->CTABEM) + '</Data></Cell>'	 								+ c_Fim
			c_Tab += '				<Cell ss:StyleID="st3"><Data ss:Type="String">' + AllTrim(A_AUX->CTADEP) + '</Data></Cell>'		 							+ c_Fim
			c_Tab += '				<Cell ss:StyleID="st3"><Data ss:Type="String">' + AllTrim(A_AUX->DAQUIS) + '</Data></Cell>'									+ c_Fim
			c_Tab += '				<Cell ss:StyleID="st4"><Data ss:Type="Number">' + AllTrim(Str(A_AUX->VCUSTO)) + '</Data></Cell>'							+ c_Fim
			c_Tab += '				<Cell ss:StyleID="st3"><Data ss:Type="String">' + AllTrim(A_AUX->CODIGO) + '</Data></Cell>'			   						+ c_Fim
			c_Tab += '				<Cell ss:StyleID="st3"><Data ss:Type="String">' + AllTrim(A_AUX->DESCRI) + '</Data></Cell>'									+ c_Fim
			c_Tab += '				<Cell ss:StyleID="st4"><Data ss:Type="Number">' + AllTrim(Str(A_AUX->TAXDEP)) + '</Data></Cell>'		 					+ c_Fim
			c_Tab += '				<Cell ss:StyleID="st4"><Data ss:Type="Number">' + AllTrim(Str(A_AUX->DEPMES)) + '</Data></Cell>'							+ c_Fim
			c_Tab += '				<Cell ss:StyleID="st4"><Data ss:Type="Number">' + AllTrim(Str(A_AUX->DEPACU)) + '</Data></Cell>'							+ c_Fim
			c_Tab += '				<Cell ss:StyleID="st4"><Data ss:Type="Number">' + AllTrim(Str(A_AUX->VRESID)) + '</Data></Cell>'							+ c_Fim
			c_Tab += '			</Row>'																															+ c_Fim
			
			If(Fwrite(n_Han,c_Tab) == 0)
				ApMsgInfo("Nใo foi possํvel salvar o arquivo !","Gera็ใo Confer๊ncia Ativo Fixo")
				Return
			EndIf
			A_AUX->(DbSkip())
		EndDo
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Define o rodape do arquivo                                                                                                  //
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		c_Tab := '			<Row>'                                                                                                                              						+ c_Fim
		c_Tab += '				<Cell ss:Index="4" ss:StyleID="st2"><Data ss:Type="String">Total</Data></Cell>'														  					+ c_Fim
		c_Tab += '				<Cell ss:Index="5" ss:StyleID="st5" ss:Formula="=SUBTOTAL(9,R[-' + AllTrim(Str(Val(c_Lin)-3)) + ']C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>'	+ c_Fim
		c_Tab += '				<Cell ss:Index="9" ss:StyleID="st5" ss:Formula="=SUBTOTAL(9,R[-' + AllTrim(Str(Val(c_Lin)-3)) + ']C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>'	+ c_Fim
		c_Tab += '				<Cell ss:Index="10" ss:StyleID="st5" ss:Formula="=SUBTOTAL(9,R[-' + AllTrim(Str(Val(c_Lin)-3)) + ']C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>'	+ c_Fim
		c_Tab += '				<Cell ss:Index="11" ss:StyleID="st5" ss:Formula="=SUBTOTAL(9,R[-' + AllTrim(Str(Val(c_Lin)-3)) + ']C:R[-1]C)"><Data ss:Type="Number">0</Data></Cell>'	+ c_Fim
		c_Tab += '			</Row>'                                                                                                                             						+ c_Fim
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Define a encerramento do arquivo                                                                                            //
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		c_Tab := '		</Table>'                                                                                                                               + c_Fim
		c_Tab += '		<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'                                                                     	+ c_Fim
		c_Tab += '			<FrozenNoSplit/>'                                                                                                                   + c_Fim
		c_Tab += '			<SplitHorizontal>2</SplitHorizontal>'                                                                                               + c_Fim
		c_Tab += '			<TopRowBottomPane>2</TopRowBottomPane>'			                                                                                    + c_Fim
		c_Tab += '			<SplitVertical>4</SplitVertical>'                                                                                                   + c_Fim
		c_Tab += '			<LeftColumnRightPane>4</LeftColumnRightPane>'                                                                                       + c_Fim
		c_Tab += '			<ActivePane>0</ActivePane>'                                                                                                         + c_Fim
		c_Tab += '			<Panes>'																															+ c_Fim
		c_Tab += '				<Pane>'																															+ c_Fim
		c_Tab += '				<Number>0</Number>'																												+ c_Fim
		c_Tab += '				<ActiveRow>1</ActiveRow>'																										+ c_Fim
		c_Tab += '				<ActiveCol>0</ActiveCol>'																										+ c_Fim
		c_Tab += '				</Pane>'																														+ c_Fim
		c_Tab += '			</Panes>'																															+ c_Fim
		c_Tab += '		</WorksheetOptions>'                                                                                                                    + c_Fim
		c_Tab += '		<AutoFilter x:Range="R2C1:R2C11" xmlns="urn:schemas-microsoft-com:office:excel">'														+ c_Fim
		c_Tab += '		</AutoFilter>'																															+ c_Fim
		c_Tab += '	</Worksheet>'                                                                                                                               + c_Fim
		c_Tab += '</Workbook>'						                                                                                                            + c_Fim
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Grava o arquivo                                                                                                             //
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		If(Fwrite(n_Han,c_Tab) == 0)
			ApMsgInfo("Nใo foi possํvel salvar o arquivo !","Gera็ใo Confer๊ncia Ativo Fixo")
			Return
		EndIf
		
		Fclose(n_Han)
		
		ShellExecute("Open",c_Arq,"","",3)
		
	EndIf
	DbCloseArea()
Else
	ApMsgInfo("Nใo hแ dados para gera็ใo do arquivo !","Gera็ใo Confer๊ncia Ativo Fixo")
EndIf

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ษออออออออออออออออออัออออออออออออออออออออออหอออออออออออออัออออออออออออออออออออออออออออออออออออออออออออหออออออออัอออออออออออออออออป
บPrograma          ณ ATFR01B             บ Analista    ณ Willer Trindade                            บ  Data  ณ     24/10/12    บ
ฬออออออออออออออออออุออออออออออออออออออออออสอออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออสออออออออฯอออออออออออออออออน
บDescricao         ณ Monta a tela de parametros do relatorio                                                                    บ
ฬออออออออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
บUso               ณ Exclusivo : ATFR001                                                                                       บ
ศออออออออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ATFR01B(aPar)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Declaracao de variaveis                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Local a_Per := {}
Local l_Ret := .T.
Local a_Mes := {"--","01","02","03","04","05","06","07","08","09","10","11","12"}
Local a_Ano := GATFR01C()

aAdd(a_Per,{2,"Informe o M๊s ?",1,a_Mes,50,,.T.})
aAdd(a_Per,{2,"Informe o Ano ?",1,a_Ano,50,,.T.})

While .T.
	
	If ParamBox(a_Per,"Parametros",aPar,,,.T.,,,,,,)
		
		If aPar[1] == Iif(ValType(aPar[1]) == "N",1,"--") .Or. aPar[2] == Iif(ValType(aPar[2]) == "N",1,"----")
			If aPar[1] == Iif(ValType(aPar[1]) == "N",1,"--")
				ApMsgInfo ("M๊s para gera็ใo informado incorretamente","Aten็ใo")
				Loop
			EndIf
			
			If aPar[2] == Iif(ValType(aPar[2]) == "N",1,"----")
				ApMsgInfo ("Ano para gera็ใo informado incorretamente","Aten็ใo")
				Loop
			EndIf
			
		ElseIf 	aPar[1] <> Iif(ValType(aPar[1]) == "N",1,"--") .And. aPar[2] <> Iif(ValType(aPar[2]) == "N",1,"----")
			lRet := .T.
			Exit
		Else
			lRet := .F.
			Exit
		EndIf
		
	EndIf
End

Return(l_Ret)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ษออออออออออออออออออัออออออออออออออออออออออหอออออออออออออัออออออออออออออออออออออออออออออออออออออออออออหออออออออัอออออออออออออออออป
บPrograma          ณ GATFR01C             บ Analista    ณ Willer Trindade                            บ  Data  ณ     24/10/12    บ
ฬออออออออออออออออออุออออออออออออออออออออออสอออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออสออออออออฯอออออออออออออออออน
บDescricao         ณ Retorna um array de anos validos para o relatorio                                                          บ
ฬออออออออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
บUso               ณ Exclusivo : ATFR001                                                                                       บ
ศออออออออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function GATFR01C()

Local a_Ret := {}
Local n_Ini := Year(Date())
Local n_Fim := 2012
Local i

aAdd(a_Ret,"----")

For i := n_Ini To n_Fim Step -1
	aAdd(a_Ret,AllTrim(Str(i)))
Next

Return(a_Ret)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
