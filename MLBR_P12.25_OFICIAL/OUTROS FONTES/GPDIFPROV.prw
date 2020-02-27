#include "rwmake.ch"

User Function GPEXYZ()

Local cArquivo
Local nOpca := 0
Local aRegs	:={}

Local aSays:={ }, aButtons:= { } //<== arrays locais de preferencia
Private lAbortPrint := .F.
cCadastro := OemToAnsi("Importacao de Cadastros") 
cPerg     := "GPEXTESTE "
Aadd(aRegs,{cPerg,"01","Arquivo Atual       ?","","","mv_cha","C",030,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Arquivo Anterior    ?","","","mv_chb","C",030,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Tipo Relatorio      ?","","","mv_chc","N",001,0,0,"C","","mv_par03","Filial","","","","","Matricula","","","","","","","","",""})
ValidPerg(aRegs,cPerg)

Pergunte(cPerg,.F.)

AADD(aSays,OemToAnsi("Este programa verifica diferen็as na Provisao"))  

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

IF nOpca == 1
		Processa({|lEnd| GPA210Processa(),"Importacao de cadastros"})
Endif

Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMGPEM001  บAutor  ณReginaldo           บ Data ณ  09/28/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc. :   |Importacao de Tarefas do PR                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Calculo da Folha                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GPA210Processa()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Carrega Regua Processamento	                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cArqAtu   := alltrim(mv_par01)
cArqAnt   := alltrim(mv_par02)
nTipoRel  := mv_par03
aFunc     := {}

If ! File(cArqAtu)
    Help(" ",1,"A210NOPEN")
	 Return
Endif

If ! File(cArqAnt)
    Help(" ",1,"A210NOPEN")
	 Return
Endif

FT_FUSE(cArqAtu)
ProcRegua(FT_FLASTREC())	
FT_FGOTOP()
Private aFilial := {}
lLinOk := .f.

While !FT_FEOF()

			IncProc()

			//-- Verifica se o arquivo
			If Empty(AllTrim(FT_FREADLN()))
				FT_FSKIP()
				Loop
			EndIf
			
			__cEDILinTxt := FT_FREADLN()
			cLinTxt      := __cEDILinTxt
            _cAnter      := Substr(cLinTxt,14,5)

			If nTipoRel == 1 // compara somente filial
			
  			   If Substr(cLinTxt,1,7) == "FILIAL:"
			      _cFilial     := Substr(cLInTxt,9,2)
		         aAdd(aFilial,{_cFilial,0,0,0})
			   EndIf
			
			   IF _cAnter == "Anter"
			      nValor := Substr(cLinTxt,120,13)
			      nValor := StrTran(nValor,",",".")
			      aFilial[Len(aFilial),2] := Val(nValor)
			   EndIF

			   If Substr(cLinTxt,1,8) == "Empresa:"
			      Exit
			   EndIf

			ElseIf nTipoRel == 2

		        If Substr(cLinTxt,12,5) == "CCTO:" .AND. LEN(cLinTxt) < 88
			       lLinOk := .f.
                EndIf
                
                If Substr(cLinTxt,1,7) == "FILIAL:" .and. LEN(cLinTxt) < 60
			       lLinOk := .f.
                EndIf
                
		        If Substr(cLinTxt,88,12) == "DT.BASE FER:"
			       lLinOk := .T.
			    EndIF
			    
			    If lLinOk
			       
	  			   If Substr(cLinTxt,1,7) == "FILIAL:"
				      _cFilial     := Substr(cLInTxt,9,2)
	               EndIf
	               
			       If Substr(cLinTxt,39,4) == "MAT:"
	                  _cMat := Substr(cLinTxt,44,6)
				      aAdd(aFunc,{_cFilial,_cMat,0,0,0})
				   EndIF
	
				   IF _cAnter == "Anter"
				      nValor := Substr(cLinTxt,120,13)
				      nValor := StrTran(nValor,",",".")
				      aFunc[Len(aFunc),3] := Val(nValor)
				   EndIF
			   
			    EndIF
			
			EndIF
			
			FT_FSKIP()
EndDo
FT_FUSE()

FT_FUSE(cArqAnt)
ProcRegua(FT_FLASTREC())	
FT_FGOTOP()
lLinOk := .f.

While !FT_FEOF()

			IncProc()

			//-- Verifica se o arquivo
			If Empty(AllTrim(FT_FREADLN()))
				FT_FSKIP()
				Loop
			EndIf
			
			__cEDILinTxt := FT_FREADLN()
			cLinTxt      := __cEDILinTxt

			If nTipoRel == 1 // compara somente filial
			
				If Substr(cLinTxt,1,7) == "FILIAL:"
				   nPos := Ascan(aFilial,{ |x| x[1] == Substr(cLInTxt,9,2) } )
				EndIf

				IF Substr(cLinTxt,14,5) == "Atual"
				   
				   nValor := Substr(cLinTxt,120,13)
				   nValor := StrTran(nValor,",",".")
				   If nPos > 0
				      aFilial[nPos,3] := Val(nValor)
				   Else
				      aAdd(aFilial,{Substr(cLInTxt,9,2),0,Val(nValor)})
                      nPos := Len(aFilial)
				   EndIF   
				   
				EndIF
	
				If Substr(cLinTxt,1,8) == "Empresa:"
				   Exit
				EndIf  
				
				
			
			ElseIf nTipoRel == 2


		        If Substr(cLinTxt,12,5) == "CCTO:" .AND. LEN(cLinTxt) < 88
			       lLinOk := .f.
                EndIf

                If Substr(cLinTxt,1,7) == "FILIAL:" .and. LEN(cLinTxt) < 60
			       lLinOk := .f.
                EndIf
                
		        If Substr(cLinTxt,88,12) == "DT.BASE FER:"
			       lLinOk := .T.
			    EndIF
			    
			    If lLinOk
	  		  
	  			   If Substr(cLinTxt,1,7) == "FILIAL:"
				      _cFilial     := Substr(cLInTxt,9,2)
	               EndIf
	
	 		       If Substr(cLinTxt,39,4) == "MAT:"
	
	                  _cMat := Substr(cLinTxt,44,6)
				       nPos := Ascan(aFunc,{ |x| x[1] == _cFilial .and. x[2] == _cMat } )
				   
				   EndIF
	
					IF Substr(cLinTxt,14,5) == "Atual"
					   
					   nValor := Substr(cLinTxt,120,13)
					   nValor := StrTran(nValor,",",".")
					   If nPos > 0
					      aFunc[nPos,4] := Val(nValor)
					   Else
					      aAdd(aFunc,{_cFilial,_cMat,0,Val(nValor),0})
	                      nPos := Len(aFunc)
					   EndIF   
	
				    EndIf
	
				EndIF
				
			EndIF
				    
			FT_FSKIP()
EndDo
FT_FUSE()

fImprime()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMGPEM001  บAutor  ณReginaldo           บ Data ณ  09/28/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc. :   |Importacao de Tarefas do PR                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Calculo da Folha                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static function fImprime()

Local cDesc1  := "Log de difere็as de Provisใo"
Local cDesc2  := "Sera impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := "usuario."
Local cString := "SX1"                 // alias do arquivo principal (Base)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Private(Basicas)                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aReturn := {"Zebrado", 1,"Administrao", 2, 2, 1, "",1 }	//"Zebrado"###"Administrao"
Private NomeProg:= "GPEM001"
Private aLinha  := { },nLastKey := 0
Private Titulo
Private AT_PRG   := "GPEM001"
Private wCabec0  := 1
Private wCabec1  := "Filial   Mes Atual    Mes Anterior    Difere็a"
Private Contfl   := 1
Private Li       := 0
Private nTamanho := "M"


cTit   := " Log de diferen็as de proviใo"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Envia controle para a funcao SETPRINT                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel:="GPEM001"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,,cTit,cDesc1,cDesc2,cDesc3,.F.,,,nTamanho)
Titulo := " Log de Diferen็as de provisao "

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| GR210Imp(@lEnd,wnRel,cString)},titulo)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMGPEM001  บAutor  ณReginaldo           บ Data ณ  09/28/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc. :   |Importacao de Tarefas do PR                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Calculo da Folha                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GR210Imp(lEnd,WnRel,cString)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Locais (Programa)                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local nLInLog
Local n
Local nNegativo := nPositivo := 0
lOCAL aFunFin := {}

If nTipoRel == 1
	For n := 1 to Len(aFilial)
	    nDif := aFilial[n,2] - aFilial[n,3]
	    If nDif < 0
	       nNegativo += nDif
	    Else
	       nPositivo += nDif
	    EndIF      
	    aFilial[n,4] := nDif
	Next
Else

	For n := 1 to Len(aFunc)
	    nDif := aFunc[n,3] - aFunc[n,4]
        If nDif <> 0
           aAdd(aFunFin,{aFunc[n,1],aFunc[n,2],aFunc[n,3],1})
        EndIF   
	Next

	For n := 1 to Len(aFunc)
	    nDif := aFunc[n,3] - aFunc[n,4]
        If nDif <> 0
           aAdd(aFunFin,{aFunc[n,1],aFunc[n,2],aFunc[n,4],2})
        EndIF   
	Next

EndIF	    

If nTipoRel == 1
	For nLinLog := 1 to len(aFilial)
		iF aFilial[nLinLog,2] <> aFilial[nLinLog,3]
	       Impr(aFilial[nLinLog,1]+"    "+Transform(aFilial[nLinLog,2],'@r 9,999,999.99')+"   "+Transform(aFilial[nLinLog,3],'@r 9,999,999.99')+"   "+Transform(aFilial[nLinLog,4],'@r 9,999,999.99'))
	    EndIf
	Next    
    
    Impr('Total positivo ' + Transform(nPositivo,'@r 9,999,999.99'))
    Impr('Total Negativo ' + Transform(nNegativo,'@r 9,999,999.99'))
    Impr('Diferen็a      ' + Transform(nPositivo + nNegativo,'@r 9,999,999.99'))

Else

	For nLinLog := 1 to len(aFunFin)

       Impr(aFunFin[nLinLog,1]+"    "+aFunFin[nLinLog,2]+"   " +Transform(aFunFin[nLinLog,3],'@r 9,999,999.99')+" " + If (aFunFiN[nlinLog,4] = 1,"Mes Atual","Mes Anterior"))

	Next    

EndIF
	

Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()
    
Return

