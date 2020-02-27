#INCLUDE "protheus.ch"
#Include "RwMake.ch"
//--------------------------------------
//Nome do progrma: MbrWbtn.Prw
//Funçao         : Ponto de entrada Genérico que atua em todos os Browses
//Data           : 10/08/10.
//----------------------
User Function MbrWbtn()
//----------------------

Local aAreaMBR 	:= GetArea()
Local cQuery 	:= ""
Local oGrp    	:= Nil
Local bOk     	:= {||nOpcao:=1, oDlg:End() }
Local bCancel 	:= {||nOpcao:=0, oDlg:End() }
Local cTES    	:= "   "
Local nOpcao  	:= 0

Private aIndex := {}
Private oDlg  	:= Nil
Private cCodUsr := RetCodUsr()

/*
//if FunName() = "MATA140" .AND. ALTERA .and. cFilant $ GetMv("MV_MDTESFI") //Funcao escoher TES unico na classificação. (Jose Roberto - TAggs - 10/08/10)
if FunName() = "MATA140" .And. PARAMIXB[3] == 4 //.And. cFilant $ GetMv("MV_MDTESFI") //Funcao escoher TES unico na classificação. (Jose Roberto - TAggs - 10/08/10)
	//	if !Empty(SD1->D1_TES) .AND. Empty(SD1->D1_CF) //usuario entrou e nao classificou a nota, necessário desfazer o que foi feito
	if Empty(SF1->F1_STATUS) //.AND. Empty(SD1->D1_CF) //usuario entrou e nao classificou a nota, necessário desfazer o que foi feito
		cQuery    := "BEGIN TRANSACTION  "
		cQuery    += "UPDATE  "
		cQuery    += +RetSqlName("SD1")+" "
		cQuery    += "SET D1_TES = '' "
		cQuery    += "WHERE D1_FILIAL = '"+xFilial("SD1")+"' AND "
		cQuery    += "D1_DOC = '"+SF1->F1_DOC+"' AND "
		cQuery    += "D1_SERIE = '"+SF1->F1_SERIE+"' AND "
		cQuery    += "D1_FORNECE = '"+SF1->F1_FORNECE+"' AND "
		cQuery    += "D1_LOJA    = '"+SF1->F1_LOJA+"' AND "
		cQuery    += "D_E_L_E_T_ = ' ' "
		cQuery    += "COMMIT "
		TcSqlExec(cQuery)
	endif
endif                            
*/

if FunName() = "MATA103" //.AND. cFilant $ SuperGetMv("MV_MDTESFI",.T.,"01") //Funcao escoher TES unico na classificação. (Jose Roberto - TAggs - 10/08/10)
	//	if !Empty(SD1->D1_TES) .AND. Empty(SD1->D1_CF) //usuario entrou e nao classificou a nota, necessário desfazer o que foi feito
	If PARAMIXB[3] == 4 .And. Empty(SF1->F1_STATUS)//Classificar
		RecLock('SF1',.F.)
		//		Alert("Classificando SF1....")
		SF1->F1_X_CLASS := RETCODUSR()+'-'+ALLTRIM(SUBSTR(CUSUARIO,7,15))+' -  EM '+DTOC(Date())+" HORA:"+Substr(TIME(),1,2)+':'+Substr(TIME(),4,2)
		SF1->F1_NREDUZ := U_AG_SHNREDUZ(SF1->F1_FORNECE, SF1->F1_LOJA, SF1->F1_TIPO)
		//Gravar o nome do usuário que fez a inclusao da nota fiscal....caso esteja em branco....
		If Empty(SF1->F1_USERPN)
			SF1->F1_USERPN  := cUserName
		endif
		MsUnLock('SF1')
		
		if Empty(SF1->F1_STATUS)  //usuario entrou e nao classificou a nota, necessário desfazer o que foi feito
			if MsgYesNo("Deseja Utilizar um unico TES para todos os itens da nota ?", "MUDA TES")
				//Tela solicitando o Tes
				DEFINE MSDIALOG oDlg TITLE "Escolha o TES" From 1,1 to 150,370 of oMainWnd PIXEL
				oGrp  := TGroup():New( 30,5,58,80,"Seleção",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
				@ 42,10 SAY "TES: " SIZE 30,7 PIXEL OF oDlg
				@ 42,32 MSGET cTES PICTURE "@!" VALID ExistCpo("SF4",cTES) F3 "SF4" SIZE 40,7 PIXEL OF oDlg
				ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) Centered
				cMiDocCla := SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
				If nOpcao == 1
					cQuery    := "BEGIN TRANSACTION  "
					cQuery    += "UPDATE  "
					cQuery    += +RetSqlName("SD1")+" "
					cQuery    += "SET D1_TES = '"+cTES+"' "
					cQuery    += "WHERE D1_FILIAL = '"+xFilial("SD1")+"' AND "
					cQuery    += "D1_DOC = '"+SF1->F1_DOC+"' AND "
					cQuery    += "D1_SERIE = '"+SF1->F1_SERIE+"' AND "
					cQuery    += "D1_FORNECE = '"+SF1->F1_FORNECE+"' AND "
					cQuery    += "D1_LOJA    = '"+SF1->F1_LOJA+"' AND "
					cQuery    += "D_E_L_E_T_ = ' ' "
					cQuery    += "COMMIT "
					TcSqlExec(cQuery)
				endif
			endif
		endif
	endif
endif

Return(.T.)
