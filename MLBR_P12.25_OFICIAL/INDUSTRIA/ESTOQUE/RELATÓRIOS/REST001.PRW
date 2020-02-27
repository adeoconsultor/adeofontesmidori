#include "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREST001   บAutor  ณMarcos Zanetti GZ   บ Data ณ  23/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Itens de baixa movimentacao - Slow Moving     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Howden Ventiladores                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function REST001()

Private cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2      := "de acordo com os parametros informados pelo usuario."
Private cDesc3      := "Slow Moving"
Private titulo      := "Slow Moving - Data de Referencia" + mv_par01
Private Cabec1   	:= "                                                                                                              ____________ ULTIMO MOVIMENTO ____________"
Private Cabec2   	:= "PRODUTO         DESCRICAO                        FIL ALMOX  UM      QUANITDADE    CUSTO TOTAL    CUSTO UNIT.    DATA      TIPO         DOCUMENTO"
Private imprime     := .T.
Private aOrd        := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "REST001"
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "REST01"
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "REST001"
Private cString 	:= "SB1"
Private _aFiliais	:= {}
Private nLin		:= 80
Private nTamPag		:= 55

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณmv_par01 - Data de referencia                      ณ
//ณmv_par02 - Do Produto                              ณ
//ณmv_par03 - Ate o Produto                           ณ
//ณmv_par04 - Do Grupo                                ณ
//ณmv_par05 - Ate o Grupo                             ณ
//ณmv_par06 - Do Tipo                                 ณ
//ณmv_par07 - Ate o Tipo                              ณ
//ณmv_par08 - Do Almoxarifado                         ณ
//ณmv_par09 - Ate o Almoxarifado                      ณ
//ณmv_par10 - Da Filial                               ณ
//ณmv_par11 - Ate a Filial                            ณ
//ณmv_par12 - Considerar NF (Entrada / Saida / Ambas) ณ
//ณmv_par13 - Cons. Mov Internos (Sim/Nao)            ณ
//ณmv_par14 - Cons. Inventario (Sim/Nao)              ณ
//ณmv_par15 - Moeda do Custo (Moeda 1/2/3/4/5)        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

validperg()

pergunte(cPerg,.F.)

dbSelectArea(cString)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.T.)
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

Processa({|| REST001TRB() },"Processando dados")

RptStatus({|| REST001IMP() },Titulo)

SB2->(dbclosearea())
ChkFile("SB2")
SB2->(dbsetorder(1))

SD1->(dbclosearea())
ChkFile("SD1")
SD1->(dbsetorder(1))

SD2->(dbclosearea())
ChkFile("SD2")
SD2->(dbsetorder(1))

SD3->(dbclosearea())
ChkFile("SD3")
SD3->(dbsetorder(1))

if select("TRB")>0
	TRB->(dbclosearea())
endif

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREST001TRBบAutor  ณMarcos Zanetti GZ   บ Data ณ  23/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria arquivo de trabalho com os dados que serao impressos  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function REST001TRB()

local _cFilSB2 	:= "" // Filtro do SB2
local _cFilSD1	:= "" // Filtro do SD1
local _cFilSD2	:= "" // Filtro do SD2
local _cFilSD3	:= "" // Filtro do SD3
local _cFilSB1	:= xFilial("SB1") // Filial do SB1
local _cTESSai	:= ""
local _cTESEnt	:= ""
local _lNFE		:= mv_par12 == 1 .or. mv_par12 == 3 // Considera NF de entrada
local _lNFS		:= mv_par12 == 2 .or. mv_par12 == 3 // Considera NF de saida
local _lMI		:= mv_par13 == 1 // Considera Movimentos Internos
local _lSepLocal:= mv_par16 == 1 // Separa Locais
local _lSepFilial:= mv_par17 == 1 // Separa Filiais
local aStru		:= {}

aAdd(aStru,{"T_PRODUTO"	,"C",15,0}) // Produto
aAdd(aStru,{"T_DESC"	,"C",30,0}) // Descricao
aAdd(aStru,{"T_FILIAL"	,"C",02,0}) // Filial
aAdd(aStru,{"T_LOCAL"	,"C",02,0}) // Almoxarifado
aAdd(aStru,{"T_UM"		,"C",02,0}) // Unidade de medida
aAdd(aStru,{"T_QUANT"	,"N",17,2}) // Quantidade em estoque
aAdd(aStru,{"T_VALOR"	,"N",17,2}) // Valor em estoque
aAdd(aStru,{"T_CM"		,"N",10,2}) // Custo medio
aAdd(aStru,{"T_ULTMOV"	,"D",08,0}) // Data do ultimo movimento
aAdd(aStru,{"T_TIPOMOV"	,"C",11,0}) // Tipo do ultimo movimento
aAdd(aStru,{"T_DOCMOV"	,"C",10,0}) // Documento do ultimo movimento

dbUseArea(.T.,,CriaTrab(aStru,.T.),"TRB",.T.)
IndRegua("TRB",CriaTrab(NIL,.F.),"T_PRODUTO" + iif(_lSepFilial," + T_FILIAL","") + iif(_lSepLocal," + T_LOCAL",""),,,"Selecionando Registros...")

SF4->(dbgotop())
while SF4->(!eof()) // Monta variaveis com os TES q movimentam estoques
	if SF4->F4_ESTOQUE == "S"
		if SF4->F4_TIPO == "S"
			_cTESSai += SF4->F4_CODIGO + "#"
		else
			_cTESEnt += SF4->F4_CODIGO + "#"
		endif
	endif
	SF4->(dbskip())
enddo

/*
IndRegua("SB2",CriaTrab(NIL,.F.),"B2_COD" + iif(_lSepFilial," + B2_FILIAL","") + iif(_lSepLocal," + B2_LOCAL","") , , _cFilSB2 ,"Selecionando Registros...")
_cFilSB2 := " B2_COD    >= '" + mv_par02 + "' .and. B2_COD    <= '" + mv_par03 + "' .and. "
_cFilSB2 += " B2_LOCAL  >= '" + mv_par08 + "' .and. B2_LOCAL  <= '" + mv_par09 + "' .and. "
_cFilSB2 += " B2_FILIAL >= '" + mv_par10 + "' .and. B2_FILIAL <= '" + mv_par11 + "' .and. "
_cFilSB2 += " B2_QATU   > 0"
*/

_aStrSB2 := SB2->(dbstruct())
SB2->(dbclosearea())
_cQrySB2 := " SELECT * FROM " + RetSQLName("SB2")
_cQrySB2 += " WHERE D_E_L_E_T_ = ' '"
_cQrySB2 += " AND B2_COD    BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "'"
_cQrySB2 += " AND B2_LOCAL  BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
_cQrySB2 += " AND B2_FILIAL BETWEEN '" + mv_par10 + "' AND '" + mv_par11 + "'"
_cQrySB2 += " AND B2_QATU > 0 "
_cQrySB2 += " ORDER BY B2_COD" + iif(_lSepFilial,", B2_FILIAL","") + iif(_lSepLocal,", B2_LOCAL","")
TcQuery _cQrySB2 New Alias "SB2"
aEval(_aStrSB2, {|e| If(e[2] != "C", TCSetField("SB2", e[1], e[2],e[3],e[4]),Nil)})

if _lNFE // Considera NFE
	/*
	_cFilSD1 := " D1_COD    >= '" + mv_par02 + "' .and. D1_COD    <= '" + mv_par03 + "' .and. "
	_cFilSD1 += " D1_LOCAL  >= '" + mv_par08 + "' .and. D1_LOCAL  <= '" + mv_par09 + "' .and. "
	_cFilSD1 += " D1_FILIAL >= '" + mv_par10 + "' .and. D1_FILIAL <= '" + mv_par11 + "' .and. "
	_cFilSD1 += " D1_QUANT  > 0 .and. D1_TES $ '" + _cTESEnt + "'"
	IndRegua("SD1",CriaTrab(NIL,.F.),"D1_COD" + iif(_lSepFilial," + D1_FILIAL","") + iif(_lSepLocal," + D1_LOCAL","") + " + DESCEND(DTOS(D1_DTDIGIT))" , , _cFilSD1 ,"Selecionando Registros...")
	*/
	
	_aStrSD1 := SD1->(dbstruct())
	SD1->(dbclosearea())
	_cQrySD1 := " SELECT * FROM " + RetSQLName("SD1")
	_cQrySD1 += " WHERE D_E_L_E_T_ = ' '"
	_cQrySD1 += " AND D1_COD    BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "'"
	_cQrySD1 += " AND D1_LOCAL  BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
	_cQrySD1 += " AND D1_FILIAL BETWEEN '" + mv_par10 + "' AND '" + mv_par11 + "'"
	_cQrySD1 += " AND D1_QUANT > 0 AND D1_TES <> ' ' AND D1_TES IN " + FormatIN(_cTESEnt,"#")
	_cQrySD1 += " ORDER BY D1_COD ASC" + iif(_lSepFilial,", D1_FILIAL ASC","") + iif(_lSepLocal,", D1_LOCAL ASC","")+ ", D1_DTDIGIT DESC"
	TcQuery _cQrySD1 New Alias "QRYSD1"
	aEval(_aStrSD1, {|e| If(e[2] != "C", TCSetField("QRYSD1", e[1], e[2],e[3],e[4]),Nil)})
	_cArq := Criatrab(NIL,.F.)
	dbselectarea("QRYSD1")
	copy to &(_cArq)
	QRYSD1->(dbclosearea())
	dbUseArea(.T.,,_cArq,"SD1",.T.)
	IndRegua("SD1",CriaTrab(NIL,.F.),"D1_COD" + iif(_lSepFilial," + D1_FILIAL","") + iif(_lSepLocal," + D1_LOCAL","") + " + DESCEND(DTOS(D1_DTDIGIT))" , , ,"Selecionando Registros...")
	
endif

if _lNFS // Considera NFS
	/*
	_cFilSD2 := " D2_COD    >= '" + mv_par02 + "' .and. D2_COD    <= '" + mv_par03 + "' .and. "
	_cFilSD2 += " D2_LOCAL  >= '" + mv_par08 + "' .and. D2_LOCAL  <= '" + mv_par09 + "' .and. "
	_cFilSD2 += " D2_FILIAL >= '" + mv_par10 + "' .and. D2_FILIAL <= '" + mv_par11 + "' .and. "
	_cFilSD2 += " D2_QUANT  > 0 .and. D2_TES $ '" + _cTESSai + "'"
	IndRegua("SD2",CriaTrab(NIL,.F.),"D2_COD" + iif(_lSepFilial," + B2_FILIAL","") + iif(_lSepLocal," + B2_LOCAL","") + "+ DESCEND(DTOS(D2_EMISSAO))" , , _cFilSD2 ,"Selecionando Registros...")
	*/
	
	_aStrSD2 := SD2->(dbstruct())
	SD2->(dbclosearea())
	_cQrySD2 := " SELECT * FROM " + RetSQLName("SD2")
	_cQrySD2 += " WHERE D_E_L_E_T_ = ' '"
	_cQrySD2 += " AND D2_COD    BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "'"
	_cQrySD2 += " AND D2_LOCAL  BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
	_cQrySD2 += " AND D2_FILIAL BETWEEN '" + mv_par10 + "' AND '" + mv_par11 + "'"
	_cQrySD2 += " AND D2_QUANT > 0 AND D2_TES <> ' ' AND D2_TES IN " + FormatIN(_cTESEnt,"#")
	_cQrySD2 += " ORDER BY D2_COD ASC" + iif(_lSepFilial,", D2_FILIAL ASC","") + iif(_lSepLocal,", D2_LOCAL ASC","")+ ", D2_EMISSAO DESC"
	TcQuery _cQrySD2 New Alias "QRYSD2"
	aEval(_aStrSD2, {|e| If(e[2] != "C", TCSetField("QRYSD2", e[1], e[2],e[3],e[4]),Nil)})
	_cArq := Criatrab(NIL,.F.)
	dbselectarea("QRYSD2")
	copy to &(_cArq)
	QRYSD2->(dbclosearea())
	dbUseArea(.T.,,_cArq,"SD2",.T.)
	IndRegua("SD2",CriaTrab(NIL,.F.),"D2_COD" + iif(_lSepFilial," + D2_FILIAL","") + iif(_lSepLocal," + D2_LOCAL","") + "+ DESCEND(DTOS(D2_EMISSAO))" , , ,"Selecionando Registros...")
	
endif

if _lMI // Se considera movimentos internos
	/*
	_cFilSD3 := " D3_COD    >= '" + mv_par02 + "' .and. D3_COD    <= '" + mv_par03 + "' .and. "
	_cFilSD3 += " D3_LOCAL  >= '" + mv_par08 + "' .and. D3_LOCAL  <= '" + mv_par09 + "' .and. "
	_cFilSD3 += " D3_FILIAL >= '" + mv_par10 + "' .and. D3_FILIAL <= '" + mv_par11 + "' .and. "
	_cFilSD3 += " D3_QUANT  > 0 "
	if mv_par14 == 2 // Nao considera movimentos internos de inventario
	_cFilSD3 += " .and. D3_DOC <> 'INVENT' "
	endif
	IndRegua("SD3",CriaTrab(NIL,.F.),"D3_COD" + iif(_lSepFilial," + D3_FILIAL","") + iif(_lSepLocal," + D3_LOCAL","") + "+ DESCEND(DTOS(D3_EMISSAO))" , , _cFilSD3 ,"Selecionando Registros...")
	*/
	
	_aStrSD3 := SD3->(dbstruct())
	SD3->(dbclosearea())
	_cQrySD3 := " SELECT * FROM " + RetSQLName("SD2")
	_cQrySD3 += " WHERE D_E_L_E_T_ = ' '"
	_cQrySD3 += " AND D3_COD    BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "'"
	_cQrySD3 += " AND D3_LOCAL  BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
	_cQrySD3 += " AND D3_FILIAL BETWEEN '" + mv_par10 + "' AND '" + mv_par11 + "'"
	_cQrySD3 += " AND D3_QUANT > 0"
	if mv_par14 == 2 // Nao considera movimentos internos de inventario
		_cQrySD3 += " AND D3_DOC <> 'INVENT' "
	endif
	_cQrySD3 += " ORDER BY D3_COD ASC" + iif(_lSepFilial,", D3_FILIAL ASC","") + iif(_lSepLocal,", D3_LOCAL ASC","")+ ", D3_EMISSAO DESC"
	TcQuery _cQrySD3 New Alias "QRYSD3"
	aEval(_aStrSD3, {|e| If(e[2] != "C", TCSetField("QRYSD3", e[1], e[2],e[3],e[4]),Nil)})
	_cArq := Criatrab(NIL,.F.)
	dbselectarea("QRYSD3")
	copy to &(_cArq)
	QRYSD3->(dbclosearea())
	dbUseArea(.T.,,_cArq,"SD3",.T.)
	IndRegua("SD3",CriaTrab(NIL,.F.),"D3_COD" + iif(_lSepFilial," + D3_FILIAL","") + iif(_lSepLocal," + D3_LOCAL","") + "+ DESCEND(DTOS(D3_EMISSAO))" , , _cFilSD3 ,"Selecionando Registros...")
	
endif

// Prepara os arquivos na ordem ideal para geracao do relatorio
SB1->(dbSetOrder(1))	// B1_FILIAL + B1_COD
SF4->(dbsetorder(1))   // F4_FILIAL + F4_CODIGO

ProcRegua(SB2->(RecCount()))

SB2->(dbgotop())

while SB2->(!eof())
	
	if SB1->(dbseek(_cFilSB1+SB2->B2_COD))
		if 	SB1->B1_GRUPO < mv_par04 .or. SB1->B1_GRUPO > mv_par05 .or. ;
			SB1->B1_TIPO < mv_par06 .or. SB1->B1_TIPO > mv_par07
			
			SB2->(dbskip())
			IncProc()
			loop
			
		endif
	else
		SB2->(dbskip())
		IncProc()
		loop
	endif
	
	_dUltMov	:= ctod("  /  /  ")
	_cTipoMov	:= ""
	_cDocMov	:= ""
	
	// Checa movimentos de NF de entrada
	if _lNFE .and. SD1->(dbseek(SB2->B2_COD + iif(_lSepFilial,SB2->B2_FILIAL,"") + iif(_lSepLocal,SB2->B2_LOCAL,"")))
		// Ultimo movimento com data anterior a data de referencia
		if SD1->D1_DTDIGIT <= mv_par01
			if (empty(_dUltMov) .or. SD1->D1_DTDIGIT >= _dUltMov)
				_dUltMov	:= SD1->D1_DTDIGIT
				_cTipoMov	:= "NF Entrada"
				_cDocMov	:= SD1->D1_DOC + "/" + SD1->D1_SERIE
			endif
		else // Movimento com data posterior a data de referencia
			SB2->(dbskip())
			IncProc()
			loop
		endif
		
	endif
	
	// Checa movimentos de NF de Saida
	if _lNFS .and. SD2->(dbseek(SB2->B2_COD + iif(_lSepFilial,SB2->B2_FILIAL,"") + iif(_lSepLocal,SB2->B2_LOCAL,"")))
		
		// Ultimo movimento com data anterior a data de referencia
		if SD2->D2_EMISSAO <= mv_par01
			if (empty(_dUltMov) .or. SD2->D2_EMISSAO >= _dUltMov)
				_dUltMov	:= SD2->D2_EMISSAO
				_cTipoMov	:= "NF Saํda"
				_cDocMov	:= SD2->D2_DOC + "/" + SD2->D2_SERIE
			endif
		else // Movimento com data posterior a data de referencia
			SB2->(dbskip())
			IncProc()
			loop
		endif
		
	endif
	
	// Checa movimentos internos
	if _lMI .and. SD3->(dbseek(SB2->B2_COD + iif(_lSepFilial,SB2->B2_FILIAL,"") + iif(_lSepLocal,SB2->B2_LOCAL,"")))
		
		// Ultimo movimento com data anterior a data de referencia
		if SD3->D3_EMISSAO <= mv_par01
			if (empty(_dUltMov) .or. SD3->D3_EMISSAO >= _dUltMov)
				_dUltMov	:= SD3->D3_EMISSAO
				_cTipoMov	:= "Mov Interno"
				_cDocMov	:= SD3->D3_DOC + "/" + SD3->D3_CF
			endif
		else // Movimento com data posterior a data de referencia
			SB2->(dbskip())
			IncProc()
			loop
		endif
		
	endif
	
	RecLock("TRB",.T.)
	TRB->T_PRODUTO	:= SB1->B1_COD
	TRB->T_DESC		:= SB1->B1_DESC
	TRB->T_FILIAL	:= iif(_lSepFilial,SB2->B2_FILIAL,"**")
	TRB->T_LOCAL	:= iif(_lSepLocal,SB2->B2_LOCAL,"**")
	TRB->T_UM		:= SB1->B1_UM
	TRB->T_QUANT	:= SB2->B2_QATU
	TRB->T_VALOR	:= xMoeda(SB2->B2_VATU1 , 1, mv_par15, , dDataBase)
	TRB->T_CM		:= TRB->T_VALOR / TRB->T_QUANT
	TRB->T_ULTMOV	:= _dUltMov
	TRB->T_TIPOMOV	:= _cTipoMov
	TRB->T_DOCMOV	:= _cDocMov
	MsUnlock()
	
	SB2->(dbskip())
	IncProc()
	
enddo

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREST001IMPบAutor  ณMarcos Zanetti GZ   บ Data ณ  23/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime os dados gerados                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function REST001IMP()
local _nCusto := 0

SetRegua(TRB->(Reccount()))

TRB->(dbgotop())

while TRB->(!eof())
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	VerifPag()
	
	@ nLin ,000 psay TRB->T_PRODUTO
	@ nLin ,016 psay TRB->T_DESC
	@ nLin ,050 psay TRB->T_FILIAL
	@ nLin ,055 psay TRB->T_LOCAL
	@ nLin ,060 psay TRB->T_UM
	@ nLin ,065 psay TRB->T_QUANT 	picture "@E 99,999,999.99"
	@ nLin ,080 psay TRB->T_VALOR 	picture "@E 99,999,999.99"
	@ nLin ,095 psay TRB->T_CM 		picture "@E 99,999,999.99"
	@ nLin ,110 psay TRB->T_ULTMOV
	@ nLin ,122 psay TRB->T_TIPOMOV
	@ nLin ,135 psay TRB->T_DOCMOV
	nLin++
	_nCusto += TRB->T_VALOR
	
	TRB->(dbskip())
	
	IncRegua()
	
enddo

nLin++
@ nLin ,000 psay "TOTAL GERAL -->"
@ nLin ,080 psay _nCusto	picture "@E 99,999,999.99"

Roda(0,"",Tamanho)

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ VERIFPAG บ Autor ณ AP5 IDE            บ Data ณ  19/04/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a necessidade de quebra de pagina                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
static function VerifPag()

If nLin > nTamPag
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := prow()+1
Endif

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณMarcos Zanetti GZ   บ Data ณ  23/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria as perguntas do SX1                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function VALIDPERG()

// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,;
// cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSX1(cPerg,"01","Data de referencia"	,"Data de referencia"	,"Data de referencia"	,"mv_ch1","D",08,0,0,"G","","SC2"	,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Do Produto"			,"Do Produto"			,"Do Produto"			,"mv_ch2","C",15,0,0,"G","","SB1"	,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Ate o Produto"		,"Ate o Produto"		,"Ate o Produto"		,"mv_ch3","C",15,0,0,"G","","SB1"	,"",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Do Grupo"			,"Do Grupo"				,"Do Grupo"				,"mv_ch4","C",04,0,0,"G","","SBM"	,"",,"mv_par04","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Ate o Grupo"			,"Ate o Grupo"			,"Ate o Grupo"			,"mv_ch5","C",04,0,0,"G","","SBM"	,"",,"mv_par05","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"06","Do Tipo"				,"Do Tipo"				,"Do Tipo"				,"mv_ch6","C",02,0,0,"G","","02"	,"",,"mv_par06","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"07","Ate o Tipo"	   		,"Ate o Tipo"			,"Ate o Tipo"			,"mv_ch7","C",02,0,0,"G","","02"	,"",,"mv_par07","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"08","Do Almoxarifado"		,"Do Almoxarifado"		,"Do Almoxarifado"		,"mv_ch8","C",02,0,0,"G","",""		,"",,"mv_par08","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"09","Ate o Almoxarifado"	,"Ate o Almoxarifado"	,"Ate o Almoxarifado"	,"mv_ch9","C",02,0,0,"G","",""		,"",,"mv_par09","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"10","Da Filial"			,"Da Filial"			,"Da Filial"			,"mv_chA","C",02,0,0,"G","",""		,"",,"mv_par10","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"11","Ate a Filial"		,"Ate a Filial"			,"Ate a Filial"			,"mv_chB","C",02,0,0,"G","",""		,"",,"mv_par11","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"12","Considerar NF"		,"Considerar NF"		,"Considerar NF"	 	,"mv_chC","N",01,0,0,"C","",""		,"",,"mv_par12","Entrada","","","","Saida","","","Ambas","","","","","","","","")
PutSX1(cPerg,"13","Cons. Mov Internos"  ,"Cons. Mov Internos"	,"Cons. Mov Internos"	,"mv_chD","N",01,0,0,"C","",""		,"",,"mv_par13","Sim","","","","Nao","","","","","","","","","","","")
PutSX1(cPerg,"14","Cons. Inventario"	,"Cons. Inventario"		,"Cons. Inventario"		,"mv_chE","N",01,0,0,"C","",""		,"",,"mv_par14","Sim","","","","Nao","","","","","","","","","","","")
PutSX1(cPerg,"15","Moeda do Custo"		,"Moeda do Custo"		,"Moeda do Custo"		,"mv_chF","N",01,0,0,"C","",""		,"",,"mv_par15","Moeda 1","","","","Moeda 2","","","Moeda 3","","","Moeda 4","","","Moeda 5","","")
PutSX1(cPerg,"16","Separa por armazem"	,"Separa por armazem"	,"Separa por armazem"	,"mv_chG","N",01,0,0,"C","",""		,"",,"mv_par16","Sim","","","","Nao","","","","","","","","","","","")
PutSX1(cPerg,"17","Separa por filial"	,"Separa por filial"	,"Separa por filial"	,"mv_chH","N",01,0,0,"C","",""		,"",,"mv_par17","Sim","","","","Nao","","","","","","","","","","","")
return