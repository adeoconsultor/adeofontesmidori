#Include "Protheus.ch"
#Include "Rwmake.ch"
/*
* Funcao : MT120FIX  | AOliveira 19-11-20119
* Descri : Manipula a ordem dos campos do array aFixe.
*/
User function MT120FIX ()
Local X
Local aAreaSC7 := SC7->(GetArea())
Local aFixe    := {}     

aAdd(aFixe,{"Enviou Email","C7_XEEMAIL"})

For X:=1 to Len(paramIxb)
	aAdd(aFixe,{paramIxb[X][1],paramIxb[X][2]})
Next X         
                        
RestArea(aAreaSC7)

Return(aFixe)