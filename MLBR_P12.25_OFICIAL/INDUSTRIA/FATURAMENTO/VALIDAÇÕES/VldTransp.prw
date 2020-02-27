# Include 'Protheus.ch'


/*
Programa: VldTransp
Autor: Humberto Garcia
Finalidade e descri��o:
Utilizado na valida��a do campo C5_TRANSP, para checagem se a transportadora est� bloqueada ou n�o.
*/                                                                                                 

                      

//-----------------------------
User Function VldTransp
//-----------------------------
Local aAreac5 := GetArea()
Local cBloq := Posicione("SA4",1,xFilial("SA4")+M->C5_TRANSP,"A4_BLOQUEI")
Local lRet  := .T.

If cBloq = "S"                                                                    
   lRet := .F.
   MsgInfo("Transportadora bloqueada para utiliza��o! Contate o departamento fiscal para mais informa��es.")
Endif

RestArea (aAreac5)
Return(lRet)