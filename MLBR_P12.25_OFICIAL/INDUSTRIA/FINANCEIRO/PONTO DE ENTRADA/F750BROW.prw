#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"   
#INCLUDE "topconn.ch"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	F750BROW()
// Autor 		Alexandre Dalpiaz
// Data 		28/04/10
// Descricao  	Consulta nota fiscal de saida/entrada a partir do titulo a pagar
// Uso         	Midori Atlantica          
// Melhoria     Willer - Limpa flag EIC para baixa
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F750BROW()
////////////////////////

_aRot := {}
aAdd( _aRot,	{ 'Título'			,'U_FM750NF(1)'		, 0 , 2})
aAdd( _aRot,	{ 'Nota Fiscal'		,'U_FM750NF(2)'		, 0 , 2})

aAdd( aRotina,	{ 'Consultar'		,_aRot, 0 , 2})
aAdd( aRotina,	{ 'Limpa Flag EIC'	,'U_FIN090W', 0 , 8})
  

CursorWait()
MsgRun( "Verificando Liberação de Títulos, aguarde...",, { || XLIBSE2() } ) 
CursorArrow()


Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FM750NF(_xPar)  // CONSULTA NOTA FISCAL A PARTIR DO DO TITULO
///////////////////////////////////////////////////////////////////////////
Local _aAlias := GetArea()

If _xPar == 1
	Fc050Con()
Else
	
	If alltrim(SE2->E2_ORIGEM) == 'MATA460'
		
		DbSelectArea('SF2')
		SF2->(DbSetOrder(1))
		If SF2->(DbSeek(SE2->E2_FILORIG + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_NUM,.F.))
			_cFilAnt := cFilAnt
			cFilAnt  := SE2->E2_FILORIG
			MC090Visual()
			cFilAnt := _cFilAnt
		Else
			MsgBox('Nota fiscal de saída não encontrada','ATENÇÃO!!!','ALERT')
		EndIf
		
	ElseIf alltrim(SE2->E2_ORIGEM) $ 'MATA100/MATA103'
		
		DbSelectArea('SF1')
		SF1->(DbSetOrder(2))
		If SF1->(DbSeek(SE2->E2_FILORIG + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_NUM,.F.))
			_cFilAnt := cFilAnt
			cFilAnt  := SE2->E2_FILORIG
			A103NFiscal('SF1',,2)
			cFilAnt := _cFilAnt
		Else
			MsgBox('Nota fiscal de entrada não encontrada','ATENÇÃO!!!','ALERT')
		EndIf
		
		RestArea(_aAlias)
		
	Else
		
		MsgBox('Titulo não foi originado através de nota fiscal','ATENÇÃO!!!','ALERT')
		
	EndIf
	
EndIf

Return()


User Function FIN090W()

Local _aAlias 	:= GetArea()
Local lGrava 	:= .T.


If Alltrim(SE2->E2_ORIGEM) == 'SIGAEIC' .And. Empty(SE2->E2_BAIXA)
	
	If !MsgYesNo("Deseja realmente limpar o Flag SIGAEIC para efetuar a baixa? ")
		lGrava := .F.
	EndIf
	If lGrava
		RecLock("SE2",.F.)
		Replace E2_ORIGEM  With '  '
		MsUnlock()
		MsgBox("Executado com Sucesso","Limpar Flag","INFO")
	EndIf
	
Else 
	MsgBox('Titulo não foi originado no SIGAEIC ou ja foi baixado','Atencao','STOP')
	Return
EndIf
	RestArea(_aAlias)             
Return()
/**
 * XLIBSE2
 * AOliveira
 * Rotina tem como objetivo 
 * Realiza gravaçao do campo E2_DATALIB para 
 * titulos com tipo (FT, TX)
 */
Static Function XLIBSE2()  
Local cQry := ""    
Local lCont := .t.

Local aArea    := GetArea()
Local aAreaSE2 := SE2->(GetArea())
        
                
cQry := ""
cQry += " SELECT * FROM "+RetSQLName("SE2")+"  "+CRLF
cQry += " WHERE E2_EMISSAO >= '20190301' "+CRLF
cQry += " AND E2_DATALIB = '' "+CRLF
cQry += " AND E2_TIPO IN ('FT','TX','IRF','PIS','COF','CSL','INS')  "+CRLF  //-- FATURA E TX = IMPOSTOS
cQry += " AND D_E_L_E_T_ = '' "+CRLF

TCQUERY cQry ALIAS "TB1" NEW 
                   
DbSelectArea("TB1")
TB1->(DbGotop())
While !TB1->(Eof()) .And. lCont
	DbSelectArea("SE2")
	SE2->(DbSetOrder(1))//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
	SE2->(DbGotop())
	If SE2->( DbSeek( TB1->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) ))
		
		RecLock("SE2",.F.)
		SE2->E2_DATALIB := StoD(TB1->E2_EMISSAO)
		SE2->(MsUnlock())
		
	EndIf
	TB1->(DbSkip())
EndDo
TB1->(DbCloseArea())

RestArea(aArea)
RestArea(aAreaSE2)

Return()