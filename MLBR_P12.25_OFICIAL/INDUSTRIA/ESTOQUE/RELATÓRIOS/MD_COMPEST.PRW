#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE PICVAL  "@E 999,999,999.99"


User Function MD_COMPEST()


Local titulo 	:= "Planilha de Produtos empenhados "
Local cString	:= ""
Local wnrel		:= "MD_COMPEST"
Local cDesc		:= "Este Programa irá gerar uma planilha com todos os empenhos efetuados por Ordem de produção "
Local aOrd    	:= ""
Local tamanho	:= "G"
Local lRet      := .T.
Private aReturn := {" ",1," ", 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
Private cPerg   := "MD_CMPEST"
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



if APMsgNoYes("Deseja Gerar para Excel", "Gerar Excel")
	aDir := MDirArq()
	If Empty(aDir[1]) .OR. Empty(aDir[2])
		Return
	Else                      
		U_GeraCompara()
		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif
else

	Alert("Função disponivel apenas para Excel...", "Atenção")
//	RptStatus({|lEnd| MntRel1(@lEnd,wnRel,titulo,tamanho)},titulo)

endif





//wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd,,Tamanho)
//wnrel := SetPrint(cString,wnrel,,@titulo,cDesc,"","",.T.,,,Tamanho)
//msgbox("Ok Relatorio....")
If aReturn[4] == 1
	Tamanho := "M"
EndIf
If nLastKey == 27
	Set Filter To
	lRet := .F.
EndIf

If lRet
//	SetDefault(aReturn,cString)
EndIf

If lRet .And. nLastKey == 27
	Set Filter To
	lRet := .F.
EndIf

If lRet

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




User function GeraCompara()
local cCodAnt := ""
local cLocAnt := ""
local cMesAnt := "" 


U_CriaTMPB9() 

dbSelectArea("TMPB9")

TMPB9->(dbGotop())   
	//Adicionando linhas no array da planilha para gerar arquivo Excel
	aAdd(aConteud,{"","POSICAO DE ESTOQUE - MES A MES REF.ANO DE "+mv_PAR01,"","","","","","","RELATORIO EMITIDO EM: "+dToC(dDatabase),"","",""})
	aAdd(aConteud,{"","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) //36 colunas
	//Cabeçalho
	//Tabulaçao       1         2         3         4       5        6            7         8           9         10          11         12         13           14           15        16          17         18          19          20       21           22          23         24         25          26         27           28         29            30                  31 
	aAdd(aConteud,{"FILIAL","CODIGO","DESCRICAO","LOCAL","GRUPO","QTDE JAN","CUSTO JAN","QTDE FEV","CUSTO FEV","QTDE MAR","CUSTO MAR","QTDE ABR","CUSTO ABR","QTDE MAI","CUSTO MAI","QTDE JUN","CUSTO JUN","QTDE JUL","CUSTO JUL","QTDE AGO","CUSTO AGO","QTDE SET","CUSTO SET","QTDE OUT","CUSTO OUT","QTDE NOV","CUSTO NOV","QTDE DEZ","CUSTO DEZ","ESTOQUE ATUAL","CUSTO M.ATUAL"}) //31 colunas
	aAdd(aConteud,{"","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) //36 colunas
	While !TMPB9->(EoF())                                
	if TMPB9->(B9_COD+B9_LOCAL) == cCodAnt
		U_InsereLn(Substr(TMPB9->B9_DATA,5,2), TMPB9->B9_QINI, TMPB9->B9_VINI1 )///TMPB9->B9_QINI)
	else
		aAdd(aConteud,{"","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) //36 colunas	
		aConteud [len(aConteud),1] := "'"+TMPB9->B9_FILIAL+"'"
		aConteud [len(aConteud),2] := "'"+TMPB9->B9_COD+"'"
		aConteud [len(aConteud),3] := TMPB9->B1_DESC
		aConteud [len(aConteud),4] := TMPB9->B9_LOCAL+"'"
		aConteud [len(aConteud),5] := TMPB9->B1_GRUPO+"'" 
//		Alert('MES-> '+Substr(TMPB9->B9_DATA,5,2)+ ' VALOR -> '+cValToChar(TMPB9->B9_VINI1))
		U_InsereLn(Substr(TMPB9->B9_DATA,5,2),TMPB9->B9_QINI, TMPB9->B9_VINI1 )///TMPB9->B9_QINI)		
	endif

		cCodAnt := TMPB9->(B9_COD+B9_LOCAL)
		cLocAnt := TMPB9->B9_LOCAL
		cMesAnt := Substr(TMPB9->B9_DATA,5,2) 

		TMPB9->(dbSkip())
	enddo
U_BuscaSldB2()
Return()


user function CriaTMPB9()

	cQuery := " Select B9_FILIAL, B9_COD, B9_LOCAL, B9_DATA, B9_QINI, B9_CM1 B9_VINI1, "
	cQuery += " B1_GRUPO, B1_DESC " 
	cQuery += " FROM "+ RetSQLName( "SB9" ) + " SB9, " + RetSQLName( "SB1" ) + " SB1 "
	cQuery += " where SB9.D_E_L_E_T_ = ' ' and SB1.D_E_L_E_T_ =  ' ' "
	cQuery += " and B9_FILIAL = '"+xFilial("SB9")+"' " 
	cQuery += " and B1_FILIAL = '"+xFilial("SB1")+"' "
	cQuery += " and B1_COD = B9_COD "
	cQuery += " and Substring(B9_DATA,1,4) = '"+mv_par01+"' "
    cQuery += " and B1_GRUPO between '"+mv_par02+"' and '"+mv_par03+"' "
    cQuery += " and B9_COD between '"+mv_par04+"' and '"+mv_par05+"' "
    cQuery += " and B9_LOCAL between '"+mv_par06+"' and '"+mv_par07+"' "
    if MV_PAR08 == 2
	    cQuery += " and B9_QINI > 0 "
    endif
    cQuery += " order by B9_FILIAL, B9_COD, B9_LOCAL, B9_DATA "
If Select('TMPB9') > 0 
	dbSelectArea('TMPB9')
	dbclosearea()
endif

dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQuery  ), 'TMPB9' , .F. , .T. )

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
PutSx1(cPerg,"01","Periodo de                    ?"," "," ","mv_ch1","C",4,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o ano"},{"Informe o ano"},{"Informe o ano"})
PutSx1(cPerg,"02","Grupo de                      ?"," "," ","mv_ch2","C",4,0,0,	"G","","SBM","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Grupo inicial  "},{"Informe o Grupo inicial  "},{"Informe o Grupo inicial  "})
PutSx1(cPerg,"03","Grupo ate                     ?"," "," ","mv_ch3","C",4,0,0,	"G","","SBM","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Grupo final  "},{"Informe o Grupo final  "},{"Informe o Grupo finial "})
PutSx1(cPerg,"04","Produto de                    ?"," "," ","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto inicial"},{"Informe o produto inicial"},{"Informe o produto inicial"})
PutSx1(cPerg,"05","Produto ate                   ?"," "," ","mv_ch5","C",15,0,0,"G","","SB1","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto final"},{"Informe o produto final"},{"Informe o produto final"})
PutSx1(cPerg,"06","Armazem de                    ?"," "," ","mv_ch6","C",2,0,0, "G","","   ","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o Armazem inicial           "},{"Informe o Armazem inicial           "},{"Informe o Armazem inicial           "})
PutSx1(cPerg,"07","Armazem ate                   ?"," "," ","mv_ch7","C",2,0,0, "G","","   ","","","mv_par07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o Armazem Final           "},{"Informe o Armazem final           "},{"Informe o Armazem final           "})
PutSx1(cPerg,"08","Imprmir estoque zerado        ?"," "," ","mv_ch8","N",1,0,2, "C","","   ","","","mv_par08","Sim","Si","Yes", " ","Nao","No","No"," "," "," ", " "," "," "," ",	" ","",{"Imprimir prod c/est.zerado"},{"Imprimir prod c/est.zerado"},{"Imprimir prod c/est.zerado"})
RestArea(aArea)
Return

User function InsereLn(cMes, nQtde, nValor)
	do Case  
	   Case cMes == '01'
		   	aConteud [len(aConteud),6] := nQtde
			aConteud [len(aConteud),7] := nValor
	   Case cMes == '02'                             
		   	aConteud [len(aConteud),8] := nQtde
			aConteud [len(aConteud),9] := nValor
	   Case cMes == '03'
		   	aConteud [len(aConteud),10] := nQtde
			aConteud [len(aConteud),11] := nValor
	   Case cMes == '04'
		   	aConteud [len(aConteud),12] := nQtde
			aConteud [len(aConteud),13] := nValor
	   Case cMes == '05'
		   	aConteud [len(aConteud),14] := nQtde
			aConteud [len(aConteud),15] := nValor
	   Case cMes == '06'
		   	aConteud [len(aConteud),16] := nQtde
			aConteud [len(aConteud),17] := nValor
	   Case cMes == '07'
		   	aConteud [len(aConteud),18] := nQtde
			aConteud [len(aConteud),19] := nValor
	   Case cMes == '08'
		   	aConteud [len(aConteud),20] := nQtde
			aConteud [len(aConteud),21] := nValor
	   Case cMes == '09'
		   	aConteud [len(aConteud),22] := nQtde
			aConteud [len(aConteud),23] := nValor
	   Case cMes == '10'
		   	aConteud [len(aConteud),24] := nQtde
			aConteud [len(aConteud),25] := nValor
	   Case cMes == '11'
		   	aConteud [len(aConteud),26] := nQtde
			aConteud [len(aConteud),27] := nValor
	   Case cMes == '12'
		   	aConteud [len(aConteud),28] := nQtde
			aConteud [len(aConteud),29] := nValor
	EndCase 

return

//Função desenvolvida para buscar o saldo e custo do arquivo SB2 para comparacao..

user function BuscaSldB2()
Local i
dbSelectArea("SB2")
dbSetOrder(1) //Produto + Armazem
for i:= 1 to Len(aConteud) 
	if dbSeek(xFilial("SB2")+Substr(aConteud[i][2],2,15)+Substr(aConteud[i][4],1,2),.T.)
		aConteud [len(aConteud),30] := SB2->B2_QATU
		aConteud [len(aConteud),31] := SB2->B2_CM1
    endif
  next i
  


	

return
