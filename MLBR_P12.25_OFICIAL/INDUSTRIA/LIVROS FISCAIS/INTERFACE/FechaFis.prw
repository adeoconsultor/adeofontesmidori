#INCLUDE 'PROTHEUS.CH'
/*-----------------------------------------------------------------------------------|
Programa: FechaFis									 Data de Criação: 19/03/2010     |
Autor:    Humberto Garcia Liendo   - Consultor de Negócios                           |
-------------------------------------------------------------------------------------|
Descrição: Esse programa tem a finalidade de permitir o fechamento fiscal, atraves da|
manipulação (atualização) do parâmetro MV_DATAFIS                                    |
-------------------------------------------------------------------------------------|
Revisãoes:                                                                           |
                                                                                     |
Data		|Responsável			|Alteração Efetuada			|Observações         |
|                       |                           |                    |           |
|                       |                           |                    |           |
|                       |                           |                    |           |
|                       |                           |                    |           |
|                       |                           |                    |           |
|                       |                           |                    |           |
|                       |                           |                    |           |
------------------------------------------------------------------------------------*/
User Function FechaFis

//Declaração das Variáveis
Local dDataAtu  := GetMv("MV_DATAFIS")
Local dNovaData := CtoD ("   ")
Local cArquiLog := "\system\LogDatafis.TXT"
Local cTextoLog := " "

// Monta a tela inicial para digitação
Define dialog _odlg From 0,0 to 300,550 title "Controle de Fechamento Fiscal" Pixel
@010,005 say    oSay Prompt "Este programa tem a finalidade de manipular o conteúdo do parâmetro MV_DATAFIS, responsável pelo" pixel
@020,005 say    oSay Prompt "controle do fechamento fiscal. Deve ser utilizado somente após o fechamento e entrega das obrigações fiscais." pixel
@042,005 say    oSay Prompt "Data do último fechamento:  " pixel
@042,095 say    oSay Prompt Dtoc(dDataAtu) Pixel
@064,085 msget  dNovaData  Pixel
@066,005 say    oSay Prompt "Nova data de fechamento: " Pixel
@130,140 button oBt1 Prompt "&OK" size 40,10 of _odlg action(_nOpc := 1,_odlg:end()) pixel
@130,180 button oBt2 Prompt "&Cancelar" size 40,10 of _odlg action(_nOpc := 2,MsgInfo("Operação cancelada","Operação Cancelada"),_odlg:end()) pixel
@130,220 button oBt3 Prompt "&Ajuda" size 40,10 of _odlg action(_nOpc := 3,Ajuda(),_odlg) pixel
activate dialog _odlg center

// Executa o programa caso a operação seja confirmada
If _nOpc == 1
	If dNovaData == Ctod(" ")                // Verifica se a nova data foi preenchida ou está vazia
		MsgInfo("Informe uma data válida!")
	Elseif dNovaData > dDataAtu	             // Compara a data informada com a data atula, permitindo apenas o fechamento
		PutMv("MV_DATAFIS",dNovaData)        // Atribui a nova data ao parâmetro MV_DATAFIS
		
		//Cria mensagem de texto que será gerada no arquivo de log na pasta system (nome do arquivo = LOGDATAFIS.TXT)
		cTextoLog := "Data da operação: "+Dtoc(ddatabase)+" Usuário: "+cUserName+" Data anterior do parâmetro: "+Dtoc(dDataAtu)+" Nova data informada: "+Dtoc(dNovaData)
		
		If !File(cArquiLog)                       // Verifica a existencia de arquivo de Log
			nHandle := GeraLog(cArquiLog,,"C",)   // Cria arquivo de log caso não exista
			GeraLog(cArquiLog,,"A",)              // Abre o arquivo para manipulação
			GeraLog( ,cTextoLog,"G",nHandle)      // Grava as informações do log
			GeraLog(cArquiLog,,"F",)              // Fecha o arquivo de log
		Else
			nHandle :=GeraLog(cArquiLog,,"A",)    // Abre o arquivo de log, quando já existe na pasta system
			GeraLog( ,cTextoLog,"G",nHandle)      // Grava as informações de log
			GeraLog(cArquiLog,,"F",)              // Fecha o arquivo
		Endif
		MsgInfo("Data de fechamento atualizada com sucesso! Nova data de fechamento: "+Dtoc(GetMv("MV_DATAFIS"))+" ") // Informa ao usuário a conclusão da operação
	Else
		MsgInfo("Não é permitida a reabertura do fechamento fiscal. Contate o administrador do sistema")
	EndIf
EndIf




// Abre a tela de informações quando o botão "Ajuda" for acionado
Static Function Ajuda()

Define dialog _oAjuda From 0,0 to 300,650 title "Informe sobre sistema de Fechamento Fiscal" Pixel
@010,005 say oSay Prompt  "FINALIDADE DO PROGRAMA" Pixel
@020,005 say oSay Prompt  "Este programa tem a finalidade de manipular o conteúdo do parâmetro MV_DATAFIS, responsável pelo controle do" Pixel
@030,005 say oSay Prompt  "fechamento fiscal." Pixel
@050,005 say oSay Prompt  "UTILIZAÇÃO" Pixel
@060,005 say oSay Prompt  "Esse programa deve ser utilizado pelo departamento fiscal para gerenciar a data do ultimo fechamento fiscal." Pixel
@070,005 say oSay Prompt  "Preferencialmente deve ser utilizado após o fechamento e entrega das obrigações fiscais." Pixel
@090,005 say oSay Prompt  "INFORMAÇÕES IMPORTANTES" Pixel
@100,005 say oSay Prompt  "O conteúdo do parâmetro MV_DATAFIS indica a data do ultimo fechamento fiscal. Não é possível realizar operações fiscais " Pixel
@110,005 say oSay Prompt  "com datas anteriores à data cadastrada nesse parâmetro. " Pixel
@130,260 button oBt3 Prompt "&OK" size 40,10 of _oAjuda action(_nOpc := 1,_oAjuda:end()) pixel
activate dialog _oAjuda center

Return()
/*-----------------------------------------------------------------------------------|
Programa: Geralog									 Data de Criação: 19/03/2010     |
Autor:    Humberto Garcia Liendo   - Consultor de Negócios                           |
-------------------------------------------------------------------------------------|
Descrição: Esse programa tem a finalidade de gerenciar o log de registro de acordo c/|
a opção selecionada:                                                                 |
                                                                                     |
Parametros:                                                                          |
³ cArquiLog -> nome e path do arquivo a ser gerado                                   |
³ cTextoLog -> texto com o conteudo a ser gravado                                    |
³ cOpc      -> opcao A : Abertura de arquivo para gravacao                           |
³				       C : Criar o arquivo com cArquiLog                             |
³                    G : Gravar o cLin no cArquiLog                                  |
³                    V : chamar o NotePad e Exibe o conteudo de cArquiLog            |
³                    F : Fechar o arquivo pelo handle                                |
³ nHandle   -> Handle do cArquiLog criado para poder ser gravado cTextoLog           |                                                                                        |
-------------------------------------------------------------------------------------|
Revisãoes:                                                                           |
                                                                                     |
Data		|Responsável			|Alteração Efetuada			|Observações         |
|                       |                           |                    |           |
|                       |                           |                    |           |
|                       |                           |                    |           |
|                       |                           |                    |           |
|                       |                           |                    |           |
|                       |                           |                    |           |
|                       |                           |                    |           |
------------------------------------------------------------------------------------*/

Static Function GeraLog(cArquiLog, cTextoLog, cOpc, nHandle )

//Define varivel com o ASCII do CR/LF
Local cEol	:= (CHR(13)+CHR(10))
Local lLog := .T.

If cOpc == "C"                               //Verifica se ira criar o arquivo
	nHandle := fCreate( cArquiLog )
	If ( nHandle == -1 )                     // Se houve erro na criacao do texto no sistema operacional.
		lLog := .F.
	End
	
ElseIf cOpc == "A"                           //Verifica se ira abrir o arquivo
	nHandle := fOpen( cArquiLog, 1 )         // Abrir com acesso a escrita
	If ( nHandle == -1 )                     // Se houve erro na criacao do texto no sistema operacional.
		lLog := .F.
	EndIf
	FSeek( nHandle, 0, 2 )
	
ElseIf cOpc == "G"                           // Gravar o texto
	If ( Empty(nHandle) .or. nHandle == -1 ) // Se houve erro na criacao do texto no sistema operacional.
		lLog := .F.
	Else
		cTextoLog += cEOL
		fWrite( nHandle, cTextoLog, Len( cTextoLog ) ) // Grava o conteudo do parametro
	EndIf
	
ElseIf cOpc == "F"
	fClose( nHandle )                        //Fechando arquivo texto apos geracao.
EndIf

Return(nHandle)

Return()
