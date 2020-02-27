#include 'Protheus.ch'
#include 'rwmake.ch'

#DEFINE PICVAL  "@E 999,999,999.99"
///////////////////////////////////////////////////////////////////////////////////////
//Função para fazer o calculo do kardex de icms
//desenvolvido por Anesio G.Faria - anesio@outlook.com - 14/07/2014
///////////////////////////////////////////////////////////////////////////////////////
user function AG_KDXICM()
local cPerg := ""

Private cPerg   := "KDXICM"
if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
endif
Pergunte(cPerg,.T.)      


processa ({|| AG_KDXICM(), "Calculando Kardex de ICMS"})

return

///////////////////////////////////////////////////////////////////////////////////////
//Função para filtrar produtos da SB1
static function AG_KDXICM()
local cQuery   := ""
local cQB9     := "" 
local cDtCalc  := ""
local cDtAnt   := "" 
local aSldAnt  := {}
local aB9D1    := {}
public aDadosG := {} 
cDtCalc:= mv_par02+mv_par01
cDtAnt := AjustDt(cDtCalc)
/*
//Busca movimentacao do fechamento de estoque
//aSldAnt := BuscaB9(cDtAnt)
//Busca movimentacao das entradas de mercadoria
//aMovD1  := BuscaD1(cDtCalc) */

//Busca Totalizador de Saldo Inicial + Entradas no periodo
aB9D1 := BuscaB9D1(cDtCalc, cDtAnt)

//if ApMsgNoYes("Deseja gerar SB9 + SD1 em Excel ? ", "ATENCAO SB9 + SD1!!!!")
//	GEREXCEL(aB9D1)
//endif

//Busca as movimentacoes internas dos produtos
//aMovD3  := BuscaD3(cDtCalc)


//if ApMsgNoYes("Deseja gerar SD3 em Excel ? ", "ATENCAO SB9 + SD1!!!!")
//	GEREXCEL(aMovD3)
//endif

MVD3ORINF(aB9D1, cDtCalc, cDtAnt)

aTIPO := TPMOV(cDtCalc)

D3MOVCF(aTIPO, cDtCalc)

/*
cQuery := " SELECT B1_COD, B1_TIPO, B1_CODLAN FROM "+RetSQLNAME("SB1")+ " SB1 "
cQuery += " WHERE B1_FILIAL= '"+xFilial("SB1")+"' " 
cQuery += "	AND D_E_L_E_T_ = ' ' " 
cQuery += " AND B1_TIPO IN ('MP','EM','PI','PA','PP','ME','MO', 'OI', 'GG', 'MC', 'MT', 'SP') " 
cQuery += " ORDER BY 1,2 " 

if Select("TMPB1") > 0 
	dbSelectArea("TMPB1")
	TMPB1->(dbCloseArea())
endif
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPB1", .T., .T. )

//Fazer a contagem do total de registros...
for i:=1 to len(cQuery)
	if substr(cQuery,i,5)=="ORDER"
		cQuery := Substr(cQuery,1, i-1)
		i:=len(cQuery)
	endif
next i
cQCount:= " SELECT COUNT(*) NREG FROM ("+cQuery+") QCOUNT " 
if Select("TMCNT") > 0 
	dbSelectArea("TMCNT")
	TMCNT->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQCount), "TMCNT", .T., .T. )

nRegB1 := 0
dbSelectArea("TMCNT")
TMCNT->(dbGotop())
while !TMCNT->(eof())
	nRegB1 += TMCNT->NREG	
	TMCNT->(dbSkip())
enddo

nCount := 0  */






//for i:= 1 to 5
//	Alert("PRODUTO->" +aSldAnt[i][1]+"|")
//next i 

/*dbSelectArea("TMPB1")
TMPB1->(dbGotop())
while !TMPB1->(eof())
	nCount++
//	nPosB9 := aScan(aSldAnt, {|x| x[1] == TMPB1->B1_COD } )
//	nPosD1 := aScan(aMovD1 , {|x| x[1] == TMPB1->B1_COD } )
	nPosB9 := aScan(aB9D1,   {|x| x[1] == TMPB1->B1_COD } )
	nPosD3 := aScan(aMovD3 , {|x| x[1] == TMPB1->B1_COD } )
//	Processa( {|| CalcICM(@aSldAnt, @aMovD1, @aMovD3, nPosB9, nPosD1, nPosD3) }, "Calculando Array...")
	CalcICM(@aSldAnt, @aMovD1, @aMovD3, nPosB9, nPosD1, nPosD3)
	incProc("Analisando código "+AllTrim(TMPB1->B1_COD)+" REG: "+cValToChar(nCount)+"/"+cValToChar(nRegB1) ) 
	TMPB1->(dbSkip())
enddo
if ApMsgYesNo("Deseja gerar a informacao em Excel? ", "Atenção!!!!!")
	GEREXCEL(aDadosG)
endif */
return

///////////////////////////////////////////////////////////////////////////////////////
//Função para gerar parameto de perguntas
Static Function AjustaSX1()
Local	aHelpPor := {}
Local	aHelpEng := {}
Local	aHelpSpa := {}
Local 	nTamSx1Grp :=Len(SX1->X1_GRUPO)

dbSelectArea("SX1")
dbSetOrder(1)

aHelpPor :={}
aHelpEng :={}
aHelpSpa :={}
Aadd (aHelpPor, "mes de apuracao." ) //"mes de apuracao." 
aHelpEng := aHelpSpa := aHelpPor
PutSx1("KDXICM","01","mes de apuracao.","mes de apuracao.","mes de apuracao.","mv_ch1","C",2,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)	

aHelpPor :={} 
aHelpEng :={} 
aHelpSpa :={} 
Aadd( aHelpPor, "ano de apuracao") //"ano de apuracao"
aHelpEng := aHelpSpa := aHelpPor
PutSx1("KDXICM","02","ano de apuracao","ano de apuracao","ano de apuracao","mv_ch2","C",4,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return NIL

/*
///////////////////////////////////////////////////////////////////////////////////////
//Função para buscar o saldo inicial do Kardex de ICMS
static function BuscaB9(cDtCalc)
local cQB9   := ""
local aSaldo := {}
cQB9 := " SELECT B9_COD, B9_LOCAL, B9_X_ICMSI, B9_QINI, B9_VINI1 FROM "+RetSQLNAME("SB9")
cQB9 += " WHERE D_E_L_E_T_ =' ' AND B9_FILIAL = '"+xFilial("SB9")+"' "
//cQB9 += " AND B9_COD < '010000' "
cQB9 += " AND Substring(B9_DATA,1,6) = '"+cDtCalc+"' "
cQB9 += " ORDER BY 1, 2 " 

cQB9 := ChangeQuery(cQB9)
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQB9), "TMPB9", .T., .T. ) 


//Fazer a contagem dos registros para mostrar na regua
for i:=1 to len(cQB9)
	if substr(cQB9,i,5)=="ORDER"
		cQB9 := Substr(cQB9,1, i-1)
		i:=len(cQB9)
	endif
next i
cQCount:= " SELECT COUNT(*) NREG FROM ("+cQB9+") QCOUNT " 
if Select("TMCNT") > 0 
	dbSelectArea("TMCNT")
	TMCNT->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQCount), "TMCNT", .T., .T. )
nRegB9 := 0
dbSelectArea("TMCNT")
TMCNT->(dbGotop())
while !TMCNT->(eof())
	nRegB9 += TMCNT->NREG
	TMCNT->(dbSkip())
enddo

procRegua(0)
dbSelectArea("TMPB9")
nCount := 0
TMPB9->(dbGotop())
while !TMPB9->(eof())
	nCount++
	//				  CODIGO         LOCAL            QTDE INIC     VLR INICIAL         VALOR ICMS
	//                  01             02                 03            04                  05
	Aadd( aSaldo, {TMPB9->B9_COD, TMPB9->B9_LOCAL, TMPB9->B9_QINI, TMPB9->B9_VINI1, TMPB9->B9_X_ICMSI } )
	incProc("Gravando Saldo SB9 "+alltrim(TMPB9->B9_COD)+" ARMZ:"+TMPB9->B9_LOCAL+" REG "+cValToChar(nCount)+"/"+cValToChar(nRegB9))
	TMPB9->(dbSkip())
enddo
//Alert("Registrado "+cValToChar(nCount) +" produtos")
return aSaldo */

/*
///////////////////////////////////////////////////////////////////////////////////////
//Função para buscar as entradas ocorridas no periodo
static function BuscaD1(cDtCalc)
local cQD1   := "" 
local aDados := {}

cQD1 := " SELECT D1_COD, D1_LOCAL, D1_NUMSEQ, D1_QUANT, D1_CUSTO, D1_VALICM, FT_BASEICM, FT_VALICM " 
cQD1 += " from "+RetSqlName("SD1")+" SD1, "+RetSqlName("SFT")+" SFT " 
cQD1 += " WHERE SD1.D_E_L_E_T_ =' ' and SFT.D_E_L_E_T_ =' ' "
cQD1 += " AND D1_FILIAL = '"+xFilial("SD1")+"' AND FT_FILIAL = '"+xFilial("SFT")+"' " 
cQD1 += " and D1_DOC = FT_NFISCAL and D1_SERIE = FT_SERIE "
cQD1 += " AND D1_FORNECE = FT_CLIEFOR AND D1_LOJA = FT_LOJA "
cQD1 += " AND D1_FILIAL = FT_FILIAL AND FT_TIPOMOV = 'E' " 
cQD1 += " and D1_COD = FT_PRODUTO AND D1_ITEM = FT_ITEM "
cQD1 += " and D1_TP IN ('MP','EM','PI','PA','PP','ME','MO', 'OI', 'GG', 'MC', 'MT', 'SP') " 
cQD1 += " and Substring(D1_COD,1,3) <> 'MOD' " 
cQD1 += " and FT_BASEICM > 0 "
cQD1 += " and Substring(D1_EMISSAO,1,6)='"+cDtCalc+"' " 
cQD1 += " Order by 1, 2, 3 " 

if Select("TMPD1") > 0
	dbSelectArea("TMPD1")
	TMPD1->(dbCloseArea())
endif

cQD1 := ChangeQuery(cQD1)
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQD1), "TMPD1", .T., .T.)

//Fazer a contagem do total de registros para mostrar na regua...
for i:=1 to len(cQD1)
	if substr(cQD1,i,5)=="ORDER"
		cQD1 := Substr(cQD1,1, i-1)
		i:=len(cQD1)
	endif
next i
cQCount:= " SELECT COUNT(*) NREG FROM ("+cQD1+") QCOUNT " 
if Select("TMCNT") > 0 
	dbSelectArea("TMCNT")
	TMCNT->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", tcGenQry(, , cQCount), "TMCNT", .T., .T. )
nRegD1 := 0
dbSelectArea("TMCNT")
TMCNT->(dbGotop())
while !TMCNT->(eof())
	nRegD1 += TMCNT->NREG
	TMCNT->(dbSkip())
enddo

dbSelectArea("TMPD1")
TMPD1->(dbGotop())
ProcRegua(0)
nCount := 0
while !TMPD1->(eof())
	nCount++
	//                CODIGO           ARMAZEM          NUMSEQ            QTDE             BASE ICM           VALOR ICM
	//                  01                02              03               04                 05                  06
	AADD( aDados, {TMPD1->D1_COD, TMPD1->D1_LOCAL, TMPD1->D1_NUMSEQ, TMPD1->D1_QUANT, TMPD1->FT_BASEICM, TMPD1->FT_VALICM })
	incProc("Add.entradas produto "+ALLTRIM(TMPD1->D1_COD)+" ARMZ: "+TMPD1->D1_LOCAL+" SEQ: "+TMPD1->D1_NUMSEQ+" REG: "+cValToChar(nCount)+"/"+cValToChar(nRegD1) )
	TMPD1->(dbSkip())
enddo
//Alert("Registrado "+cValToChar(nCount)+" lançamentos " )
return aDados */
///////////////////////////////////////////////////////////////////////////////////////
//Função para buscar as movimentacoes internas ocorridas no periodo
static function BuscaD3(cDtCalc)
local cQD3   := ""
local aDados := {}
Local i

cQD3 := " Select D3_COD, D3_TIPO, D3_LOCAL, D3_NUMSEQ, D3_CF, D3_QUANT, D3_CUSTO1, R_E_C_N_O_ NUMRECNO "
cQD3 += " from "+RetSqlName("SD3")+" SD3 " 
cQD3 += " where D_E_L_E_T_ = ' ' and D3_FILIAL ='"+xFilial("SD3")+"' " 
cQD3 += " and Substring(D3_EMISSAO,1,6)='"+cDtCalc+"' " 
cQD3 += " and D3_TIPO in ('MP','EM','PI','PA','PP','ME','MO', 'OI', 'GG', 'MC', 'MT', 'SP')  " 
//cQD3 += " AND D3_TIPO = 'OI' " //Retirar essa linha ao final...apenas para testes....
cQD3 += " and Substring(D3_COD,1,3) <>'MOD' AND D3_ESTORNO <> 'S' " 
cQD3 += " order by 1, 4, 3, 5 " 

if Select("TMPD3")>0
	dbSelectArea("TMPD3")
	TMPD3->(dbSkip())
endif

cQD3 := ChangeQuery(cQD3)

dbUseArea(.T., "TOPCONN", tcGenQry(, , cQD3), 'TMPD3', .T., .T. )

//Fazer a contagem do total de registros para mostrar na regua...
for i:=1 to len(cQD3)
	if substr(cQD3,i,5)=="ORDER"
		cQD3 := Substr(cQD3,1, i-1)
		i:=len(cQD3)
	endif
next i
cQCount:= " SELECT COUNT(*) NREG FROM ("+cQD3+") QCOUNT " 
if Select("TMCNT") > 0 
	dbSelectArea("TMCNT")
	TMCNT->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", tcGenQry(, , cQCount), "TMCNT", .T., .T. )

nRegD3 := 0
dbSelectArea("TMCNT")
TMCNT->(dbGotop())
while !TMCNT->(eof())
	nRegD3 += TMCNT->NREG
	TMCNT->(dbSkip())
enddo


dbSelectArea("TMPD3")
TMPD3->(dbGotop())
ProcRegua(0)
nCount := 0
while !TMPD3->(eof())
	nCount++
	//                CODIGO           ARMAZEM          NUMSEQ         CODFISCAL       QTDE             CUSTO           R_E_C_N_O_
	//                  01                02              03               04           05                06                07
	AADD(aDados, {TMPD3->D3_COD, TMPD3->D3_LOCAL, TMPD3->D3_NUMSEQ, TMPD3->D3_CF, TMPD3->D3_QUANT, TMPD3->D3_CUSTO1, TMPD3->NUMRECNO} )
	incProc("Add.mov.int.produto "+ALLTRIM(TMPD3->D3_COD)+" ARMZ: "+TMPD3->D3_LOCAL+" NUMSEQ: "+TMPD3->D3_NUMSEQ+" REG: "+cValToChar(nCount)+"/"+cValToChar(nRegD3))
	TMPD3->(dbSkip())
enddo

return aDados
///////////////////////////////////////////////////////////////////////////////////////
//Função para buscar as vendas ocorridas no perido
static function BuscaD2(cDtCalc)


return aDados

/*
///////////////////////////////////////////////////////////////////////////////////////
//Função para calcular o custo de ICMS
static function CalcICM(aSldAnt, aMovD1, aMovD3, nPosB9, nPosD1, nPosD3)
local aDados    := {}


//Verifica se existe lançamento na SB9 e processa os custos iniciais
//adicionando no array aDados para posteriormente efetuar a média...
if nPosB9 > 0 //
	cCod := aSldAnt[nPosB9][1]
	for nX := nPosB9 to len(aSldAnt)
		if aSldAnt[nX][1] ==  cCod
			//				  CODIGO         LOCAL               QTDE         VALOR            VALOR ICMS  VLR UNIT ICM    ORIGEM
			//                  01             02                 03            04                  05           06          07
			AADD(aDados, {aSldAnt[nX][1], aSldAnt[nX][2], aSldAnt[nX][3], aSldAnt[nX][4], aSldAnt[nX][5],        0       , "SB9"  } )
		else
			nX := Len(aSldAnt)
		endif
	next nX
	
	//Se houver informação dentro do SB9, processa no mesmo bloco o array 
	//com as informacoes das entradas SD1
	if nPosD1 > 0 
		cCod := aMovD1[nPosD1][1]
		for nX := nPosD1 to Len(aMovD1)
			if cCod == aMovD1[nPosD1][1] 
				//Verifica se já tem a informacao gravada no array aDados e grava o valor no nPos
				//Se não existir faz um novo lançamento no array, caso exista, adiciona na informação já existente
				nPos := aScan( aDados, {|x| x[1]+x[2] == aMovD1[nPosD1][1]+aMovD1[nPosD1][2] })
				if nPos == 0
					//				  CODIGO         LOCAL          QTDE           VALOR      VALOR ICMS       VLR UNIT ICM   ORIGEM
					//                  01             02            03              04           05
					AADD(aDados, {aMovD1[nX][1], aMovD1[nX][2], aMovD1[nX][4], aMovD1[nX][5], aMovD1[nX][6],         0       ,  "SD1" } )
				else
			        aDados[nPos][3] += aMovD1[nX][4]
			        aDados[nPos][4] += aMovD1[nX][5]
			        aDados[nPos][5] += aMovD1[nX][6]
			        if aDados[nPos][7] == "SB9"
				        aDados[nPos][7] := "SB9 SD1"
					endif
				endif
			else
				nPosD1 := len(aMovD1)
			endif

		next nX

	endif

//Se não existir informações nos saldos iniciais, pula para analisar as entradas de notas na SD1
elseif nPosD1 > 0 
	cCod := aMovD1[nPosD1][1]
	for nX := nPosD1 to Len(aMovD1)
		if cCod == aMovD1[nPosD1][1]
			nPos := aScan( aDados, {|x| x[1]+x[2] == aMovD1[nPosD1][1]+aMovD1[nPosD1][2] })
			if nPos == 0
				//				  CODIGO         LOCAL          QTDE           VALOR      VALOR ICMS       VLR UNIT ICM   ORIGEM
				//                  01             02            03              04           05                06          07
				AADD(aDados, {aMovD1[nX][1], aMovD1[nX][2], aMovD1[nX][4], aMovD1[nX][5], aMovD1[nX][6],         0      ,  "SD1"} )
			endif
		else
			nPosD1 := len(aMovD1)
		endif

	next nX
endif

for i:= 1 to len(aDados)
	AADD(aDadosG, {aDados[i][1], aDados[i][2], aDados[i][3], aDados[i][4], aDados[i][5], aDados[i][6], aDados[i][7]} )
next i
//condicao teste para gerar a informacao em excel antes de iniciar os rateios
//if ApMsgYesNo("Deseja gerar a informacao em Excel? ", "Atenção!!!!!")
//	GEREXCEL(aDados)
//endif
//Após analisar os Saldos Iniciais SB9 e entradas SB1, analisa os movimentos da tabela SD3
//movimentos internos (entradas e saidas)
if nPosD3 > 0
	for nX := nPosD3 to len(aMovD3)
	
	
	next nX
endif

return aDados
//nPosB9 := aScan(aSldAnt, {|x| x[1] == SB1->B1_COD } )
//nPosD1 := aScan(aMovD1 , {|x| x[1] == SB1->B1_COD } )
//nPosD3 := aScan(aMovD3 , {|x| x[1] == SB1->B1_COD } )
//Processa( {|| CalcICM(@aSldAnt, @aMovD1, @aMovD3, nPosB9, nPosD1, nPosD3) }, "Calculando Array...")

*/

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para ajustar a data selecionada para o mes anterior com objetivo de pegar o ultimo fechamento do mes.
//Desenvolvido por Anesio - 10/07/2014
static function AjustDt(cDtAjust)
local _cDtAjust := ""
local cAno := ""
local cMes := ""

if Substr(cDtAjust,5,2) == "01" 
	cMes := "12"
	cAno := str(val(Substr(cDtAjust,1,4))-1)
else
	cMes := str(val(Substr(cDtAjust,5,2))-1)
	if len(cMes) == 1
		cMes := "0"+cMes
	endif
	cAno := Substr(cDtAjust,1,4)
endif

_cDtAjust := alltrim(cAno)+alltrim(cMes)

return _cDtAjust

///////////////////////////////////////////////////////////////////////////////////////
//Função para gerar o resultado em EXCEL
static function GEREXCEL(aConteud)
//Private aConteud:= {}       
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab        := "" 

///if APMsgNoYes("Deseja Gerar para Excel", "Gerar Excel")
	aDir := MDirArq()
	If Empty(aDir[1]) .OR. Empty(aDir[2])
		Return
	Else                      
		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif


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

return

////////////////////////////////////////////////////////////////////////////////
//Funcao que vai identificar o indice ICMS a ser usado no mes
//baseado no saldo da SB9 + as entradas de SD1
static function BuscaB9D1(cDtAtu, cDtAnt)
local aDados := {}
local cQuery := "" 

cQuery := "  SELECT CODPRO, ARMZ, QUANT, VLRBASE, VLRICM, CASE VLRBASE 	when 0 then 0 else VLRICM / VLRBASE end NINDEX from " 
cQuery += " ( SELECT CODPRO, ARMZ, SUM(QUANT) QUANT, SUM(VLRBASE) VLRBASE, SUM(VLRICM) VLRICM FROM "
cQuery += " (SELECT D1_COD CODPRO, D1_LOCAL ARMZ, Sum(D1_QUANT) QUANT, Sum(FT_BASEICM) VLRBASE, Sum(FT_VALICM) VLRICM "
cQuery += " from "+RetSqlName("SD1")+" SD1 , "+RetSqlName("SFT")+" SFT "
cQuery += " 	WHERE SD1.D_E_L_E_T_ =' ' and SFT.D_E_L_E_T_ =' ' "
cQuery += " 	AND D1_FILIAL = '"+xFilial("SD1")+"' AND FT_FILIAL = '"+xFilial("SFT")+"' "
cQuery += " 	and D1_DOC = FT_NFISCAL and D1_SERIE = FT_SERIE "
cQuery += " 	AND D1_FORNECE = FT_CLIEFOR AND D1_LOJA = FT_LOJA  "
cQuery += " 	AND D1_FILIAL = FT_FILIAL AND FT_TIPOMOV = 'E' "
cQuery += " 	and D1_COD = FT_PRODUTO AND D1_ITEM = FT_ITEM "
cQuery += " 	and D1_TP IN ('MP','EM','PI','PA','PP','ME','MO', 'OI', 'GG', 'MC', 'MT', 'SP') "
cQuery += " 	and Substring(D1_COD,1,3) <> 'MOD' "
cQuery += " 	and FT_BASEICM > 0 " 
cQuery += " 	and Substring(D1_EMISSAO,1,6)='"+cDtAtu+"' " 
cQuery += " 	group by D1_COD, D1_LOCAL " 
cQuery += " union all "
cQuery += " 	SELECT B9_COD CODPRO, B9_LOCAL ARMZ, B9_QINI QUANT, B9_VINI1 VLRBASE, B9_X_ICMSI VLRICM FROM "+RetSqlName("SB9")+" SB9  "
cQuery += " 	WHERE D_E_L_E_T_ =' ' AND B9_FILIAL = '"+xFilial("SB9")+"' " 
cQuery += " 	AND Substring(B9_DATA,1,6) = '"+cDtAnt+"' ) JOINTABLE " 
cQuery += " GROUP BY CODPRO, ARMZ ) TBGERAL " //WHERE CODPRO = '002851' " 
cQuery += " order by 1, 2 " 

if Select("TMPS") > 0
	dbSelectArea("TMPS")
	TMPS->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPS", .T., .T. )

dbSelectArea("TMPS")
TMPS->(dbGotop())
nReg := 0
nCount := 0
while !TMPS->(eof())
	nReg++
	TMPS->(dbSKip())
enddo
TMPS->(dbGotop())
ProcRegua(0)
while !TMPS->(eof())
	nCount++
	AADD(aDados, {TMPS->CODPRO, TMPS->ARMZ, TMPS->QUANT, TMPS->VLRBASE, TMPS->VLRICM, TMPS->NINDEX})
	incProc("ADD B9+D1 -> "+AllTrim(TMPS->CODPRO)+" ARMZ: " +TMPS->ARMZ+" REG: "+cValToChar(nCount)+"/"+cValToChar(nReg))
	TMPS->(dbSkip())
enddo

return aDados

//////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para identificar a movimentação direta dos produtos com entrada via nota fiscal
static function MVD3ORINF(aDados, cDtAtu, cDtAnt)
local cQuery := " " 

cQuery := "  SELECT D3_COD, D3_LOCAL, D3_CF, D3_QUANT, D3_CUSTO1, R_E_C_N_O_ NUMREC FROM SD3010 SD3, "
cQuery += "  (SELECT DISTINCT CODPRO FROM "
cQuery += "  (SELECT CODPRO, ARMZ, QUANT, VLRBASE, VLRICM, CASE VLRBASE	when 0 then 0	else VLRICM / VLRBASE end NINDEX from "
cQuery += "  ( SELECT CODPRO, ARMZ, SUM(QUANT) QUANT, SUM(VLRBASE) VLRBASE, SUM(VLRICM) VLRICM FROM "
cQuery += "   (SELECT D1_COD CODPRO, D1_LOCAL ARMZ, Sum(D1_QUANT) QUANT, Sum(FT_BASEICM) VLRBASE, Sum(FT_VALICM) VLRICM "
cQuery += " from "+RetSqlName("SD1")+" SD1 , "+RetSqlName("SFT")+" SFT "
cQuery += " 	WHERE SD1.D_E_L_E_T_ =' ' and SFT.D_E_L_E_T_ =' ' "
cQuery += " 	AND D1_FILIAL = '"+xFilial("SD1")+"' AND FT_FILIAL = '"+xFilial("SFT")+"' "
cQuery += " 	and D1_DOC = FT_NFISCAL and D1_SERIE = FT_SERIE "
cQuery += " 	AND D1_FORNECE = FT_CLIEFOR AND D1_LOJA = FT_LOJA  "
cQuery += " 	AND D1_FILIAL = FT_FILIAL AND FT_TIPOMOV = 'E' "
cQuery += " 	and D1_COD = FT_PRODUTO AND D1_ITEM = FT_ITEM "
cQuery += " 	and D1_TP IN ('MP','EM','PI','PA','PP','ME','MO', 'OI', 'GG', 'MC', 'MT', 'SP') "
cQuery += " 	and Substring(D1_COD,1,3) <> 'MOD' "
cQuery += " 	and FT_BASEICM > 0 " 
cQuery += " 	and Substring(D1_EMISSAO,1,6)='"+cDtAtu+"' " 
cQuery += " 	group by D1_COD, D1_LOCAL " 
cQuery += " union all "
cQuery += " 	SELECT B9_COD CODPRO, B9_LOCAL ARMZ, B9_QINI QUANT, B9_VINI1 VLRBASE, B9_X_ICMSI VLRICM FROM "+RetSqlName("SB9")+" SB9  "
cQuery += " 	WHERE D_E_L_E_T_ =' ' AND B9_FILIAL = '"+xFilial("SB9")+"' " 
cQuery += " 	AND Substring(B9_DATA,1,6) = '"+cDtAnt+"' ) JOINTABLE " 
cQuery += "   GROUP BY CODPRO, ARMZ ) TBGERAL) PROD) CODPROD "
cQuery += "   where D_E_L_E_T_ =' ' "
cQuery += "   and CODPRO = D3_COD "
//cQuery += "   and CODPRO = '002851' " 
cQuery += "   and Substring(D3_EMISSAO,1,6)='"+cDtAtu+"' "
cQuery += "   order by 1, 2 "

if Select("TMPD3") > 0
	dbSelectArea("TMPD3")
	TMPD3->(dbSkip())
endif

dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPD3", .T., .T. )

dbSelectArea("TMPD3")
nReg := 0
TMPD3->(dbGotop())
while !TMPD3->(eof())
	nReg++
	TMPD3->(dbSkip())
enddo

TMPD3->(dbGotop())
dbSelectArea("SD3")
nCount := 0 
nIndex := 0
ProcRegua(0)
while !TMPD3->(eof())
	nCount++
//	nPosB9 := aScan(aSldAnt, {|x| x[1] == TMPB1->B1_COD } )
//	AADD(aDados, {TMPS->CODPRO, TMPS->ARMZ, TMPS->QUANT, TMPS->VLRBASE, TMPS->VLRICM, TMPS->NINDEX})
	nPos := aScan(aDados, {|x| x[1]+x[2] == TMPD3->(D3_COD+D3_LOCAL) } ) 
	if nPos > 0 
		nIndex := aDados[nPos][6]
		dbSelectArea("SD3")
		dbGoTo(  TMPD3->NUMREC  )
		RecLock("SD3", .F.)
		SD3->D3_CUSTO3 := SD3->D3_CUSTO1 * nIndex
		MsUnLock("SD3")
	endif		
	incProc("Atualizando SD3--> "+ALLTRIM(TMPD3->D3_COD)+" REG: " +cValToChar(nCount)+"/"+cValToChar(nReg))
	TMPD3->(dbSkip())
enddo
Alert("Finalizado o processo com notas fiscais...")

return

///////////////////////////////////////////////////////////////////////////////////
//Funcao para buscar os tipos de movimentos ocorridos no mes
static function TPMOV(cDtCalc)
local aTipo  := {}
local cQuery := {} 

cQuery := " Select distinct D3_CF from "+RetSqlName("SD3")+" SD3 "
cQuery += " where D_E_L_E_T_ =' ' and D3_FILIAL ='"+xFilial("SD3")+"' " 
cQuery += " and Substring(D3_EMISSAO,1,6)='"+cDtCalc+"' " 
cQuery += " AND D3_CF not in ('RE1','DE1') "
cQuery += " order by 1 desc " 

if select("TMPTP") > 0 
	dbSelectArea("TMPTP")
	TMPTP->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPTP", .T., .T. )
dbSelectArea("TMPTP")
TMPTP->(dbGOtop())
while !TMPTP->(eof())
	AADD(aTipo, {TMPTP->D3_CF} )
	TMPTP->(dbSkip())
enddo
return aTIPO

///////////////////////////////////////////////////////////////////////////////////
//Funcao para buscar as movimentacoes do SD3 por tipo de Codigo Fiscal D3_CF
static function D3MOVCF(aTIPO, cDtCalc)
local cQuery := " " 
local cQAux  := " " 
local nCtPr,nX  := 0

//Array contendo os Codigos Fiscais de Movimentacao no periodo
for nX := 1 to len(aTIPO)
	cQuery := " SELECT D3_COD, D3_LOCAL, D3_NUMSEQ, D3_CUSTO1, R_E_C_N_O_ NUMREC FROM "+RetSqlName("SD3")+" SD3 " 
	cQuery += " WHERE D_E_L_E_T_ =' ' AND D3_FILIAL = '"+xFilial("SD3")+"' " 
	cQuery += " AND SUBSTRING(D3_EMISSAO,1,6) = '"+cDtCalc+"' " 
	cQuery += " AND D3_CF = '" +aTIPO[nX][1]+"' "
	cQuery += " AND D3_CUSTO3 = 0 "  
	
	if Select("TMPD3") > 0 
		dbSelectArea("TMPD3")
		TMPD3->(dbCloseArea())
	endif
	
	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPD3", .T., .T.) 
	
	//Varrer a tabela SD3 em busca de registros contendo custos zerados...
	dbSelectArea("TMPD3")
	TMPD3->(dbGotop())
	ProcRegua(0)
	while !TMPD3->(eof())
		
	
		cQAux := " SELECT D3_COD, D3_LOCAL, D3_CUSTO1, D3_CUSTO3 FROM "+RetSqlName("SD3")+" SD3 " 
		cQAux += " WHERE D_E_L_E_T_ =' ' AND D3_FILIAL = '"+xFilial("SD3")+"' " 
		cQAux += " AND D3_NUMSEQ = '"+TMPD3->D3_NUMSEQ+"' " 
		cQAux += " AND SUBSTRING(D3_EMISSAO,1,6)='"+cDtCalc+"' " 
		cQAux += " AND D3_CUSTO3 > 0 " 
		
		if Select("TMPAUX") > 0 
			dbSelectArea("TMPAUX")
			TMPAUX->(dbCloseArea())
		endif
		
		dbUseArea(.T., "TOPCONN", tcGenQry(, , cQAux), "TMPAUX", .T., .T. )
		
		dbSelectArea("TMPAUX")
		TMPAUX->(dbGotop())
		nCount := 0 //Contar quantos registros foram encontrados (caso tenha + de 1 registro haverá necessidade de uma tratativa diferenciada)
		nCust1 := 0 //Verificar o custo1 do produto
		nCust3 := 0 //Verificar o custo3 do produto (se for apenas 1 produto, basta fazer uma regra de 3 para achar o custo
		nIndice:= 0 //Indice a ser encontrado e depois aplicado no custo do produto...
		while !TMPAUX->(eof())
			nCount ++
			nCust1 += TMPAUX->D3_CUSTO1
			nCust3 += TMPAUX->D3_CUSTO3
			TMPAUX->(dbSkip())
		enddo
		
		if nCount == 1 
			nIndice := nCust3 / nCust1
			dbSelectArea("SD3")
			dbGoTo(  TMPD3->NUMREC  )
			recLock("SD3", .F.)
			SD3->D3_CUSTO3 := nIndice * SD3->D3_CUSTO1
			msUnLock("SD3")
		endif
		nCtPr++
		IncProc("Analisando mov.int."+ALLTRIM(TMPD3->D3_COD)+" Reg "+cValToChar(nCtPr))
		TMPD3->(dbSkip())
	enddo
next nX 

return 