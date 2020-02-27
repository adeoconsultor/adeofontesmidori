#INCLUDE 'Protheus.ch'
#INCLUDE 'Rwmake.ch'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

///////////////////////////////////////////////////////////////////////////
//Ponto de entrada chamado após a confirmacao de transferencia modelo 01
//Solicita ao usuario a informação referente ao numero de Partida e 
//	metragem quadrada do produto
//Para ativar o ponto de entrada a filial precisa estar cadastrada 
//	no Parametro MA_MA260D3                                  
//A Informação fica gravada tanto no produto de origem quanto no produto 
//	de destino
///////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br - 29-11-2011
///////////////////////////////////////////////////////////////////////////

user function MA260D3()        
local cNumSeq 	   := SD3->D3_NUMSEQ
local nCount       := 0 // Utilizado para identificar o item 1 e 2 na hora de gravar o custo Anterior
local cNumPart   := Space(11)
local nQtdM2     := 0
local cMA260     := Getmv('MA_MA260D3') 

if cFilant $ cMA260

	SetPrvt("oFont1","oFont2","oFont3","oDlg1","oNumPart","oSay2","oGet1","oGet2","oBtn1")

	oFont1     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
	oFont2     := TFont():New( "MS Sans Serif",0,-20,,.F.,0,,400,.F.,.F.,,,,,, )
	oFont3     := TFont():New( "MS Serif",0,-20,,.T.,0,,700,.F.,.F.,,,,,, )
	oDlg1      := MSDialog():New( 145,427,405,697,"Informações Adicionais....",,,.F.,,,,,,.T.,,,.T. )
	oNumPart   := TSay():New( 016,016,{||"NUMERO DE PARTIDA"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)
	oSay2      := TSay():New( 049,017,{||"QTDE METRAGEM"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)
	oGet1      := TGet():New( 028,016,{|u| If(Pcount()>0,cNumPart:=u,cNumPart)},oDlg1,096,014,'@!',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,,"cNumPart",,)
	oGet2      := TGet():New( 061,016,{|u| If(Pcount()>0,nQtdM2:=u,nQtdM2)} ,oDlg1,096,014,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oBtn1      := TButton():New( 088,016,"&Confirmar",oDlg1,{|| U_ATUD3() },096,020,,oFont3,,.T.,,"",,,,.F. )

	oDlg1:Activate(,,,.T.)
endif


///////////////////////////////////////////////////////////////////////////////
//Rotina desenvolvida para gravar o custo apos a execucao da transferencia no MODELO1
//Faz parte do projeto apresentado pelo Sr.Helio Matsuda em Dez-2011
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br, angfaria@hotmail.com - 10-01-2012
///////////////////////////////////////////////////////////////////////////////
/*dbSelectArea("SD3")
dbSetOrder(4) //D3_FILIAL+D3_NUMSEQ+D3_CHAVE+D3_COD
dbSeek(xFilial('SD3')+cNumSeq)
while !SD3->(eof()) .and. xFilial('SD3')==SD3->D3_FILIAL .and. cNumSeq == SD3->D3_NUMSEQ
	nCount++
	RecLock("SD3",.F.)
	SD3->D3_CUSAPOS := U_AGF_SEARCHCUS(SD3->D3_LOCAL, SD3->D3_COD)	
	if nCount == 1
		SD3->D3_CUSANT := _nCusAnt1
	else
		SD3->D3_CUSANT := _nCusAnt2
	endif
	MsUnLock("SD3")
	SD3->(dbSkip())
enddo

return
*/
 
Return
   
user function ATUD3()
local cNumSeq := SD3->D3_NUMSEQ

dbSelectArea('SD3')
dbSetOrder(4) //D3_FILIAL+D3_NUMSEQ+D3_CHAVE+D3_COD
dbSeek(xFilial('SD3')+cNumSeq)
while !SD3->(eof()) .and. xFilial('SD3')==SD3->D3_FILIAL .and. cNumSeq == SD3->D3_NUMSEQ
	RecLock('SD3',.F.)
	SD3->D3_PARTIDA := cNumPart
	SD3->D3_QTDEM2  := nQtdM2
	SD3->D3_MEDIAM2 := nQtdM2 / SD3->D3_QUANT
	MsUnLock('SD3')
	
	SD3->(dbSkip())
enddo
oDlg1:end()

return


///////////////////////////////////////////////////////////////////////////////
//Rotina desenvolvida para gravar o custo antes da execucao da transferencia no MODELO1
//Faz parte do projeto apresentado pelo Sr.Helio Matsuda em Dez-2011
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br, angfaria@hotmail.com - 10-01-2012
///////////////////////////////////////////////////////////////////////////////
user function A260LOC()
//Funcao comentada em busca de um problema de apontamento que esta ocorrendo sem consumo de Material - 11-04-2012
//public _nCusAnt1 := 0 
//public _nCusAnt2 := 0
//	_nCusAnt1 := U_AGF_SEARCHCUS(CLOCORIG, CCODORIG)
//	_nCusAnt2 := U_AGF_SEARCHCUS(CLOCDEST, CCODDEST)
return


///////////////////////////////////////////////////////////////////////////////
//Rotina desenvolvida para gravar o custo após a execucao da transferencia no MODELO2
//Grava o custo do item de origem
//Faz parte do projeto apresentado pelo Sr.Helio Matsuda em Dez-2011
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br, angfaria@hotmail.com - 11-01-2012
///////////////////////////////////////////////////////////////////////////////
/*user function M261D3O()
Local nPosObs      := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_CUSANT"})
Public _nCusAnt2   := U_AGF_SEARCHCUS(aCols[n, 9], aCols[n, 6])
SD3->D3_CUSANT     := aCols[n,nPosObs]

SD3->D3_CUSAPOS := U_AGF_SEARCHCUS(SD3->D3_LOCAL, SD3->D3_COD)		
return
*/          

///////////////////////////////////////////////////////////////////////////////
//Rotina desenvolvida para gravar o custo após a execucao da transferencia no MODELO2
//Grava o custo do item de destino
//Faz parte do projeto apresentado pelo Sr.Helio Matsuda em Dez-2011
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br, angfaria@hotmail.com - 11-01-2012
///////////////////////////////////////////////////////////////////////////////
/*user function MA261D3()
	SD3->D3_CUSANT  := _nCusAnt2
	SD3->D3_CUSAPOS := U_AGF_SEARCHCUS(SD3->D3_LOCAL, SD3->D3_COD)	
return
*/
///////////////////////////////////////////////////////////////////////////////
//Rotina desenvolvida para adicionar o campo D3_CUSANT na tela de digitacao de transferencia MODELO2
//Grava o custo do item de destino
//Faz parte do projeto apresentado pelo Sr.Helio Matsuda em Dez-2011
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br, angfaria@hotmail.com - 11-01-2012
///////////////////////////////////////////////////////////////////////////////
user function MA261CPO( )
Local aTam := {}
aTam := TamSX3('D3_CUSANT')
Aadd(aHeader, {'Custo Antes' , 'D3_CUSANT' , PesqPict('SD3', 'D3_CUSANT' , aTam[1]) , aTam[1], aTam[2], '', USADO, 'N', 'SD3', ''})
Return Nil


///////////////////////////////////////////////////////////////////////////////
//Rotina desenvolvida para gravar o custo após a execucao da desmontagem de produtos rotina padrao.
//Grava os custos no produto de origem
//Faz parte do projeto apresentado pelo Sr.Helio Matsuda em Dez-2011
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br, angfaria@hotmail.com - 11-01-2012
///////////////////////////////////////////////////////////////////////////////
user function M242D3IN()
//Funcao comentada em busca de um problema de apontamento que esta ocorrendo sem consumo de Material - 11-04-2012
//	SD3->D3_CUSANT  := U_AGF_SEARCHCUS(cLocOrig, cProduto)
//	SD3->D3_CUSAPOS := U_AGF_SEARCHCUS(cLocOrig, cProduto)
return

///////////////////////////////////////////////////////////////////////////////
//Rotina desenvolvida para gravar o custo após a execucao da desmontagem de produtos.
//Grava o custo dos itens de destino
//Faz parte do projeto apresentado pelo Sr.Helio Matsuda em Dez-2011
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br, angfaria@hotmail.com - 11-01-2012
///////////////////////////////////////////////////////////////////////////////
user function MTA242I()

//Funcao comentada em busca de um problema de apontamento que esta ocorrendo sem consumo de Material - 11-04-2012
//dbSelectArea('SD3')
//	RecLock('SD3', .F.)
//	SD3->D3_CUSAPOS := U_AGF_SEARCHCUS(SD3->D3_LOCAL, SD3->D3_COD)	
//	MsUnLock('SD3')
	
return

///////////////////////////////////////////////////////////////////////////////
//Rotina desenvolvida para gravar o custo após a execucao do acerto de inventario
//Faz parte do projeto apresentado pelo Sr.Helio Matsuda em Dez-2011
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br, angfaria@hotmail.com - 12-01-2012
///////////////////////////////////////////////////////////////////////////////
user function MT340D3()      
//Funcao comentada em busca de um problema de apontamento que esta ocorrendo sem consumo de Material - 11-04-2012
//dbSelectArea('SD3')
//	RecLock('SD3', .F.)
//	SD3->D3_CUSAPOS := U_AGF_SEARCHCUS(SD3->D3_LOCAL, SD3->D3_COD)	
//	MsUnLock('SD3')
return                                        