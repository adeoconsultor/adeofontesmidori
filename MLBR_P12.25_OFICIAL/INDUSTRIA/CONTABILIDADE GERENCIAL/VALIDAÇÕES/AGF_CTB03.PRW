#Include 'Protheus.ch'
#Include 'rwmake.ch'
///////////////////////////////////////////////////////////////////////////////////////////////////////
//Função desenvolvida para contabilizar o credito da mao de obra do periodo para a conta 3910501
//conforme solicitacao passada pelo Sr.Mauri em 24-01-2012.
//Retorna a soma dos lancamentos das contas no intervalo de 3510202 até 3510313
//O Total será creditado na conta 3910501 e debitado na conda B1_X_ESTMP
//Desenvolvido por Anesio G.Faria - TAGGs Consultoria - agfaria@taggs.com.br angfaria@hotmail.com
//24-01-2012
///////////////////////////////////////////////////////////////////////////////////////////////////////
user function AGF_CT03() 
local cQCT2 	:= "" // Query que vai filtrar os movimentos do CT2 por conta
local cQSD3     := "" // Query que vai filtrar os movimentos via TM 501 que ainda nao foram contabilizados e fazer o rateio conforme padrao definido
local nValor    := 0

If Select("TRBCT2") > 0
	DbSelectArea("TRBCT2")
	DbCloseArea()
Endif            

If Select("TRBSD3") > 0 
	DbSelectArea("TRBSD3")
	DbCloseArea()
Endif

///////////////////////////////////////////////////////////////////////////////////////////////////////
//Faz a consulta para pegar o valor do debito
///////////////////////////////////////////////////////////////////////////////////////////////////////
cQCT2 := " select Substring(CT2_DATA,1,6) CT2_DATA, Sum(CT2_VALOR) CT2_VALOR from CT2010 "
cQCT2 += " where D_E_L_E_T_ = ' ' and CT2_DEBITO between '3510101' and '3510313' "
cQCT2 += " and Substring(CT2_DATA,1,6)= '"+Substr(dtos(dDatabase),1,6)+"' "
cQCT2 += " and CT2_FILIAL = '"+xFilial('CT2')+"'     
cQCT2 += " Group by Substring(CT2_DATA,1,6) " 

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQCT2),"TRBCT2",.T.,.T.)

dbSelectArea('TRBCT2')

//grava o debito na variavel nValor
nValor := TRBCT2->CT2_VALOR

If Select("TRBCT2") > 0
	DbSelectArea("TRBCT2")
	DbCloseArea()
Endif

///////////////////////////////////////////////////////////////////////////////////////////////////////
//Faz a consulta para pegar o valor do credito
///////////////////////////////////////////////////////////////////////////////////////////////////////
cQCT2 := " select Substring(CT2_DATA,1,6) CT2_DATA, Sum(CT2_VALOR) CT2_VALOR from CT2010 "
cQCT2 += " where D_E_L_E_T_ = ' ' and CT2_CREDIT between '3510101' and '3510313' "
cQCT2 += " and Substring(CT2_DATA,1,6)= '"+Substr(dtos(dDatabase),1,6)+"' "
cQCT2 += " and CT2_FILIAL = '"+xFilial('CT2')+"'     
cQCT2 += " Group by Substring(CT2_DATA,1,6) " 

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQCT2),"TRBCT2",.T.,.T.)

dbSelectArea('TRBCT2')


nValor := nValor - TRBCT2->CT2_VALOR

////////////////////////////////////////////////////////////////////////////////////////////////////////
//Query para buscar os movimentos do SD3 via TM 501 "REQUISICAO AO ARMAZEM" 
////////////////////////////////////////////////////////////////////////////////////////////////////////
cQSD3 := " Select Sum(D3_CUSTO1) D3_CUSTO1 from SD3010 "
cQSD3 += " where D_E_L_E_T_ = ' '  "
cQSD3 += " and Substring(D3_EMISSAO,1,6)= '"+Substr(dtos(dDatabase),1,6)+"' "
cQSD3 += " and D3_TM = '501' "
cQSD3 += " and D3_OP = space(13) "
cQSD3 += " and (D3_DTLANC = space(8) or D3_DTLANC = '"+dtos(dDatabase)+"') "
cQSD3 += " and D3_FILIAL = '"+xFilial("SD3")+"' "
cQSD3 += " and D3_GRUPO in ('71','72','75','91','99') "

dbUseArea(.T.,"TOPCONN",TcGenQry(,, cQSD3),"TRBSD3",.T.,.T.)

dbSelectArea('TRBSD3')

//nValor+= TRBSD3->D3_CUSTO1

return nValor                                   
///////////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////////////////////////////
//Funcao para calcular o rateio do valor
///////////////////////////////////////////////////////////////////////////////////////////////////////
user function AGF_CL01(nVlrARat, nQtde)
local _nVlrARat := nVlrARat
local nTotPrd   := 0
local cQD3 		:= "" 

If Select('TRBD3') > 0 
	DbSelectArea('TRBD3') 
	DbCloseArea()
Endif

cQD3 := " SELECT SUM(D3_QUANT) D3_QUANT FROM SD3010 SD3, SB1010 SB1 "
cQD3 += " WHERE SD3.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' "
cQD3 += " AND D3_COD = B1_COD AND SUBSTRING(D3_EMISSAO,1,6)='"+Substr(dtos(dDatabase),1,6)+"' "
cQD3 += " AND SUBSTRING(B1_X_ESTMP,1,5)='31101' AND D3_TM = '500' "  
cQD3 += " AND D3_FILIAL = '"+xFilial('SD3')+"' AND B1_FILIAL = '"+xFilial('SB1')+"' "

dbUseArea(.T.,"TOPCONN", TcGenQry(,, cQD3), "TRBD3",.T.,.T.)
dbSelectArea("TRBD3")

nTotPrd := (nQtde / TRBD3->D3_QUANT) * _nVlrARat
nTotPrd := Round(nTotPrd,2)
//Alert('Chamou a funcao - Qdte--> '+cValToChar(nQtde)+' D3_QUANT: '+cValToChar(TRBD3->D3_QUANT)+' Vlr a Rat-> '+cValToChar(_nVlrARat))
//Alert('TM-> '+SD3->D3_TM+'-'+SD3->D3_CF+' Retorno--> '+cValToChar(nTotPrd))

return nTotPrd
///////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////////////
//Função desenvolvida para contabilizar outras gastos diretos de fabricacao. 
//conforme solicitacao passada pelo Sr.Mauri em 24-01-2012.
//Retorna a soma dos lancamentos das contas no intervalo de 3510414 até 3521554
//O Total será creditado na conta 3910502 e debitado na conda B1_X_ESTMP
//Desenvolvido por Anesio G.Faria - TAGGs Consultoria - agfaria@taggs.com.br angfaria@hotmail.com
//25-01-2012
///////////////////////////////////////////////////////////////////////////////////////////////////////
user function AGF_CT04() 
local cQCT2 	:= "" // Query que vai filtrar os movimentos do CT2 por conta
local nValor    := 0

If Select("TRBCT2") > 0
	DbSelectArea("TRBCT2")
	DbCloseArea()
Endif

///////////////////////////////////////////////////////////////////////////////////////////////////////
//Faz a consulta para pegar o valor do debito
///////////////////////////////////////////////////////////////////////////////////////////////////////
cQCT2 := " select Substring(CT2_DATA,1,6) CT2_DATA, Sum(CT2_VALOR) CT2_VALOR from CT2010 "
cQCT2 += " where D_E_L_E_T_ = ' ' and CT2_DEBITO between '3510414' and '3521554' "
cQCT2 += " and Substring(CT2_DATA,1,6)= '"+Substr(dtos(dDatabase),1,6)+"' "
cQCT2 += " and CT2_FILIAL = '"+xFilial('CT2')+"'     
cQCT2 += " Group by Substring(CT2_DATA,1,6) " 


dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQCT2),"TRBCT2",.T.,.T.)

dbSelectArea('TRBCT2')
//Grava a soma do debito na variavel nValor
nValor := TRBCT2->CT2_VALOR


If Select("TRBCT2") > 0
	DbSelectArea("TRBCT2")
	DbCloseArea()
Endif

///////////////////////////////////////////////////////////////////////////////////////////////////////
//Faz a consulta para pegar o valor do credito
///////////////////////////////////////////////////////////////////////////////////////////////////////
cQCT2 := " select Substring(CT2_DATA,1,6) CT2_DATA, Sum(CT2_VALOR) CT2_VALOR from CT2010 "
cQCT2 += " where D_E_L_E_T_ = ' ' and CT2_CREDIT between '3510414' and '3521554' "
cQCT2 += " and Substring(CT2_DATA,1,6)= '"+Substr(dtos(dDatabase),1,6)+"' "
cQCT2 += " and CT2_FILIAL = '"+xFilial('CT2')+"'     
cQCT2 += " Group by Substring(CT2_DATA,1,6) " 


dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQCT2),"TRBCT2",.T.,.T.)

dbSelectArea('TRBCT2')
//Grava a soma do debito na variavel nValor
nValor := nValor - TRBCT2->CT2_VALOR

return nValor                                   
///////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////
//Função desenvolvida para contabilizar gastos indiretos de fabricacao. 
//conforme solicitacao passada pelo Sr.Mauri em 24-01-2012.
//Retorna a soma dos lancamentos das contas no intervalo de 3610101 até 3610313
//O Total será creditado na conta 3910601 e debitado na conda B1_X_ESTMP
//Desenvolvido por Anesio G.Faria - TAGGs Consultoria - agfaria@taggs.com.br angfaria@hotmail.com
//25-01-2012
///////////////////////////////////////////////////////////////////////////////////////////////////////
user function AGF_CT05() 
local cQCT2 	:= "" // Query que vai filtrar os movimentos do CT2 por conta
local nValor    := 0

If Select("TRBCT2") > 0
	DbSelectArea("TRBCT2")
	DbCloseArea()
Endif

///////////////////////////////////////////////////////////////////////////////////////////////////////
//Faz a consulta para pegar o valor do debito
///////////////////////////////////////////////////////////////////////////////////////////////////////
cQCT2 := " select Substring(CT2_DATA,1,6) CT2_DATA, Sum(CT2_VALOR) CT2_VALOR from CT2010 "
cQCT2 += " where D_E_L_E_T_ = ' ' and CT2_DEBITO between '3610101' and '3610313' "
cQCT2 += " and Substring(CT2_DATA,1,6)= '"+Substr(dtos(dDatabase),1,6)+"' "
cQCT2 += " and CT2_FILIAL = '"+xFilial('CT2')+"'     
cQCT2 += " Group by Substring(CT2_DATA,1,6) " 

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQCT2),"TRBCT2",.T.,.T.)

dbSelectArea('TRBCT2')

nValor := TRBCT2->CT2_VALOR

If Select("TRBCT2") > 0
	DbSelectArea("TRBCT2")
	DbCloseArea()
Endif


///////////////////////////////////////////////////////////////////////////////////////////////////////
//Faz a consulta para pegar o valor do credito
///////////////////////////////////////////////////////////////////////////////////////////////////////
cQCT2 := " select Substring(CT2_DATA,1,6) CT2_DATA, Sum(CT2_VALOR) CT2_VALOR from CT2010 "
cQCT2 += " where D_E_L_E_T_ = ' ' and CT2_CREDIT between '3610101' and '3610313' "
cQCT2 += " and Substring(CT2_DATA,1,6)= '"+Substr(dtos(dDatabase),1,6)+"' "
cQCT2 += " and CT2_FILIAL = '"+xFilial('CT2')+"'     
cQCT2 += " Group by Substring(CT2_DATA,1,6) " 

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQCT2),"TRBCT2",.T.,.T.)

dbSelectArea('TRBCT2')
//Subtrai o debito x credito
nValor := nValor - TRBCT2->CT2_VALOR

return nValor                                   
///////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////////////
//Função desenvolvida para contabilizar outros gastos indiretos de fabricacao. 
//conforme solicitacao passada pelo Sr.Mauri em 24-01-2012.
//Retorna a soma dos lancamentos das contas no intervalo de 3610414 até 3621554
//O Total será creditado na conta 3910602 e debitado na conda B1_X_ESTMP
//Desenvolvido por Anesio G.Faria - TAGGs Consultoria - agfaria@taggs.com.br angfaria@hotmail.com
//25-01-2012
///////////////////////////////////////////////////////////////////////////////////////////////////////
user function AGF_CT06() 
local cQCT2 	:= "" // Query que vai filtrar os movimentos do CT2 por conta
local nValor    := 0

If Select("TRBCT2") > 0
	DbSelectArea("TRBCT2")
	DbCloseArea()
Endif

///////////////////////////////////////////////////////////////////////////////////////////////////////
//Faz a consulta para pegar o valor do debito
///////////////////////////////////////////////////////////////////////////////////////////////////////
cQCT2 := " select Substring(CT2_DATA,1,6) CT2_DATA, Sum(CT2_VALOR) CT2_VALOR from CT2010 "
cQCT2 += " where D_E_L_E_T_ = ' ' and CT2_DEBITO between '3610414' and '3621554' "
cQCT2 += " and Substring(CT2_DATA,1,6)= '"+Substr(dtos(dDatabase),1,6)+"' "
cQCT2 += " and CT2_FILIAL = '"+xFilial('CT2')+"'     
cQCT2 += " Group by Substring(CT2_DATA,1,6) " 

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQCT2),"TRBCT2",.T.,.T.)

dbSelectArea('TRBCT2')

nValor := TRBCT2->CT2_VALOR

If Select("TRBCT2") > 0
	DbSelectArea("TRBCT2")
	DbCloseArea()
Endif

///////////////////////////////////////////////////////////////////////////////////////////////////////
//Faz a consulta para pegar o valor do credito
///////////////////////////////////////////////////////////////////////////////////////////////////////
cQCT2 := " select Substring(CT2_DATA,1,6) CT2_DATA, Sum(CT2_VALOR) CT2_VALOR from CT2010 "
cQCT2 += " where D_E_L_E_T_ = ' ' and CT2_CREDIT between '3610414' and '3621554' "
cQCT2 += " and Substring(CT2_DATA,1,6)= '"+Substr(dtos(dDatabase),1,6)+"' "
cQCT2 += " and CT2_FILIAL = '"+xFilial('CT2')+"'     
cQCT2 += " Group by Substring(CT2_DATA,1,6) " 

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQCT2),"TRBCT2",.T.,.T.)

dbSelectArea('TRBCT2')
//Substrai debito x credito
nValor := nValor - TRBCT2->CT2_VALOR

return nValor 



///////////////////////////////////////////////////////////////////////////////////////////////////////
//Função desenvolvida para contabilizar as transferencias de produtos 
//conforme solicitacao passada pelo Sr.Mauri em 23-02-2012.
//Verifica se na transferencia de produtos a conta B1_CONTA de destino eh <> de B1_CONTA da origem
//soh sera contabilizado caso satisfaca a condicao acima
//Desenvolvido por Anesio G.Faria - TAGGs Consultoria - agfaria@taggs.com.br angfaria@hotmail.com
//23-02-2012
///////////////////////////////////////////////////////////////////////////////////////////////////////
user function AGF_CT07(cNumSeq, cProd) 
local _cNumSeq := cNumSeq
local lRet := .F. 
local cConta := "" 
local cQD3    := "" 

if Select('TRBD3') > 0
	dbSelectArea('TRBD3')
	TRBD3->(dbCloseArea())
endif

//cQD3 := " SELECT D3_COD, D3_CF, B1_CONTA FROM SD3010 SD3, SB1010 SB1 " 
//cQD3 += " WHERE SD3.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' " 
//cQD3 += " AND D3_COD = B1_COD AND D3_FILIAL = '"+xFilial("SD3")+"' " 
//cQD3 += " AND D3_NUMSEQ = '"+_cNumSeq+"' " 
//cQD3 += " AND B1_FILIAL = '"+xFilial("SB1")+"' " 
//cQD3 += " ORDER BY SD3.R_E_C_N_O_ " 

cQD3 := " SELECT DISTINCT D3_CONTA FROM SD3010 WHERE D_E_L_E_T_ = ' ' AND D3_FILIAL = '"+xFilial("SD3")+"' " 
cQD3 += " AND D3_NUMSEQ = '"+_cNumSeq+"' " 
cQD3 += " GROUP BY D3_CONTA " 


dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQD3),"TRBD3",.T.,.T.)
nCount:= 0 
dbSelectArea('TRBD3')
dbGotop()
while !TRBD3->(eof())
 nCount++
 TRBD3->(dbSkip())
enddo

if nCount > 1 
 lRet := .T.
endif 
	
/*cConta := TRBD3->B1_CONTA
while !TRBD3->(eof())    
//	Alert('B1_CONTA-> ' +TRBD3->B1_CONTA)
	if TRBD3->B1_CONTA <> cConta 
	 	lRet :=.T.
	endif
	
	TRBD3->(dbSkip())
	
enddo
*/	
	

return lRet


///////////////////////////////////////////////////////////////////////////////////////////////////////
//Função desenvolvida para contabilizar as MAO DE OBRAS 
//conforme solicitacao passada pelo Sr.Mauri em 23-02-2012.
//busca a conta contabil no produto pai da ordem de producao que esta sendo utilizado na MOD
//Desenvolvido por Anesio G.Faria - TAGGs Consultoria - agfaria@taggs.com.br angfaria@hotmail.com
//23-02-2012
///////////////////////////////////////////////////////////////////////////////////////////////////////
user function AGF_CT08(cNumOP) 
local _cNumOp := Substr(cNumOp,1,6)
local cConta  := "" 

dbSelectArea("SC2")
dbSetOrder(1)
dbSeek(xFilial("SC2")+_cNumOP)

cConta := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_X_ESTMP")

return cConta