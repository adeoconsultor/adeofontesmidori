#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*                                                                                             
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VSS_RASTR ºAutor  ³Vinicius Schwartz   º Data ³  09/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Sera chamada a rotina a partir do PE SF1140I, onde ao inclu-º±±
±±º          ³ir uma nota do grupo 11 (couros) sera filtrado todos os pro-º±±
±±º          ³dutos, lotes, qtdes de vq e m2, etc...Tais parametros serao º±±
±±º          ³repassados para a funcao VSS_MntPalete onde serao inseridos º±±
±±º          ³todos os pallets correspondentes a NF de acordo com o roma- º±±
±±º          ³neio enviado pelo fornecedor.								  º±±
±±º          ³Solicitante: Thiago/Fabio - HDI 004883					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COMPRAS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

//User Function VSS_MntPalete(SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_EMISSAO,TMPF1A->M2,TMPF1A->VQ,TMPF1A->QTDREG,aColPrLt,cVarPro)
//COURO                //    1        2     3      4       5      6    7     8       9        10      11       12
User Function VSS_MntPalete(cForn,cLjForn,cDocNF,cSerNF,dEmisNF,nTM2,nTVq,nTotReg,aColPrLt,cVarPro,cParTip, dDtDigNF)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local nOpc   := GD_INSERT+GD_DELETE+GD_UPDATE
Local cQuery := ""
Local nTotVQ := 0
Local nTotM2 := 0

Private aCoBrw1   := {}
Private aHoBrw1   := {}
Private cGetPlt   := Space(14) 
Private cGetPro   := Space(15) 
Private cSayDesc  := Space(50)
Private cGetQtdCo := 0
Private cGetQtdM2 := 0
Private cSayData  := Date()
Private cSayDtDig := dDtDigNF
Private cSayFor   := Space(6)
Private cSayLj    := Space(2)
Private cGetLote  := Space(10)
Private cGetVldL  := Date()  //dDataBase           //ver se fixa 5 anos de validade a todos produtos = dDataBase + 1825
Private cSayMed   := 0
Private cSayMedT  := 0
Private cSayNF    := Space(9)
Private cSaySer   := Space(3)
Private cSayTVQ   := 0  
Private cSayProds := Space(40)
Private noBrw1    := 0
Private cGetEnd   := Space(02)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlg1","oSay8","oSayTVQ","oSay9","oSayMed","oSay10","oSayMedT","oPanel1","oSay1","oSayNF")
SetPrvt("oSayFor","oSayLj","oSay3","oSayData","oSay5","oSaySer","oBrw1","oPanel2","oSay4","oSay6","oSay13","oSay14","oSay16","oSayProds" )
SetPrvt("oGetEnd","oGetLote","oGetVldL","oGetPlt","oGetQtdCo","oSayDesc","oGetQtdM2","oBtn1","oGetPro","oBtn2","oBtn3","oBtn4")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 057,277,509,1133,"Inclusão de Pallets - COURO",,,.F.,,,,,,.T.,,,.T. )
oSay8      := TSay():New( 160,008,{||"Tot. VQ:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayTVQ    := TSay():New( 160,036,{|u| If(PCount()>0,cSayTVQ:=u,cSayTVQ)},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay10     := TSay():New( 172,008,{||"Tot M²:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSayMedT   := TSay():New( 172,036,{|u| If(PCount()>0,cSayMedT:=u,cSayMedT)},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay9      := TSay():New( 184,008,{||"M²/VQ:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
oSayMed    := TSay():New( 184,036,{|u| If(PCount()>0,cSayMed:=u, cSayMed)},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008) 
oSay14     := TSay():New( 160,094,{||"Produtos contidos na NF:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
oSayProds  := TSay():New( 160,170,{|u| If(PCount()>0,cSayProds:=u, cSayProds)},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008) 
oPanel1    := TPanel():New( 004,004,"",oDlg1,,.F.,.F.,,,468,020,.T.,.F. )
oSay1      := TSay():New( 008,004,{||"Nota Fical:"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayNF     := TSay():New( 008,040,{|u| If(PCount()>0,cSayNF:=u,cSayNF)},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSaySer    := TSay():New( 008,080,{|u| If(PCount()>0,cSaySer:=u,cSaySer)},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
oSay2      := TSay():New( 008,116,{||"Forn:"},oPanel1,,oFont1å,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
oSayFor    := TSay():New( 008,136,{|u| If(PCount()>0,cSayFor:=u,cSayFor)},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayLj     := TSay():New( 008,172,{|u| If(PCount()>0,cSayLj:=u,cSayLj)},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
oSay3      := TSay():New( 008,212,{||"Data:"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
oSayData   := TSay():New( 008,236,{|u| If(PCount()>0,cSayData:=u,cSayData)},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
//oSay5      := TSay():New( 008,288,{||"Lote:"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
//oSayLote   := TSay():New( 008,308,{|u| If(PCount()>0,cSayLote:=u,cSayLote)},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
MHoBrw1()
MCoBrw1()
oBrw1      := MsNewGetDados():New(068,004,156,468,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','AllwaysTrue()',{|| MarcaDel(2)},oDlg1,aHoBrw1,aCoBrw1 )
oPanel2    := TPanel():New( 031,004,"",oDlg1,,.F.,.F.,,,368,033,.T.,.F. )
oSay12     := TSay():New( 004,004,{||"Produto:"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oSay5      := TSay():New( 004,094,{||"Lote:"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
oSay15     := TSay():New( 004,188,{||"Validade Lote:"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay16     := TSay():New( 004,274,{||"Endeço:"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)


oSay4      := TSay():New( 020,004,{||"Pallet:"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
oSay6      := TSay():New( 020,108,{||"Qtde Couro:"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay7      := TSay():New( 020,211,{||"Qtde M²:"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay13     := TSay():New( 194,094,{||"Descrição:"},oDLG1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oGetPro    := TGet():New( 004,033,{|u| If(PCount()>0,cGetPro:=u,cGetPro)},oPanel2,052,010,'',{||Vld_Prod(cGetPro,aColPrLt,cVarPro)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetPro",,)
oGetLote   := TGet():New( 004,132,{|u| If(PCount()>0,cGetLote:=u,cGetLote)},oPanel2,052,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetLote",,)
oGetVLDL   := TGet():New( 004,218,{|u| If(PCount()>0,cGetVLDL:=u,cGetVLDL)},oPanel2,052,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetVLDL",,)
oGetEnd    := TGet():New( 004,304,{|u| If(PCount()>0,cGetEnd:=u,cGetEnd   ) },oPanel2,052,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetEnd",,)
oGetPlt    := TGet():New( 020,033,{|u| If(PCount()>0,cGetPlt:=u,cGetPlt)  },oPanel2,052,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetPlt",,)

oGetQtdCo  := TGet():New( 020,151,{|u| If(PCount()>0,cGetQtdCo:=u,cGetQtdCo)},oPanel2,044,010,'@E 999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtdCo",,)
oGetQtdM2  := TGet():New( 020,244,{|u| If(PCount()>0,cGetQtdM2:=u,cGetQtdM2)},oPanel2,052,010,'@E 999,999.9999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtdM2",,)
oSayDesc   := TSay():New( 194,132,{|u| If(PCount()>0,cSayDesc:=u,cSayDesc)},odlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,008)


oBtn1      := TButton():New( 020,302,"Inserir",oPanel2,{|| Inc_Palete(2)},028,012,,,,.T.,,"",,,,.F. )
oBtn4      := TButton():New( 020,335,"Excluir",oPanel2,{|| Del_Palete(2)},028,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 176,332,"Confirmar",oDlg1,{|| Confir_Proc(nTM2,nTVq,cSayTVQ,cSayMedT)},037,012,,,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( 176,292,"Cancelar",oDlg1,{|| oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )

//(cForn,cLjForn,cDocNF,cSerNF,dEmisNF,nTM2,nTVq,nTotReg,aColPrLt,cVarPro)
cSayFor   := cForn
cSayLj    := cLjForn
cSayNF    := cDocNF
cSaySer   := cSerNF
cSayData  := dEmisNF
cSayProds := cVarPro

//Query para atualizar a grid com todos os pallets
cQuery := " SELECT * FROM "+RetSqlName("SZO")+" "
cQuery += " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NFORI = '"+cSayNF+"' AND ZO_SERIE = '"+cSaySer+"' "
cQuery += " 	AND ZO_CODFOR = '"+cSayFor+"' AND ZO_LJFOR = '"+cSayLj+"' AND D_E_L_E_T_ <> '*' "
cQuery += "	ORDER BY R_E_C_N_O_ DESC "

If Select ('TMPSZO') > 0
	DbSelectArea('TMPSZO')
	DbCloseArea()
EndIf
	
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TMPSZO',.T.,.T.)
DbSelectArea("TMPSZO")
DbGoTop()
nCount := 0
aCoBrw1 := {}                          
	
//While para alimentar a grid novamente
While !TMPSZO->(EOF())   
	Aadd(aCoBrw1, {TMPSZO->ZO_PRODUTO, TMPSZO->ZO_NUMPLT, TMPSZO->ZO_QTDCOUR, TMPSZO->ZO_QTDEVQ, TMPSZO->ZO_QTDEM2,TMPSZO->ZO_M2VQPLT, TMPSZO->ZO_NUMLOTE, StoD(TMPSZO->ZO_DTVALID),TMPSZO->ZO_ENDERE, .F. })
	nTotVQ += TMPSZO->ZO_QTDEVQ
	nTotM2 += TMPSZO->ZO_QTDEM2
	nCount ++
	TMPSZO->(DbSkip())		
Enddo

oBrw1:SetArray(aCoBrw1)
oBrw1:oBrowse:Refresh()

/*cSayTVQ :=Round(nTotVQ,2)
cSayMedT:=Round(nTotM2,4)
cSayMed := Round((cSayMedT / cSayTVQ),2)
 */

cSayTVQ :=nTotVQ
cSayMedT:=nTotM2
cSayMed := (cSayMedT / cSayTVQ)


oDlg1:Activate(,,,.T.)

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: 
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrw1()
Local nn1

aCpos :=  	{	{'Cod. Produto'  	,'ZO_PRODUTO'		,15,0	,'@!'						,	'AllwaysTrue()'		},;     // 1
				{'Num. Pallet'  	,'ZO_NUMPLT'		,14,0	,'@!'						,	'AllwaysTrue()'		},;     // 2
				{'Qtde Couro'		,'ZO_QTDCOUR'		,09,0	,'@E 999,999'				,	'AllwaysTrue()'		},;     // 3
				{'QTde VQ'			,'ZO_QTDEVQ'		,09,0   ,'@E 999,999'				,	'AllwaysTrue()'		},;     // 4
				{'QTde M²'			,'ZO_QTDEM2'		,12,4   ,'@E 9,999,999.9999'		,	'AllwaysTrue()'		},;     // 5
				{'Média M²/VQ'		,'ZO_M2VQPLT'		,09,2	,'@E 999,999.99'			,	'AllwaysTrue()' 	},;     // 6
				{'Lote'  			,'ZO_NUMLOTE'		,10,0	,'@!'						,	'AllwaysTrue()'		},;     // 7
				{'Valid Lote'		,'ZO_DTVALID'		,08,0	,'@!'						,	'AllwaysTrue()'		},;     // 8
				{'Endereço'			,'ZO_ENDERE'		,02,0	,'@!'						,	'AllwaysTrue()'		}}      // 9


DbSelectArea("SX3")
DbSetOrder(2)

For nn1 := 1 to len( aCpos )
	if DbSeek( aCpos[ nn1,2 ] )
		If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
			noBrw1++
			
			
			Aadd(aHoBrw1,{Trim( aCpos[ nn1,1 ] ),;
			aCpos[ nn1,2 ],;
			aCpos[ nn1,5 ],;
			aCpos[ nn1,3 ],;
			aCpos[ nn1,4 ],;
			aCpos[ nn1,6 ],;
			"",;
			SX3->X3_TIPO,;
			"",;
			"" } )
		EndIf
	Endif
Next
DbSelectArea("SX3")
DbSetOrder(1)

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MCoBrw1() - Monta aCols da MsNewGetDados para o Alias: 
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MCoBrw1()

Local aAux := {}
Local nI

Aadd(aCoBrw1,Array(noBrw1+1))
For nI := 1 To noBrw1
   aCoBrw1[1][nI] := CriaVar(aHoBrw1[nI][2])
Next
aCoBrw1[1][noBrw1+1] := .F.

Return


////////////////////////////////////////////////////////////////////////////////////////
//Marca registro na grid para ser deletado.
////////////////////////////////////////////////////////////////////////////////////////
static function MarcaDel(nCQ)
//	if !aCoBrw1[n][5]
//		Alert(aCoBrw1[n][1]+' ATIVO')
//	endif
nOld := n 

If nCQ==1
	iif(auCoBrw1[n][7],auCoBrw1[n][7]:=.F.,auCoBrw1[n][7]:=.T.)
/*
	if auCoBrw1[n][7]
		Alert(auCoBrw1[n][1]+' DELETADO')
	endif
*/
	oBrw1:SetArray(auCoBrw1)

Else

	iif(aCoBrw1[n][10],aCoBrw1[n][10]:=.F.,aCoBrw1[n][10]:=.T.)
/*
	if aCoBrw1[n][10]
		Alert(aCoBrw1[n][1]+' DELETADO')
	endif
*/

	oBrw1:SetArray(aCoBrw1)
EndIf

oBrw1:oBrowse:Refresh()

//oBrw1:oBrowse:nOld:SetFocus()

return

///////////////////////////////////////////////////////////////////////////////////
//////////Funcao para validar cod do produto, e buscar o campo lote////////////////
//////////////          dentro do array aColPrLt                ///////////////////
///////////////////////////////////////////////////////////////////////////////////

Static Function Vld_Prod(cGetPro,aColPrLt,cVarPro)

Local lRet    := .T.
Local lTstPro := .F.
Local cGrupo  := ""
Local nI

For nI:=1 to len(aColPrLt)
	If cGetPro == aColPrLt[nI][1]
 //		cSayLote := aColPrLt[nI][2]
		lTstPro := .T.
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial('SB1')+cGetPro)
			cSayDesc := SB1->B1_DESC
			cGrupo   := SB1->B1_GRUPO
		EndIf
		dbCloseArea("SB1")
		
//		oSayLote:Refresh()
		oSayDesc:Refresh()
	endif
next nI

If lTstPro == .F.
	Alert('O produto informado não foi localizado nos ítens da NF, ou então não pertence ao grupo: ' + cGrupo + '. Os produtos considerados são: '+ cVarPro +'. Favor checar!!!')
	lRet := .F.
	Return lRet
EndIf

Return lRet


////////////////////////////////////////////////////////////
//////////Funcao para adicionar pallet na tabelz SZO////////
////////////////////////////////////////////////////////////

Static Function Inc_Palete(nCQ)   
Local cQuery := ""
Local nTotVQ := 0
Local nTotM2 := 0
Local nTotKG := 0
lRet := .T.

//Validacoes se ficou algum campo sem preencher
If cGetPro == Space(15)
	Alert('O campo produto não foi preenchido. Favor checar!!!')
	lRet := .F.
	oGetPro:SetFocus()
	Return lRet
Endif 

If cGetPlt == Space(14)
	Alert('O campo pallet não foi preenchido. Favor checar!!!')
	lRet := .F.
	oGetPlt:SetFocus()
	Return lRet
Endif

If nCQ == 1
	If cGetQtdKg == 0
		Alert('O campo qtde/kg de quimicos não foi preenchido. Favor checar!!!')
		lRet := .F.
		oGetQtdCo:SetFocus()
		Return lRet
	Endif

Else
	If cGetQtdCo == 0
		Alert('O campo qtde. de couro não foi preenchido. Favor checar!!!')
		lRet := .F.
		oGetQtdCo:SetFocus()
		Return lRet
	Endif
	
	If cGetQtdM2 == 0
		Alert('O campo qtde. de m² não foi preenchido. Favor checar!!!')
		lRet := .F.
		oGetQtdM2:SetFocus()
		Return lRet
	Endif
Endif
//Fim das validacoes de campos vazios

//Se não entrar em nenhuma das validacoes acima a inclusao sera iniciada
dbSelectArea("SZO")
dbSetOrder(1)
	
	//Faz a gravacao dos dados na tabela SZO
	RecLock("SZO",.T.)
	   
	SZO->ZO_FILIAL  := cFilant
	SZO->ZO_PRODUTO := cGetPro
	SZO->ZO_NFORI   := cSayNF
	SZO->ZO_SERIE   := cSaySer
	SZO->ZO_CODFOR  := cSayFor
	SZO->ZO_LJFOR   := cSayLj
	SZO->ZO_EMISSNF := cSayData           // dDataBase
	SZO->ZO_NUMLOTE := cGetLote           //cSayLote
	SZO->ZO_DTLCMTO := cSayDtDig          // dDataBase
	SZO->ZO_NUMPLT  := cGetPlt
	SZO->ZO_ENDERE  := cGetEnd

	If nCQ == 1
		SZO->ZO_QTDEM2  := cGetQtdKg
		SZO->ZO_DTVALID := cGetVLDL
	Else
		SZO->ZO_DTVALID := cGetVLDL
		SZO->ZO_QTDCOUR := cGetQtdCo
		SZO->ZO_QTDEVQ  := (cGetQtdCo * 2)
		SZO->ZO_QTDEM2  := cGetQtdM2
		SZO->ZO_M2VQPLT := cGetQtdM2 / (cGetQtdCo *2)
	EndIf
	SZO->ZO_NFCLASS := "N"
		
	MsUnLock("SZO")
		
	//Query para atualizar a grid com todos os pallets
	cQuery := " SELECT * FROM "+RetSqlName("SZO")+" "
	cQuery += " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NFORI = '"+cSayNF+"' AND ZO_SERIE = '"+cSaySer+"' "
	cQuery += " 	AND ZO_CODFOR = '"+cSayFor+"' AND ZO_LJFOR = '"+cSayLj+"' AND D_E_L_E_T_ <> '*' "
	cQuery += "	ORDER BY R_E_C_N_O_ DESC "

	If Select ('TMPSZO') > 0
		DbSelectArea('TMPSZO')
		DbCloseArea()
	EndIf
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TMPSZO',.T.,.T.)
	DbSelectArea("TMPSZO")
	DbGoTop()

	If nCQ == 1
	
		nCount := 0
		aUCoBrw1 := {}                          
		
		//While para alimentar a grid novamente
		While !TMPSZO->(EOF())   
			Aadd(aUCoBrw1, {TMPSZO->ZO_PRODUTO, TMPSZO->ZO_NUMPLT, TMPSZO->ZO_QTDEM2,TMPSZO->ZO_NUMLOTE, StoD(TMPSZO->ZO_DTVALID),TMPSZO->ZO_ENDERE ,.F. })
			nTotKG += TMPSZO->ZO_QTDEM2
			nCount ++
			TMPSZO->(DbSkip())		
		Enddo
	
		//Alert('Executou todos os passos, agora falta atualizar os campos!!!')
		
		oBrw1:SetArray(auCoBrw1)
		oBrw1:oBrowse:Refresh()
		oGetPro:SetFocus()
		cSayKgT:=nTotKG
		cSayTP:=nCount

//		If INCLUI
			cGetPlt    := Soma1(cGetPlt) //Space(14) 
//    	EndIf
		cGetQtdKG  := 0
		oGetPlt:Refresh()
		oGetQtdKg:Refresh()
		oSayKGT:Refresh()
		oSayTp:Refresh()

	Else

		nCount := 0
		aCoBrw1 := {}                          
		
		//While para alimentar a grid novamente
		While !TMPSZO->(EOF())   
			Aadd(aCoBrw1, {TMPSZO->ZO_PRODUTO, TMPSZO->ZO_NUMPLT, TMPSZO->ZO_QTDCOUR, TMPSZO->ZO_QTDEVQ, TMPSZO->ZO_QTDEM2,TMPSZO->ZO_M2VQPLT,TMPSZO->ZO_NUMLOTE, StoD(TMPSZO->ZO_DTVALID),TMPSZO->ZO_ENDERE, .F. })
			nTotVQ += TMPSZO->ZO_QTDEVQ
			nTotM2 += TMPSZO->ZO_QTDEM2
			nCount ++
			TMPSZO->(DbSkip())		
		Enddo
	
		//Alert('Executou todos os passos, agora falta atualizar os campos!!!')
		
		oBrw1:SetArray(aCoBrw1)
		oBrw1:oBrowse:Refresh()
		oGetPro:SetFocus()
	
	/*	cSayTVQ :=Round(nTotVQ,2)
		cSayMedT:=Round(nTotM2,2)
		cSayMed := Round((cSayMedT / cSayTVQ),2)
	 */
	
		cSayTVQ :=nTotVQ
		cSayMedT:=nTotM2
		cSayMed := (cSayMedT / cSayTVQ)
	
		oSayTVQ:Refresh()
		oSayMedT:Refresh()
		oSayMed:Refresh()
		
		cGetPlt    := Space(14) 
		cGetQtdCo  := 0
		cGetQtdM2  := 0
		oGetPlt:Refresh()
		oGetQtdCo:Refresh()
		oGetQtdM2:Refresh()                                               

	EndIf	

Return lRet

////////////////////////////////////////////////////////////////////
//////////Funcao para exclusao de pallets do acols//////////////////
////////////////////////////////////////////////////////////////////

Static Function Del_Palete(nCQ) 
Local cQuery := ""
Local nTotVQ := 0
Local nTotM2 := 0
Local nTotKG := 0
Local I

//Verifica se ha algum item marcado para excluir e exclui

If nCQ == 2     //couro

	For I:= 1 to len(aCoBrw1)

		If aCoBrw1[i][10]
			Aviso('Ref.aos itens marcados para excluir', 'Se houver na mesma NF pallets repedidos do mesmo produto, ambos serão excluidos!', {"OK"} )
			cQuery := " UPDATE "+RetSqlName("SZO")+" "
			cQuery += " SET D_E_L_E_T_ = '*' "
			cQuery += " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NFORI = '"+cSayNF+"' AND ZO_SERIE = '"+cSaySer+"' AND ZO_CODFOR = '"+cSayFor+"' AND ZO_LJFOR = '"+cSayLj+"' "
			cQuery += " AND ZO_NUMPLT = '"+aCoBrw1[i][2]+"' AND ZO_PRODUTO = '"+aCoBrw1[i][1]+"' AND D_E_L_E_T_ <> '*' "
			nret1 := TcSqlExec( cQuery )
		EndIf
	Next i
Else                   //quimicos

	For I:= 1 to len(aUCoBrw1)

		If aUCoBrw1[i][7]
			Aviso('Ref.aos itens marcados para excluir', 'Se houver na mesma NF pallets repedidos do mesmo produto, ambos serão excluidos!', {"OK"} )
			cQuery := " UPDATE "+RetSqlName("SZO")+" "
			cQuery += " SET D_E_L_E_T_ = '*' "
			cQuery += " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NFORI = '"+cSayNF+"' AND ZO_SERIE = '"+cSaySer+"' AND ZO_CODFOR = '"+cSayFor+"' AND ZO_LJFOR = '"+cSayLj+"' "
			cQuery += " AND ZO_NUMPLT = '"+aUCoBrw1[i][2]+"' AND ZO_PRODUTO = '"+aUCoBrw1[i][1]+"' AND D_E_L_E_T_ <> '*' "
			nret1 := TcSqlExec( cQuery )
		EndIf
	Next i
EndIf

	//Query para atualizar a grid com todos os pallets
	cQuery := " SELECT * FROM "+RetSqlName("SZO")+" "
	cQuery += " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NFORI = '"+cSayNF+"' AND ZO_SERIE = '"+cSaySer+"' "
	cQuery += " 	AND ZO_CODFOR = '"+cSayFor+"' AND ZO_LJFOR = '"+cSayLj+"' AND D_E_L_E_T_ <> '*' "
	cQuery += "	ORDER BY R_E_C_N_O_ DESC "

	If Select ('TMPSZO') > 0
		DbSelectArea('TMPSZO')
		DbCloseArea()
	EndIf
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TMPSZO',.T.,.T.)
	DbSelectArea("TMPSZO")
	DbGoTop()
	nCount := 0
	
	//While para alimentar a grid novamente
	If nCQ == 2                       //COURO
		aCoBrw1 := {}                          

		While !TMPSZO->(EOF())   
			Aadd(aCoBrw1, {TMPSZO->ZO_PRODUTO, TMPSZO->ZO_NUMPLT, TMPSZO->ZO_QTDCOUR, TMPSZO->ZO_QTDEVQ, TMPSZO->ZO_QTDEM2,TMPSZO->ZO_M2VQPLT,TMPSZO->ZO_NUMLOTE, StoD(TMPSZO->ZO_DTVALID),TMPSZO->ZO_ENDERE, .F. })
			nTotVQ += TMPSZO->ZO_QTDEVQ
			nTotM2 += TMPSZO->ZO_QTDEM2
			nCount ++
			TMPSZO->(DbSkip())		
		Enddo

	Else                              //QUIMICO
		aUCoBrw1 := {}                          

		While !TMPSZO->(EOF())   
			Aadd(aUCoBrw1, {TMPSZO->ZO_PRODUTO, TMPSZO->ZO_NUMPLT, TMPSZO->ZO_QTDEM2,TMPSZO->ZO_NUMLOTE, StoD(TMPSZO->ZO_DTVALID), TMPSZO->ZO_ENDERE, .F. })
			nTotKG += TMPSZO->ZO_QTDEM2
			nCount ++
			TMPSZO->(DbSkip())		
		Enddo
	
	EndIf

	//Alert('Executou todos os passos, agora falta atualizar os campos!!!')
	

	If nCQ == 2       //COURO
		oBrw1:SetArray(aCoBrw1)
		oBrw1:oBrowse:Refresh()
	
	/*	cSayTVQ :=Round(nTotVQ,2)
		cSayMedT:=Round(nTotM2,2)
		cSayMed := Round((cSayMedT / cSayTVQ),2)
	 */
	
		cSayTVQ :=nTotVQ
		cSayMedT:=nTotM2
		cSayMed := (cSayMedT / cSayTVQ)
	
		oSayTVQ:Refresh()
		oSayMedT:Refresh()
		oSayMed:Refresh()
	Else	                 //QUIMICO
		oBrw1:SetArray(auCoBrw1)
		oBrw1:oBrowse:Refresh()
		oGetPro:SetFocus()
		cSayKgT:=nTotKG
		cSayTP:=nCount

			cGetPlt    := Soma1(cGetPlt) //Space(14) 

		cGetQtdKG  := 0
		oGetPlt:Refresh()
		oGetQtdKg:Refresh()
		oSayKGT:Refresh()
		oSayTp:Refresh()
	EndIf	

Return


////////////////////////////////////////////////////////////////////
////////  Funcao para confirmacao do processo de inclusao  /////////
////////////////////////////////////////////////////////////////////
Static Function Confir_Proc(nTM2,nTVq,cSayTVQ,cSayMedT)

Local cQuery   := ""
Local cQuery1  := ""
Local cQuery2  := ""
Local cQuery3  := ""
Local cQuery4  := ""
Local lRet     := .T.
Local _xFlag   := 'N'
Local cAli_SD1 := GetNextAlias()
Local cAli_SZO := GetNextAlias()
Local dDtValid
Local cLocApt  := ''

If Inclui             //antonio, ajuste para acertar o calculo, pois a quantidade de vaquetas era informada no campo da D1, que só vinha como 0
	If xFilial("SZO") == '09' .And. AllTrim(POSICIONE("SB1",1,xFilial("SB1")+cGetPro,'B1_GRUPO')) == '11'
		nTVq := cSayTVQ
	EndIf
ElseIf Altera
	If xFilial("SZO") == '09' .And. AllTrim(POSICIONE("SB1",1,xFilial("SB1")+aCoBrw1[n,1],'B1_GRUPO')) == '11'
		nTVq := cSayTVQ
	EndIf
EndIf

If (nTM2 <> cSayMedT) //.Or. (nTVq <> cSayTVQ)

	Alert('Os valores totais dos pallets não estão em conformidade com o total informado na NF (Vq ou M²). Favor checar!!!')
	lRet:= .F.
	
	cQuery := " UPDATE "+RetSqlName("SZO")+" "
	cQuery += " SET ZO_STATUS = ' ' "
	cQuery += " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NFORI = '"+cSayNF+"' AND ZO_SERIE = '"+cSaySer+"' AND ZO_CODFOR = '"+cSayFor+"' AND ZO_LJFOR = '"+cSayLj+"' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	nret1 := TcSqlExec( cQuery )   
	 _xFlag == 'N'

Else 

	cQuery1 := " SELECT SD1.D1_COD, SD1.D1_ITEM, SD1.D1_LOTECTL, SD1.D1_LOCAL, SD1.D1_DTVALID, SD1.D1_QUANT, SD1.D1_VUNIT, SD1.D1_TOTAL  "
	cQuery1 += "    FROM "+RetSqlName("SD1")+" SD1 "
	cQuery1 += "    WHERE SD1.D1_DOC     = '"+cSayNF+"'         AND SD1.D1_SERIE   =  '"+cSaySer+"' AND "
	cQuery1 += "          SD1.D1_FORNECE = '"+cSayFor+"'        AND SD1.D1_LOJA    =  '"+cSayLj+"'  AND "
	cQuery1 += "          SD1.D1_FILIAL  = '"+xFilial('SD1')+"' AND SD1.D_E_L_E_T_ <> '*' "
	cQuery1 += " ORDER BY SD1.D1_COD, SD1.D1_ITEM " 
	If Select (cAli_SD1) > 0
		DbSelectArea(cAli_SD1)
		DbCloseArea()
	EndIf
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAli_SD1,.T.,.T.)

	If (cAli_SD1)->(!Eof())
		dDtValid := (cAli_SD1)->D1_DTVALID
		cLocApt  := (cAli_SD1)->D1_LOCAL
	EndIf
	
	While (cAli_SD1)->(!Eof())

		cQuery2 := " SELECT SUM(SZO.ZO_QTDCOUR) AS XZO_QTDCOUR, SUM(SZO.ZO_QTDEM2) AS XZO_QTDM2 "
		cQuery2 += "    FROM "+RetSqlName("SZO")+" SZO "
		cQuery2 += "    WHERE SZO.ZO_NFORI   = '"+cSayNF+"'         AND SZO.ZO_SERIE   =  '"+cSaySer+"' "
		cQuery2 += "      AND SZO.ZO_CODFOR  = '"+cSayFor+"'        AND SZO.ZO_LJFOR   =  '"+cSayLj+"' "
		cQuery2 += "      AND SZO.ZO_FILIAL  = '"+xFilial('SZO')+"' AND SZO.D_E_L_E_T_ <> '*' "
		cQuery2 += "      AND SZO.ZO_PRODUTO = '"+(cAli_SD1)->D1_COD+"' " 
//		cQuery2 += "      AND SZO.ZO_NUMLOTE = '"+(cAli_SD1)->D1_LOTECTL+"' " 

		If Select (cAli_SZO) > 0
			DbSelectArea(cAli_SZO)
			DbCloseArea()
		EndIf
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAli_SZO,.T.,.T.)
		
		If (cAli_SZO)->(!Eof())
		
			If (cAli_SD1)->D1_QUANT <> (cAli_SZO)->XZO_QTDM2
				Alert('Os valores totais (por produtos) dos pallets não estão em conformidade com o total informado na NF, Produto: ' + (cAli_SD1)->D1_COD + '. Favor checar!!!')
				lRet:= .F.
			EndIf

		EndIf

		(cAli_SD1)->(dbSkip())	

	EndDo

	If lRet
		cQuery3 := " UPDATE "+RetSqlName("SZO")+" "
		cQuery3 += " SET ZO_STATUS   = 'LIB'"                                 //trecho para retirar apos campos serem criados
		cQuery3 += "     ,ZO_SITUACA = '1'  "       //Analise                 //antonio 25/04/19
		cQuery3 += "     ,ZO_DATAALT =  '" + DtoS(dDataBase) + "' "
		cQuery3 += "     ,ZO_USUARIO =  '" + RetCodUsr()     + "' " 
		cQuery3 += " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NFORI = '"+cSayNF+"' AND ZO_SERIE = '"+cSaySer+"' AND ZO_CODFOR = '"+cSayFor+"' AND ZO_LJFOR = '"+cSayLj+"' "
		cQuery3 += " AND D_E_L_E_T_ <> '*' "
		nret1 := TcSqlExec( cQuery3 )    
		
//		MsgInfo('Processo concluído com sucesso!!!')
		_xFlag := 'S'
		oDlg1:End()
	Else
		cQuery3 := " UPDATE "+RetSqlName("SZO")+" "
		cQuery3 += " SET ZO_STATUS = ' ' "
		cQuery3 += " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NFORI = '"+cSayNF+"' AND ZO_SERIE = '"+cSaySer+"' AND ZO_CODFOR = '"+cSayFor+"' AND ZO_LJFOR = '"+cSayLj+"' "
		cQuery3 += " AND D_E_L_E_T_ <> '*' "
		nret1 := TcSqlExec( cQuery3 )   
		 _xFlag := 'N'
	EndIf
Endif

	//////////// - Momento em que ira gerar a etiqueta de COURO - antonio 07/03/19

	If _xFlag == 'S'

		If MsgYesNo('Emitir etiqueta de Pallet (PNP1) - Couro (S/N)?' )

			// Se a etiqueta não tiver movimento, apaga
			CB0->(DbSetOrder(6))
			CB0->(DbSeek(xFilial("CB0") + cSayNF + cSaySer + cSayFor + cSayLj))
			While CB0->(DbSeek(xFilial("CB0") + cSayNF + cSaySer + cSayFor + cSayLj ))
				RecLock("CB0",.F.)
				dbDelete()
				MsUnlock()			
				CB0->(dbSkip())             
			Enddo

			cQuery4 := " SELECT * FROM "+RetSqlName("SZO")+ " "
			cQuery4 += " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NFORI = '"+cSayNF+"' AND ZO_SERIE = '"+cSaySer+"' "
			cQuery4 += " 	AND ZO_CODFOR = '"+cSayFor+"' AND ZO_LJFOR = '"+cSayLj+"' AND D_E_L_E_T_ <> '*' "
			cQuery4 += " 	AND ZO_STATUS = 'LIB' "
//			cQuery4 += "	ORDER BY "
		
			If Select ('TMPSZON') > 0
				DbSelectArea('TMPSZON')
				DbCloseArea()
			EndIf
			
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery4),'TMPSZON',.T.,.T.)
			DbSelectArea("TMPSZON")
			DbGoTop()

			While !TMPSZON->(Eof())   
            
//				cLocApt:='01'    //usado somente para teste no caso de ja ter sido impressa a etiqueta. antonio 09/03/19
			
			    SB1->( dbSetOrder(1) )
			    SB1->( dbSeek( xFilial("SB1") + TMPSZON->ZO_PRODUTO ) )
			 	aParam    := {}                  
				nQtOpEtiq := 1
				AAdd( aParam, TMPSZON->ZO_QTDEM2) // quantidade da etiqueta                                         1
				AAdd( aParam, nil           ) // Codigo do separador                                                2
				AAdd( aParam, nil           ) // Código da etiqueta, no caso de uma reimpressão                     3
				AAdd( aParam, nQtOpEtiq     ) // Quantidade de etiquetas                                            4
				AAdd( aParam, cSayNF        ) // nota de entrada                                                    5
				AAdd( aParam, cSaySer       ) // Serie da nota de entrada                                           6
				AAdd( aParam, cSayFor       ) // Codigo do fornecedor da nota de entrada                            7
				AAdd( aParam, cSayLj        ) // Loja do fornecedor da nota de entrada                              8
				AAdd( aParam, cLocApt       ) // Armazem                                                            9
				AAdd( aParam, nil           ) // Numero da OP                                                       10
				AAdd( aParam, nil           ) // Numero sequencial da etiqueta quando for reimpressao               11
				AAdd( aParam, If(SB1->B1_RASTRO=="L", TMPSZON->ZO_NUMLOTE, nil ) )                                //12
				AAdd( aParam, nil           ) // Sublote                                                          //13

//				If StoD( dDTVALID ) <= dDataBase
					AAdd( aParam, StoD(TMPSZON->ZO_DTVALID) /*dDataBase+1824*/ ,nil)            // Data de Validade                             //14
//				Else
//					AAdd( aParam, StoD( dDTVALID) ,nil)           // Data de Validade                             //14
//				EndIf

				AAdd( aParam, nil           ) // Centro de Custos                                                 //15
				AAdd( aParam, cLocApt       ) // Local de Origem                                                  //16
				AAdd( aParam, nil           ) // Local cOPREQ    := If(len(paramixb) >=17,paramixb[17],NIL)       //17
				AAdd( aParam, nil           ) // Local cNumSerie := If(len(paramixb) >=18,paramixb[18],NIL)       //18
				AAdd( aParam, nil           ) // Local cOrigem   := If(len(paramixb) >=19,paramixb[19],NIL)         19
				AAdd( aParam, nil           ) // Local cEndereco := If(len(paramixb) >=20,paramixb[20],NIL)         20
				AAdd( aParam, nil           ) // Local cPedido   := If(len(paramixb) >=21,paramixb[21],NIL)         21
				AAdd( aParam, 0             ) // Local nResto    := If(len(paramixb) >=22,paramixb[22],0)           22
				AAdd( aParam, nil           ) // Local cItNFE    := If(len(paramixb) >=23,paramixb[23],NIL)         23   
				AAdd( aParam, TMPSZON->ZO_NUMPLT  ) // Local cPallet  := If(len(paramixb) >=24,paramixb[24],"")     24       
				AAdd( aParam, TMPSZON->ZO_PRODUTO  ) // If(len(paramixb) >=25,paramixb[25],"")                      25       

				AAdd( aParam, TMPSZON->ZO_NUMLOTE    )  //LOTE DO FORNECEDOR                                         26
				AAdd( aParam, StoD(TMPSZON->ZO_RVALID) )           // Data de Revalidade do lote               //27

				ExecBlock("IMG12",,,aParam )               	

				TMPSZON->(dbSkip())

			EndDo

		EndIf

	EndIf


Return lRet



//QUIMICOS              //    1        2       3        4       5      6    7       8       9        10       11       12
User Function VSS_UMntPalete(cForn, cLjForn, cDocNF, cSerNF, dEmisNF, nKG, nVQ ,nTotReg, aColPrLt, cVarPro, cParTip, dDtDigNF)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local nOpc   := GD_INSERT+GD_DELETE+GD_UPDATE
Local cQuery := ""
Local nTotKg := 0
Local nTotTp := 0

Private auCoBrw1  := {}
Private auHoBrw1  := {}
Private cGetPlt   := Soma1(SuperGetMV('MV_SPALQUI',.F.,'20190001'))   //Space(14) 
Private cGetPro   := Space(15) 
Private cSayDesc  := Space(50)
Private cSayTP   := 0
Private cSayKgT   := 0
Private cGetQtdKg := 0
Private cSayData  := Date()
Private cSayDtDig := dDtDigNF
Private cSayFor   := Space(6)
Private cSayLj    := Space(2)
Private cGetLote  := Space(10)
Private cSayNF    := Space(9)
Private cSaySer   := Space(3)
Private cSayProds := Space(40)
Private noBrw1    := 0  
Private cGetVldL  := Date()  //dDataBase           //ver se fixa 5 anos de validade a todos produtos = dDataBase + 1825
Private cGetEnd   := Space(2)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlg1","oSay8",,"oSay9","oSay10","oPanel1","oSay1","oSayNF","oSayKGT","oSayTP")
SetPrvt("oSayFor","oSayLj","oSay3","oSayData","oSay5","oSaySer","oBrw1","oPanel2","oSay4","oSay6","oSay13","oSay14","oSay15","oSay16","oSayProds" )
SetPrvt("oGetEnd","oGetLote",'oGetVLDL',"oGetPlt","oSayDesc","oGetQtdKg","oBtn1","oGetPro","oBtn2","oBtn3","oBtn4")

//If Day(Date()) == 1 .And. Month(Date()) == 1                          // Este IF refere-se ao controle do numero dos pallets de quimicos que ao virar o ano
	If SubStr(GetMV('MV_SPALQUI'),1,4) <> Alltrim(STR(Year(Date())))  // será alterado o ano e começará um novo sequencial Ex.: '20190001'
		cGetPlt := AllTrim(Str(Year(Date())))+'0001'
	EndIf
//EndIf

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 107,277,509,1033,"Inclusão de Pallets - QUIMICOS",,,.F.,,,,,,.T.,,,.T. )
oSay14     := TSay():New( 160,094,{||"Produtos contidos na NF:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
oSayProds  := TSay():New( 160,170,{|u| If(PCount()>0,cSayProds:=u, cSayProds)},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008) 
oPanel1    := TPanel():New( 004,004,"",oDlg1,,.F.,.F.,,,368,020,.T.,.F. )

oSay10     := TSay():New( 172,008,{||"Tot Kg:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSayKGT    := TSay():New( 172,036,{|u| If(PCount()>0,cSayKGT:=u,cSayKGT)},oDlg1,"@E 999,999.9999",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)


oSay15     := TSay():New( 184,008,{||"Tot de Pallets:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,046,008)
oSayTp     := TSay():New( 184,046,{|u| If(PCount()>0,cSayTP:=u,cSayTP)},oDlg1,"@E 999,999.9999",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oSay1      := TSay():New( 008,004,{||"Nota Fical:"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayNF     := TSay():New( 008,040,{|u| If(PCount()>0,cSayNF:=u,cSayNF)},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSaySer    := TSay():New( 008,080,{|u| If(PCount()>0,cSaySer:=u,cSaySer)},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
oSay2      := TSay():New( 008,116,{||"Forn:"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
oSayFor    := TSay():New( 008,136,{|u| If(PCount()>0,cSayFor:=u,cSayFor)},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayLj     := TSay():New( 008,172,{|u| If(PCount()>0,cSayLj:=u,cSayLj)},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
oSay3      := TSay():New( 008,212,{||"Data:"},oPanel1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
oSayData   := TSay():New( 008,236,{|u| If(PCount()>0,cSayData:=u,cSayData)},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
UMHoBrw1()
UMCoBrw1()

oBrw1      := MsNewGetDados():New(068,004,156,368,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','AllwaysTrue()',{|| MarcaDel(1)},oDlg1,aUHoBrw1,aUCoBrw1 )

oPanel2    := TPanel():New( 031,004,"",oDlg1,,.F.,.F.,,,368,033,.T.,.F. )
oSay12     := TSay():New( 004,004,{||"Produto:"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
//oSay13     := TSay():New( 004,094,{||"Descrição:"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay13     := TSay():New( 184,094,{||"Descrição:"},oDLG1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oSay5      := TSay():New( 004,094,{||"Lote:"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
oSay16     := TSay():New( 004,218,{||"Validade Lote:"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oSay4      := TSay():New( 020,004,{||"Pallet:"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
oSay4      := TSay():New( 020,094,{||"Endeço:"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)

oSay7      := TSay():New( 020,211,{||"Qtde Kg:"},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oGetPro    := TGet():New( 004,033,{|u| If(PCount()>0,cGetPro:=u,cGetPro)},oPanel2,052,010,'',{||Vld_Prod(cGetPro,aColPrLt,cVarPro)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetPro",,)
oSayDesc   := TSay():New( 184,132,{|u| If(PCount()>0,cSayDesc:=u,cSayDesc)},oPanel2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,008)

//oGetLote   := TGet():New( 004,308,{|u| If(PCount()>0,cGetLote:=u,cGetLote)},oPanel2,052,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetLote",,)
oGetLote   := TGet():New( 004,132,{|u| If(PCount()>0,cGetLote:=u,cGetLote)},oPanel2,052,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetLote",,)
oGetVLDL   := TGet():New( 004,248,{|u| If(PCount()>0,cGetVLDL:=u,cGetVLDL)},oPanel2,052,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetVLDL",,)

oGetPlt    := TGet():New( 020,033,{|u| If(PCount()>0,cGetPlt:=u, cGetPlt  ) },oPanel2,052,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetPlt",,)
oGetEnd    := TGet():New( 020,132,{|u| If(PCount()>0,cGetEnd:=u,cGetEnd   ) },oPanel2,052,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetEnd",,)
oGetQtdKg  := TGet():New( 020,244,{|u| If(PCount()>0,cGetQtdKg:=u,cGetQtdKg)},oPanel2,052,010,'@E 999,999.9999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtdKg",,)

oBtn1      := TButton():New( 020,302,"Inserir",oPanel2,{|| Inc_Palete(1)},028,012,,,,.T.,,"",,,,.F. )
oBtn4      := TButton():New( 020,335,"Excluir",oPanel2,{|| Del_Palete(1)},028,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 176,332,"Confirmar",oDlg1,{|| UConfir_Proc(nkg,cSaykGT)},037,012,,,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( 176,292,"Cancelar",oDlg1,{|| oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )

cSayFor   := cForn
cSayLj    := cLjForn
cSayNF    := cDocNF
cSaySer   := cSerNF
cSayData  := dEmisNF
cSayProds := cVarPro

//Query para atualizar a grid com todos os pallets
cQuery := " SELECT * FROM "+RetSqlName("SZO")+" "
cQuery += " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NFORI = '"+cSayNF+"' AND ZO_SERIE = '"+cSaySer+"' "
cQuery += " 	AND ZO_CODFOR = '"+cSayFor+"' AND ZO_LJFOR = '"+cSayLj+"' AND D_E_L_E_T_ <> '*' "
cQuery += "	ORDER BY R_E_C_N_O_ DESC "
//cQuery += "	ORDER BY R_E_C_N_O_ ASC "

If Select ('TMPSZO') > 0
	DbSelectArea('TMPSZO')
	DbCloseArea()
EndIf
	
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TMPSZO',.T.,.T.)
DbSelectArea("TMPSZO")
DbGoTop()
nCount := 0
aUCoBrw1 := {}                          
	
//While para alimentar a grid novamente
While !TMPSZO->(EOF())   
	Aadd(aUCoBrw1, {TMPSZO->ZO_PRODUTO, TMPSZO->ZO_NUMPLT, TMPSZO->ZO_QTDEM2, TMPSZO->ZO_NUMLOTE, StoD(TMPSZO->ZO_DTVALID), TMPSZO->ZO_ENDERE, .F. })
	nTotKg += TMPSZO->ZO_QTDEM2
	nCount ++
	TMPSZO->(DbSkip())		
Enddo

oBrw1:SetArray(aUCoBrw1)
oBrw1:oBrowse:Refresh()

cSayKGT:=nTotKg
cSayTp:=nCount

oDlg1:Activate(,,,.T.)

Return




/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ UMHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: 
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function UMHoBrw1()
Local nn1

aCpos :=  	{	{'Cod. Produto'  	,'ZO_PRODUTO'		,15,0	,'@!'						,	'AllwaysTrue()'		},;     // 1
				{'Num. Pallet'  	,'ZO_NUMPLT'		,14,0	,'@!'						,	'AllwaysTrue()'		},;     // 2
				{'QTde Kg'			,'ZO_QTDEM2'		,12,4   ,'@E 9,999,999.9999'		,	'AllwaysTrue()'		},;     // 3
				{'Lote Fornece'		,'ZO_NUMLOTE'		,10,0	,'@!'						,	'AllwaysTrue()'		},;     // 4
				{'Valid Lote'		,'ZO_DTVALID'		,08,0	,'@!'						,	'AllwaysTrue()'		},;     // 5
				{'Endereço'			,'ZO_ENDERE'		,02,0	,'@!'						,	'AllwaysTrue()'		}}      // 6


DbSelectArea("SX3")
DbSetOrder(2)

For nn1 := 1 to len( aCpos )
	if DbSeek( aCpos[ nn1,2 ] )
		If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
			noBrw1++
			
			Aadd(aUHoBrw1,{Trim( aCpos[ nn1,1 ] ),;
			aCpos[ nn1,2 ],;
			aCpos[ nn1,5 ],;
			aCpos[ nn1,3 ],;
			aCpos[ nn1,4 ],;
			aCpos[ nn1,6 ],;
			"",;
			SX3->X3_TIPO,;
			"",;
			"" } )
		EndIf
	Endif
Next
DbSelectArea("SX3")
DbSetOrder(1)

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ UMCoBrw1() - Monta aCols da MsNewGetDados para o Alias: 
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function UMCoBrw1()

Local aAux := {}
Local nI

Aadd(aUCoBrw1,Array(noBrw1+1))
For nI := 1 To noBrw1
   aUCoBrw1[1][nI] := CriaVar(aUHoBrw1[nI][2])
Next
aUCoBrw1[1][noBrw1+1] := .F.

Return

         


////////////////////////////////////////////////////////////////////
////////  Funcao para confirmacao do processo de inclusao dos QUimicos /////////
////////////////////////////////////////////////////////////////////
Static Function UConfir_Proc(nKG,cSayKgT)

//U_VSS_UMntPalete(SF1->F1_FORNECE, SF1->F1_LOJA, SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_EMISSAO, TMPF1A->KG, TMPF1A->QTDREG, TMPF1A->QTDREG, aColPrLt, cVarPro)

Local cQuery   := ""
Local cQuery1  := ""
Local cQuery2  := ""
Local cQuery3  := ""
Local cQuery4  := ""
Local lRet     := .T.
Local _xFlag   := 'N'
Local cAli_SD1 := GetNextAlias()
Local cAli_SZO := GetNextAlias()
Local dDtValid
Local cLocApt  := ''
Local cMA_EXCCQM := SuperGetMV('MA_EXCCQM',.F.,'066641','066642')    //EXCEÇÃO DE PRODUTOS QUE SÃO QUIMICOS, MAS DE OUTRO GRUPO DIFERENTE DE 12/14

If Inclui             //antonio, ajuste para acertar o calculo, pois a quantidade de vaquetas era informada no campo da D1, que só vinha como 0
	If (xFilial("SZO") == '09' .And. AllTrim(POSICIONE("SB1",1,xFilial("SB1")+cGetPro,'B1_GRUPO')) $ '12-14') .OR. cGetPro $ cMA_EXCCQM      
		nTVq := cSayKGT
	EndIf
ElseIf Altera
	If (xFilial("SZO") == '09' .And. AllTrim(POSICIONE("SB1",1,xFilial("SB1")+auCoBrw1[n,1],'B1_GRUPO')) $ '12-14') .OR. auCoBrw1[n,1] $ cMA_EXCCQM   
		nTVq := cSayKGT
	EndIf
EndIf

	cQuery1 := " SELECT SD1.D1_COD, SD1.D1_LOTECTL, SD1.D1_DTVALID, SD1.D1_LOCAL, SUM(SD1.D1_QUANT) D1_QUANT "
	cQuery1 += "    FROM "+RetSqlName("SD1")+" SD1 "
	cQuery1 += "    WHERE SD1.D1_DOC     = '"+cSayNF+"'         AND SD1.D1_SERIE   =  '"+cSaySer+"' AND "
	cQuery1 += "          SD1.D1_FORNECE = '"+cSayFor+"'        AND SD1.D1_LOJA    =  '"+cSayLj+"'  AND "
	cQuery1 += "          SD1.D1_FILIAL  = '"+xFilial('SD1')+"' AND SD1.D_E_L_E_T_ <> '*' "
	cQuery1 += " GROUP BY SD1.D1_COD, SD1.D1_LOTECTL, SD1.D1_DTVALID, SD1.D1_LOCAL  "
	cQuery1 += " ORDER BY SD1.D1_COD, SD1.D1_LOTECTL, SD1.D1_DTVALID, SD1.D1_LOCAL " 

If Select (cAli_SD1) > 0
	DbSelectArea(cAli_SD1)
	DbCloseArea()
EndIf
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAli_SD1,.T.,.T.)

If (cAli_SD1)->(!Eof())
	dDtValid := (cAli_SD1)->D1_DTVALID
	cLocApt  := (cAli_SD1)->D1_LOCAL
EndIf

While (cAli_SD1)->(!Eof())

	cQuery2 := " SELECT SUM(SZO.ZO_QTDCOUR) AS XZO_QTDCOUR, SUM(SZO.ZO_QTDEM2) AS XZO_QTDM2 "
	cQuery2 += "    FROM "+RetSqlName("SZO")+" SZO "
	cQuery2 += "    WHERE SZO.ZO_NFORI   = '"+cSayNF+"'         AND SZO.ZO_SERIE   =  '"+cSaySer+"' "
	cQuery2 += "      AND SZO.ZO_CODFOR  = '"+cSayFor+"'        AND SZO.ZO_LJFOR   =  '"+cSayLj+"' "
	cQuery2 += "      AND SZO.ZO_FILIAL  = '"+xFilial('SZO')+"' AND SZO.D_E_L_E_T_ <> '*' "
	cQuery2 += "      AND SZO.ZO_PRODUTO = '"+(cAli_SD1)->D1_COD+"' " 
//	cQuery2 += "      AND SZO.ZO_NUMLOTE = '"+(cAli_SD1)->D1_LOTECTL+"' " 

	If Select (cAli_SZO) > 0
		DbSelectArea(cAli_SZO)
		DbCloseArea()
	EndIf
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAli_SZO,.T.,.T.)
	
	If (cAli_SZO)->(!Eof())
	
		If (cAli_SD1)->D1_QUANT <> (cAli_SZO)->XZO_QTDM2
			Alert('Os valores totais (por produtos) dos pallets não estão em conformidade com o total informado na NF, Produto: ' + (cAli_SD1)->D1_COD + '. Favor checar!!!')
			lRet:= .F.
		EndIf

	EndIf

	(cAli_SD1)->(dbSkip())	

EndDo

If lRet
	cQuery3 := " UPDATE "+RetSqlName("SZO")+" "
	cQuery3 += " SET ZO_STATUS   = 'LIB'"                                 //trecho para retirar apos campos serem criados
	cQuery3 += "     ,ZO_SITUACA = '2'  "       //Disponivel              //antonio 18/06/19 (os produtos quimicos já iniciam Disponiveis)
	cQuery3 += "     ,ZO_DATAALT =  '" + DtoS(dDataBase) + "' "
	cQuery3 += "     ,ZO_USUARIO =  '" + RetCodUsr()     + "' " 
	cQuery3 += " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NFORI = '"+cSayNF+"' AND ZO_SERIE = '"+cSaySer+"' AND ZO_CODFOR = '"+cSayFor+"' AND ZO_LJFOR = '"+cSayLj+"' "
	cQuery3 += " AND D_E_L_E_T_ <> '*' "
	nret1 := TcSqlExec( cQuery3 )    
	
	//MsgInfo('Processo concluído com sucesso!!!')
	_xFlag := 'S'
	oDlg1:End()
Else
	cQuery3 := " UPDATE "+RetSqlName("SZO")+" "
	cQuery3 += " SET ZO_STATUS = ' ' "
	cQuery3 += " WHERE ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NFORI = '"+cSayNF+"' AND ZO_SERIE = '"+cSaySer+"' AND ZO_CODFOR = '"+cSayFor+"' AND ZO_LJFOR = '"+cSayLj+"' "
	cQuery3 += " AND D_E_L_E_T_ <> '*' "
	nret1 := TcSqlExec( cQuery3 )   
	 _xFlag := 'N'
EndIf

//////////// - Momento em que ira gerar a etiqueta de QUIMICO - antonio 07/03/19

If _xFlag == 'S'

	If MsgYesNo('Emitir etiqueta de Pallet (PNP1) - Quimicos (S/N)?' )

		// Se a etiqueta não tiver movimento, apaga
		CB0->(DbSetOrder(6))
		CB0->(DbSeek(xFilial("CB0") + cSayNF + cSaySer + cSayFor + cSayLj))
		While CB0->(DbSeek(xFilial("CB0") + cSayNF + cSaySer + cSayFor + cSayLj ))
			RecLock("CB0",.F.)
			dbDelete()
			MsUnlock()			
			CB0->(dbSkip())             
		Enddo

		cQuery4 := " SELECT * FROM "+RetSqlName("SZO")+ " "
		cQuery4 += " WHERE  ZO_FILIAL = '"+xFilial('SZO')+"' AND ZO_NFORI = '"+cSayNF+"' AND ZO_SERIE = '"+cSaySer+"' "
		cQuery4 += " 	AND ZO_CODFOR = '"+cSayFor+"'        AND ZO_LJFOR = '"+cSayLj+"' AND D_E_L_E_T_ <> '*' "
		cQuery4 += " 	AND ZO_STATUS = 'LIB' "
	
		If Select ('TMPSZON') > 0
			DbSelectArea('TMPSZON')
			DbCloseArea()
		EndIf
		
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery4),'TMPSZON',.T.,.T.)
		DbSelectArea("TMPSZON")
		DbGoTop()

		While !TMPSZON->(Eof())   
            
			//cLocApt:='01'    //usado somente para teste no caso de ja ter sido impressa a etiqueta. antonio 09/03/19
		
		    SB1->( dbSetOrder(1) )
		    SB1->( dbSeek( xFilial("SB1") + TMPSZON->ZO_PRODUTO ) )
		 	aParam    := {}                  
			nQtOpEtiq := 1
			AAdd( aParam, TMPSZON->ZO_QTDEM2) // quantidade da etiqueta                                         1
			AAdd( aParam, nil           ) // Codigo do separador                                                2
			AAdd( aParam, nil           ) // Código da etiqueta, no caso de uma reimpressão                     3
			AAdd( aParam, nQtOpEtiq     ) // Quantidade de etiquetas                                            4
			AAdd( aParam, cSayNF        ) // nota de entrada                                                    5
			AAdd( aParam, cSaySer       ) // Serie da nota de entrada                                           6
			AAdd( aParam, cSayFor       ) // Codigo do fornecedor da nota de entrada                            7
			AAdd( aParam, cSayLj        ) // Loja do fornecedor da nota de entrada                              8
			AAdd( aParam, cLocApt       ) // Armazem                                                            9
			AAdd( aParam, nil           ) // Numero da OP                                                       10
			AAdd( aParam, nil           ) // Numero sequencial da etiqueta quando for reimpressao               11
			AAdd( aParam, If(SB1->B1_RASTRO=="L", TMPSZON->ZO_NUMLOTE, nil ) )                                //12
			AAdd( aParam, nil           ) // Sublote                                                          //13

//			If StoD( dDTVALID ) <= dDataBase
//				AAdd( aParam, dDataBase+1824 ,nil)            // Data de Validade                             //14
//			Else
				AAdd( aParam, StoD( TMPSZON->ZO_DTVALID) )           // Data de Validade                             //14
//			EndIf

			AAdd( aParam, nil           ) // Centro de Custos                                                 //15
			AAdd( aParam, cLocApt       ) // Local de Origem                                                  //16
			AAdd( aParam, nil           ) // Local cOPREQ    := If(len(paramixb) >=17,paramixb[17],NIL)       //17
			AAdd( aParam, nil           ) // Local cNumSerie := If(len(paramixb) >=18,paramixb[18],NIL)       //18
			AAdd( aParam, nil           ) // Local cOrigem   := If(len(paramixb) >=19,paramixb[19],NIL)         19
			AAdd( aParam, nil           ) // Local cEndereco := If(len(paramixb) >=20,paramixb[20],NIL)         20
			AAdd( aParam, nil           ) // Local cPedido   := If(len(paramixb) >=21,paramixb[21],NIL)         21
			AAdd( aParam, 0             ) // Local nResto    := If(len(paramixb) >=22,paramixb[22],0)           22
			AAdd( aParam, nil           ) // Local cItNFE    := If(len(paramixb) >=23,paramixb[23],NIL)         23   
			AAdd( aParam, TMPSZON->ZO_NUMPLT  ) // Local cPallet  := If(len(paramixb) >=24,paramixb[24],"")     24       
			AAdd( aParam, TMPSZON->ZO_PRODUTO  ) // If(len(paramixb) >=25,paramixb[25],"")                      25       
			AAdd( aParam, TMPSZON->ZO_NUMLOTE  )  //LOTE DO FORNECEDOR                                       //26

			AAdd( aParam, StoD(TMPSZON->ZO_RVALID) )           // Data de Revalidade do lote               //27

			ExecBlock("IMG12",,,aParam )               	

			TMPSZON->(dbSkip())

		EndDo

		dbSelectArea("SX6")
		dbSetOrder(1)
		If SX6->(dbSeek(xFilial("SZO") + "MV_SPALQUI") )
			//Faz a gravacao dos dados na tabela Sx6
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := cGetPlt
			SX6->X6_CONTSPA := cGetPlt
			SX6->X6_CONTENG := cGetPlt
			SX6->(MsUnLock("SX6"))
		EndIf

	EndIf

EndIf

Return lRet

