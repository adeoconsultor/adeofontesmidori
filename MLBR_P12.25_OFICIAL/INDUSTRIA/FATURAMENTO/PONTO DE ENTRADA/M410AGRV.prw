#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ M410AGRV ³ Autor ³ Willer Trindade       ³ Data ³ 28.09.15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Faz validacao especifica para codigo FCI					  ³±±
±±³          ³ 					                                          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ M410AGRV                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico: Midori Atlantica                               ³±±
±±³          ³ Ponto de Entrada antes de gravar pedido.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ WILLER       ³23/11/10³ ---  ³ GRAVAR O USUARIO QUE EFETUOU A INCLUSAO³±±
±±³              ³        ³      ³                                        ³±±
±±³              ³        ³      ³                                        ³±±
±±³              ³        ³      ³                                        ³±±
±±³              ³        ³      ³                                        ³±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function M410AGRV()

Local _aArea    := GetArea()
Local lRet 		:= .T.
Local nX


Local dDatFat	:= DtoC(dDataBase)
Local cItem 	:= ""
Local cProd		:= ""
Local cClaFis	:= ""
Local cCodFCI	:= ""
Local cClaUtl	:= ""
Local nOpc		:= ParamIxb[1]

Local nPosPrd	:= aScan(aHeader,{|x|AllTrim(x[2]) == "C6_PRODUTO"})
Local nPosIt 	:= aScan(aHeader,{|x|AllTrim(x[2]) == "C6_ITEM"})
Local nPosCla	:= aScan(aHeader,{|x|AllTrim(x[2]) == "C6_CLASFIS"})
Local nPosFCI 	:= aScan(aHeader,{|x|AllTrim(x[2]) == "C6_FCICOD"})


If Funname() == "MATA410" /// Para nao contemplar o modulo de Exportacao - Willer
	
	If  IsInCallStack( "A410Deleta" ) .OR. IsInCallStack( "A410ProcDv" ) .OR. IsInCallStack( "A410Devol" )
		Return
	EndIf
	
	Reclock("SC5",.F.)
	Replace	C5_XINCLUI With RETCODUSR()+'-'+ALLTRIM(SUBSTR(CUSUARIO,7,15))+' -  EM '+DTOC(DDATABASE)
	MSUnlock("SC5")
	
	
	For nX:= 1 to len(aCols)
		
		cClaFis := aCols[nX][nPosCla]
		cItem 	:= aCols[nX][nPosIt]
		cProd	:= aCols[nX][nPosPrd]
		cCodFCI	:= aCols[nX][nPosFCI]
		
		DbSelectArea("SB1")//Inserido por Willer validar B1_ORIGEM
		SB1->(dbSetOrder(1))
		DbSeek( xFilial("SB1") + Alltrim(cProd))
			
			AtuClas :=  SB1->B1_ORIGEM
			cClaUtl :=	Substr(cClaFis,2,3)
			_cClaFis	:= 	Alltrim(AtuClas+cClaUtl)
			aCols[nX][nPosCla]:= Alltrim(_cClaFis)
						
		If Substr(_cClaFis,1,1) $ '3|5|8' .And. Empty(cCodFCI)
			DbSelectArea("CFD")
			CFD->(dbSetOrder(2))
			If DbSeek( xFilial("CFD") + Alltrim(cProd)+ Alltrim(Substr(dDatFat,4,2)+ Substr(dDatFat,7,4)))
				If !Empty(CFD->CFD_FCICOD)
					aCols[nX][nPosFCI] := CFD->CFD_FCICOD 
				EndIf
			Else
				/*cClaUtl :=	Substr(cClaFis,2,3)
				cClaFst	:= '0'
				aCols[nX][nPosCla]	:= 	Alltrim(cClaFst+cClaUtl)*/
				MsgAlert('O Item '+cItem+' do produto '+cProd+' de origem "3|5|8" está sem Código da FCI '+chr(13)+'Favor verificar com setor Fiscal','Atenção')
			EndIf			
		EndIf	
		
	Next nX

EndIf
RestArea(_aArea)

Return()

	