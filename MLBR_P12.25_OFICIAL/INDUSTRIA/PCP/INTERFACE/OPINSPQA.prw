#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OPINSPQA ºAutor  ³ Antonio           º Data ³  15/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Projeto Tela Inspeção de Qualidade                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso.      ³Rotina de inclusao de OP Inspeção de Qualidade.             º±±
±±º          ³Permite ao usuario selecionar um produto que contenha estru-º±±
±±º          ³tura, gera automaticamente a OP e faz o apontamento para o  º±±
±±º          ³mesmo automaticamente.                                      º±± 
±±º          VSS_UMSEC3                                   				  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function OPINSPQA()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cGetCodPro := Space(6)
Private cGetNPart  := Space(11)
Private cGetQtVI1  := 0
Private cGetQtVM1  := 0
Private cSayCodFor := Space(10)
Private cSayCodPro := Space(6)
Private cSayCodU   := Space(15)
Private cSayCodU1  := RetCodUsr()
Private cSayData   := Space(5)
Private cSayData1  := dDatabase
Private cSayDesc   := Space(10)
Private cSayDesc1  := Space(50)
Private cSayGrupo  := Space(5)
Private cSayGrupo1 := Space(4)
Private cSayLote   := Space(7)
Private cSayLote1  := Space(11)
Private cSayMedSec := Space(25)
Private cSayNoU    := Space(15)
Private cSayNoU1   := cUsuario
Private cSayNPart  := Space(12)
Private cSayOP     := Space(6)
Private cSayOP1    := 'INSERINDO...'
Private cSayProc   := Space(8)
Private cSayQtVI   := Space(17)
Private cSayQtVM   := Space(17)
Private cSayTot    := Space(5)
Private cSayTProd  := Space(16)
Private cSayUM     := Space(2)
Private cSayUM1    := Space(2)
Private cSayNovFor := Space(50)
Private nCFor     

Public nFor	     := "01=Outro For ->"
Public cSiglaArt := Space(4)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oSayProc","oSayMedSec","oSayData","oSayData1","oSayOP","oSayOP1","oSayCodPro","oSayNPart")
SetPrvt("oSayDesc","oSayDesc1","oSayUM","oSayUM1","oSayGrupo","oSayGrupo1","oSayQtVM","oSayQtVM1","oSayQtVI","oSayQtVI1")
SetPrvt("oGetCodPro","oGetQtVI1","oGetQtMI1","oGetNPart","oBtn1","oBtn2","oBtn3","oFont1","oFont2","oFont3")
SetPrvt("oPanel1","oSayNoU","oSayNoU1","oSayCodU","oSayCodU1","oSayLote","oSayLote1","oSayNovFor","oSayCodFor","oCFor",)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-14,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
oFont3     := TFont():New( "MS Sans Serif",0,-14,,.T.,0,,400,.F.,.F.,,,,,, )

oDlg1      := MSDialog():New( 145,459,685,1185,"INSPEÇÃO DE QUALIDADE",,,.F.,,,,,,.T.,,oFont1,.T. )
oSayProc   := TSay():New( 003,003,{||"PROCESSO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,057,010)
oSayMedSec := TSay():New( 003,061,{||"INSPEÇÃO DE QUALIDADE"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,251,010)
oSayData   := TSay():New( 015,003,{||"DATA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,023,010)
oSayData1  := TSay():New( 015,038,{|u| If(PCount()>0, cSayData1:=u, cSayData1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,066,010)
oSayOP     := TSay():New( 015,126,{||"OP Nº"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,027,010)
oSayOP1    := TSay():New( 015,161,{|u| If(PCount()>0, cSayOP1:=u, cSayOP1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,151,010)
oSayCodPro := TSay():New( 027,003,{||"CODIGO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,010)
oGetCodPro := TGet():New( 027,046,{|u| If(PCount()>0,cGetCodPro:=u,cGetCodPro)},oDlg1,086,012,'',{|| Vld_Prd(cGetCodPro) },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetCodPro",,)
oSayDesc   := TSay():New( 045,003,{||"DESCRIÇÃO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,177,010)
oSayDesc1  := TSay():New( 053,003,{|u| If(PCount()>0, cSayDesc1:=u, cSayDesc1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,201,019)
oSayUM     := TSay():New( 045,210,{||"UM"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,017,010)
oSayUM1    := TSay():New( 045,248,{|u| If(PCount()>0, cSayUM1:=u, cSayUM1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,064,014)
oSayGrupo  := TSay():New( 053,210,{||"GRUPO"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,034,010)
oSayGrupo1 := TSay():New( 053,248,{|u| If(PCount()>0, cSayGrupo1:=u, cSayGrupo1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,064,014)

oSayCodFor := TSay():New( 071,179 ,{||"FORNECEDOR"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,010)
oCFor      := TComboBox():New( 080, 180 ,{|u| If(PCount()>0,nCFor:=u,nCFor)},{"00=",nFor,"02=CUBATÃO","03=QUATRO PATAS","04=MINERVA","05=MARFRIG","06=VIPOSA","07=VANZELA","08=HUMAITÁ","09=JANGADA","10=PANORAMA"},100,014,oDlg1,,{|| Vld_OFor(nCFor)},,CLR_BLACK,CLR_WHITE,.T.,oFont3,"",,,,,,,nCFor )
oSayNovFor := TSay():New( 080,290,{|u| If(PCount()>0, cSayNovFor:=u, cSayNovFor)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,100,014)

oSayQtVM   := TSay():New( 077,003,{||"QTD APROVADA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,089,010)
oGetQtVM1  := TGet():New( 085,003,{|u| If(PCount()>0,cGetQtVM1:=u,cGetQtVM1)},oDlg1,085,012,'@E 99,999.99',/*{|| CalcMedM(cGetQtMM1,cGetQtVM1)}*/,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtVM1",,)
oSayQtVI   := TSay():New( 102,003,{||"QTDE NÃO APROVADA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,089,010)
oGetQtVI1  := TGet():New( 110,003,{|u| If(PCount()>0,cGetQtVI1:=u,cGetQtVI1)},oDlg1,085,012,'@E 99,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetQtVI1",,)
oSayNPart  := TSay():New( 147,003,{||"Nº PARTIDA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,133,010)
//oGetNPart  := TGet():New( 155,003,{|u| If(PCount()>0, cGetNPart:=u,cGetNPart)},oDlg1,145,012,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetNPart",,)
oGetNPart  := TGet():New( 155,003,{|u| If(PCount()>0, cGetNPart:=u,cGetNPart)},oDlg1,145,012,'',{|| RefreLot(cGetNPart) },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetNPart",,)

oSayLote   := TSay():New( 147,160,{||"Nº LOTE"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,134,010)
oSayLote1  := TSay():New( 157,160,{|u| If(PCount()>0, cSayLote1:=u, cSayLote1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,144,011)

oBtn2      := TButton():New( 242,256,"CONFIRMAR",oDlg1,{|| VSS_GEROP()},057,014,,oFont1,,.T.,,"",,,,.F. )
oBtn1      := TButton():New( 242,188,"CANCELAR",oDlg1,{|| oDlg1:End()},057,014,,oFont1,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( 245,003,"Imp. 2ª Via",oDlg1,{|| VSS_SEGVIA()},031,010,,oFont2,,.T.,,"",,,,.F. )
oPanel1    := TPanel():New( 257,000,"",oDlg1,,.F.,.F.,,,316,013,.T.,.F. )
oSayCodU   := TSay():New( 003,010,{||"CÓDIGO USUÁRIO:"},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,007)
oSayCodU1  := TSay():New( 003,053,{|u| If(PCount()>0, cSayCodU1:=u, cSayCodU1)},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,027,007)
oSayNoU    := TSay():New( 003,103,{||"NOME USUÁRIO:"},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,007)
oSayNoU1   := TSay():New( 003,143,{|u| If(PCount()>0, cSayNoU1:=u, cSayNoU1)},oPanel1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,060,007)

oDlg1:Activate(,,,.T.)

Return





//////////////////////////////////////////////////////////////////////////////////
//Valida produto e se tem cadastro de estrutura
//////////////////////////////////////////////////////////////////////////////////
Static Function Vld_Prd(cCod)
local lRet := .F.
Public _cCod := cCod

DbSelectArea('SB1')
DbSetOrder(1)

If DbSeek(xFilial('SB1') + cCod)
	cSayDesc1		:=SB1->B1_DESC
	cSayUM1			:=SB1->B1_UM
	cSayGrupo1		:=SB1->B1_GRUPO
	cSiglaArt		:=RTRIM(SB1->B1_X_SIGLA)
	
	oSayDesc1:Refresh()
	oSayUM1:Refresh()
	oSayGrupo1:Refresh()
EndIf             

If cSiglaArt == Space(6)
	Alert('O produto informado não possui sigla de artigo cadastrada. Favor verificar!')
	Return
EndIf

lRet := SubStr(Posicione('SG1',1,xFilial('SG1')+cCod,'G1_COD'),1,6)==SubStr(cCod,1,6)

If !lRet
	Alert('O produto informado nao tem estrutura cadastrada!')
	oGetCodPro:SetFocus()
EndIf   

Return lRet                                        
                       

//////////////////////////////////////////////////////////////////////////////////
//Dispara Num Lote = Partida                                                      
//////////////////////////////////////////////////////////////////////////////////
Static Function RefreLot(cGetLote)
	Public cLote := cGetLote 	

	If Posicione("SB1",1,xFilial("SB1")+cGetCodPro,"B1_RASTRO") == 'L' 
		cSayLote1 := cLote
	Else
		cSayLote1 := " "
	EndIf
	
	PUTMV("MA_LOTEMED", cLote) //Grava o numero do Lote no parametro MA_LOTEMED para ser buscado pela formula
	PUTMV("MV_FORMLOT", "507") //Grava o codigo da Formula no parametro que vai buscar o valor....
	oSayLote1:Refresh()
Return 

                  

//////////////////////////////////////////////////////////////////////////////////
//Inicia validacoes e o processo de geracao da OP ao confirmar
//////////////////////////////////////////////////////////////////////////////////
Static Function VSS_GEROP()


If cGetCodPro == Space(6)
	Alert('Nenhum produto foi informado...')
	oGetCodPro:SetFocus()
	Return
EndIf

If cGetQtVM1 == 0 .And. cGetQtVI1  == 0
	Alert('Nenhuma Quantidade foi informada...')
	oGetQtVM1:SetFocus()
	Return
EndIf

//Valida Num partida
If cGetNPart  == Space(11)
	Alert ('Nenhum número de partida foi informado...')
	oGetNPart:SetFocus()
	Return
EndIf                    

/////////////////////////////////antonio ver se da pra aproveitar a rotina.
//Valida armazem 01 ou 04
// xxxxxxxxxxxxx (validar armazens 04 e QS)
Public vArm  := '04'     //APROVADOS
Public vArm1 := 'QS'     //NAO APROVADOS


//Gera OP - Caso a quantidade aprovada e a qtde não aprovada sejam informadas, serão geradas duas OPs
If cGetQtVM1 > 0          //quantidade aprovada   - gerar OP para Armazem 04

	aCab := {}                           

	//cNumOP := GetSXeNum('SC2','C2_NUM') //Alterado funcao retorna numeracao automatica					
	cNumOP := GetNumSC2()                
 
	AAdd( aCab, {'C2_FILIAL'	,	XFILIAL('SC2' )	, nil	})
	AAdd( aCab, {'C2_NUM'		,	cNumOP			, nil	})   
	AAdd( aCab, {'C2_ITEM'		,	'01' 			, nil	})
	AAdd( aCab, {'C2_SEQUEN'	,	'001'			, nil	})
	AAdd( aCab, {'C2_PRODUTO'	,	cGetCodPro		, nil	})
	AAdd( aCab, {'C2_QUANT'		,	cGetQtVM1		, nil	})
	AAdd( aCab, {'C2_LOCAL'		,	vArm			, nil	})                //Armazem 01 - AProvados
	AAdd( aCab, {'C2_CC'		,	'320101'		, nil	})
	AAdd( aCab, {'C2_DATPRI'	,	dDataBase 		, nil	})
	AAdd( aCab, {'C2_DATPRF'	,	dDataBase + 10	, nil	})
	AAdd( aCab, {'C2_OPMIDO'	,	cGetNPart		, nil	})
	AAdd( aCab, {'C2_EMISSAO'	,	dDataBase		, nil	})
	AAdd( aCab, {'C2_QTDLOTE'	,   cGetQtVM1		, nil	})
	AAdd( aCab, {'C2_OBS'		,	cGetNPart		, nil	})
	AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
	AAdd( aCab, {"AUTEXPLODE"	,	'S'				, NIL   })
	
	incProc("Gerando plano -> ")
	
	lMsErroAuto := .F.
	msExecAuto({|x,Y| Mata650(x,Y)},aCab,3) 
	
	dbGotop()
	dbSelectArea('SC2')
	dbSetOrder(1)
	If dbSeek(xFilial('SC2')+cNumOP)
		RecLock("SC2",.F.)
		SC2->C2_ITEMCTA := xFilial("SC2")
		MsUnLock("SC2")
	EndIf

	If lMsErroAuto
		RollBackSx8()
		MostraErro()
	Else
		//ConfirmSx8() 
		cSayOP1 := SC2->C2_NUM
		oSayOP1:Refresh()
		oSayOP1 := TSay():New( 015,200,{|u| 'INSERINDO...' },oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,151,010)
		oSayOP1:Refresh()
		APMsgInfo('OP Inserida com sucesso...'+SC2->C2_NUM)
		cOP 	:= SC2->C2_NUM
		cItem	:= SC2->C2_ITEM
		cSeq	:= SC2->C2_SEQUEN
		nQuant	:= SC2->C2_QUANT
		
		dbGotop()
		dbSelectArea('SC2')
		dbSetOrder(1)
		dbSeek(xFilial('SC2')+cOP)

		//Prepara para fazer o apontamento da OP  
		// Adicionado AAdd D3_LOTECTL como correcao apontamentos com lote diferente partida (multiplas telas simultaneas) - Diego 20/10/2016
		PUTMV("MV_FORMLOT", "") //Limpa a formula do parametro para continuar com o padrao
		PUTMV("MA_LOTEMED", "") //Limpa a formula do parametro para continuar com o padrao	
					
        aItens  := {}
		AAdd( aItens, {'D3_FILIAL'		,	XFILIAL('SD3' )					, nil		})
		AAdd( aItens, {'D3_TM'			,	'500' 							, nil		})
		AAdd( aItens, {'D3_COD'			,	SC2->C2_PRODUTO					, nil		})
		AAdd( aItens, {'D3_OP'			,	SC2->(C2_NUM+C2_ITEM+C2_SEQUEN) , nil  		})
		AAdd( aItens, {'D3_QUANT'		,	SC2->(C2_QUANT-C2_QUJE)			, nil	   	})
		AAdd( aItens, {'D3_LOCAL'		,	SC2->C2_LOCAL					, nil		})
		AAdd( aItens, {'D3_DOC'			,	'OP'+SC2->C2_NUM 				, nil		})
		AAdd( aItens, {'D3_EMISSAO'		,	dDataBase 						, nil		}) 
		AAdd( aItens, {'D3_CC'			,	'320101' 						, nil		})
		AAdd( aItens, {'D3_CF'			,	'PR0' 							, nil		})
		AAdd( aItens, {'D3_PARCTOT'		,	'T' 							, nil	    })
		AAdd( aItens, {'D3_ATLOBS'		, 	'OPINSPQA'						, nil		})
		AAdd( aItens, {'D3_PARTIDA'		,	SC2->C2_OPMIDO 					, nil		}) 
		AAdd( aItens, {'D3_X_FORN'		,	Ret_For(nCFor)					, nil		})
		// Adicionado AAdd D3_LOTECTL como correcao apontamentos com lote diferente partida (multiplas telas simultaneas) - Diego 20/10/2016
		If Posicione("SB1",1,xFilial("SB1")+cGetCodPro,"B1_RASTRO") == 'L' 
			AAdd( aItens, {'D3_LOTECTL'	,   cLote 							, nil		}) 
		Endif
			
		lMsErroAuto := .f.
		msExecAuto({|x,Y| Mata250(x,Y)},aItens,3)
		PUTMV("MV_FORMLOT", "") //Limpa a formula do parametro para continuar com o padrao
		If lMsErroAuto
			MostraErro()
			AGF_ENVMAIL(cOP, SC2->C2_EMISSAO, cSayDesc1, SC2->C2_QUANT)
		Else
			MsUnLock('SD3')
			APMsgInfo(" OP Numero "+SC2->C2_NUM+" foi apontada com sucesso ")
			U_VSS_UFCHQA(cOP,'S')
//			AGF_ENVMAIL(cOP, SC2->C2_EMISSAO, cSayDesc1, SC2->C2_QUANT)	
		EndIf
	EndIf
EndIf



If cGetQtVI1 > 0        //quantidade não aprovada - Op Armazem QS
	aCab := {}                           

	//cNumOP := GetSXeNum('SC2','C2_NUM') //Alterado funcao retorna numeracao automatica					
	cNumOP := GetNumSC2()                
 
	AAdd( aCab, {'C2_FILIAL'	,	XFILIAL('SC2' )	, nil	})
	AAdd( aCab, {'C2_NUM'		,	cNumOP			, nil	})   
	AAdd( aCab, {'C2_ITEM'		,	'01' 			, nil	})
	AAdd( aCab, {'C2_SEQUEN'	,	'001'			, nil	})
	AAdd( aCab, {'C2_PRODUTO'	,	cGetCodPro		, nil	})
	AAdd( aCab, {'C2_QUANT'		,	cGetQtVI1		, nil	})
	AAdd( aCab, {'C2_LOCAL'		,	vArm1			, nil	})     //Armazem QS (não Aprovado)
	AAdd( aCab, {'C2_CC'		,	'320101'		, nil	})
	AAdd( aCab, {'C2_DATPRI'	,	dDataBase 		, nil	})
	AAdd( aCab, {'C2_DATPRF'	,	dDataBase + 10	, nil	})
	AAdd( aCab, {'C2_OPMIDO'	,	cGetNPart		, nil	})
	AAdd( aCab, {'C2_EMISSAO'	,	dDataBase		, nil	})
	AAdd( aCab, {'C2_QTDLOTE'	,   cGetQtVI1		, nil	})
	AAdd( aCab, {'C2_OBS'		,	cGetNPart		, nil	})     
	AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
	AAdd( aCab, {"AUTEXPLODE"	,	'S'				, NIL    })
	
	IncProc("Gerando plano -> ")
	
	lMsErroAuto := .F.
	msExecAuto({|x,Y| Mata650(x,Y)},aCab,3) 
	
	dbGotop()
	dbSelectArea('SC2')
	dbSetOrder(1)
	If dbSeek(xFilial('SC2')+cNumOP)
		RecLock("SC2",.F.)
		SC2->C2_ITEMCTA := xFilial("SC2")
		MsUnLock("SC2")
	EndIf


	If lMsErroAuto
		RollBackSx8()
		MostraErro()
	Else
		//ConfirmSx8() 
		cSayOP1 := SC2->C2_NUM
		oSayOP1 := TSay():New( 015,200,{|u| '            ' },oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,151,010)
		oSayOP1:Refresh()
		oSayOP1 := TSay():New( 015,200,{|u| If(PCount()>0, cSayOP1:=u, cSayOP1)},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_LIGHTGRAY,151,010)
		oSayOP1:Refresh()
		APMsgInfo('OP Inserida com sucesso...'+SC2->C2_NUM)
		cOP 	:= SC2->C2_NUM
		cItem	:= SC2->C2_ITEM
		cSeq	:= SC2->C2_SEQUEN
		nQuant	:= SC2->C2_QUANT
		
		dbGotop()
		dbSelectArea('SC2')
		dbSetOrder(1)
		dbSeek(xFilial('SC2')+cOP)

		//Prepara para fazer o apontamento da OP  
		// Adicionado AAdd D3_LOTECTL como correcao apontamentos com lote diferente partida (multiplas telas simultaneas) - Diego 20/10/2016
		PUTMV("MV_FORMLOT", "") //Limpa a formula do parametro para continuar com o padrao
		PUTMV("MA_LOTEMED", "") //Limpa a formula do parametro para continuar com o padrao	
					
        aItens  := {}
		AAdd( aItens, {'D3_FILIAL'		,	XFILIAL('SD3' )					, nil	})
		AAdd( aItens, {'D3_TM'			,	'500' 							, nil	})
		AAdd( aItens, {'D3_COD'			,	SC2->C2_PRODUTO					, nil	})
		AAdd( aItens, {'D3_OP'			,	SC2->(C2_NUM+C2_ITEM+C2_SEQUEN) , nil	})
		AAdd( aItens, {'D3_QUANT'		,	SC2->(C2_QUANT-C2_QUJE)			, nil 	})
		AAdd( aItens, {'D3_LOCAL'		,	SC2->C2_LOCAL					, nil	})
		AAdd( aItens, {'D3_DOC'			,	'OP'+SC2->C2_NUM 				, nil	})
		AAdd( aItens, {'D3_EMISSAO'	    ,	dDataBase 						, nil	}) 
		AAdd( aItens, {'D3_CC'			,	'320101' 						, nil	})
		AAdd( aItens, {'D3_CF'			,	'PR0' 							, nil	})
		AAdd( aItens, {'D3_PARCTOT'	    ,	'T' 							, nil   })
		AAdd( aItens, {'D3_ATLOBS' 		,	'OPINSPQA'						, nil	})
		AAdd( aItens, {'D3_X_FORN'		,	Ret_For(nCFor)					, nil	})
		AAdd( aItens, {'D3_PARTIDA'	    ,	SC2->C2_OPMIDO 					, nil	}) 
		// Adicionado AAdd D3_LOTECTL como correcao apontamentos com lote diferente partida (multiplas telas simultaneas) - Diego 20/10/2016
		If Posicione("SB1",1,xFilial("SB1")+cGetCodPro,"B1_RASTRO") == 'L' 
			AAdd( aItens, {'D3_LOTECTL'	,	cLote 							, nil	}) 
		EndIf
			
		lMsErroAuto := .f.
		msExecAuto({|x,Y| Mata250(x,Y)},aItens,3)
		PUTMV("MV_FORMLOT", "") //Limpa a formula do parametro para continuar com o padrao
		If lMsErroAuto
			MostraErro()
			AGF_ENVMAIL(cOP, SC2->C2_EMISSAO, cSayDesc1, SC2->C2_QUANT)
		Else
			MsUnLock('SD3')
			APMsgInfo(" OP Numero "+SC2->C2_NUM+" foi apontada com sucesso ")
			U_VSS_UFCHQA(cOP,'N')
//			AGF_ENVMAIL(cOP, SC2->C2_EMISSAO, cSayDesc1, SC2->C2_QUANT)	
		EndIf
	EndIf
EndIf


oDlg1:End()
U_OPINSPQA()

Return



//////////////////////////////////////////////////////////////////////////////////
//Funcao para envio de e-mail em caso de erro no apontamento
//////////////////////////////////////////////////////////////////////////////////
Static Function AGF_ENVMAIL(cOP, dData, cDescProd, nQtde)

     Local _cEmlFor := 'jairson.ramalho@midoriautoleather.com.br,waldelino.junior@midoriautoleather.com.br'
     Local oProcess 
     Local oHtml
     Local nCont := 0

	//     Alert('Iniciando envido e e-mail...')
     SETMV("MV_WFMLBOX","WORKFLOW") 
     oProcess := TWFProcess():New( "000004", "Problema com apontamento de OP - INSPEÇÃO DE QUALIDADE" )
     oProcess:NewTask( "Problema com apontamento", "\WORKFLOW\HTM\ApontOP.HTM" )
     oHtml    := oProcess:oHTML
	 oHtml:ValByName("Data"			,dToc(dData))
	 oHtml:ValByName("numOP"   		,cOP)
	 
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	 aAdd( oHtml:ValByName( "it.desc" ), "HOUVE PROBLEMA NO APONTAMENTO DA ORDEM DE PRODUCAO "+Substr(cOP,1,6)+" DA INSPEÇÃO DE QUALIDADE")
   	 aAdd( oHtml:ValByName( "it.desc" ), "PRODUTO: "+cDescProd )
   	 aAdd( oHtml:ValByName( "it.desc" ), "QUANTIDADE: "+cValToChar(nqtde) )
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	 aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
	 aAdd( oHtml:ValByName( "it.desc" ), "USUARIO QUE FEZ A INCLUSAO: "+substr(cUsuario,1,35))
   	 aAdd( oHtml:ValByName( "it.desc" ), "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
   	 aAdd( oHtml:ValByName( "it.desc" ), "****************************************************************************************")
   	 
   	    	                                 
	oProcess:cSubject := "Problema com apontamento de OP - INSPEÇÃO DE QUALIDADE - OP NUMERO: " + cOP

	oProcess:cTo      := _cEmlFor     

	oProcess:Start()                    
	//WFSendMail()
	//WFSendMail()	       
	oProcess:Finish()
	//Alert('Email enviado com sucesso...')
Return



//////////////////////////////////////////////////////////////////////////////////
//Funcao para informar o nome de outro fornecedor                                 
//////////////////////////////////////////////////////////////////////////////////
Static Function Vld_OFor(NovFor)

If NovFor == '01'	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de cVariable dos componentes                                 ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	Private cOFor   := Space(40)
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oDlg3","oOFor","oGet1","oBtnOK")
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlg3      := MSDialog():New( 091,232,203,392,"Fornecedor",,,.F.,,,,,,.T.,,,.T. )
	oOFor      := TSay():New( 008,012,{||"Informe o Fornecedor:"},oDlg3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
	oGet1      := TGet():New( 020,008,{|u| If(PCount()>0, cOFor:=u, cOFor)},oDlg3,056,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oBtnOK     := TButton():New( 032,008,"OK",oDlg3,{|| oDlg3:End(),Nov_For(cOFor,NovFor)},056,012,,,,.T.,,"",,,,.F. )

	oDlg3:Activate(,,,.T.)  
	
EndIf

Return          



//Chamado pela funcao anterior (Vld_OFor) no botao OK
Static Function Nov_For(cOFor,NovFor)
	nFor:="01="+cOFor
	
	If NovFor == '01'
		cSayNovFor:=nFor
		oSayNovFor:Refresh()
	Else
		cSayNovFor:=Space(50)
		oSayNovFor:Refresh()
	EndIf
Return



//////////////////////////////////////////////////////////////////////////////////
//Funcao que retorna o nome do fornecedor a ser gravado na tabela em vez do cod. do campo nCFor
//////////////////////////////////////////////////////////////////////////////////
Static Function Ret_For(cFor)
Public cNome

Do Case
	Case Alltrim(cFor) == "00"
		cNome:=Space(50)
	Case Alltrim(cFor) == "01"
		cNome:=cSayNovFor
	Case Alltrim(cFor) == "02"
		cNome:="02=CUBATÃO"
	Case Alltrim(cFor) == "03"
		cNome:="03=QUATRO PATAS"
	Case Alltrim(cFor) == "04"
		cNome:="04=MINERVA"
	Case Alltrim(cFor) == "05"
		cNome:="05=MARFRIG"
	Case Alltrim(cFor) == "06"
		cNome:="06=VIPOSA"
	Case Alltrim(cFor) == "07"
		cNome:="07=VANZELA"
	Case Alltrim(cFor) == "08"
		cNome:="08=HUMAITÁ"		
	Case Alltrim(cFor) == "09"
		cNome:="09=JANGADA"
	Case Alltrim(cFor) == "10"
		cNome:="10=PANORAMA"

EndCase

Return(cNome)  







//////////////////////////////////////////////////////////////////////////////////
//Funcao para emissao de segunda via do FichQUA                                   
//////////////////////////////////////////////////////////////////////////////////
Static Function VSS_SEGVIA()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cBuscaOP   := Space(6)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg2","oBuscaOP","oGet1","oBtnprint")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg2      := MSDialog():New( 091,232,203,392,"Busca OP",,,.F.,,,,,,.T.,,,.T. )
oBuscaOP   := TSay():New( 008,012,{||"Informe o Num da OP:"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGet1      := TGet():New( 020,008,{|u| If(PCount()>0, cBuscaOP:=u, cBuscaOP)},oDlg2,056,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SC2","",,)
oBtnprint  := TButton():New( 032,008,"Imprimir",oDlg2,{|| oDlg2:End(),U_VSS_UFCHQA(cBuscaOP)},056,012,,,,.T.,,"",,,,.F. )

oDlg2:Activate(,,,.T.)

Return
