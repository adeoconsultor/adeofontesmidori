USER Function MDETIQ()

Local cEtiqueta := "1"
Local _nNrCaixa := 0
Local _aEtiq := {}
Local _nCaixas := 0
Local _nx

MSCBPRINTER("S4M","LPT1",NIL ,NIL,.f.,NIL,NIL,NIL,256000 )

//MSCBPRINTER("S600","LPT1", ,,.f. )
MSCBCHKStatus(.F.)

If MsgYesNo("A impressora esta pronta?")
	
	if ZZC->ZZC_PRADO <> "S"
		
		dbSelectArea("ZZD")
		dbSetOrder(1)
		dbSeek(xfilial("ZZD")+ZZC->ZZC_NRROM)
		
		While ! eof("ZZD") .AND. xfilial("ZZD")+ZZC->ZZC_NRROM == ZZD->ZZD_FILIAL + ZZD->ZZD_NRROM
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xfilial("SB1")+ZZD->ZZD_CODIGO)
			
			_fImpEtiq("10")
			
			dbSelectArea("ZZD")
			dbSkip()
		End
		
	Else
		
		if ZZC->ZZC_COR == "MAC"
			
			
			
			
		Else //PRADO
			
			_cPA := ZZC->ZZC_COD_I
			_nTotPallet := 0
			
			dbSelectArea("EEC")
			dbSetOrder(14)
			dbSeek(xfilial("EEC")+ZZC->ZZC_PEDIDO)
			
			dbSelectArea("ZZD")
			dbSetOrder(1)
			dbSeek(xfilial("ZZD")+ZZC->ZZC_NRROM)
			While ! eof("ZZD") .AND. xfilial("ZZD")+ZZC->ZZC_NRROM == ZZD->ZZD_FILIAL + ZZD->ZZD_NRROM
				
				if ! empty(ZZD_EXTRA)
					_cPA := ZZD_EXTRA
				Endif
				
				_cXBackn 	:= GETADVFVAL("SB1","B1_XBACKN",XFILIAL("SB1")+ZZD->ZZD_CODIGO,1,"")
				_cModeloCor := alltrim(GETADVFVAL("SYC","YC_NOME",XFILIAL("SB1")+SB1->B1_FPCOD,1,""))
				_nCaixas := _fQtdCaixas(_cPA)
				
				_nPos := ascan(_aEtiq , {|x| x[1]+x[8] == ZZC->ZZC_NRROM+ZZD->ZZD_NRCX })
				if _nPos == 0
					//                         1 	       2             3     4         5             6       7       8          9                   10            11             12            13
					aadd(_aEtiq , {ZZC->ZZC_NRROM, ZZD_NRPART, ZZD->ZZD_DESC, "", _cModeloCor, ZZD->ZZD_QTDE, 0 ,ZZD->ZZD_NRCX, ZZD->ZZD_SERIAL , _cXBackn, EEC->EEC_DTEMBA , _nCaixas , ZZD->ZZD_CODIGO}   )
				Else
					_aEtiq[_nPos][4] := ZZD->ZZD_DESC  //DESC COMPONENTE 2
					_aEtiq[_nPos][7] := ZZD_QTDE      // QTDE COMPONENTE 2
				ENDIF
				_nTotPallet += ZZD->ZZD_QTDE
				
				dbSelectArea("ZZD")
				dbSkip()
				
			End
			
			_nTotPallet /= _fQtdEstru(_cPA)
			
			For _nx := 1 to len(_aEtiq)
				
				_nNrCaixa := _fCxEstru(_cPA,_aEtiq[_nx][13])
				if   _nNrCaixa == 1
					_fImpEtiq("21",_aEtiq[_nx],_nNrCaixa)
				Else
					_fImpEtiq("22",_aEtiq[_nx],_nNrCaixa)
				Endif
			Next
			_fImpEtiq("20",_aEtiq[1])
			
		Endif
		
	Endif
	
	MSCBCLOSEPRINTER()
	MS_FLUSH()
Endif

Return

//Impressao etiqueta ZEBRA
//-----------------------


Static Functio _fImpEtiq(cEtiqueta,_aEtiq,_nNrCaixa)

If "10"$cEtiqueta
	
	
	MSCBBEGIN(1,5)
	
	cTipo:="0"
	
	MSCBSay(005,170,"COMPONENT"					,"B",cTipo,"25,20")// NO LUGAR
	MSCBSay(009,178,"(C)"						,"B",cTipo,"20,20")// NO LUGAR
	
	cTexto := alltrim(ZZD->ZZD_NRPART		)
	MSCBSayBar(000,090, cTexto 					,"B","C",012,.F.,.F.,.F.,,2,1.1)       // NO LUGAR
	MSCBSay(013,115,cTexto						,"B",cTipo,"30,30") // NO LUGAR
	
	MSCBSay(001,035,"DESCRIPTION"			,"B",cTipo,"15,15")	// NO LUGAR
	//	MSCBSay(007,065,"O9M ACURA	TL"				,"B",cTipo,"32,30")	// NO LUGAR
	MSCBSay(007,015,alltrim(ZZD->ZZD_DESC)		,"B",cTipo,"32,30") // NO LUGAR
	
	_cModeloCor := alltrim(GETADVFVAL("SYC","YC_NOME",XFILIAL("SB1")+SB1->B1_FPCOD,1,""))
	MSCBSay(013,015,_cModeloCor					,"B",cTipo,"30,30")
	
	MSCBLineV(19,05,190,3,"B")
	
	MSCBSay(022,170,"QUANTITY"			,"B",cTipo,"25,25")
	MSCBSay(027,175,"(Q)"				,"B",cTipo,"20,20")
	
	cTexto := ALLTRIM(STR(ZZD->ZZD_QTDE))
	MSCBSayBar(022,120, "Q"+cTexto 			,"B","C",012,.F.,.F.,.F.,"B",2.6,1.1)
	MSCBSay(037,140,cTexto				,"B",cTipo,"35,35")
	
	MSCBSay(024,100,"SERIAL"			,"B",cTipo,"20,20")
	MSCBSay(030,105,"(S)  "				,"B",cTipo,"20,20")
	
	cTexto := alltrim(ZZD->ZZD_SERIAL)
	MSCBSayBar(022,15, cTexto 			,"B","C",012,.F.,.F.,.F.,,2.6,1.1)
	MSCBSay(037,30,cTexto				,"B",cTipo,"35,35")
	
	MSCBLineV(44,05,190,3,"B")
	
	MSCBSay(047,170,"SUPPLIER#"			,"B",cTipo,"25,25")
	MSCBSay(051,175,"(V)"				,"B",cTipo,"20,20")
	
	MSCBSay(047,100,"JOB .(NO)"			,"B",cTipo,"20,20")
	
	cTexto := alltrim(str(val(ZZD->ZZD_NRCX)))
	MSCBSayBar(047,130, cTexto 			,"B","C",010,.F.,.F.,.F.,,3,2)
	MSCBSay(053,100,cTexto		   		,"B",cTipo,"45,45")
	
	MSCBSay(047,075,"PACKER#"			,"B",cTipo,"20,20")
	MSCBSay(053,080,"1"			   		,"B",cTipo,"25,20")
	
	MSCBSay(047,030,"DATE - TIMEPACKING","B",cTipo,"20,20")
	MSCBSay(053,035,dtoc(dDataBase)		,"B",cTipo,"30,30")
	
	MSCBEND()
	
	
Endif

If cEtiqueta$"20.21.22"        //PRADO  -  20-PALLET  / 21- 1A. CAIXA / 22 - DEMAIS CAIXAS
	
	MSCBBEGIN(1,5)
	
	cTipo:="0"
	
	MSCBSay(008,185,"PART NO."			,"B",cTipo,"25,25")     //
	MSCBSay(013,193,"(P)"				,"B",cTipo,"25,25")     //
	
	//ZZD_NRPART
	cTexto := _aEtiq[2]
	
	if cEtiqueta$"20.21"
		MSCBSay(005,135,cTexto				,"B",cTipo,"30,30")    //
		MSCBSayBar(010,128, cTexto 			,"B","3",10,.F.,.F.,.F.,,2,10,.f.,.t.)  //
	Elseif cEtiqueta == "22"
		MSCBSay(005,120,cTexto				,"B",cTipo,"80,60")    //
	Endif
	
	//ZZD_DESC
	_cTexto := substr(_aEtiq[2],8,4)
	if cEtiqueta == "20"  //ETIQUETA TOTAL PALLET
		MSCBSay(005,38,_cTexto	,"B",cTipo,"130,180")   //
	Else
		
		MSCBSay(010,90,_cTexto		,"B",cTipo,"80,60")   //
		
		_cCaixaNde := alltrim(str(_nNrCaixa))+"/"+alltrim(str(_aEtiq[12]))
		MSCBSay(010,80,_cCaixaNde	,"B",cTipo,"40,40")   //
		
		MSCBSay(003,05,_aEtiq[3]	,"B",cTipo,"50,25")   //
		MSCBSay(012,05,_aEtiq[4]	,"B",cTipo,"50,25")   //
	Endif
	
	MSCBLineV(21,05,205,3,"B")
	
	MSCBSay(023,185,"QUANTITY"			,"B",cTipo,"25,25")
	MSCBSay(028,193,"(Q)"				,"B",cTipo,"25,25")
	
	
	if cEtiqueta == "20"
		cTexto := alltrim(str(_nTotPallet))  //TOTAL DO PALLET
	Else
		cTexto := alltrim(str(_aEtiq[6]))  //KITS POR CAIXA
	Endif
	
	if cEtiqueta$"20.21"
		MSCBSay(022,165,cTexto				,"B",cTipo,"30,30")
		MSCBSayBar(026,157, cTexto 			,"B","3",8,.F.,.F.,.F.,,2,10,.f.,.t.)
	Elseif cEtiqueta == "22"  //SEM CODIGO DE BARRAS COM LETRAS MAIORES
		MSCBSay(023,165,cTexto				,"B",cTipo,"60,70")
	Endif
	
	MSCBLineV(35,100,205,3,"B")
	MSCBLineH(21,100,70,3,"B")
	
	MSCBSay(023,125,"PLANT CODE"		,"B",cTipo,"18,20")
	MSCBSay(028,125,"97364"				,"B",cTipo,"40,35")
	MSCBLineH(21,150,35,3,"B")
	
	MSCBSay(038,172,"SUPLIER CODE"			,"B",cTipo,"15,30")
	MSCBSay(043,193,"(V)"				,"B",cTipo,"25,25")
	
	cTexto := "20700 "
	
	if cEtiqueta$"20.21"
		MSCBSay(037,140,cTexto				,"B",cTipo,"25,30")
		MSCBSayBar(041,128, cTexto 			,"B","3",7,.F.,.f.,.F.,,2.2,,.f.,.t.)
	Elseif cEtiqueta == "22"
		MSCBSay(039,130,cTexto				,"B",cTipo,"60,70")
	Endif
	
	
	MSCBSay(054,168,"SERIAL NUMBER"			,"B",cTipo,"15,30")
	cTexto := _aEtiq[9]  //ZZD_SERIAL
	
	if cEtiqueta$"20.21"
		MSCBSay(051,130,cTexto				,"B",cTipo,"35,35")
		MSCBSayBar(056,115, cTexto 			,"B","3",8,.F.,.F.,.F.,,2.2,,.f.,.t.)
	Elseif cEtiqueta == "22"
		MSCBSay(054,120,cTexto				,"B",cTipo,"50,60")
	Endif
	
	
	
	MSCBSay(023,78,"BACK NUMBER "		,"B",cTipo,"20,20")
	
	cTexto := _aEtiq[10] //SB1->B1_XBACKN
	
	if cEtiqueta$"20.21"
		MSCBSay(023,40,cTexto				,"B",cTipo,"150,100")
		MSCBSay(023,12,cTexto				,"B",cTipo,"30,30")
		MSCBSayBar(27,05, cTexto 			,"B","3",8,.F.,.F.,.F.,,2.2,,.f.,.t.)
	Elseif cEtiqueta == "22"
		MSCBSay(023,20,cTexto				,"B",cTipo,"130,130")
	Endif
	
	MSCBLineV(42,05,100,3,"B")
	
	MSCBSay(44,76,"LOAD TYPE"				,"B",cTipo,"20,30")
	MSCBSay(44,30,"ML"						,"B",cTipo,"30,25")
	
	MSCBLineV(49,05,205,3,"B")
	
	MSCBSay(51,52,"CONTRATC ASSEMBLER CODE"	,"B",cTipo,"22,22")
	MSCBSay(51,35,"7364"					,"B",cTipo,"35,45")
	
	MSCBLineV(56,05,100,3,"B")
	
	MSCBSay(60,66,"MFG/SHIP DATE"			,"B",cTipo,"20,30")
	MSCBSay(59,30,dtoc(_aEtiq[11])			,"B",cTipo,"35,45")
	
	MSCBEND()
	
Endif

If "30"$cEtiqueta  //MAC
	
	
	MSCBBEGIN(1,5)
	
	cTipo:="0"
	
	
	MSCBSay(003,60,"MAC 148"							,"B",cTipo,"60,120")     //
	MSCBSay(020,030,"A500S-JB047-9000 /"+"30"+"PCS"		,"B",cTipo,"100,80")     //
	MSCBLineV(44,05,205,3,"B")
	
	MSCBSay(046,160,"PS 34-51"		,"B",cTipo,"40,50")     //
	MSCBSay(048,110,"BLACK"			,"B",cTipo,"40,50")     //
	MSCBSay(048,090,"1"				,"B",cTipo,"40,50")     //
	
	SET CENTURY ON
	MSCBSay(048,20,dtoc(dDataBase)		,"B",cTipo,"40,50")     //
	SET CENTURY OFF
	
	MSCBEND()
	
Endif


return

// Retorna numero de caixa com base no romaneio padrao PRADO
// ........................................................
Static Function _fQtdCaixas(_cProdutoPA)
Local _aArea := GetArea()
Local _nCaixas := 0
Local _cNrCx := ""
Local _cRomaneio := ""

dbSelectArea("ZZD")
dbSetOrder(3) //ZZD_FILIAL+ZZD_COD_I+ZZD_REF
dbSeek(xfilial("ZZD")+_cProdutoPA+"ESTRUTURA")

_cRomaneio := ZZD->ZZD_NRROM

dbSetOrder(1)
dbSeek(xfilial("ZZD")+_cRomaneio)

While ! eof() .and. xfilial("ZZD")+_cRomaneio == ZZD->ZZD_FILIAL+ZZD->ZZD_NRROM
	
	if _cNrCx <> ZZD->ZZD_NRCX
		++_nCaixas
		_cNrCx := ZZD->ZZD_NRCX
	Endif
	
	dbSkip()
	
End

RestArea(_aArea)
Return(_nCaixas)

// Retorna numero de caixa com base no romaneio padrao PRADO
// ........................................................
Static Function _fQtdEstru(_cProdutoPA)
Local _aArea := GetArea()
Local _nComp := 0
Local _cRomaneio := ""

dbSelectArea("ZZD")
dbSetOrder(3) //ZZD_FILIAL+ZZD_COD_I+ZZD_REF
dbSeek(xfilial("ZZD")+_cProdutoPA+"ESTRUTURA")
_cRomaneio := ZZD->ZZD_NRROM

dbSetOrder(1)
dbSeek(xfilial("ZZD")+_cRomaneio)

While ! eof() .and. xfilial("ZZD")+_cRomaneio == ZZD->ZZD_FILIAL+ZZD->ZZD_NRROM
	
	++_nComp
	
	dbSkip()
	
End

RestArea(_aArea)
Return(_nComp)

//Retorna se eh primeira caixa da estrutura do romaneio padrao
//-------------------------------------------------------------
Static Function _fCxEstru(_cProdutoPA,_cCompo)

Local _aArea := GetArea()
Local _nCaixa := 0
Local _cRomaneio := ""

dbSelectArea("ZZD")
dbSetOrder(3) //ZZD_FILIAL+ZZD_COD_I+ZZD_REF
dbSeek(xfilial("ZZD")+_cProdutoPA+"ESTRUTURA")
_cRomaneio := ZZD->ZZD_NRROM

dbSetOrder(1)
dbSeek(xfilial("ZZD")+_cRomaneio)
While ! eof() .and. xfilial("ZZD")+_cRomaneio == ZZD->ZZD_FILIAL+ZZD->ZZD_NRROM
	
	if ZZD->ZZD_CODIGO == _cCompo
		_nCaixa := val(ZZD->ZZD_NRCX    )
		exit
	Endif
	
	dbSkip()
	
End

RestArea(_aArea)
Return(_nCaixa)
