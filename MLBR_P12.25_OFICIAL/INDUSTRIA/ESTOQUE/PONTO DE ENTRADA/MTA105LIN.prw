#include 'protheus.ch'

//Ponto de entrada desenvolvido para validar se o campo de motivo de uso da solicita��o ao armazem foi preenchido
//Solicitado por Marco Vale - Manuten��o - PNP1
//Desenvolvido por Vinicius Schwartz - TI em 16/07/2013

User Function MTA105LIN()

Local nPosMot  := AScan(aHeader,{|x|AllTrim(x[2]) == "CP_X_MOTSA"})
Local nPosEquip:= AScan(aHeader,{|x|AllTrim(x[2]) == "CP_X_EQUIP"})
Local nPosNOs:= AScan(aHeader,{|x|AllTrim(x[2]) == "CP_X_NUMOS"})
Local cUsrCons := Getmv( 'MA_USRSA' )//Usuarios que dever�o ser autenticados para valida��o
Local lRet := .T.
Local cUsrAtu := Alltrim( RetCodUsr()   )

If cFilAnt == '09' .And. cUsrAtu $ cUsrCons
	if Acols[N,nPosNOs] == Space(8)
		Alert('Favor preencher o campo de N�mero de OS!')
		lRet := .F.
	endif

	if Acols[N,nPosMot] == Space(1)
		Alert('Favor preencher o campo de Motivo da SA!')
		lRet := .F.
	endif
	
	if Acols[N,nPosEquip] == Space(10)
		Alert('Favor informar em qual equipamento ser� utilizado o material!')
		lRet := .F.
	endif  
Else
	lRet := .T.
Endif

Return lRet


//Ponto de entrada para grava��o dos dados da baixa na tabela SD3  
User Function M185GRV()
Local cNumSAx  := SCP->CP_NUM     
Local aAreaSD3 := SD3->(GetArea()) 

DbSelectArea("SD3")

DbSetOrder(2)
DbSeek(xFilial("SD3")+CDOCUMENTO+SCP->CP_PRODUTO) 
                                           


//Alert('Teste da baixa!' + AScan(aHeader,{|x|AllTrim(x[2]) == "CP_X_MOTSA"}))
Reclock('SD3',.F.)
	SD3->D3_X_NUMSA := cNumSAx
MsUnLock('SD3')  

SD3->( RestArea(aAreaSD3) ) 

Return