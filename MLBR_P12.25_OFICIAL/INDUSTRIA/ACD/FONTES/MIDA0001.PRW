#include "totvs.ch"

user function MIDA0001()

Local oBtnExec
Local oBtnPerg
Local oBtnSair
Local oPanel1

Local oTexto
Local cTexto := ""

Local oFont1 := TFont():New("Arial",,018,,.F.,,,,,.F.,.F.)
Local oDlg  

Local cPerg := "MIDA0001"
Local oPerg := AdvPlPerg():New(cPerg)

Private aRel := {}, nLoop := 1

//-------------------------------------------
// Ajusta os parâmetros
//-------------------------------------------
oPerg:AddPerg( "Plano Inicial", "C", 20  )
oPerg:AddPerg( "Plano Final"  , "C", 20  )
oPerg:AddPerg( "OP Inicial"   , "C", 6   )
oPerg:AddPerg( "OP Final"     , "C", 6   )

oPerg:SetPerg()

Pergunte(cPerg,.f.)

//-------------------------------------------
// Define o texto da Dialog
//-------------------------------------------
cTexto += "Esta rotina executa o empenho dos produtos necessários "
cTexto += "para a produção das OPs e planos informados nos parâmetros." + CRLF + CRLF

cTexto += "Os empenhos para os produtos que controlam lote serão feitos de acordo com o FIFO, "
cTexto += "dos lotes mais antigos para os lotes mais novos." + CRLF + CRLF

cTexto += "Para os produtos que controlam somente endereço somente será executado o ajuste do empenho dos mesmos." + CRLF + CRLF

cTexto += "Para os produtos que não controlam lote e nem endereço esta rotina não executará nenhuma mudança nos empenhos."

//-------------------------------------------
// Exibe a dialog
//-------------------------------------------
DEFINE MSDIALOG oDlg TITLE "Ajuste de empenho FIFO" FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL

@ 132, 000 MSPANEL oPanel1 SIZE 250, 017 OF oDlg COLORS 0, 16777215 RAISED
@ 000, 212 BUTTON oBtnExec PROMPT "Executar" SIZE 037, 016 OF oPanel1 ACTION Processa( { || AjuEmp() }, "Aguarde..." ) PIXEL
@ 000, 174 BUTTON oBtnPerg PROMPT "Parâmetros" SIZE 037, 016 OF oPanel1 ACTION Pergunte( cPerg ) PIXEL
@ 000, 137 BUTTON oBtnSair PROMPT "Sair" SIZE 037, 016 OF oPanel1 ACTION oDlg:End() PIXEL
@ 000, 000 GET oTexto VAR cTexto OF oDlg MULTILINE SIZE 250, 132 COLORS 0, 16777215 READONLY HSCROLL PIXEL FONT oFont1

// Don't change the Align Order
oPanel1:Align  := CONTROL_ALIGN_BOTTOM
oBtnExec:Align := CONTROL_ALIGN_RIGHT
oBtnPerg:Align := CONTROL_ALIGN_RIGHT
oBtnSair:Align := CONTROL_ALIGN_RIGHT
oTexto:Align   := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTERED

**************************************************************************************************************************************************
                                                                                                    
Static Function AjuEmp()

Local cSql      := ""                         
Local cAliasSql := GetNextAlias()
Local aArea     := GetArea()
             
//----------------------------------------
// Monta query dos produtos que devem
// ser analizados
//----------------------------------------
cSql += "SELECT SD4.D4_COD     PRODUTO "
cSql += "     , SD4.D4_LOCAL   ARMAZEM "
cSql += "     , SD4.D4_OP      OP "
cSql += "     , SD4.D4_QUANT   EMPENHO "
cSql += "     , SB1.B1_RASTRO  RASTRO "
cSql += "     , SB1.B1_LOCALIZ LOCALIZ "
cSql += "     , SD4.R_E_C_N_O_ RECNOD4 "                                    
cSql += "     , COALESCE( X.DC_QTDORIG, 0 ) EMPENDER " // TOTAL JA EMPENHADO NOS ENDERECOS ( SBF )
cSql += "  FROM "+RetSqlName("SD4")+" SD4 "
cSql += " INNER JOIN "+RetSqlName("SC2")+" SC2 ON SC2.C2_FILIAL = '"+xFilial("SC2")+"' "
cSql += "                      AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN = SD4.D4_OP "
cSql += "                      AND SC2.C2_OPMIDO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cSql += "                      AND SC2.C2_NUM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cSql += "                      AND SC2.D_E_L_E_T_ = ' ' "
cSql += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
cSql += "                      AND SB1.B1_COD = SD4.D4_COD "
cSql += "                      AND ( SB1.B1_RASTRO = 'L' OR SB1.B1_LOCALIZ = 'S' ) "
cSql += "                      AND SB1.D_E_L_E_T_ = ' ' "

cSql += "  LEFT JOIN ( SELECT SDC.DC_PRODUTO "         
cSql += "                   , SDC.DC_OP "
cSql += "                   , SDC.DC_LOCAL "
cSql += "                   , SUM( DC_QTDORIG ) DC_QTDORIG "
cSql += "                FROM "+RetSqlName("SDC")+" SDC "
cSql += "               WHERE SDC.DC_FILIAL = '"+xFilial("SDC")+"' "
cSql += "                 AND SDC.DC_ORIGEM = 'SC2' "
cSql += "                 AND SDC.D_E_L_E_T_ = ' ' "
cSql += "               GROUP BY SDC.DC_PRODUTO "
cSql += "                   , SDC.DC_OP "
cSql += "                   , SDC.DC_LOCAL ) X ON X.DC_OP = SD4.D4_OP "
cSql += "                                     AND X.DC_PRODUTO = SD4.D4_COD "
cSql += "                                     AND X.DC_LOCAL = SD4.D4_LOCAL "


cSql += "WHERE SD4.D4_FILIAL = '08' "
cSql += "  AND SD4.D4_LOTECTL = ' '  "
cSql += "  AND SD4.D4_QUANT = SD4.D4_QTDEORI "
cSql += "  AND SD4.D_E_L_E_T_ = ' ' "       

ProcRegua(0)
IncProc("Filtrando registros") 
IncProc("Filtrando registros") 
IncProc("Filtrando registros") 
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasSql,.f.,.t.) 	
                
dbGoTop()

ProcRegua(0)
While ! Eof()                            

	IncProc("Ajustando empenhos")

	If (cAliasSql)->RASTRO == "L"
		//-------------------------------------
		// trata os produtos que controlam lote
		//-------------------------------------
		TrataLote( (cAliasSql)->PRODUTO, (cAliasSql)->ARMAZEM, (cAliasSql)->EMPENHO, (cAliasSql)->EMPENDER, (cAliasSql)->OP, (cAliasSql)->RECNOD4 )
	Else
		
		//----------------------------------------------------------------------
		// Se a quantidade empenhada no SD4 (Campo EMPENHO) for a mesma do SDC
		// (Campo EMPENDER), não precisa fazer mais nada.
		//----------------------------------------------------------------------
		IF (cAliasSql)->EMPENDER >= (cAliasSql)->EMPENHO
			dbSelectArea( cAliasSql )
			dbSkip()
		    Loop
		EndIf   

		//-------------------------------------
		// trata os produtos que controlam  
		// somente endereço
		//-------------------------------------
		TrataEnd( (cAliasSql)->PRODUTO, (cAliasSql)->ARMAZEM, (cAliasSql)->EMPENHO, (cAliasSql)->EMPENDER, (cAliasSql)->OP, (cAliasSql)->RECNOD4 )
	EndIf
     
	dbSelectArea( cAliasSql )
	dbSkip()
Enddo       
                 
(cAliasSql)->(dbCloseArea())
RestArea( aArea )          
             
MsgInfo( "Processo finalizado com sucesso.")

Return( nil )   

***********************************************************************************************************
Static Function TrataLote( cPrd, cArm, nEmpenho, nEmpEnder, cOP, nRecno ) 

Local aEmpenho := {}
Local cSql     := ""
Local cAliasB8 := GetNextAlias()                 
Local aArea    := GetArea()
Local nSoma    := 0
Local cTRT     := ""           
Local aVetor   := {}
Local nX       := 0

Private lMsErroAuto := .F.

dbSelectArea("SD4")
dbGoTo(nRecno)      

cSql += "SELECT SB8.B8_PRODUTO "
cSql += "     , SB8.B8_LOCAL "
cSql += "     , SB8.B8_DATA "
cSql += "     , SB8.B8_DTVALID "
cSql += "     , SB8.B8_SALDO - SB8.B8_EMPENHO B8_LIVRE "
cSql += "     , SB8.B8_LOTECTL "
cSql += "  FROM "+RetSqlName("SB8")+" SB8 "
cSql += " WHERE SB8.B8_FILIAL = '"+xFilial("SB8")+"' "
cSql += "   AND SB8.B8_PRODUTO = '" +cPrd+ "' "
cSql += "   AND SB8.B8_SALDO - SB8.B8_EMPENHO > 0 "
cSql += "   AND SB8.B8_LOCAL = '"+cArm+"' "
cSql += "   AND SB8.B8_DTVALID >= '"+DtoS(dDataBase)+"' "
cSql += "   AND SB8.D_E_L_E_T_ = ' ' "
cSql += " ORDER BY SB8.B8_DATA, SB8.B8_DTVALID, SB8.B8_LOTECTL "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasB8,.f.,.t.) 	
dbGoTop()

While ! Eof()
	
	If (cAliasB8)->B8_LIVRE <= ( nEmpenho - nSoma )
		//------------------------------------------
		// Se tem menos estoque livre no lote do que
		// o necessário para o empenho
		//------------------------------------------
		nSoma += (cAliasB8)->B8_LIVRE
		AAdd( aEmpenho, { cPrd, cArm, (cAliasB8)->B8_LOTECTL, (cAliasB8)->B8_LIVRE, (cAliasB8)->B8_DTVALID } )
	Else
		//-----------------------------------------
		// Se tem mais estoque livre no lote do que
		// o necessário para o empenho
		//-----------------------------------------
		nSoma += (nEmpenho - nSoma)
		AAdd( aEmpenho, { cPrd, cArm, (cAliasB8)->B8_LOTECTL, nSoma, (cAliasB8)->B8_DTVALID } )
	EndIf                          
	
	//-----------------------------------------
	// Se alcançou a quantidade necessária 
	// para o empenho, sai do loop
	//-----------------------------------------
	If nSoma == nEmpenho
		Exit
	EndIf
	
	dbSkip()
	
Enddo
dbCloseArea()               
RestArea( aArea )                 
     
//---------------------------------------
// Não será possível empenhar a 
// quantidade total necessária. Mantém
// os empenhos como estão
//---------------------------------------
If ( nSoma - nEmpenho ) <> 0
	Return( nil )
EndIf
                         
//---------------------------------------
// Apaga o empenho atual 
//---------------------------------------
dbSelectArea("SD4")
dbGoTo(nRecno)     
cTrt  := SD4->D4_TRT                                             

lMsErroAuto := .F.
 
aVetor:={   {"D4_COD"     ,SD4->D4_COD     ,Nil},; //COM O TAMANHO EXATO DO CAMPO
            {"D4_LOCAL"   ,SD4->D4_LOCAL   ,Nil},;
            {"D4_OP"      ,SD4->D4_OP      ,Nil},;
            {"D4_DATA"    ,SD4->D4_DATA    ,Nil},;
            {"D4_QTDEORI" ,SD4->D4_QTDEORI ,Nil},;
            {"D4_QUANT"   ,SD4->D4_QUANT   ,Nil},;
            {"D4_TRT"     ,SD4->D4_TRT     ,Nil},;
            {"D4_QTSEGUM" ,SD4->D4_QTSEGUM ,Nil}}
             
MSExecAuto({|x,y| mata380(x,y)},aVetor,5 ) 

//---------------------------------------
// Se não conseguiu apagar o empenho sem
// lote, não continua a rotina
//---------------------------------------
If lMsErroAuto
    Alert("Erro ao excluir empenho")
    MostraErro()
    Return( nil )
EndIf
                              
//---------------------------------------
// Executa o empenho dos lotes
//---------------------------------------
For nX := 1 to Len( aEmpenhos ) 

	lMsErroAuto := .F.
                                              
	aVetor:={   {"D4_COD"     ,aEmpenho[nX,1] ,Nil},; //COM O TAMANHO EXATO DO CAMPO
	            {"D4_LOCAL"   ,aEmpenho[nX,2] ,Nil},;
	            {"D4_OP"      ,cOp            ,Nil},;
	            {"D4_DATA"    ,dDataBase      ,Nil},;
	            {"D4_QTDEORI" ,aEmpenho[nX,4] ,Nil},;
	            {"D4_QUANT"   ,aEmpenho[nX,4] ,Nil},;
	            {"D4_LOTECTL" ,aEmpenho[nX,3] ,Nil},;            
	            {"D4_DTVALID" ,aEmpenho[nX,5] ,Nil},;            
	            {"D4_TRT"     ,cTrt           ,Nil},;
	            {"D4_QTSEGUM" ,0              ,Nil}}
             
	MSExecAuto({|x,y| mata380(x,y)},aVetor,3 ) 

	If lMsErroAuto
	    Alert("Erro ao incluir empenho")
	    MostraErro()
	EndIf

Next nX

Return( nil )

***********************************************************************************************************
Static Function TrataEnd( cPrd, cArm, nEmpenho, nEmpEnder, cOP, nRecno )
                                               
Local aEmpenho := {}
Local cSql     := ""
Local cAliasBF := GetNextAlias()                 
Local aArea    := GetArea()
Local nSoma    := 0
Local cTRT     := ""           
Local aVetor   := {}
Local nX       := 0

cSql += "SELECT SBF.BF_PRODUTO "
cSql += "     , SBF.BF_LOCAL "
cSql += "     , SBF.BF_LOCALIZ "
cSql += "     , SUM( SBF.BF_QUANT - SBF.BF_EMPENHO ) BF_LIVRE "
cSql += "  FROM "+RetSqlName("SBF")+" SBF "
cSql += " WHERE SBF.BF_FILIAL = '"+xFilial("SBF")+"' "
cSql += "   AND SBF.BF_PRODUTO = '"+cPrd+"' "
cSql += "   AND SBF.BF_LOCAL = '"+cArm+"' "
cSql += "   AND SBF.D_E_L_E_T_ = ' ' "
cSql += " GROUP BY SBF.BF_PRODUTO "
cSql += "     , SBF.BF_LOCAL "
cSql += "     , SBF.BF_LOCALIZ "
cSql += "HAVING SUM( SBF.BF_QUANT - SBF.BF_EMPENHO ) > 0 "
                                           
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasBF,.f.,.t.) 	
dbGoTop()

While ! Eof()                                    

	If (cAliasBF)->BF_LIVRE <= ( nEmpenho - nSoma )
		//----------------------------------------------
		// Se tem menos estoque livre no endereço do que
		// o necessário para o empenho:
		// Pega todo o saldo livre do endereço
		//----------------------------------------------
		nSoma += (cAliasBF)->BF_LIVRE
		AAdd( aEmpenho, { (cAliasBF)->BF_LIVRE,;    // D4_QUANT
		                  (cAliasBF)->BF_LOCALIZ,;  // DC_LOCALIZ
		                   "",;                     // DC_NUMSERI
		                  0,;                       // D4_QTSEGUM
		                  .F.  } )
	Else
		//----------------------------------------------
		// Se tem mais estoque livre no endereço do que
		// o necessário para o empenho:
		// Pega somente o que falta empenhar, deixando
		// o resto do estoque livre.
		//----------------------------------------------
		nSoma += (nEmpenho - nSoma)
		AAdd( aEmpenho, { nSoma                 ,; // D4_QUANT
		                  (cAliasBF)->BF_LOCALIZ,; // DC_LOCALIZ
		                   ""                   ,; // DC_NUMSERI
		                  0                     ,; // D4_QTSEGUM
		                  .F.  } )
	EndIf                          
	
	//-----------------------------------------
	// Se alcançou a quantidade necessária 
	// para o empenho, sai do loop
	//-----------------------------------------
	If nSoma == nEmpenho
		Exit
	EndIf

	dbSelectArea(cAliasBF)
	dbSkip()
Enddo

dbCloseArea()               
RestArea( aArea )                 
     
//---------------------------------------
// Não será possível empenhar a 
// quantidade total necessária. Mantém
// os empenhos como estão
//---------------------------------------
If ( nSoma - nEmpenho ) <> 0
	Return( nil )
EndIf
                         
//---------------------------------------
// Apaga o empenho atual. É necessário
// apagar o empenho atual para diminuir
// B2_QEMP. 
//---------------------------------------
dbSelectArea("SD4")
dbGoTo(nRecno)     

lMsErroAuto := .F.
 
aVetor:={   {"D4_COD"     ,SD4->D4_COD     ,Nil},; //COM O TAMANHO EXATO DO CAMPO
            {"D4_LOCAL"   ,SD4->D4_LOCAL   ,Nil},;
            {"D4_OP"      ,SD4->D4_OP      ,Nil},;
            {"D4_DATA"    ,SD4->D4_DATA    ,Nil},;
            {"D4_QTDEORI" ,SD4->D4_QTDEORI ,Nil},;
            {"D4_QUANT"   ,SD4->D4_QUANT   ,Nil},;
            {"D4_TRT"     ,SD4->D4_TRT     ,Nil},;
            {"D4_QTSEGUM" ,SD4->D4_QTSEGUM ,Nil}}
             
MSExecAuto({|x,y| mata380(x,y)},aVetor,5 ) 

//---------------------------------------
// Se não conseguiu apagar o empenho sem
// endereço, não continua a rotina
//---------------------------------------
If lMsErroAuto
    Alert("Erro ao excluir empenho por endereço")
    MostraErro()
    Return( nil )
EndIf
                              
lMsErroAuto := .F.
MSExecAuto({|x,y| mata380(x,y,z)},aVetor,3, aEmpenho ) 

If lMsErroAuto
    Alert("Erro ao incluir empenho por endereço")
    MostraErro()
EndIf

Return( nil )
