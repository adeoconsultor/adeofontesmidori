//Eliminar todos os espacos em branco no campo descricao do cadastro de produto - Claudinei E N
//Alterado por Humberto Garcia em 01/12/2009, pois na primeira versao o posicionamento nao corrigiu os produtos


user function LIMPASB1()
	aAreaSB1 := GetArea()
	Processa({|lEnd| EXECLIMPASB1(.T., .T.), "Por favor aguarde..."})
	RestArea(aAreaSB1)
return


static function EXECLIMPASB1()

Local nCont	
aAreaSB1		:= GetArea()
cDescProd 		:= ""                         
cDescB1Atu  	:= ""
                                             
dbselectArea("SB1")
dbSetOrder(1)
ProcRegua(SB1->(RecCount("SB1")))
SB1->(dbGoTop())
	
While SB1->(!Eof()) 

     xProduto := aLLTRIM(SB1->B1_COD)+"-"+alltrim(SB1->B1_DESC)
    
     IncProc("Produto: "+xProduto)
	 cDescProd := AllTrim(SB1->B1_DESC)
	     
         For nCont := 1 TO LEN(cDescProd)
	    	  //IF(VALTYPE(SUBSTR(cDESCPROD,nCONT,1))<>"N" .AND. VALTYPE(SUBSTR(cDESCPROD,nCONT,1)))<>"A" 	       
       	      //SUBSTR(cDESCPROD,nCONT,1):= SPACE(1)
       	      If(Substr(cDescProd,nCont,1))$"!#$%&()*+,-/[\]:;<=>?@{|}.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ "
       	         cDescB1Atu +=Substr(cDescProd,nCont,1)
      	      ENDIF  
	     Next

	       
   	  RecLock("SB1",.F.)
   	  SB1->B1_DESC := ALLTRIM(cDescB1Atu)
   	  MsUnLock() 
	  cDescB1Atu := ""	                  
	  SB1->(dbSkip()) 
   
EndDo
             
RestArea(aAreaSB1)
return()