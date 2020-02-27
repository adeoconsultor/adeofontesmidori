#include "RWMAKE.CH"
#include "PROTHEUS.CH"
#include "TOPCONN.CH" 
/*                               
/////////////////////////////////////////////////////////////////////////////////////////////////
//PROGRAMA: MD_GRFCORG
//Função para imprimir as fichas de Corte em Modo Gráfico conforme modelo utilizado no México
//Especifico PNP2

//Desenvolvido por Anesio G.Faria - Taggs Consultoria - 07-09-2011
*/

User Function MD1_GRFCORG(cNumOP)	
Local wnrel
Local tamanho		:= "G"
Local titulo		:= "FICHA DE PROCESSO"
Local cDesc1		:= "FICHA DE CORE"
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

ApMsgAlert("Tecle OK para imprimir as fichas em modo grafico...")


RptStatus({|lEnd| ImpGraf(cNumOP)},Titulo)

Return(.T.)
/*
----------------------------------------------------------------------
Funcao   : ImpGraf()
Descricao: Impressao da ficha de corte modelo grafico
----------------------------------------------------------------------*/
Static Function ImpGraf(cOP)
Local cFicha   := SZ3->Z3_NUMFC
Local nMult    := SC2->C2_QTDLOTE // Multiplos
Local nMtPad   := 0 // Metragem padrao
Local cCliente := SC2->C2_CLIENTE
Local cLojaCli := SC2->C2_LOJA
Local cLoja    := SC2->C2_LOJA

//Private cLogo   := "\system\lgrl01.bmp"
Private cLogo := '\system\lgl010.bmp'
Private cQuery  := ""     
Private cQSG1   := ""

Processa({|| ImprGraf(cOP, cPlano), 'Gerando Planilhas...' } )
	
/*
----------------------------------------------------------------------
Funcao   : RImpAutPag()
Descricao: Impressão da Autorizacao de Pagamento             
----------------------------------------------------------------------*/
Static Function IMprGraf(cOP, cPlano)
Local nLin    := 30	//60    
Local nColIni := 100
Local nColFim := 2350
Local nCount   := 0
Local aPeca    := {}
Local aPc      := {}
Local aComp    := {}
Local i1, icomp, i
Private nQtMultPVC := Getmv( 'MV_QTMUPVC' )
//Local cDtEmis := GravaData(aParcelas[1,18],.f.,5)
//Local cDtProc := GravaData(dDataBase,.f.,5)
//Local cUnidade := ""
//cDtProc := Substr(cDtProc ,1,2)+"/"+Substr(cDtProc ,3,2)+"/"+Substr(cDtProc ,5,4)
ProcREgua( Reccount() )

cQuery := " Select Z3_FILIAL, Z3_PLANO, Z3_NUMOP, Z3_NUMFC, Z3_MATERIA, Sum(Z3_M2PAD) Z3_M2PAD, Sum(Z3_M2TOT) Z3_M2TOT, AVG(Z3_QTDE) Z3_QTDE from "  
cQuery += RetSqlName("SZ3")+" SZ3 "
cQuery += " WHERE " 
cQuery += " SZ3.Z3_PLANO = '" + Padr(cPlano,20) + "' AND "   
cQuery += " SZ3.Z3_NUMOP  = '" + Padr(cOP,11)  + "' AND " 
cQuery += " SZ3.D_E_L_E_T_ = ' ' and Z3_FILIAL = '"+  xFilial("SZ3")+"'"
//cQuery += " AND Z3_NUMFC = 'A108052001468001' " 
cQuery += " Group by Z3_FILIAL, Z3_PLANO, Z3_NUMOP, Z3_NUMFC, Z3_MATERIA "
cQuery += " Order by Z3_NUMFC "
cQuery := ChangeQuery(cQuery)          

If Select("TMPZ3") > 0
	DbSelectArea("TMPZ3")
	DbCloseArea("TMPZ3")
EndIf

                                         
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPZ3",.F.,.T.)
dbSelectArea("TMPZ3") 
dbGotop()
cFicha :=""
while !TMPZ3->(eof())
	cFicha:= cFicha+"'"+TMPZ3->Z3_NUMFC+"',"
	nCount++           
	incProc('Contando Fichas....'+cValToChar(nCount))
	TMPZ3->(dbSkip())
enddo
nFolhas := nCount
                     
cQSG1   := " Select G1_COMP from SG1010 where D_E_L_E_T_ = ' ' and G1_FILIAL = '"+xFilial("SG1")+"' and G1_COD = '" + SC2->C2_PRODUTO+ "' "

if Select("TMPCP") > 0
	dbSelectArea("TMPCP")
	DbCloseArea("TMPCP")
endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQSG1),"TMPCP",.F.,.T.)
dbSelectArea("TMPCP")
cComp :=""
while !TMPCP->(eof())
	cComp:= cComp+"'"+TMPCP->G1_COMP+"',"
	Aadd(aComp, {TMPCP->G1_COMP})
	TMPCP->(dbSkip())
enddo                                 
cFicha := Substr(cFicha,1,len(cFicha)-1)
//alert("FICHA|"+cFicha+"|")
cComp := Substr(cComp,1,len(cComp)-1)
//alert("COMPONENTE: "+cComp)
cQPECA := " Select G1_COD, G1_COMP, Z3_NUMFC, Sum(Z3_QTDE) Z3_QTDE, AVG(Z3_M2PAD) Z3_M2PAD, Sum(Z3_M2TOT) Z3_M2TOT  from SG1010  SG1, SZ3010 SZ3 " 
cQPECA += " where SG1.D_E_L_E_T_ = ' ' and SZ3.D_E_L_E_T_ = ' ' and Z3_FILIAL = '"+xFilial("SG1")+"' "      
cQPECA += " and Z3_NUMFC in ("+cFicha+") "
//cQPECA += " and Z3_NUMFC = 'A108052001468001' " 
cQPECA += " and G1_COMP = Z3_PRODUTO and G1_FILIAL = '"+xFilial("SG1")+"' and G1_COD in ("+cComp+") group by G1_COD, G1_COMP, Z3_NUMFC order by Z3_NUMFC, G1_COMP, G1_COD "

if Select("TMPPC") > 0 
	dbSelectArea("TMPPC")
	DbCloseArea("TMPPC")
endif
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQPECA),"TMPPC",.F.,.T.)
cComp:= cPeca := ""
nComp:= 0
dbSelectArea("TMPPC")            
while !TMPPC->(eof())
	if cComp <> TMPPC->G1_COMP //.or. (cPeca <> TMPPC->G1_COD .and. nComp == 2)
		cComp := TMPPC->G1_COMP
		cPeca := TMPPC->G1_COD
		nComp := 1
	endif
	Aadd(aPeca, {TMPPC->G1_COD, TMPPC->G1_COMP, TMPPC->Z3_NUMFC, TMPPC->Z3_M2PAD, TMPPC->Z3_M2TOT, TMPPC->Z3_QTDE, nComp})
	Aadd(aPc,   {TMPPC->G1_COD+TMPPC->Z3_NUMFC, TMPPC->G1_COMP, TMPPC->Z3_NUMFC, TMPPC->Z3_M2PAD, TMPPC->Z3_M2TOT, TMPPC->Z3_QTDE})
	TMPPC->(dbSKip())
	nComp++
enddo

aSort(aPeca,,,{|x,y| x[3]+x[1]+x[2] < y[3]+y[1]+y[2]})
//aSort(aSZN,,,{|x,y| x[7]+x[14]+StrZero(x[2],5) + StrZero(x[6],5) + StrZero(x[5],5) > y[7]+y[14]+StrZero(y[2],5) + StrZero(y[6],5) + StrZero(x[5],5) })

//for ipc:=1 to len(aPeca)
//
//next ipc


nFolha := 1

dbSelectArea('TMPZ3')
dbGotop()
while !TMPZ3->(eof())
	oPrint:Line(nLin,nColIni,nlin,nColFim)
	oPrint:Line(nLin,nColIni,456,nColIni)     		//vertical
	oPrint:Line(nLin+55,1200,nLin+55,1550)
	oPrint:Line(nLin,1550,nLin+130,1550)     		//vertical
	oPrint:Line(nLin,1200,nLin+130,1200)
	oPrint:Line(nLin,nColFim,456,nColFim)     		//vertical
	nLin += 10

   //	oPrint:Say(nLin,1610,"Codigo Barras:  ",oFontAr12n)
	MSBAR("CODE128",  0.85 ,  13.8 ,TMPZ3->Z3_NUMFC ,oPrint,.F.,,.T.,0.022,0.8,.F.,NIL, "AAA", .F.)
//	MSBAR("INT25",8.9,9.4,"15189901874501057330600115151375310",oPrint,.F.,,.T.,0.025,1.3,NIL,NIL,NIL,.F.)	
	oPrint:Say(nLin,1280,Alltrim('        PLANO'),oFontAr10n)
//	nLin += 50
   //	oPrint:Line(nLin,nColIni,nLin,nColFim)     //Horizontal
	nLin += 20
	oPrint:SayBitmap(nLin,120,cLogo,150,90)
	oPrint:Say(nLin,300,"FICHA DE PROCESSO: ",oFontAr16n)
    nLin += 40
	oPrint:Say(nLin,1250,Alltrim(SC2->C2_OPMIDO), oFontAr10n)
	nLin += 60
    oPrint:Line(nLin,nColIni,nLin,nColFim) 
	oPrint:Line(nLin,400,nLin+50,400)
	oPrint:Line(nLin,900,nLin+50,900)    
	oPrint:Line(nLin,1550,nLin+50,1550)
	
	oPrint:Say(nLin,200,"LADO", oFontAr10n)
	oPrint:Say(nLin,600,"CLIENTE ", oFontAr10n)
	oPrint:Say(nLin,1200,"MODELO", oFontAr10n)
	oPrint:Say(nLin,1800,"TIPO DE MATERIAL", oFontAr10n)     

	nLin += 50

//Montar a linha onde estara ------- LADO - CLIENTE - MODELO - TIPO DE MATERIAL
    oPrint:Line(nLin,nColIni,nLin,nColFim) 
	oPrint:Line(nLin,400,nLin+250,400)
	oPrint:Line(nLin,900,nLin+250,900)    
	oPrint:Line(nLin,1550,nLin+250,1550)
	oPrint:Line(nLin+180,400,nLin+180,900)
	oPrint:Line(nLin+90,1550,nLin+90,nColFim)
	oPrint:Line(nLin+170,1550,nLin+170, nColFim)
//	oPrint:Line(nLin+90,400,nLin+90,900)
	oPrint:Line(nLin+90,1800, nLin+250,1800)
	
	if SC2->C2_LADO == 'S'
		oPrint:Say(nLin+50,200,Substr(TMPZ3->Z3_NUMFC,1,1),oFontAr48n)
	else
		oPrint:Say(nLin+50,220," ",oFontAr48n)
	endif             
	cCliente := Substr(Posicione('SA1',1,xFilial('SA1')+SC2->(C2_CLIENTE+C2_LOJA),"A1_NOME"),1,20)
	oPrint:Say(nLin+20,410,cCliente,oFontAr11)
	oPrint:Say(nLin+100,410,Substr(Posicione('SA1',1,xFilial('SA1')+SC2->(C2_CLIENTE+C2_LOJA),"A1_NOME"),21,20),oFontAr11)
	oPrint:Say(nLin+200,500,SC2->C2_CLIENTE+' - '+SC2->C2_LOJA,oFontAr12n)                                 
	cDescPrd := Substr(Posicione('SB1',1,xFilial('SB1')+SC2->C2_PRODUTO,"B1_DESC"),1,18)
	oPrint:Say(nLin+20,920,cDescPrd,oFontAr16n)
	oPrint:Say(nLin+100,920, Substr(Posicione('SB1',1,xFilial('SB1')+SC2->C2_PRODUTO,"B1_DESC"),19,18),oFontAr16n)
	oPrint:Say(nLin+10, 1610, Substr(Posicione('SB1',1,xFilial('SB1')+TMPZ3->Z3_MATERIA,"B1_DESC"),1,27),oFontAr11)
	oPrint:Say(nLin+50, 1610, Substr(Posicione('SB1',1,xFilial('SB1')+TMPZ3->Z3_MATERIA,"B1_DESC"),27,27),oFontAr11)
	oPrint:Say(nLin+120, 1620, "COR",oFontAr12n)
	oPrint:Say(nLin+200, 1620, "CODIGO",oFontAr12n)
	oPrint:Say(nLin+200, 1900, TMPZ3->Z3_MATERIA)
    nLin += 250                          
    oPrint:Line(nLin,nColIni,nLin,nColFim) //,nLin,900,nLin,1680)

//Montar a linha onde estara ------- KITS  - LOTES - FICHA 
	nLin += 40
    oPrint:Line(nLin,nColIni,nLin,nColFim)                    
   	oPrint:Line(498,nColFim,750,nColFim)     		//vertical
   	oPrint:Line(498,nColIni,750,nColIni)     		//vertical   	
   	oPrint:Line(498,400,750,400)
   	oPrint:Line(498,900,750,900)
   	oPrint:Line(498,1200,628,1200)
   	oPrint:Line(498,1550,628,1550)
   	oPrint:Line(628,1300,750,1300)
   	oPrint:LIne(498,1800,750,1800)
	oPrint:Say(nLin+20,200,"KITS", oFontAr12n)
	oPrint:Say(nLin+20,930,"LOTE:",oFontAr12n)
	oPrint:Say(nLin+20,1635,"FICHA",oFontAr12n)
	oPrint:Say(nLin+20,1820,TMPZ3->Z3_NUMFC, oFontAr11)
    nLin += 65
    oPrint:Line(nLin,nColIni,nLin,nColFim) 
    oPrint:Say(nLin+20,135,"MULTIPLO:",oFontAr12n)
    if Posicione('SB1',1,xFilial('SB1')+TMPZ3->Z3_MATERIA,"B1_GRUPO")=='40  ' 
	    oPrint:Say(nLin+20,550, Alltrim(Transform(SC2->C2_QTDLOTE,"@E 999,999")), oFontAr11)
	else
	    oPrint:Say(nLin+20,550, Alltrim(Transform(nQtMultPVC,"@E 999,999")), oFontAr11)		
	endif
    oPrint:Say(nLin+20,950, "OP:                           "+TMPZ3->Z3_NUMOP, oFontAr11)
    oPrint:Say(nLin+20,1635, "DATA", oFontAr12n)
    oPrint:Say(nLin+20, 1850, dToc(SC2->C2_EMISSAO),oFontAr11)
    nLin += 65
    oPrint:Line(nLin,nColIni,nLin,nColFim) 
    oPrint:Say(nLin+15,140, "PADRAO (M2)",oFontAr8n)
    oPrint:Say(nLin+60,140, Alltrim(Transform(TMPZ3->Z3_M2PAD,"@E 999,999.9999")), oFontAr11)
    oPrint:Say(nLin+15,570, "PEÇAS",oFontAr8n)
    nTotPeca := 0
    dbSelectArea("SZ3")
    dbSetOrder(4)
    dbSeek(xFilial("SZ3")+TMPZ3->Z3_NUMFC)
    	while !SZ3->(eof()).and.xFilial("SZ3")==SZ3->Z3_FILIAL.and.TMPZ3->Z3_NUMFC == SZ3->Z3_NUMFC
    		nTotPeca+=SZ3->Z3_QTDE
    		SZ3->(dbSkip())
    	enddo
//    oPrint:Say(nLin+60,570, Alltrim(Transform(TMPZ3->Z3_QTDE, "E@ 999,999")), oFontAr11)

    oPrint:Say(nLin+60,570, Alltrim(Transform(nTotPeca, "E@ 999,999")), oFontAr11)
    nTotPeca := 0
    oPrint:Say(nLin+15,1000, "AREA (M2)",oFontAr8n)
    oPrint:Say(nLin+60,1000, Alltrim(Transform(TMPZ3->Z3_M2TOT,"@E 999,999.9999")), oFontAr11)
    oPrint:Say(nLin+15,1420,"AREA DA VAQUETA(M2)",oFontAr8n)                                 
    oPrint:Say(nLin+15,1870,"APROVEITAMENTO %",oFontAr8n)
    nLin += 50
    oPrint:Line(nLin,nColIni,nLin,nColFim)     
    nLin += 70
    oPrint:Line(nLin,nColIni,nLin,nColFim)     
	


//Montar as Celulas para registro dos apontamentos nas fases: Processo - Condicao - Hora - Operario - Observacoes
	nLin += 40
    oPrint:Line(nLin,nColIni,nLin,nColFim)
    oPrint:Line(nLin,nColIni,nLin+860,nColIni)
    oPrint:Line(nLin,nColFim,nLin+860,nColFim)
    //COLUNAS
    oPrint:Line(nLin,nColIni+70,nLin+860,nColIni+70)
    oPrint:Line(nLin,nColIni+560,nLIn+860,nColIni+560)
    oPrint:Line(nLin,nColIni+1050,nLin+860,nColIni+1050)
    oPrint:Line(nLin,nColIni+1180,nLin+860,nColIni+1180)
    oPrint:Line(nLin,nColIni+1480,nLin+860,nColIni+1480)
    oPrint:Say(nLin+40,120,"N",ofontAr12n)
    oPrint:Say(nLin+40,180,"Nome do Processo",oFontAr12n)
    oPrint:Say(nLin+40,670,"Condicao do Processo",oFontAr12n)
    oPrint:Say(nLin+40,1160,"Hora",oFontAr12n)
    oPrint:Say(nLin+40,1300,"Operario",oFontAr12n)
    oPrint:Say(nLin+40,1600,"Observacoes", oFontAr12n)
    
    nLin +=90                    
    oPrint:Line(nLin,nColIni,nLin,nColFim)
    oPrint:Say(nLin+25,122," 1",oFontAr11)
    oPrint:Say(nLin+25,180,"Almoxarifado",oFontAr11)
    nLin +=70
    oPrint:Line(nLin,nColIni,nLin,nColFim)
    oPrint:Say(nLin+25,122," 2",oFontAr11)
    oPrint:Say(nLin+25,180,"Marcacao de defeitos",oFontAr11)
    nLin +=70
    oPrint:Line(nLin,nColIni,nLin,nColFim)    
    oPrint:Say(nLin+25,122," 3",oFontAr11)
    oPrint:Say(nLin+25,180,"Riscagem",oFontAr11)
    nLin +=70
    oPrint:Line(nLin,nColIni,nLin,nColFim)    
    oPrint:Say(nLin+25,122," 4",oFontAr11)
    oPrint:Say(nLin+25,180,"Corte",oFontAr11)
    nLin +=70
    oPrint:Line(nLin,nColIni,nLin,nColFim)    
    oPrint:Say(nLin+25,122," 5",oFontAr11)
    oPrint:Say(nLin+25,180,"Limpeza",oFontAr11)
    nLin +=70
    oPrint:Line(nLin,nColIni,nLin,nColFim)    
    oPrint:Say(nLin+25,122," 6",oFontAr11)
 	oPrint:Say(nLin+25,180,"1 Inspecao",oFontAr11)
    nLin +=70
    oPrint:Line(nLin,nColIni,nLin,nColFim)
    oPrint:Say(nLin+25,122," 7",oFontAr11)
    oPrint:Say(nLin+25,180,"Mapa de Mesa",oFontAr11)    
    nLin +=70
    oPrint:Line(nLin,nColIni,nLin,nColFim)   
    oPrint:Say(nLin+25,122," 8",oFontAr11)
    oPrint:Say(nLin+25,180,"Perfuracao",oFontAr11)
    nLin +=70
    oPrint:Line(nLin,nColIni,nLin,nColFim)    
    oPrint:Say(nLin+25,122," 9",oFontAr11)
    oPrint:Say(nLin+25,180,"Carimbo",oFontAr11)
    nLin +=70
    oPrint:Line(nLin,nColIni,nLin,nColFim)    
    oPrint:Say(nLin+25,122,"10",oFontAr11)
    oPrint:Say(nLin+25,180,"2 Inspecao",oFontAr11)
    nLin +=70
    oPrint:Line(nLin,nColIni,nLin,nColFim)    
    oPrint:Say(nLin+25,122,"11",oFontAr11)
    oPrint:Say(nLin+25,180,"Embarque",oFontAr11)
    nLin +=70
    oPrint:Line(nLin,nColIni,nLin,nColFim)

	nLinB2 := nLin
	cCodComp :=""
	nPos := Ascan( aPeca, {|x| Alltrim( x[3] ) == Alltrim( TMPZ3->Z3_NUMFC )  } )	

   	nContLin := 0
   	nContComp := 0
   	nPosComp  := 0
	for i:=nPos to len(aPeca) 
		if len(aPeca) >= i
   		if aPeca[i,3] <> TMPZ3->Z3_NUMFC
    	    cCodComp := aPeca[i,1]   			
   		endif 
   		endif
        if nContLin <= 18	
		    if cCodComp <> aPeca[i,1]
		    	nPosComp++
//		    	alert('Componente -> '+cValToChar(nPosComp))
	    	    nContComp := 0
				//Calcular total do componente
				cCodComp1 := aPeca[i,1]
					nPos1 := Ascan( aPc, {|x| Alltrim( x[1] ) == Alltrim( cCodComp1+TMPZ3->Z3_NUMFC )  } )	
				nmt2 	:= 0
				for i1:=nPos1 to Len(aPc) 
					if cCodComp1+TMPZ3->Z3_NUMFC == aPc[i1,1]
						nmt2 += aPc[i1,4]
					else 
						i1:= Len(aPc)
					endif
				next i1
			    nLin += 50
				oPrint:Line(nLin,nColIni,nLin,nColFim)           

				oPrint:Line(nLin,nColIni,nLin+50,nColIni)
				oPrint:Line(nLin,nColFim,nLin+50,nColFim)
				oPrint:Line(nLin,nColIni+550,nLin+50,nColIni+550)
				oPrint:Line(nLin,nColIni+700,nLin+50,nColIni+700)
				oPrint:Line(nLin,nColIni+800,nLin+50,nColIni+800)
				oPrint:Line(nLin,nColIni+900,nLin+50,nColIni+900)
    		    oPrint:Say(nLin,120,Substr(Posicione("SB1",1,xFilial("SB1")+aPeca[i,1],"B1_DESC"),1,30),oFontAr8n)
	    	    oPrint:Say(nLin,700,Alltrim(Transform(nmt2,"@E 9,999.9999")), oFontAr8n)
    		    oPrint:Say(nLin,850,"NG     RP", oFontAr8n)
        	    nLin += 50                            
				oPrint:Line(nLin,nColIni,nLin+50,nColIni)
				oPrint:Line(nLin,nColFim,nLin+50,nColFim)
				oPrint:Line(nLin,nColIni,nLin,nColFim)
   				oPrint:Line(nLin,nColIni+100,nLin+50,nColIni+100)
				oPrint:Line(nLin,nColIni+400,nLin+50,nColIni+400)
				oPrint:Line(nLin,nColIni+550,nLin+50,nColini+550)
				oPrint:Line(nLin,nColini+700,nLin+50,nColini+700)
				oPrint:Line(nLin,nColIni+800,nLin+50,nColIni+800)
				oPrint:Line(nLin,nColIni+900,nLin+50,nColIni+900)
				oPrint:Say(nLin,100,Substr(aPeca[i,2],1,6),oFontAr8)
				oPrint:Say(nLin,220,u_descpc(Posicione("SB1",1,xFilial("SB1")+aPeca[i,2],"B1_DESC"),aPeca[i,2]),oFontAr8)
	  //			oPrint:Say(nLin,220,Substr(Posicione("SB1",1,xFilial("SB1")+aPeca[i,2],"B1_COD"),1,6),oFontAr8)
    		    oPrint:Say(nLin,550,Alltrim(Transform(aPeca[i,4],"@E 9,999.9999")), oFontAr8)
    		    nTotPeca := 0
    		    dbSelectArea("SZ3")
    		    dbSetOrder(4)
    		    dbSeek(xFilial("SZ3")+TMPZ3->Z3_NUMFC+aPeca[i,2])
//				Alert("COMP:"+aPeca[i][1]+" PECA: "+aPeca[i][2]+" POSICAO: "+cValToChar(aPeca[i][7]))    		    
				if (aPeca[i,7])>1
	  		    	for icomp:=2 to aPeca[i,7] //nPosComp
						SZ3->(dbSkip())
//						Alert("COMP:"+aPeca[i][1]+" PECA: "+aPeca[i][2]+" POSICAO: "+cValToChar(aPeca[i][7])+" SEQ:"+SZ3->Z3_SEQUEN)
    			    next i	
    			endif
   		     	nTotPeca+= SZ3->Z3_QTDE
				oPrint:Say(nLin,750,Alltrim(Transform(nTotPeca,"@E 9,999")), oFontAr8)
//				oPrint:Say(nLin,750,Alltrim(Transform(TMPZ3->Z3_QTDE,"@E 9,999")),oFontAr8)

				oPrint:Line(nLin,nColIni,nLin,nColFim)
				oPrint:Line(nLin+50,nColIni,nLin+50,nColFim)
	    	    cCodComp := aPeca[i,1]
			elseif aPeca[i,3] == TMPZ3->Z3_NUMFC
        	    nLin += 50
				oPrint:Line(nLin,nColIni,nLin+50,nColIni)
				oPrint:Line(nLin,nColFim,nLin+50,nColFim)
				oPrint:Line(nLin,nColIni,nLin,nColFim)
   				oPrint:Line(nLin,nColIni+100,nLin+50,nColIni+100)
				oPrint:Line(nLin,nColIni+400,nLin+50,nColIni+400)
				oPrint:Line(nLin,nColIni+550,nLin+50,nColini+550)
				oPrint:Line(nLin,nColini+700,nLin+50,nColini+700)
				oPrint:Line(nLin,nColIni+800,nLin+50,nColIni+800)
				oPrint:Line(nLin,nColIni+900,nLin+50,nColIni+900)
				oPrint:Say(nLin,100,Substr(aPeca[i,2],1,6),oFontAr8)				
				oPrint:Say(nLin,220,u_descpc(Posicione("SB1",1,xFilial("SB1")+aPeca[i,2],"B1_DESC"),aPeca[i,2]),oFontAr8)
//				oPrint:Say(nLin,220,Substr(Posicione("SB1",1,xFilial("SB1")+aPeca[i,2],"B1_COD"),1,6),oFontAr8)
    		    oPrint:Say(nLin,550,Alltrim(Transform(aPeca[i,4],"@E 9,999.9999")), oFontAr8)
    		    nTotPeca := 0
    		    dbSelectArea("SZ3")
    		    dbSetOrder(4)
    		    dbSeek(xFilial("SZ3")+TMPZ3->Z3_NUMFC+aPeca[i,2])
//    		    while !SZ3->(eof()).and.SZ3->Z3_NUMFC == TMPZ3->Z3_NUMFC.and.SZ3->Z3_PRODUTO == aPeca[i,2]
				if (aPeca[i,7])>1
	  		    	for icomp:=2 to aPeca[i,7] //nPosComp
						SZ3->(dbSkip())
//						Alert("COMP:"+aPeca[i][1]+" PECA: "+aPeca[i][2]+" POSICAO: "+cValToChar(aPeca[i][7])+" SEQ:"+SZ3->Z3_SEQUEN)    		    
    			    next i	
    			endif
   		     	nTotPeca+= SZ3->Z3_QTDE
				oPrint:Say(nLin,750,Alltrim(Transform(nTotPeca,"@E 9,999")), oFontAr8)
//				oPrint:Say(nLin,750,Alltrim(Transform(TMPZ3->Z3_QTDE,"@E 9,999")),oFontAr8)
				oPrint:Line(nLin,nColIni,nLin,nColFim)
				oPrint:Line(nLin+50,nColIni,nLin+50,nColFim)
   			endif 
			incProc('Prc.fc '+TMPZ3->Z3_NUMFC+Substr(aPeca[i,2],1,6)+' PC '+cValToChar(i)+' PG '+cValToChar(nFolha)+'/'+cValToChar(nFolhas))
	   		if aPeca[i,3] <> TMPZ3->Z3_NUMFC
   				i:= len(aPeca) + 1 
   			endif 
   		else  //Imprimir no Bloco 02
		    if cCodComp <> aPeca[i,1]
                nContComp:=0
                nPosComp++
				//Calcular total do componente
				cCodComp1 := aPeca[i,1]
					nPos1 := Ascan( aPc, {|x| Alltrim( x[1] ) == Alltrim( cCodComp1+TMPZ3->Z3_NUMFC )  } )	
				nmt2 	:= 0
				for i1:=nPos1 to Len(aPc) 
					if cCodComp1+TMPZ3->Z3_NUMFC == aPc[i1,1]
						nmt2 += aPc[i1,4]
					else 
						i1:= Len(aPc)
					endif
				next i1
			    nLinB2 += 50
				oPrint:Line(nLinB2,nColIni,nLinB2,nColFim)
//				oPrint:Line(nLinB2,nColIni,nLinB2+50,nColIni)
//				oPrint:Line(nLinB2,nColFim,nLinB2+50,nColFim)
//				oPrint:Line(nLinB2,nColIni+1000,nLinB2+50,nColIni+1100)
				oPrint:Line(nLinB2,nColIni+1600,nLinB2+50,nColIni+1600)
				oPrint:Line(nLinB2,nColIni+1800,nLinB2+50,nColIni+1800)
				oPrint:Line(nLinB2,nColIni+1900,nLinB2+50,nColIni+1900)
				oPrint:Line(nLinB2,nColIni+2000,nLinB2+50,nColIni+2000)
    		    oPrint:Say(nLinB2,1050,Substr(Posicione("SB1",1,xFilial("SB1")+aPeca[i,1],"B1_DESC"),1,30),oFontAr8n)
	    	    oPrint:Say(nLinB2,1720,Alltrim(Transform(nmt2,"@E 9,999.9999")), oFontAr8n)
    		    oPrint:Say(nLinB2,1900,"     NG        RP", oFontAr8n)
        	    nLinB2 += 50    
        	    
        	                            
				oPrint:Line(nLinB2,nColIni,nLinB2+50,nColIni)
				oPrint:Line(nLinB2,nColFim,nLinB2+50,nColFim)
				oPrint:Line(nLinB2,nColIni,nLinB2,nColFim)
   				oPrint:Line(nLinB2,nColIni+1000,nLinB2+50,nColIni+1000)
				oPrint:Line(nLinB2,nColIni+1450,nLinB2+50,nColIni+1450)
				oPrint:Line(nLinB2,nColIni+1600,nLinB2+50,nColini+1600)
				oPrint:Line(nLinB2,nColini+1800,nLinB2+50,nColini+1800)
				oPrint:Line(nLinB2,nColIni+1900,nLinB2+50,nColIni+1900)
				oPrint:Line(nLinB2,nColIni+2000,nLinB2+50,nColIni+2000)
				oPrint:Say(nLin,1120,Substr(aPeca[i,2],1,6),oFontAr8)
				oPrint:Say(nLinB2,1150,u_descpc(Posicione("SB1",1,xFilial("SB1")+aPeca[i,2],"B1_DESC"),aPeca[i,2]),oFontAr8)  
    		    oPrint:Say(nLinB2,1600,Alltrim(Transform(aPeca[i,4],"@E 9,999.9999")), oFontAr8)	 

    		    nTotPeca := 0
    		    dbSelectArea("SZ3")
    		    dbSetOrder(4)
    		    dbSeek(xFilial("SZ3")+TMPZ3->Z3_NUMFC+aPeca[i,2])
				if (aPeca[i,7])>1
	  		    	for icomp:=2 to aPeca[i,7] //nPosComp
						SZ3->(dbSkip())
//						Alert("COMP:"+aPeca[i][1]+" PECA: "+aPeca[i][2]+" POSICAO: "+cValToChar(aPeca[i][7])+" SEQ:"+SZ3->Z3_SEQUEN)
    			    next i	
    			endif
   		     	nTotPeca+= SZ3->Z3_QTDE
				oPrint:Say(nLinB2,1770,Alltrim(Transform(nTotPeca,"@E 9,999")),oFontAr8)

				oPrint:Line(nLinB2,nColIni,nLinB2,nColFim)
	    	    cCodComp := aPeca[i,1]
			elseif aPeca[i,3] == TMPZ3->Z3_NUMFC
        	    nLinB2 += 50
				oPrint:Line(nLinB2,nColIni,nLinB2+50,nColIni)
				oPrint:Line(nLinB2,nColFim,nLinB2+50,nColFim)
				oPrint:Line(nLinB2,nColIni,nLinB2,nColFim)
   				oPrint:Line(nLinB2,nColIni+1000,nLinB2+50,nColIni+1000)
				oPrint:Line(nLinB2,nColIni+1450,nLinB2+50,nColIni+1450)
				oPrint:Line(nLinB2,nColIni+1600,nLinB2+50,nColini+1600)
				oPrint:Line(nLinB2,nColini+1800,nLinB2+50,nColini+1800)
				oPrint:Line(nLinB2,nColIni+1900,nLinB2+50,nColIni+1900)
				oPrint:Line(nLinB2,nColIni+2000,nLinB2+50,nColIni+2000)
				oPrint:Say(nLinB2,1150,u_descpc(Posicione("SB1",1,xFilial("SB1")+aPeca[i,2],"B1_DESC"),aPeca[i,2]),oFontAr8)  
    		    oPrint:Say(nLinB2,1600,Alltrim(Transform(aPeca[i,4],"@E 9,999.9999")), oFontAr8)
//					oPrint:Say(nLinB2,1770,Alltrim(Transform(TMPZ3->Z3_QTDE,"@E 9,999")),oFontAr8)
    		    nTotPeca := 0
    		    dbSelectArea("SZ3")
    		    dbSetOrder(4)
    		    dbSeek(xFilial("SZ3")+TMPZ3->Z3_NUMFC+aPeca[i,2])
				if (aPeca[i,7])>1
	  		    	for icomp:=2 to aPeca[i,7] //nPosComp
						SZ3->(dbSkip())
//						Alert("COMP:"+aPeca[i][1]+" PECA: "+aPeca[i][2]+" POSICAO: "+cValToChar(aPeca[i][7])+" SEQ:"+SZ3->Z3_SEQUEN)
    			    next i	
    			endif
   		     	nTotPeca+= SZ3->Z3_QTDE
				oPrint:Say(nLinB2,1770,Alltrim(Transform(nTotPeca,"@E 9,999")), oFontAr8)
				oPrint:Line(nLinB2,nColIni,nLinB2,nColFim)
				oPrint:Line(nLinB2+50,nColIni,nLinB2+50,nColFim)
	    	    cCodComp := aPeca[i,1]				
   			endif 
			incProc('Prc.fc '+TMPZ3->Z3_NUMFC+Substr(aPeca[i,2],1,6)+' PC '+cValToChar(i)+' PG '+cValToChar(nFolha)+'/'+cValToChar(nFolhas))
	   		if aPeca[i,3] <> TMPZ3->Z3_NUMFC
   				i:= len(aPeca) + 1 
   			endif 
		endif
		nContLin++
		nContComp++
//		alert('Item -> ' +cValToChar(nContComp))
 	next i
                  
//  	oPrint:Say(nLinB2, 1200,"TESTE DO BLOCO")
TMPZ3->(dbSkip())
//Alert("LINHA: "+cValToChar(nLin))
oPrint:Say(3200,1900,"CT - 20     " + cValToChar(nFolha)+"/"+cValToChar(nFolhas))

oPrint:EndPage()
oPrint:Preview()
nFolha += 1	
nLin := 30       
enddo                                                                      

oPrint:Preview()  		// Visualizar todos antes de enviar para impressora


user function descpc(cNome, cCodProd)
local cPecaRes := ""
Local ipc
for ipc:= 1 to len(cNome)
	if substr(cNome,ipc,4)=='PECA' 
		cPecaRes := Substr(cNome,ipc+5,15)
		ipc:=Len(cNome)
	endif
next ipc
if cPecaRes == ""
	cPecaRes := cCodProd
endif
Return cPecaRes