#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VSS_PROCOSºAutor  ³ Vinicius Schwartz  º Data ³  28/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Projeto Tela de Apont. Producaoo Costura                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso.      ³Rotina de apontamento de OP na Producao Costura.            º±±
±±º          ³Permite ao usuario selecionar uma OP ja aberta pelo numero  º±±
±±º          ³da mesma, informando a quantidade a ser apontada e o aponta-º±±
±±º          ³eh feito automaticamente.                                   º±±
±±º          ³Solicitacao Diego.                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                            

User Function VSS_PROCOS

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cGetOP     := Space(11)
Private cGetQtd    := 0
Private cSayCodU   := Space(15)
Private cSayCodU1  := RetCodUsr()
Private cSayData   := Space(6)
Private cSayData1  := dDatabase
Private cSayDsc    := Space(10)
Private cSayDsc2   := Space(50)
Private cSayGrp    := Space(5)
Private cSayGrp2   := Space(4)
Private cSayLin    := Space(15)
Private cSayLin2   := Space(10)
Private cSayNoU    := Space(15)
Private cSayNoU1   := cUsuario
Private cSayOP     := Space(6)
Private cSayProc   := Space(8)
Private cSayProCos := Space(15)
Private cSayProd   := Space(6)
Private cSayProd2  := Space(30)
Private cSayQtd    := Space(5)
Private cSayUM     := Space(2)
Private cSayUM1    := Space(2)


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlg1","oSayProc","oSayProCos","oSayData","oSayData1","oSayOP","oSayUM","oSayUM1","oSayGrp")
SetPrvt("oSayQtd","oSayLin","oSayLin2","oSayProd","oSayProd2","oSayDsc","oSayDsc2","oGetOP","oGetQtd")
SetPrvt("oBtn1","oBtn2","oPanel1","oSayCodU","oSayCodU1","oSayNoU","oSayNoU1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 116,577,583,1272,"Processo Produção Costura",,,.F.,,,,,,.T.,,,.T. )
oSayProc   := TSay():New( 004,020,{||"PROCESSO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,011)
oSayProCos := TSay():New( 004,100,{||"PRODUÇÃO COSTURA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,240,016)
oSayData   := TSay():New( 028,020,{||"DATA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,012)
oSayData1  := TSay():New( 028,056,{|u| If (PCount()>0, cSayData1:=u, cSayData1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,076,016)
oSayOP     := TSay():New( 028,168,{||"OP Nº"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,012)
oSayUM     := TSay():New( 088,020,{||"UM"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,012)
oSayUM1    := TSay():New( 088,044,{|u| If (PCount()>0, cSayUM1:=u, cSayUM1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,060,016)
oSayGrp    := TSay():New( 088,128,{||"GRUPO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,012)
oSayGrp2   := TSay():New( 088,178,{|u| If (PCount()>0, cSayGrp2:=u, cSayGrp2)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,064,016)
oSayQtd    := TSay():New( 112,020,{||"QTDE"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,012)
oSayLin    := TSay():New( 112,172,{||"LINHA PRODUÇÃO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,096,012)
oSayLin2   := TSay():New( 124,172,{|u| If (PCount()>0, cSayLin2:=u, cSayLin2)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,096,016)
oSayProd   := TSay():New( 052,020,{||"CODIGO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,012)
oSayProd2  := TSay():New( 064,020,{|u| If (PCount()>0, cSayProd2:=u, cSayProd2)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,072,012)
oSayDsc    := TSay():New( 052,100,{||"DESCRIÇÃO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,232,012)
oSayDsc2   := TSay():New( 064,100,{|u| If(PCount()>0,cSayDsc2:=u, cSayDsc2)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,228,022)
oGetOP     := TGet():New( 028,208,{|u| If(PCount()>0,cGetOP:=u,cGetOP)},oDlg1,112,014,'',{|| Vld_OP(cGetOP)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SC2","cGetOP",,)

oPanel1    := TPanel():New( 196,004,"",oDlg1,,.F.,.F.,,,332,016,.T.,.F. )

oSayCodU   := TSay():New( 004,012,{||"CÓDIGO USUÁRIO:"},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSayCodU1  := TSay():New( 004,064,{|u| If (PCount()>0, cSayCodU1:=u, cSayCodU1)},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSayNoU    := TSay():New( 004,120,{||"NOME USUÁRIO:"},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSayNoU1   := TSay():New( 004,172,{|u| If (PCount()>0, cSayNoU1:=u, cSayNoU1)},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,072,008)
oGetQtd    := TGet():New( 124,020,{|u| If(PCount()>0,cGetQtd:=u,cGetQtd)},oDlg1,096,014,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtd",,)

oBtn2      := TButton():New( 168,144,"CANCELAR",oDlg1,{|| oDlg1:End()},084,020,,oFont1,,.T.,,"",,,,.F. )


oBtn1      := TButton():New( 168,236,"CONFIRMAR",oDlg1,{|| Gera_Apont(cGetOP)},084,020,,oFont1,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return

//Valida OP quando digitada e preenche os demais campos correspondentes
Static Function Vld_OP(cOP)
DbSelectArea('SC2')
DbSetOrder(1)

If DbSeek (xFilial('SC2')+cOP)
	If SC2->C2_QUANT > SC2->C2_QUJE
		cSayProd2	:=SC2->C2_PRODUTO
		cGetQtd		:=SC2->C2_QUANT - SC2->C2_QUJE
		cSayLin2	:=SC2->C2_X_LINHA
		
		DbSelectArea ('SB1')
		DbSetOrder(1)
		DbSeek (xFilial('SB1') + cSayProd2)
		
		cSayDsc2	:=SB1->B1_DESC
		cSayUM1		:=SB1->B1_UM
		cSayGrp2	:=SB1->B1_GRUPO
	 	
	 	oSayProd2:Refresh()
		oSayDsc2:Refresh()
		oSayUM1:Refresh()
		oSayGrp2:Refresh()
		oGetQtd:Refresh()
		oSayLin2:Refresh() 
		
		oGetQtd:SetFocus()
	Else
		Alert ('OP Informada já foi totalmente apontada. Favor confirmar!')
		cGetOP:=Space(11)
		oGetOP:Refresh()
		oGetOP:SetFocus()
	EndIf
Else
	If cGetOP == Space(11)
		Return
	Else
		Alert ('OP informada não encontrada. Favor confirmar!')
		cGetOP:=Space(11)
		oGetOP:Refresh()
		oGetOP:SetFocus()
	Endif
EndIf

Return

//Gera o apontamento da OP
Static Function Gera_Apont(cOP)
DbSelectArea('SC2')
DbSetOrder(1)
DbSeek (xFilial('SC2')+cOP)

If cGetOP <> Space(11)

	If !MsgYesNo ("Certeza que deseja continuar?")
		oGetOP:SetFocus()
		return (.t.)                                                    
	EndIf
	
	If cGetQtd > (SC2->C2_QUANT - SC2->C2_QUJE)
		Alert ('A Quantidade informada não deve ser maior que :'+cValToChar(SC2->C2_QUANT - SC2->C2_QUJE))
		cGetQtd:=SC2->C2_QUANT - SC2->C2_QUJE
		oGetQtd:Refresh()
		oGetQtd:SetFocus()
		Return
	Else
		If cGetQtd == (SC2->C2_QUANT - SC2->C2_QUJE)
			ParTot:= 'T'
		Else
			ParTot:= 'P'
		Endif
		
		//Prepara para fazer o apontamento da OP		
	        aItens  := {}
				AAdd( aItens, {'D3_FILIAL'		,		 XFILIAL('SD3' ),nil 								})
				AAdd( aItens, {'D3_TM'			,		 '500' ,nil											})
				AAdd( aItens, {'D3_COD'			,		 SC2->C2_PRODUTO	,nil							})
				AAdd( aItens, {'D3_OP'			,		 SC2->(C2_NUM+C2_ITEM+C2_SEQUEN) ,nil         		})
				AAdd( aItens, {'D3_QUANT'		,	 	 cGetQtd ,nil				 					   	})
				AAdd( aItens, {'D3_LOCAL'		,		 SC2->C2_LOCAL	,nil								})
				AAdd( aItens, {'D3_DOC'			,		 'OP'+SC2->C2_NUM ,nil 								})
				AAdd( aItens, {'D3_EMISSAO'	    ,		 dDataBase ,nil										})
				AAdd( aItens, {'D3_CC'			,		 SC2->C2_CC ,nil									})
				AAdd( aItens, {'D3_CF'			,		 'PR0' ,nil											})
				AAdd( aItens, {'D3_PARCTOT'	    ,		 ParTot ,nil										})
				lMsErroAuto := .f.
				msExecAuto({|x,Y| Mata250(x,Y)},aItens,3)
	
				If lMsErroAuto
					MostraErro()
					VSS_ENVMAIL(cOP, SC2->C2_EMISSAO, cSayDsc2, SC2->C2_QUANT)
				else
					APMsgInfo(" OP Numero "+SC2->C2_NUM+" foi apontado com sucesso ")
				endif
	endif

Else
	Alert('Favor inserir um número de OP!')
	oGetOP:SetFocus()
endif

oDlg1:End()
U_VSS_PROCOS()
	
Return


//Funcao para envio de e-mail em caso de erro no apontamento
Static Function VSS_ENVMAIL(cOP, dData, cDescProd, nQtde)

     Local _cEmlFor := 'reginaldo.souza@midoriautoleather.com.br'
     Local oProcess 
     Local oHtml
     Local nCont := 0
//	 RpcSetEnv("01","04","","","","",{"SRA"})
//     Alert('Iniciando envido e e-mail...')
     SETMV("MV_WFMLBOX","WORKFLOW") 
     oProcess := TWFProcess():New( "000004", "Problema com apontamento de OP - Processo Costura" )
     oProcess:NewTask( "Problema com apontamento", "\WORKFLOW\HTM\ApontOP.HTM" )
     oHtml    := oProcess:oHTML
	 oHtml:ValByName("Data"			,dToc(dData))
	 oHtml:ValByName("numOP"   		,cOP)
	 
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	 aAdd( oHtml:ValByName( "it.desc" ), "HOUVE PROBLEMA NO APONTAMENTO DA ORDEM DE PRODUCAO "+Substr(cOP,1,6)+" PROCESSO COSTURA")
   	 aAdd( oHtml:ValByName( "it.desc" ), "PRODUTO: "+cDescProd )
   	 aAdd( oHtml:ValByName( "it.desc" ), "QUANTIDADE: "+cValToChar(nqtde) )
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	 aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
	 aAdd( oHtml:ValByName( "it.desc" ), "USUARIO QUE FEZ A INCLUSAO: "+substr(cUsuario,1,35))
   	 aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	 
   	    	                                 
oProcess:cSubject := "Problema com apontamento de OP - Processo Costura - OP NUMERO: " + cOP



	oProcess:cTo      := _cEmlFor     


oProcess:Start()                    
	       //WFSendMail()
	       //WFSendMail()	       
oProcess:Finish()
//Alert('Email enviado com sucesso...')
Return