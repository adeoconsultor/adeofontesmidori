#INCLUDE "EECPEM29.ch"

/*
Programa        : EECBOR_RDM.PRW
Objetivo        : Carta COLLECT LETTER
Autor           : Cristiano A. Ferreira
Data/Hora       : 07/12/1999
Obs.            :  
*/

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"
  
#xTranslate xLin1(<nVar>) => (<nVar> := <nVar>+10)
#xTranslate xLin2(<nVar>) => (<nVar> := <nVar>+08)

/*
Funcao      : EECBOR_RDM.PRW
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
User Function EECBOR

Local lRet := .f.
Local aOrd := SaveOrd({"SA6","EEL"})

Local cEXP_NOME,mDetalhe

//USADO NO EECF3EE3 VIA SXB "E34" PARA GET ASSINANTE
Private M->cSEEKEXF:=""
Private M->cSEEKLOJA:=""

Private cBcoAvis1,cBcoAvis2
Private cBcoCred1,cBcoCred2,cBcoCred3
Private cAss1,cAss2

Private cPerg     := Avkey("EECLIST","X1_GRUPO")

Begin Sequence

   SA6->(dbSetOrder(1))
   EEL->(dbSetOrder(1))

   //regras para carregar dados
   IF !EMPTY(EEC->EEC_EXPORT)
      cEXP_NOME := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
      M->cSEEKEXF  :=EEC->EEC_EXPORT
      M->cSEEKLOJA :=EEC->EEC_EXLOJA
   ELSE
      cEXP_NOME := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME")
      M->cSEEKEXF  :=EEC->EEC_FORN
      M->cSEEKLOJA :=EEC->EEC_FOLOJA
   ENDIF

   cBcoAvis1 := Padr(BuscaInst(EEC->EEC_PREEMB,OC_EM,BC_AVI),60)
   cBcoAvis2 := Space(60)

   cBcoCred1 := Padr(BuscaInst(EEC->EEC_PREEMB,OC_EM,BC_COC),60)
   cBcoCred2 := SPACE(60)
   cBcoCred3 := SPACE(60)
   
   cAss1 := Padr(EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1),60)
   cAss2 := Padr(EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",2),60)

   IF !TelaGets()
      Break
   Endif

   IF ! E_AVGLTT("G")
      Break
   Endif
   
   //adicionar registro no AVGLTT
   AVGLTT->(DBAPPEND())

   //gravar dados a serem editados
   AVGLTT->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo

   SA2->(dbSetOrder(1))
   IF !EMPTY(EEC->EEC_EXPORT) .AND. ;
      SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
      cExp_Cod     := EEC->EEC_EXPORT+EEC->EEC_EXLOJA
      cEXP_NOME    := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
      cEXP_CONTATO := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1)  //nome do contato seq 1
      cEXP_FONE    := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",4)  //fone do contato seq 1
      cEXP_FAX     := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",7)  //fax do contato seq 1
      cEXP_CARGO   := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",2)  //CARGO
      cCidade      := Alltrim(SA2->A2_MUN)
      M->cSEEKEXF  :=EEC->EEC_EXPORT
      M->cSEEKLOJA :=EEC->EEC_EXLOJA
   ELSE
      SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA))
      cExp_Cod     := EEC->EEC_FORN+EEC->EEC_FOLOJA
      cEXP_NOME    := SA2->A2_NOME
      cEXP_CONTATO := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
      cEXP_FONE    := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
      cEXP_FAX     := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
      cEXP_CARGO   := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",2,EEC->EEC_RESPON)  //CARGO
      cCidade      := Alltrim(SA2->A2_MUN)
      
      M->cSEEKEXF  :=EEC->EEC_FORN
      M->cSEEKLOJA :=EEC->EEC_FOLOJA
   ENDIF
      
   // Dados do Exportador/Fornecedor      	   
   AVGLTT->AVG_C01_60:=ALLTRIM(cEXP_NOME) // TITULO 1
   AVGLTT->AVG_C02_60:=ALLTRIM(SA2->A2_END)
   AVGLTT->AVG_C03_60:=ALLTRIM(SA2->A2_EST+" "+AllTrim(BuscaPais(SA2->A2_PAIS))+" CEP: "+Transf(SA2->A2_CEP,AVSX3("A2_CEP",6)))
   AVGLTT->AVG_C01_30:=ALLTRIM('FONE: '+AllTrim(cEXP_FONE)+'FAX: '+AllTrim(cEXP_FAX)) //"TEL.: "###" FAX: "
   AVGLTT->AVG_C02_30:=TRANSFORM(Posicione("SA2",1,xFILIAL("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_CGC"),AVSX3("A2_CGC",AV_PICTURE))

   mDetalhe:= ""
   
//   mDetalhe:= mDetalhe+Padc("COLLECTION LETTER",90)+ENTER
//   mDetalhe:= mDetalhe+Padc("-----------------",90)+ENTER
   
   mDetalhe:= mDetalhe+cCidade+",       "+Upper(cMonth(dDataBase))+" "+AllTrim(Str(Day(dDataBase)))+", "+Str(Year(dDataBase),4)+ENTER
   mDetalhe:= mDetalhe+ENTER

// mDetalhe:= mDetalhe+Space(50)+"COURIER NBR.: "+EEC->EEC_COURIE+ENTER
   
   // Posiciona o arquivo EEJ ...
   BuscaInst(EEC->EEC_PREEMB,OC_EM,BC_DIM)
   
   SA6->(dbSeek(xFilial()+EEJ->EEJ_CODIGO+EEJ->EEJ_AGENCI))
   
   mDetalhe:= mDetalhe+"Ao: "+cBcoCred1+ENTER
//   mDetalhe:= mDetalhe+"    "+SA6->A6_END+ENTER
//   mDetalhe:= mDetalhe+"    "+AllTrim(SA6->A6_MUN)+" "+AllTrim(SA6->A6_UNIDFED)+" "+Posicione("SYA",1,xFilial("SYA")+SA6->A6_COD_P,"YA_DESCR")+ENTER
//   mDetalhe:= mDetalhe+"    ATN: "+AllTrim(EECCONTATO(CD_SA6,SA6->A6_COD,,"1",1))+" PHONE: "+AllTrim(EECCONTATO(CD_SA6,SA6->A6_COD,,"1",4))+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+"Pela presente entregamos o(s) documento(s) para COBRANÇA/CRÉDITO"+ENTER
   mDetalhe:= mDetalhe+"referente ao(s) contrato(s) de cambio abaixo discrimidado(s):"+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+Padr("   OPERACAO CAMBIO      ",37)+Padc("DATA      ",08) +Padc("    VALOR             ",10)+ENTER
   mDetalhe:= mDetalhe+Padr("   ---------------------",37)+"--------"+space(03)+Padc("------------------",20)+ENTER

// mDetalhe:= mDetalhe+"   "+Padr(REPLI('X',20),34)+'XX/XX/XX'+SPACE(04)+"999,999,999,999.99"+ENTER
                        

   // ** By JBJ - 06/01/2004 - Faz a leitura do Draft maturity a partir do EEQ (Parcelas de Câmbio).
   EEQ->(DbSetOrder(1))
   If EEQ->(DbSeek(xFilial("EEQ")+EEC->EEC_PREEMB))
      Do While EEQ->(!Eof()) .And. EEQ->EEQ_FILIAL == xFilial("EEQ") .And.;
                                   EEQ->EEQ_PREEMB == EEC->EEC_PREEMB

         mDetalhe:= mDetalhe+Padr(EEQ->EEQ_NROP,40)+DTOC(EEQ->EEQ_DTCE)+SPACE(04)+TRANS(EEQ->EEQ_VL,"@E 999,999,999,999.99")+ENTER

         If !Empty(EEQ->EEQ_VCT)
//          mDetalhe:= mDetalhe+"DRAFT MATURITY: "+Dtoc(EEQ->EEQ_VCT)+ENTER
            Exit
         EndIf
         EEQ->(DbSkip())
      EndDo
   Else
      mDetalhe:= mDetalhe+ENTER
   EndIf
                          
   mDetalhe:= mDetalhe+ENTER

//   mDetalhe:= mDetalhe+"TERM AMOUNT: "+EEC->EEC_MOEDA+" "+Transf(EEC->EEC_TOTPED,AVSX3("EEC_TOTPED",6))+ENTER

   mDetalhe:= mDetalhe+"REGISTRO DE EXPORTACAO: "+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+"SOLICITACAO DE DESPACHO: "+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+"SAQUE: "+exp->exp_nrinvo+SPACE(30)+"IMPORTANCIA:"+Transf(EXP->EXP_TOTPED,AVSX3("EEC_TOTPED",6))+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+ENTER


   // IMPORTADOR
   SA1->(DBSEEK(xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))   
   cIMP_NOME := IF(!EMPTY(EEC->EEC_IMPODE),EEC->EEC_IMPODE,SA1->A1_NOME)

   mDetalhe:= mDetalhe+"SACADO: "+LEFT(cImp_Nome,45)+SPACE(04)+"VENCIMENTO:"+SY6Descricao(EEC->EEC_CONDPA+STR(EEC->EEC_DIASPA,AVSX3("Y6_DIAS_PA",3),0),EEC->EEC_IDIOMA,1)+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+ENTER
                                  
   mDetalhe:= mDetalhe+"MERCADORIA: "+MEMOLINE(MSMM(EEC->EEC_DSCGEN,AVSX3("EEC_GENERI",AV_TAMANHO),,,LERMEMO),AVSX3("EEC_GENERI",AV_TAMANHO),1)+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+ENTER

   mDetalhe:= mDetalhe+"NAVIO: "+EEC->EEC_EMBARC+SPACE(25)+"DESTINO:"+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+ENTER
   
   mDetalhe:= mDetalhe+SPACE(25)+"INSTRUCOES PARA COBRANCA: "+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+ENTER
   

   mDetalhe:= mDetalhe+"DOCUMENTOS SOMENTE PARA EFEITO DE ARQUIVO."+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+"Courier: TNT(Conta nr.14807)"+ENTER
   mDetalhe:= mDetalhe+ENTER

   mDetalhe:= mDetalhe+"Obs.: Despesas referente comissao de agente sao por conta do exportador"+ENTER
   mDetalhe:= mDetalhe+ENTER
   
   mDetalhe:= mDetalhe+"Obs.: Menscionae na carta remessa:'All banking charges outside Brazil,except of agents"+ENTER
   mDetalhe:= mDetalhe+"comission payment,should be paid by drawee."+ENTER
   
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+Padr("   DOCUMENTOS    ",40)+Padc("ORIGINAL",10)+Padc("COPIES",10)+ENTER
   mDetalhe:= mDetalhe+Padr("   --------------",40)+Padc("--------",10)+Padc("------",10)+ENTER
   mDetalhe:= mDetalhe+Padr("   COMMERCIAL INVOICE",40)+Padc("01",10)+Padc("01",10)+ENTER
   mDetalhe:= mDetalhe+Padr("   PACKING LIST",40)+Padc("01",10)+Padc("01",10)+ENTER
   mDetalhe:= mDetalhe+Padr("   B/L OU AWB",40)+Padc("01",10)+Padc("01",10)+ENTER
   mDetalhe:= mDetalhe+Padr("   SAQUE",40)+Padc("01",10)+Padc("01",10)+ENTER

// mDetalhe:= mDetalhe+Padr("   CERTIFICATE OF ORIGIN",40)+Padc("01",10)+Padc("02",10)+ENTER
// mDetalhe:= mDetalhe+Padr("   INSURANCE CERTIFICATE",40)+Padc("01",10)+Padc("02",10)+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+cAss1+ENTER
   mDetalhe:= mDetalhe+cAss2
   
   //gravar detalhe
   AVGLTT->WK_DETALHE := mDETALHE

   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //executar rotina de manutencao de caixa de texto
   lRet:=E_AVGLTT("M",WORKID->EEA_TITULO)
   
End Sequence

RestOrd(aOrd)

Return lRet

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
Static Function TelaGets

Local lRet := .f.

Local bOk     := {||lRet := .t., oDlg:End()}
Local bCancel := {||oDlg:End()}
   
Local y := 20
Local oDlg

Begin Sequence 

   VERPERGSX1()
    
   IF ! Pergunte(cPerg,.T.)
      Break
   Endif
                  
   lRet:=.t.
   EEC->(dbseek(xFilial('EEC')+exp->exp_preemb))

   DEFINE MSDIALOG oDlg TITLE AllTrim(WorkId->EEA_TITULO) FROM 9,10 TO 28,70 OF oMainWnd
   
      @ y,01 SAY STR0001 PIXEL //"Banco Avisador"
      @ xLin2(y),01 MSGET cBcoAvis1 PICTURE "@!" SIZE 210,08 PIXEL
      @ xLin1(y),01 MSGET cBcoAvis2 PICTURE "@!" SIZE 210,08 PIXEL
      
      xLin2(y)
      
      @ xLin2(y),01 SAY STR0002 PIXEL //"Banco para Crédito"
      @ xLin2(y),01 MSGET cBcoCred1 PICTURE "@!" SIZE 210,08 PIXEL
      @ xLin1(y),01 MSGET cBcoCred2 PICTURE "@!" SIZE 210,08 PIXEL
      @ xLin1(y),01 MSGET cBcoCred3 PICTURE "@!" SIZE 210,08 PIXEL
      
      xLin2(y)
      M->cCONTATO:=cAss1
      @ xLin2(y),01 SAY STR0003 PIXEL //"Assinante"
      @ xLin2(y),01 MSGET M->cCONTATO PICTURE "@!" SIZE 210,08 F3 "E34" PIXEL
      @ xLin1(y),01 MSGET cAss2 PICTURE "@!" SIZE 210,08 F3 "E33" PIXEL
   
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)

End Sequence

cAss1:=M->cCONTATO

Return lRet




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
            
//aAdd(aRegistro,{cPerg,     "01"      ,"Data Invoice De " ,"mv_ch1"    ,"D"      ,08          ,0           ,0          ,"G"     ,"U_ShipData('01')","mv_par01",""})
//aAdd(aRegistro,{cPerg,     "02"      ,"Data Invoice Ate" ,"mv_ch2"    ,"D"      ,08          ,0           ,0          ,"G"     ,"U_ShipData('02')","mv_par02",""})
AADD(aRegistro,{cPerg,     "01"      ,"Invoice No:  "    ,"mv_ch1"    ,"C"      ,20          ,0           ,0          ,"G"     ,"U_ListData('03')","mv_par01","ZZC"})
aAdd(aRegistro,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT"       ,"X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID"        ,"X1_VAR01","X1_F3"})

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

*-------------------------------------------------------------------------*
* FIM DO ARQUIVO EECBOR_RDM.PRW                                           *
*-------------------------------------------------------------------------*
