#include 'protheus.ch'
#include 'rwmake.ch'
#include 'TOPCONN.CH'
/*
Funcao: VSS_ESTSEG																						Data: 14/02/2013
Objetivo: Filtrar todos os casos em que o produto possui uma quantidade minima de estoque de seguranca informada e caso
		essa quantidade seja menor que a quantidade disponivel do produto sera enviado um e-mail informativo aos responsaveis.
Desenvolvido por: Vinicius Schwartz - TI - vinicius.schwartz@midoriatlantica.com.br
*/

User Function VSS_ESTSEG()
Local cQuery := ""
Local aLstProd := {}

//Verifica se existe tabela temporárias e caso exista encerra a mesma
If Select ('ESTSEG') > 0
	DbSelectArea('ESTSEG')
	ESTSEG->(DbCloseArea())
Endif


cQuery := " SELECT B1_ESTSEG, B1_COD, B1_DESC, B1_UM, B1_GRUPO, SUM(B2_QATU) ATUAL, SUM(B2_QEMP) EMP, SUM(B2_RESERVA) RESERVA "
cQuery += " FROM "
cQuery += " 	SB2010 B2 "
cQuery += " LEFT JOIN SB1010 B1 "
cQuery += " ON B1.D_E_L_E_T_ = '' "
cQuery += " AND B1.B1_COD = B2.B2_COD "
cQuery += " WHERE 
cQuery += " 	B2_FILIAL = '04' AND "
cQuery += " 	B1.B1_COD IN (SELECT B1_COD FROM SB1010 WHERE B1_ESTSEG != 0) AND "
cQuery += " 	B2.D_E_L_E_T_ = '' "
cQuery += " GROUP BY "
cQuery += " 	B1_ESTSEG, B1_COD, B1_DESC, B1_UM, B1_GRUPO "
cQuery += " HAVING "
cQuery += " 	(SUM(B2_QATU) - SUM(B2_QEMP) - SUM(B2_RESERVA)) < (B1_ESTSEG) "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery),"ESTSEG",.T.,.T.)

ESTSEG->(DbGoTop())

//B2_COD, B1_DESC, B1_ESTSEG, (ATUAL - EMP - RESERVA)
While !ESTSEG->(Eof())
	Aadd(aLstProd,{ESTSEG->B1_COD, ESTSEG->B1_DESC, ESTSEG->B1_UM, ESTSEG->B1_GRUPO, ESTSEG->B1_ESTSEG, (ESTSEG->ATUAL - ESTSEG->EMP - ESTSEG->RESERVA)})
	ESTSEG->(DbSkip())
Enddo

ESTSEG->(DbCloseArea())

//Chama funcao para envio de e-mail
if len(aLstProd) > 0 
	VSS_ENVMAIL(aLstProd)
endif

Return


/*--------------------------------------------
------Inicio de envio de e-mail----------
--------------------------------------------*/

Static Function VSS_ENVMAIL(aLstProd)
Local _cEmail := GetMv('MA_ESTSEG')
Local i



//RpcSetEnv("01","04","","","","",{"SRA"})
//Alert('Iniciando envido e e-mail...')
SETMV("MV_WFMLBOX","WORKFLOW") 
oProcess := TWFProcess():New( "000004", "Itens com Estoque de Seguranca atingido" )
oProcess:NewTask( "Itens com Estoque de Seguranca atingido", "\WORKFLOW\HTM\ESTSEG.HTM" )
oHtml    := oProcess:oHTML
//oHtml:ValByName("Data"			,dToc(dData))
		                                     
If len(aLstProd) > 0
	for i:= 1 to len(aLstProd)
		aAdd( oHtml:ValByName( "it.cod" ), aLstProd[i][1])
		aAdd( oHtml:ValByName( "it.desc" ), aLstProd[i][2])
		aAdd( oHtml:ValByName( "it.um" ), aLstProd[i][3])
		aAdd( oHtml:ValByName( "it.grp" ), aLstProd[i][4])
		aAdd( oHtml:ValByName( "it.qtdseg" ), aLstProd[i][5])
		aAdd( oHtml:ValByName( "it.qtddisp" ), aLstProd[i][6])
	next i
Else
	aAdd( oHtml:ValByName( "it.cod" ), "Nenhum")
	aAdd( oHtml:ValByName( "it.desc" ), "Nenhum")
	aAdd( oHtml:ValByName( "it.um" ), "Nenhum")
	aAdd( oHtml:ValByName( "it.grp" ), "Nenhum")
	aAdd( oHtml:ValByName( "it.qtdseg" ), "Nenhum")
	aAdd( oHtml:ValByName( "it.qtddisp" ), "Nenhum")
Endif
	   	 
	   	    	                                 
oProcess:cSubject := "Itens com Estoque de Seguranca atingido"
		
		
	
oProcess:cTo      := _cEmail

oProcess:Start()                    
       //WFSendMail()
       //WFSendMail()	       
oProcess:Finish()

//Alert('Email enviado com sucesso...')

Return