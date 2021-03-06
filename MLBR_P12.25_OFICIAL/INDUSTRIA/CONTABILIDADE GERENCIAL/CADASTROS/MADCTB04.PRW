#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � AtuPro     � Autor � Marcio Kiyoshi      � Data � 22.08.08 潮�   POR SANDRO
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Atualizar campos no SB1 cadastrados na tabela ZZW010       潮�
北�          �                                                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Especifico                                                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
User Function MADCTB04()

Local cTitulo  := "Importa Contas Contabeis para Cadastro Produto "
Local nOpca
Local cCadastro
Local aSays    := {}, aButtons := {}

Private cPerg  := "CTBPROD"
Private cDesc1 := " Importacao Contas Contabeis para Cadastro de Produtos  "
Private cDesc2 := " as contas e campos em branco tamb閙 s鉶 importados da  "
Private cDesc3 := " Tabela  de  Conta  Contabil  X  Produtos  para  o  SB1 "
Private cDesc4 := " Cadastro de Produtos "

AADD(aSays,OemToAnsi(cDesc1))
AADD(aSays,OemToAnsi(cDesc2))
AADD(aSays,OemToAnsi(cDesc3))
AADD(aSays,OemToAnsi(cDesc4))

//AjustaSx1(cPerg)

If Pergunte(cPerg, .T. )
	
	nOpca    := 0                                                
	cCadastro:=OemToAnsi(cTitulo)
	
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End()}})
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End()}})
	
	FormBatch( cCadastro, aSays, aButtons )
	
	If nOpca == 1
		
		Processa({|lEnd| U_MADCTBSB1()}, "Atualizando Cadastro de Produtos")
		
	Endif
	
EndIf
Return() // MADCTB04()
/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  矼ADCTBSB1 篈utor  矼icrosiga           � Data �  12/18/06   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     � Adiciona as perguntas na Tabela de Perguntas (SX1) do      罕�
北�          � Microsiga.                                                 罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       �                                                            罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User Function MADCTBSB1()

Local aAreaAnt := GetArea()
Local nRec   := 0      

//Pergunte("CTBPROD", .F. ) // Posiciona no SX1.

dBSelectArea("ZZW")   
ZZW->(DbSetOrder(1)) //ZZW_FILIAL+ZZW_TPPROD+ZZW_GRUPO  
ZZW->(DbGoTop())
ProcRegua(0)

IF dBSeek(xFilial("ZZW") + Alltrim(mv_par02) + Alltrim(mv_par01))
//IF ZZW->( dBSeek(xFilial("ZZW") + PadR(Alltrim(mv_par02),TamSX3("ZZW_TPPROD")[1])  + PadR(Alltrim(mv_par01),TamSX3("ZZW_GRUPO")[1])) )
	
	dBSelectArea("SB1")
	//SB1->(dBSetOrder(11)) //B1_Filial+B1_TIPO+B1_GRUPO
	SB1->(dBSetOrder(12)) //B1_Filial+B1_TIPO+B1_GRUPO   
	SB1->(DbGoTop())
	IF SB1->(dBSeek(xFilial("SB1")+ZZW->ZZW_TPPROD+ZZW->ZZW_GRUPO))
		
		While !Eof() .and. (SB1->B1_TIPO == Alltrim(mv_par02) .and. Alltrim(SB1->B1_GRUPO) == Alltrim(mv_par01))
			
			IncProc("Gravando Ctas Contabeis no SB1 Grupo "+SB1->B1_GRUPO+ " Tipo "+SB1->B1_TIPO)
			
			RecLock ("SB1", .F.)  // INCLUO O DA DONA TABELA CADASTRO DE PRODUTO
			SB1->B1_CONTA   := ZZW ->ZZW_CONTA
			SB1->B1_ICMREC 	:= ZZW ->ZZW_ICMREC
			SB1->B1_ICMPAG 	:= ZZW ->ZZW_ICMPAG
			SB1->B1_ICMDEV 	:= ZZW ->ZZW_ICMDEV
			SB1->B1_ICMVD 	:= ZZW ->ZZW_ICMVD
			SB1->B1_ICMST 	:= ZZW ->ZZW_ICMST
			SB1->B1_IPIREC 	:= ZZW ->ZZW_IPIREC
			SB1->B1_IPIPAG	:= ZZW ->ZZW_IPIPAG
			SB1->B1_IPIDEV	:= ZZW ->ZZW_IPIDEV
			SB1->B1_IPIVD	:= ZZW ->ZZW_IPIVD
			SB1->B1_PISREC 	:= ZZW ->ZZW_PISREC
			SB1->B1_PISPAG	:= ZZW ->ZZW_PISPAG
			SB1->B1_PISDEV	:= ZZW ->ZZW_PISDEV
			SB1->B1_PISVD   := ZZW ->ZZW_PISVD
			SB1->B1_COFREC 	:= ZZW ->ZZW_COFREC
			SB1->B1_COFPAG	:= ZZW ->ZZW_COFPAG
			SB1->B1_COFDEV	:= ZZW ->ZZW_COFDEV
			SB1->B1_COFVD	:= ZZW ->ZZW_COFVD
			SB1->B1_PODER3 	:= ZZW ->ZZW_PODER3
			SB1->B1_PODEM3	:= ZZW ->ZZW_PODEM3
			SB1->B1_CPV   	:= ZZW ->ZZW_CPV
			SB1->B1_RECEITA := ZZW ->ZZW_RECEITA
			SB1->B1_DEVVD	:= ZZW ->ZZW_DEVVD
			SB1->B1_DEVCP	:= ZZW ->ZZW_DEVCP
			SB1->B1_FUNRUR	:= ZZW ->ZZW_FUNRUR
			SB1->B1_SAT		:= ZZW ->ZZW_SAT
			SB1->B1_SENAR	:= ZZW ->ZZW_SENAR
			SB1->B1_MONSTO	:= ZZW ->ZZW_MONSTO
			SB1->B1_ELABOR	:= ZZW ->ZZW_ELABOR
			SB1->B1_TRANS 	:= ZZW ->ZZW_TRANS
			SB1->B1_RECEXT 	:= ZZW ->ZZW_RECEXT
			SB1->B1_CPVEXT 	:= ZZW ->ZZW_CPVEXT
			SB1->B1_CONDIR 	:= ZZW ->ZZW_CONDIR
			SB1->B1_CONIND 	:= ZZW ->ZZW_CONIND
			SB1->B1_GERAIS 	:= ZZW ->ZZW_GERAIS
			SB1->B1_ESTDIR 	:= ZZW ->ZZW_ESTDIR
			SB1->B1_ESTIND 	:= ZZW ->ZZW_ESTIND
			SB1->B1_CONSUM 	:= ZZW ->ZZW_CONSUM       
			SB1->B1_X_ESTMP	:= ZZW ->ZZW_ESTMP
			SB1->B1_X_INVEN := ZZW ->ZZW_X_INVE   			
			MsUnlock()
			nRec++
			IncProc("Produto-> "+SB1->B1_COD)
			SB1->(dBSkip())
			
		EndDo   
		
		Aviso( "Atualiza玢o!", "Para o Grupo "+mv_par01+ "e Tipo "+mv_par02+ " conclu韉a ", { "OK" } )
		RestArea(aAreaAnt)
		dbCloseArea()		

	Endif
	
Else
	Aviso( "Aten玢o!", "Registro n鉶 consta no Cadastro de Ctas Contabeis x Produtos - Grupo "+mv_par01+ " e Tipo "+mv_par02 , { "OK" } )
	RestArea(aAreaAnt)
	dbCloseArea()
	Return()
	
Endif
RestArea(aAreaAnt)
Return() // MADCTBSB1()

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  矴ravaSX1  篈utor  � Sandro Albuquerque � Data �  12/18/06   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     � Adiciona as perguntas na Tabela de Perguntas (SX1) do      罕�
北�          � Microsiga.                                                 罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       �                                                            罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
Static Function AjustaSX1( cPerg )

Local aAreaAnt := GetArea()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

Local cHlp01   := " Grupo de Produto que receber� as contas contabeis no cadastro de produtos"
Local cVar01   := " Grupo de Produto "

Local cVar02   := " Tipo do Produto  "
Local cHlp02   := " Tipo de Produto que receber� as contas contabeis no cadastro de produtos "

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Primeiro grupo de Notas Fiscais                              �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁

aHelpPor := { cHlp01 }
aHelpEng := { cHlp01 }
aHelpSpa := { cHlp01 }
PutSX1(cPerg,"01",cVar01,"","","mv_ch1","C",4,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := { cHlp02 }
aHelpEng := { cHlp02 }
aHelpSpa := { cHlp02 }
PutSX1(cPerg,"02",cVar02,"","","mv_ch2","C",2,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

RestArea(aAreaAnt)

Return( Nil )





////FUNCAO PARA RODAR TODOS OS GRUPOS DE UMA VEZ
//USER FUNCTION AG_DCTBSB1()
//	Processa({|lEnd| U_MADCTBSB1()}, "Atualizando Cadastro de Produtos")
//return 

User Function AG_DCTBSB1()

Local aAreaAnt := GetArea()
Local nRec   := 0
 
Pergunte("CTBPROD", .F. ) // Posiciona no SX1.

dBSelectArea("ZZW")
dbGotop()

ProcRegua(0)
while !ZZW->(EOF())
//	IF dBSeek(xFilial("ZZW") + mv_par02 + mv_par01)
		
		dBSelectArea("SB1")
		dBSetOrder(11) //B1_Filial+B1_TIPO+B1_GRUPO
		IF dBSeek(xFilial("SB1")+ZZW->ZZW_TPPROD+ZZW->ZZW_GRUPO)
			
			While !Eof() .and. (SB1->B1_TIPO == ZZW->ZZW_TPPROD .and. Substr(Alltrim(SB1->B1_GRUPO),1,2) == Substr(Alltrim(ZZW->ZZW_GRUPO),1,2))
				
				IncProc("Gravando Ctas Contabeis no SB1 Grupo "+SB1->B1_GRUPO+ " Tipo "+SB1->B1_TIPO)
				
				RecLock ("SB1")  // INCLUO O DA DONA TABELA CADASTRO DE PRODUTO
				SB1->B1_CONTA   := ZZW ->ZZW_CONTA
				SB1->B1_ICMREC 	:= ZZW ->ZZW_ICMREC
				SB1->B1_ICMPAG 	:= ZZW ->ZZW_ICMPAG
				SB1->B1_ICMDEV 	:= ZZW ->ZZW_ICMDEV
				SB1->B1_ICMVD 	:= ZZW ->ZZW_ICMVD
				SB1->B1_ICMST 	:= ZZW ->ZZW_ICMST
				SB1->B1_IPIREC 	:= ZZW ->ZZW_IPIREC
				SB1->B1_IPIPAG	:= ZZW ->ZZW_IPIPAG
				SB1->B1_IPIDEV	:= ZZW ->ZZW_IPIDEV
				SB1->B1_IPIVD	:= ZZW ->ZZW_IPIVD
				SB1->B1_PISREC 	:= ZZW ->ZZW_PISREC
				SB1->B1_PISPAG	:= ZZW ->ZZW_PISPAG
				SB1->B1_PISDEV	:= ZZW ->ZZW_PISDEV
				SB1->B1_PISVD   := ZZW ->ZZW_PISVD
				SB1->B1_COFREC 	:= ZZW ->ZZW_COFREC
				SB1->B1_COFPAG	:= ZZW ->ZZW_COFPAG
				SB1->B1_COFDEV	:= ZZW ->ZZW_COFDEV
				SB1->B1_COFVD	:= ZZW ->ZZW_COFVD
				SB1->B1_PODER3 	:= ZZW ->ZZW_PODER3
				SB1->B1_PODEM3	:= ZZW ->ZZW_PODEM3
				SB1->B1_CPV   	:= ZZW ->ZZW_CPV
				SB1->B1_RECEITA := ZZW ->ZZW_RECEITA
				SB1->B1_DEVVD	:= ZZW ->ZZW_DEVVD
				SB1->B1_DEVCP	:= ZZW ->ZZW_DEVCP
				SB1->B1_FUNRUR	:= ZZW ->ZZW_FUNRUR
				SB1->B1_SAT		:= ZZW ->ZZW_SAT
				SB1->B1_SENAR	:= ZZW ->ZZW_SENAR
				SB1->B1_MONSTO	:= ZZW ->ZZW_MONSTO
				SB1->B1_ELABOR	:= ZZW ->ZZW_ELABOR
				SB1->B1_TRANS 	:= ZZW ->ZZW_TRANS
				SB1->B1_RECEXT 	:= ZZW ->ZZW_RECEXT
				SB1->B1_CPVEXT 	:= ZZW ->ZZW_CPVEXT
				SB1->B1_CONDIR 	:= ZZW ->ZZW_CONDIR
				SB1->B1_CONIND 	:= ZZW ->ZZW_CONIND
				SB1->B1_GERAIS 	:= ZZW ->ZZW_GERAIS
				SB1->B1_ESTDIR 	:= ZZW ->ZZW_ESTDIR
				SB1->B1_ESTIND 	:= ZZW ->ZZW_ESTIND
				SB1->B1_CONSUM 	:= ZZW ->ZZW_CONSUM       
				SB1->B1_X_ESTMP	:= ZZW ->ZZW_ESTMP
				SB1->B1_X_INVEN := ZZW ->ZZW_X_INVE   			
				MsUnlock()
				nRec++
				
				dBSkip()
				
			EndDo
			
		Endif
		
/*	Else
		Aviso( "Aten玢o!", "Registro n鉶 consta no Cadastro de Ctas Contabeis x Produtos - Grupo "+mv_par01+ "e Tipo "+mv_par02 , { "OK" } )
		RestArea(aAreaAnt)
		dbCloseArea()
		Return()
		
	Endif */

	ZZW->(dbSkip())
enddo
Alert("ROTINA EXECUTADA COM SUCESSO....")
RestArea(aAreaAnt)
dbCloseArea()

Return() // MADCTBSB1()