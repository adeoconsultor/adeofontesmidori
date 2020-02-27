#INCLUDE "Average.ch"

//+-----------------------------------------------------------------------------------//
//|Empresa...: Midori Atlantica
//|Funcao....: U_EICGI400()
//|Autor.....: Robson Luiz Sanchez Dias 
//|Data......: 06 de Julho de 2009
//|Uso.......: SIGAEIC   
//|Versao....: Protheus - 10.1    
//|Descricao.: Contem todos pontos de entradas do EICGI400 e funcoes para tratamento da LI de Importacao
//|Observação: 
//------------------------------------------------------------------------------------//

*-----------------------------*
User Function EICGI400()
*-----------------------------*         
                
If type("lManuLi") == "U" 
  Return .t.
Endif

/*
If ! lManuLi
   Return .t.
Endif
*/
DO CASE         

   Case ParamIxb == "WORK"
        AADD(Struct1,{"WKATOCONC" ,"C", AVSX3("W5_ATO_CON",3),0})
        AADD(Struct1,{"WKSEQAC"   ,"C", AVSX3("W5_SEQAC",3),0})
                          
   Case ParamIxb == "STRU"
        AADD(aDBF_Stru,{"WKATOCONC" ,"C", AVSX3("W5_ATO_CON",3),0})
        AADD(aDBF_Stru,{"WKSEQAC"   ,"C", AVSX3("W5_SEQAC",3),0})
   
   Case ParamIxb == "APROPRIAAC" .or. ParamIxb == "BROWSE"
        AADD(aCampos,{"WKATOCONC"   ,"","Nr.AC",AVSX3("W5_ATO_CON",6)}) 
        AADD(aCampos,{"WKSEQAC"     ,"","Item AC",AVSX3("W5_SEQAC",6)})

   Case ParamIxb == "DADOS_ITENS"
       
        @nL7,nC1 SAY "Nr.AC "  SIZE 50,8 PIXEL //'C¢digo Item'
        @nL8,nC1 SAY "Item AC" SIZE 40,8 PIXEL //'Fabricante'
   
        @nL7,nC2 MSGET Work->WKATOCONC   PICTURE AVSX3("W5_ATO_CON",6) SIZE 50,8 PIXEL
        @nL8,nC2 MSGET Work->WKSEQAC     PICTURE AVSX3("W5_SEQAC",6)   SIZE 15,8 PIXEL

   
   Case ParamIxb == "DESMARCA_ITEM"
        Work->WKATOCONC:=""
        Work->WKSEQAC:="" 
   
   Case ParamIxb == "GRAVAW5" .OR. ParamIxb == "GRAVAGI400_SW5"
        SW5->W5_ATO_CONC:=Work->WKATOCONC
        SW5->W5_SEQAC   :=Work->WKSEQAC

   Case ParamIxb == "WKDESPESAS"
        Work->WKATOCONC:=SW5->W5_ATO_CONC
        Work->WKSEQAC  :=SW5->W5_SEQAC
   
   CASE paramixb == "BROWSE_VISUALIZAR"  
//      AADD(aNewCampos,{"W5_RECNO","N",6,0})        
//           AADD(aBotoesVis,{"IMPRESSAO",{||U_LICRYSTAL()},"Imprime Instrucao L.I.",nil })    

    
   Case ParamIxb == "ACAPALI_GRV_SWP"
           SWP->WP_URF_DES:=SW4->W4_URF_DES 
               
   CASE paramIxb == "ANTES_TELA_VISUAL" 
        //If lManuLi
           AADD(aBotoesVis,{"IMPRESSAO",{||U_LICRYSTAL()},"Imprime Instrucao L.I.",nil })    
        //Endif
            
   CASE paramIxb == "GRAVA_TRB"
//      TRB->W5_RECNO := SW5->(RECNO())
//           AADD(aBotoesVis,{"IMPRESSAO",{||U_LICRYSTAL()},"Imprime Instrucao L.I.",nil })    

ENDCASE                           


Return .t. 

//Ponto de entrada para adicionar o botao de impressao da Instrução de LI no browse de entrada.
user function IGI400MNU()
local aRotina := {}

	AADD(aRotina, { "IMP.INSTRUC.LI","U_LICRYSTAL",0,nil})

return aRotina
//Fim do Ponto de entrada