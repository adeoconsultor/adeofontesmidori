User Function testesem
       
MDTFIM:=CTOD('15/12/09')
MDTINI:=CTOD('01/01/09')
MDIAS:= (MDTFIM-MDTINI)

Msemanas:=INT(MDIAS/7)

MSGINFO(MSEMANAS)        
                         
Dias_Uteis(MDTFIM,MDTINI)
                             
Return 

STATIC FUNCTION Dias_Uteis(PDt_ini,PDt_fim)
#define Sabado  "Saturday"
#define Domingo "Sunday"

LOCAL MDt_fim, MDias, MSemanas, MSab_Dom,;
      MDt_base, MPrazo

IF(Empty(PDt_fim))
   MDt_fim:= dDataBase
Else
   MDt_fim:= PDt_fim
Endif

MSab_Dom:=2 * ( MSemanas:=INT( (MDias:=MDt_fim-PDt_ini) / 7 ) )
MDt_base:=PDt_ini + MSemanas*7

WHILE MDt_base <= MDt_fim

      IF CDOW(MDt_base) = Sabado .OR. CDOW(MDt_base) = Domingo
         MSab_Dom++
      ENDIF

      MDt_base++
ENDDO

MPrazo:=If(MDias-MSab_Dom<0,0,MDias-MSab_Dom)

IF MPrazo > 99999
   MPrazo:=99999
ELSEIF MPrazo < -9999
   MPrazo:=99998
ENDIF
RETURN MPrazo

