#include "totvs.ch"
#Include "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMata024   บAutor  ณJuliana Taveira     บ Data ณ  30/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณApuracao Cat 83											  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
User Function Tnga024()

Local cCadastro := "Apuracao CAT83" //"Apuracao CAT83"
Local aSays		:= {}
Local aButtons	:= {}
LOCAL nOpca 	:= 0
LOCAL aCAP		:= {"Confirma","Abandona","Parโmetros"}  //"Confirma"###"Abandona"###"Parmetros"
Local cPerg		:=	"MTA024"
LocaL cTitulo	:=	"Apuracao CAT83" //"Apuracao CAT83"
Local cText1	:=	"Este programa faz a Apurao de ICMS, conforme parmetros " //"Este programa faz a Apurao de ICMS, conforme parmetros "
Local cText2	:=	"informados pelo usuario." //"informados pelo usu rio."
Local cMV_Estado:=	SuperGetMv("MV_ESTADO")	// Def. estado empresa
Local lAborta   := .F.   

PRIVATE aRotina := {	{ OemToAnsi("Pesquisar")		,"AxPesqui"  	,0,1},;	 //"Pesquisar"
						{ OemToAnsi("Visual")		,"AxAlter"		,0,2},;	 //"Visual"
						{ OemToAnsi("Incluir")		,"AxInclui"		,0,3},;	 //"Incluir"
						{ OemToAnsi("Alterar")		,"AxAlter"		,0,4},;  //"Alterar"
						{ OemToAnsi("Exclusao")		,"AxAlter"		,0,5} }  //"Exclusao"

If !SuperGetMV("MV_CAT8309",,.F.) 
	MsgAlert("Verifique o conte๚do do parโmetro MV_CAT8309. Caso nใo exista, execute o UPDFIS para atualiza็ใo de dicionแrio.")
	lAborta := .T.
Else
    If cMV_Estado <> "SP"
    	MsgAlert("Esta rotina s๓ deve ser executada para o estado de Sใo Paulo.")
        lAborta := .T.
    Else
        DbSelectArea ("CDZ")	//Cod.lcto cat83
        CDZ->(DbSetOrder (1))
        DbGoTop()     
        If Eof()
        	MsgAlert("ษ necessแrio fazer o cadastramento dos c๓d.lcto Cat83 primeiro, atrav้s da rotina Atualiza็๕es/Cadastros/Cod.Lcto Cat83.")
            lAborta := .T.
        Else
            DbSelectArea ("CCU")	//Amarracao Ficha x Cod.lcto cat83
            CCU->(DbSetOrder (1))	    
            DbGoTop()     
            If Eof()
        	    MsgAlert("ษ necessแrio fazer o relacionamento das fichas com os c๓d.lcto Cat83 primeiro, atrav้s da rotina Atualiza็๕es/Cadastros/Amarra็ใo Ficha x Cod.Lcto Cat83.")
    	        lAborta := .T.
    	    EndIf
    	EndIf
    EndIf
EndIf    

If !lAborta	
   	AjustaSX1()  
	Pergunte(cPerg,.F.)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Janela Principal ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	While .T.
		AADD(aSays,OemToAnsi( ctext1 ) )
		AADD(aSays,OemToAnsi( cText2 ) )
		AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
		AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
		AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
		FormBatch( cCadastro, aSays, aButtons )

		Do Case
			Case nOpca ==1
				Processa({||A024Processa()})
			Case nOpca==3
				Pergunte(cPerg,.t.)
				Loop
		EndCase
		Exit
	EndDo
EndIf	
Return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑบFuncao    ณA024ProcessaบAutor  ณAndreia dos Santos     บ Data ณ 09/08/2001บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑบDesc.     ณApuracao CAT83                                                 บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
Static Function A024Processa()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                             ณ
//ณ mv_par01  // Mes de Apuracao			   	                	 ณ
//ณ mv_par02  // Ano da Apuracao                                     ณ
//ณ mv_par03  // Considera Filiais( Sim/Nao )                        ณ
//ณ mv_par04  // Da Filial                                           ณ
//ณ mv_par05  // Ate a Filial                                        ณ
//ณ mv_par06  // Seleiona Filiais ( Sim/Nao )                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nMes		:= mv_par01
Local nAno		:= mv_par02
Local nConsFil  := mv_par03                               
Local cFilDe	:= mv_par04 
Local cFilAte	:= mv_par05
Local nApuracao := 0
Local nPeriodo  := 1
Local lFiliais  := If(mv_par06==1,.T.,.F.) 
Local aDatas    := {}
Local dDtIni    := ""
Local dDtFim    := ""
Local cTitulo	:= ""
Local cErro		:= ""
Local cSolucao	:= ""
Local aLisFil	:= {}
//Local aEmpCorr  := {cEmpAnt, cFilAnt}

Private cCadastro := "Apuracao de CAT83"                          //"Apuracao de CAT83"                         
    
nApuracao := 3 //mensal
nPeriodo  := 1 //primeiro
aDatas	  := DetDatas(nMes,nAno,nApuracao,nPeriodo)     //se encontra em Fisxpur
dDtIni    := aDatas[1]
dDtFim	  := aDatas[2]

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSomente sera permitido processar filial de/ate se o processamento for consolidado.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If (nConsFil == 1 .And. !(cFilDe <= cFilAnt .Or. cFilAnt >= cFilAte)) .Or.;
   (nConsFil == 1 .And.  (cFilDe == "" .Or. cFilAte == ""))
	cTitulo 	:= "Processamento Consolidado"  				//"Processamento Consolidado"	    
	cErro		:= "O processamento consolidado (filial de/at้) somente poderแ ser executado "  					//"O processamento consolidado (filial de/at้) somente poderแ ser executado " 
	cErro		+= "se a filial inicial (filial de) for a filial consolidadora, ou seja, ser " 					//"se a filial inicial (filial de) for a filial consolidadora, ou seja, ser "
	cErro		+= "a filial da empresa selecionada no momento do processamento da rotina. No momento, a " 					//"a filial da empresa selecionada no momento do processamento da rotina. No momento, a "
	cErro		+= "filial selecionada ้ a "  + cFilAnt 		//"filial selecionada ้ a " 
	cErro		+= ", e a filial inicial informada a ser processada foi a " + cFilDe + "." 	//", e a filial inicial informada a ser processada foi a "
	cSolucao	:= "Efetue o processamento consolidado da apura็ใo CAT83 apenas na empresa " 					//"Efetue o processamento consolidado da apura็ใo CAT83 apenas na empresa "
	cSolucao	+= "consolidadora. Exemplo: caso queira efetuar a apura็ใo da filial " + cFilDe 		//"consolidadora. Exemplo: caso queira efetuar a apura็ใo da filial "
	cSolucao	+= "selecione a filial " + cFilDe 		//"selecione a filial "
	cSolucao	+= " antes de efetuar o processamento da rotina." 		 					//" antes de efetuar o processamento da rotina." 		
	xMagHelpFis(cTitulo,cErro,cSolucao)
	Return
Endif
If lFiliais
	aLisFil  :=MatFilCalc(lFiliais)
	nConsFil :=1
EndIf     

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefinicao da ordem das tabelasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea ("SX5")	//Tabelas Genericas
SX5->(DbSetOrder (1))
DbSelectArea ("SF4")	//Cadastro de TES
SF4->(DbSetOrder (1))
DbSelectArea ("SF5")	//Tipos de Movimentacoes
SF5->(DbSetOrder (1))
DbSelectArea ("SD1")	//Itens das Nfs de Entrada
SD1->(DbSetOrder (1))
DbSelectArea ("SD2")	//Itens das Nfs de Saida
SD2->(DbSetOrder (3))
DbSelectArea ("SD3")	//Movimentacao Interna
SD3->(DbSetOrder (3))
DbSelectArea ("SB1")	//Cadastro de Produtos
SB1->(DbSetOrder (1))	

A024Apura(dDtIni,dDtFim,nConsFil,cFilDe,cFilAte,nAno,nMes,@aLisFil)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณA024Apura  ณAutor  ณAndreia dos Santos    ณ Data ณ 20/08/01 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDesc.     ณ Apura os valores do periodo                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
Static Function A024Apura(dDtIni,dDtFim,nConsFil,cFilDe,cFilAte,nAno,nMes,aLisFil)
//Local cFiltro	:=	""
Local cPeriodo  := ""
Local cCodPro   := ""
Local cFilial   := ""   

Default aLisFil := {}

Private cFicha1A := "" 
Private cFicha1B := ""
Private cFicha1C := ""
Private cFicha1D := ""
Private cFicha1E := ""
Private cFicha2A := ""
Private cFicha2B := ""
Private cFicha2C := ""
Private cFicha2D := ""
Private cFicha2E := ""
Private cFicha2F := ""
Private cFicha2G := ""    
Private cFicha3A := ""    
Private cFicha3B := ""    
Private cFicha3C := ""  
Private aMovim   := {}      
Private cFicha   := ""
Private cCodLan  := ""
Private cEspecie := ""       

cPeriodo := StrZero(nAno,4)+StrZero(nMes,2)		
MontFicha()

DbSelectArea ("SM0")
SM0->(DbGoTop())
SM0->(DbSeek(cEmpAnt+cFilDe, .T.))	//Pego a filial mais proxima

ProcRegua( SB1->(RecCount()) * SM0->(RecCount()) )

Do While !SM0->(Eof ()) .And. (cEmpAnt==SM0->M0_CODIGO) .And. (SM0->M0_CODFIL<=cFilAte)
	cFilAnt := SM0->M0_CODFIL
	cMvEstado := GetMv("MV_ESTADO") 	

	IncProc("Zerando CDW e CDU")

    ZeraMov(cPeriodo,cFilAnt)
//    Alert("ZERADO....")
    IncProc("Processando Movimenta็๕es internas")
     	
 	aMovim := ProcMovim(dDtIni, dDtFim, cPeriodo)
    If Len(aMovim) > 0
        GravMov(cPeriodo, dDtIni, dDtFim) 
    Endif
 	
	DbSelectArea ("SB1")
	If !Empty(MV_PAR05)
		SB1->(DBSeek(xFilial("SB1") + MV_PAR07, .T.))
	Else
		SB1->(DbGoTop ())
	EndIf	
//006963
//002541 	
	
	////////////////////////////////////////////////////////////////////////////////
	//Query Incluida por Anesio para agilizar o processamento....
	////////////////////////////////////////////////////////////////////////////////
	cQSB1 := " Select distinct CODIGO, B1_CODLAN from ( "
//	cQSB1 += " Select Distinct D3_COD CODIGO from SD3010 SD3 " 
//	cQSB1 += " where SD3.D_E_L_E_T_ =' ' "
//	cQSB1 += " and D3_FILIAL ='"+cFilAnt+"' " 
//	cQSB1 += " and Substring(D3_EMISSAO,1,6) = '"+cPeriodo+"' " 
//	cQSB1 += " union all " 
	cQSB1 += " Select distinct D2_COD CODIGO from SD2010 SD2 " 
	cQSB1 += " where SD2.D_E_L_E_T_ =' ' " 
	cQSB1 += " and D2_FILIAL = '"+cFilAnt+"' " 
	cQSB1 += " and Substring(D2_EMISSAO,1,6) = '"+cPeriodo+"' " 
//	cQSB1 += " AND D2_COD in ('006963','002541','002558','001495','006064','030858') "
	cQSB1 += " union all "
	cQSB1 += " Select distinct D1_COD CODIGO from SD1010 SD1 "
	cQSB1 += " where SD1.D_E_L_E_T_ =' ' "
	cQSB1 += " and D1_FILIAL ='"+cFilAnt+"' " 
//	cQSB1 += " AND D1_COD in ('006963','002541','002558','001495','006064','030858') "
	cQSB1 += " and Substring(D1_DTDIGIT,1,6) = '"+cPeriodo+"' ) MOV_MES, SB1010 SB1 "
	cQSB1 += " where SB1.D_E_L_E_T_ =' ' AND CODIGO = B1_COD " 
	cQSB1 += " order by 1 "
	
	if Select("TMPB1") > 0 
		dbSelectArea("TMPB1")
		TMPB1->(dbCloseArea())
	endif
	
	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQSB1), "TMPB1", .T., .T. )
	
	dbSelectArea("TMPB1")
	TMPB1->(dbGotop())
	////////////////////////////////////////////////////////////////////////////////
	//FINAL QUERY PARA AGILIZAR PROCESSAMENTO
	////////////////////////////////////////////////////////////////////////////////
	
	ProcRegua( TMPB1->(RecCount()))
	//While !SB1->(Eof ()) .And. IIf(!Empty(MV_PAR08), SB1->B1_COD <= MV_PAR08, .T.) //Comentado para testar a query acima
	While !TMPB1->(Eof())

		cProd   := TMPB1->CODIGO+xFilial("SB1")
		cCodPro := TMPB1->CODIGO
		cFicha  := ""
   		cCodLan := Iif(!Empty(TMPB1->(FieldPos("B1_CODLAN"))),TMPB1->B1_CODLAN, "")					                                                       
	   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	   //ณBusca notas fiscais do produto e periodo  ณ
	   //ณinformados no parametro                   ณ
	   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aMovim := ProcEntr(cCodPro, dDtIni, dDtFim, cCodLan, cPeriodo) 
		If Len(aMovim) > 0
		    GravMov(cPeriodo, dDtIni, dDtFim) 
		EndIf
	    aMovim := ProcDevl(cCodPro, dDtIni, dDtFim, cCodLan, cPeriodo)
		If Len(aMovim) > 0
		    GravMov(cPeriodo, dDtIni, dDtFim) 
		EndIf
	    aMovim := ProcSaid(cCodPro, dDtIni, dDtFim, cCodLan, cPeriodo)
	    If Len(aMovim) > 0
	        GravMov(cPeriodo, dDtIni, dDtFim) 
		EndIf
	  	IncProc("Calculando produto " + AllTrim(TMPB1->CODIGO))		
		TMPB1->(DbSkip())        
	EndDo   
          
    DbSelectArea ("SM0")       
	SM0->(DbSkip())
EndDo
dbSelectArea("TMPB1")
TMPB1->(dbCloseArea())
Return(.t.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณAjustaSX1 ณ Autor ณ Marcelo Alexandre     ณ Data ณ01.05.2008ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณCria as perguntas necesarias para o programa                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณNenhum                                                      ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao Efetuada                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
Static Function AjustaSX1()
Local	aHelpPor := {}
Local	aHelpEng := {}                                     
Local	aHelpSpa := {}
Local 	nTamSx1Grp :=Len(SX1->X1_GRUPO)

dbSelectArea("SX1")
dbSetOrder(1)

aHelpPor :={}
aHelpEng :={}
aHelpSpa :={}
Aadd (aHelpPor, "mes de apuracao." ) //"mes de apuracao." 
aHelpEng := aHelpSpa := aHelpPor
PutSx1("MTA024","01","mes de apuracao.","mes de apuracao.","mes de apuracao.","mv_ch1","N",2,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)	

aHelpPor :={} 
aHelpEng :={} 
aHelpSpa :={} 
Aadd( aHelpPor, "ano de apuracao") //"ano de apuracao"
aHelpEng := aHelpSpa := aHelpPor
PutSx1("MTA024","02","ano de apuracao","ano de apuracao","ano de apuracao","mv_ch2","N",4,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={} 
aHelpEng :={} 
aHelpSpa :={} 
aHelpEng := aHelpSpa := aHelpPor
PutSx1("MTA024","03","Considera Filiais","Considera Filiais","Considera Filiais","mv_ch3","N",1,0,0,"C","","","","","mv_par03","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
 
aHelpPor :={} 
aHelpEng :={} 
aHelpSpa :={} 
aHelpEng := aHelpSpa := aHelpPor
PutSx1("MTA024","04","Da Filial","Da Filial","Da Filial","mv_ch4","C",4,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={} 
aHelpEng :={} 
aHelpSpa :={} 
aHelpEng := aHelpSpa := aHelpPor
PutSx1("MTA024","05","ate filial","ate filial","ate filial","mv_ch5","C",4,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={} 
aHelpEng :={} 
aHelpSpa :={} 
aHelpEng := aHelpSpa := aHelpPor
PutSx1("MTA024","06","seleciona filiais","seleciona filiais","seleciona filiais","mv_ch6","N",1,0,2,"C","","","","","mv_par06","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={} 
aHelpEng :={} 
aHelpSpa :={} 
aHelpEng := aHelpSpa := aHelpPor
PutSx1("MTA024","07","Da Produto","Da Produto","Da Produto","mv_ch7","C",15,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={} 
aHelpEng :={} 
aHelpSpa :={} 
aHelpEng := aHelpSpa := aHelpPor
PutSx1("MTA024","08","ate produto","ate produto","ate produto","mv_ch8","C",15,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontFicha   บAutor  ณCecilia Carvalho    บ Data ณ  29/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta relacionamento Ficha x Cod.Lacnto                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
Static Function MontFicha()

Local cAliasCCU :=	"CCU"
                         
DbSelectArea (cAliasCCU)
(cAliasCCU)->(DbSetOrder(1))
(cAliasCCU)->(DbGoTop()) 
While !(cAliasCCU)->(Eof())      
   Do Case
      Case (cAliasCCU)->CCU_FICHA == "11"		
	   	   cFicha1A := cFicha1A + (cAliasCCU)->CCU_CODLAN
	  Case (cAliasCCU)->CCU_FICHA == "12" 	
	       cFicha1B := cFicha1B + (cAliasCCU)->CCU_CODLAN
	  Case (cAliasCCU)->CCU_FICHA == "13" 	
		   cFicha1C := cFicha1C + (cAliasCCU)->CCU_CODLAN
	  Case (cAliasCCU)->CCU_FICHA == "14" 	
		   cFicha1D := cFicha1D + (cAliasCCU)->CCU_CODLAN
	  Case (cAliasCCU)->CCU_FICHA == "15" 
		   cFicha1E := cFicha1E + (cAliasCCU)->CCU_CODLAN
	  Case (cAliasCCU)->CCU_FICHA == "21" 	
		   cFicha2A := cFicha2A + (cAliasCCU)->CCU_CODLAN
	  Case (cAliasCCU)->CCU_FICHA == "22" 	
		   cFicha2B := cFicha2B + (cAliasCCU)->CCU_CODLAN  
	  Case (cAliasCCU)->CCU_FICHA == "23" 	
		   cFicha2C := cFicha2C + (cAliasCCU)->CCU_CODLAN 
	  Case (cAliasCCU)->CCU_FICHA == "24" 	
		   cFicha2D := cFicha2D + (cAliasCCU)->CCU_CODLAN
	  Case (cAliasCCU)->CCU_FICHA == "25" 	
		   cFicha2E := cFicha2E + (cAliasCCU)->CCU_CODLAN
	  Case (cAliasCCU)->CCU_FICHA == "26" 	
		   cFicha2F := cFicha2F + (cAliasCCU)->CCU_CODLAN
	  Case (cAliasCCU)->CCU_FICHA == "27" 	
		   cFicha2G := cFicha2G + (cAliasCCU)->CCU_CODLAN
	  Case (cAliasCCU)->CCU_FICHA == "31" 	
		   cFicha3A := cFicha3A + (cAliasCCU)->CCU_CODLAN
	  Case (cAliasCCU)->CCU_FICHA == "32" 	
		   cFicha3B := cFicha3B + (cAliasCCU)->CCU_CODLAN
	  Case (cAliasCCU)->CCU_FICHA == "33" 	
		   cFicha3C := cFicha3C + (cAliasCCU)->CCU_CODLAN		
   EndCase
   (cAliasCCU)->(DbSkip())
EndDo                            
(cAliasCCU)->(DbCloseArea())
Return()
                                                                                                       '
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcEntr  บAutor  ณCecilia Carvalho    บ Data ณ  26/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessa notas fiscais de entrada com tributacao de ICMS    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcCodPro - Produto a ser considerado na busca                บฑฑ
ฑฑบ          ณdDtIni  - Periodo inicial a ser considerado na busca        บฑฑ
ฑฑบ          ณdDtFim  - Periodo final a ser considerado na busca          บฑฑ
ฑฑบ          ณdDtFim  - Periodo final a ser considerado na busca          บฑฑ
ฑฑบ          ณcCodLan - Codigo do lancamento cat83                        บฑฑ
ฑฑบ          ณcPeriodo- Periodo a ser considerado na busca                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
Static Function ProcEntr(cCodPro, dDtini, dDtFim, cCodLan, cPeriodo) 
Local cAlias 	:= GetNextAlias()
Local cIndex   	:= ""    
Local cDtDig    := ""
Local cAuxFic   := ""
Local cAuxLan   := ""
Local nIndex	:= 0
Local nPos      := 0
Local aDados    := {}

#IFDEF TOP                              
	If TcSrvType()<>"AS/400"							          		 
        cAlias := GetNextAlias()   
        BeginSql Alias cAlias
			COLUMN D1_DTDIGIT AS DATE   
			COLUMN D1_EMISSAO AS DATE 
			SELECT SD1.D1_FILIAL, SD1.D1_DTDIGIT, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_FORNECE, SD1.D1_LOJA,
			       SD1.D1_COD, SD1.D1_ITEM, SD1.D1_QUANT, SD1.D1_EMISSAO, SD1.D1_VALIPI, SD1.D1_VALICM, 
			       SD1.D1_BASEICM, SD1.D1_TOTAL, SD1.D1_VALFRE, SD1.D1_SEGURO, SD1.D1_DESPESA, SD1.D1_VALDESC, 
			       SD1.D1_TIPO, SD1.D1_BRICMS, SD1.D1_CF, SD1.D1_TES, SD1.D1_CUSTO, SF1.F1_ESPECIE, SD1.D1_CODLAN,
			       SD1.D1_NUMSEQ 
   		    FROM %table:SD1% SD1 
   		    JOIN %table:SF4% SF4 ON SF4.F4_FILIAL = %xFilial:SF4%
									AND SF4.F4_CODIGO = SD1.D1_TES
									AND SF4.F4_ICM = 'S' AND SF4.%NotDel%       		  
			JOIN %table:SF1% SF1 ON SF1.F1_FILIAL = %xFilial:SF1%
									AND SF1.F1_DOC = SD1.D1_DOC
									AND SF1.F1_SERIE = SD1.D1_SERIE
									AND SF1.F1_FORNECE = SD1.D1_FORNECE 
									AND SF1.F1_LOJA = SD1.D1_LOJA
									AND SF1.F1_TIPO = SD1.D1_TIPO								
									AND SF1.%NotDel%       		  																
	        WHERE SD1.D1_FILIAL = %xFilial:SD1% AND
		          SD1.D1_DTDIGIT >=%Exp:dDtIni% AND
       			  SD1.D1_DTDIGIT <=%Exp:dDtFim% AND
	    	      SD1.D1_TIPO IN('N','C') AND      
	    	      SD1.D1_COD = %Exp:cCodPro% AND
	        	  SD1.%NotDel%
		    ORDER BY 1,2
    	EndSql        		
		dbSelectArea(cAlias)         
	Else	                  
#ENDIF        
cIndex	:= CriaTrab(NIL,.F.)
cFiltro	:= "D1_FILIAL == '" + xFilial("SD1") + "' .AND. "
cFiltro += "dtos(D1_DTDIGIT) >= '"+dtos(dDtIni)+"' .AND. " 
cFiltro += "dtos(D1_DTDIGIT) <= '"+dtos(dDtFim)+"' .AND. "  
cFiltro += "D1_TIPO $ 'NC' .AND. D1_COD = '"+cCodPro+ ' "
		
IndRegua (cAlias, cIndex, (cAlias)->(IndexKey ()),, cFiltro)
nIndex := RetIndex(cAlias)
#IFNDEF TOP
	DbSetIndex (cIndex+OrdBagExt ())
#ENDIF			
DbSelectArea (cAlias)
DbSetOrder (nIndex)
#IFDEF TOP
	Endif
#ENDIF
	
DbSelectArea(cAlias)
(cAlias)->(DbGoTop())
ProcRegua((cAlias)->(RecCount()))
While !(cAlias)->(Eof())
    cAuxLan := Iif(!Empty((cAlias)->(FieldPos("D1_CODLAN"))),(cAlias)->D1_CODLAN, "") 
    If Alltrim(cAuxLan) == ""                                                                          
        cAuxLan := Iif(!Empty((cAlias)->(FieldPos("F4_CODLAN"))),(cAlias)->F4_CODLAN, "") 
    EndIf
	If Alltrim(cAuxLan) <> ""            
        cCodLan  := cAuxLan 	
	EndIf  
	    
	cEspecie := (cAlias)->F1_ESPECIE
    cAuxFic  := VerFicha(cPeriodo, cCodPro, cProd, cCodLan, cEspecie)
    If AllTrim(cAuxFic) <> "" .And. AllTrim(cCodLan) <> ""
	    cDtDig  := dtos((cAlias)->D1_DTDIGIT)
	    aAdd(aDados,{})
	    nPos :=	Len(aDados)
	    aAdd (aDados[nPos], cCodPro)                                                   //01 - PRODUTO
        aAdd (aDados[nPos], cCodLan)                                                   //02 - COD LANCTO
	    aAdd (aDados[nPos], (cAlias)->D1_QUANT)	                                    //03 - QUANTIDADE
	    aAdd (aDados[nPos], (cAlias)->D1_CUSTO)					                    //04 - CUSTO 
	    aAdd (aDados[nPos], (cAlias)->D1_VALICM)                      		            //05 - VL ICMS
	    //aAdd (aDados[nPos], substr(cDtDig,7,2)+substr(cDtDig,5,2)+substr(cDtDig,1,4)) //06 - DT DIGITACAO
	    aAdd (aDados[nPos], (cAlias)->D1_DTDIGIT)
	    aAdd (aDados[nPos], (cAlias)->D1_NUMSEQ)                      		            //07 - NRO.SEQUENCIAL
	    aAdd (aDados[nPos], cAuxFic)                             		                //08 - FICHA
	    aAdd (aDados[nPos], "I")                                 		                //09 - OPERACAO	
	    aAdd (aDados[nPos], "")                                   		                //10 - CHAVE SD3	
    EndIf
    IncProc("Processando Entradas "+(cAlias)->D1_NUMSEQ+ " Posicao "+cValToChar(nPos))
   	(cAlias)->(DbSkip())
EndDo
DbSelectArea(cAlias)
(cAlias)->(DbCloseArea())   
Return(aDados)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcDevl  บAutor  ณCecilia Carvalho    บ Data ณ  26/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessa notas fiscais de devolucao  	                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcCodPro  - Produto a ser considerado na busca               บฑฑ
ฑฑบ          ณdDtIni  - Periodo inicial a ser considerado na busca        บฑฑ
ฑฑบ          ณdDtFim - Periodo final a ser considerado na busca           บฑฑ
ฑฑบ          ณcCodLan - Codigo do lancamento cat83                        บฑฑ
ฑฑบ          ณcPeriodo- Periodo a ser considerado na busca                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/                    
Static Function ProcDevl(cCodPro, dDtIni, dDtFim, cCodLan, cPeriodo)
Local cAlias 	:= GetNextAlias()
Local cIndex   	:= ""    
Local cDtEmiss  := ""
Local cAuxFic   := ""
Local cAuxLan   := ""
Local nIndex	:= 0
Local nPos      := 0
Local aDados    := {}

#IFDEF TOP
	If TcSrvType()<>"AS/400"	 
        cAlias := GetNextAlias()       	           
       	BeginSql Alias cAlias
			COLUMN D2_EMISSAO AS DATE   
			SELECT SD2.D2_FILIAL, SD2.D2_EMISSAO, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_COD, SD2.D2_ITEM,
				   SD2.D2_QUANT, SD2.D2_CF, SD2.D2_PICM, SD2.D2_VALICM, SD2.D2_BASEICM, SD2.D2_TIPO, SD2.D2_CUSTO1,      
				   SD2.D2_NFORI, SD2.D2_SERIORI, SD2.D2_ITEMORI, SD2.D2_TES, SF2.F2_ESPECIE, SD2.D2_CODLAN,
				   SD2.D2_NUMSEQ 
			FROM %table:SD2% SD2
			JOIN %table:SF4% SF4 ON SF4.F4_FILIAL = %xFilial:SF4% AND
									SF4.F4_CODIGO = SD2.D2_TES AND
									SF4.F4_ICM = 'S' AND SF4.%NotDel%       		  
			JOIN %table:SF2% SF2 ON SF2.F2_FILIAL = %xFilial:SF2%
									AND SF2.F2_DOC = SD2.D2_DOC
									AND SF2.F2_SERIE = SD2.D2_SERIE
									AND SF2.F2_CLIENTE = SD2.D2_CLIENTE 
									AND SF2.F2_LOJA = SD2.D2_LOJA							
									AND SF2.%NotDel%       		  																				
        	WHERE SD2.D2_FILIAL = %xFilial:SD2% AND		                     
			      SD2.D2_EMISSAO >=%Exp:dDtIni% AND
       			  SD2.D2_EMISSAO <=%Exp:dDtFim% AND				      
 				  SD2.D2_TIPO = 'D' AND
 				  SD2.D2_COD = %Exp:cCodPro% AND
				  SD2.%NotDel%        
			ORDER BY 1,2			 				  				  		            
    	EndSql               
		dbSelectArea(cAlias)         
	Else	                  
#ENDIF        
cIndex	:= CriaTrab(NIL,.F.)
cFiltro	:= "D2_FILIAL == '" + xFilial("SD2") + "' .AND. "
cFiltro += "dtos(D2_EMISSAO) >= '"+dtos(dDtIni)+"' .AND. " 
cFiltro += "dtos(D2_EMISSAO) <= '"+dtos(dDtFim)+"' .AND. "  
cFiltro += "D2_TIPO == 'D' .AND. D2_COD = '"+cCodPro+ ' "
		
IndRegua (cAlias, cIndex, (cAlias)->(IndexKey ()),, cFiltro)
nIndex := RetIndex(cAlias)
#IFNDEF TOP
	DbSetIndex (cIndex+OrdBagExt ())
#ENDIF			
DbSelectArea (cAlias)
DbSetOrder (nIndex)
#IFDEF TOP
	Endif
#ENDIF          

DbSelectArea(cAlias)
(cAlias)->(DbGoTop())
ProcRegua((cAlias)->(RecCount()))
While !(cAlias)->(Eof())
    cAuxLan := Iif(!Empty((cAlias)->(FieldPos("D2_CODLAN"))),(cAlias)->D2_CODLAN, "") 
    If Alltrim(cAuxLan) == ""                                                                          
        cAuxLan := Iif(!Empty((cAlias)->(FieldPos("F4_CODLAN"))),(cAlias)->F4_CODLAN, "") 
    EndIf
	If Alltrim(cAuxLan) <> ""            
        cCodLan  := cAuxLan 	
	EndIf	 
    cEspecie := (cAlias)->F2_ESPECIE
    cAuxFic  := VerFicha(cPeriodo, cCodPro, cProd, cCodLan, cEspecie)
    If AllTrim(cAuxFic) <> "" .And. AllTrim(cCodLan) <> ""
	    cDtEmiss := dtos((cAlias)->D2_EMISSAO)
     	aAdd(aDados,{})
	    nPos :=	Len(aDados)
	    aAdd (aDados[nPos], cCodPro)	                                                      //01 - PRODUTO
	    aAdd (aDados[nPos], cCodLan)                                                         //02 - COD LANCTO 
	    aAdd (aDados[nPos], (cAlias)->D2_QUANT)	                                          //03 - QUANTIDADE
	    aAdd (aDados[nPos], (cAlias)->D2_CUSTO1)					                          //04 - CUSTO
	    aAdd (aDados[nPos], (cAlias)->D2_VALICM)                      			              //05 - VL ICMS
	    //aAdd (aDados[nPos], substr(cDtEmiss,7,2)+substr(cDtEmiss,5,2)+substr(cDtEmiss,1,4)) //06 - DT DIGITACAO
	    aAdd (aDados[nPos],(cAlias)->D2_EMISSAO)
	    aAdd (aDados[nPos], (cAlias)->D2_NUMSEQ)                      		                  //07 - NRO.SEQUENCIAL
	    aAdd (aDados[nPos], cAuxFic)                             		                      //08 - FICHA
	    aAdd (aDados[nPos], "E")                                 		                      //09 - OPERACAO	
	    aAdd (aDados[nPos], "")                                        		                  //10 - CHAVE SD3	
    EndIf
    IncProc("Processando Saidas "+(cAlias)->D2_NUMSEQ+" Posicao "+cValToChar(nPos))
    (cAlias)->(DbSkip())
EndDo
DbSelectArea(cAlias)
(cAlias)->(DbCloseArea())
Return(aDados)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcSaid  บAutor  ณCecilia Carvalho    บ Data ณ  26/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessa notas fiscais de saida	 		                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcCodPro  - Produto a ser considerado na busca               บฑฑ
ฑฑบ          ณdDtIni  - Periodo inicial a ser considerado na busca        บฑฑ
ฑฑบ          ณdDtFim - Periodo final a ser considerado na busca           บฑฑ
ฑฑบ          ณcCodLan - Codigo do lancamento cat83                        บฑฑ
ฑฑบ          ณcPeriodo- Periodo a ser considerado na busca                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/                    
Static Function ProcSaid(cCodPro, dDtIni, dDtFim, cCodLan, cPeriodo)
Local cAlias 	:= GetNextAlias()
Local cIndex   	:= ""    
Local cDtEmiss  := ""
Local cAuxFic   := ""
Local cAuxLan   := ""
Local nIndex	:= 0
Local nPos      := 0
Local aDados    := {}

#IFDEF TOP
	If TcSrvType()<>"AS/400"	 
        cAlias := GetNextAlias()       	           
       	BeginSql Alias cAlias
			COLUMN D2_EMISSAO AS DATE   
			SELECT SD2.D2_FILIAL, SD2.D2_EMISSAO, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_COD, SD2.D2_ITEM,
				   SD2.D2_QUANT, SD2.D2_CF, SD2.D2_PICM, SD2.D2_VALICM, SD2.D2_BASEICM, SD2.D2_TIPO, SD2.D2_CUSTO1,      
				   SD2.D2_TES, SF2.F2_ESPECIE, SD2.D2_CODLAN, SD2.D2_DESCZFR, SF4.F4_CRDACUM, SD2.D2_NUMSEQ 
			FROM %table:SD2% SD2
			JOIN %table:SF4% SF4 ON SF4.F4_FILIAL = %xFilial:SF4% AND
									SF4.F4_CODIGO = SD2.D2_TES AND
									((SD2.D2_CODLAN <> '317773' AND SF4.F4_ICM = 'S') OR (SD2.D2_CODLAN = '317773' AND SF4.F4_ICM <> ' ')) AND
									SF4.%NotDel%       		  
			JOIN %table:SF2% SF2 ON SF2.F2_FILIAL = %xFilial:SF2%
									AND SF2.F2_DOC = SD2.D2_DOC
									AND SF2.F2_SERIE = SD2.D2_SERIE
									AND SF2.F2_CLIENTE = SD2.D2_CLIENTE 
									AND SF2.F2_LOJA = SD2.D2_LOJA							
									AND SF2.%NotDel%       		  																				
        	WHERE SD2.D2_FILIAL = %xFilial:SD2% AND		                     
			      SD2.D2_EMISSAO >=%Exp:dDtIni% AND
       			  SD2.D2_EMISSAO <=%Exp:dDtFim% AND				      
 				  SD2.D2_TIPO = 'N' AND
 				  SD2.D2_COD = %Exp:cCodPro% AND
				  SD2.%NotDel%        
			ORDER BY 1,2			 				  				  		            
    	EndSql               
		dbSelectArea(cAlias)         
	Else	                  
#ENDIF        
cIndex	:= CriaTrab(NIL,.F.)
cFiltro	:= "D2_FILIAL == '" + xFilial("SD2") + "' .AND. "
cFiltro += "dtos(D2_EMISSAO) >= '"+dtos(dDtIni)+"' .AND. " 
cFiltro += "dtos(D2_EMISSAO) <= '"+dtos(dDtFim)+"' .AND. "  
cFiltro += "D2_TIPO == 'N' .AND. D2_COD = '"+cCodPro+ ' "
		
IndRegua (cAlias, cIndex, (cAlias)->(IndexKey ()),, cFiltro)
nIndex := RetIndex(cAlias)
#IFNDEF TOP
	DbSetIndex (cIndex+OrdBagExt ())
#ENDIF			
DbSelectArea (cAlias)
DbSetOrder (nIndex)
#IFDEF TOP
	Endif
#ENDIF          

DbSelectArea(cAlias)
(cAlias)->(DbGoTop())
ProcRegua((cAlias)->(RecCount()))
While !(cAlias)->(Eof())
    cAuxLan := Iif(!Empty((cAlias)->(FieldPos("D2_CODLAN"))),(cAlias)->D2_CODLAN, "") 
    If Alltrim(cAuxLan) == ""                                                                          
        cAuxLan := Iif(!Empty((cAlias)->(FieldPos("F4_CODLAN"))),(cAlias)->F4_CODLAN, "") 
    EndIf
	If Alltrim(cAuxLan) <> ""            
        cCodLan  := cAuxLan	
	EndIf	 
    cEspecie := (cAlias)->F2_ESPECIE
    cAuxFic  := VerFicha(cPeriodo, cCodPro, cProd, cCodLan, cEspecie)
    If AllTrim(cAuxFic) <> "" .And. AllTrim(cCodLan) <> ""
	   cDtEmiss := dtos((cAlias)->D2_EMISSAO)
	   aAdd(aDados,{})
	   nPos := Len(aDados)
	   aAdd (aDados[nPos], cCodPro)                       
	                                        //01 - PRODUTO
	   aAdd (aDados[nPos], cCodLan)                                                            //02 - COD.LANCTO 
	   aAdd (aDados[nPos], (cAlias)->D2_QUANT)	                                                //03 - QUANTIDADE
	   aAdd (aDados[nPos], (cAlias)->D2_CUSTO1)						                        //04 - CUSTO
	   aAdd (aDados[nPos], (cAlias)->D2_VALICM)                      				            //05 - VL ICMS
	   //aAdd (aDados[nPos], substr(cDtEmiss,7,2)+substr(cDtEmiss,5,2)+substr(cDtEmiss,1,4))	//06 - DT DIGITACAO
	   aAdd (aDados[nPos],(cAlias)->D2_EMISSAO)
	   aAdd (aDados[nPos], (cAlias)->D2_NUMSEQ)                      		                    //07 - NRO.SEQUENCIAL
	   aAdd (aDados[nPos], cAuxFic)                             		                        //08 - FICHA
	   aAdd (aDados[nPos], "E")                                 		                        //09 - OPERACAO	
	   aAdd (aDados[nPos], "")                                   		                        //10 - CHAVE SD3	
    EndIf
    (cAlias)->(DbSkip())
EndDo
DbSelectArea(cAlias)
(cAlias)->(DbCloseArea())                             
Return(aDados)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcMovim บAutor  ณCecilia Carvalho    บ Data ณ  26/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessa SD3 (Movimentacoes Internas)                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณdDtIni   - Periodo inicial a ser considerado na busca       บฑฑ
ฑฑบ          ณdDtFim   - Periodo final a ser considerado na busca         บฑฑ
ฑฑบ          ณcPeriodo - Periodo de referencia                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
Static Function ProcMovim(dDtIni, dDtFim, cPeriodo)
Local cAlias 	:= GetNextAlias()
Local cIndex   	:= ""    
Local cDtDig    := ""      
Local cAuxFic   := ""
Local cAuxLan   := ""
Local nIndex	:= 0
Local nPos      := 0
Local aDados    := {}
Local cFilProd  := ""

//Local cObs := 'CAT83'

#IFDEF TOP                              
	If TcSrvType()<>"AS/400"							          		 
		If !Empty(MV_PAR07)
			cFilProd := "% AND SD3.D3_COD BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' %"
		EndIf
		
        cAlias := GetNextAlias()   
        BeginSql Alias cAlias
			COLUMN D3_EMISSAO AS DATE 
			SELECT SD3.D3_FILIAL, SD3.D3_COD, SD3.D3_DOC, SD3.D3_LOCAL, SD3.D3_QUANT, SD3.D3_EMISSAO, 
			       SD3.D3_TM, SD3.D3_CF, SD3.D3_OP, SD3.D3_CUSTO1, SD3.D3_ESTORNO, SD3.D3_CHAVE,
                   SD3.D3_CODLAN, SD3.D3_NUMSEQ, SD3.D3_ESTORNO, SF5.F5_CODIGO, SF5.F5_CODLAN, SD3.D3_X_CUSTO
   		    FROM %table:SD3% SD3 
   		    JOIN %table:SF5% SF5 ON SF5.F5_FILIAL = %xFilial:SF5%
									AND SF5.F5_CODIGO = SD3.D3_TM
									AND SF5.%NotDel%
	        WHERE SD3.D3_FILIAL = %xFilial:SD3% AND
		          SD3.D3_EMISSAO >=%Exp:dDtIni% AND
       			  SD3.D3_EMISSAO <=%Exp:dDtFim% AND
       			  SD3.D3_COD between %Exp:MV_PAR07% AND %Exp:MV_PAR08% AND
//       			  SD3.D3_ATLOBS = %Exp:cObs% AND    //Incluido por anesio para filtrar apenas alguns itens....
	        	  SD3.%NotDel% 
	        	  //%Exp:cFilProd%
		    ORDER BY 1,2
    	EndSql        		
		dbSelectArea(cAlias)         
	Else	                  
#ENDIF        
 cIndex	 := CriaTrab(NIL,.F.)
 cFiltro := "D3_FILIAL == '" + xFilial("SD3") + "' .AND. "
 cFiltro += "dtos(D3_EMISSAO) >= '"+dtos(dDtIni)+"' .AND. " 
 cFiltro += "dtos(D3_EMISSAO) <= '"+dtos(dDtFim)+' "
	
 IndRegua (cAlias, cIndex, (cAlias)->(IndexKey ()),, cFiltro)
 nIndex := RetIndex(cAlias)
 #IFNDEF TOP
   DbSetIndex (cIndex+OrdBagExt ())
 #ENDIF			
 DbSelectArea (cAlias)
 DbSetOrder (nIndex)
 #IFDEF TOP
  Endif
 #ENDIF

DbSelectArea(cAlias)
(cAlias)->(DbGoTop())
ProcRegua((cAlias)->(RecCount()))
While !(cAlias)->(Eof())
	//Desconsiderar os PIs do rgupo 32 ao 40 conforme discutido com o Sr.Amadeu e Sr.Thiago
	//Implementado por Anesio - 26-06-2014 
	if posicione("SB1",1,xFilial("SB1")+(cAlias)->D3_COD,"B1_X_CODCA") <> space(15)
		(cAlias)->(DbSkip())
		loop
	endif	
    cAuxLan := Iif(!Empty((cAlias)->(FieldPos("D3_CODLAN"))),(cAlias)->D3_CODLAN, "") 
    If Alltrim(cAuxLan) = ""                                                                          
        cAuxLan := Iif(!Empty((cAlias)->(FieldPos("F5_CODLAN"))),(cAlias)->F5_CODLAN, "") 
    EndIf
	If Alltrim(cAuxLan) <> ""
		cDtDig := dtos((cAlias)->D3_EMISSAO)
	    If cAuxLan $ cFicha1B 
			cAuxFic := "12"
	    ElseIf cAuxLan $ cFicha2A 
	        cAuxFic := "21"	     
	    ElseIf cAuxLan $ cFicha2B 
	        cAuxFic := "22"	    
	    ElseIf cAuxLan $ cFicha2C 
	        cAuxFic := "23"	    
	    ElseIf cAuxLan $ cFicha2D 
	        cAuxFic := "24"
	    ElseIf cAuxLan $ cFicha2E 
	        cAuxFic := "25"
	    ElseIf cAuxLan $ cFicha2F 
	        cAuxFic := "26" 
	    ElseIf cAuxLan $ cFicha2G 
	        cAuxFic := "27"	                                                                                       
	    ElseIf cAuxLan $ cFicha3A 
	        cAuxFic := "31"
	    ElseIf cAuxLan $ cFicha3B 
	        cAuxFic := "32"
	    ElseIf cAuxLan $ cFicha3C 
	        cAuxFic := "33"
	    EndIf                            
	
		aAdd(aDados,{})
		nPos :=	Len(aDados)               
		aAdd (aDados[nPos], (cAlias)->D3_COD)      		                             //01 - PRODUTO
	    aAdd (aDados[nPos], cAuxLan)                                                    //02 - COD LANCTO 
		aAdd (aDados[nPos], (cAlias)->D3_QUANT)	                                     //03 - QUANTIDADE
		aAdd (aDados[nPos], (cAlias)->D3_CUSTO1)						                 //04 - CUSTO 
		aAdd (aDados[nPos], (cAlias)->D3_X_CUSTO)	                                //05 - VL_ICMS 	
		//aAdd (aDados[nPos], substr(cDtDig,7,2)+substr(cDtDig,5,2)+substr(cDtDig,1,4))  //06 - DT DIGITACAO
	    aAdd (aDados[nPos],(cAlias)->D3_EMISSAO)
		aAdd (aDados[nPos], Alltrim((cAlias)->D3_NUMSEQ))					             //07 - NRO SEQUENCIAL
		aAdd (aDados[nPos], cAuxFic)			 		                                 //08 - FICHA
		aAdd (aDados[nPos], Iif((cAlias)->D3_ESTORNO == "S", "E", "I"))	             //09 - OPERACAO	
   	    aAdd (aDados[nPos], (cAlias)->D3_CHAVE)                                 		 //10 - CHAVE SD3	
	Endif
	IncProc("Gravando movimento -> "+(cAlias)->D3_NUMSEQ+ " Posicao "+cValToChar(nPos))
	(cAlias)->(DbSkip())                    
EndDo

DbSelectArea(cAlias)	
(cAlias)->(DbCloseArea())
Return(aDados)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravMov   บAutor  ณCecilia Carvalho    บ Data ณ  16/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Apuracao de movimentos Cat 83/09                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ.T.                                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcPeriodo : Periodo de referencia                            บฑฑ 
ฑฑบ          ณdDtIni   - Periodo inicial a ser considerado na busca       บฑฑ
ฑฑบ          ณdDtFim   - Periodo final a ser considerado na busca         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
Static Function GravMov(cPeriodo, dDtIni, dDtFim)  
Local aArea 	:= GetArea()
Local nX        := 0
Local lRet   	:= .T.      
Local nSaldoIni := 0
Local nCustoIni := 0                   
Local nMes      := 0
Local nAno      := 0
Local cFic      := ""
Local cPer      := ""
Local cOpe      := ""
Local cAliasCDU := "CDU"
Local lTabCDU 	:=	AliasIndic("CDU")
ProcRegua(0)
nTotReg := Len(aMovim)
For nX:=1 to Len(aMovim)
    If AliasIndic("CDW")
	    Begin Transaction		
		 DbSelectArea("CDW")
		 CDW->(DbSetOrder(1))
         cFic := aMovim[nX][08]             
         cOpe := aMovim[nX][09]			 
		 If CDW->(DbSeek(xFilial("CDW")+cPeriodo+cFic+aMovim[nx][01]+aMovim[nx][02]))
			 RecLock("CDW",.F.)
			 If Alltrim(cOpe) == "I"
			     CDW->CDW_VALICM +=	aMovim[nX][05]
			     CDW->CDW_VALCUS +=	aMovim[nX][04]
			     CDW->CDW_QUANT  +=	aMovim[nX][03]
			 Else
			     CDW->CDW_VALICM +=	aMovim[nX][05]//Iif((CDW->CDW_VALICM - aMovim[nX][05])>0,(CDW->CDW_VALICM - aMovim[nX][05]),0)
			     CDW->CDW_VALCUS +=	aMovim[nX][04]//Iif((CDW->CDW_VALCUS - aMovim[nX][04])>0,(CDW->CDW_VALCUS - aMovim[nX][04]),0)
			     CDW->CDW_QUANT  +=	aMovim[nX][03]//Iif((CDW->CDW_QUANT  - aMovim[nX][03])>0,(CDW->CDW_QUANT - aMovim[nX][03]),0)
			 EndIf
  		     CDW->(MsUnLock())
         Else               
   	         RecLock("CDW", .T. )
	         CDW->CDW_FILIAL := xFilial("CDW")
	         CDW->CDW_PERIOD := cPeriodo
	         CDW->CDW_FICHA  := cFic
		     CDW->CDW_PRODUT := aMovim[nX][01]
		     CDW->CDW_CODLAN := aMovim[nX][02]
	         CDW->CDW_OPERAC := Iif(Alltrim(cOpe) == "I", "1", "2")
		     CDW->CDW_DTMOV	 := aMovim[nX][06]
		     CDW->CDW_QUANT  := aMovim[nX][03]
		     CDW->CDW_VALCUS := aMovim[nX][04]
		     CDW->CDW_VALICM := aMovim[nX][05]
	         CDW->CDW_NUMSEQ := aMovim[nX][07]  
	         CDW->CDW_CHAVE  := aMovim[nX][10] 
             CDW->(MsUnLock())
         Endif     
         //buscar saldo anterior
         nMes := Month(dDtIni) - 1
         nAno := Year(dDtFim)
         //Verifica o mes e o ano correto da regressao
         If nMes == 0
             nMes := 12
             nAno := nAno - 1
         EndIf
         cPer := StrZero(nAno,4)+StrZero(nMes,2)
         If lTabCDU
	         DbSelectArea(cAliasCDU)
	         (cAliasCDU)->(DbSetOrder(1))
	         If (cAliasCDU)->(DbSeek(xFilial(cAliasCDU)+cPer+cFic+aMovim[nX][01]))
		         nSaldoIni:=(cAliasCDU)->CDU_VALICM
	             nCustoIni:=(cAliasCDU)->CDU_VALCUS
	         Else
		         nSaldoIni:= 0
		         nCustoIni:= 0
	         EndIf
			 DbSelectArea(cAliasCDU)	
			 (cAliasCDU)->(DbCloseArea())						                
	     EndIf		
		 If AliasIndic("CDU")
			 DbSelectArea("CDU")
			 CDU->(DbSetOrder(1))
			 If CDU->(DbSeek(xFilial("CDU")+cPeriodo+cFic+aMovim[nX][01]))
				RecLock("CDU",.F.)
				If Alltrim(cOpe) == "I"
				    CDU->CDU_VALICM +=	aMovim[nX][05]
				    CDU->CDU_VALCUS +=	aMovim[nX][04]
				Else
					CDU->CDU_VALICM :=	Iif((CDU->CDU_VALICM - aMovim[nX][05])>0,(CDU->CDU_VALICM - aMovim[nX][05]),0)
					CDU->CDU_VALCUS :=	Iif((CDU->CDU_VALCUS - aMovim[nX][04])>0,(CDU->CDU_VALCUS - aMovim[nX][04]),0)
				EndIf
				CDU->(MsUnLock())
             Else
			     RecLock("CDU",.T.)
			     CDU->CDU_FILIAL := xFilial("CDU")
			     CDU->CDU_PERIOD := cPeriodo 
			     CDU->CDU_FICHA  := cFic
			     CDU->CDU_PRODUT :=	aMovim[nX][01]
			     CDU->CDU_VALICM :=	aMovim[nX][05] + nSaldoIni
			     CDU->CDU_VALCUS :=	aMovim[nX][04] + nCustoIni
			     CDU->(MsUnLock())
		     EndIf
		 EndIf
		End Transaction
    EndIf
    IncProc("Gravando movim.prod. "+AllTrim(aMovim[nX][01])+ " Posicao "+cValToChar(nX)+"/"+cValToChar(nTotReg))
Next nX
RestArea(aArea)
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณZeraMov   บAutor  ณCecilia Carvalho    บ Data ณ  16/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Limpa as tabelas CDW e CDU para o periodo em processamento บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ.T.                                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcPeriodo: Periodo                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
Static Function ZeraMov(cPeriodo, cFilialp)
Local cAliasCDW :=	"CDW"
Local cAliasCDU :=	"CDU"
Local lRet   	:= .T.
                         
DbSelectArea (cAliasCDW)
(cAliasCDW)->(DbSetOrder(1))
(cAliasCDW)->(DbGoTop()) 
If (cAliasCDW)->(DbSeek(xFilial(cAliasCDW)+cPeriodo),.T.)
While !(cAliasCDW)->(Eof())      
	If (cAliasCDW)->CDW_PERIOD == cPeriodo .And. (cAliasCDW)->CDW_FILIAL==cFilialp
       (cAliasCDW)->(RecLock("CDW"))
       (cAliasCDW)->(dbDelete())
       (cAliasCDW)->(MsUnLock())    
 	EndIf
   (cAliasCDW)->(DbSkip())
EndDo                            
EndIf
(cAliasCDW)->(DbCloseArea())

DbSelectArea (cAliasCDU)
(cAliasCDU)->(DbSetOrder(1))
If (cAliasCDU)->(DbSeek(xFilial(cAliasCDU)+cPeriodo),.T.)
    While (cAliasCDU)->CDU_PERIOD == cPeriodo .And. (cAliasCDU)->CDU_FILIAL==cFilialp
      (cAliasCDU)->(RecLock("CDU"))
      (cAliasCDU)->(dbDelete())
      (cAliasCDU)->(MsUnLock())    
      (cAliasCDU)->(DbSkip())
    EndDo                            
EndIf
(cAliasCDU)->(DbCloseArea())
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerFicha  บAutor  ณCecilia Carvalho    บ Data ณ  16/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica qual ficha para o produto e codigo lcto cat83     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณCodigo da ficha                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcPeriodo: Periodo                                           บฑฑ  
ฑฑบ          ณcCodPro : Codigo do produto                                 บฑฑ  
ฑฑบ          ณcProd   : Codigo do produto + filial                        บฑฑ  
ฑฑบ          ณcCodLan : Codigo do lcto cat83                              บฑฑ  
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
Static Function VerFicha(cPeriodo, cCodPro, cProd, cCodLan, cEspecie)
Local cAuxFicha := ""
Local cAliasCDW :=	"CDW"

DbSelectArea(cAliasCDW)
(cAliasCDW)->(DbSetOrder (1))
#IFDEF TOP
  If (TcSrvType ()<>"AS/400")
      cAliasCDW	:=	GetNextAlias()
   		   	
   	  BeginSql Alias cAliasCDW    	
		SELECT 
		      CDW.CDW_FILIAL, CDW.CDW_PERIOD, CDW.CDW_FICHA, CDW.CDW_PRODUT, CDW.CDW_CODLAN
		FROM 
		    %Table:CDW% CDW 
		WHERE 
		     CDW.CDW_FILIAL=%xFilial:CDW% AND 
			 CDW.CDW_PRODUT = (%Exp:cCodPro%) AND
			 CDW.CDW_PERIOD = (%Exp:cPeriodo%) AND
			 CDW.CDW_CODLAN = (%Exp:cCodLan%) AND	
			 CDW.%NotDel%					               
		ORDER BY 
		        1,2,3,4				
	  EndSql
  Else
#ENDIF
  cIndex := CriaTrab(NIL,.F.)
  cFiltro:= 'CDW_FILIAL=="'+xFilial ("CDW")+" AND ' 
  cFiltro:= 'CDW_PRODUT=="'+cCodPro+" AND '
  cFiltro:= 'CDW_CODLAN=="'+cCodLan+" AND '
  cFiltro:= 'CDW_PERIOD=="'+cPeriodo+"' "
		    
  IndRegua (cAliasCDW, cIndex, CDW->(IndexKey ()),, cFiltro)
  nIndex := RetIndex(cAliasCDW)
  #IFNDEF TOP
   DbSetIndex (cIndex+OrdBagExt ())
  #ENDIF			
  DbSelectArea (cAliasCDW)
  DbSetOrder (nIndex)
  #IFDEF TOP
  Endif
  #ENDIF
		              
  DbSelectArea (cAliasCDW)
  (cAliasCDW)->(DbGoTop ())
  While !(cAliasCDW)->(Eof ())      
    If (cAliasCDW)->CDW_PRODUT == cCodPro .And. (cAliasCDW)->CDW_CODLAN == cCodLan .And. (cAliasCDW)->CDW_PERIOD == cPeriodo
        cAuxFicha := (cAliasCDW)->CDW_FICHA
        Exit
    Endif
	DbSelectArea(cAliasCDW)
	(cAliasCDW)->(DbSkip())        
 EndDo  
 If AllTrim(cAuxFicha) == ""
	 If cCodLan $ cFicha1A 
	     cAuxFicha := "11"
	 ElseIf cCodLan $ cFicha1B 
         cAuxFicha := "12"    
	 ElseIf cCodLan $ cFicha1C .Or. cEspecie $ "NFCEE"
         cAuxFicha := "13"    
	 ElseIf cCodLan $ cFicha1D .Or. cEspecie $ "NFSC','NTSC"
         cAuxFicha := "14"    
     ElseIf cCodLan $ cFicha1E .Or. cEspecie $ "CTR"
         cAuxFicha := "15"
     ElseIf cCodLan $ cFicha2A 
         cAuxFicha := "21"	     
     ElseIf cCodLan $ cFicha2B 
          cAuxFicha := "22"	    
     ElseIf cCodLan $ cFicha2C 
          cAuxFicha := "23"	    
     ElseIf cCodLan $ cFicha2D 
          cAuxFicha := "24"
     ElseIf cCodLan $ cFicha2E 
          cAuxFicha := "25"
     ElseIf cCodLan $ cFicha2F 
          cAuxFicha := "26" 
     ElseIf cCodLan $ cFicha2G 
          cAuxFicha := "27"	                                                                                       
	 ElseIf cCodLan $ cFicha3A      
 		  cAuxFicha := "31"
	 ElseIf cCodLan $ cFicha3B      
   	      cAuxFicha := "32"
     ElseIf cCodLan $ cFicha3C 
          cAuxFicha := "33"
	 EndIf                            
 EndIf
 (cAliasCDW)->(DbCloseArea()) 
Return(cAuxFicha)

//===============================================================================================================================
// Fun็ใo : ICMSD3 - Calcula o Icms da Produ็ใo
// Autor : Alessandro Freire - Tuning Sistemas
// Parโmetros
// cProd - C๓digo do Produto
// cPer - Perํodo no formato AAAAMM
//===============================================================================================================================
Static Function ICMSD3( cProd, cPer )  
       
Local aArea     := GetArea()       
Local cAno      := SubStr(cPer,1,4)
Local cMes      := SubStr(cPer,5,2)
Local cPerAnt   := ""

Local nICMAnt := 0 // Saldo do valor do ICMS no perํodo anterior
Local nQtdAnt := 0 // Quantidade no perํodo anterior do ICMS
                                    
// Calcula o perํodo anterior
If cMes == "01"
	cPerAnt := StrZero(Val(cAno)-1,4)
	cPerAnt += "12"
Else
	cPerAnt := cAno
	cPerAnt += StrZero(Val(cMes)-1,2)
EndIf

// Captura o saldo m้dio anterior de ICMS deste produto ( TABELA PERSON. ZZA )
dbSelecArea( "ZZA" )
dbSetOrder(1) // Periodo + Produto
If dbSeek( xFilial("ZZA") + cPer + cProd )
	nIcmAnt := ZZA->ZZA_VALICM
	nQtdAnt := ZZA->ZZA_QUANT
EndIf

// Verifica todas as entradas e saํdas via nota fiscal destes produto para calcular o ICMS