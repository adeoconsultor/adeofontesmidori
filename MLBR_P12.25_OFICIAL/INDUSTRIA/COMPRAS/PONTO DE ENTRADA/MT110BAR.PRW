#Include 'Protheus.ch'
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "topconn.ch"
#include "rwmake.ch"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Conjunto de funcoes desenvolvidas para atender a rotina de aprovacao de compras Midori conforme chamado HDi.
//Desenvolvido por Anesio G.Faria - 23/10/2012 - anesio@outlook.com
//Manutencao em MT097END por Vinicius Schwartz - 25/01/2013 - TI Midori Atlantica
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Ponto de entrada que adiciona o botão de Ringi Sho e Aprovação na visualizacao da solicitação
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
user function MA110BAR()
Local aButtons := {}
if !inclui //.and. !altera
//	Aadd( aButtons, {"S4WB011N",{ || MsDocument() }, OemToAnsi("CONHECIMENTO")+" "+OemToAnsi(""), OemToAnsi("RINGI SHO")} )
	Aadd( aButtons, {"S4WB011N",{ || U_AG_SCHAC9()  }, OemToAnsi("Conhecimento")+" "+OemToAnsi(""), OemToAnsi("Ringi-Sho")} )	
	Aadd( aButtons, {"NOTE",{ || U_AConfAlt(), A110Aprov()  }, OemToAnsi("Aprovacao")+" "+OemToAnsi(""), OemToAnsi("Aprovar")} )	
//	Aadd( aButtons, {"S4WB010N",{ || A110Altera()  }, OemToAnsi("Excluir Itens")+" "+OemToAnsi(""), OemToAnsi("Excluir Itens")} )	
endif 
return aButtons

//Confirma a alteracao antes de aprovar....
User Function AConfAlt()
Local cSolic 		:= SC1->C1_SOLICIT
Local cFilEnt       := SC1->C1_FILENT
Local lNaturez   	:= (FieldPos("C1_NATUREZ") > 0 )

PRIVATE dA110Data 	:= SC1->C1_EMISSAO
PRIVATE cCodNatu  	:= iIf(lNaturez,SC1->C1_NATUREZ,"")
PRIVATE cCCusto 	:= SC1->C1_CC
PRIVATE cUnidReq 	:= SC1->C1_UNIDREQ
PRIVATE cCodCompr 	:= SC1->C1_CODCOMP
PRIVATE cA110Num 	:= SC1->C1_NUM
Ma110GraGr() // Compatibiliza aCols
	Begin Transaction
		If !A110Grava(2,cA110Num,cSolic,dA110Data,cCCusto,cUnidreq,cCodCompr,cFilEnt,cCodNatu)
			lHelpGrv := .T.
		Else
			EvalTrigger()
		EndIf
	End Transaction
	
	
return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Ponto de entrada que adiciona o botão aprovação Midori nos menus do cadastro de solicitacao...
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
user function MTA110MNU()            
// Desativado por Diego em 28/12/2018

/*aAdd( aRotina , Array( 4 ) )
nIndex 	:= Len( aRotina )
aRotina[ nIndex ][1]	:= "Aprov.Solic.Midori"
//aRotina[ nIndex ][2]	:= "A110Altera" //Rotina desativada por Anesio em 19/08/2014 para testar um erro que vem ocorrendo
aRotina[ nIndex ] [2] := "A110Aprov"    //na solicitação de compras, sendo a mesma duplicada em alguns casos sem explicacao
aRotina[ nIndex ][3]	:= 0
//aRotina[ nIndex ][4]	:= 4
aRotina[ nIndex ][4]	:= 7
*/

return (aRotina)


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Ponto de entrada que adiciona o botão Ringi Sho na visualização do pedido de vendas...
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
user function MA120BUT()
Local aButtons := {}
if !inclui .and. !altera
	Aadd( aButtons, {"S4WB011N",{ || U_AG_SCHRING()  }, OemToAnsi("Conhecimento")+" "+OemToAnsi(""), OemToAnsi("Ringi-Sho")} )	
//	Aadd( aButtons, {"NOTE",{ || U_AG_SCHAC9()  }, OemToAnsi("Aprovacao")+" "+OemToAnsi(""), OemToAnsi("Aprovar")} )	
endif 
return aButtons



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Função para mostrar a tela de RINGI SHO ao usuario na tela de solicitacao de compras
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
user function AG_SCHAC9()
if Select('TRBC1') > 0
	dbSelectArea('TRBC1')
	TRBC1->(dbCloseArea())
endif

cQSC1 := " SELECT R_E_C_N_O_ nREG, Substring(C1_FILIAL+ C1_NUM+C1_ITEM,1,12) CHAVE  FROM SC1010 WHERE D_E_L_E_T_ <> '*' AND C1_FILIAL = '"+xFilial('SC1')+"' AND C1_NUM = '"+cA110Num+"' "
dbUseArea(.T., "TOPCONN", TcGenQry (, , cQSC1), 'TRBC1', .T., .T.)
                                   

dbSelectArea('TRBC1')
TRBC1->(dbGotop())
nSolic := TRBC1->nReg

while !TRBC1->(eof())
	if Select('TMPAC9') > 0
		dbSelectArea('TMPAC9')
		TMPAC9->(dbCloseArea())
	endif
	cQAC9 := " SELECT Substring(AC9_CODENT,1,12) Where D_E_L_E_T_ <> '*' AND AC9_FILIAL = '"+xFilial('AC9')+"' AND AC9_FILENT = '"+xFilial('SC1')+"' AND AC9_ENTIDA = 'SC1' AND Substring(AC9_CODENT,1,12) = '"+TRBC1->CHAVE+"' "
	dbUseArea(.T., "TOPCONN", tcGenQry (, , cQAC9), 'TMPAC9', .T., .T.)
	
	dbSelectArea('TMPAC9')
	TMPAC9->(dbGotop())
	nCt := 0
	while !TMPAC9->(eof())
		nCt ++
		TMPAC9->(dbSkip())
	enddo
	
	if nCt > 0 	
		MsDocument('SC1', TRBC1->(nReg), 4)
	endif
	SC1->(dbSkip())
enddo


return 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Função para mostrar a tela de RINGI SHO ao usuario na tela de aprovacao do pedido de venda
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
user function AG_SCHRING() 

if Select('TRBC1') > 0
	dbSelectArea('TRBC1')
	TRBC1->(dbCloseArea())
endif

cQSC1 := " SELECT MIN(R_E_C_N_O_) nREG FROM SC1010 WHERE D_E_L_E_T_ <> '*' AND C1_FILIAL = '"+xFilial('SC1')+"' AND C1_NUM = '"+SC7->C7_NUMSC+"' "
dbUseArea(.T., "TOPCONN", TcGenQry (, , cQSC1), 'TRBC1', .T., .T.)

dbSelectArea('TRBC1')
TRBC1->(dbGotop())
nSolic := TRBC1->nReg

dbSelectArea('SC1')
dbSetOrder(1)
if dbSeek(xFilial('SC1')+SC7->C7_NUMSC)
	MsDocument('SC1', nSolic, 4)
endif		

return 

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

user function MT110CFM()
local cNome:= ""
local _cEmails  := ""
local oProcess 
local oHtml
local nCount := 0
local cTpAprov := "" 
local cGrupo1
local lVerif1 := .F.
local lVerif2 := .F.
Local _cEmails41 := GetMv("MA_EMAIL41")

dbSelectArea('SC1')
dbSetOrder(1)
dbSeek(xFilial('SC1')+cNumSC)

while !SC1->(eof()) .and.SC1->C1_NUM == cNumSC
	cTpAprov := SC1->C1_APROV
	SC1->(dbSkip())
enddo

SC1->(dbGotop())
if dbSeek(xFilial('SC1')+cNumSC)


	SETMV("MV_WFMLBOX","WORKFLOW") 
	oProcess := TWFProcess():New( "000003", "Aprovação de Solicitação de Compras" )
	oProcess :NewTask( "Aprovação de Solicitação de Compras", "\WORKFLOW\HTM\aprovSc_2.htm" )
	oHtml    := oProcess:oHTML
	
	oHtml:ValByName("ddatasolic"			,"Data da Solicitação: "+dToc(SC1->C1_EMISSAO))
	
	//---------------------------------------------------------------------------------------	
	/* Seleciona comprador na tabela SY1010 passando SC1->C1_CODCOMP como parametro 
	 * Motivo: Manter comprador HDI solicitacaco caso tenha sido excluido do grp. compras
	 * HDI: Marcio Grizoni								 Diego Mafisolli - 27/08/2013 */
	//---------------------------------------------------------------------------------------

	if Select('TMPSY1') > 0
		dbSelectArea('TMPSY1')
		TMPSY1->(dbCloseArea())
	endif

	cQSY1 := " SELECT Y1_NOME FROM SY1010 WHERE Y1_COD = '"+SC1->C1_CODCOMP+"'"
		
	dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQSY1), 'TMPSY1', .T.,.T.)		
	dbSelectArea('TMPSY1')
	TMPSY1->(dbGotop())
	
	do case 
		case cTpAprov == 'B'
			 oHtml:ValByName("ctitulo"   		,"POSIÇÃO DE SOLICITACAO DE COMPRAS - NUMERO DA SC "+cNumSC+ " - FILIAL: "+cFilant)
			 oHtml:ValByName("ddataaprov"   	,"SOLICITACAO CONTINUA BLOQUEADA")
			 oHtml:ValByName("chist"   			,"A Solicitação de compras "+cNumSC+" continua bloqueada pelo aprovador "+SC1->C1_NOMAPRO)
		case cTpAprov == 'L'
			 oHtml:ValByName("ctitulo"   		,"POSIÇÃO DE SOLICITACAO DE COMPRAS - NUMERO DA SC "+cNumSC+ " APROVADO  - FILIAL: "+cFilant)
			 oHtml:ValByName("ddataaprov"   		,"Data de Aprovação: "+dToc(SC1->C1_DTAPROV))
			 oHtml:ValByName("chist"   			,"A Solicitação de compras "+cNumSC+" inserida pelo usuario "+UsrRetName(SC1->C1_USER)+" foi liberada pelo aprovador "+SC1->C1_NOMAPRO)
			 //oHtml:ValByName("ccomprador"		,"Comprador responsável: "+Posicione('SY1',1,xFilial('SY1')+SC1->C1_CODCOMP,"Y1_NOME"))
			 oHtml:ValByName("ccomprador"		,"Comprador responsável: "+SC1->C1_CODCOMP+' - '+TMPSY1->Y1_NOME)			 
			 _cEmails  += IIF(Alltrim(SC1->C1_CODCOMP) $ '052|215|158|248|138',"",Posicione('SY1',1,xFilial('SY1')+SC1->C1_CODCOMP,"Y1_EMAIL")) + ';' + UsrRetmail(SC1->C1_USER) + ';'
			 //alert(_cEmails)
		case cTpAprov == 'R'
			 oHtml:ValByName("ctitulo"   		,"POSIÇÃO DE SOLICITACAO DE COMPRAS - NUMERO DA SC "+cNumSC+"  - FILIAL: "+cFilant)
			 oHtml:ValByName("ddataaprov"   		,"SOLICITAÇÃO REJEITADA")
			 oHtml:ValByName("chist"   			,"A Solicitação de compras "+cNumSC+" inserida pelo usuario "+UsrRetName(SC1->C1_USER)+" foi rejeitada pelo aprovador "+SC1->C1_NOMAPRO)
			 //oHtml:ValByName("ccomprador"		,"Comprador responsável: "+Posicione('SY1',1,xFilial('SY1')+SC1->C1_CODCOMP,"Y1_NOME"))
			 oHtml:ValByName("ccomprador"		,"Comprador responsável: "+SC1->C1_CODCOMP+' - '+TMPSY1->Y1_NOME)
 			 _cEmails  += IIF(Alltrim(SC1->C1_CODCOMP) $ '052|215|158|248|138',"",Posicione('SY1',1,xFilial('SY1')+SC1->C1_CODCOMP,"Y1_EMAIL")) + ';' + UsrRetmail(SC1->C1_USER) + ';'
			 //_cEmails  += UsrRetmail(SC1->C1_USER) + ';' + Posicione('SY1',1,xFilial('SY1')+SC1->C1_CODCOMP,"Y1_EMAIL") + ';'
			
	endcase 
	oHtml:ValByName("cringisho"					,"Numero Ringi-Sho: "+SC1->C1_NUMRSHO)
	//oHtml:ValByName("cmotivo"					,"Motivo Requisicao: "+SC1->C1_OBS)
	
	// Envia e-mail desenvolvedor para acompanhamento
	//_cEmails  += 'diego.mafisolli@midoriatlantica.com.br;'
	
	/*nCount:= 0        
	for i:=1 to len(_cEmails)
		if substr(_cEmails,i,1) == '@'
			nCount++
		endif
	next i 
	if nCount <= 1
		//_cEmails:= "diego.mafisolli@midoriatlantica.com.br;"
	endif   */
	dbSelectArea('SC1')
	dbSetOrder(1)
	SC1->(dbGotop())
	dbSeek(xFilial('SC1')+cNumSC)
	while !SC1->(eof()) .and.SC1->C1_NUM == cNumSC
	   	 aAdd( oHtml:ValByName( "it.cod" ), ALLTRIM(SC1->C1_PRODUTO))
	   	 aAdd( oHtml:ValByName( "it.desc" ), Posicione('SB1',1,xFilial('SB1')+SC1->C1_PRODUTO,"B1_DESC"))
	   	 aAdd( oHtml:ValByName( "it.qtde" ), SC1->C1_QUANT) 
	   	 aAdd( oHtml:ValByName( "it.unid" ), SC1->C1_UM)
	   	 aAdd( oHtml:ValByName( "it.dtnece" ), Dtoc(SC1->C1_DATPRF))
	   	 aAdd( oHtml:ValByName( "it.motivo" ), SC1->C1_OBS)
		 
		 If Select('TMPSY2') > 0
			dbSelectArea('TMPSY2')
			TMPSY2->(dbCloseArea())
		 EndIf

		 cQSY2 := " SELECT *FROM SA5010 WHERE D_E_L_E_T_ = '' AND A5_PRODUTO = '"+ALLTRIM(SC1->C1_PRODUTO)+"'"
		
		 dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQSY2), 'TMPSY2', .T.,.T.)		
		 dbSelectArea('TMPSY2')
		 TMPSY2->(dbGotop())
		 
		 aAdd( oHtml:ValByName( "it.tabela" ), TMPSY2->A5_CODTAB )
		 
		 //verifica se envia e-mail para Klisas e Marcos BFU -> Solicitacao de Marcio via e-mail 18/03/2013
		 cGrupo1 := Posicione('SB1',1,xFilial('SB1')+SC1->C1_PRODUTO,"B1_GRUPO")
		 if !lVerif1 .And. (cGrupo1 == '16  ' .Or. cGrupo1 == '20  ' .Or. cGrupo1 == '21  ' .Or. SC1->C1_CODCOMP $'052|215|158|248|138')
		 	//_cEmails += "marcos.oliveira@midoriatlantica.com.br;elisete.araujo@midoriatlantica.com.br;alessandra.lima@midoriatlantica.com.br;henrique.marzola@midoriautoleather.com.br"
		 	_cEmails  += _cEmails41
		 	lVerif1 := .T.
		 endif
		 
		// verifica codigo de comprador e envia email para coordenador departamento/setor
 		if !lVerif2 .And. SC1->C1_CODCOMP == '206' //Cassio Barreto
 			//Alert('Entrou no if')
			_cEmails += "luciano.borges@midoriautoleather.com.br;"
			lVerif2 := .T.
		endif
	   	     
	   	 SC1->(dbSkip())
	enddo
	
//	aAdd( oHtml:ValByName( "itr.rdtnece" ), "-")
//	aAdd( oHtml:ValByName( "itr.rdesc" ), "-")
//	aAdd( oHtml:ValByName( "itr.rqtde" ), "-")
//	aAdd( oHtml:ValByName( "itr.rdtnece" ), "-")

	
	oProcess:cSubject := "POSICAO DE SOLICITACAO DE COMPRAS "+cNumSC
	oProcess:cTo      := _cEmails
   	//Alert(_cEmails)
	
	if cTpAprov $ 'L'
		oProcess:Start()                    
			       //WFSendMail()
			       //WFSendMail()	       
		oProcess:Finish()                   
	endif
//	     *///Fim desativado por anesio
endif	 
return


//////////////////////////////////////////////////////////////////////////////////////////////////////////
/*Enviar e-mail quando houver a aprovacao do pedido de compra....
PARAMIXB[1]	Caracter	Número do Documento	X
PARAMIXB[2]	Caracter	Tipo do documento (PC, NF, SA, IP, AE)	X
PARAMIXB[3]	Numérico	Operação a ser executada (1-Aprovar, 2-Estornar, 3-Aprovar pelo Superior, 4-Transferir para Superior, 5-Rejeitar, 6-Bloquear)	X
PARAMIXB[4]	Caracter	Filial do documento	X
*/
////////////////////////////////////////////////////////////////////////////////////////////////////
user function MT094END()
local cNome:= ""
local oProcess 
local oHtml
local nCount := 0
Local _cEmails1:= "" 
Local _cEmails:= ""
local _cEmails := ""
Local _cEmails41 := GetMv("MA_EMAIL41")
local cTpAprov := "" 
local cNumPed  := PARAMIXB[1]
local lAprov1  := .F.
local lAprov2  := .F.
local cAprov1  := ""
local cAprov2  := ""
local dDataLib1:=""
local dDataLib2:="" 
local cGrupo2
local lVerif2 := .F.

if Select('QTMPCR1') > 0 
	dbSelectArea('QTMPCR1')
	QTMPCR1->(dbCloseArea())
endif

cQuery := " SELECT * FROM SCR010 where D_E_L_E_T_ = ' ' "
cQuery += " AND CR_FILIAL = '"+xFilial("SCR")+"' " 
cQuery += " AND CR_NUM = '"+cNumPed+"' "

dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQuery), 'QTMPCR1', .T.,.T.)

dbSelectArea('QTMPCR1')
QTMPCR1->(dbGotop())

while !QTMPCR1->(eof())

    if !lAprov2 .And. QTMPCR1->CR_NIVEL == '02' .And. QTMPCR1->CR_STATUS == '03'
    	lAprov2 := .T.
    endif                    
    
	QTMPCR1->(dbSkip())
enddo

if Select('TMPSC1') > 0
	dbSelectArea('TMPSC1')
	TMPSC1->(dbCloseArea())
endif

cQSC1 := " SELECT C1_NUM , C1_EMISSAO, C1_DTAPROV, C1_DATPRF, C1_SOLICIT, C1_EMISSAO, C1_NOMAPRO, C1_OBS, C1_USER, C1_X_CDAPR, C1_NUMRSHO "
cQSC1 += " FROM SC1010 where D_E_L_E_T_ = ' ' AND C1_FILIAL = '"+xFilial('SC1')+"' AND C1_PEDIDO = '"+cNumPed+"' "

dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQSC1), 'TMPSC1', .T.,.T.)

dbSelectArea('TMPSC1')
TMPSC1->(dbGotop())

//Destativado por Anesio em 26-05-2014- Motivo a atualizacao....precisa resolver e voltar
SETMV("MV_WFMLBOX","WORKFLOW") 
oProcess := TWFProcess():New( "000004", "Aprovação de Pedido de Compras" )
oProcess :NewTask( "Aprovação de Pedido de Compras", "\WORKFLOW\HTM\aprovPC.htm" )
oHtml    := oProcess:oHTML

oHtml:ValByName("cringisho"				,"Numero Ringi-Sho: "+TMPSC1->C1_NUMRSHO)
//oHtml:ValByName("cmotivo"				,"Motivo Requisicao: "+TMPSC1->C1_OBS)

oHtml:ValByName("cTitulo"	,"PEDIDO "+cNumPed+" APROVADO NAS 2 INSTANCIAS")
if lAprov1 .and. lAprov2
	oHtml:ValByName("cTitulo"	,"PEDIDO "+cNumPed+" APROVADO NAS 2 INSTANCIAS")
elseif lAprov1 .and. !lAprov2 
	oHtml:ValByName("cTitulo"	,"PEDIDO "+cNumPed+" APROVADO NA PRIMEIRA INSTANCIA")
endif
//dToC(sTod(QTMPCR->(CR_DATALIB)))
//oHtml:ValByName("ddatasolic"			,"Data da Solicitação: "+dToc(sToD(TMPSC1->C1_EMISSAO)))
//oHtml:ValByName("ddataaprov"   			,"Data de Aprov.Solicitacao: "+dToc(sToD(TMPSC1->C1_DTAPROV)))
//oHtml:ValByName("chist"   				,"")
//oHtml:ValByName("chistver"   			,"")


oHtml:ValByName("escnome"				,TMPSC1->C1_SOLICIT)
oHtml:ValByName("escdata"				,dToc(StoD(TMPSC1->C1_EMISSAO)))
oHtml:ValByName("ascnome"				,TMPSC1->C1_NOMAPRO)
oHtml:ValByName("ascdata"				,dToc(sToD(TMPSC1->C1_DTAPROV)))

if Select('QTMPCR') > 0 
	dbSelectArea('QTMPCR')
	QTMPCR->(dbCloseArea())
endif

cQSCR := " SELECT CR_NUM, CR_DATALIB, CR_USERLIB, CR_USER, CR_LIBAPRO FROM SCR010 where D_E_L_E_T_ = ' ' and CR_NIVEL = '02' AND CR_STATUS = '03' "
cQSCR += " AND CR_FILIAL = '"+xFilial("SCR")+"' " 
cQSCR += " AND CR_NUM = '"+cNumPed+"' "

dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQSCR), 'QTMPCR', .T.,.T.)

dbSelectArea('QTMPCR')
QTMPCR->(dbGotop())
nctcr := 0
while !QTMPCR->(eof())
	nctcr++
	QTMPCR->(dbSkip())
enddo

if nctcr > 0 
	QTMPCR->(dbGotop())
	while !QTMPCR->(eof())
		oHtml:ValByName("apcnome", UsrRetname(QTMPCR->(CR_USER)))
		oHtml:ValByName("apcdata", dToC(sTod(QTMPCR->(CR_DATALIB))))
		QTMPCR->(dbSkip())
	enddo
endif

if Select('QTMPC7') > 0 
	dbSelectArea('QTMPC7')
	QTMPC7->(dbCloseArea())
endif

cQSC7 := " SELECT C7_NUM, C7_PRODUTO, C7_QUANT, C7_USER, C7_EMISSAO, C7_OBS, C7_DATPRF FROM SC7010 WHERE D_E_L_E_T_ = ' ' AND C7_FILIAL = '"+xFilial('SC7')+"' "
cQSC7 += " AND C7_NUM = '"+cNumPed+"' "
dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQSC7), 'QTMPC7', .T.,.T.)


dbSelectArea('QTMPC7')
QTMPC7->(dbGotop())

oHtml:ValByName( "epcnome", QTMPC7->C7_USER+"-"+UsrRetname( QTMPC7->C7_USER ))
oHtml:ValByName( "epcdata", dToc(stod(QTMPC7->C7_EMISSAO)))
_cEmails += IIF(QTMPC7->C7_USER $ '001077|000004|000918|000735|001180',"",UsrRetMail(QTMPC7->C7_USER) + ';') + UsrRetMail(TMPSC1->C1_USER) + ';' + UsrRetMail(TMPSC1->C1_X_CDAPR) + ';'
//_cEmails += GetMv("MA_EMAIL41")
//-----------------------------------------------------------------------------------------------------------
// Adiciona e-mail filial 08 para receber aviso de aprovacao de pedido
// HDI - Marcio Grizoni - 26/07/2013			 Diego Mafisolli - 27/08/2013
//-----------------------------------------------------------------------------------------------------------
If SC7->C7_FILIAL == '08'
	_cEmails += 'aline.eugenio@midoriautoleather.com.br;'	
EndIf

while !QTMPC7->(eof()) 
   	 aAdd( oHtml:ValByName( "it.cod" ), QTMPC7->C7_PRODUTO)
   	 aAdd( oHtml:ValByName( "it.desc" ), Posicione('SB1',1,xFilial('SB1')+QTMPC7->C7_PRODUTO,"B1_DESC"))
   	 aAdd( oHtml:ValByName( "it.qtde" ), QTMPC7->C7_QUANT)
   	 aAdd( oHtml:ValByName( "it.dtnece" ), dToc(sTod(TMPSC1->C1_DATPRF)))
   	 aAdd( oHtml:ValByName( "it.dtent" ), dToc(sTod(QTMPC7->C7_DATPRF)))
   	 aAdd( oHtml:ValByName( "it.obs" ),QTMPC7->C7_OBS)
  	   
     //verifica se envia e-mail para Klisas e Marcos BFU -> Solicitacao de Marcio via e-mail 18/03/2013
	 cGrupo2 := Posicione('SB1',1,xFilial('SB1')+QTMPC7->C7_PRODUTO,"B1_GRUPO")
	 if !lVerif2 .and. (cGrupo2 == '16  ' .Or. cGrupo2 == '20  ' .Or. cGrupo2 == '21  ' .Or. QTMPC7->C7_USER $ '001077|000004|000918|000735|001180')//$ trecho alterado por Willer para os emails
		_cEmails += _cEmails41
	 EndIf
	 lVerif2 := .T.

   	 QTMPC7->(dbSkip())
enddo

oProcess:cSubject := "POSICAO DE PEDIDO DE COMPRAS "+cNumPed
oProcess:cTo      := _cEmails
if nctcr > 0 .And. lAprov2
	oProcess:Start()                    
		       //WFSendMail()
		       //WFSendMail()
	oProcess:Finish()     
endif

return