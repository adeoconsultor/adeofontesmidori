/*
Padrao Zebra
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMG11     ºAutor  ³Antonio               º Data ³  29/05/18 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada referente a imagem de identificacao do    º±±
±±º          ³ Carrinho                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP6                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IMG11  // imagem do Carrinho  

Local cSpool                                                 
Local nqtde 	:= If(len(paramixb) >= 1,paramixb[ 1],NIL)
Local cCodSep 	:= If(len(paramixb) >= 2,paramixb[ 2],NIL)
Local cCodID 	:= If(len(paramixb) >= 3,paramixb[ 3],NIL)                                                   
Local nCopias	:= If(len(paramixb) >= 4,paramixb[ 4],1)
Local cNFEnt  	:= If(len(paramixb) >= 5,paramixb[ 5],NIL)
Local cSeriee   := If(len(paramixb) >= 6,paramixb[ 6],NIL)
Local cFornec   := If(len(paramixb) >= 7,paramixb[ 7],NIL)
Local cLojafo   := If(len(paramixb) >= 8,paramixb[ 8],NIL)
Local cArmazem  := If(len(paramixb) >= 9,paramixb[ 9],NIL)
Local cOP       := If(len(paramixb) >=10,paramixb[10],NIL)
Local cNumSeq   := If(len(paramixb) >=11,paramixb[11],NIL)
Local cLote     := If(len(paramixb) >=12,paramixb[12],NIL)
Local cSLote    := If(len(paramixb) >=13,paramixb[13],NIL)
Local dValid    := If(len(paramixb) >=14,paramixb[14],NIL)
Local cCC  		:= If(len(paramixb) >=15,paramixb[15],NIL)
Local cLocOri   := If(len(paramixb) >=16,paramixb[16],NIL)
Local cOPREQ    := If(len(paramixb) >=17,paramixb[17],NIL)
Local cNumSerie := If(len(paramixb) >=18,paramixb[18],NIL)
Local cOrigem   := If(len(paramixb) >=19,paramixb[19],NIL)
Local cEndereco := If(len(paramixb) >=20,paramixb[20],NIL)
Local cPedido   := If(len(paramixb) >=21,paramixb[21],NIL)
Local nResto    := If(len(paramixb) >=22,paramixb[22],0)
Local cItNFE    := If(len(paramixb) >=23,paramixb[23],NIL)
Local cPlano    := If(len(paramixb) >=24,paramixb[24],NIL)                                                                                              
Local cX6_CONTEUD := "" 
Local nI

If cFilAnt = "08"  
//	cSpool := AllTrim( SuperGetMV("MV_ZZSPL04",.f.,"LECTRA") )  // impressao sera feita na lectra
	cSpool := AllTrim( SuperGetMV("MV_ZZSPL01",.f.,"P2GRAN") )
Endif
	
If cFilAnt = "19"       
	cSpool := AllTrim( SuperGetMV("MV_ZZSPL01",.f.,"P2GRAN") )  
Endif

If ProcName(2)=='U_ETQACD' .OR. ProcName(2)=='ETQACD'
	cProduto   := SB1->B1_COD 
	cMdrEtPlan := cPlano
Else
	cProduto   := SZP->ZP_PRODUTO
	cMdrEtPlan := SZP->ZP_OPMIDO
EndIf

For nI := 1 to nCopias

	If Usacb0("01") 
		                                      //  1           2     3      4      5        6      7        8        9       10     11   12     13  14  15   16     17    18    19   20     21   22     23         24      25
		cCodigo := If(cCodID ==NIL,CBGrvEti('01',{cProduto,nQtde,cCodSep,cNFEnt,cSeriee,cFornec,cLojafo,cPedido,cEndereco,cArmazem,cOp,cNumSeq,NIL,NIL,NIL,cLote,cSLote,dValid,cCC,cLocOri,NIL,cOPReq,cNumserie,cOrigem,cItNFE}),cCodID)

		If !Empty(cPlano)
			RecLock("CB0",.F.)
			CB0->CB0_LOTEFO := cPlano
			MsUnlock()
		EndIf

		If SX6->(dbSeek(xFilial("CB0")+'MV_NUMKIT' ))
			cX6_CONTEUD := SX6->X6_CONTEUD
		EndIf
	
		RecLock("CB0",.F.)
		CB0->CB0_XCARRI := 'S'
		CB0->CB0_XKIT   := cX6_CONTEUD
		MsUnlock() 

		cSpool := Upper( AllTrim( cSpool ) )
		MSCBPRINTER( "ZEBRA", "SPOOL",/* [ nDensidade ]*/, /*[ nTamanho ]*/, .F., /*"1290"*/, /*"172.17.0.161"*/, /*[ cEnv ]*/, /*[ nMemoria ]*/, cSpool, /*[ lDrvWin ]*/, /*[ cPathSpool ]*/ )
		MSCBCHKSTATUS(.f.)
		MSCBBEGIN(1,6)            
		
		MscbWrite("CT~~CD,~CC^~CT~")
		MscbWrite("^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ")
		MscbWrite("^XA")
		MscbWrite("^MMT")
		MscbWrite("^PW815")
		MscbWrite("^LL1215")
		MscbWrite("^LS0")
		MscbWrite("^BY7,3,140^FT243,952^BCB,,Y,N")
		MscbWrite("^FD>;"+cCodigo+"^FS")
		MscbWrite("^FT775,783^A0B,45,129^FH\^FDCARRINHO^FS")
		MscbWrite("^FO317,29^GB0,1156,8^FS")
		MscbWrite("^FO87,30^GB0,1156,7^FS")
		MscbWrite("^FO527,23^GB154,560,8^FS")
		MscbWrite("^FO528,575^GB153,612,8^FS")
		MscbWrite("^FT74,1182^A0B,34,33^FH\^FDEtiqueta de Carrinho^FS")
		//ALTERAÇÃO DA FILIAL - 04/10
		MscbWrite("^FT74,514^A0B,34,33^FH\^FD"+IIf(AllTrim(SM0->M0_CODFIL)=='08','PNP2', IIf(AllTrim(SM0->M0_CODFIL)=='19','BRB','') )+"^FS")
		MscbWrite("^FT74,383^A0B,34,33^FH\^FDMidori Auto Leather Brasil^FS")
		MscbWrite("^FT362,1181^A0B,28,28^FH\^FDCodigo do KIT: "+cProduto+"^FS")
		MscbWrite("^FT412,1182^A0B,39,38^FH\^FD"+SubStr(POSICIONE('SB1',1,xFilial('SB1')+cProduto,'SB1->B1_DESC'),01,50)+"^FS")
		MscbWrite("^FT457,1182^A0B,39,38^FH\^FD"+SubStr(POSICIONE('SB1',1,xFilial('SB1')+cProduto,'SB1->B1_DESC'),51,50)+"^FS")
		MscbWrite("^FT523,228^A0B,28,28^FH\^FDData: "+DtoC(dDataBase)+"^FS")
		MscbWrite("^FT523,1186^A0B,28,28^FH\^FD"+if( !Empty(cMdrEtPlan), "Plano:"+cMdrEtPlan, " " )+"^FS")
		MscbWrite("^FT569,1000^A0B,28,28^FH\^FDUnidade de Medida^FS")
		MscbWrite("^FT569,371^A0B,28,28^FH\^FDQuantidade^FS")
		MscbWrite("^FT634,508^A0B,52,57^FH\^FD"+Transform(nQtde,"@E 999,999,999.9999")+"^FS")
		MscbWrite("^FT634,920^A0B,52,57^FH\^FD"+SB1->B1_UM+"^FS")
		//If lEntre
		//	MscbWrite("^FT511,1184^A0B,28,28^FH\^FD...ENTRE OUTROS PRODUTOS^FS")
		//EndIf
		MscbWrite("^LRY^FO727,20^GB0,1175,61^FS^LRN")
		MscbWrite("^PQ1,0,1,Y^XZ")
		MSCBEND()
		
		MSCBCLOSEPRINTER()       

	EndIf
	
Next

Return .T.
