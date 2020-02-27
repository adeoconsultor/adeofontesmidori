#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


///////////////////////////////////////////////////////////////////////////////
//Rotina para apontamento de PLANOS 
//Este programa vai fazer o apontamento dos planos de pecas baseado no Kit lancado
//O objetivo eh eliminar o apontamento por fichas conforme ocorre atualmente,reduzindo a qtde de registros no SD3
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br -15-06-2012
///////////////////////////////////////////////////////////////////////////////
User Function AG_APTPLN()


//Variaveis
Local nOpc := 5 //GD_INSERT+GD_DELETE+GD_UPDATE
Private aCoBrwTMPZ3 := {}
Private aHoBrwTMPZ3 := {}
Private cSayCli    := Space(60)
Private cSayData   := Space(10)
Private cSayKit    := Space(60)
Private cSayPLN    := Space(20)
Private cSayRelea  := Space(20)
Private cSayTitCli := Space(10)
Private cSayTitDat := Space(10)
Private cSayTitKit := Space(10)
Private cSayTitPln := Space(10)
Private cSayTitRel := Space(10)
Private cSayTitQtd := Space(10)
Private cSayTitSta := Space(10)
Private cSayStat   := Space(20)
Private cSayQtde   := 0

Private noBrwTMPZ3  := 0

cSayTitCli := SZP->ZP_CLIENTE+'-'+SZP->ZP_LOJA+' '+SZP->ZP_NOMCLIE
cSayTitDat := SZP->ZP_EMISSAO
cSayTitKit := Substr(SZP->ZP_PRODUTO,1,6) +'-'+Posicione('SB1',1,xFilial('SB1')+SZP->ZP_PRODUTO, "B1_DESC")
cSayTitPln := SZP->ZP_OPMIDO
cSayTitRel := SZP->ZP_RELEASE
cSayQtde   := SZP->ZP_QUANT






/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oFont2","oDlg1","oGrpPLN","oSayTitPln","oSayPLN","oSayTitKit","oSayKit","oSayTitData")
SetPrvt("oSayTitRel","oSayRelea","oSayTitCli","oSayCli","oSayQtde","oSayTitQtde","oSayStat","oSayTitStat")
SetPrvt("oBrwTMPZ3","oBtnConf","oBtnCanc")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 122,264,629,1139,"Apontamento real do plano....",,,.F.,,,,,,.T.,,,.T. )
oGrpPLN    := TGroup():New( 004,004,056,428,"Dados do Plano...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayTitPln := TSay():New( 016,012,{||"PLANO: "},oGrpPLN,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayPLN    := TSay():New( 016,049,{|u| If(PCount()>0,cSayTitPln:=u,cSayTitPln)},oGrpPLN,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,072,008)
oSayTitKit := TSay():New( 029,012,{||"KIT: "},oGrpPLN,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSayKit    := TSay():New( 029,049,{|u| If(PCount()>0,cSayTitKit:=u,cSayTitKit)},oGrpPLN,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,247,008)
oSayTitDat := TSay():New( 016,129,{||"DATA DO PLANO: "},oGrpPLN,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,067,008)
oSayData   := TSay():New( 016,201,{|u| If(PCount()>0,cSayTitDat:=u,cSayTitDat)},oGrpPLN,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,051,008)
//oGetCodCli := TGet():New( 197,008,{|u| If(PCount()>0,cGetCodCli:=u,cGetCodCli)},oGrpModel,036,014,'',{|| U_BUSCACLI() },CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1","cGetCodCli",,)
oSayTitRel := TSay():New( 016,278,{||"RELEASE:"},oGrpPLN,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
oSayRelea  := TSay():New( 016,318,{|u| If(PCount()>0,cSayTitRel:=u,cSayTitRel)},oGrpPLN,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,051,008)
oSayTitCli := TSay():New( 042,012,{||"CLIENTE: "},oGrpPLN,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSayCli    := TSay():New( 042,049,{|u| If(PCount()>0,cSayTitCli:=u,cSayTitCli)},oGrpPLN,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,271,008)
oSayTitQtd := TSay():New( 029,278,{||"QUANTIDADE: "},oGrpPLN,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
oSayQtde   := TSay():New( 029,350,{|u| If(PCount()>0,cSayQtde:=u,cSayQtde)},oGrpPLN,'@E 9,999',oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,051,008)
oSayTitSta := TSay():New( 042,278,{||"STATUS: "},oGrpPLN,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
oSayStat   := TSay():New( 042,320,{|u| If(PCount()>0,cSayStat:=u,cSayStat)},oGrpPLN,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,097,008)
oGrpPecas  := TGroup():New( 060,004,216,428,"Dados das Pe?s...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
MHoBrwTMPZ3()
MCoBrwTMPZ3()
Inc_Peca()
oBrwTMPZ3  := MsNewGetDados():New(072,008,208,424,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysFalse()','','AllwaysFalse()',oGrpPecas,aHoBrwTMPZ3,aCoBrwTMPZ3 )
oBtnConf   := TButton():New( 224,284,"&Confirmar apontamento",oDlg1,{||_aptplano()},068,016,,,,.T.,,"",,,,.F. )
oBtnCons   := TButton():New( 224,211,"Localização da ficha",oDlg1,{|| locFic()},068,016,,,,.T.,,"",,,,.F.)
oBtnCanc   := TButton():New( 224,357,"Ca&ncelar",oDlg1,{||oDlg1:end()},068,016,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ?MHoBrwTMPZ3() - Monta aHeader da MsNewGetDados para o Alias: SZ3
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrwTMPZ3()

Local nn1
aCpos :=  	{	{'OP'						,'Z3_NUMOP'			,06,0	,'@!'						,	'AllwaysTrue()'		},;
				{'PECA'						,'Z3_PRODUTO'		,06,0	,'@!'						,	'AllwaysTrue()'		},;
				{'DESCRICAO'				,'B1_DESC'			,60,0	,'@!'						,	'AllwaysTrue()'		},;
				{'DATA FICHA'				,'Z3_DTFICHA'		,10,0   ,'@!'						,	'AllwaysTrue()'		},;				
				{'QTDE APTDA'				,'B1_PE'			,05,0   ,'@E 99,999'			,	'AllwaysTrue()'		},;
				{'QTDE BXDA'				,'B1_PE'			,05,0   ,'@E 99,999'			,	'AllwaysTrue()'		},;				
				{'QTDE A APT'				,'B1_PE'			,05,0	,'@E 99,999'			,	'AllwaysTrue()' 	} } 


DbSelectArea("SX3")
DbSetOrder(2)

For nn1 := 1 to len( aCpos )
	if DbSeek( aCpos[ nn1,2 ] )
		If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
			noBrwTMPZ3++
			
			
			Aadd(aHoBrwTMPZ3,{Trim( aCpos[ nn1,1 ] ),;
			aCpos[ nn1,2 ],;
			aCpos[ nn1,5 ],;
			aCpos[ nn1,3 ],;
			aCpos[ nn1,4 ],;
			aCpos[ nn1,6 ],;
			"",;
			SX3->X3_TIPO,;
			"",;
			"" } )
		EndIf
	Endif
Next
DbSelectArea("SX3")
DbSetOrder(1)

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ?MCoBrwTMPZ3() - Monta aCols da MsNewGetDados para o Alias: SZ3
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MCoBrwTMPZ3()

Local aAux := {}
Local nI

Aadd(aCoBrwTMPZ3,Array(noBrwTMPZ3+1))
For nI := 1 To noBrwTMPZ3
   aCoBrwTMPZ3[1][nI] := CriaVar(aHoBrwTMPZ3[nI][2])
Next
aCoBrwTMPZ3[1][noBrwTMPZ3+1] := .F.

Return



User Function SHOWSZP()


U_AG_MntTela()

Return



User Function AG_MntTela()
Local	nI			:= 0
Local 	aCampos		:= {}
Local nn1
Private cMarca 		:= GetMark()
Private nOrdemAtual := 10
Private cusrs := Getmv( 'MV_MIDOLBPL'  )
Private aUsrs := U_QuebraSep( cusrs , ';'  )
Private cUsuPermit  := ''
Private oOk := LoadBitmap( GetResources(), "LBOK")
Private oNo := LoadBitmap( GetResources(), "LBNO")
//
For nn1 := 1 to len( aUsrs )
	cUsuArray := aUsrs[ nn1 ]
	//
	if Alltrim(substr( cUsuArray  , 2 ) )   == Alltrim( RetCodUsr()   )
		cUsuPermit  := aUsrs[ nn1 ]
		exit
	Endif
Next
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Define o cabecalho da tela de atualizacoes               ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCadastro := "Planos de Produção"

Private aRotina := MnuMonta()
Private aIndTmp 	:= {}
Private aSavMTA652  := Array(8)
Private oVermelho   := LoadBitmap( GetResources(), "BR_VERMELHO" )
Private oAmarelo    := LoadBitmap( GetResources(), "BR_AMARELO" )
Private oVerde      := LoadBitmap( GetResources(), "BR_VERDE" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Definicao de variaveis para rotina de inclusao automatica    ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Variaveis utilizadas para parametros                         ?
//?mv_par01            // De  Produto                           ?
//?mv_par02            // Ate Produto                           ?
//?mv_par03            // De  Ordem de Producao                 ?
//?mv_par04            // Ate Ordem de Producao                 ?
//?mv_par05            // De  Data de Entrega                   ?
//?mv_par06            // Ate Data de Entrega                   ?
//?mv_par07            // De  Data de Inicio                    ?
//?mv_par08            // Ate Data de Inicio                    ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("MTA652",.F.)
For ni := 1 to 8
	aSavMTA652[ni] := &("mv_par"+StrZero(ni,2))
Next ni

dbSelectArea("SZP")
dbSetOrder(2)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Filtra o arquivo conforme perguntas antes de mostrar     ?
//?o browse                                                 ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  PLNPFiltra()
//set filter to ZP_FILIAL== xFilial("SZP") .And. ZP_LIBER == "OK" //.and. ZP_ANO == cValToChar(Year(dDatabase)) //-> comentado para n? ser considerado ano no filtro pois na virada do ano 2012/2013 foi necess?io visualizar alguns processos do ano de 2012 em PNP2 - Solicitante: Marcos Falaschi - Comentado por: Vinicius Schwartz - TI
dbGoTop()
// MarkBrow("SC2","C2_OK",  ,  ,   , cMarca)
//
aCampos := {}
AADD(aCampos,{"ZP_OK"    			,"","" 			    	})
AADD(aCampos,{"ZP_OPMIDO"    		,"","Num. Plano "     	})
AADD(aCampos,{"ZP_EMISSAO"  		,"","Emissao"  		  	})
AADD(aCampos,{"ZP_QUANT"    		,"","Quantidade"    	})
AADD(aCampos,{"ZP_PRODUTO"  		,"","Produto"   		})
AADD(aCampos,{"ZP_CLIENTE"    		,"","Cliente"    		})
AADD(aCampos,{"ZP_LOJA"    			,"","Loja"    			})
AADD(aCampos,{"ZP_NOMCLIE"    		,"","Nome"     			})
AADD(aCampos,{"ZP_RELEASE"    		,"","Release"    		})
AADD(aCampos,{"ZP_DTRELEA"    		,"","Release"    		})
AADD(aCampos,{"ZP_NMLIB1"    		,"","1 Liberacao"   	})
AADD(aCampos,{"ZP_DTLIB1"    		,"","Data"    			})
AADD(aCampos,{"ZP_NMLIB2"    		,"","2 Liberacao"   	})
AADD(aCampos,{"ZP_DTLIB2"    		,"","Data"    			})
AADD(aCampos,{"ZP_EMISSAO"    		,"","Impr. Ficha"    	})
//
aCores := {} // Limpando a variavel
//Aadd(aCores,{"empty(C2_USLIB1) .and. empty(C2_USLIB2) .AND. C2_LIBER <>'OK' "    ,"BR_VERMELHO" })
//Aadd(aCores,{"! empty(C2_USLIB1) .and. empty(C2_USLIB2) .AND. C2_LIBER <>'OK'  " ,"BR_AMARELO"   })
//
// MarkBrow("SC2","C2_OK", ,aCampos ,  , cMarca , , , , , , , , ,  )
MarkBrow("SZP","ZP_OK", ,aCampos ,  , cMarca , , , , , , , , ,  )
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Retorna indices do SC2                                       ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SZP")
aEval(aIndTmp, {|cFile| fErase(cFile+OrdBagExt())})
dbSetOrder(1)

RETURN
//----------------------------------
Static FUNCTION PLNPFiltra(nOrder)
LOCAL cIndice,nInd,cFirmaCond:=""
Local cNomeInd:=CriaTrab(NIL,.F.)
nOrder := If(nOrder=Nil,2,nOrder)

Aadd(aIndTmp, cNomeInd)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Gera index de trabalho do SC2                                ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZP")
dbSetOrder(nOrder)
cIndice   := Indexkey()
cFirmaCond += 'ZP_FILIAL=="'+xFilial("SZP")+'".And. '
cFirmaCond += ' ZP_LIBER == "OK" '
//
IndRegua("SZP",cNomeInd,cIndice,,cFirmaCond," Selecionando Registros..." )
nInd := RetIndex("SZP")
#IFNDEF TOP
	dbSetIndex(cNomeInd+OrdBagExt())
#ENDIF
dbSetOrder(nInd+1)
Return

Static Function MnuMonta()

PRIVATE aRotina	:= {}
AaDd( aRotina	,	{"Pesquisar"         		,"aXPesqui"	,0,1,0,.f.} )
AaDd( aRotina	,	{'Visualizar ' 				,"U_VISUP"	,0,4,0,.f.} ) 
AaDd( aRotina	,	{'Apontar Plano' 	   		,"U_AG_APTPLN()",0,5,0,.f.} )
AaDd( aRotina	,	{'Status PLano' 	        ,"U_STATFIC()",0,5,0,.f.} )
AaDd( aRotina	,	{'Legenda '					,"u_Mid_LegPlP"   ,0,5,0,.f.} )
									
// U_MD_GRFCOR(  SC2->(RECNO() )  )
//-------------------------
Return(aRotina)
//------------------------------------------------------------------------------------------------
Static Function ChvFic()
Return('ZP_FILIAL== xFilial("SZP").And. ZP_LIBER == "OK" ')
//------------------------------------------------------------------------------------------------


Static function Inc_Peca()
local cQuery  := ""        
local nCountA := nCountB := 0
local cAno    := ""
cQuery := " Select Substring(Z3_NUMOP,1,6) Z3_NUMOP, Z3_PLANO, Substring(Z3_PRODUTO,1,6) Z3_PRODUTO, B1_DESC, Sum(Z3_QTDE) Z3_QTDE, Z3_DTFICHA " 
cQuery += " from SZ3010 SZ3, SB1010 SB1 " 
cQuery += " where SB1.D_E_L_E_T_ = ' ' and SZ3.D_E_L_E_T_= ' ' " 
cQuery += " and Z3_PRODUTO = B1_COD "  
cQuery += " and Z3_PLANO = '"+SZP->ZP_OPMIDO+"' AND SUBSTRING(Z3_DTFICHA,1,4)= '"+SZP->ZP_ANO+"' " 
cQuery += " and Z3_STATUS = 'B' and Z3_QTDE > 0 " 
cQuery += " and Z3_FILIAL = '"+xFilial("SZ3")+"' "
cQuery += " group by Substring(Z3_NUMOP,1,6), Z3_PLANO, Z3_PRODUTO, B1_DESC, Z3_DTFICHA "
cQuery += " order by Z3_PRODUTO " 

	if Select('TRBZ3') > 0
			dbSelectArea('TRBZ3')
			dbCloseArea()
	endif
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZ3',.T.,.T.)
TcSetField("TRBZ3", "Z3_DTFICHA", "D")

dbSelectArea("TRBZ3")
dbGotop()
aCoBrwTMPZ3 := {} 
cAno := Substr(dTos(TRBZ3->Z3_DTFICHA),1,4)
while !TRBZ3->(eof()) 
	if Select('TMPC2') > 0
		dbSelectArea('TMPC2')
		dbCloseArea()
	endif
	cQC2 := " Select Sum(C2_QUANT) C2_QUANT, Sum(C2_QUJE) C2_QUJE from SC2010 WHERE D_E_L_E_T_= ' ' and C2_FILIAL = '"+xFilial('SC2')+"' " 
	cQC2 += " AND C2_OPMIDO = '"+SZP->ZP_OPMIDO+"' and Substring(C2_EMISSAO,1,4) = '"+Substr(dTos(TRBZ3->Z3_DTFICHA),1,4)+"' " 
	cQC2 += " AND C2_PRODUTO = '"+TRBZ3->Z3_PRODUTO+"' " 
	dbUseArea(.T.,"TOPCONN", TcGenQry(,, cQC2), 'TMPC2',.T.,.T.)

	Aadd(aCoBrwTMPZ3, {TRBZ3->Z3_NUMOP, TRBZ3->Z3_PRODUTO, TRBZ3->B1_DESC, TRBZ3->Z3_DTFICHA, iif(TRBZ3->Z3_QTDE <= TMPC2->C2_QUANT, TRBZ3->Z3_QTDE,TMPC2->C2_QUANT) , TMPC2->C2_QUJE, 0, .F. }) 
	
	TRBZ3->(dbSkip())
	nCountB++
enddo

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Filtrar as pecas que ainda nao foram baixadas
/////////////////////////////////////////////////////////////////////////////////////////////////////////
if Select('TRBZ3') > 0
	dbSelectArea('TRBZ3')
	dbCloseArea()
endif

cQuery := " Select Substring(Z3_NUMOP,1,6) Z3_NUMOP, Substring(Z3_PRODUTO,1,6) Z3_PRODUTO, B1_DESC, Sum(Z3_QTDE) Z3_QTDE, Z3_DTFICHA  " 
cQuery += " from SZ3010 SZ3, SB1010 SB1 " 
cQuery += " where SB1.D_E_L_E_T_ = ' ' and SZ3.D_E_L_E_T_= ' ' " 
cQuery += " and Z3_PRODUTO = B1_COD "  

cQuery += " and Z3_PLANO = '"+SZP->ZP_OPMIDO+"' " 
cQuery += " and Z3_STATUS = 'A' and Z3_QTDE > 0 and Substring(Z3_DTFICHA,1,4) = '"+cAno+"' " 

cQuery += " and Z3_FILIAL = '"+xFilial("SZP")+"' "
cQuery += " and B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery += " group by Substring(Z3_NUMOP,1,6), Z3_PRODUTO, B1_DESC, Z3_DTFICHA "
cQuery += " order by Z3_PRODUTO " 

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZ3',.T.,.T.)
TcSetField("TRBZ3", "Z3_DTFICHA", "D")

while !TRBZ3->(eof()) 
	nz:= ASCAN(aCoBrwTMPZ3,{|x| Substr(x[2],1,6) == Substr(TRBZ3->Z3_PRODUTO,1,6)})
	if nz == 0 
		Aadd(aCoBrwTMPZ3, {TRBZ3->Z3_NUMOP, TRBZ3->Z3_PRODUTO, TRBZ3->B1_DESC, TRBZ3->Z3_DTFICHA, 0, 0, TRBZ3->Z3_QTDE, .F. }) 
	else
		aCoBrwTMPZ3[nz][7] += TRBZ3->Z3_QTDE
	endif
	TRBZ3->(dbSkip())
	nCountA++
enddo

if nCountB > 0 .and. nCountA > 0 
	cSayStat := 'BAIXADO PARCIAL' 
elseif nCountB >0 .and. nCountA == 0
	cSayStat := 'BAIXADO TOTAL' 
else
	cSayStat := 'FICHAS NAO APONTADAS' 
endif
		

return 

static function _aptplano()
if cSayStat <> 'FICHAS NAO APONTADAS' 
	if APMSGNOYES('Confirma o apontamento das pecas que ja foram encerradas ? ','Atencao!!!!')
		
		If APMSGNOYES('As Etiquetas de componentes serão impressas? (S/N)? ','Atencao!!!!')
			Processa({|| apontPln('S')}, 'Apontando pecas do plano...')
		Else
			Processa({|| apontPln('N')}, 'Apontando pecas do plano...')
		EndIf
		
	endif
else
	Alert('N? existem fichas apontadas para o plano...')
endif

Return
 


///rotina para gerar d3 e as etiquetas.
Static Function apontPln(cParSN)           

Local nCount:= 0
Local _xFlag:='N'

Private cMdrEtPlan := "" // código do plano a ser impresso na etiqueta ACD

cQuery := ""
cQuery := " Select C2_NUM, C2_ITEM, C2_SEQUEN, Z3_NUMOP, Z3_PRODUTO, Sum(Z3_QTDE) Z3_QTDE, Sum(C2_QUANT) C2_QUANT " 
cQuery += " from SZ3010 SZ3, SB1010 SB1, SC2010 SC2 " 
cQuery += " where SB1.D_E_L_E_T_ = ' ' and SZ3.D_E_L_E_T_= ' ' and SC2.D_E_L_E_T_ = ' ' " 
cQuery += " and C2_FILIAL = Z3_FILIAL " 
cQuery += " and Z3_PRODUTO = B1_COD " 
cQuery += " and C2_NUM = Z3_NUMOP " 
cQuery += " and Z3_PLANO = '"+SZP->ZP_OPMIDO+"' " 
cQuery += " and Z3_STATUS = 'B' and Z3_QTDE > 0 and Z3_OPAPONT = 'N' " 
cQuery += " and Z3_FILIAL = '"+xFilial("SZ3")+"' "
cQuery += " and C2_FILIAL = '"+xFilial("SC2")+"' "
cQuery += " group by C2_NUM, C2_ITEM, C2_SEQUEN, Z3_NUMOP, Z3_PRODUTO " 
cQuery += " order by Z3_PRODUTO " 

if Select('TRBZ3') > 0
	dbSelectArea('TRBZ3')
	dbCloseArea()
endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZ3',.T.,.T.)
TcSetField("TRBZ3", "Z3_DTFICHA", "D")


////////////////////////////////////////////////////////////////////////
//Query para filtrar as fichas j?baixadas, que ainda nao foram apontadas
//objetivo de fazer o ajuste de empenho conforme o real consumido na ficha
////////////////////////////////////////////////////////////////////////
cQZ3 := " Select Z3_NUMOP, Z3_ITEM, Z3_SEQUEN, Z3_MATERIA, Z3_PRODUTO, "
cQZ3 += " Sum(Z3_M2TOT) Z3_M2TOT, Sum(Z3_SLDM2) Z3_SLDM2, "
cQZ3 += " (Sum(Z3_SLDM2) - Sum(Z3_M2TOT))  Z3_QTAJUS "
cQZ3 += "  from SZ3010 "
cQZ3 += " where D_E_L_E_T_ = ' ' "
cQZ3 += " and Z3_FILIAL = '"+xFilial("SZP")+"' "
cQZ3 += " and Z3_PLANO = '"+SZP->ZP_OPMIDO+"' " 
cQZ3 += " and Z3_OPAPONT = 'N' "
cQZ3 += " and Z3_STATUS = 'B' "
cQZ3 += " group by Z3_NUMOP, Z3_ITEM, Z3_SEQUEN, Z3_MATERIA, Z3_PRODUTO "

cPlano:= SZP->ZP_OPMIDO
if Select('TMPZ3') > 0
	dbSelectArea('TMPZ3')
	TMPZ3->(dbCloseArea())                            
endif

dbUseArea(.T., "TOPCONN", TcGenQry(,,cQZ3), 'TMPZ3', .T.,.T.)

dbSelectArea('TMPZ3')
dbGotop()
while !TMPZ3->(eof())
//	Alert('Buscando-->>> |'+PADR(TMPZ3->(Substr(Z3_NUMOP,1,6)+Z3_ITEM+Z3_SEQUEN),13)+"|"+PADR(TMPZ3->Z3_MATERIA,15)+"|")
	dbSelectArea('SD4')
	dbSetOrder(2)
	if dbSeek(xFilial('SD4')+PADR(TMPZ3->(Substr(Z3_NUMOP,1,6)+'01001'),13)+PADR(TMPZ3->Z3_MATERIA,15))

		//Verifica se o total apontado eh maior que o empenho
		if SD4->D4_QTDEORI <> TMPZ3->Z3_SLDM2
		 	 
		 	 //Faz uma segunda checagem para evitar erros....
		 	 if Select('TRCH') > 0
		 	 	dbSelectArea('TRCH')
		 	 	TRCH->(dbCloseArea())
		 	 endif
		    cQCHK := " Select Sum(Z3_SLDM2) Z3_SLDM2 from SZ3010 " 
		    cQCHK += " where D_E_L_E_T_ = ' ' "  
		    cQCHK += " and Z3_FILIAL ='"+xFilial("SZ3")+"' " 
		    cQCHK += " and Z3_NUMOP ='"+TMPZ3->(Substr(Z3_NUMOP,1,6))+"' "
		    cQCHK += " and Z3_MATERIA = '"+TMPZ3->Z3_MATERIA+"' " 
		    cQCHK += " group by Z3_NUMOP " 
			
			dbUseArea(.T., "TOPCONN", TcGenQry(,, cQCHK), 'TRCH', .T., .T.)
//			Alert(Substr(SD4->D4_COD,1,6)+' '+SD4->D4_OP+' ANTES: Qtde Total -> '+cValToChar(SD4->D4_QTDEORI)+' Qtde Saldo-> '+cValToChar(SD4->D4_QUANT))
			RecLock('SD4', .F.)
			nSldold := SD4->D4_QTDEORI
			nSldnew  := TRCH->Z3_SLDM2 - SD4->D4_QTDEORI
			SD4->D4_QTDEORI += (TRCH->Z3_SLDM2 - SD4->D4_QTDEORI )
//			SD4->D4_QUANT += (TRCH->Z3_SLDM2 - nSldOld) // - SD4->D4_QUANT)
//			SD4->D4_QTDEORI += TMPZ3->Z3_QTAJUS
//			SD4->D4_QUANT 	+= TMPZ3->Z3_QTAJUS
			MsUnlock('SD4')
//			Alert(Substr(SD4->D4_COD,1,6)+' '+SD4->D4_OP+' ANTES: Qtde Total -> '+cValToChar(SD4->D4_QTDEORI)+' Qtde Saldo-> '+cValToChar(SD4->D4_QUANT))
		//Faz acerto na quantidade empenhada do produto SB2
			dbSelectArea('SB2')
			dbSetOrder(1) //B2_FILIAL+B2_COD+B2_LOCAL
			if dbSeek(xFilial('SB2')+SD4->(D4_COD+D4_LOCAL))
				RecLock('SB2',.F.)
				SB2->B2_QEMP += (TRCH->Z3_SLDM2 - SD4->D4_QTDEORI )
				MsUnLock('SB2')
			endif
		endif
	endif
	TMPZ3->(dbSkip())
	SD4->(dbCloseArea())
enddo

dbSelectArea('TRBZ3')
dbGotop()
	while !TRBZ3->(eof())   
		dbSelectArea('SC2')
		dbSetOrder(1)
		dbSeek(xFilial('SC2')+TRBZ3->(C2_NUM+C2_ITEM+C2_SEQUEN))
			cLocApt:= SC2->C2_LOCAL
			 nPos:= ASCAN(aCoBrwTMPZ3,{|x| Substr(x[2],1,6) == Substr(TRBZ3->Z3_PRODUTO,1,6)})
/*				for i:= 1 to len(aCoBrwTMPZ3)
					Alert('Prod array |'+aCoBrwTMPZ3[i][1]+'| Produ procurado-> |'+TRBZ3->Z3_PRODUTO+'|' )
				next i
  */		
			 if nPos > 0 
				nqt := SC2->C2_QUANT - (SC2->C2_QUJE + aCoBrwTMPZ3[nPos][7])
//				Alert('QUANT -> '+cValToChar(iif((SC2->C2_QUANT-SC2->C2_QUJE) == nqt, nqt, iif(TRBZ3->Z3_QTDE <= SC2->C2_QUANT, TRBZ3->Z3_QTDE, SC2->C2_QUANT))))
			 else
			 	nqt := 0
			 endif
//			 Alert('Produto -> '+SC2->C2_PRODUTO+ ' Array-> '+aCoBrwTMPZ3[nPos][1])
//		alert('nPos -> '+cValToChar(nPos)+' nQtde-> '+cValToChar(nqt)) 
		
		if nqt > 0
		
		// Verifica grupo do produto no plano de produção para validar Centro de Custo
		dbSelectArea('SB1')
		dbSetOrder(1)
		dbSeek(xFilial('SB1')+SZP->ZP_PRODUTO)
		cGrupo:= SB1->B1_GRUPO 
		//Alert('|'+SZP->ZP_PRODUTO+'|')
		//Alert('|'+cGrupo+'|')
			
			aCab := {}
			AAdd( aCab, {'D3_FILIAL'		,		 XFILIAL('SD3' )													,	nil							})
			AAdd( aCab, {'D3_TM'			,		 '500'																,	nil							})
			AAdd( aCab, {'D3_COD'			,		 TRBZ3->Z3_PRODUTO													,	nil							})
			AAdd( aCab, {'D3_OP'			,		 TRBZ3->(C2_NUM+C2_ITEM+C2_SEQUEN) 									,	nil							})
//			AAdd( aCab, {'D3_QUANT'		    ,		 iif((SC2->C2_QUANT-SC2->C2_QUJE) == nqt, nqt, TRBZ3->Z3_QTDE)		,	nil							})
			AAdd( aCab, {'D3_QUANT'		    ,		 iif((SC2->C2_QUANT-SC2->C2_QUJE) == nqt, nqt, iif(TRBZ3->Z3_QTDE <= SC2->C2_QUANT, TRBZ3->Z3_QTDE, SC2->C2_QUANT))		,	nil							})
//			alert('Apontando -> '+cValToChar(TRBZ3->Z3_QTDE)+' Pecas... OPS: '+TRBZ3->(C2_NUM+C2_ITEM+C2_SEQUEN))
			AAdd( aCab, {'D3_LOCAL'		    ,		 cLocApt															,	nil							})
			AAdd( aCab, {'D3_DOC'			,		 TRBZ3->C2_NUM 														,	nil							})
			AAdd( aCab, {'D3_EMISSAO'	    ,		 dDataBase 															,	nil							})
			//AAdd( aCab, {'D3_CC'			,		 IIF(Alltrim(cGrupo)=='45','320701',IIF(Alltrim(cGrupo)=='55OM','320702', IIF(Alltrim(cGrupo)=='55EX','320703',' ')))	,	nil			   				})
			AAdd( aCab, {'D3_CC'			,		 SZP->ZP_CC	,	nil			   				})
			AAdd( aCab, {'D3_CF'			,		 'PR0'																,	nil							})
			AAdd( aCab, {'D3_PARCTOT'	    ,		 iif((SC2->C2_QUANT-SC2->C2_QUJE) == nqt ,'T','P')					,	nil							})
			AAdd( aCab, {'D3_PARTIDA'	    ,		 SC2->C2_OPMIDO														,	nil							})
			AAdd( aCab, {'D3_ATLOBS'	    ,	     'ROTINA NOVA'  													,	nil							})
			cMdrEtPlan := SC2->C2_OPMIDO // Utilizado para imprimir o código do plano na etiqueta.
			lMsErroAuto := .f.
			msExecAuto({|x,Y| Mata250(x,Y)},aCab,3)
			//
			If lMsErroAuto
				MostraErro()
				
			else

			    //--------------------------------------------
			    // Impressão das Etiquetas
			    //--------------------------------------------        
			    If xFilial('SC2') $ '08|19'
				    SB1->( dbSetOrder(1) )
				    SB1->( dbSeek( xFilial("SB1") +  TRBZ3->Z3_PRODUTO ) )
				 	aParam    := {}
					nQtOpEtiq := iif((SC2->C2_QUANT-SC2->C2_QUJE) == nqt, nqt, iif(TRBZ3->Z3_QTDE <= SC2->C2_QUANT, TRBZ3->Z3_QTDE, SC2->C2_QUANT))			 	
					AAdd( aParam, 1     ) // quantidade da etiqueta
					AAdd( aParam, nil           ) // Codigo do separador
					AAdd( aParam, nil           ) // Código da etiqueta, no caso de uma reimpressão
					AAdd( aParam, nQtOpEtiq             ) // Quantidade de etiquetas
					AAdd( aParam, nil           ) // nota de entrada
					AAdd( aParam, nil           ) // Serie da nota de entrada
					AAdd( aParam, nil           ) // Codigo do fornecedor da nota de entrada
					AAdd( aParam, nil           ) // Loja do fornecedor da nota de entrada
					AAdd( aParam, cLocApt       ) // Armazem
					AAdd( aParam, TRBZ3->C2_NUM ) // Numero da OP
					AAdd( aParam, nil           ) // Numero sequencial da etiqueta quando for reimpressao
		
					AAdd( aParam, If(SB1->B1_RASTRO=="L", TRBZ3->C2_NUM, nil ) ) // Numero do Lote. Neste caso deve ser o mesmo numero da OP
	
					AAdd( aParam, nil           ) // Sublote
	
					/*If SD3->D3_DTVALID == SD3->D3_EMISSAO
						AAdd( aParam, SD3->D3_EMISSAO+1825 ) // Usuário não digitou a Data de Validade então automaticamente ficará com 5 anos 
			    	Else
						AAdd( aParam, SD3->D3_DTVALID )      // Data de Validade com periodo informado pelo usuário
			    	EndIf
	  				*/
	
					AAdd( aParam, nil           ) // Data de Validade
					AAdd( aParam, nil           ) // Centro de Custos
					AAdd( aParam, cLocApt       ) // Local de Origem
	
					AAdd( aParam, nil           ) // Local cOPREQ    := If(len(paramixb) >=17,paramixb[17],NIL)
					AAdd( aParam, nil           ) // Local cNumSerie := If(len(paramixb) >=18,paramixb[18],NIL)
					AAdd( aParam, nil           ) // Local cOrigem   := If(len(paramixb) >=19,paramixb[19],NIL)
					AAdd( aParam, nil           ) // Local cEndereco := If(len(paramixb) >=20,paramixb[20],NIL)
					AAdd( aParam, nil           ) // Local cPedido   := If(len(paramixb) >=21,paramixb[21],NIL)
					AAdd( aParam, 0             ) // Local nResto    := If(len(paramixb) >=22,paramixb[22],0)
					AAdd( aParam, nil           ) // Local cItNFE    := If(len(paramixb) >=23,paramixb[23],NIL)            	            

					AAdd( aParam, nil           ) // Local cItNFE    := If(len(paramixb) >=24,paramixb[23],NIL)            	            
					AAdd( aParam, cParSN        ) // Local cParSN    := If(len(paramixb) >=25,paramixb[25],NIL)    (parametro incluido por Antonio)        	            
	            	                              //                                                               (para impressão ou nao de etq)
					ExecBlock("IMG01",,,aParam )               	                                                           
					_xFlag:='S'
				Endif

				dbSelectArea('SZ3')
				dbSetOrder(1) //Z3_FILIAL+Z3_PLANO+Z3_NUMOP       
//				alert('vai pesquisar o plano -> |'+cPlano+"'| OP-> |"+PADR(TRBZ3->C2_NUM,11)+"| "+" FILIAL->"+xFilial("SZ3"))
				if dbSeek(xFilial('SZ3')+PADR(cPlano,20)+PADR(TRBZ3->C2_NUM,11))
//					alert('Plano encontrado-> ' +SZP->Z3_NUMOP +' APONT-> '+SZ3->Z3_OPAPONT)
					while !SZ3->(eof()).and.SZ3->Z3_NUMOP == PADR(TRBZ3->C2_NUM,11)
//						Alert('Circulando...')
						if SZ3->Z3_STATUS == 'B' .and. SZ3->Z3_OPAPONT == 'N'
//						Alert('ENCONTRADO')
							RecLock('SZ3', .F.)
							SZ3->Z3_OPAPONT := 'S'
							MsUnLock('SZ3')
						endif 
					SZ3->(dbSkip())
					enddo
				endif
				nCount++
			endif 

		endif
		TRBZ3->(dbSkip())

	enddo


	////////////momento em que ira gerar a etiqueta de kit(carrinho) caso seja carrinho(lectra) - antonio 05/06/18

	If _xFlag == 'S'
    
	    SBZ->( dbSetOrder(1) )
	    IF SBZ->( dbSeek( xFilial("SBZ") + SZP->ZP_PRODUTO ) )
	
			If SBZ->BZ_XCARRI == 'S'

				//	clocapt:='01'    //usado somente para teste no caso de ja ter sido impressa a etiqueta. antonio 12/06/18

				If MsgYesNo('Emitir etiqueta de Carrinho(Kit) (S/N)?' )
		
				    //--------------------------------------------
				    // Impressão das Etiquetas de kit (carrinho)
				    //--------------------------------------------        
				    SB1->( dbSetOrder(1) )
				    SB1->( dbSeek( xFilial("SB1") + SZP->ZP_PRODUTO ) )
				 	aParam    := {}                  
					nQtOpEtiq := SZP->ZP_QUANT / SBZ->BZ_ZZQTCXA 
					AAdd( aParam, SZP->ZP_QUANT / nQtOpEtiq   ) // quantidade da etiqueta
					AAdd( aParam, nil           ) // Codigo do separador
					AAdd( aParam, nil           ) // Código da etiqueta, no caso de uma reimpressão
					AAdd( aParam, nQtOpEtiq             ) // Quantidade de etiquetas
					AAdd( aParam, nil           ) // nota de entrada
					AAdd( aParam, nil           ) // Serie da nota de entrada
					AAdd( aParam, nil           ) // Codigo do fornecedor da nota de entrada
					AAdd( aParam, nil           ) // Loja do fornecedor da nota de entrada
					AAdd( aParam, cLocApt       ) // Armazem
					AAdd( aParam, nil           ) // Numero da OP
					AAdd( aParam, nil           ) // Numero sequencial da etiqueta quando for reimpressao
		
					AAdd( aParam, If(SB1->B1_RASTRO=="L", NIL, nil ) ) // Numero do Lote. Neste caso deve ser o mesmo numero da OP
		
					AAdd( aParam, nil           ) // Sublote
					AAdd( aParam, nil           ) // Data de Validade
					AAdd( aParam, nil           ) // Centro de Custos
					AAdd( aParam, cLocApt       ) // Local de Origem
		
					AAdd( aParam, nil           ) // Local cOPREQ    := If(len(paramixb) >=17,paramixb[17],NIL)
					AAdd( aParam, nil           ) // Local cNumSerie := If(len(paramixb) >=18,paramixb[18],NIL)
					AAdd( aParam, nil           ) // Local cOrigem   := If(len(paramixb) >=19,paramixb[19],NIL)
					AAdd( aParam, nil           ) // Local cEndereco := If(len(paramixb) >=20,paramixb[20],NIL)
					AAdd( aParam, nil           ) // Local cPedido   := If(len(paramixb) >=21,paramixb[21],NIL)
					AAdd( aParam, 0             ) // Local nResto    := If(len(paramixb) >=22,paramixb[22],0)
					AAdd( aParam, nil           ) // Local cItNFE    := If(len(paramixb) >=23,paramixb[23],NIL)            
		            
					If SX6->(dbSeek(xFilial("CB0")+'MV_NUMKIT' ))
						RecLock('SX6', .F.)
						nCONTEUDO:=VAL(SX6->X6_CONTEUD)+1
						cConteudo:=Alltrim(str(nCONTEUDO))
						SX6->X6_CONTEUD := cConteudo
						MsUnlock()
					EndIf

					ExecBlock("IMG11",,,aParam )               	

				EndIf
	
			EndIf

  		EndIf

	EndIf

	Alert('Executado com sucesso....'+chr(13)+chr(13)+'Total de fichas apontadas '+cValToChar(nCount))
	oDlg1:end()	
return

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Funcao que vai mostrar a localizacao da ficha dentro do plano de producao...
//em que status a mesma se encontra...
////////////////////////////////////////////////////////////////////////////////////////////////////////////
static function locFic()
//Local nPosOP 	:= AScan(aCoBrwTMPZ3,{|x|AllTrim(x[1]) == "Z3_NUMOP"})
//obrProds:SetArray(acPrds)
//obrProds:bLine := { || { acPrds[obrProds:nAt,1],acPrds[obrProds:nAt,2],acPrds[obrProds:nAt,3],acPrds[obrProds:nAt,4]   }  }
Local nOpc := GD_INSERT+GD_DELETE+GD_UPDATE
Local nOpc := GD_INSERT+GD_DELETE+GD_UPDATE
Private aCoBrwFas := {}
Private aCoBrwFic := {}
Private aHoBrwFas := {}
Private aHoBrwFic := {}
Private cGetPlano  := Space(12)
Private cGetProd   := space(60)
Private nGetQtde   := 0
Private cGetCli    := space(60)
Private dPrev	   := dDataBase
Private dGetEmis   := dDataBase
Private noBrwFas  := 0
Private noBrwFic  := 0
Private oBrFics, cCamp, obrFase, cFase
Private acFics := {}

SetPrvt("oFont1","oDlgStat","oSayPlano","oGrpFic","oBrwFic","oSBtnOK","oSBtnCanc","oRMenu1","oGrpFas")
SetPrvt("oGetPlano")


oFont1     := TFont():New( "MS Sans Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oDlgStat   := MSDialog():New( 095,240,650,1228,"Status Plano Producao",,,.F.,,,,,,.T.,,,.T. )
oSayPlano  := TSay():New( 220,010,{||"PLANO"},oDlgStat,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oSayEmiss  := TSay():New( 234,080,{||"EMISSAO:"},oDlgStat,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oSayCli    := TSay():New( 234,172,{||"CLIENTE:"},oDlgStat,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oSayProd   := TSay():New( 255,010,{||"PRODUTO:"},oDlgStat,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oSayQtde   := TSay():New( 255,272,{||"QTDE: "},oDlgStat,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oSayPrev   := TSay():New( 255,340,{||"PREVISAO: "},oDlgStat,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,012)
oGrpFic    := TGroup():New( 004,004,144,484,"Relação das Fichas/Status",oDlgStat,CLR_BLACK,CLR_WHITE,.T.,.F. )
MHoBrwFic()
MCoBrwFic()
Inc_Fic()

@ 12,10 LISTBOX oBrFics VAR cCamp Fields HEADER "Num.Ficha","Dt.Ficha" , "Peca","Qtde Origina","Saldo M2","Status","Lado"  ON CHANGE ChngGrpFics() SIZE 469,125  pixel // ON CHANGE CHNG() ON DBLCLICK Ad_PrLst()
oBrFics:SetArray(aCoBrwFic)
oBrFics:bLine := { || { aCoBrwFic[oBrFics:nAt,1], aCoBrwFic[oBrFics:nAt,2], aCoBrwFic[oBrFics:nAt,3], aCoBrwFic[oBrFics:nAt,4], aCoBrwFic[oBrFics:nAt,5], aCoBrwFic[oBrFics:nAt,6], aCoBrwFic[oBrFics:nAt,7]   }  }


//GoRMenu1   := TGroup():New( 224,004,264,112,"Filtro de Fichas...",oDlgStat,CLR_BLACK,CLR_WHITE,.T.,.F. )
//oRMenu1    := TRadMenu():New( 228,010,{"Todas as Fichas","Apenas Fichas Pendentes","Apenas Fichas Baixadas"},,oDlgStat,,,CLR_BLACK,CLR_WHITE,"",,,088,13,,.F.,.F.,.T. )
oGrpFas    := TGroup():New( 148,004,220,484,"Fases Apontadas...",oDlgStat,CLR_BLACK,CLR_WHITE,.T.,.F. )
MHoBrwFas()
MCoBrwFas()
//aCoBrwFas    := {}
@ 155,10  LISTBOX obrFase VAR cFase Fields HEADER 'Num.Ficha','Dta Ficha','Dt Apont','Status Atual' , 'Material' , "Descricao", "Qtde ","Total M2" ,"M2 Padrao",'Usuario'  SIZE 469,060  pixel //ON DBLCLICK clk_LST() pixel // ON CHANGE CHNG() ON DBLCLICK Ad_PrLst()
obrFase:SetArray(aCoBrwFas)
obrFase:bLine := { || { aCoBrwFas[obrFase:nAt,1],aCoBrwFas[obrFase:nAt,2],aCoBrwFas[obrFase:nAt,3],aCoBrwFas[obrFase:nAt,4] , aCoBrwFas[obrFase:nAt,5] , aCoBrwFas[obrFase:nAt,6], aCoBrwFas[obrFase:nAt,7], aCoBrwFas[obrFase:nAt,8], aCoBrwFas[obrFase:nAt,9], aCoBrwFas[obrFase:nAt,10]  }  }

cGetPlano := SZP->ZP_OPMIDO
nGetQtde  := SZP->ZP_QUANT
dGetPrev  := SZP->ZP_DATPRF
dGetEmis  := SZP->ZP_EMISSAO
cGetCli   := SZP->ZP_CLIENTE+'-'+SZP->ZP_LOJA+' '+ALLTRIM( Posicione('SA1',1,xFilial('SA1')+SZP->(ZP_CLIENTE+ZP_LOJA),"A1_NOME"))
cGetProd  := Substr(SZP->ZP_PRODUTO,1,6)+"-"+ ALLTRIM( Posicione('SB1',1,xFilial('SB1')+SZP->ZP_PRODUTO,"B1_DESC") )
oGetPlano  := TGet():New( 230,10,{|u| If(PCount()>0,cGetPlano:=u,cGetPlano)},oDlgStat,060,010,'',,CLR_HBLUE,CLR_LIGHTGRAY,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetPlano",,)
oGetEmis  := TGet():New( 230,120,{|u| If(PCount()>0,dGetEmis:=u,dGetEmis)},oDlgStat,050,010,'',,CLR_HBLUE,CLR_LIGHTGRAY,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dGetEmis",,)
oGetCli   := TGet():New( 230,215,{|u| If(PCount()>0,dGetCli:=u,cGetCli)},oDlgStat,220,010,'',,CLR_HBLUE,CLR_LIGHTGRAY,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dGetCli",,)

oGetProd   := TGet():New( 252,052,{|u| If(PCount()>0,cGetProd:=u,cGetProd)},oDlgStat,220,010,'',,CLR_HBLUE,CLR_LIGHTGRAY,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetProd",,)
oGetQtde   := TGet():New( 252,300,{|u| If(PCount()>0,nGetQtde:=u,nGetQtde)},oDlgStat,30,010,'',,CLR_HBLUE,CLR_LIGHTGRAY,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetProd",,)
oGetPrev   := TGet():New( 252,390,{|u| If(PCount()>0,dGetPrev:=u,dGetPrev)},oDlgStat,50,010,'',,CLR_HBLUE,CLR_LIGHTGRAY,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dGetPrev",,)
oGetPlano:Disable()
oGetProd:Disable()
oGetQtde:Disable()
oGetPrev:Disable()

//oSBOK      := SButton():New( 036,026,1,{||nOpc:=1,oDlg1:End()},oDlg1,,"", )

DEFINE SBUTTON FROM 240,452 TYPE 1  OF oDlgStat ACTION oDlgStat:END() ENABLE
DEFINE SBUTTON FROM 252,452 TYPE 2  OF oDlgStat ACTION oDlgStat:END() ENABLE


//oSBtnOK    := SButton():New( 240,452,1,,oDlgStat,,{|| close(oDlgStat)}, )
//oSBtnCanc  := SButton():New( 240,420,2,,oDlgStat,,{|| close(oDlgStat)}, )


oDlgStat:Activate(,,,.T.)

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ?MHoBrwFic() - Monta aHeader da MsNewGetDados para o Alias: SZ3
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrwFic()

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SZ3")
While !Eof() .and. SX3->X3_ARQUIVO == "SZ3"
   If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL  .and. (SX3->X3_CAMPO == 'Z3_NUMFC  ';
   		.or. SX3->X3_CAMPO == 'Z3_MATERIA' .or. SX3->X3_CAMPO == 'Z3_STATUS ' .or. SX3->X3_CAMPO == 'Z3_QTDE   ';
   		.or. SX3->X3_CAMPO == 'Z3_SLDM2  '.or. SX3->X3_CAMPO == 'Z3_DTFICHA'.or. SX3->X3_CAMPO == 'Z3_LADO   '  )
      noBrwFic++
      Aadd(aHoBrwFic,{Trim(X3Titulo()),;
           SX3->X3_CAMPO,;
           SX3->X3_PICTURE,;
           SX3->X3_TAMANHO,;
           SX3->X3_DECIMAL,;
           "",;
           "",;
           SX3->X3_TIPO,;
           "",;
           "" } )
   EndIf
   DbSkip()
End

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ?MCoBrwFic() - Monta aCols da MsNewGetDados para o Alias: SZ3
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MCoBrwFic()

Local aAux := {}
Local nI

Aadd(aCoBrwFic,Array(noBrwFic+1))
For nI := 1 To noBrwFic
   aCoBrwFic[1][nI] := CriaVar(aHoBrwFic[nI][2])
Next
aCoBrwFic[1][noBrwFic+1] := .F.

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ?MHoBrwFas() - Monta aHeader da MsNewGetDados para o Alias: SZ7
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrwFas()

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SZ7")
While !Eof() .and. SX3->X3_ARQUIVO == "SZ7"
   If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
      noBrwFas++
      Aadd(aHoBrwFas,{Trim(X3Titulo()),;
           SX3->X3_CAMPO,;
           SX3->X3_PICTURE,;
           SX3->X3_TAMANHO,;
           SX3->X3_DECIMAL,;
           "",;
           "",;
           SX3->X3_TIPO,;
           "",;
           "" } )
   EndIf
   DbSkip()
End

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ?MCoBrwFas() - Monta aCols da MsNewGetDados para o Alias: SZ7
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MCoBrwFas()

Local aAux := {}
Local nI

Aadd(aCoBrwFas,Array(noBrwFas+1))
For nI := 1 To noBrwFas
   aCoBrwFas[1][nI] := CriaVar(aHoBrwFas[nI][2])
Next
aCoBrwFas[1][noBrwFas+1] := .F.

Return


//	alert('Em desenvolvimento...|'+cSayTitPln+'|'+' OP: '+aCoBrwTMPZ3[n][1])
//	Alert(aCoBrwTMPZ3:nAt[1])
return

//////////////////////////////////////////////////////////////////////////////////////
//Funcao para Incluir as Fichas no ARRAY
//////////////////////////////////////////////////////////////////////////////////////
Static function Inc_Fic()
local cQFic  := ""        
local nCountB:= 0
local nCountA:= 0
local acFics := {}
local cStatus:= ""
cQFic := " Select Z3_NUMFC, Z3_STATUS, Z3_MATERIA, Sum(Z3_QTDE) Z3_QTDE, Sum(Z3_SLDM2) Z3_SLDM2, Z3_DTFICHA, Z3_LADO " 
cQFic += " from SZ3010 SZ3 where SZ3.D_E_L_E_T_ = ' ' and Z3_FILIAL ='"+xFilial('SZ3')+"' "
cQFic += " and Substring(Z3_DTFICHA,1,4) = '"+SZP->ZP_ANO+"' and Z3_PLANO = '"+SZP->ZP_OPMIDO+"' " 
cQFic += " group by Z3_NUMFC, Z3_STATUS, Z3_MATERIA, Z3_DTFICHA, Z3_LADO " 

if Select('TRBST') > 0
	dbSelectArea('TRBST')
	dbCloseArea()
endif
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQFic),'TRBST',.T.,.T.)
TcSetField("TRBST", "Z3_DTFICHA", "D")
dbSelectArea("TRBST")
dbGotop()
aCoBrwFic := {} 
while !TRBST->(eof()) 
	if TRBST->Z3_STATUS == 'B' 
		cStatus:= 'BAIXADA'
	else
		cStatus:= 'ABERTA'
	endif
	Aadd(aCoBrwFic, {TRBST->Z3_NUMFC,  TRBST->Z3_DTFICHA, TRBST->Z3_MATERIA, TRBST->Z3_QTDE, TRBST->Z3_SLDM2, cStatus, TRBST->Z3_LADO, .F.}) 
	if TRBST->Z3_STATUS == 'B' 
		nCountB++
	else
		nCountA++
	endif
	TRBST->(dbSkip())
enddo
if len(aCoBrwFic) == 0
	Aadd(aCoBrwFic, {"FICHAS NAO GERADA",  dDataBase, "N/A", 0, 0, "N/A", "", .F.}) 
endif
return()


///////////////////////////////////////////////////////////////////////////////////////////////////////
//Funcao com objeito de carregar as FASES da Ficha para acompanhamento dos usuarios
///////////////////////////////////////////////////////////////////////////////////////////////////////
static function CarrFase(cOri)
Alert('Origem-> '+cOri+' Ficha ' +aCoBrwFic[n][1])

return()


static function ChngGrpFics()
local cFics  := aCoBrwFic[oBrFics:nAt,1]
local nQtdMtp:= 0 //Metros Padrao
local nQtdMtu:= 0 //Metros Utilizados
local cFase  :=' '
aCoBrwFas := {}
///Alert('Ficha-> '+aCoBrwFic[oBrFics:nAt,1])
dbSelectArea('SZ7')
dbSetOrder(1)
if dbSeek(xFilial('SZ7')+cFics)
	while !SZ7->(eof()).and.xFilial('SZ7') == SZ7->Z7_FILIAL .and. cFics == SZ7->Z7_NUMFC 
		do case 
			Case SZ7->Z7_FASE == '00 ' 
				nQtdMtp := SZ7->Z7_M2APONT
				cFase := '00-INICIO DA FICHA' 
			Case SZ7->Z7_FASE == '01 ' 
				nQtdMtu := SZ7->Z7_M2APONT
				cFase := '01-SEPARACAO COURO'
			Case SZ7->Z7_FASE == '02 ' 
			 	cFase := '02-CORTE' 
			Otherwise
				cFase := SZ7->Z7_FASE
		endcase 
		AADD(aCoBrwFas, { SZ7->Z7_NUMFC,  SZ7->Z7_DTDIGIT, SZ7->Z7_DTAPON, cFase, aCoBrwFic[oBrFics:nAt,3], Posicione('SB1',1,xFilial('SB1')+aCoBrwFic[oBrFics:nAt,3],"B1_DESC"), SZ7->Z7_QTAPON, nQtdMtp, nQtdMtu, SZ7->Z7_USDIGIT })
	SZ7->(dbSkip())
	enddo   
else
	AADD(aCoBrwFas, { 'FICHA NAO INICIADA',  dDataBase, dDataBase, 'NA', 'N/A', 'N/A', 0, 0,0, 'N/A' })
endif

obrFase:SetArray(aCoBrwFas)
//obrFase:bLine := { || { aCoBrwFas[obrFase:nAt,1],aCoBrwFas[obrFase:nAt,2],aCoBrwFas[obrFase:nAt,3],aCoBrwFas[obrFase:nAt,4] , aCoBrwFas[obrFase:nAt,5] , aCoBrwFas[obrFase:nAt,6], aCoBrwFas[obrFase:nAt,7], aCoBrwFas[obrFase:nAt,8], aCoBrwFas[obrFase:nAt,9], aCoBrwFas[obrFase:nAt,10]  }  }
obrFase:bLine := { || { aCoBrwFas[obrFase:nAt,1],aCoBrwFas[obrFase:nAt,2],aCoBrwFas[obrFase:nAt,3],aCoBrwFas[obrFase:nAt,4] , aCoBrwFas[obrFase:nAt,5] , aCoBrwFas[obrFase:nAt,6], aCoBrwFas[obrFase:nAt,7], aCoBrwFas[obrFase:nAt,8], aCoBrwFas[obrFase:nAt,9], aCoBrwFas[obrFase:nAt,10]  }  }
obrFase:Refresh()

return()

////////////////////////////////////////////////////////////////////
//Chamar o status da ficha no tela inicial
////////////////////////////////////////////////////////////////////
user function StatFic() 
	locFic() 
return