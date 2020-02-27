#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MACTBPCC º Autor ³ Sandro Albuquerque º Data ³  01/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retornar o valor dos titulos de PCC no momento da conta-   º±±
±±º          ³ bilizacao do movimento de compras conforme cliente.		  º±±
±±º          ³ 															  º±±
±±º          ³ MACTBPCC => Funcao para retornar o valor do PCC	          º±±
±±º          ³  cTitPai => Titulo de busca do Compras - Contas a Pagar    º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º   Uso    ³ PROTHEUS 10 - Midori                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±            
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//
//
User Function MACTBPCC(cFornec,cPrefixo,cNum,cVal)
// Variavel cVal é indicação do tipo do imposto a ser somado na variavel _nValImp
// cVal = 'PCC'grava somente PIS/COFINS/CSLL
// cVal = 'ALL'grava PIS/COFINS/CSLL/IRRF/INSS/ISS
// cVal = 'VENC'  Traz a dta de vencimento dos titulos de impostos retidos

Local _nValImp 	:= 0
Local _Ret 		
Local aAreaAnt 	:= GetArea()
//Verifica se query esta aberta
If Select("TITPAI") > 0
	DBSelectArea("TITPAI")
	("TITPAI")->(DBCloseArea()) //e a fecha para evitar uso com a query aberta
	
EndIf
/*
// E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM
*/

_cQuery := " SELECT  SE2.E2_PREFIXO,  SE2.E2_NUM,  SE2.E2_PARCELA,  SE2.E2_TIPO,  SE2.E2_VENCREA, SE2.E2_FORNECE,  SE2.E2_LOJA,  SE2.E2_TITPAI,  SE2.E2_NATUREZ,  SE2.E2_VALOR, SE2.E2_TITPAI"
_cQuery += "  FROM "
_cQuery += RetSqlName("SE2") + " SE2 "
_cQuery += "  WHERE	 SE2.E2_FILIAL   =  ' '  AND "
_cQuery += "  		 SE2.E2_TIPO     =  'TX' AND "
_cQuery += "  		 SE2.E2_NUM      =  '" + cNum     + "'  AND "
_cQuery += "  		 SE2.E2_PREFIXO  =  '" + cPrefixo + "'  AND "
_cQuery += "  		 SE2.E2_TITPAI LIKE '%" + cFornec + "%' AND "
_cQuery += "  		 SE2.E2_TITPAI LIKE '%" + cNum    + "%' AND "
_cQuery += "         SE2.D_E_L_E_T_   = ' '"
_cQuery += "	 ORDER BY  SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO,   SE2.E2_VENCREA, SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_TITPAI, SE2.E2_NATUREZ "

memowrit("C:\Temp\mactbpcc.sql",_cQuery)//monta query de sql

_cQuery    := ChangeQuery(_cQuery)
cAliasQry  := "TITPAI"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TITPAI",.F.,.T.)

IncProc("Selecionando registros...")

DbselectArea("TITPAI")

IF !TITPAI->( Eof() )
	While !TITPAI->( Eof() )
		
		IF Alltrim(cVal) $ "ALL/PCC/VENC"
			
			IF Alltrim(TITPAI->E2_NATUREZ) $ "PIS/COFINS/CSLL"
				
				IF Alltrim(cVal) $ "ALL/PCC"
					_nValImp += TITPAI->E2_VALOR
					
				Endif          
				
				// Grava flag de contabilização na tabela
				dBSelectArea("SE2")
				dBSetOrder(1)
				
				dBSeek(xFilial("SE2")+TITPAI->(E2_PREFIXO+ E2_NUM+ E2_PARCELA+ E2_TIPO+ E2_FORNECE+ E2_LOJA))
				
				IF !Eof() .and. Alltrim(cVal) $ "ALL/PCC"
					RecLock("SE2",.F.)
					IF Alltrim(SE2->E2_NATUREZ) $ "PIS/COFINS/CSLL"
						SE2->E2_LA := "S"
						
					Endif
					MsUnLock()
					
				Elseif Alltrim(cVal) $ "VENC"  // Retorna a data de vencimento real do titulo de imposto retido.
					IF Alltrim(SE2->E2_NATUREZ) $ "PIS/COFINS/CSLL"
					    _dia := Substr(TITPAI->E2_VENCREA,7,2)
					    _mes := "/"+Substr(TITPAI->E2_VENCREA,5,2)
					    _ano := "/"+Substr(TITPAI->E2_VENCREA,3,2)
						_Ret := "V."+_dia+_mes+_ano
						Exit // Preenche a data e sai do laço.
						
					Endif
					SE2->(DbSkip())
					
				EndiF // SE2
				
			Endif
		Endif
		TITPAI->(DBSKIP())
		
	EndDO
	
Endif

IF Alltrim(cVal) $ "ALL/PCC"
	// Se A2_RECISS for igual a N - Deve ser retido pela Midori.
	_nValImp += IIF( Alltrim(cVal) $ "ALL/ISS" ,IF(Alltrim(SF1->F1_RECISS) == "2", SF1->F1_ISS,  0), 0)
	_nValImp += IIF( Alltrim(cVal) $ "ALL/INS" ,SF1->F1_INSS   ,0 )
	_nValImp += IIF( Alltrim(cVal) $ "ALL/IRF" ,SF1->F1_VALIRF ,0 )
	_Ret :=_nValImp    // Retorna valor conforme parametro. 
	
Endif

RestArea(aAreaAnt)
Return(_Ret) // Retorna o valor ou data de vencimento dos impostos retidos. 



///////////////////////////////////////////////////////////////////////////////////////////////
//FUNCAO PARA ADICIONAR A DATA NO HISTORICO DA CONTABILIZACAO DO PCC
//DESENVOLVIDA POR ANESIO EM 07/08/2013
///////////////////////////////////////////////////////////////////////////////////////////////
User Function AGHISCC(cFornec,cPrefixo,cNum)
// Variavel cVal é indicação do tipo do imposto a ser somado na variavel _nValImp
// cVal = 'PCC'grava somente PIS/COFINS/CSLL
// cVal = 'ALL'grava PIS/COFINS/CSLL/IRRF/INSS/ISS
// cVal = 'VENC'  Traz a dta de vencimento dos titulos de impostos retidos
Local _Ret := ""
Local aAreaAnt 	:= GetArea()
//Verifica se query esta aberta
If Select("TITPCC") > 0
	DBSelectArea("TITPCC")
	("TITPCC")->(DBCloseArea()) //e a fecha para evitar uso com a query aberta
	
EndIf

_cQuery := " SELECT  SE2.E2_PREFIXO,  SE2.E2_NUM,  SE2.E2_PARCELA,  SE2.E2_TIPO,  SE2.E2_VENCREA, SE2.E2_FORNECE,  SE2.E2_LOJA,  SE2.E2_TITPAI,  SE2.E2_NATUREZ,  SE2.E2_VALOR, SE2.E2_TITPAI"
_cQuery += "  FROM "
_cQuery += RetSqlName("SE2") + " SE2 "
_cQuery += "  WHERE	 SE2.E2_FILIAL   =  ' '  AND "
_cQuery += "  		 SE2.E2_TIPO     =  'TX' AND "
_cQuery += "  		 SE2.E2_NUM      =  '" + cNum     + "'  AND "
_cQuery += "  		 SE2.E2_PREFIXO  =  '" + cPrefixo + "'  AND "
_cQuery += "  		 SE2.E2_TITPAI LIKE '%" + cFornec + "%' AND "
_cQuery += "  		 SE2.E2_TITPAI LIKE '%" + cNum    + "%' AND "
_cQuery += "         SE2.D_E_L_E_T_   = ' ' "
_cQuery += "	 ORDER BY  SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO,   SE2.E2_VENCREA, SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_TITPAI, SE2.E2_NATUREZ "

memowrit("E:\Query\mactbpcc.sql",_cQuery)//monta query de sql

_cQuery    := ChangeQuery(_cQuery)
cAliasQry  := "TITPCC"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TITPCC",.F.,.T.)

IncProc("Selecionando registros...")

DbselectArea("TITPCC")
	While !TITPCC->(eof())
		IF Alltrim(TITPCC->E2_NATUREZ) $ "PIS/COFINS/CSLL/5952"
		    	_dia := Substr(TITPCC->E2_VENCREA,7,2)
		    	_mes := "/"+Substr(TITPCC->E2_VENCREA,5,2)
		    	_ano := "/"+Substr(TITPCC->E2_VENCREA,3,2)
				_Ret := "V."+_dia+_mes+_ano+U_MACTLHIS("", "530")
			Exit // Preenche a data e sai do laço.
		Endif
		TITPCC->(dbSkip())
	enddo



if Substr(_Ret,1,1) <> 'V'
	If Select("TITPCC") > 0
		DBSelectArea("TITPCC")
		("TITPCC")->(DBCloseArea()) //e a fecha para evitar uso com a query aberta
		
	EndIf
	
	_cQuery := " SELECT   SE2.E2_VENCREA, SE2.E2_FORNECE,  SE2.E2_LOJA "
	_cQuery += "  FROM "
	_cQuery += RetSqlName("SE2") + " SE2 "
	_cQuery += "  WHERE	 SE2.E2_FILIAL   =  ' '  AND "
	_cQuery += "  		 SE2.E2_TIPO     <>  'TX' AND "
	_cQuery += "  		 SE2.E2_NUM      =  '" + cNum     + "'  AND "
	_cQuery += "  		 SE2.E2_PREFIXO  =  '" + cPrefixo + "'  AND "
	_cQuery += "  		 SE2.E2_FORNECE  =  '" + cFornec + "' AND "
	_cQuery += "         SE2.D_E_L_E_T_   = ' ' "
	_cQuery += "	 ORDER BY  SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO,   SE2.E2_VENCREA, SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_TITPAI, SE2.E2_NATUREZ "
	
	memowrit("E:\Query\mactbpcc.sql",_cQuery)//monta query de sql
	
	_cQuery    := ChangeQuery(_cQuery)
	cAliasQry  := "TITPCC"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TITPCC",.F.,.T.)
	dbSelectArea("TITPCC")
    	_dia := Substr(TITPCC->E2_VENCREA,7,2)
    	_mes := "/"+Substr(TITPCC->E2_VENCREA,5,2)
    	_ano := "/"+Substr(TITPCC->E2_VENCREA,3,2)

       if _dia > '15'
       		nMes := val(substr(_mes,2,2))+1
       		_mes := "/"+strzero(nMes,2)
       endif
    	
       if _dia >='01' .and. _dia <='15'
       		_dia := '30'
       else
          _dia := '15'
       endif
       
		_Ret := "V."+_dia+_mes+_ano+U_MACTLHIS("", "530")

endif

if len(_Ret) > 40
	_Ret := Substr(_Ret,1,40)
endif


RestArea(aAreaAnt)
return (_Ret)
