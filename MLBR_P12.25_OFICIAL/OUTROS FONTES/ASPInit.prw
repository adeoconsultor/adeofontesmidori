#include 'protheus.ch'

User Function ASPInit()
conout("ASPINIT - Iniciando Thread Advpl ASP ["+cValToChar(ThreadID())+"]")
SET DATE BRITISH
SET CENTURY ON
Return .T.

USER Function ASPConn()
Local cReturn := ''
cReturn := "http://172.17.0.10:8090/01/"
Return cReturn