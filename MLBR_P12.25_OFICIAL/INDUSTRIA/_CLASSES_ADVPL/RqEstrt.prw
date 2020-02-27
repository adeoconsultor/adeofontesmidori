#include "totvs.ch"

//======================================================================================
// Estrut2 - Alessandro Freire - 26/12/2017
// Cria tabela temporária com a estrutura de um determinado produto

//Nome			Tipo		Descrição	
//cProduto		Caracter	Código do Produto a ser pesquisado.	(obrigatorio)	
//nQuantidade	Numérico	Quantidade a ser explodida.	(obrigatorio)
//cAliasEstru	Caracter	Alias do Arquivo de Trabalho a ser criado (Default=ESTRUT).		
//oTempTable	Objeto		Nome do objeto utilizado para tabela temporária (pode ser Nil).			
//lAsShow		Lógico		Monta a estrutura exatamente como visualizado na tela (pode ser Nil).			
//lPreEstru		Lógico		Determina se será considerada uma pré-estrutura (SGG) em vez de uma estrutura (SG1) (pode ser Nil).			
//======================================================================================
User Function RQEstrt(cProduto,nQuant,cAliasEstru,cArqTrab,lAsShow,lPreEstru)
LOCAL nRegi:=0,nQuantItem:=0
LOCAL aCampos:={},aTamSX3:={},lAdd:=.F.
LOCAL nRecno
LOCAL cCodigo,cComponente,cTrt,cGrOpc,cOpc
Local cSeek := ""
DEFAULT lPreEstru := .F.

cProduto := Trim( cProduto )
cAliasEstru:=IF(cAliasEstru == NIL,"ESTRUT",cAliasEstru)
nQuant:=IF(nQuant == NIL,1,nQuant)
lAsShow:=IF(lAsShow==NIL,.F.,lAsShow)
nEstru++
If nEstru == 1
	// Cria arquivo de Trabalho
	AADD(aCampos,{"NIVEL","C",6,0})
	aTamSX3:=TamSX3(If(lPreEstru,"GG_COD","G1_COD"))
	AADD(aCampos,{"CODIGO","C",aTamSX3[1],0})
	aTamSX3:=TamSX3(If(lPreEstru,"GG_COMP","G1_COMP"))
	AADD(aCampos,{"COMP","C",aTamSX3[1],0})
	aTamSX3:=TamSX3(If(lPreEstru,"GG_QUANT","G1_QUANT"))
	AADD(aCampos,{"QUANT","N",Max(aTamSX3[1],18),aTamSX3[2]})
	aTamSX3:=TamSX3(If(lPreEstru,"GG_TRT","G1_TRT"))
	AADD(aCampos,{"TRT","C",aTamSX3[1],0})
	aTamSX3:=TamSX3(If(lPreEstru,"GG_GROPC","G1_GROPC"))
	AADD(aCampos,{"GROPC","C",aTamSX3[1],0})
	aTamSX3:=TamSX3(If(lPreEstru,"GG_OPC","G1_OPC"))
	AADD(aCampos,{"OPC","C",aTamSX3[1],0})
	// NUMERO DO REGISTRO ORIGINAL
	AADD(aCampos,{"REGISTRO","N",14,0})
	cArqTrab := CriaTrab(aCampos)
	If Select(cAliasEstru) > 0
		dbSelectArea(cAliasEstru)
		dbCloseArea()
	EndIf
	Use &cArqTrab NEW Exclusive Alias &(cAliasEstru)
	IndRegua(cAliasEstru,cArqTrab,"NIVEL+CODIGO+COMP+TRT",,,"Selecionando Registros...") //"Selecionando Registros..."
	dbSetIndex(cArqtrab+OrdBagExt())
EndIf
dbSelectArea(If(lPreEstru,"SGG","SG1"))
dbSetOrder(1)
cSeek := xFilial(If(lPreEstru,"SGG","SG1"))
cSeek += cProduto
dbSeek(xFilial()+cProduto)
While !Eof() .And. Trim(If(lPreEstru,SGG->GG_FILIAL+SGG->GG_COD,SG1->G1_FILIAL+SG1->G1_COD)) == cSeek // Trim(xFilial()+cProduto)
	nRegi:=Recno()
	cCodigo    :=If(lPreEstru,GG_COD,G1_COD)
	cComponente:=If(lPreEstru,GG_COMP,G1_COMP)
	cTrt       :=If(lPreEstru,GG_TRT,G1_TRT)
	cGrOpc     :=If(lPreEstru,GG_GROPC,G1_GROPC)
	cOpc       :=If(lPreEstru,GG_OPC,G1_OPC)
	If cCodigo != cComponente
		lAdd:=.F.
		If !(&(cAliasEstru)->(dbSeek(StrZero(nEstru,6)+cCodigo+cComponente+cTrt))) .Or. (lAsShow)
			nQuantItem:=ExplEstr(nQuant,nil,nil,nil,nil,lPreEstru)
			dbSelectArea( cAliasEstru )
//			RecLock(cAliasEstru,.T.)
			DBAPPEND()
			Replace NIVEL    With StrZero(nEstru,6)
			Replace CODIGO   With cCodigo
			Replace COMP     With cComponente
			Replace QUANT    With nQuantItem
			Replace TRT      With cTrt
			Replace GROPC    With cGrOpc
			Replace OPC      With cOpc
			Replace REGISTRO With If(lPreEstru,SGG->(Recno()),SG1->(Recno()))
			MsUnlock()
			DBCOMMIT()
			lAdd:=.T.
			dbSelectArea(If(lPreEstru,"SGG","SG1"))
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe sub-estrutura                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRecno:=Recno()
		IF dbSeek(xFilial()+cComponente)
			cCodigo:=If(lPreEstru,GG_COD,G1_COD)
			Estrut2(cCodigo,nQuantItem,cAliasEstru,cArqTrab,lAsShow,lPreEstru)
			nEstru --
		Else
			dbGoto(nRecno)
			If !(&(cAliasEstru)->(dbSeek(StrZero(nEstru,6)+cCodigo+cComponente+cTrt))) .Or. (lAsShow.And.!lAdd)
				nQuantItem:=ExplEstr(nQuant,nil,nil,nil,nil,lPreEstru)
				RecLock(cAliasEstru,.T.)
				Replace NIVEL    With StrZero(nEstru,6)
				Replace CODIGO   With cCodigo
				Replace COMP     With cComponente
				Replace QUANT    With nQuantItem
				Replace TRT      With cTrt
				Replace GROPC    With cGrOpc
				Replace OPC      With cOpc
				Replace REGISTRO With If(lPreEstru,SGG->(Recno()),SG1->(Recno()))
				MsUnlock()
				dbSelectArea(If(lPreEstru,"SGG","SG1"))
			EndIf
		Endif
	EndIf
	dbGoto(nRegi)
	dbSkip()
Enddo
Return cArqTrab

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³FimEstrut2³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 04/02/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Encerra arquivo utilizado na explosao de uma estrutura     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ FimEstrut2(ExpC1,ExpC2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do Arquivo de Trabalho                       ³±±
±±³          ³ ExpC2 = Nome do Arquivo de Trabalho                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function FimEstru(cAliasEstru,cArqTrab)
cAliasEstru:=IF(cAliasEstru == NIL,"ESTRUT",cAliasEstru)
dbSelectArea(cAliasEstru)
dbCloseArea()
FErase(AllTrim(cArqTrab)+GetDBExtension())
FErase(AllTrim(cArqTrab)+OrdBagExt())
Return
