#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ATLFOLSQ  ºAutor  ³REGINALDO - MIDORI  º Data ³  06/29/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ GERA NUMERO SEQUENCIAL PARA NUMERO PAGTO                   º±±
±±º          ³ CNAB PAGFOR - FOLHA DE PAGAMENTO                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ATLFOLSQ()
                   
Local _nNumero := 1 //Variavel para gravar o numero

dbSelectArea("SX6")
//Pesquisa na tabela de parametros Configurador se o parametro esta como exclusivo
If SX6->(dbSeek(SRA->RA_FILIAL+"MV_ATLFOSQ"))
	_nNumero := Val(SX6->X6_CONTEUD)
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD :=Str(_nNumero+1) // Grava o numero utilizado
	MSUNLOCK()
//Pesquisa na tabela de parametros Configurador se o parametro esta como compartilhado
ElseIf SX6->(dbSeek("  "+"MV_ATLFOSQ"))
	_nNumero := Val(SX6->X6_CONTEUD)
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD :=Str(_nNumero+1) // Grava o numero utilizado
	MSUNLOCK()
EndIf

Return(StrZero(_nNumero,16))