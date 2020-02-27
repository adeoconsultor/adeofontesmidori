#INCLUDE "Protheus.ch"  

#DEFINE PICVAL  "@E 999,999,999.99"

///////////////////////////////////////////////////////////////////////////////
//Relatorio de kardex resumido de todas as filiais. Objetivo de facilitar a conciliação contabil.
//Gera em planilha toda a movimentacao de entrada e saida de todas as unidades 
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br - 17-04-2013
///////////////////////////////////////////////////////////////////////////////

User Function AG_N3xN1()

Local cQuery := ""
Local i
//Exclusivo para gerar para Excel
Private aConteud:= {}       
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab        := "" 


if APMsgNoYes("Deseja Gerar para Excel", "Gerar Excel")
	aDir := MDirArq()
	If Empty(aDir[1]) .OR. Empty(aDir[2])
		Return
	Else                      
		U_AG1_N3xN1()
		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif
else

	Alert("Função disponivel apenas para Excel...", "Atenção")
//	RptStatus({|lEnd| MntRel1(@lEnd,wnRel,titulo,tamanho)},titulo)

endif							

return 

user function AG1_N3xN1()

Local i
Private cPerg   := "AG1_N3xN1"
if !SX1->(dbSeek(cPerg))
	//Cria as perguntas
	AjustaSx1(cPerg)
endif
Pergunte(cPerg,.T.)      


AADD(aConteud, {"REGISTROS DO ARQUIVO SN3"})
AADD(aConteud, {"PERIDO DE "+dToc(mv_par01)+" ATE "+dToc(mv_par02)})
CRIASN3()
cReg := "" 
cCabec := "" 
for i:= 1 to len(aCampos)
	if aCampos[i][2] == "N"
		cReg := cReg+"0;"
	else
  		cReg := cReg+"X;"
  	endif
  cCabec := cCabec+aCampos[i][1]+";"
next i
//cCabec := cCabec + 	'N1_NFISCAL;N1_NSERIE;N1_CALPPIS'

AADD(aConteud, {cCabec})



//					1		2		   3           4              5         6            7             8          9            10           11          12            13        14            15           16          17      18          19        20
//AADD(aConteud, {"FILIAL","PRODUTO", "GRUPO", "CONTA PRODUTO", "ORIGEM", "DT.ENTRADA", "CONTA MOV.", "TES/TM", "TIPO MOV.", "DOCUMENTO", "VLR.SAIDA","VLR.ENTRADA", "NUM.SEQ","ORIG.LANC", "ESTOQUE", "CLIENTE/FORN", "NOME", "GRP CTB","ARMAZEM", "ESPECIE"}) // 20 Colunas  



dbSelectArea("TMPN3")
TMPN3->(dbGotop())
ProcREgua( Reccount() )
nCount:= 1
cTpPCC := ""
cOrigCrd := ""
do while TMPN3->(!eof()) 
//AADD(aConteud, {"","", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"", "", 0,0,0,0,0,0,"", 0,0,0,0,"", "", "", "", "", "", "", "", "", "", "", "", 0,"", 0,0,0,0,0,"", "", "", "", "", "", "", "", "", "", "", 0,0,"", "", "", 0,0,0,0,0,0,0,"", "", "", 0,0,0,0,0,0,0,0,"", "", "", "", "", 0,})	
AADD(aConteud, {"","", "", "", "", "","","","","","","","","","",""})	
nCount++
incproc('Atualizando temp ...Reg '+cValToChar(nCount)+' de '+cValToChar(nReg))
	if Posicione("SN1",1,TMPN3->(N3_FILIAL+N3_CBASE+N3_ITEM),"N1_CALCPIS") == '1'
		cTpPCC := '1-SIM'
	elseif Posicione("SN1",1,TMPN3->(N3_FILIAL+N3_CBASE+N3_ITEM),"N1_CALCPIS") == '2'
		cTpPCC := '2-NAO'
	elseif Posicione("SN1",1,TMPN3->(N3_FILIAL+N3_CBASE+N3_ITEM),"N1_CALCPIS") == '3'
		cTpPCC := '3-FRACAO'
	else
		cTpPCC := 'NAO INFORMADO'
	endif
	
	if Posicione("SN1",1,TMPN3->(N3_FILIAL+N3_CBASE+N3_ITEM),"N1_ORIGCRD") == '0'
		cOrigCrd := 'NACIONAL'
	elseif Posicione("SN1",1,TMPN3->(N3_FILIAL+N3_CBASE+N3_ITEM),"N1_ORIGCRD") == '1'
		cOrigCrd := 'IMPORTADO'
	else
		cOrigCrd := 'NAO INFORMADO'
	endif	
	aConteud[len(aConteud),1] := "'"+TMPN3->N3_FILIAL
	aConteud[len(aConteud),2] := "'"+TMPN3->N3_CBASE 
	aConteud[len(aConteud),3] := TMPN3->N3_BAIXA 
	aConteud[len(aConteud),4] := TMPN3->N3_HISTOR 
	aConteud[len(aConteud),5] := "'"+TMPN3->N3_CCONTAB 
	aConteud[len(aConteud),6] := TMPN3->N3_CUSTBEM 
	aConteud[len(aConteud),9] := TMPN3->N3_VRDMES1
	aConteud[len(aConteud),8] := TMPN3->N3_VORIG1 
	aConteud[len(aConteud),10] := TMPN3->N3_VRDACM1 
	aConteud[len(aConteud),11]:= TMPN3->N3_AQUISIC
	aConteud[len(aConteud),7]:= TMPN3->N3_DINDEPR
	aConteud[len(aConteud),12]:= TMPN3->N1_NFISCAL
	aConteud[len(aConteud),13]:= TMPN3->N1_NSERIE
	aConteud[len(aConteud),14]:= cTpPCC
	aConteud[len(aConteud),15]:= cOrigCrd
	aConteud[len(aConteud),16]:= TMPN3->N1_PRODUTO
	

	
/* " SELECT N3_FILIAL,N3_CBASE,N3_BAIXA,N3_HISTOR,N3_CCONTAB,N3_CUSTBEM,N3_VRDMES1,N3_VORIG1,N3_VRDACM1,N3_AQUISIC, N3_ITEM, N3_DINDEPR, N1_NFISCAL, N1_NSERIE,N1_PRODUTO " 
	aConteud[Len(aConteud),2] := "'"+TMPN3->N1_NFISCAL
	aConteud[Len(aConteud),3] := "'"+TMPN3->N1_NSERIE
	aConteud[Len(aConteud),4] := "'"+TMPN3->N1_PRODUTO 
	aConteud[Len(aConteud),5] := "'"+TMPN3->N1_FORNEC
	aConteud[Len(aConteud),6] := "'"+TMPN3->N1_LOJA	 
	
	*/

//	aConteud[len(aConteud),3] := TMPN3->N3_ITEM 
//	aConteud[len(aConteud),4] := TMPN3->N3_TIPO 

//	aConteud[len(aConteud),5] := TMPN3->N3_TIPREAV 
//	aConteud[len(aConteud),8] := TMPN3->N3_TPSALDO 
//	aConteud[len(aConteud),9] := TMPN3->N3_TPDEPR 

//	aConteud[len(aConteud),12] := TMPN3->N3_CDEPREC 
//	aConteud[len(aConteud),13] := TMPN3->N3_CCUSTO 
//	aConteud[len(aConteud),14] := TMPN3->N3_CCDEPR 
//	aConteud[len(aConteud),15] := TMPN3->N3_CDESP 
/*	aConteud[len(aConteud),16] := TMPN3->N3_CCORREC 
	aConteud[len(aConteud),16] := TMPN3->N3_NLANCTO
	aConteud[len(aConteud),18] := TMPN3->N3_DLANCTO 
	aConteud[len(aConteud),19] := TMPN3->N3_DINDEPR 
	aConteud[len(aConteud),20] := TMPN3->N3_FIMDEPR 
	aConteud[len(aConteud),21] := TMPN3->N3_DEXAUST 
	aConteud[len(aConteud),22] := TMPN3->N3_VORIG1 
	aConteud[len(aConteud),23] := TMPN3->N3_TXDEPR1 
	aConteud[len(aConteud),24] := TMPN3->N3_VORIG2 
	aConteud[len(aConteud),25] := TMPN3->N3_TXDEPR2 
	aConteud[len(aConteud),26] := TMPN3->N3_VORIG3 
	aConteud[len(aConteud),27] := TMPN3->N3_TXDEPR3 
	aConteud[len(aConteud),28] := TMPN3->N3_VORIG4 
	aConteud[len(aConteud),29] := TMPN3->N3_TXDEPR4 
	aConteud[len(aConteud),30] := TMPN3->N3_VORIG5 
	aConteud[len(aConteud),31] := TMPN3->N3_TXDEPR5 
	aConteud[len(aConteud),32] := TMPN3->N3_VRCBAL1 
	aConteud[len(aConteud),33] := TMPN3->N3_VRDBAL1
	aConteud[len(aConteud),33] := TMPN3->N3_VRCMES1 
	aConteud[len(aConteud),34] := TMPN3->N3_VRDMES1
	aConteud[len(aConteud),35] := TMPN3->N3_VRCACM1 
	aConteud[len(aConteud),36] := TMPN3->N3_VRDACM1 
	aConteud[len(aConteud),37] := TMPN3->N3_VRDBAL2 
	aConteud[len(aConteud),38] := TMPN3->N3_VRDMES2 
	aConteud[len(aConteud),39] := TMPN3->N3_VRDACM2 
	aConteud[len(aConteud),40] := TMPN3->N3_VRDBAL3 
	aConteud[len(aConteud),41] := TMPN3->N3_VRDMES3 
	aConteud[len(aConteud),42] := TMPN3->N3_VRDACM3 
	aConteud[len(aConteud),43] := TMPN3->N3_VRDBAL4 
	aConteud[len(aConteud),44] := TMPN3->N3_VRDMES4 
	aConteud[len(aConteud),45] := TMPN3->N3_VRDACM4 
	aConteud[len(aConteud),46] := TMPN3->N3_VRDBAL5 
	aConteud[len(aConteud),47] := TMPN3->N3_VRDMES5 
	aConteud[len(aConteud),48] := TMPN3->N3_VRDACM5 
	aConteud[len(aConteud),49] := TMPN3->N3_INDICE1 
	aConteud[len(aConteud),50] := TMPN3->N3_INDICE2 
	aConteud[len(aConteud),51] := TMPN3->N3_INDICE3 
	aConteud[len(aConteud),52 ] := TMPN3->N3_INDICE4 
	aConteud[len(aConteud),53 ] := TMPN3->N3_INDICE5 
	aConteud[len(aConteud),54 ] := TMPN3->N3_AQUISIC 
	aConteud[len(aConteud),55 ] := TMPN3->N3_DTBAIXA 
	aConteud[len(aConteud),56 ] := TMPN3->N3_VRCDM1 
	aConteud[len(aConteud),57] := TMPN3->N3_VRCDB1 
	aConteud[len(aConteud),58] := TMPN3->N3_VRCDA1 
	aConteud[len(aConteud),59] := TMPN3->N3_PERDEPR 
	aConteud[len(aConteud),60] := TMPN3->N3_VMXDEPR 
	aConteud[len(aConteud),61] := TMPN3->N3_VLSALV1 
	aConteud[len(aConteud),62] := TMPN3->N3_DEPREC 
	aConteud[len(aConteud),63] := TMPN3->N3_PRODANO 
	aConteud[len(aConteud),64] := TMPN3->N3_PRODMES 
	aConteud[len(aConteud),65] := TMPN3->N3_COEFICI 
	aConteud[len(aConteud),66] := TMPN3->N3_VLACTXP 
	aConteud[len(aConteud),67] := TMPN3->N3_OK 
	aConteud[len(aConteud),68] := TMPN3->N3_SEQ 
	aConteud[len(aConteud),69] := TMPN3->N3_CCDESP 
	aConteud[len(aConteud),70] := TMPN3->N3_CCCDEP 
	aConteud[len(aConteud),71] := TMPN3->N3_CCCDES 
	aConteud[len(aConteud),72] := TMPN3->N3_CCCORR 
	aConteud[len(aConteud),73] := TMPN3->N3_SUBCTA 
	aConteud[len(aConteud),74] := TMPN3->N3_SUBCCON 
	aConteud[len(aConteud),75] := TMPN3->N3_SUBCDEP 
	aConteud[len(aConteud),76] := TMPN3->N3_SUBCCDE 
	aConteud[len(aConteud),77] := TMPN3->N3_SUBCDES 
	aConteud[len(aConteud),78] := TMPN3->N3_SUBCCOR 
	aConteud[len(aConteud),79] := TMPN3->N3_BXICMS 
	aConteud[len(aConteud),80] := TMPN3->N3_SEQREAV 
	aConteud[len(aConteud),81] := TMPN3->N3_AMPLIA1 
	aConteud[len(aConteud),82] := TMPN3->N3_AMPLIA2 
	aConteud[len(aConteud),83] := TMPN3->N3_AMPLIA3 
	aConteud[len(aConteud),84] := TMPN3->N3_AMPLIA4 
	aConteud[len(aConteud),85] := TMPN3->N3_AMPLIA5 
	aConteud[len(aConteud),86] := TMPN3->N3_CODBAIX 
	aConteud[len(aConteud),87] := TMPN3->N3_FILORIG 
	aConteud[len(aConteud),88] := TMPN3->N3_CLVL 
	aConteud[len(aConteud),89] := TMPN3->N3_CLVLCON 
	aConteud[len(aConteud),90] := TMPN3->N3_CLVLDEP 
	aConteud[len(aConteud),91] := TMPN3->N3_CLVLCDE 
	aConteud[len(aConteud),92] := TMPN3->N3_CLVLDES 
	aConteud[len(aConteud),93] := TMPN3->N3_CLVLCOR 
	aConteud[len(aConteud),94] := TMPN3->N3_IDBAIXA 
	aConteud[len(aConteud),95] := TMPN3->N3_LOCAL 
	aConteud[len(aConteud),96] := TMPN3->N3_NOVO 
	aConteud[len(aConteud),97] := TMPN3->N3_QUANTD 
	aConteud[len(aConteud),98] := TMPN3->N3_PERCBAI 
	aConteud[len(aConteud),99] := TMPN3->N3_NODIA 
	aConteud[len(aConteud),100] := TMPN3->N3_DIACTB 
	aConteud[len(aConteud),101] := TMPN3->N3_DTACELE 
	aConteud[len(aConteud),102] := TMPN3->N3_VLACEL1 
	aConteud[len(aConteud),103] := TMPN3->N3_VLACEL2 
	aConteud[len(aConteud),104] := TMPN3->N3_VLACEL3 
	aConteud[len(aConteud),105] := TMPN3->N3_VLACEL4 
	aConteud[len(aConteud),106] := TMPN3->N3_VLACEL5 
	aConteud[len(aConteud),107] := TMPN3->N3_CLVRCOA 
	aConteud[len(aConteud),108] := TMPN3->N3_CLVRDEA 
	aConteud[len(aConteud),109] := TMPN3->N3_CTXPERD 
	aConteud[len(aConteud),110] := TMPN3->N3_USERLGI 
	aConteud[len(aConteud),111] := TMPN3->N3_USERLGA 
	aConteud[len(aConteud),112] := TMPN3->N3_VRCACM2 
	aConteud[len(aConteud),113] := TMPN3->N3_VRCACM3 
	aConteud[len(aConteud),114] := TMPN3->N3_VRCACM4 
	aConteud[len(aConteud),115] := TMPN3->N3_VRCACM5 
	aConteud[len(aConteud),116] := TMPN3->N3_VRCDA2 
	aConteud[len(aConteud),117] := TMPN3->N3_VRCDA3 
	aConteud[len(aConteud),118] := TMPN3->N3_VRCDA4 
	aConteud[len(aConteud),119] := TMPN3->N3_VRCDA5 
	aConteud[len(aConteud),120] := TMPN3->N3_CALCDEP 
	aConteud[len(aConteud),121] := TMPN3->N3_RATEIO 
	aConteud[len(aConteud),122] := TMPN3->N3_CODRAT 
	aConteud[len(aConteud),123] := TMPN3->N3_CRIDEPR 
	aConteud[len(aConteud),124] := TMPN3->N3_CALDEPR 
	aConteud[len(aConteud),125] := TMPN3->N3_PRODACM */
	TMPN3->(dbSkip())
enddo 


//--------------------------------
Static Function AjustaSx1(cPerg)
//--------------------------------
//Variaveis locais
Local aRegs := {}
Local i,j
//Inicio da funcao
dbSelectArea("SX1")
dbSetOrder(1)
//   1          2        3         4          5           6       7       8             9        10      11     12       13        14        15         16       17       18       19        20          21        22      23        24       25         26        27       28       29       30          31        32       33       34        35          36        37     38     39       40       41        42
//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_PYME/X1_GRPSXG/X1_HELP/X1_PICTURE
PutSx1(cPerg,"01","Data Inicial                  ?"," "," ","mv_ch1","D",8,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo inicial"},{"Informe o periodo inicial"},{"Informe o periodo inicial"})
PutSx1(cPerg,"02","Data final                    ?"," "," ","mv_ch2","D",8,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o periodo final"},{"Informe o periodo final"},{"Informe o periodo final"})
//PutSx1(cPerg,"03","Produto de                    ?"," "," ","mv_ch3","C",15,0,0,"G","","SB1","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto inicial"},{"Informe o produto inicial"},{"Informe o produto inicial"})
//PutSx1(cPerg,"04","Produto ate                   ?"," "," ","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto final"},{"Informe o produto final"},{"Informe o produto final"})
//PutSx1(cPerg,"05","Grupo Inicial                 ?"," "," ","mv_ch5","C",04,0,0,"G","","SBM","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o grupo inicial"},{"Informe o grupo inicial"},{"Informe o grupo inicial"})
//PutSx1(cPerg,"06","Grupo Final                   ?"," "," ","mv_ch6","C",04,0,0,"G","","SBM","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o grupo final"},{"Informe o grupo final"},{"Informe o grupo final"})


//Loop de armazenamento
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			endif
		Next
		MsUnlock()
	endif
Next
Return()






Return()


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
Private cArq    := Space(10)
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
	@ 25, 10 MSGET cArq               SIZE 50,8 PIXEL OF oDlgDir
	
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


//+-----------------------------------------------------------------------------------//
//|Funcao....: MCSV
//|Descricao.: Gera Arvquivo do tipo csv
//|Retorno...: .T. ou .F.
//|Observação:
//+-----------------------------------------------------------------------------------//

*-------------------------------------------------*
Static Function MCVS(axVet,cxCab,cxArqTxt,PICTUSE)
*-------------------------------------------------*

Local cEOL       := CHR(13)+CHR(10)
Local nTamLin    := 2
Local cLin       := Space(nTamLin)+cEOL
Local cDadosCSV  := ""
Local lRet       := .T.
Local nHdl,nt,jk       := 0

If Len(axVet) == 0
	MsgInfo("Dados não informados","Sem dados")
	lRet := .F.
	Return(lRet)
ElseIf Empty(cxArqTxt)
	MsgInfo("Diretório e nome do arquivo não informados corretamente","Diretório ou Arquivo")
	lRet := .F.
	Return(lRet)
EndIf

cxArqTxt := cxArqTxt+".csv"
nHdl := fCreate(cxArqTxt)

If nHdl == -1
	MsgAlert("O arquivo de nome "+cxArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

nTamLin := 2
cLin    := Space(nTamLin)+cEOL

ProcRegua(Len(axVet))

If !Empty(cxCab)
	cLin := Stuff(cLin,01,02,cxCab)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no Cabeçalho. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		Endif
	Endif
EndIf

For jk := 1 to Len(axVet)
	nTamLin   := 2
	cLin      := Space(nTamLin)+cEOL
	cDadosCSV := ""
	IncProc("Gerando arquivo CSV")
	For nt := 1 to Len(axVet[jk])
		If ValType(axVet[jk,nt]) == "C"
			cDadosCSV += axVet[jk,nt]+Iif(nt = Len(axVet[jk]),"",";")
		ElseIf ValType(axVet[jk,nt]) == "N"
			cDadosCSV += Transform(axVet[jk,nt],PICTUSE)+Iif(nt = Len(axVet[jk]),"",";")
		ElseIf ValType(axVet[jk,nt]) == "U"
			cDadosCSV += +Iif(nt = Len(axVet[jk]),"",";")
		Else
			cDadosCSV += axVet[jk,nt]+Iif(nt = Len(axVet[jk]),"",";")
		EndIf
	Next
	cLin := Stuff(cLin,01,02,cDadosCSV)
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo nos Itens. Continua?","Atencao!")
			lOk := .F.
			Return(lOk)
		Endif
	Endif
Next
fClose(nHdl)
Return(lOk)

//+-----------------------------------------------------------------------------------//
//|Funcao....: MExcel
//|Descricao.: Abre arquivo csv em excel
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MExcel(cxDir,cxArq)
*-----------------------------------------*
Local cArqTxt := cxDir+cxArq+".csv"
Local cMsg    := "Relatorio gerado com sucesso!"+CHR(13)+CHR(10)+"O arquivo "+cxArq+".csv"
cMsg    += " se encontra no diretório "+cxDir

MsgInfo(cMsg,"Atenção")

If MsgYesNo("Deseja Abrir o arquivo em Excel?","Atenção")
	If ! ApOleClient( 'MsExcel' )
		MsgStop(" MsExcel nao instalado ")
		Return
	EndIf
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cArqTxt)
	oExcelApp:SetVisible(.T.)
EndIf

Return


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Monta a consulta com os movimentos da tabela SN3
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static function CRIASN3()
public aTitulos := {}
public cCampos := ""
public aCampos := {}
public nReg    := 0
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SN3")
While !EOF() .And. (x3_arquivo == "SN3")

	//if Alltrim(SX3->X3_CAMPO) $ 'N3_FILIAL, N1_NFISCAL, N1_NSERIE, N1_PRODUTO, N1_FORNEC, N1_LOJA, N3_CBASE,N3_BAIXA,N3_HISTOR,N3_CCONTAB,N3_CUSTBEM,N3_VRDMES1,N3_VORIG1,N3_VRDACM1,N3_AQUISIC'	
   if Alltrim(SX3->X3_CAMPO) $ 'N3_FILIAL, N3_CBASE,N3_BAIXA,N3_HISTOR,N3_CCONTAB,N3_CUSTBEM,N3_VRDMES1,N3_VORIG1,N3_VRDACM1,N3_AQUISIC,N3_DINDEPR'		
		cCampos := cCampos+SX3->X3_CAMPO+","	
		aAdd( aTitulos, {SX3->X3_TITULO} )
		aAdd(aCampos, {ALLTRIM(SX3->X3_CAMPO), SX3->X3_TIPO})
	endif

	dbSkip()
EndDO

aAdd(aCampos, {'N1_NFISCAL', 'C'} )
aAdd(aCampos, {'N1_NSERIE' , 'C'} )
aAdd(aCampos, {'N1_CALPPIS', 'C'} )
aAdd(aCampos, {'N1_ORIGCRD', 'C'} )
aAdd(aCampos, {'N1_PRODUTO', 'C'} )



cCampos := Substr(cCampos,1,len(cCampos)-1)

	if Select("TMPCT") > 0
		dbSelectArea("TMPCT")
		TMPCT->(dbCloseArea())
	endif
	cQuery := " SELECT Count(*) NREG FROM SN3010 WHERE D_E_L_E_T_ = ' ' "
	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), 'TMPCT', .T., .T. )
	
//	Alert('Total de Registros -> '+cValToChar(TMPCT->NREG))
	nReg := TMPCT->NREG
	if Select("TMPN3") > 0
		dbSelectArea("TMPN3")
		TMPN3->(dbCloseArea())
	endif

/*	cQuery := " SELECT distinct N3_FILIAL,N3_CBASE, N1_NFISCAL, N1_NSERIE, N1_PRODUTO, N1_FORNEC, N1_LOJA, "
	cQuery += " N3_BAIXA,N3_HISTOR,N3_CCONTAB,N3_CUSTBEM, N3_VRDMES1,N3_VORIG1,N3_VRDACM1,N3_AQUISIC "
	cQuery += " FROM SN3010 SN3, SN1010 SN1 "
	cQuery += " WHERE SN3.D_E_L_E_T_ = ' ' and SN1.D_E_L_E_T_ =' ' "
	cQuery += " and N1_FILIAL = N3_FILIAL and N1_CBASE = N3_CBASE order by 2 "

	*/
	cQuery := " SELECT N3_FILIAL,N3_CBASE,N3_BAIXA,N3_HISTOR,N3_CCONTAB,N3_CUSTBEM,N3_VRDMES1,N3_VORIG1,N3_VRDACM1,N3_AQUISIC, N3_ITEM,N3_DINDEPR, N1_NFISCAL, N1_NSERIE,N1_PRODUTO " 
	cQuery += " FROM SN3010 SN3, SN1010 SN1 "
	cQuery += " WHERE SN3.D_E_L_E_T_ = ' ' and SN1.D_E_L_E_T_ =' ' "
	cQuery += " AND N3_AQUISIC between '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
	cQuery += " and N1_FILIAL = N3_FILIAL and N1_CBASE = N3_CBASE and N1_ITEM = N3_ITEM order by 1,2 "
	
//	cQuery := " SELECT N3_FILIAL,N3_CBASE,N3_ITEM,N3_TIPO,N3_TIPREAV,N3_BAIXA,N3_HISTOR,N3_TPSALDO,N3_TPDEPR,N3_CCONTAB,N3_CUSTBEM,N3_CDEPREC,N3_CCUSTO,N3_CCDEPR,N3_CDESP,N3_CCORREC,N3_NLANCTO,N3_DLANCTO,N3_DINDEPR,N3_FIMDEPR,N3_DEXAUST,N3_VORIG1,N3_TXDEPR1,N3_VORIG2,N3_TXDEPR2,N3_VORIG3,N3_TXDEPR3,N3_VORIG4,N3_TXDEPR4,N3_VORIG5,N3_TXDEPR5,N3_VRCBAL1,N3_VRDBAL1,N3_VRCMES1,N3_VRDMES1,N3_VRCACM1,N3_VRDACM1,N3_VRDBAL2,N3_VRDMES2,N3_VRDACM2,N3_VRDBAL3,N3_VRDMES3,N3_VRDACM3,N3_VRDBAL4,N3_VRDMES4,N3_VRDACM4,N3_VRDBAL5,N3_VRDMES5,N3_VRDACM5,N3_INDICE1,N3_INDICE2,N3_INDICE3,N3_INDICE4,N3_INDICE5,N3_AQUISIC,N3_DTBAIXA,N3_VRCDM1,N3_VRCDB1,N3_VRCDA1,N3_PERDEPR,N3_VMXDEPR,N3_VLSALV1,N3_DEPREC,N3_PRODANO,N3_PRODMES,N3_COEFICI,N3_VLACTXP,N3_OK,N3_SEQ,N3_CCDESP,N3_CCCDEP,N3_CCCDES,N3_CCCORR,N3_SUBCTA,N3_SUBCCON,N3_SUBCDEP,N3_SUBCCDE,N3_SUBCDES,N3_SUBCCOR,N3_BXICMS,N3_SEQREAV,N3_AMPLIA1,N3_AMPLIA2,N3_AMPLIA3,N3_AMPLIA4,N3_AMPLIA5,N3_CODBAIX,N3_FILORIG,N3_CLVL,N3_CLVLCON,N3_CLVLDEP,N3_CLVLCDE,N3_CLVLDES,N3_CLVLCOR,N3_IDBAIXA,N3_LOCAL,N3_NOVO,N3_QUANTD,N3_PERCBAI,N3_NODIA,N3_DIACTB,N3_DTACELE,N3_VLACEL1,N3_VLACEL2,N3_VLACEL3,N3_VLACEL4,N3_VLACEL5,N3_CLVRCOA,N3_CLVRDEA,N3_CTXPERD,N3_USERLGI,N3_USERLGA,N3_VRCACM2,N3_VRCACM3,N3_VRCACM4,N3_VRCACM5,N3_VRCDA2,N3_VRCDA3,N3_VRCDA4,N3_VRCDA5,N3_CALCDEP,N3_RATEIO,N3_CODRAT,N3_CRIDEPR,N3_CALDEPR,N3_PRODACM FROM SN3010 WHERE D_E_L_E_T_ = ' ' "	          
	
	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), 'TMPN3', .T., .T. )
	
return 	