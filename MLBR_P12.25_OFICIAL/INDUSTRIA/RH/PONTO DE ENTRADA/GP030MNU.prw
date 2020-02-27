#INCLUDE 'PROTHEUS.CH'
#INCLUDE "RPTDEF.CH"  
#INCLUDE "IMPFER.CH"
#INCLUDE "FWPrintSetup.ch"

Static nOrdSRR

/*///////////////////////////////////////////////////////////////////////////////////////////////
Ponto de entrada GP030MNU() no menu de impressЦo do calculo de Ferias
ImpressЦo do Aviso e Recibo de Ferias
Antonio - 06/12/2019
Foram incluidos neste fonte os fontes GPER130 e IMPFER, para que possam ser chamados diretos 
pelo menu do arotina da funГЦo padrЦo para podermor imprimir grafico devido a necessidade
do codigo QRCODE no relatorio.
*////////////////////////////////////////////////////////////////////////////////////////////////

User Function GP030MNU()

	Local aArea := GetArea()
	
	Public oxPrint   //para impressЦo em todos os fontes abaixo
	
	aDel( aRotina , 3 )
	aSize( aRotina , --Len(aRotina) )
	aAdd(aRotina, { "I&mpressЦo","U_UGPER130", 0 , 5, ,.F.})
	RestArea(aArea)

Return                  





/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    Ё GPER130  Ё Autor Ё R.H. - Mauro          Ё Data Ё 26.04.95 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Recibo de Ferias                                           Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё GPER130(void)                                              Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁ                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё Generico                                                   Ё╠╠
╠╠юддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
User Function UGPER130()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis Locais (Basicas)                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local cString  := "SRA"                // ALIAS DO ARQUIVO PRINCIPAL (BASE)
Local aOrd     := {" Matricula "," C.Custo + Matric","C.Custo + Nome","Nome"}
Local nTotregs,nMult,nPosAnt,nPosAtu,nPosCnt,cSav20,cSav7 // REGUA
Local cDesc1   := " Aviso / Recibo de FИrias "
Local cDesc2   := " SerА impresso de acordo com os parametros solicitados pelo"
Local cDesc3   := " usuАrio."
Local cSavAlias,nSavRec,nSavOrdem    
Local lPnm070TamPE := ExistBlock( "PNM070TAM" )

Local lAdjustToLegacy := .T.         //COMPACTA ARQUIVO EM PDF 
Local lDisableSetup   := .T.         //DESABILITA TELA DA IMPRESSORA
Local cLocal          := "\spool"

Local bParam		:= {|| Pergunte("GPR130", .T.)}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis Private(Basicas)                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Private aReturn := {"Zebrado", 1,"AdministraГЦo", 1, 2, 1, "",1 }	// "Zebrado"###"Administra┤└o"
Private nomeprog:="GPER130"
Private anLinha := { },nLastKey := 0
Private cPerg   :="GPR130"
   
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis Private(Programa)                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Private cPdAb   := cPd13ab := cPd13o := Space(3)
Private aCodFol := {}     // Matriz com Codigo da folha
   
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis UtinLizadas na funcao IMPR                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Private Titulo  := "RECIBO E AVISO DE FERIAS"
Private AT_PRG  := "GPER130"
Private wCabec0 := 3
Private wCabec1 := ""
Private wCabec2 := ""
Private wCabec3 := ""
Private CONTFL  := 1
Private nLi     := 0
Private nTamanho:= "P"

cSavAlias := Alias()
nSavRec   := RecNo()
nSavOrdem := IndexOrd()   

If lPnm070TamPE
 	IF ( ValType( uRetBlock := ExecBlock("PNM070TAM",.F.,.F.))  == "C" )
   	   nTamanho := uRetBlock
	Endif
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Ajusta pergunta no SX1                                       Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If cPaisLoc == "BRA"
	AjustaSX1()
EndIf


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica as perguntas selecionadas                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
pergunte("GPR130",.T.)
   
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Envia controle para a funcao SETPRINT                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
wnrel:="GPER130"            //Nome Default do relatorio em Disco
//wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)


oxPrint := FWMSPrinter():New('IMPFER', IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
//oxPrint := FWMSPrinterSetup()
//oxPrint:SetUserParms(bParam)
//oxPrint:ParamReadOnly(.T.)

	//здддддддддддддддддддддддддддддддддддддддддд©
	//ЁVerifica se ha impressora ativa conectada Ё
	//юдддддддддддддддддддддддддддддддддддддддддды
		oxPrint:Setup()							//-- Escolhe a impressora	
	If ! oxPrint:GetOrientation() 
		oxPrint:Setup()							//-- Escolhe a impressora	
		If ! oxPrint:IsPrinterActive()	
			Help(" ",1,"NOPRINTGRA")			//-- Nao foi encontrada configuracao de impressora. ##Certifique-se de que as configuraГУes da impressora estЦo corretas ou se hА alguma impressora conectada.
			Return(Nil)
		Endif
	Endif   
	oxPrint:SetPortrait()		//Modo retrato 
 //	oxPrint:StartPage() 			//Inicia uma nova pagina 

   
If nLastKey = 27
	Return
Endif

//SetDefault(aReturn,cString)

If nLastKey = 27
	Return
Endif
   
RptStatus({|lEnd| GP130Imp(@lEnd,wnRel,cString)},Titulo)

dbselectarea(cSavAlias)
dbsetorder(nSavOrdem)
dbgoto(nSavrec)
    
/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    Ё GP130imp Ё Autor Ё R.H. - Mauro          Ё Data Ё 26.04.95 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Recibo de Ferias                                           Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё GPER130(void)                                              Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё Generico                                                   Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
Static Function GP130IMP(lEnd,WnRel,cString)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis Locais (Programa)                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local aPeriodos  := {}
Local lTemCpoProg
Local nImprVias
Local nCnt

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Variaveis de Acesso do Usuario                               Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Local cAcessaSRA	:= &( " { || " + ChkRH( "GPER130" , "SRA" , "2" ) + " } " )

Local cLinAtu		:= ""
Local nCntCd		:= 0
Local nConta		:= 0
Local nDiaFeQueb 	:= 0 
Local i             := 0
Local ni            := 0
Local aGozoFer      := {}
Local dDataRet      := CTOD("//")
Local cDiasFMes		:= ""
Local cDiasFMesSeg  := ""
Local cDiasAbMes	:= ""
Local cDiasAbMSeg	:= ""
Local cLiqReceber	:= ""

Local nTamSpace	:= ""
Local nLenCRet2	:= ""
Local nTamLinha	:= ""
Local nTamNomEmpresa := ""

Local nTamSpaco	:= ""
Local lDepto 	:= .f.
Local cImpAvFer		:= SuperGetMv('MV_IMPAVF',,"1")
Local cBcoDesc		:= ""
Local cBcoAg		:= ""
Local cBcoCta		:= ""
Local cDtDisp		:= ""
Local lImpBco		:= .F.

Local oBrushC	    := TBrush():New( ,  RGB(228, 228, 228)  )
Local oBrushI	    := TBrush():New( ,  RGB(242, 242, 242)  )
Local PER_AQ_I,PER_AQ_F,PER_GO_I,PER_GO_F

Private nSol13,nSolAb,nRecib,nRecAb,nRec13,cFilDe,cFilAte
Private cMatDe,cMatAte,cCcDe,cCcAte,cNomDe,cNomAte,cDtSt13
Private nFaltas   := Val_Salmin:=0
Private Salario   := SalHora := SalDia := SalMes := nSalPg := 0.00
Private lAchou    := .F.
Private aInfo     := {}
Private aTabFer   := {}    			// Tabela para calculo dos dias de ferias
Private aCodBenef := {}
Private nAviso,lImpAv,dDtfDe,dDtfAte,nImprDem

Private DaAuxI	  := Ctod("//")
Private DaAuxF	  := Ctod("//")
Private cAboAnt   := If(GetMv("MV_ABOPEC")=="S","1","2") //-- Abono antes ferias
Private cAboPec	  := ""

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis Utilizadas para Parametros                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//nOrdem  := aReturn[8]

nOrdem  := 3  //aReturn[8] //SETADO SEMPRE 3 A PEDIDO DO PESSOAL DO RH/Diego (Antonio 17/12/19)
nSol13  := mv_par01     //  SoLic. 1o. Parc. 13o.
nSolAb  := mv_par02     //  SoLic. Abono Pecun.
nAviso  := mv_par03     //  Aviso de Ferias
nRecib  := mv_par04     //  Recibo de Ferias
nRecAb  := mv_par05     //  Recibo de Abono
nRec13  := mv_par06     //  Recibo 1╕ parc. 13o.
nDtRec  := mv_par07     //  Imprime Periodo de Ferias
dDtfDe  := mv_par08     //  Periodo de Ferias De
dDtfAte := mv_par09     //  Periodo de Ferias Ate
cFilDe  := mv_par10     //  FiLial De
cFilAte := mv_par11     //  FiLial Ate
cMatDe  := mv_par12     //  Matricula De
cMatAte := mv_par13     //  Matricula Ate
cCcDe   := mv_par14     //  Centro De Custo De
cCcAte  := mv_par15     //  Centro De Custo Ate
cNomDe  := mv_par16     //  Nome De
cNomAte := mv_par17     //  Nome Ate
dDtSt13 := mv_par18     //  Data SoLic. 13o.
nVias   := mv_par19     //  No. de Vias
dDtPgDe := mv_par20	    //  Data de Pagamento De
dDtPgAte:= mv_par21	    //  Data de Pagamento Ate

LSOMLIR :=mv_par25

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica a base instalada, se for Brasil utiliza o param,	Ё
//Ё caso contrario, fixa o param como 2 (Nao Imprime Demitidos)	Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
nImprDem:= Iif( cPaisLoc == "BRA", mv_par22, 2 )
nDAbnPec:= IiF (cPaisLoc == "BRA", mv_par23, 15)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica a existencia dos campos de programacao ferias no SRFЁ
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
lTemCpoProg := fTCpoProg()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Pocisiona No Primeiro Registro Selecionado                   Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea("SRA")
   
If nOrdem == 1
	dbSetOrder(1)
	dbSeek( cFilDe + cMatDe,.T. )
	cInicio  := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim     := cFilAte + cMatAte
ElseIf nOrdem == 2
	dbSetOrder(2)
	dbSeek( cFilDe + cCcDe + cMatDe,.T. )
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := cFilAte + cCcAte + cMatAte
ElseIf nOrdem = 3                                              //SEMPRE ORDENAR POR ESTE CENTRO DE CUSTOS
	dbSetOrder(8)
	dbSeek(cFilDe + cCcDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
	cFim     := cFilAte + cCcAte + cNomAte
ElseIf nOrdem = 4
	dbSetOrder(3)
	dbSeek(cFilDe + cNomDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim     := cFilAte + cNomAte + cMatAte
Endif

//--Setar impressora                     
@ 0,0 psay Avalimp(080) 

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Carrega Regua de Processamento                               Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
SetRegua(RecCount())
   
While !Eof() .And. &cInicio <= cFim

    nLi:= 0

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Movimenta Regua de Processamento                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	IncRegua()

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif	 

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Consiste Parametrizacao do Intervalo de Impressao            Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If (SRA->RA_MAT < cMatDe) .Or. (SRA->RA_MAT > cMatAte) .Or. ;
		(SRA->RA_CC  < cCcDe ) .Or. (SRA->RA_CC  > cCcAte) .Or.;
		(SRA->RA_NOME < cNomDe) .Or. (SRA->RA_NOME > cNomAte) 
		SRA->(dbSkip(1))
		Loop
	EndIf
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Consiste Situacao do Funcionario                             Ё
	//Ё Inclusao do tratamento para Imprime Demitidos S/N no Brasil. Ё
	//Ё Se nao for Brasil considera-se o param como 2 (Nao imprime)	 Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды	
   	If SRA->RA_SITFOLH $ "D" .AND. nImprDem <> 1	// 1 - Imprime Demitido = Sim
		SRA->(dbSkip(1))
		Loop
	Endif
		                                                                    
	/*
	зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁConsiste Filiais e Acessos                                             Ё
	юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
    If !( SRA->RA_FILIAL $ fValidFil() ) .Or. !Eval( cAcessaSRA )
		dbSelectArea("SRA")
      	dbSkip()
       	Loop
	EndIF

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//| Carrega tabela para apuracao dos dias de ferias - aTabFer    |
	//| 1-Meses Periodo    2-Nro Periodos   3-Dias do Mes    4-Fator |
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	fTab_Fer(@aTabFer)

	lAchou := .F.      
	lImpAv := If(nAviso==1 .or. nSolAb==1 .or. nSol13==1,.T.,.F.)   // Imprime Aviso e/ou So.Abono e/ou Sol.1.Parc.13. s/Calcular

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Procura No Arquivo de Ferias o Periodo a Ser Listado         Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	dbSelectArea( "SRH" )
   	If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
   		aPeriodos := {}
		While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRH->RH_FILIAL + SRH->RH_MAT
			If ( !(cPaisLoc $ "ANG") .And. (SRH->RH_DATAINI >= dDtfDe .And. SRH->RH_DATAINI <= dDtfAte) .And.;
			   (SRH->RH_DTRECIB >= dDtPgDe .And. SRH->RH_DTRECIB <= dDtPgAte) ) .OR. ;
			   ( (cPaisLoc $ "ANG") .And. (SRH->RH_DTRECIB >= dDtPgDe .And. SRH->RH_DTRECIB <= dDtPgAte) )
				AAdd(aPeriodos, Recno() )
			EndIf
			dbSkip()
		Enddo

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Imprime Aviso de Ferias Caso nao tenha calculado             Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If Len(aPeriodos) == 0
			dbSelectArea( "SRA" )
			If lImpAv
			   FImprAvi(lTemCpoProg)
			Endif		
			dbSelectArea( "SRA" )
			dbSkip()
			Loop
		Endif
		
		For nCnt := 1 To Len(aPeriodos)
			dbSelectArea( "SRH" )
			dbGoTo(aPeriodos[nCnt])

			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Carrega Matriz Com Dados da Empresa                          Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			fInfo(@aInfo,SRA->RA_FILIAL)
         
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Carrega Variaveis Codigos da Folha                           Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If !FP_CODFOL(@aCodFol,SRA->RA_FILIAL)
				Return
			Endif
         
			DaAuxI := SRH->RH_DATAINI
			DaAuxF := SRH->RH_DATAFIM

			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Monta a Variavel Nao Lista Para Nao Aparecer Recibo de FeriasЁ
			//Ё e Sim No Recibo De Abono e 13o.                              Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cPdAb := cPd13ab := cPd13o := Space(3)
			If nRec13 == 1
				dbSelectArea( "SRV" )
				PosSrv("022",SRA->RA_FILIAL,,2)
				If !Eof()
					cPd13o := SRV->RV_COD
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Busca os codigos de pensao definidos no cadastro beneficiarioЁ
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					fBusCadBenef(@aCodBenef, "131", {aCodfol[172,1]})
				Endif
			Endif

			If nRecAb == 1
				dbSelectArea( "SRV" )
				PosSrv(RIGHT("0074",Len(SRV->RV_CODFOL)),SRA->RA_FILIAL,,2)
				If !Eof()
					cPdAb := SRV->RV_COD
				Endif
				PosSrv(RIGHT("0079",Len(SRV->RV_CODFOL)),SRA->RA_FILIAL,,2)
				If !Eof()
					cPd13ab := SRV->RV_COD
				Endif
			Endif
	        lAchou := .T.   

			For nImprVias := 1 to nVias
//				 UIMPFER()              //ExecBlock("IMPFER",.F.,.F.)

				cLinAtu		:= ""
				nCntCd		:= 0
				nConta		:= 0
				nDiaFeQueb 	:= 0 
				i             := 0
				ni            := 0
				aGozoFer      := {}
				dDataRet      := CTOD("//")
				cDiasFMes		:= ""
				cDiasFMesSeg  := ""
				cDiasAbMes	:= ""
				cDiasAbMSeg	:= ""
				cLiqReceber	:= ""
				
				nTamSpace	:= ""
				nLenCRet2	:= ""
				nTamLinha	:= ""
				nTamNomEmpresa := ""
				
				nTamSpaco	:= ""
				 
				cImpAvFer		:= SuperGetMv('MV_IMPAVF',,"1")
				cBcoDesc		:= ""
				cBcoAg		:= ""
				cBcoCta		:= ""
				cDtDisp		:= ""
				lImpBco		:= .F.
				
				oBrushC	    := TBrush():New( ,  RGB(228, 228, 228)  )
				oBrushI	    := TBrush():New( ,  RGB(242, 242, 242)  )
				//Local PER_AQ_I,PER_AQ_F,PER_GO_I,PER_GO_F
				
				
				
				/*/
				эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
				╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
				╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддддддддд©╠╠
				╠╠ЁPrograma  Ё IMPFER   Ё Autor Ё R.H. - Aldo           Ё Data Ё 29.10.97       Ё╠╠
				╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддддддддд╢╠╠
				╠╠ЁDescri┤┘o Ё Recibo de Ferias                                                 Ё╠╠
				╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
				╠╠ЁSintaxe   Ё ImpFer(void)                                                     Ё╠╠
				╠╠юддддддддддддаддддддддаддддддддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
				╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
				ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
				
				aVerbsAbo:={}
				aVerbs13Abo:={}
				
				nColuna:=30
				nColMax:=2400
				
				oFont10	 := TFont():New("Arial", 10 , 10 ,,.F.,,,,.T.,.F.,)
				oFont10n := TFont():New("Arial", 10 , 10 ,,.T.,,,,.T.,.F.,)
				oFont11	 := TFont():New("Arial", 11 , 11 ,,.F.,,,,.T.,.F.,)
				oFont11n := TFont():New("Arial", 11 , 11 ,,.T.,,,,.T.,.F.,)
				oFont12	 := TFont():New("Arial", 12 , 12 ,,.F.,,,,.T.,.F.,)
				oFont12n := TFont():New("Arial", 12 , 12 ,,.T.,,,,.T.,.F.,)
				oFont14	 := TFont():New("Arial", 14 , 14 ,,.F.,,,,.T.,.F.,)
				oFont14n := TFont():New("Arial", 14 , 14 ,,.T.,,,,.T.,.F.,)
				oFont16  := TFont():New("Arial", 16 , 16 ,,.F.,,,,.T.,.F.,)
				oFont16n := TFont():New("Arial", 16 , 16 ,,.T.,,,,.T.,.F.,)
				
				cReplic77:= REPLICATE("_",77)
				cReplic22:= REPLICATE("_",22)
				cReplic30:= REPLICATE("_",30)
				cReplic33:= REPLICATE("_",33)
				cReplic35:= REPLICATE("_",35)
				cReplic40:= REPLICATE("_",40)
				
				nLi:=10
				
				nDBanco:=0
				
				//Dados bancАrios
				If cPaisLoc == "BRA" .And. !Empty(nDBanco) .And. nDBanco == 1 .And. !Empty(SRA->RA_BCDEPSAL) .And. !Empty(SRA->RA_CTDEPSAL)
					cDtDisp  := If( lAchou .Or. M->RH_DFERIAS > 0 .and. SRA->RA_SITFOLH <> "D", PADR(DTOC(SRH->RH_DTRECIB),10), "" )
					cBcoDesc := AllTrim( DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL) )
					cBcoAg   := AllTrim( Substr(SRA->RA_BCDEPSAL,4,5) )
					cBcoCta  := AllTrim( SRA->RA_CTDEPSAL )
					lImpBco	 := .T.
				EndIf
				
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Procura No Arquivo de Ferias o Periodo a Ser Listado         Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If lAchou
					
					dDtBusFer := SRH->RH_DATAINI
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Se Funcionario tem  dias de Licensa remunerada, entao deve-seЁ
					//Ё imprimir somente o period de gozo das ferias (conf.vlr calcu-Ё
					//Ё lado.)                                                       Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If SRH->( RH_DIALRE1 + RH_DIALREM) > 0 
						nDiaFeQueb := SRH->(RH_DFERIAS - Int(RH_DFERIAS) )
						If lSomLiR
							DaAuxF := SRH->RH_DATAFIM + If(nDiaFeQueb>0 , 1, 0 ) 
						Else
							DaAuxF := SRH->RH_DATAFIM -( SRH->( RH_DIALRE1 + RH_DIALREM ) ) + If(nDiaFeQueb>0 , 1, 0 ) 
						EndIf
				    EndIf 
				    
				
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Solicitacao 1a Parcela 13o Salario                           Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If nSol13 == 1
					Endif
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Solicitacao Abono Pecuniario                                 Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If nSolAb == 1
					Endif
				
				
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё 0 De Ferias                                              Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If nAviso == 1
				/*		If nLi > 35
							nLi := 1
						Endif
				*/
						oxprint:StartPage()
				
						oxprint:Line(nLi, nColuna ,nLi, nColMax)
				
						oxprint:Fillrect( {nLi+5, nColuna+1, nLi+55, nColMax-1 }, oBrushI, "-2") // Quadro na Cor Cinza
				
						nLi += 35
				
						oxprint:say(nLi+7, 930	, " AVISO DE FERIAS ", oFont16n)
				
						nLi += 25
				
						oxprint:Line(nLi, nColuna ,nLi, nColMax)
					
						nLi+=55
				
						IF cPaisLoc == "ANG"
							oxprint:say(nLi, 1330	, SPACE(28+(20-LEN(ALLTRIM(aInfo[5]))))+ALLTRIM(aInfo[5])+", "+SUBSTR(DTOC(SRH->RH_DTRECIB),1,2)+STR0002+MesExtenso(MONTH(SRH->RH_DTRECIB))+STR0002+STR(YEAR(SRH->RH_DTRECIB),4), oFont12n)   	//" de "###" de "
						ELSE
							oxprint:say(nLi, 1130	, SPACE(28+(20-LEN(ALLTRIM(aInfo[5]))))+ALLTRIM(aInfo[5])+", "+SUBSTR(DTOC(SRH->RH_DTAVISO),1,2)+STR0002+MesExtenso(MONTH(SRH->RH_DTAVISO))+STR0002+STR(YEAR(SRH->RH_DTAVISO),4), oFont12n)	//" de "###" de "
						ENDIF
				
						nLi+=100
				
						If cPaisLoc <> "ARG"
							oxprint:say(nLi, 30	, SPACE(07) + STR0026,	 oFont12)	//"A(O) SR(A)"
						Else
							oxprint:say(nLi, 30	, SPACE(07) + STR0115,	 oFont12)	//"SR(A)"
						EndIf
				
						nLi+=35
				
						oxprint:say(nLi, 30	, SPACE(07) + Left(SRA->RA_NOME,30) ,	 oFont12)
				                                                                                 
						nLi+=35
				
						// Se for Brasil e imprime funcionarios demitidos SIM, utilizar CC
						// da tabela SRR para buscar CC da epoca das ferias do funcionario
						dbSelectArea( "SRR" )
						SRR->(dbSetOrder(1))	
						
						If cPaisLoc == "BRA" .and. SRA->RA_SITFOLH $ "D" .and. nImprDem == 1 .and.;
							dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + "F" + Dtos(dDtBusFer) )
							cDesc := DescCc( SRR->RR_CC, SRR->RR_FILIAL )
						Else
							cDesc := DescCc( SRA->RA_CC, SRA->RA_FILIAL )
						EndIf
				
						If cPaisLoc == "BRA"
							cLinha:=  SPACE(07) + STR0027 + SRA->RA_NUMCP+" - "+SRA->RA_SERCP+SPACE(48)+"C.CUSTO: " //"CTPS = "
						ElseIf !( cPaisLoc $ "ARG|ANG" )
							cLinha:=  SPACE(07) + STR0027 + SRA->RA_NUMCP+" - "+SRA->RA_SERCP+SPACE(48)+STR0028	//"CTPS = "###"DEPTO: "
						ElseIF cPaisLoc == "ANG"
						    cLinha:=  SPACE(07) + STR0028	//"###"DEPTO: "
						else
							cLinha:=  SPACE(07) + STR0116 + SRA->RA_NUMCP+" - "+SRA->RA_SERCP+SPACE(48)+STR0028	//"CTPS = "###"DEPTO: "
						EndIf
						
						cLInha:= cLinha+AllTrim(cDesc)
						oxprint:say(nLi, 30	, cLinha,	 oFont12)
				
						lDepto	:= CpoUsado("RA_DEPTO") .And. !EMPTY(SRA->RA_DEPTO)
						IF lDepto 
							nLi+=35
							oxprint:say(nLi, 500	, SPACE(37) + STR0028 + ( fDesc('SQB',SRA->RA_DEPTO,'QB_DESCRIC') ) ,	 oFont12)
						EndIF
				
						nLi+=100
				
						oxprint:say(nLi, 30, SPACE(16) + "Nos termos da legislaГЦo vigente, suas fИrias serЦo concedidas conforme o demonstrativo abaixo:", oFont14)
						nLi+=75
				
						If (SRH->RH_DIALRE1 + SRH->RH_DIALREM) > 0 
//							oxprint:say(nLi, 920	, SPACE(89) + STR0033,	 oFont14) 
							nLi+=35                                            //
/////STR0148
							oxprint:say(nLi, 300	, STR0031+SPACE(28)+Iif(lSomLiR,"Periodo de Gozo:",STR0032)+Iif(lSomLiR,SPACE(26),SPACE(07))+STR0122+SPACE(15)+"Retorno ao Trabalho",	 oFont14) //"Periodo Aquisitivo:"###"Periodo de Gozo:"###"Retorno ao Trabalho:" 
							nLi+=35
					 		oxprint:say(nLi, 300	, PADR(DTOC(SRH->RH_DATABAS),10)+' A '+PADR(DTOC(SRH->RH_DBASEAT),18)+SPACE(01)+If(SRH->RH_DIALREM == 30,STR0125,PADR(DTOC(DAAUXI),10)+STR0034+PADR(DTOC(DAAUXF),10))+SPACE(36)+(CVALTOCHAR(SRH->RH_DIALRE1 + SRH->RH_DIALREM))+SPACE(29)+PADR(DTOC(SRH->RH_DATAFIM+1),10),	 oFont14)	//" A "###" A "
							nLi+=50
						 Else
					   		oxprint:say(nLi, 300	, "Periodo Aquisitivo:"+SPACE(28)+"Periodo de Gozo:"+SPACE(26)+"Retorno ao Trabalho:",	 oFont14)
							nLi+=50
							
							IF cPaisLoc == "ANG"
								oxprint:say(nLi, 300	, DTOC(SRH->RH_DATABAS)+" A "+DTOC(SRH->RH_DBASEAT)+SPACE(18)+Dtoc(DAAUXI)+" A "+Dtoc(DAAUXF)+SPACE(26)+dDataRet,	 oFont14)	//" A "###" A "
								
								IF len(aGozoFer) > 1
									For ni=2 to len(aGozoFer)
										nLi++
							    		DAAUXI   := aGozoFer[ni][1]
							    		DAAUXF   := aGozoFer[ni][2]
							    		oxprint:say(nLi, 300	, Dtoc(DAAUXI)+" A "+Dtoc(DAAUXF),	 oFont14)	
							  		Next i
								Endif
							Else
								oxprint:say(nLi, 300	, PADR(DTOC(SRH->RH_DATABAS),10)+" A "+PADR(DTOC(SRH->RH_DBASEAT),10)+SPACE(18)+PADR(DTOC(DAAUXI),10)+" A "+PADR(DTOC(DAAUXF),10)+SPACE(26)+PADR(DTOC(DAAUXF+1),10),oFont14)
							Endif
						EndIf
				
						nLi+=75
				
						If cPaisLoc <> "ARG"
							If cImpAvFer == "1"
				                oxprint:say(nLi, 30, SPACE(16) + "A remuneraГЦo correspondente as fИrias e, se for o caso, ao abono pecuniАrio e ao adiantamento da gratificaГЦo de natal," ,	 oFont14)    //STR0035"A remuneracao correspondente as ferias e, se for o  caso,"
								nLi += 35
				                oxprint:say(nLi, 30, SPACE(07) + "encontra-se no caixa e poderА ser recebida no dia " +PADR(DTOC(SRH->RH_DTRECIB),10)+"." ,	 oFont14)
								nLi += 35
								If lImpBco
									oxprint:say(nLi, 30, SPACE(07) + "Banco: " + cBcoDesc ,	 oFont14)
									nLi += 35
									oxprint:say(nLi, 30, SPACE(07) + "Agencia/Conta: " + cBcoAg + "/" + cBcoCta ,	 oFont12)
									nLi += 35
								EndIf
				                oxprint:say(nLi, 30	, SPACE(16) + "Solicitamos apresentar a sua carteira de trabalho e previdЙncia social ao depto pessoal para as anotaГУes necessАrias.", oFont14)
								nLi += 35
				            Else
				                oxprint:say(nLi, 30	, SPACE(16) + "Solicitamos apresentar a sua carteira de trabalho e previdЙncia social ao depto pessoal para as anotaГУes necessАrias.", oFont14)    //"Solicitamos  apresentar  a  sua  carteira  de trabalho  e"
								nLi += 35
				            EndIF
						EndIf	
				
						nLi += 75
				        
						oxprint:say(nLi, 30	, SPACE(02) + cReplic40+SPACE(60)+cReplic33+SPACE(01),	 oFont14)
						nLi += 40
						oxprint:say(nLi, 30	, SPACE(02) + SubStr(aInfo[3]+Space(40),1,40)+SPACE(65)+Left(SRA->RA_NOME,30),	 oFont14)
				
						nLi := nLi + 75
				
					Endif
				
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Recibo De Abono                                              Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If nRecAb == 1
					Endif
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Recibo De 13o Salario                                        Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If nRec13 == 1
					Endif
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Recibo De Ferias                                             Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If nRecib == 1
						
						aPdv  := {}
						aPdd  := {}
						cRet1 := ""
						cRet2 := ""
						
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Posiciona Arq. SRR Para Guardar na Matriz as Verbas De FeriasЁ
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If Empty( nOrdSRR )
							nOrdSRR := RetOrder( "SRR", "RR_FILIAL+RR_MAT+RR_TIPO3+DTOS(RR_DATA)+RR_PD+RR_CC" )
						EndiF
						
						dbSelectArea("SRR")
						dbSetOrder(nOrdSRR)
						If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + "F" )
							While ! Eof() .And. SRA->RA_FIlIAL + SRA->RA_MAT + "F" == SRR->RR_FILIAL + SRR->RR_MAT + SRR->RR_TIPO3
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Verifica Verba For Abono Ou 13o Esta $ Na Variavel Nao Lista Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
								If AScan(aVerbsAbo, SRR->RR_PD ) == 0 .And.;
									AScan(aVerbs13Abo, SRR->RR_PD ) == 0 .And.;
									SRR->RR_PD # cPd13o .And. SRR->RR_PD # aCodFol[102,1] .And.; 					
									AScan(aCodBenef, { |x| x[1] == SRR->RR_PD }) == 0
									
									If SRR->RR_DATA == dDtBusFer
										If PosSrv( SRR->RR_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
											AAdd(aPdv , { SRR->RR_PD , SRR->RR_VALOR })
										ElseIf PosSrv( SRR->RR_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"
											AAdd(aPdd , { SRR->RR_PD , SRR->RR_VALOR })
										Endif
									Endif
									
								Endif
								dbSkip()
							Enddo
							
							PER_AQ_I := STRZERO(DAY(SRH->RH_DATABAS),2)+STR0067+MesExtenso(MONTH(SRH->RH_DATABAS))+STR0067+STR(YEAR(SRH->RH_DATABAS),4)	//" De "###" De "
							PER_AQ_F := STRZERO(DAY(SRH->RH_DBASEAT),2)+STR0067+MesExtenso(MONTH(SRH->RH_DBASEAT))+STR0067+STR(YEAR(SRH->RH_DBASEAT),4)	//" De "###" De "
							PER_GO_I := STRZERO(DAY(DAAUXI),2)+STR0067+MesExtenso(MONTH(DAAUXI))+STR0067+STR(YEAR(DAAUXI),4)		//" De "###" De "
							PER_GO_F := STRZERO(DAY(DAAUXF),2)+STR0067+MesExtenso(MONTH(DAAUXF))+STR0067+STR(YEAR(DAAUXF),4)		//" De "###" De "
				
							oxprint:Line(nLi, nColuna ,nLi, nColMax)
							oxprint:Fillrect( {nLi+5, nColuna+1, nLi+55, nColMax-1 }, oBrushI, "-2") // Quadro na Cor Cinza
				
							nLi += 25
							oxprint:say(nLi+9, 930	, STR0068	, oFont16n)	//" RECIBO DE FERIAS "
							nLi += 25
							oxprint:Line(nLi, nColuna ,nLi, nColMax)
							nLi += 55
							oxprint:say(nLi, 30	, "Nome do Empregado.......: "+Left(SRA->RA_NOME,30)+SPACE(020), oFont14)			//"STR0069| Nome do Empregado.......: "
							nLi += 35
							
							If ! (cPaisLoc $ "ARG|ANG")
								oxprint:say(nLi, 30	, "Carteira Trabalho.............: " + If(Empty(SRA->RA_NUMCP),Space(7),AllTrim(SRA->RA_NUMCP))+" - "+SRA->RA_SERCP+;		//"STR0070| Carteira Trabalho.......: "
								SPACE(04)+"          Registro..:   "+SRA->RA_FILIAL+" "+SRA->RA_MAT, oFont14)					//STR0071 "Registro: "
								nLi += 35
							Else
								cLinAtu := STR0071+"        "+SRA->RA_FILIAL+" "+SRA->RA_MAT
								oxprint:say(nLi, 530	, cLinAtu , oFont14)	//"Registro: "
								nLi += 35
							EndIf
									
							oxprint:say(nLi, 30	, "PerМodo Aquisitivo............: "+PER_AQ_I+STR0073+PER_AQ_F,	 oFont14)  //"| Periodo Aquisitivo......: "###" A "
							nLi += 35
							
							IF cPaisLoc <> "ANG"
								PER_GO_I := STRZERO(DAY(DAAUXI),2)+STR0067+MesExtenso(MONTH(DAAUXI))+STR0067+STR(YEAR(DAAUXI),4)		//" De "###" De "
								PER_GO_F := STRZERO(DAY(DAAUXF),2)+STR0067+MesExtenso(MONTH(DAAUXF))+STR0067+STR(YEAR(DAAUXF),4)		//" De "###" De "
	
								oxprint:say(nLi, 30	, "PerМodo Gozo das FИrias.: "+PER_GO_I+' a '+PER_GO_F ,oFont14)	//"| Periodo Gozo das Ferias.: "###" A " 
								nLi += 35
							ELSE
				
							    For i=1 to Len(aGozoFer)
							    	
									PER_GO_I := STR(DAY(aGozoFer[i][1]),2)+STR0067+MesExtenso(MONTH(aGozoFer[i][1]))+STR0067+STR(YEAR(aGozoFer[i][1]),4)		//" De "###" De "
									PER_GO_F := STR(DAY(aGozoFer[i][2]),2)+STR0067+MesExtenso(MONTH(aGozoFer[i][2]))+STR0067+STR(YEAR(aGozoFer[i][2]),4)		//" De "###" De "
							    	
							    	oxprint:say(nLi, 30	, STR0074+PER_GO_I+STR0073+PER_GO_F ,oFont14)
						    		nLi:=nLi+35
							       
							    	IF i <> Len(aGozoFer)
							    		nLi:=nLi+35
							    	ENDIF
							    	
							    Next i
							    
							Endif
				
							oxprint:say(nLi, 30	,  "Qtde. Dias Lic. Remun.....: " + cValToChar(SRH->RH_DIALRE1 + SRH->RH_DIALREM),oFont14)			//"| Qtde. Dias Lic. Remun...: "
							nLi += 35
							oxprint:Line(nLi, nColuna ,nLi, nColMax)
							oxprint:Fillrect( {nLi+5, nColuna+1, nLi+55, nColMax-1 }, oBrushI, "-2") // Quadro na Cor Cinza
							nLi += 35
							oxprint:say(nLi+7, 30	, STR0126 ,oFont14)
							nLi += 35
							oxprint:Line(nLi, nColuna ,nLi, nColMax)
							nLi += 35
							oxprint:say(nLi,  30	, "SalАrio MЙs.........: "   + Transform(SRH->RH_SALMES,"@E 999,999.99"),oFont14)
							oxprint:say(nLi, 630	, "SalАrio Hora...............: " + Transform(SRH->RH_SALHRS,"@E 999,999.99"),oFont14)
							nLi += 35
							oxprint:say(nLi,  30	, "Valor Dia MЙs.....: "   + Transform(SRH->RH_SALDIA,"@E 999,999.99"),oFont14)
							oxprint:say(nLi, 630	, "Valor Dia MЙs Seg.....: " + Transform(SRH->RH_SALDIA1,"@E 999,999.99"),oFont14)
							nLi += 35
							
							cDiasFMes := If(SRR->(dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + "F" +; 
													Dtos(dDtBusFer) + aCodFol[072,1])), Transform(SRR->RR_HORAS, "@E 999,999.99"), Space(11))
													
							cDiasFMesSeg := If(SRR->(dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + "F" +; 
														Dtos(dDtBusFer) + aCodFol[073,1])), Transform(SRR->RR_HORAS, "@E 999,999.99"), Space(11))									
							
							oxprint:say(nLi,  30	, "Dias FИrias MЙs.: " + cDiasFMes ,oFont14)
							oxprint:say(nLi, 630	, "Dias Ferias Mes Seg..: " + cDiasFMesSeg,oFont14)
							
							cDiasAbMes := If(SRR->(dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + "F" +; 
														Dtos(dDtBusFer) + aCodFol[074,1])), Transform(SRR->RR_HORAS, "@E 999,999.99"), Space(11))
													
							cDiasAbMSeg := If(SRR->(dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + "F" +; 
														Dtos(dDtBusFer) + aCodFol[205,1])), Transform(SRR->RR_HORAS, "@E 999,999.99"), Space(11))												
							
							nLi += 35
							oxprint:say(nLi,  30	, "Dias Abono MЙs.: " + cDiasAbMes ,oFont14)
							oxprint:say(nLi, 630	, "Dias Abono MЙs Seg.: " + cDiasAbMSeg,oFont14)
							nLi += 35
							oxprint:Line(nLi, nColuna ,nLi, nColMax)
							oxprint:Fillrect( {nLi+5, nColuna+1, nLi+55, nColMax-1 }, oBrushI, "-2") // Quadro na Cor Cinza
							nLi += 35
							oxprint:say(nLi,  30	, "P R O V E N T O S"  ,oFont14)
							oxprint:say(nLi,1230	, "D E S C O N T O S"  ,oFont14)
							nLi += 30
							oxprint:Line(nLi, nColuna ,nLi, nColMax)
							nLi += 35
							//Cod##Verba##Q/H##Valor
							oxprint:say(nLi,  30	, "Cod"   ,oFont14)
							oxprint:say(nLi, 130	, "Verba" ,oFont14)
							oxprint:say(nLi, 630	, "Q/H"   ,oFont14)
							oxprint:say(nLi, 980	, "Valor" ,oFont14)
				
							nxLI:=nLi-35
				
							oxprint:say(nLi,1230 , "Cod"   ,oFont14)
							oxprint:say(nLi,1330 , "Verba" ,oFont14)
							oxprint:say(nLi,1830 , "Q/H"   ,oFont14)
							oxprint:say(nLi,2180 , "Valor" ,oFont14)
											
							nLi += 20
				
							oxprint:Line(nLi, nColuna ,nLi, nColMax)
				
							nLi += 35
							
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Impressao das Verbas                                         Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							nMaximo := MAX(Len(aPDV),Len(aPdd))
							SRR->(DbSetOrder(1))
				
							For nConta :=1 TO nMaximo
							
								If nConta > Len(aPdv)
									DET := Space(37)
								Else
									SRR->(DbSeek(SRA->RA_FILIAL + SRA->RA_MAT + "F" + DToS(dDtBusFer) + aPdv[nConta,1]) )
									nQtdHoras := SRR->RR_HORAS
									cDesc := Left(DescPd(aPdv[nConta,1],SRA->RA_FILIAL),15)
				//					DET := aPdv[nConta,1] + " " + cDesc + " " + Transform(nQtdHoras, '@E 99.99') + " " + Transform(aPdv[nConta,2],'@E 999,999.99')
				
									oxprint:say(nLi, 30	, aPdv[nConta,1] ,oFont14)
									oxprint:say(nLi, 130	, cDesc ,oFont14)
									oxprint:say(nLi, 630	, Transform(nQtdHoras, '@E 99.99') ,oFont14)
									oxprint:say(nLi, 930	, Transform(aPdv[nConta,2],'@E 999,999.99') ,oFont14)
								EndIf
							
								If nConta > Len(aPdd)
									DET := Space(37) 
								Else
									SRR->(DbSeek(SRA->RA_FILIAL + SRA->RA_MAT + "F" + DToS(dDtBusFer) + aPdd[nConta,1]) )
									nQtdHoras := SRR->RR_HORAS
									cDesc := Left(DescPd(aPdd[nConta,1],SRA->RA_FILIAL),15)
				//					DET += aPdd[nConta,1] + " " + cDesc + " " + Transform(nQtdHoras, '@E 99.99') + " " + Transform(aPdd[nConta,2],'@E 999,999.99')
				
									oxprint:say(nLi,1230	, aPdv[nConta,1] ,oFont14)
									oxprint:say(nLi,1330	, cDesc ,oFont14)
									oxprint:say(nLi,1830	, Transform(nQtdHoras, '@E 99.99') ,oFont14)
									oxprint:say(nLi,2130	, Transform(aPdd[nConta,2],'@E 999,999.99') ,oFont14)
				
								EndIf
				
								nLi += 35
								fVerQuebra(@nLi)
							
							Next
				
							nTvp := 0.00
							nTvd := 0.00
							AeVal(aPdv,{ |X| nTVP:= nTVP + X[2]})    // Acumula Valores
							AeVal(aPdd,{ |X| nTVD:= nTVD + X[2]})
							
							oxprint:Line(nLi, nColuna ,nLi, nColMax)
							nLi += 35
							oxprint:say(nLi,  30, "Total Proventos......:            "+Trans(nTvp,"@E 999,999,999.99") ,oFont14)
							oxprint:say(nLi,1230, "Total Descontos......:            "+Trans(nTvd,"@E 999,999,999.99") ,oFont14)
							nLi += 20
							fVerQuebra(@nLi)
				
							oxprint:Line(nLi, nColuna ,nLi, nColMax)
							oxprint:Line(nxLi, 1200 ,nLi, 1200)
				
							nLi += 35
							fVerQuebra(@nLi)
							cLiqReceber := Trans(nTvp-nTvd,"@E 999,999,999.99") 														
							oxprint:say(nLi, 30, "Liquido a receber...:            "  + cLiqReceber  ,oFont14)             //"| Liquido a receber.." +Trans(nTvp-nTvd,"@E 999,999,999.99")
							nLi += 20
							fVerQuebra(@nLi)
							oxprint:Line(nLi, nColuna ,nLi, nColMax)
							nLi += 65
							fVerQuebra(@nLi)
							oxprint:say(nLi, 30, STR0082 + SubStr(aInfo[3]+Space(40),1,40) + Space(23)  ,oFont14)	//"Recebi da: "
							nLi += 35
							fVerQuebra(@nLi)
							oxprint:say(nLi, 30, STR0083 + SubStr(aInfo[4]+Space(30),1,30)+STR0084+SubStr(aInfo[7]+Space(8),1,8) ,oFont14)		//"Estabelecida a "###"   -  Cep: "
							nLi += 35
							fVerQuebra(@nLi)
							oxprint:say(nLi, 30, STR0085 + SubStr(aInfo[5]+Space(25),1,25)+STR0086+aInfo[6] + Space(27) ,oFont14)	//"Cidade: "###"   -     UF: "
							cExt   := EXTENSO(nTvp-nTvd,.F.,1)
							
							SepExt(cExt,52,77,@cRet1,@cRet2)
							
							nLi += 65
							fVerQuebra(@nLi)
							oxprint:say(nLi, 30	, 'Em ' + SubStr(aInfo[5]+Space(20),1,20)+", "+StrZero(Day(SRH->RH_DTRECIB),2)+" de "+SubStr(MesExtenso(Month(SRH->RH_DTRECIB))+Space(9),1,9) + ' de ' + STR(YEAR(SRH->RH_DTRECIB),4) + ' a importancia de ' ,oFont14)	//"|  em "###"  de  "###"  de  "###" a importancia de      |"
							nLi += 35
							fVerQuebra(@nLi)
							oxprint:say(nLi, 30	, "R$ " + TRANSFORM(nTvp-nTvd,"@E 999,999,999.99")+" ("+cRet1+" "+cRet2+".****)" ,oFont14)  	//"|  R$ "
				
							nLi += 35
							fVerQuebra(@nLi)
							oxprint:say(nLi, 30	, "que me paga adiantadamente por motivo das minhas fИrias regulamentares, ora concedidas que vou gozar de acordo com a descriГЦo acima," ,oFont14)
							
							IF cPaisLoc <> "ANG"
								nLi += 35
								fVerQuebra(@nLi)
								oxprint:say(nLi, 30, 'tudo conforme o aviso que recebi em tempo, ao qual dei meu ciente.' ,oFont14)
							ENDIF
							
							nLi += 55
							fVerQuebra(@nLi)
							oxprint:say(nLi, 30	,  'Para clareza e documento, firmo o presente recibo, dando a firma plena e geral quitaГЦo.' ,oFont14)
							nLi += 105
							fVerQuebra(@nLi)
				
							//Impressao dos dados bancarios
							If lImpBco
								oxprint:say(nLi, 30	, "A importБncia serА disponibilizada em: " + cDtDisp	 ,oFont14)				    // "A importБncia serА disponibilizada em: "
								nLi += 35
								fVerQuebra(@nLi)
								oxprint:say(nLi, 30	, "Banco: " + cBcoDesc ,oFont14)					// "Banco: " STR0144
								nLi += 35
								fVerQuebra(@nLi)
								oxprint:say(nLi, 30	, "AgЙncia/Conta: " + cBcoAg + "/" + cBcoCta	 ,oFont14)  // "AgЙncia/Conta: "
								nLi += 35
								fVerQuebra(@nLi)
								nLi += 65
								fVerQuebra(@nLi)
							EndIf
				
							If nDtRec == 1
								oxprint:say(nLi, 30	, ALLTRIM(aInfo[5])+", "+StrZero(Day(SRH->RH_DTRECIB),2)+STR0097+MesExtenso(MONTH(SRH->RH_DTRECIB))+STR0097+STRZERO(YEAR(SRH->RH_DTRECIB),4) ,oFont14)	//" de "###" de "
								nLi += 35
							Else
								nLi += 35
							Endif
				
							nLi += 195
							fVerQuebra(@nLi)
							oxprint:say(nLi, 30, "Assinatura do Empregado: _______________________________________" ,oFont14)
							nLi += 55
							fVerQuebra(@nLi)
							
						Endif
					Endif
				
				
					//imprimir QRCODE aqui - 27/11/19 - Antonio
					
					//C_FILEPRINT -> Esta padronizado como Filial + Matricula + Nome do Funcionario + 'Ficha de registro'
					If AllTrim(SRA->RA_FILIAL)=='01'
						c_NomFil := "STN_"
					ElseIf AllTrim(SRA->RA_FILIAL)=='08'
						c_NomFil := "PNP2_"
					ElseIf AllTrim(SRA->RA_FILIAL)=='09'
						c_NomFil := "PNP1_"
					Else
						c_NomFil := "OUTRA_"
					EndIf
					
					c_FilePrint:=c_NomFil + SRA->RA_MAT + " - " + Alltrim(SRA->RA_NOMECMP) + "_RECIBO DE FERIAS"
				
//					nLi += 100
				
					oxprint:QrCode(2900, 1850,c_filePrint, 100)                          //impressao do QRCODE - ESTE и O CORRETO PARA IMPRESSAO NA IMPRESSORA
					
					//imprimir QRCODE aqui - 27/11/19 - Antonio
				
				
				//	nLi += 35
				 //	oxprint:Line(nLi, nColuna ,nLi, nColMax)
				
					oxprint:EndPage() 
				Else
					//--> Impressao do Aviso de Ferias e/ou Sol.Abono e/ou Sol. 1.Parc. 13. sem ter calculado.
					//--> Se nao ha calculo gerado o CC para as apcoes abaixo a ser utilizado eh da tabela SRA.
				Endif



			Next nImprVias
			lImpAv := .F.
	    Next nCnt

    EndIf
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Imprime Aviso de Ferias Caso nao tenha calculado             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды	
	If lImpAv
	   FImprAvi(lTemCpoProg)
	Endif

	dbSelectArea("SRA")
	dbSkip()
Enddo


	oxPrint:Preview()

   
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Termino do relatorio                                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea("SRA")
Set Filter to 
dbsetorder(1)
   
Set Device To Screen
If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif
MS_FLUSH()

//*------------------------------------------
Static Function FImprAvi(lTemCpoProg)
//*------------------------------------------
Local dDtIniProg,nDiasAbono,nDiasFePro,nDiasDedFer
Local nImprVias

If nAviso==1 .or. nSolAb==1 .or. nSol13==1 // Imprimi Aviso e/ou Sol.Abono e/ou Sol1.Parc.13. sem calcular
	//-- Verifica se no Arquivo SRF Existe Periodo de Ferias
	dbSelectArea("SRF")
	If dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
		dDtIniProg := CTOD("")
		nDiasFePro := 0
		nDiasAbono := 0
		If SRF->RF_DATAINI >= dDtfDe .And. SRF->RF_DATAINI <= dDtfAte
			dDtIniProg := SRF->RF_DATAINI                    
			nDiasFePro := If(lTemCpoProg, SRF->RF_DFEPRO1, 0)
			nDiasAbono := If(lTemCpoProg, SRF->RF_DABPRO1, 0)
		ElseIf lTemCpoProg
			If SRF->RF_DATINI2 >= dDtfDe .And. SRF->RF_DATINI2 <= dDtfAte
				dDtIniProg := SRF->RF_DATINI2
				nDiasFePro := SRF->RF_DFEPRO2
				nDiasAbono := SRF->RF_DABPRO2
			ElseIf SRF->RF_DATINI3 >= dDtfDe .And. SRF->RF_DATINI3 <= dDtfAte
				dDtIniProg := SRF->RF_DATINI3
				nDiasFePro := SRF->RF_DFEPRO3
				nDiasAbono := SRF->RF_DABPRO3
			EndIf
		EndIf
		If !Empty(dDtIniProg)
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Carrega Matriz Com Dados da Empresa                          Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды				
			fInfo(@aInfo,SRA->RA_FILIAL)
			nDferven := nDferave := 0
			If SRF->RF_DVENPEN > 0 .And. !Empty(SRF->RF_IVENPEN)
		 		M->RH_DATABAS := SRF->RF_IVENPEN
				M->RH_DBASEAT := SRF->RF_FVENPEN
				nDferven       := SRF->RF_DVENPEN
			Else
		  		M->RH_DATABAS := SRF->RF_DATABAS
				M->RH_DBASEAT := fCalcFimAq(SRF->RF_DATABAS)
				If nDiasFePro > 0
					nDferven := nDiasFePro
				Else
					Calc_Fer(SRF->RF_DATABAS,dDatabase,@nDferven,@nDferave)
					nDferven := If (nDferVen <= 0,nDferave,nDferven)
				EndIf
			EndIf
			
			nDiasAviso 		:= GetNewPar("MV_AVISFER",aTabFer[3])  // Dias Aviso Ferias
			
			If !empty(SRF->RF_ABOPEC)
				cAboPec := SRF->RF_ABOPEC
			Else	          
				cAboPec := cAboAnt		//-- cAboPec = 1 -> considera abono antes do periodo de gozo de ferias 
			EndIf

			M->RH_DTAVISO  := fVerData(dDtIniProg - (If (nDiasAviso > 0, nDiasAviso,aTabFer[3]))) 
			M->RH_DFERIAS  := If( nDFerven > aTabFer[3] , aTabFer[3] , nDFerven )
			M->RH_DTRECIB  := If(cAboPec=="1" .and. nDiasAbono > 0,DataValida(DataValida((dDtIniProg-nDiasAbono)-1,.F.)-1,.F.), DataValida(DataValida(dDtIniProg-1,.F.)-1,.F.))
			M->RF_TEMABPE  := SRF->RF_TEMABPE
	
			If SRF->RF_TEMABPE == "S" .And. !lTemCpoProg
				M->RH_DFERIAS -= If(nDiasAbono > 0, nDiasAbono, 10)
			Endif

			//--Abater dias de ferias Antecipadas
			If SRF->RF_DFERANT > 0
				M->RH_DFERIAS := Min(M->RH_DFERIAS, aTabFer[3]-SRF->RF_DFERANT)
			Endif

			// Abate Faltas  do cad. Provisoes 
			If SRF->RF_DFALVAT > 5
				nDFaltaV:= SRF->RF_DFALVAT
				TabFaltas(@nDFaltaV)                                                    

				If (nDFaltaV > 0 .and. nDiasAbono > 0 ) 
				            
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё  Se tiver faltas e abono, calcular os dias de ferias\abono proporcional as faltas.|
				//Ё	 Exemplo: 20 dias ferias                                                          |
		   	    //Ё	          10 dias de abono e                                                      |
				//Ё 		  10 Faltas = deduzir 6 dias das ferias. 		 					      |
				//Ё           Regra do abono: 1/3 dos dias de ferias.                                 |
				//Ё			  Como funcionario teve 10 faltas, ele tem direito a apenas 24 dias de    |
				//Ё           ferias, e nao 30. Os dias de feria e abono devem ser proporcionais aos  |
				//Ё           dias de direito de ferias.                                              |
				//Ё           Dias de Direito = 24													  |
   		        //Ё           Dias de Abono   =  8 (24 / 3 = 1/3 dos dias de direito )                |
   	    	    //Ё           Dias de Ferias  = 16 (24 - 8 dias de abono) 							  |
   	    	    //Ё           Total de Ferias + Abono  = 24 Dias 									  |
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

					nDiasDedFer   := ( nDiasFePro - ( nDFaltaV - nDiasAbono ) )
					
					If nDiasDedFer > 0  
						M->RH_DFERIAS := nDiasDedFer - NoRound( ( ( nDiasFePro + nDiasAbono ) - nDFaltaV ) / 3 )
					Else	
						M->RH_DFERIAS -= (nDFaltaV)				
					EndIf	
	
				Else	
					M->RH_DFERIAS -= (nDFaltaV)
				EndIf	
			Endif			
	
			DaAuxI := dDtIniProg
			DaAuxF := dDtIniProg + M->RH_DFERIAS - 1
	
			If M->RH_DFERIAS > 0
				For nImprVias := 1 to nVias
					UIMPFER()              //ExecBlock("IMPFER",.F.,.F.)
				Next

				oPrint:Preview()

			Endif
		EndIf
	Endif
Endif	

Return

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁAjustaSx1 ╨Autor  ЁLuis Ricardo Cinalli╨ Data Ё  23/11/2010 ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁAjuste de  perguntas.                                       ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё GPER130                                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/ 
Static Function AjustaSx1()
Local aArea		:= GetArea()
Local aRegs		:= {}
Local aHelpPor	:= {}
Local aHelpSpa	:= {}
Local aHelpEng	:= {}
Local aHelpP	:= {}
Local aHelpS	:= {}
Local aHelpE	:= {}

//Atualiza Help
AADD(aHelpPor, 'Informe se o recibo deve ser impresso '	)
AADD(aHelpPor, 'para funcionАrios demitidos:'			)
AADD(aHelpPor, '  Sim - Imprime func. demitidos ou'		)
AADD(aHelpPor, '  NЦo - NЦo Imprime func. demitidos.'	)
AADD(aHelpSpa, ' ' )
AADD(aHelpEng, ' ' )

/* Ajusta Perguntas
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё           Grupo  Ordem Pergunta Portugues		Pergunta Espanhol	Pergunta Ingles		Variavel	Tipo  	Tamanho Decimal Presel	GSC		Valid			Var01      	Def01       DefSPA1     DefEng1      Cnt01   Var02  	Def02   	         DefSpa2              DefEng2	   	      Cnt02     Var03 	Def03    	DefSpa3   	DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp    Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
aAdd(aRegs,{cPerg,"22","Imprime Demitidos ?"	,"" 				,""					,"mv_chM"	,"N"	,1		,0		,2		,"C"	,"NaoVazio"		,"mv_par22"	,"Sim"	   ,"Si"		,"Yes"		,"2"	 ,""		,"Nao"		        ,"No"	             ,"No"		   	    ,""			,""		,""			,""			,""				,""		,""		,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,"" 	,"S"	,aHelpPor	,aHelpSpa	,aHelpEng	,""		})

ValidPerg( aRegs, cPerg, .T. )


AADD(aHelpP, "Informe a quantidade de dias prИvios ")
AADD(aHelpP, "para gerar o abono pecuniАrio. ")
AADD(aHelpP, "MМnimo de 15 dias." )
AADD(aHelpS, "")
AADD(aHelpE, "")

PutSX1Help("P"+"GPEIMPAP",aHelpP,aHelpS,aHelpE)

aAdd(aRegs,{cPerg,"23","Dias PrИvios P/ Ab. Pecun?"	,"Dias PrИvios P/ Ab. Pecun?" 				,"Dias PrИvios P/ Ab. Pecun?"					,"mv_chN"	,"N"	,3		,0		,1		,"C"	,"uFAbPecun()"		,"mv_par23"	,""	   ,""		,""		,"15"	 ,""		,""		        ,""	             ,""		   	    ,""			,""		,""			,""			,""				,""		,""		,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,"" 	,"S"	,aHelpP	,aHelpS	,aHelpE	,"GPEIMPAP"		})

ValidPerg( aRegs, cPerg, .T. )

RestArea( aArea )

Return

/*/
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁuFAbPecun	╨Autor  ЁGustavo M.			 ╨ Data Ё  22/06/2012 ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁAjuste de  perguntas.                                       ╨╠╠
╠╠╨          Ё                                                            ╨╠╠ 
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё GPER130                                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠ /*/ 

Static Function uFAbPecun()
      
IF MV_PAR23 < 15      
	MsgInfo( OemToAnsi('Ab. Pecun') )
	MV_PAR23 := 15
Endif	     

Return





/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁfBusGozo  ╨Autor  ЁTiago Malta         ╨ Data Ё  04/03/10   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     Ё  FunГЦo que busca os periodos e dias de Desfrute de Ferias ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё AP                                                         ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠ 
╠╠ЁParametrosЁ dIni - Data inicial do periodo aquisitivo                  Ё╠╠
╠╠Ё          Ё dFim - Data Final do periodo aquisitivo                    Ё╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function fBusGozo(dIni,dFim)

Local aArea		:= SRH->( GetArea() )
Local aGozoFer  := {}

	dbSelectArea("SRH")
	DBSETORDER(1)
	SRH->( DBSEEK(xFilial("SRH")+ SRH->RH_MAT  ))
	
    While SRH->( !EOF() ) .AND. SRH->RH_MAT == SRA->RA_MAT
       	IF SRH->RH_DATABAS == dIni .AND. SRH->RH_DBASEAT == dFim
			aAdd( aGozoFer , { SRH->RH_DATAINI, SRH->RH_DATAFIM ,SRH->RH_DFERIAS } )
    	ENDIF
	    SRH->( DBSKIP() )
    Enddo
	
RestArea(aArea) 

Return(aGozoFer)




/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁfVerQuebra╨Autor  ЁEquipe RH           ╨ Data Ё  08/01/16   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     Ё FunГЦo que verifica se e' necessario quebra de linha       ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё GPEM030                                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠ 
╠╠ЁParametrosЁ nLinha - Linha de impressao do arquivo                     Ё╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function fVerQuebra(nLinha)

If nLinha > 2900       //60
	nLinha := 10
	nLinha := nLinha + 25
EndIf

Return
