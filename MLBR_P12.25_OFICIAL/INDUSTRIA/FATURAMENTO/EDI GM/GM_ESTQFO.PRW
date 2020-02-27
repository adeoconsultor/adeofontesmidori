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
±±³Programa     ³ GM_POSEST        ³ Responsavel ³ REGINALDO NASCIMENTO   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o    ³ GERACAO DE ARQUIVO TEXTO POSICAO DE ESTOQUE             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Data        ³ 01/08/11         ³ Implantacao ³                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador ³ ANESIO G.FARIA                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GM_ESTQFO()
********************
LOCAL   aGMESTC5   := GetArea()
LOCAL   aGMESTB2   := SC5->(GetArea())
LOCAL   aGMESTC6   := SC6->(GetArea())
LOCAL   aGNESTZK   := SZK->(GetArea())
Local   lRet       := .T.
PRIVATE cArq       := ""
PRIVATE cDir       := ""
PRIVATE cPerg      := "MD_ESTQFO"
PRIVATE aRegistros := {}
//Exclusivo para gerar para TXT
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
A := 5


aDir := MDirArq()

	aDir[2] := UPPER(Alltrim(aDir[2]))+'.DAT' 
	

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
		Processa({|| GMESTQFO()},"Gerando posição de estoque....")
    endif

	
	fClose(nHdl)
  //–	FRENAME(cDir+cArq, cDir+"ESTQFO"+UPPER(cArq)) 

	
	KeyBoard Chr(27)
	KeyBoard Chr(27)
//Endif


RestArea(aGMESTC5)
RestArea(aGMESTB2)
RestArea(aGMESTC6)

Return

Static Function GMESTQFO()
************************
                                                                                  
cQuery := ""
cQuery += " SELECT B2_COD, B2_QATU, B1_PESO, C6_QTDVEN, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO, C5_NUM, C5_PEDCLI, "
cQuery += " C5_CODFORN, C5_PEDSAP, C5_LNSAP, C5_PBRUTO, C5_VOLUME1, C6_LNSAP, C5_LOJAGM "
cQuery += " FROM "+RetSqlName("SB2")+" SB2, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+ " SC6 "
cQuery += " WHERE B2_FILIAL = '"+xFilial("SB2")+"' AND SB2.D_E_L_E_T_ = ' ' "
cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ = ' ' "  
cQuery += " AND C5_FILIAL = '"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_ = ' ' "  
cQuery += " AND C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.D_E_L_E_T_ = ' ' "  
cQuery += " AND B1_COD = B2_COD  "
cQuery += " AND C6_NUM = C5_NUM AND C6_FILIAL = C5_FILIAL "
cQuery += " AND C6_PRODUTO = B2_COD AND C6_LOCAL = B2_LOCAL "
cQuery += " AND C6_PRODUTO = B1_COD " 
cQuery += " AND C5_NUM BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cQuery += " AND C5_CLIENTE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
cQuery += " AND C5_LOJACLI BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
cQuery += " ORDER BY C6_NUM, C6_ITEM "
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"MAR",.T.,.F.)

dbSelectArea("MAR")
dbGotop()

////////////////////////////////////////////////////////////////////////////////////////////////////
//HEADER DO ARQUIVO POSICAO DE ESTOQUE
cHDIdent	:= "HEADER" //Header do arquivo
cHDnomearq  := "ESTQFO"+DTOS(DATE())+Substr(TIME(),1,2)+Substr(TIME(),4,2)+Substr(TIME(),7,2)+Space(31)
cHDUsoFut   := Space(27)
cHDCrLf     := Chr(13)+Chr(10)
nCount      := 0

Procregua(reccount())              
cLinha := cHDIdent+cHDnomeArq+cHDUsoFut+cHDCRLf

fWrite(nHdl,cLinha,Len(cLinha))                
nCount++

While !EOF()
	
	Incproc()
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	//DETALHE DO ARQUIVO DE NOTA FISCAL
//	cEsCodPC    := Substr(Posicione('SA7',1,xFilial('SA7')+MAR->(C5_CLIENTE+C5_LOJACLI+B2_COD),'A7_CODCLI'),1,8)  //Space(2)+Substr(MAR->B2_COD,1,6) // No Layout da GM constam 8 digitos para o código da peça
	cEsCodPC    := Substr(Posicione('SA7',1,xFilial('SA7')+'00055589'+MAR->(B2_COD),'A7_CODCLI'),1,8)  //Space(2)+Substr(MAR->B2_COD,1,6) // No Layout da GM constam 8 digitos para o código da peça
	cEsCodCli   := MAR->C5_LOJAGM //Posicione("SZK",1,xFilial("SZK")+MAR->(C5_CLIENTE+C5_LOJACLI),"ZK_CODEXT")
	cEsNumPed   := Substr(MAR->C5_PEDCLI,1,6)
	cEsQuant    := MAR->C6_QTDVEN //MAR->B2_QATU //Tamanho 05
	cEsDtConf   := Substr(MAR->C5_EMISSAO,7,2)+Substr(MAR->C5_EMISSAO,5,2)+Substr(MAR->C5_EMISSAO,1,4)
	cEsCodFor   := Subst(MAR->C5_CODFORN,1,9) // DUNS do Fornecedor
	cEsTpDSO    := 'C' 
	cEsPedSAP   := Substr(MAR->C5_PEDSAP,1,9) //verificar a origem dessa informação....
	cEsPeso     := MAR->C6_QTDVEN * Posicione('SB1',1,xFilial('SB1')+MAR->B2_COD,"B1_PESBRU") //space(7)   //Tamanho 09
	cEsVolume   := MAR->C6_QTDVEN //space(5) //conforme informacao da Simone será 1 volume para cada item.
	cEsLnSAP    := MAR->C6_LNSAP //space(5)
	cDTUsoFut   := space(15) // Uso Futuro....
	cDTCrLf     := Chr(13)+Chr(10)
	                   
	cLinha 	:= cEsCodPC+cEsCodCli+cEsNumPed+StrZero(cEsQuant,5)+cEsDtConf+cEsCodFor+cEsTpDSO+cEsPedSAP+;
		Strzero(cEsPeso,7)+Strzero(cEsVolume,5)+cEsLnSAP+cDTUsoFut+cDTCrLf

		
	fWrite(nHdl,cLinha,Len(cLinha))
	nCount++ //Contador para somar o numero de linhas na nota e gravar no trailler do arquivo...		
	dbSelectArea("MAR")
	dbSkip()
Enddo

////////////////////////////////////////////////////////////////////////////////////////////////////
//TRAILLER DO ARQUIVO DE NOTA FISCAL......
cTRIdent   	:= "TRAILLER" //Trailler do arquivo
nCount++
cTRUsoFut   := Space(71)


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
Private cArq    := 'ESTQFO'+DTOS(DATE())+Substr(TIME(),1,2)+Substr(TIME(),4,2)+Substr(TIME(),7,2)
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
	@ 25, 10 MSGET cArq               SIZE 100,8 WHEN .F. PIXEL OF oDlgDir
	
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
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Anesio G.Faria -    ³    02.08.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aArea := GetArea()
PutSx1(cPerg,"01","Pedido de                     ?"," "," ","mv_ch1","C",6,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o pedido inicial "},{"Informe o pedido inicial "},{"Informe o pedido inicial "})
PutSx1(cPerg,"02","Pedido ate                    ?"," "," ","mv_ch2","C",6,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o pedido final "},{"Informe o pedido final "},{"Informe o pedido final "})
PutSx1(cPerg,"03","Cliente de                    ?"," "," ","mv_ch3","C",6,0,0,	"G","","SA1","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o cliente inicial"},{"Informe o cliente inicial"},{"Informe o cliente inicial"})
PutSx1(cPerg,"04","Cliente ate                   ?"," "," ","mv_ch4","C",6,0,0,	"G","","SA1","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o cliente final"},{"Informe o cliente final"},{"Informe o cliente final"})
PutSx1(cPerg,"05","Loja de                       ?"," "," ","mv_ch5","C",2,0,0,	"G","","   ","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a loja inicial "},{"Informe a loja inicial "},{"Informe a loja inicial "})
PutSx1(cPerg,"06","Loja ate                      ?"," "," ","mv_ch6","C",2,0,0,	"G","","   ","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe a loja final   "},{"Informe a loja final   "},{"Informe a loja final   "})
RestArea(aArea)
Return

