#Include "RWMAKE.CH"
#Include "PROTHEUS.CH"

User Function TngCat()

Local cRet := ""
//If M->cTm == "501" //Original desenvolvido pela Tuning
If M->D3_TM == "501" //Alterado por Anesio 
	If SB1->B1_TIPO == "PA"
		cRet := "317664"
	ElseIf SB1->B1_TIPO == "PI"
		cRet := "217664"
	ElseIf SB1->B1_TIPO == "MP"
		cRet := "112521"
	EndIf
EndIf                

Return( cRet )