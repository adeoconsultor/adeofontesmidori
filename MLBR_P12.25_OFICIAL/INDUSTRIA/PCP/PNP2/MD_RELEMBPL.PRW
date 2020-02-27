#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH' 


User Function MD_RELEMBPL(cNumEmb)


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario"
Local cDesc3         := "Relatorio de Embarque de Planos"
Local cPict          := ""
Local titulo       := "Relatorio de Embarque de Planos"
Local nLin         := 80

//Local Cabec1       := "0123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 "
//Local Cabec2       := "     1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18    "
Local Cabec1       := "   PLANO      SEQUENCIA          DATA   QTDE PLANO       QTDE DISP             QTDE     INVOICE              PRODUTO                                           CLIENTE"
Local Cabec2       := "                             EMBARQUE                     EMBARQUE        EMBARCADO              "
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "G"
Private nomeprog         := "MD_RELEMBPL" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "MDEMBPL"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "MD_RELEMBPL" // Coloque aqui o nome do arquivo usado para impressao em disco

Public lImpresso

//Alert("RELATORIO SENDO GERADO")
//pergunte(cPerg,.F.)

AjustaSx1()
//If ! Pergunte(cPerg,.T.)
//	Return
//Endif

cString := ""
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta a interface padrao com o usuario...                           Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

//Alert("RELATORIO SENDO GERADO")

//wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processamento. RPTSTATUS monta janela com a regua de processamento. Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return



Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//cQuery := " SELECT ZG_NUMEMB, ZG_PLANO, ZG_SEQUEN, ZG_DATA, ZG_QTDEPLA, ZG_DTEMBAR, ZG_EMBARCA, ZG_QTDEEMB, ZG_QTDISPE, ZG_INVOICE "
//cQuery += " FROM SZG010 Where D_E_L_E_T_ = ' ' AND ZG_FILIAL = '"+xFilial("SZG")+"' AND ZG_NUMEMB = '"+cNumEmb+"' "
//cQuery += " Order By ZG_PLANO "
	
//IF SELECT( 'TMPZG' ) > 0
//	DbSelectArea( 'TMPZG' )
//		DbcloseArea()
//ENDIF
//	dbUseArea(.T.,"TOPCONN",TCGenQry( ,, cQuery  ), 'TMPZG' , .F. , .T. )
                                                
//	TcSetField(cAliasQry, "ZG_DATA", "D")

SetRegua(RecCount())                                               



dbSelectArea("TMP")
dbGotop()
While !TMP->(EoF()) 
   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Verifica o cancelamento pelo usuario...                             Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Impressao do cabecalho do relatorio. . .                            Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   If nLin > 55 // Salto de PАgina. Neste caso o formulario tem 55 linhas...
   		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	    nLin := 9                                              
  	    @nLin, 001 Psay "EMBARQUE NUMERO: "+Posicione("SZG",1,xFilial("SZG")+TMP->(ZG_PLANO+ZG_SEQUEN),"ZG_NUMEMB") + "     DATA DE LANгAMENTO: "+cValToChar(TMP->ZG_DATA)
	    nLin++
	    nLin++
   Endif
//Local Cabec1       := "0123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789"
//Local Cabec2       := "     1         2         3         4         5         6         7         8         9         10        11        12        13        14"
//Local Cabec1       :=   "PLANO      SEQUENCIA             DATA   QTDE PLANO       QTDE DISP             QTDE     INVOICE  "
//Local Cabec2       :=   "                             EMBARQUE                     EMBARQUE        EMBARCADO              "

//cQuery := " SELECT ZG_NUMEMB, ZG_PLANO, ZG_SEQUEN, ZG_DATA, ZG_QTDEPLA, ZG_DTEMBAR, ZG_EMBARCA, ZG_QTDEEMB, ZG_QTDISPE, ZG_INVOICE "

    @nLin,003 Psay TMP->ZG_PLANO   
    @nLin,018 Psay TMP->ZG_SEQUEN
    @nLin,028 Psay TMP->ZG_DTEMBAR
    @nLin,041 Psay TMP->ZG_QTDEPLA Picture "@E 999,999.99"
    @nLin,057 Psay TMP->ZG_QTDISPE Picture "@E 999,999.99"
    @nLin,074 PSay TMP->ZG_QTDEEMB Picture "@E 999,999.99"
    @nLin,089 Psay cInvoice                     
/*    dbSelectArea("SC2")
    dbSetOrder(10)                              
    dbGotop()
    Alert("Buscando Plano: "+TMP->ZG_PLANO)
    */                               
    if Select('TRBC2') > 0
    	dbSelectArea('TRBC2')
    	TRBC2->(dbCloseArea())
    endif
    
    cQuery := " SELECT C2_NUM, C2_CLIENTE, C2_LOJA, C2_PRODUTO FROM SC2010 WHERE D_E_L_E_T_ = ' ' AND C2_FILIAL = '"+xFILIAL("SC2")+"' "
    cQuery += " AND Substring(C2_EMISSAO,1,4)='"+Substr(dTos(dDatabase),1,4)+"' "
    cQuery += " AND C2_OPMIDO = '"+Substr(TMP->ZG_PLANO,1,12)+"' "
    
	dbUsearea(.T., "TOPCONN", TcGenQry( ,, cQuery   ), 'TRBC2' , .F. , .T. )
	
	dbSelectArea('TRBC2')
	dbGotop()
//	Alert('Numero da OP -> '+TRBC2->C2_NUM)
//    if dbSeek(xFilial("SC2")+Substr(TRBC2->ZG_PLANO,1,12))
//    	Alert('Localizado...' +SC2->C2_OPMIDO) 
	   	@nLin,110 Psay Substr(TRBC2->C2_PRODUTO,1,6)+'-'+Posicione("SB1",1,xFilial("SB1")+TRBC2->C2_PRODUTO,"B1_DESC")
    	@nLin, 160 Psay TRBC2->C2_CLIENTE + '-'+TRBC2->C2_LOJA
	    @nLin, 175 Psay Posicione("SA1",1,xFilial("SA1")+TRBC2->(C2_CLIENTE+C2_LOJA),"A1_NOME")
//	endif

    nLin := nLin + 1 
TMP->(dbSkip())                 
   		
EndDo

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Finaliza a execucao do relatorio...                                 Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

SET DEVICE TO SCREEN

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Se impressao em disco, chama o gerenciador de impressao...          Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()                          
dbSelectArea("TMP")
dbGotop()
lImpresso := .T.
Return lImpresso 



Static Function AjustaSX1()

Local aArea := GetArea()
PutSx1(cPerg,"01","Numero do Embarque            ?"," "," ","mv_ch1","C",6,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o Numero do Embarque"},{"Informe o Numero do Embarque"},{"Informe o Numero do Embarque"})
RestArea(aArea)
Return