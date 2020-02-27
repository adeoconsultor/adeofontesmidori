#Include "Protheus.ch"
#Include "RwMake.ch"
/*---------------------------------------------------------
Funcao: GRVSZW()  |Autor: AOliveira    |Data: 22/11/2017
-----------------------------------------------------------
Descr.: Rotina tem como Objetivo Realizar manutencao de
dados na tabela SZW
-----------------------------------------------------------
Uso:    MIDIRI
-----------------------------------------------------------
PARAM:
aDados ->
			01 - ZW_PREFIXO
			02 - ZW_NUM
			03 - ZW_PARCELA
			04 - ZW_TIPO
			05 - ZW_FORNECE
			06 - ZW_LOJA
			07 - ZW_NOMFOR
			08 - ZW_RAZAO
			09 - ZW_EMISSAO
			10 - ZW_VALOR
			11 - ZW_HIST
			12 - ZW_OK
			13 - ZW_ORIG
			14 - ZW_DEPTO
			15 - ZW_BCOFV
			16 - ZW_AGEFV
			17 - ZW_CTAFV
			18 - ZW_TPCTA
			19 - ZW_FPAGT
			20 - ZW_NOMFV
			21 - ZW_CPFFV
			22 - ZW_TXBANC
			23 - ZW_REFER
			24 - ZW_CODRE
			25 - ZW_DDAOK
			26 - ZW_FORIG
			27 - ZW_BINSS
			28 - ZW_HISTAPV         
_cNumAP -> Numero da AP
cCodUsr -> Cod Usuario que incluiu a AP			
-----------------------------------------------------------
ALTERAÇÕES:  
			18-03-2019
			Inclusão de novo parametro _cNumAP
			para evitar que o numero da AP seja diferente
			do TITULO.                 
---------------------------------------------------------*/
User Function GRVSZW(aDados,_cNumAP,cCodUsr,cCodApr)

Local lRet := .T.
                       
//Para caso as variaveis de parametros sejam NULL
Default aDados  := {}     
Default _cNumAP := ""  
Default cCodUsr := ""
Default cCodApr := ""

// Alterado por Diego 01/04/19
// Motivo: Problema de numeracao de AP diferente SE2
If Empty(_cNumAP)
	_cNumAP := aDados[1][7] //NumAP
EndIf

RecLock("SE2", .F.
SE2->E2_X_NUMAP := _cNumAP
SE2->(MSUnlock())

If (Len(aDados) > 0)	
	
	DbSelectArea("SZW")
	SZW->(DbGotop())
	SZW->(DbSetOrder(1)) //ZW_FILIAL+ZW_NUMAP
	If SZW->(DbSeek( xFilial("SZW")+_cNumAP ))
		DbSelectArea("SZW")
		RecLock("SZW", .F.)
	Else
		DbSelectArea("SZW")
		RecLock("SZW", .T.)
	EndIf
	
	SZW->ZW_FILIAL    := xFilial("SZW")
	SZW->ZW_NUMAP     := _cNumAP               //SF1->F1_X_NUMAP	   //GETSXENUM('SZW','ZW_NUMAP')
	SZW->ZW_PREFIXO   := aDados[01][01]
	SZW->ZW_NUM       := aDados[01][02]
	SZW->ZW_PARCELA   := aDados[01][03]
	SZW->ZW_TIPO      := SE2->E2_TIPO          //aDados[01][04]
	SZW->ZW_FORNECE   := aDados[01][05]
	SZW->ZW_LOJA      := aDados[01][06]
	SZW->ZW_NOMFOR    := SE2->E2_NOMFOR        //aDados[01][07]
	SZW->ZW_RAZAO     := SA2->A2_NOME          //aDados[01][08]
	SZW->ZW_EMISSAO   := SE2->E2_EMISSAO       //aDados[01][09]
	SZW->ZW_VALOR     := SE2->E2_VALOR         //aDados[01][10]
	SZW->ZW_HIST      := aDados[01][16]        //aDados[01][11]
	SZW->ZW_ORIG      := aDados[01][13]
	SZW->ZW_DEPTO     := ""			           //aDados[01][13]
	//
	If FunName() == "MATA103"
		SZW->ZW_BCOFV     := aDados[01][08] 	  //aDados[01][14]
		SZW->ZW_AGEFV     := aDados[01][09]       //aDados[01][15]
		SZW->ZW_CTAFV     := aDados[01][10]       //aDados[01][16]
		SZW->ZW_TPCTA     := aDados[01][14]       //aDados[01][17]
		SZW->ZW_FPAGT     := aDados[01][15] 	  //aDados[01][18]
		SZW->ZW_NOMFV     := aDados[01][11]       //aDados[01][19]
		SZW->ZW_CPFFV     := aDados[01][12]       //aDados[01][20]
	Endif
	//
	SZW->ZW_FORIG     := SE2->E2_MSFIL         //aDados[01][24]
	SZW->ZW_STATUS    := "A"  
	//SZW->ZW_USRAPS    :=                
    
	//AOliveira 17-10-2019
	//GRV usuario que incluiu a AP
	If !(Empty(cCodUsr))
		SZW->ZW_CODUS  := cCodUsr	
		SZW->ZW_USUAR  := Alltrim(USRFULLNAME( cCodUsr ))
	EndIf                                   
	//                                      

	//AOliveira 17-10-2019
	//GRV usuario APR da AP
	If !(Empty(cCodApr))     
		SZW->ZW_USRAP   := cCodApr	
		SZW->ZW_USRAPN  := Alltrim(USRFULLNAME( cCodApr ))
	EndIf                                   
	//                                      	
	
	SZW->(MSUnlock())
	
	//SZW->ZW_TXBANC    := aDados[01][21]
	//SZW->ZW_REFER     := aDados[01][22]
	//SZW->ZW_CODRE     := aDados[01][23]
	
//	ConfirmSX8() // Retirado porque nao usa getsxenum
	
EndIf

Return(lRet)
