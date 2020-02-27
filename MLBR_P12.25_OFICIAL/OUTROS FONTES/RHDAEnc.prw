#Include "Protheus.ch"
#Include "rwmake.ch"
#include "ap5mail.ch"   
#Include "TOPCONN.CH"
#include "tbiconn.ch"
/*---------------------------------------------------------
Função: RHDAEnc()        |Autor: AOliveira  |Data: 21-04-11
-----------------------------------------------------------
Descr.:
---------------------------------------------------------*/
User Function RHDAEnc(_cEmpAtu,_cFilAtu)                

Local _aTabela 	 	:= {'SZY'}
Local cQry 		 	:= ""
Local _aNumCha	 	:= {}           
Local _aDados	 	:= {}
Local cEnt		 	:= CHR(13)+CHR(10)     
Local nTipoEmail 	:= 1
Local cArqCham   	:= ""
Local cPathSystem	:= GetSrvProfString('Startpath','')+"RHDAEnc\"
Local n

Local nNrCham, dDTCham, dHRCham, cStatus, cNomeSol, cSetor, cEmp, cUnidade, cTel, cRamal, cTipo, cModulo, cMotivo, cDescProb

Default _cEmpAtu := '01'
Default _cFilAtu := '01'     

//Return()

RpcSetType(3) 
RpcSetEnv('01','01', "","","","",_aTabela )        
                                                               
Conout("---                     INICIO                   ---")
Conout("--- Rotina de Encerramento Automatico de Chamado ---")

/* Criando parametro do programa */
//EP_QTDDABE
DbSelectArea("SX6")
DbSetorder(1)
DbgoTop()
Dbseek(xFilial()+"EP_QTDDABE")
If !Found()
	Reclock("SX6",.T.)
	SX6->X6_FIL:=xFilial()
	SX6->X6_VAR:="EP_QTDDABE"
	SX6->X6_TIPO:="C"           
	SX6->X6_DESCRIC:="AVISO - Qtd de Dias Chamado Aberto"
	SX6->X6_CONTEUD := "15"
	MsUnlock()
Endif
     
//EP_QTDDENC
DbSelectArea("SX6")
DbSetorder(1)
DbgoTop()
Dbseek(xFilial()+"EP_QTDDENC")
If !Found()
	Reclock("SX6",.T.)
	SX6->X6_FIL:=xFilial()
	SX6->X6_VAR:="EP_QTDDENC"
	SX6->X6_TIPO:="C"      
	SX6->X6_DESCRIC:="ENCERRA - Qtd de Dias p/ Encerrar Encerrar"
	SX6->X6_CONTEUD := "4"	
	MsUnlock()
Endif                                                   
/*-------------------------------------------------------*/

_QtdDAberto := SuperGetMv( "EP_QTDDABE" , .F. , "15" ,  ) //'30' //Verifica se a DT de Lib. p/ tst é maior que 30 dias ou conforme MV_
_QtdDEncera := SuperGetMv( "EP_QTDDENC" , .F. , "4" ,  ) //'4'

Conout("Inicio") 
Conout("Verificacao de Chamados em Abertos") 

cQry := ""
cQry += " SELECT CONVERT(VARCHAR(30),GetDate(),112) AS DTATUAL, "+ cEnt //Exibe Data atual no formato AAAAMMDD 
cQry += "        DATEDIFF(DAY,ZY_DTATST,GetDate()) AS QTDDLTST, "+ cEnt //Calcula Qtd de dias entre DT atual e DT Lib. TST
cQry += "        CASE WHEN ZY_VALIDA = '1' THEN DATEDIFF(DAY,ZY_DTINTS,GetDate()) ELSE ' ' END AS QTDDITST, "+ cEnt //Calcula Qtd de dias entre DT Atual e DT In. TST
cQry += "        *  "+ cEnt
cQry += " FROM "+RetSqlName("SZY") +" "+ cEnt
cQry += " WHERE ZY_STATUS IN ('6','7')  "+ cEnt
cQry += " AND ZY_DTAVAL = ''  "+ cEnt
cQry += " AND DATEDIFF(DAY,ZY_DTATST,GetDate()) > "+_QtdDAberto+"  "+ cEnt //Verifica se a DT de Lib. p/ tst é maior que 30 dias ou conforme MV_
cQry += " AND D_E_L_E_T_ = ''  "+ cEnt
cQry += " ORDER BY ZY_NUMCHA "+ cEnt

TCQuery cQry Alias TRB New 

DbSelectArea("TRB")   
TRB->(DbGotop())
While TRB->(!Eof())

	If Empty(TRB->ZY_DTINTS)
		AADD(_aNumCha,TRB->ZY_NUMCHA)
		
	ElseIf TRB->QTDDITST > Val(_QtdDAberto)
		AADD(_aNumCha,TRB->ZY_NUMCHA)	
		
	EndIf
	TRB->(DbSkip())
EndDo


If Len(_aNumcha) > 0
	For n:=1 To Len(_aNumcha)
		
		cArqCham := cPathSystem + _aNumcha[n] + ".AEC"
		
		DbSelectArea("SZY")
		SZY->(DbSetOrder(1)) //ZY_FILIAL+ZY_NUMCHA
		SZY->(DbSeek(xFilial("SZY")+_aNumcha[n]))
		
		_aDados:={SZY->ZY_NUMCHA,; 	//01 - nNrCham		:= SZY->ZY_NUMCHA
		SZY->ZY_DTABERT,;		//02 - dDTCham  	:= SZY->ZY_DTABERT
		SZY->ZY_HORINI,;		//03 - dHRCham  	:= SZY->ZY_HORINI
		SZY->ZY_STATUS,;		//04 - cStatus  	:= SZY->ZY_STATUS //1=Em Aberto;2=Encerrado;3=Alocar Rec.;4=Rec.Alocado;5=Em Analise;6=Lib.p/ Teste;7=Em Teste;8=Chamado Microsiga;9=Validado
		SZY->ZY_NOMUSR,;		//05 - cNomeSol  	:= SZY->ZY_NOMUSR
		SZY->ZY_USRDEP,;		//06 - cSetor  	:= SZY->ZY_USRDEP
		SZY->ZY_NOMFIL,;		//07 - cEmp  		:= SZY->ZY_NOMFIL
		SZY->ZY_NOMFIL,;		//08 - cUnidade  	:= SZY->ZY_NOMFIL
		SZY->ZY_NROTEL,;		//09 - cTel  		:= SZY->ZY_NROTEL
		SZY->ZY_RAMAL,;			//10 - cRamal  	:= SZY->ZY_RAMAL
		SZY->ZY_TIPOCHM,;		//11 - cTipo  		:= SZY->ZY_TIPOCHM //1=Hardware;2=Software;3=Infraestrutura;4=ERP Protheus;5=Outros
		SZY->ZY_DESMOD,;		//12 - cModulo  	:= SZY->ZY_DESMOD
		SZY->ZY_MOTCHA,;		//13 - cMotivo  	:= SZY->ZY_MOTCHA //1=Duvida;2=Nao Conformidade;3=Melhoria;4=Treinamento;5=Instalacao;6=Manutencao;7=Outros
		SZY->ZY_DESCHA,;		//14 - cDescProb  	:= SZY->ZY_DESCHA
		SZY->ZY_EMALOC,;		//15 - Responsavel TI
		SZY->ZY_USRMAI,;		//16 - EMAIL USUARIO
		SZY->ZY_ANAMAI}			//17 - EMAIL ANALISTA
		
		If File(cArqCham)
			FT_FUSE(cArqCham)
			FT_FGOTOP()
			cBuffer := FT_FREADLN()
			
			//If CtoD(cBuffer) > Date()+ Val(_QtdDEncera)
			If Date() - CtoD(cBuffer) > Val(_QtdDEncera)
				FT_FUSE()
				nTipoEmail:= 2
				If Grv_Dados(_aDados[1])
					Aviso_Encer(_aDados,nTipoEmail)
					Ferase(cArqCham)
				EndIf
			Else
				FT_FUSE()
				//Loop
				//Ferase(cArqCham)
			EndIf
			
		Else
			//Cria arq.
			hnda:=Fcreate(cArqCham,0)
			Fwrite(hnda,DtoC(Date()))
			Fclose(hnda)
			FClose(cArqCham)
			nTipoEmail:= 1
			Aviso_Encer(_aDados,nTipoEmail)
		EndIf
		
	Next
	
	//nTipoEmail:= 2
	//Aviso_Encer(_aDados,nTipoEmail)
	//Grv_Dados(_aDados[1])
	//Alert("Existe Chamados em Abertos")
EndIf   


           
TRB->(DbCloseArea())                 
                        
Conout("---                      FIM                    ---")
Conout("---------------------------------------------------")
Return()

//
/*---------------------------------------------------------
Funcao: Grv_Dados() | Autor:AOliveira |Data: 01-08-2011
-----------------------------------------------------------
Descr.: Rotina tem como Objtivo realizar VALIDACAO
        Automatica de Chamados.
---------------------------------------------------------*/
Static Function Grv_Dados(cNumCha)
Local lRet := .F.                 

DbSelectArea("SZY")
SZY->(DbSetOrder(1)) //ZY_FILIAL+ZY_NUMCHA
SZY->(DbGoTop())
If SZY->(DbSeek(xFilial("SZY")+cNumCha))
	RecLock("SZY",.F.)
	SZY->ZY_STATUS 	:= "2"
	SZY->ZY_DESCSO  := "*** VALIDACAO Automatica, por falta de FEEDBACK do usuario ***"+CHR(13)+CHR(10)+SZY->ZY_DESCSO
	SZY->ZY_DTPRTE	:= Date()
	SZY->ZY_ANALAC	:= "4"
	SZY->ZY_DTACAN	:= Date()
	SZY->ZY_DTATST	:= Date()
	SZY->ZY_OBSTST	:= "*** VALIDACAO Automatica, por falta de FEEDBACK do usuario ***"+CHR(13)+CHR(10)+SZY->ZY_OBSTST
	SZY->ZY_VALIDA	:= "2"
	SZY->ZY_DTAVAL	:= Date()
	SZY->(MsUnLock())
	lRet:= .T.
EndIf

Return (lRet)

///
/*---------------------------------------------------------
Funcao: Aviso_Encer() | Autor:AOliveira |Data: 01-08-2011
-----------------------------------------------------------
Descr.: Envia E-mail
---------------------------------------------------------*/
Static Function Aviso_Encer(_aDados,nTipoEmail)
                        
Local aAreaBKP     := GetArea()   
Local aParam := { "01", "00" }  
Local oHTML        := Nil  
Local cDirHTMLs    := GetMv("MV_XHTMDIR",,"\workflow\")
Local nRecSM0      := SM0->(RecNo()) 
Local cEmails      := ""

If nTipoEmail == 1
	cEmails := Alltrim(_aDados[15]+";"+_aDados[16])//15 - Responsavel TI  //16 - EMAIL USUARIO  //17 - EMAIL ANALISTA
Else
	cEmails := Alltrim(_aDados[15]+";"+_aDados[16]+";"+_aDados[17])
EndIf

//cEmails      := "aoliveira@taggs.com.br"

Private oProcess   := Nil 

//Monta HTML.
//-----------------------------------------------
oProcess:= TWFProcess():New( "000001", IIf(nTipoEmail == 1,"Aviso de Encerramento","Encerramento") + " do Chamado: " + Alltrim(_aDados[01]) )
oProcess:NewTask(IIf(nTipoEmail == 1,"Aviso de Encerramento","Encerramento") + " do Chamado: " + Alltrim(_aDados[01]), cDirHTMLs + IIf(nTipoEmail == 1,"AvisoHD.HTM","EncHD.HTM" ))
oProcess:cSubject 	:= IIf(nTipoEmail == 1,"Aviso de Encerramento","Encerramento") + " do Chamado: " + Alltrim(_aDados[01])
oProcess:cTo      	:= cEmails
oHtml 				:= oProcess:oHTML

//Dados Aviso Encerramento                               
                
oHtml:ValByName("nNrCham"	,_aDados[01])
oHtml:ValByName("dDTCham"  	,_aDados[02])
oHtml:ValByName("dHRCham"  	,_aDados[03])
oHtml:ValByName("cStatus"	,RetDados(_aDados[04],"cStatus") ) //1=Em Aberto;2=Encerrado;3=Alocar Rec.;4=Rec.Alocado;5=Em Analise;6=Lib.p/ Teste;7=Em Teste;8=Chamado Microsiga;9=Validado
oHtml:ValByName("cNomeSol"	,_aDados[05])
oHtml:ValByName("cSetor"	,_aDados[06])
oHtml:ValByName("cEmp"		,RetDados(_aDados[07],"cEmp") ) 
oHtml:ValByName("cUnidade"	,RetDados(_aDados[08],"cUnidade") ) 
oHtml:ValByName("cTel"		,_aDados[09])
oHtml:ValByName("cRamal"	,_aDados[10])
oHtml:ValByName("cTipo"		,RetDados(_aDados[11],"cTipo") ) //1=Hardware;2=Software;3=Infraestrutura;4=ERP Protheus;5=Outros
oHtml:ValByName("cModulo"	,_aDados[12])
oHtml:ValByName("cMotivo"	,RetDados(_aDados[13],"cMotivo") ) //1=Duvida;2=Nao Conformidade;3=Melhoria;4=Treinamento;5=Instalacao;6=Manutencao;7=Outros
oHtml:ValByName("cDescProb"	,_aDados[14])

//Encerra o HTML, dispara o email e finaliza o processo.
oProcess:UserSiga := "000000"
oProcess:oHtml    := oHtml
oProcess:Start()
oProcess:Finish()

WFSENDMAIL(aParam)

SM0->(dbGoTo(nRecSM0))

RestArea(aAreaBKP)

Return()

Return(Nil)

/*---------------------------------------------------------
Funcao: RetDados()  |Autor: AOliveira  |Data: 01-08-2011
-----------------------------------------------------------
Uso:
---------------------------------------------------------*/
Static Function RetDados(_cDado,_cVar)
Local cRet := ""

if Alltrim(_cVar) == 'cStatus'
	Do Case
		Case _cDado == '1'
			cRet := "Em Aberto"
		Case _cDado == '2'
			cRet := "Encerrado"
		Case _cDado == '3'
			cRet := "Alocar Rec."
		Case _cDado == '4'
			cRet := "Rec.Alocado"
		Case _cDado == '5'
			cRet := "Em Analise"
		Case _cDado == '6'
			cRet := "Lib.p/ Teste"
		Case _cDado == '7'
			cRet := "Em Teste"
		Case _cDado == '8'
			cRet := "Chamado Totvs"
		Case _cDado == '9'
			cRet := "Validado"
		OtherWise
			cRet := ""
	EndCase
ElseIf Alltrim(_cVar) == 'cTipo'
	Do Case
		Case _cDado == '1'
			cRet := "Hardware"
		Case _cDado == '2'
			cRet := "Software"
		Case _cDado == '3'
			cRet := "Infraestrutura"
		Case _cDado == '4'
			cRet := "ERP Protheus"
		Case _cDado == '5'
			cRet := "Outros"
		OtherWise
			cRet := ""
	EndCase
ElseIf Alltrim(_cVar) == 'cMotivo'
	Do Case
		Case _cDado == '1'
			cRet := "Duvida"
		Case _cDado == '2'
			cRet := "Nao Conformidade"
		Case _cDado == '3'
			cRet := "Melhoria"
		Case _cDado == '4'
			cRet := "Treinamento"
		Case _cDado == '5'
			cRet := "Instalacao"
		Case _cDado == '6'
			cRet := "Manutencao"
		Case _cDado == '7'
			cRet := "Outros"
		OtherWise
			cRet := ""
	EndCase            
	
ElseIf Alltrim(_cVar) == 'cEmp'
	_nPosIni := At("/",Alltrim(_cDado))
	_nPosFim := At("|",Alltrim(_cDado))
	cRet := Alltrim(SubStr(_cDado,_nPosIni + 1,(_nPosFim-1 ) -_nPosIni))
ElseIf Alltrim(_cVar) == 'cUnidade'
	_nPosIni := At("|",Alltrim(_cDado))
	cRet := Alltrim(SubStr(_cDado,_nPosIni + 1,Len(_cDado)))
	
EndIf

Conout("---                      FIM                     ---")
Conout("--- Rotina de Encerramento Automatico de Chamado ---")

Return(cRet)