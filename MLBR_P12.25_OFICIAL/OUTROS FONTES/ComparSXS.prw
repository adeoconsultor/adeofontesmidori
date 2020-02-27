#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออหอออออออออออหออออออหอออออออออออออออออออออหออออออหออออออออออออปฑฑ
ฑฑบRotina    บ ComparSXS บAutor บ Paulo R. Trivellato บ Data บ 27/07/2009 บฑฑ
ฑฑฬออออออออออฮอออออออออออสออออออสอออออออออออออออออออออสออออออสออออออออออออนฑฑ
ฑฑบDescricao บ Rotina para fazer a comparacao entre arquivos SX           บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑฬออออออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       บ Protheus10                                                 บฑฑ
ฑฑศออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ComparSXS()

Local   _aSay    := {}
Local   _aButton := {}
Local   _nOpc    := 0
Local   _cTitulo := "COMPARAวรO DE ARQUIVOS DA FAMอLIA SX"
Local   _cDesc1  := "Esta rotina  tem como fun็ใo fazer  a compara็ใo  de arquivos  da famํlia SX  entre si, "
Local   _cDesc2  := "identificando diferen็as entre eles."
Local   _cDesc3  := ""
Local   _cDesc4  := "Todos os arquivos que forem selecionados serใo comparados entre si. (De 2 a N)"
Local   _cDesc5  := ""
Local   _cDesc6  := "Todos os arquivos que come็arem com o Prefixo SX?, aparecerใo na lista de arquivos"
Local   _cDesc7  := "a comparar."
Local   _cVar    := NIL
Local   _oDlgLB  := NIL
Local   _oOk     := LoadBitmap( GetResources(), "LBOK" )
Local   _oNo     := LoadBitmap( GetResources(), "LBNO" )
Local   _oChk    := NIL
Local   _i       := 0
Private _lChk    := .F.
Private _oLbx    := NIL
Private _aVetor  := {}
Private _aSX     := {}
Private _aRet    := {}
Private _cExtensao:= Upper(GetDbExtension())
//Private cPerg    := ""

aAdd( _aSay, _cDesc1 )
aAdd( _aSay, _cDesc2 )
aAdd( _aSay, _cDesc3 )
aAdd( _aSay, _cDesc4 )
aAdd( _aSay, _cDesc5 )
aAdd( _aSay, _cDesc6 )
aAdd( _aSay, _cDesc7 )

//aAdd( aButton, { 5, .T., {|| Pergunte(cPerg, .T. )    }} )
aAdd( _aButton, { 1, .T., {|| _nOpc := 1, FechaBatch() }} )
aAdd( _aButton, { 2, .T., {|| FechaBatch()             }} )

Define Font _oFontBold Name "Arial" Size 0, -13 Bold
Define Font _oFontNor  Name "Arial" Size 0, -11
Define Font _oFontNorB Name "Arial" Size 0, -11 Bold

FormBatch( _cTitulo, _aSay, _aButton )

If _nOpc <> 1
	Return NIL
EndIf

// Dados dos SXs
aAdd( _aSX, { "SX1 - Perguntas            ", "SX1", "X1_GRUPO+X1_ORDEM+ORIGEM"                , "X1_GRUPO+X1_ORDEM"                , "ORIGEM" , "ORIGEM/X1_CNT01/X1_PRESEL/X1_PERSPA/X1_PERENG" , "'Pergunta '+X1_GRUPO+' '+X1_ORDEM"    } )
aAdd( _aSX, { "SX2 - Configura็ใo Arquivos", "SX2", "X2_CHAVE+ORIGEM"                         , "X2_CHAVE"                         , "ORIGEM" , "ORIGEM/X2_DELET/X2_ARQUIVO"                    , "'Arquivo '+X2_CHAVE"                  } )
aAdd( _aSX, { "SX3 - Dicionแrio de Dados  ", "SX3", "X3_CAMPO+ORIGEM"                         , "X3_CAMPO"                         , "ORIGEM" , "ORIGEM/X3_ORDEM/X3_ARQUIVO/X3_TITENG/X3_TITSPA", "'Campo '+X3_CAMPO"                    } )
aAdd( _aSX, { "SX5 - Cadastro de Tabelas  ", "SX5", "X5_TABELA+X5_CHAVE+ORIGEM"               , "X5_TABELA+X5_CHAVE"               , "ORIGEM" , "ORIGEM/X5_DESCSPA/X5_DESCENG"                  , "'Tabela '+X5_TABELA+' Item '+X5_CHAVE"} )
aAdd( _aSX, { "SX6 - Parametros do Sistema", "SX6", "X6_VAR+ORIGEM"                           , "X6_VAR"                           , "ORIGEM" , "ORIGEM/X6_CONTSPA/X6_CONTENG"                  , "'Parametro '+X6_VAR"                  } )
aAdd( _aSX, { "SX7 - Cadastro de Gatilhos ", "SX7", "X7_CAMPO+X7_SEQUENC+ORIGEM"              , "X7_CAMPO+X7_SEQUENC"              , "ORIGEM" , "ORIGEM"                                        , "'Campo '+X7_CAMPO+' Seq. '+X7_SEQUENC"} )
aAdd( _aSX, { "SXB - Consultas Padroes    ", "SXB", "XB_ALIAS+XB_TIPO+XB_SEQ+XB_COLUNA+ORIGEM", "XB_ALIAS+XB_TIPO+XB_SEQ+XB_COLUNA", "ORIGEM" , "ORIGEM/XB_DESCSPA/XB_DESCENG"                  , "'Ref. ' + XB_ALIAS+ ' '+ XB_TIPO+ ' '+XB_SEQ+ ' '+XB_COLUNA"} )
aAdd( _aSX, { "SIX - Indices dos Arquivos ", "SIX", "INDICE+ORDEM+ORIGEM"                     , "INDICE+ORDEM"                     , "ORIGEM" , "DESCSPA/DESCENG"                                , "'Arquivo ' + INDICE + ' ' + ORDEM"    } )

For _i := 1 To Len(_aSX)
	aAdd(_aVetor, { .F., _aSX[_i][1] } )
Next

Define MSDialog _oDlgLB Title "Selecione a Famํlia a Comparar" From 0, 0 To 240, 395 Pixel

@ 10, 10 Listbox _oLbx Var _cVar Fields Header " ", "Arquivo Base" ;
Size 178, 095 Of _oDlgLB Pixel On DblClick( _aVetor[_oLbx:nAt, 1] := !_aVetor[_oLbx:nAt, 1], _oLbx:Refresh())

_oLbx:SetArray( _aVetor )
_oLbx:bLine := {|| {IIf( _aVetor[_oLbx:nAt, 1], _oOk, _oNo), _aVetor[_oLbx:nAt, 2]}}
_oLbx:lHScroll  := .F. //NoScroll
_oLbx:cToolTip  := "Famํlias de Dicionแrios"
_oLbx:Refresh()

@ 110, 10 CheckBox _oChk Var _lChk Prompt "Marca / Desmarca" Message "Marca/Desmarca Todas as Famํlias" Size 60, 007 Pixel Of _oDlgLB;
on Click(Marca(_lChk, _aVetor, _oLbx))

Define SButton From 107, 123 Type 1 Action  (Principal(), _oDlgLB:End())    Enable Of _oDlgLB
Define SButton From 107, 158 Type 2 Action _oDlgLB:End() Enable Of _oDlgLB

Activate MSDialog _oDlgLB Center

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณPRINCIPAL บAutor  ณPaulo R. Trivellato บ Data บ  27/07/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina Principal                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus10                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Principal()

Local   _cVar     := NIL
Local   _cVarCpos := NIL
Local   _oDlgLB   := NIL
Local   _oOk      := LoadBitmap( GetResources(), "LBOK" )
Local   _oNo      := LoadBitmap( GetResources(), "LBNO" )
Local   _oTik     := LoadBitmap(GetResources(), "LBTIK")
Local   _oChk     := NIL
Local   _i        := 0
Local   _j        := 0
Local   _lChk     := .F.
Local   _lChkCpos := .F.
Private _aVetor2  := {}
Private _aCposSX  := {}
Private _aStruSX  := {}
Private _aArqs    := {}
Private _nCtSX    := 0
Private _cRef     := ""
Private _cChave   := ""
Private _cQuebra  := ""
Private _cCpoEmp  := ""
Private _cNaoComp := ""
Private _oDlg

For _i := 1 To Len(_aVetor)
	If _aVetor[_i][1]
		_nCtSX++
	EndIf
Next

For _i := 1 To Len(_aSX)
	
	If _aVetor[_i][1]
		
		_lChk     := .F.
		_lChkCpos := .F.
		_cRef     := _aSX[_i][2]
		_cChave   := _aSX[_i][3]
		_cQuebra  := _aSX[_i][4]
		_cCpoEmp  := _aSX[_i][5]
		_cNaoComp := _aSX[_i][6]
		_cMensLog := _aSX[_i][7]
		_aArqs    := Directory(_cRef+"*"+_cExtensao)
		
		If _cRef == "SIX"
			If File("SINDEX"+_cExtensao)
				aAdd( _aArqs, {"SINDEX", 1, Date(), Time() , "A" } )
			EndIf
		EndIf
		
		_aVetor2  := {}
		_aCposSX  := {}
		_aStruSX := (_cRef)->(dbStruct())
		
		For _j := 1 To Len(_aStruSX)
			aAdd(_aCposSX , {IIf(RTrim(_aStruSX[_j][1])$_cNaoComp, .F., .T.) , _aStruSX[_j][1]})
		Next
		
		For _j := 1 To Len(_aArqs)
			If !("990" $ _aArqs[_j][1])
				aAdd(_aVetor2, { .F., StrTran(Upper(_aArqs[_j][1]), _cExtensao, "") } )
			EndIf
		Next
		
		aSort( _aVetor2,,, {|x, y| x[2]< y[2]} )
		
		Define MSDialog _oDlg Title "Selecione os Arquivos e Campos a Comparar - "+_cRef From 0, 0 To 300, 445 Pixel
		
		@ 005, 005 Group _oGrp1 To 125, 110 Label " Arquivos a Comparar " Of _oDlg Pixel
		_oGrp1:oFont := _oFontNorB
		
		@ 015, 010 Listbox _oLbx Var _cVar Fields Header " ", "Arquivos" ;
		Size 93, 95 Of _oDlg Pixel On DblClick( _aVetor2[_oLbx:nAt, 1] := !_aVetor2[_oLbx:nAt, 1], _oLbx:Refresh())
		_oLbx:SetArray( _aVetor2 )
		_oLbx:bLine := {|| {IIf(_aVetor2[_oLbx:nAt, 1], _oOk, _oNo), _aVetor2[_oLbx:nAt, 2]}}
		_oLbx:lHScroll  := .F. //NoScroll
		_oLbx:cToolTip  := "Arquivos para Comparar"
		_oLbx:Refresh()
		
		@ 115, 10 CheckBox _oChk Var _lChk Prompt "Marca / Desmarca" Message "Marca/Desmarca Todos os Arquivos"Size 60, 007 Pixel Of _oDlg;
		on Click(Marca(_lChk, _aVetor2, _oLbx))
		
		@ 005, 115 Group _oGrp1 To 125, 220 Label " Campos a Comparar " Of _oDlg Pixel
		_oGrp1:oFont := _oFontNorB
		
		@ 15, 120 Listbox _oLbxCpos Var _cVarCpos Fields Header " ", "Campos" ;
		Size 93, 95 Of _oDlg Pixel On DblClick( _aCposSX[_oLbxCpos:nAt, 1] := !_aCposSX[_oLbxCpos:nAt, 1], _oLbx:Refresh())
		_oLbxCpos:SetArray( _aCposSX )
		_oLbxCpos:bLine := {|| {IIf(_aCposSX[_oLbxCpos:nAt, 1], _oTik, _oNo), _aCposSX[_oLbxCpos:nAt, 2]}}
		_oLbxCpos:lHScroll  := .F. //NoScroll
		_oLbxCpos:cToolTip  := "Campos para Comparar"
		_oLbxCpos:Refresh()
		
		@ 115, 120 CheckBox _oChkCpos Var _lChkCpos Prompt "Marca / Desmarca" Message "Marca/Desmarca Todos os Campos" Size 60, 007 Pixel Of _oDlg;
		on Click(Marca(_lChkCpos, _aCposSX, _oLbxCpos))
		
		Define SButton From 133, 160 Type 1 Action Comparacao() Enable Of _oDlg
		Define SButton From 133, 193 Type 2 Action _oDlg:End()  Enable Of _oDlg
		
		Activate MSDialog _oDlg Center
		
	EndIf
	
Next

Alert("Processamento Terminado.")

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณCOMPARACAOบAutor  ณPaulo R. Trivellato บ Data บ  27/07/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para fazer efetivamente a comparacao                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus10                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Comparacao()

Local   _aStru    := {}
Local   _i        := 0
Local   _j        := 0
Private _nCtArq   := 0
Private _aStruPad := {}

For _i := 1 To Len(_aVetor2)
	If _aVetor2[_i][1]
		_nCtArq++
	EndIf
Next

If _nCtArq < 2
	Alert("T๊m que ser selecionados ao menos 2 arquivos para compara็ใo.")
	Return NIL
EndIf

If !ApMsgNoYes("Serใo comparados " + AllTrim(Str(_nCtArq, 4, 0)) + " arquivos. Continua ?")
	Return NIL
EndIf

_cNaoComp := AllTrim(_aSX[aScan(_aSX, {|x| AllTrim(x[2]) == _cRef })][5])+"/"
For _j := 1 To Len(_aCposSX)
	If !_aCposSX[_j][1]
		_cNaoComp += RTrim( _aCposSX[_j][2])+"/"
	EndIf
Next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Criacao do Arquivo de LOG                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_aStru := {}
aAdd(_aStru, {"MENSAGEM", "C", 220,  0 })
_cArq  := CriaTrab(_aStru, .T.)
dbUseArea(.T.,, _cArq, "LOG", .F., .F.)

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...", "Executando rotina...", .T. )

ListaLog()

dbSelectArea("LOG")
dbCloseArea()

If File(_cArq)
	//			FErase(_cArq)
EndIf

_oDlg:End()

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณRUNPROC   บAutor  ณ Paulo R. Trivellatoบ Data บ  27/07/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina Auxiliar de Procesamento                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus10                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunProc(lEnd)

Local _i        := 0
Local _j        := 0
Local _lLimpa   := .F.
Local _aStruDif := {}
Local _lTemDif  := .F.
Local _lNaoExis := .F.

If !File("PAD"+_cRef+".DBF")
	aAdd(_aStruSX, {"ORIGEM", "C", 10, 0})
	_cArq     := CriaTrab(_aStruSx, .T.)
	FRename(_cArq+_cExtensao, "PAD"+_cRef+_cExtensao)
	_lNaoExis := .T.
EndIf

dbUseArea(.T.,, "PAD"+_cRef, "PAD", .F., .F.)
_aStruPad   := dbStruct()

// Compatibilizando Estruturas dos Arquivos Selecionados
_aStruDif := {}
_lTemDif  := .F.

For _i := 1 To Len(_aVetor2)
	If _aVetor2[_i][1]
		dbUseArea(.T.,, _aVetor2[_i][2] , "XXX", .T., .F.)
		_aStruTemp := dbStruct()
		dbCloseArea()
		
		For _j := 1 To Len(_aStruTemp)
			_nPos := aScan(_aStruPad, {|x| AllTrim(x[1]) == AllTrim(_aStruTemp[_j][1])})
			
			If     _nPos == 0
				aAdd( _aStruDif, _aStruTemp[_j])
				
			ElseIf _aStruPad[_j][3] < _aStruTemp[_j][3]
				_aStruPad[_j][3] := _aStruTemp[_j][3]
				_lTemDif := .T.
				
			ElseIf _aStruPad[_j][4] < _aStruTemp[_j][4]
				_aStruPad[_j][4] := _aStruTemp[_j][4]
				_lTemDif := .T.
				
			EndIf
		Next
	EndIf
Next

_lLimpa := .T.
If Len(_aStruDif) > 0 .or. _lTemDif
	dbSelectArea("PAD")
	dbCloseArea()
	FErase("PAD"+_cRef+_cExtensao)
	
	For _i := 1 To Len(_aStruDif)
		aAdd(_aStruPad, _aStruDif[_i])
	Next
	
	_cArq  := CriaTrab(_aStruPad, .T.)
	FRename(_cArq+_cExtensao, "PAD"+_cRef+_cExtensao)
	
	dbUseArea(.T.,, "PAD"+_cRef, "PAD", .F., .F.)
	_aStruPad   := dbStruct()
	
Else
	If !_lNaoExis
		_lLimpa := ApMsgNoYes("Monta novamente arquivo base de compara็ใo ?")
	EndIf
EndIf


If _lLimpa  .or. _lNaoExis
	dbSelectArea("PAD")
	Zap
	
	ProcRegua(_nCtArq * 2)
	
	For _i := 1 To Len(_aVetor2)
		If _aVetor2[_i][1]
			IncProc("Incluindo Arquivo "+_aVetor2[_i][2]+" ...")
			Append From &(_aVetor2[_i][2])
			
			IncProc("Gravando Origem "+_aVetor2[_i][2]+" ...")
			Replace All PAD->(&(_cCpoEmp)) With _aVetor2[_i][2] For Empty(PAD->(&(_cCpoEmp)))
			dbGoTop()
		EndIf
	Next
EndIf

dbSelectArea("PAD")
_cIndexName := Criatrab(NIL, .F.)
IndRegua("PAD", _cIndexName, _cChave,,, "Aguarde selecionando registros....")
dbSetIndex(_cIndexName + OrdBagExt())

dbSelectArea("PAD")
dbGoTop()
Copy Stru To TEMP
ProcRegua(LastRec())

While !PAD->(EOF()) .and. !lEnd
	
	_cCampoAnt  := PAD->(&(_cQuebra))
	_cCampoImp  := PAD->(&(_cMensLog))
	_lPrimeiro  := .T.
	_nRecno     := PAD->(Recno())
	_lDiferenca := .F.
	_aCposDif   := {}
	_nCont      := 0
	
	While !PAD->(EOF()) .and. !lEnd .and. _cCampoAnt == PAD->(&(_cQuebra))
		
		If _lPrimeiro
			dbUseArea(.T.,, "TEMP", "TEMP", .F., .F.)
			Zap
			RecLock("TEMP", .T.)
			For _i := 1 To Len(_aStruPad)
				FieldPut(_i, PAD->(FieldGet(_i)) )
				_lPrimeiro := .F.
			Next
			MsUnlock()
			
		Else
			
			For _i := 1 To Len(_aStruPad)
				If !AllTrim(_aStruPad[_i][1]) $ _cNaoComp
					
					_xCpo1 := PAD->(FieldGet(_i))
					_xCpo2 := TEMP->(FieldGet(_i))
					
					If  AllTrim(_aStruPad[_i][2]) == "C"
						_xCpo1 := AllTrim(StrTran(Upper(PAD->(FieldGet(_i))), " ", ""))
						_xCpo2 := AllTrim(StrTran(Upper(TEMP->(FieldGet(_i))), " ", ""))
					EndIf
					
					If _xCpo1 <> _xCpo2
						//					If PAD->(FieldGet(_i)) <> TEMP->(FieldGet(_i))
						_cAux := _aStruPad[_i][1]
						_nPos := aScan(_aCposDif, {|x| AllTrim(x[1]) == AllTrim(_cAux) })
						If _nPos == 0
							aAdd(_aCposDif, {_aStruPad[_i][1]+REPLICATE(" ", 10-Len(_aStruPad[_i][1])), _aStruPad[_i][2] })
						EndIf
						_lDiferenca := .T.
						//						Exit
					EndIf
				EndIf
			Next
		EndIf
		
		If _lDiferenca
			Exit
		EndIf
		
		_nCont++
		
		IncProc("Processando "+_cCampoImp+" ...")
		
		dbSelectArea("PAD")
		dbSkip()
	End
	
	dbSelectArea("TEMP")
	dbCloseArea()
	
	If _lDiferenca
		For _i := 1 To Len(_aCposDif)
			dbSelectArea("PAD")
			dbGoTo(_nRecno)
			
			While !PAD->(EOF()) .and. !lEnd .and. _cCampoAnt == PAD->(&(_cQuebra))
				
				_xAux := ""
				Do Case
					Case _aCposDif[_i][2] == "C"
						_xAux := PAD->&(_aCposDif[_i][1])
						
					Case _aCposDif[_i][2] == "N"
						_xAux := Str(PAD->&(_aCposDif[_i][1]))
						
					Case _aCposDif[_i][2] == "D"
						_xAux := DToC(PAD->&(_aCposDif[_i][1]))
						
					Case _aCposDif[_i][2] == "L"
						_xAux := IIf(PAD->&(_aCposDif[_i][1]), ".T.", ".F.")
						
				EndCase
				
				GravaLog(PAD->(&(_cCpoEmp))  + "  " + PAD->(&(_cMensLog))  + "  " +_aCposDif[_i][1]+ " - Com diferenca de conteudo - [ " + _xAux + " ]")
				dbSelectArea("PAD")
				dbSkip()
			End
			GravaLog(" " )
		Next
	EndIf
End

dbSelectArea("PAD")
dbGoTop()
ProcRegua(LastRec())

While !PAD->(EOF()) .and. !lEnd
	_cCampoAnt  := PAD->(&(_cQuebra))
	_cCampoImp  := PAD->(&(_cMensLog))
	_nRecno     := PAD->(Recno())
	_nCont      := 0
	_aAux       := {}
	
	While !PAD->(EOF()) .and. !lEnd .and. _cCampoAnt == PAD->(&(_cQuebra))
		IncProc("Verificando chaves inexistentes "+PAD->(&(_cMensLog))+" ...")
		
		_nCont++
		dbSelectArea("PAD")
		dbSkip()
	End
	
	If _nCont++ <> _nCtArq
		For _i:=1 To Len(_aVetor2)
			If _aVetor2[_i][1]
				aAdd(_aAux, {_aVetor2[_i][2], .F.})
			EndIf
		Next
		
		dbSelectArea("PAD")
		dbGoTo(_nRecno)
		
		While !PAD->(EOF()) .and. !lEnd .and. _cCampoAnt ==  PAD->(&(_cQuebra))
			_nPos := aScan(_aAux, {|x| AllTrim(x[1]) == AllTrim(PAD->(&(_cCpoEmp))) })
			
			If _nPos > 0
				_aAux[_nPos][2] := .T.
			EndIf
			
			dbSelectArea("PAD")
			dbSkip()
		End
		
		For _i:=1 To Len(_aAux)
			GravaLog(_aAux[_i][1] + "  " + _cCampoImp + "  " +IIf(_aAux[_i][2], " - Ok", " - Nao Existe"))
		Next
		GravaLog(" ")
	EndIf
	
End

dbSelectArea("PAD")
dbCloseArea()
//	FErase(_cIndexName+OrdBagExt())

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณMARCA     บAutor  ณ Paulo R. Trivellatoบ Data บ  27/07/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar para escolha                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus10                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Marca(_lMarca, _aVet, _oObj)

Local _i := 0

For _i := 1 To Len(_aVet)
	_aVet[_i][1] := _lMarca
Next _i

_oObj:Refresh()

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GRAVALOG บAutor  ณ Paulo R. Trivellatoบ Data บ  27/07/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para gravacao do arquivo de LOG                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus10                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GravaLog(_cMens)

Local _aArea := GetArea()

dbSelectArea("LOG")
RecLock("LOG", .T.)
LOG->MENSAGEM  := _cMens
MsUnlock()

RestArea(_aArea)

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ LISTALOG บAutor  ณ Paulo R. Trivellatoบ Data บ  27/07/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para listagem do arquivo de LOG                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus10                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ListaLog()

Local   cDesc1       := "Serao listados as mesagens de LOG referentes"
Local   cDesc2       := "a comparacao dos "+_cRef
Local   cDesc3       := ""
Local   cPict        := ""
Local   titulo       := "LISTAGEM DE LOG NA COMPARACAO "+_cRef
Local   Cabec1       := ""
Local   Cabec2       := "Mensagem"
Local   imprime      := .T.
Local   aOrd         := {}
Private nLin         := 80
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "COMPSX"+_cRef
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 1, 1, "", 1}
Private nLastKey     := 0
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "COMPSX"+_cRef
Private cString      := "LOG"

dbSelectArea("LOG")
If RecCount() == 0
	GravaLog("   *** N A O   H O U V E R A M   E R R O S  ***")
EndIf
dbGoTop()

wnrel := SetPrint(cString, NomeProg, "", @titulo, cDesc1, cDesc2, cDesc3, .F., aOrd, .F., Tamanho,, .F.)

If nLastKey == 27
	Return NIL
EndIf

SetDefault(aReturn, cString)

If nLastKey == 27
	Return
EndIf

nTipo := If(aReturn[4]==1, 15, 18)

RptStatus({|| RunReport(Cabec1, Cabec2, Titulo, nLin) }, Titulo)

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ RUNREPORTบAutor  ณ Paulo R. Trivellatoบ Data บ  27/07/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus10                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunReport(Cabec1, Cabec2, Titulo, nLin)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Lista Erros                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetPrc(80, 01)
titulo := "DIFERENCAS ENCONTRADAS NA COMPARACAO DE "+_cRef

dbSelectArea("LOG")
SetRegua(RecCount())
dbGoTop()

While !EOF()
	
	If lAbortPrint
		@nLin, 00 PSay "*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf
	
	If PRow() > 55
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	EndIf
	
	@ PRow()+1, 000 PSay LOG->MENSAGEM
	
	dbSkip()
End

Set Device To Screen

If aReturn[5]==1
	dbCommitAll()
	Set Printer To
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return NIL