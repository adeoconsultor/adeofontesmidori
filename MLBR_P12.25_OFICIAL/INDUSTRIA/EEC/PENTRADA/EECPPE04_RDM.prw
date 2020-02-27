#INCLUDE "EEC.CH"
#INCLUDE "TOPCONN.CH"

#define STR0001  "Pesquisar"
#define STR0002  "Visualizar"
#define STR0003  "Incluir"
#define STR0004  "Alterar"
#define STR0005  "Cancelar"
#define STR0006  "Apr.Credito"
#define STR0007  "Copiar Processo"
#define STR0008  "Volumes"
#define STR0009  "Documentos/Cartas"
#define STR0010  "Empresas"
#define STR0011  "Instituições Bancárias"
#define STR0012  "Despesas"
#define STR0013  "Notify's"
#define STR0014  "Excluir"
#define STR0015  "Preparando Dados do Processo ..."
#define STR0016  "Processo de Exportação"
#define STR0017  "Definição de Produtos para o Pedido "
#define STR0018  "&Cancelar"
#define STR0019  "&Eliminar"
#define STR0020  "&Retornar"
#define STR0021  "Cancelar ou Eliminar Registro do Processo : "
#define STR0022  " ?"
#define STR0023  "Processo já Cancelado em "
#define STR0024  "Atenção"
#define STR0025  "Processando Estorno..."
#define STR0026  "Excluindo Itens, Agentes, Bancos, Despesas..."
#define STR0027  "Gravando dados do Processo: "
#define STR0028  "Total Itens"
#define STR0029  "Peso Liquido "
#define STR0030  "Total Pedido "
#define STR0031  "Peso Bruto "
#define STR0032  "Total FOB "
#define STR0033  "Total Incoterm "
#define STR0034  "Volume "
#define STR0035  " não foi encotrado no Cadastro de Embalagens !"
#define STR0036  "Aviso"
#define STR0037  "Erro de integridade, embalagem "
#define STR0038  " não encontrada no cadastro de embalagens !"
#define STR0039  "Cubagem da Embalagem "
#define STR0040  " não foi preenchida !"
#define STR0041  "Embalagem Final do Item "
#define STR0042  " - Sequência "
#define STR0043  "Sequência"
#define STR0044  "Embalagem"
#define STR0045  "Quantidade"
#define STR0046  "Volume: "
#define STR0047  " COM "
#define STR0048  "º"
#define STR0049  "Copiando informações do processo: "
#define STR0050  "Seleção de Processos"
#define STR0051  "&Pesquisa"
#define STR0052  "Copiar:"
#define STR0053  "&Capa"
#define STR0054  "&Itens"
#define STR0055  "Conferência de Pesos"
#define STR0056  "Peso Liquido"
#define STR0057  "Peso Bruto"
#define STR0058  "Confirma Exclusão? "
#define STR0059  "Atenção"
#define STR0060  "Os itens já lançados serão apagados. Confirma a cópia dos dados?"
#define STR0061  "Confirma cancelar entrada de dados ?"
#define STR0062  "Erro de Integridade"
#define STR0063  "Falha de integridade com o módulo de faturamento."
#define STR0064  "Informações"
#define STR0065  "Ped. Exportação"
#define STR0066  "Ped. Venda"
#define STR0067  "Nro. de Itens:"
#define STR0068  "Valor Total:"
#define STR0069  "Favor entrar em contato com o suporte da Average Tecnologia."
#define STR0070  "Recriar o pedido na filial do exterior ?"
#define STR0071  "Apagando pedido na filial do exterior..."
#define STR0072  "Deseja cancelar o pedido na filial do exterior ?"
#define STR0073  "Deseja eliminar o pedido na filial do exterior ?"
#define STR0074  " renomeado com sucesso."
#define STR0075  "Renomear "
#define STR0076  "Nro. Antigo"
#define STR0077  "Nro. Novo"
#define STR0078  "Este processo possue item(ns) fixado(s). Deseja continuar o processo de cancelamento?"
#define STR0088  "Renomear"
#define STR0089  "Fixar Preço"
#define STR0101  "Histórico de Impressões"
#define STR0102  "Agenda de Atividades/Documentos"
#define STR0103  "Inclusão de Tarefa"
#define STR0104  "Só é permitida a alteração de tarefas específicas."
#define STR0105  "Alteração de Tarefa"
#define STR0106  "Só é permitida a exclusão de tarefas específicas."
#define STR0107  "Exclusão de Tarefa"
#define STR0108  "Ativo"
#define STR0109  "Histórico"
#define STR0110  "Específica"
#define STR0111  "Padrão(Cliente/País)"
#define STR0112  "Tipo de Tarefa"
#define STR0113  "Adiantamentos"
#define STR0114  "Este processo não pode ser cancelado ou excluído."
#define STR0115  "Detalhes:"
#define STR0116  "O processo selecionado possui adiantamento(s) lançado(s)."
#define STR0117  "Para cancelar ou excluir, primeiro estorne o(s) adiantameto(s)."
#define STR0118  "O percentual de comissão deve ser informado!"
#define STR0119  "Vinc/Estorno R.V."
#define STR0120  "Vincular R.V."
#define STR0121  "Para processos com tratamentos de off-shore o preco negociado e obrigatorio para todos os produtos."
#define STR0122  "Näo e permitida a alteracäo de item com preco fixado."
#define STR0123  "Näo e permitida a alteracäo de item com RV."
#define STR0124  "Item com preco fixado. Deseja continuar o processo de exclusäo?"
#define STR0125  "Calculado"
#define STR0126  "Digitado"
#define STR0127  "Informe o codigo do importador."
#define STR0128  "Agentes de Comissäo"
#define STR0129  "Despesas Nacionais"
#define STR0130  "Qtde informada invalida, pois o saldo alocado em embarque e maior."
#define STR0131  "Verifique o campo "
#define STR0132  " na pasta "
#define STR0133  "Preencha o campo "
#define STR0134  "Não é permitida a inclusão ou exclusão de itens para este processo devida-a sua geração através da integração."
#define STR0135  "Pedido de Consignação - Remessa"
#define STR0136  "Pedido de Consignação - Venda"
#define STR0137  "Pedido de Back To Back"
#define STR0138  "Pedido de Back To Back com Consignação"
#define STR0139  "Não será possível continuar porque não foi informada nenhuma invoice a pagar para o processo de Back to Back."
#define STR0140  "Compra FOB"
#define STR0141  "Ctr.Export."
#define STR0142  "O total das comissões deve ser inferior ao valor FOB do processo. Favor revisar as comissões antes de prosseguir."
#define STR0143  "Compra FOB"
#define STR0144  "Para a compra FOB, todos os itens devem ter a un. de medida do preço de compra preenchida. Itens inconsistentes: "
#define STR0145  "Editar Preços de Compra"
#define STR0146  "Este processo não poderá ser cancelado, pois o mesmo possui iten(s) vinculado(s) a R.V.. Faça o estorno da vinculação de R.V.."
#define STR0147  "O ### não pode começar com '*', pois este prefixo é utilizado em controles internos do sistema."
#define STR0148  "Este é um pedido especial para vinculação de RV. Para cancelá-lo, vá em Atualizações -> Siscomex -> Geração de RV."
#define STR0149  "Processo da Filial"
#define STR0150  "Brasil"
#define STR0151  "Off-Shore"
#define STR0152  "Ag.At/Do"
#define STR0153  "Cop.Proc"
#define STR0154  "Docto/Carta"
#define STR0155  "Ag.Comis"
#define STR0156  "Desp.Nac"
#define STR0157  "Inst.Ban"
#define STR0158  "Vinc.R.V"
#define STR0159  "Ed.Pr.Com"
#define STR0160  "Gravação do pedido número: 'XXX' na filial: 'YYY'"
#define STR0161  "Sim"
#define STR0162  "Não"
#define STR0163  "Possui R.V.?"
#define STR0164  "Historico de Saldo"
#define STR0165  "Hist. Saldo"

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: U_EECPPE04()
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Data......: 11 de Janeiro de 2010, 08:00
//|Uso.......: SIGAEEC
//|Versao....: Protheus - 10
//|Descricao.: PE inclusão de botão no Pedido de Exportação
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function EECPPE04()
*-----------------------------------------*
Public axRoma   := {}
Public axItRoma := {}
Public nxCouRom := 0
Public axDadRom := {}

If ALTERA
	aAdd(aButtons,{"PENDENTE",{|| U_VincRoma(M->EE7_PEDIDO) },"Vinculação de Romaneio"})
EndIf

aAdd(aButtons,{"S4WB007N",{|| U_DesVincR(M->EE7_PEDIDO) },"Desvinculação de Romaneio"})

Return .T.

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: U_VincRoma
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Data......: 11 de Janeiro de 2010, 08:00
//|Uso.......: SIGAEEC
//|Versao....: Protheus - 10
//|Descricao.: Vinculação do Romaneio de Couro
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function VincRoma(xPed)
*-----------------------------------------*

Local cSql := ""
Local lRet := .F.

Private axItRoma := {}
Private aDesc := {}
Private oLbx1 := Nil
Private bLine := Nil
Private oOk   := LoadBitmap( GetResources(), "LBOK" )
Private oNo   := LoadBitmap( GetResources(), "LBNO" )


cSql := "SELECT ZZB_ARTIGO,ZZB_COD_I,SUM(ZZB_PESOB) AS ZZB_PESOB,SUM(ZZB_PESOL) AS ZZB_PESOL, "
cSql += "SUM(ZZB_SQMTOT) AS ZZB_SQMTOT,ZZB_SEQUEN, COUNT(*) AS ZZB_ITEM "
cSql += "FROM "+RetSqlName("ZZB")+" WHERE D_E_L_E_T_ <> '*' AND ZZB_FILIAL = '"+xFilial("ZZB")+"' AND "
cSql += "ZZB_PEDIDO = '"+Alltrim(xPed)+"' AND ZZB_USADO = '' "
cSql += "GROUP BY ZZB_ARTIGO,ZZB_COD_I,ZZB_SEQUEN "
cSql += "ORDER BY ZZB_ARTIGO,ZZB_COD_I,ZZB_SEQUEN "

Iif(Select("CONSUL") # 0,CONSUL->(dbCloseArea()),.T.)

TcQuery cSql New Alias "CONSUL"
CONSUL->(dbSelectArea("CONSUL"))
CONSUL->(dbGoTop())

If CONSUL->(EOF()) .AND. CONSUL->(BOF())
	MsgInfo("Não há itens para consulta","Sem Itens")
	CONSUL->(dbCloseArea())
	Return
EndIf

SA2->(dbSetOrder(1))
While CONSUL->(!EOF())
	If aScan(axRoma,{ |x|x[1] =  CONSUL->ZZB_COD_I}) = 0
		aAdd(axItRoma,{.F.,CONSUL->ZZB_ARTIGO,CONSUL->ZZB_COD_I,CONSUL->ZZB_PESOB,CONSUL->ZZB_PESOL,CONSUL->ZZB_SQMTOT,;
		CONSUL->ZZB_SEQUEN, CONSUL->ZZB_ITEM})
	EndIf
	CONSUL->(dbSkip())
EndDo

CONSUL->(dbCloseArea())
If Len(axItRoma) > 0
	MostraTel()
Else
	MsgInfo("Não há itens para consulta","Sem Itens")
EndIf

Return



////////////DESVINCULACAO


//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: U_DesVincR
//|Autor.....: Luis Henrique de Oliveira  henrique@selectconsult.com.br
//|Data......: 11 de Fevereiro de 2011, 08:00
//|Uso.......: SIGAEEC
//|Versao....: Protheus - 10
//|Descricao.: Desvinculação do Romaneio de Couro
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function DesVincR(xPed)
	Processa({||DVR01(xPed)})
Return
*-----------------------------------------*
      
Static Function DVR01(xPed)
Local cSql := ""
Local lRet := .F.

Private axItRoma := {}
Private aDesc := {}
Private oLbx1 := Nil
Private bLine := Nil
Private oOk   := LoadBitmap( GetResources(), "LBOK" )
Private oNo   := LoadBitmap( GetResources(), "LBNO" )

ProcRegua(100)



dbSelectArea("ZZB")
dbSetOrder(1)
dbSeek(xfilial("ZZB")+alltrim(xped))
While ! eof() .and. ZZB->ZZB_PEDIDO == xPed

	//Aumenta a regua
	IncProc("Desvinculando")
                                  
	reclock("ZZB",.F.)
	ZZB->ZZB_USADO := SPACE(6)                         
	MsUnlock()                      

   ZZB->(dbSkip())
End


dbSelectArea("EE8")
dbSetOrder(1)
dbSeek(xfilial("EE8")+xped)
While ! eof() .and. EE8->EE8_PEDIDO == xPed

	//Aumenta a regua
	IncProc("Desvinculando")
	Reclock("EE8",.F.)               
	EE8->EE8_XITROM := "N"
    MsUnlock()                  
	
   	EE8->(dbSkip())
End

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: MostraTel()
//|Descricao.: Mostra tela com variação
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MostraTel()
*-----------------------------------------*

Local cLine := ""
Local nLin1 := 15
Local nCol1 := 5
Local nLin2 := 200
Local nCol2 := 400
Local _cTitle := ""

Private oDlgRom    := Nil
Private bOk     := {|| nOpcao := 1 , lRet := GrvSel(), Iif(lRet,oDlgRom:End(),.F.) }
Private bCancel := {|| nOpcao := 0 , Iif(MsgYesNo("Deseja Sair?","Sair"),oDlgRom:End(),.F.) }
Private nOpcao  := 1
Private aButt   := {}

_cTitle := "Vinculação de Romaneio"

aAdd(aButt,{"LBTIK",{|| UZMarcDes()         }, "Marca Todos"})

aDesc := {"","Artigo","Sub Produto","P. Bruto","P. Liq","SQM / Total", "Tot. Emb"}
cLine := "{Iif(axItRoma[oLbx1:nAt,1],oOk,oNo),axItRoma[oLbx1:nAt,2],axItRoma[oLbx1:nAt,3],axItRoma[oLbx1:nAt,4],"
cLine += "axItRoma[oLbx1:nAt,5],axItRoma[oLbx1:nAt,6],axItRoma[oLbx1:nAt,8]}"
bLine := &( "{ || " + cLine + " }" )

Define MsDialog oDlgRom Title _cTitle From 1,1 to 435,820 of oMainWnd PIXEL STYLE DS_MODALFRAME

oLbx1:= TWBrowse():New( nLin1,nCol1,nCol2,nLin2,,aDesc,,oDlgRom,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oLbx1:SetArray(axItRoma)
oLbx1:bLDblClick := { || axItRoma[oLbx1:nAt,1] := !axItRoma[oLbx1:nAt,1] }
oLbx1:bLine := bLine

Activate MsDialog oDlgRom ON INIT EnchoiceBar(oDlgRom,bOk,bCancel,,aButt) Centered

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: GrvSel()
//|Descricao.: Grava Itens selecionados
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function GrvSel()
*-----------------------------------------*

Local nSc := Ascan(axItRoma,{|x|x[1] == .T. } )

If Empty(nSc)
	MsgInfo("Não há produtos selecionados","Atenção")
	Return .F.
Else
	
		If MsgYesNo("Confirma vinculação dos Itens?","Romaneio de Couro")
			Processa({|| GrvVincRom()  })
			Return .T.
		EndIf
		
	
Endif
Return .F.

//+-----------------------------------------------------------------------------------//
//|Funcao....: GrvVincRom()
//|Descricao.: Vincula Itens selecionados do Romaneio
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function GrvVincRom()
*-----------------------------------------*

Local nxCouRom,nTotIts  := 0
Local lConvert := .F.
Local cSeq     := ""
Local aDados   := {}

ProcRegua(Len(axItRoma))

nxCouRom := 1
//Alert('Tamanho do Array -> '+cValToChar(len(axItRoma)) )
For nxCouRom := 1 To Len(axItRoma)
	IncProc("Vinculando Itens...")
	If axItRoma[nxCouRom,1]
		
		aAdd(axRoma,{axItRoma[nxCouRom,3],""})
		axDadRom := {}
		WorkIt->(dbSeek(axItRoma[nxCouRom,7]))
		axDadRom := {WorkIt->EE8_TES,WorkIt->EE8_CF,WorkIt->EE8_EMBAL1}

*********************************************     
**** Incluso pelo Fernando - aFill  
*********************************************     
		MID100DETMAN(INC_DET)
		
	EndIf
Next

axDadRom := {}

MsgInfo("Vinculação realizado com sucesso!","Vinculação")

Return

*********************************************     
**** Incluso pelo Fernando - aFill  
*********************************************     
/*
Funcao      : AP100DETMAN(nTipo,lExibe)
Parametros  : nTipo  := VIS_DET/INC_DET/ALT_DET/EXC_DET
              lExibe := Faz a inclusao do Workit sem tela de edição
Retorno     : .T.
Objetivos   : Permitir manutencao de outras descricoes da moeda
Autor       : Heder M Oliveira
Data/Hora   : 25/11/98 11:47
Revisao     : Jeferson Barros Jr. 02/10/01 - 14:25
              João Pedro Macimiano Trabbold - 10/10/05 às 11:30
Obs.        : JBJ - Habilitar a gravação de itens sem exibir tela ...
              JPM - Tratar consolidação de itens
*/
*--------------------------------------*
Static Function MID100DETMAN(nTipo, lExibe) 
*--------------------------------------*
Local lRet:=.T.,cOldArea:=Select()
Local oDlg,nInc,cNewTit,cSequencia
Local nRecno,aPos, i, j:=0
Local nCodI := 0

*********************************************     
**** Incluso pelo Fernando - aFill  
*********************************************     
Local nSLDINI := 0    
//Local cCOD_I
//Local nQTDCLI
//Local nEMBAL1
//Local cUNIDADE
//Local nQE
//Local nQTDEM1
//Local nPRECO
//Local dDTPREM
//Local dDTENTR
//Local cUNPES
//Local nPSLQUN
//Local cPOSIPI
Local cTES := Space(03)
Local cCF  := Space(04)                
   
Local nRecOld := WorkIt->(RecNo()), aBufferIt, aBufferItIt
Local nPos

// ** By JBJ - 10/06/2002 - 15:06
Local aCodDesc:={}, aVmDesc:={} //Local cVmDes, cDesc
Local aBkp := {}

Local bDetOk   := {||nOpcA:=1,If(AP100VALDET(nTipo,nRECNO) .And. If(nTipo=ALT_DET .Or. nTipo=INC_DET,AP100Crit("EE8_PRECO"),.T.),oDlg:End(),nOpcA:=0)}
Local bCancel  := {||nOpcA:=0,oDlg:End()}
Local aButtons := {}

Local aGrpVerify := {} //JPM
Private oGetPsLiq, oGetPsBru, oGetPreco, oGetItens, oGetPrecoI, oSayPsBru, oSayPsLiq
Private aTela[0][0],aGets[0], nUsado
   
Default lExibe     := .F.

If Type("lConsolida") <> "L"
   lConsolida := .f.
EndIf

Private nOpcA := 0
// ** JPM - 10/10/05 - Consolidação de itens na rotina de controle de qtds entre Br e Off-Shore
Private lConsolItem := lConsolida .And.;
                       !lExibe    .And.;
                       nTipo <> INC_DET
                       
If EECFlags("INTERMED") // EECFlags("CONTROL_QTD") // By JPP - 21/09/2006 - 09:00 - A rotina controle de quantidade passou a ser padrão para Off-Shore
   Private cConsolida := Ap104StrCpos(aConsolida)
EndIf

Private oMsMGet, aObjs

Private aHeader, aTotaliza := {}, aNotEditGetDb := {}, aDifValid := {}
Private aCposDif, aCposNotShow, aCposGetDb := {}, aStruct := {}, aAllCpos := {}
Private lDelTudo := .f.
Private lPerguntou := .f.,cAuxIt
Private nOpcFolder := 1
// **

nOPCI := nTipo

Begin Sequence
   
   If lConsolItem // JPM - 10/10/05
      Private lArtificial := .f.
      
      /*
      Nopado por ER em 24/11/2006.
      Os Itens que não possuírem quebra de linha, não serão tratados como Consolidação.
      
      Ap104TrtCampos(1) //tratamentos para o novo folder com browse de itens. (definição de campos, criação de work)
      M->EE8_TOTAL := 0 //inicializa variável.
      */
      
      //Tratar Filtro abaixo..
      //ER - 24/11/2006
      If Ap104TrtCampos(1) //tratamentos para o novo folder com browse de itens. (definição de campos, criação de work)
         M->EE8_TOTAL := 0 //inicializa variável.      
      Else
         lConsolItem := .F.
         WorkIt->( DBClearFilter() )  // PLB 03/04/07
      EndIf
   
   EndIf

   /* by jbj - Neste ponto o sistema irá verificar as condições que possibilitam 
               a alteração/exclusão de itens no pedido de exportação. */
   Do Case
      Case nTipo == INC_DET
           If !Ap104CanInsert()
              lRet:=.f.
              Break
           EndIf

      Case nTipo == EXC_DET
           If !Ap104CanDel()
              lRet:=.f.
              Break
           EndIf
   EndCase

   If !lExibe //** A inclusão será feita via tela de edição .. 

      /*
      AMS - 24/06/2005. Tratamento para não permitir a inclusão ou exclusão de itens caso o pedido seja originário da integração e
                        o parametro MV_AVG0094 estiver habilitado.
      */
      If Ap106VlIntegra(nTipo) // By JPP - 29/06/2005 - 14:00 - Esta função substitui a condição abaixo devido a estouro de define.
         Break
      EndIf
/*      If GetMv("MV_AVG0094",, .F.) .and. EE7->(FieldPos("EE7_INTEGR") > 0 .and. EE7_INTEGR = "S")
         If nTipo == INC_DET .or. nTipo == EXC_DET
            MsgStop(STR0134, STR0059) //"Não é permitida a inclusão ou exclusão de itens para este processo devida-a sua geração através da integração."###"Atenção"
            Break
         EndIf
      EndIf   */

      If nTipo==INC_DET
         WorkIt->(DBGOBOTTOM())
         cSEQUENCIA := STR(VAL(WorkIt->EE8_SEQUEN)+1,TAMSX3("EE8_SEQUEN")[1])
         WorkIt->(DBSKIP())
      EndIf

      nRecno:=WorkIt->(RecNo())

      If nTipo == INC_DET
         For j:=1 TO EE8->(FCount())
            M->&(EE8->(FieldName(j))) := CriaVar(EE8->(FieldName(j)))
         Next
         For j:=1 To Len(aMemoItem)    // By JPP - 31/01/2006 - 17:00
             M->&(aMemoItem[j][2]) := ""
         Next
      Else
         For nInc := 1 TO WorkIt->(FCount())
            M->&(WorkIt->(FIELDNAME(nInc))) := WorkIt->(FIELDGET(nInc))
         Next nInc
         
         aAdd(aButtons,{"SDUPROP", {|| AP106HistDet() }, STR0164, STR0165}) //"Historico de Saldo"###"Hist. Saldo"
      EndIf

      If nTIPO==INC_DET
         M->EE8_SEQUEN := cSequencia
         M->EE8_PEDIDO := M->EE7_PEDIDO
         M->EE8_FORN   := M->EE7_FORN
         M->EE8_FOLOJA := M->EE7_FOLOJA

         // ** By JBJ - 27/06/2002 - 09:59
         If lConvUnid
            M->EE8_UNPES  := If(!Empty(M->EE7_UNIDAD),M->EE7_UNIDAD,"")
         EndIf

      EndIf
      
      /* JPM - Validações dos itens, devem estar dentro do loop. Se for consolidação, fará o Loop 
               por toda a AuxIt. Se não, só fará uma vez, como é o normal */
      If lConsolItem
         AuxIt->(DbGoTop())
      EndIf
      
      While If(lConsolItem,AuxIt->(!EoF()),.t.)

         If lConsolItem
            WorkIt->(DbGoTo(AuxIt->EE8_RECNO))
         EndIf
         
         If nTipo == EXC_DET
            If !Ap100VldExc()
               Break
            EndIf
         EndIf
         
         If !lAltFix .And. nTipo <> INC_DET .And. !lConsolItem // JPM - 11/10/05
            If lCommodity .and. !Empty(WorkIT->EE8_DTFIX) .And. nTipo = ALT_DET
               MsgInfo(STR0122 , STR0024) //"Não é permitida a alteração de item com preço fixado."###"Atenção"
               Break
            ElseIf WorkIt->(FieldPos("EE8_RV")) > 0 
               IF !Empty(WorkIT->EE8_RV) .And. nTipo <> VIS_DET
                  MsgInfo(STR0123 , STR0024) //"Não é permitida a alteração de item com RV."###"Atenção"
                  Break
               ENDIF   
            EndIf
         EndIf
         
         If lConsolItem
            AuxIt->(DbSkip())
         Else
            Exit
         EndIf
      EndDo
              
      cNewTit:= STR0017+AllTrim(Transf(M->EE7_PEDIDO,AVSX3("EE7_PEDIDO",AV_PICTURE)))+" - "+AllTrim(AVSX3("EE8_SEQUEN",AV_TITULO))+": "+AllTrim(Transf(M->EE8_SEQUEN,AVSX3("EE8_SEQUEN",AV_PICTURE))) //"Definição de Produtos para o Pedido "
      
      // ** By JBJ - 12/06/03 set dos campos referentes a agente recebedor de comissão.
      If EECFlags("COMISSAO")
         If nTipo == INC_DET .And. GetMv("MV_AVG0088",,.t.) // JPP - 02/05/2005 15:40 - Inclusão do parametro "MV_AVG0088" na expressão.
            EECInitCmpAg()
         EndIf
      EndIf
      
      /*
      Rotina para manter os dados da ultima inclusão do item.
      Autor       : Alexsander Martins dos Santos
      Data e Hora : 26/02/2004 às 11:58.
      Observação  : A rotina será executada com o MV_AVG0060 igual .T.
      */
      If nTipo == INC_DET .and. GetMv("MV_AVG0060",,.F.)
         WorkIt->(dbGoBottom())
         For nInc := 1 To WorkIt->(FCount())                      
            If Type("M->"+WorkIt->(FieldName(nInc))) <> "U" .and. Empty(M->&(WorkIt->(FieldName(nInc))))
               If !(WorkIt->(FieldName(nInc)) $ "EE8_ORIGEM/EE8_ORIGV /EE8_DTFIX /EE8_PRCFIX/EE8_QTDFIX/EE8_STFIX /EE8_QTDLOT/EE8_DIFERE/EE8_DTVCRV/EE8_STA_RV/EE8_SEQ_RV/EE8_MESFIX/EE8_DTCOTA/EE8_DTRV  /EE8_RV    /EE8_FATIT ")
               M->&(WorkIt->(FieldName(nInc))) := WorkIt->(FieldGet(nInc))
            EndIf
            EndIf
         Next
         //ER - 29/08/2006 - Não carrega o Item do faturmanto, para gravar um novo na confirmação do Pedido.
         If lIntegra .and. EE8->(FieldPos("EE8_FATIT")) <> 0
            M->EE8_FATIT := ""
         EndIf
      EndIf
      //Fim da rotina.
      
      //** AAF - 09/09/04 - Adiciona campos do Back to back
      IF lBACKTO
         AP106ItemEnc(OC_PE)
      EndIF
      //**
      
      /*
      ER - 15/08/05 - 14:00
      Validaçao para alteraçao do codigo do Item caso exista um Embarque usando essa sequencia.
      */
      
      aBkp := {aClone(aEE8CamposEditaveis),aClone(aItemEnchoice)}

*********************************************     
**** Incluso pelo Fernando - aFill  
*********************************************     

cOldArea := GetArea()    

If Altera 
  cSeqEE8 := Str(nxCouRom,6)
  cBusca := xFilial("EE8")+EE7->EE7_PEDIDO+cSeqEE8+axItRoma[nxCouRom,3]
  EE8->(DbSetOrder(1))
  EE8->(DbSeek(cBusca))
Endif
    if nxCouRom <= Len(axItRoma)
      nSLDINI := axItRoma[nxCouRom,6] //ee8->EE8_SLDINI
    endif
      
    If Altera
     	M->EE8_SLDINI 	:= axItRoma[nxCouRom,6] //nSLDINI
		M->EE8_QTDEM1 	:= axItRoma[nxCouRom,8] //EE8->EE8_QTDEM1
      	M->EE8_COD_I 	:= EE8->EE8_COD_I
		M->EE8_DESC     := EE8->EE8_DESC  	
		//M->EE8_VM_DES   := //EE8->EE8_VM_DES
      	M->EE8_FABR 	:= EE8->EE8_FABR
      	M->EE8_FALOJA 	:= EE8->EE8_FALOJA      	      	
		M->EE8_QTDCLI 	:= EE8->EE8_QTDCLI
		M->EE8_QTDLIM 	:= EE8->EE8_QTDLIM
		M->EE8_EMBAL1 	:= EE8->EE8_EMBAL1
		M->EE8_UNIDADE 	:= EE8->EE8_UNIDADE
		M->EE8_QE 		:= EE8->EE8_QE
		M->EE8_PRECO 	:= EE8->EE8_PRECO
		M->EE8_DTPREM 	:= EE8->EE8_DTPREM
		M->EE8_DTENTR 	:= EE8->EE8_DTENTR
		M->EE8_UNPES 	:= EE8->EE8_UNPES
		M->EE8_PSLQUN 	:= EE8->EE8_PSLQUN
		M->EE8_POSIPI 	:= EE8->EE8_POSIPI
		M->EE8_TES 		:= '553' //EE8->EE8_TES
		M->EE8_CF 		:= '7101' //EE8->EE8_CF    
		M->EE8_SLDATU	:= EE8_SLDATU  
		M->EE8_PRECOI	:= EE8->EE8_PRECOI		
		M->EE8_PRCTOT 	:= EE8->EE8_PRCTOT
		M->EE8_PSLQTO 	:= EE8->EE8_PSLQTO
		M->EE8_PSBRUN 	:= EE8->EE8_PSBRUN
		M->EE8_PSBRTO 	:= EE8->EE8_PSBRTO
		M->EE8_REFCLI 	:= EE8->EE8_REFCLI  
		M->EE8_PRCINC 	:= EE8->EE8_PRCINC
		M->EE8_FATIT 	:= EE8->EE8_FATIT				
		M->EE8_PRCUN 	:= EE8->EE8_PRCUN
		M->EE8_XITROM	:= EE8->EE8_XITROM
		M->EE8_CCUSTO 	:= EE8->EE8_CCUSTO
		M->EE8_GRADE 	:= EE8->EE8_GRADE			  					
    Endif

    If nSLDINI != 0 .and. !Altera
      	M->EE8_SLDINI 	:= axItRoma[nxCouRom,6] //nSLDINI
		M->EE8_QTDEM1 	:= 1 //axItRoma[nxCouRom,8] //EE8->EE8_QTDEM1
      	M->EE8_COD_I 	:= axItRoma[nxCouRom,3]
//		M->EE8_DESC     :=  //EE8->EE8_DESC  	
		M->EE8_VM_DES   := Posicione("SB1",1,xFILIAL("SB1")+axItRoma[nxCouRom,3],"B1_DESC") //SB1->B1_DESC //EE8->EE8_VM_DES
      	M->EE8_FABR 	:= EE8->EE8_FABR
      	M->EE8_FALOJA 	:= EE8->EE8_FALOJA      	      	
		M->EE8_QTDCLI 	:= (axItRoma[nxCouRom,6]/2) //EE8->EE8_QTDCLI
		M->EE8_QTDLIM 	:= (axItRoma[nxCouRom,6]/2) //EE8->EE8_QTDLIM
//		M->EE8_EMBAL1 	:= Space(20) // EE8->EE8_EMBAL1
		M->EE8_UNIDADE 	:= "M2" //EE8->EE8_UNIDADE
		M->EE8_QE 		:= axItRoma[nxCouRom,6] //EE8->EE8_QE
		M->EE8_PRECO 	:= 0.00 //EE8->EE8_PRECO
		M->EE8_DTPREM 	:= dDataBase //EE8->EE8_DTPREM
		M->EE8_DTENTR 	:= dDataBase //EE8->EE8_DTENTR
		M->EE8_UNPES 	:= "KG" //EE8->EE8_UNPES
		M->EE8_PSLQUN 	:= axItRoma[nxCouRom,5] / axItRoma[nxCouRom,6] //EE8->EE8_PSLQUN
		M->EE8_POSIPI 	:= Posicione("SB1",1,xFILIAL("SB1")+axItRoma[nxCouRom,3],"B1_POSIPI") //EE8->EE8_POSIPI
		M->EE8_TES 		:= "553"  //cTes //EE8->EE8_TES
		M->EE8_CF 		:= "7101" //cCF  // EE8->EE8_CF    
		M->EE8_SLDATU	:= axItRoma[nxCouRom,6] // EE8_SLDATU  
		M->EE8_PRECOI	:= 0.00 //EE8->EE8_PRECOI		
//		M->EE8_PRCTOT 	:= EE8->EE8_PRCTOT
		M->EE8_PSLQTO 	:= axItRoma[nxCouRom,5] / axItRoma[nxCouRom,6] // EE8->EE8_PSLQTO
		M->EE8_PSBRUN 	:= axItRoma[nxCouRom,4] / axItRoma[nxCouRom,6] // EE8->EE8_PSBRUN
		M->EE8_PSBRTO 	:= axItRoma[nxCouRom,4] // EE8->EE8_PSBRTO
//		M->EE8_REFCLI 	:= "         " //EE8->EE8_REFCLI  
//		M->EE8_PRCINC 	:= EE8->EE8_PRCINC
//		M->EE8_FATIT 	:= EE8->EE8_FATIT				
		M->EE8_PRCUN 	:= 0.00 //EE8->EE8_PRCUN
//		M->EE8_XITROM	:= EE8->EE8_XITROM
//		M->EE8_CCUSTO 	:= EE8->EE8_CCUSTO
//		M->EE8_GRADE 	:= EE8->EE8_GRADE								

nxCouRom += 1
cTES := M->EE8_TES
CCF  := M->EE8_CF                

    Endif

RestArea(cOldArea)

*********************************************     
     
      IF nTipo == ALT_DET .and. WorkIT->EE8_SLDINI <> WorkIT->EE8_SLDATU
      
         nCodI := aScan(aEE8CamposEditaveis,"EE8_COD_I")
         IF nCodI > 0                                 
            aDel(aEE8CamposEditaveis,nCodI)
            aSize(aEE8CamposEditaveis,Len(aEE8CamposEditaveis)-1)
         EndIf
      EndIf
      
      // JPM - 11/10/05 - Controle de qtds fil Br. Ex.
      If lConsolItem
         Ap104TrtCampos(2) //Tratamentos para campos editáveis, não usados, etc.
      EndIf
      
      If !lAlteraStatus .And. cStatus == ST_CL
         aBufferIt := Array(Len(aFieldItens))
         For i:=1 to Len(aFieldItens)
            IF (lConsolItem .And. AScan(aCposDif,aFieldItens[i]) > 0) .Or. Type("M->"+aFieldItens[i]) = "U"
               Loop
            Endif
            aBufferIt[i] := Eval(MemVarBlock(aFieldItens[i]))
         Next i
         
         If lConsolItem // JPM
            aBufferItIt := Array(AuxIt->(RecCount()))
            AuxIt->(DbGoTop())
            j := 0
            While AuxIt->(!EoF())
               j++
               aBufferItIt[j] := Array(Len(aFieldItens))
               For i:=1 to Len(aFieldItens)
                  IF AScan(aCposDif,aFieldItens[i]) > 0
                     Loop
                  Endif
                  aBufferItIt[j][i] := AuxIt->&(aFieldItens[i])
               Next i
      
               AuxIt->(DbSkip())
            EndDo
            AuxIt->(DbGoTop())
         EndIf
      Endif
      
      DEFINE MSDIALOG oDlg TITLE cNewTit FROM DLG_LIN_INI,DLG_COL_INI TO DLG_LIN_FIM,DLG_COL_FIM OF oMainWnd PIXEL
         
         aPos := PosDlg(oDlg)
         aPos[3] -= 28 // Rodape 

       // JPM - Criar enchoice com MsMGet para retornar objeto.

         oMsMGet := MsMGet():New( "EE8", , IF(nTipo=INC_DET,3,4), , , ,aItemEnchoice, aPos,IF(Str(nTipo,1) $ Str(VIS_DET,1)+"/"+Str(EXC_DET,1), {}, If(Len(aEE8CamposEditaveis) <> 0, aEE8CamposEditaveis,) ), 3 )
         
         If lConsolItem
            aObjs := Ap104TelaIt(oMsMGet)
         EndIf
         
         aPos[1] := aPos[3]
         aPos[3] := aPos[1]+28
         
         AP100DetTela(.T.,aPos,nTipo) 
                  
         // Busca a descrição do memo do work
         //M->EE8_VM_DES := WorkIt->EE8_VM_DES // ** By JBJ - 10/06/2002 - 14:08
         /*

         AMS - 05/11/2003 às 13:00, Substituido a rotina abaixo, pq os campos do aMemoItem já 
                                    estão sendo carregados no aFieldVirtual e tendo o seu conteúdo 
                                    carregado pelo X3_RELACAO e gravado no WorkIt.
                                    Obs. Os campos de tipo "MEMO" devem ter o X3_RELACAO preenchido.
         
         For i:=1 To Len(aMemoItem)
            If WorkIt->(FieldPos(aMemoItem[i][2])) > 0
               M->&(aMemoItem[i][2]) := WorkIt->&(aMemoItem[i][2])
            EndIf
         Next i
         */
       
         oDlg:lMaximized := .T.

      //ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,If(AP100VALDET(nTipo,nRECNO) .And. If(nTipo=ALT_DET .Or. nTipo=INC_DET,AP100Crit("EE8_PRECO"),.T.),oDlg:End(),nOpcA:=0)},{||nOpcA:=0,oDlg:End()})
      ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bDetOk,bCancel,,aButtons) //ER - 28/02/2007

      aEE8CamposEditaveis := aClone(aBkp[1])
      aItemEnchoice := aClone(aBkp[2])
   
   Else // ** Faz a inclusão sem tela de edição ...
      nRecNo := IF(nTipo==INC_DET,0,WorkIt->(RecNo()))     
             
      SX3->(dbSetOrder(2))
      For nInc := 1 TO WorkIt->(FCount())
         If Type("M->"+WorkIt->(FIELDNAME(nInc))) = "U"
            IF SX3->(dbSeek(WorkIt->(FIELDNAME(nInc))))
               M->&(WorkIt->(FIELDNAME(nInc))):= CriaVar(WorkIt->(FIELDNAME(nInc)))
            Endif
         EndIf
      Next

      If nTipo==INC_DET
         WorkIt->(DBGOBOTTOM())
         cSEQUENCIA := STR(VAL(WorkIt->EE8_SEQUEN)+1,TAMSX3("EE8_SEQUEN")[1])
         WorkIt->(DBSKIP())
      EndIf

      // ** By JBJ - 10/06/2002 - 15:03
      //cDesc := M->EE8_DESC 
      //cVmDes := M->EE8_VM_DES

      For i:=1 To Len(aMemoItem)
         If EE8->(FieldPos(aMemoItem[i][1])) > 0
            aAdd(aCodDesc,M->&(aMemoItem[i][1]))
            aAdd(aVmDesc,M->&(aMemoItem[i][2]))
         EndIf
      Next i

      // ** By JBJ - 10/06/2002 - 15:04
      //M->EE8_VM_DES  := cVmDes
      For i:=1 To Len(aMemoItem)
         If EE8->(FieldPos(aMemoItem[i][1])) > 0
            M->&(aMemoItem[i][2]):=aVmDesc[i]
         EndIf
      Next i
     
      //M->EE8_DESC :="."
 
      // ** Executa todas as validações ... 
      If(AP100VALDET(nTipo,nRecNo),nOpca:=1,"")

      // ** By JBJ - 10/06/2002 - 15:04
      //M->EE8_DESC := cDesc
      For i:=1 To Len(aMemoItem)
        If EE8->(FieldPos(aMemoItem[i][1])) > 0
           M->&(aMemoItem[i][1]):=aCodDesc[i]
        EndIf
      Next i

      M->EE8_SEQUEN := cSequencia
                                     
   EndIf        
         
   IF nOpcA == 1 .And. !lDelTudo// Ok
      
      If lConsolItem
         //Ap104AuxIt(7)
         AuxIt->(DbGoTop())
      EndIf
      
      IF ! Str(nTipo,1) $ Str(VIS_DET,1)+Str(EXC_DET,1)
         IF ! lAlteraStatus .And. cStatus == ST_CL
            For i:=1 To Len(aFieldItens)
               IF (lConsolItem .And. AScan(aCposDif,aFieldItens[i]) > 0) .Or. Type("M->"+aFieldItens[i]) = "U"
                  Loop
               Endif
                      
               IF aBufferIt[i] != Eval(MemVarBlock(aFieldItens[i]))
                  lAlteraStatus := .T.                     
                  Exit
               Endif
            Next i
            
            If lConsolItem // JPM
               AuxIt->(DbGoTop())
               j := 0
               While AuxIt->(!EoF())
                  j++
                  aBufferItIt[j] := Array(Len(aFieldItens))
                  For i:=1 to Len(aFieldItens)
                     IF AScan(aCposDif,aFieldItens[i]) > 0
                        Loop
                     Endif
                     IF aBufferItIt[j][i] != AuxIt->&(aFieldItens[i])
                        lAlteraStatus := .T.                     
                        Exit
                     Endif
                  Next i
                  AuxIt->(DbSkip())
               EndDo
               AuxIt->(DbGoTop())
            EndIf

         Endif
      EndIf
      
      While If(lConsolItem, AuxIt->(!Eof()), .t.)
         If lConsolItem
            If AuxIt->DELETE
               AuxIt->(DbSkip())
               Loop
            EndIf
            Ap104AuxIt(3,,.t.) // Simula variáveis de memória
         EndIf
         
         IF nTipo == INC_DET
            WorkIt->(DBAPPEND())
   
            // ** By JBJ - 14/06/2002 - 08:45 
            If lConvUnid         
               M->EE7_PESLIQ += AvTransUnid(M->EE8_UNPES,If(!Empty(M->EE7_UNIDAD),M->EE7_UNIDAD,"KG"),M->EE8_COD_I,M->EE8_PSLQTO,.F.)
               M->EE7_PESBRU += AvTransUnid(M->EE8_UNPES,If(!Empty(M->EE7_UNIDAD),M->EE7_UNIDAD,"KG"),M->EE8_COD_I,M->EE8_PSBRTO,.F.)
            Else
               M->EE7_PESLIQ += M->EE8_PSLQTO
               M->EE7_PESBRU += M->EE8_PSBRTO
            EndIf
   
            M->EE7_TOTITE++
            IF cStatus == ST_CL
               lAlteraStatus := .T.
            Endif
   
            /*
            Gravação do saldo na Work e na variável de memória.
            Autor: Alexsander Martins dos Santos
            Data e Hora: 05/08/2004 às 17:25.
            */
            WorkIT->EE8_SLDATU := M->EE8_SLDATU := M->EE8_SLDINI
   
         Elseif nTipo == ALT_DET         
   
            //** By JBJ - 14/06/2002 - 08:46 
            If lConvUnid
               M->EE7_PESLIQ -= AvTransUnid(WorkIt->EE8_UNPES,If(!Empty(M->EE7_UNIDAD),M->EE7_UNIDAD,"KG"),WorkIt->EE8_COD_I,WorkIt->EE8_PSLQTO,.F.)
               M->EE7_PESBRU -= AvTransUnid(WorkIt->EE8_UNPES,If(!Empty(M->EE7_UNIDAD),M->EE7_UNIDAD,"KG"),WorkIt->EE8_COD_I,WorkIt->EE8_PSBRTO,.F.)
               M->EE7_PESLIQ += AvTransUnid(M->EE8_UNPES,If(!Empty(M->EE7_UNIDAD),M->EE7_UNIDAD,"KG"),M->EE8_COD_I,M->EE8_PSLQTO,.F.)
               M->EE7_PESBRU += AvTransUnid(M->EE8_UNPES,If(!Empty(M->EE7_UNIDAD),M->EE7_UNIDAD,"KG"),M->EE8_COD_I,M->EE8_PSBRTO,.F.)
            Else
               M->EE7_PESLIQ -= WorkIt->EE8_PSLQTO
               M->EE7_PESBRU -= WorkIt->EE8_PSBRTO
               M->EE7_PESLIQ += M->EE8_PSLQTO
               M->EE7_PESBRU += M->EE8_PSBRTO
            EndIf
         EndIf
               
         IF ! Str(nTipo,1) $ Str(VIS_DET,1)+Str(EXC_DET,1)
            IF ! lAlteraStatus .And. cStatus == ST_CL
               For i:=1 To Len(aFieldItens)
                   IF Type("M->"+aFieldItens[i]) = "U"
                      Loop
                   Endif
                    
                   IF aBufferIt[i] != Eval(MemVarBlock(aFieldItens[i]))
                      lAlteraStatus := .T.
                      Exit
                   Endif
               Next i
            Endif

            /*
            Substituido a gravação do EE8_SLDATU, para permitir a atualização do saldo, pela função AP104SLDEMB.
            Autor: Alexsander Martins dos Santos
            Data e Hora: 05/08/2004 às 17:17.
   
            M->EE8_SLDATU := M->EE8_SLDINI
            */
   
            If nSelecao = INCLUIR
               WorkIT->EE8_SLDATU := M->EE8_SLDATU := M->EE8_SLDINI
            EndIf
   
            EECPPE07("PESOS",.t.)
            
            M->EE8_RECNO := Nil
            AVReplace("M","WorkIt")
   
            // ** By JBJ - 10/06/2002 - 13:53 ...
            //WorkIt->EE8_VM_DES := M->EE8_VM_DES
   
            For i:=1 To Len(aMemoItem)
               If WorkIt->(FieldPos(aMemoItem[i][2])) > 0
                  WorkIt->&(aMemoItem[i][2]) := M->&(aMemoItem[i][2])
               EndIf
            Next i
   
         // by CAF 29/02/2000 14:52 WorkIt->EE8_PRCTOT := AP100PrcTot(M->EE8_PRECO,M->EE8_SLDINI)

            // FJH - 03/02/06 - Calcula desconto da capa de acordo com o digitado nos itens
            If GetMV("MV_AVG0119",,.F.) .and. EE8->(FieldPos("EE8_DESCON")) > 0
               EECCALCDESC("P")
            Endif
 
            //Formar preco incoterm
            AP100PrecoI()
   
         /*
         // ** By JBJ - 26/06/2002 - 13:24
         If lCommodity
            If !Empty(WorkIt->EE8_DTFIX)
               WorkIt->EE8_PRECO := M->EE8_PRCFIX
               WorkIt->EE8_SLDINI:= M->EE8_SLDINI
            EndIf
         EndIf
         */

            // ** By JBJ - 12/06/2003 - 13:48 - Atualizar o total de comissão do agente.
            If EECFlags("COMISSAO")
               EECTotCom()
            EndIf
   
         // ** Atualiza o valor das invoices de compra para os tratamentos de back to back.
         If lBackTo           
            AP106VlInv(OC_PE)
         Endif     

            AP100TTELA(.F.)
         EndIf
 
         oMsSelect:oBrowse:Refresh()
      
         If lConsolItem
            Ap104AuxIt(4,.t.,.t.) //Restaura backup de variáveis de memória.
            AuxIt->(DbSkip())
         Else
            Exit
         EndIf
      EndDo
      
      /*
      Nopado por ER em 10/03/2008. A gravação da WorkGrp será realizada também na alteração do item.
      If nTipo == INC_DET .And. lConsolida // Ao incluir um item, inclui um novo registro de grupo na base
         WorkGrp->(DbAppend())
         For i := 1 To Len(aGrpCpos)
            WorkGrp->&(aGrpCpos[i]) := WorkIt->&(aGrpCpos[i])
         Next
         WorkGrp->EE8_ORIGEM := WorkIt->EE8_SEQUEN
         WorkGrp->TRB_ALI_WT := "EE8"
         WorkGrp->TRB_REC_WT := EE8->(Recno())
      EndIf
      */
      //ER - 10/03/2008. Gravação da WorkGrp.
      If lConsolida
         If nTipo == INC_DET
            WorkGrp->(DbAppend())
            For i := 1 To Len(aGrpCpos)
               WorkGrp->&(aGrpCpos[i]) := WorkIt->&(aGrpCpos[i])
            Next
            WorkGrp->EE8_ORIGEM := WorkIt->EE8_SEQUEN
            WorkGrp->TRB_ALI_WT := "EE8"
            WorkGrp->TRB_REC_WT := EE8->(Recno())
     
         ElseIf nTipo == ALT_DET
            For i := 1 To Len(aGrpCpos)
               WorkGrp->&(aGrpCpos[i]) := WorkIt->&(aGrpCpos[i])
            Next
            WorkGrp->EE8_ORIGEM := WorkIt->EE8_SEQUEN
            WorkGrp->TRB_ALI_WT := "EE8"
            WorkGrp->TRB_REC_WT := EE8->(Recno())

         EndIf
      EndIf
            
      If lConsolItem
    
         // Trata itens deletados
         AuxIt->(DbGoTop())
         While AuxIt->(!Eof())
            If AuxIt->DELETE
               lConsolItem := .f.
               AP100ValDet(EXC_DET,AuxIt->EE8_RECNO,.t.)
               lConsolItem := .t.
            EndIf
            AuxIt->(DbSkip())
         EndDo

         Ap104AuxIt(7,.t.) // totaliza variáveis de memória.

         // Atualiza WorkGrp
         For i := 1 To Len(aGrpCpos)
            If aGrpCpos[i] = "EE8_ORIGEM"
               // é sempre o mesmo.
            ElseIf aGrpInfo[i] = "N" // se for um campo que não é sempre igual.. (Ex. Preço)
               AAdd(aGrpVerify,{aGrpCpos[i],Nil}) //Vai verificar um por um
            Else
               WorkGrp->&(aGrpCpos[i]) := M->&(aGrpCpos[i])  // quando é campo de totalizar, a memória já está totalizada
            EndIf
         Next
         
         // tratamentos para campos que não são sempre iguais
         AuxIt->(DbGoTop())
         While AuxIt->(!Eof())
            If AuxIt->DELETE
               AuxIt->(DbSkip())
               Loop
            EndIf
            For i := 1 To Len(aGrpVerify)
               If i = 1
                  aGrpVerify[i][2] := AuxIt->&(aGrpVerify[i][1])
               Else
                  If aGrpVerify[i][2] <> AuxIt->&(aGrpVerify[i][1])
                     aGrpVerify[i][2] := CriaVar(aGrpVerify[i][1])
                  EndIf
               EndIf
            Next
            AuxIt->(DbSkip())
         EndDo
         
         // atualiza os campos.
         For i := 1 To Len(aGrpVerify)
            WorkGrp->&(aGrpVerify[i][1]) := aGrpVerify[i][2]
         Next

      EndIf
      
   Elseif nOpcA == 0 // Cancel
         
       IF nTipo == INC_DET
          WorkEm->(dbSeek(M->EE7_PEDIDO+M->EE8_SEQUEN))
          While !WorkEm->(Eof()) .And. WorkEm->(EEK_PEDIDO+EEK_SEQUEN)==;
                                            M->EE7_PEDIDO+M->EE8_SEQUEN
              WorkEm->(dbDelete())
              WorkEm->(dbSkip())
          Enddo
          WorkIt->(dbGoTo(nRecOld))
       Endif
         
   EndIf
   
   //ER - 20/12/05 ás 19:20
   If ExistBlock("EECAP100")
      ExecBlock("EECAP100",.F.,.F.,{ "PE_GRVDET",nTipo})
   Endif 
End Sequence

If Select("AuxIt") > 0
   AuxIt->(E_EraseArq(cAuxIt))
EndIf

If AllTrim(cOldArea) <> "SX3"
   dbSelectArea(cOldArea)
EndIf

// ** JBJ 15/10/01 9:40 - Reabre a tela de inclusão de itens ...
IF nOpcA = 1 .And. nTipo == INC_DET .And. !lExibe
   MID100DETMAN(INC_DET)
EndIf
// **

oMsSelect:oBrowse:Refresh()

Return lRet


*********************************************     
**** Incluso pelo Fernando - aFill  
*********************************************     
/*
Funcao      : AP100VALDET(nTipo,nRecno,lForcado)
Parametros  : nTipo := idem nTipo AT135SYR_MAN
              nRecno:= n.registro
              lForcado := exclusão pela rotina de consolidação de itens
Retorno     : .T. / .F.
Objetivos   : validar/aceitar exclusao
Autor       : Heder M Oliveira
Data/Hora   : 25/11/98 11:51
Revisao     : WFS 24/02/2010
              Inclusão dos tratamentos de deleção de itens para quando
              o recurso Grade está habilitado.
Obs.        :
*/
Static Function AP100VALDET(nTipo,nRecno,lForcado)
   Local lRet:=.T.,cOldArea:=select(),cTmpPreco, cOldCodAg, aOrdAux:={}
   Local nDiferenca:=0, nVlToAtu:=0, nSldAtu := 0, nPos, nLinha, nColuna, nLinAcols
   Local cVal := "", cCpoCont, cProdGrd
   Local lAllDeleted := .t. // define se todos os itens foram deletados
   
   Default lForcado := .f.

   Begin Sequence
      If nTipo == INC_DET .OR. nTipo = ALT_DET
            
         //19.mai.2009 - UE719925 - Tratamento para data de prev. de embarque e entrega - HFD
         If M->EE8_DTENTR < M->EE8_DTPREM 
            MsgInfo("Data de Entrega deve ser maior ou igual a Data de Prev. de Embarque","Aviso")
            lRet:=.f.
            Break
         EndIf
         If lConsolItem
            Ap104AuxIt(7)
            AuxIt->(DbGoTop())
         Else
            lAllDeleted := .f.
         EndIf   
         
         While If(lConsolItem, AuxIt->(!EoF()), .t.)
            If lConsolItem
               If AuxIt->DELETE
                  AuxIt->(DbSkip())
                  Loop
               EndIf
               Ap104AuxIt(3,,.t.) // Simula variáveis de memória
               cVal := " - " + AllTrim(AvSx3("EE8_SEQUEN",AV_TITULO)) + " " + AllTrim(AuxIt->EE8_SEQUEN)
               If lAllDeleted .And. !(AuxIt->DELETE)
                  lAllDeleted := .f.
               EndIf
            Else
               cVal := ""
            EndIf
            // JPM - 03/08/05 - validação da Carta de Crédito
            If EECFlags("ITENS_LC")
               If !Ae107VldProd(OC_PE)
                  lRet := .f.
                  Break
               EndIf
            EndIf
          
            /* Neste ponto o sistema irá realizar validações para criticar as alterações na
               quantidade do item. */

            If nTipo == ALT_DET .And. lIntermed .And. SM0->M0_CODFIL == cFilBr .And. M->EE7_INTERM $ cSim
               If !Ax101VldQtde(OC_PE)
                  lRet:=.f.
                  Break
               EndIf
            EndIf

            If EECFlags("COMISSAO")
             
               // JPM - 31/05/05 - Campo novo: tipo de comissão no item
               If EE8->(FieldPos("EE8_TIPCOM")) > 0 .And. !Empty(M->EE8_CODAGE) .And. Empty(M->EE8_TIPCOM)
                  MsgInfo(STR0133 + "'" + AllTrim(AvSx3("EE8_TIPCOM",AV_TITULO)) + "'",STR0036)//"Preencha o campo " ## "Aviso"
                  lRet := .f.
                  Break
               EndIf

               // ** Para o tipo 'Percentual por Item' o percentual de comissao deve ser informado.
               If !Empty(M->EE8_CODAGE) .And. M->EE8_PERCOM = 0
                  //If WorkAg->(DbSeek(M->EE8_CODAGE+CD_AGC)) - JPM - 31/05/05
                  If WorkAg->(DbSeek(M->EE8_CODAGE+AvKey(CD_AGC+"-"+Tabela("YE",CD_AGC,.f.),"EEB_TIPOAG")+;
                                      If(EE8->(FieldPos("EE8_TIPCOM")) > 0,M->EE8_TIPCOM,"")))
                     //If WorkAg->EEB_TIPCVL $ "1/3" // Percentual/Percentual por Item.
                     If WorkAg->EEB_TIPCVL = "3" // Percentual por Item.
                        MsgInfo(STR0118,STR0036) //"O percentual de comissão deve ser informado!"###"Aviso"
                        lRet := .f.
                        Break
                     EndIf
                  EndIf
               EndIf
             
            EndIf


            // ** By JBJ - 25/06/2002 - 17:08
            If lCommodity
               AP100GrvStFix()
            EndIf
          
            IF TYPE("SB1->B1_REPOSIC") <> "U"
               IF Posicione("SB1",1,xFILIAL("SB1")+M->EE8_COD_I,"B1_REPOSIC") $cSim
                  lAltQtd := !EMPTY(M->EE8_SLDINI)
                  lAltFor := !EMPTY(M->EE8_FORN)
                  lAltLoj := !EMPTY(M->EE8_FOLOJA)
                  lAltEmb := !EMPTY(M->EE8_EMBAL1)
                  lAltQE  := !EMPTY(M->EE8_QE)
                  lAltQem := !EMPTY(M->EE8_QTDEM1)
                  lAltNcm := !EMPTY(M->EE8_POSIPI)
                  HELP(" ",1,"AVG0000629") //MSGINFO("Este é um produto para reposição, os valores serão zerados","Aviso")
                  M->EE8_SLDINI := IF(laltQtd,M->EE8_SLDINI,1)
                  M->EE8_FORN   := IF(laltFor,M->EE8_FORN,".")
                  M->EE8_FOLOJA := IF(laltLoj,M->EE8_FOLOJA,".")
                  M->EE8_EMBAL1 := IF(laltEmb,M->EE8_EMBAL1,".")
                  M->EE8_QE     := IF(laltQE,M->EE8_QE,1)
                  M->EE8_QTDEM1 := IF(laltQem,M->EE8_QTDEM1,1)
                  M->EE8_POSIPI := IF(laltNcm,M->EE8_POSIPI,".")
                  M->EE8_PSLQUN := 1
                  M->EE8_PSBRUN := 1
                  M->EE8_PRECO  := 1
                  M->EE8_PRECOI := 1
                  M->EE8_PRCTOT := 1
                  M->EE8_PRCINC := 1
               ENDIF
            ENDIF

            If lCommodity
               cTmpPreco:=M->EE8_PRECO

               M->EE8_PRECO:=1

               lRet:=Obrigatorio(aGets,aTela)

               M->EE8_PRECO:=cTmpPreco
            Else
               lRet:=Obrigatorio(aGets,aTela)
            EndIf

            If !lRet
               Break
            EndIf

            IF TYPE("SB1->B1_REPOSIC") <> "U"
               IF Posicione("SB1",1,xFILIAL("SB1")+M->EE8_COD_I,"B1_REPOSIC") $cSim
                  M->EE8_SLDINI := IF(laltQtd,M->EE8_SLDINI,0)
                  M->EE8_FORN   := IF(laltFor,M->EE8_FORN,"")
                  M->EE8_FOLOJA := IF(laltLoj,M->EE8_FOLOJA,"")
                  M->EE8_EMBAL1 := IF(laltEmb,M->EE8_EMBAL1,"")
                  M->EE8_QE     := IF(laltQE,M->EE8_QE,0)
                  M->EE8_QTDEM1 := IF(laltQem,M->EE8_QTDEM1,0)
                  M->EE8_POSIPI := IF(laltNcm,M->EE8_POSIPI,"")
                  M->EE8_PSLQUN := 0
                  M->EE8_PSBRUN := 0
                  M->EE8_PRECO  := 0
                  M->EE8_PRECOI := 0
                  M->EE8_PRCTOT := 0
                  M->EE8_PRCINC := 0
               ENDIF
            ENDIF

            /* by jbj - 28/06/04 11:12 - Para processos com tratamento de off-shore e ambientes com a rotina 
                                         de Commodity desabilitada, o preço negociado a obrigatório. */
            If lIntermed .And. !lCommodity
               If (M->EE7_INTERM $ cSim) .And. Empty(M->EE8_PRENEG)
                  MsgStop(STR0121,STR0024) //"Para processos com tratamentos de off-shore o preço negociado é obrigatório para todos os produtos."###"Atenção"
                  lRet:=.f.
                  Break
               EndIf
            EndIf

            /* by jbj - 19/05/05 - Neste ponto o sistema irá realizar tratamentos para os casos em que a quantidade
                                   do item (pedido) for alterada, atendendo as seguintes regras:
                                   1) Para os casos de aumento na quantidade:
                                      a) O sistema sempre irá aumentar somente o saldo do item no pedido, ou seja,
                                         nesta situação o usuário não terá opção de atualizar as quantidades do(s)
                                         embarque(s) onde o item foi utilizado.
                                   2) Para os casos de diminuição na quantidade:
                                      a) Caso a diferença a ser abatida seja menor ou igual ao saldo da linha, o
                                         sistema irá abater diretamente no saldo, não exibindo a tela de seleção
                                         de embarques.
                                      b) Caso a diferença a ser abatida seja maior que o saldo, o sistema irá  abater
                                         o saldo, e o restante irá solicitar que o usuário selecione um embarque para
                                         abatimento da quantidade restante. */

            If nTipo == ALT_DET .And. M->EE8_SLDINI <> WorkIt->EE8_SLDINI .And.  !lConsolItem // JPM/JPP - na consolidação, o saldo é atualizado sempre na hora da edição do browse.
               // Verifica se o item sofreu alteração na quantidade.
               nDiferenca := (M->EE8_SLDINI - WorkIt->EE8_SLDINI)

               If nDiferenca > 0
                  M->EE8_SLDATU += nDiferenca
               Else
                  nSldAtu := M->EE8_SLDATU

                  If nSldAtu + nDiferenca < 0
                     nVlToAtu := nDiferenca + nSldAtu

                     If nVlToAtu < 0
                        If AP104ItemEmb(M->EE8_PEDIDO, M->EE8_SEQUEN) > 0
                           
                           ///////////////////////////////////////////////////////////////////////////////////////
                           //Para a nova integração entre SigaEEC e SigaFAT a atualização de embarque automática//
                           //não será realizada.                                                                //
                           ////////////////////////////////////////////////////////////////////,///////////////////
                           If !lIntEmb
                              If !AP104SldEmb(nVlToAtu,M->EE8_PEDIDO, M->EE8_SEQUEN)
                                 lRet := .f.
                                 Break
                              EndIf
                              M->EE8_SLDATU := 0
                           Else
                              MsgStop(STR0130, STR0024) //"Qtde informada inválida, pois o saldo alocado em embarque é maior."###"Atenção"
                              lRet := .f.
                              Break
                           EndIf
                        Else
                           MsgStop(STR0130, STR0024) //"Qtde informada inválida, pois o saldo alocado em embarque é maior."###"Atenção"
                           lRet := .f.
                           Break
                        EndIf
                     Else
                        M->EE8_SLDATU += nDiferenca
                     EndIf
                  Else
                     M->EE8_SLDATU += nDiferenca
                  EndIf
               EndIf
            EndIf

            /*
            Rotina para validação da qtde. do item, verificando se o mesmo está embarcado.
            Autor: Alexsander Martins dos Santos.
            Date e Hora: 03/08/2004 às 15:15.
            */
            /*
            If nTipo = ALT_DET
               If AP104ItemEmb(M->EE8_PEDIDO, M->EE8_SEQUEN) > 0 // Verifica se o item foi utilizado em algum embarque.

                  // ** Verifica se o item sofreu alteração na quantidade.
                  If M->EE8_SLDINI <> WorkIT->EE8_SLDINI

                     // ** Exibe tela para seleção de embarque a ser realizada pelo usuário.
                     If !AP104SLDEMB(WorkIT->EE8_SLDINI, M->EE8_SLDINI, M->EE8_PEDIDO, M->EE8_SEQUEN)
                        lRet := .f.
                        Break
                     EndIf
                  EndIf
               Else
                  If M->EE8_SLDATU+(M->EE8_SLDINI-WorkIt->EE8_SLDINI) >= 0
                     M->EE8_SLDATU += (M->EE8_SLDINI - WorkIt->EE8_SLDINI)
                  Else
                     MsgStop(STR0130, STR0024) //"Qtde informada inválida, pois o saldo alocado em embarque é maior."###"Atenção"
                     lRet := .f.
                     Break
                  EndIf
               EndIf
            EndIf
            */
         
            /* Neste ponto o sistema irá carregar o array aItAlterados, para controle de alteração do preço negociado
               nas linhas. */

            If lReplicaDados
               nPos := aScan(aItAlterados,{|x| x[1] == M->EE8_SEQUEN})

               If nPos > 0
                  If M->EE8_PRENEG <> aItAlterados[nPos][2]
                     aItAlterados[nPos][2] := M->EE8_PRENEG
                  EndIf
               Else
                  aOrdAux := SaveOrd({"EE8"})
                  EE8->(DbSetOrder(1))
                  If EE8->(DbSeek(xFilial("EE8")+M->EE8_PEDIDO+M->EE8_SEQUEN))
                     If EE8->EE8_PRENEG <> M->EE8_PRENEG 
                        aAdd(aItAlterados,{M->EE8_SEQUEN,M->EE8_PRENEG})
                     EndIf                  
                  EndIf
                  RestOrd(aOrdAux,.t.)
               EndIf
            EndIf

            // LCS - 27/09/2002 - INCLUI A CHAMADA DO PONTO DE ENTRADA
            If (ExistBlock("EECPPE08")) 
               // By JBJ - 06/04/04 - Tratamento para retorno do ponto de entrada.
               lRet := ExecBlock("EECPPE08",.F.,.F.)
               If ValType(lRet) <> "L"
                  lRet := .t.
               Elseif ! lRet
                  Break
               Endif
            EndIf
         
            //** AAF - 09/09/04 - Validação para Back To Back
            if lBACKTO           
               lRet := AP106Valid("PE_DET_OK")
            endif 

            If lConsolItem
               Ap104AuxIt(4,.t.,.t.) //Restaura backup de variáveis de memória.
               AuxIt->(DbSkip()) //situação de consolidação de itens: valida para cada registro da AuxIt
            Else
               Exit // situação normal: valida apenas uma vez
            EndIf
         EndDo
         
         If lAllDeleted // se todos os itens da work AuxIt foram deletados, então exclui o item por inteiro.
            nTipo := EXC_DET
            If !(lRet := AP100ValDet(nTipo,nRecno))
               Break
            EndIf
         EndIf            
            

      ElseIf nTipo == EXC_DET  
        
         If !lForcado
            lDelTudo := .t.
         EndIf

         If lConsolItem
            AuxIt->(DbGoTop())
         Else
            WorkIt->(DbGoTo(nRecno))
         EndIf
      
         If lForcado .Or. lEE7Auto .Or. MSGYESNO(STR0058,STR0059) //'Confirma Exclusão? '###'Atenção'
            While If(lConsolItem, AuxIt->(!EoF()),.t.)

               If lConsolItem
                  WorkIt->(DbGoTo(AuxIt->EE8_RECNO))
               EndIf
                
               WorkEm->(dbSeek(M->EE7_PEDIDO+WorkIt->EE8_SEQUEN))
               While !WorkEm->(Eof()) .And. WorkEm->(EEK_PEDIDO+EEK_SEQUEN)==;
                                            M->EE7_PEDIDO+WorkIt->EE8_SEQUEN
                  WorkEm->(dbDelete())
                  WorkEm->(dbSkip())
               Enddo
             
               If WorkIt->EE8_RECNO # 0

                  //AADD(aDeletados,WorkIt->EE8_RECNO) nopado por WFS
                  //Tratamento para deleção quando a rotina de grade está habilitada
                  If lGrade
                     EE8->(DBSetOrder(1)) //EE8_FILIAL + EE8_PEDIDO + EE8_SEQUEN + EE8_COD_I
                     cCpoCont:= WorkIt->EE8_COD_I

                     If MatGrdPrrf(@cCpoCont)
                        nLinAcols:= Val(WorkIt->EE8_SEQUEN)
                        For nLinha:= 1 To Len(oGrdExp:aColsGrade[nLinAcols])
                           For nColuna:= 2 To Len(oGrdExp:aHeadGrade[nLinAcols])

                              cProdGrd:= oGrdExp:GetNameProd(cCpoCont, nLinha, nColuna)

                              //Verifica se o registro existe na base.
                              If EE8->(DBSeek(xFilial() + WorkIt->EE8_PEDIDO + WorkIt->EE8_SEQUEN + cProdGrd)) .And.;
                                 !Empty(EE8->EE8_ITEMGR)

                                 AAdd(aDeletados, EE8->(RecNo()))
                              EndIf


                           Next
                        Next
                     Else
                        AAdd(aDeletados, WorkIt->EE8_RECNO)
                     EndIf
                  Else
                     AAdd(aDeletados, WorkIt->EE8_RECNO)
                  EndIf                  
               EndIf
            
               //** By JBJ - 14/06/2002 - 08:50 
               If lConvUnid
                  M->EE7_PESLIQ -= AvTransUnid(WorkIt->EE8_UNPES,If(!Empty(M->EE7_UNIDAD),M->EE7_UNIDAD,"KG"),WorkIt->EE8_COD_I,WorkIt->EE8_PSLQTO,.F.)
                  M->EE7_PESBRU -= AvTransUnid(WorkIt->EE8_UNPES,If(!Empty(M->EE7_UNIDAD),M->EE7_UNIDAD,"KG"),WorkIt->EE8_COD_I,WorkIt->EE8_PSBRTO,.F.)
               Else
                  M->EE7_PESLIQ -= Workit->EE8_PSLQTO
                  M->EE7_PESBRU -= WorkIt->EE8_PSBRTO
               EndIf
            
               M->EE7_TOTPED -= WorkIt->EE8_PRCTOT
               M->EE7_TOTITE--
            
               If EECFlags("COMISSAO")
                  If !Empty(WorkIt->EE8_CODAGE)               
                     cOldCodAg := WorkIt->EE8_CODAGE
                  EndIf
               EndIf
            
               WorkIt->(DBDELETE())
               
               If lConsolida .and. !lConsolItem
                  If WorkGrp->(!EOF()) .and. WorkGrp->(!BOF())
                     WorkGrp->(DbDelete())
                  EndIf
               EndIf
               
               If !lEE7Auto
                  AP100TTELA(.F.)
               EndIf
               IF cStatus == ST_CL
                  lAlteraStatus := .t.
               Endif
               // LCS.18/05/2006.17:28
               If ExistBlock("EECAP100")
                  ExecBlock("EECAP100",.F.,.F.,{"DEL_WORKIT"})
               EndIf

               // FJH 06/02/06
               If GetMV("MV_AVG0119",,.F.) .and. EE8->(FieldPos("EE8_DESCON")) > 0
                  EECCALCDESC("P")
               Endif

               //** By JBJ - 10/06/2003 - 10:51 (Atualizar o total de comissão para o agente.)
               If EECFlags("COMISSAO")
                  If !Empty(cOldCodAg)
                     EECTotCom()
                  EndIf
               EndIf 
               
               If lConsolItem
                  AuxIt->(DbSkip())
               Else
                  Exit
               EndIf
            EndDo
            
            If lConsolItem
               WorkGrp->(DbDelete()) // Apaga o registro da work de consolidação
            EndIf   
               
         EndIf
      EndIf

   End Sequence
 
   // JPM - 14/10/05
   If lConsolItem .And. !lRet .And. (nTipo == INC_DET .Or. nTipo == ALT_DET)
      Ap104AuxIt(4,.f.,.t.) //Restaura backup de variáveis de memória.
   EndIf

   dbselectarea(cOldArea)
   
Return lRet


//+-----------------------------------------------------------------------------------//
//|Funcao....: UZMarcDes()
//|Descricao.: Marca Itens
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function UZMarcDes()
*-----------------------------------------*

Local lMar := Iif(axItRoma[1,1],.F.,.T.)
Local i

For i := 1 To Len(axItRoma)
	axItRoma[i,1] := lMar
Next

oLbx1:SetArray(axItRoma)
oLbx1:bLine := bLine
oLbx1:Refresh()

Return Nil