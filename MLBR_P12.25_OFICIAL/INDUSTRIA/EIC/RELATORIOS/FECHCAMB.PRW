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
//|Funcao....: FECHCAMB
//|Autor.....: Robson Sanchez Dias - robson@dqzafra.com.br
//|Data......: 24/06/09
//|Uso.......: SIGAEIC   
//|Versao....: Protheus - 10.1    
//|Descricao.: Fechamento de Cambio em Crystal
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function FECHCAMB()        
*-----------------------------------------*
                 
Local cSEQREL
Local cTelFax, cEndTec1, cEndTec2,cFone, cEmail
                                                  
Private cPerg     := Avkey("EICCAMB","X1_GRUPO")

cPict1Total := '@E 9,999,999,999.99'

//SWA->(dbgoto(SWA->WA_RECNO))
//Alert('Posicionado no registro'+SWA->WA_HAWB)
//Alert('Posicionado no registro '+SWA->WA_RECNO)

/*
If ! Empty(SWB->WB_CA_DT)
   MsgStop("PARCELA DE CAMBIO JA LIQUIDADA","Atenção")
   Return .f.
Endif
*/
VERPERGSX1()

If ! Pergunte(cPerg,.T. )
  Return .f.
Endif
           
E_ARQCRW(.T.,.T.,.T.)

cSEQREL:=GETSXENUM("SY0","Y0_SEQREL")    
ConfirmSX8()

dbSelectArea("SWB")
dbSetOrder(1)
dbSeek(xFilial("SWB")+SWA->WA_HAWB)

//Alert("Encontrado processo "+SWB->WB_HAWB)         

HEADER_P->(DBAPPEND())
HEADER_P->AVG_FILIAL := xFilial()
HEADER_P->AVG_SEQREL := cSEQREL
HEADER_P->AVG_CHAVE  := Alltrim(SWB->WB_HAWB)         // REF HAWB 
HEADER_P->AVG_C01_10 := DataA(Dtos(dDataBase)) 		  // Data Emissao


SY1->(dbsetorder(1))
SY1->( DBSEEK( xFilial("SY1")+MV_PAR02 ) )

//Alert("NOME -> "+SY1->Y1_NOME)
// Depto Importacao
HEADER_P->AVG_C02_30 := Left(SY1->Y1_NOME,30)
// Depto Financeiro
HEADER_P->AVG_C03_20 := MV_PAR03

SW9->(dbsetorder(1))
SW9->(dbseek(xFilial('SW9')+SWB->WB_INVOICE))

//-----------> Condicoes de Pagamento.
SY6->( DBSETORDER( 1 ) )
SY6->( DBSEEK( xFilial('SY6')+SW9->W9_COND_PA+STR(SW9->W9_DIAS_PA,3,0) ) )
      
cTerms := MSMM(SY6->Y6_DESC_P,48)
STRTRAN(cTerms, CHR(13)+CHR(10), " ")

// Banco de Fechamento     
SA6->(dbsetorder(1))
SA6->(dbseek(xFilial('SA6')+SWB->WB_BANCO))

HEADER_P->AVG_C01_60:= SWB->WB_BANCO+'-'+SA6->A6_NOME
HEADER_P->AVG_C02_60:= Alltrim(cTerms)   
If SWB->WB_PO_DI == "D"	      
	_cQuery = "SELECT SUM(WB_FOBMOE) CAMBTOT FROM SWB010 WHERE WB_FILIAL = '"+xFilial('SWB')+"' AND WB_HAWB = '"+Alltrim(SWB->WB_HAWB)+"' AND D_E_L_E_T_ = ''"
	
	If Select("TRBSWB") > 0
		TRBSWB->(DbCloseArea())
	Endif
	
	Tcquery	_cQuery New Alias "TRBSWB"
	
	HEADER_P->AVG_C03_60:= SWB->WB_MOEDA+' '+Alltrim(TRANS(TRBSWB->CAMBTOT,cPict1Total)) // Valor FOB	
// 	HEADER_P->AVG_C03_60:= SWB->WB_MOEDA+' '+Alltrim(TRANS(SWB->WB_FOBMOE,cPict1Total)) // Valor FOB
Else
	_cQuery = "SELECT SUM(WB_PGTANT) CAMBTOT FROM SWB010 WHERE WB_FILIAL = '"+xFilial('SWB')+"' AND WB_HAWB = '"+Alltrim(SWB->WB_HAWB)+"'"
	
	If Select("TRBSWB") > 0
		TRBSWB->(DbCloseArea())
	Endif
	
	Tcquery	_cQuery New Alias "TRBSWB"
	
	HEADER_P->AVG_C03_60:= SWB->WB_MOEDA+' '+Alltrim(TRANS(TRBSWB->CAMBTOT,cPict1Total)) // Valor FOB
//	HEADER_P->AVG_C03_60:= SWB->WB_MOEDA+' '+Alltrim(TRANS(SWB->WB_PGTANT,cPict1Total)) // Valor Pagto Antecipado
Endif   


// Banco para Remessa
SA2->(dbsetorder(1))
SA2->(dbseek(xFilial('SA2')+SWB->WB_FORN))
cMemo := AllTrim(SA2->A2_XMEMO)

If Len(cMemo) > 150
	HEADER_P->AVG_C01150  := SubStr(cMemo,1,150)
	HEADER_P->AVG_C02150  := SubStr(cMemo,151,Len(cMemo))
Else
	HEADER_P->AVG_C01150  := cMemo
EndIf

/*
SA6->(dbsetorder(1))
SA6->(dbseek(xFilial('SA6')+SWB->WB_BCO_REC))
HEADER_P->AVG_C04_60  := SWB->WB_BCO_REC+'-'+SA6->A6_NOME
HEADER_P->AVG_C05_60  := Alltrim(SA6->A6_MUN)+'/'+SA6->A6_PAISBCO //E_Field("A2_PAIS","YA_DESCR")    // Cidade / Nome do Pais
HEADER_P->AVG_C06_60  := 'SWIFT: '+SWB->WB_SWIFT
HEADER_P->AVG_C07_60  := SA6->A6_COMPL1 
HEADER_P->AVG_C10_60  := SA6->A6_COMPL2
*/               

// Vencimento
HEADER_P->AVG_C05_20  := 'ATE '+DTOC(SWB->WB_DT_VEN)

// Beneficiário

If SWB->WB_PO_DI == "D"
  SA2->(dbsetorder(1))
  SA2->(dbseek(xFilial('SA2')+SW9->W9_FORN))
Else
  SA2->(dbsetorder(1))
  SA2->(dbseek(xFilial('SA2')+SWB->WB_FORN))
Endif
                  
HEADER_P->AVG_C08_60  := SA2->A2_NOME
HEADER_P->AVG_C11_60  := Alltrim(SA2->A2_END)+' '+SA2->A2_NR_END     // Endereco 
HEADER_P->AVG_C12_60  := Alltrim(SA2->A2_MUN)+'/'+E_Field("A2_PAIS","YA_DESCR")    // Cidade / Nome do Pais

// Mercadoria
                                             
SWA->(dbsetorder(1))
SWA->(dbseek(xFilial('SWA')+SWB->WB_HAWB))

SW7->(dbsetorder(1))
SW2->(dbsetorder(1))
                    
SW7->(dbseek(xFilial('SW7')+SWB->WB_HAWB))
SW2->(dbseek(xFilial('SW2')+SW7->W7_PO_NUM))                    

HEADER_P->AVG_C13_60 := SW2->W2_DES_IPI // Descricao Produto

If Empty(SWA->WA_DI_NUM)
   HEADER_P->AVG_C09_60 := "REGISTRANDO"
Else
   HEADER_P->AVG_C09_60  := TRANS(SWA->WA_DI_NUM,'@R 99/9999999-9')
Endif
                  
FechAprov()
FechCargo()

cNomeRPT := "CAMBMIDORI.RPT" 
AvgCrw32(cNomeRPT,Alltrim(HEADER_P->AVG_CHAVE),cSEQREL,,,.F.)	

Return .t.


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

AADD(aRegistro,{cPerg,"01","Grupo Aprovação     " ,"mv_ch1","C", 06,0,0,"G","","mv_par01","SAL"})
AADD(aRegistro,{cPerg,"02","Atendente Importacao" ,"mv_ch2","C", 03,0,0,"G","","mv_par02","SY1"})
AADD(aRegistro,{cPerg,"03","Usuario Financeiro  " ,"mv_ch3","C", 20,0,0,"G","","mv_par03",""})
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



//+-----------------------------------------------------------------------------------//
//|Funcao....: FechAprov()
//|Descricao.: Verifica aprovador
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static FUNCTION FechAprov()
*-----------------------------------------*
Local xAprov:="", aAprov:=Array(3)

cAprov    := ""           

AFILL(aAprov,SPACE(30))

//-----------> Cadastro de Aprovadores
SAL->(DBSETORDER(1))

If SAL->(DBSEEK(xFilial("SAL")+MV_PAR01))
	cAprov := SAL->AL_COD      
	
	//aAprov:={} 
	nAprov:=1
	Do While !SAL->(EOF()) .and. cAprov == SAL->AL_COD .AND. nAprov <= 3

	    xAprov:=SAL->AL_NOME
	          
	    //aadd(aAprov,xAprov) 
	    aAprov[nAprov]:=xAprov
	    
	    nAprov++
	    
		SAL->(dbskip())
	EndDo
	
	Header_P->AVG_C04_30:= aAprov[1]
	Header_P->AVG_C05_30:= aAprov[2]
	Header_P->AVG_C07_30:= aAprov[3]
//	Header_P->AVG_C12_30:= aAprov[4]
	
EndIf


Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: FechCargo(
//|Descricao.: Verifica Cargo
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static FUNCTION FechCargo()
*-----------------------------------------*
Local aCargos:=Array(3)

cCodAprov := ""
cCargo	  := ""

//-----------> Cadastro de Cargo de Aprovadores
SAL->( DBSETORDER(1))
If SAL->( DBSEEK( xFilial()+MV_PAR01))
	cAprov := SAL->AL_COD                        
	nCargo:=1
	Do While !SAL->(EOF()) .and. cAprov == SAL->AL_COD .AND. nCargo <= 3
		cCodAprov := SAL->AL_APROV
		SAK->(DBSETORDER(1))
		If SAK->(DBSEEK(xFilial()+cCodAprov))
			cCargo := SAK->AK_CARGO
			
			//AADD(aCargos,cCargo)
			aCargos[nCArgo]:=cCargo  
			nCargo++
		EndIf
		SAL->(dbskip())
	EndDo
      
	Header_P->AVG_C04_30:= aCargos[1]
	Header_P->AVG_C05_30:= aCargos[2]
	Header_P->AVG_C07_30:= aCargos[3]
//	Header_P->AVG_C13_30:= aCargos[4]

EndIf

Return
