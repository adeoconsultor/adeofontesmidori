#include "protheus.ch"
#include "rwmake.ch"
#include "FONT.ch"

//+--------------------------------------------------------------------+
//| Rotina | MD_TGERPL | Autor | Anesio - Taggs     | Data | 11.07.2011|
//+--------------------------------------------------------------------+
//| Descr. | Programa para Geração de Planos MAC e Emparelhamento      |
//+--------------------------------------------------------------------+
//| Uso    | Penapolis 2 Corte                                         |
//+--------------------------------------------------------------------+
User Function MD_TGERPL()
	Local cFiltra := ""                         
	Local cCodigo := SG1->G1_COD
	Local cAlias := "SG1"
	Local cFiltra := "G1_FILIAL == '"+xFilial('SG1')+"' .And. G1_COD == '"+cCodigo+"' "
	Private cCadastro := "Geracao de Planos..."
	Private aRotina   := {}
	Private aIndexSG1 := {}                               
	Private bFiltraBrw := { || FilBrowse(cAlias, @aIndexSG1, @cFiltra)}
	
	AADD( aRotina, {"Pesquisar"  			,"AxPesqui" ,0,1})
	AADD( aRotina, {"Visualizar" 			,'U_GPVisu',0,2})
	AADD( aRotina, {"Gerar Plano PÇ"		,'U_GPInc',0,3})
	AADD( aRotina, {"Gerar Plano CP"   		,'U_GPComp',0,4})

//    alert("Filtro..."+cFiltra)
//	cFiltra := SG1->G1_FILIAL == xFilial("SG1") .and. SG1->G1_COD == cCodigo


	dbSelectArea("SG1")
	dbSetOrder(1)      
	eval(bFiltraBrw)

	dbSelectArea(cAlias)

	dbGoTop()

	
	MBrowse(,,,,"SG1")
	
	EndFilBrw(cAlias,aIndexSG1)
Return             


//+--------------------------------------------------------------------+
//| Rotina | GPInc     | Autor | Anesio - Taggs     | Data | 11.07.2011|
//+--------------------------------------------------------------------+
//| Descr. | Rotina para Gerar os Planos Recorte, Mac e Emparelhamento |
//+--------------------------------------------------------------------+
//| Uso    | Penapolis II - Corte                                      |
//+--------------------------------------------------------------------+

User Function GPInc( cAlias, nReg, nOpc ) 
	Local cArq
	Local oGet
	Local oTPanel1
	Local oTPAnel2
//	Local cFornece :=  space(6)  //Space(Len(Space(SZ8->Z8_Fornece)))
//	Local cNomeForn := space(40) //Space(Len(Space(Posicione("SA2",1,xFilial("SA2")+SZ8->Z8_Fornece,"A2_NOME"))))
	Local dData := Ctod(Space(8))                                

	
	Local nOpca		:= 0
	Local nOpc      := 4
	
	Local aCampos	:= {}
	Local aAltera	:= {}
	Local aEntid	:= {}

	
	Private aHeader := {}
	Private aCOLS := {}
	Private aREG := {}

	Private cPlano := space(8)
	Private oDlg	


	
	dbSelectArea( cAlias )
	dbGoTo( nReg )
	
	cProd       := SG1->G1_COD
	cDescr      := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_DESC")
	dData 		:= dDataBase

aCampos := U_MntaHeader(@aAltera)
U_MntCriaTMP(aCampos,@cArq)
U_GPColsTMP(nOpc)
		
	DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

  	DEFINE FONT oFnt	NAME "Arial" Size 10,15

		oTPanel1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
		oTPanel1:Align := CONTROL_ALIGN_TOP
	
		@ 4, 005 SAY "Codigo:" SIZE 70,7 PIXEL OF oTPanel1
		@ 4, 065 SAY "Prod.Acab:"   SIZE 70,7 PIXEL OF oTPanel1

		@ 3, 028 MSGET cProd When .F. SIZE 30,7 PIXEL OF oTPanel1
		@ 3, 097 MSGET cDescr   When .F. SIZE 200,7 PIXEL OF oTPanel1
		oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,15,.T.,.F.)
		oTPanel2:Align := CONTROL_ALIGN_BOTTOM
		
		If nOpc == 4    
			oGet := 	MSGetDB():New(0, 0, 0, 0, Iif(nOpc==3,4,nOpc),"U_MntaLok","U_GPcTok", "+G1_ITEM",.t.,aAltera,,.t.,,"TMP",,,,,,,"")
		Else
			oGet := MSGetDados():New(0,0,0,0,nOpc)
		Endif

		oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

                                                                                                             
    oBtnGer    := TButton():New( 02,004,"Gerar Planos dos produtos selecionados",oTPanel2,{|| ProcPlan()},140,012,,,,.T.,,"Gera os planos para os itens selecionados...",,,,.F. )
   	@004,180	SAY OemToAnsi("NUMERO PLANO: ") PIXEL	FONT oFnt COLOR CLR_BLACK	OF oTPanel2
	oGet1      := TGet():New( 02,265,{|u| If(PCount()>0,cPlano:=u,cPlano)}    ,oTPanel2,40,008  ,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPlano",,)		

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,;
				{||nOpca:=1,if(u_GPcTok(), (u_MntGrva(4), oDlg:End()),nOpca := 0)},;
				{||nOpca:=2,oDlg:End()}) VALID nOpca != 0 CENTERED

	
DbSelectArea( "TMP" )
DbCloseArea()
If Select("cArq") = 0
	FErase(cArq+GetDBExtension())
EndIf

dbSelectArea("SG1")
dbSetOrder(1)

Return nOpca
	
//+--------------------------------------------------------------------+
//| Rotina | MntaHeader | Autor | Anesio - Taggs     |Data|12.07.2011  |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para montar o vetor aHeader. Para digitação de     |
//|        | quantidades 																							 |
//+--------------------------------------------------------------------+
//| Uso    | Modulo de geração de fixas automáticas (exclusivo PNP2)   |
//+--------------------------------------------------------------------+
User Function MntaHeader(aAltera)

Local aArea:= GetArea()
Local aCampos	:= {}

PRIVATE nUsado := 0

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SG1")
While !EOF() .And. (x3_arquivo == "SG1")
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL 
		if X3_CAMPO == "G1_COD    " .or. X3_CAMPO == "G1_DESC   "; 
		     .or. X3_CAMPO == "G1_QUANT  "
			nUsado++
			if X3_CAMPO <> "G1_DESC   "                                
			    if X3_CAMPO == "G1_QUANT  " 
					AADD(aHeader,{ TRIM(X3Titulo()), x3_campo, "@E 999,999",;
									x3_tamanho, 0, 'NaoVazio()',;
									x3_usado, x3_tipo, "TMP", x3_context } )
				else
					AADD(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
									x3_tamanho, x3_decimal, x3_valid,;
									'V', x3_tipo, "TMP", x3_context } )
				
				endif
				
			else
				AADD(aHeader, { TRIM(X3Titulo()), x3_campo, "@!",;
								50, x3_decimal, x3_valid,;
								x3_usado, x3_tipo, "TMP", x3_context } )
			endif
			If Alltrim(x3_campo) <> "G1_ITEM"
				Aadd(aAltera,Trim(X3_CAMPO))
			EndIf
		EndIF
	EndIF
	aAdd( aCampos, { SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO,;
						 SX3->X3_DECIMAL } )
	dbSkip()
EndDO

Aadd(aCampos,{"G1_FLAG","L",1,0})

RestArea(aArea)

Return aCampos

//+--------------------------------------------------------------------+
//| Rotina | MntaColsTMP| Autor | Anesio - Taggs    | Data | 11.07.2011|
//+--------------------------------------------------------------------+
//| Descr. | Rotina para montar o vetor aCOLS.                         |
//+--------------------------------------------------------------------+
//| Uso    | Penapolis 2 Corte                                         |
//+--------------------------------------------------------------------+
   
user Function GPColsTMP(nOpc)
Local aArea:= GetArea()
Local cAlias	:= "SG1"
Local nPos
Local nCont
Local cOldFiltro:=""
Public cChaveRel:=""            
nOpc := 4    
If nOpc != 3						// Visualizacao / Alteracao / Exclusao
	//Gera a consulta com os componentes da estrutura....
	cQuery := " SELECT G1_COMP from SG1010 where D_E_L_E_T_ = ' ' and G1_FILIAL = '"+xFilial("SG1")+"' and G1_COD = '"+SG1->G1_COD+"' "

	IF SELECT( 'TMPSTR' ) > 0
		DbSelectArea( 'TMPSTR' )
		DbcloseArea()
	ENDIF
//
	dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQuery ), 'TMPSTR' , .F. , .T. )
//
	DbSelectArea( 'TMPSTR' )
	DbgoTop()
    nCont:=0          
	while !TMPSTR->(eof())
		cQuery1 := "SELECT G1_COMP from SG1010 where D_E_L_E_T_ = ' ' and G1_FILIAL = '"+xFilial("SG1")+"' and G1_COD = '"+TMPSTR->G1_COMP+"' "
		IF SELECT( 'TMPCOMP' ) >0 
			DbSelectArea( 'TMPCOMP' )
			dbCloseArea()
		ENDIF

			dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQuery1 ), 'TMPCOMP' , .F. , .T. )
		
		   	dbSelectArea('TMPCOMP')
		   	dbGotop()
			   	While !TMPCOMP->(EOF())
			   		if nCont== 0
					dbSelectArea("TMP")
					RecLock("TMP",.T.)
					TMP->G1_COD := TMPCOMP->G1_COMP
					TMP->G1_DESC:= Posicione("SB1",1,xFilial("SB1")+TMPCOMP->G1_COMP,"B1_DESC")
					TMP->G1_QUANT:= 0
					MsUnLock("TMP")
					endif						
					TMPCOMP->(dbSkip())
						nCont++
 				EndDo
        
		TMPSTR->(dbSkip())
	enddo
	TMP->G1_FLAG := .F.
EndIf

dbSelectArea("TMP")
dbGoTop()
RestArea(aArea)
Return



//+--------------------------------------------------------------------+
//| Rotina | MntGrvA | Autor | Anesio - Taggs     | Data | 11.07.2011  |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para gravar os dados na alteração.                 |
//+--------------------------------------------------------------------+
//| Uso    | Penapolis 1 Curtume                                       |
//+--------------------------------------------------------------------+

User Function MntGrvA(nOpc)
Local aArea := GetArea()
Local nCont
Local lDelSEQ1 := .F.
Local cChave := space(50)
dbSelectArea("TMP") 
dbgotop()           

RestArea(aArea)

Return


//+--------------------------------------------------------------------+
//| Rotina | GPcTok  | Autor | Anesio - Taggs     | Data | 13.07.2011  |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar os itens selecionados                 |
//+--------------------------------------------------------------------+
//| Uso    | Penapolis 1 Curtume                                       |
//+--------------------------------------------------------------------+
                                                      
User Function GPcTok()
Local aArea := GetArea()
Local lRet  	:= .T.
dbSelectArea("TMP")
dbGotop()
While !Eof()       
		If !U_MntaLok()
			lRet := .F.
			Exit
		EndiF
	dbSkip()
EndDo

//U_MntRefresh() //(nTotalM2, nTotalVQ, nMediaM2VQ)
RestArea(aArea)

Return lRet

//+--------------------------------------------------------------------+
//| Rotina | MntCriaTMP | Autor | Anesio - Taggs    | Data |11.07.2011 |
//+--------------------------------------------------------------------+
//| Descr. | Cria tabela temporária.                                   |
//+--------------------------------------------------------------------+
//| Uso    | Penapolis 2 Corte                                         |
//+--------------------------------------------------------------------+
User Function MntCriaTMP(aCampos,cArq)

Local cChave 
Local aArea := GetArea()

cChave 	:= "G1_ITEM"
cArq		:= CriaTrab(aCampos,.t.)

dbUseArea(.t.,,cArq,"TMP",.f.,.f.)

RestArea(aArea)

Return


//+--------------------------------------------------------------------+
//| Rotina | MntaLok | Autor | Anesio - Taggs       | Data |13.07.2011  |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar a linha de dados.                     |
//+--------------------------------------------------------------------+
//| Uso    | Penapolis 2 Corte                                         |
//+--------------------------------------------------------------------+
User Function MntaLok()
Local aArea    		:= GetArea()
Local lRet  			:= .T.             
 	if !TMP->G1_FLAG
 		TMP->G1_DESC := Posicione("SB1",1,xFilial("SB1")+TMP->G1_COD,"B1_DESC")
  		if TMP->G1_QUANT == 0
		    lRet := .F.
  		endif
	  if !lRet                                                             
	  	if APmsgYesNo("Quantidade zerada será descartada...","Continuar assim mesmo?")
  			lRet:= .T.
  		else
			Msgbox("Altere a quantidade para um numero > 0")
  		endif
	  endif
  	endif

RestArea(aArea)     

Return lRet





user function GPComp()
	Alert("Rotina de Planos de Componentes em desenvolvimento")
return
                                                       

static function ProcPlan()

if cPlano == '        '
	Alert("informe o numero do Plano...")
	oGet1:SetFocus()
	Return()
endif


dbSelectArea("SC2")
dbSetOrder(10) // Filial + Numero do Plano...
if dbSeek(xFilial("SC2")+cPlano+'-001')  
//	Alert("OP Já lançada...")
	while !SC2->(eof()).and.SC2->C2_OPMIDO == cPlano+'-001'
		if Year(SC2->C2_EMISSAO) == Year(dDataBase)
			Alert("Já existe plano com esse numero no sistema..."+Chr(13)+Chr(13)+"Escolha outro numero de Plano")
			oGet1:SetFocus()
			Return
		endif
		SC2->(dbSkip())
	enddo
else
		Processa({|| GeraPlano()},"Gerando Planos.......")
endif


return

static function GeraPlano()
Local aArea := GetArea()
Local lRet  	:= .T.
Local nCount    := 0
dbSelectArea("TMP")
dbGotop()

Procregua(reccount())

While !Eof()       
	if TMP->G1_QUANT > 0
		nCount++
		cITPlano:= cPlano+'-'+strzero(nCount,3)
		aCab := {}
	//
		AAdd( aCab, {'C2_FILIAL'		,		 XFILIAL('SC2' ),nil 								})
		AAdd( aCab, {'C2_ITEM'			,		 '01' ,nil											})
		AAdd( aCab, {'C2_SEQUEN'		,	     '001',nil											})
		AAdd( aCab, {'C2_PRODUTO'		,		 TMP->G1_COD,nil									})
		AAdd( aCab, {'C2_QUANT'		    ,		 TMP->G1_QUANT,nil 									})
		AAdd( aCab, {'C2_LOCAL'		    ,		 '01'	,nil										})
		AAdd( aCab, {'C2_CC'			,		 '324',nil 											})
		AAdd( aCab, {'C2_DATPRI'	    ,		 dDataBase ,nil										})
		AAdd( aCab, {'C2_DATPRF'		,		 dDataBase + 10,nil									})
		AAdd( aCab, {'C2_OPMIDO'	    ,		 cITPlano,nil										})
		AAdd( aCab, {'C2_EMISSAO'	    ,	     dDataBase,	nil										})
		AAdd( aCab, {'C2_QTDLOTE'	    ,	     TMP->G1_QUANT,	nil									})
		AAdd( aCab, {'C2_OBS'           ,        'ROTINA AUTOMATICA',nil                            })
		AAdd( aCab, {'C2_OPRETRA'       ,        'N',nil				                            })
		AAdd( aCab, {"AUTEXPLODE"       ,        'S',NIL 										    })

		lMsErroAuto := .f.
		msExecAuto({|x,Y| Mata650(x,Y)},aCab,3)
		//
		If lMsErroAuto
			// Alert( 'Erro no apontamento da Ordem de Produção ' + aPrdsFc[nn1,2])
			If lMsErroAuto
				MostraErro()
			EndIf
		Endif
//			lRet := .F.
//			Exit
		EndiF
		
	dbSkip()
EndDo                                      

dbSelectArea("TMP")
dbGotop()
while !TMP->(eof())
	RecLock("TMP",.F.)
	TMP->G1_QUANT := 0
	MsUnlock("TMP")
	TMP->(dbSkip())
enddo
dbGotop()
	
	APMsgInfo("Rotina finalizada com sucesso..."+Chr(13)+"Foram Gerados "+cValToChar(nCount)+" Planos ")
//	oGet1:SetFocus()
	oDlg:End()
return
