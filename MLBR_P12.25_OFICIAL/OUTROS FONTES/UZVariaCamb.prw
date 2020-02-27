#INCLUDE "RWMAKE.CH" 

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: UZValCam
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Uso.......: SIGAEIC
//|Versao....: Protheus - 10
//|Descricao.: Valida o Lan�amento Padr�o e chama fun��o de contabiliza��o de 
//|            varia��o cambial
//|Observa��o:
//+-----------------------------------------------------------------------------------//
*----------------------------------------------*
User Function UZValCam(axLanc)
*----------------------------------------------*

If VerPadrao(axLanc[1])
	Processa({|| UZVariaCamb(axLanc) },"Contabilizando")
Else
	MsgInfo("Lancamento padronizado "+Alltrim(axLanc[1])+" nao existe. Favor verificar os Lan�amentos cadastrados","Lan�amento Padr�o")
EndIf

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: UZVariaCamb
//|Descricao.: Chama Lan�amento padr�o para a Varia��o Cambial
//|Observa��o: 
//------------------------------------------------------------------------------------//
*----------------------------------------------*
Static Function UZVariaCamb(axPad)
*----------------------------------------------*

Local lCab   := .F.
Local nVaria := 0
Public VALOR := 0

SE2->(dbSetOrder(1))
If SE2->(dbSeek(axPad[2]))
	
	dbSelectArea("SE5")
	dbSelectArea("SWB")
	dbSelectArea("SE2")
	dbSelectArea("CT5")

	cLot := "008850"
	lDig := .T.
	lAgl := iif(mv_par04 == 1,.T.,.F.)
	nTot := 0
	nHdl := 0
	cArq := ""
		
	nHdl := HeadProva(cLot,"UZVARIAC",Substr(cUsuario,7,6),@cArq)
	
	VALOR := SE5->E5_VLCORRE
	
	VALOR += DetProva(nHdl,axPad[1],"UZVARIAC",cLot)
	
	If VALOR <> 0
		RodaProva(nHdl,nTot)
		cA100Incl(cArq,nHdl,3,cLot,lDig,lAgl)
	EndIf
	
EndIf

Return                               

//+------------------------------------------------------------------------------------//
//|Fim do programa UZVariaCamb.PRW
//+------------------------------------------------------------------------------------//