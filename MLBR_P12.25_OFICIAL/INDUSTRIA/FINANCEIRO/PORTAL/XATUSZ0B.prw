#include "totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "RwMake.ch"

User Function XATUSZ0B(_cRECNO,_cCHVSZ0,_aDados)

Local _cEmp   := "01"
Local _cFil   := "01"
Local aTables := {"SZ0"}

Local cFunName   := Alltrim(ProcName())
Local cArqLckA := "\logLCKXATUSZ0A\"
Local cArqLckB := "\logLCKXATUSZ0B\"
Local cArqLock   := " "

Local _cATIVO := ""

Default _cRECNO  := ''
Default _cCHVSZ0 := ''
Default _aDados  := {}

MakeDir(cArqLckA)
MakeDir(cArqLckB)
cArqLock := cArqLckB+Alltrim(cFunName)+"_" + _cRECNO+".lck"

//Efetua o Lock de gravacao da Rotina - Monousuario
/*
FErase(cArqLock)
nHdlLock := MsFCreate(cArqLock)
IF nHdlLock < 0
	Conout("")
	Conout("**  Rotina "+ cFunName +" em uso...")
	Conout("")
	Return(.T.)
EndIF
*/
If !(Empty(_cCHVSZ0) .And. Len(_aDados) == 29) //
	
	//Preparando Ambiente
	//RpcSetType(3)
	lRetEnv := RpcSetEnv( _cEmp, _cFil, ,, 'COM', , aTables,  ,.f. , , )
	
	If lRetEnv
		
		CONOUT("INICIANDO ROTINA ("+cFunName+")")
		
		DbSelectArea("SZ0")
		SZ0->(DbSetOrder(1)) //Z0_FILIAL+Z0_PREFIXO+Z0_NUM+Z0_PARCELA+Z0_TIPO+Z0_FORNECE+Z0_LOJA
		SZ0->(DbGoTop())
		If SZ0->(DbSeek( _cCHVSZ0 ))
			RecLock("SZ0",.f.)
			Do Case
				Case SZ0->Z0_FILIAL  <> _aDados[1] //TBX->E2_FILIAL
					_cATIVO := ""
				Case SZ0->Z0_PREFIXO <> _aDados[2] //TBX->E2_PREFIXO
					_cATIVO := ""
				Case SZ0->Z0_NUM     <> _aDados[3] //TBX->E2_NUM
					_cATIVO := ""
				Case SZ0->Z0_PARCELA <> _aDados[4] //TBX->E2_PARCELA
					_cATIVO := ""
				Case SZ0->Z0_TIPO    <> _aDados[5] //TBX->E2_TIPO
					_cATIVO := ""
				Case SZ0->Z0_FORNECE <> _aDados[6] //Alltrim(TBX->E2_FORNECE)
					_cATIVO := ""
				Case SZ0->Z0_LOJA    <> _aDados[7] //TBX->E2_LOJA
					_cATIVO := ""
				Case SZ0->Z0_NOMFOR  <> _aDados[8] //TBX->E2_NOMFOR
					_cATIVO := ""
				Case SZ0->Z0_EMISSAO <> _aDados[9] //Stod(TBX->E2_EMISSAO)
					_cATIVO := ""
				Case SZ0->Z0_VENCTO  <> _aDados[10] //Stod(TBX->E2_VENCTO)
					_cATIVO := ""
				Case SZ0->Z0_VENCREA <> _aDados[11] //Stod(TBX->E2_VENCREA)
					_cATIVO := ""
				Case SZ0->Z0_VALOR   <> _aDados[12] //TBX->E2_VALOR
					_cATIVO := ""
				Case SZ0->Z0_BAIXA   <> _aDados[13] //Stod(TBX->E2_BAIXA)
					_cATIVO := ""
				Case SZ0->Z0_SALDO   <> _aDados[14] //TBX->E2_SALDO
					_cATIVO := ""
				Case SZ0->Z0_MULTA   <> _aDados[15] //TBX->E2_MULTA
					_cATIVO := ""
				Case SZ0->Z0_JUROS   <> _aDados[16] //TBX->E2_JUROS
					_cATIVO := ""
				Case SZ0->Z0_CORREC  <> _aDados[17] //TBX->E2_CORREC
					_cATIVO := ""
				Case SZ0->Z0_VALLIQ  <> _aDados[18] //TBX->E2_VALLIQ
					_cATIVO := ""
				Case SZ0->Z0_FATPREF <> _aDados[19] //TBX->E2_FATPREF
					_cATIVO := ""
				Case SZ0->Z0_FATURA  <> _aDados[20] //TBX->E2_FATURA
					_cATIVO := ""
				Case SZ0->Z0_DTFATUR <> _aDados[21] //Stod(TBX->E2_DTFATUR)
					_cATIVO := ""
				Case SZ0->Z0_ACRESC  <> _aDados[22] //TBX->E2_ACRESC
					_cATIVO := ""
				Case SZ0->Z0_ORIGEM  <> _aDados[23] //TBX->E2_ORIGEM
					_cATIVO := ""
				Case SZ0->Z0_X_NUMAP <> _aDados[24] //TBX->E2_X_NUMAP
					_cATIVO := ""
				Case SZ0->Z0_TITPAI  <> _aDados[25] //TBX->E2_TITPAI
					_cATIVO := ""
				Case SZ0->Z0_MSFIL   <> _aDados[26] //TBX->E2_MSFIL
					_cATIVO := ""
				Case SZ0->Z0_FORMPAG <> _aDados[27] //TBX->E2_FORMPAG
					_cATIVO := ""
				Case SZ0->Z0_RECSE2  <> _aDados[28] //Alltrim(Str( TBX->R_E_C_N_O_ ))
					_cATIVO := ""
				Case SZ0->Z0_XDELET  <> _aDados[29] //TBX->XSE2DEL
					_cATIVO := ""
				OtherWise
					_cATIVO := "S"
			EndCase
			
		Else
			RecLock("SZ0",.T.)
			_cATIVO := ""
		EndIf
		
		SZ0->Z0_FILIAL  := _aDados[1] //TBX->E2_FILIAL
		SZ0->Z0_PREFIXO := _aDados[2] //TBX->E2_PREFIXO
		SZ0->Z0_NUM     := _aDados[3] //TBX->E2_NUM
		SZ0->Z0_PARCELA := _aDados[4] //TBX->E2_PARCELA
		SZ0->Z0_TIPO    := _aDados[5] //TBX->E2_TIPO
		SZ0->Z0_FORNECE := _aDados[6] //Alltrim(TBX->E2_FORNECE)
		SZ0->Z0_LOJA    := _aDados[7] //TBX->E2_LOJA
		SZ0->Z0_NOMFOR  := _aDados[8] //TBX->E2_NOMFOR
		SZ0->Z0_EMISSAO := _aDados[9] //Stod(TBX->E2_EMISSAO)
		SZ0->Z0_VENCTO  := _aDados[10] //Stod(TBX->E2_VENCTO)
		SZ0->Z0_VENCREA := _aDados[11] //Stod(TBX->E2_VENCREA)
		SZ0->Z0_VALOR   := _aDados[12] //TBX->E2_VALOR
		SZ0->Z0_BAIXA   := _aDados[13] //Stod(TBX->E2_BAIXA)
		SZ0->Z0_SALDO   := _aDados[14] //TBX->E2_SALDO
		SZ0->Z0_MULTA   := _aDados[15] //TBX->E2_MULTA
		SZ0->Z0_JUROS   := _aDados[16] //TBX->E2_JUROS
		SZ0->Z0_CORREC  := _aDados[17] //TBX->E2_CORREC
		SZ0->Z0_VALLIQ  := _aDados[18] //TBX->E2_VALLIQ
		SZ0->Z0_FATPREF := _aDados[19] //TBX->E2_FATPREF
		SZ0->Z0_FATURA  := _aDados[20] //TBX->E2_FATURA
		SZ0->Z0_DTFATUR := _aDados[21] //Stod(TBX->E2_DTFATUR)
		SZ0->Z0_ACRESC  := _aDados[22] //TBX->E2_ACRESC
		SZ0->Z0_ORIGEM  := _aDados[23] //TBX->E2_ORIGEM
		SZ0->Z0_X_NUMAP := _aDados[24] //TBX->E2_X_NUMAP
		SZ0->Z0_TITPAI  := _aDados[25] //TBX->E2_TITPAI
		SZ0->Z0_MSFIL   := _aDados[26] //TBX->E2_MSFIL
		SZ0->Z0_FORMPAG := _aDados[27] //TBX->E2_FORMPAG
		SZ0->Z0_RECSE2  := _aDados[28] //Alltrim(Str( TBX->R_E_C_N_O_ ))
		SZ0->Z0_XDELET  := _aDados[29] //TBX->XSE2DEL
		SZ0->Z0_ATIVO   := _cATIVO
		SZ0->(MsUnlock())
		
		CONOUT("TERMINANDO ROTINA ("+cFunName+")")
		
	EndIf
EndIf
//Cancela o Lock de gravacao da rotina
/*
FClose(nHdlLock)
FErase(cArqLock)
*/
Return()
