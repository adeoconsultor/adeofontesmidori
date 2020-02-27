#Include "Protheus.ch"
#Include "RwMake.ch"        
#Include "TopConn.ch"
#Include 'Font.ch'
#Include 'Colors.ch'  
/*---------------------------------------------------------
Funcao: XMNTAPS()  |Autor: AOliveira    |Data: 21/11/2017
-----------------------------------------------------------
Descr.: Rotina tem como Objetivo Realizar Manutencao de 
        Aprovacoes de Pagamentos.
-----------------------------------------------------------
Uso:    MIDIRI
---------------------------------------------------------*/
User Function XMNTAPS()

Local cAlias := "SZW"
Private cCadastro := ""
Private aRotina := {}
Private aCores  := {}

Private _cCDUSR := RetCodUsr()
    
Private cMark:=GetMark()

//Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
                                                                    
cCadastro := OEMToANSI( "Controle de AprovaÁ„o de Pagamentos (AP's)" )

AAdd( aRotina, {"Pesquisar"        , "AxPesqui",   0, 1} )
AAdd( aRotina, {"Visualizar"       , "u_VIEWAP"  , 0, 2} )
AAdd( aRotina, {"Aprovar"          , "u_MNTAPAPV", 0, 3} )
AAdd( aRotina, {"Imprimir AP"      , "u_MNTAPIMP", 0, 4} )
AAdd( aRotina, {"Legenda"          , "u_MNTAPLEG", 0, 5} )
AAdd( aRotina, {"Imp Lista Pgto"   , "u_RLISTAP" , 0, 6} )
AAdd( aRotina, {"Visualizar NF"    , "u_MNTAPVNF", 0, 7} )
AAdd( aRotina, {"Aprovar por Lote" , "u_MNTAPAPM", 0, 8} )

if !(vlduser(_cCDUSR))
	AAdd( aRotina, {"Alterar Aprovador" , "u_SeekApr", 0, 8} ) //Alterar
endif

aAdd(aCores,{'ZW_STATUS == "B" ' ,"ENABLE"})                            //-- "Aprovacao"
aAdd(aCores,{'ZW_STATUS == "A" ' ,"DISABLE"})                           //-- "Aguardando Aprovaùùo"
aAdd(aCores,{'ZW_STATUS == "C"  .AND. ZW_FLAG == "1" ' ,"BR_LARANJA"})  //-- AP Aprovado/Impresso                              
aAdd(aCores,{'ZW_STATUS == "D"  .AND. ZW_FLAG <> "1" ' ,"BR_PINK"})     //-- AP Aprovado/Reimpresso                               

//valida registro deletados entre SZW x SE2                          
CursorWait()
MsgRun( "Selecionando registros, aguarde...",, { || VLDREGDEL() } ) 
CursorArrow()

//valida NUMAP entre SZW x SE2                          
CursorWait()
MsgRun( "Selecionando registros, aguarde...",, { || AJNUMAP() } ) 
CursorArrow() 

CursorWait()
MsgRun( "Selecionando registros, aguarde...",, { || AJNUMAP2() } ) 
CursorArrow() 
                                                     

DbSelectArea(cAlias)
(cAlias)->(DbSetOrder(1))
 
//_cCDUSR := "000441"
If (vlduser(_cCDUSR))
	//Aoliveira 22-10-2019
	//Se usuario for aprovador
	//lista somente AP do usuario
	
	//mBrowse( 6,1,22,75,cAlias,,,,,,aCores,,,,,,,,  "ZW_USRAP = '"+ Alltrim(_cCDUSR) +"' " )	
	
	MarkBrow( 'SZW', 'ZW_OK',,,, cMark,'u_XMARKALL()',,,,'u_XMARK()',/*{|| u_XMARKALL()}*/,"ZW_USRAP = '"+ Alltrim(_cCDUSR) +"' ",,aCores,,,,.F.) 
Else
	//mBrowse( 6,1,22,75,cAlias,,,,,,aCores)
	MarkBrow( 'SZW', 'ZW_OK',,,, cMark,'u_XMARKALL()',,,,'u_XMARK()',/*{|| u_XMARKALL()}*/,,,aCores,,,,.F.) 
EndIf
                        
Return()    

//----------------------------------------------------------------------------//
User Function MNTAPDES()
ALert("Rotina em DESENVOLVIMENTO!")
Return()                               
//----------------------------------------------------------------------------//
User Function MNTAPLEG(cAlias, nRegistro, nOpcao)

Local aLegenda	 := {}
//Local aLegeUsr   := {}

aAdd(aLegenda,{"ENABLE" 	,"Aprovado"})                //ZW_STATUS == "B"
aAdd(aLegenda,{"DISABLE"	,"Aguardando AprovaÁ„o"})    //ZW_STATUS == "A"
aAdd(aLegenda,{"BR_LARANJA"	,"Aprovado/Impresso"})       //ZW_STATUS == "C"  .AND. ZW_FLAG == "1"
aAdd(aLegenda,{"BR_PINK"	,"Aprovado/Reimpresso"})     //ZW_STATUS == "D"  .AND. ZW_FLAG <> "1"

BrwLegenda("MNT AP's","", aLegenda )

Return .T.   

/*---------------------------------------------------------
Funcao: MNTAPAPV() | Autor: AOliveira  | Data: 21-11-2017
-----------------------------------------------------------
Descr.: Rotina de Aprovaùùes de Pagamentos.
-----------------------------------------------------------
Uso:    XMNTAPS
---------------------------------------------------------*/
User Function MNTAPAPV(cAlias, nRegistro, nOpcao)

Local _lAcesso := vlduser() //Valida se o usuùrio tem acesso para realizar aprovaùùes.

If _lAcesso
	If (SZW->ZW_STATUS <> "A")
		Aviso(  "MNT AP's","AP JA SE ENCONTRA APROVADA." ,{"Ok"},1)
	Else
		// Chama a rotina de visualizacao para mostrar o movimento a ser excluido.
		//nConfirmou := AxVisual(cAlias, nRegistro, 2)
		nConfirmou := U_VIEWAP("B") //AxVisual(cAlias, nRegistro, 2)
		
		If nConfirmou //== 1      // Confirmou a exclusao.
			
			Begin Transaction
			
			//Implementar a rotina
			//Alert("MNTAPAPV() -- Rotina em DESENVOLVIMENTO!")
			
			DbSelectArea("SZW")
			RecLock("SZW", .F.)
			SZW->ZW_USRAP   := RetCodUsr()
			SZW->ZW_USRAPN  := Alltrim(USRFULLNAME(RETCODUSR()))
			SZW->ZW_DATAAP  := ddatabase
			SZW->ZW_STATUS  := "B"
			SZW->ZW_HISTAPV	:= "APROVACAO REALIZADA EM "+DtoC(dDataBase)+" - "+Time()+", USUARIO: "+ Alltrim(RetCodUsr()) +" - "+Alltrim(USRFULLNAME(RETCODUSR()))+ CRLF + IIf(!Empty(MV_PAR20), "OBS DA AP:"+ CRLF + MV_PAR20 ,"") + CRLF + Alltrim(SZW->ZW_HISTAPV)
			SZW->ZW_FLAG    := Soma1(SZW->ZW_FLAG)		                                   
			SZW->(MSUnlock())         
			
			// Tratativa para gravar data de liberaùùo da AP no financeiro.
			// E2_DATALIB / Param. MV_CTLIPAG 
		    // Diego em 14/09/2018  
		    /*
		    If (SE2->(MsSeek(xFilial("SE2")+ SZW->(ZW_PREFIXO+ZW_NUM+ZW_PARCELA+ZW_TIPO+ZW_FORNECE+ZW_LOJA))))
				RecLock("SE2",.F.)
				SE2->E2_DATALIB  := ddatabase
				SE2->(MsUnlock())
			Endif
            */
            
			//AOliveira em 17-09-2018
			//Realizado alteraùùo para gravar a da de liberaùùo em todos os titulos da AP, liberada.
			cQuery := " SELECT * FROM "  
			cQuery += RetSqlName("SE2")+" SE2 "
			cQuery += " WHERE E2_FILIAL = '"+ xFilial("SE2") +"' "
			cQuery += " AND E2_X_NUMAP = '"+ SZW->ZW_NUMAP +"' "
			cQuery += " AND D_E_L_E_T_ = ' ' "
			
			dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'TMP4',.T.,.F.)
			DbSelectArea("TMP4") 
			TMP4->(DbGoTop())
			While !TMP4->(Eof())  
                DbSelectArea("SE2")
                SE2->(DbSetOrder(1))//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
			    If (SE2->(MsSeek( TMP4->E2_FILIAL+TMP4->E2_PREFIXO+TMP4->E2_NUM+TMP4->E2_PARCELA+TMP4->E2_TIPO+TMP4->E2_FORNECE+TMP4->E2_LOJA )))
					RecLock("SE2",.F.)
					SE2->E2_DATALIB  := ddatabase
					SE2->(MsUnlock())
				Endif			      
				TMP4->(DbSkip()) 
			EndDo 
			TMP4->(DbCloseArea())
		
			End Transaction
			
		EndIf
	EndIf
EndIf


Return() 
         

/*---------------------------------------------------------
Funcao: MNTAPAPM() | Autor: AOliveira  | Data: 21-11-2017
-----------------------------------------------------------
Descr.: Rotina de Aprovaùùes de Pagamentos.
-----------------------------------------------------------
Uso:    XMNTAPS
---------------------------------------------------------*/
User Function MNTAPAPM(cAlias, nRegistro, nOpcao) 
 
Local lCont := .F.   
Local aDados := {}

DbSelectArea('SZW')  
SZW->(DbGotop())
While !SZW->(Eof()) .And. !(lCont)
	//If IsMark( 'ZW_OK', cMark )
	If (Alltrim(SZW->ZW_OK) == Alltrim(cMark) )
		lCont := .T.
		AADD(aDados,{ SZW->(Recno())})
	EndIf	
	SZW->(dbSkip())
EndDo

If lCont
	SZW->(DbGotop())	
	CursorWait()
	MsgRun( "Realizando Aprovaes, aguarde...",, { ||  APAPM(cAlias, nRegistro, nOpcao, aDados)  } )
	CursorArrow()
Else
	Aviso("MNT APs","Necessario ter ao menos um registro selecionado para continuar!",{"Ok"},1)
EndIf

//SET FILTER TO
//SET FILTER TO &("ZW_USRAP == '"+ Alltrim(RetCodUsr()) +"' " )


Return()

/*Aprovar multiplos (Lote)*/
Static Function APAPM(cAlias, nRegistro, nOpcao, aDados)

Local aAreaSZW := SZW->(GetArea())

Local _lAcesso := vlduser() //Valida se o usuùrio tem acesso para realizar aprovaùùes.

If _lAcesso
	
	DbSelectArea("SZW")
	SZW->(DbGoTOP())
	
	While !SZW->(Eof())
		//If IsMark( 'ZW_OK', cMark )
		If (Alltrim(SZW->ZW_OK) == Alltrim(cMark) )
			
			If (SZW->ZW_STATUS <> "A")
				Aviso("MNT APs","AP ( "+ SZW->ZW_NUMAP +" ), JA SE ENCONTRA APROVADA.",{"Ok"},1)
			Else
				
				Begin Transaction
								
				DbSelectArea("SZW")
				RecLock("SZW", .F.)
				SZW->ZW_USRAP   := RetCodUsr()
				SZW->ZW_USRAPN  := Alltrim(USRFULLNAME(RETCODUSR()))
				SZW->ZW_DATAAP  := ddatabase
				SZW->ZW_STATUS  := "B"
				SZW->ZW_HISTAPV	:= "APROVACAO (EM LOTE), REALIZADA EM "+DtoC(dDataBase)+" - "+Time()+", USUARIO: "+ Alltrim(RetCodUsr()) +" - "+Alltrim(USRFULLNAME(RETCODUSR()))+ CRLF + Alltrim(SZW->ZW_HISTAPV)
				SZW->ZW_FLAG    := Soma1(SZW->ZW_FLAG)
				SZW->ZW_OK      := Space(2)
				SZW->(MSUnlock())
				
				MarkBRefresh( )
					
				//AOliveira em 17-09-2018
				//Realizado alteracao para gravar a da de liberaùùo em todos os titulos da AP, liberada.
				cQuery := " SELECT * FROM "
				cQuery += RetSqlName("SE2")+" SE2 "
				cQuery += " WHERE E2_FILIAL = '"+ xFilial("SE2") +"' "
				cQuery += " AND E2_X_NUMAP = '"+ SZW->ZW_NUMAP +"' "
				cQuery += " AND D_E_L_E_T_ = ' ' "
				
				dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'TMP4',.T.,.F.)
				DbSelectArea("TMP4")
				TMP4->(DbGoTop())
				While !TMP4->(Eof())
					DbSelectArea("SE2")
					SE2->(DbSetOrder(1))//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
					If (SE2->(MsSeek( TMP4->E2_FILIAL+TMP4->E2_PREFIXO+TMP4->E2_NUM+TMP4->E2_PARCELA+TMP4->E2_TIPO+TMP4->E2_FORNECE+TMP4->E2_LOJA )))
						RecLock("SE2",.F.)
						SE2->E2_DATALIB  := ddatabase
						SE2->(MsUnlock())
					Endif
					TMP4->(DbSkip())
				EndDo
				TMP4->(DbCloseArea())
				
				End Transaction
				
			EndIf
		EndIf
		SZW->(DbSkip())
	EndDo
EndIf



RestArea(aAreaSZW)

Return() 
 
 
/*---------------------------------------------------------
Funcao: MNTAPIMP() | Autor: AOliveira  | Data: 21-11-2017
-----------------------------------------------------------
Descr.: Rotina de Aprovacoes de Pagamentos.
-----------------------------------------------------------
Uso:    XMNTAPS
---------------------------------------------------------*/
User Function MNTAPIMP(cAlias, nRegistro, nOpcao)

Local aDadosTit := {}
Local aDescrAP  := {}
Local cQuery    := ""   
//Local cPrefixo  := SZW->ZW_PREFIXO
//Local cNumTit   := SZW->ZW_NUM
//Local cNumAP    := SZW->ZW_NUMAP  
//Local lDescriOk := .F.
//Local nTotalDoc := 0

Local cAliasSE2 := "TRB"
Local aStruSE2  := SE2->(dbStruct())

Local lCont := .F.

Local nX
     
If (ZW_STATUS == "A") 
	//
	Aviso("MNT APs","AP AGUARDANDO APROVACAO.",{"Ok"},1)
Elseif SZW->ZW_STATUS == "B"      
	//Implementar a rotina
	//Alert("MNTAPIMP() -- Rotina em DESENVOLVIMENTO!") 	
	DbSelectArea("SZW")
	RecLock("SZW", .F.)
	SZW->ZW_FLAG    := "1" // Soma1(SZW->ZW_FLAG)
	SZW->ZW_STATUS  := "C"  
	SZW->ZW_HISTAPV	:= SZW->ZW_HISTAPV +CRLF+ "IMPRESSAO REALIZADA EM "+DtoC(dDataBase)+" - "+Time()+", USUARIO: "+ Alltrim(RetCodUsr()) +" - "+Alltrim(USRFULLNAME(RETCODUSR()))				//	
	SZW->(MSUnlock())
	lCont := .T.
	
Elseif SZW->ZW_STATUS == "C"      
	
	//Implementar a rotina
	//Alert("MNTAPIMP() -- Rotina em DESENVOLVIMENTO!") 
	DbSelectArea("SZW")
	RecLock("SZW", .F.)
	SZW->ZW_FLAG    := Soma1(SZW->ZW_FLAG)
	SZW->ZW_STATUS  := "D"  
	SZW->ZW_HISTAPV	:= SZW->ZW_HISTAPV +CRLF+ "REIMPRESSAO REALIZADA EM "+DtoC(dDataBase)+" - "+Time()+", USUARIO: "+ Alltrim(RetCodUsr()) +" - "+Alltrim(USRFULLNAME(RETCODUSR()))				//	
	SZW->(MSUnlock())
	lCont := .T.                                 

Elseif SZW->ZW_STATUS == "D"      
	
	//Implementar a rotina
	//Alert("MNTAPIMP() -- Rotina em DESENVOLVIMENTO!") 
	DbSelectArea("SZW")
	RecLock("SZW", .F.)
	SZW->ZW_FLAG    := Soma1(SZW->ZW_FLAG)
	SZW->ZW_STATUS  := "D"  
	SZW->ZW_HISTAPV	:= SZW->ZW_HISTAPV +CRLF+ "REIMPRESSAO REALIZADA EM "+DtoC(dDataBase)+" - "+Time()+", USUARIO: "+ Alltrim(RetCodUsr()) +" - "+Alltrim(USRFULLNAME(RETCODUSR()))				//	
	SZW->(MSUnlock())
	lCont := .T.
		
EndIf

If lCont
	cQuery := " SELECT * FROM "  
	cQuery += RetSqlName("SE2")+" SE2 "
	cQuery += " WHERE " 
	cQuery += " SE2.E2_X_NUMAP = '" + SZW->ZW_NUMAP + "' AND "   
	cQuery += " SE2.D_E_L_E_T_ = ' '"  
	cQuery += " ORDER BY SE2.E2_X_NUMAP, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO, SE2.E2_FORNECE, SE2.E2_LOJA"
	cQuery := ChangeQuery(cQuery)
	                                         
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB")
	
	dbSelectArea("TRB")   
	
	For nX := 1 To Len(aStruSE2)
		If aStruSE2[nX][2]<>"C"
			TcSetField(cAliasSE2,aStruSE2[nX][1],aStruSE2[nX][2],aStruSE2[nX][3],aStruSE2[nX][4])
		EndIf
	Next nX
	                                                              	
	aAdd(aDescrAP,{Upper("Referente Titulos"),Nil})
	aDescrAP:= xTiAgl(TRB->E2_NUM,TRB->E2_NATUREZ,aDescrAP)
	
	aAdd(aDadosTit,	{	TRB->E2_PREFIXO,	TRB->E2_NUM    ,	TRB->E2_PARCELA,	TRB->E2_TIPO   ,	TRB->E2_FORNECE,	TRB->E2_LOJA,;   
						TRB->E2_X_NUMAP,	TRB->E2_X_BCOFV,	TRB->E2_X_AGEFV,	TRB->E2_X_CTAFV,	TRB->E2_X_NOMFV,	TRB->E2_X_CPFFV,;
						TRB->E2_X_ORIG ,	TRB->E2_X_TPCTA,	TRB->E2_X_FPAGT,	TRB->E2_HIST, TRB->E2_HIST1})
		
	U_RFR10(aDadosTit,aDescrAP,"RFINA02")    //RFinR01(aTit,aDesc,xRotina,_cFiltro)
	//U_PDFRELAP()
	
	/*--------------------------------------------------
	Fecha tabela temporaria
	---------------------------------------------------*/
	TRB->(dbCloseArea())       
EndIf

Return() 

/*---------------------------------------------------------    
Funcao: vlduser()     |Autor: AOliveira   |Data: 22-11-2017
-----------------------------------------------------------
Descr.: Funcao tem como objetivo, validar permissùo de 
        usuario para APROVACAO de APùs. 
---------------------------------------------------------*/
Static Function vlduser(_cCDUSR)           
Local lRet     := .F.
Local nCodUser := RetCodUsr()
Local aContent := FWGetSX5( "Z4" ) //Tabela com  os usuarios no SX5.
                        
Default _cCDUSR := ""

nCodUser := iif( Empty(_cCDUSR),nCodUser,_cCDUSR) //validar usr aprovador no filtro da tela //AOliveira 22-10-2019 

If Ascan(aContent,{ |x| x[3] == nCodUser}) > 0
	lRet := .T.
Else
	If Empty(_cCDUSR)
		Aviso( "Atencao", "Usuario sem acesso para realizar APROVACOES !", { "Ok" }, 2 )
	Endif
EndIf

//lRet:= .f.
Return(lRet)                  

/*---------------------------------------------------------
---------------------------------------------------------*/
Static Function xTiAgl(_cNum,_cNaturez,aDadosAP)
Local cQuery := " "

if Select('TMP1') > 0
	dbSelectArea('TMP1')
	TMP1->(dbCloseArea())
endif


cQuery := " SELECT * FROM "  
cQuery += RetSqlName("SE5")+" SE5 "
cQuery += " WHERE E5_AGLIMP = '"+_cNum+"' "
cQuery += " AND E5_NATUREZ = '"+_cNaturez+"' "
cQuery += " AND E5_SITUACA = ' ' "
cQuery += " AND D_E_L_E_T_ = ' ' "

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'TMP1',.T.,.F.)
DbSelectArea("TMP1") 
TMP1->(DbGoTop())
While !TMP1->(Eof())        
	aAdd(aDadosAP,{Upper("   "+TMP1->E5_PREFIXO+" - "+TMP1->E5_NUMERO+" - "+TMP1->E5_PARCELA+" - "+TMP1->E5_TIPO),TMP1->E5_VALOR})	
	TMP1->(DbSkip())
EndDo
TMP1->(DbCloseArea())

Return(aDadosAP)

/*---------------------------------------------------------
Funcao: VIEWAP   |Autor: AOliveia    |Data: 29-01-2018
-----------------------------------------------------------
Descr.: 
---------------------------------------------------------*/
User Function VIEWAP(cFunc)      
 
Local lRet       := .F.                               
Local cGNumPa    := Space(1)
Local cGFornece  := Space(1)
Local cGDTEmi    := Space(1)
Local cGetUsr1   := Space(1)
Local cGetUsr2   := Space(1)
Local cMGHist    := Space(1)
Local cMGObs    := Space(1)

Local cSVlrTot   := Space(1)

Local lAlter := .T.

Default cFunc := "A"

If cFunc == "B"
	lAlter := .F.
EndIf

Private oDlg, oGrpCab, oSay1, oSay3, oSay4, oSay2, oSay5, oSay6, oSay7, oGNumPa, oGFornece
Private oGetUsr1, oGetUsr2, oMGObs, oMGHist, oGrpItem, oBrwTit, oBtnConf, oBtnCanc, oGrpVLRTot ,oSVlrTot, oGDTEmi
Private oBtnVNF

Private oFtArialN  := TFont():New( "Arial",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )

//Alimentar dados da tela
cGNumPa    := Alltrim(SZW->ZW_NUMAP)
cGFornece  := Alltrim(SZW->ZW_FORNECE) +" / "+ Alltrim(SZW->ZW_LOJA) +" - "+ Alltrim(SZW->ZW_NOMFOR)

cGDTEmi    := Alltrim(DtoC(SZW->ZW_EMISSAO))

cGetUsr1   := Alltrim(SZW->ZW_USUAR)  //USR QUE INCLUIU
cGetUsr2   := Alltrim(SZW->ZW_USRAPN) //USR QUE APROVOU

cMGHist    := SZW->ZW_HISTAPV
cMGObs     := Iif(Alltrim(SZW->ZW_TIPO) == "PA", "*** PA - Pagto Antecipado (Sem NF) ***","")

cSVlrTot   := "R$ "+Alltrim(Transform( 0 ,"@e 9,999,999,999,999.99"))   //SZW->ZW_


oDlg       := MSDialog():New( 092,232,589,737,"View AP",,,.F.,,,,,,.T.,,,.T. )
oGrpCab    := TGroup():New( 000,004,109,242,"  Dados  ",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 008,008,{||"Nro. AP"},oGrpCab,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 008,059,{||"Fornecedor"},oGrpCab,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay4      := TSay():New( 008,195,{||"Dt. Emissao"},oGrpCab,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 030,008,{||"Incluido Por"},oGrpCab,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay5      := TSay():New( 030,126,{||"Aprovado Por"},oGrpCab,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6      := TSay():New( 053,008,{||"Observacoes"},oGrpCab,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay7      := TSay():New( 053,124,{||"Historicos"},oGrpCab,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGNumPa    := TGet():New( 016,008,{|u| If(PCount()>0,cGNumPa:=u,cGNumPa)},oGrpCab,047,008,'',{|| /*bValid*/ },CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| /*bWhen*/ },.F.,.F.,{|| /*bChange*/ },.T.,.F.,"","cGNumPa",,)
oGFornece  := TGet():New( 016,059,{|u| If(PCount()>0,cGFornece:=u,cGFornece)},oGrpCab,132,008,'',{|| /*bValid*/ },CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| /*bWhen*/ },.F.,.F.,{|| /*bChange*/ },.T.,.F.,"","cGFornece",,)
oGDTEmi    := TGet():New( 016,195,{|u| If(PCount()>0,cGDTEmi:=u,cGDTEmi)},oGrpCab,040,008,'',{|| /*bValid*/ },CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| /*bWhen*/ },.F.,.F.,{|| /*bChange*/ },.T.,.F.,"","cGDTEmi",,)
oGetUsr1   := TGet():New( 038,008,{|u| If(PCount()>0,cGetUsr1:=u,cGetUsr1)},oGrpCab,112,008,'',{|| /*bValid*/ },CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| /*bWhen*/ },.F.,.F.,{|| /*bChange*/ },.T.,.F.,"","cGetUsr1",,)
oGetUsr2   := TGet():New( 038,124,{|u| If(PCount()>0,cGetUsr2:=u,cGetUsr2)},oGrpCab,112,008,'',{|| /*bValid*/ },CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| /*bWhen*/ },.F.,.F.,{|| /*bChange*/ },.T.,.F.,"","cGetUsr2",,)
oMGObs     := TMultiGet():New( 061,008,{|u| If(PCount()>0,cMGObs:=u,cMGObs)},oGrpCab,112,044,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,lAlter,,,.F.,, .T.  )
oMGHist    := TMultiGet():New( 061,124,{|u| If(PCount()>0,cMGHist:=u,cMGHist)},oGrpCab,112,044,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,, .T. )


cSVlrTot := oTbl()
DbSelectArea("TMP") 
TMP->(DbGoTop())
oGrpItem   := TGroup():New( 114,004,184,242,"  Titulos  ",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBrwTit    := MsSelect():New( "TMP","","",{{"ITEM","","Item","@!"},{"PREFIXO","","Prefixo","@!"},{"NUMERO","","Numero","@!"},{"PARCELA","","Parcela","@!"},{"TIPO","","Tipo","@!"},{"VALOR","","Valor","@E 9,999,999,999,999.99"},{"VENCTO","","Vencto Real",""}},.F.,,{123,008,179,238},,, oGrpItem ) 


oBrwTit:bAval  := {||xVerNf() }

cSVlrTot   := "R$ "+Alltrim(Transform( cSVlrTot ,"@E 9,999,999,999,999.99"))

oGrpVLRTot := TGroup():New( 208,004,230,152,"   Valor Total   ",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSVlrTot   := TSay():New( 216,021,{||cSVlrTot },oGrpVLRTot,,oFtArialN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,083,012)

oBtnVNF    := TButton():New( 185,004,"Ver NF",oDlg,{|| xVerNf() },037,012,,,,.T.,,"",,,,.F. )

oBtnConf   := TButton():New( 215,160,"Confirmar",oDlg,{|| oDlg:End(),lRet:= .T. },037,012,,,,.T.,,"",,,,.F. )
oBtnCanc   := TButton():New( 215,203,"Cancelar",oDlg ,{|| oDlg:End() },037,012,,,,.T.,,"",,,,.F. )

oDlg:Activate(,,,.T.)
 
If lRet .And. cFunc <> "A"
	MV_PAR20 := Alltrim(cMGObs)
EndIf

Return(lRet)     


/*ùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùù
Function  ù oTbl() - Cria temporario para o Alias: TMP
ùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùù*/
Static Function oTbl()

Local nRet := 0
Local aFds := {}
Local cTmp   

Local nItem := "00"

Aadd( aFds , {"FILIAL"  ,"C",TamSx3("E2_FILIAL")[1] ,TamSx3("E2_FILIAL")[2]} )
Aadd( aFds , {"ITEM"    ,"C",004 ,000} )
Aadd( aFds , {"PREFIXO" ,"C",TamSx3("E2_PREFIXO")[1],TamSx3("E2_PREFIXO")[2]} )
Aadd( aFds , {"NUMERO"  ,"C",TamSx3("E2_NUM")[1]    ,TamSx3("E2_NUM")[2]} )
Aadd( aFds , {"PARCELA" ,"C",TamSx3("E2_PARCELA")[1],TamSx3("E2_PARCELA")[2]} )
Aadd( aFds , {"TIPO"    ,"C",TamSx3("E2_TIPO")[1]   ,TamSx3("E2_TIPO")[2]} )
Aadd( aFds , {"FORNECE" ,"C",TamSx3("E2_FORNECE")[1],TamSx3("E2_FORNECE")[2]} )
Aadd( aFds , {"LOJA"    ,"C",TamSx3("E2_LOJA")[1]   ,TamSx3("E2_LOJA")[2]} )
Aadd( aFds , {"VALOR"   ,"N",TamSx3("E2_VALOR")[1]  ,TamSx3("E2_VALOR")[2]} )
Aadd( aFds , {"VENCTO"  ,"D",TamSx3("E2_VENCTO")[1] ,TamSx3("E2_VENCTO")[2]} )

If Select("TMP") > 0
	DbSelectArea("TMP")
	TMP->(DbCloseArea())
EndIf

cTmp := CriaTrab( aFds, .T. )
Use (cTmp) Alias TMP New Exclusive
Index On ITEM+PREFIXO+NUMERO+PARCELA+TIPO+dtos(VENCTO) To (cTmp)

cQuery := " SELECT * FROM "  
cQuery += RetSqlName("SE2")+" SE2 "
cQuery += " WHERE E2_FILIAL = '"+ xFilial("SE2") +"' "
cQuery += " AND E2_X_NUMAP = '"+ SZW->ZW_NUMAP +"' "
cQuery += " AND E2_PREFIXO NOT IN ('EIC') "
cQuery += " AND D_E_L_E_T_ = ' ' "

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'TMP3',.T.,.F.)
DbSelectArea("TMP3") 
TMP3->(DbGoTop())
While !TMP3->(Eof())  
      
	nItem := SOMA1(nItem)
	RecLock("TMP",.T.)    
	TMP->FILIAL   := TMP3->E2_MSFIL	
	TMP->ITEM     := nItem
	TMP->PREFIXO  := TMP3->E2_PREFIXO
	TMP->NUMERO   := TMP3->E2_NUM
	TMP->PARCELA  := TMP3->E2_PARCELA
	TMP->TIPO     := TMP3->E2_TIPO
	TMP->FORNECE  := TMP3->E2_FORNECE
	TMP->LOJA     := TMP3->E2_LOJA
	TMP->VALOR    := TMP3->E2_VALOR
	TMP->VENCTO   := StoD(TMP3->E2_VENCREA)
	TMP->(MSUnLock())
	nRet += TMP3->E2_VALOR
	TMP3->(DbSkip()) 

EndDo 

TMP3->(DbCloseArea())

Return(nRet)
                                                    
/*---------------------------------------------------------
Funcao: MNTAPVNF   |Autor: AOliveia    |Data: 17-10-2019
-----------------------------------------------------------
Descr.: Rotina tem como Objetivo visualizar NF
        vinculada ù AP
---------------------------------------------------------*/
User function MNTAPVNF(cFunc)      
 
Local lRet := .F.                                  
Default cFunc := "A"        

XVERNF()
	
Return(lRet)        

/*---------------------------------------------------------
Funcao: VLDREGDEL   |Autor: AOliveia    |Data: 29-01-2018
-----------------------------------------------------------
Descr.: Rotina em como Objetivo realizar ajuste de registros
        deletados entre SZW x SE2
---------------------------------------------------------*/
Static Function xVerNf()

Local aAreaSZW := SZW->(GetArea())

Local cFilBKP := cFilAnt
             
Local cAliasCAB := "SF1"
Local aAreaNota	:= GetArea()

Local cQry := ""    

Local nQtd  := 0       

Private L103AUTO := .f.

cAliasCAB := "SF1"

cQry := " SELECT * FROM "+ RetSQLName("SF1") +" SF1 "
cQry += " WHERE F1_X_NUMAP = '"+ SZW->ZW_NUMAP +"' "
cQry += " AND D_E_L_E_T_ = '' "
TCQUERY cQry ALIAS "TB4" NEW  

DbSelectArea("TB4")
TB4->(DbGotop()) 
TB4->(DbEval({|| nQtd ++ }))

If nQtd > 0
	TB4->(DbGotop())
	DbSelectArea( "SF1" )
	SF1->(DbSetOrder( 1 )) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
	SF1->(DbGotop())
	If SF1->(DbSeek( TB4->F1_FILIAL+TB4->F1_DOC+TB4->F1_SERIE+TB4->F1_FORNECE+TB4->F1_LOJA ))
		cFilAnt := TB4->F1_FILIAL  
		L103AUTO := .f.
		MsgRun( "Selecionando registros, aguarde...",, { || A103NFiscal( "SF1", SF1->( Recno() ), 2 ) } ) // Visualizaùùo da NF de Entrada 			
		cFilAnt := cFilBKP
	Else
		Alert("NF, nao encontrada!")
	EndIf	
	/*
	While !TB4->(Eof())
		DbSelectArea( "SF1" )
		SF1->(DbSetOrder( 1 )) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
		SF1->(DbGotop())
		If SF1->(DbSeek( TB4->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) ))
			A103NFiscal( "SF1", SF1->( Recno() ), 2 )		// Visualizaùùo da NF de Entrada
			lCont := .F.
		Else
			Alert("NF, nùo encontrada!")
			lCont := .F.
		EndIf
		TB4->(DbSkip())
	EndDo
	TB4->(DbCloseArea())
	*/
Else
	Alert("NF, nùo encontrada!")
EndIf                   
TB4->(DbCloseArea())


RestArea(aAreaSZW)
RestArea(aAreaNota)

Return()

/*---------------------------------------------------------
Funcao: VLDREGDEL   |Autor: AOliveia    |Data: 29-01-2018
-----------------------------------------------------------
Descr.: Rotina em como Objetivo realizar ajuste de registros
        deletados entre SZW x SE2
---------------------------------------------------------*/
Static Function VLDREGDEL() 

Local cQry := ""
           
/*   
cQry := " "
cQry += " SELECT SE2.D_E_L_E_T_ DELETSE2, SZW.R_E_C_N_O_ AS RECNOSZW,* "
cQry += " FROM "+RetSQLName("SZW")+" SZW "
cQry += " INNER JOIN "+RetSQLName("SE2")+" SE2 ON ZW_FILIAL = E2_FILIAL "
cQry += "                      AND ZW_PREFIXO = E2_PREFIXO "
cQry += "                      AND ZW_NUM = E2_NUM "
cQry += "                      AND ZW_PARCELA = E2_PARCELA "
cQry += "                      AND ZW_TIPO = E2_TIPO "
cQry += "                      AND ZW_FORNECE = E2_FORNECE "
cQry += "                      AND ZW_LOJA = E2_LOJA "
cQry += "                      AND ZW_NUMAP = E2_X_NUMAP "
cQry += "                      AND SE2.D_E_L_E_T_ = '*' "
cQry += " WHERE SZW.D_E_L_E_T_ = '' "   
*/

cQry := " "+CRLF
cQry += " SELECT SZW.R_E_C_N_O_ AS RECNOSZW "+CRLF
cQry += " FROM "+RetSQLName("SZW") +" SZW "+CRLF
cQry += " INNER JOIN "+RetSQLName("SE2")+" SE2 ON ZW_NUMAP = E2_X_NUMAP   "+CRLF
cQry += "                      AND ZW_PREFIXO = E2_PREFIXO  "+CRLF
cQry += "                      AND SE2.D_E_L_E_T_ = '*'  "+CRLF
cQry += " WHERE SZW.D_E_L_E_T_ = ''  "+CRLF
cQry += " GROUP BY SZW.R_E_C_N_O_ "+CRLF

TCQUERY cQry ALIAS "TB0" NEW  

DbSelectArea("TB0")
TB0->(DbGotop())
While !(Eof())    

	DbSelectArea("SZW")
	SZW->(DbGoTo( TB0->RECNOSZW )) 
    If SZW->(Recno()) == TB0->RECNOSZW
	    RecLock("SZW",.F.)
	    SZW->(DBDelete())
	    SZW->(MsUnlock()) 
    EndIf

	TB0->(DbSkip())

EndDo                                 

TB0->(DbCloseArea())

Return()

/*---------------------------------------------------------
Funcao: AJNUMAP   |Autor: AOliveia    |Data: 29-01-2018
-----------------------------------------------------------
Descr.: Rotina em como Objetivo realizar ajuste de registros
        de NUMAP entre SZW x SE2
---------------------------------------------------------*/
Static Function AJNUMAP() 

Local cQry := ""
   
cQry := " "
cQry += " SELECT SZW.R_E_C_N_O_ as RECNOSZW, E2_X_NUMAP, * "+CRLF
cQry += " FROM "+RetSQLName("SZW")+" SZW "
cQry += " INNER JOIN "+RetSQLName("SE2")+" SE2 ON ZW_FILIAL = E2_FILIAL "
cQry += "                      AND ZW_PREFIXO = E2_PREFIXO "+CRLF
cQry += "                      AND ZW_NUM = E2_NUM "+CRLF
cQry += "                      AND ZW_PARCELA = E2_PARCELA "+CRLF
cQry += "                      AND ZW_TIPO = E2_TIPO "+CRLF
cQry += "                      AND ZW_FORNECE = E2_FORNECE "+CRLF
cQry += "                      AND ZW_LOJA = E2_LOJA "+CRLF
cQry += "                      AND SE2.D_E_L_E_T_ = '' "+CRLF
cQry += " WHERE ( (ZW_NUMAP <> E2_X_NUMAP) OR (ZW_CODUS <> E2_X_CODUS) ) "+CRLF
cQry += " ORDER BY ZW_NUM "+CRLF

TCQUERY cQry ALIAS "TB0" NEW  

DbSelectArea("TB0")
TB0->(DbGotop())
While !(Eof())    
   /*
	DbSelectArea("SZW")
	SZW->(DbGoTo( TB0->RECNOSZW )) 
    If SZW->(Recno()) == TB0->RECNOSZW
	    RecLock("SZW",.F.)
	    SZW->ZW_NUMAP := TB0->E2_X_NUMAP   
	    SZW->ZW_CODUS := TB0->E2_X_CODUS
	    SZW->ZW_USUAR := Alltrim(USRFULLNAME( TB0->E2_X_CODUS ))
	    SZW->(MsUnlock()) 
    EndIf         
    */ 
    If !(Empty(TB0->E2_X_NUMAP) )
	    cUPD := " UPDATE SZW010 SET ZW_NUMAP = '"+ Alltrim(TB0->E2_X_NUMAP) + "', ZW_CODUS = '"+ Alltrim(TB0->E2_X_CODUS) + "', ZW_USUAR = '"+ Alltrim(USRFULLNAME( TB0->E2_X_CODUS )) +"' WHERE R_E_C_N_O_ = "+ Alltrim(STR(TB0->RECNOSZW))
	    //cUPD := " UPDATE SZW010 SET ZW_NUMAP = '"+ TB0->E2_X_NUMAP + "' WHERE R_E_C_N_O_ = "+ STR(TB0->RECNOSZW)
	    //nret1 := TcSqlExec(cUPD)     
    EndIf


	TB0->(DbSkip())

EndDo                                 

TB0->(DbCloseArea())  

return()

/*---------------------------------------------------------
Funcao: AJNUMAP   |Autor: AOliveia    |Data: 29-01-2018
-----------------------------------------------------------
Descr.: Rotina em como Objetivo realizar ajuste de registros
        de NUMAP entre SZW x SE2
---------------------------------------------------------*/
Static Function AJNUMAP2() 

Local cQry := ""
Local nret1 := 0
   
cQry := " "
cQry += " SELECT SZW.R_E_C_N_O_ as RECNOSZW, ISNULL(E2_X_NUMAP,'') AS E2_X_NUMAP,  "+CRLF
cQry += "        ZW_NUMAP,ZW_FILIAL,ZW_PREFIXO,ZW_NUM,ZW_PARCELA, ZW_TIPO, ZW_FORNECE, ZW_LOJA, "+CRLF
cQry += "        ZW_FILIAL+ZW_PREFIXO+ZW_NUM+ZW_PARCELA+ZW_TIPO+ZW_FORNECE+ZW_LOJA, "+CRLF
cQry += "        E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA AS SE2CHV, "+CRLF
cQry += "        E2_EMISSAO,SE2.D_E_L_E_T_ AS SE2_D_E_L_E_T_,SZW.D_E_L_E_T_ AS SZW_D_E_L_E_T_ "+CRLF
cQry += " FROM SZW010 SZW "+CRLF
cQry += " LEFT JOIN SE2010 SE2 ON E2_FILIAL+E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA = ZW_FILIAL+ZW_PREFIXO+ZW_NUM+ZW_TIPO+ZW_FORNECE+ZW_LOJA "+CRLF
cQry += "                     AND SE2.D_E_L_E_T_ = '' "+CRLF
cQry += " WHERE SZW.D_E_L_E_T_ = ''  "+CRLF
cQry += " AND ZW_NUMAP = '000244888' "+CRLF
cQry += " ORDER BY ZW_NUMAP "+CRLF

TCQUERY cQry ALIAS "TB0" NEW  

DbSelectArea("TB0")
TB0->(DbGotop())
While !(Eof())    
   /*
	DbSelectArea("SZW")
	SZW->(DbGoTo( TB0->RECNOSZW )) 
    If SZW->(Recno()) == TB0->RECNOSZW
	    RecLock("SZW",.F.)
	    SZW->ZW_NUMAP := TB0->E2_X_NUMAP   
	    SZW->ZW_CODUS := TB0->E2_X_CODUS	
	    SZW->ZW_USUAR := Alltrim(USRFULLNAME( TB0->E2_X_CODUS ))
	    SZW->(MsUnlock()) 
    EndIf         
    */ 
    If !(Empty(TB0->E2_X_NUMAP) )
	    cUPD := " UPDATE SZW010 SET ZW_NUMAP = '"+ Alltrim(TB0->E2_X_NUMAP) + "' WHERE R_E_C_N_O_ = "+ Alltrim(STR(TB0->RECNOSZW))
	    //cUPD := " UPDATE SZW010 SET ZW_NUMAP = '"+ TB0->E2_X_NUMAP + "' WHERE R_E_C_N_O_ = "+ STR(TB0->RECNOSZW)
	    nret1 := TcSqlExec(cUPD)     
    EndIf

	TB0->(DbSkip())

EndDo                                 

TB0->(DbCloseArea())

Return()

/* 
*Grava marca no campo 
*/
User Function XMARK(lMARKALL)

Default lMARKALL := .F.

If SZW->ZW_STATUS == "A"
	If IsMark( 'ZW_OK', cMark )
		RecLock( 'SZW', .F. )
		Replace ZW_OK With Space(2)
		MsUnLock()
	Else
		RecLock( 'SZW', .F. )
		Replace ZW_OK With cMark
		MsUnLock()
	EndIf
Else
	If !(lMARKALL)
		Aviso("MNT AP","AP ( "+ SZW->ZW_NUMAP +" ), JA SE ENCONTRA APROVADA.",{"Ok"},1)
	EndIf
EndIf
Return()

/*
*Grava marca em todos os registros validos
*/
User Function XMARKALL()
Local oMark := GetMarkBrow()
dbSelectArea('SZW')
dbGotop()
While !Eof()
	u_XMARK(.T.)
	dbSkip()
EndDo
MarkBRefresh( )
// forùa o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()
Return


/*
* funcao: SeekApr 
* descr.: Rotina tem o objetivo realizar alteraÁ„o do aprovador.
*/
User Function SeekApr()

Local cGetCod1   := SZW->ZW_USRAP
Local cGetNome1  := XRETVAL("1",Alltrim(cGetCod1))
Local cGetCod2   := Space(6)
Local cGetNome2  := Space(30)

Local nOpc := 0

Private oDlg1
Private oGrp1, oGrp2
Private oSay1, oSay2, oSay3, oSay4
Private oGet1, oGet2, oGet3, oGet4
Private oBtnCanc, oBtnConf

If ( Alltrim(SZW->ZW_STATUS)  <> "A" )
	Aviso( "MNT AP","AP JA SE ENCONTRA APROVADA." ,{"Ok"},1)
Else

	oDlg1      := MSDialog():New( 092,232,354,540,"Alterar Aprovador",,,.F.,,,,,,.T.,,,.T. )

	oGrp1      := TGroup():New( 000,004,050,143," Aprovador Atual ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 028,009,{||"Nome"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay2      := TSay():New( 007,009,{||"Codigo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet1      := TGet():New( 015,009,{|u| If(PCount()>0,cGetCod1:=u,cGetCod1)},oGrp1,060,008,'',{|| /*bValid*/ },CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| /*bWhen*/},.F.,.F.,{|| /*bChange*/},.T.,.F.,,"cGetCod1",,)
	oGet2      := TGet():New( 036,009,{|u| If(PCount()>0,cGetNome1:=u,cGetNome1)},oGrp1,126,008,'',{|| /*bValid*/},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cGetNome1",,)
	
	oGrp2      := TGroup():New( 052,004,102,143," Novo Aprovador ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay3      := TSay():New( 080,009,{||"Nome"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay4      := TSay():New( 059,009,{||"Codigo"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet3      := TGet():New( 067,009,{|u| If(PCount()>0,cGetCod2:=u,cGetCod2)},oGrp2,060,008,'',{|| XRETVAL("2",cGetCod2)  /*bValid*/ },CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| /*bWhen*/},.F.,.F.,{||cGetNome2:= XRETVAL("1",Alltrim(cGetCod2)) /*bChange*/},.F.,.F.,"Z4","cGetCod2",,)
	oGet4      := TGet():New( 088,009,{|u| If(PCount()>0,cGetNome2:=u,cGetNome2)},oGrp2,126,008,'',{|| /*bValid*/},CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| /*bWhen*/},.F.,.F.,{||  /*bChange*/},.T.,.F.,"","cGetNome2",,)

	oBtnCanc   := TButton():New( 106,106,"Cancelar",oDlg1 ,{|| oDlg1:End() /*bAction*/},037,012,,,,.T.,,"",,{|| /*bWhen*/},{|| /*bValid*/},.F. )
	oBtnConf   := TButton():New( 106,064,"Confirmar",oDlg1,{|| oDlg1:End(), nOpc := 1 /*bAction*/},037,012,,,,.T.,,"",,{|| /*bWhen*/},{|| XRETVAL("2",cGetCod2) /*bValid*/},.F. )

	oDlg1:Activate(,,,.T.)

	if nOpc <> 0
		if !EMPTY(cGetCod2)
		    
			DbSelectArea("SZW")
			RecLock("SZW", .F.)	
			SZW->ZW_USRAP   := cGetCod2	
			SZW->ZW_USRAPN  := Alltrim(USRFULLNAME( cGetCod2 ))
			SZW->(MSUnlock())
								
		endif
	endif

EndIf

Return()

/*
* cFunc = 1 -> Retornar nome do aprovador
* cFunc = 2 -> Valida se o codigo È de um aprovador
*/
Static Function XRETVAL(cFunc,_cVAL)
Local cRet     := ""
Local aContent := FWGetSX5( "Z4" ) //Tabela com  os usuarios no SX5.
Local nPos     := 0

Local cMSG := ""

Local cA2CDUSR := ""

Default _cVAL := ""

If cFunc == "1"
	nPos := Ascan(aContent,{ |x| x[3] == _cVAL })

	If  nPos > 0
		cRet := aContent[nPos][4]
	EndIf

Elseif cFunc == "2" //Validar
	cRet := .T.
	if Empty(_cVAL)
		cMSG := "( Codigo do Aprovador, n„o est· preenchido! )"
		cRet := .F.
	else
		if (Ascan(aContent,{ |x| Alltrim(x[3]) == Alltrim(_cVAL) }) == 0 )
			cMSG := "( CÛdigo de Aprovador informado, n„o est· na listagem de aprovadores! )"
			cRet := .f.
		else
			cA2CDUSR := Alltrim(Posicione("SA2",1, xFilial("SA2")+ SZW->ZW_FORNECE+SZW->ZW_LOJA,"A2_XCDUSR") )
			if ( Alltrim(cA2CDUSR) == Alltrim(_cVAL) )
				cMSG := "( Aprovador n„o pode ser o Fornecedor! )"	
				cRet := .f.
			endif
		endif		
	endIf

	if !(cRet)
		Aviso( "MNT AP","Selecione um aprovador, valido!"+CRLF+cMSG ,{"Ok"},1)	
	endif

EndIf

Return(cRet)