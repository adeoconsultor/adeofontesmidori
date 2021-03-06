#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SINCRORC  �Autor  �Microsiga           � Data �  01/03/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para criar o arquivo de fechamento da folha RCEEAAMM ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SINCRORC

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg       := "CRIAXX"
Private oGeraTxt
Private cString := "SRD"
dbSelectArea("SRD")
dbSetOrder(1)
ValidPerg()
Pergunte(cPerg,.f.)
//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Sincronizacao de Acumulados")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira sincronizar a tabela de acumualdos com os "
@ 18,018 Say " arquivos de fechamento mensal - RCEEAAMM                      "

@ 70,090 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 70,120 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 70,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERATXT� Autor � AP5 IDE            � Data �  06/01/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a geracao do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkGeraTxt

SetPrvt("_cChave1,_cArqInd1,_cArea_")
_aMeses := {}
_caux_ := AnoMes(mv_par01)

While _caux_ <= AnoMes(mv_par02)
	AADD(_aMeses,{_caux_,})
	If Subs(_caux_,5,2) == "12"
		_caux_ := StrZero(Val(Subs(_caux_,1,4)) + 1,4) + "01"
	Else
		_caux_ := Subs(_caux_,1,4) + StrZero(Val(Subs(_caux_,5,2)) + 1,2)
	Endif
Enddo

Processa({|lEnd| RunCont()}, 'Processando...')

Close(oGeraTxt)

If !Empty(_cArqInd1)
   Ferase(_cArqInd1+OrdBagExt())
EndIf

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RunCont   �Autor  �Microsiga           � Data �  01/03/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RunCont()
Local i

For i := 1 to Len(_aMeses)
	cArqDBF  := "RC"+SM0->M0_CODIGO+SUBS(_aMeses[i,1],3,4)+".DBF"
	
	If file(cArqDbf)
		Erase(cArqDBF)
	Endif
	
	dbSelectArea("SRC")
	aFields1 := SRC->( dbStruct() )	// Efetuando criacao
	dbCreate(cArqDbf,aFields1)
	DbUseArea(.T., ,cArqDBF, "RCXX", .F., .F.)
	_cChave2  := "RC_FILIAL+RC_MAT+RC_PD"
	_cArqInd2 := CriaTrab(,.F.)
	IndRegua("RCXX", _cArqInd2,_cChave2, , , "Selecionando Registros" )
	DbClearIndex()
	DbSetIndex(_cArqInd2)
	                                                             
	dbSelectArea("SRA")
	dbSetOrder(1)
	dbGotop()
	While !Eof()
		dbSelectArea("SRD")
		dbSetOrder(1)
		If dbSeek (SRA->RA_FILIAL + SRA->RA_MAT + _aMeses[i,1]) 
			While !eof() .And. SRA->RA_FILIAL+SRA->RA_MAT+_aMeses[i,1] == SRD->RD_FILIAL+SRD->RD_MAT+SRD->RD_DATARQ
				dbSelectArea("RCXX")
				RecLock("RCXX",.T.)
					RCXX->RC_FILIAL := SRD->RD_FILIAL
					RCXX->RC_MAT	:= SRD->RD_MAT
					RCXX->RC_PD		:= SRD->RD_PD
					RCXX->RC_DATA	:= SRD->RD_DATPGT
					RCXX->RC_HORAS	:= SRD->RD_HORAS
					RCXX->RC_VALOR	:= SRD->RD_VALOR
					RCXX->RC_TIPO1	:= SRD->RD_TIPO1
					RCXX->RC_TIPO2	:= SRD->RD_TIPO2
					RCXX->RC_CC		:= SRD->RD_CC
					RCXX->RC_SEQ	:= SRD->RD_SEQ
				MsUnlock()
			dbSelectArea("SRD")
			dbskip()
			Enddo
		Endif
		dbSelectArea("SRA")
		IncProc('Funcionario -> '+SRA->RA_FILIAL+"/"+SRA->RA_MAT+"/"+_aMeses[i,1]	)
		dbskip()
	Enddo
	
	dbSelectArea("RCXX")
	dbCloseArea()
	
	//Chamada funcao ajuste
	AjustaRC(_aMeses[i,1])
	
	If file(cArqDbf)
		Erase(cArqDBF)
	Endif

Next
	
Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor � AP6 IDE            � Data �  17/03/02   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� /*/

Static Function ValidPerg

Local _sAlias, aRegs, i,j

_sAlias := Alias()
aRegs := {}
I := 0
J := 0

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
//          Grupo/Ordem    /Pergunta/ /                                                        /Var	/Tipo/Tam/Dec/Pres/GSC/Valid/ Var01      /Def01    /DefSpa01    /DefIng1      /Cnt01/Var02    /Def02   /DefSpa2     /DefIng2          /Cnt02   /Var03 /Def03   /DefSpa3  /DefIng3  /Cnt03 /Var04   /Def04    /Cnt04    /Var05  /Def05	/Cnt05  /XF3                                                         
Aadd(aRegs,{cPerg,"01","Dt Referencia de?","Data       ?","Data       ?","mv_ch1","D",08,0,0,"G" ,"","mv_par01","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","",""})
Aadd(aRegs,{cPerg,"02","Dt Referencia Ate?","Data       ?","Data       ?","mv_ch2","D",08,0,0,"G" ,"","mv_par02","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next

Return

//Funcao de Sincronismo com RC
Static Function AjustaRC(_cAnoMes)

cArqFec := "RC"+cEmpAnt+Subs( _cAnoMes,3,2)+Subs(_cAnoMes,5,2)
cArqFec := RetArq(__cRDD,cArqFec,.T.)
If !MSFile(cArqFec) //Verifica Existencia, senao cria
	If !MsCreate( cArqFec , aFields1 , __cRdd )
		MsgInfo( OemToAnsi( "Nao foi possivel criar o arquivo" )  , OemToAnsi( "Atencao" ) )		
	Endif
Endif

IF !MsOpenDbf( .T. , __cRdd , cArqFec , "FEC" , .F. )
	MsgInfo( OemToAnsi( "Nao foi possivel abrir o arquivo" )  , OemToAnsi( "Atencao" ) )	
	Return( NIL )
Else
	//Deleta os dados atuais
	While !Eof()
		delete
		skip()
	Enddo
	//--Append do Arquivo para mes seguinte
	RddSetDefault("DBFCDX")
	Append From &cArqDBF
EndIF

dbSelectArea("FEC")
dbCloseArea()

Return