#include "EECRDM.CH"

/*
Funcao      : PEDIMPLA
Parametros  :
Retorno     :
Objetivos   :
Autor       : Luis Henrique de Oliveira
Data/Hora   : 05/12/01 09:37
Revisao     :
Obs.        :
*/
User Function PEDIMPLA

Local lRet := .t.
Local _aArea := getArea()
Local _cPerg := "PEDIMPLA"

cFileMen:=""

Begin Sequence

IF ! TelaGets(_cPerg)
	Break
Endif                         

cSeqRel := GetSXENum("SY0","Y0_SEQREL")
ConfirmSX8()



dbSelectArea("EE7")
dbSetOrder(3)
_lOkEE7 := dbSeek(xfilial("EE7")+MV_PAR03+MV_PAR04)
While ! EE7->(eof()) .and. EE7->EE7_FILIAL == xfilial("EE7") .AND. ( EE7->EE7_IMPORT+EE7->EE7_IMLOJA == MV_PAR03+MV_PAR04 )
	
	if ! (EE7->EE7_DTPEDI >= MV_PAR01 .and. EE7->EE7_DTPEDI <= MV_PAR02	)
		
		EE7->(dbSkip())
		loop
	Endif
	
	if _lOkEE7
		//CABECALHO DA FILIAL
		dbSelectArea("SM0")
		dbSetOrder(1)
		dbSeek(cEmpAnt+cFilAnt)
		
		HEADER_P->(Add())
		
		HEADER_P->AVG_C01_60	:= ALLTRIM(SM0->M0_FILIAL)  // LOCAL
		HEADER_P->AVG_C02_60 := ALLTRIM(SM0->M0_ENDCOB) + " - " + ALLTRIM(SM0->M0_CIDCOB)+" - "+ALLTRIM(SM0->M0_ESTCOB) + " - "+ALLTRIM(SM0->M0_CEPCOB)+" - BRASIL"
		HEADER_P->AVG_C03_60 := "Fone : "+ALLTRIM(SM0->M0_TEL)+" - Fax : "+ALLTRiM(SM0->M0_FAX)
		HEADER_P->AVG_C04_30 := "CNPJ : "+ALLTRIM(SM0->M0_CGC)+" - Inscr Estadual : "+ALLTRIM(SM0->M0_INSC)
		HEADER_P->AVG_C06_60 := (GETADVFVAL("SA1","A1_NOME",XFILIAL("SA1")+EE7->EE7_IMPORT+EE7->EE7_IMLOJA,1,"") )
		
		HEADER_P->(dbUnlock())
	Endif            

	dbSelectArea("EEC")
	dbSetOrder(14)
	dbSeek(xfilial("EEC")+EE7->EE7_PEDIDO)

	
	_cNrInvoice := ""
	dbSelectArea("EXP")
	dbSetOrder(1)
	if dbSeek(xfilial("EXP")+EEC->EEC_PREEMB)
		_cNrInvoice 	:= EXP->EXP_NRINVO // INVOICE NUMBER
	Endif

	                   
	_nTotQPed := 0
	_nTotQEnt := 0
	
	dbSelectArea("EE8")
	dbSetOrder(1)
	dbSeek(xfilial("EE8")+EE7->EE7_PEDIDO)
	While ! EE8->(eof()) .and. EE8->EE8_PEDIDO == EE7->EE7_PEDIDO
		     
		_cQtdEnt := 0		                                    
		_dDatFat := ctod("")
		dbSelectArea("SC6")
		dbSetOrder(1)
		
		if dbSeek(xfilial("SC6")+EE7->EE7_PEDFAT)
		
    		//ACHA PRODUTO DENTRO DO PEDIDO
			While SC6->C6_PRODUTO <> EE8->EE8_COD_I
				SC6->(dbSkip())                 				
			End			 

			if SC6->C6_PRODUTO == EE8->EE8_COD_I
				_cQtdEnt := SC6->C6_QTDENT
				_dDatFat := SC6->C6_DATFAT
			Endif	
		Endif			                         		
		
		Detail_p->(add())
		Detail_p->AVG_C01_10  := dtoc(EE7->EE7_DTPEDI)
		Detail_p->AVG_C01_20  := EE7->EE7_PEDIDO
		Detail_p->AVG_C03_60  := alltrim(GETADVFVAL("SB1","B1_DESC",XFILIAL("SB1")+EE8->EE8_COD_I,1,"") )
		Detail_p->AVG_C05_10  := transform(EE8->EE8_SLDINI, "@E 99,999,999.99")
		Detail_p->AVG_C03_10  := EE8->EE8_UNIDAD
		Detail_p->AVG_C04_10  := alltrim(str(EE7->EE7_DIASPA))
		Detail_p->AVG_C04_20  := dtoc(_dDatFat)
		Detail_p->AVG_C05_20  := dtoc(EEC->EEC_DTEMBA)
		Detail_p->AVG_C06_20  := _cNrInvoice
		Detail_p->AVG_C07_20  := Transform(_cQtdEnt, "99,999,999.99")
		Detail_p->AVG_C01_60  := EEC->EEC_VIAGEM
		Detail_p->AVG_C02_10  := SC6->C6_NUM
		
		DETAIL_P->AVG_LINHA	  :='A'

		_nTotQPed += EE8->EE8_SLDINI
		_nTotQEnt += _cQtdEnt
                              		
		EE8->(dbSkip())
		          				
		Detail_P->(dbUnlock())
		
	End 
	

	Detail_p->(add())
		Detail_p->AVG_C01_20  := EE7->EE7_PEDIDO
		Detail_p->AVG_C05_10  := transform(_nTotQPed, "@E 99,999,999.99")
		Detail_p->AVG_C07_20  := Transform(_ntotQEnt, "99,999,999.99")
		DETAIL_P->AVG_LINHA	:='B'
    Detail_P->(dbUnlock())
	
	EE7->(dbSkip())
	
End


//*** JBJ - 19/06/01 - 11:56 - Gravar histórico de documentos - (INICIO)

HEADER_H->(dbAppend())
AvReplace("HEADER_P","HEADER_H")

DETAIL_P->(DBSETORDER(0),DbGoTop())

dbSelectArea("DETAIL_P")
copy to ike66

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
	Eval(bAux,EE7->EE7_PEDIDO)
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

AADD(_aRegs,{_cPerg,"01" ,"Da Data ?"                   ,"mv_ch1","D" ,08, 0, "G","mv_par01","","","",""})
AADD(_aRegs,{_cPerg,"02" ,"Até Data ?"                  ,"mv_ch2","D" ,08, 0, "G","mv_par02","","","",""})
AADD(_aRegs,{_cPerg,"03" ,"Cliente ?"                   ,"mv_ch3","C" ,06, 0, "G","mv_par03","SA1","","",""})
AADD(_aRegs,{_cPerg,"04" ,"Loja ?"	                	,"mv_ch4","C" ,02, 0, "G","mv_par04","","","",""})

//AADD(_aRegs,{_cPerg,"05" ,"Até Cliente ?"   		     ,"mv_ch5","C" ,06, 0, "G","mv_par05","SA1","","",""})
//AADD(_aRegs,{_cPerg,"06" ,"Até Loja ?"   	             ,"mv_ch6","C" ,02, 0, "G","mv_par06","","","",""})

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
