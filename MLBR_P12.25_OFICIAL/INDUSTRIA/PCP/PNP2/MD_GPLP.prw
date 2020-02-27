#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

//---------------------------------
/*

*/


/////////////////////////////////////////////////////////////////////////////////
//Este Programa gera ordens de produçao de pecas conforme digitacao do usuario
//foi desenvolvido com o objetivo de facilidar a inclusao de planos de producao
//de recorte.

//Desenvolvido por Anesio G.Faria - Taggs Consultoria - 30-09-2011



User Function MD_GPLP //Gerar plano parcial

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local nOpc     := GD_INSERT+GD_DELETE+GD_UPDATE
Local nOpcPeca := GD_UPDATE
Private aCoBrw1 := {}
Private aHoBrw1 := {}
Private cCodKit    := Space(6)
Private cNomeKit   := Space(60)
Private cNomePlan  := Space(12)
Private cCodPeca   := space(6)
Private cNomePeca  := space(60)
Private cCodCli    := space(6)
Private cLojaCli   := space(2)
Private cNomeCli   := space(50)
Private cRelease   := space(20)

Private nQtde      := 0
Private noBrw1  := 0
Private nRMenuCmP 
Private nRMenuCP  

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oFont2","oFont3","oFont4","oDlg1","oGrp1","oCodKit","oSay8","oGet1","oGet3","oRMenuCmP")
SetPrvt("oBtn1","oGrp2","oBrw1","oGrp3","oSay1","oSay2","oSay3","oSay7","oGet4","oGet5","oGet6","oBtnOkPc")
SetPrvt("oGrp4","oSay4","oSay5","oSay6","oGet7","oGet8","oGet9","oGet10")

//SetPrvt("oFont1","oFont2","oFont3","oFont4","oDlg1","oGrp1","oCodKit","oGet1","oGet3","oRMenuCmP","oRMenuCP")
//SetPrvt("oGet2","oBtn1","oGrp2","oBrw1","oGrp3","oSay1","oSay2","oSay3","oGet4","oGet5","oGet6","oBtnOkPc")
//SetPrvt("oSay4","oSay5","oSay6","oGet7","oGet8","oGet9")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oFont1     := TFont():New( "MS Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oFont3     := TFont():New( "MS Sans Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
oFont4     := TFont():New( "Times New Roman",0,-15,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 051,335,664,1057,"Geracao de Planos Parciais",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 004,004,044,352,"Modelo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oCodKit    := TSay():New( 012,008,{||"Código do Kit:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,012)
oSay8      := TSay():New( 012,081,{||"Descriçao do Kit"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,079,012)
oGet1      := TGet():New( 024,008,{|u| If(PCount()>0,cCodKit:=u,cCodKit)},oGrp1,056,014,'',{||Vld_Kit()},CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SG1","",,)
oGet3      := TGet():New( 025,080,{|u| If(PCount()>0,cNomeKit:=u,cNomeKit)},oGrp1,268,014,'',,CLR_BLACK,CLR_LIGHTGRAY,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,,"cNomeKit",,)
oGet3:Disable()

GoRMenuCmP := TGroup():New( 048,004,084,088,"Couro / Mat.Prima",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oRMenuCmP  := TRadMenu():New( 055,013,{"Couro","Materia Prima"},{|u| If(PCount()>0,nRMenuCmP:=u,nRMenuCmP)},oDlg1,,,CLR_BLACK,CLR_WHITE,"Gerar Plano de Couro e/ou Materia Prima",,,064,18,,.F.,.F.,.T. )
GoRMenuCP  := TGroup():New( 049,093,085,177,"Peça / Componente",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oRMenuCP   := TRadMenu():New( 056,102,{"Peca","Componente"},{|u| If(PCount()>0,nRMenuCP:=u,nRMenuCP)},oDlg1,,,CLR_BLACK,CLR_WHITE,"Gerar plano a partir dos componentes e/ou das pecas",,,064,18,,.F.,.F.,.T. )
oBtn1      := TButton():New( 056,200,"Gerar Plano",oDlg1,{|| GerPlnNovo()},136,020,,oFont3,,.T.,,"",,,,.F. )

//oBtn1:Disable()

oGrp2      := TGroup():New( 168,004,296,352,"Itens a serem gerado planos...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
MHoBrw1()
MCoBrw1()
oBrw1      := MsNewGetDados():New(180,008,292,348,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrp2,aHoBrw1,aCoBrw1 )
oGrp3      := TGroup():New( 124,004,160,348,"Digitacao do item...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 132,008,{||"Codigo"},oGrp3,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 133,049,{||"Descricao"},oGrp3,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 133,254,{||"Qtde"},oGrp3,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay7      := TSay():New( 132,203,{||"PLANO"},oGrp3,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet4      := TGet():New( 141,008,{|u| If(PCount()>0, cCodPeca:=u,cCodPeca)},oGrp3,032,008,'',{||Vld_Peca()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)
//oGet4      := TGet():New( 141,008,,oGrp3,032,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet5      := TGet():New( 141,048,{|u| If(PCount()>0, cNomePeca:=u,cNomePeca)},oGrp3,152,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet5:Disable()
oGet6      := TGet():New( 141,253,{|u| If(PCount()>0,nQtde:=u,nQtde)},oGrp3,039,008,'@E 99,999,999',{||Vld_Qtde()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oBtnOkPc   := TButton():New( 139,300,"&Confirmar",oGrp2,{||Inc_Peca()},044,012,,oFont4,,.T.,,"",,,,.F. )
oGet2      := TGet():New( 141,202,{|u| If(PCount()>0,cNomePlan:=u,cNomePlan)},oGrp3,046,008,'@!',{||Vld_PlnDig()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGrp4      := TGroup():New( 088,004,120,348,"Informacoes referente ao Cliente...",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay4      := TSay():New( 095,008,{||"Codigo/Loja"},oGrp4,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay5      := TSay():New( 095,080,{||"Nome do Cliente"},oGrp4,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
oSay6      := TSay():New( 095,256,{||"Release"},oGrp4,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,034,008)
oGet7      := TGet():New( 104,008,{|u| If(PCount()>0, cCodCli:=u,cCodCli)},oGrp4,040,010,'',{||Vld_Cliente()},CLR_BLACK,CLR_WHITE,oFont4,,,.T.,"Codigo do Cliente",,,.F.,.F.,,.F.,.F.,"SA1","",,)
oGet8      := TGet():New( 104,080,{|u| If(PCount()>0, cNomeCli:=u,cNomeCli)},oGrp4,168,010,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet8:Disable()
oGet9      := TGet():New( 104,256,{|u| If(PCount()>0, cRelease:=u,cRelease)},oGrp4,084,010,'@!',{||Vld_Release()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet10     := TGet():New( 104,061,{|u| If(PCount()>0, cLojaCli:=u,cLojaCli)},oGrp4,015,010,'@!',{||Vld_LojaCli()},CLR_BLACK,CLR_WHITE,oFont4,,,.T.,"Loja do Cliente",,,.F.,.F.,,.F.,.F.,"","",,)


oBtnOkPc:Disable()

oDlg1:Activate(,,,.T.)

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ MHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: SZH
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MHoBrw1()
Local nn1 := 0

aCpos :=  	{	{'Codigo'					,'ZH_PRODUTO'		,15,0	,'@!'						,	'AllwaysTrue()'		},;
				{'Descrição'				,'ZH_DESCR'			,60,0	,'@!'						,	'AllwaysFalse()'	},;
				{'Plano'					,'ZH_PLANO'			,12,0   ,'@!'						,	'AllwaysTrue()'		},;
				{'Qtde Produz'				,'ZH_QUANT'			,12,0	,'@E 999,999,999'			,	'AllwaysTrue()' 	} } 


DbSelectArea("SX3")
DbSetOrder(2)

For nn1 := 1 to len( aCpos )
	if DbSeek( aCpos[ nn1,2 ] )
		If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
			noBrw1++
			
			
			Aadd(aHoBrw1,{Trim( aCpos[ nn1,1 ] ),;
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
Function  ³ MCoBrw1() - Monta aCols da MsNewGetDados para o Alias: SZH
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function MCoBrw1()
Local nI
Local aAux := {}

Aadd(aCoBrw1,Array(noBrw1+1))
For nI := 1 To noBrw1
   aCoBrw1[1][nI] := CriaVar(aHoBrw1[nI][2])
Next
aCoBrw1[1][noBrw1+1] := .F.

Return



Static Function Vld_Kit()
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+cCodKit)
if SB1->B1_UM <> 'KT'
	Alert('O Codigo informado nao esta na estrutura como KIT'+chr(13)+'Favor verificar')
	oBtn1:Disable()
	oGet1:SetFocus()
else
	cNomeKit := SB1->B1_DESC
//	oBtn1:Enable()
	oGet3:Refresh() 
	oGet7:SetFocus()
//	Alert("Tipo Comp: "+cValToChar(nRMenuCP))
endif
return

Static function Vld_Plano()
local cPlano    := ""

if cNomePlan <> space(12)
	oGet7:SetFocus()
else
	Alert('Informe o nome do plano!')
	oGet2:SetFocus()
endif	      
if !u_buscahifen(cNomePlan)
	Alert('O ultimo caracter do plano precisa ser um HIFEN'+chr(13)+'VERIFIQUE!!!!!!!!!!!')
	oGet2:SetFocus()	
endif

//Funcao destinada a validacao do plano digitado...
Static function Vld_PlnDig()
Local lOkYear := .T. 

if !u_buscahifen(cNomePlan)
	Alert('O nome do plano está incorreto '+chr(13)+'VERIFIQUE!!!!!!!!!!!')
	cNomePlan := space(12)
	oGet2:SetFocus()	
endif


if cNomePlan <> space(12)
	//Validar se o plano ja foi lancado no arquivo SC2
	dbSelectArea("SC2") 
	dbSetOrder(10)
	if dbSeek(xFilial("SC2")+cNomePlan)
		while !SC2->(eof()) .and. xFilial("SC2") == SC2->C2_FILIAL .and. Padr(SC2->C2_OPMIDO,12) == Padr(cNomePlan,12)
			if Year(SC2->C2_EMISSAO) == Year(dDatabase)
				lOkYear := .F.
			endif
			SC2->(dbSkip())
		enddo
	endif
	//Validar se o plano ja foi lancado na tela atual....
 	dbSelectArea("SZH")
 	dbSetOrder(3)   
 	dbGotop()
 	if dbSeek(xFilial("SZH")+Padr(cNomePlan,12))
	 	while !SZH->(eof()) .and. xFilial("SZH")==SZH->ZH_FILIAL .and. SZH->ZH_PLANO == Padr(cNomePlan,12)
			if Year(SZH->ZH_DATA) == Year(dDatabase)
//				lOkYear := .F.
				If MsgNoYes ("Esse plano já foi lançado uma vez e/ou provavelmente excluído. Deseja utilizar o mesmo plano?")
	            Else
					Alert ("Favor informar um outro plano...")
					oGet2:SetFocus()
   					return (.F.)                                                    
				EndIf
			endif
	 		SZH->(dbSkip())
	 	enddo
    endif

	if lOkYear 			
		oGet6:SetFocus()
	else
		Alert('Plano já cadastrado'+chr(13)+'Favor Conferir')
		oGet2:SetFocus()
	endif
else
	Alert('Informe o nome do plano!')
	oGet2:SetFocus()
endif	      


return

//Funcao com objetivo de certificar que o ultimo caracter digitado é um hifen			
user function buscahifen(cNomePlan)
local lOkHifen  := .F.
local lOkchr    := .T.
local nPosHifen, i := 0   
 
//Alert('Nome do Plano no Hifen-> '+cNomePlan)
//Validar se existe hifen
for i:=1 to 11
	if Substr(cNomePlan,i,1)=='-'
		lOkHifen  := .T.
		nPosHifen := i 
		i:= 11
	endif
next i
for i := nPosHifen+1 to len(cNomePlan)
	if Substr(cNomePlan,i,1) $ '0|1|2|3|4|5|6|7|8|9| |' .and. lOkChr
		lOkchr := .T.
	else
		lOkchr := .F.
	endif
next i
if !lOkchr
	lOkHifen := lOkchr
endif

Return lOkHifen



Static Function Vld_Peca()
local aComp  := {}
local lOk    := .F.
local lOkEx  := .F.
local cGrupo := ''
Local i
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+cCodPeca)
	cNomePeca := SB1->B1_DESC
	cGrupo    := SB1->B1_GRUPO
	oGet5:Refresh() 
	if nRMenuCP == 1
		dbSelectArea("SG1")
		dbSetOrder(1)
		dbSeek(xFilial("SG1")+Padr(cCodKit,15))
			while !SG1->(eof()) .and. xFilial("SG1")==SG1->G1_FILIAL .and. SG1->G1_COD == Padr(cCodKit,15)
				Aadd(aComp, {SG1->G1_COMP})
				SG1->(dbSkip())                
			enddo
		for i:=1 to Len(aComp)
			dbSelectArea("SG1")
			dbSetOrder(1)                     
			dbGotop()
			dbSeek(xFilial("SG1")+aComp[i][1])
				while !SG1->(eof()) .and. xFilial("SG1")==SG1->G1_FILIAL .and. SG1->G1_COD == Padr(aComp[i][1],15)
					if SG1->G1_COMP == Padr(cCodPeca,15)
						cProd := SG1->G1_COMP
						oBtnOkPc:Enable()
						oGet2:SetFocus()
						i:= Len(aComp)  
						lOkEx := .T.
					endif
					SG1->(dbSkip())
				enddo
		next i
		if lOkEx == .T.
			if nRMenuCmP == 1
				for i:= 1 to len(cNomePeca)
					if Substr(cNomePeca,i,5)== 'COURO'
						lOk := .T.
						i:= len(cNomePeca)
					endif
				next i
				dbSelectArea("SG1")
				dbSetOrder(1)
				dbSeek(xFilial("SG1")+Padr(cProd,15))
				if Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_GRUPO") == '40  '
					lOk:=.T.
				endif

            else         
            	lOk := .T.
				for i:= 1 to len(cNomePeca)
					if Substr(cNomePeca,i,5)== 'COURO'
						lOk := .F.
						i:= len(cNomePeca)
					endif
				next i
            endif
    	endif

		if lOk == .F.    
			if cCodPeca <> space(6)
				if !lOkEx
					Alert('A peca informada nao pertence a estrutura do acabado'+chr(13)+'Favor conferir')
					oBtnOkPc:Disable()
				    oGet4:SetFocus()
				else 
					Alert('A peca informada nao é COURO ou nao está na estrutura do MODELO'+chr(13)+'Favor conferir')
					oBtnOkPc:Disable()
				    oGet4:SetFocus()
			 	endif
			 endif
		 else
		 	oBtnOkPc:Enable()
		 	oGet2:SetFocus()
		 endif
	else //Validar se o plano eh de componente ou nivel 02
		dbSelectArea("SG1")
		dbSetOrder(1)
		dbSeek(xFilial("SG1")+Padr(cCodKit,15))
			while !SG1->(eof()) .and. xFilial("SG1")==SG1->G1_FILIAL .and. SG1->G1_COD == Padr(cCodKit,15)
				if SG1->G1_COMP == Padr(cCodPeca,15)
					oBtnOkPc:Enable()
					oGet2:SetFocus()
					i:= Len(aComp)  
					lOkEx := .T.
				endif
				SG1->(dbSkip())
			enddo
		if lOkEx == .T.
			lOk := lOkEx
		endif
		if lOk == .F.    
			if cCodPeca <> space(6)
				Alert('O componente informado nao pertence a estrutura do acabado'+chr(13)+'Favor conferir')
				oBtnOkPc:Disable()
			    oGet4:SetFocus()
			 endif
		 else
		 	oBtnOkPc:Enable()
		 	oGet2:SetFocus()
		 endif
	endif
	if cCodCli == space(6) .or. cCodCli == ''
		Alert('Codigo/Loja do cliente inválido'+chr(13)+'Favor conferir!')
		oBtnOkPc:Disable()
		oBtn1:Disable()
		oGet7:SetFocus()
	endif				
				        
				

//	Alert("Tipo Comp: "+cValToChar(nRMenuCP))
return

Static Function Vld_Qtde()
	//Alert('Validando qtde')
return

//Função para validar se está tudo OK com a digitação do cabeçalho....
user function TudoOK1()
local tOk := .T.
local cMsg:= ""
//if nRMenuCP == 2
//	cMsg:= 'Apenas a rotina de geracao de planos de peças está disponivel!'
//	tOk := .F.
//endif
if nQtde <=0
	cMsg:= 'A quantidade precisa ser maior que zero!'
	tOk := .F.
endif
if cCodCli == space(6) .or. cLojaCli == space(2)
	cMsg:= 'Codigo/Loja do cliente inválido!'
	tOk := .F.
endif
if cRelease == space(20)
	cMsg:= 'Numero do Release invalido!'
	tOk := .F.
endif

if cMsg <> ""
	Alert(cMsg+chr(13)+'Atenção!')
	oBtn1:disable()
else
	oGet1:Disable()
	oRMenuCmP:Disable()
	oRMenuCP:Disable()
	oGet7:Disable()
    oGet9:Disable()
    oGet10:Disable()
    oBtn1:enable()
endif

	

return tOk

Static function Inc_Peca()
local cQuery := ""        
if u_TudoOK1()
	dbSelectArea("SZH")
	dbSetOrder(1)
		RecLock("SZH",.T.)
		SZH->ZH_FILIAL  := cFilant
		SZH->ZH_PRODUTO := cCodPeca
		SZH->ZH_DESCR   := cNomePeca
		SZH->ZH_QUANT   := nQtde
		SZH->ZH_PLANO   := cNomePlan
		SZH->ZH_DATA    := dDatabase
		SZH->ZH_STATUS  := 'N'
		SZH->ZH_MODELO  := cCodKit
		MsUnLock("SZH")
	
		cQuery := " Select * from SZH010 where D_E_L_E_T_ = ' ' and ZH_STATUS = 'N' and ZH_FILIAL = '"+xFilial("SZH")+"' "
	
		if Select('TRBZH') > 0
			dbSelectArea('TRBZH')
			dbCloseArea()
		endif
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZH',.T.,.T.)
 		dbSelectArea("TRBZH")
	 	dbGotop()
 		nCount:=0
	 	aCoBrw1 := {} 
 		while !TRBZH->(eof()) // .and. xFilial("SZH")==SZH->ZH_FILIAL .and. SZH->ZH_PLANO == Padr(cNomePlan,12) 
 			Aadd(aCoBrw1, {TRBZH->ZH_PRODUTO, TRBZH->ZH_DESCR, TRBZH->ZH_PLANO, TRBZH->ZH_QUANT, .F. }) 
 		
	 		TRBZH->(dbSkip())
 			nCount++
	 	enddo
			oBrw1:SetArray(aCoBrw1)
			oBrw1:oBrowse:Refresh()
		 	oGet5:SetFocus()

	oBtnOkPc:Disable()
	oGet1:Disable()
	oRMenuCmP:Disable()
	oRMenuCP:Disable()
	cNomePlan := u_novoplano(cNomePlan)
	oGet2:Refresh()
	cNomePeca := space(60)
	oGet5:Refresh()
	cCodPeca  := space(6)
	nQtde     := 0
	oGet6:Refresh()
	oGet4:Refresh()
	oGet4:SetFocus()
endif		
return 
		
/*
static function ProcPlan()
local cQuery := ""
local cPlano := ""
local lContinua := .T.
local nCount  := 0
local nDigito := 0
local cDigito := ""
if cNomePlan == space(8)
	Alert("informe o numero do Plano...")
	oGet2:SetFocus()
	Return()
endif                              
cPlano := cNomePlan
if Substr(cNomePlan,8,1) == space(1)
	cPlano:= Substr(cNomePlan,1,7)
	lContinua := .T.
else
	lContinua := .F.
endif
if lContinua
	if Substr(cNomePlan,7,1) == space(1)
		cPlano:= Substr(cNomePlan,1,6)
		lContinua := .T.
	else
		lContinua := .F.
	endif
endif

if lContinua 
	if Substr(cNomePlan,6,1) == space(1)
		cPlano:= Substr(cNomePlan,1,5)
		lContinua := .T.
	else
		lContinua := .F.
	endif
endif
	
if lContinua 
	if Substr(cNomePlan,5,1) == space(1)
		cPlano:= Substr(cNomePlan,1,4)
		lContinua := .T.
	else
		lContinua := .F.
	endif
endif

if lContinua 
	if Substr(cNomePlan,4,1) == space(1)
		cPlano:= Substr(cNomePlan,1,3)
		lContinua := .T.
	else
		lContinua := .F.
	endif
endif

	

cQuery := " select MAX(C2_OPMIDO) ULTPLANO from SC2010 "
cQuery += " where D_E_L_E_T_ = ' ' and C2_FILIAL ='08' and C2_OPMIDO <> '' "
cQuery += " and C2_OPMIDO like '"+cPlano+"%' and Substring(C2_EMISSAO,1,4) = '"+cValToChar(Year(dDatabase))+"' " 

	if Select("TMPC2") > 0
		dbSelectArea("TMPC2")
		dbCloseArea()
	endif
                                                      
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), "TMPC2", .F., .T.)

dbSelectArea("TMPC2")                          
dbGotop()
while !TMPC2->(eof())
	ncount++
	TMPC2->(dbSkip())
enddo
dbSelectArea("TMPC2")                          
dbGotop()

//Alert("nCount: "+cValToChar(ncount)+" PLANO: "+TMPC2->ULTPLANO)
if ncount == 1
	for i:= 1 to len(TMPC2->ULTPLANO)
//		Alert('Analisando item-> '+substr(TMPC2->ULTPLANO,i,1))
		if substr(TMPC2->ULTPLANO,i,1) == '-'
			
			for it:= i+1 to len(TMPC2->ULTPLANO)
//				Alert('Contando digito-->> '+Substr(TMPC2->ULTPLANO,it,1))
				cDigito := cDigito+Substr(TMPC2->ULTPLANO,it,1)
			next it
		endif
	next i
else
	cDigito := '01'
endif
	

	Processa({|| ProcP(cDigito,cPlano)},"Gerando Planos.......")
return                             
*/

static function GerPlnNovo()
	Processa({|| ProcPNovo()},"Gerando Planos.......")
return 
                           
static function ProcPNovo()
local cQuery := ""

cQuery := " Select * from SZH010 where D_E_L_E_T_ = ' ' and ZH_STATUS = 'N' and ZH_FILIAL = '"+xFilial("SZH")+"' "
	
if Select('TRBZH') > 0
	dbSelectArea('TRBZH')
	dbCloseArea()
endif
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZH',.T.,.T.)
dbSelectArea("TRBZH")
dbGotop()
nCount:=0
while !TRBZH->(eof())  

	//cNumOP := GetSXeNum('SC2','C2_NUM') //Alterado funcao retorna numeracao automatica				
	cNumOP := GetNumSC2()                
	
	aCab := {}
	AAdd( aCab, {'C2_FILIAL'		,		 XFILIAL('SC2' ),nil 								})
	AAdd( aCab, {'C2_ITEM'			,		 '01' ,nil											})
	AAdd( aCab, {'C2_SEQUEN'		,	     '001',nil											})
	AAdd( aCab, {'C2_PRODUTO'		,		 TRBZH->ZH_PRODUTO,nil								})
	AAdd( aCab, {'C2_QUANT'		    ,		 TRBZH->ZH_QUANT,nil								})
	AAdd( aCab, {'C2_LOCAL'		    ,		 '01'	,nil										})
	AAdd( aCab, {'C2_CC'			,		 '324',nil 											})
	AAdd( aCab, {'C2_DATPRI'	    ,		 dDataBase ,nil										})
	AAdd( aCab, {'C2_DATPRF'		,		 dDataBase + 10,nil									})
	AAdd( aCab, {'C2_OPMIDO'	    ,		 TRBZH->ZH_PLANO,nil		  						})
	AAdd( aCab, {'C2_EMISSAO'	    ,	     dDataBase,	nil										})
	AAdd( aCab, {'C2_CLIENTE' 		,		 cCodCli, nil										})
	AAdd( aCab, {'C2_LOJA'			,    	 cLojaCli, nil										})
	AAdd( aCab, {'C2_RELEASE'		,		 cRelease, nil										})
	AAdd( aCab, {'C2_DTRELE'		, 		 dDatabase, nil										})
	AAdd( aCab, {'C2_ITEMCTA'		,		 xFilial("SC2"), nil								})
	AAdd( aCab, {'C2_QTDLOTE'	    ,	     TRBZH->ZH_QUANT,	nil								})
	AAdd( aCab, {'C2_OBS'           ,        'ROTINA AUTOMATICA',nil                            })
	AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
	AAdd( aCab, {"AUTEXPLODE"       ,        'S',NIL 										    })
	
	incProc("Gerando plano -> "+TRBZH->ZH_PLANO)
	
	lMsErroAuto := .f.
	msExecAuto({|x,Y| Mata650(x,Y)},aCab,3)
//	ncount++

	
			If lMsErroAuto
				MostraErro()
			Endif
 		TRBZH->(dbSkip())
// 		Alert('PROXIMO GERADO -> '+TRBZH->ZH_PLANO)
 		nCount++
 	enddo                        	

	if nCount > 0  
		dbSelectArea("SZH")
		cChave := "ZH_FILIAL+ZH_STATUS"
		cIndSZH := CriaTrab(Nil,.F.)                                  
		IndRegua("SZH", cIndSZH, cChave, , , "Selecionando Itens...")
			if dbSeek(xFilial("SZH")+'N')
				while !SZH->(eof()) .and. xFilial("SZH") == SZH->ZH_FILIAL .and. SZH->ZH_STATUS == 'N'
					RecLock('SZH',.F.)
					SZH->ZH_STATUS := 'G'
					MsUnlock('SZH')
					SZH->(dbSkip())
				enddo
			endif
	
		DbSelectArea( "SZH" ) //Selecionando a area
		DbSetOrder( 1 ) //Posicionando na ordem de origem
		fErase( cIndSZH + OrdBagExt() ) //Deletando arquivo de trabalho
	
		APMsgInfo("Rotina finalizada com sucesso..."+Chr(13)+"Foram Gerados "+cValToChar(nCount)+" Planos ")	
		
		oDlg1:End()
	else
		APMsgInfo("Nao foi gerado nenhum plano..." +chr(13)+"Favor Conferir !!!!!!!")
	endif


return 

/*
static function procP(cDigito,cPlano)
local nDigito := val(cDigito)
local cPlanoOld := cPlano
local ncount :=0            

dbSelectArea("SZH")
dbSetOrder(3) // Filial + Numero do Plano...
ProcRegua(reccount())
if dbSeek(xFilial("SZH")+Padr(cNomePlan,12)+Padr(cCodKit,15))  
 	while !SZH->(eof()) .and. xFilial("SZH") == SZH->ZH_FILIAL .and. SZH->ZH_PLANO == Padr(cNomePlan,12) .and. SZH->ZH_MODELO == Padr(cCodKit,15)
 		if SZH->ZH_STATUS == 'N' .and. SZH->ZH_QUANT > 0
	 		nDigito++                                                 
 			if nDigito < 100 
 				cPlano := cPlano + strzero(nDigito,2)
	 		else
 				cPlano := cPlano + strzero(nDigito,3)
 			endif                                                                      

			aCab := {}
			AAdd( aCab, {'C2_FILIAL'		,		 XFILIAL('SC2' ),nil 								})
			AAdd( aCab, {'C2_ITEM'			,		 '01' ,nil											})
			AAdd( aCab, {'C2_SEQUEN'		,	     '001',nil											})
			AAdd( aCab, {'C2_PRODUTO'		,		 SZH->ZH_PRODUTO,nil								})
			AAdd( aCab, {'C2_QUANT'		    ,		 SZH->ZH_QUANT,nil 									})
			AAdd( aCab, {'C2_LOCAL'		    ,		 '01'	,nil										})
			AAdd( aCab, {'C2_CC'			,		 '324',nil 											})
			AAdd( aCab, {'C2_DATPRI'	    ,		 dDataBase ,nil										})
			AAdd( aCab, {'C2_DATPRF'		,		 dDataBase + 10,nil									})
			AAdd( aCab, {'C2_OPMIDO'	    ,		 cPlano,nil		  									})
			AAdd( aCab, {'C2_EMISSAO'	    ,	     dDataBase,	nil										})
			AAdd( aCab, {'C2_QTDLOTE'	    ,	     SZH->ZH_QUANT,	nil									})
			AAdd( aCab, {'C2_OBS'           ,        'ROTINA AUTOMATICA',nil                            })
			AAdd( aCab, {"AUTEXPLODE"       ,        'S',NIL 										    })
			incProc("Gerando plano -> "+cPlano)
			lMsErroAuto := .f.
			msExecAuto({|x,Y| Mata650(x,Y)},aCab,3)
			RecLock("SC2",.F.)
			 	SC2->C2_CLIENTE := cCodCli
			 	SC2->C2_LOJA    := cLojaCli
			 	SC2->C2_RELEASE := cRelease
			MsUnLock("SC2")
			ncount++
	
			If lMsErroAuto
				MostraErro()
			else
				cPlano := cPlanoOld 
			Endif
        endif
		
	SZH->(dbSkip())
	EndDo
	
	dbSelectArea("SZH")
	dbSetOrder(3) // Filial + Numero do Plano...
	if dbSeek(xFilial("SZH")+Padr(cNomePlan,12)+Padr(cCodKit,15))  
 		while !SZH->(eof()) .and. xFilial("SZH") == SZH->ZH_FILIAL .and. SZH->ZH_PLANO == Padr(cNomePlan,12) .and. SZH->ZH_MODELO == Padr(cCodKit,15)
 			if SZH->ZH_STATUS == 'N' 
			 	RecLock("SZH",.F.)
				SZH->ZH_DATA   := dDatabase
				SZH->ZH_STATUS := 'G' 	
				SZH->ZH_PLANO  := cPlano        
				MsUnLock("SZH")   
				incProc("Atualizando os registros gerados..."+cPlano)
				if SZH->ZH_QUANT == 0
					Alert('Quantidade digitada igual a zero foi descartado...')
				endif
			endif
		SZH->(dbSkip())
		enddo
	endif
	
	if nCount > 0
		APMsgInfo("Rotina finalizada com sucesso..."+Chr(13)+"Foram Gerados "+cValToChar(nCount)+" Planos ")	
		oDlg1:End()
	else
		APMsgInfo("Nao foi gerado nenhum plano..." +chr(13)+"Favor Conferir !!!!!!!")
	endif

endif 
return
*/
static function Vld_Cliente()
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+cCodCli+cLojaCli)
cNomeCli := SA1->A1_NOME
oGet8:Refresh() 
if cCodCli <> space(6)
	oGet10:SetFocus()
endif

return

static function Vld_LojaCli()

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+cCodCli+cLojaCli)
cNomeCli := SA1->A1_NOME
oGet8:Refresh() 
if cLojaCli <> space(2)
	oGet9:SetFocus()
endif
	
return

static function Vld_Release
	oGet4:SetFocus()
return


user function novoplano(cNomePlano)
Local cNovoPlano := space(12)
Local cPlanoParc := "" 
Local cNumSeq    := ""
Local nNumSeq    := "" 
Local i
//Alert('Nome do Plano -> '+cNomePlano)
for i:=1 to len(cNomePlano)
	if substr(cNomePlano,i,1)== '-' 
		cPlanoParc := Substr(cNomePlano,1,i)
		i:= len(cNomePlano)
	endif
next i
cNumSeq := Substr(cNomePlano,Len(cPlanoParc)+1, Len(cNomePlano) - Len(cPlanoParc)+1)
nNumSeq := val(cNumSeq)
nNumSeq++
if Len(cPlanoParc) < 10
	cNovoPlano := cPlanoParc + strzero(nNumSeq,3)
elseif Len(cPlanoParc) == 10
	cNovoPlano := cPlanoParc + strzero(nNumSeq,2)
else 
	cNovoPlano := cPlanoParc + strzero(nNumSeq,1)
endif	
return cNovoPlano