#include "totvs.ch"
#define DEF_NOTA       1
#define DEF_SERIE      2
#define DEF_FORNECEDOR 3
#define DEF_LOJA       4
#define DEF_NOME       5
#define DEF_PRODUTO    6
#define DEF_DESCPROD   7
#define DEF_QUANTIDADE 8
#define DEF_ETIQUETA   9
#define DEF_OK        10
#define DEF_TAMARR    10

//========================================================================================================
// MIDR0002 - Alessandro Freire - OUTUBRO / 2015
//--------------------------------------------------------------------------------------------------------
// Descrição
// Relatório de CONFERENCIA DE LEITURA DAS ETIQUETAS
//--------------------------------------------------------------------------------------------------------
// Parametros
// nil
//--------------------------------------------------------------------------------------------------------
// Retorno
// nil
//========================================================================================================
User Function MIDR0002()

Local cPerg := "MIDR0002"
Local oPerg := AdvPlPerg():New(cPerg)                            

Private aRel := {}, nLoop := 1
               
//-------------------------------------------
// Ajusta os parâmetros
//-------------------------------------------
oPerg:AddPerg( "Nota Fiscal", "C", 09  )
oPerg:AddPerg( "Série"      , "C", 03  )
oPerg:AddPerg( "Fornecedor" , "C", 6,,,"SA2"   )
oPerg:AddPerg( "Loja"       , "C", 2   ) 

oPerg:SetPerg()
                                    
oReport := ReportDef( cPerg )
oReport:PrintDialog()

Return( nil )

//=================================================================================================================
// ReportDef() -                           Alessandro de Barros Freire                             - Outubro / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Cria o objeto que define o relatorio
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros
// nil
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================
Static Function ReportDef( cPerg )

Local oReport                  

//---------------------------------------
// Criação do componente de impressão
//---------------------------------------
// TReport():New
// ExpC1 : Nome do relatorio
// ExpC2 : Titulo
// ExpC3 : Pergunte
// ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao
// ExpC5 : Descricao
//---------------------------------------
oReport := TReport():New( cPerg , "Conferência", cPerg, {|oReport| ReportPrint(oReport)}, "Imprime a conferência das etiquetas das notas de entrada" )
oReport:SetTotalInLine(.F.)
Pergunte(oReport:uParam, .F.)

//---------------------------------------
// Criação da seção utilizada pelo relatório
//
// TRSection():New
// ExpO1 : Objeto TReport que a seção pertence
// ExpC2 : Descrição da seçao
// ExpA3 : Array com as tabelas utilizadas pela seção. A primeira tabela será considerada como principal para a seção.
// ExpA4 : Array com as ordens do relatório
// ExpL5 : Carrega campos do SX3 como celulas
// Default : False
// ExpL6 : Carrega ordens do Sindex
// Default : False
//---------------------------------------

//---------------------------------------
// Criação da celulas da seção do relatório
//
// TRCell():New
// ExpO1 : Objeto TSection que a secao pertence
// ExpC2 : Nome da celula do relatório. O SX3 será consultado
// ExpC3 : Nome da tabela de referencia da celula
// ExpC4 : Titulo da celula
// Default : X3Titulo()
// ExpC5 : Picture
// Default : X3_PICTURE
// ExpC6 : Tamanho
// Default : X3_TAMANHO
// ExpL7 : Informe se o tamanho esta em pixel
// Default : False
// ExpB8 : Bloco de código para impressao.
// Default : ExpC2
//---------------------------------------
oSection := TRSection():New(oReport, "Conferência", "CB0", /*{Array com as ordens do relatório}*/, /*Campos do SX3*/, /*Campos do SIX*/)
oSection:SetTotalInLine(.F.)

TRCell():New(oSection, "NOTA"       , "CB0", "Nota"        , "@!", Len(SF1->F1_DOC)  , /*lPixel*/, {|| aRel[1,DEF_NOTA]       } )
TRCell():New(oSection, "SERIE"      , "CB0", "Serie"       , "@!", Len(SF1->F1_SERIE), /*lPixel*/, {|| aRel[1,DEF_SERIE]      } )
TRCell():New(oSection, "FORNECEDOR" , "CB0", "Fornecedor"  , "@!", Len(SA2->A2_COD)  , /*lPixel*/, {|| aRel[1,DEF_FORNECEDOR] } )
TRCell():New(oSection, "LOJA"       , "CB0", "Loja"        , "@!", Len(SA2->A2_LOJA) , /*lPixel*/, {|| aRel[1,DEF_LOJA]       } )
TRCell():New(oSection, "NOME"       , "CB0", "Razao Social", "@!", Len(SA2->A2_NOME) , /*lPixel*/, {|| aRel[1,DEF_NOME]       } )

oSection2 := TRSection():New(oSection, "Produtos", "SD4", /*{Array com as ordens do relatório}*/, /*Campos do SX3*/, /*Campos do SIX*/)

TRCell():New(oSection2, "PRODUTO"   , "CB0", "Produto"     , "@!", Len(SB1->B1_COD)    , /*lPixel*/, {|| aRel[nLoop,DEF_PRODUTO]   } )
TRCell():New(oSection2, "DESCRICAO" , "CB0", "Descrição"   , "@!", Len(SB1->B1_DESC)   , /*lPixel*/, {|| aRel[nLoop,DEF_DESCPROD]  } )
TRCell():New(oSection2, "QUANTIDADE", "CB0", "Quantidade"  , "@E 999999.9999", 11      , /*lPixel*/, {|| aRel[nLoop,DEF_QUANTIDADE]} )
TRCell():New(oSection2, "ETIQUETA"  , "CB0", "Etiqueta"    , "@!", Len(CB0->CB0_CODETI), /*lPixel*/, {|| aRel[nLoop,DEF_ETIQUETA]  } )
TRCell():New(oSection2, "CONFERIDO" , "CB0", "Conferencia" , "@!", 10                  , /*lPixel*/, {|| aRel[nLoop,DEF_OK]        } )

oSection2:SetTotalInLine(.F.)

Return( oReport )

//=================================================================================================================
// ReportPrint() -                        Alessandro de Barros Freire                             - Outubro / 2015
//-----------------------------------------------------------------------------------------------------------------
// Descrição
// Imprime o relatório
//-----------------------------------------------------------------------------------------------------------------
// Parâmetros
// oReport - objeto contendo as definições do relatório
//-----------------------------------------------------------------------------------------------------------------
// Retorno
// nil
//=================================================================================================================

Static Function ReportPrint(oReport)

Local aArea       := GetArea()
Local cArmDest    := ""
Local nConta      := 1
Local nLoop
          
// popula aRel              
aRel := {}          
Processa( {|| aRel := DadosRel() }, "Filtrando Registros..." )

If Empty( aRel )
	MsgInfo( "Sem dados. Verifique os parâmetros informados." )
	Return( nil )
EndIf

//-------------------------------------------
// Inicio da impressao do fluxo do relatório
//-------------------------------------------
oReport:SetMeter(Len(aRel))

nLoop := 1
oReport:Section(1):Init()
oReport:Section(1):PrintLine()
oReport:Section(1):Section(1):Init()
                    
For nLoop := 1 to Len( aRel )

	If oReport:Cancel() 
		Exit
	EndIf
	                                         
	//----------------------------------------
   	// Impressão zebrada. verifica se imprime
   	// o fundo branco ou o fundo cinza            
	//----------------------------------------
	If ( nconta % 2 ) == 0
		nCor := CLR_HGRAY
	Else
		nCor := CLR_WHITE
	endIf       

	//-----------------------------------------
	// Carrega os dados de cada campo
	//-----------------------------------------
	oReport:Section(1):Section(1):Cell("PRODUTO"   ):SetClrBack(nCor) //cor da fonte
	oReport:Section(1):Section(1):Cell("DESCRICAO" ):SetClrBack(nCor) //cor da fonte
	oReport:Section(1):Section(1):Cell("QUANTIDADE"):SetClrBack(nCor) //cor da fonte
	oReport:Section(1):Section(1):Cell("ETIQUETA"  ):SetClrBack(nCor) //cor da fonte
	oReport:Section(1):Section(1):Cell("CONFERIDO" ):SetClrBack(nCor) //cor da fonte
	
	//-----------------------------------------
	// Imprime a linha
	//-----------------------------------------
	oReport:Section(1):Section(1):PrintLine()
	nConta ++

	oReport:IncMeter()

Next nLoop

oReport:Section(1):Section(1):Finish()
oReport:Section(1):Finish()
oReport:Section(1):SetPageBreak(.T.)

dbCloseArea()
RestArea( aArea )
Return( nil )

//========================================================================================================
// DadosRel - Alessandro Freire - OUTUBRO / 2015
//--------------------------------------------------------------------------------------------------------
// Descrição
// Grava os itens que devem compor o relatório em um array
//--------------------------------------------------------------------------------------------------------
// Parametros
// nil
//--------------------------------------------------------------------------------------------------------
// Retorno
// aRel - Array com os itens do relatório
// [1] Nota
// [2] Serie
// [3] Fornecedor
// [4] Loja
// [5] Etiqueta
// [6] Ok
//========================================================================================================
Static Function DadosRel( ) 


Local aArea     := GetArea()
Local aRet      := {}   
Local cAlias    := GetNextAlias()                    
Local cSql      := SqlEtiq()
         
ProcRegua(0)
IncProc("Abrindo consulta no banco de dados...")
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAlias,.f.,.t.)
dbGoTop() 

While ! Eof() 

	IncProc("Gerando dados...")
	
	AAdd( aRet, Array(DEF_TAMARR) )

	aRet[ Len(aRet) ][DEF_NOTA]       := (cAlias)->CB0_NFENT
	aRet[ Len(aRet) ][DEF_SERIE]      := (cAlias)->CB0_SERIEE
	aRet[ Len(aRet) ][DEF_FORNECEDOR] := (cAlias)->CB0_FORNEC
	aRet[ Len(aRet) ][DEF_LOJA]       := (cAlias)->CB0_LOJAFO
	aRet[ Len(aRet) ][DEF_NOME]       := (cAlias)->A2_NOME
	aRet[ Len(aRet) ][DEF_PRODUTO]    := (cAlias)->CB0_CODPRO
	aRet[ Len(aRet) ][DEF_DESCPROD]   := Posicione( "SB1",1,xFilial("SB1")+(cAlias)->CB0_CODPRO, "B1_DESC" )
	aRet[ Len(aRet) ][DEF_QUANTIDADE] := (cAlias)->CB0_QTDE
	aRet[ Len(aRet) ][DEF_ETIQUETA]   := (cAlias)->CB0_CODETI
	aRet[ Len(aRet) ][DEF_OK]         := (cAlias)->CB0_XXOKXX
	
	dbSelectArea( cAlias )                     
	dbSkip()

Enddo
            
dbSelectArea( cAlias )
dbCloseArea()                     

RestArea( aArea )
ProcRegua(0)
IncProc("Organizando dados...")
aSort( aRet,,,{|x,y| x[DEF_PRODUTO]+x[DEF_ETIQUETA] < y[DEF_PRODUTO]+y[DEF_ETIQUETA] } )

Return( aRet )
                                   
***********************************************************************************************************************************
** SqlEtiq()                                    
** Query das etiquetas
***********************************************************************************************************************************
Static Function SqlEtiq()
    
Local cSql := ""

cSql += "SELECT CB0.CB0_NFENT "
cSql += "     , CB0.CB0_SERIEE "
cSql += "     , CB0.CB0_CODETI "
cSql += "     , CB0.CB0_FORNEC "
cSql += "     , CB0.CB0_LOJAFO "
cSql += "     , SA2.A2_NOME "
cSql += "     , CASE WHEN COALESCE( CBE.R_E_C_N_O_, 0 ) = 0 THEN ' ' ELSE 'Conferida' END CB0_XXOKXX "
cSql += "     , CB0.CB0_CODPRO "
cSql += "     , CB0.CB0_QTDE "
cSql += "     , CBE.CBE_DATA "
cSql += "     , CBE.CBE_HORA "              

cSql += "  FROM "+RetSqlName("CB0")+" CB0 "

cSql += " LEFT JOIN "+RetSqlName("CBE")+" CBE ON CBE.CBE_FILIAL = '"+xFilial("CBE")+"' "
cSql += "                      AND CBE.CBE_CODETI = CB0.CB0_CODETI "
cSql += "                      AND CBE.D_E_L_E_T_ = ' ' "

cSql += "INNER JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_FILIAL = '"+xFilial("SA2")+"' "
cSql += "                      AND SA2.A2_COD = CB0.CB0_FORNEC "
cSql += "                      AND SA2.A2_LOJA = CB0.CB0_LOJAFO "
cSql += "                      AND SA2.D_E_L_E_T_ = ' ' "

cSql += " WHERE CB0.CB0_FILIAL = '"+xFilial("CB0")+"' "
cSql += "   AND CB0.CB0_NFENT =  '"+MV_PAR01+"' "
cSql += "   AND CB0.CB0_SERIEE = '"+MV_PAR02+"' "
cSql += "   AND CB0.CB0_FORNEC = '"+MV_PAR03+"' "
cSql += "   AND CB0.CB0_LOJAFO = '"+MV_PAR04+"' " 
cSql += "   AND CB0.D_E_L_E_T_ = ' ' "

cSql += "ORDER BY CB0.CB0_NFENT "
cSql += "    , CB0.CB0_SERIEE "
cSql += "    , CB0.CB0_CODPRO "
cSql += "    , CB0.CB0_CODETI "
    
Return( cSql )