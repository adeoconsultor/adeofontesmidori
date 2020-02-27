#Include "Protheus.ch"
#Include "Topconn.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMR001  ºAutor  ³Antonio             º Data ³  16/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de relatorio da Ordem de Separação                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Midori                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MD_RELOSC(cNumOS)

Local oPerg,nI
Local c_X_OrdSep
Local cZUASD4  := GetNextAlias()
Local aDadosOS := {}

Private cPerg  := "RELOSC01"

Default cNumOS:=''
//ValidPerg()
//Pergunte("RCOMR001",.T.)

If Empty(cNumOS)
	oPerg := AdvplPerg():New( cPerg )
	
	//-------------------------------------------------------------------
	//    AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
	// Parametriza as perguntas
	//-------------------------------------------------------------------
	oPerg:AddPerg( "Plano Inicial......: " ,"C",TamSx3("ZP_OPMIDO")[1]  , ,         , "SZP")
	oPerg:AddPerg( "Plano Final........: " ,"C",TamSx3("ZP_OPMIDO")[1]  , ,         , "SZP")
	oPerg:AddPerg( "Cod. Ord. Separação: " ,"C",TamSx3("D4_X_ORSEP")[1] , ,         , "SD4")
	oPerg:AddPerg( "Reimprimir (S/N)?  : " ,   ,                        , ,{"S","N"},)
	oPerg:SetPerg()

	If ! Pergunte( cPerg, .T. )
		Return( nil )
	EndIf

	If Empty(MV_PAR01) .And. Empty(MV_PAR02)
		If EMpty(MV_PAR03)
			HS_MsgInf("Informe o numero da OS, pois vc não informou o nr do plano! ","Atenção!!!","Impressão da Ordem de Separação")
			Return( nil )
		EndIf 
	EndIf

EndIf

//Verifica se tabelas temporias existem e encerra as mesmas antes de executar as novas
If Select(cZUASD4) > 0 
	dbSelectArea(cZUASD4)
	(cZUASD4)->(dbCloseArea())
endif

If Empty(MV_PAR03)
	cSql := " SELECT '', "
//	cSql += "        SC2.C2_OPMIDO  D4PLANO   , "
	cSql += "        SD4.D4_COD     D4PRODUTO , "
	cSql += "        SB1.B1_DESC    D4XDESC   , "
	cSql += "        SD4.D4_DATA    D4DATA    , "
	cSql += "        SD4.D4_LOCAL   D4LOCAL   , "
	cSql += "        SD4.D4_X_LOTE  D4LOTE    , "
	cSql += "        SD4.D4_X_DTVLL D4VALID   , "
	cSql += "        SD4.D4_X_ORSEP D4ORSEP   , "
	cSql += "        SUM(SD4.D4_QTDEORI) D4QUANT  "
	cSql += "  FROM " + RetSqlName("SC2") + " SC2 "
	cSql += " JOIN " + RetSqlName("SD4") + " SD4 ON "
	cSql += " 			SUBSTRING(SD4.D4_OP,1,6) =  SC2.C2_NUM AND " 
	cSql += " 			SD4.D_E_L_E_T_           <> '*' AND "
	cSql += "   		SD4.D4_FILIAL            =  '" + xFilial("SD4") + "' "
	cSql += " JOIN " + RetSqlName("SB1") + " SB1 ON  "
	cSql += " 			SB1.B1_COD     =  SD4.D4_COD AND " 
	cSql += " 			SB1.D_E_L_E_T_ <> '*' AND "
	cSql += "   		SB1.B1_FILIAL  =  '" + xFilial("SB1") + "' AND "
	cSql += "   		SB1.B1_RASTRO  =  'L' "
	cSql += " JOIN " + RetSqlName("SBZ") + " SBZ ON  "
	cSql += " 			SBZ.BZ_COD     =  SB1.B1_COD AND " 
	cSql += " 			SBZ.D_E_L_E_T_ <> '*' AND "
	cSql += "   		SBZ.BZ_FILIAL  =  '" + xFilial("SBZ") + "' AND "
	cSql += "   		SBZ.BZ_ORDSEP  =  'S' "
	cSql += "   WHERE SC2.C2_FILIAL    =  '" + xFilial("SC2") + "' "
	cSql += "     AND SC2.D_E_L_E_T_   =  ' ' "
	If !Empty(MV_PAR01) .and. !Empty(MV_PAR02)
		cSql += "     AND SC2.C2_OPMIDO BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"'"
	Else
		If !Empty(MV_PAR03)
			cSql += "     AND SD4.D4_X_ORSEP = '"+ MV_PAR03 +"' "
		Else
			cSql += "     AND SD4.D4_X_ORSEP <> ' ' "
		EndIf
	EndIf
	
	If MV_PAR04 <> 1  // REIMPRESSAO = 'N'
		cSql += "     AND SD4.D4_QUANT    = SD4.D4_QTDEORI "
    EndIf

	cSql += "     AND SUBSTRING(SD4.D4_COD,1,3) <> 'MOD' "
	cSql += "     AND SUBSTRING(D4_DATA,1,4) = '"+ ALLTRIM(STR(YEAR(DDATABASE))) +"' "
	cSql += "   GROUP BY  "
//	cSql += "        SC2.C2_OPMIDO  , "
	cSql += "        SD4.D4_COD     , "
	cSql += "        SB1.B1_DESC    , "
	cSql += "        SD4.D4_DATA    , "
	cSql += "        SD4.D4_LOCAL   , "
	cSql += "        SD4.D4_X_LOTE  , "
	cSql += "        SD4.D4_X_DTVLL , "
	cSql += "        SD4.D4_X_ORSEP   "
	cSql += "   ORDER BY SD4.D4_X_ORSEP"
	dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql),cZUASD4,.F.,.T.)


	c_X_OrdSep := " "

	While (cZUASD4)->(!Eof())

		If c_X_OrdSep <> (cZUASD4)->D4ORSEP
			aAdd(aDadosOS,{ (cZUASD4)->D4ORSEP }   )
			c_X_OrdSep := (cZUASD4)->D4ORSEP
		EndIf

		(cZUASD4)->(dbSkip())

	EndDo

	For nI := 1 to Len(aDadosOS)                                //  Plano Ini/Plano Fin/Ord Separação
		MsgRun("Imprimindo a Ordem de Separação !!!!",,{|| fProcessa(MV_PAR01,MV_PAR02,aDadosOS[nI,1]) })
	Next

Else

	MsgRun("Imprimindo a Ordem de Separação !!!!",,{|| fProcessa(MV_PAR01,MV_PAR02,MV_PAR03) })

EndIf



Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fProcessa ºAutor  ³Antonio             º Data ³  16/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para processamento do relatorio.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MIDORI                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fProcessa(cParMV01,cParMV02,cParMV03)

Local cBitMap 	:= 'oximaq.BMP'
Local aDadosEmp  

Private oPrint
Private aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
Private cZUAliaSD4 := GetNextAlias()

//
// Atualiza matriz com Dados da empresa.
//
aDadosEmp := {SM0->M0_NOMECOM															,; //Nome da Empresa
              SM0->M0_ENDCOB															,; //Endereço
              AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB	,; //Complemento
              "CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)				,; //CEP
              "PABX/FAX: "+SM0->M0_TEL													,; //Telefones
              "C.G.C.: "+SM0->M0_CGC													,; //CGC
              "I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ;
              Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //I.E

oPrint:= TMSPrinter():New( "Ordem de Separação de Materiais" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página


ProcREgua( Reccount() )

//Verifica se tabelas temporias existem e encerra as mesmas antes de executar as novas
If Select(cZUAliaSD4) > 0 
	dbSelectArea(cZUAliaSD4)
	(cZUAliaSD4)->(dbCloseArea())
endif

cSql := " SELECT '', "
//cSql += "        SC2.C2_OPMIDO  D4PLANO   , "
cSql += "        SD4.D4_COD     D4PRODUTO , "
cSql += "        SB1.B1_DESC    D4XDESC   , "
cSql += "        SD4.D4_DATA    D4DATA    , "
cSql += "        SD4.D4_LOCAL   D4LOCAL   , "
cSql += "        SD4.D4_X_LOTE  D4LOTE    , "
cSql += "        SD4.D4_X_DTVLL D4VALID   , "
cSql += "        SD4.D4_X_ORSEP D4ORSEP   , "
cSql += "        SUM(SD4.D4_QTDEORI) D4QUANT  "
cSql += "  FROM " + RetSqlName("SC2") + " SC2 "
cSql += " JOIN " + RetSqlName("SD4") + " SD4 ON "
cSql += " 			SUBSTRING(SD4.D4_OP,1,6) =  SC2.C2_NUM AND " 
cSql += " 			SD4.D_E_L_E_T_           <> '*' AND "
cSql += "   		SD4.D4_FILIAL            =  '" + xFilial("SD4") + "' "
cSql += " JOIN " + RetSqlName("SB1") + " SB1 ON  "
cSql += " 			SB1.B1_COD     =  SD4.D4_COD AND " 
cSql += " 			SB1.D_E_L_E_T_ <> '*' AND "
cSql += "   		SB1.B1_FILIAL  =  '" + xFilial("SB1") + "' AND "
cSql += "   		SB1.B1_RASTRO  =  'L' "
cSql += " JOIN " + RetSqlName("SBZ") + " SBZ ON  "
cSql += " 			SBZ.BZ_COD     =  SB1.B1_COD AND " 
cSql += " 			SBZ.D_E_L_E_T_ <> '*' AND "
cSql += "   		SBZ.BZ_FILIAL  =  '" + xFilial("SBZ") + "' AND "
cSql += "   		SBZ.BZ_ORDSEP  =  'S' "
cSql += "   WHERE SC2.C2_FILIAL    =  '" + xFilial("SC2") + "' "
cSql += "     AND SC2.D_E_L_E_T_   =  ' ' "
If !Empty(MV_PAR01) .and. !Empty(MV_PAR02)
	cSql += "     AND SC2.C2_OPMIDO BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"'"
Else
	If !Empty(cParMV03)
		cSql += "     AND SD4.D4_X_ORSEP = '"+ cParMV03 +"' "
	Else
		cSql += "     AND SD4.D4_X_ORSEP <> ' ' "
	EndIf
EndIf

If MV_PAR04 <> 1 // REIMPRESSAO = 'N'
	cSql += "     AND SD4.D4_QUANT    = SD4.D4_QTDEORI "
EndIf

cSql += "     AND SUBSTRING(SD4.D4_COD,1,3) <> 'MOD' "
cSql += "     AND YEAR(SD4.D4_DATA ) = '"+ STR((YEAR(DDATABASE))) +"'"
cSql += "   GROUP BY  "
//cSql += "        SC2.C2_OPMIDO  , "
cSql += "        SD4.D4_COD     , "
cSql += "        SB1.B1_DESC    , "
cSql += "        SD4.D4_DATA    , "
cSql += "        SD4.D4_LOCAL   , "
cSql += "        SD4.D4_X_LOTE  , "
cSql += "        SD4.D4_X_DTVLL , "
cSql += "        SD4.D4_X_ORSEP   "
//cSql += "     ORDER BY  "
dbUseArea(.T.,"TOPCONN", TcGenQry(,,cSql),cZUAliaSD4,.F.,.T.)

//TcSetField(cZUAliaSD4, "D4_DTVALID", "D")
//TcSetField(cZUAliaSD4, "D4_DATA", "D")

// funcao de impressao dos dados.
fImpress(oPrint,cBitmap,aDadosEmp,cParMV03) 

oPrint:Preview()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMR001  ºAutor  ³Antonio             º Data ³  16/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fImpress(oPrint,cBitmap,aDadosEmp,cParMV03)

Local oFont8
Local oFont10
Local oFont16
Local oFont16n
Local oFont20
Local oFont24
Local oBrush
Local cFileLogo := "lgrl01_1.BMP"
Local nLinIni   := 0

//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8n := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9n := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10n:= TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11 := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11n:= TFont():New("Arial",10,11,.T.,.F.,5,.T.,5,.T.,.F.)
oFont12 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13n:= TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
oFont12n:= TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14	:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15n:= TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont19n:= TFont():New("Arial",9,19,.T.,.F.,5,.T.,5,.T.,.F.)
oFont20 := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20n:= TFont():New("Arial",9,20,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oBrush := TBrush():New(,CLR_BLUE,,)

//oPrint:SetPortrait()

oPrint:StartPage()   // Inicia uma nova página

nLinIni := 0100
nColIni := 0100
nLin := nLinIni+12


//-- Carrega Logotipo para impressao 
//fLogoEmp(@cFileLogo)

If File(cFilelogo)
	//oPrint:SayBitmap(0100,0100,cFileLogo,500,300)
	oPrint:SayBitmap(0150,0150,cFileLogo,500,300)
Endif    

// CABEÇALHO                     
oPrint:Say(nLin,1200,aDadosEmp[1] ,oFont10n)
nLin+=45
//oPrint:Say(nLin,1200,aDadosEmp[2] ,oFont10n)
oPrint:Say(nLin,1200, ( AllTrim(aDadosEmp[2]) + " - " + AllTrim(SM0->M0_BAIRCOB) ) ,oFont10n)
nLin+=45
//oPrint:Say(nLin,1200,AllTrim(SM0->M0_BAIRCOB) ,oFont10n)
//oPrint:Say(nLin,1800,"TEL: "+SM0->M0_TEL ,oFont10n)
oPrint:Say(nLin,1200,"TEL: "+SM0->M0_TEL ,oFont10n)
nLin+=45
oPrint:Say(nLin,1200,aDadosEmp[4] + " - " + AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,oFont10n)
nLin+=45
oPrint:Say(nLin,1200,aDadosEmp[6] ,oFont10n)
nLin+=45
oPrint:Say(nLin,1200,aDadosEmp[7] ,oFont10n)

nLin+=180

//oPrint:Say(nLin-70,1900, "Num. O.S.: " + (cZUAliaSD4)->D4ORSEP ,oFont10n) 
oPrint:Say(nLin-70,1900, "Num. O.S.: " + cParMV03 ,oFont10n) 

oPrint:Line (nLin-20,nColIni,nLin-20,2300)
oPrint:Say(nLin,0900,"ORDEM DE SEPARAÇÃO" ,oFont19n) 

//	oPrint:Say(nLin,1610,"Codigo Barras:  ",oFontAr12n)
MSBAR("CODE128",  5.85 ,  15.8 ,cParMV03,oPrint,.F.,,.T.,0.022,0.8,.F.,NIL, "AAA", .F.)


nLin+=80
oPrint:Line (nLin,nColIni,nLin,2300)


If !Empty(MV_PAR01) .and. !Empty(MV_PAR02)
	If MV_PAR01 == MV_PAR02
		oPrint:Say(nLin+50,nColIni,"Plano(s) Nr(s).: " +  MV_PAR01 ,oFont12n)
	Else
		oPrint:Say(nLin+50,nColIni,"Plano(s) Nr(s).: De: " +  MV_PAR01 + " a   " + MV_PAR02 ,oFont12n)
	EndIf
Else
	oPrint:Say(nLin+50,nColIni,"Plano(s) Nr(s).: " +  MV_PAR01 ,oFont12n)
EndIf

nLin+=70
              
oPrint:Say(nLin+50,nColIni, "Armazem.: " + (cZUAliaSD4)->D4LOCAL ,oFont12n)
nLin+=70
  
oPrint:Say(nLin+50,nColIni,"Data da Emissão : " + DtoC(StoD((cZUAliaSD4)->D4DATA)) ,oFont12n)

nLin+=180
oPrint:Line (nLin,nColIni,nLin,2300)
oPrint:Say(nLin+10,0300,"Produto"  ,oFont10)
//oPrint:Say(nLin+10,1350,"Etiqueta" ,oFont10)
oPrint:Say(nLin+10,1600,"Qtde"     ,oFont10)
oPrint:Say(nLin+10,1800,"Lote"     ,oFont10)
//oPrint:Say(nLin+10,2050,"Validade Lote" ,oFont10)
oPrint:Say(nLin+10,2050,"Data Entrada" ,oFont10)
          
nLin+=80
oPrint:Line (nLin,nColIni,nLin-080,nColIni)   //lado esquerdo produto
oPrint:Line (nLin,2300   ,nLin-080,2300)      //lado direito da validade
oPrint:Line (nLin,nColIni,nLin,2300)

oPrint:Line (nLin,1550,nLin+2120,1550 )       // coluna vertical antes da qtde
oPrint:Line (nLin,1750,nLin+2120,1750 )       // coluna vertical antes do lote
oPrint:Line (nLin,2000,nLin+2120,2000 )       // coluna vertical antes da validade
 
nLin+=620 
oPrint:Line (nLin-620,nColIni,nLin+1500,nColIni)  //coluna vertical esquerda
oPrint:Line (nLin-620,2300   ,nLin+1500,2300)     //coluna vertical direita
oPrint:Line (nLin+1500,nColIni,nLin+1500,2300)

nLin+=370                                         
//oPrint:Say(nLin,0200,"-----------------------------------------------------" ,oFont12n)
//oPrint:Line (nLin,0200,nLin,0800)
//oPrint:Say(nLin,1550,"-----------------------------------------------------" ,oFont12n)
//oPrint:Line (nLin,1550,nLin,2150)
nLin+=40

nLin-= 1030 //960  // 40 + 580 + 370 + 40
          
Do While (cZUAliaSD4)->(!Eof()) 
                                          
	If nLin > 2600
		oPrint:EndPage() // Finaliza a página
		oPrint:StartPage()   // Inicia uma nova página
		nLinIni := 0100
		nColIni := 0100
		nLin := nLinIni+12
	EndIf

    oPrint:Say  (nLin+20,0110, Alltrim((cZUAliaSD4)->D4PRODUTO) + " " + SubStr(AllTrim((cZUAliaSD4)->D4XDESC),1,30) ,oFont11)   
//    oPrint:Say  (nLin+20,1350, (cUAliaCB0)->ETIQTA  ,oFont11)   
    oPrint:Say  (nLin+20,1550, Transform( (cZUAliaSD4)->D4QUANT, "@E 9,999.9999")   ,oFont11)   
    oPrint:Say  (nLin+20,1800, (cZUAliaSD4)->D4LOTE    ,oFont11)   
//    oPrint:Say  (nLin+20,2050, Dtoc(StoD((cZUAliaSD4)->D4VALID ))  ,oFont11)   
//    oPrint:Say  (nLin+20,2050, Dtoc(StoD((cZUAliaSD4)->D4DATA ))  ,oFont11)    

	SB8->(dbSetOrder(3))
//	If SB8->(dbSeek(xFilial("SB8")+(cZUAliaSD4)->D4PRODUTO+(cZUAliaSD4)->D4LOCAL+(cZUAliaSD4)->D4LOTE ) )
	If SB8->(dbSeek(xFilial("SB8")+(cZUAliaSD4)->D4PRODUTO+'01'+(cZUAliaSD4)->D4LOTE ) )
	    oPrint:Say  (nLin+20,2050, DtoC(SB8->B8_DATA)  ,oFont11)
	EndIf
    nLin+=40

	(cZUAliaSD4)->(DbSkip())
EndDo

oPrint:EndPage() // Finaliza a página
//oPrint:Preview()

Return Nil

/*
SELECT  SUM(B9_VINI1) AS Custo_Total 
FROM SB9010
WHERE B9_DATA = '20180531' 
AND B9_FILIAL IN('08','19')
AND B9_LOCAL IN('DE','DS','CL')    
*/