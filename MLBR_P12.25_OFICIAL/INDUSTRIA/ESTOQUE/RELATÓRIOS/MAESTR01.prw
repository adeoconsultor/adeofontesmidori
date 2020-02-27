#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMAESTR01  บAutor  ณBruno M. Mota       บ Data ณ  01/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina responsavel por imprimir o recibo das solicitacoes   บฑฑ
ฑฑบ          ณao armazem                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP 10.1          Espeficico - Midori                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MAESTR01(_lAutomatica)
//Variaveis locais da funcao
Local cPerg 	:= PADR("MAESTR01",10)
Local lRet		:= .F.             

Default _lAutomatica := .f.
//Variaveis privadas da funcao
Private nCount := 0
Private _cEnter := chr(13) + chr(10)
//Inicio da funcao
//Cria as perguntas
ValidPerg(cPerg)
//Verifica se o usuario parametrizou os relatorios


If FunName() == 'MATA185'
	mv_par01 := SCP->CP_NUM
	mv_par02 := SCP->CP_NUM
	mv_par03 := ''
	mv_par04 := 'zzz'
ElseIf !Pergunte(cPerg)
	//Envia mensagem de alerta
	Alert("Processamento cancelado pelo usuแrio...")
EndIf	

_cQuery := "SELECT SCQ.CQ_NUM, SCQ.CQ_ITEM, SCQ.CQ_PRODUTO, SB1.B1_DESC, SCQ.CQ_CC, MAX(SCP.CP_QUANT) CQ_QUANT,
_cQuery += _cEnter + "  SCQ.CQ_UM, SAH.AH_DESCPO, SCP.CP_OBS, SUM(ISNULL(SD3.D3_QUANT,CQ_QUANT)) D3_QUANT, CP_SOLICIT"

_cQuery += _cEnter + " FROM " + RetSqlName('SCQ') + " SCQ"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SB1') + " SB1"
_cQuery += _cEnter + " ON SCQ.CQ_PRODUTO = SB1.B1_COD"
_cQuery += _cEnter + " AND SB1.D_E_L_E_T_ <> '*'"
_cQuery += _cEnter + " AND SB1.B1_FILIAL = '" + xFilial('SB1') + "'"
                                                
_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SAH') + " SAH"
_cQuery += _cEnter + " ON SAH.AH_UNIMED = SB1.B1_UM"
_cQuery += _cEnter + " AND SAH.AH_FILIAL = '" + xFilial('SAH') + "'"
_cQuery += _cEnter + " AND SAH.D_E_L_E_T_ <> '*'"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SCP') + " SCP"
_cQuery += _cEnter + " ON SCP.CP_FILIAL = SCQ.CQ_FILIAL"
_cQuery += _cEnter + " AND SCP.CP_NUM = SCQ.CQ_NUM"
_cQuery += _cEnter + " AND SCP.CP_ITEM = SCQ.CQ_ITEM"
_cQuery += _cEnter + " AND SCP.D_E_L_E_T_ <> '*'"

_cQuery += _cEnter + " left  JOIN " + RetSqlName('SD3') + " SD3"
_cQuery += _cEnter + " ON SCQ.CQ_PRODUTO = SB1.B1_COD"
_cQuery += _cEnter + " AND SD3.D3_FILIAL = SCQ.CQ_FILIAL"
_cQuery += _cEnter + " AND SD3.D3_NUMSEQ = SCQ.CQ_NUMREQ"
_cQuery += _cEnter + " AND SD3.D_E_L_E_T_ <> '*'"

_cQuery += _cEnter + " WHERE SCQ.CQ_NUM BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
_cQuery += _cEnter + " AND SCQ.CQ_ITEM BETWEEN '"  + mv_par03 + "' AND '" + mv_par04 + "'"
_cQuery += _cEnter + " AND SCQ.CQ_FILIAL = '" + xFilial('SCQ') + "'" 
_cQuery += _cEnter + " AND SCQ.CQ_QTDISP > 0"
_cQuery += _cEnter + " AND SCQ.CQ_NUMREQ <> ''"
_cQuery += _cEnter + " AND SCQ.D_E_L_E_T_ <> '*'"

_cQuery += _cEnter + " GROUP BY SCQ.CQ_NUM, SCQ.CQ_ITEM, SCQ.CQ_PRODUTO, SB1.B1_DESC, SCQ.CQ_CC," 
_cQuery += _cEnter + " SCQ.CQ_UM, SAH.AH_DESCPO, SCP.CP_OBS, CP_SOLICIT"

MemoWrit("c:\spool\sql\maestr01.sql", _cQuery)    

If !_lAutomatica
	MsAguarde({|| dbUseArea( .T., 'TOPCONN', TCGENQRY(,,_cQuery), 'TMP', .F., .T.)},'Selecionando Pr้-Requisi็๕es...')
EndIf

Count to nCount	
//Verifica se a query retornou resultado
If nCount == 0
	Alert("Resultados nใo encontrados.")
	DbCloseArea()
	Return()
EndIf

DbGoTop()

//Query de totalizacao de registros
Processa({||Imprime()})	
//Fecha tabela TMP
TMP->(dbCloseArea())
//Retorno da rotina
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImprime   บAutor  ณBruno M. Mota       บ Data ณ  01/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina responsavel pela impressao do documento.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Imprime()
//Vaiaveis locais da funcao
Local cSAAtu	:= ""
Local nX		:= 0
//Variaveis privadas
Private aSizeH		:= {}
Private aSizeV		:= {}
Private oPrint		:= ""
Private oFont10  	:= ""
Private oFont10n	:= ""
Private oFont12		:= ""
Private oFont12n	:= ""
//Inicio da Fun็ao
oPrint := TMSPrinter():New("Impressใo de Recibo de Material",.T.) // Cria o objeto de impressao
//Cria objeto das fontes
oFont10 	:= TFont():New("Courier New",,10,,.F.,,,,.F.,.F.) //Courier New - Tam. 10 - Normal
oFont10n 	:= TFont():New("Courier New",,10,,.T.,,,,.F.,.F.) //Courier New - Tam. 10 - Negrito
oFont12 	:= TFont():New("Courier New",,12,,.F.,,,,.F.,.F.) //Courier New - Tam. 12 - Normal
oFont12n 	:= TFont():New("Courier New",,11,,.T.,,,,.F.,.F.) //Ariabrunol - Tam. 12 - Negrito
oFont16 	:= TFont():New("Courier New",,16,,.F.,,,,.F.,.F.) //Courier New - Tam. 16 - Normal
oFont16n 	:= TFont():New("Courier New",,16,,.T.,,,,.F.,.F.) //Courier New - Tam. 16 - Negrito
oFont20 	:= TFont():New("Courier New",,20,,.F.,,,,.F.,.F.) //Courier New - Tam. 20 - Normal
oFont20n 	:= TFont():New("Courier New",,20,,.T.,,,,.F.,.F.) //Courier New - Tam. 20 - Negrito

oPrint:Setup()
oPrint:SetLandscape()    

oPrint:SetPage(9)	//Tamanho do papel A4
ProcRegua(nCount)
TMP->(dbGoTop())
_cCodAnt := ''
Do While !TMP->(EoF())
	//Verifica a SA atual
	If (cSAAtu <> TMP->CQ_NUM) .Or. (nX > 75)
		oPrint:StartPage()
		//Seta um novo valor para a pagina atual
		cSAAtu := TMP->CQ_NUM
		MontaBox()
		nX := 15
	EndIf

	_cLinha := left(TMP->CQ_PRODUTO,6) 	+ '   ' + left(TMP->B1_DESC,50) + '   ' 
	_cLinha += left(TMP->CQ_CC,3)		+ '   ' + Transform(TMP->CQ_QUANT,"@E 999,999.99") + '   '
	_cLinha += Transform(TMP->D3_QUANT,"@E 999,999.99")	+ '   ' + TMP->CQ_UM + ' - ' + left(TMP->AH_DESCPO,10) + '   '
	_cLinha += TMP->CP_OBS

	oPrint:Say(aSizeV[nX],aSizeH[4],_cLinha	,oFont10)   	   	

   	//Atualiza nX
   	nX += 2
   	TMP->(dbSkip())
   	//Verifica se ้ a mesma SA, caso contrario, encerra o recibo
   	If (cSAAtu <> TMP->CQ_NUM) .Or. (nX > 75)
        oPrint:EndPage()
   	EndIf
   	IncProc("Imprimindo...")     
EndDo   
oPrint:Preview()
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaBox  บAutor  ณBruno M. Mota       บ Data ณ  01/14/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta o layout de impressao do relatorio                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaBox()
//Vaiaveis locais da funcao
Local nX		:= 0
Local nValResH	:= 0
Local nValResV	:= 0
//Inicio da funcao
//Dimensiona array de acordo com o tamanho horizontal (por propocao)
For nX := 1 To 100
	nValResH += (oPrint:nHorzRes()/100)
	nValResV += (oPrint:nVertRes()/100)
	AAdd(aSizeH,nValResH)
	AAdd(aSizeV,nValResV)
Next nX
//Cria box do relatorio
oPrint:Box(aSizeV[3],aSizeH[3],aSizeV[97],aSizeH[97])
//Imprime cabe็alho
oPrint:Say(aSizeV[5],aSizeH[38],"REQUISIวรO DE MATERIAL"	,oFont20n	)
oPrint:Say(aSizeV[8],aSizeH[5],"No.:"						,oFont16n	)
oPrint:Say(aSizeV[8],aSizeH[9],TMP->CQ_NUM					,oFont16 	)
oPrint:Say(aSizeV[8],aSizeH[25],"ENTRADA ( ) SAอDA ( )"		,oFont12n	)
oPrint:Say(aSizeV[8],aSizeH[55],"DATA:"						,oFont12n	)
oPrint:Say(aSizeV[8],aSizeH[60],DtoC(dDataBase)				,oFont12	)
//Imprime linha de divisao
oPrint:Line(aSizeV[10],aSizeH[3],aSizeV[10],aSizeH[97])
//Monta as linhas de colunas
oPrint:Line(aSizeV[10],aSizeH[09],aSizeV[80],aSizeH[09])
oPrint:Line(aSizeV[10],aSizeH[44],aSizeV[80],aSizeH[44])
oPrint:Line(aSizeV[10],aSizeH[50],aSizeV[80],aSizeH[50])
oPrint:Line(aSizeV[10],aSizeH[57],aSizeV[80],aSizeH[57])
oPrint:Line(aSizeV[10],aSizeH[66],aSizeV[80],aSizeH[66])
oPrint:Line(aSizeV[10],aSizeH[76],aSizeV[80],aSizeH[76])

//Monta cabecalho dos itens

_cLinha := "C๓digo   Descri็ใo                                            C.C    Qtd Solic   Qtd Entreg   Unidade            Observa็ใo"
//          123456   12345678901234567890123456789012345678901234567890   123   999,999,99   999,999,99   233 - 1234567890   123456789012345678901234567890
oPrint:Say(aSizeV[11],aSizeH[4]	,_cLinha		,oFont10n	)

//Imprime linhas de divisao
oPrint:Line(aSizeV[13],aSizeH[3],aSizeV[13],aSizeH[97])	
oPrint:Line(aSizeV[80],aSizeH[3],aSizeV[80],aSizeH[97])	
//Imprime as linhas de assinatura
oPrint:Line(aSizeV[88],aSizeH[15],aSizeV[88],aSizeH[40])	
oPrint:Line(aSizeV[88],aSizeH[50],aSizeV[88],aSizeH[85])
//Imprime as linhas dos responsaveis
oPrint:Say(aSizeV[90],aSizeH[23],"Almoxarifado"		,oFont12n	)
oPrint:Say(aSizeV[93],aSizeH[23],cUserName			,oFont12n	)
oPrint:Say(aSizeV[90],aSizeH[65],TMP->CP_SOLICIT	,oFont12n	)				
//Retorno da funcao
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณBruno M. Mota       บ Data ณ  13/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCadastra perguntas do relatorio                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP 8.11/R4 ou 10.1 - Especifico Midori                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg(cPerg)
//Variaveis locais
Local aRegs := {}
Local i,j
//Inicio da funcao
dbSelectArea("SX1")
dbSetOrder(1)
//   1          2        3         4          5           6       7       8             9        10      11     12       13        14        15         16       17       18       19        20          21        22      23        24       25         26        27       28       29       30          31        32       33       34        35          36        37     38     39       40       41        42
//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_PYME/X1_GRPSXG/X1_HELP/X1_PICTURE
AADD(aRegs,{cPerg,"01","De Solicita็ใo" 	,"","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Solicita็ใo"	,"","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","De Item" 			,"","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Item"			,"","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Loop de armazenamento
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif     
Next
//Retorno da funcao
Return()
