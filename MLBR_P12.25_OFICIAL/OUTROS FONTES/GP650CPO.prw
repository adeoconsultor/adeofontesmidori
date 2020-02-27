#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GP650CPO  �Autor  �Alessandro Lima     � Data �  17/12/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava o prefixo com o codigo da filial e o titulo de pensao���
���          � com o fornecedor correto                                   ���
�������������������������������������������������������������������������͹��
���Uso       � MIDORI                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GP650CPO()

Local cQuery_	:= ""
Local _cCodSA2	:= ""
Local _cCampo	:= ""       
Local _cLoja	:= ""
Local cTextAviso:= ""
Local cAlias    := ""

_aArea := GetArea()

RC1->RC1_PREFIX := RC1->RC1_FILTIT

If Subs(cCodTit,1,1) == "P" //Titulos pens�o alimenticia

	//�����������������������������������������Ŀ
	//� Trata campo para Titulo de Pensao       �
	//�������������������������������������������
	If cCodTit $ ("P01-P02-P03-P04-P05")
		_cCampo := "VERBFOL"
	ElseIf cCodTit $ ("P06-P07-P08-P09-P10")
	    _cCampo := "VERBADI"
	ElseIf cCodTit $ ("P11-P12-P13-P14-P15")
	    _cCampo := "VERBFER"
	ElseIf cCodTit $ ("P16-P17-P18-P19-P20")
	    _cCampo := "VERB131"
	ElseIf cCodTit $ ("P21-P22-P23-P24-P25")
	    _cCampo := "VERB132"
	EndIF
	                                                  
	//����������������������������������������Ŀ
	//� Retorna o c�digo do Fornecedor         �
	//������������������������������������������
	cQuery_ := " SELECT A2_COD, A2_LOJA"
	cQuery_ += " FROM " + RETSQLNAME("SA2") + " SA2, " + RETSQLNAME("SRQ") + " SRQ, " + RETSQLNAME("RC1") + " RC1 "
	cQuery_ += " WHERE SUBSTRING('"+RC1->RC1_CODTIT+"',1,1) = 'P' "
	cQuery_ += " AND SRQ.RQ_FILIAL = '"+RC1->RC1_FILTIT+"' "
	cQuery_ += " AND SRQ.RQ_MAT = '"+RC1->RC1_MAT+"' "
	cQuery_ += " AND RC1.RC1_FILTIT = SRQ.RQ_FILIAL " 
	cQuery_ += " AND RC1.RC1_MAT = SRQ.RQ_MAT " 
	cQuery_ += " AND SRQ.RQ_CIC = SA2.A2_CGC "
	cQuery_ += " AND SA2.A2_MSBLQL <> '1' "
	cQuery_ += " AND SUBSTRING('"+RC1->RC1_VERBAS+"',1,3) = SRQ.RQ_"+_cCampo
	cQuery_ += " AND SRQ.RQ_SEQUENC = '01' "
	cQuery_ += " AND RC1.D_E_L_E_T_ <> '*' "         
	cQuery_ += " AND SRQ.D_E_L_E_T_ <> '*' "        
	cQuery_ += " AND SA2.D_E_L_E_T_ <> '*' "
	cQuery_ := CHANGEQUERY(cQuery_)                  
	                                                   
	//����������������������������������������Ŀ
	//� Cria alias conforme resultado da query �
	//������������������������������������������
	If Select("ARQTRB") >0
		dbSelectArea("ARQTRB")
	    dbCloseArea()
	EndIf
	                
	TCQUERY cQuery_ NEW ALIAS "ARQTRB"  
	                
	_cCodSA2 := ARQTRB->A2_COD
	_cLoja   := ARQTRB->A2_LOJA
	                
	If !Empty(_cCodSA2)
		RC1->RC1_FORNEC := _cCodSA2
		RC1->RC1_LOJA   := _cLoja
	Else
		RC1->RC1_FORNEC := "NAOCAD"
		RC1->RC1_LOJA   := "XX"
		cTextAviso:="Nao existe Fornecedor cadastrado para o Beneficiario do Funcionario.:" + CHR(13)+CHR(10)
		cTextAviso+=RC1->RC1_FILTIT+"-"+RC1->RC1_MAT
		Aviso('Atencao',cTextAviso,{'Ok'})
	EndIf
	
EndIf

RestArea( _aArea )

Return
