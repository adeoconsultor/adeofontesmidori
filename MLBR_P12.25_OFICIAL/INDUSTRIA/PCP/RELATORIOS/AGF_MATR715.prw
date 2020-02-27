#INCLUDE "PROTHEUS.CH"

#define STR0001  "Transferencias entre filiais"
#define STR0002  "O relatorio ira imprimir as informacoes sobre as notas fiscais"
#define STR0003  "de transferencia entre filiais, imprimindo informacoes sobre as"
#define STR0004  "saidas e entradas de cada documento."
#define STR0005  "Zebrado"
#define STR0006  "Administracao"
#define STR0007  "CANCELADO PELO OPERADOR"
#define STR0008  "Produto"
#define STR0009  "Documento / Serie"
#define STR0010  "Data de emissao"
#define STR0011  "TOTAL GERAL EM TRANSITO FILIAL "
#define STR0012  "FILIAL DESCRICAO        DOCUMENTO SERIE TES CFO   DESCRICAO            PRODUTO         DESCRICAO PRODUTO         GRUPO UM QUANTIDADE     VALOR TOTAL     CUSTO TOTAL     DATA DE    | FILIAL  DESCRICAO        DATA DE  "
#define STR0013  "ORIGEM ORIGEM                           ORI ORIG  OPERACAO ORIGEM                                                                                                        EMISSAO    | DESTINO DESTINO          DIGITACAO"
#define STR0014  "TOTAL DO PRODUTO EM TRANSITO"
#define STR0015  "TOTAL DO DOCUMENTO EM TRANSITO"
#define STR0016  "TOTAL DA DATA EM TRANSITO"
#define STR0017  "FILIAL DESCRICAO        DOCUMENTO           SERIE TES   CFO            PRODUTO         DESCRICAO PRODUTO         GRUPO UM QUANTIDADE     VALOR TOTAL     CUSTO TOTAL     DATA DE    | FILIAL  DESCRICAO        DATA DE  "
#define STR0018  "ORIGEM ORIGEM                               ORI   ORIG                                                                                                                   EMISSAO    | DESTINO DESTINO          DIGITACAO"

#DEFINE PICVAL  "@E 999,999,999.99"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MATR715   ³ Autor ³ Rodrigo de A Sartorio ³ Data ³ 29.01.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de transferencias entre filiais                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AGF_MATR715()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Variaveis                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local Titulo  := STR0001    //"Transferencias entre filiais"                                     // Titulo do Relatorio
Local cDesc1  := STR0002    //"O relatorio ira imprimir as informacoes sobre as notas fiscais"   // Descricao 1
Local cDesc2  := STR0003    //"de transferencia entre filiais, imprimindo informacoes sobre as"  // Descricao 2
Local cDesc3  := STR0004    //"saidas e entradas de cada documento."                             // Descricao 3
Local cString := "SD2"      // Alias utilizado na Filtragem
Local lDic    := .F.        // Habilita/Desabilita Dicionario
Local lComp   := .T.        // Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro := .T.        // Habilita/Desabilita o Filtro
Local wnrel   := "AGF_MATR715"  // Nome do Arquivo utilizado no Spool
Local nomeprog:= "AGF_MATR715"  // nome do programa

Private Tamanho := "G" // P/M/G
Private Limite  := 220 // 80/132/220
Private aOrdem  := {STR0008,STR0009,STR0010}  //"Produto"###"Documento / Serie"###"Data de emissao"
//Private cPerg   := "MTR715"  // Pergunta do Relatorio
Private aReturn := { STR0005, 1,STR0006, 1, 2, 1, "",1 } //"Zebrado"###"Administracao"


Private cPerg   := "AGFTRFL"
Private aConteud    := {}       
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab        := "" 



//[1] Reservado para Formulario
//[2] Reservado para N§ de Vias
//[3] Destinatario
//[4] Formato => 1-Comprimido 2-Normal
//[5] Midia   => 1-Disco 2-Impressora
//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
//[7] Expressao do Filtro
//[8] Ordem a ser selecionada
//[9]..[10]..[n] Campos a Processar (se houver)

Private lEnd    := .F.// Controle de cancelamento do relatorio
Private m_pag   := 1  // Contador de Paginas
Private nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza o acerto no grupo de perguntas MTR715 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Pergunte(cPerg,.F.)

aDir := MDirArq()
AjustaSX1()
If ! Pergunte(cPerg,.T.)
	Return
Endif
If Empty(aDir[1]) .OR. Empty(aDir[2])
	Return
Else                      
		Processa({ || AGF_TRFIL1()}, 'Gerando informacoes...')

		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia para a SetPrinter                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,,lFiltro)
/*If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif
SetDefault(aReturn,cString)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif
RptStatus({|lEnd| ImpDet(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo) */
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ ImpDet   ³ Autor ³ Rodrigo de A Sartorio ³ Data ³29.01.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Controle de Fluxo do Relatorio.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AGF_TRFIL1(lEnd,wnrel,cString,nomeprog,Titulo)
Local aStrucSD2 :={}
Local aFilsCalc :={}                 				// Array com dados das filiais
Local aAreaSM0  := SM0->(GetArea()) 				// Status original do arquivo SM0
Local cFilBack  := cFilAnt           		 		// Filial corrente original
Local aRetNf    := {}                				// Informacoes relacionadas a transferencia entre filiais
Local cSeek     := ""                				// Variavel utilizada na quebra
Local cWhile    := ""                				// Variavel utilizada na quebra
Local cTexto    := ""                				// Texto para totalizacao utilizada na quebra
// Texto para totalizacao geral
Local cTextoGer := STR0011 //"TOTAL GERAL EM TRANSITO FILIAL "
Local cName 	:= "" 								// Nome do campo utilizado no filtro
Local cQryAd 	:= "" 						   		// Campos adicionados na query conforme filtro de Usuario
Local aTotais   := {0,0,0}				  			// Array para totalizacao utilizada na quebra
Local aTotaisGer:= {0,0,0}				 			// Array para totalizacao geral
Local li        := 100               				// Contador de Linhas
Local cbCont    := 0                 				// Numero de Registros Processados
Local cbText    := ""                				// Mensagem do Rodape
Local cQuery    := ""  								// Query para filtragem
Local lQuery    := .F.								// Variavel que indica filtragem
Local cAliasSD2 := "SD2"							// Alias para processamento
Local nTamDoc   := TamSX3("D2_DOC")[1]
Local nX		:= 0
//
//                                  1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21      22
//                        01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local cCabec1:=STR0012 //"FILIAL DESCRICAO        DOCUMENTO SERIE TES CFO   DESCRICAO            PRODUTO         DESCRICAO PRODUTO         GRUPO UM QUANTIDADE     VALOR TOTAL     CUSTO TOTAL     DATA DE    | FILIAL  DESCRICAO FILIAL DATA DE  "
Local cCabec2:=STR0013 //"ORIGEM ORIGEM                           ORI ORIG  OPERACAO ORIGEM                                                                                                        EMISSAO    | DESTINO DESTINO          DIGITACAO"
//                        XX     XXXXXXXXXXXXXXX  XXXXXX    XXX   XXX XXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXX XXXXX XX XXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXX | XX      XXXXXXXXXXXXXXX  XXXXXXXXXX
//                        12     123456789012345  123456    123   123 12345 12345678901234567890 123456789012345 1234567890123456789012345 12345 12 12345678901234 123456789012345 123456789012345 1234567890 | 12      123456789012345  1234567890

//                  1         2           3         4       5      6          7                  8            9               10    11      12            13            14            15         16             17              18   
aAdd(aConteud, {"FILIAL","DESCRICAO","DOCUMENTO","SERIE", "TES", "CFO ", "DESCRICAO      ", "PRODUTO", "DESCRICAO PRODUTO","GRUPO","UM","QUANTIDADE","VALOR TOTAL", "CUSTO TOTAL", "DATA DE ","|FILIAL ", "DESCRICAO FILIAL","DATA DE  " }) //18 Colunas
aAdd(aConteud, {"ORIGEM","         ","ORIGEM   ","     ", "ORI", "ORIG", "OPERACAO ORIGEM", "       ", "                 ","     ","  ","          ","           ", "           ", "EMISSAO ","|DESTINO", "DESTINO         ","DIGITACAO" }) //18 Colunas
// Caso o tamanho do campo documento seja maior que 9 mudar o cabecalho
If nTamDoc > 9
//                                  1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21      22
//                        01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	cCabec1 := STR0017 //"FILIAL DESCRICAO        DOCUMENTO           SERIE TES   CFO            PRODUTO         DESCRICAO PRODUTO         GRUPO UM QUANTIDADE     VALOR TOTAL     CUSTO TOTAL     DATA DE    | FILIAL  DESCRICAO        DATA DE  "
	cCabec2 := STR0018 //"ORIGEM ORIGEM                               ORI   ORIG                                                                                                                   EMISSAO    | DESTINO DESTINO          DIGITACAO"
//                        XX     XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX XXX  XXX   XXXXX          XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXX XXXXX XX XXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXX | XX      XXXXXXXXXXXXXXX  XXXXXXXXXX
//                        12     123456789012345  12345678901234567890 123   123  12345          123456789012345 1234567890123456789012345 12345 12 12345678901234 123456789012345 123456789012345 1234567890 | 12      123456789012345  1234567890
EndIf

// Posiciona arquivos utilizados nas ordens corretas
dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SF4")
dbSetOrder(1)

// Varre arquivo de itens de nota fiscal da filial posicionada
dbSelectArea("SD2")
//SetRegua(LastRec())
If aReturn[8] == 1 // Ordem por produto 
	dbSetOrder(1)
	cWhile   := "D2_FILIAL+D2_COD"  
	cTexto   := STR0014 //"TOTAL DO PRODUTO EM TRANSITO"
ElseIf aReturn[8] == 2 // Ordem de documento
	dbSetOrder(3)                   
	cWhile   := "D2_FILIAL+D2_DOC+D2_SERIE"  
	cTexto   := STR0015 //"TOTAL DO DOCUMENTO EM TRANSITO"
ElseIf aReturn[8] == 3 // Ordem de data
	dbSetOrder(5)                         
	cWhile   := "D2_FILIAL+DTOS(D2_EMISSAO)"  	
	cTexto   := STR0016 //"TOTAL DA DATA EM TRANSITO"	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega filiais da empresa corrente                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SM0")
dbSeek(cEmpAnt)
Do While ! Eof() .And. SM0->M0_CODIGO == cEmpAnt
	// Adiciona filial
	Aadd(aFilsCalc,{SM0->M0_CODFIL,SM0->M0_CGC,SM0->M0_FILIAL})
	dbSkip()
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Varre filiais da empresa corrente                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSeek(cEmpAnt)
Do While ! Eof() .And. SM0->M0_CODIGO == cEmpAnt
	cFilAnt:=SM0->M0_CODFIL
	aTotaisGer:= {0,0,0}
	// Filtra filial da nota fiscal de saida
	If cFilAnt < mv_par01 .Or. cFilAnt > mv_par02
		dbSkip()
		Loop
	EndIf
	dbSelectArea("SD2")

	#IFDEF TOP
		cQuery := "SELECT SD2.D2_FILIAL,SD2.D2_EMISSAO,SD2.D2_DOC,SD2.D2_SERIE,SD2.D2_COD,SD2.D2_TES,SD2.D2_CF,SD2.D2_UM,"
		cQuery += "SD2.D2_QUANT,SD2.D2_TOTAL,SD2.D2_CUSTO1,SD2.D2_TIPO,SD2.D2_CLIENTE,SD2.D2_LOJA"
	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Esta rotina foi escrita para adicionar no select os campos         ³
		//³usados no filtro do usuario quando houver, a rotina acrecenta      ³
		//³somente os campos que forem adicionados ao filtro testando         ³
		//³se os mesmo já existem no select ou se forem definidos novamente   ³
		//³pelo o usuario no filtro, esta rotina acrecenta o minimo possivel  ³
		//³de campos no select pois a tabela SD1 tem muitos campos e a query  |
		//³pode derrubar o TOP CONNECT e abortar o sistema				      |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	   	
		aStrucSD2 := SD2->(dbStruct())
		 If !Empty(aReturn[7])
		 	For nX := 1 To SD2->(FCount())
		 	cName := SD2->(FieldName(nX))
		 	If AllTrim( cName ) $ aReturn[7]
		      	If aStrucSD2[nX,2] <> "M"  
		      		If !cName $ cQuery .And. !cName $ cQryAd
		        		cQryAd += "," + cName 
		          	Endif 	
		       	EndIf
			EndIf 			       	
		 	Next nX
     	 Endif     
			 
			 If !Empty(cQryAd)
				cQuery+= cQryAd
			 EndIf	
		lQuery    := .T.
		cAliasSD2 := GetNextAlias()  
		cQuery += " FROM "
		cQuery += RetSqlName("SD2")+" SD2 ,"+RetSqlName("SF4")+" SF4 WHERE SD2.D2_FILIAL='"+xFilial("SD2")+"' AND SD2.D_E_L_E_T_ <> '*' AND "
		cQuery += "SF4.F4_FILIAL='"+xFilial("SF4")+"' AND SF4.D_E_L_E_T_ <> '*' AND "
		cQuery += "SF4.F4_TRANFIL = '1' AND SF4.F4_CODIGO = SD2.D2_TES AND "
		cQuery += "SD2.D2_EMISSAO >= '"+DTOS(mv_par03)+"' AND SD2.D2_EMISSAO <= '"+DTOS(mv_par04)+"' AND "
		cQuery += "SD2.D2_DOC >= '"+mv_par05+"' AND SD2.D2_DOC <= '"+mv_par06+"' AND "
		cQuery += "SD2.D2_SERIE >= '"+mv_par07+"' AND SD2.D2_SERIE <= '"+mv_par08+"' AND "
		cQuery += "SD2.D2_COD >= '"+mv_par09+"' AND SD2.D2_COD <= '"+mv_par10+"' "
		cQuery += "ORDER BY " + SqlOrder(SD2->(IndexKey()))
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)
		aEval(SD2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasSD2,x[1],x[2],x[3],x[4]),Nil)})
		dbSelectArea(cAliasSD2)
	#ELSE
		dbSeek(xFilial("SD2"))
	#ENDIF
	Do While !Eof() .And. xFilial("SD2") == D2_FILIAL
		If lEnd
			aConteud[len(aconteud)][1] := "CANCELADO PELO OPERADOR..." 
			Exit
		EndIf
//		IncRegua()
		// Valida o Filtro de Usuario
		If !Empty(aReturn[7]) .And. !&(aReturn[7])
			dbSkip()
			Loop
		EndIf	  
		// So efetua filtragem caso nao tenha efetuado na query		
		If !lQuery
			// Filtra emissao da nota fiscal de saida
			If D2_EMISSAO < mv_par03 .Or. D2_EMISSAO > mv_par04
				dbSkip()
				Loop
			EndIf
			// Filtra documento da nota fiscal de saida
			If D2_DOC < mv_par05 .Or. D2_DOC > mv_par06
				dbSkip()
				Loop
			EndIf
			// Filtra serie da nota fiscal de saida
			If D2_SERIE < mv_par07 .Or. D2_SERIE > mv_par08
				dbSkip()
				Loop
			EndIf
			// Filtra produto da nota fiscal de saida
			If D2_COD < mv_par09 .Or. D2_COD > mv_par10
				dbSkip()
				Loop
			EndIf
		EndIf
		// Totaliza de acordo com a escolha o usuario
		cSeek := &(cWhile)
		aTotais:={0,0,0}
		Do While !Eof() .And. cSeek  == &(cWhile)
			// Valida o Filtro de Usuario
			If !Empty(aReturn[7]) .And. !&(aReturn[7])
				dbSkip()
				Loop
			EndIf		
			// So efetua filtragem caso nao tenha efetuado na query
			If !lQuery
				// Filtra emissao da nota fiscal de saida
				If D2_EMISSAO < mv_par03 .Or. D2_EMISSAO > mv_par04
					dbSkip()
					Loop
				EndIf
				// Filtra documento da nota fiscal de saida
				If D2_DOC < mv_par05 .Or. D2_DOC > mv_par06
					dbSkip()
					Loop
				EndIf
				// Filtra serie da nota fiscal de saida
				If D2_SERIE < mv_par07 .Or. D2_SERIE > mv_par08
					dbSkip()
					Loop
				EndIf
				// Filtra produto da nota fiscal de saida
				If D2_COD < mv_par09 .Or. D2_COD > mv_par10
					dbSkip()
					Loop
				EndIf
			EndIf
			// Checa TES
			If lQuery .Or. (!lQuery .And. SF4->(MsSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)) .And. SF4->F4_TRANFIL == "1")
				aRetNF:=MR715BuscaNF(aFilsCalc,cAliasSD2)
				// Checa status de acordo com o parametro
				If mv_par11 == 3 .Or. (mv_par11 == 2 .And. Len(aRetNF) > 0) .Or. (mv_par11 == 1  .And. Len(aRetNf) == 0)
					// Imprime linha
//					If ( li > 58 )
//						li := cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,If(aReturn[4]==1,15,18))
//						li++
//					Endif
//aAdd(aConteud, {"FILIAL","DESCRICAO","DOCUMENTO","SERIE", "TES", "CFO ", "DESCRICAO      ", "PRODUTO", "DESCRICAO PRODUTO","GRUPO","UM","QUANTIDADE","VALOR TOTAL", "CUSTO TOTAL", "DATA DE ","|FILIAL ", "DESCRICAO FILIAL","DATA DE  " }) //18 Colunas
                    // Posiciona no produto
					aAdd(aConteud, {"","","","","","","","","","",0,0,0,0,"","","",""})
                    SB1->(MsSeek(xFilial("SB1")+(cAliasSD2)->D2_COD))
                    aConteud[len(aconteud)][1] := Substr(cFilAnt,1,2)+"'"
					aConteud[len(aconteud)][2] := Substr(SM0->M0_FILIAL,1,15)
					aConteud[len(aconteud)][3] := Substr((cAliasSD2)->D2_DOC,1,nTamDoc)+"'"
					aConteud[len(aconteud)][4] := Substr((cAliasSD2)->D2_SERIE,1,3)+"'"
					aConteud[len(aconteud)][5] := Substr((cAliasSD2)->D2_TES,1,3)+"'"
					aConteud[len(aconteud)][6] := Substr((cAliasSD2)->D2_CF,1,5)+"'"
					aConteud[len(aconteud)][7] := Posicione("SF4",1,xFilial("SF4")+(cAliasSD2)->D2_TES,"F4_TEXTO")
					aConteud[len(aconteud)][8] := Substr((cAliasSD2)->D2_COD,1,15)+"'"
					aConteud[len(aconteud)][9] := Substr(SB1->B1_DESC,1,25)
					aConteud[len(aconteud)][10] := Substr(SB1->B1_GRUPO,1,5)+"'"
					aConteud[len(aconteud)][11] := Substr((cAliasSD2)->D2_UM,1,2)
					aConteud[len(aconteud)][12] := (cAliasSD2)->D2_QUANT //Picture PesqPict("SD2","D2_QUANT",14)
					aConteud[len(aconteud)][13] := (cAliasSD2)->D2_TOTAL //Picture PesqPict("SD2","D2_TOTAL",15)
					aConteud[len(aconteud)][14] := (cAliasSD2)->D2_CUSTO1 //Picture PesqPict("SD2","D2_CUSTO1",15)
					aConteud[len(aconteud)][15] := dToc((cAliasSD2)->D2_EMISSAO)
					// Imprime informacoes da devolucao
					If Len(aRetNf) > 0
						aConteud[len(aconteud)][16] := aRetNf[1]+"'"
						aConteud[len(aconteud)][17] := Substr(aRetNf[2],1,15)
						aConteud[len(aconteud)][18] := dToc(aRetNf[3])
					// Soma valores em transito
					Else
						aTotais[1]+=(cAliasSD2)->D2_QUANT;aTotaisGer[1]+=(cAliasSD2)->D2_QUANT
						aTotais[2]+=(cAliasSD2)->D2_TOTAL;aTotaisGer[2]+=(cAliasSD2)->D2_TOTAL
						aTotais[3]+=(cAliasSD2)->D2_CUSTO1;aTotaisGer[3]+=(cAliasSD2)->D2_CUSTO1
					EndIf 
					li++
					cbCont++
				EndIf
			EndIf
			dbSelectArea(cAliasSD2)
			dbSkip()
		EndDo
		// Imprime total caso tenha quantidade em transito
		If mv_par12 == 1 .And. (QtdComp(aTotais[1],.T.) > QtdComp(0,.T.))
		aAdd(aConteud, {"TOTAL-->>","","","","","","","","","",0,0,0,0,"","","",""})		
			aConteud[len(aconteud)][12] := aTotais[1]
			aConteud[len(aconteud)][13] := aTotais[2]
			aConteud[len(aconteud)][12] := aTotais[3]
			aTotais:={0,0,0}      
			li+=2
		EndIf
	EndDo
	// Fecha arquivo da query
	If lQuery
		dbSelectArea(cAliasSD2)
		dbCloseArea()
		dbSelectArea("SD2")
	EndIf
	// Imprime total caso tenha quantidade em transito
	If QtdComp(aTotaisGer[1],.T.) > QtdComp(0,.T.)     
 		li+=2
		aAdd(aConteud, {cTextoGer+cFilAnt+"-->","","","","","","","","","",0,0,0,0,"","","",""})		 		
			aConteud[len(aconteud)][12] := aTotaisGer[1]
			aConteud[len(aconteud)][12] := aTotaisGer[2]
			aConteud[len(aconteud)][12] := aTotaisGer[3]
		aTotaisGer:={0,0,0}      
		li+=2
	EndIf
	dbSelectArea("SM0")
	dbSkip()
EndDo
// Restaura filial original
cFilAnt:=cFilBack
RestArea(aAreaSM0)

/*
If cbCont > 0
	Roda(cbCont,cbText,Tamanho)
EndIf

Set Device To Screen
Set Printer To
If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH() */
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ MR715BuscaNF                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Rodrigo de Almeida Sartorio              ³ Data ³ 29/01/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Busca as informacoes da nota fiscal de transferencia       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³aFilsCalc  Array com informacoes das filiais da empresa     ³±±
±±³           ³           em uso corrente no sistema.                      ³±±
±±³           ³cAliasSD2  Area do arquivo de itens de NF de saida          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³aRetNF     Array com informacoes da nota de retorno         ³±±
±±³           ³           [1] Codigo da filial que recebeu a nota          ³±±
±±³           ³           [2] Descricao da filial que recebu a nota        ³±±
±±³           ³           [3] Data de digitacao da nota                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Uso      ³ MATR715                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MR715BuscaNF(aFilsCalc,cAliasSD2)
Local aRetNf    := {}
Local nAchoCGC  := 0
Local aArea     := GetArea()
Local cFilBack  := cFilAnt
Local cCGCOrig  := ""
Local cCGCDest  := SM0->M0_CGC

// Posiciona no fornecedor
If (cAliasSD2)->D2_TIPO $ "DB"
	dbSelectArea("SA2")
	dbSetOrder(1)
	If MsSeek(xFilial("SA2")+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)
		cCGCOrig:=SA2->A2_CGC
	EndIf
Else
	// Posiciona no cliente
	cArqCliFor:="SA1"
	dbSelectArea("SA1")
	dbSetOrder(1)
	If MsSeek(xFilial("SA1")+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)
		cCGCOrig:=SA1->A1_CGC
	EndIf
EndIf

// Checa se cliente / fornecedor esta configurado como filial do sistema
If !Empty(cCGCOrig) .And. ((nAchoCGC:=ASCAN(aFilsCalc,{|x| x[2] == cCGCOrig})) > 0)
	// Pesquisa se nota fiscal ja foi registrada no destino
	cFilAnt := aFilsCalc[nAchoCGC,1]
	dbSelectArea("SD1")
	dbSetOrder(2)
	dbSeek(xFilial("SD1")+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_SERIE)
	While !Eof() .And. xFilial("SD1")+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_SERIE == D1_FILIAL+D1_COD+D1_DOC+D1_SERIE
		// Checa TES
		If SF4->(MsSeek(xFilial("SF4")+SD1->D1_TES)) .And. SF4->F4_TRANFIL == "1"
			// Itens de nota fiscal de entrada
			If SD1->D1_TIPO $ "DB"
				dbSelectArea("SA1")
				dbSetOrder(1)
				If MsSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA) .And. SA1->A1_CGC == cCGCDest
					aRetNf:={cFilAnt,aFilsCalc[nAchoCGC,3],SD1->D1_DTDIGIT}
					Exit
				EndIf
			Else
				dbSelectArea("SA2")
				dbSetOrder(1)
				If MsSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA) .And. SA2->A2_CGC == cCGCDest
					aRetNf:={aFilsCalc[nAchoCGC,1] ,aFilsCalc[nAchoCGC,3],SD1->D1_DTDIGIT}
					Exit
				EndIf
			EndIf
		EndIf
		dbSelectArea("SD1")
		dbSkip()
	End
EndIf
// Reposiciona area original
cFilAnt:=cFilBack
RestArea(aArea)
RETURN aRetNf 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ AjustaSX1³ Autor ³ Microsiga S/A         ³ Data ³28/07/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Ajusta o grupo de perguntas MTR715                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR715  		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local nTamSX1  := Len(SX1->X1_GRUPO)
Local nTamDoc  := TamSX3("D2_DOC")[1]


PutSx1("AGFTRFL","01","Filial de ?"   		 ,"Filial de ?"   		  ,"Filial de ?"   ,"mv_ch1","C",2,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","")
PutSx1("AGFTRFL","02","Filial ate?"   		 ,"Filial ate?"   		  ,"Filial ate?"   ,"mv_ch2","C",2,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","")
PutSx1("AGFTRFL","03","Emissao de ?"  		 ,"Emissao de ?"  		  ,"Emissao de ?"  ,"mv_ch3","D",8,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","")
PutSx1("AGFTRFL","04","Emissao ate?"  		 ,"Emissao ate?"  		  ,"Emissao ate?"  ,"mv_ch4","D",8,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","")
PutSx1("AGFTRFL","05","Doc saida de ?"		 ,"Doc saida de ?"		  ,"Doc saida de ?","mv_ch5","C",6,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","")
PutSx1("AGFTRFL","06","Doc saida ate?"		 ,"Doc saida ate?"		  ,"Doc saida ate?","mv_ch6","C",6,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","")
PutSx1("AGFTRFL","07","Ser saida de ?"		 ,"Ser saida de ?"		  ,"Ser saida de ?","mv_ch7","C",3,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","")
PutSx1("AGFTRFL","08","Ser saida ate?"		 ,"Ser saida ate?"		  ,"Ser saida ate?","mv_ch8","C",3,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","")
PutSx1("AGFTRFL","09","Produto de ?"  		 ,"Produto de ?"  		  ,"Produto de ?"  ,"mv_ch9","C",15,0,0,"G","","","","","mv_par09","","","","","","","","","","","","","")
PutSx1("AGFTRFL","10","Produto ate?"  		 ,"Produto ate?"  		  ,"Produto ate?"  ,"mv_cha","C",15,0,0,"G","","","","","mv_par10","","","","","","","","","","","","","")
PutSx1("AGFTRFL","11","Lista NFs  ?"  		 ,"Lista NFs  ?"  		  ,"Lista NFs  ?"  ,"mv_chb","N",1,0,1,"C","","","","","mv_par11","Em transito","Em transito","Em transito","","Ja recebidas","Ja recebidas","Ja recebidas","Todas","Todas","Todas","","","","","","")
PutSx1("AGFTRFL","12","Totaliza nas quebras ?","Totaliza nas quebras ?","Totaliza nas quebras ?","mv_chc","N",1,0,1,"C","","","","","mv_par12","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","")

dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(PADR("AGFTRFL",nTamSX1)+"05") .And. X1_TAMANHO <> nTamDoc
	RecLock("SX1",.F.)
	Replace X1_TAMANHO 	with nTamDoc
	MsUnLock()
EndIf

dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(PADR("AGFTRFL",nTamSX1)+"06") .And. X1_TAMANHO <> nTamDoc
	RecLock("SX1",.F.)
	Replace X1_TAMANHO 	with nTamDoc
	MsUnLock()
EndIf

RestArea(aAreaSX1)
RestArea(aAreaAnt)
Return Nil




//+-----------------------------------------------------------------------------------//
//|Funcao....: MDirArq
//|Descricao.: Define Diretório e nome do arquivo a ser gerado
//|Retorno...: aRet[1] = Diretório de gravação
//|            aRet[2] = Nome do arquivo a ser gerado
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MDirArq()
*-----------------------------------------*
Local aRet := {"",""}
Private bFileFat:={|| cDir:=UZXChoseDir(),If(Empty(cDir),cDir:=Space(250),Nil)}
Private cArq    := Space(10)
Private cDir    := Space(250)
Private oDlgDir := Nil
Private cPath   := "Selecione diretório"
Private aArea   := GetArea()
Private lRetor  := .T.
Private lSair   := .F.

//+-----------------------------------------------------------------------------------//
//| Definição da janela e seus conteúdos
//+-----------------------------------------------------------------------------------//
While .T.
	DEFINE MSDIALOG oDlgDir TITLE "Definição de Arquivo e Diretório" FROM 0,0 TO 175,368 OF oDlgDir PIXEL
	
	@ 06,06 TO 65,180 LABEL "Dados do arquivo" OF oDlgDir PIXEL
	
	@ 15, 10 SAY   "Nome do Arquivo"  SIZE 45,7 PIXEL OF oDlgDir
	@ 25, 10 MSGET cArq               SIZE 50,8 PIXEL OF oDlgDir
	
	@ 40, 10 SAY "Diretorio de gravação"  SIZE  65, 7 PIXEL OF oDlgDir
	@ 50, 10 MSGET cDir PICTURE "@!"      SIZE 150, 8 WHEN .F. PIXEL OF oDlgDir
	@ 50,162 BUTTON "..."                 SIZE  13,10 PIXEL OF oDlgDir ACTION Eval(bFileFat)
	
	DEFINE SBUTTON FROM 70,10 TYPE 1  OF oDlgDir ACTION (UZXValRel("ok")) ENABLE
	DEFINE SBUTTON FROM 70,50 TYPE 2  OF oDlgDir ACTION (UZXValRel("cancel")) ENABLE
	
	ACTIVATE MSDIALOG oDlgDir CENTER
	
	If lRetor
		Exit
	Else
		Loop
	EndIf
EndDo

If lSair
	Return(aRet)
EndIf

aRet := {cDir,cArq}

Return(aRet)



*-----------------------------------------*
Static Function UZXChoseDir()
*-----------------------------------------*
Local cTitle:= "Geração de arquivo"
Local cMask := "Formato *|*.*"
Local cFile := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions:= GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY

cFile:= cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,.F., nOptions)

Return(cFile)


//+-----------------------------------------------------------------------------------//
//|Funcao....: UZXValRel()
//|Descricao.: Valida informações de gravação
//|Uso.......: U_UZXDIRARQ
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function UZXValRel(cValida)
*-----------------------------------------*

Local lCancela

If cValida = "ok"
	If Empty(Alltrim(cArq))
		MsgInfo("O nome do arquivo deve ser informado","Atenção")
		lRetor := .F.
	ElseIf Empty(Alltrim(cDir))
		MsgInfo("O diretório deve ser informado","Atenção")
		lRetor := .F.
		//	ElseIf Len(Alltrim(cDir)) <= 3
		//		MsgInfo("Não se pode gravar o arquivo no diretório raiz, por favor, escolha um subdiretório.","Atenção")
		//		lRetor := .F.
	Else
		oDlgDir:End()
		lRetor := .T.
	EndIf
Else
	lCancela := MsgYesNo("Deseja cancelar a geração do Relatório / Documento?","Atenção")
	If lCancela
		oDlgDir:End()
		lRetor := .T.
		lSair  := .T.
	Else
		lRetor := .F.
	EndIf
EndIf

Return(lRetor)


//+-----------------------------------------------------------------------------------//
//|Funcao....: MCSV
//|Descricao.: Gera Arvquivo do tipo csv
//|Retorno...: .T. ou .F.
//|Observação:
//+-----------------------------------------------------------------------------------//

*-------------------------------------------------*
Static Function MCVS(axVet,cxCab,cxArqTxt,PICTUSE)
*-------------------------------------------------*

Local cEOL       := CHR(13)+CHR(10)
Local nTamLin    := 2
Local cLin       := Space(nTamLin)+cEOL
Local cDadosCSV  := ""
Local lRet       := .T.
Local nHdl,nt,jk       := 0

If Len(axVet) == 0
	MsgInfo("Dados não informados","Sem dados")
	lRet := .F.
	Return(lRet)
ElseIf Empty(cxArqTxt)
	MsgInfo("Diretório e nome do arquivo não informados corretamente","Diretório ou Arquivo")
	lRet := .F.
	Return(lRet)
EndIf

cxArqTxt := cxArqTxt+".csv"
nHdl := fCreate(cxArqTxt)

If nHdl == -1
	MsgAlert("O arquivo de nome "+cxArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

nTamLin := 2
cLin    := Space(nTamLin)+cEOL

ProcRegua(Len(axVet))

If !Empty(cxCab)
	cLin := Stuff(cLin,01,02,cxCab)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no Cabeçalho. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		Endif
	Endif
EndIf

For jk := 1 to Len(axVet)
	nTamLin   := 2
	cLin      := Space(nTamLin)+cEOL
	cDadosCSV := ""
	IncProc("Gerando arquivo CSV")
	For nt := 1 to Len(axVet[jk])
		If ValType(axVet[jk,nt]) == "C"
			cDadosCSV += axVet[jk,nt]+Iif(nt = Len(axVet[jk]),"",";")
		ElseIf ValType(axVet[jk,nt]) == "N"
			cDadosCSV += Transform(axVet[jk,nt],PICTUSE)+Iif(nt = Len(axVet[jk]),"",";")
		ElseIf ValType(axVet[jk,nt]) == "U"
			cDadosCSV += +Iif(nt = Len(axVet[jk]),"",";")
		Else
			cDadosCSV += axVet[jk,nt]+Iif(nt = Len(axVet[jk]),"",";")
		EndIf
	Next
	cLin := Stuff(cLin,01,02,cDadosCSV)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo nos Itens. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		Endif
	Endif
Next
fClose(nHdl)
Return(lOk)

//+-----------------------------------------------------------------------------------//
//|Funcao....: MExcel
//|Descricao.: Abre arquivo csv em excel
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MExcel(cxDir,cxArq)
*-----------------------------------------*
Local cArqTxt := cxDir+cxArq+".csv"
Local cMsg    := "Relatorio gerado com sucesso!"+CHR(13)+CHR(10)+"O arquivo "+cxArq+".csv"
cMsg    += " se encontra no diretório "+cxDir

MsgInfo(cMsg,"Atenção")

If MsgYesNo("Deseja Abrir o arquivo em Excel?","Atenção")
	If ! ApOleClient( 'MsExcel' )
		MsgStop(" MsExcel nao instalado ")
		Return
	EndIf
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cArqTxt)
	oExcelApp:SetVisible(.T.)
EndIf

Return



