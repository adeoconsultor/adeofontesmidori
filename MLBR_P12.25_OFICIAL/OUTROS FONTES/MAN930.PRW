#include "rwmake.ch"
#include "tbiconn.ch"
#include 'protheus.ch'

/*
+-------+--------------+---------+---------------------------+---------+-------------+
|Função | MAM930     | Autor:  | WILLER TRINDADE             | Data:   | 13/09/04    |
+-------+--------------+---------+---------------------------+---------+-------------+
| Atualiza o Dolar,Euro,Yenn pela taxa de venda do ultimo dia util ant a data atual  |
+-------------+----------------------------------------------------------------------+
| Uso:        | Modulo Importação  SCHEDULE                                         |
+-------------+----------------------------------------------------------------------+
|            ALTERACOES FEITAS DESDE A CRIACAO DO PROGRAMA:                          |
+--------------------+-----------+---------------------------------------------------+
|Programador         | Data      | Descrição                                         |
+--------------------+-----------+---------------------------------------------------+
| 					 | 			 | 													 |
|								   									 				 |
+--------------------+-----------+---------------------------------------------------+
*/


User Function Man930()


Private ncont := 0
Private lAuto		:= .F.
Private dDataRef, dData
Private nValDolar, nValYen, nValEuro
Private nValReal	:= 1.000000
Private nValUfir	:= 0.828700
Private nN		:= 0
Private nS1, nS2, nS3
Private nI1, nI2, nI3
Private oDlg
Private nDiasPro	:= 999
Private nDiasreg	:= 999

//Testa se esta sendo rodado do menu
If	Select('SX2') == 0
	RPCSetType( 3 )						//Não consome licensa de uso
	RpcSetEnv('01','01',,,,GetEnvServer(),{ "SM2" })
	//sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
	ConOut('Atualizando Moedas... '+Dtoc(DATE())+' - '+Time())
	lAuto := .T.
EndIf

If	( ! lAuto )
	LjMsgRun(OemToAnsi('Atualização On-line BCB'),,{|| xExecMoeda()} )
Else
	xExecMoeda()
EndIf

If	( lAuto )
	RpcClearEnv()		   				//Libera o Environment
	ConOut('Moedas Atualizadas. '+Dtoc(DATE())+' - '+Time())
EndIf
Return
//--------------------------------------------------------------------------
Static Function xExecMoeda()
Local nPass, cFile, cTexto, nLinhas, cLinha, cdata, cCompra, cVenda, J, nK, L
Local cUrl := 'http://www4.bcb.gov.br/Download/fechamento/'


For nPass := 0 to 0 step -1					//Refaz os ultimos 6 dias. O BCB não disponibiliza periodo maior de uma semana
	
	dDataRef := (dDataBase) - nPass
	

		//Finais de Semana
	If	Dow(dDataRef) == 2				//Se for segunda
		cFile := Dtos(dDataRef - 3)+'.csv'
	ElseIf	Dow(dDataRef) == 3  				
		cFile := Dtos(dDataRef - 1)+'.csv'
	ElseIf	Dow(dDataRef) == 4  				
		cFile := Dtos(dDataRef - 1)+'.csv'	
	ElseIf	Dow(dDataRef) == 5  				
		cFile := Dtos(dDataRef - 1)+'.csv'	
	ElseIf	Dow(dDataRef) == 6  				
		cFile := Dtos(dDataRef - 1)+'.csv'		
	EndIf
	
	
	cTexto  := HttpGet(cUrl+cFile)
	cTexto	:= StrTran(cTexto, Chr(10), Chr(13)+Chr(10))
	
	If Substr(cTexto,1,21) == '<!DOCTYPE HTML PUBLIC'
		ConOut('Data nao disponivel  from BCB '+cFile+' In '+Dtoc(DATE())+Space(2)+Time())
		Return
	EndIf
	
	
	If	( lAuto )
		ConOut('Downloading from BCB '+cFile+' In '+Dtoc(DATE()))
	EndIf
	If ! Empty(cTexto)
		nLinhas := MLCount(cTexto, 81)
		For J	:= 1 to nLinhas
			cLinha	:= Memoline(cTexto,81,J)
			aDados  := Separa(cLinha,";",.T.)
			
			If !(aDados[2]) $ '220*470*978*540*706'
				Loop
			Endif
			
			cData  	:= aDados[1]	// Data
			cCompra := StrTran(aDados[5],',','.') //StrTran(Substr(cLinha,22,14),',','.')//Caso a empresa use o Valor de Compra nas linhas abaixo substitua por esta variável
			cVenda  := StrTran(aDados[6],',','.') //StrTran(Substr(cLinha,37,14),',','.')//Para conversão interna nas empresas normalmente usa-se Valor de Venda
			
			If	( aDados[2]=='220' )	//Seleciona o Valor do Dolar
				dData		:= Ctod(cData)
				nValDolar	:= Val(cVenda)
			EndIf
			
			If	( aDados[2]=='470' )	//Seleciona o Valor do Yen
				dData		:= Ctod(cData)
				nValYen		:= Val(cVenda)
			EndIf
			
			If	( aDados[2]=='978' )	//Seleciona o Valor do Euro
				dData		:= Ctod(cData)
				nValEuro	:= Val(cVenda)
			EndIf
			
			If	( aDados[2]=='540' )	//Seleciona o Valor do Euro
				dData		:= Ctod(cData)
				nValLibEs	:= Val(cVenda)
			EndIf
			
			If	( aDados[2]=='706' )	//Seleciona o Valor do Euro
				dData		:= Ctod(cData)
				nValPesAr	:= Val(cVenda)
			EndIf
		Next
	Endif
	GravaDados()                            		//Grava Dados do Período selecionado em "J"
Next

Return
//--------------------------------------------------------------------------
Static Function GravaDados()
//--------------------------------------------------------------------------
Local dDataRef := dData
Local dDataTow := dDataBase+1

DbSelectArea("SM2")						//Grava Moedas
SM2->(DbSetorder(1))

If SM2->(DbSeek(Dtos(dData)))
	Reclock('SM2',.F.)
	SM2->M2_MOEDA1	:= nValReal				//Real
	SM2->M2_MOEDA2	:= nValDolar			//Dolar
	SM2->M2_MOEDA3	:= nValUfir				//Ufir
	SM2->M2_MOEDA4	:= nValEuro				//Euro
	SM2->M2_MOEDA5	:= nValYen				//Yen
	SM2->M2_MOEDA6	:= nValLibEs			//Libra Esterlina
	SM2->M2_TXMOE6	:= nValPesAr			//Peso Argentino
	SM2->M2_INFORM	:= "S"
	MsUnlock('SM2')
Else
	Reclock('SM2',.T.)
	SM2->M2_DATA	:= dData
	SM2->M2_MOEDA1	:= nValReal				//Real
	SM2->M2_MOEDA2	:= nValDolar			//Dolar
	SM2->M2_MOEDA3	:= nValUfir				//Ufir
	SM2->M2_MOEDA4	:= nValEuro				//Euro
	SM2->M2_MOEDA5	:= nValYen				//Yen
	SM2->M2_MOEDA6	:= nValLibEs			//Libra Esterlina
	SM2->M2_TXMOE6	:= nValPesAr			//Peso Argentino
	SM2->M2_INFORM	:= "S"
	MsUnlock('SM2')
EndIf        

If SM2->(DbSeek(Dtos(dDataTow)))
	Reclock('SM2',.F.)
	SM2->M2_MOEDA1	:= nValReal				//Real
	SM2->M2_MOEDA2	:= nValDolar			//Dolar
	SM2->M2_MOEDA3	:= nValUfir				//Ufir
	SM2->M2_MOEDA4	:= nValEuro				//Euro
	SM2->M2_MOEDA5	:= nValYen				//Yen
	SM2->M2_MOEDA6	:= nValLibEs			//Libra Esterlina
	SM2->M2_TXMOE6	:= nValPesAr			//Peso Argentino
	SM2->M2_INFORM	:= "S"
	MsUnlock('SM2')
Else
	Reclock('SM2',.T.)
	SM2->M2_DATA	:= dData
	SM2->M2_MOEDA1	:= nValReal				//Real
	SM2->M2_MOEDA2	:= nValDolar			//Dolar
	SM2->M2_MOEDA3	:= nValUfir				//Ufir
	SM2->M2_MOEDA4	:= nValEuro				//Euro
	SM2->M2_MOEDA5	:= nValYen				//Yen
	SM2->M2_MOEDA6	:= nValLibEs			//Libra Esterlina
	SM2->M2_TXMOE6	:= nValPesAr			//Peso Argentino
	SM2->M2_INFORM	:= "S"
	MsUnlock('SM2')
EndIf

If 	dDataRef = dDataBase
	SRV_ENVMAIL(nValDolar, nValEuro, nValYen, nValLibEs)
EndIf

Return        

/*--------------------------------------------
------Inicio de envio de e-mail----------
--------------------------------------------*/
Static Function SRV_ENVMAIL(nValDolar, nValEuro, nValYen, nValLibEs)

Local oHtml
Local oProcess
Local cEmlFor := GetMv ('MV_EMFCOT')//financeiro
Local cProc := "Cotação de Moedas"

SETMV("MV_WFMLBOX","WORKFLOW")
cProcess := OemToAnsi("001020")
cStatus  := OemToAnsi("001020")
_cProc  := OemToAnsi(cProc)

oProcess:= TWFProcess():New( '001020', _cProc )
oProcess:NewTask( cStatus, "\WORKFLOW\HTM\cotamoedas.htm" )
oHtml    := oProcess:oHTML
oHtml:ValByName("Data"			,DTOC(DDATABASE))
oHtml:ValByName("acao"			,_cProc)

aAdd( oHtml:ValByName( "it.desc" ), "*********************************************************************************************************************************************")
aAdd( oHtml:ValByName( "it.desc" ), "Abaixo a cotação das moedas gravadas no sistema.")
aAdd( oHtml:ValByName( "it.desc" ), "Cotações das moedas no dia"+Space(2)+ DTOC(DDATABASE)+" às 13:00 (horário de Brasília), conforme fechamento PTAX.")
aAdd( oHtml:ValByName( "it.desc" ), "Para outras moedas acesse: http://www4.bcb.gov.br/pec/taxas/batch/cotacaomoedas.asp?id=txtodas")
aAdd( oHtml:ValByName( "it.desc" ), "*********************************************************************************************************************************************")
aAdd( oHtml:ValByName( "it.desc" ), "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
aAdd( oHtml:ValByName( "it.desc" ), "Dolar USD : "+ Alltrim(TRANS(nValDolar,	'@E 999.9999')))
aAdd( oHtml:ValByName( "it.desc" ), "Euro		: "+ Alltrim(TRANS(nValEuro,	'@E 999.9999')))
aAdd( oHtml:ValByName( "it.desc" ), "Yenne Jap	: "+ Alltrim(TRANS(nValYen,		'@E 999.999999')))
aAdd( oHtml:ValByName( "it.desc" ), "Libra Est : "+ Alltrim(TRANS(nValLibEs,	'@E 999.9999')))
aAdd( oHtml:ValByName( "it.desc" ), "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
aAdd( oHtml:ValByName( "it.desc" ), "*********************************************************************************************************************************************")


oProcess:cSubject := _cProc + " do Banco Central "



oProcess:cTo      := cEmlFor

oProcess:Start()

oProcess:Finish()

Return(Nil)
