#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#define STR0001  "OP's Previstas"
#define STR0002  "Firma OPs"
#define STR0003  "Exclui OPs"
#define STR0004  " Firma as OPs marcadas ?"
#define STR0005  " Deleta as OPs marcadas ?"
#define STR0006  "Selecionando Registros..."
#define STR0007  "Pesquisar"
#define STR0008  "Atenção"
#define STR0009  "Todas as OPs intermediárias que possuam vinculo com alguma OP Pai marcada no Browse, serão firmadas, "
#define STR0010  "devido o sistema estar parametrizado para trabalhar com produção automática (MV_PRODAUT habilitado). "
#define STR0011  "Deseja continuar o processo ?"
#define STR0012  "Sim"
#define STR0013  "Não"
#define STR0014  "Deletando OP's previstas..."
#define STR0015  "Deletando SC's previstas..."
#define STR0016  "Deletando PC's/CP's previstos..."

User Function AGF_GERPL1()

Local	nI,nn1			:= 0
Local 	aCampos		:= {}
Private cMarca 		:= GetMark()
Private nOrdemAtual := 1
Private cusrs := Getmv( 'MV_MIDOLBPL'  )
Private aUsrs := U_QuebraSep( cusrs , ';'  )
Private cUserCod  := ''
Private cteste := RetCodUsr()
//
//Alert('cod user-> '+ cteste)

For nn1 := 1 to len( aUsrs )
//	Alert ('cod User array-> '+ aUsrs[nn1])//teste
	cUsuArray := aUsrs[ nn1 ]
//	Alert ('cod user array 2-> '+ Alltrim(substr( cUsuArray  , 2 ) ))
	//
	if Alltrim(substr( cUsuArray  , 2 ) )   == Alltrim( RetCodUsr()   )
		cUserCod  := aUsrs[ nn1 ]
		exit
	Endif
Next

//
if cUserCod == ''
	Alert('Atenção !!! Você Não tem direito a utilizar esta rotina. Entre em contato com o Administrador do sistema.')
	Return()
Endif
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa  ³
//³ ----------- Elementos contidos por dimensao ------------ ³
//³ 1. Nome a aparecer no cabecalho                          ³
//³ 2. Nome da Rotina associada                              ³
//³ 3. Usado pela rotina                                     ³
//³ 4. Tipo de Transa‡„o a ser efetuada                      ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados         ³
//³    2 - Simplesmente Mostra os Campos                     ³
//³    3 - Inclui registros no Bancos de Dados               ³
//³    4 - Altera o registro corrente                        ³
//³    5 - Remove o registro corrente do Banco de Dados      ³
//³    6 - Altera determinados campos sem incluir novos Regs ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCadastro := "Manutencao Planos de Producao"

Private aRotina := MenuDef()
Private aIndTmp 	:= {}
Private aSavMTA652  := Array(8)
Private oVermelho   := LoadBitmap( GetResources(), "BR_VERMELHO" )
Private oAmarelo    := LoadBitmap( GetResources(), "BR_AMARELO" )
Private oVerde      := LoadBitmap( GetResources(), "BR_VERDE" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de variaveis para rotina de inclusao automatica    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // De  Produto                           ³
//³ mv_par02            // Ate Produto                           ³
//³ mv_par03            // De  Ordem de Producao                 ³
//³ mv_par04            // Ate Ordem de Producao                 ³
//³ mv_par05            // De  Data de Entrega                   ³
//³ mv_par06            // Ate Data de Entrega                   ³
//³ mv_par07            // De  Data de Inicio                    ³
//³ mv_par08            // Ate Data de Inicio                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("MTA652",.F.)
For ni := 1 to 8
	aSavMTA652[ni] := &("mv_par"+StrZero(ni,2))
Next ni

dbSelectArea("SZP")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra o arquivo conforme perguntas antes de mostrar     ³
//³ o browse                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PLNFiltra()
dbGoTop()
// MarkBrow("SZP","ZP_OK",  ,  ,   , cMarca)
//
aCampos := {}
AADD(aCampos,{"ZP_OK"            		,""," "})
AADD(aCampos,{"ZP_OPMIDO"    		,"","Num. Plano "    })
AADD(aCampos,{"ZP_ANO"    			,"","Ano"    })
AADD(aCampos,{"ZP_EMISSAO"  		,"","Emissao"    })
AADD(aCampos,{"ZP_PRODUTO"  		,"","Produto"    })
AADD(aCampos,{"ZP_DESCPRD"      	,"","Descricao" })
AADD(aCampos,{"ZP_QUANT"    		,"","Quantidade"    })
AADD(aCampos,{"ZP_CLIENTE"    		,"","Cliente" ,   })
AADD(aCampos,{"ZP_LOJA"    			,"","Loja"    })
AADD(aCampos,{"ZP_NOMCLIE"    		,"","Nome"  , Posicione('SA1' , 1 , xFilial('SA1') + SZP->ZP_CLIENTE + SZP->ZP_LOJA, 'A1_NOME' )})
AADD(aCampos,{"ZP_RELEASE"	    	,"","Release"    })
AADD(aCampos,{"ZP_MULTPLO"    		,"","Multiplo"    })
AADD(aCampos,{"ZP_NMLIB1"    		,"","1 Liberacao"   })
AADD(aCampos,{"ZP_DTLIB1"    		,"","Data"    })
//
aCores := {} // Limpando a variavel
//Aadd(aCores,{"empty(C2_USLIB1) .and. empty(C2_USLIB2) .AND. C2_LIBER <>'OK' "    ,"BR_VERMELHO" })
Aadd(aCores,{" empty(ZP_USLIB1) .and. empty(ZP_USLIB2) .AND. ZP_LIBER <> 'OK' "    ,"BR_VERMELHO" })
Aadd(aCores,{"!empty(ZP_USLIB1) .and. empty(ZP_USLIB2) .AND. ZP_LIBER <> 'OK' "    ,"BR_AMARELO"  })
Aadd(aCores,{"!empty(ZP_USLIB1) .and. !empty(ZP_USLIB2) .AND. ZP_LIBER == 'OK' "   ,"BR_VERDE"    })
//                                                                      	
MarkBrow("SZP","ZP_OK", ,aCampos , , cMarca , , , , , , , , , aCores )
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna indices do SZP                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("ZP2")
dbSetOrder(1 ) // Ordenado pelo numero do Plano do Cliente
aEval(aIndTmp, {|cFile| fErase(cFile+OrdBagExt())})


RETURN





///////////////////////////////////////////////////////////////////////////////////////////////////
Static Function MenuDef()

/*
PRIVATE aRotina	:= {	{"Pesquisar"         	,"u_LPLNPesqui"	,0,1,0,.f.},;
{'Visualizar ' 			,"U_VISUPLANO"	,0,4,0,.f.},;
{'Aprovar ' 				,"U_APROVPL"		,0,5,0,.f.},;
{'Legenda '				,"u_Mid_LegPlP"   ,0,5,0,.f.} }
*/
PRIVATE aRotina	:= {	{"Pesquisar"         	,"AxPesqui"	,0,1,0,.f.},;
									{'Visualizar ' 			,"U_VISUP"		,0,4,0,.f.},;
									{'Aprovar ' 			,"U_APROV"		,0,5,0,.f.},;
									{'Excluir Plano'     ,"U_EXCLUIPLN"  ,0,5,0,.f.},;
									{'Legenda '				,"u_Mid_LegPlP"   	,0,5,0,.f.} }



Return(aRotina)
//------------------------------------------------------------------------------------------------
USER FUNCTION VISUP()
A650VIEW( 'SZP', SZP->( RECNO() ), 2 )
Return()
//------------------------------------------------------------------------------------------------
//  A funcao abaixo tem como objetivo realizar a aprovacao do plano, verificando o status do aprovador,
// Bem como a sua existencia no cadastro de aprovadores
User Function APROV()
If  ! MsgYesno( 'Deseja Realmente aprovar os itens Selecionados ?' )
	Return()
Endif
//
DbSelectArea('SZP')
DbGoTop()
While !eof()
	if ZP_ok == cMarca

		if SZP->ZP_OPSOK <> 'S' // Se o valor do campo for = N indica que as OPs nao foram finalizadas corretamente e impede a liberacao para PNP2....
			Alert('O plano '+SZP->ZP_OPMIDO+' teve problema em sua geração!!'+chr(13)+'Favor altera-lo e gerar as fichas novamente antes de liberar para Produção.')
			return
		endif
		
		if SZP->ZP_OPGERAD <> 'S' 
			Alert('O plano '+SZP->ZP_OPMIDO+' ainda nao está 100% gerado, aguarde a conclusão!!'+chr(13)+'Favor aguardar até que o plano esteja completo.')
			return
		endif
//		Alert('MARCA-> '+SZP->ZP_NUM) 
		// O bloco abaixo fara a verificacao quanto a seu o usuario podera realizar todas as liberacoes de uma so vez ou se ele somente podera faze-la
		// na primeira ou seguna vez
		//
		if substr( cUserCod, 1,1 ) == '1' // O usuario somente pode realizar uma liberacao por vez
			Reclock('SZP' , .f. )
			if empty( ZP_USLIB1 )
				//
				Replace ZP_USLIB1 	WITH  substr( cUserCod, 2 )
				Replace ZP_DTLIB1 	WITH  dDataBase
				Replace ZP_HRLIB1 	WITH  Time()
//				Replace C2_NMLIB1 	WITH  UsrRetname( C2_USLIB1 )
				//Conforme  CHAMADO HDi 002770, foi solicitado que o usuario faça apenas uma aprovacao...				
					Replace ZP_USLIB2 	WITH  substr( cUserCod, 2 )
					Replace ZP_DTLIB2	WITH  dDataBase
					Replace ZP_HRLIB2 	WITH  Time()
//					Replace C2_NMLIB2 	WITH  UsrRetname( C2_USLIB2)					
					//
					// Aqui o usuario libera o plano de producao, tornando passivel de transformacao
					Replace ZP_LIBER		WITH  'OK'
				//
			Else
				//
			if ZP_USLIB1 <> substr( cUserCod, 2 )
					Replace ZP_USLIB2 	WITH  substr( cUserCod, 2 )
					Replace ZP_DTLIB2	WITH  dDataBase
					Replace ZP_HRLIB2 	WITH  Time()
					Replace ZP_NMLIB2 	WITH  UsrRetname(ZP_USLIB2)					
					//
					// Aqui o usuario libera o plano de producao, tornando passivel de transformacao
					Replace ZP_LIBER		WITH  'OK'
				Endif
				//
			Endif
			Msunlock()
			//
		Elseif  substr( cUserCod, 1,1 ) == '2' // O usuario podera realizar todas as liberacoes de uma so vez
			Reclock('SZP' , .f. )
			if empty( ZP_USLIB1 )
				//
				Replace ZP_USLIB1 	WITH  substr( cUserCod, 2 )
				Replace ZP_DTLIB1 	WITH  dDataBase
				Replace ZP_HRLIB1 	WITH  Time()
				Replace ZP_NMLIB1 	WITH  UsrRetname( ZP_USLIB1 )
				//
			Endif
			//
			Replace ZP_USLIB2 	WITH  substr( cUserCod, 2 )
			Replace ZP_DTLIB2	WITH  dDataBase
			Replace ZP_HRLIB2 	WITH  Time()
//			Replace ZP_NMLIB2 	WITH  UsrRetname( C2_USLIB2 )
			//
			//  Aqui o usuario libera o plano de producao, tornando passivel de transformacao
			Replace ZP_LIBER		WITH  'OK'
			//
			Msunlock()
			//
		Endif
		//
	Endif
	// cUserCod
	DbSkip()
Enddo
//
Return()


Static FUNCTION PLNFiltra(nOrder)
LOCAL cIndice,nInd,cFirmaCond:=""
Local cNomeInd:=CriaTrab(NIL,.F.)
nOrder := If(nOrder=Nil,10,nOrder)

Aadd(aIndTmp, cNomeInd)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera index de trabalho do SZP                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZP")
dbSetOrder( 1 )
cIndice   := Indexkey()
cFirmaCond += "ZP_FILIAL=='"+xFilial("SZP")+"' .AND. ZP_LIBER <> 'OK' .AND. " 
cFirmaCond += ' ZP_ANO == "'+cValToChar(Year(dDatabase))+'" .AND. !Empty( ZP_OPMIDO ) '

IndRegua("SZP",cNomeInd,cIndice,,cFirmaCond,STR0006)	//"Selecionando Registros..."

nInd := RetIndex("SZP")
dbSetOrder(nInd+1)
Return



////////////////////////////////////////////////////////////////////////////////////////////////
//Função desenvolvida com objetivo de excluir o plano desejado 
User Function EXCLUIPLN()
If  ! MsgYesno( 'Deseja Realmente realmente excluir o(s) plano(s) selecionado(s) ?' )
	Return()
Endif
//
DbSelectArea('SZP')
DbGoTop()
While !SZP->(eof())
	if ZP_ok == cMarca

		// o bloco abaixo fará uma verificacao nos arquivos SZ7, SZ3 e SC2 para verificar se ja foi feito algum apontamento, 
		// caso tenha ocorrido, nao será permitido as exclusoes....
		if Select("TRBZ7") > 0 
			dbSelectArea('TRBZ7')
			dbCloseArea()
		endif
		cQSZ7 := " SELECT Z7_NUMFC from SZ7010 where D_E_L_E_T_ =  ' ' AND Z7_PLANO = '"+SZP->ZP_OPMIDO+"' AND Substring(Z7_DTDIGIT,1,4) = '"+SZP->ZP_ANO+"' AND Z7_FILIAL = '"+xFilial("SZ7")+"' "
		nCount := 0
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQSZ7),'TRBZ7',.T.,.T. )		
		dbSelectArea('TRBZ7')
		dbGotop()
		while !TRBZ7->(eof())
			 nCount++
			TRBZ7->(dbSkip())
		enddo
		if nCount > 0 
			Alert('Já existem fichas apontadas, exclusao nao permitida! ')
			Return
		endif
		
		if Select("TRBZ3") > 0
			dbSelectArea("TRBZ3")
			dbCloseArea()
		endif
		
		cQSZ3 := " SELECT Z3_NUMFC FROM SZ3010 where D_E_L_E_T_ = ' ' AND Z3_PLANO = '"+SZP->ZP_OPMIDO+"' AND Substring(Z3_DTFICHA,1,4) = '"+SZP->ZP_ANO+"' "
		cQSZ3 += " AND Z3_STATUS <> 'A' AND Z3_FILIAL = '"+xFilial("SZ3")+"' "
		
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQSZ3), 'TRBZ3', .T., .T. )
		nCount := 0
		dbSelectArea('TRBZ3')
		dbGotop()
		while !TRBZ3->(eof())
			nCount++
			TRBZ3->(dbSkip())
		enddo
		
		if nCount > 0
			Alert('Já existem fichas apontadas, exclusão não permitida! ')
			Return 
		endif
		
		if Select("TRBC2") > 0 
			dbSelectArea("TRBC2")
			dbCloseArea()
		endif
		
		cQSC2 := " SELECT C2_NUM from SC2010 WHERE C2_FILIAL = '"+xFilial('SC2')+"' AND C2_OPMIDO = '"+SZP->ZP_OPMIDO+"' AND SUBSTRING(C2_EMISSAO,1,4)= '"+SZP->ZP_ANO+"' "
		cQSC2 += " AND C2_QUJE > 0 " 
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,,cQSC2), "TRBC2", .T.,.T.)
		
		nCount := 0
		dbSelectArea("TRBC2")
		dbGotop()
		while !TRBC2->(eof())
			nCount++
			TRBC2->(dbSkip())
		enddo
		
		if nCount > 0
			Alert('Já existe apontamento de peças para este plano, exclusão não permitida! ')
			Return
		endif
// Faz a exclusao dos itens de SZ3 caso tenha passado por todas as condicoes anteriores


		if Select("TRBZ3") > 0
			dbSelectArea("TRBZ3")
			TRBZ3->(dbCloseArea())
		endif
		
		cQSZ3 := " UPDATE SZ3010 SET D_E_L_E_T_ = '*' where D_E_L_E_T_ = ' ' AND Z3_PLANO = '"+SZP->ZP_OPMIDO+"' AND Substring(Z3_DTFICHA,1,4) = '"+SZP->ZP_ANO+"' "
		cQSZ3 += " AND Z3_FILIAL = '"+xFilial("SC2")+"' "
		
		nret1 := TcSqlExec( cQSZ3 )
				
//Faz a exclusao das OPS no arquivo SC2
		if Select("TRBC2") > 0 
			dbSelectArea("TRBC2")
			dbCloseArea()
		endif
		
		cQSC2 := " SELECT C2_NUM from SC2010 WHERE C2_FILIAL = '"+xFilial('SC2')+"' AND C2_OPMIDO = '"+SZP->ZP_OPMIDO+"' AND SUBSTRING(C2_EMISSAO,1,4)= '"+SZP->ZP_ANO+"' AND D_E_L_E_T_ = ' ' "
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,,cQSC2), "TRBC2", .T.,.T.)
		
		nCount := 0
		dbSelectArea("TRBC2")
		dbGotop()
		
		dbSelectArea('SC2')
		dbSetOrder(1)
			while !TRBC2->(eof())
				if dbSeek(xFilial('SC2')+TRBC2->C2_NUM)
					aCab := {}
					AAdd( aCab, {'C2_FILIAL'		,		 XFILIAL('SC2' )				,			nil					})
					AAdd( aCab, {'C2_NUM' 			, 		 SC2->C2_NUM					,			nil					})
					AAdd( aCab, {'C2_ITEM'			,		 '01' 							,			nil					})
					AAdd( aCab, {'C2_SEQUEN'		,	     '001'							,			nil					})
					AAdd( aCab, {'C2_PRODUTO'		,		 SC2->C2_PRODUTO				,			nil					})
					AAdd( aCab, {'C2_QUANT'		    ,		 SC2->C2_QUANT					, 			nil					})
					AAdd( aCab, {'C2_LOCAL'		    ,		 SC2->C2_LOCAL					,			nil					})
					AAdd( aCab, {'C2_CC'		  	,	 	 SC2->C2_CC						,			nil 				})
					AAdd( aCab, {'C2_DATPRI'	    ,		 SC2->C2_DATPRI					,			nil					})
					AAdd( aCab, {'C2_DATPRF'		,		 SC2->C2_DATPRF					,			nil					})
					AAdd( aCab, {'C2_EMISSAO'	    ,	     SC2->C2_EMISSAO				,			nil					})
					AAdd( aCab, {'C2_OPMIDO'	    ,		 SC2->C2_OPMIDO					,			nil		  			})
					AAdd( aCab, {'C2_CLIENTE'	    ,		 SC2->C2_CLIENTE				,			nil		  			})
					AAdd( aCab, {'C2_LOJA' 			, 		 SC2->C2_LOJA					,  			nil					})
					AAdd( aCab, {'C2_LADO'			,		 SC2->C2_LADO					, 			nil					})
					AAdd( aCab, {'C2_RELEASE' 		,		 SC2->C2_RELEASE				, 			nil 				})
					AAdd( aCab, {'C2_DTRELE'		, 		 SC2->C2_DTRELE					, 			nil 				})
					AAdd( aCab, {'C2_ITEMCTA'		,		 xFilial("SC2")					, 			nil 				})
					AAdd( aCab, {'C2_QTDLOTE'	    ,	     SC2->C2_QTDLOTE				,			nil					})
					AAdd( aCab, {'C2_OBS'           ,       SC2->C2_OBS						,			nil        			})
					AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
					AAdd( aCab, {"AUTEXPLODE"       ,        'S'							,			NIL 			   	})
					
					
					lMsErroAuto := .f.
					msExecAuto({|x,Y| Mata650(x,Y)},aCab,5)
				
						If lMsErroAuto
							MostraErro()
						else
							incProc("Excluindo plano - Por Favor Aguarde.... "+SC2->C2_NUM)
						endif
				endif
			TRBC2->(dbSkip())
			enddo
			Alert('Plano Excluido com Sucesso....')
	endif
	SZP->(DbSkip())
Enddo
//
Return()


////////////////////////////////////////////////////////////////////////////////////
//Funçao com objetivo de verificar se todas as peças do plano estao geradas 
//corretamente antes de liberar para ficha producao de corte
////////////////////////////////////////////////////////////////////////////////////
static function chkPln()
local lRet := .T.
local cN1  := 'PC'
local cPlano := SZP->ZP_OPMIDO
local cAno   := SZP->ZP_ANO
Local i
aStru1 := {}
aStru2 := {} 
dbSelectArea('SZP')
dbSetOrder(2)
//if dbSeek(xFilial('SZP')+cPlano+cAno)
	cGetCodKit := SZP->ZP_PRODUTO
	nGetQtde   := SZP->ZP_QUANT
	if SZP->ZP_PLNPARC == 'N' //.and. Posicione('SB1',1,xFilial('SB1')+SZP->ZP_
		cQuery:= " SELECT G1_COMP, G1_QUANT FROM SG1010 WHERE D_E_L_E_T_ = ' ' AND G1_FILIAL='"+xFilial("SG1")+"' AND G1_COD = '"+cGetCodKit+"' AND SUBSTRING(G1_COMP,1,3) <> 'MOD' " 


		if select('TRBG1') > 0
			DbSelectArea( 'TRBG1' )
			DbCloseArea()
		Endif
	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBG1',.T.,.T. )
	
		dbSelectArea("TRBG1")
		DbGoTop()
	
		//Verifica se o produto solicitado eh KIT
		if Posicione('SB1',1,xFilial('SB1')+cGetCodKit,"B1_UM") =='KT' 
			//Verifica se o item empenhado eh material do grupo 16,40 ou 48 e gera Ordem de Producao do item lancado...
			if Posicione('SB1',1,xFilial('SB1')+TRBG1->G1_COMP,"B1_GRUPO") $ '16  |40  |48  |40A '
				AADD(aStru2, {cGetCodKit, nGetQtde})                                         
				cN1 := 'PC1'
				lPc := .T.
			else
			    while !TRBG1->(eof())
		    		AADD(aStru1, {TRBG1->G1_COMP, TRBG1->G1_QUANT})
		    		cCodAux := Posicione('SG1',1,xFilial('SG1')+TRBG1->G1_COMP,"G1_COD")
		    		if Posicione('SB1',1,xFilial('SB1')+SG1->G1_COMP,"B1_GRUPO") $ '16  |40  |48  |40A '
		    			cN1 := ''
		    		endif
		    		TRBG1->(dbSkip())
			    enddo 
			endif
			if cN1 == 'PC' 
				for i:=1  to len(aStru1)
		   			dbSelectArea('SG1')
			   		dbSetOrder(1)
				   	dbSeek(xFilial('SG1')+aStru1[i][1])
		   			while !SG1->(eof()).and.SG1->G1_COD == aStru1[i][1]
						incProc("Analisando pecas -> "+SG1->G1_COMP)
						AADD(aStru2, {SG1->G1_COMP, aStru1[i][2]*SG1->G1_QUANT})
			    		SG1->(dbSkip())
				   	enddo
			   	 next i
			endif
		else
			if Posicione('SB1',1,xFilial('SB1')+TRBG1->G1_COMP,"B1_GRUPO") $ '16  |40  |48  |40A '
				AADD(aStru2, {cGetCodKit, nGetQtde})                                         
					cN1 := 'PC1'
					lPc := .T.
			else
		    	while !TRBG1->(eof())
	   				AADD(aStru2, {TRBG1->G1_COMP, TRBG1->G1_QUANT})
		   			TRBG1->(dbSkip())
			    enddo 
		    	cN1 := 'PC' 
			endif 
		endif		
	endif
	//Rotina para remover as peças de material dublado....
	aStruAux := aStru2
	for i:= 1 to len(aStruAux)
		if i <= Len(aStruAux)
		    cCodAux := Posicione('SG1',1,xFilial('SG1')+aStruAux[i][1],"G1_COMP")
	    	if Posicione('SB1',1,xFilial('SB1')+cCodAux,'B1_GRUPO') $ '45  |21  |20  '
				nPos := aScan(aStru2, {|x| x[1] == aStruAux[i][1]})
				if nPos > 0 .and. nPos <= Len(aStru2)
					aDel(aStru2, nPos)
					ASIZE(aStru2,Len(aStru2)-1)
				endif
			endif
		endif
	next i                         

	cQuery := " SELECT COUNT(*) NPECAS FROM SC2010 WHERE D_E_L_E_T_ = ' ' AND C2_FILIAL = '"+xFilial('SC2')+"' AND SUBSTRING(C2_EMISSAO,1,4)='"+cAno+"' AND C2_OPMIDO = '"+cPlano+"' "
	if select('TMPC2') > 0 
		dbSelectArea('TMPC2')
		TMPC2->(dbCloseArea())
	endif
	dbUseArea(.T., 'TOPCONN', tcGenQry(,, cQuery), 'TMPC2', .T.,.F.)
//	Alert('TOTAL DE FICHAS-> '+cValToChar(TMPC2->NPECAS)+' Analisado no Array-> '+cValToChar(len(aStru2)))
	if TMPC2->NPECAS < Len(aStru2)
		lRet := .F. 
	endif
//endif

return lRet