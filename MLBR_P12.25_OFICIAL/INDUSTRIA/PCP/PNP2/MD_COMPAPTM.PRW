#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE PICVAL  "@E 999,999,999.99"


User Function MD_COMPAPTM()  //Compara apontamentos X Padrao - Rotina de Fichas PNP2

/////////////////////////////////////////////////////////////////////////////////////////////////
//Programa que vai gerar relatório em Excel com as movimentações feitas nas fichas dentro dos parametros selecionados
//Faz um comparativo entre o padrao do sistema e o que foi apontado pelos usuarios, tambem apresenta 
//apontamentos feito com senha de outros usuários.

//Desenvolvido por Anesio G.Faria - Taggs Consultoria - 28-07-2011


Local titulo 	:= "Planilha de apontamento de fichas"
Local cString	:= ""
Local wnrel		:= "MD_COMPAPTM"
Local cDesc		:= "Programa que vai gerar relatório em Excel com as movimentações feitas nas fichas dentro dos parametros selecionados "
Local aOrd    	:= ""
Local tamanho	:= "G"
Local lRet      := .T.
Private aReturn := {" ",1," ", 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
Private cPerg   := "MD_CMPAPT"
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



//if APMsgNoYes("Deseja Gerar para Excel", "Gerar Excel")
	aDir := MDirArq()
	If Empty(aDir[1]) .OR. Empty(aDir[2])
		Return
	Else                      
		GeraComp()
		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif
//else

//	Alert("Função disponivel apenas para Excel...", "Atenção")
//	RptStatus({|lEnd| MntRel1(@lEnd,wnRel,titulo,tamanho)},titulo)

//endif




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




Static function GeraComp()  //Gera comparação de apontamentos
local cCodAnt := ""
local cLocAnt := ""
local cMesAnt := "" 


CriaTMP() 

dbSelectArea("TMP")

TMP->(dbGotop())   
	//Adicionando linhas no array da planilha para gerar arquivo Excel
	aAdd(aConteud,{"","APONTAMENTO REALIZADO ENTRE "+dToc(mv_PAR01)+" E "+dToc(mv_PAR02),"","RELATORIO EMITIDO EM: "+dToC(dDatabase),"","","","","","","",""})
	aAdd(aConteud,{"","PLANO DE "+mv_PAR03+" ATE "+mv_PAR04,"","","","","","","","","",""}) //12 colunas
	aAdd(aConteud,{"","","","","","","","","","","",""}) //12 colunas	
	//Cabeçalho
	//Tabulaçao       1         2         3                4                 5                  6                7             8         9           10           11            12    
	aAdd(aConteud,{"FICHA","ORD.PROD","OPERADOR","NOME DO OPERADOR","DATA DIGITACAO","USUARIO QUE APONTOU","PLANO","DATA DA FICHA","STATUS","M² PADRAO","M² UTILIZADO","APROVEIT.","OBSERVACAO"}) //13 colunas
	aAdd(aConteud,{"","","","","","","","","","","","",""}) //13 colunas
	While !TMP->(EoF())                                
		aAdd(aConteud,{"","","","","","","","","","","","",""}) //13 colunas 
		nM2Pad := Posicione('SZ7',1,xFilial('SZ7')+TMP->Z7_NUMFC+'00','Z7_M2APONT')
		aConteud [len(aConteud),1] := "'"+TMP->Z7_NUMFC
		aConteud [len(aConteud),2] := "'"+TMP->Z3_NUMOP+"'"
		aConteud [len(aConteud),3] := TMP->Z7_OPERADO
		aConteud [len(aConteud),4] := Posicione("SH1",1,xFilial("SH1")+TMP->Z7_OPERADO,"H1_DESCRI")
		aConteud [len(aConteud),5] := dtoc(TMP->Z7_DTDIGIT)
		aConteud [len(aConteud),6] := TMP->Z7_USDIGIT
		aConteud [len(aConteud),7] := TMP->Z7_PLANO
		aConteud [len(aConteud),8] := dtoc(TMP->Z3_DTFICHA)
		aConteud [len(aConteud),9] := iif(TMP->Z3_STATUS=='B',"BAIXADO","ABERTO")
		aConteud [len(aConteud),10]:= nM2Pad //TMP->Z3_SLDM2
		aConteud [len(aConteud),11]:= TMP->Z7_M2APONT
		aConteud [len(aConteud),12]:= nM2Pad / TMP->Z3_SLDM2 
		if Substr(TMP->Z7_USDIGIT,1,14) <> Substr(Posicione("SH1",1,xFilial("SH1")+TMP->Z7_OPERADO,"H1_DESCRI"),1,14)
			aConteud [len(aConteud),13]:= "USOU SENHA DE OUTRO USUARIO"
		endif
		TMP->(dbSkip())
	enddo

Return()


static function CriaTMP()


	cQuery := " select Z7_NUMFC, Z3_NUMOP, Z7_OPERADO, Z7_DTDIGIT, Z7_USDIGIT, "
	cQuery += " Z7_PLANO, Z3_DTFICHA, Z3_STATUS, " 
	cQuery += " sum(Z3_SLDM2) Z3_SLDM2, avg(Z7_M2APONT) Z7_M2APONT "
	cQuery += " FROM "+ RetSQLName( "SZ7" ) + " SZ7, " + RetSQLName( "SZ3" ) + " SZ3 "
	cQuery += " where SZ7.D_E_L_E_T_ = ' ' and SZ3.D_E_L_E_T_ =  ' ' "
	cQuery += " and Z3_FILIAL = '"+xFilial("SZ3")+"' " 
	cQuery += " and Z7_FILIAL = '"+xFilial("SZ7")+"' "
	cQuery += " and Z3_NUMFC = Z7_NUMFC "
	cQuery += " and Z3_FILIAL = Z7_FILIAL "
	cQuery += " and Z3_PLANO = Z7_PLANO and Z7_FASE='01' "
	cQuery += " and Z7_DTDIGIT between '"+dtos(mv_par01)+"' and '"+dtos(mv_par02)+"' "
	cQuery += " and Z3_PLANO between '"+mv_par03+"' and '"+mv_par04+"' "
    cQuery += " group by Z7_NUMFC, Z3_NUMOP, Z7_OPERADO, Z7_DTDIGIT, Z7_USDIGIT,  Z7_PLANO, Z3_DTFICHA, Z3_STATUS "
    cQuery += " order by Z7_NUMFC "
If Select('TMP') > 0 
	dbSelectArea('TMP')
	dbclosearea()
endif

dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQuery  ), 'TMP' , .F. , .T. )

TcSetField('TMP', "Z7_DTDIGIT", "D")       
TcSetField('TMP', "Z3_DTFICHA", "D")


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
PutSx1(cPerg,"01","Periodo de                    ?"," "," ","mv_ch1","D",8,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe data inicial"},{"Informe data inicial"},{"Informe data inicial"})
PutSx1(cPerg,"02","Periodo ate                   ?"," "," ","mv_ch2","D",8,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe data final"},{"Informe data final"},{"Informe data final"})
PutSx1(cPerg,"03","Plano de                      ?"," "," ","mv_ch3","C",4,0,0,	"G","","SZ3","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Plano inicial  "},{"Informe o Plano inicial  "},{"Informe o Plano inicial  "})
PutSx1(cPerg,"04","Plano ate                     ?"," "," ","mv_ch4","C",4,0,0,	"G","","SZ3","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Plano final  "},{"Informe o Plano final  "},{"Informe o Plano finial "})
RestArea(aArea)
Return

return
