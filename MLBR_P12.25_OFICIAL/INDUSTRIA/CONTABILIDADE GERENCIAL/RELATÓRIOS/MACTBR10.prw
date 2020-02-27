#INCLUDE "PROTHEUS.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TOPCONN.CH"

#DEFINE PICVAL  "@E 999,999,999.99"

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori
//|Funcao....: MACTBR09()
//|Autor.....: Jose Roberto de Souza  -  Taggs Consultoria
//|Data......: 19 de julho de 2010
//|Uso.......: SIGACTB
//|Versao....: Protheus - 10
//|Descricao.: Relatorio de Gastos por filial - Horizontal e centro de custo
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function MACTBR10()
*-----------------------------------------*
Local   nLc			:= 0
Private cTitulo  	:= "Relatorio de despesas por unidade de negocios"
Private aArea    	:= GetArea()
Private aConteud 	:= {}
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cPerg  		:= PADR("MACTBR10",10)
Private cResp 		:= ""
Private nVez		:= 1
If !SX1->(dbSeek(cPerg))
	ValidPerg(cPerg)
EndIf

If !Pergunte(cPerg,.T. )
	Return
Endif

Processa({|| MCTR10()},'Analisando Dados...')

Return .T.

//+-----------------------------------------------------------------------------------//
//|Funcao....: MCTR10()
//|Autor.....: Jose Roberto deSouza - Taggs Consultoria
//|Uso.......: SIGACTB
//|Descricao.: Gera relatorio de gastos por unidade de negocios
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MCTR10()
*-----------------------------------------*
Private aAreaNF		:= GetArea()
Private cCab		:= ""
Private cAcum		:= 0
Private nVCONT		:= 0
Private nVMER		:= 0
Private nVFRETE		:= 0
Private nVIPI		:= 0
Private nVICM		:= 0
Private nVPIS		:= 0
Private nVCOF		:= 0
Private nAcumLiq	:= 0
Private nAcumL 		:= 0

//----------------APURANDO DADOS DE GASTOS POR CENTRO DE CUSTOS CONFORME INFORMACOES DE PARAMETROS -------------------
//+--------------------------------------------------------------//
//| Faz Select principal para preenchimento do array de impressao
//+--------------------------------------------------------------//
cQuery := ""
cQuery += " SELECT *  "
cQuery += " FROM " + RETSQLNAME("CT1")
cQuery += " WHERE "
cQuery += " CT1_FILIAL  =  '"+xFilial("CT1")+"'"
cQuery += " AND SUBSTRING(CT1_CONTA,1,2) IN ('35','36','41') "
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY CT1_CONTA "
TcQuery cQuery New Alias "M1"

//01 - Guarulhos (GRU)
//04- Alto Alegre (AAL)
//08- Penápolis 2 (PNP2)
//09- Penápolis 1 (PNP1)
//10- Uberaba (UBA)
//12- Clementina (CLM)
//16- Cambuí (CMB)
//18- São Paulo (SP)
//19- Barbosa (BRS)


//impressao em 12 colunas conforme modelo.
//CONTA|DESCRICAO|GRU|PNP|PNP II|UBA|AAL|CLM|BRB|SP|CMB|TOTAL
//3.5  	GASTOS DIRETOS DE FABRICACAO
//3.6  	GASTOS INDIRETOS DE PRODUCAO
//4.5  	GASTOS OPERACIONAIS
//Competência: Janeiro de 2010

aAdd(aConteud,{"","RELATORIO DE GASTOS POR UNIDADE DE NEGOCIOS","","","","","","","","","",""})
aAdd(aConteud,{"","","","","","","","","","","","",""})

aAdd(aConteud,{"","PARAMETROS: MES :"+MV_PAR01+" DE: "+MV_PAR02,"","","","","","","","","",""})
aAdd(aConteud,{"","","","","","","","","","","","",""})

aAdd(aConteud,{"","3.5 GASTOS DIRETOS DE FABRICACAO","","","","","","","","","",""})
aAdd(aConteud,{"","3.6 GASTOS INDIRETOS DE PRODUCAO","","","","","","","","","",""})
aAdd(aConteud,{"","4.5 GASTOS OPERACIONAIS","","","","","","","","","",""})
aAdd(aConteud,{"","","","","","","","","","","","",""})

//Tabulaçao     1       2           3          4     5        6     7     8     9     10   11    12
aAdd(aConteud,{"CONTA","DESCRICAO","DEV/CRED","GRU","PNP","PNP II","UBA","AAL","CLM","BRB","SP","CMB","TOTAL"})
//CONTA|DESCRICAO|GRU|PNP|PNP II|UBA|AAL|CLM|BRB|SP|CMB|TOTAL

do While M1->(!EOF())
	cQuery := ""
	cQuery += " SELECT *  "
	cQuery += " FROM " + RETSQLNAME("CT7")
	cQuery += " WHERE "
	cQuery += " SUBSTRING(CT7_DATA,1,4) = '"+MV_PAR02+"'"
	cQuery += " AND SUBSTRING(CT7_DATA,5,2) = '"+MV_PAR01+"'"
	cQuery += " AND CT7_CONTA =  '"+M1->CT1_CONTA+"'"
	cQuery += " AND D_E_L_E_T_ <> '*' "
	cQuery += " ORDER BY CT7_FILIAL,CT7_DATA DESC " //Ordem descendente
	TcQuery cQuery New Alias "M2"
	cResp = M2->CT7_FILIAL
	if M2->(!eof())
		aAdd(aConteud,{"","","",0,0,0,0,0,0,0,0,0,0}) //Nao Vazio, adiciona linha
		if CT1->(dbSeek(xFilial("CT1")+M2->CT7_CONTA))
			aConteud [len(aConteud),1] := CT1->CT1_CONTA
			aConteud [len(aConteud),2] := CT1->CT1_DESC01
			aConteud [len(aConteud),3] := IIF(CT1->CT1_NORMAL="1","D","C")
		else
			aConteud [len(aConteud),1] := "N/I"
			aConteud [len(aConteud),2] := "N/I"
			aConteud [len(aConteud),3] := "N/I"
		endif
	endif
	do While M2->(!eof())
		cResp 	:= M2->CT7_FILIAL
		nVez 	:= 1
		//		aAdd(aConteud,{"","","","","","","","","","","",""}) //Nao Vazio, adiciona linha
		do while cResp = M2->CT7_FILIAL //Roda enquanto for a mesma filial 
			if nVez > 1  //pega somente o primeiro registro que é o que interessa (data)
				M2->(dbSkip())
			endif
			if !empty(M2->CT7_FILIAL)
				nLc := len(aConteud)
				do case
					Case M2->CT7_FILIAL = '01'  //Guarulhos
						//Tabulaçao     1       2           3          4     5        6     7     8     9     10   11    12
						//aAdd(aConteud,{"CONTA","DESCRICAO","DEV/CRED","GRU","PNP","PNP II","UBA","AAL","CLM","BRB","SP","CMB","TOTAL"})
						aConteud[nLc,4] := (M2->CT7_ATUDEB - M2->CT7_ATUCRD)
						aConteud[nLc,13] := aConteud[nLc,13] + aConteud[nLc,4]

					Case M2->CT7_FILIAL = '09'  //Penapolis
						aConteud[nLc,5] := (M2->CT7_ATUDEB - M2->CT7_ATUCRD)
						aConteud[nLc,13] := aConteud[nLc,13] +  aConteud[nLc,5]

					Case M2->CT7_FILIAL = '08'  //Penapolis II
						aConteud[nLc,6] := (M2->CT7_ATUDEB - M2->CT7_ATUCRD)
						aConteud[nLc,13] := aConteud[nLc,13] +   aConteud[nLc,6]
						
					Case M2->CT7_FILIAL = '10'  //Uberaba
						aConteud[nLc,7] := (M2->CT7_ATUDEB - M2->CT7_ATUCRD)
						aConteud[nLc,13] := aConteud[nLc,13] +   aConteud[nLc,7]
						
					Case M2->CT7_FILIAL = '04'  //Alto Alegre
						aConteud[nLc,8] := (M2->CT7_ATUDEB - M2->CT7_ATUCRD)
						aConteud[nLc,13] := aConteud[nLc,13] +   aConteud[nLc,8]
						
					Case M2->CT7_FILIAL = '12'  //Clementina
						aConteud[nLc,9] := (M2->CT7_ATUDEB - M2->CT7_ATUCRD)
						aConteud[nLc,13] := aConteud[nLc,13] +   aConteud[nLc,9]
						
					Case M2->CT7_FILIAL = '19'  //Barbosa
						aConteud[nLc,10] := (M2->CT7_ATUDEB - M2->CT7_ATUCRD)
						aConteud[nLc,13] := aConteud[nLc,13] +   aConteud[nLc,10]
						
					Case M2->CT7_FILIAL = '18'  //Sao Paulo
						aConteud[nLc,11] := (M2->CT7_ATUDEB - M2->CT7_ATUCRD)
						aConteud[nLc,13] := aConteud[nLc,13] +   aConteud[nLc,11]
						
					Case M2->CT7_FILIAL = '16'  //Cambui
						aConteud[nLc,12] := (M2->CT7_ATUDEB - M2->CT7_ATUCRD)
						aConteud[nLc,13] := aConteud[nLc,13] +   aConteud[nLc,12]
				endcase
				nVez++
				M2->(dbSkip())
			else
				exit
			endif
		enddo
	enddo
	M2->(dbCloseArea())
	M1->(dbSkip())
EndDo
aAdd(aConteud,{"","","","","","","","","","","","",""})

//---------------------------------------------------
nCab := 1
aDir := MDirArq()
If Empty(aDir[1]) .OR. Empty(aDir[2])
	Return
Else
	Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
	If lOk
		MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
	EndIf
EndIf


//nSdConta := SaldoConta("2110101             ",ddatabase-40,"01","1",1,.f.,ddatabase)

M1->(dbCloseArea())
RestArea(aAreaNF)

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

//+-----------------------------------------------------------------------------------//
//|Funcao....: ValidPerg
//|Descricao.: Valida perguntas utilizadas no SX1
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function ValidPerg(cPerg)
*-----------------------------------------*

Local aRegs := {}
Local i,j
dbSelectArea("SX1")
dbSetOrder(1)
//   1          2        3         4          5           6       7       8             9        10      11     12       13        14        15         16       17       18       19        20          21        22      23        24       25         26        27       28       29       30          31        32       33       34        35          36        37     38     39       40       41        42
//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_PYME/X1_GRPSXG/X1_HELP/X1_PICTURE
AADD(aRegs,{cPerg,"01","Mesl" 			,"","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ano"			,"","","mv_ch2","C",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

//---------------------------------------
Static Function NomeFil(cNomEmp,cNumFil)
//---------------------------------------
Local aArFil := GetArea()
SM0->(dbGoTop())
if SM0->(dbSeek(cNomEmp+cNumFil))
	RestArea(aArFil)
	Return(alltrim(SM0->M0_FILIAL))
else
	RestArea(aArFil)
	Return("Filial nao encontrada !")
endif
