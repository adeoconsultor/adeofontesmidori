#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	F740BROW()
// Autor 		Alexandre Dalpiaz
// Data 		28/04/10
// Descricao  	Consulta nota fiscal de saida/entrada a partir do titulo a receber
// Uso         	Midori Atlantica
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F740BROW()
////////////////////////

_aRot := {}
aAdd( _aRot,	{ 'Título'		,'U_FM740(1)'		, 0 , 2})
aAdd( _aRot,	{ 'Nota Fiscal'	,'U_FM740(2)'	, 0 , 2})

aAdd( aRotina,	{ 'Consultar'	,_aRot, 0 , 2})
Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FM740(_xPar)  // CONSULTA NOTA FISCAL A PARTIR DO DO TITULO
/////////////////////////////////////////////////////////////////////////
Local _aAlias := GetArea()

lFi040Cmpo := .t.
cFilName := SM0->M0_FILIAL
cFieldPE := ''

If _xPar == 1
	
	Fc040Con()
	
Else
	If alltrim(SE1->E1_ORIGEM) == 'MATA460'
		
		DbSelectArea('SF2')
		SF2->(DbSetOrder(1))
		If SF2->(DbSeek(SE1->E1_FILORIG + SE1->E1_NUM + SE1->E1_SERIE + SE1->E1_CLIENTE + SE1->E1_LOJA,.F.))
			_cFilAnt := cFilAnt
			cFilAnt  := SE1->E1_FILORIG
			MC090Visual()
			cFilAnt := _cFilAnt
		Else
			MsgBox('Nota fiscal de saída não encontrada','ATENÇÃO!!!','ALERT')
		EndIf
		
	ElseIf alltrim(SE1->E1_ORIGEM) $ 'MATA100/MATA103'
		
		DbSelectArea('SF1')
		SF1->(DbSetOrder(1))
		If SF1->(DbSeek(SE1->E1_FILORIG + SE1->E1_NUM + SE1->E1_SERIE + SE1->E1_CLIENTE + SE1->E1_LOJA,.F.))
			_cFilAnt := cFilAnt
			cFilAnt  := SE1->E1_FILORIG
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

