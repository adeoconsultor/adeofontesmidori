#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'             
/*---------------------------------------------------------
Funca: xAltDtEnt()     |Autor: AOliveira    |Data:31-01-12
-----------------------------------------------------------
Desc.: Rotina tem como objetivo editar o campo C8_PRAZO, 
       calculando a Dt.Emissao menos Dt.Entrega
-----------------------------------------------------------
Retorno: dias para entrega (numerico).  
-----------------------------------------------------------
Obs.: Incluir a Chama da função no dicionario de dados
      X3_When do campo.
-----------------------------------------------------------
Chamado: 004256                                            
-----------------------------------------------------------
MAnutenção por Vinicius S. Schwartz - TI - Midori Atlantica
Motivo: Algumas vezes retornada o prazo que não correspon-
	dia a data digitada.
Data: 17/05/2012
---------------------------------------------------------*/
User Function xAltDtEnt()
Local cGetData   := dA150Emis + M->C8_PRAZO //CtoD(" / / ")
Local nOpc := 0
Private oDlg1,oSay1,oGetData,oSBOK,oSBCAN  


oDlg1      := MSDialog():New( 091,232,213,475,"Data de Entrega",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 015,005,{||"Data de Entrega:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGetData   := TGet():New( 012,051,{|u| If(PCount()>0,cGetData:=u,cGetData)},oDlg1,057,008,'',{||xValid(cGetData)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetData",,)
oSBOK      := SButton():New( 036,026,1,{||nOpc:=1,oDlg1:End()},oDlg1,,"", )
oSBCAN     := SButton():New( 036,068,2,{||oDlg1:End()},oDlg1,,"", )

oDlg1:Activate(,,,.T.) 
                                                 
If (nOpc == 1)
	M->C8_PRAZO := (cGetData - dA150Emis)
Endif


Return (.T.)                                                    

/*---------------------------------------------------------
Funcao: xValid(cGetData) | Autor: AOliveira  |Data:31-01-12
-----------------------------------------------------------
Desc.: Valida Dt informada.
----------------------------------------------------------*/
Static Function xValid(cGetData)
Local lRet := .F.

If (cGetData >= dA150Emis)
	lRet:= .T.            
Else
	MsgStop("Data Informada. Menor que a data de Emissão!","Atenção")
End

Return(lRet)