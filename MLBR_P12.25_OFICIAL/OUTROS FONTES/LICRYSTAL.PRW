#INCLUDE "AvPrint.ch"  
#INCLUDE "Font.ch"  
#INCLUDE "rwmake.ch"       
#INCLUDE "topconn.ch"

#DEFINE INGLES                     1
#DEFINE PORTUGUES                  2 
#DEFINE DLG_CHARPIX_H              15.1
#DEFINE DLG_CHARPIX_W               7.9   

Static aMarcados := {}, nMarcados  
//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: LICRYSTAL
//|Autor.....: Robson Sanchez Dias - robson@dqzafra.com.br
//|Data......: 24/06/09
//|Uso.......: SIGAEIC   
//|Versao....: Protheus - 10.1    
//|Descricao.: Impressão da Instrucao de LI
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function LICRYSTAL()        
*-----------------------------------------*
                 
Local cSEQREL
Local cTelFax, cEndTec1, cEndTec2,cFone, cEmail
Local nTam:=150 
Local nLoop
Local LnCount

cPictQtde   := '@E 999,999,999.99'
cPict1Total := '@E 999,999,999,999.99'
cPict2Total := '@E 99,999,999,999,999.99'

Private cPerg     := Avkey("EICLI","X1_GRUPO")


VERPERGSX1()

If ! Pergunte(cPerg,.T. )
  Return .f.
Endif


               
E_ARQCRW(.T.,.T.,.T.)

cSEQREL:=GETSXENUM("SY0","Y0_SEQREL")    
ConfirmSX8()
         

dbSelectArea('SW5')
dbSetOrder(8)      
dbGoTop()
nCount:= 0 

if dbSeek(xFilial('SW5')+SW4->W4_PGI_NUM)
//	alert('NUM W4-> '+SW4->W4_PGI_NUM)
	while !SW5->(eof()) .and. SW5->W5_PGI_NUM == SW4->W4_PGI_NUM
		        
		// Evita impressao duplicada na Pli caso tenha embarque cadastrado
		dbSelectArea('SW7')
		dbSetOrder(1)
		If dbSeek(xFilial('SW7')+SW4->W4_PGI_NUM)      
		  	If EMPTY(SW5->W5_HAWB)
				SW5->(dbSkip())
			endif  
		Endif
	  	
	  	if nCount > 0 
			Alert('Tecle OK para imprimir o proximo Item...')
		endif
		nCount++                                                
		
		HEADER_P->(DBAPPEND())
		HEADER_P->AVG_FILIAL := xFilial()
		HEADER_P->AVG_SEQREL := cSEQREL
		//HEADER_P->AVG_CHAVE  := Alltrim(SW5->W5_PGI_NUM)+'/'+Alltrim(SW5->W5_SEQ_LI)    // REF PLI 
		HEADER_P->AVG_CHAVE  := Alltrim(SW5->W5_PGI_NUM)    // REF PLI 
		HEADER_P->AVG_C01_10 := DataA(Dtos(dDataBase)) 		  // Data Emissao
		
		//-----------> Cabeçalho Endereço.
		SW2->(dbsetorder(1))
		SW2->(dbseek(xFilial('SW2')+SW5->W5_PO_NUM))
		
		SYT->( DBSETORDER( 1 ) )
		SYT->( DBSEEK( xFilial()+SW2->W2_CONSIG ) )

		HEADER_P->AVG_C18_60 := SYT->YT_NOME                                      //Nome
		HEADER_P->AVG_C19_60 := Alltrim(SYT->YT_ENDE)+', '+Alltrim(STR(SYT->YT_NR_END))          //Endereco , Numero

		SYA->( DBSEEK( xFilial("SYA")+SYT->YT_PAIS ) )


		HEADER_P->AVG_C07_60 := Alltrim(SYT->YT_CIDADE)+' - '+Alltrim(SYT->YT_ESTADO)+' - '+Alltrim(SYA->YA_DESCR)+' - '+" CEP "+Space(1)+SYT->YT_CEP         
		//Alterado por Anesio em 10/10/2012 para incluir o BAIRRO - LINHA ORIGINAL = 	HEADER_P->AVG_C12_60 := "CNPJ: "+TRANS(SYT->YT_CGC,'@R 99.999.999/9999-99')
		if Len(AllTrim (SYT->YT_BAIRRO)) > 0
		HEADER_P->AVG_C14_20 := AllTrim(SYT->YT_BAIRRO)
		endif

		HEADER_P->AVG_C15_20 := TRANS(SYT->YT_CGC,'@R 99.999.999/9999-99')
		
		// Dados Despachante
		SW2->(dbsetorder(1))
		SW2->(dbseek(xFilial('SW2')+SW5->W5_PO_NUM))
		
		SY5->(dbsetorder(1))
		SY5->(dbseek(xFilial('SY5')+SW2->W2_DESP))
		
		
		HEADER_P->AVG_C01_60:= Alltrim(SY5->Y5_NOME)               // Nome do Despachante
		HEADER_P->AVG_C02_60:= "Fone: "+Alltrim(SY5->Y5_FONE)+" Fax: "+Alltrim(SY5->Y5_FAX)
		HEADER_P->AVG_C03_60:= Alltrim(SY5->Y5_CONTATO)
		
		SY1->(dbsetorder(1))
		SY1->( DBSEEK( xFilial("SY1")+MV_PAR01 ) )
		
		// Dados do Comprador
		HEADER_P->AVG_C02_30 := Alltrim(SY1->Y1_NOME) //
		HEADER_P->AVG_C01_30 := Alltrim(SY1->Y1_TEL) //"Telephone: "
		HEADER_P->AVG_C13_60 := Alltrim(SY1->Y1_EMAIL)
		
		// Dados Exportador
		
		SA2->(dbsetorder(1))
		SA2->(dbseek(xFilial('SA2')+SW2->W2_FORN))
		                   
		HEADER_P->AVG_C14_60  := SA2->A2_NOME                                // Nome Exportador
		HEADER_P->AVG_C15_60  := Alltrim(SA2->A2_END)+' '+SA2->A2_NR_END     // Endereco 
		HEADER_P->AVG_C16_60  := Alltrim(SA2->A2_MUN)+'/'+E_Field("A2_PAIS","YA_DESCR")    // Cidade / Nome do Pais
		
		
		// Dados Consignatário
		
		SYT->(dbsetorder(1))
		SYT->(dbseek(xFilial('SA2')+SW2->W2_CONSIG))
		                   
		HEADER_P->AVG_C04_60  := SYT->YT_NOME                               				 // Nome Consignatario
		HEADER_P->AVG_C05_60  := Alltrim(SYT->YT_ENDE)+','+Alltrim(STR(SYT->YT_NR_END))      // Endereco 
		HEADER_P->AVG_C06_60  := Alltrim(SYT->YT_BAIRRO)+'/'+Alltrim(SYT->YT_CIDADE)+'/'+SYT->YT_ESTADO   // Bairro/Cidade/Estado
		HEADER_P->AVG_C17_60  := Alltrim(Trans(SYT->YT_CGC,'@R 99.999.999/9999-99'))
		
		//-----------> Mercadoria
		SB1->( DBSETORDER( 1 ) )
		SB1->( DBSEEK( xFilial('SB1')+SW5->W5_COD_I ) )
		
		cDescrItem := MSMM(SB1->B1_DESC_GI)
		LnCount := MlCount(cDescrItem, 150)
		//alert(cDescrItem)                
		//MemoWrite("C:\TEMP\SYPDESC.TXT", cDescrItem)		                                  
		//alert(LnCount) 
		//Alert(OemToAnsi(cDescrItem)) 
		//Alert(AnsiToOem(cDescrItem))
		//Alert(NoAcento(AnsiToOem(cDescrItem)))
		//HEADER_P->AVG_C01100:= NoAcento(AnsiToOem(cDescrItem))   
	   	HEADER_P->AVG_C01150:=MEMOLINE(cDescrItem,nTam,1)    
		HEADER_P->AVG_C02150:=MEMOLINE(cDescrItem,nTam,2)   
		HEADER_P->AVG_C03150:=MEMOLINE(cDescrItem,nTam,3)
		HEADER_P->AVG_C04150:=MEMOLINE(cDescrItem,nTam,4) 
		HEADER_P->AVG_C01100:=MEMOLINE(cDescrItem,nTam,5)  
		HEADER_P->AVG_C02100:=MEMOLINE(cDescrItem,nTam,6)           
		
		//HEADER_P->AVG_C01100 := cDescrItem     // Mercadoria
//		SB1->(DbSeek(xFilial("SB1")+TRB->W5_COD_I))
		HEADER_P->AVG_C08_20 := Posicione('SB1',1, xFilial('SB1')+SW5->W5_COD_I, "B1_POSIPI")
//		HEADER_P->AVG_C08_20 := SW5->W5_NBMTEC          // TEC/EX-NCM/EX-NBM                         
		
		HEADER_P->AVG_C02_10 := SW4->W4_INCOTER           // Incoterms
		HEADER_P->AVG_C04_10 := SW4->W4_MOEDA            // Moeda 
		HEADER_P->AVG_C02_20 := Alltrim(TRANS(SW5->W5_QTDE,cPictQtde))                 // Quantidade
		//HEADER_P->AVG_C03_20 := Alltrim(TRANS(SW5->W5_PESO*SW5->W5_QTDE,'@E 999,999.9999'))           // Peso Liquido
		HEADER_P->AVG_C03_20 := Alltrim(TRANS(SW5->W5_PESO,'@E 999,999.9999'))           // Peso Liquido
		HEADER_P->AVG_C06_20 := Alltrim(TRANS(SW5->W5_PRECO,'@E 99,999,999.99'))      // Preco Unitario
		HEADER_P->AVG_C07_20 := Alltrim(TRANS(SW5->W5_QTDE*SW5->W5_PRECO,cPict1Total)) // Valor Total   
		
		//-----------> Observacao Produto Pli
   		HEADER_P->AVG_C05150 :=  Alltrim(SB1->B1_XOBSPLI)

		                      
		// Regime Tributacao - ATO CONCESSORIO
		                                    
		cRegime:="RECOLHIMENTO INTEGRAL DOS IMPOSTOS."
		
		If !Empty(SW5->W5_ATO_CON)
		   cRegime := "SUPENSAO, 'DRAWBACK' A.C. No. "+TRAN(SW5->W5_ATO_CON,'@R 9999-99-999999-9')+'/'+SW5->W5_SEQAC
		Endif        
		
		HEADER_P->AVG_C09_60:=cRegime
		
		//-----------> Condicoes de Pagamento.
		SY6->( DBSETORDER( 1 ) )
		SY6->( DBSEEK( xFilial('SY6')+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0) ) )
		      
		cTerms := MSMM(SY6->Y6_DESC_P,48)
		STRTRAN(cTerms, CHR(13)+CHR(10), " ")
		HEADER_P->AVG_C08_60 := Alltrim(cTerms)   
		
		
		//------------> Via de Transporte
		SYQ->( DBSETORDER( 1 ) )
		SYQ->( DBSEEK( xFilial('SYQ')+SW2->W2_TIPO_EMB ) )
		
		HEADER_P->AVG_C05_20 := Alltrim(SYQ->YQ_DESCR) // "Via Transporte 
		
		
		_cQrySya := "SELECT SYA.YA_DESCR "
		_cQrySya += "FROM " + RetSqlName("SYA") + " SYA "
		_cQrySya += "WHERE	SYA.D_E_L_E_T_ = '' "
		_cQrySya += "AND SYA.YA_FILIAL = '" + xFilial("SYA") + "' "
		_cQrySya += "AND SYA.YA_CODGI = (	SELECT SYR.YR_PAIS_DE "
		_cQrySya += "						FROM " + RetSqlName("SYR") + " SYR "
		_cQrySya += "						WHERE	SYR.D_E_L_E_T_ = '' "
		_cQrySya += "								AND SYR.YR_FILIAL = '" + xFilial("SYR") + "' " 
		_cQrySya += "								AND SYR.YR_VIA = '" + SW2->W2_TIPO_EMB + "' "  // Indice via de tranporte - linha add por Diego M. em 13/10/14 para corrigir erro consulta
		_cQrySya += "								AND SYR.YR_ORIGEM = '" + SW2->W2_ORIGEM + "' "
		_cQrySya += "								AND SYR.YR_DESTINO = '" + SW2->W2_DEST + "' ) "
		
		//MemoWrite("C:\TEMP\SYA_LIMIDORI.TXT", _cQrySya)
		
		If Select("TRBSYA") > 0
			TRBSYA->(DbCloseArea())
		Endif  
			
		Tcquery	_cQrySya New Alias "TRBSYA"	                      
		
		SY9->(dbsetorder(2))
		SY9->(dbseek(xFilial('SY9')+SW2->W2_DEST))
		
		HEADER_P->AVG_C05_30 := Alltrim(SW2->W2_DEST)+" - "+Alltrim(SY9->Y9_DESCR) //"Country of Final Destination: "                                            
		HEADER_P->AVG_C04_30 := Alltrim(E_Field("W4_PAISPRO","YA_DESCR")) //"Country of Origin: "                                            
		
		LIRemarks()                
		
		SA2->( DBSEEK( xFilial()+SW5->W5_FABR ) )
		cPais := SA2->A2_PAIS
		                       
		                  
		HEADER_P->AVG_C10_60 := SA2->A2_NOME
		HEADER_P->AVG_C11_60  := Alltrim(SA2->A2_END)+' '+SA2->A2_NR_END     // Endereco 
		HEADER_P->AVG_C12_60  := Alltrim(SA2->A2_MUN)+'/'+E_Field("A2_PAIS","YA_DESCR")    // Cidade / Nome do Pais
		
		
		cNomeRPT := "LIMIDORI.RPT" 
		AvgCrw32(cNomeRPT,Alltrim(HEADER_P->AVG_CHAVE),cSEQREL,,,.F.)		
	SW5->(dbSkip())
	enddo
endif  

		
If Select("TRB") > 0
	TRB->(DbCloseArea())
Endif		
Return()


//+-----------------------------------------------------------------------------------//
//| Função de Tratamento de data
//+-----------------------------------------------------------------------------------//
*-------------------------------*
Static Function DataA(cData)
*-------------------------------*

Local cRET := ""              
If !Empty(cData)
    cDD := SubStr(cData,7)
    cMM := SubStr(cData,5,2)
    cAA := SubStr(cData,3,2) 
    cRET:= Alltrim(cDD)+"/"+Alltrim(cMM)+"/"+Alltrim(cAA)
EndIf

Return (cRET)

//+-----------------------------------------------------------------------------------//
//|Funcao....: LIRemarks()
//|Descricao.: Preenche Observações da LI
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static FUNCTION LIRemarks()
*-----------------------------------------*
Local nTam:=150                                          

cRemarks := ""
cRemarks := MSMM(SW4->W4_DESC_GE,1200)

//HEADER_P->AVG_C05150:=MEMOLINE(cRemarks,nTam,1)  
HEADER_P->AVG_C06150:=MEMOLINE(cRemarks,nTam,1)
  

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: VERPERGSX1()
//|Descricao.: Inclusão de Parametros no arquivo SX1
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static FUNCTION VERPERGSX1()
*-----------------------------------------*
Local nX,nY,j := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aRegistro := {}

aRegistro:= {}

AADD(aRegistro,{cPerg,"01","Atendente" ,"mv_ch2","C", 03,0,0,"G","","mv_par01","SY1"})
aAdd(aRegistro,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)
For ny:=1 to Len(aRegistro)-1
	If !dbSeek(aRegistro[ny,1]+aRegistro[ny,2])
		SX1->(RecLock("SX1",.T.))
		For j:=1 to Len(aRegistro[ny])
			FieldPut(FieldPos(aRegistro[Len(aRegistro)][j]),aRegistro[ny,j])
		Next j
		SX1->(MsUnlock())
	EndIf
Next ny
RestArea(aAreaSX1)
RestArea(aAreaAnt)

Return
