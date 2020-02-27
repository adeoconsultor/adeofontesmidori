#include 'rwmake.ch'
#include 'protheus.ch'
#DEFINE PICVAL  "@E 999,999,999.99"

user function AGF_CALCPIMP()
private lEnd := .F. 

 Processa({|lEnd| VLRIMP()},"Aguarde", "Calculando parcela de importado.......", .T.)						

return                             


static function VLRIMP()
local cQuery  := "" 
local nCount  := 0
local dtUlMes := getmv ('MA_MESFCI')
local aStru	  := {}
Local i

//Array gravando a composicao dos custos apurados....
aadd(aStru, {'CALCULO DE COMPOSICAO DE IMPORTAÇÃO REALIZADO EM '+dToc(dDatabase)+' PARA FILIAL DE '+cFilAnt})
aadd(aStru, {' P.PRINCIPAL', 'DESCRICAO', 'LOCAL', 'CUSTO ACABADO', 'ORIGEM', 'CUSTO CALCULADO','P.ORIGEM', 'DESCRICAO ORIGEM', 'QTDE', 'ORIGEM MAT', 'ORIGEM CUSTO','CUSTO ORIG', 'COMPOSICAO RECURSIVA',"SUGESTAO ORIGEM", "INDICE IMPORTADO" })

if ApmsgNoYes('Deseja fazer o calculo do conteudo de importação para os produtos'+chr(13)+chr(13)+"Será calculado no fechamento de "+dToc(dtUlmes),'Atenção')
   if cFilAnt $  '09' 
		ApmsgInfo('Quando calculado essa rotina para a filial 09 PNP1'+chr(13)+'deve-se rodar para as unidades 08, 04, 19 e 01'+;
		chr(13)+'Nessa ordem...' ,'Atencao!!!')
	endif
	
	cQuery := " Select G1_COD, B1_DESC, B1_ORIGEM, G1_COMP, MATERIAL, QTDMAT, ORIMAT, G1_NIVINV from " 
	cQuery += " SB1010 SB1, " 
	cQuery += " (select G1_COD, G1_COMP, B1_DESC MATERIAL, G1_QUANT QTDMAT,  B1_ORIGEM ORIMAT, G1_NIVINV from SG1010 SG1, SB1010 SB1 "
	cQuery += " where SG1.D_E_L_E_T_ = ' ' and SB1.D_E_L_E_T_ = ' ' "
	cQuery += " and G1_COMP = B1_COD  "
	cQuery += " and B1_ORIGEM in ('0','1','2','3','5') "
	cQuery += " and G1_FILIAL = '"+xFilial('SG1')+"' ) MATERIAL "
	cQuery += " where SB1.D_E_L_E_T_ = ' ' "
	cQuery += " and G1_COD = B1_COD "
	cQuery += " and B1_ORIGEM not in ('6','7') " 
	cQuery += " and Substring(G1_COMP,1,3) <> 'MOD' " 
//	cQuery += " AND G1_COMP in ('001940') "
	cQuery += " order by G1_NIVINV, G1_COD asc "
	
	if Select('TMPG1') > 0 
		dbSelectArea('TMPG1')
		dbCloseArea()
	endif
	
	dbUseArea(.T. , 'TOPCONN', tcGenQry( , , cQuery), 'TMPG1', .T., .T.)


//Rotina para zerar o valor da parcela importada de todos os produtos do cadastro.
//Apenas quando rodar a filial 09,,, posterior a isso deve-se rodar todas as unidades... 
//Sequencia para rodar o calculo: Filial 09, 08, 04, 19, 01 nessa ordem.... 
if cFilAnt == '09'

		cQSB1 := "UPDATE "+ RetSqlName( 'SB1' ) + " SET B1_X_VLIMP = 0 where D_E_L_E_T_ =' ' and B1_X_VLIMP > 0 "

		nret1 := TcSqlExec( cQSB1 )

		//	ApMsgInfo('Atualizado CONTEUDO para ZERO')	
endif  

dbSelectArea('TMPG1')
TMPG1->(dbGotop())
cCodOld := TMPG1->G1_COD
nValImp := 0

nCount  := 0
nCountBZ:= 0
ProcREgua( Reccount() )
//Rotina que faz o calculo da composicao de importação dos produtos que possuem estrutura na SG1
while !TMPG1->(eof())
	incproc('Atualizando comp.importação...'+TMPG1->G1_COD)
    
	//Grava o valor importado quando o loop trocar de código
	if TMPG1->G1_COD <> cCodOld
		dbSelectArea('SB1')
		dbSetOrder(1)
		if dbSeek(xFilial('SB1')+cCodOld)
			RecLock('SB1',.F.)                                     
			Replace B1_X_VLIMP with nValImp
			if nCusto > 0
				Replace B1_X_PERIM with iif(nValImp / nCusto > 1, 0, nValImp / nCusto)
			endif
			if nCusto > 0 .and. nValImp > 0
				if (nValImp / nCusto) >= .4  	// Se o conteudo de importacao for superior ou igual a 40%
//					Replace B1_ORIGEM with '3'
				else							// Se o conteudo de importacao for inferior a 4%
//					Replace B1_ORIGEM with '5'
				endif
			elseif !cFilAnt $ '09'
				if nValImp > 0 
//					Replace B1_ORIGEM with '5'
				endif
			endif
			MsUnLock('SB1')
			aStru[len(aStru)][5]:= SB1->B1_ORIGEM
		endif
		nValImp := 0
	endif



	//Rotina para buscar o local do produto acabado 
	dbSelectArea('SBZ')
	dbSetOrder(1)
	If dbSeek(xFilial('SBZ')+TMPG1->G1_COD)
    	cLocal := SBZ->BZ_LOCPAD
 	else
 		cLocal := Posicione('SB1',1, xFilial('SB1')+TMPG1->G1_COD, "B1_LOCPAD")
 	endif
 	
 	//Rotina para buscar o custo do material acabado
 	nCusto 	:= 0
 	nCusto  := Posicione('SB2',1,xFilial('SB2')+TMPG1->G1_COD+cLocal,"B2_CM1")
 	
 	//Rotina desenvolvida para buscar o custo de alguns produtos que constam zerado na SB2 para o armazem padrao cadastrado
 	//Alguns produtos tem armazem padrao 01 porem a movimentação está ocorrendo em outro armazem
	if nCusto == 0 
		cQSB2 := " SELECT AVG(B2_CM1) CUSMED FROM SB2010 WHERE D_E_L_E_T_ =' ' and B2_FILIAL = '"+xFilial('SB2')+"' "
		cQSB2 += " AND B2_COD = '"+TMPG1->G1_COD+"' AND B2_CM1 > 0 "
		if Select('TMPB2') > 0
			dbSelectArea("TMPB2")
			TMPB2->(dbCloseArea())
		endif
		dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQSB2), 'TMPB2',.T.,.T.)
		
		dbSelectArea('TMPB2')
		TMPB2->(dbGotop())
		nCusto := TMPB2->CUSMED
	endif
	//Array com a composicao do custo calculado
	aadd(aStru, {TMPG1->G1_COD+"'", TMPG1->B1_DESC, cLocal+"'", nCusto, TMPG1->B1_ORIGEM, 0, TMPG1->G1_COMP+"'", TMPG1->MATERIAL, TMPG1->QTDMAT, TMPG1->ORIMAT, '',0,0, 0})
	
	//Verifica se o produto que está sendo consumido pertence ao grupo 3 ou 5, caso positivo 
	//Pega o valor de importado que já foi calculado no campo B1_X_VLIMP e multiplica pela quantidade de material 
	//padrao da estrutura
	if posicione('SB1',1, xFilial('SB1')+TMPG1->G1_COMP, "B1_ORIGEM") $ '3|5' 
		//Verifica se já está calculado o conteudo de importação para o ITEM....
//		apmsginfo('Buscando item '+cCodOld+' Componente '+TMPG1->G1_COMP)
		if (posicione('SB1',1, xFilial('SB1')+TMPG1->G1_COMP, "B1_X_VLIMP") * TMPG1->QTDMAT) > 0
			nValImp += posicione('SB1',1, xFilial('SB1')+TMPG1->G1_COMP, "B1_X_VLIMP") * TMPG1->QTDMAT
			
		else //Caso o produto esteja com origem 3 ou 5 e não tenha o valor do conteudo de importação ainda, 
			 //Executa a rotina abaixo para saber o valor do conteudo, pois a estrutura que utiliza esse item precisa desse valor.
			nValImp += calcRec(TMPG1->G1_COMP, dtUlMes)
		endif

	else

		//Rotina para desconsiderar os itens com origem 0 ou 2
		if posicione('SB1',1, xFilial('SB1')+TMPG1->G1_COMP, "B1_ORIGEM") $ '0|2'
			TMPG1->(dbSkip())
			loop
		endif


		//Caso nao tenha encontrado custo previamente calculado, faz o processo normal buscando nas origens do material...
		//Pesquisa se o produto está cadastrado no cadastro de indicadores, caso positivo utiliza o armazem indicado na SBZ para calculo do custo
		dbSelectArea('SBZ')
		dbSetOrder(1)
		If dbSeek(xFilial('SBZ')+TMPG1->G1_COMP)
			dbSelectArea('SB2')
			dbSetOrder(1)
			dbSeek(xFilial('SB2')+SBZ->(BZ_COD+BZ_LOCPAD))
				//Verifica se o produto tem Custo médio cadastrado na SB2, caso positivo, utiliza esse custo x a qtde de material e adiciona
				//ao custo da parcela importada
				if SB2->B2_CM1 > 0 
					nValImp += SB2->B2_CM1 * TMPG1->QTDMAT 
					aStru[len(aStru)][11]  := "SBZ+SB2 - LOCAL "+SBZ->BZ_LOCPAD
					aStru[len(aStru)][12] := SB2->B2_CM1
				//Caso o produto não t		enha custo na SB2, faz a busca pelo ultimo fechamento que consta na SB9 para compor o custo da parcela importada
				//referente ao item.
				else
					cQSB9 := " SELECT B9_CUSTD from SB9010 Where D_E_L_E_T_ = ' ' and B9_FILIAL = '"+xFilial('SB9')+"' "
					cQSB9 += " AND B9_DATA = '"+dTos(dtUlmes)+"' AND B9_COD = '"+TMPG1->G1_COMP+"' AND B9_LOCAL = '"+SBZ->BZ_LOCPAD+"' "
					if Select('TMPB9') > 0 
						dbSelectArea('TMPB9')
						TMPB9->(dbCloseArea())
					endif
					dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQSB9), 'TMPB9', .T., .T.)
					dbSelectArea('TMPB9')
					nValImp += TMPB9->B9_CUSTD * TMPG1->QTDMAT 
					aStru[len(aStru)][11] := "SBZ+SB9"+' - LOCAL '+SBZ->BZ_LOCPAD+' - FECH DIA: '+dToc(dtUlmes)
					aStru[len(aStru)][12] := TMPB9->B9_CUSTD
				endif
			ncountBZ++
		else
		//Caso o produto não esteja cadastrado na SBZ o calculo é feito diretamente pelo SB1 (Cadastro de produtos)
		dbSelectArea('SB1')
		dbSetOrder(1)
		If dbSeek(xFilial('SB1')+TMPG1->G1_COMP)
			dbSelectArea('SB2')
			dbSetOrder(1)
			dbSeek(xFilial('SB2')+SB1->(B1_COD+B1_LOCPAD))
				//Verifica se o produto tem Custo médio cadastrado na SB2, caso positivo, utiliza esse custo x a qtde de material e adiciona
				//ao custo da parcela importada
				if SB2->B2_CM1 > 0
					aStru[len(aStru)][11] := "SB1+SB2 - LOCAL "+SB1->B1_LOCPAD
					aStru[len(aStru)][12] := SB2->B2_CM1
					nValImp += SB2->B2_CM1 * TMPG1->QTDMAT
				//Caso o produto não tenha custo na SB2, faz a busca pelo ultimo fechamento que consta na SB9 para compor o custo da parcela importada
				//referente ao item.
				else
					cQSB9 := " SELECT B9_CUSTD from SB9010 Where D_E_L_E_T_ = ' ' and B9_FILIAL = '"+xFilial('SB9')+"' "
					cQSB9 += " AND B9_DATA = '"+dTos(dtUlmes)+"' AND B9_COD = '"+TMPG1->G1_COMP+"' AND B9_LOCAL = '"+SBZ->BZ_LOCPAD+"' "
					if Select('TMPB9') > 0 
						dbSelectArea('TMPB9')
						TMPB9->(dbCloseArea())
					endif
					dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQSB9), 'TMPB9', .T., .T.)
					dbSelectArea('TMPB9')
					aStru[len(aStru)][11] := "SB1+SB9 - LOCAL "+SB1->B1_LOCPAD+' - FECH DIA: '+dToc(dtUlmes)
					aStru[len(aStru)][12] := TMPB9->B9_CUSTD
					nValImp += TMPB9->B9_CUSTD * TMPG1->QTDMAT 
				endif
				ncount++
			endif
		endif
	endif
	//Permite ao usuario cancelar o processamento da rotina, os itens já processados nao serao desfeito.
	If lEnd
		ApMsgInfo('Rotina cancelada pelo usuário...')
		Exit
	EndIf
	
	//Busca o valor da composicao de importaçao já gravada no proprio produto
	//Essa rotina libera de fazer o calculo recursivo na estrutura.
//	nValImp += Posicione('SB1',1, xFilial('SB1')+TMPG1->G1_COMP,"B1_X_VLIMP")	
	aStru[len(aStru)][6] := nValImp	
	aStru[len(aStru)][13] := Posicione('SB1',1, xFilial('SB1')+TMPG1->G1_COMP,"B1_X_VLIMP")
	cCodOld := TMPG1->G1_COD
	TMPG1->(dbSkip())
enddo
//Rotina para gravar a composicao do custo do ultimo registro do loop, tendo em vista que ele não estará voltando para fazer a gravação.
dbSelectArea('SB1')
dbSetOrder(1)
if dbSeek(xFilial('SB1')+cCodOld)
	RecLock('SB1',.F.)
	Replace B1_X_VLIMP with nValImp
	//Identificar a origem que deve conter no produto...
	if nCusto > 0 .and. nValImp > 0
		if (nValImp / nCusto) >= .4  	// Se o conteudo de importacao for superior ou igual a 40%
//			Replace B1_ORIGEM with '3'
		else							// Se o conteudo de importacao for inferior a 40%
//			Replace B1_ORIGEM with '5'
		endif
	endif
	MsUnLock('SB1')
	
endif

//Refazer os itens que estao com conteudo de importacao = 3//certifica se está correto..
cQSB1 := " SELECT B1_COD from SB1010 where D_E_L_E_T_ = ' ' and B1_ORIGEM = '3' "
if Select('TMPB1') > 0 
	dbSelectArea('TMPB1')
	TMPB1->(dbCloseArea())
endif
dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQSB1), 'TMPB1', .T., .T.)
nCount3 := 0
dbSelectArea('TMPB1')
TMPB1->(dbGotop())
while !TMPB1->(eof())
	IncProc('Revisando produtos de origem 3 '+TMPG1->G1_COMP)
	calcRec(TMPG1->G1_COMP, dtUlMes)
	nCount3++
	TMPB1->(dbSkip())
enddo


//Refazer os itens que vieram com custo de importação zerado...
cQSB1 := " SELECT B1_COD from SB1010 where D_E_L_E_T_ = ' ' and B1_ORIGEM = '5' AND B1_X_VLIMP = 0 "
if Select('TMPB1') > 0 
	dbSelectArea('TMPB1')
	TMPB1->(dbCloseArea())
endif
dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQSB1), 'TMPB1', .T., .T.)
nCount3 := 0
dbSelectArea('TMPB1')
TMPB1->(dbGotop())
while !TMPB1->(eof())
	IncProc('Revisando produtos de origem 5 e conteudo de importacao zerado... '+TMPG1->G1_COMP)
	calcRec(TMPG1->G1_COMP, dtUlMes)
	nCount3++
	TMPB1->(dbSkip())
enddo



//Atualizar os produtos que são provenientes de outros produtos via transferencia e/ou desmontagem...
nCtTrf := 0 // fazer a contagem dos itens atualizado por transferencias
//ApMsgInfo('Iniciar atualizacao dos itens de transferencias e desmontagem de códigos...')
If cFilant == '09'
	cQTrans := " Select D3_COD, D3_CF, D3_NUMSEQ, D3_LOCAL, B1_DESC, B1_GRUPO, B1_X_VLIMP, B1_ORIGEM, (D3_CUSTO1 / D3_QUANT ) CUSTOUN "
	cQTrans += " FROM SD3010 SD3, SB1010 SB1 "
	cQTrans += " where SD3.D_E_L_E_T_ = ' ' "
	cQTrans += " and SB1.D_E_L_E_T_ = ' ' "
	cQTrans += " and B1_COD = D3_COD "
	cQTrans += " and D3_FILIAL = '"+xFilial('SD3')+"' "
	cQTrans += " and D3_ESTORNO <> 'S' "
	cQTrans += " and D3_CF in ('RE4','RE7','DE4','DE7') "
//	cQTrans += " and B1_ORIGEM in ('0','5')
	cQTrans += " and Substring(D3_EMISSAO,1,4)= '2013' "
	cQTrans += " order by D3_NUMSEQ, D3_CF desc "
	
	if Select('TMTRANS') > 0
		dbSelectArea('TMTRANS')
		TMTRANS->(dbCloseArea())
	endif
	dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQTrans), 'TMTRANS', .T., .T. )
	
	cCodAnt	:= ""
	ccf 	:= ""
	cNumSeq := ""
	cOrigem := "" 
	nVlimp 	:= 0
	nVluni	:= 0
	dbSelectArea('TMTRANS')
	TMTRANS->(dbGotop())
	while !TMTRANS->(eof())
	incProc('Atualizando itens originado de transferencias...'+cCodAnt)
		if !TMTRANS->B1_ORIGEM $ '3|5'
			TMTRANS->(dbSkip())
			loop
		endif
		if Substr(TMTRANS->D3_CF,1,1) == 'R'
			cCodAnt	:= TMTRANS->D3_COD
			ccf		:= TMTRANS->D3_CF
			cNumSeq	:= TMTRANS->D3_NUMSEQ
			nVlimp	:= TMTRANS->B1_X_VLIMP
			nVluni	:= TMTRANS->CUSTOUN
			cOrigem := TMTRANS->B1_ORIGEM
		endif
		aProd := {}
		TMTRANS->(dbSkip())
			while !TMTRANS->(eof()).and.cNumSeq == TMTRANS->D3_NUMSEQ 
				if Substr(TMTRANS->D3_CF,1,1) == 'D'
					aadd( aProd, {TMTRANS->D3_COD, nVlimp, nVluni, TMTRANS->CUSTOUN, cOrigem} )
				endif
                TMTRANS->(dbSkip())
    		enddo
		For i:= 1 to len(aProd)
			dbSelectArea('SB1')
			dbSeek(xFilial('SB1')+aProd[i][1])
			RecLock('SB1',.F.)
//			Replace B1_ORIGEM with cOrigem
			Replace B1_X_VLIMP with (nVlimp / nVluni) * aProd[1][4]
			MsUnLock('SB1')
			nCtTrf++
		next i
	enddo
endif
for i:= 3 to len(aStru)
	incproc('Comparando origens modificadas com o array...'+aStru[i][1])
	aStru[i][5] := Posicione('SB1',1, xFilial('SB1')+aStru[i][1],"B1_ORIGEM")
	aStru[i][10] := Posicione('SB1',1, xFilial('SB1')+aStru[i][7],"B1_ORIGEM")
next i

ApmsgInfo('Finalizada com sucesso...REG.SB1-> '+cValToChar(nCount)+' REG.SBZ-> '+cValToChar(nCountBZ)+chr(13)+' Refeito '+cValToChar(nCount3)+' registros...Atualizado por trf/desm '+cValToChar(nCtTrf))
	if apmsgYesNo('Deseja gerar a composição do calculo em excel ? ','Atenção')
		Private aDir     	:= {}
		Private nHdl     	:= 0
		Private lOk     	:= .T.
		Private cArqTxt  	:= ""
		Private cCab        := "" 

		aDir := MDirArq()
		If Empty(aDir[1]) .OR. Empty(aDir[2])
			Return
		Else                      
			Processa({ || lOk := MCVS(aStru,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
			If lOk
				MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
			EndIf
	    endif

	
		
	endif
else
	Alert('Rotina abortada')
endif

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
Local nHdl       := 0
Local nt,jk

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




//Rotina que faz calculos de conteudo de importação de produtos de origem 3 ou 5 que estejam na estrutura com valor de conteudo ainda nao calculado
//e precisa do valor para ser calculado em outra estrutura.
static function calcRec(cCodComp, dtUlMes)
local cQG1TMP := "" 
local nVlrImp := 0
cQG1TMP := " Select G1_COD, B1_DESC, B1_ORIGEM, G1_COMP, MATERIAL, QTDMAT, ORIMAT, G1_NIVINV from " 
cQG1TMP += " SB1010 SB1, " 
cQG1TMP += " (select G1_COD, G1_COMP, B1_DESC MATERIAL, G1_QUANT QTDMAT,  B1_ORIGEM ORIMAT, G1_NIVINV from SG1010 SG1, SB1010 SB1 "
cQG1TMP += " where SG1.D_E_L_E_T_ = ' ' and SB1.D_E_L_E_T_ = ' ' "
cQG1TMP += " and G1_COMP = B1_COD  "
cQG1TMP += " and B1_ORIGEM in ('0','1','2','3','5') "
cQG1TMP += " and G1_FILIAL = '"+xFilial('SG1')+"') MATERIAL "
cQG1TMP += " where SB1.D_E_L_E_T_ = ' ' "
cQG1TMP += " and G1_COD = B1_COD "
cQG1TMP += " and B1_ORIGEM not in ('6','7') " 
cQG1TMP += " and Substring(G1_COMP,1,3) <> 'MOD' " 
cQG1TMP += " AND G1_COD = '" +cCodComp+"' "
cQG1TMP += " order by G1_NIVINV, G1_COD asc "

if Select('TMPREC') > 0 
	dbSelectArea('TMPREC')
	dbCloseArea()
endif

dbUseArea(.T. , 'TOPCONN', tcGenQry( , , cQG1TMP), 'TMPREC', .T., .T.)


dbSelectArea('TMPREC')
TMPREC->(dbGotop())
cCodOld := TMPREC->G1_COD
//Alert('Codigo -> '+cCodOld+' Codigo do componente -> '+cCodComp)
nVlrImp := 0
//nCount  := 0
//nCountBZ:= 0
ProcREgua( Reccount() )
//Rotina que faz o calculo da composicao de importação dos produtos que possuem estrutura na SG1
while !TMPREC->(eof())

	incproc('Atualizando comp.recursivo...'+TMPREC->G1_COD)
    
	//Rotina para buscar o local do produto acabado 
	dbSelectArea('SBZ')
	dbSetOrder(1)
	If dbSeek(xFilial('SBZ')+TMPREC->G1_COD)
    	cLocal := SBZ->BZ_LOCPAD
 	else
 		cLocal := Posicione('SB1',1, xFilial('SB1')+TMPREC->G1_COD, "B1_LOCPAD")
 	endif
 	
 	//Rotina para buscar o custo do material acabado
 	nCusto 	:= 0
 	nCusto  := Posicione('SB2',1,xFilial('SB2')+TMPREC->G1_COD+cLocal,"B2_CM1")
 	
 	//Rotina desenvolvida para buscar o custo de alguns produtos que constam zerado na SB2 para o armazem padrao cadastrado
 	//Alguns produtos tem armazem padrao 01 porem a movimentação está ocorrendo em outro armazem
	if nCusto == 0 
		cQSB2 := " SELECT AVG(B2_CM1) CUSMED FROM SB2010 WHERE D_E_L_E_T_ =' ' and B2_FILIAL = '"+xFilial('SB2')+"' "
		cQSB2 += " AND B2_COD = '"+TMPREC->G1_COD+"' AND B2_CM1 > 0 "
		if Select('TMPB2') > 0
			dbSelectArea("TMPB2")
			TMPB2->(dbCloseArea())
		endif
		dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQSB2), 'TMPB2',.T.,.T.)
		
		dbSelectArea('TMPB2')
		TMPB2->(dbGotop())
		nCusto := TMPB2->CUSMED
	endif
	
	//Verifica se o produto que está sendo consumido pertence ao grupo 3 ou 5, caso positivo 
	//Pega o valor de importado que já foi calculado no campo B1_X_VLIMP e multiplica pela quantidade de material 
	//padrao da estrutura
	if posicione('SB1',1, xFilial('SB1')+TMPREC->G1_COMP, "B1_ORIGEM") $ '3|5' 
		//Verifica se já está calculado o conteudo de importação para o ITEM....
		if (posicione('SB1',1, xFilial('SB1')+TMPREC->G1_COMP, "B1_X_VLIMP") * TMPREC->QTDMAT) > 0
			nVlrImp += posicione('SB1',1, xFilial('SB1')+TMPREC->G1_COMP, "B1_X_VLIMP") * TMPREC->QTDMAT
		endif
	else

		//Rotina para desconsiderar os itens com origem 0 ou 2
		if posicione('SB1',1, xFilial('SB1')+TMPREC->G1_COMP, "B1_ORIGEM") $ '0|2'
			TMPREC->(dbSkip())
			loop
		endif


		// Caso nao tenha encontrado custo previamente calculado, faz o processo normal buscando nas origens do material...
		//Pesquisa se o produto está cadastrado no cadastro de indicadores, caso positivo utiliza o armazem indicado na SBZ para calculo do custo
		dbSelectArea('SBZ')
		dbSetOrder(1)
		If dbSeek(xFilial('SBZ')+TMPREC->G1_COMP)
			dbSelectArea('SB2')
			dbSetOrder(1)
			dbSeek(xFilial('SB2')+SBZ->(BZ_COD+BZ_LOCPAD))
				//Verifica se o produto tem Custo médio cadastrado na SB2, caso positivo, utiliza esse custo x a qtde de material e adiciona
				//ao custo da parcela importada
				if SB2->B2_CM1 > 0 
					nVlrImp += SB2->B2_CM1 * TMPREC->QTDMAT 
				//Caso o produto não t		enha custo na SB2, faz a busca pelo ultimo fechamento que consta na SB9 para compor o custo da parcela importada
				//referente ao item.
				else
					cQSB9 := " SELECT B9_CUSTD from SB9010 Where D_E_L_E_T_ = ' ' and B9_FILIAL = '"+xFilial('SB9')+"' "
					cQSB9 += " AND B9_DATA = '"+dTos(dtUlmes)+"' AND B9_COD = '"+TMPREC->G1_COMP+"' AND B9_LOCAL = '"+SBZ->BZ_LOCPAD+"' "
					if Select('TMPB9') > 0 
						dbSelectArea('TMPB9')
						TMPB9->(dbCloseArea())
					endif
					dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQSB9), 'TMPB9', .T., .T.)
					dbSelectArea('TMPB9')
					nVlrImp += TMPB9->B9_CUSTD * TMPREC->QTDMAT 
					
				endif
//			ncountBZ++
		else
		//Caso o produto não esteja cadastrado na SBZ o calculo é feito diretamente pelo SB1 (Cadastro de produtos)
		dbSelectArea('SB1')
		dbSetOrder(1)
		If dbSeek(xFilial('SB1')+TMPREC->G1_COMP)
			dbSelectArea('SB2')
			dbSetOrder(1)
			dbSeek(xFilial('SB2')+SB1->(B1_COD+B1_LOCPAD))
				//Verifica se o produto tem Custo médio cadastrado na SB2, caso positivo, utiliza esse custo x a qtde de material e adiciona
				//ao custo da parcela importada
				if SB2->B2_CM1 > 0
					nVlrImp += SB2->B2_CM1 * TMPREC->QTDMAT
				//Caso o produto não tenha custo na SB2, faz a busca pelo ultimo fechamento que consta na SB9 para compor o custo da parcela importada
				//referente ao item.
				else
					cQSB9 := " SELECT B9_CUSTD from SB9010 Where D_E_L_E_T_ = ' ' and B9_FILIAL = '"+xFilial('SB9')+"' "
					cQSB9 += " AND B9_DATA = '"+dTos(dtUlmes)+"' AND B9_COD = '"+TMPREC->G1_COMP+"' AND B9_LOCAL = '"+SBZ->BZ_LOCPAD+"' "
					if Select('TMPB9') > 0 
						dbSelectArea('TMPB9')
						TMPB9->(dbCloseArea())
					endif
					dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQSB9), 'TMPB9', .T., .T.)
					dbSelectArea('TMPB9')
					nVlrImp += TMPB9->B9_CUSTD * TMPREC->QTDMAT 
				endif
//				ncount++
			endif
		endif
	endif
	//Permite ao usuario cancelar o processamento da rotina, os itens já processados nao serao desfeito.
	If lEnd
		ApMsgInfo('Rotina cancelada pelo usuário...')
		Exit
	EndIf
	cCodOld := TMPREC->G1_COD
	TMPREC->(dbSkip())
enddo

//Bloco para conferir se o nVlrImp é zero, caso positivo faz + uma varredura em busca do valor...
if nVlrImp == 0
	cQuCZero := " Select  VLIMP "
	cQuCZero += " from  SB1010 SB1,  "
	cQuCZero += " 	(select G1_COD, G1_COMP, B1_DESC MATERIAL, G1_QUANT QTDMAT,  B1_ORIGEM ORIMAT, G1_NIVINV, B1_X_VLIMP VLIMP "
	cQuCZero += " 		from SG1010 SG1, SB1010 SB1  "
	cQuCZero += " 		where SG1.D_E_L_E_T_ = ' ' and SB1.D_E_L_E_T_ = ' '  and G1_COMP = B1_COD   "
	cQuCZero += " 		and B1_ORIGEM in ('3','5')  and G1_FILIAL = '"+xFilial("SG1")+"') MATERIAL  "
	cQuCZero += " where SB1.D_E_L_E_T_ = ' '  and G1_COD = B1_COD  and B1_ORIGEM not in ('6','7')  "
	cQuCZero += " and Substring(G1_COMP,1,3) <> 'MOD'  AND G1_COD in ('"+cCodComp+"') "
	
		if Select("TCZ") > 0
			dbSelectArea("TCZ")
			TCZ->(dbCloseArea())
		endif
	
	dbUseArea(.T., 'TOPCONN', tcGenQry(, , cQuCZero), 'TCZ', .T.,.T.)
	
	dbSelectArea('TCZ')
	TCZ->(dbGotop())
	while !TCZ->(eof())
		nVlrImp += TCZ->VLIMP
		TCZ->(dbSkip())
	enddo
endif
	
//Rotina para gravar a composicao do custo do ultimo registro do loop, tendo em vista que ele não estará voltando para fazer a gravação.
dbSelectArea('SB1')
dbSetOrder(1)
if dbSeek(xFilial('SB1')+cCodComp)
	RecLock('SB1',.F.)
//	Alert('Atualizado o codigo '+cCodComp+' Valor importado '+cValToChar(nVlrImp))
	Replace B1_X_VLIMP with nVlrImp
	//Identificar a origem que deve conter no produto...
	if nCusto > 0 .and. nVlrImp > 0
		if (nVlrImp / nCusto) >= .4  	// Se o conteudo de importacao for superior ou igual a 40%
//			Replace B1_ORIGEM with '3'
		else							// Se o conteudo de importacao for inferior a 4%
//			Replace B1_ORIGEM with '5'
		endif
	endif
	MsUnLock('SB1')
endif

Return (nVlrImp)













////////////////////////////////////////////////////////////////////////////////
//Função para identificar o indice de importado de cada produto e gravar nas
//no campo D3_PERIMP - Percentual de conteudo importado de cada item....
///////////////////////////////////////////////////////////////////////////////
user function AG_PROCPIMP()
private lEnd := .F. 
if ApMsgNoYes("Confirma o calculo do conteudo de importação", "Atenção" )
	Processa({|lEnd| AG_PERIMP()},"Aguarde", "Calculando indice de importado.......", .T.)
else
	Alert("Rotina cancelada")
endif
	

return

static function AG_PERIMP()
local cQuery := ""
local dtUlMes := getmv ('MA_MESFCI')
cQuery := " Select SD3.R_E_C_N_O_ NRECNO, D3_NUMSEQ, D3_COD, D3_CF, D3_CUSTO1, B1_X_PERIM, D3_PERIMP  "
cQuery += " from "+RetSqlName("SD3")+" SD3 with (nolock), "+RetSqlName("SB1")+" SB1 with (nolock) "
cQuery += " where SD3.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' '  and D3_FILIAL ='"+xFilial("SD3")+"' and B1_FILIAL = '"+xFilial("SB1")+"' " 
cQuery += " and D3_COD = B1_COD and substring(D3_COD,1,3) <> 'MOD'  and Substring(D3_CF,1,1) in ('P','R') " 
cQuery += " and Substring(D3_EMISSAO,1,6)='"+substr(dTos(dtUlmes),1,6)+"' and D3_OP <>'' "
cQuery += " order by D3_NUMSEQ, D3_CF  " 

if Select("TMPD3") > 0 
	dbSelectArea("TMPD3")
	TMPD3->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPD3", .T., .T.)

ProcREgua( 0 )
dbSelectArea("TMPD3")
TMPD3->(dbGotop())
cOldSeq := TMPD3->D3_NUMSEQ
nRec	:= TMPD3->NRECNO
nVlrImp := 0 
nCustPR0:= TMPD3->D3_CUSTO1
while !TMPD3->(eof())
	//Gravar os valores assim que mudar de ordem de producao
	if TMPD3->D3_NUMSEQ <> cOldSeq 
		dbSelectArea("SD3")
		SD3->(dbGoto(nRec))
		if SD3->D3_PERIMP == 0
			RecLock("SD3",.F.)
			SD3->D3_PERIMP := iif(nCustPR0 > 0, nVlrImp / nCustPR0, 0)
			MsUnLock("SD3")
		endif
		cOldSeq := TMPD3->D3_NUMSEQ
		nRec	:= TMPD3->NRECNO
		nVlrImp := 0 
		nCustPR0:= TMPD3->D3_CUSTO1	
	endif
	//Trocar os valores quando mudar de ordem de produção
	if TMPD3->D3_CF = 'PR0'
		cOldSeq := TMPD3->D3_NUMSEQ
		nRec	:= TMPD3->NRECNO
		nVlrImp := 0 
		nCustPR0:= TMPD3->D3_CUSTO1	
	endif
	if TMPD3->D3_CF = 'PR0'
		nVlrImp += TMPD3->D3_CUSTO1 * TMPD3->B1_X_PERIM
	endif
	TMPD3->(dbSkip())
	incproc('Atualizando comp.importação...'+TMPD3->D3_COD)
enddo
Return 

















////////////////////////////////////////////////////////////////////////////////
//Função para calcular o indice de valor importado baseado na produção
//Seguindo a ordem do fluxo de produção de PNP1
//no campo D3_PERIMP - Percentual de conteudo importado de cada item....
///////////////////////////////////////////////////////////////////////////////
user function AG_IMPBYG()
local aRegs   := {}
local dtUlMes := getmv ('MA_MESFCI')
private lEnd := .F.
if ApMsgNoYes("Confirma o calculo do conteudo de importação por grupo", "Atenção...MES REF: "+substr(dToc(dtUlmes),1,5) )
	if cFilAnt == '09'
		Processa({|lEnd| AG_IMPBY1(aRegs)},"Aguarde", "Calculando indice de importado.......", .T.)
	else
		Processa({|lEnd| AG_IMPBY2(aRegs)},"Aguarde", "Calculando indice de corte/costura/volante.......", .T.)	
	endif
elseif ApMsgNoYes("Confirma o calculo para produtos que não foi encontrado na rotina padrao ?", "Atenção...MES REF: "+substr(dToc(dtUlmes),1,5) )
		Processa({|lEnd| AG_CHKOR5(dtUlMes) }, "Aguarde....", "Calculando produtos sem indices....")


elseif ApMsgNoYes("Confirma calculo de composicao residual ?", "Atenção...ANO REF: "+substr(dTos(dtUlmes),1,4) )
		Processa({|lEnd| AG_IMPBY3(aRegs)},"Aguarde", "Calculando indice de importado.......", .T.)

else 
	Alert("Rotina Abortada....")
	

endif


	
static function AG_IMPBY1(aRegs)
local cQB1 := " "
local cQD3 := ""
local dtUlMes := getmv ('MA_MESFCI')

//if ApMSgNoYes("Deseja realizar apenas para os produtos que ainda estão pendentes ?","Atenção!!!")


//endif

aadd(aREGs, { "NUM_SEQ", "PRODUTO", "COD.FISCAL", "CUSTO", "PERC.IMP", "D3_PERIMP", "GRUPO", "ORIGEM", "VLR.IMP ACUMULADO" }) 
//Query para filtrar os produtos do grupo 11 até 40 seguindo em ordem alfabetica...
//Com essa query será possivel identificar o indice real de conteudo importado em cada ordem de producao...
cQB1 := " Select R_E_C_N_O_ NRECNO, B1_COD, B1_DESC, B1_ORIGEM, B1_TIPO, B1_GRUPO, B1_X_PERIM, B1_X_VLIMP from SB1010 "
cQB1 += " where D_E_L_E_T_ = ' ' and B1_GRUPO in ('11','11C','11D','30','31','31A','32','32A','35','35A','38','38A','38B','38C','38D','38F','39','39A','39B','39C','39D','39E','39E','39F','39G','39H','39I','39T','39TI','40','40A') " 
cQB1 += " AND Substring(B1_COD,1,3) <> 'MOD' " 
///cQB1 += " AND B1_COD ='039274' " 
cQB1 += " order by B1_GRUPO, B1_COD, 1 " 

if Select("TMPB1") > 0
	dbSelectArea("TMPB1")
	TMPB1->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", TcGenQry(, , cQB1), "TMPB1", .T., .T.)
                     
ProcRegua(0)
dbSelectArea("TMPB1")
TMPB1->(dbGotop())
nVlrTPro:= 0  //Variavel para guardar o total produzido o item no periodo
nVlrTImp:= 0  //Variavel para guardar o total de valor importado no periodo
while !TMPB1->(eof())
	cRecProd := TMPB1->NRECNO
	IncProc("Alterando produto "+ALLTRIM(TMPB1->B1_COD)+" GRUPO "+ALLTRIM(TMPB1->B1_GRUPO))
	//Query para filtrar todos os NUMSEQs de Producao no periodo
	//////////////////////////////////////////////////////////////////////
	cQuery := " Select D3_NUMSEQ  "
	cQuery += " from "+RetSqlName("SD3")+" SD3 with (nolock) "
	cQuery += " where SD3.D_E_L_E_T_ =' ' and D3_FILIAL ='"+xFilial("SD3")+"'  "
	cQuery += " AND D3_CF = 'PR0' and D3_COD = '"+TMPB1->B1_COD+"' " 
	cQuery += " and Substring(D3_EMISSAO,1,6)='"+substr(dTos(dtUlmes),1,6)+"' and D3_OP <>'' "
	cQuery += " order by D3_NUMSEQ " 
	if Select("TMPD3") > 0 
		dbSelectArea("TMPD3")
		TMPD3->(dbCloseArea())
	endif
	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPD3", .T., .T.)
	dbSelectArea("TMPD3")
	ProcRegua(0)
	while !TMPD3->(eof())
		IncProc("Calculando NUMSEQ => " +TMPD3->D3_NUMSEQ) 
		//Query para filtrar as producoes conforme NUMSEQ selecionado acima...
		/////////////////////////////////////////////////////////////////////////
		cQuery := " Select SD3.R_E_C_N_O_ NRECNO, D3_NUMSEQ, D3_COD, D3_CF, D3_CUSTO1, B1_X_PERIM, D3_PERIMP, D3_GRUPO, B1_ORIGEM  "
		cQuery += " from "+RetSqlName("SD3")+" SD3 with (nolock), "+RetSqlName("SB1")+" SB1 with (nolock) "
		cQuery += " where SD3.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' '  and D3_FILIAL ='"+xFilial("SD3")+"' and B1_FILIAL = '"+xFilial("SB1")+"' " 
		cQuery += " and D3_COD = B1_COD and substring(D3_COD,1,3) <> 'MOD'  and Substring(D3_CF,1,1) in ('P','R') " 
		cQuery += " and Substring(D3_EMISSAO,1,6)='"+substr(dTos(dtUlmes),1,6)+"' and D3_OP <>'' "
		cQuery += " AND D3_NUMSEQ ='"+TMPD3->D3_NUMSEQ+"' " 
		cQuery += " order by D3_NUMSEQ, D3_CF  " 

		if Select("TMP") > 0 
			dbSelectArea("TMP")
			TMP->(dbCloseArea())
		endif
		dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMP", .T., .T.)		

			//Rotina para calcular a composicao do importado de cada ordem de producao
			ProcREgua( 0 )
			dbSelectArea("TMP")
			TMP->(dbGotop())
			cOldSeq := TMP->D3_NUMSEQ
			nRec	:= TMP->NRECNO
			nVlrImp := 0 
			nCustPR0:= TMP->D3_CUSTO1
			while !TMP->(eof())
				//Trocar os valores quando mudar de ordem de produção
				if TMP->D3_CF = 'PR0'
					cOldSeq := TMP->D3_NUMSEQ
					nRec	:= TMP->NRECNO
					nVlrImp := 0 
					nCustPR0:= TMP->D3_CUSTO1	
					nVlrTPro  += TMP->D3_CUSTO1  //Variavel para guardar o total produzido o item no periodo
				endif
				if TMP->D3_CF <> 'PR0'
					if TMP->B1_ORIGEM $ '1|2|6|7'
						nVlrImp += TMP->D3_CUSTO1
						nVlrTImp += TMP->D3_CUSTO1  //Variavel para guardar o total de valor importado no periodo
					elseif TMP->B1_ORIGEM $ '3|4|5||8'
						nVlrImp += TMP->D3_CUSTO1 * TMP->B1_X_PERIM
						nVlrTImp += TMP->D3_CUSTO1 * TMP->B1_X_PERIM //Variavel para guardar o total de valor importado no periodo
					endif
				endif
				aadd(aREGs, { TMP->D3_NUMSEQ, TMP->D3_COD+"'", TMP->D3_CF, TMP->D3_CUSTO1, TMP->B1_X_PERIM, TMP->D3_PERIMP, TMP->D3_GRUPO+"'", TMP->B1_ORIGEM, nVlrImp }) 
				TMP->(dbSkip())
				incproc('Atualizando comp.importação...'+TMP->D3_COD)
			enddo
			//Fazer a gravação nos arquivos SD3 e SB1
					dbSelectArea("SD3")
					SD3->(dbGoto(nRec))
					if SD3->D3_PERIMP == 0
						RecLock("SD3",.F.)
						SD3->D3_PERIMP := iif(nCustPR0 > 0, nVlrImp / nCustPR0, 0)
						MsUnLock("SD3")
            		endif
					nPos := aScan( aRegs,{ |x| x[1]+x[3] == TMP->(D3_NUMSEQ+D3_CF) } ) 
					if nPos > 0 
						aREGs[nPos][5] := iif(nCustPR0 > 0, nVlrImp / nCustPR0, 0)
						aREGs[nPos][6] := iif(nCustPR0 > 0, nVlrImp / nCustPR0, 0)
					endif
					cOldSeq := TMP->D3_NUMSEQ
					nRec	:= TMP->NRECNO
					nVlrImp := 0 
					nCustPR0:= TMP->D3_CUSTO1	
		TMPD3->(dbSkip())
	enddo
		//Gravar na SB1 o indice de valor importado
		if nVlrTPro > 0 .and. nVlrTImp > 0 
			dbSelectArea("SB1")
			SB1->(dbGoto(cRecProd))
			if nVlrTImp > 0 
				RecLock("SB1", .F.)
				SB1->B1_X_PERIM := iif(nVlrTPro > 0, nVlrTImp / nVlrTPro, 0)
				MsUnLock("SB1")
			endif
        endif
       nVlrTImp := 0
       nVlrTPro := 0 
	
	TMPB1->(dbSkip())
enddo

If ApMsgNoYes("Finalizado o calculo dos grupos produtivos de Semi-Acabado e Acabado"+chr(13)+"Grupos ('11','31','32','35','39A','39B','39D','39F','40') ";
	+chr(13)+chr(13)+"Deseja gerar o calculo para os demais itens ? ","Atenção")

		Processa({|lEnd| AG_IMPBY2(aRegs)},"Aguarde", "Calculando indice de outros itens......", .T.)

else
	if apmsgYesNo('Deseja gerar a composição do calculo em excel ? ','Atenção')
		Private aDir     	:= {}
		Private nHdl     	:= 0
		Private lOk     	:= .T.
		Private cArqTxt  	:= ""
		Private cCab        := "" 

		aDir := MDirArq()
		If Empty(aDir[1]) .OR. Empty(aDir[2])
			Return
		Else                      
			Processa({ || lOk := MCVS(aREGs,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
			If lOk
				MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
			EndIf
	    endif

	
		
	endif
endif


return

//Rotina para calculo de importado dos itens fora do grupo Semi-Acabado e Acabado
static function AG_IMPBY2(aRegs)
local cQB1 := " "
local cQD3 := ""
local dtUlMes := getmv ('MA_MESFCI')


aadd(aREGs, { "NUM_SEQ", "PRODUTO", "COD.FISCAL", "CUSTO", "PERC.IMP", "D3_PERIMP", "GRUPO", "ORIGEM", "VLR.IMP.ACUMULADO" }) 
//Query para filtrar os produtos do grupo 11 até 40 seguindo em ordem alfabetica...
//Com essa query será possivel identificar o indice real de conteudo importado em cada ordem de producao...
If cFilAnt == '09'
	cQB1 := " Select R_E_C_N_O_ NRECNO, B1_COD, B1_DESC, B1_ORIGEM, B1_TIPO, B1_GRUPO, B1_X_PERIM, B1_X_VLIMP from SB1010 "
	cQB1 += " where D_E_L_E_T_ = ' ' and B1_GRUPO not in ('11','11C','11D','30','31','31A','32','32A','35','35A','38','38A','38B','38C','38D','38F','39','39A','39B','39C','39D','39E','39E','39F','39G','39H','39I','39T','39TI','40','40A') " 
	cQB1 += " AND Substring(B1_COD,1,3) <> 'MOD' "
	cQB1 += " order by B1_GRUPO, B1_COD, 1 " 
Else
	cQB1 := " Select R_E_C_N_O_ NRECNO, B1_COD, B1_DESC, B1_ORIGEM, B1_TIPO, B1_GRUPO, B1_X_PERIM, B1_X_VLIMP from SB1010 "
	cQB1 += " where D_E_L_E_T_ = ' ' "//and B1_GRUPO not in ('11','11C','11D','30','31','31A','32','32A','35','35A','38','38A','38B','38C','38D','38F','39','39A','39B','39C','39D','39E','39E','39F','39G','39H','39I','39T','39TI','40','40A') " 
	cQB1 += " AND Substring(B1_COD,1,3) <> 'MOD' "
	cQB1 += " order by B1_GRUPO, B1_COD, 1 " 	
EndIf
if Select("TMPB1") > 0
	dbSelectArea("TMPB1")
	TMPB1->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", TcGenQry(, , cQB1), "TMPB1", .T., .T.)
                     
ProcRegua(0)
dbSelectArea("TMPB1")
TMPB1->(dbGotop())
nVlrTPro:= 0  //Variavel para guardar o total produzido o item no periodo
nVlrTImp:= 0  //Variavel para guardar o total de valor importado no periodo
while !TMPB1->(eof())
	cRecProd := TMPB1->NRECNO
	IncProc("Alterando produto "+ALLTRIM(TMPB1->B1_COD)+" GRUPO "+ALLTRIM(TMPB1->B1_GRUPO))
	//Query para filtrar todos os NUMSEQs de Producao no periodo
	//////////////////////////////////////////////////////////////////////
	cQuery := " Select D3_NUMSEQ  "
	cQuery += " from "+RetSqlName("SD3")+" SD3 with (nolock) "
	cQuery += " where SD3.D_E_L_E_T_ =' ' and D3_FILIAL ='"+xFilial("SD3")+"'  "
	cQuery += " AND D3_CF = 'PR0' and D3_COD = '"+TMPB1->B1_COD+"' " 
	cQuery += " and Substring(D3_EMISSAO,1,6)='"+substr(dTos(dtUlmes),1,6)+"' and D3_OP <>'' "
	cQuery += " order by D3_NUMSEQ " 

	if Select("TMPD3") > 0 
		dbSelectArea("TMPD3")
		TMPD3->(dbCloseArea())
	endif
	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPD3", .T., .T.)
	dbSelectArea("TMPD3")
	ProcRegua(0)
	while !TMPD3->(eof())
		IncProc("Calculando NUMSEQ => " +TMPD3->D3_NUMSEQ) 
		//Query para filtrar as producoes conforme NUMSEQ selecionado acima...
		/////////////////////////////////////////////////////////////////////////
		cQuery := " Select SD3.R_E_C_N_O_ NRECNO, D3_NUMSEQ, D3_COD, D3_CF, D3_CUSTO1, B1_X_PERIM, D3_PERIMP, D3_GRUPO, B1_ORIGEM  "
		cQuery += " from "+RetSqlName("SD3")+" SD3 with (nolock), "+RetSqlName("SB1")+" SB1 with (nolock) "
		cQuery += " where SD3.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' '  and D3_FILIAL ='"+xFilial("SD3")+"' and B1_FILIAL = '"+xFilial("SB1")+"' " 
		cQuery += " and D3_COD = B1_COD and substring(D3_COD,1,3) <> 'MOD'  and Substring(D3_CF,1,1) in ('P','R') " 
		cQuery += " and Substring(D3_EMISSAO,1,6)='"+substr(dTos(dtUlmes),1,6)+"' and D3_OP <>'' "
		cQuery += " AND D3_NUMSEQ ='"+TMPD3->D3_NUMSEQ+"' " 
		cQuery += " order by D3_NUMSEQ, D3_CF  " 

		if Select("TMP") > 0 
			dbSelectArea("TMP")
			TMP->(dbCloseArea())
		endif
		dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMP", .T., .T.)		

			//Rotina para calcular a composicao do importado de cada ordem de producao
			ProcREgua( 0 )
			dbSelectArea("TMP")
			TMP->(dbGotop())
			cOldSeq := TMP->D3_NUMSEQ
			nRec	:= TMP->NRECNO
			nVlrImp := 0 
			nCustPR0:= TMP->D3_CUSTO1
			while !TMP->(eof())
				//Trocar os valores quando mudar de ordem de produção
				if TMP->D3_CF = 'PR0'
					cOldSeq := TMP->D3_NUMSEQ
					nRec	:= TMP->NRECNO
					nVlrImp := 0 
					nCustPR0:= TMP->D3_CUSTO1	
					nVlrTPro  += TMP->D3_CUSTO1  //Variavel para guardar o total produzido o item no periodo
				endif
				if TMP->D3_CF <> 'PR0'
					if TMP->B1_ORIGEM $ '1|2|6|7'
						nVlrImp += TMP->D3_CUSTO1
						nVlrTImp += TMP->D3_CUSTO1  //Variavel para guardar o total de valor importado no periodo											
					elseif TMP->B1_ORIGEM $ '3|4|5||8'
						nVlrImp  += TMP->D3_CUSTO1 * Posicione("SB1",1,xFilial("SB1")+TMP->D3_COD,"B1_X_PERIM") 
						nVlrTImp += TMP->D3_CUSTO1 * Posicione("SB1",1,xFilial("SB1")+TMP->D3_COD,"B1_X_PERIM") 
					endif
				endif
				aadd(aREGs, { TMP->D3_NUMSEQ, TMP->D3_COD+"'", TMP->D3_CF, TMP->D3_CUSTO1, TMP->B1_X_PERIM, TMP->D3_PERIMP, TMP->D3_GRUPO+"'", TMP->B1_ORIGEM, nVlrImp }) 
				TMP->(dbSkip())
				incproc('Atualizando comp.importação...'+TMP->D3_COD)
			enddo
			//Fazer a gravação nos arquivos SD3 e SB1
					dbSelectArea("SD3")
					SD3->(dbGoto(nRec))
					if SD3->D3_PERIMP == 0 
						RecLock("SD3",.F.)
						SD3->D3_PERIMP := iif(nCustPR0 > 0, nVlrImp / nCustPR0, 0)
						MsUnLock("SD3")
					endif
					nPos := aScan( aRegs,{ |x| x[1]+x[3] == TMP->(D3_NUMSEQ+D3_CF) } ) 
					if nPos > 0 
						aREGs[nPos][5] := iif(nCustPR0 > 0, nVlrImp / nCustPR0, 0)
						aREGs[nPos][6] := iif(nCustPR0 > 0, nVlrImp / nCustPR0, 0)
					endif
					cOldSeq := TMP->D3_NUMSEQ
					nRec	:= TMP->NRECNO
					nVlrImp := 0 
					nCustPR0:= TMP->D3_CUSTO1	
		TMPD3->(dbSkip())
	enddo
		//Gravar na SB1 o indice de valor importado
		dbSelectArea("SB1")
		SB1->(dbGoto(cRecProd))
		nPerImp  := SB1->B1_X_PERIM
		RecLock("SB1", .F.)
		SB1->B1_X_PERIM := iif(nVlrTPro > 0, iif(nVlrTImp > 0, nVlrTImp / nVlrTPro, nPerImp), nPerImp)
		MsUnLock("SB1")

       nVlrTImp := 0
       nVlrTPro := 0 
	
	TMPB1->(dbSkip())
enddo

	if apmsgYesNo('Deseja gerar a composição do calculo em excel ? ','Atenção')
		Private aDir     	:= {}
		Private nHdl     	:= 0
		Private lOk     	:= .T.
		Private cArqTxt  	:= ""
		Private cCab        := "t" 

		aDir := MDirArq()
		If Empty(aDir[1]) .OR. Empty(aDir[2])
			Return
		Else                      
			Processa({ || lOk := MCVS(aREGs,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
			If lOk
				MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
			EndIf
	    endif
		
	endif

return


//
//Rotina para verificar se um produto com código 05 ainda não tem conteudo de importado...
/////////////////////////////////////////////////////////////////////////////////////////////////
//Calcula indice de importado baseado na NUMSEQ
static function AG_CHKOR5(dtUlMes)
local cQB1    := ""
local cQD3    := "" 
local nIndImp := 0
cQD3 := " Select distinct SB1.R_E_C_N_O_ cRecPro, D3_FILIAL, D3_NUMSEQ from SB1010 SB1 with (nolock), SD3010 SD3 with (nolock) "
cQD3 += " where SB1.D_E_L_E_T_ =' ' and SD3.D_E_L_E_T_ =' '  "
cQD3 += " and D3_COD = B1_COD "
cQD3 += " and B1_GRUPO not in ('16','12','19') "
cQD3 += " and B1_ORIGEM = '5' and D3_FILIAL in ('04','08','09','19' ) "
//cQD3 += " AND D3_COD in ('037069','037070') "
cQD3 += " and Substring(D3_EMISSAO,1,6)='"+substr(dTos(dtUlmes),1,6)+"' "
cQD3 += " and B1_X_PERIM = 0  " 

if Select("TMPD3") > 0 
	dbSelectArea("TMPD3")
	TMPD3->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", tcGenQry(, , cQD3), "TMPD3", .T.,.T.)


nCount:=0
TMPD3->(dbGotop())
while !TMPD3->(eof())
	nCount++
	TMPD3->(dbSkip())
enddo
Alert("TOTAL DE REGISTRO -> "+cValToChar(nCount))

nCTPos:= 0
dbSelectArea("TMPD3")
ProcRegua(0)
TMPD3->(dbGotop())
while !TMPD3->(eof())
	nIndImp := BuscaIDX(TMPD3->D3_NUMSEQ) 
	if nIndImp > 0 
		dbSelectArea("SB1")
		SB1->(dbGoto(TMPD3->cRecPro))
		RecLock("SB1", .F.)
		SB1->B1_X_PERIM := nIndImp
		MsUnlock("SB1")
	endif
	nCTPOs++
	incProc("Calculando chave "+TMPD3->D3_NUMSEQ+" Posicao "+cValToChar(nCTPos)+" de "+cValToChar(nCount) )
	TMPD3->(dbSkip())
enddo



return nIndImp

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para buscar uma produção baseada no NUMSEQ dos produtos que nao foram encontrados indices
//Desenvolvida por Anesio G.Faria - 09/12/2014
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static function BuscaIDX(cNumSeq)
local cQD3A := " " 
local nCusPImp := 0 
local nCusTPro := 0
Local i

cQD3A := " Select B1_COD, B1_ORIGEM, B1_X_PERIM, D3_CUSTO1, D3_CF, D3_NUMSEQ from SB1010 SB1 with (nolock), SD3010 SD3 with (nolock) "
cQD3A += " where SB1.D_E_L_E_T_ =' ' and SD3.D_E_L_E_T_ =' ' "
cQD3A += " and D3_COD = B1_COD "
cQD3A += " and D3_FILIAL <>'01' "
cQD3A += " and D3_NUMSEQ = '"+cNumSeq+"' " 
cQD3A += " and B1_GRUPO not in ('16','12','19') "
cQD3A += " and B1_ORIGEM = '5' "
cQD3A += " and Substring(D3_EMISSAO,1,4)='2014' "
cQD3A += " and B1_X_PERIM =0 AND D3_OP <> '' AND D3_CF in ('RE1','PR0') " 
cQD3A += " Order BY D3_NUMSEQ, D3_CF " 

if Select("TMPD3A") > 0 
	dbSelectArea("TMPD3A")
	TMPD3A->(dbCloseArea())
endif

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQD3A), "TMPD3A", .T., .T.)

dbSelectArea("TMPD3A")
RecCount(0)
aCodProd := {}
TMPD3A->(dbGotop())
while !TMPD3A->(eof())
	if TMPD3A->D3_CF == 'PR0' 
		nCusTPro := TMPD3A->D3_CUSTO1
	else
		if TMPD3A->B1_ORIGEM == '5'
			nCusPImp += TMPD3A->B1_X_PERIM * TMPD3A->D3_CUSTO1
			AADD( aCodProd, {ALLTRIM(TMPD3A->B1_COD) }) 
		endif
	endif
	TMPD3A->(dbSkip())
	incProc("Ajustando..."+ALLTRIM(TMPD3A->B1_COD)) 
enddo

if nCusTPro > 0 
	nCusPImp := nCusPImp / nCusTPro
else
	nCusPImp := 0 
endif

//Caso o custo seja zero faz busca pelos produtos utilizados no item superior
if nCusPImp == 0
	nVlrImp := 0 //Variavel para acumular o valor de importado 
	nCusto  := 0 //Variavel para acumular o custo do produto PR0
	for i:= 1 to len (aCodProd)
	cQ1 := " Select MAX(D3_NUMSEQ) NUMSEQ from SD3010 SD3 with (nolock), SB1010 SB1 with (nolock) "
	cQ1 += " where SD3.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' and D3_FILIAL ='09' "
	cQ1 += " and D3_COD = B1_COD and Substring(D3_CF,1,1) in ('P') and Substring(D3_EMISSAO,1,4)='2014' and D3_OP <>''  "
	cQ1 += " and D3_COD ='"+aCodProd[i][1]+"' " 
	
	if Select("TMPQ1") > 0 
		dbSelectArea("TMPQ1")
		TMPQ1->(dbCloseArea())
	endif
	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQ1), "TMPQ1", .T., .T.)
	
	dbSelectArea("TMPQ1")
	TMPQ1->(dbGotop())
	cProdD3 := "" 
	cNSeqD3 := ""
	nCusInd := 0 //Custo individual da Producao
	nImpInd := 0 //valor de Importado da producao
	dbSelectArea("SD3")
	dbSetOrder(4) //D3_NUMSEQ
	if dbSeek(xFilial("SD3")+TMPQ1->NUMSEQ)
		while !SD3->(eof()).and.SD3->D3_NUMSEQ == TMPQ1->NUMSEQ
			if SD3->D3_CF == 'PR0' 
				nCusto  += SD3->D3_CUSTO1
				nCusInd := SD3->D3_CUSTO1
				cProdD3 := SD3->D3_COD
			endif
			if SD3->D3_CF == 'RE1' .and. Posicione("SB1",1,xFilial("SB1")+SD3->D3_COD,"B1_ORIGEM") == '5' 
				nVlrImp += SD3->D3_CUSTO1 * Posicione("SB1",1,xFilial("SB1")+SD3->D3_COD,"B1_X_PERIM") 
				nImpInd += SD3->D3_CUSTO1 * Posicione("SB1",1,xFilial("SB1")+SD3->D3_COD,"B1_X_PERIM") 
			endif

			SD3->(dbSkip())
		enddo
		if nCusInd > 0
			dbSelectArea("SB1")
			dbSetOrder(1)
			if dbSeek(xFilial("SB1")+cProdD3)
				if SB1->B1_X_PERIM == 0 
					RecLock("SB1",.F.)
					SB1->B1_X_PERIM := nImpInd / nCusInd
					MsUnLock("SB1")
				endif
			endif
		endif
	endif
	next i
	nCusPImp := iif(nCusto > 0, nVlrImp / nCusto, 0 )
endif

return nCusPImp
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

return





//Rotina para calculo de importado dos itens fora do grupo Semi-Acabado e Acabado
static function AG_IMPBY3(aRegs)
local cQB1 := " "
local cQD3 := ""
local dtUlMes := getmv ('MA_MESFCI')

Alert("Rotina a ser executada: AG_IMPBY3") 

aadd(aREGs, { "NUM_SEQ", "PRODUTO", "COD.FISCAL", "CUSTO", "PERC.IMP", "D3_PERIMP", "GRUPO", "ORIGEM", "VLR.IMP.ACUMULADO" }) 
//Query para filtrar os produtos do grupo 11 até 40 seguindo em ordem alfabetica...
//Com essa query será possivel identificar o indice real de conteudo importado em cada ordem de producao...
cQB1 := " Select distinct SB1.R_E_C_N_O_ NRECNO, B1_COD, B1_DESC, B1_ORIGEM, B1_TIPO, B1_GRUPO, B1_X_PERIM, B1_X_VLIMP from SB1010 SB1 with (nolock), SD3010 SD3 with (nolock)  "
cQB1 += " where SB1.D_E_L_E_T_ =' ' and SD3.D_E_L_E_T_ =' '  " 
//cQB1 += " and D3_FILIAL ='"+xFilial("SD3")+"' "
cQB1 += " AND D3_COD = B1_COD and B1_GRUPO not in ('16','12','19') and B1_ORIGEM = '5' "
cQB1 += " AND Substring(B1_COD,1,3) <> 'MOD' " //AND B1_COD = '037069' "
cQB1 += " AND B1_X_PERIM = 0 and Substring(D3_EMISSAO,1,4)='"+substr(dTos(dtUlmes),1,4)+"' " 
cQB1 += " order by B1_GRUPO, B1_COD, 1  " 



if Select("TMPB1") > 0
	dbSelectArea("TMPB1")
	TMPB1->(dbCloseArea())
endif
dbUseArea(.T., "TOPCONN", TcGenQry(, , cQB1), "TMPB1", .T., .T.)
                     
ProcRegua(0)
dbSelectArea("TMPB1")
TMPB1->(dbGotop())
nVlrTPro:= 0  //Variavel para guardar o total produzido o item no periodo
nVlrTImp:= 0  //Variavel para guardar o total de valor importado no periodo
while !TMPB1->(eof())
	cRecProd := TMPB1->NRECNO
	IncProc("Alterando produto "+ALLTRIM(TMPB1->B1_COD)+" GRUPO "+ALLTRIM(TMPB1->B1_GRUPO))
	//Query para filtrar todos os NUMSEQs de Producao no periodo
	//////////////////////////////////////////////////////////////////////
	cQuery := " Select D3_FILIAL, D3_NUMSEQ  "
	cQuery += " from "+RetSqlName("SD3")+" SD3 with (nolock) "
	cQuery += " where SD3.D_E_L_E_T_ =' ' " //and D3_FILIAL ='"+xFilial("SD3")+"'  "
	cQuery += " AND D3_CF = 'PR0' and D3_COD = '"+TMPB1->B1_COD+"' " 
	cQuery += " and Substring(D3_EMISSAO,1,4)='"+substr(dTos(dtUlmes),1,4)+"' and D3_OP <>'' "
	cQuery += " order by D3_NUMSEQ " 

	if Select("TMPD3") > 0 
		dbSelectArea("TMPD3")
		TMPD3->(dbCloseArea())
	endif                                io fa
	dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMPD3", .T., .T.)
	dbSelectArea("TMPD3")
	ProcRegua(0)
	while !TMPD3->(eof())
		IncProc("Calculando NUMSEQ => " +TMPD3->D3_NUMSEQ) 
		//Query para filtrar as producoes conforme NUMSEQ selecionado acima...
		/////////////////////////////////////////////////////////////////////////
		cQuery := " Select SD3.R_E_C_N_O_ NRECNO, D3_NUMSEQ, D3_COD, D3_CF, D3_CUSTO1, B1_X_PERIM, D3_PERIMP, D3_GRUPO, B1_ORIGEM  "
		cQuery += " from "+RetSqlName("SD3")+" SD3 with (nolock), "+RetSqlName("SB1")+" SB1 with (nolock) "
		cQuery += " where SD3.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' '  and D3_FILIAL ='"+TMPD3->D3_FILIAL+"' and B1_FILIAL = '"+xFilial("SB1")+"' " 
		cQuery += " and D3_COD = B1_COD and substring(D3_COD,1,3) <> 'MOD'  and Substring(D3_CF,1,1) in ('P','R') " 
		cQuery += " and Substring(D3_EMISSAO,1,4)='"+substr(dTos(dtUlmes),1,4)+"' and D3_OP <>'' "
		cQuery += " AND D3_NUMSEQ ='"+TMPD3->D3_NUMSEQ+"' " 
		cQuery += " order by D3_NUMSEQ, D3_CF  " 

		if Select("TMP") > 0 
			dbSelectArea("TMP")
			TMP->(dbCloseArea())
		endif
		dbUseArea(.T., "TOPCONN", tcGenQry(, , cQuery), "TMP", .T., .T.)		

			//Rotina para calcular a composicao do importado de cada ordem de producao
			ProcREgua( 0 )
			dbSelectArea("TMP")
			TMP->(dbGotop())
			cOldSeq := TMP->D3_NUMSEQ
			nRec	:= TMP->NRECNO
			nVlrImp := 0 
			nCustPR0:= TMP->D3_CUSTO1
			while !TMP->(eof())
				//Trocar os valores quando mudar de ordem de produção
				if TMP->D3_CF = 'PR0'
					cOldSeq := TMP->D3_NUMSEQ
					nRec	:= TMP->NRECNO
					nVlrImp := 0 
					nCustPR0:= TMP->D3_CUSTO1	
					nVlrTPro  += TMP->D3_CUSTO1  //Variavel para guardar o total produzido o item no periodo
				endif
				if TMP->D3_CF <> 'PR0'
					if TMP->B1_ORIGEM $ '1|2|6|7'
						nVlrImp += TMP->D3_CUSTO1
						nVlrTImp += TMP->D3_CUSTO1  //Variavel para guardar o total de valor importado no periodo											
					elseif TMP->B1_ORIGEM $ '3|4|5||8'
						nVlrImp  += TMP->D3_CUSTO1 * Posicione("SB1",1,xFilial("SB1")+TMP->D3_COD,"B1_X_PERIM") 
						nVlrTImp += TMP->D3_CUSTO1 * Posicione("SB1",1,xFilial("SB1")+TMP->D3_COD,"B1_X_PERIM") 
					endif
				endif
				aadd(aREGs, { TMP->D3_NUMSEQ, TMP->D3_COD+"'", TMP->D3_CF, TMP->D3_CUSTO1, TMP->B1_X_PERIM, TMP->D3_PERIMP, TMP->D3_GRUPO+"'", TMP->B1_ORIGEM, nVlrImp }) 
				TMP->(dbSkip())
				incproc('Atualizando comp.importação...'+TMP->D3_COD)
			enddo
			//Fazer a gravação nos arquivos SD3 e SB1
					dbSelectArea("SD3")
					SD3->(dbGoto(nRec))
					if SD3->D3_PERIMP == 0 
						RecLock("SD3",.F.)
						SD3->D3_PERIMP := iif(nCustPR0 > 0, nVlrImp / nCustPR0, 0)
						MsUnLock("SD3")
					endif
					nPos := aScan( aRegs,{ |x| x[1]+x[3] == TMP->(D3_NUMSEQ+D3_CF) } ) 
					if nPos > 0 
						aREGs[nPos][5] := iif(nCustPR0 > 0, nVlrImp / nCustPR0, 0)
						aREGs[nPos][6] := iif(nCustPR0 > 0, nVlrImp / nCustPR0, 0)
					endif
					cOldSeq := TMP->D3_NUMSEQ
					nRec	:= TMP->NRECNO
					nVlrImp := 0 
					nCustPR0:= TMP->D3_CUSTO1	
		TMPD3->(dbSkip())
	enddo
		//Gravar na SB1 o indice de valor importado
		dbSelectArea("SB1")
		SB1->(dbGoto(cRecProd))
		nPerImp  := SB1->B1_X_PERIM
		RecLock("SB1", .F.)
		SB1->B1_X_PERIM := iif(nVlrTPro > 0, iif(nVlrTImp > 0, nVlrTImp / nVlrTPro, nPerImp), nPerImp)
		MsUnLock("SB1")

       nVlrTImp := 0
       nVlrTPro := 0 
	
	TMPB1->(dbSkip())
enddo

	if apmsgYesNo('Deseja gerar a composição do calculo em excel ? ','Atenção')
		Private aDir     	:= {}
		Private nHdl     	:= 0
		Private lOk     	:= .T.
		Private cArqTxt  	:= ""
		Private cCab        := "t" 

		aDir := MDirArq()
		If Empty(aDir[1]) .OR. Empty(aDir[2])
			Return
		Else                      
			Processa({ || lOk := MCVS(aREGs,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
			If lOk
				MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
			EndIf
	    endif
		
	endif

return


