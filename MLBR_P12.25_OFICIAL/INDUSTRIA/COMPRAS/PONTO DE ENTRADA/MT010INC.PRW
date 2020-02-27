#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.ch"
/*
----------------------------------------------------------------------------------------
Funcao: MT010INC														Data: 02.09.2010
Autor : Sandro Albuquerque //WILLER TRINDADE VALIDAÇÃO CONTAS ATUALIZADO
----------------------------------------------------------------------------------------
Objetivo: PONTO DE ENTRADA PARA GRAVAR O USUARIO QUE EFETUOU A INCLUSAO DO PRODUTO.
LOCALIZAÇÃO : Function A010Inclui - Função de Inclusão do Produto, após sua inclusão.
EM QUE PONTO: Após incluir o Produto, este Ponto de Entrada nem confirma nem cancela a 
operação, deve ser utilizado para gravar arquivos/campos do usuário,
complementando a inclusão.
--------------------------------------------------------------------------------------*/
User Function MT010INC

If INCLUI
	Reclock("SB1",.F.)
	Replace	B1_XINCLUI 	With RETCODUSR()+'-'+ALLTRIM(SUBSTR(CUSUARIO,7,15))+' - EM '+DTOC(DDATABASE)
	Replace B1_XROTINA	With FUNNAME()
	MSUnlock("SB1")
Endif
	DbSelectArea('SYD')      //implementado verificação ncm conforme hdi 005191
			DbSetOrder(1)
			If DbSeek (xFilial('SYD')+ SB1->B1_POSIPI)
				If SYD->YD_RETOPER == '1'
		   			SB1->B1_PIS   	:= '1'
					SB1->B1_COFINS 	:= '1'
					SB1->B1_RETOPER	:= '1'
				EndIf
   			EndIf
	dbCloseArea()
u_AtuCTB(SB1->B1_GRUPO, SB1->B1_COD, SB1->B1_TIPO)
Return()

User Function AtuCTB(cGrupo, cProd, cTipo)
Local aAreaAnt := GetArea()
Local _cGrupo := cGrupo
Local _cProd  := cProd
Local _cTipo  := cTipo

dBSelectArea("ZZW")
dbSetOrder(2) //Grupo + Tipo
ProcRegua(0)


IF dBSeek(xFilial("ZZW") + _cGrupo + _cTipo )
	dBSelectArea("SB1")
	dBSetOrder(1) //B1_Filial+B1_TIPO+B1_GRUPO

	IncProc("Gravando Ctas Contabeis no SB1 Produto "+SB1->B1_COD+ " Tipo "+SB1->B1_TIPO)
	
	RecLock ("SB1",.F.)  // INCLUO O DADO NA TABELA CADASTRO DE PRODUTO
	SB1->B1_CONTA   := ZZW ->ZZW_CONTA
	SB1->B1_ICMREC 	:= ZZW ->ZZW_ICMREC
	SB1->B1_ICMPAG 	:= ZZW ->ZZW_ICMPAG
	SB1->B1_ICMDEV 	:= ZZW ->ZZW_ICMDEV
	SB1->B1_ICMVD 	:= ZZW ->ZZW_ICMVD
	SB1->B1_ICMST 	:= ZZW ->ZZW_ICMST
	SB1->B1_IPIREC 	:= ZZW ->ZZW_IPIREC
	SB1->B1_IPIPAG	:= ZZW ->ZZW_IPIPAG
	SB1->B1_IPIDEV	:= ZZW ->ZZW_IPIDEV
	SB1->B1_IPIVD	:= ZZW ->ZZW_IPIVD
	SB1->B1_PISREC 	:= ZZW ->ZZW_PISREC
	SB1->B1_PISPAG	:= ZZW ->ZZW_PISPAG
	SB1->B1_PISDEV	:= ZZW ->ZZW_PISDEV
	SB1->B1_PISVD   := ZZW ->ZZW_PISVD
	SB1->B1_COFREC 	:= ZZW ->ZZW_COFREC
	SB1->B1_COFPAG	:= ZZW ->ZZW_COFPAG
	SB1->B1_COFDEV	:= ZZW ->ZZW_COFDEV
	SB1->B1_COFVD	:= ZZW ->ZZW_COFVD
	SB1->B1_PODER3 	:= ZZW ->ZZW_PODER3
	SB1->B1_PODEM3	:= ZZW ->ZZW_PODEM3
	SB1->B1_CPV   	:= ZZW ->ZZW_CPV
	SB1->B1_RECEITA := ZZW ->ZZW_RECEITA
	SB1->B1_DEVVD	:= ZZW ->ZZW_DEVVD
	SB1->B1_DEVCP	:= ZZW ->ZZW_DEVCP
	SB1->B1_FUNRUR	:= ZZW ->ZZW_FUNRUR
	SB1->B1_SAT		:= ZZW ->ZZW_SAT
	SB1->B1_SENAR	:= ZZW ->ZZW_SENAR
	SB1->B1_MONSTO	:= ZZW ->ZZW_MONSTO
	SB1->B1_ELABOR	:= ZZW ->ZZW_ELABOR
	SB1->B1_TRANS 	:= ZZW ->ZZW_TRANS
	SB1->B1_RECEXT 	:= ZZW ->ZZW_RECEXT
	SB1->B1_CPVEXT 	:= ZZW ->ZZW_CPVEXT
	SB1->B1_CONDIR 	:= ZZW ->ZZW_CONDIR
	SB1->B1_CONIND 	:= ZZW ->ZZW_CONIND
	SB1->B1_GERAIS 	:= ZZW ->ZZW_GERAIS
	SB1->B1_ESTDIR 	:= ZZW ->ZZW_ESTDIR
	SB1->B1_ESTIND 	:= ZZW ->ZZW_ESTIND
	SB1->B1_CONSUM 	:= ZZW ->ZZW_CONSUM
	SB1->B1_X_ESTMP	:= ZZW ->ZZW_ESTMP
	SB1->B1_X_INVEN := ZZW ->ZZW_X_INVE
	
	MsUnlock()
Else
	Aviso( "Atencao!", "Registro nao consta no Cadastro de Ctas Contabeis x Produtos - Grupo "+_cGrupo+ "e Tipo "+_cTipo , { "OK" } )
	RestArea(aAreaAnt)
	dbCloseArea()
	Return()
	
Endif


RestArea(aAreaAnt)
dbCloseArea()

Return()
