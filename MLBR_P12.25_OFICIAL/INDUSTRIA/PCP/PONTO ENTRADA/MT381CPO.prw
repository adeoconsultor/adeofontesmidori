#INCLUDE "TOPCONN.CH"

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � MT381CPO  � Autor � Antonio              � Data �  22/09/16  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Valida��o para n�o deixar incluir produtos que n�o estejam na���
���          � estrutura no ajuste de empenhos                              ���
���������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                    	���
���������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum 	                                                 	���
���������������������������������������������������������������������������Ĵ��
���Uso       � SIGAPCP                                                      ���
����������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������� ��
*/
User Function MT381CPO()

Local lRet     := .F.
Local cQuery   := ""
Local cAliasZ  := GetNextAlias()
Local nPosCod  := ""
Local aAreaSG1 := GetArea()                
Local cUsrLib  := GetMv ('MA_381ULIB') //Usuarios com permissao para empenhar produtos que nao esta na estrutura

If IsInCallStack('MATA650')
	cQuery := " SELECT SG1.G1_COD, SG1.G1_COMP, SG1.G1_QUANT, SG1.G1_PERDA  "
	cQuery += " FROM "+RetSqlName("SG1")+" SG1 " 
	cQuery += " WHERE SG1.G1_FILIAL  = '" + xFilial("SG1") + "'  AND "
	cQuery += "       SG1.G1_COD     = '" + SC2->C2_PRODUTO + "' AND "
	cQuery += "       SG1.D_E_L_E_T_ = '  ' "
//	If Select(cAliasZ) > 0
//		(cAliasZ)->(dbCloseArea())	
//	EndIf 
Else 

	cQuery := " SELECT SG1.G1_COD, SG1.G1_COMP, SG1.G1_QUANT, SG1.G1_PERDA  "
	cQuery += " FROM "+RetSqlName("SG1")+" SG1 " 
	cQuery += " WHERE SG1.G1_FILIAL  = '" + xFilial("SG1") + "'  AND "
	cQuery += "       SG1.G1_COD     = '" + SC2->C2_PRODUTO + "' AND "
	cQuery += "       SG1.D_E_L_E_T_ = '  ' "

/*
	cQuery := " SELECT SC2.C2_NUM , SC2.C2_PRODUTO, SC2.C2_QUANT, SC2.C2_EMISSAO, "
	cQuery += "        SG1.G1_COMP, SG1.G1_QUANT  , SG1.G1_PERDA, SD4.D4_LOTECTL  "
	cQuery += " FROM "+RetSqlName("SC2")+" SC2 "     
	cQuery += " INNER JOIN "+RetSqlName("SG1")+" SG1 ON ( SG1.G1_FILIAL  = '" + xFilial("SG1") + "' AND "
	cQuery += "                                           SG1.G1_COD     = SC2.C2_PRODUTO           AND "
	cQuery += "                                           SG1.D_E_L_E_T_ = '  ' ) "
	cQuery += " INNER JOIN "+RetSqlName("SD4")+" SD4 ON ( SD4.D4_FILIAL  = '" + xFilial("SD4") + "' AND "
	cQuery += "                                           SD4.D4_COD     = SG1.G1_COMP              AND "
	cQuery += "                                 SUBSTRING(SD4.D4_OP,1,6) = SC2.C2_NUM               AND "
	cQuery += "                                           SD4.D_E_L_E_T_ = '  ' ) "
	cQuery += " WHERE SC2.C2_FILIAL  = '" + xFilial("SC2") + "' AND "                          
	cQuery += "       SC2.D_E_L_E_T_ = '  '                     AND " 
	If IsInCallStack('MATA381')
		cQuery += "       SC2.C2_NUM     = '" + SUBSTR(cOP,1,6) + "' "
	ElseIf IsInCallStack('MATA380')
		If Empty(M->D4_OP)
			lRet:=.T.
		EndIf
		cQuery += "       SC2.C2_NUM     = '" + SUBSTR(M->D4_OP,1,6) + "' "                          
	EndIf*/
//	If Select(cAliasZ) > 0
//		(cAliasZ)->(dbCloseArea())	
//	EndIf 
EndIf 

cQuery := ChangeQuery(cQuery)
TCQUERY cQuery NEW ALIAS (cAliasZ)
//TCSetField((cAliasZ),"C2_EMISSAO","D",8,0)

(cAliasZ)->(dbGoTop())

nPosCod  :=aScan(aHeader,{|x| AllTrim(x[2])=="G1_COMP"})

While !(cAliasZ)->(Eof())

	If IsInCallStack('MATA381')
		If ReadVar() == 'M->D4_COD'
			If M->D4_COD == (cAliasZ)->G1_COMP .AND. !aCols[n,Len(AHeader)+1]
				lRet := .T.   
			EndIf
		Else
			lRet := .T.   
		EndIf
	ElseIf IsInCallStack('MATA380')
		If M->D4_COD == (cAliasZ)->G1_COMP
			lRet := .T.   
		EndIf
	ElseIf IsInCallStack('MATA650')
    //    If !Empty(aCols[n,nPosCod])
	//		If aCols[n,nPosCod] == (cAliasZ)->G1_COMP         //M->G1_COMP == (cAliasZ)->G1_COMP
	//			lRet := .T.   
	//		EndIf
	//	Else
			If ReadVar() == 'M->G1_COMP'
				If M->G1_COMP == (cAliasZ)->G1_COMP
					lRet := .T.   
				EndIf
			EndIf
//		EndIf
	EndIf
	
	(cAliasZ)->(dbSkip())

EndDo

If !lRet .And. !RetCodUsr() $ cUsrLib
	msgAlert("Aten��o.. Este componente n�o pertence a estrutura do produto, n�o poder� ser adicionado ao Empenho da OP !!!")
	lRet := .F.   
Else 
	lRet := .T.
EndIf

(cAliasZ)->(dbCloseArea())	
RestArea(aAreaSG1)
   
Return lRet                               
