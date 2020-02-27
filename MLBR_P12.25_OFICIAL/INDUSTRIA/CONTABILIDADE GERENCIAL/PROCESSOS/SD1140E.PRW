#include 'Protheus.ch' 
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "topconn.ch"

//////////////////////////////////////////////////////////////////////////////////////////
//Programa de para envio de e-mail automatico ao setor de contabilidade
//sempre que houver o cancelamento de alguma nota fiscal
//////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br - 05-05-2012               
///////////////////////////////////////////////////////////////////////////
//Manutencao por Vinicius Schwartz - TI - Midori Atlantica em 29/10/12
//Chamada da funcao VSS_StatNF - Atualizar tabela SZO (Rastreabilidade) - Ref Thiago/Fabio - HDI 004883
///////////////////////////////////////////////////////////////////////////

User Function SD1140E()
Local cStat


if SD1->D1_ITEM == '0001' 
//	U_MAILCANF(SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA, SF1->F1_TIPO, SF1->F1_EMISSAO, "PRE-NOTA" )
	cStat := "EXC"
	If cFilAnt == '09'
		U_VSS_StatNF (cStat)
	endif	
endif
Return 

User Function SD1100E()
Local cStat

If SD1->D1_ITEM == '0001'
	cStat := "EXC"
	If cFilAnt == '09'
		U_VSS_StatNF (cStat)
	endif
EndIf

If SD1->D1_ITEM == '0001' .And. !Empty(SF1->F1_DTLANC)  //Alterado por willer conforme solicitação Contabil/Andre/15/02/16
	U_MAILCANF(SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA, SF1->F1_TIPO, SF1->F1_EMISSAO, "CONTABILIZADA")
EndIf	

Return


user function MAILCANF(cNota, cSerie, cFornece, cLoja, cTipo, cDataNF, cSitua) //Envio de e-mail quando ha cancelamento de nota fiscal de entrada
local cNome		:= ""
local _cEmails	:= GetMv('MA_EMAIL02') //Emails para Fiscal/Contab1
local oProcess 
local oHtml
local nCount	:= 0
Local cCodUs	:= UsrFullName(RetCodUsr() ) 


if cTipo $ 'N|C' 
	dbSelectArea('SA2')
	dbSetOrder(1)
	dbSeek(xFilial('SA2')+cFornece+cLoja)
	cNome := SA2->A2_NOME
else
	dbSelectArea('SA1')
	dbSetOrder(1)
	dbSeek(xFilial('SA1')+cFornece+cLoja)
	cNome := SA1->A1_NOME
endif


SETMV("MV_WFMLBOX","WORKFLOW") 
oProcess := TWFProcess():New( "000003", "Itens com variação de custo" )
oProcess :NewTask( "CANCELAMENTO DE NOTA DE ENTRADA", "\WORKFLOW\HTM\CANCELNF.HTM" )
oHtml    := oProcess:oHTML

	 oHtml:ValByName("Data"			,dToc(dDatabase))
	 oHtml:ValByName("numNF"   		,cNota+'-'+cSerie)
	 
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	 aAdd( oHtml:ValByName( "it.desc" ), "OCORREU A EXCLUSAO DA NOTA FISCAL "+cNOTA+" SERIE "+cSerie+" EMITIDA EM "+dToc(cDataNF))
   	 if cTipo == 'N' 
	   	 aAdd( oHtml:ValByName( "it.desc" ), "FORNECEDOR "+cFornece+"-"+cLoja+"  "+cNome)
	 else
	   	 aAdd( oHtml:ValByName( "it.desc" ), "NOTA DE "+ IIF(Alltrim(cTipo)=='D','DEVOLUCAO', IIF(Alltrim(cTipo)=='C','COMPLEMETAR', IIF(Alltrim(cTipo)=='B','BENEFICIAMENTO',' '))) + IIF(Alltrim(cTipo)=='C'," DO FORNECEDOR"," DO CLIENTE ")+cFornece+"-"+cLoja+"  "+cNome)
	 endif
   	 aAdd( oHtml:ValByName( "it.desc" ), "FILIAL DE ORIGEM "+cFilant)
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	 aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
	 aAdd( oHtml:ValByName( "it.desc" ), "USUARIO QUE FEZ A EXCLUSAO: "+Alltrim(cCodUs))
   	 aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	 

oProcess:cSubject := "CANCELAMENTO/EXCLUSAO DE NOTA FISCAL " +cNota+" SERIE "+cSerie+" SITUACAO "+cSitua+" | FILIAL "+cFilAnt
oProcess:cTo := _cEmails
oProcess:Start()                    
//WFSendMail()      
oProcess:Finish()

//Alert('E-mail enviado...')
Return