#INCLUDE "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  UCadQuim     º Autor ³ Antonio º Data ³  19/06/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Tela para cadastramento de quimicos º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function UCadQuim()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZO"

dbSelectArea("SZO")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Pallets de Quimicos",cVldExc,cVldAlt/*"U_UGRVCB0()"*/,,,{|| U_UGRVCB0()} )  //,,,,,,,,.T.)


Return


                                                              
User Function UGRVCB0()

	Local aParam    := {}
	Local cLocApt   := '11'
    Local lRet      :=.T.
	LOCAL a_ParamBox := {}  
	LOCAL aRet      := {}  
	LOCAL cTitulo   := 'Informe o Armazém'  
	Local cMA_EXCCQM := SuperGetMV('MA_EXCCQM',.F.,'066641','066642')    //EXCEÇÃO DE PRODUTOS QUE SÃO QUIMICOS, MAS DE OUTRO GRUPO DIFERENTE DE 12/14

	If MsgYesNo('Emitir etiqueta de Pallet (PNP1) - Quimicos (S/N)?' )

		aAdd(a_ParamBox,{2,"Qual Armazém?    ",1,{" ","11","12","9A"},50,"",.F.})
		If ParamBox(a_ParamBox, cTitulo, @aRet)
			cLocApt := MV_PAR01
		EndIf	

	    SB1->( dbSetOrder(1) )
	    SB1->( dbSeek( xFilial("SB1") + M->ZO_PRODUTO ) )

		IF (AllTrim(SB1->B1_GRUPO) $ '12-14') .OR. AllTrim(SB1->B1_COD) $ cMA_EXCCQM //QUIMICOS       //produtos quimicos
	
		 	aParam    := {}                  
			nQtOpEtiq := 1                      
			AAdd( aParam, M->ZO_QTDEM2     ) // quantidade da etiqueta                                              1
			AAdd( aParam, nil              ) // Codigo do separador                                                 2
			AAdd( aParam, nil              ) // Código da etiqueta, no caso de uma reimpressão                      3
			AAdd( aParam, nQtOpEtiq        ) // Quantidade de etiquetas                                             4
			AAdd( aParam, M->ZO_NFORI      ) // nota de entrada                                                     5
			AAdd( aParam, M->ZO_SERIE      ) // Serie da nota de entrada                                            6
			AAdd( aParam, M->ZO_CODFOR     ) // Codigo do fornecedor da nota de entrada                             7
			AAdd( aParam, M->ZO_LJFOR      ) // Loja do fornecedor da nota de entrada                               8
			AAdd( aParam, cLocApt          ) // Armazem                                                             9
			AAdd( aParam, nil              ) // Numero da OP                                                       10
			AAdd( aParam, nil              ) // Numero sequencial da etiqueta quando for reimpressao               11
	//		AAdd( aParam, If(SB1->B1_RASTRO=="L", SZO->ZO_NUMLOTE, nil ) )   //lote                                  12
			AAdd( aParam, M->ZO_NUMLOTE    ) //lote                                                                12
			AAdd( aParam, nil              ) // Sublote                                                            13
	//		AAdd( aParam, If(SB1->B1_RASTRO=="L", SZO->ZO_DTVALID     , nil ) )   // Data de Validade                14

			AAdd( aParam, M->ZO_DTVALID    ) // Data de Validade                                                   14

			AAdd( aParam, nil              ) // Centro de Custos                                                   15
			AAdd( aParam, cLocApt          ) // Local de Origem                                                    16
			AAdd( aParam, nil              ) // Local cOPREQ    := If(len(paramixb) >=17,paramixb[17],NIL)         17
			AAdd( aParam, nil              ) // Local cNumSerie := If(len(paramixb) >=18,paramixb[18],NIL)         18
			AAdd( aParam, nil              ) // Local cOrigem   := If(len(paramixb) >=19,paramixb[19],NIL)         19
			AAdd( aParam, nil              ) // Local cEndereco := If(len(paramixb) >=20,paramixb[20],NIL)         20
			AAdd( aParam, nil              ) // Local cPedido   := If(len(paramixb) >=21,paramixb[21],NIL)         21
			AAdd( aParam, 0                ) // Local nResto    := If(len(paramixb) >=22,paramixb[22],0)           22
			AAdd( aParam, nil              ) // Local cItNFE    := If(len(paramixb) >=23,paramixb[23],NIL)         23   
			AAdd( aParam, M->ZO_NUMPLT     ) // Local cPallet   := If(len(paramixb) >=24,paramixb[24],"")          24       
			AAdd( aParam, M->ZO_PRODUTO    ) // Local           := If(len(paramixb) >=24,paramixb[24],"")          25       
	
			AAdd( aParam, M->ZO_NUMLOTE   )  //LOTE DO FORNECEDOR                                         26
			AAdd( aParam, M->ZO_RVALID  )           // Data de Revalidade do lote               //27

			ExecBlock("IMG12",,,aParam )               	
	        lRet:=.T.
	
	    	If INCLUI
				dbSelectArea("SX6")
				dbSetOrder(1)
				If SX6->(dbSeek(xFilial("SZO") + "MV_SPALQUI") )
					//Faz a gravacao dos dados na tabela Sx6
					//cGetPlt:=SX6->X6_CONTEUD
					RecLock("SX6",.F.)
					SX6->X6_CONTEUD := M->ZO_NUMPLT
					SX6->X6_CONTSPA := M->ZO_NUMPLT
					SX6->X6_CONTENG := M->ZO_NUMPLT
					SX6->(MsUnLock("SX6"))
				EndIf
			EndIf
		
		EndIf

	EndIf

Return(lRet)




User Function UVLDPAL()

    Local CNUMPLT:=" "
    
	If ProcName(13) == "U_UCADQUIM"

		dbSelectArea("SX6")
		dbSetOrder(1)
		If SX6->(dbSeek(xFilial("SZO") + "MV_SPALQUI") )
			CNUMPLT := Soma1(AllTrim(SX6->X6_CONTEUD))
		EndIf
	EndIf	

Return(CNUMPLT)
