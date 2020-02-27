#include 'Protheus.ch'
#include 'rwmake.ch'


////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Função para ser utilizada nas plantas de costuras, com objetivo de transferir produto do armazem de estoque
//para o armazem de elaboração.
//Essa rotina será ativada via o parametro MA_TRFCOST, 
//Armazem Origem/Destino será identificado via parametro MA_LOCELAB Local de Elaboração
//Cadastrar MA_LOCELAB com Local de elaboraçao, o local de origem será onde está empenhado o produto
//Caso o empenho seja realizado no mesmo local da local cadastrado no parametro MA_LOCELAB, o sistema não 
//fará a transferencia
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
//
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////
*------------------------------------*
Static Function AG_TrfArm(cOpFic ,nQtde, cCodProd, cDescrPrd, cGFicha, cArmOri, cArmDes)
*------------------------------------*
//Alert("Transferencia a ser realizada ->"+chr(13)+"Documento: "+cOpFic+" qtde-> "+cValToChar(nMtTot)+" FICHA: "+cgFicha+" Produto: "+cCodProd)
aLin = {}
aCab = {}
aAdd (aCab,{ cOpFic, ddatabase})

				aadd (aLin, cCodProd) // Produto origem
				aadd (aLin, Substr(Alltrim(cDescrPrd),1,30)) // Descricao produto origem
				aadd (aLin, Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_UM")) // UM origem
				aadd (aLin, cArmOri) // Almox origem 
				aadd (aLin, '') // Endereco origem
				aadd (aLin, cCodProd) // Produto destino
				aadd (aLin, Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_DESC")) // Descricao produto origem
				aadd (aLin, Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_UM")) // UM destino
				aadd (aLin, cArmDes) // Almox destino
				aadd (aLin, '') // Endereco destino
				aadd (aLin, '') // Num serie
				aadd (aLin, '') // Lote
				aadd (aLin, '') // Sublote
				aadd (aLin, criavar('D3_DTVALID'))
				aadd (aLin, 0) // Potencia
				aadd (aLin, nQtde) // Quantidade
				nQtdeSeg := Iif(Posicione(("SB1"),1,xFilial("SB1")+cCodProd,"B1_TIPCONV")=='M', nQtde*Posicione(("SB1"),1,xFilial("SB1")+cCodProd,"B1_CONV"),nQtde / Posicione(("SB1"),1,xFilial("SB1")+cCodProd,"B1_CONV"))
				aadd (aLin, nQtdeSeg) // Qt seg.UM
				aadd (aLin, '') //criavar("D3_ESTORNO")) // Estornado
				aadd (aLin, criavar("D3_NUMSEQ")) // Sequencia (D3_NUMSEQ)
				aadd (aLin, '') //criavar("D3_LOTECTL")) // Lote destino
				aadd (aLin, criavar("D3_DTVALID")) // Validade
				aadd (aLin, criavar("D3_ITEMGRD")) // Item da Grade
				aadd (aLin, criavar("D3_CODLAN")) //CodLan Cat83 - Origem
				aadd (aLin, criavar("D3_CODLAN")) //CodLan Cat83 - Destino
				aadd (aLin, criavar("D3_PERIMP")) // Percentual de Importação
				aadd (aLin, criavar("D3_CUSANT")) // Cusant
				aadd (aCab, aclone (aLin))
                                                  
			lMSErroAuto = .F.
			cNumSeq:= GetMv ('MV_DOCSEQ') 
			cNumSeq:= Soma1(cNumSeq)
//		    Alert('NumSEQ de transferencia-> ' +cNumSeq)			
	   		msexecauto({|x| Mata261(x)}, aCab, 2)
		   If lMsErroAuto
				MostraErro ()
				Alert("A Transferencia desse produto não foi realizada, favor verificar e transferir manualmente para evitar divergencias","Atenção")
				u_mailerrtrf(Substr(cgFicha,12,6), cCodProd)
		   else
//		   alert("Transferido com sucesso...")
		   dbSelectArea("SD3")     
		   dbSetOrder(4)
		   if dbSeek(xFilial("SD3")+cNumSeq)
		   		while !SD3->(eof()) .and. SD3->D3_NUMSEQ == cNumSEQ
		   			if SD3->D3_ATLOBS == space(20)
		   				RecLock("SD3",.F.)
		   				SD3->D3_ATLOBS := cgFicha
		   				MsUnlock("SD3")
		   			endif
		   			SD3->(dbSkip())
		   		enddo
		   endif
//		   		Alert("Transferencia realizada com sucesso...."+chr(13)+"Documento: "+cOpFic+" qtde-> "+cValToChar(nMtTot)+" FICHA: "+cgFicha+" Produto: "+cCodProd)
		   endif
return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Funçao chamada em AG_TRFLOC(SC2->C2_NUM) no ponto de entrada MA650EMP()
//com validação do campo SC2->C2_X_TRFLC == "N"
user function AG_TRFLOC(cOP)
local lRet := .F.
local cArmDes := GetMV("MA_LOCELAB") //Substr(GetMv("MA_LOCELAB"),1,2)
local cArmOri := GetMV("MA_LOCORIG")

if cArmDes <> cArmOri //se origem e destino forem iguais o sistema desconsidera a transferencia...
	dbSelectArea("SD4")
	dbSetOrder(2) //Ordem D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
	if dbSeek(xFilial("SD4")+cOP)
		while !SD4->(eof()).and.Substr(SD4->D4_OP,1,6) == cOP
			if Substr(SD4->D4_COD,1,3) == 'MOD' 
				SD4->(dbSkip())
			else
				if cArmOri <> SD4->D4_LOCAL .and. SD4->D4_X_TRFEL <> 'S'
					cArmDes := TMPD4->D4_LOCAL
					AG_TrfArm(SD4->D4_OP ,SD4->D4_QUANT, SD4->D4_COD, Substr(Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD, "B1_DESC"),1,30), 'TRF.REF.OP:'+SD4->D4_OP, cArmOri, cArmDes)
					recLock("SD4",.F.)
					SD4->D4_X_TRFEL := "S"
					msUnlock("SD4")
					lRet := .T.
				endif
			endif
			SD4->(dbSkip())
		enddo
	endif
endif

return lRet


user function mailerrtrf(cFicha, cCodProd)

     Local _cEmlFor := ''
     Local oProcess 
     Local oHtml
     Local nCont := 0
     
     if cFilant == '04'
        _cEmlFor := 'thiago@midoriatlantica.com.br;amanda.adario@midoriatlantica.com.br' 
     elseif cFilant == '19'
	     _cEmlFor := 'thiago@midoriatlantica.com.br;graziele.correa@midoriatlantica.com.br' 
	 elseif cFilant == '08'
	     _cEmlFor := 'thiago@midoriatlantica.com.br;amanda.adario@midoriatlantica.com.br'     
	 else
	 	_cEmlFor := 'thiago@midoriatlantica.com.br'
     endif
     //RA_VCTOEXP
     //RA_VCTEXP2                                      
//	 RpcSetEnv("01","04","","","","",{"SRA"})
     SETMV("MV_WFMLBOX","WORKFLOW") 
     oProcess := TWFProcess():New( "000005", "Problema na transferencia entre almoxarifado - prod "+ALLTRIM(cCodProd) )
     oProcess :NewTask( "Problema na transferencia entre almoxarifado", "\WORKFLOW\HTM\trfautalmox.HTM" )
     oHtml    := oProcess:oHTML
     	oHtml:ValByName( "data", dtoc(ddatabase))
     	oHtml:ValByName( "numOP", cFicha)
     	oHtml:ValByName( "NumFicha", 'OP:'+cFicha)
     	oHtml:ValByName( "NumPlano", '')
	 	aAdd( oHtml:ValByName( "it.desc" ), "Houve problema na transferencia de estoque entre armazens da ordem de producao acima" )
   	 	aAdd( oHtml:ValByName( "it.desc" ), "favor analisar para evitar divergencias ao final do mes.")
   	 	aAdd( oHtml:ValByName( "it.desc" ), "o erro ocorreu na senha do usuario "+Substr(cUsuario,1,20)+ " e o mesmo " )
   	 	aAdd( oHtml:ValByName( "it.desc" ), "tambem recebeu uma mensagem na tela informando sobre o fato..." )

		oProcess:cSubject := "Problema com transferencia automatica entre armazens " + dToc(dDatabase) +" produto "+ALLTRIM(cCodProd)



	oProcess:cTo      := _cEmlFor     


oProcess:Start()                    
	       WFSendMail()
	       //WFSendMail()	       
oProcess:Finish()


return


///////////////////////////////////////////////////////////////////////////////////////////////////////
//Funcao para fazer transferencia de material empenhado conforme parametro selecionado pelo usuario
///////////////////////////////////////////////////////////////////////////////////////////////////////
user function AG_PTRFARM()
cPerg  := "AG_PTRFAR"
//
AjustaSx1() // Funcao faz a montagem das perguntas
PERGUNTE(cPerg, .T. )
if ApMsgNoYes("Confirma a transferencia dos itens definido nos parametros ? ", "Atençao...ROTINA DE TRANSFERENCIA")

	cQuery := " SELECT R_E_C_N_O_ nReg, C2_NUM FROM "+ RetSqlName("SC2")+" SC2 with (nolock) WHERE D_E_L_E_T_ = ' ' "
	cQuery += " AND C2_FILIAL = '"+xFilial("SC2")+ "' AND C2_X_TRFLC <> 'S' " 
	cQuery += " AND C2_NUM between '"+MV_PAR03+"' AND '"+MV_PAR04+"' " 
	cQuery += " AND C2_EMISSAO between '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " 
	
	If !Empty(MV_PAR05) 
	cQuery += " AND C2_CC = '"+MV_PAR05+"'
	Endif
		
	//MemoWrite("C:\TEMP\AG_TRFARM-SC2.TXT", cQuery)

	if Select("TMPC2") > 0
		dbSelectArea("TMPC2")
		TMPC2->(dbCloseArea())
	endif

	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPC2", .T., .T.)

	dbSelectArea("TMPC2")
	TMPC2->(dbGotop())
	while !TMPC2->(eof())
//		Processa({||AtuBZ()},"Aguarde Processamento...")
		if AG_ALDD4(TMPC2->C2_NUM)
			dbSelectArea("SC2")
			SC2->(dbGoto(TMPC2->NREG))
			RecLock("SC2",.F.)
			Replace C2_X_TRFLC with 'S'
			MsUnLock("SC2")
		endif
		TMPC2->(dbSkip())
	enddo
	Alert("Transferencia Finalizada....")
endif

Static Function AG_ALDD4(cNumOP)
local lRet := .F.
local aTrans := {}
	aTrans := Processa({||AG_ALTD4(cNumOP)},"Aguarde Processamento...")
	lRet := .T.
return lRet

Static Function AG_ALTD4(cNumOP)
local cArmDes := GetMV("MA_LOCELAB") //Substr(GetMv("MA_LOCELAB"),1,2)
local cArmOri := GetMV("MA_LOCORIG")
local aTrans  := {} 

cQD4 := " SELECT R_E_C_N_O_ nREG, D4_COD, D4_OP, D4_LOCAL, D4_QTDEORI FROM "+RetSqlName("SD4")+" SD4 with (nolock) WHERE D_E_L_E_T_ = ' ' " 
cQD4 += " AND D4_FILIAL = '"+xFilial("SD4")+"' AND SUBSTRING(D4_COD,1,3) <> 'MOD' AND Substring(D4_OP,1,6) = '"+cNumOp+"' AND D4_X_TRFEL <> 'S' "

if Select("TMPD4") > 0 
	dbSelectArea("TMPD4")
	TMPD4->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", TcGenQry(, , cQD4), "TMPD4", .T., .T.)

ProcRegua(0)
dbSelectArea("TMPD4")
TMPD4->(dbGotop())
while !TMPD4->(eof())
	lRet := .F.
	if cArmDes <> cArmOri .and. TMPD4->D4_LOCAL <> cArmOri //se origem e destino forem iguais o sistema desconsidera a transferencia...
		cArmDes := TMPD4->D4_LOCAL
		AG_TrfArm(TMPD4->D4_OP ,TMPD4->D4_QTDEORI, TMPD4->D4_COD, Substr(Posicione("SB1",1,xFilial("SB1")+TMPD4->D4_COD, "B1_DESC"),1,30), 'TRF.REF.OP:'+TMPD4->D4_OP, cArmOri, cArmDes)
		aadd( aTrans, {TMPD4->D4_OP} )
		lRet:=.T.
	endif
	if lRet 
		dbSelectArea("SD4")
		SD4->(dbGoto(TMPD4->nReg))
		RecLock("SD4",.F.)
		replace D4_X_TRFEL with 'S'
		MsUnLock("SD4")
	endif
	incProc("Processando registro "+Substr(TMPD4->D4_OP,1,6))
	TMPD4->(dbSkip())
enddo

return aTrans

Static Function AjustaSx1()
//
PutSx1(cPerg, "01","Data De "				,"Data De ","Data De "	,"mv_ch1"	,"D"	,08	,0	,0	,"G",,,,,"mv_par01",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg, "02","Data Ate "				,"Data Ate ","Data Ate ","mv_ch2"	,"D"	,08	,0	,0	,"G",,,,,"mv_par02",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg, "07","Da OP Siga "			,"",""					,"mv_ch3"	,"C"	,11	,0	,0	,"G","", "","","","mv_par03"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "08","Ate a Op Siga"			,"",""					,"mv_ch4"	,"C"	,11	,0	,0	,"G","", "","","","mv_par04"," "," "," ","","","","","","","","","","","",""," ", , ,)
PutSx1(cPerg, "09","C.Custo"				,"C. Custo","C. Custo"	,"mv_ch5"	,"C"	,6	,0	,0	,"G","", "","","","mv_par05"," "," "," ","","","","","","","","","","","",""," ", , ,)

//
Return Nil

return