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
//|Descricao.: Pontos de Entrada na gera��o da NF de Importa��o
//|Observa��o:
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
//|VerIfica pelo parametro padrao do DESEMBARA�O F12 se fara a contabiliza��o
//|Precionando F12 na tela do Desembara�o poderam selecionar os parametros
//+------------------------------------------------------------------------------------//
MV_PAR03 := Posicione("SX1",1,"EICFI4    "+"02","X1_PRESEL")  // Mostra   Lan�amento Contabil?
MV_PAR04 := Posicione("SX1",1,"EICFI4    "+"03","X1_PRESEL")  // Aglutina Lan�amento Contabil?

Do Case
	
	//+-----------------------------------------------------------------------------------//
	//|Parametro..: "FINAL_GRAVA_NF"
	//|Descricao..: Verifica as contabiliza��es para Grava��o da Nota
	//+-----------------------------------------------------------------------------------//
	Case ParamIxb == "FINAL_GRAVA_NF"
		
		If nTipoNF == 1 .OR. nTipoNF == 3
			
			//+------------------------------------------------------------------------------------//
			//|Contabiliza��o de Pr�-Nota
			//+------------------------------------------------------------------------------------//
			//|Estorno Contabiliza��o Em Transito
			//|S� ser� efetuado o lan�amento do estorno, caso a data gravada no arquivo n�o esteja
			//|em branco, sabemos assim que j� foi contabilizada necessitando estorn�-la.
			//+------------------------------------------------------------------------------------//
			dDtaEmb := SW6->W6_DT_EMB
			If !Empty(dDtaEmb)
				U_UZValInform("905")
			Endif
			
			
		EndIf
		
		
		//+-----------------------------------------------------------------------------------//
		//|Parametro..: "ANTES_ESTORNO_NOTA"
		//|Descricao..: Verifica as contabiliza��es no estorno e se h� NF Transferencia
		//+-----------------------------------------------------------------------------------//
	Case ParamIxb == "ANTES_ESTORNO_NOTA"
		
		If nTipoNF == 1 .OR. nTipoNF == 3
			
			//+------------------------------------------------------------------------------------//
			//|Inclus�o Retorno da Contabiliza��o Dta Em Transito
			//+------------------------------------------------------------------------------------//
			dDtaEmb := SW6->W6_DT_EMB
			If !Empty(dDtaEmb)
				SW6->W6_DT_EMB := dDtaEmb // O Lancamento 904 busca a data do Embarque com M-> entao foi preciso FAZER a recpcao desta variavel
				U_UZValInform("900")
			Endif
			
		EndIf
		
		//+-----------------------------------------------------------------------------------//
		//|Parametro..: "ESTORNO"  // Luiz Fernando - 06/08/2010
		//|Descricao..: Verifica se Nota classificada com permiss�o apenas do Setor Fiscal
		//+-----------------------------------------------------------------------------------//
	Case ParamIxb == "ESTORNO"
        
        lRetNF1 := .T.
//Codigo comentado por ANESIO, a partir da vers�o 11 o EIC s� permite a exclus�o de notas fiscais classificadas.        		
/*		_AliasSWN := GetArea()
		SF1->(DbSetOrder(5))
		IF SF1->(DBSEEK(xFilial("SF1")+SW6->W6_HAWB+"1"+cNota))
			If SF1->F1_STATUS != " "
				MsgInfo("NF Est� Classificada, Exclus�o liberada apenas para Dpto Fiscal !","Aten��o")
				lRetNF1 := .F.
			Endif
		Endif
		
		SF1->(DbSetOrder(5))
		IF SF1->(DBSEEK(xFilial("SF1")+SW6->W6_HAWB+"2"+cNota))
			If SF1->F1_STATUS != " " 
				MsgInfo("NF Est� Classificada, Exclus�o liberada apenas para Dpto Fiscal !","Aten��o")
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