#include 'Protheus.ch'

//////////////////////////////////////////////////////////////////////////////////////////
//Ponto de entrada para substituir o numero da OP pelo numero do plano 
//na unidade de PNP2
//Conforme chamado aberto pelo Sr.Marcos Falaschi - chamado 004732
//Desenvolvido por Anesio G.Faria - 18-08-2012
//////////////////////////////////////////////////////////////////////////////////////////

User Function MC030IDMV()

Local cNewIdent := ""  

if cFilAnt == '08' .and. (SD3->D3_TM == '500' .or. (SD3->D3_TM = '999' .and. SD3->D3_CF == 'RE1' .and. Substr(SD3->D3_OP,1,2) <> space(2)))
	cNewIdent :=  Posicione('SC2',1,xFilial('SC2')+Substr(SD3->D3_OP,1,6),'C2_OPMIDO') //SD3->D3_PARTIDA 
else
	cNewIdent := SD3->D3_OP
endif

Return cNewIdent 