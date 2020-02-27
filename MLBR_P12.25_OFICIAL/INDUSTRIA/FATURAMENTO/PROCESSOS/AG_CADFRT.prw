#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

///////////////////////////////////////////////////////////////////////////////////
//Cadastro de conhecimento de frete de vendas
//Desenvolvido por Anesio G.Faria anesio@anesio.com.br - 17-06-2014
///////////////////////////////////////////////////////////////////////////////////
User Function AG_CADFT()
//Variáveis private
Local nOpc 		   := GD_INSERT+GD_DELETE+GD_UPDATE
Private cGetCli    := Space(6)
Private cGetCodTr  := space(6)                     
Private cLjTrans   := space(2)
Private cGetOrig   := Space(50)
Private cGetDest   := Space(50)
Private cGetDtEmis := dDataBase
Private cGetLojCli := Space(2)
Private cGetNConhe := space(9)
Private cGetNFiscal:= Space(9)
Private cGetSerie  := Space(3)
Private cGetVlrCon := 0
Private cGetVlrMer := 0
Private cGetVlrNF  := 0
Private cSayCdTran := Space(1)
Private cSayOrig   := "Origem: " 
Private cSayDest   := "Destino: "
Private cSayDtEmis := Space(1)
Private cSayNConh  := Space(1)
Private cSayNFisca := Space(1)
Private cSayNFisca := Space(1)
Private cSayNomeCl := Space(1)
Private cSaySerie  := Space(5)
Private cSayTpNf   := Space(1)
Private cSayTransp := Space(1)
Private cSayVlrCon := Space(1)
Private cPlacaV := Space(7)
Private cGetVlrMer := 0
Private nCBoxTpNF 
Private cDescTran := "..." //Descricao da Transportadora
Private cDescCli  := "...." //Descricao do Cliente
Private cMsgCF:= "Código do Cliente: " //Mensagem do codigo do Cliente/Fornecedor     
Private aHoBrw1 := {}  
Private aCoBrw1 := {}
Private noBrw1  := 3 
Private bLinOk := {|| fValidLn()}                   

SetPrvt("oFont1","oFont2","oFont3","oDlg1","oSay1","oGrpConhec","oSayNConh","oSayDtEmiss","oSayCdTrans","oSayDest","oGetPlacaV","oSayPlacaV")
SetPrvt("oSayVlrConhec","oSayTpNf","oSayNFiscal","oSaySerie","oSay2","oSayNomeCli","oGetNConhec","oGetDtEmiss","oGetOrig", "oGetDest")
SetPrvt("oGetVlrConhec","oCBoxTpNF","oGetNF1","oGetNF2","oGetSF2","oGetCli","oGetFor", "oGetLojCli","oBtnSalva","oBtnCancel","oGrid","oSayVlrMer")
             
      
//Aadd(aHoBrw1,{"Titulo", SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, "", "", SX3->X3_TIPO, "", "" } )
Aadd(aHoBrw1,{"N.Fiscal", "ZM_NFISCAL", "@!", 09, 00, 'AllwaysTrue()', "", "N", "", "" })
Aadd(aHoBrw1,{"Serie", "ZM_SERIE", "@!", 03, 00, 'AllwaysTrue()', "", "N", "", "" })
Aadd(aHoBrw1,{"Vlr. Rateio", "ZM_VALFRET", "@E 99,999,999.99", 13, 02, "", "", "N", "", "" })
MCoBrw1()                                     


//Montagem da tela...
oFont1     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "Arial monospaced for SAP",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oFont3     := TFont():New( "Arial",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 099,277,620,968,"Digitação de Conhecimento de Frete",,,.F.,,,,,,.T.,,,.T. )
//oSay1      := TSay():New( 162,004,{||"Dpto T.I. - Midori Atlantica..."},oDlg1,,,.F.,.F.,.F.,.T.,CLR_LIGHTGRAY,CLR_WHITE,072,008)
oGrpConhec := TGroup():New( 004,004,205,336,"Dados do Conhecimento",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayNConh  := TSay():New( 020,008,{||"Numero do Conhecimento:"},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,096,008)
oSayDtEmis := TSay():New( 020,176,{||"Data Emissao:"},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,056,008)
oSayCdTran := TSay():New( 040,008,{||"Código Forn.Transporte:"},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,092,008)                       
oSayTransp := TSay():New( 040,170,{||cDescTran},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,168,008)
oSayPlacaV := TSay():New( 058,008,{||"Placa Veículo:"},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,092,008)
oSayVlrCon := TSay():New( 082,008,{||"Valor do Conhecimento:"},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,088,008)
oSayVlrMer := TSay():New( 082,176,{||"Valor Merca.: "},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,052,008)
oSayTpNf   := TSay():New( 104,008,{||"Tipo de Nota: "},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,052,008)
//oSayNFisca := TSay():New( 074,008,{||"Numero da Nota:"},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,088,008)
//oSaySerie  := TSay():New( 074,176,{||"Serie:"},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)
oSayOrig   := TSay():New( 210,008,{||cSayOrig },oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)
oSayDest   := TSay():New( 226,008,{||cSayDest },oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)
oSay2      := TSay():New( 104,140,{||cMsgCF },oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,088,008)
oSayNomeCl := TSay():New( 119,009,{||cDescCli},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,307,008)
oGetNConhe := TGet():New( 018,104,{|u| If(PCount()>0,cGetNConhec:=u,cGetNConhec)},oGrpConhec,064,009,'@!',{|| vldConhec(cGetNConhec)},CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetNConhec",,)
oGetDtEmis := TGet():New( 018,232,{|u| If(PCount()>0,cGetDtEmiss:=u,cGetDtEmiss)},oGrpConhec,060,009,'@E 99/99/9999',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDtEmiss",,)
oGetCodTr  := TGet():New( 038,104,{|u| If(PCount()>0,cGetCodTr:=u,cGetCodTr)},oGrpConhec,044,009,'@!',{|| vltr(cGetCodTr)},CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2","cGetCodTr",,)
oGetLojTr  := TGet():New( 038,150,{|u| If(PCount()>0,cLjTrans:=u,cLjTrans)},oGrpConhec,012,009,'@!',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cLjTrans",,)
oGetPlacaV := TGet():New( 056,68,{|u| If(PCount()>0,cPlacaV:=u,cPlacaV)},oGrpConhec,040,009,'@!',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPlacaV",,)
oGetVlrCon := TGet():New( 082,104,{|u| If(PCount()>0,cGetVlrConhec:=u,cGetVlrConhec)},oGrpConhec,060,009,'@E 9,999,999.99',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetVlrConhec",,)
oGetVlrMer := TGet():New( 082,232,{|u| If(PCount()>0,cGetVlrMer:=u,cGetVlrMer)},oGrpConhec,070,009,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetVlrMer",,)
oCBoxTpNF  := TComboBox():New( 102,062,{|u| If(PCount()>0,nCBoxTpNF:=u,nCBoxTpNF)},{"V=Vendas","C=Compras"},064,011,oGrpConhec,,{|| fClean(), atvF3()},,CLR_BLUE,CLR_WHITE,.T.,oFont2,"Informe o Tipo de Nota fiscal, V=Venda, C=Compra",,,,,,,nCBoxTpNF )

//oGetNF2    := TGet():New( 072,104,{|u| If(PCount()>0,cGetNFiscal:=u,cGetNFiscal)},oGrpConhec,060,009,'@!',{|| fOrigem() },CLR_BLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF2VEI","cGetNFiscal",,)
//oGetSF2    := TGet():New( 072,208,{|u| If(PCount()>0,cGetSerie:=u,cGetSerie)},oGrpConhec,032,009,'',,CLR_BLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetSerie",,)
oGetCli    := TGet():New( 102,220,{|u| If(PCount()>0,cGetCli:=u,cGetCli)},oGrpConhec,044,009,'@!',{|| oGetLjC:SetFocus(), fOrigem()},CLR_BLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1","cGetCli",,)
oGetLjC    := TGet():New( 102,265,{|u| If(PCount()>0,cGetLojCli:=u,cGetLojCli)},oGrpConhec,019,009,'@!',{|| fOrigem(),vldCli(cGetCli,cGetLojCli, 1) },CLR_BLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,,"cGetLojCli",,)

//oGetNF1    := TGet():New( 072,104,{|u| If(PCount()>0,cGetNFiscal:=u,cGetNFiscal)},oGrpConhec,060,009,'@!',{||},CLR_BLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF1VEI","cGetNFiscal",,)
//oGetSF1  := TGet():New( 072,208,{|u| If(PCount()>0,cGetSerie:=u,cGetSerie)},oGrpConhec,032,009,'',,CLR_BLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetSerie",,)
oGetFor    := TGet():New( 102,230,{|u| If(PCount()>0,cGetCli:=u,cGetCli)},oGrpConhec,044,009,'@!',{|| oGetLjF:SetFocus(), fOrigem()},CLR_BLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2","cGetCli",,)
oGetLjF    := TGet():New( 102,280,{|u| If(PCount()>0,cGetLojCli:=u,cGetLojCli)},oGrpConhec,019,009,'@!',{|| fOrigem(),vldCli(cGetCli,cGetLojCli, 2)},CLR_BLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,,"cGetLojCli",,)

oGrid := MsNewGetDados():New(134,008,198,300,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrpConhec,aHoBrw1,aCoBrw1,{|| U_GChange()} )

cGetOrig := fOrigIni()
oGetOrig   := TGet():New( 210,044,{|u| If(PCount()>0,cGetOrig:=u,cGetOrig)},oGrpConhec,256,010,'@!',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetOrig",,)
oGetDest   := TGet():New( 226,044,{|u| If(PCount()>0,cGetDest:=u,cGetDest)},oGrpConhec,256,010,'@!',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDest",,)
oBtnSalva  := TButton():New( 240,204,"&Salvar",oDlg1,{|| btSalva(1)},052,012,,oFont2,,.T.,,"Salvar as informacoes",,,,.F. )
oBtnCancel := TButton():New( 240,268,"&Cancelar",oDlg1,{|| oDlg1:end()},052,012,,oFont2,,.T.,,"",,,,.F. )


//oGetNF1:Hide()
//oGetSF1:Hide()
oGetFor:Hide()
oGetLjF:Hide()

oDlg1:Activate(,,,.T.)


return

//////////////////////////////////////////////////////////////////////////
//Funcao para ativar a busca via F3
//Caso selecionado venda, ativa SF2, caso selecionado compra, ativa SF1
//////////////////////////////////////////////////////////////////////////
static function atvF3()
oSay2:disable()
if nCBoxTpNF == "C" 
	//oGetNF1:enable()
	//oGetNF1:Show()
	//oGetSF1:enable()
	//oGetSF1:Show()
	//oGetNF2:disable()
	//oGetNF2:Hide()
	//oGetSF2:disable()
	//oGetSF2:Hide()
	oGetFor:enable()
	oGetFor:Show()
	oGetLjF:enable()
	oGetLjF:Show()
	oGetCli:disable()
	oGetCli:Hide()
	oGetLjc:disable()
	oGetLjC:Hide()
	cMsgCF:= "Código do Fornecedor: " 
elseif nCBoxTpNF == "V"
	//oGetNF1:disable()
	//oGetNF1:Hide()
	//oGetSF1:disable()
	//oGetSF1:Hide()
	//oGetNF2:enable()
	//oGetNF2:Show()
	//oGetSF2:enable()
	//oGetSF2:Show()
	oGetFOr:disable()
	oGetFor:Hide()
	oGetLjF:disable()
	oGetLjF:Hide()
	oGetCli:Enable()
	oGetCli:Show()
	oGetLjC:Enable()
	oGetLjC:Show()
	cMsgCF:= "Código do Cliente: "
else
	oGetNF1:enable()
	oGetNF1:Show()
	oGetSF1:enable()
	oGetSF1:Show()
	oGetNF2:disable()
	oGetNF2:Hide()
	oGetSF2:disable()
	oGetSF2:Hide()
	oGetFOr:disable()
	oGetFor:Hide()
	oGetLjF:disable()
	oGetLjF:Hide()
	oGetCli:Enable()
	oGetCli:Show()
	oGetLjC:Enable()
	oGetLjC:Show()
	cMsgCF:= "Código do Cliente: "
endif
oSay2:refresh()
oGetCli:refresh()
//oGetNF1:refresh()
//oGetNF2:refresh()
oGetFor:refresh()
oSay2:refresh()
return
      
////////////////////////////////////////////////////////////////////
//Valida a transportadora
////////////////////////////////////////////////////////////////////
static function vltr(cGetCodTr)
cLjTrans := Posicione("SA2",1,xFilial("SA2")+cGetCodTr,"A2_LOJA")
cDescTran:= Posicione("SA2",1,xFilial("SA2")+cGetCodTr+cLjTrans,"A2_NOME")
oSayTransp:Refresh()
return

////////////////////////////////////////////////////////////////////
//Valida a transportadora
////////////////////////////////////////////////////////////////////
static function vlljtr(cGetCodTr, cLjTrans)
cDescTran:= Posicione("SA2",1,xFilial("SA2")+cGetCodTr+cLjTrans,"A2_NOME")
oSayTransp:Refresh()
oGetLojTr:Refresh()
return

////////////////////////////////////////////////////////////////////
//Valida o cliente/fornecedor
////////////////////////////////////////////////////////////////////
static function vldCli(cGetCli, cGetLojCli, nOri)
if nOri == 1
	cDescCli := Posicione("SA1",1,xFilial("SA1")+cGetCli+cGetLojCli, "A1_NOME")
else
	cDescCli := Posicione("SA2",1,xFilial("SA2")+cGetCli+cGetLojCli, "A2_NOME")
endif
oSayNomeCl:Refresh()
return

////////////////////////////////////////////////////////////////////
//Montagem a tela inicial do browse
////////////////////////////////////////////////////////////////////
User Function AG_FRETE()
Local 	aCampos		:= {}
Private cMarca 		:= GetMark()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCadastro := "Conhecimentos de Frete..."

Private aRotina := MenuDef()
Private aIndTmp 	:= {}
Private oVermelho   := LoadBitmap( GetResources(), "BR_VERMELHO" )
Private oAmarelo    := LoadBitmap( GetResources(), "BR_AMARELO" )
Private oVerde      := LoadBitmap( GetResources(), "BR_VERDE" )


dbSelectArea("SZM")
dbGoTop()

aCampos := {}
//AADD(aCampos,{"ZM_OK"            		,""," "						})
AADD(aCampos,{"ZM_NUMCONH"  		    ,"","Num.Conhecimento"    	})
AADD(aCampos,{"ZM_DTCONHE"    	        ,"","Dt.Conhecimento"    	})
AADD(aCampos,{"ZM_TRANSP"    		    ,"","Transp"    			})
AADD(aCampos,{"ZM_NOMTRAN" 	    	    ,"","Nome Transp" 			})
AADD(aCampos,{"ZM_NFISCAL"  	        ,"","Nota Fiscal"    		})
AADD(aCampos,{"ZM_SERIE"    	       	,"","Serie"    				})
AADD(aCampos,{"ZM_CLIENTE"    		    ,"","Cliente"    			})
AADD(aCampos,{"ZM_LOJCLI"    			,"","Loja"    				})
AADD(aCampos,{"ZM_NOMCLI"    	        ,"","Nome do Cliente"    	})
AADD(aCampos,{"ZM_VALCONH"    	        ,"","Valor do Conhec."    	})
AADD(aCampos,{"ZM_TPNOTA"    	        ,"","Tipo Nota"    			})
//
aCores := {} // Limpando a variavel
Aadd(aCores,{" ZM_TPNOTA == 'C' "                     ,"BR_VERMELHO" })
Aadd(aCores,{" ZM_TPNOTA == 'V' "                     ,"BR_VERDE"    })


MarkBrow("SZM","", ,aCampos , , , , , , , , , , , aCores )
//MarkBrow("SZM","", ,aCampos , , cMarca , , , , , , , , , aCores )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna indices do SZM                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SZM")
dbSetOrder( 1 ) // Ordenado pelo numero do Plano do Cliente
aEval(aIndTmp, {|cFile| fErase(cFile+OrdBagExt())})

RETURN


////////////////////////////////////////////////////////////////////
//Montagem do menu
////////////////////////////////////////////////////////////////////
Static Function MenuDef()
Private aRotina := {	{"Incluir"			,"U_AG_CADFT"	,0,3} ,;  
						{"Alterar Conhec"	,"U_AG_ALTFT"	,0,4} ,;             
             			{"Excluir Conhec"	,"U_AG_EXLFT"	,0,5} ,;
		            	{"Relatório Frete"	,"U_AG_RLFRET"	,0,0} ,;
            		 	{"Legenda"			,"u_LegFret"	,0,0} }

Return(aRotina)


////////////////////////////////////////////////////////////////////
//Mostra legenda das cores
////////////////////////////////////////////////////////////////////
User Function LegFret()

Local aLegenda := { { "BR_VERMELHO", 'Nota fiscal de Entrada' } , ;  
					{ "BR_VERDE", 'Nota fiscal de Saída'} }
BrwLegenda( 'Rotina de Lançamento de fretes', 'Status ', aLegenda  ) 
Return(.T.)


////////////////////////////////////////////////////////////////////
//Mostra legenda das cores
////////////////////////////////////////////////////////////////////
static function btSalva(nTp)  
Local nPosNF := ASCAN(aHoBrw1, {|x| AllTrim(x[2]) == 'ZM_NFISCAL'})
Local nPosSerie := ASCAN(aHoBrw1, {|x| AllTrim(x[2]) == 'ZM_SERIE'}) 
Local nX
	
if apmsgyesNo("Confirma gravação do conhecimento? ","Atenção!!!")

//	if nTp == 1           
    
		For nX :=1 to Len(oGrid:aCols)
			if !oGrid:aCols[1][4]   // valida se linha nao esta excluida, aCols[1][3] igual a .F.
			   	cGetNFiscal := oGrid:aCols[nX][1]
				cGetSerie := oGrid:aCols[nX][2]		
								
				// valida informacoes das NFs
				// Busca NF no banco de dados
				lRet := vldSalva(nTp) 
				
				If Len(oGrid:aCols) > 1
					nIndiceRat = Round(cGetVlrNF/cGetVlrMer,6) 
					nVlrCon = cGetVlrConhec * nIndiceRat
				Else
					nVlrCon = cGetVlrConhec
				Endif
				
				If lRet
					
					If nTp == 1
						RecLock("SZM",.T.)
					Else                  
						dbSelectArea("SZM")
						dbSetOrder(4)
						dbSeek(xFilial("SZM")+cGetCli+cGetLojCli+cGetNFiscal+cGetSerie)	
						RecLock("SZM",.F.)	
					Endif					
					SZM->ZM_FILIAL  := xFilial("SZM")
					SZM->ZM_NUMCONH	:= cGetNConhec
					SZM->ZM_DTCONHE	:= cGetDtEmiss
					SZM->ZM_TRANSP	:= cGetCodTr 
					SZM->ZM_LJTRANS := cLjTrans
					SZM->ZM_NFISCAL	:= cGetNFiscal
					SZM->ZM_SERIE	:= cGetSerie
					SZM->ZM_CLIENTE	:= cGetCli
					SZM->ZM_LOJCLI	:= cGetLojCli
					SZM->ZM_VALCONH	:= nVlrCon
					SZM->ZM_VALMERC := cGetVlrMer
					SZM->ZM_PLACA	:= cPlacaV
					If nTp == 1
					SZM->ZM_ORIGDES := cGetOrig 
					SZM->ZM_DESTINO := cGetDest
					SZM->ZM_TPNOTA	:= nCBoxTpNF
					Endif
					MsUnlock("SZM") 
				Endif
			Endif  
   		Next
	
	If lRet   	
		oDlg1:End()
		U_AG_CADFT()	
	Endif
endif	

return



////////////////////////////////////////////////////////////////////
//Tela de alteração de conhecimento
////////////////////////////////////////////////////////////////////
User Function AG_ALTFT()
//Variáveis private
dbSelectArea("SZM")

//Variáveis private
Private nOpc 		:= GD_INSERT+GD_DELETE+GD_UPDATE
Private cGetCli    := SZM->ZM_CLIENTE
Private cLjTrans   := SZM->ZM_LJTRANS
Private cGetCodTr  := SZM->ZM_TRANSP
Private cGetDtEmis := SZM->ZM_DTCONHE
Private cGetLojCli := SZM->ZM_LOJCLI
Private cGetNConhe := SZM->ZM_NUMCONH
Private cGetNFiscal:= SZM->ZM_NFISCAL
Private cGetSerie  := SZM->ZM_SERIE
Private cGetVlrConhec := SZM->ZM_VALCONH
Private cGetOrig   := SZM->ZM_ORIGDES
Private cGetDest   := SZM->ZM_DESTINO
Private cGetVlrMer := SZM->ZM_VALMERC
Private cGetVlrNF  := 0
Private cSayCdTran := Space(1)
Private cSayDtEmis := Space(1)
Private cSayNConh  := Space(1)
Private cSayNFisca := Space(1)
Private cSayNFisca := Space(1)
Private cSayNomeCl := Space(1)
Private cSaySerie  := Space(5)
Private cSayTpNf   := Space(1)
Private cSayTransp := Space(1)
Private cSayVlrCon := Space(1)
Private cPlacaV    := SZM->ZM_PLACA
Private nCBoxTpNF := SZM->ZM_TPNOTA 
Private cDescTran := Posicione("SA2",1,xfilial("SA2")+cGetCodTr+cLjTrans, "A2_NOME")
Private cDescCli  := "...." //Descricao do Cliente
Private cMsgCF:= "Código do Cliente: " //Mensagem do codigo do Cliente/Fornecedor     
Private aHoBrw1 := {}  
Private aCoBrw1 := {}
Private aItens := {}
Private noBrw1  := 0                    

SetPrvt("oFont1","oFont2","oFont3","oDlg1","oSay1","oGrpConhec","oSayNConh","oSayDtEmiss","oSayCdTrans","oSayDest","oGetPlacaV","oSayPlacaV")
SetPrvt("oSayVlrConhec","oSayTpNf","oSayNFiscal","oSaySerie","oSay2","oSayNomeCli","oGetNConhec","oGetDtEmiss","oGetOrig", "oGetDest")
SetPrvt("oGetVlrConhec","oCBoxTpNF","oGetNF1","oGetNF2","oGetSF2","oGetCli","oGetFor", "oGetLojCli","oBtnSalva","oBtnCancel","oGrid","oSayVlrMer")
             
if SZM->ZM_TPNOTA == "V"
	cDescCli := Posicione("SA1",1,xFilial("SA1")+SZM->(ZM_CLIENTE+ZM_LOJCLI),"A1_NOME")
else
	cDescCli := Posicione("SA2",1,xFilial("SA2")+SZM->(ZM_CLIENTE+ZM_LOJCLI),"A2_NOME")
endif
      
//Aadd(aHoBrw1,{"Titulo", SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, "", "", SX3->X3_TIPO, "", "" } )
Aadd(aHoBrw1,{"N.Fiscal", "ZM_NFISCAL", "@!", 09, 00, 'AllwaysTrue()', "", "N", "", "" })
Aadd(aHoBrw1,{"Serie", "ZM_SERIE", "@!", 03, 00, 'AllwaysTrue()', "", "N", "", "" })
Aadd(aHoBrw1,{"Vlr. Rateio", "ZM_VALFRET", "@E 99,999,999.99", 13, 02, "", "", "N", "", "" })
MCoBrw1()                                     

//Montagem da tela...
oFont1     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "Arial monospaced for SAP",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oFont3     := TFont():New( "Arial",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 099,277,620,968,"Digitação de Conhecimento de Frete",,,.F.,,,,,,.T.,,,.T. )
//oSay1      := TSay():New( 162,004,{||"Dpto T.I. - Midori Atlantica..."},oDlg1,,,.F.,.F.,.F.,.T.,CLR_LIGHTGRAY,CLR_WHITE,072,008)
oGrpConhec := TGroup():New( 004,004,205,336,"Dados do Conhecimento",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayNConh  := TSay():New( 020,008,{||"Numero do Conhecimento:"},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,096,008)
oSayDtEmis := TSay():New( 020,176,{||"Data Emissao:"},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,056,008)
oSayCdTran := TSay():New( 040,008,{||"Código Forn.Transporte:"},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,092,008)                       
oSayTransp := TSay():New( 040,170,{||cDescTran},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,168,008)
oSayPlacaV := TSay():New( 058,008,{||"Placa Veículo:"},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,092,008)
oSayVlrCon := TSay():New( 082,008,{||"Valor do Conhecimento:"},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,088,008)
oSayVlrMer := TSay():New( 082,176,{||"Valor Merca.: "},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,052,008)
oSayTpNf   := TSay():New( 104,008,{||"Tipo de Nota: "},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,052,008)
//oSayNFisca := TSay():New( 074,008,{||"Numero da Nota:"},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,088,008)
//oSaySerie  := TSay():New( 074,176,{||"Serie:"},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)
oSay2      := TSay():New( 104,140,{||cMsgCF },oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,088,008)
oSayNomeCl := TSay():New( 119,009,{||cDescCli},oGrpConhec,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,307,008)
oGetNConhe := TGet():New( 018,104,{|u| If(PCount()>0,cGetNConhec:=u,cGetNConhec)},oGrpConhec,064,009,'@!',{|| vldConhec(cGetNConhec)},CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetNConhec",,)
oGetDtEmis := TGet():New( 018,232,{|u| If(PCount()>0,cGetDtEmiss:=u,cGetDtEmiss)},oGrpConhec,060,009,'@E 99/99/9999',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDtEmiss",,)
oGetCodTr  := TGet():New( 038,104,{|u| If(PCount()>0,cGetCodTr:=u,cGetCodTr)},oGrpConhec,044,009,'@!',{|| vltr(cGetCodTr)},CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2","cGetCodTr",,)
oGetLojTr  := TGet():New( 038,150,{|u| If(PCount()>0,cLjTrans:=u,cLjTrans)},oGrpConhec,012,009,'@!',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cLjTrans",,)
oGetPlacaV := TGet():New( 056,68,{|u| If(PCount()>0,cPlacaV:=u,cPlacaV)},oGrpConhec,040,009,'@!',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPlacaV",,)
oGetVlrCon := TGet():New( 082,104,{|u| If(PCount()>0,cGetVlrConhec:=u,cGetVlrConhec)},oGrpConhec,060,009,'@E 9,999,999.99',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetVlrConhec",,)
oGetVlrMer := TGet():New( 082,232,{|u| If(PCount()>0,cGetVlrMer:=u,cGetVlrMer)},oGrpConhec,070,009,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetVlrMer",,)
oCBoxTpNF  := TComboBox():New( 102,062,{|u| If(PCount()>0,nCBoxTpNF:=u,nCBoxTpNF)},{"V=Vendas","C=Compras"},064,011,oGrpConhec,,{|| fClean()},,CLR_BLUE,CLR_WHITE,.T.,oFont2,"Informe o Tipo de Nota fiscal, V=Venda, C=Compra",,,,,,,nCBoxTpNF )
//oGetNF2    := TGet():New( 072,104,{|u| If(PCount()>0,cGetNFiscal:=u,cGetNFiscal)},oGrpConhec,060,009,'@!',{|| fOrigem() },CLR_BLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF2VEI","cGetNFiscal",,)
//oGetSF2    := TGet():New( 072,208,{|u| If(PCount()>0,cGetSerie:=u,cGetSerie)},oGrpConhec,032,009,'',,CLR_BLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetSerie",,)
oGetCli    := TGet():New( 102,220,{|u| If(PCount()>0,cGetCli:=u,cGetCli)},oGrpConhec,044,009,'@!',{|| oGetLjC:SetFocus(), fOrigem()},CLR_BLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1","cGetCli",,)
oGetLjC    := TGet():New( 102,265,{|u| If(PCount()>0,cGetLojCli:=u,cGetLojCli)},oGrpConhec,019,009,'@!',{|| fOrigem(),vldCli(cGetCli,cGetLojCli, 1) },CLR_BLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,,"cGetLojCli",,)

//oGetNF1    := TGet():New( 072,104,{|u| If(PCount()>0,cGetNFiscal:=u,cGetNFiscal)},oGrpConhec,060,009,'@!',{||},CLR_BLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF1VEI","cGetNFiscal",,)
//oGetSF1  := TGet():New( 072,208,{|u| If(PCount()>0,cGetSerie:=u,cGetSerie)},oGrpConhec,032,009,'',,CLR_BLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetSerie",,)
oGetFor    := TGet():New( 102,230,{|u| If(PCount()>0,cGetCli:=u,cGetCli)},oGrpConhec,044,009,'@!',{|| oGetLjF:SetFocus(), fOrigem()},CLR_BLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2","cGetCli",,)
oGetLjF    := TGet():New( 102,280,{|u| If(PCount()>0,cGetLojCli:=u,cGetLojCli)},oGrpConhec,019,009,'@!',{|| fOrigem(),vldCli(cGetCli,cGetLojCli, 2)},CLR_BLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,,"cGetLojCli",,)
atvF3()
oGrid := MsNewGetDados():New(134,008,198,300,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrpConhec,aHoBrw1,aCoBrw1,{|| U_GChange()} )

// Adicionar NFs no grid
cQVLD := " Select ZM_FILIAL, ZM_NUMCONH, ZM_TRANSP, ZM_NFISCAL, ZM_SERIE, ZM_DTCONHE, ZM_CLIENTE, ZM_LOJCLI, ZM_TPNOTA, ZM_VALCONH from SZM010 " 
cQVLD += " WHERE D_E_L_E_T_ =' ' AND ZM_FILIAL = '"+xFilial("SZM")+"' " 
cQVLD += " AND ZM_NUMCONH = '"+cGetNConhec+"' AND ZM_TRANSP = '"+cGetCodTr+"' " 
cQVLD += " AND ZM_CLIENTE = '"+cGetCli+"' AND ZM_LOJCLI = '"+cGetLojCli+"' " 
cQVLD += " AND ZM_TPNOTA = '"+nCBoxTpNF+"' "   
cQVLD += " ORDER BY ZM_NFISCAL ASC" 
if Select("TMPZM") >0 
	dbSelectArea("TMPZM")
	TMPZM->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", TcGenQry(, , cQVLD), "TMPZM", .T., .T.)

dbSelectArea("TMPZM")
TMPZM->(dbGotop())
nSumVlrCon := 0
While !TMPZM->(eof())
	nSumVlrCon += TMPZM->ZM_VALCONH
	AADD(aItens,{TMPZM->ZM_NFISCAL,TMPZM->ZM_SERIE,TMPZM->ZM_VALCONH,.F.})
	TMPZM->(dbSkip())
Enddo                  

cGetVlrConhec := nSumVlrCon
oGetVlrCon:Refresh(.T.)

//Adiciona array aItens no objeto oGrid

oGrid:oBrowse:SetArray(aItens)  
oGrid:aCols := aItens                  
//Atualizo as informações no grid
oGrid:Refresh(.T.)

cGetOrig := fOrigIni()
oGetOrig   := TGet():New( 210,044,{|u| If(PCount()>0,cGetOrig:=u,cGetOrig)},oGrpConhec,256,010,'@!',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetOrig",,)
oGetDest   := TGet():New( 226,044,{|u| If(PCount()>0,cGetDest:=u,cGetDest)},oGrpConhec,256,010,'@!',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDest",,)
oBtnSalva  := TButton():New( 240,204,"&Salvar",oDlg1,{|| btSalva(2)},052,012,,oFont2,,.T.,,"Salvar as informacoes",,,,.F. )
oBtnCancel := TButton():New( 240,268,"&Cancelar",oDlg1,{|| oDlg1:end()},052,012,,oFont2,,.T.,,"",,,,.F. )

oCBoxTpNF:Disable()
oGetNConhe:Disable()

oDlg1:Activate(,,,.T.)


return

////////////////////////////////////////////////////////////////////
//Função de Exclusao
////////////////////////////////////////////////////////////////////
user function AG_EXLFT()
if ApMsgNoYes("Confirma a exclusão do conhecimento? ", "Atenção")
    RecLock("SZM",.F.)
    DBDelete()
    MsUnlock()
    Alert("Excluido com sucesso...")
endif

return

////////////////////////////////////////////////////////////////////
//Função para acrescentar zeros a esquerda ao número do conhecimento
////////////////////////////////////////////////////////////////////
static function vldConhec(cConhec)
local cZero := ""
  
cZero := StrZero( Val(AllTrim(cConhec)),9 )

cGetNConhec := cZero
oGetNConhe:refresh()
return

////////////////////////////////////////////////////////////////////
//Função para gravar a Origem da Mercadoria durante a digitação
////////////////////////////////////////////////////////////////////
static function fOrigem()
local cOrigem  := "" 
local cDestino := ""
if nCBoxTpNF == "V"
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+"000148"+cFilAnt)
	if cFilAnt == "08" 
		cOrigem := SA2->(AllTrim(Substr(A2_NOME,1,17))+" | "+AllTrim(A2_MUN)+"-PNP2/"+A2_EST)
	elseif cFilAnt == "09" 
		cOrigem := SA2->(AllTrim(Substr(A2_NOME,1,17))+" | "+AllTrim(A2_MUN)+"-PNP1/"+A2_EST)
	else
		cOrigem := SA2->(AllTrim(Substr(A2_NOME,1,17))+" | "+AllTrim(A2_MUN)+"/"+A2_EST)
	endif
	cDestino := AllTrim(Posicione("SA1", 1, xFilial("SA1")+cGetCli+cGetLojCli, "A1_END"))
	cDestino += " - "+AllTrim(Posicione("SA1", 1, xFilial("SA1")+cGetCli+cGetLojCli, "A1_MUN"))
	cDestino += "/"  +AllTrim(Posicione("SA1", 1, xFilial("SA1")+cGetCli+cGetLojCli, "A1_EST"))
else
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+"000001"+cFilAnt)
	if cFilAnt == "08" 
		cDestino := SA1->(AllTrim(Substr(A1_NOME,1,17))+" | "+AllTrim(A1_MUN)+"-PNP2/"+A1_EST)
	elseif cFilAnt == "09" 
		cDestino := SA1->(AllTrim(Substr(A1_NOME,1,17))+" | "+AllTrim(A1_MUN)+"-PNP1/"+A1_EST)
	else
		cDestino := SA1->(AllTrim(Substr(A1_NOME,1,17))+" | "+AllTrim(A1_MUN)+"/"+A1_EST)
	endif
	cOrigem := AllTrim(Posicione("SA2", 1, xFilial("SA2")+cGetCli+cGetLojCli, "A2_END"))
	cOrigem += " - "+AllTrim(Posicione("SA2", 1, xFilial("SA2")+cGetCli+cGetLojCli, "A2_MUN"))
	cOrigem += "/"  +AllTrim(Posicione("SA2", 1, xFilial("SA2")+cGetCli+cGetLojCli, "A2_EST"))
//	cOrigem:= space(50)
endif
cGetOrig := cOrigem
cGetDest := cDestino
oGetOrig:Refresh()
oGetDest:Refresh()
return cOrigem

////////////////////////////////////////////////////////////////////////
//Função para gravar a Origem da Mercadoria na abertura da tela inicial
////////////////////////////////////////////////////////////////////////
static function fOrigIni()
local cOrigem := "" 
if nCBoxTpNF == "V
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+"000148"+cFilAnt)
	if cFilAnt == "08" 
		cOrigem := SA2->(AllTrim(Substr(A2_NOME,1,17))+" | "+AllTrim(A2_MUN)+"-PNP2/"+A2_EST)
	elseif cFilAnt == "09" 
		cOrigem := SA2->(AllTrim(Substr(A2_NOME,1,17))+" | "+AllTrim(A2_MUN)+"-PNP1/"+A2_EST)
	else
		cOrigem := SA2->(AllTrim(Substr(A2_NOME,1,17))+" | "+AllTrim(A2_MUN)+"/"+A2_EST)
	endif
else
	cOrigem:= space(50)
endif
cGetOrig := cOrigem
//oGetOrig:Refresh()
return cOrigem

//
//
static function vldSalva(nTp)
lRet := .T.
cQVLD := " " 
cQVLD := " Select ZM_FILIAL, ZM_NUMCONH, ZM_TRANSP, ZM_NFISCAL, ZM_SERIE, ZM_DTCONHE, ZM_CLIENTE, ZM_LOJCLI, ZM_TPNOTA from SZM010 " 
cQVLD += " WHERE D_E_L_E_T_ =' ' AND ZM_FILIAL = '"+xFilial("SZM")+"' " 
cQVLD += " AND ZM_NUMCONH = '"+cGetNConhec+"' AND ZM_TRANSP = '"+cGetCodTr+"' " 
cQVLD += " AND ZM_NFISCAL = '"+cGetNFiscal+"' AND ZM_SERIE = '"+cGetSerie+"' " 
cQVLD += " AND ZM_CLIENTE = '"+cGetCli+"' AND ZM_LOJCLI = '"+cGetLojCli+"' " 
cQVLD += " AND ZM_TPNOTA = '"+nCBoxTpNF+"' " 
cQVLD += " ORDER BY ZM_NFISCAL ASC" 
if Select("TMPZM") >0 
	dbSelectArea("TMPZM")
	TMPZM->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", TcGenQry(, , cQVLD), "TMPZM", .T., .T.)

dbSelectArea("TMPZM")
TMPZM->(dbGotop())
nCount := 0
while !TMPZM->(eof())
	nCount++
	TMPZM->(dbSkip())
enddo

if nCount > 0 .And. nTp == 1
	lRet := .F.
	Alert("Já existe registro cadastrado para cte'"+cGetNConhec+"' e nota fiscal '"+cGetNFiscal+"'...")
endif
           
if nCBoxTpNF == "V" 
	dbSelectArea("SF2")
	dbSetOrder(1)
	if !dbSeek(xFilial("SF2")+cGetNFiscal+cGetSerie+cGetCli+cGetLojCli) 
		Alert("Nota Fiscal de Venda '"+cGetNFiscal+"' não encontrada na base..."+chr(13)+"Por favor verificar...")
		lRet := .F.
	Else
		dbSeek(xFilial("SF2")+cGetNFiscal+cGetSerie+cGetCli+cGetLojCli) 
		cGetVlrNF := SF2->F2_VALBRUT 
	Endif	
elseif nCBoxTpNF == "C" 
	dbSelectArea("SF1")
	dbSetOrder(1)
	if !dbSeek(xFilial("SF1")+cGetNFiscal+cGetSerie+cGetCli+cGetLojCli) 
		Alert("Nota Fiscal de Compra '"+cGetNFiscal+"' não encontrada na base..."+chr(13)+"Por favor verificar...")
		lRet := .F.
	Else
		dbSeek(xFilial("SF1")+cGetNFiscal+cGetSerie+cGetCli+cGetLojCli)
		cGetVlrNF := SF1->F1_VALBRUT 
	Endif
endif    

return lRet

////////////////////////////////////////////////////////////////////////
//Função para limpar o numero da nota, serie, codigo cliente e loja
//Caso o usuário altere o tipo de nota V=Venda, C=Compra
////////////////////////////////////////////////////////////////////////
static function fClean()
//cGetNFiscal := space(9)
//cGetSerie   := space(3)
cGetCli     := space(6)
cGetLojCli  := space(2)
cGetOrig 	:= space(50)
cGetDest 	:= space(50)
//oGetNF2:Refresh()
//oGetSF2:Refresh()
oGetCli:Refresh()
oGetLjC:Refresh()
//oGetNF1:Refresh()
//oGetSF1:Refresh()
oGetFor:Refresh()
oGetLjF:Refresh()
oGetOrig:Refresh()
oGetDest:Refresh()
return      

Static Function MCoBrw1()

Local aAux := {}
Local nI

	Aadd(aCoBrw1,Array(noBrw1+1)) 
	For nI := 1 To noBrw1
	   aCoBrw1[1][nI] := CriaVar(aHoBrw1[nI][2])
	Next
	aCoBrw1[1][noBrw1+1] := .F.
               

Return      

User Function fValidLn() 
Local nPosNF
Local nPosSerie
Local nX

nPosNF := ASCAN(aHoBrw1, {|x| AllTrim(x[2]) == 'ZM_NFISCAL'})
nPosSerie := ASCAN(aHoBrw1, {|x| AllTrim(x[2]) == 'ZM_SERIE'})   	
 
	For nX :=1 to Len(oGrid:aCols)
		If !Empty(oGrid:aCols[nX][1])   // valida se linha nao esta vazia
			cZero := StrZero( Val(AllTrim(oGrid:aCols[nX][1])),9 )
			oGrid :Refresh()		
		Endif		
	Next
	
Return cZero 

User Function fPrevRat() 
Local nPosNF
Local nPosSerie

nPosNF := ASCAN(aHoBrw1, {|x| AllTrim(x[2]) == 'ZM_NFISCAL'})
nPosSerie := ASCAN(aHoBrw1, {|x| AllTrim(x[2]) == 'ZM_SERIE'})   	
 	

	// Previa valor rateio
	If !oGrid:aCols[oGrid:oBrowse:nAt, 4]   // valida se linha nao esta excluida, aCols[1][3] igual a .F.
	   	cGetNFiscal := oGrid:aCols[oGrid:oBrowse:nAt, nPosNF]
		cGetSerie := oGrid:aCols[oGrid:oBrowse:nAt, nPosSerie]		
						
		// valida informacoes das NFs
		// Busca NF no banco de dados 				
		vldSalva()
		
		nIndiceRat = Round(cGetVlrNF/cGetVlrMer,6) 
		nVlrCon = cGetVlrConhec * nIndiceRat
			
		cGetNFiscal := oGrid:aCols[oGrid:oBrowse:nAt, 3] := nVlrCon
		oGrid:Refresh()
	Endif

Return  nVlrCon


User Function GChange()

//oGrid:aCols[nX][1]
Local nPosNF
Local nPosSerie

nPosNF := ASCAN(aHoBrw1, {|x| AllTrim(x[2]) == 'ZM_NFISCAL'})
nPosSerie := ASCAN(aHoBrw1, {|x| AllTrim(x[2]) == 'ZM_SERIE'})   		
	
if ( Empty(oGrid:aCols[oGrid:oBrowse:nAt, nPosNF]) )
   	oGrid:aCols[oGrid:oBrowse:nAt, nPosNF]:= space(9)
	oGrid:aCols[oGrid:oBrowse:nAt, nPosSerie]:= space(3)
 	oGrid:Refresh()
Endif
 	
return .T.
