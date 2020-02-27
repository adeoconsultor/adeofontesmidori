#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
/*
* Funcao: MBRUPDWF7
* Autor:  AOliveira
* Data:   20-01-2020
* Descr.: Rotina tem como objetivo realizar a alteração da 
          senha de e-mail do usuario utilizado para envio do pedido de compra
*/
User Function MBRUPDWF7

LOCAL cGet1  := Space( TamSx3("WF7_DSENHA"  )[1] )
LOCAL cGet2  := Space( TamSx3("WF7_DSENHA"  )[1] ) 
LOCAL cSay1  := "Rotina tem como objetivo realizar a alteração da senha,"
LOCAL cSay2  := "utilizada para envio de e-mail de Ped Compra."
LOCAL cSay3  := "OBS.: A senha deverá ser a mesma utilizado em seu"
LOCAL cSay4  := "           e-mail empresarial. "

LOCAL cUsrEmail  := UsrRetMail(RetCodUsr()) 

LOCAL nOpc := 0

LOCAL lCont := .T.
LOCAL cSeekWF7 := ""

PRIVATE oDlg, oGrp, oSay1, oSay2, oSay3, oSay4, oGet1, oGet2, oBtnConf, oBtnCanc

//cUsrEmail  := "suportemidori@adeoconsultor.com.br"
//
DbSelectArea("WF7")
WF7->(DbGoTop())
While !WF7->(Eof()) .And. lCont                 
	If Alltrim(LOWER(WF7->WF7_ENDERE)) == Alltrim(LOWER(cUsrEmail))      
        cSeekWF7 := WF7->WF7_FILIAL+WF7->WF7_PASTA    
	EndIf
	WF7->(DbSkip())
EndDo

if Empty(cSeekWF7)
    Aviso("ATENCAO - WF7", "Usuario sem cadastro para envio de Ped. Compra por e-mail",{"OK"},3)
    return()
endif
//
//WF7_FILIAL+WF7_PASTA

oDlg       := MSDialog():New( 092,232,290,657,"Alterar senha de envio de E-mail Ped.Compra",,,.F.,,,,,,.T.,,,.T. )
oGrp       := TGroup():New( 000,004,072,204,"  Dados  ",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 011,008,{|| cSay1 },oGrp,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,175,008)
oSay2      := TSay():New( 019,008,{|| cSay2 },oGrp,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,175,008)
oSay3      := TSay():New( 027,008,{|| cSay3 },oGrp,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,175,008)
oSay4      := TSay():New( 034,008,{|| cSay4 },oGrp,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,175,008)
oGet1      := TGet():New( 057,008,{|u| If(PCount()>0,cGet1:=u,cGet1)},oGrp,060,008,'',{|| /*bValid*/},CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| /*bWhen*/},.F.,.F.,,.F.,.T.,"","cGet1",,)
oGet2      := TGet():New( 057,074,{|u| If(PCount()>0,cGet2:=u,cGet2)},oGrp,060,008,'',{|| /*bValid*/},CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| /*bWhen*/},.F.,.F.,,.F.,.T.,"","cGet2",,)
oBtnConf   := TButton():New( 076,091,"Confirmar",oDlg,{ || oDlg:End(),nOpc:= 1 /* bAction */},050,012,,,,.T.,,"",,{  ||/*bWhen*/},{ || XBVALID(cGet1,cGet2) /*bValid*/},.F. )
oBtnCanc   := TButton():New( 076,153,"Cancelar",oDlg,{ || oDlg:End() /* bAction */},050,012,,,,.T.,,"",,{  ||/*bWhen*/},{ || /*bValid*/},.F. )

oDlg:Activate(,,,.T.)

if nOpc == 1
    DbSelectArea("WF7")
    WF7->(DBSETORDER( 1 )) //WF7_FILIAL+WF7_PASTA
    WF7->(DBGOTOP())
    if WF7->(DBSEEK( cSeekWF7 ))
		RecLock("WF7",.F.)
		WF7->WF7_DSENHA := Alltrim(cGet2)
        WF7->WF7_AUTSEN := Alltrim(cGet2)
		WF7->(MsUnlock())
    endif

    if (Alltrim(WF7->WF7_DSENHA) == Alltrim(cGet2)) .AND. (Alltrim(WF7->WF7_AUTSEN) == Alltrim(cGet2) )
        Aviso("ATENCAO", "Senha alterada com SUCESSO!",{"OK"})        
    endif
endif

Return()

/*
* Funcao: XBVALID
* Autor:  AOliveira
* Data:   20-01-2020
* Descr.: Validacao da nova senha
*/
Static Function XBVALID(cPass1,cPass2)
LOCAL lRet := .F.

DEFAULT cPass1 := ""
DEFAULT cPass2 := ""
if (Alltrim(cPass1) == Alltrim(cPass2)) .AND. !EMPTY(Alltrim(cPass1)) .AND. !EMPTY(Alltrim(cPass2))
    lRet := .T.    
else
    Aviso("ERROR", "Senhas informadas não conferem. Ou não foram digitadas",{"OK"})        
endif

Return lRet