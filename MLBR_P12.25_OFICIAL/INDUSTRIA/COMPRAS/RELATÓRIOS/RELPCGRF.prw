#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "Report.ch"
#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "RptDef.ch"
#Include "FwPrintSetup.ch"
#Include "TbiConn.ch"
#Include "Font.ch"
#Include 'fileio.ch'

/*
*RELPCGRF
*
*@Autor:  AOliveira
*@Data:   30-08-2019
*@Descri: Geração de Pedido de Compra modo grafico PDF.
          Envio de E-mail do pedido em formato PDF. 
*/
User Function RELPCGRF(_lEnvMail,_cNumPed)

Local aArea			:= GetArea()
Local cDirClient	:= GetTempPath()//GetClientDir()+ "pdf\"
Local cDirServer	:= "\data\pdf\" //GetSrvProfString("RootPath", "\undefined")+ "\data\pdf\" //GetTempPath()//GetClientDir()+ "pdf\"

Local lVisualPDF    := .T.

Private _cAlias		:= GetNextAlias()
Private cFileName	:= ""

Default _lEnvMail := .F. //Se envia PDF por E-mail.

If !empty(_cNumPed)
	cFileName	:= "PC_"+Alltrim(_cNumPed)  
Else 
	cFileName	:= "PC_"+Alltrim(SC7->C7_NUM)  
EndIf

If !ExistDir(cDirClient) //Valida que exista directorio auxiliar para crear PDF
	MakeDir(cDirClient)
EndIf
	
If File(cDirClient + cFileName + ".pdf") //Si existe una version impresa del Comprobante Fiscal, se elimina. (Directorio Auxiliar)
	FErase(cDirClient + cFileName + ".pdf")
Endif                                 

If File(cDirServer + cFileName + ".pdf") //Si existe una version impresa del Comprobante Fiscal, se elimina. (Directorio Auxiliar)
	FErase(cDirServer + cFileName + ".pdf")
Endif


oPrn := FWMsPrinter():New(AllTrim(cFileName) + ".pdf", 6, .T., , .T.)
oPrn:SetResolution(78)
oPrn:SetPortrait()
oPrn:SetPaperSize(DMPAPER_A4)      
oPrn:SetMargin(10,10,10,10)
oPrn:cPathPDF := cDirClient
                                                                     
If _lEnvMail                               
	oPrn:SetViewPDF(.f.) //Define quenao visualiza PDF
Else
	oPrn:SetViewPDF(lVisualPDF) //Define se visualiza PDF?
EndIf
                   
If !empty(_cNumPed)
	//Monta arquivo de trabalho temporário
	MsAguarde({|| MontaQuery(_cNumPed)},"Aguarde","Criando arquivos para impressão...")
Else 
	//Monta arquivo de trabalho temporário
	MsAguarde({|| MontaQuery(SC7->C7_NUM)},"Aguarde","Criando arquivos para impressão...") 
EndIf

//Verifica resultado da query
DbSelectArea(_cAlias)
DbGoTop()
If (_cAlias)->(Eof())
	MsgAlert("Relatório vazio! Verifique os parâmetros.","Atenção")  //"Relatório vazio! Verifique os parâmetros."##"Atenção"
	(_cAlias)->(DbCloseArea())
Else
	Processa({|| Imprime() },"Pedido de Compras ","Imprimindo...") //"Pedido de Compras "##"Imprimindo..." 
	oPrn:Print()
EndIf

If _lEnvMail
	oPrn := Nil                  
	FreeObj(oPrn)  
	
	If File(cDirClient + cFileName + ".pdf")
	   
		If !(CpyT2S( cDirClient + cFileName + ".pdf", cDirServer ))
			MsgAlert("ERRO ao copiar arquivo PDF","Atenção")  
		Else

			If File(cDirServer + cFileName + ".pdf")
				cArqPDF := "\data\pdf\" + cFileName + ".pdf"
				XEVMAIL(cArqPDF,SC7->C7_FILIAL+SC7->C7_NUM) //AOliveira incluido parametro para envio do pedido
			Endif
			
		EndIf
			        
	EndIf
	/*
	If File(cDirClient + cFileName + ".pdf")
		cArqPDF := "\data\pdf\" + cFileName + ".pdf"
		XEVMAIL(cArqPDF)
	Endif
	*/
Endif

oPrn := Nil                  
FreeObj(oPrn)

RestArea(aArea)

Return()

/*
*IMPRIME
*
*@Autor:  AOliveira
*@Data:   13-06-2019
*@Descri: MONTA A PAGINA DE IMPRESSAO
*/
Static Function Imprime()
Local _nCont 	 := 1
Local cPedidoAtu := ""
Local cPedidoAnt := ""
Local aAreaSM0	 := {}	 

Local X,Y 
Local nPulaLin := 35
Private cBitmap	 := ""
     
Private X
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
                        
Private lCouro := .f.

cBitmap := R110ALogo()

//Fontes a serem utilizadas no relatório
Private oFont17N 	:= TFont():New( "Arial",,17,,.T.,,,,,.F.)
Private oFontCOR 	:= TFont():New( "Arial",,10,,.f.,,,,,.f.)
Private oFontITE 	:= TFont():New( "Arial",,10,,.f.,,,,,.f.)
Private oFontCORN 	:= TFont():New( "Arial",,10,,.T.,,,,,.f.)
Private oFontCORI 	:= TFont():New( "Arial",,10,,.f.,,,,,.f.,.T.)
             
Private cGrupo := ""
      
Private _aCol := {	0035,; //Item | 
    	          	0120,; //Codigo | 
				    0240,; //Descricao do Material|     
				    0950,; //Grupo| 
				    1040,; //UM| 
					1110,; //Quantidade| 
					1280,; //Valor Unitario| 
					1470,; //IPI| 
					1560,; //Valor Total| 
					1750,; //Entrega| 
					1910,; //C.C.| 
					2030,; //S.C.| 
					2190,; //C/E|
					2270}  //TES|
		         
//cabecalho da pagina
nLin := Cabec(.t.)

nLin += nPulaLin
		
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
               
aPRSImp := {}

While (_cAlias)->(!Eof())

	cPedidoAtu := (_cAlias)->C7_NUM
	
	cGrupo := (_cAlias)->B1_GRUPO
	//Regra valida somente para couros (grupo 11)
	If cGrupo == '11  ' //Conforme informações derá ser exibido em todos os PC. 10-09-2019.
		 
	    If !(lCouro)
			lCouro := .T.
	    EndIf
		                              
		nTxMoeda   := IIF((_cAlias)->C7_TXMOEDA > 0,(_cAlias)->C7_TXMOEDA,Nil)
		nPiscof := Posicione("SF4",1,space(2)+(_cAlias)->C7_TES,"F4_PISCOF")  
		nPiscred := Posicione("SF4",1,space(2)+(_cAlias)->C7_TES,"F4_PISCRED")
		
		If nPiscof == '3' .And. nPiscred == '1'
			nAlqPiscof	:= 9.25
		Else
			nAlqPiscof := 0
		Endif 
		
		nPrecUn := (( (_cAlias)->C7_TOTAL - (_cAlias)->C7_VALICM) / (_cAlias)->C7_QUANT) - (( (_cAlias)->C7_PRECO * nAlqPiscof) / 100)
		
		If !(_cAlias)->C7_TES == space(3) 
		
			AADD(aPRSImp,{ "Vlr. Unit. sem Impostos do produto " + Alltrim((_cAlias)->C7_PRODUTO) + ": ", ;
			               xMoeda(Round( nPrecUn, 2 ),(_cAlias)->C7_MOEDA,(_cAlias)->C7_MOEDA,(_cAlias)->C7_DATPRF,3,nTxMoeda) })
		Else
	   		//AADD(aPRSImp,{ "Necessário informar TES para calcular valor s/ imposto.", ;
			//               0 })
		Endif		
			
	EndIf	                   
	       
	If _nCont >= 19 .Or. cPedidoAtu <> cPedidoAnt // Quebra paginas por qtde itens
		
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
		nLin := Cabec(.t.)
		nLin += nPulaLin
	EndIf
	    
	/*
	_cItens := ""	
    _cItens += Alltrim((_cAlias)->C7_ITEM) +" | "	                                        //Item //Item | 
    _cItens += Alltrim((_cAlias)->C7_PRODUTO) +" | "						    //codigo//Codigo | 
    _cItens += Substr((_cAlias)->B1_DESC,1,70) +" | "							    //descricao //Descricao do Material|     
    _cItens += Alltrim( (_cAlias)->B1_GRUPO )  +" | "                             //Grupo| 
    _cItens += Alltrim( (_cAlias)->C7_UM ) +" | "									//unidade de medida //UM| 
	_cItens += Alltrim( Transform((_cAlias)->C7_QUANT,"@R 999,999.9999") ) +" | "	//Quantidade //Quantidade| 
	_cItens += Alltrim( Transform((_cAlias)->C7_PRECO,"@R 999,999,999.99") ) +" | "	//VLR UNIT //Valor Unitario| 
	_cItens += Alltrim( Transform((_cAlias)->C7_IPI,"@R 999.99") ) +" | "			//IPI //IPI| 
	_cItens += Alltrim( Transform((_cAlias)->C7_TOTAL,"@R 999,999,999.99") ) +" | "	//VLR TOT //Valor Total| 
	_cItens += DTOC((_cAlias)->C7_DATPRF) +" | "							    //data de entrega //Entrega| 
	_cItens += (_cAlias)->C7_CC  +" | "                                           //C.C.| 
	_cItens += Alltrim( ( _cAlias)->C7_NUMSC )  +" | "                             //S.C.| 
	_cItens += Alltrim( (_cAlias)->CCE )  +" | "                                   //C/E|
	_cItens += (_cAlias)->C7_TES   	
	                
	oPrn:SayAlign( nLin,0035, _cItens  ,oFontCOR, (2375 - 0035 ),200 , , 0, 1 )
	*/

	_aItens := {}	

/*
//Alltrim( Transform((_cAlias)->C7_PRECO,x3Picture("C7_PRECO") ) ) ,;	 //VLR UNIT //Valor Unitario com 6 digitos decimal  
Alltrim( Transform((_cAlias)->C7_TOTAL,x3Picture("C7_TOTAL") ) ) ,;	 //VLR TOT //Valor Total com 6 digitos decimal
*/    
    
    AADD(_aItens, { Alltrim((_cAlias)->C7_ITEM) ,;	                                     //Item //Item | 
					Alltrim((_cAlias)->C7_PRODUTO) ,;						             //codigo//Codigo | 
					Substr((_cAlias)->B1_DESC,1,39) ,;							         //descricao //Descricao do Material|     
					Alltrim( (_cAlias)->B1_GRUPO )  ,;                                   //Grupo| 
					Alltrim( (_cAlias)->C7_UM ) ,;								         //unidade de medida //UM| 
					Alltrim( Transform((_cAlias)->C7_QUANT,x3Picture("C7_QUANT") ) ) ,;	 //Quantidade //Quantidade| 
					Alltrim( Transform((_cAlias)->C7_PRECO, x3Picture("C7_PRECO") ) ) ,;	 //VLR UNIT //Valor Unitario| 
					Alltrim( Transform((_cAlias)->C7_IPI,x3Picture("C7_IPI") ) ) ,;		 //IPI //IPI| 
 					Alltrim( Transform((_cAlias)->C7_TOTAL,x3Picture("C7_TOTAL") ) ) ,;	 //VLR TOT //Valor Total|
					DTOC((_cAlias)->C7_DATPRF) ,;							             //data de entrega //Entrega| 
					(_cAlias)->C7_CC  ,;                                                 //C.C.| 
					Alltrim( ( _cAlias)->C7_NUMSC ) ,;                                   //S.C.| 
					Alltrim( (_cAlias)->CCE ) ,;                                         //C/E|
					(_cAlias)->C7_TES })  
                       
	If (Len( (_cAlias)->B1_DESC ) > 39)  
	    AADD(_aItens, { "" ,;	                             // Item //Item | 
						"" ,;						         //codigo//Codigo | 
						Substr((_cAlias)->B1_DESC,40,70) ,;	 //descricao //Descricao do Material|     
						"" ,;                                //Grupo| 
						"" ,;								 //unidade de medida //UM| 
						"" ,;	                             //Quantidade //Quantidade| 
						"" ,;	                             //VLR UNIT //Valor Unitario| 
						"" ,;			                     //IPI //IPI| 
						"" ,;	                             //VLR TOT //Valor Total| 
						"" ,;							     //data de entrega //Entrega| 
						"" ,;                                //C.C.| 
						"" ,;                                //S.C.| 
						"" ,;                                //C/E|
						"" })  	
	EndIf                                         
      
	For X:= 1 To Len(_aItens)
	    _aAux := _aItens[X]               
	    If X == 2
	    	nLin += nPulaLin
	    EndIf
		For Y:= 1 To Len(_aAux)           
			oPrn:say(nLin,_aCol[Y],_aAux[Y] ,oFontITE)		
		Next Y
	Next X

	/*
    oPrn:SayAlign( nLin, _aCol[02], Substr((_cAlias)->C7_PRODUTO,1,25), oFontCOR, (_aCol[03] - _aCol[02] ),100 , , 0, 1 )
    oPrn:SayAlign( nLin, _aCol[03], Substr((_cAlias)->B1_DESC,1,70), oFontCOR, (_aCol[04] - _aCol[03] ),100 , , 0, 1 )
    oPrn:SayAlign( nLin, _aCol[04], Alltrim( (_cAlias)->B1_GRUPO ), oFontCOR, (_aCol[05] - _aCol[04] ),100 , , 0, 1 )
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
	
	nLin += nPulaLin   //pula linha
	
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

Return()

/*
*CABEC
*
*@Autor:  AOliveira
*@Data:   13-06-2019
*@Descri: Imprimir Cabecalho do pedido
*/
Static Function  Cabec(_lCabec)

Local nPulaLin := 35
Local aCaolCab := {0035,;
                   1170,;
                   1220}     

Private oFontCAB  := TFont():New( "Arial",,10,,.f.,,,,,.f.)
Private oFontCABI := TFont():New( "Arial",,10,,.f.,,,,,.f.,.T.)                                                                 
Private oFontCOR  := TFont():New( "Arial",,10,,.f.,,,,,.f.)
Private oFontCORN := TFont():New( "Arial",,10,,.T.,,,,,.f.)
Private oFontCORI := TFont():New( "Arial",,10,,.f.,,,,,.f.,.T.)

oPrn:StartPage()	//Inicia uma nova pagina

_cFileLogo	:= GetSrvProfString('Startpath','') + cBitmap

oPrn:SayBitmap(0045,0060,_cFileLogo,0239,0100)
            
nLin:= 50 // 70
oPrn:SayAlign( nLin,0035,"PEDIDO DE COMPRA:"+ " " +Alltrim((_cAlias)->C7_NUM),oFont17N, (2375 - 0035 ),200 , , 2, 1 )
oPrn:SayAlign( nLin,0035,"EMISSÃO:"+ " " + dtoc((_cAlias)->C7_EMISSAO),oFontCAB, (2375 - 0035 ),200 , , 1, 1 )

/*cabecalho*/
// Primeira coluna do cabecalho
nLin := 205 //225
oPrn:say (nLin,aCaolCab[1], SM0->M0_NOMECOM ,oFontCAB)
nLin += nPulaLin
oPrn:say (nLin,aCaolCab[1],"CNPJ:"+" "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+"  -  "+"I.E:"+" "+Alltrim(SM0->M0_INSC) ,oFontCAB)  //"CNPJ:"##"I.E:"
nLin += nPulaLin
oPrn:say (nLin,aCaolCab[1],Alltrim(SM0->M0_ENDCOB))//+" - "+Alltrim(SM0->M0_CIDCOB)+" /"+Alltrim(SM0->M0_ESTCOB)+"  "+"CEP:"+" "+(SM0->M0_CEPENT),oFontCAB) //"CEP:"
nLin += nPulaLin 
oPrn:say (nLin,0035,Alltrim(SM0->M0_BAIRCOB) + ' - ' + Alltrim(SM0->M0_CIDCOB)+" /"+Alltrim(SM0->M0_ESTCOB)+"  "+"CEP:"+" "+(SM0->M0_CEPENT),oFontCAB) //"CEP:"
nLin += nPulaLin
oPrn:say (nLin,aCaolCab[1],"TEL.:"+" "+Alltrim(SM0->M0_TEL)+"  -  "+"FAX:"+" "+Alltrim(SM0->M0_FAX) ,oFontCAB) //"TEL.:"##"FAX:"
nLin += nPulaLin
oPrn:say (nLin,aCaolCab[1],"NFE.:"+" "+LOWER(Alltrim(SM0->M0_DSCCNA)) ,oFontCAB)

// Segunda coluna do cabecalho (FORNECEDOR)
nLin := 205 //180
oPrn:say (nLin,aCaolCab[3],"FORNECEDOR",oFontCABI)  //"Fornecedor"
nLin += nPulaLin
oPrn:say (nLin,aCaolCab[3],(_cAlias)->A2_COD +"-"+(_cAlias)->A2_LOJA +" - "+ (_cAlias)->A2_NOME , oFontCAB)
nLin += nPulaLin
oPrn:say (nLin,aCaolCab[3],"CNPJ: "+Transform((_cAlias)->A2_CGC,"@R 99.999.999/9999-99")+"  -  I.E: "+Transform((_cAlias)->A2_INSCR,"@R 999.999.999.999"), oFontCAB) //"CNPJ:"
nLin += nPulaLin
oPrn:say (nLin,aCaolCab[3],Alltrim((_cAlias)->A2_END)+"  "+(_cAlias)->A2_BAIRRO, oFontCAB) //"End:" 
nLin += nPulaLin
oPrn:say (nLin,aCaolCab[3],Alltrim((_cAlias)->A2_MUN)+" / "+(_cAlias)->A2_EST+"  CEP: "+Transform((_cAlias)->A2_CEP,"@R 99.999-999"),oFontCAB)
nLin += nPulaLin
oPrn:say (nLin,aCaolCab[3],"TEL.: ("+Alltrim((_cAlias)->A2_DDD)+") "+Transform((_cAlias)->A2_TEL,"@R 9999-9999") + "  -  FAX: ("+Alltrim((_cAlias)->A2_DDD)+") "+Transform((_cAlias)->A2_FAX,"@R 9999-9999"), oFontCAB) //"TEL.:"
nLin += nPulaLin

oPrn:line(180,aCaolCab[2],nLin,aCaolCab[2]) 	//Linha Vertical Cabecalho
oPrn:line(nLin,0035,nLin,2375)                 //Linha Horizontal Cabecalho Itens Superior

nLin += nPulaLin	
//nLin := 485//450
oPrn:say (nLin,_aCol[01],"ITEM",oFontCORI)                  //|Item| 
oPrn:say (nLin,_aCol[02],"COD.",oFontCORI)                  //Codigo| 
oPrn:say (nLin,_aCol[03],"DESCRICAO DO MATERIAL",oFontCORI) //Descricao do Material|
oPrn:say (nLin,_aCol[04],"GRP",oFontCORI)                   //Grupo| 
oPrn:say (nLin,_aCol[05],"UM",oFontCORI)                    //UM| 
oPrn:say (nLin,_aCol[06],"QTDE",oFontCORI)                  //Quantidade| 
oPrn:say (nLin,_aCol[07],"VLR UNIT",oFontCORI)              //Valor Unitario| 
oPrn:say (nLin,_aCol[08],"IPI",oFontCORI)                   //IPI| 
oPrn:say (nLin,_aCol[09],"VLR TOTAL",oFontCORI)             //Valor Total| 
oPrn:say (nLin,_aCol[10],"ENTREGA",oFontCORI)               //Entrega| 
oPrn:say (nLin,_aCol[11],"C.C",oFontCORI)                   //C.C. |
oPrn:say (nLin,_aCol[12],"S.C",oFontCORI)                   //S.C. | 
oPrn:say (nLin,_aCol[13],"C/E",oFontCORI)                   //C/E|
oPrn:say (nLin,_aCol[14],"TES",oFontCORI)                   //TES|

nLin += nPulaLin

oPrn:line(nLin,0035,nLin,2375)    //Linha Horizontal Cabecalho de Itens Inferior 

return(nLin)

/*
*RODAP
*
*@Autor:  AOliveira
*@Data:   13-06-2019
*@Descri: Imprimir Rodape do pedido
*/
Static Function Rodap()                                

Local x    
Local aTextPad := {}

Local nPulLin := 30

Private oFontROD  := TFont():New( "Arial",,10,,.f.,,,,,.f.)
Private oFontRODN := TFont():New( "Arial",,10,,.T.,,,,,.f.)
Private oFontRODI := TFont():New( "Arial",,10,,.f.,,,,,.f.,.T.)

Private oFontTEXT := TFont():New( "Arial",,10,,.f.,,,,,.f.,.T.)
              
Private cComprador := ""

AADD(aTextPad,{"A Nota Fiscal deverá constar o número do(s) Pedido de Compra(s) e Nome do solicitante Midori."})
AADD(aTextPad,{"Produtos Químicos deverão estar acompanhados de seus respectivos certificados de análises e FISPQ."})
AADD(aTextPad,{"Produtos Automotivos deverão estar acompanhados de seus respectivos CQ's em conformidade com PPAP aprovados em último nível."})
AADD(aTextPad,{"Os demais quesitos devem estar em conformidade com o nosso Manual de Fornecedores."})
AADD(aTextPad,{"Não serão recebidos mercadorias ou notas fiscais nos 02 (dois) últimos dias do mês."})
AADD(aTextPad,{"Não serão aceitas Notas Fiscais com valores e quantidades divergentes, e os devidos impostos vigentes."})
AADD(aTextPad,{"Serão informados os prazos de entrega e detalhes da transportadora para Pedidos de compra com frete FOB;"})
AADD(aTextPad,{"Entregas parciais deverão estar acordadas com o Planejamentos e controle de produção (PCP) ou Suprimentos;"})
AADD(aTextPad,{"Conformar o recebimento do(s) pedido(s) e a precisão de entrega via e-mail;"})

nLin := 2100 //1900 //1930 //1905
                            
If lCouro
	//Valores unit. sem impostos
	If Len(aPRSImp) > 0
		nLin -= nPulLin
	    For X:=1 to Len(aPRSImp)                             
			oPrn:say(nLin,1420, Alltrim(Upper(aPRSImp[X][1])) + Transform(aPRSImp[X][2],"@E 999,999,999.99"),oFontROD) 
			nLin -= nPulLin
		Next X      
	EndIf                          
EndIf

nLin := 2100 //1900 //1930 //1905
oPrn:line(nLin,0035,nLin,2375)    //Linha Horizontal Inicial do Rodape Inferior
nLin += nPulLin
_nTot := (_nTot + _nValIcmR + _nValIpi + _nDespesa + _nSeguro + _nFrete - _nDescPed)

cTotal := ""

cTotal += "Desc: "+ Alltrim(Transform(_nDesc1,"@E 999.99"))+"%  "+Alltrim(Transform(_nDesc2,"@E 999.99"))+"%  "+Alltrim(Transform(_nDesc3,"@E 999.99"))+"%    "+Alltrim(Transform(_nDescPed, "@E 999,999,999.99"))
cTotal += "  |  ICMS: "+ Alltrim(Transform(_nValIcm,"@E 999,999,999.99"))
cTotal += "  |  IPI:  "+ Alltrim(Transform(_nValIpi,"@E 999,999,999.99"))
cTotal += "  |  Despesas: "+ Alltrim(Transform(_nDespesa,"@E 99,999,999.99"))
cTotal += "  |  Seguro: "+ Alltrim(Transform(_nSeguro,"@E 99,999,999.99"))
cTotal += "  |  Vlr Frete:"+ Alltrim(Transform(_nFrete,"@E 999,999,999.99"))

oPrn:say(nLin,0035, cTotal ,oFontRODI) 

oPrn:say(nLin,1900,"  |  Valor Total: "+Transform(_nTot,"@E 999,999,999.99"),oFontRODN) 	//"Valor Total:"
                   
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

cAprov  := ""              
lLiber  := .F.
lNewAlc := .F.

dbSelectArea("SC7")
If !Empty(SC7->C7_APROV)
	lNewAlc := .T.
	cComprador := UsrFullName(SC7->C7_USER)
	If SC7->C7_CONAPRO != "B"
		lLiber := .T.
	EndIf
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

nLin += nPulLin 
oPrn:line(nLin,0035,nLin,2375)    //Linha Horizontal Rodape Inferior

nLinIni :=   nLin       

nLin += nPulLin 

nTamTex := 0
nPosTex := 0
nWidht  := 0
nWidSom := 5

aTexTit := {}  

AADD(aTexTit,"FRETE:")
AADD(aTexTit,"COND. PAGT :")
AADD(aTexTit,"COMPRADOR RESP:")
AADD(aTexTit,"APROVADOR(es) :")
AADD(aTexTit,"LOCAL DE ENTREGA:")
AADD(aTexTit,"LOCAL DE COBRANÇA:")

For X:=1 to Len(aTexTit)
	If nTamTex < Len(aTexTit[X])
		nTamTex := Len(aTexTit[X]) 
		nPosTex := X
	EndIf
Next X              

nWidht := oPrn:GetTextWidth(aTexTit[nPosTex], oFontRODN)                          

oPrn:say(nLin,0035,"COND. PAGT :",oFontRODN)
SE4->(dbSetOrder(1))
SE4->(dbSeek(xFilial("SE4")+SC7->C7_COND)) 
oPrn:say(nLin,(nWidht + nWidSom),SubStr(SE4->E4_COND,1,40) ,oFontROD)      

nLin := InsOBS(nLin,lLiber)//Imprimir observações.

nLin += nPulLin        

oPrn:say(nLin,0035,"FRETE:",oFontRODN)   
oPrn:say(nLin,(nWidht + nWidSom), cTPFrete ,oFontROD)
nLin += nPulLin 

oPrn:say(nLin,0035,"COMPRADOR RESP:",oFontRODN) 
oPrn:say(nLin,(nWidht + nWidSom),Alltrim(UsrFullName(SC7->C7_USER)) ,oFontROD)
nLin += nPulLin  

oPrn:say(nLin,0035,"APROVADOR(es) :",oFontRODN)
oPrn:say(nLin,(nWidht + nWidSom),cAprov ,oFontROD)
nLin += nPulLin   
                 
/*
oPrn:say(nLin,0035,"LOCAL DE ENTREGA:",oFontRODN)                 
oPrn:say(nLin,(nWidht + nWidSom),Alltrim(_cEndEnt) +" - "+Alltrim(_cBairEnt) ,oFontROD)
nLin += nPulLin   
oPrn:say(nLin,(nWidht + nWidSom),Alltrim(_cCidEnt)+ " - " +Alltrim(_cEstEnt),oFontROD)
nLin += nPulLin      
*/
 
oPrn:say(nLin,0035,"LOCAL DE ENTREGA:",oFontRODN)                 
oPrn:say(nLin,(nWidht + nWidSom),Alltrim(_cEndEnt) ,oFontROD)
nLin += nPulLin   
oPrn:say(nLin,(nWidht + nWidSom),Alltrim(_cBairEnt) + " - " + Alltrim(_cCidEnt)+ " - " +Alltrim(_cEstEnt),oFontROD)
nLin += nPulLin  

/*
oPrn:say(nLin,0035,"LOCAL DE COBRANÇA:",oFontRODN)
oPrn:say(nLin,(nWidht + nWidSom),Alltrim(_cEndCob) +" - "+Alltrim(_cBairCob) ,oFontROD)  
nLin += nPulLin
oPrn:say(nLin,(nWidht + nWidSom),Alltrim(_cCidCob)+ " - " +Alltrim(_cEstCob),oFontROD)  
nLin += nPulLin
*/

oPrn:say(nLin,0035,"LOCAL DE COBRANÇA:",oFontRODN)
oPrn:say(nLin,(nWidht + nWidSom),Alltrim(_cEndCob) ,oFontROD)  
nLin += nPulLin
oPrn:say(nLin,(nWidht + nWidSom),Alltrim(_cBairCob) + " - " + Alltrim(_cCidCob)+ " - " +Alltrim(_cEstCob),oFontROD)  
nLin += nPulLin
 
nLin += 20 

oPrn:line(nLin,0035,nLin,2375)      //Linha Horizontal Rodape Inferior
oPrn:line(nLinIni,1420,nLin,1420) 	//Linha Vertical Rodape

nLin += nPulLin 
for x:= 1 to Len(aTextPad)
	oPrn:say(nLin,0035, aTextPad[x][1] ,oFontTEXT) //Texto Padrão de observação
	nLin += nPulLin
Next x
nLin += nPulLin            
nLin += nPulLin

oPrn:SayAlign( nLin,0035,"Pagina  " +Transform(_nPag,"@R 999"),oFontRODN, (2375 - 0035 ),200 , , 2, 0 )

oPrn:EndPage()

Return      

/*
*InsOBS
*
*@Autor : AOliveira
*@Data:   13-06-2019
*@Descri: Imprimir Observacoes do pedido
*/
Static Function InsOBS(_LinAtu,lLiber)
Local X
Local _nLin01 := 0
Local _cObs   := ""
Local _aObs   := {}

Default _LinAtu := 0 
Default lLiber := .F.
 
_nLin01 := _LinAtu

oPrn:say(_nLin01,1450,"OBSERVACOES:",oFontRODN)
_nLin01 += 30
     
If (!Empty(SC7->C7_OBS) .Or. Alltrim(SC7->C7_OBS) <> '...')
                  
	_cObs := Alltrim(SC7->C7_OBS)
    For X:= 1 to 4
		AADD(_aObs,Substr(_cObs,1,50))
		_cObs := Alltrim( SubStr(_cObs,51,Len(_cObs)) )
    Next X  
    
    For X := 1 to Len(_aObs)
    	oPrn:say(_nLin01,1450,_aObs[X],oFontROD)	
		_nLin01 += 30    	
    Next X                                     

EndIf   
               
oPrn:line(_nLin01,1420,_nLin01,2375)    //Linha Horizontal Rodape Inferior
_nLin01 += 30
//oPrn:say(_nLin01,1450,IF(lLiber,"P E D I D O   L I B E R A D O","P E D I D O   B L O Q U E A D O !!!") ,oFontRODN)  

oPrn:SayAlign( _nLin01,1450,IF(lLiber,"P E D I D O   L I B E R A D O","P E D I D O   B L O Q U E A D O !!!"),oFontRODN, (2375 - 1450 ),200 , , 2, 0 )
 
Return(_LinAtu)

/*
* MONTAQUERY
*
*@Autor:  AOliveira 
*@Data:   13-06-2019
*@Descri: QUERY
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
cQuery += " SA2.A2_COD, SA2.A2_NOME, SA2.A2_LOJA,SA2.A2_END, SA2.A2_BAIRRO, SA2.A2_EST, SA2.A2_MUN, SA2.A2_CEP,"
cQuery += " SA2.A2_CGC, SA2.A2_INSCR, SA2.A2_TEL, SA2.A2_FAX, SA2.A2_DDD, SA5.A5_CODPRF, SB1.B1_DESC, SB1.B1_GRUPO, C7_TES, C7_OBS, C7_MOEDA, C7_TXMOEDA, "
cQuery += " ISNULL((SELECT DISTINCT C1_X_MOTIV "
cQuery += "         FROM "+RetSQLName("SC1")+" SC1 " 
cQuery += "         WHERE SC1.C1_FILIAL = '"+xFilial("SC1")+"' "
cQuery += "         AND SC1.C1_PRODUTO = SC7.C7_PRODUTO "
cQuery += "         AND SC1.C1_NUM = SC7.C7_NUMSC  "
cQuery += "         AND SC1.D_E_L_E_T_ = ''),'') AS CCE "
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
*R110ALogo 
*
*@Autor:  AOliveira 
*@Data:   13-06-2019
*@Descri: Retorna string com o nome do arquivo bitmap de logotipo
*/
Static Function R110ALogo()

Local cRet := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial

If !File( cRet )
	cRet := "LGRL" + AllTrim(SM0->M0_CODIGO) + SM0->M0_CODFIL+".BMP" // Empresa+Filial
EndIf

If !File( cRet )
	cRet := "LGRL"+SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
EndIf

If !File( cRet )
	cRet := "LGRL" + AllTrim(SM0->M0_CODIGO) + AllTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
EndIf

If !File( cRet )
	cRet := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
EndIf

Return cRet

/* 
*XEVMAIL
*  
*@Autor:  AOliveira 
*@Data:   18-06-2019
*@Descri: Tela para envio do E-mail
*/            
Static Function XEVMAIL(cArqPdf,cPedCom)
         
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
      
Private aCompra := {}
Private aHList  := {}   
Private oOk     := LoadBitMap(GetResources(),"LBOK")
Private oNo     := LoadBitMap(GetResources(),"LBNO")    
Private lMarcaItem := .T.

Default cArqPdf := "cArqPdf"    
Default cPedCom := ""
                    
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
        _cCC_cpy := ""
        For X:= 1 To Len(aCompra)
        	If aCompra[X][1]
        		_cCC_cpy += Alltrim(lower(aCompra[X][3]))+";"
        	EndIf
        Next X
        //
        if ((At( "@", _cCC_cpy )) <> 0) .And. !Empty(_cCC_cpy)
        	_cCC += ";"+ _cCC_cpy
        EndIf                         
              
	    //Nova rotina para envio de e-mail (permite que seja enviado e listado os e-mail em copia) // ---- 20-08-2019.
	    MsAguarde({|| ENVEMAIL(_cTo , _cCC, _cBCC, _cAnexo, _cSubject,_cBody, _xcKey, _xcCNOME, _xcCTEL, _xcCEMAIL, cTXTCorp, cPedCom ) },"Aguarde","Enviando E-mail...")
	   
	EndIf
	
Else
	Aviso("Atencao","Arquivo PDF, não encontrado!",{"Ok"})	
EndIf

Return()                           


/*
* VLDEMAIL
*
*@versao: 1.0
*@autor : AOliveira
*@Descr.: VALIDA EMAIL.
*/
Static Function VLDEMAIL(cEDest)
 
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
* ENVEMAIL
*
*@versao: 1.0
*@autor : AOliveira
*@Data  : 2019-09-10
*@Descr.: Inicia envio de e-mail
*/
Static function ENVEMAIL(cTo , cCC, cBCC, cAnexo, cSubject,cBody, xcKey,xcCNOME, xcCTEL, xcCEMAIL, cTXTCorp , cPedCom)
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
Default cTXTCorp := "" 
Default cPedCom  := ""

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
           
//retirar depois dos testes
//	cTo := ""
//	cCc := " "
//	cBCC := " "

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
	MsgAlert ( Time()+" - Email enviado para " + CRLF + cTo ) 
	Conout( cMsg )               
	//Aviso('Sucesso', cMsg , {"OK"} )
	If !Empty(cPedCom)
		LOGSEND(cPedCom) // realiza a gravação do log de envio.
	EndIf	
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
                     
/*
* RETHTML
*
*@versao: 1.0
*@autor : AOliveira
*@Descr.: Gera arquivo HTML
*/
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
        
/*
* Funcao: LOGSEND() / AOliveira - 14-11-2019
* Descri: Gravação de log de envio de e-mail.
*/
Static Function LOGSEND(cPedCom)

Local aAreaSC7 := SC7->(GetArea())

Default cPedCom := ""

If !(Empty(cPedCom))

	If ( (SC7->(FieldPos("C7_XEEMAIL")) > 0 ) .And. (SC7->(FieldPos("C7_XHEMAIL")) > 0 ) )

		DbSelectArea("SC7")
		SC7->(DbSetOrder(1))
		SC7->(DbGoTop())
		SC7->(DbSeek(cPedCom))
		While !SC7->(Eof()) .And. SC7->C7_FILIAL+SC7->C7_NUM == cPedCom	
			
			DbSelectArea("SC7")
			RecLock("SC7", .F.)
			SC7->C7_XEEMAIL := "S" 
			SC7->C7_XHEMAIL := SC7->C7_XHEMAIL+CRLF+CRLF+ "********" +CRLF+ "Envio realizado em "+ DToC(dDataBase) +" as " +Alltrim(Time())
			SC7->(MSUnlock())
			
			SC7->(DbSkip())
			
		EndDo	
		
	EndIf
	
EndIf

RestArea(aAreaSC7)

Return()