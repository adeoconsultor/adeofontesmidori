#include 'protheus.ch'
#include 'rwmake.ch'

#DEFINE PICVAL  "@E 999,999,999.99"
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Função com o objetivo de gerar um comparativo dos produtos produzidos, fazendo um comparativo entre o
//consumo devido e o consumo real de material
//O objetivo é identificar ajustes de empenhos realizados na producao

//Desenvolvido por Anesio G.Faria - 17/04/2014
     
//Rotina principal que vai chamar as demais...
user function AG_COMPCONS() // 

if ApMsgNoYes("Deseja gerar o arquivo em Excel ? ", "Atenção")
	Processa({|| CalcPR0(), "Iniciando Calculo"})
else
	ApMsgInfo('Rotina abortada')
	
endif

return 

//Rotina de calculo
static function CalcPR0()
local cQuery := "" 
local aItens := {}
Local i
Private cPerg   := "AG_CPCONS"

Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab        := "" 



if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
endif
Pergunte(cPerg,.T.)
Aadd(aItens, {"PLANILHA DE PRODUCAO DA FILIAL "+cFilant+" PLANILHA GERADA EM "+dtoc(dDataBase)})
Aadd(aItens, {"COMPARATIVO DE CONSUMO DEVIDO x CONSUMO REAL" })
Aadd(aItens, {"COMP/KIT", "DESCRICAO DO COMPONENT", "MAT.PRIMA", "DESCRICAO DO MATERIAL", "QTDE ESTRUTURA", "QTDE DEVIDA", "CUSTO DEVIDO", "QTDE CONSUMIDO","CUSTO CONSUMIDO","DIFERENCA"})


cQuery := " Select D3_NUMSEQ, D3_COD, B1_DESC, QTDE, round(CUSTO,2) CUSTO, round(CUSTO / QTDE,2) CUST_UN from "
cQuery += " (Select D3_NUMSEQ, D3_COD, B1_DESC, Sum(D3_QUANT) QTDE, Sum(D3_CUSTO1) CUSTO "
cQuery += " from SD3010 SD3, SB1010 SB1 "
cQuery += " where SD3.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' "
cQuery += " and D3_COD = B1_COD "
cQuery += " and D3_FILIAL = '"+xFilial("SD3")+"' "
cQuery += " and Substring(D3_EMISSAO,1,6)='"+mv_par01+mv_par02+"' "
cQuery += " and D3_CF ='PR0' "
//cQuery += " AND D3_COD in ('040023','040037') "
cQuery += " group by D3_NUMSEQ, D3_COD, B1_DESC ) PRD_AA "
//cQuery += " where B1_DESC like '%369%'
cQuery += " order by 2,3 "

if Select('TMPCM') > 0
	dbSelectArea('TMPCM')
	TMPCM->(dbCloseArea())
endif

dbUseArea(.T., 'TOPCONN', tcGenQry( , , cQuery), 'TMPCM', .T., .T.)


dbSelectArea('TMPCM')
dbGotop()
cCodOld  := TMPCM->D3_COD
cCod	 := "'"
nQtde    := 0  
nCusto   := 0 
while !TMPCM->(eof())
	incproc('Atualizando registros... '+TMPCM->D3_NUMSEQ)
	//Quando mudar de código faz um filtro do consumo do anterior...
	if cCodOld <> TMPCM->D3_COD
		aPRD := {}
		aadd(aPrd,{cCodOld, Posicione("SB1",1,xFilial("SB1")+cCodOld,"B1_DESC"), "------", "------------------------------", nQtde, nCusto, 0,0, 0})
		cQG1 := " Select G1_COD, G1_COMP, G1_QUANT from SG1010 where D_E_L_E_T_ =' '  and G1_FILIAL ='"+xFilial("SG1")+"' AND G1_COD = '"+cCodOld+"' " 
		if mv_par01+mv_par02 <= '201403'
			cQG1 += " AND len(G1_COMP) < 9 "
		else
			cQG1 += " and Substring(G1_FIM,1,6) > '201403' "
		endif
			
		if Select("TMPG1")>0
			dbSelectArea("TMPG1")
			TMPG1->(dbCloseArea())
		endif
		dbUseArea(.T., "TOPCONN", tcGenQry(, , cQG1), "TMPG1", .T., .T.)
		
		dbSelectArea("TMPG1")
		TMPG1->(dbGotop())
		while !TMPG1->(eof())
			AADD(aPRD, {TMPG1->G1_COD, Posicione("SB1",1,xFilial("SB1")+TMPG1->G1_COD,"B1_DESC"), TMPG1->G1_COMP, Posicione("SB1",1,xFilial("SB1")+TMPG1->G1_COMP,"B1_DESC"), TMPG1->G1_QUANT, TMPG1->G1_QUANT*nQtde ,0, 0, 0 }) //Ultimos zeros = Qtde/Vlr Prod
			TMPG1->(dbSkip())                                                         				//Qtde/Vlr Consumido
		enddo
		cCod := Substr(cCod,1,Len(cCod)-2)
		cCodOld  := TMPCM->D3_COD
		cQD3 := " Select D3_COD, B1_DESC, QTDE, round(CUSTO,2) CUSTO, round(CUSTO / QTDE,2) CUST_UN from "
		cQD3 += " (Select D3_COD, B1_DESC, Sum(D3_QUANT) QTDE, Sum(D3_CUSTO1) CUSTO "
		cQD3 += " from SD3010 SD3, SB1010 SB1 "
		cQD3 += " where SD3.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' "
		cQD3 += " and D3_COD = B1_COD "
		cQD3 += " and D3_FILIAL = '"+xFilial("SD3")+"' "
		cQD3 += " and Substring(D3_EMISSAO,1,6)='"+mv_par01+mv_par02+"' "
		cQD3 += " and D3_CF <> 'PR0' " 
		cQD3 += " and D3_NUMSEQ in ("+cCod+") " 
		cQD3 += " group by D3_COD, B1_DESC ) PRD_AA "
		cQD3 += " order by 2,3 "
    
		if Select("TMPD3")>0
			dbSelectArea("TMPD3")
			TMPD3->(dbCloseArea())
		endif
		dbUseArea(.T., "TOPCONN", TcGenQry(, , cQD3), "TMPD3", .T., .T.)
		
		dbSelectArea("TMPD3")
		TMPD3->(dbGotop())
		while !TMPD3->(eof())
			nPos := aScan(aPrd, {|x| x[3] == TMPD3->D3_COD})
			if nPos > 0
				aPrd[nPos][8] := TMPD3->QTDE
				aPrd[nPos][9] := TMPD3->CUSTO
//				alert('Produto encontrado1 -> '+aPrd[nPos][3])
			else
				AADD(aPRD, {"", "", TMPD3->D3_COD,Posicione("SB1",1,xFilial("SB1")+TMPD3->D3_COD,"B1_DESC"), 0, 0, 0, TMPD3->QTDE, TMPD3->CUSTO })
			endif
			TMPD3->(dbSkip())
		enddo 

		cCod := "'"
		for i:= 1 to len(aPrd)
	      AADD(aItens, {aPrd[i][1], aPrd[i][2], aPrd[i][3], aPrd[i][4], aPrd[i][5], aPrd[i][6], aPrd[i][7],aPrd[i][8],aPrd[i][9], 0 })
		next i
		nQtde := 0
		nCusto:= 0
	endif
	nQtde += TMPCM->QTDE
	nCusto+= TMPCM->CUSTO
	cCod := cCod+Alltrim(TMPCM->D3_NUMSEQ)+"','"
TMPCM->(dbSkip())
enddo


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para gravar o ultimo calculo...
		aPRD := {}
		aadd(aPrd,{cCodOld, Posicione("SB1",1,xFilial("SB1")+cCodOld,"B1_DESC"), "------", "------------------------------", nQtde, nCusto, 0,0, 0})
		cQG1 := " Select G1_COD, G1_COMP, G1_QUANT from SG1010 where D_E_L_E_T_ =' '  and G1_FILIAL ='"+xFilial("SG1")+"' AND G1_COD = '"+cCodOld+"' " 
		if mv_par01+mv_par02 <= '201403'
			cQG1 += " AND len(G1_COMP) < 9 "
		else
			cQG1 += " AND Substring(G1_FIM,1,6) > '201403' "
		endif

		if Select("TMPG1")>0
			dbSelectArea("TMPG1")
			TMPG1->(dbCloseArea())
		endif
		dbUseArea(.T., "TOPCONN", tcGenQry(, , cQG1), "TMPG1", .T., .T.)
		
		dbSelectArea("TMPG1")
		TMPG1->(dbGotop())
		while !TMPG1->(eof())
			AADD(aPRD, {TMPG1->G1_COD, Posicione("SB1",1,xFilial("SB1")+TMPG1->G1_COD,"B1_DESC"), TMPG1->G1_COMP, Posicione("SB1",1,xFilial("SB1")+TMPG1->G1_COMP,"B1_DESC"), TMPG1->G1_QUANT, TMPG1->G1_QUANT*nQtde ,0, 0, 0 }) //Ultimos zeros = Qtde/Vlr Prod
			TMPG1->(dbSkip())                                                         				//Qtde/Vlr Consumido
		enddo
		cCod := Substr(cCod,1,Len(cCod)-2)

		cQD3 := " Select D3_COD, B1_DESC, QTDE, round(CUSTO,2) CUSTO, round(CUSTO / QTDE,2) CUST_UN from "
		cQD3 += " (Select D3_COD, B1_DESC, Sum(D3_QUANT) QTDE, Sum(D3_CUSTO1) CUSTO "
		cQD3 += " from SD3010 SD3, SB1010 SB1 "
		cQD3 += " where SD3.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' "
		cQD3 += " and D3_COD = B1_COD "
		cQD3 += " and D3_FILIAL = '"+xFilial("SD3")+"' "
		cQD3 += " and Substring(D3_EMISSAO,1,6)='"+mv_par01+mv_par02+"' "
		cQD3 += " and D3_CF <> 'PR0' " 
		cQD3 += " and D3_NUMSEQ in ("+cCod+") " 
		cQD3 += " group by D3_COD, B1_DESC ) PRD_AA "
		cQD3 += " order by 2,3 "
    
		if Select("TMPD3")>0
			dbSelectArea("TMPD3")
			TMPD3->(dbCloseArea())
		endif
		dbUseArea(.T., "TOPCONN", TcGenQry(, , cQD3), "TMPD3", .T., .T.)
		
		dbSelectArea("TMPD3")
		TMPD3->(dbGotop())
		while !TMPD3->(eof())
			nPos := aScan(aPrd, {|x| x[3] == TMPD3->D3_COD})
			if nPos > 0
				aPrd[nPos][8] := TMPD3->QTDE
				aPrd[nPos][9] := TMPD3->CUSTO
//				alert('Produto encontrado2 -> '+aPrd[nPos][3])
			else
				AADD(aPRD, {"", "", TMPD3->D3_COD,Posicione("SB1",1,xFilial("SB1")+TMPD3->D3_COD,"B1_DESC"), 0, 0, 0, TMPD3->QTDE, TMPD3->CUSTO })
			endif
			TMPD3->(dbSkip())
		enddo 

		cCod := "'"

//Fim rotina para gravar o ultimo calculo...
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
for i:= 1 to len(aPrd)
      AADD(aItens, {aPrd[i][1], aPrd[i][2], aPrd[i][3], aPrd[i][4], aPrd[i][5], aPrd[i][6], aPrd[i][7],aPrd[i][8],aPrd[i][9],0 })
next i


for i:= 4 to len(aItens)
	if aItens[i][3] <> "------"
		aItens[i][7] := iif(aItens[i][8]<aItens[i][6],aItens[i][9], iif(aItens[i][8] > 0, aItens[i][9] / aItens[i][8] * aItens[i][6],0) )
		aItens[i][10] := aItens[i][9] - aItens[i][7]
	endif
next i 

if ApmsgNoYes('Deseja gerar os registros atualizados para excel ? ', 'Atenção')

	aDir := MDirArq()
	If Empty(aDir[1]) .OR. Empty(aDir[2])
		Return
	Else                      

		Processa({ || lOk := MCVS(aItens,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif
else
	return
endif



//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Funçao para criar as perguntas iniciais
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
PutSx1(cPerg,"01","Informe o Ano                 ?"," "," ","mv_ch1","C",4,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Ano para calcular"},{"Informe o Ano para calcular"},{"Informe o Ano para calcular"})
PutSx1(cPerg,"02","Informe o mês                 ?"," "," ","mv_ch2","C",2,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Mês para calcular"},{"Informe o Mês para calcular"},{"Informe o Mês para calcular"})

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

return

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