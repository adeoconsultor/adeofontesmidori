#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Minuta     º Autor ³ Humberto Garcia   º Data ³  21/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Este programa tem a finalidade de imprimir a Minuta de     º±±
±±º          ³ despacho de mercadorias                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento - Midori Atlântica                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MinutaAtu()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Minuta de Despacho"
Local cPict          := ""
Local titulo         := "Minuta de Despacho"
Local nLin           := 80

Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Local cPerg          := "MINUTA"
Local cQuery		 := ""


Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "Minuta" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Fiscal", 1, 2, 2, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "Minuta" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "SF2"

dbSelectArea("SF2")
dbSetOrder(1)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  21/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

//dbSelectArea(cString)
//dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//dbGoTop()
//While !EOF()
  
cQuery := " SELECT F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_TRANSP,F2_VALBRUT,F2_PLIQUI,F2_PBRUTO,F2_ESPECI1,F2_TIPO,F2_VOLUME1
cQuery += " FROM " + RetSqlName("SF2") + "  F2 " 
cQuery += " WHERE F2_FILIAL = '"+ xFILIAL("SF2")+"'
cQuery += " AND F2_DOC BETWEEN '"+ALLTRIM(MV_PAR02)+"' AND '"+ALLTRIM(MV_PAR03)+"' 
cQuery += " AND F2_SERIE = '"+ALLTRIM(MV_PAR01)+"' 
cQuery += " AND D_E_L_E_T_ = ' '
cQuery += " ORDER BY F2_DOC, F2_CLIENTE, F2_LOJA"
                     
/*
cQuery := "SELECT F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_TRANSP,F2_VALBRUT,F2_PLIQUI,"
cQuery += "F2_PBRUTO,F2_ESPECI1,F2_TIPO,C5_VOLUME1"
cQuery += " FROM " + RetSqlName ("SF2") + " F2 " 
cQuery += " INNER JOIN " + RetSqlName ("SC5") + " C5 " 
cQuery += " ON F2_DOC = C5_NOTA "
cQuery += " AND F2_SERIE = C5_SERIE "
cQuery += " AND F2_CLIENTE = C5_CLIENTE "
cQuery += " AND F2_LOJA = C5_LOJACLI "
cQuery += " AND F2_TRANSP = C5_TRANSP "
cQuery += " WHERE F2.D_E_L_E_T_ = ' ' "                                           
cQuery += " AND F2_FILIAL ='"+ xFILIAL("SF2")+"'
cQuery += " AND F2_SERIE ='"+ALLTRIM(MV_PAR01)+"'
cQuery += " AND F2_DOC >='"+ALLTRIM(MV_PAR02)+"'
cQuery += " AND F2_DOC <='"+ALLTRIM(MV_PAR03)+"'
cQuery += " ORDER BY F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_TRANSP"
*/
/*
cQuery := "SELECT F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_TRANSP,F2_VALBRUT,F2_PLIQUI,F2_PBRUTO"
cQuery += " FROM " + RetSqlName("SF2")
cQuery += " WHERE D_E_L_E_T_ = ' '"
cQuery += " AND F2_SERIE ='"+ALLTRIM(MV_PAR01)+"'
cQuery += " AND F2_DOC >='"+ALLTRIM(MV_PAR02)+"'
cQuery += " AND F2_DOC <='"+ALLTRIM(MV_PAR03)+"'
cQuery += "ORDER BY F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_TRANSP"
*/
TcQuery cQuery New Alias "TRB"

DbSelectArea("TRB")
TRB->(DbGotop())
While TRB->(!EOF())
	
	cCliente := ""
	cLoja    := ""
	cTransp  := ""
	nLin     := 80
	
	nPliquiTot:= 0
	nPbrutoTot:= 0
	nValTot   := 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	// Executo enquanto as notas estiverem entre o "range" informado
	
	cCliente := TRB->F2_CLIENTE
	cLoja    := TRB->F2_LOJA
	cTransp  := TRB->F2_TRANSP                            
	
	IF TRB->F2_TIPO $ 'BD'
    
    	@nLin, 00 PSAY "Fornecedor: "  + Posicione("SA2",1,xFilial("SA2")+cCliente+cLoja,"A2_NOME")
	    nLin++
	    @nLin, 00 PSAY "Endereço: " + Posicione("SA2",1,xFilial("SA2")+cCliente+cLoja,"A2_END")
	    nLin++
	    @nLin, 00 PSAY "Bairro: "  + Posicione("SA2",1,xFilial("SA2")+cCliente+cLoja,"A2_BAIRRO")
	    @nLin, 35 PSAY "Cidade: "  + Posicione("SA2",1,xFilial("SA2")+cCliente+cLoja,"A2_MUN") 
	    nLin:= nLin+2
	
	ELSE
	
	    @nLin, 00 PSAY "Cliente: "  + Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NOME")
	    nLin++
	    @nLin, 00 PSAY "Endereço: " + Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_END")
	    nLin++
	    @nLin, 00 PSAY "Bairro: "  + Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_BAIRRO")
	    @nLin, 35 PSAY "Cidade: "  + Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_MUN") 
	    nLin:= nLin+2
	
	ENDIF    
	    
	@nLin, 00 PSAY "Transportadora: " + Posicione("SA4",1,xFilial("SA4")+cTransp,"A4_NOME")
	nLin++
	@nLin, 00 PSAY "Endereço: " + Posicione("SA4",1,xFilial("SA4")+cTransp,"A4_END")
	nLin :=nLin+5
	@nLin,00 PSAY Replicate ("-",80)
	nLin++
	//             12345678901234567890123456789012345678901234567890123456789012345678901234567890
	@nLin,00 PSAY "NOTA FISCAL  SERIE   VALOR     PESO BRUTO    PESO LIQUIDO    VOLUMES     ESPECIE" 
	nLin++
	@nLin,00 PSAY Replicate ("-",80)
	nLin :=nLin+2
	
	While TRB->F2_CLIENTE == cCliente .and. TRB->F2_LOJA == cLoja .and. TRB->F2_TRANSP == cTransp
		
		@nLin,00 PSAY TRB->F2_DOC
		@nLin,14 PSAY TRB->F2_SERIE
		@nLin,20 PSAY Alltrim(Transform(TRB->F2_VALBRUT,"@E 999,999,999,999,999.99"))
		@nLin,31 PSAY Transform(TRB->F2_PBRUTO,"@E 999,999.99")
		@nLin,44 PSAY Transform(TRB->F2_PLIQUI,"@E 999,999.99")
		@nLin,63 PSAY TRB->F2_VOLUME1
		@nLin,72 PSAY TRB->F2_ESPECI1
		nLin++
		
		// Nesse espaço deve ser implementado um totalizador
		
		nPliquiTot:= nPliquiTot + TRB->F2_PLIQUI
		nPbrutoTot:= nPbrutoTot + TRB->F2_PBRUTO
		nValTot   := nValTot    + TRB->F2_VALBRUT
		
		dbSkip() // Avanca o ponteiro do registro no arquivo
	EndDO                                                       
	nLin:= 50
	@nLin,00 PSAY "Total Peso Bruto: " + Alltrim(Transform(nPbrutoTot,"@E 999,999.99"))    //Alltrim(cValtoChar(nValTot)) 
   //	nLin++
	@nLin,35 PSAY "Total Peso Liquido: " + Alltrim(Transform(nPliquiTot,"@E 999,999.99"))
	nLin++
	@nLin,00 PSAY "Valor Total: " + Alltrim(Transform(nValTot,"@E 999,999,999,999,999.99"))
	nLin := nLin+3
	@nLin,00 PSAY "Data:____/____/____"
	@nLin,55 PSAY Replicate("-",20)
	nLin++
	@nLin,55 PSAY "CARIMBO E ASSINATURA"
	
	//TRB->(DbSkip())
	
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

TRB->(dbCloseArea())

Return
