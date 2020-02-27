#INCLUDE "EECPEM29.ch"
#INCLUDE "EECRDM.CH"
  
//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: MIDTIMBRE
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Uso.......: SIGAEIC   
//|Versao....: Protheus - 10
//|Descricao.: Função para impressão de documentos
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function MIDTIMBRE()
*-----------------------------------------*

Local lRet := .F.

Private cTituloRel := Space(60)

Begin Sequence
	
	If !MostraTela()
		Break
	EndIf
	If !E_AVGLTT("G")
		Break
	EndIf

	AVGLTT->(DBAPPEND())
	AVGLTT->AVG_CHAVE  := "TIM"+Alltrim(cSEQREL)
	AVGLTT->AVG_C01_60 := cTituloRel
	AVGLTT->WK_DETALHE := ""
	
	cSEQREL := GetSXENum("SY0","Y0_SEQREL")
	CONFIRMSX8()
	
	//executar rotina de manutencao de caixa de texto
	lRet := E_AVGLTT("M",WORKID->EEA_TITULO)
	
End Sequence

Return lRet

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: MostraTela
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Uso.......: SIGAEIC   
//|Versao....: Protheus - 10
//|Descricao.: Tela inicial para impressão do Documento
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MostraTela()
*-----------------------------------------*

Local lRet    := .F.
Local bOk     := {||lRet := .T., oDlg:End()}
Local bCancel := {||oDlg:End()}
Local y       := 20
Local oDlg    := Nil

Begin Sequence

	DEFINE MSDIALOG oDlg TITLE "Timbre Midori" FROM 0,0 TO 95,430 OF oDlg PIXEL

	@ 15, 05 TO 45,210 LABEL "Titulo do Documento" OF oDlg PIXEL
	@ 25, 10 MSGET cTituloRel PICTURE "@!" SIZE 195,08 PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)

End Sequence

Return lRet

//+-----------------------------------------------------------------------------------//
//| FIM DO ARQUIVO MIDTIMBRE.PRW                                             
//+-----------------------------------------------------------------------------------//
