#Include "Protheus.ch"
#Include "RwMake.ch"   
#include "Parmtype.ch"
/*---------------------------------------------------------
Funcao: CT101TOK  | Autor: AOliveira   | Data:	 04/02/2020
-----------------------------------------------------------
Descri.: PE - validar o tipo de saldo na inclus�o manual de
         lan�amento contabil - Rotina CTAB101
-----------------------------------------------------------
Uso    : Midori
---------------------------------------------------------*/
User function CT101TOK()

Local lRet := .T.

Local cTpSld := Paramixb[10]  //outros parametros ver na documenta��o TDN
Local nOpc	 := Paramixb[11]  //nOpc = 3-INCLUSAO / 4-ALTERACAO / 5-EXCLUSAO / 7-COPIA

/*
IF RetCodUsr() $ "000113|000242"	//TRativa para usuarios.
	Return(.T.)
ENDIF
*/

If nOpc == 5 // EXCLUS�O
	
	If cTpSld <> "9" 
		Aviso("Aten��o","Exclusao n�o permitida para lan�amentos com o tipo de saldo real!",{"Ok"},1)
		lRet := .F.
	EndIf
	
Else
	
	If cTpSld <> "9" 
		Aviso("Aten��o","N�o � permitida a inclusao/altera��o de lan�amentos contabeis com o tipo de saldo real!",{"Ok"},1)
		lRet := .F.
	EndIf
	
EndIf

Return(lRet)