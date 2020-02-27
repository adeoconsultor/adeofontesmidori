#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"
#INCLUDE "TOPCONN.CH"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	MA650ENCER
// Autor 		Alexandre Dalpiaz
// Data 		01/06/10
// Descricao  	Encerramento automático de OPs
// Uso         	Midori Atlantica
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MA650ENCER()
//////////////////////////

Local _cEnter := chr(13) + chr(10)
cPerg := 'MA650ENCER'
ValidPerg()

If !Pergunte(cPerg,.t.)
	Return()
EndIf

_cQuery := "SELECT C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_QUJE, C2_QUANT, C2_PRODUTO"
_cQuery += _cEnter + " FROM " + RetSqlName('SC2') + " SC2"
_cQuery += _cEnter + " WHERE SC2.D_E_L_E_T_ <> '*'"
_cQuery += _cEnter + " AND C2_FILIAL = '" + xFilial('SC2') + "'"
_cQuery += _cEnter + " AND C2_EMISSAO BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
_cQuery += _cEnter + " AND C2_STATUS <> 'E' "
_cQuery += _cEnter + " AND C2_NUM BETWEEN '"+mv_par04+"' AND '"+mv_par05+"' "
//_cQuery += _cEnter + " AND C2_OBS = 'EXCL.CF.AUT.SR.YUKIO EM 05/04' "
If mv_par03 == 1
	_cQuery += _cEnter + " AND C2_QUJE = 0"
ElseIf mv_par03 == 2
	_cQuery += _cEnter + " AND C2_QUJE < C2_QUANT"
	_cQuery += _cEnter + " AND C2_QUJE > 0"
Else
	_cQuery += _cEnter + " AND C2_QUJE <> C2_QUANT"
EndIf

MsAguarde({|| DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'TRB',.f.,.f.)},"Selecionando OP'S pendentes")
MemoWrit("c:\spool\sql\ma650encer.sql", _cQuery)

count to _nLastRec
DbGoTop()

If _nLastRec > 0
	Processa({|| RunProc()},"Encerrando OP´s pendentes")
Else
	MsgBox('Nenhuma OP encontrada. Verifique os parâmetros de tente novamente','ATENÇÃO!!!','ALERT')
EndIf

DbCloseArea()

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc()
/////////////////////////

ProcRegua(_nLastRec)

Do While !eof()
	
	IncProc("Encerrando Ordens de Produção pendentes ...")
	
	If TRB->C2_QUJE == 0	// OP ainda não apontada, será excluída
		_aOP := {}
		
		aAdd(_aOP, {"C2_FILIAL"	,	TRB->C2_FILIAL	, NIL})
		aAdd(_aOP, {"C2_NUM"	,	TRB->C2_NUM   	, NIL})
		aAdd(_aOP, {"C2_ITEM"	,	TRB->C2_ITEM	, NIL})
		aAdd(_aOP, {"C2_SEQUEN"	,	TRB->C2_SEQUEN	, NIL})
		
		DbSelectArea('SC2')
		DbSeek(TRB->C2_FILIAL + TRB->C2_NUM + TRB->C2_ITEM + TRB->C2_SEQUEN,.f.)
		
		MsExecAuto({|x,y,z| Mata650(x,y,z)}, _aOP, 5)
		
	Else	// OP apontada parcialmente, será encerrada
		
		_aOP := {}
		
		aAdd(_aOP, {"D3_FILIAL"	,	TRB->C2_FILIAL	, NIL})
		aAdd(_aOP, {"D3_OP" 	,	TRB->C2_NUM + TRB->C2_ITEM + TRB->C2_SEQUEN	, NIL})
		aAdd(_aOP, {"D3_COD"	,	TRB->C2_PRODUTO	, NIL})
		
		DbSelectArea('SC2')
		DbSeek(TRB->C2_FILIAL + TRB->C2_NUM + TRB->C2_ITEM + TRB->C2_SEQUEN,.f.)
		DbSelectArea('SD3')
		DbSetOrder(1)
		If DbSeek(TRB->C2_FILIAL + TRB->C2_NUM + TRB->C2_ITEM + TRB->C2_SEQUEN + '  ' + TRB->C2_PRODUTO,.f.)		
			MA250Encer('SD3',Recno(),5)                                                
		EndIf
		//MsExecAuto({|x,y,z| Mata250(x,y,z)}, _aOP, 5)
		
	EndIf
	
	DbSelectArea('TRB')
	DbSkip()
	
EndDo

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
///////////////////////////
Local j,i
cAlias := Alias()
aPerg  := {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd( aPerg , {cPerg, "01", "Data de                            ", "","", "mv_ch1", "D",  8 , 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "", "",""})
aAdd( aPerg , {cPerg, "02", "Data até                           ", "","", "mv_ch2", "D",  8 , 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "", "",""})
aAdd( aPerg , {cPerg, "03", "Encerrar                           ", "","", "mv_ch3", "N",  1 , 0, 0, "C", "", "mv_par03", "Não Atendidas", "", "", "", "", "Parcialmente Atendidas", "", "", "", "", "Todas", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "", "",""})
aAdd( aPerg , {cPerg, "04", "Ordem Prod de                      ", "","", "mv_ch4", "C",  6 , 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "", "",""})
aAdd( aPerg , {cPerg, "05", "Ordem Prod até                     ", "","", "mv_ch5", "C",  6 , 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "", "",""})


DbSelectArea("SX1")
DbSetOrder(1)
For i:=1 to Len(aPerg)
	RecLock("SX1",!DbSeek(cPerg + aPerg[i,2]))
	For j:=1 to FCount()
		If j <= Len(aPerg[i]) .and. !(left(alltrim(FieldName(j)),6) $ 'X1_PRE/X1_CNT')
			FieldPut(j,aPerg[i,j])
		EndIf
	Next
	MsUnlock()
Next

DbSelectArea(cAlias)
Return



/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function MA250Encer(cAlias,nReg,nOpc)
////////////////////////////////////////////

Local bCampo     := {|nCpo| Field(nCpo) }
Local cMascara	 := GetMv("MV_MASCGRD")
Local nProdProp  := GetMV("MV_PRODPR0",NIL,1)
Local nTamRef	 := Val(Substr(cMascara,1,2))

Local lMonta     := .F.
Local lParcTot   := .F.
Local lQuery	 := .F.
Local lContinua	 := .T.

Local cCodRef	 := ''
Local cNumOP     := ''
Local cSeqPai    := ''
Local aAreaSD3   := ''
Local cQuery	 := ''
Local cAliasNew	 := ''

Local nQuant     := 0
Local nQuant2UM  := 0
Local nPerda     := 0
Local cOpOrig    := 0
Local i          := 0

Local aTam		 := {}

Local cOp, nRecSD3
Local nOpca, oDlg

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se devera' encerrar ou nao todos os itens da Grade     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lEncGrd   := .T.

Private aTELA[0][0],aGETS[0]
Private dDataFec	:= iif(FindFunction("MVUlmes"),MVUlmes(),GetMV("MV_ULMES"))
Private lIntQual	:=.F.
Private lDelOpSC 	:= GetMV("MV_DELOPSC")== "S"
Private lProdAut 	:= GetMv("MV_PRODAUT")

dbSelectArea(cAlias)
If Subs(D3_CF,1,2) == "ER"
	//Help(" ",1,"A250MOVEST")
	lContinua := .F.
ElseIf Subs(D3_CF,1,2) != "PR"
	//Help(" ",1,"A250NAO")
	lContinua := .F.
ElseIf D3_ESTORNO == "S"
	//Help(" ",1,"A250ESTORN")
	lContinua := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar data do ultimo fechamento em SX6.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lContinua .And. dDataFec >= dDataBase
	//Help ( " ", 1, "FECHTO" )
	lContinua := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a Ordem de Producao nao foi encerrada por outra estacao  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lContinua .And. SC2->(dbSeek(xFilial("SC2")+Alltrim(SD3->D3_OP))) .And. !Empty(SC2->C2_DATRF)
	//Help(" ",1,"A250ENCERR")
	lContinua := .F.
EndIf

If lContinua
	aAreaSD3:= SD3->(GetArea())
	cNum 	:= SD3->D3_DOC
	cItemGrd:= Right(SD3->D3_OP,Len(SC2->C2_ITEMGRD))
	cNumOp  := Substr(SD3->D3_OP,1,Len(SD3->D3_OP)-Len(cItemGrd))
	cOpOrig := SD3->D3_OP
	cDoc    := SD3->D3_DOC
	cSeqPai := SC2->C2_SEQPAI
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se for encerrar todos os itens da Grade,a Enchoice sera' mon-³
	//³ tada de acordo com as variaveis de memoria, caso contrario,  ³
	//³ sera' montada baseando-se no registro corrente no SD3        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lEncGrd .And. !Empty(cItemGrd)
		lMonta := .T.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Salva a integridade dos campos de Bancos de Dados            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For i := 1 To FCount()
			M->&(EVAL(bCampo,i)) := FieldGet(i)
		Next i
		dbSetOrder(2)
		dbSeek(xFilial("SD3")+cDoc)
		aAreaSD3:=SD3->(GetArea())
		lQuery := .T.
		cAliasNew := GetNextAlias()

		cQuery := " SELECT SUM(D3_QUANT) QTD, SUM(D3_QTSEGUM) QTSEGUM, SUM(D3_PERDA) PERDA FROM "+RetSqlName('SD3')
		cQuery += " WHERE "
		cQuery += " D3_FILIAL = '"+xFilial("SD3")+"' AND "
		cQuery += " D3_DOC = '"+cDoc+"' AND "
		cQuery += " D3_ESTORNO <> 'S' AND "
		cQuery += " D3_CF = 'PRO' AND "

		DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasNew,.F.,.T.)
		aTam := TamSx3("D3_QUANT")
		TCSetField( cAliasNew, "QTD", "N",aTam[1] , aTam[2] )
		aTam := TamSx3("D3_QTSEGUM")
		TCSetField( cAliasNew, "QTSEGUM", "N",aTam[1] , aTam[2] )
		aTam := TamSx3("D3_PERDA")
		TCSetField( cAliasNew, "PERDA", "N",aTam[1] , aTam[2] )
		If lQuery
			nQuant 	:= (cAliasNew)->QTD
			nQuant2UM	:= (cAliasNew)->QTSEGUM
			nPerda		:= (cAliasNew)->PERDA
			(cAliasNew)->(DbCloseArea())
			SD3->(RestArea(aAreaSD3))
		Else
			Do While ! Eof() .And. D3_FILIAL+SD3->D3_DOC == xFilial("SD3")+cDoc
				If D3_ESTORNO != "S" .And. D3_CF == "PR0"
					nQuant+= D3_QUANT
					nQuant2UM += D3_QTSEGUM
					nPerda+=D3_PERDA
				EndIf
				dbSkip()
			EndDo
		EndIf
		
		If FindFunction("MsMatGrade") .And. IsAtNewGrd()
			cCodRef		 := M->D3_COD
			MatGrdPrrf(@cCodRef,.T.)
			M->D3_COD    := cCodRef
		Else
			M->D3_COD    := Substr(M->D3_COD,1,nTamRef)
		EndIf
		
		M->D3_QUANT  := nQuant
		M->D3_QTSEGUM:= nQuant2UM
		M->D3_PERDA  := nPerda
		M->D3_LOTECTL:= ' '
		M->D3_OP     := Substr(M->D3_OP,1,Len(M->D3_OP)-Len(cItemGrd))
	EndIf
	
	nOpca:= If( (!lIntQual) .Or. A250EndOk(), 2, 0)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa funcao que encerra OP              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpcA == 2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Quando utiliza proporcionalizacao tipo 3   ³
		//³ no recalculo do custo medio pergunta se    ³
		//³ altera tipo do apontamento                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nProdProp == 3
			lParcTot:=If(Type("lProdTotal") <> "U", lProdTotal,.F.)
		EndIf
		
		RestArea(aAreaSD3)
		
		Do While !Eof() .And. D3_FILIAL+D3_DOC == xFilial("SD3")+cDoc
			
			If !(D3_CF $ "PR0/PR1")
				dbSkip()
				loop
			EndIf
			If !lEncGrd .And. Right(SD3->D3_OP,Len(SC2->C2_ITEMGRD))!=cItemGrd
				dbSkip()
				loop
			EndIf
			If SC2->(dbSeek(xFilial("SC2")+SD3->D3_OP)) .And. Empty(SC2->C2_DATRF)
				If (SC2->C2_SEQPAI > cSeqPai .Or. (SC2->C2_SEQPAI == cSeqPai .And. SD3->D3_OP == cOpOrig))
					If lParcTot
						Reclock("SD3",.F.)
						Replace D3_PARCTOT With "T"
						MsUNlock()
					EndIf
					A250End(.T.)
				EndIf
			EndIf
			dbSelectArea("SD3")
			SD3->(dbSkip())
			
		EndDo
	EndIf
EndIf
dbSelectArea(cAlias)
Return
