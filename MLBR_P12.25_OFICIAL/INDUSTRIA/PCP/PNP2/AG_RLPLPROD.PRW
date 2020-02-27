#INCLUDE "MATR820.CH"
#INCLUDE "RWMAKE.CH"
/*
Funcao de Emissao do Formulario CT - 08
Desenvolvido por Rogerio Nunes em 12/03/10
*/
//Static cAliasTop

User Function AG_MTR820()
Local titulo  := STR0039 //"Ordens de Producao"
Local cString := "SC2"
Local wnrel   := "MATR820"
Local cDesc   := STR0001	//"Este programa ira imprimir a Rela‡„o das Ordens de Produ‡„o"
Local aOrd    := {}	//"Por Numero"###"Por Produto"###"Por Centro de Custo"###"Por Prazo de Entrega"
Local tamanho := "P"

//Private aReturn  := {STR0006,1,STR0007, 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
Private aReturn  := {STR0006,1,STR0007, 3, 2, 2, "",3 }	//"Zebrado"###"Administracao"
Private cPerg    :="MDRLPL"
Private nLastKey := 0
Private lItemNeg := .F.
Private cMainOp
//
AjustaSx1()
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPErg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Do PLano                                ³
//³ mv_par02            // Ate o Plano                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//-- Verifica se o SH8 esta locado para atualizacao por outro processo
If !IsLockSH8()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd,.F.,Tamanho)
	
//6	lItemNeg := GetMv("MV_NEGESTR") .And. mv_par11 == 1
	
	If nLastKey == 27
		dbSelectArea("SH8")
		dbClearFilter()
		dbCloseArea()
		dbSelectArea("SC2")
		Return
	Endif
	//
	SetDefault(aReturn,cString)
	//
	If nLastKey == 27
		dbSelectArea("SH8")
		dbClearFilter()
		dbCloseArea()
		dbSelectArea("SC2")
		Return
	Endif
	
	RptStatus({|lEnd| R820Imp(@lEnd,wnRel,titulo,tamanho)},titulo)
	
EndIf

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R820Imp  ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 13.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R820Imp(lEnd,wnRel,titulo,tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbCont,cabec1,cabec2
Local limite     := 80
Local nQuant     := 1
Local nomeprog   := "MATR820"
Local nTipo      := 18
Local cProduto   := SPACE(LEN(SC2->C2_PRODUTO))
Local cQtd,i,nBegin
Local cIndSC2    := CriaTrab(NIL,.F.), nIndSC2
Local nPosMv1, nPosMv2

#IFDEF TOP
	Local bBlockFiltro := {|| .T.}
#ENDIF

Private li       := 80

//cAliasTop  := "TRBC2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
m_pag    := 1
lPrim    := .t.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1 := ""
cabec2 := ""
//
dbSelectArea("SC2")
DbSetOrder( 1 )
//

// cAliasTop := GetNextAlias()
/*cQuery := "SELECT SC2.R_E_C_N_O_ AS REC "
cQuery += " FROM "+RetSqlName("SC2")+" SC2 WHERE "
cQuery += "SC2.C2_FILIAL='"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_=' ' AND "
cQuery += "SC2.C2_OPMIDO >= '" +alltrim(MV_PAR01) +"' AND SC2.C2_OPMIDO <= '" + alltrim(MV_PAR02) + "' AND "
cQuery += "SC2.C2_EMISSAO between '"+dTos(MV_PAR03)+"' AND '"+dTos(MV_PAR04)+"' "
*/

nPosMv1 := RAT('/', MV_PAR01) - 1   
nPosMv2 := RAT('/', MV_PAR02) - 1    

//Alert(SUBSTR(UPPER(MV_PAR01),1,nPosMv1))  
//Alert(Substr(DTOS(MV_PAR03),1,4)) 
//Alert(SUBSTR(UPPER(MV_PAR01),nPosMv1,1))

dbSelectArea('SZP')
dbSetOrder(2)

if dbSeek(xFilial('SZP')+SUBSTR(UPPER(MV_PAR01),1,nPosMv1))
	while !SZP->(eof()).and.SZP->ZP_OPMIDO >= SUBSTR(UPPER(MV_PAR01),1,nPosMv1) .and. SZP->ZP_OPMIDO <= SUBSTR(UPPER(MV_PAR02),1,nPosMv2)
	//	while !SZP->(eof()).and.SZP->ZP_OPMIDO >= SUBSTR(UPPER(MV_PAR01),1,20) .and. SZP->ZP_OPMIDO <= SUBSTR(UPPER(MV_PAR02),1,20)
	if Substr(SZP->ZP_ANO,1,4) >= Substr(DTOS(MV_PAR03),1,4) .and. Substr(SZP->ZP_ANO,1,4) <= Substr(DTOS(MV_PAR04),1,4)
		IF lEnd
			@ Prow()+1,001 PSay STR0009	//"CANCELADO PELO OPERADOR"
	//		Exit
		EndIF
	

		cMainPLANO:= SZP->ZP_OPMIDO
	//
	//
		cProduto  := SZP->ZP_PRODUTO 

		dbSelectArea("SB1")
		dbSeek(xFilial()+cProduto)
		
//			Alert('Executar query')

			cQuery := " SELECT C2_OPMIDO, C2_EMISSAO, G1_COMP, SUM(C2_QUANT * (G1_QUANT /(1- (G1_PERDA/100)))) QTDE from "
//			cQuery := " SELECT C2_OPMIDO, C2_EMISSAO, G1_COMP, SUM(G1_QUANT * C2_QUANT) QTDE from "
			cQuery += " SC2010 SC2, SG1010 SG1, SB1010 SB1 "
			cQuery += " where SC2.D_E_L_E_T_ = ' ' AND SG1.D_E_L_E_T_ = ' ' "
			cQuery += " and C2_PRODUTO = G1_COD "
			cQuery += " and C2_FILIAL = G1_FILIAL "
			cQuery += " and G1_COMP = B1_COD " 
			cQuery += " AND G1_INI <= '"+dTos(MV_PAR03)+"' AND G1_FIM >= '"+dTos(MV_PAR04)+"' "
			cQuery += " and B1_UM not in ('PC','CM','KT')  "
			cQuery += " and C2_EMISSAO between '"+dTos(MV_PAR03)+"' AND '"+dTos(MV_PAR04)+"' "
	//		cQuery += " and C2_FILIAL = '09' and C2_OPMIDO = '" +alltrim(MV_PAR01) +"' AND C2_OPMIDO <= '" + alltrim(MV_PAR02) + "' "
			cQuery += " and C2_FILIAL = '"+xFilial('SC2')+"' and C2_OPMIDO = '" +SZP->ZP_OPMIDO+"' " 
			If SUBSTR(MV_PAR01,nPosMv1,1) $ 'BCDM'
		   		cQuery += " and C2_OPMIDO LIKE '%" +SUBSTR(UPPER(MV_PAR01),nPosMv1,1)+"%' " 
			Endif
			cQuery += " and Substring(G1_COMP,1,3) <> 'MOD' "
			cQuery += " group by C2_OPMIDO, C2_EMISSAO, G1_COMP "
	
	   	   	MemoWrite("C:\TEMP\ct08.txt", cQuery)
	
				If Select("TRBC2") > 0
					DbSelectArea( "TRBC2" )
					DbCloseArea()
	   			Endif
			
				//
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBC2",.T.,.T.)
				
				//If SUBSTR(TRBC2->C2_OPMIDO,nPosMv1) = SUBSTR(UPPER(MV_PAR01),nPosMv1)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime cabecalho                                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cabecOp(Tamanho)
				lPrim := .T.
				//
									
				*	m_pag++
				Li := 0					// linha inicial - ejeta automatico
				//
				Roda(cbCont,'CT08      ' ,Tamanho)
				//Endif
	endif	
	SZP->(dbskip())

	Enddo
//
//
endif
dbSelectArea("SH8")
dbCloseArea()
//
If aReturn[5] = 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return NIL


//----------------------------------------------------
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ CabecOp  ³ Autor ³ Paulo Boschetti       ³ Data ³ 07/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta o cabecalho da Ordem de Producao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ CabecOp()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function CabecOp(Tamanho)

// Local cCabec1 := SM0->M0_NOME+STR0010	//"        O R D E M   D E   P R O D U C A O       NRO :"
Local cCabec1 := "          P L A N O   D E  P R O D U Ç Ã O "
Local cCabec2 := "Codigo                               Descricao                  Quantidade  UM.      Padrao"
//
//"CODIGO          DESCRICAO                      QUANTIDADE|UM|PADRAO
// XXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXX.XXX,XXXX | XXX | XXX.XXX,XXXX
// 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                  1                2                3                4               5                7                8

//Local cCabec3 := "                MATERIAIS DO PLANO                    |QUANTIDADE | UM | PADRAO"
//						      012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                                             1                2                3               4                 5                6               7

Local cCabec3 := "                MATERIAIS DO PLANO                      QUANTIDADE   UM   PADRAO"


Local nBegin

If li # 5
	li := 0
Endif
//
Cabec("","" ,"","",Tamanho,18,{ SM0->M0_NOME + ' - '+ SM0->M0_FILIAL +  cCabec1 + '            CT08 -   Pag. ' +TRANSFORM(m_pag,'999')  , ' Emissao: ' + DTOC( dDataBase ) + '                  Numero Plano : '+SZP->ZP_OPMIDO   +'             Núm Controle Protheus: ' + SZP->(ZP_NUM)   } , .f. )
//
//
SA1->( DbSetOrder( 1 ) )
SA1->(  DbSeek( xFilial('SA1') +  SZP->ZP_CLIENTE + SZP->ZP_LOJA  )  )
SB1->(  DbSeek( xFilial('SB1') +  SZP->ZP_PRODUTO  )   )
//
if  lPrim  
	@ li, 00 psay 'Cliente : ' + SZP->ZP_CLIENTE + '/' + SZP->ZP_LOJA + '-' + Substr(sa1->A1_NOME,1,28 )
	@ li, 50 psay 'C.N.P.J.: '
	@ li, 60 psay sa1->a1_cgc Picture pesqpict('SA1', 'A1_CGC' )
	Li ++
	//
	@Li,00 PSay 'Modelo: ' + Alltrim(SZP->ZP_produto )  +' - ' + Substr( SB1->B1_DESC, 1 , 45  ) // alltrim( aArray[1][1] )  +  " - " +Alltrim(aArray[1][2])	//"Produto: "
	if SZP->ZP_PLNPARC == 'S'
		if Select("TRB1")> 0 
			dbSelectArea('TRB1')
			TRB1->(dbCloseArea())
		endif
		cQSomaPC := " SELECT SUM(C2_QUANT) C2_QUANT FROM SC2010 WHERE D_E_L_E_T_ = ' ' AND C2_FILIAL = '"+xFilial("SC2")+"' "
		cQSomaPC += " AND C2_OPMIDO = '"+SZP->ZP_OPMIDO+"' AND C2_EMISSAO = '"+DTOS(SZP->ZP_EMISSAO)+"' "
		
		dbUseArea(.T., "TOPCONN", tcGenQry(,, cQSomaPC), 'TRB1', .T., .T.)

  		@Li, 59 Psay "Qtde PCs:" + Alltrim( Transform(TRB1->C2_QUANT	, '@E 99999999999999' )  )
  		nQtdPc := TRB1->C2_QUANT
	else
		@Li,63 PSay "Qtde. : " + Alltrim( Transform(SZP->ZP_QUANT	, '@E 99999999999999' )  ) + iif( sb1->b1_tipo == 'PA', '  KIT',' ' + sb1->b1_UM  )
	endif 
	//
	Li++
	//
	@Li,00 PSay 'Pedido Cliente : ' + SZP->ZP_RELEASE
	@ li,40  Psay 'MES : ' + Substr(    DTOC(SZP->ZP_DATPRI) , 4 )
	@ li,55  Psay 'Prev. Emb. : ' +  DTOC( SZP->ZP_DATPRF )
	Li ++
	//
	//
	@Li,00  PSay 'Prev. Inicio: '+DTOC(SZP->ZP_DATPRF)	//"Prev. : "
	@Li,52 PSay 'Prev. Conclusao: '+DTOC(SZP->ZP_DATPRI)	//"Prev. : "
	Li++
	@Li,00 PSay STR0023+SZP->ZP_CC				//"C.Custo: "
	@Li,42 PSay STR0024+'  / /    ' //DTOC(SC2->C2_DATAJI)	//"Ajuste: "
	@Li,62 PSay STR0024+'  / /    ' //DTOC(SC2->C2_DATAJF)	//"Ajuste: "
	Li++
//	If SC2->C2_STATUS == "S"
//		@Li,00 PSay STR0025						//"Status: OP Sacramentada"
//	ElseIf SC2->C2_STATUS == "U"
//		@Li,00 PSay STR0026						//"Status: OP Suspensa"
//	ElseIf SC2->C2_STATUS $ " N"
		@Li,00 PSay STR0027						//"Status: OP Normal"
//	EndIf
	@Li,42 PSay STR0028							//	"Real  :   /  /      Real  :   /  / "
	Li++
	
	if SZP->ZP_PLNPARC == 'S'
		@Li, 00 PSay "Multiplo das peças - PLANO PARCIAL"
	else
		@Li, 00 Psay "Multiplo Couro: "+Alltrim( Transform(SZP->ZP_MULTPLO	, '@E 99999999999' ) )
	endif
	@Li, 42 Psay "Armazém: "+SZP->ZP_LOCAL
	@Li, 62 Psay "Considera lado: "+iif(SZP->ZP_LADO=='S', 'SIM','NAO')
	Li++
	If !(Empty(SZP->ZP_OBS))
		@Li,00 PSay STR0029						//"Observacao: "
		For nBegin := 1 To Len(Alltrim(SZP->ZP_OBS)) Step 65
			@li,012 PSay Substr(SZP->ZP_OBS,nBegin,65)
			li++
		Next nBegin
	EndIf
	//
	Li++
	@ li,00 psay 'C O N F E R E N C I A  :'
	lI += 2
	@ LI,00 PSAY '1. ______________________________________________     ______/_______/_________'
	lI += 2
	@ LI,00 PSAY '2. ______________________________________________     ______/_______/_________'

	//
	lPrim    := .F.
		



		
Else
	@ LI,00 PSAY 'Continuacao do Plano : ' +  SZP->ZP_PLANO   +' Núm Controle Protheus: ' + SZP->(ZP_NUM) //+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
Endif
// Aqui termina o if
Li++
@Li,00 PSay __PrtFatLine()
//
//
//
//Li++
//@Li,00 PSay cCabec2
Li++
@Li,00 PSay cCabec3
Li++
@Li,00 PSay __PrtFatLine()
Li++
	dbSelectArea("TRBC2")
	dbGotop()
	while !TRBC2->(eof())
		@Li,00 PSay Substr(TRBC2->G1_COMP,1,8)
		@Li,08 PSay Substr(Posicione('SB1',1,xFilial('SB1')+TRBC2->G1_COMP, "B1_DESC"),1,45)
		@Li,59 Psay Alltrim( Transform(TRBC2->QTDE	, '@E 99,999.9999' ) )
		@Li,70 Psay Posicione('SB1',1,xFilial('SB1')+TRBC2->G1_COMP, "B1_UM")
		@Li,75 Psay Alltrim( Transform(TRBC2->QTDE / IIF(SZP->ZP_PLNPARC == 'S', nQtdPc, SZP->ZP_QUANT), '@E 99.9999' ) )
		TRBC2->(dbSkip())
		li++
	enddo
	
return

//--------------------------------------------------------------
Static Function AjustaSx1()
//
PutSx1(cPerg,"01","Do Plano "		,"Do Plano "		,"Do Plano "		,"mv_ch1"	,"C"	,20	,0	,0	,"G",,,,,"mv_par01",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg,"02","Ate o  Plano "	,"Ate o  Plano "	,"Ate o  Plano "	,"mv_ch2"	,"C"	,20	,0	,0	,"G",,,,,"mv_par02",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg,"03","Emissao de   "	,"Emissao de   "	,"Emissao de   "	,"mv_ch3"	,"D"	,08	,0	,0	,"G",,,,,"mv_par03",,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg,"04","Emissao ate  "	,"Emissao ate  "	,"Emissao ate  "	,"mv_ch4"	,"D"	,08	,0	,0	,"G",,,,,"mv_par04",,,,,,,,,,,,,,,,,,,)
//
Return Nil