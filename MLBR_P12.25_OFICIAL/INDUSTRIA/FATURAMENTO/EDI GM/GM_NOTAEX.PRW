#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE PICVAL  "@E 999,999,999.99"

/* TAGGs - CONSULTORIA
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Cliente      ³ MIDORI ATLANTICA                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programa     ³ GM_NOTAEX        ³ Responsavel ³ REGINALDO NASCIMENTO   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o    ³ GERACAO DE ARQUIVO TEXTO REF.NOTA FISCAL                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Data        ³ 13/07/11         ³ Implantacao ³                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador ³ ANESIO G.FARIA                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GM_NOTAEX()
********************
LOCAL   aGMNF      := GetArea()
LOCAL   aGMNFSF2   := SF2->(GetArea())
LOCAL   aGMNFSD2   := SD2->(GetArea())
Local   lRet       := .T.
PRIVATE cArq       := ""
PRIVATE cDir       := ""
PRIVATE cPerg      := "MD_GENFGM"
PRIVATE aRegistros := {}
//Exclusivo para gerar para Excel
Private aConteud:= {}       
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab        := "" 
Private aReturn := {" ",1," ", 1, 2, 1, "",1 }

                     
AjustaSx1()
If ! Pergunte(cPerg,.T.)
	Return
Endif
                     

//NfExCriaPer(cPerg,aRegistros)

//If Pergunte(cPerg,.T.)           

aDir := MDirArq()

	aDir[2] := Alltrim(aDir[2])+'.DAT' 
	

	cDir := AllTrim(aDir[1])
	IF Subs(cDir,len(cDir),1)<>"\"
		cDir := cDir+"\"
	EndIF
	
	cArq   := alltrim(aDir[2])
	If file(cDir+cArq)
		ferase(cDir+cArq)
	Endif
	
	nHdl	:= fCreate(cDir+cArq)
	cEOL    := "CHR(13)+CHR(10)"
	cEOL	:= &cEOL
	
	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArq+" nao pode ser criado!!!"+Chr(13)+"Verifique se o caminho "+ALLTRIM(aDir[1])+" e valido!!!","Atencao!")
		Return
	Endif


	If Empty(aDir[1]) .OR. Empty(aDir[2])
		Return
	Else                      
		Processa({|| GMNFEXGERA()},"Gerando Texto ref.Nota Fiscal....")
//		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
	 
//		If lOk
//			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
//		EndIf
    endif

	
	fClose(nHdl)
	
	KeyBoard Chr(27)
	KeyBoard Chr(27)
//Endif


RestArea(aGMNFSF2)
RestArea(aGMNFSD2)
RestArea(aGMNF)

Return

Static Function GMNFEXGERA()
************************
                                                                                  
cQuery := " "
cQuery += " SELECT F2_DOC, F2_SERIE, D2_COD, F2_CLIENTE, F2_LOJA, D2_ITEM, D2_PEDIDO, F2_EMISSAO, D2_QUANT, D2_TOTAL, D2_VALIPI, D2_VALICM, D2_ITEMPV "
cQuery += " FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SD2")+" SD2 "
cQuery += " WHERE F2_FILIAL = '"+xFilial("SF2")+"' AND SF2.D_E_L_E_T_ = ' ' "
cQuery += " AND D2_FILIAL = '"+xFilial("SD2")+"' AND SD2.D_E_L_E_T_ = ' ' "
cQuery += " AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND D2_LOJA = F2_LOJA "
cQuery += " AND F2_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "
cQuery += " AND F2_DOC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
cQuery += " AND F2_CLIENTE BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
cQuery += " AND F2_LOJA BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "
cQuery += " AND F2_SERIE = '"+mv_par05+"' "
cQuery += " ORDER BY F2_DOC, F2_SERIE "
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"MAR",.T.,.F.)

dbSelectArea("MAR")
dbGotop()

////////////////////////////////////////////////////////////////////////////////////////////////////
//HEADER DO ARQUIVO DE NOTA FISCAL......
cHDIdent	:= "HEADER" //Header do arquivo
cHDnomearq  := "NFFORN"+DTOS(DATE())+Substr(TIME(),1,2)+Substr(TIME(),4,2)+Substr(TIME(),7,2)+Space(32)
cHDUsoFut   := Space(70)
cHDCrLf     := Chr(13)+Chr(10)
cNotAnt     := MAR->F2_DOC
nCount      := 0

Procregua(reccount())              
cLinha := cHDIdent+cHDnomeArq+cHDUsoFut+cHDCRLf

fWrite(nHdl,cLinha,Len(cLinha))                
nCount++

While !EOF()
	
	Incproc()
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	//DETALHE DO ARQUIVO DE NOTA FISCAL
	cDTCodPC    := Substr(Posicione('SA7',1,xFilial('SA7')+MAR->(F2_CLIENTE+F2_LOJA+D2_COD),'A7_CODCLI'),1,8)
	cDTCodCli   := Posicione('SC5',1,xFilial('SC5')+MAR->D2_PEDIDO,'C5_LOJAGM') //Posicione('SZK',1,xFilial('SZK')+MAR->(F2_CLIENTE+F2_LOJA),'ZK_CODEXT')
	cDTNumPed   := Posicione('SC5',1,xFilial('SC5')+MAR->D2_PEDIDO,'C5_PEDCLI')
	cDTNota		:= Substr(MAR->F2_DOC,1,9) // Alterado para 09 digitos conforme nova solicitacao da GM
	cDTSerie    := MAR->F2_SERIE
	cDTCodFor   := Posicione('SC5',1,xFilial('SC5')+MAR->D2_PEDIDO,'C5_CODFORN')
	cDTDtNota   := Substr(MAR->F2_EMISSAO,7,2)+Substr(MAR->F2_EMISSAO,5,2)+Substr(MAR->F2_EMISSAO,1,4)
	cDTTpDSO    := 'C' 
	cDTPedSAP   := Posicione('SC5',1,xFilial('SC5')+MAR->D2_PEDIDO,'C5_PEDSAP')
	cDTQuant    := MAR->D2_QUANT //Tamanho 05
	
	cValor := cValToChar(MAR->D2_TOTAL) //Tamanho 13
	cDTVlrTIt   := val(retPto(cValor))
	
	cValor := cValToChar(MAR->D2_VALIPI) //Tamanho 09
	cDTVlrIPI   := val(retPto(cValor))	
	
	cValor := cValToChar(MAR->D2_VALICM) //Tamanho 09
	cDTVlrICM   := val(retPto(cValor))	

	cDTVlrICMSs := 0 //space(9) // Verificar a origem dessa informação...
	cDTNFGM     := '000000' // Numero da nota fiscal da GM - Verificar a origem dessa informacao...
	cDTContr    := Posicione('SA7',1,xFilial('SA7')+MAR->(F2_CLIENTE+F2_LOJA+D2_COD),'A7_CONTRAT') 
	cDTLnSAP    := Posicione('SC6',1,xFilial('SC6')+MAR->(D2_PEDIDO+D2_ITEMPV+D2_COD),'C6_LNSAP')
	cDTUsoFut   := space(3) // Uso Futuro....
	cDTCrLf     := Chr(13)+Chr(10)
	                   
	cLinha 	:= cDTCodPC+cDTCodCli+cDTNumPed+cDTNota+cDTSerie+cDTCodFor+cDTDtNota+cDTTpDSO+cDTPedSAP+Strzero(cDTQuant,5);
		+Strzero(cDTVlrTIt,13)+Strzero(cDTVlrIPI,9)+Strzero(cDTVlrICM,9)+Strzero(cDTVlrICMSs,12)+cDTNFGM;
		+cDTContr+cDTLnSAP+cDTUsoFut+cEol
		
	fWrite(nHdl,cLinha,Len(cLinha))

	nCount++ //Contador para somar o numero de linhas na nota e gravar no trailler do arquivo...		

	dbSelectArea("MAR")
	dbSkip()
Enddo

////////////////////////////////////////////////////////////////////////////////////////////////////
//TRAILLER DO ARQUIVO DE NOTA FISCAL......
cTRIdent   	:= "TRAILLER" //Trailler do arquivo
nCount++
cTRUsoFut   := Space(116)


Procregua(reccount())              
cLinha := cTRIdent+StrZero(nCount,5)+cTRUsoFut+cHDCRLf
fWrite(nHdl,cLinha,Len(cLinha))                





If (Select("MAR") <> 0)
	dbSelectArea("MAR")                                        
	
	dbCloseArea()
Endif

	fClose(nHdl)

//MsgStop("Numero de notas incluidas no arquivo "+Alltrim(cArq)+": "+Alltrim(str(nNrNot)))
MsgStop("Processo Finalizado!!!"+chr(13)+"Arquivo Salvo em "+ALLTRIM(aDir[1])+ALLTRIM(aDir[2]))

Return


//+-----------------------------------------------------------------------------------//
//|Funcao....: MDirArq
//|Descricao.: Defini Diretório e nome do arquivo a ser gerado
//|Retorno...: aRet[1] = Diretório de gravação
//|            aRet[2] = Nome do arquivo a ser gerado
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MDirArq()
*-----------------------------------------*
Local aRet := {"",""}
Private bFileFat:={|| cDir:=UZXChoseDir(),If(Empty(cDir),cDir:=Space(250),Nil)}
Private cArq    := 'NFFORN'+DTOS(DATE())+Substr(TIME(),1,2)+Substr(TIME(),4,2)+Substr(TIME(),7,2)
Private cDir    := Space(250)
Private oDlgDir := Nil
Private cPath   := "Selecione diretório"
Private aArea   := GetArea()
Private lRetor  := .T.
Private lSair   := .F.
//+-----------------------------------------------------------------------------------//
//| Definição da janela e seus conteúdos
//+-----------------------------------------------------------------------------------//
While .T.
	DEFINE MSDIALOG oDlgDir TITLE "Definição de Arquivo e Diretório" FROM 0,0 TO 175,368 OF oDlgDir PIXEL
	
	@ 06,06 TO 65,180 LABEL "Dados do arquivo" OF oDlgDir PIXEL
	
	@ 15, 10 SAY   "Nome do Arquivo"  SIZE 45,7 PIXEL OF oDlgDir
	@ 25, 10 MSGET cArq               SIZE 100,8 When .F. PIXEL OF oDlgDir
	
	@ 40, 10 SAY "Diretorio de gravação"  SIZE  65, 7 PIXEL OF oDlgDir
	@ 50, 10 MSGET cDir PICTURE "@!"      SIZE 150, 8 WHEN .F. PIXEL OF oDlgDir
	@ 50,162 BUTTON "..."                 SIZE  13,10 PIXEL OF oDlgDir ACTION Eval(bFileFat)
	
	DEFINE SBUTTON FROM 70,10 TYPE 1  OF oDlgDir ACTION (UZXValRel("ok")) ENABLE
	DEFINE SBUTTON FROM 70,50 TYPE 2  OF oDlgDir ACTION (UZXValRel("cancel")) ENABLE
	
	ACTIVATE MSDIALOG oDlgDir CENTER
	
	If lRetor
		Exit
	Else
		Loop
	EndIf
EndDo

If lSair
	Return(aRet)
EndIf

aRet := {cDir,cArq}

Return(aRet)



*-----------------------------------------*
Static Function UZXChoseDir()
*-----------------------------------------*
Local cTitle:= "Geração de arquivo"
Local cMask := "Formato *|*.*"
Local cFile := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions:= GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY

cFile:= cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,.F., nOptions)

Return(cFile)


//+-----------------------------------------------------------------------------------//
//|Funcao....: UZXValRel()
//|Descricao.: Valida informações de gravação
//|Uso.......: U_UZXDIRARQ
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function UZXValRel(cValida)
*-----------------------------------------*

Local lCancela

If cValida = "ok"
	If Empty(Alltrim(cArq))
		MsgInfo("O nome do arquivo deve ser informado","Atenção")
		lRetor := .F.
	ElseIf Empty(Alltrim(cDir))
		MsgInfo("O diretório deve ser informado","Atenção")
		lRetor := .F.
		//	ElseIf Len(Alltrim(cDir)) <= 3
		//		MsgInfo("Não se pode gravar o arquivo no diretório raiz, por favor, escolha um subdiretório.","Atenção")
		//		lRetor := .F.
	Else
		oDlgDir:End()
		lRetor := .T.
	EndIf
Else
	lCancela := MsgYesNo("Deseja cancelar a geração do Relatório / Documento?","Atenção")
	If lCancela
		oDlgDir:End()
		lRetor := .T.
		lSair  := .T.
	Else
		lRetor := .F.
	EndIf
EndIf

Return(lRetor)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Anesio G.Faria -    ³    02.08.2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aArea := GetArea()
//PutSx1(cPerg,"01","Caminho do arquivo            ?"," "," ","mv_ch1","C",30,0,0,"G","","   ","","","mv_par01","C:\"," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o caminho "},{"Informe o caminho"},{"Informe o caminho"})
//PutSx1(cPerg,"02","Nome do Arquivo               ?"," "," ","mv_ch2","C",30,0,0,"G","","   ","","","mv_par02","NFGMEX.TXT "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe nome do arquivo"},{"Informe nome do arquivo"},{"Informe nome do arquivo"})
PutSx1(cPerg,"01","Periodo de                    ?"," "," ","mv_ch1","D",8,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a data inicial   "},{"Informe a data inicial   "},{"Informe a data inicial   "})
PutSx1(cPerg,"02","Periodo ate                   ?"," "," ","mv_ch2","D",8,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a data final   "},{"Informe a data final   "},{"Informe a data final   "})
PutSx1(cPerg,"03","Nota fiscal de                ?"," "," ","mv_ch3","C",9,0,0,	"G","","SF2","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a nota inicial "},{"Informe a nota inicial "},{"Informe a nota inicial "})
PutSx1(cPerg,"04","Nota fiscal ate               ?"," "," ","mv_ch4","C",9,0,0,	"G","","SF2","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a nota final   "},{"Informe a nota final   "},{"Informe a nota final   "})
PutSx1(cPerg,"05","Serie da Nota Fiscal          ?"," "," ","mv_ch5","C",3,0,0,	"G","","   ","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a serie da nota"},{"Informe a serie da nota"},{"Informe a serie da nota"})
PutSx1(cPerg,"06","Cliente de                    ?"," "," ","mv_ch6","C",6,0,0,	"G","","SA1","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o cliente inicial "},{"Informe o cliente inicial "},{"Informe o cliente inicial "})
PutSx1(cPerg,"07","Cliente ate                   ?"," "," ","mv_ch7","C",6,0,0,	"G","","SA1","","","mv_par07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o cliente final   "},{"Informe o cliente final   "},{"Informe o cliente final   "})
PutSx1(cPerg,"08","Loja de                       ?"," "," ","mv_ch8","C",2,0,0,	"G","","","","","mv_par08"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a loja inicial "},{"Informe a loja inicial "},{"Informe a loja inicial "})
PutSx1(cPerg,"09","Loja ate                      ?"," "," ","mv_ch9","C",2,0,0,	"G","","","","","mv_par09"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a loja final   "},{"Informe a loja final   "},{"Informe a loja final   "})


RestArea(aArea)

static function retPto(cVal)
local _cVal := ""
Local i
	
	for i:= 1 to len(cVal)
		if substr(cVal,i,1) <> '.'
			_cVal := _cVal+substr(cVal,i,1)
		endif
	next
return _cVal 


Return

