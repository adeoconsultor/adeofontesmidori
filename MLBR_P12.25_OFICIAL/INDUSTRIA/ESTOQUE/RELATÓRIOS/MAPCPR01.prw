#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMAPCPA01  บAutor  ณBruno M. Mota       บ Data ณ  01/21/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina responsavel por imprimir o relatorio de ordens de    บฑฑ
ฑฑบ          ณprodu็ใo.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MAPCPR01()
//Variaveis locais da funcao
Local cPerg 	:= PADR("MAPCPA01",10)
Local lRet		:= .T.
Local nQuant	:= 0
//Variaveis privadas da funcao
Private nEstru := 0
//Inicio da funcao
//Cria็ใo das perguntas do relatorio
ValidPerg(cPerg)
//Verifica se o usuแrio configurou as perguntas
If !Pergunte(cPerg,.T.)
	//Retorno da rotina
	Return()
EndIf
//Inicia a query com os dados das OPS a serem explodidas
BeginSql Alias "SC2TMP"
%NoParser%
SELECT
	SC2.C2_FILIAL,
	SC2.C2_NUM,
	SC2.C2_ITEM,
	SC2.C2_SEQUEN,
	SC2.C2_ITEMGRD,
	SC2.C2_DATPRF,
	SC2.C2_DATRF,
	SC2.C2_PRODUTO,
	SC2.C2_DESTINA,
	SC2.C2_PEDIDO,
	SC2.C2_ROTEIRO,
	SC2.C2_QUJE,
	SC2.C2_PERDA,
	SC2.C2_QUANT,
	SC2.C2_DATPRI,
	SC2.C2_CC,
	SC2.C2_DATAJI,
	SC2.C2_DATAJF,
	SC2.C2_STATUS,
	SC2.C2_OBS,
	SC2.C2_TPOP,
	CASE 
		WHEN SA1.A1_NOME IS NULL 
		THEN ' ' 
		ELSE SA1.A1_NOME 
	END A1_NOME ,
	SB1.B1_DESC 
FROM
	%Table:SC2% SC2 
		LEFT OUTER JOIN %Table:SC5% SC5 
		ON SC2.C2_PEDIDO = SC5.C5_NUM 
		LEFT OUTER JOIN %Table:SA1% SA1 
		ON SC5.C5_CLIENTE = SA1.A1_COD AND
		SC5.C5_LOJACLI = SA1.A1_LOJA 
		INNER JOIN %Table:SB1% SB1 
		ON SB1.B1_COD = SC2.C2_PRODUTO 
WHERE
	SC2.C2_FILIAL = %xFilial:SC2% AND
	SC2.C2_NUM BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND
	SC2.C2_ITEM BETWEEN %Exp:mv_par03% AND %Exp:mv_par04% AND
	SC2.C2_SEQUEN BETWEEN %Exp:mv_par05% AND %Exp:mv_par06% AND
	SC2.C2_ITEMGRD BETWEEN %Exp:mv_par07% AND %Exp:mv_par08% AND
	SC2.C2_DATPRF BETWEEN %Exp:mv_par09% AND %Exp:mv_par10% AND
	SC2.%NotDel%
ORDER BY 
	SC2.C2_NUM,SC2.C2_ITEM,SC2.C2_SEQUEN
EndSql	
//Verifica se a consulta retornou informacoes
If SC2TMP->(EoF()) .And. SC2TMP->(BoF())
	//Ajusta o retorno da rotina
	lret := .F.
EndIf
//Verifica se ocorrerแ a impressao
If !lRet
	//Mensagem de erro
	Alert("Nใo hแ informa็๕es a exibir, verifique os parametros.")
Else
	//Executa a query de quantidade de registros
	BeginSql Alias "QUANT"
	%NoParser%
	SELECT
		COUNT(*) QUANT
	FROM
		%Table:SC2% SC2
	WHERE
		SC2.C2_FILIAL = %xFilial:SC2% AND
		SC2.C2_NUM >= %Exp:mv_par01% AND
		SC2.C2_ITEM >= %Exp:mv_par02% AND
		SC2.C2_SEQUEN >= %Exp:mv_par03% AND
		SC2.C2_ITEMGRD >= %Exp:mv_par04% AND
		SC2.C2_NUM <= %Exp:mv_par05% AND
		SC2.C2_ITEM <= %Exp:mv_par06% AND
		SC2.C2_SEQUEN <= %Exp:mv_par07% AND
		SC2.C2_ITEMGRD <= %Exp:mv_par08% AND
		SC2.C2_DATPRF BETWEEN %Exp:mv_par09% AND
		%Exp:mv_par10% AND
		SC2.%NotDel%
	EndSql
	//Ajusta nQuant
	nQuant := QUANT->QUANT
	//Fecha tabela temporaria
	QUANT->(dbCloseArea())
	//Inicia processamento da rotina
	Processa({||Imprime(nQuant)})
EndIf
//Fecha a tabela temporaria
SC2TMP->(dbCloseArea())
//Retorno da rotina
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMAPCPA01  บAutor  ณBruno M. Mota       บ Data ณ  01/21/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina responsavel por imprimir o relatorio de ordens de    บฑฑ
ฑฑบ          ณprodu็ใo.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Imprime(nQuant)
//Vaiaveis locais da funcao
Local cSC2Atu	:= ""
Local cSC2Itm	:= ""
Local cSC2Seq	:= ""
Local cArqNome	:= ""
Local lPag		:= .T.
Local nX		:= 10
//Variaveis privadas
Private aSizeH		:= {}
Private aSizeV		:= {}
Private oPrint		:= ""
Private oFont08  	:= ""
Private oFont08n	:= ""
Private oFont09		:= ""
Private oFont09n	:= ""
Private oFont10  	:= ""
Private oFont10n	:= ""
Private oFont12		:= ""
Private oFont12n	:= ""
//Inicio da Fun็ao
oPrint := TMSPrinter():New("Impressใo de Ordem de Produ็ใo",.T.) // Cria o objeto de impressao
//Cria objeto das fontes
oFont08 	:= TFont():New("Arial",,08,,.F.,,,,.F.,.F.) //Arial - Tam. 08 - Normal
oFont08n 	:= TFont():New("Arial",,08,,.T.,,,,.F.,.F.) //Arial - Tam. 08 - Negrito
oFont09 	:= TFont():New("Arial",,09,,.F.,,,,.F.,.F.) //Arial - Tam. 09 - Normal
oFont09n 	:= TFont():New("Arial",,09,,.T.,,,,.F.,.F.) //Arial - Tam. 09 - Negrito
oFont10 	:= TFont():New("Arial",,10,,.F.,,,,.F.,.F.) //Arial - Tam. 10 - Normal
oFont10n 	:= TFont():New("Arial",,10,,.T.,,,,.F.,.F.) //Arial - Tam. 10 - Negrito
oFont12 	:= TFont():New("Arial",,12,,.F.,,,,.F.,.F.) //Arial - Tam. 12 - Normal
oFont12n 	:= TFont():New("Arial",,12,,.T.,,,,.F.,.F.) //Arial - Tam. 12 - Negrito
oFont14 	:= TFont():New("Arial",,14,,.F.,,,,.F.,.F.) //Arial - Tam. 14 - Normal
oFont14n 	:= TFont():New("Arial",,14,,.T.,,,,.F.,.F.) //Arial - Tam. 14 - Negrito
oFont16 	:= TFont():New("Arial",,16,,.F.,,,,.F.,.F.) //Arial - Tam. 16 - Normal
oFont16n 	:= TFont():New("Arial",,16,,.T.,,,,.F.,.F.) //Arial - Tam. 16 - Negrito
oFont20 	:= TFont():New("Arial",,20,,.F.,,,,.F.,.F.) //Arial - Tam. 20 - Normal
oFont20n 	:= TFont():New("Arial",,20,,.T.,,,,.F.,.F.) //Arial - Tam. 20 - Negrito
//Setup da impressora
oPrint:Setup()
//Tamanho do papel A4
oPrint:SetPage(9)
//Cria a divisao proporcional da folha de impressao
CriaDiv(100)
//Atualiza regua de processamento
ProcRegua(nQuant)
//Posiciona tabela
SC2TMP->(dbGoTop())
//Loop de processamento
While !SC2TMP->(EoF())
	//Inicia a query com os dados dos produtos empenhados para a OP
	BeginSql Alias "SD4TMP"
	%NoParser%
	SELECT
		D4_COD,
		D4_LOCAL,
		D4_DATA,
		D4_QUANT,
		D4_TRT,
		B1_DESC 
	FROM
		SD4010 SD4 
			INNER JOIN SB1010 SB1 
			ON D4_COD = B1_COD 
	WHERE
		SD4.D_E_L_E_T_ = ' ' AND
		SD4.D4_FILIAL = %Exp:xFilial("SD4")% AND
		SD4.D4_OP = %Exp:SC2TMP->C2_NUM+SC2TMP->C2_ITEM+SC2TMP->C2_SEQUEN+SC2TMP->C2_ITEMGRD%
	EndSql		
	//Verifica se a query trouxe resultado
	If SD4TMP->(EoF()) .And. SD4TMP->(BoF())
		//Muda de registro
	    SC2TMP->(dbSkip())
		//Fecha tabela temporaria
	    SD4TMP->(dbCloseArea())
		//Muda de registro
		Loop
	EndIf	
	//Verifica a OP atual
	If ((cSC2Atu+cSC2Itm+cSC2Seq <> SC2TMP->C2_NUM+SC2TMP->C2_ITEM+SC2TMP->C2_SEQUEN) .And. (lPag)) .Or. ((cSC2Atu+cSC2Itm+cSC2Seq <> SC2TMP->C2_NUM+SC2TMP->C2_ITEM+SC2TMP->C2_SEQUEN) .And. (nX > 82))
		//Verifica se ja imprimiu a pagina inicial
        If (!lPag)
			//Fecha pagina aberta
			IniPag("F")
		EndIf	
		//Inicia pagina
		IniPag("I")
		//Cabe็alho da OP
		nX := CabecOP(10)
		//Atualiza variavel
		cSC2Atu := SC2TMP->C2_NUM
		cSC2Itm := SC2TMP->C2_ITEM
		cSC2Seq := SC2TMP->C2_SEQUEN
		//Ajusta lPag
		lPag := .F.
	ElseIf 	(cSC2Atu+cSC2Itm+cSC2Seq <> SC2TMP->C2_NUM+SC2TMP->C2_ITEM+SC2TMP->C2_SEQUEN)
		//Cabe็alho da OP
		nX := CabecOP(nX)
		//Atualiza variavel
		cSC2Atu := SC2TMP->C2_NUM
		cSC2Itm := SC2TMP->C2_ITEM
		cSC2Seq := SC2TMP->C2_SEQUEN
    EndIf
	//Loop de Processamento da Estrutura
	While !SD4TMP->(EoF())
		//Imprime dados da estrutura
		oPrint:Say(aSizeV[nX],aSizeH[5],SD4TMP->D4_COD,oFont10)
		oPrint:Say(aSizeV[nX],aSizeH[25],SubStr(SD4TMP->B1_DESC,1,40),oFont10)
		oPrint:Say(aSizeV[nX],aSizeH[70],Transform(SD4TMP->D4_QUANT,"@E 999,999,999,999.99"),oFont10)
		oPrint:Say(aSizeV[nX],aSizeH[85],SD4TMP->D4_TRT,oFont10)
		//Pula de linha
		nX += 2
		SD4TMP->(dbSkip())
		//Verifica se atingiu o numero maximo de itens na folha
		If nX > 90
			//finaliza pagina
			IniPag("F")
			//Inicia pagina
			IniPag("I")
			//Reseta nX
			If (cSC2Atu+cSC2Itm+cSC2Seq == SC2TMP->C2_NUM+SC2TMP->C2_ITEM+SC2TMP->C2_SEQUEN)
				nX := CorpoOp(10)
			Else
				nX := 10
			EndIf
		EndIf	
	EndDo
	//Fecha tabela temporaria
    SD4TMP->(dbCloseArea())
	//Ajusta regua
	IncProc("Imprimindo relat๓rio.")
	SC2TMP->(dbSkip())	
EndDo
//Vizualiza impressใo
oPrint:Preview()
//Retorno da funcao
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaDiv   บAutor  ณBruno M. Mota       บ Data ณ  01/21/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDivide a pagina do relatorio em celulas proporcionais       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaDiv(nVal)
//Vaiaveis locais da funcao
Local nValResH	:= 0
Local nValResV	:= 0
Local nX
//Inicio da funcao
//Dimensiona array de acordo com o tamanho horizontal (por propocao)
For nX := 1 To nVal
	nValResH += (oPrint:nHorzRes()/nVal)
	nValResV += (oPrint:nVertRes()/nVal)
	AAdd(aSizeH,nValResH)
	AAdd(aSizeV,nValResV)
Next nX
//Retorno da funcao
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIniPag    บAutor  ณBruno M. Mota       บ Data ณ  01/21/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina responsavel por iniciar a pagina e montar cabe็alho  บฑฑ
ฑฑบ          ณdo relatorio                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IniPag(cVal)
//Vaiaveis locais da funcao
//Inicio da funcao
//Verifica a opcao do usuario
If cVal == "I"
	//Inicia a pagina
	oPrint:StartPage()
	//Monta o box da pagina
	oPrint:Box(aSizeV[3],aSizeH[3],aSizeV[97],aSizeH[97],oFont12n)
	//Imprime logo da empresa
	oPrint:SayBitmap(aSizeV[4],aSizeH[90],"lgr010.bmp",aSizeH[6],aSizeH[6])
	//Imprime cabe็alho
	oPrint:Say(aSizeV[5],aSizeH[42],"Ordem de Produ็ใo",oFont20n)
	oPrint:Say(aSizeV[8],aSizeH[5],Upper(SM0->M0_FILIAL),oFont12n)
	//Imprime linha divis๓ria
	oPrint:Line(aSizeV[10],aSizeH[03],aSizeV[10],aSizeH[97])
ElseIf cVal == "F"
	oPrint:EndPage()
EndIf
//Retorno da rotina
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIniPag    บAutor  ณBruno M. Mota       บ Data ณ  01/21/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina responsavel por iniciar a pagina e montar cabe็alho  บฑฑ
ฑฑบ          ณdo relatorio                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CabecOP(nX)
//Inicio da funcao
//Imprime linha divis๓ria
oPrint:Line(aSizeV[nX],aSizeH[03],aSizeV[nX],aSizeH[97])
nX += 1
oPrint:Say(aSizeV[nX],aSizeH[5],"Ordem de Produ็ใo No.: -",oFont12n)
oPrint:Say(aSizeV[nX],aSizeH[27],SC2TMP->C2_NUM,oFont12)
oPrint:Say(aSizeV[nX],aSizeH[33],"Item:",oFont12n)
oPrint:Say(aSizeV[nX],aSizeH[38],SC2TMP->C2_ITEM,oFont12)
oPrint:Say(aSizeV[nX],aSizeH[43],"Sequencia:",oFont12n)
oPrint:Say(aSizeV[nX],aSizeH[53],SC2TMP->C2_SEQUEN,oFont12)
oPrint:Say(aSizeV[nX],aSizeH[60],"Item da Grade:",oFont12n)
oPrint:Say(aSizeV[nX],aSizeH[5],SC2TMP->C2_ITEMGRD,oFont12)
nX += 2
oPrint:Say(aSizeV[nX],aSizeH[5],"Data Entrega:",oFont12n)
oPrint:Say(aSizeV[nX],aSizeH[20],DTOC(STOD(SC2TMP->C2_DATPRF)),oFont12)
oPrint:Say(aSizeV[nX],aSizeH[32],"Data Inicio:",oFont12n)
oPrint:Say(aSizeV[nX],aSizeH[45],DTOC(STOD(SC2TMP->C2_DATPRI)),oFont12)
oPrint:Say(aSizeV[nX],aSizeH[52],"Pedido No.:",oFont12n)
oPrint:Say(aSizeV[nX],aSizeH[64],SC2TMP->C2_PEDIDO,oFont12)
oPrint:Say(aSizeV[nX],aSizeH[72],"Cod. Produto:",oFont12n)
oPrint:Say(aSizeV[nX],aSizeH[84],SC2TMP->C2_PRODUTO,oFont12)
nX += 2
oPrint:Say(aSizeV[nX],aSizeH[5],"Desc. Prod:",oFont12n)
oPrint:Say(aSizeV[nX],aSizeH[15],SubStr(SC2TMP->B1_DESC,1,40),oFont12)
nX += 2
oPrint:Say(aSizeV[nX],aSizeH[5],"Quantidade:",oFont12n)
oPrint:Say(aSizeV[nX],aSizeH[15],Transform(SC2TMP->C2_QUANT,"@E 999,999,999,999,999.99"),oFont12)
oPrint:Say(aSizeV[nX],aSizeH[35],"Centro de Custo:",oFont12n)
oPrint:Say(aSizeV[nX],aSizeH[49],SC2TMP->C2_CC,oFont12)
oPrint:Say(aSizeV[nX],aSizeH[69],"Status:",oFont12n)
oPrint:Say(aSizeV[nX],aSizeH[77],SC2TMP->C2_STATUS,oFont12)
nX += 2
oPrint:Say(aSizeV[nX],aSizeH[5],"Observa็ใo:",oFont12n)
oPrint:Say(aSizeV[nX],aSizeH[15],SC2TMP->C2_OBS,oFont12)
nX += 2
//Imprime linha divis๓ria
oPrint:Line(aSizeV[nX],aSizeH[03],aSizeV[nX],aSizeH[97])
//Monta cabecalho dos itens
nX := CorpoOp(nX)
//Retorno da rotina
Return(nX)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCorpoOp   บAutor  ณBruno M. Mota       บ Data ณ  01/21/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina responsavel por iniciar a pagina e montar cabe็alho  บฑฑ
ฑฑบ          ณdo corpo do relatorio                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CorpoOp(nX)
//Inicio da funcao
oPrint:Say(aSizeV[nX],aSizeH[10],"C๓digo",oFont12n)
oPrint:Say(aSizeV[nX],aSizeH[35],"Descri็ใo",oFont12n)
oPrint:Say(aSizeV[nX],aSizeH[70],"Quantidade",oFont12n)
oPrint:Say(aSizeV[nX],aSizeH[85],"Sequencia",oFont12n)
//Retorno da funcao
Return(nX+2)
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
AADD(aRegs,{cPerg,"01","De OP" 			,"","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC2","","","",""})
AADD(aRegs,{cPerg,"02","Ate Op"			,"","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC2","","","",""})
AADD(aRegs,{cPerg,"03","De Item" 		,"","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Item"		,"","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","De Sequencia " 	,"","","mv_ch5","C",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate Sequencia"	,"","","mv_ch6","C",03,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","De Item Grade" 	,"","","mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate Item Grade"	,"","","mv_ch8","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","De Entrega" 	,"","","mv_ch9","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Ate Entrega"	,"","","mv_cha","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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