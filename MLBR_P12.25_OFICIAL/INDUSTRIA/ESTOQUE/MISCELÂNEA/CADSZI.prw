#INCLUDE "rwmake.ch"


User Function CADSZI()



//³ Declaracao de Variaveis                                             ³
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cPerg   := "SZI"
Private cString := "SZI"

dbSelectArea("SZI")
dbSetOrder(1)

cPerg   := "SZI"

Pergunte(cPerg,.F.)
SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros

AxCadastro(cString,"Cadastro de Camadas de Cortes",cVldExc,cVldAlt)


Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros


Return


//função para nao permitir que um mesmo KIT/COMPONENTE seja cadastrado 2 vezes 
user function AG_VLDZI(cCodKit, cCodMat)
local lRet := .T.
dbSelectArea("SZI")
dbSetOrder(1) //ZI_FILIAL+ZI_CODKIT+ZI_MATERIA
if dbSeek(xFilial("SZI")+cCodKit+cCodMat)
	Alert("O Material "+ALLTRIM(Posicione("SB1",1,xFIlial("SB1")+cCodMat, "B1_DESC"))+chr(13);
	+"já está cadastrado para o KIT "+ALLTRIM(Posicione("SB1",1,xFIlial("SB1")+cCodKit, "B1_DESC"))+;
	chr(13)+"Lançamento nao permitido...")
	lRet := .F.	 
endif



return lRet