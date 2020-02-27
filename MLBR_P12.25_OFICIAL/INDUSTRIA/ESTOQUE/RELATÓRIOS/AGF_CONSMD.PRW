#Include 'Protheus.ch'
#Include 'Rwmake.ch'

#DEFINE PICVAL  "@E 999,999,999.99"

//---------------------------------
/*

/////////////////////////////////////////////////////////////////////////////////
//Este Programa gera em excel o consumo médio mes a mes dos ultimos 12 meses.
//Conforme registros gravados no arquivo SB3

//Desenvolvido por Anesio G.Faria - angfaria@hotmail.com - Taggs Consultoria - 21-10-2011 

*/

User function AGF_CONSMD()
Private cPerg   := "AGF_CSMD"
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
		Processa({ || AGF_CSMD()}, 'Gerando informacoes...')

		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif




return


static function AGF_CSMD()
local nCount 	:= 0
local cUser  	:= RetCodUsr()
local cNomeUsr  := "" //RetNomeUsr()                
local nMes      := month(date())
local nAno      := year(date())
local aMes      := {}
Local i

U_AGF_QRYB3()

for i:= nMes + 1 to 12 
	aAdd(aMes, { u_buscames(i)+'-'+cValToChar(nAno-1)})
next i

for i:= 1 to nMes
	aAdd(aMes, { u_buscames(i)+'-'+cValToChar(nAno)})
next i
	

aAdd(aConteud, {"","CONSUMO MEDIDO DE PRODUTO DOS ULTIMOS 12 MESES ",""})
aAdd(aConteud, {"","EMITIDO EM "+dToc(dDatabase)+' - '+Time()," ",""})
aAdd(aConteud, {"","USUARIO: "+cUser+'-'+cNomeUsr,"","","","",""})
aAdd(aConteud, {"GRUPO","PRODUTO","DESCRICAO DO PRODUTO",aMes[1][1], aMes[2][1], aMes[3][1], aMes[4][1], aMes[5][1], aMes[6][1], aMes[7][1], aMes[8][1], aMes[9][1], aMes[10][1], aMes[11][1], aMes[12][1], "MEDIA" })
dbSelectArea("TRBB3")
TRBB3->(dbGotop())
Do Case 
	Case nMes == 1
		while !TRBB3->(eof())
			aAdd(aConteud, {TRBB3->B1_GRUPO+"'",TRBB3->B3_COD,TRBB3->B1_DESC, TRBB3->B3_Q02, TRBB3->B3_Q03, TRBB3->B3_Q04,TRBB3->B3_Q05, TRBB3->B3_Q06, TRBB3->B3_Q07, TRBB3->B3_Q08, TRBB3->B3_Q09, TRBB3->B3_Q10, TRBB3->B3_Q11, TRBB3->B3_Q12, TRBB3->B3_Q01, TRBB3->B3_MEDIA})
		TRBB3->(dbSkip())
		enddo	
	Case nMes == 2
		while !TRBB3->(eof())
			aAdd(aConteud, {TRBB3->B1_GRUPO+"'",TRBB3->B3_COD,TRBB3->B1_DESC, TRBB3->B3_Q03, TRBB3->B3_Q04, TRBB3->B3_Q05,TRBB3->B3_Q06, TRBB3->B3_Q07, TRBB3->B3_Q08, TRBB3->B3_Q09, TRBB3->B3_Q10, TRBB3->B3_Q11, TRBB3->B3_Q12, TRBB3->B3_Q01, TRBB3->B3_Q02, TRBB3->B3_MEDIA})
		TRBB3->(dbSkip())
		enddo	
	Case nMes == 3
		while !TRBB3->(eof())
			aAdd(aConteud, {TRBB3->B1_GRUPO+"'",TRBB3->B3_COD,TRBB3->B1_DESC, TRBB3->B3_Q04, TRBB3->B3_Q05, TRBB3->B3_Q06,TRBB3->B3_Q07, TRBB3->B3_Q08, TRBB3->B3_Q09, TRBB3->B3_Q10, TRBB3->B3_Q11, TRBB3->B3_Q12, TRBB3->B3_Q01, TRBB3->B3_Q02, TRBB3->B3_Q03, TRBB3->B3_MEDIA})
		TRBB3->(dbSkip())
		enddo	
	Case nMes == 4
		while !TRBB3->(eof())
			aAdd(aConteud, {TRBB3->B1_GRUPO+"'",TRBB3->B3_COD,TRBB3->B1_DESC, TRBB3->B3_Q05, TRBB3->B3_Q06, TRBB3->B3_Q07,TRBB3->B3_Q08, TRBB3->B3_Q09, TRBB3->B3_Q10, TRBB3->B3_Q11, TRBB3->B3_Q12, TRBB3->B3_Q01, TRBB3->B3_Q02, TRBB3->B3_Q03, TRBB3->B3_Q04, TRBB3->B3_MEDIA})
		TRBB3->(dbSkip())	
		enddo	
	Case nMes == 5
		while !TRBB3->(eof())
			aAdd(aConteud, {TRBB3->B1_GRUPO+"'",TRBB3->B3_COD,TRBB3->B1_DESC, TRBB3->B3_Q06, TRBB3->B3_Q07, TRBB3->B3_Q08,TRBB3->B3_Q09, TRBB3->B3_Q10, TRBB3->B3_Q11, TRBB3->B3_Q12, TRBB3->B3_Q01, TRBB3->B3_Q02, TRBB3->B3_Q03, TRBB3->B3_Q04, TRBB3->B3_Q05, TRBB3->B3_MEDIA})
		TRBB3->(dbSkip())
		enddo	
	Case nMes == 6
		while !TRBB3->(eof())
			aAdd(aConteud, {TRBB3->B1_GRUPO+"'",TRBB3->B3_COD,TRBB3->B1_DESC, TRBB3->B3_Q07, TRBB3->B3_Q08, TRBB3->B3_Q09,TRBB3->B3_Q10, TRBB3->B3_Q11, TRBB3->B3_Q12, TRBB3->B3_Q01, TRBB3->B3_Q02, TRBB3->B3_Q03, TRBB3->B3_Q04, TRBB3->B3_Q05, TRBB3->B3_Q06, TRBB3->B3_MEDIA})
		TRBB3->(dbSkip())
		enddo	
	Case nMes == 7
		while !TRBB3->(eof())
			aAdd(aConteud, {TRBB3->B1_GRUPO+"'",TRBB3->B3_COD,TRBB3->B1_DESC, TRBB3->B3_Q08, TRBB3->B3_Q09, TRBB3->B3_Q10,TRBB3->B3_Q11, TRBB3->B3_Q12, TRBB3->B3_Q01, TRBB3->B3_Q02, TRBB3->B3_Q03, TRBB3->B3_Q04, TRBB3->B3_Q05, TRBB3->B3_Q06, TRBB3->B3_Q07, TRBB3->B3_MEDIA})
		TRBB3->(dbSkip())
		enddo	
	Case nMes == 8
		while !TRBB3->(eof())
			aAdd(aConteud, {TRBB3->B1_GRUPO+"'",TRBB3->B3_COD,TRBB3->B1_DESC, TRBB3->B3_Q09, TRBB3->B3_Q10, TRBB3->B3_Q11,TRBB3->B3_Q12, TRBB3->B3_Q01, TRBB3->B3_Q02, TRBB3->B3_Q03, TRBB3->B3_Q04, TRBB3->B3_Q05, TRBB3->B3_Q06, TRBB3->B3_Q07, TRBB3->B3_Q08, TRBB3->B3_MEDIA})
		TRBB3->(dbSkip())
		enddo
	Case nMes == 9
		while !TRBB3->(eof())
			aAdd(aConteud, {TRBB3->B1_GRUPO+"'",TRBB3->B3_COD,TRBB3->B1_DESC, TRBB3->B3_Q10, TRBB3->B3_Q11, TRBB3->B3_Q12,TRBB3->B3_Q01, TRBB3->B3_Q02, TRBB3->B3_Q03, TRBB3->B3_Q04, TRBB3->B3_Q05, TRBB3->B3_Q06, TRBB3->B3_Q07, TRBB3->B3_Q08, TRBB3->B3_Q09, TRBB3->B3_MEDIA})
		TRBB3->(dbSkip())
		enddo	
	Case nMes == 10
		while !TRBB3->(eof())
			aAdd(aConteud, {TRBB3->B1_GRUPO+"'",TRBB3->B3_COD,TRBB3->B1_DESC, TRBB3->B3_Q11, TRBB3->B3_Q12, TRBB3->B3_Q01,TRBB3->B3_Q02, TRBB3->B3_Q03, TRBB3->B3_Q04, TRBB3->B3_Q05, TRBB3->B3_Q06, TRBB3->B3_Q07, TRBB3->B3_Q08, TRBB3->B3_Q09, TRBB3->B3_Q10, TRBB3->B3_MEDIA})
		TRBB3->(dbSkip())
		enddo	
	Case nMes == 11
		while !TRBB3->(eof())
			aAdd(aConteud, {TRBB3->B1_GRUPO+"'",TRBB3->B3_COD,TRBB3->B1_DESC, TRBB3->B3_Q12, TRBB3->B3_Q01, TRBB3->B3_Q02,TRBB3->B3_Q03, TRBB3->B3_Q04, TRBB3->B3_Q05, TRBB3->B3_Q06, TRBB3->B3_Q07, TRBB3->B3_Q08, TRBB3->B3_Q09, TRBB3->B3_Q10, TRBB3->B3_Q11, TRBB3->B3_MEDIA})
		TRBB3->(dbSkip())
		enddo	
	Case nMes == 12
		while !TRBB3->(eof())
			aAdd(aConteud, {TRBB3->B1_GRUPO+"'",TRBB3->B3_COD,TRBB3->B1_DESC, TRBB3->B3_Q01, TRBB3->B3_Q02, TRBB3->B3_Q03,TRBB3->B3_Q04, TRBB3->B3_Q05, TRBB3->B3_Q06, TRBB3->B3_Q07, TRBB3->B3_Q08, TRBB3->B3_Q09, TRBB3->B3_Q10, TRBB3->B3_Q11, TRBB3->B3_Q12, TRBB3->B3_MEDIA})
		TRBB3->(dbSkip())
		enddo	
endcase
		

//alert('Total de registros...'+cValToChar(nCount))

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-¿±±
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
//PutSx1(cPerg,"05","Emissao de                    ?"," "," ","mv_ch5","D",8,0,0, "G","","   ","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a data inicial          "},{"Informe a data inicial          "},{"Informe a data inicial           "})
//PutSx1(cPerg,"06","Emissao ate                   ?"," "," ","mv_ch6","D",8,0,0, "G","","   ","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a data Final           "},{"Informe a data final            "},{"Informe a data final           "})
//PutSx1(cPerg,"07","Armazem de                    ?"," "," ","mv_ch7","C",2,0,0, "G","","   ","","","mv_par07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o Armazem inicial           "},{"Informe o Armazem inicial           "},{"Informe o Armazem inicial           "})
//PutSx1(cPerg,"08","Armazem ate                   ?"," "," ","mv_ch8","C",2,0,0, "G","","   ","","","mv_par08"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o Armazem Final           "},{"Informe o Armazem final           "},{"Informe o Armazem final           "})
///PutSx1(cPerg,"09","Filtrar apenas transferencias ?"," "," ","mv_ch9","N",1,0,2, "C","","   ","","","mv_par09","Sim","Sim","Sim"," ","Nao","Nao","Nao"," "," "," ", " "," "," "," "," ","",{"Filtrar apenas as transferencias"},{"Filtrar apenas as transferencias"},{"Filtrar apenas as transferencias"})
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
Local nHdl       := 0
Local nt,jk

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


user function AGF_QRYB3()
Local cQuery := ""


cQuery := " Select B1_GRUPO, B3_COD, B1_DESC, B3_Q01, B3_Q02, B3_Q03, "
cQuery += " B3_Q04, B3_Q05, B3_Q06, B3_Q07, B3_Q08, B3_Q09, B3_Q10, B3_Q11, B3_Q12, B3_MEDIA "
cQuery += " from SB3010 SB3, SB1010 SB1 "
cQuery += " where SB3.D_E_L_E_T_ = ' ' "
cQuery += " and SB1.D_E_L_E_T_ = ' ' "
cQuery += " and B1_COD = B3_COD "
cQuery += " and B3_COD between '"+mv_par03+"' and '"+mv_par04+"' "
cQuery += " and B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' "
cQuery += " order by B1_GRUPO " 


if Select("TRBB3") > 0
	dbSelectArea("TRBB3")
	dbCloseArea()
endif

dbUseArea(.T., "TOPCONN", TCGenQry(, , cQuery), "TRBB3", .F., .T.)



return

user function buscames(i)
local cMes := "" 
Do Case 
	Case i == 1 
		cMes:= "JANEIRO"
	Case i == 2
		cMes:= "FEVEREIRO"
	Case i == 3 
		cMes:= "MARÇO"
	Case i == 4 
		cMes:= "ABRIL"
	Case i == 5 
		cMes:= "MAIO"
	Case i == 6 
		cMes:= "JUNHO"
	Case i == 7 
		cMes:= "JULHO"
	Case i == 8 
		cMes:= "AGOSTO"
	Case i == 9 
		cMes:= "SETEMBRO"
	Case i == 10 
		cMes:= "OUTUBRO"
	Case i == 11 
		cMes:= "NOVEMBRO"
	Case i == 12 
		cMes:= "DEZEMBRO"
endcase 		
	
return cMes 