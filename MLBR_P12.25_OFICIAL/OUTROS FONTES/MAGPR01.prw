#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MAGPR01  บ Autor ณ PrimaInfo          บ Data ณ 19/09/2009  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Recibo de entrega da cesta basica.                         บฑฑ
ฑฑบ          ณ Listagem de entrega de cesta basica.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10 Midori Atlantica                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MAGPR01

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cDesc1         := "Este programa tem como objetivo imprimir recibo e ou"
Local cDesc2         := "Listagem da Cesta Basica de acordo com os parametros"
Local cDesc3         := "informados pelo usuario."
Local cPict          := ""
Local Titulo         := "Cesta Basica"
Local nLin           := 03
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.

Private aOrd         := { "Unidade Trabalho","Filial" }
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "MAGPR01"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "MAGPR01"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "MAGPR01"
Private cString      := "SRA"

fPriPerg()
pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint(cString,NomeProg,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  11/02/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem   := aReturn[8]
Local lCont    := .F.
Local aInfo    := {}
Local cChave   := "@@"
Local cOldInfo := "@@"
Local nTotCC   := 0
Local dPeriodo := dDataBase

Private cFilDe, cFilAte
Private cMatDe, cMatAte, cCcDe, cCcAte
Private cLctDe, cLctAte,cSitFol,nCesta,cCatFol

pergunte(cPerg,.F.)

cFilDe   := mv_par01
cFilAte  := mv_par02
cMatDe   := mv_par03
cMatAte  := mv_par04
cCcDe    := mv_par05
cCcAte   := mv_par06
cSitFol  := StrTran(mv_par07,"*","")
cAnaSin  := mv_par08
cLctDe   := mv_par09
cLctAte  := mv_par10
nCesta   := mv_par11
cCatFol  := StrTran(mv_par12,"*","")

// Monta a Query Principal a Partir do Cadastro de Funcionarios
MsAguarde( {|| lCont := fMtaQuery(nOrdem)}, "Processando...", "Selecionado Registros no Banco de Dados..." )

If !lCont
	Aviso("ATENCAO","Nao Existem Dados para Este Relatorio",{"Sair"})
	Return
EndIf

If cAnaSin == 1 .Or. cAnaSin == 3
	
	nTotal := 1
	nLin   := 1
	
	dbSelectArea( "RRACB" )
	dbGoTop()
	Do While !Eof()
		dbSkip( 15 )
		If !Eof()
			nTotal := Recno()
		EndIf
	EndDo
	
	dbGoTop()
	
	SetRegua( nTotal )
	
	While !RRACB->(Eof())
		
		IncRegua()
		
		// Busca Informacoes da Filial
		If cOldInfo # RRACB->RA_FILIAL
			fInfo(aInfo,RRACB->RA_FILIAL)
			cOldInfo := RRACB->RA_FILIAL
		EndIf
		
		If nLin >= 58
			@ 0,00 Psay ""
			SetPrc(0,0)
			nLin := 1
		EndIf
		
		If cChave <> If(nOrdem==1,RRACB->(RA_ITEM+RA_CC),RRACB->(RA_FILIAL+RA_CC))
			
			If nOrdem == 1
				cChave := RRACB->(RA_ITEM+RA_CC)
			Else
				cChave := RRACB->(RA_FILIAL+RA_CC)
			EndIf
			
			@ 0,00 Psay ""
			SetPrc(0,0)
			nLin := 1
			
		EndIf
		
		@ nLin,030 PSAY chr(18) + " C E S T A  B A S I C A "
		nLin++
		@ nLin,026 PSAY Replicate("=",30)
		nLin+=3
		@ nLin,010 PSAY "FUNCIONARIO : " + RRACB->RA_MAT
		@ nLin,035 PSAY RRACB->RA_NOME
		nLin++
		@ nLin,010 PSAY "SETOR       : " + RRACB->RA_CC + " - " + RRACB->CTT_DESC01
		nLin+=3
		@ nLin,010 PSAY "Recebi da " + aInfo[3]
		nLin++
		@ nLin,010 PSAY "uma (01) Cesta Basica referente ao mes de "
		@ nLin,053 PSAY MesExtenso(dPeriodo)+"/"+Left(Dtos(dPeriodo),4)+"."
		nLin+=3
		@ nLin,010 PSAY aInfo[5]+",______de___________________________de________."
		nLin+=4
		@ nLin,025 PSAY Replicate("-",30)
		nLin++
		@ nLin,035 PSAY "NOME DO FUNCIONมRIO (POR EXTENSO)"
		nLin+=2
		@ nLin,001 PSAY "Obs:A Cesta Basica sera entregue exclusivamente nos dias estabelecidos em circular."
		nLin++
		@ nLin,001 PSAY Replicate("-",80)
		
		nLin+=13
		// nLin := 31 
		//SetPrc(0,0)
		
		RRACB->(dbSkip())
		
	Enddo
	
EndIf

If cAnaSin == 2 .Or. cAnaSin == 3
	
	dbSelectArea( "RRACB" )
	dbGoTop()
	nLin := 59
	
	While !RRACB->(Eof())
		
		// Busca Informacoes da Filial
		If cOldInfo # RRACB->RA_FILIAL
			fInfo(aInfo,RRACB->RA_FILIAL)
			cOldInfo := RRACB->RA_FILIAL
		EndIf
		
		If nLin >= 58
			@ 0,00 Psay ""
			SetPrc(0,0)
			nLin := 3
			@ nLin,020 PSAY aInfo[3]
			nLin+=3
			@ nLin,017 PSAY "Lista de Entrega da Cesta Basica "+MesExtenso(dPeriodo)+"/"+Left(dtos(dPeriodo),4)
			nLin+=3
		EndIf
		
		If cChave <> If(nOrdem==1,RRACB->(RA_ITEM+RA_CC),RRACB->(RA_FILIAL+RA_CC))
			
			If nOrdem == 1
				cChave := RRACB->(RA_ITEM+RA_CC)
			Else
				cChave := RRACB->(RA_FILIAL+RA_CC)
			EndIf
			
			If nTotCC > 0
				nLin++
				@ nLin,001 PSAY "Quant. Funcionarios " + Str(nTotCC,3)
				@ 0,00 Psay ""
				SetPrc(0,0)
				nLin := 3
				@ nLin,020 PSAY aInfo[3]
				nLin+=3
				@ nLin,017 PSAY "Lista de Entrega da Cesta Basica "+MesExtenso(dPeriodo)+"/"+Left(dtos(dPeriodo),4)
				nLin+=3
				nTotCC := 0
			EndIf
			
			@ nLin,010 PSAY RRACB->CTT_DESC01
			nLin+=4
			@ nLin,001 PSAY "Func.   Nome                                              Assinatura"
			nLin+=3
		EndIf
		
		@ nLin,001 PSAY RRACB->RA_MAT
		@ nLin,008 PSAY RRACB->RA_NOME
		@ nLin,050 PSAY Replicate("_",30)
		
		nLin+=3
		nTotCC++
		
		RRACB->(dbSkip())
		
	EndDo
	
EndIf

If nTotCC > 0
	@ nLin,001 PSAY "Quant. Funcionarios " + Str(nTotCC,3)
EndIf

RRACB->(dbCloseArea())

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMtaQuery บAutor  ณPrima Info          บ Data ณ  19/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fMtaQuery(nOrdem)

Local lRet    := .F.
Local cQuery

cQuery := "SELECT RA_FILIAL,RA_ITEM,RA_MAT,RA_NOME,RA_CC,RA_SITFOLH,RA_CESTAB"
cQuery += ",CTT_DESC01,'S' AS TEM_CESTA"
cQuery += "  FROM " + RetSqlName( "SRA" ) + " SRA," + RetSqlName( "CTT" ) + " CTT"
cQuery += " WHERE SRA.D_E_L_E_T_ <>'*'"
cQuery += "   AND CTT.D_E_L_E_T_ <>'*'"
cQuery += "   AND RA_CC = CTT_CUSTO"
cQuery += "   AND RA_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
cQuery += "   AND RA_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
cQuery += "   AND RA_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
cQuery += "   AND RA_SITFOLH LIKE '["+cSitFol+"]'"
cQuery += "   AND RA_CATFUNC LIKE '["+cCatFol+"]'"
//cQuery += "   AND RA_ITEM BETWEEN '" + cLctDe + "' AND '" + cLctAte + "'"
If nCesta == 1
	cQuery += "   AND RA_CESTAB ='S'"
ElseIf nCesta == 2
	cQuery += "   AND RA_CESTAB ='N'"
EndIf

If nOrdem == 1
	cQuery += " ORDER BY RA_ITEM, RA_CC, RA_NOME"
Else
	cQuery += " ORDER BY RA_FILIAL, RA_CC, RA_NOME"
EndIf

cQuery := ChangeQuery( cQuery )

TCQuery cQuery New Alias "RRACB"

dbSelectArea( "RRACB" )

If Used()
	lRet := .T.
EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  27/10/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fPriPerg()

Local aRegs := {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{ cPerg,'01','Filial De ?                  ','','','mv_ch1','C',02,0,0,'G','             ','mv_par01','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'02','Filial Ate ?                 ','','','mv_ch2','C',02,0,0,'G','NaoVazio     ','mv_par02','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'03','Matricula De ?               ','','','mv_ch3','C',06,0,0,'G','             ','mv_par03','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'04','Matricula Ate ?              ','','','mv_ch4','C',06,0,0,'G','NaoVazio     ','mv_par04','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'05','Centro Custo De ?            ','','','mv_ch5','C',10,0,0,'G','             ','mv_par05','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT','' })
aAdd(aRegs,{ cPerg,'06','Centro Custo Ate ?           ','','','mv_ch6','C',10,0,0,'G','NaoVazio     ','mv_par06','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT','' })
aAdd(aRegs,{ cPerg,'07','Situacao                     ','','','mv_ch7','C',05,0,0,'G','fSituacao'    ,'mv_par07',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','',''    ,'' })
aAdd(aRegs,{ cPerg,'08','Tipo de Relatorio ?          ','','','mv_ch8','N',01,0,0,'C','             ','mv_par08','Recibo           ','','','','','Listagem         ','','','','','Ambos'               ,'','','','',''                 ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'09','Unidade Trabalho De?         ','','','mv_ch9','C',02,0,0,'G','             ','mv_par09','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'10','Unidade Trabalho Ate?        ','','','mv_cha','C',02,0,0,'G','NaoVazio     ','mv_par10','                 ','','','','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'11','Cesta Basica ?               ','','','mv_chb','N',01,0,0,'C','NaoVazio     ','mv_par11','Sim              ','','','','','Nao              ','','','','','Ambos'               ,'','','','',''                 ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'12','Categoria                    ','','','mv_chc','C',15,0,0,'G','fCategoria'   ,'mv_par12',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','',''    ,'' })

ValidPerg(aRegs,cPerg)

Return
