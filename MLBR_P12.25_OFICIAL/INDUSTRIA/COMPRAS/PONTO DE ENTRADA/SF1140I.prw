#Include 'totvs.ch'
#Include 'topconn.ch'

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada SF1140I                                                                                  ³
//³                                                                                                          ³
//³LOCALIZAÇÃO : Function Ma140Grava() - Responsável por atualizar um pre-documento de entrada e seus anexos ³
//³                                                                                                          ³
//³EM QUE PONTO : Ponto de Entrada na atualizacao do cabecalho do pre-documento de entrada                   ³
//³                                                                                                          ³
//³Utilizado para a gravação do usuário que digitou a inclusão da Pré-Nota de Entrada                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/    


User Function SF1140I
Local _aARea := GetArea()     
Local _aDespEEC := {}  //EEC - Luis Henrique - DQZAFRA
Local _nRecSF1 := 0 , _nRecSD1 := 0
Local cQuery1	:= ""
Local cQuery2	:= ""
Local cVarPro	:= "/"
Local aColPrLt	:= {}
Local lProdCon  := .f.
Local cMA_EXCCQM := SuperGetMV('MA_EXCCQM',.F.,'066641','066642')    //EXCEÇÃO DE PRODUTOS QUE SÃO QUIMICOS, MAS DE OUTRO GRUPO DIFERENTE DE 12/14

RecLock ("SF1",.F.)
_nRecSF1 := SF1->(RECNO())

If Empty(SF1->F1_USERPN)
	SF1->F1_USERPN  := cUserName
Else
	SF1->F1_ALTERPN := cUserName
Endif
MsUnlock()                       


////EEC - Luis Henrique - DQZAFRA
/////VERIFICA SE HA PRODUTO COM AMARRACAO EM ZZJ - DESP. EXPORT x PRODUTO
/////SE HOUVER  SOLICITA NUMERO DO PROCESSO DE EXPORTACAO PARA GERAR DESPESAS EM EET

dbSelectArea("SD1")
_nRecSD1 := SD1->(RECNO())

dbSetOrder(1)  

dbSeek(xfilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
While !eof() .and. xfilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE == SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE
                       
	// Verifica se tem produtos na nota fiscal que imprime etiqueta e, por consequencia
	// deve ter conferencia fisica.
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial("SB1") + SD1->D1_COD )

	dbSelectArea("SBZ")
	dbSetOrder(1)
	If ! dbSeek( xFilial("SBZ") + SD1->D1_COD )
		dbSelectArea("SD1")
		dbSkip()
		Loop
	EndIf

	//IF SB1->B1_ZZIMPET == "S"
	IF SBZ->BZ_ZZIMPET == "S"	
		// Se o produto tiver etiqueta variável ( hora imprime, hora não imprime )  
		// verifica se deve ou não conferir a etiqueta
		If ! ( SD1->( FieldPos("D1_ZZIMPET") ) > 0 .and. SD1->D1_ZZIMPET == "N" .and. SBZ->BZ_ZZETVAR == "S" ) .or. ;
			SD1->( FieldPos("D1_ZZIMPET") ) == 0
			lProdCon := .t.      
		EndIf

	EndIf
	
	
	dbSelectArea("ZZJ")
    dbSetOrder(3)
    if dbSeek(xfilial("ZZJ")+SD1->D1_COD)              
                           
		//verifica se existe empresa amarrada ao fornecedor                            
    	dbSelectArea("SY5")
    	dbOrderNickName("Y5_XFORNEC") 
    	
    	if ! dbSeek(xfilial("SY5")+SF1->F1_FORNECE+SF1->F1_LOJA)
			msgAlert("Despesas não podem ser geradas pois Empresa não esta cadastrada em SY5")		
			exit
		Endif	
    
    //                     NF               SERIE        COD. DESP         VALOR        EMISSAO
		AADD(_aDespEEC,{SF1->F1_DOC, SF1->F1_SERIE, ZZJ->ZZJ_DESPES, SD1->D1_TOTAL, SF1->F1_EMISSAO })		

	Endif                           
	
	SD1->(dbSkip())
                
End                

if !empty(_aDespEEC)

	Processa({||GERADESP(_aDespEEC)})

Endif

RestARea(_aArea)

dbSelectArea("SD1")
dbGoTo(_nRecSD1) 
    
dbSelectArea("SF1")
dbGoTo(_nRecSF1)   

// Marca a nota para não conferir etiquetas
If ! lProdCon
	RecLock("SF1",.F.)
	SF1->F1_STATCON := " "
	MsUnlock()
EndIf

/////////////////////////////////////////////////////////////////////////
//Chamada da rotina de inclusao dos pallets para os produtos do grupo 11
//Vinicius Schwartz - TI - Midori Atlantica 23/10/2012
//Ref. ao Thiago/Fabio - HDI 004883
/////////////////////////////////////////////////////////////////////////
If cFilAnt == '09'

	If Select ('TMPF1G') > 0
		DbSelectArea('TMPF1G')
		DbCloseArea()
	endif

	cQuery1 := " SELECT D1_GRUPO,D1_COD FROM SD1010 "
	cQuery1 += " WHERE D1_FILIAL = '"+xFilial('SF1')+"' AND D1_DOC = '"+SF1->F1_DOC+"' AND D1_SERIE = '"+SF1->F1_SERIE+"' AND D1_FORNECE = '"+SF1->F1_FORNECE+"' AND D1_LOJA = '"+SF1->F1_LOJA+"' AND D1_GRUPO IN('11  ','12  ','14  ') AND D_E_L_E_T_ <> '*' "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),'TMPF1G',.T.,.T.)
	
	dbSelectArea("TMPF1G")
	dbGotop()

	If AllTrim(TMPF1G->D1_GRUPO) $ '11'         //COURO

		If Select ('TMPF1A') > 0
			DbSelectArea('TMPF1A')
			DbCloseArea()
		endif
	
		cQuery1 := " SELECT SUM (D1_QUANT) M2 , SUM (D1_NVQTAS) VQ , COUNT (*) QTDREG FROM SD1010 "
		cQuery1 += " WHERE D1_FILIAL = '"+xFilial('SF1')+"' AND D1_DOC = '"+SF1->F1_DOC+"' AND D1_SERIE = '"+SF1->F1_SERIE+"' AND D1_FORNECE = '"+SF1->F1_FORNECE+"' AND D1_LOJA = '"+SF1->F1_LOJA+"' AND D1_GRUPO = '11  ' AND D_E_L_E_T_ <> '*' "
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),'TMPF1A',.T.,.T.)
		
		dbSelectArea("TMPF1A")
		dbGotop()
		
		If TMPF1A->QTDREG > 0
			
			If Select ('TMPF1B') > 0
				DbSelectArea('TMPF1B')
				DbCloseArea()
			endif
			
			cQuery2 := " SELECT D1_COD, D1_LOTECTL FROM SD1010 "
			cQuery2 += " WHERE D1_FILIAL = '"+xFilial('SF1')+"' AND D1_DOC = '"+SF1->F1_DOC+"' AND D1_SERIE = '"+SF1->F1_SERIE+"' AND D1_FORNECE = '"+SF1->F1_FORNECE+"' AND D1_LOJA = '"+SF1->F1_LOJA+"' AND D1_GRUPO = '11  ' AND D_E_L_E_T_ <> '*' "
		    
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),'TMPF1B',.T.,.T.)
			
			dbSelectArea("TMPF1B")
			dbGotop()	
			
			While !TMPF1B->(Eof()) 
				Aadd(aColPrLt, {TMPF1B->D1_COD, TMPF1B->D1_LOTECTL})
				cVarPro := cVarPro + TMPF1B->D1_COD + "/"
				TMPF1B->(DbSkip())
			Enddo   
			
			//Chama a funcao de montagem da tabela com os pallets   
			//Alert('Chamando a Função')
			U_VSS_MntPalete(SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_EMISSAO,TMPF1A->M2,TMPF1A->VQ,TMPF1A->QTDREG,aColPrLt,cVarPro,,SF1->F1_DTDIGIT)
				
		Endif

    ElseIf Alltrim(TMPF1G->D1_GRUPO) $ '12-14'  .OR. AllTrim(TMPF1G->D1_COD) $ cMA_EXCCQM //QUIMICOS

		If ProcName(10) == "MATA140"            //SO ABRIR NA PRÉ-NOTA

			If MsgYesNo("Nota Fiscal Filha?")
	
				If Select ('TMPF1A') > 0
					DbSelectArea('TMPF1A')
					DbCloseArea()
				EndIf
		
				cQuery1 := " SELECT SUM (D1_QUANT) KG , COUNT (*) QTDREG FROM SD1010 "
				cQuery1 += " WHERE D1_FILIAL = '"+xFilial('SF1')+"' AND D1_DOC = '"+SF1->F1_DOC+"' AND D1_SERIE = '"+SF1->F1_SERIE+"' AND D1_FORNECE = '"+SF1->F1_FORNECE+"' AND D1_LOJA = '"+SF1->F1_LOJA+"' AND D1_GRUPO IN('12  ','14  ') AND D_E_L_E_T_ <> '*' "
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),'TMPF1A',.T.,.T.)
				
				dbSelectArea("TMPF1A")
				dbGotop()
				
				If TMPF1A->QTDREG > 0
					
					If Select ('TMPF1B') > 0
						DbSelectArea('TMPF1B')
						DbCloseArea()
					endif
					
					cQuery2 := " SELECT D1_COD, D1_LOTECTL FROM SD1010 "
					cQuery2 += " WHERE D1_FILIAL = '"+xFilial('SF1')+"' AND D1_DOC = '"+SF1->F1_DOC+"' AND D1_SERIE = '"+SF1->F1_SERIE+"' AND D1_FORNECE = '"+SF1->F1_FORNECE+"' AND D1_LOJA = '"+SF1->F1_LOJA+"' AND D1_GRUPO IN('12  ','14  ') AND D_E_L_E_T_ <> '*' "
				    
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),'TMPF1B',.T.,.T.)
					
					dbSelectArea("TMPF1B")
					dbGotop()	
					
					While !TMPF1B->(Eof()) 
						Aadd(aColPrLt, {TMPF1B->D1_COD, TMPF1B->D1_LOTECTL})
						cVarPro := cVarPro + TMPF1B->D1_COD + "/"
						TMPF1B->(DbSkip())
					Enddo   
					
					//Chama a funcao de montagem da tabela com os pallets   
					//Alert('Chamando a Função')
					U_VSS_UMntPalete(SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_EMISSAO,TMPF1A->KG,TMPF1A->QTDREG,TMPF1A->QTDREG,aColPrLt,cVarPro, ,SF1->F1_DTDIGIT)
						        //         1              2             3            4              5            6             7             8          9       10    11    12
				Endif
			
			EndIf    

		EndIf    

	EndIf    

Endif

Return()

      
//GERA DESPESAS EM EET - Luis Henrique - DQZAFRA
///////////////////////////////////
Static Function GERADESP(_aDespEEC)
Local _cFilial := ""     
Local _cPreemb := ""
Local _cPerg := "SF1140Ia"  
Local _nx                


CriaSx1(_cPerg)
  
Pergunte(_cPerg,.T.)
_cPreemb := MV_PAR01   

dbSelectArea("EEC")
dbGoTop()
Locate for alltrim(MV_PAR01) $ EEC->EEC_PREEMB 

if ! eof()
	_cFilial := EEC->EEC_FILIAL
Endif

ProcRegua(len(_aDespEEC))
     
//VERIFICA SE EXISTE AGENTE CADASTRADO PARA O PEDIDO - SE NAO HOUVER CADASTRA   
dbSelectArea("EEB")
dbSetOrder(1)
if ! dbSeek(_cFilial+_cPreEmb+"Q"+SY5->Y5_COD)
	Reclock("EEB",.T.)
	EEB->EEB_FILIAL	:= _cFilial
	EEB->EEB_CODAGE	:= SY5->Y5_COD
	EEB->EEB_PEDIDO	:= _cPreEmb
	EEB->EEB_TIPOAG	:= SY5->Y5_TIPOAGE
	EEB->EEB_NOME	:= SY5->Y5_NOME		
	EEB->EEB_OCORRE := "Q"
	EEB->EEB_TIPCOM := "2"
	EEB->EEB_TIPCVL := "1"	
	EEB->EEB_FORNEC := SY5->Y5_FORNECE	
	EEB->EEB_LOJAF  := SY5->Y5_LOJAF
    MsUnlock()
Endif              
    
dbSelectArea("EET")

For _nx := 1 to len(_aDespEEC)

	//Aumenta a regua
	IncProc("Gerando Despesas de Exportação em EET...")                              

	Reclock("EET",.T.)		
	
	EET->EET_FILIAL		:= _cFilial
	EET->EET_TIPOAGE	:= SY5->Y5_TIPOAGE
	EET->EET_PEDIDO		:= _cPreEmb
	EET->EET_OCORRE		:= "Q"
	EET->EET_DESPES		:= _aDespEEC[_nx][3]
	EET->EET_DESADI		:= _aDespEEC[_nx][5]
	EET->EET_VALORR		:= _aDespEEC[_nx][4]
	EET->EET_BASEAD		:= "2"
	EET->EET_DOCTO		:= "NF"+_aDespEEC[_nx][1]+"-"+_aDespEEC[_nx][2]
	EET->EET_PAGOPO		:= "1"	
	EET->EET_FORNECE	:= SY5->Y5_FORNECE
	EET->EET_LOJAF		:= SY5->Y5_LOJAF
	EET->EET_CODAGE		:= SY5->Y5_COD
	
	MsUnlock()

Next

Return



/*
ROTINA..................:CriaSX1
OBJETIVO................:Criar registros no arquivo de perguntas SX1
*/
Static Function CriaSX1(_cPerg)

Local _aArea := GetArea()
Local _aRegs := {}
Local i


_sAlias := Alias()
dbSelectArea("SX1")
SX1->(dbSetOrder(1))
_cPerg := padr(_cPerg,len(SX1->X1_GRUPO))

AADD(_aRegs,{_cPerg,"01" ,"Processo Exportação "                   ,"mv_ch1","C" ,20, 0, "G","mv_par01","EEC","","","","U_SF1140Ia()"})

DbSelectArea("SX1")
SX1->(DbSetOrder(1))

For i := 1 To Len(_aRegs)
	IF  !DbSeek(_aRegs[i,1]+_aRegs[i,2])
		RecLock("SX1",.T.)
		Replace X1_GRUPO   with _aRegs[i,01]
		Replace X1_ORDEM   with _aRegs[i,02]
		Replace X1_PERGUNT with _aRegs[i,03]
		Replace X1_VARIAVL with _aRegs[i,04]
		Replace X1_TIPO      with _aRegs[i,05]
		Replace X1_TAMANHO with _aRegs[i,06]
		Replace X1_PRESEL  with _aRegs[i,07]
		Replace X1_GSC    with _aRegs[i,08]
		Replace X1_VAR01   with _aRegs[i,09]
		Replace X1_F3     with _aRegs[i,10]
		Replace X1_DEF01   with _aRegs[i,11]
		Replace X1_DEF02   with _aRegs[i,12]
		Replace X1_DEF03   with _aRegs[i,13]
		Replace X1_VALID   with _aRegs[i,14]
		MsUnlock()
	EndIF
Next i

RestArea(_aArea)

Return


User Function SF1140Ia()
Local _lRet := .t.
Local _aArea := GetArea()
                
dbSelectArea("EEC")
dbGoTop()
Locate FOR alltrim(MV_PAR01)$EEC->EEC_PREEMB

_lret := !eof()
                         
RestArea(_aArea)
Return(_lRet)
