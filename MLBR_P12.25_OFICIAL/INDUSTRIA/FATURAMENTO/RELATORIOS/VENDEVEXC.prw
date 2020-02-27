#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
// Programa   	VENDEVEXC()
// Autor 		Claudinei E.Nascimento Data: 20/01/10
// Data 		29/05/10
// Descricao  	Gera arquivo excel com informacoes de vendas e/ou devolucoes somente
//				para notas que geram duplicatas no financeiro. Serao desconsideradas
//				devolucoes diferentes do tipo D e/ou se a nota desconsidrar geracao
//				duplicatas.
//				O grupo considerado no relatorio sera o grupo padrao do cadastro de
//				produto conhecido como grupo contabil pela sra.Patricia-Fiscal ao
//				inves do grupo Midori.
//				As vendas serao geradas pela data de emissao da nota fiscal e as
//				devolucoes pela data de digitacao da nota fiscal
// Uso         	Midori Atlantica
// Alterações	Alexandre Dalpiaz
//				Incluido parametro para relatorio analitico ou sintetico

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
user function VENDEVEXC()
//////////////////////////
//Criacao de variaveis 
Local nHdlLock
Local aDados := {}

SetPrvt("cQryVD,aArea,aSays,aButtons,nOpc,cTitulo,cPerg,cArqCSV,nArqCSV")
SetPrvt("cTipoRel,dDtEmissDe,dDtEmissAte,cCliDe,cLjCliDe,cCliAte,cLjCliAte,cForneDe,cLjForDe,cForneAte,cLjForAte")
SetPrvt("cProdDe,cProdAte,cGrProdDe,cGrProdAte,cFilDe,cFilAte")

//Inicializacao de variaveis
aArea := GetArea() //
aSays := {} //
aButtons := {} //
nOpc := 0 //
cTitulo := OemToAnsi("Geração de arquivo de vendas e devolução")
cPerg := PADR("VENDEVEXCL", 10) //Grupo de pergunta que sera gravado no campo X1_GRUPO

/*
-----------------------------------------------------------------------------------------------
Semáforo para utilização unica da rotina 
-> Não permite o acesso simultaneo da rotina por mais de um usuário
-----------------------------------------------------------------------------------------------

If ( nHdlLock := MSFCreate("VENDEVEXC.L"+cEmpAnt)) < 0
	ApMsgAlert(	"A geração do relatorio esta sendo utilizada por"				+ chr(13)+chr(10)+;
	"outro usuário. Por questões de integridade/perfomance dos dados, não"		+ chr(13)+chr(10)+;
	"é permitida a utilização desta rotina por mais de um usuário"				+ chr(13)+chr(10)+;
	"simultaneamente. Tente novamente mais tarde.","Vendas e Devoluções")
	Return
Else
	/*
	-----------------------------------------------------------------------------------------------
	Grava no semáforo informações sobre quem está utilizando a Rotina de Comprovantes
	-----------------------------------------------------------------------------------------------
	
	FWrite(nHdlLock,"Operador: "+substr(cUsuario,7,15)+chr(13)+chr(10)+;
	"Empresa.: "+cEmpAnt+chr(13)+chr(10)+;
	"Filial..: "+cFilAnt+chr(13)+chr(10))
Endif
*/
CriaPerg(cPerg) //Cria perguntas no SX1-Arquivos de perguntas

//Tela com mensagem informativa ao usuario sobre o programa
aAdd(aSays,OemToAnsi("Gerará arquivo com dados de produtos vendidos e devolvidos em um período."))
aAdd(aSays,OemToAnsi("As saídas são pela emissão da nota fiscal e devoluções pela data de digitação."))
//aAdd(aSays,OemToAnsi("as notas fiscais deverão gerar duplicatas e o campo Grp Midori do cadastro de  "))
//aAdd(aSays,OemToAnsi("deverão estar preenchidos.                                                     "))
//aAdd(aSays,OemToAnsi("                                                                               "))
aAdd(aButtons, { 5, .T., {|| Pergunte(cPerg,.T. ) } } ) //Busca grupo de perguntas e os exibe ao usuario, apos selecionar botao parametros
aAdd(aButtons, { 1, .T., {|o| nOpc := 1, IF(gpconfOK(), FechaBatch(), nOpc:=0) }} ) //Se selecionar botao Ok fecha tela de entrada
aAdd(aButtons, { 2, .T., {|o| FechaBatch() }} ) //Se selecionado botao Cancelar, fecha tela de entrada e retorna para tela principal

FormBatch(cTitulo,aSays,aButtons) //Exibe Tela de entrada

IF ( nOpc == 1 )
	Processa({|| BUSCADADOS()},"Buscando dados","Por favor, aguarde...",.T.) //Chama rotina que localiza dados no banco de dados
EndIF
RestArea(aArea) //Restaura o ambiente de arquivo
return(nil)


////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
static function BUSCADADOS()
////////////////////////////

//Carrega parametros para variaveis
cFilDe 		:= mv_par01 //Filial
cFilAte 	:= mv_par02 //Filial
cTipoRel 	:= mv_par03 //Tipo do relatorio: Vendas, Devolucoes ou Ambos
dDtEmissDe 	:= DToS(mv_par04) //Data de Emissao: para Vendas sera Emissao da Nota fiscal e para Devolucoes sera Data Digitacao
dDtEmissAte := DToS(mv_par05) //Data de Emissao: para Vendas sera Emissao da Nota fiscal e para Devolucoes sera Data Digitacao
cCliDe 		:= mv_par06 //Codigo cliente inicial: Sera considerado quando cTipoRel for 1-Vendas ou 3-Ambos
cLjCliDe 	:= mv_par07 //Codigo loja do cliente final: Sera considerado quando cTipoRel for 1-Vendas ou 3-Ambos
cCliAte 	:= mv_par08 //Codigo cliente final: Sera considerado quando cTipoRel for 1-Vendas ou 3-Ambos
cLjCliAte 	:= mv_par09 //Codigo loja cliente final: Sera considerado quando cTipoRel for 1-Vendas ou 3-Ambos
cProdDe 	:= AllTrim(mv_par10) //Codigo do produto inicial
cProdAte 	:= AllTrim(mv_par11) //Codigo do produto final
cGrProdDe 	:= AllTrim(mv_par12) //Codigo do grupo contabil do produto inicial
cGrProdAte 	:= AllTrim(mv_par13) //Codigo do grupo contabil do produto final
_cEnter 	:= chr(13) + chr(10)

procregua(0)
_cQuery := ''

If mv_par14 == 2	//relatório sintetico
	_cQuery += _cEnter + "SELECT FILIAL, TIPO, CLIENTE, LOJA, EMISSAO, NFISCAL, NOME, SUM(TOTAL) TOTAL, "
	_cQuery += _cEnter + " SUM(VALORICM) VALORICM, SUM(VALORIPI) VALORIPI, SUM(VALORPIS) VALORPIS, SUM(VALORCOFINS) VALORCOFINS, CF, TES "
	_cQuery += _cEnter + "FROM ("
EndIf

if cTipoRel <>  2 //Se o tipo do relatorio for Ambos ou Vendas
	
	_cQuery += _cEnter + "SELECT DISTINCT D2.D2_FILIAL FILIAL ,F2.F2_TIPO TIPO, D2.D2_EMISSAO EMISSAO,"
	_cQuery += _cEnter + "D2.D2_DOC NFISCAL, F2.F2_CHVNFE CHVNFE, D2.D2_ITEM ITEM, D2.D2_SERIE SERIE, D2.D2_CLIENTE CLIENTE, D2.D2_LOJA LOJA, A1.A1_NOME NOME, "
	_cQuery += _cEnter + "B1.B1_GRUPO GRUPO, BM.BM_DESC DESCR_GRUPO, B1.B1_MIGRMID GRUPO_MIDORI, FT.FT_DESCONT DESCONTO, FT.FT_BASEPIS BASEPIS,"
	_cQuery += _cEnter + "FT.FT_FRETE FRETE, FT.FT_SEGURO SEGURO, FT.FT_DESPESA DESPESA,"
	_cQuery += _cEnter + "FT.FT_BASECOF BASECOF, FT.FT_CSTPIS CSTPIS, FT.FT_CSTCOF CSTCOF, FT.FT_CODBCC CODBCC, FT.FT_OBSERV OBSERVACAO,"
	_cQuery += _cEnter + " ' ' MOTIVO, " 
	_cQuery += _cEnter + "FT.FT_VRETPIS VRETPIS, FT.FT_VRETCOF VRETCOF, FT.FT_ARETPIS ARETPIS, FT.FT_ARETCOF ARETCOF, FT_CONTA, "
	_cQuery += _cEnter + "(CASE WHEN D2.D2_EST <> 'EX' THEN 'Interno-' ELSE 'Exportacao-' END) + BM1.BM_DESC AS BMDESC, "
	_cQuery += _cEnter + "D2.D2_COD PRODUTO, B1.B1_DESC DESCRICAO, B1.B1_UM UM,"
	_cQuery += _cEnter + "FT.FT_POSIPI NCM, D2.D2_QUANT QUANTIDADE, D2.D2_TOTAL TOTAL, FT.FT_VALCONT VLRCONTAB, FT.FT_TOTAL - FT.FT_DESCONT VLRLIQ,"
	_cQuery += _cEnter + "D2.D2_VALICM VALORICM, D2.D2_VALIPI VALORIPI, D2.D2_ICMSRET ICMSRET, D2.D2_TIPO TIPO, D2.D2_VALISS VALORISS, "
	
	_cQuery += _cEnter + "CASE WHEN D2.D2_EST = 'EX' OR B1.B1_MIGRMID = '9911' OR B1.B1_GRUPO = '90' OR "
//	_cQuery += _cEnter + "D2.D2_CF IN ('5501','6501','5502','6502') THEN 0 ELSE (D2.D2_TOTAL * 0.0165) END AS VALORPIS, "
	_cQuery += _cEnter + "D2.D2_CF IN ('5501','6501','5502','6502') THEN 0 ELSE (D2.D2_VALIMP6) END AS VALORPIS, "
	
	_cQuery += _cEnter + "CASE WHEN D2.D2_EST = 'EX' OR B1.B1_MIGRMID = '9911' OR B1.B1_GRUPO = '90' OR "
//	_cQuery += _cEnter + "D2.D2_CF IN ('5501','6501','5502','6502') THEN 0 ELSE (D2.D2_TOTAL * 0.0760) END AS VALORCOFINS, "
	_cQuery += _cEnter + "D2.D2_CF IN ('5501','6501','5502','6502') THEN 0 ELSE (D2.D2_VALIMP5) END AS VALORCOFINS, "
		
	_cQuery += _cEnter + "A1.A1_EST UF, D2.D2_TES TES, D2.D2_CF CF, F4.F4_TEXTO TEXTO, 'S' TIPOMOV"
	
	_cQuery += _cEnter + " FROM " + RetSQLName("SD2") + " D2 WITH(NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSQLName("SF2") + " F2 WITH(NOLOCK)"
	_cQuery += _cEnter + " ON F2.D_E_L_E_T_ =''"
	_cQuery += _cEnter + " AND F2.F2_FILIAL = D2.D2_FILIAL"
	_cQuery += _cEnter + " AND F2.F2_DOC = D2.D2_DOC"
	_cQuery += _cEnter + " AND F2.F2_CLIENTE = D2.D2_CLIENTE "
	_cQuery += _cEnter + " AND F2.F2_LOJA = D2.D2_LOJA"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSQLName("SB1") + " B1 WITH(NOLOCK)"
	_cQuery += _cEnter + " ON B1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND B1.B1_COD = D2.D2_COD"
	
	_cQuery += _cEnter + " LEFT JOIN " + RetSQLName("SF4")  + " F4 WITH(NOLOCK)"
	_cQuery += _cEnter + " ON F4.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND F4.F4_CODIGO=D2.D2_TES"
//	_cQuery += _cEnter + " AND F4.F4_FILIAL=D2.D2_FILIAL"      - Comentado por ter unificado as TES
	
	_cQuery += _cEnter + " LEFT JOIN " + RetSQLName("SFT") + " FT WITH(NOLOCK)"
	_cQuery += _cEnter + " ON FT.D_E_L_E_T_ =''"
	_cQuery += _cEnter + " AND FT.FT_FILIAL = D2.D2_FILIAL"
	_cQuery += _cEnter + " AND FT.FT_NFISCAL = D2.D2_DOC"
	_cQuery += _cEnter + " AND SUBSTRING(FT.FT_ITEM,1,2) = D2.D2_ITEM"
	_cQuery += _cEnter + " AND FT.FT_CLIEFOR = D2.D2_CLIENTE"
	_cQuery += _cEnter + " AND FT.FT_LOJA = D2.D2_LOJA"
	_cQuery += _cEnter + " AND [FT_OBSERV] <> 'NF CANCELADA'"
	
	_cQuery += _cEnter + " LEFT JOIN "  + RetSQLName("SBM")  + " BM WITH(NOLOCK)"
	_cQuery += _cEnter + " ON BM.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND BM.BM_GRUPO = B1.B1_GRUPO"
	
	_cQuery += _cEnter + " LEFT JOIN "  + RetSQLName("SBM")  + " BM1 WITH(NOLOCK)"
	_cQuery += _cEnter + " ON BM1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND BM1.BM_GRUPO = B1.B1_MIGRMID"
	
	_cQuery += _cEnter + " LEFT JOIN "  + RetSQLName("SA1") + " A1 WITH(NOLOCK)"
	_cQuery += _cEnter + " ON A1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND A1.A1_COD = D2.D2_CLIENTE"
	_cQuery += _cEnter + " AND A1.A1_LOJA = D2.D2_LOJA"
	
	_cQuery += _cEnter + " WHERE D2.D_E_L_E_T_='' "
	_cQuery += _cEnter + " AND D2.D2_FILIAL  BETWEEN '" + cFilDe     + "' AND '" + cFilAte     + "'"
	_cQuery += _cEnter + " AND D2.D2_EMISSAO BETWEEN '" + dDtEmissDe + "' AND '" + dDtEmissAte + "'"
	_cQuery += _cEnter + " AND D2.D2_CLIENTE BETWEEN '" + cCliDe     + "' AND '" + cCliAte     + "'"
	_cQuery += _cEnter + " AND D2.D2_LOJA    BETWEEN '" + cLjCliDe   + "' AND '" + cLjCliAte   + "'"
	_cQuery += _cEnter + " AND D2.D2_COD     BETWEEN '" + cProdDe    + "' AND '" + cProdAte    + "'"
	_cQuery += _cEnter + " AND B1.B1_GRUPO   BETWEEN '" + cGrProdDe  + "' AND '" + cGrProdAte  + "' "
	_cQuery += _cEnter + " AND D2.D2_CF NOT IN ('5601','5602')"
	//	_cQuery += _cEnter + " AND ( D2_TIPO <> 'P' AND Substring(D2_CF,1,1) not in ('5','6','7')) "
	_cQuery += _cEnter + " AND F4.F4_DUPLIC = 'S'" //A nota fiscal deve gerar duplicata no financeiro
	_cQuery += _cEnter + " AND F2.F2_TIPO NOT IN ('D','B')"
	
EndIf

If cTipoRel == 3	// Ambos = vendas + devoluções
	_cQuery += _cEnter + " UNION ALL"  //Seleciona dados de devolucao conforme data de digitacao da nota fiscal e somente se gerar duplicatas no financeiro
EndIf

If cTipoRel <> 1	// ambos ou devolucoes//CAST(ROUND(SalesYTD/CommissionPCT, 0) AS int)
	
	_cQuery += _cEnter + " SELECT DISTINCT D1.D1_FILIAL FILIAL, F1.F1_TIPO TIPO, D1.D1_DTDIGIT EMISSAO, "
	_cQuery += _cEnter + " D1.D1_DOC NFISCAL, F1.F1_CHVNFE CHVNFE, D1.D1_ITEM ITEM, D1.D1_SERIE SERIE, D1.D1_FORNECE CLIENTE, D1.D1_LOJA LOJA, A1.A1_NOME NOME, "
	_cQuery += _cEnter + " B1.B1_GRUPO GRUPO, BM.BM_DESC DESCR_GRUPO, B1.B1_MIGRMID GRUPO_MIDORI, FT.FT_DESCONT DESCONTO, FT.FT_BASEPIS BASEPIS,"
	_cQuery += _cEnter + " FT.FT_FRETE FRETE, FT.FT_SEGURO SEGURO, FT.FT_DESPESA DESPESA,"
	_cQuery += _cEnter + " FT.FT_BASECOF BASECOF, FT.FT_CSTPIS CSTPIS, FT.FT_CSTCOF CSTCOF, FT.FT_CODBCC CODBCC, FT.FT_OBSERV OBSERVACAO,"
	_cQuery += _cEnter + " CASE WHEN D1_X_ORIDE = '01' THEN 'QUALIDADE' WHEN D1_X_ORIDE = '02' THEN 'COMERCIAL' WHEN D1_X_ORIDE = '03' THEN 'LOGISTICA' ELSE 'OUTROS' END MOTIVO, " 
	_cQuery += _cEnter + " FT.FT_VRETPIS VRETPIS, FT.FT_VRETCOF VRETCOF, FT.FT_ARETPIS ARETPIS, FT.FT_ARETCOF ARETCOF, FT_CONTA, "	
	_cQuery += _cEnter + " CASE WHEN A1.A1_EST <> 'EX' THEN 'Interno-' ELSE 'Exportacao-' END +BM1.BM_DESC AS BMDESC, "
	_cQuery += _cEnter + " D1.D1_COD PRODUTO, B1.B1_DESC DESCRICAO, B1.B1_UM UM,"
	_cQuery += _cEnter + " FT.FT_POSIPI NCM, D1.D1_QUANT QUANTIDADE, D1.D1_TOTAL TOTAL, FT.FT_VALCONT VLRCONTAB, FT.FT_TOTAL - FT.FT_DESCONT VLRLIQ,"
	_cQuery += _cEnter + " D1.D1_VALICM VALORICM, D1.D1_VALIPI VALORIPI, D1.D1_ICMSRET ICMSRET, D1.D1_TIPO TIPO, D1.D1_VALISS VALORISS, " "
	
//	_cQuery += _cEnter + "	CASE WHEN A1.A1_EST = 'EX' THEN 0 ELSE (D1.D1_TOTAL * 0.0165) END AS VALORPIS,  "
	_cQuery += _cEnter + "	CASE WHEN A1.A1_EST = 'EX' THEN 0 ELSE (D1.D1_VALIMP6) END AS VALORPIS,  "	
	
//	_cQuery += _cEnter + "	CASE WHEN A1.A1_EST = 'EX' THEN 0 ELSE (D1.D1_TOTAL * 0.0760) END AS VALORCOFINS, "
	_cQuery += _cEnter + "	CASE WHEN A1.A1_EST = 'EX' THEN 0 ELSE (D1.D1_VALIMP5) END AS VALORCOFINS, "	
	
	_cQuery += _cEnter + " A1.A1_EST UF, D1.D1_TES TES, D1.D1_CF CF, F4.F4_TEXTO TEXTO, 'E' TIPOMOV"
	
	_cQuery += _cEnter + " FROM " + RetSQLName("SD1") + " D1 WITH(NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSQLName("SF1") + " F1 WITH(NOLOCK)"
	_cQuery += _cEnter + " ON F1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND F1.F1_FILIAL = D1.D1_FILIAL"
	_cQuery += _cEnter + " AND F1.F1_DOC = D1.D1_DOC"
	_cQuery += _cEnter + " AND F1.F1_FORNECE = D1.D1_FORNECE"
	_cQuery += _cEnter + " AND F1.F1_LOJA = D1.D1_LOJA"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSQLName("SB1") + " B1 WITH(NOLOCK)"
	_cQuery += _cEnter + " ON B1.D_E_L_E_T_= ''"
	_cQuery += _cEnter + " AND B1.B1_COD = D1.D1_COD"
	
	_cQuery += _cEnter + " LEFT JOIN "+RetSQLName("SF4") + " F4 WITH(NOLOCK)"
	_cQuery += _cEnter + " ON F4.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND F4.F4_CODIGO=D1.D1_TES"
//	_cQuery += _cEnter + " AND F4.F4_FILIAL=D1.D1_FILIAL"  - Comentado por ter unificado as TES
	
	_cQuery += _cEnter + " LEFT JOIN " + RetSQLName("SFT") + " FT WITH(NOLOCK)"
	_cQuery += _cEnter + " ON FT.D_E_L_E_T_= ''"
	_cQuery += _cEnter + " AND FT.FT_FILIAL = D1.D1_FILIAL"
	_cQuery += _cEnter + " AND FT.FT_NFISCAL = D1.D1_DOC"
	_cQuery += _cEnter + " AND FT.FT_ITEM = D1.D1_ITEM"
	_cQuery += _cEnter + " AND FT.FT_CLIEFOR = D1.D1_FORNECE"
	_cQuery += _cEnter + " AND FT.FT_LOJA = D1.D1_LOJA"
	_cQuery += _cEnter + " AND [FT_OBSERV] <> 'NF CANCELADA'"
	
	_cQuery += _cEnter + " LEFT JOIN " + RetSQLName("SBM") + " BM WITH(NOLOCK)"
	_cQuery += _cEnter + " ON BM.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND BM.BM_GRUPO = B1.B1_GRUPO"
	
	_cQuery += _cEnter + " LEFT JOIN " + RetSQLName("SBM") + " BM1 WITH(NOLOCK)"
	_cQuery += _cEnter + " ON BM1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND BM1.BM_GRUPO = B1.B1_MIGRMID"
	
	_cQuery += _cEnter + " LEFT JOIN " + RetSQLName("SA1") + " A1 WITH(NOLOCK)"
	_cQuery += _cEnter + " ON A1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND A1.A1_COD = D1.D1_FORNECE"
	_cQuery += _cEnter + " AND A1.A1_LOJA = D1.D1_LOJA"
	
	_cQuery += _cEnter + " WHERE D1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND D1.D1_FILIAL  BETWEEN '" + cFilDe     + "' AND '" + cFilAte     + "'"
	_cQuery += _cEnter + " AND D1.D1_DTDIGIT BETWEEN '" + dDtEmissDe + "' AND '" + dDtEmissAte + "'"
	_cQuery += _cEnter + " AND D1.D1_FORNECE BETWEEN '" + cCliDe     + "' AND '" + cCliAte     + "'"
	_cQuery += _cEnter + " AND D1.D1_LOJA    BETWEEN '" + cLjCliDe   + "' AND '" + cLjCliAte   + "'"
	_cQuery += _cEnter + " AND D1.D1_COD     BETWEEN '" + cProdDe    + "' AND '" + cProdAte    + "'"
	_cQuery += _cEnter + " AND B1.B1_GRUPO   BETWEEN '" + cGrProdDe  + "' AND '" + cGrProdAte  + "'"
	_cQuery += _cEnter + " AND F4.F4_DUPLIC = 'S' " //Notas de devolucao devem gerar duplicatas
	_cQuery += _cEnter + " AND F1.F1_TIPO = 'D' " //Os tipos das nota devem ser 'D-Devolucao'
	_cQuery += _cEnter + " AND D1.D1_CF <> ' ' " //Notas de devolucao somente classificadas
	_cQuery += _cEnter + " AND D1.D1_TES <> ' ' " //Notas de devolucao somente classificadas
	
EndIf

If mv_par14 == 2	//relatório sintetico
	_cQuery += _cEnter + ") A"
	_cQuery += _cEnter + " GROUP BY  FILIAL, TIPO, CLIENTE, LOJA, EMISSAO, NFISCAL, NOME, CF "
EndIf
_cQuery += _cEnter + " ORDER BY 1,2,3,4"

MemoWrit("C:\relato\vendevexc.sql", _cQuery)

cAliasQry := "QRYVD"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasQry,.F.,.T.)

count to _nLastRec
DbGoTop()
if _nLastRec == 0
	Aviso("Atenção","Por favor, dados de vendas inexistentes. Reconfigure os parâmetros informados.", {"Ok"}, 2, "Dados inexistentes!") //informa ao usuario que nao localizou dados na base de dados
	DbCloseArea()
	return
endif

IncProc("Selecionando registros...")
IncProc("Localizando excel...")

GERAEXCEL(cAliasQry) //Chama a rotina geradora do arquivo excel

DbCloseArea()

return(nil)


////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
static function CriaPerg(cPerg)
///////////////////////////////
local _sAlias := Alias()
Local j, i 

dbSelectArea("SX1") //Seleciona a tabela SX1
dbSetOrder(1) //X1_GRUPO+X1_ORDEM
_cPerg := PADR(cPerg, 10)
aRegs := {}
//Grupo   Ord  Pergunta Brasil        Pergunta Espanhol     Pergunta Ingles       VAR_VL   Tipo Tam Dec Pres GSC Validacao      VAR1       DEF1     DEF1     DEF1    CNT1  VAR2  DEF2        DEF2        DEF2        CNT2  VAR3  DEF3    DEF3    DEF3   CNT3  VAR3  DEF3  DEF3  DEF3  CNT4   VAR4  DEF4  DEF4  DEF4  _F3   PYME  GRPSXG  _HELP PICTUR    IDFIL
aAdd(aRegs,{_cPerg,"01","Filial De?         ","¿Filial De?          ","Filial De?        ","mv_ch1", "C", 02, 00, 00,"G","            ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","XM0","","","","99",""})
aAdd(aRegs,{_cPerg,"02","Filial Ate?        ","¿Filial Ate?         ","Filial Ate?       ","mv_ch2", "C", 02, 00, 00,"G","NaoVazio    ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","XM0","","","","99",""})
aAdd(aRegs,{_cPerg,"03","Tipo Relatorio?    ","¿Tipo Relatorio?     ","Tipo Relatorio?    ","mv_ch3", "N", 01, 00, 02,"C","NaoVazio   ","mv_par03","Vendas","Vendas","Vendas","","","Devolucao","Devolucao","Devolucao","","","Ambos","Ambos","Ambos","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"04","Dt Emis NF De?     ","¿Dt Emis NF De?      ","Dt Emis NF De?     ","mv_ch4", "D", 08, 00, 00,"G","            ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"05","Dt Emis NF Ate?    ","¿Dt Emis NF Ate?     ","Dt Emis NF Ate?    ","mv_ch5", "D", 08, 00, 00,"G","NaoVazio    ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{_cPerg,"06","Cliente De?        ","¿Cliente De?         ","Cliente De?        ","mv_ch6", "C", 06, 00, 00,"G","            ","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","","",""})
aAdd(aRegs,{_cPerg,"07","Loja Cli De?       ","¿Loja Cli De?        ","Loja Cli De?       ","mv_ch7", "C", 02, 00, 00,"G","            ","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{_cPerg,"08","Cliente Ate?       ","¿Cliente Ate?        ","Cliente Ate?       ","mv_ch8", "C", 06, 00, 00,"G","NaoVazio    ","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","","",""})
aAdd(aRegs,{_cPerg,"09","Loja Cli Ate?      ","¿Loja Cli Ate?       ","Loja Cli Ate?      ","mv_ch9", "C", 02, 00, 00,"G","NaoVazio    ","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{_cPerg,"10","Produto De?        ","¿Produto De?         ","Produto De?        ","mv_ch1", "C", 15, 00, 00,"G","            ","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","030  ","","",""})
aAdd(aRegs,{_cPerg,"11","Produto Ate?       ","¿Produto Ate?        ","Produto Ate?       ","mv_chb", "C", 15, 00, 00,"G","NaoVazio    ","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","030  ","","",""})
aAdd(aRegs,{_cPerg,"12","Grp Ctb Prod De?   ","¿Grp Ctb Prod De?    ","Grp Ctb Prod De?   ","mv_chc", "C", 04, 00, 00,"G","            ","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","","",""})
aAdd(aRegs,{_cPerg,"13","Grp Ctb Prod Ate?  ","¿Grp Ctb Prod Ate?   ","Grp Ctb Prod Ate?  ","mv_chd", "C", 04, 00, 00,"G","NaoVazio    ","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","","",""})
aAdd(aRegs,{_cPerg,"14","Analítico/Sintético","¿                    ","                   ","mv_che", "N", 01, 00, 01,"C","NaoVazio    ","mv_par14","Analítico","","","","","Sintético","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)     //RESERVA DENTRO DO BANCO DE PERGUNTAS
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()    //SALVA O CONTEUDO DO ARRAY NO BANCO
	Endif
Next

dbSelectArea(_sAlias)

Pergunte(cPerg,.F.)
return(nil)


////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
Static function GERAEXCEL(cAlias)
/////////////////////////////////

//cDir := "C:\SIGAEXCEL\" //Diretorio onde sera gravado o arquivo excel
cEol := CHR(13)+CHR(10)

dbSelectArea(cAlias)
cArqCSV := CriaTrab(NIL,.F.) //Cria arquivo de trabalho temporario
cArqCSV := Alltrim(cArqCSV)+".CSV" //Inclui extensao CSV compativel com excel no arquivo de trabalho

nArqCSV := fCreate(cArqCSV) //Criar arquivo texto com extensao CSV

//Constroi colunas dentro do arquivo texto e finaliza linha da colunas
If mv_par14 == 1	// RELATORIO ANALITICO
	cColunas := "Filial;Tipo NF;Data;Nota;Item;Tipo; Cliente; Loja;Nome Cliente;Tipo;Grupo de Produto;Descrição; Grupo Vendas; Descrição;Cod.Produto;Descrição Produto;UN;NCM;Qtde;" //quatorze colunas
	cColunas += "Total Mercds;Vlr Contabil;IPI;Vlr Liquido;ICMS;Vlr ISS;ICMSRET; Desconto; Frete; Seguro; Despesa; Base PIS; PIS 1,65%;Base Cofins;COFINS 7,6%; TES;CFOP; CSTPIS; CSTCOF; CODBCC; Vlr Ret PIS;Vlr Ret Cofins;Aliq Ret PIS;Aliq Ret Cofins;"
	cColunas +=	"Observacao;MOTIVO;Chave;CContabil;"

Else
	cColunas := "Filial;Tipo NF;Data;Nota;Cliente; Loja;Nome Cliente;" //quatorze colunas
	cColunas += "Total Mercds;Valor Contabil;ICMS;IPI;PIS 1,65%;COFINS 7,6%; CFOP;Chave;"
EndIf
fWrite(nArqCSV, cColunas + cEol)

dbSelectArea(cAlias) //Seta na tabela contendo dados pesquisados
ProcRegua((cAlias)->(RecSize(cAlias)+49))
Do while (cAlias)->(!Eof())
	IncProc("Gerando planilha excel...")
	if Posicione('SF4',1,xFilial('SF4')+AllTrim((cAlias)->TES),"F4_PISCOF") == '4' .and. Posicione('SF4',1,xFilial('SF4')+AllTrim((cAlias)->TES),"F4_PISCRED") == '3'
		nVlrPis := 0
		nVlrCof := 0
	else
		nVlrPis := (cAlias)->VALORPIS
		nVlrCof := (cAlias)->VALORCOFINS
	endif

	If mv_par14 == 1	// RELATORIO ANALITICO
		cLiArqCSV := AllTrim((cAlias)->FILIAL)+";"
		cLiArqCSV += AllTrim((cAlias)->TIPO)+";"
		cLiArqCSV += dtoc(stod((cAlias)->EMISSAO))+";"
		cLiArqCSV += AllTrim((cAlias)->NFISCAL)+ ";"
		cLiArqCSV += AllTrim((cAlias)->ITEM)+ ";"
		cLiArqCSV += AllTrim((cAlias)->TIPO)+";"
		cLiArqCSV += AllTrim((cAlias)->CLIENTE)+";"
		cLiArqCSV += AllTrim((cAlias)->LOJA)+";"
		cLiArqCSV += AllTrim((cAlias)->NOME)+";"
		cLiArqCSV += AllTrim((cAlias)->UF)+";"
		cLiArqCSV += AllTrim((cAlias)->GRUPO)+";"
		cLiArqCSV += AllTrim((cAlias)->DESCR_GRUPO)+";"
		cLiArqCSV += AllTrim((cAlias)->GRUPO_MIDORI)+";"
		cLiArqCSV += AllTrim((cAlias)->BMDESC)+";"
		cLiArqCSV += AllTrim((cAlias)->PRODUTO)+";"
		cLiArqCSV += AllTrim((cAlias)->DESCRICAO)+";"
		cLiArqCSV += AllTrim((cAlias)->UM)+";"
		//cLiArqCSV += AllTrim((cAlias)->NCM)+";"
		cLiArqCSV += Transform((cAlias)->NCM, '@R ####.##.##')+";"
		cLiArqCSV += Transform((cAlias)->QUANTIDADE,  		"@E 99999999.99")+";"
		cLiArqCSV += Transform((cAlias)->TOTAL, 	  		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->VLRCONTAB,  		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->VALORIPI, 	 		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->VLRLIQ, 	  		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->VALORICM, 	 		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->VALORISS, 	 		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->ICMSRET, 	  		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->DESCONTO, 	  		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->FRETE, 	  		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->SEGURO, 	  		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->DESPESA, 	  		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->BASEPIS, 	  		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform(nVlrPis, 	  				"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->BASECOF, 	  		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform(nVlrCof, 					"@E 999,999,999.99")+";"
		cLiArqCSV += AllTrim((cAlias)->TES)+";"
		cLiArqCSV += AllTrim((cAlias)->CF)+";"
		cLiArqCSV += AllTrim((cAlias)->CSTPIS)+";"
		cLiArqCSV += AllTrim((cAlias)->CSTCOF)+";"
		cLiArqCSV += AllTrim((cAlias)->CODBCC)+";"
		cLiArqCSV += Transform((cAlias)->VRETPIS, 	  		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->VRETCOF, 	  		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->ARETPIS, 	  		"@E 999.99")+";"
		cLiArqCSV += Transform((cAlias)->ARETCOF, 	  		"@E 999.99")+";"
		cLiArqCSV += AllTrim((cAlias)->OBSERVACAO)+";"
		cLiArqCSV += ALLTRIM((cAlias)->MOTIVO)+";"
		cLiArqCSV += Transform((cAlias)->CHVNFE,'@R #### ########################################')+";"
		cLiArqCSV += Transform((cAlias)->FT_CONTA,'@!')+";"
		
		//StrTran(cTexto,CHR(13),"")
		//		cLiArqCSV += cValToChar(Posicione("SFT",1,(cAlias)->(FILIAL+TIPOMOV+SERIE+NFISCAL+CLIENTE+LOJA+ITEM+PRODUTO),"FT_BASECOF"))+";"
		//		cLiArqCSV += Posicione("SFT",1,(cAlias)->(FILIAL+TIPOMOV+SERIE+NFISCAL+CLIENTE+LOJA+ITEM+PRODUTO),"FT_CSTPIS")+";"
		//		cLiArqCSV += Posicione("SFT",1,(cAlias)->(FILIAL+TIPOMOV+SERIE+NFISCAL+CLIENTE+LOJA+ITEM+PRODUTO),"FT_CSTCOF")+";"
		//		cLiArqCSV += Posicione("SFT",1,(cAlias)->(FILIAL+TIPOMOV+SERIE+NFISCAL+CLIENTE+LOJA+ITEM+PRODUTO),"FT_CODBCC")+";"
		//		cLiArqCSV += cValToChar(Posicione("SFT",1,(cAlias)->(FILIAL+TIPOMOV+SERIE+NFISCAL+CLIENTE+LOJA+ITEM+PRODUTO),"FT_MALQCOF"))+";"
		//		cLiArqCSV += cValToChar(Posicione("SFT",1,(cAlias)->(FILIAL+TIPOMOV+SERIE+NFISCAL+CLIENTE+LOJA+ITEM+PRODUTO),"FT_MVALCOF"))+";"
		//		cLiArqCSV += Posicione("SFT",1,(cAlias)->(FILIAL+TIPOMOV+SERIE+NFISCAL+CLIENTE+LOJA+ITEM+PRODUTO),"FT_TNATREC")+";"
		//		cLiArqCSV += Posicione("SFT",1,(cAlias)->(FILIAL+TIPOMOV+SERIE+NFISCAL+CLIENTE+LOJA+ITEM+PRODUTO),"FT_CNATREC")+";"
		//		cLiArqCSV += Posicione("SFT",1,(cAlias)->(FILIAL+TIPOMOV+SERIE+NFISCAL+CLIENTE+LOJA+ITEM+PRODUTO),"FT_OBSERV")+";"
		
		//FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO
		//		FT_CSTPIS, FT_CSTCOF, FT_CODBCC, FT_MALQCOF, FT_MVALCOF, FT_TNATREC,FT_CNATREC,
		
	Else		// RELATORIO SINTETICO
		
		cLiArqCSV := AllTrim((cAlias)->FILIAL)+";"
		cLiArqCSV += AllTrim((cAlias)->TIPO)+";"
		cLiArqCSV += dtoc(stod((cAlias)->EMISSAO))+";"
		cLiArqCSV += AllTrim((cAlias)->NFISCAL)+ ";"
		cLiArqCSV += AllTrim((cAlias)->CLIENTE)+";"
		cLiArqCSV += AllTrim((cAlias)->LOJA)+";"
		cLiArqCSV += AllTrim((cAlias)->NOME)+";"
		cLiArqCSV += Transform((cAlias)->TOTAL, "@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->VLRCONTAB, "@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->VALORICM, 	  "@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->VALORIPI, 	  "@E 999,999,999.99")+";"
		cLiArqCSV += Transform(nVlrPis, 	  	"@E 999,999,999.99")+";"
		cLiArqCSV += Transform(nVlrCof, 		"@E 999,999,999.99")+";"
		cLiArqCSV += AllTrim((cAlias)->CF)+";"
		cLiArqCSV += Transform((cAlias)->CHVNFE,'@R #### ########################################')+";"
		cLiArqCSV += Transform((cAlias)->FT_CONTA,'@!')+";"
	EndIf
	
	//		cLiArqCSV += Transform((cAlias)->VALORPIS, 	  "@E 999,999,999.99")+";
	//		cLiArqCSV += Transform((cAlias)->VALORCOFINS, "@E 999,999,999.99")+";
	
	fwrite(nArqCSV, cLiArqCSV+cEol) //Cria arquivo texto com dados necessarios
	(cAlias)->(DbSkip())
	IncProc("Gerando dados para planilha...")
	
EndDo

fclose(nArqCSV) //Fecha arquivo texto para abrir no excel
/*fclose(nHdlLock)
Ferase("VENDEVEXC.L"+cEmpAnt)
*/
If !ApOleClient("MsExcel")
	MsgStop("Por favor instalar o software Microsoft Excel.") //Exibe mensagem ao usuaro caso o excel esteja ausente no computador que esta sendo executado a rotina
	Return
EndIf

cPath := AllTrim(GetTempPath()) //Cria arquivo temporario
CpyS2T(cArqCSV, cPath, .F. ) //Copia o arquivo temporario para estrutura .csv

oExcelApp:= NIL
oExcelApp:= MsExcel():New()
oExcelApp:WorkBooks:Open(cPath+cArqCSV)
oExcelApp:SetVisible(.T.)
lIntExcel:= .T.
oExcelApp:= NIL
return(nil)
