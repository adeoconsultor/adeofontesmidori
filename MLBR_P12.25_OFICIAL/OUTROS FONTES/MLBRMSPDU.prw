#include 'protheus.ch'
#include 'parmtype.ch'

#define ET_CAMPO     1
#define ET_PICTURE   2
#define ET_TAMANHO   3
#define ET_DECIMAL   4  
#define ET_TIPO      5
#define ET_CONTEST   6

//==========================================================================================
// MLBRMPSDU - Antonio C. Damaceno - Advpl Tecnologia - Maio / 2017
//------------------------------------------------------------------------------------------
// Descrição
// Uso da mygrid() para cadastro de usuários que podem acessar e alterar determinadas 
// tabelas de acordo com permissão e cadastro
//------------------------------------------------------------------------------------------
// Parametros
// nenhum
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
/*
Criar a tabela ZZU
Campos
ZZU_USUARIO C 6    EX.: 001010
ZZU_TABELA  C 20   EX.: SE1,SE2,SE5,SFT,SF1,SF2,SD1,SD2,CB0

Criar Parametros de acordo com o nome das tabelas:
Exemplo do Parametro para Tabela SFT:
Var:           MA_ZZUSFT 
Tipo:          C
Conteudo:      FT_EMISSAO,FT_NFISCAL,FT_SERIE,FT_CLIEFOR,FT_LOJA
Descrição:     Campos da tabela a serem alterados pela mygrid

*/

User Function MLBRMPSDU()

Local cTabela := Space(03)
Local oTabela

Private oDlg
Private nOpc
Private cPerg

//Monta interface com o usuário
DEFINE MSDIALOG oDlg TITLE "Alterações na Tabela" FROM C(164),C(182) TO C(325),C(409) PIXEL

// Cria as Groups do Sistema
@ C(003),C(003) TO C(102),C(260) LABEL "Informe a Tabela" PIXEL OF oDlg

// Cria Componentes Padroes do Sistema
@ C(013),C(008) Say "Tabela:" Size C(038),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(013),C(030) MsGet oTabela Var cTabela Size C(041),C(009) COLOR CLR_BLACK Picture "@!" Valid(FS_TabUsu(cTabela)) PIXEL OF oDlg

DEFINE SBUTTON FROM C(028),C(046) TYPE 1 ENABLE OF oDlg ACTION {||nOpc := 1,oDlg:End()}

ACTIVATE MSDIALOG oDlg CENTERED

If nOpc == 1
	Processa({|| MDMG001A(cTabela)})
Else
	Alert("Processamento cancelado pelo usuário")
EndIf
Return(.T.)
  

//Validar se usuário tem acesso para alterar a tabela informada
//Antonio - 31/05/17
Static Function FS_TABUSU(cTabela)
	Local lRet:=.T.
	Local cUsuario:=RetCodUsr()

	dbSelectArea("ZZU")
	dbSetOrder(1)
	If dbSeek(xFilial("ZZU")+cUsuario)
		If cTabela $ ZZU->ZZU_TABELA 
			lRet:=.T.
		Else
			MsgAlert("Usuário não tem acesso para alterar esta Tabela:" + cTabela) 
			lRet:=.F.
		EndIf
	Else
		MsgAlert("Usuário não cadastrado!!!" + cUsuario) 
		lRet:=.F.
	EndIf

Return(lRet)


///execução da rotina
Static Function MDMG001A(cTabela)

//PARAM SX6: MA_SD1 := D1_DOC;D1_SERIE,D1_FORNECE,D1_EMISSAO
//cTabela := MV_PAR02 (tabela que o usuário digita na primeira tela de parametros) Ex. SD1,SE2,SFT
//aCampos := supergetmv("MA_ZZU"+cTabela) (carrega campos de forma dinamica conforme tabela digitada pelo usuário)

	Local oPerg
	Local aZHeader := {}
	Local aCampos  := {}
	Local aRet     := {}
	Local nPos, nITab, nI, nLoop := 0

	Private cSql   := ""
	Private oDlg
	Private oGrdMGU
	Private cPerg  := "MDMG"+cTabela
	Private aHead  := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aHeader                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)                                                                             
	If dbSeek(cTabela)
		While ( !Eof() .And. (SX3->X3_ARQUIVO == cTabela) )
		
			/* Comentado no If, nao carregava campos do Browser
			 */
			If ( /* X3USO(SX3->X3_USADO) .And.*/ cNivel >= SX3->X3_NIVEL .And. SX3->X3_CONTEXT <> 'V')
				
				Aadd(aZHeader,{ TRIM(X3Titulo()),;  //1
					SX3->X3_CAMPO,;       //2
					SX3->X3_PICTURE,;     //3
					SX3->X3_TAMANHO,;     //4
					SX3->X3_DECIMAL,;     //5
					SX3->X3_TIPO,;        //6
					SX3->X3_CONTEXT } )   //7
			EndIf
			dbSelectArea("SX3")
			dbSkip()
		EndDo
	EndIf                     

	oPerg := AdvplPerg():New( cPerg )

	//-------------------------------------------------------------------
	//    AddPerg( cCaption, cTipo, nTam, nDec, aCombo, cF3, cValid )
	// Parametriza as perguntas
	//-------------------------------------------------------------------
//	oPerg:AddPerg( "Usuario?"              ,"C",6, , , "USR",,"@!")   //1
//	oPerg:AddPerg( "Tabela a alterar?"     ,"C",3, , ,      ,,"@!")   //2
//	oPerg:AddPerg( "A Partir de qual data?","D",8, , ,      ,,)       //3

	//Alert(SuperGetMv("MA_ZZU"+cTabela))
	Aadd(aCampos,{SuperGetMv("MA_ZZU"+cTabela)})
	aRet:=StrTokArr(aCampos[1,1],',')

    For nITab := 1 to Len(aRet)
    	nPos:=Ascan(aZHeader,{ |x| Alltrim(x[2]) == aRet[nITab]})
		If nPos > 0      //TRIM(X3Titulo()    SX3->X3_TIPO   SX3->X3_TAMANHO  SX3->X3_DECIMAL
			oPerg:AddPerg( aZHeader[nPos,1],aZHeader[nPos,6],aZHeader[nPos,4],aZHeader[nPos,5] , ,      ,,)
		EndIf
	Next nITab
	
	oPerg:SetPerg()

	If ! Pergunte( cPerg, .t. )
		Return( nil )
	EndIf

	//-----------------------------------------------
	// Seleciona os registros
	//-----------------------------------------------
	c_Tab:=cTabela
	IIF( SubStr(c_Tab,1,1)=='S', c_Tab1:=SubStr(c_Tab,2,2), c_Tab1:=c_Tab )

	cSql := "SELECT "
	cSql += c_Tab1+"_FILIAL, "		
	For nI:=1 to Len(aZHeader)
			cSql += aZHeader[nI,2]
		If nI<>Len(aZHeader)
			cSql += ','
		EndIf
	Next
	cSql += "  FROM "+RetSqlName(c_Tab)+' '+c_Tab1 "

	cSql += " WHERE "+c_Tab1+"_FILIAL = '"+xFilial(c_Tab)+"' " 
	cSql += "   AND "+c_Tab1+".D_E_L_E_T_ = ' ' "

	nPos:=0

    For nITab := 1 to Len(aRet)

    	nPos:=Ascan(aZHeader,{ |x| Alltrim(x[2]) == aRet[nITab]})  
		If nPos > 0
			If !Empty( &('MV_PAR'+STRZERO(nITab,2)) )      //caso o campo esteja em branco não entra na query
				cSql += " AND " + aRet[nITab] + " = '" + IIf( aZHeader[nPos,6] == 'D', DtoS(&('MV_PAR'+STRZERO(nITab,2))), &('MV_PAR'+STRZERO(nITab,2)) ) + "' "
			EndIf
		EndIf

	Next nITab

	//cSql += "   ORDER BY "+cCAMPO+"

	MemoWrite("C:\TEMP\P1TABEL.TXT", cSql)
	cSql := ChangeQuery( cSql )

	cAliascSQL1:=GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliascSQL1,.T.,.T.) 

	//-----------------------------------------------
	// Monta a dialog
	//-----------------------------------------------
	oDlg:= uAdvplDlg():New(  "Alterações na Tabela: "+cTabela, .t., .t., , nil, 100, 100 )


   /*				Aadd(aZHeader,{ TRIM(X3Titulo()),;  //1
					SX3->X3_CAMPO,;       //2
					SX3->X3_PICTURE,;     //3
					SX3->X3_TAMANHO,;     //4
					SX3->X3_DECIMAL,;     //5
					SX3->X3_TIPO,;        //6
					SX3->X3_CONTEXT } )   //7
					
Padrão aHeader MsNewGetDados
1 - TITULO, ;
2 - CAMPO   	, ;
3 - PICTURE 	, ;
4 - TAMANHO 	, ;
5 - DECIMAL 	, ;
6 - VALID   	, ;
7 - USADO   	, ;
8 - TIPO    	, ;
9 - F3      	, ;
10 - CONTEXT 	, ;
11 - CBOX    	, ;
12 - RELACAO 	, ;
13 - WHEN    	, ;
14 - VISUAL  	, ;
15 - VLDUSER 	, ;
16 - PICTVAR 	, ;
17 - OBRIGAT})

     */


	For nI := 1 to Len(aZHeader)
                     //X3_TITULO       SX3->X3_CAMPO   SX3->X3_PICTURE  SX3->X3_TAMANHO  SX3->X3_DECIMAL               SX3->X3_TIPO
//                         1                   2              3                 4              5           6    7        8          9     10  11 12   13    14   15 16   17
		Aadd(aHead, { aZHeader[nI,1] , aZHeader[nI,2] , aZHeader[nI,3] , aZHeader[nI,4] , aZHeader[nI,5] , "", "", aZHeader[nI,6], ""   , "R","","", ".T.", "A", "","",".F."} )
	Next nI

//	Aadd(aHead, { "Armazém"    , "ARMAZEM"  , "@!"     , TamSx3("B1_LOCPAD")[1] , 0 , ".f.", "", "C", ""   , "R","","", ".f.", "A", ""} )

	oGrdMGU:= MyGrid():New( 000, 000, 000, 000, GD_UPDATE+GD_DELETE /*GD_UPDATE*/,,,,,, 99999,,,, oDlg:oPnlCenter )

	For nLoop := 1 to Len( aHead )
			oGrdMGU:AddColumn( aHead[nLoop] )
	Next nLoop

	oGrdMGU:SeekSet()
	oGrdMGU:IndexSet()
//	oGrdMGU:SheetSet()
	oGrdMGU:AddButton( "Salvar Alterações"   , { || Processa( {|| UMdGrava(@oGrdMGU,@c_TAB)}, "Aguarde... Salvando Alterações ..." ) } )
	oGrdMGU:Load()
	oGrdMGU:FromSql( cSql )
	oGrdMGU:SetAlignAllClient()       
	oGrdMGU:IsDeleted()

	oDlg:SetInit( {|| oGrdMGU:Refresh()})
	oDlg:Activate()

return( nil )
                 
                 

//==========================================================================================
// UMDGrava - Antonio - Advpl Tecnologia - Maio / 2017
//------------------------------------------------------------------------------------------
// Descrição
// Salvar Alterações feitas nos campos das respectivas tabelas
//------------------------------------------------------------------------------------------
// Parametros
// Nenhum
//------------------------------------------------------------------------------------------
// Retorno
// nenhum
//==========================================================================================
Static Function UMDGrava(oGrdMGU,c_TAB)

Local nLoop, nX, a_Altera:= {} , ca_Altera:="", lRet

Local cCodEti  := ""

Local cDocF1   := ""
Local cSerieF1 := ""
Local cForneF1 := ""
Local cLojaF1  := ""

Local cDocF2   := ""
Local cSerieF2 := ""
Local cClienF2 := ""
Local cLojaF2  := ""

Local cDocD1   := ""
Local cSerieD1 := ""
Local cForneD1 := ""
Local cLojaD1  := ""
Local cProduD1 := ""
Local cItemD1  := ""

Local cDocD2   := ""
Local cSerieD2 := ""
Local cClienD2 := ""
Local cLojaD2  := ""
Local cProduD2 := ""
Local cItemD2  := ""

Local cTipoMov := ""
Local cSerieFT := ""
Local cNFiscal := ""
Local cClieFFT := ""
Local cLojaFT  := ""
Local cItemFT  := ""
Local cProduFT := ""

Local cSerieF3 := ""
Local cNFiscF3 := ""
Local cClieFF3 := ""
Local cLojaF3  := ""
Local cIdeFTF3 := ""

Local cClienE1 := ""
Local cLojaE1  := ""
Local cPrefiE1 := ""
Local cNumE1   := ""
Local cParceE1 := ""
Local cTipoE1  := ""

Local cForneE2 := ""
Local cLojaE2  := ""
Local cPrefiE2 := ""
Local cNumE2   := ""
Local cParceE2 := ""
Local cTipoE2  := ""

Local cTipoDoc := ""
Local cPrefiE5 := ""
Local cNumerE5 := ""
Local cParceE5 := ""
Local cTipoE5  := ""
Local cDataE5  := ""
Local cCliFoE5 := ""
Local cLojaE5  := ""
Local cSeqE5   := ""

Local cTpMovCD2 := ""
Local cSerieCD2 := ""
Local cNumerCD2 := ""
Local cCodForCD2 := ""
Local cCodCliCD2 := ""
Local cLojForCD2 := ""
Local cLojCliCD2 := ""
Local cItemCD2   := ""
Local cCodProCD2 := ""
Local cImpCD2    := ""   

Local cCodBemSF9 := ""                        

Local cCodigoSFA := ""                                                                                                                       
Local cDataSFA := ""                                                                                                                       
Local cTipoSFA := ""      

Local cDocCD5 := ""                                                                                                                                                                                                                    
Local cSerieCD5 := ""
Local cForneCD5 := ""
Local cLojaCD5 := ""
Local cItemCD5 := ""                  

Local cDocCDL := "" 
Local cSerieCDL := "" 
Local cCliCDL := "" 
Local cLojaCDL := "" 
Local cItemCDL := ""                                	
Local cNumDeCDL := ""                            	
Local cDocOriCDL := ""                                	
Local cSerOriCDL := ""                                 	
Local cForneCDL := ""                                	
Local cLojaCDL := ""                                	
Local cNumRegCDL := ""             

Local cTpMovCDG := ""
Local cDocCDG := ""
Local cSerieCDG := ""	
Local cForneCDG := ""	
Local cLojaCDG := ""                                	
Local cNumProCDG := ""                                 	
Local cTpProCDG := "" 

Local cCBaseSN1 := "" 
Local cItemSN1 := "" 

Local cCBaseSN3 := "" 
Local cItemSN3 := "" 
Local cCustoSN3 := ""     	                                                                                                                             	                                 	                                                                                                              	
Local cTipoSN3 := ""  	
Local cContabSN3 := "" 	
Local cSubCtaSN3 := ""    
                                                                                                                                           
Local cNrAvrcDB1 := ""  

Local cDocDB2 := ""	                                                                                                                			
Local cSerieDB2 := ""
Local cClifoDB2 := ""
Local cLojaDB2 := ""            

Local cNrAvrcDB3 := ""	     		                                                                                                                			
Local cItDocDB3 := ""	     
Local cItemDB3 := ""	                                                                                                            

Local cHawb := ""	     		                                                                                                                			
Local cDespesa := ""
Local nI, nII, nI2	     

If c_Tab == 'CB0' 
	cCodEti  := aScan(aHead,{|x| AllTrim(x[2])=="CB0_CODETI"})
ElseIf c_Tab == 'SF1' 
	cDocF1   := aScan(aHead,{|x| AllTrim(x[2])=="F1_DOC"    })
	cSerieF1 := aScan(aHead,{|x| AllTrim(x[2])=="F1_SERIE"  })
	cForneF1 := aScan(aHead,{|x| AllTrim(x[2])=="F1_FORNECE"})
	cLojaF1  := aScan(aHead,{|x| AllTrim(x[2])=="F1_LOJA"   })
ElseIf c_Tab == 'SF2' 
	cDocF2   := aScan(aHead,{|x| AllTrim(x[2])=="F2_DOC"    })
	cSerieF2 := aScan(aHead,{|x| AllTrim(x[2])=="F2_SERIE"  })
	cClienF2 := aScan(aHead,{|x| AllTrim(x[2])=="F2_CLIENTE"})
	cLojaF2  := aScan(aHead,{|x| AllTrim(x[2])=="F2_LOJA"   })
ElseIf c_Tab == 'SF3' 
//F3_FILIAL+F3_SERIE+F3_NFISCAL+F3_CLIEFOR+F3_LOJA+F3_IDENTFT
	cSerieF3 := aScan(aHead,{|x| AllTrim(x[2])=="F3_SERIE"  })
	cNFiscF3 := aScan(aHead,{|x| AllTrim(x[2])=="F3_NFISCAL"})
	cClieFF3 := aScan(aHead,{|x| AllTrim(x[2])=="F3_CLIEFOR"})
	cLojaF3  := aScan(aHead,{|x| AllTrim(x[2])=="F3_LOJA"   })
	cIdeFTF3 := aScan(aHead,{|x| AllTrim(x[2])=="F3_IDENTFT"})
ElseIf c_Tab == 'SD1' 
	cDocD1   := aScan(aHead,{|x| AllTrim(x[2])=="D1_DOC"    })
	cSerieD1 := aScan(aHead,{|x| AllTrim(x[2])=="D1_SERIE"  })
	cForneD1 := aScan(aHead,{|x| AllTrim(x[2])=="D1_FORNECE"})
	cLojaD1  := aScan(aHead,{|x| AllTrim(x[2])=="D1_LOJA"   })
	cProduD1 := aScan(aHead,{|x| AllTrim(x[2])=="D1_COD"    })
	cItemD1  := aScan(aHead,{|x| AllTrim(x[2])=="D1_ITEM"   })
ElseIf c_Tab == 'SD2' 
	cDocD2   := aScan(aHead,{|x| AllTrim(x[2])=="D2_DOC"    })
	cSerieD2 := aScan(aHead,{|x| AllTrim(x[2])=="D2_SERIE"  })
	cClienD2 := aScan(aHead,{|x| AllTrim(x[2])=="D2_CLIENTE"})
	cLojaD2  := aScan(aHead,{|x| AllTrim(x[2])=="D2_LOJA"   })
	cProduD2 := aScan(aHead,{|x| AllTrim(x[2])=="D2_COD"    })
	cItemD2  := aScan(aHead,{|x| AllTrim(x[2])=="D2_ITEM"   })
ElseIf c_Tab == 'SFT' 
	cTipoMov := aScan(aHead,{|x| AllTrim(x[2])=="FT_TIPOMOV"})
	cSerieFT := aScan(aHead,{|x| AllTrim(x[2])=="FT_SERIE"  })
	cNFiscal := aScan(aHead,{|x| AllTrim(x[2])=="FT_NFISCAL"})
	cClieFFT := aScan(aHead,{|x| AllTrim(x[2])=="FT_CLIEFOR"})
	cLojaFT  := aScan(aHead,{|x| AllTrim(x[2])=="FT_LOJA"   })
	cItemFT  := aScan(aHead,{|x| AllTrim(x[2])=="FT_ITEM"   })
	cProduFT := aScan(aHead,{|x| AllTrim(x[2])=="FT_PRODUTO"})
ElseIf c_Tab == 'SE1' 
	cClienE1 := aScan(aHead,{|x| AllTrim(x[2])=="E1_CLIENTE"})
	cLojaE1  := aScan(aHead,{|x| AllTrim(x[2])=="E1_LOJA"   })
	cPrefiE1 := aScan(aHead,{|x| AllTrim(x[2])=="E1_PREFIXO"})
	cNumE1   := aScan(aHead,{|x| AllTrim(x[2])=="E1_NUM"    })
	cParceE1 := aScan(aHead,{|x| AllTrim(x[2])=="E1_PARCELA"})
	cTipoE1  := aScan(aHead,{|x| AllTrim(x[2])=="E1_TIPO"   })
ElseIf c_Tab == 'SE2' 
	cForneE2 := aScan(aHead,{|x| AllTrim(x[2])=="E2_FORNECE"})
	cLojaE2  := aScan(aHead,{|x| AllTrim(x[2])=="E2_LOJA"   })
	cPrefiE2 := aScan(aHead,{|x| AllTrim(x[2])=="E2_PREFIXO"})
	cNumE2   := aScan(aHead,{|x| AllTrim(x[2])=="E2_NUM"    })
	cParceE2 := aScan(aHead,{|x| AllTrim(x[2])=="E2_PARCELA"})
	cTipoE2  := aScan(aHead,{|x| AllTrim(x[2])=="E2_TIPO"   })
ElseIf c_Tab == 'SE5' 
	cTipoDoc := aScan(aHead,{|x| AllTrim(x[2])=="E5_TIPODOC"})
	cPrefiE5 := aScan(aHead,{|x| AllTrim(x[2])=="E5_PREFIXO"})
	cNumerE5 := aScan(aHead,{|x| AllTrim(x[2])=="E5_NUMERO" })
	cParceE5 := aScan(aHead,{|x| AllTrim(x[2])=="E5_PARCELA"})
	cTipoE5  := aScan(aHead,{|x| AllTrim(x[2])=="E5_TIPO"   })
	cDataE5  := aScan(aHead,{|x| AllTrim(x[2])=="E5_DATA"   })
	cCliFoE5 := aScan(aHead,{|x| AllTrim(x[2])=="E5_CLIFOR" })
	cLojaE5  := aScan(aHead,{|x| AllTrim(x[2])=="E5_LOJA"   })
	cSeqE5   := aScan(aHead,{|x| AllTrim(x[2])=="E5_SEQ"    })    
ElseIf c_Tab == 'CD2' 
	cTpMovCD2:= aScan(aHead,{|x| AllTrim(x[2])=="CD2_TPMOV"})
	cSerieCD2:= aScan(aHead,{|x| AllTrim(x[2])=="CD2_SERIE"})
	cNumerCD2:= aScan(aHead,{|x| AllTrim(x[2])=="CD2_DOC"})
	cCodForCD2:= aScan(aHead,{|x| AllTrim(x[2])=="CD2_CODFOR"})
	cCodCliCD2:= aScan(aHead,{|x| AllTrim(x[2])=="CD2_CODCLI"})
	cLojForCD2:= aScan(aHead,{|x| AllTrim(x[2])=="CD2_LOJFOR"})
	cLojCliCD2:= aScan(aHead,{|x| AllTrim(x[2])=="CD2_LOJCLI"})
	cItemCD2  := aScan(aHead,{|x| AllTrim(x[2])=="CD2_ITEM"})
	cCodProCD2:= aScan(aHead,{|x| AllTrim(x[2])=="CD2_CODPRO"})
	cImpCD2   := aScan(aHead,{|x| AllTrim(x[2])=="CD2_IMP"}) 
ElseIf c_Tab == 'SF9' 
	cCodBemSF9:= aScan(aHead,{|x| AllTrim(x[2])=="F9_CODIGO"})
ElseIf c_Tab == 'SFA' 
	cCodigoSFA:= aScan(aHead,{|x| AllTrim(x[2])=="FA_CODIGO"})
	cDataSFA:= aScan(aHead,{|x| AllTrim(x[2])=="FA_DATA"})
	cTipoSFA:= aScan(aHead,{|x| AllTrim(x[2])=="FA_TIPO"})
ElseIf c_Tab == 'CD5'           
	cDocCD5:= aScan(aHead,{|x| AllTrim(x[2])=="CD5_DOC"})
	cSerieCD5:= aScan(aHead,{|x| AllTrim(x[2])=="CD5_SERIE"})
	cForneCD5:= aScan(aHead,{|x| AllTrim(x[2])=="CD5_FORNEC"})	
	cLojaCD5:= aScan(aHead,{|x| AllTrim(x[2])=="CD5_LOJA"})	
	cItemCD5:= aScan(aHead,{|x| AllTrim(x[2])=="CD5_ITEM"})	  
ElseIf c_Tab == 'CDL'           
	cDocCDL:= aScan(aHead,{|x| AllTrim(x[2])=="CDL_DOC"})
	cSerieCDL:= aScan(aHead,{|x| AllTrim(x[2])=="CDL_SERIE"})
	cCliCDL:= aScan(aHead,{|x| AllTrim(x[2])=="CDL_CLIENT"})	
	cLojaCDL:= aScan(aHead,{|x| AllTrim(x[2])=="CDL_LOJA"})	
	cItemCDL:= aScan(aHead,{|x| AllTrim(x[2])=="CDL_ITEMNF"})                                  	
	cNumDeCDL:= aScan(aHead,{|x| AllTrim(x[2])=="CDL_NUMDE"})                                  	
	cDocOriCDL:= aScan(aHead,{|x| AllTrim(x[2])=="CDL_DOCORI"})                                  	
	cSerOriCDL:= aScan(aHead,{|x| AllTrim(x[2])=="CDL_SERORI"})                                  	
	cForneCDL:= aScan(aHead,{|x| AllTrim(x[2])=="CDL_FORNEC"})                                  	
	cLojaCDL:= aScan(aHead,{|x| AllTrim(x[2])=="CDL_LOJFOR"})                                  	
	cNumRegCDL:= aScan(aHead,{|x| AllTrim(x[2])=="CDL_NRREG"})    
ElseIf c_Tab == 'CDG'           
	cTpMovCDG:= aScan(aHead,{|x| AllTrim(x[2])=="CDG_TPMOV"})
	cDocCDG:= aScan(aHead,{|x| AllTrim(x[2])=="CDG_DOC"})
	cSerieCDG:= aScan(aHead,{|x| AllTrim(x[2])=="CDG_SERIE"})	
	cForneCDG:= aScan(aHead,{|x| AllTrim(x[2])=="CDG_CLIFOR"})	
	cLojaCDG:= aScan(aHead,{|x| AllTrim(x[2])=="CDG_LOJA"})                                  	
	cNumProCDG:= aScan(aHead,{|x| AllTrim(x[2])=="CDG_PROCES"})                                  	
	cTpProCDG:= aScan(aHead,{|x| AllTrim(x[2])=="CDG_TPPROC"})       
ElseIf c_Tab == 'SN1'           
	cCBaseSN1:= aScan(aHead,{|x| AllTrim(x[2])=="N1_CBASE"})
	cItemSN1:= aScan(aHead,{|x| AllTrim(x[2])=="N1_ITEM"})  
ElseIf c_Tab == 'SN3'                                                                                                                                                                                                                   
	cCBaseSN3:= aScan(aHead,{|x| AllTrim(x[2])=="N3_CBASE"})
	cItemSN3:= aScan(aHead,{|x| AllTrim(x[2])=="N3_ITEM"})
	cCustoSN3:= aScan(aHead,{|x| AllTrim(x[2])=="N3_CCUSTO"})     	                                                                                                                             	                                 	                                                                                                              	
	cTipoSN3:= aScan(aHead,{|x| AllTrim(x[2])=="N3_TIPO"}) 	
	cContabSN3:= aScan(aHead,{|x| AllTrim(x[2])=="N3_CCONTAB"}) 		
	cSubCtaSN3:= aScan(aHead,{|x| AllTrim(x[2])=="N3_SUBCTA"})
ElseIf c_Tab == 'DB1'                                                                                                                                                                                                                   
	cNrAvrcDB1:= aScan(aHead,{|x| AllTrim(x[2])=="DB1_NRAVRC"})		 
ElseIf c_Tab == 'DB2'                                                                                                                                                                                                                   
	cDocDB2:= aScan(aHead,{|x| AllTrim(x[2])=="DB2_DOC"})		                                                                                                                			
	cSerieDB2:= aScan(aHead,{|x| AllTrim(x[2])=="DB2_SERIE"})
	cClifoDB2:= aScan(aHead,{|x| AllTrim(x[2])=="DB2_CLIFOR"})
	cLojaDB2:= aScan(aHead,{|x| AllTrim(x[2])=="DB2_LOJA"})                    
ElseIf c_Tab == 'DB3'                                                                                                                                                                                                                   
	cNrAvrcDB3:= aScan(aHead,{|x| AllTrim(x[2])=="DB3_NRAVRC"})		                                                                                                                			
	cItDocDB3:= aScan(aHead,{|x| AllTrim(x[2])=="DB3_ITDOC"})
	cItemDB3:= aScan(aHead,{|x| AllTrim(x[2])=="DB3_ITEM"})   
ElseIf c_Tab == 'SWD'                                                                                                                                                                                                                   
	cHawb:= aScan(aHead,{|x| AllTrim(x[2])=="WD_HAWB"})		                                                                                                                			
	cDespesa:= aScan(aHead,{|x| AllTrim(x[2])=="WD_DESPESA"})  	                                                                                                  	
EndIf                                                           
                                                                    

ProcRegua( 0 )

For nLoop := 1 to Len( oGrdMGU:aCols )
	
	IncProc()

	For nI := 1 to Len(aHead)

		IncProc()

		If oGrdMGU:GetField( aHead[nI,2] , nLoop) <> Nil

			If oGrdMGU:GetField( aHead[nI,2] , nLoop) <> oGrdMGU:aCols[nLoop,nI]                   //oGrdMGU:GetField("xxx"  , nLoop) == "xxx"
	
				AAdd( a_Altera, {	nLoop	} )

			EndIf

			If oGrdMGU:IsDeleted(nLoop)                 //linha deletada
				AAdd( a_Altera, {	nLoop	} )
			EndIf

		EndIf

	Next nI

	If !Empty(a_Altera)

		For nI2 := 1 to Len( oGrdMGU:aCols )

            If nI2 == nLoop

				lRet:=.F.
				
				If c_Tab == 'CB0' 
					&(c_Tab)->(dbSetOrder(1))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cCodEti]) )     //CB0_CODETI
						lRet:=.T.                
					EndIf
				EndIf

				If c_Tab == 'SF1'                          //FILIAL+DOC+SERIE+FORNECE+LOJA
					&(c_Tab)->(dbSetOrder(1))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cDocF1]+oGrdMGU:aCols[nI2,cSerieF1]+oGrdMGU:aCols[nI2,cForneF1]+oGrdMGU:aCols[nI2,cLojaF1] ) )
						lRet:=.T.                
					EndIf
				EndIf

				If c_Tab == 'SF2'                          //FILIAL+DOC+SERIE+CLIENTE+LOJA
					&(c_Tab)->(dbSetOrder(1))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cDocF2]+oGrdMGU:aCols[nI2,cSerieF2]+oGrdMGU:aCols[nI2,cClienF2]+oGrdMGU:aCols[nI2,cLojaF2] ) )
						lRet:=.T.                
					EndIf
				EndIf

				If c_Tab == 'SD1'                         //FILIAL+DOC+SERIE+FORNECE+LOJA+COD+ITEM
					&(c_Tab)->(dbSetOrder(1))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cDocD1]+oGrdMGU:aCols[nI2,cSerieD1]+oGrdMGU:aCols[nI2,cForneD1]+oGrdMGU:aCols[nI2,cLojaD1]+oGrdMGU:aCols[nI2,cProduD1]+oGrdMGU:aCols[nI2,cItemD1]) )
						lRet:=.T.                
					EndIf
				EndIf

				If c_Tab == 'SD2'                         //FILIAL+DOC+SERIE+CLIENTE+LOJA+COD+ITEM
					&(c_Tab)->(dbSetOrder(3))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cDocD2]+oGrdMGU:aCols[nI2,cSerieD2]+oGrdMGU:aCols[nI2,cClienD2]+oGrdMGU:aCols[nI2,cLojaD2]+oGrdMGU:aCols[nI2,cProduD2]+oGrdMGU:aCols[nI2,cItemD2]) )
						lRet:=.T.                
					EndIf
				EndIf

				If c_Tab == 'SFT'                         //FILIAL+TIPOMOV+SERIE+NFISCAL+CLIEFOR+LOJA+ITEM+PRODUTO
					&(c_Tab)->(dbSetOrder(1))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cTipoMov]+oGrdMGU:aCols[nI2,cSerieFT]+oGrdMGU:aCols[nI2,cNFiscal]+oGrdMGU:aCols[nI2,cClieFFT]+oGrdMGU:aCols[nI2,cLojaFT]+oGrdMGU:aCols[nI2,cItemFT]+oGrdMGU:aCols[nI2,cProduFt] ) )
						lRet:=.T.                
					EndIf
				EndIf

				If c_Tab == 'SF3'                         //F3_FILIAL+F3_SERIE+F3_NFISCAL+F3_CLIEFOR+F3_LOJA+F3_IDENTFT
					&(c_Tab)->(dbSetOrder(5))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cSerieF3]+oGrdMGU:aCols[nI2,cNFiscF3]+oGrdMGU:aCols[nI2,cClieFF3]+oGrdMGU:aCols[nI2,cLojaF3]+oGrdMGU:aCols[nI2,cIdeFTF3] ) )
						lRet:=.T.                
					EndIf
				EndIf

				If c_Tab == 'SE1'                         //FILIAL+CLIENTE+LOJA+PREFIXO+NUM+PARCELA+TIPO
					&(c_Tab)->(dbSetOrder(2))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cClienE1]+oGrdMGU:aCols[nI2,cLojaE1]+oGrdMGU:aCols[nI2,cPrefiE1]+oGrdMGU:aCols[nI2,cNumE1]+oGrdMGU:aCols[nI2,cParceE1]+oGrdMGU:aCols[nI2,cTipoE1] ) )
						lRet:=.T.                
					EndIf
				EndIf

				If c_Tab == 'SE2'                         //FILIAL+FORNECE+LOJA+PREFIXO+NUM+PARCELA+TIPO
					&(c_Tab)->(dbSetOrder(6))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cForneE2]+oGrdMGU:aCols[nI2,cLojaE2]+oGrdMGU:aCols[nI2,cPrefiE2]+oGrdMGU:aCols[nI2,cNumE2]+oGrdMGU:aCols[nI2,cParceE2]+oGrdMGU:aCols[nI2,cTipoE2] ) )
						lRet:=.T.                
					EndIf
				EndIf

				If c_Tab == 'SE5'                         //FILIAL+TIPODOC+PREFIXO+NUMERO+PARCELA+TIPO+DTOS(DATA)+CLIFOR+LOJA+SEQ
					&(c_Tab)->(dbSetOrder(2))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cTipoDoc]+oGrdMGU:aCols[nI2,cPrefiE5]+oGrdMGU:aCols[nI2,cNumerE5];
					+oGrdMGU:aCols[nI2,cParceE5]+oGrdMGU:aCols[nI2,cTipoE5]+DtoS(oGrdMGU:aCols[nI2,cDataE5])+oGrdMGU:aCols[nI2,cCliFoE5]+oGrdMGU:aCols[nI2,cLojaE5]+oGrdMGU:aCols[nI2,cSeqE5] ))
						lRet:=.T.                
					EndIf
				EndIf
				
				If c_Tab == 'CD2'                                                                                                 
					If oGrdMGU:aCols[nI2,cTpMovCD2] == 'E'
						&(c_Tab)->(dbSetOrder(2))	//CD2_FILIAL+CD2_TPMOV+CD2_SERIE+CD2_DOC+CD2_CODFOR+CD2_LOJFOR+CD2_ITEM+CD2_CODPRO+CD2_IMP
						If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cTpMovCD2]+oGrdMGU:aCols[nI2,cSerieCD2]+oGrdMGU:aCols[nI2,cNumerCD2];
				  		+oGrdMGU:aCols[nI2,cCodForCD2]+oGrdMGU:aCols[nI2,cLojForCD2]+oGrdMGU:aCols[nI2,cItemCD2]+oGrdMGU:aCols[nI2,cCodProCD2]+oGrdMGU:aCols[nI2,cImpCD2] ))
					   		lRet:=.T.                
				   		EndIf
					Else 
				   		&(c_Tab)->(dbSetOrder(1))	//CD2_FILIAL+CD2_TPMOV+CD2_SERIE+CD2_DOC+CD2_CODCLI+CD2_LOJCLI+CD2_ITEM+CD2_CODPRO+CD2_IMP
						If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cTpMovCD2]+oGrdMGU:aCols[nI2,cSerieCD2]+oGrdMGU:aCols[nI2,cNumerCD2];
				  		+oGrdMGU:aCols[nI2,cCodCliCD2]+oGrdMGU:aCols[nI2,cLojCliCD2]+oGrdMGU:aCols[nI2,cItemCD2]+oGrdMGU:aCols[nI2,cCodProCD2]+oGrdMGU:aCols[nI2,cImpCD2] ))
					   		lRet:=.T.                
						EndIf	
					Endif
				EndIf
				
				If c_Tab == 'SF9'  		//F9_FILIAL+F9_CODIGO                                                                                                                                             
					&(c_Tab)->(dbSetOrder(1))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cCodBemSF9]))
						lRet:=.T.                
					EndIf
				EndIf
				
				If c_Tab == 'SFA'       //FA_FILIAL+FA_CODIGO+DTOS(FA_DATA)+FA_TIPO                                                                                                                                      
					&(c_Tab)->(dbSetOrder(1))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cCodigoSFA]+DtoS(oGrdMGU:aCols[nI2,cDataSFA])+oGrdMGU:aCols[nI2,cTipoSFA]))
						lRet:=.T.                
					EndIf
				EndIf 

				If c_Tab == 'CD5'       //CD5_FILIAL+CD5_DOC+CD5_SERIE+CD5_FORNEC+CD5_LOJA+CD5_ITEM                                                                                                                                                                                                                                             
					&(c_Tab)->(dbSetOrder(4))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cDocCD5]+oGrdMGU:aCols[nI2,cSerieCD5]+oGrdMGU:aCols[nI2,cForneCD5];
					+oGrdMGU:aCols[nI2,cLojaCD5]+oGrdMGU:aCols[nI2,cItemCD5]))
						lRet:=.T.                
					EndIf
				EndIf       
				
				If c_Tab == 'CDL'   //CDL_FILIAL+CDL_DOC+CDL_SERIE+CDL_CLIENT+CDL_LOJA+CDL_ITEMNF+CDL_NUMDE+CDL_DOCORI+CDL_SERORI+CDL_FORNEC+CDL_LOJFOR+CDL_NRREG                                                                                                                                                                                                                                          
					&(c_Tab)->(dbSetOrder(2))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cDocCDL]+oGrdMGU:aCols[nI2,cSerieCDL]+oGrdMGU:aCols[nI2,cCliCDL];
					+oGrdMGU:aCols[nI2,cLojaCDL]+oGrdMGU:aCols[nI2,cItemCDL]+oGrdMGU:aCols[nI2,cNumDeCDL]+oGrdMGU:aCols[nI2,cDocOriCDL];
					+oGrdMGU:aCols[nI2,cSerOriCDL]+oGrdMGU:aCols[nI2,cForneCDL]+oGrdMGU:aCols[nI2,cLojaCDL]+oGrdMGU:aCols[nI2,cNumRegCDL]))
						lRet:=.T.                
					EndIf
				EndIf    
				
				If c_Tab == 'CDG'   //	CDG_FILIAL+CDG_TPMOV+CDG_DOC+CDG_SERIE+CDG_CLIFOR+CDG_LOJA+CDG_PROCES+CDG_TPPROC 
					&(c_Tab)->(dbSetOrder(2))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cTpMovCDG]+oGrdMGU:aCols[nI2,cDocCDG]+oGrdMGU:aCols[nI2,cSerieCDG];
					+oGrdMGU:aCols[nI2,cForneCDG]+oGrdMGU:aCols[nI2,cLojaCDG]+oGrdMGU:aCols[nI2,cNumProCDG]+oGrdMGU:aCols[nI2,cTpProCDG]))
						lRet:=.T.                
					EndIf
				EndIf    
				
				If c_Tab == 'SN1'   //N1_FILIAL+N1_CBASE+N1_ITEM 
					&(c_Tab)->(dbSetOrder(1))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cCBaseSN1]+oGrdMGU:aCols[nI2,cItemSN1]))
						lRet:=.T.                
					EndIf
				EndIf   
				
				If c_Tab == 'SN3'   //N3_FILIAL+N3_SUBCTA+N3_CCUSTO+N3_CCONTAB+N3_CBASE+N3_ITEM+N3_TIPO                                                                                               
					&(c_Tab)->(dbSetOrder(6))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cSubCtaSN3]+oGrdMGU:aCols[nI2,cCustoSN3]+oGrdMGU:aCols[nI2,cContabSN3];
				   	+oGrdMGU:aCols[nI2,cCBaseSN3]+oGrdMGU:aCols[nI2,cItemSN3]+oGrdMGU:aCols[nI2,cTipoSN3]))
						lRet:=.T.                
					EndIf
				EndIf   
				
				If c_Tab == 'DB1'   //DB1_FILIAL+DB1_NRAVRC                                                                                              
					&(c_Tab)->(dbSetOrder(1))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cNrAvrcDB1]))
						lRet:=.T.                
					EndIf
				EndIf   
				
				If c_Tab == 'DB2'   //DB2_FILIAL+DB2_DOC+DB2_SERIE+DB2_CLIFOR+DB2_LOJA                                                                                               
					&(c_Tab)->(dbSetOrder(1))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cDocDB2]+oGrdMGU:aCols[nI2,cSerieDB2]+oGrdMGU:aCols[nI2,cClifoDB2]+oGrdMGU:aCols[nI2,cLojaDB2]))
						lRet:=.T.                
					EndIf
				EndIf 
				
				If c_Tab == 'DB3'   //DB3_FILIAL+DB3_NRAVRC+DB3_ITDOC+DB3_ITEM                                                                                         
					&(c_Tab)->(dbSetOrder(1))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cNrAvrcDB3]+oGrdMGU:aCols[nI2,cItDocDB3]+oGrdMGU:aCols[nI2,cItemDB3]))
						lRet:=.T.                
					EndIf
				EndIf 		  

				If c_Tab == 'SWD' //WD_HAWB+WD_DESPESA                                                                                       
					&(c_Tab)->(dbSetOrder(1))
					If &(c_Tab)->(dbSeek(xFilial(c_Tab)+oGrdMGU:aCols[nI2,cHawb]+oGrdMGU:aCols[nI2,cDespesa]))
						lRet:=.T.                
					EndIf
				EndIf 		  
				
    			If lRet
    
					If oGrdMGU:IsDeleted(nLoop)       //linha deletada

	   					RecLock(c_Tab,.F.)
						dbDelete()
						MsUnlock()

					Else

						For nII := 1 to Len(aHead)
		
		   					RecLock(c_Tab,.F.)
		   					If !(c_Tab)->&(aHead[nII,2] ) == oGrdMGU:GetField( aHead[nII,2] , nI2)
								(c_Tab)->&(aHead[nII,2] ):=oGrdMGU:GetField( aHead[nII,2] , nI2)
							Endif
							MsUnlock()
								
						Next nII

					EndIf
				EndIf				
			EndIF

		Next nI2
	EndIF	
	
Next nLoop

oGrdMGU:Refresh()
oGrdMGU:FromSql( cSql )
	
Return( nil )                                                                                                                                                                           