#include "rwmake.ch"
#include "colors.ch"

User Function MDROMBC2()

LOCAL oPrint
Local _aCartoon := {}
Local _cCampo, _nOrdem
Local cPerg		:= "MDROMBC2"
Local _nx
Private _nTamLin := 0

Private oFont8
Private oFont11c
Private oFont10
Private oFont14
Private oFont16n
Private oFont15
Private oFont14n
Private oFont24

Private _nTotKits := 0
Private _nTotPall := 0

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)

oFont4  := TFont():New("Arial",9,6,.T.,.F.,5,.T.,5,.T.,.F.)
oFont5  := TFont():New("Arial",9,7,.T.,.F.,5,.T.,5,.T.,.F.)
oFont6  := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8  := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9  := TFont():New("Arial",9,9,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9n  := TFont():New("Arial",9,9,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10n  := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12n  := TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)

CriaSx1(cPerg)
pergunte(cPerg,.t.)

if MV_PAR01 == 1
	_nOrdem := 1
	_cCampo := "ZZD->ZZD_NRROM"
Elseif MV_PAR01 == 2
	_nOrdem := 2
	_cCampo := "ZZD->ZZD_REF"
Endif

_lCont := .f.
dbSelectArea("ZZD")
dbSetOrder(_nOrdem)
if dbSeek(xfilial("ZZD")+alltrim(MV_PAR02))
	_lCont := .t.
Endif


if _lCont
	
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xfilial("SB1")+ZZD->ZZD_CODIGO)
	
	dbSelectArea("ZZC")
	dbSetOrder(1)
	dbSeek(xfilial("ZZC")+ZZD->ZZD_NRROM)
	
	dbSelectArea("EEC")
	dbSetOrder(14)
	dbSeek(xfilial("EEC")+ZZC->ZZC_PEDIDO)
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(XFILIAL("SA1")+MV_PAR03+MV_PAR04)
	
	_cModelo := ZZC->ZZC_COD_I
	_cModAnt := _cModelo
	_nQtdStru := _fQtdStru(_cModelo)
	
	_lPrado := if(ZZC->ZZC_PRADO=="S",.t.,.f.)
	_nPesoL := 0
	_nPesoB := 0
	_cromaneio := ZZD->ZZD_NRROM
	_nPalets := 1
	
	dbSelectArea("ZZD")
	While !ZZD->(EOF()) .and. alltrim(&_cCampo) == alltrim(MV_PAR02)
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xfilial("SB1")+ZZD->ZZD_CODIGO)
		
		//                        1              2            3             4            5             6               7                 8     9vehicle type           10               11              12               13               14           15                   16                 17            18                         19            20            21        22       23
		aadd(_aCartoon,{ZZD->ZZD_NRROM, ZZD->ZZD_REF, _cModelo  , ZZD->ZZD_QTDE, ZZD->ZZD_NRCX, ZZD->ZZD_PESOL, ZZD->ZZD_PESOB, ZZC->ZZC_NRPAL, ""                 ,ZZD->ZZD_NRPART, SB1->B1_XBACKN, ZZD->ZZD_DESC, ZZD->ZZD_SERIAL,ZZC->ZZC_QTKIT ,ZZC->ZZC_PESOL  , ZZC->ZZC_PESOB, ZZC->ZZC_CUBAGE,ZZC->ZZC_PESO+ZZC->ZZC_PESOIN,ZZC->ZZC_DIM,ZZC->ZZC_QTKIT,ZZC->ZZC_COR,_nQtdStru,  0})
		
		//ULTIMA POSICAO DO MODELO CONTEM PESO TOTAL
		_nPos := ascan(_aCartoon, {|x| x[3] == _cModelo })
		
		ZZD->(dbSkip())
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xfilial("SB1")+ZZD->ZZD_CODIGO)
		
		dbSelectArea("ZZC")
		dbSetOrder(1)
		dbSeek(xfilial("ZZC")+ZZD->ZZD_NRROM)
		
		if (!empty(ZZD->ZZD_EXTRA)) .or.(!_lPrado .and. ZZD->ZZD_NRROM <> _cRomaneio)
			
			_nPos := ascan(_aCartoon,{|x| x[3] == _cModAnt })
			_cModelo		:= if(_lPrado,ZZD->ZZD_EXTRA,ZZC->ZZC_COD_I)
			_cModAnt := _cModelo
			_nQtdStru := _fQtdStru(_cModelo)
			_cRomaneio := ZZD->ZZD_NRROM
			
		Endif
		
	End
	
/*	if _lPrado
		
		oFont4  := TFont():New("Arial",9,4,.T.,.F.,5,.T.,5,.T.,.F.)
		oFont5  := TFont():New("Arial",9,5,.T.,.F.,5,.T.,5,.T.,.F.)
		oFont6  := TFont():New("Arial",9,6,.T.,.F.,5,.T.,5,.T.,.F.)
		
		oPrint:= TMSPrinter():New( "Romaneio Prado Capa" )
		oPrint:StartPage()   // Inicia uma nova página
		oPrint:SetLandscape()  //SetPortrait() // ou SetLandscape()
		oPrint:Setup()
		
		Impress(oPrint,_aCartoon)
		
		oPrint:EndPage()     // Finaliza a página
		oPrint:Preview()     // Visualiza antes de imprimir
		
		///////////////////////////////////////////////////////////////////Q
		
		oPrint:= TMSPrinter():New( "Romaneio Prado Detalhe" )
		oPrint:StartPage()   // Inicia uma nova página
		oPrint:SetPortrait()  //SetPortrait() // ou SetLandscape()
		oPrint:Setup()
		
		Impr2(oPrint,_aCartoon)
		
		oPrint:EndPage()     // Finaliza a página
		oPrint:Preview()     // Visualiza antes de imprimir
		
	else
 */		
		For _nx := 1 to len(_aCartoon)
			_aCartoon[_nx][23] := _fQtdPallet(_aCartoon[_nx][3],_aCartoon)
		Next
		
		oPrint:= TMSPrinter():New( "Romaneio  Capa" )
		oPrint:StartPage()   // Inicia uma nova página
		oPrint:SetLandscape()  //SetPortrait() // ou SetLandscape()
		oPrint:Setup()
		
		Impr3(oPrint,_fSubaru(_aCartoon))
		
		oPrint:EndPage()     // Finaliza a página
		oPrint:Preview()     // Visualiza antes de imprimir
		
		////////////////////////////////////
		
		oPrint:= TMSPrinter():New( "Romaneio  Detalhe" )
		oPrint:StartPage()   // Inicia uma nova página
		oPrint:SetPortrait()  //SetPortrait() // ou SetLandscape()
		oPrint:Setup()
		
		Impr4(oPrint,_aCartoon)
		
		oPrint:EndPage()     // Finaliza a página
		oPrint:Preview()     // Visualiza antes de imprimir
		
//	Endif
	
	
	
Endif

Return nil

/*
ROTINA..................:Impr2
OBJETIVO................:Detalhe do romaneio
*/

Static Function Impress(oPrint,_aCartoon)
Local _nx, _ny
nRow1 := -100

_nRomaneio := ""
For _nx := 1 to len(_aCartoon)
	
	if _nRomaneio <> _aCartoon[_nx][1]
		_lImpCartoon := .t.
		_nromaneio := _aCartoon[_nx][1]
		_lCabec := .t.
	Endif
	
	//************
	// CABECALHO
	//************
	if nRow1 == -100 .or. _lCabec == .t.
		if nRow1 == -100
			oPrint:StartPage()   // Inicia uma nova página
			nRow1 := ImpLogo(oPrint)
		Endif
		
		nRow1 := ImpCabec(oPrint,_nx, _aCartoon)
		_lImpCartoon := .t.
		_lCabec := .f.
	Endif
	
	if  _lImpCartoon
		
		oPrint:Say  (nRow1+0100,0430,alltrim(str(_aCartoon[_nx][8])),oFont5)
		oPrint:Say  (nRow1+0100,0500,alltrim(str(_aCartoon[_nx][20])),oFont6)
		oPrint:Say  (nRow1+0050,0600,_aCartoon[_nx][21],oFont5)
		oPrint:Line (nRow1+0080,0700,nRow1+0080,_nTamlin)
		
		oPrint:Say  (nRow1+0100,0600,"Weight",oFont5)
		oPrint:Line (nRow1+0100,0700,nRow1+0100,_nTamlin)
		
		oPrint:Say  (nRow1+0080,0700,"Gross",oFont5)
		oPrint:Say  (nRow1+0100,0700,"Net",oFont5)
		oPrint:Line (nRow1+0120,0700,nRow1+0120,_nTamlin)
		
		oPrint:Say  (nRow1+0120,0700,"Other Weights",oFont5)
		oPrint:Say  (nRow1+0120,0850,transform(_aCartoon[_nx][18],"999.99"),oFont4)
		oPrint:Line (nRow1+0140,0700,nRow1+0140,_nTamlin)
		
		oPrint:Say  (nRow1+0140,0600,"Dimension",oFont5)
		oPrint:Say  (nRow1+0140,0850,_aCartoon[_nx][19],oFont4)
		oPrint:Line (nRow1+0160,0600,nRow1+0160,_nTamlin)
		
		oPrint:Say  (nRow1+0160,0600,"M3",oFont5)
		oPrint:Say  (nRow1+0160,0850,transform(_aCartoon[_nx][17],"999,999.99"),oFont4)
		oPrint:Line (nRow1+0180,0080,nRow1+0180,_nTamlin)
		
		_nw := 1
		_cRomaneio := _aCartoon[_nx][1]
		For _ny := _nx to len(_aCartoon)
			
			oPrint:Say  (nRow1+0080,0800+(_nw*35),transform(_aCartoon[_ny][7],"999.99"),oFont4)
			oPrint:Say  (nRow1+0100,0800+(_nw*35),transform(_aCartoon[_ny][6],"999.99"),oFont4)
			++_nw
			
			if _aCartoon[_ny][1] <> _cRomaneio
				exit
			Endif
			
		Next
		oPrint:Say  (nRow1+0080,_nTamlin-050,transform(_aCartoon[_nx][16],"999,999.99"),oFont4)
		oPrint:Say  (nRow1+0100,_nTamlin-050,transform(_aCartoon[_nx][15],"999,999.99"),oFont4)
		
		oPrint:Line (nRow1+0080,600,nRow1+0080,_nTamlin)
		
		_lImpCartoon := .f.
		
	Endif
	
	if !empty(_aCartoon[_nx][3])
		
		_cTxtMod := GETADVFVAL("SB1","B1_DESC",XFILIAL("SB1")+_aCartoon[_nx][3],1,"")
		
		oPrint:Say  (nRow1+0050,0080,_cTxtMod,oFont6)
		oPrint:Say  (nRow1+0050,0250,_aCartoon[_nx][11],oFont5)
		oPrint:Say  (nRow1+0050,0320,transform(_aCartoon[_nx][14]/ _aCartoon[_nx][22] ,"9,999"),oFont6)
		oPrint:Line (nRow1+0090,0080,nRow1+0090,0400)
		
		nRow1 += 45
	Endif
	
	if nRow1 > 1000
		oPrint:EndPage() // Finaliza a página
		nRow1 := -100
	Endif
	
Next
oPrint:EndPage() // Finaliza a página

Return Nil


/*
ROTINA..................:Impr2
OBJETIVO................:Detalhe do romaneio
*/

Static Function Impr2(oPrint,_aCartoon)
Local _nx
Local _nNrKits := 0

nRow1 := -100
oPrint:SetLandScape()

_nRomaneio := ""
For _nx := 1 to len(_aCartoon)
	
	if _nRomaneio <> _aCartoon[_nx][1]
		if !empty(_nRomaneio)
			ImpFooter(oPrint,_nNrKits)
			_nNrKits := 0
			oPrint:EndPage() // Finaliza a página
		Endif
		_nromaneio := _aCartoon[_nx][1]
		nRow1 := -100
	Endif
	
	//************
	// CABECALHO
	//************
	if nRow1 == -100
		oPrint:StartPage()   // Inicia uma nova página
		nRow1 := ImpCab2(oPrint,_nx, _aCartoon)
	Endif
	
	oPrint:Say  (nRow1+0100,0085,_aCartoon[_nx][5],ofont9)
	oPrint:Say  (nRow1+0100,0230,_aCartoon[_nx][9],ofont9)
	oPrint:Say  (nRow1+0100,0450,_aCartoon[_nx][10],ofont9)
	oPrint:Say  (nRow1+0100,0650,_aCartoon[_nx][11],ofont9)
	oPrint:Say  (nRow1+0100,0800,_aCartoon[_nx][12],ofont9)
	oPrint:Say  (nRow1+0100,1400,transform(_aCartoon[_nx][4],"9,999"),ofont9)
	oPrint:Say  (nRow1+0100,1700,_aCartoon[_nx][13],ofont9)
	_nNrKits += _aCartoon[_nx][4]
	
	oPrint:Line (nRow1+0130,0080,nRow1+0130,_nTamlin)
	nRow1 += 40
	
	if nRow1 > 1500
		oPrint:EndPage() // Finaliza a página
		nRow1 := -100
	Endif
	
Next

ImpFooter(oPrint,_nNrKits)
_nNrKits := 0
oPrint:EndPage() // Finaliza a página

Return Nil


Static Function ImpLogo(oPrint)


oPrint:Line (nRow1+0150,0080,nRow1+0150,_nTamLin)
oPrint:Say  (nRow1+0150,0140,"PACKING LIST PER SHIPMENT",oFont8)
oPrint:Line (nRow1+0180,0080,nRow1+0180,_nTamLin)
oPrint:Say  (nRow1+0200,0140,"DESTINATION",oFont8)
oPrint:Say  (nRow1+0200,0400,SA1->A1_NOME,oFont8)


oPrint:Say  (nRow1+0250,0140,"INVOICE "+EEC->EEC_PREEMB,oFont8)
oPrint:Say  (nRow1+0300,0140,DTOC(dDataBase),oFont8)
oPrint:Line (nRow1+0330,0080,nRow1+0330,_nTamLin)

oPrint:Line (nRow1+0150,0080,nRow1+0380,0080)
oPrint:Line (nRow1+0150,_nTamLin,nRow1+0380,_nTamLin)


Return(nRow1+150)

/*
ROTINA..................:ImpCabec
OBJETIVO................:Cabecalho da capa do packing list
*/

Static Function ImpCabec(oprint,_nx, _aCartoon)
Local _ny

oPrint:Say(nRow1+0200,0140,"MODEL",oFont6)
oPrint:Say(nRow1+0200,0320,"KITS",oFont6)
oPrint:Say(nRow1+0200,0410,"PALLET",oFont6)
oPrint:Say(nRow1+0200,0500,"Total Kits",oFont6)
oPrint:Say(nRow1+0200,0600,"Color",oFont6)
oPrint:Say(nRow1+0200,0700,"Qty",oFont6)

_nw := 1
_cRomaneio := _aCartoon[_nx][1]
For _ny := _nx to len(_aCartoon)
	
	if _aCartoon[_ny][1] == _cRomaneio
		oPrint:Say  (nRow1+0200,0800+(_nw*35),strzero(val(_aCartoon[_ny][5]),3),oFont5)
		++_nw
	else
		exit
	Endif
	
Next
_nw--
_nTamlin := 0800+(_nw*35)+100

oPrint:Line (nRow1+0200,0080,nRow1+0200,_nTamLin)

oPrint:Say  (nRow1+0200,_nTamlin-050,"Total",oFont5)
oPrint:Line (nRow1+0230,0080,nRow1+0230,_nTamlin)

_cModelo := _aCartoon[_nx][3]
_cTxtMod := alltrim(GETADVFVAL("SB1","B1_DESC",XFILIAL("SB1")+_aCartoon[_nx][3],1,"") )

oPrint:Say  (nRow1+0300,0080,_cTxtMod,oFont6)

_nQtdKits := 120 //_aCartoon[_nx][14]/ _aCartoon[_nx][22]
_nTotKits += _nQtdKits
oPrint:Say  (nRow1+0300,0320,transform(_nQtdKits ,"9,999"),oFont6)

_nPallets := _aCartoon[_nx][23]
_nTotPall += _nPallets
//PALLETS
oPrint:Say  (nRow1+0300,0430,alltrim(str(_nPallets)),oFont6)

//TOTAL KITS
oPrint:Say  (nRow1+0300,0500,alltrim(str(_nQtdKits * _nPallets )),oFont6)

Return(nRow1+0180)

/*
ROTINA..................:ImpFooter
OBJETIVO................:Cabecalho da capa do packing list
*/
Static Function ImpFooter(oPrint,_nNrKits,_nLinIni)

oPrint:Say  (nRow1+0100,1200,"TOTAL",oFont10n)
oPrint:Say  (nRow1+0100,1600,transform(_nNrKits,"99,999"),ofont10n)
oPrint:Line (nRow1+0140,0080,nRow1+0140,_nTamLin)

oPrint:Say  (nRow1+2000,950,"Page "+alltrim(str(_nPage))+" of "+alltrim(str(_nTotPall)),ofont10n)


Return(nRow1+0100)



/*
ROTINA..................:ImpCab2
OBJETIVO................:Cabecalho da capa do packing list
*/

Static Function ImpCab2(oprint,_nx, _aCartoon)
                        
++_nPage
oPrint:Line (nRow1+0150,0080,nRow1+0150,_nTamLin)
oPrint:Say  (nRow1+0150,0700,"PACKING LIST PER SHIPMENT",oFont12n)

oPrint:Say  (nRow1+0200,0600,"MIDORI AUTO LEATHER BRASIL LTDA",oFont10)

oPrint:Say  (nRow1+0250,0350,"RUA ANDRELINO VAZ DE ARRUA - PARQUE INDUSTRIAL - PENAPOLIS - SP - CEP 16.300-000 - BRASIL",oFont6)
oPrint:Say  (nRow1+0280,0600,"CNPJ : 60.398.914/0008-50   Inscr. Estadual : 521.123.719.119",oFont6)


oPrint:Say  (nRow1+0370,0140,"CUSTOMER "+SA1->A1_NOME,oFont6)
oPrint:Say  (nRow1+0370,0850,"Pallet No. "+strzero(_aCartoon[_nx][8],3) +"/"+ strzero(_nTotPall,3),oFont6)
oPrint:Say  (nRow1+0400,0140,"                       "+SA1->A1_END,oFont6)
oPrint:Say  (nRow1+0440,0140,"                       "+SA1->A1_BAIRRO,oFont6)


oPrint:Say  (nRow1+0520,0140,"INVOICE No. ",oFont6)
oPrint:Say  (nRow1+0520,0650,"DATE :"+DTOC(dDataBase),oFont6)

nRow1+= 380

oBrush1 := TBrush():New( , CLR_BLACK )
oPrint:FillRect( {nRow1+190, 80, nRow1+250, 1900}, oBrush1 )

oPrint:Say  (nRow1+0200,0090,"Cartoon",ofont9n,,CLR_WHITE)
oPrint:Say  (nRow1+0200,0240,"Vehicle type",ofont9n,,CLR_WHITE)
oPrint:Say  (nRow1+0200,0470,"Parts No.",ofont9n,,CLR_WHITE)
oPrint:Say  (nRow1+0200,0700,"Back Number",ofont9n,,CLR_WHITE)
oPrint:Say  (nRow1+0200,0800,"     ",ofont9n,,CLR_WHITE)
oPrint:Say  (nRow1+0200,1530,"Quantity",ofont9n,,CLR_WHITE)
oPrint:Say  (nRow1+0200,1720,"Serial #",ofont9n,,CLR_WHITE)

_ntamlin := 1900

oPrint:Line (nRow1+0230,0080,nRow1+0230,_nTamlin)


Return(nRow1+0180)


/*
ROTINA..................:Impr3
OBJETIVO................:Detalhe do romaneio Subaru
*/

Static Function Impr3(oPrint,_aCartoon)
Local _nx
Local _cModelo := ""
Local _nLinIni := 0
Local _nLinfim := 0
Local nRow0 := 0
Local _nTotPBruto := 0
Local _nTotPLiqui := 0
Local _ny

nRow1 := -100

asort(_aCartoon,,, {|x,y| y[2]+y[1]+y[5] > x[2]+x[1]+x[5]  })

_nRomaneio := ""
For _nx := 1 to len(_aCartoon)
	
	if _nRomaneio <> _aCartoon[_nx][1]
		_lImpCartoon := .t.
		_nromaneio := _aCartoon[_nx][1]
		_lCabec := .t.
	Endif
	
	//************
	// CABECALHO
	//************
	if nRow1 == -100 .or. _lCabec == .t.
		if nRow1 == -100
			oPrint:StartPage()   // Inicia uma nova página
			nRow1 += 180
		Endif
		
		_nLinIni := nRow1+200
		nRow1 := ImpCabec3(oPrint,_nx, _aCartoon)
		_lImpCartoon := .t.
		_lCabec := .f.
	Endif
	
	if  _lImpCartoon
		
		oPrint:Say  (nRow1+0050,1100,_aCartoon[_nx][21],oFont5)
		oPrint:Line (nRow1+0080,1080,nRow1+0080,_nTamlin)
		
		oPrint:Say  (nRow1+0130,1100,"Weight",oFont5)
		oPrint:Say  (nRow1+0090,1300,"Gross",oFont5)
		oPrint:Say  (nRow1+0130,1300,"Net",oFont5)
		oPrint:Line (nRow1+0120,1280,nRow1+0120,_nTamlin)
		oPrint:Line (nRow1+0160,1280,nRow1+0160,_nTamlin)
		
		oPrint:Say  (nRow1+0210,1100,"Dimension",oFont5)
		oPrint:Say  (nRow1+0210,1500,_aCartoon[_nx][19],oFont4)
		oPrint:Line (nRow1+0240,1080,nRow1+0240,_nTamlin)
		
		oPrint:Say  (nRow1+0250,1100,"M3",oFont5)
		oPrint:Say  (nRow1+0250,1500,transform(_aCartoon[_nx][17],"999,999.99"),oFont4)
		oPrint:Line (nRow1+0280,0080,nRow1+0280,_nTamlin)
		
		_nLinFim := nRow1+0280
		
		
		_nw := 1
		_cRomaneio := _aCartoon[_nx][1]
		
		_nTotPBruto := 0
		_nTotPLiqui := 0
		
		For _ny := _nx to len(_aCartoon)
			
			if _aCartoon[_ny][1] <> _cRomaneio
				exit
			Endif
			
			//PESOS CARTOONS
			_nTotPbruto += _aCartoon[_ny][7]
			_nTotPliqui += _aCartoon[_ny][6]
			
			oPrint:Say  (nRow1+0090,1395+(_nw*55),transform(_aCartoon[_ny][7],"999.99"),oFont4)
			oPrint:Say  (nRow1+0130,1395+(_nw*55),transform(_aCartoon[_ny][6],"999.99"),oFont4)
			oPrint:Line (_nLinIni,1400+(_nw*55),nRow1+0160,1400+(_nw*55))
			
			++_nw
			
			
		Next
		
		_nx:=_ny-1
		
		
		//TOTAL PESO BRUTO E LIQUIDO
		oPrint:Say  (nRow1+0090,_nTamlin-100,transform(_nTotPBruto,"999,999.99"),oFont4)
		oPrint:Say  (nRow1+0130,_nTamlin-100,transform(_nTotPLiqui,"999,999.99"),oFont4)
		
		
		oPrint:Say  (nRow1+0170,1300,"Other Weights",oFont5)
		oPrint:Say  (nRow1+0170,1500,transform(_aCartoon[_nx][18],"999.99"),oFont4)
		oPrint:Line (nRow1+0200,1080,nRow1+0200,_nTamlin)
		
		oPrint:Say  (nRow1+0170,_nTamLin-300,"Total Weight",oFont5)
		oPrint:Say  (nRow1+0170,_nTamLin-100,transform(_nTotPBruto+_aCartoon[_nx][18],"999,999.99"),oFont4)
		
		oPrint:Line (nRow1+0080,1500,nRow1+0080,_nTamlin)
		
		//LINHAS VERTICAIS
		oPrint:Line (_nLinIni,480,_nLinFim,480)
		oPrint:Line (_nLinIni,680,_nLinFim,680)
		oPrint:Line (_nLinIni,880,_nLinFim,880)
		oPrint:Line (_nLinIni,1080,_nLinFim,1080)
		oPrint:Line (_nLinIni,1280,nRow1+0200,1280)
		
		oPrint:Line (_nLinIni,0080,_nLinFim,0080)
		
		oPrint:Line (_nLinIni,_nTamLin-100,_nLinFim,_nTamLin-100)
		oPrint:Line (_nLinIni,_nTamLin,_nLinFim,_nTamLin)
		
		
		_lImpCartoon := .f.
		nRow1+=120
		
	Endif
	
	//	if _aCartoon[_nx][3] <> _cModelo
	
	//		nRow1 += 45
	//	Endif
	
	nRow0 := nRow1
	if nRow1 > 1300
		ImpFooter3(oPrint,nRow0)
		nRow1 := -100
		ImpLogo(oPrint)
		oPrint:EndPage() // Finaliza a página
	Endif
	
Next

if nRow1 > -100
	ImpFooter3(oPrint,nRow0)
	nRow1 := -100
	ImpLogo(oPrint)
Endif

oPrint:EndPage() // Finaliza a página

Return Nil

/*
ROTINA..................:ImpFooter3
OBJETIVO................:Rodape Romaneio Subaru
*/

Static Function ImpFooter3(oPrint,nRow0)

oPrint:Say  (nRow0+200,0080,"TOTAL (PALLETS / KITS) ",oFont10n)
oPrint:Say  (nRow0+200,0710,transform(_nTotPall,"99,999"),ofont10n)
oPrint:Say  (nRow0+200,0910,transform(_nTotKits,"99,999"),ofont10n)

Return

/*
ROTINA..................:Impr4
OBJETIVO................:Detalhe do romaneio
*/

Static Function Impr4(oPrint,_aCartoon)
Local _nx
Local _nNrKits := 0
Local _nLinIni := 0
Local _nLinFim := 0
Private _nPage := 0

nRow1 := -100
oPrint:SetLandScape()

_nRomaneio := ""
For _nx := 1 to len(_aCartoon)
	
	if _nRomaneio <> _aCartoon[_nx][1]
		if !empty(_nRomaneio)
			
			nRow1 := ImpFooter(oPrint,_nNrKits)
			
			_nLinFim := nRow1
			
			oPrint:Line (_nLinIni+30,080,_nLinFim-10,080)
			oPrint:Line (_nLinIni+30,230,_nLinFim-10,230)
			oPrint:Line (_nLinIni+30,450,_nLinFim-10,450)
			oPrint:Line (_nLinIni+30,700,_nLinFim-10,700)
			oPrint:Line (_nLinIni+30,900,_nLinFim-10,900)
			oPrint:Line (_nLinIni+30,1500,_nLinFim-10,1500)
			oPrint:Line (_nLinIni+30,1700,_nLinFim-10,1700)
			oPrint:Line (_nLinIni+30,1900,_nLinFim-10,1900)
			
			
			
			_nNrKits := 0
			oPrint:EndPage() // Finaliza a página
		Endif
		_nromaneio := _aCartoon[_nx][1]
		nRow1 := -100
	Endif
	
	//************
	// CABECALHO
	//************
	if nRow1 == -100
		oPrint:StartPage()   // Inicia uma nova página
		nRow1 := ImpCab2(oPrint,_nx, _aCartoon)
		_nLinIni := nRow1
	Endif
	
	oPrint:Say  (nRow1+0100,0110,_aCartoon[_nx][5],ofont9)
	oPrint:Say  (nRow1+0100,0235,_aCartoon[_nx][9],ofont9)
	oPrint:Say  (nRow1+0100,0500,_aCartoon[_nx][10],ofont9)
	oPrint:Say  (nRow1+0100,0650,_aCartoon[_nx][11],ofont9)
	oPrint:Say  (nRow1+0100,0950,_aCartoon[_nx][12],ofont9)
	oPrint:Say  (nRow1+0100,1600,transform(_aCartoon[_nx][4],"9,999"),ofont9)
	oPrint:Say  (nRow1+0100,1750,_aCartoon[_nx][13],ofont9)
	_nNrKits += _aCartoon[_nx][4]
	
	oPrint:Line (nRow1+0130,0080,nRow1+0130,_nTamlin)
	nRow1 += 40
	
	if nRow1 > 1500
		_nLinFim := nRow1
		oPrint:EndPage() // Finaliza a página
		nRow1 := -100
	Endif
	
Next

nRow1 := ImpFooter(oPrint,_nNrKits)
_nLinFim := nRow1
oPrint:Line (_nLinIni+30,080,_nLinFim-10,080)
oPrint:Line (_nLinIni+30,230,_nLinFim-10,230)
oPrint:Line (_nLinIni+30,450,_nLinFim-10,450)
oPrint:Line (_nLinIni+30,700,_nLinFim-10,700)
oPrint:Line (_nLinIni+30,900,_nLinFim-10,900)
oPrint:Line (_nLinIni+30,1500,_nLinFim-10,1500)
oPrint:Line (_nLinIni+30,1700,_nLinFim-10,1700)
oPrint:Line (_nLinIni+30,1900,_nLinFim-10,1900)



_nNrKits := 0
oPrint:EndPage() // Finaliza a página

Return Nil


/*
ROTINA..................:ImpCabec3
OBJETIVO................:Cabecalho da capa do packing list
*/

Static Function ImpCabec3(oprint,_nx, _aCartoon)
Local _ny
///

oPrint:Say  (nRow1+0200,0160,"MODEL",oFont6)
oPrint:Say  (nRow1+0200,0520,"KITS",oFont6)
oPrint:Say  (nRow1+0200,0710,"PALLETS",oFont6)
oPrint:Say  (nRow1+0200,0910,"Total Kits",oFont6)
oPrint:Say  (nRow1+0200,1100,"Color",oFont6)
oPrint:Say  (nRow1+0200,1300,"Qty",oFont6)


_nw := 1
_cRomaneio := _aCartoon[_nx][1]
For _ny := _nx to len(_aCartoon)
	
	if _aCartoon[_ny][1] == _cRomaneio
		oPrint:Say  (nRow1+0200,1400+(_nw*55),str(val(_aCartoon[_ny][5]),3),oFont5)
		++_nw
	else
		exit
	Endif
	
Next

_nw--
_nTamlin := 1500+(_nw*55)+350

oPrint:Line (nRow1+0200,0080,nRow1+0200,_nTamLin)

oPrint:Say  (nRow1+0200,_nTamlin-100,"   Total",oFont5)
oPrint:Line (nRow1+0230,0080,nRow1+0230,_nTamlin)

//QUADRO AZUL
oBrush1 := TBrush():New( , 224255255)
oPrint:FillRect( {nRow1+230, 80, nRow1+470, 0480}, oBrush1 )


/////
_cModelo := _aCartoon[_nx][3]
_cTxtMod := alltrim(GETADVFVAL("SB1","B1_DESC",XFILIAL("SB1")+_aCartoon[_nx][3],1,"") )
oPrint:Say  (nRow1+0330,( (0500-0080)/2)- ( (len(_cTxtMod)/2) * 10 ),_cTxtMod,oFont6)
oPrint:Say  (nRow1+0330,0520,"120",oFont6)

_nPallets := _aCartoon[_nx][23]
_nTotPall += _nPallets
//PALLETS
oPrint:Say  (nRow1+0330,0750,alltrim(str(_nPallets)),oFont6)

//TOTAL KITS
_nQtdKits := _fQtdKits(_aCartoon[_nx][3]  ,_aCartoon)
_nQtdKits := _nQtdKits / _aCartoon[_nx][22]   // QTDKITS / QTD. ESTRUTURA
_nTotKits += _nQtdKits

oPrint:Say  (nRow1+0330,0930,alltrim(str(_nQtdKits)),oFont6)

Return(nRow1+0190)


/*
ROTINA..................:_fQtdStru
OBJETIVO................:Retorna quantidade de itens na estrutura
*/

Static Function _fQtdStru(_cCodigo)
Local _aArea := GetArea()
Local _nQtd := 0

dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xfilial("SG1")+_cCodigo)
While !eof() .and. xfilial("SG1")+_cCodigo == SG1->G1_FILIAL + SG1->G1_COD
	_nQtd++
	dbSkip()
End

RestArea(_aArea)
Return(_nQtd)

/*
ROTINA..................:_fQtdPallet
OBJETIVO................:Retorna quantidade de Pallets por modelo
*/

Static Function _fQtdPallet(_cCodigo,_aCartoon)
Local _aArea := GetArea()
Local _nQtd := 0
Local _nx , _nPos
Local _nPallet := 0
Local _aVetor := {}

_aVetor := aClone(_aCartoon)

aSort(_aVetor,,, { |x,y| y[3]+str(y[8]) > x[3]+str(x[8]) } )

_nPos := ascan(_aVetor,{|x| x[3] == _cCodigo })

For _nx := _nPos to len(_aVetor)
	
	if _aVetor[_nx][3] <> _cCodigo
		exit
	Endif
	
	if _aVetor[_nx][8] <> _nPallet
		_nQtd++
		_nPallet := _aVetor[_nx][8]
	Endif
	
Next

RestArea(_aArea)
Return(_nQtd)

/*
ROTINA..................:CriaSX1
OBJETIVO................:Criar registros no arquivo de perguntas SX1
*/
Static Function CriaSX1(_cPerg)

Local _ABrea := GetArea()
Local _aRegs := {}
Local i


_sAlias := Alias()
dbSelectArea("SX1")
SX1->(dbSetOrder(1))
_cPerg := padr(_cPerg,len(SX1->X1_GRUPO))


Aadd(_aRegs,{_cPerg,"01","Romaneio /Referencia     	?","mv_ch1","N",01,0,"C","mv_par01","","Romaneio","Referencia","","",""})
Aadd(_aRegs,{_cPerg,"02","Pesquisa     				?","mv_ch2","C",20,0,"G","mv_par02","","","","","",""})
Aadd(_aRegs,{_cPerg,"03","CUSTOMER     				?","mv_ch3","C",06,0,"G","mv_par03","SA1","","","","",""})
Aadd(_aRegs,{_cPerg,"04","LOJA	     				?","mv_ch4","C",02,0,"G","mv_par04","","","","","",""})

DbSelectArea("SX1")
SX1->(DbSetOrder(1))

For i := 1 To Len(_aRegs)
	IF  !DbSeek(_aRegs[i,1]+_aRegs[i,2])
		RecLock("SX1",.T.)
		Replace X1_GRUPO   with _aRegs[i,01]
		Replace X1_ORDEM   with _aRegs[i,02]
		Replace X1_PERGUNT with _aRegs[i,03]
		Replace X1_VARIAVL with _aRegs[i,04]
		Replace X1_TIPO      with _aRegs[i,05]
		Replace X1_TAMANHO with _aRegs[i,06]
		Replace X1_PRESEL  with _aRegs[i,07]
		Replace X1_GSC    with _aRegs[i,08]
		Replace X1_VAR01   with _aRegs[i,09]
		Replace X1_F3     with _aRegs[i,10]
		Replace X1_DEF01   with _aRegs[i,11]
		Replace X1_DEF02   with _aRegs[i,12]
		Replace X1_DEF03   with _aRegs[i,13]
		Replace X1_DEF04   with _aRegs[i,14]
		Replace X1_DEF05   with _aRegs[i,15]
		MsUnlock()
	EndIF
Next i

RestArea(_ABrea)

Return

/*
ROTINA..................:_fSubaru
OBJETIVO................:Aglutina romaneios com mesmo PA conforme estrutura
*/
Static Function _fSubaru(_aCartoon)
Local _nx
Local _aSubaru := {}
Local _cCodigo := ""

For _nx := 1 to len(_aCartoon)
	
	if _cCodigo <> _aCartoon[_nx][3]
		_nCartoon := 1
	Else
		_nCartoon += 1
	Endif
	
	_cCodigo := _aCartoon[_nx][3]
	_cNrPart := _aCartoon[_nx][10]
	
	
	_nPos := ascan(_aSubaru, {|x| x[3]+x[10] == _cCodigo+_cNrPart   })
	
	if _nPos == 0
		AADD(_aSubaru ,{_aCartoon[_nx][1],;
		_aCartoon[_nx][2],;
		_aCartoon[_nx][3],;
		_aCartoon[_nx][4],;
		str(_nCartoon,3),;
		_aCartoon[_nx][6],;
		_aCartoon[_nx][7],;
		_aCartoon[_nx][8],;
		_aCartoon[_nx][9],;
		_aCartoon[_nx][10],;
		_aCartoon[_nx][11],;
		_aCartoon[_nx][12],;
		_aCartoon[_nx][13],;
		_aCartoon[_nx][14],;
		_aCartoon[_nx][15],;
		_aCartoon[_nx][16],;
		_aCartoon[_nx][17],;
		_aCartoon[_nx][18],;
		_aCartoon[_nx][19],;
		_aCartoon[_nx][20],;
		_aCartoon[_nx][21],;
		_aCartoon[_nx][22],;
		_aCartoon[_nx][23]})
		
	Else
		
		_aSubaru[_nPos][4]	+= 	_aCartoon[_nx][4]
		_aSubaru[_nPos][6]	+= 	_aCartoon[_nx][6]
		_aSubaru[_nPos][7]	+=	_aCartoon[_nx][7]
		
	Endif
	
Next


Return(_aSubaru)



/*
ROTINA..................:_fQtdKits
OBJETIVO................:Retorna quantidade de Kits por modelo
*/

Static Function _fQtdKits(_cCodigo,_aCartoon)
Local _aArea := GetArea()
Local _nQtd := 0
Local _nx , _nPos
Local _aVetor := {}

_aVetor := aClone(_aCartoon)

aSort(_aVetor,,, { |x,y| y[3]+str(y[8]) > x[3]+str(x[8]) } )

_nPos := ascan(_aVetor,{|x| x[3] == _cCodigo })

For _nx := _nPos to len(_aVetor)
	
	if _aVetor[_nx][3] <> _cCodigo
		exit
	Endif
	
	_nQtd+= _aVetor[_nx][04]
	
Next

RestArea(_aArea)
Return(_nQtd)
