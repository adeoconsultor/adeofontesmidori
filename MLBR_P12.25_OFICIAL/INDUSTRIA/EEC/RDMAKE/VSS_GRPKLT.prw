#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VSS_GRPKLTºAutor  ³ Vinicius Schwartz  º Data ³  26/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Projeto Geracao do Packing List                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso.      ³Rotina p selecao dos pallets que farao parte do packing listº±±
±±º          ³Permite ao usuario selecionar os pallets que serao utiliza -º±±
±±º          ³dos para montagem do pedido de exportacao gerado pelo impex º±±
±±º          ³antes de passar para unidade de PNP1 acertar os detales dos º±±
±±º          ³itens a serem exportados. A rotina trabalha com os dados queº±±
±±º          ³foram gerados na tabela ZZL(separados por classificacao), e º±±
±±º          ³de acordo com as selecoes de pallets feitas pelo usuario eh º±±
±±º          ³gravado os registros na tabelz ZZB que sera integrada ao pe-º±±
±±º          ³dido criado inicialmente.								      º±±
±±º          ³O objetivo foi substituir a inclusao manual dos registros,  º±±
±±º          ³sendo que atualmente os dados sao gravados no BD a partir daº±±
±±º          ³rotina VSS_MSEC2.PRW										  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function VSS_GRPKLT(cPedido)
Local oBrowse                                      
Local cQry
Public nSeq
Public nItem
Private aRotina
Public cCodMae

//Procura o num. do pedido na tabela EE8 e verifica se eh valido
DbSelectArea('EE8')
DbSetOrder(1)
If DbSeek(xFilial('EE8')+cPedido)
	cCodMae := EE8_COD_I
	nSeq 	:= EE8_SEQUEN
Else
	Alert ('Pedido não localizado. Verifique ou informe o Administrador do sistema!')
	Return
Endif
EE8->(DbCloseArea())


//Verifica o ultimo registro de item na tabela ZZB para gravar o proximo
If Select("MAXZZB") > 0
	dbSelectArea("MAXZZB")
	MAXZZB->(dbCloseArea())
Endif
	
cQry := " SELECT MAX(ZZB_ITEM) SEQUEN "
cQry += " FROM ZZB010 "
cQry += " WHERE ZZB_FILIAL = '"+xFilial("ZZB")+"' AND ZZB_PEDIDO = '"+cPedido+"' AND D_E_L_E_T_ <> '*' "

cQry:= ChangeQuery(cQry)
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry),"MAXZZB",.T.,.T.)

dbSelectArea("MAXZZB")

//Se for maior ou igual a 1, entao soma 1, senao inicia com valor 1
If MAXZZB->SEQUEN < '001'
	nItem := 1
Else 
	nItem := Val(MAXZZB->SEQUEN) + 1
Endif

//Atribui a chamada da funcao U_SELPLT no botão "Gera Registros" no menu aRotina
aRotina := { 	{ OemToAnsi("Gera Registros")   , "U_SELPLT(cPedido,cCodMae,nSeq,nItem)", 	0, 3}}  	//"Gera Registros" -> Grava ZZB a partir da ZZL

If !MsgYesNo ('Deseja selecionar os pallets referente ao pedido?')
	Return
Endif


oBrowse := FWMarkBrowse():New() 
oBrowse:SetAlias('ZZL')
oBrowse:SetFieldMark( 'ZZL_OK' )
oBrowse:AddLegend( "ZZL_STATUS=='OK'", "GREEN", "CONCLUIDO" )
oBrowse:AddLegend( "ZZL_STATUS<>'OK'", "RED"  , "PENDENTE"  )
///oBrowse:SetFilterDefault("ZP_EMBARC <> 'S' ")
oBrowse:SetDescription('Selecao de Paletes')
oBrowse:Activate()
Return Nil

 
/////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////    
/*
Static Function MenuDef()
Local aRot := {}                                                                      

	ADD OPTION aRot TITLE 'Gerar Pedido' ACTION 'U_SELPLT(cPedido,cCodMae,nSeq,nItem)' OPERATION 2 ACCESS 0  

Return aRot
*/
/////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////
Static Function ModelDef()

Local oStruZP := FWFormStruct(1,'ZZL')
Local oModel
oModel := MPFormModel():New('ZZL_001')
oModel:AddFields('ZZLMASTER',/*cOwner*/,oStruZZL)
oModel:SetDescription('Selecao de Palete')
oModel:GetModel('ZZPMASTER'):SetDescription('Embarque de Planos...')
Return oModel 


/////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////
Static Function ViewDef()
Local oModel := FWFormModelGrid( 'VSS_GRPKLT' )
Local oStruZZL := FWFormStruct( 2, 'ZZL' )
Local oViewDef := FWFormView():New()

oViewDef:SetModel( oModel )
oViewDef:AddGrid( 'VIEW_ZZL', oStruZZL, 'VSS_GRPKLT' )

oViewDef:CreateHorizontalBox( 'SUPERIOR', 40 )
//oViewDef:CreateHorizontalBox( 'INFERIOR', 60 )

oViewDef:SetOwnerView( 'VIEW_ZZL', 'SUPERIOR' )


Return oViewDef



//Inicia processo de gravacao da tabela ZZB a partir da tabela ZZL
User function SELPLT(cPedido,cCodMae,nSeq,nItem)

Local aArea  := GetArea()
Local cMarca := oMark:Mark()
Local aPlt   := {}
Local i

dbSelectArea('ZZL')
DbGoTop('ZZL')

	while !ZZL->(eof())
		if oMark:IsMark(cMarca)
//			Alert('Funcao Chamada '+cPedido)
			nPos := aScan(aPlt, {|x| x[1] == ZZL->ZZL_NPLT} )
			if nPos == 0
				aadd(aPlt, {ZZL->ZZL_NPLT})
			endif
		endif
		ZZL->(dbSkip())
	enddo

for i := 1 to len(aPlt)
	dbSelectArea('ZZL') 
	dbSelectArea('ZZA')
	dbSelectArea('ZZB') 
	ZZL->(DbSetOrder(1))
	ZZA->(DbSetOrder(1))
	ZZB->(DbOrderNickName("PD_COD_PLT"))
//	ZZB->(DbSetOrder(4))
	
//Se nao achar o pedido na tabela de cabecalho ele inclui
If !ZZA->(DbSeek(xFilial('ZZA')+Padr(cPedido,20)+Padr(cCodMae,15)+nSeq))
	
	RecLock('ZZA',.T.) //Inclui

	ZZA->ZZA_PEDIDO := cPedido
	ZZA->ZZA_ARTIGO := cCodMae
	ZZA->ZZA_SEQUEN := nSeq
	
Endif


	if ZZL->(dbSeek(xFilial('ZZL')+aPlt[i][1]))
		while !ZZL->(eof()).and.ZZL->ZZL_NPLT == aPlt[i][1]
//			Alert('Palete Marcado -> '+ZZL->ZZL_NPLT+ ' - '+ZZL->ZZL_ARTEXP+ ' QTDE -> '+cValToChar(ZZL->ZZL_SIDES))
			
			If ZZB->(DbSeek(xFilial('ZZL')+Padr(cPedido,20)+Padr(ZZL->ZZL_ARTEXP,15)+ZZL->ZZL_NPLT))
			                                               
//				Alert ('Achou -> Alterar!!!')
				RecLock('ZZB',.F.) //Altera
//				ZZB->ZZB_ITEM   := cValToChar(StrZero(nItem,3))
				ZZB->ZZB_PESOB  := ZZL->ZZL_PESOB  
				ZZB->ZZB_PESOL  := ZZL->ZZL_PESOL  
				ZZB->ZZB_HEIGHT := cValToChar(ZZL->ZZL_HEIGHT * 100) //Convertendo metro para centimetro
				ZZB->ZZB_WIDTH  := cValToChar(ZZL->ZZL_WIDTH  * 100) //Convertendo metro para centimetro
				ZZB->ZZB_LENGHT := cValToChar(ZZL->ZZL_LENGTH * 100) //Convertendo metro para centimetro
				ZZB->ZZB_SIDES  := cValToChar(ZZL->ZZL_SIDES)
				ZZB->ZZB_SQM1   := ZZL->ZZL_SQM1  
				ZZB->ZZB_LOTE   := ZZL->ZZL_LOTE  
				ZZB->ZZB_SQMTOT := ZZL->ZZL_SQMTOT
				MsUnLock("ZZB")
			Else
				RecLock('ZZB',.T.) //Inclui
//				Alert('Não Achou -> Incluir!!!')
				ZZB->ZZB_PEDIDO := cPedido
				ZZB->ZZB_ARTIGO := cCodMae 
				ZZB->ZZB_SEQUEN := nSeq
				ZZB->ZZB_ITEM   := cValToChar(StrZero(nItem,3))
				ZZB->ZZB_COD_I  := ZZL->ZZL_ARTEXP
				ZZB->ZZB_NRPCTE := ZZL->ZZL_NPLT
				ZZB->ZZB_PESOB  := ZZL->ZZL_PESOB  
				ZZB->ZZB_PESOL  := ZZL->ZZL_PESOL  
				ZZB->ZZB_HEIGHT := cValToChar(ZZL->ZZL_HEIGHT * 100) //Convertendo metro para centimetro
				ZZB->ZZB_WIDTH  := cValToChar(ZZL->ZZL_WIDTH  * 100) //Convertendo metro para centimetro
				ZZB->ZZB_LENGHT := cValToChar(ZZL->ZZL_LENGTH * 100) //Convertendo metro para centimetro
				ZZB->ZZB_SIDES  := cValToChar(ZZL->ZZL_SIDES)
				ZZB->ZZB_SQM1   := ZZL->ZZL_SQM1  
				ZZB->ZZB_LOTE   := ZZL->ZZL_LOTE  
				ZZB->ZZB_SQMTOT := ZZL->ZZL_SQMTOT
				MsUnLock("ZZB")
				
				nItem := nItem + 1
			Endif
			
			RecLock('ZZL',.F.)
			ZZL->ZZL_STATUS := "OK"
			MsUnLock("ZZL")
			
			ZZL->(dbSkip())
			
		enddo
	endif
next i 	

Msginfo('Registros gerados com sucesso!!!')
	
return

//Cadastra as perguntas
Static Function AjustaSx1(cPerg)
//--------------------------------
//Variaveis locais
Local aRegs := {}
Local i,j
//Inicio da funcao
dbSelectArea("SX1")
dbSetOrder(1)
//   1          2        3         4          5           6       7       8             9        10      11     12       13        14        15         16       17       18       19        20          21        22      23        24       25         26        27       28       29       30          31        32       33       34        35          36        37     38     39       40       41        42
//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_PYME/X1_GRPSXG/X1_HELP/X1_PICTURE
PutSx1(cPerg,"01","Periodo Inicial                  ?"," "," ","mv_ch1","D",8,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo inicial"},{"Informe o periodo inicial"},{"Informe o periodo inicial"})
PutSx1(cPerg,"02","Periodo Final                    ?"," "," ","mv_ch2","D",8,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo final"},{"Informe o periodo final"},{"Informe o periodo final"})

//Loop de armazenamento
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			endif
		Next
		MsUnlock()
	endif
Next
Return()