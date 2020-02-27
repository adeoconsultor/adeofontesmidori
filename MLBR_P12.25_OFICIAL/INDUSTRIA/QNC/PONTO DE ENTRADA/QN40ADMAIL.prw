#include 'protheus.ch'

//Ponto de entrada desenvolvido para adicionar e-mails ao processo de Controle de Não Conformidade
//Solicitado por Amadeu Soliani
//Desenvolvido por Vinicius Schwartz - TI em 01/07/2013

User Function QN40ADMAIL()

Local cEmail

cEmail := GetMv ('MA_QNCEMAI')
cEmail += GetMv ('MA_QNCEMA2')

Return (cEmail)

