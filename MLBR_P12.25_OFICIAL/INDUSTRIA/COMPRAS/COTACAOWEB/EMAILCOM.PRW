#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EMAILCOM  ºAutor  ³Microsiga           º Data ³  29/05/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±  
±±º          ³                                                            º±±     
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam.    ³                                                            º±±
±±º          ³ lModoTst : Define de esta ativo modo de TESTE.             º±± 
±±º          ³ cFrom    : Defina email para remetente                     º±± 
±±º          ³ cTo      : Defina email para destinatario                  º±± 
±±º          ³ cCc      : Defina email para copia da mensagem             º±± 
±±º          ³ cBcc     : Defina email para copia oculta                  º±± 
±±º          ³ cSubject : Defina assunto do email                         º±± 
±±º          ³ cBody    : Defina corpo do email                           º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function EMAILCOM(lModoTst,cFrom,cTo,cCc,cBcc,cSubject,cBody)
Local cUser := "", cPass := "", cSendSrv := ""
Local cMsg := ""
Local nSendPort := 3, nSendSec := 3, nTimeout := 0
Local xRet
Local oServer, oMessage           

Default lModoTst := .T.
Default cFrom    := " "    // Defina email para remetente
Default cTo      := " "    // Defina email para destinatario
Default cCc      := " "    // Defina email para copia da mensagem
Default cBcc     := " "    // Defina email para copia oculta
Default cSubject := " "    // Defina assunto do email
Default cBody    := " "    // Defina corpo do email
     
cFrom    := "andre@sigasp.com"
cUser    := "andre@sigasp.com"            //  // defina o nome de usuário da conta de e-mail
cPass    := "q2c9h2h2"                    //  // defina a senha da conta de e-mail
cSendSrv := "smtp.sigasp.com"             //  // defina o servidor de envio

nTimeout := 60                            // defina a temporização para 60 segundos
      
If lModoTst 

	cFrom    := "andre@sigasp.com"
	cUser    := "andre@sigasp.com"                  // "cobranca@molin.com.br" // defina o nome de usuário da conta de e-mail
	cPass    := "q2c9h2h2"                          // "M0l1nC0br@"            // defina a senha da conta de e-mail
	cSendSrv := "smtp.sigasp.com"             // "email-ssl.com.br"      // defina o servidor de envio

	cTo := "andre@adeoconsultor.com.br"
	cBCC := ""
	cSubject := "[EMAILCOM] -- TESTE DE ENVIO " 
	cBody    := " TESTE DE ENVIO "+CRLF+CRLF+cBody 
	cFrom    := "andre@sigasp.com"
	nSendSec := 3
EndIf

oServer := TMailManager():New()

oServer:SetUseSSL( .F. )
oServer:SetUseTLS( .F. )

if nSendSec == 0
	nSendPort := 25 //porta padrão para protocolo SMTP
elseif nSendSec == 1
	nSendPort := 465 //Porta padrão para protocolo SMTP com SSL
	oServer:SetUseSSL( .T. )
else
	nSendPort := 587 //porta padrão para protocolo SMTPS com TLS
	oServer:SetUseTLS( .T. )
endif

// uma vez que apenas enviará mensagens, o servidor receptor será passado como ""
// e o número da porta de recepção não será passado, uma vez que é opcional
xRet := oServer:Init( "", cSendSrv, cUser, cPass, , nSendPort )
if xRet != 0
	cMsg := "01 - Não foi possível inicializar o servidor SMTP: " + oServer:GetErrorString( xRet )
	conout( cMsg )
	return(xRet)
endif

// O método define a temporização para o servidor SMTP
xRet := oServer:SetSMTPTimeout( nTimeout )
if xRet != 0
	cMsg := "02 - Não foi possível configurar " + "cProtocol" + " tempo limite para " + cValToChar( nTimeout )
	conout( cMsg )
	return(xRet)
endif

// estabelecer a conexão com o servidor SMTP
xRet := oServer:SMTPConnect()
if xRet <> 0
	cMsg := "03 - Não foi possível conectar no servidor SMTP: " + oServer:GetErrorString( xRet )
	conout( cMsg )
	return(xRet)
endif

// autenticar no servidor SMTP (se necessário)
xRet := oServer:SmtpAuth( cUser, cPass )
if xRet <> 0
	cMsg := "04 - Não foi possível autenticar no servidor *SMTP*: " + oServer:GetErrorString( xRet )
	conout( cMsg )
	oServer:SMTPDisconnect()
	return (xRet)
endif

oMessage := TMailMessage():New()
oMessage:Clear()

oMessage:cDate    := cValToChar( Date() )
oMessage:cFrom    := cFrom
oMessage:cTo      := cTo 
     
If !Empty(cCc)
	oMessage:cCC     := cCc  //Envio de Copia
EndIf

If !Empty(cBcc)
	oMessage:cBCC     := cBcc //Envio de Copia Oculta
EndIf

oMessage:cSubject := cSubject
oMessage:cBody    := cBody

xRet := oMessage:Send( oServer )
if xRet <> 0
	cMsg := "05 - Não foi possível enviar uma mensagem: " + oServer:GetErrorString( xRet )
	conout( cMsg )
	return(xRet)
Else   
	cMsg := Time()+" - Email enviado para "+cTo  
	Conout( cMsg )
	return(xRet)	
endif

xRet := oServer:SMTPDisconnect()
if xRet <> 0
	cMsg := "06 - Não foi possível desconectar do servidor SMTP: " + oServer:GetErrorString( xRet )
	conout( cMsg )
	return(xRet)
endif      

return(xRet )