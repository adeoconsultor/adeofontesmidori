#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"                                                                                                                                 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³          ³ Autor ³ Bruno M. Mota         ³ Data ³22/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Consultor de Neg ³Contato ³ bmassarelli@taggs.com.br       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
   ALEXANDRE DALPIAZ 20/04/2010   incluido centro de custo na gravação da nota - HDI 000013 - Marisangela - PCP
   ALEXANDRE DALPIAZ 30/04/2010   conforme conversa com Patricia (Fiscal) trazer sempre o CC 414 nas notas de transferencia
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/     

User Function MACOM01()
// Variaveis Locais da Funcao
Local cNumero	 := Space(9)
Local cSerie	 := Space(3)
Local cArmz		 := Space(2)
Local cCcusto	 := Space(6)
Local cPlano	 := Space(18)
Local oNumero
Local oSerie
Local oArmz
Local oCcusto
Local oPlano
Local cImpEt 	


// Variaveis Private da Funcao
Private oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.
// Privates das ListBoxes
Private aListBox1 := {}
Private nPosList	:= 0
Private oListBox1   
Private nOpc

Public cParSN := 'N'

//Monta interface com o usuário                                                             

DEFINE MSDIALOG oDlg TITLE "Pré-Nota de Entrada" FROM C(264),C(282) TO C(575),C(909) PIXEL   


	// Cria as Groups do Sistema
	@ C(003),C(003) TO C(202),C(360) LABEL "Dados da Nota de Origem" PIXEL OF oDlg

	// Cria Componentes Padroes do Sistema
	@ C(013),C(008) Say "Série:" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(013),C(030) MsGet oSerie Var cSerie Size C(021),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(013),C(056) Say "Número:" Size C(025),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(013),C(080) MsGet oNumero Var cNumero Size C(060),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg

	@ C(028),C(008) Say "Armazém:" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(028),C(030) MsGet oArmz Var cArmz Size C(021),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ C(028),C(056) Say "C. Custo:" Size C(025),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(028),C(080) MsGet oCcusto Var cCcusto Size C(060),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg	F3 "CTT"  
	@ C(013),C(170) Say "Conferência:" Size C(080),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(013),C(200) MSCOMBOBOX oComboBox VAR cImpEt ITEMS {"NAO","SIM"} SIZE C(040),C(060) PIXEL OF oDlg
	
	@ C(028),C(170) Say "Plano:" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(028),C(185) MsGet oPlano Var cPlano Size C(061),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg

	DEFINE SBUTTON FROM C(028),C(250) TYPE 1 ENABLE OF oDlg ACTION {|| IIf(ValidMark() .And. ValidCcArm(cArmz,cCcusto),Eval({||nOpc := 1,oDlg:End()}),nOpc := 2)}
	DEFINE SBUTTON FROM C(028),C(280) TYPE 2 ENABLE OF oDlg ACTION {||nOpc := 2,oDlg:End()}

	// Cria ExecBlocks dos Componentes Padroes do Sistema
	oNumero:bValid := {||IIf(Empty(cNumero),.F.,.T.)}

	// Chamadas das ListBox do Sistema
	fListBox1()
	
	//Caso pertencer as filiais 01 ou 18 ignora entrada de armazem e CC
	If Alltrim(cFilAnt) $ '01|18'
		oArmz:Disable()
		oCcusto:Disable()
	endif

ACTIVATE MSDIALOG oDlg CENTERED

//Verifica a opção do usuário
If nOpc == 1
	//Descobre qua filial foi solucionada
	nPosList := aScan(aListBox1,{|x| x[1] == .T.})
	//Inicia processamento da rotina
	Processa({||AtuSF1(cSerie,cNumero,cArmz,cCcusto,cImpEt,cPlano)})
Else
	//Menssagem de saída da rotina
	Alert("Processamento cancelado pelo usuário")
EndIf
//Retorno da funcao
Return(.T.)
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Rotina responsavel por atualizar os registros nas ³
//³tabelas SF1 e SD1                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
Static Function AtuSF1(cSerie,cNumero,cArmz,cCcusto,cImpEt,cPlano)
//Variaiveis locais da rotina
Local aItens 	:={}
Local cAmLocal	:= cArmz
Local cCC := cCcusto
Local cStatCon := ''


//Variaveis privadas
Private lMsErroAuto := .F.
//Inicio da funcao
//Seta um tamanho de regua baseado no numero de atividades da rotina

ProcRegua(5)
//Aumenta a regua
IncProc("Gerando arquivo temporario...")
//Query de busca de dados

If Select('TMP') > 0
	dbSelectArea('TMP')
	dbClosearea()
endif

beginSql Alias "TMP"
%NoParser%
SELECT
	SF2.F2_DOC,
	SF2.F2_SERIE,
	SF2.F2_CLIENTE,
	SF2.F2_LOJA,
	SF2.F2_COND,
	SF2.F2_EMISSAO,
	SF2.F2_DESCONT,
	SD2.D2_ITEM,  
	SD2.D2_COD, 
	SD2.D2_QUANT,
	SD2.D2_PRCVEN,
	SD2.D2_CCUSTO,
	SD2.D2_TOTAL ,
	SD2.D2_FCICOD,
	SF2.F2_CHVNFE
FROM
	SF2010 SF2
		INNER JOIN SD2010 SD2
		ON SF2.F2_DOC = SD2.D2_DOC AND
		SF2.F2_SERIE = SD2.D2_SERIE
WHERE
	SF2.F2_SERIE = %exp:cSerie% AND
	SF2.F2_DOC = %exp:cNumero% AND
	SF2.F2_CLIENTE IN ('000001','000148') AND
	SF2.F2_FILIAL = %exp:aListBox1[nPosList][2]% AND
	SD2.D2_FILIAL = %exp:aListBox1[nPosList][2]% AND
	SF2.%NotDel% AND
	SD2.%NotDel% 
ORDER BY
	SD2.D2_ITEM   //Ordenado por Item para que a nota fiscal de entrada na filial de destino
				  //tenha a mesma ordem da nota fiscal de origem, facilitando a conferencia na classificacao.
EndSql
//	SF2.F2_TIPO = 'B' AND
//Verifica se a query retornou alguma coisa	
If !TMP->(EoF())
	//Posiciona no primeiro item da temporaria
	TMP->(dbGoTop())
	//Adiciona regsitro
	IncProc("Criando numeração da pré-nota...")
	//Pega proximo numero da SF1
//	cDocNum := GetSX8Num("SF1","F1_DOC")
//	Monta cabeçalho da pre nota
	/*aCab := {{"F1_FILIAL"		,xFilial("SF1")							,NIL},;
				{"F1_TIPO"		,'N'									,NIL},;
				{"F1_DOC"		,cNumero								,NIL},;
				{"F1_SERIE"		,cSerie									,NIL},;
				{"F1_EMISSAO"	,StoD(TMP->F2_EMISSAO)					,NIL},;
				{"F1_FORNECE"	,'000148'    							,NIL},;
				{"F1_LOJA"	   ,aListBox1[nPosList][2]  			   	,NIL},;
				{"F1_FRETE" 	,0 								    	,NIL},;
				{"F1_ESPECIE"	,'NFF'						    		,NIL},;
				{"F1_COND"		,'001'									,NIL}}*/                 
      
//     Alterado por Humberto Garcia para que as notas sejam carregadas com a especie SPED, tendo em vista a entrada da NFe
	  //AOliveira - Realizado inclusão dos campos F1_CHVNNFE e F2_CHVNFE.
	  If cImpEt == 'SIM'                                        
	  //Cancela conferencia transf. PNP2->BRB - Solicit. Thiago
	  // Diego 20/09/2018
	  	If TMP->F2_CLIENTE = '000001' .And. TMP->F2_LOJA $ '19' 
	  		cStatCon := '1'                                                                        
	  	Else 
			cStatCon := '0'                                                                        	  	
	  	Endif
	  Else
	  	cStatCon := ''
	  EndIf	 
	  
      aCab := {{"F1_FILIAL"		,xFilial("SF1")							,NIL},;
				{"F1_TIPO"		,'N'						 			,NIL},;
				{"F1_DOC"		,cNumero								,NIL},;
				{"F1_SERIE"		,cSerie									,NIL},;
				{"F1_EMISSAO"	,StoD(TMP->F2_EMISSAO)					,NIL},;
				{"F1_FORNECE"	,'000148'    							,NIL},;
				{"F1_LOJA"	    ,aListBox1[nPosList][2]  			   	,NIL},;
				{"F1_FRETE" 	,0 								    	,NIL},;
				{"F1_ESPECIE"	,'SPED'						    		,NIL},;
				{"F1_CHVNFE"	,TMP->F2_CHVNFE				    		,NIL},;
				{"F1_STATCON"	,cStatCon					    		,NIL},;
				{"F1_DESCONT"	,TMP->F2_DESCONT			    		,NIL},;
				{"F1_COND"		,'001'									,NIL}}   
				
	//Processa loop de itens da pre-nota
	While !TMP->(EoF())
        //Ajusta regua                                	
		IncProc("Ajustando array...")
	    //Adiciona itens da pre-nota
	    If Alltrim(cFilAnt) $ '01|18'
		    cAmLocal := IIf(cFilAnt == "10",IIf(Posicione("SZ1",1,xFilial("SZ1")+TMP->D2_COD,"Z1_LOCAL") <> '  ', Posicione("SZ1",1,xFilial("SZ1")+TMP->D2_COD,"Z1_LOCAL"), Posicione("SB1",1,xFilial("SB1")+TMP->D2_COD,"B1_LOCPAD")),Posicione("SB1",1,xFilial("SB1")+TMP->D2_COD,"B1_LOCPAD")) //Comentado por Vinicius para nova tratativa de armazem e c. custo
		endif
		//cAmLocal := cArmz
	    //***********************************************************************
	    // Incluido por Sandro Albuquerque em 27/01/11 - Conforme solicitação do 
	    // usuário Mauri Help Desk: ???????
	    ///*********************************************************************
	    If Alltrim(cFilAnt) $ '01|18'
	       cCC := '410205'
/*	    Else 
//	       cCC := '312' // RETIRADO POR ANESIO CFE SOLICITACAO DO SR.MAURI PARA REMODELAR OS LANCAMENTOS 
						// EM CENTRO DE CUSTOS DAS UNIDADES 

			cCC := cCcusto
*/
	    Endif          
	    // Até Aqui 
	    //**********************************************************************
		AAdd(aItens,{{"D1_COD"			,TMP->D2_COD						,NIL},;
						{"D1_QUANT"		,TMP->D2_QUANT						,NIL},;
						{"D1_VUNIT"		,TMP->D2_PRCVEN						,NIL},;
						{"D1_LOCAL"		,cAmLocal							,NIL},;						
						{"D1_TOTAL"		,TMP->D2_TOTAL						,NIL},;
						{"D1_FCICOD"	,TMP->D2_FCICOD						,NIL},;
						{"D1_CC"   		,cCC            					,NIL},;
						{"D1_LOTEFOR"	,cPlano            					,NIL}})
		//Muda de registro
		TMP->(dbSkip())                       
	EndDo
    //Ajusta regua
	IncProc("Gerando pré-nota...")
    
    //Executa a execauto
	MSExecAuto({|x,y,z| MATA140(x,y,z)},aCab,aItens,3)
    //Verifica se houve erro
	If lMsErroAuto
		//Mostra erro
		MostraErro()
		//Volta numeracao da SF1
//	   	RollBackSX8()
	   	//Sai da rotina
		Return()
	EndIf      
	
	// imprime etiquetas
	If cImpEt == 'SIM'	
		cParSN:='S'
		U_EtqAcd(cPlano,cParSN)
	Else
		cParSN:='N'
		U_EtqAcd(cPlano,cParSN)
	Endif
	
    //Confirma numeracao da SF1
//	ConfirmSX8()
	//Aviso do numero da pre-nota criada
	Alert("Pré-Nota: "+cSerie+" - "+StrZero(Val(cNumero),9)+" criado.")
	//Fecha tabela temporaria
	if Select('TMP') > 0
		TMP->(dbCloseArea())
	endif
	
Else
	//Mensagem de erro    -
	Alert("A pesquisa não encontrou nenhum documento. Por favor, revise os parametros.")
EndIf		
//Sai da rotina
Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³fListBox1() ³ Autor ³ Bruno M. Mota         ³ Data ³22/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Montagem da ListBox                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fListBox1()
Local oOk 	   := LoadBitmap( GetResources(), "LBOK"       )
Local oNo 	   := LoadBitmap( GetResources(), "LBNO"       )
//Local aSelFil  := MatFilCalc()
	// Carrega array da Listbox
	//Posiciona sigamat
	dbSelectArea("SM0")
    //Primeiro registro do sigamat
	dbGotop()
	//Loop de processamento
	While ! SM0->(Eof())
		If Alltrim(SM0->M0_CODFIL) $ '01|08|09|19'
			//Adiciona registro no array
			Aadd(aListBox1,{.F.,SM0->M0_CODFIL,SM0->M0_NOME+" - "+SM0->M0_FILIAL})
			//Muda de registro
			SM0->(dbSkip())
		Else	
			SM0->(dbSkip())
	   	EndIf	
	EndDo

	@ C(041),C(008) ListBox oListBox1 Fields ;
		HEADER "","Filial","Nome";
		Size C(278),C(110) Of oDlg Pixel;
		ColSizes 70,70;
	On DBLCLICK (	aListBox1[oListBox1:nAt,1] := !(aListBox1[oListBox1:nAt,1]),oListBox1:Refresh())
	oListBox1:SetArray(aListBox1)

	// Cria ExecBlocks das ListBoxes
	oListBox1:bLine 		:= {|| {;
	If(aListBox1[oListBox1:nAT,1],oOk,oNo),;
		aListBox1[oListBox1:nAT,02],;
		aListBox1[oListBox1:nAT,03]}}

Return Nil
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@¿
//³Funcao que valida a escolha das filiais pelo usuario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@Ù
ENDDOC*/
Static Function ValidMark()
//Variaveis locais
Local nOk 	:= 0
Local lRet 	:= .T.
Local nX
//loop de processamento
For nX := 1 To Len(aListBox1)
	//verifica se a filial foi selecionada
	If aListBox1[nX][1] == .T.
		//adiciona o total de filiais selecionadas
		nOk = nOk + 1
	EndIf
Next nX
//caso tenha selecionado mais que uma filial ou nenhuma
If nOk <> 1
	//não permite a confirmação para processamento
	lRet := .F.
	//mensagem de erro
	Alert("É necessário selecionar uma e apenas uma filial por processamento.")
Endif
//Retorno da rotina
Return (lRet)   

////////////////////////////////////////////////////////////////////////////////
//Funcao para validação de preenchimento de CC e Armazem
//Desenvolvida por Vinicius Schwartz - TI - Midori Atlântica
//Em 22/05/2013
///////////////////////////////////////////////////////////////////////////////

Static Function ValidCcArm(cArmz,cCcusto)
lRet := .T.

//Valida preenchimento do armazem
If Empty(cArmz) .And. !Alltrim(cFilAnt) $ '01|18'
	Alert ('Favor preencher o campo Armazem!')
	lRet := .F.
	Return lRet
endif
//Valida preenchimento do C de custo
If Empty(cCcusto) .And. !Alltrim(cFilAnt) $ '01|18'
	Alert ('Favor preencher o campo C. de Custo!')
	lRet := .F.
	Return lRet
endif	

Return(lRet)    

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
/*Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima */
		nTam *= 1.28
//	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para tema "Flat"³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)
