#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH" 
#INCLUDE "TBICONN.CH"
                               
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MDGFER01     บAutor  ณAntonio Damaceno    บData ณ 27/09/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio GFE                                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
    
User Function MDGFER01()

	Local lRet := .t.
	Local dDataI   := dDataBase //Ctod("09/08/2016")
	Local oDataI
	Local dDataF   := dDataBase //Ctod("09/08/2016")
	Local oDataF
	Local cFilialI := Space(02)
	Local oFilialI
	Local cFilialF := Space(02)
	Local oFilialF
	Local cCT_eI   := Space(09)
	Local oCT_eI
	Local cCT_eF   := Space(09)
	Local oCT_eF
	
	Local oNotaI
	Local cNotaI   := Space(09)
	Local oSerieI
	Local cSerieI  := Space(02)

	Local oNotaF
	Local cNotaF   := Space(09)
	Local oSerieF
	Local cSerieF  := Space(02)

	Local cCodTraI := Space(09)
	Local oCodTraI
	Local cCodTraF := Space(09)
	Local oCodTraF
 
	Private oDlg
	Private nOpc
	
	//Monta interface com o usuแrio
	DEFINE MSDIALOG oDlg TITLE "Movimento Frete p/Periodo" FROM C(164),C(182) TO C(525),C(459) PIXEL
	
	@ C(003),C(003) TO C(202),C(360) LABEL "Filtro Docto Frete - GFE" PIXEL OF oDlg

	@ C(013),C(028) Say "Data De: " Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(013),C(070) MsGet oDataI Var dDataI Size C(041),C(009) COLOR CLR_BLACK PIXEL OF oDlg

	@ C(023),C(028) Say "Data At้: " Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(023),C(070) MsGet oDataF Var dDataF Size C(041),C(009) COLOR CLR_BLACK PIXEL OF oDlg

	@ C(033),C(028) Say "Filial De: " Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(033),C(070) MsGet oFilialI Var cFilialI Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg  // F3 'SF2'

	@ C(043),C(028) Say "Filial At้: " Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(043),C(070) MsGet oFilialF Var cFilialF Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg

	@ C(053),C(028) Say "CT-e De: " Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(053),C(070) MsGet oCT_eI Var cCT_eI Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg  // F3 'SF2'

	@ C(063),C(028) Say "CT-e At้: " Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(063),C(070) MsGet oCT_eF Var cCT_eF Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg

	@ C(073),C(028) Say "Nota Fiscal De: " Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(073),C(070) MsGet oNotaI Var cNotaI Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg F3 'SF2'

	@ C(083),C(028) Say "S้rie De:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(083),C(070) MsGet oSerieI Var cSerieI Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg

	@ C(093),C(028) Say "Nota Fiscal At้: " Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(093),C(070) MsGet oNotaF Var cNotaF Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg F3 'SF2'

	@ C(103),C(028) Say "S้rie At้:" Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(103),C(070) MsGet oSerieF Var cSerieF Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg

	@ C(113),C(028) Say "Transportadora De: " Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(113),C(070) MsGet oCodTraI Var cCodTraI Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg  F3 'GU3'

	@ C(123),C(028) Say "Transportadora At้: " Size C(048),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(123),C(070) MsGet oCodTraF Var cCodTraF Size C(041),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg  F3 'GU3'
	
	DEFINE SBUTTON FROM C(148),C(046) TYPE 1 ENABLE OF oDlg ACTION {||nOpc := 1,oDlg:End()}
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpc == 1
		If Empty(dDataI) .And. Empty(dDataF)
			If MsgYesNo("Nใo foi informado o perํodo para gera็ใo do Movto de Frete, gerar mesmo assim?") 
				Processa( {||lRet := U_MDGFER02(dDataI, dDataF, cFilialI, cFilialF, cCT_eI, cCT_eF, cNotaI, cSerieI, cNotaF, cSerieF, cCodTraI, cCodTraF)}, "Aguarde..." )
			EndIf	
		Else
			Processa( {||lRet := U_MDGFER02(dDataI, dDataF, cFilialI, cFilialF, cCT_eI, cCT_eF, cNotaI, cSerieI, cNotaF, cSerieF, cCodTraI, cCodTraF)}, "Aguarde..." )
		EndIf
	EndIf
	
Return( lRet )


//*****************************************************************
//Chamada da Rotina para gerar os dados em planilha excel - Antonio
//*****************************************************************
User Function MDGFER02(dDataI, dDataF, cFilialI, cFilialF, cCT_eI, cCT_eF, cNotaI, cSerieI, cNotaF, cSerieF, cCodTraI, cCodTraF)

Local aDados    := {}           
Local cSql      := ""
Local cAliasGW3 := GetNextAlias()

Local dGData    := ""
Local cGFilial  := ""
Local cGCte     := ""
Local cGOrigem  := ""
Local cGOrigem1 := ""
Local cGDestino := ""
Local cGDestino1:= ""
Local cGTransp  := ""
Local cGTraCNPJ := ""
Local cGNF      := ""
Local nGVlMerc  := 0
Local nGVlFrete := 0
Local nGVlFreteP := 0
Local nGVlFreteV := 0
Local nGVlPedag := 0
Local nGVlIcms  := 0
Local nGVlTaxas := 0
Local nGVlTFret := 0
Local nGPlaca   := 0
Local cGObs     := ""
Local nGPFrete  := 0
Local cCTE      := ''
Local cGPlaca   := ""

//-----------------------------------------------
// Seleciona os registros
//-----------------------------------------------
//OBS: A query abaixo nใo possui xFilial() pelo fato de podermos informar nos parametros do relatorio filiais de/Ate

cSql := " SELECT DISTINCT GW3.GW3_DTEMIS AS GW3_DATA,    GW3.GW3_FILIAL  AS GW3_FILIAL,  "
cSql += "                 GW3.GW3_NRDF   AS GW3_CTE,     GU3X.GU3_NMFAN  AS GW3_REMETE, GU3.GU3_CDEMIT AS GU3_CODTRA,"
cSql += "                 GU7.GU7_NMCID  AS GW3_ORIGEM,  GU7.GU7_CDUF    AS GW3_UFO,     "
cSql += "                 GU3Y.GU3_NMFAN AS GW3_DESTI,   GU7X.GU7_NMCID  AS GW3_DESTINO, "
cSql += "                 GU7X.GU7_CDUF  AS GW3_UFD,     GU3.GU3_NMEMIT  AS GW3_TRANSP,  "
cSql += "                 GU3.GU3_IDFED  AS GW3_TRACNPJ, GW4.GW4_NRDC    AS GW3_NF,      "
cSql += "                 GW4.GW4_SERDC  AS GW3_SERIE,   GW3.GW3_VLCARG  AS GW3_VLMERC,  "
////////////////cSql += "                 GW3.GW3_VLDF-(GW3.GW3_PEDAG+GW3.GW3_VLIMP+GW3.GW3_TAXAS) AS GW3_VLFRETE,      "
//cSql += "                 (GW3.GW3_FRVAL+GW3.GW3_FRPESO) AS GW3_VLFRETE,      "
cSql += "                 GW3.GW3_FRPESO AS GW3_FRETEP,  GW3.GW3_FRVAL    AS GW3_FRETEV,      "
cSql += "                 GW3.GW3_PEDAG  AS GW3_VLPEDA,  GW3.GW3_VLIMP    AS GW3_VLIMP ,  "
//cSql += "                 (GW3.GW3_TAXAS-GW3.GW3_VLIMP) AS GW3_TAXAS,   GW3.GW3_VLDF        AS GW3_VLTFRE   "
cSql += "                 GW3.GW3_TAXAS AS GW3_TAXAS,   GW3.GW3_VLDF      AS GW3_VLTFRE,   "
cSql += "                 GWF.GWF_NRCALC AS GWF_NRCALC "
////////////////cSql += "               GWN.GWN_PLACAD AS GW3_PLACA    GW3.GW3_OBS         AS GW3_OBS      "
cSql += " FROM "+RetSqlName("GW3")+" GW3 "
cSql += " 	JOIN "+RetSqlName("GWF")+" GWF  ON GWF.GWF_NRDF    = GW3.GW3_NRDF   AND GWF.D_E_L_E_T_  <> '*' AND GWF.GWF_FILIAL  = GW3.GW3_FILIAL "
cSql += " 	JOIN "+RetSqlName("GU7")+" GU7  ON GU7.GU7_NRCID   = GWF.GWF_CIDORI AND GU7.D_E_L_E_T_  <> '*' "
cSql += " 	JOIN "+RetSqlName("GU7")+" GU7X ON GU7X.GU7_NRCID  = GWF.GWF_CIDDES AND GU7X.D_E_L_E_T_ <> '*' "
cSql += " 	JOIN "+RetSqlName("GW4")+" GW4  ON GW4.GW4_NRDF    = GW3.GW3_NRDF   AND GW4.D_E_L_E_T_  <> '*' AND GW4.GW4_FILIAL  = GW3.GW3_FILIAL "
cSql += " 	JOIN "+RetSqlName("GU3")+" GU3  ON GU3.GU3_CDEMIT  = GWF.GWF_TRANSP AND GU3.D_E_L_E_T_  <> '*' "
cSql += " 	JOIN "+RetSqlName("GU3")+" GU3X ON GU3X.GU3_CDEMIT = GW3.GW3_CDREM  AND GU3X.D_E_L_E_T_ <> '*' "
cSql += " 	JOIN "+RetSqlName("GU3")+" GU3Y ON GU3Y.GU3_CDEMIT = GW3.GW3_CDDEST AND GU3Y.D_E_L_E_T_ <> '*' "
////////////////cSql += " 	JOIN "+RetSqlName("GW1")+" GW1  ON GW1.GW1_NRROM  = GWF.GWF_NRROM  AND GW1.D_E_L_E_T_  <> '*' "
cSql += " WHERE "
If !Empty(dDataI) .And. !Empty(dDataF)
	cSql += "   GW3.GW3_DTEMIS BETWEEN '" + DtoS(dDataI) + "' AND '" + DtoS(dDataF) + "' AND "
EndIf
If !Empty(cFilialI) .And. !Empty(cFilialF)
	cSql += "   GW3.GW3_FILIAL BETWEEN '" + cFilialI + "' AND '" + cFilialF + "' AND "
EndIf
If !Empty(cCT_eI) .And. !Empty(cCT_eF)
	cSql += "   GW3.GW3_NRDF   BETWEEN '" + cCT_eI   + "' AND '" + cCT_eF   + "' AND "
EndIf
If !Empty(cNotaI) .And. !Empty(cNotaF)
	cSql += "   GW4.GW4_NRDC BETWEEN '" + cNotaI     + "' AND '" + cNotaF   + "' AND "
EndIf
If !Empty(cSerieI) .And. !Empty(cSerieF)
	cSql += "   GW4.GW4_SERDC BETWEEN '" + cSerieI   + "' AND '" + cSerieF  + "' AND "
EndIf
If !Empty(cCodTraI) .And. !Empty(cCodTraF)
	cSql += "   GU3.GU3_CDEMIT BETWEEN '" + cCodTraI + "' AND '" + cCodTraF + "' AND "
EndIf
cSql += "       GW3.D_E_L_E_T_ <> '*' "
If !Empty(cNotaI) .And. !Empty(cNotaF)
	cSql += "ORDER BY GW3.GW3_FILIAL, GW4.GW4_NRDC, GW4.GW4_SERDC, GW3.GW3_DTEMIS "             //ORDEM POR NOTA FISCAL
Else
	cSql += "ORDER BY GW3.GW3_FILIAL, GW3.GW3_NRDF, GW3.GW3_DTEMIS "                        //ORDEM POR FRETE 
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasGW3,.T.,.T.) 
dbSelectArea(cAliasGW3)

//'"+xFilial("")+"'
//cSql += " GW3_NRDF = '000044617' "
//cSql += " JOIN "+RetSqlName("GWN")+" GWN  ON GWN.GWN_NRROM  = GW1.GW1_NRROM  AND GWN.D_E_L_E_T_  <> '*' "

AAdd(aDaDOS, {"","","",SM0->M0_CODIGO + " " +SM0->M0_NOMECOM , "De: " + DtoC(dDataI) + " A " + DtoC(dDataF),"","","","","","","","","","","","","","" })
If Empty(cNotaI) .And. Empty(cNotaF)
	AAdd(aDaDOS, {"","","","Relatorio GFE por Periodo - Ordem Por Docto Frete"  ,""                         ,"","","","","","","","","","","","","","" })
Else
	AAdd(aDaDOS, {"","","","Relatorio GFE por Periodo - Ordem Por NF"           ,""                         ,"","","","","","","","","","","","","","" })
EndIf
AAdd(aDaDOS, {"","","","","","","","","","","","","","","","","","","" })
AAdd(aDaDOS, {'Data', 'Filial', 'CT-e', 'Origem' ,"" ,'Destino', '',' Transportadora', "CNPJ", 'Nota(s) Fisca(l)(is)', 'Valor Mercadoria(s)' , 'Valor Icms', 'Frete Peso',  'Frete Valor', 'Valor Pedagio',;
'Taxas', 'Valor Total Frete', 'Placa Veiculo', '% Frete S/Vl Mercadoria(s)' })
AAdd(aDaDOS, {"","","","","","","","","","","","","","","","","","","" })

cCTE:=(cAliasGW3)->GW3_CTE

While (cAliasGW3)->(!Eof())

	If cCte <> (cAliasGW3)->GW3_CTE
	 
	   	AAdd(aDaDOS, { dGData                              ;                        //01
	   	              ,cGFilial                            ;                        //02
	   	              ,cGCte                               ;                        //03
	   	              ,cGOrigem                            ;                        //04
	   	              ,cGOrigem1                           ;                        //05
	   	              ,cGDestino                           ;                        //06
	   	              ,cGDestino1                          ;                        //07
	   	              ,cGTransp                            ;                        //08
	   	              ,Transform(cGTraCNPJ,"@R 99.999.999/9999-99") ;               //09
	   	              ,cGNF                                ;                        //10
	   	              ,nGVlMerc                            ;                        //11
	   	              ,nGVlIcms                            ;                        //12
	   	              ,nGVlFreteP                          ;                        //13
	   	              ,nGVlFreteV                          ;                        //14
	   	              ,nGVlPedag                           ;                        //15
	   	              ,nGVlTaxas                           ;                        //16
	   	              ,nGVlTFret                           ;                        //17
	   	              ,cGPlaca                             ;      //,cGObs ;        //18
	   	              ,Transform(nGPFrete,"@E 999.99")     ;                        //19
	   	              })
		cCte := (cAliasGW3)->GW3_CTE
		cGNF := ""
	EndIf

	dGData    := StoD((cAliasGW3)->GW3_DATA)                                        //01
	cGFilial  := (cAliasGW3)->GW3_FILIAL                                            //02
	cGCte     := (cAliasGW3)->GW3_CTE                                               //03
	cGOrigem  := Alltrim((cAliasGW3)->GW3_REMETE)                                   //04
	cGOrigem1 := Alltrim((cAliasGW3)->GW3_ORIGEM)+" - "+(cAliasGW3)->GW3_UFO        //05
	cGDestino := Alltrim((cAliasGW3)->GW3_DESTI)                                    //06
	cGDestino1:= Alltrim((cAliasGW3)->GW3_DESTINO)+" - "+(cAliasGW3)->GW3_UFD       //07
	cGTransp  := Alltrim((cAliasGW3)->GU3_CODTRA) + " - " +(cAliasGW3)->GW3_TRANSP  //08
	cGTraCNPJ := (cAliasGW3)->GW3_TRACNPJ                                           //09
	If Empty(cGNF)
		cGNF += Alltrim((cAliasGW3)->GW3_NF)+"-"+(cAliasGW3)->GW3_SERIE             //10
   	Else
		cGNF += " / "+Alltrim((cAliasGW3)->GW3_NF)+"-"+(cAliasGW3)->GW3_SERIE       //10
   	EndIf
    	
	nGVlMerc  := (cAliasGW3)->GW3_VLMERC                                            //11

//	nGVlFrete := (cAliasGW3)->GW3_VLFRETE                                          
	cGPlaca   := ""  //(cAliasGW3)->GW3_PLACA                                       //18
	cGObs     := "" // (cAliasGW3)->GW3_OBS                                         //

	If (cAliasGW3)->GW3_FRETEP == 0 .and. (cAliasGW3)->GW3_FRETEV == 0

		nGVlIcms  := 0
		nGVlFreteP:= 0
		nGVlFretev:= 0
		nGVlPedag := 0
		nGVlTaxas := 0

		GWI->(dbSetOrder(1))
		GWI->(dbSeek(xFilial("GWI")+(cAliasGW3)->GWF_NRCALC ))
		While GWI->GWI_NRCALC == (cAliasGW3)->GWF_NRCALC

			If GWI->GWI_NRCALC <> (cAliasGW3)->GWF_NRCALC
				Exit			
			EndIf

			If AllTrim(GWI->GWI_CDCOMP) == 'ICMS' .OR. AllTrim(GWI->GWI_CDCOMP) == 'IMP SN' .OR. AllTrim(GWI->GWI_CDCOMP) == 'IMPOSTO SN';
			    .OR. AllTrim(GWI->GWI_CDCOMP) == 'IMP REPASSADO'
				nGVlIcms  += GWI->GWI_VLFRET                                           //12
			ElseIf AllTrim(GWI->GWI_CDCOMP) == 'FRETE - PESO' 
				nGVlFreteP+= GWI->GWI_VLFRET                                           //13
			ElseIf AllTrim(GWI->GWI_CDCOMP) == 'FRETE VALOR' .OR. AllTrim(GWI->GWI_CDCOMP) == 'FRETE COMBINADO' ;
			    .OR. AllTrim(GWI->GWI_CDCOMP) == 'FRETE P/KM RODADO' .OR. AllTrim(GWI->GWI_CDCOMP) == 'FRETE'
				nGVlFretev+= GWI->GWI_VLFRET                                           //14
			ElseIf AllTrim(GWI->GWI_CDCOMP) == 'PEDAGIO'
				nGVlPedag += GWI->GWI_VLFRET                                           //15
    		Else
				nGVlTaxas += GWI->GWI_VLFRET                                           //16
			EndIf

			GWI->(dbSkip())

		EndDo	

		nGVlTFret := (cAliasGW3)->GW3_VLTFRE                                            //17
		nGPFrete  := ((cAliasGW3)->GW3_VLTFRE/(cAliasGW3)->GW3_VLMERC)*100              //19

	Else

		nGVlFreteP:=(cAliasGW3)->GW3_FRETEP                                             //13
		nGVlFretev:=(cAliasGW3)->GW3_FRETEV                                             //14
		nGVlPedag := (cAliasGW3)->GW3_VLPEDA                                            //15
		nGVlTaxas := (cAliasGW3)->GW3_TAXAS                                             //16
		nGVlTFret := (cAliasGW3)->GW3_VLTFRE                                            //17
		nGPFrete  := ((cAliasGW3)->GW3_VLTFRE/(cAliasGW3)->GW3_VLMERC)*100              //19
	
	EndIf

	(cAliasGW3)->(dbSkip())

EndDo

	   	AAdd(aDaDOS, { dGData                              ;                        //01
	   	              ,cGFilial                            ;                        //02
	   	              ,cGCte                               ;                        //03
	   	              ,cGOrigem                            ;                        //04
	   	              ,cGOrigem1                           ;                        //05
	   	              ,cGDestino                           ;                        //06
	   	              ,cGDestino1                          ;                        //07
	   	              ,cGTransp                            ;                        //08
	   	              ,Transform(cGTraCNPJ,"@R 99.999.999/9999-99") ;               //09
	   	              ,cGNF                                ;                        //10
	   	              ,nGVlMerc                            ;                        //11
	   	              ,nGVlIcms                            ;                        //12
	   	              ,nGVlFreteP                           ;                       //13
	   	              ,nGVlFreteV                           ;                       //14
	   	              ,nGVlPedag                           ;                        //15
	   	              ,nGVlTaxas                           ;                        //16
	   	              ,nGVlTFret                           ;                        //17
	   	              ,cGPlaca                             ;      //,cGObs ;        //18
	   	              ,Transform(nGPFrete,"@E 999.99")     ;                        //19
	   	              })
		cCte := (cAliasGW3)->GW3_CTE
		cGNF := ""
	
IF (Len(aDados) > 0)

	cArqGer := MkExcWB(.F., aDados)
	
	IF (cArqGer <> Nil)
		IF !ApOleClient( 'MsExcel' )
			MsgAlert("O excel nใo foi encontrado. Arquivo " + cArqGer + " gerado em " + GetClientDir( ) + ".", "MsExcel nใo encontrado" )
		ELSE
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open(cArqGer)
			oExcelApp:SetVisible(.T.)
		EndIF
	EndIF
	
ELSE

	MsgInfo("Os dados selecionados nos parโmetros nใo retornaram nenhum resultado!")
	
EndIF  

(cAliasGW3)->(dbCloseArea()) 

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFS_MkExcWBบAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria um arquivo XML para o Excel no diret๓rio indicado,    บฑฑ
ฑฑบ          ณ o no diret๓rio informado pelo parโmetro                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParโmetrosณ aItens: Matriz MxN que cont้m os dados a serem colocados   บฑฑ
ฑฑบ          ณ         na planilha                                        บฑฑ
ฑฑบ          ณ aCabec: Cabe็alho da planilha colocado na primeira linha   บฑฑ
ฑฑบ          ณ lCabec: Indica se a primiera linha da matriz corresponde   บฑฑ
ฑฑบ          ณ         ao cabe็alho da planilha                           บฑฑ
ฑฑบ          ณ cDirSrv:Diret๓rio no servidor onde serแ salvo o arquivo    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorna   ณO nome do arquivo salvo no servidor ou Nil, caso nใo seja   บฑฑ
ฑฑบ          ณpossivel efetuar a grava็ใo                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MkExcWB( lCabec, aItens, aCabec, cDirServer )
	Local cCreate   := AllTrim( Str( Year( dDataBase ) ) ) + "-" + AllTrim( Str( Month( dDataBase ) ) ) + "-" + AllTrim( Str( Day( dDataBase ) ) ) + "T" + SubStr( Time(), 1, 2 ) + ":" + SubStr( Time(), 4, 2 ) + ":" + SubStr( Time(), 7, 2 ) + "Z" // string de data no formato <Ano>-<Mes>-<Dia>T<Hora>:<Minuto>:<Segundo>Z
	Local nFields   := 19 // Nบ de Colunas  formato string
	Local nRecords  := 19 // Numero de Linhas + Cabe็alho formato string
	Local cFileName := CriaTrab( , .F. )
	Local i, j

	Local cDirNI    := UZXChoseDir()

	//	cFileName := Lower(GetClientDir( ) + cFileName + ".XLS")
	//cFileName := Lower("\\172.17.0.183\temp\Jairson\"+ cFileName + ".XLS")

	cFileName := Lower(cDirNI + cFileName + ".XLS")

	If Empty( aItens )
		aItens := aClone( aCols )
	End
	
	If Empty(aCabec) .AND. lCabec
		For i := 1 To Len( aHeader )
			AAdd( aCabec, aHeader[i][1] )
		Next
	EndIf
	
	If lCabec == Nil
		lCabec := .T.
	EndIf
	
	nRecords := Len( aItens)
			
/*	If lCabec
		nFields := Len( aCabec )
	Else
		nFields := Len( aItens[1] )
	EndIf
  */			
		
	If ( nHandle := FCreate( cFileName , FC_NORMAL ) ) != -1
		ConOut("Arquivo criado com sucesso.")
	Else
		MsgAlert("Nใo foi possivel criar a planilha. Por favor, verifique se existe espa็o em disco ou voc๊ possui pemissใo de escrita no diret๓rio \system\", "Erro de cria็ใo de arquivo")
		ConOut("Nใo foi possivel criar a planilha no diret๓rio \system\")
	 Return()
	EndIf
		
	cFile := "<?xml version=" + Chr(34) + "1.0" + Chr(34) + "?>" + Chr(13) + Chr(10)
	cFile += "<?mso-application progid=" + Chr(34) + "Excel.Sheet" + Chr(34) + "?>" + Chr(13) + Chr(10)
	cFile += "<Workbook xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:spreadsheet" + Chr(34) + " " + Chr(13) + Chr(10)
	cFile += "	xmlns:o=" + Chr(34) + "urn:schemas-microsoft-com:office:office" + Chr(34) + " " + Chr(13) + Chr(10)
	cFile += "	xmlns:x=" + Chr(34) + "urn:schemas-microsoft-com:office:excel" + Chr(34) + " " + Chr(13) + Chr(10)
	cFile += "	xmlns:ss=" + Chr(34) + "urn:schemas-microsoft-com:office:spreadsheet" + Chr(34) + " " + Chr(13) + Chr(10)
	cFile += "	xmlns:html=" + Chr(34) + "http://www.w3.org/TR/REC-html40" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "	<DocumentProperties xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:office" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "		<Author>" + AllTrim(SubStr(cUsuario,7,15)) + "</Author>" + Chr(13) + Chr(10)
	cFile += "		<LastAuthor>" + AllTrim(SubStr(cUsuario,7,15)) + "</LastAuthor>" + Chr(13) + Chr(10)
	cFile += "		<Created>" + cCreate + "</Created>" + Chr(13) + Chr(10)
	cFile += "		<Company>Microsiga Intelligence</Company>" + Chr(13) + Chr(10)
	cFile += "		<Version>11.6568</Version>" + Chr(13) + Chr(10)
	cFile += "	</DocumentProperties>" + Chr(13) + Chr(10)
	cFile += "	<ExcelWorkbook xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:excel" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "		<WindowHeight>9345</WindowHeight>" + Chr(13) + Chr(10)
	cFile += "		<WindowWidth>11340</WindowWidth>" + Chr(13) + Chr(10)
	cFile += "		<WindowTopX>480</WindowTopX>" + Chr(13) + Chr(10)
	cFile += "		<WindowTopY>60</WindowTopY>" + Chr(13) + Chr(10)
	cFile += "		<ProtectStructure>False</ProtectStructure>" + Chr(13) + Chr(10)
	cFile += "		<ProtectWindows>False</ProtectWindows>" + Chr(13) + Chr(10)
	cFile += "	</ExcelWorkbook>" + Chr(13) + Chr(10)
	cFile += "	<Styles>" + Chr(13) + Chr(10)
	cFile += "		<Style ss:ID=" + Chr(34) + "Default" + Chr(34) + " ss:Name=" + Chr(34) + "Normal" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "			<Alignment ss:Vertical=" + Chr(34) + "Bottom" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "			<Borders/>" + Chr(13) + Chr(10)
	cFile += "			<Font/>" + Chr(13) + Chr(10)
	cFile += "			<Interior/>" + Chr(13) + Chr(10)
	cFile += "			<NumberFormat/>" + Chr(13) + Chr(10)
	cFile += "			<Protection/>" + Chr(13) + Chr(10)
	cFile += "		</Style>" + Chr(13) + Chr(10)
	cFile += "	<Style ss:ID=" + Chr(34) + "s21" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "		<NumberFormat ss:Format=" + Chr(34) + "Short Date" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "	</Style>" + Chr(13) + Chr(10)
	cFile += "	</Styles>" + Chr(13) + Chr(10)
	cFile += " <Worksheet ss:Name=" + Chr(34) + "Planilha Nova " + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "		<Table ss:ExpandedColumnCount=" + Chr(34) + AllTrim( Str( nFields ) ) + Chr(34) + " ss:ExpandedRowCount=" + Chr(34) + AllTrim( Str( Iif( lCabec, 1 + nRecords, nRecords ) ) ) + Chr(34) + " x:FullColumns=" + Chr(34) + "1" + Chr(34) + " x:FullRows=" + Chr(34) + "1" + Chr(34) + ">" + Chr(13) + Chr(10)
							
	// Linha de Cabe็alho 
	If lCabec
		cFile += "			<Row>" + Chr(13) + Chr(10)
		For i := 1 To nFields
			cFile += "				<Cell><Data ss:Type=" + Chr(34) + "String" + Chr(34) + ">" + AllTrim(aCabec[i]) + "</Data></Cell>" + Chr(13) + Chr(10)
		Next
		cFile += "			</Row>" + Chr(13) + Chr(10)
	EndIf
			
	If nHandle >=0
	 FWrite(nHandle, cFile)
	 cFile := ""
	Endif
				
	For i := 1 To nRecords
		cFile += "			<Row>" + Chr(13) + Chr(10)
		For j := 1 To nFields
			cFile += "				" + FS_GetCell(aItens[i][j]) + Chr(13) + Chr(10)
		Next
		cFile += "			</Row>" + Chr(13) + Chr(10)
	 If (i % 100) == 0
	  If nHandle >=0
	   FWrite(nHandle, cFile)
		  cFile := ""
	  Endif
	 Endif
	Next
   
  
	cFile += "		</Table>" + Chr(13) + Chr(10)
	cFile += "		<WorksheetOptions xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:excel" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "			<PageSetup>" + Chr(13) + Chr(10)
	cFile += "				<Header x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "				<Footer x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "				<PageMargins x:Bottom=" + Chr(34) + "0.984251969" + Chr(34) + " x:Left=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Right=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Top=" + Chr(34) + "0.984251969" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "			</PageSetup>" + Chr(13) + Chr(10)
	cFile += "			<Selected/>" + Chr(13) + Chr(10)
	cFile += "			<ProtectObjects>False</ProtectObjects>" + Chr(13) + Chr(10)
	cFile += "			<ProtectScenarios>False</ProtectScenarios>" + Chr(13) + Chr(10)
	cFile += "		</WorksheetOptions>" + Chr(13) + Chr(10)
	cFile += "	</Worksheet>" + Chr(13) + Chr(10)
  
	cFile += "	<Worksheet ss:Name=" + Chr(34) + "Plan2" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "		<WorksheetOptions xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:excel" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "			<PageSetup>" + Chr(13) + Chr(10)
	cFile += "				<Header x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "				<Footer x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "				<PageMargins x:Bottom=" + Chr(34) + "0.984251969" + Chr(34) + " x:Left=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Right=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Top=" + Chr(34) + "0.984251969" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "			</PageSetup>" + Chr(13) + Chr(10)
	cFile += "			<ProtectObjects>False</ProtectObjects>" + Chr(13) + Chr(10)
	cFile += "			<ProtectScenarios>False</ProtectScenarios>" + Chr(13) + Chr(10)
	cFile += "		</WorksheetOptions>" + Chr(13) + Chr(10)
	cFile += "	</Worksheet>" + Chr(13) + Chr(10)
	cFile += "	<Worksheet ss:Name=" + Chr(34) + "Plan3" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "		<WorksheetOptions xmlns=" + Chr(34) + "urn:schemas-microsoft-com:office:excel" + Chr(34) + ">" + Chr(13) + Chr(10)
	cFile += "			<PageSetup>" + Chr(13) + Chr(10)
	cFile += "				<Header x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "				<Footer x:Margin=" + Chr(34) + "0.49212598499999999" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "				<PageMargins x:Bottom=" + Chr(34) + "0.984251969" + Chr(34) + " x:Left=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Right=" + Chr(34) + "0.78740157499999996" + Chr(34) + " x:Top=" + Chr(34) + "0.984251969" + Chr(34) + "/>" + Chr(13) + Chr(10)
	cFile += "			</PageSetup>" + Chr(13) + Chr(10)
	cFile += "			<ProtectObjects>False</ProtectObjects>" + Chr(13) + Chr(10)
	cFile += "			<ProtectScenarios>False</ProtectScenarios>" + Chr(13) + Chr(10)
	cFile += "		</WorksheetOptions>" + Chr(13) + Chr(10)
	cFile += "	</Worksheet>" + Chr(13) + Chr(10)
	cFile += "</Workbook>" + Chr(13) + Chr(10)
	
	ConOut("Criando o arquivo " + cFileName + ".")
	If nHandle  >= 0
		FWrite(nHandle, cFile)
		FClose(nHandle)
		ConOut("Arquivo criado com sucesso.")
	Else
		MsgAlert("Nใo foi possivel criar a planilha. Por favor, verifique se existe espa็o em disco ou voc๊ possui pemissใo de escrita no diret๓rio \system\", "Erro de cria็ใo de arquivo")
		ConOut("Nใo foi possivel criar a planilha no diret๓rio \system\")
	EndIf
	
Return cFileName
                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFS_GetCellบAutor  ณ     Microsiga      บ Data ณ  18/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera arquivo no SX1                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿	
 */
Static Function FS_GetCell( xVar )
	Local cRet  := ""
	Local cType := ValType(xVar)
	
	If cType == "U"
		cRet := "<Cell><Data ss:Type=" + Chr(34) + "General" + Chr(34) + "></Data></Cell>"
	ElseIf cType == "C"
		cRet := "<Cell><Data ss:Type=" + Chr(34) + "String" + Chr(34) + ">" + AllTrim( xVar ) + "</Data></Cell>"
	ElseIf cType == "N"
		cRet := "<Cell><Data ss:Type=" + Chr(34) + "Number" + Chr(34) + ">" + AllTrim( Str( xVar ) ) + "</Data></Cell>"
	ElseIf cType == "D"
		xVar := DToS( xVar )
	           //<Cell ss:StyleID=              "s21"              ><Data ss:Type=              "DateTime"              >    2006                  -    12                    -    27                    T00:00:00.000</Data></Cell>
		cRet := "<Cell ss:StyleID=" + Chr(34) + "s21" + Chr(34) + "><Data ss:Type=" + Chr(34) + "DateTime" + Chr(34) + ">" + SubStr(xVar, 1, 4) + "-" + SubStr(xVar, 5, 2) + "-" + SubStr(xVar, 7, 2) + "T00:00:00.000</Data></Cell>"
	Else
		cRet := "<Cell><Data ss:Type=" + Chr(34) + "Boolean" + Chr(34) + ">" + Iif ( xVar , "=VERDADEIRO" ,  "=FALSO" ) + "</Data></Cell>"
	EndIf

Return cRet          


*-----------------------------------------*
Static Function UZXChoseDir()
*-----------------------------------------*
Local cTitle:= "Gera็ใo de arquivo"
Local cMask := "Formato *|*.*"
Local cFile := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions:= GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY

cFile:= cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,.F., nOptions)

Return(cFile)
