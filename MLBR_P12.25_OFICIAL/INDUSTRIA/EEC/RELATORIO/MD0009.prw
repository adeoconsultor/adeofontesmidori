#INCLUDE "EECPEM09.ch"
#include "EECRDM.CH"

/*
Funcao      : MD0009
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Luis Henrique de Oliveira
Data/Hora   : 02/12/01 09:37
Revisao     :
Obs.        :
*/
User Function MD0009

Local lRet := .t.
Local _aArea := getArea()
Local _cMercadoria := ""
Local _aMensagem := {}  
Local _cPerg := "MD0009"

Private mDet := ""
Private mDetalhe:= ""


cFileMen:=""

Begin Sequence
   
   	IF ! TelaGets(_cPerg)
    	Break
   	Endif              
   	
	cSeqRel := GetSXENum("SY0","Y0_SEQREL")
	ConfirmSX8()

   // ** Nome do Beneficiario.
   IF !Empty(EEC->EEC_EXPORT)
      SA2->(DbSeek(xFilial("SA2")+EEC->EEC_EXPORT))
   Else
      SA2->(DbSeek(xFilial("SA2")+EEC->EEC_FORN))
   Endif

   cExpMun := Alltrim(SA2->A2_MUN)
                       
	HEADER_P->(Add())                    
	
//CABECALHO DA FILIAL
dbSelectArea("SM0")
dbSetOrder(1)
dbSeek(cEmpAnt+cFilAnt)


HEADER_P->AVG_C08_60 := ALLTRIM(SM0->M0_ENDCOB) + " - " + ALLTRIM(SM0->M0_CIDCOB)+" - "+ALLTRIM(SM0->M0_ESTCOB)
HEADER_P->AVG_C05_20 := ALLTRIM(SM0->M0_CEPCOB)+" - BRASIL"
HEADER_P->AVG_C06_30 := "Fone : "+ALLTRIM(SM0->M0_TEL)
HEADER_P->AVG_C07_30 :=+" - Fax : "+ALLTRiM(SM0->M0_FAX)
HEADER_P->AVG_C08_30 := "CNPJ : "+ALLTRIM(SM0->M0_CGC)
HEADER_P->AVG_C09_30 :=+" - Inscr Estadual : "+ALLTRIM(SM0->M0_INSC)
	
	
                                          
	HEADER_P->AVG_C01_60:= alltrim(EEC->EEC_IMPODE) + " / "+MV_PAR01	//SACADO  
                          
   	HEADER_P->AVG_C02_60:= Upper(cMonth(dDataBase))+" "+AllTrim(Str(Day(dDataBase)))+", "+Str(Year(dDataBase),4)
                                           
	HEADER_P->AVG_C03_60	:= ALLTRIM(SM0->M0_FILIAL) +" / "+ALLTRIM(EEC->EEC_RESPON) // LOCAL / RESPONSAVEL           
           
	dbSelectArea("EXP")
	dbSetOrder(1)                                  
	if dbSeek(xfilial("EXP")+EEC->EEC_PREEMB)
		HEADER_P->AVG_C01_20 	:= EXP->EXP_NRINVO // INVOICE NUMBER
	Endif

   	HEADER_P->(dbUnlock())

    

   //executar rotina de manutencao de caixa de texto
	//   lRet := E_AVGLTT("M",WORKID->EEA_TITULO,"AVG_C01150")

	
	//*** JBJ - 19/06/01 - 11:56 - Gravar histórico de documentos - (INICIO)
	
	HEADER_H->(dbAppend())
	AvReplace("HEADER_P","HEADER_H")
	
	DETAIL_P->(DBSETORDER(0),DbGoTop())
	Do While ! DETAIL_P->(Eof())
		DETAIL_H->(DbAppend())
		AvReplace("DETAIL_P","DETAIL_H")
		DETAIL_P->(DbSkip())
	EndDo
	DETAIL_P->(DBSETORDER(1))
	//*** (FIM)
	HEADER_P->(DBCOMMIT())
	DETAIL_P->(DBCOMMIT())




End Sequence
                                                        
IF(SELECT("Work_Men")>0,Work_Men->(E_EraseArq(cFileMen)),)

RestArea(_aArea)
Return lRet

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Heder M Oliveira
Data/Hora   : 
Revisao     : Jeferson Barros Jr.
Data/Hora   : 05/12/03 - 15:00.
Obs.        :
*/
*-----------------------*
Static Function TelaGets(_cPerg)
*-----------------------*
Local lRet := .t.
                
CriaSX1(_cPerg)
Pergunte(_cPerg,.T.) // Pergunta no SX1

Return lRet 


/*
Funcao      : Add
Parametros  :
Retorno     :
Objetivos   :
Autor       : Cristiano A. Ferreira
Data/Hora   : 21/01/2000 16:37
?Revisao     :
Obs.        :
*/
Static Function Add

Begin Sequence
dbAppend()

bAux:=FieldWBlock("AVG_FILIAL",Select())

IF ValType(bAux) == "B"
	Eval(bAux,xFilial("SY0"))
Endif

bAux:=FieldWBlock("AVG_CHAVE",Select())

IF ValType(bAux) == "B"
	Eval(bAux,EEC->EEC_PREEMB)
Endif

bAux:=FieldWBlock("AVG_SEQREL",Select())

IF ValType(bAux) == "B"
	Eval(bAux,cSeqRel)
Endif
End Sequence

Return NIL



******************************************************************************************************************
*   FIM DO RDMAKE EECPEM09_RDM																					 *
******************************************************************************************************************




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


AADD(_aRegs,{_cPerg,"01" ,"Contato :"                   ,"mv_ch1","C" ,20, 0, "G","mv_par01","","","",""})



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
		MsUnlock()
	EndIF
Next i

RestArea(_aArea)

Return
