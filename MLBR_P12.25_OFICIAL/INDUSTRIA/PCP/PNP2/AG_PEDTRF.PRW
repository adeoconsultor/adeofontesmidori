#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#define STR0001  "Pesquisar"
#define STR0002  "Visualizar"
#define STR0003  "Incluir"
#define STR0004  "Alterar"
#define STR0005  "Excluir"
#define STR0006  "Cod.barra"
#define STR0007  "Atualizaçäo de Pedidos de Venda"
#define STR0008  "Fornec.:"
#define STR0009  "Cliente: "
#define STR0010  "Totais :"
#define STR0011  "Total :"
#define STR0012 "Desc./Acres.:"
#define STR0013 "Confirma a Inclusao do Pedido ?"
#define STR0014 "Atençäo"
#define STR0015 "Recortar"
#define STR0016  "Copiar"
#define STR0017  "Colar"
#define STR0018  "Calculadora..."
#define STR0019  "Agenda..."
#define STR0020 "Gerenciador de Impressäo..."
#define STR0021 "Help de Programa..."
#define STR0022  "Posiçäo de Clientes"
#define STR0023 "Confirma - <Ctrl-O>"
#define STR0024 "Cancela - <Ctrl-X>"
#define STR0025 "Qt. Vendida : "
#define STR0026  "Saldo : "
#define STR0027  "O item "
#define STR0028 " gerou a Ordem de Producao "
#define STR0029 "Confirma Exclusao ?"
#define STR0030  "Sim"
#define STR0031  "Nao"
#define STR0032  "Legenda"
#define STR0033  "Pedido de Venda em aberto"
#define STR0034 "Pedido de Venda encerrado"
#define STR0035  "Pedido de Venda liberado"
#define STR0036  "Produto sem estoque no deposito especifico"
#define STR0037  "Produto sem saldo por lote (Rastreabilidade)"
#define STR0038  "Atencao!"
#define STR0039  "Este item foi marcado para gerar uma Ordem de Producao mas nao gerou, pois havia saldo disponivel em estoque. Este Pedido de Venda ja comprometeu o saldo necessario."
#define STR0040  "OK"
#define STR0041  "Formas de Pagamento"
#define STR0042  "copiaR"
#define STR0043  "Planilha Financeira"
#define STR0044  "Nota Fiscal"
#define STR0045  "Duplicatas"
#define STR0046  "Vencimento"
#define STR0047  "Valor"
#define STR0048 "Total da Nota"
#define STR0049  "Sair"
#define STR0050  "System Tracker"
#define STR0051  "Vlr. Duplicatas"
#define STR0052  "reTornar"
#define STR0053  "&Retorno"
#define STR0054  "Atencao"
#define STR0055  "Produto deve ser informado no item do pedido de venda"
#define STR0056  "Formacao de Precos"
#define STR0057  "Notas Fiscais de Entrada"
#define STR0058  "Pedido de Venda com Bloqueio de Regra"
#define STR0059  "Pedido de Venda com Bloqueio de Verba"
#define STR0060  "Este pedido nao podera ser excluido pois o mesmo gerou Ordem de Producao."
#define STR0061  "Existem documentos originais informados no pedido referente ao cliente atual. Os vinculos dos respectivos registros serao excluidos. Deseja confirmar operacao ?"
#define STR0062  " nao pode ser alterado porque possui servicos de WMS pendentes. Estorne estes servicos para proceder com a alteracao."
#define STR0063  "Dt. Entrega Ref."
#define STR0064  "Este item"
#define STR0065  "na 1a UM ) nao pode ser alterada."
#define STR0066  "O item "
#define STR0067  "Clientes"
#define STR0068  "Formas"
#define STR0069  "Planilha"
#define STR0070  "Formacao"
#define STR0071  "Tracker"
#define STR0072  "Faturamento do projeto"
#define STR0073  "Nao e permitido o faturamento de Edts do projeto quando o controle de saldo de faturamento de projetos esta ativo. Verifique a EDT/Tarefa do projeto selecionado no item : "
#define STR0074  "Fechar"
#define STR0075  "Saldo do projeto insuficiente"
#define STR0076  "Os projetos selecionados nao possuem saldo suficiente para estes faturamento/remessas. Verifique o valor do item do pedido e o saldo de faturamento/remessa da EDT/Tarefa ."
#define STR0077  "Detalhes"
#define STR0078  "Saldos insuficientes"
#define STR0079  "Este item de pedido de venda esta vinculado a um contrato de parceria, portanto o preco de venda näo pode ser inferior ao preco contratado. Solucäo: Efetuar ajustes no item de pedido de venda para reduzir o preco de venda."
#define STR0080  "Rentabilidade"
#define STR0081  "C.M.V"
#define STR0082  "Vlr.Presente"
#define STR0083  "Lucro Bruto"
#define STR0084  "Margem de Contribuicäo(%)"
#define STR0085  "Estrutura de Produto"
#define STR0086  "Estr.Prod."
#define STR0087  "O saldo deste documento original esta comprometido no(s) seguinte(s) pedido(s) de venda: "
#define STR0088  "Não pode existir referência do Código da"
#define STR0089  " EDT e Codigo da Tarefa no mesmo item."
#define STR0090  "O Código da EDT informado não existe."
#define STR0091  "O Código de Tarefa informado não existe."
#define STR0092  "O Código de Projeto informado não existe."
#define STR0093  "A reserva "
#define STR0094  " pertence ao cliente "
#define STR0095  "Prep.&Doc.Saída"
#define STR0096  "Dt. Entrada De"
#define STR0097  "Dt. Entrada Ate"
#define STR0098  "Retorno de Doctos. de Entrada"
#define STR0099  "Fornecedor"
#define STR0100  "Tipo de Seleção"
#define STR0101  'Nenhum documento encontrado, favor verificar os dados informados  ...'
#define STR0102  "Documento"
#define STR0103  "Con&hecimento"
#define STR0104  "Nao informar servico WMS para itens com endereco informado."
#define STR0105  "Cliente"
#define STR0106  "Opcionais Selecionados"
#define STR0107  "Opcionais"
#define STR0108  "gerou a Solicitacao de Compras"
#define STR0109  "Residuo"
#define STR0110  "O item de venda não pode estar amarrado unicamente ao projeto! (utilize também a EDT ou Tarefa)"
#define STR0111  "Nao sera gerado OS.WMS. Pedido nao utiliza carga."
#define STR0112  "A TES deve ser de Devolução de Despesa do Projeto! Favor verificar a TES."
#define STR0113  "Ainda existe saldo deste documento original pendente de liberação no CQ."
#define STR0114  "Lançamentos da Apuração de ICMS"
#define STR0115  "Este Pedido foi gerado através do módulo de Controle de Lojas, e não poderá ser alterado."
#define STR0116  "Este Pedido foi gerado através do módulo de Controle de Lojas, e somente poderá ser excluído através da exclusão da Venda que o originou."

//////////////////////////////////////////////////////////////////////////////////////////////
//Programa com o objetivo de gerar o pedido de transferencia entre as filiais 
//especificamente os pedidos cortados em PNP1 (Couro) e PNP2 (PVC)
//Desenvolvido por Anesio G.Faria em 26/03/2014 - anesio@anesio.com.br
//Participaram da reuniao de definicao o Sr.Newton Donomai, Thiago Cruz, Edson Oseco e Anesio
//////////////////////////////////////////////////////////////////////////////////////////////


User Function AG_PEDTRF()

Private cGetnPln   := space(20)
Private cGetStApto := '...'
Private cGetStPed  := '...'
Private cGetTES    := Space(03)
Private CGETTXTES  := space(40)
Private cSayNPln   := Space(20)
Private cSayNPln   := Space(20)
Private cSayStApto := Space(20)
Private cSayStPed  := Space(20)
Private nCBoxTrf
Private aItens := {}
Private cGetCC     := iif(cFilant=='08','320300','320700')
//Processa({|| geraped(aItens), "GERANDO PEDIDO"}) 
SetPrvt("oFontStatus","oDlgPedTrf","oGrpPln","oSayNPln","oSayStApto","oSayStPed","oGetnPln","oGetStApto")
SetPrvt("oGrpTES","oSay3","oGetTES","oBtn1","oGet1","oCBoxTrf","oGetCC")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

if cFilant $ '08|09'
	oFontStatu := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
//	oDlgPedTrf := MSDialog():New( 055,233,258,924,"Rotina geradora de Pedido baseado no Plano de Produção....",,,.F.,,,,,,.T.,,,.T. )
 	oDlgPedTrf := MSDialog():New( 155,208,388,899,"Rotina geradora de Pedido baseado no Plano de Produção....",,,.F.,,,,,,.T.,,,.T. )
	


	oGrpPln    := TGroup():New( 004,004,048,336,"Dados do Plano...",oDlgPedTrf,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSayNPln   := TSay():New( 020,008,{||"Numero do Plano: "},oGrpPln,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oSayStApto := TSay():New( 012,192,{||"Status de Apontamento:"},oGrpPln,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
	oSayStPed  := TSay():New( 025,193,{||"Status de Pedido"},oGrpPln,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)      
	oGetnPln   := TGet():New( 018,056,{|u| If(PCount()>0,cGetnPln:=u,cGetnPln)},oGrpPln,108,008,'@!',{ || iif(vldPln(cGetnPln), processa( {|| vldPed(cGetnPln),"Analisando pedidos já gerados"}),"") },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZP","cGetnPln",,)
	oGetStApto := TGet():New( 012,256,{|u| If(PCount()>0,cGetStApto:=u,cGetStApto)},oGrpPln,080,010,'',,CLR_BLACK,CLR_WHITE,oFontStatus,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cGetStApto",,)
	oGetStPed  := TGet():New( 024,256,{|u| If(PCount()>0,cGetStPed:=u,cGetStPed)},oGrpPln,080,010,'',,CLR_BLACK,CLR_WHITE,oFontStatus,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cGetStPed",,)
//	oGrpTES    := TGroup():New( 053,005,088,337,"Dados da TES...",oDlgPedTrf,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oGrpTES    := TGroup():New( 053,005,104,337,"Dados da TES...",oDlgPedTrf,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay2      := TSay():New( 070,178,{||"Filial destino: "},oGrpTES,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,008)
	oSay3      := TSay():New( 069,009,{||"TES:"},oGrpTES,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oGetTES    := TGet():New( 067,025,{|u| If(PCount()>0,cGetTES:=u,cGetTES)},oGrpTES,032,008,'@!',{|| vldTes(cGetTES) },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF4","cGetTES",,)
    oSay4      := TSay():New( 086,010,{||"CENTRO DE CUSTO: "},oGrpTES,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,059,008)
	oBtn1      := TButton():New( 061,269,"GERAR PEDIDO",oGrpTES,{||oDlgPedTrf:End(), ConfPed()},060,020,,,,.T.,,"",,,,.F. )
//oBtnGerPln := TButton():New( 249,268,"Gerar Plano",oDlg1,{|| VLDGer('INC') },090,020,,oFont3,,.T.,,"",,,,.F. )	
//	oGet1      := TGet():New( 067,069,,oGrpTES,104,010,'',,CLR_BLACK,CLR_WHITE,oFontStatus,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","",,)
	oGet1      := TGet():New( 067,069,{|u| If(PCount()>0,cGetTxTES:=u,cGetTxTES)},oGrpTES,104,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cGetTxTES",,)	
	oCBoxTrf   := TComboBox():New( 069,209,{|u| If(PCount()>0,nCBoxTrf:=u,nCBoxTrf)},{"01-B.Funda","04-Alto Alegre","08-PNP 2","19-Barbosa"},056,010,oGrpTES,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nCBoxTrf )
    oGetCC     := TGet():New( 084,069,{|u| If(PCount()>0,cGetCC:=u,cGetCC)},oGrpTES,048,008,'@!',{||Vazio() .Or. Ctb105CC(), vldCC(cGetCC) },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CTT","cGetCC",,)
	//oGetPlano  := TGet():New( 068,060,{|u| If(PCount()>0,cGetPlano:=u,cGetPlano)},oGrpEntrega,076,014,'@!',{|| iif(VldNumPln(cGetPlano),oGetLocal:SetFocus(),oGetPlano:SetFocus())},CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetPlano",,)
	//oGetLocal  := TGet():New( 068,189,{|u| If(PCount()>0,cGetLocal:=u,cGetLocal)},oGrpEntrega,031,014,'',{|| U_AGFLOC() },CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetLocal",,)
	
	
		oDlgPedTrf:Activate(,,,.T.)
else
	Alert("Rotina disponivel apenas para as unidades de corte"+chr(13)+chr(13)+"PNP1 e PNP2 ! ! !")
endif

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Funcao de validação do plano
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static function vldPln(cGetnPln)
local lRet := .T.
local cPln := cGetnPln
if cPln == space(20)
	Alert("Não foi selecionado um plano para analise! ! ! "+chr(13)+chr(13)+"Escolha um plano válido!")
	oGetnPln:setfocus()
	return .F.
endif
cGetStApto := "TESTANDO"
cGetStPed := "ANALISANDO..."
oGetStApto:refresh()
oGetStPed:refresh()
//Alert("Cliente: "+nCBoxTrf)

processa({|| lRet := vldapto(cPln), "VALIDANDO SITUACAO DO PLANO...AGUARDE..." })

return lRet




return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Funcao para chegar a situação do plano... se está apontado total, parcial ou nao apontado...
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static function vldapto(cGetnPln)
local cQuery := ""
local ncount := 0
public aPecas := {} //Peças disponiveis cortadas no kit
cQuery := " SELECT Sum(C2_QUANT) QTDE, Sum(C2_QUJE) QUJE FROM SC2010 WHERE D_E_L_E_T_ = ' ' "
cQuery += " AND C2_FILIAL = '"+xFilial("SC2")+"' AND C2_OPMIDO = '"+cGetnPln+"' " 
//cQuery += " AND C2_QUJE > 0 " 
if Select("TMPC2") > 0
	dbSelectArea("TMPC2")
 	TMPC2->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(,, cQuery), "TMPC2",.T., .T.)

dbSelectArea("TMPC2")
TMPC2->(dbGotop())
nApon := 0
nQtdPc:= 0
while !TMPC2->(eof())                      
	nApon := TMPC2->(QTDE - QUJE)
	nQtdPc := TMPC2->QTDE
	nCount++
	TMPC2->(dbSkip())
enddo

if ncount > 0 .and. nApon <> nQtdPc 
 	if nApon > 0 
		cGetStApto := "02-APONTADO PARCIAL"
		oBtn1:Disable()
	else
	 	cGetStApto := "03-APONTADO TOTAL"
		oBtn1:Enable()	
	endif
else
 	cGetStApto := "01-NAO APONTADO"
	oBtn1:Disable()
 	Alert("Plano não apontado! ! !"+chr(13)+chr(13)+"SELECIONE OUTRO PLANO... !")
 	return .F.
 	oGetStApto:setfocus()
endif
 oGetStApto:refresh()

//Gerar a consulta e gravar em ARRAY para geração do pedido
 cQuery := " SELECT C2_PRODUTO, Sum(C2_QUANT) QTDE, Sum(C2_QUJE) QUJE FROM SC2010 WHERE D_E_L_E_T_ = ' ' "
 cQuery += " AND C2_FILIAL = '"+xFilial("SC2")+"' AND C2_OPMIDO = '"+cGetnPln+"' " 
 cQuery += " AND C2_QUJE > 0 " 
 cQuery += " GROUP BY C2_PRODUTO "
 cQuery += " ORDER BY C2_PRODUTO "
 
 if Select("TMPC2") > 0
 	dbSelectArea("TMPC2")
 	TMPC2->(dbCloseArea())
 endif
 dbUseArea(.T., "TOPCONN", tcGenQry(,, cQuery), "TMPC2",.T., .T.)

dbSelectArea("TMPC2")
TMPC2->(dbGotop())
while !TMPC2->(eof())
	//Posicao 4 refere aos pedidos já gerados
	//Posicao 5 refere a qtde que deverá ser gerado - essa coluna será calculada no final das validacoes
	AADD(aPecas, {TMPC2->C2_PRODUTO, TMPC2->QTDE, TMPC2->QUJE, 0, 0} )
	nCount++
	TMPC2->(dbSkip())
enddo
	 
return .T.

//////////////////////////////////////////////////////////////////////////////////
//Função de validação a TES 
//////////////////////////////////////////////////////////////////////////////////
static function vldTes(cTes)
local lRet := .T.

if cTes < '500'.and.cTes <> space(3)
	Alert("Utilize apenas TES de Saída ! !  ! ")
	return .F.
endif

lRet := Posicione('SF4',1, xFilial("SF4")+cTes,"F4_MSBLQL") == "2"
//Se a TES for bloqueada volta para informar nova TES
if !lRet
	Alert("TES BLOQUEADA PARA USO ! ! ! ")
	Return lRet
else
	cGetTxTES := Posicione('SF4',1, xFilial("SF4")+cTes,"F4_TEXTO")
endif
oGet1:refresh()
return lRet


//////////////////////////////////////////////////////////////////////////////////
//Funcao para verificar se já existe pedido gerado para o plano
//////////////////////////////////////////////////////////////////////////////////
static function vldPed(cPlano)
local cQuery := "" 
local cQSC6  := ""
local nCount := 0
local cPed   := ""
local aItens := {}
Local iIt,i

cQuery := " SELECT C5_NUM, C5_X_PLANO FROM SC5010 WHERE D_E_L_E_T_ = ' ' AND C5_FILIAL = '"+xFilial("SC5")+"' " 
cQuery += " AND C5_X_PLANO = '"+cPlano+"' " 

if Select("TMPC5") > 0 
	dbSelectArea("TMPC5")
	TMPC5->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(,, cQuery), "TMPC5", .T.,.T.)

dbSelectArea("TMPC5")
TMPC5->(dbGotop())
cPed := "'" 
while !TMPC5->(eof())
	cPed := cPed+TMPC5->C5_NUM+"','"
	nCount++
	TMPC5->(dbSkip())
enddo
cPed := Substr(cPed,1,len(cPed)-2)
	if nCount > 0

		cQSC6 := " SELECT C6_PRODUTO, Sum(C6_QTDVEN) C6_QTDVEN FROM SC6010 WHERE D_E_L_E_T_ =' ' AND C6_FILIAL = '"+xFilial("SC6")+"' " 
		cQSC6 += " AND C6_NUM in ("+cPed+") " 
		cQSC6 += " GROUP BY C6_PRODUTO "
		cQSC6 += " ORDER BY C6_PRODUTO " 
		if Select("TMPC6") > 0 
			dbSelectArea("TMPC6") 
			TMPC6->(dbCloseArea())
		endif
		dbUseArea(.T., "TOPCONN", tcGenQry(, , cQSC6), "TMPC6", .T., .T.)
		dbSelectArea("TMPC6")
		TMPC6->(dbGotop())
		while !TMPC6->(eof())
			AADD(aItens, { TMPC6->C6_PRODUTO, TMPC6->C6_QTDVEN,0,0,0 }) 
			TMPC6->(dbSkip())
		enddo
	endif

if len(aItens) > 0 
	cGetStPed := "03-JÁ EXISTE PEDIDO"
	oBtn1:Disable()
	Alert("Já existe Pedido para este plano! ! !"+chr(13)+chr(13)+"SELECIONE OUTRO PLANO... !")
endif

if len(aPecas) > 0 .and. len(aItens) == 0 
	cGetStPed := "01-PEDIDO NAO GERADO"
endif 
//Verifica se já existe pedido de transferencia referente ao plano selecionado
if len(aPecas) > 0 .and. len(aItens) > 0 
	for i:= 1 to len(aPecas)
		for iIt := 1 to len(aItens)
			if aItens[iIt][1] == aPecas[i][1]
				aPecas[i][4] := aItens[iIt][2]
				iIt := len(aItens)
			endif
		next iIt
	next i

//Verifica se do total apontado foi totalmente transferido ou se há saldos
	for i:= 1 to len(aPecas)
		if aPecas[i][3] - aPecas[i][4] > 0 
			i:= len(aPecas)
			cGetStPed := "02-PEDIDO PARCIAL"
		endif
	next i 
	
	if cGetStPed  <> "02-PEDIDO PARCIAL"
		cGetStPed <> "03-PEDIDO TOTAL"
	endif
endif
oGetStPed:refresh()

//Posicao 4 refere aos pedidos já gerados
//Posicao 5 refere a qtde que deverá ser gerado - essa coluna será calculada no final das validacoes
//AADD(aPecas, {TMPC2->C2_PRODUTO, TMPC2->QTDE, TMPC2->QUJE, 0, 0} )
//Calcular a quantidade que deverá ser gerada por item
for i:= 1 to len(aPecas)
	aPecas[i][5] := aPecas[i][3]-aPecas[i][4] 
next i 

aItens := aPecas
return aItens

//////////////////////////////////////////////////////////////////////////////////////
//ROTINA PARA VALIDAR O INICIO DA GERACAO DO PEDIDO DE TRANSFERENCIA
//////////////////////////////////////////////////////////////////////////////////////
static function ConfPed()
local aPedTrf := {}
if APMSGYESNO("Confirma a geração do pedido de transferencia"+chr(13)+"para a filial selecionada? ","ATENÇÃO")
	if Substr(cGetStPed,1,2)=='03' .or. Substr(cGetStPed,1,2) == "02"
		Alert('Já existe pedido TOTAL/PARCIAL para esse plano!'+chr(13)+chr(13)+'Favor selecionar outro plano...')
		return
	endif
	
	if Substr(cGetStApto,1,2) == '01'
		Alert('Plano sem apontamento!'+chr(13)+chr(13)+'Favor selecionar outro plano...')
		return
	endif
	//Faz a validação da TES antes de gerar o pedido
	if !vldTes(cGetTES)
		return
	endif	
	
	processa({|| aPedTrf := vldPed(cGetnPln),"Montando relação de itens..."})
	
	
	processa({|| geraped(aPedTrf), "Gerando pedido de transferencia..." })
/*	for i:= 1 to len(aPedTrf)
		Alert("Item disponivel "+aPedTrf[i][1]+' Qtde: '+cValToChar(aPedTrf[i][5]))
	next i  */
endif

return

//////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////
static function geraped(aItens)

Local nCount     := 0
Local aItemPV    := {}   
Local aAux       := {}
Local aCabPV	 := {}
Local nCount     := 0
Local cQuery 	 := ""
Local cData 	 := dtos(ddatabase)
Local cLoja 	 := Substr(nCBoxTrf,1,2)
Public cCadastro := OemToAnsi(STR0007) //"Atualiza‡„o de Pedidos de Venda"
Public inclui	 := .F.
Public altera	 := .T.
Public aRotina   :=  {	{	OemToAnsi(STR0001),"AxPesqui"		,0,1,0 ,.F.},;		//"Pesquisar"
							{ OemToAnsi(STR0002),"A410Visual"	,0,2,0 ,NIL},;		//"Visual"
							{ OemToAnsi(STR0003),"A410Inclui"	,0,3,0 ,NIL},;		//"Incluir"
							{ OemToAnsi(STR0004),"A410Altera"	,0,4,20,NIL},;		//"Alterar"
							{ OemToAnsi(STR0042),"A410PCopia"	,0,6,0 ,NIL},;		//"Copia"
							{ OemToAnsi(STR0052),"A410Devol"	,0,3,0 ,NIL},;		//"Dev. Compras"
							{ OemToAnsi(STR0095),"Ma410PvNfs"	,0,2,0 ,NIL},;		//"Prep.Doc.Saída"
							{ OemToAnsi(STR0032),"A410Legend"	,0,3,0 ,.F.} }		//"Conhecimento"


//Local cCondPag   := space(3)
//Local cCodLoja   := space(8)
cQuery := " SELECT C2_PRODUTO, C2_LOCAL, Sum(C2_QUANT) QTDE, Sum(C2_QUJE) QUJE FROM SC2010 WHERE D_E_L_E_T_ = ' ' "
cQuery += " AND C2_FILIAL = '"+xFilial("SC2")+"' AND C2_OPMIDO = '"+cGetnPln+"' " 
cQuery += " AND C2_QUJE > 0 " 
cQuery += " GROUP BY C2_PRODUTO, C2_LOCAL  "
cQuery += " ORDER BY 1 " 
if Select("TRBC2") > 0
	dbSelectArea("TRBC2")
 	TRBC2->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", tcGenQry(,, cQuery), "TRBC2",.T., .T.)
ApMsgInfo("TECLE OK para Iniciar a geração do pedido...")
ProcRegua(595300)
dbSelectArea("TRBC2")
TRBC2->(dbGotop())
//cNum := GetSxeNum('SC5','C5_NUM')
///					{"C5_TABELA"    ,"001" 					 ,NIL},;
		aCabPV := {	{"C5_TIPO"		,"N"						,NIL},;
					{"C5_CLIENTE"	,'000001'				,NIL},;
					{"C5_LOJACLI"	,cLoja        		,NIL},;				
					{"C5_CONDPAG"	,"001"					,NIL},;
					{"C5_TIPOCLI"	,'F'						,NIL},;
					{"C5_PEDCLI"    ,cGetnPln                ,NIL},;
					{"C5_EMISSAO"   ,stod(cData)				 ,NIL},;
					{"C5_CODFORN"   ,cFilAnt                   ,NIL},;
					{"C5_PEDSAP"    ,"XX"                ,NIL},;
					{"C5_HORA"      ,""               ,NIL},;
					{"C5_LNSAP"     ,""               ,NIL},;
					{"C5_LOJAGM"    ,""               ,NIL},;
					{"C5_TPFRETE" 	,"S"						,NIL},;
					{"C5_PESOL"		,0						 ,NIL},;
					{"C5_PBRUTO"	,0						 ,NIL},;
					{"C5_X_PLANO" 	,cGetnPln				,NIL},;
					{"C5_MENNOTA"   ,cGetnPln						,Nil} }


dbSelectArea("TRBC2")
dbGotop()        
aItemPV := {}     
cItem := '00' 
while !TRBC2->(eof())
	    IncProc("Gerando Pedido de Transferencia...")
//		IndRegua("Gerando Pedido de Transferencia..."+TRBC2->C2_PRODUTO)
			cItem := soma1(cItem)
			nValor:= round(U_AGF_SHCUS(TRBC2->C2_PRODUTO, TRBC2->C2_LOCAL, cGetTES),6)
//			nVlrSug := U_AGF_SHCUS(TRBC2->C2_PRODUTO, TRBC2->C2_LOCAL, cGetTES)
//			Alert("PRODUTO:"+TRBC2->C2_PRODUTO+"| ARMAZEM:|"+TRBC2->C2_LOCAL+"| TES:|"+MV_PAR04+"|Valor A: "+cValToChar(nValor)+ " VALOR B " +cValToChar(nVlrSug))
//							
//			Alert('cItem->'+cItem+' cPeca-> '+cPeca+' DESCR->'+Posicione("SB1",1,xFilial("SB1")+cPeca,"B1_DESC"))
//			Alert('Qtde->'+cValToChar(TRB->QUANT)+' PrcVen->'+cValToChar(nValor)+' TOTAL-> '+cValToChar(TRB->QUANT*nValor))
			AAdd(aItemPV,{		{"C6_ITEM"      ,cItem,															,NIL},;
								{"C6_PRODUTO"	,TRBC2->C2_PRODUTO            									,NIL},;
								{"C6_DESCRI"    ,Posicione("SB1",1,xFilial("SB1")+TRBC2->C2_PRODUTO,"B1_DESC")	,NIL},;
								{"C6_QTDVEN"	,TRBC2->QUJE        											,NIL},;
								{"C6_LOCAL" 	,TRBC2->C2_LOCAL												,NIL},;
								{"C6_PRCVEN"	,nValor			   								   				,NIL},;
								{"C6_VALOR"		,Round(TRBC2->QUJE*nValor,2)     								,NIL},;	
								{"C6_TES"		,cGetTES														,NIL},;
								{"C6_CCUSTO"    ,cGetCC															,NIL},;								
								{"C6_TPPROD"    ,"1"															,NIL}})
								
//								{"C6_LNSAP"     ,''										,NIL}								
//					cDet := cDet+chr(13)+cItem+";"+cPeca+";"+Posicione("SB1",1,xFilial("SB1")+cPeca,"B1_DESC");
//					+";"+strzero(TRB->QUANT,6)+";"+strzero(nValor,6)+";"+strzero(TRB->QUANT*nValor,10)+";"+'543'+";"+'414'+";"+TRB->GM_LINPED
								
  TRBC2->(dbSkip())
enddo
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabPV,aItemPV,3)

		If lMsErroAuto
			Mostraerro()
			RollBackSX8()
//			cNum := GetSX8Num("SC5","C5_NUM")			
		Else
//			ConfirmSX8()  
			nCount    := 0
			lGravaPed := .T.
			aItemPV   := {}
			aCabPV    := {}
			cItem     := '00'
			Alert("Numero do Pedido de Vendas GM Gerado-> "+SC5->C5_NUM)
			A410Altera( 'SC5', SC5->( RECNO() ), 4 )
//			cNum := GetSXENum("SC5","C5_NUM")			
		EndIf

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Validar o Centro de Custos
static function VldCC(cCC)
if Substr(cCC,1,1) <> '3'
	if Substr(cCC,1,1) == ' '
		Alert("Informe um centro de custo válido!!")
	else
		Alert("Centro de Custo "+cCC+" não pertence a um centro de custo produtivo")
	endif
	oGetCC:SetFocus()
	Return.F.
endif

	if !u_ag_blqctt(cCC,"","") //Valida o centro de custo para nao utilizar C.Custo diferente do permitido a partir de ABR/2014
		oGetCC:SetFocus()
		Return .F.
	endif
return