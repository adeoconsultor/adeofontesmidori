#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*                                                                  
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGP110ACT  บAutor  ณPrimaInfo           บ Data ณ  08/01/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Altera SRZ antes da contabilizacao para tratamento dos     บฑฑ
ฑฑบ          ณ autonomos                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MIDORI                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GP110ACT

Local n

_aArea       := GetArea()
cQuery_    	 := ""
_aVlAuto     := {}


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Selecionando dados com Query       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery_ := "SELECT RZ_FILIAL, RZ_CC, RZ_ITEM, RZ_CLVL, RZ_PD, SUM(RZ_VAL) AS TOTAL "
cQuery_ += " FROM " + RETSQLNAME("SRZ") + ' SRZ, '  + RetSqlName('SRA')+ ' SRA' 
cQuery_ += " WHERE SRZ.RZ_FILIAL = SRA.RA_FILIAL "
cQuery_ += " AND SRZ.RZ_MAT = SRA.RA_MAT "
cQuery_ += " AND SRA.RA_CATFUNC = 'A' "
cQuery_ += " AND SRA.D_E_L_E_T_ <> '*' "
cQuery_ += " AND SRZ.D_E_L_E_T_ <> '*' "
cQuery_ += " GROUP BY RZ_FILIAL, RZ_CC, RZ_ITEM, RZ_CLVL, RZ_PD "
cQuery_ += " ORDER BY RZ_FILIAL, RZ_CC, RZ_ITEM, RZ_CLVL, RZ_PD "
cQuery_ := CHANGEQUERY(cQuery_)                  

/* FORMA ANTIGA
//cQuery_ += " WHERE SUBSTRING(RZ_MAT,1,2) = '99' "
//cQuery_ += " AND D_E_L_E_T_ <> '*' " 
*/
                                   
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria alias conforme resultado da query ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If Select("ARQTRB") >0
	dbSelectArea("ARQTRB")
    dbCloseArea()
EndIf

TCQUERY cQuery_ NEW ALIAS "ARQTRB"  

                                                                     
DBSelectArea("ARQTRB") 
dbGoTop()          

While !ARQTRB->(Eof())

	aAdd(_aVlAuto,{ARQTRB->RZ_FILIAL,;
				 ARQTRB->RZ_CC,;
				 ARQTRB->RZ_ITEM,;
				 ARQTRB->RZ_CLVL,;
				 ARQTRB->RZ_PD,;
				 ARQTRB->TOTAL;
				 })

	ARQTRB->(dbSkip())
	Loop
EndDo

dbSelectArea("SRZ")
dbGotop()
dbSetOrder(4)

For n:=1 to Len(_aVlAuto)
	
	If(DbSeek( _aVlAuto[n,1] + _aVlAuto[n,2] + _aVlAuto[n,3] + _aVlAuto[n,4] + _aVlAuto[n,5] + "1" + "zzzzzz" ))
		RecLock( "SRZ", .F. )
			SRZ->RZ_VAL     := (SRZ->RZ_VAL - _aVlAuto[n,6])
		msUnlock()

		RecLock( "SRZ", .T. )
			SRZ->RZ_FILIAL  := _aVlAuto[n,1]
			SRZ->RZ_MAT     := "zzzzzz"
			SRZ->RZ_CC      := _aVlAuto[n,2]
			SRZ->RZ_PD      := _aVlAuto[n,5]
			SRZ->RZ_HRS     := 0
			SRZ->RZ_VAL     := If(_aVlAuto[n,5] == "748",0,_aVlAuto[n,6])
			SRZ->RZ_OCORREN := 0
			SRZ->RZ_TIPO    := "FL"
			SRZ->RZ_TPC     := "2"
			SRZ->RZ_ITEM    := _aVlAuto[n,3]
			SRZ->RZ_CLVL    := _aVlAuto[n,4]
		msUnlock()
	EndiF

Next n

RestArea(_aArea)


Return
