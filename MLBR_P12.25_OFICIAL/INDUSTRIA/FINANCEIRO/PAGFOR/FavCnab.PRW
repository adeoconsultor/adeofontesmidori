# Include 'Protheus.ch'


/*

Programa - FavCNAB
Autor    - Humberto Garcia
Data     - 09/04/2010                        

Finalidade e descricão:

	Este programa e utilizado nas posicões 018 à 049 do PAGFOR Bradesco e tem a finalidade de retonar o nome do fornecedor, verificando a existencia 
	dessa informação no campo E2_NOMFV ou A2_NOME

*/                                               


User function FavCNAB


Local _cNomFav := If(Empty(SE2->E2_X_NOMFV),Substr(Alltrim(SA2->A2_NOME),1,30),Substr(Alltrim(SE2->E2_X_NOMFV),1,30))

Return(_cNomFav)