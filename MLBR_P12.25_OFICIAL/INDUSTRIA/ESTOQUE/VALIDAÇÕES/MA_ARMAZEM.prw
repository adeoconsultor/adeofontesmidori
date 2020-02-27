#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	ma_armazem
// Autor 		WILLER TRINDADE
// Data			08/09/10
// Descricao  	faz valida��o dos armazens onde est�o sendo feitas as movimenta��es
// 				essa fun��o � gen�rica para qualquer campo de armaz�m. � s� fazer a chamada na
//				valida��o do usu�rio.
// Uso         	Midori Atlantica
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MA_ARMAZEM()
//////////////////////////


Local _lRet 	:= .T.
Local _cTexto 	:= 'Movimenta��o N�O Permitida No(s) Armazem(s) -> '+ GetMv('MA_ARMAZEM') + chr(13) + chr(13)
      //_cTexto += 'Deseja realmente fazer movimenta��o neste armazem?'+chr(13)
      //_cTexto += 'Esta opera��o gravar� um log para posterior auditoria.'


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

