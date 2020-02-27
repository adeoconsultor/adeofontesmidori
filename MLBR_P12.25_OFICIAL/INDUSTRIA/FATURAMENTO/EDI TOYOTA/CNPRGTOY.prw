#INCLUDE "PROTHEUS.CH"

#define STR0001  "OP's Previstas"
#define STR0002  "Firma OPs"
#define STR0003  "Exclui OPs"
#define STR0004  " Firma as OPs marcadas ?"
#define STR0005  " Deleta as OPs marcadas ?"
#define STR0006  "Selecionando Registros..."
#define STR0007  "Pesquisar"
#define STR0008  "Aten��o"
#define STR0009  "Todas as OPs intermedi�rias que possuam vinculo com alguma OP Pai marcada no Browse, ser�o firmadas, "
#define STR0010  "devido o sistema estar parametrizado para trabalhar com produ��o autom�tica (MV_PRODAUT habilitado). "
#define STR0011  "Deseja continuar o processo ?"
#define STR0012  "Sim"
#define STR0013  "N�o"
#define STR0014  "Deletando OP's previstas..."
#define STR0015  "Deletando SC's previstas..."
#define STR0016  "Deletando PC's/CP's previstos..."


//---------------------------------
/*
Este Programa faz a consulta das programacoes de entrega para os clientes conforme necessidade Toyota X Midoria Atlantica
*/
User Function CNPRGTOY ()
Local	nI			:= 0
Local 	aCampos		:= {}
Private cMarca 		:= GetMark()
Private nOrdemAtual := 1
Private oOk := LoadBitmap( GetResources(), "LBOK")
Private oNo := LoadBitmap( GetResources(), "LBNO")
//
//
//����������������������������������������������������������Ŀ
//?Define Array contendo as Rotinas a executar do programa  ?
//?----------- Elementos contidos por dimensao ------------ ?
//?1. Nome a aparecer no cabecalho                          ?
//?2. Nome da Rotina associada                              ?
//?3. Usado pela rotina                                     ?
//?4. Tipo de Transacao a ser efetuada                      ?
//?   1 - Pesquisa e Posiciona em um Banco de Dados         ?
//?   2 - Simplesmente Mostra os Campos                     ?
//?   3 - Inclui registros no Bancos de Dados               ?
//?   4 - Altera o registro corrente                        ?
//?   5 - Remove o registro corrente do Banco de Dados      ?
//?   6 - Altera determinados campos sem incluir novos Regs ?
//������������������������������������������������������������

//����������������������������������������������������������Ŀ
//?Define o cabecalho da tela de atualizacoes               ?
//������������������������������������������������������������
Private cCadastro := "Programaco de Entregas TOYOTA DO BRASIL"

Private aRotina := MenuDef()
Private aIndTmp 	:= {}
//
dbSelectArea("SZ5")
//
mBrowse( 6, 1,22,75,"SZ5",,,,,,)
//
RETURN
//----------------------------------

Static Function MenuDef()
PRIVATE aRotina	:= {	{"Pesquisar"           	,"AxPesqui"		,0,1,0,.f.},;
						{'Consulta Programacao'	,"U_VISUPRG()"	,0,4,0,.f.},;
						{'Aviso Emb/ASN'		,"U_AVEMBTOY()"	,0,2,0,.f.},;
						{'Importa EDI'			,"U_IMPEDITOY()",0,3,0,.f.}}
Return(aRotina)
//------------------------------------------------------------------------------------------------------------------
User Function VISUPRG()
u_ConsZ5( sz5->( REcno() ) )    
Return()
//------------------------------------------------------------------------------------------------------------------