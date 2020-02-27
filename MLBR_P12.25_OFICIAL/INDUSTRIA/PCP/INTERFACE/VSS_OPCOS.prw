#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VSS_OPCOS ºAutor  ³ Vinicius Schwartz  º Data ³  30/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Projeto Tela de Abertura de OP Producaoo Costura            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso.      ³Rotina de abertura de OP na Producao Costura.               º±±
±±º          ³Permite ao usuario abrir uma OP informando apenas alguns    º±±
±±º          ³campos mais relevantes tornando o processo mais dinamico.   º±±
±±º          ³A partir da abertura de OP sera impresso um relatorio onde  º±±
±±º          ³constara o numero da OP em cod. de barras para ser utilizadaº±±
±±º          ³no apontamento na rotina VSS_PROCOS.  	                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                            

User Function VSS_OPCOS()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cGetCodPro := Space(6)
Private cGetQtde   := 0
Private cSayCodPro := Space(6)
Private cGetCC	   := Space(9)
Private cSayCodU   := Space(15)
Private cSayCodU1  := RetCodUsr()
Private cSayData   := Space(5)
Private cSayData2  := dDatabase
Private cSayDsc    := Space(10)
Private cSayDsc2   := Space(50)
Private cSayGrupo  := Space(6)
Private cSayGrupo2 := Space(4)
Private cSayLin    := Space(6)
Private cSayLoc    := Space(6)
Private cSayNoU    := Space(15)
Private cSayNoU1   := cUsuario
Private cSayOP     := Space(6)
Private cSayOP2    := 'INSERINDO...' //Soma1(GetSxeNum('SC2'))
Private cSayOpCos  := Space(25)
Private cSayProc   := Space(10)
Private cSayQtde   := Space(4)
Private cSayUM     := Space(2)
Private cSayUM2    := Space(2)
Private cSayCC	   := Space(10)
Private nCBoxLin  
Private nRLoc     

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlg1","oSayProc","oSayOpCos","oSayData","oSayData2","oSayOP","oSayOP2","oSayCodPro")
SetPrvt("oSayDsc2","oSayUM","oSayUM2","oSayGrupo","oSayGrupo2","oSayQtde","cSayLin","oSayLoc","oGetCodPro","oGetQtde")
SetPrvt("oCBoxLin","oBtn1","oBtn2","oPanel1","oSayCodU","oSayCodU1","oSayNoU","oSayNoU1","oRLoc","oGetCC")

if cFilant == "08"
	nRLoc := 1
endif

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )   
oFont2     := TFont():New( "MS Sans Serif",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 091,579,562,1272,"ABERTURA DE OP PROCESSO COSTURA",,,.F.,,,,,,.T.,,,.T. )
oSayProc   := TSay():New( 004,008,{||"PROCESSO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,011)
oSayOpCos  := TSay():New( 004,068,{||"ABERTURA DE OP PROCESSO COSTURA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,264,016)
oSayData   := TSay():New( 032,008,{||"DATA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,012)
oSayData2  := TSay():New( 032,040,{|u| If (PCount()>0, cSayData2:=u, cSayData2)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,076,016)
oSayOP     := TSay():New( 032,124,{||"OP Nº"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,012)
oSayOP2    := TSay():New( 032,160,{|u| If (PCount()>0, cSayOP2:=u, cSayOP2)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,172,016)
oSayCodPro := TSay():New( 056,008,{||"CODIGO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,012)
oSayDsc    := TSay():New( 056,092,{||"DESCRIÇÃO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,232,012)
oSayDsc2   := TSay():New( 068,092,{|u| If (PCount()>0, cSayDsc2:=u, cSayDsc2)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,240,022)
oSayUM     := TSay():New( 096,008,{||"UM"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,012)
oSayUM2    := TSay():New( 096,036,{|u| If (PCount()>0, cSayUM2:=u, cSayUM2)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,060,016)
oSayGrupo  := TSay():New( 096,128,{||"GRUPO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,012)
oSayGrupo2 := TSay():New( 096,176,{|u| If (PCount()>0, cSayGrupo2:=u, cSayGrupo2)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,064,016)
oSayQtde   := TSay():New( 124,008,{||"QTDE"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,012)
cSayLin    := TSay():New( 124,136,{||"LINHA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,012)
oSayLoc    := TSay():New( 124,244,{||"LOCAL"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,012)
oSayCC     := TSay():New( 164,008,{||"C.CUSTO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,012)
oGetCodPro := TGet():New( 068,008,{|u| If(PCount()>0,cGetCodPro:=u,cGetCodPro)},oDlg1,072,014,'',{|| Vld_Prd(cGetCodPro)},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetCodPro",,)
oGetQtde   := TGet():New( 140,008,{|u| If(PCount()>0,cGetQtde:=u,cGetQtde)},oDlg1,100,014,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtVM1",,)
oGetCC	   := TGet():New( 164,60,{|u| If(PCount()>0,cGetCC:=u,cGetCC)},oDlg1,072,014,'',{|| u_ag_blqctt(cGetCC,"", "")},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CTT","cGetCC",,)
oCBoxLin   := TComboBox():New( 140,136,{|u| If(PCount()>0,nCBoxLin:=u,nCBoxLin)},{"00=","01=LINHA 01","02=LINHA 02","03=LINHA 03","04=LINHA 04","05=LINHA 05","06=LINHA 06","07=LINHA 07","08=LINHA 08","09=LINHA 09","10=LINHA 10"},088,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nCBoxLin )
GoRLoc     := TGroup():New( 136,244,172,316,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oRLoc      := TRadMenu():New( 140,250,{"05 - NORMAL","02 - RETRABALHO"},{|u| If(PCount()>0,nRLoc:=u,nRLoc)},oDlg1,,,CLR_BLACK,CLR_WHITE,"",,,052,18,,.F.,.F.,.T. )
oBtn2      := TButton():New( 184,244,"CONFIRMAR",oDlg1,{|| VSS_GEROP()},084,020,,oFont1,,.T.,,"",,,,.F. )
oBtn1      := TButton():New( 184,148,"CANCELAR",oDlg1,{|| oDlg1:End()},084,020,,oFont1,,.T.,,"",,,,.F. )
oPanel1    := TPanel():New( 208,004,"",oDlg1,,.F.,.F.,,,332,016,.T.,.F. )
oSayCodU   := TSay():New( 004,012,{||"CÓDIGO USUÁRIO:"},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSayCodU1  := TSay():New( 004,064,{|u| If(PCount()>0, cSayCodU1:=u, cSayCodU1)},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSayNoU    := TSay():New( 004,124,{||"NOME USUÁRIO:"},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSayNoU1   := TSay():New( 004,172,{|u| If(PCount()>0, cSayNoU1:=u, cSayNoU1)},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,072,008)

oDlg1:Activate(,,,.T.)

Return

//Valida produto e se tem cadastro de estrutura
Static Function Vld_Prd(cCod)
local lRet := .F.
DbSelectArea('SB1')
DbSetOrder(1)

If DbSeek(xFilial('SB1') + cCod)
	cSayDsc2		:=SB1->B1_DESC
	cSayUM2			:=SB1->B1_UM
	cSayGrupo2		:=SB1->B1_GRUPO
	
	oSayDsc2:Refresh()
	oSayUM2:Refresh()
	oSayGrupo2:Refresh()
endif

lRet := SubStr(Posicione('SG1',1,xFilial('SG1')+cCod,'G1_COD'),1,6)==SubStr(cCod,1,6)

If !lRet
	Alert('O produto informado nao tem estrutura cadastrada!')
	oGetCodPro:SetFocus()
endif

return lRet   

Static Function VSS_GEROP()

//Valida o centro de custo
if !u_ag_blqctt(cGetCC,"", "")
	Alert('Informe um centro de custo válido!!!','atenção!!!')
	oGetCC:SetFocus()
	return		
endif

//Valida se produto foi informado
If cGetCodPro == Space(6)
	Alert('Nenhum produto foi informado...')
	oGetcodPro:SetFocus()
	return
Endif

//Valida se Qtde foi informada
If cGetQtde == 0
	Alert('A quantidade não foi informada...')
	oGetQtde:Setfocus()
	return
Endif

//Valida se a Linha foi informada
If nCBoxLin == '00'
	Alert('Nenhuma linha foi informada...')
	oCBoxLin:SetFocus()
	return
Endif                       

//Valida local e atribui o armazem
If nRloc == 1
	vLoc := '05'
Elseif nRloc == 2
		vLoc := '02' 
//Elseif nRLoc == 3 .and. cFilant == "08"  //Desativado em 17/06/15 por Diego - Padronizacao OP.Costura Armazem 05
//	vLoc := "12"
Else
	vLoc := '05' 
Endif




//Alert ('Linha: '+nCBoxLin)	
//Alert ('Local: '+cValToChar(vLoc))

//Gera OP
aCab := {}
              
//cNumOP := GetSXeNum('SC2','C2_NUM') //Alterado funcao retorna numeracao automatica				
cNumOP := GetNumSC2()                

AAdd( aCab, {'C2_FILIAL'		,		 XFILIAL('SC2' ),nil 								})
AAdd( aCab, {'C2_NUM' 			, 		 cNumOp,"A710ValNum()"								})
AAdd( aCab, {'C2_ITEM'			,		 '01' ,"A710ValNum()"								})
AAdd( aCab, {'C2_SEQUEN'		,	     '001',"A710ValNum()"								})
AAdd( aCab, {'C2_PRODUTO'		,		 cGetCodPro		,nil								})
AAdd( aCab, {'C2_QUANT'		    ,		 cGetQtde		,nil								})
AAdd( aCab, {'C2_LOCAL'		    ,		 vLoc	,nil										})
AAdd( aCab, {'C2_CC'			,		 cGetCC,nil 											})
AAdd( aCab, {'C2_DATPRI'	    ,		 dDataBase ,nil										})
AAdd( aCab, {'C2_DATPRF'		,		 dDataBase ,nil										})
AAdd( aCab, {'C2_EMISSAO'	    ,	     dDataBase,nil										})
AAdd( aCab, {'C2_ITEMCTA' 		,		 xFilial("SC2"),nil									})
AAdd( aCab, {'C2_X_LINHA'		,		 nCBoxLin,nil										}) 
AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
AAdd( aCab, {"AUTEXPLODE"       ,        'S',nil 										    })
	
	incProc("Gerando plano -> ")
	
	lMsErroAuto := .f.
	msExecAuto({|x,Y| Mata650(x,Y)},aCab,3)


	If lMsErroAuto
		MostraErro()
	else
		cSayOP2 := cNumOP
		oSayOP2:Refresh()
		Alert('OP Inserida com sucesso...'+cNumOP)
		cOP 	:= cNumOP
	Endif
		
//Alerta antes de chamar o relatorio de empenho VSS_MT820
Alert ('Clique em OK para imprimir o relatório!')
U_VSS_MT820(cOP)

oDlg1:End()
U_VSS_OPCOS()
Return