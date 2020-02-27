#include "totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "RwMake.ch"
/*
*
*/
User Function UPDZZ01()

Local X

Local _cEmp   := "01"
Local _cFil   := "01"
Local aTables := {"SD3","SB1"}

Local cFunName   := Alltrim(ProcName())
Local cArqLckNfe := "\logLCKNfe\"
Local cArqLock   := " "

Local cQrySD3 := ""

Local aFilSD3     := {}
Local aFilANOMES  := {}
Local aFilAG1     := {}

Local lCont := .T.

Local nCusMat    := 0
Local nCusMod    := 0
Local nCusPQ     := 0 
Local nCusCouro  := 0
Local nEmbalagem := 0

MakeDir(cArqLckNfe)
cArqLock := Alltrim(cFunName + ".lck" )
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//?Efetua o Lock de gravacao da Rotina - Monousuario            ?
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FErase(cArqLock)
nHdlLock := MsFCreate(cArqLock)
IF nHdlLock < 0
	Conout("")
	Conout("**  Rotina "+ cFunName +" em uso...")
	Conout("")
	Return(.T.)
EndIF

//Preparando Ambiente
//RpcSetType(3)
lRetEnv := RpcSetEnv( _cEmp, _cFil, ,, 'COM', , aTables,  ,.f. , , )
If lRetEnv
	
	CONOUT("INICIANDO ROTINA ("+Alltrim(cFunName)+")")
	
	//Verificar Filiais da SD3
	cQrySD3 := " SELECT D3_FILIAL "
	cQrySD3 += " FROM "+RetSQLName("SD3")+"  "
	cQrySD3 += " WHERE D_E_L_E_T_ = '' "
	cQrySD3 += " GROUP BY D3_FILIAL "
	
	TCQUERY cQrySD3 ALIAS "TB1" NEW
	
	DbSelectArea("TB1")
	TB1->(DbGoTop())
	TB1->( dBEval({|| AAdd(aFilSD3, TB1->D3_FILIAL )}) )
	TB1->(DbCloseArea())
	  
	//Verificar Filiais da GS1
	cQrySD3 := " SELECT D3_FILIAL "
	cQrySD3 += " FROM "+RetSQLName("SD3")+"  "
	cQrySD3 += " WHERE D_E_L_E_T_ = '' "
	cQrySD3 += " GROUP BY D3_FILIAL "
	
	//Verificar Filial + Ano + MES
	cQry2 := " SELECT * " +CRLF
	cQry2 += " FROM ( " +CRLF
	cQry2 += "     SELECT D3_FILIAL AS FILIAL, " +CRLF
	cQry2 += "            SUBSTRING(D3_EMISSAO,1,4) ANO," +CRLF
	cQry2 += "            SUBSTRING(D3_EMISSAO,5,2) MES" +CRLF
	cQry2 += "     FROM "+RetSQLName("SD3")+" " +CRLF
	cQry2 += "     WHERE D_E_L_E_T_ = ''" +CRLF   
	cQry2 += "     AND D3_CF = 'PR0' AND D3_ESTORNO <> 'S' " +CRLF
	cQry2 += "     AND D3_LOCAL NOT IN ('L1','L2') " +CRLF	
	cQry2 += "     GROUP BY D3_FILIAL, SUBSTRING(D3_EMISSAO,1,4),SUBSTRING(D3_EMISSAO,5,2)" +CRLF
	cQry2 += " ) AS TB" +CRLF
	cQry2 += " WHERE [TB].[FILIAL]+[TB].[ANO]+[TB].[MES] <> ''" +CRLF
	cQry2 += " ORDER BY [TB].[FILIAL], [TB].[ANO],[TB].[MES]" +CRLF
	
	TCQUERY cQry2 ALIAS "TB2" NEW
	
	DbSelectArea("TB2")
	TB2->(DbGoTop())
	TB2->( dBEval({|| AAdd(aFilANOMES, {TB2->FILIAL, Alltrim(TB2->ANO+TB2->MES) } )}) )
	TB2->(DbCloseArea())
	
	For X:= 1 To Len(aFilANOMES)
		
		//cQD3 := " SELECT D3_GRUPO, D3_COD, Substring(D3_OP,1,6) D3_OP, D3_CC, D3_NUMSEQ, D3_QUANT, D3_CUSTO1 "
		cQD3 := " SELECT * "+CRLF
		cQD3 += " FROM "+RetSQLName("SD3")+" SD3 " +CRLF
		cQD3 += " WHERE D3_FILIAL = '"+aFilANOMES[X][1]+"' "+CRLF
		cQD3 += " AND D3_EMISSAO Between '"+aFilANOMES[X][2]+"01' and '"+ DtoS(LastDate( StoD(aFilANOMES[X][2]+"01") ))+  "'  "+CRLF
		CQD3 += " AND D3_CF = 'PR0' AND D3_ESTORNO <> 'S' " +CRLF
		CQD3 += " AND D3_LOCAL NOT IN ('L1','L2') " +CRLF
		cQD3 += " AND SD3.D_E_L_E_T_ = ' '  "+CRLF 
		cQD3 += " AND R_E_C_N_O_ NOT IN( SELECT ZZ0_RECSD3 FROM ZZ0010 WHERE D_E_L_E_T_ = ' ' )  "+CRLF 
		CQD3 += " ORDER BY D3_COD "   +CRLF
		
		TCQUERY cQD3 ALIAS "TB3" NEW
		DbSelectArea("TB3")
		TB3->(DbGoTop())
		While !TB3->(Eof()) .And. lCont   
		
			DbSelectArea("ZZ0")
			ZZ0->(DbSetOrder(1))//ZZ0_FILIAL+ZZ0_ANOMES+ZZ0_GRUPO+ZZ0_COD
			ZZ0->(DbGoTop())
			If ZZ0->(DbSeek( aFilANOMES[X][1]+aFilANOMES[X][2]+ TB3->D3_GRUPO + TB3->D3_COD  ))  
				RecLock("ZZ0",.F.)
			Else
			    
			    RecLock("ZZ0",.T.)                  
			    
				ZZ0->ZZ0_FILIAL	 := aFilANOMES[X][1]
				ZZ0->ZZ0_ANOMES	 := aFilANOMES[X][2]
				ZZ0->ZZ0_GRUPO	 := TB3->D3_GRUPO
				ZZ0->ZZ0_COD	 := TB3->D3_COD			    
				
				ZZ0->ZZ0_RECSD3  := Alltrim(Str(TB3->R_E_C_N_O_))
				
			EndIf

			nCusMat := 0
			nCusMod := 0
			nCusPQ  := 0 
			nCusCouro := 0
			nEmbalagem := 0			
			
			DbSelectArea('SD3')
			DbSetOrder(4) //D3_FILIAL+D3_NUMSEQ+D3_CHAVE+D3_COD
			DbSeek(xFilial('SD3')+TB3->D3_NUMSEQ)
			While !SD3->(eof()).and.SD3->D3_NUMSEQ == TB3->D3_NUMSEQ
				if SD3->D3_COD <> TB3->D3_COD .and. Substr(SD3->D3_COD,1,3) <> 'MOD'
					if Substr(SD3->D3_CF,1,1) <> 'D'
						nCusMat += SD3->D3_CUSTO1
					endif
					// Adiciona custo materia prima grupo 16 na coluna Insumo/Quimico
					// Desconta custo da materia prima do custo das demais requisicoes
					if Substr(SD3->D3_GRUPO,1,4) $ '16  '
						nCusPQ += SD3->D3_CUSTO1
						nCusMat -= SD3->D3_CUSTO1
					endif
					if Substr(SD3->D3_GRUPO,1,4) $ '16  '  .And. TB3->D3_GRUPO $ '56  '
						nCusPQ += SD3->D3_CUSTO1
						nCusMat -= SD3->D3_CUSTO1
					endif
					if Substr(SD3->D3_GRUPO,1,4) $ '12  |14  |39T |39TI'
						nCusPQ += SD3->D3_CUSTO1
						nCusMat -= SD3->D3_CUSTO1
					endif
				Endif
				//
				// Separa custo couro (45C e 45D) do custo da materia prima (45)
				if SD3->D3_CF = 'RE1' .And. Substr(SD3->D3_GRUPO,1,4) $ '45C  |45D  |51OM'
					nCusCouro += SD3->D3_CUSTO1
					nCusMat -= SD3->D3_CUSTO1
				endif
				
				// Separa materias de embalagem
				if Substr(SD3->D3_GRUPO,1,4) $ '19  '
					nEmbalagem += SD3->D3_CUSTO1
					nCusMat -= SD3->D3_CUSTO1
				endif
						
				if SD3->D3_COD <> TB3->D3_COD .and. Substr(SD3->D3_COD,1,3) == 'MOD' .and. SD3->D3_CF == 'RE1' .and. Substr(SD3->D3_COD,1,6) <> 'MOD998'
					nCusMod += SD3->D3_CUSTO1
				endif
				if SD3->D3_COD <> TB3->D3_COD .and. Substr(SD3->D3_COD,1,3) == 'MOD' .and. SD3->D3_CF == 'DE1' .and. Substr(SD3->D3_COD,1,6) == 'MOD998'
					nCusMat -= SD3->D3_CUSTO1
				endif
				
				if SD3->D3_CF == 'RE1'
					//					TMP->(ALLTRIM(SD3->D3_COD)) += SD3->D3_CUSTO1
					do case
						case Substr(ALLTRIM(SD3->D3_COD),1,5) == 'MOD32'
							ZZ0->D3_MODDIR += SD3->D3_CUSTO1
						case Substr(ALLTRIM(SD3->D3_COD),1,5) $ 'MOD35|MOD36|MOD37|MOD38|MOD39'
							ZZ0->D3_MODIND += SD3->D3_CUSTO1
						otherwise
							if Substr(ALLTRIM(SD3->D3_COD),1,3) == "MOD"
								ZZ0->D3_MODDIV += SD3->D3_CUSTO1
							endif
					EndCase
				Endif
				SD3->(dbSkip())
			EndDo			
			
			ZZ0->ZZ0_DESCRI	 := Posicione('SB1',1,xFilial('SB1')+TB3->D3_COD,"B1_DESC")
			ZZ0->ZZ0_OP	     := TB3->D3_OP
			ZZ0->ZZ0_QUANT	 := TB3->D3_QUANT
			ZZ0->ZZ0_CUSTO1	 := TB3->D3_CUSTO1
			ZZ0->ZZ0_CUSCOU	 := nCusCouro
			ZZ0->ZZ0_CUSMAT	 := nCusMat
			ZZ0->ZZ0_CONSPQ	 := nCusPQ
			ZZ0->ZZ0_EMB	 := nEmbalagem
			ZZ0->ZZ0_CUSMOD	 := nCusMod
			ZZ0->ZZ0_DTATU	 := dDataBase
			
			ZZ0->(MsUnLock("ZZ0"))
			
			ZZ0->(DbCloseArea())
			
			TB3->(DbSkip())
			nCusMat := 0
			nCusMod := 0
			nCusPQ  := 0
			nCusCouro := 0 
			nEmbalagem := 0			
            

			
		EndDo
		TB3->(DbCloseArea())
		
	Next X
                                           
	//
	//
	cQrySG1 := " "+CRLF
	cQrySG1 += "SELECT G1_FILIAL, COUNT(*) FROM "+RetSQLName("SG1")+" SG1"+CRLF 
	cQrySG1 += "WHERE G1_FILIAL <> 'ЪЧ'"+CRLF
	cQrySG1 += "AND D_E_L_E_T_ = ' ' "+CRLF
	cQrySG1 += "GROUP BY G1_FILIAL	"+CRLF
	cQrySG1 += "ORDER BY G1_FILIAL	"+CRLF
	
	TCQUERY cQrySG1 ALIAS "TB4" NEW
	
	aFilAG1 := {}
	DbSelectArea("TB4")
	TB4->(DbGoTop())
	TB4->( dBEval({|| AAdd(aFilAG1, TB4->G1_FILIAL )}) )
	TB4->(DbCloseArea())	
	
	For X:= 1 To Len(aFilAG1)
	
	Next X       
	
		
	CONOUT("FINALIZANDO ROTINA ("+Alltrim(cFunName)+")")
	
EndIf

//Cancela o Lock de gravacao da rotina
FClose(nHdlLock)
FErase(cArqLock)

Return()