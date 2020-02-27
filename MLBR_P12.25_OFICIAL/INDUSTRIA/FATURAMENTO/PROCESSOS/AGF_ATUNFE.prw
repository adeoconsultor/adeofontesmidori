#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


User Function AGF_ATUNFE()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cGetChNFe  := Space(50)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont1","oDlg1","oSay1","oGetChNFe","oBtnConfirma","oBtnCancel")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "MS Sans Serif",0,-21,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 095,252,251,787,"Atualizador de Chave NFe",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 012,012,{||"Informe a Chave da Nota Fiscal"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,164,016)
oGetChNFe  := TGet():New( 028,004,{|u| If(PCount()>0,cGetChNFe:=u,cGetChNFe)},oDlg1,252,014,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetChNFe",,)
oBtnConfir := TButton():New( 048,144,"&Confirmar",oDlg1,{|| AtuChNFe(cGetChNFe) },052,016,,,,.T.,,"Confirma a informacao",,,,.F. )
oBtnCancel := TButton():New( 049,201,"Ca&ncelar",oDlg1 ,{|| oDlg1:End() },052,016,,,,.T.,,"Cancela a informacao",,,,.F. )

oDlg1:Activate(,,,.T.)

Return

static function AtuChNFe(cChNFe)
local cCnpj:= Substr(cChNFe,7,14)
local cNota:= Substr(cChNFe,26,9)
local cMsg := 'Rotina acessada, nenhuma informacao atualizada'
local cTipoMsg := '0'
local nCount := 0 
if ApMsgNoYes('Confirma a atualizacao da chave nos arquivos','Atenção')
	// Indice (1) FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO
	// Indice (3) A2_FILIAL+A2_CGC
	// Indice (2) F1_FILIAL+F1_FORNECE+F1_LOJA+F1_DOC
	dbSelectArea('SA2')
	dbSetOrder(3)
	if dbSeek(xFilial('SA2')+cCnpj)
		dbSelectArea('SF1')
		dbSetOrder(2)
		if dbSeek(xFilial('SF1')+SA2->(A2_COD+A2_LOJA)+cNota)
			if SF1->F1_CHVNFE == space(44)
				RecLock('SF1',.F.)
				SF1->F1_CHVNFE := cChNFe
				MsUnLock('SF1')
				cMsg := 'Chave da nota fiscal gravada com sucesso. Fiscal não gravado'
				dbSelectArea('SFT')
				dbSetOrder(1)
				if dbSeek(xFilial('SFT')+'E'+SF1->(F1_SERIE+F1_DOC+F1_FORNECE+F1_LOJA))
					while !SFT->(eof()).and.SFT->(FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA)==SF1->(F1_SERIE+F1_DOC+F1_FORNECE+F1_LOJA)
						RecLock('SFT',.F.)
						SFT->FT_CHVNFE := cChNFe
						MsUnLock('SFT')
						SFT->(dbSkip())
						nCount++
						cMsg:= 'Chave da nota fiscal e livros fiscais gravados com sucesso.'
						cTipoMsg:= '1'
					enddo
				endif
				dbSelectArea('SF3')
				dbSetOrder(1)
				if dbSeek(xFilial('SF3')+SF1->(Dtos(F1_DTDIGIT)+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
					RecLock('SF3',.F.)
					SF3->F3_CHVNFE := cChNFe
					MsUnLock('SF3')
				endif
			else
				if apmsgnoyes('A Nota fiscal '+SF1->F1_DOC+' já possui chave, deseja substituir ? ')
					RecLock('SF1',.F.)
					SF1->F1_CHVNFE := cChNFe
					MsUnLock('SF1')
					cMsg := 'Chave da nota fiscal gravada com sucesso. Fiscal não gravado'
					dbSelectArea('SFT')
					dbSetOrder(1)
					if dbSeek(xFilial('SFT')+'E'+SF1->(F1_SERIE+F1_DOC+F1_FORNECE+F1_LOJA))
						while !SFT->(eof()).and.SFT->(FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA)==SF1->(F1_SERIE+F1_DOC+F1_FORNECE+F1_LOJA)
							RecLock('SFT',.F.)
							SFT->FT_CHVNFE := cChNFe
							MsUnLock('SFT')
							SFT->(dbSkip())
							nCount++
							cMsg:= 'Chave da nota fiscal e livros fiscais gravados com sucesso.'
							cTipoMsg:= '1'
						enddo
					endif
					dbSelectArea('SF3')
					dbSetOrder(1)
					if dbSeek(xFilial('SF3')+SF1->(Dtos(F1_DTDIGIT)+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
						RecLock('SF3',.F.)
						SF3->F3_CHVNFE := cChNFe
						MsUnLock('SF3')
					endif
				    
				endif
			
			endif
		else  // Caso nao encontrar no cadastro buscando por fornecedor, faz a busca por cliente
		
			dbSelectArea('SA1')
			dbSetOrder(3)
			if dbSeek(xFilial('SA1')+cCnpj)
				dbSelectArea('SF1')
				dbSetOrder(2)
				if dbSeek(xFilial('SF1')+SA1->(A1_COD+A1_LOJA)+cNota)
					if SF1->F1_CHVNFE == space(44)
						RecLock('SF1',.F.)
						SF1->F1_CHVNFE := cChNFe
						MsUnLock('SF1')
						cMsg := 'Chave da nota fiscal gravada com sucesso. Fiscal não gravado'
						dbSelectArea('SFT')
						dbSetOrder(1)
						if dbSeek(xFilial('SFT')+'E'+SF1->(F1_SERIE+F1_DOC+F1_FORNECE+F1_LOJA))
							while !SFT->(eof()).and.SFT->(FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA)==SF1->(F1_SERIE+F1_DOC+F1_FORNECE+F1_LOJA)
								RecLock('SFT',.F.)
								SFT->FT_CHVNFE := cChNFe
								MsUnLock('SFT')
								SFT->(dbSkip())
								nCount++
								cMsg:= 'Chave da nota fiscal e livros fiscais gravados com sucesso.'
								cTipoMsg:= '1'
							enddo
						endif
						dbSelectArea('SF3')
						dbSetOrder(1)
						if dbSeek(xFilial('SF3')+SF1->(Dtos(F1_DTDIGIT)+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
							RecLock('SF3',.F.)
							SF3->F3_CHVNFE := cChNFe
							MsUnLock('SF3')
						endif
					else
						if apmsgnoyes('A Nota fiscal '+SF1->F1_DOC+' já possui chave, deseja substituir ? ')
							RecLock('SF1',.F.)
							SF1->F1_CHVNFE := cChNFe
							MsUnLock('SF1')
							cMsg := 'Chave da nota fiscal gravada com sucesso. Fiscal não gravado'
							dbSelectArea('SFT')
							dbSetOrder(1)
							if dbSeek(xFilial('SFT')+'E'+SF1->(F1_SERIE+F1_DOC+F1_FORNECE+F1_LOJA))
								while !SFT->(eof()).and.SFT->(FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA)==SF1->(F1_SERIE+F1_DOC+F1_FORNECE+F1_LOJA)
									RecLock('SFT',.F.)
									SFT->FT_CHVNFE := cChNFe
									MsUnLock('SFT')
									SFT->(dbSkip())
									nCount++
									cMsg:= 'Chave da nota fiscal e livros fiscais gravados com sucesso.'
									cTipoMsg:= '1'
								enddo
							endif
							dbSelectArea('SF3')
							dbSetOrder(1)
							if dbSeek(xFilial('SF3')+SF1->(Dtos(F1_DTDIGIT)+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
								RecLock('SF3',.F.)
								SF3->F3_CHVNFE := cChNFe
								MsUnLock('SF3')
							endif
                        endif
					
					endif
				endif
			endif
	
		endif

	endif
	if cTipoMsg == '1'
		Alert(cMsg+chr(13)+'Total registro atualizado no fiscal: '+cValToChar(nCount))
	else
		Apmsginfo(cMsg)
	endif		
else
	Alert('Rotina aportada!')
endif 
oDlg1:End()
U_AGF_ATUNFE()
return