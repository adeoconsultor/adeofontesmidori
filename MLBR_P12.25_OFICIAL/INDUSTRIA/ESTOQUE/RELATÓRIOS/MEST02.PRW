#INCLUDE "PROTHEUS.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TOPCONN.CH"

#DEFINE PICVAL  "@E 999,999,999.999999"

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori
//|Funcao....: MEST02_()
//|Autor.....: Jose Roberto de Souza  -  Taggs Consultoria
//|Data......: 18 de dezembro de 2010
//|Uso.......: SIGAEST
//|Versao....: Protheus - 10
//|Descricao.: rELATORIO DE Produtos em elaboraçao 
//|Observação: Relatorio solicitado pelo Srl Koji para fechamento anual (inventário) 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function MEST02()
*-----------------------------------------*
Local   nLc			:= 0
Private cTitulo  	:= "Relatorio Produtos em Elaboração - INVENTARIO"
Private aArea    	:= GetArea()
Private aConteud 	:= {}
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cPerg  		:= PADR("MTR850",10)
Private cResp 		:= ""
Private nVez		:= 1
Private nLcSup      := 0 //Indica em que ponto do array esta a conta superior
Private cCtaSup     := ""
If !SX1->(dbSeek(cPerg))
	ValidPerg(cPerg)
EndIf

If !Pergunte(cPerg,.T. )
	Return
Endif

Processa({|| MEST02()},'Analisando Dados...')

Return .T.

//+-----------------------------------------------------------------------------------//
//|Funcao....: MEST02()
//|Autor.....: Jose Roberto deSouza - Taggs Consultoria
//|Uso.......: SIGAEST
//|Descricao.: Gera relatorio produtos em elaboraçao - Inventário 
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MEST02()
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
Private aSdc        := {}
Private cQuery      := ""
Private nSoma  		:= 0 

//+--------------------------------------------------------------//
//| Faz Select principal para preenchimento do array de impressao
//+--------------------------------------------------------------//

//Adicionando linhas no array da planilha
aAdd(aConteud,{"","RELATORIO DE MATERIAIS EM ELABORACAO","(INVENTARIO)","","","","","","","","","","","",""}) //15 COLUNAS
aAdd(aConteud,{"","","","","","","","","","","","","","",""}) //15 COLUNAS

aAdd(aConteud,{"","PARAMETROS:","","","","","","","","","","","","",""}) //15 COLUNAS
aAdd(aConteud,{"","","","","","","","","","","","","","",""}) //15 COLUNAS

//Cabeçalho
//Tabulaçao     1       2           3       4      5                       6       7            8                9       10
aAdd(aConteud,{"NCM/NBM","CODIGO ","TIPO","GRUPO","DESCRICAO DO MATERIAL","UNID ","QUANTIDADE","VALOR UNITARIO","TOTAL","TOTAL DA OP","1o. Conferente","2o. Conferente","RECONTAGEM"})
aAdd(aConteud,{"","","","","","","","","","","","","","",""}) //15 COLUNAS

//seleção de dados da B6
//Utiliza os mesmos parametros do relatorio MART480 - RELACAO DE MATERIAIS EM PODER DE TERCERIOS - CLIENTE/FORNECEDOR

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// Da OP                                 ³
//³ mv_par02        	// Ate a OP                              ³
//³ mv_par03        	// Do Produto                            ³
//³ mv_par04        	// Ate o Produto                         ³
//³ mv_par05        	// Do Centro de Custo                    ³
//³ mv_par06        	// Ate o Centro de Custo                 ³
//³ mv_par07        	// Da data                               ³
//³ mv_par08        	// Ate a data                            ³
//³ mv_par09        	// 1-EM ABERTO 2-ENCERRADAS  3-TODAS     ³
//³ mv_par10        	// 1-SACRAMENTADAS 2-SUSPENSA 3-TODAS    ³
//³ mv_par11            // Impr. OP's Firmes, Previstas ou Ambas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte("MTR850",.F.)
 
cQuery := ""
cQuery += " SELECT COUNT(*) AS REC  "
cQuery += " FROM " + RETSQLNAME("SC2")
cQuery += " WHERE "
cQuery += " C2_FILIAL  =  '"+xFilial("SC2")+"'"
cQuery += " AND C2_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"
cQuery += " AND C2_FILIAL  =  '"+xFilial("SC2")+"'"
cQuery += " AND C2_QUANT <> C2_QUJE "
cQuery += " AND D_E_L_E_T_ <> '*' "
TcQuery cQuery New Alias "C2"
nRec := C2->REC
C2->(dbCloseArea())

//Seleciona as OP's 
cQuery := ""
cQuery += " SELECT *  "
cQuery += " FROM " + RETSQLNAME("SC2")
cQuery += " WHERE "
cQuery += " C2_FILIAL  =  '"+xFilial("SC2")+"'"
cQuery += " AND C2_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"
cQuery += " AND C2_FILIAL  =  '"+xFilial("SC2")+"'"
cQuery += " AND C2_QUANT <> C2_QUJE "
cQuery += " AND D_E_L_E_T_ <> '*' "
TcQuery cQuery New Alias "M2"


ProcRegua(nRec)
do while M2->(!eof())
	IncProc()
	//Cabeçalho da op
	aAdd(aConteud,{"","","","","","","","","","","","","","",""}) //15 COLUNAS  - Linha em branco
	aConteud [len(aConteud),2] := "Ordem de Producao:"+ M2->C2_NUM
	aAdd(aConteud,{"","","","","","","","","","","","","","",""}) //15 COLUNAS  - Linha em branco

	//Seleciona os movimentos das OP's 
	cQuery := ""
	cQuery += " SELECT *  "
	cQuery += " FROM " + RETSQLNAME("SD3")
	cQuery += " WHERE "
	cQuery += " D3_FILIAL  =  '"+xFilial("SD3")+"'"
	cQuery += " AND SUBSTRING(D3_OP,1,6) = '"+M2->C2_NUM+"'"
	cQuery += " AND D3_FILIAL  =  '"+xFilial("SD3")+"'"
	cQuery += " AND D3_ESTORNO  <> 'S'"
	cQuery += " AND D_E_L_E_T_ <> '*' "
	TcQuery cQuery New Alias "M3"

	DO WHILE M3->(!EOF())
		SB1->(dbSeek(xFilial("SB1")+M3->D3_COD) )
		aAdd(aConteud,{"","","","","","","","","","","","","","",""}) //15 COLUNAS  - Linha em branco
		aConteud [len(aConteud),1]  := SB1->B1_POSIPI
		aConteud [len(aConteud),2]  := M3->D3_COD
		aConteud [len(aConteud),3]  := M3->D3_CF
		aConteud [len(aConteud),4]  := M3->D3_GRUPO
		aConteud [len(aConteud),5]  := SB1->B1_DESC
		aConteud [len(aConteud),6]  := M3->D3_UM
		aConteud [len(aConteud),7]  := M3->D3_QUANT
		SB2->(dbSeek(xFilial("SB2")+M3->D3_COD))
		aConteud [len(aConteud),8]  := SB2->B2_CM1
		if  M3->D3_CF <> "PR0"
			aConteud [len(aConteud),9]  := M3->D3_QUANT * SB2->B2_CM1
	        nSoma := nSoma + aConteud [len(aConteud),9]
        endif 
		aConteud [len(aConteud),10] := " "
		M3->(dbSkip())
        if M3->(EOF()) 
			aConteud [len(aConteud),10] := nSoma 
    	endif     
	ENDDO
	nSoma  		:= 0         
	M3->(dbCloseArea())
	aAdd(aConteud,{"______________","_______________","______________","_______________","____________________________","___________________","______________","________________","___________________",}) //15 COLUNAS  - Linha em branco
   	M2->(dbSkip())
enddo
M2->(dbCloseArea())

//---------------------------------------------------
//Montagem da planilha 
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
Private cArq    := "MAEST02"
Private cDir    := Space(250)
Private oDlgDir := Nil
Private cPath   := "Selecione diretório"
Private aArea   := GetArea()
Private lRetor  := .T.
Private lSair   := .F.
cDir := "F:\"
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
AADD(aRegs,{cPerg,"01","Ano" 			,"","","mv_ch1","C",04,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"02","Ano"			,"","","mv_ch2","C",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

