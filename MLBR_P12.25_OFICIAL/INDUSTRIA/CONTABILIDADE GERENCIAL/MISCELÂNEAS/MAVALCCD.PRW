#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
//
//
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MAVALCCD � Autor � Sandro Albuquerque � Data �  01/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida se o C. CUSTOS inclusao do  Ctas a Pagar e Movimento���
���          � bancario � do grupo 3 e filial diferente de 01 e 18.		  ���
���          � Gatilho E5_CCD e E2_CCD e ponto de entrada no compras	  ���
���          � MAVALCCD   => Funcao para validar centro de custos         ���
���          �       cCpo => Lancamento PAdrao em uso.                    ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���   Uso    � PROTHEUS 10- Midori                                        ���
�������������������������������������������������������������������������ͼ��     
���27/01/11  � Alterado por Sandro Albuquerque conforme Help Desk 002584  ���
���          � para valida��o dos Centros de Custos e Unidade de Origem   ���
���          � na inclusao do item da NFE associado ao Ponto de Entrada   ���
���          � MT140LOK.PRW.                                              ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//
//
User Function MAVALCCD(cCCD, cITC)
// Se o campo E5_CCD ou E2_CCD tiver um centro de custos iniciados com digito
// diferente de 3 e a filial n�o for Midori SP ou Guarulhos, retorna branco.
_cRet := cCCD

IF !Empty(cITC)
	                                       
	Do case
		Case cFilant $ '01|18' .and. Alltrim(cITC) $ '01|18'    // Quando item e a filial for SP/GUA utiliza C. Custo 1, 4 e 5.
			
			IF !(substr(cCCD,1,1) $ '1|3|4|5') //Acrescentado o Centro de Custo Iniciado por 3 em 18/10/2012 por solicitacao do Sr.Mauri para atender 
												//ao modelo de uso de Cartao para quem viaja.
				Alert("Somente CENTROS DE CUSTOS iniciados com 1,4 e 5 s�o permitidos...")
				_cRet := '   '
				
			EndIF
			
		Case cFilant $ '01|18' .and. !(Alltrim(cITC) $ '01|18')     // Quando a filial for SP ou GUA e Item contabil diferente de 01/18 (outra filial).
			IF substr(cCCD,1,1) <> '3'
				Alert("Somente CENTROS DE CUSTOS iniciados com 3 s�o permitidos...")
				_cRet := '   '
				
			EndIF
			
		Case !(cFilant $ '01|18') .and. !(Alltrim(cITC) $ '01|18')   // Filiais e Unid. de Origem Diferentes de SP/GUA.
			IF substr(cCCD,1,1) <> '3'
				Alert("Somente CENTROS DE CUSTOS iniciados com 3 s�o permitidos...")
				_cRet := '   '
				
			EndIF
			
		Case !(cFilant $ '01|18') .and. (Alltrim(cITC) $ '01|18') // Filiais diferente de SP/GUA e Unid. de Origem = SP/GUA
			IF !(substr(cCCD,1,1) $ '1|3|4|5') //Acrescentado o Centro de Custo Iniciado por 3 em 18/10/2012 por solicitacao do Sr.Mauri para atender 
												//ao modelo de uso de Cartao para quem viaja.
				Alert("Somente CENTROS DE CUSTOS iniciados com 1,4 e 5 s�o permitidos...")
				_cRet := '   '
				
			EndIF
	EndCase
Else
	Alert("Unidade de Origem n�o preenchida no Pedido ou na Nota Fiscal ...")
	_cRet := '   '

EndIF

Return(_cRet) // Retorna branco ou o centro de custos correto
