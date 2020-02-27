#Include "rwmake.ch"
#Include "average.ch"

User Function GetNumEmb(cPar)

Local cSeqEmb

If Empty(M->EEC_PREEMB)
   cSeqEmb:=GetSx8Num("EEC","EEC_PREEMB")
   CONFIRMSX8()
   cSeqEmb:=M->EEC_PREFIX+Right(cSeqEmb,14)+'/'+Right(Alltrim(Str(Year(dDataBase),4)),2)
Else
   cSeqEmb:=M->EEC_PREFIX+Right(M->EEC_PREEMB,17)
Endif

M->EEC_PREEMB:=cSeqEmb

If cPar <> NIL
   M->EXP_NRINVO:=M->EEC_PREEMB
   Return M->EXP_NRINVO
Endif
   
Return .t.       

                       

User Function CalcQtdPed()

M->EE8_SLDINI:=M->EE8_QTDLIM+M->EE8_QTDCLI
                                           
Return .t.

/*
User Function SomaQtdLim()
Local cVar:=ReadVar()

If "EE8_QTDLIM" $ UPPER(cVar)
   M->EE8_SLDINI+=M->EE8_QTDLIM
Endif

Return .t.        

User Function TiraQtdLim()
Local cVar:=ReadVar()

If "EE8_QTDLIM" $ UPPER(cVar)
   M->EE8_SLDINI-=M->EE8_QTDLIM
   M->EE8_QTDLIM:=0
Endif
Return .t.
*/