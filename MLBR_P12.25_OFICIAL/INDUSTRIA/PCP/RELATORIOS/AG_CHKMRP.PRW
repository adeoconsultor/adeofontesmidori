#Include 'Protheus.ch'
#Include 'Rwmake.ch'

#DEFINE PICVAL  "@E 999,999,999.99"

//---------------------------------
/*

/////////////////////////////////////////////////////////////////////////////////
//Este Programa gera em excel as entradas e saidas de produtoos conforme seleÁ„o do usuario.
//foi desenvolvido com o objetivo de facilidar o acompanhamento di·rio dos usuarios com relacao 
//as transferencias de produtos do armazem 01 para o 02 em PNP2 -
//Mostra as transferencias que ocorreram e a qual plano se refere.

//Desenvolvido por Anesio G.Faria - Taggs Consultoria - 10-10-2011 

*/

User function AG_CHKMRP()
Private cPerg   := "AG_CHKMRP"
Private aConteud    := {}       
Private aDir     	:= {}
Private nHdl     	:= 0
Private lOk     	:= .T.
Private cArqTxt  	:= ""
Private cCab        := "" 

aDir := MDirArq()
AjustaSx1()
If ! Pergunte(cPerg,.T.)
	Return
Endif

If Empty(aDir[1]) .OR. Empty(aDir[2])
	Return
Else                      
		Processa({ || AG_CHKQRY()}, 'Gerando informacoes...')

		Processa({ || lOk := MCVS(aConteud,cCab,Alltrim(aDir[1])+Alltrim(aDir[2]),PICVAL) })
		If lOk
			MExcel(Alltrim(aDir[1]),Alltrim(aDir[2]))
		EndIf
    endif




return


static function AG_CHKQRY()
local cOP    := "" 
local nCount := 0
local cES    := "" //Variavel registra se È entrada ou saida.
local cModelo:= ""
Local i

Processa({ || AG_QRYENT()}, 'Extraindo dados......')
 //Executa a consulta de entrada de materiais...

ProcRegua(0)
cPeriodo := ""
Do Case
	Case MV_PAR06=="M" //Mensal
		cPeriodo := "MENSAL"
	Case MV_PAR06=="T" //Trimestral
		cPeriodo := "TRIMESTRAL"
	Case MV_PAR06=="S" //Semestral
		cPeriodo := "SEMESTRAL"
	Case MV_PAR06=="A" //Anual
		cPeriodo := "ANUAL"
	OtherWise
		cPeriodo := "INCORRETO"
EndCase

aAdd(aConteud, {"ANALISE DE CONSUMO DE ESTOQUE - PARA IMPLANTACAO MRP - PERIODO: "+cPeriodo+" - ANO: "+MV_PAR05})
aAdd(aConteud, {"GRUPO DE "+mv_par01+" ATE "+mv_par02+" - PRODUTO DE "+mv_par03+" ATE "+mv_par04+" - FILIAL DE "+MV_PAR07+" ATE "+mv_par08})
if mv_par07 <> mv_par08
	aAdd(aConteud, {"APENAS NOTAS FISCAIS QUE MOVIMENTARAM ESTOQUE E GERARAM FINANCEIRO - COMPRAS" })
else
	aAdd(aConteud, {"APENAS NOTAS FISCAIS QUE MOVIMENTARAM ESTOQUE - COMPRAS E TRANSFERENCIAS " })
endif


//Cria as colunas da planilha conforme tipo de periodo selecionado
Do Case
	Case MV_PAR06=="M" //Mensal
				//				   01		 	02					03		 		  04			  05		  06				07				08			09	 			      10		      11			 12		 		 13				     14	    		   15			   16					17			  		  18			   19			      20	    21		   22		 23		  24	 25		 26		 27		 28	   	 29		 30		 31		 32		 33		  34     35
//		aAdd(aConteud, {TRBD3->MES_ANO+"'",TRBD3->D1_GRUPO+"'",TRBD3->D1_COD+"'",TRBD3->B1_DESC, TRBD3->QTDE,TRBD3->QTDETRANSF,TRBD3->QTDECOMPR, nCompras, TRBD3->D1_FORNECE+"'",TRBD3->A2_NOME, TRBD3->A2_MUN, TRBD3->A2_EST, 	TRBD3->PRAZ_ENTREG, TRBD3->TIPO_PRAZ, TRBD3->QTD_EMB, TRBD3->PONTO_PEDIDO, TRBD3->EST_SEGURANCA, TRBD3->LOTE_ECON, TRBD3->LOTE_MINIMO, nConsPrd, nConsTMs, nConsTrans, nEstAnt,nEstJan,nEstFev,nEstMar,nEstAbr,nEstMai,nEstJun,nEstJul,nEstAgo,nEstSet,nEstOut,nEstNov,nEstDez})
	
		//				     01		       02	  03		 04		                 	05			       	06					    	07						08					09	         10	            11		       12			13			14			   15		      16			17			     18		     	19		  20		21		   22		 23			24		  25		26		  27		28		  29		 30		   31	
		AADD(aConteud, {"MES ANO     ","GRUPO","CODIGO","DESCRICAO DO PRODUTO","QTDE ENTRADA TOTAL","ENTRADA TRANSF FILIAIS", "ENTRADA VIA COMPRAS", "COMPRAS EM ANDAMENTO", "PRAZO ENTREGA","TIPO PRAZO","QTDE EMBALAGEM","PONTO PEDIDO","EST SEGUR","LOTE ECON","LOTE MINIMO", "CONSUMO OP", "CONSUMO TM", "TRANS / DESMONT", "EST ANT", "EST JAN", "EST FEV","EST MAR","EST ABR","EST MAI","EST JUN","EST JUL","EST AGO","EST SET", "EST OUT", "EST NOV","EST DEZ" })
	Case MV_PAR06=="T" //Trimestral
		AADD(aConteud, {"TRIM ANO    ","GRUPO","CODIGO","DESCRICAO DO PRODUTO","QTDE ENTRADA TOTAL","ENTRADA TRANSF FILIAIS", "ENTRADA VIA COMPRAS", "COMPRAS EM ANDAMENTO", "PRAZO ENTREGA","TIPO PRAZO","QTDE EMBALAGEM","PONTO PEDIDO","EST SEGUR","LOTE ECON","LOTE MINIMO", "CONSUMO OP", "CONSUMO TM", "TRANS / DESMONT", "EST ANT", "EST JAN", "EST FEV","EST MAR","EST ABR","EST MAI","EST JUN","EST JUL","EST AGO","EST SET", "EST OUT", "EST NOV","EST DEZ" })
	Case MV_PAR06=="S" //Semestral
		AADD(aConteud, {"SEMESTRE ANO","GRUPO","CODIGO","DESCRICAO DO PRODUTO","QTDE ENTRADA TOTAL","ENTRADA TRANSF FILIAIS", "ENTRADA VIA COMPRAS", "COMPRAS EM ANDAMENTO", "PRAZO ENTREGA","TIPO PRAZO","QTDE EMBALAGEM","PONTO PEDIDO","EST SEGUR","LOTE ECON","LOTE MINIMO", "CONSUMO OP", "CONSUMO TM", "TRANS / DESMONT", "EST ANT", "EST JAN", "EST FEV","EST MAR","EST ABR","EST MAI","EST JUN","EST JUL","EST AGO","EST SET", "EST OUT", "EST NOV","EST DEZ" })
	Case MV_PAR06=="A" //Anual         
		AADD(aConteud, {"ANO         ","GRUPO","CODIGO","DESCRICAO DO PRODUTO","QTDE ENTRADA TOTAL","ENTRADA TRANSF FILIAIS", "ENTRADA VIA COMPRAS", "COMPRAS EM ANDAMENTO", "PRAZO ENTREGA","TIPO PRAZO","QTDE EMBALAGEM","PONTO PEDIDO","EST SEGUR","LOTE ECON","LOTE MINIMO", "CONSUMO OP", "CONSUMO TM", "TRANS / DESMONT", "EST ANT", "EST JAN", "EST FEV","EST MAR","EST ABR","EST MAI","EST JUN","EST JUL","EST AGO","EST SET", "EST OUT", "EST NOV","EST DEZ" })
	OtherWise
		cPeriodo := "INCORRETO"
EndCase
aAux := {}
dbSelectArea("TRBD3")
TRBD3->(dbGotop())
while !TRBD3->(eof())
	incproc("Preenchendo Planilha....")
	//Incluir a quantidade consumida em producao...
		nPos := aScan(aProducao, {|x| x[1]+x[2] == TRBD3->(MES_ANO+D1_COD)})
		if nPos > 0 
			nConsPrd 			:= aProducao[nPos][3]
			aProducao[nPos][4] 	:= .F.
		else
		    nConsPrd 			:= 0 
		endif

	//Incluir a quantidade consumida por acertos...
		nPos := aScan(aTMs, {|x| x[1]+x[2] == TRBD3->(MES_ANO+D1_COD)})
		if nPos > 0 
			nConsTMs 			:= aTMs[nPos][3]
			aTMs[nPos][4]		:= .F.
		else
		    nConsTMs 			:= 0 
		endif

	//Incluir a quantidade consumida por transferencias/desmontagem
		nPos := aScan(aTrans, {|x| x[1]+x[2] == TRBD3->(MES_ANO+D1_COD)})
		if nPos > 0 
			nConsTrans 			:= aTrans[nPos][3]
			aTrans[nPos][4] 	:= .F.
		else
		    nConsTrans 			:= 0 
		endif

	//Incluir a quantidade consumida por transferencias/desmontagem
		nPos := aScan(aCompras, {|x| x[1]+x[2] == TRBD3->(MES_ANO+D1_COD)})
		if nPos > 0 
			nCompras 			:= aCompras[nPos][3]
			aCompras[nPos][4] 	:= .F.
		else
		    nCompras 			:= 0 
		endif


	//Incluir o fechamento do estoque mes a mes 
		nPos 	:= aScan(aEstoque, {|x| x[1] == TRBD3->D1_COD })
		nPosAnt := aScan(aEstoque, {|x| x[1] == TRBD3->D1_COD })
		if nPos > 0 
			nEstAnt 	  		:= aEstoque[nPosAnt][2] 
			nEstJan 			:= aEstoque[nPos][3]
			nEstFev 			:= aEstoque[nPos][4]
			nEstMar				:= aEstoque[nPos][5]
			nEstAbr 			:= aEstoque[nPos][6]
			nEstMai 			:= aEstoque[nPos][7]
			nEstJun 			:= aEstoque[nPos][8]
			nEstJul 			:= aEstoque[nPos][9]
			nEstAgo 			:= aEstoque[nPos][10]
			nEstSet 			:= aEstoque[nPos][11]
			nEstOut 			:= aEstoque[nPos][12]
			nEstNov 			:= aEstoque[nPos][13]
			nEstDez 			:= aEstoque[nPos][14]
			aEstoque[nPos][15] 	:= .F.
		elseif  nPosAnt > 0
			nEstAnt 	  		:= aEstoque[nPosAnt][2]
			nEstAnt := 0
			nEstJan := 0
			nEstFev := 0
			nEstMar := 0
			nEstAbr := 0
			nEstMai := 0
			nEstJun := 0
			nEstJul := 0
			nEstAgo := 0
			nEstSet := 0
			nEstOut := 0
			nEstNov := 0
			nEstDez := 0
			aEstoque[nPosAnt][15] 	:= .F.
		else
			nEstAnt := 0
			nEstJan := 0
			nEstFev := 0
			nEstMar := 0
			nEstAbr := 0
			nEstMai := 0
			nEstJun := 0
			nEstJul := 0
			nEstAgo := 0
			nEstSet := 0
			nEstOut := 0
			nEstNov := 0
			nEstDez := 0
		endif
				//				   01		 	02					03		 		  04			  05		  06				07				08			09	 			     10		           11			   12		 		     13				      14	    		15			    16				17			   18			    19			  20	         21		        22		       23		       24	         25		         26		       27		       28	   	      29		      30		       31	
		aAdd(aConteud, 	{TRBD3->MES_ANO+"'",TRBD3->D1_GRUPO+"'",TRBD3->D1_COD+"'",TRBD3->B1_DESC, TRBD3->QTDE,TRBD3->QTDETRANSF,TRBD3->QTDECOMPR, nCompras, TRBD3->PRAZ_ENTREG, TRBD3->TIPO_PRAZ, TRBD3->QTD_EMB, TRBD3->PONTO_PEDIDO, TRBD3->EST_SEGURANCA, TRBD3->LOTE_ECON, TRBD3->LOTE_MINIMO, nConsPrd,      nConsTMs,    nConsTrans,       nEstAnt,       nEstJan,       nEstFev,       nEstMar,       nEstAbr,       nEstMai,       nEstJun,       nEstJul,       nEstAgo,        nEstSet,        nEstOut,		nEstNov,         nEstDez})

	TRBD3->(dbSkip())
enddo

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rotina para identificar os arrays que possuem informacoes que nao tiveram pedido de compras e n„o foram inseridos em aConteud
//durante o loop acima

//Inserir os itens consumidos por OPs (Ordens de Producao)
for i:=1 to len(aProducao)
	if aProducao[i][4]
		nPos := aScan(aAux, {|x| x[1]+x[3] == aProducao[i][1]+aProducao[i][2] })
		if nPos > 0 
			aAux[nPos][20] := aProducao[i][3]
		else
			cGrupo 		:= posicione("SB1",1,xFilial("SB1")+aProducao[i][2],"B1_GRUPO")
			cDesc 	   	:= posicione("SB1",1,xFilial("SB1")+aProducao[i][2],"B1_DESC")
			//						01				        02		 	    03			             04            05 				 06 			  07       08  	   09   		  10  			11   		   12   			   13   			 14               15  			  16            17 	           18                  19        20                 21             22            23            24              25            26              27             28             29            30            31    
			aAdd(aAux, 		{aProducao[i][1],            cGrupo+"'",   aProducao[i][2], 		   cDesc,	        0, 				  0, 			   0, 		0, 		0, 			 " ",            0, 	   	    0, 					0,                0, 			   0, aProducao[i][3],		     0,             0,			  0,			0,				0,			  0,			  0, 			 0,				0,			  0,			0,				0,				0,				0,				0})
		endif
	endif
next i 

//Inserir itens consumidos via TMs 
for i:=1 to len(aTMs)
	if aTMs[i][4]
		nPos := aScan(aAux, {|x| x[1]+x[3] == aTMs[i][1]+aTMs[i][2] })
		if nPos > 0 
			aAux[nPos][21] := aTMs[i][3]
		else
			cGrupo 		:= posicione("SB1",1,xFilial("SB1")+aTMs[i][2],"B1_GRUPO")
			cDesc 	   	:= posicione("SB1",1,xFilial("SB1")+aTMs[i][2],"B1_DESC")
			//						01				        02		 	    03			         04            05 				 06 			  07       08  			   09   		  10  			11   		   12   		     13   			 14            15  		 16 	         17 	           18            19        20              21            22          23         24              25           26            27          28          29          30           31
			aAdd(aAux, 		{   aTMs[i][1],            cGrupo+"'",     aTMs[i][2], 		       cDesc,	        0, 				  0, 			   0, 		0, 			    0, 			 " ",            0, 			0, 				  0,              0, 			0, 		  0,	    aTMs[i][3],             0,			  0,		0,				0,			  0,		  0, 		 0,			    0,			  0,			0,			0,			0,			0,			0})
		endif
	endif
next i 

//Inserir os Itens transferidos 
for i:= 1 to len(aTrans)
	if aTrans[i][4]
//	Alert("ATRANS-> |"+x[1]+x[3]+"| |"+aTrans[i][1]+aTMs[i][2]+"|")
		if len(aTMS) >= i
			nPos := aScan(aAux, {|x| x[1]+x[3] == aTrans[i][1]+aTMs[i][2] })
			if nPos > 0
				aAux[nPos][22] := aTrans[i][3]
			else
				cGrupo 		:= posicione("SB1",1,xFilial("SB1")+aTrans[i][2],"B1_GRUPO")
				cDesc 	   	:= posicione("SB1",1,xFilial("SB1")+aTrans[i][2],"B1_DESC")
				//						01				        02		 	    03			             04            05 				 06 			  07       08 	   09   		  10  			11   		  12   			 13   			 14            15  	     16 			 17           18             19        20              21             22            23          24              25            26              27             28             29            30            31
				aAdd(aAux, 		{   aTrans[i][1],            cGrupo+"'",     aTrans[i][2], 		       cDesc,	        0, 				  0, 			   0, 		0,		0, 			 " ",            0, 		   0, 			  0,              0, 			0, 		  0,	          0,  aTrans[i][3],			  0,		0,				0,			  0,			 0, 		 0,				 0,			  0,			0,				0,				0,				0,		     0})
			endif
	    endif
	endif
next i 

//Inserir os itens de estoque
/*
for i:= 1 to len(aEstoque)
//	if aEstoque[1][15]
		nPos := aScan(aAux, { |x| x[3] == aEstoque[i][1] })
//		Alert("POSICAO-> " +cValToChar(nPos)+"  |"+aEstoque[i][1]+"| ")
		if nPos > 0 
			cGrupo 		:= posicione("SB1",1,xFilial("SB1")+aEstoque[i][1],"B1_GRUPO")
			cDesc 	    := posicione("SB1",1,xFilial("SB1")+aEstoque[i][1],"B1_DESC")
			aAux[i][19] := aEstoque[i][2]
			aAux[i][20] := aEstoque[i][3]
			aAux[i][21] := aEstoque[i][4]
			aAux[i][22] := aEstoque[i][5]
			aAux[i][23] := aEstoque[i][6]
			aAux[i][24] := aEstoque[i][7]
			aAux[i][25] := aEstoque[i][8]
			aAux[i][26] := aEstoque[i][9]
			aAux[i][27] := aEstoque[i][10]
			aAux[i][28] := aEstoque[i][11]
			aAux[i][29] := aEstoque[i][12]
			aAux[i][30] := aEstoque[i][13]
			aAux[i][31] := aEstoque[i][14]
			//						01				                   02		 	    03			         04            05 				 06 			  07       08   	   09   		  10  			11   		   12   			   13   				 14               15  				   16 			         17 	           18                  19         20             21              22            23            24              25            26              27              28              29             30              31             
//			aAdd(aAux, 		{aEstoque[i][16],            aEstoque[i][17]+"'",   aEstoque[i][1], 		   cDesc,	        0, 				  0, 			   0, 		0, 			0, 			 " ",            0, 	   	    0, 				    0,                    0, 			   0,		            0,		              0,                0,      aEstoque[i][2], aEstoque[i][3], aEstoque[i][4], aEstoque[i][5],aEstoque[i][6],aEstoque[i][7],aEstoque[i][8],aEstoque[i][9],aEstoque[i][10],aEstoque[i][11],aEstoque[i][12],aEstoque[i][13],aEstoque[i][14]})
		endif
//	endif
next i
*/

//Inserir os dados a aAux no array aConteud
for i:= 1 to len(aAux)
		//						01				        02		 	    03			             04            05 				 06 			  07         08  					   09   		  10  		 	 11   		   12   			   13   				 14               15  				   16 			         17 	           18                  19         20                 21             22            23            24              25            26              27             28             29            30            31      //        32              33              34              35
	aAdd(aConteud, 		{   aAux[i][1]+"'",          aAux[i][2],    aAux[i][3]+"'", 		     aAux[i][4],   aAux[i][5],		 aAux[i][6],      aAux[i][7],aAux[i][8], 			   aAux[i][9],    aAux[i][10], 	aAux[i][11],  aAux[i][12], 		   aAux[i][13], 	     aAux[i][14],     aAux[i][15], 		   aAux[i][16], 		aAux[i][17],      aAux[i][18], 	  aAux[i][19],  aAux[i][20],	     aAux[i][21],  aAux[i][22],	 aAux[i][23],  aAux[i][24],	   aAux[i][25],	 aAux[i][26],	 aAux[i][27], 	 aAux[i][28],  aAux[i][29],	 aAux[i][30],  aAux[i][31]}) //,	   aAux[i][32],	   aAux[i][33],	    aAux[i][34],    aAux[i][35] } )
next i

//Ajustar a posicao de estoque em todas as posicoes do array....
nCount := 0
for i:= 5 to len(aConteud)
	nPos := aScan(aEstoque, {|x| x[1] == Substr(aConteud[i][3],1,15) }) 
	if nPos > 0
	
				//				   01		 	02					03		 		  04			  05		  06				07				08			09	 			     10		           11			   12		 		     13				      14	    		15			    16				17			   18			    19			  20	         21		        22		       23		       24	         25		         26		       27		       28	   	      29		      30		       31	
//		aAdd(aConteud, 	{TRBD3->MES_ANO+"'",TRBD3->D1_GRUPO+"'",TRBD3->D1_COD+"'",TRBD3->B1_DESC, TRBD3->QTDE,TRBD3->QTDETRANSF,TRBD3->QTDECOMPR, nCompras, 
		
//		TRBD3->PRAZ_ENTREG, TRBD3->TIPO_PRAZ, TRBD3->QTD_EMB, TRBD3->PONTO_PEDIDO, TRBD3->EST_SEGURANCA, TRBD3->LOTE_ECON, TRBD3->LOTE_MINIMO, nConsPrd,      nConsTMs,    nConsTrans,       nEstAnt,       nEstJan,       nEstFev,       nEstMar,       nEstAbr,       nEstMai,       nEstJun,       nEstJul,       nEstAgo,        nEstSet,        nEstOut,		nEstNov,         nEstDez})
//		cQuery += " B1_PE PRAZ_ENTREG, B1_TIPE TIPO_PRAZ, B1_QE QTD_EMB, B1_EMIN PONTO_PEDIDO, "
//		cQuery += " B1_ESTSEG EST_SEGURANCA, B1_LE LOTE_ECON, B1_LM LOTE_MINIMO " 
	
	    aConteud[i][9]   := Posicione("SB1",1,xFilial("SB1")+aEstoque[nPos][1],"B1_PE")
	    aConteud[i][10]  := Posicione("SB1",1,xFilial("SB1")+aEstoque[nPos][1],"B1_TIPE")
	    aConteud[i][11]  := Posicione("SB1",1,xFilial("SB1")+aEstoque[nPos][1],"B1_QE")
	    aConteud[i][12]  := Posicione("SB1",1,xFilial("SB1")+aEstoque[nPos][1],"B1_EMIN")
	    aConteud[i][13]  := Posicione("SB1",1,xFilial("SB1")+aEstoque[nPos][1],"B1_ESTSEG")
	    aConteud[i][14]  := Posicione("SB1",1,xFilial("SB1")+aEstoque[nPos][1],"B1_LE")
	    aConteud[i][15]  := Posicione("SB1",1,xFilial("SB1")+aEstoque[nPos][1],"B1_LM")
	    
		aConteud[i][19] := aEstoque[nPos][2]
		aConteud[i][20] := aEstoque[nPos][3] 
		aConteud[i][21] := aEstoque[nPos][4] 
		aConteud[i][22] := aEstoque[nPos][5]
		aConteud[i][23] := aEstoque[nPos][6]
		aConteud[i][24] := aEstoque[nPos][7]
		aConteud[i][25] := aEstoque[nPos][8]
		aConteud[i][26] := aEstoque[nPos][9]
		aConteud[i][27] := aEstoque[nPos][10]
		aConteud[i][28] := aEstoque[nPos][11]
		aConteud[i][29] := aEstoque[nPos][12]
		aConteud[i][30] := aEstoque[nPos][13]
		aConteud[i][31] := aEstoque[nPos][14]
		nCount++
	endif
next i 
//Alert("Atualizado "+cValToChar(nCount))


/*
aAux1 := {}
//aAux1 := aClone(aConteud)

for i:= 5 to len(aConteud)
	AADD( aAux, {aConteud[i][1], aConteud[i][2], aConteud[i][3], aConteud[i][4], aConteud[i][5], aConteud[i][6], aConteud[i][7], aConteud[i][8], aConteud[i][9], aConteud[i][10], aConteud[i][11], aConteud[i][12], aConteud[i][13], aConteud[i][14], aConteud[i][15], aConteud[i][16], aConteud[i][17], aConteud[i][18], aConteud[i][19], aConteud[i][20], aConteud[i][21], aConteud[i][22], aConteud[i][23], aConteud[i][24], aConteud[i][25], aConteud[i][26], aConteud[i][27], aConteud[i][28], aConteud[i][29], aConteud[i][30], aConteud[i][31] })
//	for j:= 1 to 31
//		aAux[i-4][j] := aConteud[i][j]
//	next j
next i 

for i:= 5 to len(aConteud)
	aConteud[i][20] := buscafech(20, aConteud[i][3], aAux1)
	aConteud[i][21] := buscafech(21, aConteud[i][3], aAux1)
	aConteud[i][22] := buscafech(22, aConteud[i][3], aAux1)
	aConteud[i][23] := buscafech(23, aConteud[i][3], aAux1)
	aConteud[i][24] := buscafech(24, aConteud[i][3], aAux1)
	aConteud[i][25] := buscafech(25, aConteud[i][3], aAux1)
	aConteud[i][26] := buscafech(26, aConteud[i][3], aAux1)
	aConteud[i][27] := buscafech(27, aConteud[i][3], aAux1)
	aConteud[i][28] := buscafech(28, aConteud[i][3], aAux1)
	aConteud[i][29] := buscafech(29, aConteud[i][3], aAux1)
	aConteud[i][30] := buscafech(30, aConteud[i][3], aAux1)
	aConteud[i][31] := buscafech(31, aConteud[i][3], aAux1)
next i 
*/

//FunÁ„o para buscar o saldo fechamento de estoque de cada mes
static function buscafech(nMes, cProd, aAux1)
local nRet := 0
local _nMes := nMes - 19
Local i
//Alert(" TAMANHO ARRAY-> "+cValToChar(len(aAux1)))
for i := 1 to len(aAux1)
	Alert("Posicao -> "+cValToChar(i)+ ":  |"+aAux[i][1]+aAux[i][3]+"|")
next i 
	Do Case
		case _nMes == 1 
			nPos := aScan(aAux1, {|x| x[1]+x[3] == "01/"+mv_par05+"'"+cProd})
//			alert("aAUX1 |"+x[1]+x[3]+"| COMPARADO |"+"01/"+mv_par05+"'"+cProd+"|")
			if nPos > 0 
				nRet := aAux1[nPos][nMes]
			endif
		case _nMes == 2 
			nPos := aScan(aAux1, {|x| x[1]+x[3] == "02/"+mv_par05+"'"+cProd})
			alert("aAUX1 |"+x[1]+x[3]+"| COMPARADO |"+"01/"+mv_par05+"'"+cProd+"|")
			if nPos > 0 
				nRet := aAux1[nPos][nMes]
			endif
		case _nMes == 3 
			nPos := aScan(aAux1, {|x| x[1]+x[3] == "03/"+mv_par05+"'"+cProd})
			if nPos > 0 
				nRet := aAux1[nPos][nMes]
			endif
		case _nMes == 4 
			nPos := aScan(aAux1, {|x| x[1]+x[3] == "04/"+mv_par05+"'"+cProd})
			if nPos > 0 
				nRet := aAux1[nPos][nMes]
			endif
		case _nMes == 5 
			nPos := aScan(aAux1, {|x| x[1]+x[3] == "05/"+mv_par05+"'"+cProd})
			if nPos > 0 
				nRet := aAux1[nPos][nMes]
			endif
		case _nMes == 6 
			nPos := aScan(aAux1, {|x| x[1]+x[3] == "06/"+mv_par05+"'"+cProd})
			if nPos > 0 
				nRet := aAux1[nPos][nMes]
			endif
		case _nMes == 7 
			nPos := aScan(aAux1, {|x| x[1]+x[3] == "07/"+mv_par05+"'"+cProd})
			if nPos > 0
				nRet := aAux1[nPos][nMes]
			endif
		case _nMes == 8 
			nPos := aScan(aAux1, {|x| x[1]+x[3] == "08/"+mv_par05+"'"+cProd})
			if nPos > 0 
				nRet := aAux1[nPos][nMes]
			endif
		case _nMes == 9 
			nPos := aScan(aAux1, {|x| x[1]+x[3] == "09/"+mv_par05+"'"+cProd})
			if nPos > 0 
				nRet := aAux1[nPos][nMes]
			endif
		case _nMes == 10 
			nPos := aScan(aAux1, {|x| x[1]+x[3] == "10/"+mv_par05+"'"+cProd})
			if nPos > 0 
				nRet := aAux1[nPos][nMes]
			endif
		case nMes == 11
			nPos := aScan(aAux1, {|x| x[1]+x[3] == "11/"+mv_par05+"'"+cProd})
			if nPos > 0 
				nRet := aAux1[nPos][nMes]
			endif
		case _nMes == 12 
			nPos := aScan(aAux1, {|x| x[1]+x[3] == "12/"+mv_par05+"'"+cProd})
			if nPos > 0 
				nRet := aAux1[nPos][nMes]
			endif
		otherwise
			nRet := 0
	endcase 
return nRet

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FIM ROTINA DE ARRAYs QUE NAO CONSTARAM NO FILTRO DE COMPRAS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




return


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ-ø±±
±±≥FunáÖo    ≥ AjustaSX1    ≥Autor ≥  Anesio G.Faria -    ≥    19.10.2011 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ-¥±±
±±≥DescriáÖo ≥ Ajusta perguntas do SX1                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

static Function AjustaSX1()

Local aArea := GetArea()
//PutSx1(cPerg,"01","Periodo de                    ?"," "," ","mv_ch1","C",4,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o ano"},{"Informe o ano"},{"Informe o ano"})
PutSx1(cPerg,"01","Grupo de                      ?"," "," ","mv_ch1","C",4,0,0,	"G","","SBM","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Grupo inicial  "},{"Informe o Grupo inicial  "},{"Informe o Grupo inicial  "})
PutSx1(cPerg,"02","Grupo ate                     ?"," "," ","mv_ch2","C",4,0,0,	"G","","SBM","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Grupo final  "},{"Informe o Grupo final  "},{"Informe o Grupo finial "})
PutSx1(cPerg,"03","Produto de                    ?"," "," ","mv_ch3","C",15,0,0,"G","","SB1","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto inicial"},{"Informe o produto inicial"},{"Informe o produto inicial"})
PutSx1(cPerg,"04","Produto ate                   ?"," "," ","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o produto final"},{"Informe o produto final"},{"Informe o produto final"})
PutSx1(cPerg,"05","Ano		                     ?"," "," ","mv_ch5","C",4,0,0, "G","","   ","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe o Ano a ser considerado          "},{"Informe o Ano a ser considerado"},{"Informe o Ano a ser considerado           "})
PutSx1(cPerg,"06","Tipo de Analise               ?"," "," ","mv_ch6","C",1,0,2, "G","","   ","","","mv_par06","M=Mensal","M=Mensal","M=Mensal","T=Trimestral","T=Trimestral","T=Trimestral","S=Semestral","S=Semestral","S=Semestral","A=Anual","A=Anual","A=Anual"," "," ",	" ","",{"Informe o tipo de an·lise           "},{"Informe o tipo de an·lise     "},{"Informe o tipo de an·lise"})
PutSx1(cPerg,"07","Filial de                     ?"," "," ","mv_ch7","C",2,0,0, "G","","   ","","","mv_par07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a Filial inicial           "},{"Informe a Filial inicial           "},{"Informe a Filial inicial           "})
PutSx1(cPerg,"08","Filial ate                    ?"," "," ","mv_ch8","C",2,0,0, "G","","   ","","","mv_par08"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" ","",{"Informe a Filial Final           "},{"Informe a Filial final           "},{"Informe a Filial final           "})
//PutSx1(cPerg,"09","Filtrar apenas transferencias ?"," "," ","mv_ch9","N",1,0,2, "C","","   ","","","mv_par09","Sim","Sim","Sim"," ","Nao","Nao","Nao"," "," "," ", " "," "," "," "," ","",{"Filtrar apenas as transferencias"},{"Filtrar apenas as transferencias"},{"Filtrar apenas as transferencias"})
RestArea(aArea)
Return


//+-----------------------------------------------------------------------------------//
//|Funcao....: MDirArq
//|Descricao.: Defini DiretÛrio e nome do arquivo a ser gerado
//|Retorno...: aRet[1] = DiretÛrio de gravaÁ„o
//|            aRet[2] = Nome do arquivo a ser gerado
//|ObservaÁ„o:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MDirArq()
*-----------------------------------------*
Local aRet := {"",""}
Private bFileFat:={|| cDir:=UZXChoseDir(),If(Empty(cDir),cDir:=Space(250),Nil)}
Private cArq    := Space(10)
Private cDir    := Space(250)
Private oDlgDir := Nil
Private cPath   := "Selecione diretÛrio"
Private aArea   := GetArea()
Private lRetor  := .T.
Private lSair   := .F.

//+-----------------------------------------------------------------------------------//
//| DefiniÁ„o da janela e seus conte˙dos
//+-----------------------------------------------------------------------------------//
While .T.
	DEFINE MSDIALOG oDlgDir TITLE "DefiniÁ„o de Arquivo e DiretÛrio" FROM 0,0 TO 175,368 OF oDlgDir PIXEL
	
	@ 06,06 TO 65,180 LABEL "Dados do arquivo" OF oDlgDir PIXEL
	
	@ 15, 10 SAY   "Nome do Arquivo"  SIZE 45,7 PIXEL OF oDlgDir
	@ 25, 10 MSGET cArq               SIZE 50,8 PIXEL OF oDlgDir
	
	@ 40, 10 SAY "Diretorio de gravaÁ„o"  SIZE  65, 7 PIXEL OF oDlgDir
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
Local cTitle:= "GeraÁ„o de arquivo"
Local cMask := "Formato *|*.*"
Local cFile := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions:= GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY

cFile:= cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,.F., nOptions)

Return(cFile)


//+-----------------------------------------------------------------------------------//
//|Funcao....: UZXValRel()
//|Descricao.: Valida informaÁıes de gravaÁ„o
//|Uso.......: U_UZXDIRARQ
//|ObservaÁ„o:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function UZXValRel(cValida)
*-----------------------------------------*

Local lCancela

If cValida = "ok"
	If Empty(Alltrim(cArq))
		MsgInfo("O nome do arquivo deve ser informado","AtenÁ„o")
		lRetor := .F.
	ElseIf Empty(Alltrim(cDir))
		MsgInfo("O diretÛrio deve ser informado","AtenÁ„o")
		lRetor := .F.
		//	ElseIf Len(Alltrim(cDir)) <= 3
		//		MsgInfo("N„o se pode gravar o arquivo no diretÛrio raiz, por favor, escolha um subdiretÛrio.","AtenÁ„o")
		//		lRetor := .F.
	Else
		oDlgDir:End()
		lRetor := .T.
	EndIf
Else
	lCancela := MsgYesNo("Deseja cancelar a geraÁ„o do RelatÛrio / Documento?","AtenÁ„o")
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
//|ObservaÁ„o:
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
	MsgInfo("Dados n„o informados","Sem dados")
	lRet := .F.
	Return(lRet)
ElseIf Empty(cxArqTxt)
	MsgInfo("DiretÛrio e nome do arquivo n„o informados corretamente","DiretÛrio ou Arquivo")
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
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no CabeÁalho. Continua?","Atencao!")
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
//|ObservaÁ„o:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function MExcel(cxDir,cxArq)
*-----------------------------------------*
Local cArqTxt := cxDir+cxArq+".csv"
Local cMsg    := "Relatorio gerado com sucesso!"+CHR(13)+CHR(10)+"O arquivo "+cxArq+".csv"
cMsg    += " se encontra no diretÛrio "+cxDir

MsgInfo(cMsg,"AtenÁ„o")

If MsgYesNo("Deseja Abrir o arquivo em Excel?","AtenÁ„o")
	If ! ApOleClient( 'MsExcel' )
		MsgStop(" MsExcel nao instalado ")
		Return
	EndIf
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cArqTxt)
	oExcelApp:SetVisible(.T.)
EndIf

Return


static function AG_QRYENT()
Local cQuery := ""

procregua(0)

incproc("Gerando Entradas")

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Query para calcular as entradas via nota fiscal
Do Case
	Case MV_PAR06=="M" //Mensal
		cQuery := " Select MES_ANO, D1_GRUPO, D1_COD, B1_DESC, Sum(QTDE) QTDE, Sum(QTDETRANSF) QTDETRANSF,  Sum(QTDECOMPR) QTDECOMPR, "
		cQuery += " PRAZ_ENTREG, TIPO_PRAZ, QTD_EMB, PONTO_PEDIDO,  EST_SEGURANCA, LOTE_ECON, LOTE_MINIMO  from "
		cQuery += " (Select Substring(D1_DTDIGIT,5,2)+'/'+Substring(D1_DTDIGIT,1,4) MES_ANO, "
		cQuery += " D1_GRUPO, D1_COD, B1_DESC, " 
		cQuery += " Sum(D1_QUANT) QTDE, " 
		cQuery += " Case D1_FORNECE when '000148' then Sum(D1_QUANT) end QTDETRANSF, "
		cQuery += " Case D1_FORNECE when '000148' then 0 else Sum(D1_QUANT) end QTDECOMPR, "
//		cQuery += " D1_FORNECE, A2_NOME, A2_MUN, A2_EST, "
		cQuery += " B1_PE PRAZ_ENTREG, B1_TIPE TIPO_PRAZ, B1_QE QTD_EMB, B1_EMIN PONTO_PEDIDO, "
		cQuery += " B1_ESTSEG EST_SEGURANCA, B1_LE LOTE_ECON, B1_LM LOTE_MINIMO " 
		cQuery += " from SD1010 SD1, SB1010 SB1, SF4010 SF4 "
		cQuery += " where SD1.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ = ' ' and SF4.D_E_L_E_T_ =' '  "
//		cQuery += " and F4_FILIAL = D1_FILIAL " - Comentado por ter unificado as TES
		cQuery += " and B1_COD = D1_COD and D1_TES = F4_CODIGO "
		cQuery += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND B1_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQuery += " AND Substring(D1_DTDIGIT,1,4) = '"+mv_par05+"' " 
		cQuery += " AND F4_ESTOQUE = 'S' AND D1_QUANT > 0 " 
//		if mv_par07 <> mv_par08
//			cQuery += " AND F4_DUPLIC = 'S' "
//		endif
		cQuery += " AND D1_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' " 
		cQuery += " group by Substring(D1_DTDIGIT,5,2)+'/'+Substring(D1_DTDIGIT,1,4), D1_GRUPO, D1_COD, B1_DESC, D1_FORNECE, "
		//, A2_NOME, A2_MUN, A2_EST, "
		cQuery += " B1_PE, B1_TIPE, B1_QE, B1_EMIN, B1_ESTSEG, B1_LE, B1_LM) QRYMES " 
		cQuery += " group by MES_ANO, D1_GRUPO, D1_COD, B1_DESC, PRAZ_ENTREG, TIPO_PRAZ, QTD_EMB, PONTO_PEDIDO,  EST_SEGURANCA, LOTE_ECON, LOTE_MINIMO " 
		cQuery += " order by 1, 2 " 
	Case MV_PAR06=="T" //Trimestral
		cQuery := " Select MES_ANO, D1_GRUPO, D1_COD, B1_DESC, Sum(QTDE) QTDE, Sum(QTDETRANSF) QTDETRANSF, Sum(QTDECOMPR) QTDECOMPR, "
		cQuery += " PRAZ_ENTREG, TIPO_PRAZ, QTD_EMB, PONTO_PEDIDO, EST_SEGURANCA, LOTE_ECON, LOTE_MINIMO from ( " 
		cQuery += " Select '01|'+Substring(D1_DTDIGIT,1,4) MES_ANO, "
		cQuery += " D1_GRUPO, D1_COD, B1_DESC, " //D1_FORNECE, A2_NOME, A2_MUN, A2_EST,  "
		cQuery += " Sum(D1_QUANT) QTDE, " 
		cQuery += " Case D1_FORNECE when '000148' then Sum(D1_QUANT) end QTDETRANSF, "
		cQuery += " Case D1_FORNECE when '000148' then 0 else Sum(D1_QUANT) end QTDECOMPR, "
		cQuery += " B1_PE PRAZ_ENTREG, B1_TIPE TIPO_PRAZ, B1_QE QTD_EMB, B1_EMIN PONTO_PEDIDO, "
		cQuery += " B1_ESTSEG EST_SEGURANCA, B1_LE LOTE_ECON, B1_LM LOTE_MINIMO " 
		cQuery += " from SD1010 SD1, SB1010 SB1, SF4010 SF4 "
		cQuery += " where SD1.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ = ' ' and SF4.D_E_L_E_T_ =' '  "
//		cQuery += " and F4_FILIAL = D1_FILIAL  - Comentado por ter unificado as TES
		cQuery += " and B1_COD = D1_COD and D1_TES = F4_CODIGO "
		cQuery += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND B1_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQuery += " AND Substring(D1_DTDIGIT,1,4) = '"+mv_par05+"' " 
		cQuery += " AND D1_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' " 
		cQuery += " AND F4_ESTOQUE = 'S' AND D1_QUANT > 0 " 
//		if mv_par07 <> mv_par08
//			cQuery += " AND F4_DUPLIC = 'S' "
//		endif
		cQuery += " AND Substring(D1_DTDIGIT,5,2) between '01' and '03' " 
		cQUery += " group by '01|'+Substring(D1_DTDIGIT,1,4), D1_GRUPO, D1_COD, B1_DESC, D1_FORNECE, " // A2_NOME, A2_MUN, A2_EST, "
		cQuery += " B1_PE, B1_TIPE, B1_QE, B1_EMIN, B1_ESTSEG, B1_LE, B1_LM " 

		cQuery += " UNION ALL " 
		
		cQuery += " Select '02|'+Substring(D1_DTDIGIT,1,4) MES_ANO, "
		cQuery += " D1_GRUPO, D1_COD, B1_DESC, " // D1_FORNECE, A2_NOME, A2_MUN, A2_EST, "
		cQuery += " Sum(D1_QUANT) QTDE, " 
		cQuery += " Case D1_FORNECE when '000148' then Sum(D1_QUANT) end QTDETRANSF, "
		cQuery += " Case D1_FORNECE when '000148' then 0 else Sum(D1_QUANT) end QTDECOMPR, "
		cQuery += " B1_PE PRAZ_ENTREG, B1_TIPE TIPO_PRAZ, B1_QE QTD_EMB, B1_EMIN PONTO_PEDIDO, "
		cQuery += " B1_ESTSEG EST_SEGURANCA, B1_LE LOTE_ECON, B1_LM LOTE_MINIMO " 
		cQuery += " from SD1010 SD1, SB1010 SB1, SF4010 SF4 "
		cQuery += " where SD1.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ = ' ' and SF4.D_E_L_E_T_ =' '  "
//		cQuery += " and F4_FILIAL = D1_FILIAL "  - Comentado por ter unificado as TES
		cQuery += " and B1_COD = D1_COD and D1_TES = F4_CODIGO " // and A2_COD = D1_FORNECE and A2_LOJA = D1_LOJA "
		cQuery += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND B1_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQuery += " AND Substring(D1_DTDIGIT,1,4) = '"+mv_par05+"' " 
		cQuery += " AND D1_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' " 
		cQuery += " AND F4_ESTOQUE = 'S' AND D1_QUANT > 0 " 
//		if mv_par07 <> mv_par08
//			cQuery += " AND F4_DUPLIC = 'S' "
//		endif
		cQuery += " AND Substring(D1_DTDIGIT,5,2) between '04' and '06' " 
		cQUery += " group by '02|'+Substring(D1_DTDIGIT,1,4), D1_GRUPO, D1_COD, B1_DESC, D1_FORNECE, " //A2_NOME, A2_MUN, A2_EST, "
		cQuery += " B1_PE, B1_TIPE, B1_QE, B1_EMIN, B1_ESTSEG, B1_LE, B1_LM " 

		cQuery += " UNION ALL " 
		
		cQuery += " Select '03|'+Substring(D1_DTDIGIT,1,4) MES_ANO, "
		cQuery += " D1_GRUPO, D1_COD, B1_DESC, "// D1_FORNECE, A2_NOME, A2_MUN, A2_EST, "
		cQuery += " Sum(D1_QUANT) QTDE, " 
		cQuery += " Case D1_FORNECE when '000148' then Sum(D1_QUANT) end QTDETRANSF, "
		cQuery += " Case D1_FORNECE when '000148' then 0 else Sum(D1_QUANT) end QTDECOMPR, "
		cQuery += " B1_PE PRAZ_ENTREG, B1_TIPE TIPO_PRAZ, B1_QE QTD_EMB, B1_EMIN PONTO_PEDIDO, "
		cQuery += " B1_ESTSEG EST_SEGURANCA, B1_LE LOTE_ECON, B1_LM LOTE_MINIMO " 
		cQuery += " from SD1010 SD1, SB1010 SB1, SF4010 SF4 "
		cQuery += " where SD1.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ = ' ' and SF4.D_E_L_E_T_ =' '  "
//		cQuery += " and F4_FILIAL = D1_FILIAL "  - Comentado por ter unificado as TES
		cQuery += " and B1_COD = D1_COD and D1_TES = F4_CODIGO " //and A2_COD = D1_FORNECE and A2_LOJA = D1_LOJA "
		cQuery += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND B1_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQuery += " AND Substring(D1_DTDIGIT,1,4) = '"+mv_par05+"' " 
		cQuery += " AND D1_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' " 
		cQuery += " AND F4_ESTOQUE = 'S' AND D1_QUANT > 0 " 
//		if mv_par07 <> mv_par08
//			cQuery += " AND F4_DUPLIC = 'S' "
//		endif
		cQuery += " AND Substring(D1_DTDIGIT,5,2) between '07' and '09' " 
		cQUery += " group by '03|'+Substring(D1_DTDIGIT,1,4), D1_GRUPO, D1_COD, B1_DESC, D1_FORNECE, " // A2_NOME, A2_MUN, A2_EST, "
		cQuery += " B1_PE, B1_TIPE, B1_QE, B1_EMIN, B1_ESTSEG, B1_LE, B1_LM " 

		cQuery += " UNION ALL " 
		
		cQuery += " Select '04|'+Substring(D1_DTDIGIT,1,4) MES_ANO, "
		cQuery += " D1_GRUPO, D1_COD, B1_DESC, Sum(D1_QUANT) QTDE, " //D1_FORNECE, A2_NOME, A2_MUN, A2_EST, "
//		cQuery += " Sum(D1_QUANT) QTDE, " 
		cQuery += " Case D1_FORNECE when '000148' then Sum(D1_QUANT) end QTDETRANSF, "
		cQuery += " Case D1_FORNECE when '000148' then 0 else Sum(D1_QUANT) end QTDECOMPR, "
		cQuery += " B1_PE PRAZ_ENTREG, B1_TIPE TIPO_PRAZ, B1_QE QTD_EMB, B1_EMIN PONTO_PEDIDO, "
		cQuery += " B1_ESTSEG EST_SEGURANCA, B1_LE LOTE_ECON, B1_LM LOTE_MINIMO " 
		cQuery += " from SD1010 SD1, SB1010 SB1,SF4010 SF4 "
		cQuery += " where SD1.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ = ' ' and SF4.D_E_L_E_T_ =' '  "
//		cQuery += " and F4_FILIAL = D1_FILIAL "  - Comentado por ter unificado as TES
		cQuery += " and B1_COD = D1_COD and D1_TES = F4_CODIGO " //and A2_COD = D1_FORNECE and A2_LOJA = D1_LOJA "
		cQuery += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND B1_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQuery += " AND Substring(D1_DTDIGIT,1,4) = '"+mv_par05+"' " 
		cQuery += " AND D1_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' " 
		cQuery += " AND F4_ESTOQUE = 'S' AND D1_QUANT > 0 " 
//		if mv_par07 <> mv_par08
//			cQuery += " AND F4_DUPLIC = 'S' "
//		endif
		cQuery += " AND Substring(D1_DTDIGIT,5,2) between '10' and '12' " 
		cQUery += " group by '04|'+Substring(D1_DTDIGIT,1,4), D1_GRUPO, D1_COD, B1_DESC, D1_FORNECE, " //A2_NOME, A2_MUN, A2_EST, "
		cQuery += " B1_PE, B1_TIPE, B1_QE, B1_EMIN, B1_ESTSEG, B1_LE, B1_LM ) QRYTRY " 
		cQuery += " group by MES_ANO, D1_GRUPO, D1_COD, B1_DESC, PRAZ_ENTREG, TIPO_PRAZ, QTD_EMB, PONTO_PEDIDO, EST_SEGURANCA, LOTE_ECON, LOTE_MINIMO " 
		cQuery += " order by 1, 2 " 
		memowrite('e:\protheus11\arqqry.txt', cQuery )
		
	Case MV_PAR06=="S" //Semestral
		cQuery := " Select MES_ANO, D1_GRUPO, D1_COD, B1_DESC, Sum(QTDE) QTDE, Sum(QTDETRANSF) QTDETRANSF, Sum(QTDECOMPR) QTDECOMPR, "
		cQuery += " PRAZ_ENTREG, TIPO_PRAZ, QTD_EMB, PONTO_PEDIDO, EST_SEGURANCA, LOTE_ECON, LOTE_MINIMO from ( "
		cQuery += " Select '01|'+Substring(D1_DTDIGIT,1,4) MES_ANO, "
		cQuery += " D1_GRUPO, D1_COD, B1_DESC, Sum(D1_QUANT) QTDE, " //D1_FORNECE, A2_NOME, A2_MUN, A2_EST, "
		cQuery += " Case D1_FORNECE when '000148' then Sum(D1_QUANT) end QTDETRANSF, "
		cQuery += " Case D1_FORNECE when '000148' then 0 else Sum(D1_QUANT) end QTDECOMPR, "
		cQuery += " B1_PE PRAZ_ENTREG, B1_TIPE TIPO_PRAZ, B1_QE QTD_EMB, B1_EMIN PONTO_PEDIDO, "
		cQuery += " B1_ESTSEG EST_SEGURANCA, B1_LE LOTE_ECON, B1_LM LOTE_MINIMO " 
		cQuery += " from SD1010 SD1, SB1010 SB1, SF4010 SF4 "
		cQuery += " where SD1.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ = ' ' and SF4.D_E_L_E_T_ =' '  "
//		cQuery += " and F4_FILIAL = D1_FILIAL "  - Comentado por ter unificado as TES
		cQuery += " and B1_COD = D1_COD and D1_TES = F4_CODIGO " //and A2_COD = D1_FORNECE and A2_LOJA = D1_LOJA "
		cQuery += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND B1_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQuery += " AND Substring(D1_DTDIGIT,1,4) = '"+mv_par05+"' " 
		cQuery += " AND D1_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQuery += " AND F4_ESTOQUE = 'S' AND D1_QUANT > 0 " 
//		if mv_par07 <> mv_par08
//			cQuery += " AND F4_DUPLIC = 'S' "
//		endif
		cQuery += " AND Substring(D1_DTDIGIT,5,2) between '01' and '06' " 
		cQUery += " group by '01|'+Substring(D1_DTDIGIT,1,4), D1_GRUPO, D1_COD, B1_DESC, D1_FORNECE, "// A2_NOME, A2_MUN, A2_EST, "
		cQuery += " B1_PE, B1_TIPE, B1_QE, B1_EMIN, B1_ESTSEG, B1_LE, B1_LM " 

		cQuery += " UNION ALL " 
		
		cQuery += " Select '02|'+Substring(D1_DTDIGIT,1,4) MES_ANO, "
		cQuery += " D1_GRUPO, D1_COD, B1_DESC, Sum(D1_QUANT) QTDE, " // D1_FORNECE, A2_NOME, A2_MUN, A2_EST, "
		cQuery += " Case D1_FORNECE when '000148' then Sum(D1_QUANT) end QTDETRANSF, "
		cQuery += " Case D1_FORNECE when '000148' then 0 else Sum(D1_QUANT) end QTDECOMPR, "
		cQuery += " B1_PE PRAZ_ENTREG, B1_TIPE TIPO_PRAZ, B1_QE QTD_EMB, B1_EMIN PONTO_PEDIDO, "
		cQuery += " B1_ESTSEG EST_SEGURANCA, B1_LE LOTE_ECON, B1_LM LOTE_MINIMO " 
		cQuery += " from SD1010 SD1, SB1010 SB1, SF4010 SF4 "
		cQuery += " where SD1.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ = ' ' and SF4.D_E_L_E_T_ =' '  "
//		cQuery += " and F4_FILIAL = D1_FILIAL "  - Comentado por ter unificado as TES
		cQuery += " and B1_COD = D1_COD and D1_TES = F4_CODIGO " //and A2_COD = D1_FORNECE and A2_LOJA = D1_LOJA "
		cQuery += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND B1_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQuery += " AND Substring(D1_DTDIGIT,1,4) = '"+mv_par05+"' " 
		cQuery += " AND D1_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' " 
		cQuery += " AND F4_ESTOQUE = 'S' AND D1_QUANT > 0 " 
//		if mv_par07 <> mv_par08
//			cQuery += " AND F4_DUPLIC = 'S' "
//		endif
		cQuery += " AND Substring(D1_DTDIGIT,5,2) between '07' and '12' " 
		cQUery += " group by '02|'+Substring(D1_DTDIGIT,1,4), D1_GRUPO, D1_COD, B1_DESC, D1_FORNECE,  "//A2_NOME, A2_MUN, A2_EST, "
		cQuery += " B1_PE, B1_TIPE, B1_QE, B1_EMIN, B1_ESTSEG, B1_LE, B1_LM ) QRYSEM "
		cQuery += " group by MES_ANO, D1_GRUPO, D1_COD, B1_DESC, PRAZ_ENTREG, TIPO_PRAZ, QTD_EMB, PONTO_PEDIDO, EST_SEGURANCA, LOTE_ECON, LOTE_MINIMO "
		cQuery += " order by 1, 2 " 
		memowrite('e:\protheus11\arqSEM.txt', cQuery )
	Case MV_PAR06=="A" //Anual      
		cQuery := " Select MES_ANO, D1_GRUPO, D1_COD, B1_DESC, Sum(QTDE) QTDE, Sum(QTDETRANSF) QTDETRANSF, Sum(QTDECOMPR) QTDECOMPR, " 
		cQuery += " PRAZ_ENTREG, TIPO_PRAZ, QTD_EMB, PONTO_PEDIDO, EST_SEGURANCA, LOTE_ECON, LOTE_MINIMO from ( " 
		cQuery += " Select '|'+Substring(D1_DTDIGIT,1,4) MES_ANO, "
		cQuery += " D1_GRUPO, D1_COD, B1_DESC, Sum(D1_QUANT) QTDE, " // D1_FORNECE, A2_NOME, A2_MUN, A2_EST, "
		cQuery += " Case D1_FORNECE when '000148' then Sum(D1_QUANT) end QTDETRANSF, "
		cQuery += " Case D1_FORNECE when '000148' then 0 else Sum(D1_QUANT) end QTDECOMPR, "
		cQuery += " B1_PE PRAZ_ENTREG, B1_TIPE TIPO_PRAZ, B1_QE QTD_EMB, B1_EMIN PONTO_PEDIDO, "
		cQuery += " B1_ESTSEG EST_SEGURANCA, B1_LE LOTE_ECON, B1_LM LOTE_MINIMO " 
		cQuery += " from SD1010 SD1, SB1010 SB1, SF4010 SF4 "
		cQuery += " where SD1.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ = ' ' and SF4.D_E_L_E_T_ =' '  "
//		cQuery += " and F4_FILIAL = D1_FILIAL "  - Comentado por ter unificado as TES
		cQuery += " and B1_COD = D1_COD and D1_TES = F4_CODIGO " //and A2_COD = D1_FORNECE and A2_LOJA = D1_LOJA "
		cQuery += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND B1_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQuery += " AND Substring(D1_DTDIGIT,1,4) = '"+mv_par05+"' " 
		cQuery += " AND F4_ESTOQUE = 'S' AND D1_QUANT > 0 " 
//		if mv_par07 <> mv_par08
//			cQuery += " AND F4_DUPLIC = 'S' "
//		endif
		cQuery += " AND D1_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' " 
		cQUery += " group by '|'+Substring(D1_DTDIGIT,1,4), D1_GRUPO, D1_COD, B1_DESC, D1_FORNECE, " //A2_NOME, A2_MUN, A2_EST, "
		cQuery += " B1_PE, B1_TIPE, B1_QE, B1_EMIN, B1_ESTSEG, B1_LE, B1_LM ) QRYANO " 
		cQuery += " Group by MES_ANO, D1_GRUPO, D1_COD, B1_DESC, PRAZ_ENTREG, TIPO_PRAZ, QTD_EMB, PONTO_PEDIDO, EST_SEGURANCA, LOTE_ECON, LOTE_MINIMO " 
		cQuery += " order by 1, 2 " 

	OtherWise
		cPeriodo := "INCORRETO"
EndCase

if Select("TRBD3") > 0
	dbSelectArea("TRBD3")
	dbCloseArea()
endif

dbUseArea(.T., "TOPCONN", TCGenQry(, , cQuery), "TRBD3", .F., .T.)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FIM QUERY ENTRADA VIA NOTA FISCAL
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Query para calcular o consumo ocorrido em produÁ„o 
Do Case
	Case MV_PAR06=="M" //Mensal
		cQProducao := " Select Substring(D3_EMISSAO,5,2)+'/'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQProducao += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 "
		cQProducao += " where D_E_L_E_T_ =' ' " 
		cQProducao += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQProducao += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQProducao += " AND D3_OP <> '' and D3_CF in ('RE1','RE5') " 
		cQProducao += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQProducao += " GROUP BY Substring(D3_EMISSAO,5,2)+'/'+Substring(D3_EMISSAO,1,4), D3_COD " 
		cQProducao += " ORDER BY 1, 2 " 
	Case MV_PAR06=="T" //Trimestral
		cQProducao := " Select '01|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQProducao += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 "
		cQProducao += " where D_E_L_E_T_ =' ' " 
		cQProducao += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQProducao += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQProducao += " AND D3_OP <> '' and D3_CF In ('RE1','RE5') " 
		cQProducao += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQProducao += " AND Substring(D3_EMISSAO,5,2) between '01' and '03' " 
		cQProducao += " GROUP BY '01|'+Substring(D3_EMISSAO,1,4), D3_COD " 
		
		cQProducao += " UNION ALL "
		
		cQProducao += " Select '02|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQProducao += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 "
		cQProducao += " where D_E_L_E_T_ =' ' " 
		cQProducao += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQProducao += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQProducao += " AND D3_OP <> '' and D3_CF in ('RE1','RE5') " 
		cQProducao += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQProducao += " AND Substring(D3_EMISSAO,5,2) between '04' and '06' " 
		cQProducao += " GROUP BY '02|'+Substring(D3_EMISSAO,1,4), D3_COD " 
	
		cQProducao += " UNION ALL "
		
		cQProducao += " Select '03|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQProducao += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 "
		cQProducao += " where D_E_L_E_T_ =' ' " 
		cQProducao += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQProducao += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQProducao += " AND D3_OP <> '' and D3_CF in('RE1','RE5') " 
		cQProducao += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQProducao += " AND Substring(D3_EMISSAO,5,2) between '07' and '09' " 
		cQProducao += " GROUP BY '03|'+Substring(D3_EMISSAO,1,4), D3_COD " 
	
		cQProducao += " UNION ALL "
		
		cQProducao += " Select '04|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQProducao += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 "
		cQProducao += " where D_E_L_E_T_ =' ' " 
		cQProducao += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQProducao += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQProducao += " AND D3_OP <> '' and D3_CF In ('RE1','RE5') " 
		cQProducao += " AND Substring(D3_EMISSAO,5,2) between '10' and '12' " 
		cQProducao += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQProducao += " GROUP BY '04|'+Substring(D3_EMISSAO,1,4), D3_COD " 
		cQProducao += " ORDER BY 1, 2 " 
		
	Case MV_PAR06=="S" //Semestral

		cQProducao := " Select '01|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQProducao += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 "
		cQProducao += " where D_E_L_E_T_ =' ' " 
		cQProducao += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQProducao += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQProducao += " AND D3_OP <> '' and D3_CF in ('RE1','RE5') " 
		cQProducao += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQProducao += " AND Substring(D3_EMISSAO,5,2) between '01' and '06' " 
		cQProducao += " GROUP BY '01|'+Substring(D3_EMISSAO,1,4), D3_COD " 
		
		cQProducao += " UNION ALL "
		
		cQProducao += " Select '02|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQProducao += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 "
		cQProducao += " where D_E_L_E_T_ =' ' " 
		cQProducao += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQProducao += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQProducao += " AND D3_OP <> '' and D3_CF in ( 'RE1','RE5') " 
		cQProducao += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQProducao += " AND Substring(D3_EMISSAO,5,2) between '07' and '12' " 
		cQProducao += " GROUP BY '02|'+Substring(D3_EMISSAO,1,4), D3_COD " 
		cQProducao += " ORDER BY 1, 2 " 

	
	
	Case MV_PAR06=="A" //ANUAL
		cQProducao := " Select '|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQProducao += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 " 
		cQProducao += " where D_E_L_E_T_ =' ' " 
		cQProducao += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQProducao += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQProducao += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQProducao += " AND D3_OP <> '' and D3_CF in ('RE1','RE5') " 
		cQProducao += " GROUP BY '|'+Substring(D3_EMISSAO,1,4), D3_COD " 
		cQProducao += " ORDER BY 1, 2 " 


	otherwise
		Alert("ESCOLHA INVALIDA")
endcase

if Select("TRBPRD") > 0 
	dbSelectArea("TRBPRD")
	TRBPRD->(dbCloseArea())
endif

dbUseArea(.T.,"TOPCONN", tcGenQry(,, cQProducao), "TRBPRD", .T., .T.)
ProcRegua(0)
dbSelectArea("TRBPRD")
TRBPRD->(dbgotop())

public aProducao := {}  //Array contendo todo o consumo via producao do mes

while !TRBPRD->(eof())
	incProc("Gerando Consumo de Producao")
	AADD( aProducao, {TRBPRD->MES_ANO, TRBPRD->D3_COD, TRBPRD->D3_QUANT, .T.} )
	TRBPRD->(dbSkip())
enddo
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FIM QUERY CONSUMO EM PRODUCAO
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Query para calcular o consumo ocorrido fora do ambiente de producao e que nao foi transferido para outro cÛdigo
Do Case
	Case MV_PAR06=="M" //Mensal
		cQTMs := " Select Substring(D3_EMISSAO,5,2)+'/'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQTMs += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 "
		cQTMs += " where D_E_L_E_T_ =' ' " 
		cQTMs += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQTMs += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQTMs += " AND D3_OP = ''  and Substring(D3_CF,1,1) = 'R' and D3_CF not in ('RE4','RE7') " 
		cQTMs += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQTMs += " GROUP BY Substring(D3_EMISSAO,5,2)+'/'+Substring(D3_EMISSAO,1,4), D3_COD " 
		cQTMs += " ORDER BY 1, 2 " 
	Case MV_PAR06=="T" //Trimestral
		cQTMs := " Select '01|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQTMs += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 "
		cQTMs += " where D_E_L_E_T_ =' ' " 
		cQTMs += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQTMs += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQTMs += " AND D3_OP = ''  and Substring(D3_CF,1,1) = 'R' and D3_CF not in ('RE4','RE7') " 
		cQTMs += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQTMs += " AND Substring(D3_EMISSAO,5,2) between '01' and '03' " 
		cQTMs += " GROUP BY '01|'+Substring(D3_EMISSAO,1,4), D3_COD " 
		
		cQTMs += " UNION ALL "
		
		cQTMs += " Select '02|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQTMs += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010  "
		cQTMs += " where D_E_L_E_T_ =' ' " 
		cQTMs += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQTMs += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQTMs += " AND D3_OP = ''  and Substring(D3_CF,1,1) = 'R'  and D3_CF not in ('RE4','RE7') " 
		cQTMs += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQTMs += " AND Substring(D3_EMISSAO,5,2) between '04' and '06' " 
		cQTMs += " GROUP BY '02|'+Substring(D3_EMISSAO,1,4), D3_COD " 
	
		cQTMs += " UNION ALL "
		
		cQTMs += " Select '03|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQTMs += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 "
		cQTMs += " where D_E_L_E_T_ =' ' " 
		cQTMs += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQTMs += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQTMs += " AND D3_OP = ''  and Substring(D3_CF,1,1) = 'R' and D3_CF not in ('RE4','RE7') " 
		cQTMs += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQTMs += " AND Substring(D3_EMISSAO,5,2) between '07' and '09' " 
		cQTMs += " GROUP BY '03|'+Substring(D3_EMISSAO,1,4), D3_COD " 
	
		cQTMs += " UNION ALL "
		
		cQTMs += " Select '04|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQTMs += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 "
		cQTMs += " where D_E_L_E_T_ =' ' " 
		cQTMs += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQTMs += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQTMs += " AND D3_OP = ''  and Substring(D3_CF,1,1) = 'R' and D3_CF not in ('RE4','RE7') " 
		cQTMs += " AND Substring(D3_EMISSAO,5,2) between '10' and '12' " 
		cQTMs += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQTMs += " GROUP BY '04|'+Substring(D3_EMISSAO,1,4), D3_COD " 
		cQTMs += " ORDER BY 1, 2 " 
		
	Case MV_PAR06=="S" //Semestral

		cQTMs := " Select '01|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQTMs += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010   "
		cQTMs += " where D_E_L_E_T_ =' ' " 
		cQTMs += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQTMs += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQTMs += " AND D3_OP = ''  and Substring(D3_CF,1,1) = 'R' and D3_CF not in ('RE4','RE7') " 
		cQTMs += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQTMs += " AND Substring(D3_EMISSAO,5,2) between '01' and '06' " 
		cQTMs += " GROUP BY '01|'+Substring(D3_EMISSAO,1,4), D3_COD " 
		
		cQTMs += " UNION ALL "
		
		cQTMs += " Select '02|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQTMs += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010  "
		cQTMs += " where D_E_L_E_T_ =' ' " 
		cQTMs += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQTMs += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQTMs += " AND D3_OP = ''  and Substring(D3_CF,1,1) = 'R' and D3_CF not in ('RE4','RE7') " 
		cQTMs += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQTMs += " AND Substring(D3_EMISSAO,5,2) between '07' and '12' " 
		cQTMs += " GROUP BY '02|'+Substring(D3_EMISSAO,1,4), D3_COD " 
		cQTMs += " ORDER BY 1, 2 " 

	
	
	Case MV_PAR06=="A" //ANUAL
		cQTMs := " Select '|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQTMs += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 "
		cQTMs += " where D_E_L_E_T_ =' ' " 
		cQTMs += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQTMs += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQTMs += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQTMs += " AND D3_OP = ''  and Substring(D3_CF,1,1) = 'R' and D3_CF not in ('RE4','RE7') " 
		cQTMs += " GROUP BY '|'+Substring(D3_EMISSAO,1,4), D3_COD " 
		cQTMs += " ORDER BY 1, 2 " 


	otherwise
		Alert("ESCOLHA INVALIDA")
endcase

if Select("TRBTM") > 0 
	dbSelectArea("TRBTM")
	TRBTM->(dbCloseArea())
endif

dbUseArea(.T.,"TOPCONN", tcGenQry(,, cQTMs), "TRBTM", .T., .T.)
ProcRegua(0)
dbSelectArea("TRBTM")
TRBTM->(dbgotop())

public aTMs := {}  //Array contendo todo o consumo via producao do mes

while !TRBTM->(eof())
	incProc("Gerando Consumo por TM...")
	AADD( aTMs, {TRBTM->MES_ANO, TRBTM->D3_COD, TRBTM->D3_QUANT, .T.} )
	TRBTM->(dbSkip())
enddo
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FIM QUERY CONSUMO VIA TMs
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Query para calcular os pedidos em andamento
Do Case
	Case MV_PAR06=="M"
		cQPed := " Select Substring(C7_DATPRF,5,2)+'/'+Substring(C7_DATPRF,1,4) MES_ANO, C7_PRODUTO, Sum(C7_QUANT-C7_QUJE) QTDECOM  "
		cQPed += " from SC7010 SC7, SB1010 SB1 " 
		cQPed += " where SC7.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' "
		cQPed += " and C7_PRODUTO = B1_COD "
		cQPed += " and C7_ENCER <> 'E' and C7_CONAPRO = 'L' and C7_RESIDUO <> 'S' "
		cQPed += " and C7_QUANT - C7_QUJE > 0 " 
		cQPed += " AND C7_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQPed += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND C7_PRODUTO between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQPed += " AND Substring(C7_DATPRF,1,4) = '"+mv_par05+"' " 
		cQPed += " group by Substring(C7_DATPRF,5,2)+'/'+Substring(C7_DATPRF,1,4), C7_PRODUTO " 
		cQPed += " order by 1, 2 " 
	Case MV_PAR06=="T"
		cQPed := " Select '01|'+Substring(C7_DATPRF,1,4) MES_ANO, C7_PRODUTO, Sum(C7_QUANT-C7_QUJE) QTDECOM  "
		cQPed += " from SC7010 SC7, SB1010 SB1 " 
		cQPed += " where SC7.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' "
		cQPed += " and C7_PRODUTO = B1_COD "
		cQPed += " and C7_ENCER <> 'E' and C7_CONAPRO = 'L' and C7_RESIDUO <> 'S' "
		cQPed += " and C7_QUANT - C7_QUJE > 0 " 
		cQPed += " AND C7_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQPed += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND C7_PRODUTO between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQPed += " AND Substring(C7_DATPRF,1,4) = '"+mv_par05+"' " 
		cQPed += " AND Substring(C7_DATPRF,5,2) between '01' and '03' " 
		cQPed += " group by '01|'+Substring(C7_DATPRF,1,4), C7_PRODUTO " 
		cQPed += " order by 1, 2 " 
		
		cQPed += " UNION ALL " 

		cQPed := " Select '02|'+Substring(C7_DATPRF,1,4) MES_ANO, C7_PRODUTO, Sum(C7_QUANT-C7_QUJE) QTDECOM  "
		cQPed += " from SC7010 SC7, SB1010 SB1 " 
		cQPed += " where SC7.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' "
		cQPed += " and C7_PRODUTO = B1_COD "
		cQPed += " and C7_ENCER <> 'E' and C7_CONAPRO = 'L' and C7_RESIDUO <> 'S' "
		cQPed += " and C7_QUANT - C7_QUJE > 0 " 
		cQPed += " AND C7_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQPed += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND C7_PRODUTO between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQPed += " AND Substring(C7_DATPRF,1,4) = '"+mv_par05+"' " 
		cQPed += " AND Substring(C7_DATPRF,5,2) between '04' and '06' " 
		cQPed += " group by '02|'+Substring(C7_DATPRF,1,4), C7_PRODUTO " 
		cQPed += " order by 1, 2 " 
		
		cQPed += " UNION ALL " 

		cQPed := " Select '03|'+Substring(C7_DATPRF,1,4) MES_ANO, C7_PRODUTO, Sum(C7_QUANT-C7_QUJE) QTDECOM  "
		cQPed += " from SC7010 SC7, SB1010 SB1 " 
		cQPed += " where SC7.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' "
		cQPed += " and C7_PRODUTO = B1_COD "
		cQPed += " and C7_ENCER <> 'E' and C7_CONAPRO = 'L' and C7_RESIDUO <> 'S' "
		cQPed += " and C7_QUANT - C7_QUJE > 0 " 
		cQPed += " AND C7_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQPed += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND C7_PRODUTO between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQPed += " AND Substring(C7_DATPRF,1,4) = '"+mv_par05+"' " 
		cQPed += " AND Substring(C7_DATPRF,5,2) between '07' and '09' " 
		cQPed += " group by '03|'+Substring(C7_DATPRF,1,4), C7_PRODUTO " 
		cQPed += " order by 1, 2 " 
		
		cQPed += " UNION ALL " 

		cQPed := " Select '04|'+Substring(C7_DATPRF,1,4) MES_ANO, C7_PRODUTO, Sum(C7_QUANT-C7_QUJE) QTDECOM  "
		cQPed += " from SC7010 SC7, SB1010 SB1 " 
		cQPed += " where SC7.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' "
		cQPed += " and C7_PRODUTO = B1_COD "
		cQPed += " and C7_ENCER <> 'E' and C7_CONAPRO = 'L' and C7_RESIDUO <> 'S' "
		cQPed += " and C7_QUANT - C7_QUJE > 0 " 
		cQPed += " AND C7_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQPed += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND C7_PRODUTO between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQPed += " AND Substring(C7_DATPRF,1,4) = '"+mv_par05+"' " 
		cQPed += " AND Substring(C7_DATPRF,5,2) between '10' and '12' " 
		cQPed += " group by '04|'+Substring(C7_DATPRF,1,4), C7_PRODUTO " 
		cQPed += " order by 1, 2 " 
	CASE MV_PAR06=="S"
		cQPed := " Select '01|'+Substring(C7_DATPRF,1,4) MES_ANO, C7_PRODUTO, Sum(C7_QUANT-C7_QUJE) QTDECOM  "
		cQPed += " from SC7010 SC7, SB1010 SB1 " 
		cQPed += " where SC7.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' "
		cQPed += " and C7_PRODUTO = B1_COD "
		cQPed += " and C7_ENCER <> 'E' and C7_CONAPRO = 'L' and C7_RESIDUO <> 'S' "
		cQPed += " and C7_QUANT - C7_QUJE > 0 " 
		cQPed += " AND C7_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQPed += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND C7_PRODUTO between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQPed += " AND Substring(C7_DATPRF,1,4) = '"+mv_par05+"' " 
		cQPed += " AND Substring(C7_DATPRF,5,2) between '01' and '06' " 
		cQPed += " group by '01|'+Substring(C7_DATPRF,1,4), C7_PRODUTO " 
		cQPed += " order by 1, 2 " 
		
		cQPed += " UNION ALL " 

		cQPed := " Select '02|'+Substring(C7_DATPRF,1,4) MES_ANO, C7_PRODUTO, Sum(C7_QUANT-C7_QUJE) QTDECOM  "
		cQPed += " from SC7010 SC7, SB1010 SB1 " 
		cQPed += " where SC7.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' "
		cQPed += " and C7_PRODUTO = B1_COD "
		cQPed += " and C7_ENCER <> 'E' and C7_CONAPRO = 'L' and C7_RESIDUO <> 'S' "
		cQPed += " and C7_QUANT - C7_QUJE > 0 " 
		cQPed += " AND C7_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQPed += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND C7_PRODUTO between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQPed += " AND Substring(C7_DATPRF,1,4) = '"+mv_par05+"' " 
		cQPed += " AND Substring(C7_DATPRF,5,2) between '07' and '12' " 
		cQPed += " group by '02|'+Substring(C7_DATPRF,1,4), C7_PRODUTO " 
		cQPed += " order by 1, 2 " 
	CASE MV_PAR06=="A"
		cQPed := " Select '|'+Substring(C7_DATPRF,1,4) MES_ANO, C7_PRODUTO, Sum(C7_QUANT-C7_QUJE) QTDECOM "
		cQPed += " from SC7010 SC7, SB1010 SB1 " 
		cQPed += " where SC7.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' "
		cQPed += " and C7_PRODUTO = B1_COD "
		cQPed += " and C7_ENCER <> 'E' and C7_CONAPRO = 'L' and C7_RESIDUO <> 'S' "
		cQPed += " and C7_QUANT - C7_QUJE > 0 " 
		cQPed += " AND C7_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQPed += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND C7_PRODUTO between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQPed += " AND Substring(C7_DATPRF,1,4) = '"+mv_par05+"' " 
		cQPed += " group by '|'+Substring(C7_DATPRF,1,4), C7_PRODUTO " 
		cQPed += " order by 1, 2 " 
	OtherWise
		Alert("ESCOLHA ERRADA")
EndCase

if Select("TRBCOM") > 0 
	dbSelectArea("TRBCOM")
	TRBCOM->(dbCloseArea())
endif

dbUseArea(.T.,"TOPCONN", tcGenQry(,, cQPed), "TRBCOM", .T., .T.)
ProcRegua(0)
dbSelectArea("TRBCOM")
TRBCOM->(dbgotop())

public aCompras := {}  //Array contendo todo o consumo via producao do mes

while !TRBCOM->(eof())
	incProc("Processando Pedido de Compras....")
	AADD( aCompras, {TRBCOM->MES_ANO, TRBCOM->C7_PRODUTO, TRBCOM->QTDECOM, .T.} )
	TRBCOM->(dbSkip())
enddo
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FIM QUERY ANALISE DE COMPRAS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Query para calcular o consumo ocorrido via transferencia e desmontagem
Do Case
	Case MV_PAR06=="M" //Mensal
		cQTransf := " Select Substring(D3_EMISSAO,5,2)+'/'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQTransf += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 "
		cQTransf += " where D_E_L_E_T_ =' ' " 
		cQTransf += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQTransf += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQTransf += " AND D3_OP = ''  and Substring(D3_CF,1,1) = 'R' and D3_CF in ('RE4','RE7') " 
		cQTransf += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQTransf += " GROUP BY Substring(D3_EMISSAO,5,2)+'/'+Substring(D3_EMISSAO,1,4), D3_COD " 
		cQTransf += " ORDER BY 1, 2 " 
	Case MV_PAR06=="T" //Trimestral
		cQTransf := " Select '01|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQTransf += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010  "
		cQTransf += " where D_E_L_E_T_ =' ' " 
		cQTransf += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQTransf += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQTransf += " AND D3_OP = '' and D3_CF   in ('RE4','RE7') " 
		cQTransf += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQTransf += " AND Substring(D3_EMISSAO,5,2) between '01' and '03' " 
		cQTransf += " GROUP BY '01|'+Substring(D3_EMISSAO,1,4), D3_COD " 
		
		cQTransf += " UNION ALL "
		
		cQTransf += " Select '02|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQTransf += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 "
		cQTransf += " where D_E_L_E_T_ =' ' " 
		cQTransf += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQTransf += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQTransf += " AND D3_OP = '' and D3_CF   in ('RE4','RE7') " 
		cQTransf += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQTransf += " AND Substring(D3_EMISSAO,5,2) between '04' and '06' " 
		cQTransf += " GROUP BY '02|'+Substring(D3_EMISSAO,1,4), D3_COD " 
	
		cQTransf += " UNION ALL "
		
		cQTransf += " Select '03|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQTransf += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 " 
		cQTransf += " where D_E_L_E_T_ =' ' " 
		cQTransf += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQTransf += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQTransf += " AND D3_OP = '' and D3_CF   in ('RE4','RE7') " 
		cQTransf += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQTransf += " AND Substring(D3_EMISSAO,5,2) between '07' and '09' " 
		cQTransf += " GROUP BY '03|'+Substring(D3_EMISSAO,1,4), D3_COD " 
	
		cQTransf += " UNION ALL "
		
		cQTransf += " Select '04|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQTransf += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010  "
		cQTransf += " where D_E_L_E_T_ =' ' " 
		cQTransf += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQTransf += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQTransf += " AND D3_OP = '' and D3_CF   in ('RE4','RE7') " 
		cQTransf += " AND Substring(D3_EMISSAO,5,2) between '10' and '12' " 
		cQTransf += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQTransf += " GROUP BY '04|'+Substring(D3_EMISSAO,1,4), D3_COD " 
		cQTransf += " ORDER BY 1, 2 " 
		
	Case MV_PAR06=="S" //Semestral

		cQTransf := " Select '01|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQTransf += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 "
		cQTransf += " where D_E_L_E_T_ =' ' " 
		cQTransf += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQTransf += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQTransf += " AND D3_OP = '' and D3_CF   in ('RE4','RE7') " 
		cQTransf += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQTransf += " AND Substring(D3_EMISSAO,5,2) between '01' and '06' " 
		cQTransf += " GROUP BY '01|'+Substring(D3_EMISSAO,1,4), D3_COD " 
		
		cQTransf += " UNION ALL "
		
		cQTransf += " Select '02|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQTransf += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010  "
		cQTransf += " where D_E_L_E_T_ =' ' " 
		cQTransf += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQTransf += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQTransf += " AND D3_OP = '' and D3_CF   in ('RE4','RE7') " 
		cQTransf += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQTransf += " AND Substring(D3_EMISSAO,5,2) between '07' and '12' " 
		cQTransf += " GROUP BY '02|'+Substring(D3_EMISSAO,1,4), D3_COD " 
		cQTransf += " ORDER BY 1, 2 " 

	
	
	Case MV_PAR06=="A" //ANUAL
		cQTransf := " Select '|'+Substring(D3_EMISSAO,1,4) MES_ANO, "
		cQTransf += " D3_COD, Sum(D3_QUANT) D3_QUANT from SD3010 " 
		cQTransf += " where D_E_L_E_T_ =' ' " 
		cQTransf += " AND D3_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND D3_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
		cQTransf += " AND Substring(D3_EMISSAO,1,4) = '"+mv_par05+"' " 
		cQTransf += " AND D3_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
		cQTransf += " AND D3_OP = '' and D3_CF   in ('RE4','RE7') " 
		cQTransf += " GROUP BY '|'+Substring(D3_EMISSAO,1,4), D3_COD " 
		cQTransf += " ORDER BY 1, 2 " 


	otherwise
		Alert("ESCOLHA INVALIDA")
endcase

if Select("TRBTR") > 0 
	dbSelectArea("TRBTR")
	TRBTR->(dbCloseArea())
endif

dbUseArea(.T.,"TOPCONN", tcGenQry(,, cQTransf), "TRBTR", .T., .T.)
ProcRegua(0)
dbSelectArea("TRBTR")
TRBTR->(dbgotop())

public aTrans := {}  //Array contendo todo o consumo via producao do mes

while !TRBTR->(eof())
	incProc("Processando Transferencias Internas....")
	AADD( aTrans, {TRBTR->MES_ANO, TRBTR->D3_COD, TRBTR->D3_QUANT, .T.} )
	TRBTR->(dbSkip())
enddo
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FIM QUERY CONSUMO VIA TRANSFERENCIA E DESMONTAGEM
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Query para calcular o saldo do fechamento de estoque mes a mes....
//Busca Saldo do Ano Anterior........
cAnoAnt := cValToChar(Val(MV_PAR05) - 1)
cQSB9 := " Select Substring(B9_DATA,5,2)+'/'+Substring(B9_DATA,1,4) MES_ANO, B1_GRUPO, B9_COD, Sum(B9_QINI) B9_QINI "
cQSB9 += " from SB9010 SB9, SB1010 SB1 " 
cQSB9 += " where SB9.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' "
cQSB9 += " and B1_COD = B9_COD "
cQSB9 += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND B1_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
cQSB9 += " AND Substring(B9_DATA,1,6) = '"+cAnoAnt+"12' " 
cQSB9 += " AND B9_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
cQSB9 += " group by Substring(B9_DATA,5,2)+'/'+Substring(B9_DATA,1,4), B1_GRUPO, B9_COD "
cQSB9 += " order by 1, 2 "

if Select("TRBB9") > 0 
	dbSelectArea("TRBB9")
	TRBB9->(dbCloseArea())
endif

dbUseArea(.T.,"TOPCONN", tcGenQry(,, cQSB9), "TRBB9", .T., .T.)
ProcRegua(0)
dbSelectArea("TRBB9")
TRBB9->(dbgotop())

public aEstoque := {}  //Array contendo todo o consumo via producao do mes

while !TRBB9->(eof())
	incProc("Processando Fechamento Ano Anterior...")
	//                     01            02        03 04 05 06 07 08 09  10 11 12 13 14  15      16				   17
	AADD( aEstoque, {TRBB9->B9_COD, TRBB9->B9_QINI, 0, 0, 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0, .T., TRBB9->MES_ANO, TRBB9->B1_GRUPO} )
	TRBB9->(dbSkip())
enddo


//Busca Saldo mes a mes do ano solicitado....
cQSB9 := " Select Substring(B9_DATA,5,2)+'/'+Substring(B9_DATA,1,4) MES_ANO, B9_COD, B1_GRUPO, Sum(B9_QINI) B9_QINI "
cQSB9 += " from SB9010 SB9, SB1010 SB1 " 
cQSB9 += " where SB9.D_E_L_E_T_ =' ' and SB1.D_E_L_E_T_ =' ' "
cQSB9 += " and B1_COD = B9_COD "
cQSB9 += " AND B1_GRUPO between '"+mv_par01+"' and '"+mv_par02+"' AND B1_COD between '"+mv_par03+"' and '"+mv_par04+"' " 
cQSB9 += " AND Substring(B9_DATA,1,4) = '"+mv_par05+"' " 
cQSB9 += " AND B9_FILIAL between '"+mv_par07+"' AND '"+mv_par08+"' "
cQSB9 += " group by Substring(B9_DATA,5,2)+'/'+Substring(B9_DATA,1,4), B9_COD, B1_GRUPO "
cQSB9 += " order by 1, 2 "

if Select("TRBB9") > 0 
	dbSelectArea("TRBB9")
	TRBB9->(dbCloseArea())
endif

//Rotina para adicionar o fechamento de estoque mes a mes por produto....
dbUseArea(.T.,"TOPCONN", tcGenQry(,, cQSB9), "TRBB9", .T., .T.)
ProcRegua(0)
dbSelectArea("TRBB9")
TRBB9->(dbgotop())
while !TRBB9->(eof())
	IncProc("Processando Fechamentos de Estoques...")
	nPos := aScan( aEstoque, {|x| x[1] == TRBB9->B9_COD })
	if nPos > 0 
		Do Case 
		    Case Substr(TRBB9->MES_ANO,1,2) == '01'
		    	aEstoque[nPos][3] := TRBB9->B9_QINI
		    Case Substr(TRBB9->MES_ANO,1,2) == '02'
		    	aEstoque[nPos][4] := TRBB9->B9_QINI		    
		    Case Substr(TRBB9->MES_ANO,1,2) == '03'
		    	aEstoque[nPos][5] := TRBB9->B9_QINI		    
		    Case Substr(TRBB9->MES_ANO,1,2) == '04'
		    	aEstoque[nPos][6] := TRBB9->B9_QINI		    
		    Case Substr(TRBB9->MES_ANO,1,2) == '05'
		    	aEstoque[nPos][7] := TRBB9->B9_QINI		    
		    Case Substr(TRBB9->MES_ANO,1,2) == '06'
		    	aEstoque[nPos][8] := TRBB9->B9_QINI		    
		    Case Substr(TRBB9->MES_ANO,1,2) == '07'
		    	aEstoque[nPos][9] := TRBB9->B9_QINI		    
		    Case Substr(TRBB9->MES_ANO,1,2) == '08'
		    	aEstoque[nPos][10] := TRBB9->B9_QINI		    
		    Case Substr(TRBB9->MES_ANO,1,2) == '09'
		    	aEstoque[nPos][11] := TRBB9->B9_QINI		    
		    Case Substr(TRBB9->MES_ANO,1,2) == '10'
		    	aEstoque[nPos][12] := TRBB9->B9_QINI		    
		    Case Substr(TRBB9->MES_ANO,1,2) == '11'
		    	aEstoque[nPos][13] := TRBB9->B9_QINI		    
		    Case Substr(TRBB9->MES_ANO,1,2) == '12'
		    	aEstoque[nPos][14] := TRBB9->B9_QINI		    
		    otherwise
				Alert("NAO IDENTIFICADO")    
		EndCase
	else
		Do Case 
		    Case Substr(TRBB9->MES_ANO,1,2) == '01'
			   //                     01       02      03        04 05 06 07 08 09  10 11 12 13 14  15         16            17
				AADD( aEstoque, {TRBB9->B9_COD, 0,TRBB9->B9_QINI, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0,0, .T., TRBB9->MES_ANO, TRBB9->B1_GRUPO} )
		    Case Substr(TRBB9->MES_ANO,1,2) == '02'
				AADD( aEstoque, {TRBB9->B9_COD, 0,0, TRBB9->B9_QINI,0,0,0,0,0,0,0,0,0,0, .T., TRBB9->MES_ANO, TRBB9->B1_GRUPO} )
		    Case Substr(TRBB9->MES_ANO,1,2) == '03'
				AADD( aEstoque, {TRBB9->B9_COD, 0,0,0, TRBB9->B9_QINI,0,0,0,0,0,0,0,0,0, .T., TRBB9->MES_ANO, TRBB9->B1_GRUPO} )
		    Case Substr(TRBB9->MES_ANO,1,2) == '04'
				AADD( aEstoque, {TRBB9->B9_COD, 0,0,0,0, TRBB9->B9_QINI,0,0,0,0,0,0,0,0, .T., TRBB9->MES_ANO, TRBB9->B1_GRUPO} )
		    Case Substr(TRBB9->MES_ANO,1,2) == '05'
				AADD( aEstoque, {TRBB9->B9_COD, 0,0,0,0,0, TRBB9->B9_QINI,0,0,0,0,0,0,0, .T., TRBB9->MES_ANO, TRBB9->B1_GRUPO} )
		    Case Substr(TRBB9->MES_ANO,1,2) == '06'
				AADD( aEstoque, {TRBB9->B9_COD, 0,0,0,0,0,0, TRBB9->B9_QINI,0,0,0,0,0,0, .T., TRBB9->MES_ANO, TRBB9->B1_GRUPO} )
		    Case Substr(TRBB9->MES_ANO,1,2) == '07'
				AADD( aEstoque, {TRBB9->B9_COD, 0,0,0,0,0,0,0, TRBB9->B9_QINI,0,0,0,0,0, .T., TRBB9->MES_ANO, TRBB9->B1_GRUPO} )
		    Case Substr(TRBB9->MES_ANO,1,2) == '08'
				AADD( aEstoque, {TRBB9->B9_COD, 0,0,0,0,0,0,0,0, TRBB9->B9_QINI,0,0,0,0, .T., TRBB9->MES_ANO, TRBB9->B1_GRUPO} )
		    Case Substr(TRBB9->MES_ANO,1,2) == '09'
				AADD( aEstoque, {TRBB9->B9_COD, 0,0,0,0,0,0,0,0,0, TRBB9->B9_QINI,0,0,0, .T., TRBB9->MES_ANO, TRBB9->B1_GRUPO} )
		    Case Substr(TRBB9->MES_ANO,1,2) == '10'
				AADD( aEstoque, {TRBB9->B9_COD, 0,0,0,0,0,0,0,0,0,0, TRBB9->B9_QINI,0,0, .T., TRBB9->MES_ANO, TRBB9->B1_GRUPO} )
		    Case Substr(TRBB9->MES_ANO,1,2) == '11'
				AADD( aEstoque, {TRBB9->B9_COD, 0,0,0,0,0,0,0,0,0,0,0, TRBB9->B9_QINI,0, .T., TRBB9->MES_ANO, TRBB9->B1_GRUPO} )
		    Case Substr(TRBB9->MES_ANO,1,2) == '12'
				AADD( aEstoque, {TRBB9->B9_COD, 0,0,0,0,0,0,0,0,0,0,0,0, TRBB9->B9_QINI, .T., TRBB9->MES_ANO, TRBB9->B1_GRUPO} )
		    otherwise
				Alert("NAO IDENTIFICADO")    
		EndCase
	endif
	TRBB9->(dbSkip())
enddo
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FIM QUERY FECHAMENTO DE ESTOQUE
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

return