#include "report.ch"

User Function ListFun()

Local oReport 
Local aArea := GetArea()                      
Local cPerg := 'RELNDI    ' 
Local cDesc := ' '
Private aOrd := ("Matricula","C.Custo","Nome")
Private cTitulo := "Relacao de Funcionarios"

If FindFunction("TRepInUse") .And. TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

RestArea( aArea)
                                                    
//DEFINE REPORT oReport NAME "LISTFUNC" TITLE cTitulo PARAMETER cPerg ACTION {|oReport|RelFuncImp(oReport)}DESCRIPTION "Este programa e um teste."

//oReport:= TReport():New("GPER150", OemToAnsi(STR0016),"GP150R",{|oReport| GR150Imp(oReport)},cDesc) 

Return