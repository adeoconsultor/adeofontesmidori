#INCLUDE "rwmake.ch"
#include "PROTHEUS.CH"
#include "TOPCONN.CH" 


User Function AG_CADSZR	


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Cadastro de SZR. . ."
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} ,;
             {"Imprimir Ficha","U_FCRASPA( SZR->(RECNO()) )",0,1},;
             {"Gerar OP ", "U_OPSZR(SZR->(RECNO()))",0,1 },; 
             {"Imprimir Lista", "U_ListaSZR()", 0 ,1 }}
             

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZR"

dbSelectArea("SZR")
dbSetOrder(1)


dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return




///////////////////////////////////////////////////////////////////////////////
//Ficha para acompanhar o produto
///////////////////////////////////////////////////////////////////////////////

User Function FCRASPA(nRecno)

Local cQuery := ""          

Local wnrel
Local tamanho		:= "G"
Local titulo		:= "FICHA DE ENTRADA DE DROPS"
Local cDesc1		:= "FICHA DE ENTRADA DE DROPS"
Local cDesc2		:= ""
Local aSays     	:= {}, aButtons := {}, nOpca := 0

Private _aArea      := GetArea()
Private nomeprog 	:= "MD_GRFCORG"
Private nLastKey 	:= 0
Private cPerg    	:= "ENTDRP"
Private oPrint
Private aDadosPec   := {} //Array com todas as peças da ficha
Private aDadosCmp   := {} //Array com todas os componentes da ficha
//Private aDescri     := aDesc
//Private lTitFT      := If(Valtype(aDesc)=="A",.F.,.T.)    //lTitFT = .T. -->titulo tipo "FT", senao conteudo de aDesc eh um array
//Private xRotOrig    := xRotina   

Private oFontAr8	:= TFont():New("Arial", 8, 8,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr9	:= TFont():New("Arial", 9, 9,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr11	:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr14	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)	//Normal
Private oFontAr16	:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)	//Normal

Private oFontAr8n	:= TFont():New("Arial", 8, 8,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr9n	:= TFont():New("Arial", 9, 9,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr10n	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr11n	:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr12n	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr14n	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr16n	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr24n	:= TFont():New("Arial",24,24,,.T.,,,,.T.,.F.)	//Negrito
Private oFontAr48n	:= TFont():New("Arial",48,48,,.T.,,,,.T.,.F.)	//Negrito

oPrint:=TMSPrinter():New()	
oPrint:SetPortrait()					
oPrint:SetPaperSize(9)					
//_cNumOP := '021990' 
ApMsgAlert("Tecle OK para imprimir a ficha ")

//Processa( {|lEnd| FICHMED(@lEnd, cNum)}, "Aguarde...","Calculando Itens gerados na medideira.", .T. )
RptStatus({|lEnd| ImpFic(nRecno)},Titulo)

Return(.T.)


/*
----------------------------------------------------------------------
Funcao   : ImpGraf()
Descricao: Impressao da ficha de processo da medideira Semi-Acabado
----------------------------------------------------------------------*/
Static Function ImpFic(nRecno)

Private cLogo := '\system\lgrl0101.bmp'

ProcREgua( Reccount() )


Processa( {|lEnd| CalcMed(@lEnd, nRecno)}, "Aguarde...","Gerando relatorio...", .T. )

return

static function CalcMed(lEnd, nRecno)
Local cQuery := "" 


Local nLin    := 30	//60    
Local nColIni := 100
Local nColFim := 2350
Local nCount  := 0


ProcREgua( Reccount() )

//Verifica se tabelas temporias existem e encerra as mesmas antes de executar as novas
dbSelectArea("SZR")
//dbSetOrder(1)
//dbSeek(xFilial("SZR")+nRecno)
//Alert("CHAVE-->"+cValToChar(nRecno))
SZR->(dbGoto( nRecno ))
	oPrint:Line(nLin,nColIni,nlin,nColFim)
	oPrint:Line(nLin,nColIni,1500,nColIni)     		//vertical
	oPrint:Line(nLin+55,1450,nLin+55,1750)
	oPrint:Line(nLin,1450,nLin+130,1450)
	oPrint:Line(nLin,1750,nLin+130,1750)     		//vertical
	oPrint:Line(nLin,nColFim,1500,nColFim)     		//vertical
	oPrint:Line(1500,nColIni,1500,nColFim)	
	nLin += 10

   //	oPrint:Say(nLin,1610,"Codigo Barras:  ",oFontAr12n)
//	MSBAR("CODE128",  0.85 ,  16.8 ,SZR->ZR_NUMPLT ,oPrint,.F.,,.T.,0.022,0.8,.F.,NIL, "AAA", .F.)
	MSBAR("CODE128",  0.85 ,  16.0 ,SZR->ZR_NUMPLT ,oPrint,.F.,,.T.,0.022,0.8,.F.,NIL, "AAA", .F.)	

	oPrint:Say(nLin,1480,Alltrim('    NUMERO PALETE'),oFontAr10n)
	nLin += 20
	oPrint:SayBitmap(nLin,120,cLogo,150,90)
	oPrint:Say(nLin,300,"FICHA DE ESTOQUE DROPS",oFontAr16n)
    nLin += 40
	oPrint:Say(nLin,1500,Alltrim(SZR->ZR_NUMPLT), oFontAr10n)
	oPrint:Line(nLin,900,nLin+450,900)
	oPrint:Line(nLin,1450,nLin+450,1450)	
	nLin += 60
    oPrint:Line(nLin,nColIni,nLin,nColFim) 
    nLin += 5
    oPrint:Line(nLin,nColIni,nLin,nColFim)     
    nLin += 5
    oPrint:Line(nLin,nColIni,nLin,nColFim)             
//	oPrint:Line(nLin,1450,nLin+230,1450)
    nLin+= 150
//ZR_NUMSQ, ZR_NUMPLT, ZR_PRODUTO, ZR_QTDE, ZR_PESOKG, ZR_USUARIO, ZR_DTLANC, ZR_EMISSAO
    oPrint:Say(nLin+10,150, "PRODUCAO: "+ DTOC(SZR->ZR_EMISSAO), oFontAr16n)
    oPrint:Say(nLin+70,150, "LANCAMENTO: "+ DTOC(SZR->ZR_DTLANC), oFontAr16n)    
    oPrint:Say(nLin+10,950, "GRUPO: "+ POSICIONE("SB1",1, xFilial("SB")+SZR->ZR_PRODUTO, "B1_GRUPO"), oFontAr16n)	
    oPrint:Say(nLin+10,1500, "Nº PALETE: "+ SZR->ZR_NUMPLT, oFontAr16n)
    nLin += 80
    nLin += 150
    oPrint:Line(nLin,nColIni,nLin,nColFim)     
    oPrint:Say(nLin+50,150, "PRODUTO: "+Substr(SZR->ZR_PRODUTO,1,6)+" - "+ POSICIONE("SB1", 1, xFilial("SB")+SZR->ZR_PRODUTO, "B1_DESC"), oFontAr24n)
	nLin += 150
    oPrint:Say(nLin+200, 150, "QTDE PEÇA: "+cValToChar(SZR->ZR_QTDE), oFontAr16n)
    oPrint:Say(nLin+200, 850, "QTDE KG: "+cValToChar(SZR->ZR_PESOKG), oFontAr16n)    
//    oPrint:Say(nLin+50, 150, "Nº LOTE: "+ TMPD3->D3_PARTIDA, oFontAr16n)
    nLin+=130
    oPrint:Line(nLin,nColIni,nLin,nColFim)
    oPrint:Line(nLin, 750, nLin+405, 750)
    oPrint:Line(nLin,1400, nLin+670,1400)
    
	//Imprime as qtdes por classificacao caso o tipo de producao for exportacao
	
	nLin +=310
//	oPrint:Say(nLin,150, "                   COMPROVANTE MEDIDEIRA", oFontAr12n)
    nLin +=100
    oPrint:Say(nLin+10, 150,"RESPONSAVEL: "+SZR->ZR_USUARIO, oFontAr11)
    oPrint:Say(nLin+10,1600,"impresso em "+dtoc(date())+ " hora "+time(), oFontAr11) //StrZero(HoraToInt(Time()),6))
    oPrint:Line(nLin,nColIni,nLin,nColFim)    
   
oPrint:EndPage()
oPrint:Preview()  		// Visualizar todos antes de enviar para impressora

Return 


//Função para gerar a ordem de produção
/////////////////////////////////////////////////////////////////////////////
user function OPSZR(nRecNo)
//Perguntas para filtrar quais paletes serão gerados OPs
Private cPerg := PADR("AG_OPSZR",10)
if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	VldPerg(cPerg)
endif
Pergunte(cPerg,.T.)

if ApMsgNoYes("Confirma Filtro para Geração das OPs ? ", "Atenção para geração de OPs")
	Processa( {|lEnd| AG_GEROP(@lEnd)}, "Aguarde...","Executando geração de OPs...", .T. )
else
	Alert("Rotina abortada...")
endif
return

static function AG_GEROP()
local cOPs := ""

if Select("TMPZR") > 0
	dbSelectArea("TMPZR")
	TMPZR->(dbCloseArea())
endif 

BeginSql Alias "TMPZR"
	%NoParser%
	SELECT SZR.R_E_C_N_O_ nReg, ZR_NUMSQ, ZR_NUMPLT, ZR_PRODUTO, B1_DESC, B1_GRUPO, B1_UM, ZR_QTDE, ZR_PESOKG, ZR_USUARIO, ZR_DTLANC, ZR_EMISSAO, ZR_OPGERAD, ZR_NUMOP
	FROM %Table:SZR% SZR with (nolock), %Table:SB1% SB1 with (nolock)
	WHERE
	SZR.ZR_PRODUTO = SB1.B1_COD AND  
	SZR.ZR_FILIAL = %Exp:xFilial("SZR")% AND SB1.B1_FILIAL = %Exp:xFilial("SB1")% AND
	SB1.B1_COD   BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND 
	SZR.ZR_NUMPLT BETWEEN %Exp:mv_par03% AND %Exp:mv_par04% AND 
	SZR.ZR_EMISSAO BETWEEN %Exp:mv_par05% AND %Exp:mv_par06% AND 
	SZR.ZR_OPGERAD <> %Exp:"S"% AND 
	SZR.%NotDel% AND SB1.%NotDel% 
	ORDER BY ZR_PRODUTO, ZR_NUMPLT, ZR_EMISSAO
EndSql

dbSelectArea("TMPZR")
TMPZR->(dbGotop())
RecCount(0)
while !TMPZR->(eof())
	//cNumOP := GetSxeNum("SC2","C2_NUM")  
	cNumOP := GetNumSC2()  
	Processa( {|lEnd| AGINDOP(cNumOP, TMPZR->nReg, TMPZR->ZR_NUMPLT, TMPZR->ZR_PRODUTO, TMPZR->B1_DESC, TMPZR->B1_GRUPO, TMPZR->B1_UM, TMPZR->ZR_QTDE, TMPZR->ZR_PESOKG, TMPZR->ZR_EMISSAO, @lEnd)}, "Aguarde...", "Gerando ordem de produção "+cNumOP, .T.)
	TMPZR->(dbSkip())
	cOPs+= cNumOP+"; "
enddo
memowrite("C:\Temp\cOPs\OPS"+DTOS(DATE())+Substr(TIME(),1,2)+Substr(TIME(),4,2)+Substr(TIME(),7,2)+".txt", cOPs)
Alert("Ordens de Produção "+cOPs+" Gerado com sucesso...")
return 

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Fução para gerar a ordem de produção conforme filtro executado acima...
static function AGINDOP(cNumOP, nReg, cNUMPLT, cPROD, cDESCPROD, cGRUPO, cUM, nQTDE, nPESOKG, dEMISSAO)
//ZR_NUMSQ, ZR_NUMPLT, ZR_PRODUTO, ZR_QTDE, ZR_PESOKG, ZR_USUARIO, ZR_DTLANC, ZR_EMISSAO

	aCab := {}
	AAdd( aCab, {'C2_FILIAL'		,		 XFILIAL('SC2' ),nil 								})
	AAdd( aCab, {'C2_NUM'	   		,		 cNumOP,nil			 								})
	AAdd( aCab, {'C2_ITEM'			,		 '01' ,nil											})
	AAdd( aCab, {'C2_SEQUEN'		,	     '001',nil											})
	AAdd( aCab, {'C2_PRODUTO'		,		 cProd,nil							   				})
	AAdd( aCab, {'C2_QUANT'		    ,		 nQTDE,nil											})
	AAdd( aCab, {'C2_LOCAL'		    ,		 '03'	,nil										})
	AAdd( aCab, {'C2_CC'			,		 '320802',nil 										})
	AAdd( aCab, {'C2_DATPRI'	    ,		 dDataBase ,nil										})
	AAdd( aCab, {'C2_DATPRF'		,		 dDataBase + 10,nil									})
	AAdd( aCab, {'C2_OPMIDO'	    ,		 cNumPLT,nil		  								})
	AAdd( aCab, {'C2_EMISSAO'	    ,	     dDataBase,	nil										})
	AAdd( aCab, {'C2_CLIENTE' 		,		 '', nil											})
	AAdd( aCab, {'C2_LOJA'			,    	 '', nil											})
	AAdd( aCab, {'C2_RELEASE'		,		 '', nil											})
	AAdd( aCab, {'C2_DTRELE'		, 		 dDatabase, nil										})
	AAdd( aCab, {'C2_ITEMCTA'		,		 xFilial("SC2"), nil								})
	AAdd( aCab, {'C2_QTDLOTE'	    ,	     nQTDE,	nil											})
	AAdd( aCab, {'C2_X_KG' 			, 		 nPESOKG, nil										})
	AAdd( aCab, {'C2_X_DRWBK'		, 		 'N',nil											})
	AAdd( aCab, {'C2_OBS'           ,        'OP PALETE DROPS '+cNUMPLT,nil                     })    
	AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
	AAdd( aCab, {"AUTEXPLODE"       ,        'S',NIL 										    })
	
	incProc("Gerando plano -> OP.: "+cNumOP+" OP."+cNumPLT)
	
	lMsErroAuto := .f.
	msExecAuto({|X,Y| Mata650(x,Y)},aCab,3)
	If lMsErroAuto
		MostraErro()
	else   
		//ConfirmSX8()
		dbSelectArea("SZR")
		SZR->(dbGoto( nReg ))
		RecLock("SZR", .F.)
		SZR->ZR_OPGERAD := 'S'
		SZR->ZR_NUMOP   := cNumOP
		MsUnLock("SZR")
	Endif
return

///////////////////////////////////////////////////////////////////////////////////////////////////
//Relatorio de conferencia de digitação - lista 
//Desenvolvido por Anesio - 29/06/2015 - anesio@outlook.com
///////////////////////////////////////////////////////////////////////////////////////////////////
User Function ListaSZR()
Private cPerg := PADR("AG_LSTZR",10)
if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	ValidPerg(cPerg)
endif
Pergunte(cPerg,.T.)      

//Arquivo temporario da funcao para geracao do relatorio
//ZR_NUMSQ, ZR_NUMPLT, ZR_PRODUTO, ZR_QTDE, ZR_PESOKG, ZR_USUARIO, ZR_DTLANC, ZR_EMISSAO
aSZR	:= {}
AADD(aSZR,{"NUMPLT" 	    , "C", 08, 0 } )
AADD(aSZR,{"PRODUTO" 	    , "C", 15, 0 } )
AADD(aSZR,{"DESCRI" 	    , "C", 50, 0 } )
AADD(aSZR,{"UM"		 	    , "C", 02, 0 } )
AADD(aSZR,{"GRUPO" 	    	, "C", 04, 0 } )
AADD(aSZR,{"QTDE" 	 		, "N", 15, 2 } )
AADD(aSZR,{"PESO" 	   		, "N", 15, 3 } )
AADD(aSZR,{"DTEMISSAO"		, "D", 10, 0 } )
AADD(aSZR,{"DIGITACAO"		, "D", 10, 0 } )
AADD(aSZR,{"USUARIO" 	    , "C", 30, 0 } )
AADD(aSZR,{"ZR_OPGERAD"		, "C", 01, 0 } )
AADD(aSZR,{"ZR_NUMOP"		, "C", 10, 0 } )

ctrbSZR := CriaTrab(aSZR, .T.)
dbUseArea(.T.,,ctrbSZR,"SZRT",.F.,.F.)
INDEX ON PRODUTO + GRUPO + NUMPLT TO &ctrbSZR
//rotina para extraçao de dados 

//Mensagem solciitando ao usuario que aguarde a extraçao dos dados
CursorWait()
MsgRun( "Selecionando Movimentos de produção, Aguarde...",, { || MSZR01() } ) 
CursorArrow()

SZRT->(dbgotop())

If TRepInUse()
	//Gera as definicoes do relatorio
	oReport := ReportDef()
	//Monta interface com o usuário
	oReport:PrintDialog()
endif
//Retorno da funcao
SZRT->(dbCloseArea())
Ferase(ctrbSZR+".dbf")
Ferase(ctrbSZR+".cdx")

Return()

//-------------------------
Static Function ReportDef()
//-------------------------
//Variaveis locais da funcao
Local oReport 	:= ""
Local oBreak	:= ""
Local oSection1	:= ""
//Inicio da funcao
//Monta o objeto do relatorio
oReport := TReport():New(cPerg,"Kardex por Grupo de Produto",cPerg,{|oReport| Printreport(oReport)},;
				"Kardex por Grupo de Produto, solicitado pela Elisabeth da contabilidade. ")
//Cria a Seção do relatorio
oSection1 := TRSection():New(oReport,"Section ?????",{"SZRT"},/*Ordem*/)

//Cria as celulas do relatório 
TRCell():New(oSection1,"NUMPLT"		,"SZRT","Palete"   			,"@!"				,08,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"PRODUTO"	,"SZRT","Produto"   		,"@!"				,15,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"DESCRI"		,"SZRT","Descricao"   		,"@!"				,50,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"UM"			,"SZRT","U.Medida"     		,"@!"				,02,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"GRUPO"		,"SZRT","Grupo"   	   		,"@!"				,04,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"USUARIO"	,"SZRT","Usuario"  			,"@!"				,30,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"QTDE"		,"SZRT","Quantidade"   		,"@E 99,999,999"		,12,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"PESO"  		,"SZRT","Peso Palete"  		,"@E 999,999.99"		,12,/*lPixel*/,/*CodeBlock*/)                                                                                                                                                                                                                                             //"VALOR A PAGAR"
TRCell():New(oSection1,"DTEMISSAO"	,"SZRT","Emissao"  	  		,"@!"				,14,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"DIGITACAO"	,"SZRT","Digitacao"    		,"@!"				,14,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"ZR_OPGERAD"	,"SZRT","OP.Gerada?"  		,"@!"				,01,/*TAMPIXEL*/,/*BLOCO*/)
TRCell():New(oSection1,"ZR_NUMOP"	,"SZRT","Num.OP" 		 	,"@!"				,10,/*TAMPIXEL*/,/*BLOCO*/)


Return(oReport)

//-------------------------
Static Function PrintReport()
//-------------------------
Private oSection1 := oReport:Section(1)
oReport:FatLine()
oSection1:Print()
Return()


//-----------------------
Static Function MSZR01()
//-----------------------
BeginSql Alias "TMP"
	%NoParser%
	SELECT ZR_NUMSQ, ZR_NUMPLT, ZR_PRODUTO, B1_DESC, B1_GRUPO, B1_UM, ZR_QTDE, ZR_PESOKG, ZR_USUARIO, ZR_DTLANC, ZR_EMISSAO, ZR_OPGERAD, ZR_NUMOP
	FROM %Table:SZR% SZR with (nolock), %Table:SB1% SB1 with (nolock)
	WHERE 
	SZR.ZR_FILIAL = %Exp:xFilial("SZR")% AND SB1.B1_FILIAL = %Exp:xFilial("SB1")% AND ZR_PRODUTO = B1_COD AND
	SB1.B1_COD   BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND 
	SZR.ZR_EMISSAO BETWEEN %Exp:mv_par03% AND %Exp:mv_par04% AND 
	SZR.ZR_DTLANC BETWEEN %Exp:mv_par05% AND %Exp:mv_par06% AND 
	SZR.%NotDel% AND SB1.%NotDel% 
	ORDER BY ZR_PRODUTO, ZR_NUMPLT, ZR_EMISSAO
EndSql

do while TMP->(!eof())
		Reclock("SZRT",.T.)
		SZRT->NUMPLT	:= TMP->ZR_NUMPLT
		SZRT->PRODUTO	:= TMP->ZR_PRODUTO
		SZRT->DESCRI	:= TMP->B1_DESC
		SZRT->UM 		:= TMP->B1_UM
		SZRT->GRUPO		:= TMP->B1_GRUPO
		SZRT->QTDE		:= TMP->ZR_QTDE
		SZRT->PESO		:= TMP->ZR_PESOKG
		SZRT->DTEMISSAO	:= sToD(TMP->ZR_EMISSAO)
		SZRT->DIGITACAO	:= sToD(TMP->ZR_DTLANC)
		SZRT->USUARIO	:= TMP->ZR_USUARIO
		SZRT->ZR_OPGERAD:= TMP->ZR_OPGERAD
		SZRT->ZR_NUMOP	:= TMP->ZR_NUMOP
		Msunlock("SZRT")
	TMP->(dbSkip())
enddo 
TMP->(dbCloseArea())
Return




//--------------------------------
Static Function ValidPerg(cPerg)
//--------------------------------
//Variaveis locais
Local aRegs := {}
Local i,j
//Inicio da funcao
dbSelectArea("SX1")
dbSetOrder(1)
//   1          2        3         4          5           6       7       8             9        10      11     12       13        14        15         16       17       18       19        20          21        22      23        24       25         26        27       28       29       30          31        32       33       34        35          36        37     38     39       40       41        42
//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_PYME/X1_GRPSXG/X1_HELP/X1_PICTURE
AADD(aRegs,{cPerg,"01","De Produto" 		,"","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
AADD(aRegs,{cPerg,"02","Ate Produto" 		,"","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
AADD(aRegs,{cPerg,"03","De Data "  			,"","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Data " 			,"","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","De Digitação "		,"","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate Digitação " 	,"","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})



//Loop de armazenamento
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			endif
		Next
		MsUnlock()
	endif
Next
Return()



/////////////////////////////////////////////////////////////////////////////
//Funcao para rodar via schedule
//Desenvolvida por anesio em 30/06/2015 - anesio@outlook.com
user function AUTOPSZR()
local NumSeq := '000197'      
local cFil := "09"
Local cGerado := "N"

Memowrite("C:\TEMP\ANESIO.TXT", cNumOP)

cEmpAnt := '01'
RpcSetEnv(cEmpAnt, '09',,,,, { "SZR", "SB1", "SC2" } )


BeginSql Alias "TMP"
	%NoParser%
	SELECT ZR_NUMSQ, ZR_NUMPLT, ZR_PRODUTO, B1_DESC, B1_GRUPO, B1_UM, ZR_QTDE, ZR_PESOKG, ZR_USUARIO, ZR_DTLANC, ZR_EMISSAO, ZR_OPGERAD, ZR_NUMOP
	FROM %Table:SZR% SZR with (nolock), %Table:SB1% SB1 with (nolock)
	WHERE 
	SZR.ZR_FILIAL = %Exp:cFil% AND SB1.B1_FILIAL = %Exp:xFilial("SB1")% AND
	SB1.B1_COD   BETWEEN %Exp:mv_par01% AND %Exp:mv_par01% AND 
	SZR.ZR_EMISSAO BETWEEN %Exp:mv_par03% AND %Exp:mv_par04% AND 
	SZR.ZR_DTLANC BETWEEN %Exp:mv_par05% AND %Exp:mv_par06% AND 
	SZR.ZR_NUMSQ = %Exp:NumSeq% AND SZR.ZR_OPGERAD = %Exp:cGerado% AND
	SZR.%NotDel% AND SB1.%NotDel% 
	ORDER BY ZR_PRODUTO, ZR_NUMPLT, ZR_EMISSAO
EndSql


cNumOP := GetSxeNum("SC2","C2_NUM")

//Alert("Executando...")

//000197
//ZR_NUMSQ, ZR_NUMPLT, ZR_PRODUTO, ZR_QTDE, ZR_PESOKG, ZR_USUARIO, ZR_DTLANC, ZR_EMISSAO

	aCab := {}
	AAdd( aCab, {'C2_FILIAL'		,		 XFILIAL('SC2' ),nil 								})
	AAdd( aCab, {'C2_NUM'	   		,		 cNumOP,nil			 								})
	AAdd( aCab, {'C2_ITEM'			,		 '01' ,nil											})
	AAdd( aCab, {'C2_SEQUEN'		,	     '001',nil											})
	AAdd( aCab, {'C2_PRODUTO'		,		 TMP->ZR_PRODUTO,nil								})
	AAdd( aCab, {'C2_QUANT'		    ,		 TMP->ZR_PESOKG,nil								})
	AAdd( aCab, {'C2_LOCAL'		    ,		 '03'	,nil										})
	AAdd( aCab, {'C2_CC'			,		 '320802',nil 											})
	AAdd( aCab, {'C2_DATPRI'	    ,		 TMP->ZR_EMISSAO ,nil										})
	AAdd( aCab, {'C2_DATPRF'		,		 TMP->ZR_EMISSAO + 10,nil									})
	AAdd( aCab, {'C2_OPMIDO'	    ,		 TMP->ZR_NUMPLT,nil		  						})
	AAdd( aCab, {'C2_EMISSAO'	    ,	     TMP->ZR_EMISSAO,	nil										})
	AAdd( aCab, {'C2_CLIENTE' 		,		 '', nil										})
	AAdd( aCab, {'C2_LOJA'			,    	 '', nil										})
	AAdd( aCab, {'C2_RELEASE'		,		 '', nil										})
	AAdd( aCab, {'C2_DTRELE'		, 		 TMP->ZR_EMISSAO, nil										})
	AAdd( aCab, {'C2_ITEMCTA'		,		 xFilial("SC2"), nil								})
	AAdd( aCab, {'C2_QTDLOTE'	    ,	     TMP->ZR_PESOKG,	nil								})
	AAdd( aCab, {'C2_OBS'           ,        'OP DROPS '+TMP->ZR_NUMPLT,nil                            })
	AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
	AAdd( aCab, {"AUTEXPLODE"       ,        'S',NIL 										    })
	
//	incProc("Gerando plano -> "+SZR->ZR_NUMPLT)
	
	lMsErroAuto := .f.
	msExecAuto({|x,Y| Mata650(x,Y)},aCab,3)
	If lMsErroAuto
		MostraErro()
	else
		//ConfirmSx8() 
		dbSelectArea("SZR")
		dbSetOrder(2)
		dbSeek('09'+NumSeq)
		RecLock("SZR", .F.)
		SRZ->ZR_OPGERAD := 'S'
		SZR->ZR_NUMOP   := cNumOP
		MsUnLock("SZR")
//		Alert("Ordem de Proodução "+cNumOP+" Gerado com sucesso...")
		Memowrite("C:\TEMP\ANESIO.TXT", cNumOP)
	Endif
	
return

//--------------------------------
Static Function VldPerg(cPerg)
//--------------------------------
//Variaveis locais
Local aRegs := {}
Local i,j
//Inicio da funcao
dbSelectArea("SX1")
dbSetOrder(1)
//   1          2        3         4          5           6       7       8             9        10      11     12       13        14        15         16       17       18       19        20          21        22      23        24       25         26        27       28       29       30          31        32       33       34        35          36        37     38     39       40       41        42
//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_PYME/X1_GRPSXG/X1_HELP/X1_PICTURE
AADD(aRegs,{cPerg,"01","De Produto" 		,"","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
AADD(aRegs,{cPerg,"02","Ate Produto" 		,"","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
AADD(aRegs,{cPerg,"03","Do Palete "  		,"","","mv_ch3","C",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Palete " 		,"","","mv_ch4","C",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Emissao de "		,"","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Emissao até "   	,"","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})


//Loop de armazenamento
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			endif
		Next
		MsUnlock()
	endif
Next
Return()


