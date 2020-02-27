#INCLUDE "Protheus.ch"  

#DEFINE PICVAL  "@E 999,999,999.99"

///////////////////////////////////////////////////////////////////////////////
//Relatorio de kardex resumido de todas as filiais. Objetivo de facilitar a conciliação contabil.
//Gera em planilha toda a movimentacao de entrada e saida de todas as unidades 
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br - 17-04-2013
///////////////////////////////////////////////////////////////////////////////

User Function AG_KDXEXL1()

Local cQuery := ""
Private cPerg := PADR("AGKARDEX",10)
if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
endif
Pergunte(cPerg,.T.)      

//Exclusivo para gerar para Excel
Private aConteud:= {}       
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab        := "" 

if APMsgNoYes("Deseja Gerar para Excel", "Gerar Excel")
	aDir := MDirArq()
	If Empty(aDir[1]) .OR. Empty(aDir[2])
		Return
	Else                      
		U_AG1_KDXEXL(mv_par01, mv_par02)
		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif
else

	Alert("Função disponivel apenas para Excel...", "Atenção")
//	RptStatus({|lEnd| MntRel1(@lEnd,wnRel,titulo,tamanho)},titulo)

endif							

return 

user function AG1_KDXEXL(mv_par01, mv_par02)

AADD(aConteud, {"KARDEX GLOBAL - MES "+MV_PAR01+" ANO "+MV_PAR02})
//					1		2		   3           4              5         6            7             8          9            10           11          12            13        14            15           16          17      18          19        20
AADD(aConteud, {"FILIAL","PRODUTO", "GRUPO", "CONTA PRODUTO", "ORIGEM", "DT.ENTRADA", "CONTA MOV.", "TES/TM", "TIPO MOV.", "DOCUMENTO", "VLR.SAIDA","VLR.ENTRADA", "NUM.SEQ","ORIG.LANC", "ESTOQUE", "CLIENTE/FORN", "NOME", "GRP CTB","ARMAZEM", "ESPECIE"}) // 20 Colunas  

U_CRIAMOV(mv_par01, mv_par02)

dbSelectArea("TMP")
TMP->(dbGotop())
ProcREgua( Reccount() )
nCount:= 1
do while TMP->(!eof()) 

incproc('Atualizando temp ...'+TMP->I)
	//Rotina para descartar as NFs que não controla estoque e não pertercen a CTR e CTE
	//Pula as NFs de saida que nao controlam estoque
/*	if Substr(TMP->N,1,3) $ "SD2" .and. !TMP->D $ 'B' 
		if Posicione("SF4",1,xFilial("SF4")+TMP->J, "F4_ESTOQUE") $ 'N'
			TMP->(dbSkip())
			loop
		endif
	endif
	//Pula as NFs de entrada que utilizam cliente e nao controlam estoque, (exceto beneficiamento)
/*	if Substr(TMP->N,1,3) $ "SD1" .and. TMP->D $ 'D' 
		if Posicione("SF4",1,xFilial("SF4")+TMP->J, "F4_ESTOQUE") $ 'N'
			TMP->(dbSkip())
			loop
		endif
	endif
	//Pula as notas de entrada que não é CTR e CTE e nao controla estoque
	/*if Substr(TMP->N,1,3) $ "SD1" .and. !TMP->D $ 'B|D' 
		if Posicione("SF4",1,xFilial("SF4")+TMP->J, "F4_ESTOQUE") $ 'N'
			if !Posicione("SF2",1,xFilial('SF2')+Substr(TMP->E,1,9)+Substr(TMP->E,11,3)+TMP->O+TMP->P, "F2_ESPECIE") $ 'CTR  |CTE  '
				TMP->(dbSkip())
				loop
			endif
		endif
	endif
*/

		// 				 1  2  3  4  5  6  7  8  9  10  11  12  13  14  15    16  17    18   19	  20
		AADD(aConteud, {"","","","","","","","","","  ",0,  0, " ", " "," ", " ", " ", " ", " ", "  " })
		aConteud[len(aConteud),1]  := TMP->A+"'" 
		aConteud[len(aConteud),2]  := TMP->I+"'"
		aConteud[len(aConteud),3]  := TMP->K+"'"
		aConteud[len(aConteud),4]  := TMP->L+"'"
		aConteud[len(aConteud),5]  := TMP->M+"'"
		aConteud[len(aConteud),6]  := dtoC(sTod(TMP->B))
		aConteud[len(aConteud),7]  := TMP->CTA+"'"
		aConteud[len(aConteud),8]  := TMP->J+"'"
		aConteud[len(aConteud),9]  := TMP->D+"'"
		aConteud[len(aConteud),10] := TMP->E+"'"
		aConteud[len(aConteud),11] := TMP->F
		aConteud[len(aConteud),12] := TMP->G
		aConteud[len(aConteud),13] := TMP->H+"'"
		aConteud[len(aConteud),14] := TMP->N

		if Substr(TMP->N,1,3) == "SD3"
			aConteud[len(aConteud),15] := "S"
		else
			aConteud[len(aConteud),15] := Posicione("SF4",1,xFilial("SF4")+TMP->J, "F4_ESTOQUE")
		endif 

		aConteud[len(aConteud),16] := TMP->(O+"-"+P)

		if Substr(TMP->N,1,3) $ "SD1"
			if Substr(TMP->D,1,1) $ 'B|D'	
				aConteud[len(aConteud),17] := Posicione("SA1",1,xFilial("SA1")+ALLTRIM(TMP->O)+ALLTRIM(TMP->P),"A1_NOME")
			else
				aConteud[len(aConteud),17] := Posicione("SA2",1,xFilial("SA2")+ALLTRIM(TMP->O)+ALLTRIM(TMP->P),"A2_NOME")
			endif
		elseif Substr(TMP->N,1,3) $ "SD2"
			if Substr(TMP->D,1,1) $ 'B|D'
				aConteud[len(aConteud),17] := Posicione("SA2",1,xFilial("SA2")+ALLTRIM(TMP->O)+ALLTRIM(TMP->P),"A2_NOME")
			else
				aConteud[len(aConteud),17] := Posicione("SA1",1,xFilial("SA1")+ALLTRIM(TMP->O)+ALLTRIM(TMP->P),"A1_NOME")
			endif
		elseif Substr(TMP->N,1,3) $ "SD3"
			aConteud[len(aConteud),17] := "MOVIMENTOS INTERNOS"
		endif
		aConteud[len(aConteud),18] := TMP->R
		aConteud[len(aConteud),19] := "'"+TMP->S
		if Substr(TMP->N,1,3) == "SD2"
			aConteud[len(aConteud),20] := Posicione("SF2",1,xFilial('SF2')+Substr(TMP->E,1,9)+Substr(TMP->E,11,3)+ALLTRIM(TMP->O)+ALLTRIM(TMP->P), "F2_ESPECIE")
		elseif Substr(TMP->N,1,3) == "SD1"
			aConteud[len(aConteud),20] := Posicione("SF1",1,xFilial('SF1')+Substr(TMP->E,1,9)+Substr(TMP->E,11,3)+ALLTRIM(TMP->O)+ALLTRIM(TMP->P), "F1_ESPECIE")
		endif		
	TMP->(dbSkip())
enddo 

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
AADD(aRegs,{cPerg,"01","Informe o Mes"	,"","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Informe o Ano"	,"","","mv_ch2","C",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
Endif

nTamLin := 2
cLin    := Space(nTamLin)+cEOL

ProcRegua(Len(axVet))

If !Empty(cxCab)
	cLin := Stuff(cLin,01,02,cxCab)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no Cabeçalho. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		Endif
	Endif
EndIf

For jk := 1 to Len(axVet)
	nTamLin   := 2
	cLin      := Space(nTamLin)+cEOL
	cDadosCSV := ""
	IncProc("Gerando arquivo CSV")
	For nt := 1 to Len(axVet[jk])
		If ValType(axVet[jk,nt]) == "C"
			cDadosCSV += axVet[jk,nt]+Iif(nt = Len(axVet[jk]),"",";")
		ElseIf ValType(axVet[jk,nt]) == "N"
			cDadosCSV += Transform(axVet[jk,nt],PICTUSE)+Iif(nt = Len(axVet[jk]),"",";")
		ElseIf ValType(axVet[jk,nt]) == "U"
			cDadosCSV += +Iif(nt = Len(axVet[jk]),"",";")
		Else
			cDadosCSV += axVet[jk,nt]+Iif(nt = Len(axVet[jk]),"",";")
		EndIf
	Next
	cLin := Stuff(cLin,01,02,cDadosCSV)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo nos Itens. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		Endif
	Endif
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


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Monta a consulta com os movimentos do periodo selecionado
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function CRIAMOV(mv_par01, mv_par02)

	if Select("TMP") > 0
		dbSelectArea("TMP")
		TMP->(dbCloseArea())
	endif
//ProcRegua()

//incProc('Gerando query ')
	
	//FAZ A CONTAGEM DOS REGISTROS DE SD1
/*	cQcount := " SELECT COUNT(*) NREG FROM SD1010 WHERE D_E_L_E_T_ = ' ' and Substring(D1_DTDIGIT,1,6)='"+mv_par02+mv_par01+"' "
	if Select("TMCNT") > 0 
		dbSelectArea("TMCNT")
		TMCNT->(dbCloseArea())
	endif 
	
	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQCount), 'TMCNT', .T.,.T.)
	
	dbSelectArea('TMCNT')
	nCntReg := TMCNT->NREG
	
*	//FAZ A CONTAGEM DOS REGISTROS DE SD2
	cQcount := " SELECT COUNT(*) NREG FROM SD2010 WHERE D_E_L_E_T_ = ' ' and Substring(D2_EMISSAO,1,6)='"+mv_par02+mv_par01+"' "
	if Select("TMCNT") > 0 
		dbSelectArea("TMCNT")
		TMCNT->(dbCloseArea())
	endif 
	
	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQCount), 'TMCNT', .T.,.T.)
	
	dbSelectArea('TMCNT')
	nCntReg += TMCNT->NREG
	
	
	//FAZ A CONTAGEM DOS REGISTROS DE SD3
	cQcount := " SELECT COUNT(*) NREG FROM SD3010 WHERE D_E_L_E_T_ = ' ' and Substring(D3_EMISSAO,1,6)='"+mv_par02+mv_par01+"' "
	if Select("TMCNT") > 0 
		dbSelectArea("TMCNT")
		TMCNT->(dbCloseArea())
	endif 
	
	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQCount), 'TMCNT', .T.,.T.)
	
	dbSelectArea('TMCNT')
	nCntReg += TMCNT->NREG
*/	
	cQuery := ""
	          
	cQuery := " Select A, I, K, L, M, B, CTA, J, D, E, F, G, H, N, O, P, Q, R, S from 	"
	cQuery += " (Select D1_FILIAL A, D1_COD I, 	D1_GRUPO K, B1_CONTA L, D1_ITEMCTA M, "
	cQuery += " D1_DTDIGIT B, "
	cQuery += " D1_CONTA CTA, D1_TES J, D1_TIPO D, D1_DOC+'-'+D1_SERIE E, "
	cQuery += " Case Substring(D1_TIPO,1,1)	"
	cQuery += " when 'D' then Round(D1_CUSTO,2) "
	cQuery += " else 0 "
	cQuery += " end F, "
	cQuery += " Case Substring(D1_TIPO,1,1)	"
	cQuery += " when 'B' then Round(D1_CUSTO,2) "
	cQuery += " when 'N' then Round(D1_CUSTO,2) "
	cQuery += " when 'C' then Round(D1_CUSTO,2) "
	cQuery += " when 'I' then Round(D1_CUSTO,2) "
	cQuery += " else 0 "
	cQuery += " end G, D1_NUMSEQ H, 'SD1' N, D1_FORNECE O, D1_LOJA P, F4_ESTOQUE Q, F4_GRPCTB R, D1_LOCAL S "
	cQuery += " from SD1010 SD1, SF4010 SF4, SB1010 SB1 "
	cQuery += " where SD1.D_E_L_E_T_= ' ' AND SF4.D_E_L_E_T_ = ' ' and SB1.D_E_L_E_T_ =' ' "
//	cQuery += " AND D1_FILIAL = F4_FILIAL  "  - Comentado por ter unificado as TES
	cQuery += " and F4_CODIGO = D1_TES "
	cQuery += " AND D1_COD = B1_COD " 
	cQuery += " AND (Substring(D1_CONTA,1,3) ='113' or Substring(D1_CONTA,1,3) ='   ') "  //Incluido a opcao de gerar produtos sem contas...
	cQuery += " and Substring(D1_DTDIGIT,1,6)='"+mv_par02+mv_par01+"') NFE "
	cQuery += " union all "
	cQuery += " (Select D2_FILIAL A, D2_COD I,	D2_GRUPO K, B1_CONTA L, D2_FILIAL M,  "
	//cQuery += " Substring(D2_EMISSAO,7,2)+'/'+Substring(D2_EMISSAO,5,2)+'/'+Substring(D2_EMISSAO,1,4) B, "
	cQuery += " D2_EMISSAO B, "
	cQuery += " D2_CONTA CTA, D2_TES J, D2_TIPO D , D2_DOC+'-'+D2_SERIE E, "
	cQuery += " Case Substring(D2_TIPO,1,1)	"
	cQuery += " when 'B' then Round(D2_CUSTO1,2) "
	cQuery += " when 'N' then Round(D2_CUSTO1,2) "
	cQuery += " when 'D' then Round(D2_CUSTO1,2) "
	cQuery += " else 0 "
	cQuery += " end F, "
	cQuery += " Case Substring(D2_TIPO,1,1)	"
	cQuery += " when ' ' then Round(D2_CUSTO1,2) "
	cQuery += " else 0 "
	cQuery += " end G, D2_NUMSEQ H, 'SD2' N, D2_CLIENTE O, D2_LOJA P, F4_ESTOQUE Q, F4_GRPCTB R, D2_LOCAL S	"
	cQuery += " from SD2010 SD2, SF4010 SF4, SB1010 SB1 "
	cQuery += " where SD2.D_E_L_E_T_= ' ' AND SF4.D_E_L_E_T_ = ' ' and SB1.D_E_L_E_T_ =' ' "
//	cQuery += " and F4_FILIAL = D2_FILIAL "  - Comentado por ter unificado as TES
	cQuery += " and F4_CODIGO = D2_TES " 
	cQuery += " and D2_COD = B1_COD " 
	cQuery += " AND (Substring(D2_CONTA,1,3) ='113' or Substring(D2_CONTA,1,3) ='   ') " 
	cQuery += " AND F4_ESTOQUE = 'S' " 
	cQuery += " and Substring(D2_EMISSAO,1,6)='"+mv_par02+mv_par01+"') "
	cQuery += " union all "
	cQuery += " (Select D3_FILIAL A, D3_COD I,	D3_GRUPO K, B1_CONTA L, D3_ITEMCTA M, "
	//cQuery += " Substring(D3_EMISSAO,7,2)+'/'+Substring(D3_EMISSAO,5,2)+'/'+Substring(D3_EMISSAO,1,4) B, "
	cQuery += " D3_EMISSAO B, "
	cQuery += " D3_CONTA CTA, D3_TM J, D3_CF D, D3_DOC E, "
	cQuery += " Case Substring(D3_CF,1,1) "
	cQuery += " when 'R' then Round(D3_CUSTO1,2) "
	cQuery += " else 0 "
	cQuery += " end F, "
	cQuery += " Case Substring(D3_CF,1,1) "
	cQuery += " when 'D' then Round(D3_CUSTO1,2) "
	cQuery += " when 'P' then Round(D3_CUSTO1,2) "
	cQuery += " else 0 "
	cQuery += " end G, D3_NUMSEQ H, 'SD3' N, 'MOV_INT' O, 'MOV_INT' P, 'MOV_INT' Q, D3_TM R, D3_LOCAL S "
	cQuery += " from SD3010 SD3, SB1010 SB1	"
	cQuery += " where SD3.D_E_L_E_T_ = ' ' and SB1.D_E_L_E_T_ =' '	"
	cQuery += " AND D3_COD = B1_COD " 
	cQuery += " and Substring(D3_EMISSAO,1,6)='"+mv_par02+mv_par01+"'	"
	cQuery += " AND (Substring(D3_CONTA,1,3) ='113' or Substring(D3_CONTA,1,3) ='   ') AND SUBSTRING(D3_COD,1,3) <> 'MOD' " 
	cQuery += " and D3_ESTORNO <> 'S')	"
	cQuery += " order by A, H	"
		
	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), 'TMP', .T., .T. )

return