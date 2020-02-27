#include "totvs.ch"
CLASS TngElap

	Data cHoraIni    // hora inicial no formato hh:mm:ss
	Data cHoraFim    // hora final no formato hh:mm:ss
	Data nSegundos   // Segundos entre a hora de inicio e a hora final
	Data cTempo      // hora de duração no formato hh:mm:ss
	Data nHora       // hora da hora de duração 
	Data nMinuto     // minuto da hora de duração 
	Data nSegundo    // Segundo da hora de duração  
	Data nSecPass    // Acumulador dos segundos deste o SetInicio() até o último SetFim()

	METHOD New()
	METHOD SetInicio( cHora )
	METHOD SetFim( cHora )
	METHOD ElapTime()
	METHOD Previsao( nRecTot, nRecDone )

ENDCLASS            

METHOD New() CLASS TngElap

::cHoraIni  := Time()
::cHoraFim  := Time()
::nSegundos := 0  // Segundos entre a hora de inicio e a hora final
::cTempo    := ""  // hora de duração no formato hh:mm:ss
::nHora     := 0  // hora da hora de duração 
::nMinuto   := 0  // minuto da hora de duração 
::nSegundo  := 0  // Segundo da hora de duração  
::nSecPass  := 0  // Acumulador dos segundos deste o SetInicio() até o último SetFim()

Return( ::Self )
             
************************************************************************************************************************
METHOD SetInicio(cHora) CLASS TngElap
                   
DEFAULT cHora := Time()

::cHoraIni  := cHora
::cHoraFim  := cHora
::nSegundos := 0  // Segundos entre a hora de inicio e a hora final
::cTempo    := ""  // hora de duração no formato hh:mm:ss
::nHora     := 0  // hora da hora de duração 
::nMinuto   := 0  // minuto da hora de duração 
::nSegundo  := 0  // Segundo da hora de duração  
::nSecPass  := 0  // Acumulador dos segundos deste o SetInicio() até o último SetFim()

Return( nil )
************************************************************************************************************************
METHOD SetFim(cHora) CLASS TngElap

DEFAULT cHora := Time()

::cHoraFim := cHora

Return( nil )
************************************************************************************************************************
METHOD ElapTime() CLASS TngElap
               
Local cTime 
Local cElap 
Local nHora 
Local nMin  
Local nSeg  
Local nSegs 

::cHoraFim  := Time()

cTime := ElapTime( ::cHoraIni, ::cHoraFim )
cElap := StrTran( cTime, ":", "" )
nHora := Val( SubStr(cElap,1,2) )
nMin  := Val( SubStr(cElap,3,2) )
nSeg  := Val( SubStr(cElap,5,2) )
nSegs := nSeg + ( nMin * 60 ) + ( ( nHora * 60 ) * 60 )

::cTempo    := cTime
::nHora     := nHora
::nMinuto   := nMin
::nSegundo  := nSeg
::nSecPass  := nSegs

Return( cTime )
************************************************************************************************************************
METHOD Previsao( nRecTot, nRecDone ) CLASS TngElap

Local nSecRec := nRecDone / ::nSecPass // Qtde de Segundos por registro
Local nSecPrv := nRecTot / nSecRec   // Qtde de Segundos necessária

// Define o tempo necessário previsto para terminar o processo
Local nHora := Int( ( nSecPrv / 60) / 60 )
Local nMin  := Mod(Int((nSecPrv/60)),60)
Local nSeg  := Mod(nSecPrv,60)
                                                 
Return( StrZero(nHora,4)+":"+StrZero(nMin,2)+":"+StrZero(nSeg,2) )

*************************************************************************************************************************
User Function TestElap()

Processa( {|| TestElap() }, "Processando Registros..." )

Return( nil )
*************************************************************************************************************************
Static Function TestElap()

Local nRecs    := SD1->(RecCount())
Local oTngElap := TngElap():New()
Local nDone, nLoop    := 0

oTngElap:SetInicio()

dbSelectArea("SD1")
dbSetOrder(1)
dbGoTop()          

ProcRegua( nRecs )

While ! Eof()    

	nDone ++
	For nLoop := 1 to 500
	Next nLoop

	oTngElap:ElapTime()
	
	cMsg := "Execução: " + oTngElap:cTempo + " - Previsão: " + oTngElap:Previsao(nRecs,nDone)
	IncProc( cMsg )

	dbSkip()
	
Enddo
                 

Return( nil )