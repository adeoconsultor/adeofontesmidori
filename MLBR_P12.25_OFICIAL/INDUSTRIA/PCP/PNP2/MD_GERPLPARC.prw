#INCLUDE "rwmake.ch"


//////////////////////////////////////////////////////////////////////////////
//Programa desenvolvido com o objetivo de gerar planos parciais a partir da sele��o de usuarios
//Ser� utilizado para gera��o de recorte e emparelhamento conforme sele��o do usu�rio
//Desenvolvido por Anesio G.Faria - TAGGs Consultoria - Exclusivo PNP2 - Midori Atlantica
//08-07-2011



User Function MD_GERPLPARC


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro := "Gera��o de Planos de Pe�as"

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

/*Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }                      
             
  */           
PRIVATE aRotina	:= {}
AaDd( aRotina	,	{"Pesquisar"         		,"aXPesqui"	,0,1,0,.f.} )
AaDd( aRotina	,	{'Visualizar ' 				,"AxVisual"	,0,2,0,.f.} ) 
AaDd( aRotina	,	{'Gerar Plano' 	            ,"U_MD_TGERPL(SG1->G1_COD)" ,0,5,0,.f.} )
AaDd( aRotina	,	{'Legenda '					,"u_Mid_LegPlP"   ,0,5,0,.f.} )
             
             

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SG1"

dbSelectArea("SG1")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Executa a funcao MBROWSE. Sintaxe:                                  �
//�                                                                     �
//� mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              �
//� Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   �
//�                        exibido. Para seguir o padrao da AXCADASTRO  �
//�                        use sempre 6,1,22,75 (o que nao impede de    �
//�                        criar o browse no lugar desejado da tela).   �
//�                        Obs.: Na versao Windows, o browse sera exibi-�
//�                        do sempre na janela ativa. Caso nenhuma este-�
//�                        ja ativa no momento, o browse sera exibido na�
//�                        janela do proprio SIGAADV.                   �
//� Alias                - Alias do arquivo a ser "Browseado".          �
//� aCampos              - Array multidimensional com os campos a serem �
//�                        exibidos no browse. Se nao informado, os cam-�
//�                        pos serao obtidos do dicionario de dados.    �
//�                        E util para o uso com arquivos de trabalho.  �
//�                        Segue o padrao:                              �
//�                        aCampos := { {<CAMPO>,<DESCRICAO>},;         �
//�                                     {<CAMPO>,<DESCRICAO>},;         �
//�                                     . . .                           �
//�                                     {<CAMPO>,<DESCRICAO>} }         �
//�                        Como por exemplo:                            �
//�                        aCampos := { {"TRB_DATA","Data  "},;         �
//�                                     {"TRB_COD" ,"Codigo"} }         �
//� cCampo               - Nome de um campo (entre aspas) que sera usado�
//�                        como "flag". Se o campo estiver vazio, o re- �
//�                        gistro ficara de uma cor no browse, senao fi-�
//�                        cara de outra cor.                           �
//�����������������������������������������������������������������������

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,"G1_COMP")

Return
