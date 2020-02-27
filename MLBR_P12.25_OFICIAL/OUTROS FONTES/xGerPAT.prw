#INCLUDE 'FILEIO.CH'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"   
#Include "TOPCONN.CH"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "GPEXCALC.CH"

/*---------------------------------------------------------
Funcao:                |Autor: AOliveira |Data:24-08-11
-----------------------------------------------------------
Desc.:  Funcao tem como objetivo realizar criacao de 
        arquivo de envio da Ticket "PAT"
-----------------------------------------------------------
Tab´s: 
---------------------------------------------------------*/
User Function xGerPAT()

Local aSays := {}
Local aButtons := {}
Local nOpca := 0
Private cTitulo := OemToAnsi("Geracao de Arquivo de Remessa PAT - Ticket")
Private cArq :=""

aAdd(aSays,OemToAnsi("Este programa tem como objetivo relaizar a geração de arquivo de    "))
aAdd(aSays,OemToAnsi("remessa para Pedido de PAT - Ticket.                                "))
aAdd(aSays,OemToAnsi("Conforme parametros informados pelo usuário.                        "))
aAdd(aSays,OemToAnsi("                                                                    "))
aAdd(aSays,OemToAnsi("                                                                    "))
aAdd(aSays,OemToAnsi("                                                                    "))
aAdd(aButtons, { 5, .T., {|o| Parametro() } } )           //Parâmetros para execussão da Rotina.
aAdd(aButtons, { 1, .T., {|o| nOpca := 1, IF(gpconfOK() .And. ValidPAR(), FechaBatch(), nOpca:=0) }} ) //Se selecionar botao Ok fecha tela de entrada.
aAdd(aButtons, { 2, .T., {|o| FechaBatch() }} ) //Se selecionado botao Cancelar, fecha tela de entrada e retorna ao sistema.

FormBatch(cTitulo,aSays,aButtons) //Exibe Tela de entrada

IF ( nOpca == 1 )
	Processa({|lEnd| xGerArq(), "Por favor aguarde..."}) //Antes: ProcessHE(.T., .T.) //Chamada a rotina de processamento de contabilizacao
	//Alert("Em Desenvolvimento...")
EndIF


Return()

/*Validaçã/Verificação de parametros*/
Static Function ValidPAR()
Local lRet := .T.

Do Case
	Case Valtype(MV_PAR01) <> "C"
		lRet := .F. 
	Case Valtype(MV_PAR02) <> "C"
		lRet := .F.
	Case Valtype(MV_PAR03) <> "C"
		lRet := .F.
	Case Valtype(MV_PAR04) <> "C"
		lRet := .F.
	Case Valtype(MV_PAR05) <> "D"
		lRet := .F.				
	//Case Valtype(MV_PAR06) <> "D"
	//	lRet := .F.
	//Case Valtype(MV_PAR07) <> "D"
	//	lRet := .F.
	//Case Valtype(MV_PAR08) <> "C"
	//	lRet := .F.										
EndCase 

If !lRet
	Alert("Verifique os parametros informados!")
EndIf

Return(lRet)
//
                
/*---------------------------------------------------------
Funcao: Parametro()  |Autor: AOliveira     |Data:24-08-2011
-----------------------------------------------------------
Uso: xGerPat ()
---------------------------------------------------------*/
Static Function Parametro()      
Local _aAreaSM0 := SM0->(GetArea())
Local aMes := {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
Local aFilial := {}
Local i := 0         
Local aParamBox := {}
Local aRet := {}

Private cCadastro := "Parametros"                        

DbSelectArea("SM0")
SM0->(DbGotop())
While SM0->(!Eof()) .And. SM0->M0_CODIGO == cEmpAnt
	AAdd(aFilial,Alltrim(SM0->M0_CODFIL+" - "+SM0->M0_FILIAL) )       
	SM0->(DbSkip())
EndDo                                                           
RestArea(_aAreaSM0)

AADD(aParamBox,{2,"Mês de Referência",aMes[1],aMes,50,"",.F.})
AADD(aParamBox,{2,"Filial de Entrega",aFilial[1],aFilial,100,"",.F.})
AADD(aParamBox,{1,"Resp. Recebimento",Space(20),"@!","","","",0,.T.})    
AADD(aParamBox,{6,"Diretório",padr("",150),"",,"", 90 ,.T.,"","",GETF_NETWORKDRIVE + GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_RETDIRECTORY})
AADD(aParamBox,{1,"DT. Liberação",dDataBase,"@D","","","",60,.T.}) 
//AADD(aParamBox,{1,"DT.Inicio do Perido",dDataBase,"@D","","","",60,.T.}) 
//AADD(aParamBox,{1,"DT.Final do Periodo",dDataBase,"@D","","","",60,.T.}) 
//AADD(aParamBox,{1,"Qtd. de Ticket p/ Periodo",Space(2),"@E 99","","","",60,.T.}) 

If ParamBox(aParamBox,"Geracao de Arquivo de Remessa PAT - Ticket",@aRet,,,,,,,,.T.,.T.) 

Endif 

Return(aRet)

/*---------------------------------------------------------
Funcao: xGerArq()    |Autor: AOliveira     |Data:24-08-2011
-----------------------------------------------------------
Desc.:  Geração do arquivo
-----------------------------------------------------------
Retorno: 
---------------------------------------------------------*/
Static Function xGerArq()

Local _cNArq := Upper(Alltrim(MV_PAR04)+"\TRE - "+Alltrim(Upper(MV_PAR02))+" - "+Alltrim((cMes:=xMes())+Alltrim(Str(Year(MV_PAR05)))) +".TXT")
//                 Alltrim((cMes:=xMes())+Alltrim(Str(Year(MV_PAR05))))
Public __SEQ := 1             
Public __TTFunc := 0
Public __VlrTot := 0

hnda:=Fcreate(_cNArq,0) 
Fclose(hnda)
FClose(_cNArq)

xHPedido(_cNArq)   					//Registro HEADER DO ARQUIVO DE PEDIDO
xTreHD(_cNArq)     					//TRE - REGISTRO HEADER    
xTRERUENT(_cNArq)  					//TRE - REGISTRO DE UNIDADES DE ENTREGA
If nOpcA:= xTRERFunc(_cNArq) <> 1 	//TRE - REGISTRO DE FUNCIONARIOS
	Return()
EndIf
xTRERTrai(_cNArq)  					//TRE - REGISTRO TRAILLER
xTRAILPed(_cNArq)  					//Registro TRAILLER DO ARQUIVO DE PEDIDO             

Return()


/*---------------------------------------------------------
Funcao: xHPedido()    |Autor: AOliveira     |Data:24-08-2011
-----------------------------------------------------------
Desc.:  Registro HEADER DO ARQUIVO DE PEDIDO
-----------------------------------------------------------
Retorno: 
---------------------------------------------------------*/
Static Function xHPedido(_cNArq)      
Local _cTPReg :="LSUP5" 			    //Tam= 05 ---Tipo de Registro
Local _cUser  :=__cUserID               //Tam= 08 ---Usario do Sistema
Local _cRsv01 :=Space(11)			    //Tam= 11 ---Reservado
Local _cDTPed :=DtoS(Date())            //Tam= 08 ---DT. Geração do Pedido  "AAAAMMDD"
Local _cHrPed :=STRTRAN(time(),':','.') //Tam= 08 ---Hrs. Geração do Pedido
Local _cRsv02 :="LAYOUT-05/05/2008"	    //Tam= 17 ---Reservado
Local _cRsv03 :=Space(106) 			    //Tam= 106 --Espaço Reservado

Local _GrvArq  := ""                                                                         
Local _aTam    := {5,8,11,8,8,17,106}
Local _aGrvArq := {_cTPReg,_cUser,_cRsv01,_cDTPed,_cHrPed,_cRsv02,_cRsv03}
Local x

For x:= 1 To Len (_aTam)
	_GrvArq += If(Len(Alltrim(_aGrvArq[x])) == _aTam[x] ,Alltrim(_aGrvArq[x]),Alltrim(_aGrvArq[x])+Space(_aTam[x] - Len(Alltrim(_aGrvArq[x]) ) ) )
Next

_GrvArq += Chr(13)+Chr(10)
                 
hnda:= Fopen(_cNArq , FO_READWRITE + FO_SHARED )
If hnda == -1
	MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
Else
	FSeek(hnda, 0, FS_END)
	Fwrite(hnda,_GrvArq)
	Fclose(hnda)
	FClose(_cNArq)
EndIf

Return() 

/*---------------------------------------------------------
Funcao: xTreHD()    |Autor: AOliveira     |Data:24-08-2011
-----------------------------------------------------------
Desc.:  TRE - REGISTRO HEADER
-----------------------------------------------------------
Retorno: 
---------------------------------------------------------*/
Static Function xTreHD(_cNArq)
Local cTPProd := "T" 								//Tam= 001 --- Tipo de Produto / Sequencia
Local cProd   := "R" 								//Tam= 001 --- Produto
Local cFixo   := "02" 								//Tam= 002 --- Fixo
Local cTPReg  := "0" 								//Tam= 001 --- TP Registro
Local cProd2  := "R" 								//Tam= 001 --- Produto
Local cContr  := StrZero(59250020,10)//"999999999" 	//Tam= 009 --- Cod. Contrato Ticket   //Cod. de Cliente informado pela Sr Fatima 86263
Local cNEmp   := Alltrim(SubStr(SM0->M0_NOME,1,24))	//Tam= 0024 -- Nome da Empresa 
Local cRsv01  := Space(6) 							//Tam= 006 --- Reservado
Local cDTPed  := DtoS(Date()) 						//Tam= 008 --- DT Pedido
Local cDTLib  := DtoS(MV_PAR05)//DtoS(Date())		//Tam= 008 --- DT Lib do Beneficio
Local cTPPed  := "C"								//Tam= 001 --- Tipo Pedido
Local cRsv02  := Space(16)							//Tam= 016 --- reservado
Local cMesRef := xMes()								//Tam= 002 --- Mes de Referencia
Local cRsv03  := Space(19)							//Tam= 019 --- Reservado   
Local cTPLay  := "04"								//Tam= 002 --- Tipo do Layout
Local cTPCart := "34"								//Tam= 002 --- Tipo do Cartão (33= TAE | 34= TRE)
Local cRsv04  := Space(48)							//Tam= 048 --- Reservado
Local cOrig   := "SUP"+Space(3)						//Tam= 006 --- Origem
Local cSeq	  := StrZero(__SEQ,6)					//Tam= 006 --- Sequencia

Local _GrvArq  := ""                                                                         
Local _aTam    := {1,1,2,1,1,10,24,6,8,8,1,16,2,19,2,2,48,6,6}
Local _aGrvArq := {cTPProd,cProd,cFixo,cTPReg,cProd2,cContr,cNEmp,cRsv01,cDTPed,cDTLib,cTPPed, ;
                   cRsv02,cMesRef,cRsv03,cTPLay,cTPCart,cRsv04,cOrig,cSeq}
                   
Local x                 

For x:= 1 To Len (_aTam)
	_GrvArq += If(Len(Alltrim(_aGrvArq[x])) == _aTam[x] ,Alltrim(_aGrvArq[x]),Alltrim(_aGrvArq[x])+Space(_aTam[x] - Len(Alltrim(_aGrvArq[x]) ) ) )
Next

_GrvArq += Chr(13)+Chr(10)

hnda:= Fopen(_cNArq , FO_READWRITE + FO_SHARED )                  

If hnda == -1
	MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
Else
	FSeek(hnda, 0, FS_END)
	Fwrite(hnda,_GrvArq)
	Fclose(hnda)
	FClose(_cNArq)
EndIf

__SEQ := __SEQ + 1                                 

Return()
  
/*---------------------------------------------------------
Funcao: xTRERUENT()  |Autor: AOliveira    |Data: 29-08-2011
-----------------------------------------------------------
Descr.: TRE - REGISTRO DE UNIDADES DE ENTREGA
-----------------------------------------------------------
Uso:
---------------------------------------------------------*/
Static Function xTRERUENT(_cNArq)
Local cTPProd  := "T"	  						//Tam= 001 ---Tipo Produto/ Sequencia
Local cprod	   := "R"							//Tam= 001 ---Produto
Local cFixo    := "02"							//Tam= 002 ---Fixo
Local cTPReg   := "2"							//Tam= 001 --- Tipo Registro
Local cNUnid   := SubStr(SM0->M0_FILIAL,1,26)	//Tam= 026 ---Nome da Unidade
local cTpLougr := xLougr(1)						//Tam= 004 ---Tipo lougradouro
Local cLougr   := xLougr(2)						//Tam= 030 ---Lougradouro   
Local cNum     := xLougr(3)						//Tam= 006 ---Numero
Local cCompl   := SubStr(SM0->M0_COMPCOB,1,10)	//Tam= 010 ---Complemento
Local cMuni    := SubStr(SM0->M0_CIDCOB,1,25) 	//Tam= 025 ---Municipio
Local cBair    := SubStr(SM0->M0_BAIRCOB,1,15)  //Tam= 015 ---Bairro
Local cCEP     := SubStr(SM0->M0_CEPCOB,1,5)	//Tam= 005 ---CEP
Local cEst     := SubStr(SM0->M0_ESTCOB,1,5) 	//Tam= 002 ---Estado
Local cInter   := SubStr(MV_PAR03,1,20)   		//Tam= 020 ---Reponsavel pelo Recebimento 
Local cCompCEP := SubStr(SM0->M0_CEPCOB,6,3)	//Tam= 003 ---Complemento de CEP
Local cRvd     := Space(7)						//Tam= 007 ---Reservado
Local cSeq     := StrZero(__SEQ,6)      		//Tam= 006 ---Sequencia

Local _GrvArq  := ""                                                                         
Local _aTam    := {1,1,2,1,26,4,30,6,10,25,15,5,2,20,3,7,6}
Local _aGrvArq := {cTPProd,cprod,cFixo,cTPReg,cNUnid,cTpLougr,cLougr,cNum,;
                   cCompl,cMuni,cBair,cCEP,cEst,cInter,cCompCEP,cRvd,cSeq}
                   
Local x                   

For x:= 1 To Len (_aTam)
	_GrvArq += If(Len(Alltrim(_aGrvArq[x])) == _aTam[x] ,Alltrim(_aGrvArq[x]),Alltrim(_aGrvArq[x])+Space(_aTam[x] - Len(Alltrim(_aGrvArq[x]) ) ) )
Next

_GrvArq += Chr(13)+Chr(10)

hnda:= Fopen(_cNArq , FO_READWRITE + FO_SHARED )                  

If hnda == -1
	MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
Else
	FSeek(hnda, 0, FS_END)
	Fwrite(hnda,_GrvArq)
	Fclose(hnda)
	FClose(_cNArq)
EndIf

__SEQ := __SEQ + 1                                 

Return()              

/*---------------------------------------------------------
Funcao: xTRERFunc()  |Autor: AOliveira |Data: 29-08-2011
-----------------------------------------------------------
Descr.: TRE - REGISTRO DE FUNCIONARIOS
-----------------------------------------------------------
Uso:
---------------------------------------------------------*/
Static Function xTRERFunc(_cNArq)  //
Local cTPProd  := "T"						//Tam= 001 ---Tipo Produto/sequencia
Local cProd    := "R"						//Tam= 001 ---Produto
Local cFixo    := "02"						//Tam= 002 ---Fixo
Local cTPReg   := "3"						//Tam= 001 ---Tipo Registro
Local cDep     := ""						//Tam= 026 ---Departamento
Local cMatric  := ""						//Tam= 012 ---Matricula
Local cDTnasc  := ""						//Tam= 008 ---Dt Nasc. Funcionario
Local cRvd     :=Space(18)					//Tam= 018 ---Reservado
Local cNUnid   := SubStr(SM0->M0_FILIAL,1,26)	//Tam= 026 ---Nome da Unidade
Local cFixo2   := "00101"					//Tam= 005 ---Fixo
Local cVlr     := StrZero(0,9)				//Tam= 009 ---Valor (Vlr Unitario do ticket)
Local cProd2   := "R"						//Tam= 001 ---Produto
Local cFixo3   := "E"						//Tam= 001 ---Fixo
Local cNFunc   := ""						//Tam= 023 ---Nome Funcionario
Local cRvd2    := Space(24)					//Tam= 024 ---Reservado
Local cSeq     := StrZero(__SEQ,6)			//Tam= 006 ---Sequencia
Local _GrvArq  := ""                                                                         
Local _aGrvArq := {}
Local _aTam    := {1,1,2,1,26,12,8,18,26,5,9,1,1,23,24,6}
Local cQry	   := ""  
Local cEnt     := Chr(13)+Chr(10)
Local nx, x

Private nVlr := 0                   
Private dDAfast 
Private nVlrTick := xVlrRef()

Private nOpcA


cQry := ""
cQry += " SELECT '  ' AS OK, RA_FILIAL, SUBSTRING(RA_MAT,1,12) AS RA_MAT, "+cEnt 
cQry += "        RA_CIC, RA_NASC,   "+cEnt
cQry += "        SUBSTRING(RA_NOME,1,23) AS RA_NOME, RA_CC,  "+cEnt
cQry += "        SUBSTRING(CTT_DESC01,1,26) AS DEP, "+cEnt
cQry += "        RA_VALEREF, "+cEnt
cQry += "        RA_SITFOLH, "+cEnt
cQry += "        (SELECT RCF_DIATRA FROM  "+ RetSqlName("RCF")+" WHERE RCF_FILIAL = '"+SubStr(MV_PAR02,1,2)+"' AND RCF_MES = '"+(cMes:=xMes())+"' AND RCF_ANO = '"+Alltrim(Str(Year(MV_PAR05)))+"') AS DTRABM," +cEnt
cQry += "        0 AS DEDUZIR, " +cEnt
cQry += "        "+ Alltrim(Str(nVlrTick))+" AS VLRUN," +cEnt
cQry += "        ((SELECT RCF_DIATRA FROM  "+ RetSqlName("RCF")+" WHERE RCF_FILIAL = '"+SubStr(MV_PAR02,1,2)+"' AND RCF_MES = '"+(cMes:=xMes())+"' AND RCF_ANO = '"+Alltrim(Str(Year(MV_PAR05)))+"') * "+ Alltrim(Str(nVlrTick))+") AS VLRTOTAL, " +cEnt
cQry += "        RA_REGRA" +cEnt
cQry += " FROM "+ RetSqlName("SRA")+" , "+RetSqlName("CTT")+" "+cEnt
cQry += " WHERE RA_FILIAL  = '"+SubStr(MV_PAR02,1,2)+"' "+cEnt
cQry += " AND RA_CC = CTT_CUSTO "+cEnt
cQry += " AND RA_SITFOLH NOT IN ('T','D','A')  "+cEnt //demetido(D), Afastado(A) ou Transferido(T)
cQry += " AND RA_X_GERTR = 'S'  "+cEnt   //Campo identificador para geracao do beneficio.
cQry += " AND "+RetSqlName("SRA")+".D_E_L_E_T_ = ' '  "+cEnt
cQry += " AND "+RetSqlName("CTT")+".D_E_L_E_T_ = ' '  "+cEnt
cQry += " ORDER BY RA_NOME "+cEnt

TCQuery cQry Alias TRC New

aStru := TRC->(DbStruct())
cArqTrb := CriaTrab(aStru,.T.)
dbUseArea(.T.,__LOCALDRIVER,cArqTrb,"TRB",.T.,.F.)
SqlToTrb(cQry,aStru,"TRB")

TRC->(DbCloseArea())

//
Processa({||nOpcA:= OpenBrowse()},"Organizando Browse","Aguarde...")

If nOpcA == 1
	
	For nx:= 1 To Len(aDados)
		cSeek:= aDados[nx][1] + aDados[nx][2]
		lAtu := .F.
		DbSelectArea("TRB")
		TRB->(DbGoTop())
		While !TRB->(Eof()) .And. !lAtu
			If TRB->(RA_FILIAL+RA_MAT) == cSeek
				RecLock("TRB",.f.)
				TRB->DTRABM   := aDados[nx][4]
				TRB->DEDUZIR  := aDados[nx][5]
				TRB->VLRUN    := aDados[nx][6]
				TRB->VLRTOTAL := aDados[nx][7]
				TRB->(MsUnLock()) 
				lAtu := .T.
			EndIf
			TRB->(DbSkip())
		EndDo
	Next
	
Else
	TRB->(DbCloseArea())
	Return(nOpcA)
EndIf
//  

DbSelectArea("TRB")   
TRB->(DbGotop())
ProcRegua(LastRec())
While TRB->(!Eof())
        
    IncProc() 
		
	nVlr := (TRB->VLRTOTAL * 100 )
	
	cDTnasc := Alltrim(SubStr(TRB->RA_NASC,7,2)+SubStr(TRB->RA_NASC,5,2)+Substr(TRB->RA_NASC,1,4))//Data "DDMMAAAA"
	
	_aGrvArq := {cTPProd,cProd,cFixo,cTPReg,TRB->DEP,StrZero(Val(TRB->RA_MAT),12),;
	             IIf(Empty(cDTnasc),StrZero(0,8),cDTnasc),;
	             cRvd,cNUnid,cFixo2,StrZero(nVlr,9),cProd2,cFixo3,TRB->RA_NOME,cRvd2,StrZero(__SEQ,6)}
	
	For x:= 1 To Len (_aTam)
		_GrvArq += If(Len(Alltrim(_aGrvArq[x])) == _aTam[x] ,Alltrim(_aGrvArq[x]),Alltrim(_aGrvArq[x])+Space(_aTam[x] - Len(Alltrim(_aGrvArq[x]) ) ) )
	Next
	
	_GrvArq += Chr(13)+Chr(10)
	
	hnda:= Fopen(_cNArq , FO_READWRITE + FO_SHARED )
	
	If hnda == -1
		MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
	Else
		FSeek(hnda, 0, FS_END)
		Fwrite(hnda,_GrvArq)
		Fclose(hnda)
		FClose(_cNArq)     
		_GrvArq:=""
	EndIf
	__TTFunc := __TTFunc + 1
	__VlrTot += nVlr	
	__SEQ := __SEQ + 1
	TRB->(DbSkip())
EndDo

TRB->(DbCloseArea())

Return(nOpcA)


/*---------------------------------------------------------
Funcao: xTRERTrai()  |Autor: AOliveira |Data: 29-08-2011
-----------------------------------------------------------
Descr.: TRE - REGISTRO TRAILLER
-----------------------------------------------------------
Uso:
---------------------------------------------------------*/
Static Function xTRERTrai(_cNArq)
Local cTPprod := "T"					//Tam= 001 ---Tipo produto / Sequencia
Local cProd   := "R"					//Tam= 001 ---produto
Local cFixo   := "02"					//Tam= 002 ---Fixo
Local cTPReg  := "9"					//Tam= 001 ---Tipo de registro
Local cTTFunc := StrZero(__TTFunc,8)	//Tam= 008 ---total de Funcionario
Local cVlrTot := StrZero(__VlrTot,14)	//Tam= 014 ---Valor Total
Local cRvd    := Space(131)				//Tam= 131 ---Reservado
Local cSeq    := StrZero(__SEQ,6)		//Tam= 006 ---Sequencia
Local _GrvArq  := ""                                                                         
Local _aTam    := {1,1,2,1,8,14,131,6}
Local _aGrvArq := {cTPprod,cProd,cFixo,cTPReg,cTTFunc,cVlrTot,cRvd,cSeq}
Local x

For x:= 1 To Len (_aTam)
	_GrvArq += If(Len(Alltrim(_aGrvArq[x])) == _aTam[x] ,Alltrim(_aGrvArq[x]),Alltrim(_aGrvArq[x])+Space(_aTam[x] - Len(Alltrim(_aGrvArq[x]) ) ) )
Next

_GrvArq += Chr(13)+Chr(10)


hnda:= Fopen(_cNArq , FO_READWRITE + FO_SHARED )                  

If hnda == -1
	MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
Else
	FSeek(hnda, 0, FS_END)
	Fwrite(hnda,_GrvArq)
	Fclose(hnda)
	FClose(_cNArq)
EndIf

__SEQ := __SEQ + 1                                 


Return()

/*---------------------------------------------------------
Funcao: xTRAILPed()  |Autor: AOliveira    |Data: 29-08-2011
-----------------------------------------------------------
Descr.: Registro TRAILLER DO ARQUIVO DE PEDIDO
-----------------------------------------------------------
Uso:
---------------------------------------------------------*/
Static Function xTRAILPed(_cNArq)
Local _cTPReg := "LSUP9"       			//Tam= 05 ---Tipo de Registro
Local _cQtdHD :=  StrZero(2,8) 			//Tam= 008 ---Somatorio total dos reg. Heard´s
Local _cQtdTL :=  StrZero(2,8) 			//Tam= 008 ---Somatorio total dos reg. Trailler´s
Local _cQtdReg:=  StrZero(__TTFunc,8) 	//Tam= 008 ---Somatorio total dos reg. do Arq.
Local _cRsv01 :=  Space(134)   			//Tam= 134 ---Branco
Local _GrvArq  := ""                                                                         
Local _aTam    := {5,8,8,8,134}
Local _aGrvArq := {_cTPReg,_cQtdHD,_cQtdTL,_cQtdReg, _cRsv01}
Local x

For x:= 1 To Len (_aTam)
	_GrvArq += If(Len(Alltrim(_aGrvArq[x])) == _aTam[x] ,Alltrim(_aGrvArq[x]),Alltrim(_aGrvArq[x])+Space(_aTam[x] - Len(Alltrim(_aGrvArq[x]) ) ) )
Next

_GrvArq += Chr(13)+Chr(10)

hnda:= Fopen(_cNArq , FO_READWRITE + FO_SHARED )                  

If hnda == -1
	MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
Else
	FSeek(hnda, 0, FS_END)
	Fwrite(hnda,_GrvArq)
	Fclose(hnda)
	FClose(_cNArq)
	Aviso('Atenção!','Arquivo gerado com sucesso...',{'&Continuar'})
EndIf

Return()      

/*---------------------------------------------------------
Funcao: xMes()  |Autor: AOliveira    |Data: 29-08-2011
-----------------------------------------------------------
Descr.: Retorna o numero do Mes
-----------------------------------------------------------
Uso:
---------------------------------------------------------*/ 
Static Function xMes()
Local cRet := ""      
Local cPAR01 := Alltrim(MV_PAR01)



Do Case
	Case cPAR01 == "Janeiro"
		cRet := "01"
	Case cPAR01 == "Fevereiro"
		cRet := "02"
	Case cPAR01 == "Março"
		cRet := "03"
	Case cPAR01 == "Abril"
		cRet := "04"
	Case cPAR01 == "Maio"
		cRet := "05"
	Case cPAR01 == "Junho"
		cRet := "06"
	Case cPAR01 == "Julho"
		cRet := "07"
	Case cPAR01 == "Agosto"
		cRet := "08"
	Case cPAR01 == "Setembro"
		cRet := "09"
	Case cPAR01 == "Outubro"
		cRet := "10"
	Case cPAR01 == "Novembro"
		cRet := "11"
	Case cPAR01 == "Dezembro"
		cRet := "12"
EndCase

Return(cRet)



/*Lougradouro*/
Static Function xLougr(_Ret)
Local cTPLOUGR , cLOUGRAD, cNUMERO, cRet

Do Case
	Case SM0->(M0_CODIGO+M0_CODFIL) == "0101"
		Do Case
			Case _Ret == 1
				cRet := "RUA"
			Case _Ret == 2
				cRet := "DOUTOR MOISES KAUFFMAN"
			Case _Ret == 3
				cRet := "291"
		EndCase
	Case SM0->(M0_CODIGO+M0_CODFIL) == "0102"
		Do Case
			Case _Ret == 1
				cRet := "AV"
			Case _Ret == 2
				cRet := "YOUSSEF I. MANSO"
			Case _Ret == 3
				cRet := "621"
		EndCase
	Case Alltrim(SM0->(M0_CODIGO+M0_CODFIL)) == "0103"
		Do Case
			Case _Ret == 1
				cRet := "V"
			Case _Ret == 2
				cRet := "JOAO CAETANO C. ALME"
			Case _Ret == 3
				cRet := "SN"
		EndCase
	Case Alltrim(SM0->(M0_CODIGO+M0_CODFIL)) == "0104"
		Do Case
			Case _Ret == 1
				cRet := "RUA"
			Case _Ret == 2
				cRet := "SACADURA CABRAL"
			Case _Ret == 3
				cRet := "365"
		EndCase
	Case Alltrim(SM0->(M0_CODIGO+M0_CODFIL)) == "0108"
		Do Case
			Case _Ret == 1
				cRet := "RUA"
			Case _Ret == 2
				cRet := "ANDRELINO VAZ DE ARRUDA"
			Case _Ret == 3
				cRet := "830"
		EndCase
	Case Alltrim(SM0->(M0_CODIGO+M0_CODFIL)) == "0109"
		Do Case
			Case _Ret == 1
				cRet := "AV"
			Case _Ret == 2
				cRet := "SANTA LEONOR"
			Case _Ret == 3
				cRet := "SN"
		EndCase
	Case Alltrim(SM0->(M0_CODIGO+M0_CODFIL)) == "0110"
		Do Case
			Case _Ret == 1
				cRet := "AV"
			Case _Ret == 2
				cRet := "FRANCISCO PODBOY"
			Case _Ret == 3
				cRet := "1701"
		EndCase
	Case Alltrim(SM0->(M0_CODIGO+M0_CODFIL)) == "0112"
		Do Case
			Case _Ret == 1
				cRet := "AV"
			Case _Ret == 2
				cRet := "YOUSSEF ISMAIL MANSOUR ZE TURCO"
			Case _Ret == 3
				cRet := "621/41"
		EndCase
	Case Alltrim(SM0->(M0_CODIGO+M0_CODFIL)) == "0115"
		Do Case
			Case _Ret == 1
				cRet := "RUA"
			Case _Ret == 2
				cRet := "BAHIA"
			Case _Ret == 3
				cRet := "1042"
		EndCase
	Case Alltrim(SM0->(M0_CODIGO+M0_CODFIL)) == "0116"
		Do Case
			Case _Ret == 1
				cRet := "AV"
			Case _Ret == 2
				cRet := "JOSE ALVES CARDOSO"
			Case _Ret == 3
				cRet := "280"
		EndCase
	Case Alltrim(SM0->(M0_CODIGO+M0_CODFIL)) == "0117"
		Do Case
			Case _Ret == 1
				cRet := "AV"
			Case _Ret == 2
				cRet := "NOROESTE"
			Case _Ret == 3
				cRet := "732"
		EndCase
	Case Alltrim(SM0->(M0_CODIGO+M0_CODFIL)) == "0118"
		Do Case
			Case _Ret == 1
				cRet := "RUA"
			Case _Ret == 2
				cRet := "MOISES KAUFFMAN"
			Case _Ret == 3
				cRet := "291"
		EndCase
	Case Alltrim(SM0->(M0_CODIGO+M0_CODFIL)) == "0119"
		Do Case
			Case _Ret == 1
				cRet := "V"
			Case _Ret == 2
				cRet := "AC JOAO CAETANO C DE ALMEIDA"
			Case _Ret == 3
				cRet := "S/N"
		EndCase  
	Otherwise	
		Do Case
			Case _Ret == 1
				cRet := "RUA"
			Case _Ret == 2
				cRet := "DOUTOR MOISES KAUFFMAN"
			Case _Ret == 3
				cRet := "291"
		EndCase
EndCase


Return(cRet)  

 
/*---------------------------------------------------------*/
//
Static Function xDtrab()
Local nRet:=0
Local cMat:=TRB->RA_MAT
Local cFil:=TRB->RA_FILIAL 
Local nDtick := 0

local cAnoMes:= Alltrim(Str(Year(MV_PAR05))) + (mes:=xMes())

//nDiasUtMes := U_NumDiasUteis(cAnoMes)
                      
&&Verifica Ferias                                   
/*DbSelectArea("SRH")
SRH->(DbGoTop())
SRH->(DbSetOrder(2))
If SRH->(DbSeek(cFil+cMat)) .And. Left(DtoS(SRH->RH_DataIni),6) = cAnoMes
     nDUteisPer:=U_DiasUteisPer(SRH->RH_DataIni,SRH->RH_DataIni,.F.)	
     nRet  :=nDiasUtMes-nDUteisPer
Else
	nRet := nDiasUtMes 		
EndIf*/          

//nDTick := Val(MV_PAR08)
nDTick := TRB->DTRABM

dDAfast:= DiasAfast()                                            

dDFaltas:= DiasFaltas()

//nRet := IIf(dDAfast > 0,dDAfast - dDFaltas ,nDiasUtMes - dDFaltas)    //nDiasUtMes - dDAfast
nRet :=  nDTick - (dDAfast + dDFaltas)

Return(nRet)                                                               
                
/*------------------------------------------*/
USER FUNCTION DiasUteisPer(dDtIni,dDtFim,lChkFer)
Local dMudaData:=dDtIni,nDias:=0

If lChkFer = NIL ; lChkFer:=.T.
EndIf
Do While dMudaData <= dDtFim
	If DataValida(dMudaData) == dMudaData .AND. !VerFeriado(dMudaData,lChkFer)
	  nDias++
	EndIf
	dMudaData++
EndDo
Return(nDias)
/*-----------------------------------------*/
STATIC FUNCTION VerFeriado(dData,lChkFer)
Local nRegSP3:=SP3->(RecNo()), lRetorno:=.F.

If lChkFer .AND. SP3->(DbSeek(SRA->RA_Filial + DtoS(dData)))
	lRetorno:=.T.
EndIf
SP3->(DbGoto(nRegSP3))
Return(lRetorno)

/*---------------------------------------------
----------------------------------------------*/
USER FUNCTION NumDiasUteis(cMesAno) && Padrao do MV_FOLMES (AAAAMM)
Local nDUtil:=0,dDtIni:=CTOD("01/"+Right(cMesAno,2)+"/"+Left(cMesAno,4)),dDtMov := dDtIni
	
Do While Month(dDtIni) == Month(dDtMov) .And. Year(dDtIni)  == Year(dDtMov)
	If DataValida(dDtMov) == dDtMov .And. ! VerFeriado(dDtMov,.T.)
		nDUtil++
	Endif
	dDtMov++
EndDo

Return(nDUtil)
              
              
/*---------------------------------------------------------
---------------------------------------------------------*/
USER FUNCTION nDUtelPer(cMesAno) && Padrao do MV_FOLMES (AAAAMM)
Local nDUtil:=0,dDtIni:=CTOD("01/"+Right(cMesAno,2)+"/"+Left(cMesAno,4)),dDtMov := dDtIni
	
Do While Month(dDtIni) == Month(dDtMov) .And. Year(dDtIni)  == Year(dDtMov)
	If DataValida(dDtMov) == dDtMov .And. ! VerFeriado(dDtMov,.T.)
		nDUtil++
	Endif
	dDtMov++
EndDo

Return(nDUtil)




/*ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
&& Esta funcao conta os dias de afastamento do funcionario, ela verifica na 
&& tabela de afastamentos(SR8) se o funcionario encontra-se afastado no mes
&& do movimento (MV_FOLMES) caso esteja a funcao busca, por meio da  funcao
&& CONTADIAS, os dias trabalhados no mes.*/
STATIC FUNCTION DiasAfast(_cMat)
Local nRetorno:=0,lAchouMat:=.F.,dDtPesq,cMat:=_cMat,cFil:=TRB->RA_FILIAL
Private cAnoMes:=Alltrim(Str(Year(dDatabase))) + (mes:=xMes())
//Private cAnoMes:=Alltrim(Str(Year(MV_PAR06))) + (mes:=xMes())       

//Private _cDTIni := Alltrim(Str(Year(MV_PAR06))) + Alltrim(Str(Month(MV_PAR06))) 
//Private _cDTFim := Alltrim(Str(Year(MV_PAR07))) + Alltrim(Str(Month(MV_PAR07)))

Private _cDTIni := StrZero(Year(dDtIniAnt),4) + StrZero(Month(dDtIniAnt),2) //StrZero(Year(MV_PAR06),4) + StrZero(Month(MV_PAR06),2) 
Private _cDTFim := StrZero(Year(dDtFimAnt),4) + StrZero(Month(dDtFimAnt),2) //StrZero(Year(MV_PAR07),4) + StrZero(Month(MV_PAR07),2)

If SR8->(DbSeek(cFil+cMat))  && Posiciona na tabela de Afastamentos (SR8)
   If Empty(SR8->R8_DataFim) && Data fim vazia indica que funcionario esta afastado
		nRetorno:=-999999      && por tempo indeterminado
	Else
		Do While SR8->R8_Filial+SR8->R8_Mat = cFil+cMat
			If SR8->R8_Tipo = "F"  && Tipo de afastamento por ferias
				cAnMeIni:=StrZero(Year(SR8->R8_DataIni),4) + StrZero(Month(SR8->R8_DataIni),2)
				cAnMeFim:=StrZero(Year(SR8->R8_DataFim),4) + StrZero(Month(SR8->R8_DataFim),2)
				If     cAnMeIni = _cDTIni//cAnoMes  && Verifica se ferias inicia no mes do movimento
					If SR8->R8_DataFim > U_UltimoDiaMes(_cDTIni)  && Verifica se ferias Termina no mes do movimento
						nRetorno+=U_DiasUteisPer(CtoD("01/" + Right(_cDTIni,2) + "/" + Left(_cDTIni,4)),SR8->R8_DataIni-1,.T.) && Pega os dias uteis ate o inicio das ferias
					EndIf
					If SR8->R8_DataFim < U_UltimoDiaMes(_cDTIni)  && Verifica se ferias termina no mes do movimento
						nRetorno+=U_DiasUteisPer(CtoD("01/" + Right(_cDTIni,2) + "/" + Left(_cDTIni,4)),SR8->R8_DataIni-1,.T.) && Pega os dias uteis ate o inicio das ferias												
						nRetorno+=U_DiasUteisPer(SR8->R8_DataFim+1,U_UltimoDiaMes(cAnMeFim),.T.)
					EndIf    
					                                                	
				ElseIf cAnoMes = cAnMeFim && Ferias termina no mes do movimento
					If SR8->R8_DataIni < CtoD("01/" + Right(cAnoMes,2) + "/" + Left(cAnoMes,4)) && Verifica se ferias nao esta dentro do proprio mes
						nRetorno+=U_DiasUteisPer(SR8->R8_DataFim+1,U_UltimoDiaMes(cAnMeFim),.T.) && Pega os dias uteis ate o inicio das ferias
					EndIf
				   If SM0->M0_Codigo + cFil # "0103" .AND. ;  && Diminui Bonus no mes de termino das ferias para funcionario que tenha tirado 30 dias de ferias menos para filial 03
					   SR8->R8_DataIni - SR8->R8_DataFim = 30
						nRetorno-=5
					EndIf
				EndIf
			Else
				If Left(DtoS(SR8->R8_DataIni),6) = cAnoMes .OR. Left(DtoS(SR8->R8_DataFim),6) = cAnoMes
					nRetorno-=ContaDias(cAnoMes)
				EndIf
			EndIf
			SR8->(DbSkip())
		EndDo
	EndIf
EndIf   
Return(nRetorno)

/*---------------------------------------------------------
-----------------------------------------------------------
---------------------------------------------------------*/
USER FUNCTION UltimoDiaMes(cMesAno) && Padrao do MV_FOLMES (AAAAMM)
Local dDtIni:=CTOD("01/"+Right(cMesAno,2)+"/"+Left(cMesAno,4))

Do While StrZero(Month(dDtIni),2) = Right(cMesAno,2)
	dDtIni++
EndDo
dDtIni--

Return(dDtIni)

/*---------------------------------------------------------
Função: DiasFaltas()
-----------------------------------------------------------
Desc.: Retornar Qtd dias de faltas do Mes anterior ao
       mês de referencia
---------------------------------------------------------*/
Static Function DiasFaltas()  
Local cQry := "" , cEnt:= Chr(13)+Chr(10), nRet:= 0             
//Private cAnoMes:=Alltrim(Str(Year(dDatabase))) + StrZero(Val(mes:=xMes() )-1,2)
//Private cAnoMes:=Alltrim(Str(Year(MV_PAR05))) + StrZero(Iif(Val(mes:=xMes() )-1 == 0,12,Val(mes)),2)
//Private dDataIni := cAnoMes+ "01"
//Private dDataFim :=  DtoS(U_UltimoDiaMes(cAnoMes))
                                                               
cQry := ""
cQry += " SELECT COUNT(PC_MAT) AS QTDFALTAS FROM  "+ RetSqlName("SPC")+" "+cEnt
cQry += " WHERE PC_FILIAL = '"+TRB->RA_FILIAL+"' "+cEnt
cQry += " AND PC_MAT = '"+TRB->RA_MAT+"' "+cEnt
cQry += " AND PC_DATA BETWEEN '"+DtoS(MV_PAR06)+"' AND '"+DtoS(MV_PAR07)+"' "+cEnt
cQry += " AND PC_PD = '112' "+cEnt //EVENTOS "FALTA INTEGR. AUT"  
cQry += " AND PC_ABONO NOT IN (SELECT P6_CODIGO FROM SP6010 WHERE D_E_L_E_T_ = ' ')  "+cEnt  //('003','016','018','021','022','023')    ///08.96
cQry += " AND D_E_L_E_T_ = ' ' "+cEnt
cQry += " GROUP BY PC_FILIAL, PC_MAT "+cEnt

TCQuery cQry Alias TRC New 

DbSelectArea("TRC")
TRC->(DbGotop())
nRet := TRC->QTDFALTAS

TRC->(DbCloseArea())            

Return(nRet)                     

/*---------------------------------------------------------
Funcao: xVlrRef()  |Autor: AOliveira | Data 13-12-2011
-----------------------------------------------------------
Desc.: 
---------------------------------------------------------*/ 
Static Function xVlrRef()
Local nRet := 0

DbSelectArea("SRX")
SRX->(DbSetOrder(1))
SRX->(DbGotop())
If SRX->(DbSeek(xFilial("SRX")+"26"))
	nRet := Val(Alltrim(SubStr(SRX->RX_TXT,27,8)))
EndIf

Return(nRet)
        


/*---------------------------------------------------------
Funcao: OpenBrowse()  |Autor: AOliveira | Data 27-02-2012
-----------------------------------------------------------
Uso: xGerPAT()
---------------------------------------------------------*/
Static Function OpenBrowse()       
                  
Local aInfo		:= {}
Local aPosObj	:= {}
Local aObjects	:= {}
Local aSize		:= MsAdvSize()  			// Define e utilização de janela padrão Microsiga
Local nOpc := 6//GD_INSERT+GD_DELETE+GD_UPDATE
Private aCols := {}
Private aHeader := {}
Private noBrw1  := 0      
Private nOpcA    
Private aAlterGDa := {"D1_QUANT","D2_QUANT"}  


Public aDados := {}

SetPrvt("oDlg1","oBrw1")                         

AADD( aObjects, { 100, 000, .T., .F. })  //Enchoice
AADD( aObjects, { 100, 100, .T., .T. })  //GetDados
AADD( aObjects, { 100, 000, .T., .F. })  //Rodapé
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects,.T. )

oDlg1      := MSDialog():New( aSize[7],0,aSize[6],aSize[5],"Geracao de Arquivo de Remessa PAT - Ticket",,,.F.,,,,,,.T.,,,.T. )
oDlg1:bInit := {||EnchoiceBar     (oDlg1,{|| (nOpcA := 1,oDlg1:End())},{|| (nOpcA := 0,oDlg1:End())},,{})}
MHoBrw1()
MCoBrw1()
oBrw1      := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,'AllwaysTrue()','AllwaysTrue()',,aAlterGDa,0,99,'AllwaysTrue()','','AllwaysTrue()',oDlg1,aHeader,aCols )

oDlg1:Activate(,,,.T.)                                  

If nOpcA == 1
	aDados:= aClone(oBrw1:aCols)
EndIf

Return(nOpcA)

/*Function  ³ MHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: */
Static Function MHoBrw1()

//{cTitulo, cCampo, cPicture, nTamanho, nDecimais,cValidação, cReservado, cTipo, xReservado1, xReservado2}
Aadd(aHeader,{"Filial", "RA_FILIAL", X3Picture( "RA_FILIAL" ), TamSx3("RA_FILIAL")[1] ,TamSx3("RA_FILIAL")[2] ,"", "", "C", "", ""})
Aadd(aHeader,{"Matricula", "RA_MAT", X3Picture( "RA_MAT" ), TamSx3("RA_MAT")[1] ,TamSx3("RA_MAT")[2] ,"", "", "C", "", ""})
Aadd(aHeader,{"Nome", "RA_NOME", X3Picture( "RA_NOME" ), TamSx3("RA_NOME")[1] ,TamSx3("RA_NOME")[2]  ,"", "", "C", "", ""})
Aadd(aHeader,{"Qtd. Vales", "D1_QUANT",X3Picture( "D1_QUANT" ) ,TamSx3("D1_QUANT")[1] ,0 ,"u_VldQTD()", "", "N", "", ""})
Aadd(aHeader,{"Deduzir", "D2_QUANT", X3Picture( "D2_QUANT" ) ,TamSx3("D2_QUANT")[1],0 ,"u_VldDEDUZ()", "", "N", "", ""})
Aadd(aHeader,{"VLR Un.", "D2_TOTAL", X3Picture( "D2_TOTAL" ),TamSx3("D2_TOTAL")[1] ,TamSx3("D2_TOTAL")[2] ,"", "", "N", "", ""})
Aadd(aHeader,{"VLR Total", "D2_TOTAL", X3Picture( "D2_TOTAL" ),TamSx3("D2_TOTAL")[1] ,TamSx3("D2_TOTAL")[2] ,"", "", "N", "", ""})

Return

/*Function  ³ MCoBrw1() - Monta aCols da MsNewGetDados para o Alias: */
Static Function MCoBrw1()

Local aAux := {}
Local nI 
Local _nDTRABM   := 0
Local _nDEDUZIR  := 0
Local _nVLRUN    := 0
Local _nVLRTOTAL := 0      
                  
dDataFim := MV_PAR05
ndTrab      := 0
ndNTrab    := 0
ndDSR      := 0
nQtRef     := 0 
nTotVT     := 0
nTotNVT    := 0  
nDifVTN    := 0
  
cSemana    := ""  

/*
Aadd(aCols,Array(Len(aHeader)+1))
For nI := 1 To Len(aHeader)
   aCols[1][nI] := CriaVar(aHeader[nI][2]) 
Next
aCols[1][Len(aHeader)+1] := .F.            
*/

DbSelectArea("TRB")
TRB->(DbGotop())
ProcRegua(LastRec())
While !TRB->(Eof())

	IncProc() 
	
	/*Verificar funcionarios*/
	/*
	If TRB->RA_MAT $ ('010737|010801|011304')
	Alert('RA: '+TRB->RA_MAT)
	End
	*/
	
	dDataFim   := MV_PAR05
	dDtIniAnt  := CtoD("01"+"/"+StrZero(Month(MV_PAR05)-1,2)+"/"+StrZero(Year(MV_PAR05),4))
	dDtFimAnt  := CtoD(StrZero(F_UltDia(CtoD(StrZero(Day(MV_PAR05),2)+"/"+StrZero(Month(MV_PAR05)-1,2)+"/"+StrZero(Year(MV_PAR05),4))),2)+"/"+StrZero(Month(MV_PAR05)-1,2)+"/"+StrZero(Year(MV_PAR05),4))    

	

	_nDTrabs := xDTrabs(TRB->RA_FILIAL,TRB->RA_MAT)
	
	_nDTRABM 	:= _nDTrabs//xDtrab()
	_nDEDUZIR 	:= TRB->DEDUZIR
	_nVLRUN     := TRB->VLRUN
	_nVLRTOTAL	:= ((_nDTRABM - _nDEDUZIR) * _nVLRUN)
	If _nDTRABM > 0
		Aadd(aCols,{TRB->RA_FILIAL,TRB->RA_MAT,TRB->RA_NOME,_nDTRABM,_nDEDUZIR,_nVLRUN,_nVLRTOTAL,.F.})
	EndIf
	TRb->(DbSkip())
EndDo


Return

//
User Function VldQTD()
Local lRet := .T.                        
Local nRet := ( D1_QUANT - aCols[n][5] ) * aCols[n][6]

If nRet > 0
	aCOLS[n][7] := nRet
Else
	Alert("VLR Total, não pode ser menor ou igual a zero!")	
	lRet := .F.
EndIf

Return(lRet)                                  

//
User Function VldDEDUZ()
Local lRet := .T.                        
Local nRet := ( aCols[n][4] - D2_QUANT ) * aCols[n][6]

If nRet > 0
	aCOLS[n][7] := nRet
Else
	Alert("VLR Total, não pode ser menor ou igual a zero!")	
	lRet := .F.
EndIf

Return(lRet)


/*---------------------------------------------------------
Funçao: xDTrabs()     |Autor: AOliveira   |Data: 06-03-2012
-----------------------------------------------------------
Desc.: 
---------------------------------------------------------*/
Static Function xDTrabs(_cFil,_cMat)
Local _nRet      := 0
Local ndTrab     := 0
Local ndNTrab    := 0
Local ndDSR      := 0
Local nQtRef     := 0
Local nTotVT     := 0
Local nTotNVT    := 0
Local nDifVTN    := 0
Local nDNUtil    := 0
Local nDUte      := 0
Local nDifVT     := 0

Local	DiasTrab  	:= 0 
Local	nDiasAfas 	:= 0      
Local   nDiasFal    := 0
Private cDiasMes	:= Getmv("MV_DIASMES")  
Private aCodFol     := {}
Private aAbonosPer  := {} 
Private __Afast     := 0
		
DbSelectArea("SRA")
SRA->(DbSetOrder(1))
SRA->(DbGoTop())
    
//If SRA->(DbSeek(TRB->RA_FILIAL+TRB->RA_MAT))
If SRA->(DbSeek(_cFil+_cMat))

	//Acessa Calendario de Periodos para buscar a quantidade de dias
	FTrabCalen(dDataFim,@ndTrab,@ndNTrab,@ndDSR,@nDNUtil,@nDUte,@nDifVT,,,@nQtRef,@nTotVT,@nTotNVT,cSemana,.F.,.T.,@nDifVTN) 
	If .T.//nDFerias == 1   //Calcula Ferias do periodo Anterior
		//FDiasAfast(@nDiasAfas,@DiasTrab,dDtFimAnt,.F.)
		//nDiasAfas:= DiasAfast(_cMat)
		//nDiasAfas:= Iif(nDiasAfas == 0, 0, TRB->DTRABM - nDiasAfas)//	TRB->DTRABM - nDiasAfas
		__Afast:= xDAfast(_cFil,_cMat,dDtIniAnt)
	Endif
     
	_nExtra:= xExtras()

EndIf            

//_nRet := ((nQtRef + _nExtra) - nDiasAfas)
//_nRet := (Iif(TRB->RA_REGRA == '12',TRB->DTRABM,(nQtRef + _nExtra)) - nDiasAfas)
_nRet := (Iif(TRB->RA_REGRA == '12',TRB->DTRABM,(nQtRef + _nExtra)) - __Afast)

Return(_nRet)
                                                                    
//         

/*---------------------------------------------------------
Função: xExtras() 
-----------------------------------------------------------
Desc.: 
---------------------------------------------------------*/
Static Function xExtras()  
Local cQry := "" , cEnt:= Chr(13)+Chr(10), nRet:= 0                                                                            
cQry := ""    
cQry += " SELECT * FROM  "+ RetSqlName("SPC")+" "+cEnt
cQry += " WHERE PC_FILIAL = '"+TRB->RA_FILIAL+"' "+cEnt
cQry += " AND PC_MAT = '"+TRB->RA_MAT+"'"+cEnt
cQry += " AND PC_DATA BETWEEN '"+DtoS(dDtIniAnt)+"' AND '"+DtoS(dDtFimAnt)+"' "+cEnt
cQry += " AND PC_PD IN (SELECT P4_CODAUT FROM  "+RetSqlName("SP4")+ " WHERE P4_FILIAL = '"+TRB->RA_FILIAL+"' AND D_E_L_E_T_ = ' ')"+cEnt
cQry += " AND D_E_L_E_T_ = ' '  "+cEnt     

TCQuery cQry Alias TRR New 

DbSelectArea("TRR")
TRR->(DbGotop())
While !TRR->(Eof())
	If DataValida(StoD(TRR->PC_DATA)) <> StoD(TRR->PC_DATA) .OR. VerFeriado(StoD(TRR->PC_DATA),.T.)
		nRet++
	Endif
	TRR->(DbSkip())
EndDo 
  
    
TRR->(DbCloseArea())

Return(nRet)  

//
/*---------------------------------------------------------
Função: xDAfast() 
-----------------------------------------------------------
Desc.: 
---------------------------------------------------------*/
Static Function xDAfast(_cFil,_cMat,_dDataRef)
Local _nRet := 0                    

Default _dDataRef := dDataBase     

_dDataRef := StrZero(Year(_dDataRef),4) + StrZero(Month(_dDataRef),2)

DbSelectArea("SR8")
SR8->(DbSetOrder(1))
SR8->(DbGotop())
If SR8->(DbSeek(_cFil+_cMat))
	If Empty(SR8->R8_DataFim) && Data fim vazia indica que funcionario
		nRetorno:=-999999     && esta afastado por tempo indeterminado
	Else
		While SR8->(R8_Filial+R8_Mat) = _cFil+_cMat
			If SR8->R8_Tipo = "F"  && Tipo de afastamento por ferias
				If SubStr(DtoS(SR8->R8_DATAINI),1,6) == _dDataRef  && Data de Inicio no mesmo Mês
					If SubStr(DtoS(SR8->R8_DATAINI),1,6) == _dDataRef .And. SubStr(DtoS(SR8->R8_DATAFIM),1,6) == _dDataRef && Data Inicio e Fim no mesmo mês
						_nRet := U_DiasUteisPer(SR8->R8_DATAINI,SR8->R8_DATAFIM,.T.)
					Else
					    _nRet := U_DiasUteisPer(SR8->R8_DATAINI,StoD(_dDataRef+Alltrim(Str(F_UltDia(SR8->R8_DATAINI)))),.T.)
					EndIf					
				ElseIf SubStr(DtoS(SR8->R8_DATAFIM),1,6) == _dDataRef
				   _nRet := U_DiasUteisPer(StoD(_dDataRef+"01"),SR8->R8_DATAFIM,.T.)
				EndIf
			EndIf    
			SR8->(DbSkip())
		EndDo
	EndIf
EndIf

Return(_nRet)                                                                            