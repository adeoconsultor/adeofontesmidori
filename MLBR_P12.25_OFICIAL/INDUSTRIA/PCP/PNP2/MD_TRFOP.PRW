#INCLUDE "PROTHEUS.CH"

#define STR0001  "OP's Previstas"
#define STR0002  "Firma OPs"
#define STR0003  "Exclui OPs"
#define STR0004  " Firma as OPs marcadas ?"
#define STR0005  " Deleta as OPs marcadas ?"
#define STR0006  "Selecionando Registros..."
#define STR0007  "Pesquisar"
#define STR0008  "Atenção"
#define STR0009  "Todas as OPs intermediárias que possuam vinculo com alguma OP Pai marcada no Browse, serão firmadas, "
#define STR0010  "devido o sistema estar parametrizado para trabalhar com produção automática (MV_PRODAUT habilitado). "
#define STR0011  "Deseja continuar o processo ?"
#define STR0012  "Sim"
#define STR0013  "Não"
#define STR0014  "Deletando OP's previstas..."
#define STR0015  "Deletando SC's previstas..."
#define STR0016  "Deletando PC's/CP's previstos..."
/*
Esta Rotina fara a transformacao do Plano de Producao em Ordem de Producao Firme, verificando as autorizacoes
Lancadas eletronicamente. Especifico Midori Atlantica
*/
User Function MD_TRFORD()
Local	nI			:= 0
Local 	aCampos		:= {}
Private cMarca 		:= GetMark()
Private nOrdemAtual := 4

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa  ³
//³ ----------- Elementos contidos por dimensao ------------ ³
//³ 1. Nome a aparecer no cabecalho                          ³
//³ 2. Nome da Rotina associada                              ³
//³ 3. Usado pela rotina                                     ³
//³ 4. Tipo de Transa‡„o a ser efetuada                      ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados         ³
//³    2 - Simplesmente Mostra os Campos                     ³
//³    3 - Inclui registros no Bancos de Dados               ³
//³    4 - Altera o registro corrente                        ³
//³    5 - Remove o registro corrente do Banco de Dados      ³
//³    6 - Altera determinados campos sem incluir novos Regs ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCadastro := OemToAnsi(STR0001)	//"OP's Previstas"

Private aRotina := {	{STR0002,"A651Firma",0,4},;		//"Firma OPs"
{STR0007,"A651PEsqui",0,1},; 	//"Pesquisar"
{STR0003,"A651Deleta",0,5} }	//"Exclui OPs"

Private aIndTmp 	:= {}
Private aSavMTA652  := Array(9)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de variaveis para rotina de inclusao automatica    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private l651Auto := .F.
Private nOpc := 3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // De  Produto                           ³
//³ mv_par02            // Ate Produto                           ³
//³ mv_par03            // De  Ordem de Producao                 ³
//³ mv_par04            // Ate Ordem de Producao                 ³
//³ mv_par05            // De  Data de Entrega                   ³
//³ mv_par06            // Ate Data de Entrega                   ³
//³ mv_par07            // De  Data de Inicio                    ³
//³ mv_par08            // Ate Data de Inicio                    ³
//³ mv_par09            // Firma OPs Intermediarias              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()

If Pergunte("MTA652",.T.)
	For ni := 1 to 9
		aSavMTA652[ni] := &("mv_par"+StrZero(ni,2))
	Next ni
	
	dbSelectArea("SC2")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o arquivo conforme perguntas antes de mostrar     ³
	//³ o browse                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Filtra_A651() // Invertido pra manter o padrao
	dbGoTop()
	//
	MarkBrow("SC2","C2_OK", ,               , ,cMarca)
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna indices do SC2                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SC2")
aEval(aIndTmp, {|cFile| fErase(cFile+OrdBagExt())})
dbClearFilter()

RETURN

//----------------------------
/*
A funcao abaixo tem como objetivo filtrar a tabela SC2 de acordo com as ordens efetivamente liberadas
*/
Static FUNCTION Filtra_A651( nOrder )

LOCAL cIndice,nInd,cFirmaCond:=""
Local cNomeInd:=CriaTrab(NIL,.F.)
nOrder := If(nOrder=Nil,10,nOrder)

Aadd(aIndTmp, cNomeInd)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera index de trabalho do SC2                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC2")
dbSetOrder(nOrder)
cIndice   := Indexkey()
cFirmaCond += 'C2_FILIAL=="'+xFilial("SC2")+'".And.C2_TPOP=="'+"P"+'".And.'
cFirmaCond += 'C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD>="'+aSavMTA652[03]+'".And.C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD<="'+aSavMTA652[04]+'".And.'
cFirmaCond += 'dTos(C2_DATPRF)>="'+dTos(aSavMTA652[05])+'".And.dTos(C2_DATPRF)<="'+dTos(aSavMTA652[06])+'".And.'
cFirmaCond += 'C2_PRODUTO>="'+aSavMTA652[01]+'".And.C2_PRODUTO<="'+aSavMTA652[02]+'".And. C2_LIBER ="OK" .AND.  '
cFirmaCond += 'dTos(C2_DATPRI)>="'+dTos(aSavMTA652[07])+'".And.dTos(C2_DATPRI)<="'+dTos(aSavMTA652[08])+'"'
IndRegua("SC2",cNomeInd,cIndice,,cFirmaCond,STR0006)	//"Selecionando Registros..."
nInd := RetIndex("SC2")
#IFNDEF TOP
	dbSetIndex(cNomeInd+OrdBagExt())
#ENDIF
dbSetOrder(nInd+1)
Return
//--------------------------------------
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AjustaSX1 ºAutor³Felipe Nunes Toledo   º Data ³ 14/05/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA651                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aHelpPor :={}
Local aHelpEng :={}
Local aHelpSpa :={}

/*-----------------------MV_PAR09--------------------------*/
Aadd( aHelpPor, "Firma automaticamente as OPs filhas,       ")
Aadd( aHelpPor, "caso a OP Pai seja firmada.                ")
Aadd( aHelpPor, "Observação: Caso o sistema esteja          ")
Aadd( aHelpPor, "configurado para trabalhar com produção    ")
Aadd( aHelpPor, "automática (MV_PRODAUT = .T.), todas as    ")
Aadd( aHelpPor, "OPs filhas serão firmadas, independente    ")
Aadd( aHelpPor, "da opção selecionada nessa pergunta.       ")

Aadd( aHelpEng, "Firm automatically intermediary POs        ")
Aadd( aHelpEng, "if the parent PO is confirmed.             ")
Aadd( aHelpEng, "Note: if the system is configured to       ")
Aadd( aHelpEng, "work with automatic production             ")
Aadd( aHelpEng, "(MV_PRODAUT = .T.), all intermediary POs   ")
Aadd( aHelpEng, "will be confirmed, irrespective of the     ")
Aadd( aHelpEng, "option selected in this question.          ")

Aadd( aHelpSpa, "¿Confirma automaticamente las OP           ")
Aadd( aHelpSpa, "intermedias si se confirma la OP principal.")
Aadd( aHelpSpa, "Observacion: si el sistema esta configurado")
Aadd( aHelpSpa, "con produccion automatica (MV_PRODAUT =.T.)")
Aadd( aHelpSpa, " ,se confirmaran todas las OP intermedias, ")
Aadd( aHelpSpa, "independientemente de la opcion            ")
Aadd( aHelpSpa, "seleccionada em esta pergunta.             ")

PutSx1( "MTA652","09","Firma OPs Intermediarias ?","¿Confirma OPs intermedias ?","Firm Intermediary POs ?","mv_ch9",;
"N",1,0,1,"C","","","","S","mv_par09","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

Return Nil
//---------------------------
// A funcao abaixo impede que haja o alerta de geracao das OPS intermediarias
//
User Function MTA650OK()
//Return( .F. )

Return( .t. )
//---------------------------

user function MA650TOK()
local cGrupo := ' ' //Grupo de produtos
local lLado  := .F. //Verificar se os itens do cadastro controla lado
local aProd  := {}
local nKgOld := 0
Local cGrp := Space(4)
Local lRet := .T.     
Local I

cQG1 := " SELECT Count(*) NREG FROM "+RetSqlName("SG1")+" WHERE D_E_L_E_T_ =' ' AND G1_FILIAL = '"+xFilial("SG1")+"' " 
cQG1 += " AND G1_COD = '"+M->C2_PRODUTO+"' " 
if Select("TMPG1") > 0 
	dbSelectArea("TMPG1")
	TMPG1->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", TcGenQry(, , cQG1), "TMPG1", .T., .T. )
dbSelectArea("TMPG1")
TMPG1->(dbGotop())

//lRet := Posicione("SG1",1,xFilial("SG1")+SC2->C2_PRODUTO,"G1_COD") == SC2->C2_PRODUTO

if TMPG1->NREG == 0 .And. !Rtrim(M->C2_PRODUTO) $ 'MANUTENCAO'
	Alert("O Produto "+ALLTRIM(M->C2_PRODUTO)+" não possui estrutura cadastrada!!"+chr(13)+"Favor verificar procurar dpto engenharia de processo...","ATENÇÃO - FALTA DE ESTRUTURA")
	lRet := .F. 
	Return lRet
endif                        

//Ponto de entrada para tratar obrigatoriedade de preenchimento do campo de Kg quando o produto for do grupo 32
//e se for retrabalho = NAO   
//Vinicius de Sousa Schwartz - TI - Midori Atlantica em 20/04/2012
If cFilAnt == '09'
	
	//Verificar grupo do produto
	dbSelectArea('SB1')
	dbSetOrder(1)
	dbSeek(xFilial('SB1')+M->C2_PRODUTO)
	cGrp := SB1->B1_GRUPO
	
	//Validacao do preenchimento do campo KG
	If (cGrp == '32  ' .Or. cGrp == '32A ') .and. M->C2_OPRETRA == 'N' .and. M->C2_X_KG > 0
		lRet := .T.
	else
		if (cGrp == '32  ' .Or. cGrp == '32A ') .and. M->C2_OPRETRA == 'N' .and. M->C2_X_KG == 0 
		Alert ('Kg não informado. Favor informar!')
		lRet := .F.
		return lRet
		else
			if (cGrp == '32  ' .Or. cGrp == '32A ') .and. M->C2_OPRETRA == 'S' .and. M->C2_X_KG > 0
				Alert ('Não deve ser informado KG para retrabalho. Favor zerar o campo KG!')
				//lRet := .F. linha desativada nova receita de retrabalho consome quimico automatico baseado no KG do couro
				// desativado por Diego em 18/12			   
				lRet := .T.
			else
				lRet := .T.
			endif
		endif	
	endif
		 
	//Validacao preenchimento campo C2_X_KGTI
	If (cGrp == '38B ' .OR. cGrp == '38C ' .OR. cGrp == '38D ' .OR. cGrp == '38F ' .OR.;
		cGrp == '39B ' .OR. cGrp == '39C ' .OR. cGrp == '39D ' .OR. cGrp == '39F ') .and. M->C2_X_KGTI == 0
		Alert ('Kg Tinta não informado. Favor informar!')
		lRet := .F.
	else
		lRet := .T.
   	endif
	
EndIf	


//Validação em caso de alteracao de OP para nao deixar alterar o Kg, somente pela rotina especifica VSS_AJEMP
If cFilant == '09'	
	if Altera
		dbSelectArea('SC2')
		dbSetOrder(1)
		if dbSeek(xFilial('SC2')+M->C2_NUM)
			nKgOld:= SC2->C2_X_KG
	//		Alert('Quilo anterior -> ' +cValToChar(nKgOld)+' Quilo Atual-> '+cValToChar(M->C2_X_KG))	
			if nKgOld <> M->C2_X_KG
				Alert('O Kg não pode ser alterado!!! Somente pela rotina de Ajuste de Empenho!') 
				M->C2_X_KG := nkgOld
				lRet := .F.
			endif
		endif
	endif        
Endif
//Fim de tratamento Vinicius	



if cFilant == '09' 
	cGrupo := Posicione('SB1',1,xFilial('SB1')+M->C2_PRODUTO,'B1_GRUPO')
	if cGrupo $ '39C |39D |39F '
		if M->C2_X_FASE = space(1)
			Alert('Voce precisa informar a FASE de apontamento, Campo FASE APTO'+chr(13);
				+'Informe:'+Chr(13);
				+' 	1=Primeira Mao'+Chr(13);
				+'	2=Segunda Mao'+Chr(13);
				+' 	R=Retrabalho')
				lRet := .F.
		endif
	endif
endif

if cFilant == '08' 
//	Alert('Verificando grupo...') 
	cQuery:= "SELECT G1_COMP FROM SG1010 WHERE D_E_L_E_T_ = ' ' AND G1_FILIAL='"+xFilial("SG1")+"' AND G1_COD = '"+M->C2_PRODUTO+"' " 

	if select('TRBG1') > 0
		DbSelectArea( 'TRBG1' )
		DbCloseArea()
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBG1',.T.,.T. )

	dbSelectArea("TRBG1")
	DbGoTop()
    while !TRBG1->(eof())
    	lLado:= Posicione("SB1",1,xFilial("SB1")+TRBG1->G1_COMP,"B1_LADO") $ 'A|B'
    	AADD(aProd, {TRBG1->G1_COMP})
    	TRBG1->(dbSkip())
    enddo 
    if !lLado
	    for i:=1  to len(aProd)
    		dbSelectArea('SG1')
    		dbSetOrder(1)
	    	dbSeek(xFilial('SG1')+aProd[i][1])
    		while !SG1->(eof()).and.SG1->G1_COD == aProd[i][1]
				if !lLado
					lLado := Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_LADO") $ 'A|B'
				endif
    		SG1->(dbSkip())
    	   	enddo
    	 next i
    endif
endif
if lLado 
	M->C2_LADO := 'S' 
else
	M->C2_LADO := 'N' 
endif

//  Diego Silva - 28/08/2012
//  Rotina desenvolvida para evitar a utilizacao de armazens indevidos nas unidades de costura.
if cFilant == '04' .or. cFilant == '19'
	
	cArmLocal := GetMv('MA_ARMCOST') // RECEBE OS ARMAZENS HABILITADOS PARA MOVIMENTACAO NAS UNDIADES DE COSTURA
	
	if !M->C2_LOCAL $ cArmLocal 
		alert('Armazém não cadastrado para abertura de OP. Favor alterar o armazém '+M->C2_LOCAL+' para um válido ou solicite ao Administrador para incluir este novo armazém no parâmetro MA_ARMCOST. ';
				+'Armazéns válidos: '+cArmLocal)
		lRet := .F.
	EndIf
Endif

if cFilant == "09"
	lRet := U_vlddrwbk()
EndIf
 

//validação para checar se no cadastro do complemento do produto o cliente possui PPAP(BZ_X_PPAP='1' (Sim)) para as filiais 08 E 19
//ANTONIO - 30/01/18
If cFilant == "08" .Or. cFilAnt == "19"
	
	If Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_GRUPO") $ '51OM|51AF'
		SBZ->(dbSetOrder(1))  
		If SBZ->( !dbSeek(xFilial("SC2") + M->C2_PRODUTO) )
			HS_MSGINF("Produto não possui PPAP, favor entrar em contato com o Depto de Qualidade/PNP2!!!","Atenção","Inclusão da OP")
			lRet := .F.
		Else
			If SBZ->BZ_X_PPAP == '2'
				HS_MSGINF("Produto não possui PPAP, favor entrar em contato com o Depto de Qualidade/PNP2!!!","Atenção","Inclusão da OP")
				lRet := .F.
			EndIf
		EndIf
	Endif

EndIf


Return lRet
