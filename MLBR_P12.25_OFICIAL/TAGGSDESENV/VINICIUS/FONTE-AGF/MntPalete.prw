#include "protheus.ch"
#include "rwmake.ch"
#include "FONT.ch"

//+--------------------------------------------------------------------+
//| Rotina | MntPalete | Autor | Anesio - Taggs     | Data | 11.07.2010|
//+--------------------------------------------------------------------+
//| Descr. | Programa para manutencao de paletes e class.couro/vaquetas|
//+--------------------------------------------------------------------+
//| Uso    | Penapolis 1 Curtume                                       |
//+--------------------------------------------------------------------+
User Function MntPalete()
	Private cCadastro := "Manutenção Paletes"
	Private aRotina := {}
	
	AADD( aRotina, {"Pesquisar"  			,"AxPesqui" ,0,1})
	AADD( aRotina, {"Visualizar" 			,'U_VSS_MntPLTinc',0,2})
	AADD( aRotina, {"Incluir"    			,'U_VSS_MntInc',0,3})
	AADD( aRotina, {"Inf.Iniciais"    		,'U_VSS_MntPLTinc',0,4})
	AADD( aRotina, {"Inf.Confer"			,'U_PltConf',0,4})
	AADD( aRotina, {"Excluir"    			,'U_MntEx',0,5})

	dbSelectArea("SZO")
	dbSetOrder(1)
	dbGoTop()
	
	MBrowse(,,,,"SZO")
Return             


//+--------------------------------------------------------------------+
//| Rotina | VSS_MntInc    | Autor | Anesio - Taggs     | Data | 11.07.2010|
//+--------------------------------------------------------------------+
//| Descr. | Rotina de inclusão, não utilizado será utilizado          |
//+--------------------------------------------------------------------+
//| Uso    | Penapolis 1 Curtume                                       |
//+--------------------------------------------------------------------+
User Function VSS_MntInc( cAlias, nReg, nOpc )
	Msgbox("Função de inclusão nao disponivel nessa rotina")
Return


//+--------------------------------------------------------------------+
//| Rotina | VSS_MntPLTinc | Autor | Anesio - Taggs     | Data | 12.07.2010|
//+--------------------------------------------------------------------+
//| Descr. | Rotina para Visualizar, Alterar e Excluir dados.          |
//+--------------------------------------------------------------------+
//| Uso    | Classificacao de tipo de couro - Curtume - PNP1           |
//+--------------------------------------------------------------------+

User Function VS_MntPLTinc( cAlias, nReg, nOpc ) 
	Local cArq
	Local oDlg
	Local oGet
	Local oTPanel1
	Local oTPAnel2
	Local cFornece :=  space(6)  //Space(Len(Space(SZ8->Z8_Fornece)))
	Local cNomeForn := space(40) //Space(Len(Space(Posicione("SA2",1,xFilial("SA2")+SZ8->Z8_Fornece,"A2_NOME"))))
	Local dData := Ctod(Space(8))
	Local cLote := space(10)
	Local nOpca			:= 0
	
	Local aCampos	:= {}
	Local aAltera	:= {}
	Local aEntid	:= {}

	
	Private aHeader := {}
    Private aCOLS := {}
	Private aREG := {}

	Private oTotalM2
	Private oTotalVQ
	Private oMediaM2VQ
	Private nTotalM2
	Private nTotalVQ
	Private nMediaM2VQ
	
	nTotalM2  := 0
	nTotalVQ  := 0
	nMediaM2VQ:= 0

	dbSelectArea( cAlias )
	dbGoTo( nReg )
	
	cNota       := SZ8->Z8_NFISCAL
	cNomeForn   := Posicione("SA2",1,xFilial("SA2")+SZ8->Z8_Fornece,"A2_NOME")
	dData  			:= SZ8->Z8_DTNOTA
	cLote       := SZ8->Z8_NUMLOTE

aCampos := U_VSS_MntaHeader(@aAltera)
U_MntaTblTMP(aCampos,@cArq)
U_VSS_MntColsTMP(nOpc)
		
	DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

  	DEFINE FONT oFnt	NAME "Arial" Size 10,15

		oTPanel1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
		oTPanel1:Align := CONTROL_ALIGN_TOP
	
		@ 4, 005 SAY "N.Fiscal:" SIZE 70,7 PIXEL OF oTPanel1
		@ 4, 068 SAY "Fornedor:"    SIZE 70,7 PIXEL OF oTPanel1
		@ 4, 190 SAY "Emissao:" SIZE 70,7 PIXEL OF oTPanel1
		@ 4, 260 Say "Lote:"    SIZE 70,7 PIXEL OF oTPanel1

		@ 3, 028 MSGET cNota When .F. SIZE 30,7 PIXEL OF oTPanel1
		@ 3, 100 MSGET cNomeForn   When .F. SIZE 78,7 PIXEL OF oTPanel1
		@ 3, 215 MSGET dData   When .F. SIZE 40,7 PIXEL OF oTPanel1
		@ 3, 275 MSGET cLote  When .F. SIZE 40,7 PIXEL OF oTPanel1
		oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,15,.T.,.F.)
		oTPanel2:Align := CONTROL_ALIGN_BOTTOM
		
		If nOpc == 4
			oGet := 	MSGetDB():New(0, 0, 0, 0, Iif(nOpc==3,4,nOpc),"U_VS_MntaLok","U_VSS_cTok", "+Z8_ITEM",.t.,aAltera,,.t.,,"TMP",,,,,,,"")//"U_VSS_MntaDEL")
		Else
			oGet := MSGetDados():New(0,0,0,0,nOpc)
		Endif

		oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT


  	@004,002 	SAY OemToAnsi("TOTAL M²: ") PIXEL FONT oFnt COLOR CLR_BLACK OF oTPanel2
	  @004,048 	SAY oTotalM2 VAR nTotalM2 Picture "@E 999,999.99" PIXEL FONT oFnt COLOR CLR_HBLUE OF oTPanel2
  	@004,090 	SAY OemToAnsi("TOTAL VQ: ") PIXEL FONT oFnt COLOR CLR_BLACK OF oTPanel2
  	@004,138	SAY oTotalVQ VAR nTotalVQ Picture "@E 999,999.99" PIXEL FONT oFnt COLOR CLR_HBLUE OF oTPanel2
   	@004,180	SAY OemToAnsi("MEDIA M² P/VQ: ") PIXEL	FONT oFnt COLOR CLR_BLACK	OF oTPanel2
  	@004,270 	SAY oMediaM2VQ VAR nMediaM2VQ Picture "@E 9,999.99" PIXEL FONT oFnt COLOR CLR_HBLUE OF oTPanel2

	U_VSS_MntExibe(0,.T.)

//ACTIVATE MSDIALOG oDlg CENTER ON INIT ;
//	EnchoiceBar(oDlg,{|| ( IIF( nOpc==4, U_VSS_MntGrvA(nOpc), IIF( nOpc==5, MntGrvE(), oDlg:End() ) ), oDlg:End() ) },	{|| oDlg:End() })


	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,;
				{||nOpca:=1,if(u_VSS_cTok(), (u_VSS_MntGrva(nOPC), oDlg:End()),nOpca := 0)},;
				{||nOpca:=2,oDlg:End()}) VALID nOpca != 0 CENTERED



	
DbSelectArea( "TMP" )
DbCloseArea()
If Select("cArq") = 0
	FErase(cArq+GetDBExtension())
EndIf

dbSelectArea("SZ8")
dbSetOrder(1)

Return nOpca
	



//+--------------------------------------------------------------------+
//| Rotina | VSS_MntPltConf | Autor | Anesio - Taggs     | Data | 12.07.2010|
//+--------------------------------------------------------------------+
//| Descr. | Rotina para Visualizar, Alterar e Excluir dados.          |
//+--------------------------------------------------------------------+
//| Uso    | Conferencia da Classif.do tipo de Couro  - PNP1           |
//+--------------------------------------------------------------------+

User Function PltConf( cAlias, nReg, nOpc ) 
	Local cArq
	Local oDlg
	Local oGet
	Local oTPanel1
	Local oTPAnel2
	Local cFornece :=  space(6)  //Space(Len(Space(SZ8->Z8_Fornece)))
	Local cNomeForn := space(40) //Space(Len(Space(Posicione("SA2",1,xFilial("SA2")+SZ8->Z8_Fornece,"A2_NOME"))))
	Local dData := Ctod(Space(8))
	Local cLote := space(10)
	Local nOpca			:= 0

	Local aCampos	:= {}
	Local aAltera	:= {}
	Local aEntid	:= {}

	Private aHeader := {}
  Private aCOLS := {}
	Private aREG := {}


	Private oTotalM2CF
	Private oTotalVQCF
	Private oMediaM2VQCF
	Private nTotalM2CF
	Private nTotalVQCF
	Private nMediaM2VQCF
	
	nTotalM2CF  := 0
	nTotalVQCF  := 0
	nMediaM2VQCF:= 0

	dbSelectArea( cAlias )
	dbGoTo( nReg )
	nOpc:= 4
	cNota       := SZ8->Z8_NFISCAL
	cNomeForn   := Posicione("SA2",1,xFilial("SA2")+SZ8->Z8_Fornece,"A2_NOME")
	dData  			:= SZ8->Z8_DTNOTA
	cLote       := SZ8->Z8_NUMLOTE
		

aCampos := U_MntaHderCf(@aAltera)
U_MntaTblTMP(aCampos,@cArq)
U_VSS_MntColsTMP(nOpc)

	DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 40,140 OF oMainWnd

  	DEFINE FONT oFnt	NAME "Arial" Size 10,15
		oTPanel1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
		oTPanel1:Align := CONTROL_ALIGN_TOP

	
		@ 4, 005 SAY "N.Fiscal:" SIZE 70,7 PIXEL OF oTPanel1
		@ 4, 068 SAY "Fornedor:"    SIZE 70,7 PIXEL OF oTPanel1
		@ 4, 190 SAY "Emissao:" SIZE 70,7 PIXEL OF oTPanel1
		@ 4, 260 Say "Lote:"    SIZE 70,7 PIXEL OF oTPanel1

		@ 3, 028 MSGET cNota When .F. SIZE 30,7 PIXEL OF oTPanel1
		@ 3, 100 MSGET cNomeForn   When .F. SIZE 78,7 PIXEL OF oTPanel1
		@ 3, 215 MSGET dData   When .F. SIZE 40,7 PIXEL OF oTPanel1
		@ 3, 275 MSGET cLote  When .F. SIZE 40,7 PIXEL OF oTPanel1
		oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,24,.T.,.F.)
		oTPanel2:Align := CONTROL_ALIGN_BOTTOM
		If nOpc == 4
  		oGet := 	MSGetDB():New(0, 0, 0, 0, Iif(nOpc==3,4,nOpc),"U_MntaLokCF","U_cTokCF", "+Z8_ITEM",.t.,aAltera,,.t.,,"TMP",,,,,,,"U_MntDELCF")
		Else
		   oGet := MSGetDados():New(0,0,0,0,nOpc)
		Endif

		oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
	@004,002 	SAY OemToAnsi("TOTAL M² CF: ") PIXEL FONT oFnt COLOR CLR_BLACK OF oTPanel2
	@004,058 	SAY oTotalM2CF VAR nTotalM2CF Picture "@E 999,999.99" PIXEL FONT oFnt COLOR CLR_HBLUE OF oTPanel2
  	@004,100 	SAY OemToAnsi("TOTAL VQ.CF: ") PIXEL FONT oFnt COLOR CLR_BLACK OF oTPanel2
  	@004,168	SAY oTotalVQCF VAR nTotalVQCF Picture "@E 999,999.99" PIXEL FONT oFnt COLOR CLR_HBLUE OF oTPanel2
   	@004,210	SAY OemToAnsi("MEDIA M² P/VQ.CF: ") PIXEL	FONT oFnt COLOR CLR_BLACK	OF oTPanel2
  	@004,300 	SAY oMediaM2VQCF VAR nMediaM2VQCF Picture "@E 9,999.99" PIXEL FONT oFnt COLOR CLR_HBLUE OF oTPanel2 
  	@225,420  BMPBUTTON TYPE 06 ACTION (ExecBlock("VSS_MntGrvaCF"), ExecBlock("RELMNTPLT") ) 

	U_MntExbCF(0,.T.)

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,;
				{||nOpca:=1,if(u_cTokCF(), (u_MntGrvaCF(nOPC), oDlg:End()),nOpca := 0)},;
				{||nOpca:=2,oDlg:End()}) VALID nOpca != 0 CENTERED
	

DbSelectArea( "TMP" )
DbCloseArea()
If Select("cArq") = 0
	FErase(cArq+GetDBExtension())
EndIf	
	
dbSelectArea("SZ8")
dbSetOrder(1)

	
Return nOpca




//+--------------------------------------------------------------------+
//| Rotina | VSS_MntaHeader | Autor | Anesio - Taggs     |Data|12.07.2010  |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para montar o vetor aHeader. Na conferencia de     |
//|        | dos paletes 																							 |
//+--------------------------------------------------------------------+
//| Uso    | Modulo de desmontagem de produtos (Exclusivo curtume)     |
//+--------------------------------------------------------------------+
User Function VSS_MntaHeader(aAltera)

Local aArea:= GetArea()
Local aCampos	:= {}

PRIVATE nUsado := 0
// Montagem da matriz aHeader									
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZ8")
While !EOF() .And. (x3_arquivo == "SZ8")
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL 
		if X3_CAMPO == "Z8_DOCSD3 " .or. X3_CAMPO == "Z8_CLASSE "; 
		     .or. X3_CAMPO == "Z8_PALETE " .or. X3_CAMPO == "Z8_MQUAD  ";
		     .or. X3_CAMPO == "Z8_QTDCOU " .or. X3_CAMPO == "Z8_ITEM   ";
		     .or. X3_CAMPO == "Z8_NUMLOTE" .or. X3_CAMPO == "Z8_SUBLOTE"
			nUsado++
			AADD(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
								x3_tamanho, x3_decimal, x3_valid,;
								x3_usado, x3_tipo, "TMP", x3_context } )
			If Alltrim(x3_campo) <> "Z8_ITEM"
				Aadd(aAltera,Trim(X3_CAMPO))
			EndIf
		EndIF
	EndIF
	aAdd( aCampos, { SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO,;
						 SX3->X3_DECIMAL } )
	dbSkip()
EndDO

Aadd(aCampos,{"Z8_FLAG","L",1,0})

RestArea(aArea)

Return aCampos

//+--------------------------------------------------------------------+
//| Rotina | MntaHderCf | Autor | Anesio - Taggs     |Data|12.07.2010  |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para montar o vetor aHeader. Na conferencia de     |
//|        | dos paletes final dos paletes														 |
//+--------------------------------------------------------------------+
//| Uso    | Modulo de desmontagem de produtos (Exclusivo curtume)     |
//+--------------------------------------------------------------------+

User Function MntaHderCf(aAltera)
Local aArea := GetArea()
Local aCampos	:= {}
PRIVATE nUsado := 0
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZ8")
While !EOF() .And. (x3_arquivo == "SZ8")
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL 
		  if X3_CAMPO == "Z8_NUMLOTE" .or. X3_CAMPO == "Z8_PALETE "; 
		     .or. X3_CAMPO == "Z8_MQUADCF" .or. X3_CAMPO == "Z8_QTDCOUC";
		     .or. X3_CAMPO == "Z8_QTTPC  " .or. X3_CAMPO == "Z8_ITEM   ";
		     .or. X3_CAMPO == "Z8_QTTPD  " .or. X3_CAMPO == "Z8_QTTPE  ";
		     .or. X3_CAMPO == "Z8_QTTPER " .or. X3_CAMPO == "Z8_QTTPDER";
		     .or. X3_CAMPO == "Z8_DTCLASS" .or. X3_CAMPO == "Z8_PRONTO ";
		     .or. X3_CAMPO == "Z8_CLASSE " .or. X3_CAMPO == "Z8_QTTPF  "
				nUsado++                  
				AADD(aHeader,{ TRIM(X3Titulo()),;
				 x3_campo, x3_picture,;
				 x3_tamanho,;
				 x3_decimal,;
				 x3_valid,;
				 x3_usado,;
				 x3_tipo,;
				 "TMP",;
				 x3_context } )


			If Alltrim(x3_campo) <> "Z8_ITEM"
				Aadd(aAltera,Trim(X3_CAMPO))
			EndIf
		EndIF
	EndIF                                                   	
	aAdd( aCampos, { SX3->X3_CAMPO,;
			 SX3->X3_TIPO,;
			 SX3->X3_TAMANHO,;
			 SX3->X3_DECIMAL } )
	dbSkip()
EndDO

Aadd(aCampos,{"Z8_FLAG","L",1,0})

RestArea(aArea)

Return aCampos

//+--------------------------------------------------------------------+
//| Rotina | VSS_MtaColsTMP| Autor | Anesio - Taggs    | Data | 11.07.2010|
//+--------------------------------------------------------------------+
//| Descr. | Rotina para montar o vetor aCOLS.                         |
//+--------------------------------------------------------------------+
//| Uso    | Penapolis 1 Curtume                                       |
//+--------------------------------------------------------------------+
   
user Function VSS_MntColsTMP(nOpc)
Local aArea:= GetArea()
Local cAlias	:= "SZ8"
Local nPos
Local nCont
Local cOldFiltro:=""
Public cChaveRel:="" 
If nOpc != 3						// Visualizacao / Alteracao / Exclusao
	cOldFiltro:=SZ8->(DBFILTER())
	cChave := SZ8->Z8_FILIAL + SZ8->Z8_DOCSD3 + SZ8->Z8_NFISCAL + SZ8->Z8_SERIE+SZ8->Z8_FORNECE+SZ8->Z8_LOJA
	cChaveRel:= cChave
	dbSelectArea("SZ8")
	dbClearFilter()
	dbSetOrder(4)
 	If dbSeek(cChave)           
   	While !EOF() .And. cChave == xFilial("SZ8")+SZ8->Z8_DOCSD3 + SZ8->Z8_NFISCAL + SZ8->Z8_SERIE+SZ8->Z8_FORNECE+SZ8->Z8_LOJA
			dbSelectArea("TMP")
			dbAppend()
			For nCont := 1 To Len(aHeader)
				nPos := FieldPos(aHeader[nCont][2])
				If (aHeader[nCont][08] <> "M" .And. aHeader[nCont][10] <> "V" )
					FieldPut(nPos,(cAlias)->(FieldGet(FieldPos(aHeader[nCont][2]))))
				EndIf
			Next nCont 
			TMP->Z8_FLAG := .F.
			dbSelectArea("SZ8")
			dbSkip()
		EndDo
	EndIf
	dbSelectArea("SZ8")
	Set Filter to &(cOldFiltro)
Else
	dbSelectArea("TMP")
	dbAppend()
	For nCont := 1 To Len(aHeader)                  	
		If (aHeader[nCont][08] <> "M" .And. aHeader[nCont][10] <> "V" )
			nPos := FieldPos(aHeader[nCont][2])
			FieldPut(nPos,CriaVar(aHeader[nCont][2],.T.))
		EndIf
	Next nCont
	TMP->Z8_FLAG := .F.
	TMP->Z8_ITEM := "01" 
EndIf

dbSelectArea("TMP")
dbGoTop()

RestArea(aArea)

Return



//+--------------------------------------------------------------------+
//| Rotina | VSS_MntGrvA | Autor | Anesio - Taggs     | Data | 11.07.2010  |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para gravar os dados na alteração.                 |
//+--------------------------------------------------------------------+
//| Uso    | Penapolis 1 Curtume                                       |
//+--------------------------------------------------------------------+

User Function VSS_MntGrvA(nOpc)
Local aArea := GetArea()
Local nCont
Local lDelSEQ1 := .F.
Local cChave := space(50)
dbSelectArea("TMP") 
dbgotop()                
cChave := cChaveRel
nOpc := 4
While !Eof() 
	If !TMP->Z8_FLAG
		If nOpc == 3 .Or. nOpc == 4
			dbSelectArea("SZ8")
			dbSetOrder(4)
//			msgbox("Gravando item...."+cChave)
//			If !(dbSeek(SZ8->Z8_FILIAL + SZ8->Z8_DOCSD3 + SZ8->Z8_NFISCAL + SZ8->Z8_SERIE+SZ8->Z8_FORNECE+SZ8->Z8_LOJA+TMP->Z8_ITEM))
			If dbSeek(cChave+TMP->Z8_ITEM)
//				msgbox("Item Localizado...."+cChave+TMP->Z8_ITEM+"--")
				RecLock( "SZ8", .F. )         
				SZ8->Z8_CLASSE		:= TMP->Z8_CLASSE
				SZ8->Z8_PALETE		:= TMP->Z8_PALETE
				SZ8->Z8_MQUAD     := TMP->Z8_MQUAD
				SZ8->Z8_QTDCOU    := TMP->Z8_QTDCOU
				SZ8->Z8_PRONTO := 'N'				
			Endif
//			For nCont := 1 To Len(aHeader)
//				If (aHeader[nCont][10] != "V" )
//					FieldPut(FieldPos(aHeader[nCont][2]),;
//					TMP->(FieldGet(FieldPos(aHeader[nCont][2]))))
//				EndIf
//			Next nCont
			MsUnLock()		
		endif
	Else
		dbSelectArea("SZ8")
		dbSetOrder(4)
		If dbSeek(cChave+TMP->Z8_ITEM)
			If TMP->Z8_ITEM == STRZERO(1,LEN(TMP->Z8_ITEM))
				lDelSEQ1 := .T.
			Endif
			RecLock( "SZ8", .f., .t. )
			DbDelete()
			MsUnlock()
		Endif                  
	EndIf
	dbSelectArea("TMP")
	dbSkip()
Enddo

RestArea(aArea)

Return




//+--------------------------------------------------------------------+
//| Rotina | VSS_MntGrvA | Autor | Anesio - Taggs     | Data | 11.07.2010  |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para gravar os dados na alteração.                 |
//+--------------------------------------------------------------------+
//| Uso    | Penapolis 1 Curtume                                       |
//+--------------------------------------------------------------------+

User Function MntGrvACF(nOpc)
Local aArea := GetArea()
Local nCont
Local lDelSEQ1 := .F.
Local cChave := space(50)
dbSelectArea("TMP") 
dbgotop()                
cChave := cChaveRel
nOpc := 4
While !Eof() 
	If !TMP->Z8_FLAG
		If nOpc == 3 .Or. nOpc == 4
			dbSelectArea("SZ8")
			dbSetOrder(4)
			If dbSeek(cChave+TMP->Z8_ITEM)
				RecLock( "SZ8", .F. )
				SZ8->Z8_FILIAL		:= xFilial()
				SZ8->Z8_CLASSE		:= TMP->Z8_CLASSE
				SZ8->Z8_PALETE		:= TMP->Z8_PALETE
				SZ8->Z8_MQUADCF   := TMP->Z8_MQUADCF
				SZ8->Z8_QTDCOUC   := TMP->Z8_QTDCOUC
				SZ8->Z8_QTTPDER   := TMP->Z8_QTTPDER
				SZ8->Z8_QTTPER    := TMP->Z8_QTTPER
				SZ8->Z8_QTTPC     := TMP->Z8_QTTPC
				SZ8->Z8_QTTPD     := TMP->Z8_QTTPD
				SZ8->Z8_QTTPE     := TMP->Z8_QTTPE
				SZ8->Z8_QTTPF     := TMP->Z8_QTTPF
				SZ8->Z8_DTCLASS   := TMP->Z8_DTCLASS
				if (TMP->Z8_QTTPC + TMP->Z8_QTTPD + TMP->Z8_QTTPER + TMP->Z8_QTTPDER + TMP->Z8_QTTPE + TMP->Z8_QTTPF) == TMP->Z8_QTDCOUC
					SZ8->Z8_PRONTO := 'S'				
				else
					SZ8->Z8_PRONTO := 'N'
				endif
			Else                                 
				msgbox("Item não localizado.... "+cChave)
			Endif
			For nCont := 1 To Len(aHeader)
				If (aHeader[nCont][10] != "V" )
					//If lDelSEQ1 .and. alltrim(aHeader[nCont][2]) == "Z8_ITEM"		/// SE DELETOU A 1ª SEQUENCIA RENUMERA A PROXIMA PARA 0001
					//	SZ8->Z8_ITEM := STRZERO(1,LEN(TMP->Z8_ITEM))
					//	lDelSEQ1 := .F.
					//Else       
						FieldPut(FieldPos(aHeader[nCont][2]),;
						TMP->(FieldGet(FieldPos(aHeader[nCont][2]))))
					//EndIf
				EndIf
			Next nCont
			MsUnLock()		
	Elseif nOpc == 5 //Se for exclusao
			dbSelectArea("SZ8")
			dbSetOrder(4)
			If dbSeek(cChave+TMP->CTJ_SEQUEN)
				RecLock("SZ8",.F.,.T.)
				dbDelete()
				MsUnlOCK()
			EndIf
		EndIf
	Else
		dbSelectArea("SZ8")
		dbSetOrder(4)
		If dbSeek(cChave+TMP->Z8_ITEM)
			If TMP->Z8_ITEM == STRZERO(1,LEN(TMP->Z8_ITEM))
				lDelSEQ1 := .T.
			Endif
			RecLock( "SZ8", .f., .t. )
			DbDelete()
			MsUnlock()
		Endif                  
	EndIf
	dbSelectArea("TMP")
	dbSkip()
Enddo

RestArea(aArea)

Return






//+--------------------------------------------------------------------+
//| Rotina | MntGrvE | Autor | Anesio - Taggs     | Data | 11.07.2010  |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para excluir os registros.                         |
//+--------------------------------------------------------------------+
//| Uso    | Penapolis 1 Curtume                                       |
//+--------------------------------------------------------------------+
Static Function MntGrvE()
Local nI := 0
dbSelectArea("SZ8")
For nI := 1 To Len( aCOLS )
	dbGoTo(aREG[nI])
	RecLock("SZ8",.F.)
	dbDelete()
	MsUnLock()
	Next nI
Return


//+--------------------------------------------------------------------+
//| Rotina | MntForn | Autor | Anesio - Taggs     | Data | 11.07.2010  |
//+--------------------------------------------------------------------+
//| Descr. | Rotina validar o codigo e nome do fornecedor              |
//+--------------------------------------------------------------------+
//| Uso    | Penapolis 1 Curtume                                       |
//+--------------------------------------------------------------------+
Static Function MntForn( cFornece, cNomeForn )
//	If ExistCpo("SA2",cFornece) .And. ExistChav("SZ8",cCodigo) 
//		cNomeForn := Posicione("SA2",1,xFilial("SA2")+cCodigo,"A2_NOME")
//	Endif
 cNomeForn:= "TESTE ANESIO"
Return(!Empty(cNomeForn))



                                                      
User Function VSS_cTok()
Local aArea := GetArea()
Local lRet  	:= .T.
Local nTotalM2	  := 0
Local nTotalVQ	  := 0     
Local nMediaM2VQ	:= 0 
dbSelectArea("TMP")
dbGotop()
While !Eof()       
		If !U_VS_MntaLok()
			lRet := .F.
			Exit
		EndiF

		If !Empty(TMP->Z8_MQUAD)
			nTotalM2 += TMP->Z8_MQUAD
		EndIf	
		If !Empty(TMP->Z8_QTDCOU)
			nTotalVQ += TMP->Z8_QTDCOU
		EndIf	    
	dbSkip()
EndDo
if nTotalM2 > 0 
	nMediaM2VQ := nTotalM2 / nTotalVQ
endif

nTotalM2		:= Round(nTotalM2,2)
nTotalVQ		:= Round(nTotalVQ,2)
nMediaM2VQ	:= Round(nMediaM2VQ,2)
                  

if nTotalVQ <> SZ8->Z8_QTDDEST
	if !APMsgNoYes("Salvar assim mesmo ?", "Qtde de VQ diferente")
		lRet :=.F.
	endif
endif

if nTotalM2 <> SZ8->Z8_QTDORIG
	if !APMsgNoYes("Salvar assim mesmo ?", "Qtde de M² diferente")
		lRet :=.F.
	endif
endif


		
/*
If lRet
	If nTotalM2 = 0 
		Help(" ",1,"M2 ZERADO")
			lRet	:= .F.
	EndIf	
	If nTotalVQ = 0 
		Help(" ",1,"VAQUETA ZERADO")
			lRet	:= .F.
	EndIf	
EndIf
*/

U_VSS_MntRefresh() //(nTotalM2, nTotalVQ, nMediaM2VQ)
RestArea(aArea)

Return lRet



User Function cTokCF()
Local aArea := GetArea()
Local lRet  	:= .T.
Local cMsg := ""
dbSelectArea("TMP")
dbGotop()
While !Eof()       
/*	if !U_VSS_MntaLokCF()
		lRet := .F.
		Exit
	EndiF */
	If !TMP->Z8_FLAG
		if TMP->Z8_MQUADCF == 0
			lRet := .F.
			cMsg := "Qtde de Metros conferido nao digitado"
		endif
		if TMP->Z8_QTDCOUC == 0
		 	lRet := .F.
		 	cMsg := "Qtde Vaquetas conferidas não informadas"
		endif
		if Substr(TMP->Z8_CLASSE,1,1) == '1'
			if TMP->Z8_QTTPDER <> 0
				lRet := .F.
				cMSg := "Qtde Tipo DEF não deve ser informado para Class.Tipo TR1"
			endif
			if TMP->Z8_QTTPER <> 0
				lRet := .F.
				cMsg := "Qtde Tipo ER não deve ser informado para Class.Tipo TR1"
			endif                                      
			if TMP->Z8_QTTPE <> 0
				lRet := .F.
				cMsg := "Qtde Tipo DEF não deve ser informado para Class.Tipo TR1"
			endif
			if TMP->Z8_QTTPC + TMP->Z8_QTTPD <> TMP->Z8_QTDCOUC
			  lRet := .F.
			  cMsg := "Qtde Conferida diverge da Qtde Classificada"
			endif
		else 	  
			if (TMP->Z8_QTTPC + TMP->Z8_QTTPD + TMP->Z8_QTTPE + TMP->Z8_QTTPDER + TMP->Z8_QTTPER) <> TMP->Z8_QTDCOUC
			  lRet := .F.
			  cMsg := "Qtde Conferida diverge da Qtde Classificada"
			endif
    	endif
	endif
dbSkip()
EndDo
if APmsgNoYes(cMsg, "Continuar assim mesmo? ")
	lRet := .T.
endif
RestArea(aArea)

Return lRet

//+--------------------------------------------------------------------+
//| Rotina | VSS_MntaTblTMP | Autor | Anesio - Taggs    | Data |11.07.2010 |
//+--------------------------------------------------------------------+
//| Descr. | Cria tabela temporária.                                   |
//+--------------------------------------------------------------------+
//| Uso    | Penapolis 1 Curtume                                       |
//+--------------------------------------------------------------------+
User Function MntaTblTMP(aCampos,cArq)

Local cChave 
Local aArea := GetArea()

cChave 	:= "Z8_ITEM"
cArq		:= CriaTrab(aCampos,.t.)

dbUseArea(.t.,,cArq,"TMP",.f.,.f.)

RestArea(aArea)

Return


//+--------------------------------------------------------------------+
//| Rotina | VSS_VS_MntaLok | Autor | Anesio - Taggs       | Data |11.07.2010  |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar a linha de dados.                     |
//+--------------------------------------------------------------------+
//| Uso    | Penapolis 1 Curtume                                       |
//+--------------------------------------------------------------------+
User Function VS_MntaLok()
Local nTotalM2 := 0
Local nTotalVQ := 0
Local nMediaM2VQ := 0
Local aArea    		:= GetArea()
Local lRet  			:= .T.             
 	if !TMP->Z8_FLAG
  	if TMP->Z8_PALETE == ""
  	  lRet := .F.
		 endif
	  if TMP->Z8_MQUAD == 0
    	lRet := .F.
	  endif
  	if TMP->Z8_QTDCOU == 0               
	    lRet := .F.
  	endif
	  if !lRet                                                             
	  	if APmsgNoYes("Falta informações: PALETE, M² e QTDE VAQUETAS","Continuar assim mesmo?")
  			lRet:= .T.
  		else
			Msgbox("Confira as seguintes informações: PALETE, M² e QTDE VAQUETAS")  			
  		endif
	  endif
  endif

dbSelectArea("TMP")
dbgotop()
While !eof()
  nTotalM2 += TMP->Z8_MQUAD
  nTotalVQ += TMP->Z8_QTDCOU
  dbSkip()
enddo         
	if nTotalM2 > 0
		nMediaM2VQ := nTotalM2 / nTotalVQ                                             
	endif                                             

U_VSS_MntRefresh() 
U_VSS_MntExibe()
RestArea(aArea)     

Return lRet



//+--------------------------------------------------------------------+
//| Rotina | VSS_MntaLokCF| Autor | Anesio - Taggs       | Data |11.07.2010  |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar a linha de dados.                     |
//+--------------------------------------------------------------------+
//| Uso    | Penapolis 1 Curtume                                       |
//+--------------------------------------------------------------------+
User Function MntaLokCF()
Local nTotalM2CF := 0
Local nTotalVQCF := 0
Local nMediaM2VQCF := 0 
Local aArea    		:= GetArea()
Local lRet  			:= .T.             
Local cMsg := "cMsg"
 	if !TMP->Z8_FLAG
  	if TMP->Z8_MQUADCF == 0
	    cMsg := "Qtde M² Conferido não pode ser zero"  	
  	  lRet := .F.
		 endif
	  if TMP->Z8_QTDCOUC == 0
	    cMsg := "Qtde Couro Conferido não pode ser zero"  	
    	lRet := .F.
	  endif                  
	  if (TMP->Z8_QTTPDER + TMP->Z8_QTTPER + TMP->Z8_QTTPE + TMP->Z8_QTTPC + TMP->Z8_QTTPD + TMP->Z8_QTTPF) <> TMP->Z8_QTDCOUC 
	    cMsg := "Qtde conferida -> "+cValtoChar(TMP->Z8_QTDCOUC)+ " é diferente da qtde Classificada -> "+;
	    	cValtoChar(TMP->Z8_QTTPDER + TMP->Z8_QTTPER + TMP->Z8_QTTPE + TMP->Z8_QTTPC + TMP->Z8_QTTPD + TMP->Z8_QTTPF)
   		TMP->Z8_PRONTO := "N"
	    lRet := .F.
	  endif
  endif            
	if !lRet 
	   if APMSGNOYES(cMsg ,"Continuar assim mesmo?")
		  lRet := .T.
	   EndIf
	elseif !TMP->Z8_FLAG
		TMP->Z8_PRONTO := "S"
		TMP->Z8_DTCLASS := dDatabase
	endif


dbSelectArea("TMP")
dbgotop()
While !eof()
  nTotalM2CF += TMP->Z8_MQUAD
  nTotalVQCF += TMP->Z8_QTDCOU
  dbSkip()
enddo         
	if nTotalM2CF > 0
		nMediaM2VQCF := nTotalM2CF / nTotalVQCF 
	endif                                             

U_MntRefCf() 
U_MntExbCF()
RestArea(aArea)     

Return lRet





user Function VSS_MntExibe() 
Local aArea := GetArea()
Local nReg
nTotalM2   := 0
nTotalVQ   := 0
nMediaM2VQ := 0
	
dbSelectArea("TMP")
nReg := Recno()
dbGoTop()
While !Eof()
	If !TMP->Z8_FLAG
		nTotalM2 += TMP->Z8_MQUAD
		nTotalVQ += TMP->Z8_QTDCOU
	endif	
	dbSkip()
EndDo	
dbGoto(nReg)

if nTotalVQ > 0
  nMediaM2VQ := nTotalM2 / nTotalVQ
endif                  
U_VSS_MntRefresh() //(nTotalM2, nTotalVQ, nMediaM2VQ)

RestArea(aArea)

Return .T.
     
User Function VSS_MntRefresh() //(nTotalM2, nTotalVQ, nMediaM2VQ)
oTotalM2:Refresh()
oTotalVQ:Refresh()
oMediaM2VQ:Refresh()

If nTotalM2 == 0
	oTotalM2:Hide()
	oTotalVQ:Hide()
	oMediaM2VQ:Hide()
Else
	oTotalM2:Show()
	oTotalVQ:Show()
	oMediaM2VQ:Show()      
EndIf
Return




user Function MntExbCF() 
Local aArea := GetArea()
Local nReg
nTotalM2CF   := 0
nTotalVQCF   := 0
nMediaM2VQCF := 0
	
dbSelectArea("TMP")
nReg := Recno()
dbGoTop()
While !Eof()
	If !TMP->Z8_FLAG
		nTotalM2CF += TMP->Z8_MQUADCF
		nTotalVQCF += TMP->Z8_QTDCOUC
	endif	
	dbSkip()
EndDo	
dbGoto(nReg)

if nTotalVQCF > 0
  nMediaM2VQCF := nTotalM2CF / nTotalVQCF
endif                  
U_MntRefCF() 

RestArea(aArea)

Return .T.
     
User Function MntRefCF() 
oTotalM2CF:Refresh()
oTotalVQCF:Refresh()
oMediaM2VQCF:Refresh()

If nTotalM2CF == 0
	oTotalM2CF:Hide()
	oTotalVQCF:Hide()
	oMediaM2VQCF:Hide()
Else

	oTotalM2CF:Show()
	oTotalVQCF:Show()
	oMediaM2VQCF:Show()      

EndIf
Return


User Function MntaDel()
Local aArea := GetArea()
Local nReg
Local nTotalM2 := 0
Local nTotalVQ := 0
Local nMediaM2VQ := 0
dbSelectArea("TMP")
dbgotop()
While !eof()
	if !TMP->Z8_FLAG
	  nTotalM2 += TMP->Z8_MQUAD
	  nTotalVQ += TMP->Z8_QTDCOU
	endif
  dbSkip()
enddo         
	if nTotalM2 > 0
		nMediaM2VQ := nTotalM2 / nTotalVQ
	endif
U_VSS_MntRefresh() //(nTotalM2, nTotalVQ, nMediaM2VQ)
U_VSS_MntExibe()
RestArea(aArea)

Return .T.

User Function MntDelCF()
Local aArea := GetArea()
Local nReg
Local nTotalM2CF := 0
Local nTotalVQCF := 0
Local nMediaM2VQCF := 0
dbSelectArea("TMP")
dbgotop()
While !eof()
	if !TMP->Z8_FLAG
	  nTotalM2CF += TMP->Z8_MQUAD
	  nTotalVQCF += TMP->Z8_QTDCOU
	endif
  dbSkip()
enddo         
	if nTotalM2CF > 0
		nMediaM2VQCF := nTotalM2CF / nTotalVQCF
	endif
U_MntRefCF() //(nTotalM2, nTotalVQ, nMediaM2VQ)
U_MntExbCF()
RestArea(aArea)
Return .T.