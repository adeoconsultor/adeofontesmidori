//#INCLUDE "EICAP100.CH" 
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "AVERAGE.CH"
//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: EICAP100_RDM()
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Uso.......: SIGAEIC   
//|Versao....: Protheus - 10
//|Descricao.: Ponto de entrada para o cambio
//|Observação: 
//------------------------------------------------------------------------------------//
*----------------------------------------------*
User Function EICAP100()
*----------------------------------------------*
Local oDlg
Local oBar
Local axVariaCam := {}  


Do Case
	
	//+-----------------------------------------------------------------------------------//
	//|Parametro..: "MANUT_SWA"
	//|Descricao..: Zera variavel axVariaCam 
	//+-----------------------------------------------------------------------------------//
	Case ParamIxb == "MANUT_SWA"
		If nPos_aRotina == 2	
    		axVariaCam := {}
			//Aadd(aBotoes,{"IMPRESSAO",{|| U_FECHCAMB() }, "Imprime Fechamento Cambio" })
			DEFINE BUTTON oBtnImpFech RESOURCE "IMPRESSAO" OF oBar GROUP ACTION (U_FECHCAMB()) TOOLTIP "Imprime Fechamento Cambio"
			oBtnImpFech:cTitle := "Imprime Fechamento Cambio"
  			//oBar:nGroups+=6
			
		EndIf 

	//+-----------------------------------------------------------------------------------//
	//|Parametro..: "BTINCLUI"
	//|Descricao..: Inclui bota de impressão na visualização
	//+-----------------------------------------------------------------------------------//
	Case ParamIxb == "BTINCLUI"
	
		If nPos_aRotina == 2
			Aadd(aBotoes,{"IMPRESSAO",{|| U_FECHCAMB() }, "Imprime Fechamento Cambio" })
  		EndIf 

	//+-----------------------------------------------------------------------------------//
	//|Parametro..: "ANTES_GRAVA_SWB"
	//|Descricao..: Verifica quais cambios já foram liquidados ou estornados
	//+-----------------------------------------------------------------------------------//
	/*Case ParamIxb == "ANTES_GRAVA_SWB"

		If Empty(SWB->WB_CA_DT) .AND. !Empty(TRB->WB_CA_DT)
  			If M->WA_PO_DI == "D" .AND. TRB->WB_TIPOREG <> "P"
  				aAdd(axVariaCam,{"903",xFilial("SE2")+SWB->WB_PREFIXO+SWB->WB_NUMDUP+SWB->WB_PARCELA+SWB->WB_TIPOTIT+SWB->WB_FORN+SWB->WB_LOJA}) 
            ElseIf M->WA_PO_DI <> "D" .AND. TRB->WB_TIPOREG == "P"
  				aAdd(axVariaCam,{"903",xFilial("SE2")+SWB->WB_PREFIXO+SWB->WB_NUMDUP+SWB->WB_PARCELA+SWB->WB_TIPOTIT+SWB->WB_FORN+SWB->WB_LOJA}) 
			EndIf
		ElseIf !Empty(SWB->WB_CA_DT) .AND. Empty(TRB->WB_CA_DT)
			aAdd(axVariaCam,{"904",xFilial("SE2")+SWB->WB_PREFIXO+SWB->WB_NUMDUP+SWB->WB_PARCELA+SWB->WB_TIPOTIT+SWB->WB_FORN+SWB->WB_LOJA}) 
		EndIf  
	*/		
    
	/*
	//+-----------------------------------------------------------------------------------//
	//|Parametro..: "EXCLUINDO TUDO"
	//|Descricao..: Verifica quais cambios tem liquidação para estorno da variação
	//+-----------------------------------------------------------------------------------//	
	Case ParamIxb == "EXCLUINDO TUDO"	
		If !Empty(SWB->WB_CA_DT)
			axVariaCam := {"904",xFilial("SE2")+SWB->WB_PREFIXO+SWB->WB_NUMDUP+SWB->WB_PARCELA+SWB->WB_TIPOTIT+SWB->WB_FORN+SWB->WB_LOJA,Nil}
			U_UZValCam(axVariaCam)
		EndIf        
	*/  
	
	/*
	//+-----------------------------------------------------------------------------------//
	//|Parametro..: "APOS GRAVAR SWB"
	//|Descricao..: Depois da Gravação do SWB Verificar a variação Cambial
	//+-----------------------------------------------------------------------------------//

	Case ParamIxb == "APOS GRAVAR SWB"
		For hj := 1 To Len(axVariaCam)
			U_UZValCam(axVariaCam[hj])
		Next
	*/
EndCase

Return .T. 

//+------------------------------------------------------------------------------------//
//|Fim do programa EICAP100_RDM.PRW
//+------------------------------------------------------------------------------------//