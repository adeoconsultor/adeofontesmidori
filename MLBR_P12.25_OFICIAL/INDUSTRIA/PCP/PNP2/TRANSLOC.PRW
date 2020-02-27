#INCLUDE "Protheus.ch"
#INCLUDE "TBICONN.CH" 
#INCLUDE "TOPCONN.CH" 

//+-----------------------------------------------------------------------------------//
//|Empresa...: MIDORI ATLANTICA
//|Funcao....: U_TRANSLOC()
//|Autor.....: Anesio G.Faria - TAGGs Consultoria
//|Data......: 18 de Fevereiro 2011
//|Uso.......: SIGAPCP
//|Versao....: Protheus 10    
//|Descricao.: Função para Transferencia de Estoque quando estiver Consumo previsto 
//|            em armazem diferente do armazem 01
//|Observação: Esta função foi desenvolvida para que nao fique produtos empenhados no
//|			   armazem 01, facilitando o controle de estoque
//+-----------------------------------------------------------------------------------//
//|                                FUNÇÕES UTILIZADAS
//+-----------------------------------------------------------------------------------//
//|
//|Funcao....: ChamaTroca()
//|Descricao.: Chama função de Transferencia
//|Observação: 
//|
//|Funcao....: GeraTroca()
//|Descricao.: Faz a Transferencia de Locais
//|Observação: 
//+-----------------------------------------------------------------------------------//
User Function TRANSLOC(cgFicha)
//Alert("Transferindo...")
if Substr(Getmv('MV_ARQPROD'),1,3) == 'SBZ'
//	Alert("SBZ")
	Processa({ || GeraTroca(cgFicha) })
endif 


Return
//+-----------------------------------------------------------------------------------//
//|Funcao....: GeraTroca()
//|Descricao.: Faz a Transferencia de Locais
//|Observação: 
//+-----------------------------------------------------------------------------------//
*------------------------------------*
Static Function GeraTroca(cgFicha)
*------------------------------------*
Local _cDoc := ""
Local cProduto := 	SUBSTR( cGFicha , iif( Substr( cGFicha , 1,1 ) $ 'AB', 8 , 7 )  , 6 )
_aLinha = {}
_aAutoSD3 = {}                              

//alert("NUMERO DA OP:"+cOP+"-")

//lOk := MsgYesNo("Deseja Gerar Transferencia dos Itens selecionados?","Atenção")
// Gera numero para proximo documento.
_cDOC3:=Substr(cgFicha,1,7)+Substr(cgFicha,12,2)

if _cDOC3 == space(9)
	_cDOC3 := 'SEM FICHA'
endif

// Inclui uma linha para os campos do cabecalho
aAdd (_aAutoSD3,{ _cDOC3, ddatabase})


nQtdeTrans:= 0                                 
nQtdeSD4 := 0

dbSelectArea("SZ7")
dbSetOrder(1)
//dbSeek(xFilial("SZ7")+cgFicha+'01')
//Alert("CHAMANDO SZ7:"+_cDOC3)

if dbSeek(xFilial("SZ7") + Padr(cgFicha, 20) + '01')
//	Alert("Numero da Ficha:"+Padr(cgFicha, 20) + '|01')
	if SZ7->(Z7_M2APONT <> Z7_SLDTRAN)                    
		nQtdeTrans:= SZ7->(Z7_M2APONT - Z7_SLDTRAN)    
//		Alert("Qtde a Transf:"+cValToChar(nQtdeTrans))
		dbSelectArea("SZ3")
		dbSetOrder(4)
		dbSeek(xFilial("SZ3")+cgFicha)
		dbSelectArea("SD4")
		dbSetOrder(1)
//		Alert("Buscando....:"+Substr(SZ3->Z3_NUMOP,1,6)+SZ3->(Z3_ITEM+Z3_SEQUEN)+"|"+cProduto)
		if dbSeek(xFilial("SD4")+Padr(cProduto,15)+Substr(SZ3->Z3_NUMOP,1,6)+SZ3->(Z3_ITEM+Z3_SEQUEN))
//			Alert("Encontrado....LOCAL:"+SD4->D4_LOCAL+" OP:"+SD4->D4_OP)
			if SD4->D4_LOCAL == '02'
  //				Alert("Entrou em SD4...")
				if nQtdeTrans > 1       
//					Alert("Qtde a Transf >>:"+cValToChar(nQtdeTrans))
					aadd (_aLinha, SD4->D4_COD) // Produto origem
					aadd (_aLinha, Substr(Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_DESC"),1,30)) // Descricao produto origem
					aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_UM")) // UM origem
					aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_LOCPAD")) // Almox origem
					aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_LOCPAD")) // Endereco origem
					aadd (_aLinha, SD4->D4_COD) // Produto destino
					aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_DESC")) // Descricao produto origem
					aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_UM")) // UM destino
					aadd (_aLinha, Posicione("SBZ",1,xFilial("SBZ")+SD4->D4_COD,"BZ_LOCPAD")) // Almox destino
					aadd (_aLinha, SB2->B2_LOCAL) // Endereco destino
					aadd (_aLinha, '') // Num serie
					aadd (_aLinha, '') // Lote
					aadd (_aLinha, '') // Sublote
					aadd (_aLinha, criavar('D3_DTVALID'))
					aadd (_aLinha, 0) // Potencia
					aadd (_aLinha, nQtdeTrans) // Quantidade
					nQtdeSeg := Iif(Posicione(("SB1"),1,xFilial("SB1")+SD4->D4_COD,"B1_TIPCONV")=='M', nQtdeTrans*Posicione(("SB1"),1,xFilial("SB1")+SD4->D4_COD,"B1_CONV"),nQtdeTrans / Posicione(("SB1"),1,xFilial("SB1")+SD4->D4_COD,"B1_CONV"))
					aadd (_aLinha, nQtdeSeg) // Qt seg.UM
					aadd (_aLinha, '') //criavar("D3_ESTORNO")) // Estornado
					aadd (_aLinha, criavar("D3_NUMSEQ")) // Sequencia (D3_NUMSEQ)
					aadd (_aLinha, '') //criavar("D3_LOTECTL")) // Lote destino
					aadd (_aLinha, criavar("D3_DTVALID")) // Validade
					aadd (_aLinha, criavar("D3_ITEMGRD")) // Item da Grade
					aadd (_aAutoSD3, aclone (_aLinha))
				elseif nQtdeTrans <= -1 
					nQtdeTrans := nQtdeTrans * -1
					aadd (_aLinha, SD4->D4_COD) // Produto origem
					aadd (_aLinha, Substr(Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_DESC"),1,30)) // Descricao produto origem
					aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_UM")) // UM origem
					aadd (_aLinha, Posicione("SBZ",1,xFilial("SBZ")+SD4->D4_COD,"BZ_LOCPAD")) // Almox origem
					aadd (_aLinha, SB2->B2_LOCAL) // Endereco origem
					aadd (_aLinha, SD4->D4_COD) // Produto destino
					aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_DESC")) // Descricao produto origem
					aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_UM")) // UM destino
					aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_LOCPAD")) // Almox destino
					aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_LOCPAD")) // Endereco destino
					aadd (_aLinha, '') // Num serie
					aadd (_aLinha, '') // Lote
					aadd (_aLinha, '') // Sublote
					aadd (_aLinha, criavar('D3_DTVALID'))
					aadd (_aLinha, 0) // Potencia                                                            
					dbSelectArea("SB2")
					dbSetOrder(1)
						dbSeek(xFilial("SB2")+SD4->D4_COD+SD4->D4_LOCAL)
							if SB2->B2_QATU - SB2->B2_QEMP < nQtdeTrans
								nQtdeTrans :=  SB2->(B2_QATU - B2_QEMP)
							endif	                                       
					aadd (_aLinha, nQtdeTrans) // Quantidade				
					nQtdeSeg := Iif(Posicione(("SB1"),1,xFilial("SB1")+SD4->D4_COD,"B1_TIPCONV")=='M', nQtdeTrans*Posicione(("SB1"),1,xFilial("SB1")+SD4->D4_COD,"B1_CONV"),nQtdeTrans / Posicione(("SB1"),1,xFilial("SB1")+SD4->D4_COD,"B1_CONV"))
					aadd (_aLinha, nQtdeSeg) // Qt seg.UM
					aadd (_aLinha, '') //criavar("D3_ESTORNO")) // Estornado
					aadd (_aLinha, criavar("D3_NUMSEQ")) // Sequencia (D3_NUMSEQ)
					aadd (_aLinha, '') //criavar("D3_LOTECTL")) // Lote destino
					aadd (_aLinha, criavar("D3_DTVALID")) // Validade
					aadd (_aLinha, criavar("D3_ITEMGRD")) // Item da Grade
					aadd (_aAutoSD3, aclone (_aLinha))
				endif
			endif
			if len (_aAutoSD3) > 1 // A primeira posicao refere-se aos campos do cabecalho
//				Alert("Entrou para transferir...")
			   lMSErroAuto = .F.
			   MSExecAuto({|x| MATA261(x)},_aAutoSD3,2)                   
			   
			   If lMsErroAuto
					MostraErro ()
			   else                                    
			   
//			   	    Alert("ATUALIZANDO SZ7...")
			   		dbSelectArea("SZ7")
		   			RecLock("SZ7",.F.)
		   			Replace Z7_SLDTRAN with Z7_M2APONT
			   		MsUnlock("SZ7")
			   endif
			endif
		endif
	endif
//else
//	Alert("Ficha nao encontrada para fazer a transferencia...Acione o Suporte")
endif
Return 
//+-----------------------------------------------------------------------------------//
//| Fim do Programa TRANSLOC.PRW
//+-----------------------------------------------------------------------------------//