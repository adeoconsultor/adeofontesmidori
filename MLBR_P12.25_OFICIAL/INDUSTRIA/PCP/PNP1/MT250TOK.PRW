#Include "Protheus.Ch"
#Include "rwmake.ch"

#DEFINE PICVAL  "@E 999,999,999.99"
/////////////////////////////////////////////////////////////////////////////////////////////////
//Função que será chamada no ato do apontamento de uma Ordem de Produção
//Verifica se existe algum plano na tabela SZ3 que nao esteja encerrado e alerta ao usuario 
//Para evitar o encerramento de OPs sem que seja apontado todas as FASES das fichas de Corte 
//Especifico PNP2

//Desenvolvido por Anesio G.Faria - Taggs Consultoria - 24-05-2011


User Function MT250TOK()    

Local aArea   := GetArea()
Local lOk     := .T.
Local cNumOp  := 0
Local cCodPA  := 0
Local nIndice := 0
Local lAtivo  := GetMv("MA_ATVLES") // Parametro para ativar a funcao de validação de consumo a menor
Local cLocal  := GetMv("MA_ARMAZEM") // Parametro para ativar a funcao de validação armazem

                            
If cFilant $ '08|19'
	If Substr(M->D3_OP,9,3) == '001'                      
		dbSelectArea("SC2")
		dbSeek(xFilial("SC2")+Substr(M->D3_OP,1,6),.F.)
		if !Empty(SC2->C2_OPMIDO)  // <> space(12)
			cCodPA := M->D3_COD
			cNumOp := SC2->C2_NUM                             
			nIndice := (M->D3_QUANT + SC2->C2_QUJE)/ (SC2->C2_QUANT)
			dbSelectArea("SZ3")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ3")+SC2->C2_OPMIDO,.T.)
				While !SZ3->(eof()) .and. Substr(SZ3->Z3_NUMOP,1,6) == Substr(M->D3_OP,1,6)
					If SZ3->Z3_STATUS == 'A'
						lOk := .F.
					EndIf
					SZ3->(dbSkip())
		    	EndDo
			EndIf
		EndIf


        //chamada para emissão da etiqueta no caso de apontamento de OP padrão (#LE) - Antonio ADVPL 08/11/16
	    //--------------------------------------------
	    // Impressão das Etiquetas
	    //--------------------------------------------        

/*	    SB1->( dbSetOrder(1) )
	    SB1->( dbSeek( xFilial("SB1") +  SC2->C2_PRODUTO ) )

		If AllTrim(SB1->B1_GRUPO) == '48' .And. SB1->B1_UM == 'MT'     // AllTrim(SB1->B1_RASTRO) == 'L'  //antonio
	
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

//			cLote:=U_LoteCB0(TMP250->D4_COD)     //caso o produto tenha lote, executa a função para pegá-lo

			AAdd( aParam, M->D3_LOTECTL         ) // Numero do Lote. Neste caso deve ser o mesmo numero da OP
			AAdd( aParam, nil           ) // Sublote
			AAdd( aParam, nil           ) // Data de Validade
			AAdd( aParam, nil      		) // Centro de Custos  (TI)
			AAdd( aParam, nil     	    ) // Local de Origem
			AAdd( aParam, nil           ) // Local cOPREQ    := If(len(paramixb) >=17,paramixb[17],NIL)
			AAdd( aParam, nil           ) // Local cNumSerie := If(len(paramixb) >=18,paramixb[18],NIL)
			AAdd( aParam, nil           ) // Local cOrigem   := If(len(paramixb) >=19,paramixb[19],NIL)
			AAdd( aParam, nil           ) // Local cEndereco := If(len(paramixb) >=20,paramixb[20],NIL)
			AAdd( aParam, nil           ) // Local cPedido   := If(len(paramixb) >=21,paramixb[21],NIL)
			AAdd( aParam, 0             ) // Local nResto    := If(len(paramixb) >=22,paramixb[22],0)
			AAdd( aParam, nil           ) // Local cItNFE    := If(len(paramixb) >=23,paramixb[23],NIL)            

			ExecBlock("IMG01",,,aParam )               	

		EndIf */

	EndIf

	If !lOk 
		If APMSGNoYes("Existem fichas que não foram apontados totalmente ! ! !"+Chr(10)+Chr(13)+Chr(10)+Chr(13)+"Confirma apontamento ? ","Alerta de fichas não apontadas...") 
			If APMSGNoYes("Deseja realmente apontar esta OP com fichas em Aberto ? ", "Alerta Extra de Ficha ")
				lOk :=.T.             
				
	//			If !u_isOk(cCodPA, cNumOP,nIndice)  
	//				Alert("Ainda existem peças a serem apontadas" +chr(13)+"Apontamento não permitido...")
	//				lOk := .F.
	//			EndIf

			EndIf
	 	EndIf
	EndIf
EndIf

If cFilant == '09'
	If M->D3_PARTIDA == Space(12)
		Alert('Campo de numero de partida é obrigatorio...')
		lOk := .F.
	EndIf 
	
	//Chamada da funcao para validar saldo MOD998
	//antes do apontamento da OP
	lOk := VLDMOD998()  
EndIf

//If cFilant $ '04|19'
	If SC2->C2_OPRETRA == 'N' .And. Substr(M->D3_OP,9,3) == '001' .And. !Alltrim(SC2->C2_CC) $ '320201|320202|320001|320301|320701|320501|320702|370200'  // tratamento temporar. ops tinta/acabamento                
		dbSelectArea("SC2")   
		If AG_D4DPLIC(Substr(M->D3_OP,1,6))
			Alert("Foi encontrado itens duplicados no empenho, por favor revisar antes de continuar....")
			return .F.
		EndIf
		If lAtivo
			If AG_D4LESS(Substr(M->D3_OP,1,6)) 
				Alert("Foram encontrados empenho menor do que o devido na estrutura"+chr(13)+"O Apontamento não será permitido"+chr(13)+"Parametro MA_ATVLES ativo")
				return .F.
			EndIf
		EndIf
	EndIf
//EndIf

// Validacao armazem bloqueado param MA_ARMAZEM
// Diego Mafisolli - 23/01/17
If M->D3_LOCAL $ cLocal
	Help(" ",1,"HELP","MA_ARMAZEM",'Movimentação NÃO Permitida No(s) Armazem(s) -> '+ GetMv('MA_ARMAZEM') + chr(13) + chr(13),1,0)
	lOk := .F.
EndIf

RestArea(aArea)

Return lOk
              


//Funcao para verificar se o SD4 das unidades de costura está duplicado...
//Função desenvolvida por Anesio - 12/06/2015
Static Function AG_D4DPLIC(cNumOP)
lRet := .F.
cQuery := " "
If Substr(M->D3_OP,9,3) == '001'                      
	dbSelectArea("SC2")
	dbSeek(xFilial("SC2")+cNumOP,.F.)
	cCodPA := M->D3_COD
	nQtde  := SC2->C2_QUANT

	cQuery := " Select G1_COMP, G1_QUANT * "+cValToChar(nQtde)+ " QTDREAL, D4_QUANT, D4_QTDEORI, (D4_QTDEORI - (G1_QUANT * "+cValToChar(nQtde)+" )) DIF "
	cQuery += " from SG1010 SG1 with (nolock), SD4010 SD4 with (nolock), SB1010 SB1 with (nolock) "
	cQuery += " where SD4.D_E_L_E_T_ =' ' and SG1.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' "
	cQuery += " and G1_FILIAL = D4_FILIAL and G1_COMP = D4_COD "
	cQuery += " and G1_COMP = B1_COD  "
	cQuery += " and D4_FILIAL ='"+xFilial("SD4")+"' and G1_FILIAL ='"+xFilial("SD4")+"' "
	cQuery += " and Substring(D4_OP,1,6) ='"+cNumOP+"' "
	cQuery += " and G1_COD ='"+cCodPA+"' "
	cQuery += " and Substring(G1_COMP,1,3) <> 'MOD' " 
	
   	//MemoWrite("C:\TEMP\MT250TOKTMPG1.TXT", cQuery)
	
	If Select("TMPG1") > 0 
		dbSelectArea("TMPG1")
		TMPG1->(dbCloseArea())
	EndIf
	dbUseArea(.T., "TOPCONN", TcGenQry(, , cQuery), "TMPG1", .T., .T.)
	
	dbSelectArea("TMPG1")
	TMPG1->(dbGotop())
	ProcRegua(0)
	While !TMPG1->(eof())
		If TMPG1->DIF >= TMPG1->QTDREAL
			Alert("Produto "+ALLTRIM(TMPG1->G1_COMP)+ " DUPLICADO o empenho na estrutura...")
			lRet := .T.
		EndIf
		IncProc("Analisando consistencia dos empenhos...")
		TMPG1->(dbSkip())
	EndDo
EndIf

Return lRet

//Funcao para verificar se o SD4 o está com quantidade inferior do que deveria estar conforme estrutura
//Função desenvolvida por Anesio - 31/07/2015
static function AG_D4LESS(cNumOP) 
local cUser := GetMV("MA_USRLES") // Usuários com permissão de apontar com quantidade a menor
lRet := .F.
cQuery := " "
	if Substr(M->D3_OP,9,3) == '001'                      
		dbSelectArea("SC2")
		dbSeek(xFilial("SC2")+cNumOP,.F.)
		cCodPA := M->D3_COD
		nQtde  := SC2->C2_QUANT
	
		cQuery := " Select G1_COMP, G1_QUANT * "+cValToChar(nQtde)+ " QTDREAL, D4_QUANT, D4_QTDEORI "
		cQuery += " from SG1010 SG1 with (nolock), SD4010 SD4 with (nolock), SB1010 SB1 with (nolock) "
		cQuery += " where SD4.D_E_L_E_T_ =' ' and SG1.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' "
		cQuery += " and G1_FILIAL = D4_FILIAL and G1_COMP = D4_COD "
		cQuery += " and G1_COMP = B1_COD  "
		cQuery += " and D4_FILIAL ='"+xFilial("SD4")+"' and G1_FILIAL ='"+xFilial("SD4")+"' "
		cQuery += " and Substring(D4_OP,1,6) ='"+cNumOP+"' "
		cQuery += " and G1_COD ='"+cCodPA+"' "
		cQuery += " and Substring(G1_COMP,1,3) <> 'MOD' " 
		
		MemoWrite("C:\TEMP\MT250TOKTMPG1.TXT", cQuery)
		
		if Select("TMPG1") > 0 
			dbSelectArea("TMPG1")
			TMPG1->(dbCloseArea())
		endif
		dbUseArea(.T., "TOPCONN", TcGenQry(, , cQuery), "TMPG1", .T., .T.)
		
		dbSelectArea("TMPG1")
		TMPG1->(dbGotop())
		ProcRegua(0)
		while !TMPG1->(eof())
			if TMPG1->D4_QTDEORI < TMPG1->QTDREAL
				Alert("Produto "+ALLTRIM(TMPG1->G1_COMP)+ " Está consumindo a menor do que prevê a estrutura..."+chr(13)+"O Apontamento não será permitido..."+chr(13)+"Parametro MA_ATVLES ativo" )
				lRet := .T.
			endif
			incProc("Analisando consumo a menor...")
			TMPG1->(dbSkip())
		enddo
	endif


Return lRet


///////////////////////////////////////////
user function isOk(cCodPA, cNumOP,nIndice)
local cQuery  := ""
local cQuery1 := ""
local nResult := .T.

Local aCampos	:= {}
Local aAltera	:= {}
Private aConteud:= {}       
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab        := "" 



nCount        := 0


cArq := CriaTrab(NIL, .F.)
//cIndice := "CODIGO"                        


aCampos := U_MntHead(@aAltera)

U_MntTMP(aCampos,@cArq)

aStru := {}
AADD(aStru,{ "PECA"    , "C",  6, 0})
AADD(aStru,{ "OP"      , "C", 11, 0})
AADD(aStru,{ "QTDORI"  , "N", 16, 2})
AADD(aStru,{ "QUANT"   , "N", 16, 2})
AADD(aStru,{ "SALDO"   , "N", 16, 2})
cArqTrab := CriaTrab(aStru, .T.)

If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea("TRB")
Endif
dbUseArea(.T.,,cArqTrab,"TRB",Nil,.F.)



	cQuery := " SELECT G1_COMP FROM SG1010 WHERE D_E_L_E_T_ = ' ' and G1_FILIAL = '"+xFilial("SG1")+"' AND G1_COD = '"+cCodPA+"' "

	if Select('TMPCP') > 0 
		dbSelectArea('TMPCP')
		dbCloseArea()
	endif
	dbUseArea(.T., "TOPCONN", TCGenQry( , , cQuery), 'TMPCP', .F., .T.)
	
	dbSelectArea("TMPCP")
	TMPCP->(dbGotop())
	while !TMPCP->(eof())
		cQuery1 := " SELECT G1_COMP FROM SG1010 WHERE D_E_L_E_T_ = ' ' and G1_FILIAL = '"+xFilial("SG1")+"' and G1_COD = '"+TMPCP->G1_COMP+"' "
		
		if Select('TMPPC') > 0
			dbSelectArea('TMPPC')
			dbCloseArea()
		endif                                                     
		
		dbUseArea(.T., "TOPCONN", TCGenQry( ,, cQuery1), 'TMPPC', .F., .T.)
	    dbSelectArea("TMPPC")
	    TMPPC->(dbGotop())
	    while !TMPPC->(eof())
	    	cQueryD4 := " Select D4_COD, D4_OP, D4_QTDEORI, D4_QUANT from SD4010 Where D_E_L_E_T_ = ' ' and Substring(D4_OP,1,6)='"+cNumOP+;
	    		"' AND D4_COD = '"+TMPPC->G1_COMP+"' AND D4_FILIAL ='"+xFilial("SD4")+"' "
	    		if Select('TMPD4')>0
	    			dbSelectArea('TMPD4')
	    			dbCloseArea()
	    		endif

	    		dbUseArea(.T., "TOPCONN", TCGenQry( ,, cQueryD4), 'TMPD4', .F., .T.)  
	    		
//	    		Alert("Pesquisando o produto ->> "+TMPD4->D4_COD+" Indice Encontrado-> "+cValToChar(1-(TMPD4->(D4_QUANT / D4_QTDEORI)))+" Indice aplicado -> "+cValToChar(nIndice)) 
				if 1 - TMPD4->(D4_QUANT / D4_QTDEORI) < nIndice 
					nResult := .F.
					dbSelectArea("TMP")
					RecLock("TMP",.T.)
						TMP->D4_COD     := TMPPC->G1_COMP
						TMP->D4_QTDEORI := TMPD4->D4_QTDEORI
						TMP->D4_QUANT   := TMPD4->D4_QUANT
						TMP->D4_OP  := Substr(TMPD4->D4_OP,1,11)
					MsUnLock("TMP")
						
					nCount++
				endif
			TMPPC->(dbSkip())
		enddo
 		TMPCP->(dbSkip())
	enddo
if nCount > 0 
	If APMSGNoYes("Não existem fichas suficiente apontadas"+chr(13)+"Deseja Imprimir as Fichas Pendentes ? ","Fichas insuficiente...")
		DbSelectArea("TMP")
		dbGotop()
			aDir := MDirArq()
			If Empty(aDir[1]) .OR. Empty(aDir[2])
				Return
			Else                      
				U_GRFICTMP(Substr(TMP->D4_OP,1,6))
			Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		
				If lOk
					MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
				EndIf
  			endif
		
		
		
			while !TMP->(eof())
				nCount++
				TMP->(dbSkip())
			enddo


		
	endif
endif
return nResult


User Function MntHead(aAltera)

Local aArea:= GetArea()
Local aCampos	:= {}

PRIVATE nUsado := 0
// Montagem da matriz aHeader									
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SD4")
While !EOF() .And. (x3_arquivo == "SD4")
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL 
		if X3_CAMPO == "D4_COD    " .or. X3_CAMPO == "D4_OP     "; 
		     .or. X3_CAMPO == "D4_QTDEORI" .or. X3_CAMPO == "D4_QUANT  "
			nUsado++
			AADD(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
								x3_tamanho, x3_decimal, x3_valid,;
								x3_usado, x3_tipo, "TMP", x3_context } )
			If Alltrim(x3_campo) <> "D4_ITEM"
				Aadd(aAltera,Trim(X3_CAMPO))
			EndIf
		EndIF
	EndIF
	aAdd( aCampos, { SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO,;
						 SX3->X3_DECIMAL } )
	dbSkip()
EndDO

//Aadd(aCampos,{"D4_FLAG","L",1,0})

RestArea(aArea)

Return aCampos


//+--------------------------------------------------------------------+
//| Rotina | CriaTMP    | Autor | Anesio - Taggs    | Data |20.07.2011 |
//+--------------------------------------------------------------------+
//| Descr. | Cria tabela temporária.                                   |
//+--------------------------------------------------------------------+
//| Uso    | Penapolis 1 Curtume                                       |
//+--------------------------------------------------------------------+
User Function MntTMP(aCampos,cArq)

Local cChave 
Local aArea := GetArea()

cArq		:= CriaTrab(aCampos,.t.)
cChave 	:= "D4_COD" //+IndexKey()

dbUseArea(.t.,,cArq,"TMP",.f.,.f.)

RestArea(aArea)

Return


User function GRFICTMP(cNumOP)
Local nCount := 0


U_CriaTMPZ3(cNumOP) 

dbSelectArea("TMPZ3")

TMPZ3->(dbGotop())   
	//Adicionando linhas no array da planilha para gerar arquivo Excel
	aAdd(aConteud,{"","RELAÇÃO DE FICHAS DA OP "+cNumOP,"","","","RELATORIO EMITIDO EM: "+dToC(dDatabase)})
	aAdd(aConteud,{"","","","","",""}) //6 colunas
	//Cabeçalho
	//Tabulaçao       1         2         3         4       5        6            7         8           9         10          11         12         13           14           15        16          17         18          19          20       21           22          23         24         25          26         27           28         29            30                  31 
	aAdd(aConteud,{"PLANO","FICHA","PECA","QTDE","STATUS"}) //6 colunas
	aAdd(aConteud,{"","","","","",""}) //6 colunas
	While !TMPZ3->(EoF())                                
		aAdd(aConteud,{"","","","","",""}) //6 colunas
		aConteud [len(aConteud),1] := TMPZ3->Z3_PLANO
		aConteud [len(aConteud),2] := TMPZ3->Z3_NUMFC
		aConteud [len(aConteud),3] := TMPZ3->Z3_PRODUTO+' - '+Posicione("SB1",1,xFilial("SB1")+TMPZ3->Z3_PRODUTO,"B1_DESC")
		aConteud [len(aConteud),4] := TMPZ3->Z3_QTDE
		aConteud [len(aConteud),5] := TMPZ3->Z3_STATUS
		TMPZ3->(dbSkip())
		nCount++
	enddo       
	
Return()



user function CriaTMPZ3(cNumOP)

	cQuery := " Select Z3_PLANO, Z3_NUMFC, Z3_PRODUTO, Z3_QTDE, Z3_STATUS  "
	cQuery += " FROM "+ RetSQLName( "SZ3" ) + " SZ3 "
	cQuery += " where SZ3.D_E_L_E_T_ = ' ' "
	cQuery += " and Z3_FILIAL = '"+xFilial("SZ3")+"' " 
	cQuery += " and (Substring(Z3_NUMFC,1,6) = '"+cNumOP+"' or Substring(Z3_NUMFC,2,6) = '"+cNumOP+"') "
    cQuery += " order by Z3_PLANO, Z3_PRODUTO, Z3_NUMFC "
If Select('TMPZ3') > 0 
	dbSelectArea('TMPZ3')
	dbclosearea()
endif

dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQuery  ), 'TMPZ3' , .F. , .T. )

//TcSetField(cAliasQry, "D3_EMISSAO", "D")


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
Local nHdl, nt, jk       := 0

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

/////////////////////////////////////////////////////////////////////////////?
// Funcao desenvolvida para validar saldo atual MOD998xxxx
// Nao permite o apontamento da OP se o empenho produto MOD998 > saldo atual 
// Solicitante: Jairson Ramalho Chamado 3384
// Desenvolvedor: Diego Mafisolli 12/04/2017
/////////////////////////////////////////////////////////////////////////////
Static Function VLDMOD998()

Local lRet := .T.
Local nSaldo1

DbSelectArea('SD4')
DbSetOrder(2) //SETANDO PARA A ORDEM DE OP + CODIGO + LOCAL

cQuery := "SELECT SD4.R_E_C_N_O_ AS REC "
cQuery += " FROM "+RetSqlName("SD4")+" SD4 WHERE "
cQuery += "SD4.D4_FILIAL='"+xFilial("SD4")+"' AND SD4.D_E_L_E_T_=' ' AND "
cQuery += "SD4.D4_OP =  '" +M->D3_OP +"' "

If Select("TRBD4") > 0
	DbSelectArea( "TRBD4" )
	DbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBD4",.T.,.T.)

While !eof()

	DbSelectArea('SD4')
	Dbgoto( TRBD4->REC ) 

	nSaldo1 := SD4->D4_QUANT
	
	If Substr(SD4->D4_COD,1,6) == "MOD998"
		                  
		DbSelectArea('SB2')
		DbSetORder(1)
		
		If DbSeek( xFilial('SB2') + SD4->D4_COD + SD4->D4_LOCAL)
			aSaldo := {B2_QATU,B2_QEMP}
		Else
			aSaldo := {0}
		Endif
	
		If aSaldo[1] < nSaldo1 .And. nSaldo1 > 0   // O Saldo em Estoque for menor que o Saldo Empenhado, dispara mensagem
			ApMsgInfo("Apontamento da Op não realizado!"+CHR(13)+CHR(10)+"Saldo do produto "+Rtrim(SD4->D4_COD)+" ficará negativo.")
			lRet := .F.	
		Endif
	Endif

	DbSelectArea('TRBD4')
	DbSkip()
Enddo

Return lRet

