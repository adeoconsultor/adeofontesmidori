#INCLUDE "Protheus.ch"
#INCLUDE "TBICONN.CH" 
#INCLUDE "TOPCONN.CH" 

//+-----------------------------------------------------------------------------------//
//|Empresa...: MIDORI ATLANTICA
//|Funcao....: MD_AJUSSD4()
//|Autor.....: Anesio G.Faria - TAGGs Consultoria
//|Data......: 21 de Fevereiro 2011
//|Uso.......: SIGAPCP
//|Versao....: Protheus 10    
//|Descricao.: Função para Ajuste dos empenhos no arquivo SD4 conforme alteração feita 
//|            Pelo usuário no momento da separação do couro para corte 
//|Observação: Esta função foi desenvolvida para após o usuário confirmar a quantidade 
//|			   real de Couro Separado, o sistema já faz o ajuste de empenho automático
//|            conforme confirmação do usuario
//+-----------------------------------------------------------------------------------//
//|                                FUNÇÕES UTILIZADAS
//+-----------------------------------------------------------------------------------//
//|Funcao....: GeraAjuste()
//|Descricao.: Faz o ajuste de empenho para o produto
//|Observação: 
//+-----------------------------------------------------------------------------------//


User function MD_AJUSSD4(cOPSD4)
//	Alert("cOPSD4->"+cOPSD4)
	dbSelectArea("SD4")
	dbSetOrder(2)
	dbSeek(xFilial("SD4")+cOPSD4)   
//		Alert("OP: "+SD4->D4_OP) 
		dbSelectArea("SB2") 
		dbSetOrder(1)
		dbSeek(xFilial("SB2")+SD4->(D4_COD+D4_LOCAL))
//			Alert("Necessita: "+cValToChar(SD4->D4_QUANT)+" Possui: "+cValToChar(SB2->B2_QATU))
			if SB2->B2_QATU < SD4->D4_QUANT
//				Alert("Acessos Gera Ajuste")
				Processa({ || GeraAjuste(cOPSD4, SD4->D4_QUANT - SB2->B2_QATU, SD4->D4_COD, SD4->D4_LOCAL)})
			endif

return


*------------------------------------*
Static Function GeraAjuste(cOPSD4, nQtdeSZ3, cProdSD4, cLocSD4)
*------------------------------------*
Local _cDoc := ""
_aLinha = {}
_aAutoSD3 = {}                              

NQTDETRANS := nQtdeSZ3
//Alert("chamou....")

//lOk := MsgYesNo("Deseja Gerar Transferencia dos Itens selecionados?","Atenção")
// Gera numero para proximo documento.
_cDOC3:= Padr(cOPSD4,7)+'AJ'



// Inclui uma linha para os campos do cabecalho
aAdd (_aAutoSD3,{ _cDOC3, ddatabase})

	aadd (_aLinha, cProdSD4) // Produto origem
	aadd (_aLinha, Substr(Posicione("SB1",1,xFilial("SB1")+cProdSD4,"B1_DESC"),1,30)) // Descricao produto origem
	aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+cProdSD4,"B1_UM")) // UM origem
	aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+cProdSD4,"B1_LOCPAD")) // Almox origem
	aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+cProdSD4,"B1_LOCPAD")) // Endereco origem
	aadd (_aLinha, cProdSD4) // Produto destino
	aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+cProdSD4,"B1_DESC")) // Descricao produto origem
	aadd (_aLinha, Posicione("SB1",1,xFilial("SB1")+cProdSD4,"B1_UM")) // UM destino
	aadd (_aLinha, Posicione("SBZ",1,xFilial("SBZ")+cProdSD4,"BZ_LOCPAD")) // Almox destino
	aadd (_aLinha, cLocSD4) // Endereco destino
	aadd (_aLinha, '') // Num serie
	aadd (_aLinha, '') // Lote
	aadd (_aLinha, '') // Sublote
	aadd (_aLinha, criavar('D3_DTVALID'))
	aadd (_aLinha, 0) // Potencia
	aadd (_aLinha, nQtdeTrans) // Quantidade
	nQtdeSeg := Iif(Posicione(("SB1"),1,xFilial("SB1")+cProdSD4,"B1_TIPCONV")=='M', nQtdeTrans*Posicione(("SB1"),1,xFilial("SB1")+cProdSD4,"B1_CONV"),nQtdeTrans / Posicione(("SB1"),1,xFilial("SB1")+cProdSD4,"B1_CONV"))
	aadd (_aLinha, nQtdeSeg) // Qt seg.UM
	aadd (_aLinha, '') //criavar("D3_ESTORNO")) // Estornado
	aadd (_aLinha, criavar("D3_NUMSEQ")) // Sequencia (D3_NUMSEQ)
	aadd (_aLinha, '') //criavar("D3_LOTECTL")) // Lote destino
	aadd (_aLinha, criavar("D3_DTVALID")) // Validade
	aadd (_aLinha, criavar("D3_ITEMGRD")) // Item da Grade
	aadd (_aAutoSD3, aclone (_aLinha))

	if len (_aAutoSD3) > 1 // A primeira posicao refere-se aos campos do cabecalho
	   lMSErroAuto = .F.
	   MSExecAuto({|x| MATA261(x)},_aAutoSD3,2)
	   If lMsErroAuto
			MostraErro ()
	   endif
	endif

  //	Alert("Ajuste realizado com sucesso....") 
Return 
//+-----------------------------------------------------------------------------------//
//| Fim do Programa MD_AJUSSD4.PRW
//+-----------------------------------------------------------------------------------//