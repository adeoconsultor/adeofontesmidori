#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


///////////////////////////////////////////////////////////////////////////////
//Rotina de inclusao de OP na medideira - PNP1
//Permite ao usuario selecionar um produto que contenha estrutura, gera 
//a Ordem de Producao e faz o apontamento para o mesmo automáticamente
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br - 06-02-2012
//Manutenção na função AGF_PROCME para antender as solicitações do sr. Thiago para inclusão
//das informações de VQ e M2 inicial e aproveitamento de metragem. - 22-11-2012
///////////////////////////////////////////////////////////////////////////////
User Function VSS_MEDACA()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cGetCavMes := Space(3)
Private cGetNumPar := Space(11)
Private cGetProd   := Space(6)
Private nGetQtdM2  := 0
Private nGetQtdVq  := 0
Private nGetQtdM2I := 0
Private nGetQtdVqI := 0
Private cSayMed	   := '0,00' //(cSayMVM1 / cSayMVI1)
Private cSayCodigo := Space(6)
Private cSayCodUsu := RetCodUsr()
Private cSayData   := Space(10)
Private cSayData1  := dDatabase
Private cSayDesc   := Space(10)
Private cSayDesc1  := Space(50)
Private cSayGrupo  := Space(4)
Private cSayGrupo1 := Space(30)
Private cSayM2VQ   := Space(10)
Private cSayM2VQ1  := '0,00'
Private cSayM2VQ1I := '0,00'
Private cSayMedAca := Space(10)
Private cSayNomeUs := cUsuario
Private cSayOP     := Space(6)
Private cSayOP1    := 'INSERINDO...' //Soma1(GetSxeNum('SC2'))
Private cSayProc   := Space(10)
Private cSayQtdM2  := Space(10)
Private cSayQtdVQ  := Space(10)
Private cSayUM     := Space(4)
Private cSayUM1    := Space(4)
Private nTProd1
Private nLocal

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oFont2","oFont3","oDlg1","oSayProc","oSayMedAcab","oSayData","oSayData1","oSayOP","oSayOP1","oSayMed","oSayTProd","oTProd1")
SetPrvt("oSayDesc","oSayDesc1","oSayUM","oSayUM1","oSayGrupo","oSayGrupo1","oSayQtdVQ","oSayQtdM2","oSayM2VQ","oSayQtdVQI","oSayQtdM2I","oSayM2VQI")
SetPrvt("oSayM2VQ1","oSayM2VQ1I","oGetProd","oGetQtdVq","oGetQtdM2","oGetNumPart","oGetCavMesa","oPanel1","oGetQtdVqI","oGetQtdM2I","oSayPer")
SetPrvt("oSayCodUsu1","oSayNomeUsu","oSayNomeUsu1","oBtnConfirm","oBtnCancel")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oFont3     := TFont():New( "MS Sans Serif",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 105,312,671,1099,"Processo Medideira Acabamento...",,,.F.,,,,,,.T.,,oFont1,.T. )
oSayProc   := TSay():New( 015,007,{||"PROCESSO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,101,017)
oSayMedAca := TSay():New( 015,112,{||"MEDIDEIRA ACABAMENTO"},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,268,023)
oSayData   := TSay():New( 032,008,{||"DATA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,024)
oSayData1  := TSay():New( 032,112,{|u| If(PCount()>0, cSayData1:=u, cSayData1)},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,092,021)
//oGdtApont   := TGet():New( 078,339,{|u| If(PCount()>0,cGdtApont:=u,cGdtApont)},oGrpItens,046,009,'@r 99/99/9999',{|| ! empty( cGdtApont ) .and. VldtApon()},CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGdtApont",,)
oSayOP     := TSay():New( 032,215,{||"OP N²"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,065,025)
oSayOP1    := TSay():New( 032,288,{|u| If(PCount()>0, cSayOP1:=u, cSayOP1)},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,092,022)
oSayCodigo := TSay():New( 052,008,{||"CÓDIGO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,084,018)
oSayDesc   := TSay():New( 052,111,{||"DESCRICAO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,105,023)
oSayDesc1  := TSay():New( 067,112,{|u| If(PCount()>0, cSayDesc1:=u, cSayDesc1)},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,268,024)
oSayUM     := TSay():New( 090,008,{||"UM"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,089,018)
oSayUM1    := TSay():New( 090,50,{|u| If(PCount()>0, cSayUM1:=u, cSayUM1)},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,081,022)
oSayGrupo  := TSay():New( 090,115,{||"GRUPO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,070,022)
oSayGrupo1 := TSay():New( 090,180,{|u| If(PCount()>0, cSayGrupo1:=u, cSayGrupo1)},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,104,022)
oSayTProd  := TSay():New( 090,235,{||"TIPO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,089,012)
oSayQtdVQ  := TSay():New( 110,008,{||"QTDE VQ"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,089,018)
oSayQtdM2  := TSay():New( 110,115,{||"QTDE M2"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,018)
oSayM2VQ   := TSay():New( 110,235,{||"M2 / VQ"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,089,018)
oSayM2VQ1  := TSay():New( 125,235,{|u| If(PCount()>0, cSayM2VQ1:=u, cSayM2VQ1) },oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,104,022)
oSayQtdVQI := TSay():New( 150,008,{||"QTDE VQ INICIAL"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,089,018)
oSayQtdM2I := TSay():New( 150,115,{||"QTDE M2 INICIAL"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,018)
oSayM2VQI  := TSay():New( 150,235,{||"M2 / VQ"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,089,018)
oSayM2VQ1I := TSay():New( 165,235,{|u| If(PCount()>0, cSayM2VQ1I:=u, cSayM2VQ1I) },oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,104,022)
oSayPor    := TSay():New( 125,295,{||"Aprov Metragem"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,010)
oSayMed    := TSay():New( 148,310,{|u| If(PCount()>0, cSayMed:=u, cSayMed)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,094,010)
oSayPer    := TSay():New( 148,338,{||"%"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,073,010)
oSayNumPar := TSay():New( 195,008,{||"N² PARTIDA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,103,018)
oSayCaval  := TSay():New( 190,200,{||"CAVALETE / "},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,103,018)
oSayMesa   := TSay():New( 210,208,{||"MESA N."},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,078,018)
oGetProd   := TGet():New( 065,008,{|u| If(PCount()>0,cGetProd:=u,cGetProd)},oDlg1,086,020,'',{|| Vld_Prd(cGetProd)},CLR_HBLUE,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetProd",,)
oTProd1    := TComboBox():New(090,265,{|u| If(PCount()>0,nTProd1:=u,nTProd1)},{"--SELECIONE--","NORMAL","VENDA"},86,20,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,oFont1,"",,,,,,,nTProd1 )
oGetQtdVq  := TGet():New( 124,008,{|u| If(PCount()>0,nGetQtdVq:=u,nGetQtdVq)},oDlg1,086,020,'@E 99,999,999.99',{|| RefreshMedia(), CalcMedia(nGetQtdM2,nGetQtdVq)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtdVq",,)
oGetQtdM2  := TGet():New( 124,115,{|u| If(PCount()>0,nGetQtdM2:=u,nGetQtdM2)},oDlg1,086,020,'@E 99,999,999.99',{|| RefreshMedia(), CalcMedia(nGetQtdM2,nGetQtdVq)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtdM2",,)
oGetQtdVqI := TGet():New( 164,008,{|u| If(PCount()>0,nGetQtdVqI:=u,nGetQtdVqI)},oDlg1,086,020,'@E 99,999,999.99',{|| RefreshMedia(), CalcMediaI(nGetQtdM2I,nGetQtdVqI)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtdVqI",,)
oGetQtdM2I := TGet():New( 164,115,{|u| If(PCount()>0,nGetQtdM2I:=u,nGetQtdM2I)},oDlg1,086,020,'@E 99,999,999.99',{|| RefreshMedia(), CalcMediaI(nGetQtdM2I,nGetQtdVqI)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtdM2I",,)
oGetNumPar := TGet():New( 208,008,{|u| If(PCount()>0,cGetNumPart:=u,cGetNumPart)},oDlg1,144,020,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetNumPart",,)
oGetCavMes := TGet():New( 197,280,{|u| If(PCount()>0,cGetCavMesa:=u,cGetCavMesa)},oDlg1,100,025,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetCavMesa",,)
oPanel1    := TPanel():New( 260,000,"",oDlg1,,.F.,.F.,,,388,016,.T.,.F. )
oSayCodUsu := TSay():New( 005,004,{||"CODIGO USUÁRIO"},oPanel1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
oSayCodUsu1:= TSay():New( 005,070,{|u| If(PCount()>0, cSayCodUsu:=u, cSayCodUsu)},oPanel1,,oFont3,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,031,008)
oSayNomeUs := TSay():New( 005,117,{||"NOME USUARIO"},oPanel1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,051,008)
oSayNomeUs1:= TSay():New( 006,174,{|u| If(PCount()>0, cSayNomeUs:=u, cSayNomeUs)},oPanel1,,oFont3,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,198,008)
oBtnConfir := TButton():New( 236,280,"&CONFIMAR",oDlg1,{|| VSS_GEROP()} ,096,020,,oFont1,,.T.,,"",,,,.F. )
oBtnCancel := TButton():New( 237,177,"CANCE&LAR",oDlg1,{|| oDlg1:End()} ,096,020,,oFont1,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return
                                                                        


Static Function Vld_Prd(cCod)
local lRet := .F. 
DbSelectArea('SB1')
DbSetOrder(1)

IF DbSeek( xFilial('SB1') + cCod )
	cSayDesc1		:= SB1->B1_DESC           
	cSayUM1		    := SB1->B1_UM
	cSayGrupo1		:= SB1->B1_GRUPO


	oSayDesc1:Refresh()
	oSayUM1:Refresh()
	oSayGrupo1:Refresh()
endif

lRet := Substr(Posicione('SG1',1,xFilial('SG1')+cCod,'G1_COD'),1,6)==Substr(cCod,1,6)

if !lRet
	Alert('O produto informado não tem estrutura cadastrada')
	oGetProd:SetFocus()
endif	


return lRet


Static Function CalcMedia(nGetQtdM2,nGetQtdVq)
public nMediaM2VQ := 0 
public cPerc
if nGetQtdVq > 0
	nMediaM2VQ := Round((nGetQtdM2 / nGetQtdVq),2)
	//Alert ('Media na medideira -> ' + cValToChar(nMediaM2VQ))
	cSayM2VQ1  := cValToChar(nMediaM2VQ)
	nPerc := Round(((Val(cSayM2VQ1) / Val(cSayM2VQ1I)) * 100),2)
	cSayMed := cValToChar(nPerc)
else
	nMediaM2VQ := '0,00' 
	nPerc := '0,00'
	cSayMVM1 := cValToChar(nMediaM2VQ)
	cSayMed := cValToChar(nPerc)	
endif                           

return 

Static Function CalcMediaI(nGetQtdM2I,nGetQtdVqI)
public nMedM2VQI := 0 
public cPerc2
if nGetQtdVqI > 0
	nMedM2VQI := Round((nGetQtdM2I / nGetQtdVqI),2)
	//Alert ('Media Inicial -> ' + cValToChar(nMedM2VQI))
	cSayM2VQ1I  := cValToChar(nMedM2VQI)
	nPerc2 := Round(((Val(cSayM2VQ1) / Val(cSayM2VQ1I)) * 100),2)
	cSayMed := cValToChar(nPerc2)	
else
	nMedM2VQI := '0,00' 
	nPerc2 := '0,00'
	cSayMVM1 := cValToChar(nMedM2VQI)
	cSayMed := cValToChar(nPerc2)	

endif
return 

Static Function RefreshMedia()
	oSayM2VQ1:Refresh()
	oSayM2VQ1I:Refresh()
	oSayMed:Refresh()	
return 


Static Function VSS_GEROP()
if cGetProd == space(6)
	Alert('Produto não informado, informe um código de produto.')
	Return
endif
if !Vld_Prd(cGetProd)
	return
endif

If nTProd1 == "--SELECIONE--"
	Alert("Informe o Tipo de Produção")
	nLocal := '0'
	Return
ElseIf nTProd1 == "NORMAL"
	nLocal := '10'
ElseIf nTProd1 == "VENDA"
	nLocal := '14'
EndIf  

if nGetQtdM2 == 0 
	Alert('Quantidade de M² não informado...')
	oGetQtdVq:SetFocus()
	Return
endif

if nGetQtdVq  == 0
	Alert('Quantidade de VQ não informado...')
	oGetQtdVq:SetFocus()
	Return
endif


if cGetCavMes == Space(3)
	Alert('Faltou informação do cavalete')
	oGetCavMes:SetFocus()
	return
endif
if cGetNumPar == Space(11)
	Alert('Faltou número de partida')
	oGetNumPar:SetFocus()
	return
endif           

//Alert('Armazem: |'+nLocal+'|')	

//cNumOP := GetSXeNum('SC2','C2_NUM') //Alterado funcao retorna numeracao automatica				
cNumOP := GetNumSC2()                

aCab := {}
AAdd( aCab, {'C2_FILIAL'		,		 XFILIAL('SC2' ),nil 								})
AAdd( aCab, {'C2_NUM'			,		 cNumOP			,nil								})
AAdd( aCab, {'C2_ITEM'			,		 '01' 			,nil								})
AAdd( aCab, {'C2_SEQUEN'		,	     '001'			,nil								})
AAdd( aCab, {'C2_PRODUTO'		,		 cGetProd 		,nil								})
AAdd( aCab, {'C2_QUANT'		    ,		 nGetQtdVq		,nil								})
AAdd( aCab, {'C2_LOCAL'		    ,		 nLocal			,nil								})
AAdd( aCab, {'C2_CC'			,		 '320202'		,nil								})
AAdd( aCab, {'C2_DATPRI'	    ,		 dDataBase 		,nil								})
AAdd( aCab, {'C2_DATPRF'		,		 dDataBase + 10	,nil								})
AAdd( aCab, {'C2_OPMIDO'	    ,		 cGetNumPar		,nil		  						})
AAdd( aCab, {'C2_EMISSAO'	    ,	     dDataBase		,nil								})
AAdd( aCab, {'C2_QTDLOTE'	    ,	     nGetQtdVq		,nil								})
AAdd( aCab, {'C2_OBS'           ,        cGetNumPar		,nil						        }) 
AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
AAdd( aCab, {"AUTEXPLODE"       ,        'S'			,nil							    })
	
	incProc("Gerando plano -> ")
	
	lMsErroAuto := .f.
	msExecAuto({|x,Y| Mata650(x,Y)},aCab,3)
	dbGotop()
	dbSelectArea('SC2')
	dbSetOrder(1)
	dbSeek(xFilial('SC2')+cNumOP)
	RecLock("SC2",.F.)
	SC2->C2_ITEMCTA := xFilial("SC2")
	MsUnLock("SC2")

	If lMsErroAuto
		MostraErro()
	else
		cSayOP1 := cNumOP
		oSayOP1:Refresh()
		Alert('OP Inserida com sucesso...'+cNumOP)
	
		cOP := cNumOP
		//dbGotop()
		//dbSelectArea('SC2')
		//dbSetOrder(1)
		//dbSeek(xFilial('SC2')+cOP)
//Prepara para fazer o apontamento da OP		
        aItens  := {}
			AAdd( aItens, {'D3_FILIAL'		,		 XFILIAL('SD3' ),nil 								})
			AAdd( aItens, {'D3_TM'			,		 '500' ,nil											})
			AAdd( aItens, {'D3_COD'			,		 SC2->C2_PRODUTO	,nil							})
			AAdd( aItens, {'D3_OP'			,		 SC2->(C2_NUM+C2_ITEM+C2_SEQUEN) ,nil         		})
			AAdd( aItens, {'D3_QUANT'		,	 	 SC2->(C2_QUANT-C2_QUJE),nil 					   	})
			AAdd( aItens, {'D3_LOCAL'		,		 SC2->C2_LOCAL	,nil								})
			AAdd( aItens, {'D3_DOC'			,		 'OP'+cNumOP ,nil 								})
			AAdd( aItens, {'D3_EMISSAO'	    ,		 dDataBase ,nil										})
			AAdd( aItens, {'D3_CC'			,		 '320202' ,nil											})
			AAdd( aItens, {'D3_CF'			,		 'PR0' ,nil											})
			AAdd( aItens, {'D3_PARCTOT'	    ,		 'T' ,nil										    })
			AAdd( aItens, {'D3_PARTIDA'	    ,	     SC2->C2_OPMIDO ,nil								})
			lMsErroAuto := .f.
			msExecAuto({|x,Y| Mata250(x,Y)},aItens,3)

			If lMsErroAuto
				MostraErro()
//				VSS_ENVMAIL(cOP, SC2->C2_EMISSAO, cSayDesc1, SC2->C2_QUANT)  //DESATIVADO POR ANESIO POR ESTAR TRAVANDO PROTHEUS 11.8 (Aguardando solucao da TOTVs)
			else
				dbSelectArea('SD3')
				dbSetOrder(1)
				dbSeek(xFilial('SD3')+PADR(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN),13)+SC2->C2_PRODUTO)
				RecLock('SD3',.F.)
		
				SD3->D3_QTDEM2 := nGetQtdM2
				SD3->D3_MEDIAM2:= nMediaM2VQ
				SD3->D3_ATLOBS := cGetCavMesa
				
				SD3->D3_X_QTI  := nGetQtdVqI  
				SD3->D3_X_MT2I := nGetQtdM2I
				SD3->D3_X_MD2I := nMedM2VQI
				SD3->D3_X_APMET:= Val(cSayMed)				
				
				
				MsUnLock('SD3')
				APMsgInfo(" OP Numero "+SC2->C2_NUM+" foi apontado com sucesso ")
				U_AGF_FICHMED(cOP)
//				AGF_ENVMAIL(cOP, SC2->C2_EMISSAO, cSayDesc1, SC2->C2_QUANT)	
			endif
		endif
oDlg1:End()
U_VSS_MEDACA()
Return




Static Function VSS_ENVMAIL(cOP, dData, cDescProd, nQtde)

     Local _cEmlFor := 'jairson.ramalho@midoriautoleather.com.br,waldelino.junior@midoriautoleather.com.br, lucimara.moura@midoriautoleather.com.br'
     Local oProcess 
     Local oHtml
     Local nCont := 0
//	 RpcSetEnv("01","04","","","","",{"SRA"})
//     Alert('Iniciando envido e e-mail...')
	 SETMV("MV_WFMLBOX","WORKFLOW") 
     oProcess := TWFProcess():New( "000004", "Problema com apontamento de OP - MEDIDEIRA" )
     oProcess:NewTask( "Problema com apontamento", "\WORKFLOW\HTM\ApontOP.HTM" )
     oHtml    := oProcess:oHTML
	 oHtml:ValByName("Data"			,dToc(dData))
	 oHtml:ValByName("numOP"   		,cOP)
	 
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	 aAdd( oHtml:ValByName( "it.desc" ), "HOUVE PROBLEMA NO APONTAMENTO DA ORDEM DE PRODUCAO "+Substr(cOP,1,6)+" DA MEDIDEIRA")
   	 aAdd( oHtml:ValByName( "it.desc" ), "PRODUTO: "+cDescProd )
   	 aAdd( oHtml:ValByName( "it.desc" ), "QUANTIDADE: "+cValToChar(nqtde) )
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	 aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
	 aAdd( oHtml:ValByName( "it.desc" ), "USUARIO QUE FEZ A INCLUSAO: "+substr(cUsuario,1,35))
   	 aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	 
   	    	                                 
oProcess:cSubject := "Problema com apontamento de OP - MEDIDEIRA - OP NUMERO: " + cOP



	oProcess:cTo      := _cEmlFor     



oProcess:Start()                    
//WFSendMail() // Remover comentario	       
oProcess:Finish()
//Alert('Email enviado com sucesso...')
Return