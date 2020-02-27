#include "totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "RwMake.ch"

User Function RESTSZ0()


Local cUrlBase := "https://www.midoriautoleather.com.br/cotacao/rest.php?class=CotacaoRest&method=getMethod"
Local cJson := ""
Local cQry := ""

Local aTables := {"SZ0"}
Local _cEmp   := "01"
Local _cFil   := "01"
Local lExec   := .T.


Local cFunName   := Alltrim(ProcName())
Local cArqLckNfe := "\logLCKNfe\"
Local cArqLock   := " "

Local _cUrl    := ""
Local _cClass  := ""
Local _cMethod := ""
Local _cData   := ""
Local _cRecnoerp := ""

Local _nQtde   := 0
Local _nQtde2  := 0

Private _DTRECEMAIL := '20491231' //Data para acompanhamento de e-mail de envio de cota豫o
Private _DTRECEMAI2 := '20181221' //Data para acompanhamento de e-mail de envio de cota豫o
//Private cEmailCopy  := IIf( DtoS(Date()) <= _DTRECEMAIL ,"andre@adeoconsultor.com.br;marcos.oliveira@midoriautoleather.com.br;","")
Private cEmailCopy  := IIf( DtoS(Date()) <= _DTRECEMAIL ,"marcos.oliveira@midoriautoleather.com.br;","")

cEmailCopy  += IIf( DtoS(Date()) <= _DTRECEMAI2 ,"andre@sigasp.com;","")

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
	
	CONOUT("INICIANDO ROTINA ("+ cFunName +")")
	
	lExec := .T.
	_nQtde := 0
	
	cQry := "  "+CRLF
	cQry += " SELECT --TOP 100  "+CRLF
	cQry += " Z0_FILIAL AS FILIAL,   "+CRLF
	cQry += " Z0_PREFIXO AS PREFIXO,  "+CRLF
	cQry += " Z0_NUM AS NUM,     "+CRLF
	cQry += " Z0_PARCELA AS PARCELA,   "+CRLF
	cQry += " Z0_TIPO AS TIPO,     "+CRLF
	cQry += " RTRIM(Z0_FORNECE) AS FORNECE,   "+CRLF
	cQry += " RTRIM(Z0_LOJA) AS LOJA,  "+CRLF
	cQry += " RTRIM(Z0_NOMFOR) AS NOMFOR, "+CRLF
	cQry += " CASE WHEN Z0_EMISSAO <>'' THEN convert(varchar(20), CAST(ISNULL(Z0_EMISSAO,'') as datetime), 120) ELSE Z0_EMISSAO END  AS EMISSAO,   "+CRLF
	cQry += " CASE WHEN Z0_VENCTO <>'' THEN convert(varchar(20), CAST(ISNULL(Z0_VENCTO,'') as datetime), 120) ELSE Z0_VENCTO END AS VENCTO,   "+CRLF
	cQry += " CASE WHEN Z0_VENCREA <>'' THEN convert(varchar(20), CAST(ISNULL(Z0_VENCREA,'') as datetime), 120) ELSE Z0_VENCREA END AS VENCREA,   "+CRLF
	cQry += " Z0_VALOR AS VALOR ,  "+CRLF
	cQry += " Z0_SALDO AS SALDO,  "+CRLF
	cQry += " CASE WHEN Z0_BAIXA <>'' THEN convert(varchar(20), CAST(ISNULL(Z0_BAIXA,'') as datetime), 120) ELSE Z0_BAIXA END AS BAIXA,  "+CRLF
	cQry += " LTRIM(RTRIM(STR(R_E_C_N_O_))) AS XRECNO,   "+CRLF
	cQry += " CASE WHEN D_E_L_E_T_ = '' THEN 'N' ELSE 'S' END  AS XDELET,    "+CRLF
	cQry += " 'S' AS ATIVO,  "+CRLF
	cQry += " 'NULL' AS DTINTEGRA,   "+CRLF
	cQry += " Z0_FILIAL,  "+CRLF
	cQry += " Z0_PREFIXO,    "+CRLF
	cQry += " Z0_NUM,  "+CRLF
	cQry += " Z0_PARCELA,  "+CRLF
	cQry += " Z0_TIPO,   "+CRLF
	cQry += " Z0_FORNECE, "+CRLF
	cQry += " Z0_LOJA,    "+CRLF
	cQry += " Z0_NOMFOR,    "+CRLF
	cQry += " Z0_EMISSAO,    "+CRLF
	cQry += " Z0_VENCTO,    "+CRLF
	cQry += " Z0_VENCREA,  "+CRLF
	cQry += " Z0_VALOR,    "+CRLF
	cQry += " Z0_BAIXA,    "+CRLF
	cQry += " Z0_SALDO,   "+CRLF
	cQry += " Z0_MULTA,   "+CRLF
	cQry += " Z0_JUROS,  "+CRLF
	cQry += " Z0_CORREC, "+CRLF
	cQry += " Z0_VALLIQ,  "+CRLF
	cQry += " Z0_FATPREF, "+CRLF
	cQry += " Z0_FATURA,  "+CRLF
	cQry += " Z0_DTFATUR, "+CRLF
	cQry += " Z0_ACRESC,  "+CRLF
	cQry += " Z0_ORIGEM,   "+CRLF
	cQry += " Z0_X_NUMAP,   "+CRLF
	cQry += " Z0_TITPAI,    "+CRLF
	cQry += " Z0_MSFIL,  "+CRLF
	cQry += " Z0_FORMPAG,  "+CRLF
	cQry += " Z0_XDELET,  "+CRLF
	cQry += " Z0_RECSE2,  "+CRLF
	cQry += " R_E_C_N_O_ AS SE2RECNO,   "+CRLF
	cQry += " D_E_L_E_T_ as SE2DEL "+CRLF
	cQry += " FROM SZ0010 SZ0  "+CRLF
	cQry += " WHERE Z0_DTINTEG = '' "+CRLF
	cQry += " AND D_E_L_E_T_ = '' "+CRLF
	
	TCQUERY cQry ALIAS "TBX" NEW
	
	DbSelectArea("TBX")
	TBX->(DbGoTop())
	TBX->( dBEval({|| _nQtde++}) )
	TBX->(DbGoTop())
	
	If _nQtde <= 0
		CONOUT("SEM DADOS...")
	Else
		
		While !TBX->(EOf()) .And. lExec
			//Sleep(500)
			_nQtde2++
			
			
			//conout( Alltrim(Str(_nQtde2)) +" / "+ Alltrim(Str(_nQtde)) )
			aHeader := {}
			Aadd(aHeader, "Content-Type: application/json")
			
			cJson := ''
			cJson += '{'
			cJson += '"filial":"'+TBX->Z0_FILIAL+'",'
			cJson += '"prefixo":"'+TBX->Z0_PREFIXO+'",'
			cJson += '"numero":"'+TBX->Z0_NUM+'",'
			cJson += '"parcela":"'+TBX->Z0_PARCELA+'",'
			cJson += '"tipo":"'+TBX->Z0_TIPO+'", '
			cJson += '"coderp_fornece":"'+TBX->Z0_FORNECE+'",'
			cJson += '"loja":"'+TBX->Z0_LOJA+'",'
			cJson += '"nomefornece":"'+TBX->Z0_NOMFOR+'",'
			cJson += '"dtemissao":"'+TBX->EMISSAO+'",'
			cJson += '"dtvencimento":"'+TBX->VENCTO+'",'
			cJson += '"dtvecntoreal":"'+TBX->VENCREA+'",'
			cJson += '"valor":"'+Alltrim(Str(TBX->Z0_VALOR))+'",'
			cJson += '"saldo":"'+Alltrim(Str(TBX->Z0_SALDO))+'",'
			cJson += '"dtbaixa":"'+TBX->BAIXA+'",'
			cJson += '"recnoerp":"'+Alltrim(TBX->Z0_RECSE2)+'",'
			cJson += '"delet":"'+Alltrim(TBX->Z0_XDELET)+'",'
			cJson += '"ativo":"'+TBX->ATIVO+'",'
			cJson += '"dtintegracao":"'+DtoS(Date())+'"'
			cJson += '}'
			
			cUrlBase := "https://www.midoriautoleather.com.br"
			aHeader := {"Content-Type: application/json"}
			
			//_cUrl    := 'http://adeoconsultor.com.br'
			_cUrl    := "https://www.midoriautoleather.com.br"
			_cClass  := 'class=MlbrTitulosfornecedorRestService'
			_cMethod := 'method=InsUpd'
			_cData   := 'data='+EncodeUtf8(cJson)
			_cRecnoerp := '&recnoerp='+Alltrim(TBX->XRECNO)+''
			
			oRestClient := FWRest():New(_cUrl)
			
			//oRestClient:setPath("/appmidori/rest.php?class=MlbrTitulosfornecedorRestService&method=getMethod")
			oRestClient:setPath("/portal/rest.php?class=MlbrTitulosfornecedorRestService&method=getMethod")
			oRestClient:cHost := _cUrl
			oRestClient:SetPostParams( cJson )
			
			If oRestClient:Post(aHeader)
				
				//Gravou com sucesso no WSRest
				//ConOut("GET", oRestClient:GetResult())
				    
				
				DbSelectArea("SZ0")
				SZ0->(DbSetOrder(1)) //Z0_FILIAL+Z0_PREFIXO+Z0_NUM+Z0_PARCELA+Z0_TIPO+Z0_FORNECE+Z0_LOJA
				SZ0->(DbGoTop())
				If SZ0->(DbSeek( TBX->Z0_FILIAL+TBX->Z0_PREFIXO+TBX->Z0_NUM+TBX->Z0_PARCELA+TBX->Z0_TIPO+TBX->Z0_FORNECE+TBX->Z0_LOJA ))
					RecLock("SZ0",.f.)
					//conout(" SZ0 -- Atualizando" )

					SZ0->Z0_DTINTEG := Date() //dDataBase
					SZ0->(MsUnlock())
					
				EndIf
				
				SZ0->(DbCloseArea())
				
				
			Else
				ConOut("GET", oRestClient:GetLastError())
			EndIf
			
			oRestClient := Nil
			
			TBX->(DbSkip())
			
		EndDo
		
	EndIf
	TBX->(DbCloseArea())
	
	CONOUT("TERMINANDO ROTINA ("+ cFunName +")")
	
EndIf

//Cancela o Lock de gravacao da rotina
FClose(nHdlLock)
FErase(cArqLock)

Return()
