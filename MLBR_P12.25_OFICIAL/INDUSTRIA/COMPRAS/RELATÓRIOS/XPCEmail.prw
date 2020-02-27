#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "Report.ch"
#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "RptDef.ch"
#Include "FwPrintSetup.ch"
#include 'fileio.ch'
/*
*Funcao: XPCEmail() | Autor:  AOliveira | Data: 13-06-209
*Descri: Envio de PC por email.
*/
User Function XPCEMAIL(cNumPed)
                 
Local cArqPDF := ""

Private _cAlias		:= GetNextAlias()
Private cEOL 		:= "CHR(13)+CHR(10)"

DEFAULT cNumPed		:= ""

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif
          
//Monta arquivo de trabalho temporário
MsAguarde({|| MontaQuery(SC7->C7_NUM)},"Aguarde","Criando arquivos para impressão...")

//Verifica resultado da query

DbSelectArea(_cAlias)
DbGoTop()
If (_cAlias)->(Eof())
	MsgAlert("Relatório vazio! Verifique os parâmetros.","Atenção")  //"Relatório vazio! Verifique os parâmetros."##"Atenção"
	(_cAlias)->(DbCloseArea())
Else
	Processa({|| cArqPDF := Imprime() },"Pedido de Compras ","Imprimindo...") //"Pedido de Compras "##"Imprimindo..." 
	// XEVMAIL(cArqPDF) //Enviar o e-mail
EndIf

/*/ Apaga um arquivo PDF gerado
If FERASE(cArqPDF) == -1
	Conout('Falha na deleção do Arquivo')
Else
	Conout('Arquivo deletado com sucesso.')
Endif
/*/     

Return
                                                  
/* 
*MONTA A PAGINA DE IMPRESSAO
*/
Static Function Imprime()

Local _nCont 		:= 1
Local cPedidoAtu	:= ""
Local cPedidoAnt	:= ""
Local aAreaSM0	:= {}	 

Local lAdjustToLegacy := .T.
Local lDisableSetup   := .T.
Local cLocal          := "\data\"
Local cFilePrint      := ""


Private cBitmap	    := ""

Private nLin
Private _nValIcm	:= 0   // Valor do Icms
Private _nValIcmR	:= 0   // Valore do Icms retido
Private _nValIpi	:= 0   // Valor do Ipi
Private _nPag  		:= 1   // Numero da
Private _nTot    	:= 0   // Valor Total
Private _nFrete		:= 0   // Valor do frete
Private _nDescPed	:= 0
Private _nDesc1	 	:= 0
Private _nDesc2	 	:= 0
Private _nDesc3	 	:= 0
Private _nDespesa	:= 0
Private _nSeguro	:= 0
Private _dDtEnt
Private _cEndEnt	:= ""
Private _cBairEnt	:= ""
Private _cCidEnt	:= ""
Private _cEstEnt	:= ""		
Private _cTel		:= ""
Private _cEndCob	:= ""
Private _cBairCob	:= ""
Private _cCidCob	:= ""
Private _cEstCob	:= ""		
Private _cTelCob	:= ""

cBitmap := R110ALogo()

//Fontes a serem utilizadas no relatório

Private oFont08 	:= TFont():New( "Arial",,08,,.f.,,,,,.f.)
Private oFont08N 	:= TFont():New( "Arial",,08,,.T.,,,,,.f.)
Private oFont08I 	:= TFont():New( "Arial",,08,,.f.,,,,,.f.,.T.)

Private oFont09N 	:= TFont():New( "Arial",,09,,.T.,,,,,.f.)    

Private oFont10 	:= TFont():New( "Arial",,10,,.f.,,,,,.f.)
Private oFont10N 	:= TFont():New( "Arial",,10,,.T.,,,,,.f.)
Private oFont10I 	:= TFont():New( "Arial",,10,,.f.,,,,,.f.,.T.)

Private oFont17 	:= TFont():New( "Arial",,17,,.F.,,,,,.F.)
Private oFont17N 	:= TFont():New( "Arial",,17,,.T.,,,,,.F.)

Private oFontCOR 	:= TFont():New( "Arial",,09,,.f.,,,,,.f.)
Private oFontCORN 	:= TFont():New( "Arial",,09,,.T.,,,,,.f.)
Private oFontCORI 	:= TFont():New( "Arial",,09,,.f.,,,,,.f.,.T.)

Private cNomeRel := "PC_"+Alltrim(SC7->C7_NUM)
      
Private _aCol := {	0035,; //Item | 
    	          	0100,; //Codigo | 
				    0200,; //Descricao do Material|     
				    0970,; //Grupo| 
				    1050,; //UM| 
					1170,; //Quantidade| 
					1320,; //Valor Unitario| 
					1450,; //IPI| 
					1580,; //Valor Total| 
					1710,; //Entrega| 
					1840,; //C.C.| 
					1970,; //S.C.| 
					2100}  //C/E|

Private cDirClient	:= GetClientDir()+ "pdf\"
				
//Start de impressão
//Private oPrn:= TMSPrinter():New()  
//Private oPrn := FWMSPrinter():New(cNomeRel+'.PD_', IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F.,.f. )     
//FWMsPrinter(): New ( < cFilePrintert >, [ nDevice], [ lAdjustToLegacy], [ cPathInServer], [ lDisabeSetup ], [ lTReport], [ @oPrintSetup], [ cPrinter], [ lServer], [ lPDFAsPNG], [ lRaw], [ lViewPDF], [ nQtdCopy] ) 

oPrn := FWMsPrinter():New(AllTrim(cNomeRel) + ".pdf", 6, .T., , .T.)

//oPrn:SetLandScape()  // SetPortrait() - Formato retrato   SetLandscape() - Formato Paisagem
oPrn:SetPortrait()  // SetPortrait() - Formato retrato   SetLandscape() - Formato Paisagem
 
oPrn:SetViewPDF(.t.) //Define si se visualiza PDF
oPrn:cPathPDF := cDirClient

oPrn:SetPaperSize(DMPAPER_A4)
       
If !ExistDir(cDirClient) //Valida que exista directorio auxiliar para crear PDF
	MakeDir(cDirClient)
EndIf


//cabecalho da pagina
Cabec(.t.)

cPedidoAnt := (_cAlias)->C7_NUM 

// Carrega dados da filial de cobrança - sempre 01
If((_cAlias)->C7_FILENT != NIL)
 	aAreaSM0 := SM0->(GetArea())
	dbSelectArea("SM0")
	dbGoTop()
	While !Eof()
		If Trim(M0_CODFIL) == '01'
 			_cEndCob	:= M0_ENDENT
 			_cBairCob	:= M0_BAIRENT
			_cCidCob	:= M0_CIDENT
			_cEstCob	:= M0_ESTENT
			_cTelCob	:= M0_TEL
		EndIf
		dbSkip()
	EndDo
	RestArea(aAreaSM0)
EndIf

// Carrega dados da filial de Entrega
If((_cAlias)->C7_FILENT != NIL)
 	aAreaSM0 := SM0->(GetArea())
	dbSelectArea("SM0")
	dbGoTop()
	While !Eof()
		If Trim(M0_CODFIL) == Trim((_cAlias)->C7_FILENT)
 			_cEndEnt	:= M0_ENDENT
 			_cBairEnt	:= M0_BAIRENT
			_cCidEnt	:= M0_CIDENT
			_cEstEnt	:= M0_ESTENT
			_cTel		:= M0_TEL
		EndIf
		dbSkip()
	EndDo
	RestArea(aAreaSM0)
EndIf

While (_cAlias)->(!Eof())

	cPedidoAtu := (_cAlias)->C7_NUM
	
	If _nCont >= 29 .Or. cPedidoAtu <> cPedidoAnt
		
		If cPedidoAtu <> cPedidoAnt
					
			Rodap()
			
			// Carrega dados da filial de Entrega
			If((_cAlias)->C7_FILENT != NIL)
				aAreaSM0 := SM0->(GetArea())
				dbSelectArea("SM0")
				dbGoTop()
				While !Eof()
					If Trim(M0_CODFIL) == Trim((_cAlias)->C7_FILENT)
 						_cEndEnt	:= M0_ENDENT
 						_cBairEnt	:= M0_BAIRENT
						_cCidEnt	:= M0_CIDENT
						_cEstEnt	:= M0_ESTENT
						_cTel		:= M0_TEL
					EndIf
					dbSkip()
				EndDo
				RestArea(aAreaSM0)
			EndIf
						
			_nDescPed 	:= 0
			_nDesc1 	:= 0
			_nDesc2 	:= 0
			_nDesc3 	:= 0
			_nValIpi	:= 0
			_nValIcm	:= 0
			_nValIcmR	:= 0
			_nTot		:= 0
			_nFrete	    := 0
			_dDtEnt 	:= NIL
			
			oPrn :EndPage() 
			
		Else
			oPrn:line(1960,0075,1960,3425)    //Linha Horizontal Rodape Inferior
		EndIf
		
		_nCont		:= 0
		_nPag 		+= 1
		
		oPrn :EndPage() 
		Cabec(.t.)
	EndIf
	    
    oPrn:say(nLin,_aCol[01],(_cAlias)->C7_ITEM, oFontCOR)	 //Item //Item | 
    oPrn:say(nLin,_aCol[02],Substr((_cAlias)->C7_PRODUTO,1,25),oFontCOR)						//codigo//Codigo | 
    oPrn:say(nLin,_aCol[03],Substr((_cAlias)->B1_DESC,1,70),oFontCOR)							//descricao //Descricao do Material|     
    oPrn:say(nLin,_aCol[04],(_cAlias)->B1_GRUPO ,oFontCOR)    //Grupo| 
    oPrn:say(nLin,_aCol[05],(_cAlias)->C7_UM,oFontCOR)										//unidade de medida //UM| 
	oPrn:say(nLin,_aCol[06],Transform((_cAlias)->C7_QUANT,"@R 999999"), oFontCOR)				//Quantidade //Quantidade| 
	oPrn:say(nLin,_aCol[07],Transform((_cAlias)->C7_PRECO,"@R 999,999,999.99"),oFontCOR)		//VLR UNIT //Valor Unitario| 
	oPrn:say(nLin,_aCol[08],Transform((_cAlias)->C7_IPI,"@R 999.99"),oFontCOR)				//IPI //IPI| 
	oPrn:say(nLin,_aCol[09],Transform((_cAlias)->C7_TOTAL,"@R 999,999,999.99"),oFontCOR)		//VLR TOT //Valor Total| 
	oPrn:say(nLin,_aCol[10],DTOC((_cAlias)->C7_DATPRF),oFontCOR)								//data de entrega //Entrega| 
	oPrn:say(nLin,_aCol[11],(_cAlias)->C7_CC ,oFontCOR)                                       //C.C.| 
	oPrn:say(nLin,_aCol[12],(_cAlias)->C7_NUMSC ,oFontCOR)  //S.C.| 
	oPrn:say(nLin,_aCol[13],(_cAlias)->C7_OP ,oFontCOR)  //C/E|
	
/*
	
	
	
	
	



	//C/E|


	
	
	oPrn:say(nLin,0500,Substr((_cAlias)->A5_CODPRF,1,18),oFont08)						//codigo do fornecedor
  */
	  
	/*
	oPrn:say(nLin,0035,(_cAlias)->C7_ITEM, oFont08)		  								//item
	oPrn:say(nLin,0150,Transform((_cAlias)->C7_QUANT,"@R 999999"), oFont08)				//Quantidade
	oPrn:say(nLin,0280,Substr((_cAlias)->C7_PRODUTO,1,25),oFont08)						//codigo
	oPrn:say(nLin,0500,Substr((_cAlias)->A5_CODPRF,1,18),oFont08)						//codigo do fornecedor
	oPrn:say(nLin,0800,(_cAlias)->C7_UM,oFont08)										//unidade de medida
	oPrn:say(nLin,1160,Substr((_cAlias)->B1_DESC,1,70),oFont08)							//descricao
	oPrn:say(nLin,2250,Transform((_cAlias)->C7_PRECO,"@R 999,999,999.99"),oFont08)		//VLR UNIT
	oPrn:say(nLin,2570,Transform((_cAlias)->C7_TOTAL,"@R 999,999,999.99"),oFont08)		//VLR TOT
	oPrn:say(nLin,2890,Transform((_cAlias)->C7_IPI,"@R 999.99"),oFont08)				//IPI
	oPrn:say(nLin,3150,DTOC((_cAlias)->C7_DATPRF),oFont08)								//data de entrega
	*/
	_nFrete	+= (_cAlias)->C7_VALFRE
	
	If (_cAlias)->C7_DESC1 != 0 .or. (_cAlias)->C7_DESC2 != 0 .or. (_cAlias)->C7_DESC3 != 0
		_nDescPed  += CalcDesc((_cAlias)->C7_TOTAL,(_cAlias)->C7_DESC1,(_cAlias)->C7_DESC2,(_cAlias)->C7_DESC3)
	    _nDesc1	:= (_cAlias)->C7_DESC1
		_nDesc2	:= (_cAlias)->C7_DESC2
		_nDesc3	:= (_cAlias)->C7_DESC3
	Else
		_nDescPed += (_cAlias)->C7_VLDESC
	Endif
	
	If _dDtEnt == NIL
		_dDtEnt := (_cAlias)->C7_DATPRF 
	ElseIf (_cAlias)->C7_DATPRF > _dDtEnt
		_dDtEnt := (_cAlias)->C7_DATPRF 
	Endif
	
	_nCont 		+= 1
	_nValIcm 	+= (_cAlias)->C7_VALICM
	_nValIcmR	+= (_cAlias)->C7_ICMSRET 
	_nValIpi 	+= (_cAlias)->C7_VALIPI
	_nTot 	 	+= (_cAlias)->C7_TOTAL
	_nDespesa 	+= (_cAlias)->C7_DESPESA
	_nSeguro	+= (_cAlias)->C7_SEGURO
	
	nLin += 50   //pula linha
	
	cPedidoAnt := (_cAlias)->C7_NUM
	
	//Verifica a quebra de pagina
	
	(_cAlias)->(dBskip())               
EndDo

If _nCont <= 32
	(_cAlias)->(DbGoTop())
	//		Infoger()
	Rodap()
	//		WordImp()
Else
	(_cAlias)->(DbGoTop())
	Rodap()
	oPrn :EndPage()
	Cabec(.f.)
	//   		Infoger()
	Rodap()
	//   		WordImp()
EndIF

/*
If(mv_par09 == 1)
  oPrn:Print()
Else
  oPrn:Preview() //Preview DO RELATORIO
EndIf
*/ 
/*            
FERASE(cLocal+cNomeRel+'.PDF')

cFilePrint := cLocal+cNomeRel+'.PD_'
File2Printer( cFilePrint, "PDF" )
oPrn:cPathPDF:= cLocal 
*/
oPrn:Print()            

//oPrn:Preview()
              
If (File(cLocal+cNomeRel+".PDF"))
	cFilePrint := cLocal + cNomeRel + ".PDF"
Else
	cFilePrint := ""
EndIf

Return(cFilePrint)

/*
*Impressão do Relatório
*/
Static Function  Cabec(_lCabec)

Private oFont12 	:= TFont():New( "Arial",,12,,.f.,,,,,.f.)
Private oFont12N 	:= TFont():New( "Arial",,12,,.T.,,,,,.f.)
Private oFont12I 	:= TFont():New( "Arial",,12,,.f.,,,,,.f.,.T.)

Private oFontCAB 	:= TFont():New( "Arial",,09,,.f.,,,,,.f.)
Private oFontCABN 	:= TFont():New( "Arial",,09,,.T.,,,,,.f.)
Private oFontCABI 	:= TFont():New( "Arial",,09,,.f.,,,,,.f.,.T.)
                                                                 
Private oFontCOR 	:= TFont():New( "Arial",,09,,.f.,,,,,.f.)
Private oFontCORN 	:= TFont():New( "Arial",,09,,.T.,,,,,.f.)
Private oFontCORI 	:= TFont():New( "Arial",,09,,.f.,,,,,.f.,.T.)

oPrn:StartPage()	//Inicia uma nova pagina

_cFileLogo	:= GetSrvProfString('Startpath','') + cBitmap

//oPrn:SayBitmap(0045,0060,_cFileLogo,0400,0125)
oPrn:SayBitmap(0045,0060,_cFileLogo,0239,0100)
            
nLin:= 95 // 70
oPrn:say(nLin,0900, "PEDIDO DE COMPRA:"+ " " +Alltrim((_cAlias)->C7_NUM),oFont17N) //"PEDIDO DE COMPRA:"
oPrn:say(nLin,1865,Iif(!Empty(Alltrim((_cAlias)->C7_OP))," |   OP: " +Alltrim((_cAlias)->C7_OP),""),oFont17N)

//nLin := 115 //90
oPrn:say(nLin,1970, "EMISSÃO:"+ " " + dtoc((_cAlias)->C7_EMISSAO) ,oFont12) //"EMISSÃO:"

oPrn:line(180,0930,430,0930) 	//Linha Vertical Cabecalho
oPrn:line(445,0035,445,2375)    //Linha Horizontal Cabecalho Inferior
oPrn:line(505,0035,505,2375)    //Linha Horizontal Cabecalho Inferior

/*
*cabecalho
*/
// Primeira coluna do cabecalho
nLin := 205 //225
oPrn:say (nLin,0035, SM0->M0_NOMECOM ,oFontCAB)
nLin += 35
oPrn:say (nLin,0035,"CNPJ:"+" "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+"  -  "+"I.E:"+" "+Alltrim(SM0->M0_INSC) ,oFontCAB)  //"CNPJ:"##"I.E:"
nLin += 35
oPrn:say (nLin,0035,Alltrim(SM0->M0_ENDCOB)+" "+ Alltrim(SM0->M0_BAIRCOB)+" - "+Alltrim(SM0->M0_CIDCOB)+" /"+Alltrim(SM0->M0_ESTCOB)+"  "+"CEP:"+" "+(SM0->M0_CEPENT),oFontCAB) //"CEP:"
nLin += 35
oPrn:say (nLin,0035,"TEL.:"+" "+Alltrim(SM0->M0_TEL)+"  -  "+"FAX:"+" "+Alltrim(SM0->M0_FAX) ,oFontCAB) //"TEL.:"##"FAX:"
nLin += 35
oPrn:say (nLin,0035,"NFE.:"+" "+LOWER(Alltrim(SM0->M0_DSCCNA)) ,oFontCAB)

//............................................................................................
// Segunda coluna do cabecalho (FORNECEDOR)

nLin := 205 //180
oPrn:say (nLin,0960,"Fornecedor",oFontCABI)  //"Fornecedor"
nLin += 40
oPrn:say (nLin,0960,(_cAlias)->A2_COD, oFontCAB)
oPrn:say (nLin,1070,(_cAlias)->A2_NOME, oFontCAB)
oPrn:say (nLin,1970,"CNPJ:", oFontCABI) //"CNPJ:"
oPrn:say (nLin,2045,Transform((_cAlias)->A2_CGC,"@R 99.999.999/9999-99"), oFontCAB)
nLin += 50
oPrn:say (nLin,0960,"End:", oFontCABI) //"End:"
oPrn:say (nlin,1070,(_cAlias)->A2_END, oFontCAB)
oPrn:say (nLin,1970,"I.E:",oFontCABI) //"I.E:"
oPrn:say (nLin,2045,Transform((_cAlias)->A2_INSCR,"@R 999.999.999.999"),oFontCAB)
nLin += 50
oPrn:say (nLin,0960,"Bairro:"+" ", oFontCABI) //"Bairro:"
oPrn:say (nLin,1070,(_cAlias)->A2_BAIRRO,oFontCAB)
oPrn:say (nLin,1580,"Municipio/UF:"+" ", oFontCABI) //"Municipio/UF:"
oPrn:say (nLin,1720,Alltrim((_cAlias)->A2_MUN)+" / "+(_cAlias)->A2_EST,oFontCAB)
oPrn:say (nLin,1970,"CEP:"+" ", oFontCABI) //"CEP:"
oPrn:say (nLin,2045,Transform((_cAlias)->A2_CEP,"@R 99.999-999"), oFontCAB)
nLin += 50
oPrn:say (nLin,0960,"TEL.:"+" ", oFontCABI) //"TEL.:"
oPrn:say (nLin,1070,"("+Alltrim((_cAlias)->A2_DDD)+") "+Transform((_cAlias)->A2_TEL,"@R 9999-9999"),oFontCAB)
oPrn:say (nLin,1580,"FAX:"+" ", oFontCABI) //"FAX:"
oPrn:say (nLin,1720,"("+Alltrim((_cAlias)->A2_DDD)+") "+Transform((_cAlias)->A2_FAX,"@R 9999-9999"),oFontCAB)


/*
*Corpo
*/      
/*
	_aCol := {}
    AAdd(_aCol,0035)  //Item | 
    AAdd(_aCol,0100) //Codigo | 
    AAdd(_aCol,0200) //Descricao do Material|     
    AAdd(_aCol,0970) //Grupo| 
    AAdd(_aCol,1050) //UM| 
	AAdd(_aCol,1170) //Quantidade| 
	AAdd(_aCol,1320) //Valor Unitario| 
	AAdd(_aCol,1450) //IPI| 
	AAdd(_aCol,1580) //Valor Total| 
	AAdd(_aCol,1710) //Entrega| 
	AAdd(_aCol,1840) //C.C.| 
	AAdd(_aCol,1970)  //S.C.| 
	AAdd(_aCol,2100)  //C/E|
*/
	
nLin := 485//450
oPrn:say (nLin,_aCol[01],"Item",oFontCORI)                  //|Item| 
oPrn:say (nLin,_aCol[02],"Codigo",oFontCORI)                //Codigo| 
oPrn:say (nLin,_aCol[03],"Descricao do Material",oFontCORI) //Descricao do Material|
oPrn:say (nLin,_aCol[04],"Grp",oFontCORI)                 //Grupo| 
oPrn:say (nLin,_aCol[05],"UM",oFontCORI)                    //UM| 
oPrn:say (nLin,_aCol[06],"Qtde",oFontCORI)            //Quantidade| 
oPrn:say (nLin,_aCol[07],"Vlr Unit",oFontCORI)        //Valor Unitario| 
oPrn:say (nLin,_aCol[08],"IPI",oFontCORI)                   //IPI| 
oPrn:say (nLin,_aCol[09],"Vlr Total",oFontCORI)           //Valor Total| 
oPrn:say (nLin,_aCol[10],"Entrega",oFontCORI)               //Entrega| 
oPrn:say (nLin,_aCol[11],"C.C",oFontCORI)                   //C.C. |
oPrn:say (nLin,_aCol[12],"S.C",oFontCORI)                   //S.C. | 
oPrn:say (nLin,_aCol[13],"C/E",oFontCORI)                   //C/E|
nLin := 535//510                           

return()

/*
*Rodape
*/
Static Function Rodap()                                

Local x    
Local aTextPad := {}

AADD(aTextPad,{"A Nota Fiscal deverá constar o número do(s) Pedido de Compra(s) e Nome do solicitante Midori."})
AADD(aTextPad,{"Produtos Químicos deverão estar acompanhados de seus respectivos certificados de análises e FISPQ."})
AADD(aTextPad,{"Produtos Automotivos deverão estar acompanhados de seus respectivos CQ's em conformidade com PPAP aprovados em último nível."})
AADD(aTextPad,{"Os demais quesitos devem estar em conformidade com o nosso Manual de Fornecedores."})
AADD(aTextPad,{"Não serão recebidos mercadorias ou notas fiscais nos 02 (dois) últimos dias do mês."})
AADD(aTextPad,{"Não serão aceitas Notas Fiscais com valores e quantidades divergentes, e os devidos impostos vigentes."})
AADD(aTextPad,{"Serão informados os prazos de entrega e detalhes da transportadora para Pedidos de compra com frete FOB;"})
AADD(aTextPad,{"Entregas parciais deverão estar acordadas com o Planejamentos e controle de produção (PCP) ou Suprimentos;"})
AADD(aTextPad,{"Conformar o recebimento do(s) pedido(s) e a precisão de entrega via e-mail;"})

///oPrn:line(1900,0035,1900,3425)    //Linha Horizontal Rodape Inferior
//oPrn:line(1960,0035,1960,3425)    //Linha Horizontal Rodape Inferior
//oPrn:line(2120,0035,2120,3425)    //Linha Horizontal Rodape Inferior  Alterado em 22.08.2012 por André Luiz de Sousa

nLin := 1900 //1930 //1905
oPrn:line(nLin,0035,nLin,2375)    //Linha Horizontal Rodape Inferior
nLin += 20
_nTot := (_nTot + _nValIcmR + _nValIpi + _nDespesa + _nSeguro - _nDescPed)

cTotal := ""
/*
oPrn:say(nLin,0035,"Desc: "+ Transform(_nDesc1,"@E 999.99")+"%  "+Transform(_nDesc2,"@E 999.99")+"%  "+Transform(_nDesc3,"@E 999.99")+"%    "+Transform(_nDescPed, "@E 999,999,999.99") ,oFont08I) //"Desc:"
oPrn:say(nLin,0700,"ICMS: "+ Alltrim(Transform(_nValIcm,"@E 999,999,999.99")),oFont08I) 		//"ICMS:"
oPrn:say(nLin,1100,"IPI:  "+ Alltrim(Transform(_nValIpi,"@E 999,999,999.99")),oFont08I) 		//"IPI:"
oPrn:say(nLin,1500,"Despesas: "+ Alltrim(Transform(_nDespesa,"@E 99,999,999.99"),oFont08I))	//"Despesas: "
oPrn:say(nLin,1900,"Seguro: "+ Alltrim(Transform(_nSeguro,"@E 99,999,999.99")),oFont08I)		//"Seguro: "
oPrn:say(nLin,2300,"Vlr Frete:"+ Alltrim(Transform(_nFrete,"@E 999,999,999.99")),oFont08I) 	//"Vlr Frete:"
*/

cTotal += "Desc: "+ Alltrim(Transform(_nDesc1,"@E 999.99"))+"%  "+Alltrim(Transform(_nDesc2,"@E 999.99"))+"%  "+Alltrim(Transform(_nDesc3,"@E 999.99"))+"%    "+Alltrim(Transform(_nDescPed, "@E 999,999,999.99"))
cTotal += "  |  ICMS: "+ Alltrim(Transform(_nValIcm,"@E 999,999,999.99"))
cTotal += "  |  IPI:  "+ Alltrim(Transform(_nValIpi,"@E 999,999,999.99"))
cTotal += "  |  Despesas: "+ Alltrim(Transform(_nDespesa,"@E 99,999,999.99"))
cTotal += "  |  Seguro: "+ Alltrim(Transform(_nSeguro,"@E 99,999,999.99"))
cTotal += "  |  Vlr Frete:"+ Alltrim(Transform(_nFrete,"@E 999,999,999.99"))

oPrn:say(nLin,0035, cTotal ,oFont08I) 

oPrn:say(nLin,1900,"  |  Valor Total: "+Transform(_nTot,"@E 999,999,999.99"),oFont08N) 	//"Valor Total:"
           
        
//Verifica tipo do frete
cTPFrete := ""
Do Case            
	Case Alltrim(SC7->C7_TPFRETE) == "C"
		cTPFrete := "C-CIF"
	Case Alltrim(SC7->C7_TPFRETE) == "F"
		cTPFrete := "F-FOB"                               
	Case Alltrim(SC7->C7_TPFRETE) == "T"
		cTPFrete := "T-Por Conta Terceiros"               
	Case Alltrim(SC7->C7_TPFRETE) == "R"
		cTPFrete := "R-Por Conta Remetente"               
	Case Alltrim(SC7->C7_TPFRETE) == "D"
		cTPFrete := "D-Por Conta Destinatário"            
	Case Alltrim(SC7->C7_TPFRETE) == "S"
		cTPFrete := "S-Sem Frete"                         
	OtherWise
		cTPFrete := " "
EndCase   

cAprov := ""
dbSelectArea("SC7")
If !Empty(SC7->C7_APROV)
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM)
	While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM)==xFilial("SCR")+Alltrim(SC7->C7_NUM) .And. SCR->CR_TIPO == "PC"
		If (SCR->CR_STATUS=="03")
			cAprov += AllTrim(UsrFullName(SCR->CR_USER))+" "
			cAprov += " "
		EndIf	
		dbSelectArea("SCR")
		dbSkip()
	Enddo
EndIf

nLin += 20 
oPrn:line(nLin,0035,nLin,2375)    //Linha Horizontal Rodape Inferior

nLin += 30 

oPrn:say(nLin,0035,"COND. PAGT :",oFont08N)
SE4->(dbSetOrder(1))
SE4->(dbSeek(xFilial("SE4")+SC7->C7_COND)) 
oPrn:say(nLin,0325,SubStr(SE4->E4_COND,1,40) ,oFont08)
nLin += 30

oPrn:say(nLin,0035,"FRETE:",oFont08N)   
oPrn:say(nLin,0325, cTPFrete ,oFont08)
nLin += 30 

oPrn:say(nLin,0035,"COMPRADOR RESPONSÁVEL:",oFont08N) 
oPrn:say(nLin,0325,Alltrim(UsrFullName(SC7->C7_USER)) ,oFont08)
nLin += 30  

oPrn:say(nLin,0035,"APROVADOR(es) :",oFont08N)
oPrn:say(nLin,0325,cAprov ,oFont08)
nLin += 30   

oPrn:say(nLin,0035,"LOCAL DE ENTREGA:",oFont08N)                 
oPrn:say(nLin,0325,Alltrim(_cEndEnt) +" - "+Alltrim(_cBairEnt) +" / "+Alltrim(_cCidEnt)+ " - " +Alltrim(_cEstEnt)+"   Telefone: "+Alltrim(_cTel) ,oFont08)
nLin += 30   

oPrn:say(nLin,0035,"LOCAL DE COBRANÇA:",oFont08N)
oPrn:say(nLin,0325,Alltrim(_cEndCob) +" - "+Alltrim(_cBairCob) +" / "+Alltrim(_cCidCob)+ " - " +Alltrim(_cEstCob)+"   Telefone: "+Alltrim(_cTelCob) ,oFont08)
nLin += 30

/*
oPrn:say(nLin,0035,"Prazo Programado p/ Entrega:"+"  "+DTOC(_dDtEnt),oFont08) 			//"Prazo Programado p/ Entrega:"

nLin += 30                                                                                                                                   
oPrn:say(nLin,0035,"Endereço de Entrega:"+" "+Alltrim(_cEndEnt) +" - "+Alltrim(_cBairEnt),oFont08) 	//"Endereço de Entrega:"
oPrn:say(nLin,1700,"Cidade / UF:"+" "+Alltrim(_cCidEnt)+ "/" +Alltrim(_cEstEnt),oFont08) 		    //"Cidade / UF:"
oPrn:say(nLin,2300,"Telefone:"+" "+Alltrim(_cTel),oFont08) 									        //"Telefone:"
 */
 
nLin += 20 
//nLin := 2320 
oPrn:line(nLin,0035,nLin,2375)    //Linha Horizontal Rodape Inferior

nLin += 30 
for x:= 1 to Len(aTextPad)
	oPrn:say(nLin,0035, aTextPad[x][1] ,oFont08) //Texto Padrão de observação
	nLin += 30
Next x

            
//nLin += 2120 + 100              
nLin += 30
oPrn:say (nLin,1365 /*3330*/,Transform(_nPag,"@R 999"),oFont08I)    //Impressão do numero da página

oPrn :EndPage()

Return

/*
* QUERY
*/
Static Function MontaQuery(_cNumPed)

Local cQuery  
Default _cNumPed := ""

cQuery := "SELECT DISTINCT SC7.C7_NUM,SC7.C7_ITEM,SC7.C7_FILENT, SC7.C7_VALFRE, SC7.C7_UM, SC7.C7_OP,"
cQuery += " SC7.C7_QUANT, SC7.C7_PRODUTO, SC7.C7_FORNECE, SC7.C7_LOJA, SC7.C7_DESCRI, SC7.C7_PRECO,"
cQuery += " SC7.C7_TOTAL, SC7.C7_EMISSAO, SC7.C7_DATPRF, SC7.C7_IPI, SC7.C7_DESC1,"
cQuery += " SC7.C7_DESC2, SC7.C7_DESC3, SC7.C7_VLDESC, SC7.C7_BASEICM, SC7.C7_BASEIPI, SC7.C7_VALIPI,"
cQuery += " SC7.C7_VALICM,SC7.C7_DT_EMB, SC7.C7_TOTAL, SC7.C7_CODTAB, SC7.C7_SEGURO, SC7.C7_DESPESA,"
cQuery += " SC7.C7_ICMSRET,SC7.C7_CC, SC7.C7_NUMSC, SC7.C7_COND, SC7.C7_FRETE, "
cQuery += " SA2.A2_COD, SA2.A2_NOME, SA2.A2_END, SA2.A2_BAIRRO, SA2.A2_EST, SA2.A2_MUN, SA2.A2_CEP,"
cQuery += " SA2.A2_CGC, SA2.A2_INSCR, SA2.A2_TEL, SA2.A2_FAX, SA2.A2_DDD, SA5.A5_CODPRF, SB1.B1_DESC, SB1.B1_GRUPO"
cQuery += " FROM "+RetSqlName('SC7')+" SC7 "
cQuery += " INNER JOIN "+RetSqlName('SA2')+" SA2 ON SA2.A2_FILIAL = '"+xFilial("SA2")+"' AND SC7.C7_FORNECE =  SA2.A2_COD     AND SC7.C7_LOJA = SA2.A2_LOJA        AND SA2.D_E_L_E_T_ <> '*' "
cQuery += " LEFT JOIN "+RetSqlName('SA5')+" SA5 ON SA5.A5_FILIAL = '"+xFilial("SA5")+"'  AND SC7.C7_PRODUTO =  SA5.A5_PRODUTO AND SC7.C7_FORNECE =  SA5.A5_FORNECE AND SC7.C7_LOJA = SA5.A5_LOJA  AND SA5.D_E_L_E_T_ <> '*' "
cQuery += " INNER JOIN "+RetSqlName('SB1')+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SC7.C7_PRODUTO =  SB1.B1_COD     AND SB1.D_E_L_E_T_ <> '*' "
cQuery += " WHERE SC7.C7_FILIAL = '"+xFilial("SC7")+"' "
cQuery += " AND SC7.C7_NUM  = '"+_cNumPed+"' "
cQuery += " AND SC7.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY SC7.C7_NUM,SC7.C7_ITEM"

//Criar alias temporário
TCQUERY cQuery NEW ALIAS (_cAlias)

tCSetField((_cAlias), "C7_EMISSAO", "D")
tCSetField((_cAlias), "C7_DATPRF",  "D")
tCSetField((_cAlias), "C7_DT_EMB",  "D")

Return()

/*
*Funcao: R110ALogo | Autor: AOliveira | Data: 13-06-2019
*Descri: Retorna string com o nome do arquivo bitmap de logotipo
*/
Static Function R110ALogo()

Local cRet := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial

/*
Se nao encontrar o arquivo com o codigo do grupo de empresas 
completo, retira os espacos em branco do codigo da empresa   
para nova tentativa.                                         
*/
If !File( cRet )
	cRet := "LGRL" + AllTrim(SM0->M0_CODIGO) + SM0->M0_CODFIL+".BMP" // Empresa+Filial
EndIf

/*
Se nao encontrar o arquivo com o codigo da filial completo, 
retira os espacos em branco do codigo da filial para nova  
tentativa.
*/
If !File( cRet )
	cRet := "LGRL"+SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
EndIf

/*
*Se ainda nao encontrar, retira os espacos em branco do codigo
*da empresa e da filial simultaneamente para nova tentativa. 
*/
If !File( cRet )
	cRet := "LGRL" + AllTrim(SM0->M0_CODIGO) + AllTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
EndIf

/*
*Se nao encontrar o arquivo por filial, usa o logo padrao
*/
If !File( cRet )
	cRet := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
EndIf

Return cRet


/* 
* Funcao: XEVMAIL()  | Autor: AOliveira | Data:18-06-2019
* Descri: Tela para envio do E-mail
*/
Static Function XEVMAIL(cArqPdf)
         
Local nOpc := 0
Local cEForn := ""
        
Local X

Private cEDest     := Space(254)
Private cTXTCorp   := ""
Private lCBox      := .T. //TCheckBox 

Private oDlg
Private oGrp
Private oSay1
Private oSay2
Private oEDest
Private oTXTCorp
Private oCBox
Private oBtnConf
Private oBtnCanc        

Private oGrp1
Private oLBoxEmail
Private oBtnTd
Private oBtnInv
      
Private aCompra := {}
Private aHList  := {}   
Private oOk     := LoadBitMap(GetResources(),"LBOK")
Private oNo     := LoadBitMap(GetResources(),"LBNO")    
Private lMarcaItem := .T.

Default cArqPdf :=  "cArqPdf"
                    
If !(Empty(cArqPdf))           
	//
	DbSelectArea("WF7")
	WF7->(DbGoTop())
	While!WF7->(Eof())            
		If !(Alltrim(WF7->WF7_PASTA) $ ('HELP DESK|WORKFLOW|COTACAO|AOLIVEIRASIGASP'))
			AAdd(aCompra,{.F.,;
						  WF7->WF7_REMETE,;
						  WF7->WF7_ENDERE,;
						  WF7->(Recno())})

		EndIf
		WF7->(DbSkip())
	EndDo	
	//Senao tiver Dados lista em Branco 
	If (Len(aCompra) == 0)            
		Aadd(aCompra,{.F.,;
					  '',;
					  '',;
					  0})
	EndIf	

	AAdd( aHList, ' ')
	AAdd( aHList, 'Comprador' )
	AAdd( aHList, 'E-mail' )
	AAdd( aHList, 'Recno')
		
	//

	cEForn := Alltrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_CEMAIL"))
	cEDest := PadR(Alltrim(cEForn) +";",254)                                                                                       
	
	
	//	oDlg       := MSDialog():New( 092,232,348,780,"Envio de Pedido de Compras por E-mail",,,.F.,,,,,,.T.,,,.T. )
	//oGrp       := TGroup():New( 000,004,099,263,"   Dados   ",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	//oSay1      := TSay():New( 010,008,{||"E-mail do Destinatario"},oGrp,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,092,008)
	//oEDest     := TGet():New( 018,008,{|u| If(PCount()>0,cEDest:=u,cEDest)},oGrp,250,008,'',/*bValid*/,CLR_BLACK,CLR_WHITE,,,,.T.,"",,/*bWhen*/,.F.,.F.,,.F.,.F.,"","cEDest",,)
	
	//oSay2      := TSay():New( 032,008,{||"Texto adicional no corpo do E-mail"},oGrp,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,119,008)
	//oTXTCorp   := TMultiGet():New( 040,008,{|u| If(PCount()>0,oTXTCorp:=u,cTXTCorp)},oGrp,250,044,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
	
	//oCBox      := TCheckBox():New( 086,008,"Enviar Somente Texto Padrão",{|u| If(PCount()>0,lCBox:=u,lCBox)},oGrp,094,008,,/*bLClicked*/,,/*bValid*/,CLR_BLACK,CLR_WHITE,,.T.,"",,/*bWhen*/ )
	//oBtnConf   := TButton():New( 102,180,"Confirmar",oDlg,{|| oDlg:End()}/*bAction*/,037,012,,,,.T.,,"",,/*bWhen*/, {|| Iif(VLDEmail(cEDest),nOpc:= 1, ) } /*bValid*/,.F. )
	//oBtnCanc   := TButton():New( 102,225,"Cancelar" ,oDlg,{|| oDlg:End()}/*bAction*/,037,012,,,,.T.,,"",,/*bWhen*/,/*bValid*/,.F. )
	
	oDlg       := MSDialog():New( 089,216,338,925,"Envio de Pedido de Compras por E-mail",,,.F.,,,,,,.T.,,,.T. )
	oGrp       := TGroup():New(  000,004,099,246,"   Dados   ",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	oSay1      := TSay():New( 010,008,{||"E-mail do Destinatario"},oGrp,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,092,008)
	oEDest     := TGet():New( 018,008,{|u| If(PCount()>0,cEDest:=u,cEDest)},oGrp,235,008,'',/*bValid*/,CLR_BLACK,CLR_WHITE,,,,.T.,"",,/*bWhen*/,.F.,.F.,,.F.,.F.,"","cEDest",,)
	
	oSay2      := TSay():New( 032,008,{||"Texto adicional no corpo do E-mail"},oGrp,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,119,008)
	oTXTCorp   := TMultiGet():New( 040,008,{|u| If(PCount()>0,oTXTCorp:=u,cTXTCorp)},oGrp,235,044,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
	
	oCBox      := TCheckBox():New( 086,008,"Enviar Somente Texto Padrão",{|u| If(PCount()>0,lCBox:=u,lCBox)},oGrp,094,008,,/*bLClicked*/,,/*bValid*/,CLR_BLACK,CLR_WHITE,,.T.,"",,/*bWhen*/ )
	oBtnConf   := TButton():New( 102,266,"Confirmar",oDlg,{|| oDlg:End()}/*bAction*/,037,012,,,,.T.,,"",,/*bWhen*/, {|| Iif(VLDEmail(cEDest),nOpc:= 1, ) } /*bValid*/,.F. )
	oBtnCanc   := TButton():New( 102,307,"Cancelar" ,oDlg,{|| oDlg:End()}/*bAction*/,037,012,,,,.T.,,"",,/*bWhen*/,/*bValid*/,.F. )
	                                           
	                                           
	oGrp1      := TGroup():New( 000,248,099,345," E-mail Setor de Compras ",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oLBoxEmail := TListBox():New( 008,252,,{"Marcos","Ana"},089,080,,oGrp1,{||/*bValid*/},CLR_BLACK,CLR_WHITE,.T.,,,,"",,{||/*bWhen*/},,,,, )

	oLBoxEmail := TWBrowse():New(008,252,089,080,,aHList,,oGrp1,,,,,,,,,,,,, "ARRAY", .T. )
	oLBoxEmail:SetArray( aCompra )
	oLBoxEmail:bLine := {|| {	If(aCompra[oLBoxEmail:nAT,1], oOk, oNo),;
							   	   aCompra[oLBoxEmail:nAT,2],;
							       aCompra[oLBoxEmail:nAT,3],;
							       aCompra[oLBoxEmail:nAT,4]}}
	
	oLBoxEmail:bLDblClick := {|| aCompra[oLBoxEmail:nAt,1] := !aCompra[oLBoxEmail:nAt,1], oLBoxEmail:Refresh()}

	oBtnTd     := TButton():New( 089,251,"Selec.Todos",oGrp1,{|| (Aeval(aCompra,{|aElem|aElem[1] := lMarcaItem}), lMarcaItem := !lMarcaItem,,oLBoxEmail:Refresh())  },042,008,,,,.T.,,"",,,,.F. )
	//oBtnInv    := TButton():New( 089,298,"Inverter Selec.",oGrp1, {|| (Aeval(aCompra,{|aElem|aElem[1] := lMarcaItem}), lMarcaItem := !lMarcaItem,,oLBoxEmail:Refresh())  },042,008,,,,.T.,,"",,,,.F. )	
	
	
	oDlg:Activate(,,,.T.)  
	
	If nOpc == 1                                
		_cBody := ""+CRLF
		_cBody += "Prezado Fornecedor"+CRLF+CRLF
		_cBody += "Verificar texto padrao do corpo do email, com o setor de compras."+CRLF
		
		If !(lCBox) 
			cTXTCorp := Iif( valtype(oTXTCorp) == "C" .And. EMpty(cTXTCorp), oTXTCorp, cTXTCorp)		
			cTXTCorp := Alltrim(cTXTCorp)	
		EndIf
        
		cAsEmail := ""
		_codUsr := SC7->C7_USER // RetCodUsr()
		DbSelectArea("SY1")
		SY1->(DbSetOrder(3)) //Y1_FILIAL+Y1_USER
		SY1->(DbGoTop())  
		If SY1->( DbSeek( xFilial("SY1")+_codUsr ) )
			cAsEmail := ""+CRLF
			cAsEmail += "Setor de Suprimentos MLBR." +CRLF
			cAsEmail += "Comprador: "+ Alltrim(SY1->Y1_NOME) + CRLF
			cAsEmail += "Tel: "+ Alltrim(SY1->Y1_TEL) +CRLF
			cAsEmail += "E-mail: "+ Alltrim(SY1->Y1_EMAIL) +CRLF  
			 
			_xcCNOME  := Alltrim(SY1->Y1_NOME)
			_xcCTEL   := Alltrim(SY1->Y1_TEL)
			_xcCEMAIL := Alltrim(SY1->Y1_EMAIL) 
		Else
			cAsEmail := ""+CRLF
			cAsEmail += "Setor de Suprimentos MLBR." +CRLF
			cAsEmail += "Tel: "+ Alltrim(SM0->M0_TEL) +CRLF	
			_xcCNOME  := ""
			_xcCTEL   := ""
			_xcCEMAIL := ""
		EndIf
	    SY1->(DbCloseArea()) 
	    _cBody += ""+CRLF
		_cBody += cAsEmail
         
        _cTo    := cEDest // UsrRetMail(RetCodUsr()) // //cEDest
        _cCC    := _xcCEMAIL //UsrRetMail(RetCodUsr()) //"" 
        _cBCC   := "" 
        _cAnexo := cArqPdf 
        
		//_cSubject:= "["+Alltrim(SM0->M0_NOME)+"] -- Pedido de Compra ("+SC7->C7_FILIAL+SC7->C7_NUM+"), APROVADO"
		_cSubject:= "["+Alltrim(SM0->M0_NOME)+"] -- Pedido de Compra ( "+Alltrim(SC7->C7_NUM)+" ), APROVADO"
		
        _xcKey:= SC7->C7_FILIAL+SC7->C7_NUM  
        
        cTXTCorp:= STRTRAN(cTXTCorp,chr(13)+chr(10),'<br>')
                                                 
        //
        //Trativa para pegar o primeiro email coloca em _cTo e os demais em _cCC //-- 20-08-2019
        //
            
        If !Empty(UsrRetMail(RetCodUsr()))
        	_cCC += ";"+Alltrim(UsrRetMail(RetCodUsr())) //Inclui em copia o email de quem executou a rotina.
        EndIf
        
        aString  := strtokarr(Alltrim(_cTo), ";")
        _cTo_cpy := ""
        _cCC_cpy := "" 

        X:= 0     
        For X:= 1 to Len(aString)
			If X == 1
				_cTo_cpy += aString[X]
			Else                      
				_cCC_cpy += aString[X]+";"
			EndIf
        Next X
        
        if ((At( "@", _cTo_cpy )) <> 0)
        	_cTo := ";"+ _cTo_cpy
        EndIf                        

        if ((At( "@", _cCC_cpy )) <> 0)
        	_cCC += ";"+ _cCC_cpy
        EndIf    
        
        // 
        // 
        _cCC_cpy := ""
        For X:= 1 To Len(aCompra)
        	If aCompra[X][1]
        		_cCC_cpy += Alltrim(lower(aCompra[X][3]))+";"
        	EndIf
        Next X
        //
        //
        if ((At( "@", _cCC_cpy )) <> 0) .And. !Empty(_cCC_cpy)
        	_cCC += ";"+ _cCC_cpy
        EndIf                         
              
	    //MsAguarde({|| VSS_ENVMAIL(_cTo , _cCC, _cBCC, _cAnexo, _cSubject,_cBody, _xcKey, _xcCNOME, _xcCTEL, _xcCEMAIL, cTXTCorp )},"Aguarde","Enviando E-mail...")		
	     
	    //Nova rotina para envio de e-mail (permite que seja enviado e listado os e-mail em copia) // ---- 20-08-2019.
	    MsAguarde({|| ENVEMAIL(_cTo , _cCC, _cBCC, _cAnexo, _cSubject,_cBody, _xcKey, _xcCNOME, _xcCTEL, _xcCEMAIL, cTXTCorp ) },"Aguarde","Enviando E-mail...")
	   
	EndIf
	
	
Else
	Aviso("Atencao","Arquivo PDF, não encontrado!",{"Ok"})	
EndIf

Return()                           


/**/
Static Function VLDEmail(cEDest)
 
Local lRet := .T.
/*
Default cEDest := "" 
If !(IsEmail(cEDest))
	lRet := .F.
	Aviso("Atencao","Informe um E-mail valido!",{"Ok"})
EndIf
*/        
Return(lRet)

/*
* VSS_ENVMAIL
*
*@versao: 1.0
*@autor : AOliveira
*@Data  : 2018-02-06
*@Descr.: Inicia WF de envio de e-mail
*/     
Static Function VSS_ENVMAIL(_cTo , _cCC, _cBCC, _cAnexo, _cSubject,_cBody, _xcKey,_xcCNOME, _xcCTEL, _xcCEMAIL, cTXTCorp )
 
Local nRet := 0
Local oProcess
Local cProcess    
Local cStatus := ""

Default _cTo := ""
Default _cCC := ""
Default _cBCC := ""
Default _cAnexo := ""
Default _cSubject := ""
Default _cBody := ""
Default _xcKey := "" 

Default _xcCNOME  := "" 
Default _xcCTEL   := "" 
Default _xcCEMAIL := "" 
Default cTXTCorp  := ""
       
lCont := .T. 
cWFMLBOX := ""       

DbSelectArea("WF7")
WF7->(DbGoTop())
While!WF7->(Eof()) .And. lCont                 
	If Alltrim(LOWER(WF7->WF7_ENDERE)) == Alltrim(LOWER(_xcCEMAIL))
		lCont := .F.
		cWFMLBOX := Alltrim(WF7->WF7_PASTA)
	EndIf
	WF7->(DbSkip())
EndDo

//SETMV("MV_WFMLBOX","WORKFLOW")
//SETMV("MV_WFMLBOX","AOLIVEIRASIGASP")  //Habilitado somente para teste

If Empty(cWFMLBOX)
	SETMV("MV_WFMLBOX","WORKFLOW")
Else                                     
	SETMV("MV_WFMLBOX",cWFMLBOX)
EndIf

cProcess := OemToAnsi("001001")
//_cProc  := OemToAnsi(cProc)

oProcess:= TWFProcess():New( '001001', _xcKey )
//oProcess:NewTask( cStatus,"\WORKFLOW\HTM\APROVPRC.htm" )
oProcess:NewTask( cStatus,"\WORKFLOW\HTM\emailaprovpc.htm" )
oHtml    := oProcess:oHTML

oHtml:ValByName("ccnome"	, Alltrim(_xcCNOME) )
oHtml:ValByName("cctel"	    , Alltrim(_xcCTEL) )
oHtml:ValByName("ccEmail"	, Alltrim(_xcCEMAIL) )
oHtml:ValByName("cctxtcorp"	, Alltrim(cTXTCorp) )

oProcess:cTo  := _cTo  //Destinatario
oProcess:cCC  := _cCC  //Destinatario em Copia
oProcess:cBCC := _cBCC //Destinatario em Copia oculta

oProcess:AttachFile(_cAnexo) //Caminho e nome do arquivo a ser anexo a mensagem.

oProcess:cSubject := _cSubject //Assunto do email

//oProcess:cBody := _cBody //Corpo do e-mail

oProcess:Start()
oProcess:Finish()
Return(nRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EMAILCOM  ºAutor  ³Microsiga           º Data ³  29/05/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±  
±±º          ³                                                            º±±     
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam.    ³                                                            º±±
±±º          ³ lModoTst : Define de esta ativo modo de TESTE.             º±± 
±±º          ³ cFrom    : Defina email para remetente                     º±± 
±±º          ³ cTo      : Defina email para destinatario                  º±± 
±±º          ³ cCc      : Defina email para copia da mensagem             º±± 
±±º          ³ cBcc     : Defina email para copia oculta                  º±± 
±±º          ³ cSubject : Defina assunto do email                         º±± 
±±º          ³ cBody    : Defina corpo do email                           º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function ENVEMAIL(cTo , cCC, cBCC, cAnexo, cSubject,cBody, xcKey,xcCNOME, xcCTEL, xcCEMAIL, cTXTCorp )
Local cUser := "", cPass := "", cSendSrv := ""
Local cMsg := ""
Local nSendPort := 3, nSendSec := 3, nTimeout := 0
Local xRet
Local oServer, oMessage           

Local _cHTML := RETHTML() //MemoRead( "\WORKFLOW\HTM\emailaprovpc.htm" )

Local lModoTst := .F.
Local cFrom    := " "    // Defina email para remetente

Default cTo      := " "    // Defina email para destinatario
Default cCc      := " "    // Defina email para copia da mensagem
Default cBcc     := " "    // Defina email para copia oculta   
Default cAnexo   := " "    //
Default cSubject := " "    // Defina assunto do email
Default cBody    := " "    // Defina corpo do email 

Default xcKey    := "" 
Default xcCNOME  := "" 
Default xcCTEL   := "" 
Default xcCEMAIL := "" 
Default cTXTCorp  := ""

_cHTML := StrTran( _cHTML, "%ccTXTCorp%"	, Alltrim(cTXTCorp) )
_cHTML := StrTran( _cHTML, "%ccnome%", Alltrim(_xcCNOME) )
_cHTML := StrTran( _cHTML, "%ccEmail%", Alltrim(_xcCEMAIL) )
_cHTML := StrTran( _cHTML, "%cctel%" , Alltrim(_xcCTEL) )
          
cSendSrv := GetMV("MV_RELSERV") //            //  // defina o servidor de envio
cUser    := GetMV("MV_RELACNT") //            //  // defina o nome de usuário da conta de e-mail
cPass    := GetMV("MV_RELPSW")  //                   //  // defina a senha da conta de e-mail

nTimeout := 60                            // defina a temporização para 60 segundos

cFrom := xcCEMAIL //      
cBody := _cHTML
If lModoTst 

	cFrom    := "andre@sigasp.com"

	cTo := cTo //"andre@adeoconsultor.com.br"
	cCc := cCc
	cBCC := " "
	cSubject := "[EMAILCOM] -- TESTE DE ENVIO " 
	cBody    := " TESTE DE ENVIO "+CRLF+CRLF+cBody 
	cFrom    := cUser //"andre@sigasp.com"
	nSendSec := 3
	
//
Else
	lCont := .T. 
	cWFMLBOX := ""       
	
	DbSelectArea("WF7")
	WF7->(DbGoTop())
	While!WF7->(Eof()) .And. lCont                 
		If Alltrim(LOWER(WF7->WF7_ENDERE)) == Alltrim(LOWER(_xcCEMAIL))
			lCont := .F.
			cWFMLBOX := Alltrim(WF7->WF7_PASTA)

			cSendSrv := Alltrim(WF7->WF7_SMTPSR) //GetMV("MV_RELSERV")  // defina o servidor de envio
			cUser    := Alltrim(WF7->WF7_CONTA)  //GetMV("MV_RELACNT")  // defina o nome de usuário da conta de e-mail
			cPass    := Alltrim(WF7->WF7_SENHA)  //GetMV("MV_RELPSW")   // defina a senha da conta de e-mail
            cFrom    := cUser       
			
		EndIf
		WF7->(DbSkip())
	EndDo

EndIf


oServer := TMailManager():New()

oServer:SetUseSSL( .F. )
oServer:SetUseTLS( .F. )

cSendSrv := StrTran( cSendSrv, ":587" , "" )

if nSendSec == 0
	nSendPort := 25 //porta padrão para protocolo SMTP
elseif nSendSec == 1
	nSendPort := 465 //Porta padrão para protocolo SMTP com SSL
	oServer:SetUseSSL( .T. )
else
	nSendPort := 587 //porta padrão para protocolo SMTPS com TLS
	oServer:SetUseTLS( .T. )
endif

// uma vez que apenas enviará mensagens, o servidor receptor será passado como ""
// e o número da porta de recepção não será passado, uma vez que é opcional
xRet := oServer:Init( "", cSendSrv, cUser, cPass, , nSendPort )
if xRet != 0
	cMsg := "01 - Não foi possível inicializar o servidor SMTP: " + CRLF + oServer:GetErrorString( xRet )
	conout( cMsg ) 
	Aviso('Erro', cMsg , {"OK"} )
	return(xRet)
endif

// O método define a temporização para o servidor SMTP
xRet := oServer:SetSMTPTimeout( nTimeout )
if xRet != 0
	cMsg := "02 - Não foi possível configurar " + "cProtocol" + " tempo limite para " + CRLF + cValToChar( nTimeout )
	conout( cMsg )               
	Aviso('Erro', cMsg , {"OK"} )
	return(xRet)
endif

// estabelecer a conexão com o servidor SMTP
xRet := oServer:SMTPConnect()
if xRet <> 0
	cMsg := "03 - Não foi possível conectar no servidor SMTP: " + CRLF + oServer:GetErrorString( xRet )
	conout( cMsg )               
	Aviso('Erro', cMsg , {"OK"} )
	return(xRet)
endif

// autenticar no servidor SMTP (se necessário)
xRet := oServer:SmtpAuth( cUser, cPass )  
cFrom := cUser
if xRet <> 0
	cMsg := "04 - Não foi possível autenticar no servidor *SMTP*: " + CRLF + oServer:GetErrorString( xRet )
	conout( cMsg )               
	Aviso('Erro', cMsg , {"OK"} )
	oServer:SMTPDisconnect()
	return (xRet)
endif

oMessage := TMailMessage():New()
oMessage:Clear()

oMessage:cDate    := cValToChar( Date() )
oMessage:cFrom    := cFrom
oMessage:cTo      := cTo 
     
If !Empty(cCc)
	oMessage:cCC     := cCc  //Envio de Copia
EndIf

If !Empty(cBcc)
	oMessage:cBCC     := cBcc //Envio de Copia Oculta
EndIf

oMessage:cSubject := cSubject
oMessage:cBody    := cBody 

// Adiciona um anexo
if !Empty(cAnexo)
	oMessage:AttachFile( cAnexo )
EndIf

xRet := oMessage:Send( oServer )
if xRet <> 0
	cMsg := "05 - Não foi possível enviar uma mensagem: " + CRLF +oServer:GetErrorString( xRet )
	conout( cMsg )               
	Aviso('Erro', cMsg , {"OK"} )
	return(xRet)
Else   
	cMsg := Time()+" - Email enviado para " + CRLF + cTo  
	Conout( cMsg )               
	//Aviso('Sucesso', cMsg , {"OK"} )
	return(xRet)	
endif

xRet := oServer:SMTPDisconnect()
if xRet <> 0
	cMsg := "06 - Não foi possível desconectar do servidor SMTP: " + CRLF + oServer:GetErrorString( xRet )
	conout( cMsg )               
	Aviso('Erro', cMsg , {"OK"} )
	return(xRet)
endif      

return(xRet )
                     
          
/*Gera arquivo HTML*/
Static Function RETHTML()
Local cRet := ""

///
cRet += " <html>"+CRLF
cRet += " <head> "+CRLF
cRet += '  <meta charset="utf-8"> '+CRLF
cRet += " </head> "+CRLF
cRet += " <body lang=PT-BR link=blue "+'vlink="#954F72" '+"style='tab-interval:35.4pt'> "+CRLF
cRet += "   <div > "+CRLF
cRet += '     <p style = "margin:0cm;margin-bottom:.0001pt;"> '+CRLF
cRet += "       <b> "+CRLF
cRet += "         <i> "+CRLF
cRet += "           <span style='font-size:12.0pt;font-family"+':"Segoe UI",'+"sans-serif;color:gray'> "+CRLF
cRet += "             Prezado Fornecedor "+CRLF
cRet += "           </span> "+CRLF
cRet += "         </i> "+CRLF
cRet += "       </b> "+CRLF
cRet += "     </p> "+CRLF
cRet += "  "+CRLF
cRet += "     <br> "+CRLF
cRet += "  "+CRLF
cRet += "      <!-- Texto adicional--> "+CRLF
cRet += '      <p style = "margin:0cm;margin-bottom:.0001pt;"> '+CRLF
cRet += "        <b> "+CRLF
cRet += "         <span style='"+"'font-size:11.0pt;font-family:"+'"Segoe UI"'+',sans-serif;color:gray;mso-bidi-font-weight:bold;mso-bidi-font-style:italic'+"'> "+CRLF
cRet += "         	%ccTXTCorp%  "+CRLF
cRet += "         </span> "+CRLF
cRet += "       </b> "+CRLF
cRet += "     </p> "+CRLF
cRet += "  "+CRLF
cRet += "     <br><br><br> "+CRLF
cRet += "      "+CRLF
cRet += '     <p style = "margin:0cm;margin-bottom:.0001pt;"> '+CRLF
cRet += "       <b> "+CRLF
cRet += "         <span style='font-size:12.0pt;font-family:"+'"Segoe UI"'+",sans-serif;color:gray;mso-bidi-font-weight:bold;mso-bidi-font-style:italic'> "+CRLF
cRet += "           Observações gerais: "+CRLF
cRet += "         </span> "+CRLF
cRet += "       </b> "+CRLF
cRet += "     </p> "+CRLF
cRet += "  "+CRLF
cRet += "     <ul style='font-size:12.0pt;font-family:"+'"Segoe UI"'+",sans-serif;color:gray;mso-bidi-font-weight:bold;mso-bidi-font-style:italic'> "+CRLF
cRet += "       <li>É obrigatório informar o nº deste PC em sua NFE,</li> "+CRLF
cRet += "       <li>Envio de arquivo XML deve ser enviado para endereço de e-mail , conforme consta em cabeçalho deste PC</li> "+CRLF
cRet += "       <li>Não receberemos material nos dois últimos dias úteis do mês,</li> "+CRLF
cRet += "       <li>Caso a NFE seja constatado qualquer divergência com relação ao PC , a mesma será recusada e com eventuais custos de frete por conta do fornecedor , a qual incluímos neste tópico que entregas parciais devem ser acordadas antes do recebimento.</li> "+CRLF
cRet += "       <li>Horário de recebimento das 07:30 hrs ás 16:30hrs para CNPJ 60.398.914/0009-31</li> "+CRLF
cRet += "       <li>Horário de recebimento das 07:00 hrs ás 15:30hrs para CNPJ 60.398.914/0008-50</li> "+CRLF
cRet += "     </ul> "+CRLF
cRet += "  "+CRLF
cRet += "     <br> "+CRLF
cRet += "  "+CRLF
cRet += '     <p style = "margin:0cm;margin-bottom:.0001pt;"> '+CRLF
cRet += "       <span style='font-size:10.0pt;font-family:"+'"Segoe UI"'+",sans-serif;color:gray;mso-bidi-font-weight:bold;mso-bidi-font-style:italic'> "+CRLF
cRet += "         Setor de Suprimentos <o:p></o:p> "+CRLF
cRet += "       </span> "+CRLF
cRet += "     </p> "+CRLF
cRet += "  "+CRLF
cRet += '     <p style = "margin:0cm;margin-bottom:.0001pt;"> '+CRLF
cRet += "       <b> "+CRLF
cRet += "         <i> "+CRLF
cRet += "           <span style='font-size:10.0pt;font-family:"+'"Segoe UI"'+",sans-serif;color:gray'> "+CRLF
cRet += "             %ccnome% "+CRLF
cRet += "           </span> "+CRLF
cRet += "         </i> "+CRLF
cRet += "       </b> "+CRLF
cRet += "     </p> "+CRLF
cRet += "  "+CRLF
cRet += '     <p style = "margin:0cm;margin-bottom:.0001pt;"> '+CRLF
cRet += "       <b> "+CRLF
cRet += "         <i> "+CRLF
cRet += "           <span style='font-size:9.0pt;mso-ascii-font-family:Calibri;mso-hansi-font-family:Calibri;mso-bidi-font-family:Calibri;color:#1F497D'> "+CRLF
cRet += "             %ccEmail% "+CRLF
cRet += "           </span> "+CRLF
cRet += "         </i> "+CRLF
cRet += "       </b> "+CRLF
cRet += "     </p> "+CRLF
cRet += "  "+CRLF
cRet += '     <p style = "margin:0cm;margin-bottom:.0001pt;"> '+CRLF
cRet += "       <span style='font-size:9.0pt;font-family:"+'"Segoe UI"'+",sans-serif;color:#666666'> "+CRLF
cRet += "         T | +55  %cctel%  "+CRLF
cRet += "       </span> "+CRLF
cRet += "     </p> "+CRLF
cRet += "  "+CRLF
cRet += '     <p style = "margin:0cm;margin-bottom:.0001pt;"> '+CRLF
cRet += "       <b> "+CRLF
cRet += "         <i> "+CRLF
cRet += "           <span style='font-size:10.0pt;font-family:"+'"Segoe UI"'+",sans-serif;color:gray'> "+CRLF
cRet += "             Midori Auto Leather Brasil LTDA "+CRLF
cRet += "           </span> "+CRLF
cRet += "         </i> "+CRLF
cRet += "       </b> "+CRLF
cRet += "     </p> "+CRLF
cRet += "  "+CRLF
cRet += '     <p style = "margin:0cm;margin-bottom:.0001pt;"> '+CRLF
cRet += "       <span style='font-size:9.0pt;mso-ascii-font-family:Calibri;mso-hansi-font-family:Calibri;mso-bidi-font-family:Calibri;color:#1F497D'> "+CRLF
cRet += '         <a href="http://www.midoriautoleather.com.br"> '+CRLF
cRet += "           www.midoriautoleather.com.br "+CRLF
cRet += "         </a> "+CRLF
cRet += "       </span> "+CRLF
cRet += "     </p>     "+CRLF
cRet += "   </div> "+CRLF
cRet += " </body> "+CRLF
cRet += " </html> "+CRLF


Return(cRet)