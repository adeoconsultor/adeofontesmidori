#Include 'protheus.ch'
#Include 'rwmake.ch'
                    
///////////////////////////////////////////////////////////////////////////
//Ponto de entrada chamado na atualizacao das cotacoes.
///////////////////////////////////////////////////////////////////////////


user function MT150END()
Local cQuery := ""   

//Tratativa temporaria para Gerar PC na analise da Cotacao
//Diego 12/06/18
cQuery := " UPDATE SC8010 SET C8_TPDOC = '1' "
cQuery += " WHERE D_E_L_E_T_ = '' AND C8_NUM = '" + SC8->C8_NUM + "' "
TcSqlExec(cQuery)

return                                                               