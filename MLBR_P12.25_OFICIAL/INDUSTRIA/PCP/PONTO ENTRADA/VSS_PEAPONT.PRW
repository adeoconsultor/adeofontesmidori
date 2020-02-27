#include "RWMAKE.CH"
#include "protheus.ch"

//Ponto de entrada para preencher o conteudo do campo D3_X_PLT (Pallets do fornecedor) 
//referente ao item a ser consumido no momento do apontamento da producao
//A variavel cPltsNumOP (Public) foi atribuida no PE A250ITOK, pois o PE A250ETRAN nao esta posicionado na OP que acaba de ser apontada,
//isto foi necessario pois havia a necessidade de um PE apos a gravacao do apontamento da OP na SD3
//Desenvolvido por Vinicius Schwartz - TI - Midori Atlantica 07/11/2012 - Ref ao Thiago/Fabio - HDI 004883

User Function A250ETRAN()

Local cQuery := ""
Local i

If cFilAnt == '09'     

	// Adiciona PARTIDA em todos registros da OP                                                                                                  ?
	// Manter reastreabilidade ao longo dos processso
	// Solicit: Anesio
	// Diego Mafisolli 15/06/2019
	
	If !empty(cPartida)
		cQuerySD3 := " Select MAX(D3_NUMSEQ) NSEQ from "+RetSqlName("SD3")+" with (nolock) " 
		cQuerySD3 += " where D_E_L_E_T_ =' ' and D3_FILIAL ='"+xFilial("SD3")+"' " 
		cQuerySD3 += " and Substring(D3_OP,1,6)='"+Substr(cPltsNumOP,1,6)+"' and D3_CF = 'PR0' "
		
		if Select("D3PART") > 0 
			dbSelectArea("D3PART")
			D3PART->(dbCloseArea())
		endif
		 	
		dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuerySD3), "D3PART", .T., .T. )
		
		cQuerySD3 := " UPDATE SD3010 SET D3_PARTIDA = '"+cPartida+"' " 
		cQuerySD3 += " WHERE D_E_L_E_T_ = ' ' AND D3_FILIAL ='"+xFilial("SD3")+"' AND D3_NUMSEQ = '"+D3PART->NSEQ+"' "		     
		
		TcSqlExec(cQuerySD3)
		
	Endif

	
	//Alert ('Teste ponto de entrada A250ITOK -> ' + SD3->D3_OP + ' - ' + cPltsNumOP)
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Gravar informacoes na tabela SZC - Controle de lotes drawback
	if Substr(cLoteDrwb,1,2) == "DB"
		cQD3DRW := " Select MAX(D3_NUMSEQ) NSEQ from "+RetSqlName("SD3")+" with (nolock) " 
		cQD3DRW += " where D_E_L_E_T_ =' ' and D3_FILIAL ='"+xFilial("SD3")+"' " 
	 	cQD3DRW += " and Substring(D3_OP,1,6)='"+Substr(cPltsNumOP,1,6)+"' and D3_CF = 'PR0' and D3_COD ='"+cProDrwb+"' "
	 	
	 	if Select("D3DRW") > 0 
	 		dbSelectArea("D3DRW")
	 		D3DRW->(dbCloseArea())
	 	endif
	 	
	 	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQD3DRW), "D3DRW", .T., .T. )
	 	
	 	dbSelectArea("D3DRW")
	 	D3DRW->(dbGotop())
	 	
		AG_GRVSZC(Substr(cProDrwb,1,6), cLoteDrwb, nQtdDrwb, D3DRW->NSEQ, Substr(cPltsNumOP,1,6))
	endif 
	//Fim da rotina referente a lote do drawback
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////	



	cQuery := " SELECT D4_OP, D4_COD, D4_LOTECTL, D4_X_PLTF FROM SD4010 "
	cQuery += " WHERE D4_FILIAL = '"+xFilial('SD4')+"' AND D4_OP = '"+cPltsNumOP+"' AND D_E_L_E_T_ <> '*' "
	
	If Select ('TMPD4PLT') > 0
		DbSelectArea('TMPD4PLT')
		DbCloseArea()
	EndIf


	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TMPD4PLT',.T.,.T.)
	DbSelectArea("TMPD4PLT")
	
	aPltsFor := {}
	
	//While para alimentar o array partir da query
	While !TMPD4PLT->(EOF())
		Aadd(aPltsFor, {TMPD4PLT->D4_OP, TMPD4PLT->D4_COD, TMPD4PLT->D4_LOTECTL, TMPD4PLT->D4_X_PLTF})
		//Alert('Entrou -> ' + TMPD4PLT->D4_COD + ' - ' + TMPD4PLT->D4_LOTECTL + ' - ' + TMPD4PLT->D4_X_PLTF)
		TMPD4PLT->(DbSkip())		
	Enddo
	
	//Localizando os registros de apontamento e preenchendo o campo com os pallets
	DbSelectArea('SD3')
	DbGoTop('SD3')
	//DbOrderNickName("PLT_FORNEC")
	DbSetOrder(1)
	
	For i:=1 to len (aPltsFor)
		If SD3->(DbSeek(xFilial('SD3') + aPltsFor[i][1] ))//+ aPltsFor[i][2] + aPltsFor[i][3]))
			//Alert ('Achou OP ->' + aPltsFor[i][3] + '-' + aPltsFor[i][2])
			While !SD3->(Eof()) .And. SD3->D3_OP == aPltsFor[i][1]
				
				If SD3->(D3_COD == aPltsFor[i][2] .And. D3_LOTECTL == aPltsFor[i][3] .And. D3_CF == 'RE1' .And. D3_ESTORNO <> 'S' .And. D3_GRUPO == '11  ')
					//Alert('Satisfez as opções -> ' + aPltsFor[i][4])
					RecLock('SD3',.F.) //Altera
					SD3->D3_X_PLTF := aPltsFor[i][4]
					MsUnLock("ZZB")
				endif
				
			SD3->(dbSkip())
			EndDo
		Endif
	next i
	
	
	//MsgInfo('Processo concluído com sucesso!!!')


ElseIf cFilAnt $ '08|19'

//	MsgInfo(SD3->D3_OP)

    //chamada para emissão da etiqueta no caso de apontamento de OP padrão (#LE) - Antonio ADVPL 19/04/18
    //--------------------------------------------
    // Impressão das Etiquetas
    //--------------------------------------------        

    SB1->( dbSetOrder(1) )
    SB1->( dbSeek( xFilial("SB1") + SD3->D3_COD ) )
                                                              
	// Inclusao de alguns códigos na validacao para chamar tela de romaneio
	// Solicitante: Amanda Adario          
	// Diego Mafisolli
	If (AllTrim(SB1->B1_GRUPO) == '48' .And.  AllTrim(SB1->B1_RASTRO) == 'L') .OR. AllTrim(SB1->B1_COD) $ '064834|064835|070199|070200'
	

	    SC2->( dbSetOrder(1) )
	    SC2->( dbSeek( xFilial("SC2") + SD3->D3_OP ) )
	
	 	aParam    := {}
		nQtOpEtiq := 1
		AAdd( aParam, SC2->C2_QUANT ) // quantidade da etiqueta
		AAdd( aParam, nil           ) // Codigo do separador
		AAdd( aParam, nil           ) // Código da etiqueta, no caso de uma reimpressão
		AAdd( aParam, nQtOpEtiq     ) // Quantidade de etiquetas
		AAdd( aParam, nil           ) // nota de entrada
		AAdd( aParam, nil           ) // Serie da nota de entrada
		AAdd( aParam, nil           ) // Codigo do fornecedor da nota de entrada
		AAdd( aParam, nil           ) // LojPa do fornecedor da nota de entrada
		AAdd( aParam, '01'          ) // Armazem
		AAdd( aParam, SC2->C2_NUM ) // Numero da OP
		AAdd( aParam, nil           ) // Numero sequencial da etiqueta quando for reimpressao
		AAdd( aParam, SD3->D3_LOTECTL         ) // Numero do Lote. Neste caso deve ser o mesmo numero da OP
		AAdd( aParam, nil           ) // Sublote

		If SD3->D3_DTVALID == SD3->D3_EMISSAO
			AAdd( aParam, SD3->D3_EMISSAO+1825 ) // Usuário não digitou a Data de Validade então automaticamente ficará com 5 anos 
    	Else
			AAdd( aParam, SD3->D3_DTVALID )      // Data de Validade com periodo informado pelo usuário
    	EndIf
 //esta alteração sera feita para corrigir a data de validade do lote que é digitada no apontamento e o sistema coloca a database caso não exista o lote
 

//		AAdd( aParam, '320401'      ) // Centro de Custos  (TI)
//		AAdd( aParam, 'LE'          ) // Local de Origem
		AAdd( aParam, ''      ) // Centro de Custos  (TI)
		AAdd( aParam, ''          ) // Local de Origem
		AAdd( aParam, nil           ) // Local cOPREQ    := If(len(paramixb) >=17,paramixb[17],NIL)
		AAdd( aParam, nil           ) // Local cNumSerie := If(len(paramixb) >=18,paramixb[18],NIL)
		AAdd( aParam, nil           ) // Local cOrigem   := If(len(paramixb) >=19,paramixb[19],NIL)
		AAdd( aParam, nil           ) // Local cEndereco := If(len(paramixb) >=20,paramixb[20],NIL)
		AAdd( aParam, nil           ) // Local cPedido   := If(len(paramixb) >=21,paramixb[21],NIL)
		AAdd( aParam, 0             ) // Local nResto    := If(len(paramixb) >=22,paramixb[22],0)
		AAdd( aParam, nil           ) // Local cItNFE    := If(len(paramixb) >=23,paramixb[23],NIL)            

		ExecBlock("IMG01",,,aParam )               	

	EndIf
		
Endif
  
Return



/////////////////////////////////////////////////////////////////////////////////////////////////
//Função para gravar o apontamento do grupo 32 na tabela SZC
/////////////////////////////////////////////////////////////////////////////////////////////////
static function AG_GRVSZC(cProd, cLtDrawb, nQtde, cNumSeq, cOP)
	RecLock("SZC",.T.)
	SZC->ZC_FILIAL := xFIlial("SZC")
	SZC->ZC_PRODUTO:= cProd
	SZC->ZC_LTDRAWB:= cLtDrawb
	SZC->ZC_QTDENTR:= nQtde
	SZC->ZC_NUMSEQ := cNumSeq
	SZC->ZC_OPORIG := cOP
	MsUnLock("SZC")
return
 


/////////////////////////////////////////////////////////////////////////////////////////////////
//Ponto de entrada chamado no estorno do apontamento de OP....
/////////////////////////////////////////////////////////////////////////////////////////////////
User Function MT250GREST()
Local cQuery    := " " 
Local cQ35      := " " 
Local aAreaSZC  := SZC->(GetArea())
Local aAreaCB0  := CB0->(GetArea())

cQuery := " UPDATE "+RetSqlName("SZC")+" SET D_E_L_E_T_ = '*' WHERE D_E_L_E_T_ = ' ' AND ZC_NUMSEQ = '"+SD3->D3_NUMSEQ+"' " 

TcSqlExec(cQuery)

//Fazer extorno do saldo ref.ao lote de drawback ref.ao lote consumido na produção.
//cQ35 := " SELECT R_E_C_N_O_ NREG FROM "+RetSqlname("SZC")+" with (nolock) where D_E_L_E_T_ =' ' 
//cQ35 += " AND ZC_NSEQD LIKE '%"+SD3->D3_NUMSEQ+"%' "
//cQ35 += " ORDER BY 1 "
  
cQ35 := " SELECT ZD_NSEQORI, ZD_QTDE FROM "+RetSqlName("SZD")+" WHERE D_E_L_E_T_ =' ' AND ZD_FILIAL = '"+xFilial("SZD")+"' "
cQ35 += " AND ZD_NUMSEQ = '"+SD3->D3_NUMSEQ+"'"
                      
if Select("TMP35") > 0 
	dbSelectArea("TMP35")
	TMP35->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", TcGenQry(, , cQ35), "TMP35", .T.,.T.)

dbSelectArea("TMP35")
TMP35->(dbGotop())
While !TMP35->(Eof())
	//Atualiza as informacoes na tabela SZC
	dbSelectArea("SZC")
	dbSetOrder(4)
	If dbSeek(xFilial("SZC")+TMP35->ZD_NSEQORI)
		RecLock("SZC",.F.)
		SZC->ZC_QTDSAID -= TMP35->ZD_QTDE
		MsUnLock("SZC")
	EndIf
	//ZC_PRODUTO, ZC_LTDRAWB, ZC_QTDENTR, ZC_QTDSAID, ZC_PRDCONS, ZC_OP, ZC_NSEQD	
	TMP35->(dbSkip())
EndDo

cQ35 := " UPDATE SZD010 SET D_E_L_E_T_ ='*' WHERE ZD_FILIAL ='"+xFilial("SZD")+"' AND ZD_NUMSEQ = '"+SD3->D3_NUMSEQ+"'"
TcSqlExec(cQ35)

////////////////////EXCLUIR ETIQUETA DA CB0 CASO EXISTA - ANTONIO - 03/05/18
If xFilial("SD3") $ '08|19'
	dbSelectArea("CB0")
	dbSetOrder(7)    //xFilial+CB0->CB0_OP
	cOP:=SubStr(SD3->D3_OP,1,6)
	If dbSeek(xFilial("CB0")+cOP)
		While !Eof()
			If Alltrim(CB0->CB0_OP) <> cOP
				Exit			
			EndIf
			RecLock("CB0",.F.)
			dbDelete()
			MsUnLock("CB0")
			CB0->(dbSkip())
		EndDo
	EndIf
EndIf	
////////////////////EXCLUIR ETIQUETA DA CB0 CASO EXISTA

RestArea(aAreaSZC)
RestArea(aAreaCB0)

Return

/////////////////////////////////////////////////////////////////////////////////////////////////
//Ponto de entrada para validar se é lote de drawback
//caso seja produto de drawback e tenha saldo consumido, não permite a exclusao do mesmo
/////////////////////////////////////////////////////////////////////////////////////////////////
user function MT250EST()
local lRet := .T.
local cQuery := " " 
If cFilAnt == '09'
	cQuery := " SELECT ZC_LTDRAWB, ZC_QTDSAID FROM "+RetSqlName("SZC")+" WHERE D_E_L_E_T_ = ' ' AND ZC_NUMSEQ = '"+SD3->D3_NUMSEQ+"' "
	//Alert("D3_NUMSEQ "+SD3->D3_NUMSEQ)
	if Select("TMPZC") > 0 
		dbSelectArea("TMPZC")
		TMPZC->(dbCloseArea())
	endif
	
		dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPZC", .T., .T. )
		
		dbSelectArea("TMPZC")
		TMPZC->(dbGotop())
		
		if TMPZC->ZC_QTDSAID > 0 
			Alert("Já existe consumo do grupo 35 para o lote de drawback "+TMPZC->ZC_LTDRAWB+chr(13)+"O Estorno não será possivel neste momento!")
			lRet := .F.
		endif
endif	

return lRet 
