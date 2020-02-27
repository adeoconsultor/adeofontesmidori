# Include 'Protheus.ch'


/*

Programa - CGCCNAB
Autor    - Humberto Garcia
Data     - 09/04/2010                        

Finalidade e descricão:

	Este programa e utilizado nas posicões 437 à 450 do PAGFOR Bradesco e tem a finalidade de retonar o CNPJ/CPF do fornecedor, verificando a existencia 
	dessa informação no campo E2_X_CPFFV ou A2_CGC

*/                                               


User function CGCCNAB


Local _cCNPCPF := If(Empty(SE2->E2_X_CPFFV),SA2->A2_CGC,SE2->E2_X_CPFFV)

Return(_cCNPCPF)