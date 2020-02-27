#include "totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "RwMake.ch"

User Function RESTFIN2()

Local cQry := ""

Local aTables := {"SE2"}
Local _cEmp   := "01"
Local _cFil   := "01"
Local lExec   := .T.

Local cFunName   := Alltrim(ProcName())
Local cArqLckNfe := "\logLCKNfe\"
Local cArqLock   := " "

Local cHrInicio := TIME()

MakeDir(cArqLckNfe)
cArqLock := Alltrim(cFunName + ".lck" )
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Efetua o Lock de gravacao da Rotina - Monousuario            ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
FErase(cArqLock)
nHdlLock := MsFCreate(cArqLock)
IF nHdlLock < 0
	Conout("")
	Conout("**  Rotina "+ cFunName +" em uso...")
	Conout("")
	Return(.T.)
EndIF

//Preparando Ambiente
//RpcSetType(3)
lRetEnv := RpcSetEnv( _cEmp, _cFil, ,, 'COM', , aTables,  ,.f. , , )


If lRetEnv
	
	cHrInicio := TIME()
	CONOUT("INICIANDO ROTINA ( "+cFunName+" )")
	
	lExec := .T.
	_nQtde := 0
	
	cQry := " SELECT TOP 200 "+CRLF
	cQry += "        E2_FILIAL AS FILIAL,   "+CRLF
	cQry += "  	     E2_PREFIXO AS PREFIXO,   "+CRLF
	cQry += "  	     E2_NUM AS NUM,   "+CRLF
	cQry += "  		 E2_PARCELA AS PARCELA,  "+CRLF
	cQry += "  		 E2_TIPO AS TIPO,  "+CRLF
	cQry += "  		 RTRIM(E2_FORNECE) AS FORNECE,   "+CRLF
	cQry += "  		 RTRIM(E2_LOJA) AS LOJA,   "+CRLF
	cQry += "  		 RTRIM(E2_NOMFOR) AS NOMFOR,   "+CRLF
	cQry += "  		 CASE WHEN E2_EMISSAO <>'' THEN convert(varchar(20), CAST(ISNULL(E2_EMISSAO,'') as datetime), 120) ELSE E2_EMISSAO END  AS EMISSAO,   "+CRLF
	cQry += "  		 CASE WHEN E2_VENCTO <>'' THEN convert(varchar(20), CAST(ISNULL(E2_VENCTO,'') as datetime), 120) ELSE E2_VENCTO END AS VENCTO,   "+CRLF
	cQry += "  		 CASE WHEN E2_VENCREA <>'' THEN convert(varchar(20), CAST(ISNULL(E2_VENCREA,'') as datetime), 120) ELSE E2_VENCREA END AS VENCREA,   "+CRLF
	cQry += "  		 E2_VALOR AS VALOR ,   "+CRLF
	cQry += "  		 E2_SALDO AS SALDO,  "+CRLF
	cQry += "  		 CASE WHEN E2_BAIXA <>'' THEN convert(varchar(20), CAST(ISNULL(E2_BAIXA,'') as datetime), 120) ELSE E2_BAIXA END AS BAIXA,   "+CRLF
	cQry += "  		 LTRIM(RTRIM(STR(R_E_C_N_O_))) AS XRECNO,  "+CRLF
	cQry += "  		 CASE WHEN D_E_L_E_T_ = '' THEN 'N' ELSE 'S' END  AS XDELET,  "+CRLF
	cQry += "  		 'S' AS ATIVO,   "+CRLF
	cQry += "  		 'NULL' AS DTINTEGRA,  "+CRLF
	cQry += "        E2_FILIAL,  "+CRLF
	cQry += "        E2_PREFIXO,  "+CRLF
	cQry += "        E2_NUM,  "+CRLF
	cQry += "        E2_PARCELA,  "+CRLF
	cQry += "        E2_TIPO,        "+CRLF
	cQry += "        E2_FORNECE,  "+CRLF
	cQry += "        E2_LOJA,  "+CRLF
	cQry += "        E2_NOMFOR,  "+CRLF
	cQry += "        E2_EMISSAO,  "+CRLF
	cQry += "        E2_VENCTO,  "+CRLF
	cQry += "        E2_VENCREA,  "+CRLF
	cQry += "        E2_VALOR,  "+CRLF
	cQry += "        E2_BAIXA,  "+CRLF
	cQry += "        E2_SALDO,  "+CRLF
	cQry += "        E2_MULTA,  "+CRLF
	cQry += "        E2_JUROS,  "+CRLF
	cQry += "        E2_CORREC,  "+CRLF
	cQry += "        E2_VALLIQ,  "+CRLF
	cQry += "        E2_FATPREF,  "+CRLF
	cQry += "        E2_FATURA,  "+CRLF
	cQry += "        E2_DTFATUR,  "+CRLF
	cQry += "        E2_ACRESC,  "+CRLF
	cQry += "        E2_ORIGEM,  "+CRLF
	cQry += "        E2_X_NUMAP,  "+CRLF
	cQry += "        E2_TITPAI,  "+CRLF
	cQry += "        E2_MSFIL,  "+CRLF
	cQry += "        E2_FORMPAG,  "+CRLF
	cQry += "        R_E_C_N_O_ AS SE2RECNO,  "+CRLF
	cQry += "        D_E_L_E_T_ as SE2DEL  "+CRLF
	cQry += "  FROM SE2010 SE2 "+CRLF
	cQry += "  WHERE E2_TIPO NOT IN ('FOL','INS','TX ')   "+CRLF
	
	TCQUERY cQry ALIAS "TBX" NEW
	
	DbSelectArea("TBX")
	TBX->(DbGoTop())
	TBX->( dBEval({|| _nQtde++}) )
	TBX->(DbGoTop())
	
	If _nQtde <= 0
		CONOUT("SEM DADOS...")
	Else
		
		_nQtde2 := 0
		While !TBX->(EOf()) .And. lExec
			
			_nQtde2++
			
			DbSelectArea("SZ0")
			SZ0->(DbSetOrder(1)) //Z0_FILIAL+Z0_PREFIXO+Z0_NUM+Z0_PARCELA+Z0_TIPO+Z0_FORNECE+Z0_LOJA
			SZ0->(DbGoTop())
			If SZ0->(DbSeek( TBX->E2_FILIAL+TBX->E2_PREFIXO+TBX->E2_NUM+TBX->E2_PARCELA+TBX->E2_TIPO+TBX->E2_FORNECE+TBX->E2_LOJA ))
			
				If (Alltrim(SZ0->Z0_NOMFOR) <> Alltrim(TBX->E2_NOMFOR)) .or.;
					(SZ0->Z0_EMISSAO <> StoD(TBX->E2_EMISSAO)) .or.;
					(SZ0->Z0_VENCTO  <> StoD(TBX->E2_VENCTO)) .or.;
					(SZ0->Z0_VENCREA <> StoD(TBX->E2_VENCREA)) .or.;
					(SZ0->Z0_VALOR   <> TBX->E2_VALOR) .or.;
					(SZ0->Z0_BAIXA   <> StoD(TBX->E2_BAIXA)) .or.;
					(SZ0->Z0_SALDO   <> TBX->E2_SALDO) .or.;
					(SZ0->Z0_MULTA   <> TBX->E2_MULTA) .or.;
					(SZ0->Z0_JUROS   <> TBX->E2_JUROS) .or.;
					(SZ0->Z0_CORREC  <> TBX->E2_CORREC) .or.;
					(SZ0->Z0_VALLIQ  <> TBX->E2_VALLIQ) .or.;
					(SZ0->Z0_FATPREF <> TBX->E2_FATPREF) .or.;
					(SZ0->Z0_FATURA  <> TBX->E2_FATURA) .or.;
					(SZ0->Z0_DTFATUR <> StoD(TBX->E2_DTFATUR)) .or.;
					(SZ0->Z0_ACRESC  <> TBX->E2_ACRESC) .or.;
					(Alltrim(SZ0->Z0_ORIGEM)  <> Alltrim(TBX->E2_ORIGEM)) .or.;
					(Alltrim(SZ0->Z0_X_NUMAP) <> Alltrim(TBX->E2_X_NUMAP)) .or.;
					(Alltrim(SZ0->Z0_TITPAI)  <> Alltrim(TBX->E2_TITPAI)) .or.;
					(Alltrim(SZ0->Z0_MSFIL)   <> Alltrim(TBX->E2_MSFIL)) .or.;
					(Alltrim(SZ0->Z0_FORMPAG) <> Alltrim(TBX->E2_FORMPAG)) .or.;
					(Alltrim(SZ0->Z0_RECSE2)  <> Alltrim(Str(TBX->(Recno())))) .or.;
					(Alltrim(SZ0->Z0_XDELET)  <> Alltrim(Iif(TBX->XDELET == 'N',' ','*'))) 
				
					//RecLock("SZ0",.f.)
					conout( Alltrim(Str(_nQtde2)) +" / "+ Alltrim(Str(_nQtde)) + " (Atualizando)" ) 
					DbSelectArea("SZ0")
					RecLock("SZ0",.f.)
					SZ0->Z0_NOMFOR  := TBX->E2_NOMFOR
					SZ0->Z0_EMISSAO := StoD(TBX->E2_EMISSAO)
					SZ0->Z0_VENCTO  := StoD(TBX->E2_VENCTO)
					SZ0->Z0_VENCREA := StoD(TBX->E2_VENCREA)
					SZ0->Z0_VALOR   := TBX->E2_VALOR
					SZ0->Z0_BAIXA   := StoD(TBX->E2_BAIXA)
					SZ0->Z0_SALDO   := TBX->E2_SALDO
					SZ0->Z0_MULTA   := TBX->E2_MULTA
					SZ0->Z0_JUROS   := TBX->E2_JUROS
					SZ0->Z0_CORREC  := TBX->E2_CORREC
					SZ0->Z0_VALLIQ  := TBX->E2_VALLIQ
					SZ0->Z0_FATPREF := TBX->E2_FATPREF
					SZ0->Z0_FATURA  := TBX->E2_FATURA
					SZ0->Z0_DTFATUR := StoD(TBX->E2_DTFATUR)
					SZ0->Z0_ACRESC  := TBX->E2_ACRESC
					SZ0->Z0_ORIGEM  := TBX->E2_ORIGEM
					SZ0->Z0_X_NUMAP := TBX->E2_X_NUMAP
					SZ0->Z0_TITPAI  := TBX->E2_TITPAI
					SZ0->Z0_MSFIL   := TBX->E2_MSFIL
					SZ0->Z0_FORMPAG := TBX->E2_FORMPAG
					SZ0->Z0_RECSE2  := Alltrim(Str(TBX->(Recno())))
					SZ0->Z0_XDELET  := Iif(TBX->XDELET == 'N',' ','*')
					SZ0->Z0_ATIVO   := "S"
					SZ0->Z0_DTINTEG := StoD(" / / ") //dDataBase
					SZ0->(MsUnlock())    					
                EndIf
			
			Else
			
				conout( Alltrim(Str(_nQtde2)) +" / "+ Alltrim(Str(_nQtde)) + " (Incluindo)" )
				DbSelectArea("SZ0")
				RecLock("SZ0",.T.)
				SZ0->Z0_FILIAL  := TBX->E2_FILIAL
				SZ0->Z0_PREFIXO := TBX->E2_PREFIXO
				SZ0->Z0_NUM     := TBX->E2_NUM
				SZ0->Z0_PARCELA := TBX->E2_PARCELA
				SZ0->Z0_TIPO    := TBX->E2_TIPO
				SZ0->Z0_FORNECE := Alltrim(TBX->E2_FORNECE)
				SZ0->Z0_LOJA    := TBX->E2_LOJA
				SZ0->Z0_NOMFOR  := TBX->E2_NOMFOR
				SZ0->Z0_EMISSAO := StoD(TBX->E2_EMISSAO)
				SZ0->Z0_VENCTO  := StoD(TBX->E2_VENCTO)
				SZ0->Z0_VENCREA := StoD(TBX->E2_VENCREA)
				SZ0->Z0_VALOR   := TBX->E2_VALOR
				SZ0->Z0_BAIXA   := StoD(TBX->E2_BAIXA)
				SZ0->Z0_SALDO   := TBX->E2_SALDO
				SZ0->Z0_MULTA   := TBX->E2_MULTA
				SZ0->Z0_JUROS   := TBX->E2_JUROS
				SZ0->Z0_CORREC  := TBX->E2_CORREC
				SZ0->Z0_VALLIQ  := TBX->E2_VALLIQ
				SZ0->Z0_FATPREF := TBX->E2_FATPREF
				SZ0->Z0_FATURA  := TBX->E2_FATURA
				SZ0->Z0_DTFATUR := StoD(TBX->E2_DTFATUR)
				SZ0->Z0_ACRESC  := TBX->E2_ACRESC
				SZ0->Z0_ORIGEM  := TBX->E2_ORIGEM
				SZ0->Z0_X_NUMAP := TBX->E2_X_NUMAP
				SZ0->Z0_TITPAI  := TBX->E2_TITPAI
				SZ0->Z0_MSFIL   := TBX->E2_MSFIL
				SZ0->Z0_FORMPAG := TBX->E2_FORMPAG
				SZ0->Z0_RECSE2  := Alltrim(Str(TBX->(Recno())))
				SZ0->Z0_XDELET  := Iif(TBX->XDELET == 'N',' ','*')
				SZ0->Z0_ATIVO   := "S"
				SZ0->Z0_DTINTEG := StoD(" / / ") //dDataBase
				SZ0->(MsUnlock())    
				
			EndIf
			
			
			TBX->(DbSkip())
		EndDo
		
	EndIf
	TBX->(DbCloseArea())
	
	cElapsed := ElapTime( cHrInicio, TIME() )
	
	CONOUT("TERMINANDO ROTINA ( "+cFunName+" ) (Tempo execucao '"+cElapsed+"')")
	
	
EndIf
Return()
