#INCLUDE "rwmake.ch"
/*
-------------------------------------------------------------------------
Programa : RFINA01		   		Data     : 27.08.08				
-------------------------------------------------------------------------		   	
Descricao: Visualizar borderos que devem ser enviados ao banco atraves da 
	   geracao de arquivo de remessa tipo Cnab, com objetivo de faci-
	   litar o processo quando os boletos forem impressos pela rotina
	   RFINR00, que gera borderos automaticamente
-------------------------------------------------------------------------		   	
Autor    : Gildesio Campos
-------------------------------------------------------------------------		   	
*/
User Function RFinA01()
Local cFiltro,bFilBrw,aIndices 
Local aCores := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Borderos de Cobranca - Gerar Arquivo de Envio"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
		             {"Visualizar","AxVisual",0,2},;
       				 {"Legenda"   ,"U_RFinA01L",0,2}}

//		             {"Gerar Arq.Envio","FINA150",0,1},; 
Aadd(aCores,{"EA_TRANSF $ 'SX'","DISABLE"})  	//Arquivo Cnab nao Gerado
Aadd(aCores,{"EA_TRANSF == 'N'","ENABLE"})		//Arquivo Cnab Gerado

dbSelectArea("SEA")
dbSetOrder(1)

mBrowse(6,1,22,75,"SEA",,"EA_TRANSF",,,,aCores)

Return               
/*
-------------------------------------------------------------------------
Programa : RFinA01L	   				   			     			
Descricao: Legenda
-------------------------------------------------------------------------		   	
Autor    : Gildesio Campos 
Data     : 22.06.06
-------------------------------------------------------------------------		   	
*/
User Function RFinA01L()   
Local aCorDesc 

aCorDesc := {{"ENABLE","Gerar Arquivo Cnab"},;   	//Arquivo Cnab nao Gerado
			 {"DISABLE","Arquivo Cnab Gerado"}}			//Arquivo Cnab Gerado

BrwLegenda( "Arquivos Cnab", "Legenda", aCorDesc )
Return
