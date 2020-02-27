#include "totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "RwMake.ch"

User Function XATUSZ0A()

Local _cEmp   := "01"
Local _cFil   := "01"
Local aTables := {"SB1","SBM"}
Local lExec   := .T.

Local cQry := ""

Local cTime1 := ""
Local cTime2 := "" 

Local cFunName   := Alltrim(ProcName())
Local cArqLckA := "\logLCKXATUSZ0A\"
Local cArqLckB := "\logLCKXATUSZ0B\"
Local cArqLock   := " "

Local _nQtde    := 0
Local _nQtde2    := 0
 
local aDados := {}                    

Private nQtdThread := 3
Private _lThread := .T.

MakeDir(cArqLckA)
MakeDir(cArqLckB)
cArqLock := cArqLckA+Alltrim(cFunName + ".lck" )
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
	
	CONOUT("INICIANDO ROTINA (RESTFINF)")
	
	lExec := .T.
	_nQtde := 0
	
	cQry := " SELECT --TOP 10, "+CRLF
	cQry += "        E2_FILIAL AS FILIAL,  "+CRLF
	cQry += "  	     E2_PREFIXO AS PREFIXO,  "+CRLF
	cQry += "  	     E2_NUM AS NUM,  "+CRLF
	cQry += "  		 E2_PARCELA AS PARCELA, "+CRLF
	cQry += "  		 E2_TIPO AS TIPO,  "+CRLF
	cQry += "  		 RTRIM(E2_FORNECE) AS FORNECE,  "+CRLF
	cQry += "  		 RTRIM(E2_LOJA) AS LOJA,  "+CRLF
	cQry += "  		 RTRIM(E2_NOMFOR) AS NOMFOR,  "+CRLF
	cQry += "  		 CASE WHEN E2_EMISSAO <>'' THEN convert(varchar(20), CAST(ISNULL(E2_EMISSAO,'') as datetime), 120) ELSE E2_EMISSAO END  AS EMISSAO,  "+CRLF
	cQry += "  		 CASE WHEN E2_VENCTO <>'' THEN convert(varchar(20), CAST(ISNULL(E2_VENCTO,'') as datetime), 120) ELSE E2_VENCTO END AS VENCTO,  "+CRLF
	cQry += "  		 CASE WHEN E2_VENCREA <>'' THEN convert(varchar(20), CAST(ISNULL(E2_VENCREA,'') as datetime), 120) ELSE E2_VENCREA END AS VENCREA,  "+CRLF
	cQry += "  		 E2_VALOR AS VALOR ,  "+CRLF
	cQry += "  		 E2_SALDO AS SALDO,  "+CRLF
	cQry += "  		 CASE WHEN E2_BAIXA <>'' THEN convert(varchar(20), CAST(ISNULL(E2_BAIXA,'') as datetime), 120) ELSE E2_BAIXA END AS BAIXA,  "+CRLF
	cQry += "  		 LTRIM(RTRIM(STR(SE2.R_E_C_N_O_))) AS XRECNO, "+CRLF
	cQry += "  		 CASE WHEN SE2.D_E_L_E_T_ = '' THEN 'N' ELSE 'S' END  AS XDELET, "+CRLF
	cQry += "  		 'S' AS ATIVO,  "+CRLF
	cQry += "  		 'NULL' AS DTINTEGRA, "+CRLF
	cQry += "        E2_FILIAL, "+CRLF
	cQry += "        E2_PREFIXO, "+CRLF
	cQry += "        E2_NUM, "+CRLF
	cQry += "        E2_PARCELA, "+CRLF
	cQry += "        E2_TIPO, "+CRLF
	cQry += "        E2_FORNECE, "+CRLF
	cQry += "        E2_LOJA, "+CRLF
	cQry += "        E2_NOMFOR, "+CRLF
	cQry += "        E2_EMISSAO, "+CRLF
	cQry += "        E2_VENCTO, "+CRLF
	cQry += "        E2_VENCREA, "+CRLF
	cQry += "        E2_VALOR, "+CRLF
	cQry += "        E2_BAIXA, "+CRLF
	cQry += "        E2_SALDO, "+CRLF
	cQry += "        E2_MULTA, "+CRLF
	cQry += "        E2_JUROS, "+CRLF
	cQry += "        E2_CORREC, "+CRLF
	cQry += "        E2_VALLIQ, "+CRLF
	cQry += "        E2_FATPREF, "+CRLF
	cQry += "        E2_FATURA, "+CRLF
	cQry += "        E2_DTFATUR, "+CRLF
	cQry += "        E2_ACRESC, "+CRLF
	cQry += "        E2_ORIGEM, "+CRLF
	cQry += "        E2_X_NUMAP, "+CRLF
	cQry += "        E2_TITPAI, "+CRLF
	cQry += "        E2_MSFIL, "+CRLF
	cQry += "        E2_FORMPAG, "+CRLF
	cQry += "        SE2.R_E_C_N_O_, "+CRLF
	cQry += "        SE2.D_E_L_E_T_ as XSE2DEL "+CRLF
	cQry += "        "+CRLF
	cQry += " FROM "+RetSQLName("SE2")+" SE2 "+CRLF
	cQry += " WHERE E2_FILIAL = ' '  "+CRLF
	cQry += " AND E2_EMISSAO >= '20190101'   "+CRLF
	cQry += " AND E2_FORNECE NOT IN('UNIAO','MUNIC','INPS','FOLHA','FEDER','ESTADO') "+CRLF
	//cQry += " AND E2_TIPO NOT IN ('FOL','INS','TX ')   "+CRLF
	cQry += " AND E2_TIPO IN ('NF ','NFS','FT ')   "+CRLF
	
	TCQUERY cQry ALIAS "TBX" NEW
	
	DbSelectArea("TBX")
	TBX->(DbGoTop())
	TBX->( dBEval({|| _nQtde++}) )
	TBX->(DbGoTop())
	
	If _nQtde <= 0
		CONOUT("SEM DADOS...")
	Else
		cTime1 := time()
		While !TBX->(EOf()) .And. lExec
			//Sleep(500)
			_nQtde2++
			
			_lThread := .T.
		   /*				
			While _lThread
				_lThread := !(QTDARQLCK(nQtdThread)) //Thread em execucao da rotina "u_INTEGRAS".
				Sleep(500) //
			EndDo 
			*/
			AAdd(aDados,TBX->E2_FILIAL)        //01
			AAdd(aDados,TBX->E2_PREFIXO)       //02
			AAdd(aDados,TBX->E2_NUM)           //03
			AAdd(aDados,TBX->E2_PARCELA)       //04
			AAdd(aDados,TBX->E2_TIPO)          //05
			AAdd(aDados,Alltrim(TBX->E2_FORNECE)) //06
			AAdd(aDados,TBX->E2_LOJA)           //07
			AAdd(aDados,TBX->E2_NOMFOR)         //08
			AAdd(aDados,Stod(TBX->E2_EMISSAO))  //09
			AAdd(aDados,Stod(TBX->E2_VENCTO))   //10
			AAdd(aDados,Stod(TBX->E2_VENCREA))  //11
			AAdd(aDados,TBX->E2_VALOR)          //12
			AAdd(aDados,Stod(TBX->E2_BAIXA))    //13
			AAdd(aDados,TBX->E2_SALDO)          //14
			AAdd(aDados,TBX->E2_MULTA)          //15
			AAdd(aDados,TBX->E2_JUROS)          //16
			AAdd(aDados,TBX->E2_CORREC)         //17
			AAdd(aDados,TBX->E2_VALLIQ)         //18
			AAdd(aDados,TBX->E2_FATPREF)        //19
			AAdd(aDados,TBX->E2_FATURA)         //20
			AAdd(aDados,Stod(TBX->E2_DTFATUR))  //21
			AAdd(aDados,TBX->E2_ACRESC)         //22
			AAdd(aDados,TBX->E2_ORIGEM)         //23
			AAdd(aDados,TBX->E2_X_NUMAP)        //24
			AAdd(aDados,TBX->E2_TITPAI)         //25
			AAdd(aDados,TBX->E2_MSFIL)          //26
			AAdd(aDados,TBX->E2_FORMPAG)        //27
			AAdd(aDados,Alltrim(Str( TBX->R_E_C_N_O_ ))) //28
			AAdd(aDados,TBX->XSE2DEL)                    //29
             
			//XATUSZ0B(_cRECNO,_cCHVSZ0,_aDados) 
			//Z0_FILIAL+Z0_PREFIXO+Z0_NUM+Z0_PARCELA+Z0_TIPO+Z0_FORNECE+Z0_LOJA
			//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
            //u_XATUSZ0B( TBX->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) ,aDados)    
            
            StartJob("u_XATUSZ0B",GetEnvServer(),.T.,Alltrim(Str( TBX->R_E_C_N_O_ )), TBX->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) ,aDados)
						
			TBX->(DbSkip())
		EndDo
		cTime2 := time()
	EndIf
	TBX->(DbCloseArea())
	
	CONOUT("TERMINANDO ROTINA (RESTFINF)")
	
EndIf

//Cancela o Lock de gravacao da rotina
FClose(nHdlLock)
FErase(cArqLock)

Return()

/*
* Rotina: QTDARQLCK()
* Descr.: Retorna o numero de Thread de uma rotina especifica
*/
Static Function QTDARQLCK(nQTDThread)
Local lRet := .T.
Local aDirectory  := Directory("\loglckxatusz0a\*.LCK","D")
Local nQtdArq := 0        

Default nQTDThread := 0

AEVAL(aDirectory, {||  nQtdArq ++ } )

lRet := IIF(nQtdArq <= nQTDThread,.T.,.F.)

Return(lRet)                                                 