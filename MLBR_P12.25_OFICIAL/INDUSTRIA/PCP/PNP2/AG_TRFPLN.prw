#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

User Function AG_TRFPLN()
Private cPerg := PADR("AG_TRFPLN",10)
Private lEnd := .F.

if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	ValidPerg(cPerg)
endif                                                                       
Pergunte(cPerg,.T.)      

	if ApMsgNoYes("Confirma parametros selecionados?","Atenção")
		Processa({||GERASZP(mv_par01, mv_par02, mv_par03, mv_par04, lEnd)},"Aguarde", "Analisando Filtros de Planos.......", .T.)
	endif
return 

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para filtrar a tabela SBZ conforme parametros
//////////////////////////////////////////////////////////////////////////////////////////////////////////
static function GERASZP(cPlnIni, cPlnFim, cDataIni, cDataFim, lEnd)
Local cQSZP   := "" // Filtrar Arquivos da tabela SBZ conforme paramentros
Private aPln    := {}

//Montar a query
cQSZP := " Select SZP.R_E_C_N_O_ CHAVE, ZP_OPMIDO, ZP_ANO, ZP_PRODUTO, ZP_DESCPRD, ZP_EMISSAO, ZP_CLIENTE, ZP_NOMCLIE, ZP_PRDSTRF "
cQSZP += " from "+RetSqlName("SZP")+" SZP with (nolock) " 
cQSZP += " Where D_E_L_E_T_ = ' ' AND ZP_FILIAL = '"+xFilial("SZP")+"' "
cQSZP += " AND ZP_OPMIDO between '"+cPlnIni+"' AND '"+cPlnFim+"' AND ZP_EMISSAO between '"+dTos(cDataIni)+"' AND '"+dTos(cDataFim)+"' "

MemoWrite("C:\TEMP\cQSZP.txt", cQSZP) //Grava a query em txt

if Select("TMPZP") > 0 
	dbSelectArea("TMPZP")
	TMPZP->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQSZP), "TMPZP", .T., .T.)

dbSelectArea("TMPZP")
ProcRegua(0)
nCount := 0
TMPZP->(dbGotop())
while !TMPZP->(eof())
	AADD(aPln, { TMPZP->CHAVE, ALLTRIM(TMPZP->ZP_OPMIDO), TMPZP->ZP_ANO, ALLTRIM(TMPZP->ZP_PRODUTO), ALLTRIM(TMPZP->ZP_DESCPRD), dToc(sTod(TMPZP->ZP_EMISSAO)), TMPZP->ZP_CLIENTE, ALLTRIM(TMPZP->ZP_NOMCLIE), TMPZP->ZP_PRDSTRF})
	nCount++
	IncProc("Filtrando plano "+ALLTRIM(TMPZP->ZP_OPMIDO)+" Registro "+cValToChar(nCount))
	if lEnd 
		Return
	endif
	TMPZP->(dbSkip())
enddo
if len(aPln) > 0 
	Processa({||GERASC2(cPlnIni, cPlnFim, cDataIni, cDataFim, aPln, lEnd)},"Aguarde", "Analisando Filtros de Ordem de Produção.......", .T.)
else
	Alert("Não existem planos para o filtro selecionado..."+chr(13)+chr(13)+"Por favor revisar os filtros...","Atenção - TI Midori")
endif

return 

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para filtrar os planos que já tiveram apontamentos na SD3
//////////////////////////////////////////////////////////////////////////////////////////////////////////
static function GERASC2(cPlnIni, cPlnFim, cDataIni, cDataFim, aPln, lEnd)
Local cQSC2   := "" // Filtrar a produção já realizada em SC2 - C2_QUJE
Local cQD3TRF := "" // Filtra transferencias já realizadas da SD3
Local i
Private aSC2    := {}
Private aSC2Aux := {}

cQSC2 := " Select ZP_FILIAL, ZP_OPMIDO, C2_NUM, C2_PRODUTO, B1_DESC, C2_QUJE, C2_LOCAL, C2_EMISSAO "
cQSC2 += " from SZP010 SZP with (nolock), SC2010 SC2 with (nolock), SB1010 SB1 with (nolock) "
cQSC2 += " where SZP.D_E_L_E_T_ =' ' and SC2.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' "
cQSC2 += " and ZP_FILIAL = C2_FILIAL  "
cQSC2 += " and C2_PRODUTO = B1_COD "
cQSC2 += " and ZP_OPMIDO = C2_OPMIDO and ZP_ANO = Substring(C2_EMISSAO,1,4)  "
cQSC2 += " AND ZP_OPMIDO between '"+cPlnIni+"' AND '"+cPlnFim+"' "
cQSC2 += " and C2_QUJE > 0  "
cQSC2 += " AND ZP_FILIAL = '"+xFilial("SZP")+"' and C2_FILIAL ='"+xFilial("SC2")+"' "
cQSC2 += " AND ZP_EMISSAO between '"+dTos(cDataIni)+"' AND '"+dTos(cDataFim)+"' "
cQSC2 += " ORDER BY 2 "

MemoWrite("C:\TEMP\AG_TRFPLN-cQSC2.TXT", cQSC2)



if Select("TMPC2") > 0
	dbSelectArea("TMPC2")
	TMPC2->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQSC2), "TMPC2", .T.,.T.)

ProcRegua(0)
nCountC2 := 0
dbSelectArea("TMPC2")
TMPC2->(dbGotop())
while !TMPC2->(eof())
	AADD(aSC2Aux, {.T., ALLTRIM(TMPC2->ZP_OPMIDO), TMPC2->C2_NUM, ALLTRIM(TMPC2->C2_PRODUTO), ALLTRIM(TMPC2->B1_DESC), TMPC2->C2_QUJE, TMPC2->C2_LOCAL, Dtoc(sTod(TMPC2->C2_EMISSAO)) } )
	nCountC2++
	IncProc("Filtrando OPs Baixadas "+ALLTRIM(TMPC2->C2_NUM)+" Registro "+cValToChar(nCountC2))
		if lEnd 
			Return
		endif
	TMPC2->(dbSkip())
enddo

cPln001 := aPln[1][2]
for i:= 1 to len(aSC2Aux)
	if aSC2Aux[i][2] == cPln001
		AADD(aSC2, { aSC2Aux[i][1], aSC2Aux[i][2], aSC2Aux[i][3], aSC2Aux[i][4], aSC2Aux[i][5], aSC2Aux[i][6], aSC2Aux[i][7], aSC2Aux[i][8] } )
	endif
next i


MNTTRFPLN()

return


//////////////////////////////////////////////////////////////////////////////////////////////////////////
//Montar a tela que o usuário vai visualizar os planos e escolher qual será transferido de armazem
//////////////////////////////////////////////////////////////////////////////////////////////////////////
Static function MNTTRFPLN()
Private cGetArm := Space(2)
Private cMsg    := Space(25)
Private oOk := LoadBitmap( GetResources(), "LBOK")
Private oNo := LoadBitmap( GetResources(), "LBNO")
Private tchkAll := .T.
Private cTrans := ""
Private aSldD3 := {}

SetPrvt("oFont1","oDlg1","oSay1","oSay2","oSay3","oSayTrfCf","oGrp1","oLBoxSZP","oGrp2","oLBoxSC2","oBtn1","oBtn2")
SetPrvt("oCBox1")

DEFINE FONT oFontSay     NAME "Arial"    SIZE 0,16  BOLD

oFont1     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 092,232,644,1261,"Transferencia de Armazem - Por Plano",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 172,424,{||"Informe o Armazem"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,084,008)
oSay2      := TSay():New( 185,425,{||"de destino"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,067,008)
oSayTrfCf  := TSay():New( 116,424,{||cMsg},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,080,008)
oSay3      := TSay():New( 264,486,{||"By Anesio"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)
oGrp1      := TGroup():New( 004,004,100,504,"Relação de Planos...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrp2      := TGroup():New( 105,004,252,420,"Relação de Produtos...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBtn1      := TButton():New( 128,424,"&Verificar transferencia",oDlg1,{||Alert("Rotina em desenvolvimento!")},080,012,,,,.T.,,"",,,,.F. )
//@ 128,424  BUTTON "&Verificar transferencia" SIZE 080, 012 ACTION Processa( {|| }, 'Verificando transferencias...') of oDlg1 Pixel
@ 208,424  BUTTON "&Transferir"       SIZE 80,16   ACTION  Processa( {|| TRFARM()}, 'Checando itens para transferir ...' )     of oDlg1 Pixel 
oGet1      := TGet():New( 184,480,{|u| If(PCount()>0,cGetArm:=u,cGetArm)},oDlg1,024,012,'',,CLR_BLACK,CLR_HGRAY,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetArm",,)
@ 256 , 004  CHECKBOX oCBox1 VAR tchkAll PROMPT 'Marcar/Desmarcar todos' ON CHANGE CHNG_LST()  OF  oDlg1  SIZE 075,008  FONT oFontSay COLOR CLR_BLUE   PIXEL
@ 012,008  LISTBOX oLBoxSZP VAR cFics Fields HEADER 'Chave','Plano','Ano' ,'Produto', 'Descrição' , "Emissao","Cliente", "Nome do Cliente ", "Transferido"  SIZE 492,084 ON CHANGE ChngGrpPrs() pixel 
oLBoxSZP:SetArray(aPln)
oLBoxSZP:bLine := { || { aPln[oLBoxSZP:nAt,1],aPln[oLBoxSZP:nAt,2],aPln[oLBoxSZP:nAt,3],aPln[oLBoxSZP:nAt,4] , aPln[oLBoxSZP:nAt,5] , aPln[oLBoxSZP:nAt,6], aPln[oLBoxSZP:nAt,7], aPln[oLBoxSZP:nAt,8], aPln[oLBoxSZP:nAt,9] }  }

@ 113,008  LISTBOX oLBoxSC2 VAR cFiOps Fields HEADER '    ','Plano','Num.OP.' ,'Produto', 'Descrição' , "Qtde","Armazem", "Dt.Emissao "  SIZE 408,136 ON DBLCLICK Chk_C2()  pixel // ON CHANGE CHNG() ON DBLCLICK Ad_PrLst()          
oLBoxSC2:SetArray(aSC2)
oLBoxSC2:bLine := { || { iif( aSC2[oLBoxSC2:nAt,1], ook, oNo ), aSC2[oLBoxSC2:nAt,2],aSC2[oLBoxSC2:nAt,3],aSC2[oLBoxSC2:nAt,4],aSC2[oLBoxSC2:nAt,5] , aSC2[oLBoxSC2:nAt,6] , aSC2[oLBoxSC2:nAt,7], aSC2[oLBoxSC2:nAt,8] }  }

oDlg1:Activate(,,,.T.)

Return
//Fim da tela
//////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//A Função abaixo tem objetivo de permitir a marcação de itens individual na lista
Static function Chk_C2()
Local cFicMain := aSC2[oLBoxSC2:nAt,3]
Local lFlagChk  := aSC2[oLBoxSC2:nAt,1]
Local nn1
//
For nn1 := 1 to len( aPln )
	if aSC2[nn1 , 3 ] == cFicMain
		if ! lFlagChk
			aSC2[nn1 , 1 ]  := .t.
		Else
			aSC2[nn1 ,1 ]  := .f.
		Endif
	Endif
Next
oLBoxSC2:REfresh()


return

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//A Função abaixo tem o objetivo de marcar/desmarcar todos os itens da lista de uma unica vez
Static Function CHNG_LST()
Local nn1

For nn1 := 1 to len( aSC2 )
	if tchkAll
		aSC2[nn1 , 1 ]  := .t.
	Else
		aSC2[nn1 ,1 ]  := .f.
	Endif
Next
oLBoxSC2:REfresh()
Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//A Função abaixo tem o objetivo de filtrar as OPs conforme posicionamento na grid de Planos
Static Function ChngGrpPrs()

Local nn1
cPlano := aPln[oLBoxSZP:nAt,2]
cTrans := aPln[oLBoxSZP:nAt,9]
aSC2   := {}

if cTrans == "S"
	cMsg:= "Já Transferido"
	oBtn1:Enable()
else
	cMsg:= ""
	oBtn1:disable()
endif
oSayTrfCf:Refresh()
oBtn1:refresh()

For nn1 := 1 to len( aSC2Aux )
	if aSC2Aux[nn1][2] == cPlano
		AADD(aSC2, { aSC2Aux[nn1][1], aSC2Aux[nn1][2], aSC2Aux[nn1][3], aSC2Aux[nn1][4], aSC2Aux[nn1][5], aSC2Aux[nn1][6], aSC2Aux[nn1][7], aSC2Aux[nn1][8] } )
	Endif
Next
oLBoxSC2:REfresh()
return

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//A Função abaixo tem o objetivo de filtrar as OPs conforme posicionamento na grid de Planos
static function TRFARM()
local cArmVld := GetMV ("MA_LOCVLD")
local lTrans  := .F.
Local i

if !tchkAll 
	Alert("Não há itens marcado para transferencia!")
elseif cTrans == "S"
	ApMsgInfo("O Plano já foi transferido!","Atenção")
else
	if cGetArm $ cArmVld
	    if cGetArm <> aSC2[oLBoxSC2:nAt,7]
			if ApMsgNoYes("Confirma a transferencia do plano selecionado? ","Atenção - TI Midori")
	//			Processa({ || lRet := AGOPAPONT() }, "Verificando OPs apontada...") 
				lRet := AGOPAPONT()
				if lRet
//				    Processa({ || lRet := AGVEREST()}, "Verificando saldos para transferir...")
					lRet := AGVEREST()
				endif
			    if lRet
			    	for i:= 1 to len(aSldD3)
//			    		AADD(aSldD3, {TMPD3->CHAVE, ALLTRIM(TMPD3->D3_COD), ALLTRIM(TMPD3->D3_OP), TMPD3->D3_LOCAL, TMPD3->D3_QUANT})
						if Substr(aSldD3[i][7],1,2) <>'OP'
//																					AG_TrfArm(cOpFic  ,nQtde       , cCodProd    , cDescrPrd                                               , cGFicha                                            , cArmOri     , cArmDes)
							nSpace := 15 - len(aSldD3[i][2])
							Processa({ || AG_TrfArm(Substr(aSldD3[i][3],1,6)+Substr(aSldD3[i][6],3,3) ,aSldD3[i][5], aSldD3[i][2]+space(nSpace), Posicione("SB1",1,xFilial("SB1")+aSldD3[i][2],"B1_DESC"), 'OP:'+Substr(aSldD3[i][3],1,6)+'NSEQ:'+aSldD3[i][6], aSldD3[i][4], cGetArm)}, "Transferindo produtos do plano")
							//Grava observacao na SD3 para evitar nova transferencia
							dbSelectArea("SD3")
							SD3->(dbGoto(aSldD3[i][1]))
							RecLock("SD3",.F.)
							Replace D3_ATLOBS with 'OP:'+Substr(aSldD3[i][3],1,6)+'NSEQ:'+aSldD3[i][6]
							MsUnlock("SD3")
							lTrans := .T.
						endif
					next i
				endif
			else
				Alert("Rotina cancelada pelo operador...")
	
    		endif
 		else
 			ApMsgInfo("Armazem de destino igual armazem de origem"+chr(13)+chr(10)+"Transferencia não permitida...","Atençao - TI Midori")
 		endif
 	else
 		ApMsgInfo("Armazem não permitido transferencia nessa rotina!"+chr(13)+chr(10)+"Verificar parametro MA_LOCVLD...";
 		+"Armazens Permidito "+ALLTRIM(cArmVld),"Atenção - TI Midori")
 	endif
endif

if lTrans 
	dbSelectArea("SZP")
	SZP->(dbGoto(aPln[oLBoxSZP:nAt,1]))
	RecLock("SZP",.F.)
	Replace ZP_PRDSTRF with 'S'
	MsUnLock("SZP")
	aPln[oLBoxSZP:nAt,9] := 'S'
	oLBoxSZP:refresh()
	ApMsgInfo("Rotina de transferencia executada com sucesso...")
endif

return

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//A Função abaixo tem o objetivo consultar os saldos em estoque antes de efetuar a transferencia
static function AGVEREST()
local lRet   := .T.
local aSldB2 := {}
Local i

dbSelectArea("SB2")
dbSetOrder(1)
ProcRegua(0)
for i:= 1 to len(aSC2)
	nTam := 15-len(aSC2[i][4])
	if dbSeek(xFilial("SB2")+aSC2[i][4]+space(nTam)+aSC2[i][7])
		if SB2->B2_QATU < aSC2[i][6]
			AADD(aSldB2, {SB2->B2_COD, ALLTRIM(Posicione("SB1",1, xFilial("SB1")+SB2->B2_COD,"B1_DESC")), SB2->B2_LOCAL, SB2->B2_QATU, aSC2[i][6], SB2->B2_QATU - aSC2[i][6]})
			lRet := .F.
		endif
	endif
	IncProc("Buscando Saldos "+Alltrim(aSC2[i][4])+" Registro "+cValToChar(i))
next i 

retindex("SB2")

if !lRet
	if ApMsgNoYes("Não há saldo suficiente para transferir o plano"+chr(13)+chr(13)+"Deseja visualizar os itens com problema ?", "Atenção - TI Midori")
		ShowSLD(aSldB2)
	endif
endif
return lRet


//////////////////////////////////////////////////////////////////////////////////////////////////////////
//A Função abaixo tem o objetivo de validar se as OPs do plano já foram todas apontadas
static function AGOPAPONT()
local lRet   := .T.
local cOps   := ""
local cQD3   := ""
Local i

ProcRegua(0)
for i:= 1 to len(aSC2)
	cOps := cOPs+"'"+aSC2[i][3]+"',"
    IncProc("Identificando OPs já finalizadas "+aSC2[i][3]+" Registro "+cValToChar(i))
next i
	cOPs := "("+Substr(cOps,1,Len(cOps)-1)+")"

cQD3 := "SELECT R_E_C_N_O_ CHAVE, D3_COD, D3_OP, D3_LOCAL, D3_QUANT, D3_NUMSEQ, D3_ATLOBS FROM "+RetSqlName("SD3")+ " SD3 with (nolock) "
cQD3 += " WHERE D_E_L_E_T_ = ' ' and D3_FILIAL = '"+xFilial("SD3")+"' "
cQD3 += " AND Substring(D3_OP,1,6) in "+cOPs
cQD3 += " AND D3_CF = 'PR0' " 

MemoWrite("C:\TEMP\AG_TRFPLN-cQD3.txt", cQD3)

if Select("TMPD3") > 0
	dbSelectArea("TMPD3")
	TMPD3->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQD3), "TMPD3", .T., .T.)

dbSelectArea("TMPD3")
TMPD3->(dbGotop())
procRegua(1)
nCount := 0
while !TMPD3->(eof())
	AADD(aSldD3, {TMPD3->CHAVE, ALLTRIM(TMPD3->D3_COD), ALLTRIM(TMPD3->D3_OP), TMPD3->D3_LOCAL, TMPD3->D3_QUANT, TMPD3->D3_NUMSEQ, TMPD3->D3_ATLOBS})
	nCount++
	IncProc("Gravando arquivo de transferencia "+ALLTRIM(TMPD3->D3_COD)+" Registro "+cValToChar(nCount))
	TMPD3->(dbSkip())
enddo

if nCount == 0
	lRet := .F.
endif

return lRet


//////////////////////////////////////////////////////////////////////////////////////////////////////////
//A Função abaixo tem o objetivo mostrar os produtos sem saldos para que seja verificado antes de transferir
Static Function ShowSLD(aSldB2)
SetPrvt("oDlgPrdSld","oLBox1","oBtnPrint")

oDlgPrdSld := MSDialog():New( 092,232,548,1069,"Produtos sem saldos - TI Midori",,,.F.,,,,,,.T.,,,.T. )
//oLBox1     := TListBox():New( 004,004,,,404,192,,oDlgPrdSld,,CLR_BLACK,CLR_WHITE,.T.,,,,"",,,,,,, )
@ 004,004  LISTBOX oLBox1 VAR cLstPrd Fields HEADER 'Código','Descrição','Armazem' ,'Est.Disponivel', 'Est.a transf' , "Diferença" SIZE 404,192 pixel // ON CHANGE CHNG() ON DBLCLICK Ad_PrLst()          
oLBox1:SetArray(aSldB2)
oLBox1:bLine := { || { Alltrim(aSldB2[oLBox1:nAt,1]), AllTrim(aSldB2[oLBox1:nAt,2]),aSldB2[oLBox1:nAt,3],aSldB2[oLBox1:nAt,4],aSldB2[oLBox1:nAt,5] , aSldB2[oLBox1:nAt,6]  }  }

oBtnPrint  := TButton():New( 204,348,"&Imprimir",oDlgPrdSld,{|| Alert("Em desenvolvimento")},060,012,,,,.T.,,"",,,,.F. )


oDlgPrdSld:Activate(,,,.T.)

Return


////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina que vai fazer a transferencia dos produtos
*------------------------------------*
Static Function AG_TrfArm(cOpFic ,nQtde, cCodProd, cDescrPrd, cGFicha, cArmOri, cArmDes)
*------------------------------------*
//Alert("Transferencia a ser realizada ->"+chr(13)+"Documento: "+cOpFic+" qtde-> "+cValToChar(nMtTot)+" FICHA: "+cgFicha+" Produto: "+cCodProd)
aLin = {}
aCab = {}

aAdd (aCab,{ cOpFic, ddatabase})

				aadd (aLin, cCodProd) // Produto origem
				aadd (aLin, Substr(Alltrim(cDescrPrd),1,30)) // Descricao produto origem
				aadd (aLin, Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_UM")) // UM origem
				aadd (aLin, cArmOri) // Almox origem 
				aadd (aLin, '') // Endereco origem
				aadd (aLin, cCodProd) // Produto destino
				aadd (aLin, Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_DESC")) // Descricao produto origem
				aadd (aLin, Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_UM")) // UM destino
				aadd (aLin, cArmDes) // Almox destino
				aadd (aLin, '') // Endereco destino
				aadd (aLin, '') // Num serie
				aadd (aLin, '') // Lote
				aadd (aLin, '') // Sublote
				aadd (aLin, criavar('D3_DTVALID'))
				aadd (aLin, 0) // Potencia
				aadd (aLin, nQtde) // Quantidade
				nQtdeSeg := Iif(Posicione(("SB1"),1,xFilial("SB1")+cCodProd,"B1_TIPCONV")=='M', nQtde*Posicione(("SB1"),1,xFilial("SB1")+cCodProd,"B1_CONV"),nQtde / Posicione(("SB1"),1,xFilial("SB1")+cCodProd,"B1_CONV"))
				aadd (aLin, nQtdeSeg) // Qt seg.UM
				aadd (aLin, '') //criavar("D3_ESTORNO")) // Estornado
				aadd (aLin, criavar("D3_NUMSEQ")) // Sequencia (D3_NUMSEQ)
				aadd (aLin, '') //criavar("D3_LOTECTL")) // Lote destino
				aadd (aLin, criavar("D3_DTVALID")) // Validade
				aadd (aLin, criavar("D3_ITEMGRD")) // Item da Grade
				aadd (aLin, criavar("D3_CODLAN")) //CodLan Cat83 - Origem
				aadd (aLin, criavar("D3_CODLAN")) //CodLan Cat83 - Destino
				aadd (aLin, criavar("D3_PERIMP")) // Percentual de Importação
				aadd (aLin, criavar("D3_CUSANT")) // Cusant
				
				aadd (aCab, aclone (aLin))
                                                  
			lMSErroAuto = .F.
			cNumSeq:= GetMv ('MV_DOCSEQ') 
			cNumSeq:= Soma1(cNumSeq)
//		    Alert('NumSEQ de transferencia-> ' +cNumSeq)			
	   		msexecauto({|x| Mata261(x)}, aCab, 2)
		   If lMsErroAuto
				MostraErro ()
				Alert("A Transferencia desse produto não foi realizada, favor verificar e transferir manualmente para evitar divergencias","Atenção")
				u_mailertrf(cgFicha, cCodProd)
		   else
//		   alert("Transferido com sucesso...")
		   dbSelectArea("SD3")     
		   dbSetOrder(4)
		   if dbSeek(xFilial("SD3")+cNumSeq)
		   		while !SD3->(eof()) .and. SD3->D3_NUMSEQ == cNumSEQ
		   			if SD3->D3_ATLOBS == space(20)
		   				RecLock("SD3",.F.)
		   				SD3->D3_ATLOBS := cgFicha
		   				MsUnlock("SD3")
		   			endif
		   			SD3->(dbSkip())
		   		enddo
		   endif
//		   		Alert("Transferencia realizada com sucesso...."+chr(13)+"Documento: "+cOpFic+" qtde-> "+cValToChar(nMtTot)+" FICHA: "+cgFicha+" Produto: "+cCodProd)
		   endif
return



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Enviar e-mail quando houver problema de transferencia
user function mailertrf(cFicha, cCodProd)

Local _cEmlFor := ''
Local oProcess 
Local oHtml
Local nCont := 0
     
       _cEmlFor := 'diego.mafisolli@midoriatlantica.com.br' 

     SETMV("MV_WFMLBOX","WORKFLOW") 
     oProcess := TWFProcess():New( "000005", "Problema na transferencia entre almoxarifado - prod "+ALLTRIM(cCodProd) )
     oProcess :NewTask( "Problema na transferencia entre almoxarifado", "\WORKFLOW\HTM\trfautalmox.HTM" )
     oHtml    := oProcess:oHTML
     	oHtml:ValByName( "data", dtoc(ddatabase))
     	oHtml:ValByName( "numOP", cFicha)
     	oHtml:ValByName( "NumFicha", 'OP:'+cFicha)
     	oHtml:ValByName( "NumPlano", '')
	 	aAdd( oHtml:ValByName( "it.desc" ), "Houve problema na transferencia de estoque entre armazens da ordem de producao acima" )
   	 	aAdd( oHtml:ValByName( "it.desc" ), "favor analisar para evitar divergencias ao final do mes.")
   	 	aAdd( oHtml:ValByName( "it.desc" ), "o erro ocorreu na senha do usuario "+Substr(cUsuario,1,20)+ " e o mesmo " )
   	 	aAdd( oHtml:ValByName( "it.desc" ), "tambem recebeu uma mensagem na tela informando sobre o fato..." )

		oProcess:cSubject := "Problema com transferencia automatica entre armazens " + dToc(dDatabase) +" produto "+ALLTRIM(cCodProd)



	oProcess:cTo      := _cEmlFor     


oProcess:Start()                    
	       WFSendMail()
	       //WFSendMail()	       
oProcess:Finish()


return




//--------------------------------
Static Function ValidPerg(cPerg)
//--------------------------------
//Variaveis locais
Local aRegs := {}
Local i,j
//Inicio da funcao
dbSelectArea("SX1")
dbSetOrder(1)
//   1          2        3         4          5           6       7       8             9        10      11     12       13        14        15         16       17       18       19        20          21        22      23        24       25         26        27       28       29       30          31        32       33       34        35          36        37     38     39       40       41        42
//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_PYME/X1_GRPSXG/X1_HELP/X1_PICTURE
AADD(aRegs,{cPerg,"01","De Plano" 	    ,"","","mv_ch1","C",20,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SZP","","","",""})
AADD(aRegs,{cPerg,"02","Ate Plano"	    ,"","","mv_ch2","C",20,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SZP","","","",""})
AADD(aRegs,{cPerg,"03","Data de"		,"","","mv_ch9","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Data ate"	    ,"","","mv_cha","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"11","De Filial"  	,"","","mv_chb","C",02,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"12","Ate. Filial"	,"","","mv_chc","C",02,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

//Loop de armazenamento
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif     
Next
//Retorno da funcao
Return()