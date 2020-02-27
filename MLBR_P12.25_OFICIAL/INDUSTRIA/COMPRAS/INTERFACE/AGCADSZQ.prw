#INCLUDE "rwmake.ch"

///////////////////////////////////////////////////////////////////////////////////////////
//Programa de cadastro de histórico do Financeiro
//Utilizado para distinguir as despesas ocorridas nas unidades.
//Desenvolvido por Anesio G.Faria - anesio@outlook.com em 06/03/2013
///////////////////////////////////////////////////////////////////////////////////////////
User Function CADSZQ()


Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZQ"

dbSelectArea("SZQ")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Projetos/Eventos...",cVldExc,cVldAlt)

Return
