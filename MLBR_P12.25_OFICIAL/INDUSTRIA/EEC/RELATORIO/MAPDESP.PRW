#include "EECRDM.CH"

/*
Funcao      : MAPDESP
Parametros  :
Retorno     :
Objetivos   :
Autor       : Luis Henrique de Oliveira
Data/Hora   : 02/12/01 09:37
Revisao     :
Obs.        :
*/
User Function MAPDESP

Local lRet := .t.
Local _aArea := getArea()
Local _cPerg := "MAPDESP"

cFileMen:=""



Begin Sequence

IF ! TelaGets(_cPerg)
	Break
Endif

dbSelectArea("EEC")
dbSetOrder(2)
dbSeek(xfilial("EEC")+dtos(MV_PAR01),.T.)
if !eof() .and. EEC->EEC_FILIAL == xfilial("EEC") .AND. dtos(EEC->EEC_DTPROC) >= DTOS(MV_PAR01) .and. dtos(EEC->EEC_DTPROC) <= DTOS(MV_PAR02)
	
	
	cSeqRel := GetSXENum("SY0","Y0_SEQREL")
	ConfirmSX8()
	
	
	//CABECALHO DA FILIAL
	dbSelectArea("SM0")
	dbSetOrder(1)
	dbSeek(cEmpAnt+cFilAnt)
	
	HEADER_P->(Add())
	
	HEADER_P->AVG_C01_60	:= ALLTRIM(SM0->M0_FILIAL)  // LOCAL
	HEADER_P->AVG_C02_60 := ALLTRIM(SM0->M0_ENDCOB) + " - " + ALLTRIM(SM0->M0_CIDCOB)+" - "+ALLTRIM(SM0->M0_ESTCOB) + " - "+ALLTRIM(SM0->M0_CEPCOB)+" - BRASIL"
	HEADER_P->AVG_C03_60 := "Fone : "+ALLTRIM(SM0->M0_TEL)+" - Fax : "+ALLTRiM(SM0->M0_FAX)
	HEADER_P->AVG_C04_30 := "CNPJ : "+ALLTRIM(SM0->M0_CGC)+" - Inscr Estadual : "+ALLTRIM(SM0->M0_INSC)
	
	_nTotFrete_INTER := 0
	_nTotHonor_SHIP := 0
	_nTotOther_SHIP := 0
	_nTotVLFOB := 0
	_nTotFRPREV := 0
	_nTotFRPCOM := 0
	_nTotDESPIN := 0
	_nTotGeral := 0
	
	HEADER_P->(dbUnlock())
	
	dbSelectArea("EEC")
	While !eof() .and. EEC->EEC_FILIAL == xfilial("EEC") .AND. dtos(EEC->EEC_DTPROC) >= DTOS(MV_PAR01) .and. dtos(EEC->EEC_DTPROC) <= DTOS(MV_PAR02)
		
		Detail_p->(add())
		Detail_p->AVG_C01_10  := EEC->EEC_NRINVO
		Detail_p->AVG_C01_20  := GETADVFVAL("SA1","A1_NREDUZ",XFILIAL("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA,1,"")
		Detail_p->AVG_C02_10  := transform(EEC->EEC_VLFOB,"@E 999,999.99")           	//FOB VALUE
		
		_nHonor_SHIP := 0
		_nOther_SHIP := 0
		_cRef_SHIP := ""
		_cCodAge_SHIP := ""
		
		_nFrete_INTER 	:= 0
		_nFrete_TRANSP := 0
		_nAdVal_TRANSP := 0
		
		
		dbSelectArea("EET")
		dbSetOrder(1)
		dbSeek(xfilial("EET")+EEC->EEC_PEDREF)
		While ! eof() .and. xfilial("EET")+EEC->EEC_PEDREF == EET->EET_FILIAL+EET->EET_PEDIDO
			
			
			
			IF EET->EET_DESPES == "404"  //HONORARIOS
				_nHonor_SHIP += EET->EET_VALORR
				_cRef_SHIP	:= EET->EET_DOCTO
				_cCodAge_SHIP := EET->EET_CODAGE
			Elseif EET->EET_DESPES == "406"
				_nFrete_TRANSP += EET->EET_VALORR
			Elseif EET->EET_DESPES == "440"
				_nAdVal_TRANSP += EET->EET_VALORR
			Elseif EET->EET_DESPES == "102"
				_nFrete_INTER += EET->EET_VALORR
				
			Else
				_nOther_SHIP += EET->EET_VALORR
			Endif
			
			EET->(dbSkip())
		End
		
		
		Detail_p->AVG_C03_10  := transform(_nFrete_INTER,"@E 999,999.99")			// SEA/AIR FREIGHT  - SHIPPING CO
		
		Detail_p->AVG_C04_10  := _cCodAge_SHIP			// DESPACHANTE 	- FORWARDER
		Detail_p->AVG_C05_10  := _cRef_SHIP				// REF#  NF		- FORWARDER
		Detail_p->AVG_C10_20  := transform(_nHonor_SHIP,"@E 999,999.99")			// HONOR R$		- FORWARDER
		Detail_p->AVG_C02_20  := transform(_nOther_SHIP,"@E 999,999.99")           // OTHER COSTS 	- FORWARDER
		
		dbSelectArea("EE7")
		dbSetOrder(1)
		dbSeek(xfilial("EE7")+EEC->EEC_PEDREF)
		if ! EE7->(eof())
			
			Detail_p->AVG_C02_60  := GETADVFVAL("SA4","A4_NREDUZ",XFILIAL("SA4")+EE7_XTRANS,1,"")			// TRANSP 		- TRANSPORT
			Detail_p->AVG_C03_20  := ""										   										// REF# MINUTA 	- TRANSPORT
			Detail_p->AVG_C04_20  := transform(EE7->EE7_FRPREV,"@E 999,999.99")										// FREIGHT		- TRANSPORT
			Detail_p->AVG_C05_20  := transform(EE7->EE7_FRPCOM,"@E 999,999.99")										// AD VALOREN	- TRANSPORT
			Detail_p->AVG_C06_20  := transform(EE7->EE7_DESPIN,"@E 999,999.99")				     					// OTHER COSTS 	- TRANSPORT
			
		Endif
		
		_nTotFrete_INTER += _nFrete_INTER
		_nTotHonor_SHIP += _nHonor_SHIP
		_nTotOther_SHIP += _nOther_SHIP
		
		_nTotVLFOB += EEC->EEC_VLFOB
		_nTotFRPREV += EE7->EE7_FRPREV
		_nTotFRPCOM += EE7->EE7_FRPCOM
		_nTotDESPIN += EE7->EE7_DESPIN
		
		_nTotLinha := _nHonor_SHIP+_nOther_SHIP+EE7->EE7_FRPREV+EE7->EE7_FRPCOM+EE7->EE7_DESPIN
		_nTotGeral += _nTotLinha
		
		Detail_p->AVG_C07_20  := "0,00"						// OTHER COSTS NEEDED
		Detail_p->AVG_C08_20  := transform(_nTotLinha,"@E 999,999.99")   // TOTAL
		Detail_p->AVG_C09_20  := "0,00"						// % COST US$/FOB
		Detail_p->AVG_C01_60  := ""						// OBS
		Detail_p->AVG_LINHA	  := "A"
		
		Detail_P->(dbUnlock())
		
		
		EEC->(dbSkip())
		
	End
	
	
	Detail_p->(add())
	Detail_p->AVG_C02_10  := transform(_nTotVLFOB,"@E 99,999,999.99")           	//FOB VALUE	
	Detail_p->AVG_C03_10  := transform(_nTotFrete_INTER,"@E 999,999.99")			// SEA/AIR FREIGHT  - SHIPPING CO
	Detail_p->AVG_C10_20  := transform(_nTotHonor_SHIP,"@E 999,999.99")			// HONOR R$		- FORWARDER
	Detail_p->AVG_C02_20  := transform(_nTotOther_SHIP,"@E 999,999.99")           // OTHER COSTS 	- FORWARDER
	Detail_p->AVG_C04_20  := transform(_nTotFRPREV,"@E 999,999.99")										// FREIGHT		- TRANSPORT
	Detail_p->AVG_C05_20  := transform(_nTotFRPCOM,"@E 999,999.99")										// AD VALOREN	- TRANSPORT
	Detail_p->AVG_C06_20  := transform(_nTotDESPIN,"@E 999,999.99")				     					// OTHER COSTS 	- TRANSPORT
	Detail_p->AVG_C08_20  := transform(_nTotGeral,"@E 999,999.99")   // TOTAL
	Detail_p->AVG_LINHA	  := "B"	
	Detail_P->(dbUnlock())
	
	
	
	
	
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
	
	dbSelectArea("DETAIL_P")
	COPY TO IKE66.DBF
	
	//*** (FIM)
	HEADER_P->(DBCOMMIT())
	DETAIL_P->(DBCOMMIT())
	
	
Endif


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
	Eval(bAux,cSeqRel)
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
AADD(_aRegs,{_cPerg,"02" ,"Até Data ?"                   ,"mv_ch2","D" ,08, 0, "G","mv_par02","","","",""})

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
