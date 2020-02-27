#include "totvs.ch"
//===============================================================
// MDRACD01 - Alessandro Freire - Novembro / 2015
//---------------------------------------------------------------
// Descrição
// Imprime as etiquetas dos produtos em estoque
//===============================================================
User Function MDRACD01()
                
Local cPerg  := "MDRACD01"
Local oPerg  := AdvPlPerg():New(cPerg)       
Local aParam := {}

oPerg:AddPerg( "Produto"   , "C", 15, 0, nil, "SB1" )
oPerg:AddPerg( "Armazem"   , "C", 02, 0, nil, nil )
oPerg:AddPerg( "Quantidade", "N", 15, 4  )      
oPerg:AddPerg( "Lote"      , "C", TamSx3("B8_LOTECTL")[1], 0 , , "SB8MFJ")
oPerg:SetPerg()
     
While .t.
	If ! Pergunte( cPerg )
		MsgInfo("Cancelado pelo usuário")
		Exit
	EndIf
	
	If ! MsgYesNo( "Deseja imprimir as etiquetas ?" )
		MsgInfo("Cancelado pelo usuário")
		Loop
	EndIf
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	If ! dbSeek( xFilial("SB1") + mv_par01 )
		MsgInfo( "Produto não encontrado" )
		Loop
	EndIf
	              
	aParam := {}
	AAdd( aParam, mv_par03      ) // quantidade da etiqueta
	AAdd( aParam, nil           ) // Codigo do separador
	AAdd( aParam, nil           ) // Código da etiqueta, no caso de uma reimpressão
	AAdd( aParam, 1             ) // Quantidade de etiquetas ( cópias )
	AAdd( aParam, nil           ) // nota de entrada
	AAdd( aParam, nil           ) // Serie da nota de entrada
	AAdd( aParam, nil           ) // Codigo do fornecedor da nota de entrada
	AAdd( aParam, nil           ) // Loja do fornecedor da nota de entrada
	AAdd( aParam, mv_par02      ) // Armazem
	AAdd( aParam, nil           ) // Numero da OP
	AAdd( aParam, nil           ) // Numero sequencial da etiqueta quando for reimpressao
	
	AAdd( aParam, If(SB1->B1_RASTRO=="L", MV_PAR04, nil ) ) // Numero do Lote. Neste caso deve ser o mesmo numero da OP
	
	AAdd( aParam, nil           ) // Sublote
	AAdd( aParam, nil           ) // Data de Validade
	AAdd( aParam, nil           ) // Centro de Custos
	AAdd( aParam, MV_PAR02      ) // Local de Origem
	
	AAdd( aParam, nil           ) // Local cOPREQ    := If(len(paramixb) >=17,paramixb[17],NIL)
	AAdd( aParam, nil           ) // Local cNumSerie := If(len(paramixb) >=18,paramixb[18],NIL)
	AAdd( aParam, nil           ) // Local cOrigem   := If(len(paramixb) >=19,paramixb[19],NIL)
	AAdd( aParam, nil           ) // Local cEndereco := If(len(paramixb) >=20,paramixb[20],NIL)
	AAdd( aParam, nil           ) // Local cPedido   := If(len(paramixb) >=21,paramixb[21],NIL)
	AAdd( aParam, 0             ) // Local nResto    := If(len(paramixb) >=22,paramixb[22],0)
	AAdd( aParam, nil           ) // Local cItNFE    := If(len(paramixb) >=23,paramixb[23],NIL)
	
	ExecBlock("IMG01",,,aParam )    
	
	MsgInfo("Etiquetas enviadas para o Spool.")  
	
Enddo
