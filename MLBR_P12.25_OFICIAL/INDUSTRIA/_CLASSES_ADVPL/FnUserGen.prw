#INCLUDE "TOTVS.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "Ap5Mail.ch"
	
#define __Debug .T.

Static __RetM0Emp := "" //Variavel utilizada para retorno da consulta SM0
Static __RetM0Fil := "" //Variavel utilizada para retorno da consulta SM0

User Function GrvSx1(cGrpPerg, cOrd, cPergunta, cTipo, nTam, nDecimal, cPict, cObj, cValid, aCbox, cF3, cGrupo, aHelp)
Local aArea := GetArea()

Local lAchou := .F.
Local cAux   := ""

Local cVar   := ""
Local cPar   := ""
Local nI     := 0

Default cOrd  := ""
Default cTipo := "C"
Default cObj  := "G"
Default cValid := ""
Default aCbox  := {}
                   
cGrpPerg := PadR(cGrpPerg, Len(SX1->X1_GRUPO) )

DbSelectArea("SX1")
DbSetOrder(1)

If Empty(cOrd)
	
	While SX1->(!Eof()) .And. SX1->X1_GRUPO == cGrpPerg
		cAux := SX1->X1_ORDEM
	EndDo
	
	cOrd := StrZero(Val(cAux) + 1,2)
EndIf

lAchou := DbSeek(cGrpPerg+cOrd)

cVar := RetParSX1("MV_CH", cOrd, 1, .T.)
cPar := RetParSX1("MV_PAR", cOrd, 2)

RecLock("SX1", !lAchou)
SX1->X1_GRUPO    := cGrpPerg
SX1->X1_ORDEM    := cOrd
SX1->X1_PERGUNT  := cPergunta
SX1->X1_PERSPA   := cPergunta
SX1->X1_PERENG   := cPergunta
SX1->X1_VARIAVL  := cVar      //MV_CH1

SX1->X1_TIPO     := cTipo
SX1->X1_TAMANHO  := nTam
SX1->X1_DECIMAL  := nDecimal
SX1->X1_PRESEL   := 0//IIF(Len(aCbox) > 0, 1, 0) //Pré selecionado
SX1->X1_GSC      := cObj

SX1->X1_VALID    := cValid //Valid
SX1->X1_VAR01    := cPar

For nI := 1 To Len(aCbox)
	&("SX1->X1_DEF0"+AllTrim(Str(nI)))   := aCbox[nI]
	&("SX1->X1_DEFSPA"+AllTrim(Str(nI))) := aCbox[nI]
	&("SX1->X1_DEFENG"+AllTrim(Str(nI))) := aCbox[nI]
	&("SX1->X1_CNT0"+AllTrim(Str(nI)))   := ""
Next

SX1->X1_F3       := cF3
SX1->X1_PYME     := "N"
SX1->X1_GRPSXG   := cGrupo
SX1->X1_PICTURE  := cPict
MsUnLock()

PutSX1Help("P."+AllTrim(RetParSX1(AllTrim(cGrpPerg), cOrd, 2)) +".",aHelp,aHelp,aHelp)

RestArea(aArea)
Return()

User Function GrvSx1Ref(cGrpPerg, cOrd, cPergunta, cCpoRef, cValid, cF3, aHelp, aCbox)
Local aArea := GetArea()

Default cValid := ""
Default cF3    := ""
Default aCbox  := {}

DbSelectArea("SX3")
DbSetOrder(2)

If DbSeek(cCpoRef)
	
	cTipo    := SX3->X3_TIPO //Tipo
	nTam     := SX3->X3_TAMANHO //Tamanho
	nDecimal := SX3->X3_DECIMAL //Decimal
	cPict    := SX3->X3_PICTURE
	cObj     := IIF(Empty(aCbox),"G","C")
	cF3      := IIF(Empty(cF3),SX3->X3_F3,cF3)
	cGrupo   := SX3->X3_GRPSXG
Else
	ConOut("FnUserGen - Campo ["+cCpoRef+"] não encontrado")
EndIF

u_GrvSx1(cGrpPerg, cOrd, cPergunta, cTipo, nTam, nDecimal, cPict, cObj, cValid, aCbox, cF3, cGrupo, aHelp)

RestArea(aArea)
Return()

Static Function RetParSX1(cPrefix, cOrd, nCasas,lAlpha)
Local cAux := ""
Local aAux := {"A","B","C","D","E","F","G","H","I","J","L","M","N","O","P","Q","R","S","T","U","V","X","Z"}

Default lAlpha := .F.
Default nCasas := 1

If !IsDigit(cOrd)
	cAux := cOrd
ElseIf lAlpha .And. Val(cOrd) > 9
	cAux := aAux[Val(cOrd) - 9]
Else
	cAux := StrZero(Val(cOrd),nCasas)
EndIF

Return(cPrefix+cAux)

User Function vFindKey(cAlias, nInd, cKey, aObjRet)

Local aArea := GetArea()
Local nI    := 0
Local lRet  := .F.

DbSelectArea(cAlias)
DbSetOrder(nInd)

If lRet := DbSeek(cKey)
	For nI := 1 To Len(aObjRet)
		&(aObjRet[nI,1]) := &(cAlias+"->"+aObjRet[nI, 2])
	Next
EndIf

RestArea(aArea)
Return(lRet)

User Function Exists(aVet)
Local aArea := GetArea()
Local lRet  := .T.
Local nI    := 0

//aVet := {{cTipo, cNome}}

For nI := 1 to Len(aVet)
	If lRet
		If     aVet[nI, 1] == "T"
			DbSelectArea("SX2")
			DbSetOrder(1) //X2_CHAVE
			lRet := DbSeek(aVet[nI, 2])
		ElseIf aVet[nI, 1] == "C"                
		    //Abre Area 
		    If lRet := u_Exists({{"T", u_RPrefCpo(aVet[nI, 2], .T.)}})
			    DbSelectArea(u_RPrefCpo(aVet[nI, 2], .T.))
			    
				DbSelectArea("SX3")
				DbSetOrder(2) //X3_CAMPO
				lRet := DbSeek(aVet[nI, 2]) .And. &(u_RPrefCpo(aVet[nI, 2], .T.)+"->(FieldPos('"+aVet[nI, 2]+"'))") > 0
			EndIf
		EndIf
	EndIf
Next


RestArea(aArea)
Return(lRet)
  
User Function RPrefCpo(cCampo, lOnlyPref, lSql)
Local cPrefixo := ""

Default lSql      := .F.
Default lOnlyPref := .F.

cPrefixo := PADL(SubStr(cCampo, 1, aT("_",cCampo)-1), 3, "S")

If !lOnlyPref
	cPrefixo += IIF(lSql, ".","->") + cCampo
EndIf

Return(cPrefixo)

User Function MntHeader(aCampos, aHeader)
	Local nForCampos := 0
	Local oHash      := Nil
	Local cCampo     := ""
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	
	For nForCampos := 1 To Len(aCampos)
	 If ValType(aCampos[nForCampos]) == "C"
	 	cCampo := aCampos[nForCampos]
	 	oHash := THash():New()
	 Else
	 	cCampo := aCampos[nForCampos, 1]
	 	oHash:Load(aCampos[nForCampos, 2]:GetEntry())
	 EndIf	
	 
	 If AllTrim(cCampo) <> "IDMARC"	
	 	
	 	SX3->(DbSeek(cCampo))
	 	
	 	oHash:addUnless("X3_TITULO" , TRIM(X3Titulo()))
		 oHash:addUnless("X3_CAMPO"  , SX3->X3_CAMPO   )
   oHash:addUnless("X3_PICTURE", SX3->X3_PICTURE )
   oHash:addUnless("X3_TAMANHO", SX3->X3_TAMANHO )
   oHash:addUnless("X3_DECIMAL", SX3->X3_DECIMAL )
   oHash:addUnless("X3_VALID"  , SX3->X3_VALID   )
   oHash:addUnless("X3_USADO"  , SX3->X3_USADO   )
   oHash:addUnless("X3_TIPO"   , SX3->X3_TIPO    )
   oHash:addUnless("X3_F3"     , SX3->X3_F3      )
   oHash:addUnless("X3_CONTEXT", SX3->X3_CONTEXT )
   oHash:addUnless("X3_CBOX"   , SX3->X3_CBOX    )
   oHash:addUnless("X3_RELACAO", SX3->X3_RELACAO )
   oHash:addUnless("X3_WHEN"   , SX3->X3_WHEN    )
   oHash:addUnless("X3_VISUAL" , SX3->X3_VISUAL  )
   oHash:addUnless("X3_VLDUSER", SX3->X3_VLDUSER )
   oHash:addUnless("X3_PICTVAR", SX3->X3_PICTVAR )
   oHash:addUnless("X3_OBRIGAT", X3Obrigat(SX3->X3_CAMPO))
   
   oHash:varialize()
		  
			aAdd(aHeader, { H_X3_TITULO, ;
							H_X3_CAMPO   	, ;
							H_X3_PICTURE 	, ;
							H_X3_TAMANHO 	, ;
							H_X3_DECIMAL 	, ;
							H_X3_VALID   	, ;
							H_X3_USADO   	, ;
							H_X3_TIPO    	, ;
							H_X3_F3      	, ;
							H_X3_CONTEXT 	, ;
							H_X3_CBOX    	, ;
							H_X3_RELACAO 	, ;
							H_X3_WHEN    	, ;
							H_X3_VISUAL  	, ;
							H_X3_VLDUSER 	, ;
							H_X3_PICTVAR 	, ;
							H_X3_OBRIGAT})
		Else
			aAdd(aHeader, { " ", aCampos[nForCampos], "@BMP", 1, 0, .F., "", "C", "", "V", "", "", "", "V", "", "", ""})
		Endif                                                               
		
	Next nForCampos	
Return(aHeader)

User Function GrvSx3Ref(cCampo,oHash)
	DbSelectArea("SX3")
	DbSetOrder(2) 
	
	If DbSeek(cCampo)
		oHash:addUnless("X3_TIPO"   , SX3->X3_TIPO)
		oHash:addUnless("X3_TAMANHO", SX3->X3_TAMANHO)
		oHash:addUnless("X3_DECIMAL", SX3->X3_DECIMAL)          
		//oHash:addUnless("X3_ORDEM"  , SX3->X3_ORDEM)		
		oHash:addUnless("X3_TITULO" , SX3->X3_TITULO)
		oHash:addUnless("X3_DESCRIC", SX3->X3_DESCRIC)
		oHash:addUnless("X3_PICTURE", SX3->X3_PICTURE)
		oHash:addUnless("X3_BROWSE" , SX3->X3_BROWSE)
		oHash:addUnless("X3_CBOX"   , SX3->X3_CBOX)
		oHash:addUnless("X3_GRPSXG" , SX3->X3_GRPSXG)
		
		u_GrvSx3(oHash)                               
		//oHash:addUnless("X3_ARQUIVO", SX3->X3_ARQUIVO)		
		//oHash:addUnless("X3_CAMPO"  , SX3->X3_CAMPO)		
		//oHash:addUnless("X3_VALID"  , SX3->X3_VALID    )
		//oHash:addUnless("X3_RELACAO", SX3->X3_RELACAO)
		//oHash:addUnless("X3_F3 ", SX3->X3_F3)       
		//oHash:addUnless("X3_VISUAL", SX3->X3_VISUAL)
		//oHash:addUnless("X3_CONTEXT", SX3->X3_CONTEXT  )
		//oHash:addUnless("X3_OBRIGAT", SX3->X3_OBRIGAT  )
		//oHash:addUnless("X3_VLDUSER", SX3->X3_VLDUSER  )		
		//oHash:addUnless("X3_WHEN"//, SX3->X3_WHEN     )
		//oHash:addUnless("X3_INIBRW"//, SX3->X3_INIBRW   )
		//oHash:addUnless("X3_FOLDER"//, SX3->X3_FOLDER   )			
	EndIf
	
Return(NIL)


User Function GrvSx3(oHash, aHelp)
	
	Local aVet   := oHash:Exists("X3_ARQUIVO/X3_CAMPO/X3_TIPO/X3_TAMANHO/X3_TITULO/X3_DESCRIC/X3_PICTURE/X3_CONTEXT")
	Local lAchou := .F.     
	Local cPref  := ""
	
	Default aHelp := {}
			 
	If !Empty(aVet)
		ConOut("Erro: FNUserGen:GrvSx3 - Falta chaves principais ")
		Return(NIL)
	EndIf
	
	//Definindo valores defaults para campo
	oHash:addUnless("X3_ORDEM"   , Sx3UltOrd(oHash:getObj("X3_ARQUIVO"))) 
	oHash:addUnless("X3_DECIMAL" , 0)
	oHash:addUnless("X3_VALID"   , "")
	oHash:addUnless("X3_RELACAO" , "")
	oHash:addUnless("X3_F3"      , "")
	oHash:addUnless("X3_BROWSE"  , "S")
	oHash:addUnless("X3_VISUAL"  , "A")
	oHash:addUnless("X3_OBRIGAT" , "N")
	oHash:addUnless("X3_VLDUSER" , "")
	oHash:addUnless("X3_CBOX"    , "")
	oHash:addUnless("X3_WHEN"    , "")
	oHash:addUnless("X3_INIBRW"  , "")
	oHash:addUnless("X3_GRPSXG"  , "")
	oHash:addUnless("X3_FOLDER"  , "")   
	oHash:addUnless("X3_USADO"   , "ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá")   
	oHash:addUnless("X3_RESERV"  , "âÇ")   
	oHash:addUnless("X3_PYME"    , "N")
	oHash:addUnless("X3_IDXSRV"  , "N") 
	oHash:addUnless("X3_ORTOGRA" , "N")  
	oHash:addUnless("X3_IDXFLD"  , "N")
	oHash:addUnless("X3_PROPRI"  , "U")
	oHash:addUnless("X3_NIVEL"   , 1)
	
	//Testando campo PrefixoCpo
	cPref := PrefixoCpo(oHash:GetObj("X3_ARQUIVO")) + "_"
	If !(cPref $ oHash:GetObj("X3_CAMPO"))
		oHash:put("X3_CAMPO", cPref + AllTrim(oHash:GetObj("X3_CAMPO")))
	EndIf
			      
	oHash:varialize()
                               
    DbSelectArea("SX3")
    DbSetOrder(2)
    lAchou := DbSeek(H_X3_CAMPO)
                   
	RecLock("SX3",!lAchou)
		SX3->X3_ARQUIVO := H_X3_ARQUIVO
		SX3->X3_ORDEM   := H_X3_ORDEM //		
		SX3->X3_CAMPO   := H_X3_CAMPO  
		SX3->X3_TIPO    := H_X3_TIPO
		SX3->X3_TAMANHO := H_X3_TAMANHO      		
		SX3->X3_DECIMAL := H_X3_DECIMAL //		
		SX3->X3_TITULO  := H_X3_TITULO
		SX3->X3_DESCRIC := H_X3_DESCRIC
		SX3->X3_PICTURE := H_X3_PICTURE 		
		SX3->X3_VALID   := H_X3_VALID  //
		SX3->X3_USADO   := H_X3_USADO
		SX3->X3_RELACAO := H_X3_RELACAO //
		SX3->X3_F3      := H_X3_F3 //
		SX3->X3_NIVEL   := H_X3_NIVEL
		SX3->X3_RESERV  := H_X3_RESERV
		SX3->X3_PROPRI  := H_X3_PROPRI 
		SX3->X3_BROWSE  := H_X3_BROWSE //
		SX3->X3_VISUAL  := H_X3_VISUAL  //
		SX3->X3_CONTEXT := H_X3_CONTEXT  
		SX3->X3_OBRIGAT := IIF(H_X3_OBRIGAT == "S", "€", "")//
		SX3->X3_VLDUSER := H_X3_VLDUSER //
		SX3->X3_CBOX    := H_X3_CBOX   //
		SX3->X3_WHEN    := H_X3_WHEN    //
		SX3->X3_INIBRW  := H_X3_INIBRW  //
		SX3->X3_GRPSXG  := H_X3_GRPSXG // 
		SX3->X3_FOLDER  := H_X3_FOLDER   //
		SX3->X3_PYME    := H_X3_PYME
		//SX3->X3_IDXSRV  := H_X3_IDXSRV
		//SX3->X3_ORTOGRA := H_X3_ORTOGRA
		//SX3->X3_IDXFLD  := H_X3_IDXFLD
    MsUnLock()
    
    If !Empty(aHelp)                           	
		PutHelp(H_X3_CAMPO,aHelp,aHelp,aHelp,.T.)
	EndIf

Return(Nil) 
 
Static Function Sx3UltOrd(cAlias)
	Local cOrdem := "00"
	
	DbSelectArea("SX3")
	DbSetOrder(1)
	
	If DbSeek(cAlias)
		While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAlias
			cOrdem := SX3->X3_ORDEM 	
			SX3->(DbSkip())	
        EndDo
    EndIF
    
Return(Soma1(cOrdem))
 
User Function GrvSix(cAlias, cIndice, cChave, cNick)
	Local aArea  := GetArea() 
	Local aIndice := {}, oHmInd := THash():New()
	Local nI := 0
	Local cPref := ""                        
	Local cCampo := ""
	                           
	Default cIndice := ""    
	Default cNick := ""
	
	If Empty(cIndice)
		cIndice := GetIndSIX(cAlias)	
	EndIf 
	             
	For nI := 1 To Len(aIndice := StrTokArr(cChave, "+"))
		//Testando campo PrefixoCpo
		cPref := PrefixoCpo(cAlias) + "_"
		cCampo := aIndice[nI]
		If !(cPref $ cCampo)
			cCampo := cPref + cCampo
		EndIf
		oHmInd:put(nI, cCampo)
	Next                     
	cChave := oHmInd:Join("+")
		
	DbSelectArea("SIX")
	DbSetOrder(1)
	
	If !DbSeek(cAlias+cIndice)
		RecLock("SIX",.T.)
			SIX->INDICE    := cAlias
			SIX->ORDEM     := cIndice				
			SIX->CHAVE     := cChave 
			SIX->DESCRICAO := RetTitSix(cChave)
			SIX->DESCSPA   := SIX->DESCRICAO
			SIX->DESCENG   := SIX->DESCRICAO		
			SIX->PROPRI    := "U"
			SIX->SHOWPESQ  := "S"	
			SIX->NICKNAME  := cNick
		MsUnLock()
    EndIf
    
	RestArea(aArea) 
Return(NIL)  

Static Function GetIndSIX(cAlias)
	Local cRet := "0"
	DbSelectArea("SIX")
	DbSetOrder(1)
	
	SIX->(DbSeek(cAlias))
	
	While SIX->(!Eof()) .And. SIX->INDICE == cAlias
		cRet := SIX->ORDEM
		SIX->(DbSkip())
	EndDo
	
Return(Soma1(cRet))                 

Static Function RetTitSix(cChave)
	Local aCpos := SepCampos(cChave,"+")
	Local nI    := 1
	Local cRet  := ""
	
	For nI := 1 To Len(aCpos)       
		If !("FILIAL" $ aCpos[nI])
			cRet += IIF(Empty(cRet),""," + ")+RetTitle(aCpos[nI])	
		EndIf
    Next

Return(cRet)
 
 
Static Function SepCampos(cLinha,cSep1)

	Local nPos, aDadosLin := {}
	
	Default cSep1 := "/"

	cLinha := alltrim(cLinha)

	while len(alltrim(cLinha)) <> 0
		nPos := at(cSep1,cLinha)  // Posicao do separador1
		if nPos<>0  // Nao e´ ultimo campo
			aadd(aDadosLin,alltrim(substr(cLinha,1,nPos-1)))
		else // ultimo campo
			aadd(aDadosLin,alltrim(cLinha))
			exit
		endIf
		cLinha := substr(cLinha,nPos+1,len(cLinha)-nPos)
	end
Return(aDadosLin)


User Function GrvSx2(oHash)
	Local aVet   := oHash:Exists("X2_CHAVE/X2_NOME")
	Local lAchou := .F.
			 
	If !Empty(aVet)
		ConOut("Erro: FNUserGen:GrvSx2 - Falta chaves principais ")
		Return(NIL)
	EndIf
	
	//Definindo valores defaults para campo
	oHash:addUnless("X2_ARQUIVO" ,oHash:getObj("X2_CHAVE") + SM0->M0_CODIGO + "0")
	oHash:addUnless("X2_NOMESPA" ,oHash:getObj("X2_NOME"))
	oHash:addUnless("X2_NOMEENG" ,oHash:getObj("X2_NOME"))
	oHash:addUnless("X2_MODO"    , "C")

	DbSelectArea("SX2")
 DbSetOrder(1)
    
 lAchou := DbSeek(oHash:getObj("X2_CHAVE") )
    
 RecLock("SX2", !lAchou)
		SX2->X2_CHAVE    := oHash:getObj("X2_CHAVE")
		SX2->X2_ARQUIVO  := oHash:getObj("X2_ARQUIVO")
		SX2->X2_NOME     := oHash:getObj("X2_NOME")
		SX2->X2_NOMESPA  := oHash:getObj("X2_NOMESPA")
		SX2->X2_NOMEENG  := oHash:getObj("X2_NOMEENG")
		SX2->X2_MODO     := oHash:getObj("X2_MODO")
	MsUnLock()	

Return(Nil)



User Function UpdTable(cAlias)
	Local aArea := GetArea()
	
	If Select(cAlias) > 0
		dbSelectArea(cAlias)
		dbCloseArea()					
	EndIf	            

	X31UpdTable(cAlias)

	If __GetX31Error()
		Alert(__GetX31Trace())
		Aviso("Aviso!","Ocorreu um erro durante a atualizacao da tabela : "+ cAlias + ". Verifique a integridade do dicionario e da tabela.",{"OK"})
	EndIf
	dbSelectArea(cAlias)	

    RestArea(aArea)       
Return(.T.)

User Function VDuplLin(nLinPesq, aCPesq, aPosicoes, lMsg, lDel)
Local lRet  := .T.
Local nPos  := 0
Local cCond := ""

Default lMsg := .T. // Identifica se a funcao exibira ou nao as mensagens de erro, caso haja.
Default lDel := .F. // Identifica se os registros deletados serão desconsiderados na validação de registros duplicados.

For nPos := 1 to len(aPosicoes)
	cCond += IIf(nPos == 1, "", " .And. ")
	cCond += "aVet[" + Alltrim(Str(aPosicoes[nPos])) + "] == aCPesq[" + AllTrim(Str(nLinPesq)) + ", " + AllTrim(Str(aPosicoes[nPos])) + "]"
Next nPos

If lDel .And. !Empty(cCond)
 cCond += " .And. aVet[" + Alltrim(Str(len(aCPesq[1]))) + "] == .F."
EndIf 

nPos := 0
nPos := ScanVet(ACPesq, cCond, @nPos)
If nPos <> nLinPesq
	lRet := .F.
ElseIf nPos <> len(aCPesq)
	nPos := ScanVet(aCPesq, cCond, @nPos)
	If nPos <> 0
		lRet := .F.
	Endif
Endif

If !lRet .and. lMsg
	Aviso("Atenção", "Verificar ocorrëncia de duplicidade", {"OK"})
Endif

Return(lRet)

Static Function ScanVet(aCPesq, cCond, nPos)
 Private cBusca := "{| aVet |" + cCond + "}"
 nPos := aScan(aCPesq, &cBusca, nPos+1 )
Return(nPos)

User Function GrvSx6(oHash, lMsg)
	//nome/tipo/descricao/conteudo
	Local aVet   := oHash:Exists("nome/tipo/descricao")
	Local lAchou := .F.
    Local nLMarg := 20 
    
	Local oDlg   := nil
	Local cConteudo := "" 
	Local nOpcDlg := 1        
	Local oConteudo := Nil
	Local cConteudo := ""   
	
	Default lMsg := .F.
			 
	If !Empty(aVet)
		ConOut("Erro: FNUserGen:GrvSx6 - Falta chaves principais ")
		Return(NIL)
	EndIf

	oHash:addUnless("conteudo", "")
			
	oHash:varialize()
	                   	
	cConteudo := H_conteudo
	
	If lMsg                    	
		DEFINE MSDIALOG oDlg TITLE OemToAnsi("Ajuste Parâmetro") From 0,0 TO 100,500 Of oMainWnd PIXEL
	
		  @ 017, nLMarg + 005 SAY OemtoAnsi("Parâmetro : "+H_nome) OF oDlg PIXEL COLOR CLR_BLUE
		  @ 024, nLMarg + 005 SAY OemtoAnsi("Tipo : "+H_tipo) OF oDlg PIXEL COLOR CLR_BLUE
		  @ 031, nLMarg + 005 SAY OemtoAnsi("Descrição : "+H_descricao) OF oDlg PIXEL COLOR CLR_BLUE
	
		  @ 040, nLMarg + 005 SAY OemtoAnsi("Conteúdo : ") OF oDlg PIXEL COLOR CLR_BLUE	  
		  @ 038, nLMarg + 040 MSGET oConteudo VAR cConteudo SIZE 80,04  OF oDlg PIXEL COLOR CLR_BLUE
		  	 			  
		ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar (oDlg, {|| nOpcDlg := 1, IIF(VldOkSx6(cConteudo), oDlg:End(), nOpcDlg := 0)}, ;
		   														    {|| nOpcDlg := 0, oDlg:End()})      
	EndIf
	
	If nOpcDlg == 1
		
		DbSelectArea("SX6")
		SX6->(DbSetOrder(1))
		
		lAchou := SX6->(DbSeek("  " + H_nome))
				
		//Grava Parâmetro 
		RecLock("SX6", !lAchou)
			SX6->X6_FIL      := "  "
			SX6->X6_VAR      := H_nome    
			SX6->X6_TIPO     := H_tipo
			SX6->X6_DESCRIC  := SubStr(H_descricao, 1, Len(X6_DESCRIC))
			SX6->X6_DESC1    := SubStr(H_descricao, Len(X6_DESCRIC) + 1, Len(X6_DESCRIC))
			SX6->X6_DESC2    := SubStr(H_descricao, Len(X6_DESCRIC) * 2 + 1, Len(X6_DESCRIC))
			SX6->X6_CONTEUD  := cConteudo
			SX6->X6_PROPRI   := "U"
			SX6->X6_PYME	 := "N"
		MsUnLock()	
	EndIf                      

Return(NIL)

Static Function VldOkSx6(cConteudo)
	Local lRet := .T. 

	If Empty(cConteudo)
		lRet := Aviso("Validação Ajuste Parâmetro", "O conteúdo do parâmetro está vazio, deseja continuar?",{"Não", "Sim"}) == 2
	EndIf

Return(lRet)

User Function ExibeMemo(cCampo, nInd, cChave, lExbTela, nTam, lReadOnly, cConteudo)
	Local aArea := getArea()
	Local oDlgMsg, oTexto, oBtnOk, cRet := ""
	Local aStruct  := HS_CfgSx3(cCampo)                                   
	Local cAlias := u_RPrefCpo(cCampo, .T.)//Substr(cCampo,1,3)
	Local nCont := 0    
	Local cMemo := ""  
	Local lOk   := .F.
	Local cRetOld := ""        
	 
	Default lExbTela := .T.
	Default nTam := 80                                           
	Default lReadOnly := .F.
	
	
	If Empty(cConteudo)                       
		cMemo := POSICIONE(cAlias,nInd,cChave,cCampo)       
		 			
		If !Empty(cMemo)
			For nCont := 1 to MLCount(cMemo, nTam)
				cRet += MemoLine(cMemo, nTam, nCont)+chr(13)+chr(10)
			Next
		EndIf   
	Else
		cRet := cConteudo	                                            		
	EndIf                                                               
	
	cRetOld := cRet 
	 
	If lExbTela 
		DEFINE MSDIALOG oDlgMsg FROM	62,100 TO 211,400 TITLE OemToAnsi(aStruct[SX3->(FieldPos("X3_TITULO"))]) PIXEL
			
			If lReadOnly                                                                
				@ 001, 001 GET oTexto VAR cRet MEMO READONLY SIZE 150, 060 OF oDlgMsg PIXEL
            Else
				@ 001, 001 GET oTexto VAR cRet MEMO SIZE 150, 060 OF oDlgMsg PIXEL            
            EndIf                
                      //TButton():New(nRow, nCol, [ cCaption], [ oWnd], [ bAction]                    , nWidth, nHeight, [ uParam8], [ oFont], [ uParam10], [ lPixel], [ uParam12], [ uParam13], [ uParam14], [ bWhen], [ uParam16], [ uParam17] ) --> oObjeto
			oBtnOk := tButton():New(062 , 002 , "Ok"       , oDlgMsg, {|| lOk := .T., oDlgMsg:End()},   50,        ,,,,.T.)
			oBtnOk:SetFocus()
			
			oBtnCancel := tButton():New(062, 062, "Cancela", oDlgMsg, {|| oDlgMsg:End()},50,,,,,.T.)
						                                                                             
			ACTIVATE MSDIALOG oDlgMsg CENTERED ON INIT EnchoiceBar (oDlgMsg, {|| oDlgMsg:End()}, {|| oDlgMsg:End()})
			
			If !lOk
				cRet := cRetOld			
			EndIf
			
	EndIf
 
	RestArea(aArea)
Return(cRet)

User Function TrocaStr(cCond, aParams)
	Local cRet := ""
	Local nPos := 0
	Local nParam := 1
	         
	cRet := cCond
	
	While (nPos := aT("?",cRet)) > 0
	   cRet := Stuff(cRet, nPos, 1, aParams[nParam++])	
	EndDo
Return(cRet)

User Function ConvData(cData, cFormat)
	Local cAno := "", cMes := "", cDia := ""                    
	Local dData := CtoD("")

	cFormat := UPPER(cFormat)

	If "YYYY" $ cFormat .And. "MM" $ cFormat .And. "DD" $ cFormat
		cAno := SubStr(cData,At("YYYY",cFormat), 4)
		cMes := SubStr(cData,At("MM",cFormat), 2)	
		cDia := SubStr(cData,At("DD",cFormat), 2)	
		
		dData := StoD(cAno + cMes + cDia)	
	EndIf
	
Return(dData)

User Function GeraHtml(cPath, oHash)
	Local cHtml := ""
	Local aArq := {}
	Local nI := 0, nVLin := 0,  nVCol := 0
	Local cPar := "", cConteudo := ""     
	Local aVet := {}
	
	If File(cPath)
		aArq := LeArq(cPath)
	Else
		Aviso("Erro Geração HTML", u_TrocaStr("O arquivo modelo ? não foi encontrado.", {cPath}), {"OK"})
		Return(cHtml)				
	EndIf
	
	For nI := 1 To Len(aArq)		
		While !Empty(cPar := AllTrim(GetHtmPar(aArq[nI])))		
			If UPPER(SubStr(cPar, 1, 3)) <> "TBL"
				cConteudo := oHash:GetObj(cPar)
			Else                   
				aVet := oHash:GetObj(cPar) 
				cConteudo := ""
				For nVLin := 1 To Len(aVet)
					If nVLin % 2 == 0					
						cConteudo += " <tr class='even'> "
					Else
						cConteudo += " <tr class='odd'> "					
					EndIf
					
					For nVCol := 1 To Len(aVet[nVLin])
						cConteudo += u_TrocaStr("<td> ? </td>",{aVet[nVLin, nVCol]})				
                    Next 							
					cConteudo += " </tr> "								
				Next
			EndIf
			aArq[nI] := SetHtmPar(aArq[nI], cPar, cConteudo)
		EndDo 
		cHtml += aArq[nI]
	Next
	
Return(cHtml)    

Static Function SetHtmPar(cLinha, cPar, cConteudo)
	Local nPos := at("?"+cPar, cLinha)
	Local nTam := Len("?"+cPar)
Return(Stuff(cLinha, nPos, nTam, cConteudo))

Static Function GetHtmPar(cLinha)
	Local cRet := ""
	Local cAux := "" 
	Local nPos := 0
	
	If (nPos := aT("?",cLinha)) >  0 
		If ((SubStr(cLinha, nPos + 1, 1) > "a" .And. SubStr(cLinha, nPos + 1, 1) < "z") .Or. (SubStr(cLinha, nPos + 1, 1) > "A" .And. SubStr(cLinha, nPos + 1, 1) < "Z")) 
			cAux := SubStr(cLinha, nPos + 1)   
			cRet := cAux
			If At(" ", cAux) > 0                                                                                                                            
				cRet := SubStr(cAux, 1, At(" ", cAux))
			EndIf				
		Else
			cRet := GetHtmPar(SubStr(cLinha, nPos + 1))
		EndIf		
	EndIf
Return(cRet)

Static Function LeArq(cPath, lString)
	Local aArq := {}, cArq := ""
	Local cLinha := ""       
	
	Default lString := .F.
		                  
	FT_FUse( cPath ) //Abre Arquivo
	
	FT_FGoTop()
	            
	While !FT_FEof()   
		cLinha := FT_FReadLn()  
		cArq += cLinha
		aAdd(aArq, cLinha)
		
		FT_FSkip() 		 
    End
    
    FT_FUse()       									
Return(IIF(lString, cArq, aArq))
    

User Function SendMail(cEmailTo, cEmailCc, cEmailBcc, cAssunto, cMensagem, cAnexos, cAccount, cPassword, cServer, cFrom, cPort, lParWf, cUser)

	Local aAnexos   := {}
	Local cMailBox   := ""
	Local cAutUser   := ""
	Local cAutSenha  := ""
	Local lRet       := .T.
	Local lSmtpAuth  := GetMv("MV_RELAUTH",,.F.)
	Local nI         := 0
	       
	Default cEmailCc  := "" 
	Default cEmailBcc := ""
	Default cAnexos   := ""
	Default	cAccount  := "" 
	Default	cUser     := ""
	Default cPassword := ""
	Default	cServer   := "mail.rioquimica.com.br"	
	Default cPort     := 587
	Default lParWf    := .T.
              
	If __Debug
   ConOut("<DEBUG DATA='" + DToS(dDataBase) + "', HORA='"+ Time() + "'>  ") 
	EndIf		
	
	//cAccount  := Lower( AllTrim( Iif( Empty(cAccount), Iif ( !Empty( cAutUser ), cAutUser, WF7->WF7_CONTA )   , cAccount  ) ) )
	//cUser     := Lower( AllTrim( Iif( At( "@", cAccount ) > 0, Subs( cAccount, 1, At( "@", cAccount ) - 1 ), cAccount ) ) )
	//cPassword := AllTrim( Iif( Empty(cPassword) , Iif ( !Empty( cAutSenha ), cAutSenha, WF7->WF7_SENHA ) , cPassword ) )
	//cServer   := Lower( AllTrim( Iif( Empty(cServer), WF7->WF7_SMTPSR, cServer   ) ) )
	//cFrom     := Lower( AllTrim( Iif( Empty(cFrom), WF7->WF7_REMETE, cFrom     ) ) )
              
	If !lParWf
	 
		cAccount  := If( Empty(cAccount),GETMV("MV_EMCONTA"),cAccount)
		cPassword  := If(Empty(cPassword),GETMV("MV_EMSENHA"),cPassword)

		cAccount  := AllTrim(Iif( Empty( cAccount ),  GetMV("MV_RELACNT"), cAccount ))
		cServer   := AllTrim(Iif( Empty( cServer ),   GetMV("MV_RELSERV"), cServer ))
		cPassword := AllTrim(Iif( Empty( cPassword ), GetMV("MV_RELPSW"),  cPassword ))
		cUser     := AllTrim(Iif( Empty( cUser ),     Iif( At( '@', cAccount ) > 0, SubStr( cAccount, 1, At( '@', cAccount ) - 1 ), cAccount ), cUser ))
		
		ConOut(cAccount)
		ConOut(cServer)
		ConOut(cPassword)
		ConOut(cUser)
	Else
		cMailBox   := AllTrim(GetMV( "MV_WFMLBOX" ))
		cAutUser   := AllTrim(GetMv( "MV_WFAUTUS" )) 
		cAutSenha  := AllTrim(GetMV( "MV_WFAUTSE" ))
	
		DbSelectArea( "WF7" )
		DbSetOrder( 1 )
		DbSeek( xFilial( "WF7" ) + cMailBox )

		cAccount  := AllTrim(Iif( Empty( cAccount ),  WF7->WF7_CONTA, cAccount ))
		cServer	  := AllTrim(Iif( Empty( cServer ),   WF7->WF7_SMTPSR, cServer ))
		cPassword := AllTrim(Iif( Empty( cPassword ), WF7->WF7_AUTSEN,  cPassword ))		
		cPort     := IIF(!Empty(WF7->WF7_SMTPPR),WF7->WF7_SMTPPR, 25) 		
		cUser     := AllTrim(Iif( Empty( cUser ),     Iif( At( '@', cAccount ) > 0, SubStr( cAccount, 1, At( '@', cAccount ) - 1 ), cAccount ), cUser ))
		cFrom := AllTrim(Iif( Empty( cFrom ), WF7->WF7_REMETE, cFrom ))
	EndIf

	cFrom := AllTrim(Iif( Empty( cFrom ), cAccount, cFrom ))

	If __Debug
		ConOut("  cAccount  (" + ValType( cAccount ) +  ") := " + cAccount )
		ConOut("  cUser     (" + ValType( cUser ) +     ") := " + cUser )
		ConOut("  cPassword (" + ValType( cPassword ) + ") := " + cPassword )
		ConOut("  cServer   (" + ValType( cServer ) +   ") := " + cServer )
		ConOut("  cFrom     (" + ValType( cFrom ) +     ") := " + cFrom )
		ConOut("  cEmailTo  (" + ValType( cEmailTo ) +  ") := " + cEmailTo )
		ConOut("  cEmailCc  (" + ValType( cEmailCc ) +  ") := " + Iif( cEmailCc == Nil, 'NIL', cEmailCc ) )
		ConOut("  cEmailBcc (" + ValType( cEmailBcc ) + ") := " + Iif( cEmailBcc == Nil, 'NIL', cEmailBcc ) )
	EndIf
                      
	oServer := TMailManager():New()
 //oServer:setUseSSL(.T.)
	oServer:Init( "", cServer, cAccount, cPassword, 0, cPort ) 
	
		
	If (nErro := oServer:SetSmtpTimeOut( 180 )) != 0
		ConOut( "[ERRO "+ AllTrim(Str(nErro)) + "] Falha ao setar o time out: "+oServer:GetErrorString( nErro ) )
		lRet := .F.
	EndIf
	
	If lRet .AND. (nErro := oServer:SmtpConnect()) != 0
		ConOut( "[ERRO "+ AllTrim(Str(nErro)) + "] Falha ao conectar: "+oServer:GetErrorString( nErro )  )
		lRet := .F.
	EndIf
	
	If lRet .And. lSmtpAuth .And. (nErro := oServer:SmtpAuth(cUser, cPassword)) != 0 
		If lRet .AND. (nErro := oServer:SmtpAuth(cAccount, cPassword)) != 0
			Conout( "[ERRO "+ AllTrim(Str(nErro)) + "] Falha ao autenticar SMTP: "+oServer:GetErrorString( nErro ) )
			oServer:SmtpDisconnect()
			lRet := .F.
		EndIf
	EndIf
	                                     
	If lRet
		ConOut("Autenticação Ok")
		oMessage := TMailMessage():New()
		oMessage:Clear()
		
		oMessage:cFrom    := cFrom
		oMessage:cTo      := cEmailTo
		oMessage:cCc      := cEmailCc
		oMessage:cBcc     := cEmailBcc
		oMessage:cSubject := cAssunto
		oMessage:cBody    := cMensagem  
			
		For nI := 1 to Len(aAnexo := U_SToA(cAnexos,';'))
			If lRet .AND. ( nErro := oMessage:AttachFile( aAnexo[nI] ) ) < 0
				Conout( "[ERRO "+ AllTrim(Str(nErro)) + "] Erro ao anexar o arquivo "+aAnexo[nI]+": "+oServer:GetErrorString( nErro )  )
				lRet := .F.
				Exit
			Else                     
				oMessage:AddAtthTag( 'Content-Disposition: attachment; filename='+aAnexo[nI])
			EndIf
		Next
		 
		If lRet .AND. (nErro := oMessage:Send( oServer )) != 0
			Conout( "[ERRO "+ AllTrim(Str(nErro)) + "] Erro ao enviar o e-mail: " + oServer:GetErrorString( nErro )  )
			lRet := .F.
		EndIf
		
		If lRet .AND. (nErro := oServer:SmtpDisconnect()) != 0
			Conout( "[ERRO "+ AllTrim(Str(nErro)) + "] Erro ao disconectar do servidor SMTP: "+oServer:GetErrorString( nErro )  )
			lRet := .F.
		EndIf
	EndIf
		
	If __Debug
   ConOut("</DEBUG DATA='" + DToS(dDataBase) + "', HORA='"+ Time() + "'>  ")
	EndIf
	
	ConOut("Fim do Envio")
	ConOut(IIf(lRet, ".T.", ".F."))
	
Return lRet

User Function SToA(cString,cCharSep)
	Local aVet   := {}
	Local nPosAt := 0
	
	If cString != Nil
		While ( nPosAt := At( cCharSep, cString ) ) > 0
			AAdd( aVet, AllTrim( SubStr( cString, 1, nPosAt-1 ) ) )
			cString := SubStr( cString, nPosAt+1 )
		End
	    
		If !Empty( cString )
			AAdd( aVet, AllTrim( cString ) )
		EndIf
	EndIf

Return aVet


//Consulta Especifica SM0
User Function PdGrtM0()

Local aArea    := getArea()
Local cTitulo  := "Selecione a Empresa"
Local aAux     := {}
Local oGdPar   := Nil
Local nOpca    := 0

Local nI       := 0
Local nAt      := 1
Local nCont    := 0
                                                                     
Local oDlgPar := Nil                                                 
Local aHSM0 := {}

aAdd(aHSM0,{"Empresa"  , "M0_CODIGO", "@!",	2, 0 , "", /* Usado */, "C",         , "V",,,, "V", ""})
aAdd(aHSM0,{"Filial"   , "M0_CODFIL", "@!",	2, 0 , "", /* Usado */, "C",         , "V",,,, "V", ""})
aAdd(aHSM0,{"Nome"     , "M0_FILIAL", "@!",	50, 0 , "", /* Usado */, "C",         , "V",,,, "V", ""})
aAdd(aHSM0,{"Descricao", "M0_NOME"  , "@!",	50, 0 , "", /* Usado */, "C",         , "V",,,, "V", ""})

DbSelectArea("SM0")
DbSetOrder(1)   
DbGoTop()

While SM0->(!Eof())
	nCont++
	
	If !Empty(&(ReadVar())) .And. &(ReadVar()) == SM0->M0_CODIGO
		nAt := nCont
	EndIf
	
	aAdd(aAux,{SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_FILIAL, SM0->M0_NOME, .F.})

	SM0->(DbSkip())
Enddo

DEFINE MSDIALOG oDlgPar TITLE cTitulo From 000, 000 To 500, 800 Of oMainWnd Pixel

oPPesqPar	:=	tPanel():New(000,000,, oDlgPar,,,,,/*CLR_GREEN*/, 017,017)
oPPesqPar:Align := CONTROL_ALIGN_TOP

oGdPar := MsNewGetDados():New(000, 000, 200, 200,0,,,,,,,,,, oDlgPar, aHSM0, aAux)
oGdPar:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

HS_GDPesqu( , , oGdPar, oPPesqPar, 002, .T.)

oGdPar:oBrowse:Refresh()
oGdPar:oBrowse:nAt := nAt
oGdPar:oBrowse:SetFocus()

ACTIVATE MSDIALOG oDlgPar CENTERED ON INIT EnchoiceBar(oDlgPar, {||nOpca := 1, oDlgPar:End()}, {|| nOpca := 0, oDlgPar:End()})

__RetM0Emp := ""
__RetM0Fil := ""

If nOpca == 1
	__RetM0Emp := oGdPar:aCols[oGdPar:nAt, 1]
	__RetM0Fil := oGdPar:aCols[oGdPar:nAt, 2]
EndIf

RestArea(aArea)
Return(.T.)

User Function RetM0Emp()
	&(Readvar()) := __RetM0Emp
Return(.T.)

User Function RetM0Fil()
	&(Readvar()) := __RetM0Fil
Return(.T.)      

User Function DefSX1(aChave)
 Local aArea      := GetArea()
 Local nLenChave  := Len(aChave)
 Local nForChave  := 0
 Local nForSX1    := 0
 Local cP_Defs    := ""
 Local cP_DefsTmp := ""
 Local nPFLin     := 0
 Local lProfAlias := Select("PROFALIAS") > 0
 Local nPosGrupo  := 1
 Local nPosOrdem  := 2
 Local nPosCont   := 3

 For nForChave := 1 To nLenChave

  If aChave[nForChave][nPosCont] == Nil 
   aChave[nForChave][nPosCont] := Space(SX1->X1_TAMANHO)
  EndIf

  If lProfAlias
   DBSelectArea("PROFALIAS")
   DbSetOrder(1)
   If DbSeek(PadR(AllTrim(cUserName)          , Len(PROFALIAS->P_NAME)) + ;
             PadR(aChave[nForChave][nPosGrupo], Len(PROFALIAS->P_PROG)) + ;
             PadR("PERGUNTE"                  , Len(PROFALIAS->P_TASK)) + ;
             PadR("MV_PAR"                    , Len(PROFALIAS->P_TYPE)))

    cP_DefsTmp := PROFALIAS->P_DEFS
	  
    While !Empty(cP_DefsTmp)
    
     nPFLin := At(Chr(13) + Chr(10), cP_DefsTmp)
	  
     If  nForSx1 == Val(aChave[nForChave][nPosOrdem])
      cP_Defs += SubStr(cP_DefsTmp, 1, 4) + aChave[nForChave][nPosCont] + Chr(13) + Chr(10)
     Else 
      cP_Defs += SubStr(cP_DefsTmp, 1, nPFLin + 1)
     EndIf 

     cP_DefsTmp := SubStr(cP_DefsTmp, nPFLin + 2)
     nForSx1++
    
    End
	  
    RecLock("PROFALIAS", .F.)
    PROFALIAS->P_DEFS := cP_Defs
    MsUnLock() 
   Else 
    FS_PosSx1(PADR(aChave[nForChave][nPosGrupo], Len(SX1->X1_GRUPO))+aChave[nForChave][nPosOrdem], aChave[nForChave][nPosCont])
   EndIf
  Else	                         
   FS_PosSx1(PADR(aChave[nForChave][nPosGrupo], Len(SX1->X1_GRUPO))+aChave[nForChave][nPosOrdem], aChave[nForChave][nPosCont])
  EndIf
 Next nForChave

 RestArea(aArea)
Return(Nil)

Static Function FS_PosSx1(cChave, xConteudo)
 Local nForSx1 := 0
 
 DbSelectArea("SX1")
 DbSetOrder(1) // X1_GRUPO + X1_ORDEM           
 If DbSeek(cChave)	
  If Type("xConteudo") == "A"
   For nForSx1 := 1 To Len(xConteudo)
    RecLock("SX1", .F.)
    &(xConteudo[nForSx1][1]) := xConteudo[nForSx1][2]
    MsUnLock()
   Next
  Else
   RecLock("SX1", .F.)
   SX1->X1_CNT01 := xConteudo
   MsUnLock()
  EndIf
 EndIf
Return(Nil)	 

class DaoObject FROM LongNameClass 
	data cAlias                   
	data cNewAlias
	data oWhere
	data cWhere 
	data oJoin      
	data cOrder   
	data oFields   
	data oGroup        
	data aEmpSql as Array
	data lUseXfilial as boolean
				
	data __nWhere 
	data __nJoin
	data __nFields           
	data __nGroup
	
	method new(cAlias, cNewAlias, aEmpSql) constructor    
	method where(cField, cContent, cOperator) 
	method join(cTabela, cAlias, aCampos, lLeftJoin)
	method setOrder(cOrder)
    method toSql(nTipoRet)
    method showSql()
    method addField(cField, cAlias)
    method group(aGroup) 
    method setWhere(cWhere)   
    method addJoin(cJoin) 
    
    method Clone()
    method setEmpSql(aVet)
endclass          

method setEmpSql(aVet) class DaoObject
	Local aArea := GetArea()
	Local nI := 1
	::aEmpSql := {}
	DbSelectArea("SM0")
	DbSetOrder(1)
			
	For nI := 1 To Len(aVet)
		
		//If SM0->(DbSeek(aVet[nI]))
			aAdd(::aEmpSql, aVet[nI]) //Empresa e Filial
		//EndIf
			
	Next  
	
	If Empty(::aEmpSql)
		aAdd(::aEmpSql, {cEmpAnt, cFilAnt})
	EndIf 
		
	RestArea(aArea)
return(self)
           
method addJoin(cJoin) class DaoObject
	
	If ::oJoin == Nil
		::oJoin := THash():New()	
		::__nJoin := 0
	EndIf
		
	::oJoin:put(::__nJoin++, cJoin)

return(self)
                  
method Clone() class DaoObject    
	Local nI := 1, aAux := {}	
	Local oTarget := DaoObject():New(::cAlias)  
	Local cWhere := ""
	Local cField := ""
		               
	aAux := ::oFields:getKeys()
	
	For nI := 1 To Len(aAux)
		cField := ::oFields:getIndex(nI)    	
		cField := AllTrim(SubStr(cField, 1, rAt(" ", cField)))
		oTarget:addField(cField, aAux[nI])		
	Next                                                  
	
	If ::oJoin <> Nil .And. !::oJoin:isEmpty()
		aAux := ::oJoin:getKeys()
		
		For nI := 1 To Len(aAux) 
			oTarget:addJoin(::oJoin:getIndex(nI))		
		Next 	
	
	EndIF
	
	If ::cWhere <> Nil .And. !Empty(::cWhere)
		cWhere := ::cWhere 
	ElseIf ::oWhere <> Nil
		aAux := ::oWhere:getKeys()
		
		For nI := 1 To Len(aAux) 
			cWhere += ::oWhere:getIndex(nI) + CRLF
		Next 
	EndIf 	
	
	oTarget:setWhere(cWhere)		
	
	If ::cOrder <> Nil .And. !Empty(::cOrder) 
		oTarget:setOrder(::cOrder)
	EndIf		

	If ::oGroup <> Nil .And. !::oGroup:IsEmpty()
		aAux := ::oGroup:getValues()	
		oTarget:group(aAux)
	EndIf
				
return(oTarget)

method setWhere(cWhere) class DaoObject
	::cWhere := cWhere 
return(self)         
           
method group(aGroup) class DaoObject
	
	Local nI := 1 

	//If ::oGroup == Nil 		
		::oGroup := THash():New()
		::__nGroup := 0
	//EndIf                        
	
	For nI := 1 To Len(aGroup)
		::oGroup:put(::__nGroup++, aGroup[nI])
	Next
		
return(self)

method new(cAlias, cNewAlias, aEmpSql) class DaoObject 
	Default cNewAlias := cAlias
	Default aEmpSql := {{cEmpAnt + "0", cFilAnt}}

	::cAlias      := cAlias
	::cNewAlias   := cNewAlias
	::aEmpSql     := aEmpSql   
	::lUseXfilial := .T.
		
	::cWhere := ""
return(self)

method addField(cField, cAlias) class DaoObject
	
	Default cAlias := ""
	
	If Empty(cAlias)  
		cAlias := cField 
		IF (nPos := at(".", cField)) > 0
			cAlias := SubStr(cField, nPos + 1)
		EndIF
	EndIf
			
	If ::oFields == Nil
		::oFields := THash():New()
		::__nFields := 0		
	EndIf
    
	::oFields:put(cAlias, cField + " " + cAlias)

return(self)                                      

method where(cField, cContent, cOperator) class DaoObject
	                         
	Local cWhere := ""
	
	Default cOperator := " = "
			
	If ::oWhere == Nil
		::oWhere := THash():New()	
		::__nWhere := 0
	EndIf
	
	cWhere := cField + " " + cOperator + " " + cContent
		
	::oWhere:put(::__nWhere++, cWhere)
	
return(self)

method join(cTabela, cAlias, aCampos, lLeftJoin) class DaoObject
	
	Local cJoin := ""
		                                 
	Default cAlias := cTabela
	Default lLeftJoin := .F.
	
	If ::oJoin == Nil
		::oJoin := THash():New()	
		::__nJoin := 0
	EndIf
	
	cJoin := RetJoin(cTabela, cAlias, aCampos, lLeftJoin)
	
	::oJoin:put(::__nJoin++, cJoin)
		
return(self)      

Static Function RetJoin(cTabela, cAlias, aCampos, lLeftJoin)
	Local cJoin := ""           
	Local nI := 0, oCpo := THash():New()
	Local cLeftJoin := ""
	Local cCpoFil   := ""
	Local cOperador := ""
	
	Default cAlias := cTabela
	Default lLeftJoin := .F.
	
	cLeftJoin := IIF(lLeftJoin," LEFT ","")
	
	cCpoFil := cAlias + "." + PrefixoCpo(cAlias) + "_FILIAL"
		
	cJoin += " ? JOIN ? ? ON ? AND ? = '?' AND ?.D_E_L_E_T_ <> '*' "
	
	For nI := 1 To Len(aCampos)                         
		cOperador := IIF(Len(aCampos[nI]) > 2,  aCampos[nI, 3], " = ")
		oCpo:put(nI, cAlias + "." + aCampos[nI, 1] + cOperador + aCampos[nI, 2])	
	Next       
Return(u_TrocaStr(cJoin, {cLeftJoin, RetSqlName(cTabela), cAlias,  oCpo:join(" AND "), cCpoFil, xFilial(cTabela), cAlias}))
   
method setOrder(cOrder) class DaoObject
	::cOrder := cOrder
return(self)

method toSql(nTipoRet) class DaoObject
	Local cSql := ""
	Local nI := 1
	Local aRet := {}
	
	Default nTipoRet := 1 // 1 - Union All  2 - Union 3 -Vetor com sql separados
	
	For nI := 1 To Len(::aEmpSql)
				
		If nTipoRet <> 3		
			cSql += IIF(Empty(cSql), "", " UNION " + IIF(nTipoRet == 1, " ALL ", ""))
		Else
			cSql := ""
		EndIf
		
		cSql += " SELECT "       
		If ::oFields <> Nil
			cSql +=   ::oFields:join(", " )
		Else
			cSql += " * "	
		EndIf 
		
		cSql += " FROM " + ::cAlias + ::aEmpSql[nI, 1] + " " + ::cNewAlias
	
		If ::oJoin <> Nil
			cSql += ::oJoin:join(" ")	
		EndIf
		
		cCpoFil := ::cNewAlias + "." + PrefixoCpo(::cAlias) + "_FILIAL"
		
		If self:lUseXfilial
			cSql += u_TrocaStr(" WHERE ? = '?' AND ?.D_E_L_E_T_ <> '*' AND ", {cCpoFil, xFilial(::cAlias), ::cNewAlias})
		Else
			cSql += u_TrocaStr(" WHERE (? = '?' OR ? = '  ' ) AND ?.D_E_L_E_T_ <> '*' ", {cCpoFil, ::aEmpSql[nI, 2], cCpoFil, ::cNewAlias})		
		EndIf
		                  
		If ValType(self:cWhere) <> "U" .Or. ValType(self:oWhere) <> "U"
			cSql += IIF(Empty(::cWhere), ::oWhere:Join(" AND "), ::cWhere)
		EndIf
		   
		If ::oGroup <> Nil
			cSql += " GROUP BY "+::oGroup:Join(", ")	
		EndIf 
		
		aAdd(aRet, cSql)
	Next
			      
	If ::cOrder <> Nil .And. !Empty(::cOrder)
		cSql += " ORDER BY " + ::cOrder
	EndIf
	
return(IIF(nTipoRet == 3, aRet, cSql))

method showSql() class DaoObject
	Aviso("SELECT",::toSql(),{"OK"})	
return(nil)

User Function CountTb(cAlias, cCond, aJoin)
	Local aArea  := GetArea()
	Local nCount := 0, nI := 0           
	
	Local cAliasJoin := ""
	Local aCpoJoin   := {}, aCpValJoin := {}
	Local nCpoJoin   := 0
	Local lLeftJoin  := .F.
	Local cJoin  := ""     
	      
	Default aJoin = {}
	
	If Len(aJoin) > 0
	 For nI := 1 to len(aJoin)
	  cAliasJoin := aJoin[nI, 1]
	  aCpoJoin   := aJoin[nI, 2]
	  aCpValJoin := aJoin[nI, 3]
	  lLeftJoin  := IIF(Len(aJoin)>3,aJoin[nI, 4],.F.)
	  
	  cJoin := IIF(lLeftJoin, " LEFT ", "")+" JOIN "+RetSqlName(cAliasJoin) + " ON "
	  cJoin += RetSqlName(cAliasJoin)+"."+cAliasJoin+"_FILIAL = '"+xFilial(cAliasJoin)+"' AND "
	  cJoin += RetSqlName(cAliasJoin)+"."+"D_E_L_E_T_ <> '*' "
	  
	  for nCpoJoin := 1 to len(aCpoJoin)
	   cJoin += " AND " + PrefixoCpo(cAliasJoin)+"."+aCpoJoin[nCpoJoin]+" = '"+&(aCpValJoin[nCpoJoin])+"' "
	  next nCpoJoin
	 next nI 
	endIf
	
	TCQuery "SELECT COUNT(*) NCOUNT " + ;
	        " FROM " + RetSqlName(cAlias) + " " +;
	        IIF(!Empty(cJoin),cJoin,"") + ;
	        " WHERE " + RetSqlName(cAlias)+"."+PrefixoCpo(cAlias) + "_FILIAL = '" + xFilial(cAlias) + "' AND "+RetSqlName(cAlias)+".D_E_L_E_T_ <> '*' " + ;
	IIf(!Empty(cCond), "AND " + cCond, "") New Alias "QTREG"
	
	DbGoTop()
	nCount := QTREG->NCOUNT
	
	DbCloseArea()
	RestArea(aArea)
Return(nCount)


User Function SendMsgEvt(cAlias, aEvento, cTitulo, cTexto, lInclui)
            
	//Aviso("HTML", GeraMsg(cAlias, cTitulo, cTexto, lInclui), {"OK"})
	U_ECM(aEvento,GeraMsg(cAlias, cTitulo, cTexto, lInclui))                            
		
Return(.T.)
    

Static Function GeraMsg(cAlias, cTitulo, cTexto, lInclui)
	Local cHtml := ""
	Local nI    := 1           
	Local aCampos := {}
	
	Local cAcaoTit := IIF(lInclui, "inclusão", "alteração")
	Local cAcao    := IIF(lInclui, "incluída", "alterada")
	Local cCor     := IIF(lInclui, "green"   , "blue")

	cHtml += "<html>"
	cHtml += "	<title>" + UPPER(cAcaoTit) + " DE " + UPPER(cTitulo) + "</title>"
	cHtml += "	<style>"
	cHtml += "		h1 {"
	cHtml += "			color : " + cCor + " ;"
	cHtml += "		}"
	cHtml += "		h2 {"
	cHtml += "			font-size: large ;"
	cHtml += "			color : " + cCor + " ;"
	cHtml += "		}"
	cHtml += "		.table {"
	cHtml += "			width: 60%;"
	cHtml += "			border: 1px solid black ;"
	cHtml += "			text-align: center;"
	cHtml += "		}"
	cHtml += "		.table tr.head {"
	cHtml += "			background-color: light" + cCor + ";"
	cHtml += "		}"
	cHtml += "		.table tr.odd {"
	cHtml += "			background-color: lightgray;"
	cHtml += "		}"
	cHtml += "	</style>"  	
	cHtml += "	<body>"
	cHtml += "		<h1>Notificação " + cAcaoTit + " de " + cTitulo + "</h1>"
	cHtml += "		<p>"
	cHtml += "			<strong>"
	cHtml += "				" + cTitulo + " "+ cTexto +" foi " + cAcao + " em " + DtoC(dDataBase) + " às " + Time() + " pelo usuário " + cUserName 
	cHtml += "			</strong>"
	cHtml += "		</p>"
	cHtml += "		<p>"
	cHtml += "			<h2>Itens modificados</h2>"
	cHtml += "			<table class='table' BORDER>"
	cHtml += "					<tr class='head'>"
	cHtml += "						<th>Campo</th>"
	cHtml += "						<th>Valor Antigo</th>"
	cHtml += "						<th>Valor Novo</th>"
	cHtml += "					</tr>"        
	
	For nI := 1 To Len(aCampos := ChangedVal(cAlias))
		cHtml += " <tr "+IIF(nI % 2 == 0, "class='odd'", "")+"> "
		cHtml += " 	<td> " + aCampos[nI, 2] + " </td> "
		cHtml += " 	<td> <em> " + aCampos[nI, 3] + " </em> </td> "
		cHtml += " 	<td> <em> " + aCampos[nI, 4] + " </em> </td> "
		cHtml += " </tr> "
	Next		
	cHtml += "			</table>"
	cHtml += "		</p>"
	cHtml += "	</body>"
	cHtml += "</html>"
			
Return(cHtml)

Static Function ChangedVal(cAlias)
	Local aArea := GetArea()
	Local aRet := {}                          
	Local cCampo := "", cTela := ""
	
	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	
	If SX3->(!DbSeek(cAlias))
		Return({"","","",""})			
	EndIf                  
	
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAlias            
		cCampo := SX3->(X3_ARQUIVO + "->" + X3_CAMPO)
		cTela  := SX3->("M->" + X3_CAMPO)
		If SX3->X3_CONTEXT <> 'V' .And. Type(cTela) # "U" .And. Type(cCampo) # "U" .And.  &(cCampo) <> &(cTela)
			
			If     Type(cTela) == "D"
				cTela := "DtoS(" + cTela + ") "
				cCampo := "DtoS(" + cCampo + ") "
			ElseIF Type(cTela) == "N"
				cTela := "AllTrim(Str(" + cTela + ")) "
				cCampo := "AllTrim(Str(" + cCampo + ")) "
			EndIf			
			
			aAdd(aRet, {SX3->X3_CAMPO, SX3->X3_TITULO, &(cCampo), &(cTela)})
		EndIf
			
		SX3->(DbSkip())	
	EndDo
	
	RestArea(aArea)
Return(aRet)

//Classe Gráfica para R3
class TPrintGraf 
	data oPrint 
	data nLin 
	data _nAltLin 
	data nLinMax 
	data nColMax 
	data nMgTop 
	data nMgLeft 	
	data nMgBottom 
	data nMgRight 		
	data lFirstPage 
	data nPage 
	data cTitulo 
	data cCabec 
	data nTamanho    
	data bCabec 
	data bAfterCab 
 	data nOrientat //1 - Portrait 2 - Landscape
 	data nHeigthLg
 	data nWidthLg	
 	
	method Puts(nCol, cText, lNewLine, oFont)
	method Cabec(cTitulo, cCabec)
	method IncLin(nArg)
	method New(cTitWin, cTitulo, cCabec) Constructor
	method preview()                          
	method EndPrt()
	method SetAftCab(bBloco) 
	method Setup()
	method HLine()
	method SetPortrait()
	method SetLandScape()
	method GetOrient()
	method SetTamanho(nTamanho)
endclass                 

method SetTamanho(nTamanho) class TPrintGraf
	::nTamanho := nTamanho
return(self)

method GetOrient() class TPrintGraf
return(::nOrientat)
	
method SetPortrait() class TPrintGraf
	::nOrientat := 1	
	::nLinMax   := ::oPrint:nVertRes()
	::nColMax   := ::oPrint:nHorzRes()	
	::oPrint:SetPortrait()
return (self)

method SetLandScape() class TPrintGraf
	::nOrientat := 2 	
	::nLinMax      := ::oPrint:nVertRes()
	::nColMax      := ::oPrint:nHorzRes()	
	::oPrint:SetLandscape()	
return (self)

method HLine() class TPrintGraf
	::IncLin()
	::oPrint:Line(::nLin, ::nMgLeft, ::nLin, ::nColMax - ::nMgRight)		
return(self)
                       
method Setup() class TPrintGraf
	Local uRet := Nil
	
	uRet := ::oPrint:Setup()
	If ::oPrint:GetOrientation() == 1
		::nOrientat := 1
	Else
		::nOrientat := 2
	EndIf
	::nLinMax   := ::oPrint:nVertRes()
	::nColMax   := ::oPrint:nHorzRes()
	
return uRet
	
method SetAftCab(bBloco) class TPrintGraf
	::bAfterCab := bBloco
return(self)
                 
method EndPrt() class TPrintGraf
	::oPrint:End()
return(.T.)
    
method IncLin(nArg) class TPrintGraf
	Default nArg := 1
	
	self:nLin += nArg * self:_nAltLin
return(self)                 

Method New(cTitWin, cTitulo, cCabec) Class TPrintGraf
	Default cTitWin := ""
	Default cTitulo := ""
	Default cCabec  := ""
	
	::oPrint       := TNewMSPrinter():New(cTitWin)	 
	::nLin         := 4000
	::_nAltLin     := 40	
	::nLinMax      := 3300
	::nColMax      := 2450
	::lFirstPage   := .T.
	::nPage        := 1 
	::cTitulo      := cTitulo
	::cCabec       := cCabec
	::nTamanho     := 132
	::nMgTop       := 50
	::nMgLeft 	   := 50
	::nMgBottom    := 50
	::nMgRight	   := 50
	::nOrientat    := 1
	::nHeigthLg    := 120
	::nWidthLg     := 480
	::oPrint:SetPaperSize(9)
	
Return Self

// nTipoCol - 1 - Define se o tamanho da coluna será assumido pelo numero de colunas definido no tamanho
// nTipoCol - 2 - Define se o tamanho da coluna será definido pelo tamanho do caracter
method Puts(nCol, cText, lNewLine, oFont, nTipoCol) class TPrintGraf
	Default lNewLine := .F.        
	Default oFont    := RetFont(08)
	Default nTipoCol := 1
		
	If nTipoCol == 1
		nCol := (::nColMax - (::nMgLeft + ::nMgRight)) / ::nTamanho * nCol
	Else
		nCol := oFont:nWidth * 1.8 * nCol  // ::oPrint:GetTextWidth("M", oFont)
	EndIf
		
	If lNewLine 
		If ::nLin + ::_nAltLin >= ::nLinMax - (::nMgTop + ::nMgBottom)
			::Cabec()
		Else
			::nLin += ::_nAltLin
		EndIf
	EndIf
		
	::oPrint:say(::nLin, nCol + ::nMgLeft, cText, oFont)
return(self)

method preview() class TPrintGraf
	::oPrint:preview()	
return(self)

method cabec(cCabec, lAfter) class TPrintGraf 
	Local nLin := 250            
	Local cLogo := FisxLogo("1")
	
	Default cCabec  := ::cCabec
	Default lAfter  := .T.
	
	If Type("::bCabec") == "B"
		Return(Eval(::bCabec, oPrint))                                
	EndIf
		
	If !::lFirstPage
		::oPrint:EndPage()
	EndIf               
	
	::oPrint:StartPage()
	::oPrint:Box(::nMgTop, ::nMgLeft, ::nLinMax - ::nMgBottom, ::nColMax - ::nMgRight)
	::oPrint:SayBitmap(::nMgTop + 10, ::nMgLeft + 35, cLogo, ::nWidthLg, ::nHeigthLg)
	::oPrint:Say(::nMgTop + 10 , ::nColMax - ::nMgRight - 150 , "Folha: " + StrZero(::nPage, 3), RetFont(08,.T.))		
	::oPrint:Say(::nMgTop + ::_nAltLin, ::nMgLeft + ::nWidthLg + 200, cCabec, RetFont(14,.T.))	
	//::oPrint:Say(::nMgTop + 110, ::nColMax - ::nMgRight - 150, DtoC(dDataBase), RetFont(08,.T.))	
	//::oPrint:Say(::nMgTop + 60 ,((::nColMax) / 2) - (::oPrint:GetTextWidht(cCabec, RetFont(14,.T.)) / 2), cCabec, RetFont(14,.T.))	
	//::oPrint:Say(::nMgTop + 60 , ::nWidthLg + ((::nColMax - ::nWidthLg - ::oPrint:GetTextWidht(AllTrim(cCabec), RetFont(14,.T.))) / 2), cCabec, RetFont(14,.T.))
	::oPrint:Line(::nMgTop + 150, ::nMgLeft, ::nMgTop + 150, ::nColMax - ::nMgRight)	
		
	::nPage += 1
	::lFirstPage := .F.  
	::nLin := ::nMgTop + 160
	     
	If ValType(::bAfterCab) == "B"
		Eval(::bAfterCab, Self, lAfter)
	EndIf
Return ::nLin

Static Function RetFont(nTam, lBold, lItalic)
Local oRet	:= Nil
Default nTam    := 8
Default lBold   := .F.
Default lItalic := .F.
//Return(oRet	:= TFont():New("Times New Roman",nTam,nTam,,lBold,,,,,lItalic))
Return(oRet	:= TFont():New("Courier New",nTam,nTam,,lBold,,,,,lItalic))

//Converte um array para o formato 'IN' para ser utilizado em query
User Function AToIn(aVet)
	Local nFor  := 0
	Local cRet  := ""
	Local cTipo := ""
	
	For nFor := 1 To Len(aVet)
		If ValType(aVet[nFor]) == "C"
			cRet += If(Empty(cRet), "'" + aVet[nFor] + "'", ", '" + aVet[nFor] + "'")
		ElseIf ValType(aVet[nFor]) == "N" 
			cRet += If(Empty(cRet), cValToChar(aVet[nFor]), ", " + cValToChar(aVet[nFor]))
		EndIf
	Next

Return(cRet)

User Function CToIn(cString, cSeparador)
	
	Local cRet := ""
	Local nPos := 0
	Default cSeparador := "/"
	
	While !Empty(cString)
		If !Empty(cRet)
			cRet += ", "
		EndIf
		
		If (nPos := At(cSeparador, cString)) > 0
			cRet += "'" + SubStr(cString, 1, nPos-1) + "'"
			cString := SubStr(cString, nPos+1)
		Else
			cRet += "'" + AllTrim(cString) + "'"
			cString := ""
		EndIf
	End
	
Return(cRet)

User Function UExecute()

	Local   oGet := Nil, oDlg1 := Nil, oBtBusca := Nil
 Private cGet := Space(200)
	
	DEFINE MSDIALOG oDlg1 FROM 000,000 TO 150, 400 PIXEL TITLE "Executar"

		oGet := TGet():New(10,10,bSETGET(cGet),oDlg1,130,10,"@!",{|| },,,,,,.T.,,,,,,,.F.,,,)
		
		oBtBusca  := tButton():New(25, 10, "Executar", oDlg1, {|| FS_Execute(cGet) }, 030, 012,,,, .T.)
		
	ACTIVATE MSDIALOG oDlg1
	
Return

Static Function FS_Execute(cGet)

 If !Empty(cGet)
	//	TRYEXCEPTION
			xConteudo	:= &(AllTrim(cGet))
	//	ENDEXCEPTION
	EndIf
	
Return()

User Function CTeConsul(oHmPar, cProtocolo, cCodSta, cMsgSta, cXml)
	Local cXmlCabMsg := ""
	Local cXmlDados  := ""    
	Local cUrl :=  ""//Somente para São Paulo
	Local lRetorno := .F.   
	Local cErro := "", cAviso := ""

	//"https://nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx"
	If oHmPar:getObj("cUf") $ "51/50/31/43/35" //MT/MS/MG/RS/SP - ESTADOS QUE TRANSMITEM COM SEFAZ CTE PROPRIA
	 cUrl := "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx"   
	Else//Demais estados transmitem pela SEFAZ Virtual RS ;)
		cUrl := "https://cte.sefaz.rs.gov.br/ws/cteconsulta/cteconsulta.asmx"
	EndIf
	oHmPar:put("cVersao", "1.04")
	//If oHmPar:Exists("nAmbiente/nModalidade/cChave/cVersao/cUf")
	//	UserException("Paramêtros Obrigatórios 'nAmbiente/nModalidade/cChave/cVersao/cUf' ")	
	If !(AllTrim(oHmPar:getObj("cVersao")) $  "1.04/1.03/1.01")
		UserException("Conteúdo do parâmetro cVersao inválido!")	
	EndIf
					
	//Cabeçalho
	cXmlCabMsg := ''	
	cXmlCabMsg += '<cteCabecMsg xmlns="http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta">'
	cXmlCabMsg += "<cUF>"+oHmPar:getObj("cUf")+"</cUF>"
	cXmlCabMsg += "<versaoDados>" + oHmPar:getObj("cVersao") + "</versaoDados>"
	cXmlCabMsg += "</cteCabecMsg>"
		
	//Dados		
	cXmlDados  := ''
	cXmlDados  += '<consSitCTe xmlns="http://www.portalfiscal.inf.br/cte" versao="' + oHmPar:getObj("cVersao") + '">'
	cXmlDados  += "<tpAmb>"+Str(oHmPar:getObj("nAmbiente"),1)+"</tpAmb>"
	cXmlDados  += "<xServ>CONSULTAR</xServ>"
	cXmlDados  += "<chCTe>"+StrTran(oHmPar:getObj("cChave"),"CTe","")+"</chCTe>"
	cXmlDados  += "</consSitCTe>"          
	          	
	oWsNfe := WSCteConsulta():New()
	oWsNfe:_URL         := cURL
	oWsNfe:cCTeCabecMsg := cXmlCabMsg
	oWsNfe:cCTeDadosMsg := cXmlDados
	lRetorno := oWsNfe:CTeConsultaCT()
	
	If lRetorno <> Nil .And. lRetorno
		cXml := EncodeUtf8(oWsNfe:cCTeConsultaCTResult)
		
		oXmlResult := XmlParser(cXML,"_",@cErro,@cAviso) //Parser Estranho
		
		//TODO - cErro e cAviso	
		If Empty(cErro) .And. Empty(cAviso)
			cCodSta := oXmlResult:_RETCONSSITCTe:_CSTAT:TEXT
			cMsgSta := oXmlResult:_RETCONSSITCTe:_XMOTIVO:TEXT
			
			If cCodSta $ "100,101,102"
				If cCodSta == "101"
					cProtocolo := oXmlResult:_RETCONSSITCTE:_RETCANCCTE:_INFCANC:_NPROT:TEXT
				Else
					cProtocolo := oXmlResult:_RETCONSSITCTE:_PROTCTE:_INFPROT:_NPROT:TEXT
				EndIf
			EndIf
		Else
			lRetorno := .F.
		EndIf
	EndIf    
Return(lRetorno)

User Function NfeConsul(oHmPar, cProtocolo, cCodSta, cMsgSta, cXML, lQuiet)
	Local cIdEnt := ""
	Local cChave := ""
	Local lRet   := .T.

	Local cURL      := PadR(GetNewPar("MV_SPEDURL", "http://"),250)
	Local cMensagem := ""
	Local oWS
	
	Default lQuiet := .T.

	cIdEnt := AllTrim(GetIdEnt())
	cChave := Iif(ValType(oHmPar) == "O", oHmPar:getObj("cChave"), oHmPar)
	If Empty(cChave)
		UserException("Obrigatório a Informação da Chave!")	
	EndIf
	
	oWs := WsNFeSBra():New()
	oWs:cUserToken := "TOTVS"
	oWs:cID_ENT    := cIdEnt
	ows:cCHVNFE    := cChave
	oWs:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"

	If oWs:ConsultaChaveNFE()
		cMensagem := ""
		If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cVERSAO)
			cMensagem += "Versão da mensagem: "+oWs:oWSCONSULTACHAVENFERESULT:cVERSAO+CRLF
		EndIf
		cMensagem += "Ambiente: " + IIf(oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE==1,"Produção","Homologação")+CRLF //###
		cMensagem += "Cod.Ret.NFe: " + oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE+CRLF
		cMensagem += "Msg.Ret.NFe: " + oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE+CRLF
		If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
			cMensagem += "Protocolo: " + oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO+CRLF	
			cProtocolo := oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO
		EndIf
		cCodSta := oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE
		cMsgSta := oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE
		cXML    := ""
		lRet    := AllTrim(oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE) $ "100/101/110"
		If !lRet .And. !lQuiet
			Aviso("Consulta Nfe", cMensagem, {"Ok"}, 3)
		EndIf
	Else
		Aviso("SPED",IIf(Empty(GetWscError(3)), GetWscError(1), GetWscError(3)), {"OK"}, 3)
	EndIf                                                           

Return lRet

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Funcao    ³GetIdEnt			   ³Autor³Marinaldo de Jesus &³Data ³06/07/2010³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Obtem o codigo da entidade apos enviar o post para o Totvs		   ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>									 	   ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>								     	   ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³WebService NFS	            							     	   ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function GetIdEnt()

	Local aArea  := GetArea()
	Local cIdEnt := ""
	Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local oWs
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Obtem o codigo da entidade                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oWS := WsSPEDAdm():New()
	oWS:cUSERTOKEN := "TOTVS"
		
	oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")	
	oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
	oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM		
	oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
	oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
	oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
	oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
	oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
	oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
	oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
	oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
	oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
	oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
	oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
	oWS:oWSEMPRESA:cCEP_CP     := Nil
	oWS:oWSEMPRESA:cCP         := Nil
	oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
	oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
	oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
	oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
	oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
	oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
	oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cINDSITESP  := ""
	oWS:oWSEMPRESA:cID_MATRIZ  := ""
	oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
	oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
	If oWs:ADMEMPRESAS()
		cIdEnt  := oWs:cADMEMPRESASRESULT
	Else
		Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
	EndIf
	
	RestArea(aArea)
Return(cIdEnt)

User Function VldCliCad(cCodCli, cLoja)
	Local aArea     := GetArea()
	Local aAreaSa1  := SA1->(GetArea())
	Default cCodCli := SA1->A1_COD
	Default cLoja   := SA1->A1_LOJA
	
	If Select("SA1") <> 0
		DbSelectArea("SA1")
	EndIf                 

	If xFilial("SA1") + cCodCli + cLoja <> SA1->(A1_FILIAL + A1_COD + A1_LOJA)	
		SA1->(DbSetOrder(1))
		If !SA1->(DbSeek(xFilial("SA1") + cCodCli + cLoja))
			UserException("Cliente não encontrado (Consulta Contribuinte)")		
		Endif
	EndIf
	
	If !(lRet := ConsCad(SA1->A1_EST, IIF(SA1->A1_PESSOA == "J", SA1->A1_CGC, ""), IIF(SA1->A1_PESSOA == "F", SA1->A1_CGC, ""), IIF(SA1->A1_INSCR <> "ISENTO", SA1->A1_INSCR, ""), .F.) == "1")
		MsgStop("Cliente não habilitado como contribuinte do ICMS", "Validação Consulta Contribuinte")
	Endif
		
	RestArea(aAreaSa1)
	RestArea(aArea)
Return(lRet)

Static Function ConsCad(cUF, cCnpj, cCpf, cIE, lQuiet)
	Local cURL     	:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cIdEnt    := "" 
	Local cRazSoci 	:= ""	
	Local cRegApur  := ""
	Local cCnpj	    := ""
	Local cCpf	    := ""
	Local cSituacao := ""   
	Local cPictCNPJ	:= "" 
	
	Local dIniAtiv    := Ctod("")
	Local dAtualiza	  := Ctod("")

	Local nX := {}

	Private oWS              
	
	Default cCnpj  := ""
	Default cCpf   := ""
	Default cIE    := ""
	Default lQuiet := .F.

	cIdEnt := GetIdEnt()

	oWs:= WsNFeSBra():New()
	oWs:cUserToken    := "TOTVS"
	oWs:cID_ENT		  := cIdEnt
	oWs:cUF		      := cUF
	oWs:cCNPJ		  := Alltrim(cCnpj)
	oWs:cCPF	  	  := Alltrim(cCpf)
	oWs:cIE		      := Alltrim(cIE)
	oWs:_URL          := AllTrim(cURL)+"/NFeSBRA.apw"
	
	If oWs:CONSULTACONTRIBUINTE()
	
		If Type("oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE") <> "U" 
			If ( Len(oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE) > 0 )
				nX := Len(oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE)
				
				If ValType(oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:dInicioAtividade) <> "U"			
			   		dIniAtiv  := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:dInicioAtividade
			   	Else
			   		dIniAtiv  := ""
				EndIf            
				cRazSoci  := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:cRazaoSocial
				cRegApur  := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:cRegimeApuracao
				cCnpj	  := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:cCNPJ
				cCpf	  := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:cCPF
			   	cIe       := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:cIE
			   	cUf	      := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:cUF
				cSituacao := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:cSituacao	
			     
			  	If ValType(oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:dUltimaSituacao) <> "U"
				  	dAtualiza := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:dUltimaSituacao           
				Else
					dAtualiza := ""
				EndIf
				
				If ( cSituacao == "1" )
					cSituacao := "1 - Habilitado"
				ElseIf ( cSituacao == "0" )
					cSituacao := "0 - Não Habilitado"
				EndIf 
				
	 
				If ( !Empty(cCnpj) ) 
					cCnpj		:= cCnpj
					cPictCNPJ	:= "@R 99.999.999/9999-99"
				Else  
					cCnpj		:= cCPF
					cPictCNPJ	:= "@R 999.999.999-99"
				EndIf			
				
				If !lQuiet			  
					DEFINE FONT oFont BOLD
				
					DEFINE MSDIALOG oDlgKey TITLE "Retorno do Consulta Contribuinte" FROM 0,0 TO 200,355 PIXEL OF GetWndDefault()  //
					
					@ 008,010 SAY "Início das Atividades:"		 PIXEL FONT oFont OF oDlgKey    	//
					@ 008,072 SAY If(Empty(dIniAtiv),"",DtoC(dIniAtiv))	 PIXEL OF oDlgKey
					@ 008,115 SAY "UF:" 		 PIXEL FONT oFont OF oDlgKey		//
					@ 008,124 SAY cUf			 PIXEL OF oDlgKey
					@ 020,010 SAY "Razão Social:"		 PIXEL FONT oFont OF oDlgKey 		//
					@ 020,048 SAY cRazSoci		 PIXEL OF oDlgKey		
					@ 032,010 SAY "CNPJ/CPF:"		 PIXEL FONT oFont OF oDlgKey  	//
					@ 032,040 SAY cCnpj		 PIXEL PICTURE cPictCNPJ OF oDlgKey		
					@ 032,115 SAY "IE:"		 PIXEL FONT oFont OF oDlgKey  	//
					@ 032,123 SAY cIe			 PIXEL OF oDlgKey		
					@ 044,010 SAY "Regime:"		 PIXEL FONT oFont OF oDlgKey  	//
					@ 044,035 SAY cRegApur		 PIXEL OF oDlgKey		      	
					@ 056,010 SAY "Situação:"		 PIXEL FONT oFont OF oDlgKey  	//
					@ 056,038 SAY cSituacao		 PIXEL OF oDlgKey             	
					@ 068,010 SAY "Atualizado em:"   	 PIXEL FONT oFont OF oDlgKey  	 //
		  			@ 068,055 SAY If(Empty(dAtualiza),"",DtoC(dAtualiza))	 PIXEL OF oDlgKey
					
					@ 80,137 BUTTON oBtnCon PROMPT "Ok" SIZE 38,11 PIXEL ACTION oDlgKey:End()	//"Ok"
				
					ACTIVATE DIALOG oDlgKey CENTERED		  
				EndIf  
			EndIf
		EndIf	
	Else
		Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
	EndIf
					
Return(SubStr(cSituacao, 1, 1))

User Function ExpUser()
	Processa({ || ExpUser() }, "Processando...")
Return(Nil)                                     

Static Function ExpUser()
	Local aAllUsers :=  AllUsers( .T. )
	Local nI := 1, nJ := 1
	Local oExcel := UExcel():New({"Usuarios"})
	Local lExpGrupo := MsgYesNo("Deseja exportar informações sobre os grupos dos usuários?")
	Local lExpMenu  := MsgYesNo("Deseja exportar informações sobre os menus dos usuários?")

	Local aGrupos := {}  
	Local aAllGrp := AllGroups(), nPosGru := 0
	
	ProcRegua(Len(aAllUsers))	
	oExcel:SetNome("usuarios.xls")
	
	PswOrder(1)
	
	oExcel:OffSet(0, 1):SetValue("Codigo")
	oExcel:OffSet(0, 1):SetValue("Login")
	oExcel:OffSet(0, 1):SetValue("Nome Completo")
	oExcel:OffSet(0, 1):SetValue("Status")
	oExcel:OffSet(0, 1):SetValue("Acesso")
	oExcel:NextRow()
	
	For nI := 1 To Len(aAllUsers)   

		IncProc()
		oExcel:OffSet(0, 1):SetValue(aAllUsers[nI, 1, 1])//Codigo
		oExcel:OffSet(0, 1):SetValue(aAllUsers[nI, 1, 2])//Login
		oExcel:OffSet(0, 1):SetValue(aAllUsers[nI, 1, 4])//Nome Completo
		oExcel:OffSet(0, 1):SetValue(IIF(aAllUsers[nI, 1, 17], "Bloqueado", "Liberado"))//Nome Completo
		oExcel:OffSet(0, 1):SetValue(aAllUsers[nI, 1, 15])
		
		If lExpGrupo
			PswSeek(aAllUsers[nI, 1, 1])
			If !Empty(aGrupos := PswRet(1)[1, 10])
				
				oExcel:NextRow()
				oExcel:OffSet(0, 1):SetValue("Grupos")
				
				oExcel:NextRow()				
				For nJ := 1 To Len(aGrupos)
					nPosGru := aScan(aAllGrp, { | v | AllTrim(v[1, 1]) == aGrupos[nJ]})
					oExcel:OffSet(0, 2):SetValue(aGrupos[nJ])
					oExcel:OffSet(0, 1):SetValue(aAllGrp[nPosGru, 1, 2])
					
					oExcel:NextRow()
				Next 				
			EndIf    
			oExcel:NextRow()
		EndIf
				
		If lExpMenu		
            
			If !Empty(aAllUsers[nI, 3])
				oExcel:OffSet(0, 1):SetValue("Menus")
				oExcel:NextRow()				
				For nJ := 1 To Len(aAllUsers[nI, 3])
					oExcel:OffSet(0, 2):SetValue(aAllUsers[nI, 3, nJ])
					oExcel:NextRow()
				Next
			EndIf
			oExcel:NextRow()
		EndIf	 
		
		oExcel:NextRow()	
	Next
	
	If oExcel:Save()
		oExcel:Show()
	EndIf	
Return()

//Cliente Customizado 
WSCLIENT WSConsultaNfe

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD nfeConsultaNF

	WSDATA   _URL                      as String
	WSDATA   cnfeCabecMsg              as String
	WSDATA   cnfeDadosMsg              as String
	WSDATA   cnfeConsultaNFResult      as String
	WSDATA   cVersao                   as String

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSConsultaNfe
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.070518A] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSConsultaNfe
Return

WSMETHOD RESET WSCLIENT WSConsultaNfe
	::cnfeCabecMsg       := NIL 
	::cnfeDadosMsg       := NIL 
	::cnfeConsultaNFResult := NIL          
	::cVersao := ""
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSConsultaNfe
Local oClone := WSNfeConsulta():New()
	oClone:_URL          := ::_URL 
	oClone:cnfeCabecMsg  := ::cnfeCabecMsg
	oClone:cnfeDadosMsg  := ::cnfeDadosMsg
	oClone:cnfeConsultaNFResult := ::cnfeConsultaNFResult
	oClone:cVersao := ::cVersao
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method nfeConsultaNF of Service WSNfeConsulta
------------------------------------------------------------------------------- */

WSMETHOD nfeConsultaNF WSSEND cnfeCabecMsg,cnfeDadosMsg WSRECEIVE cnfeConsultaNFResult WSCLIENT WSConsultaNfe
Local cSoap := "" , oXmlRet
Local cXML     := ""
Local cPrefixo := ""
Local nX       := 0
Local nY       := 0
Local cSave    := GetSrvProfString("SPED_SAVEWSDL"," ")
Local lGrava   := "1"$cSave .Or. "6"$cSave

WSDLSaveXML(lGrava)

BEGIN WSMETHOD
Do Case
	Case self:cVersao < "2.00"
		If "/dec/"$Self:_URL
			cSoap += '<nfeConsultaNF xmlns="http://nfe.fazenda.df.gov.br/">'
			cSoap += WSSoapValue("nfeCabecMsg", ::cnfeCabecMsg, cnfeCabecMsg , "string", .F. , .F., 0 , NIL, .F.) 
			cSoap += WSSoapValue("nfeDadosMsg", ::cnfeDadosMsg, cnfeDadosMsg , "string", .F. , .F., 0 , NIL, .F.) 	
		Else
			cSoap += '<nfeConsultaNF xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta">'
			cSoap += WSSoapValue("nfeCabecMsg", ::cnfeCabecMsg, cnfeCabecMsg , "string", .F. , .F., 0 ) 
			cSoap += WSSoapValue("nfeDadosMsg", ::cnfeDadosMsg, cnfeDadosMsg , "string", .F. , .F., 0 ) 
		EndIf
		cSoap += "</nfeConsultaNF>"
		If "/dec/"$Self:_URL
			oXmlRet := SvcSoapCall(	Self,cSoap,; 	
			"http://nfe.fazenda.df.gov.br/nfeConsultaNF",; 
			"DOCUMENT","http://nfe.fazenda.df.gov.br/",,,; 
			"https://dec.fazenda.df.gov.br/dec/ServiceConsulta.asmx")
		Else
			oXmlRet := SvcSoapCall(	Self,cSoap,; 
				"http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta/nfeConsultaNF",; 
				"DOCUMENT","http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta",,,; 
				"https://homologacao.nfe.fazenda.sp.gov.br:443/nfeWEB/services/NfeConsultaSoap")
		EndIf
		::Init()
		::cnfeConsultaNFResult :=  WSAdvValue( oXmlRet,"_NFECONSULTANFRESPONSE:_NFECONSULTANFRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
		If ::cnfeConsultaNFResult==Nil
			::cnfeConsultaNFResult :=  WSAdvValue( oXmlRet,"_P152_NFECONSULTANFRESPONSE:_P152_NFECONSULTANFRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
		EndIf
		If ::cnfeConsultaNFResult==Nil
			//--------------------------------------------------
			//Procura o namespace criado pela SEF
			//--------------------------------------------------
			cXML := Upper(XMLSaveStr(oxmlret,.F.))
			nX   := At('NFECONSULTANFRESPONSE',cXml)-1
			nY   := Rat("<",substr(Upper(XMLSaveStr(oxmlret,.F.)),1,nX))+1
			cPrefixo := SubStr(cXml,nY,nX-nY)
			If !Empty(cPrefixo)
				::cnfeConsultaNFResult :=  WSAdvValue( oXmlRet,"_"+cPrefixo+"_NFECONSULTANFRESPONSE:_"+cPrefixo+"_NFECONSULTANFRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 
			EndIf
		EndIf	
	//--------------------------------------------------
	//Client dos Webservices versao 2.0 da NF-e
	//--------------------------------------------------	
	Case self:cVersao >= "2.00"
		If ".sp.//" $ Self:_URL
			cSoap += '<nfeConsultaNF2 xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2">'
			cSoap += ' <nfeDadosMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2">'
			cSoap += ::cnfeDadosMsg
			cSoap += "</nfeDadosMsg>"                                 	
			cSoap += "</nfeConsultaNF2>"
		Else
			cSoap += ' <nfeDadosMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2">'
			cSoap += ::cnfeDadosMsg
			cSoap += "</nfeDadosMsg>"                                 	
        EndIf
		If "sefaz.mt." $ Self:_URL
			oXmlRet := SvcSoapCall(	Self,cSoap,; 
				"http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2/nfeConsultaNF2",; 
				"DOCUMENT","http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2",::cnfeCabecMsg,,; 
				"https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta2")
		Else
	   		oXmlRet := SvcSoapCall(	Self,cSoap,;
				"http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2/nfeConsultaNF2",; 
				"DOCUMENTSOAP12","http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2",::cnfeCabecMsg,,; 
				"https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeConsulta2")
		EndIf	
		::Init()
		::cnfeConsultaNFResult := Upper(XMLSaveStr(WSAdvValue( oXmlRet,"_NFECONSULTANF2RESULT:_RETCONSSITNFE","string",NIL,NIL,NIL,NIL,NIL,NIL),.F.))	      													 
		If Empty(Self:cnfeConsultaNFResult)
			::cnfeConsultaNFResult :=  Upper(XMLSaveStr(WSAdvValue( oXmlRet,"_NFECONSULTANF2RESPONSE:_NFECONSULTANF2RESULT:_RETCONSSITNFE","string",NIL,NIL,NIL,NIL,NIL),.F.))	 
		EndIf
		If Self:cnfeConsultaNFResult==Nil .Or. Empty(Self:cnfeConsultaNFResult)
			//--------------------------------------------------
			//Procura o namespace criado pela SEF
			//--------------------------------------------------
			cXML := Upper(XMLSaveStr(oxmlret,.F.))
			nX   := At('NFECONSULTANF2RESULT',cXml)-1
			nY   := Rat("<",substr(Upper(XMLSaveStr(oxmlret,.F.)),1,nX))+1
			cPrefixo := SubStr(cXml,nY,nX-nY)
			If !Empty(cPrefixo)
				::cnfeConsultaNFResult :=  Upper(XMLSaveStr(WSAdvValue( oXmlRet,"_"+cPrefixo+"_NFECONSULTANF2RESULT:_RETCONSSITNFE","string",NIL,NIL,NIL,NIL,NIL),.F.)) 
			EndIf
		EndIf
EndCase	

END WSMETHOD

oXmlRet := NIL
Return .T.