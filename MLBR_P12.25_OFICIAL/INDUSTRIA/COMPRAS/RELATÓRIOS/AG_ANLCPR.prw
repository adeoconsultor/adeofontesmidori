#INCLUDE "Protheus.ch"  
#DEFINE PICVAL  "@E 999,999,999.99"
///////////////////////////////////////////////////////////////////////////////
//Relatorio de Analise de produtos comprados.
//Gera em planilha toda a movimentação de entrada de produtos no estoque
//Analisando o consumo do mesmo no ambiente produtivo baseado no real cadastrado na estrutura 
//Relatório solicitado pelo Sr.Hissashi (Dpto Compras)
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br - 25-09-2013
///////////////////////////////////////////////////////////////////////////////

User Function AG_ANLCPR() //Analisa compras

	Processa({|lEnd| U_AG_GANLCPR()},"Aguarde", "Analisando Filtros.......", .T.) // Gera o relatório de analise

return 

user function AG_GANLCPR()
Local cQuery := ""
Local i
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab        := "" 


Private cPerg := PADR("AGANLCPR",10)
if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
endif
Pergunte(cPerg,.T.)      


if Select("KDX") > 0 
	dbSelectArea("KDX")
	KDX->(dbCloseArea())
endif
//Arquivo temporario da funcao para geracao do relatorio
aKDX	:= {}
AADD(aKDX,{"FILIAL"		    , "C", 02, 0 } ) //Filial do Lancamento
AADD(aKDX,{"PRODUTO" 	    , "C", 15, 0 } ) //Codigo do Produto
AADD(aKDX,{"GRUPO" 	        , "C", 04, 0 } ) //Grupo do produto
AADD(aKDX,{"DESCR"  	    , "C", 50, 0 } ) //Descricao do produto
AADD(aKDX,{"QTDENT"     	, "N", 12, 2 } ) //Quantidade Entrada no periodo

ctrKDX := CriaTrab(aKDX, .T.)
dbUseArea(.T.,,ctrKDX,"KDX",.F.,.F.)
INDEX ON PRODUTO + FILIAL + GRUPO TO &ctrKDX

if Select("TMPENT") > 0    // Arquivo temporário das entradas
	dbSelectArea("TMPENT")
	TMPENT->(dbCloseArea())
endif

//FAZ O FILTRO DE TODOS OS ITENS QUE DERAM ENTRADA DENTRO DO PERIODO
//COM NOTA FISCAL E QUE GERA FINANCEIRO E CONTROLA ESTOQUE
cQEntr := " Select D1_COD, D1_GRUPO, D1_UM, Sum(D1_QUANT) QTDEENT "
cQEntr += " from SD1010 SD1, SF4010 SF4 "
cQEntr += " where SD1.D_E_L_E_T_ =' ' and SF4.D_E_L_E_T_  = ' ' "
//cQEntr += " and D1_FILIAL = F4_FILIAL " - Comentado por ter unificado as TES
cQEntr += " and D1_TES = F4_CODIGO "
cQEntr += " and F4_ESTOQUE = 'S' "
cQEntr += " and F4_DUPLIC = 'S' "
cQEntr += " AND D1_FILIAL = '" +xFilial("SD1")+"' "
cQEntr += " AND F4_FILIAL = '" +xFilial("SF4")+"' " 
cQEntr += " AND D1_DTDIGIT between '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "
cQEntr += " and D1_GRUPO between '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQEntr += " AND D1_COD between '"+MV_PAR05+"' AND '"+MV_PAR06+"' " 
cQEntr += " group by D1_COD, D1_GRUPO, D1_UM "

dbUseArea(.T., "TOPCONN", tcGenQry(, , cQEntr), 'TMPENT', .T.,.T.)

//FAZ A CONTAGEM DOS REGISTROS DE SD1 PARA ANALISE DAS QUANTIDADES DE ITENS QUE ENTRARAM NO PERIODO
nContPrd := 0
dbSelectArea('TMPENT')
TMPENT->(dbGotop())
while !TMPENT->(eof())
	nContPrd ++
	TMPENT->(dbSKip())
enddo
                 
// Se nao tiver informações encerra o relatorio
if nContPrd == 0 
	Alert('Nao há registros para o filtro informado'+chr(13)+'Por favor conferir!')
	Return
endif

//VERIFICA A EXISTENCIA DA TABELA TEMPORARIA SD3
if Select("TMPSD3") > 0 
	dbSelectArea("TMPSD3")
	TMPSD3->(dbCloseArea())
endif
//FILTRA AS MOVIMENTACOES OCORRIDAS NO SD3           

cQSD3 := " SELECT D3_COD, D3_TM, D3_CF, D3_UM, PRODUCAO, Sum(D3_QUANT) QTDTOT from "
cQSD3 += " (Select D3_COD, D3_TM, D3_CF, D3_UM, "
cQSD3 += " Case D3_OP " 
cQSD3 += " 	when '' then '' "
cQSD3 += " 	else 'PRODUCAO' "
cQSD3 += " end PRODUCAO, "
cQSD3 += " D3_QUANT from SD3010 "
cQSD3 += " where D_E_L_E_T_ =' '  "
cQSD3 += " and D3_FILIAL = '"+xFilial("SD3")+"' "
cQSD3 += " and D3_EMISSAO between '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "
cQSD3 += " and D3_GRUPO between '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQSD3 += " and D3_COD between '"+MV_PAR05+"' AND '"+MV_PAR06+"' ) CONSUMO " 
cQSD3 += " group by D3_COD, D3_TM, D3_CF, D3_UM, PRODUCAO "
cQSD3 += " order by 1,2 "
	
	dbUseArea(.T., "TOPCONN", tcGenQry( , , cQSD3), 'TMPSD3', .T., .T.) 

//ADICIONA O ARQUIVO GERADO EM UM ARRAY
aSD3 := {}
dbSelectArea("TMPSD3")
TMPSD3->(dbGotop())
while !TMPSD3->(eof())
	AADD( aSD3, {TMPSD3->D3_COD, TMPSD3->D3_TM, TMPSD3->D3_CF, iif(TMPSD3->D3_TM < '500', TMPSD3->QTDTOT, TMPSD3->QTDTOT * -1), TMPSD3->PRODUCAO})
	TMPSD3->(dbSkip())
enddo


//FAZ ANALISE ITEM A ITEM DO CONSUMO DO MATERIAL NO DECORRER DO MES
nCount:= 0
aConteud := {}
AADD(aConteud, {"PLANILHA DE ANALISE DE CONSUMO MENSAL", "", "", "", ""})
AADD(aConteud, {"PERIODO DE "+dToc(mv_par01)+" ATE "+dtoc(mv_par02)+" GRUPO DE "+mv_par03+" ATE "+mv_par04+" PRODUTO DE "+mv_par05+" ATE "+mv_par06}, " " , " " , " " )
AADD(aConteud, {"OS ITENS ANALISADOS SAO PRODUTOS QUE ENTRARAM VIA NOTA FISCAL, CONTROLANTO ESTOQUE E GERANDO FINANCEIRO", " ", " ", " "})
AADD(aConteud, {"GRUPO", "CODIGO", "DESCRICAO", "UM", "QUANTIDADE"})
ProcREgua( Reccount() )
dbSelectArea('TMPENT')
TMPENT->(dbGotop())
while !TMPENT->(eof())
	nCount++
	incProc('Analisando Produto '+Alltrim(TMPENT->D1_COD)+" Sequencia "+cValToChar(nCount) +' de '+cValToChar(nContPrd))
	AADD(aConteud, {"'"+TMPENT->D1_GRUPO, "'"+TMPENT->D1_COD, Posicione("SB1", 1, xFilial("SB1")+TMPENT->D1_COD,"B1_DESC"), TMPENT->D1_UM, TMPENT->QTDEENT })
		nAchou:=ASCAN(aSD3,{|x| x[1] == TMPENT->D1_COD })
		if nAchou > 0 
			for i:= nAchou to len(aSD3)
				if aSD3[i][1] == TMPENT->D1_COD
					AADD(aConteud, {"", "'"+aSD3[i][1], "TM-> "+aSD3[i][2]+"-"+aSD3[i][5], "COD.FISCAL-> "+aSD3[i][3], aSD3[i][4]})
				else
					i:= len(aSD3)
				endif
			next i 
		endif
	TMPENT->(dbSKip())
enddo
     
//GERAR O ARQUIVO EM FORMATO DE EXCEL
if ApmsgNoYes('Deseja gerar os registros atualizados para excel ? ', 'Atenção')
	aDir := MDirArq()
	If Empty(aDir[1]) .OR. Empty(aDir[2])
		Return
	Else                      
		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif
else
	return
endif




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
AADD(aRegs,{cPerg,"01","Data Inicial"	,"","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data Final"	    ,"","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Grupo Inicial"	,"","","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""})
AADD(aRegs,{cPerg,"04","Grupo Final"	,"","","mv_ch4","C",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""})
AADD(aRegs,{cPerg,"05","Produto Inicial","","","mv_ch4","C",15,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
AADD(aRegs,{cPerg,"06","Produto Final"	,"","","mv_ch4","C",15,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})

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
