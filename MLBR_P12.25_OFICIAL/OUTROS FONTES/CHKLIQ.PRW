#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  CHKLIQ  บAutor  ณExclusiverp         บ Data ณ  16/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relacao de Diferencas de LIquidos                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RELACON                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบ DATA     ณPROGRAMADORณ   ALTERACAO                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑณ06.01.2006ณJOSE CARLOSณQUERY,PESQUISA SRV E IMPRESSAO C/ FUNCAO IMPR   ณฑฑ
ฑฑณ          ณ           ณ                                                ณฑฑ
ฑฑณ          ณ           ณ                                                ณฑฑ
ฑฑณ          ณ           ณ                                                ณฑฑ
ฑฑณ          ณ           ณ                                                ณฑฑ
ฑฑณ          ณ           ณ                                                ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ChkLiq()

// Declara Variaveis
Local   cDesc1   	:= "DIFERENCA DE LIQUIDOS "
Local   cDesc2   	:= "Sera impresso de acordo com os parametros solicitados pelo"
Local   cDesc3   	:= "usuario."
Local   cString  	:= "SRC"
Private nLastKey 	:= 0
Private NomeProg 	:= "CHKLIQ"
Private Tamanho  	:= "P"
Private Titulo   	:= "Diferenca de Liquidos " + MesExtenso(dDataBase) + "/"+Strzero(year(dDataBase),4)
Private wCabec1  	:= "Fl Matric  Nome                         Valor Somado   Valor Calculado Diferenca"
Private wCabec2  	:= ""
Private cDet	 	:= ""
Private WnRel    	:= "CHKLIQ"
Private nOrdem   	:= 1
Private Li       	:= 0
Private m_pag    	:= 1
Private ContFl   	:= 1 
Private aReturn  	:= {"Zebrado",1,"Administracao",1,2,1,"",1}
Private cPerg    	:= "CHKLIQ"
Private cCancel		:= "Cancelado Pelo Operador"
Private lAbortPrint	:= .F.

//Verifica Perguntas
fChkPerg()

Pergunte(cPerg,.T.)

//Abre tela de Impressao
WnRel:=SetPrint(cString,WnRel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
EndIf

//Executa o relatorio
RptStatus({|lEnd| ImpRel(@lEnd,WnRel,cString)},titulo)

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ IMPREL   บ Autor ณReginaldo           บ Data ณ  16/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ Relacon                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function IMPREL(lEnd,WnRel,cString)

Local cQuery  	:= ""
Local cFilDe	:= ""
Local cFilAte	:= ""
Local cCodLiq	:= ""
Local nPos		:= 0
Local nX		:= 0
Local nDif		:= 0
Local nTotDif	:= 0
Local aFunc 	:= {}

//Variaveis das Perguntas
cFilDe	:= mv_par01
cFilAte	:= mv_par02

//Monta query de Pesquisa no SRC    
cQuery := "SELECT RC_FILIAL, RC_MAT,'1' AS TIPO ,SUM(RC_VALOR) AS TOTFUN "

cQuery += "FROM " + RetSqlName("SRC") + ","  + RetSqlName("SRV") + " "

cQuery += "WHERE RC_FILIAL >= '" + cFilDe + "' AND RC_FILIAL <= '" + cFilAte + "' "
cQuery += "AND RC_PD = RV_COD "
cQuery += "AND RV_TIPOCOD = '1' "
cQuery += "AND " + RetSqlName("SRC") + ".D_E_L_E_T_ = ' ' "
cQuery += "AND " + RetSqlName("SRV") + ".D_E_L_E_T_ = ' ' "

cQuery += "GROUP BY RC_FILIAL,RC_MAT "

cQuery += "UNION "

cQuery += "SELECT RC_FILIAL, RC_MAT,'2' AS TIPO ,SUM(RC_VALOR) AS TOTFUN "

cQuery += "FROM " + RetSqlName("SRC") + " , "  + RetSqlName("SRV") + " "

cQuery += "WHERE RC_FILIAL >= '"+ cFilDe + "' AND RC_FILIAL <= '" + cFilAte + "' "
cQuery += "AND RC_PD = RV_COD "
cQuery += "AND RV_TIPOCOD = '2' "
cQuery += "AND " + RetSqlName("SRC") + ".D_E_L_E_T_ = ' ' "
cQuery += "AND " + RetSqlName("SRV") + ".D_E_L_E_T_ = ' ' "

cQuery += "GROUP BY RC_FILIAL,RC_MAT "

cQuery += "ORDER BY RC_FILIAL,RC_MAT,TIPO "   

cQuery := ChangeQuery(cQuery)

//Abrir Tabela
dbUseArea(.T.,"TopConn",TcGenQry(,,cQuery),"TRB",.T.,.T.)

TRB->(dbGoTop())

ProcRegua(TRB->(RecCount()))

While TRB->(!Eof())

    IF !TRB->RC_FILIAL $ fValidFil()
       TRB->(DbSkip())
       Loop
    EndIF   

    If ( nPos := Ascan(aFunc,{ |X| x[1] = TRB->RC_FILIAL .and. x[2] = TRB->RC_MAT } )) > 0

       If TRB->TIPO = "1"
          aFunc[nPos,4] += TRB->TOTFUN
       Else   
          aFunc[nPos,4] -= TRB->TOTFUN 
       EndIF

    Else
       aAdd(aFunc,{TRB->RC_FILIAL,TRB->RC_MAT,TRB->TIPO,TRB->TOTFUN})
    EndIF
    
    TRB->(DbSkip())
    
	IncProc("Selecionando Registros.....")    

EndDO             

TRB->(dbCloseArea())

SetRegua(Len(aFunc))

//Pesquisa Codigo Verba Liquido
SRV->(dbSetOrder(2)) //Identificador de Calculo
	
SRV->(dbSeek(xFilial("SRV") + "047"))
cCodLiq := SRV->RV_COD

For nX := 1 to Len(aFunc)

	IncRegua("Imprimindo........")
	
	//Abortado Pelo Operador
	If lAbortPrint
		cDet := cCancel
		Impr(cDet,'C')
		Exit
	EndIF			
     	
	nLiq := 0
	
	If SRC->(DbSeek(aFunc[nX,1] + aFunc[nX,2] + cCodLiq))
	
	   While aFunc[nX,1] + aFunc[nX,2] + cCodLiq == SRC->RC_FILIAL + SRC->RC_MAT + SRC->RC_PD

	      nLiq += SRC->RC_VALOR
	      SRC->(DbSkip())
	      
	   EndDo 
	     
	EndIf
	
	If aFunc[nX,4] != nLiq
		
		nDif := aFunc[nX,4] - nLiq
		
 		cDet := aFunc[nX,1] + "-" + aFunc[nX,2] + "-" + Posicione("SRA",1,aFunc[nX,1] + aFunc[nX,2],"RA_NOME") 
 		cDet += Transform(AFunc[nX,4], '@E 9,999,999.99') + Transform(nLiq, '@E 9,999,999.99') 
 		cDet += Space(2) + Transform(nDif, '@E 9,999,999.99') 
        
 		Impr(cDet,"C")
 		
 		//Totaliza Diferenca
 		nTotDif += nDif
 		
	EndIF
	      
Next 

cDet := Replicate("-",80)
Impr(cDet,"C")

//Imprime Total
cDet := Space(45) + "Total da Diferenca   " + Transform(nTotDif, '@E 9,999,999.99') 
Impr(cDet,"C")

cDet := ''
Impr(cDet,'F')

If aReturn[5] == 1
	Set Printer To
	Commit
	OurSpool(WnRel)
EndIf

Ms_Flush()

SRV->(dbSetOrder(1)) //Volta ao indice padrao

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfChkPerg  บAutor  ณJose Carlos Gouveia บ Data ณ  10/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Perguntas do Sistema.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fChkPerg()

Local aRegs := {}

cPerg := Left(cPerg,6)

aAdd(aRegs,{cPerg,"01","Filial de      ","Filial de       " ,"Filial de       ","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
aAdd(aRegs,{cPerg,"02","Filial ate     ","Filial ate      " ,"Filial ate      ","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","SMO"})

ValidPerg(aRegs,cPerg,.F.)

Return
//Fim da Rotina

//Fim do Programa
