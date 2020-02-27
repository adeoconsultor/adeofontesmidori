#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.ch"
/*
----------------------------------------------------------------------------------------
Funcao: MTA010OK														Data: 13.03.2014
Autor : Willer Trindade
----------------------------------------------------------------------------------------
Objetivo: PONTO DE ENTRADA ENVIA EMAIL AO RESPONSAVEIS FISCAL UTILIZANDO FUNCAO
VSS_EMAIL QDO TENTATIVA DE EXCLUIR PRODUTO, NAO PERMITE EXCLUSAO MESMO, CONFORME
HDI 005132
--------------------------------------------------------------------------------------*/
User Function MTA010OK()

Local aAreaAnt 		:= GetArea()
Local lRet 			:= .T.
Local cCodPer		:= Alltrim(SuperGetMv("MA_EXCPROD"))

Private cCodUs

If (!RetCodUsr() $ cCodPer)
	cCod	:= SB1->B1_COD
	cGrupo  := SB1->B1_GRUPO
	cDesc1  := SB1->B1_DESC
	cCodUs	:= UsrFullName(RetCodUsr() )
	
	_cEmlFor := Alltrim(GetMV( "MA_EMAIL01" )) //fiscal
	cProc := "Exclusao Produto"
	VSS_ENVMAIL(cCod,cGrupo,cDesc1,_cEmlFor, cProc)
	
	Alert('Nao existe permissao para exclusao de produtos cadastrados, se estiver errado favor contatar Depto Suprimentos ou Fiscal para alteracao do mesmo.')
	lRet := .F.
EndIf
RestArea(aAreaAnt)
Return(lRet)
/*--------------------------------------------
------Inicio de envio de e-mail----------
--------------------------------------------*/
Static Function VSS_ENVMAIL(cProd, cGrupo, cDescProd, _cEmlFor, cProc)

Local oProcess
Local oHtml
Local nCont := 0

SETMV("MV_WFMLBOX","WORKFLOW") 
oProcess := TWFProcess():New( "000008", cProc )
oProcess:NewTask( cProc, "\WORKFLOW\HTM\VldExc.htm" )
oHtml    := oProcess:oHTML
oHtml:ValByName("Data"			,DTOC(DDATABASE))
oHtml:ValByName("Prod"   		,cProd)
oHtml:ValByName("acao"			,cProc)

aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
aAdd( oHtml:ValByName( "it.desc" ), "PRODUTO: "+cProd+" DO GRUPO: "+cGrupo)
aAdd( oHtml:ValByName( "it.desc" ), "DESCRICAO: "+cDescProd )
// 	 aAdd( oHtml:ValByName( "it.desc" ), "QUANTIDADE: "+cValToChar(nqtde) )
aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
aAdd( oHtml:ValByName( "it.desc" ), "Exclusao por : "+cCodUs)
aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")


oProcess:cSubject := cProc + "- Produto: " + cProd + "- Grupo: " + cGrupo



oProcess:cTo      := _cEmlFor

oProcess:Start()

oProcess:Finish()                      

Return
