#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


///////////////////////////////////////////////////////////////////////////////
//Função com objetivo de bloquear/liberar apontamento menor que a estrutura
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Diego H. Mafisolli - 03-08-2015
///////////////////////////////////////////////////////////////////////////////

user function DM_BLQAPON()
Private cData      := iif(getmv('MA_ATVLES'),'S','N')

SetPrvt("oFont1","oDlgBlq","oSaay1","oGet1","oBtnConfirma","oBtnFecha")

oFont1     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oDlgBlq    := MSDialog():New( 113,324,227,646,"Apontamento Menor que Estrutura",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 012,004,{||"Bloqueado: "},oDlgBlq,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
oGet1      := TGet():New( 012,092,{|u| If(PCount()>0,cData:=u,cData)},oDlgBlq,056,010,'@!',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cData",,)
oBtnConfir := TButton():New( 032,068,"&Confirmar",oDlgBlq, {|| oDlgBlq:end(), BLQAPONTA()},036,012,,,,.T.,,"",,,,.F. )
oBtnFecha  := TButton():New( 032,111,"&Fechar",oDlgBlq,{|| oDlgBlq:end()},037,012,,,,.T.,,"",,,,.F. )

oDlgBlq:Activate(,,,.T.)

return

//////////////////////////////////////////////////////////////////////////////////////////////
//função de bloqueio
static function BLQAPONTA()
local lRet := .T.
hora:= A680ConvHora(time(), "N", "C")
if apmsgnoyes("Confirma a alteração do parametro 'MA_ATVLES'?"+chr(13)+chr(13)+"Será gravado log dessa operacao","ATENÇÃO")
	putmv('MA_ATVLES', iif(cData=="S", .T., .F.))
		RecLock("AIF",.T.)
		AIF->AIF_TABELA := "SX6"
		AIF->AIF_CODPRO := ""
		AIF->AIF_CAMPO  := 'MA_ATVLES'
		AIF->AIF_CONTEU := "ALTERADO PARA " +cData+" POR "+cUserName+" EM "+DtoC(Date())+" AS "+hora
		AIF->AIF_DATA   := dDataBase 
		AIF->AIF_HORA   := substr(time(),1,5)
		MsUnlock("AIF")
		Alert("Executado com sucesso....")
else
	Alert("Operacão cancelada...")
endif


return

