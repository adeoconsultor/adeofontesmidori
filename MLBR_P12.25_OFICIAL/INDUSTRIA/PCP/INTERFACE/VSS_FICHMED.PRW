#include "RWMAKE.CH"
#include "PROTHEUS.CH"
#include "TOPCONN.CH" 

///////////////////////////////////////////////////////////////////////////////
//Relatorio de Ordens de producao incluida na Medideira - PNP1
//Gera um relatorio com as OPs que foram incluidas na medideira 
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br -05-03-2012
//Chamado HDi 004319 aberto por Thiago Amorim
///////////////////////////////////////////////////////////////////////////////
//Manutencao por Vinicius de Souza Schwartz - TI, Midori Atlantica em 29-03-2012
//Para atender solicitacao de Fabio/Thiago no Semi-Acabado
///////////////////////////////////////////////////////////////////////////////
//Manutencao feita em 26/10/2012 por Vinicius Schwartz
//O objetivo foi atender a necessidade exposta por Thiago,
//onde sera apresentado a quantidade de VQ e M2 por classificacao quando o mesmo
//for para exportacao.
///////////////////////////////////////////////////////////////////////////////

User Function VSS_FICHMED(cNumOp)

Local _cNumOP := Substr(cNumOP,1,6)
Local cQuery := ""          

Local wnrel
Local tamanho		:= "G"
Local titulo		:= "FICHA DE PROCESSO SEMI-ACABADO"
Local cDesc1		:= "FICHA DE CORTE"
Local cDesc2		:= ""
Local aSays     	:= {}, aButtons := {}, nOpca := 0

Private _aArea      := GetArea()
Private nomeprog 	:= "MD_GRFCORG"
Private nLastKey 	:= 0
Private cPerg    	:= "GRFCORG"
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
ApMsgAlert("Tecle OK para imprimir a ficha do processo...OP->" +_cNumOP)

//Processa( {|lEnd| FICHMED(@lEnd, cNum)}, "Aguarde...","Calculando Itens gerados na medideira.", .T. )
RptStatus({|lEnd| ImpGraf(_cNumOP)},Titulo)

Return(.T.)


/*
----------------------------------------------------------------------
Funcao   : ImpGraf()
Descricao: Impressao da ficha de processo da medideira Semi-Acabado
----------------------------------------------------------------------*/
Static Function ImpGraf(cNumOP)

Private cLogo := '\system\lgl010.bmp'

Processa({|| ImprGraf(cNumOP), 'Gerando Planilhas...'+cNumOP } )
	
/*
----------------------------------------------------------------------
Funcao   : RImpAutPag()
Descricao: Impressão da Autorizacao de Pagamento             
----------------------------------------------------------------------*/
Static Function IMprGraf(cNumOP)
ProcREgua( Reccount() )


Processa( {|lEnd| CalcMed(@lEnd, cNumOP)}, "Aguarde...","Calculando processo da medideira..."+cNumOP, .T. )

return

static function CalcMed(lEnd, cNumOP)
Local cQuery := "" 


Local nLin    := 30	//60    
Local nColIni := 100
Local nColFim := 2350
Local nCount  := 0


ProcREgua( Reccount() )

//Verifica se tabelas temporias existem e encerra as mesmas antes de executar as novas
if Select("TMPD3") > 0 
	dbSelectArea("TMPD3")
	TMPD3->(dbCloseArea())
endif

//alert('cNumOP-> '+cNumOP)

cQuery := " Select C2_NUM, C2_EMISSAO, C2_PRODUTO, B1_DESC, B1_UM, B1_GRUPO, "
cQuery += " C2_QUANT, B1_GRUPO, C2_OBS, D3_PARTIDA, D3_LOTECTL, D3_QTDEM2, D3_MEDIAM2, D3_USUARIO, D3_X_FORN, D3_X_NPLT, D3_X_TPROD, D3_X_VC, D3_X_VD, D3_X_VE, D3_X_VER, D3_X_MC, D3_X_MD, D3_X_ME, D3_X_MER "
cQuery += " from SD3010 SD3, SC2010 SC2, SB1010 SB1 "
cQuery += " where SB1.D_E_L_E_T_ = ' ' and SC2.D_E_L_E_T_ = ' ' and SD3.D_E_L_E_T_ = ' ' "
cQuery += " and D3_FILIAL = C2_FILIAL " 
cQuery += " and C2_PRODUTO = B1_COD "
cQuery += " and C2_FILIAL = '"+xFilial("SC2")+"' "
cQuery += " and D3_FILIAL = '"+xFilial("SD3")+"' "
cQuery += " and Substring(D3_OP,1,6) = C2_NUM "
//cQuery += " and Substring(C2_OBS,1,10)= 'ROTINA AUT' "
cQuery += " and D3_COD = B1_COD "
cQuery += " and C2_NUM = '"+cNumOp+"' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN", tcGenQry(,,cQuery),"TMPD3",.F.,.T.)

TcSetField("TMPD3", "C2_EMISSAO", "D")


dbGotop()
	oPrint:Line(nLin,nColIni,nlin,nColFim)
	oPrint:Line(nLin,nColIni,1500,nColIni)     		//vertical
	oPrint:Line(nLin+55,1450,nLin+55,1750)
	oPrint:Line(nLin,1450,nLin+130,1450)
	oPrint:Line(nLin,1750,nLin+130,1750)     		//vertical
	oPrint:Line(nLin,nColFim,1500,nColFim)     		//vertical
	oPrint:Line(1500,nColIni,1500,nColFim)	
	nLin += 10

   //	oPrint:Say(nLin,1610,"Codigo Barras:  ",oFontAr12n)
	MSBAR("CODE128",  0.85 ,  16.8 ,TMPD3->C2_NUM ,oPrint,.F.,,.T.,0.022,0.8,.F.,NIL, "AAA", .F.)
//	MSBAR("INT25",8.9,9.4,"15189901874501057330600115151375310",oPrint,.F.,,.T.,0.025,1.3,NIL,NIL,NIL,.F.)	
	oPrint:Say(nLin,1480,Alltrim('    OP.NUMERO'),oFontAr10n)
//	nLin += 50
//    oPrint:Line(nLin,nColIni,nLin,nColFim)     //Horizontal
	nLin += 20
	oPrint:SayBitmap(nLin,120,cLogo,150,90)
	oPrint:Say(nLin,300,"PROCESSO: MEDIDEIRA SEMI-ACABADO",oFontAr16n)
    nLin += 40
	oPrint:Say(nLin,1500,Alltrim(TMPD3->C2_NUM), oFontAr10n)
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
    oPrint:Say(nLin+10,150, "DATA: "+ DTOC(TMPD3->C2_EMISSAO), oFontAr16n)
    oPrint:Say(nLin+10,950, "GRUPO: "+ TMPD3->B1_GRUPO, oFontAr16n)	
    oPrint:Say(nLin+10,1500, "Nº PARTIDA: "+ TMPD3->D3_PARTIDA, oFontAr16n)
    nLin += 80
    nLin += 150
    oPrint:Line(nLin,nColIni,nLin,nColFim)     
    oPrint:Say(nLin+50,150, "PRODUTO: "+Substr(TMPD3->C2_PRODUTO,1,6)+" - "+TMPD3->B1_DESC, oFontAr16n)
	nLin += 150
//    oPrint:Say(nLin+50, 150, "CAVALETE/MESA N²: "+Substr(TMPD3->C2_OBS,26,3), oFontAr16n)
    oPrint:Say(nLin+50, 150, "Nº LOTE: "+ TMPD3->D3_LOTECTL, oFontAr16n)
    nLin+=130
    oPrint:Line(nLin,nColIni,nLin,nColFim)
    oPrint:Line(nLin, 750, nLin+670, 750)
    oPrint:Line(nLin,1400, nLin+670,1400)
    
	//Imprime as qtdes por classificacao caso o tipo de producao for exportacao
	If TMPD3->D3_X_TPROD == 'E'
		nLin += 80
	    oPrint:Say(nLin+50,150, "QTDE VQ", oFontAr16n)
	    oPrint:Say(nLin+50,800, "QTDE M2", oFontAr16n)
	    oPrint:Say(nLin+50,1450,"MEDIA M2/VQ", oFontAr16n)
   	    nLin += 150
	    oPrint:Say(nLin,    150, "C: "+Alltrim(Transform(TMPD3->D3_X_VC  ,"@E 9,999")), oFontAr16n)
	    oPrint:Say(nLin+50 ,150, "D: "+Alltrim(Transform(TMPD3->D3_X_VD  ,"@E 9,999")), oFontAr16n)
	    oPrint:Say(nLin+100,150, "E: "+Alltrim(Transform(TMPD3->D3_X_VE  ,"@E 9,999")), oFontAr16n)
 	    oPrint:Say(nLin+150,150, "ER: "+Alltrim(Transform(TMPD3->D3_X_VER,"@E 9,999")), oFontAr16n)	  
 	    oPrint:Say(nLin+250,150, "TOTAL: "+Alltrim(Transform((TMPD3->D3_X_VC+TMPD3->D3_X_VD+TMPD3->D3_X_VE+TMPD3->D3_X_VER),"@E 9,999")), oFontAr16n)
	    
	    oPrint:Say(nLin,    800, "C: "+Alltrim(Transform(TMPD3->D3_X_MC  ,"@E 9,999.99")), oFontAr16n)
	    oPrint:Say(nLin+50 ,800, "D: "+Alltrim(Transform(TMPD3->D3_X_MD  ,"@E 9,999.99")), oFontAr16n)
	    oPrint:Say(nLin+100,800, "E: "+Alltrim(Transform(TMPD3->D3_X_ME  ,"@E 9,999.99")), oFontAr16n)
 	    oPrint:Say(nLin+150,800, "ER: "+Alltrim(Transform(TMPD3->D3_X_MER,"@E 9,999.99")), oFontAr16n)	  
 	    oPrint:Say(nLin+250,800, "TOTAL: "+Alltrim(Transform((TMPD3->D3_X_MC+TMPD3->D3_X_MD+TMPD3->D3_X_ME+TMPD3->D3_X_MER),"@E 9,999.99")), oFontAr16n)

	    oPrint:Say(nLin+120,1450, Alltrim(Transform(TMPD3->D3_QTDEM2/TMPD3->C2_QUANT,"@E 999.99")), oFontAr16n)        
	    nLin += 600                                        
	Else
	    nLin += 130
	    oPrint:Say(nLin+50,150, "QTDE VQ", oFontAr16n)
	    oPrint:Say(nLin+50,800, "QTDE M2", oFontAr16n)
	    oPrint:Say(nLin+50,1450,"MEDIA M2/VQ", oFontAr16n)
	    nLin += 100
	    oPrint:Say(nLin+120,150, Alltrim(Transform(TMPD3->C2_QUANT,"@E 9,999")), oFontAr16n)
	    oPrint:Say(nLin+120,800, Alltrim(Transform(TMPD3->D3_QTDEM2,"@E 9,999.99")), oFontAr16n)
	    oPrint:Say(nLin+120,1450, Alltrim(Transform(TMPD3->D3_QTDEM2/TMPD3->C2_QUANT,"@E 999.99")), oFontAr16n)        
	    nLin += 600                                        
	Endif	
 
	//impressao do fornecedor
	oPrint:Line(nLin,nColIni,nLin,1350)
	oPrint:Line(nLin+300,nColIni,nLin+300,1350)
	oPrint:Line(nLin,nColIni,nLin+300,nColIni)
	oPrint:Line(nLin,1350,nLin+300,1350)
	oPrint:Say(nLin+150,200, "Fornecedor: "+TMPD3->D3_X_FORN, oFontAr12n)
	
	//Imprimir somente caso o tipo de producao for exportacao
	If TMPD3->D3_X_TPROD == 'E'
		oPrint:Line(nLin,nColIni+1350,nLin,nColFim)
		oPrint:Line(nLin+300,nColIni+1350,nLin+300,nColFim)
		oPrint:Line(nLin,nColIni+1350,nLin+300,nColIni+1350)
		oPrint:Line(nLin,nColFim,nLin+300,nColFim)
		oPrint:Say(nLin+150,1500, "Nº PALLET: "+TMPD3->D3_X_NPLT, oFontAr12n)
	Endif
	
	nLin +=310
//	oPrint:Say(nLin,150, "                   COMPROVANTE MEDIDEIRA", oFontAr12n)
    nLin +=100
    oPrint:Say(nLin+10, 150,"Codigo usuário: "+RetCodUsr()+ " NOME: "+Substr(cUsuario,1,20), oFontAr11)
    oPrint:Say(nLin+10,1600,"impresso em "+dtoc(date())+ " hora "+time(), oFontAr11) //StrZero(HoraToInt(Time()),6))
    oPrint:Line(nLin,nColIni,nLin,nColFim)    
   
oPrint:EndPage()
oPrint:Preview()  		// Visualizar todos antes de enviar para impressora

Return 