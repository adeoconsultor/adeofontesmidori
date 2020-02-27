#include 'protheus.ch'
#include 'rwmake.ch'

#DEFINE PICVAL  "@E 999,999,999.99"
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Função com o objetivo de gerar um relatorio dos produtos lento/desuso mes a mes
//detalhado
//O objetivo é identificar os produtos em desuso assim que ocorrer o fechamento do mes

//Desenvolvido por Anesio G.Faria - 17/03/2017
     
//Rotina principal que vai chamar as demais...
user function AG_LENDESU() //Relatorio para calcular produto Lento/Desuso 

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
Private cPerg   := "AG_LENDES"

Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab        := "" 



//if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
//endif
Pergunte(cPerg,.T.)
Aadd(aItens, {"PLANILHA DE PRODUTO LENTO/DESUSO PLANILHA GERADA EM "+dtoc(dDataBase)})
//Aadd(aItens, {"COMPARATIVO DE CONSUMO DEVIDO x CONSUMO REAL" })
Aadd(aItens, {"FILIAL", "EMISSAO", "GRUPO DE PRODUTO", "TIPO", "UM", "CATEGORIA", "ARMAZEM","QTY STOCK","VLR ESTOQUE","STATUS", "DESCRICAO DO PRODUTO"})
//B9_FILIAL	EMISSAO	BM_DESC	B1_DESC	B1_TIPO	B1_UM	Categoria	ARMAZEM	 QTDINI 	 VINI 


cQuery := " Select B9_FILIAL, EMISSAO, B1_GRUPO+'-'+BM_DESC GRUPO, B9_COD+'-'+B1_DESC PRODUTO, B1_TIPO, B1_UM, "		
cQuery += " Categoria =  "		
cQuery += " 	Case B1_TIPO "	
cQuery += " 		WHEN 'MP' then 'MATERIAL' "
cQuery += " 		WHEN 'PI' then 'MATERIAL' "
cQuery += " 		WHEN 'MC' then 'MATERIAL' "
cQuery += " 		WHEN 'ME' then 'MATERIAL' "
cQuery += " 		WHEN 'PP' then 'ELABORACAO' "
cQuery += " 		WHEN 'PA' then 'ACABADO' "
cQuery += " 		Else 'NAO IDENTIFICADO' "
cQuery += " 	end, "
cQuery += " B9_LOCAL = "
cQuery += " 	Case B9_LOCAL " 
cQuery += " 		WHEN 'DS' then 'DESUSO' "
cQuery += " 		WHEN 'DE' then 'DESUSO' "
cQuery += " 		Else 'NORMAL' "
cQuery += " 	end,"
cQuery += " Sum(QTDINI) QTDINI, " 
cQuery += " Sum(VINI) VINI "	
cQuery += "  from "		
cQuery += " (Select B9_FILIAL, Substring(B9_DATA,1,6) EMISSAO, RTRIM(B1_GRUPO) B1_GRUPO, RTRIM(BM_DESC) BM_DESC, RTRIM(B9_COD) B9_COD, RTRIM(B1_DESC) B1_DESC, B1_TIPO, B1_UM, B9_LOCAL, " 		
cQuery += " Sum(B9_QINI) QTDINI, SUm(B9_VINI1) VINI from SB9010 SB9, SB1010 SB1, SBM010 SBM	"	
cQuery += " where SB9.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' and SBM.D_E_L_E_T_ =' ' "		
//cQuery += " --and B9_FILIAL in ('08','09','19','01') "
//cQuery += " and B9_FILIAL ='09' "
cQuery += " and B1_COD = B9_COD and B1_GRUPO = BM_GRUPO "		
cQuery += " and substring(B9_DATA,1,6) in ('201702','201701','201612') and B9_VINI1 > 0  "		
//cQuery += " and Substring(B9_DATA,1,6)='"+mv_par01+mv_par02+"' "
cQuery += " and B1_TIPO in ('MP','PI','MC','ME','PP','PA') "
cQuery += " and B9_LOCAL IN ('DS','DE') "
cQuery += " group by B9_FILIAL, Substring(B9_DATA,1,6), B1_GRUPO, BM_DESC, B9_COD, B1_DESC, B1_TIPO, B1_UM, B9_LOCAL) ESTOQUE "		
cQuery += " group by B9_FILIAL, EMISSAO, B1_GRUPO+'-'+BM_DESC, B9_COD+'-'+B1_DESC, B1_TIPO, B1_UM, B9_LOCAL	"
cQuery += " order by 1, 2, 3 "		

if Select('TMPCM') > 0
	dbSelectArea('TMPCM')
	TMPCM->(dbCloseArea())
endif
memowrite('c:\temp\cQuery.txt', cQuery )
dbUseArea(.T., 'TOPCONN', tcGenQry( , , cQuery), 'TMPCM', .T., .T.)


dbSelectArea('TMPCM')
dbGotop()
cCodOld  := TMPCM->PRODUTO
cCod	 := "'"
nQtde    := 0  
nCusto   := 0
//aPRD     := {}
//AADD(aPRD, {'Filial', 'Mes', 'Grupo', 'Produto', 'Tipo', 'Um', 'Categoria', 'Tipo de armazem', 'Qty', 'Custo', 'Status'}) 
cData:="ESTOQUE"
ncont :=1
while !TMPCM->(eof())
	incproc('Atualizando registros... '+Substr(TMPCM->PRODUTO,1,6)+ " Registro: "+cValToChar(nCont))
	//Rotina para checar ultima movimentacao do material
   //	if TMPCM->B9_LOCAL == "DESUSO" .and. TMPCM->B9_FILIAL <> '09'
        cQUltMov := " SELECT MAX(Substring(D3_EMISSAO,1,6)) ULTMOV FROM SD3010 where D_E_L_E_T_ = ' ' and D3_OP <> '' "
       // cQUltMov += " AND Substring(D3_EMISSAO,1,6) <= '"+mv_par01+mv_par02+"' "
        cQUltMov += " AND D3_FILIAL = '"+TMPCM->B9_FILIAL+"' "  
        cQUltMov += " AND Substring(D3_COD,1,6) = '"+Substr(TMPCM->PRODUTO,1,6)+"' AND D3_ESTORNO <> 'S' "
        if Select('TMPULT') > 0 
        	dbSelectArea('TMPULT') 
        	TMPULT->(dbCloseArea())
        endif
        dbUseArea(.T., "TOPCONN", tcGenQry(, , cQUltMov), 'TMPULT', .T., .T.)
 		dbSelectArea("TMPULT")
 		dbGotop()
 		/*if TMPULT->ULTMOV >= MV_PAR04 .and. TMPULT->ULTMOV < MV_PAR03
 			cData := "ESTOQUE LENTO"
 		elseif TMPULT->ULTMOV < MV_PAR04
 			cData := "ESTOQUE DESUSO"
 		else 
 			cData := "ESTOQUE NORMAL1"
 		endif*/
   //	else
 		cData := TMPULT->ULTMOV
   // endif 
//B9_FILIAL, EMISSAO, B1_GRUPO+'-'+BM_DESC GRUPO, B1_TIPO, B1_UM, B9_COD+'-'+B1_DESC PRODUTO,
    AADD(aItens, {TMPCM->B9_FILIAL, TMPCM->EMISSAO, TMPCM->GRUPO, TMPCM->B1_TIPO, TMPCM->B1_UM, TMPCM->Categoria, TMPCM->B9_LOCAL, TMPCM->QTDINI, TMPCM->VINI, cData, TMPCM->PRODUTO}) 
        
	TMPCM->(dbSkip())
	nCont++
enddo
//if ApmsgNoYes('Deseja gerar os registros atualizados para excel ? ', 'Atenção')

	aDir := MDirArq()
	If Empty(aDir[1]) .OR. Empty(aDir[2])
		Return
	Else                      

		Processa({ || lOk := MCVS(aItens,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif
//else
//	return
//endif



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
PutSx1(cPerg,"03","Informe Ano/Mes Lento         ?"," "," ","mv_ch3","C",6,0,0,	"G","","   ","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Ano/Mes Lento"},{"Informe o Ano/Mes Lento"},{"Informe o Ano/Mes Lento"})
PutSx1(cPerg,"04","Informe Ano/Mes Desuso        ?"," "," ","mv_ch4","C",6,0,0,	"G","","   ","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Ano/Mes Desuso"},{"Informe o Ano/Mes Desuso"},{"Informe Ano/Mes Desuso"})

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
