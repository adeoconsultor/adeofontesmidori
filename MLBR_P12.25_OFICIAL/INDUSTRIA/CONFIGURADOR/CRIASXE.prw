#include "protheus.ch"
#include "topconn.ch"
  
/*/{Protheus.doc}P.E - CriaSXE
                    
    Ponto de entrada para retornar o próximo número que deve ser utilizado na inicialização da numeração. Este ponto de entrada é recomendado
    para casos em que deseja-se alterar a regra padrão de descoberta do próximo número.
    A execução deste ponto de entrada, ocorre em casos de perda das tabelas SXE/SXF ( versões legado ) e de reinicialização do License Server.
        
    @author: Súlivan Simões Silva - Email: sulivansimoes@gmail.com
    @since : 15/10/2019
    @version : 1.0
    @param   : PARAMIXB, array, Vetor contendo as informações que poderão ser utilizadas pelo P.E.
    @return  : cRet, caracter, Número que será utilizado pelo controle de numeração.
               Caso seja retornado Nulo ( NIL ), a regra padrão do sistema será aplicada. Esta função nunca deve retornar uma string vazia.
                
    @Lik     : 1 - http://tdn.totvs.com/pages/releaseview.action?pageId=6815179      
               2 - https://centraldeatendimento.totvs.com/hc/pt-br/articles/360019303171-MP-ADVPL-CRIASXE-PARA-SOLUCIONAR-LACUNAS-NO-CONTROLE-DE-NUMERA%C3%87%C3%83O
                          
        
    @obs : MANUTENÇÕES FEITAS NO CÓDIGO:
    --------------------------------------------------------------------------------------------                   
    Versão gerada:
    Data:
    Responsável:
    Log: [Fale aqui o que foi feito]
    --------------------------------------------------------------------------------------------       
/*/               
  
user function CRIASXE()
    
    local aArea     := getArea()      
    Local cAlias_   := paramixb[1]
    local cCpoSx8   := paramixb[2]
    local cAlias_Sx8:= paramixb[3]
    local nOrdSX8   := paramixb[4]
    local aTabelas  := {}         //Tabelas que irão permitir a execução do P.E
    local cTabela   := ""         //Alias corrente que irá permitir a execução do P.E.      
    local nCount    := 0                                                                    
    local cQuery    := ""         //Na query eu vejo o ultimo número que tá no banco.
    local cProxNum  := Nil        //Retorno da função.
                                                    
      
    ConOut("[u_CRIASXE] 01 - Entrou no ponto de entrada CRIASXE / Se nao tiver log entre mensagem 01 e 02, nao foi feito nada aqui!")      
        
            
       //Definindo as tabelas que irão executar o P.E / Caso precise executar em mais alguma só adicionar no array e pronto..
       aTabelas := {"AA5","AB1","AB6","ABB","ACB","ACF","ACS","AD1","ADA","ADK","ADW","AE8","AFK","AG1","AGE",+;
                    "AI3","AI8","AI9","AIC","AK6","AKD","ALB","C0W","C5E","C8B","C8R","C8X","C92","C99","CF8",+;
                    "CLG","CM0","CM6","CM8","CM9","CMD","CMR","CN0","CN1","CN2","CN3","CN4","CN5","CN8","CN9",+;
                    "CND","CNF","CNK","CNL","CNP","CNX","CTA","CTO","CUO","CV4","DA4","DB1","DBJ","FJV","FKA",+;
                    "FN6","FN8","FN9","GU3","GU5","GU9","GVE","GWD","GWF","GWR","LEK","MBI","NNS","NQ6","NQC",+;
                    "NQE","NRO","NST","NVG","NVH","NY3","QDA","QE1","RA0","RA1","RA2","RA8","RAG","RAT","RAV",+;
                    "RB6","RBF","RBG","RBK","RBR","RD1","RD3","RD5","RD6","RDK","RDM","RDS","RDU","RE0","RE3",+;
                    "REC","REE","REJ","RER","RF1","RHG","RHY","SA1","SA2","SA4","SA5","SAJ","SAK","SAL","SB1",+;
                    "SC0","SC1","SC2","SC3","SC5","SC7","SC8","SCJ","SCP","SCT","SD3","SD4","SDA","SE2","SE4",+;
                    "SE5","SEH","SEU","SF9","SGK","SGL","SGM","SJQ","SK0","SK2","SK3","SK4","SKP","SKY","SL1",+;
                    "SL7","SN4","SNV","SON","SPW","SQ0","SQB","SQE","SQG","SQO","SQQ","SQS","SQT","SQU","SQV",+;
                    "SQW","SQX","SRA","SRL","STJ","STO","SU0","SU5","SU6","SU7","SU9","SUA","SUC","SUE","SUN",+;
                    "SUQ","SUS","SY0","SYP","SZJ","SZQ","SZR","SZY","T1S","T2V","T3B","T3M","T3V","TBB","TIQ",+;
                    "TIR","TIS","TIV","TJK","TLX","TM0","TMY","TN0","TNY","TQB","TQN","TRF","TT1","TTF","TZ9",+;
                    "TZB","VEG","WF1","ZZC","ZZO"}
        
       //Percorro array e vejo se tabela corrente deve executar o P.E              
       for nCount := 1 to  len(aTabelas)
        
            if( cAlias_ $ aTabelas[nCount] )
                
                cTabela := aTabelas[nCount]
                                                                                                        
                ConOut("[u_CRIASXE] ->  TRATATIVA | Sera ajustado via P.E numeracao automatica: "+ cAlias_ + " - " +;
                        cCpoSx8 + " - " + cAlias_Sx8 + " - " + cValToChar(nOrdSX8) )           
                exit
            endif    
       next
              
       //Se a tabela corrente estiver na coleção de tabelas E as variáveis dos parâmetros não estiverem com problema.
       if( !empty(cTabela) .AND.  ! ( empty(cAlias_) .AND. empty(cCpoSx8) ) )        
                                
            ConOut("[u_CRIASXE] ->  Antes de criar consulta para pegar ultimo numero do campo "+cCpoSx8 )  
            
            DO CASE
            CASE substr(cTabela,1,3) $ "SC7"
                cQuery := " SELECT MAX("+cCpoSx8+") AS ULTIMO_NUM FROM "+cTabela+'010'+" AS TMP "
                cQuery += " WHERE D_E_L_E_T_ = '' AND "+cCpoSx8+" LIKE '0%' AND "+Upper(Substr(cTabela,2,2))+"_FILIAL = '" + xFilial() +"' AND LEN("+cCpoSx8+") = '6' "
            CASE substr(cTabela,1,3) $ "SC5"
                cQuery := " SELECT MAX("+cCpoSx8+") AS ULTIMO_NUM FROM "+cTabela+'010'+" AS TMP "
                cQuery += " WHERE D_E_L_E_T_ = '' AND "+cCpoSx8+" LIKE '0%' AND "+Upper(Substr(cTabela,2,2))+"_FILIAL = '" + xFilial() +"' AND LEN("+cCpoSx8+") = '6' "
            CASE substr(cTabela,1,3) $ "SE2" .AND. cCpoSx8 == "E2_X_NUMAP"
                cQuery := " SELECT MAX("+cCpoSx8+") AS ULTIMO_NUM FROM "+cTabela+'010'+" AS TMP "
                cQuery += " WHERE D_E_L_E_T_ = '' AND E2_EMISSAO >= '20191220' AND LEN("+cCpoSx8+") = '9' "                
            CASE cTabela $ "SB1|SA1|SA2"
                cQuery := " SELECT MAX("+cCpoSx8+") AS ULTIMO_NUM FROM "+cTabela+'010'+" AS TMP "
                cQuery += " WHERE D_E_L_E_T_ = '' AND "+cCpoSx8+" LIKE '0%' AND LEN("+cCpoSx8+") = '6' "                
            CASE substr(cTabela,1,2) $ "SR"
                cQuery := " SELECT MAX("+cCpoSx8+") AS ULTIMO_NUM FROM "+cTabela+'010'+" AS TMP "
                cQuery += " WHERE D_E_L_E_T_ = '' AND "+Upper(Substr(cTabela,2,2))+"_FILIAL = '" + xFilial() +"' AND "+cCpoSx8+" NOT LIKE '9%' AND LEN("+cCpoSx8+") = '6' "
            CASE substr(cTabela,1,2) $ "SQ"
                cQuery := " SELECT MAX("+cCpoSx8+") AS ULTIMO_NUM FROM "+cTabela+'010'+" AS TMP "
                cQuery += " WHERE D_E_L_E_T_ = '' "
            ENDCASE   

            If !empty(cQuery)
                cQuery := changeQuery(cQuery)
                TcQuery cQuery New Alias 'TMP_QRY'
                
                
                ConOut("[u_CRIASXE] ->  Depois de criar consulta para pegar ultimo numero do campo "+cCpoSx8 )                
                
                //Caso a query retorne ultimo número
                if( !TMP_QRY->(eof() ) )
                                        
                    cProxNum := soma1(Trim(TMP_QRY->ULTIMO_NUM)) //pego ultimo código e somo 1
                    
                    ConOut("[u_CRIASXE] ->  Proximo numero do campo  "+cCpoSx8+" sera "+cProxNum )             
                else
                    
                    ConOut("[u_CRIASXE] ->  A query veio vazia ou ocorreu algum problema, nao conseguiu incrementar o proximo numero do campo"+cCpoSx8 )                               
                endif
            
                TMP_QRY->( dbCloseArea() )  
            Endif               
        endif
    
  
    ConOut("[u_CRIASXE] 02 - Encerrou taferas no ponto de entrada CRIASXE")  
    
    restArea( aArea )
    
return cProxNum
