#INCLUDE "RWMAKE.CH"    
#INCLUDE "PROTHEUS.ch"
/*
----------------------------------------------------------------------------------------
Funcao: FA290															Data: 16.03.2010
Autor : Gildesio Campos
----------------------------------------------------------------------------------------
Objetivo: PE apos a gravacao da Fatura a Pagar no SE2 (apos PE FA290TOK)
		  -	Gera e imprime AP para o titulo tipo FATURA
		  -	Monta array para Impressão da Autorizacao de Pagmento 
----------------------------------------------------------------------------------------
aDadosTit:	1-Prefixo
			2-Numero do Titulo
			3-Parcela
			4-Tipo
			5-Fornecedor
			6-Loja    
			7-Numero da AP
			8-Banco Fav
			9-Agencia Fav
			10-Conta Fav
			11-Nom Fav
			12-Cpf Fav	   
			13-Origem AP   
			14-Tipo de Conta     	| 1=Conta Corrente 2= Conta Poupanca (A2_X_TPCON)
			15-Forma de Pagamento   | 1=DOC/TED 2=Boleto/DDA 3=Cheque      
			16-Historico
---------------------------------------------------------------------------------------------------*/
User Function FA290()

Local lRet      := .T.    

Static nLinAcols := 1
/*	
----------------------------------------------------
Regrava tabela SE2-CONTAS A PAGAR (FATURA)
----------------------------------------------------*/
Replace	SE2->E2_X_NUMAP 	With cNumAp 
Replace SE2->E2_X_ORIG 	    With cCodOri 
Replace SE2->E2_X_FPAGT 	With cFrmPag 
Replace SE2->E2_X_BCOFV 	With cBco
Replace SE2->E2_X_AGEFV 	With cAge
Replace SE2->E2_X_CTAFV 	With cConta 
Replace SE2->E2_X_TPCTA 	With cTPCta 
Replace SE2->E2_X_NOMFV 	With cNomFav 
Replace SE2->E2_X_CPFFV 	With cInscr 
Replace SE2->E2_HIST    	With cHistor 
Replace SE2->E2_X_USUAR 	With Alltrim(USRFULLNAME(RETCODUSR())) 
Replace SE2->E2_X_DEPTO 	With Tabela("80",cCodOri,.f.) 
Replace SE2->E2_X_CODUS 	With RetCodUsr()
Replace SE2->E2_X_FORIG     With cForOrig
Replace SE2->E2_X_CODRE     With cCodRec      

/*AOliveira 12-04-2011 Chamado 002489*/
Replace SE2->E2_JUROS	With nJuros 
Replace SE2->E2_MULTA	With nMulta
Replace SE2->E2_CORREC	With nCorrec
Replace SE2->E2_APURAC	With dDataAp
//                                     

/*AOliveira 04-04-2019 "Incluido para que os titulos de Fatura seja liberado"*/
Replace SE2->E2_DATALIB With ddatabase
//                       

aAdd(aDadosTit, {SE2->E2_PREFIXO,SE2->E2_NUM    ,SE2->E2_PARCELA,SE2->E2_TIPO   ,SE2->E2_FORNECE,SE2->E2_LOJA,;   
   				 SE2->E2_VENCTO ,SE2->E2_VENCREA,SE2->E2_NATUREZ,SE2->E2_HIST   ,SE2->E2_X_BCOFV,SE2->E2_X_AGEFV,;
   				 SE2->E2_X_CTAFV,SE2->E2_X_NOMFV,SE2->E2_X_TPCTA,SE2->E2_X_CPFFV,SE2->E2_X_NUMAP,SE2->E2_EMISSAO,;
   				 SE2->E2_X_ORIG ,SE2->E2_VALOR  ,SE2->E2_X_USUAR,SE2->E2_X_FPAGT,SE2->E2_CCD    ,SE2->E2_CODINS,;
        		 SE2->E2_CODRET ,SE2->E2_X_CODRE,SE2->E2_ACRESC ,SE2->E2_DECRESC,SE2->E2_MULTA  ,SE2->E2_JUROS ,SE2->E2_CORREC,SE2->E2_X_FORIG, SE2->E2_HIST1 })

/*                                               
----------------------------------------------------
Rotina de impressao da AP
----------------------------------------------------*/
If nLinaCols == Len(aCols)
	U_RFINR01(aDadosTit,"FT") 
	nLinAcols := 1
Else
	nLinAcols += 1
EndIf              

Return(lRet)
