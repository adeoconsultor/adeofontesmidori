#include "protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ JUCCTB002º Autor ³ Marcio             º Data ³  18/09/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ GATILHO PARA PREENCHIMENTO DOS CAMPOS CONTABEIS PELA SZA   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO - CONTABILIDADE X PRODUTOS                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION MIDCTB02()
LOCAL cRet		:= &(ReadVar())
LOCAL aArea		:= GetArea()
LOCAL cTipoProd := M->B1_TIPO
LOCAL cGrpProd	:= M->B1_GRUPO
LOCAL lExiste	:= .F.

DbSelectArea("ZZW")
DbSetOrder(1)

// VERIFICA PRIMEIRO PELA CHAVE COMPLETA PARA:
// 1- SE EXISTIR UMA REGRA PARA TIPO + GRUPO - UTILIZA ESTA REGRA
// 2- CASO CONTRARIO UTILIZA A REGRA GENERICA PARA O TIPO
IF DbSeek(xFilial("ZZW")+cTipoProd+cGrpProd,.F.)
	lExiste := .T.
ELSEIF DbSeek(xFilial("ZZW")+cTipoProd,.F.)
	lExiste := .T.
ENDIF

IF lExiste 

		M->B1_CONTA 	:= ZZW ->ZZW_CONTA 	
		M->B1_ICMREC 	:= ZZW ->ZZW_ICMREC 	
		M->B1_ICMPAG 	:= ZZW ->ZZW_ICMPAG 	
		M->B1_ICMDEV 	:= ZZW ->ZZW_ICMDEV 	
		M->B1_ICMVD 	:= ZZW ->ZZW_ICMVD 	
		M->B1_ICMST 	:= ZZW ->ZZW_ICMST 	
		M->B1_IPIREC 	:= ZZW ->ZZW_IPIREC 	
		M->B1_IPIPAG	:= ZZW ->ZZW_IPIPAG	
		M->B1_IPIDEV	:= ZZW ->ZZW_IPIDEV	
		M->B1_IPIVD		:= ZZW ->ZZW_IPIVD	
		M->B1_PISREC 	:= ZZW ->ZZW_PISREC 	
		M->B1_PISPAG	:= ZZW ->ZZW_PISPAG	
		M->B1_PISDEV	:= ZZW ->ZZW_PISDEV	
		M->B1_PISVD     := ZZW ->ZZW_PISVD    
		M->B1_COFREC 	:= ZZW ->ZZW_COFREC 	
		M->B1_COFPAG	:= ZZW ->ZZW_COFPAG	
		M->B1_COFDEV	:= ZZW ->ZZW_COFDEV	
		M->B1_COFVD		:= ZZW ->ZZW_COFVD	
		M->B1_PODER3 	:= ZZW ->ZZW_PODER3 	
		M->B1_PODEM3	:= ZZW ->ZZW_PODEM3	
		M->B1_CPV   	:= ZZW ->ZZW_CPV   	
		M->B1_RECEITA   := ZZW ->ZZW_RECEITA
		M->B1_DEVVD		:= ZZW ->ZZW_DEVVD
		M->B1_DEVCP		:= ZZW ->ZZW_DEVCP
		M->B1_FUNRUR	:= ZZW ->ZZW_FUNRUR
		M->B1_SAT		:= ZZW ->ZZW_SAT
		M->B1_SENAR		:= ZZW ->ZZW_SENAR
		M->B1_MONSTO	:= ZZW ->ZZW_MONSTO
		M->B1_ELABOR	:= ZZW ->ZZW_ELABOR
		M->B1_X_ESTMP	:= ZZW ->ZZW_ESTMP
		M->B1_X_INVEN   := ZZW ->ZZW_X_INVE   
	
ELSE

		M->B1_CONTA 	:= " " 
		M->B1_ICMREC 	:= " " 
		M->B1_ICMPAG 	:= " " 
		M->B1_ICMDEV 	:= " " 
		M->B1_ICMVD 	:= " "
		M->B1_ICMST 	:= " "
		M->B1_IPIREC 	:= " "
		M->B1_IPIPAG	:= " "
		M->B1_IPIDEV	:= " "
		M->B1_IPIVD		:= " "	
		M->B1_PISREC 	:= " "
		M->B1_PISPAG	:= " "
		M->B1_PISDEV	:= " "
		M->B1_PISVD     := " " 
		M->B1_COFREC 	:= " "
		M->B1_COFPAG	:= " "
		M->B1_COFDEV	:= " "
		M->B1_COFVD		:= " "	
		M->B1_PODER3 	:= " "
		M->B1_PODEM3	:= " "
		M->B1_CPV   	:= " "
		M->B1_RECEITA   := " "
		M->B1_DEVVD		:= " "
		M->B1_DEVCP		:= " "
		M->B1_FUNRUR	:= " "
		M->B1_SAT		:= " "
		M->B1_SENAR		:= " "
		M->B1_MONSTO	:= " "
		M->B1_ELABOR	:= " "
		M->B1_X_ESTMP	:= " "


ENDIF

RESTAREA(aArea)
RETURN cRet