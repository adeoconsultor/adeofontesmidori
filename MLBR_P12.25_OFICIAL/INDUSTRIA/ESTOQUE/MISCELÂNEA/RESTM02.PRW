#include "rwmake.ch"    
/*/
@---------------------------------------------------------------------------@
| Programa  | RESTM02  | Autor|Rogerio Batista         | Data |05.08.2010   |
@---------------------------------------------------------------------------@
| Descricao | Programa para atualizar os campos de grupos nos movimentos,   |
|           | com base no cadastro do produto, pois muitos produtos sofrerão|
|           | alterações nos grupos.                                        |
|           |                                                               |
@---------------------------------------------------------------------------@
| Uso       | Especifico - Midori Atlantica                                 |
@---------------------------------------------------------------------------@
/*/


User Function RESTM02()              

        If !MsgBox("Esta  rotina  ira' atualizar o grupo do produto nos movimentos, conforme )"+Chr(13);
                  +"o cadastro do produto","Atualizacao dos grupos de produtos","YesNo")
           Return 
        EndIf
        
        Processa({|| _TrocaAll()},"Atualiza campo de grupo de produtos nos movimentos de estoques.")

Return()



Static Function _TrocaAll()

dbSelectArea("SB1")
dbSetOrder(1)                          // filial + produto
dbGotop()
ProcRegua(RecCount())

While !Eof()
	
	_cCodigo := SB1->B1_COD         
		
	IncProc("SB1 - Produto: "+_cCodigo+" ")
	           
	
    dbSelectArea("SD1")
    dbSetOrder(5)           //Produto+Armazem
	dbSeek(xFilial("SD1")+_cCodigo)
	While !Eof().and. SD1->D1_COD == _cCodigo
	
		RecLock("SD1",.F.)
	     SD1->D1_GRUPO  := SB1->B1_GRUPO
	    MsUnlock()
	      
	 dbSkip()    
	EndDo        
	
	dbSelectArea("SD2")
    dbSetOrder(1)           //Produto+Armazem
	dbSeek(xFilial("SD2")+_cCodigo)
	While !Eof() .and. D2_COD == _cCodigo
	
		RecLock("SD2",.F.)
	     SD2->D2_GRUPO  := SB1->B1_GRUPO
	    MsUnlock()
	      
	 dbSkip()    
	EndDo  
	
	dbSelectArea("SD3")
    dbSetOrder(3)           //Produto+Armazem
    dbSeek(xFilial("SD3")+_cCodigo)
	While !Eof() .and. D3_COD == _cCodigo
	
		RecLock("SD3",.F.)
	     SD3->D3_GRUPO  := SB1->B1_GRUPO
	    MsUnlock()
	      
	 dbSkip()    
	EndDo            
	
	dbSelectArea("SB1")
	dbSkip()
EndDo
                   
Return()
                          

