#INCLUDE "rwmake.ch"

///////////////////////////////////////////////////////////////////////////////////////////
//Programa de cadastro de hist�rico do Financeiro
//Desenvolvido por Anesio G.Faria - anesio@outlook.com em 14/06/2013
///////////////////////////////////////////////////////////////////////////////////////////
//Os hist�ricos definidos nesse programa ser�o utilizados para impressao nas APs
User Function AGCADSZJ()


Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZJ"

dbSelectArea("SZJ")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Hist�ricos financeiros...",cVldExc,cVldAlt)

Return
