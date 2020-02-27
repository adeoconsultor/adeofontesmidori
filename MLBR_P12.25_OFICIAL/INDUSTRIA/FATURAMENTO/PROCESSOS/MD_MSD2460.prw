#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"

/////////////////////////////////////////////////////////////////////////////////
//Função para verificar se usuario digitou quantidade de vaquetas no campo C6_QTDVQ
//caso o valor do campo seja > 0 essa informação será gravado no arquivo SD2 campo D2_QTDVQ

//Desenvolvido por Anesio G.Faria - Taggs Consultoria em 02-06-2011

user Function MSD2460()

//Rotina para gravar a numeração de couro no arquivo SC5 e SD2
if SC5->C5_TIPOCLI == 'X'	 //Verificar se o pedido é do tipo Exportação/Importação
	if SC5->C5_PEDEXP <> space(20) //Verificar se existe informado o numero do pedido de exportação/importação
			cQuery1 := " Select ZZB_PEDIDO, ZZB_COD_I, Sum(convert(int, ZZB_SIDES)) as QTDVQ, Sum(ZZB_SQMTOT) as M2TOTAL "
			cQuery1 += " from ZZB010 where D_E_L_E_T_ = ' '  "
			cQuery1 += " AND ZZB_PEDIDO = '"+SC5->C5_PEDEXP+"' AND ZZB_FILIAL = '"+xFilial("ZZB")+"' "
			cQuery1 += " AND ZZB_COD_I = '"+SC6->C6_PRODUTO+"' "
			cQuery1 += " group by ZZB_PEDIDO, ZZB_COD_I "
	
		IF SELECT( 'TRBEX' ) > 0
			DbSelectArea( 'TRBEX' )
			DbcloseArea()
		ENDIF
		dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQuery1  ), 'TRBEX' , .F. , .T. )
		dbSelectArea("TRBEX")                                       
		dbGotop()
//		Alert("PEDIDO-> "+TRBEX->ZZB_PEDIDO+" PRODUTO "+TRBEX->ZZB_COD_I+" QTDE "+cValToChar(TRBEX->QTDVQ)+" PRODUTO  C6-> "+SC6->C6_PRODUTO)
		if TRBEX->ZZB_COD_I == SC6->C6_PRODUTO
			RecLock("SC6",.F.)
			SC6->C6_QTDVQ := TRBEX->QTDVQ
			MsUnLock("SC6")
		endif
	endif //Fim do teste de verificação se existe numero de pedido de exportação/importação informado
endif //Fim do teste se o cliente é do tipo 'X' (Exportação/Importação)

	 if SC6->C6_QTDVQ > 0 
 		SD2->D2_QTDVQ := SC6->C6_QTDVQ
	 endif                 
	
	SD2->D2_PARTIDA := SC6->C6_PARTIDA
    SD2->D2_CCUSTO  := SC6->C6_CCUSTO 
	
 	
//Chama a funcão AGF_SEARCHCUS para gravacao do custo do produto antes da movimentacao.

//SD2->D2_CUSANT := U_AGF_SEARCHCUS(SC6->C6_LOCAL, SC6->C6_PRODUTO)
 	
return                                          

//Função desenvolvida para corrigir o peso bruto das notas fiscais de exportação
//Desenvolvido por Aneiso em 16/05/2013 - anesio@anesio.com.br 
//Correção do peso liquido NF exportacao - Diego Mafisolli em 14/11/2018
user function SF2460I()
local cPedido := ""
local nPBruto := 0   
local nPLiqui := 0
if SF2->F2_EST $ 'EX'
	cPedido := Posicione("SD2",3, xFilial('SD2')+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA), "D2_PEDIDO")
	nPBruto := Posicione("SC5", 1, xFilial('SC5')+cPedido, "C5_PBRUTO")
	nPLiqui := Posicione("SC5", 1, xFilial('SC5')+cPedido, "C5_PESOL")
	if nPBruto > 0
		RecLock('SF2',.F.)
		Replace F2_PBRUTO with nPBruto
		Replace F2_PLIQUI with nPLiqui
		MsUnLock('SF2')
	endif
endif

return                                                                     


////////////////////////////////////////////////////////////////////////////////////////////////
//Funçao desenvolvida para gravar a mensagem de Vaqueta ao final da geracao da nota fiscal 
//quando existir numero de vaquetas digitados...
user Function M460FIM()
/////////////////////////////////////////////////////////////////////
Local cPedido := SD2->D2_PEDIDO
Local cNota:= SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
Local cNfMsg:= SD2->(D2_DOC+' SERIE '+D2_SERIE)
Local dData := SD2->D2_EMISSAO
Local cMsg:= cMsg2 := ""
Local Grv1 := .T.
Local nCountM1:= nCountM2 := 0
Local CodConc := GetMv ("MV_PEDCONC") 
//Alert("NUMERO DA NOTA FISCAL " + cNota)
dbSelectArea("SD2")
dbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
dbGotop()
if dbSeek(xFilial("SD2")+cNota)
while !SD2->(eof()).and.SD2->D2_FILIAL==xFilial("SD2").and.SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == cNota
	if SD2->D2_QTDVQ > 0       
//		Alert("Gravando dados da nota "+cNota)
		cMsg:= cMsg+Substr(SD2->D2_COD,1,6)+'-'+cValToChar(SD2->D2_QTDVQ)+','
	endif
	SD2->(dbSkip())
enddo
endif

if Substr(SC5->C5_MENNOTA,1,1) <> ' '
	Grv1 := .F.
endif

if cMsg <> "" 
	dbSelectArea("SC5")
	dbSetOrder(1)
	if dbSeek(xFilial("SC5")+cPedido)                    
		if SC5->C5_TIPOCLI <> 'X' //Nao grava quantidade de vaquetas para pedidos de exportação/importação
			RecLock("SC5",.F.)
			if Grv1 
				SC5->C5_MENNOTA:= cMsg
				SC5->C5_MENNOT2:= " " 
				if len(cMsg) > 120
					SC5->C5_MENNOT2:= Substr(cMsg,121,Len(cMsg)-120)
				endif
			else
				SC5->C5_MENNOT2:= cMsg //Substr(SC5->C5_MENNOTA,1,nCountM1)+' '+Substr(cMsg,nCountM1,120-nCountM1)
			endif
			MsUnlock("SC5")
		endif
	endif
endif

//Rotina desenvolvida para gerar o pedido que será enviado para a concessionária, quando tratar de pedidos da GM
//utilizado o parametro MV_PEDCONC onde fica registrado os clientes que deverao gerar pedidos de remessa de mercadoria.
//Para ser gerado o pedido, o cliente que será gerado a remessa deve estar com o campo A1_CODEXTC preenchido
//e o campo C5_
cLojaGM:=space(6)
cCli   := space(6)
cLj	   := space(2)
cNome  := space(50)
cMun   := space(30)
cEnd   := space(50)
cUf    := space(2)
cTpCli := space(1)
cItem  := '00'
cCli   := Posicione('SC5',1, xFilial('SC5')+cPedido,'C5_CLIENTE')
aCabPV := {}
aItemPV:= {}
if cCli $ CodConc
	cLojaGm := Posicione('SC5',1, xFilial('SC5')+cPedido,'C5_LOJAGM')
	nPBruto := Posicione('SC5',1, xFilial('SC5')+cPedido,'C5_PBRUTO')
	nPLiq	:= Posicione('SC5',1, xFilial('SC5')+cPedido,'C5_PESOL')
	
	if Select('TMPCLI') > 0 
		dbSelectArea('TMPCLI')
		TMPCLI->(dbCloseArea())
	endif
		
	
	qCliente := " SELECT A1_COD, A1_LOJA FROM SA1010 WHERE D_E_L_E_T_ = ' ' AND A1_CODEXTC = '"+cLojaGm+"' "
	
	dbUseArea(.T., 'TOPCONN', tcGenQry(, , qCliente),'TMPCLI', .T.,.T.)
	
	dbSelectArea('TMPCLI')
	TMPCLI->(dbGotop())
	nCount:=0
	while !TMPCLI->(eof())
		nCount++
	     
		TMPCLI->(dbSkip())
	enddo
	TMPCLI->(dbGotop())
//	alert('Loja GM-> '+cLojaGm+' CLIENTE no SIGA -> '+TMPCLI->A1_COD+' nReg-> '+cValToChar(nCount))
	if nCount > 1 
		Alert('Existem 2 lojas cadastradas para o código GM '+cLojaGm+chr(13)+'O pedido não será gerado, por favor corrija!!')
		return
	endif

	
	dbSelectArea('SA1')
	dbSetOrder(1)
	if !dbSeek(xFilial('SA1')+TMPCLI->(A1_COD+A1_LOJA))
		return
	else
		cCli := SA1->A1_COD
		cLj  := SA1->A1_LOJA
		cNome:= SA1->A1_NOME
		cMun := SA1->A1_MUN
		cEnd := SA1->A1_END
		cUf  := SA1->A1_EST
		cTpCli:= SA1->A1_TIPO
		cMsg  := 'REMESSA POR CONTA E ORDEM CFE NOSSA NF.'+cNfMsg+' EMITIDO EM '+dToc(dData)+' GERADO PARA O CNPJ: 59.275.792/0089-91'
		
	endif
	if cLojaGM <> space(6)
		if ApmsgNoYes('Deseja gerar uma cópia do pedido '+cPedido+' para a concessionária '+chr(13)+;
			cCli+'-'+cLj+' '+cNome+chr(13)+'END: '+Alltrim(cEnd)+' MUN: '+Alltrim(cMun)+'/'+cUf )

				aCabPV := {	{"C5_TIPO"		,"N"						,NIL},;
							{"C5_CLIENTE"	,cCli						,NIL},;
							{"C5_LOJACLI"	,cLj						,NIL},;
							{"C5_CONDPAG"	,'001'						,NIL},;
							{"C5_TPFRETE"   ,'C'						,NIL},;
							{"C5_PBRUTO" 	,nPBruto					,NIL},;
							{"C5_PESOL"		,nPliq						,NIL},;
							{"C5_ESPECI1"	,'PACOTE'					,NIL},;
							{"C5_MENNOTA"   ,cMsg						,NIL},;
							{"C5_TIPOCLI"	,cTpCli						,NIL}} 
			
    		dbSelectArea('SC6')
    		dbSetOrder(1)
    		dbSeek(xFilial('SC6')+cPedido)
    			while !SC6->(eof()).and.SC6->C6_NUM == cPedido
    				cItem := Soma1(cItem)
					AAdd(aItemPV,{  {"C6_ITEM"      ,cItem,			 						,NIL},;
									{"C6_PRODUTO"	,SC6->C6_PRODUTO						,NIL},;
									{"C6_QTDVEN"	,SC6->C6_QTDVEN							,NIL},;
									{"C6_PRCVEN"	,SC6->C6_PRCVEN 						,NIL},;
									{"C6_VALOR"		,Round(SC6->(C6_QTDVEN*C6_PRCVEN),2)	,NIL},;						
									{"C6_TES"		,'867'									,NIL},;
									{"C6_CCUSTO" 	,'414'									,NIL},;
									{"C5_CCUSTO"	,SC6->C6_CCUSTO							,NIL}}) 
									
    				SC6->(dbSkip())
    		    enddo
   		    lMsErroAuto := .F.
				MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabPV,aItemPV,3)
				//Verifica se houve erro
			If lMsErroAuto
				AutoGrLog( "Data.........: " + DtoC(Date()) )
				AutoGrLog( "Hora.........: " + Time() )
				AutoGrLog( "Aonde........: Gerando Pedido de Venda da GM " )
				AutoGrLog( "Nome Fisico do Programa: MD_MSD2460.PRW")
				AutoGrLog( "Nome da Função: M460FIM() ")
				AutoGrLog( "Ordem de Producao...: " + SC2->C2_NUM + SC2->C2_SEQUEN + SC2->C2_ITEM )
				AutoGrLog( "Usuario: "+ RetCodUsr() +"-"+Substr(cUsuario,1,20))
				Mostraerro()
			else
				Alert('Pedido '+SC5->C5_NUM+' gerado com sucesso ')
			endif
    		
    	endif
	endif
endif


///////////////////////////////////alteração do peso liquido e peso bruto para nfs de exportação - Antonio - 13/11/18
/*
	dbSelectArea("SC5")
	dbSetOrder(1) //C5_FILIAL+C5_NUM
	If dbSeek(xFilial("SC5")+EE7->EE7_PEDFAT  )

	cQuery := " SELECT EE7.EE7_PEDFAT "
	cQuery += "  FROM "+RetSqlName("EE7")+" EE7 "
	cQuery += " WHERE "
	cQuery += " 	EE7.EE7_FILIAL =  '" + xFilial("EE7") + "' AND "
	cQuery += "		EE7.EE7_PEDFAT = '" + cPedido + "'         AND " 
	cQuery += " 	EE7.D_E_L_E_T_ = ''                        AND " 
	cQuery += " ORDER BY EE7.EE7_PEDFAT "
	
	If Select('TMPEE7') > 0
		dbSelectArea('TMPEE7')
		TMPEET->(dbCloseArea())                            
	EndIf
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), 'TMPEE7', .T.,.T.)
	
	If TMPEE7->(!Eof()) 

		nPBruto := Posicione('SC5',1, xFilial('SC5')+cPedido,'C5_PBRUTO')
		nPLiq	:= Posicione('SC5',1, xFilial('SC5')+cPedido,'C5_PESOL')
		SF2->(dbSetOrder(1))
		If SF2->(dbSeek(xFilial()+cNota ))
			RecLock("SF2",.F.)
			SF2->F2_PLIQUI := nPLiq
			SF2->F2_PBRUTO := nPBruto
	        MsUnLock()
		EndIf	
	EndIf	

 */
///////////////////////////////////alteração do peso liquido e peso bruto para nfs de exportação



return


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Funcao para emitir um aviso ao usuario que ao digitar quantidade de vaquetas no SC6 nao poderá utilizar o campo C5_MENNOT2
user function AvisoVQ()
Local nVQ := 0
Local cItem := ""
nVQ := M->C6_QTDVQ    
cItem := SC6->C6_ITEM

if cItem == '01' .and. M->C6_QTDVQ > 0
	Alert('Ao digitar quantidade de vaquetas, o segundo campo de "MENS P/NOTA"'+chr(13)+chr(13)+'Ficará reservado para informações de vaquetas';
	+chr(13)+chr(13)+'Favor não utiliza-lo, pois será substituido!!!')                     
endif
//Informação não é mais utilizada pelo setor fiscal 26/07/2018 - Jairson Ramalho
//Solicitado pelo Sr. Erikson Fernandes
/*if M->C6_QTDVQ > 0
	M->C5_MENNOT2 := "CAMPO RESERVADO PARA INFORMACOES DE VAQUETA, FAVOR NAO UTILIZA-LO!!!"
endif*/
return nVQ
