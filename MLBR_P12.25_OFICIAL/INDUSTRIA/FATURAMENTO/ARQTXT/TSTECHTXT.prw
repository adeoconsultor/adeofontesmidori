#Include "PROTHEUS.CH"
#include "ap5mail.ch"
#define QuebraLi CHR(13)+CHR(10)
/*======= ======= ======= ======= ======= ======= ======= ======= ======= =======
 Programa  : TSTECHTXT()           Autor: Claudinei E.Nascimento Data: 23/11/09
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Objetivo  : Gera arquivo texto com informacoes das notas fiscais emitidas num
             determinado periodo conforme layout versao 17 da ANFAVEA, cujo
             objetivo e informar todas as movimentacoes de notas fiscais
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Modulo(s) : FAT - Faturamento
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Tabela(s) : 
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Campos    : 
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Uso       : Modulo SIGAFAT
 Obs.      : Nome do arquivo = TSTECHAAAAMMDD.TXT (AAAA=Ano, MM=Mes e DD=Dia)
             A sra.Patricia-Fiscal informou que o arquivo deve ser gerado apenas
             uma vez por dia, portando devera ser renomeado com a data do dia.
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Ajustes   : 
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= */
 user function TSTECHTXT()
 	local aArea := GetArea() //Armazena o ambiente de arquivo
 	local aSays := {} //
 	local aButtons := {} //
 	local nOpc := 0 //
 	private cTitulo := OemToAnsi("Arquivo texto com dados de notas fiscais - Layout ANFAVEA")
 	private cPerg := PADR("TSTECH0001", 10) //Grupo de pergunta que sera gravado no campo X1_GRUPO

 	CriaPerg(cPerg) //Cria perguntas no SX1-Arquivos de perguntas

	//Tela com mensagem informativa ao usuario sobre o programa
	aAdd(aSays,OemToAnsi("Gerará arquivo texto com dados de notas fiscais conforme layout versão 17 da ANFAVEA."))
	aAdd(aSays,OemToAnsi("                                                                                     "))
	aAdd(aSays,OemToAnsi("Este arquivo poderá ser enviado por e-mail.                                          "))
	aAdd(aSays,OemToAnsi("Rotina: TSTECHTXT                                                                    "))
	aAdd(aButtons, { 5, .T., {|| Pergunte(cPerg,.T. ) } } ) //Busca grupo de perguntas e os exibe ao usuario, apos selecionar botao parametros
	aAdd(aButtons, { 1, .T., {|o| nOpc := 1, IF(gpconfOK(), FechaBatch(), nOpc:=0) }} ) //Se selecionar botao Ok fecha tela de entrada
	aAdd(aButtons, { 2, .T., {|o| FechaBatch() }} ) //Se selecionado botao Cancelar, fecha tela de entrada e retorna para tela principal do Gestao de pessoal

	FormBatch(cTitulo,aSays,aButtons) //Exibe Tela de entrada

	IF ( nOpc == 1 )
		Processa({|| BuscaDados()},"Geração de arquivo texto","Por favor, aguarde...",.T.) //Antes: ProcessHE(.T., .T.) //Chamada a rotina de processamento de contabilizacao
	EndIF

 	RestArea(aArea) //Restaura o ambiente de arquivo
return(nil)


/*======= ======= ======= ======= ======= ======= ======= ======= ======= =======
 Programa  : BuscaDados()           Autor: Claudinei E.Nascimento Data: 22/11/09
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Objetivo  : Busca dados conforme parametros informados pelo usuario e armazena
             em variaveis.
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Modulo(s) : FAT - Faturamento
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Tabela(s) : 
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Campos    : 
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Uso       : Modulo SIGAFAT
 Obs.      : 
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= */
static function BuscaDados()
	local aAreaSA1 := {}
	Local nCol, nLi

	Setprvt("cRazSocEmp,cRazSocCli,cTipPed_,cSDXParam,cNomDptRes,cQrySD2")
	Setprvt("cHora,cDtHrGeMvto,cRazSocTra,cCNPJTrans,cRazSocRec,cCNPJRecep,cTipPed_,cSDXParam,cNomDptRes,cQrySRA")
	Setprvt("cSpace16,cSpace3,cSpace55,cSpace12,cSpace5,lImpNF,cNFAnt,cNFAtu,nVlrTtl")
	SetPrvt("cDetAE1,cDetNF2,cDetAE2,cDetAE4,cDetAE7,nQtdChar,cArq,cHeader,cLocEnt,cFinal,cDirLoc")
	SetPrvt("nADetAE2,nADetAE4,nADetAE7,nQtdRegFTP,nSeqItemNF,cDirLoc,nHdl,nLi,nColcCodCont")
	SetPrvt("cFileName,cDestino,cBarra,cCtaEMail,cAssunto,cMensagem,cArqEntcQryAC8,cFilSA1,cCliLjAC8,cMsgTsT")

	private aHeader := {}	 //Registro ITP: Cabecalho do arquivo
	private aDetAE1 := {}	 //Registro AE1: 
	private aDetNF2 := {}  //Registro NF2: Dados das Notas fiscais
	private aDetAE2 := {}	 //Registro AE2: Dados dos Itens das Notas Fiscais
	private aDetAE4 := {}	 //Registro AE4: Dados dos Itens das Notas Fiscais
	private aDetAE7 := {}	 //Registro AE7: Dados dos Itens das Notas Fiscais
	private aFinal := {}	 //Registro FTP: Rodape do arquivo

	cSpace16 := Space(16)
	cSpace3 := Space(3)
	cSpace55 := Space(55)
	cSpace12 := Space(12)
	cSpace5 := Space(5)

	//Carrega parametros de usuario para variaveis do programa
	cDtEmiDe := DTOS(mv_par01) //Dt Emis NF De?
	cCliente := mv_par02 //Cliente?
	cCliLoja := mv_par03 //Cliente?
	cEMail := mv_par04 //Enviar por e-mail?

	cHora := SubStr(TIME(),1,2)+SubStr(TIME(),4,2)+SubStr(Time(),7,2)
	cDtHrGeMvto := SubStr(DToS(dDataBase),3,2)+SubStr(DToS(dDataBase),5,4)+cHora //Data e Hora Geracao Movimento AAMMDDHHMMSS

	cRazSocTra := SubStr(SM0->M0_NOMECOM,1,25)
	cCNPJTrans := AllTrim(SM0->M0_CGC)
	cMidSeq := "00000" //GetMv("MV_MIDSEQ")

	//Verifica se nao esta aberto o alias
	If Select("QRYSD2") > 0
		DBSelectArea("QRYSD2")
		("QRYSD2")->(DBCloseArea())
	EndIf

	cQrySD2 := "SELECT F2.F2_DOC,F2.F2_SERIE,F2.F2_EMISSAO,F2.F2_VALBRUT,D2.D2_CF,F2.F2_VALICM, E1.E1_VENCTO,'01' ESPECIENF,F2.F2_VALIPI, F2.F2_DESPESA, F2.F2_FRETE, F2.F2_SEGURO, "
	cQrySD2 += "(SELECT SUM(D2.D2_DESC) FROM "+RetSqlName("SD2")+ " D2 WHERE D2.D_E_L_E_T_='' AND D2.D2_FILIAL='"+cFilAnt+"' AND D2.D2_DOC=F2.F2_DOC) D2_DESC,F2.F2_BASEICM,D2.D2_ITEMPV, "
	cQrySD2 += "D2.D2_QUANT,D2.D2_UM,B1.B1_POSIPI,D2.D2_IPI,D2.D2_PRUNIT, ((D2.D2_DESC/D2.D2_PRUNIT)*100) D2_PERCDE, "
	cQrySD2 += "D2.D2_PICM,D2.D2_BASEICM,D2.D2_COD,D2.D2_VALICM,D2.D2_VALIPI,(SELECT F4.F4_SITTRIB FROM "+RetSqlName("SF4")+" F4 WHERE F4.D_E_L_E_T_='' AND "
	if !Empty(xFilial("SF4"))
		cQrySD2 += "F4.F4_FILIAL='"+cFilAnt+"' AND "
	endif
	cQrySD2 += "F4.F4_CODIGO=D2.D2_TES) D2_SITTRI,D2.D2_CF CFO,D2.D2_VALBRUT, "
	cQrySD2 += "	A7.A7_PRODUTO,A7.A7_DESCCLI "
	cQrySD2 += "FROM "+RetSqlName("SF2")+" F2 "
	cQrySD2 += "INNER JOIN "+RetSqlName("SD2")+" D2 ON (D2.D_E_L_E_T_='' AND D2.D2_FILIAL=F2.F2_FILIAL AND D2.D2_DOC=F2.F2_DOC) "
	cQrySD2 += "INNER JOIN "+RetSqlName("SE1")+" E1 ON (E1.D_E_L_E_T_='' AND E1.E1_FILORIG=F2.F2_FILIAL AND E1.E1_NUM=F2.F2_DOC) "
	cQrySD2 += "INNER JOIN "+RetSqlName("SB1")+" B1 ON (B1.D_E_L_E_T_='' AND B1.B1_COD=D2.D2_COD) "
	cQrySD2 += "INNER JOIN "+RetSqlName("SA7")+" A7 ON (A7.D_E_L_E_T_='' AND A7.A7_CLIENTE=F2.F2_CLIENTE AND A7.A7_LOJA=F2.F2_LOJA AND A7.A7_PRODUTO=B1.B1_COD) "
	cQrySD2 += "WHERE F2.D_E_L_E_T_='' "
	cQrySD2 += "AND F2.F2_FILIAL='"+cFilAnt+"' "
	cQrySD2 += "AND F2.F2_EMISSAO = '"+cDtEmiDe+"' "
	cQrySD2 += "ORDER BY F2.F2_FILIAL, F2.F2_DOC "
	cQrySD2 := ChangeQuery( cQrySD2 )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySD2),'QRYSD2',.F.,.T.)

	if Empty(QRYSD2->F2_DOC)
		Aviso("Atenção","Por favor, verificar títulos, produtos e amarracao de cliente x produtos.", {"Ok"}, 2, "Período sem informações!") //Informa ao usuario que nao ha nota fiscal na base de dados
		return
	endif

	CriaArq("TSTECH",".TXT")

	dbSelectArea("SA1")
	aAreaSA1 := GetArea()
	dbSetOrder(1)
	if dbSeek(xFilial("SA1")+cCliente+cCliLoja)
		cRazSocRec := SubStr(SA1->A1_NOME,1,25)
		cCNPJRecep := AllTrim(SA1->A1_CGC)
	endif

	//Carrega dados para Registro ITP                                      Posicoes
	aAdd(aHeader,{	    "ITP",      ;  //Codigo Registro                   001 - 003
					    "004",      ;  //Identificacao da Transacao        004 - 006
						"17",       ;  //Versao da transacao               007 - 008
						cMidSeq,    ;  //Sequencial Controle Transmissor   009 - 013
						cDtHrGeMvto,;  //Data e Hora Geracao Movimento     014 - 025
						cCNPJTrans, ;  //CNPJ Transmissor                  026 - 039
						cCNPJRecep, ;  //CNPJ Receptor                     040 - 053
						cSpace16,   ;  //Brancos                           054 - 069
						cRazSocTra, ;  //Nome Transmissor                  070 - 094
						cRazSocRec  ;  //Nome Receptor                     095 - 119
                  })

		//Monta Registro ITP - Cabecalho do arquivo
		nCol := 1
		for nLi := 1 to len(aHeader)
			cHeader := aHeader[nLi,01]
			for nCol := 1 to 9
				cHeader += aHeader[nLi,01+nCol]
			next nCol
		next nLi
		fWrite(nHdl,cHeader+QuebraLi)

	ProcRegua(QRYSD2->(RecSize("QRYSD2")+14))

	cNFAnt := "!!!!!!"

	nADetAE2 := nADetAE4 := nADetAE7 := 0

	while QRYSD2->(!Eof())
		IncProc("Nota Fiscal: "+QRYSD2->F2_DOC) //Incrementa a regra de progressao exibida ao usuario

		//Imprime somente AE1 e NF2 quando nota fiscal atual for diferente da anterior
		if cNFAnt != QRYSD2->F2_DOC //A cada AE1 e NF2 sao gerados AE2, AE4 e AE7
			nSeqItemNF := 1  //Reinicia contagem de itens da nota fiscal
			//Registro AE1 - Dados Notas Fiscais
			aAdd(aDetAE1,{   "AE1"	,;       //Codigo Registro      001 - 003
							  SUBSTR(QRYSD2->F2_DOC,4,6),;			     //Numero Nota Fiscal   004 - 009 (ALTERADO PARA PEGAR 6 DIGITOS DO NUMERO DO DOCTO- JOSE ROBERTO(TAGGS)
			AllTrim(QRYSD2->F2_SERIE)+Replicate(" " ,4-Len(AllTrim(QRYSD2->F2_SERIE))),;		         //Serie Nota Fiscal    010 - 013
			SubStr(QRYSD2->F2_EMISSAO,3,2)+SubStr(QRYSD2->F2_EMISSAO,5,2)+SubStr(QRYSD2->F2_EMISSAO,7,2),;			     //Data Emissao N F     014 - 019
								              cSpace3,;        //Brancos              020 - 022 - Nao informado no layout, mas registrado aqui para ajuste
	        Replicate("0",17-Len(fExtraiNum(AllTrim(STR(QRYSD2->F2_VALBRUT,17,2)))))+fExtraiNum(AllTrim(STR(QRYSD2->F2_VALBRUT,17,2))),;			     //Valor Nota Fiscal    023 - 039
									                  "3",;		         //Qtd Casas Decimais   040 - 040
		    Replicate("0",5-Len(AllTrim(QRYSD2->D2_CF)))+AllTrim(QRYSD2->D2_CF),;			     //CFO-Natureza Operac  041 - 045
	        Replicate("0",17-Len(fExtraiNum(AllTrim(STR(QRYSD2->D2_VALICM,17,2)))))+fExtraiNum(AllTrim(STR(QRYSD2->D2_VALICM,17,2))),;			     //Valor Total ICMS     046 - 062
			SubStr(QRYSD2->E1_VENCTO,3,2)+SubStr(QRYSD2->E1_VENCTO,5,2)+SubStr(QRYSD2->E1_VENCTO,7,2),;			     //Data Vencimento      063 - 068
									 AllTrim(QRYSD2->ESPECIENF),;			     //Especie Nota Fiscal  069 - 070
	        Replicate("0",17-Len(fExtraiNum(AllTrim(STR(QRYSD2->D2_VALIPI,17,2)))))+fExtraiNum(AllTrim(STR(QRYSD2->D2_VALIPI,17,2)));		  		 //Valor Total IPI      071 - 087
			             })

			//Registro NF2 - Dados Notas Fiscais
			aAdd(aDetNF2,{            "NF2" ,;         //Codigo Registro      001 - 003
			        Replicate("0",12-Len(fExtraiNum(AllTrim(STR(QRYSD2->F2_DESPESA,12,2)))))+fExtraiNum(AllTrim(STR(QRYSD2->F2_DESPESA,12,2))),;			     //Valor Desp Acessor   004 - 015
			        Replicate("0",12-Len(fExtraiNum(AllTrim(STR(QRYSD2->F2_FRETE,12,2)))))+fExtraiNum(AllTrim(STR(QRYSD2->F2_FRETE,12,2))),;		         //Valor Frete          016 - 027
			        Replicate("0",12-Len(fExtraiNum(AllTrim(STR(QRYSD2->F2_SEGURO,12,2)))))+fExtraiNum(AllTrim(STR(QRYSD2->F2_SEGURO,12,2))),;			     //Valor Seguro         028 - 039
			        Replicate("0",12-Len(fExtraiNum(AllTrim(STR(QRYSD2->D2_DESC,12,2)))))+fExtraiNum(AllTrim(STR(QRYSD2->D2_DESC,12,2))),;              //Valor Desc N F       040 - 051
			        Replicate("0",12-Len(fExtraiNum(AllTrim(STR(QRYSD2->F2_BASEICM,12,2)))))+fExtraiNum(AllTrim(STR(QRYSD2->F2_BASEICM,12,2)));			     //Base Calculo ICMS    052 - 063
				               })
		
			//Imprime AE1-dados nota fiscal
			for nLi := 1 to len(aDetAE1)
				cDetAE1 := aDetAE1[nLi,01]
				for nCol := 1 to 11
					cDetAE1 += aDetAE1[nLi,01+nCol]
				next nCol
			next nLi
			fWrite(nHdl,cDetAE1+QuebraLi)
		
			//Imprime NF2-dados nota fiscal
			for nLi := 1 to len(aDetNF2)
				cDetNF2 := aDetNF2[nLi,01]
				for nCol := 1 to 5
					cDetNF2 += aDetNF2[nLi,01+nCol]
				next nCol
			next nLi
			fWrite(nHdl,cDetNF2+QuebraLi)
		endif

		cNFAnt := QRYSD2->F2_DOC

			//Registro AE2 - Dados Itens Nota Fiscal
			aAdd(aDetAE2,{      "AE2"	,;   //Codigo Registro      001 - 003
					Replicate("0",3-Len(AllTrim(Str(nSeqItemNF))))+AllTrim(Str(nSeqItemNF)),;			     //Seq Item Nota Fiscal 004 - 006
  							  space(12),;		         //Numero Ordem Compra  007 - 018 - Opcional
			        AllTrim(QRYSD2->A7_DESCCLI)+Replicate(" ",30-Len(AllTrim(QRYSD2->A7_DESCCLI))),;			     //Codigo Item TSTECH   019 - 048
 			        Replicate("0",9-Len(fExtraiNum(AllTrim(STR(QRYSD2->D2_QUANT*1000,9,0)))))+fExtraiNum(AllTrim(STR(QRYSD2->D2_QUANT*1000,9,0))),;              //Qtd Item N Fiscal    049 - 057
			        AllTrim(QRYSD2->D2_UM),;			     //Uni Med Item N F     058 - 059
				    Replicate("0",10-Len(AllTrim(QRYSD2->B1_POSIPI)))+fExtraiNum(AllTrim(QRYSD2->B1_POSIPI)),;		         //Cod Class Fisc Item  060 - 069
					Replicate("0",4-Len(AllTrim(QRYSD2->D2_IPI)))+fExtraiNum(AllTrim(QRYSD2->D2_IPI)),;			     //Aliquta IPI Item     070 - 073 
					Replicate("0",12-Len(fExtraiNum(AllTrim(STR(QRYSD2->D2_PRUNIT,12,5)))))+fExtraiNum(AllTrim(STR(QRYSD2->D2_PRUNIT,12,5))),;			     //Valor Unitario Item  074 - 085
						     space(23),;
				    Replicate("0",4-Len(fExtraiNum(AllTrim(STR(QRYSD2->D2_PERCDE,4,2)))))+fExtraiNum(AllTrim(STR(QRYSD2->D2_PERCDE,4,2)));			     //Perc Desc Item       109 - 112 - (D2_DESC/D2_PRUNIT)*100
 	               })
	 	      if len(aDetAE2) > 0
	 	      	nADetAE2 ++
	 	      endif

			//Registro AE4 - Dados Itens Notas Fiscais
			aAdd(aDetAE4,{      "AE4"	,;       //Codigo Registro      001 - 003
					Replicate("0",4-Len(fExtraiNum(AllTrim(STR(QRYSD2->D2_PICM,4,2)))))+fExtraiNum(AllTrim(STR(QRYSD2->D2_PICM,4,2))),;			     //Aliquota ICMS Item   004 - 007
					Replicate("0",17-Len(fExtraiNum(AllTrim(STR(QRYSD2->D2_BASEICM,17,2)))))+fExtraiNum(AllTrim(STR(QRYSD2->D2_BASEICM,17,2))),;		         //Base Calc ICMS Item  008 - 024
					Replicate("0",17-Len(fExtraiNum(AllTrim(STR(QRYSD2->D2_VALICM,17,2)))))+fExtraiNum(AllTrim(STR(QRYSD2->D2_VALICM,17,2))),;			     //Vlr ICMS Aplic Item  025 - 041
 					Replicate("0",17-Len(fExtraiNum(AllTrim(STR(QRYSD2->D2_VALIPI,17,2)))))+fExtraiNum(AllTrim(STR(QRYSD2->D2_VALIPI,17,2))),;               //Vlr IPI Aplic Item   042 - 058
  					AllTrim(QRYSD2->D2_SITTRI)+Replicate(" ",2-Len(AllTrim(QRYSD2->D2_SITTRI))),;			     //Codigo Situac Tribut 059 - 060
								cSpace55,;       //Brancos              061 - 115
 					Replicate("0",12-Len(fExtraiNum(AllTrim(STR(QRYSD2->D2_VALBRUT,12,2)))))+fExtraiNum(AllTrim(STR(QRYSD2->D2_VALBRUT,12,2)));			     //Preco Total Item     116 - 127 
  		               })
	 	      if len(aDetAE4) > 0
	 	      	nADetAE4 ++
	 	      endif

		//Registro AE7 - Dados Itens Notas Fiscais
			aAdd(aDetAE7,{      "AE7"	,;       //Codigo Registro      001 - 003
 								cSpace12,;	     //Brancos              004 - 015
							Replicate("0",5-Len(AllTrim(QRYSD2->D2_CF)))+AllTrim(QRYSD2->D2_CF),;		         //CFO por Item         016 - 020
							Replicate("0",17-Len(fExtraiNum(AllTrim(STR(0.00,17,2)))))+fExtraiNum(AllTrim(STR(0.00,17,2))),;			     //Vlr BC ICMS Sub Trib 021 - 037
 							Replicate("0",17-Len(fExtraiNum(AllTrim(STR(0.00,17,2)))))+fExtraiNum(AllTrim(STR(0.00,17,2)));		  		 //Vlr ICMS Subs Tribu  038 - 054
  		               })
	 	      if len(aDetAE7) > 0
	 	      	nADetAE7 ++
	 	      endif
	 	      
			ImpDetINF()
			
			len(aDetAE1) ++
			len(aDetNF2) ++
			nSeqItemNF ++
			aDetAE2 := {}
			aDetAE4 := {}
			aDetAE7 := {}

		dbSelectArea("QRYSD2")
		QRYSD2->(dbSkip())
	end while

	nQtdRegFTP := len(aHeader)+len(aDetAE1)+len(aDetNF2)+nADetAE2+nADetAE4+nADetAE7+1
	//Registro FTP - Rodape do Arquivo
	aAdd(aFinal,{          "FTP",;				//Codigo Registro    001 - 003
		    		     cSpace5,;  		//Brancos            004 - 008
	        StrZero(nQtdRegFTP,9);                   //Qtd Registro Trans 009 - 017
                 })

	//Imprime FTP-Final do arquivo
	for nLi := 1 to len(aFinal)
		cFinal := aFinal[nLi,01]
		for nCol := 1 to 2
			cFinal += aFinal[nLi,01+nCol]
		next nCol
	next nLi
	fWrite(nHdl,cFinal+QuebraLi)

	RestArea(aAreaSA1)
	fClose(nHdl)

	if cEMail == 1 //Se usuario deseja enviar enviar email

		If Select("QRYAC8") > 0 //Verifica se esta aberta e...
			DBSelectArea("QRYAC8")
			("QRYAC8")->(DBCloseArea()) //...fecha para nova utilizacao
		EndIf
		//Seleciona dados de clientes x contatos
		cQryAC8 := "SELECT AC8.AC8_FILIAL,AC8.AC8_FILENT,AC8.AC8_ENTIDA,AC8.AC8_CODENT,AC8.AC8_CODCON, "
		cQryAC8 += "       U5.U5_CODCONT,U5.U5_CONTAT,U5.U5_EMAIL,U5.U5_AUTORIZ,U5.U5_ATIVO,U5.U5_GRUPO "
		cQryAC8 += "FROM "+RetSQLName("AC8")+" AC8 "
		cQryAC8 += "INNER JOIN "+RetSQLName("SU5")+" U5 ON (U5.D_E_L_E_T_='' AND "
		if !Empty(xFilial("SU5")) //Se arquivo SU5 for exclusivo
			cQryAC8 += "U5.U5_FILIAL=AC8.AC8_FILIAL AND U5.U5_CODCONT=AC8.AC8_CODCON) "
		else //se for compartilhado
			cQryAC8 += "U5.U5_CODCONT=AC8.AC8_CODCON) "
		endif
		//Contato deve estar autorizado a receber e-mail, estar ativo e pertencer ao grupo _ _ -Recebe Arq ANFAVEA
		cQryAC8 += "WHERE AC8.D_E_L_E_T_='' AND U5.U5_AUTORIZ = 1 AND U5.U5_ATIVO = 1 AND U5.U5_GRUPO='05' "
		cQryAC8 := ChangeQuery( cQryAC8 )
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryAC8),'QRYAC8',.F.,.T.)
		
        cCtaEmail := ""
		while QRYAC8->(!Eof())
			cCtaEMail += AllTrim(QRYAC8->U5_EMAIL)
			dbSelectArea("AC8")
			QRYAC8->(dbSkip())
		end while

		if Empty(QRYSD2->F2_DOC)
			Aviso("Atenção","Por favor, cadastrar contas de e-mail, grupo e autorizar e ativar a conta em Atualizações->Cadastros->Contatos.", {"Ok"}, 2, "Falta contas de e-mail!") //Informa ao usuario que nao ha nota fiscal na base de dados
			return
		endif

		cAssunto := "Arquivo texto TS TECH x Midori"
		cMensagem := "Segue arquivo texto com dados de notas fiscais emitidas."

		SEND_EMAIL(,,,,cCtaEMail,cAssunto, cMensagem,,,.T.)

		If FILE(cDestino+cBarra+cArq)
			FErase(cDestino+cBarra+cArq)
		EndIf
	endif
	RestArea(aAreaSA1)
return(nil)


/*======= ======= ======= ======= ======= ======= ======= ======= ======= =======
 Programa  : CriaArq()           Autor: Claudinei E.Nascimento Data: 10/09/09
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Objetivo  : Cria pasta e arquivo C:\TSTECH\TSTECH0000001.TXT, renomeia os
             arquivos com o numero sequencial conforme parametro MV_TSTECHS
             cadastrado no arquivo SX6.
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Modulo(s) : Todos
  ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Parametros(s) : cPrefArq = prefixo para gravacao do nome
                 cNomeArq = nome do arquivo
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Tabela(s) : SX6
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Campos    : X6_VAR
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Uso       : Generico
 Integracao: Generico
 Obs.      : 
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= */
static function CriaArq(cPrefArq,cExtensao)
	private cTsTParam := 0
	private cData := ""
	private cBarra := "\"

	cDirLoc := "C:\TSTECH"

	cTsTParam := GetMv("MV_TSTCSEQ")
	if Len(cTsTParam) < 7
		Aviso("Atenção","Por favor, o parametro devera possuir sete caracteres.", {"Ok"}, 2, "Qtde caracteres incorreta!") //Informa ao usuario para corrigir quantidade de caracteres do parametro sequencial do arquivo texto
	endif

	cData := fExtraiNum(dtoc(ddatabase)) //SubStr(TIME(),1,2)+SubStr(TIME(),4,2)+SubStr(Time(),7,2)
	//Verifica existencia da pasta e aquivo no computador do usuario e cria-os caso inexistentes
	if ExistDir(cDirLoc)
		if File(cDirLoc+cBarra+cPrefArq+cDtEmiDe+cExtensao)
			//cTsTParam := STRZERO(Val(SubStr(GetMv("MV_TSTCSEQ"),1,7))+1,7)+SubStr(GetMv("MV_TSTCSEQ"),8,8)
			//PutMv("MV_TSTCSEQ",SubStr(cTsTParam,1,7)+cDtEmiDe) //Grava o novo numero sequencial do arquivo gerado pelo usuario mais a data de emissao do arquivo anterior
			//fRename(cDirLoc+cBarra+cPrefArq+".TXT", cDirLoc+cBarra+cPrefArq+SubStr(cTsTParam,8,8)+SubStr(cTsTParam,1,7)+".TXT")
			nHdl := fCreate(cDirLoc+cBarra+cPrefArq+cDtEmiDe+cExtensao)
		else
			//if Empty(GetMv("MV_TSTCSEQ")) .or. (GetMv("MV_TSTCSEQ") == "0000000")
			//	PutMv("MV_TSTCSEQ","0000001"+cDtEmiDe)
			//	cTsTParam := STRZERO(Val(GetMv("MV_TSTCSEQ"))+1,15)
			//else
			//	cMsgTsT := iif(Val(SubStr(cTsTParam,1,7))-1 <= 0, "0000001", STRZERO(Val(SubStr(cTsTParam,1,7)),7))
			//	Aviso("Atenção","Por favor, os arquivos ate "+cMsgTsT+" foram gerados por outra(o)s usuária(o)s.", {"Ok"}, 2, "Arquivos gerados!") //Informa ao usuario que nao ha nota fiscal na base de dados
			//	PutMv("MV_TSTCSEQ",STRZERO(Val(SubStr(GetMv("MV_TSTCSEQ"),1,7))+1,7)+cDtEmiDe)
			//endif
			//PutMv("MV_TSTCSEQ",cTsTParam+cDtEmiDe)
			nHdl := fCreate(cDirLoc+cBarra+cPrefArq+cDtEmiDe+cExtensao)
		endif
	else
		//if Empty(GetMv("MV_TSTCSEQ")) .or. (GetMv("MV_TSTCSEQ") == "0000000")
		//	PutMv("MV_TSTCSEQ","0000001"+cDtEmiDe)
			//cTsTParam := STRZERO(Val(GetMv("MV_TSTCSEQ"))+1,15)
		//else
		//	cTsTParam := STRZERO(Val(GetMv("MV_TSTCSEQ"))+1,15)
		//	cMsgTsT := StrZero(Val(SubStr(cTsTParam,1,7))-1,7)
		//	Aviso("Atenção","Por favor, os arquivos ate "+cMsgTsT+" gerados por outra(o)s usuária(o)s.", {"Ok"}, 2, "Arquivos gerados 1a vez!") //Informa ao usuario que nao ha nota fiscal na base de dados
		//endif
		//PutMv("MV_TSTCSEQ",cTsTParam+cDtEmiDe)
		MontaDir(cDirLoc)
		nHdl := fCreate(cDirLoc+cBarra+cPrefArq+cDtEmiDe+cExtensao)
	endif
return(nHdl)



/*======= ======= ======= ======= ======= ======= ======= ======= ======= =======
 Programa  : ImpDetINF()           Autor: Claudinei E.Nascimento Data: 10/09/09
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Objetivo  : Imprime detalhes dos itens da nota fiscal
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Modulo(s) : Todos
  ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Parametros(s) : cPrefArq = prefixo para gravacao do nome
                 cNomeArq = nome do arquivo
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Tabela(s) : SX6
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Campos    : X6_VAR
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
 Uso       : Generico
 Integracao: Generico
 Obs.      : 
 ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= */
static function ImpDetINF()
	local nCol, nLi := 1
	//Imprime AE2-dados nota fiscal
	for nLi := 1 to len(aDetAE2)
		cDetAE2 := aDetAE2[nLi,01]
		for nCol := 1 to 10
			cDetAE2 += aDetAE2[nLi,01+nCol]
		next nCol
	next nLi
	fWrite(nHdl,cDetAE2+QuebraLi)

	//Imprime AE4-dados nota fiscal
	for nLi := 1 to len(aDetAE4)
		cDetAE4 := aDetAE4[nLi,01]
		for nCol := 1 to 7
			cDetAE4 += aDetAE4[nLi,01+nCol]
		next nCol
	next nLi
	fWrite(nHdl,cDetAE4+QuebraLi)

	//Imprime AE7-dados nota fiscal
	for nLi := 1 to len(aDetAE7)
		cDetAE7 := aDetAE7[nLi,01]
		for nCol := 1 to 4
			cDetAE7 += aDetAE7[nLi,01+nCol]
		next nCol
	next nLi
	fWrite(nHdl,cDetAE7+QuebraLi)
return(nHdl)

 /*
======= ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
Programa  | CriaPerg(cPerg)
======= ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
Objetivo  | Criar perguntas no arquivo SX1
======= ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
Parametros| cPerg : string com o nome do conjunto de perguntas que sera gravado no
                   arquivo SX1
======= ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
Modulos   | SIGAFAT - Faturamento
======= ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
Uso       | Generico
======= ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
Tabelas   | SX1 - Arquivos de perguntas
======= ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
Campos    | Todos os campos do arquivo SX1
======= ======= ======= ======= ======= ======= ======= ======= ======= ======= ======= 
*/
static function CriaPerg(cPerg)
	local _sAlias := Alias()
	Local j, i

	dbSelectArea("SX1") //Seleciona a tabela SX1
	dbSetOrder(1) //X1_GRUPO+X1_ORDEM
	_cPerg := PADR(cPerg, 10)
	aRegs := {}
              //Grupo   Ord  Pergunta Brasil        Pergunta Espanhol     Pergunta Ingles       VAR_VL   Tipo Tam Dec Pres GSC Validacao    VAR1      DEF1  DEF1 DEF1  CNT1  VAR2  DEF2  DEF2 DEF2 CNT2  VAR3  DEF3  DEF3   DEF3  CNT3  VAR4  DEF4  DEF4  DEF4  CNT4   VAR5  DEF5  DEF5  DEF5  CNT5  _F3   PYME  GRPSXG  _HELP PICTUR  IDFIL
	Aadd(aRegs,{_cPerg,"01","Dt Emis NF De?     ","¿Dt Emis NF De?      ","Dt Emis NF De?     ","mv_ch1", "D", 08, 00, 00,"G","           ","mv_par01","   ","  ","   ","  ","   ","   ","  ","  ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","     ","    ","     ","    "})
	aAdd(aRegs,{_cPerg,"02","Cliente?           ","¿Cliente?            ","Cliente?           ","mv_ch2", "C", 06, 00, 00,"G","            ","mv_par02","   ","  ","   ","  ","   ","   ","  ","  ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","SA1","   ","     ","    ","    ","    "})
	aAdd(aRegs,{_cPerg,"03","Loja?              ","¿Loja?               ","Loja?              ","mv_ch3", "C", 02, 00, 00,"G","            ","mv_par03","   ","  ","   ","  ","   ","   ","  ","  ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","SA1","   ","     ","    ","    ","    "})
	aAdd(aRegs,{_cPerg,"04","Enviar por e-mail? ","¿Enviar por e-mail? ","Enviar por e-mail?  ","mv_ch4", "C", 01, 00, 00,"C","NaoVazio    ","mv_par04","Sim","Sim","Sim","  ","   ","Nao","Nao","Nao","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","   ","     ","    ","@!  ","    "})

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


/*===========================================================================
Funcao    : fExtraiNum()      | Autor: Claudinei E.N.     | Data |08/05/07
==========|================================================================
Descricao : Extrai os numeros dentre letras e espacos
Parametros: cString := recebe caracter entre " "
==========|================================================================
Modulo    : SIGAGPE - Gestão de Pessoal
==========|================================================================
OBS       : 
==========|================================================================
Alterações solicitadas
===========================================================================
Descrição :                                    |Sol.por|Atend.por|Data    
===========================================================================*/
static function fExtraiNum(cString)
	local i:=1
	local cNumeros := ""
	
	//Extrair os numeros dentre as letras e espaços
	for i:=1 to Len(cString)
		if AT( Substr(cString,i,1),"0123456789" ) > 0
			cNumeros += Substr(cString,i,1)
		endif	
	next i
		//cNumeros := replicate( "0", 5 - len(cNumeros) ) + cNumeros
return (cNumeros)


/*======= ======= ======= ======= ======= ======= ======= ======= ======= 
Funcao      SEND_EMAIL
======= ======= ======= ======= ======= ======= ======= ======= ======= 
Descricao   Rotina para o envio de emails
======= ======= ======= ======= ======= ======= ======= ======= ======= 
Parametros  Param1 : Conta para conexao com servidor SMTP
            Param2 : Senha da conta para conexao com o servidor SMTP
            Param3 : Servidor de SMTP
            Param4 : Conta de origem do e-mail. O padrao e a mesma conta
                    de conexao com o servidor SMTP.
            Param5 : Conta de destino do e-mail.
            Param6 : Assunto do e-mail.
            Param7 : Corpo da mensagem a ser enviada.
            Param8 : Patch com o arquivo que serah enviado.
======= ======= ======= ======= ======= ======= ======= ======= ======= 
Modulo      SIGAGPE
======= ======= ======= ======= ======= ======= ======= ======= ======= 
Tabelas     SRA
======= ======= ======= ======= ======= ======= ======= ======= ======= */
static Function SEND_EMAIL(cAccount, cPassword, cServer, cFrom, cEmailTo, cAssunto, cMensagem, cAttach, cEmailBcc,lMsg)
	//Declaracao de variaveis                                //SEND_EMAIL(1,2,3,4,cCtaEMail,cAssunto,cMensagem,8,,.T.)
	Local cEmailTo,cMail,cEmailBcc,cError,cAccount,cPassword,cServer,cAttach,cFrom //Caracteres
	Local lResult := lRet := .F. //Logica
	local aAreaSRA //Array
	local lRelauth := GetMv("MV_RELAUTH",,.F.)
	cBarra := If(isSrvUnix(),"/","\")
    //Verifica se diretorio esta separado com :
	If Substr(cDirLoc,2,2) == ":"+cBarra
		cDestino := GetSrvProfString("StartPath","")+If(Right(GetSrvProfString("StartPath",""),1) == cBarra,"",cBarra)+"TSTECH"
		If !File(cDestino)
			MAKEDIR(cDestino)
		EndIf
		If CpyT2S(cDirLoc+cBarra+cArq,cDestino,.T.) //Copiado arquivo na pasta system do protheus
			cArqEnt := cDestino+cBarra+cArq
		Else
			Help(" ",1,"F650COPY",,"Não foi possível copiar o arquivo de entrada para o servidor. O arquivo será processado a partir da máquina local, para um melhor desempenho, copie o arquivo diretamente no servidor.",1,0)
		EndIf
	EndIf

	//Inicializar variaveis
	cError := ""
	lResult := .F.

	//Verifica se serao utilizados os valores padrao
	cAccount	:= Iif( cAccount  == NIL, AllTrim(GetMV("MV_RELACNT")), cAccount) //Conta utilizada no envio de relatorios
	cPassword := AllTrim(GetMV("MV_RELPSW")) //Iif( cPassword == NIL, AllTrim(GetMV( "MV_RELPSW"  )), cPassword ) //Senha autenticacao servidor de e-mail
	cRelUsr := AllTrim(GetMV("MV_RELAUSR")) //Usuario autenticacao de email
	cServer := Iif( cServer == NIL, AllTrim(GetMV("MV_RELSERV")), cServer) //Nome do servidor de email utilizado nos relatorios
	cAttach :=  cArqEnt //Iif( cAttach == NIL, "" , cAttach ) //
	cFrom := Iif( cFrom == NIL, AllTrim(GetMV("MV_RELFROM")), cFrom ) //Utilizado no campo FROM de envio de email
	cRelPSW := AllTrim(GetMV("MV_RELPSW")) //Senha para envio de relatorios

	cEmail := cEmailTo
	If At(";",cEmailTo) > 0 // existe um segundo e-mail.
		cEmailBcc:= SubStr(cEmailTo,At(";",cEmailTo)+1,Len(cEmailTo))
	Endif	
	//Conectar ao servidor SMTP
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

	//Envia o e-mail para a lista selecionada. Envia como BCC para que a pessoa pense que somente ela recebeu aquele email, tornando o email mais personalizado.
	If lResult == .T.
		// Se existe autenticacao para envio valida pela funcao MAILAUTH
		If lRelauth //MV_RELAUTH: T-Servidor de email precisa de autenticacao ou F-Nao precisa
			lRet := Mailauth(cAccount, cPassword)	
		Else
			lRet := .T.	
		Endif

		If lRet == .T.
			SEND MAIL FROM cFrom TO cEmailTo SUBJECT cAssunto BODY cMensagem RESULT lResult //SEND MAIL FROM cFrom TO cEmailTo BCC cEmailBcc SUBJECT ACTxt2Htm(cAssunto,cEmailTo) BODY ACTxt2Htm(cMensagem,cEmailTo) ATTACHMENT cAttach RESULT lRet
                                                              //ATTACHMENT cAttach
			if !lResult
				//Erro no envio do email
				GET MAIL ERROR cError
				Help(" ",1,"ATENCAO",,cError+ " " + cEmailTo,4,5)
			endif
		else
			GET MAIL ERROR cError
			Help(" ",1,"Autenticacao",,cError,4,5)
			MsgStop("Erro de autenticação","Verifique a conta e a senha para envio")
			if lMsg
				Alert("E-Mail enviado com sucesso! "+cEmailTo)
			endif
		EndIf
		DISCONNECT SMTP SERVER
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
	EndIf
return(lResult)


/*   -- Consulta dados para geracao do arquivo texto -- 
SELECT F2.F2_DOC,F2.F2_SERIE,F2.F2_EMISSAO,F2.F2_VALBRUT,D2.D2_CF,F2.F2_VALICM, E1.E1_VENCTO,'01' ESPECIENF,F2.F2_VALIPI, F2.F2_DESPESA, F2.F2_FRETE, F2.F2_SEGURO,
           (SELECT SUM(D2.D2_DESC) FROM SD2010 D2 WHERE D2.D_E_L_E_T_='' AND D2.D2_FILIAL='16' AND D2.D2_DOC=F2.F2_DOC) D2_DESC,F2.F2_BASEICM,D2.D2_ITEMPV,
           D2.D2_QUANT,D2.D2_UM,B1.B1_POSIPI,D2.D2_IPI,D2.D2_PRUNIT, ((D2.D2_DESC/D2.D2_PRUNIT)*100) D2_PERCDE,
          D2.D2_PICM,D2.D2_BASEICM,D2.D2_COD,D2.D2_VALICM,D2.D2_VALIPI,(SELECT F4.F4_SITTRIB FROM SF4010 F4 WHERE F4.D_E_L_E_T_='' AND F4.F4_FILIAL = '16' AND F4.F4_CODIGO=D2.D2_TES) D2_SITTRI,D2.D2_CF CFO,D2.D2_VALBRUT,
          A7.A7_PRODUTO,A7.A7_DESCCLI
FROM SF2010 F2
INNER JOIN SD2010  D2 ON (D2.D_E_L_E_T_='' AND D2.D2_FILIAL=F2.F2_FILIAL AND D2.D2_DOC=F2.F2_DOC)
INNER JOIN SE1010 E1 ON (E1.D_E_L_E_T_='' AND E1.E1_FILORIG=F2.F2_FILIAL AND E1.E1_NUM=F2.F2_DOC) 
INNER JOIN SB1010 B1 ON (B1.D_E_L_E_T_=''  AND B1.B1_COD=D2.D2_COD) 
INNER JOIN SA7010 A7 ON (A7.D_E_L_E_T_=''  AND A7.A7_CLIENTE='000007'  AND A7.A7_LOJA='02' AND A7.A7_PRODUTO=B1.B1_COD)
WHERE F2.D_E_L_E_T_=''
AND F2.F2_FILIAL='16'
AND F2.F2_EMISSAO >= '20091209' AND F2.F2_EMISSAO <= '20091209'
ORDER BY F2.F2_FILIAL, F2.F2_DOC
*/