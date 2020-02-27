#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMACTBR02  บ Autor ณSandro Albuquerque  บ Data ณ  19/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio responsavel imprimir o razใo contabil de acordo   บฑฑ
ฑฑบ          ณcom a solicita็ใo feita pela usuแria Elizabeth Takahashi    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP 8.11/R4 ou 10.1 - Especifico Midori                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function MACTBR02()

Private _cColuna := ''

//Criacao de variaveis
SetPrvt("cQryCt2, aArea, aSays, aButtons, nOpc, cTitulo, cPerg, cArqCSV, nArqCSV")
SetPrvt("cTipoRel, dDtEmissDe, dDtEmissAte, cCliDe, cLjCliDe, cCliAte, cLjCliAte, cForneDe, cLjForDe, cForneAte, cLjForAte")
SetPrvt("cProdDe, cProdAte, cGrProdDe, cGrProdAte, cFilDe, cFilAte")

//Inicializacao de variaveis
aArea	 := GetArea()
aSays 	 := {}
aButtons := {}
nOpc 	 := 0
cTitulo  := OemToAnsi("RELATORIO CONCILIAวAO CONTABIL")
cPerg    := PADR("MACTBR02",10)

//Inicio da funcao
IF !SX1->(dbSeek(cPerg))
	ValidPerg(cPerg)
	
EndIf

//Executa a pergunta do relat๓rio
Pergunte(cPerg,.f.)

//Tela com mensagem informativa ao usuario sobre o programa
aAdd(aSays,OemToAnsi("Gerarแ relatorio para concilia็ใo dos movimentos contแbeis, conforme regra de "))
aAdd(aSays,OemToAnsi("de relacionamento entre tabelas do contabil.              "))
aAdd(aSays,OemToAnsi("                                                          "))
aAdd(aSays,OemToAnsi("Relatorio de Concilia็ใo Contabil      "))
aAdd(aButtons, { 5, .T., {|| Pergunte(cPerg,.T. ) } } ) 								 //Busca grupo de perguntas e os exibe ao usuario, apos selecionar botao parametros
aAdd(aButtons, { 1, .T., {|o| nOpc := 1, IF(gpconfOK(), FechaBatch(), nOpc:=0) }} )   //Se selecionar botao Ok fecha tela de entrada
aAdd(aButtons, { 2, .T., {|o| FechaBatch() }} ) 										 //Se selecionado botao Cancelar, fecha tela de entrada e retorna para tela principal

FormBatch(cTitulo,aSays,aButtons) //Exibe Tela de entrada

IF ( nOpc == 1 )
	Processa({|| EXECQRY()},"Localizando dados...","Por favor, aguarde...",.T.) 		 //Chama rotina que localiza dados no banco de dados
	
EndIF

RestArea(aArea) //Restaura o ambiente de arquivo
Return(nil)
//
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ExecQry  บ Autor ณ Sandro Albuquerque บ Data ณ  03/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCadastra perguntas do relatorio                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP 8.11/R4 ou 10.1 - Especifico Midori                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ExecQry()
//Carrega parametros para variaveis
cFilDe 		:= mv_par01 		//Filial
cFilAte 	:= mv_par02 		//Filial
dDataDe		:= DToS(mv_par03) 	//Data da movimentacao contabil
dDataAte 	:= DToS(mv_par04) 	//Data de movimenta็ใo contabil
cContaDe	:= mv_par05 		//Da conta contabil de
cContaAte   := mv_par06 		//Conta Contabil Ate
cModulo     := mv_par07			// Identifica o modulo para conciliacao

//Verifica se query esta aberta
If Select("QRYCT2") > 0
	DBSelectArea("QRYCT2")
	("QRYCT2")->(DBCloseArea()) //e a fecha para evitar uso com a query aberta
	
EndIf

cQryCt2 := " SELECT	CT2.CT2_FILIAL, CT2.CT2_DATA, CT2.CT2_LP, CVA.CVA_CODIGO, CVA.CVA_DESCRI, CVA.CVA_MODULO, CVA.CVA_PROCES, CT2.CT2_LOTE, CT2.CT2_SBLOTE, "
cQryCt2 += " 		CT2.CT2_DOC, CT2.CT2_LINHA, CT2.CT2_DEBITO, CT2.CT2_CREDIT, CT2.CT2_CCD, CT2.CT2_CCC, CT2.CT2_ITEMD, CT2.CT2_ITEMC, "
cQryCt2 += " 		CT2.CT2_VALOR, CT2.CT2_HIST, CT2.CT2_KEY, CT2.CT2_ORIGEM "

cQryCt2 += " FROM 	CT2010 AS CT2, CVA010 AS CVA "

cQryCt2 += " WHERE	CT2.CT2_FILIAL >= '"+cFilDe  +"' AND CT2.CT2_FILIAL <= '"+cFilAte  +"' "
cQryCt2 += "  	AND CT2.CT2_DATA   >= '"+dDataDe +"' AND CT2.CT2_DATA   <= '"+dDataAte +"' "
cQryCt2 += "    AND CT2.CT2_DEBITO >= '"+cContaDe+"' AND CT2.CT2_DEBITO <= '"+cContaAte+"' "
cQryCt2 += "    AND CT2.CT2_CREDIT >= '"+cContaDe+"' AND CT2.CT2_CREDIT <= '"+cContaAte+"' "
cQryCt2 += "  	AND CVA.CVA_MODULO =  '"+cModulo+"' "

cQryCt2 += "   	AND CT2.CT2_LP = CVA.CVA_CODIGO "
cQryCt2 += " 	AND CT2.D_E_L_E_T_ = '' "
cQryCt2 += " 	AND CVA.D_E_L_E_T_ = '' "

cQryCt2 += " ORDER BY CVA.CVA_MODULO, CT2.CT2_DATA, CT2.CT2_LOTE, CT2.CT2_SBLOTE, CT2.CT2_DOC, CT2.CT2_LINHA, CT2.CT2_LP "

cQryCt2   := ChangeQuery(cQryCt2)
cAliasQry := "QRYCT2"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryCt2),cAliasQry,.F.,.T.)

If Empty((cAliasQry)->CT2_DOC)
	Aviso("Aten็ใo","Por favor, Verificar parametros informados...", {"Ok"}, 2, "Dados inexistentes!") //informa ao usuario que nao localizou dados na base de dados
	Return
	
Endif

IncProc("Selecionando registros...")
IncProc("Localizando excel...")
GeraExcel(cAliasQry) //Chama a rotina geradora do arquivo excel
Return(nil)
//
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraExcel บ Autor ณ Sandro Albuquerque บ Data ณ  03/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCadastra perguntas do relatorio                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP 8.11/R4 ou 10.1 - Especifico Midori                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraExcel(cAliasQry)

Local _cCtl_Alias  := " "
Local _cCtl_Key    := " "
Local _cCtl_LP     := " "
Local _cCtl_Desc   := " "
Local _cCtl_Order  := " "

Private cLiArqCSV
Private aCampos := {}

//cDir := "C:\SIGAEXCEL\" 				//Diretorio onde sera gravado o arquivo excel
cEol := CHR(13)+CHR(10)

dbSelectArea(cAliasQry)
cArqCSV  := CriaTrab(NIL,.F.) 			//Cria arquivo de trabalho temporario
cArqCSV  := Alltrim(cArqCSV)+".CSV" 	//Inclui extensao CSV compativel com excel no arquivo de trabalho

nArqCSV  := fCreate(cArqCSV) 			//Criar arquivo texto com extensao CSV

_cColuna := ''
_cLP 	 :=  ((cAliasQry)->CT2_LP)

DbselectArea("CTL")
DbSetOrder(1)
IF dbSeek(xFilial("CTL")+_cLP, .T.)
	_cCtl_Alias := CTL->CTL_ALIAS
	_cCtl_Key   := CTL->CTL_KEY
	_cCtl_LP    := CTL->CTL_LP
	_cCtl_Desc  := CTL->CTL_DESC
	_cCtl_Order := CTL->CTL_ORDER
	
Else
	Alert("Nใo existe (CTL)-Relacionamento para este LP "+_cLP)
	Return()
	
Endif

// Retorna o titulo dos campos de todas as tabelas relacionadas
dbSelectArea(cAliasQry)
IF (cAliasQry)->(!Eof())
	_cColuna  += AllTrim(RetTitle("CT2_FILIAL")) 	//X3Titulo('CT2_FILIAL')+';'
	_cColuna  += AllTrim(RetTitle("CT2_DATA")) 		//X3Titulo('CT2_DATA')+';'
	_cColuna  += AllTrim(RetTitle("CT2_LOTE")) 		//X3Titulo('CT2_LOTE')+';'
	_cColuna  += AllTrim(RetTitle("CT2_SBLOTE")) 	//X3Titulo('CT2_SBLOTE')+';'
	_cColuna  += AllTrim(RetTitle("CT2_DOC"))		//X3Titulo('CT2_DOC')+';'
	_cColuna  += AllTrim(RetTitle("CT2_LINHA")) 	//X3Titulo('CT2_LINHA')+';'
	_cColuna  += AllTrim(RetTitle("CT2_DEBITO")) 	//X3Titulo('CT2_DEBITO')+';'
	_cColuna  += AllTrim(RetTitle("CT2_CREDIT")) 	//X3Titulo('CT2_CREDIT')+';'
	_cColuna  += AllTrim(RetTitle("CT2_CCD")) 		//X3Titulo('CT2_CCD')+';'
	_cColuna  += AllTrim(RetTitle("CT2_CCC")) 		//X3Titulo('CT2_CCC')+';'
	_cColuna  += AllTrim(RetTitle("CT2_ITEMD")) 	//X3Titulo('CT2_ITEMD')+';'
	_cColuna  += AllTrim(RetTitle("CT2_ITEMC")) 	//X3Titulo('CT2_ITEMC')+';'
	_cColuna  += AllTrim(RetTitle("CT2_HIST")) 		//X3Titulo('CT2_HIST')+';'
	_cColuna  += AllTrim(RetTitle("CT2_VALOR")) 	//X3Titulo('CT2_VALOR')+';'
	_cColuna  += "|=|;" 				   			// insere uma coluna de separacao
	//_cColuna  += AllTrim(RetTitle("CVA_MODULO")) 	//X3Titulo('CVA_MODULO')+';'
	//_cColuna  += AllTrim(RetTitle("CVA_PROCES")) 	//X3Titulo('CVA_PROCES')+';'
	//_cColuna  += AllTrim(RetTitle("CVA_DESCRI")) 	//X3Titulo('CVA_DESCRI')+';'
	//_cColuna  += AllTrim(RetTitle("CT2_LP")) 		//X3Titulo('CT2_LP')+';'
	_cColuna  += AllTrim(RetTitle("CT2_KEY")) 		//X3Titulo('CT2_KEY')+';'
	_cColuna  += AllTrim(RetTitle("CT2_ORIGEM")) 	//X3Titulo('CT2_ORIGEM')+';'
	//_cColuna  += AllTrim(RetTitle("CTL_LP")) 		//X3Titulo('CTL_LP')+';'
	//_cColuna  += AllTrim(RetTitle("CTL_ALIAS")) 	//X3Titulo('CTL_ALIAS')+';'
	//_cColuna  += AllTrim(RetTitle("CTL_KEY")) 	//X3Titulo('CTL_KEY')+';'
	//_cColuna  += AllTrim(RetTitle("CTL_ORDER")) 	//X3Titulo('CTL_ORDER')+';'
	//_cColuna  += AllTrim(RetTitle("CT2_DESC")) 	//X3Titulo('CTL_DESC')+';' 
	_cColuna  += 'CONCILIADO'+';'
	//
	// Cria Cabecalho da tabela selecionada.
	cTab := AllTrim(_cCtl_Alias)
	nOrd := Val(AllTrim(_cCtl_Order))
	cKey := _cCtl_Key                          	
	ValidKey(cTab, nOrd, cKey, _cCtl_Key, 0) 		//0 = Retorna titulo dos campos da tabela selecionada.
	
Endif
fWrite(nArqCSV, _cColuna + cEol)

//Inicio do processo de criacao da planilha e relacionamento com outras tabelas
dbSelectArea(cAliasQry)
DbGotop()   				// Posiciona no primeiro registro do filtro
ProcRegua((cAliasQry)->(RecSize(cAliasQry)+49))

While (cAliasQry)->(!Eof())
	
	DbselectArea("CTL")
	DbSetOrder(1)
	IF dbSeek(xFilial("CTL")+_cLP, .T.)
		_cCtl_Alias := CTL->CTL_ALIAS
		_cCtl_Key   := CTL->CTL_KEY
		_cCtl_LP    := CTL->CTL_LP
		_cCtl_Desc  := CTL->CTL_DESC
		_cCtl_Order := CTL->CTL_ORDER
		
	Else
		Alert("Nใo existe (CTL)-Relacionamento para este LP "+_cLP)
		Return()
		
	Endif
	
	
	IncProc("Gerando planinha excel...")
	
	cLiArqCSV := AllTrim((cAliasQry)->CT2_FILIAL)+";"
	cLiArqCSV += AllTrim((cAliasQry)->CT2_DATA)+";"
	cLiArqCSV += AllTrim((cAliasQry)->CT2_LOTE)+";"
	cLiArqCSV += AllTrim((cAliasQry)->CT2_SBLOTE)+";"
	cLiArqCSV += AllTrim((cAliasQry)->CT2_DOC)+";"
	cLiArqCSV += AllTrim((cAliasQry)->CT2_LINHA)+";"
	cLiArqCSV += AllTrim((cAliasQry)->CT2_DEBITO)+";"
	cLiArqCSV += AllTrim((cAliasQry)->CT2_CREDIT)+";"
	cLiArqCSV += AllTrim((cAliasQry)->CT2_CCD)+";"
	cLiArqCSV += AllTrim((cAliasQry)->CT2_CCC)+";"
	cLiArqCSV += AllTrim((cAliasQry)->CT2_ITEMD)+";"
	cLiArqCSV += AllTrim((cAliasQry)->CT2_ITEMC)+";"
	cLiArqCSV += AllTrim((cAliasQry)->CT2_HIST)+";"
	cLiArqCSV += Transform((cAliasQry)->CT2_VALOR,"@E 999,999,999.99")+";"
	cLiArqCSV += "|=|;" 					// insere uma coluna
	//
	//cLiArqCSV += AllTrim((cAliasQry)->CT2_LP)+";"
	cLiArqCSV += (cAliasQry)->CT2_KEY+";"
	cLiArqCSV += AllTrim((cAliasQry)->CT2_ORIGEM)+";"
	//cLiArqCSV += AllTrim(_cCtl_Lp)+";"
	//cLiArqCSV += AllTrim(_cCtl_Alias)+";"
	//cLiArqCSV += AllTrim(_cCtl_Key)+";"
	//cLiArqCSV += AllTrim(_cCtl_Order)+";"
	//cLiArqCSV += AllTrim(_cCtl_Desc)+";"
	//
	// Carrega dados das tabelas relacionadas.
	cTab := AllTrim(_cCtl_Alias)
	nOrd := Val(AllTrim(_cCtl_Order))
	cKey := _cCtl_Key  					// Conteudo da chave
	ValidKey(cTab, nOrd, cKey, _cCtl_Key ,1) 		// 1 = Retorna o conteudo dos campos da tabela selecionada.
	                                                                        
	// Efetua a conciliacao
	Relaciona(cTab, nOrd, (cAliasQry)->CT2_KEY)    // Verifica a origem do lan็amento padronizado
	
	fwrite(nArqCSV, cLiArqCSV+cEol) 				// Cria arquivo texto com dados contabil.
	
	(cAliasQry)->(DbSkip())
	
End While
fclose(nArqCSV) 									// Fecha arquivo texto para abrir no excel

If !ApOleClient("MsExcel")
	MsgStop("Por favor instalar o software Microsoft Excel.") //Exibe mensagem ao usuaro caso o excel esteja ausente no computador que esta sendo executado a rotina
	Return
	
EndIf

cPath := AllTrim(GetTempPath()) 					// Cria arquivo temporario
CpyS2T(cArqCSV, cPath, .F. ) 						// Copia o arquivo temporario para estrutura .csv

oExcelApp:= NIL
oExcelApp:= MsExcel():New()
oExcelApp:WorkBooks:Open(cPath+cArqCSV)
oExcelApp:SetVisible(.T.)
lIntExcel:= .T.
oExcelApp:= NIL
Return(nil)
//
//
//

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRelaciona บ Autor ณ Sandro Albuquerque บ Data ณ  03/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetornar campos da tabela que originou o lan็amento padrao  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP 8.11/R4 ou 10.1 - Especifico Midori                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Relaciona(cTab, nOrd, cKey)

Local cCampo := ""

dbSelectArea(cTab)
dbSetOrder(nOrd) // Ordem do indice na tabela CTL
                

If !Empty(cKey)
	
	If DbSeek(cKey)
		
		If cTab == "SE1"
			cLiArqCSV += Transform(SE1->E1_VALOR,"@E 999,999,999.99")
			
		ElseIf cTab == "SE2"
			cLiArqCSV += Transform(SE2->E2_VALOR,"@E 999,999,999.99")
			
		ElseIf cTab == "SE5"
			cLiArqCSV += Transform(SE5->E5_VALOR,"@E 999,999,999.99")
			
		ElseIf cTab == "SEF"
			cLiArqCSV += Transform(SEF->EF_VALOR,"@E 999,999,999.99")
			
		Endif
		
	
	Else
		
		cLiArqCSV += "Nใo encontrou rela็ใo"
		
	Endif
	
Else
	cLiArqCSV += "Campo chave no contabil vazio !!!"
	
Endif  
cLiArqCSV += ';'
  
Return()
//
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidKey  บ Autor ณ Sandro Albuquerque บ Data ณ  03/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCadastra perguntas do relatorio                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP 8.11/R4 ou 10.1 - Especifico Midori                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidKey(cTab, nOrd, cKey, cSix, nTip)

Local cCampo := ""
Local _cRet  := ""
Local nCpo   := 1
Local nPos   := 1
Local cChar  := "+()"

dbSelectArea(cTab)
dbSetOrder(nOrd) // Ordem do indice na tabela CTL


If !Empty(cKey)
	If DbSeek(cKey)
		
		While nPos <= Len(Alltrim(cSix))
			
			If Substr(Alltrim(cSix),nPos,1) $ cChar	// Executa caso nใo exista o caracter indicado
				
				If nTip == 0 // Retorna o titulo do campo do SX3
					_cColuna += Alltrim(X3Titulo(cCampo))
					_cColuna += ';'
					
				Else         // Retorna o conteudo do campo
					cLiArqCSV += AllTrim((cTab)->&cCampo)
					cLiArqCSV += ';'
					
				Endif
				cCampo := " "
				nCpo ++
				
			Else
				cCampo := Alltrim(cCampo)+Substr(alltrim(cSix),nPos,1) // Monta nome do campo
				
			Endif
			nPos ++
			
		Enddo
		
	Else
		
		_cRet := "Nใo encontrou rela็ใo"
		
	Endif
	
Else
	_cRet := "Campo chave no contabil vazio !!!"
	
Endif
Return(_cRet)
//
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออออออหอออออัออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณ RetCpo          บAutorณ Microsiga                  บ Data ณ 21/01/2010 บฑฑ
ฑฑฬอออออออออุอออออออออออออออออสอออออฯออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Retorna o campo da tebela existente no sindex/six da empresa           บฑฑ
ฑฑบ         ณ                                                                        บฑฑ
ฑฑบ         ณ Ex: RetCpo( 'E1_FILIAL+E1_DOC' ) retorna 'E1_FILIAL','E1_DOC'  	     บฑฑ
ฑฑบ         ณ                                                                        บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe  ณ RetEnd( ExpC1, ExpN2 )                                                 บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametr ณ ExpC1 = String contendo o endereco                                     บฑฑ
ฑฑบ         ณ ExpN2 = Indica o retorno da funcao, ou seja:                           บฑฑ
ฑฑบ         ณ         1 - Retorna endereco                                           บฑฑ
ฑฑบ         ณ         2 - Retorna o numero do endereco                               บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ Generico                                                               บฑฑ
ฑฑฬอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 บฑฑ
ฑฑฬอออออออออออออออัอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ  Programador  ณ  Data   ณ Motivo da Alteracao                                    บฑฑ
ฑฑฬอออออออออออออออุอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ               ณ         ณ                                                        บฑฑ
ฑฑศอออออออออออออออฯอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RetCPO( cSix, cChar )
Local cCampo  := " "
Local nCpo    := 1
Local nPos    := 1
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuando nao ha virgula no endereco procura-se o caracter brancoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While nPos <= Len(Alltrim(cSix))
	
	If Substr(Alltrim(cSix),nPos,1) $ cChar	 		// Executa caso nใo exista o caracter indicado
		cLiArqCSV += AllTrim((cTab)->&cCampo)+";"
		cCampo 	  := " "
		nCpo ++
		
	Else
		cCampo := Alltrim(cCampo)+Substr(alltrim(cSix),nPos,1) // Monta nome do campo
		
	Endif
	nPos ++
	
Enddo

RETURN()

//
//
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บ Autor ณ Sandro Albuquerque บ Data ณ  03/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCadastra perguntas do relatorio                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP 8.11/R4 ou 10.1 - Especifico Midori                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg(cPerg)

//Variaveis locais
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

//   1          2        3         4          5           6       7       8             9        10      11     12       13        14        15         16       17       18       19        20          21        22      23        24       25         26        27       28       29       30          31        32       33       34        35          36        37     38     39       40       41        42
//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_PYME/X1_GRPSXG/X1_HELP/X1_PICTURE
AADD(aRegs,{cPerg,"01","Da Filial         ","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate a Filial      ","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Da Data           ","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate a Data        ","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Da Conta          ","","","mv_ch5","C",20,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate a Conta       ","","","mv_ch6","C",20,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"07","M๓dulo            ","","","mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

//Loop de armazenamento
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
Return()
