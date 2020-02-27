#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.ch"

///////////////////////////////////////////////////////////////////////////////
//Ponto de entrada chamado após a inclusao da nota fiscal de entrada
//busca o custo médio dos produtos depois do lançamento
//Faz parte do projeto apresentado pelo Sr.Helio Matsuda em Dez-2011
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br, angfaria@hotmail.com - 09-01-2012
///////////////////////////////////////////////////////////////////////////////


User Function MT103FIM()  
            
local aBkpArea := GetArea()
local nOpcao    := PARAMIXB[1] // Opção escolhida pelo usuário no aRotina
local nConfirma := PARAMIXB[2] // Se o usuário confirmou a operação de gravação da NFE

/*
local cCodEv := "" //Codigo do Evento a ser rastreado posterior nas despesas
local lCodEv := .F.

dbSelectArea("SD1")
//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
dbSetOrder(1) //Documento + Serie + Forn/Cliente + Loja + Produto + Item NF
if dbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
	//Bloco para buscar no pedido se há codigo de evento cadastrado
	dbSelectArea("SC7")
	dbSetOrder(1)
	if dbSeek(xFilial("SC7")+SD2->D2_PEDIDO)
		while !SC7->(eof())
			if SC7->C7_X_CODEV <> space(6)
				lCodEv := .T.
				cCodEv := SC7->C7_X_CODEV
			endif
			SC7->(dbSkip())	
		enddo
	endif
	//Se houver código do Evento o sistema registra no arquivo SD1
	if lCodEv 
		dbSelectArea("SD1")
		dbSetOrder(1)
		dbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
		while !SD1->(eof()).and.SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
			RecLock("SD1",.F.)
			//SD1->D1_CUSAPOS := U_AGF_SEARCHCUS(SD1->D1_LOCAL, SD1->D1_COD)	
			SD1->D1_X_CODEV := cCodEv
			MsUnLock("SD1")
			SD1->(dbSkip())
		enddo
	endif
endif
	//Fim do bloco de atualizacao do código do evento

*/

Dbselectarea ("SF3")
Dbsetorder(4)

If dBseek( xfilial("SF3")+SF1->(F1_FORNECE+F1_LOJA+F1_DOC+F1_SERIE)  )
	if SF1->F1_MENNOTA <> space(200)
		if SF3->F3_OBSERV == space(40)
		   Reclock("SF3",.F.)  
		   SF3->F3_OBSERV := SF1->F1_MENNOTA
		   SF3->(Msunlock())
		endif
	endif
Endif

/*
* Autor			: DANIEL TORNISIELO
* Data			: 02/08/2016
* Descrição		: O ponto de entrada MT103FIM encontra-se no final da função A103NFISCAL. 
* Após o destravamento de todas as tabelas envolvidas na gravação do documento de entrada, depois de fechar a operação realizada neste, é utilizado para realizar alguma operação após a gravação da NFE.
* Observacoes	: n/a
*/
If (nOpcao = 3	.OR. nOpcao = 4) .And. nConfirma = 1 //-Inclusao ou Classificacao da NFe e Confirmou
	U_MONGRVSP(SF1->F1_CHVNFE,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_DTDIGIT)

EndIf
	
If nOpcao = 4 .And. nConfirma = 1 // Classificacao da NFe e Confirmou
	U_fManClas(SF1->F1_CHVNFE) // Irá manifestar automaticamente com o evento Confirmação da Operação caso o parametro ZZ_MANCLAS estiver verdadeiro
EndIf                                                                                                    
	
RestArea(aBkpArea)
	
return nil


