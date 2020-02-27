#Include 'Protheus.ch'
#Include 'Rwmake.ch'

#DEFINE PICVAL  "@E 999,999,999.99"

//---------------------------------
/*

/////////////////////////////////////////////////////////////////////////////////
//Este Programa gera em excel a quantidade de planos produzidos em determinado periodo
//Conforme fitro realizado pelo usuario via parametros.
//O objetivo é apresentar a quantidade de kits produzido no periodo, com opcao de verificar qual 
//o percentual de aproveitamento obtido.

//Desenvolvido por Anesio G.Faria - angfaria@hotmail.com - Taggs Consultoria - 25-10-2011 

*/

User function AGF_PLNPRD()
Private cPerg   := "AGF_PLNPRD"
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
		Processa({ || AGF_PLNP1()}, 'Gerando informacoes...')

		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif




return


static function AGF_PLNP1()
local nCount 	:= 0
local cUser  	:= RetCodUsr()
local cNomeUsr  := "" //RetNomeUsr()                
local nMes      := month(date())
local nAno      := year(date())
local aMes      := {}
local dtApIni   := mv_par01
local dtApFim   := mv_par02

//alert("Nome do usuario"+ cnomeUsr)
U_AGF_QRYTMP()

aAdd(aConteud, {"","RELACAO DE PRODUCAO PERIODO DE "+DTOC(MV_PAR01)+" ATE "+DTOC(MV_PAR02),"","","","","",""}) //8 COLUNAS
aAdd(aConteud, {"","EMITIDO EM "+dToc(dDatabase)+' - '+Time()+ " "+"TIPO: "+IIF(MV_PAR11 == 1, "ANALITICO","SINTETICO"),"","IMPRIMIR MATERIAL: "+IIF(MV_PAR12==1,"SIM","NAO"),"","","",""})  //8 COLUNAS
aAdd(aConteud, {"","USUARIO: "+cUser+'- KIT DE '+mv_par09+" ATE "+mv_par10,"","","","","",""})  //8 COLUNAS
if MV_PAR11 = 1
	aAdd(aConteud, {"ORD.PROD.","CODIGO KIT", "DESCRICAO DO KIT", "PLANO", "QUANTIDADE", "DATA EMISSAO", "METROS PADR", "METROS GASTOS", "APROVEITAMENTO","DATA APTO" })
else
	aAdd(aConteud, {"CODIGO KIT", "DESCRICAO DO KIT", "QUANTIDADE", "METROS PADR", "METROS GASTOS", "APROVEITAMENTO"})
endif             

dbSelectArea("TRBPL")
TRBPL->(dbGotop())
cProd 		:= "" //TRBPL->C2_PRODUTO
cOPs 	 	:= ""
nCountIt 	:= 0
cOldOp      := ""
nQuant      := 0
while !TRBPL->(eof())
//		aConteud [len(aConteud),1] := ""
	cOldOp := TRBPL->C2_NUM
	if MV_PAR11 == 1 // Se é analitico 1=Sim, 2=Nao
		u_qryCons(nCountIt,"'"+TRBPL->C2_NUM+"'", TRBPL->C2_OPMIDO, TRBPL->D3_EMISSAO, MV_PAR01, MV_PAR02)
		aAdd(aConteud, {TRBPL->C2_NUM+"'", Substr(TRBPL->C2_PRODUTO,1,6)+"'", TRBPL->B1_DESC, TRBPL->C2_OPMIDO, TRBPL->C2_QUANT+nQuant, dToc(TRBPL->C2_EMISSAO), TRBCS->Z3_M2TOT, TRBCS->Z3_SLDM2, TRBCS->Z3_M2TOT / TRBCS->Z3_SLDM2 ,dtoc(TRBPL->D3_EMISSAO)})
		nCountIt++
		if MV_PAR12 == 1 // Se imprime itens resumido - 1=Sim, 2=Nao
			U_AGF_QRYMTP1("'"+TRBPL->C2_NUM+"'", TRBPL->D3_EMISSAO, dtApIni, dtApFim, nCountIt)
//			dbSelectArea("TRBMP")
//			TRBMP->(dbGotop()) 
				aAdd(aConteud, {"NUMERO OP", "COD.MATERIAL", "DESCRICAO DO PRODUTO", "METROS PADR", "METROS GASTOS", "APROVEITAMENTO"})
			while !TRBMP->(eof())
				aAdd(aConteud, {TRBMP->Z3_NUMOP+"'", Substr(TRBMP->Z3_MATERIA,1,6)+"'", TRBMP->B1_DESC, TRBMP->Z3_M2TOT, TRBMP->Z3_SLDM2, TRBMP->Z3_M2TOT / TRBMP->Z3_SLDM2})
				TRBMP->(dbSkip())
			enddo
//			aAdd(aConteud, {"","","","","","","",""})
			cProd := TRBPL->C2_PRODUTO
			cOps:= cOps+ "'"+TRBPL->C2_NUM+"',"
		endif
	else 
		u_qryCons(nCountIt, "'"+TRBPL->C2_NUM+"'", TRBPL->C2_OPMIDO, TRBPL->D3_EMISSAO, MV_PAR01, MV_PAR02)	
		if cProd <> TRBPL->C2_PRODUTO
			aAdd(aConteud, {Substr(TRBPL->C2_PRODUTO,1,6)+"'", TRBPL->B1_DESC, TRBPL->C2_QUANT +nQuant, TRBCS->Z3_M2TOT, TRBCS->Z3_SLDM2, 0})
		else
			aConteud [len(aConteud),3] += TRBPL->C2_QUANT + nQuant
			aConteud [len(aConteud),4] += TRBCS->Z3_M2TOT
			aConteud [len(aConteud),5] += TRBCS->Z3_SLDM2
		endif
			aConteud [len(aConteud),6] := aConteud [len(aConteud),4] / aConteud [len(aConteud),5]		

		cProd := TRBPL->C2_PRODUTO
		cOps:= cOps+ "'"+TRBPL->C2_NUM+"',"
		if dtApIni > TRBPL->D3_EMISSAO
			dtApIni := TRBPL->D3_EMISSAO
		endif
		if dtApFim < TRBPL->D3_EMISSAO
			dtApFim := TRBPL->D3_EMISSAO
		endif
		
	endif
	
	TRBPL->(dbSkip())
//	if mv_par11 == 1
		if cOldOp <> TRBPL->C2_NUM
			nCountIt:= 0
	//		alert("Contatdor->>> "+cValToChar(nCountIt))
		endif
//	endif
	nQuant:= 0
	while cOldOP == TRBPL->C2_NUM .and. MV_PAR11 == 2
		nQuant+= TRBPL->C2_QUANT	
		TRBPL->(dbSkip())
	enddo
		

	if MV_PAR11 == 2 // se é analitido 1=Sim 2=Nao
		if cProd <> TRBPL->C2_PRODUTO
			if MV_PAR12 == 1
				cOps := Substr(cOps,1,Len(cOPS)-1)
				U_AGF_QRYMTP1(cOPs, TRBPL->D3_EMISSAO, dtApIni, dtApFim, nCountIt)
				aAdd(aConteud, {"COD.MATERIAL", "DESCRICAO DO PRODUTO", "METROS PADR", "METROS GASTOS", "APROVEITAMENTO"})			
//				u_qryCons(nCountIt, "'"+cOPS+"'", TRBPL->C2_OPMIDO, TRBPL->D3_EMISSAO, MV_PAR01, MV_PAR02)	
				dbSelectArea("TRBMP")
				TRBMP->(dbGotop())
				while !TRBMP->(eof())
					aAdd(aConteud, {Substr(TRBMP->Z3_MATERIA,1,6)+"'", TRBMP->B1_DESC, TRBMP->Z3_M2TOT, TRBMP->Z3_SLDM2, TRBMP->Z3_M2TOT / TRBMP->Z3_SLDM2})
					TRBMP->(dbSkip())
				enddo
//				aAdd(aConteud, {"","","","","","","",""})	
				cOps := "" 
				nCountIt := 0
			endif
		endif
	endif
	
enddo
		

//alert('Total de registros...'+cValToChar(nCount))

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Anesio G.Faria -    ³    25.10.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static Function AjustaSX1()

Local aArea := GetArea()
PutSx1(cPerg,"01","Produção de                   ?"," "," ","mv_ch1","D",8,0,0, "G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a data inicial          "},{"Informe a data inicial          "},{"Informe a data inicial           "})
PutSx1(cPerg,"02","Producao ate                  ?"," "," ","mv_ch2","D",8,0,0, "G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a data Final           "},{"Informe a data final            "},{"Informe a data final           "})
PutSx1(cPerg,"03","Plano de                      ?"," "," ","mv_ch3","C",12,0,0,"G","","   ","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o plano inicial  "},{"Informe o plano inicial   "},{"Informe o plano inicial   "})
PutSx1(cPerg,"04","Plano ate                     ?"," "," ","mv_ch4","C",12,0,0,"G","","   ","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o plano final  "},{"Informe o plano final   "},{"Informe o plano final  "})
PutSx1(cPerg,"05","OP Inicial                    ?"," "," ","mv_ch5","C",9,0,0,	"G","","SC2","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a OP inicial     "},{"Informe a OP inicial     "},{"Informe a OP inicial     "})
PutSx1(cPerg,"06","OP Final                      ?"," "," ","mv_ch6","C",9,0,0,	"G","","SC2","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a OP final     "},{"Informe a OP final     "},{"Informe a OP final    "})
PutSx1(cPerg,"07","Material de                   ?"," "," ","mv_ch7","C",15,0,0,"G","","SB1","","","mv_par07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a M.Prima inicial"},{"Informe a M.Prima inicial"},{"Informe a M.Prima inicial"})
PutSx1(cPerg,"08","Material ate                  ?"," "," ","mv_ch8","C",15,0,0,"G","","SB1","","","mv_par08"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o M.Prima final"},{"Informe o M.Prima final"},{"Informe o M.Prima final"})
PutSx1(cPerg,"09","Kit de                        ?"," "," ","mv_ch9","C",15,0,0,"G","","SB1","","","mv_par09"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Kit inicial    "},{"Informe o inicial do Kit  "},{"Informe o inicial do Kit  "})
PutSx1(cPerg,"10","Kit ate                       ?"," "," ","mv_cha","C",15,0,0,"G","","SB1","","","mv_par10"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Kit final    "},{"Informe o final do Kit  "},{"Informe o final do Kit "})
PutSx1(cPerg,"11","Plano analitico               ?"," "," ","mv_chb","N",1,0,2, "C","","   ","","","mv_par11","Analitico","Analitico","Analitico"," ","Sintetico","Sintetico","Sintetico"," "," "," ", " "," "," "," "," ","",{"Analitico / sintetico"},{"Analitico / sintetico"},{"Analitico / sintetico"})
PutSx1(cPerg,"12","Mostrar material              ?"," "," ","mv_chc","N",1,0,2, "C","","   ","","","mv_par12","Sim","Sim","Sim"," ","Nao","Nao","Nao"," "," "," ", " "," "," "," "," ","",{"Imprimir os materiais utilizados"},{"Imprimir os materiais utilizados"},{"Imprimir os materiais utilizados"})
RestArea(aArea)
Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: MDirArq
//|Descricao.: Define Diretório e nome do arquivo a ser gerado
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


user function AGF_QRYTMP()
Local cQuery := ""
/*
cQuery := " Select C2_NUM, C2_OPMIDO, C2_PRODUTO, B1_DESC, D3_QUANT as C2_QUANT , C2_EMISSAO, Z3_DTAPON, "
cQuery += " Sum(Z3_M2TOT) M2TOTPADR, Sum(Z3_SLDM2) M2TOTUSD, D3_EMISSAO "
cQuery += " FROM SZ3010 SZ3,SC2010 SC2, SB1010 SB1, SD3010 SD3 "
cQuery += " Where SZ3.D_E_L_E_T_ <> '*' and SZ3.Z3_FILIAL = '08' and SZ3.Z3_DTAPON   <> '        '  "
cQuery += " and SD3.D_E_L_E_T_ = ' ' and Substring(D3_OP,1,6)= Substring(Z3_NUMOP,1,6) "
cQuery += " and Substring(SC2.C2_NUM,1,6) = Substring(SD3.D3_OP,1,6) "
cQuery += " and SD3.D3_FILIAL = SZ3.Z3_FILIAL "
cQuery += " and SD3.D3_FILIAL = SC2.C2_FILIAL "
cQuery += " and D3_COD between '"+mv_par09+"' and '"+mv_par10+"' "
cQuery += " and SD3.D3_EMISSAO between   '"+dtos(mv_par01)+"' and '"+dtos(mv_par02)+"' " 
cQuery += " and SZ3.Z3_PLANO    >= '"+mv_par03+"' and SZ3.Z3_PLANO   <= '"+mv_par04+"' " 
cQuery += " and SZ3.Z3_NUMOP    >= '"+mv_par05+"' and SZ3.Z3_NUMOP   <= '"+mv_par06+"' "
cQuery += " and SZ3.Z3_MATERIA  >= '"+mv_par07+"' and SZ3.Z3_MATERIA <= '"+mv_par08+"' "
cQuery += " AND SC2.C2_FILIAL = '08'  and SC2.C2_NUM = SZ3.Z3_NUMOP  and C2_PRODUTO = D3_COD and D3_EMISSAO = Z3_DTAPON "
cQuery += " and SC2.C2_ITEM =  SZ3.Z3_ITEM   and SC2.C2_PRODUTO = SB1.B1_COD  and SC2.C2_OPMIDO <> ''  "
cQuery += " AND SC2.D_E_L_E_T_ = ' '  AND SB1.D_E_L_E_T_ = ' '  and SC2.C2_PRODUTO between '"+mv_par09+"' and '"+mv_par10+"' "
cQuery += " group by C2_NUM, C2_OPMIDO, C2_PRODUTO, B1_DESC, D3_QUANT, C2_EMISSAO, D3_EMISSAO, Z3_DTAPON "
*/

cQuery := " Select C2_NUM, C2_OPMIDO, C2_PRODUTO, B1_DESC, D3_QUANT as C2_QUANT , C2_EMISSAO, D3_EMISSAO"
cQuery += " FROM SC2010 SC2, SB1010 SB1, SD3010 SD3 "
cQuery += " Where SD3.D_E_L_E_T_ = ' ' "
cQuery += " and Substring(SC2.C2_NUM,1,6) = Substring(SD3.D3_OP,1,6) "
cQuery += " and SD3.D3_FILIAL = SC2.C2_FILIAL "
cQuery += " and D3_COD between '"+mv_par09+"' and '"+mv_par10+"' "
cQuery += " and SD3.D3_EMISSAO between   '"+dtos(mv_par01)+"' and '"+dtos(mv_par02)+"' " 
cQuery += " and SC2.C2_OPMIDO   >= '"+mv_par03+"' and SC2.C2_OPMIDO  <= '"+mv_par04+"' " 
cQuery += " and SC2.C2_NUM      >= '"+mv_par05+"' and SC2.C2_NUM     <= '"+mv_par06+"' "
//cQuery += " and SZ3.Z3_MATERIA  >= '"+mv_par07+"' and SZ3.Z3_MATERIA <= '"+mv_par08+"' "
cQuery += " AND SC2.C2_FILIAL = '08'  and C2_PRODUTO = D3_COD "
cQuery += " and SC2.C2_PRODUTO = SB1.B1_COD  and SC2.C2_OPMIDO <> ''  "
cQuery += " AND SC2.D_E_L_E_T_ = ' '  AND SB1.D_E_L_E_T_ = ' '  and SC2.C2_PRODUTO between '"+mv_par09+"' and '"+mv_par10+"' "
cQuery += " group by C2_NUM, C2_OPMIDO, C2_PRODUTO, B1_DESC, D3_QUANT, C2_EMISSAO, D3_EMISSAO "


if MV_PAR11 == 1
	cQuery += " order By D3_EMISSAO "
else
	cQuery += " order by C2_PRODUTO, C2_NUM, D3_EMISSAO "
endif

if Select("TRBPL") > 0
	dbSelectArea("TRBPL")
	dbCloseArea()
endif

dbUseArea(.T., "TOPCONN", TCGenQry(, , cQuery), "TRBPL", .F., .T.)

TcSetField("TRBPL", "C2_EMISSAO", "D")
TcSetField("TRBPL", "D3_EMISSAO", "D")
//TcSetField("TRBPL", "Z3_DTAPON", "D")

return

user function AGF_QRYMTP(cOPs,dDtApon, dtApIni, dtApFim, nCountIt)
Local cQryMP := ""
if MV_PAR11 == 1
	cQryMP := " Select Z3_NUMOP, Z3_MATERIA, B1_DESC, SUM(Z3_M2TOT) Z3_M2TOT, SUM(Z3_SLDM2) Z3_SLDM2 "
else
	cQryMP := " Select Z3_MATERIA, B1_DESC, SUM(Z3_M2TOT) Z3_M2TOT, SUM(Z3_SLDM2) Z3_SLDM2 "
endif
cQryMP += " from SZ3010 SZ3, SB1010 SB1 "
cQryMP += " where SB1.D_E_L_E_T_ = ' ' "
cQryMP += " and SZ3.D_E_L_E_T_ = ' ' "
cQryMP += " and B1_COD = Z3_MATERIA "
cQryMP += " and Z3_FILIAL = '"+xFilial("SZ3")+"' "
cQryMP += " and Z3_NUMOP in ("+cOPs+") "          
if MV_PAR11 == 1 
	cQryMP += " and Z3_DTAPON between '"+dtos(dtApIni)+"' and '"+dtos(dtApFim)+"' "
//	cQryMP += " and Z3_DTAPON = '"+dtos(dDtApon)+"' "
else
	cQryMP += " and Z3_DTAPON between '"+dtos(dtApIni)+"' and '"+dtos(dtApFim)+"' "
endif
if MV_PAR11 == 1
	cQryMP += " group by Z3_NUMOP, Z3_MATERIA, B1_DESC "
else
	cQryMP += " group by Z3_MATERIA, B1_DESC "	
endif
if Select("TRBMP") > 0
	dbSelectArea("TRBMP")
	dbCloseArea()
endif


dbUseArea(.T., "TOPCONN", TCGenQry(, , cQryMP), "TRBMP", .F., .T.)



return

user function qryCons(nCountIt, cOPs, NumPlano, dtApon, dtApIni, dtApFim)

Local cQryCons := ""
if MV_PAR11 == 1 // Se é analitico 1=Sim, 2=Nao
	cQryCons := " Select Z3_NUMOP, SUM(Z3_M2TOT) Z3_M2TOT, SUM(Z3_SLDM2) Z3_SLDM2 "
else
	cQryCons := " Select SUM(Z3_M2TOT) Z3_M2TOT, SUM(Z3_SLDM2) Z3_SLDM2 "
endif
cQryCons += " from SZ3010 SZ3 "
cQryCons += " where SZ3.D_E_L_E_T_ = ' ' "
cQryCons += " and Z3_FILIAL = '"+xFilial("SZ3")+"' "
cQryCons += " and Z3_NUMOP in ("+cOPs+") "
if MV_PAR11 == 1 
	if nCountIt == 0
		cQryCons += " and Z3_DTAPON between '"+dtos(DtApon-30)+"' and '"+dtos(DtApon)+"' "
	else
		cQryCons += " and Z3_DTAPON = '"+dtos(DtApon)+"' "
	endif
else
	cQryCons += " and Z3_DTAPON between '"+dtos(dtApIni-30)+"' and '"+dtos(dtApFim)+"' "
endif

if MV_PAR11 == 1
	cQryCons += " group by Z3_NUMOP "
endif

if Select("TRBCS") > 0
	dbSelectArea("TRBCS")
	dbCloseArea()
endif


dbUseArea(.T., "TOPCONN", TCGenQry(, , cQryCons), "TRBCS", .F., .T.)


return