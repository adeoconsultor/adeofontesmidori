
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³  MACTLHIS.PRW   ºAutor³ Sandro Albuquerque         º Data ³ 01/02/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Retorna o historico para o campo CT2_HIS e CT2_HAGLUT                  º±±
±±º         ³ 																		 º±±
±±º         ³ Ex: 0        1         2         3         4							 º±±
±±º         ³     1234567890123456789012345678901234567890                           º±±
±±º         ³     NFE.000000000-1 NOME REDUZIDO DO CLIENTE                           º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe  ³ MACTLHIS(Complemento,Lancamento Padrao)                                º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro³ MACTLHIS(Lancamento padrao)                       					 º±±
±±º         ³ Retorna o historico do campo CTL_X_HIST no formato exigido pelo clienteº±±
±±º         ³ 																		 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ Generico                                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  Programador  ³  Data   ³ Motivo da Alteracao                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º               ³         ³                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MACTLHIS(cCompl,cLp)
Local _cRet     := " "
Local _cDocto   := " "
Local _cNfori   := " "
Local _cSerie   := " "
Local _cCliFor  := " "
Local _cPerg    := " "
//Local _nTamHist := TamSX3("CT2_HIST") // Tamanho do campo historico da tabela de movimento contabil
Local aAreaAnt  := GetArea()
Local _cCod := " "
Local _cFornece  := " "

// Quando tiver que incluir a data de vencimento dos titulos de Pis/Cof/Csll
IF Alltrim(cCompl) $ "VENC"
	cCompl := U_MACTBPCC(SF1->F1_FORNECE,SF1->F1_FILIAL+" ",SF1->F1_DOC,'VENC') // retenção de impostos traz a data de vencto real
Endif

DbselectArea("CTL")
DbSetOrder(1)
If dBSeek(xFilial("CTL")+cLP)
	
	IF CTL->CTL_ALIAS $ "SF1/SD1" // Notas Fiscais de Entrada
		Pergunte("CTBNFE",.F.)
		_lHaglu := IIF(MV_PAR02 == 1, .T., .F.)  // Parametro de aglutina 1=sim / 2=Não
		
		_cDocto := SF1->F1_DOC
		_cSerie := SF1->F1_SERIE
		_cCod   := SD1->D1_COD
        _cFornece := SF1->F1_FORNECE
		
		If SF1->F1_TIPO $ "B/D"
			cCompl   := " "  //cCompl+IIf(SF1->F1_TIPO $ "B", " BENEF "," DEV ") // Beneficiamento ou Devolucao
			_cClifor := Alltrim(SA1->A1_NREDUZ)
			_cNfori  := Alltrim(SD1->D1_NFORI)
			
		Else
			_cClifor := Alltrim(SA2->A2_NREDUZ)
			
		Endif
		
		_cRet  := Alltrim(cCompl)+" NF "+Alltrim(_cDocto) //Alltrim(cCompl)+" NF "+Alltrim(_cDocto)
		_cRet  := Alltrim(IIf(Empty(_cSerie), _cRet, _cRet+"-"+Alltrim(_cSerie)))
		_cRet  := Alltrim(IIf(Empty(_cNfori), _cRet, _cRet+"/"+Alltrim(_cNfori)))
		_cRet  := _cRet+" "+Alltrim(_cCliFor)// + "|" + rtrim(_cCod) + "|" + rtrim(_cFornece)         // Amadeu Soliani
		
	Elseif CTL->CTL_ALIAS $ "SF2/SD2"  // Notas Fiscais de Saida
		
		Pergunte("CTBNFS", .F.)
		_lHaglu := IIF(MV_PAR02==1, .T., .F.) // Parametro de aglutina 1=sim / 2=Não
		
		_cDocto := SF2->F2_DOC
		_cSerie := SF2->F2_SERIE
		
		If SF2->F2_TIPO $ "B/D"
			cCompl    := " " // cCompl+IIf(SF2->F2_TIPO $ "B", " BENEF "," DEV ") // Beneficiamento ou Devolucao
			_cClifor  := Alltrim(SA2->A2_NREDUZ)
			_cNfori   := Alltrim(SD2->D2_NFORI)
			
		Else
			_cClifor := Alltrim(SA1->A1_NREDUZ)
			
		Endif
		
		_cRet  := Alltrim(cCompl)+" NF "+Alltrim(_cDocto) //Alltrim(cCompl)+" NFS "+Alltrim(_cDocto)
		_cRet  := Alltrim(IIf(Empty(_cSerie), _cRet, _cRet+"-"+Alltrim(_cSerie)))
		_cRet  := Alltrim(IIf(Empty(_cNfori), _cRet, _cRet+"/"+Alltrim(_cNfori)))
		_cRet  := _cRet+" "+Alltrim(_cCliFor)
		
	Else
		
		Pergunte("FIN370", .F.) 				// Rotina que faz a chamada CTBAFIN
		_lHaglu := IIF(MV_PAR02==1, .T., .F.) 	// Parametro de aglutina 1=sim / 2=Não
		
		_cRet := Alltrim(cCompl)
		_cRet := _cRet +' '+ &(CTL->CTL_X_HIST)  // Traz historico diferente de Entradas e Saidas		
	Endif
	
	If _lHAglu
		_cRet := IIF(!Empty(_cRet), _cRet, CTL->CTL_DESC)
		
	Else
		_cRet := IIF(!Empty(_cRet), _cRet, CTL->CTL_DESC)
		
	Endif
	
Else // se for final de arquivo CTL.
	_cRet := 'HIST NÃO CADASTRADO'
	
Endif

_cRet := Iif(!Empty(_cRet),Substr(Alltrim(_cRet),1,40),_cRet) //AOliveira VERIFICADO  09-08-2011, para atender solicitação do Mauri no qual diz que não esta sendo realizado o acerto de historico.

RestArea(aAreaAnt)

Return(_cRet) // Retorna o historico de acordo com o tamanho do campo do CT2.
