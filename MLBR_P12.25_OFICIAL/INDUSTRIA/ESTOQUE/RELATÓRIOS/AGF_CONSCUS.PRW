#INCLUDE "Protheus.ch"  
#DEFINE PICVAL  "@E 999,999,999.99"

///////////////////////////////////////////////////////////////////////////////
//Relatorio de composicao do custo dos produtos 
//Gera um relatorio com o custo dos produtos e as respectivas origens de cada custo
//separando o consumo por grupo e os MODs por códigos
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br -15-02-2012
///////////////////////////////////////////////////////////////////////////////

User Function AGF_MDCONSC()
//Exclusivo para gerar para Excel
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
Private cPerg   := "AGF_CONSCUS"
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

//Arquivo temporario da funcao para geracao do relatorio
aTMP	:= {}                               
AADD(aTMP,{"D3_GRUPO"       , "C", 04, 0 } )
AADD(aTMP,{"B1_COD" 	    , "C", 15, 0 } )
AADD(aTMP,{"B1_DESC"        , "C", 50, 0 } )
AADD(aTMP,{"D3_OP"			, "C", 06, 0 } )
AADD(aTMP,{"D3_QUANT"       , "N", 15, 2 } )
AADD(aTMP,{"D3_CUSTO1"      , "N", 15, 2 } )
AADD(aTMP,{"D3_CUSTMAT"     , "N", 15, 2 } )
//AADD(aTMP,{"D3_CUSTPQ"      , "N", 15, 2 } )
AADD(aTMP,{"D3_CUSMOD"      , "N", 15, 2 } )
//AADD(aTMP,{"D3_CUSOUT"      , "N", 15, 2 } )
AADD(aTMP,{"MOD301"      , "N", 15, 2 } )
AADD(aTMP,{"MOD301A"      , "N", 15, 2 } )
AADD(aTMP,{"MOD311"      , "N", 15, 2 } )
AADD(aTMP,{"MOD311A"      , "N", 15, 2 } )
AADD(aTMP,{"MOD321"      , "N", 15, 2 } )
AADD(aTMP,{"MOD322"      , "N", 15, 2 } )
AADD(aTMP,{"MOD323"      , "N", 15, 2 } )
AADD(aTMP,{"MOD324"      , "N", 15, 2 } )
AADD(aTMP,{"MOD325"      , "N", 15, 2 } )
AADD(aTMP,{"MOD327"      , "N", 15, 2 } )
AADD(aTMP,{"MOD328"      , "N", 15, 2 } )
AADD(aTMP,{"MOD328A"      , "N", 15, 2 } )
AADD(aTMP,{"MOD351"      , "N", 15, 2 } )
AADD(aTMP,{"MOD351A"      , "N", 15, 2 } )
AADD(aTMP,{"MOD352"      , "N", 15, 2 } )
AADD(aTMP,{"MOD352A"      , "N", 15, 2 } )
AADD(aTMP,{"MOD353"      , "N", 15, 2 } )
AADD(aTMP,{"MOD353A"      , "N", 15, 2 } )
AADD(aTMP,{"MOD371"      , "N", 15, 2 } )
AADD(aTMP,{"MOD371A"      , "N", 15, 2 } )
AADD(aTMP,{"MOD372"      , "N", 15, 2 } )
AADD(aTMP,{"MOD372A"      , "N", 15, 2 } )
AADD(aTMP,{"MOD373"      , "N", 15, 2 } )
AADD(aTMP,{"MOD373A"      , "N", 15, 2 } )
AADD(aTMP,{"MOD374"      , "N", 15, 2 } )
AADD(aTMP,{"MOD374A"      , "N", 15, 2 } )
AADD(aTMP,{"MOD413"      , "N", 15, 2 } )
AADD(aTMP,{"MOD414"      , "N", 15, 2 } )
AADD(aTMP,{"MOD501"      , "N", 15, 2 } )
AADD(aTMP,{"MOD521"      , "N", 15, 2 } )
AADD(aTMP,{"MOD522"      , "N", 15, 2 } )
AADD(aTMP,{"MOD523"      , "N", 15, 2 } )
AADD(aTMP,{"MOD524"      , "N", 15, 2 } )
AADD(aTMP,{"MOD525"      , "N", 15, 2 } )
AADD(aTMP,{"MOD526"      , "N", 15, 2 } )
AADD(aTMP,{"MOD543"      , "N", 15, 2 } )
AADD(aTMP,{"MOD544"      , "N", 15, 2 } )
AADD(aTMP,{"MOD545"      , "N", 15, 2 } )
AADD(aTMP,{"MOD561"      , "N", 15, 2 } )
AADD(aTMP,{"MOD562"      , "N", 15, 2 } )


//
//for i:= 1 to len(aMOds)
//	AADD(aTMP,{aMods[i][1]  , "N", 15, 2 } )
//next i
ctrTMP := CriaTrab(aTMP, .T.)
dbUseArea(.T.,,ctrTMP,"TMP",.F.,.F.)
INDEX ON B1_COD + B1_DESC to &ctrTMP


if Select('TMPD3')> 0
	dbSelectArea('TMPD3')
	TMPD3->(dbCloseArea())
endif

	cQD3 := " SELECT D3_GRUPO, D3_COD, Substring(D3_OP,1,6) D3_OP, D3_NUMSEQ, D3_QUANT, D3_CUSTO1 "
	cQD3 += " FROM SD3010 SD3 "
	cQD3 += " where SD3.D_E_L_E_T_ = ' '  "
	cQD3 += " and D3_FILIAL = '"+xFilial("SD3")+"' "
	cQD3 += " and D3_EMISSAO >= '"+dTos(mv_par01)+"' and D3_EMISSAO <= '"+dTos(mv_par02)+"' "
	cQD3 += " and D3_COD between '"+mv_par03+"' and '"+mv_par04+"' "
	cQD3 += " and D3_GRUPO between '"+mv_par05+"' and '"+mv_par06+"' "
	cQD3 += " and D3_CF = 'PR0' and D3_ESTORNO <> 'S' " 
	cQD3 += " order by D3_COD "

	cQD3 := ChangeQuery(cQD3)
	dbUseArea(.T.,"TOPCONN", tcGenQry(,, cQD3), "TMPD3",.F.,.T.)

	
	dbSelectArea("TMPD3")
	TMPD3->(dbGotop())
	while !TMPD3->(eof())
	dbSelectArea("TMP")
		nCusMat := 0
		nCusMod := 0
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
					nCusMat += SD3->D3_CUSTO1
				endif
				if SD3->D3_COD <> TMPD3->D3_COD .and. Substr(SD3->D3_COD,1,3) == 'MOD' .and. SD3->D3_CF == 'RE1'
					nCusMod += SD3->D3_CUSTO1
				endif
				if SD3->D3_CF == 'RE1'
					do case 
						case ALLTRIM(SD3->D3_COD) == 'MOD301'
							TMP->MOD301 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD301A'
							TMP->MOD301A += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD311'
							TMP->MOD311 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD311A'
							TMP->MOD311A += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD321'
							TMP->MOD321 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD322'
							TMP->MOD322 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD323'
							TMP->MOD323 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD324'
							TMP->MOD324 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD325'
							TMP->MOD325 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD327'
							TMP->MOD327 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD328'
							TMP->MOD328 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD328A'
							TMP->MOD328A += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD351'
							TMP->MOD351 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD351A'
							TMP->MOD351A += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD352'
							TMP->MOD352 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD352A'
							TMP->MOD352A += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD353'
							TMP->MOD353 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD353A'
							TMP->MOD353A += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD371'
							TMP->MOD371 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD371A'
							TMP->MOD371A += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD372'
							TMP->MOD372 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD372A'
							TMP->MOD372A += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD373'
							TMP->MOD373 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD373A'
							TMP->MOD373A += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD374'
							TMP->MOD374 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD374A'
							TMP->MOD374A += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD413'
							TMP->MOD413 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD414'
							TMP->MOD414 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD501'
							TMP->MOD501 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD521'
							TMP->MOD521 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD522'
							TMP->MOD522 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD523'
							TMP->MOD523 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD524'
							TMP->MOD524 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD525'
							TMP->MOD525 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD526'
							TMP->MOD526 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD543'
							TMP->MOD543 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD544'
							TMP->MOD544 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD545'
							TMP->MOD545 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD561'
							TMP->MOD561 += SD3->D3_CUSTO1
						case ALLTRIM(SD3->D3_COD) == 'MOD562'
							TMP->MOD562 += SD3->D3_CUSTO1
					EndCase
				endif
			 	SD3->(dbSkip())
			 enddo
		TMP->D3_CUSTMAT := nCusMat 
		TMP->D3_CUSMOD  := nCusMod
		MsUnLock("TMP")
		TMPD3->(dbSkip())
		incProc("Calculando custo OP "+TMPD3->D3_OP)
	enddo

if cFilant == '09'
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
endif		

//Adicionando linhas no array da planilha para gerar arquivo Excel
aAdd(aConteud,{"","Planilha de Composicao de custo de produção","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) //50 Colunas
aAdd(aConteud,{"","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	//Cabeçalho
	//Tabulaçao     1             2           3             4    5        6      7        8           9        10       11        12   
aAdd(aConteud,{"GRUPO","CODIGO","DESCRICAO","UM","TIPO","ORD.PROD","QTDE","CUST.TOTAL","CUST.MAT.","CUST.MOD.","MOD301","MOD301A","MOD311","MOD311A","MOD321","MOD322","MOD323","MOD324","MOD325","MOD327","MOD328","MOD328A","MOD351","MOD351A","MOD352","MOD352A","MOD353","MOD353A","MOD371","MOD371A","MOD372","MOD372A","MOD373","MOD373A","MOD374","MOD374A","MOD413","MOD414","MOD501","MOD521","MOD522","MOD523","MOD524","MOD525","MOD526","MOD543","MOD544","MOD545","MOD561","MOD562"})
	dbSelectArea('TMP')
	dbGotop()
	while !TMP->(eof())
	incproc('Gravando arquivo CSV....Produto '+ TMP->B1_COD+ 'OP -> '+TMP->D3_OP)
		aAdd(aConteud,{"","","","","","",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
		aConteud [len(aConteud),1] := "'"+TMP->D3_GRUPO
		aConteud [len(aConteud),2] := "'"+TMP->B1_COD
		aConteud [len(aConteud),3] := TMP->B1_DESC
		aConteud [len(aConteud),4] := Posicione("SB1",1,xFilial("SB1")+TMP->B1_COD,"B1_UM")
		aConteud [len(aConteud),5] := Posicione("SB1",1,xFilial("SB1")+TMP->B1_COD,"B1_TIPO")
		aConteud [len(aConteud),6] := "'"+TMP->D3_OP		
		aConteud [len(aConteud),7] := TMP->D3_QUANT
		aConteud [len(aConteud),8] := TMP->D3_CUSTO1 //CUSTMAT +TMP->D3_CUSMOD
		aConteud [len(aConteud),9] := TMP->D3_CUSTMAT
		aConteud [len(aConteud),10] := TMP->D3_CUSMOD
		aConteud [len(aConteud),11] := TMP->MOD301
		aConteud [len(aConteud),12] := TMP->MOD301A   
		aConteud [len(aConteud),13] := TMP->MOD311
		aConteud [len(aConteud),14] := TMP->MOD311A
		aConteud [len(aConteud),15] := TMP->MOD321
		aConteud [len(aConteud),16] := TMP->MOD322
		aConteud [len(aConteud),17] := TMP->MOD323
		aConteud [len(aConteud),18] := TMP->MOD324
		aConteud [len(aConteud),19] := TMP->MOD325
		aConteud [len(aConteud),20] := TMP->MOD327
		aConteud [len(aConteud),21] := TMP->MOD328
		aConteud [len(aConteud),22] := TMP->MOD328A
		aConteud [len(aConteud),23] := TMP->MOD351
		aConteud [len(aConteud),24] := TMP->MOD351A
		aConteud [len(aConteud),25] := TMP->MOD352
		aConteud [len(aConteud),26] := TMP->MOD352A
		aConteud [len(aConteud),27] := TMP->MOD353
		aConteud [len(aConteud),28] := TMP->MOD353A
		aConteud [len(aConteud),29] := TMP->MOD371
		aConteud [len(aConteud),30] := TMP->MOD371A
		aConteud [len(aConteud),31] := TMP->MOD372
		aConteud [len(aConteud),32] := TMP->MOD372A
		aConteud [len(aConteud),33] := TMP->MOD373
		aConteud [len(aConteud),34] := TMP->MOD373A
		aConteud [len(aConteud),35] := TMP->MOD374
		aConteud [len(aConteud),36] := TMP->MOD374A
		aConteud [len(aConteud),37] := TMP->MOD413
		aConteud [len(aConteud),38] := TMP->MOD414
		aConteud [len(aConteud),39] := TMP->MOD501
		aConteud [len(aConteud),40] := TMP->MOD521
		aConteud [len(aConteud),41] := TMP->MOD522
		aConteud [len(aConteud),42] := TMP->MOD523
		aConteud [len(aConteud),43] := TMP->MOD524
		aConteud [len(aConteud),44] := TMP->MOD525
		aConteud [len(aConteud),45] := TMP->MOD526
		aConteud [len(aConteud),46] := TMP->MOD543
		aConteud [len(aConteud),47] := TMP->MOD544
		aConteud [len(aConteud),48] := TMP->MOD545
		aConteud [len(aConteud),49] := TMP->MOD561
		aConteud [len(aConteud),50] := TMP->MOD562
		TMP->(dbSkip())                   
	enddo               

//Gerar Resumo....

TMP->(dbCloseArea())
Ferase(ctrTMP+".dbf")
Ferase(ctrTMP+".cdx")

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
