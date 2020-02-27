#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Gp010ValPEºAutor  ³ ALEXANDRE SOUZA      º Data ³ 11/05/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada do Cadastro de Functionarios para Validar a CC do funcionário  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Gp010ValPE()

Local nAtu
lRet := .T.     		
nAtu := 0
nTot := 0


For nAtu := nAtu + 1 To Len(alltrim(M->RA_CTDEPSA))  // VALIDACAO PARA CORRETO FUNCIONAMENTO DO CNAB

	If Substr(alltrim(M->RA_CTDEPSA),nAtu,1) == "-"
	   Aviso("ATENCAO","Nao deve ser informado IFEM no codigo da Conta Corrente.",{"Voltar"})
       lRet := .F.
	Endif

Next

	 If (Len(alltrim(M->RA_CTDEPSA)) < 12) .and. (M->RA_CTDEPSA <> " ")  // VALIDACAO PARA CORRETO FUNCIONAMENTO DO CNAB
    	   Aviso("ATENCAO","Codigo de Conta Corrente para Deposito de Salario Invalido, o campo deve possuir 12 caracteres, se necessario complete o campo com ZEROS a esquerda e o DIGITO na ultima posicao.",{"Voltar"})
	       lRet := .F.
	 EndIf


	 If (Len(alltrim(substr(M->RA_BCDEPSA,4,5))) < 5) .and. (M->RA_BCDEPSA <> " ")  // VALIDACAO PARA CORRETO FUNCIONAMENTO DO CNAB
	    Aviso("ATENCAO","Codigo da Agencia para Deposito de Salario Invalido, o campo deve possuir 5 caracteres, se necessario complete o campo com ZEROS a esquerda.",{"Voltar"})
	    lRet := .F.
	 EndIf


	 If (M->RA_BCDEPSA <> " ") .and. (M->RA_M_DIGAG == " ")   // VALIDACAO PARA CORRETO FUNCIONAMENTO DO CNAB
	    Aviso("ATENCAO","Nao foi informado o digito da Agencia no campo correto.",{"Voltar"})
	    lRet := .F.
	 EndIf

 
Return( lRet )
