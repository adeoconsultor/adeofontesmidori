#INCLUDE "TOTVS.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMDPACKLI     บ Autor ณ ANTONIO C DAMACENO บ Data ณ 06/09/16 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de impressao do Packing List de Embarque         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ACD                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MDPACKLI()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Packing List de Embarque"
Local cPict        := ""
Local titulo       := "Packing List de Embarque"
Local nLin         := 80
Local cCabec1      := "NFiscal/S้rie   Data Emissใo  Cliente"
Local cCabec2      := ""
Local imprime      := .T.
Local aOrd         := {}
                 
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "MDPACKLI" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "CBLPAC"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "MDPACKLI" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "CBL"

dbSelectArea("CBL")
dbSetOrder(1)

AtuSx1Tela(cPerg)
pergunte(cPerg,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

CBK->( dbSetOrder(1) )
If CBK->( dbSeek( xFilial("CBK") + MV_PAR01 + MV_PAR02 ) )

	If CBK->CBK_STATUS <> '2'    //NAO EMBARCADO
		MsgAlert("Hแ itens a serem conferidos no embarque desta nota fiscal, Status de envio pendente, Packing List nใo serแ Emitido!!!")
		Return()
	EndIF	

Else
	MsgAlert("Nota fiscal sem embarque!!!")
	Return()
EndIf

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
//wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(cCabec1,cCabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  06/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(cCabec1,cCabec2,Titulo,nLin)

Local nOrdem
Local nTotQtd    := 0
Local cProduto   := ""
Local cSql       := ""
Local cAliasCBL  := GetNextAlias()
Local cAliasCB0  := GetNextAlias()
Local lProd      := .T.
Local nQtd       := 0
Local nTotQtdCB0 := 0
Local lRet       := .T.

cSql := "SELECT CBL_PROD, CBL_CODETI, CBL_QTDEMB, CBL_DOC,  CBL_SERIE, CBL_CLIENT, CBL_LOJA, CBL_XCARRI "
cSql += "  FROM " + RetSqlName("CBL") + " CBL "
cSql += " WHERE CBL.CBL_FILIAL = '" + xFilial("CBL") + "' "
cSql += "   AND CBL.CBL_DOC    = '" + MV_PAR01 + "' "
cSql += "   AND CBL.D_E_L_E_T_ = ' ' "
cSql += " ORDER BY CBL_PROD "
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasCBL,.T.,.T.)
dbGoTop()  
SetRegua(RecCount())
dbGoTop()
cProduto:=(cAliasCBL)->CBL_PROD

While (cAliasCBL)->(!EOF())
cCodPro:=MV_PAR01
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		lProd:=.T.
	Endif

	If (cAliasCBL)->CBL_PROD <> cProduto
		nTotQtd:=0
		cProduto:=(cAliasCBL)->CBL_PROD
		lProd:=.T.
	EndIf

	If lProd
		lProd:=.F.
	EndIf

	If MV_PAR03 == 1             // 1='Sim'

		cSql := "SELECT SUM (CB0_QTDE) QTDETQPAL"
		cSql += "  FROM " + RetSqlName("CB0") + " CB0 "
		cSql += " WHERE CB0.CB0_FILIAL = '"+xFilial("CB0")+"' "
		cSql += "   AND CB0.CB0_PALLET = '"+ (cAliasCBL)->CBL_CODETI +"' "
		cSql += "   AND CB0.D_E_L_E_T_ = ' ' "
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasCB0,.T.,.T.)

		If (cAliasCB0)->QTDETQPAL <> (cAliasCBL)->CBL_QTDEMB
			Set Printer to
			Set Device to Screen
			HS_MsgInf("Diverg๊ncia de Qtde no Item: " + (cAliasCBL)->CBL_PROD + "               Pallet: " + (cAliasCBL)->CBL_CODETI;
			+ " Qtde NF: " + Transform((cAliasCBL)->CBL_QTDEMB,"T@E 9999") + "     Qtde Lida: " + Transform((cAliasCB0)->QTDETQPAL,"T@E 9999"),"Aten็ใo",Titulo)
			lRet:=.F.
			Exit
		Endif

		(cAliasCB0)->(dbCloseArea())

 	EndIf	

    nTotQtd := nTotQtd + (cAliasCBL)->CBL_QTDEMB

    nQtd:=(cAliasCBL)->CBL_QTDEMB
	(cAliasCBL)->(dbSkip())

EndDo


If lRet
	 nTotQtd    := 0
	 nQtd       := 0
	 nTotQtdCB0 := 0
	
	(cAliasCBL)->(dbGoTop())  
	(cAliasCBL)->(SetRegua(RecCount()))
	cProduto:=(cAliasCBL)->CBL_PROD
	
	While (cAliasCBL)->(!EOF())
	
	   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	   //ณ Verifica o cancelamento pelo usuario...                             ณ
	   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	   If lAbortPrint
	      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	      Exit
	   Endif
	
	   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	   //ณ Impressao do cabecalho do relatorio. . .                            ณ
	   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,cCabec1,"",nomeprog,Tamanho,nTipo)
	      
	//		Li := CABEC(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
	
	      nLin := 8
	//                                 10        20        30        40        50        60        70        80   
	//                       01234567890123456789012345678901234567890123456789012345678901234567890123456789
	//Local Cabec1       := "NFiscal/S้rie   Data Emissใo  Cliente"
	//Local Cabec2       := ""
	
			@nLin,00 PSAY (cAliasCBL)->CBL_DOC+" "+(cAliasCBL)->CBL_SERIE
			@nLin,16 PSAY Posicione("CBK",1,xFilial("CBK")+(cAliasCBL)->CBL_DOC+(cAliasCBL)->CBL_SERIE+(cAliasCBL)->CBL_CLIENT+(cAliasCBL)->CBL_LOJA, "CBK_EMISSA" )
			@nLin,30 PSAY (cAliasCBL)->CBL_CLIENT+" "+(cAliasCBL)->CBL_LOJA
			@nLin,40 PSAY Posicione("SA1",1,xFilial("SA1")+(cAliasCBL)->CBL_CLIENT+(cAliasCBL)->CBL_LOJA, "A1_NOME" )
				
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,00 PSAY Replicate("_",80)
			nLin := nLin + 1 // Avanca a linha de impressao
	
	//                               10        20        30        40        50        60        70        80   
	//                     01234567890123456789012345678901234567890123456789012345678901234567890123456789
			If (cAliasCBL)->CBL_XCARRI == 'S'
				@nLin,00 PSAY "PRODUTO DESCRIวรO                                                EQT KIT    QTDE"
			Else
				@nLin,00 PSAY "PRODUTO DESCRIวรO                                                EQT PALETE QTDE"
			EndIf                                                     
	
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,00 PSAY Replicate("_",80)
			nLin := nLin + 1 // Avanca a linha de impressao
			lProd:=.T.
	   Endif
	
		If (cAliasCBL)->CBL_PROD <> cProduto
	
			If nQtd <> nTotQtd
				@nLin,65 PSAY Replicate("_",15)
				nLin := nLin + 1 // Avanca a linha de impressao
				@nLin,65 PSAY "TOTAL"
				@nLin,76 PSAY Transform(nTotQtd,"@E 9999")
				nLin := nLin + 1 // Avanca a linha de impressao
				@nLin,00 PSAY Replicate("_",80)
				nLin := nLin + 1 // Avanca a linha de impressao
			Else
				@nLin,00 PSAY Replicate("_",80)
				nLin := nLin + 1 // Avanca a linha de impressao
			EndIf
	
			nTotQtd:=0
			cProduto:=(cAliasCBL)->CBL_PROD
			lProd:=.T.
		EndIf
	
	
		@nLin,00 PSAY ""
		If lProd
			@nLin,00 PSAY SubSTR((cAliasCBL)->CBL_PROD,1,6)
			@nLin,10 PSAY SubSTR(Posicione("SB1",1,xFilial("SB1")+(cAliasCBL)->CBL_PROD, "B1_DESC"),1,53)
			lProd:=.F.
		EndIf
		@nLin,65 PSAY (cAliasCBL)->CBL_CODETI
		@nLin,76 PSAY Transform((cAliasCBL)->CBL_QTDEMB,"@E 9999")
	
	    nTotQtd := nTotQtd + (cAliasCBL)->CBL_QTDEMB
	
		nLin := nLin + 1 // Avanca a linha de impressao
	    nQtd:=(cAliasCBL)->CBL_QTDEMB
		(cAliasCBL)->(dbSkip())
	EndDo
	
	If nQtd <> nTotQtd
		@nLin,65 PSAY Replicate("_",15)
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,65 PSAY "TOTAL"
		@nLin,76 PSAY Transform(nTotQtd,"@E 9999")
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,00 PSAY Replicate("_",80)
		nLin := nLin + 1 // Avanca a linha de impressao
	Else
		@nLin,00 PSAY Replicate("_",80)
		nLin := nLin + 1 // Avanca a linha de impressao
	EndIf

EndIf

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

(cAliasCBL)->(dbCloseArea())

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuSX1telaบAutor  ณGeronimo B. Alves   บ Data ณ  22/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza perguntas utilizada na rotina de impressao de     บฑฑ
ฑฑบ          ณ orcamento em word (quando invocada atraves do browse)      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuSX1TELA(cPerg)

Local aArea 	:= GetArea()
Local nI		:= 0

PutSX1(cPerg, "01", "Informe a Nota Fiscal:" , ""	, ""	, "MV_CH1", "C",9		, 0, 1, "G", ""		, ""  , ""  ,"", "MV_PAR01"		, "", "", "", "", "", "", "", ""   , ""	  , "" , ""	, "", "" , "" , "", ""  )
PutSX1(cPerg, "02", "Informe a Serie:"		 , ""	, ""	, "MV_CH2", "C",3		, 0, 1, "G", ""		, ""  , ""  ,"", "MV_PAR02"		, "", "", "", "", "", "", "", ""   , ""	  , "" , ""	, "", "" , "" , "", ""  )
PutSX1(cPerg, "03", "Conferencia via CBO?"	 , ""	, ""	, "MV_CH3", "C",1		, 0, 1, "C", ""		, ""  , ""  ,"", "MV_PAR03"		, "", "", "", "", "", "", "", ""   , ""	  , "" , ""	, "", "" , "" , "", ""  )

RestArea(aArea)
Return

