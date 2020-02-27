#Include "PROTHEUS.Ch" 

/*
----------------------------------------------------------------------------------------
Funcao: MT110END														Data: 29.10.2010
Autor : WILLER TRINDADE
----------------------------------------------------------------------------------------
Objetivo: PONTO DE ENTRADA PARA GRAVAR DATA ALTERAÇÃO SC CONFORME SOLICITADO HDI 001872 
----------------------------------------------------------------------------------------
Manutencao: Vinicius S Schwartz - TI Midori Atlantica 					Data: 12.07.2012
Motivo: Gravar tambem a hora da aprovacao
--------------------------------------------------------------------------------------*/
User Function MT110END 

Local cProPE 
Local cNumSC := SC1->C1_NUM

dbSelectArea("SC1")    
dbSetOrder(1)
dbSeek( xFilial("SC1") + cNumSC )         

 

While SC1->C1_NUM == cNumSC
	
	cProPE := POSICIONE("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO,'B1_PE')  
   	
	Reclock("SC1", .F.)
	SC1->C1_APROV := 'L'
	SC1->C1_DTAPROV := Date()
	SC1->C1_X_HRAPR := Time()
	SC1->C1_X_CDAPR := RetCodUsr()   
	If SC1->C1_DATPRF < Date()+cProPE
		SC1->C1_DATPRF := Date()+cProPE          
	Endif         	           
	Msunlock("SC1") 
	
	SC1->(dbSkip())    
Enddo
 