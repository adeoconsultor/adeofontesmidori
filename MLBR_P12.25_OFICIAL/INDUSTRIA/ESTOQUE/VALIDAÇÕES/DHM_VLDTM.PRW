#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Autor 		DIEGO HENRIQUE MAFISOLLI
// Data			09/03/2017
// Descricao  	faz valida��o dos armazens onde est�o sendo feitas as movimenta��es
// 				essa fun��o � gen�rica para qualquer campo de armaz�m. � s� fazer a chamada na
//				valida��o do usu�rio.
// Uso         	Midori Atlantica
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function VLDMOVTM(nCod,nTM, nLinha)  

Local _lRet 	:= .T.
Local _nGrupo 	:= Posicione("SB1",1,xFilial("SB1")+nCod,"B1_GRUPO")  
Local _nLinha	:= nLinha          
LocaL nMsg
             

/* Valida��o pendente de implanta��o
 * Aguardando autorizacao final do Depto Custos                                                                         
 */
/*If nTM == '501' .And. !rtrim(_nGrupo) $ '75'  

	nMsg := 'Baixa de materiais produtivos por TM 501 n�o permitido.'  
	If !empty(_nLinha)
   		nMsg += chr(13)+' Linha: ' + cValToChar(_nLinha) + ' - Produto: ' + cValToChar(nCod)
	Endif
	
	nMsg += chr(13)+'Qualquer d�vida entre em contato com Depto Custos'
	
	Alert(nMsg) 
	
	_lRet := .F.
Endif 
*/

If nTM <= '499' .And. !RetCodUsr() $ GetMV('MA_CODUSTM')

	nMsg := 'N�o permitido movimento de TM que gera saldo em estoque.'  
	nMsg += chr(13)+'Qualquer d�vida entre em contato com Depto. Custos'
	
	Alert(nMsg) 
	
	_lRet := .F.
Endif

Return(_lRet)

