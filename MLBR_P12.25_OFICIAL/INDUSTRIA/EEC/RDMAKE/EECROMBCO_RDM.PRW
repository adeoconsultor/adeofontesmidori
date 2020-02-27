Static __nExeDel  := 0

#INCLUDE "Rwmake.ch"
#INCLUDE "Average.ch"

//+-----------------------------------------------------------------------------------//
//|Funcao....: U_EECROMBCO()
//|Autor.....: Luis Henrique - DQZAFRA - 05-11-2010
//|Descricao.: Função para Inicialização das variaveis e montagem do browse
//|Observação:
//+-----------------------------------------------------------------------------------//

User Function EECROMBCO

Local nInd

Private _cRomaneio:=""
Private _lMantem := .f.

Private aRotina := { { "Pesquisar" ,"AxPesqui"      , 0 , PESQUISAR},; //"Pesquisar"
{ "Visualizar","U_PREPROMBCO"  , 0 , VISUALIZAR},; //"Visualizar"
{ "Incluir"   ,"U_PREPROMBCO"  , 0 , INCLUIR},; //"Incluir"
{ "Alterar"   ,"U_PREPROMBCO"  , 0 , ALTERAR},; //"Alterar"
{ "Excluir"   ,"U_PREPROMBCO"  , 0 , EXCLUIR,3},; //"Excluir"
{ "Etiquetas"   ,"U_MDETIQ"  , 0 , INCLUIR,},;//"Excluir"
{ "Packing List"   ,"U_MDROMBC2"  , 0 , VISUALIZAR,} } //"Excluir"


/*
Private aRotina := { 	{ OemToAnsi("Pesquisar"), "AxPesqui"  , 	0, 1},; 	//"Pesquisar"
{ OemToAnsi("Preparar"), "U_PREPROMBCO", 	0, 3}}  	//"Visualizar"
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCadastro 	:= OemToAnsi("Planilha Romaneio Banco ") //"Aprovacao de Aparencia"

Private aSize	  := MsAdvSize(,.F.,430)
Private aObjects  := {}
Private aPosObj   := {}
Private aSizeAut  := MsAdvSize() // devolve o tamanho da tela atualmente no micro do usuario

AAdd( aObjects, { 315,  70, .T., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )

aInfo   := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

Private aTela[0][0],aGets[0]

Private nTamLin		:= 75
Private cAlias2     := ""
Private cAlias1     := ""

FOR nInd := 1 TO ZZC->(FCount())
	M->&(ZZC->(FIELDNAME(nInd))) := ZZC->(CRIAVAR(FIELDNAME(nInd)))
NEXT

DbSelectArea("ZZC")
DbSetOrder(1)

mBrowse( 6, 1, 22, 75,"ZZC",,,,,,)
SET FILTER TO
Return


//+-----------------------------------------------------------------------------------//
//|Funcao....: U_PrepRomBco()
//|Autor.....: Luis Henrique - DQZAFRA - 05-11-2010
//|Descricao.: Função para montagem da tela de edição
//|Observação:
//+-----------------------------------------------------------------------------------//
User Function PREPROMBCO(cAlias,nReg,nOpc)

Local oDlg		:= NIL
Local lOk 		:= .F.
Local aCposVis	:= {}
Local aCposNao	:= {}
Local aButtons	:= {}
Local nInd

Private aHeader	:= {}
Private aCols	:= {}
Private nUsado	:=	0
Private oGet	:= NIL

Private aTela[0][0],aGets[0]

If nOpc == EXCLUIR
	If MsgYesno("Confirma a Exclusao?","Atenção")
		Processa({ ||RomExclui() })
		ZZC->(dbskip())
		ZZC->(dbskip(-1))
	Endif
	Return .T.
Endif


cAlias:="ZZC"
cAlias1:="ZZC"
cAlias2:="ZZD"

/*
If Inclui
nOpc:=INCLUIR
Endif
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Enchoice Modelo3                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


DEFINE MSDIALOG oDlg TITLE OemToAnsi("Romaneio - Banco Couro") ; //"Aprovacao de Aparencia"
FROM aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta vetor aHeader a ser utilizado na getdados              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ROMAhead(cAlias2)


nPosValorB	:= Ascan(aHeader	, {|e| Alltrim(e[2]) == "ZZD_PESOB" } )
nPosValorL	:= Ascan(aHeader	, {|e| Alltrim(e[2]) == "ZZD_PESOL" } )

nUsado	:= Len(aHeader)

ROMAcols(nOpc)

//RegToMemory(cAlias,.T.)

If Inclui
	
	if ! _lMantem
		FOR nInd := 1 TO ZZC->(FCount())
			M->&(ZZC->(FIELDNAME(nInd))) := ZZC->(CRIAVAR(FIELDNAME(nInd)))
		NEXT
	Else
        M->ZZC_NRROM := CRIAVAR("ZZC_NRROM")
	Endif        

	
Else
	If ! Empty(ZZC->ZZC_NRROM)
		//nOpc:=4
		FOR nInd := 1 TO ZZC->(FCount())
			ZZC->( M->&(FIELDNAME(nInd)) := FieldGet(nInd) )
		NEXT
	Endif
Endif

M->ZZC_CLIENT :=EEC->EEC_IMPORT
M->ZZC_NOME   :=POSICIONE("SA1",1,XFILIAL("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA,"A1_NOME")






//oEnch1 := MsMGet():New( cAlias, nReg, nOpc,,,,,PosDlgUp(oDlg))
oEnch1 := MsMGet():New( cAlias, nReg, nOpc,,,,,aPosObj[1])

aButtons:={}
//aButtons := {	{"EDIT", { || QPP210APRO(nOpc) }, OemToAnsi( STR0007 )}} //"Aprovar/Limpar"

DbSelectArea(cAlias2)



cLinhaOk  	:= "U_RomBcoLinOk()"
cTudoOk 	:= "U_RomBcoAllOk()"
cFieldOk 	:= "U_RomBcoCpoOk()"
cDelOk		:= "U_RomBcoDelOk()"

//oGet 		:= MSGetDados():New(aPosObj[2,1]-40,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]           , nOpc,cLinhaOk       ,cTudoOk, ,.T.      ,, ,,   ,cFieldOk,,,cDelOk)
oGet 		:= MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]           , nOpc,cLinhaOk       ,cTudoOk, ,.T.      ,, ,,   ,cFieldOk,,,cDelOk)

bValOK:={||oDlg:End()}

If nOpc == INCLUIR  .OR. nOpc == ALTERAR
	bValOK:={||lOk := .t. /*U_DI210TudOk()*/, Iif(Obrigatorio(aGets,aTela) .and. lOk ,If(U_RomBcoOk(),oDlg:End(),lOk:=.F.),)}
Endif


ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bValOK,{||If(MsgYesno("Deseja Sair?","Atenção"),(lOk:=.f.,oDlg:End()),)}, , aButtons)

If lOk
	If nOpc <> EXCLUIR
		Processa({ ||RomGrava(nOpc) })
		nOpc:=0
	Else
		Processa({ ||RomExclui() })
	Endif
Endif



Return



//+-----------------------------------------------------------------------------------//
//|Funcao....: U_RomAcols()
//|Autor.....: Luis Henrique - DQZAFRA - 05-11-2010
//|Descricao.: Função para montagem do acols
//|Observação:
//+-----------------------------------------------------------------------------------//

Static Function RomAcols(nOpc)
Local nCnt, n, nI, nPos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aCols               					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//If ! Inclui
DbSelectArea(cAlias2)
DbSetOrder(1)
If ! DbSeek(xFilial(cAlias2)+ZZC->ZZC_NRROM)
	nOpc:=3
Endif
//Endif

If nOpc == 3
	
	aCols := Array(1,nUsado+1)
	
	For nI = 1 To Len(aHeader)
		If aHeader[nI,8] == "C"
			aCols[1,nI] := Space(aHeader[nI,4])
		ElseIf aHeader[nI,8] == "N"
			aCols[1,nI] := 0
		ElseIf aHeader[nI,8] == "D"
			aCols[1,nI] := CtoD(" / / ")
		ElseIf aHeader[nI,8] == "M"
			aCols[1,nI] := ""
		Else
			aCols[1,nI] := .F.
		EndIf
	Next nI
	
	
	aCols[1,nUsado+1] := .F.
	
Else
	
	Do While !ZZD->(EOF()) .and. ZZD->(ZZD_FILIAL+ZZD_NRROM) == xFilial('ZZD')+ZZC->ZZC_NRROM
		
		aAdd(aCols,Array(nUsado+1))
		
		For nI := 1 to nUsado
			
			If Upper(AllTrim(aHeader[nI,10])) != "V" 	// Campo Real
				
				if alltrim( aHeader[nI,2] ) == "ZZD_NRCX"
					aCols[Len(aCols),nI] := val(FieldGet(FieldPos(aHeader[nI,2])) )
				Else
					aCols[Len(aCols),nI] := FieldGet(FieldPos(aHeader[nI,2]))
				Endif
			Else										// Campo Virtual
				cCpo := AllTrim(Upper(aHeader[nI,2]))
				aCols[Len(aCols),nI] := CriaVar(aHeader[nI,2])
			Endif
			
		Next nI
		
		aCols[Len(aCols),nUsado+1] := .F.
		
		ZZD->(DbSkip())
		
	Enddo
	
Endif

nPosCX      := Ascan(aHeader, {|e| Alltrim(e[2]) == "ZZD_NRCX" } )
asort(aCols,,, {|x,y| y[nPosCX] > x[nPosCX] } )

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: U_RomAhead()
//|Autor.....: Luis Henrique - DQZAFRA - 05-11-2010
//|Descricao.: Função para montagem do aheader
//|Observação:
//+-----------------------------------------------------------------------------------//

Static Function ROMAhead(cAlias)

aHeader := {}
nUsado 	:= 0

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek(cAlias)

Do While !Eof() .and. (X3_ARQUIVO == cAlias)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ignora campos que nao devem aparecer na getdados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If 	Upper(AllTrim(X3_CAMPO)) $ "ZZD_NRROM/ZZD_COD_I"
		DbSkip()
		Loop
	Endif
	
	If X3USO(X3_USADO) .and. cNivel >= X3_NIVEL
		nUsado++
		Aadd(aHeader,{ AllTrim(X3Titulo()),;
		SX3->X3_CAMPO	,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID	,;
		SX3->X3_USADO	,;
		SX3->X3_TIPO	,;
		SX3->X3_F3 		,;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX	,;
		SX3->X3_RELACAO})
		
		If 	alltrim(aheader[len(aHeader),2]) $ "ZZD_NRCX"
			aHeader[len(aHeader),8] := "N"
		Endif
		
	Endif
	
	
	DbSkip()
	
Enddo

Return



//+-----------------------------------------------------------------------------------//
//|Funcao....: U_RomGrava
//|Autor.....: Luis Henrique - DQZAFRA - 05-11-2010
//|Descricao.: Função para gravação dos dados da tela
//|Observação:
//+-----------------------------------------------------------------------------------//

Static Function RomGrava(nOpc)

Local nIt,nCpo
Local nCont
Local nPosDel 		:= Len(aHeader) + 1
Local bCampo		:= { |nCPO| Field(nCPO) }
Local lGraOk 		:= .T.   // Indica se todas as gravacoes obtiveram sucesso
Local cAtividade	:= "11    " // Definido no SX5 - QF
Local aAVAP1		:= {}  // Array para converter o texto
Local _nNrKits		:= 0
Local _nPesoL		:= 0
Local _nPesoB		:= 0

//Local aCposChaves   :={"_REF","_PROC"}

ProcRegua(Len(aCols))


Begin Transaction


DbSelectArea(cAlias2)
DbSetOrder(1)
dbSeek(xfilial(cAlias2)+M->ZZC_NRROM)
While ! eof() .and. xfilial(cAlias2)+M->ZZC_NRROM == ZZD->ZZD_FILIAL + ZZD->ZZD_NRROM
	
	Reclock(cAlias2,.f.)
	dbdelete()
	MsUnlock()
	dbSkip()
	
End


For nIt := 1 To Len(aCols)
	
	IncProc("Gravando registros...")
	
	If !aCols[nIt, nPosDel]  // Verifica se o item foi deletado
		
		RecLock(cAlias2,.T.)
		
		For nCpo := 1 To Len(aHeader)
			If aHeader[nCpo, 10] <> "V"
				if alltrim(aheader[nCpo,2]) <> "ZZD_NRCX"
					(cAlias2)->(FieldPut(FieldPos(Trim(aHeader[nCpo, 2])),aCols[nIt, nCpo]))
				Else
					ZZD->ZZD_NRCX := strzero(aCols[nIt, nCpo],3)
				Endif
			EndIf
		Next nCpo
		
		ZZD->ZZD_FILIAL	:=xFilial('ZZD')
		ZZD->ZZD_NRROM	:=M->ZZC_NRROM
		ZZD->ZZD_REF	:=M->ZZC_REF
		ZZD->ZZD_COD_I 	:=M->ZZC_COD_I
		_nNrKits 	+= ZZD->ZZD_QTDE
		_nPesoL 	+= ZZD->ZZD_PESOL
		_nPesoB 	+= ZZD->ZZD_PESOB
		
	Endif
	(cAlias2)->(MsUnlock())
	
Next nIt

DbSelectArea(cAlias1)
DbSetOrder(1)

lInclui:=.f.
If ! ZZC->(dbseek(xFilial('ZZC')+M->ZZC_NRROM+M->ZZC_COD_I))
	lInclui:= .t.
Endif

If lInclui
	RecLock(cAlias1,.T.)
Else
	RecLock(cAlias1,.F.)
Endif

For nCont := 1 To (cAlias1)->(FCount())
	
	IncProc("Gravando registros...")
	
	If "FILIAL"$(cAlias1)->(Field(nCont))
		(cAlias1)->(FieldPut(nCont,xFilial(cAlias1)))
	Else
		(cAlias1)->(FieldPut(nCont,M->&(EVAL(bCampo,nCont))))
	Endif
Next nCont

ZZC->ZZC_QTKIT	:=_nNrKits
ZZC->ZZC_PESOL	:= _nPesoL  				// Peso liquido dos componentes
ZZC->ZZC_PESOB	:= _nPesoB   				//Peso bruto dos componentes + pallet

MsUnLock()

confirmSX8()
End Transaction


Return lGraOk


//+-----------------------------------------------------------------------------------//
//|Funcao....: U_RomBcoLinOk
//|Autor.....:
//|Descricao.: Função para validação da linha do acols
//|Observação:
//+-----------------------------------------------------------------------------------//

User Function RomBcoLinOk(nx)

Local lRetorno 	:= .T.
Local nPosDel 	:= Len(aHeader) + 1
Local nCpo

Return lRetorno


//+-----------------------------------------------------------------------------------//
//|Funcao....: U_RomBcodel()
//|Autor.....:
//|Descricao.: Função
//|Observação:
//+-----------------------------------------------------------------------------------//


User Function RomBcodel()
//Local nPosValorB	:= Ascan(aHeader	, {|e| Alltrim(e[2]) == "ZZD_PESOB" } )
//Local nPosValorL	:= Ascan(aHeader	, {|e| Alltrim(e[2]) == "ZZD_PESOL" } )

__nExeDel++
// Como esta rotina eh chamada duas vezes pela exclusao na GetDados, controlar
// as chamadas para nao ocorrer erro nos calculos dos dados do rodape
If (__nExeDel%2)==0
	Return .T.
Endif

// Registro deletado -> eh o contrario pois pressionou <DEL> e o arquivo ainda esta com Flag trocado
If !GdDeleted()
	M->ZZC_PESOB -= aCols[n][nPosValorB]
	M->ZZC_PESOL -= aCols[n][nPosValorL]
Else
	M->ZZC_PESOB += aCols[n][nPosValorB]
	M->ZZC_PESOL += aCols[n][nPosValorL]
EndIf

If Type("oEnch1")=="O"
	oEnch1:Refresh()
Endif

Return .T.


//+-----------------------------------------------------------------------------------//
//|Funcao....: U_RomWhen()
//|Autor.....:
//|Descricao.: Função
//|Observação:
//+-----------------------------------------------------------------------------------//


User Function RomWhen()

Local cVar:=ReadVar()

If Empty(&(cVar))
	Return .t.
Endif

If "PESOB" $ cVar
	M->ZZC_PESOB -= M->ZZD_PESOB//aCols[n][nPosValorB]
Else
	M->ZZC_PESOL -= M->ZZD_PESOL//aCols[n][nPosValorL]
Endif

oEnch1:Refresh()

Return .T.


//+-----------------------------------------------------------------------------------//
//|Funcao....: U_RomValid()
//|Autor.....:
//|Descricao.: Função
//|Observação:
//+-----------------------------------------------------------------------------------//

User Function RomValid()

Local cVar:=ReadVar()

If "PESOB" $ cVar
	M->ZZC_PESOB += M->ZZD_PESOB//aCols[n][nPosValorB]
Else
	M->ZZC_PESOL += M->ZZD_PESOL//aCols[n][nPosValorL]
Endif
oEnch1:Refresh()

Return .T.

Static Function RomExclui()

lExclui:=.f.
ZZD->(dbsetorder(1))
ZZD->(dbseek(xFilial('ZZD')+ZZC->ZZC_NRROM))
While ! zzd->(eof()) .and. zzd->(zzd_filial+zzd_nrRom) == xFilial('ZZD')+ZZC->ZZC_NRROM
	ZZD->(RecLock("ZZD",.F.))
	ZZD->(dbdelete())
	ZZD->(MsUnLock())
	ZZD->(dbskip())
	lExclui:=.t.
End

If lexclui
	ZZC->(RecLock("ZZC",.F.))
	ZZC->(dbdelete())
	ZZC->(MsUnlock())
Endif

Return .t.


//+-----------------------------------------------------------------------------------//
//|Funcao....: U_EECRBANGET()
//|Autor.....:
//|Descricao.: Função para Get no romaneio de banco
//|Observação:
//+-----------------------------------------------------------------------------------//
User Function EECRBANGET()

EE5->(dbSetOrder(1))
If EE5->(dbSeek(xFilial("EE5")+M->ZZC_EMBAL))
	M->ZZC_DIM   := EE5->EE5_DIMENS
	M->ZZC_DESC  := EE5->EE5_DESC
	M->ZZC_PESO  := EE5->EE5_PESO
	M->ZZC_PESOB := EE5->EE5_PESO
	M->ZZC_CUBAGE:= EE5->EE5_CCOM * EE5->EE5_LLARG * EE5->EE5_HALT
EndIf

Return .T.



//+-----------------------------------------------------------------------------------//
//|Funcao....: U_RBCESTRU()
//|Autor.....: Luis Henrique - DQZAFRA - 05-11-2010
//|Descricao.: Função para explodir a estrutura do PA no acols
//|Observação:
//+-----------------------------------------------------------------------------------//

User Function RBCESTRU(_cProdutoPA)
Local _aArea := getArea()
Local _nP_NRCX		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_NRCX"})
Local _nP_NRPART	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_NRPART"})
Local _nP_DESC		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_DESC"})
Local _nP_QTDE		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_QTDE"})
Local _nP_PESOB		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_PESOB"})
Local _nP_PESOL		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_PESOL"})
Local _nP_SERIAL	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_SERIAL"})
Local _nP_PRODUTO	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_CODIGO"})

Local _nCx,_nx,nI := 0

dbSelectArea("ZZD")
dbSetOrder(2)
dbSeek(xfilial("ZZD")+M->ZZC_REF)
While ! eof() .and. xfilial("ZZD")+M->ZZC_REF == ZZD->ZZD_FILIAL + ZZD->ZZD_REF
	IF val(ZZD->ZZD_NRCX) > _nCx
		_nCx := val(ZZD->ZZD_NRCX)
	Endif
	ZZD->(dbSkip())
End

For _nx := 1 to len(aCols)
	
	if aCols[_nx][_nP_NRCX] > _nCx
		_nCx := aCols[_nx][_nP_NRCX]
	Endif
	
Next
_nCx += 1


dbSelectArea("EE7")
dbSetOrder(1)
dbSeek(xfilial("EE7")+M->ZZC_PEDIDO)

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xfilial("SA1")+EE7->EE7_IMPORT+EE7->EE7_IMLOJA)

dbSelectArea("SYA")
dbSetOrder(1)
dbSeek(xfilial("SYA")+SA1->A1_PAIS)

dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xfilial("SC5")+EE7->EE7_PEDFAT)

dbSelectArea("SC6")
dbSetOrder(2) // FILIAL+PRODUTO+NUM
dbSeek(xfilial("SC6")+&_cProdutoPA+EE7->EE7_PEDFAT)

if M->ZZC_PRADO == "N"
	
	dbSelectArea("SG1")
	dbSetOrder(1)
	dbSeek(xfilial("SG1")+&_cProdutoPA)
	While ! eof() .and. xfilial("SG1")+&_cProdutoPA == SG1->G1_FILIAL+SG1->G1_COD
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xfilial("SB1")+SG1->G1_COMP)
		
		dbSelectArea("EE2")
		dbSetOrder(1)
		dbSeek(xfilial("EE2")+'3*'+SYA->YA_IDIOMA+SG1->G1_COMP)
		
		////////////q
		
		_n := len(aCols)
		if ! empty(	aCols[len(aCols)][_nP_PRODUTO] )
			
			aColsTmp := Array(1,nUsado+1)
			aadd(aCols,aColsTmp[1])
			_n := len(aCols)
			
			For nI = 1 To Len(aHeader)
				If aHeader[nI,8] == "C"
					aCols[_n,nI] := Space(aHeader[nI,4])
				ElseIf aHeader[nI,8] == "N"
					aCols[_n,nI] := 0
				ElseIf aHeader[nI,8] == "D"
					aCols[_n,nI] := CtoD(" / / ")
				ElseIf aHeader[nI,8] == "M"
					aCols[_n,nI] := ""
				Else
					aCols[_n,nI] := .F.
				EndIf
			Next nI
			
			aCols[_n,nUsado+1] := .F.
			
		Endif
		
		///////////////q
		
		aCols[_n][_nP_NRCX] 	:= _nCx
		_nCx++
		
		aCols[_n][_nP_PRODUTO] 	:= SG1->G1_COMP
		aCols[_n][_nP_NRPART] 	:= GETADVFVAL("SB1","B1_ATLREF",XFILIAL("SB1")+SG1->G1_COMP,1,"")
		
		_cDescric := MSMM(EE2_TEXTO)
		if empty(_cDescric)
			_cDescric := SB1->B1_DESC
		Endif
		
		
		aCols[_n][_nP_DESC] 	:= _cDescric
		aCols[_n][_nP_QTDE] 	:= ( SC6->C6_QTDVEN - SC6->C6_QTDENT ) * SG1->G1_QUANT  //SALDO DO PEDIDO * QUANT DA ESTRUTURA
		
		aCols[_n][_nP_PESOB] 	:= U_CalcPesoB()
		
		aCols[_n][_nP_PESOL] 	:= SB1->B1_PESO
		aCols[_n][_nP_SERIAL] 	:= M->ZZC_SERIAL
		
		dbSelectArea("SG1")
		dbSkip()
		
	End
	
ELSE
	
	dbSelectArea("ZZD")
	dbSetOrder(3) //ZZD_FILIAL+ZZD_COD_I+ZZD_REF
	dbSeek(xfilial("ZZC")+&_cProdutoPA+"ESTRUTURA")
	While ! eof() .and. xfilial("ZZD")+&_cProdutoPA+"ESTRUTURA" == ZZD->ZZD_FILIAL+ZZD->ZZD_COD_I+SUBSTR(ZZD->ZZD_REF,1,9)
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xfilial("SB1")+ZZD->ZZD_CODIGO)
		
		dbSelectArea("EE2")
		dbSetOrder(1)
		dbSeek(xfilial("EE2")+'3*'+SYA->YA_IDIOMA+ZZD->ZZD_CODIGO)
		
		////////////q
		
		_n := len(aCols)
		if ! empty(	aCols[len(aCols)][_nP_PRODUTO] )
			
			aColsTmp := Array(1,nUsado+1)
			aadd(aCols,aColsTmp[1])
			_n := len(aCols)
			
			For nI = 1 To Len(aHeader)
				If aHeader[nI,8] == "C"
					aCols[_n,nI] := Space(aHeader[nI,4])
				ElseIf aHeader[nI,8] == "N"
					aCols[_n,nI] := 0
				ElseIf aHeader[nI,8] == "D"
					aCols[_n,nI] := CtoD(" / / ")
				ElseIf aHeader[nI,8] == "M"
					aCols[_n,nI] := ""
				Else
					aCols[_n,nI] := .F.
				EndIf
			Next nI
			
			aCols[_n,nUsado+1] := .F.
			
		Endif
		
		///////////////q
		
		aCols[_n][_nP_NRCX] 	:= _nCx
        
		if _fSomaCaixa(ZZD->ZZD_CODIGO)
			_nCx++
		Endif
		
		aCols[_n][_nP_PRODUTO] 	:= ZZD->ZZD_CODIGO
		aCols[_n][_nP_NRPART] 	:= GETADVFVAL("SB1","B1_ATLREF",XFILIAL("SB1")+ZZD->ZZD_CODIGO,1,"")
		
		_cDescric := MSMM(EE2_TEXTO)
		if empty(_cDescric)
			_cDescric := ZZD->ZZD_DESC
		Endif
		
		
		aCols[_n][_nP_DESC] 	:= _cDescric
//		aCols[_n][_nP_QTDE] 	:= ( SC6->C6_QTDVEN - SC6->C6_QTDENT ) * ZZD->ZZD_QTDE  //SALDO DO PEDIDO * QUANT DA ESTRUTURA
		aCols[_n][_nP_QTDE] 	:= ZZD->ZZD_QTDE		
		aCols[_n][_nP_PESOB] 	:= U_CalcPesoB()
		
		aCols[_n][_nP_PESOL] 	:= SB1->B1_PESO
		aCols[_n][_nP_SERIAL] 	:= M->ZZC_SERIAL
		
		dbSelectArea("ZZD")
		dbSkip()
		
	End
	
	
ENDIF


oGet:oBrowse:Refresh(.T.)

RestArea(_aArea)
RETURN(&_cProdutoPA)


//+-----------------------------------------------------------------------------------//
//|Funcao....: U_RomBcoCpoOk()
//|Autor.....: Luis Henrique - DQZAFRA - 05-11-2010
//|Descricao.: Função FieldOK para validacao dos campos do acols
//|Observação:
//+-----------------------------------------------------------------------------------//

User Function RomBcoCpoOk()
Local _lRet := .t.
Local _aArea := getArea()
Local _nx
Local _nP_PRODUTO	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_CODIGO"})
Local _nP_NRCX		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_NRCX"})
Local _nP_NRPART	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_NRPART"})
Local _nP_DESC		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_DESC"})
Local _nP_QTDE		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_QTDE"})
Local _nP_PESOB		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_PESOB"})
Local _nP_PESOL		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_PESOL"})
Local _nP_SERIAL	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_SERIAL"})


dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xfilial("SG1")+M->ZZC_COD_I)

dbSelectArea("EE7")
dbSetOrder(1)
dbSeek(xfilial("EE7")+M->ZZC_PEDIDO)

dbSelectArea("SC6")
dbSetOrder(2) // FILIAL+PRODUTO+NUM
dbSeek(xfilial("SC6")+M->ZZC_COD_I+EE7->EE7_PEDFAT)

dbSelectArea("SC2")
dbSetOrder(1)
dbSeek(xfilial("SC2")+M->ZZC_SERIAL)

if readvar() <> "M->ZZC_COD_I"
	
	IF alltrim(M->ZZC_COD_I) == alltrim(GETMV("MV_XEMPTY"))
		Return(.t.)
	Endif
	
Else
	
	if alltrim(aCols[n][_nP_PRODUTO]) == alltrim(GET("MV_XEMPTY"))
		Return(.t.)
	Endif
	
Endif

if readvar() == "M->ZZC_COD_I"
	
	
	if SC6->(eof())
		msgalert("Produto não consta do pedido de faturamento.")
		_lRet := .f.
	Endif
	
	if _lRet
		if SC2->(eof())
			_lRet := .f.
		Endif
		
		if _lRet
			_lret := .f.
			While !SC2-(EOF())	.AND. SC2->C2_NUM == M->ZZC_SERIAL
				
				if alltrim(M->ZZC_COD_I) == alltrim(SC2->C2_PRODUTO)
					_lRet := .t.
					exit
				Endif
				SC2->(dbskip())
			End
			
		Endif
		
		if ! _lRet
			msgAlert("Produto não encontrado na ordem de produção")
		Endif
	Endif
	
Endif

if readvar() == "M->ZZD_QTDE"
	
	
	
	
	/*	if M->ZZD_QTDE >  ( SC6->C6_QTDVEN - SC6->C6_QTDENT ) * SG1->G1_QUANT
	msgAlert("Quantidade digitada é superior ao saldo do pedido de faturamento.")
	_lRet := .f.
	Endif
	*/
	
	
	if _lRet
		
		if msgyesno("Replica quantidade para demais itens ?")
			For _nx := n to len(acols)
				acols[_nx][_nP_QTDE] := M->ZZD_QTDE
			Next
		Endif
		
	Endif
	
	
Endif

if readvar() == "M->ZZD_NRPART"
	
	
	if SG1->(eof())
		msgalert("Produto não consta da estrutura do produto modelo.")
		_lRet := .f.
	Endif
	
	if _lRet
		
		if msgyesno("Replica Parts No.  para demais itens ?")
			For _nx := n to len(acols)
				acols[_nx][_nP_NRPART] := M->ZZD_NRPART
			Next
		Endif
		
		if msgyesno("Grava  Parts No.  no cadastro de produtos ?")
			
			dbSelectArea("SB1")
			_nrecno := Recno()
			
			For _nx := n to len(acols)
				dbSetOrder(1)
				dbSeek(xfilial("SB1")+acols[_nx][_nP_PRODUTO])
				Reclock("SB1")
				SB1->B1_ATLREF := M->ZZD_NRPART
				MsUnlock("SB1")
			Next
			
			dbGoTo(_nRecno)
			
		Endif
		
		
	Endif
	
Endif

if readvar() == "M->ZZD_EXTRA"
	
	if !empty(acols[n][_nP_NRPART])
		msgAlert("Produto Extra dever ser digitado em linha sem dados.")
		_lret := .f.
	Endif
	
	if _lRet
		
		dbSelectArea("SC6")
		dbSetOrder(2) // FILIAL+PRODUTO+NUM
		dbSeek(xfilial("SC6")+M->ZZD_EXTRA+EE7->EE7_PEDFAT)
		
		if SC6->(eof())
			msgalert("Produto não consta da estrutura do produto modelo.")
			_lRet := .f.
		Endif
		
	Endif
	
Endif


Return(_lret)


//+-----------------------------------------------------------------------------------//
//|Funcao....: U_RomBcoAllOk()
//|Autor.....: Luis Henrique - DQZAFRA - 05-11-2010
//|Descricao.: Função Validação TUDO OK
//|Observação:
//+-----------------------------------------------------------------------------------//
User Function RomBcoAllOk()
Local _nx := 0
Local _lRet := .t.
Local _nP_NRCX		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_NRCX"})
Local _nNrCX := 0

For _nx := 1 to len(aCols)
	
	if _nx > 1
		
		if aCols[_nx][_nP_NRCX] - 1 <> _nNrCX
			MsgAlert("Existe salto de numeração de caixa entre as caixas "+strzero(_nNrCX,3)+" e "+strzero(aCols[_nx][_nP_NRCX]) )
			_lRet := .f.
			Exit
		Endif
		
	Endif
	
	_nNrCX := aCols[1][_nP_NRCX]
	
Next

Return(_lRet)


//+-----------------------------------------------------------------------------------//
//|Funcao....: U_CalcPesoB()
//|Autor.....: Luis Henrique - DQZAFRA - 05-11-2010
//|Descricao.: Função Calculo do peso bruto unitario
//|Observação:
//+-----------------------------------------------------------------------------------//

User Function CalcPesob()
Local _aArea := getArea()
Local _nPesoB := 0
Local _nPosCX   := Ascan(aHeader, {|e| Alltrim(e[2]) == "ZZD_NRCX" } )
Local _nPosPB   := Ascan(aHeader, {|e| Alltrim(e[2]) == "ZZD_PESOB" } )
Local _nPosPL   := Ascan(aHeader, {|e| Alltrim(e[2]) == "ZZD_PESOL" } )

Local _nx := 0


dbSelectArea("EE5")
dbSetOrder(1)
IF dbSeek(xfilial("EE5")+SB1->B1_CODEMB)
	
	_nPesoB := EE5->EE5_PESO
	_nrCX := aCols[n,_nPosCX]
	
Endif

if _nPesoB > 0
	
	_nIguais := 1
	For _nx := n to len(acols)
		
		if aCols[_nx,_nPosCX] <> _nrCX
			Exit
		Endif
		
		_nIguais++
		
	Next
	
	if _nIguais > 1
		_nPesoB /= _nIguais
		For _nx := 1 to len(aCols)
			if aCols[_nx,_nPosCX] == _nrCX
				aCols[_nx,_nPosPB] := _nPesoB + aCols[_nx,_nPosPL]
			Endif
		Next
	Endif
	
	
Endif                     
For _nx := 1 to len(acols)
	if aCols[_nx,_nPosPb] == 0
		aCols[_nx,_nPosPb] := aCols[_nx,_nPosPL]
	Endif	
Next                     

RestArea(_aArea)
Return(_nPesoB)

//+-----------------------------------------------------------------------------------//
//|Funcao....: U_PesoInsumo()
//|Autor.....: Luis Henrique - DQZAFRA - 05-11-2010
//|Descricao.: Função Calculo Peso dos Insumos de Embalagem
//|Observação:
//+-----------------------------------------------------------------------------------//

User Function PesoInsumo()
Local _nPeso := 0
Local _aArea := GetArea()

dbSelectArea("ZZI")
dbSetORDER(1)
dbSeek(xfilial("ZZI")+M->ZZC_CODEMP)
While ! eof() .and. xfilial("ZZI")+M->ZZC_CODEMP == ZZI->ZZI_FILIAL + ZZI->ZZI_CODEMP
	
	
	dbSelectArea("ZZG")
	dbSetOrder(1)
	if dbSeek(xfilial("ZZG")+ZZI->ZZI_CODINS)
		_nPeso += ZZI->ZZI_QUANTI * ZZG->ZZG_PESO
	Endif
	
	dbSelectArea("ZZI")
	dbSkip()
	
End


RestArea(_aArea)
Return(_nPeso)

//+-----------------------------------------------------------------------------------//
//|Funcao....: U_RomBcoOk()
//|Autor.....: Luis Henrique - DQZAFRA - 05-11-2010
//|Descricao.: Função Confirma Gravacao e mantem variaveis de ZZC
//|Observação:
//+-----------------------------------------------------------------------------------//

User function RomBcoOk()
Local _lRet := .f.


if MsgYesno("Confirma a Gravacao?","Atenção")
	_lret := .t.
	IF INCLUI
		
		if MsgYesNo("Mantém dados do cabeçalho ?")
			
			_lMantem := .t.
			
		Else
			
			_lMantem := .f.
			
		Endif
		
	Endif
	
Endif


Return(_lRet)


//+-----------------------------------------------------------------------------------//
//|Funcao....: U_PesoInsumo()
//|Autor.....: Luis Henrique - DQZAFRA - 05-11-2010
//|Descricao.: Função Busca descricao do produto na lingua do pais
//|Observação:
//+-----------------------------------------------------------------------------------//

User Function BuscaEE2(_cProduto)
Local _cDescric := ""
Local _aArea := GetArea()

dbSelectArea("EE7")
dbSetOrder(1)
dbSeek(xfilial("EE7")+M->ZZC_PEDIDO)

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xfilial("SA1")+EE7->EE7_IMPORT+EE7->EE7_IMLOJA)

dbSelectArea("SYA")
dbSetOrder(1)
dbSeek(xfilial("SYA")+SA1->A1_PAIS)


dbSelectArea("EE2")
dbSetOrder(1)
dbSeek(xfilial("EE2")+'3*'+SYA->YA_IDIOMA+_cProduto)

_cDescric := MSMM(EE2_TEXTO)
if empty(_cDescric)
	_cDescric := SB1->B1_DESC
Endif

RestArea(_aArea)
Return(_cDescric)



//+-----------------------------------------------------------------------------------//
//|Funcao....: U_RBCMAC()
//|Autor.....: Luis Henrique - DQZAFRA - 01-02-2011
//|Descricao.: Função para explodir itens do pedido MAC  no acols
//|Observação:
//+-----------------------------------------------------------------------------------//

User Function RBCMAC(_cPedido)
Local _aArea := getArea()
Local _nP_NRCX		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_NRCX"})
Local _nP_NRPART	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_NRPART"})
Local _nP_DESC		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_DESC"})
Local _nP_QTDE		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_QTDE"})
Local _nP_PESOB		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_PESOB"})
Local _nP_PESOL		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_PESOL"})
Local _nP_SERIAL	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_SERIAL"})
Local _nP_PRODUTO	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "ZZD_CODIGO"})

Local _nCx,_nx,nI := 0

dbSelectArea("EE7")
dbSetOrder(1)
if dbSeek(xfilial("EE7")+_cPedido)
	
	if EE7->EE7_XMAC == "S"
		
		dbSelectArea("ZZD")
		dbSetOrder(2)
		dbSeek(xfilial("ZZD")+M->ZZC_REF)
		While ! eof() .and. xfilial("ZZD")+M->ZZC_REF == ZZD->ZZD_FILIAL + ZZD->ZZD_REF
			IF val(ZZD->ZZD_NRCX) > _nCx
				_nCx := val(ZZD->ZZD_NRCX)
			Endif
			ZZD->(dbSkip())
		End
		
		For _nx := 1 to len(aCols)
			
			if aCols[_nx][_nP_NRCX] > _nCx
				_nCx := aCols[_nx][_nP_NRCX]
			Endif
			
		Next
		_nCx += 1
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xfilial("SA1")+EE7->EE7_IMPORT+EE7->EE7_IMLOJA)
		
		dbSelectArea("SYA")
		dbSetOrder(1)
		dbSeek(xfilial("SYA")+SA1->A1_PAIS)
		
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(xfilial("SC5")+EE7->EE7_PEDFAT)
		
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xfilial("SC6")+EE7->EE7_PEDFAT)
		
		While ! eof() .and. xfilial("SC6")+EE7->EE7_PEDFAT == SC6->C6_FILIAL+SC6->C6_NUM
			
			dbSelectArea("EE8")
			dbSetOrder(1)
			dbSeek(xfilial("EE8")+_cPedido)
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xfilial("SB1")+SC6->C6_PRODUTO)
			
			dbSelectArea("EE2")
			dbSetOrder(1)
			dbSeek(xfilial("EE2")+'3*'+SYA->YA_IDIOMA+SC6->C6_PRODUTO)
			
			////////////q
			
			_n := len(aCols)
			if ! empty(	aCols[len(aCols)][_nP_PRODUTO] )
				
				aColsTmp := Array(1,nUsado+1)
				aadd(aCols,aColsTmp[1])
				_n := len(aCols)
				
				For nI = 1 To Len(aHeader)
					If aHeader[nI,8] == "C"
						aCols[_n,nI] := Space(aHeader[nI,4])
					ElseIf aHeader[nI,8] == "N"
						aCols[_n,nI] := 0
					ElseIf aHeader[nI,8] == "D"
						aCols[_n,nI] := CtoD(" / / ")
					ElseIf aHeader[nI,8] == "M"
						aCols[_n,nI] := ""
					Else
						aCols[_n,nI] := .F.
					EndIf
				Next nI
				
				aCols[_n,nUsado+1] := .F.
				
			Endif
			
			///////////////q
			
			aCols[_n][_nP_NRCX] 	:= _nCx
			_nCx++
			
			aCols[_n][_nP_PRODUTO] 	:= SC6->C6_PRODUTO
			aCols[_n][_nP_NRPART] 	:= GETADVFVAL("SB1","B1_ATLREF",XFILIAL("SB1")+SC6->C6_PRODUTO,1,"")
			
			_cDescric := MSMM(EE2_TEXTO)
			if empty(_cDescric)
				_cDescric := SB1->B1_DESC
			Endif
			
			
			aCols[_n][_nP_DESC] 	:= _cDescric
			aCols[_n][_nP_QTDE] 	:= SC6->C6_QTDVEN - SC6->C6_QTDENT
			
			aCols[_n][_nP_PESOB] 	:= U_CalcPesoB()
			
			aCols[_n][_nP_PESOL] 	:= SB1->B1_PESO
			aCols[_n][_nP_SERIAL] 	:= EE8->EE8_XMAC
			
			dbSelectArea("SC6")
			dbSkip()
			
		End
		
		oGet:oBrowse:Refresh(.T.)
		
	Endif //MAC = S
Endif //EE7

RestArea(_aArea)
RETURN(_cPedido)


Static Function _fSomaCaixa(_cProduto)
Local _lRet := .f.
Local _aArea := GetArea()
                
dbSelectArea("ZZD")
_cCaixa := ZZD->ZZD_NRCX
dbSkip()

if ! eof()
	if _cCaixa <> ZZD->ZZD_NRCX
		_lRet := .t.
	Endif              
Endif
dbSkip(-1)    
                         
RestArea(_aArea)
Return(_lRet)