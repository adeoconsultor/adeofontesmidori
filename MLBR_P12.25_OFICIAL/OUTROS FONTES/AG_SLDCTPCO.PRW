#include 'protheus.ch'
#include 'rwmake.ch'

//Rotina para fazer o recalculo do PCO x CONTABIL x COMPRA
//
//


user function AG_SLDCTPCO()

Private cPerg   := "AG_SLDCTPCO"

if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
endif
Pergunte(cPerg,.T.)
If ApMsgNoYes("Confirma a execução da rotina ?", "ATENÇÃO")
	Processa({|lEnd| AGCTSORC() }, "Aguarde", "Atualizando contas sem orçamento.....",.T.)
	Processa({|lEnd| PROCRPCO() }, "Aguarde", "Filtrando contas.....",.T.)
endif
return

static function PROCRPCO()
local cQuery := ""
local cQCT2  := ""
local cQAKD  := ""
local cQCT2C := ""
local cQCT2D := ""
local aCt2C  := {}
local aCT2D  := {} 
Local i

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para identificar se o filtro selecionado possui lancamentos no PCO...
//Caso negativo emite um alerta ao usuario...
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
cQuery := " SELECT COUNT(*) NREG FROM AKD010 WHERE D_E_L_E_T_ = ' ' and AKD_FILIAL between '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
cQuery += " Substring(AKD_DATA,1,6)='"+MV_PAR01+MV_PAR02+"' AND AKD_CO between ' ' AND 'ZZZZZZZZZZZZ' AND " 
//cQuery += " AKD_CO = '4510419' AND "
cQuery += " AKD_TPSALD ='OR' " 
Memowrite('c:\temp\queryCOUNT.txt', cQuery)
if Select("TMPAKD") > 0
	dbSelectArea("TMPAKD")
	TMPAKD->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", tcGenQry(,, cQuery), 'TMPAKD', .T., .T.)

ncount:= 0
dbSelectArea('TMPAKD')
TMPAKD->(dbGotop())
while !TMPAKD->(eof())
	nCount++
	TMPAKD->(dbSkip())
enddo
if nCount == 0
	Alert('O Filtro Selecionado nao possui movimentos no PCO....')
	Return .F.
endif
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Fim da rotina para identificar se o filtro selecionado possui lancamentos no PCO...
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para excluir os lancamentos já realizados no periodo conforme filtro selecionado
//Após essa exclusao o sistema vai recalcular a movimentacao com as informacoes atualizadas
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
cQuery := " UPDATE "+RetSqlName("AKD")+" SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_, AKD_HIST = 'EXCLUIDO POR '"+"' "+UsrRetname(RetCodUsr())+"' " 
cQuery += " WHERE D_E_L_E_T_ = ' ' and AKD_FILIAL between '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
cQuery += " Substring(AKD_DATA,1,6)='"+MV_PAR01+MV_PAR02+"' AND " //AKD_CO between '"+SUBSTR(MV_PAR05,1,12)+"' AND '"+SUBSTR(MV_PAR06,1,12)+"' AND " 
//cQuery += " AKD_CO = '4510419' AND "
cQuery += " AKD_TPSALD ='CO' "  //CO = CONTABIL
                             
nret1:= TcSqlExec(cQuery) //Executa a query de exclusao...

if Select("TMPAKD") > 0
	dbSelectArea("TMPAKD")
	TMPAKD->(dbCloseArea())
endif
//dbUseArea(.T., "TOPCONN", tcGenQry(,, cQuery), "TMPAKD", .T.,.T.)

//alert('Excluindo....')

//dbSelectArea('TMPAKD')

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Fim rotina para excluir os lancamentos já realizados no periodo conforme filtro selecionado
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para filtrar as contas que possuem orçamento no periodo selecionado pelo usuario
//É baseado no filtro do que foi orçado que o sistema vai analisar o realizado...
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
cQAKD := " Select Substring(AKD_FILIAL,1,2) AKD_FILIAL, AKD_STATUS, AKD_LOTE,   AKD_ID, AKD_DATA, Substring(AKD_CO,1,7) AKD_CO, "
cQAKD += " AKD_CLASSE, AKD_OPER, AKD_TIPO, AKD_TPSALD, AKD_HIST, AKD_IDREF, AKD_PROCES, "
cQAKD += " AKD_CHAVE, AKD_ITEM, AKD_SEQ, AKD_USER, AKD_COSUP, AKD_VALOR1, AKD_VALOR2, AKD_VALOR3, AKD_VALOR4, "
cQAKD += " AKD_VALOR5, AKD_CODPLA, AKD_VERSAO, Substring(AKD_CC,1,6) AKD_CC, AKD_ITCTB, AKD_CLVLR, AKD_LCTBLQ, AKD_FILORI, "
cQAKD += " AKD_UNIORC , AKD_X_CVAL "
cQAKD += " from AKD010 " 
cQAKD += " WHERE D_E_L_E_T_ = ' ' and AKD_FILIAL between '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
cQAKD += " Substring(AKD_DATA,1,6)='"+MV_PAR01+MV_PAR02+"' AND " //AKD_CO between '"+SUBSTR(MV_PAR05,1,12)+"' AND '"+SUBSTR(MV_PAR06,1,12)+"' AND " 
//cQAKD += " AKD_CO = '4510419' AND "
cQAKD += " AKD_TPSALD ='OR' " 

Memowrite('c:\temp\queryAKD.txt', cQAKD)
if Select("TMPAKD") > 0 
	dbSelectArea("TMPAKD")
	TMPAKD->(dbCloseArea())
endif
dbUseArea(.T., 'TOPCONN', tcGenQry(,, cQAKD), 'TMPAKD', .T., .T.)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Fim da rotina de Filtro do orçado conforme periodo selecionado
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para filtrar as contas de debitos referente ao realizado no contabil
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
cQCT2D := " Select Substring(CT2_ITEMD,1,2) CT2_FILIAL, Substring(CT2_DEBITO,1,7) CT2_DEBITO, Substring(CT2_CCD,1,6) CT2_CCD, Sum(CT2_VALOR) VALORD from CT2010 "
cQCT2D += " WHERE D_E_L_E_T_ = ' ' and CT2_ITEMD between '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
cQCT2D += " Substring(CT2_DATA,1,6)='"+MV_PAR01+MV_PAR02+"' AND Substring(CT2_DEBITO,1,3) in ('351','352','361','362','451','452') " 
//cQCT2D += " AND CT2_DEBITO = '4510419' "
cQCT2D += " GROUP BY CT2_ITEMD, CT2_DEBITO, CT2_CCD " 
cQCT2D += " ORDER BY 1, 2, 3 " 
Memowrite('c:\temp\queryDEB.txt', cQCT2D)
if Select("CT2D") > 0
	dbSelectArea("CT2D")
	CT2D->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQCT2D), "CT2D", .T., .T.)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Fim da rotina de Filtro do realizado de debito no periodo selecionado
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para filtrar as contas de creditos referente ao realizado no contabil
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
cQCT2C := " Select Substring(CT2_ITEMC,1,2) CT2_FILIAL, Substring(CT2_CREDIT,1,7) CT2_CREDIT, Substring(CT2_CCC,1,6) CT2_CCC, Sum(CT2_VALOR) VALORC from CT2010 " 
cQCT2C += " WHERE D_E_L_E_T_ = ' ' and CT2_ITEMC between '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
cQCT2C += " Substring(CT2_DATA,1,6)='"+MV_PAR01+MV_PAR02+"' and SUbstring(CT2_CREDIT,1,3) in ('351','352','361','362','451','452') " 
//cQCT2C += " AND CT2_CREDIT = '4510419' " 
cQCT2C += " GROUP BY CT2_ITEMC, CT2_CREDIT, CT2_CCC " 
cQCT2C += " ORDER BY 1, 2, 3 "

Memowrite('c:\temp\queryCRED.txt', cQCT2C)
if Select("CT2C") > 0
	dbSelectArea("CT2C")
	CT2C->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(,, cQCT2C), "CT2C", .T., .T.)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Fim da rotina de Filtro do realizado de credito no periodo selecionado
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para gravar os debitos e os creditos no array e preparar o processametno

//DEBITO
dbSelectArea("CT2D")
CT2D->(dbGotop())
while !CT2D->(eof())
	aAdd( aCT2D, {ALLTRIM(CT2D->CT2_FILIAL)+ALLTRIM(CT2D->CT2_DEBITO)+ALLTRIM(CT2D->CT2_CCD), CT2D->VALORD, 'N' })
	CT2D->(dbSkip())
enddo

//CREDITO
dbSelectArea("CT2C")
CT2C->(dbGotop())
while !CT2C->(eof())
	aAdd( aCT2C, {ALLTRIM(CT2C->CT2_FILIAL)+ALLTRIM(CT2C->CT2_CREDIT)+ALLTRIM(CT2C->CT2_CCC), CT2C->VALORC, 'N' })
	CT2C->(dbSkip())
enddo


aCT2D := aSort( aCT2D,,, { |x, y| x[1] < y[1] } )
aCT2C := aSort( aCT2C,,, { |x, y| x[1] < y[1] } )

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Rotina para varrer toda as contas que tiveram orçamento e identificar o que foi realizado na contabilidade
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	dbSelectArea("TMPAKD")
	TMPAKD->(dbGotop())
	ncount:=0
	while !TMPAKD->(eof())
/*		if ALLTRIM(TMPAKD->AKD_CO) == '3521069'
			for i:=1 to len(aCT2D)
				if Substr(aCT2D[i][1],3,7) == '3521069'
					Alert("Buscando INformação: "+chr(13)+"|"+ALLTRIM(TMPAKD->(AKD_FILIAL+AKD_CO+AKD_CC))+"|";
						+chr(13)+"|"+aCT2D[i][1]+"|" )
				endif
			next i
		endif */
		nPosD	:= ASCAN(aCT2D, {|x| x[1]== ALLTRIM(TMPAKD->AKD_FILIAL)+ALLTRIM(TMPAKD->AKD_CO)+ALLTRIM(TMPAKD->AKD_CC)})
		nPosC   := ASCAN(aCT2C, {|x| x[1]== ALLTRIM(TMPAKD->AKD_FILIAL)+ALLTRIM(TMPAKD->AKD_CO)+ALLTRIM(TMPAKD->AKD_CC)})
		nVDeb   := 0
		nVCred  := 0
		
		if nPosD > 0
			nVDeb := aCT2D[nPosD][2]
			aCT2D[nPosD][3] := 'S'
		endif
		
		if nPosC > 0
			nVCred := aCT2C[nPosC][2]
			aCT2C[nPosC][3] := 'S' 
		endif
	  	cVSald := nVDeb - nVCred
	  	
		///////////////////////////////////////////////////////////////////////////////
		//Rotina para buscar o ultimo ID registrado na filial
		///////////////////////////////////////////////////////////////////////////////
		cQID := " Select MAX(AKD_ID) cID from AKD010 "
		cQID += " where D_E_L_E_T_ =' ' and AKD_FILIAL = '"+TMPAKD->AKD_FILIAL+"'" 
		
		if Select("TMPID") > 0 
			dbSelectArea("TMPID")
			TMPID->(dbCloseArea())
		endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry( , , cQID), "TMPID", .T.,.T.)
		dbSelectArea("TMPID")
		TMPID->(dbGotop())
		
		cID := TMPID->cID
		cID1 := Soma1(cID)
	
		
	  	
		RecLock("AKD",.T.)
		AKD->AKD_FILIAL := TMPAKD->AKD_FILIAL
		AKD->AKD_STATUS := '1' //AKD->AKD_STATUS
		AKD->AKD_LOTE   := TMPAKD->AKD_FILIAL+Substr(TMPAKD->AKD_LOTE,3,8)
		AKD->AKD_ID     := cID1 //TMPAKD->AKD_ID
		AKD->AKD_DATA   := sToD(TMPAKD->AKD_DATA)
		AKD->AKD_CO		:= TMPAKD->AKD_CO
		AKD->AKD_CLASSE := TMPAKD->AKD_CLASSE
		AKD->AKD_OPER   := TMPAKD->AKD_OPER
		AKD->AKD_TIPO 	:= "1"
		AKD->AKD_TPSALD	:= "CO"
		AKD->AKD_HIST	:= "SALDO CONTABIL CONTA "+TMPAKD->AKD_CO
		AKD->AKD_IDREF	:= ""
		AKD->AKD_PROCES	:= "000082"
		AKD->AKD_CHAVE	:= "CT2"+TMPAKD->AKD_FILIAL+"REALIZADO"+Substr(TMPAKD->AKD_CHAVE,15,Len(ALLTRIM(TMPAKD->AKD_CHAVE))-15)
		AKD->AKD_ITEM	:= TMPAKD->AKD_ITEM
		AKD->AKD_SEQ 	:= TMPAKD->AKD_SEQ
		AKD->AKD_USER	:= TMPAKD->AKD_USER
		AKD->AKD_COSUP	:= TMPAKD->AKD_COSUP
		AKD->AKD_VALOR1	:= cVSald
		AKD->AKD_VALOR2	:= TMPAKD->AKD_VALOR2
		AKD->AKD_VALOR3	:= TMPAKD->AKD_VALOR3
		AKD->AKD_VALOR4	:= TMPAKD->AKD_VALOR4
		AKD->AKD_VALOR5	:= TMPAKD->AKD_VALOR5
		AKD->AKD_CODPLA	:= TMPAKD->AKD_CODPLA
		AKD->AKD_VERSAO := TMPAKD->AKD_VERSAO
		AKD->AKD_CC		:= TMPAKD->AKD_CC
		AKD->AKD_ITCTB	:= TMPAKD->AKD_ITCTB
		AKD->AKD_CLVLR	:= TMPAKD->AKD_CLVLR
		AKD->AKD_LCTBLQ	:= TMPAKD->AKD_LCTBLQ
		AKD->AKD_FILORI	:= TMPAKD->AKD_FILORI
		AKD->AKD_UNIORC	:= TMPAKD->AKD_UNIORC
		AKD->AKD_X_CVAL	:= TMPAKD->AKD_X_CVAL
		
		MsUnLock("AKD")
		ncount++
		TMPAKD->(dbSkip())
	enddo

//Vefiricar as contas que nao tiveram valores orçados...
aCT2DC := {}
for i:= 1 to len(aCT2D)
	if aCT2D[i][3] == 'N'
		AADD( aCT2DC, {aCT2D[i][1], aCT2D[i][2], 'D'} )
	endif
next i

for i:= 1 to len(aCT2C)
	if aCT2C[i][3] == 'N'
		AADD( aCT2DC, {aCT2C[i][1], aCT2C[i][2], 'C'} )
	endif
next i 

aCT2AUX := {}
cCTDupl := ""
//////////////////////////////
//Gerar Orçamento de Contas
//não orçadas
//////////////////////////////
nCtDpl := 0
for i:= 1 to len(aCT2DC)
   if cCTDupl <> aCT2DC[1][1]
   		nCtDpl++
		AADD( aCT2AUX, {aCT2DC[i][1], aCT2DC[i][2]})
   endif
   cCTDupl := aCT2DC[1][1]
next i 
//AG_GERAPCO(aCT2AUX)

if len(aCT2DC) > 0
	if ApMsgNoYes("Rotina encerrada com "+cValToChar(ncount)+" valores orçados"+chr(13)+;
		" e "+cValToChar(len(aCT2DC))+ " registros contabilizados sem orçamento..." +chr(13)+"Deseja gerar esses arquivos em txt ? ","Atençao")
		cIt := ""
		aCT2DC := aSort( aCT2DC,,, { |x, y| x[1] < y[1] } )
		
		//Rotina para eliminar contas que tem DEBITO e CREDITO sem ORÇAMENTO
/*		nCtDpl := 0
		for i:= 1 to len(aCT2DC)
		   if cCTDupl <> aCT2DC[1][1]
		   		nCtDpl++
				AADD( aCT2AUX, {aCT2DC[i][1], aCT2DC[i][2]})
		   endif
		   cCTDupl := aCT2DC[1][1]
		next i 
		AG_GERAPCO(aCT2AUX) */
//		AG_GERAPCO(aCT2DC)
		for i:= 1 to len(aCT2AUX) - 1
			cIt += Substr(aCT2AUX[i][1],1,2)+";"+Substr(aCT2AUX[i][1],3,7)+";"+Substr(aCT2AUX[i][1],10,6)+";"+Str(aCT2AUX[i][2])+";"+aCT2AUX[i][3]+";"+chr(13)
		next i 
		memowrite('c:\temp\ContasSemOrcamento.txt', cIt )
		Alert("Arquivo gravado em c:\temp\ContasSemOrcamento.txt "+cValToChar(nCTDpl)+" Registros") 
	else
		Alert("Rotina encerrada com "+cValToChar(ncount)+" registros orçados e contabilizados"+chr(13)+;
		cValToChar(len(aCT2DC))+ " registros contabilizados sem orçamento...")
	endif

else
	Alert("Rotina encerrada com sucesso "+cValToChar(ncount)+" registros ")
endif
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Fim da rotina de identificao das contas que tiveram orcamento previsto
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Funçao para criar as perguntas iniciais
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
PutSx1(cPerg,"01","Informe o Ano                 ?"," "," ","mv_ch1","C",4,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Ano para calcular"},{"Informe o Ano para calcular"},{"Informe o Ano para calcular"})
PutSx1(cPerg,"02","Informe o mês                 ?"," "," ","mv_ch2","C",2,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Mês para calcular"},{"Informe o Mês para calcular"},{"Informe o Mês para calcular"})
PutSx1(cPerg,"03","Filial de                     ?"," "," ","mv_ch3","C",2,0,0,	"G","","   ","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a filial inicial   "},{"Informe a filial inicial   "},{"Informe a filial inicial   "})
PutSx1(cPerg,"04","Filial até                    ?"," "," ","mv_ch4","C",2,0,0,	"G","","   ","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a filial final     "},{"Informe a filial final     "},{"Informe a filial final     "})
//PutSx1(cPerg,"05","Conta Contabil de             ?"," "," ","mv_ch5","C",20,0,0,"G","","CT1","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a conta inicial    "},{"Informe a conta inicial    "},{"Informe a conta inicial    "})
//PutSx1(cPerg,"06","Conta Contabil até            ?"," "," ","mv_ch6","C",20,0,0,"G","","CT1","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a conta final      "},{"Informe a conta final      "},{"Informe a conta final      "})
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


//Funcao para verificar os itens que vao gravar novo PCO
static function AG_GERAPCO(aCT2)
local _aCT2 := aCT2
Local i

	for i := 1 to len(_aCT2)
		if Substr(_aCT2[i][1],10,6) <> space(6)
			AG_GRAVAREG(Substr(aCT2DC[i][1],1,2), Substr(aCT2DC[i][1],3,7), Substr(aCT2DC[i][1],10,6))
		endif
	next i 
return

//Funcao para gravar os itens no PCO
static function AG_GRAVAREG(cxfilial, cCContab, cCusto)
local cQAKD := ""

//Query para filtrar o ultimo registro gravado na tabela AKD como orçamento
cQAKD := " Select Max(R_E_C_N_O_) NREG from "+RetSQLNAME("AKD")+ " AKD WHERe D_E_L_E_T_ =' ' and AKD_TPSALD = 'OR' " 
cQAKD += " and AKD_FILIAL ='"+cxFilial+"' "

if Select("TMPAKD") > 0 
	dbSelectArea("TMPAKD")
	TMPAKD->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQAKD), "TMPAKD", .T., .T.)

//Query para pegar o ultimo ID gerado na AKD 
cQID := " SELECT MAX(AKD_ID) IDMAX FROM "+RetSQLNAME("AKD")+" AKD WHERE D_E_L_E_T_ = ' ' "
if Select("AKDID") > 0 
	dbSelectArea("AKDID")
	AKDID->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(, , cQID), "AKDID", .T., .T.) 

dbSelectArea("TMPAKD")
TMPAKD->(dbGotop())

dbSelectArea("AKDID")
AKDID->(dbGotop())

cUltID := AKDID->IDMAX

dbSelectArea("AKD")
AKD->(dbGoto(TMPAKD->NREG))

cStatus := AKD->AKD_STATUS
cLote   := AKD->AKD_LOTE
cId     := SOMA1(cULTID)
cChave  := SOMA1(AKD->AKD_CHAVE)
cItem   := AKD->AKD_ITEM
cSeq    := AKD->AKD_SEQ

RecLock("AKD", .T.)
	AKD->AKD_FILIAL := cxfilial
	AKD->AKD_STATUS := cStatus
	AKD->AKD_LOTE   := cLote
	AKD->AKD_ID	    := cId
	AKD->AKD_DATA   := stod(mv_par01+mv_par02+'01')
	AKD->AKD_CO     := cCContab
	AKD->AKD_CLASSE := '000001'
	AKD->AKD_OPER    := 'RECEITA'
	AKD->AKD_TIPO   := "1"
	AKD->AKD_TPSALD := 'OR'
	AKD->AKD_HIST   := 'GERADO PELA ROTINA AG_SLDCTPCO'
	AKD->AKD_PROCES := '000252'
	AKD->AKD_CHAVE  := cChave
	AKD->AKD_ITEM   := cItem
	AKD->AKD_SEQ    := cSeq
	AKD->AKD_COSUP  := Substr(cCContab,1,5)
	AKD->AKD_VALOR1 := 0.01
	AKD->AKD_CODPLA := 'ORCAMENTO 2015 AG_SLDCTPCO'
	AKD->AKD_VERSAO := '0001'
	AKD->AKD_CC     := cCusto
	AKD->AKD_ITCTB  := cxFilial
	AKD->AKD_CLVLR  := '000001'
	AKD->AKD_FILORI := cxFilial
MsUnLock("AKD")

return

return 


//Função para identificar contas sem orçamento
Static function AGCTSORC()
local cQConta := ""
local nctx1  := 0

cQConta := " SELECT DISTINCT FILIAL, CONTA, CCUSTO FROM " 
cQConta += " (Select Substring(CT2_ITEMC,1,2) FILIAL, Substring(CT2_CREDIT,1,7) CONTA, CT2_CCC CCUSTO "
cQConta += " from CT2010  WHERE D_E_L_E_T_ = ' ' and CT2_ITEMC between '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND  Substring(CT2_DATA,1,6)='"+MV_PAR01+MV_PAR02+"' "
cQConta += " and SUbstring(CT2_CREDIT,1,3) in ('351','352','361','362','451','452')  "
cQConta += " GROUP BY CT2_ITEMC, CT2_CREDIT, CT2_CCC "
cQConta += " UNION ALL "
cQConta += " Select Substring(CT2_ITEMD,1,2) FILIAL, Substring(CT2_DEBITO,1,7) CONTA, CT2_CCD CCUSTO "
cQConta += " from CT2010  WHERE D_E_L_E_T_ = ' ' and CT2_ITEMD between '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND  Substring(CT2_DATA,1,6)='"+MV_PAR01+MV_PAR02+"' "
cQConta += " AND Substring(CT2_DEBITO,1,3) in ('351','352','361','362','451','452') "
cQConta += " GROUP BY CT2_ITEMD, CT2_DEBITO, CT2_CCD) CONTMOV "
cQConta += " ORDER BY 1, 2, 3 " 

	if Select("TMPCT") > 0 
		dbSelectArea("TMPCT")
		TMPCT->(dbCloseArea())
	endif
dbUseArea(.T., "TOPCONN", TcGenQry(,, cQConta), "TMPCT", .T., .T.)

dbSelectArea("TMPCT")
TMPCT->(dbGotop())

cAKD1 := ""
ProcRegua(0)
while !TMPCT->(eof())
	cAKD1 := " Select Count(*) NREG from AKD010 with (nolock) "
	cAKD1 += " WHERE D_E_L_E_T_ = ' ' AND Substring(AKD_CO,1,7) = '"+TMPCT->CONTA+"' AND Substring(AKD_CC,1,6) = '"+TMPCT->CCUSTO+"' AND Substring(AKD_FILIAL,1,2)='"+TMPCT->FILIAL+"' " 
	cAKD1 += " and Substring(AKD_DATA,1,6)='"+MV_PAR01+MV_PAR02+"' "
	cAKD1 += " and AKD_TPSALD = 'OR' "

	if Select("TMPKD")>0
		dbSelectArea("TMPKD")
		TMPKD->(dbCLoseArea())
	endif
	dbUseArea(.T., "TOPCONN", TcGenQry(,, cAKD1), "TMPKD", .T., .T.)
	
	dbSelectArea("TMPKD")
	TMPKD->(dbGotop())
	
	if TMPKD->NREG == 0 
	  	Processa({|lEnd| AG_GRAVAREG(TMPCT->FILIAL, TMPCT->CONTA, TMPCT->CCUSTO) }, "Aguarde", "Filtrando contas.....",.T.)
	  	nctx1++
	endif
	IncProc("Atualizando conta --> "+ALLTRIM(TMPCT->CONTA)+ " cc "+ALLTRIM(TMPCT->CCUSTO)+ " qtde atualização "+cValToChar(nctx1))
	TMPCT->(dbSkip())
enddo
//Alert("Atualizado "+cValToChar(nctx1)+" contas que não tinham orçamento...")
return