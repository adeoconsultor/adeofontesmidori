# Include 'Protheus.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110TOK  �Autor  �Humberto Garcia     � Data �  04/09/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para valida��o da GetDados da solicita��o ���
���          | de compras.                                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

LOCALIZA��O : Function A110TudOk() respons�vel pela valida��o da GetDados da Solicita��o de Compras .

EM QUE PONTO : O ponto se encontra no final da fun��o e deve ser utilizado para valida��es especificas do usuario onde ser� controlada pelo retorno do ponto
de entrada o qual se for .F. o processo ser� interrompido e se .T. ser� validado.
*/
/*
User Function MT110TOK

If empty(cCodCompr)
	Msginfo("Obrigat�rio o preenchimento do c�digo do comprador. Em caso de d�vidas contate o departamento de suprimentos para mais informa��es.")
	lRet := .F.
Else
	lRet := .T.
Endif

Return(lRet)
#Include "PROTHEUS.Ch" 
/*
----------------------------------------------------------------------------------------
Funcao: MT110TOK														Data: 26.07.2012
Autor : Vinicius Schwartz - TI Midori Atlantica
----------------------------------------------------------------------------------------
Objetivo: PONTO DE ENTRADA PARA OBRIGAR A INFORMA��O DO CODIGO DO COMPRADOR
          CONFORME SOLICITADO HDI 004709 
Manutencao 28/01/2013: Objetivo -> De acordo com HDI 005008 (Marcia) foi incluido uma
          validacao para verificar se a data base do sistema esta menor do que a data atual,
          e caso esteja o sistema barra, impossibilitando a conclusao do processo.
----------------------------------------------------------------------------------------
*/

User Function MT110TOK
Local 	nRingSho	:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_RINGSHO"})
Local 	nNumRing	:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_NUMRSHO"})
Local 	cFinalSC	:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_X_FINSC"})
Local 	cProduto	:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_PRODUTO"})
Local 	cBlqRSho	:= Getmv('MA_BLQRSHO')
Local   nRegBloq 	:= 0
Local 	nI                      //Contador no For
Local 	nJ                      // Contador no For
Local   lRet     	:= ParamIXB[1] //.T.      Paramametro do MATA110
Local   dDtAtiva := "20181001" //Data para ativa��o bloq
Local  	cUsr := RetCodUsr()
Private nProd    	:= aScan(aHeader,{|x| Trim(x[2])=="C1_PRODUTO"})      //Procura no aHeader o Campo C1_Produto
Private cRollout := IIf( DtoS(Date()) >= dDtAtiva,"S","")


	If cCodCompr == Space(3)
		Alert ("Favor informar um comprador!!!")
		lRet := .F.
	Else
//		Alert("Comprador: "+cCodCompr)
		lRet := .T.
	Endif
	
	If dDatabase < Date()
		Alert('Data base menor que data atual. Favor verificar!')
		lRet := .F.
	Endif
//Inclusoes solicitadas por Anesio 20/09/18 - ticket 7900	--willer 
If cRollout == "S"
	If !cUsr $ ('000441|000000|000021|000031')
		For nI := 01 To Len( aCols )        // De 1 ateh o numero de linhas do aCols

			dbSelectArea( "SB1" )           //Abre a tabela SB1
			dbSetOrder(1)
			If dbSeek(xFilial() + aCols[nI,nProd])   // Procura no aCols a linha(nI) do campo especificado no aHeader(nProd - que busca o campo C1_PRODUTO)

				If AllTrim(SB1->B1_GRUPO) $ '16|48'        
					If !Alltrim(SB1->B1_XBACKN) $ ('PPAPF|PPAPI|NA')
						Aviso("Atencao!", "Producao n�o liberado pelo setor da Qualidade para Solicit. Compra " + aCols[nI,nProd] + chr(13);
						+"Campo Aprova��o PPAP n�o preenchido.",{ "OK" } )			
						lRet := .F.
						Return (lRet)
					Else
						lRet := .T.
					
					EndIf
	   	    
				EndIf
		
			EndIf    
	
		Next nI
	Endif		
EndIf
Return (lRet)