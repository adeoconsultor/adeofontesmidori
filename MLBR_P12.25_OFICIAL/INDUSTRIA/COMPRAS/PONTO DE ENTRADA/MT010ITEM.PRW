#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
/*-----------------------------------------------------------------------------------------
Funcao ITEM()   |Autor: AOliveira      |Data: 23-01-2018         (MT010ITEM)
-------------------------------------------------------------------------------------------
Desc.: PE no padrao MCV executado na rotina MATA010   (Antigo MT010INC e todos do MATA010)
-------------------------------------------------------------------------------------------
IDs. : MODELCOMMITTTS -> Utilizado para gravação dos campos B1_HISTBLQ e
B1_MOTIV.
-------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------*/
User Function ITEM()//Nome o ID do Modelo de Dados (Model) ou Nome da rotina

Local aParam := PARAMIXB
Local oModel   := FwModelActive()
Local xRet := .T.
Local oObj := ''
Local cIdPonto := ''
Local cIdModel := ''
Local lIsGrid := .F.

Local nLinha := 0
Local nQtdLinhas := 0
Local cMsg := ''

//
/*variaveis utilizada no PE A010TOK*/
Local cVldNcm := GetMv ('MA_VLDNCM') //Valores validos S/N/A
Local cGrp	  := GetMv ('MA_GRPPER') //Grupo de compras permitidos
Local _cEmlFor
Local cProc
Local cRetMail
Local cBlq
Local cGrupoM
Local cDesc1
Local cDesc2
Local nNcm
Local nIPI
Local cUM
Local cB5OK := 'N'
Local cOrig

Local cGrp1 := GetMv ('MA_GRPR01') //Grupos que serao considerados -> Workflow: Cadastro->Compras->Fiscal->Cadastro - Email para Fiscal
Local cGrp2 := GetMv ('MA_GRPR02') //Grupos que serao considerados -> Workflow: Cadastro->Compras->Fiscal->Cadastro - Email para Fiscal/Contab1
Local cGrp3 := GetMv ('MA_GRPR03') //Grupos que serao considerados -> Workflow: Cadastro->Compras->Fiscal->Cadastro - Email para Fiscal/Contab2
Local cGrp4 := GetMv ('MA_GRPR04') //Grupos que nao entraram no workflow - Excecao
Local cGrp5 := GetMv ('MA_GRPR05') //Grupos 100,91

Local cGrMid := getmv('MA_GRPMIDO') //Os grupos que constarem nesse parametro deve ser obrigatorio o preenchimento do campo B1_MIGRMID
Local cCodPer		:= Alltrim(SuperGetMv("MA_EXCPROD"))


Private	cCodUs	:= UsrFullName(RetCodUsr() )
Private lBloq
//

If aParam <> NIL
	
	oObj := aParam[1]
	cIdPonto := aParam[2]
	cIdModel := aParam[3]
	lIsGrid := ( Len( aParam ) > 3 )
	
	
	If cIdPonto == 'FORMCOMMITTTSPRE'
		
		If !PARAMIXB[4]
			Reclock("SB1",.F.)
			SB1->B1_MOTIV := " "
			MSUnlock("SB1")
		Endif
		
		If PARAMIXB[4]
			
			If !Empty(SB1->B1_GRUPO)
				If Alltrim(SB1->B1_GRUPO) $ Alltrim(cGrp1) .Or. Alltrim(SB1->B1_GRUPO) $ Alltrim(cGrp2) .Or. Alltrim(SB1->B1_GRUPO) $ Alltrim(cGrp3) .Or. Alltrim(SB1->B1_GRUPO) $ Alltrim(cGrp5)
					Reclock("SB1",.F.)
					SB1->B1_MSBLQL := '1'
					MSUnlock("SB1")
					
				Else
					Reclock("SB1",.F.)
					SB1->B1_MSBLQL := '2'
					MSUnlock("SB1")
					
				EndIf
			Endif
			DbSelectArea('SYD')      //implementado verificação ncm conforme hdi 005191
			DbSetOrder(1)
			If DbSeek (xFilial('SYD')+ M->B1_POSIPI)
				If SYD->YD_RETOPER == '1'
		   			M->B1_PIS   	:= '1'
					M->B1_COFINS 	:= '1'
					M->B1_RETOPER	:= '1'
				EndIf
   			EndIf
			dbCloseArea()
		EndIf                      
	EndIf
EndIf
Return(xRet)
