#INCLUDE "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTACB0 บAutor  ณAntonio             บ Data ณ  06/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณPrograma para ajustar a CB0 de acordo com o campo ETQPAL    บฑฑ
ฑฑบ          ณe as etiquetas de Pallet                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAP6                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AJUSTACB0()
	Processa({||U_UAJUSTACB0()},"Aguarde...Ajustando Registros da CB0...")
	
Return                   


User Function UAJUSTACB0()

Local cSql     := "" 
Local cAlias1  := GetNextAlias()
Local cAlias2  := GetNextAlias()
Local aArea    := GetArea()
Local cPallet  := ""
Local nQtde    := 0
   

cSql := "SELECT CB0_FILIAL, CB0_PALLET, CB0_CODPRO, CB0_USUARI,  CB0_TIPO "
cSql += "  FROM CB0010 CB0 "
//cSql += " WHERE CB0.CB0_FILIAL = '"+xFilial("CB0")+"' "
cSql += " WHERE CB0.CB0_PALLET <> SPACE(10) "
cSql += "   AND CB0.CB0_TIPO = '01' "
cSql += "   AND CB0.D_E_L_E_T_ = ' ' "
cSql += " GROUP BY CB0_FILIAL, CB0_PALLET, CB0_CODPRO, CB0_USUARI,  CB0_TIPO"
cSql += " ORDER BY CB0_FILIAL, CB0_PALLET, CB0_CODPRO, CB0_USUARI,  CB0_TIPO"
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAlias1,.T.,.T.)
dbGoTop()    

//If (cAlias1)->(! Eof())
//	cPallet := (cAlias1)->CB0_PALLET
//EndIf
 
While (cAlias1)->(! Eof())

	nQtde := 0
	cSql := "SELECT CB0_FILIAL, CB0_CODPRO, SUM( CB0_QTDE ) CB0_QTDE "
	cSql += "  FROM CB0010 CB0 "
//	cSql += " WHERE CB0.CB0_FILIAL = '"+xFilial("CB0")+"' "
	cSql += " WHERE CB0.CB0_PALLET = '"+(cAlias1)->CB0_PALLET+"' "
	cSql += "   AND CB0.CB0_TIPO = '01' "
	cSql += "   AND CB0.D_E_L_E_T_ = ' ' "
	cSql += " GROUP BY CB0_FILIAL,CB0_CODPRO "
	cSql += " ORDER BY 2,1 "
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAlias2,.T.,.T.)
	If (cAlias2)->(! Eof())
		nQtde    := (cAlias2)->CB0_QTDE          
    EndIf
    
	(cAlias2)->(dbCloseArea())

	CB0->(dbSetOrder(1))
	If CB0->(dbSeek((cAlias1)->CB0_FILIAL+(cAlias1)->CB0_PALLET ))
		RecLock("CB0",.F.)
		CB0->CB0_TIPO   := '01'
		CB0->CB0_USUARI := RetCodUsr()
		CB0->CB0_QTDE   := nQtde
		CB0->CB0_CODPRO := (cAlias1)->CB0_CODPRO
		CB0->CB0_ETQPAL := 'S'
		CB0->(MsUnlock())
	Else
		RecLock("CB0",.T.)
		CB0->CB0_FILIAL := (cAlias1)->CB0_FILIAL
		CB0->CB0_CODETI := (cAlias1)->CB0_PALLET
		CB0->CB0_DTNASC := dDataBase
		CB0->CB0_TIPO   := '01'
		CB0->CB0_USUARI := RetCodUsr()
		CB0->CB0_QTDE   := nQtde
		CB0->CB0_CODPRO := (cAlias1)->CB0_CODPRO
		CB0->CB0_ETQPAL := 'S'
		CB0->(MsUnlock())
	EndIf

	(cAlias1)->(dbSkip())

Enddo

(cAlias1)->(dbCloseArea())

Return .T.


