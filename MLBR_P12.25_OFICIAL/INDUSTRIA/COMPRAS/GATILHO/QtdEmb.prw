#Include "protheus.ch"     
//-----------------------------------------------
//Autor : AOliveira
//Data  : 05/04/2011
//Fun��o : QtdEmb
//Desc.  : Tem como Objetivo realizar o calculo de 
//         Qdt com base na Qtd.Embagem do Cad. de 
//         Produto na digita��o do PC e SC.
//
//OBS    :Para o funcionamento da rotina dever� ser criado os Gatilhos
//
// CAMPO	; Cnt.Dominio; TIPO    ; REGRA											   ; POSICIONA
// C7_QUANT ; C7_QUANT   ; Primario; M->C7_QUANT := u_QtdEmb(M->C7_PRODUTO,M->C7_QUANT); N�o
// C1_QUANT ; C1_QUANT   ; Primario; M->C1_QUANT := u_QtdEmb(M->C1_PRODUTO,M->C1_QUANT); N�o
//-------------------------------------
User Function QtdEmb (CodProd,Qtd)
Local nEmbalagem	:= Posicione("SB1",1,xFilial("SB1")+CodProd,"B1_QE")
Local nQtd1			:= Qtd
Local nQtd2			:= nQtd1
Local _nRet			:= nQtd2
Local nMod			:= If(nEmbalagem == 0,0,nQtd2 % nEmbalagem)
Local cRestr        := Posicione("SB1",1,xFilial("SB1")+CodProd,"B1_X_RESTR") //Restri��o a compra

//While nMod <> 0 
While Int(nMod) <> 0    //AOliveira 08-11-2011 
	nQtd2 ++
	nMod := nQtd2 % nEmbalagem
EndDo

If _nRet <> nQtd2
	_nRet := nQtd2 
	Aviso('Aten��o','Qtde por Embalagem: ( '+Alltrim(Str(nEmbalagem))+' )'+CHR(13)+CHR(10)+;
 		  'Qtde Solicitada: ( '+Alltrim(Str(nQtd1))+' )'+CHR(13)+CHR(10)+;
          'Qtde a Solicitar dever� ser: ( '+Alltrim(Str(_nRet))+' )',{'Ok'})	
EndIf

//Bloco implementado para alertar os usu�rios quando for fazer uma SC 
//Caso o produto tenha restri��o cadastrada em B1_X_RESTR 
//B1_X_RESTR == '1' Alerta o usu�rio para analisar o produto antes de solicitar
//B1_X_RESTR == '2' zera _nRet para que o usu�rio n�o fa�a a solicita��o...
//Implementado por Anesio em 08/05/2015 - anesio@outlook.com
if cRestr == '1'
	ApMsgInfo('O produto '+ALLTRIM(Posicione("SB1",1,xFilial("SB1")+CodProd,"B1_DESC"))+CHR(13)+CHR(10)+;
		'est� com restri��o para solicita��o de compras '+CHR(13)+CHR(10)+;
		'Favor verificar ', 'Aten��o', {'Ok'})
elseif cRestr == '2'
	Alert('O produto '+ALLTRIM(Posicione("SB1",1,xFilial("SB1")+CodProd,"B1_DESC"))+CHR(13)+CHR(10)+;
		'est� bloqueado para solicita��o de compras '+CHR(13)+CHR(10)+;
		'Favor verificar ', 'Aten��o')
	_nRet := 0
endif

Return(_nRet)