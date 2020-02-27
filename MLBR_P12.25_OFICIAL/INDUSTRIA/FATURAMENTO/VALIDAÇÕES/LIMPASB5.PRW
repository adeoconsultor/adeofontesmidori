//Eliminar todos os espacos em branco no campo descricao do cadastro de produto - Claudinei E N
//Alterado por Humberto Garcia em 01/12/2009, pois na primeira versao o posicionamento nao corrigiu os produtos


user function LIMPASB5()
	aAreaSB5 := GetArea()
	Processa({|lEnd| EXECLIMPASB5(.T., .T.), "Por favor aguarde..."})
	RestArea(aAreaSB5)
return


static function EXECLIMPASB5()

Local nCont	
aAreaSB5		:= GetArea()
cDescProd 		:= ""                         
cDescB5Atu  	:= ""
                                             
dbselectArea("SB5")
dbSetOrder(1)
ProcRegua(SB5->(RecCount("SB5")))
SB5->(dbGoTop())
	
While SB5->(!Eof()) 

     xProduto := aLLTRIM(SB5->B5_COD)+"-"+alltrim(SB5->B5_CEME)
    
     IncProc("Produto: "+xProduto)
	 cDescProd := AllTrim(SB5->B5_CEME)
	     
         For nCont := 1 TO LEN(cDescProd)
	    	  //IF(VALTYPE(SUBSTR(cDESCPROD,nCONT,1))<>"N" .AND. VALTYPE(SUBSTR(cDESCPROD,nCONT,1)))<>"A" 	       
       	      //SUBSTR(cDESCPROD,nCONT,1):= SPACE(1)
       	      If(Substr(cDescProd,nCont,1))$"!#$%&()*+,-/[\]:;<=>?@{|}.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ "
       	         cDescB5Atu +=Substr(cDescProd,nCont,1)
      	      ENDIF  
	     Next

	       
   	  RecLock("SB5",.F.)
   	  SB5->B5_CEME := ALLTRIM(cDescB5Atu)
   	  MsUnLock() 
	  cDescB5Atu := ""	                  
	  SB5->(dbSkip()) 
   
EndDo
RestArea(aAreaSB5)
return()