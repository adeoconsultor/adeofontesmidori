#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Autor 		DIEGO HENRIQUE MAFISOLLI
// Data			09/03/2017
// Descricao  	faz validação dos armazens onde estão sendo feitas as movimentações
// 				essa função é genérica para qualquer campo de armazém. è só fazer a chamada na
//				validação do usuário.
// Uso         	Midori Atlantica
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function VLDMOVTM(nCod,nTM, nLinha)  

Local _lRet 	:= .T.
Local _nGrupo 	:= Posicione("SB1",1,xFilial("SB1")+nCod,"B1_GRUPO")  
Local _nLinha	:= nLinha          
LocaL nMsg
             

/* Validação pendente de implantação
 * Aguardando autorizacao final do Depto Custos                                                                         
 */
/*If nTM == '501' .And. !rtrim(_nGrupo) $ '75'  

	nMsg := 'Baixa de materiais produtivos por TM 501 não permitido.'  
	If !empty(_nLinha)
   		nMsg += chr(13)+' Linha: ' + cValToChar(_nLinha) + ' - Produto: ' + cValToChar(nCod)
	Endif
	
	nMsg += chr(13)+'Qualquer dúvida entre em contato com Depto Custos'
	
	Alert(nMsg) 
	
	_lRet := .F.
Endif 
*/

If nTM <= '499' .And. !RetCodUsr() $ GetMV('MA_CODUSTM')

	nMsg := 'Não permitido movimento de TM que gera saldo em estoque.'  
	nMsg += chr(13)+'Qualquer dúvida entre em contato com Depto. Custos'
	
	Alert(nMsg) 
	
	_lRet := .F.
Endif

Return(_lRet)

