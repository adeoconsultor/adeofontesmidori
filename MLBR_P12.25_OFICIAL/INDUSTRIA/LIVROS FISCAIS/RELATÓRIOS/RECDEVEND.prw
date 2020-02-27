#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} RECDEVEND

@author Willer Trindade
@since 10/12/2014
@version P11
/*
/*/
//-------------------------------------------------------------------
User Function RECDEVEND()
//////////////////////////
//Criacao de variaveis 
Local nHdlLock

SetPrvt("cQryVD,aArea,aSays,aButtons,nOpc,cTitulo,cPerg,cArqCSV,nArqCSV")
SetPrvt("cTipoRel,dDtEmissDe,dDtEmissAte,cCliDe,cLjCliDe,cCliAte,cLjCliAte,cForneDe,cLjForDe,cForneAte,cLjForAte")
SetPrvt("cProdDe,cProdAte,cGrProdDe,cGrProdAte,cFilDe,cFilAte")

//Inicializacao de variaveis
aArea := GetArea() //
aSays := {} //
aButtons := {} //
nOpc := 0 //
cTitulo := OemToAnsi("Geração do Relatorio de Recusa Vendas ou Devoluções de Compras")
cPerg := PADR("RECDEVEND", 10) //Grupo de pergunta que sera gravado no campo X1_GRUPO

CriaPerg(cPerg) //Cria perguntas no SX1-Arquivos de perguntas

//Tela com mensagem informativa ao usuario sobre o programa
aAdd(aSays,OemToAnsi("Gerará arquivo excel com dados de recusas vendas ou devoluções de compras em um período."))
aAdd(aSays,OemToAnsi("Rotina/RECDEVEND - Recusa Venda ou Devoluções de Compra                           "))
aAdd(aButtons, { 5, .T., {|| Pergunte(cPerg,.T. ) } } ) //Busca grupo de perguntas e os exibe ao usuario, apos selecionar botao parametros
aAdd(aButtons, { 1, .T., {|o| nOpc := 1, IF(gpconfOK(), FechaBatch(), nOpc:=0) }} ) //Se selecionar botao Ok fecha tela de entrada
aAdd(aButtons, { 2, .T., {|o| FechaBatch() }} ) //Se selecionado botao Cancelar, fecha tela de entrada e retorna para tela principal

FormBatch(cTitulo,aSays,aButtons) //Exibe Tela de entrada

IF ( nOpc == 1 )
	Processa({|| BUSCADADOS()},"Localizando Dados","Por Favor, Aguarde...",.T.) //Chama rotina que localiza dados no banco de dados
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
cTipoRel 	:= mv_par03 //Tipo do relatorio: Recusa, Devolucoes 
dDtEmissDe 	:= DToS(mv_par04) //Data de Emissao: para Vendas sera Emissao da Nota fiscal e para Devolucoes sera Data Digitacao
dDtEmissAte := DToS(mv_par05) //Data de Emissao: para Vendas sera Emissao da Nota fiscal e para Devolucoes sera Data Digitacao
_cEnter 	:= chr(13) + chr(10)

procregua(0)
_cQuery := ''


if cTipoRel == 1 //RECUSA
	
	_cQuery += _cEnter + "SELECT D1_FILIAL D1FILIAL, D1_DOC D1DOC, D1_SERIE D1SERIE, D2_TIPO D2TIPO, D1_TIPO D1TIPO, D2_CF D2CF, D1_CF D1CF, D1_EMISSAO D1EMISSAO,"
	_cQuery += _cEnter + "D1_TOTAL D1TOTAL, D1_BASIMP5 BSPIS, D1_BASIMP6 D1BSCOF, D1_VALIMP5 D1VLPIS, D1_VALIMP6 D1VLCOF, D1_NFORI D1NFORI, D1_SERIORI D1SERIEORI, D2_EMISSAO D2EMISSAO,"
	_cQuery += _cEnter + "D1_DTDIGIT D1DTDIGIT, D2_TOTAL D2TOTAL, D2_BASIMP5 D2BSPIS, D2_BASIMP6 D2BSCOF, D2_VALIMP5 D2VLPIS, D2_VALIMP6 D2VLCOF, D2_ITEM D2ITEM, D2_DOC D2DOC, D2_SERIE D2SERIE"
	_cQuery += _cEnter + " FROM " + RetSQLName("SD2") + " D2 WITH(NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSQLName("SD1") + " D1 WITH(NOLOCK)"
	_cQuery += _cEnter + " ON D1.D_E_L_E_T_<>'*'"
	_cQuery += _cEnter + " and D1_NFORI = D2_DOC and D1_SERIORI = D2_SERIE"
	_cQuery += _cEnter + " and D1_FORNECE = D2_CLIENTE and D1_LOJA = D2_LOJA"
	_cQuery += _cEnter + " and D1_FILIAL  = D2_FILIAL "
	_cQuery += _cEnter + " and D1_COD = D2_COD"
	_cQuery += _cEnter + " and D1_ITEMORI = D2_ITEM"
	_cQuery += _cEnter + " and D1_CF IN ('1949','2949','3949')"
	_cQuery += _cEnter + " and D1_TIPO = 'D'"
	_cQuery += _cEnter + " WHERE D2.D_E_L_E_T_='' "
	_cQuery += _cEnter + " AND D1.D1_FILIAL  BETWEEN '" + cFilDe     + "' AND '" + cFilAte     + "'"
	_cQuery += _cEnter + " AND D1.D1_DTDIGIT BETWEEN '" + dDtEmissDe + "' AND '" + dDtEmissAte + "'"

	


Else	// devolucoes
	
	_cQuery += _cEnter + "SELECT D2_FILIAL D2FILIAL, D2_DOC D2DOC, D2_SERIE D2SERIE, D2_TIPO D2TIPO, D2_CF D2CF, D2_EMISSAO D2EMISSAO,"
	_cQuery += _cEnter + "D2_TOTAL D2TOTAL, D2_BASIMP5 D2BIMP5, D2_BASIMP6 D2BIMP6, D2_VALIMP5 D2VLIMP5, D2_VALIMP6 D2VLIMP6, D2_NFORI D2NFORI, D2_SERIORI D2SERIORI,D1_EMISSAO D1EMISSAO,D1_DTDIGIT D1DTDIGIT,"
	_cQuery += _cEnter + "D1_TOTAL D1TOTAL, D1_BASIMP5 D1BIMP5, D1_BASIMP6 D1BIMP6, D1_VALIMP5 D1VLIMP5, D1_VALIMP6 D1VLIMP6"
	_cQuery += _cEnter + " FROM " + RetSQLName("SD2") + " D2 WITH(NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSQLName("SD1") + " D1 WITH(NOLOCK)"
	_cQuery += _cEnter + " ON D1.D_E_L_E_T_<>'*'"
	_cQuery += _cEnter + " and D2_NFORI = D1_DOC and D2_SERIORI = D1_SERIE"
	_cQuery += _cEnter + " and D2_CLIENTE = D1_FORNECE and D2_LOJA = D1_LOJA"
	_cQuery += _cEnter + " and D2_FILIAL  = D1_FILIAL"
	_cQuery += _cEnter + " and D2_COD = D1_COD"
	_cQuery += _cEnter + " and D2_ITEMORI = D1_ITEM"
	_cQuery += _cEnter + " and D2_CF in ('5201','5202','5210','5410','5411','5412','5413','5553','5556','5660','5661','5662','6201','6202','6210','6410','6411','6412','6413','6553','6556','6660','6661','6662')"
	
	_cQuery += _cEnter + " WHERE D2.D_E_L_E_T_='' "
	_cQuery += _cEnter + " AND D2.D2_FILIAL  BETWEEN '" + cFilDe     + "' AND '" + cFilAte     + "'"
	_cQuery += _cEnter + " AND D2.D2_EMISSAO BETWEEN '" + dDtEmissDe + "' AND '" + dDtEmissAte + "'"
	
EndIf

_cQuery += _cEnter + " ORDER BY 1,2,3,4"

MemoWrit("C:\relato\recdevend.sql", _cQuery)

cAliasQry := "QRYVD"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasQry,.F.,.T.)

count to _nLastRec
DbGoTop()
if _nLastRec == 0
	Aviso("Atenção","Por favor, dados inexistentes. Reconfigure os parâmetros informados.", {"Ok"}, 2, "Dados inexistentes!") //informa ao usuario que nao localizou dados na base de dados
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
aAdd(aRegs,{_cPerg,"03","Tipo Relatorio?    ","¿Tipo Relatorio?     ","Tipo Relatorio?    ","mv_ch3", "N", 01, 00, 02,"C","NaoVazio   ","mv_par03","Recusa Venda","Recusa Venda","","","","Devoluçao de Compras","Devoluçao de Compras","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"04","Dt Emis NF De?     ","¿Dt Emis NF De?      ","Dt Emis NF De?     ","mv_ch4", "D", 08, 00, 00,"G","            ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"05","Dt Emis NF Ate?    ","¿Dt Emis NF Ate?     ","Dt Emis NF Ate?    ","mv_ch5", "D", 08, 00, 00,"G","NaoVazio    ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
If mv_par03 == 1	// RELATORIO ANALITICO
	cColunas := "Filial;Nota;Serie;Tipo Saida;Tipo Ent;CFO Saida; CFO Ent; Emissao Ent;Total;Base Pis;Base Cof;Vlr PIS; Vlr Cofins; Nota Origem;Serie Orig;Emissao;Dt Digit;Total;Base Pis;Base Cof;Vlr PIS; Vlr Cofins;Item;Nota; Serie;" //quatorze colunas
Else
	cColunas := "Filial;Nota;Serie;Tipo;Cfop; Emissao;Total;Base Pis;Base Cofins;Vlr Pis;Vlr Cofins;Nota Origem; Serie Ori;Emissao;Dt Digit;Total;Base Pis;Base Cofins;Vlr Pis;Vlr Cofins" //quatorze colunas
EndIf
fWrite(nArqCSV, cColunas + cEol)

dbSelectArea(cAlias) //Seta na tabela contendo dados pesquisados
ProcRegua((cAlias)->(RecSize(cAlias)+49))
//ProcRegua(0)
//Preenche o arquivo texto
nVlrPis := 0
nVlrCof := 0
Do while (cAlias)->(!Eof())
	IncProc("Gerando planilha Excel...")

	If mv_par03 == 1	// RELATORIO ANALITICO
		cLiArqCSV := AllTrim((cAlias)->D1FILIAL)+";"
		cLiArqCSV += AllTrim((cAlias)->D1DOC)+";"
		cLiArqCSV += AllTrim((cAlias)->D1SERIE)+ ";"
		cLiArqCSV += AllTrim((cAlias)->D2TIPO)+ ";"
		cLiArqCSV += AllTrim((cAlias)->D1TIPO)+";"
		cLiArqCSV += AllTrim((cAlias)->D2CF)+";"
		cLiArqCSV += AllTrim((cAlias)->D1CF)+";"
		cLiArqCSV += dtoc(stod((cAlias)->D1EMISSAO))+";"
		cLiArqCSV += Transform((cAlias)->D1TOTAL,  		"@E 99999999.99")+";"
		cLiArqCSV += Transform((cAlias)->BSPIS, 	  		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->D1BSCOF,  		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->D1VLPIS, 	 		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->D1VLCOF, 	  		"@E 999,999,999.99")+";"
		cLiArqCSV += AllTrim((cAlias)->D1NFORI)+";"
		cLiArqCSV += AllTrim((cAlias)->D1SERIEORI)+";"
		cLiArqCSV += dtoc(stod((cAlias)->D2EMISSAO))+";"
		cLiArqCSV += dtoc(stod((cAlias)->D1DTDIGIT))+";"
		cLiArqCSV += Transform((cAlias)->D2TOTAL,  		"@E 99999999.99")+";"
		cLiArqCSV += Transform((cAlias)->D2BSPIS, 	  		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->D2BSCOF,  		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->D2VLPIS, 	 		"@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->D2VLCOF, 	  		"@E 999,999,999.99")+";"
		cLiArqCSV += AllTrim((cAlias)->D2ITEM)+";"
		cLiArqCSV += AllTrim((cAlias)->D2DOC)+";"
		cLiArqCSV += AllTrim((cAlias)->D2SERIE)+";"

	Else			
		
		cLiArqCSV := AllTrim((cAlias)->D2FILIAL)+";"
		cLiArqCSV += AllTrim((cAlias)->D2DOC)+";"
		cLiArqCSV += AllTrim((cAlias)->D2SERIE)+ ";"
		cLiArqCSV += AllTrim((cAlias)->D2TIPO)+ ";"
		cLiArqCSV += AllTrim((cAlias)->D2CF)+ ";"
		cLiArqCSV += dtoc(stod((cAlias)->D2EMISSAO))+";"
		cLiArqCSV += Transform((cAlias)->D2TOTAL, "@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->D2BIMP5, "@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->D2BIMP6, 	  "@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->D2VLIMP5, 	  "@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->D2VLIMP6, 	  "@E 999,999,999.99")+";"
		cLiArqCSV += AllTrim((cAlias)->D2NFORI)+";"
		cLiArqCSV += AllTrim((cAlias)->D2SERIORI)+";"
		cLiArqCSV += dtoc(stod((cAlias)->D1EMISSAO))+";"
		cLiArqCSV += dtoc(stod((cAlias)->D1DTDIGIT))+";"
		cLiArqCSV += Transform((cAlias)->D1TOTAL, "@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->D1BIMP5, "@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->D1BIMP6, 	  "@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->D1VLIMP5, 	  "@E 999,999,999.99")+";"
		cLiArqCSV += Transform((cAlias)->D1VLIMP6, 	  "@E 999,999,999.99")+";"

	EndIf
	
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
