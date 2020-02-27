#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	ma_armazem
// Autor 		WILLER TRINDADE
// Data			08/09/10
// Descricao  	faz validação dos armazens onde estão sendo feitas as movimentações
// 				essa função é genérica para qualquer campo de armazém. è só fazer a chamada na
//				validação do usuário.
// Uso         	Midori Atlantica
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MA_ARMAZEM()
//////////////////////////


Local _lRet 	:= .T.
Local _cTexto 	:= 'Movimentação NÃO Permitida No(s) Armazem(s) -> '+ GetMv('MA_ARMAZEM') + chr(13) + chr(13)
      //_cTexto += 'Deseja realmente fazer movimentação neste armazem?'+chr(13)
      //_cTexto += 'Esta operação gravará um log para posterior auditoria.'


If FunName() == "MATA103" .And. M->D1_LOCAL $ GetMv('MA_ARMAZEM') 
		Help(" ",1,"HELP","MA_ARMAZEM",_cTexto,1,0)
		 _lRet   := .F.		
ElseIf FunName() == "MATA140" .And. M->D1_LOCAL $ GetMv('MA_ARMAZEM') 
		Help(" ",1,"HELP","MA_ARMAZEM",_cTexto,1,0)
		 _lRet   := .F.		
ElseIf FunName() == "MATA240" .And. M->D3_LOCAL $ GetMv('MA_ARMAZEM') 
		Help(" ",1,"HELP","MA_ARMAZEM",_cTexto,1,0)
		 _lRet   := .F.		
ElseIf FunName() == "MATA241" .And. M->D3_LOCAL $ GetMv('MA_ARMAZEM') 
		Help(" ",1,"HELP","MA_ARMAZEM",_cTexto,1,0)
		 _lRet   := .F.	
ElseIf FunName() == "MATA242" .And. M->D3_LOCAL $ GetMv('MA_ARMAZEM') 
		Help(" ",1,"HELP","MA_ARMAZEM",_cTexto,1,0)
		 _lRet   := .F.					
ElseIf FunName() == "MATA260" .And. cLocDest $ GetMv('MA_ARMAZEM') 
		Help(" ",1,"HELP","MA_ARMAZEM",_cTexto,1,0)
		 _lRet   := .F.		
ElseIf FunName() == "MATA261" .And. M->D3_LOCAL $ GetMv('MA_ARMAZEM') 
		Help(" ",1,"HELP","MA_ARMAZEM",_cTexto,1,0)
		 _lRet   := .F.		
ElseIf FunName() == "MATA250" .And. M->D3_LOCAL $ GetMv('MA_ARMAZEM') 
		Help(" ",1,"HELP","MA_ARMAZEM",_cTexto,1,0)
		 _lRet   := .F.		
ElseIf FunName() == "MATA650" .And. M->C2_LOCAL $ GetMv('MA_ARMAZEM') 
		Help(" ",1,"HELP","MA_ARMAZEM",_cTexto,1,0)
		 _lRet   := .F.				 
ElseIf FunName() == "MATA270" .And. M->B7_LOCAL $ GetMv('MA_ARMAZEM') 
		Help(" ",1,"HELP","MA_ARMAZEM",_cTexto,1,0)
		 _lRet   := .F.				 
EndIf



Return(_lRet)

