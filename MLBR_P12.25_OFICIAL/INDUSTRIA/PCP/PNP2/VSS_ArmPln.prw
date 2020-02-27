#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VSS_ArmPln ºAutor  ³ Vinicius Schwartz  º Data ³  28/06/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela para transferencia de armazem do plano				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso.      ³Rotina para transferir de armazem um Plano específico.	  º±±
±±º          ³Desde modo cada linha de produção terá um armazem especificoº±±
±±º          ³para que seja transferidos os materiais a serem consumidos  º±±
±±º          ³Solicitação de Marcos/Newton - PNP2.						  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

User Function VSS_ArmPln()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cArmaz     := Space(2)
Private cGrupo     := Space(4)
Private cPlano     := Space(20)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oSay1","oSay2","oSay3","oPlano","oArmaz","oGrupo","oBtn1","oBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 275,370,403,893,"Transferência Armazem do Plano",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 008,016,{||"PLANO:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 008,132,{||"ARMAZÉM DE DESTINO:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
oSay3      := TSay():New( 028,016,{||"PRODUTOS DO GRUPO:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
oPlano     := TGet():New( 008,040,{|u| If(PCount()>0,cPlano:=u,cPlano)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZP","cPlano",,)
oArmaz     := TGet():New( 008,200,{|u| If(PCount()>0,cArmaz:=u,cArmaz)},oDlg1,032,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cArmaz",,)
oGrupo     := TGet():New( 028,084,{|u| If(PCount()>0,cGrupo:=u,cGrupo)},oDlg1,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SBM","cGrupo",,)
oBtn1      := TButton():New( 040,160,"Ok",oDlg1,{|| Vld_Tudo()},037,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 040,204,"Cancelar",oDlg1,{|| oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return

//Validando as informações e transferindo o Plano de armazem
Static Function Vld_Tudo()

//Validando Plano informado
DbSelectArea('SZP')
DbSetOrder(2)

If !DbSeek(xFilial('SZP') + cPlano)
	Alert('Plano informado não é valido. Favor confirmar!')
    Return
Endif

//Validando Grupo informado
DbSelectArea('SBM')
DbSetOrder(1)

If !DbSeek(xFilial('SBM') + cGrupo)
	Alert('Grupo informado não é valido. Favor confirmar!')
    Return
Endif

//Verifica se algum campo está sem preenchimento
If cArmaz == Space(2) .Or. cGrupo == Space(4) .Or. cPlano == Space(20)
	Alert('Faltou preencher algum dos campos. Favor confirmar!')
	Return
Endif


//Verifica se tabelas temporias existem e encerra as mesmas antes de executar as novas
if Select("TMPSD4") > 0 
	dbSelectArea("TMPSD4")
	TMPSD4->(dbCloseArea())
endif

//Monta a query
cQry := " SELECT D4_COD, B1_GRUPO, D4_LOCAL, D4_OP, D4_QTDEORI, D4_QUANT FROM SD4010 "
cQry += " JOIN SB1010 ON SB1010.D_E_L_E_T_ <> '*' "
cQry += " 	AND B1_COD = D4_COD "
cQry += " 	AND B1_GRUPO = '"+cGrupo+"' "
cQry += " WHERE D4_FILIAL = '"+xFilial("SD4")+"' "
cQry += " 	AND D4_OP IN (SELECT C2_NUM+C2_ITEM+C2_SEQUEN AS OPCOMPL FROM SC2010 "
cQry += " 					WHERE C2_FILIAL = '"+xFilial("SD4")+"' AND C2_OPMIDO = '"+cPlano+"' AND D_E_L_E_T_ <> '*') "
cQry += " 	AND SD4010.D_E_L_E_T_ <> '*' "
cQry += " 	AND SUBSTRING(D4_COD,1,3) <> 'MOD' "

cQry:= ChangeQuery(cQry)
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry),"TMPSD4",.T.,.T.) 

//Posicionando no primeiro registro da tabela selecionada
TMPSD4->(dbGoTop())

dbSelectArea('SB2')
SB2->(dbSetOrder(1))

dbSelectArea('SD4')
SD4->(dbSetOrder(1))

//Entrando no loop da atualização
While !TMPSD4->(Eof())

	//Atualização da tabela SB2
	//Coloca empenho no armazem destino
	If SB2->(dbSeek(xFilial("SB2")+TMPSD4->D4_COD+cArmaz))
		RecLock("SB2",.F.)
			SB2->B2_QEMP := SB2->B2_QEMP + TMPSD4->D4_QUANT
		SB2->(MsUnlock())
	EndIf

	//Retira empenho do armazem atual
	If SB2->(dbSeek(xFilial("SB2")+TMPSD4->D4_COD+TMPSD4->D4_LOCAL))
		RecLock("SB2",.F.)
			SB2->B2_QEMP := SB2->B2_QEMP - TMPSD4->D4_QUANT
		SB2->(MsUnlock())		                                                
	EndIf

	//Atualização da tabela SD4	
	//Atualiza o empenho da  tabela SD4 para o novo armazem
	If SD4->(dbSeek(xFilial("SD4")+TMPSD4->D4_COD+TMPSD4->D4_OP))
		RecLock("SD4",.F.)
			SD4->D4_LOCAL := cArmaz
		SD4->(MsUnlock())
	Endif
	
	TMPSD4->(DbSkip())

EndDo

Msginfo('Transferência concluída com sucesso!')

oDlg1:End()
U_VSS_ARMPLN()        

Return