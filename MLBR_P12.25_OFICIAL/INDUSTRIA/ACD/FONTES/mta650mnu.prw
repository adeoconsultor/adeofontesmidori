#include "totvs.ch"  	
//=======================================================================================
// MTA650MNU - Alessandro Freire - Setembro / 2015
//---------------------------------------------------------------------------------------
// Descricao
// Adiciona a impressão das etiquetas no menu na tela de cadastro das OPs
//---------------------------------------------------------------------------------------
// Retorno
// aRotina
//=======================================================================================
user Function MTA650MNU()

AAdd( aRotina, {"Etiquetas ACD-TNT","u_MDRETOP"  , 0 , 3, 0 , nil} )

Return( nil )

//=======================================================================================
// MdrEtOp - Alessandro Freire - Setembro / 2015
//---------------------------------------------------------------------------------------
// Descricao
// Imprime as etiquetas da OP
//---------------------------------------------------------------------------------------
// Retorno
// NIL
//=======================================================================================
User Function MdrEtOp()
              
Local cMsg   := ""                                     
//Local nQtde  := ( SC2->C2_QUANT - SC2->C2_QUJE ) // Linha alterada para permitir reimprimir etiquetas de OP encerradas.
Local nQtde  := SC2->C2_QUANT
Local aParam := {}  
Local cPerg  := "MDRETOP"           
Local oPerg  := AdvPlPerg():New(cPerg)                            
Local lImpressas := .f.

Private cMdrEtOp := SC2->C2_NUM     

//-------------------------------------------
// Ajusta os parâmetros
//-------------------------------------------
oPerg:AddPerg( "OP Inicial"     , "C", 6   )
oPerg:AddPerg( "OP Final"       , "C", 6   ) 
oPerg:AddPerg( "Emissao Inicial", "D"    ) 
oPerg:AddPerg( "Emissao Final"  , "D"    ) 
oPerg:AddPerg( "Produto Inicial", "C", TamSx3("B1_COD")[1],,, "SB1"  ) 
oPerg:AddPerg( "Produto Final"  , "C", TamSx3("B1_COD")[1],,, "SB1"  ) 
oPerg:AddPerg( "Plano        "  , "C", 18 ) 
                                                            
//AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
oPerg:SetPerg()  

If ! Pergunte( cPerg, .t. )
	MsgInfo("Rotina cancelada pelo usuário") 
	Return( nil )	
EndIf

If ! MsgYesNo( "Confirma a impressão das etiquetas ?" )
	MsgInfo("Rotina cancelada pelo usuário") 
	Return( nil )
EndIf

dbSelectArea("SC2")
dbSetOrder(1)
dbSeek( xFilial("SC2") + mv_par01, .t. )

While ! Eof() .and. xFilial("SC2") == SC2->C2_FILIAL .and. SC2->C2_NUM <= mv_par02
                 
    lImpressas := .t.          
    
    cMdrEtOp   := SC2->C2_NUM
    cMdrEtPlan := mv_par07 
                                   
	SB1->( dbSetOrder(1) )
	SB1->( dbSeek(xFilial("SB1")+SC2->C2_PRODUTO) )
	
	SBZ->( dbSetOrder(1) )
	IF ! SBZ->( dbSeek(xFilial("SBZ")+SC2->C2_PRODUTO) )
		dbSelectArea("SC2")
		dbSkip()
		Loop
		//Return(nil)
	EndIf
	
	//--------------------------------------
	// Nao é PARA IMPRIMIR A ETIQUETA
	//--------------------------------------
	//If SB1->B1_ZZIMPET <> "S"
	If SBZ->BZ_ZZIMPET <> "S"
		dbSelectArea("SC2")
		dbSkip()
		Loop
	EndIf   
	     
	//--------------------------------------
	// Nao é TNT
	//--------------------------------------
	//If SB1->B1_ZZETIQ <> "2" 
	If SBZ->BZ_ZZETIQ <> "2" 
		dbSelectArea("SC2")
		dbSkip()
		Loop
	EndIf                                                          
	
	IF SC2->C2_EMISSAO < mv_par03 .or. SC2->C2_EMISSAO > mv_par04
		dbSelectArea("SC2")
		dbSkip()
		Loop
	EndIf   
	
	
	IF SC2->C2_PRODUTO < mv_par05 .or. SC2->C2_PRODUTO > mv_par06
		dbSelectArea("SC2")
		dbSkip()
		Loop
	EndIf   
	
	If !empty(mv_par08)
		If SC2->C2_OPMIDO <> Alltrim(mv_par08)
	   		dbSelectArea("SC2")
			dbSkip()
			Loop		
		Endif
	Endif

	nQtde      := ( SC2->C2_QUANT - SC2->C2_QUJE )
	cMdrEtOp   := SC2->C2_NUM
	cMdrEtPlan := mv_par07 
	aParam     := {}
	
	AAdd( aParam, 1             ) // quantidade da etiqueta
	AAdd( aParam, nil           ) // Codigo do separador
	AAdd( aParam, nil           ) // Código da etiqueta, no caso de uma reimpressão
	AAdd( aParam, nQtde         ) // Quantidade de etiquetas ( cópias )
	AAdd( aParam, nil           ) // nota de entrada
	AAdd( aParam, nil           ) // Serie da nota de entrada
	AAdd( aParam, nil           ) // Codigo do fornecedor da nota de entrada
	AAdd( aParam, nil           ) // Loja do fornecedor da nota de entrada
	AAdd( aParam, SC2->C2_LOCAL ) // Armazem
	AAdd( aParam, SC2->C2_NUM   ) // Numero da OP
	AAdd( aParam, nil           ) // Numero sequencial da etiqueta quando for reimpressao

	AAdd( aParam, If(SB1->B1_RASTRO=="L", SC2->C2_NUM, nil ) ) // Numero do Lote. Neste caso deve ser o mesmo numero da OP

	AAdd( aParam, nil           ) // Sublote
	AAdd( aParam, nil           ) // Data de Validade
	AAdd( aParam, nil           ) // Centro de Custos
	AAdd( aParam, SC2->C2_LOCAL ) // Local de Origem

	AAdd( aParam, nil           ) // Local cOPREQ    := If(len(paramixb) >=17,paramixb[17],NIL)
	AAdd( aParam, nil           ) // Local cNumSerie := If(len(paramixb) >=18,paramixb[18],NIL)
	AAdd( aParam, nil           ) // Local cOrigem   := If(len(paramixb) >=19,paramixb[19],NIL)
	AAdd( aParam, nil           ) // Local cEndereco := If(len(paramixb) >=20,paramixb[20],NIL)
	AAdd( aParam, nil           ) // Local cPedido   := If(len(paramixb) >=21,paramixb[21],NIL)
	AAdd( aParam, 0             ) // Local nResto    := If(len(paramixb) >=22,paramixb[22],0)
	AAdd( aParam, nil           ) // Local cItNFE    := If(len(paramixb) >=23,paramixb[23],NIL)            
                                 
	ExecBlock("IMG01",,,aParam )

	dbSelectArea("SC2")
	dbSkip()
	
Enddo
             
If lImpressas
	MsgInfo("Etiquetas impressas.")
Else
	MsgInfo("Não há etiquetas a imprimir")
EndIf
Return( nil )