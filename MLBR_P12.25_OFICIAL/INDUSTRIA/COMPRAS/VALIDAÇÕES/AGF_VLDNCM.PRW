#include 'protheus.ch' 


///////////////////////////////////////////////////////////////////////////////
//Funcao para validar se o produto possui NCM cadastrada
//Trabalha integrado com  o parametro MA_VLDNCM (S=Valida, N=Nao Valida, A=Alerta)
//Solicitacao feita via chamado HDi.004440
///////////////////////////////////////////////////////////////////////////////
//Desenvolvido por Anesio G.Faria agfaria@taggs.com.br -21-02-2012
///////////////////////////////////////////////////////////////////////////////
user function VldNCM(cProd)
Local lRet := .T.
Local cVldNcm := GetMv ('MA_VLDNCM') //Valores validos S/N/A 
Local cGrp	  := GetMv ('MA_GRPPER') //Grupo de compras permitidos
if cVldNcm $ 'S|A' 
	dbSelectArea('SB1')
	dbSetOrder(1)
	dbSeek(xFilial('SB1')+cProd)  
	if SB1->B1_POSIPI == space(10)
		if !SB1->B1_GRUPO $ cGrp 
		
		Alert('Codigo nao pode ser utilizado, está faltando NCM'+chr(13);
			+'Favor solicitar correcao ao departamento de compras antes'+chr(13);
			+'de incluir a solicitacao!!!')
			if cVldNcm == 'S' 
				lRet := .F.
			endif
		endif
	endif
endif
Return lRet