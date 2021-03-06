#INCLUDE 'PROTHEUS.CH'
/*
Programa:        AltCnab
Autor:           Humberto Garcia
Data de Cria��o: 21/02/2010
Data de Revis�o:
Finalidade e Descri��o:

Caso um arquivo de pagamento seja rejeitado pelo banco devido a dados cadastrais incorretos (Ex ag�ncia ou conta corrente do fornecedor), o mesmo
arquivo n�o pode ser enviado novamente pois o banco Bradesco valida a informa��o do nosso n�mero no arquivo do CNAB a pagar(posi��es de 120 a 135).
Essa informa��o � preenchida pelo campo E2_IDCNAB e uma vez gerada n�o pode mais ser manipulada atrav�s de rotinas padr�o do sistema.

Esse programa tem a finalidade de "apagar" o n�mero gravado no campo E2_IDCNAB para que na gera��o do novo arquivo de envio uma nova numera��o seja
atribuida a este campo, possibilitando o pagamento correto.

Utiliza��o:

Midori Atl�ntica do Brasil - Departamento Financeiro - Contas a pagar
*/

USER FUNCTION AltCnab

// Declara��o das vari�veis

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

Define dialog _odlg From 0,0 to 300,650 title "Manuten��o de Arquivos de Pagamento" Pixel

@010,05 say   oSay Prompt "Este programa tem a finalidade de apagar o registro do campo E2_IDCNAB, utilizado no arquivo de envio de pagamentos."   pixel
@020,05 say   oSay Prompt "Deve ser utilizado somente se o 1� envio do pagamento for rejeitado pelo banco devido a dados cadastrais incorretos." pixel
@040,45 msget _cPrefix size 50,10 F3 "SE2CNA"  Pixel
@042,05 say   oSay Prompt "Prefixo" pixel
@052,45 msget _cNumtit size 50,10 Pixel
@054,05 say   oSay Prompt "Numero T�tulo" pixel
@064,45 msget _cParcela size 50,10 Picture "@!" Pixel
@066,05 say   oSay Prompt "Parcela" Pixel
@076,45 msget _cTipo size 50,10 Picture "@!" Pixel
@078,05 say   oSay Prompt "Tipo" Pixel
@088,45 msget _cFornece size 50,10 Pixel
@090,05 say   oSay Prompt "Fornecedor" Pixel
@100,45 msget _cLoja size 50,10 Pixel
@102,05 say   oSay Prompt "Loja" Pixel
@130,180 button oBt1 Prompt "&OK" size 40,10 of _odlg action(_nOpc := 1,_odlg:end()) pixel
@130,220 button oBt2 Prompt "&Cancelar" size 40,10 of _odlg action(_nOpc := 2,MsgInfo("Opera��o cancelada","Opera��o Cancelada"),_odlg:end()) pixel
@130,260 button oBt3 Prompt "&Ajuda" size 40,10 of _odlg action(_nOpc := 3,Ajuda(),_odlg) pixel

activate dialog _odlg center

// Executa o programa caso seja confirmada a opera��o

If _nOpc == 1
	DbSelectArea("SE2")
	DbSetOrder(1)
	DbSeek(xFilial("SE2")+_cPrefix+_cNumtit+_cParcela+_cTipo+_cFornece+_cLoja)
	If found()
		If MsgYesNo("Tem certeza de que deseja apagar o n�mero de identifica��o do titulo  " +_cNumTit+ "  Prefixo  " +_cPrefix+ "  Parcela  " +_cParcela,"Confirma a opera��o")
			If !Empty(SE2->E2_BAIXA)
				MsgStop("Este Titulo j� foi baixado. Se desejar continuar com a opera��o ser� necess�rio estornar a baixa do t�tulo","T�tulo j� Baixado no Sistema")
			ElseIf !Empty(SE2->E2_NUMBOR)
				MsgStop("Este Titulo est� vinculado ao border� "+SE2->E2_NUMBOR+" Para continuar a opera��o � necess�rio retirar o t�tulo do border�","T�tulo em Border�")
			Else
				RecLock("SE2",.F.)
				SE2->E2_IDCNAB:=SPACE(10)
				MsUnlock()
				Msginfo("T�tulo atualizado!","Opera��o Finalizada")
			Endif
		Endif
	Else
		MsgInfo("T�tulo n�o encontrado","Sem registro")
	Endif
	DbCloseArea()
Endif


// Executa o programa quando for acionado o bot�o de ajuda
Static Function Ajuda()

Define dialog _oAjuda From 0,0 to 300,650 title "Informe sobre o Sistema de Manuten��o de Arquivos de Pagamento" Pixel
@010,05 say oSay Prompt "FINALIDADE DO PROGRAMA" Pixel
@020,05 say oSay Prompt "Este programa tem a finalidade de apagar o conte�do do campo E2_IDCNAB, utilizado no arquivo de envio de pagamentos." Pixel
@040,05 say oSay Prompt "UTILIZA��O" Pixel
@050,05 say oSay Prompt "Esse programa deve ser utilizado apenas quando o banco Bradesco rejeitar algum arquivo de pagamento por motivo de dados" Pixel
@060,05 say oSay Prompt "cadastrais incorreto (o banco n�o faz o agendamento do t�tulo) e o t�tulo precisar ser re-enviado pelo departamento financeiro." Pixel
@080,05 say oSay Prompt "INFORMA��ES IMPORTANTES" Pixel
@090,05 say oSay Prompt "O conte�do do campo E2_IDCNAB � utilizado nas posi��es 120 a 135 do arquivo de envio de contas a pagar do Banco Bradesco " Pixel
@100,05 say oSay Prompt "e representam o nosso n�mero de pagamento. A informa��o contida nesse campo � um controle interno do sistema Protheus e" Pixel
@110,05 say oSay Prompt "uma vez gerada n�o pode mais ser alterada pelas rotinas 'padr�o' do sistema. Por�m o banco Bradesco utiliza-se dessa" Pixel
@120,05 say oSay Prompt "informa��o para checar se o titulo j� existe na base de dados do banco." Pixel
@130,260 button oBt3 Prompt "&OK" size 40,10 of _oAjuda action(_nOpc := 1,_oAjuda:end()) pixel
activate dialog _oAjuda center

Return()

RETURN() 
