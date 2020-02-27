#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE PICVAL  "@E 999,999,999.99"


User Function MD_PRDEMP()


Local titulo 	:= "Planilha de Produtos empenhados "
Local cString	:= ""
Local wnrel		:= "MD_PRDEMP"
Local cDesc		:= "Este Programa irá gerar uma planilha com todos os empenhos efetuados por Ordem de produção "
Local aOrd    	:= ""
Local tamanho	:= "G"
Local lRet      := .T.
Private aReturn := {" ",1," ", 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
Private cPerg   := "MD_PRDEMP"
Private nLastKey:= 0


//Exclusivo para gerar para Excel
Private aConteud:= {}       
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab        := "" 


//Pergunte("MD_PRDEMP",.F.)
	
AjustaSx1()
If ! Pergunte(cPerg,.T.)
	Return
Endif



//wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd,,Tamanho)
wnrel := SetPrint(cString,wnrel,,@titulo,cDesc,"","",.T.,,,Tamanho)
//msgbox("Ok Relatorio....")
If aReturn[4] == 1
	Tamanho := "M"
EndIf
If nLastKey == 27
	Set Filter To
	lRet := .F.
EndIf

If lRet
	SetDefault(aReturn,cString)
EndIf

If lRet .And. nLastKey == 27
	Set Filter To
	lRet := .F.
EndIf

If lRet

if APMsgNoYes("Deseja Gerar para Excel", "Gerar Excel")
	aDir := MDirArq()
	If Empty(aDir[1]) .OR. Empty(aDir[2])
		Return
	Else                      
		U_GeraPRDEMP()
		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif
else

	Alert("Função disponivel apenas para Excel...", "Atenção")
//	RptStatus({|lEnd| MntRel1(@lEnd,wnRel,titulo,tamanho)},titulo)

endif

EndIf
Return NIL


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
Local nHdl, nt, jk       := 0

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




User function GeraPRDEMP()



U_CriaTMPD4() 

dbSelectArea("TMPD4")

TMPD4->(dbGotop())   

	//Adicionando linhas no array da planilha para gerar arquivo Excel
	aAdd(aConteud,{"","RELACAO DE PRODUTOS EMPENHADOS PARA ORDEM DE PRODUCAO","","","","","","","","","",""})
	aAdd(aConteud,{"","","","","","","","","","","",""}) //12 colunas
	//Cabeçalho
	//Tabulaçao     1             2           3             4    5        6      7        8           9        10       11        12   
	aAdd(aConteud,{"ORD.PROD.","PRODUTO","DESCRICAO","QTDE EMP.","SALDO A APONTAR"}) //5 colunas

	While !TMPD4->(EoF())
		aAdd(aConteud,{"","","",0,0}) //5 colunas                    
		if MV_PAR11 == 1
			aConteud [len(aConteud),1] := ""
		elseif MV_PAR11 == 2
			aConteud [len(aConteud),1] := "'"+TMPD4->D4_OP+"'"
		endif
		aConteud [len(aConteud),2] := "'"+TMPD4->D4_COD+"'"
		aConteud [len(aConteud),3] := TMPD4->B1_DESC
		aConteud [len(aConteud),4] := TMPD4->QTDEORI
		aConteud [len(aConteud),5] := TMPD4->QTDE
		
		TMPD4->(dbSkip())
	enddo

Return()


user function CriaTMPD4()

if mv_par11 == 1 
	cQuery := " select D4_COD, B1_DESC, Sum(D4_QTDEORI) QTDEORI, SUM(D4_QUANT) QTDE "
	cQuery += " FROM "+ RetSQLName( "SD4" ) + " SD4, "+RetSQLName( "SB1" ) + " SB1 "
	cQuery += " where SB1.D_E_L_E_T_ = ' ' and SD4.D_E_L_E_T_ = ' ' 
	cQuery += " and D4_COD = B1_COD and D4_FILIAL = '"+xFilial("SD4")+"' "
	cQuery += " and D4_LOCAL between '"+mv_par09+"' AND '"+mv_par10+"' "
	cQuery += " and D4_DATA between '"+dTos(mv_par01)+"' AND '"+dTos(mv_par02)+"' "
	cQuery += " and B1_GRUPO between '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += " and D4_COD between '"+mv_par05+"' AND '"+mv_par06+"' "
	cQuery += " and substring(D4_OP,1,6) between '"+mv_par07+"' and '"+mv_par08+"' "
	cQuery += " and D4_QUANT > 0 "
	cQuery += " group by D4_COD, B1_DESC "
	cQuery += " order by B1_DESC "
elseif mv_par11 == 2
	cQuery := " select Substring(D4_OP,1,6) D4_OP, D4_COD, B1_DESC, Sum(D4_QTDEORI) QTDEORI, SUM(D4_QUANT) QTDE "
	cQuery += " FROM "+ RetSQLName( "SD4" ) + " SD4, "+RetSQLName( "SB1" ) + " SB1 "
	cQuery += " where SB1.D_E_L_E_T_ = ' ' and SD4.D_E_L_E_T_ = ' ' 
	cQuery += " and D4_COD = B1_COD and D4_FILIAL = '"+xFilial("SD4")+"' "
	cQuery += " and D4_LOCAL between '"+mv_par09+"' AND '"+mv_par10+"' "
	cQuery += " and D4_DATA between '"+dTos(mv_par01)+"' AND '"+dTos(mv_par02)+"' "
	cQuery += " and B1_GRUPO between '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += " and D4_COD between '"+mv_par05+"' AND '"+mv_par06+"' "
	cQuery += " and substring(D4_OP,1,6) between '"+mv_par07+"' and '"+mv_par08+"' "
	cQuery += " and D4_QUANT > 0 "	
	cQuery += " group by Substring(D4_OP,1,6), D4_COD, B1_DESC "
	cQuery += " order by Substring(D4_OP,1,6), B1_DESC "
endif	
                       
If Select('TMPD4') > 0 
	dbSelectArea('TMPD4')
	dbclosearea()
endif

dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQuery  ), 'TMPD4' , .F. , .T. )

//TcSetField(cAliasQry, "D3_EMISSAO", "D")


return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Anesio G.Faria -    ³    02.08.2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aArea := GetArea()
PutSx1(cPerg,"01","Periodo de                    ?"," "," ","mv_ch1","D",8,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo inicial"},{"Informe o periodo inicial"},{"Informe o periodo inicial"})
PutSx1(cPerg,"02","Periodo ate                   ?"," "," ","mv_ch2","D",8,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo final"},{"Informe o periodo final"},{"Informe o periodo final"})
PutSx1(cPerg,"03","Grupo de                      ?"," "," ","mv_ch3","C",4,0,0,	"G","","SBM","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Grupo inicial  "},{"Informe o Grupo inicial  "},{"Informe o Grupo inicial  "})
PutSx1(cPerg,"04","Grupo ate                     ?"," "," ","mv_ch4","C",4,0,0,	"G","","SBM","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Grupo final  "},{"Informe o Grupo final  "},{"Informe o Grupo finial "})
PutSx1(cPerg,"05","Produto de                    ?"," "," ","mv_ch5","C",15,0,0,"G","","SB1","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto inicial"},{"Informe o produto inicial"},{"Informe o produto inicial"})
PutSx1(cPerg,"06","Produto ate                   ?"," "," ","mv_ch6","C",15,0,0,"G","","SB1","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto final"},{"Informe o produto final"},{"Informe o produto final"})
PutSx1(cPerg,"07","Ordem de Producao de          ?"," "," ","mv_ch7","C",6,0,0, "G","","SC2","","","mv_par07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a OP Inicial        "},{"Informe a OP Inicial        "},{"Informe a OP Inicial        "})
PutSx1(cPerg,"08","Ordem de Producao ate         ?"," "," ","mv_ch8","C",6,0,0, "G","","SC2","","","mv_par08"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a OP Final        "},{"Informe a OP Final        "},{"Informe a OP Final        "})
PutSx1(cPerg,"09","Armazem de                    ?"," "," ","mv_ch9","C",2,0,0, "G","","   ","","","mv_par09"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o Armazem inicial           "},{"Informe o Armazem inicial           "},{"Informe o Armazem inicial           "})
PutSx1(cPerg,"10","Armazem ate                   ?"," "," ","mv_cha","C",2,0,0, "G","","   ","","","mv_par10"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o Armazem Final           "},{"Informe o Armazem final           "},{"Informe o Armazem final           "})
PutSx1(cPerg,"11","Imprimir Resumo               ?"," "," ","mv_chb","N",1,0,2, "C","","   ","","","mv_par11","Sim","Si","Yes", " ","Nao","No","No"," "," "," ", " "," "," "," ",	" ","",{"Imprimir resumo ao final do relatorio"},{"Imprimir resumo ao final do relatorio"},{"Imprimir resumo ao final do relatorio"})
RestArea(aArea)
Return



