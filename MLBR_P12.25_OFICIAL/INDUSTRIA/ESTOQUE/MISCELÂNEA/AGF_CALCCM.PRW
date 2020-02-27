#include 'protheus.ch'
#include 'rwmake.ch'

#DEFINE PICVAL  "@E 999,999,999.99"
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Funçao com o objetivo de fazer os calculos dentro de um determinado mes referente a todas as entradas
//de mercadorias via SD1 (que movimentaram estoque) e todas as entradas via SD3
//Faz a composicao do custo total e quantidade total no mes e encontra o custo médio praticado.
//Grava essa informação no arquivo SB9 referente ao ultimo fechamento.
//O objetivo é utilizar essa informacão para o calculo das transferencias entre as unidades no decorrer do mes.

//Desenvolvido por Anesio G.Faria - 28/03/2013 - anesio@outlook.com
     
//Rotina principal que vai chamar as demais...
user function AG_CALCCM() // Calcula Custo Médio

if ApMsgNoYes("Deseja atualizar o custo médio no arquivo SB9 para o ultimo mês fechado ? ","Atenção atualização ocorrera apenas em campo customizado")
	Processa({|| CalcCM(), "Iniciando Calculo"})
else
	ApMsgInfo('Rotina abortada')
	
endif

return 

//Rotina de calculo
static function CalcCM()
local cQuery := "" 
local aItens := {}
local dtUlmes := getmv('MV_ULMES')
Private cPerg   := "AGF_CALCCM"

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
Aadd(aItens, {"PLANILHA DE CALCULO REALIZADO PARA A FILIAL "+cFilant+" DATA DO CALCULO "+dtoc(dDataBase)})
Aadd(aItens, {"REGISTROS GRAVADOS NO ARQUIVO SB9 REFERENTE AO FECHAMENTO DE "+dToc(dtUlmes)})
Aadd(aItens, {"MES/ANO", "ARM", "PRODUTO", "DESCRICAO DO PRODUTO", "QTDE", "CUSTO UNIT CALCULADO", "CUSTO TOTAL MES","CUSTO MEDIO B9_CM1"})

cQuery := " Select EMISSAO, ARMAZEM, CODIGO, QTDE, CUSTO, CUSTO / QTDE CUSTOMED from "
cQuery += " (Select EMISSAO, ARMAZEM, CODIGO, Sum(QTDE) QTDE, SUM(CUSTO) CUSTO FROM "
cQuery += " (Select Substring(D1_DTDIGIT,1,6) EMISSAO, D1_LOCAL ARMAZEM, D1_COD CODIGO, SUM(D1_QUANT) QTDE, SUM(D1_CUSTO) CUSTO  "
cQuery += " from SD1010 SD1, SF4010 SF4 "
cQuery += " where SD1.D_E_L_E_T_ = ' ' and SF4.D_E_L_E_T_ = ' ' "
cQuery += " and D1_TES = F4_CODIGO "
//cQuery += " and D1_FILIAL = F4_FILIAL "  - Comentado por ter unificado as TES
cQuery += " and D1_FILIAL = '"+xFilial("SD1")+"' and F4_FILIAL = '"+xFilial("SF4")+"' "
cQuery += " and Substring(D1_DTDIGIT,1,6)='"+mv_par01+mv_par02+"' "
cQuery += " and F4_ESTOQUE = 'S' "
cQuery += " group by Substring(D1_DTDIGIT,1,6), D1_LOCAL, D1_COD "
cQuery += " union all "
cQuery += " SELECT Substring(D3_EMISSAO,1,6) EMISSAO, D3_LOCAL ARMAZEM, D3_COD CODIGO, SUM(D3_QUANT) QTDE, SUM(D3_CUSTO1) CUSTO from SD3010 "
cQuery += " where D_E_L_E_T_ = ' ' "
cQuery += " and SUBSTRING(D3_CF,1,1) in ('D','P') "
cQuery += " and D3_FILIAL ='"+xFilial("SD3")+"' "
cQuery += " and Substring(D3_EMISSAO,1,6)='"+mv_par01+mv_par02+"' "
cQuery += " group by Substring(D3_EMISSAO,1,6), D3_LOCAL, D3_COD) TRB001 "
cQuery += " where QTDE > 0 "
cQuery += " group by EMISSAO, ARMAZEM, CODIGO) TRB002 "
cQuery += " order by CODIGO "

if Select('TMPCM') > 0
	dbSelectArea('TMPCM')
	TMPCM->(dbCloseArea())
endif

dbUseArea(.T., 'TOPCONN', tcGenQry( , , cQuery), 'TMPCM', .T., .T.)

nData := Val(dtos(dtUlmes))-40
cDtAnt := Substr(cValToChar(nData),1,6)

cDtAnt := Substr(cValToChar(nData),1,6)

dbSelectArea('TMPCM')
dbGotop()
while !TMPCM->(eof())
	incproc('Atualizando registros... '+TMPCM->CODIGO)
		nCusAnt := 0
        nQtd := TMPCM->QTDE
        nCus := TMPCM->CUSTO
		cQB9ANT := " Select B9_DATA, B9_COD, B9_QINI, B9_VINI1, B9_X_CMTRF from SB9010  where D_E_L_E_T_ = ' ' " 
		cQB9ANT += " and B9_COD = '"+TMPCM->CODIGO+"' and Substring(B9_DATA,1,6) = '"+cDtAnt+"' and B9_LOCAL = '"+TMPCM->ARMAZEM+"' AND B9_FILIAL = '"+xFilial("SB9")+"' " 
 		if Select("B9ANT") > 0
 			dbSelectArea('B9ANT')
 			B9ANT->(dbCloseArea())
 		endif
 		dbUseArea(.T., 'TOPCONN', TcGenQry(, , cQB9ANT), 'B9ANT' , .T.,.T.)
 		dbSelectArea('B9ANT')
 		B9ANT->(dbGotop())
 		nQtd += B9ANT->B9_QINI
 		nCus += B9ANT->B9_VINI1
 		nCusAnt := B9ANT->B9_X_CMTRF  //Grava o custo do mes anterior para o caso de nao haver custo no mes corrente
	    nCusMed := iif(nQtd > 0, nCus / nQtd, 0)
	
	dbSelectArea('SB9')
	dbSetOrder(1)
	if dbSeek(xFilial('SB9')+TMPCM->CODIGO+TMPCM->ARMAZEM+dTos(dtUlMes))
		RecLock('SB9',.F.)
		replace B9_X_CMTRF with iif(nCusMed > 0, nCusMed, nCusAnt) //testa se existe Custo médio no mes corrente, caso negativo utiliza o Custo do mes anterior
			//Se não houver custo no mes corrente e nem no mes anterior, faz a atualizacao com custo médio padrao do sistema
			if (nCusMed + nCusAnt) == 0 
				replace B9_X_CMTRF with B9_CM1 
			endif
			//
		MsUnLock('SB9')
		//	Aadd(aItens, { TMPCM->EMISSAO, +"'"+TMPCM->ARMAZEM, "'"+TMPCM->CODIGO, Posicione('SB1',1, xFilial('SB1')+TMPCM->CODIGO, "B1_DESC"), TMPCM->QTDE, TMPCM->CUSTOMED, TMPCM->CUSTO, SB9->B9_CM1 })
		Aadd(aItens, { TMPCM->EMISSAO, +"'"+TMPCM->ARMAZEM, "'"+TMPCM->CODIGO, Posicione('SB1',1, xFilial('SB1')+TMPCM->CODIGO, "B1_DESC"), nQtd, nCusMed, nCus, SB9->B9_CM1 })	
	endif
TMPCM->(dbSkip())
enddo

//Incluir valor para os Itens do SB9 que não tiverão seus custos atualizados...
cQB9ATU := " Select B9_DATA, B9_LOCAL, B9_COD, B9_QINI, B9_VINI1, B9_X_CMTRF from SB9010  where D_E_L_E_T_ = ' ' " 
cQB9ATU += " and Substring(B9_DATA,1,6) = '"+Substr(dtos(dtUlmes),1,6)+"' AND B9_FILIAL = '"+xFilial("SB9")+"' AND B9_X_CMTRF = 0 " 
if Select("B9ATU") > 0
	dbSelectArea('B9ATU')
	B9ATU->(dbCloseArea())
endif

dbUseArea(.T., 'TOPCONN', TcGenQry(, , cQB9ATU), 'B9ATU' , .T.,.T.)
dbSelectArea('B9ATU')
B9ATU->(dbGotop())
while !B9ATU->(eof())
	incProc('Atualizando Itens sem movimento...')
		cQB9ANT := " Select B9_DATA, B9_COD, B9_QINI, B9_VINI1, B9_X_CMTRF from SB9010  where D_E_L_E_T_ = ' ' " 
		cQB9ANT += " and B9_COD = '"+B9ATU->B9_COD+"' and Substring(B9_DATA,1,6) = '"+cDtAnt+"' and B9_LOCAL = '"+B9ATU->B9_LOCAL+"' AND B9_FILIAL = '"+xFilial("SB9")+"' " 
 		if Select("B9ANT") > 0
 			dbSelectArea('B9ANT')
 			B9ANT->(dbCloseArea())
 		endif
 		dbUseArea(.T., 'TOPCONN', TcGenQry(, , cQB9ANT), 'B9ANT' , .T.,.T.)
 		dbSelectArea('B9ANT')
		nCusAnt := B9ANT->B9_X_CMTRF  //Grava o custo do mes anterior para o caso de nao haver custo no mes corrente
		dbSelectArea('SB9')
		dbSetOrder(1)
 		if dbSeek(xFilial('SB9')+B9ATU->(B9_COD+B9_LOCAL)+dTos(dtUlMes))
			RecLock('SB9',.F.)
 			if nCusAnt > 0
	 			Replace B9_X_CMTRF with nCusAnt
	 		else
	 			Replace B9_X_CMTRF with B9_CM1
	 		endif 
	 		MsUnLock('SB9')
 		endif
	B9ATU->(dbSkip())
enddo



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

//Variaveis locais
Local aRegs := {}
Local i,j

Private cPerg   := "AGF_CALCCM"
//--------------------------------


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
Local nHdl       := 0
Local nt
Local jk

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