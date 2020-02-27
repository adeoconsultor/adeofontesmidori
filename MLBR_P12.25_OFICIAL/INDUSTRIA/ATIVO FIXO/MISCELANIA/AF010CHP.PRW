#include 'rwmake.ch'
#include 'protheus.ch'

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Função para validar se permitirá um ativo ser classificado com a mesma chapa
//Desenvolvido por Anesio G.Faria em 02/01/2014
//Especificamente para classificação de bens que vem desmemblado e precisa constar do mesmo ativo.(Barbosa NF.000.119.509)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

user function AF010CHP()
local lRet := .T.
local cChapa := M->N1_CBASE
if ApMsgYesNo('Deseja permitir a duplicidade do bem, "Caso Exista!!!"','Atenção')
	lRet := .T.
else
	IF Empty(cChapa)
		HELP( " ",1,"AFA010JAEX" )	// Criar Help (Este campo nao pode ficar em branco)
		lRet := .F.	
	ELSE
		dbSelectArea("SN1")
		dbSetOrder(2)
		IF dbSeek(xFilial("SN1")+cChapa)
			HELP( " ",1,"AFA010CHAP" )		/// Criar Help (Esta chapa ja existe.)
			lRet := .F.
		ENDIF
	ENDIF
endif

return lRet