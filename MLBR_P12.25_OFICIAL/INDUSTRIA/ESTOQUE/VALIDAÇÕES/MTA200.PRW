#include 'protheus.ch'

user function MTA200()
local lRet := .T.
Local cParam := PARAMIXB
Local cEmail := ""    
       
If cFilAnt == '08'       
	
	cEmail := "guilherme.basilio@midoriautoleather.com.br"    
	
	If PARAMIXB == 'A' //Alteracao 
		VSS_ENVMAIL(cEmail,CPRODUTO,CCODPAI,"Atualizacao") 
	Endif      
	
	If PARAMIXB == 'E' //Exclusao  
		VSS_ENVMAIL(cEmail,CPRODUTO,CCODPAI,"Exclusao de Item") 
	Endif
	
	If PARAMIXB == 'I' //Exclusao  
		VSS_ENVMAIL(cEmail,CPRODUTO,M->G1_COMP,"Inclusao Novo Item") 
	Endif 
Endif


Static Function VSS_ENVMAIL(_cEmail,_cProd, _cComp, _cAcao)

Local oHtml
Local nCont := 0
Local oProcess

SETMV("MV_WFMLBOX","WORKFLOW")
cProcess := OemToAnsi("001001")
cStatus  := OemToAnsi("001001")
//_cProc  := OemToAnsi(cProc)

oProcess:= TWFProcess():New( '001001')
oProcess:NewTask( cStatus, "\WORKFLOW\HTM\AltEstrut.htm" )
oHtml    := oProcess:oHTML

aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")                    
aAdd( oHtml:ValByName( "it.desc" ), "Cod.Comp./Produto: "+ _cComp +" ")
aAdd( oHtml:ValByName( "it.desc" ), "Ação: "+ _cAcao +" ")  
aAdd( oHtml:ValByName( "it.desc" ), "Data: "+ DTOC(DDATABASE) +" ")
aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")

oProcess:cSubject := "ALTERAÇÃO ESTRUTURA: "+_cProd

oProcess:cTo      := _cEmail

oProcess:Start()
oProcess:Finish()
Return()

return  lRet