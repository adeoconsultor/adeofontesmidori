
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RH_CONTAB³ Autor ³ PrimaInfo             ³ Data ³ 12.11.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para busca de Contas Contabeis a partir do cadastro ³±±
±±³          ³ de Verbas.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Midori                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/***********
* Debito  *
***********/
User Function deb_rh_contabil()
local cConta := space(10)
local cGrupo := space(4)

//IF !(SRZ->RZ_MAT $ "zzz") 
//	if UPPER(SRZ->RZ_MAT) <> "ZZZZZZ"
		cConta := space(10)
		
		If !ALLTRIM(SRZ->RZ_ITEM) $ "01-18" .And. SUBS(SRZ->RZ_CC,1,1) $ "1-4-5"
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		ElseIf ALLTRIM(SRZ->RZ_ITEM) $ "01-18" .And. SUBS(SRZ->RZ_CC,1,1) == "3"
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		Else
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		EndIf
		
		If cGrupo == "1" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'			//NAO CONTABILIZA AUTONOMO NESTA CONTA
//			if SRZ->RZ_VAL < 0 
//				cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD")
//			else
  			    cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB")			
//			endif
			if trim(cConta) = ""
				msgalert("Conta nao encontrada para a Verba Geral- " + SRZ->RZ_PD+chr(13)+"MATRICULA "+SRZ->RZ_MAT+" C.CUSTO "+SRZ->RZ_CC+chr(13)+"GRUPO "+cGrupo+" TP.SALDO "+SRZ->RZ_TPC+ " RV_CTADEB")
			endif
		ElseIf cGrupo == "2" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB1")
			if trim(cConta) = ""
				msgalert("Conta nao encontrada para a Verba Geral- " + SRZ->RZ_PD+chr(13)+"MATRICULA "+SRZ->RZ_MAT+" C.CUSTO "+SRZ->RZ_CC+chr(13)+"GRUPO "+cGrupo+" TP.SALDO "+SRZ->RZ_TPC+"RV_CTADEB1")
			endif
		ElseIf cGrupo == "3" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB2")
			if trim(cConta) = ""
				msgalert("Conta nao encontrada para a Verba Geral- " + SRZ->RZ_PD+chr(13)+"MATRICULA "+SRZ->RZ_MAT+" C.CUSTO "+SRZ->RZ_CC+chr(13)+"GRUPO "+cGrupo+" TP.SALDO "+SRZ->RZ_TPC+"RV_CTADEB2")
			endif
		ElseIf cGrupo == "1" .and. Substr(SRZ->RZ_MAT,1,2) == '99'		//TRATA AUTONOMO
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB5",1)
			if trim(cConta) = ""
				msgalert("Conta nao encontrada para a Verba Geral- " + SRZ->RZ_PD+chr(13)+"MATRICULA "+SRZ->RZ_MAT+" C.CUSTO "+SRZ->RZ_CC+chr(13)+"GRUPO "+cGrupo+" TP.SALDO "+SRZ->RZ_TPC+"RV_CTADEB5")
			endif
		ElseIf cGrupo == "2" .and. Substr(SRZ->RZ_MAT,1,2) == '99'		//TRATA AUTONOMO
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB3",1)
			if trim(cConta) = ""
				msgalert("Conta nao encontrada para a Verba Geral- " + SRZ->RZ_PD+chr(13)+"MATRICULA "+SRZ->RZ_MAT+" C.CUSTO "+SRZ->RZ_CC+chr(13)+"GRUPO "+cGrupo+" TP.SALDO "+SRZ->RZ_TPC+"RV_CTADEB3")
			endif
		ElseIf cGrupo == "3" .and. Substr(SRZ->RZ_MAT,1,2) == '99'		//TRATA AUTONOMO
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB4",1)
			if trim(cConta) = ""
				msgalert("Conta nao encontrada para a Verba Geral- " + SRZ->RZ_PD+chr(13)+"MATRICULA "+SRZ->RZ_MAT+" C.CUSTO "+SRZ->RZ_CC+chr(13)+"GRUPO "+cGrupo+" TP.SALDO "+SRZ->RZ_TPC+"RV_CTADEB4")
			endif
		EndIf
//	endif
//Endif
	
return(cConta)


/***********
* Credito *
***********/
User Function cre_rh_contabil()
local cConta := space(10)
local cGrupo := space(4)

//IF !(SRZ->RZ_MAT $ "zzz") 
//	if UPPER(SRZ->RZ_MAT) <> "ZZZZZZ"
		cConta := space(10)
		
		if !ALLTRIM(SRZ->RZ_ITEM) $ "01-18" .And. SUBS(SRZ->RZ_CC,1,1) $ "1-4-5"
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		ElseIf ALLTRIM(SRZ->RZ_ITEM) $ "01-18" .And. SUBS(SRZ->RZ_CC,1,1) == "3"
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		Else
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		EndIf

		
		If cGrupo == "1" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'				//NAO CONTABILIZA AUTONOMO NESTA CONTA
//			if SRZ->RZ_VAL < 0 
//				cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB")
//			else
				cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD")
//			endif
			if trim(cConta) = ""
				msgalert("Conta nao encontrada para a Verba Geral- " + SRZ->RZ_PD+ " F"+SRZ->RZ_FILIAL+" MAT:"+SRZ->RZ_MAT+" Grup:"+cGrupo+" RV_CTACRD")
			endif
		ElseIf cGrupo == "2" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD1")
			if trim(cConta) = ""
				msgalert("Conta nao encontrada para a Verba Geral- " + SRZ->RZ_PD+ " F"+SRZ->RZ_FILIAL+" MAT:"+SRZ->RZ_MAT+" Grup:"+cGrupo+" RV_CTACRD1")
			endif
		ElseIf cGrupo == "3" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD2")
			if trim(cConta) = ""
				msgalert("Conta nao encontrada para a Verba Geral- " + SRZ->RZ_PD+ " F"+SRZ->RZ_FILIAL+" MAT:"+SRZ->RZ_MAT+" Grup:"+cGrupo+" RV_CTACRD2")
			endif
		ElseIf cGrupo == "1" .and. Substr(SRZ->RZ_MAT,1,2) == '99'		//TRATA AUTONOMO
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD5")
			if trim(cConta) = ""
				msgalert("Conta nao encontrada para a Verba Geral- " + SRZ->RZ_PD+ " F"+SRZ->RZ_FILIAL+" MAT:"+SRZ->RZ_MAT+" Grup:"+cGrupo+" RV_CTACRD5")
			endif
		ElseIf cGrupo == "2" .and. Substr(SRZ->RZ_MAT,1,2) == '99'		//TRATA AUTONOMO
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD3")
			if trim(cConta) = ""
				msgalert("Conta nao encontrada para a Verba Geral- " + SRZ->RZ_PD+ " F"+SRZ->RZ_FILIAL+" MAT:"+SRZ->RZ_MAT+" Grup:"+cGrupo+" RV_CTACRD3")
			endif
		ElseIf cGrupo == "3" .and. Substr(SRZ->RZ_MAT,1,2) == '99'		//TRATA AUTONOMO
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD4")
			if trim(cConta) = ""
				msgalert("Conta nao encontrada para a Verba Geral- " + SRZ->RZ_PD+ " F"+SRZ->RZ_FILIAL+" MAT:"+SRZ->RZ_MAT+" Grup:"+cGrupo+" RV_CTACRD4")
			endif
		EndIf
//	endif
//ENDIF
return(cConta)



/***************************
* Centro de Custo Debito  *
***************************/
User Function cc_deb_rh_contabil()
local cCc 		:= space(9)
local cRecebcc 	:= space(1)
local cConta 	:= space(10)
//IF !(SRZ->RZ_MAT $ "zzz") 
//	if UPPER(SRZ->RZ_MAT) <> "ZZZZZZ"
		cCc 	:= ""
		cRecebCc:= ""
		cConta  := space(10)
		
		If !ALLTRIM(SRZ->RZ_ITEM) $ "01-18" .And. SUBS(SRZ->RZ_CC,1,1) $ "1-4-5"
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		ElseIf ALLTRIM(SRZ->RZ_ITEM) $ "01-18" .And. SUBS(SRZ->RZ_CC,1,1) == "3"
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		Else
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		EndIf
		
		If cGrupo == "1" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'
//			if SRZ->RZ_VAL < 0 
//				cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD")			
//			else
				cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB")				
//			endif		
			if trim(cConta) = ""
				msgalert("Conta nao encontrada para a Verba Geral- " + SRZ->RZ_PD+ " F"+SRZ->RZ_FILIAL+" MAT:"+SRZ->RZ_MAT+" Grup:"+cGrupo+" RV_CTACRD")
			endif
		ElseIf cGrupo == "2" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB1")
		ElseIf cGrupo == "3" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB2")
		ElseIf cGrupo == "1" .and. Substr(SRZ->RZ_MAT,1,2) == '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB5")
		ElseIf cGrupo == "2" .and. Substr(SRZ->RZ_MAT,1,2) == '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB3")
		ElseIf cGrupo == "3".and. Substr(SRZ->RZ_MAT,1,2) == '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB4")
		EndIf
		
		cRecebCC := fdesc("CT1",cConta,"CT1_ACCUST")
		
		IF cRecebCC = "1"
			If !ALLTRIM(SRZ->RZ_ITEM) $ "01-18" .And. SUBS(SRZ->RZ_CC,1,1) $ "1-4-5"
				cCC := SRZ->RZ_CC
			ElseIf ALLTRIM(SRZ->RZ_ITEM) $ "01-18" .And. SUBS(SRZ->RZ_CC,1,1) ==  "3"
				cCC := SRZ->RZ_CC
			Else
				cCC:= SRZ->RZ_CC
			EndIf
		Endif
//	endif
//ENDIF

return(cCC)


/*****************************
* * Centro de Custo Credito *
*****************************/
User Function cc_cre_rh_contabil()
local cCc 		:= space(9)
local cRecebcc 	:= space(1)
local cConta 	:= space(10)
//IF !(SRZ->RZ_MAT $ "zzz") 
//	if UPPER(SRZ->RZ_MAT) <> "ZZZZZZ"
		cCc 	:= ""
		cRecebCc:= ""
		cConta  := space(10)
		
		If !ALLTRIM(SRZ->RZ_ITEM) $ "01-18" .And. SUBS(SRZ->RZ_CC,1,1) $ "1-4-5"
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		ElseIf ALLTRIM(SRZ->RZ_ITEM) $ "01-18" .And. SUBS(SRZ->RZ_CC,1,1) == "3"
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		Else
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		EndIf
		
		If cGrupo == "1" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'
//			if SRZ->RZ_VAL < 0 
//				cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB")	
//			else
				cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD")
//			endif		
			if trim(cConta) = ""
				msgalert("Conta nao encontrada para a Verba Geral- " + SRZ->RZ_PD+ " F"+SRZ->RZ_FILIAL+" MAT:"+SRZ->RZ_MAT+" Grup:"+cGrupo+" RV_CTACRD")
			endif
		ElseIf cGrupo == "2" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD1")
		ElseIf cGrupo == "3" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD2")
		ElseIf cGrupo == "1" .and. Substr(SRZ->RZ_MAT,1,2) == '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD5")
		ElseIf cGrupo == "2" .and. Substr(SRZ->RZ_MAT,1,2) == '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD3")
		ElseIf cGrupo == "3" .and. Substr(SRZ->RZ_MAT,1,2) == '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD4")
		EndIf
		
		cRecebCC := fdesc("CT1",cConta,"CT1_ACCUST")
		
		IF cRecebCC = "1"
			If !ALLTRIM(SRZ->RZ_ITEM) $ "01-18" .And. SUBS(SRZ->RZ_CC,1,1) $ "1-4-5"
				cCC := SRZ->RZ_CC
			ElseIf ALLTRIM(SRZ->RZ_ITEM) $ "01-18" .And. SUBS(SRZ->RZ_CC,1,1) ==  "3"
				cCC := SRZ->RZ_CC
			Else
				cCC:= SRZ->RZ_CC
			EndIf
		Endif
//	ENDIF
//ENDIF

Return(cCC)


/***************************
* Item Contabil Debito       *
***************************/
User Function item_deb_rh_contabil()
local cItem		:= space(3)
local cRecItem 	:= space(1)
local cConta 	:= space(10)
local cmatri    := space(06)
//IF !(SRZ->RZ_MAT $ "zzz") 
//	IF UPPER(SRZ->RZ_MAT) <> "ZZZZZZ"
		cItem 	 := ""
		cRecItem := ""
		cConta   := space(10)
		cmatri := space(06)
		
		If !ALLTRIM(SRZ->RZ_ITEM) $ "01-18" .And. SUBS(SRZ->RZ_CC,1,1) $ "1-4-5"
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		ElseIf ALLTRIM(SRZ->RZ_ITEM) $ "01-18" .And. SUBS(SRZ->RZ_CC,1,1) == "3"
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		Else
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		EndIf
		
		If cGrupo == "1" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB")
		ElseIf cGrupo == "2" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB1")
		ElseIf cGrupo == "3" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB2")
		ElseIf cGrupo == "1" .and. Substr(SRZ->RZ_MAT,1,2) == '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB5")
		ElseIf cGrupo == "2" .and. Substr(SRZ->RZ_MAT,1,2) == '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB3")
		ElseIf cGrupo == "3" .and. Substr(SRZ->RZ_MAT,1,2) == '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTADEB4")
		EndIf
		
		//cRecItem := fdesc("CT1",cConta,"CT1_ACITEM")
		cRecItem := Posicione('CT1',1,xFilial('CT1')+cConta, "CT1_ACITEM")
		IF cRecItem = "1"		
			cItem := SRZ->RZ_ITEM			
			cmatri := SRZ->RZ_MAT			  	
			if Substr(cItem,1,1) == space(1)			
				cItem := Posicione('SRA',1,xFilial('SRA')+SRZ->RZ_MAT, "RA_ITEM")				
		    endif
			if Substr(cItem,1,1) == space(1)
				cItem := SRZ->RZ_FILIAL				
			endif			
		Endif
//	ENDIF
//ENDIF
return(cItem)


/*****************************
* * Item Contabil Credito      *
*****************************/
User Function item_cre_rh_contabil()
local cItem		:= space(3)
local cRecItem 	:= space(1)
local cConta 	:= space(10)
local cmatri    := space(06)
//IF !(SRZ->RZ_MAT $ "zzz") 
//	IF UPPER(SRZ->RZ_MAT) <> "ZZZZZZ"
		cItem 	 := ""		
		cRecItem := ""
		cConta   := space(10)
		
		If !ALLTRIM(SRZ->RZ_ITEM) $ "01-18" .And. SUBS(SRZ->RZ_CC,1,1) $ "1-4-5"
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		ElseIf ALLTRIM(SRZ->RZ_ITEM) $ "01-18" .And. SUBS(SRZ->RZ_CC,1,1) == "3"
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		Else
			cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_MTIPOC")
		EndIf
		
		If cGrupo == "1" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD")
		ElseIf cGrupo == "2" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD1")
		ElseIf cGrupo == "3" .and. Substr(SRZ->RZ_MAT,1,2) <> '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD2")
		ElseIf cGrupo == "1" .and. Substr(SRZ->RZ_MAT,1,2) == '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD5")
		ElseIf cGrupo == "2" .and. Substr(SRZ->RZ_MAT,1,2) == '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD3")
		ElseIf cGrupo == "3" .and. Substr(SRZ->RZ_MAT,1,2) == '99'
			cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,"RV_CTACRD4")
		EndIf
		
		//cRecItem := fdesc("CT1",cConta,"CT1_ACITEM")
		cRecItem := Posicione('CT1',1,xFilial('CT1')+cConta, "CT1_ACITEM")
		
		IF cRecItem = "1"
			cItem := SRZ->RZ_ITEM			
			if Substr(cItem,1,1) == space(1)			   			   
				cItem := Posicione('SRA',1,xFilial('SRA')+SRZ->RZ_MAT, "RA_ITEM")
			endif
			if Substr(cItem,1,1) == space(1)
				cItem := SRZ->RZ_FILIAL			 
			endif
		Endif
//	ENDIF
//ENDIF
Return(cItem)
    
//Funcao para chamar a funcao CC_RH_DEB_CONTABIL()
user function CC_DEB_CONTABIL()
local cItem := ""
	cItem := U_cc_deb_rh_contabil()
return(cItem)
