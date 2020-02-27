#include "RWMAKE.CH"
#include "PROTHEUS.CH"

///////////////////////////////////////////////////////////////////////////////////////////////
//Programa para imprimir a minuta de transporte gerada pelo sistema
//Desenvolvido por Anesio G.Faria - anesio@hakodistribuidora.com.br
//Data 29-05-2013
///////////////////////////////////////////////////////////////////////////////////////////////
User Function AG_PMINUTA()

//Variaveis locais da funcao
Local cPerg 	:= PADR("AGMINUTA",10)
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

BeginSql Alias "TRBF2"
%NoParser%
SELECT
	F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_TRANSP,F2_VALBRUT,F2_PLIQUI,F2_PBRUTO,F2_ESPECI1,F2_TIPO,F2_VOLUME1, F2_PLACA, F2_EMISSAO
FROM
	%Table:SF2% SF2
		INNER JOIN %Table:SA1% SA1 
		ON SA1.A1_COD = SF2.F2_CLIENTE AND
		SA1.A1_LOJA = SF2.F2_LOJA
WHERE
	SF2.F2_SERIE = %Exp:mv_par01% AND
	SF2.F2_DOC between %Exp:mv_par02% AND %Exp:mv_par03% AND 
	SF2.%NotDel% AND
	SF2.F2_FILIAL = %Exp:xFilial("SF2")% AND
	SA1.A1_FILIAL = %Exp:xFilial("SA1")% AND
	SA1.%NotDel%
ORDER BY
	SA1.A1_NOME,SF2.F2_DOC
EndSql	
//Verifica se a consulta retornou informacoes
If TRBF2->(EoF()) .And. TRBF2->(BoF())
	//Ajusta o retorno da rotina
	lret := .F.
EndIf
//Verifica se ocorrerแ a impressao
If !lRet
	//Mensagem de erro
	Alert("Nใo hแ informa็๕es a exibir, verifique os parametros.")
Else
	//Inicia processamento da rotina
	Processa({||Imprime()})
EndIf
//Fecha a tabela temporaria
TRBF2->(dbCloseArea())
//Retorno da rotina
Return()

///////////////////////////////////////////////////////////////////////////////////////////////
//Faz a Impressao da minuta
//Desenvolvido por Anesio G.Faria - anesio@hakodistribuidora.com.br
//Data 14-07-2012
///////////////////////////////////////////////////////////////////////////////////////////////
Static Function Imprime()
//Vaiaveis locais da funcao
Local cDataAtu	:= ""
Local lPag		:= .T.
Local nX		:= 18
Local nRec		:= 0
Local nPag		:= 0
Local nTotRec	:= 0
Local nTotPag	:= 0
Local nSaldo	:= 0
Local nSalAnt	:= 0
Local nCxValor,nIt 	:= 0
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
oPrint := TMSPrinter():New("Impressใo de Minuta de Embarque de Mercadorias",.T.) // Cria o objeto de impressao
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
oPrint:SetPortrait()
//Tamanho do papel A4
oPrint:SetPage(9)
//Cria a divisao proporcional da folha de impressao
CriaDiv(100)
//Atualiza regua de processamento
//ProcRegua() //(nQuant)
//Imprime cabe็alho
ImpPag("I")
//Posiciona tabela
TRBF2->(dbGoTop())
//Loop de processamento
nSomaVlr:= 0
nSomaVol:= 0
nSomaPes:= 0
nSomaPBr:= 0
cOldCli := TRBF2->F2_CLIENTE
aItens  := {}
cCliente := "" 
cTransp  := "" 
cPlaca   := ""
While !TRBF2->(EoF())
	If (nX > 40) .or. cOldCli <> TRBF2->F2_CLIENTE

		oPrint:Say(aSizeV[31],aSizeH[4],"TOTAIS --->>>",oFont12n)
		oPrint:Say(aSizeV[31],aSizeH[27],Transform(nSomaVlr,"@E 9,999,999.99"),oFont12n)
		oPrint:Say(aSizeV[31],aSizeH[42],Transform(nSomaPBr,"@E 9,999,999.99"),oFont12n)
		oPrint:Say(aSizeV[31],aSizeH[57],Transform(nSomaPes,"@E 9,999,999.99"),oFont12n)
		oPrint:Say(aSizeV[31],aSizeH[73],Transform(nSomaVol,"@E 9,999,999"),oFont12n)
		nXIt := 66
		for nIt := 1 to len(aItens)

			oPrint:Say(aSizeV[nXIt],aSizeH[4],aItens[nIt][1],oFont10)
			oPrint:Say(aSizeV[nXIt],aSizeH[30],Transform(aItens[nIt][2],"@E 9,999,999.99"),oFont10)
			oPrint:Say(aSizeV[nXIt],aSizeH[45],Transform(aItens[nIt][3],"@E 9,999,999.99"),oFont10)	
			oPrint:Say(aSizeV[nXIt],aSizeH[60],Transform(aItens[nIt][4],"@E 9,999,999.99"),oFont10)
			oPrint:Say(aSizeV[nXIt],aSizeH[75],Transform(aItens[nIt][5],"@E 9,999,999"),oFont10)
			oPrint:Say(aSizeV[nXIt],aSizeH[85],aItens[nIt][6],oFont10)	
			nXIt++
		next nIt

		oPrint:Say(aSizeV[81],aSizeH[4],"TOTAIS --->>>",oFont12n)
		oPrint:Say(aSizeV[81],aSizeH[27],Transform(nSomaVlr,"@E 9,999,999.99"),oFont12n)
		oPrint:Say(aSizeV[81],aSizeH[42],Transform(nSomaPBr,"@E 9,999,999.99"),oFont12n)
		oPrint:Say(aSizeV[81],aSizeH[57],Transform(nSomaPes,"@E 9,999,999.99"),oFont12n)
		oPrint:Say(aSizeV[81],aSizeH[73],Transform(nSomaVol,"@E 9,999,999"),oFont12n)
		aItens := {}
		
		Imp2Via("I", cCliente, cTransp, cPlaca)
		
		nSomaVlr:=0
		nSomaVol:=0
		nSomaPes:=0
		nSomaPBr:=0


		//Finaliza pagina
		ImpPag("F")
		//Inicializa nova pagina
		ImpPag("I")
		//Reseta nX
		nX := 18
	ElseIf (lPag) 

		//Ajusta a data
//		cDataAtu := TRBF2->F2_EMISSAO
		//Ajusta lPag
		lPag := .F.
	EndIf	
	oPrint:Say(aSizeV[nX],aSizeH[4],TRBF2->F2_DOC+'-'+TRBF2->F2_SERIE,oFont10)
	oPrint:Say(aSizeV[nX],aSizeH[30],Transform(TRBF2->F2_VALBRUT,"@E 9,999,999.99"),oFont10)
	oPrint:Say(aSizeV[nX],aSizeH[45],Transform(TRBF2->F2_PBRUTO,"@E 9,999,999.99"),oFont10)	
	oPrint:Say(aSizeV[nX],aSizeH[60],Transform(TRBF2->F2_PLIQUI,"@E 9,999,999.99"),oFont10)
	oPrint:Say(aSizeV[nX],aSizeH[75],Transform(TRBF2->F2_VOLUME1,"@E 9,999,999"),oFont10)
	oPrint:Say(aSizeV[nX],aSizeH[85],TRBF2->F2_ESPECI1,oFont10)	
//	oPrint:Say(aSizeV[nX],aSizeH[83],TRBF2->(A1_MUN+'/'+A1_EST),oFont10)	
    
	//Array para guardar os itens e imprimir segunda via...
	aaDD( aItens, { TRBF2->F2_DOC+'-'+TRBF2->F2_SERIE, TRBF2->F2_VALBRUT, TRBF2->F2_PBRUTO, TRBF2->F2_PLIQUI, TRBF2->F2_VOLUME1, TRBF2->F2_ESPECI1})
	cCliente := TRBF2->(F2_CLIENTE+F2_LOJA)
	cTransp  := TRBF2->F2_TRANSP
	cPlaca 	 := Posicione("SC5",1,xFilial("SC5")+Posicione("SD2",3,xFilial("SD2")+TRBF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA),"D2_PEDIDO"),"C5_X_VEIC")
	
	nSomaVlr+=TRBF2->F2_VALBRUT
	nSomaVol+=TRBF2->F2_VOLUME1
	nSomaPes+=TRBF2->F2_PLIQUI
	nSomaPBr+=TRBF2->F2_PBRUTO 
	nX += 1
	cOldCli := TRBF2->F2_CLIENTE
	TRBF2->(dbSkip())
EndDo	                                                    
oPrint:Say(aSizeV[31],aSizeH[4],"TOTAIS --->>>",oFont12n)
oPrint:Say(aSizeV[31],aSizeH[27],Transform(nSomaVlr,"@E 9,999,999.99"),oFont12n)
oPrint:Say(aSizeV[31],aSizeH[42],Transform(nSomaPBr,"@E 9,999,999.99"),oFont12n)
oPrint:Say(aSizeV[31],aSizeH[57],Transform(nSomaPes,"@E 9,999,999.99"),oFont12n)
oPrint:Say(aSizeV[31],aSizeH[73],Transform(nSomaVol,"@E 9,999,999"),oFont12n)

/////////////////////////////////////////////////////////////////////////////////////////////////
//IMPRIME A SEGUNDA VIA DA ULTIMA PAGINA DA MINUTA
/////////////////////////////////////////////////////////////////////////////////////////////////
nXIt := 66
for nIt := 1 to len(aItens)

	oPrint:Say(aSizeV[nXIt],aSizeH[4],aItens[nIt][1],oFont10)
	oPrint:Say(aSizeV[nXIt],aSizeH[30],Transform(aItens[nIt][2],"@E 9,999,999.99"),oFont10)
	oPrint:Say(aSizeV[nXIt],aSizeH[45],Transform(aItens[nIt][3],"@E 9,999,999.99"),oFont10)	
	oPrint:Say(aSizeV[nXIt],aSizeH[60],Transform(aItens[nIt][4],"@E 9,999,999.99"),oFont10)
	oPrint:Say(aSizeV[nXIt],aSizeH[75],Transform(aItens[nIt][5],"@E 9,999,999"),oFont10)
	oPrint:Say(aSizeV[nXIt],aSizeH[85],aItens[nIt][6],oFont10)	
	nXIt++
next nIt

oPrint:Say(aSizeV[81],aSizeH[4],"TOTAIS --->>>",oFont12n)
oPrint:Say(aSizeV[81],aSizeH[27],Transform(nSomaVlr,"@E 9,999,999.99"),oFont12n)
oPrint:Say(aSizeV[81],aSizeH[42],Transform(nSomaPBr,"@E 9,999,999.99"),oFont12n)
oPrint:Say(aSizeV[81],aSizeH[57],Transform(nSomaPes,"@E 9,999,999.99"),oFont12n)
oPrint:Say(aSizeV[81],aSizeH[73],Transform(nSomaVol,"@E 9,999,999"),oFont12n)
aItens := {}

Imp2Via("I", cCliente, cTransp, cPlaca)
/////////////////////////////////////////////////////////////////////////////////////////////////
//FIM DA IMPRESSA DA ULTIMA PAGINA
/////////////////////////////////////////////////////////////////////////////////////////////////



//Vizualiza impressใo
oPrint:Preview()
//Retorno da funcao
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaDiv   บAutor  ณBruno M. Mota       บ Data ณ  01/27/10   บฑฑ
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
Local nValResH
Local nValResV
Local nX := 0
//Inicio da funcao
//Dimensiona array de acordo com o tamanho horizontal (por propocao)
nValResH := 0
nValResV := 0
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
ฑฑบPrograma  ณImpPag    บAutor  ณBruno M. Mota       บ Data ณ  01/27/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina responsavel por iniciar a pagina e montar cabe็alho  บฑฑ
ฑฑบ          ณdo relatorio                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpPag(cVal)
//Vaiaveis locais da funcao
Local nX := 0
//Inicio da funcao
//Verifica a opcao do usuario
If cVal == "I"
	//Inicia a pagina
	oPrint:StartPage()
	//Monta o box da pagina
	oPrint:Box(aSizeV[3],aSizeH[3],aSizeV[97],aSizeH[97])
	oPrint:Say(aSizeV[3],aSizeH[90],"1 via cliente " ,oFont08)
	//Imprime logo da empresa
	oPrint:SayBitmap(aSizeV[4],aSizeH[4],"lgrl01.bmp",aSizeH[16],aSizeH[5])
	//Imprime cabe็alho
	oPrint:Say(aSizeV[5],aSizeH[55],"MINUTA DE DESPACHO " ,oFont14n)
	oPrint:Say(aSizeV[7],aSizeH[55],"DATA DE EMBARQUE: "+DTOC(dDatabase),oFont14n)
	oPrint:Say(aSizeV[7],aSizeH[7] ,"MIDORI AUTO LEATHER BRASIL LTDA",oFont14n)
	oPrint:Say(aSizeV[10],aSizeH[5],"CLIENTE: "+Posicione('SA1',1,xFilial('SA1')+TRBF2->(F2_CLIENTE+F2_LOJA),"A1_NOME"),oFont10n)
	oPrint:Say(aSizeV[11],aSizeH[5],"END: "+Posicione('SA1',1,xFilial('SA1')+TRBF2->(F2_CLIENTE+F2_LOJA),"A1_END"),oFont10n)
	

	oPrint:Say(aSizeV[13],aSizeH[5],"TRANSPORTADORA: "+Posicione('SA4',1,xFilial('SA4')+TRBF2->F2_TRANSP,"A4_NOME")+ ' FONE: '+ Posicione('SA4',1,xFilial('SA4')+TRBF2->F2_TRANSP,"A4_DDD")+'-'+Posicione('SA4',1,xFilial('SA4')+TRBF2->F2_TRANSP,"A4_TEL"),oFont10n)
	oPrint:Say(aSizeV[14],aSizeH[5],"PLACA: "+Posicione("SC5",1,xFilial("SC5")+Posicione("SD2",3,xFilial("SD2")+TRBF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA),"D2_PEDIDO"),"C5_X_VEIC"), oFont10n)
	//Imprime linha divis๓ria
	oPrint:Line(aSizeV[10],aSizeH[03],aSizeV[10],aSizeH[97])
	//Imprime cabecalho dos campos
	oPrint:Say(aSizeV[16],aSizeH[4],"NOTA/SERIE",oFont12n)
	oPrint:Say(aSizeV[16],aSizeH[32],"VALOR",oFont12n)	
	oPrint:Say(aSizeV[16],aSizeH[42],"PESO BRUTO",oFont12n)
	oPrint:Say(aSizeV[16],aSizeH[60],"PESO LIQ",oFont12n)
	oPrint:Say(aSizeV[16],aSizeH[73],"VOLUME",oFont12n)
	oPrint:Say(aSizeV[16],aSizeH[85],"ESPECIE",oFont12n)	

	//impressaod e cabecalho
	oPrint:Line(aSizeV[16],aSizeH[03],aSizeV[16],aSizeH[97])
	oPrint:Line(aSizeV[18],aSizeH[03],aSizeV[18],aSizeH[97])

	//Linhas de quadricular os totais...
	oPrint:Line(aSizeV[30],aSizeH[03],aSizeV[30],aSizeH[97])
	oPrint:Line(aSizeV[33],aSizeH[03],aSizeV[33],aSizeH[97])	

  //Cria as 2 linhas para assinatura 
  	oPrint:Line(aSizeV[37],aSizeH[15],aSizeV[37],aSizeH[35])
  	oPrint:Line(aSizeV[37],aSizeH[20],aSizeV[36],aSizeH[21])
	oPrint:Say(aSizeV[36],aSizeH[5],"Data:",oFont12n)	
  	oPrint:Line(aSizeV[37],aSizeH[25],aSizeV[36],aSizeH[26])  	
    oPrint:Line(aSizeV[42],aSizeH[15],aSizeV[42],aSizeH[35])
   	oPrint:Say(aSizeV[42],aSizeH[20],"NOME LEGIVEL",oFont12n)	
    
	//Monta as linhas verticais para separa็ใo dos valores
	oPrint:Line(aSizeV[16],aSizeH[21],aSizeV[33],aSizeH[21]) //CLIENTE
	oPrint:Line(aSizeV[16],aSizeH[40],aSizeV[33],aSizeH[40]) //VALOR
	oPrint:Line(aSizeV[16],aSizeH[55],aSizeV[33],aSizeH[55]) //VOLUMES
	oPrint:Line(aSizeV[16],aSizeH[70],aSizeV[33],aSizeH[70]) //PESO
	oPrint:Line(aSizeV[16],aSizeH[82],aSizeV[33],aSizeH[82]) 

ElseIf cVal == "F"
	oPrint:EndPage()
EndIf
//Retorno da rotina
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
AADD(aRegs,{cPerg,"01","Serie da Nota 		","","","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
AADD(aRegs,{cPerg,"02","Da Nota Fiscal 		","","","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SF2","","","",""})
AADD(aRegs,{cPerg,"03","Ate a Nota Fiscal	","","","mv_ch3","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SF2","","","",""})
//AADD(aRegs,{cPerg,"04","Ate Emissao"	,"","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"05","Subtotal X Dia"	,"","","mv_ch5","C",03,0,0,"C","","mv_par05","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","","",""})
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


////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para imprimir o Rodap้
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Imp2Via(cVal, cCliente, cTransp, cPlaca)
//Vaiaveis locais da funcao
Local nX := 0
//Inicio da funcao
//Verifica a opcao do usuario
	//Imprime logo da empresa
	oPrint:Say(aSizeV[48],aSizeH[88],"2 via empresa " ,oFont08)
	oPrint:SayBitmap(aSizeV[49],aSizeH[4],"lgrl01.bmp",aSizeH[16],aSizeH[5])
	//Imprime cabe็alho
	oPrint:Say(aSizeV[51],aSizeH[55],"MINUTA DE DESPACHO " ,oFont14n)
	oPrint:Say(aSizeV[52],aSizeH[7],"MIDORI AUTO LEATHER BRASIL LTDA",oFont14n)
	oPrint:Say(aSizeV[53],aSizeH[55],"DATA DE EMBARQUE: "+DTOC(dDatabase),oFont14n)
	oPrint:Say(aSizeV[58],aSizeH[5],"CLIENTE: "+Posicione('SA1',1,xFilial('SA1')+cCliente,"A1_NOME"),oFont10n)
	oPrint:Say(aSizeV[59],aSizeH[5],"END: "+Posicione('SA1',1,xFilial('SA1')+cCliente,"A1_END"),oFont10n)
	

	oPrint:Say(aSizeV[61],aSizeH[5],"TRANSPORTADORA: "+Posicione('SA4',1,xFilial('SA4')+cTransp,"A4_NOME")+ ' FONE: '+ Posicione('SA4',1,xFilial('SA4')+TRBF2->F2_TRANSP,"A4_DDD")+'-'+Posicione('SA4',1,xFilial('SA4')+TRBF2->F2_TRANSP,"A4_TEL"),oFont10n)
	oPrint:Say(aSizeV[62],aSizeH[5],"PLACA: "+cPlaca, oFont10n)
	//LINHA DIVISORIA ONDE SERม CORTADO
	oPrint:Line(aSizeV[47],aSizeH[03],aSizeV[47],aSizeH[97])
	oPrint:Line(aSizeV[48],aSizeH[03],aSizeV[48],aSizeH[97])	

	oPrint:Say(aSizeV[47],aSizeH[1],"-->  "+Replicate ("-",280),oFont08n)

	//Imprime linha divis๓ria
	oPrint:Line(aSizeV[56],aSizeH[03],aSizeV[56],aSizeH[97])

	//Imprime cabecalho dos campos
	oPrint:Say(aSizeV[64],aSizeH[4],"NOTA/SERIE",oFont12n)
	oPrint:Say(aSizeV[64],aSizeH[32],"VALOR",oFont12n)	
	oPrint:Say(aSizeV[64],aSizeH[42],"PESO BRUTO",oFont12n)
	oPrint:Say(aSizeV[64],aSizeH[60],"PESO LIQ",oFont12n)
	oPrint:Say(aSizeV[64],aSizeH[73],"VOLUME",oFont12n)
	oPrint:Say(aSizeV[64],aSizeH[85],"ESPECIE",oFont12n)	

	//impressaod e cabecalho
	oPrint:Line(aSizeV[64],aSizeH[03],aSizeV[64],aSizeH[97])
	oPrint:Line(aSizeV[66],aSizeH[03],aSizeV[66],aSizeH[97])

	//Linhas de quadricular os totais...
	oPrint:Line(aSizeV[80],aSizeH[03],aSizeV[80],aSizeH[97])
	oPrint:Line(aSizeV[83],aSizeH[03],aSizeV[83],aSizeH[97])	

  //Cria as 2 linhas para assinatura 
  	oPrint:Line(aSizeV[87],aSizeH[15],aSizeV[87],aSizeH[35])
  	oPrint:Line(aSizeV[87],aSizeH[20],aSizeV[86],aSizeH[21])
	oPrint:Say(aSizeV[86],aSizeH[5],"Data:",oFont12n)	
 	oPrint:Line(aSizeV[87],aSizeH[25],aSizeV[86],aSizeH[26])  	
    oPrint:Line(aSizeV[92],aSizeH[15],aSizeV[92],aSizeH[35])
   	oPrint:Say(aSizeV[92],aSizeH[20],"NOME LEGIVEL",oFont12n)	
    
	//Monta as linhas verticais para separa็ใo dos valores
	oPrint:Line(aSizeV[64],aSizeH[21],aSizeV[83],aSizeH[21]) //CLIENTE
	oPrint:Line(aSizeV[64],aSizeH[40],aSizeV[83],aSizeH[40]) //VALOR
	oPrint:Line(aSizeV[64],aSizeH[55],aSizeV[83],aSizeH[55]) //VOLUMES
	oPrint:Line(aSizeV[64],aSizeH[70],aSizeV[83],aSizeH[70]) //PESO
	oPrint:Line(aSizeV[64],aSizeH[82],aSizeV[83],aSizeH[82]) 

//Retorno da rotina
Return()