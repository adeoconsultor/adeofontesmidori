#Include "Protheus.ch"
#Include "Colors.ch"

#DEFINE D_PRELAN	"9"

STATIC __lBlind  := IsBlind()
STATIC __aRptLog := {}
STATIC __cTEMPOS := ""

STATIC lAtSldBase
STATIC lCusto
STATIC lItem
STATIC lClVl
STATIC lCtb350Ef
STATIC lEfeLanc
STATIC lCT350TRC
STATIC lCT350TSL
STATIC nQtdEntid
STATIC lUsaProc := .F.
STATIC _oCTBA350
STATIC __nTamCT2	:= TamSX3("CT2_VALOR")[1]
STATIC __nDecCT2	:= TamSX3("CT2_VALOR")[2]

/*
* Funcao : XAPRCT2
* Autor  : AOliveira 
* Data   : 12-11-2019                  
* Descr  : Rotina tem como objetivo realizar a gravação da 
*          efetivação do Lançamento contabil.
*/
User Function XAPRCT2()
      
Local nX
Local cFiltro  := ""
Local aLegenda := {}

Private oBrowse
Private aRotina := {}

Private cCadastro 	:= OemToAnsi(" ") // "Lan‡amentos Cont beis - Automaticos"
Private dDataLanc
Private cLote
Private cLoteSub 	:= GetMv("MV_SUBLOTE")
Private cSubLote 	:= cLoteSub
Private lSubLote 	:= Empty(cSubLote)
Private cDoc

Private __lCusto	:= .F.
Private __lItem 	:= .F.
Private __lCLVL		:= .F.
Private aCtbEntid

DbSelectArea("CT2")
DbSetOrder(1)
 
AADD(aRotina,{"Pesquisar"  ,"AxPesqui"   , 0 , 1,,.F.}) // "Pesquisar"
AADD(aRotina,{"Visualizar" ,"Ctba102Cal" , 0 , 2     }) // "Visualizar"
AADD(aRotina,{"Aprovar"    ,"u_APRCT2A"  , 0 , 3     }) // "Aprovar"
                                                				
//AADD(aLegenda,{cRegra,cCor,cTitulo})
AADD(aLegenda,{'CT2->CT2_XSITUA = "S" ' ,"f5_verd",'Aprovado'}) //Aprovação
AADD(aLegenda,{'CT2->CT2_XSITUA = "N" .OR. CT2->CT2_XSITUA = " " ',"f5_verm",'Aguardando Aprovação'}) //Aguardando Aprovação

oBrowse := FWMBrowse():New()

oBrowse:SetAlias("CT2")
oBrowse:SetDescription("Aprovação de Lançamentos") 

//aLegenda := CtbLegenda("CT2")
For nX := 1 To Len(aLegenda)
	oBrowse:AddLegend( aLegenda[nX,1],  aLegenda[nX,2] ,  aLegenda[nX,3] )
Next
If !Empty( cFiltro )
	oBrowse:SetFilterDefault( cFiltro )
EndIf
  
oBrowse:Activate()

Return()                                            

/*
* Funcao: APRCT2A()
* Autor : AOliveira / 12-11-2019.
* Descr : Rotina tem como objetivo realizar a gravação da 
*         efetivação do Lançamento contabil.
*/
User Function APRCT2A() 
Local lRet  
Local X   
Local aAreaCT2 := CT2->(GetArea())

Local lAprvOK  := .F.
Local lAprvNOK := .F.
    
//CT2->CT2_XUSR   :=  //-  Usuario Inclui
//CT2->CT2_XUSRAP :=  Alltrim(RetCodUsr())              //-  Usuario Aprova

If ( Alltrim(CT2->CT2_XSITUA) == "S" )
	Aviso("Atenção","Registro já se encontra APROVADO!",{"Ok"},1)

elseif (Alltrim(CT2->CT2_XUSR) == Alltrim(RetCodUsr()) )
	Aviso("Atenção","O aprovador não pode, aprovar os seus próprios lançamentos!",{"Ok"},1)

Else                                                     

	//Variaveis utilizadas para parametros

	mv_par01 := CT2->CT2_LOTE    // Numero do Lote Inicial  
	mv_par02 := CT2->CT2_LOTE    // Numero do Lote Final
	mv_par03 := CT2->CT2_DATA    // Data Inicial
	mv_par04 := CT2->CT2_DATA    // Data Final
	mv_par05 := 1                // Efetiva sem Bater Lote? (1=Sim, 2=Nao)
	mv_par06 := 1                // Efetiva sem Bater Documento? (1=Sim, 2=Nao)
	mv_par07 := "1"               // Efetiva para saldo? (Real/Gerencial/Orcado)
	mv_par08 := 2                // Verifica entidades contabeis? (1=Sim,2=Nao)
	mv_par09 := CT2->CT2_SBLOTE  // SubLote Inicial?
	mv_par10 := CT2->CT2_SBLOTE  // SubLote Final?
	mv_par11 := 1                // Mostra Lancamento Contabil?  Sim/Nao
	mv_par12 := 1                // Modo Processamento (1=Efetivacao, 2=Simulacao)
	mv_par13 := CT2->CT2_DOC     // Documento Inicial
	mv_par14 := CT2->CT2_DOC     // Documento Final                            
	                         
	cQry := "" +CRLF
	cQry += " SELECT CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_TPSALD, R_E_C_N_O_ "+CRLF
	cQry += " FROM "+RetSQLNAME("CT2")+" "+CRLF
	cQry += " WHERE CT2_FILIAL = '"+xFilial("CT2")+"' "+CRLF
	cQry += " AND CT2_DATA Between '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"' "+CRLF
	cQry += " AND CT2_LOTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' " +CRLF
	cQry += " AND CT2_SBLOTE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "+CRLF
	cQry += " AND CT2_DOC BETWEEN '"+mv_par13+"' AND '"+mv_par14+"' "+CRLF
	cQry += " AND CT2_TPSALD = '9' "+CRLF
	cQry += " AND D_E_L_E_T_ = ' ' "+CRLF
	                         
	MPSysOpenQuery( cQry, "TRW" )
    
	aCT2Recno := {}
	DbSelectArea("TRW")
	TRW->(DbGotop()) 
	While !TRW->(Eof()) 
		AAdd(aCT2Recno,TRW->R_E_C_N_O_)
		TRW->(DbSkip())
	EndDo
	TRW->(DbCloseArea())
	                               
	If (Len(aCT2Recno)  > 0 )	                            
	
		//Efetiva os pre-lancamentos   	
		EFETCT2(.T.) //CTBA350(.T.)       
	
		For X:= 1 To Len(aCT2Recno)	

        	DbSelectArea("CT2")
        	CT2->(dbGoto(aCT2Recno[X]))

			//Se Efetivou
			If CT2->CT2_TPSALD <> '9'
				
				DbSelectArea("CT2")
				RecLock("CT2",.F.)
				
				//CT2->CT2_XUSR   :=  //-  Usuario Inclui
				//CT2->CT2_XUSRN1 :=  //-  Nome user Inclui
				//CT2->CT2_XDTINI :=  //-  Data Inclui
				CT2->CT2_XSITUA :=  "S"                               //-  Situa     
				CT2->CT2_XUSRAP :=  Alltrim(RetCodUsr())              //-  Usuario Aprova
				CT2->CT2_XUSRN2 :=  Alltrim(UsrRetName(RetCodUsr()))  //-  Nome user Aprova
				CT2->CT2_XDTFIM :=  dDataBase                         //-  Data Aprova
				CT2->(MsUnLock())   
				//Aviso("Atenção","Aprovação concluida com sucesso!",{"Ok"},1)
				if !lAprvOK
					lAprvOK := .T.
				endif   

			Else                                                      
				//Aviso("Atenção","Erro ao realizar aprovação.",{"Ok"},1)
				if !lAprvNOK
					lAprvNOK := .T.
				endif
				
			EndIf  			      	 
  
		Next X

		if lAprvNOK
			Aviso("Atenção","Erro ao realizar aprovação.",{"Ok"},1)	
			lAprvOK := .F.
		endif

		if lAprvOK
			Aviso("Atenção","Aprovação concluida com sucesso!",{"Ok"},1)	
		endif

    Else
    	Aviso("Atenção","Sem dados para efetivar.",{"Ok"},1)	
	EndIf
	//Aviso("Atenção","ROTINA EM DESENVOLVIMENTO.",{"Ok"},1)
EndIf 
    
RestArea(aAreaCT2)

Return(lRet)

/*
* Função : EFETCT2
* Autor  : AOliveira 
* Data   : 12-11-2019  
*/
Static Function EFETCT2(lAutomato)

Local nOpca		:= 0
Local aSays		:= {}, aButtons := {}
Local aCampos	:= {{"DDATA"	,"C"	,10							,0			},;
					{"LOTE"		,"C"	,TamSX3("CT2_LOTE")[1]		,0			},;
					{"DOC"		,"C"	,TamSX3("CT2_DOC")[1]		,0			},;
					{"MOEDA"	,"C"	,TamSX3("CT2_MOEDLC")[1]	,0			},;
					{"VLRDEB"	,"N"	,__nTamCT2					,__nDecCT2	},;
					{"VLRCRD"	,"N"	,__nTamCT2					,__nDecCT2	},;
					{"DESCINC"	,"C"	,80							,0			}}

Local lRet		:= .T.
Local nCont		:= 0
Local nX
Local nThread	:= GetNewPar( "MV_CT350TH", 1 )
Local nSeconds	:= 0

Private cCadastro := OemToAnsi(OemtoAnsi("Efetivacao de Pre-Lancamentos"))  //"Efetivacao de Pre-Lancamentos"

PRIVATE titulo    := OemToAnsi("Log Validacao Efetivacao")  //"Log Validacao Efetivacao"
PRIVATE cCancel   := OemToAnsi("***** CANCELADO PELO OPERADOR *****")  //"***** CANCELADO PELO OPERADOR *****"

Private aCtbEntid

Default lAutomato := .F.

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return()
EndIf

If nQtdEntid == NIL
	nQtdEntid := CtbQtdEntd()//sao 4 entidades padroes -> conta /centro custo /item contabil/ classe de valor
EndIf

If aCtbEntid == NIL
	aCtbEntid := Array(2,nQtdEntid)  //posicao 1=debito  2=credito
EndIf

//DEBITO
aCtbEntid[1,1] := {|| TMP->CT2_DEBITO   }
aCtbEntid[1,2] := {|| TMP->CT2_CCD      }
aCtbEntid[1,3] := {|| TMP->CT2_ITEMD    }
aCtbEntid[1,4] := {|| TMP->CT2_CLVLDB   }
//CREDITO
aCtbEntid[2,1] := {|| TMP->CT2_CREDITO  }
aCtbEntid[2,2] := {|| TMP->CT2_CCC      }
aCtbEntid[2,3] := {|| TMP->CT2_ITEMC    }
aCtbEntid[2,4] := {|| TMP->CT2_CLVLCR   }

For nX := 5 TO nQtdEntid
	aCtbEntid[1, nX] := MontaBlock("{|| TMP->CT2_EC"+StrZero(nX,2)+"DB } ")  //debito
	aCtbEntid[2, nX] := MontaBlock("{|| TMP->CT2_EC"+StrZero(nX,2)+"CR } ")  //credito
Next

lAtSldBase	:= ( GetMv("MV_ATUSAL") == "S" )
lCusto		:= CtbMovSaldo("CTT")
lItem 		:= CtbMovSaldo("CTD")
lClVl		:= CtbMovSaldo("CTH")
lCtb350Ef	:= ExistBlock("CTB350EF")
lEfeLanc 	:= ExistBlock("EFELANC")
lCT350TRC	:= GetNewPar( "MV_CT350TC", .F.)			///PARAMETRO NÃO PUBLICADO NA CRIAÇÃO (15/03/07-BOPS120975)
lCT350TSL	:= GetNewPar( "MV_CT350SL", .T.)			///PARAMETRO NÃO PUBLICADO NA CRIAÇÃO (15/03/07-BOPS120975)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01 // Numero do Lote Inicial                           ³
//³ mv_par02 // Numero do Lote Final                             ³
//³ mv_par03 // Data Inicial                                     ³
//³ mv_par04 // Data Final                                       ³
//³ mv_par05 // Efetiva sem Bater Lote?                          ³
//³ mv_par06 // Efetiva sem Bater Documento?                     ³
//³ mv_par07 // Efetiva para sald?Real/Gerencial/Orcado          ³
//³ mv_par08 // Verifica entidades contabeis?                    ³
//³ mv_par09 // SubLote Inicial?                                 ³
//³ mv_par10 // SubLote Final?                                   ³
//³ mv_par11 // Mostra Lancamento Contabil?  Sim/Nao             ³
//³ mv_par12 // Modo Processamento                               ³
//³ mv_par13 // Documento Inicial                                ³
//³ mv_par14 // Documento Final                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Pergunte( "CTB350" , .F. )


/*
mv_par01 := CT2->CT2_LOTE    // Numero do Lote Inicial
mv_par02 := CT2->CT2_LOTE    // Numero do Lote Final
mv_par03 := CT2->CT2_DATA    // Data Inicial
mv_par04 := CT2->CT2_DATA    // Data Final
mv_par05 := 1                // Efetiva sem Bater Lote? (1=Sim, 2=Nao)
mv_par06 := 1                // Efetiva sem Bater Documento? (1=Sim, 2=Nao)
mv_par07 := ""               // Efetiva para saldo? (Real/Gerencial/Orcado)
mv_par08 := 2                // Verifica entidades contabeis? (1=Sim,2=Nao)
mv_par09 := CT2->CT2_SBLOTE  // SubLote Inicial?
mv_par10 := CT2->CT2_SBLOTE  // SubLote Final?
mv_par11 := 1                // Mostra Lancamento Contabil?  Sim/Nao
mv_par12 := 1                // Modo Processamento (1=Efetivacao, 2=Simulacao)
mv_par13 := CT2->CT2_DOC     // Documento Inicial
mv_par14 := CT2->CT2_DOC     // Documento Final
*/

AADD(aSays,OemToAnsi( "Transfere os lancamentos indicados com status pre-lancamento (que nao controla saldos)" ) )  //"Transfere os lancamentos indicados com status pre-lancamento (que nao controla saldos)"
AADD(aSays,OemToAnsi( "para o saldo informado, acompanhando relatorio de confirmacao do processamento." ) )         //"para o saldo informado, acompanhando relatorio de confirmacao do processamento."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o log de processamento                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogIni( aButtons )

AADD(aButtons, { 5,.T.,{|| Pergunte("CTB350",.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca:= 1, If( ConaOk(), FechaBatch(), nOpca:=0 ) }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

PcoIniLan("000082")

If !lAutomato
	FormBatch( cCadastro, aSays, aButtons,, 160 )
Else
	nOpca:= 1
Endif

//-----------------------------------------------------
// Crio tabela temporaroa p/ gravar as inconsistencias
//-----------------------------------------------------
CriaTmp(aCampos)

If nOpca == 1
	//Verificar se o calendario esta aberto para poder efetuar a efetivacao.
	//Somente verificar a data inicial.
	For nCont := 1 To __nQuantas
		If CtbExisCTE( StrZero(nCont,2),Year(mv_par03) )
			
			lRet := CtbStatus(StrZero(nCont,2),mv_par03,mv_par04, .F.)
			If !lRet
				nOpca	:= 0
				Exit
			EndIf
		Endif
	Next
	
	If ! lCT350TSL
		MsgInfo("Após as efetivações do periodo, para emissao de relatórios executar 'Reprocessamento de Saldos' do periodo/data.","ATENÇÃO ! At. de saldos desligada, MV_CT350SL (L) = F ") //"Após as efetivações do periodo, para emissao de relatórios executar 'Reprocessamento de Saldos' do periodo/data.","ATENÇÃO ! At. de saldos desligada, MV_CT350SL (L) = F "
		lAtSldBase := .F.
	EndIf
	
EndIf

IF nOpca == 1
	nSeconds := Seconds()
	Conout("INICIO" + "|" + dtoc(dDatabase) + "|" + Time() + "|" + AllTrim(Str(nSeconds))) //"INICIO"

	// efetuo a criação da procedure que irá alimentar os dados para o relatorio.
	lUsaProc := CriaProc()

	If FindFunction("CTBSERIALI")
		While !CTBSerialI("CTBPROC","ON")
		EndDo
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("INICIO") //"INICIO"
	lEnd := .F.
	If nThread <= 1
		Processa({|lEnd| Ctb350Proc(@lEnd)},cCadastro)
	Else
		Processa({|lEnd| Ctb351Proc(@lEnd)},cCadastro)
	Endif

	CTBSerialF("CTBPROC","ON")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("FIM") //"FIM"

	If lUsaProc
		If TCSPExist("CTB350REL_" + cEmpAnt )
			CtbSqlExec( "Drop procedure CTB350REL_" + cEmpAnt )
		Endif	
	Endif

	Conout("TERMINO" + "|" + dtoc(dDatabase) + "|" + Time() + "|" + AllTrim(Str(Seconds())) + "| " + "Tempo Gasto:" + AllTrim(Str(Seconds() - nSeconds)) ) //"TERMINO"###"Tempo Gasto:"
Endif

PcoFinLan("000082")

// efetua a exclusão do arquivo temporario
DeleteTmp()

dbSelectArea("CT2")
dbSetOrder(1)

Return()   


/*
* Funcao : CriaTmp
* Autor  : AOliveira 
* Data   : 12-11-2019 
* Uso    : Cria a tabela temporaria a ser usada na impressão do relatorio
*/
Static Function CriaTmp( aCampos)
Local aArea	:= GetArea()
Local cArq	:= "TRB350REL"

DeleteTmp()

_oCTBA350 := FWTemporaryTable():New(cArq)
_oCTBA350:SetFields(aCampos)
_oCTBA350:AddIndex("1",{"DDATA","LOTE","DOC"})

_oCTBA350:Create()

RestArea(aArea)

Return()

/*
*Funcao  : DeleteTmp
* Autor  : AOliveira 
* Data   : 12-11-2019 
* Uso    : Executa a instrução de exclusão do temporario do banco
*/
Static Function DeleteTmp()
Local aArea := GetArea()

If _oCTBA350 <> Nil
	_oCTBA350:Delete()
	_oCTBA350 := Nil
Endif

RestArea(aArea)

Return()

/*
* Funcao : CtbSqlExec
* Autor  : AOliveira 
* Data   : 12-11-2019 
* Uso    : Executa a instrução de banco via TCSQLExec
*/
Static Function CtbSqlExec( cStatement )
Local bBlock	:= ErrorBlock( { |e| ChecErro(e) } )
Local lRetorno	:= .T.

BEGIN SEQUENCE
	IF TcSqlExec(cStatement) <> 0
		UserException( "Erro na instrução de execução do SQL" + CRLF + TCSqlError()  + CRLF + ProcName(1) + CRLF + cStatement ) //"Erro na instrução de execução do SQL"
		lRetorno := .F.
	Endif
RECOVER
	lRetorno := .F.
END SEQUENCE
ErrorBlock(bBlock)

Return lRetorno

      
/*
* Funcao : CtbExisCTE
* Autor  : AOliveira 
* Data   : 12-11-2019 
*/

Static Function CtbExisCTE( cMoeda, cAno )
Local aArea	:= GetArea()
Local lRet	:= .F.

DbSelectArea( 'CTE' )
DbSetOrder( 1 )
If MsSeek( xFilial( 'CTE' ) + cMoeda )
	DbSelectArea("CTG")
	DbSetOrder(1)
	If MsSeek(xFilial("CTG")+CTE->(CTE_CALEND)+Str(cAno))
		lRet := .T.
	EndIf
EndIf

RestArea( aArea )

Return lRet

/*
* Funcao : CtbCriaProc()
* Autor  : AOliveira 
* Data   : 12-11-2019 
* Uso    : Executa a instrução de banco via TCSQLExec
*/
Static Function CriaProc()
Local cQuery	:= ""
Local nPTratRec	:= 0
Local lOk		:= .T.
Local cNomeTab	:= ""

//----------------------------------------------------------------------------------------------
// Exclusao da procedure pois o FWTemporaryTable fornece um novo nome de tabela a cada execucao
//----------------------------------------------------------------------------------------------
If TCSPExist("CTB350REL_" + cEmpAnt )
	CtbSqlExec( "Drop procedure CTB350REL_" + cEmpAnt )
Endif	

//-----------------------------
// Obtem o nome real da tabela
//-----------------------------
If _oCTBA350 <> Nil
	cNomeTab := _oCTBA350:GetRealName()
EndIf

cQuery := "Create Procedure CTB350REL_" + cEmpAnt + "(" + CRLF
cQuery += "    @IN_DDATA      Char( 10 )," + CRLF
cQuery += "    @IN_LOTE       Char( " + StrZero(TAMSX3('CT2_LOTE')[1],2) + " )," + CRLF
cQuery += "    @IN_DOC        Char( " + StrZero(TAMSX3('CT2_DOC' )[1],2) + " )," + CRLF
cQuery += "    @IN_MOEDA      Char( " + StrZero(TAMSX3('CT2_MOEDLC' )[1],2) + " )," + CRLF
cQuery += "    @IN_VLRDEB     Float," + CRLF
cQuery += "    @IN_VLRCRD     Float," + CRLF
cQuery += "    @IN_DESCINC    Char( 80 )," + CRLF
cQuery += "    @OUT_RESULT    Char( 01 ) OutPut" + CRLF
cQuery += "    " + CRLF
cQuery += ")" + CRLF
cQuery += "as" + CRLF
cQuery += "    " + CRLF
cQuery += "begin" + CRLF
cQuery += "    select @OUT_RESULT = '0'" + CRLF
cQuery += "    " + CRLF
cQuery += "    begin tran" + CRLF
cQuery += "    INSERT INTO TRB350REL ( DDATA, LOTE, DOC, MOEDA, VLRDEB, VLRCRD, DESCINC, D_E_L_E_T_ ) " + CRLF
cQuery += "                   VALUES ( @IN_DDATA, @IN_LOTE, @IN_DOC, @IN_MOEDA, @IN_VLRDEB, @IN_VLRCRD, @IN_DESCINC , ' ' )" + CRLF
cQuery += "    commit tran " + CRLF
cQuery += "    " + CRLF
cQuery += "    select @OUT_RESULT = '1'" + CRLF
cQuery += "End" + CRLF
cQuery += "    " + CRLF

cQuery := CtbAjustaP(.T., cQuery, @nPTratRec)
cQuery := MsParse(cQuery,If(Upper(TcSrvType())= "ISERIES", "DB2", Alltrim(TcGetDB())),.F.)
cQuery := CtbAjustaP(.F., cQuery, nPTratRec)

//---------------------------------------------------------------------------------------------------------
// Esta adequacao foi implementada pois o nome real da tabela criada no SQL fazia o MSParse apagar a query
//---------------------------------------------------------------------------------------------------------
cQuery := StrTran( cQuery,"TRB350REL",cNomeTab)

If !TCSPExist( "CTB350REL_" + cEmpAnt )
	lOk := CtbSqlExec(cQuery)
EndIf

Return lOk