#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RelEntr   º Autor ³ Anesio - Taggs     º Data ³  22/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RelEntr()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatório de Entradas de Produtos por Fornecedor"
Local cPict          := ""
Local titulo       := "Relatório de Entradas de Produtos por Fornecedor"
Local nLin         := 80

//Local Cabec1       := "0123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789"
//Local Cabec2       := "     1         2         3         4         5         6         7         8         9         10        11        12        13        14"
Local Cabec1       := "CODIGO   DESCRICAO                                                              QTDE          DEVOL          SALDO    VALOR SALDO  VALOR UNIT"
Local Cabec2       := ""

Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "G"
Private nomeprog         := "NOME" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "RELENTR"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RELENTRADAS" // Coloque aqui o nome do arquivo usado para impressao em disco


//pergunte(cPerg,.F.)

AjustaSx1()
If ! Pergunte(cPerg,.T.)
	Return
Endif

cString := ""
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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  22/09/10   º±±
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

Local cQuery   := "",cIndex := CriaTrab("",.F.),nIndex:=0
Local cAliasQry    := GetNextAlias()
Local nOrdem
Local cFornAnt := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                                                                           
cQuery := "SELECT D1_COD, D1_GRUPO, B1_DESC, B1_UM, D1_FILIAL, D1_LOCAL, D1_FORNECE, D1_LOJA, "
cQuery += "Sum(D1_QUANT) SAIDAS, Sum(D1_QTDEDEV) DEVOL, Sum(D1_VUNIT*(D1_QUANT-D1_QTDEDEV)) VALOR "
cQuery += "FROM " + RetSQLName( "SD1" ) + " SD1, " + RetSQLName( "SB1" ) + " SB1, " + RetSQLName( "SF4" ) + " SF4 " 
cQuery += "WHERE "
cQuery += "SD1.D1_FILIAL = '"+xFilial("SD1") + "' AND SB1.B1_FILIAL = '" +xFilial("SB1") + "' AND SF4.F4_FILIAL = '"+xFilial("SF4") + "'"
cQuery += "AND SD1.D_E_L_E_T_ <> '*' AND  SB1.D_E_L_E_T_ <> '*' AND SF4.D_E_L_E_T_ <> '*' "             
cQuery += "AND D1_COD = B1_COD AND D1_TES = F4_CODIGO " // AND D1_FILIAL = F4_FILIAL " - Comentado por ter unificado as TES
cQuery += "AND F4_ESTOQUE = 'S' AND "
cQuery += "SD1.D1_LOCAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND "
cQuery += "SD1.D1_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND "
cQuery += "SD1.D1_COD BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND "        
cQuery += "SD1.D1_FORNECE BETWEEN '"+MV_PAR07 +"' AND '"+ MV_PAR08 + "' AND "
cQuery += "SD1.D1_LOJA BETWEEN '"+MV_PAR09 +"' AND '"+MV_PAR10 +"' AND "
cQuery += "SD1.D1_DTDIGIT BETWEEN '"+dTos(MV_PAR11)+ "' AND '"+dTos(MV_PAR12)+"' " 
cQuery += "GROUP BY D1_COD, D1_GRUPO, B1_DESC, B1_UM, D1_FILIAL, D1_LOCAL, D1_FORNECE, D1_LOJA "
cQuery += "ORDER BY D1_FORNECE, D1_LOJA, B1_DESC "

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)

//TcSetField(cAliasQry, "EMISSAO", "D")

SetRegua(RecCount())

                                                                    
dbSelectArea(cAliasQry)
dbGoTop()           
cFornAnt:= (cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA
@nLin,001 Psay "FORNECEDOR: "+(cAliasQry)->D1_FORNECE +"-"+(cAliasQry)->D1_LOJA+"   "+Posicione("SA2",1,xFilial("SA2")+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA,"A2_NOME")
nLin++

While !EOF()

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
	if cFornAnt <> (cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA
		nLin++
		nLin++
		cFornAnt:= (cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA
		@nLin,001 Psay "FORNECEDOR: "+(cAliasQry)->D1_FORNECE +"-"+(cAliasQry)->D1_LOJA+"   "+Posicione("SA2",1,xFilial("SA2")+(cAliasQry)->D1_FORNECE+(cAliasQry)->D1_LOJA,"A2_NOME")
		nLin++
	endif
    @nLin,001 Psay Substr((cAliasQry)->D1_COD,1,6) + " - "+(cAliasQry)->B1_DESC
    @nLin,070 Psay (cAliasQry)->SAIDAS Picture "@E 999,999,999.99"
    @nLin,085 Psay (cAliasQry)->DEVOL Picture "@E 999,999,999.99"
    @nLin,100 Psay (cAliasQry)->SAIDAS-(cAliasQry)->DEVOL Picture "@E 999,999,999.99"            
    @nLin,115 PSay (cAliasQry)->VALOR Picture "@E 999,999,999.99" 
    @nLin,130 PSay (cAliasQry)->VALOR / (cAliasQry)->SAIDAS Picture "@E 999,999.9999" 

   nLin := nLin + 1 // Avanca a linha de impressao

   dbSkip() // Avanca o ponteiro do registro no arquivo
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

Return


Static Function AjustaSX1()

Local aArea := GetArea()
PutSx1(cPerg,"01","Armazem de                    ?"," "," ","mv_ch1","C",2,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o armazem inicial"},{"Informe o armazem inicial"},{"Informe o armazem inicial"})
PutSx1(cPerg,"02","Armazem ate                   ?"," "," ","mv_ch2","C",2,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o armazem final"},{"Informe o armazem final"},{"Informe o armazem final"})
PutSx1(cPerg,"03","Grupo de                      ?"," "," ","mv_ch3","C",6,0,0,	"G","","SBM","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o grupo inicial"},{"Informe o grupo inicial"},{"Informe o grupo inicial"})
PutSx1(cPerg,"04","Grupo ate                     ?"," "," ","mv_ch4","C",6,0,0,	"G","","SBM","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o grupo final"},{"Informe o grupo final"},{"Informe o grupo final"})
PutSx1(cPerg,"05","Produto de                    ?"," "," ","mv_ch5","C",15,0,0,"G","","SB1","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto inicial"},{"Informe o produto inicial"},{"Informe o produto inicial"})
PutSx1(cPerg,"06","Produto ate                   ?"," "," ","mv_ch6","C",15,0,0,"G","","SB1","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto final"},{"Informe o produto final"},{"Informe o produto final"})
PutSx1(cPerg,"07","Fornecedor de                 ?"," "," ","mv_ch7","C",6,0,0,	"G","","SA2","","","mv_par07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o fornecedor inicial"},{"Informe o fornecedor inicial"},{"Informe o fornecedor inicial"})
PutSx1(cPerg,"08","Fornecedor ate                ?"," "," ","mv_ch8","C",6,0,0,	"G","","SA2","","","mv_par08"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o fornecedor final"},{"Informe o fornecedor final"},{"Informe o fornecedor final"})
PutSx1(cPerg,"09","Loja de                       ?"," "," ","mv_ch9","C",2,0,0,	"G","","   ","","","mv_par09"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a loja inicial"},{"Informe a loja inicial"},{"Informe a loja inicial"})
PutSx1(cPerg,"10","Loja ate                      ?"," "," ","mv_chA","C",2,0,0,	"G","","   ","","","mv_par10"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a loja final"},{"Informe a loja final"},{"Informe a loja final"})
PutSx1(cPerg,"11","Emissao de                    ?"," "," ","mv_chB","D",8,0,0,	"G","","   ","","","mv_par11"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o periodo inicial"},{"Informe o periodo inicial"},{"Informe o periodo inicial"})
PutSx1(cPerg,"12","Emissao ate                   ?"," "," ","mv_chC","D",8,0,0,	"G","","   ","","","mv_par12"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o periodo final"},{"Informe o periodo final"},{"Informe o periodo final"})
RestArea(aArea)
Return