#Include 'Protheus.ch'
#Include 'Rwmake.ch'

#DEFINE PICVAL  "@E 999,999,999.99"

//---------------------------------
/*

/////////////////////////////////////////////////////////////////////////////////
//Este Programa gera em excel as entradas e saidas de produtoos conforme seleção do usuario.
//foi desenvolvido com o objetivo de facilidar o acompanhamento diário dos usuarios com relacao 
//as transferencias de produtos do armazem 01 para o 02 em PNP2 -
//Mostra as transferencias que ocorreram e a qual plano se refere.

//Desenvolvido por Anesio G.Faria - Taggs Consultoria - 10-10-2011 

*/

User function AGF_KDXP2
Private cPerg   := "AGF_KDXP2"
Private aConteud    := {}       
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab        := "" 

aDir := MDirArq()
AjustaSx1()
If ! Pergunte(cPerg,.T.)
	Return
Endif

If Empty(aDir[1]) .OR. Empty(aDir[2])
	Return
Else                      
		Processa({ || AGF_KDXQRY()}, 'Gerando informacoes...')

		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif




return


static function AGF_KDXQRY()
local cOP    := "" 
local nCount := 0
local cES    := "" //Variavel registra se é entrada ou saida.
local cModelo:= ""

U_AGF_QRYSD3()

aAdd(aConteud, {"","MOVIMENTACAO DE ESTOQUE POR FILIAL",""})
aAdd(aConteud, {"","PERIODO DE "+dToc(mv_par05)+" ATE "+dToc(mv_par06),""})
aAdd(aConteud, {"","","","","","",""})
aAdd(aConteud, {"DOCUMENTO","PLANO","CODIGO","DESCRICAO DO PRODUTO","QTDE","LOCAL","TIPO E/S","MODELO"})
//SD3.D3_DOC, SD3.D3_COD, SB1.B1_DESC, SD3.D3_QUANT D3_CF, D3_TM, D3_LOCAL 
dbSelectArea("TRBD3")
TRBD3->(dbGotop())
while !TRBD3->(eof())               
	cOP     := Posicione("SC2",1,xFilial("SC2")+PADR(TRBD3->D3_DOC,6),"C2_OPMIDO")
    cModelo := Posicione("SC2",1,xFilial("SC2")+PADR(TRBD3->D3_DOC,6),"C2_PRODUTO")
    cModelo := Posicione("SB1",1,xFilial("SB1")+cModelo,"B1_DESC")
	if Substr(TRBD3->D3_CF,1,1) $ 'R'
		cES := 'SAIDA'
	else
		cES := 'ENTRADA'
	endif
	
	aAdd(aConteud, {TRBD3->D3_DOC+"'",cOP,TRBD3->D3_COD+"'",TRBD3->B1_DESC, TRBD3->D3_QUANT,TRBD3->D3_LOCAL+"'",cES, cModelo})
	cOP		:= "" 
	cModelo := "" 
	nCount++
	TRBD3->(dbSkip())
enddo
//alert('Total de registros...'+cValToChar(nCount))

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Anesio G.Faria -    ³    19.10.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static Function AjustaSX1()

Local aArea := GetArea()
//PutSx1(cPerg,"01","Periodo de                    ?"," "," ","mv_ch1","C",4,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o ano"},{"Informe o ano"},{"Informe o ano"})
PutSx1(cPerg,"01","Grupo de                      ?"," "," ","mv_ch1","C",4,0,0,	"G","","SBM","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Grupo inicial  "},{"Informe o Grupo inicial  "},{"Informe o Grupo inicial  "})
PutSx1(cPerg,"02","Grupo ate                     ?"," "," ","mv_ch2","C",4,0,0,	"G","","SBM","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Grupo final  "},{"Informe o Grupo final  "},{"Informe o Grupo finial "})
PutSx1(cPerg,"03","Produto de                    ?"," "," ","mv_ch3","C",15,0,0,"G","","SB1","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto inicial"},{"Informe o produto inicial"},{"Informe o produto inicial"})
PutSx1(cPerg,"04","Produto ate                   ?"," "," ","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto final"},{"Informe o produto final"},{"Informe o produto final"})
PutSx1(cPerg,"05","Emissao de                    ?"," "," ","mv_ch5","D",8,0,0, "G","","   ","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a data inicial          "},{"Informe a data inicial          "},{"Informe a data inicial           "})
PutSx1(cPerg,"06","Emissao ate                   ?"," "," ","mv_ch6","D",8,0,0, "G","","   ","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a data Final           "},{"Informe a data final            "},{"Informe a data final           "})
PutSx1(cPerg,"07","Armazem de                    ?"," "," ","mv_ch7","C",2,0,0, "G","","   ","","","mv_par07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o Armazem inicial           "},{"Informe o Armazem inicial           "},{"Informe o Armazem inicial           "})
PutSx1(cPerg,"08","Armazem ate                   ?"," "," ","mv_ch8","C",2,0,0, "G","","   ","","","mv_par08"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o Armazem Final           "},{"Informe o Armazem final           "},{"Informe o Armazem final           "})
PutSx1(cPerg,"09","Filtrar apenas transferencias ?"," "," ","mv_ch9","N",1,0,2, "C","","   ","","","mv_par09","Sim","Sim","Sim"," ","Nao","Nao","Nao"," "," "," ", " "," "," "," "," ","",{"Filtrar apenas as transferencias"},{"Filtrar apenas as transferencias"},{"Filtrar apenas as transferencias"})
//PutSx1(cPerg,"10","Filtrar apenas transferencias ?"," "," ","mv_cha","N",1,0,2, "C","","   ","","","mv_par10","Sim","Sim","Sim"," ","Nao","Nao","Nao"," "," "," ", " "," "," "," "," ","",{"Filtrar apenas as transferencias"},{"Filtrar apenas as transferencias"},{"Filtrar apenas as transferencias"})
RestArea(aArea)
Return


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


user function AGF_QRYSD3()
Local cQuery := ""

cQuery := " Select SD3.D3_DOC, SD3.D3_COD, SB1.B1_DESC, SD3.D3_QUANT, D3_CF, D3_TM, D3_LOCAL "
cQuery += " from SD3010 SD3, SB1010 SB1 "
cQuery += " where B1_COD = D3_COD and SD3.D_E_L_E_T_ = ' ' and SB1.D_E_L_E_T_ = ' ' "
cQuery += " and D3_FILIAL ='"+xFilial("SD3")+"' and D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' "
cQuery += " and D3_COD between '"+mv_par03+"' and '"+mv_par04+"' "
cQuery += " and D3_EMISSAO between '"+dTos(mv_par05)+"' and '"+dTos(mv_par06)+"' "
cQuery += " and D3_LOCAL between '"+mv_par07+"' and '"+mv_par08+"' "
cQuery += " and D3_ESTORNO <> 'S' "
if mv_par09 == 1 
	cQuery += " and D3_CF in ('RE4','DE4') "
endif
cQuery += " order by D3_DOC "

if Select("TRBD3") > 0
	dbSelectArea("TRBD3")
	dbCloseArea()
endif

dbUseArea(.T., "TOPCONN", TCGenQry(, , cQuery), "TRBD3", .F., .T.)



return