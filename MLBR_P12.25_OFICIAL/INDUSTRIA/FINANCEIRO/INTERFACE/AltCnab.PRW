#INCLUDE 'PROTHEUS.CH'
/*
Programa:        AltCnab
Autor:           Humberto Garcia
Data de Criação: 21/02/2010
Data de Revisão:
Finalidade e Descrição:

Caso um arquivo de pagamento seja rejeitado pelo banco devido a dados cadastrais incorretos (Ex agência ou conta corrente do fornecedor), o mesmo
arquivo não pode ser enviado novamente pois o banco Bradesco valida a informação do nosso número no arquivo do CNAB a pagar(posições de 120 a 135).
Essa informação é preenchida pelo campo E2_IDCNAB e uma vez gerada não pode mais ser manipulada através de rotinas padrão do sistema.

Esse programa tem a finalidade de "apagar" o número gravado no campo E2_IDCNAB para que na geração do novo arquivo de envio uma nova numeração seja
atribuida a este campo, possibilitando o pagamento correto.

Utilização:

Midori Atlântica do Brasil - Departamento Financeiro - Contas a pagar
*/

USER FUNCTION AltCnab

// Declaração das variáveis

LOCAL _cPrefix  := space(3)
LOCAL _cNumTit  := space(9)
LOCAL _cParcela := space(1)
LOCAL _cTipo    := space(3)
LOCAL _cFornece := space(6)
LOCAL _cLoja    := space(2)
LOCAL _dDtBaixa := CtoD(" ")
LOCAL _cBordero := " "
LOCAL _nOpc     := 0


// Monta a tela inicial do programa

Define dialog _odlg From 0,0 to 300,650 title "Manutenção de Arquivos de Pagamento" Pixel

@010,05 say   oSay Prompt "Este programa tem a finalidade de apagar o registro do campo E2_IDCNAB, utilizado no arquivo de envio de pagamentos."   pixel
@020,05 say   oSay Prompt "Deve ser utilizado somente se o 1º envio do pagamento for rejeitado pelo banco devido a dados cadastrais incorretos." pixel
@040,45 msget _cPrefix size 50,10 F3 "SE2CNA"  Pixel
@042,05 say   oSay Prompt "Prefixo" pixel
@052,45 msget _cNumtit size 50,10 Pixel
@054,05 say   oSay Prompt "Numero Título" pixel
@064,45 msget _cParcela size 50,10 Picture "@!" Pixel
@066,05 say   oSay Prompt "Parcela" Pixel
@076,45 msget _cTipo size 50,10 Picture "@!" Pixel
@078,05 say   oSay Prompt "Tipo" Pixel
@088,45 msget _cFornece size 50,10 Pixel
@090,05 say   oSay Prompt "Fornecedor" Pixel
@100,45 msget _cLoja size 50,10 Pixel
@102,05 say   oSay Prompt "Loja" Pixel
@130,180 button oBt1 Prompt "&OK" size 40,10 of _odlg action(_nOpc := 1,_odlg:end()) pixel
@130,220 button oBt2 Prompt "&Cancelar" size 40,10 of _odlg action(_nOpc := 2,MsgInfo("Operação cancelada","Operação Cancelada"),_odlg:end()) pixel
@130,260 button oBt3 Prompt "&Ajuda" size 40,10 of _odlg action(_nOpc := 3,Ajuda(),_odlg) pixel

activate dialog _odlg center

// Executa o programa caso seja confirmada a operação

If _nOpc == 1
	DbSelectArea("SE2")
	DbSetOrder(1)
	DbSeek(xFilial("SE2")+_cPrefix+_cNumtit+_cParcela+_cTipo+_cFornece+_cLoja)
	If found()
		If MsgYesNo("Tem certeza de que deseja apagar o número de identificação do titulo  " +_cNumTit+ "  Prefixo  " +_cPrefix+ "  Parcela  " +_cParcela,"Confirma a operação")
			If !Empty(SE2->E2_BAIXA)
				MsgStop("Este Titulo já foi baixado. Se desejar continuar com a operação será necessário estornar a baixa do título","Título já Baixado no Sistema")
			ElseIf !Empty(SE2->E2_NUMBOR)
				MsgStop("Este Titulo está vinculado ao borderô "+SE2->E2_NUMBOR+" Para continuar a operação é necessário retirar o título do borderô","Título em Borderô")
			Else
				RecLock("SE2",.F.)
				SE2->E2_IDCNAB:=SPACE(10)
				MsUnlock()
				Msginfo("Título atualizado!","Operação Finalizada")
			Endif
		Endif
	Else
		MsgInfo("Título não encontrado","Sem registro")
	Endif
	DbCloseArea()
Endif


// Executa o programa quando for acionado o botão de ajuda
Static Function Ajuda()

Define dialog _oAjuda From 0,0 to 300,650 title "Informe sobre o Sistema de Manutenção de Arquivos de Pagamento" Pixel
@010,05 say oSay Prompt "FINALIDADE DO PROGRAMA" Pixel
@020,05 say oSay Prompt "Este programa tem a finalidade de apagar o conteúdo do campo E2_IDCNAB, utilizado no arquivo de envio de pagamentos." Pixel
@040,05 say oSay Prompt "UTILIZAÇÃO" Pixel
@050,05 say oSay Prompt "Esse programa deve ser utilizado apenas quando o banco Bradesco rejeitar algum arquivo de pagamento por motivo de dados" Pixel
@060,05 say oSay Prompt "cadastrais incorreto (o banco não faz o agendamento do título) e o título precisar ser re-enviado pelo departamento financeiro." Pixel
@080,05 say oSay Prompt "INFORMAÇÕES IMPORTANTES" Pixel
@090,05 say oSay Prompt "O conteúdo do campo E2_IDCNAB é utilizado nas posições 120 a 135 do arquivo de envio de contas a pagar do Banco Bradesco " Pixel
@100,05 say oSay Prompt "e representam o nosso número de pagamento. A informação contida nesse campo é um controle interno do sistema Protheus e" Pixel
@110,05 say oSay Prompt "uma vez gerada não pode mais ser alterada pelas rotinas 'padrão' do sistema. Porém o banco Bradesco utiliza-se dessa" Pixel
@120,05 say oSay Prompt "informação para checar se o titulo já existe na base de dados do banco." Pixel
@130,260 button oBt3 Prompt "&OK" size 40,10 of _oAjuda action(_nOpc := 1,_oAjuda:end()) pixel
activate dialog _oAjuda center

Return()

RETURN() 
