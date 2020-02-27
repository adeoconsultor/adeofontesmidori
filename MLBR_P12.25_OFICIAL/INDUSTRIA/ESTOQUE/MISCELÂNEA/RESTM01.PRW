#include "rwmake.ch"     

User Function RESTM01()   

SetPrvt("C_SVSCEST,LPERG,_CPRODUTO,_CLOCAL,_DDATA,_NVALORUN")
SetPrvt("_NQTD,_CKEY_TOT,_CIND_TOT,")

/*/
@---------------------------------------------------------------------------@
| Programa  | RESTM01  | Autor|Rogerio Batista         | Data |05.08.2010   |
@---------------------------------------------------------------------------@
| Descricao | Programa para importar o Custo unitario dos produtos, atraves |
|           | de uma planilha do excel ajustada pela Beth, este custo será  |
|           | importado para o SB9 (Saldos iniciais) de determinada data    |
|           |                                                               |
@---------------------------------------------------------------------------@
| Uso       | Especifico - Midori Atlantica                                 |
@---------------------------------------------------------------------------@
/*/

        If !MsgBox("Esta  rotina  ira' importar um arquivo com o custo do produto apos a  )"+Chr(13);
                  +"virada de estoques, arquivo ajustado pela Beth","Importacao de Custos","YesNo")
           Return 
        EndIf

AbreArq()

PROCESSA({|| _ProcArq()},"Processa Arquivos...")

Return()    

Static Function _ProcArq()

dbSelectArea("TOT")

    ProcRegua(Reccount())

While !Eof()

          IncProc()

        _cProduto := TOT->CODIGO
        _cLocal   := TOT->LOCAL
        _dData    := TOT->EMISSAO
        _nValorUn := TOT->CUSMED

        dbSelectArea("SB9")
        dbSetOrder(1)
        dbSeek(xfilial("SB9")+_cProduto+_cLocal+Dtos(_dData))

        If Found()
             _nQTD := SB9->B9_QINI

             RecLock("SB9",.F.)

               SB9->B9_VINI1  := _nValorUn*_nQTD
               SB9->B9_VINI2  := 0
               SB9->B9_VINI3  := 0
               SB9->B9_VINI4  := 0
               SB9->B9_VINI5  := 0

             MsUnlock()
        EndIf

          _nQTD := "0"


      dbSelectArea("TOT")
      dbSkip()

EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno index e apaga index temporario                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB9")
RetIndex("SB9")

dbSelectArea("TOT")
dbCloseArea()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ABREARQ  ³ Autor ³Rogerio Batista        ³ Data ³ 25/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Abertura de Arquivos                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AbreArq()
                 
cPerg := "RESTM01"                              

pergunte(cPerg,.t.)     

_cArquivo := "\ARQUIVOS\"+alltrim(MV_PAR01)

dbUseArea(.T.,,_cArquivo,"TOT",.T.,.F.)
_cKey_TOT := "CODIGO"
_cInd_TOT := CriaTrab(Nil,.F.)
INDREGUA("TOT",_cInd_TOT,_cKey_TOT,,,"Filtrando Movimentos...")
dbGotop()

Return

