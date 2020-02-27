#INCLUDE "Protheus.ch"  

#DEFINE PICVAL  "@E 999,999,999.99"
///////////////////////////////////////////////////////////////////////////////
//Relatorio de composicao do custo dos produtos 
//Gera um relatorio com o custo dos produtos e as respectivas origens de cada custo
//separando o consumo por grupo e os MODs por códigos
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br -15-02-2012
///////////////////////////////////////////////////////////////////////////////

User Function AGF_CPCUSGER()
//Exclusivo para gerar para Excel
Local i
Private aConteud:= {}       
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab        := "" 

if APMsgNoYes("Deseja Gerar para Excel", "Gerar Excel")
	aDir := MDirArq()
	If Empty(aDir[1]) .OR. Empty(aDir[2])
		Return
	Else                      
		Processa( {|lEnd| CalcCompCus(@lEnd)}, "Aguarde...","Calculando Custos.", .T. )		
	
		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif
else
	return
endif




return

static function CalcCompCus(lEnd)		
Local cQuery := ""  
Local i,ik        
Private cPerg   := "AGF_CPSCUS"

if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
endif
Pergunte(cPerg,.T.)      

//Verifica se tabelas temporias existem e encerra as mesmas antes de executar as novas
if Select("TMPMOD") > 0 
	dbSelectArea("TMPMOD")
	TMPMOD->(dbCloseArea())
endif

//Alert('MV_PAR07-> '+cValToChar(mv_par07))

cQuery := " SELECT DISTINCT D3_COD from SD3010 WHERE D_E_L_E_T_ = ' ' "
cQuery += " AND D3_FILIAL = '"+xFilial('SD3')+"' AND SUBSTRING(D3_COD,1,3)='MOD' " 
cQuery += " AND D3_EMISSAO between '"+dTos(mv_par01)+"' AND '"+dTos(mv_par02)+"' "
cQuery += " ORDER BY D3_COD " 
                                                            
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN", tcGenQry(,,cQuery),"TMPMOD",.F.,.T.)
nCount:= 0 
aMods := {}
dbSelectArea('TMPMOD')
dbGotop()
while !TMPMOD->(eof())
	AADD(aMods, {ALLTRIM(TMPMOD->D3_COD)})
	nCount++
	TMPMOD->(dbSkip())
enddo 

aTMP	:= {}
AADD(aTMP,{"D3_GRUPO"       , "C", 04, 0 } )
AADD(aTMP,{"B1_COD" 	    , "C", 15, 0 } )
AADD(aTMP,{"B1_DESC"        , "C", 100, 0 } )
AADD(aTMP,{"D3_OP"			, "C", 06, 0 } )
AADD(aTMP,{"D3_QUANT"       , "N", 15, 2 } )
AADD(aTMP,{"D3_CUSTO1"      , "N", 15, 2 } )
AADD(aTMP,{"D3_CUSCOU"		, "N", 15, 2 } ) //COURO GRP 45C/45D
AADD(aTMP,{"D3_CUSTMAT"     , "N", 15, 2 } )      
AADD(aTMP,{"D3_CONSPQ"		, "N", 15, 2 } ) //EXCLUSIVO PNP1 - PRODUTOS QUIMICOS SERÃO ADICIONADOS NESTE CAMPO
AADD(aTMP,{"D3_EMB"		    , "N", 15, 2 } )
AADD(aTMP,{"D3_CUSMOD"      , "N", 15, 2 } )
AADD(aTMP,{"D3_MODDIR"      , "N", 15, 2 } ) //MAO DE OBRA DIRETA
AADD(aTMP,{"D3_MODIND"      , "N", 15, 2 } ) //MAO DE OBRA INDIRETA
AADD(aTMP,{"D3_MODDIV"      , "N", 15, 2 } ) //MAO DE OBRA DIVERSAS


ctrTMP := CriaTrab(aTMP, .T.)
dbUseArea(.T.,,ctrTMP,"TMP",.F.,.F.)
INDEX ON B1_COD + B1_DESC to &ctrTMP


if Select('TMPD3')> 0
	dbSelectArea('TMPD3')
	TMPD3->(dbCloseArea())
endif

	cQD3 := " SELECT D3_GRUPO, D3_COD, Substring(D3_OP,1,6) D3_OP, D3_CC, D3_NUMSEQ, D3_QUANT, D3_CUSTO1 "
	cQD3 += " FROM SD3010 SD3 "
	cQD3 += " where SD3.D_E_L_E_T_ = ' '  "
	cQD3 += " and D3_FILIAL = '"+xFilial("SD3")+"' "
	cQD3 += " and D3_EMISSAO >= '"+dTos(mv_par01)+"' and D3_EMISSAO <= '"+dTos(mv_par02)+"' "
	cQD3 += " and D3_COD between '"+mv_par03+"' and '"+mv_par04+"' "
	cQD3 += " and D3_GRUPO between '"+mv_par05+"' and '"+mv_par06+"' "
	//cQD3 += " AND D3_OP IN ('86231901001' ) " 
	//cQD3 += " AND D3_COD IN ('069273' ) " 
	cQD3 += " and D3_CF = 'PR0' and D3_ESTORNO <> 'S' " 
	cQD3 += " and D3_LOCAL NOT IN ('L1','L2') " 
	cQD3 += " order by D3_COD "

	cQD3 := ChangeQuery(cQD3)
	dbUseArea(.T.,"TOPCONN", tcGenQry(,, cQD3), "TMPD3",.F.,.T.)
    
	ProcRegua(0)
	dbSelectArea("TMPD3")
	TMPD3->(dbGotop())
	while !TMPD3->(eof())
	dbSelectArea("TMP")
		nCusMat := 0
		nCusMod := 0
		nCusPQ  := 0 
		nCusCouro := 0
		nEmbalagem := 0
		RecLock("TMP",.T.)
		TMP->D3_GRUPO   := TMPD3->D3_GRUPO
		TMP->B1_COD		:= TMPD3->D3_COD
		TMP->B1_DESC 	:= Posicione('SB1',1,xFilial('SB1')+TMPD3->D3_COD,"B1_DESC")
		TMP->D3_OP   	:= TMPD3->D3_OP
		TMP->D3_CUSTO1  := TMPD3->D3_CUSTO1
		TMP->D3_QUANT   := TMPD3->D3_QUANT
		dbSelectArea('SD3')
		dbSetOrder(4) //D3_FILIAL+D3_NUMSEQ+D3_CHAVE+D3_COD
			dbSeek(xFilial('SD3')+TMPD3->D3_NUMSEQ)
			while !SD3->(eof()).and.SD3->D3_NUMSEQ == TMPD3->D3_NUMSEQ
				if SD3->D3_COD <> TMPD3->D3_COD .and. Substr(SD3->D3_COD,1,3) <> 'MOD'
					if Substr(SD3->D3_CF,1,1) <> 'D'
						nCusMat += SD3->D3_CUSTO1
					endif          
					// Adiciona custo materia prima grupo 16 na coluna Insumo/Quimico
					// Desconta custo da materia prima do custo das demais requisicoes 
						if Substr(SD3->D3_GRUPO,1,4) $ '16  '
							nCusPQ += SD3->D3_CUSTO1
							nCusMat -= SD3->D3_CUSTO1
						endif 
						if Substr(SD3->D3_GRUPO,1,4) $ '16  '  .And. TMPD3->D3_GRUPO $ '56  '
							nCusPQ += SD3->D3_CUSTO1
							nCusMat -= SD3->D3_CUSTO1
						endif 
						if Substr(SD3->D3_GRUPO,1,4) $ '12  |14  |39T |39TI'
							nCusPQ += SD3->D3_CUSTO1
							nCusMat -= SD3->D3_CUSTO1
						endif 
					Endif
					//
					// Separa custo couro (45C e 45D) do custo da materia prima (45)
					if SD3->D3_CF = 'RE1' .And. Substr(SD3->D3_GRUPO,1,4) $ '45C  |45D  |51OM'
						nCusCouro += SD3->D3_CUSTO1
						nCusMat -= SD3->D3_CUSTO1
					endif 
					
					// Separa materias de embalagem
					if Substr(SD3->D3_GRUPO,1,4) $ '19  '
						nEmbalagem += SD3->D3_CUSTO1
						nCusMat -= SD3->D3_CUSTO1
					endif
						

				if SD3->D3_COD <> TMPD3->D3_COD .and. Substr(SD3->D3_COD,1,3) == 'MOD' .and. SD3->D3_CF == 'RE1' .and. Substr(SD3->D3_COD,1,6) <> 'MOD998'
					nCusMod += SD3->D3_CUSTO1
				endif
				if SD3->D3_COD <> TMPD3->D3_COD .and. Substr(SD3->D3_COD,1,3) == 'MOD' .and. SD3->D3_CF == 'DE1' .and. Substr(SD3->D3_COD,1,6) == 'MOD998'
					nCusMat -= SD3->D3_CUSTO1
				endif
				
				if SD3->D3_CF == 'RE1'
//					TMP->(ALLTRIM(SD3->D3_COD)) += SD3->D3_CUSTO1
					do case 
						case Substr(ALLTRIM(SD3->D3_COD),1,5) == 'MOD32'
							TMP->D3_MODDIR += SD3->D3_CUSTO1
						case Substr(ALLTRIM(SD3->D3_COD),1,5) $ 'MOD35|MOD36|MOD37|MOD38|MOD39'
							TMP->D3_MODIND += SD3->D3_CUSTO1
						otherwise
							if Substr(ALLTRIM(SD3->D3_COD),1,3) == "MOD"
								TMP->D3_MODDIV += SD3->D3_CUSTO1
							endif
					EndCase
				endif
			 	SD3->(dbSkip())
			 enddo
		TMP->D3_CUSTMAT := nCusMat 
		TMP->D3_CUSMOD  := nCusMod
		TMP->D3_CONSPQ  := nCusPQ
		TMP->D3_CUSCOU  := nCusCouro
		TMP->D3_EMB 	:= nEmbalagem
		MsUnLock("TMP")
		TMPD3->(dbSkip())
		nCusMat := 0
		nCusMod := 0
		nCusPQ  := 0
		nCusCouro := 0 
		nEmbalagem := 0
		incProc("Calculando custo OP "+TMPD3->D3_OP)
	enddo

/*if cFilant == '09'
	dbSelectArea('TMP')
	dbGotop()
	while !TMP->(eof())
		if TMP->D3_CUSMOD == 0
			RECLOCK('TMP',.F.)
			DBDELETE()
			MSUNLOCK('TMP')
		endif
		TMP->(dbSkip())
	enddo
endif		*/ 

aRES := {}
cCodOld := ""

dbSelectArea('TMP')
TMP->(dbGotop())
While !TMP->(eof())
//Alert('cCodOld-> ' +cCodOld+' TMP-> '+TMP->B1_COD)
if cCodOld <> TMP->B1_COD
	AADD(aRes, {TMP->B1_COD, TMP->B1_DESC, TMP->D3_QUANT, TMP->D3_CUSTO1, TMP->D3_CUSCOU,TMP->D3_CUSTMAT, TMP->D3_CONSPQ, TMP->D3_EMB, TMP->D3_CUSMOD, TMP->D3_MODDIR, TMP->D3_MODIND, TMP->D3_MODDIV })		
else
	aRES [len(aRes), 3] += TMP->D3_QUANT
	aRES [len(aRes), 4] += TMP->D3_CUSTO1
	aRES [len(aRes), 5] += TMP->D3_CUSCOU
	aRES [len(aRes), 6] += TMP->D3_CUSTMAT
	aRES [len(aRes), 7] += TMP->D3_CONSPQ
	aRES [len(aRes), 8] += TMP->D3_EMB
	aRES [len(aRes), 9] += TMP->D3_CUSMOD
	aRES [len(aRes), 10] += TMP->D3_MODDIR
	aRES [len(aRes), 11] += TMP->D3_MODIND
	aRES [len(aRes), 12] += TMP->D3_MODDIV
endif
	cCodOld := TMP->B1_COD
	TMP->(dbSkip())
enddo
                             
//Gerar Resumo....
aCustoKit := {}
nCKMat    := 0 // Custo Kit - Material
nCMMod    := 0 // Custo Kit - MOD 

  
cQryRes := " SELECT DISTINCT G1_COD, G1_COMP, G1_QUANT FROM SG1010 SG1, SB1010 SB1 WHERE SG1.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' " 
cQryRes += " AND G1_COD = B1_COD AND G1_FILIAL = '"+xFilial('SG1')+"' " 
cQryRes += " AND B1_UM = 'KT' ORDER BY G1_COD, G1_COMP " 

if Select('TMPRES') > 0
	dbSelectArea('TMPRES')
	TMPRES->(dbCloseArea())
endif 

cQryRes := ChangeQuery(cQryRes)
dbUseArea(.T.,"TOPCONN", tcGenQry(,, cQryRes), "TMPRES",.F.,.T.)


//
ncount := 0
aStruCP :={}
dbSelectArea('TMPRES')
dbGotop()
while !TMPRES->(eof())
	if cFilAnt $ '08'
		dbSelectArea('SG1')
		dbSetOrder(1)
		dbSeek(xFilial('SG1')+TMPRES->G1_COMP)
		while !SG1->(eof()).and.SG1->G1_COD == TMPRES->G1_COMP
			if Substr(SG1->G1_COD,1,3) <> 'MOD' 
				if Posicione('SB1',1,xFilial('SB1')+TMPRES->G1_COMP,"B1_GRUPO") $ '16  |40  |48  '
					aadd(aStruCP, {TMPRES->G1_COD, TMPRES->G1_COMP, TMPRES->G1_QUANT, SG1->G1_COMP, SG1->G1_QUANT,2,'NAO TEM COMP', 0, 0 , 0})
				else
				    aadd(aStruCP, {TMPRES->G1_COD, TMPRES->G1_COMP, TMPRES->G1_QUANT, SG1->G1_COMP, SG1->G1_QUANT,2,'TEM COMP', 0 , 0, 0})
				endif
			endif
			SG1->(dbSkip())
			nCount++
		enddo
	elseif cFilant $ '04|12|19'
		aadd(aStruCP, {TMPRES->G1_COD, TMPRES->G1_COMP, TMPRES->G1_QUANT, 0, 0,2,''})
	endif
	TMPRES->(dbSkip())
enddo
//Verifica se tem 3 niveis
if cFilant $ '08'
	for i:= 1 to len(aStruCP)
		if Posicione('SB1',1, xFilial('SB1')+aStruCP[i][4],"B1_GRUPO") $ '16|40|48'
			aStruCP[i][6] := 3
		endif
		nPosPc := aScan(aCustoKit, {|x| Alltrim(x[2]) == Alltrim(aStruCP[i][1]) } )
		if nPosPc == 0
			AADD(aCustoKit, {"'"+Posicione('SB1',1,xFilial('SB1')+aStruCP[i][1], "B1_GRUPO"), aStruCP[i][1], Posicione('SB1',1,xFilial('SB1')+aStruCP[i][1], "B1_DESC"), 0, 0, 0, 0} )
		endif
	next i
endif


if cFilant $ '04|12|19'
	for ik := 1 to len(aCustoKit)
		nPosPc := aScan(aStruCP, {|x| Alltrim(x[1]) == Alltrim(aCustoKit[ik][2]) } )
		for i:= nPosPc to len(aStruCP)
			if Alltrim(aStruCP[i][1]) == Alltrim(aCustoKit[ik][2])
				nPos := aScan(aRes, {|x| Alltrim(x[1]) == Alltrim(aStruCP[i][2]) } ) 
				if nPos > 0
					aCustoKit[ik][4] := aCustoKit[ik][4] + ((aRes[nPos][4]/aRes[nPos][3]))
					aCustoKit[ik][5] := aCustoKit[ik][5] + ((aRes[nPos][5]/aRes[nPos][3]))
					aCustoKit[ik][6] := aCustoKit[ik][6] + ((aRes[nPos][6]/aRes[nPos][3]))
					aCustoKit[ik][7] += 1
				endif
			endif
		next i			
	next iK
elseif cFilant $ '08' 
aKits := {}
cCodOld := ""
nCount  :=0 
	for i:=1 to len(aStruCP)
		if aStruCP[i][7]=='NAO TEM COMP'
			nPosPc := aScan(aRES, {|x| Alltrim(x[1]) == Alltrim(aStruCP[i][2]) } )
		else
			nPosPc := aScan(aRES, {|x| Alltrim(x[1]) == Alltrim(aStruCP[i][4]) } )
		endif
		if nPosPc >0 
			aStruCP[i][8] := aRes[nPosPc][4] / aRes[nPosPc][3]
			aStruCP[i][9] := aRes[nPosPc][5] / aRes[nPosPc][3]
			aStruCP[i][10] := aRes[nPosPc][6] / aRes[nPosPc][3]
			nCount++
		endif
	next i
	for i:= 1 to len(aStruCP)
		if aStruCP[i][8] > 0
			if aStruCP[i][1] <> cCodOld
				aadd(aKits, {Posicione('SB1',1,xFilial('SB1')+aStruCP[i][1],"B1_GRUPO"), aStruCP[i][1],Posicione('SB1',1,xFilial('SB1')+aStruCP[i][1],"B1_DESC"), aStruCP[i][8], aStruCP[i][9], aStruCP[i][10] } )
			else
				aKits [len(aKits),4] += aStruCP[i][8]
				aKits [len(aKits),5] += aStruCP[i][9]
				aKits [len(aKits),6] += aStruCP[i][10]
			endif
			cCodOld := aStruCP[i][1]
		endif
	next i
endif



/*
for i:= 1 to len(aStruCP)
	nPosPC := aScan( aRES, {|x| Alltrim(x[1]) == Alltrim(aStruCP[i][1]) } )
	if nPosPC > 0
		aCustoKit [len(aCustoKit), 5] := (aRes[nPosPc][4]/aRes[nPosPc][3])*TMPRES->C2_QUANT
		aCustoKit [len(aCustoKit), 6] := (aRes[nPosPc][5]/aRes[nPosPc][3])*TMPRES->C2_QUANT
		aCustoKit [len(aCustoKit), 7] := (aRes[nPosPc][6]/aRes[nPosPc][3])*TMPRES->C2_QUANT
	endif
	aCustoKit [len(aCustoKit), 8] := aCustoKit [len(aCustoKit), 8] +','+Alltrim(aStruCP[i][1])
next i



/*
	aaDD(aCustoKit, {"'"+Posicione('SB1',1,xFilial('SB1')+TMPRES->C2_PRODUTO,"B1_GRUPO"), TMPRES->C2_PRODUTO, Posicione('SB1',1,xFilial('SB1')+TMPRES->C2_PRODUTO,"B1_DESC"), TMPRES->D3_QUANT, 0, 0, 0,""})
//	Alert('Produto -> '+TMPRES->C2_PRODUTO)
	if nNivel == 2 .or. cFilant <> '08' 
		Alert('Produto -> '+TMPRES->C2_PRODUTO)
		for i:= 1 to len(aStruCP)
			nPosPC := aScan( aRES, {|x| Alltrim(x[1]) == Alltrim(aStruCP[i][1]) } )
			if nPosPC > 0
				aCustoKit [len(aCustoKit), 5] := (aRes[nPosPc][4]/aRes[nPosPc][3])*TMPRES->C2_QUANT
				aCustoKit [len(aCustoKit), 6] := (aRes[nPosPc][5]/aRes[nPosPc][3])*TMPRES->C2_QUANT
				aCustoKit [len(aCustoKit), 7] := (aRes[nPosPc][6]/aRes[nPosPc][3])*TMPRES->C2_QUANT
			endif
			aCustoKit [len(aCustoKit), 8] := aCustoKit [len(aCustoKit), 8] +','+Alltrim(aStruCP[i][1])
		next i
	elseif nNivel == 3 .and. cFilAnt == '08' 
		for i:= 1 to len(aStruPC)
			nPosPC := aScan( aRES, {|x| Alltrim(x[1]) == Alltrim(aStruPC[i][1]) } )
			if nPosPC > 0
				aCustoKit [len(aCustoKit), 4] := (aRes[nPosPc][4]/aRes[nPosPc][3])*TMPRES->C2_QUANT
				aCustoKit [len(aCustoKit), 5] := (aRes[nPosPc][5]/aRes[nPosPc][3])*TMPRES->C2_QUANT
				aCustoKit [len(aCustoKit), 6] := (aRes[nPosPc][6]/aRes[nPosPc][3])*TMPRES->C2_QUANT
			endif
		next i
	endif
*/

//Adicionando linhas no array da planilha para gerar arquivo Excel
aAdd(aConteud,{"","Planilha de Composicao de custo de produção - RESUMIDO - FILIAL "+cFilant,"","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) //50 Colunas
aAdd(aConteud,{"","PERIODO DE "+dtoc(mv_par01)+" ATE "+dtoc(mv_par02),"","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	//Cabeçalho

If cFilant $ '08|19' 
	//Tabulaçao     1     2           3       4    5        6      7        8            9           10        11          13         14         15         16
	aAdd(aConteud,{"GRUPO","CODIGO","DESCRICAO","UM","TIPO","QTDE","TOTAL","COURO/RASPA","MAT.SEC","PQ/INSUMO","EMBALAGEM","MOD_DIR","MOD_IND", "MOD_DIV"}) 
Else
	//Tabulaçao     1     2           3          4    5        6      7        8            9           10        11          13         14         15         16
	aAdd(aConteud,{"GRUPO","CODIGO","DESCRICAO","UM","TIPO","QTDE","TOTAL","MAT.SEC","COURO/RASPA","PQ/INSUMO","EMBALAGEM","MOD_DIR","MOD_IND", "MOD_DIV"}) 
Endif

    for i := 1 to len(aREs)
	incproc('Gravando arquivo CSV....Produto '+ aRES[i][1])
		//              1  2  3  4  5  6  7  8  9 10 11 12 13 14
		aAdd(aConteud,{"","","","","","", 0, 0, 0, 0, 0,0, 0, 0 })
		aConteud [len(aConteud),1] := "'"+Posicione("SB1",1,xFilial('SB1')+aRES[i][1],"B1_GRUPO")
		aConteud [len(aConteud),2] := "'"+aRES[i][1]
		aConteud [len(aConteud),3] := aRES[i][2]
		aConteud [len(aConteud),4] := Posicione("SB1",1,xFilial("SB1")+aRES[i][1],"B1_UM")
		aConteud [len(aConteud),5] := Posicione("SB1",1,xFilial("SB1")+aRES[i][1],"B1_TIPO")
		aConteud [len(aConteud),6] := aRES[i][3]
		aConteud [len(aConteud),7] := aRES[i][4]
		aConteud [len(aConteud),8] := aRES[i][5]
		aConteud [len(aConteud),9] :=  aRES[i][6]
		aConteud [len(aConteud),10] := aRES[i][7]
		aConteud [len(aConteud),11] := aRES[i][8]
		aConteud [len(aConteud),12] := aRES[i][10]
		aConteud [len(aConteud),13] := aRES[i][11]
		aConteud [len(aConteud),14] := aRES[i][12]
		//aConteud [len(aConteud),15] := aRES[i][12]
/*		aConteud [len(aConteud),14] := aRES[i][10]
		aConteud [len(aConteud),15] := aRES[i][11]
		aConteud [len(aConteud),16] := aRES[i][12]
		aConteud [len(aConteud),17] := aRES[i][13]
		aConteud [len(aConteud),18] := aRES[i][14]
		aConteud [len(aConteud),19] := aRES[i][15]
		aConteud [len(aConteud),20] := aRES[i][16]
		aConteud [len(aConteud),21] := aRES[i][17]
		aConteud [len(aConteud),22] := aRES[i][18]
		aConteud [len(aConteud),23] := aRES[i][19]
		aConteud [len(aConteud),24] := aRES[i][20]
		aConteud [len(aConteud),25] := aRES[i][21]
		aConteud [len(aConteud),26] := aRES[i][22]
		aConteud [len(aConteud),27] := aRES[i][23]
		aConteud [len(aConteud),28] := aRES[i][24]
		aConteud [len(aConteud),29] := aRES[i][25]
		aConteud [len(aConteud),30] := aRES[i][26]
		aConteud [len(aConteud),31] := aRES[i][27]
		aConteud [len(aConteud),32] := aRES[i][28]
		aConteud [len(aConteud),33] := aRES[i][29]
		aConteud [len(aConteud),34] := aRES[i][30]
		aConteud [len(aConteud),35] := aRES[i][31]
		aConteud [len(aConteud),36] := aRES[i][32]
		aConteud [len(aConteud),37] := aRES[i][33]
		aConteud [len(aConteud),38] := aRES[i][34]
		aConteud [len(aConteud),39] := aRES[i][35]
		aConteud [len(aConteud),40] := aRES[i][36]
		aConteud [len(aConteud),41] := aRES[i][37]
		aConteud [len(aConteud),42] := aRES[i][38]
		aConteud [len(aConteud),43] := aRES[i][39]
		aConteud [len(aConteud),44] := aRES[i][40]
		aConteud [len(aConteud),45] := aRES[i][41]
		aConteud [len(aConteud),46] := aRES[i][42]
		aConteud [len(aConteud),47] := aRES[i][43]
		aConteud [len(aConteud),48] := aRES[i][44]
		aConteud [len(aConteud),49] := aRES[i][45]
		aConteud [len(aConteud),50] := aRES[i][46]
		aConteud [len(aConteud),51] := aRES[i][47]		 */
	next i

if cFilAnt $ '04|08|12|19' 
	aAdd(aConteud,{"","","","","","","",""})
	aAdd(aConteud,{"","","","","","","",""})
	aAdd(aConteud,{"","Resumo de Custo de Producao por KIT - FILIAL "+cFilant,"","","","","",""}) //5 Colunas
	aAdd(aConteud,{"","PERIODO DE "+dtoc(mv_par01)+" ATE "+dtoc(mv_par02),"","","","","",""})
	aAdd(aConteud,{"GRUPO","CODIGO","DESCRICAO","CUST.TOTAL","CUST.MAT.","CUST.MOD."})
endif
// Alert('Tamanho do array -> '+cValToChar(len(aCustoKit)))
 nCount := 0
 if cFilAnt $ '04|12|19' 
	 for i:= 1 to len(aCustoKit)
    	if aCustoKit[i][4] > 0 .and. aCustoKit[i][7] > 1
		 	aAdd(aConteud, {"","","",0,0,0})
			aConteud [len(aConteud), 1] := aCustoKit[i][1]
			aConteud [len(aConteud), 2] := aCustoKit[i][2]+"'"
			aConteud [len(aConteud), 3] := aCustoKit[i][3]
			aConteud [len(aConteud), 4] := aCustoKit[i][4]
			aConteud [len(aConteud), 5] := aCustoKit[i][5]
			aConteud [len(aConteud), 6] := aCustoKit[i][6]
			nCount++
		endif
	next i
elseif cFilant $ '08' 
//			aadd(aStruCP, {TMPRES->G1_COD, TMPRES->G1_COMP, TMPRES->G1_QUANT, SG1->G1_COMP, SG1->G1_QUANT,2, ' ',0,0,0})
	for i:= 1 to len(aKits)
	 	aAdd(aConteud, {"","","",0,0,0})
		aConteud [len(aConteud), 1] := aKits[i][1]+"'"
		aConteud [len(aConteud), 2] := aKits[i][2]+"'"
		aConteud [len(aConteud), 3] := aKits[i][3]
		aConteud [len(aConteud), 4] := aKits[i][4]
		aConteud [len(aConteud), 5] := aKits[i][5]
		aConteud [len(aConteud), 6] := aKits[i][6]
//		aConteud [len(aConteud), 7] := aStruCP[i][7]
//		aConteud [len(aConteud), 8] := aStruCP[i][8]
//		aConteud [len(aConteud), 9] := aStruCP[i][9]
//		aConteud [len(aConteud), 10] := aStruCP[i][10]
	next i

endif

          
TMP->(dbCloseArea())
Ferase(ctrTMP+".dbf")
Ferase(ctrTMP+".cdx")

return 

//--------------------------------
Static Function AjustaSx1(cPerg)
//--------------------------------
//Variaveis locais
Local aRegs := {}
Local i,j
//Inicio da funcao
dbSelectArea("SX1")
dbSetOrder(1)
//   1          2        3         4          5           6       7       8             9        10      11     12       13        14        15         16       17       18       19        20          21        22      23        24       25         26        27       28       29       30          31        32       33       34        35          36        37     38     39       40       41        42
//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_PYME/X1_GRPSXG/X1_HELP/X1_PICTURE
PutSx1(cPerg,"01","Data Inicial                  ?"," "," ","mv_ch1","D",8,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo inicial"},{"Informe o periodo inicial"},{"Informe o periodo inicial"})
PutSx1(cPerg,"02","Data final                    ?"," "," ","mv_ch2","D",8,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo final"},{"Informe o periodo final"},{"Informe o periodo final"})
PutSx1(cPerg,"03","Produto de                    ?"," "," ","mv_ch3","C",15,0,0,"G","","SB1","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto inicial"},{"Informe o produto inicial"},{"Informe o produto inicial"})
PutSx1(cPerg,"04","Produto ate                   ?"," "," ","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto final"},{"Informe o produto final"},{"Informe o produto final"})
PutSx1(cPerg,"05","Grupo Inicial                 ?"," "," ","mv_ch5","C",04,0,0,"G","","SBM","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o grupo inicial"},{"Informe o grupo inicial"},{"Informe o grupo inicial"})
PutSx1(cPerg,"06","Grupo Final                   ?"," "," ","mv_ch6","C",04,0,0,"G","","SBM","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o grupo final"},{"Informe o grupo final"},{"Informe o grupo final"})
//PutSx1(cPerg,"07","Resumido por                  ?"," "," ","mv_ch7","N",1,0,2, "C","","   ","","","mv_par07","Kit","Kit","Kit", "Componente","Componente","Componente","Peca","Peca","Peca"," ", " "," "," "," ",	" ","",{"Imprimir consumo pela Média ou Pela Soma"},{"Imprimir consumo pela Média ou Pela Soma"},{"Imprimir consumo pela Média ou Pela Soma"})
//PutSx1(cPerg,"07","Aglutina Por 	             ?"," "," ","mv_ch7","N",01	,0,0,"C","", "", "","","mv_par07","Kit "," "," ","","Componente"," "," ","Peca","Peca","","","","","","",	" ", , ,)

//PutSx1(cPerg,"07","Armazem ate                   ?"," "," ","mv_ch9","C",2,0,0, "G","","   ","","","mv_par09"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o Armazem Final           "},{"Informe o Armazem final           "},{"Informe o Armazem final           "})
//PutSx1(cPerg,"08","Imprimir Resumo               ?"," "," ","mv_cha","N",1,0,2, "C","","   ","","","mv_par10","Sim","Si","Yes", " ","Nao","No","No"," "," "," ", " "," "," "," ",	" ","",{"Imprimir resumo ao final do relatorio"},{"Imprimir resumo ao final do relatorio"},{"Imprimir resumo ao final do relatorio"})
///PutSx1(cPerg,"11","Imprimir M2 Pelo              ?"," "," ","mv_chb","N",1,0,2, "C","","   ","","","mv_par11","Soma Consumo","Soma Consumo","Soma Consumo", " ","Media Consumo","Media Consumo","Media Consumo"," "," "," ", " "," "," "," ",	" ","",{"Imprimir consumo pela Média ou Pela Soma"},{"Imprimir consumo pela Média ou Pela Soma"},{"Imprimir consumo pela Média ou Pela Soma"})

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