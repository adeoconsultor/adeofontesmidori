#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "topconn.ch"


///////////////////////////////////////////////////////////////////////////////
//Rotina de inclusao de OP na medideira - PNP1
//Permite ao usuario selecionar um produto que contenha estrutura, gera 
//a Ordem de Producao e faz o apontamento para o mesmo automáticamente
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br - 06-02-2012
///////////////////////////////////////////////////////////////////////////////
User Function AGF_PROCMED()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cGetCavMes := Space(3)
Private cGetNumPar := Space(11)
Private cGetProd   := Space(6)
Private nGetQtdM2  := 0
Private nGetQtdVq  := 0
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
Private cSayMedAca := Space(10)
Private cSayNomeUs := cUsuario
Private cSayOP     := Space(6)
Private cSayOP1    := 'INSERINDO...' //Soma1(GetSxeNum('SC2'))
Private cSayProc   := Space(10)
Private cSayQtdM2  := Space(10)
Private cSayQtdVQ  := Space(10)
Private cSayUM     := Space(4)
Private cSayUM1    := Space(4)


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oFont2","oFont3","oDlg1","oSayProc","oSayMedAcab","oSayData","oSayData1","oSayOP","oSayOP1")
SetPrvt("oSayDesc","oSayDesc1","oSayUM","oSayUM1","oSayGrupo","oSayGrupo1","oSayQtdVQ","oSayQtdM2","oSayM2VQ")
SetPrvt("oSayM2VQ1","oGetProd","oGetQtdVq","oGetQtdM2","oGetNumPart","oGetCavMesa","oPanel1")
SetPrvt("oSayCodUsu1","oSayNomeUsu","oSayNomeUsu1","oBtnConfirm","oBtnCancel")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-24,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-24,,.T.,0,,700,.F.,.F.,,,,,, )
oFont3     := TFont():New( "MS Sans Serif",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 105,312,671,1099,"Processo Medideira Acabamento...",,,.F.,,,,,,.T.,,oFont1,.T. )
oSayProc   := TSay():New( 015,007,{||"PROCESSO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,101,017)
oSayMedAca := TSay():New( 015,112,{||"MEDIDEIRA ACABAMENTO"},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,268,023)
oSayData   := TSay():New( 036,008,{||"DATA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,024)
oSayData1  := TSay():New( 036,112,{|u|If(PCount()>0, cSayData1:=u, cSayData1)},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,092,021)
//oGdtApont   := TGet():New( 078,339,{|u| If(PCount()>0,cGdtApont:=u,cGdtApont)},oGrpItens,046,009,'@r 99/99/9999',{|| ! empty( cGdtApont ) .and. VldtApon()},CLR_BLACK,CLR_WHITE,oFontLabel,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGdtApont",,)
oSayOP     := TSay():New( 036,215,{||"OP N²"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,065,025)
oSayOP1    := TSay():New( 036,288,{|u|If(PCount()>0, cSayOP1:=u, cSayOP1)},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,092,022)
oSayCodigo := TSay():New( 066,008,{||"CÓDIGO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,084,018)
oSayDesc   := TSay():New( 066,111,{||"DESCRICAO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,105,023)
oSayDesc1  := TSay():New( 088,112,{|u|If(PCount()>0, cSayDesc1:=u, cSayDesc1)},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,268,024)
oSayUM     := TSay():New( 114,007,{||"UM"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,089,018)
oSayUM1    := TSay():New( 114,111,{|u|If(PCount()>0, cSayUM1:=u, cSayUM1)},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,081,022)
oSayGrupo  := TSay():New( 114,202,{||"GRUPO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,070,022)
oSayGrupo1 := TSay():New( 114,276,{|u|If(PCount()>0, cSayGrupo1:=u, cSayGrupo1)},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,104,022)
oSayQtdVQ  := TSay():New( 144,008,{||"QTDE VQ"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,089,018)
oSayQtdM2  := TSay():New( 144,120,{||"QTDE M2"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,018)
oSayM2VQ   := TSay():New( 144,274,{||"M2 / VQ"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,089,018)
oSayM2VQ1  := TSay():New( 163,277,{|u|If(PCount()>0, cSayM2VQ1:=u, cSayM2VQ1) },oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,104,022)
oSayNumPar := TSay():New( 192,009,{||"N² PARTIDA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,103,018)
oSayCaval  := TSay():New( 192,174,{||"CAVALETE / "},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,103,018)
oSayMesa   := TSay():New( 214,208,{||"MESA N."},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,078,018)
oGetProd   := TGet():New( 086,010,{|u| If(PCount()>0,cGetProd:=u,cGetProd)},oDlg1,086,020,'',{|| Vld_Prd(cGetProd)},CLR_HBLUE,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetProd",,)
oGetQtdVq  := TGet():New( 160,011,{|u| If(PCount()>0,nGetQtdVq:=u,nGetQtdVq)},oDlg1,086,020,'@E 99,999,999.99',{|| RefreshMedia(), CalcMedia(nGetQtdM2,nGetQtdVq)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtdVq",,)
oGetQtdM2  := TGet():New( 160,120,{|u| If(PCount()>0,nGetQtdM2:=u,nGetQtdM2)},oDlg1,086,020,'@E 99,999,999.99',{|| RefreshMedia(), CalcMedia(nGetQtdM2,nGetQtdVq)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtdM2",,)
oGetNumPar := TGet():New( 212,012,{|u| If(PCount()>0,cGetNumPart:=u,cGetNumPart)},oDlg1,144,020,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetNumPart",,)
oGetCavMes := TGet():New( 197,280,{|u| If(PCount()>0,cGetCavMesa:=u,cGetCavMesa)},oDlg1,100,025,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetCavMesa",,)
oPanel1    := TPanel():New( 260,000,"",oDlg1,,.F.,.F.,,,388,016,.T.,.F. )
oSayCodUsu := TSay():New( 005,004,{||"CODIGO USUÁRIO"},oPanel1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
oSayCodUsu1:= TSay():New( 005,070,{|u|If(PCount()>0, cSayCodUsu:=u, cSayCodUsu)},oPanel1,,oFont3,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,031,008)
oSayNomeUs := TSay():New( 005,117,{||"NOME USUARIO"},oPanel1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,051,008)
oSayNomeUs1:= TSay():New( 006,174,{|u|If(PCount()>0, cSayNomeUs:=u, cSayNomeUs)},oPanel1,,oFont3,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,198,008)
oBtnConfir := TButton():New( 236,280,"&CONFIMAR",oDlg1,{|| AGF_GEROP()} ,096,020,,oFont1,,.T.,,"",,,,.F. )
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
if nGetQtdVq > 0
	nMediaM2VQ := nGetQtdM2 / nGetQtdVq
	cSayM2VQ1  := cValToChar(nMediaM2VQ)
//	Alert('Valor-> '+cSayM2VQ1)
endif
return 

Static Function RefreshMedia()
	oSayM2VQ1:Refresh()
return 


Static Function AGF_GEROP()
if cGetProd == space(6)
	Alert('Você não informou nenhum produto...')
	Return
endif
if !Vld_Prd(cGetProd)
	return
endif

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


aCab := {}
AAdd( aCab, {'C2_FILIAL'		,		 XFILIAL('SC2' ),nil 								})
AAdd( aCab, {'C2_ITEM'			,		 '01' ,nil											})
AAdd( aCab, {'C2_SEQUEN'		,	     '001',nil											})
AAdd( aCab, {'C2_PRODUTO'		,		 cGetProd 		,nil								})
AAdd( aCab, {'C2_QUANT'		    ,		 nGetQtdVq		,nil								})
AAdd( aCab, {'C2_LOCAL'		    ,		 '10'	,nil										})
AAdd( aCab, {'C2_CC'			,		 '323',nil 											})
AAdd( aCab, {'C2_DATPRI'	    ,		 dDataBase ,nil										})
AAdd( aCab, {'C2_DATPRF'		,		 dDataBase + 10,nil									})
AAdd( aCab, {'C2_OPMIDO'	    ,		 cGetNumPar,		nil		  						})
AAdd( aCab, {'C2_EMISSAO'	    ,	     dDataBase,	nil										})
AAdd( aCab, {'C2_QTDLOTE'	    ,	     nGetQtdVq,			nil								})
AAdd( aCab, {'C2_OBS'           ,        cGetNumPar,		nil						        }) 
AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
AAdd( aCab, {"AUTEXPLODE"       ,        'S',NIL 										    })
	
	incProc("Gerando plano -> ")
	
	lMsErroAuto := .f.
	msExecAuto({|x,Y| Mata650(x,Y)},aCab,3)

	RecLock("SC2",.F.)
	SC2->C2_ITEMCTA := xFilial("SC2")
	MsUnLock("SC2")

	If lMsErroAuto
		MostraErro()
	else
		cSayOP1 := SC2->C2_NUM
		oSayOP1:Refresh()
		Alert('OP Inserida com sucesso...'+SC2->C2_NUM)
	
		cOP := SC2->C2_NUM
		dbGotop()
		dbSelectArea('SC2')
		dbSetOrder(1)
		dbSeek(xFilial('SC2')+cOP)
//Prepara para fazer o apontamento da OP		
        aItens  := {}
			AAdd( aItens, {'D3_FILIAL'		,		 XFILIAL('SD3' ),nil 								})
			AAdd( aItens, {'D3_TM'			,		 '500' ,nil											})
			AAdd( aItens, {'D3_COD'			,		 SC2->C2_PRODUTO	,nil							})
			AAdd( aItens, {'D3_OP'			,		 SC2->(C2_NUM+C2_ITEM+C2_SEQUEN) ,nil         		})
			AAdd( aItens, {'D3_QUANT'		,	 	 SC2->(C2_QUANT-C2_QUJE),nil 					   	})
			AAdd( aItens, {'D3_LOCAL'		,		 SC2->C2_LOCAL	,nil								})
			AAdd( aItens, {'D3_DOC'			,		 'OP'+SC2->C2_NUM ,nil 								})
			AAdd( aItens, {'D3_EMISSAO'	    ,		 dDataBase ,nil										})
			AAdd( aItens, {'D3_CC'			,		 '323' ,nil											})
			AAdd( aItens, {'D3_CF'			,		 'PR0' ,nil											})
			AAdd( aItens, {'D3_PARCTOT'	    ,		 'T' ,nil										    })
			AAdd( aItens, {'D3_PARTIDA'	    ,	     SC2->C2_OPMIDO ,nil								})
			lMsErroAuto := .f.
			msExecAuto({|x,Y| Mata250(x,Y)},aItens,3)

			If lMsErroAuto
				MostraErro()
				AGF_ENVMAIL(cOP, SC2->C2_EMISSAO, cSayDesc1, SC2->C2_QUANT)
			else
				dbSelectArea('SD3')
				dbSetOrder(1)
				dbSeek(xFilial('SD3')+PADR(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN),13)+SC2->C2_PRODUTO)
				RecLock('SD3',.F.)
				SD3->D3_QTDEM2 := nGetQtdM2
				SD3->D3_MEDIAM2:= nMediaM2VQ
				SD3->D3_ATLOBS := cGetCavMesa
				MsUnLock('SD3')
				APMsgInfo(" OP Numero "+SC2->C2_NUM+" foi apontado com sucesso ")
				U_AGF_FICHMED(cOP)
//				AGF_ENVMAIL(cOP, SC2->C2_EMISSAO, cSayDesc1, SC2->C2_QUANT)	
			endif
		endif
oDlg1:End()
U_AGF_PROCMED()
Return




Static Function AGF_ENVMAIL(cOP, dData, cDescProd, nQtde)

     Local _cEmlFor := 'jairson.ramalho@midoriautoleather.com.br,waldelino.junior@midoriautoleather.com.br'
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
	      // WFSendMail()
//	       WFSendMail()	       
oProcess:Finish()
//Alert('Email enviado com sucesso...')
Return