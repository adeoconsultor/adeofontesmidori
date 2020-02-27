#INCLUDE "Rwmake.ch"
#include "Average.ch"

#DEFINE  NFE_UNICA     3
#define  NF_TRANS      6

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: EICDI154_RDM
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Data......: 11 de Janeiro de 2010 - 08:00
//|Uso.......: SIGAEIC
//|Versao....: Protheus - 10
//|Descricao.: Pontos de Entrada na geração da NF de Importação
//|Observação:
//+-----------------------------------------------------------------------------------//
*----------------------------------------------*
User Function EICDI154_RDM()
*----------------------------------------------*

Local nQt   := 0
Local cDesc := ""

_nTotFob := SW6->W6_FOB_TOT

If Type("ParamIXB") # "C"
	Return .F.
EndIf

//+------------------------------------------------------------------------------------//
//|VerIfica pelo parametro padrao do DESEMBARAÇO F12 se fara a contabilização
//|Precionando F12 na tela do Desembaraço poderam selecionar os parametros
//+------------------------------------------------------------------------------------//
MV_PAR03 := Posicione("SX1",1,"EICFI4    "+"02","X1_PRESEL")  // Mostra   Lançamento Contabil?
MV_PAR04 := Posicione("SX1",1,"EICFI4    "+"03","X1_PRESEL")  // Aglutina Lançamento Contabil?

Do Case
	
	//+-----------------------------------------------------------------------------------//
	//|Parametro..: "FINAL_GRAVA_NF"
	//|Descricao..: Verifica as contabilizações para Gravação da Nota
	//+-----------------------------------------------------------------------------------//
	Case ParamIxb == "FINAL_GRAVA_NF"
		
		If nTipoNF == 1 .OR. nTipoNF == 3
			
			//+------------------------------------------------------------------------------------//
			//|Contabilização de Pré-Nota
			//+------------------------------------------------------------------------------------//
			//|Estorno Contabilização Em Transito
			//|Só será efetuado o lançamento do estorno, caso a data gravada no arquivo não esteja
			//|em branco, sabemos assim que já foi contabilizada necessitando estorná-la.
			//+------------------------------------------------------------------------------------//
			dDtaEmb := SW6->W6_DT_EMB
			If !Empty(dDtaEmb)
				U_UZValInform("905")
			Endif
			
			
		EndIf
		
		
		//+-----------------------------------------------------------------------------------//
		//|Parametro..: "ANTES_ESTORNO_NOTA"
		//|Descricao..: Verifica as contabilizações no estorno e se há NF Transferencia
		//+-----------------------------------------------------------------------------------//
	Case ParamIxb == "ANTES_ESTORNO_NOTA"
		
		If nTipoNF == 1 .OR. nTipoNF == 3
			
			//+------------------------------------------------------------------------------------//
			//|Inclusão Retorno da Contabilização Dta Em Transito
			//+------------------------------------------------------------------------------------//
			dDtaEmb := SW6->W6_DT_EMB
			If !Empty(dDtaEmb)
				SW6->W6_DT_EMB := dDtaEmb // O Lancamento 904 busca a data do Embarque com M-> entao foi preciso FAZER a recpcao desta variavel
				U_UZValInform("900")
			Endif
			
		EndIf
		
		//+-----------------------------------------------------------------------------------//
		//|Parametro..: "ESTORNO"  // Luiz Fernando - 06/08/2010
		//|Descricao..: Verifica se Nota classificada com permissão apenas do Setor Fiscal
		//+-----------------------------------------------------------------------------------//
	Case ParamIxb == "ESTORNO"
        
        lRetNF1 := .T.
//Codigo comentado por ANESIO, a partir da versão 11 o EIC só permite a exclusão de notas fiscais classificadas.        		
/*		_AliasSWN := GetArea()
		SF1->(DbSetOrder(5))
		IF SF1->(DBSEEK(xFilial("SF1")+SW6->W6_HAWB+"1"+cNota))
			If SF1->F1_STATUS != " "
				MsgInfo("NF Está Classificada, Exclusão liberada apenas para Dpto Fiscal !","Atenção")
				lRetNF1 := .F.
			Endif
		Endif
		
		SF1->(DbSetOrder(5))
		IF SF1->(DBSEEK(xFilial("SF1")+SW6->W6_HAWB+"2"+cNota))
			If SF1->F1_STATUS != " " 
				MsgInfo("NF Está Classificada, Exclusão liberada apenas para Dpto Fiscal !","Atenção")
				lRetNF1 := .F.
			Endif
		Endif
		
		RestArea(_AliasSWN)
  */		
		Return(lRetNF1)
		
	Case ParamIxb == "GRAVACAO_SF1"
		EIH->(dbSetOrder(1))
		If !lTipoCompl
			aAdd(aCab,{"F1_TRANSP",SW6->W6_TRANS  ,Nil})
			aAdd(aCab,{"F1_PLIQUI",SW6->W6_PESOL  ,Nil})
			aAdd(aCab,{"F1_PBRUTO",SW6->W6_PESO_BR,Nil})
			
			If EIH->(dbSeek(xFilial("EIH")+SW6->W6_HAWB))
				While EIH->(!EOF()) .AND. (xFilial("EIH")+EIH->EIH_HAWB) == (SW6->W6_FILIAL+SW6->W6_HAWB)
					cDesc := ""
					nQt++
					If nQt > 4
						Exit
					Else
						cDesc := Alltrim(Posicione("SJF",1,xFilial("SJF")+EIH->EIH_CODIGO,"JF_DESC"))
						aAdd(aCab,{"F1_ESPECI"+Alltrim(Str(nQt)),cDesc          ,Nil})
						aAdd(aCab,{"F1_VOLUME"+Alltrim(Str(nQt)),EIH->EIH_QTDADE,Nil})
					EndIf
					EIH->(dbSkip())
				EndDo
			EndIf
		EndIf
		
EndCase

Return

//+------------------------------------------------------------------------------------//
//|Fim do programa EICDI154_RDM.PRW
//+------------------------------------------------------------------------------------//