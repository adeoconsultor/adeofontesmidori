#include "rwmake.ch"        
#include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F240TBOR  ºAutor  ³Josmar Castiglioni  º Data ³  28/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE NA GRAVAÇÃO DO BORDERO QUE TRATA O CODIGO DE BARRAS SE  º±±
±±º          ³ DIGITADO OU LEITORA OTICA NO MODELO DE PAGAMENTO TIPO 30   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F240TBOR()

Local   _aAr   :=  getarea()

Private _nTitCon:=0 // 0=Nao identificado;1=Titulo;2=Concessionaria

_cLinhaDig:=space(54)

DbSelectArea("SE2")

IF M->CMODPGTO $ "13;31;30" .and. M->CPORT240 $ "237;341;422;456"

	_cCodBar := SE2->E2_CODBAR

	@ 000,000 TO 225,350 DIALOG oDlg1 TITLE "Entrada de Codigo de Barras do Titulo"

	@ 005,010 SAY "Titulo:"
 	@ 005,045 SAY ALLTRIM(se2->e2_prefixo)+"-"+ALLTRIM(se2->e2_num)+"-"+ALLTRIM(se2->e2_parcela)+"-"+ALLTRIM(se2->e2_tipo) COLOR CLR_HBLUE

	@ 015,010 SAY "Fornecedor:"
	@ 015,045 SAY ALLTRIM(se2->e2_nomfor) COLOR CLR_HBLUE

	@ 025,010 SAY "Valor R$:"
	@ 025,045 SAY (SE2->E2_SALDO + SE2->E2_ACRESC) - (SE2->E2_DECRESC) size 115 picture "@e 9,999,999.99" COLOR CLR_HBLUE
	
	@ 040,010 SAY "Passe o documento pela leitora: "
	@ 050,010 GET _cCodBar SIZE 160,50  Valid vazio().or.ECODBAR(_cCodBar,SE2->E2_SALDO)
	
	@ 065,010 say "Ou informe abaixo a linha digitavel:"            
	@ 075,010 get _cLinhaDig size 160,15 valid _fLinhaDig()
	
	@ 095,100 BMPBUTTON TYPE 01 ACTION (if(GravaBar(),Close(oDlg1),nil))
	@ 095,145 BMPBUTTON TYPE 02 ACTION Close(oDlg1)

	ACTIVATE DIALOG oDlg1 CENTER

    
    Restarea(_aAr)
	Return(.t.)        

ELSE
    Restarea(_aAr)
    RETURN(.t.)

ENDIF         
 
Restarea(_aAr)
Return 

*****************************************************************************
Static Function GravaBar()
_lReturn:=.f.
if ECODBAR(_cCodBar,SE2->E2_SALDO)
   RecLock("SE2",.f.)
       se2->e2_codbar := _cCodBar
   MsUnlock()
   _lReturn:=.t.
endif   

Return _lReturn
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ECODBAR  ³ Autor ³ ROBERTO R.MEZZALIRA   ³ Data ³ 19.01.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ EXECBLOCK PARA GATILHO PARA VALICAO DE VALOR DO TITULO     ³±± 
±±³          ³ DO CONTAS A PAGAR x CODIGO DE BARRAS                       ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                              
Static Function ECODBAR(CodBar,nVLRTIT)

Local   _aArea   :=  getarea()
Local   _cBco    :=  Substr(CODBAR,1,3) //IDENTIFICA O BANCO DO CODIGO DE BARRA
LOCAL   _nVlr    :=  0  // RETORNA O VALOR DO CODIGO DE BARRA
LOCAL   _cVlr    :=  "" 
LOCAL 	_cVlrtit :=  ""
Private _Lok   := .F. 

_nTitCon:=0 // 0=Nao identificado;1=Titulo;2=Concessionaria

if left(codbar,1)=="8"
   _nTitCon:=2
   _nVlr := (VAL(Substr(CODBAR,6,10))/100)
else
   _nTitCon:=1
  _nVlr := (VAL(Substr(CODBAR,10,10))/100)
//   _nVlr := (VAL(Substr(CODBAR,12,10))/100)
endif         


    _cVlr    := PADR(ALLTRIM(transform((_nVlr),"@E 999,999,999.99")),18)  	
 //	_cVlr    := PADR(transform(_nVlr,"@E 99,999,999.99"),18)        
	_cVlrtit := PADR(ALLTRIM(transform(SE2->E2_SALDO,"@E 99,999,999.99")),18)        	

   IF _cVlrtit <> _cVlr  .And. CODBAR <> " "

    MsgInfo("Valor do titulo R$ "+_cVlr+CHR(13)+" Difere do Titulo R$ "+_cVlrtit+CHR(13)+CHR(13)+"Cancele a operacao e encontre o titulo correto"+CHR(13),"Boleto invalido")
    _Lok   := .F.
ELSE
    _Lok   := .T. 
ENDIF       

Restarea(_aArea)
RETURN(_Lok)

*----------------------------------------------------------
Static Function _fLinhaDig()
* Ricardo Luiz da Rocha - 24/04/2006
* Monta o codigo de barras a partir da linha digitavel
*----------------------------------------------------------
Local _nVez

_cReturn:=_cBarraAux:=""

for _nVez:=1 to len(_cLinhaDig)
    _cLido:=substr(_cLinhadig,_nVez,1)
    if _cLido$'0123456789'
       _cReturn+=_cLido
    endif
next

_nTitCon:=0 // 0=Nao identificado;1=Titulo;2=Concessionaria

if left(_cReturn,1)=="8"
   _nTitCon:=2
else
   _nTitCon:=1
endif

if _nTitCon==1 // Titulo normal
   if !empty(_cReturn)
      if len(alltrim(_cReturn))<=38
         _cReturn:=SubStr(_cReturn,1,33)+StrZero(ABS(se2->e2_saldo*100),14)
         Return
      endif

      if Substr(_cReturn,34,5) == "00000" .and. Len(alltrim(_cReturn)) == 47  // Fator de Vencimento
         _cReturn:=SubStr(_cReturn,1,33)+StrZero(ABS(se2->e2_saldo*100),14)
      else
         _cReturn:=SubStr(_cReturn,1,38)+StrZero(ABS(se2->e2_saldo*100),09)
      endif

      if substr(_cReturn,34,5) <> "00000"
         nVal1 := strzero(abs(se2->e2_saldo*100),14)
         nVal  := substr(_cReturn,34,5)+substr(nVal1,6,9)
         _cBarraAux:= substr(_cReturn,1,4)+nVal+substr(_cReturn,5,5)+substr(_cReturn,11,10)+substr(_cReturn,22,10)
      else
         _cBarraAux:= substr(_cReturn,1,4)+strzero(abs(se2->e2_saldo*100),14)+substr(_cReturn,5,5)+substr(_cReturn,11,10)+substr(_cReturn,22,10)
      endif

      _cReturn:=substr(_cBarraAux,1,4) + substr(_cReturn,33,1) + substr(_cBarraAux,5,39)
      _cCodBar:=_cReturn
   endif
elseif _nTitCon==2 // Concessionaria
   if !empty(_cReturn)
      _cReturn:=substr(_cReturn,01,11)+;
                substr(_cReturn,13,11)+;
                substr(_cReturn,25,11)+;
                substr(_cReturn,37,11)
      _cCodBar:=_cReturn
   endif
endif

return .t.