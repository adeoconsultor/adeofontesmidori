#include "totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "RwMake.ch"

User Function RESTFINF()


Local cUrlBase := "http://www.midoriautoleather.com.br/cotacao/rest.php?class=CotacaoRest&method=getMethod"
Local cJson := ""
Local cQry := ""

Local aTables := {"SB1","SBM"}
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


Local _nQtde    := 0
Local _nQtde2    := 0

Local _nQtde3 := 0
Local _nQtde4 := 0

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
	
	CONOUT("INICIANDO ROTINA (RESTFINF)")
	
	lExec := .T.
	_nQtde := 0
	
	cQry := " SELECT --TOP 10 "+CRLF
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
	cQry += "  AND E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA NOT IN (  SELECT Z0_FILIAL+Z0_PREFIXO+Z0_NUM+Z0_PARCELA+Z0_TIPO+Z0_FORNECE+Z0_LOJA  "+CRLF  
	cQry += "                                                                                  FROM SZ0010     "+CRLF
	cQry += "                                                                                  WHERE Z0_FILIAL = E2_FILIAL    "+CRLF
	cQry += "                                                                                  AND Z0_PREFIXO = E2_PREFIXO	  "+CRLF  
	cQry += "                                                                                  AND Z0_NUM = E2_NUM	    "+CRLF
	cQry += "                                                                                  AND Z0_PARCELA = E2_PARCELA	   "+CRLF 
	cQry += "                                                                                  AND Z0_TIPO = E2_TIPO	    "+CRLF
	cQry += "                                                                                  AND Z0_FORNECE = E2_FORNECE "+CRLF	   
	cQry += "                                                                                  AND Z0_LOJA = E2_LOJA    "+CRLF
	cQry += "                                                                                     "+CRLF
	cQry += "                                                                                  AND (Z0_EMISSAO = E2_EMISSAO  "+CRLF  
	cQry += "                                                                                  AND Z0_VENCTO = E2_VENCTO    "+CRLF
	cQry += "                                                                                  AND Z0_VENCREA = E2_VENCREA   "+CRLF 
	cQry += "                                                                                  AND Z0_VALOR = E2_VALOR    "+CRLF
	cQry += "                                                                                  AND Z0_SALDO = E2_SALDO    "+CRLF
	cQry += "                                                                                  AND Z0_BAIXA = E2_BAIXA    "+CRLF
	cQry += "                                                                                  AND RTRIM(LTRIM(Z0_RECSE2)) = RTRIM(LTRIM(STR(SE2.R_E_C_N_O_)))    "+CRLF
	cQry += "                                                                                  AND RTRIM(LTRIM(Z0_XDELET)) = RTRIM(LTRIM(SE2.D_E_L_E_T_))) ) "+CRLF

	TCQUERY cQry ALIAS "TBX" NEW
	
	DbSelectArea("TBX")
	TBX->(DbGoTop())
	TBX->( dBEval({|| _nQtde++}) )
	TBX->(DbGoTop())
	
	If _nQtde <= 0
		CONOUT("SEM DADOS...")
	Else
				
		While !TBX->(EOf()) .And. lExec
			Sleep(500)
			_nQtde2++
            
			cQry2 := " SELECT D_E_L_E_T_ AS XSE2DEL,* FROM SE2010 WHERE R_E_C_N_O_ = '"+ TBX->XRECNO +"'  " 
			TCQUERY cQry2 ALIAS "TBY" NEW
               
			_nQtde3 := 0
	
			DbSelectArea("TBY")
			TBY->(DbGoTop())
			TBY->( dBEval({|| _nQtde3++}) )
			TBY->(DbGoTop())

			If _nQtde3 > 0

				DbSelectArea("SZ0") 
				SZ0->(DbSetOrder(1)) //Z0_FILIAL+Z0_PREFIXO+Z0_NUM+Z0_PARCELA+Z0_TIPO+Z0_FORNECE+Z0_LOJA
				SZ0->(DbGoTop())
				If SZ0->(DbSeek( TBY->E2_FILIAL+TBY->E2_PREFIXO+TBY->E2_NUM+TBY->E2_PARCELA+TBY->E2_TIPO+TBY->E2_FORNECE+TBY->E2_LOJA )) 
				
					if (SZ0->Z0_FILIAL <> TBY->E2_FILIAL .AND. ;
						SZ0->Z0_PREFIXO <> TBY->E2_PREFIXO .AND.;
						SZ0->Z0_NUM <> TBY->E2_NUM .AND.;
						SZ0->Z0_PARCELA <> TBY->E2_PARCELA .AND.;
						SZ0->Z0_TIPO <> TBY->E2_TIPO .AND.;
						SZ0->Z0_FORNECE <> TBY->E2_FORNECE .AND.;
						SZ0->Z0_LOJA <> TBY->E2_LOJA .AND.   ;
						SZ0->Z0_NOMFOR <> TBY->E2_NOMFOR .AND.;
						SZ0->Z0_EMISSAO <> StoD(TBY->E2_EMISSAO) .AND.;
						SZ0->Z0_VENCTO <> Stod(TBY->E2_VENCTO) .AND.;
						SZ0->Z0_VENCREA <> StoD(TBY->E2_VENCREA) .AND.;
						SZ0->Z0_VALOR <> TBY->E2_VALOR .AND.;
						SZ0->Z0_BAIXA <> StoD(TBY->E2_BAIXA) .AND. ;
						SZ0->Z0_SALDO <> TBY->E2_SALDO .AND.;
						SZ0->Z0_MULTA <> TBY->E2_MULTA .AND.;
						SZ0->Z0_JUROS <> TBY->E2_JUROS .AND.;
						SZ0->Z0_CORREC <> TBY->E2_CORREC .AND.;
						SZ0->Z0_VALLIQ <> TBY->E2_VALLIQ .AND.;
						SZ0->Z0_FATPREF <> TBY->E2_FATPREF .AND.;
						SZ0->Z0_FATURA <> TBY->E2_FATURA .AND.;
						SZ0->Z0_DTFATUR <> Stod(TBY->E2_DTFATUR) .AND.;
						SZ0->Z0_ACRESC <> TBY->E2_ACRESC .AND.;
						SZ0->Z0_ORIGEM <> TBY->E2_ORIGEM .AND.;
						SZ0->Z0_X_NUMAP <> TBY->E2_X_NUMAP .AND.;
						SZ0->Z0_TITPAI <> TBY->E2_TITPAI .AND.;
						SZ0->Z0_MSFIL <> TBY->E2_MSFIL .AND.;
						SZ0->Z0_FORMPAG <> TBY->E2_FORMPAG .AND.;
						Alltrim(SZ0->Z0_RECSE2) <> Alltrim(Str(TBY->R_E_C_N_O_)) .AND. ;
						Alltrim(SZ0->Z0_XDELET) <> Alltrim(TBY->XSE2DEL)  )

						
						_nQtde3 := 0                    
                    
                    Else
                    
						_nQtde4 := 0
										
					EndIf
				

				 
				Else
				
					_nQtde3 := 0
				
				EndIf			     
			
			EndIf

//return()
			
			DbSelectArea("SE2")
			SE2->(DbSetOrder(1))
			SE2->(DbGoTop())
			If SE2->(DbSeek( TBX->E2_FILIAL+TBX->E2_PREFIXO+TBX->E2_NUM+TBX->E2_PARCELA+TBX->E2_TIPO+TBX->E2_FORNECE+TBX->E2_LOJA ))
							
				//conout( Alltrim(Str(_nQtde2)) +" / "+ Alltrim(Str(_nQtde)) )
				aHeader := {}
				Aadd(aHeader, "Content-Type: application/json")
				
				cJson := ''
				cJson += '{'
				cJson += '"filial":"'+TBX->E2_FILIAL+'",'
				cJson += '"prefixo":"'+TBX->E2_PREFIXO+'",'
				cJson += '"numero":"'+TBX->E2_NUM+'",'
				cJson += '"parcela":"'+TBX->E2_PARCELA+'",'
				cJson += '"tipo":"'+TBX->E2_TIPO+'", '
				cJson += '"coderp_fornece":"'+TBX->E2_FORNECE+'",'
				cJson += '"loja":"'+TBX->E2_LOJA+'",'
				cJson += '"nomefornece":"'+TBX->E2_NOMFOR+'",'
				cJson += '"dtemissao":"'+TBX->E2_EMISSAO+'",'
				cJson += '"dtvencimento":"'+TBX->E2_VENCTO+'",'
				cJson += '"dtvecntoreal":"'+TBX->E2_VENCREA+'",'
				cJson += '"valor":"'+Alltrim(Str(TBX->E2_VALOR))+'",'
				cJson += '"saldo":"'+Alltrim(Str(TBX->E2_SALDO))+'",'
				cJson += '"dtbaixa":"'+TBX->E2_BAIXA+'",'
				cJson += '"recnoerp":"'+Alltrim(TBX->XRECNO)+'",'
				cJson += '"delet":"'+Alltrim(TBX->XDELET)+'",'
				cJson += '"ativo":"'+TBX->ATIVO+'",'
				cJson += '"dtintegracao":"'+TBX->DTINTEGRA+'"'
				cJson += '}'
				
				cUrlBase := "http://www.midoriautoleather.com.br"
				aHeader := {"Content-Type: application/json"}
				
				_cUrl    := 'http://adeoconsultor.com.br'
				_cClass  := 'class=MlbrTitulosfornecedorRestService'
				_cMethod := 'method=InsUpd'
				_cData   := 'data='+EncodeUtf8(cJson)
				_cRecnoerp := '&recnoerp='+Alltrim(TBX->XRECNO)+''
				
				oRestClient := FWRest():New(_cUrl)
				
				oRestClient:setPath("/appmidori/rest.php?class=MlbrTitulosfornecedorRestService&method=getMethod")
				oRestClient:cHost := _cUrl
				oRestClient:SetPostParams( cJson )
	
				If oRestClient:Post(aHeader) 
	
					//Gravou com sucesso no WSRest
					//ConOut("GET", oRestClient:GetResult())
					
					DbSelectArea("SE2")
					SE2->(DbSetOrder(1))
					SE2->(DbGoTop())
					If SE2->(DbSeek( TBX->E2_FILIAL+TBX->E2_PREFIXO+TBX->E2_NUM+TBX->E2_PARCELA+TBX->E2_TIPO+TBX->E2_FORNECE+TBX->E2_LOJA ))
					
						DbSelectArea("SZ0") 
						SZ0->(DbSetOrder(1)) //Z0_FILIAL+Z0_PREFIXO+Z0_NUM+Z0_PARCELA+Z0_TIPO+Z0_FORNECE+Z0_LOJA
						SZ0->(DbGoTop())
						If SZ0->(DbSeek( SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA ))  
							RecLock("SZ0",.f.)                              
							conout( Alltrim(Str(_nQtde2)) +" / "+ Alltrim(Str(_nQtde)) + " (Atualizando)" )
						Else
							RecLock("SZ0",.T.)                                          
							conout( Alltrim(Str(_nQtde2)) +" / "+ Alltrim(Str(_nQtde)) + " (Incluindo)" )
						EndIf
						
						SZ0->Z0_FILIAL := SE2->E2_FILIAL
						SZ0->Z0_PREFIXO := SE2->E2_PREFIXO
						SZ0->Z0_NUM := SE2->E2_NUM
						SZ0->Z0_PARCELA := SE2->E2_PARCELA
						SZ0->Z0_TIPO := SE2->E2_TIPO
						SZ0->Z0_FORNECE := Alltrim(SE2->E2_FORNECE)
						SZ0->Z0_LOJA := SE2->E2_LOJA
						SZ0->Z0_NOMFOR := SE2->E2_NOMFOR
						SZ0->Z0_EMISSAO := SE2->E2_EMISSAO
						SZ0->Z0_VENCTO := SE2->E2_VENCTO
						SZ0->Z0_VENCREA := SE2->E2_VENCREA
						SZ0->Z0_VALOR := SE2->E2_VALOR
						SZ0->Z0_BAIXA := SE2->E2_BAIXA
						SZ0->Z0_SALDO := SE2->E2_SALDO
						SZ0->Z0_MULTA := SE2->E2_MULTA
						SZ0->Z0_JUROS := SE2->E2_JUROS
						SZ0->Z0_CORREC := SE2->E2_CORREC
						SZ0->Z0_VALLIQ := SE2->E2_VALLIQ
						SZ0->Z0_FATPREF := SE2->E2_FATPREF
						SZ0->Z0_FATURA := SE2->E2_FATURA
						SZ0->Z0_DTFATUR := SE2->E2_DTFATUR
						SZ0->Z0_ACRESC := SE2->E2_ACRESC
						SZ0->Z0_ORIGEM := SE2->E2_ORIGEM
						SZ0->Z0_X_NUMAP := SE2->E2_X_NUMAP
						SZ0->Z0_TITPAI := SE2->E2_TITPAI
						SZ0->Z0_MSFIL := SE2->E2_MSFIL
						SZ0->Z0_FORMPAG := SE2->E2_FORMPAG
						SZ0->Z0_RECSE2 := Alltrim(Str(SE2->(Recno())))
						SZ0->Z0_XDELET := Iif(TBX->XDELET == 'N',' ','*')
						SZ0->Z0_ATIVO   := "S" 
						SZ0->Z0_DTINTEG := Date() //dDataBase
						SZ0->(MsUnlock()) 
						
						SZ0->(DbCloseArea())
											
					EndIf   
					    
					SE2->(DbCloseArea())
					
				Else
					ConOut("GET", oRestClient:GetLastError())
				EndIf
				
				oRestClient := Nil
				
			EndIf
			TBX->(DbSkip())
		EndDo
		
	EndIf
	TBX->(DbCloseArea())

	CONOUT("TERMINANDO ROTINA (RESTFINF)")
	
EndIf

//Cancela o Lock de gravacao da rotina
FClose(nHdlLock)
FErase(cArqLock)

Return()