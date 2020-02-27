#INCLUDE "Average.ch"

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: U_EICDI500()
//|Autor.....: Robson Luiz Sanchez Dias 
//|Data......: 12 de Agosto de 2009
//|Uso.......: SIGAEIC   
//|Versao....: Protheus - 10.1    
//|Descricao.: Contem todos pontos de entradas do EICDI500 e funcoes para tratamento da DI de Importacao
//|Observação: 
//------------------------------------------------------------------------------------//

*-----------------------------*
User function EICDI500
*-----------------------------*

If Paramixb == "MANUT_W9_INC"
  U_VctoInv()
Endif           
Return .t.

*-----------------------------*
User Function VctoInv()
*-----------------------------*         

//If ParamIxb == "TELA_INVOICES"
If Inclui .or. Altera
//   If nTipoW9Manut  == 1 /* Inclusao Invoice */    .or.  nTipoW9Manut == 2 /*Alteracao Invoice*/
      M->W9_DTVCTO:=M->W6_DT_EMB+M->W9_DIAS_PA
Endif


Return .t.

