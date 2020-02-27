#include "RWMAKE.CH"
#include "PROTHEUS.CH"
#include "TOPCONN.CH" 

///////////////////////////////////////////////////////////////////////////////
//Relatorio de Ordens de producao incluida na Qualidade - PNP1
//Gera um relatorio com as OPs que foram incluidas na INSPEÇÃO DE QUALIDADE
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Antonio-23-03-2017
///////////////////////////////////////////////////////////////////////////////

User Function VSS_UFCHQA(cNumOp,cParIQ)

Local _cNumOP       := Substr(cNumOP,1,6)
Local cQuery        := ""          
Local wnrel
Local tamanho		:= "G"
Local titulo		:= "FICHA DE INSPEÇÃO DE QUALIDADE"
Local cDesc1		:= "FICHA DE INSPEÇÃO DE QUALIDADE"
Local cDesc2		:= ""
Local aSays     	:= {}, aButtons := {}, nOpca := 0

Private _aArea      := GetArea()
Private nomeprog 	:= "VSS_UFCHQA"
Private nLastKey 	:= 0
Private cPerg    	:= "GRFCORG"
Private oPrint
Private aDadosPec   := {} //Array com todas as peças da ficha
Private aDadosCmp   := {} //Array com todas os componentes da ficha

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

ApMsgAlert("Tecle OK para imprimir a ficha do processo...OP->" +_cNumOP)

RptStatus({|lEnd| ImpGraf(_cNumOP,cParIQ)},Titulo)

Return(.T.)


/*
----------------------------------------------------------------------
Funcao   : ImpGraf()
Descricao: Impressao da ficha de Inspeçãod e Qualidade
----------------------------------------------------------------------*/
Static Function ImpGraf(cNumOP,cParIQ)

Private cLogo := '\system\lgl010.bmp'

Processa({|| ImprGraf(cNumOP,cParIQ), 'Gerando Planilhas...'+cNumOP } )
	
/*
----------------------------------------------------------------------
Funcao   : RImpAutPag()
Descricao: Impressão da Autorizacao de Pagamento             
----------------------------------------------------------------------*/
Static Function IMprGraf(cNumOP,cParIQ)

ProcREgua( Reccount() )
Processa( {|lEnd| CalcMed(@lEnd, cNumOP, cParIQ)}, "Aguarde...","Calculando processo da inspeção de qualidade..."+cNumOP, .T. )

Return()


Static function CalcMed(lEnd, cNumOP, cParIQ)

Local cQuery  := "" 
Local nLin    := 30	//60    
Local nColIni := 100
Local nColFim := 2350
Local nCount  := 0

Default cParIQ := ' '

ProcREgua( Reccount() )

//Verifica se tabelas temporias existem e encerra as mesmas antes de executar as novas
If Select("TMPD3") > 0 
	dbSelectArea("TMPD3")
	TMPD3->(dbCloseArea())
EndIf

//alert('cNumOP-> '+cNumOP)

cQuery := " Select C2_NUM, C2_EMISSAO, C2_PRODUTO, B1_DESC, B1_UM, B1_GRUPO, "
cQuery += " C2_QUANT, C2_OBS, D3_PARTIDA, D3_LOTECTL, D3_USUARIO, D3_X_FORN, C2_LOCAL "
cQuery += " from SD3010 SD3, SC2010 SC2, SB1010 SB1 "
cQuery += " where SB1.D_E_L_E_T_ = ' ' and SC2.D_E_L_E_T_ = ' ' and SD3.D_E_L_E_T_ = ' ' "
cQuery += " and D3_FILIAL = C2_FILIAL " 
cQuery += " and C2_PRODUTO = B1_COD "
cQuery += " and C2_FILIAL = '"+xFilial("SC2")+"' "
cQuery += " and D3_FILIAL = '"+xFilial("SD3")+"' "
cQuery += " and Substring(D3_OP,1,6) = C2_NUM "
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
	MSBAR("CODE128",  0.40 ,  15.8 ,TMPD3->C2_NUM ,oPrint,.F.,,.T.,0.022,0.8,.F.,NIL, "AAA", .F.)
//	MSBAR("INT25",8.9,9.4,"15189901874501057330600115151375310",oPrint,.F.,,.T.,0.025,1.3,NIL,NIL,NIL,.F.)	
	oPrint:Say(nLin,1480,Alltrim('    OP.NUMERO'),oFontAr10n)
//	nLin += 50
//    oPrint:Line(nLin,nColIni,nLin,nColFim)     //Horizontal
	nLin += 20
	oPrint:SayBitmap(nLin,120,cLogo,150,90)
	oPrint:Say(nLin,250,"PROCESSO: INSPEÇÃO DE QUALIDADE",oFontAr16n)
    nLin += 40
	oPrint:Say(nLin,1500,Alltrim(TMPD3->C2_NUM), oFontAr10n)
	oPrint:Line(nLin+60,900,nLin+450,900)                  //vertical do grupo
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
//    oPrint:Say(nLin+50, 150, "Nº LOTE: "+ TMPD3->D3_LOTECTL, oFontAr16n)
    nLin+=130
    oPrint:Line(nLin,nColIni,nLin,nColFim)
    oPrint:Line(nLin, 1250, nLin+670, 1250)
//    oPrint:Line(nLin,1400, nLin+670,1400)
    
	//Imprime as qtdes por classificacao caso o tipo de producao for exportacao

    nLin += 130
	If cParIQ =='S' .OR. TMPD3->C2_LOCAL == '04'
	    oPrint:Say(nLin+50,150, "QTDE APROVADA", oFontAr16n)
	ElseIf cParIQ =='N' .OR. TMPD3->C2_LOCAL == 'QS'
    	oPrint:Say(nLin+50,1300, "QTDE NÃO APROVADA", oFontAr16n)
	EndIf
//    oPrint:Say(nLin+50,1450,"MEDIA M2/VQ", oFontAr16n)

    nLin += 100
	If cParIQ=='S' .OR. TMPD3->C2_LOCAL == '04'
	    oPrint:Say(nLin+120,150, Alltrim(Transform(TMPD3->C2_QUANT,"@E 9,999.99")), oFontAr16n)
	ElseIf cParIQ=='N' .OR. TMPD3->C2_LOCAL == 'QS'
    	oPrint:Say(nLin+120,1300, Alltrim(Transform(TMPD3->C2_QUANT,"@E 9,999.99")), oFontAr16n)
	EndIf

//    oPrint:Say(nLin+120,1450, Alltrim(Transform(TMPD3->D3_QTDEM2/TMPD3->C2_QUANT,"@E 999.99")), oFontAr16n)        
    nLin += 600                                        
 
	//impressao do fornecedor
	oPrint:Line(nLin,nColIni,nLin,1350)
	oPrint:Line(nLin+300,nColIni,nLin+300,1350)
	oPrint:Line(nLin,nColIni,nLin+300,nColIni)
	oPrint:Line(nLin,1350,nLin+300,1350)
	oPrint:Say(nLin+150,200, "Fornecedor: "+TMPD3->D3_X_FORN, oFontAr12n)
	
	nLin +=310
	//	oPrint:Say(nLin,150, "                   COMPROVANTE QUALIDADE", oFontAr12n)
    nLin +=100
    oPrint:Say(nLin+10, 150,"Codigo usuário: "+RetCodUsr()+ " NOME: "+Substr(cUsuario,1,20), oFontAr11)
    oPrint:Say(nLin+10,1600,"impresso em "+dtoc(date())+ " hora "+time(), oFontAr11) //StrZero(HoraToInt(Time()),6))
    oPrint:Line(nLin,nColIni,nLin,nColFim)    
   
	oPrint:EndPage()
	oPrint:Preview()  		// Visualizar todos antes de enviar para impressora

Return  
