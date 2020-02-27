#INCLUDE "PROTHEUS.CH"

		#define STR0001 "Importacao de Valores Variaveis"
		Static STR0002 := "Esta rotina importa valores para os arquivos de Movimentacao Mensal,"
		#define STR0003  "Confirma"
		#define STR0004  "Redigita"
		Static STR0005 := "Abandona"
		#define STR0006  "Continua"
		Static STR0007 := "Abandona"
		Static STR0008 := "Este programa Importa lancamento de Valores Variaveis "
		Static STR0009 := "Codigo nao cadastrado"
		Static STR0010 := "Valores Extras e 13o Salario, conforme definido no Parametro 02     "
		Static STR0011 := "Condicao do codigo "
		Static STR0012 := "nao esta retornando valor logico"
		Static STR0013 := "Condicao: "
		Static STR0014 := "Formula Invalida"
		Static STR0015 := "Campo Filial: "
		Static STR0016 := "Campo Matricula: "
		Static STR0017 := "Funcionario nao cadastrado"
		#define STR0018  "Linha: "
		Static STR0019 := "Campo C.Custo: "
		Static STR0020 := "Campo Verba: "
		Static STR0021 := "Verba nao cadastrada"
		Static STR0022 := "Filial+Verba: "
		Static STR0023 := "Campo Tipo da Verba: "
		Static STR0024 := "Campo Horas: "
		Static STR0025 := "Campo Valor: "
		Static STR0026 := "Campo Semana: "
		Static STR0027 := "Campo Parcela: "
		Static STR0028 := "Funcionarios Importados"
		Static STR0029 := "Linha  Matricula                             Verba                     Horas          Valor Semana Parcela Data Pagto"
		Static STR0030 := "Invalido "
		Static STR0031 := "Nenhum registro atendeu a condicao de filtro"
		Static STR0032 := "Campo Data "
		Static STR0033 := "Funcionario Demitido "
		Static STR0081 := "Campo Matricula "
		Static STR0067 := "Linha "

#Define nColTam  20  // Tamanho limite para conteudo de impressao
#Define nColSpc  3   // Coluna de espacamento entre registros impressos
#Define nLimImp  9 // Limite de campos para impressao

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao      ³ GPEA210  ³  Autor  ³ Raquel Hager            ³ Data ³  18/06/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao   ³ Importacao de Variaveis                                  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso         ³ Generico                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³ FNC          ³ Motivo da Alteracao                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Raquel Hager³18/06/2013³M12RH01  RQ006³Unificacao da Folha de Pagamento.	      ³±±
±±³Raquel Hager³21/10/2013³M12RH01  RQ006³Correcao para captura de perguntes.     ³±±
±±³Alberto M   ³17/10/2014³TQUTLF        ³Tratamento para importação da SRK.      ³±±
±±³Alberto M   ³20/10/2014³TQUTLF        ³Inclusão de STR0084 e ajuste no LOG     ³±±
±±³            ³          ³              ³quando a importacao e da tabela SRK.    ³±±
±±³Alberto M   ³30/10/2014³TQUTLF        ³Inclusao das funcoes gpa210ClcParc e    ³±±
±±³            ³          ³              ³gpa210VldSRK e alteracao no calculo do  ³±±
±±³            ³          ³              ³numero de linhas do arquivo lido.       ³±±
±±³Alberto M   ³06/11/2014³TQUTLF        ³Inclusao da validacao do cmpo RK_NUMPAGO³±±
±±³            ³          ³              ³e alteracao na geracao do log para SRK  ³±±
±±³Henrique V. ³01/06/2015³TSHXST        ³Ajustada função GP210SXB() para que as  ³±±
±±³            ³          ³              ³linhas da consulta padrão não possam ser³±±
±±³            ³          ³              ³alteradas, uma vez que a consulta padrão³±±
±±³            ³          ³              ³serve somente para consulta e seleção.  ³±±
±±³Flavio C.   ³28/07/2015³TSXYOW        ³Ajustada tamanho do arq de leitura      ³±±
±±³Allyson M   ³14/10/2015³TTMBH1        ³Ajuste na importacao dos lanctos. da RHO³±±
±±³Esther V.   ³16/03/2015³		TUSGTC	 ³Ajuste na funcao fVldLanc para gerar	  ³±±
±±³			   ³		  ³				 ³corretamente a sequencia das verbas.	  ³±±
±±³Raquel Hager³12/05/2016³TUWJDM        ³Criacao da funcao GPA21WHEN e remocao da³±±
±±³            ³          ³              ³impressão da variável cTitImpress.      ³±±
±±³Raquel Hager³30/05/2016³TVGSTO        ³Gravacao da Data de Referencia de acordo³±±
±±³            ³          ³              ³com o cad. de Sindicato quando importar ³±±
±±³            ³          ³              ³para roteiro de PLR.                    ³±±
±±³Gabriel A.  ³16/06/2016³TVHVBZ        ³Ajuste para gravação do valor correta-  ³±±
±±³            ³          ³              ³mente.                                  ³±±
±±³P. Pompeu...|17/06/2016|TVKQ43        |Adição do campo DTREF para Valores Futur³±±
±±³P. Pompeu...|21/06/2016|TVLMRL        |Melhoria no controle das mensagens de log±±
±±³P. Pompeu...|01/07/2016|TVNIOH        |Importacao de demitidos para SRK         ±±
±±³Gabriel A.  ³14/09/2016³TVUNLK        ³Ajuste na importação de TXT sem marcação³±±
±±³            ³          ³              ³de final de linha (enter).              ³±±
±±³Cícero Alves³14/10/2016³TVRWRT        ³Alteração dos grupos de perguntas usados³±±
±±³            ³          ³              ³na rotina.							  ³±±
±±³Gabriel A.  ³08/12/2016³99632         ³Ajuste na importação de registros com a ³±±
±±³            ³          ³MRH-832       ³mesma verba, mas com centro de custo    ³±±
±±³            ³          ³              ³diferente.                              ³±±
±±³Eduardo K.  ³02/03/2017³MPRIMESP-9226 ³Ajuste para executar corretamente a con-³±±
±±³            ³          ³		         ³dição cadastrada no leiaute.			  ³±±
±±³Paulo O     ³24/03/2017³MRH-8447      ³Correção da posição do preenchimento    ³±±
±±³Inzonha     ³          ³		         ³da variavel (cAliasArq) devido a errolog³±±
±±³Eduardo K.  ³09/06/2017³MPRIMESP-10281³Ajuste na importação de TXT para        ³±±
±±³            ³          ³		         ³contrib. individual semanal ou mensal.  ³±±
±±³Cecilia C.  ³30/06/2017³DRHPAG-3738   ³Alteração para que a rotina faça a veri-³±±
±±³            ³          ³              ³cação do campo RHO_COMPPG.              ³±±
±±³Cecilia C.  ³23/08/2017³DRHPAG-5375   ³Ajuste para não permitir importação quan³±±
±±³            ³          ³              ³do já exite uma parcela paga no SRK.    ³±±
±±³Rafael R.   ³25/10/2017³DRHPAG-6866   ³Ajuste para verificação de condição de  ³±±
±±³            ³          ³              ³importação linha a linha				  ³±±
±±³Jose Glez.  ³25/10/2017³TSSERMI01-188 ³Ajuste para localizar las variables     ³±±
±±³            ³          ³              ³cEmpConsSRK donde se asigna un campo    ³±±
±±³            ³          ³              ³especifico para Brazil                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function UGPEA210 ()     
Local aSays		:= {}
Local aButtons	:= {}	
Local aPerg1	:= {}
Local aPerg2	:= {}  
Local aPerg3	:= {}
Local nOpca 	:= 0

Private cPerg1		:= "GPE210A"	// Gp. perguntas sobre a importacao  
Private cPerg2		:= "GPE210B"	// Gp. perguntas especifico RGB
Private cPerg3		:= "GPE210C"	// Gp. perguntas especifico RHO
Private cProcesso	:= ""			// Variavel utilizada na funcao gpRCHFiltro() Consulta Padrao - 1 = Periodos Abertos
Private cCond		:= "1"			// Variavel utilizada na funcao gpRCHFiltro() Consulta Padrao - 1 = Periodos Abertos
Private cRot		:= ""
Private lItemClVl   := SuperGetMv( "MV_ITMCLVL", .F., "2" ) $ "1*3" // Define se trabalha com item e classe contabil
Private cDigHoras	:= SuperGetMv("MV_HORASDE")	// Define se os lançamentos serão feitos em horas e deverão ser convertidos.

Private lDemPSrk	:= .F.
Private lDtRefSRK	:= (aScan(SRK->(DbStruct()),{|x|AllTrim(x[1]) == "RK_DTREF"}) > 0) 
Private aGravaSRK	:= {}       //Array auxiliar na importacao para SRK.  
								 //{TRP->FILIAL + TRP->MAT + TRP->PD,RK_CC,RK_PROCES,RK_JUROMES,RK_VALORPA,RK_VALORAR,;
								 // RK_VLJUROS,RK_PCJUROS,RK_EMPCONS,RK_DOCUMEN}
								    
//Verifica se exite o grupo de perguntas GP210AR1 
DBSelectArea("SX1")
DBSetOrder(1)
If DBSeek("GP210AR1")
	cPerg1 := "GP210AR1"	  
	cPerg2 := "GP210BR1"
	cPerg3 := "GP210CR1"
EndIf
 
	If !(IsBlind() )
		cCadastro := "Importacao de Variaveis"
	   	aAdd(aSays,"Esta rotina importa valores para os seguintes arquivos" + CRLF )
	   	aAdd(aSays,"RGB - Lançamentos " + CRLF )
	   	aAdd(aSays,"RHO - Co-Participacao e Reembolso " + CRLF )
	   	aAdd(aSays,"SRK - Movimento de Valores Futuros " + CRLF )
	   	aAdd(aSays,"SRC - Movimento Folha Mensal " + CRLF )
	   	aAdd(aSays,"Conforme definido na rotina de cadastro de Layout de Importacao." )
		                
		aAdd(aButtons, { 5,.T.,{|| aPerg := U210Perg(@aPerg1,@aPerg2,@aPerg3)  } } )
		aAdd(aButtons, { 1,.T.,{|o| nOpca := 1,If(UGpa210OK(),FechaBatch(),nOpca:=0) }} )
		aAdd(aButtons, { 2,.T.,{|o| FechaBatch() }} )
			
		FormBatch( cCadastro, aSays, aButtons )
	Else
		nOpca := 1
	EndIf
	
	If nOpca == 1                      
		 Processa({|lEnd| U210Proces(aPerg1,aPerg2,aPerg3),STR0001})   //"Importacao de Valores Variaveis"
	EndIf

Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±                                                                  
±±³Funcao    ³ Gpea210Perg ³ Autor ³ Equipe RH          ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Processa grupos de perguntas.							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA210                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function U210Perg(aPerg1,aPerg2,aPerg3)
Local aArea		:= GetArea()   
Local cAliasArq	:= ""
	
	Pergunte(cPerg1,.F.)	
	Pergunte(cPerg1,.T.)
	
	// Carregando variaveis mv_par??     
    AADD(aPerg1, {mv_par01,mv_par02,mv_par03,mv_par04})
    
    if(lDtRefSRK)
    	aAdd(aTail(aPerg1),mv_par05)
    endIf
     
    dbSelectArea( "RFJ" ) 
	dbSetOrder(1) // RFJ_FILIAL + RFJ_CODIGO +RFJ_TBDEST + RFJ_CPO
	If RFJ->(dbSeek( xFilial("RFJ") + mv_par02 ) ) 
		cAliasArq 	:= RFJ->RFJ_TBDEST
	Else
       	Help( " ",1,"A210NOPAR" ) // "Parametro Importacao de Variaveis nao cadastrado."      
	    Return
	EndIf  
      
	If cAliasArq == "RGB" .Or. cAliasArq == "SRC"
		Pergunte(cPerg2,.F.)  
		Pergunte(cPerg2,.T.)	  
		AADD(aPerg2,{mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06})		
	ElseIf cAliasArq == "RHO" 
   		Pergunte(cPerg2,.F.) 
		Pergunte(cPerg3,.T.)	  
		AADD(aPerg3,{mv_par01,mv_par02})	
	EndIf    
	
	RestArea(aArea)
	
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±                                                                  
±±³Funcao    ³ GPA210PROC ³ Autor ³ Equipe RH           ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Leitura Arquivo Texto e Gravacao no Arq. Valores Variaveis.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA210                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function U210Proces(aPerg1,aPerg2,aPerg3)
Local aAux		   		:= {}                    
Local cHelp     
Local cConteudo	   		:= ""   
Local cCodFil			:= ""
Local cFilPd			:= ""  
Local cCC				:= ""      
Local cItem				:= ""
Local cClvl				:= ""
Local cTblAuxSRK        := ""
Local cTpRotPLR			:= fGetCalcRot('F') // PLR
Local lFirstGrv			:= .T.  
Local lPula				:= .F.
Local lVerfCamp
Local tregs
Local m_mult     
Local nHandle
Local nBytes
Local nSize
Local nX
Local nY
Local nPosSind			:= 0
Local nPerSRK			:= 0
Local nSemSRK			:= 0
Local aAuxLay			:= {}
Local cMatSRK        	:= ""
Local cVerSRK        	:= ""
Local cPerSRK		    := ""
Local cSemSRK			:= ""

Private aCampos			:= {}	// Campos gravados no layout de impressao(RFJ)
Private aStru			:= {}	// Campos da estrutura = campos gravados no layout de impressao(RFJ) + adicionais a depender do alias destino  
Private aReg			:= {}	// Array com registros a serem importados que passaram pela validacao inicial
Private aRegSv			:= {}	// Copia de aReg
Private aTitle	   		:= {OemToAnsi("Titulo de log de importacao")}	// Titulo de log de importacao
Private aLog			:= {{}}	// Log de importacao    
Private aLogVld			:= {}	// Log de registros importados validos          
Private aRegSbr			:= {} 	// Array de registros sobrepostos e importados  - Pos 1 = Chave do registro  
Private aRgItCl			:= {}	// CC/Item/Cl do registro a ser importado quando alias dest for RGB
Private aSindMat		:= {} // Sindicato das matriculas processas
Private cTitImpres		:= ""	// Titulo de impressao 
Private cArq1			:= ""	// Arquivo da estrutura
Private dDataRef                
// Variaveis carregas nos perguntes
Private cArquivo
Private cCodigo   
Private cSituacao
Private cAliasArq
Private cNomeArq
Private cCondicao          
Private cTpLan		
Private cComPg	
Private lCond       	 := .T.
Private nSobrepoe   
Private nTotaliza 

//Variaveis auxiliares para importacao da SRK - Valores Futuros 
Private lVrbJurSRK  	 := .F. // Indica se o campo Verba Juros foi preenchido(Importacao SRK).                           
Private nVlTotSRK        := 0
Private nNumParcSRK      := 0
Private nJurAnoSRK       := 0
Private nJurMesSRK       := 0  
Private nValParSRK       := 0
Private nValResSRK       := 0
Private nValJurSRK       := 0
Private nPArcJurSRK      := 0
Private cCCSRK           := ""
Private cProcesSRK       := ""
Private cNumPagSRK       := ""
Private cEmpConsSRK      := ""

// OBSERVACAO IMPORTANTE
// Na inclusao de novos alias, incluir array com nomenclatura abaixo 'aCpsVld'+cAlias  
// 1- Posicao Matricula		3- Qtde de campos obrigatorios 
// 2- Posicao Verba			4- Indice a ser utilizado na gravacao 
// Utilizar posicoes seguintes para tratamentos especificos do alias destino
Private aCpsVldRGB		:= {,,3,"RGB_SEQ","RGB_DTREF","RGB_CC","RGB_ITEM","RGB_CLVL"} 	// Mat/Pd/Cpo Obrigat/Cpo Seq/Cpo Data/Cpo C.Custo/Cpo Item/Cpo Cl. Valor
Private aCpsVldRHO		:= {,,7,4,6}  // Mat/Pd/Cpo Obrigat
Private aCpsVldSRK		:= {,,10,5,"RK_PDJUROS","RK_VALORTO","RK_PARCELA","RK_PGJUROS","RK_REGRADS",;
								"RK_QUITAR","RK_EMPCONS","RK_POSTO","RK_PERINI","RK_HORAS","RK_JUROMES",;
								"RK_JUROANO","RK_DTMOVI","RK_DTVENC","RK_STATUS","RK_NUMPAGO"}   
Private aCpsVldSRC		:= {,,3,"RC_SEQ","RC_DTREF","RC_CC","RC_ITEM","RC_CLVL"}								
								
Private oRegGrv			:= tHashMap():New()

If(lDtRefSRK)
	aAdd(aCpsVldSRK,"RK_DTREF")
EndIf
     		 
	Begin Sequence    
	
		If Len(aPerg1) > 0 // Selecionou botao 'Ok' primeiro   
			cArquivo		:=	AllTrim(aPerg1[1][1])		// Nome do Aquivo Texto
			cCodigo			:= 	aPerg1[1][2]	   			// Codigo da Tabela da Importacao de variaveis
			nSobrepoe		:=  aPerg1[1][3] 				// Sobrepoe Lancamentos de mesma verba 
			cSituacao		:=  aPerg1[1][4] 				// Situacoes
			if(lDtRefSRK)				
				dDataRef	:=  IIF(Empty(aPerg1[1,5]),dDatabase,aPerg1[1,5])// Data de Referência
			endIf			
		Else // Selecionou botao 'Paramentos' primeiro 
		  	Pergunte(cPerg1,.F.)
			cArquivo		:=	mv_par01		// Nome do Aquivo Texto
			cCodigo			:= 	mv_par02	   	// Codigo da Tabela da Importacao de variaveis
			nSobrepoe		:=  mv_par03 		// Sobrepoe Lancamentos de mesma verba 
			cSituacao		:=  mv_par04 		// Situacoes
			if(lDtRefSRK)			
				dDataRef	:=  IIF(Empty(mv_par05),dDatabase,mv_par05)		//Data de Referência
			endIf
	    EndIf 
	    	   
    	If Len(aPerg2) > 0  // Selecionou botao 'Ok' primeiro                                                     
			cProcesso		:= 	aPerg2[1][1]	// Processo a importar
			cRoteiro		:= 	aPerg2[1][2]	// Periodo para o qual sera importado
			cPeriodo		:=	aPerg2[1][3]	// Numero de Pagamento para o qual sera importado
			cNroPago		:= 	aPerg2[1][4]	// Roteiro de Calculo
			nTotaliza		:= 	aPerg2[1][5]	// Totaliza lancamento
			lDemPSrk 		:= IIF(Empty(aPerg2[1,6]),.F.,(aPerg2[1,6] == 1))						
		Else// Selecionou botao 'Paramentos' primeiro   
		  	Pergunte(cPerg2,.F.)
			cProcesso		:= 	mv_par01		// Processo a importar
			cRoteiro		:= 	mv_par02		// Roteiro de Calculo
			cPeriodo		:= 	mv_par03		// Periodo para o qual sera importado
			cNroPago		:=	mv_par04		// Numero de Pagamento para o qual sera importado			
			nTotaliza		:=  mv_par05		// Totaliza lancamento
			lDemPSrk 		:= IIF(Empty(MV_PAR06),.F.,(MV_PAR06 == 1))		
		EndIf 	

		If Len(aPerg3) > 0 // Selecionou botao 'Ok' primeiro   
			cTpLan		:=	cValtoChar(aPerg3[1][1])	// Tipo de Lancamento 1=Co-particip./2=Reembolso
			cComPg		:= 	aPerg3[1][2]	   					// Mes competencia de pago
		Else // Selecionou botao 'Paramentos' primeiro 
			Pergunte(cPerg3,.F.)
			cTpLan		:=	cValtoChar(mv_par01)	// Tipo de Lancamento 1=Co-particip./2=Reembolso
			cComPg		:= 	mv_par02	   			// Mes competencia de pago
	    EndIf
	
		dbSelectArea( "RFJ" ) 
		dbSetOrder(1) // RFJ_FILIAL + RFJ_CODIGO +RFJ_TBDEST + RFJ_CPO
		If RFJ->(dbSeek( xFilial("RFJ") + cCodigo ) ) 
			cAliasArq 	:= RFJ->RFJ_TBDEST
			cNomeArq  	:= RFJ->RFJ_DESC
			cCondicao	:= RFJ->RFJ_COND
	    Else                                                                          
	       	Help( " ",1,"A210NOPAR" ) // "Parametro Importacao de Variaveis nao cadastrado."      
		    Return
		EndIf 
	
		
	  	If cAliasArq == "RGB" .Or. cAliasArq == "SRC"
		  	If !( fPosPeriodo( Nil, cProcesso, cPeriodo, cNroPago, cRoteiro, Nil, Nil, 3 ) )
				cHelp := OemToAnsi("O Periodo Informado nos Parametros nao existe ou ja foi fechado!")			// "O Periodo Informado nos Parametros "
				cHelp += CRLF + OemToAnsi("Item contabil invalido ou nao preenchido.")	// "nao existe ou ja foi fechado! "
				Help(" ", 1, "NOISPER",,cHelp,1,0 )// "Item contabil invalido ou nao preenchido."
				Break			
			EndIf 
		EndIf
	
		If !File(cArquivo)
			Help(" ",1,"A210NOPEN") // "Nao foi possivel abrir o arquivo."
			Break
		EndIf   
			
		// Cria arquivo Temporario      
		UCria_Temp()
		
		// Abre arquivo texto informado 
		nHandle := fOpen( cArquivo ,64)
		If Ferror() # 0 .Or. nHandle < 0
		    Help(" ",1,"A210NOPEN")	// "Nao foi possivel abrir o arquivo."
		    Break
		EndIf
		
		aFile   := Directory( cArquivo )
		nSize   := aFile[1,2]
		
		TXT       := fReadStr( nHandle,nSize )
		cTXTCopia := TXT // Copia de TXT para verificar o numero de linhas
		nLinhas   := 0
		nBytes    := 0
		//Verifica o numero de linhas do arquivo.
		While (Len(cTXTCopia) # 0)
			nBytes := (At( CHR(13)+ CHR(10),cTXTCopia )) + 1
			cTXTCopia := SubStr(cTXTCopia , nBytes + 1 , len(cTXTCopia))
			nLinhas++
			If (nBytes == 1)
				Exit
			EndIf
		End
		
	
		cTXTCopia := TXT // Copia de TXT novamente
		nBytes := (At( CHR(13)+ CHR(10),TXT )) + 1 // Numero de Bytes da primeira linha
		
		fSeek( nHandle,0,0 )
				
		// Cria a Regua de processamento de registros              
		tregs = nLinhas-1
		m_mult=1
		If tregs > 0
		    m_mult=70/tregs
		EndIf
		
		// Posiciona SRA na Ordem 1  
		dbSelectArea("SRA")                                   
		SRA->(dbSetOrder(1))
	
		// Carrega Regua Processamento	                               
		ProcRegua(nLinhas)
		
		If cAliasArq == "SRK"
			nPerSRK := aScan(aCampos,{|x| x[1] == "RK_PERINI"})
			nSemSRK := aScan(aCampos,{|x| x[1] == "RK_NUMPAGO"})
		EndIf
		
		// PASSO 1 - Carregar todas as linhas do arquivo no array aReg
		For nX:= 1 To nLinhas
		
			// Move Regua Processamento	                                   
			IncProc("Importacao de Valores Variaveis" ) //"Importacao de Valores Variaveis" 
						
		    // Le cada linha do arquivo texto 
		    TXT := fReadStr( nHandle,nBytes )
		    
		    lCond := U210Form(cCondicao)
		    
		    If ValType( lCond ) # "L"				
				cLog := STR0011+cCodigo+" "+STR0012 // "Condicao do codigo "###"nao esta retornando valor logico"				
				UAddErrLog(STR0013+cCondicao, cLog, nX)
		 		Exit
			EndIf 
		    
		    //Linha satisfaz condição de gravação de registro
		    If lCond
		    	aAux 	:= {}  
				lPula	:= .F.
	     		lVerfCamp := .T.
	     		aAuxLay := AClone(aCampos)
	     		
	     		aSort(aAuxLay,,, { |x, y| x[3] > y[3] } )
				 //Verifica se a Linha preenchida completamente.
			    If(nBytes < aAuxLay[1][3])
			    	nY := 1 
			    	While(aCampos[nY][3] < nBytes)
			    		nY++ 	
			    	EndDo           		
		           	cLog := If(nY > 1 , "Não foi preenchido o campo" + "  " + aCampos[nY][6] , "Linha não foi preenchida")
		           	lPula:= .T.
		           	lVerfCamp := .F.
		           	UAddErrLog( "Erro", cLog, nX)
			    EndIf
				        
				cTXTCopia := SubStr(cTXTCopia,nBytes + 1,len(cTXTCopia)) // Atualiza cTXTCopia, removendo a linha que foi verificada.
			    nBytes    := (At( CHR(13)+ CHR(10),cTXTCopia )) + 1	// Calcula os Bytes da prox.linha
			    
				For nY := 1 to Len(aCampos)
					// Posicoes no array aCampos:
	                // 1- Campo         	// 5- Ordem		// 9- Sufixo
	                // 2- Pos. Inicial		// 6- Titulo
	                // 3- Pos.Final			// 7- Tipo
	                // 4- Formula 			// 8- Picture 
	                		  			 
				    If !Empty( aCampos[nY][4] ) .And. (aCampos[nY][2] == 0 .And. aCampos[nY][3] == 0)
						cErForm := U210Form(aCampos[nY][4])
						If cErForm == "ERRO" 
							cLog := "Formula Invalida" //						
							UAddErrLog(STR0081+aCampos[nY][6], cLog, nX)						 					
							lPula		:= .T.
							cConteudo	:= ""
						Else
							cConteudo	:= cErForm
						EndIf 
				    ElseIf (aCampos[nY][2] # 0 .And. aCampos[nY][3] # 0) .And. Empty( aCampos[nY][4] )
				    	   cConteudo := SubStr( TXT,aCampos[nY][2],aCampos[nY][3]-aCampos[nY][2]+1)
				    EndIf
			    		    		
		    		// Valida preenchimento de campo obrigatorio
		    		If (nY <= &("aCpsVld"+cAliasArq)[3] .And. Empty(cConteudo)) .And. lVerfCamp .And. UGPA21WHEN(cAliasArq,aCampos[nY][1],cConteudo,aCampos,TXT)
		    			cLog :=  STR0081+aCampos[nY][6] // Campo Matrícula : valor	    			
		    			UAddErrLog("Campo de preenchimento obrigatorio esta sem conteudo.", cLog, nX) //"Campo de preenchimento obrigatorio esta sem conteudo." 
		    			lPula:= .T.
						Exit
		        	EndIf
			        
			    	// Validacoes de campos especificos = MATRICULA/VERBA 
			    	If nY == 1 // Filial
			    		cCodFil	:= cConteudo 
			    	EndIf 
			    			 			    
			    	If nY == &("aCpsVld"+cAliasArq)[1] .And. lVerfCamp// Matricula   
			            dbSelectArea("SRA")
						SRA->(dbSetOrder(1))
						If SRA->(!dbSeek(cCodFil+cConteudo)) 	 
							cLog :=  "Funcionario nao cadastrado" + " - " + cConteudo 					
							UAddErrLog(AllTrim(Subs(TXT,1,Len(txt)-1)), cLog, nX)
							lPula:= .T. 
						ElseIf (SRA->RA_SITFOLH == "D")						
							If !(SRA->RA_SITFOLH $ cSituacao ) 
								cLog := "Funcionario Demitido" + " - " + cConteudo 
								UAddErrLog(Subs(TXT,1,Len(txt)-1), cLog, nX)						
								lPula:= .T.
							EndIf
						ElseIf !(SRA->RA_SITFOLH $ cSituacao ) 
							cLog := "Funcionario nao esta dentro da situacao escolhida." + " - " + cConteudo  
							UAddErrLog(Subs(TXT,1,Len(txt)-1), cLog, nX)
							lPula:= .T.
			  			ElseIf (cAliasArq $ "RGB|SRC" .And. SRA->RA_PROCES <> cProcesso )
							cLog := "Processo diferente do Informado." + " - " + cProcesso 						
							UAddErrLog(Subs(TXT,1,Len(txt)-1), cLog, nX) 
							lPula:= .T.
					  	ElseIf cAliasArq == "RGB|SRC"				  			
							If cRoteiro ==  cTpRotPLR // Se for roteiro de PLR
								nPosSind := aScan(aSindMat,{|x| x[1] == SRA->RA_FILIAL+SRA->RA_MAT})
								If nPosSind == 0
									AADD(aSindMat,{SRA->RA_FILIAL+SRA->RA_MAT,SRA->RA_SINDICA,""}) // Filial+Matrícula/Código Sindicato/Posição Resercada para Ano Ref. Cálculo
								EndIf	
							EndIf							
					    ElseIf cAliasArq == "RHO" 
				    		If !U210ComPg(SRA->RA_PROCES, SRA->RA_CATFUNC)
					    		cLog := "Competencia de Pagamento nao e igual ou maior a Competencia da Folha - Processo/Compet Pagto: " + SRA->RA_PROCES + " / " + cComPg
								UAddErrLog(cLog, "Competência Inválida", nX)
								lPula:= .T.
				    		EndIf
					    EndIf
					    
					    If cAliasArq == "SRK" 
				    		cCCSRK      := SRA->RA_CC     //Guarda Centro de Custo para futura Gravação.
				  			cProcesSRK  := SRA->RA_PROCES //Guarda Numero do Processo para futura Gravação.
				  			cMatSRK     := SRA->RA_MAT
				  			cPerSRK		:= If(nPerSRK > 0, AllTrim(aCampos[nPerSRK,4]),"")
				  			cSemSRK		:= If(nSemSRK > 0, AllTrim(aCampos[nSemSRK,4]),"01")
					    EndIf
	
				   		cCC		:= SRA->RA_CC 
				    	If lItemClVl
					   		cItem	:= SRA->RA_ITEM
					   		cClvl	:= SRA->RA_CLVL
						EndIf  		
	
					EndIf
	
			    	If nY == &("aCpsVld"+cAliasArq)[2] .And. lVerfCamp// Verba
						// Verifica no SRV se Existe a Verba  
						dbSelectArea("SRV")
						SRV->(dbSetOrder(1))
						cFilPd	:= xFilial("SRV",cCodFil)
						If !(SRV->(dbSeek(cFilPd+cConteudo)))
							cLog := "Verba nao cadastrada" + ": " + "Filial+Verba: " + " " + cFilPd + " - "+ cConteudo						
							UAddErrLog(Subs(TXT,1,Len(txt)-1), cLog, nX) 
							lPula:= .T.	 
							Exit													
					    EndIf
						// Se verba nao permite qtde de lanctos tambem nao importa.
					    If Val(SRV->RV_QTDLANC) == 0
							cLog := "A verba: " + cConteudo + " esta com o campo RV_QTDLANC igual a zero(0)" 
							UAddErrLog(Subs(TXT,1,Len(txt)-1), cLog, nX)  
							lPula:= .T.
					    EndIf
					    // Validacao da verba conforme valid do campo SRK_PD
					    If (cAliasArq == "SRK") .And. !IsLeePrest( Nil , cConteudo , Nil )
					   		cLog := "Valor do campo verba" + " " + cConteudo + "Invalido " 
							UAddErrLog(Subs(TXT,1,Len(txt)-1), cLog, nX)  
							lPula:= .T.
						Else
							If cPaisLoc == "BRA"
								cEmpConsSRK := SRV->RV_EMPCONS //Armazena Emp. Cons para gravar caso usuario nao tenha importado.
							EndIf
							cVerSRK     := SRV->RV_COD
							 	
						EndIf  					 
				    EndIf		 	
	
					//Validacoes exclusivas de Valores Futuros(SRK) 
					If (cAliasArq == "SRK") .And. lVerfCamp .And. !lPula
					    If nY == 3 
	                      //antes de consisitir os campos do arquivo, verificar se já existe alguma parcela paga 
	                      dbSelectArea("SRK")
	    			        SRK->(dbSetOrder(1))//Fil, Mat, Verb, CC.
	  				        If SRK->(dbSeek( xFilial("SRK",cCodFil) + cMatSRK + cVerSRK ) ) //Fil + Mat.		
	    				         If SRK->RK_PARCPAG > 0 .and. (Empty(cPerSRK) .or. cPerSRK == SRK->RK_PERINI) .and. (cSemSRK == SRK->RK_NUMPAGO)
	    				             UAddErrLog("","Problema desconhecido", nX)
	     				             lPula := .T.  
	 				             EndIf
	 				        EndIf
					    EndIf
	            	    If !lPula			
						     lPula := U210VldSRK(nY,nX,cConteudo,cCodFil,aAux)
						     If lPula
							      cLog := aCampos[nY][6] + ": " + cConteudo  + " Invalido "
							      UAddErrLog(Subs(TXT,1,Len(txt)-1), cLog, nX)
						     EndIf
						EndIf
					EndIf
	
				 	If lPula 
				 		Exit 
				 	Else			
						AADD(aAux, cConteudo ) 	// Inclui funcionario importado	 
					EndIf		        	 				                         
					    				                                    
			    Next nY 
			//Linha não satisfaz condição de gravação de registro
		    Else
				UAddErrLog("Linha não satisfaz condição de gravação de registro.","Linha não importada.",nX)  
				Loop
		    Endif  	
				    

		    
		    If(cAliasarq == "SRK")
		    	//Verificação do Juros Mes e Juros Ano.
				If(nJurMesSRK == 0 .And. nJurAnoSRK # 0)//Juros Mes em branco e Juros ano preenchido.
					//Calculo do Juro Mes atraves do Juros Ano baseado na funcao fJrAnoToMes(GPEA110).
					nJurMesSRK			:=(  1 + (  nJurAnoSRK/100 ) ) 
					nJurMesSRK			:=( (nJurMesSRK	** ( 1 / 12 ) )  - 1 ) * 100 					
				EndIf 
				//Cálculo do Valor das Parcelas.
				U210ClParc(nVlTotSRK , nNumParcSRK, nJurMesSRK, nX)
			EndIf
			
			// Grava no array principal onde estao todos os registros a serem importados.
			If lCond .And. !lPula .And. Len(aAux) == Len(aCampos)
				AADD(aReg,aAux)     
				
				//Grava informacoes da importacao SRK para o array auxiliar.
				If(cAliasArq == "SRK")
					AADD(aGravaSRK,{cCodFil + SRA->RA_MAT + SRV->RV_COD,cCCSRK, cProcesSRK, nJurMesSRK, nValParSRK,;
									  nValResSRK ,nValJurSRK, nPArcJurSRK, cEmpConsSRK})
				EndIf
				     
				If lItemClvl
					AADD(aRgItCl, { cCC,cItem,cClvl })
				Else
					AADD(aRgItCl, { cCC,"","" })
				EndIf
			Else
				Loop
			EndIf
			
			//Zera Juros Mes, Juros Ano e Num. Pgto quando troca de linha.			 
			If (cAliasArq == "SRK")
				nJurMesSRK   := 0 
				nJurAnoSRK   := 0 
				cNumPagSRK   := "" 
			EndIf
			
		Next nX
		
		//Importacao SRK - Ajustes e Validacao no campo RK_DOCUMEN.
		If(cAliasArq == "SRK") .And. Len(aReg) > 0
			dbSelectArea("SRK")
			SRK->(dbSetOrder(1))//Fil, Mat, Verb, CC.
			For nX := 1 to Len(aReg)
				cSRKDocumen := STRZERO(1,6)
				If SRK->(dbSeek( aReg[nX][1] + aReg[nX][2] ) ) //Fil + Mat.
					While (aReg[nX][2] == SRK->RK_MAT) //Verifica qual e o ultimo Nr.Documen da Tabela SRK para a matricula em questao.
						cSRKDocumen := If( ( Val(SRK->RK_DOCUMEN) >= Val(cSRKDocumen) ) , STRZERO( (Val(SRK->RK_DOCUMEN)+1) , 6) , cSRKDocumen)  
						SRK->(dbSkip())
					End
				EndIf
				
				If(nX > 1)
					nY := 1
					//Percorre os campos anteriores do aReg ate localizar o ultimo registro com a mesma matricula.
					While ((nX - nY) > 0)
						If(aReg[nX-nY][2] == aReg[nX][2])
							If(Val(cSRKDocumen) # (Val(aGravaSRK[nX-nY][10]) + 1))//Caso exista algum registro no aReg, atualiza o numero do documento.
								cSRKDocumen := STRZERO( ( Val(aGravaSRK[nX-nY][10] ) + 1) , 6 )
							EndIf
							Exit
						EndIf
						nY++
					End
				EndIf
				AADD(aGravaSRK[nX], cSRKDocumen)	
			Next nX	
		EndIf
	
		// Abre pergunte para correta captura de parametros
		// na funcao RetPergLog (dentro de fMakeLog em GPEXREL)
		Pergunte(cPerg1,.F.) 
			 		
		// PASSO 2 - Gravar no arquivo temporario e realizar validacoes 
		UGravaTRP()  
		
		// PASSO 3 - Gravar no alias destino o conteudo do arquivo temporario           
	 	UGrava210()  
	 	
	 	// PASSO 4 - Gerar Log 
	 	fGerarLog(.T.,.F.,0,0,"") 
	 	 
	 	If Len(aLog) == 0 
			cLog := "Condicao do codigo "+cCodigo // "Condicao do codigo			
			// "Nenhum registro atendeu a condicao de filtro do parametro"
			UAddErrLog("  "+STR0031+" => "+cCondicao, cLog, nX)
		EndIf 
		 	
	 	fClose(nHandle)
		                                                                  
		aSort(alog[1],,, { |x, y| SubStr(x,24,83) < SubStr(y,24,83) } )
		fMakeLog(aLog,aTitle,"GPE210A") // Log dos registros importados      
	End Sequence 
			
	// Se foi criado arquivo temporario de ser excluido    
	If ( Select( "TRP" ) > 0 )
		dbSelectArea("TRP")
		dbCloseArea()
		FErase(cArq1+GetDBExtension())
		FErase(cArq1+OrdBagExt())
	EndIf 

oRegGrv:Clean()
FreeObj(oRegGrv)

Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ Cria_Temp ³ Autor ³ Equipe RH            ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cria arquivo temporario e titulo de impressao.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ GPEA210   												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UCria_Temp()      
Local aArea		:= GetArea()       
Local cTitulo	:= ""
Local cCond		:= ""
Local nCont		:= 0       
Local nX		:= 0

	dbSelectArea( "RFJ" ) 
	dbSetOrder(1) // RFJ_FILIAL + RFJ_CODIGO + RFJ_TBDEST + RFJ_CPO
	If RFJ->(dbSeek( xFilial("RFJ") + cCodigo ) )  
		While RFJ->(!Eof()) .And. RFJ->RFJ_FILIAL == xFilial("RFJ") .And. RFJ->RFJ_CODIGO = cCodigo  
			AADD(aCampos,{AllTrim(RFJ->RFJ_CPO),RFJ->RFJ_POSINI,RFJ->RFJ_POSFIN,RFJ->RFJ_FORM, RFJ_ORDEM })
	   		nCont++
	   	RFJ->(dbSkip())
		End  
	EndIf    
	
	// Ordena array de acordo com campo 'Ordem'
	ASort(aCampos,,,{|x,y| x[5] < y[5]})
	
	If nCont > 0 
		dbSelectArea("SX3")
		DbSetOrder(2) //X3_CAMPO 
				
		For nX := 1 to Len(aCampos)
	   		If AllTrim(aCampos[nX][1]) == "RGB_MAT"
	   			aCpsVldRGB[1] := nX
	   		ElseIf AllTrim(aCampos[nX][1]) == "RGB_PD"
	   			aCpsVldRGB[2] := nX
	   		ElseIf AllTrim(aCampos[nX][1]) == "RHO_MAT"
	   			aCpsVldRHO[1] := nX
	   		ElseIf AllTrim(aCampos[nX][1]) == "RHO_PD"
	   			aCpsVldRHO[2] := nX
	   		ElseIf AllTrim(aCampos[nX][1]) == "RK_MAT"
	   			aCpsVldSRK[1] := nX
	   		ElseIf AllTrim(aCampos[nX][1]) == "RK_PD"
	   			aCpsVldSRK[2] := nX
	   		ElseIf AllTrim(aCampos[nX][1]) == "SRC_MAT"
	   			aCpsVldSRC[1] := nX
	   		ElseIf AllTrim(aCampos[nX][1]) == "SRC_PD"
	   			aCpsVldSRC[2] := nX	   			
	   		EndIf		 
			If SX3->(dbSeek( aCampos[nX][1] ) )		 							
				cCampo 	:= aCampos[nX][1]
				nPos	:= AT("_",cCampo)
				cSufixo := SUBSTR(cCampo,nPos+1,Len(cCampo))  
				AADD(aStru,{cSufixo,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})  					
				AADD(aCampos[nX],SX3->X3_TITULO )
				AADD(aCampos[nX],SX3->X3_TIPO)  
				AADD(aCampos[nX],SX3->X3_PICTURE)      
				AADD(aCampos[nX],cSufixo)
				// Inclui no titulo de impressao apenas qtde do limite de impressao
				If nX <= nLimImp  
					cTitulo	:= SX3->X3_TITULO
					cTitulo	:= SubStr(cTitulo+Space(nColTam-Len(cTitulo)),1,nColTam)
					cTitImpres += cTitulo+Space(nColSpc)
				EndIf 		 													 										
		    EndIf
		Next nX	     //"Linha  "
		cTitImpres:= STR0067 + cTitImpress	
		
		// ESPECIFICOS - INCIDENCIAS
		If cAliasArq == "RGB" .Or. cAliasArq == "SRC" 
			If SX3->(dbSeek( &("aCpsVld"+cAliasArq)[4] ) ) // Campo Sequencia 
				If aScan(aStru, {|x| x[1] == "SEQ"}) == 0 // Somente inclui se nao existir no layout 
					AADD(aStru,{"SEQ",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})  
				EndIf			 				
			EndIf    
			If SX3->(dbSeek( &("aCpsVld"+cAliasArq)[5] ) ) // Campo Data de Referencia
				If aScan(aStru, {|x| x[1] == "DTREF"}) == 0 // Somente inclui se nao existir no layout
					AADD(aStru,{"DTREF",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})  
				EndIf					
			EndIf  
				If SX3->(dbSeek( &("aCpsVld"+cAliasArq)[6] ) ) // Campo Centro de Custo
					If aScan(aCampos, {|x| x[9] == "CC"}) == 0 // Somente inclui se nao existir no layout
						AADD(aStru,{"CC",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})       
					EndIf					
				EndIf 
			If lItemClvl    
				If SX3->(dbSeek( &("aCpsVld"+cAliasArq)[7] ) ) // Campo Item 
					If aScan(aCampos, {|x| x[9] == "ITEM"}) == 0 // Somente inclui se nao existir no layout
						AADD(aStru,{"ITEM",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})  
					EndIf					
				EndIf 
				If SX3->(dbSeek( &("aCpsVld"+cAliasArq)[8] ) ) // Campo Classe de valor
					If aScan(aCampos, {|x| x[9] == "CLVL"}) == 0 // Somente inclui se nao existir no layout
						AADD(aStru,{"CLVL",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})   
					EndIf					
				EndIf 
			EndIf
		EndIf
		
		if(cAliasArq == "SRK" .And. lDtRefSRK)
			If SX3->(dbSeek( &("aCpsVld"+cAliasArq)[21] ) ) // Campo Data de Referencia
				If aScan(aStru, {|x| x[1] == "DTREF"}) == 0 // Somente inclui se nao existir no layout
					AADD(aStru,{"DTREF",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})  
				EndIf					
			EndIf	
		endIf 
		
		// Adiciona no final da estrutura campo que determina posicao no array aReg
		AADD(aStru,{"POSREG","N",5,0})
		AADD(aStru,{"OK","C",1,0})	

	EndIf   	
 	
	cArq1 	  	:= CriaTrab(aStru, .T. )
	dbUseArea(.T.,,cArq1,"TRP",.F.,.F.)     

 	If cAliasArq == "RHO"   
 		cCond := "FILIAL + MAT + DTOS(DTOCOR) + TPFORN + CODFOR + ORIGEM + CODIGO + PD" // Filial + Matricula + Dt. Ocorrencia + Tp. Forncedor + Cod. Fornecedor + Origem + Codigo + Verba
 	ElseIf cAliasArq == "RGB" .Or. cAliasArq == "SRC"
		If lItemClvl  
			cCond 	:= "FILIAL + MAT + PD  + CC + ITEM + CLVL"  // Filial + Matricula + Verba + C.Custo + Item + Cl. Valor  
   		Else
 			cCond 	:= "FILIAL + MAT + PD"  // Filial + Matricula + Verba
 		EndIf
 	Else
 		cCond 	:= "FILIAL + MAT + PD"  // Filial + Matricula + Verba
 	EndIf	                                                                   
 	
	IndRegua("TRP",cArq1,cCond)	//"Selecionando Registros ..."    
	
	RestArea(aArea)

Return( Nil )  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ fGravaTRP ³ Autor ³ Equipe RH            ³ Data ³ 18/03/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Efetua Gravacao dos dados.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Gpea210  												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UGravaTRP()  
Local aArea		  := GetArea()
Local cTpRotPLR	  := fGetCalcRot('F') // PLR
Local cCodSind	  := ""
Local cAlias	  := "TRP"         
Local nX		  := 0  
Local nY 		  := 0
Local nPosMat	  := 0 
Local nPosPd	  := 0 
Local nPosDt	  := 0 
Local nPosSeq	  := 0
Local nPosHrs	  := 0
Local nPosVlr	  := 0
Local nPosTp	  := 0
Local nPosCod	  := 0
Local nPosFor	  := 0
Local nPosOrg	  := 0
Local nPosVlrTot  := 0
Local nPosParc    := 0
Local nPosVlrPa   := 0
Local nPosVlrar   := 0
Local nPosDocumen := 0
Local nPosCC      := 0
Local nPosPerIni  := 0
Local nPosNumPago := 0
Local nPosDtMovi  := 0
Local nPos1		  := 0
Local xConteudo
   
	Begin Sequence   
	
        // Clona array de registros gerais para utilizar na impressao da linha na funcao fGerarLog
        aRegSv := aClone(aReg)
        
	    dbSelectArea("TRP") 
	    dbSetOrder(1)  
	    
		If Len(aReg) > 0  
		
			// ESPECIFICOS - INCIDENCIAS
			If cAliasArq == "RGB" .Or. cAliasArq == "SRC" // Tratamento para sequenciamento dos lancamentos 			
				nPosMat 	:= &("aCpsVld"+cAliasArq)[1]  // Posicao em que esta a matricula
				nPosPd   	:= &("aCpsVld"+cAliasArq)[2]  // Posicao em que esta a verba
								   
				For nX := 1 to Len(aReg) 
				
					If cRoteiro == cTpRotPLR // Se for roteiro de PLR
						nPos1	:= aScan(aSindMat,{|x| x[1] == aReg[nX][1]+aReg[nX][2]})
						If nPos1 > 0
							cCodSind	:= aSindMat[nPos1,2]
							If Empty(aSindMat[nPos1,3]) 
								dbSelectArea("RCE")
								RCE->(dbSetOrder(1))
								If RCE->(dbSeek(xFilial("RCE",aReg[nX][1])+cCodSind))		
									aSindMat[nPos1,3] := RCE->RCE_PLRARC
								EndIf							
								RCE->(dbCloseArea())									
							EndIf
							dDataRef	:= STOD(aSindMat[nPos1,3]+"0101") 
						EndIf
					EndIf 	   
					
					If lItemClvl 
						cKey := aReg[nX][1] + aReg[nX][nPosMat] + aReg[nX][nPosPd] +; // Filial + Matricula + Verba 	
								TRP->CC + TRP->ITEM + TRP->CLVL						// C.Custo + Item + Cl. Valor
					Else			
						cKey := aReg[nX][1] + aReg[nX][nPosMat] + aReg[nX][nPosPd]	// Filial + Matricula + Verba 
					EndIf  											
					If TRP->( dbSeek(cKey,.T.) )  // Alteracao	 			
						If nTotaliza == 1 // Totaliza lancamento 
							RecLock("TRP",.F. )    
							// Verifica se existem os campos na estrutura
							// Campo Horas
							If cAliasArq == "RGB"
								nPosHrs := aScan(aCampos, {|x| x[1] == "RGB_HORAS"})
							Elseif cAliasArq == "SRC"
								nPosHrs := aScan(aCampos, {|x| x[1] == "RC_HORAS"})							
							Endif
							
							If nPosHrs > 0 
								aReg[nX][nPosHrs] 	:= cValtoChar(TRP->HORAS + Val(aReg[nX][nPosHrs]))
								TRP->HORAS			:= Val(aReg[nX][nPosHrs])
							EndIf
							// Campo Valor 
							If cAliasArq == "RGB"
								nPosVlr := aScan(aCampos, {|x| x[1] == "RGB_VALOR"}) 
							Elseif cAliasArq == "SRC"
								nPosVlr := aScan(aCampos, {|x| x[1] == "RC_VALOR"}) 						
							Endif
													
							If nPosVlr > 0 
								aReg[nX][nPosVlr] 	:= cValtoChar(TRP->VALOR + Val(aReg[nX][nPosVlr]))
								TRP->VALOR 			:= Val(aReg[nX][nPosVlr])
							EndIf   
							&(cAlias+"->"+"POSREG") := nX 	  									
						Else // Se nao totalizar, incluir lancamento
							RecLock("TRP",.T. ) 
							// Grava conteudo no arquivo temporario
							&(cAlias+"->"+"POSREG") := nX
							For nY := 1 to Len(aCampos)			
								Do Case       
									Case aCampos[nY][7] == "C" 
										xConteudo := aReg[nX][nY]
									Case aCampos[nY][7] == "N"   
										xConteudo := Val(aReg[nX][nY])
										aReg[nX][nY] :=  Transform(Val(aReg[nX][nY]),aCampos[nY][8])
									Case aCampos[nY][7] == "D"   
											cData	:= aReg[nX][nY]
											cData	:= If( "/" $ cData,;
															cData, ;
												   			Substr(cData,1,2)+  "/" + Substr(cData,3,2) + "/" +  Substr(cData,5, Len(cData));
												              ) 
											aReg[nX][nY] := cData
										xConteudo := CtoD(cData)
								End Case												
								&(cAlias+"->"+aCampos[nY][9]) := xConteudo	      
							Next nY	 							 
							// Campo Dt Referencia
							
							If cAliasArq == "RGB"
								nPosDt := aScan(aCampos, {|x| x[1] == "RGB_DTREF"}) 
							Elseif cAliasArq == "SRC"
						   		nPosDt := aScan(aCampos, {|x| x[1] == "RC_DTREF"}) 
							Endif
								
							If nPosDt == 0 // Se nao tem na estrutura, grava o dDataRef
								TRP->DTREF := dDataRef
							EndIf 	
							// Campos do parametro MV_ITEMCLVL
							
							If lItemClvl  
								TRP->CC 	:= aRgItCl[nX][1]
								TRP->ITEM	:= aRgItCl[nX][2]   
								TRP->CLVL   := aRgItCl[nX][3]
							Else
								// Campo CC
								If cAliasArq == "RGB"
									nPosDt := aScan(aCampos, {|x| x[1] == "RGB_CC"}) 
								Elseif cAliasArq == "SRC"
							   		nPosDt := aScan(aCampos, {|x| x[1] == "RC_CC"})  
								Endif															

								If nPosDt == 0 
									TRP->CC 	:= aRgItCl[nX][1]
								EndIf
							EndIf			
						EndIf  
					Else  // Inclusao
				   		RecLock("TRP",.T. ) 
				   		// Grava conteudo no arquivo temporario
						For nY := 1 to Len(aCampos)	   
							Do Case       
								Case aCampos[nY][7] == "C" 
									xConteudo := aReg[nX][nY]
								Case aCampos[nY][7] == "N"   
									xConteudo := Val(aReg[nX][nY])
									While xConteudo > Int(Val(Substr(StrTran(aCampos[nY][8] ,"," ,""),3)))
										xConteudo := xConteudo/10
									EndDo
									aReg[nX][nY] :=  Transform(xConteudo,aCampos[nY][8])
								Case aCampos[nY][7] == "D"   
										cData	:= aReg[nX][nY]
										cData	:= If( "/" $ cData,;
														cData, ;
											   			Substr(cData,1,2)+  "/" + Substr(cData,3,2) + "/" +  Substr(cData,5, Len(cData));
											              ) 
										aReg[nX][nY] := cData
									xConteudo := CtoD(cData)
							End Case												
							&(cAlias+"->"+aCampos[nY][9]) := xConteudo	   
						Next nY     
						&(cAlias+"->"+"POSREG") := nX 
						// Campo Dt Referencia
   						If cAliasArq == "RGB"
							nPosDt := aScan(aCampos, {|x| x[1] == "RGB_DTREF"}) 
						Elseif cAliasArq == "SRC"
							nPosDt := aScan(aCampos, {|x| x[1] == "RC_DTREF"}) 
						Endif	
						
						If nPosDt == 0 // Se nao tem na estrutura, grava o dDataRef
							TRP->DTREF := dDataRef  
						EndIf  
						// Campos do parametro MV_ITEMCLVL
						If lItemClvl  
							TRP->CC 	:= aRgItCl[nX][1]
							TRP->ITEM	:= aRgItCl[nX][2]   
							TRP->CLVL   := aRgItCl[nX][3]
						Else
						// Campo CC
						If cAliasArq == "RGB"						
							nPosDt := aScan(aCampos, {|x| x[1] == "RGB_CC"}) 
						Elseif cAliasArq == "SRC"
							nPosDt := aScan(aCampos, {|x| x[1] == "RC_CC"}) 
						Endif

							If nPosDt == 0 
								TRP->CC 	:= aRgItCl[nX][1]
							EndIf
						EndIf										
					EndIf
			 		MsUnlock()
				Next nX  				 
			EndIf
			
			// ESPECIFICOS - CO PARTICIPACAO E REEMBOLSO
			If cAliasArq == "RHO"  
				// Todos os campos obrigatorios devem fazer parte da chave 
			    nPosMat	:= aScan(aStru,{|x| x[1] == "MAT" })
			    nPosDt	:= aScan(aStru,{|x| x[1] == "DTOCOR" })
			    nPosTp	:= aScan(aStru,{|x| x[1] == "TPFORN" })
			    nPosFor	:= aScan(aStru,{|x| x[1] == "CODFOR" })
			    nPosCod	:= aScan(aStru,{|x| x[1] == "CODIGO" })
			    nPosOrg	:= aScan(aStru,{|x| x[1] == "ORIGEM" })
			    nPosPd	:= aScan(aStru,{|x| x[1] == "PD" })
				If nPosMat>0 .And. nPosDt>0 .And. nPosTp>0 .And. nPosFor>0 .And. nPosCod>0 .And. nPosOrg>0 .And. nPosPd>0 				
					For nX := 1 to Len(aReg)  	   
						cKey := aReg[nX][1] + aReg[nX][nPosMat] + aReg[nX][nPosDt] + aReg[nX][nPosTp] +;	// Filial + Matricula + Dt.Ocor. + Tp. Forn.
								 aReg[nX][nPosFor] + aReg[nX][nPosOrg] + aReg[nX][nPosCod] + aReg[nX][nPosPd] + cComPg  		// + Cod.Forn. + Origem + Codigo + Pd + Comp.Pago
						If !( TRP->( dbSeek( cKey ) ) )  // Inclusao
							RecLock("TRP",.T. ) 		
							// Grava conteudo no arquivo temporario
							For nY := 1 to Len(aCampos)			
								Do Case       
									Case aCampos[nY][7] == "C" 
										xConteudo := aReg[nX][nY]
									Case aCampos[nY][7] == "N"   
										xConteudo := Val(aReg[nX][nY])
										aReg[nX][nY] :=  Transform(Val(aReg[nX][nY]),aCampos[nY][8])
									Case aCampos[nY][7] == "D"   
											cData	:= aReg[nX][nY]
											cData	:= If( "/" $ cData,;
															cData, ;
												   			Substr(cData,1,2)+  "/" + Substr(cData,3,2) + "/" +  Substr(cData,5, Len(cData));
												              ) 
											aReg[nX][nY] := cData
										xConteudo := CtoD(cData)
								End Case												
								&(cAlias+"->"+aCampos[nY][9]) := xConteudo	      
							Next nY	  
							&(cAlias+"->"+"POSREG") := nX 
				 	   		MsUnlock()
				 	 	Else
				 	 		// Adiciona no Log - Arquivo nao importado				
							nPosReg	:= nX                   
							fGerarLog(.F.,.T.,nPosReg,1,"")
							Loop
				 	 	EndIf
					Next nX 
				EndIf 				 
			EndIf
			
			 // ESPECIFICOS - LANCAMENTOS FUTUROS
		    If cAliasArq == "SRK"  
				// Todos os campos obrigatorios devem fazer parte da chave 
			    nPosPd  	:= aScan(aStru,{|x| x[1] == "PD" })
			    nPosMat	    := aScan(aStru,{|x| x[1] == "MAT" })
			    nPosVlrTot  := aScan(aStru,{|x| x[1] == "VALORTO" })
			    nPosParc	:= aScan(aStru,{|x| x[1] == "PARCELA" })
			    nPosDtVenc	:= aScan(aStru,{|x| x[1] == "DTVENC" })
			    nPosPerIni	:= aScan(aStru,{|x| x[1] == "PERINI" })
			    nPosDtMovi	:= aScan(aStru,{|x| x[1] == "DTMOVI" })

			      
				If nPosPd > 0 .And. nPosMat  > 0 .And. nPosVlrTot > 0 .And. nPosParc > 0 .And. ;
			    nPosDtVenc  > 0.And. nPosPerIni > 0 .And. nPosDtMovi > 0				
					For nX := 1 to Len(aReg)  	   
						cKey := aReg[nX][1] + aReg[nX][nPosPd] + aReg[nX][nPosMat] + aReg[nX][nPosVlrTot] +; 
								 aReg[nX][nPosParc] + aReg[nX][nPosDtVenc] + aReg[nX][nPosPerIni] + aReg[nX][nPosDtMovi]  
						If !( TRP->( dbSeek( cKey ) ) )  // Inclusao
							RecLock("TRP",.T. ) 		
							// Grava conteudo no arquivo temporario
							For nY := 1 to Len(aCampos)			
								Do Case       
									Case aCampos[nY][7] == "C" 
										xConteudo := aReg[nX][nY]
									Case aCampos[nY][7] == "N"   
										xConteudo := Val(aReg[nX][nY])
										aReg[nX][nY] :=  Transform(Val(aReg[nX][nY]),aCampos[nY][8])
									Case aCampos[nY][7] == "D"   
											cData	:= aReg[nX][nY]
											cData	:= If( "/" $ cData,;
															cData, ;
												   			Substr(cData,1,2)+  "/" + Substr(cData,3,2) + "/" +  Substr(cData,5, Len(cData));
												              ) 
											aReg[nX][nY] := cData
										xConteudo := CtoD(cData)
								End Case
								
								
								if(lDtRefSRK)									
									// Campo Dt Referencia
									nPosDt := aScan(aCampos, {|x| x[1] == "RK_DTREF"}) 
									If nPosDt == 0 // Se nao tem na estrutura, grava o dDataRef
										TRP->DTREF := dDataRef
									EndIf
								endIf								
								 												
								&(cAlias+"->"+aCampos[nY][9]) := xConteudo	      
							Next nY	  
							&(cAlias+"->"+"POSREG") := nX 
				 	   		MsUnlock()
				 	 	Else
				 	 		// Adiciona no Log - Arquivo nao importado				
							nPosReg	:= nX                   
							fGerarLog(.F.,.T.,nPosReg,1,"")
							Loop
				 	 	EndIf
					Next nX 
				EndIf 				 
			EndIf
		
		
		
		EndIf
        
    End Sequence
    
	RestArea(aArea)

Return()     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ fGrava210 ³ Autor ³ Equipe RH            ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Efetua gravacao dos dados.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ GPEA210  												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UGrava210() 
Local aArea		    := GetArea() 
Local aErro		    := {0,0}
Local cArqRHO	    := ""  
Local cChave		:= "" 
Local cData			:= "" 
Local cIndKeyRHO	:= ""
Local nOrder	    := 0  
Local nX		    := 0 
Local nY            := 0
Local nErro		    := 0
Local nPosReg	    := 0 
Local nPosSbr	    := 0 
Local nPosMat	    := 0 
Local nPosPd	    := 0 
Local nPosDt	    := 0 
Local nPosSeq	    := 0   
Local nPosHrs	    := 0
Local nPosVlr	    := 0
Local nPosTp	    := 0
Local nPosCod	    := 0
Local nPosOrg	    := 0
Local xConteudo	    := 0 
Local nPoSRKCC      := 0
Local nPoSKRProces  := 0
Local nPoSRKNumPago := 0
Local nPoSRKVlrPa   := 0
Local nPoSRKVLrRar  := 0
Local nPoSRKVlJur   := 0
Local nPoSRKPcJur   := 0 
Local nPoSRKJrMes   := 0
Local nPoSRKDocum   := 0
Local lDemitido	    := .F.
Local lSort			:= .T.
Local aAreaSRK		:= {}
Local cSeek 		:= ""

	DbSelectArea(cAliasArq) 
	If cAliasArq == "RGB"  
		If lItemClvl
			nOrder	:= RetOrder("RGB","RGB_FILIAL+RGB_PROCES+RGB_MAT+RGB_PERIOD+RGB_SEMANA+RGB_ROTEIR+RGB_PD+RGB_CC+RGB_ITEM+RGB_CLVL+RGB_SEQ+DTOS(RGB_DTREF)")
		Else   
			nOrder	:= RetOrder("RGB","RGB_FILIAL+RGB_PROCES+RGB_MAT+RGB_PERIOD+RGB_SEMANA+RGB_ROTEIR+RGB_PD+RGB_CC+RGB_SEQ+DTOS(RGB_DTREF)")
		EndIf
	ElseIf cAliasArq == "SRC"  
		If lItemClvl
			nOrder	:= RetOrder("SRC","RC_FILIAL+RC_PROCES+RC_MAT+RC_PERIOD+RC_SEMANA+RC_ROTEIR+RC_PD+RC_CC+RC_ITEM+RC_CLVL+RC_SEQ+DTOS(RC_DTREF)")
		Else   
			nOrder	:= RetOrder("SRC","RC_FILIAL+RC_PROCES+RC_MAT+RC_PERIOD+RC_SEMANA+RC_ROTEIR+RC_PD+RC_CC+RC_SEQ+DTOS(RC_DTREF)")
		EndIf
	ElseIf cAliasArq == "RHO"
		cIndKeyRHO	:= "RHO_FILIAL+RHO_MAT+DTOS(RHO_DTOCOR)+RHO_TPFORN+RHO_CODFOR+RHO_ORIGEM+RHO_CODIGO+RHO_PD+RHO_COMPPG" 
		cArqRHO		:= CriaTrab( Nil, .F. )		
		IndRegua( "RHO", cArqRHO, cIndKeyRHO, , , '', .T. )
		nOrder		:= RHO->( RetIndex( ) ) + 1
	ElseIf cAliasArq == "SRK"
		nOrder	:= RetOrder("SRK","RK_FILIAL+RK_MAT+RK_PD+RK_PERINI+RK_NUMPAGO")
	EndIf
	
	dbSetOrder(nOrder)
	
	DbSelectArea("TRP")   
	TRP->(DbGoTop()) 
	nY := 1 //Inicializa o contador de linhas da TRP.
	
	Begin Transaction 
	
		While !TRP->( EoF() )  

			// ESPECIFICOS - INCIDENCIAS
			If cAliasArq == "RGB" .Or. cAliasArq == "SRC" 
				If lItemClvl
					cChave := TRP->FILIAL + cProcesso + TRP->MAT + cPeriodo + cNroPago +cRoteiro + TRP->PD + TRP->CC + TRP->ITEM + TRP->CLVL 
				Else
					cChave := TRP->FILIAL + cProcesso + TRP->MAT + cPeriodo + cNroPago + cRoteiro + TRP->PD + TRP->CC
				EndIf 							 
				If (nSobrePoe == 1) .And. ( RGB->(dbSeek(AllTrim(cChave))) .Or. RC->(dbSeek(AllTrim(cChave)))) 					 
					If RGB->RGB_TIPO2 == "G" .Or. RC->RC_TIPO2 == "G"// Lancamento do tipo gerado
						RecLock( cAliasArq,.F. ) // Altera   
						For nX := 1 to Len(aStru)								 
							If aStru[nX][1] $ "POSREG*OK*SEQ" 
								Loop
							Elseif aStru[nX][1] == "HORAS" .And. cDigHoras == "S" 
								xConteudo := fConvHr( TRP->&(aStru[nX][1]) , "D" )
							Else
								xConteudo := TRP->&(aStru[nX][1])	
							EndIf										
							&(cAliasArq+"->"+cAliasArq+"_"+aStru[nX][1]) :=  xConteudo   
						Next nX 
						If Empty(RGB->RGB_TIPO1)
				 			RGB->RGB_TIPO1 := fDesc("SRV",RGB->RGB_PD, "RV_TIPO")
				 		Elseif Empty(RC->RC_TIPO1)
				 			RC->RC_TIPO1 := fDesc("SRV",RC->RC_PD, "RV_TIPO")
				 		EndIf
						// Adiciona no Log - Arquivo importado 
						nPosReg	:= TRP->POSREG    
						MsUnlock() 
						nPosSbr := aScan(aRegSbr,{|x| x[1] == cChave}) 
						If nPosSbr == 0          
							AADD(aRegSbr,{ cChave, nPosReg , 0 } ) // Adiciona no array de reg sobrepostos  
						EndIf
						fGerarLog(.F.,.F.,nPosReg,0,cChave)
					Else   
						// Adiciona no Log - Arquivo nao importado (nao sobrepoe tipo de lanc dif de 'G')				
						nPosReg	:= TRP->POSREG                    
						fGerarLog(.F.,.T.,nPosReg,3,"")
						TRP->( dbSkip() )   
						Loop							
					EndIf				
				Else
				 	If(lDemPSrk)				 	
				 		If(SRA->(DbSeek(TRP->FILIAL + TRP->MAT)))
				 			lDemitido := (SRA->RA_SITFOLH == "D")
				 		EndIf				 		
				 	EndIf
				 	
				 	If(lDemitido)
				 		//Nessa situação quando o funcionário está demitido
				 		//seus lançamentos vão para a tabela de lançamentos futuros.
				 		aAreaSRK := SRK->(GetArea())
    			
		    			SRK->(DbSetOrder(4))    			
			    		cSeek := TRP->FILIAL
			    		cSeek += TRP->MAT
			    		cSeek += TRP->PD			    		
			    		cSeek += TRP->PERINI
			    		cSeek += TRP->NUMPAGO
			    			    			    		
			    		lNew := !(SRK->(DbSeek(cSeek)))
			    		
			    		RecLock("SRK",lNew)
			    		
			    		If(lNew)	    			
				    		SRK->RK_FILIAL		:= TRP->FILIAL
				    		SRK->RK_MAT 		:= TRP->MAT
				    		SRK->RK_PD			:= TRP->PD
			    			SRK->RK_DTMOVI		:= TRP->DTREF
			    			SRK->RK_DOCUMEN		:= UNxtDocSRK(TRP->FILIAL,TRP->MAT)
				    		SRK->RK_VALORTO  	:= TRP->VALOR
				    		SRK->RK_VALORPA  	:= TRP->VALOR
			    		Else			    			
			    			If(nTotaliza != 1)
				    			SRK->RK_VALORTO  	:= TRP->VALOR
				    			SRK->RK_VALORPA  	:= TRP->VALOR
				    		Else	    				
				    			SRK->RK_VALORTO  	+= TRP->VALOR
				    			SRK->RK_VALORPA  	+= TRP->VALOR
			    			EndIf	    		
			    		EndIf
			    		
			    		SRK->RK_PARCELA  	:= 1
			    		SRK->RK_JUROANO  	:= 0
			    		SRK->RK_JUROMES  	:= 0
			    		SRK->RK_VALORAR 	:= 0
			    		SRK->RK_DTVENC 	:= dDataRef		    		
			    		
			    		If(lDtRefSRK)	    			
			    			SRK->RK_DTREF	:= TRP->DTREF
			    		EndIf	    		
			    		
			    		SRK->RK_CC			:= TRP->CC
			    		SRK->RK_REGRADS	:= "1"
			    		SRK->RK_VALPARE	:= 0
			    		SRK->RK_TIPO		:= "G"
			    		
			    		If(lItemClVl)	    			
				    		SRK->RK_ITEM		:= TRP->ITEM
				    		SRK->RK_CLVL		:= TRP->CLVL
			    		EndIf
			    		
			    		SRK->(MsUnlock())
			    		nPosReg	:= TRP->POSREG						
						fGerarLog(.F.,.F.,nPosReg,0,"")
						
			    		RestArea(aAreaSRK)	
				 	Else
						// Valida Verba/Sequencia 
					 	aErro := UVldLanc( cChave , TRP->PD, TRP->DTREF, nOrder)
						If aErro[1] > 0
							// Adiciona no Log - Arquivo nao importado
							nErro	:= aErro[1]
							nPosReg	:= TRP->POSREG
							fGerarLog(.F.,.T.,nPosReg,nErro,"")
							TRP->( dbSkip() )   
							Loop
						EndIf
						RecLock( cAliasArq,.T. ) // Inclui
						For nX := 1 to Len(aStru)			
							If aStru[nX][1] $ "POSREG|OK"  
								Loop
							ElseIf aStru[nX][1] == "SEQ" 
								xConteudo	:= aErro[2] 				// Se nao tem erro, apenas possui prox seq 
								HMSet(oRegGrv,cChave,xConteudo) 
							Elseif aStru[nX][1] == "HORAS" .And. cDigHoras == "S" 
								xConteudo := fConvHr( TRP->&(aStru[nX][1]) , "D" )
							Else
								xConteudo := TRP->&(aStru[nX][1])
							EndIf										
							&(cAliasArq+"->"+cAliasArq+"_"+aStru[nX][1]) :=  xConteudo   
						Next nX
						If cAliasArq == "RGB"
							RGB->RGB_TIPO2	:= "G" 
							RGB->RGB_PROCES	:= cProcesso
							RGB->RGB_ROTEIR	:= cRoteiro
							RGB->RGB_PERIOD	:= cPeriodo
							RGB->RGB_SEMANA	:= cNroPago   
							If Empty(RGB->RGB_TIPO1)
					 			RGB->RGB_TIPO1 := fDesc("SRV",RGB->RGB_PD, "RV_TIPO")
					 		EndIf
				 		Elseif cAliasArq == "SRC"
				 			SRC->RC_TIPO2	:= "G" 
							SRC->RC_PROCES	:= cProcesso
							SRC->RC_ROTEIR	:= cRoteiro
							SRC->RC_PERIOD	:= cPeriodo
							SRC->RC_SEMANA	:= cNroPago   
							If Empty(RC->RGB_TIPO1)
					 			SRC->RC_TIPO1 := fDesc("SRV",RC->RC_PD, "RV_TIPO")
					 		EndIf
				 		Endif
						
						// Adiciona no Log - Arquivo importado 
						nPosReg	:= TRP->POSREG
						MsUnlock()
						fGerarLog(.F.,.F.,nPosReg,0,"") 	      
					EndIf				
				EndIf
			EndIf

			// ESPECIFICOS - CO PARTICIPACAO E REEMBOLSO
			If cAliasArq == "RHO" 
				cChave := TRP->FILIAL + TRP->MAT + DTOS(TRP->DTOCOR) + TRP->TPFORN + TRP->CODFOR + TRP->ORIGEM + TRP->CODIGO + TRP->PD + cComPg  		         
				If RHO->(dbSeek(AllTrim(cChave))) 
					If nSobrePoe == 1
						RecLock( cAliasArq,.F. ) // Altera   
						For nX := 1 to Len(aStru)			
							If aStru[nX][1] $ "POSREG|OK"  
								Loop
							Else
								xConteudo := TRP->&(aStru[nX][1])
							EndIf										
							&(cAliasArq+"->"+cAliasArq+"_"+aStru[nX][1]) :=  xConteudo   
						Next nX 
						// Adiciona no Log - Arquivo importado 
						nPosReg	:= TRP->POSREG    
						MsUnlock() 
						nPosSbr := aScan(aRegSbr,{|x| x[1] == cChave}) 
						If nPosSbr == 0          
							AADD(aRegSbr,{ cChave, nPosReg , 0 } ) // Adiciona no array de reg sobrepostos  
						EndIf
						fGerarLog(.F.,.F.,nPosReg,0,cChave)
					Else
						// Adiciona no Log - Arquivo nao importado (itens da chave)				
						nPosReg	:= TRP->POSREG                    
						fGerarLog(.F.,.T.,nPosReg,1,"")
						TRP->( dbSkip() )   
						Loop
					EndIf		
				Else 				                               
					RecLock( cAliasArq,.T. ) // Inclui
					For nX := 1 to Len(aStru)			
						If aStru[nX][1] $ "POSREG|OK"   
							Loop
						Else
							xConteudo := TRP->&(aStru[nX][1])
						EndIf										
						&(cAliasArq+"->"+cAliasArq+"_"+aStru[nX][1]) :=  xConteudo   
					Next nX     
					RHO->RHO_COMPPG	:= cComPg
					RHO->RHO_TPLAN	:= cTpLan 
					// Adiciona no Log - Arquivo importado 
					nPosReg	:= TRP->POSREG
					MsUnlock()
					fGerarLog(.F.,.F.,nPosReg,0,"") 	      
				EndIf	
			EndIf	

			// ESPECIFICOS - VALORES FUTUROS
			If cAliasArq == "SRK" 
				cChave := TRP->FILIAL + TRP->MAT + TRP->PD + TRP->PERINI + TRP->NUMPAGO
				If lSort //Efetua o sort uma única vez
					aSort(aGravaSRK,,,{|x,y| x[1]<y[1]})
					lSort := .F.
				EndIf
				If SRK->(dbSeek(AllTrim(cChave))) 
					If nSobrePoe == 1 
						
						RecLock( cAliasArq,.F. ) // Altera

						SRK->RK_CC      := aGravaSRK [nY][2]
						SRK->RK_PROCES  := aGravaSRK [nY][3]
						SRK->RK_JUROMES := aGravaSRK [nY][4]
						SRK->RK_VALORPA := aGravaSRK [nY][5]
						SRK->RK_VALORAR := aGravaSRK [nY][6]
						SRK->RK_VLJUROS := aGravaSRK [nY][7]
						SRK->RK_PCJUROS := aGravaSRK [nY][8]
						SRK->RK_DOCUMEN := SRK->RK_DOCUMEN
						if(lDtRefSRK)							
							SRK->RK_DTREF	  := TRP->DTREF
						endIf
											
						For nX := 1 to Len(aStru)			
							If aStru[nX][1] $ "POSREG|OK" 
								Loop
							Else
								xConteudo := TRP->&(aStru[nX][1])
							EndIf	
							
							If(aStru[nX][1] == "JUROMES") //Juro Mes estava no layout mas foi preenchido com zeros.
								xConteudo := If(aGravaSRK [nY][4] # 0 , aGravaSRK [nY][4] , xConteudo)
							ElseIf(aStru[nX][1] == "JUROANO") //Quando for o Juro Ano.
								If(aScan(aCampos, {|x| x[1] == "RK_JUROMES"})) # 0 //Verifica se Juro Mes Existe na Estrutura
									xConteudo := If( TRP->JUROMES # 0 , 0 , xConteudo ) // Se Juro Mes veio preenchido, zera o Juro Ano
								EndIf
							EndIf
							//Gravacao da TRP para SRK.	
							&(cAliasArq+"->"+"RK"+"_"+aStru[nX][1]) :=  xConteudo   
						Next nX 

						// Adiciona no Log - Arquivo importado 
						nPosReg	:= TRP->POSREG    
						MsUnlock() 
						nPosSbr := aScan(aRegSbr,{|x| x[1] == cChave}) 
						If nPosSbr == 0          
							AADD(aRegSbr,{ cChave, nPosReg , 0 } ) // Adiciona no array de reg sobrepostos  
						EndIf
						fGerarLog(.F.,.F.,nPosReg,0,cChave)														
					Else
						// Adiciona no Log - Arquivo nao importado (itens da chave)				
						nPosReg	:= TRP->POSREG                    
						fGerarLog(.F.,.T.,nPosReg,1,"")
						TRP->( dbSkip() )   
						Loop
					EndIf		
				Else
					RecLock( cAliasArq,.T. ) // Inclui
						//Caso usuario nao tenha importado, preenche com "2 - Ativo"
						If(aScan(aCampos, {|x| x[1] == "RK_STATUS"})) == 0
							SRK->RK_STATUS := StrZero(2,1)	
						EndIf
						//Caso usuario nao tenha importado, preenche com Emp Cons da Verba importada
						If(aScan(aCampos, {|x| x[1] == "RK_EMPCONS"})) == 0
							SRK->RK_EMPCONS := aGravaSRK [nY][9]	
						EndIf
						
						SRK->RK_CC      := aGravaSRK [nY][2]
						SRK->RK_PROCES  := aGravaSRK [nY][3]
						SRK->RK_JUROMES := aGravaSRK [nY][4]
						SRK->RK_VALORPA := aGravaSRK [nY][5]
						SRK->RK_VALORAR := aGravaSRK [nY][6]
						SRK->RK_VLJUROS := aGravaSRK [nY][7]
						SRK->RK_PCJUROS := aGravaSRK [nY][8]
						SRK->RK_DOCUMEN := aGravaSRK [nY][10]									
					
					For nX := 1 to Len(aStru)							
						If aStru[nX][1] $ "POSREG|OK"  
							Loop
						Else
							xConteudo := TRP->&(aStru[nX][1])
						EndIf		
							
						If(aStru[nX][1] == "JUROMES") //Juro Mes estava no layout mas foi preenchido com zeros..
							xConteudo := If(aGravaSRK [nY][4] # 0 , aGravaSRK [nY][4] , xConteudo)
						ElseIf(aStru[nX][1] == "JUROANO") //Quando for o Juro Ano.
							If(aScan(aCampos, {|x| x[1] == "RK_JUROMES"})) # 0 //Verifica se Juro Mes Existe na Estrutura
								xConteudo := If( TRP->JUROMES # 0 , 0 , xConteudo ) // Se Juro Mes veio preenchido, zera o Juro Ano.
							EndIf
						EndIf	
						//Gravacao da TRP para SRK.						
						&(cAliasArq+"->"+"RK"+"_"+aStru[nX][1]) :=  xConteudo   
					Next nX     

					// Adiciona no Log - Arquivo importado 
					nPosReg	:= TRP->POSREG
					MsUnlock()
					UGerarLog(.F.,.F.,nPosReg,0,"") 	      
				EndIf	
			EndIf	
			
		nY++	//Contabiliza as Linhas da TRP
			
		TRP->( dbSkip() ) 
			
		Enddo		
	End Transaction 
	
	RestArea(aArea)

	If File(cArqRHO+OrdBagExt())
		fErase(cArqRHO+OrdBagExt())
	Endif
	If File(cArqRHO+GetDBExtension())
		fErase(cArqRHO+GetDBExtension())
	Endif
	
	RHO->( retIndex() )
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ fVldLanc  ³ Autor ³ Equipe RH            ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Validar sequenciamento de acordo com a verba.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ GPEA210   												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UVldLanc( cChave , cVerba , dData , nOrderRGB )  
Local aArea		:= GetArea() 
Local aErro		:= {} 
Local cKey		:= "" 
Local cSeq		:= ""
Local cRet		:= "#"
Local lLancDia	:= .F. 
Local nErro		:= 0 
Local nQtdLanc	:= 1 

	// Realiza verificacao ref a Verba
	dbSelectArea("SRV")
	SRV->(dbSetOrder(1))
	If SRV->(dbSeek(xFilial("SRV")+cVerba))
       	nQtdLanc := If( Empty(Val(SRV->RV_QTDLANC)), 9, Val(SRV->RV_QTDLANC) )  
       	If SRV->RV_LCTODIA $ "S*1"
       		lLancDia	:= .T.
       	EndIf
	EndIf 

	HMGet(oRegGrv,cChave,@cRet)

	If cRet <> "#"
	 	cRet := If(Empty(cRet),"0",cRet)
		nErro 	:= 0  
		If !lLancDia
			nSeq 	:= Val(cRet)+1
			If nSeq > nQtdLanc  // Se esta gravado em aRegGrv ja passou pela validacao do lanc diario
				nErro 	:= 1 	// Atingiu quantidade permitida de lancamentos					
			Else
				cSeq 	:= cValToChar(nSeq)
			EndIf
		Else //se for lancamento Diario verifica o campo DTREF para permitir ou nao a importacao do registro.
			If cAliasArq == "RGB"
				dbSelectArea("RGB")
				RGB->( dbSetOrder(nOrderRGB) )
				If RGB->(dbSeek(cChave), .T.)
					While !RGB->(EoF()) .And. RGB->(RGB_FILIAL + RGB_PROCESS + RGB_PERIOD + RGB_SEMANA + RGB_ROTEIR + RGB_MAT + RGB_PD) == cChave
						If RGB->RGB_DTREF == dData
							nErro := 2 // Nao permite lancamento diario
						EndIf
						RGB->(DbSkip())
					EndDo
				Else
					cSeq := ""
				EndIf
			Elseif cAliasArq == "SRC"
				dbSelectArea("SRC")
				SRC->( dbSetOrder(nOrderRGB) )
				If SRC->(dbSeek(cChave), .T.)
					While !SRC->(EoF()) .And. SRC->(RC_FILIAL + RC_PROCESS + RC_PERIOD + RC_SEMANA + RC_ROTEIR + RC_MAT + RC_PD) == cChave
						If SRC->RC_DTREF == dData
							nErro := 2 // Nao permite lancamento diario
						EndIf
						SRC->(DbSkip())
					EndDo
				Else
					cSeq := ""
				EndIf			
			Endif
		EndIf

	Else // Verifica no alias destino
		If cAliasArq == "RGB"
			dbSelectArea("RGB")
			RGB->( dbSetOrder(nOrderRGB) )
			If RGB->(dbSeek(cChave, .T.))
				While !RGB->(EoF()) .And. ( ( lItemClvl .and. RGB->(RGB_FILIAL + RGB_PROCESS + RGB_MAT + RGB_PERIOD + RGB_SEMANA + RGB_ROTEIR + RGB_PD + RGB_CC + RGB_ITEM + RGB_CLVL) == cChave ) .or. ( !lItemClvl .and. RGB->(RGB_FILIAL + RGB_PROCESS + RGB_MAT + RGB_PERIOD + RGB_SEMANA + RGB_ROTEIR + RGB_PD + RGB_CC ) == cChave ) )
					If RGB->RGB_DTREF == dData  .And. lLancDia
						nErro := 2 // Nao permite lancamento diario
						Exit
					ElseIf !lLancDia
						If Val(RGB->RGB_SEQ) >= nQtdLanc
							nErro := 1 // Atingiu quantidade permitida de lancamentos
							Exit
						Else
							cSeq := cValToChar(Val(RGB->RGB_SEQ)+1)
						EndIf
					EndIf
	
					RGB->(DbSkip())
				EndDo
			Else
				cSeq := ""
			EndIf 
		Elseif cAliasArq == "SRC"
			dbSelectArea("SRC")
			SRC->( dbSetOrder(nOrderRGB) )
			If SRC->(dbSeek(cChave, .T.))
				While !SRC->(EoF()) .And. ( ( lItemClvl .and. SRC->(RC_FILIAL + RC_PROCESS + RC_MAT + RC_PERIOD + RC_SEMANA + RC_ROTEIR + RC_PD + RC_CC + RC_ITEM + RC_CLVL) == cChave ) .or. ( !lItemClvl .and. SRC->(RC_FILIAL + RC_PROCESS + RC_MAT + RC_PERIOD + RC_SEMANA + RC_ROTEIR + RC_PD + RC_CC ) == cChave ) )
					If SRC->RC_DTREF == dData  .And. lLancDia
						nErro := 2 // Nao permite lancamento diario
						Exit
					ElseIf !lLancDia
						If Val(SRC->RC_SEQ) >= nQtdLanc
							nErro := 1 // Atingiu quantidade permitida de lancamentos
							Exit
						Else
							cSeq := cValToChar(Val(SRC->RC_SEQ)+1)
						EndIf
					EndIf
	
					SRC->(DbSkip())
				EndDo
			Else
				cSeq := ""
			EndIf		
		Endif
	EndIf

	aAdd(aErro,nErro)
	aAdd(aErro,cSeq)

	RestArea(aArea)	

Return ( aErro )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fGerarLog ³ Autor ³ Equipe RH            ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina para geracao de log.							      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA210                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UGerarLog(lFirstGrv,lError,nPosReg,nErro,cChave)
Local aArea		:= GetArea()
Local aTrpArea	:= {}
Local aLinSRK   := {}  
Local cLog		:= ""  
Local cLinha	:= "" 
Local cTpFor	:= ""
Local cTpOrg	:= ""
Local cDesc		:= ""
Local xTxt1     := ""
Local xTxt2		:= ""
Local xConteudo	:= "" 
Local lSobrepoe	:= .F.  
Local nPosGrv	:= 0   
Local nPosLg	:= 0  
Local nPosPd	:= 0
Local nPosTpFor	:= 0
Local nPosOrg	:= 0 
Local nPosVlr	:= 0
Local nPosHrs	:= 0
Local nX		:= 0
Local nTotal	:= 0
Local nMaior	:= 0
Local nMenor	:= 0
Local nValor	:= 0
Local nRegs	:= 0
Local xTemp	:= ""
Local lTrpValor	:= .T.

DEFAULT nPosReg	:= 0
DEFAULT nErro	:= 0   
DEFAULT cChave	:= ""

	If lFirstGrv  	// Grava todas as informacoes em aTitle/aLog
		// Associa titulo de impressao
		If Len(aLogVld) > 0
			cLog := oEmToAnsi(STR0028) + " -> " + AllTrim(cNomeArq)  + " (" + cAliasArq + ")    " 	//-- "Funcionarios Importados + ## + Nome Tabela + ## Verba  + ##" 	   
			AADD(aTitle,cLog)   
			AADD(aLog, { Space(2) + cTitImpres }  )  
			nPosGrv	:= Len(aLog)			
			nRegs		:= Len(aLogVld)
						
			If nRegs > 0		// Grava log dos registros importados  		
			  			
				For nX := 1 to Len(aLogVld)				
		  			AADD( aLog[nPosGrv], Space(2) + aLogVld[nX] )   
				Next nX
				
				aTrpArea := TRP->(GetArea())
				TRP->(DbGoTop())
				nX := 0
				lTrpValor := Type("TRP->VALOR") == "U"
				while ( TRP->(!Eof()) )
					nX++
					if(TRP->OK == "S")
						Do Case
							Case (cAliasArq == "SRK")
								nValor := TRP->VALORTO
							Case (cAliasArq == "RGB") 
								If lTrpValor 
									nValor := 0
								Else
									nValor := TRP->VALOR
								EndIf             
							Case (cAliasArq == "SRC") 
								If lTrpValor 
									nValor := 0
								Else
									nValor := TRP->VALOR
								EndIf								
							Case (cAliasArq == "RHO")							
								nValor := 0
								if(aScan(aCampos,{|x|x[1] == 'RHO_VLRFUN'}))
									nValor += TRP->VLRFUN 	
								endIf
								if(aScan(aCampos,{|x|x[1] == 'RHO_VLREMP'}))
									nValor += TRP->VLREMP
								endIf								
						EndCase						
						
			    		nTotal += nValor
			    		
			    		if(nValor > nMaior .Or. nX == 1)
			    			nMaior := nValor
			    		endIf
			    		if(nValor < nMenor .Or. nX == 1)
			    			nMenor := nValor
			    		endIf
					endIf
										
					TRP->(dbSkip())
				EndDo
				RestArea(aTrpArea)				
				
				xTxt1 := PadC(OemToAnsi("Totalizadores"),((nLimImp+1) * nColTam),"-") //Totalizadores   	
		    	aAdd(aLog[nPosGrv],xTxt1)
		    	
		    	xTxt1 := PadL(OemToAnsi("Importados"),(nColTam + 8),'.')//Importados
		    	xTxt1 += PadL(StrZero(Len(aLogVld),6),nColTam)		    	
		    	aAdd(aLog[nPosGrv],xTxt1)
		    	
		    	xTxt1 := PadL(OemToAnsi("Não Importados"),(nColTam + 8),'.')//Não Importados
		    	xTxt1 += PadL(StrZero(nLinhas - Len(aLogVld),6),nColTam)
		    	aAdd(aLog[nPosGrv],xTxt1)
		    	
		    	xTxt1 := PadL(OemToAnsi("Valor"),(nColTam + 8),'.') //Valor
		    	xTxt1 += PadL(Transform(nTotal,"@E 999,999,999.99"),nColTam)
		    	aAdd(aLog[nPosGrv],xTxt1)
		    	
		    	xTxt1 := PadL(OemToAnsi("Maior"),(nColTam + 8),'.')//Maior
		    	xTxt1 += PadL(Transform(nMaior,"@E 999,999,999.99"),nColTam)
		    	aAdd(aLog[nPosGrv],xTxt1)
		    	
		    	xTxt1 := PadL(OemToAnsi("Menor"),(nColTam + 8),'.')//Menor
		    	xTxt1 += PadL(Transform(nMenor,"@E 999,999,999.99"),nColTam)
		    	aAdd(aLog[nPosGrv],xTxt1)
		    	
		    	xTxt1 := PadL(OemToAnsi("Total"),(nColTam + 8),'.')//OemToAnsi
		    	xTxt1 += PadL(Transform((nTotal / nRegs),"@E 999,999,999.99"),nColTam)
		    	aAdd(aLog[nPosGrv],xTxt1)					
			EndIf
		EndIf
	ElseIf !lError .And. nPosReg > 0  .And. nErro == 0// Arquivos validos importados 
		    RecLock('TRP',.F.)
		    TRP->OK := "S"
		    TRP->(MSUnlock())
		    
		    // Tratamento quando sobrepor
			If nSobrePoe == 1
		    	nPosSbr	:= aScan(aRegSbr,{|x| x[1] == cChave})  
				If nPosSbr > 0
					If Empty(aRegSbr[nPosSbr][3])
						aRegSbr[nPosSbr][3] := Len(aLogVld)+1 // Guarda posicao no aLogVld onde foi gravado 
					Else
						 lSobrepoe 	:= .T.
						 nPosLg		:=  aRegSbr[nPosSbr][3]   // Substitui registro no aLogVld
					EndIf
				EndIf
			EndIf  
			
			// Tratamento quando totalizar
			If nTotaliza == 1 // Se houveram registros totalizadas   
				If cAliasArq == "RGB"
			   		nPosHrs := aScan(aCampos, {|x| x[1] == "RGB_HORAS"})
				Elseif cAliasArq == "SRC"
					nPosHrs := aScan(aCampos, {|x| x[1] == "RC_HORAS"})
				Endif
				
				If nPosHrs > 0     
					aRegSv[nPosReg][nPosHrs] :=  Transform(Val(aRegSv[nPosReg][nPosHrs]),aCampos[nPosHrs][8])	// Converte para mesmo formato  									
					If 	aRegSv[nPosReg][nPosHrs] <> aReg[nPosReg][nPosHrs]
						xTxt2 := "XXXXXX" + " " // Linha totalizada
					Else
						xTxt2 := StrZero(nPosReg,6) + " "
					EndIf 	
				EndIf
				// Campo Valor
				If cAliasArq == "RGB"
					nPosVlr := aScan(aCampos, {|x| x[1] == "RGB_VALOR"}) 
				Elseif cAliasArq == "SRC"
					nPosVlr := aScan(aCampos, {|x| x[1] == "RC_VALOR"}) 
				Endif
				
				If nPosVlr > 0  
					aRegSv[nPosReg][nPosVlr] :=  Transform(Val(aRegSv[nPosReg][nPosVlr]),aCampos[nPosVlr][8]) // Converte para mesmo formato  
					If 	aRegSv[nPosReg][nPosVlr] <> aReg[nPosReg][nPosVlr]
						xTxt2 := "XXXXXX" + " "    // Linha totalizada
					Else 
						xTxt2 := StrZero(nPosReg,6) + " "
					EndIf 
				EndIf  
			Else
				xTxt2 := StrZero(nPosReg,6) + " " 						
			EndIf 		
			
			nPosPd  := &("aCpsVld"+cAliasArq)[2]  // Posicao em que esta a verba, dependendo do alias destino
			If cAliasArq == "RHO"  
				nPosTpFor	:= &("aCpsVld"+cAliasArq)[4]  // Posicao em que esta o Tp. do Fornecedor
				nPosOrg  	:= &("aCpsVld"+cAliasArq)[3]  // Posicao em que esta a Origem
			EndIf
					
			For nX := 1 to Len(aCampos)   
				// Fixar tamanho 
				//           20         2           20
				// |Titulo------------|---|Titulo------------|
				// |Conteudo----------|---|Conteudo----------| 
				// Somente imprime os campos obrigatorios
				If nX  <= nLimImp   
					If nX == nPosPd  
						cVerba		:= AllTrim(aReg[nPosReg][nX]) 
						xConteudo 	:= cVerba + "-" + fDesc("SRV",cVerba, "RV_DESC")
					ElseIf cAliasArq == "RHO" .And. (nX == nPosTpFor .Or. nX == nPosOrg)						
						if(nX == nPosTpFor)
							cTpFor		:= AllTrim(aReg[nPosReg][nX])
							cDesc		:= fDesc210(cTpFor,"RHO_TPFOR") 
							xConteudo 	:= cTpFor + "-" + cDesc
						else														
							cTpOrg		:= AllTrim(aReg[nPosReg][nX]) 
							cDesc		:= UDesc210(cTpOrg,"RHO_ORIGEM") 
							xConteudo 	:= cTpOrg + "-" + cDesc
						endIf
					Else
						xConteudo	:= AllTrim(aReg[nPosReg][nX])  
					EndIf
					
					xConteudo := PadR(xConteudo,nColTam)
					If(cAliasArq == "SRK")		
						xTxt2 		+= Space(At(Acampos[nX][6],cTitImpress) - Len(xTxt2)) + xConteudo + Space(nColSpc)
					Else
						xTxt2 		+= xConteudo + Space(nColSpc)
					EndIf 
				EndIf
			Next nX  
			xTxt1	+= xTxt2    
			    
		    If lSobrepoe      
		    	aLogVld[nPosLg] := xTxt1  
		    Else     		    	 
		    	AADD( aLogVld , xTxt1 )   
		    EndIf     	
    ElseIf lError .And. nPosReg > 0  .And. nErro > 0 // Arquivos invalidos NAO importados        	
		RecLock('TRP',.F.)
		TRP->OK := "N"
		TRP->(MSUnlock())
    	// ESPECIFICOS
		If cAliasArq == "RGB" .Or. cAliasArq == "SRC"
			For nX := 1 to Len(aReg[nPosReg]) 
				cLinha+= aRegSv[nPosReg][nX]
			Next nX 					
		   	If nErro == 1 	// Quantidade lancamentos excedida 
	    		cLog := "Funcionario NÃO possui quantidade permitida de lancamentos para essa verba."  //"Funcionario NÃO possui quantidade permitida de lancamentos para essa verba."	    							  
				UAddErrLog(cLog, cLinha, nPosReg)										
		  	ElseIf nErro == 2 // Nao permite lancamento diario 
		   		cLog := "Verba nao permite lancamento diario."  //"Verba nao permite lancamento diario."  
				UAddErrLog(cLinha, cLog, nPosReg)					
		  	ElseIf  nErro == 3 // Nao sobrepoe lancamento que nao for do tipo "G"   
		    	cLog := "Nao e permitido sobrepor lancamentos que nao sejam do tipo 'Gerado'"  //"Nao e permitido sobrepor lancamentos que nao sejam do tipo "Gerado"." 
				UAddErrLog(cLog, cLinha, nPosReg)
		  	EndIf		  	
		EndIf    
	
		If cAliasArq == "RHO" 
			For nX := 1 to Len(aReg[nPosReg]) 
				cLinha+= aRegSv[nPosReg][nX]
			Next nX 					
		    If nErro == 1 	// Registro ja existe 
		    	cLog := "Registro não sera importado pois ja existe. Para sobrescrever, ative o parâmetro." //""Registro não sera importado pois ja existe. Para sobrescrever, ative o parâmetro."
				UAddErrLog(cLog, cLinha, nPosReg)	
			EndIf
		EndIf    	
	
		If cAliasArq == "SRK" 
			For nX := 1 to Len(aReg[nPosReg]) 
				cLinha+= aRegSv[nPosReg][nX]
			Next nX 					
		    If nErro == 1 	// Registro ja existe 
		    	cLog := "Registro não sera importado pois ja existe. Para sobrescrever, ative o parâmetro." //""Registro não sera importado pois ja existe. Para sobrescrever, ative o parâmetro."
				UAddErrLog(cLinha, cLog, nPosReg)	
			EndIf
		EndIf 
	EndIf		
 
	RestArea(aArea)    
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fDesc210 ³ Autor ³ Equipe RH             ³ Data ³ 17/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Busca opcao descritiva de combo do campo.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA210                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/  
Static Function UDesc210(cOpc, cCpo)    
Local aArea	:= GetArea() 
Local cDesc	:= ""    

	If cCpo == "RHO_TPFOR"  
		Do Case 
			Case cOpc == "1" 
				cDesc:= "Assist.Medica"
			Case cOpc == "2" 
				cDesc:= "Assist.Odont." 
		End Case
	ElseIf cCpo == "RHO_ORIGEM"
		Do Case 
			Case cOpc == "1" 
				cDesc:= "Titular" // "Titular"
			Case cOpc == "2" 
				cDesc:= "Dependente" // "Dependente"
			Case cOpc == "3" 
				cDesc:= "Agregado" // "Agregado"
		End Case				
	EndIf

	RestArea(aArea)

Return( cDesc )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ A210Form ³ Autor ³ Wiliam                ³ Data ³ 18/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina para tratamento da formula.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA210                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function U210Form( cFormula,Txt )
Local bErro      := ErrorBlock( { |e| U210Error( e ) } )
Local lResult    := .T.
Local cEnd
	
	cFormula := AllTrim( cFormula )
	If Len(cFormula) > 0
	    lResult := U210Exec( @cFormula )
	EndIf     
	
	ErrorBlock( bErro ) 
	
	If ValType(cFormula)=="N"
	    cFormula := Str(cFormula)
	ElseIf	ValType(cFormula)=="D"   
		cFormula := DtoC(cFormula) 
	EndIf
	
	If !lResult
	    cFormula := "ERRO"
	EndIf

Return ( cFormula )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ A210Exec ³ Autor ³ Wiliam                ³ Data ³ 18/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Executa a formula e retorna o resultado.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA210                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function U210Exec( cFormula )

	Local lRet
	
	Begin Sequence
	    cFormula := &(cFormula)
	    lRet := .T.
		Recover
	    lRet := .F.
	End Sequence

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ A210Error ³ Autor ³ Wiliam               ³ Data ³ 18/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina para tratamento de erros da formula.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA210                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function U210Error( oError )

	If oError:gencode > 0
		Help(" ",1,"U210FORM") // "A formula do parametro de importacao de valores variaveis esta com erro."       
		Break
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ fAcha	³ Autor ³ Andreia dos Santos	³ Data ³ 17/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna conteudo do campo informado.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ GPEA210  												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UAcha(cAlias,cChave,nOrdem,cCpoRet)

	Local cRet     
	Local cOldAlias := Alias()
	Local nOldOrdem := SRA->( IndexOrd())
	
	
	cRet := Posicione(cAlias,nOrdem,cChave,cCpoRet) 
	
	If cAlias == "SRA"  
		dbSelectArea("SRA")
		SRA->(DbSetOrder(nOrdem))
		cArqChave := SRA->(IndexKey())
		While SRA->(!EoF()) .And. AllTrim(cChave) == AllTrim(&(cArqChave))
			If SRA->RA_SITFOLH == "D"
				SRA->(DbSkip())
				Loop
			EndIf
			cRet := &(cCpoRet)
			Exit
		EndDo	
		SRA->(DbSetOrder(nOldOrdem))
		dbSelectArea(cOldAlias)
	EndIf

Return(cRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ GP210SXB  ³ Autor ³ Equipe RH            ³ Data ³ 28/05/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Constroi F3 para tabela RFJ.				                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA210                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function UGP210SXB( cTabela, cCpoRet )
Local aArea			:= GetArea()
Local aObject 		:= {}              
Local aSize 		:= {}  
Local aCordW 		:= {125,0,400,635} 
Local aSvRot 		:= Nil       
Local aCGD			:= {}
Local cCampo
Local cCaption
Local cPict
Local cValid
Local cF3
Local cWhen    
Local cBlkGet
Local cBlkWhen    
Local cBlkVld     
Local cSvField		:= &(ReadVar())
Local cMyCpo 		:= ""   
Local cLineOk 		:= "AllwaysTrue()"
Local cAllOk  		:= "AllwaysTrue()"
Local cCpoAux		:= "" 
Local cPesq    		:= Space(30)    
Local lDelGetD 		:= .F. 
Local lAllOk 
Local lExist   		:= .F.
Local nCpoRet 		:= 0
Local nOpca	   		:= 0 
Local nObject
Local nAuxWidth 	:= 0
Local nCount 		:= 0
Local nOpcx			:= 7 
Local nX
Local nY
Local nLargSay
Local nLargGet
Local nCntCmb 		:= 0
Local nMaxCmb 		:= 5	//# Nr.Maximo de opcoes no Combo
Local nPos 			:= At("+", cCpoRet )  
Local oDlg  
Local oSay
Local oGet 
Local oSaveGetdad 	:= Nil
Local oTop
Local oBottom
Local i
Local uConteudo 

Private aCombo  	:= {}
Private aMyCombo	:= {}
Private aSXBCols   	:= {}
Private aSXBHeader 	:= {}
Private aC 			:= {}  
Private aColsBkp 	:= {}
Private cCombo  	:= "" 
Private cFilRFJ  	:= ""
Private cDescRFJ 	:= ""   
Private cTitulo 	:= ""
Private lPesqComp 	:= .F. //Variavel que indica se a pesquisa esta sendo feita com mais de um campo
Private lCheck		
Private nUsado  	:= 0 
Private nMax 		:= 0   
Private oCombo
Private oPesq
Private oBtn1
Private oCheckBox  
// OBSERVACAO IMPORTANTE
// Ao serem incluidos novos alias, campo Filial
// devera ser incluido nessa variavel para montagem
// do F3 com filtro  
Private cCposFiltros	:= "RGB_FILIAL*RHO_FILIAL*RK_FILIAL*RC_FILIAL"

	If cTabela == Nil.Or. cCpoRet == Nil
		MsgAlert(OemToAnsi("Atencao"),OemToAnsi("Nao e possivel continuar pois faltam parametros nesta funcao!"))	//"Atencao"###"Nao e possivel continuar pois faltam parametros nesta funcao!"
		Return(.F.)
	EndIf

	If nPos > 0
		lPesqComp := .T.
	EndIf

	cFilRFJ  := xFilial("RFJ")
	cDescRFJ := OemToAnsi(STR0001)

	// Posiciona no RFJ
	dbSelectArea("RFJ")
   
	// Monta conteudo dos objetos
	U210MonCol(cTabela,xFilial("FJ")) 

	// Variaveis inicializadas no teste
	cTitulo		:= cTabela+" - "+cDescRFJ
	nMax 		:= Len(aSXBCols)
	aColsBkp 	:= aClone(aSXBCols)
	
	// Variaveis inicializadas no teste
	AADD(aC,{"cMyCpo", {15,001},"",,,,.F.,})     

	// Variaveis inicializadas no teste
	nCount++
	__cLineOk := cLineOK
	__nOpcx	 := nOpcx
	If nCount > 1
		oSaveGetdad := oGetDados
		oSaveGetdad:oBrowse:lDisablePaint := .t.
	EndIf

	oGets := {}  
	
	If Type("aRotina") == "A"
		aSvRot := aClone(aRotina)
	EndIf
	aRotina := {}
	For nX := 1 to nOpcX
		AADD(aRotina,{"","",0,nOpcx})
	Next

	aCGD	:=Iif(Len(aCGD)==0,{34,5,128,315},aCGD)

	DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitulo) FROM aCordW[1],aCordW[2] TO aCordW[3],aCordW[4] PIXEL OF oMainWnd
        
		If Len(aC) > 0			
		
			For nX := 1 to Len(aSXBHeader)				
				// Monta o aCombo 
				AADD( aCombo, Alltrim(aSXBHeader[nX][1]) )
				aAdd( aMyCombo, {Alltrim(aSXBHeader[nX][1]),Alltrim(aSXBHeader[nX][2])} )		
			Next nX
   			
			@ 000,000 SCROLLBOX oTop
			Aadd(aSize,aCGD[1]+13)
			Aadd(aObject,oTop)
			nObject := 2
					
			@ 005,005 SAY OemToAnsi("Pesquisar por: ") SIZE 35,07 OF oTop PIXEL	//"Pesquisar por: "
			@ 005,045 MSCOMBOBOX oCombo VAR cCombo ITEMS aCombo SIZE 080,010 OF oTop PIXEL  			
			@ 005,145 MSGET oPesq VAR cPesq PICTURE "@!" VALID Iif(!Empty(cCombo),PesqDados(cPesq),fValPesq()) SIZE 80,10 OF oTop PIXEL 						
			@ 013,475 BTNBMP oBtn1 RESOURCE "btpesq" SIZE 025,025 OF oTop PIXEL ACTION ( PesqDados(cPesq) )			
			
			For i:=1 to Len(aC)
				cCampo:=aC[i,1]
				nX:=aC[i,2,1]-13
				nY:=aC[i,2,2]
				cCaption:=Iif(Empty(aC[i,3])," ",aC[i,3])
				cPict:=Iif(Empty(aC[i,4]),Nil,aC[i,4])
				cValid:=Iif(Empty(aC[i,5]),".T.",aC[i,5])
				cF3:=Iif(Empty(aC[i,6]),NIL,aC[i,6])
				cWhen    := Iif(aC[i,7]==NIL,".T.",Iif(aC[i,7],".T.",".F."))
				cWhen    := Iif(!(Str(nOpcx,1,0)$"346"),".F.",cWhen)
				cBlKSay  := "{|| OemToAnsi('"+cCaption+"')}"
				
				oSay     := TSay():New( nX+1, nY, &cBlkSay,oTop,,, .F., .F., .F., .T.,,,,, .F., .F., .F., .F., .F. )
				nLargSay := GetTextWidth(0,cCaption) / 1.8  // estava 2.2
				cCaption := oSay:cCaption
				
				cBlkGet  := "{ | u | If( PCount() == 0, "+cCampo+","+cCampo+":= u ) }"
				cBlKVld  := "{|| "+cValid+"}"
				cBlKWhen := "{|| "+cWhen+"}"
							
				oGet := TGet():New( nX, nY+nLargSay,&cBlKGet,oTop,,,cPict, &(cBlkVld),,,, .F.,, .T.,, .F., &(cBlkWhen), .F., .F.,, .F., .F. ,cF3,(cCampo))
				AADD(oGets,oGet)
			Next
		EndIf

		oGetDados := MsNewGetDados():New(aCGD[1],;			// nTop
										 aCGD[2],;   		// nLelft
										 aCGD[3],; 			// nBottom
			                             aCGD[4],;			// nRright
										 Nil,;	    		// controle do que podera ser realizado na GetDado - nstyle
										 "SXBMod2LOk()",;	// Funcao para validar a edicao da linha - ulinhaOK  (funcao no GPEA310)
										 "AllwaysTrue()",;	// Funcao para validar todas os registros da GetDados - uTudoOK
		  								 Nil,;				// cIniCPOS
										 Nil,;		        // aAlter
										 0,; 				// nfreeze
										 nMax,;  			// nMax
										 Nil,;		 		// cFieldOK
										 Nil,;				// usuperdel
										 .F.,;	        	// udelOK
										 @oDlg,;        	// objeto de dialogo - oWnd
										 @aSXBHeader,;		// Vetor com Colunas - AparHeader
										 @aSXBCols;			// Vetor com Header - AparCols
							)
		
		AADD(aObject,oGetDados:oBrowse)
		AADD(aSize,Nil)

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT (EnchoiceBar(oDlg,{||nOpca:=1,lAllOk:=__Mod2OK(cAllOk),Iif(lAllOk,oDlg:End(),nOpca:=0)},{||oDlg:End()},,),;
									AlignObject(oDlg,aObject,1,nObject,aSize),oGetDados:oBrowse:Refresh())

	nCount--
	If nCount > 0
		oGetDados := oSaveGetDad
		oGetDados:oBrowse:lDisablePaint := .f.
	EndIf
	If ValType(aSvRot) == "A"
		aRotina := aClone(aSvRot)
	EndIf

	If nOpca == 1 .And. Len(aSXBCols) > 0
		If !lPesqComp
			nCpoRet := GdFieldPos(cCpoRet, aSXBHeader)
			VAR_IXB  := aSXBCols[oGetDados:nAt,nCpoRet]
		Else         
			VAR_IXB := ""	
			While lPesqComp
				cCpoAux := Substr(cCpoRet, 1, nPos - 1)
				cCpoRet := Substr(cCpoRet, nPos +1)    
	
				nCpoRet := GdFieldPos(cCpoAux, aSXBHeader)
				VAR_IXB += aSXBCols[oGetDados:nAt,nCpoRet]
	
				nPos := At("+", cCpoRet )
				lPesqComp := If (nPos > 0, .T., .F.)
				
				If nPos == 0
					nCpoRet := GdFieldPos(cCpoRet, aSXBHeader)
					VAR_IXB += aSXBCols[oGetDados:nAt,nCpoRet]
				EndIf
			EndDo
		EndIf
	Else
		VAR_IXB := cSvField
		RestArea(aArea)
		Return .T.
	EndIf

RestArea( aArea )

Return(nOpca == 1)   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ GP210MontaCols ³ Autor ³ Equipe RH        ³ Data ³  22/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta aCols com campos para o F3 RFJ.				          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GPEA210 									                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
Static Function U210MonCol(cTab,cFilRFJ)   
Local aArea	  		:= GetArea()
Local nCont			:= 0    
Local nCnt
Local nQtdLin		:= 7000
Local uValor

    // Monta aHeader
	dbSelectArea("SX3")
	dbSetOrder(1) // X3_ARQUIVO + X3_ORIGEM	  
	If SX3->(dbSeek(cTab))
		While !Eof() .And. SX3->X3_ARQUIVO == cTab		
			If AllTrim(SX3->X3_CAMPO) $ "RFJ_FILIAL*RFJ_CODIGO*RFJ_DESC*RGJ_TBDEST"
				aAdd(aSXBHeader,{ 	SX3->X3_TITULO, ;	//# 01
									SX3->X3_CAMPO, ;	//# 02
									SX3->X3_PICTURE, ;	//# 03
									SX3->X3_TAMANHO, ;	//# 04
									SX3->X3_DECIMAL, ;	//# 05
									Nil, ;				//# 06
									Nil, ;				//# 07
									SX3->X3_TIPO, ;		//# 08
									Nil,  ;	     		//# 09
									SX3->X3_CONTEXT } )	//# 10 Real ou Virtual  
							
			EndIf
			dbSkip()
		EndDo 
	EndIf 
	
	// Monta aCols
	dbSelectArea( "RFJ" )
	RFJ->( dbSetOrder( 1 ) )	// RFJ_FILIAL + RFJ_CODIGO 
	If RFJ->(dbSeek(cFilRFJ))
		While ! Eof() .And. RFJ->RFJ_FILIAL == ( cFilRFJ  ) 
			If allTrim(RFJ->RFJ_CPO) $ cCposFiltros // Campos 'Filial' dos alias destino	 	
				AADD(aSXBCols,Array(Len(aSXBHeader)+1))
				For nCnt := 1 To Len(aSXBHeader)	
					cCampo := Alltrim(aSXBHeader[nCnt,02])		
						If aSXBHeader[nCnt,08] == "N"
							uValor := Val( RFJ->&(cCampo) )
						ElseIf aSXBHeader[nCnt,08] == "D"
							uValor := Ctod( RFJ->&(cCampo) )
						Else
							uValor := RFJ->&(cCampo)
						EndIf
						aSXBCols[Len(aSXBCols)][nCnt] := uValor		  
				Next nCnt
				aSXBCols[Len(aSXBCols)][Len(aSXBHeader)+1] := .F.
				nCont += 1
				If nCont > nQtdLin
					Exit
				EndIf 
			EndIf
			dbSkip()
		EndDo  
	EndIf  

	RestArea( aArea )

Return   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Gp210SetVar   ³ Autor ³ Raquel Hager		     ³ Data ³28/05/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Seta variavel cRot a ser utilizada em gpRCHFiltro pelo F3 RCH.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ F3 Roteiro                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function U210SetVar(cCampo,cPerg)

	If cCampo == 'cProcesso'
		cProcesso := cPerg 
	Else
		cRot := cPerg    
	EndIf

Return (.T.)    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Gp210Valid    ³ Autor ³ Raquel Hager		     ³ Data ³28/05/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida numero de pagamento.									   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ X1_VALID - mv_par04                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function U210Valid(cProcesso,cRoteiro,cPer,cNumPg)    
Local aArea		:= GetArea()
Local lRet 		:= .T.                   
    
	If !Empty(cNumPg)	
		DbSelectArea( "RCH" )
		DbSetOrder( 4 ) // RCH_FILIAL + RCH_PROCESSO + RCH_ROTEIRO + RCH_PERIODO + RCH_NUMPAG
		If !RCH->(DbSeek(xFilial("RCH")+cProcesso+cRoteiro+cPer+cNumPg))  
			Help( " ", 1, "REGNOIS" )
			lRet 	 := .F. 
		EndIf  
	EndIf 

RestArea(aArea)

Return ( lRet )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fGp210ComPg   ³ Autor ³ Raquel Hager		     ³ Data ³ 18/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida competencia valida(RHO).  							   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA210						                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function U210ComPg(cProcesso, cCatfunc)
Local aArea		:= GetArea() 
Local aPerAtual	:= {} 
Local lRet		:= .T.
Local cMesAtual := ""
Local cRoteiro    := If(cCatfunc $ 'A|P',fGetCalcRot('9'),fGetCalcRot('1'))						

Default cProcesso := ""
Default cCatfunc  := ""

	If Type("aPerAtual") == "U" .or. Empty(aPerAtual) .or. !(aPerAtual[1,8] == cProcesso)
	   	If fGetPerAtual( @aPerAtual, xFilial("RCH"), cProcesso, cRoteiro )
			cMesAtual := AnoMes(aPerAtual[1,6])
		Else
			lRet := .F.
		EndIf
	EndIf

    If lRet .and. cComPg < cMesAtual
    	lRet := .F.
    EndIf

RestArea( aArea )
	
Return( lRet )    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ gpa210Ok      ³ Autor ³ Equipe RH 		     ³ Data ³18/06/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Confirma configuracao de parametros. 						   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA210						                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Ugpa210Ok()
Return (MsgYesNo(OemToAnsi("Atencao"),OemToAnsi("Confirma configuracao dos parametros?"))) // "Confirma configuracao dos parametros?"##"Atencao"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ gpa210VldSRK      ³ Autor ³ Alberto.M 		 ³ Data ³30/10/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida os dados de uma linha (nX) do arquivo de importação      ³±±
±±³          ³ para SRK, retorna .T. se houve alguma inconsistencia na linha.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA210						                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function U210VldSRK(nY,;// Numero do campo que esta sendo analisado do aCampos.
                             nX,;// Numero da linha do arquivo de importacao.
                             cConteudo,;// Conteudo do campo que esta sendo validado.
                             cCodFil,;// Filial utilizada na validacao do campo.
                             aAux;// Array temporario onde os dados estao sendo guardado.
                             )


Local cTblAuxSRK
Local cCombSRK
Local cData
Local nDataDia    := 0
Local nDataMes    := 0
Local nDataAno    := 0
Local cCampoSRK   := ""
Local cRoteirSRK  := ""
Local cIndSRK     := ""
Local nIndAuxSRK


Do Case
	  		//Validacao dos campos Vr. Principal, Nr.Parcelas, Juros Pagos, Horas Lanc,
	  		//Juros Mes, Juros Ano e Num. Pagto.
	  		Case aCampos[nY][1] == &("aCpsVld"+cAliasArq)[6] .Or.;
	  			 aCampos[nY][1] == &("aCpsVld"+cAliasArq)[7] .Or.; 
	  			 aCampos[nY][1] == &("aCpsVld"+cAliasArq)[8] .Or.;
	  			 aCampos[nY][1] == &("aCpsVld"+cAliasArq)[14] .Or.;
	  			 aCampos[nY][1] == &("aCpsVld"+cAliasArq)[15] .Or.;
	  			 aCampos[nY][1] == &("aCpsVld"+cAliasArq)[16] .Or.;
	  			 aCampos[nY][1] == &("aCpsVld"+cAliasArq)[20]
	  			 
	  			 Do Case
	  			 	Case aCampos[nY][1] == &("aCpsVld"+cAliasArq)[6]
	  			 		cCampoSRK := "RK_VALORTO"
	  			 	Case aCampos[nY][1] == &("aCpsVld"+cAliasArq)[7]
	  			 		cCampoSRK := "RK_PARCELA"
	  			 	Case aCampos[nY][1] == &("aCpsVld"+cAliasArq)[8]
	  			 	   cCampoSRK := "RK_PGJUROS"
	  			 	Case aCampos[nY][1] == &("aCpsVld"+cAliasArq)[14] 
	  			 	   cCamposSRK := "RK_HORAS"
	  			 	Case aCampos[nY][1] == &("aCpsVld"+cAliasArq)[15] 
	  			 	   cCamposSRK := "RK_JUROMES"
	  			    Case aCampos[nY][1] == &("aCpsVld"+cAliasArq)[16]
	  			    	cCampoSRK := "RK_JUROANO"
	  			    Case aCampos[nY][1] == &("aCpsVld"+cAliasArq)[20]
	  			    	cCampoSRK := "RK_NUMPAGO" 
	  			 EndCase
	  			    
	  			    If Valtype(&(cConteudo)) == "N" //Verifica se a informacao e numerica.
	  			    	If (aCampos[nY][1] == &("aCpsVld"+cAliasArq)[15] .Or.; //Verificacao dos campos juros mes e juros ano
	  			 		    aCampos[nY][1] == &("aCpsVld"+cAliasArq)[16])
	  			 		    	If ( &(cConteudo) > 1000 ) .Or. ( &(cConteudo) < 0 )//Verifica se juros ultrapassam os valores permitidos
									Return(.T.)
								EndIf
						Else // Verificacao do restante dos campos, nao tolerar valores negativas.
							If &(cConteudo) < 0 .Or. PictureIsExploded(cCampoSRK , &(cConteudo)) 
								Return(.T.)
							EndIf
						EndIf
					Else //Nao e numerico
						Return(.T.)
					EndIf
					
				//Guarda o valor total, número de parcelas, Juros mes, Juros ano e Numero do Pagamento.
				Do Case
	  			 	Case aCampos[nY][1] == &("aCpsVld"+cAliasArq)[6]
	  			 		nVlTotSRK := Val(cConteudo)
	  			 	Case aCampos[nY][1] == &("aCpsVld"+cAliasArq)[7]
	  			 		nNumParcSRK := Val(cConteudo)
	  			 	Case aCampos[nY][1] == &("aCpsVld"+cAliasArq)[15] 
	  			 	   nJurMesSRK := Val(cConteudo)
	  			    Case aCampos[nY][1] == &("aCpsVld"+cAliasArq)[16]
	  			    	nJurAnoSRK := Val(cConteudo)
	  			    Case aCampos[nY][1] == &("aCpsVld"+cAliasArq)[20]
	  			    	 cNumPagSRK := cConteudo
	  			 EndCase

			//Validacao dos campos Cod. Posto, Verba Juros.		
	  		Case (aCampos[nY][1] == &("aCpsVld"+cAliasArq)[5]) .Or.; 
	  			  aCampos[nY][1] == &("aCpsVld"+cAliasArq)[12]
	  			     
               	 cTblAuxSRK := If(aCampos[nY][1] == &("aCpsVld"+cAliasArq)[5] , "SRV" , "RCL")
	  			     nIndAuxSRK := If(aCampos[nY][1] == &("aCpsVld"+cAliasArq)[5] , 1 , 2) 
	  			      
	  				dbSelectArea(cTblAuxSRK)
					(cTblAuxSRK)->(dbSetOrder(nIndAuxSRK))
					cFilPd	:= xFilial(cTblAuxSRK,cCodFil)
					
					If !((cTblAuxSRK)->(dbSeek(cFilPd + cConteudo))) 
							Return(.T.)
	  				EndIf
	  				
	  				If aCampos[nY][1] == &("aCpsVld"+cAliasArq)[5]
						lVrbJurSRK := .T. // Indica se o campo Verba Juros foi preenchido corretamente.	  					
	  				EndIf
	  												
	  		//Validacao dos campos Reg.Desconto, Emp. Cons., Quitar Lanc.e Status
	  		Case aCampos[nY][1] == &("aCpsVld"+cAliasArq)[9] .Or.; 
	  			 aCampos[nY][1] == &("aCpsVld"+cAliasArq)[11] .Or.; 
	  			 aCampos[nY][1] == &("aCpsVld"+cAliasArq)[10] .Or.;
	  			 aCampos[nY][1] == &("aCpsVld"+cAliasArq)[19] 
	  				 
	  				 cCombSRK := If ( aCampos[nY][1] == &("aCpsVld"+cAliasArq)[10] , "1*2*3" , "1*2" )
	  				 cCombSRK := If ( aCampos[nY][1] == &("aCpsVld"+cAliasArq)[19] , "1*2*3*4" , cCombSRK )
	  				
	  				If !(cConteudo $ cCombSRK) 
						Return(.T.) 								 
	  				EndIf
	  			
	  		//Validacao do campo Per. Inicio
			Case aCampos[nY][1] == &("aCpsVld"+cAliasArq)[13]
				dbSelectArea("RFQ")
				DbSetOrder(1) //RFQ_FILIAL+RFQ_PROCES+RFQ_PERIOD+RFQ_NUMPAG+DTOS(RFQ_DTINI)+DTOS(RFQ_DTFIM)+RFQ_MODULO
				cFilPd	:= xFilial("RFQ",cCodFil) 					
				//Verifica se o periodo existe e se ainda esta em aberto.
				If (RFQ->(dbSeek(cFilPd + cProcesSRK + cConteudo + cNumPagSRK)))
					If (RFQ->RFQ_STATUS == "2") //Verificar se o periodo esta com todos os roteiros fechados.
						Return(.T.)
					EndIf
				Else				
					Return(.T.)					 												
	    		EndIf
						
			//Validacao dos campos Data Movimento e Data Vencimento	
			Case aCampos[nY][1] == &("aCpsVld"+cAliasArq)[18] .Or.;
				aCampos[nY][1] == &("aCpsVld"+cAliasArq)[17]
				  
			  	If "/" $ cConteudo
					cConteudo := StrTran(cConteudo,"/","")
				EndIf
				 
				nDataDia := Val(Substr(cConteudo,1,2))
				nDataMes := Val(Substr(cConteudo,3,2)) 
				nDataAno := Val(Substr(cConteudo,5, Len(cConteudo)))
				 
				If nDataDia < 1 .Or. nDataDia > 31 .Or. nDataMes < 1 .Or. nDataMes > 12 .Or. nDataAno < 1900 .Or. ;
				 	 nDataDia * nDataMes * nDataAno == 0 // Nao deixa nenhum valor ser igual a zero. 
				 	 Return(.T.)
				EndIf 
	
	  		EndCase 
  				  					  					  					  			
Return(.F.)
	  			  			
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ gpa210ClcParc      ³ Autor ³ Alberto.M 		 ³ Data ³30/10/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Calculo das parcelas com juros, baseado na funcao fCalcVrParc do³±±
±±³          ³ GPEA110.PRX, para importar os dados para SRK.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA210						                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function U210ClParc(nValPrinc,;// Valor Principal.
                              nNrParcela,;// Numero de Parcelas.
                              nPercJrMes,;// Percentual de Juro Mes.
                              nX;// Numero da linha que esta sendo analisada
                              )

Local nFator1			:= 0 
Local nFator2			:= 0 
Local nVlrParc		:= 0 				// Valor Parcela 
Local nVlrResid		:= 0				// Valor do Residuo das parcelas 
Local nJuros			:= 0

DEFAULT nValPrinc 	:= 0
DEFAULT nNrParcela	:= 0
DEFAULT nPercJrMes	:= 0  

	/*	nFator => Percentual aplicado ao valor Principal para calcular-se o valor da parcela mensal,  que deverá ter o mesmo valor
		          em  todas as parcelas, ja com os juros mensais informados.
		i:= Jrs ao mes 
		n:= Periodo (Meses)

		nFator :=      [ { ( 1 + i)^n  } * i ]  
    	               ----------------------   
       	             [ { (1+i)^n } -1  ]                     */   

		If nPercJrMes > 0 //Se houver Juros Mes, calcula o valor da parcela ja com o juros 
			nFator1 				:= (( 1 + (nPercJrMes/100) )** nNrParcela  )
			nFator2			    := ( ( 1 + (nPercJrMes/100) )** nNrParcela  ) -1 
			nFator 			    := ( nPercJrMes/100) * ( (nFator1 /nFator2))
			nVlrParc   		    := NoRound(( nFator * nValPrinc ) , 2)	//Valor da Parcela com o Juros 
			nJuros					:= nVlrParc - ( nValPrinc / nNrParcela )  //Valor da parcela de juros
			If !(lVrbJurSRK)	//Nao esta com a verba de juros preenchido, nao ira preencher os campos referentes ao juros
				nValParSRK := nVlrParc
				nValResSRK := nVlrResid
				nValJurSRK := 0
				nParcJurSRK := 0
			Else //Esta com a verba de juros preenchido, ira preencher os campos referentes ao juros.
				nValParSRK := nVlrParc - nJuros
				nValResSRK := nVlrResid
				nValJurSRK := nJuros * nNrParcela
				nParcJurSRK := nJuros	
			EndIf
		Else //Calculo Simpes da parcela, quando nao existe o juro mes.
			nVlrParc  := NoRound( (nValPrinc)/(nNrParcela) , 2 )
			nVlrResid := NoRound( (nValPrinc) - (nVlrParc)*nNrParcela , 2 )
			
			nValParSRK := nVlrParc
			nValResSRK := nVlrResid
			nValJurSRK := 0
			nParcJurSRK := 0
		EndIf
			
Return()   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ gpa21WHEN      ³ Autor ³ Equipe RH 		     ³ Data ³18/06/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Validação de When dos campos, que possuem dependencias .		   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPEA210						                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UGPA21WHEN(cTab,cCampo,cValor,aCpos,cLinha)
	Local lRet 		:= .T.
	Local nPosCpo	:= 0
	
	Default cValor	:= NIL
	Default cCampo	:= NIL
	Default cTab	:= NIL
	
	Do Case
	Case (cTab=="RHO")
		If cCampo=="RHO_CODIGO" .And. Empty(cValor) .And. (nPosCpo:=aScan(aCpos,{|x| x[1] == "RHO_ORIGEM" }))>0
			If SubStr( cLinha,aCpos[nPosCpo][2],aCpos[nPosCpo][3]-aCpos[nPosCpo][2]+1)== "1"
				lRet:= .F.
			EndIf
		EndIf
	Case (cTab=="RGB")
		/*Caso haja alguma validação no futuro da RGB*/
	Case (cTab=="SRC")
	OtherWise
		/*Trecho caso seja necessário para outro tratamento*/
	EndCase
Return lRet

/*/{Protheus.doc} AddErrLog
	Função responsável por gerenciar as mensagens de erro
	que devem ser adicionadas ao Log;
	Criada para centralizar o tratamento das mensagens de erro.
@author PHILIPE.POMPEU
@since 21/06/2016
@version P12.1.06
@param cMsg, caractere, Mensagem de erro
@param cTitulo, caractere, Título do Erro
@param nLinha, numérico, Número da Linha
@return cResult, retorna a mensagem adicionada
/*/
Static Function UAddErrLog(cMsg,cTitulo,nLinha)
	Local cResult	:= ""
	Default cMsg 	:= ""
	Default nLinha:= 0	
	
	if(Len(aLog[1]) == 0)
		cResult := Space(2)
		cResult += PadR(STR0018	,nColTam) // linha
		cResult += PadC("titulo "	,nColTam * 3) // título
		cResult += PadR("mensagem"	,nColTam * 3) //mensagem 		
		aAdd(aLog[1],OemToAnsi(cResult))
		cResult := ''		
	endIf
		
	cResult := Space(2)
	cResult += PadR(StrZero(nLinha,6),nColTam)
	cResult += PadR(cTitulo	,nColTam * 3)
	cResult += AllTrim(cMsg)
		
	aAdd(aLog[1],OemToAnsi(cResult))	
Return cResult

/*/{Protheus.doc} NextDocSRK
	Obtem o próximo código de documento da tabela SRK com base na matrícula
@author PHILIPE.POMPEU
@since 20/04/2016
@version P11
@param cFil, caractere, filial
@param cMat, caractere, matrícula do funcionário
@return cResult, próximo código
/*/
Static Function UNxtDocSRK(cFil,cMat)
	Local aArea	:= GetArea()
	Local cMyAlias := GetNextAlias()
	Local cQuery	:= ''
	Local nTamSeq := TamSx3("RK_DOCUMEN")[1]
	Local cResult := StrZero(1,nTamSeq)	
		
	cQuery := "SELECT MAX(RK_DOCUMEN) AS SEQUEN FROM "
	cQuery += RetSqlName( "SRK" )
	cQuery += " WHERE RK_FILIAL='"+ xFilial("SRK",cFil)+"' AND RK_MAT ='"+cMat+"'"
	cQuery += " AND D_E_L_E_T_ = ' '"
	
	cQuery	:= ChangeQuery(cQuery)				
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cMyAlias, .F., .T.)
	
	if((cMyAlias)->(! Eof()))	
		if((cMyAlias)->SEQUEN != Nil)
			cResult := StrZero(Val((cMyAlias)->SEQUEN)+ 1,nTamSeq)
		endIf					
	EndIf
		
	(cMyAlias)->(dbCloseArea())
	RestArea(aArea)
Return (cResult)
