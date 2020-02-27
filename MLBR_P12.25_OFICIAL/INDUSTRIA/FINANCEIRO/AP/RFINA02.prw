#INCLUDE "rwmake.ch"
/*
--------------------------------------------------------------------------
Programa: RFINA02										Data: 18/10/09
--------------------------------------------------------------------------
Objetivo: Re-Impressao de Autorização de Pagamento de Titulos - MANUAL
--------------------------------------------------------------------------
*/
User Function RFINA02()
Local aCores   := {} , aIndices := {} , _cFiltro
Local aUsers   := {} 
Local aGrupos  := {}
Local nCnt                        
Local aIndices := {} , _cFiltro, bFilBrw
Local cGruDesc := "", cGruCod := ""

Private aIndTmp 	:= {}

Private cCodUser  := RetCodUsr()
Private cCadastro := "Autorização de Pagamento"
Private aRotina := {{"Pesquisar"  ,"AxPesqui",0,1},;
					{"Visualizar" ,"AxVisual",0,2},;
					{"Imprimir AP","U_RFinA02Ap",0,3},;
					{"Legenda"    ,"U_RFinA02Lg",0,2}}

PswOrder(1) //Order o arquivo de usuario por código
lAchou       := PSWSeek(cCodUser) //Pesquisa no array
aUserFl      := PswRet(1)
IdUsuario    := aUserFl[1][1]      // codigo do usuario     
NomeUsuario := aUserFl[1][4]      // nome do usuario
EmailUsuario := aUserFl[1][14]     // Email
GrupoUsuario := aUserFl[1][10][1] // Grupo Que o usuario Pertence

aGrupos  := AllGroups()

cGruCod := GrupoUsuario

Aadd(aCores,{"E2_X_FLAG $ ' 1'","ENABLE"})		// AP Impressa
Aadd(aCores,{"E2_X_FLAG == '2'","BR_AMARELO"}) 	// AP RE-Impressa

//_cFiltro := "Empty(E2_BAIXA) .And. (!Empty(E2_X_NUMAP))"
//SE2FILTRA("F", cCodUser)

/*
-----------------------------------------------
Pesquisa o Grupo do Usuario
-----------------------------------------------*/                             
/*For nCnt := 1 To Len(aUsers)
	If aUsers[nCnt, 1, 1] == cCodUser
		If Len(aUsers[nCnt][1][10]) > 0   //Usuario pertence a um Grupo de Usuarios
			cGruCod := aUsers[nCnt, 1, 10, 1]	
			Exit
		Else
			cGruCod := ""
	    EndIf
	EndIf
Next */
/*
-----------------------------------------------
Pesquisa o Descriçao do Grupo do Usuario
-----------------------------------------------*/                             
If !Empty(cGruCod)
	For nCnt := 1 To Len(aGrupos)
		If aGrupos[nCnt, 1, 1] == cGruCod
			cGruDesc := aGrupos[nCnt, 1, 2]
		EndIf
	Next                             
Else
	cGruDesc := "Sem Grupo"
EndIf
/*
---------------------------------------------------
Filtra se usuario nao pertencer ao grupo Financeiro
---------------------------------------------------*/                             
If cGruCod != '000000'	//Grupo Administradores - Nao Filtra
	If Upper(Substr(cGruDesc,1,10)) != "FINANCEIRO"  .And.   Upper(Substr(cGruDesc,1,6)) != "CONTAB" //Se usuario for do Grupo Financeiro -- Nao Filtra   //AOLIVEIRA 07-03-2012 INCLUIDO GRUPO CONTABIL
//		_cFiltro := _cFiltro + '.And. E2_X_CODUS == "'+ccoduser+'"'
		SE2FILTRA("U", cCodUser)
		bFilBrw	 :=	{|| FilBrowse('SE2',@aIndices,_cFiltro)}   //Filtra o MBrowse
		Eval( bFilBrw )                                                            
	Else 
		SE2FILTRA("F", cCodUser)
	  // EndFilBrw('SE2',aIndexSA2)
	EndIf
Else
	SE2FILTRA("F", cCodUser)
	bFilBrw	 :=	{|| FilBrowse('SE2',@aIndices,_cFiltro)}   //Filtra o MBrowse
	Eval( bFilBrw )
EndIf

mBrowse( 6,1,22,75,"SE2",,"E2_X_FLAG",,,,aCores)

Return
/*
--------------------------------------------------------------------------
Programa: RFinA02Lg										Data: 18/10/09
--------------------------------------------------------------------------
Objetivo: Legenda
--------------------------------------------------------------------------
*/
User Function RFinA02Lg()              
Private aCorDesc 
aCorDesc :=	{   {"ENABLE","AP Impressa"},;   
				{"BR_AMARELO","AP Reimpressa"}}

BrwLegenda( "Legenda ", "Autorização de Pagamento", aCorDesc )

Return( .T. )                                                            
/*
--------------------------------------------------------------------------
Programa: RImprAP										Data: 18/10/09
--------------------------------------------------------------------------
Objetivo: Monta array para RE-Impressão da Autorizacao de Pagmento 
aDadosTit:	1-Prefixo
			2-Numero do Titulo
			3-Parcela
			4-Tipo
			5-Fornecedor
			6-Loja    
			7-Numero da AP
			8-Banco Fav
			9-Agencia Fav
			10-Conta Fav
			11-Nom Fav
			12-Cpf Fav	   
			13-Origem AP  
			14-Tipo de Conta     	| 1=Conta Corrente 2= Conta Poupanca
			15-Forma de Pagamento   | 1=DOC/TED 2=Boleto/DDA 3=Cheque    
			16-Historico
--------------------------------------------------------------------------
*/
User Function RFinA02Ap()    
Local aDadosTit := {}
Local aParcelas := {}
Local aDescrAP  := {}
Local cQuery    := ""   
Local cPrefixo  := SE2->E2_PREFIXO
Local cNumTit   := SE2->E2_NUM
Local cNumAP    := SE2->E2_X_NUMAP  
Local lDescriOk := .F.
Local nTotalDoc := 0

Local cAliasSE2 := "TRB"
Local aStruSE2  := SE2->(dbStruct())
Local nX

cQuery := " SELECT * FROM "  
cQuery += RetSqlName("SE2")+" SE2 "
cQuery += " WHERE " 
cQuery += " SE2.E2_X_NUMAP = '" + cNumAP + "' AND "   
cQuery += " SE2.D_E_L_E_T_ = ' '"  
cQuery += " ORDER BY SE2.E2_X_NUMAP, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO, SE2.E2_FORNECE, SE2.E2_LOJA"
cQuery := ChangeQuery(cQuery)
                                         
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE2)

dbSelectArea(cAliasSE2)   

For nX := 1 To Len(aStruSE2)
	If aStruSE2[nX][2]<>"C"
		TcSetField(cAliasSE2,aStruSE2[nX][1],aStruSE2[nX][2],aStruSE2[nX][3],aStruSE2[nX][4])
	EndIf
Next nX
                                                              

//aAdd(aDescrAP,{Upper("Referente Titulos"),Nil})
//aDescrAP:= xTiAgl(TRB->E2_NUM,TRB->E2_NATUREZ,aDescrAP)

aAdd(aDadosTit,	{	TRB->E2_PREFIXO,	TRB->E2_NUM    ,	TRB->E2_PARCELA,	TRB->E2_TIPO   ,	TRB->E2_FORNECE,	TRB->E2_LOJA,;   
					TRB->E2_X_NUMAP,	TRB->E2_X_BCOFV,	TRB->E2_X_AGEFV,	TRB->E2_X_CTAFV,	TRB->E2_X_NOMFV,	TRB->E2_X_CPFFV,;
					TRB->E2_X_ORIG ,	TRB->E2_X_TPCTA,	TRB->E2_X_FPAGT,	TRB->E2_HIST, TRB->E2_HIST1})
	
U_RFINR01(aDadosTit,aDescrAP,"RFINA02")    //RFinR01(aTit,aDesc,xRotina,_cFiltro)
/*
---------------------------------------------------
Fecha tabela temporaria
---------------------------------------------------*/
TRB->(dbCloseArea())              

Return

Static Function xTiAgl(_cNum,_cNaturez,aDadosAP)
Local cRet:= " "
Local cQuery := " "

if Select('TMP1') > 0
	dbSelectArea('TMP1')
	TMP1->(dbCloseArea())
endif

cQuery := " SELECT * FROM "  
cQuery += RetSqlName("SE5")+" SE5 "
cQuery += " WHERE E5_AGLIMP = '"+_cNum+"' "
cQuery += " AND E5_NATUREZ = '"+_cNaturez+"' "
cQuery += " AND E5_SITUACA = ' ' "
cQuery += " AND D_E_L_E_T_ = ' ' "

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'TMP1',.T.,.F.)
DbSelectArea("TMP1") 
TMP1->(DbGoTop())
ncount := 0
While !TMP1->(Eof())        
	aAdd(aDadosAP,{Upper("   "+TMP1->E5_PREFIXO+" - "+TMP1->E5_NUMERO+" - "+TMP1->E5_PARCELA+" - "+TMP1->E5_TIPO),TMP1->E5_VALOR})	
	TMP1->(DbSkip())
	ncount ++
EndDo
TMP1->(DbCloseArea())
//Alert ('Contador -> ' + cValToChar(ncount))   


//for i:= 1 to len(aDadosAP)
//  Alert('PRF '+aDadosAP[i][1]+' VLR '+cValToChar(aDadosAP[i][2]) )
//next

Return(aDadosAP)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera index de trabalho do SE2                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
static function SE2FILTRA(cTipo, ccoduser)
LOCAL cIndice,nInd,_cFiltro:=""
Local cNomeInd:=CriaTrab(NIL,.F.)
local nOrder  := 1
nOrder := If(nOrder=Nil,1,nOrder)
//Alert("Abrindo Filtro...")
Aadd(aIndTmp, cNomeInd)

dbSelectArea("SE2")
nOrder := 1
dbSetOrder(nOrder)
cIndice   := Indexkey()
_cFiltro := "Empty(E2_BAIXA) .And. (!Empty(E2_X_NUMAP))"
//_cFiltro := "!Empty(E2_X_NUMAP)"
if cTipo == "U"
//	Alert("Usuario -> "+cCodUser)
	_cFiltro := _cFiltro + '.And. E2_X_CODUS == "'+ccoduser+'"'
endif
//
IndRegua("SE2",cNomeInd,cIndice,,_cFiltro," Selecionando Registros..." )
nInd := RetIndex("SE2")
#IFNDEF TOP
	dbSetIndex(cNomeInd+OrdBagExt())
#ENDIF
dbSetOrder(nInd+1)
//alert("Filtro Realizado...")
Return
