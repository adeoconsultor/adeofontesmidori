#Include "rwmake.ch"
#Include "TopConn.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CFATA001 ³ Autor ³ Paulo R. Trivellato   ³ Data ³ 29/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina de manutenção do Cabeçalho de Pedido de Venda (SC5) ³±±
±±³          ³ Permite alterar dados sem afetar liberação de itens.       ³±±
±±³          ³ Dados a alterar: Transportadora, Mensagem da Nota e Peso   ³±±
±±³          ³                  Bruto                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Chamado via menu do faturamento. (Incluido no aRotina do   ³±±
±±³          ³ MatA410 pelo PE MT410BRW.                                  ³±±
±±³          ³ Especifico: Cotrijuc                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³UpDate    ³                                                            ³±±
±±³29/04/09  ³TI0470-Paulo = Inclusao do elemento "NOUSER" no array para  ³±±
±±³          ³nao trazer os campos de usuario(X3_PROPRI=U);acerto de cam- ³±±
±±³          ³pos visualizaveis e alteraveis;                             ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
User Function CFATA001(cAlias,nReg,nOpc)

Local lNaoFatur := .F.
Local aArea := GetArea()
Local aCpoVis := {"C5_NUM","C5_TRANSP","C5_PESOL","C5_PBRUTO","C5_VOLUME1","C5_ESPECI1","C5_MENNOTA","NOUSER"}
Local aCpoAlt := {"C5_TRANSP","C5_PESOL","C5_PBRUTO","C5_VOLUME1","C5_ESPECI1","C5_MENNOTA"}
Local nCntFor

If SC5->C5_TIPO <> "N" .Or. !Empty( SC5->C5_NOTA)
	Help(" ",1,"A410PEDFAT")
	Return
EndIf

cArqQry := "SC6"
aStruSC6:= SC6->(dbStruct())
lQuery  := .T.
cQuery := "SELECT SC6.*,SC6.R_E_C_N_O_ SC6RECNO "
cQuery += "FROM "+RetSqlName("SC6")+" SC6 "
cQuery += "WHERE SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
cQuery += "SC6.C6_NUM='"+SC5->C5_NUM+"' AND "
cQuery += "SC6.D_E_L_E_T_<>'*' "
cQuery += "ORDER BY "+SqlOrder(SC6->(IndexKey()))

cQuery := ChangeQuery(cQuery)

dbSelectArea("SC6")
dbCloseArea()
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
For nCntFor := 1 To Len(aStruSC6)
	If ( aStruSC6[nCntFor,2]<>"C" )
		TcSetField(cArqQry,aStruSC6[nCntFor,1],aStruSC6[nCntFor,2],aStruSC6[nCntFor,3],aStruSC6[nCntFor,4])
	EndIf
Next nCntFor

While !Eof()
	
	If !"R" $ Alltrim((cArqQry)->C6_BLQ)
		If ( (cArqQry)->C6_QTDENT < (cArqQry)->C6_QTDVEN )
			lNaoFatur := .T.
		EndIf
	EndIf
	
	dbSelectArea(cArqQry)
	dbSkip()
	
EndDo

dbCloseArea()
ChkFile("SC6",.F.)

RestArea( aArea )

If (!(SuperGetMv("MV_ALTPED")=="S") .And. !lNaoFatur)
	Help(" ",1,"A410PEDFAT")
	Return
EndIf

AxAltera( "SC5" , SC5->( Recno() ) , 4 , aCpoVis , aCpoAlt)
//AxAltera(cAlias,Registro,Opcao,Campos Visiveis,Campos Alteraveis)

Return()