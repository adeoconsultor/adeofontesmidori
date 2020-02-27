#Include "Protheus.ch"
#Include "RwMake.ch"        
#Include "TopConn.ch"
#Include 'Font.ch'
#Include 'Colors.ch'  
/*---------------------------------------------------------
Funcao: USRXCC()  |Autor: AOliveira    |Data: 26-03-19
-----------------------------------------------------------
Descr.: Rotina tem como Objetivo Realizar Manutencao de 
        Usuarios x C.Custo.
-----------------------------------------------------------
Uso:    MIDIRI
---------------------------------------------------------*/
User Function USRXCC(nCallOpcx)

Private cCadastro := "Cadastro de Usuario x C.Custo"
Private aRotina   := {}

AAdd( aRotina, {"Pesquisar"  , "AxPesqui"    , 0, 1})
AAdd( aRotina, { "Visualizar", "AxVisual"    , 0, 2})
AAdd( aRotina, { "Incluir"   , "u_MNTUSRXCC" , 0, 3})
AAdd( aRotina, { "Alterar"   , "u_MNTUSRXCC" , 0, 4})
AAdd( aRotina, { "Excluir"   , "AxDeleta"    , 0, 5})

DbSelectArea("SZL")
SZL->(DbSetOrder(1))
mBrowse(6,1,22,75,"SZL")

Return()    

/*---------------------------------------------------------
Funcao: MNTUSRXCC()  |Autor: AOliveira    |Data: 26-03-2019
-----------------------------------------------------------
Descr.: Rotina tem como Objetivo Realizar Manutencao de 
        Usuarios x C.Custo.
-----------------------------------------------------------
Uso:    MIDIRI
---------------------------------------------------------*/    
User Function MNTUSRXCC(cAlias,nReg,nOpcx)
If nOpcx == 3
	AxInclui(cAlias,nReg,nOpcx,/*aAcho*/,/*cFunc*/,/*aCpos*/,"u_VLDUSRXCC()"/*cTudoOk*/,/*lF3*/,/*cTransact*/,/*aButtons*/,/*aParam*/,/*aAuto*/,/*lVirtual*/,/*lMaximized*/)
ElseIf nOpcx == 4
	AxAltera(cAlias,nReg,nOpcx,/*aAcho*/,/*aCpos*/,/*nColMens*/,/*cMensagem*/,"u_VLDUSRXCC()"/*cTudoOk*/,/*cTransact*/,/*cFunc*/,/*aButtons*/,/*aParam*/,/*aAuto*/,/*lVirtual*/,/*lMaximized*/)
EndIf

Return()

/*---------------------------------------------------------
Funcao: VLDUSRXCC()  |Autor: AOliveira    |Data: 26-03-2019
-----------------------------------------------------------
Descr.: Rotina tem como Objetivo Realizar Manutencao de 
        Usuarios x C.Custo.
-----------------------------------------------------------
Uso:    MIDIRI
---------------------------------------------------------*/    
User Function VLDUSRXCC(lAval, cUser, cCustoIni, cCustoFin, lInclui, nRecAKX)
Local aAreaSZL := SZL->(GetArea())
Local cAlias   := Alias()
Local lRet := .T.
Local aFaixaCC
Local nCtd := 0
Local nPriReg := 0
Local nTamCC := Len(SZL->ZL_CC_INI)
Local cQryCC := ""

Local cQryFinal := ""
Local cQryTmp  := GetNextAlias()
Local cTmpCC
Local lVazioTmp := .T.

DEFAULT lAval := .T.
DEFAULT cUser := M->ZL_USER
DEFAULT cCustoIni := M->ZL_CC_INI
DEFAULT cCustoFin := M->ZL_CC_FIN
DEFAULT lInclui   := Inclui
DEFAULT nRecSZL   := If(Inclui, 0, SZL->(Recno()))

If lAval .And. cCustoIni > cCustoFin
   HELP("  ",1,"PCOA1301") //Centro de custo inicial maior que final
   lRet := .F.
EndIf

If lRet
	//temporario criado no banco
	cTmpCC := CriaTrab( , .F.)
	MsErase(cTmpCC)
	MsCreate(cTmpCC,{{ "CTT_CUSTO", "C", Len(CTT->CTT_CUSTO), 0 }}, "TOPCONN")
	Sleep(1000)
	dbUseArea(.T., "TOPCONN",cTmpCC,cTmpCC/*cAlias*/,.T.,.F.)

	// Cria o indice temporario
	IndRegua(cTmpCC/*cAlias*/,cTmpCC,"CTT_CUSTO",,)

	dbSelectArea("SZL")
	dbSetOrder(1)
	aFaixaCC := {}
	If dbSeek(xFilial("SZL")+cUser)
		While ! Eof() .And. SZL->ZL_FILIAL == xFilial("SZL") .And. SZL->ZL_USER == cUser
		    If lInclui .OR. (!Inclui .And. Recno() <> nRecSZL)
				aAdd(aFaixaCC, {SZL->ZL_CC_INI, SZL->ZL_CC_FIN})
		    EndIf
			dbSkip()
		End
	EndIf
		
	If Len(aFaixaCC) > 0
		//1o. avalia se todos os elementos são do tipo caracter
		For nCtd := 1 TO Len(aFaixaCC)
		    aFaixaCC[nCtd][1] := PadR(Alltrim(aFaixaCC[nCtd][1]),nTamCC)  //inicio 
	    	aFaixaCC[nCtd][2] := PadR(Alltrim(aFaixaCC[nCtd][2]),nTamCC)  //final
	
			//avalia se todos os elementos sao numericos
			If 	Valtype(aFaixaCC[nCtd][1]) != "C" .OR. ;     //inicio
				Valtype(aFaixaCC[nCtd][2]) != "C"             //final
		    	HELP("  ",1,"PCOA1302") //Erro: Array enviado contem elemento nao caracter!
		   	    lRet := .F.
		    	EXIT
			EndIf
		Next
		
		If lRet
			//Cenario Atual ja incluido no cadastro
			//Usuario Faixa Inicial CC     Faixa Final CC
			//X       01                   03
			//X       10                   20
			//Tentando Incluir os centros de custo na faixa de 04 a 09
			//X       04                  09
			//primeiro contamos quantos CC tem na faixa de 04-09 (C1)
			//depois contamos quantos CC tem na faixa de 04-09 que nao estao cadastrados (C2)
			//entao fazemos comparacao se quantidade de centro de Custo e para permitir cadastros (C1) === (C2)
			//se for diferente entao é porque ja existe alguma faixa com cadastro destes centros de custos
		
			//monta a query para retornar todos os centros de custos constantes no array aFaixaCC
			For nCtd := 1 TO Len(aFaixaCC)
				cQryCC := " SELECT CTT_CUSTO FROM " + RetSqlName("CTT")
				cQryCC += " WHERE CTT_FILIAL = '"+xFilial("CTT")+"' "
				cQryCC += " AND CTT_CUSTO BETWEEN '" + aFaixaCC[nCtd][1] + "' AND '" + aFaixaCC[nCtd][2] + "' "
				cQryCC += " AND D_E_L_E_T_ = ' ' "				
				cQryCC := ChangeQuery(cQryCC)
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQryCC), cQryTmp, .F., .T.)
				dbSelectArea(cQryTmp)
    	        dbGoTop()
    			//alimenta o temporario criado no banco pois quando usuario tinha muito acesso estourava o tamanho da query	        
    	        While ! Eof()
    	        
    	        	dbSelectArea(cTmpCC)  //temporario criado no banco
    	        	Reclock(cTmpCC, .T.)
                    (cTmpCC)->CTT_CUSTO := (cQryTmp)->CTT_CUSTO
    	        	MsUnlock()
    	        	lVazioTmp := .F.
    	        
    	        	dbSelectArea(cQryTmp)
    	        	dbSkip()
    	        EndDo
				dbSelectArea(cQryTmp)
    	        dbCloseArea()
	
			Next
			
        	dbSelectArea(cTmpCC)  //temporario criado no banco
			dbCloseArea()

			//Monta a query final
		
            //monta a query para retornar se encontrou cc inicial/final informado se existe no array aFaixaCC
			cQryFinal := " SELECT COUNT(CTT_CUSTO) NCOUNTCTT FROM " + RetSqlName("CTT")
			cQryFinal += "        WHERE CTT_FILIAL = '"+xFilial("CTT")+"' "
			cQryFinal += "          AND CTT_CUSTO BETWEEN '" + cCustoIni + "' AND '" + cCustoFin + "' "
			cQryFinal += "          AND D_E_L_E_T_ = ' ' "
			If ! lVazioTmp
				//faz union com arquivo de centro de custo e temporario contendo as faixas de centro de custo ja inclusas
				cQryFinal += " UNION ALL "
	            //somente retorna os centros de custo se nao existe no array aFaixaCC
	            cQryFinal += " SELECT COUNT(CTT_CUSTO) NCOUNTCTT FROM " + RetSqlName("CTT")
				cQryFinal += "         WHERE CTT_FILIAL = '"+xFilial("CTT")+"' "
				cQryFinal += "           AND CTT_CUSTO BETWEEN '" + cCustoIni + "' AND '" + cCustoFin + "' "
				cQryFinal += "           AND D_E_L_E_T_ = ' ' "
				cQryFinal += "           AND CTT_CUSTO NOT IN ( SELECT CTT_CUSTO FROM " + cTmpCC + " ) "
			EndIf
			cQryFinal := ChangeQuery(cQryFinal)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQryFinal), cQryTmp, .F., .T.)
			dbSelectArea(cQryTmp)
            dbGoTop()
			
			//avalia retorno da query no primeiro registro
            lRet := ( (nPriReg := (cQryTmp)->NCOUNTCTT) > 0 )
			//avalia segundo registro se primeiro retornou algum contador de centro de custo            
			If lRet .And. ! lVazioTmp
				dbSelectArea(cQryTmp)
            	dbSkip() //vai para segundo registro
				lRet := ( (cQryTmp)->NCOUNTCTT == nPriReg )
			Else
				HELP("  ",1,"PCOA1303") //Faixa de centro de Custo ja existente nao esta integra.Verificar!
			EndIf						
			            
			dbSelectArea(cQryTmp)
            dbCloseArea()
            //apaga arquivo temporario criado
            MsErase(cTmpCC)
            
            If ! lRet
				HELP("  ",1,"PCOA1304") //Faixa de centro de Custo ja existente, portanto nao pode ser incluida!
            EndIf
            
	    EndIf
	    
	EndIf
		
EndIf
	
RestArea(aAreaSZL)
dbSelectArea(cAlias)

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AvFaixaCC ºAutor  ³Paulo Carnelossi    º Data ³  25/10/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Avalia se elemento 1 ou 2 podem ser inseridos na Tabela de  º±±
±±º          ³Acessos ao Centro de Custo                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AvFaixaCC(lAval,cNewElem1, cNewElem2, aElemExistente)
Local cInicio, cFim, nCtd, cAnterior := Space(Len(SZL->ZL_CC_INI))
Local lRet := .T.
Local nTamCC := Len(cNewElem1)

cNewElem1 := PadL(Alltrim(cNewElem1),nTamCC)
cNewElem2 := PadL(Alltrim(cNewElem2),nTamCC)

For nCtd := 1 TO Len(aElemExistente)
    aElemExistente[nCtd][1] := PadL(Alltrim(aElemExistente[nCtd][1]),nTamCC)
    aElemExistente[nCtd][2] := PadL(Alltrim(aElemExistente[nCtd][2]),nTamCC)
Next

If lAval .And. cNewElem1 > cNewElem2
   HELP("  ",1,"PCOA1301") //Centro de custo inicial maior que final
   lRet := .F.
EndIf

If lRet
	For nCtd := 1 TO Len(aElemExistente)
		//avalia se todos os elementos sao numericos
		If Valtype(aElemExistente[nCtd][1]) != "C" .OR. ;
	    	Valtype(aElemExistente[nCtd][2]) != "C"
	    	HELP("  ",1,"PCOA1302") //Erro: Array enviado contem elemento nao caracter!
	   	    lRet := .F.
	    	EXIT
	   EndIf
	   // avalia se elemento inicial e maior que anterior e neste caso
	   // atribui a cAnterior o segundo elemento
	   // senao esta errado - avisa usuario e sai
	   If aElemExistente[nCtd][1] > cAnterior
			cAnterior := aElemExistente[nCtd][2]
		Else
			HELP("  ",1,"PCOA1303") //Faixa de centro de Custo ja existente nao esta integra.Verificar!
	    	lRet := .F.
	    	EXIT
		EndIf	
	Next
EndIf

If lRet
	For nCtd := 1 TO Len(aElemExistente)
		cInicio	:= aElemExistente[nCtd][1]
		cFim		:= aElemExistente[nCtd][2]
		
		If cNewElem1 > cInicio
		    //avalia elementos a Inserir
			If cNewElem1 <= cFim .OR. cNewElem2 <= cFim
				HELP("  ",1,"PCOA1304") //Faixa de centro de Custo ja existente, portanto nao pode ser incluida!
				lRet := .F.
				EXIT
			EndIf	
		Else	
			//se elemento 1 for menor que inicio avalia elemento 2
			If cNewElem2 >= cInicio
				HELP("  ",1,"PCOA1304") //Faixa de centro de Custo ja existente, portanto nao pode ser incluida!
				lRet := .F.
				EXIT
			EndIf	
		EndIf
	Next
EndIf

Return(lRet)