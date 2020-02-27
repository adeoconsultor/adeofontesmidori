#include 'Protheus.ch'
#include "rwmake.ch" 
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "topconn.ch"

#DEFINE PICVAL  "@E 999,999,999.99"

//////////////////////////////////////////////////////////////////////////////////////////
//Programa de averiguação de divergencias entre custo medio dos movimentos
//////////////////////////////////////////////////////////////////////////////////////////
//Pesquisa no parametro MA_VARCUS qual o percentual de variação de custo
//Busca o custo médio do ultimo fechamento B9_CM1, compara com o custo médio atual B2_CM1
//Verifica a variação
//Depois faz uma busca movimento a movimento do item comparando com a variação do custo 
//B2_CM1 da tabela SB2. se tiver a maior do que o permitido no parametro, guarda as informacoes
//num array para depois descarregar num html e enviar via e-mail.
///////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br - 29-11-2011
///////////////////////////////////////////////////////////////////////////

user function AGF_EMVARCUS() //Envio de e-mail com variação de custo
local dMvUlMes 	:= GetMv ('MV_ULMES') //busca o ultimo fechamento ocorrido por filial
local nVarCus   := GetMv ('MA_VARCUS') //busca a variacao de custo permitido  
local cQB2		:= "" //Query para filtrar SB2
local aFiliais  := {}
local aVarB2    := {}
local aVarD1    := {}
local aVarD2    := {}
local aVarD3    := {}
local nItens    := 0
Local i
public nItTot   := 0
public aItens   := {}

aaDD(aFiliais, {'04','08','09','12'} )

//Alert('Iniciando calculo...')
for i:= 1 to len(aFiliais)
	aItens := {}
	if Select("TMPB2") > 0
		dbSelectArea("TMPB2")
		dbCloseArea()
	endif
	
	cQB2 := " SELECT B2_COD, B2_LOCAL, B2_CM1 FROM SB2010 "
	cQB2 += " WHERE D_E_L_E_T_ = ' ' AND B2_FILIAL = '"+aFiliais[i][1]+"' "
	
	dbUseArea(.T.,"TOPCONN", TcGenQry(,,cQB2), "TRBB2",.T.,.T.)
	dbSelectArea("TRBB2")
	dbGotop()
	while !TRBB2->(eof())
		U_FiltraB9B2(TRBB2->B2_COD, TRBB2->B2_LOCAL, dMvUlMes, nVarCus, TRBB2->B2_CM1, aFiliais[i][1])
		U_FiltraD1(TRBB2->B2_COD, TRBB2->B2_LOCAL, dMvUlMes, nVarCus, TRBB2->B2_CM1, aFiliais[i][1])
		U_FiltraD2(TRBB2->B2_COD, TRBB2->B2_LOCAL, dMvUlMes, nVarCus, TRBB2->B2_CM1, aFiliais[i][1])
		U_FiltraD3(TRBB2->B2_COD, TRBB2->B2_LOCAL, dMvUlMes, nVarCus, TRBB2->B2_CM1, aFiliais[i][1])
		TRBB2->(dbSkip())
	enddo                          
 
//	Alert('Funcoes geradas...')//+cValToChar(nItens)+' itens por funcao: '+cValToChar(nItTot))
	U_GerEmail(aItens, aFiliais[i][1])
//	U_GerExcel(aItens)
next i


return


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
user function FiltraB9B2(cCod, cLocal, dMvUlMes, nVarCus, nCMAtu, _cfilial) 
local cQB9B2 	:= "" // Query que vai fazer o comparativo de custo entre B9 e B2
local _cCod 	:= cCod
local _cLocal 	:= cLocal
local _dMvUlMes := dMvUlMes
local _nVarCus  :=  (nVarCus / 100)
local _nCMAtu   := nCMAtu

If Select("TRBB9") > 0
	DbSelectArea("TRBB9")
	DbCloseArea()
Endif


cQB9B2:= " SELECT B9_COD, B9_LOCAL, B9_DATA, B9_QINI, B9_CM1, B2_QFIM, B2_LOCAL, B2_QATU, B2_CM1 "
cQB9B2+= " FROM SB9010 SB9, SB2010 SB2 "
cQB9B2+= " WHERE SB2.D_E_L_E_T_ =' '  AND SB9.D_E_L_E_T_ = ' ' "
cQB9B2+= " AND B2_FILIAL = B9_FILIAL AND B2_COD = B9_COD "
cQB9B2+= " AND B2_LOCAL = B9_LOCAL AND B2_FILIAL = '"+_cFilial+"' AND B9_FILIAL = '"+_cFilial+"' " 
cQB9B2+= " AND B9_DATA = '"+dtos(_dMvUlMes)+"' "
cQB9B2+= " AND B9_COD = '"+_cCod+"' AND B9_LOCAL = '"+_cLocal+"' AND SUBSTRING(B2_COD,1,3) <> 'MOD' "
cQB9B2+= " AND B9_CM1 <> 0 AND B9_QINI > 0  "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQB9B2),"TRBB9",.T.,.T.)

TcSetField("TRBB9", "B9_DATA", "D")

dbSelectArea("TRBB9")
dbGotop()
while !TRBB9->(eof())

	if (1-(TRBB9->B9_CM1 / nCMAtu)) > _nVarCus .or. (1-(TRBB9->B9_CM1 / nCMAtu)) < (_nVarCus * -1)
		aaDD(aItens, {TRBB9->B9_COD, Posicione("SB1",1,xFilial("SB1")+TRBB9->B9_COD, "B1_DESC"),;
						"FECHAMENTO", dtoc(TRBB9->B9_DATA), TRBB9->B9_LOCAL, "FEC", "FECHAMENTO",;
						TRBB9->B9_QINI, nCMAtu, TRBB9->B9_CM1, 1- (nCMAtu / TRBB9->B9_CM1)})

						nItTot++
	endif
	TRBB9->(dbSkip())
enddo

return 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
user function FiltraD1(cCod, cLocal, dMvUlMes, nVarCus, nCMAtu, _cfilial) 
local cQD1   	:= "" // Query que var fazer o filtro do produto na tabela SD1
local _cCod 	:= cCod
local _cLocal 	:= cLocal
local _dMvUlMes := dMvUlMes
local _nVarCus  :=  (nVarCus / 100)
local _nCMAtu   := nCMAtu
public aVarD1  := {}

If Select("TRBD1") > 0
	DbSelectArea("TRBD1")
	DbCloseArea()
Endif


cQD1 := " SELECT D1_DOC, D1_COD, D1_X_DESCR, D1_LOCAL, D1_TES, D1_QUANT, D1_CUSTO / D1_QUANT AS CUSTOUNI, D1_EMISSAO "
cQD1 += " FROM SD1010 SD1, SF4010 SF4 " 
cQD1 += " WHERE SD1.D_E_L_E_T_ =' ' AND SF4.D_E_L_E_T_ = ' ' "
cQD1 += " AND D1_FILIAL = '"+_cfilial+"' " //AND F4_FILIAL = '"+_cfilial+"' "  - Comentado por ter unificado as TES
cQD1 += " AND D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' "
cQD1 += " AND D1_COD = '"+_cCod+"' AND D1_LOCAL = '"+_cLocal+"' "          
cQD1 += " AND D1_EMISSAO > '"+dTos(_dMvUlMes)+"' AND D1_QUANT > 0 AND SUBSTRING(D1_COD,1,3) <> 'MOD' " 

dbUseArea(.T., "TOPCONN", TcGenQry(,,cQD1),"TRBD1",.T.,.T.)

TcSetField("TRBD1", "D1_EMISSAO", "D")

dbSelectArea("TRBD1")
dbGotop()
while !TRBD1->(eof())
	if (1-(TRBD1->CUSTOUNI / nCMAtu)) > _nVarCus .or. (1-(TRBD1->CUSTOUNI / nCMAtu)) < (_nVarCus * -1)
		aaDD(aItens, {TRBD1->D1_COD, Posicione("SB1",1,xFilial("SB1")+TRBD1->D1_COD, "B1_DESC"),;
						TRBD1->D1_DOC, dtoc(TRBD1->D1_EMISSAO), TRBD1->D1_LOCAL, TRBD1->D1_TES, "ENTRADA",;
						TRBD1->D1_QUANT, nCMAtu, TRBD1->CUSTOUNI, 1- (nCMAtu / TRBD1->CUSTOUNI)})

						nItTot++						
	endif
	TRBD1->(dbSkip())
enddo
return 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
user function FiltraD2(cCod, cLocal, dMvUlMes, nVarCus, nCMAtu, _cfilial) 
local cQD2   	:= "" // Query que var fazer o filtro do produto na tabela SD2
local _cCod 	:= cCod
local _cLocal 	:= cLocal
local _dMvUlMes := dMvUlMes
local _nVarCus  := (nVarCus / 100)
local _nCMAtu   := nCMAtu
public aVarD2  := {}

If Select("TRBD2") > 0
	DbSelectArea("TRBD2")
	DbCloseArea()
Endif


cQD2 := " Select D2_DOC, D2_SERIE, D2_COD, D2_TES, D2_QUANT, D2_PRCVEN, D2_TOTAL, D2_LOCAL, D2_CUSTO1 / D2_QUANT AS CUSTOUNI, D2_EMISSAO "
cQD2 += " FROM SD2010 where D_E_L_E_T_ =' ' "
cQD2 += " AND D2_FILIAL = '"+_cfilial+"' AND D2_COD = '"+_cCod+"' AND D2_LOCAL = '"+_cLocal+"' " 
cQD2 += " AND D2_EMISSAO > '"+dTos(_dMvUlMes)+"' AND D2_QUANT > 0 AND SUBSTRING(D2_COD,1,3) <> 'MOD' " 

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQD2), "TRBD2", .T.,.T.)

TcSetField("TRBD2", "D2_EMISSAO", "D")

dbSelectArea("TRBD2")
dbGotop()
while !TRBD2->(eof())
	if (1-(TRBD2->CUSTOUNI / nCMAtu)) > _nVarCus .or. (1-(TRBD2->CUSTOUNI / nCMAtu)) < (_nVarCus * -1)
//		alert('Custo uni '+cValTochar(TRBD2->CUSTOUNI)+' nVarCus-> '+cValToChar(_nVarCus)+' Custo Medio-> '+cValToChar(nCMAtu))
		aaDD(aItens, {TRBD2->D2_COD, Posicione("SB1",1,xFilial("SB1")+TRBD2->D2_COD, "B1_DESC"),;
						TRBD2->(D2_DOC+'-'+D2_SERIE), dtoc(TRBD2->D2_EMISSAO), TRBD2->D2_LOCAL, TRBD2->D2_TES, "SAIDA",;
						TRBD2->D2_QUANT, nCMAtu, TRBD2->CUSTOUNI, 1-(nCMAtu / TRBD2->CUSTOUNI)})

						nItTot++
	endif
	TRBD2->(dbSkip())
enddo

return 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
user function FiltraD3(cCod, cLocal, dMvUlMes, nVarCus, nCMAtu, _cfilial) 
local cQD3   	:= "" // Query que var fazer o filtro do produto na tabela SD3
local _cCod 	:= cCod
local _cLocal 	:= cLocal
local _dMvUlMes := dMvUlMes
local _nVarCus  := (nVarCus / 100)
local _nCMAtu   := nCMAtu
public aVarD3  := {}

If Select("TRBD3") > 0
	DbSelectArea("TRBD3")
	DbCloseArea()
Endif

cQD3 := " SELECT D3_TM, D3_CF, D3_COD, D3_QUANT, (D3_CUSTO1 / D3_QUANT) AS CUSTOUNI, D3_LOCAL, D3_DOC, D3_OP, D3_EMISSAO " 
cQD3 += " FROM SD3010 WHERE D_E_L_E_T_ = ' ' " 
cQD3 += " AND D3_FILIAL = '"+_cfilial+"' AND D3_COD = '"+_cCod+"' AND D3_LOCAL = '"+_cLocal+"' " 
cQD3 += " AND D3_EMISSAO > '"+dTos(_dMvUlMes)+"' AND D3_QUANT > 0 AND SUBSTRING(D3_COD,1,3) <> 'MOD' " 

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQD3), "TRBD3",.T.,.T.)

TcSetField("TRBD3", "D3_EMISSAO", "D")

dbSelectArea("TRBD3")
dbGotop()
while !TRBD3->(eof())
	if (1 - (TRBD3->CUSTOUNI / nCMAtu )) > _nVarCus .or. (1-(TRBD3->CUSTOUNI / nCMAtu)) < (_nVarCus * -1)
//	if (TRBD3->CUSTOUNI * _nVarCus) > nCMAtu .or. (TRBD3->CUSTOUNI / _nVarCus) < nCMAtu
//		alert('Custo uni '+cValTochar(TRBD3->CUSTOUNI)+' nVarCus-> '+cValToChar(_nVarCus)+' Custo Medio-> '+cValToChar(nCMAtu))
//		alert(' Primeira comparacao-> '+cValToChar((1 - (nCMAtu / TRBD3->CUSTOUNI)))+' Segunda Comparacao-> '+cValToChar(((TRBD3->CUSTOUNI / nCMAtu)-1)))
		aaDD(aItens, {TRBD3->D3_COD, Posicione("SB1",1,xFilial("SB1")+TRBD3->D3_COD, "B1_DESC"),;
						TRBD3->D3_DOC, dtoc(TRBD3->D3_EMISSAO), TRBD3->D3_LOCAL, TRBD3->D3_TM, TRBD3->D3_OP,;
						TRBD3->D3_QUANT, nCMAtu, TRBD3->CUSTOUNI, 1-(nCMAtu / TRBD3->CUSTOUNI)})

						nItTot++
	endif
	TRBD3->(dbSkip())
enddo


return 




/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Função que estará gerando os e-mails por filial...
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
user function GerEmail(aItens, _cFilial)
local _cEmails  := 'agfaria@taggs.com.br'
local oProcess 
local oHtml,i
local nCount := 0




//RpcSetEnv("01",_cFilial,"","","","",{"SB1","SD1","SD2","SD3","SF4"})
SETMV("MV_WFMLBOX","WORKFLOW") 
oProcess := TWFProcess():New( "000003", "Itens com variação de custo" )
oProcess :NewTask( "VARIACAO DE CUSTO", "\WORKFLOW\HTM\VARCUSTO.HTM" )
oHtml    := oProcess:oHTML
//alert('Iniciando geracao do e-mail')
for i:=1 to len(aItens)

   	 aAdd( oHtml:ValByName( "it.cod"     ), aItens[i][1])
   	 aAdd( oHtml:ValByName( "it.descr"   ), aItens[i][2])
   	 aAdd( oHtml:ValByName( "it.doc"     ), aItens[i][3])
   	 aAdd( oHtml:ValByName( "it.data"    ), aItens[i][4])
   	 aAdd( oHtml:ValByName( "it.local"   ), aItens[i][5])
   	 aAdd( oHtml:ValByName( "it.tm"      ), aItens[i][6])
   	 aAdd( oHtml:ValByName( "it.origem"  ), aItens[i][7])
   	 aAdd( oHtml:ValByName( "it.qtde"    ), cValToChar(aItens[i][8] ))
   	 aAdd( oHtml:ValByName( "it.custmed" ), cValToChar(aItens[i][9] ))// picture "@E 9,999,999.9999"))
   	 aAdd( oHtml:ValByName( "it.custmov" ), cValToChar(aItens[i][10]))// picture "@E 9,999,999.9999"))
   	 aAdd( oHtml:ValByName( "it.variacao"), cValToChar(aItens[i][11]))// picture "@E 999.9999%"))
   	 nCount++
   	 if nCount > 50
   	 	i:= len(aItens)
   	 endif
next i                                
oProcess:cSubject := "Itens com variacao de custo acima da media em " + dToc(dDatabase) + " ref.filial "+_cFilial


//Alert('E-mail montado...iniciando envio....'+ cValToChar(nCount))
	oProcess:cTo      := _cEmails


oProcess:Start()                    
	       //WFSendMail()
	       //WFSendMail()	       
oProcess:Finish()


//Alert('E-mail enviado...')
Return

/////////////////////////////////////////////////////////////////////////////////////////////
user function GerExcel(aItens)

Private cPerg   := "AGF_KDXP2"
Private aConteud    := {}       
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab        := "" 

aDir := MDirArq()
//AjustaSx1()

If Empty(aDir[1]) .OR. Empty(aDir[2])
	Return
Else                      
		//Processa({ || AGF_KDXQRY()}, 'Gerando informacoes...')
//		aConteud := aItens

		Processa({ || lOk := MCVS(aItens,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif

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



