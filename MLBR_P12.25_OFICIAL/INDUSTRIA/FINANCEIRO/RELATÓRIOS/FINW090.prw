#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

#DEFINE PICVAL  "@E 999,999,999.99"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} FINW090
Relatorio de titulos vencidos e observações pelo Call Center

@author    Willer Trindade
@version   1.00
@since     25/08/2015
/*/
//------------------------------------------------------------------------------------------

User Function FINW090()

Local cQuery := ""

Private aConteud	:= {}
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab        := ""
Private cPerg := PADR("FINW090",10)

If !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
EndIf

Pergunte(cPerg,.T.)



If APMsgNoYes("Deseja Gerar em Excel", "Gerar Excel")
	aDir := MDirArq()
	If Empty(aDir[1]) .OR. Empty(aDir[2])
		Return
	Else
		Processa({ || FINW090_1(mv_par01, mv_par02, mv_par03, mv_par04)})
		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
	EndIf
Else
	
	Alert("Função disponivel apenas para Excel...", "Atenção")
	//	RptStatus({|lEnd| MntRel1(@lEnd,wnRel,titulo,tamanho)},titulo)
	
EndIf

Return

Static Function FINW090_1(mv_par01, mv_par02, mv_par03, mv_par04)

Local _cTexto := ''

AADD(aConteud, {"Contas a Receber X Telecobrança - Vencidos até "+DTOC(mv_par04)})
//					A1		B2		   C3             D4        E5       F6         G7       H8               I9             J10               L11              M12           N13           O14             P15       Q16		    R17			        S18				   V19
AADD(aConteud, {"Cliente","Loja", "Nome Cliente", "Prefixo", "Numero", "Parcela", "Tipo", "Data Emissao", "Vencto Real", "Valor Original", "Valor Atual", "Valor Recebível","Cobrança", "Resp Cobrança", "Jurídico","Despesas","Status Financeiro", "Data Observacao","Status Comercial"}) // 18 Colunas

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Monta a consulta com os movimentos do periodo selecionado
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

If Select("TMP") > 0
	dbSelectArea("TMP")
	TMP->(dbCloseArea())
EndIf

cQuery := ""

cQuery := " SELECT E1_CLIENTE AS A, E1_LOJA AS B, [E1_NOMCLI] AS C, E1_PREFIXO AS D,E1_NUM AS E,"
cQuery += " E1_PARCELA AS F,[E1_TIPO] AS G,E1_EMISSAO AS H,E1_VENCREA AS I,E1_VALOR AS J,[E1_SALDO] AS L,"
cQuery += " '' AS M,'' AS N,'' AS O,'' AS P,'' AS Q,[ACF_CODOBS] AS R,[ACF_DATA] AS S,'' AS V"
cQuery += " FROM SE1010 AS E1 WITH (NOLOCK) "
cQuery += " INNER JOIN SK1010 AS K1 WITH (NOLOCK) "
cQuery += " ON K1_PREFIXO = E1_PREFIXO AND K1_NUM = E1_NUM AND K1_PARCELA = E1_PARCELA "
cQuery += " AND K1_CLIENTE = E1_CLIENTE AND K1_LOJA = E1_LOJA "
cQuery += " INNER JOIN SA1010 AS A1 WITH (NOLOCK) "
cQuery += " ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA "
cQuery += " LEFT OUTER JOIN [ACG010] AS ACG WITH (NOLOCK) "
cQuery += " ON ACG.[ACG_PREFIX] = [E1].[E1_PREFIXO]"
cQuery += " AND ACG.[ACG_TITULO] = [E1].[E1_NUM]"
cQuery += " AND ACG.ACG_PARCEL = [E1].[E1_PARCELA] "
cQuery += " LEFT OUTER JOIN [ACF010] AS ACF WITH (NOLOCK) "
cQuery += " ON ACF.ACF_CODIGO = [ACG].[ACG_CODIGO] "
cQuery += " WHERE [E1].[D_E_L_E_T_] = '' AND K1.[D_E_L_E_T_] = '' AND [ACF].[D_E_L_E_T_] = '' AND A1.[D_E_L_E_T_] = '' AND [ACG].[D_E_L_E_T_] = ''"
cQuery += " AND [E1_EMISSAO] >= '"+DTOS(mv_par01)+"' AND [E1_EMISSAO] <= '"+DTOS(mv_par02)+"'"
cQuery += " AND [E1_VENCREA] >= '"+DTOS(mv_par03)+"' AND [E1_VENCREA] <= '"+DTOS(mv_par04)+"'"
cQuery += " AND E1_BAIXA = ' ' OR E1_BAIXA <> ' ' AND E1_SALDO <= E1_VALOR AND E1_SALDO > 0 "
cQuery += " AND E1_TIPO IN ('NF','FT') "
cQuery += " AND A1_TIPO <> 'X' "
cQuery += " ORDER BY I,A,B,E "



dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), 'TMP', .T., .T. )



DbSelectArea("TMP")
TMP->(dbGotop())
nCount := 0
ProcRegua(RecCount())
Do while TMP->(!eof())
	
	IncProc('Gerando dados ...'+TMP->E)
	
	_cTexto := ''
	// 				 1  2  3  4  5  6  7  8  9  10  11  12  13   14  15  16 17 18 19
	AADD(aConteud, {"","","","","","","","",""," ","" , "", " ", " "," ","","","",""})
	aConteud[len(aConteud),1]  := StrZero(Val(TMP->A),6)
	aConteud[len(aConteud),2]  := StrZero(Val(TMP->B),2)
	aConteud[len(aConteud),3]  := Alltrim(TMP->C)
	aConteud[len(aConteud),4]  := StrZero(Val(TMP->D),2)
	aConteud[len(aConteud),5]  := StrZero(Val(TMP->E),9)
	aConteud[len(aConteud),6]  := Alltrim(TMP->F)
	aConteud[len(aConteud),7]  := Alltrim(TMP->G)
	aConteud[len(aConteud),8]  := dtoC(sTod(TMP->H))
	aConteud[len(aConteud),9]  := dtoC(sTod(TMP->I))
	aConteud[len(aConteud),10] := Alltrim(Transform(TMP->J, "@E 999,999,999.99"))
	aConteud[len(aConteud),11] := Alltrim(Transform(TMP->L, "@E 999,999,999.99"))
	aConteud[len(aConteud),12] := Alltrim(TMP->M)
	aConteud[len(aConteud),13] := Alltrim(TMP->N)
	aConteud[len(aConteud),14] := Alltrim(TMP->O)
	aConteud[len(aConteud),15] := Alltrim(TMP->P)
	aConteud[len(aConteud),16] := Alltrim(TMP->Q)
	
	SYP->(DbSetOrder(1))
	SYP->(DbSeek(xFilial("SYP")+Alltrim(TMP->R)))
	While !SYP->(Eof()) .and. SYP->YP_CHAVE == Alltrim(TMP->R)
		_cTexto += ALLTRIM(Substr(SYP->YP_TEXTO,1,IIF(At("\",SYP->YP_TEXTO)==0,80,At("\",SYP->YP_TEXTO)-1)))
		IF At("\",SYP->YP_TEXTO) > 0
			Alltrim(_cTexto) += chr(13)+chr(13)
		Endif
		SYP->(DbSkip())
	Enddo
	
	aConteud[len(aConteud),17] := Alltrim(StrTran(StrTran(_cTexto,"-",""),".",""))
	aConteud[len(aConteud),18] := dtoC(sTod(TMP->S))
	aConteud[len(aConteud),19] := Alltrim(TMP->V)
	
	
	TMP->(dbSkip())
Enddo

Return()

//--------------------------------
Static Function AjustaSx1(cPerg)
//--------------------------------
//Variaveis locais
Local aRegs := {}
Local i,j
//Inicio da funcao
dbSelectArea("SX1")
dbSetOrder(1)
//   1          2        3         4          5           6       7       8             9        10      11     12       13        14        15         16       17       18       19        20          21        22      23        24       25         26        27       28       29       30          31        32       33       34        35          36        37     38     39       40       41        42
//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_PYME/X1_GRPSXG/X1_HELP/X1_PICTURE
AADD(aRegs,{cPerg,"01","Emissao De"		,"","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Emissao Ate"	,"","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Vencimento De"	,"","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Vencimento Ate"	,"","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

//Loop de armazenamento
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			endif
		Next
		MsUnlock()
	endif
Next
Return()


//+-----------------------------------------------------------------------------------//
//|Funcao....: MDirArq
//|Descricao.: Defini Diretório e nome do arquivo a ser gerado
//|Retorno...: aRet[1] = Diretório de gravação
//|            aRet[2] = Nome do arquivo a ser gerado
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MDirArq()
*-----------------------------------------*
Local aRet := {"",""}
Private bFileFat:={|| cDir:=UZXChoseDir(),If(Empty(cDir),cDir:=Space(250),Nil)}
Private cArq    := Space(10)
Private cDir    := Space(250)
Private oDlgDir := Nil
Private cPath   := "Selecione diretório"
Private aArea   := GetArea()
Private lRetor  := .T.
Private lSair   := .F.

//+-----------------------------------------------------------------------------------//
//| Definição da janela e seus conteúdos
//+-----------------------------------------------------------------------------------//
While .T.
	DEFINE MSDIALOG oDlgDir TITLE "Definição de Arquivo e Diretório" FROM 0,0 TO 175,368 OF oDlgDir PIXEL
	
	@ 06,06 TO 65,180 LABEL "Dados do arquivo" OF oDlgDir PIXEL
	
	@ 15, 10 SAY   "Nome do Arquivo"  SIZE 45,7 PIXEL OF oDlgDir
	@ 25, 10 MSGET cArq               SIZE 50,8 PIXEL OF oDlgDir
	
	@ 40, 10 SAY "Diretorio de gravação"  SIZE  65, 7 PIXEL OF oDlgDir
	@ 50, 10 MSGET cDir PICTURE "@!"      SIZE 150, 8 WHEN .F. PIXEL OF oDlgDir
	@ 50,162 BUTTON "..."                 SIZE  13,10 PIXEL OF oDlgDir ACTION Eval(bFileFat)
	
	DEFINE SBUTTON FROM 70,10 TYPE 1  OF oDlgDir ACTION (UZXValRel("ok")) ENABLE
	DEFINE SBUTTON FROM 70,50 TYPE 2  OF oDlgDir ACTION (UZXValRel("cancel")) ENABLE
	
	ACTIVATE MSDIALOG oDlgDir CENTER
	
	If lRetor
		Exit
	Else
		Loop
	EndIf
EndDo

If lSair
	Return(aRet)
EndIf

aRet := {cDir,cArq}

Return(aRet)



*-----------------------------------------*
Static Function UZXChoseDir()
*-----------------------------------------*
Local cTitle:= "Geração de arquivo"
Local cMask := "Formato *|*.*"
Local cFile := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions:= GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY

cFile:= cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,.F., nOptions)

Return(cFile)


//+-----------------------------------------------------------------------------------//
//|Funcao....: UZXValRel()
//|Descricao.: Valida informações de gravação
//|Uso.......: U_UZXDIRARQ
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function UZXValRel(cValida)
*-----------------------------------------*

Local lCancela

If cValida = "ok"
	If Empty(Alltrim(cArq))
		MsgInfo("O nome do arquivo deve ser informado","Atenção")
		lRetor := .F.
	ElseIf Empty(Alltrim(cDir))
		MsgInfo("O diretório deve ser informado","Atenção")
		lRetor := .F.
		//	ElseIf Len(Alltrim(cDir)) <= 3
		//		MsgInfo("Não se pode gravar o arquivo no diretório raiz, por favor, escolha um subdiretório.","Atenção")
		//		lRetor := .F.
	Else
		oDlgDir:End()
		lRetor := .T.
	EndIf
Else
	lCancela := MsgYesNo("Deseja cancelar a geração do Relatório / Documento?","Atenção")
	If lCancela
		oDlgDir:End()
		lRetor := .T.
		lSair  := .T.
	Else
		lRetor := .F.
	EndIf
EndIf

Return(lRetor)


//+-----------------------------------------------------------------------------------//
//|Funcao....: MCSV
//|Descricao.: Gera Arvquivo do tipo csv
//|Retorno...: .T. ou .F.
//|Observação:
//+-----------------------------------------------------------------------------------//

*-------------------------------------------------*
Static Function MCVS(axVet,cxCab,cxArqTxt,PICTUSE)
*-------------------------------------------------*

Local cEOL       := CHR(13)+CHR(10)
Local nTamLin    := 2
Local cLin       := Space(nTamLin)+cEOL
Local cDadosCSV  := ""
Local lRet       := .T.
Local nHdl,nt,jk       := 0

If Len(axVet) == 0
	MsgInfo("Dados não informados","Sem dados")
	lRet := .F.
	Return(lRet)
ElseIf Empty(cxArqTxt)
	MsgInfo("Diretório e nome do arquivo não informados corretamente","Diretório ou Arquivo")
	lRet := .F.
	Return(lRet)
EndIf

cxArqTxt := cxArqTxt+".csv"
nHdl := fCreate(cxArqTxt)

If nHdl == -1
	MsgAlert("O arquivo de nome "+cxArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
EndIf

nTamLin := 2
cLin    := Space(nTamLin)+cEOL

ProcRegua(Len(axVet))

If !Empty(cxCab)
	cLin := Stuff(cLin,01,02,cxCab)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no Cabeçalho. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		EndIf
	EndIf
EndIf

For jk := 1 to Len(axVet)
	nTamLin   := 2
	cLin      := Space(nTamLin)+cEOL
	cDadosCSV := ""
	IncProc("Gerando arquivo...")
	For nt := 1 to Len(axVet[jk])
		If ValType(axVet[jk,nt]) == "C"
			cDadosCSV += Alltrim(axVet[jk,nt]+IIf(nt = Len(axVet[jk]),"",";"))
		ElseIf ValType(axVet[jk,nt]) == "N"
			cDadosCSV += Alltrim(Transform(axVet[jk,nt],PICTUSE)+IIf(nt = Len(axVet[jk]),"",";"))
		ElseIf ValType(axVet[jk,nt]) == "U"
			cDadosCSV += Alltrim(+IIf(nt = Len(axVet[jk]),"",";"))
		Else
			cDadosCSV += Alltrim(axVet[jk,nt]+IIf(nt = Len(axVet[jk]),"",";"))
		EndIf
	Next
	
	cLin := Stuff(cLin,01,02,cDadosCSV)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo nos Itens. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		EndIf
	EndIf
Next

fClose(nHdl)
Return(lOk)

//+-----------------------------------------------------------------------------------//
//|Funcao....: MExcel
//|Descricao.: Abre arquivo csv em excel
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MExcel(cxDir,cxArq)
*-----------------------------------------*
Local cArqTxt := cxDir+cxArq+".csv"
Local cMsg    := "Relatorio gerado com sucesso!"+CHR(13)+CHR(10)+"O arquivo "+cxArq+".csv"
cMsg    += " se encontra no diretório "+cxDir

MsgInfo(cMsg,"Atenção")

If MsgYesNo("Deseja Abrir o arquivo em Excel?","Atenção")
	If ! ApOleClient( 'MsExcel' )
		MsgStop(" MsExcel nao instalado ")
		Return
	EndIf
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cArqTxt)
	oExcelApp:SetVisible(.T.)
EndIf

Return
