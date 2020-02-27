#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Padrao Zebra
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³img12     ºAutor  ³Sandro Valex        º Data ³  12/02/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada referente a imagem de identificacao do     º±±
±±º          ³produto. Padrao Microsiga  (Pallet PNP1)                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img12 //Identificacao de produto

Local cCodigo,sConteudo,cTipoBar, nX
Local nQtde 	:= If(len(paramixb) >= 1,paramixb[ 1],NIL)
Local cCodSep 	:= If(len(paramixb) >= 2,paramixb[ 2],NIL)     //usuario
Local cCodID 	:= If(len(paramixb) >= 3,paramixb[ 3],NIL)                                                   
Local nCopias	:= If(len(paramixb) >= 4,paramixb[ 4],0)
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
Local cProVolu  := "" 
Local cItNFE    := If(len(paramixb) >=23,paramixb[23],NIL)
Local cPallet   := If(len(paramixb) >=24,paramixb[24],"")            
Local cCodPro   := If(len(paramixb) >=25,paramixb[25],"")  

Local cLoteFor  := If(len(paramixb) >=26,paramixb[26],"")  
Local dRValid   := If(len(paramixb) >=27,paramixb[27],"")  
            
Local cSpool    := ""
Local lEscEti   := .f.
Local nLoop

Local dDataAvul := dDataBase
//Local cCodPro   := SB1->B1_COD

Private lRVolumes:=.F.

// Se o produto não está na SBZ, não tem que imprimir a etiqueta
dbSelectArea("SBZ")
dbSetOrder(1)
If ! dbSeek( xFilial("SBZ") + cCodPro )
	Return(nil)
EndIf

If GetMv("MV_INTACD") <> "1"
	Return( nil )
EndIf
                                      
// ETIQUETA NA ENTRADA DA NOTAS                                                   
                    
// verifica se o produto, apesar de ter que imprimir etiqueta, não deve imprimir para esta nota
If ! Valtype(cItNFE) == "C" .and. ! Empty(cItNFE)
	If SD1->( FieldPos("D1_ZZIMPET") ) > 0 .and. SD1->D1_ZZIMPET == "N"
		// If SB1->B1_ZZETVAR == "S"
		If SBZ->BZ_ZZETVAR == "S"
			Return( nil )
		EndIf
	EndIf
EndIf

lQEMB := SBZ->BZ_ZZQEACD > 0
_nQE  := SBZ->BZ_ZZQEACD

If lQEmb
 
	_nQtde   := Int(nQtde/_nQE)
	_nResto  :=MOD( nQtde, _nQE )                                             
	If _nResto >0
	   _nQtde++
	EndIf
	
	nQtde   := _nQE
	nCopias	:= _nQtde
	nResto  := _nResto

EndIf
                                                                             
cLocOri := If(cLocOri==cArmazem,' ',cLocOri)
nQtde   := If(nQtde==NIL,1,nQtde)
cCodSep := If(cCodSep==NIL,'',cCodSep)

// Utilizado para impressao etiquetas de Carrinho(diego molume)

If Posicione("SBZ",1,SBZ->BZ_FILIAL+AllTrim(SBZ->BZ_COD),"BZ_XETQVOL") == "S"
	cProVolu := "S"
Endif			
     
// Campo que informa se imprime ou não etiquetas para este produto
If Empty(SBZ->BZ_ZZIMPET) .or. SBZ->BZ_ZZIMPET == "N"
	Return(nil)
EndIf

If lEscEti
	Return( nil )
EndIf

// Ajusta a quantidade de cada volume, de acordo com os produtos
aVolumes := {}
If lEscEti
	Return( nil )
EndIf

// Quantidade por caixa                                       
nTotQtVl := 0

If ! Empty( SBZ->BZ_ZZQTCXA ) .and. ! IsTelNet() 
    
	// Utilizado para Impressao Etiqueta Volume		
	// Diego Mafisolli em 26/05/18
	If ProcName(2) == "ACDI10NF" .And. cProVolu == "S"
		nCopias := nQtde
		nQtde   := SBZ->BZ_ZZQTPRD
	EndIf

	//---------------------------------------------------
	// Calcula a quantidade necessária de
	// caixas para o produto. Cada caixa = 1 etiqueta
	//---------------------------------------------------
	nTotQtVl := nCopias
    
    If SBZ->BZ_ZZQTPRD < nCopias
		nConta    := nCopias / SBZ->BZ_ZZQTPRD
		nContaInt := int( nConta )
		nCaixas   := nContaInt * SBZ->BZ_ZZQTCXA
		If nConta > nContaInt
			nCaixas += SBZ->BZ_ZZQTCXA
		EndIf
	Else
		nCaixas := SBZ->BZ_ZZQTCXA
    EndIf
    
	//---------------------------------------------------
	// Calcula a quantidade do produto em cada caixa
	//---------------------------------------------------
	nQtdeCxa := int( nCopias / nCaixas ) // Qtde em cada uma das caixas
	nUltCxa  := nCopias - ( nQtdeCxa * nCaixas ) // Qtde na ultima caixa

	For nLoop := 1 to nCaixas
		if nLoop == nCaixas
			nQtdeCxa := nQtdeCxa + nUltCxa
		EndIf                  
		AAdd( aVolumes, nQtdeCxa ) 	
	Next 
	
	nCopias := Len( aVolumes )
		
EndIf

CONOUT("Entrou na rotina de impressao")
  
// Etiqueta padrão de recebimento ( GRANDE ) ou de apontúemento do PA via apontamento em lote, customizado
// pela MIDORI. 
If ( SBZ->BZ_ZZETIQ == "1" .OR. Empty( SBZ->BZ_ZZETIQ ) )
	cSpool := SuperGetMV("MV_ZZSPL01",.F.,"P1GRAN")
Elseif SBZ->BZ_ZZETIQ == "5"
	cSpool := SuperGetMV("MV_ZZSPL05",.F.,"P1QUIM")
EndIf

//cSpool := Upper( AllTrim( cSpool ) )                                   \

//              1        2              3               4             5        6              7               8               9             10           11                12
//MSCBPRINTER( "ZEBRA", "LPT1",/* [ nDensidade ]*/, /*[ nTamanho ]*/, .F., /*"1290"*/, /*"172.17.0.161"*/, /*[ cEnv ]*/, /*[ nMemoria ]*/, /*cSpool*/, /*[ lDrvWin ]*/, '\IMPTER'/*[ cPathSpool ]*/ )

MSCBPRINTER( "ZEBRA", "SPOOL",/* [ nDensidade ]*/, /*[ nTamanho ]*/, .F., /*"1290"*/, /*"172.17.0.161"*/, /*[ cEnv ]*/, /*[ nMemoria ]*/, cSpool, /*[ lDrvWin ]*/, /*[ cPathSpool ]*/ )


MSCBCHKSTATUS(.f.)
//CONOUT("Abriu a impressora")     

For nX := 1 to nCopias

	MSCBBEGIN(1,6)            

	If cCodID#NIL // USADO PARA REIMPRESSAO
		CBRetEti(cCodID)
		nqtde 	 := CB0->CB0_QTDE
		cCodSep  := CB0->CB0_USUARIO
		cNFEnt   := CB0->CB0_NFENT
		cSeriee  := CB0->CB0_SERIEE
		cFornec  := CB0->CB0_FORNEC
		cLojafo  := CB0->CB0_LOJAFO
		cArmazem := CB0->CB0_LOCAL
		cOP      := CB0->CB0_OP
		cNumSeq  := CB0->CB0_NUMSEQ
		cLote    := CB0->CB0_LOTE
		cSLote   := CB0->CB0_SLOTE
		cCC      := CB0->CB0_CC
		cLocOri  := CB0->CB0_LOCORI
		cOPReq	 := CB0->CB0_OPREQ
		cNumserie:= CB0->CB0_NUMSER		
		cOrigem  := CB0->CB0_ORIGEM
		cEndereco:= CB0->CB0_LOCALI
		cPedido  := CB0->CB0_PEDCOM
		dRValid  := CB0->CB0_DTRVLD
		
		If CB0->(FieldPos("CB0_ITNFE"))>0
			cItNFE := CB0->CB0_ITNFE
		EndIf
	EndIf

	If !nResto == Nil	
	   If nResto > 0 .and. nX==nCopias
	      nQtde  := nResto
	   EndIf        
	Endif
                                   //            1      2      3      4       5       6      7     8     9       10    11    12    13  14  15   16     17    18    19   20     21   22     23         24      25
	cCodigo := If(cCodID ==NIL,CBGrvEti('01',{cCodPro,nQtde,cCodSep,cNFEnt,cSeriee,cFornec,cLojafo,,cEndereco,cArmazem,cOp,cNumSeq,NIL,NIL,NIL,cLote,cSLote,dValid,cCC,cLocOri,NIL,cOPReq,cNumserie,cOrigem,cItNFE}),cCodID)

	cCodigo := Alltrim(cCodigo)

	RecLock("CB0",.F.)
	CB0->CB0_PALSZO := cPallet
	CB0->CB0_LOTEFO := cLoteFor
	CB0->CB0_DTRVLD := dRValid
	MsUnlock() 

	cTipoBar := 'MB07' //128
/*	If ! Usacb0("01")
		If Len(cCodigo) == 8
			cTipoBar := 'MB03'
		ElseIf Len(cCodigo) == 13
			cTipoBar := 'MB04'
		EndIf
	EndIf
 */     
	// Etiqueta padrão de recebimento ( GRANDE ) , customizado pela MIDORI.

	If ( (SBZ->BZ_ZZETIQ == "1" .or. SBZ->BZ_ZZETIQ == "4" .or. SBZ->BZ_ZZETIQ == "5") .OR. Empty( SBZ->BZ_ZZETIQ ) )
			
		MscbWrite("CT~~CD,~CC^~CT~")
		MscbWrite("^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ")
		MscbWrite("^XA")
		MscbWrite("^MMT")
		MscbWrite("^PW815")
		MscbWrite("^LL1215")
		MscbWrite("^LS0")
		MscbWrite("^BY6,3,118^FT221,904^BCB,,Y,N")
		MscbWrite("^FD>;"+cCodigo+"^FS")
		MscbWrite("^FT778,903^A0B,62,62^FH\^FDPALETE Nr. "+cPallet+"^FS")
		MscbWrite("^FO317,29^GB0,1156,8^FS")
		MscbWrite("^FO87,30^GB0,1156,7^FS")
		MscbWrite("^FO527,23^GB154,560,8^FS")
		MscbWrite("^FO528,575^GB153,612,8^FS")
		MscbWrite("^FT74,1182^A0B,34,33^FH\^FDEtiqueta de Volume - Palete^FS")
		MscbWrite("^FT74,383^A0B,34,33^FH\^FDMidori Auto Leather Brasil^FS")
		MscbWrite("^FT434,1181^A0B,39,38^FH\^FDDescricao: "+SubStr(SB1->B1_DESC,01,50)+"^FS")
		MscbWrite("^FT374,393^A0B,39,38^FH\^FDNF/Serie: " + cNFEnt + cSeriee + "^FS")
		MscbWrite("^FT373,1181^A0B,39,38^FH\^FDCodigo do Produto: "+SB1->B1_COD+"^FS")

		MscbWrite("^FT440,302^A0B,39,38^FH\^FDData: "+DtoC(dDataBase)+"^FS")
		MscbWrite("^FT569,1000^A0B,28,28^FH\^FDUnidade de Medida^FS")
		MscbWrite("^FT68,618^A0B,28,28^FH\^FDPNP1^FS")
		MscbWrite("^FT568,370^A0B,28,28^FH\^FDQuantidade^FS")
		MscbWrite("^FT634,508^A0B,52,57^FH\^FD"+Transform(nQtde,"@E 999,999.9999")+"^FS")
		MscbWrite("^FT634,920^A0B,52,57^FH\^FD"+SB1->B1_UM+"^FS")

		If Empty(cLoteFor)
			If ValType( cLote ) == "C" .and. ! Empty( cLote )
				MscbWrite("^FT497,1179^A0B,39,38^FH\^FDLote: " + cLote + "^FS")
				MscbWrite("^FT499,865^A0B,39,38^FH\^FDValidade: "+DtoC(dValid)+"^FS")
	    	EndIf
		Else
			MscbWrite("^FT497,1179^A0B,39,38^FH\^FDLote: " + cLoteFor + "^FS")
			MscbWrite("^FT499,865^A0B,39,38^FH\^FDValidade: "+DtoC(dValid)+"^FS")
		EndIf

		If !Empty(dRValid)
			MscbWrite("^FT499,477^A0B,39,38^FH\^FDRevalidado P/: "+DtoC(dRValid)+"^FS")
		EndIf

		MscbWrite("^LRY^FO727,20^GB0,1175,61^FS^LRN")
		MscbWrite("^PQ1,0,1,Y^XZ")

	EndIf

	sConteudo:=MSCBEND() 
	
Next

MSCBCLOSEPRINTER()                                              

ConOut("Encerrou a rotina de impressao")

Return sConteudo
