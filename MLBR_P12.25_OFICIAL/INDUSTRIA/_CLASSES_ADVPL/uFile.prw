#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FILEIO.CH"

Class uFile  

	Data nHdl
	Data FileName
	Data FilePath
	Data FileSize
	Data FullName
	Data cData
	Data nLines
	Data nLine
	Data lOk
	Data lBof
	Data lEof
	Data lCreate
	Data lAuto
	
	Method New( lCreate ) Constructor
	Method Open( cFile, cPath )       // Cria ou Abre um arquivo
	Method Write( cTxt, lEol )     // Escreve um Texto colocando ou não CRLF no final
	Method GoTop()                    // Vai para a 1a linha do arquivo texto
	Method Skip()                     // Salta uma linha
	Method GoTo()                     // Vai para uma determinada linha
	Method GoBottom()                 // Vai para o fim do arquivo
	Method Eof()                      // Similar ao EOF() do banco de dados
	Method Bof()                      // Similar ao BOF() do banco de dados
	Method ReadLine()                 // Le a Linha atual
	Method Copy(cFileName, cPath)     // Copia o arquivo aberto
	Method Move(cFileName, cPath)     // Move o arquivo aberto
	Method Delete()                   // Apaga o arquivo selecionado
	Method Rename()                   // Renomeia o arquivo Selecionado
	Method Count()                    // Quantidade de linhas do arquivo txt
	Method Msg( cMsg )                // Mensagem que deve ser direcionada para tela ou para o arquivo de log, de acordo com Self:lAuto
	
EndClass

******************************************************************************************************************                                                       
// lCreate informa que o arquivo que o objeto controla deve ser: .T.=criado do zero, sobreescrevendo se já existe
//                                                               .F.=Aberto se já existir ou criado se não existir
******************************************************************************************************************                                                       
Method New( lCreate, lAuto ) Class uFile

Default lCreate := .f. // .t. - Criar um arquivo novo, .f. - Lê um arquivo já existente
Default lAuto   := .f. // .t. - Rotina automatica, logs em CONOUT() - .f. - Logs via MsgInfo()

Self:nHdl     := -1
Self:nLine    := 1
Self:nLines   := 1

Self:lOk      := .t.
Self:lBof     := .t.
Self:lEof     := .t.
Self:lCreate  := lCreate
Self:lAuto    := lAuto 

Self:cData    := ""
Self:FileSize := 0
Self:FileName := ""
Self:FilePath := ""
Self:FullName := ""
 
Return( Self )              

******************************************************************************************************************
// Abre ou cria um arquivo
******************************************************************************************************************
Method Open( cFile, cPath, lCreate ) Class uFile                                                                

Local cLogErro := ""
Local lNovo    := .t.
Local lRet     := .t.
Local nHdl     := -1
                       
Default cPath     := GetSrvProfString("RootPath","") // Caso não seja informado o path, o arquivo será criado/modificado no rootpath do sistema
Default lCreate   := Self:lCreate // .t. - Criar arquivo novo, .f. - Deve abrir um arquivo já existente
        
Self:nLines   := 1 
Self:nLine    := 1
Self:cData    := ""
Self:lOk      := .t.

Self:FileName := Lower( AllTrim(cFile) )

Self:FilePath := Lower( AllTrim(cPath) )
Self:FilePath := AllTrim(Self:FilePath)

If Right(Self:FilePath,1) <> "\"
	Self:FilePath += "\"
EndIf           

Self:FullName := Self:FilePath + Self:FileName
                   
// Se o arquivo já existe, verifica a possibilidade de reescrevê-lo
If File( Self:FullName ) .and. lCreate
	
	// Se for rotina automática, sobreescreve o arquivo
	If ! Self:lAuto
		If ! MsgYesNo( "O arquivo " + Self:FullName + " já existe. Sobreescrever ?" )
			Return( .f. )
		EndIf           
	EndIf
EndIf

If ! File( Self:FullName ) .or. lCreate
	// Cria o arquivo ou, caso já exista, trunca o seu conteúdo
	Self:cData  := ""
	nHdl     := FCreate( Self:FullName, 0 )
	nErro    := FError()
	lNovo    := .t.
	fClose( nHdl )		
Else
	// Abre o arquivo
	Self:cData := MemoRead( Self:FullName )  
	nErro   := FError()
	lNovo   := .f.
EndIf         

If nErro <> 0
	cLogErro := "Não foi possível "+iif(lNovo,"criar","abrir")+" o arquivo "
	cLogErro += Self:FullName + CRLF
	cLogErro += GetFError(nErro)
	Self:Msg( cLogErro )
	lRet     := .f.
EndIf
                             
// Quantidade de Linhas do arquivo texto
Self:nLine  := 1
Self:nLines := Self:Count()
Self:lBof   := .t.
Self:lEof   := .f.
         
Return( lRet )

*****************************************************************************************************************
// Escreve uma string dentro do arquivo.
*****************************************************************************************************************
Method Write( cTxt, lEol ) Class uFile

Local cBuffer  := Self:cData + cTxt + iif(lEol,CRLF,"")
Local cLogErro := ""
     
// Verifica se pode utilizar o arquivo
If ! Self:lOk
	Self:Msg("Não é possível escrever no arquivo " + Self:FullName )
	Return(.f.)
EndIf

// Grava o texto no arquivo
If ! MemoWrite( Self:FullName, cBuffer )
	cLogErro := "Não foi possível escrever no arquivo " + Self:FullName + CRLF
	cLogErro += GetFError( fError() )
	Self:Msg( cLogErro )
	Return( .f. )
Else
	Self:cData  := cBuffer
	Self:nLines := Self:Count()
	Self:nLinha := Self:nLines
EndIf

Return( .t. )    
                             
*****************************************************************************************************************
// Vai para o início do arquivo
*****************************************************************************************************************
Method GoTop() Class uFile
Self:nLine := 1
Return( nil )
                               
*****************************************************************************************************************
// Vai para o fim do arquivo
*****************************************************************************************************************
Method GoBottom() Class uFile

Self:nLine := Self:nLines

Return( nil )  
                            
*****************************************************************************************************************
// Salta <n> linhas no arquivo
*****************************************************************************************************************
Method Skip( nSkip ) Class uFile

Default nSkip := 1
                
// Valida se chegou no fim do arquivo
If Self:nLine + nSkip > Self:nLines
	Self:lEof  := .t.
	Self:nLine := Self:nLines
	nSkip   := 0
Else
	Self:lEof  := .f.  
EndIf

// Valida se chegou no inicio do arquivo
If Self:nLine + nSkip < 1
	Self:lBof  := .t.
	Self:nLine := 1
	nSkip   := 0
Else
	Self:lBof  := .f.
EndIf
Self:nLine += nSkip

Return(nil)

*****************************************************************************************************************
// Vai para uma determinada linha do arquivo
*****************************************************************************************************************
Method GoTo( nLinha ) Class uFile                                                                              

If nLinha < 1
	nLinha := 1 
	Self:Bof  := .t.
EndIf

If nLinha > Self:nLines
	nLinha := Self:nLines
	Self:Eof  := .t.
EndIf

Self:nLine := nLinha

Return(nil)
*****************************************************************************************************************
// Verifica se está no fim do arquivo
*****************************************************************************************************************
Method Eof() Class uFile

Return( Self:lEof )

*****************************************************************************************************************
// Verifica se está no inicio do arquivo
*****************************************************************************************************************
Method Bof() Class uFile

Return( Self:lBof )    

*****************************************************************************************************************
// Lê uma linha do arquivo
*****************************************************************************************************************
Method ReadLine() Class uFile
Local cRet := MemoLine( Self:cData,,Self:nLine)
Return( cRet )

*****************************************************************************************************************
// Copia o arquivo 
*****************************************************************************************************************
Method Copy(cFileName, cPath) Class uFile

Local nLoop
Local nErro
Local nHdl
Local lCopiou := .f.
                           
Default cFileName := Self:FileName
Default cPath     := Self:FilePath

If ! ExistDir(cPath)
	Self:Msg("O caminho " + cPath + " não existe" )
	Return( .f. )
EndIf

If ! File( Self:FullName )
	Self:Msg( "O arquivo de origem " + Self:FullName + " não existe ")
	Return( .f. )
EndIf

cFileName := Lower( AllTrim(cFileName) )
cPath     := Lower( AllTrim(cPath) )

If Right(cPath,1) <> "\"
	cPath += "\"
EndIf               

If cPath + cFileName == Self:FullName
	Self:Msg("Não é possível copiar um arquivo para ele mesmo")
	Return( .f. )
EndIf      

If File( cPath + cFileName )
	If ! MsgYesNo( "O arquivo " + cPath + cFileName + " já existe. Deseja sobreescrevê-lo?" )
		Return( .f. )
	EndIf
EndIf

// Cria o arquivo novo
nHdl   := fCreate( cPath + cFileName, 0 )
nErro  := fError()
                
// Valida a criação do novo arquivo
If nErro <> 0
	cLogErro := "Não foi possível criar o arquivo "
	cLogErro += cPath + cFileName + CRLF
	cLogErro += GetFError(nErro)
	Self:Msg( cLogErro ) 
	Return( .f. )
EndIf     

FClose( nHdl )
        
lCopiou := MemoWrite( cPath + cFileName, Self:cData )
	
If ! lCopiou
	nErro  := fError()
	// Valida a criação do novo arquivo
	If nErro <> 0
		cLogErro := "Não foi possível escrever no arquivo "
		cLogErro += cPath + cFileName + CRLF
		cLogErro += GetFError(nErro)
		Self:Msg( cLogErro ) 
	EndIf     
EndIf
             
Return( lCopiou )

*****************************************************************************************************************
// Move o arquivo
*****************************************************************************************************************
Method Move(cFileName, cPath) Class uFile  // Move o arquivo aberto

Local lMoveu      := .t. 

Default cFileName := Self:FileName
Default cPath     := Self:FilePath

If ! File( Self:FullName )
	Self:Msg( "O arquivo de origem " + Self:FullName + " não existe ")
	Return( .f. )
EndIf

cPath     := Lower( AllTrim(cPath) )
cFileName := Lower( AllTrim(cFileName) )

If Right(cPath,1) <> "\"
	cPath += "\"
EndIf               

If cPath + cFileName == Self:FullName
	Self:Msg("Não é possível mover um arquivo para ele mesmo",cPath + cFileName)
	Return( .f. )
EndIf

FRename(Self:FullName,cPath+cFileName)
nErro := FError()

// Valida o movimento do arquivo
If nErro <> 0
	cLogErro := "Não foi possível mover o arquivo "
	cLogErro += cPath + cFileName + CRLF
	cLogErro += GetFError(nErro)
	Self:Msg( cLogErro ) 
	lMoveu := .f.
Else
	Self:FullName := cPath+cFileName
EndIf     

Return( lMoveu )                

*****************************************************************************************************************
// Apaga o arquivo
*****************************************************************************************************************
Method Delete()  Class uFile
Local lApagou := .t.

FErase( Self:FullName )

nErro := FError()

// Valida o movimento do arquivo
If nErro <> 0
	cLogErro := "Não foi possível apagar o arquivo "
	cLogErro += cPath + cFileName + CRLF
	cLogErro += GetFError(nErro)
	Self:Msg( cLogErro ) 
	lApagou := .f.
EndIf     

Return( lApagou )                

*****************************************************************************************************************
// Renomeia o arquivo
*****************************************************************************************************************
Method Rename(cFileName) Class uFile

Local lRet := Self:Move(cFileName)

Return( lRet )

*****************************************************************************************************************
// Conta a quantidade de linhas do arquivo
*****************************************************************************************************************
Method Count() Class uFile

Self:nLines := MemoRead( Self:cData )	

Return( Self:nLines )

*****************************************************************************************************************
// Retorna as mensagens para tela ou para ConOut()
*****************************************************************************************************************
Method Msg( cMsg ) Class uFile

If Self:lAuto
	ConOut( cMsg )
Else
	MsgInfo( cMsg )
EndIf

Return( nil )

*****************************************************************************************************************
// Retorna a descrição do erro a partir de seu código
*****************************************************************************************************************
Static Function GetFError( nErro )

Local aErro := {} 
Local nPos  := 0
Local cRet  := ""

AAdd( aErro, { 0, "Operação bem-sucedida."                                          } )
AAdd( aErro, { 2, "Arquivo não encontrado."                                         } )
AAdd( aErro, { 3, "Diretório não encontrado."                                       } )
AAdd( aErro, { 4, "Muitos arquivos foram abertos. Verifique o   parâmetro FILES."   } )
AAdd( aErro, { 5, "Impossível acessar o arquivo."                                   } )
AAdd( aErro, { 6, "Número de manipulação de arquivo inválido."                      } )
AAdd( aErro, { 8, "Memória insuficiente."                                           } )
AAdd( aErro, { 15, "Acionador (Drive) de discos inválido."                          } )
AAdd( aErro, { 19, "Tentativa de gravar sobre um disco   protegido contra escrita." } )
AAdd( aErro, { 21, "Acionador (Drive) de discos inoperante."                        } )
AAdd( aErro, { 23, "Erro de dados no disco."                                        } )
AAdd( aErro, { 29, "Erro de gravação no disco."                                     } )
AAdd( aErro, { 30, "Erro de leitura no disco."                                      } )
AAdd( aErro, { 32, "Violação de compartilhamento."                                  } )
AAdd( aErro, { 33, "Violação de bloqueio."                                          } )

nPos := aScan(aErro, {|x| x[1] == nErro} )

If Empty( nPos )
	cRet := "File Error: " +StrZero(nErro,2) + " erro indefinido"
Else
	cret := "File Error: " +StrZero(nErro,2) + " " + aErro[nPos,2]
EndIf

If nErro <> 0
	Self:lOk := .f.
EndIf

Return( cRet )
******************************************************************************************************
User Function TesteTxt()
Local oFile 
Local nLoop

oFile := uFile():New( .t. )

If ! oFile:Open("TESTE.TXT")
	Return( nil )
EndIf       
             
For nLoop := 1 to 100
	oFile:Write( "Linha " + StrZero( nLoop,3), .t. )
Next nLoop
                                           
MsgInfo( "Verifique se o arquivo " + oFile:FullName + " foi gravado com 100 linhas ")

oFile:GoTop()
oLog := TngLog():New()
While ! oFile:Eof()
	oLog:Add( oFile:ReadLine() )
	oFile:Skip()
Enddo       
oLog:Show()

oFile:Copy("TESTECOPIA.TXT")
MsgInfo( "Verifique o arquivo " + oFile:FilePath + "TESTECOPIA.TXT" )

oFile:Move("TESTEMOVE.TXT")
MsgInfo( "Verifique o arquivo " + oFile:FullName )

oFile:Rename("TESTEREN.TXT")
MsgInfo( "Verifique o arquivo " + oFile:FullName )

oFile:Delete()
MsgInfo( "Verifique o arquivo " + oFile:FullName + " foi deletado" )
