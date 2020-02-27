#include 'protheus.ch'
#include 'rwmake.ch'


///////////////////////////////////////////////////////////////////////////////
//Função para busca do custo medio do produto em SB2 antes e depois de cada 
//transação. 
//Será chamada via ponto de entrada das rotinas.
//Faz parte do projeto apresentado pelo Sr.Helio Matsuda em Dez-2011
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br, angfaria@hotmail.com - 09-01-2012
///////////////////////////////////////////////////////////////////////////////


User Function AGF_SEARCHCUS(cLocal, cCod)
Local nCusto  := 0
Local _cLocal := cLocal
Local _cCod   := cCod

nCusto := Posicione("SB2",2,xFilial("SB2")+_cLocal+_cCod,"B2_CM1")

return nCusto
