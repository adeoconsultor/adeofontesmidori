#INCLUDE "AvPrint.ch"  
#INCLUDE "Font.ch"  
#INCLUDE "rwmake.ch"       
#INCLUDE "topconn.ch"
#INCLUDE "Average.ch"
#include "EECRDM.CH"

#define NUMLINPAG 23

//Static aMarcados := {}, nMarcados  
//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: SOLRE
//|Autor.....: Robson Sanchez Dias - robson@dqzafra.com.br
//|Data......: 10/07/09
//|Uso.......: SIGAEIC   
//|Versao....: Protheus - 10.1    
//|Descricao.: Impressao de Solicitacao de Faturamento
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function EECSALES()      
*-----------------------------------------*
Local lRet:=.t.
Private cPerg     := Avkey("EECSALES","X1_GRUPO")
             
PRIVATE nLin :=0,nPag := 1


//EXP->(dbsetorder(2))                            
//EEC->(dbsetorder(1))

//nRecEEC:=EEC->(RECNO())

//E_ARQCRW(.T.,.T.,.T.)                   

Begin Sequence

   IF ! TelaGets()
      lRet := .f.
      Break
   Endif

   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()

   // adicionar registro no HEADER_P
   HEADER_P->(DBAPPEND())
   HEADER_P->AVG_FILIAL:=xFilial("SY0")
   HEADER_P->AVG_SEQREL:=cSEQREL
   HEADER_P->AVG_CHAVE :=cSEQREL
   
   cData:=DTOC(mv_par01)+" A "+DTOC(mv_par02)
   
   RepFile("H","01","20",cData)   

   GravaItens()
   
   HEADER_P->(dbUnlock())

End Sequence
               
/*
If lRet
   AvgCrw32("RELSALES.RPT","SALES REPORT" + cSeqRel,cSEQREL,,,.F.)
Endif
*/

Return .t.

Static Function GravaItens()

Local cSql:=""

cSql:="SELECT EE9.EE9_FPCOD,EEC.EEC_IMPORT,INV.EXP_NRINVO,EE9.EE9_DESC,EE9_SLDINI,EE9_EMB,EE9_PRECOI,EE9_SLDINI*EE9_PRECOI 'FOBTOT', "
cSql+="0 'COMISS', EE9_SLDINI*EE9_PRECOI 'FOBSCOMI' "  
cSql+="FROM "+RetSqlName("EEC")+" EEC, "+RetSqlName("EE9")+" EE9, "+RetSqlName("EXP")+" INV "
cSql+="WHERE EEC.EEC_FILIAL = '"+xFilial('EEC')+"' AND EE9.EE9_FILIAL = '"+xFilial('EE9')+"' AND INV.EXP_FILIAL ='"+xFilial('EXP')+"' AND "
cSql+="EEC.EEC_DTPROC BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' AND "
cSql+="EE9.EE9_PREEMB = EEC.EEC_PREEMB AND INV.EXP_PREEMB = EEC.EEC_PREEMB AND "
cSql+="      EE9.D_E_L_E_T_ <> '*' AND EEC.D_E_L_E_T_  <> '*' AND INV.D_E_L_E_T_ <> '*' "
cSql+="ORDER BY EE9.EE9_FPCOD,EEC.EEC_IMPORT,INV.EXP_NRINVO "

If Select("SQL") # 0
   SQL->(E_EraseArq("SQL")) 
EndIf

dbUseArea( .T., "TOPCONN"     , TCGENQRY(,,cSql),"SQL", .F., .T.)
TCSetField("SQL", "EE9_SLDINI", "N",15,3)
TCSetField("SQL", "EE9_PRECOI", "N",18,8)
TCSetField("SQL", "FOBTOT"    , "N",18,2)
TCSetField("SQL", "COMISS"    , "N",15,2)
TCSetField("SQL", "FOBSCOMI"  , "N",15,2)

SQL->(dbgotop())
While ! SQL->(eof()) 

  syc->(dbseek(xFilial('SYC')+SQL->EE9_FPCOD))
                                              
  SA1->(DBSEEK(xFilial("SA1")+SQL->EEC_IMPORT))
  
  cMemo    :=MSMM(SQL->EE9_DESC,AVSX3("EE9_VM_DES",3))
  cProduto :=MemoLine(cMemo,AVSX3("EE9_VM_DES",3),1)

  AppendDet()             

     RepFile("D","01","10",SQL->EE9_FPCOD)
     RepFile("D","01","60",SYC->YC_NOME)
     RepFile("D","02","10",SQL->EEC_IMPORT)
     RepFile("D","01","20",SA1->A1_NREDUZ)
     RepFile("D","02","20",SQL->EXP_NRINVO)
     RepFile("D","02","60",Left(cProduto,60))
     
     RepFile("D","06","17",SQL->EE9_SLDINI,"N")
     RepFile("D","01","04",VAL(SQL->EE9_EMB),"N")
     RepFile("D","02","15",SQL->EE9_PRECOI,"N")
     RepFile("D","03","15",SQL->FOBTOT,"N")
     RepFile("D","04","15",SQL->COMISS,"N")
     RepFile("D","05","15",SQL->FOBSCOMI,"N")
     
     UnLockDet()
     
     SQL->(dbskip())
End

Return .t.

Static Function Repfile(cSigla,cPar1,cPar2,cValor,cTipo)

Local cFile:="HEADER_P"

cCampo:="AVG_"+VALTYPE(cValor)+cPar1+If(Len(cPar2)<=2,"_","")+cPar2

If Valtype(cValor) == "C"
   cValor:=Alltrim(cValor)
Endif

cTipo:=If(cTipo==NIL,"C",cTipo)

If cSigla == "D"   // Grava Detail_P
   cFile:="DETAIL_P"
Endif

(cFile)->(FIELDPUT(FIELDPOS(cCampo),cValor))

Return .t.



/*
Funcao      : AppendDet
Parametros  : 
Retorno     : 
Objetivos   : Adiciona registros no arquivo de detalhes
Autor       : Cristiano A. Ferreira 
Data/Hora   : 05/05/2000
Revisao     : 
Obs.        :
*/
Static Function AppendDet()

Begin Sequence
   nLin := nLin+1
   IF nLin > NUMLINPAG
      nLin := 1
      nPag := nPag+1
   ENDIF
   DETAIL_P->(dbAppend())
   DETAIL_P->AVG_FILIAL := xFilial("SY0")
   DETAIL_P->AVG_SEQREL := cSEQREL
   DETAIL_P->AVG_CHAVE  := cSEQREL
   DETAIL_P->AVG_CONT   := STRZERO(nPag,6,0)
End Sequence

Return .t.

/*
Funcao      : UnlockDet
Parametros  : 
Retorno     : 
Objetivos   : Desaloca registros no arquivo de detalhes
Autor       : Cristiano A. Ferreira 
Data/Hora   : 05/05/2000
Revisao     : 
Obs.        :
*/
Static Function UnlockDet()

Begin Sequence
   DETAIL_P->(dbUnlock())
End Sequence

Return NIL


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
   
Local lRet := .t.

  
DEFINE FONT oFont NAME "Courier New" SIZE 0,15

Begin Sequence

   VERPERGSX1()
    
   IF ! Pergunte(cPerg,.T.)
      lRet:=.f.
      Break
   Endif
                  
End Sequence

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
            
aAdd(aRegistro,{cPerg,     "01"      ,"Data Processo De " ,"mv_ch1"    ,"D"      ,08          ,0           ,0          ,"G"     ,"U_ShipData('01')","mv_par01",""})
aAdd(aRegistro,{cPerg,     "02"      ,"Data Processo Ate" ,"mv_ch2"    ,"D"      ,08          ,0           ,0          ,"G"     ,"U_SaleData('02')","mv_par02",""})
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


//+-----------------------------------------------------------------------------------//
//|Funcao....: U_SaleData()
//|Descricao.: Valida datas informadas nas perguntas
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function SaleData(cMV)
*-----------------------------------------*
Local cRet     := .T.
Local cTitulo  := "Inconsistencia de Dados"

Do Case
	Case cMV == '01'    
	    If Empty(MV_PAR01)
			Aviso( cTitulo, "Data de Processo Inicial deve ser informada", {"Ok"} )
	        cRet:=.F.
	    Endif
	    
		If !Empty(MV_PAR02) .AND. MV_PAR01 > MV_PAR02
			Aviso( cTitulo, "Data de Processo Inicial não pode ser maior que a Final", {"Ok"} )
			cRet := .F.
		EndIf		
	Case cMV == '02'	

	    If Empty(MV_PAR02)
			Aviso( cTitulo, "Data de Processo Final deve ser informada", {"Ok"} )
	        cRet:=.F.
	    Endif

		If !Empty(MV_PAR01) .AND. MV_PAR01 > MV_PAR02
			Aviso( cTitulo, "Data de Processo Final não pode ser menor que a Inicial", {"Ok"} )
			cRet := .F.
		EndIf
End Case
Return cRet