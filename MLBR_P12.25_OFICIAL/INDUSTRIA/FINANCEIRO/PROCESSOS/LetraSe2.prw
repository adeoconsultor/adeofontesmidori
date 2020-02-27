#Include 'Protheus.ch'

/*-------------------------------------------------------------------------------------
Fun��o: LetraSe2()
Autor:  Humberto Garcia Liendo
---------------------------------------------------------------------------------------
Uso e Finalidade: Utilizada na valida��o de usu�rio do campo E2_NUM para que n�o possa
ser digitado letras neste campo.
---------------------------------------------------------------------------------------

*/

User Function LetraSe2
                                                               
Local nX
Local cRet := .T.           

For nX:= 1 to Len(M->E2_NUM)
	If  IsAlpha(Substr(M->E2_NUM,nX,1))
		MsgStop("O campo n� do t�tulo n�o pode conter letras.")
    	cRet := .F.
	    Return(cRet)

	EndIf                                                         
Next

Return(cRet)

