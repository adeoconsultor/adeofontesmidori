#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"
#INCLUDE "TOPCONN.CH"

//+-----------------------------------------------------------------------------------//
//|Empresa...: MIDORI ATLANTICA
//|Funcao....: MTA650E() - Ponto de Entrada chamado no ato da exclusão de uma OP.
//|Autor.....: Anesio G.Faria - TAGGs Consultoria
//|Data......: 22 de Fevereiro 2011
//|Uso.......: SIGAPCP
//|Versao....: Protheus 10    
//|Descricao.: Função para Exclusao das Fichas de Corte caso já tenha sido gerada 
//|			   Excluirá tambem os apontamentos caso existam...
//|Observação: Esta função foi desenvolvida para após o usuário Solicitar a exclusao de 
//|			   OP, o sistema verifica se existem Fichas de Corte SZ3 lançados e 
//|            Apontamentos SZ7. Caso seja verdadeiro, o sistema faz a exclusao dos mesmos
//+-----------------------------------------------------------------------------------//
//|                                FUNÇÕES UTILIZADAS
//+-----------------------------------------------------------------------------------//

User Function MTA650E()
//////////////////////////                    

Local _aLinha   := {}
Local _aAutoSD3 := {}                              
Local _cDOC3    := ""
if xFilial("SC2") == '08'
	C2Num    := SC2->C2_NUM
	C2Plano  := SC2->C2_OPMIDO
	lOk      := .F.
	lOkDev   := .F.
	// o bloco abaixo busca a SZ3 pra saber se tem fichas de corte apontadas
	cQuery1 := "Select Count(*) AS TOTREC FROM SZ7010 WHERE Z7_FILIAL = '08' AND D_E_L_E_T_ = ' ' AND Z7_PLANO = '" + C2Plano + "' "
	//cQuery2 += " Z3_ITEM = '" + TRBC2->C2_ITEM + "' AND Z3_SEQUEN = '" + TRBC2->C2_SEQUEN + "' "

	IF SELECT( 'TRBZ7' ) > 0
		DbSelectArea( 'TRBZ7' )
		DbcloseArea()
	ENDIF

	dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQuery1  ), 'TRBZ7' , .F. , .T. )
		if TRBZ7->TOTREC > 0
			lOk := MsgYesNo("OP possui apontamentos realizados, confirma a exclusão?","Atenção")

//Rotina comentada para enquanto estiver sendo feito as transferencias manuais
//			if lOk 
//				lOkDev := APMsgYesNo("Deseja devolver os estoques do almoxaridado 02 para o almoxarifado 01","Atenção")
//			endif

			FErase("TRBATU"+GetDBExtension())

			//Devolver as quantidades que já foram transferidas de volta ao almox 01. 
			if lOkDev
				cQueryZ7 := "Select Z7_NUMFC, Z7_FASE, Z7_SLDTRAN from SZ7010 where D_E_L_E_T_ = ' ' AND  Z7_FILIAL = '"+xFilial('SZ7')+"' AND Z7_PLANO = '"+C2Plano+"' AND Z7_FASE = '01' "
				IF SELECT( 'TRBZ7' ) > 0
					DbSelectArea( 'TRBZ7' )
					DbcloseArea()
				ENDIF
			
				dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQueryZ7  ), 'TRBZ7' , .F. , .T. )				                                                          
				
				dbSelectArea('TRBZ7')
				_cDOC3:=Substr(TRBZ7->Z7_NUMFC,1,9)
				aAdd (_aAutoSD3,{ _cDOC3, ddatabase})
				while !eof()
					dbSelectArea("SZ7")
					dbSetOrder(1)
					if !dbSeek(xFilial("SZ7")+TRBZ7->(Z7_NUMFC+'06'))                                                                           
							cProd := SUBSTR( TRBZ7->Z7_NUMFC , iif( Substr( TRBZ7->Z7_NUMFC , 1,1 ) $ 'AB', 8 , 7 )  , 6 )						
						if TRBZ7->Z7_SLDTRAN > 0 .and. Posicione("SBZ",1,xFilial("SBZ")+cProd,"BZ_LOCPAD") == '02'
//							cProd := SUBSTR( TRBZ7->Z7_NUMFC , iif( Substr( TRBZ7->Z7_NUMFC , 1,1 ) $ 'AB', 8 , 7 )  , 6 )						
							aadd (_aLinha, cProd) // Produto origem
							aadd (_aLinha, Substr(Posicione("SB1",1,xFilial("SB1")+cProd,"B1_DESC"),1,30)) // Descricao produto origem
							aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+cProd,"B1_UM")) // UM origem
							aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+cProd,"B1_LOCPAD")) // Almox origem
							aadd (_aLinha, Posicione("SBZ",1,xFilial("SBZ")+cProd,"BZ_LOCPAD")) // Almox destino
							aadd (_aLinha, cProd) // Produto destino
							aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+cProd,"B1_DESC")) // Descricao produto origem
							aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+cProd,"B1_UM")) // UM destino
							aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+cProd,"B1_LOCPAD")) // Endereco origem
							aadd (_aLinha, SB2->B2_LOCAL) // Endereco destino
							aadd (_aLinha, '') // Num serie
							aadd (_aLinha, '') // Lote
							aadd (_aLinha, '') // Sublote
							aadd (_aLinha, criavar('D3_DTVALID'))
							aadd (_aLinha, 0) // Potencia
							aadd (_aLinha, SZ7->Z7_SLDTRAN) // Quantidade
							nQtdeSeg := Iif(Posicione(("SB1"),1,xFilial("SB1")+cProd,"B1_TIPCONV")=='M', SZ7->Z7_SLDTRAN*Posicione(("SB1"),1,xFilial("SB1")+cProd,"B1_CONV"),SZ7->Z7_SLDTRAN / Posicione(("SB1"),1,xFilial("SB1")+cProd,"B1_CONV"))
							aadd (_aLinha, nQtdeSeg) // Qt seg.UM
							aadd (_aLinha, '') //criavar("D3_ESTORNO")) // Estornado
							aadd (_aLinha, criavar("D3_NUMSEQ")) // Sequencia (D3_NUMSEQ)
							aadd (_aLinha, '') //criavar("D3_LOTECTL")) // Lote destino
							aadd (_aLinha, criavar("D3_DTVALID")) // Validade
							aadd (_aLinha, criavar("D3_ITEMGRD")) // Item da Grade
							aadd (_aAutoSD3, aclone (_aLinha))
						endif
					endif
					TRBZ7->(dbSkip())
				enddo
						
				if len (_aAutoSD3) > 1 // A primeira posicao refere-se aos campos do cabecalho
				   lMSErroAuto = .F.
				   MSExecAuto({|x| MATA261(x)},_aAutoSD3,2)
				   If lMsErroAuto
						MostraErro ()
				   endif
				endif
			endif
			
			if lOk
				cQuery := "UPDATE "+ RetSqlName( 'SZ7' ) + " SET D_E_L_E_T_ = '*' where Z7_FILIAL = '" + xFilial('SZ7') + "' and Z7_PLANO ='"+C2Plano+"' "
				nret1 := TcSqlExec( cQuery )
//				MsgInfo("Apontamentos de Fichas de Corte Eliminada com sucesso...")				
			else
				return .f.	
			endif
		endif
	
	
	// o bloco abaixo busca a SZ3 pra saber se tem fichas de corte geradas
	cQuery2 := "Select Count(*) AS TOTREC FROM SZ3010 WHERE Z3_FILIAL = '08' AND D_E_L_E_T_ = ' ' AND Z3_NUMOP = '" + C2Num + "' "

	IF SELECT( 'TRBZ3' ) > 0
		DbSelectArea( 'TRBZ3' )
		DbcloseArea()
	ENDIF


	dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQuery2  ), 'TRBZ3' , .F. , .T. )
		if TRBZ3->TOTREC > 0
			if lOk
				cQuery := "UPDATE "+ RetSqlName( 'SZ3' ) + " SET D_E_L_E_T_ = '*' where Z3_FILIAL = '" + xFilial('SZ3') + "' and Z3_NUMOP ='"+ Alltrim( C2Num )
				cQuery +="' "
				nret1 := TcSqlExec( cQuery )
			endif
		endif    
	if lOk
		MsgInfo("Fichas de Corte Eliminada com sucesso...")
	endif
endif
Return .T.
