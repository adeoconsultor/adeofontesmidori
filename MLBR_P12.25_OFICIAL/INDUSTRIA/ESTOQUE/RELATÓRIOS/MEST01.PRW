#INCLUDE "PROTHEUS.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TOPCONN.CH"

#DEFINE PICVAL  "@E 999,999,999,999.99"

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori
//|Funcao....: MEST01_()
//|Autor.....: Jose Roberto de Souza  -  Taggs Consultoria
//|Data......: 18 de dezembro de 2010
//|Uso.......: SIGAEST
//|Versao....: Protheus - 10
//|Descricao.: Relatorio Materiais em poder de terceiros formato planilha excel
//|Observação: Relatorio solicitado pelo Srl Koji para fechamento anual (inventário) fiscal
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function MEST01()
*-----------------------------------------*
Local   nLc			:= 0
Private cTitulo  	:= "Relatorio Materiais em Poder de Terceiros - INVENTARIO"
Private aArea    	:= GetArea()
Private aConteud 	:= {}
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cPerg  		:= PADR("MTR480",10)
Private cResp 		:= ""
Private nVez		:= 1
Private nLcSup      := 0 //Indica em que ponto do array esta a conta superior
Private cCtaSup     := ""
Private cNome 		:= ""

If !SX1->(dbSeek(cPerg))
	ValidPerg(cPerg)
EndIf

If !Pergunte(cPerg,.T. )
	Return
Endif

Processa({|| MEST01()},'Analisando Dados...')

Return .T.

//+-----------------------------------------------------------------------------------//
//|Funcao....: MEST01()
//|Autor.....: Jose Roberto deSouza - Taggs Consultoria
//|Uso.......: SIGAEST
//|Descricao.: Gera relatorio materiais em poder de terceiros - inventário fiscal
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MEST01()
*-----------------------------------------*
Private aAreaNF		:= GetArea()
Private nRecSM0		:= 0 
Private cNFil		:= ""
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
Private cQuery     := 0

//+--------------------------------------------------------------//
//| Faz Select principal para preenchimento do array de impressao
//+--------------------------------------------------------------//

//Pega o nome da filial para imprimir no relatório 
nRecSM0 := SM0->(recno())
do While SM0->(!eof())
	if SM0->M0_CODFIL = cFilAnt
		cNFil := SM0->M0_NOME
	endif 
	SM0->(dbSkip())
enddo 
SM0->(dbGoTo(nRecSM0))

//seleção de dados da B6
//Utiliza os mesmos parametros do relatorio MART480 - RELACAO DE MATERIAIS EM PODER DE TERCERIOS - CLIENTE/FORNECEDOR
pergunte("MTR480",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                  ³
//³ mv_par01   		// Cliente Inicial                		              ³
//³ mv_par02        // Cliente Final                       	              ³
//³ mv_par03        // Fornecedor Inicial                     	          ³
//³ mv_par04        // Fornecedor Final                          	      ³
//³ mv_par05        // Produto Inicial                              	  ³
//³ mv_par06        // Produto Final                         		      ³
//³ mv_par07        // Data Inicial                              	      ³
//³ mv_par08        // Data Final                                   	  ³
//³ mv_par09        // Situacao   (Todos / Em aberto)                     ³
//³ mv_par10        // Tipo   (De Terceiros / Em Terceiros / Ambos)		  ³
//³ mv_par11        // Custo em Qual Moeda  (1/2/3/4/5)             	  ³
//³ mv_par12        // Lista NF Devolucao  (Sim) (Nao)              	  ³
//³ mv_par13        // Devolucao data de                            	  ³
//³ mv_par14        // Devolucao data ate                           	  ³
//³ mv_par15        // QTDE. na 2a. U.M.? Sim / Nao                       ³
//³ mv_par16        // Lista Custo? Medio / Fifo                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//Adicionando linhas no array da planilha
aAdd(aConteud,{"","RELATORIO DE MATERIAIS EM PODER DE TERCEIROS (INVENTARIO-FILIA: "+alltrim(cNFil)+")","","","","","","","","","","","","",""}) //15 COLUNAS
aAdd(aConteud,{"PARAMETROS:","Cliente de: "+MV_PAR01+" Ate: "+MV_PAR02,"","","","","","","","","","","",""}) //15 COLUNAS
aAdd(aConteud,{""           ,"Fornecedor de: "+MV_PAR03+" Ate: "+MV_PAR04,"","","","","","","","","","","",""}) //15 COLUNAS
aAdd(aConteud,{""           ,"Produto de: "+MV_PAR05+" Ate: "+MV_PAR06,"","","","","","","","","","","",""}) //15 COLUNAS
aAdd(aConteud,{""           ,"Emissao de: "+dtoc(MV_PAR07)+" Ate: "+dtoc(MV_PAR08),"","","","","","","","","","","",""}) //15 COLUNAS
aAdd(aConteud,{""           ,"De Terc.(1),Em Terc.(2), Ambos(3): "+alltrim(str(MV_PAR10)),"","","","","","","","","","","",""}) //15 COLUNAS
aAdd(aConteud,{"","","","","","","","","","","","","","",""}) //15 COLUNAS

//Cabeçalho
//Tabulaçao     1       2           3       4      5                       6       7            8                9       10
aAdd(aConteud,{"NCM/NBM","CODIGO ","TIPO","GRUPO","DESCRICAO DO MATERIAL","UNID ","QUANTIDADE","VALOR UNITARIO","TOTAL","PRECO","Cabe ao setor fiscal a conferencia "})
aAdd(aConteud,{"","","","","","","","","","","","","","",""}) //15 COLUNAS
 
cQuery := ""
cQuery += " SELECT COUNT(*) AS REC  "
cQuery += " FROM " + RETSQLNAME("SB6")
cQuery += " WHERE "
cQuery += " B6_FILIAL  =  '"+xFilial("SB6")+"'"
cQuery += " AND B6_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"
cQuery += " AND B6_FILIAL  =  '"+xFilial("SB6")+"'"
cQuery += " AND B6_TIPO = 'E' "
cQuery += " AND D_E_L_E_T_ <> '*' "
TcQuery cQuery New Alias "B6"
nRec := B6->REC
B6->(dbCloseArea())

cQuery := ""
cQuery += " SELECT *  "
cQuery += " FROM " + RETSQLNAME("SB6")
cQuery += " WHERE "
cQuery += " B6_FILIAL  =  '"+xFilial("SB6")+"'"
cQuery += " AND B6_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"
cQuery += " AND B6_FILIAL  =  '"+xFilial("SB6")+"'"
cQuery += " AND B6_CLIFOR >= '"+MV_PAR01+"'"
cQuery += " AND B6_CLIFOR <= '"+MV_PAR02+"'"
cQuery += " AND B6_CLIFOR >= '"+MV_PAR03+"'"
cQuery += " AND B6_CLIFOR <= '"+MV_PAR04+"'"
cQuery += " AND B6_PRODUTO >= '"+MV_PAR05+"'"
cQuery += " AND B6_PRODUTO <= '"+MV_PAR06+"'"
cQuery += " AND B6_TIPO = 'E' "
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY B6_TIPO,B6_CLIFOR "
TcQuery cQuery New Alias "B6"

ProcRegua(nRec)
do while B6->(!eof())
	IncProc()
	//testa pararametro para imprimir todas ou somente em aberto
	//mv_par09        // Situacao   (Todos / Em aberto)
	If mv_par09 == 2 .And. B6->B6_SALDO <= 0
		SB6->(dbSkip())
		Loop
	EndIf
	//mv_par10        // Tipo   (De Terceiros / Em Terceiros / Ambos)
	If mv_par10 == 1 .And. B6->B6_TIPO != "D"
		B6->(dbSkip())
		Loop
	ElseIf mv_par10 == 2 .And. B6->B6_TIPO != "E"
		B6->(dbSkip())
		Loop
	EndIf
//³ mv_par11        // Custo em Qual Moeda  (1/2/3/4/5)             	  ³
//³ mv_par12        // Lista NF Devolucao  (Sim) (Nao)              	  ³
	cCliFor := B6->B6_CLIFOR
	cNota   := B6->B6_DOC
	//Cabeçalho da nota
	aAdd(aConteud,{"","","","","","","","","","","","","","",""}) //15 COLUNAS  - Linha em branco
	if B6->B6_TPCF = "F"
		SA2->(dbSeek(xFilial("SA2")+B6->B6_CLIFOR+B6->B6_LOJA))
		cNome := alltrim(SA2->A2_NOME)
	else
		SA1->(dbSeek(xFilial("SA1")+B6->B6_CLIFOR+B6->B6_LOJA))
		cNome := alltrim(SA1->A1_NOME)
	endif 

	aConteud [len(aConteud),2] := "Destinatário "+ B6->B6_CLIFOR+"/"+B6->B6_LOJA +"-"+cNome
	aConteud [len(aConteud),4] := "Nota Fiscal:"
	aConteud [len(aConteud),5] := B6->B6_DOC + "/"+ B6->B6_SERIE + "de: "+ SUBSTR(B6->B6_EMISSAO,7,2)+"/"+SUBSTR(B6->B6_EMISSAO,5,2)+"/"+SUBSTR(B6->B6_EMISSAO,3,2)
	
	DO WHILE (B6->B6_CLIFOR + B6->B6_DOC) = (cCliFor + cNota )
		SB1->(dbSeek(xFilial("SB1")+B6->B6_PRODUTO) )
		aAdd(aConteud,{"","","","","","","","","","","","","","",""}) //15 COLUNAS  - Linha em branco
		aConteud [len(aConteud),1]  := SB1->B1_POSIPI
		aConteud [len(aConteud),2]  := B6->B6_PRODUTO
		aConteud [len(aConteud),3]  := B6->B6_TIPO
		aConteud [len(aConteud),4]  := SB1->B1_GRUPO
		aConteud [len(aConteud),5]  := SB1->B1_DESC
		aConteud [len(aConteud),6]  := B6->B6_UM
		aConteud [len(aConteud),7]  := B6->B6_QUANT
		aConteud [len(aConteud),8]  := B6->B6_PRUNIT
		aConteud [len(aConteud),9]  := B6->B6_QUANT * B6->B6_PRUNIT
		aConteud [len(aConteud),10] := B6->B6_PRUNIT
		aConteud [len(aConteud),11] := "|_____________________________________|"
		B6->(dbSkip())
	ENDDO
	aAdd(aConteud,{"______________","_______________","______________","_______________","____________________________","___________________","______________","________________","___________________","_________________________","_______________________________"}) //15 COLUNAS  - Linha em branco

enddo
B6->(dbCloseArea())


//REMESSA

ProcRegua(nRec)

cQuery := ""
cQuery += " SELECT COUNT(*) AS REC  "
cQuery += " FROM " + RETSQLNAME("SB6")
cQuery += " WHERE "
cQuery += " B6_FILIAL  =  '"+xFilial("SB6")+"'"
cQuery += " AND B6_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"
cQuery += " AND B6_FILIAL  =  '"+xFilial("SB6")+"'"
cQuery += " AND B6_TIPO = 'D' "
cQuery += " AND D_E_L_E_T_ <> '*' "
TcQuery cQuery New Alias "B6"
nRec := B6->REC
B6->(dbCloseArea())


cQuery := ""
cQuery += " SELECT *  "
cQuery += " FROM " + RETSQLNAME("SB6")
cQuery += " WHERE "
cQuery += " B6_FILIAL  =  '"+xFilial("SB6")+"'"
cQuery += " AND B6_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"
cQuery += " AND B6_FILIAL  =  '"+xFilial("SB6")+"'"
cQuery += " AND B6_TIPO = 'D' "
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY B6_TIPO,B6_CLIFOR "
TcQuery cQuery New Alias "B6"

ProcRegua(nRec)
DO while B6->(!eof())
	IncProc()
	//testa pararametro para imprimir todas ou somente em aberto
	//mv_par09        // Situacao   (Todos / Em aberto)
	If mv_par09 == 2 .And. B6->B6_SALDO <= 0
		SB6->(dbSkip())
		Loop
	EndIf
	//mv_par10        // Tipo   (De Terceiros / Em Terceiros / Ambos)
	If mv_par10 == 1 .And. B6->B6_TIPO != "D"
		B6->(dbSkip())
		Loop
	ElseIf mv_par10 == 2 .And. B6->B6_TIPO != "E"
		B6->(dbSkip())
		Loop
	EndIf
//³ mv_par11        // Custo em Qual Moeda  (1/2/3/4/5)             	  ³
//³ mv_par12        // Lista NF Devolucao  (Sim) (Nao)              	  ³
	cCliFor := B6->B6_CLIFOR
	cNota   := B6->B6_DOC
	//Cabeçalho da nota
	//Cabeçalho da nota
	aAdd(aConteud,{"","","","","","","","","","","","","","",""}) //15 COLUNAS  - Linha em branco
	if B6->B6_TPCF = "F"
		SA2->(dbSeek(xFilial("SA2")+B6->B6_CLIFOR+B6->B6_LOJA))
		cNome := alltrim(SA2->A2_NOME)
	else
		SA1->(dbSeek(xFilial("SA1")+B6->B6_CLIFOR+B6->B6_LOJA))
		cNome := alltrim(SA1->A1_NOME)
	endif 
	aConteud [len(aConteud),2] := "Destinatário "+ B6->B6_CLIFOR+"/"+B6->B6_LOJA +"-"+cNome
	aConteud [len(aConteud),4] := "Nota Fiscal:"
	aConteud [len(aConteud),5] := B6->B6_DOC + "/"+ B6->B6_SERIE + "de: "+ SUBSTR(B6->B6_EMISSAO,7,2)+"/"+SUBSTR(B6->B6_EMISSAO,5,2)+"/"+SUBSTR(B6->B6_EMISSAO,3,2)

	DO WHILE (B6->B6_CLIFOR + B6->B6_DOC) = (cCliFor + cNota )
		SB1->(dbSeek(xFilial("SB1")+B6->B6_PRODUTO) )
		aAdd(aConteud,{"","","","","","","","","","","","","","",""}) //15 COLUNAS  - Linha em branco
		aConteud [len(aConteud),1]  := SB1->B1_POSIPI
		aConteud [len(aConteud),2]  := B6->B6_PRODUTO
		aConteud [len(aConteud),3]  := B6->B6_TIPO
		aConteud [len(aConteud),4]  := SB1->B1_GRUPO
		aConteud [len(aConteud),5]  := SB1->B1_DESC
		aConteud [len(aConteud),6]  := B6->B6_UM
		aConteud [len(aConteud),7]  := B6->B6_QUANT
		aConteud [len(aConteud),8]  := B6->B6_PRUNIT
		aConteud [len(aConteud),9]  := B6->B6_QUANT * B6->B6_PRUNIT
		aConteud [len(aConteud),10] := B6->B6_PRUNIT
		aConteud [len(aConteud),11] := "|_____________________________________|"
		B6->(dbSkip())
	ENDDO
	aAdd(aConteud,{"______________","_______________","______________","_______________","____________________________","___________________","______________","________________","___________________","_________________________","_______________________________"}) //15 COLUNAS  - Linha em branco
enddo
B6->(dbCloseArea())



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
Private cArq    := "MAEST01"
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
Local nHdl, nt, nt       := 0

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

For nt := 1 to Len(axVet)
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

