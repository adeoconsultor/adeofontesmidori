#INCLUDE "RWMAKE.ch"    
#INCLUDE "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณVLDMAIL     บAutor: Diego Mafisolli      บ Data ณ 27/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function DM_VLDMAIL(cEmail)
local nCont := 1
local lRet   := .T.
local nResto := 0
  
If cEmail $ "{}()<>[]|\/&*$%?!^~`,:=# "
	APMSGALERT("Email invแlido. Informe um endere็o de e-mail vแlido.","Atencao") 
	lRet := .F.

else

	if ( nResto := at( "@", cEmail )) > 0 .and. at( "@", right( cEmail, len( cEmail ) - nResto )) == 0 
	
	     if ( nResto := at( ".", right( cEmail, len( cEmail ) - nResto ))) > 0 
	
	        lRet := .T.
	
	     else
	
	        APMSGALERT("Email invแlido. Informe um endere็o de e-mail vแlido.","Atencao") 
	
	        lRet := .F. 
	
	    endif
	
	else

     APMSGALERT("Email invแlido. Informe um endere็o de e-mail vแlido.","Atencao")  

     lRet := .F. 

	endif

endif


return lRet