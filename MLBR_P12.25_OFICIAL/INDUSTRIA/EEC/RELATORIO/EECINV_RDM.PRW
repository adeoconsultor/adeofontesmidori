#INCLUDE "EECPEM11.ch"
#INCLUDE "EECRDM.CH"
#DEFINE  NUMLINPAG 23
#DEFINE  TAMDESC 29

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: EECINV
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Data......: 01 de Março de 2010, 07:00
//|Uso.......: SIGAEEC
//|Versao....: Protheus - 10        `
//|Descricao.: Impressão da Invoice Midori
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function EECINV()
*-----------------------------------------*

Local lRet    := .t.
Local lIngles := "INGLES" $ Upper(WorkId->EEA_IDIOMA)
Local nAlias  := Select()
Local aOrd    := SaveOrd({"EE9","SA2","EE2","DETAIL_P"})
Local nCod, aFields, cFile
LOCAL aMESES := {"ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"}
Local nInc, cPackag, acRETPAC, nFobValue

Private cPict       := "999,999,999.99"
Private cPictDecPrc := Iif(EE7->EE7_DECPRC > 0, "."+Replic("9",EE7->EE7_DECPRC),"")
Private cPictDecPes := Iif(EE7->EE7_DECPES > 0, "."+Replic("9",EE7->EE7_DECPES),"")
Private cPictDecQtd := Iif(EE7->EE7_DECQTD > 0, "."+Replic("9",EE7->EE7_DECQTD),"")
Private cPictPreco  := "9,999"+cPictDecPrc
Private cPictPeso   := "9,999,999"+cPictDecPes
Private cPictQtde   := "9,999,999"+cPictDecQtd
Private cObs        := ""
Private aNotify[6]
Private cFileMen    :=""
Private cMarca      := GetMark(), lInverte := .f.
Private lNcm        := .F., lPesoBru := .T.
Private M->cSEEKEXF :=""
Private M->cSEEKLOJA:=""
Private cInvoice    := Space(15)
Private aHeader     := {}, aCAMPOS := ARRAY(0)
Private lUnidade    :=.F.,cUnQtde,cUnPeso,cUnPreco,nPesLiq:=0,nPesBru:=0
Private lPesoManual := GetMV("MV_AVG0004",,.F.)
aFill(aNotify,"")

Begin Sequence
	
	If EE8->(FieldPos("EE8_UNPES")) # 0 .And. EE8->(FieldPos("EE8_UNPRC")) # 0
		lUnidade :=.T.
		cUnQtde  :=CriaVar("EE8_UNPRC")
		cUnPeso  :=CriaVar("EE8_UNPES")
		cUnPreco :=CriaVar("EE8_UNPRC")
	EndIf
	
	// *** Cria Arquivo de Trabalho ...
	nCod := AVSX3("EEN_IMPORT",3)+AVSX3("EEN_IMLOJA",3)
	
	aFields := {{"WKMARCA" ,"C",02,0},;
				{"WKTIPO"  ,"C",01,0},;
				{"WKCODIGO","C",nCod,0},;
				{"WKDESCR" ,"C",AVSX3("EEN_IMPODE",3),0}}
	
	cFile := E_CriaTrab(,aFields,"Work")
	IndRegua("Work",cFile+OrdBagExt(),"WKTIPO+WKCODIGO")
	
	EEM->(dbSetOrder(1))
	EE2->(dbSetOrder(1))
	ZZE->(dbSetOrder(1))
	EE8->(dbSetOrder(1))
	EE8->(dbSeek(xFilial()+EE7->EE7_PEDIDO))
	
	// regras para carregar dados
	SA2->(dbSetOrder(1))
	IF !EMPTY(EE7->EE7_EXPORT) .AND. ;
		SA2->(DBSEEK(xFilial("SA2")+EE7->EE7_EXPORT+EE7->EE7_EXLOJA))
		cExp_Cod     := EE7->EE7_EXPORT+EE7->EE7_EXLOJA
		cEXP_NOME    := Posicione("SA2",1,xFilial("SA2")+EE7->EE7_EXPORT+EE7->EE7_EXLOJA,"A2_NOME")
		cEXP_CONTATO := EECCONTATO(CD_SA2,EE7->EE7_EXPORT,EE7->EE7_EXLOJA,"1",1)  //nome do contato seq 1
		cEXP_FONE    := EECCONTATO(CD_SA2,EE7->EE7_EXPORT,EE7->EE7_EXLOJA,"1",4)  //fone do contato seq 1
		cEXP_FAX     := EECCONTATO(CD_SA2,EE7->EE7_EXPORT,EE7->EE7_EXLOJA,"1",7)  //fax do contato seq 1
		cEXP_CARGO   := EECCONTATO(CD_SA2,EE7->EE7_EXPORT,EE7->EE7_EXLOJA,"1",2)  //CARGO
		M->cSEEKEXF  :=EE7->EE7_EXPORT
		M->cSEEKLOJA :=EE7->EE7_EXLOJA
	ELSE
		SA2->(DBSEEK(xFilial("SA2")+EE7->EE7_FORN+EE7->EE7_FOLOJA))
		cExp_Cod     := EE7->EE7_FORN+EE7->EE7_FOLOJA
		cEXP_NOME    := SA2->A2_NOME
		cEXP_CONTATO := EECCONTATO(CD_SA2,EE7->EE7_FORN,EE7->EE7_FOLOJA,"1",1,EE7->EE7_RESPON)  //nome do contato seq 1
		cEXP_FONE    := EECCONTATO(CD_SA2,EE7->EE7_FORN,EE7->EE7_FOLOJA,"1",4,EE7->EE7_RESPON)  //fone do contato seq 1
		cEXP_FAX     := EECCONTATO(CD_SA2,EE7->EE7_FORN,EE7->EE7_FOLOJA,"1",7,EE7->EE7_RESPON)  //fax do contato seq 1
		cEXP_CARGO   := EECCONTATO(CD_SA2,EE7->EE7_FORN,EE7->EE7_FOLOJA,"1",2,EE7->EE7_RESPON)  //CARGO
		M->cSEEKEXF  :=EE7->EE7_FORN
		M->cSEEKLOJA :=EE7->EE7_FOLOJA
	ENDIF
	
	cC2160 := EE7->EE7_IMPODE
	cC2260 := EE7->EE7_ENDIMP
	cC2360 := EE7->EE7_END2IM
	cC2460 := SPACE(60)
	cC2960 := SPACE(60)
	cC3060 := SPACE(60)
	
	// dar get do titulo e das mensagens ...
	IF !TelaGets()
		lRet := .f.
		Break
	Endif

	ZZE->(dbSeek(xFilial()+cInvoice))
	
	cSEQREL := GetSXENum("SY0","Y0_SEQREL")
	CONFIRMSX8()
	
	// adicionar registro no HEADER_P
	HEADER_P->(DBAPPEND())
	HEADER_P->AVG_FILIAL:=xFilial("SY0")
	HEADER_P->AVG_SEQREL:=cSEQREL
	HEADER_P->AVG_CHAVE := cInvoice //nr. do processo
	
	// Dados do Exportador/Fornecedor
	HEADER_P->AVG_C01_60:=ALLTRIM(cEXP_NOME) // TITULO 1
	HEADER_P->AVG_C02_60:=ALLTRIM(SA2->A2_END)
	HEADER_P->AVG_C03_60:=ALLTRIM(SA2->A2_EST+" "+AllTrim(BuscaPais(SA2->A2_PAIS))+" CEP: "+Transf(SA2->A2_CEP,AVSX3("A2_CEP",6)))
	HEADER_P->AVG_C04_60:=ALLTRIM(STR0001+AllTrim(cEXP_FONE)+STR0002+AllTrim(cEXP_FAX)) //"TEL.: "###" FAX: "
	
	HEADER_P->AVG_C19_20:=TRANSFORM(Posicione("SA2",1,xFILIAL("SA2")+EE7->EE7_FORN+EE7->EE7_FOLOJA,"A2_CGC"),AVSX3("A2_CGC",AV_PICTURE))
	
	// Informacoes do Cabecalho
	HEADER_P->AVG_C06_60 := AllTrim(SA2->A2_MUN)+", "+Upper(IF(lIngles,cMonth(ZZE->ZZE_DTINV),IF(EMPTY(ZZE->ZZE_DTINV),"",aMeses[Month(ZZE->ZZE_DTINV)])))+" "+StrZero(Day(ZZE->ZZE_DTINV),2)+", "+Str(Year(ZZE->ZZE_DTINV),4)+"."
	HEADER_P->AVG_C02_20 := cInvoice
	
	// TO
	HEADER_P->AVG_C07_60 := EE7->EE7_IMPODE
	HEADER_P->AVG_C08_60 := EE7->EE7_ENDIMP
	HEADER_P->AVG_C09_60 := EE7->EE7_END2IM
	
	// Consignee
	HEADER_P->AVG_C10_60 := Posicione("SA1",1,xFilial("SA1")+EE7->EE7_CONSIG+EE7->EE7_COLOJA,"A1_NOME")
	HEADER_P->AVG_C11_60 := EECMEND("SA1",1,EE7->EE7_CONSIG+EE7->EE7_COLOJA,.T.,58,1)
	HEADER_P->AVG_C12_60 := EECMEND("SA1",1,EE7->EE7_CONSIG+EE7->EE7_COLOJA,.T.,60,2)
	
	// Titulos ...
	HEADER_P->AVG_C01_10 := EE7->EE7_MOEDA
	
	If lUnidade
		IF !EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EE7->EE7_IDIOMA+cUnPeso))
			MsgStop(STR0003+cUnPeso+STR0004+EE7->EE7_IDIOMA,STR0005) //"Unidade de medida "###" nào cadastrada em "###"Aviso"
		EndIf
		HEADER_P->AVG_C02_10 := AllTrim(EE2->EE2_DESCMA)
	Else
		HEADER_P->AVG_C02_10 := "KG"
	EndIf
	
	If !lUnidade .Or. lPesoManual
		// Pesos/Cubagem
		HEADER_P->AVG_C03_20 := AllTrim(Transf(EE7->EE7_PESLIQ,cPictPeso))
		HEADER_P->AVG_C04_20 := AllTrim(Transf(EE7->EE7_PESBRU,cPictPeso))
	EndIf
	
	cPictCub := AllTrim(StrTran(Upper(AVSX3("EEC_CUBAGE",6)),"@E",""))
	HEADER_P->AVG_C05_20 := Transf(EE7->EE7_CUBAGE,cPictCub)  //AVSX3("EEC_CUBAGE",6))
	
	//Incoterm
	HEADER_P->AVG_C03_10 := EE7->EE7_INCOTE
	
	// pais de origem
	HEADER_P->AVG_C01_30 := Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM")
	
	// VIA
	SYQ->(dbSetOrder(1))
	SYQ->(dbSeek(xFilial()+EE7->EE7_VIA))
	
	HEADER_P->AVG_C02_30 := IF(Left(SYQ->YQ_COD_DI,1) == "4",IF(lIngles,"BY AIR","AEREA"),SYQ->YQ_DESCR) // VIA //CORRETO
	
	IF Left(SYQ->YQ_COD_DI,1) == "7" // Rodoviario
		HEADER_P->AVG_C14_60 := BuscaEmpresa(EE7->EE7_PEDIDO,OC_PE,CD_TRA)
	Else
		HEADER_P->AVG_C14_60 := "" //Posicione("EE6",1,xFilial("EE6")+EE7->EE7_EMBARC,"EE6_NOME")// Embarcacao
	Endif
	
	//CASE PARA HEADER_P->AVG_C03_30
	IF Left(SYQ->YQ_COD_DI,1) == "1" // MARITIMO
		HEADER_P->AVG_C05_10:="FOB"
	Else
		HEADER_P->AVG_C05_10:="FCA"
	Endif
	
	SYR->(dbSeek(xFilial()+EE7->EE7_VIA+EE7->EE7_ORIGEM+EE7->EE7_DEST+EE7->EE7_TIPTRA))
	
	IF Posicione("SYJ",1,xFilial("SYJ")+EE7->EE7_INCOTE,"YJ_CLFRETE") $ cSim
		HEADER_P->AVG_C13_20 := AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR")) // Porto de Destino
	Else
		HEADER_P->AVG_C13_20 := AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR"))  // Porto de Origem
	Endif
	
	// Port of Unloading
	HEADER_P->AVG_C04_30 := alltrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR"))
	
	// Port of Loading
	HEADER_P->AVG_C03_30 := alltrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR"))
	
	// MARKS
	cMemo := MSMM(EE7->EE7_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO))
	HEADER_P->AVG_C06_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),1)
	HEADER_P->AVG_C07_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),2)
	HEADER_P->AVG_C08_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),3)
	HEADER_P->AVG_C09_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),4)
	HEADER_P->AVG_C10_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),5)
	HEADER_P->AVG_C11_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),6)
	
	// NOTIFY
	HEADER_P->AVG_C15_60 := aNotify[1]
	HEADER_P->AVG_C16_60 := aNotify[2]
	HEADER_P->AVG_C17_60 := aNotify[3]
	HEADER_P->AVG_C18_60 := aNotify[4]
	HEADER_P->AVG_C19_60 := aNotify[5]
	HEADER_P->AVG_C20_60 := aNotify[6]
	
	//DOCUMENTS
	HEADER_P->AVG_C21_60 := cC2160
	HEADER_P->AVG_C22_60 := cC2260
	HEADER_P->AVG_C23_60 := cC2360
	HEADER_P->AVG_C24_60 := cC2460
	HEADER_P->AVG_C29_60 := cC2960
	HEADER_P->AVG_C30_60 := cC3060
	
	// Cond.Pagto ...
	HEADER_P->AVG_C01100 := SY6Descricao(EE7->EE7_CONDPA+Str(EE7->EE7_DIASPA,AVSX3("EEC_DIASPA",3),AVSX3("EEC_DIASPA",4)),EE7->EE7_IDIOMA,1)
	
	// I/L
	HEADER_P->AVG_C25_60 := EE7->EE7_LICIMP
	// L/C
	HEADER_P->AVG_C04_10 := EE7->EE7_LC_NUM
	
	// RODAPE
	HEADER_P->AVG_C26_60 := cEXP_NOME
	
	HEADER_P->AVG_C27_60 := cEXP_CONTATO
	HEADER_P->AVG_C28_60 := cEXP_CARGO
	HEADER_P->AVG_C01150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),1)
	HEADER_P->AVG_C02150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),2)
	HEADER_P->AVG_C03150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),3)
	HEADER_P->AVG_C04150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),4)
	HEADER_P->AVG_C05150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),5)
	
	GravaItens()
	
	If lUnidade .And. !lPesoManual
		HEADER_P->AVG_C03_20 := AllTrim(Transf(nPesLiq,cPictPeso))
		HEADER_P->AVG_C04_20 := AllTrim(Transf(nPesBru,cPictPeso))
	EndIf
	
	HEADER_P->(dbUnlock())
	
	HEADER_H->(dbAppend())
	AvReplace("HEADER_P","HEADER_H")
	
	DETAIL_P->(dbSetOrder(0))
	DETAIL_P->(DbGoTop())
	Do While ! DETAIL_P->(Eof())
		DETAIL_H->(DbAppend())
		AvReplace("DETAIL_P","DETAIL_H")
		DETAIL_P->(DbSkip())
	EndDo
	
	DETAIL_P->(dbSetOrder(1))
	
	// (Fim)
End Sequence


IF Select("Work_Men") > 0
	Work_Men->(E_EraseArq(cFileMen))
Endif

Work->(E_EraseArq(cFile))
RestOrd(aOrd)
Select(nAlias)

Return lRet


//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: GravaItens
//|Descricao.: Grava itens para impressão
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function GravaItens()
*-----------------------------------------*

Local nTotQtde := 0
Local nTotal   := 0
Local cUnidade := ""
Local bCond    := Iif(lNcm,{|| EE9->EE9_POSIPI == cNcm },{|| .t. })
Local cNcm     := "", lDescUnid := .F. , i := 0, gi_W := 0
Private nLin   := 0, nPag := 1

ZZF->(dbSetOrder(1))
EE8->(dbSetOrder(1))

ZZF->(dbSeek(xFilial("ZZF")+Alltrim(cInvoice)))

While ZZF->(!Eof() .And. ZZF_FILIAL == xFilial("ZZF")) .And. Alltrim(ZZF->ZZF_INVOICE) == Alltrim(cInvoice)
	
	EE8->(dbSeek(xFilial("EE8")+ZZF->ZZF_PEDIDO+ZZF->ZZF_SEQUEN))
	
	IF lNcm
		cNcm := EE8->EE8_POSIPI
		
		If lUnidade .And. !lDescUnid
			AppendDet()
			IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EE7->EE7_IDIOMA+cUnQtde))
				MsgStop(STR0003+cUnQtde+STR0004+EE7->EE7_IDIOMA,STR0005) //"Unidade de medida "###" nào cadastrada em "###"Aviso"
			EndIf
			
			DETAIL_P->AVG_C01_20 := AllTrim(EE2->EE2_DESCMA)
			
			IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EE7->EE7_IDIOMA+cUnPreco))
				MsgStop(STR0003+cUnPreco+STR0004+EE7->EE7_IDIOMA,STR0005) //"Unidade de medida "###" nào cadastrada em "###"Aviso"
			EndIf
			
			DETAIL_P->AVG_C01_60 := "CODIGO MAE"
			DETAIL_P->AVG_C06_20 := AllTrim(EE7->EE7_MOEDA)+"/"+EE2->EE2_DESCMA
			
			lDescUnid:=.t.
			
			UnlockDet()
			
		ElseIf !lUnidade
			IF cUnidade <> EE9->EE9_UNIDAD
				cUnidade := EE9->EE9_UNIDAD
				AppendDet()
				
				IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EE7->EE7_IDIOMA+EE9->EE9_UNIDAD))
					MsgStop(STR0003+EE8->EE8_UNIDAD+STR0004+EE7->EE7_IDIOMA,STR0005) //"Unidade de medida "###" nào cadastrada em "###"Aviso"
				Endif
				//DETAIL_P->AVG_C01_60 := "CODIGO MAE"
				DETAIL_P->AVG_C06_20 := AllTrim(EE7->EE7_MOEDA)+"/"+EE2->EE2_DESCMA
				
				UnlockDet()
			Endif
			
		EndIf
		
		AppendDet()
		DETAIL_P->AVG_C01_60 := Transf(EE8->EE8_POSIPI,AVSX3("EE8_POSIPI",6))
		UnlockDet()
		
		AppendDet()
		DETAIL_P->AVG_C01_60 := Replic("-",25)
		UnlockDet()
	Endif
	
	While ZZF->(!Eof() .And. ZZF_FILIAL == xFilial("ZZF")) .And. ZZF->ZZF_INVOIC == ZZE->ZZE_INVOIC .AND. Eval(bCond)
		
		EE8->(dbSeek(xFilial("EE8")+ZZF->ZZF_PEDIDO+ZZF->ZZF_SEQUEN))
		If lUnidade .And. !lDescUnid
			AppendDet()
			// ** Verifica se a unidade de medida para o qtde esta cadastrada no idioma ...
			IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EE7->EE7_IDIOMA+cUnQtde))
				MsgStop(STR0003+cUnQtde+STR0004+EE7->EE7_IDIOMA,STR0005) //"Unidade de medida "###" nào cadastrada em "###"Aviso"
			EndIf
			
			DETAIL_P->AVG_C01_20 := AllTrim(EE2->EE2_DESCMA)
			
			// ** Verifica se a unidade de medida para o preco esta cadastrada no idioma ...
			IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EE7->EE7_IDIOMA+cUnPreco))
				MsgStop(STR0003+cUnPreco+STR0004+EE7->EE7_IDIOMA,STR0005) //"Unidade de medida "###" nào cadastrada em "###"Aviso"
			EndIf
			
			//DETAIL_P->AVG_C01_60 := "CODIGO MAE"
			DETAIL_P->AVG_C06_20 := AllTrim(EE7->EE7_MOEDA)+"/"+EE2->EE2_DESCMA
			
			UnlockDet()
			
			lDescUnid:=.t.
			
		ElseIf !lUnidade
			
			IF cUnidade <> EE8->EE8_UNIDAD
				cUnidade := EE8->EE8_UNIDAD
				AppendDet()
				
				IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EE7->EE7_IDIOMA+EE8->EE8_UNIDAD))
					MsgStop(STR0003+EE8->EE8_UNIDAD+STR0004+EE7->EE7_IDIOMA,STR0005) //"Unidade de medida "###" nào cadastrada em "###"Aviso"
				Endif
				//DETAIL_P->AVG_C01_60 := "CODIGO MAE"
				DETAIL_P->AVG_C06_20 := AllTrim(EE7->EE7_MOEDA)+"/"+EE2->EE2_DESCMA
				
			EndIf
			
			UnlockDet()
		Endif
		
		AppendDet()
		
		If lUnidade
			DETAIL_P->AVG_C01_20 := ALLTRIM(Transf(AVTransUnid(EE8->EE8_UNIDAD,cUnQtde,EE8->EE8_COD_I,ZZF->ZZF_QUANT,.f.),cPictQtde))
		Else
			DETAIL_P->AVG_C01_20 := ALLTRIM(Transf(ZZF->ZZF_QUANT,cPictQtde))
		EndIf

		
		DETAIL_P->AVG_N02_15 := ZZF->ZZF_QUANT
		DETAIL_P->AVG_C02_20 := Transf(ZZF->ZZF_COD_I,AVSX3("ZZF_COD_I",6))
		DETAIL_P->AVG_C03_20 := Alltrim(EE8->EE8_REFCLI)
		DETAIL_P->AVG_C04_20 := Alltrim(EE8->EE8_PEDIDO)
		DETAIL_P->AVG_C05_20 := EE8->EE8_UNIDAD
		cMemo := MSMM(EE8->EE8_DESC,AVSX3("EE8_VM_DES",3))
		
		DETAIL_P->AVG_C01_60 := MemoLine(cMemo,TAMDESC,1)
		
		If lUnidade
			DETAIL_P->AVG_C06_20 := AllTrim(Transf(AVTransUnid(EE8->EE8_UNIDAD,cUnPreco,ZZF->ZZF_COD_I,ZZF->ZZF_PRECO,.f.),cPictPreco))
		Else
			DETAIL_P->AVG_C06_20 := AllTrim(Transf(ZZF->ZZF_PRECO,cPictPreco))
		Endif
		
		DETAIL_P->AVG_C07_20 := AllTrim(Transf(ZZF->ZZF_PRECOT,cPict))
		
		For i := 2 To MlCount(cMemo,TAMDESC,3)
			IF !EMPTY(MemoLine(cMemo,TAMDESC,i))
				UnLockDet()
				AppendDet()
				DETAIL_P->AVG_C01_60 := MemoLine(cMemo,TAMDESC,i)
			ENDIF
		Next
		
		// Totaliza os valores da quantidade e dos pesos liquido e bruto...
		If lUnidade
			nTotQtde := nTotQtde+AVTransUnid(EE8->EE8_UNIDAD,cUnQtde,ZZF->ZZF_COD_I,ZZF->ZZF_QUANT,.f.)
			nPesLiq  += AVTransUnid(EE8->EE8_UNIDAD,cUnPeso,ZZF->ZZF_COD_I,((EE8->EE8_PSLQTO/EE8->EE8_SLDINI)*ZZF->ZZF_QUANT),.f.)
			
			IF lPesoBru
				nPesBru +=AVTransUnid(EE8->EE8_UNIDAD,cUnPeso,ZZF->ZZF_COD_I,((EE8->EE8_PSBRTO/EE8->EE8_SLDINI)*ZZF->ZZF_QUANT),.f.)
			EndIf
			
		Else
			nTotQtde := nTotQtde+ZZF->ZZF_QUANT
		EndIf
			
		nTotal   := nTotal  + Round(ZZF->ZZF_PRECOT,2)
		
		UnLockDet()
		
		ZZF->(dbSkip())
	Enddo
Enddo

AppendDet()
DETAIL_P->AVG_C01_20 := Replic("-",20)
DETAIL_P->AVG_C07_20 := Replic("-",20)
UnLockDet()
AppendDet()

// TOTAIS
DETAIL_P->AVG_C01_20 := ALLTRIM(Transf(nTotQtde,cPictQtde))
HEADER_P->AVG_C14_20 := ALLTRIM(Transf(nTotal,cPICT)) 
HEADER_P->AVG_C15_20 := ALLTRIM(Transf(ZZE->ZZE_FRETE,cPICT)) 
HEADER_P->AVG_C16_20 := ALLTRIM(Transf(ZZE->ZZE_SEGURO,cPICT))
HEADER_P->AVG_C17_20 := ALLTRIM(Transf(0,cPICT))
HEADER_P->AVG_C18_20 := ALLTRIM(Transf(ZZE->ZZE_FRETE+ZZE->ZZE_SEGURO+nTotal,cPICT))

If lUnidade  .And. !lPesoManual 
   DETAIL_P->AVG_C07_20 := ALLTRIM(Transf(nTotal,cPict))
Else
   DETAIL_P->AVG_C07_20 := ALLTRIM(Transf(nTotal,cPict))
EndIf

UnLockDet()
HEADER_P->AVG_C12_20 := ALLTRIM(Transf(nTotal,cPict))

IF Select("Work_Men") > 0
	Work_Men->(dbGoTop())
	
	While !Work_Men->(Eof()) .And. Work_Men->WKORDEM < "zzzzz"
		gi_nTotLin:=MLCOUNT(Work_Men->WKOBS,40)
		For gi_W := 1 To gi_nTotLin
			If !Empty(MEMOLINE(Work_Men->WKOBS,40,gi_W))
				AppendDet()
				DETAIL_P->AVG_C01_60 := MemoLine(Work_Men->WKOBS,40,gi_W)
				UnLockDet()
			EndIf
		Next
		Work_Men->(dbSkip())
	Enddo
Endif

DO WHILE MOD(nLin,NUMLINPAG) <> 0
	APPENDDET()
ENDDO 

Return NIL

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: AppendDet
//|Descricao.: Adiciona registros no arquivo de detalhes
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function AppendDet()
*-----------------------------------------*

Begin Sequence
	nLin := nLin+1
	IF nLin > NUMLINPAG
		nLin := 1
		nPag := nPag+1
	ENDIF
	DETAIL_P->(dbAppend())
	DETAIL_P->AVG_FILIAL := xFilial("SY0")
	DETAIL_P->AVG_SEQREL := cSEQREL
	DETAIL_P->AVG_CHAVE  := cInvoice //nr. da Invoice
	DETAIL_P->AVG_CONT   := STRZERO(nPag,6,0)
End Sequence

Return NIL

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: UnlockDet
//|Descricao.: Desaloca registros no arquivo de detalhes
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function UnlockDet()
*-----------------------------------------*

Begin Sequence
	DETAIL_P->(dbUnlock())
End Sequence

Return NIL

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: TelaGets
//|Descricao.: Tela com Get de Dados do Pedido
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function TelaGets()
*-----------------------------------------*

Local lRet    := .F.
Local nOpc    := 0
Local oDlg
Local bOk     := {||nOpc:=1,Iif(!Empty(Alltrim(cInvoice)),oDlg:End(),MsgInfo("Invoice deve ser preenchida"))}
Local bCancel := {||nOpc:=0,oDlg:End()}
Local bSet    := {|x,o| lNcm := x, o:Refresh(), lNcm }
Local bSetP   := {|x,o| lPesoBru := x, o:Refresh(), lPesoBru }
Local bHide,bHideAll
Local oFld, oFldDoc, oFldNot,oFldCFG, oBtnOk, oBtnCancel
Local oYes, oNo, oYesP, oNoP, oMark, oMark2, oMark3
Local n,i,nTamLoj,cKey,cLoja,cImport
Local xx := "",nPosLin:=20
Local aCampos := {{"WKMARCA" ,," "},{"WKCODIGO",,STR0007},{"WKDESCR" ,,STR0008}} //"Descrição"
Local bShow   := {|nTela,o| Iif(nTela==2,dbSelectArea("Work"),Iif(nTela==3,dbSelectArea("WkMsg"),;
                            Iif(nTela==4,dbSelectArea("Work_Men"),))),;
                            o := Iif(nTela==2,oMark,Iif(nTela==3,oMark2,oMark3)):oBrowse,;
                            o:Show(),o:SetFocus() }
Private aMarcados[2], nMarcado := 0

Begin Sequence
	
	If lUnidade
		bHide := {|nTela| Iif(nTela==2,oMark:oBrowse:Hide(),;
		Iif(nTela==3,oMark2:oBrowse:Hide(),;
		Iif(nTela==4,oMark3:oBrowse:Hide(),;
		Iif(nTela==5,(oMark:oBrowse:Hide(),oMark2:oBrowse:Hide(),oMark3:oBrowse:Hide()),))))}
		
		bHideAll := {|| Eval(bHide,2), Eval(bHide,3), Eval(bHide,4),Eval(bHide,5) }
		
	Else
		bHide := {|nTela| Iif(nTela==2,oMark:oBrowse:Hide(),;
		Iif(nTela==3,oMark2:oBrowse:Hide(),;
		Iif(nTela==4,oMark3:oBrowse:Hide(),))) }
		
		bHideAll := {|| Eval(bHide,2), Eval(bHide,3), Eval(bHide,4)}
	EndIf
	
	
	// Notify
	EEN->(dbSeek(xFilial()+EE7->EE7_PEDIDO+OC_PE))
	
	While EEN->(!Eof() .And. EEN_FILIAL == xFilial("EEN")) .And.;
		EEN->EEN_PROCES+EEN->EEN_OCORRE == EE7->EE7_PEDIDO+OC_PE
		
		SysRefresh()
		
		Work->(dbAppend())
		Work->WKTIPO   := "N"
		Work->WKCODIGO := EEN->EEN_IMPORT+EEN->EEN_IMLOJA
		Work->WKDESCR  := EEN->EEN_IMPODE
		
		EEN->(dbSkip())
	Enddo
	
	Work->(dbGoTop())
	
	DEFINE MSDIALOG oDlg TITLE WorkId->EEA_TITULO FROM 9,0 TO 28,80 OF oMainWnd
	
	oFld := TFolder():New(1,1,Iif(lUnidade,{STR0009,STR0010,STR0011,STR0012,STR0021},{STR0009,STR0010,STR0011,STR0012}),; //"Configurações"
	Iif(lUnidade,{"IPC","IBC","OBS","MEN","CFG"},{"IPC","IBC","OBS","MEN"}),oDlg,,,,.T.,.F.,315,127) //"Documentos Para"###"Notify's"###"Mensagens"###"Observações"
	
	aEval(oFld:aControls,{|x| x:SetFont(oDlg:oFont) })
	
	// Documentos Para
	oFldDoc := oFld:aDialogs[1]
	
	If !lUnidade
		@ 10,001 SAY STR0013 SIZE 232,10 PIXEL OF oFldDoc //"Imprime N.C.M."
		
		oYes := TCheckBox():New(10,42,STR0014,{|x| Iif(PCount()==0, lNcm,Eval(bSet, x,oNo ))},oFldDoc,21,10,,,,,,,,.T.) //"Sim"
		oNo  := TCheckBox():New(10,65,STR0015,{|x| Iif(PCount()==0,!lNcm,Eval(bSet,!x,oYes))},oFldDoc,21,10,,,,,,,,.T.) //"Não"
		
		@ 10,100 SAY STR0016 SIZE 232,10 PIXEL OF oFldDoc //"Imprime Peso Bruto"
		
		oYesP := TCheckBox():New(10,157,STR0014,{|x| Iif(PCount()==0, lPesoBru,Eval(bSetP, x,oNoP ))},oFldDoc,21,10,,,,,,,,.T.) //"Sim"
		oNoP  := TCheckBox():New(10,180,STR0015,{|x| Iif(PCount()==0,!lPesoBru,Eval(bSetP,!x,oYesP))},oFldDoc,21,10,,,,,,,,.T.) //"Não"
	Else
		nPosLin := 10
	EndIf
	
	M->cCONTATO   := EE7->EE7_RESPON
	M->cEXP_CARGO := "EXPORT COORDINATOR"
	
	@ nPosLin,001 SAY STR0017 SIZE 232,10 PIXEL OF oFldDoc //"Assinante"
	@ nPosLin,043 GET M->cCONTATO SIZE 120,08 PIXEL OF oFldDoc
	
	@ nPosLin,170 SAY "Invoice" SIZE 50,10 PIXEL OF oFldDoc //"Invoice
	@ nPosLin,200 MSGET cInvoice  SIZE 70,08 F3 "ZZE" OF oFldDoc PIXEL
	
	@ nPosLin+10,001 SAY STR0018 SIZE 232,10 PIXEL OF oFldDoc //"Cargo"
	@ nPosLin+10,043 GET M->cEXP_CARGO SIZE 120,08 PIXEL OF oFldDoc
	
	@ nPosLin+24,001 SAY STR0019 SIZE 232,10 PIXEL OF oFldDoc //"Doct.Para"
	
	@ nPosLin+24,043 GET cC2160 SIZE 120,08 PIXEL OF oFldDoc
	@ nPosLin+34,043 GET cC2260 SIZE 120,08 PIXEL OF oFldDoc
	@ nPosLin+44,043 GET cC2360 SIZE 120,08 PIXEL OF oFldDoc
	@ nPosLin+54,043 GET cC2460 SIZE 120,08 PIXEL OF oFldDoc
	@ nPosLin+64,043 GET cC2960 SIZE 120,08 PIXEL OF oFldDoc
	@ nPosLin+74,043 GET cC3060 SIZE 120,08 PIXEL OF oFldDoc
	
	// Folder Notify's ...
	oMark := MsSelect():New("Work","WKMARCA",,aCampos,@lInverte,@cMarca,{18,3,125,312})
	oMark:bAval := {|| ChkMarca(oMark,cMarca) }
	@ 14,043 GET xx OF oFld:aDialogs[2]
	AddColMark(oMark,"WKMARCA")
	
	
	// Folder Mensagens ...
	@ 14,043 GET xx OF oFld:aDialogs[3]
	oMark3 := EECMensagem(EE7->EE7_IDIOMA,"#",{18,3,125,312},,,,oDlg)
	
	// Folder Observações ...
	oMark2 := Observacoes("New",cMarca)
	@ 14,043 GET xx OF oFld:aDialogs[4]
	AddColMark(oMark2,"WKMARCA")
	
	If lUnidade
		// Folder Configuções ...
		oFldCFG:= oFld:aDialogs[5]
		
		@ 05,03 To 60,310 LABEL STR0022 OF oFldCFG PIXEL //"Unidades de Medida"
		
		@ 15,08 SAY STR0023 SIZE 50,07 OF oFldCFG PIXEL //"U.M. Qtde.:"
		@ 15,55 MSGET cUnQtde SIZE 20,07 F3 "SAH" OF oFldCFG PIXEL
		
		@ 27,08 SAY STR0024 SIZE 50,07 OF oFldCFG PIXEL //"U.M. Preço.:"
		@ 27,55 MSGET cUnPreco SIZE 20,07 F3 "SAH" OF oFldCFG PIXEL
		
		@ 39,08 SAY STR0025 SIZE 50,07 OF oFldCFG PIXEL //"U.M. Peso.:"
		@ 39,55 MSGET cUnPeso SIZE 20,07 F3 "SAH" OF oFldCFG PIXEL
		
		@ 65,03 To 100,310 LABEL STR0026 OF oFldCFG PIXEL     //"Impressão"
		
		@ 75,08 SAY STR0013 SIZE 232,10 PIXEL OF oFldCFG //"Imprime N.C.M."
		
		oYes := TCheckBox():New(75,62,STR0014,{|x| Iif(PCount()==0, lNcm,Eval(bSet, x,oNo ))},oFldCFG,21,10,,,,,,,,.T.) //"Sim"
		oNo  := TCheckBox():New(75,85,STR0015,{|x| Iif(PCount()==0,!lNcm,Eval(bSet,!x,oYes))},oFldCFG,21,10,,,,,,,,.T.) //"Não"
		
		@ 87,08 SAY STR0016 SIZE 232,10 PIXEL OF oFldCFG //"Imprime Peso Bruto"
		
		oYesP := TCheckBox():New(87,62,STR0014,{|x| Iif(PCount()==0, lPesoBru,Eval(bSetP, x,oNoP ))},oFldCFG,21,10,,,,,,,,.T.) //"Sim"
		oNoP  := TCheckBox():New(87,85,STR0015,{|x| Iif(PCount()==0,!lPesoBru,Eval(bSetP,!x,oYesP))},oFldCFG,21,10,,,,,,,,.T.) //"Não"
		
	EndIf
	
	Eval(bHideAll)
	
	If lUnidade
		oFld:bChange := {|nOption,nOldOption| Eval(bHide,nOldOption),;
		IiF(nOption <> 1 .And. nOption <> 5,Eval(bShow,nOption),) }
	ELse
		oFld:bChange := {|nOption,nOldOption| Eval(bHide,nOldOption),;
		IiF(nOption <> 1,Eval(bShow,nOption),)}
	EndIf
	
	DEFINE SBUTTON oBtnOk     FROM 130,258 TYPE 1 ACTION Eval(bOk) ENABLE OF oDlg
	DEFINE SBUTTON oBtnCancel FROM 130,288 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	IF nOpc == 0
		Break
	Endif
	
	lRet := .t.
	
	n := 1
	For i:=1 To 2
		IF !Empty(aMarcados[i])
			nTamLoj := AVSX3("EEN_IMLOJA",3)
			cKey    := Subst(aMarcados[i],2)
			cLoja   := Right(cKey,nTamLoj)
			cImport := Subst(cKey,1,Len(cKey)-nTamLoj)
			
			IF EEN->(dbSeek(xFilial()+AvKey(EE7->EE7_PREEMB,"EEN_PROCES")+OC_EM+AvKey(cImport,"EEN_IMPORT")+AvKey(cLoja,"EEN_IMLOJA")))
				aNotify[n]   := EEN->EEN_IMPODE
				aNotify[n+1] := EEN->EEN_ENDIMP
				aNotify[n+2] := EEN->EEN_END2IM
				n := n+3
			Endif
		Endif
	Next
	
	cEXP_CONTATO := M->cCONTATO
	
End Sequence
	
OBSERVACOES("END")
	
Return lRet

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: ChkMarca
//|Descricao.: Faz marcação na Work
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function ChkMarca(oMark,cMarca)
*-----------------------------------------*

Local n

Begin Sequence
	IF ! Work->(Eof() .Or. Bof())
		IF !Empty(Work->WKMARCA)
			// Desmarca
			n := aScan(aMarcados,Work->WKTIPO+Work->WKCODIGO)
			IF n > 0
				aMarcados[n] := ""
			Endif
			
			Work->WKMARCA := Space(2)
		Else
			// Marca
			IF !Empty(aMarcados[1]) .And. !Empty(aMarcados[2])
				HELP(" ",1,"AVG0005046") //MsgStop("Já existem dois notify's selecionados !","Aviso")
				Break
			Endif
			
			IF Empty(aMarcados[1])
				aMarcados[1] := Work->WKTIPO+Work->WKCODIGO
			Else
				aMarcados[2] := Work->WKTIPO+Work->WKCODIGO
			Endif
			
			Work->WKMARCA := cMarca
		Endif
		
		oMark:oBrowse:Refresh()
	Endif
End Sequence

Return NIL

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: Observacoes
//|Descricao.: Preenche observações
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function Observacoes(cAcao,cMarca)
*-----------------------------------------*

Local xRet := nil
Local cPaisEt := Posicione("SA1",1,xFilial("SA1")+EE7->EE7_IMPORT+EE7->EE7_IMLOJA,"A1_PAIS")
Local nAreaOld, aOrd, aSemSx3
Local cTipMen, cIdioma, cTexto, i
Local oMark
Local lInverte := .F.
Static aOld

Begin Sequence
	cAcao := Upper(AllTrim(cAcao))
	
	IF cAcao == "NEW"
		aOrd := SaveOrd({"EE4","EE1"})
		
		EE1->(dbSetOrder(1))
		EE4->(dbSetOrder(1))
		
		Private aHeader := {}, aCAMPOS := array(EE4->(fcount()))
		aSemSX3 := { {"WKMARCA","C",02,0},{"WKTEXTO","M",10,0}}
		
		aOld := {Select(), E_CriaTrab("EE4",aSemSX3,"WkMsg")}
		
		EE1->(dbSeek(xFilial()+TR_MEN+cPAISET))
		
		While !EE1->(Eof()) .And. EE1->EE1_FILIAL == xFilial("EE1") .And.;
			EE1->EE1_TIPREL == TR_MEN .And.;
			EE1->EE1_PAIS == cPAISET
			
			cTipMen := EE1->EE1_TIPMEN+"-"+Tabela("Y8",AVKEY(EE1->EE1_TIPMEN,"X5_CHAVE"))
			cIdioma := Posicione("SYA",1,xFilial("SYA")+EE1->EE1_PAIS,"YA_IDIOMA")
			
			IF EE4->(dbSeek(xFilial()+AvKey(EE1->EE1_DOCUM,"EE4_COD")+AvKey(cTipMen,"EE4_TIPMEN")+AvKey(cIdioma,"EE4_IDIOMA")))
				WkMsg->(dbAppend())
				cTexto := MSMM(EE4->EE4_TEXTO,AVSX3("EE4_VM_TEX",3))
				
				For i:=1 To MlCount(cTexto,AVSX3("EE4_VM_TEX",3))
					WkMsg->WKTEXTO := WkMsg->WKTEXTO+MemoLine(cTexto,AVSX3("EE4_VM_TEX",3),i)+ENTER
				Next
				
				WkMsg->EE4_TIPMEN := EE4->EE4_TIPMEN
				WkMsg->EE4_COD    := EE4->EE4_COD
			ENDIF
			
			EE1->(dbSkip())
		Enddo
		
		dbSelectArea("WkMsg")
		WkMsg->(dbGoTop())
		
		aCampos := {{"WKMARCA",," "},ColBrw("EE4_COD","WkMsg"),ColBrw("EE4_TIPMEN","WkMsg"),;
		{{|| MemoLine(WkMsg->WKTEXTO,AVSX3("EE4_VM_TEX",AV_TAMANHO),1)},"",AVSX3("EE4_VM_TEX",AV_TITULO)}}
		
		oMark := MsSelect():New("WkMsg","WKMARCA",,aCampos,lInverte,@cMarca,{18,3,125,312})
		oMark:bAval := {|| EditObs(cMarca), oMark:oBrowse:Refresh() }
		xRet := oMark
		
		RestOrd(aOrd)
	Elseif cAcao == "END"
		IF Select("WkMsg") > 0
			WkMsg->(E_EraseArq(aOld[2]))
		Endif
		
		Select(aOld[1])
	Endif
End Sequence

Return xRet

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: EditObs
//|Descricao.: Edita observações
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function EditObs(cMarca)
*-----------------------------------------*

Local nOpc, cMemo, oDlg

Local bOk     := {|| nOpc:=1, oDlg:End() }
Local bCancel := {|| oDlg:End() }

Local nRec

IF WkMsg->(!Eof())
	IF Empty(WkMsg->WKMARCA)
		nOpc:=0
		cMemo := WkMsg->WKTEXTO
		
		DEFINE MSDIALOG oDlg TITLE WorkId->EEA_TITULO FROM 7,0.5 TO 26,79.5 OF oMainWnd
		
		@ 05,05 SAY STR0020 PIXEL //"Tipo Mensagem"
		@ 05,45 GET WkMsg->EE4_TIPMEN WHEN .F. PIXEL
		@ 20,05 GET cMemo MEMO SIZE 300,105 OF oDlg PIXEL HSCROLL
		
		DEFINE SBUTTON oBtnOk     FROM 130,246 TYPE 1 ACTION Eval(bOk) ENABLE OF oDlg
		DEFINE SBUTTON oBtnCancel FROM 130,278 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg
		
		ACTIVATE MSDIALOG oDlg CENTERED // ON INIT EnchoiceBar(oDlg,bOk,bCancel)
		
		IF nOpc == 1
			IF !Empty(nMarcado)
				nRec := WkMsg->(RecNo())
				WkMsg->(dbGoTo(nMarcado))
				WkMsg->WKMARCA := Space(2)
				WkMsg->(dbGoTo(nRec))
			Endif
			cObs := cObs + CMemo
			WkMsg->WKTEXTO := cMemo
			WkMsg->WKMARCA := cMarca
			nMarcado := nRec
		Endif
	Else
		cObs := ""
		WkMsg->WKMARCA := Space(2)
		nMarcado := 0
	Endif
Endif
     
Return NIL

//+-----------------------------------------------------------------------------------//
//|FIM DO PROGRAMA EECINV
//+-----------------------------------------------------------------------------------//