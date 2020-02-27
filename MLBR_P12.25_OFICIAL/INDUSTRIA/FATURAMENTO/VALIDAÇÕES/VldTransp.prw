# Include 'Protheus.ch'


/*
Programa: VldTransp
Autor: Humberto Garcia
Finalidade e descrição:
Utilizado na validaçõa do campo C5_TRANSP, para checagem se a transportadora está bloqueada ou não.
*/                                                                                                 

                      

//-----------------------------
User Function VldTransp
//-----------------------------
Local aAreac5 := GetArea()
Local cBloq := Posicione("SA4",1,xFilial("SA4")+M->C5_TRANSP,"A4_BLOQUEI")
Local lRet  := .T.

If cBloq = "S"                                                                    
   lRet := .F.
   MsgInfo("Transportadora bloqueada para utilização! Contate o departamento fiscal para mais informações.")
Endif

RestArea (aAreac5)
Return(lRet)