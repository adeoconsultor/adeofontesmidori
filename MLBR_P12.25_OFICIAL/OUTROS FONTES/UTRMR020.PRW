#INCLUDE "PROTHEUS.CH"

#define STR0001  "Relatorio de Funcionarios."
#define STR0002  "Será impresso de acordo com os parametros solicitados pelo"
#define STR0003  "usuário."
#define STR0004  "Matricula"
#define STR0005  "Nome"
#define STR0006  "Centro Custo"
#define STR0007  "Cargo"
#define STR0008  "Zebrado"
#define STR0009  "Administraçäo"
#define STR0010  "Relatorio de Funcionarios"
#define STR0011  " MATR. NOME                           DT.NASC.   DT.ADMIS   EST.CIVIL         CARGO                     CENTRO CUSTO"
#define STR0012  "NOME                            MATR. DT.NASC.   DT.ADMIS   EST.CIVIL         CARGO                     CENTRO CUSTO"
#define STR0013  " MATR. NOME                           DT.NASC.   DT.ADMIS   EST.CIVIL         CARGO                               "
#define STR0014  "NOME                            MATR. DT.NASC.   DT.ADMIS   EST.CIVIL         CENTRO CUSTO                       "
#define STR0015  "Centro de Custo: "
#define STR0016  "Cargo: "
#define STR0017  "GRADUACAO DO FUNCIONARIO"
#define STR0018  "FATOR AVALIACAO                   GRADUACAO NECESSARIA              GRADUACAO FUNCIONARIO            "
#define STR0019  " *** Nao existe graduacao para este funcionario *** "
#define STR0020  "CURSOS DO FUNCIONARIO"
#define STR0021  "CURSO                                PERIODO         DURACAO VALIDADE  NECES. ENTIDADE                   NOTA PRESENCA REALIZ"
#define STR0022  " *** Nao existe Curso para este Funcionario ***"
#define STR0023  "HISTORICO DE CARREIRA"
#define STR0024  "ADMISSAO   DEMISSAO   EMPRESA                        CARGO                         "
#define STR0025  " *** Nao existe Historico de Carreira para este Funcionario *** "
#define STR0026  "HISTORICO DE CARREIRA NA EMPRESA"
#define STR0027  "DT AUMENTO  TP AUMENTO               FUNCAO                   "
#define STR0028  " *** Nao existe Historico de Carreira na Empresa para este Funcionario *** "
#define STR0030  "CURSOS EXTRACURRICULARES"
#define STR0031  "DATA       DESCRICAO                                ENTIDADE                       ESCOLARIDADE"
#define STR0032  " *** Nao existe Curso ExtraCurricular para este Funcionario *** "
#define STR0033  "SOLICITACAO DE CURSOS"
#define STR0034  "CURSO                               TURMA CALENDARIO                TP RESERVA    VZ ADIADO DT.SOLIC.         PERIODO       "
#define STR0035  "*** Nao existe Solicitacao de Curso feita por este Funcionario ***"
#define STR0037  "FATOR AVALIACAO                   GRADUACAO NECESSARIA               PONTOS           GRADUACAO FUNCIONARIO           PONTOS"
#define STR0038  "T O T A L :"
#define STR0039  "PONTOS"
#define STR0040  "AVALIACOES DE TREINAMENTO"
#define STR0041  "CALENDARIO                CURSO                     TURMA TIPO AVALIACAO       AVALIACAO                 DATA       RESULT."
#define STR0042  "*** Nao existe Avaliacao deste Funcionario ***"
#define STR0043  "DESCRICAO DETALHADA DO FATOR"
#define STR0044  " *** Nao existe Descricao detalhada do Fator *** "
#define STR0045  "OBSERVACAO FATOR DO FUNCIONARIO"
#define STR0046  " *** Nao tem nenhuma Observacao para este Fator *** "
#define STR0047  "SINONIMO: "
#define STR0048  "HABILIDADES"
#define STR0049  "HABIL. DESC.HABILIDADE                  ESC. DESC.ESCALA            ITEM DESC.ITEM ESCALA FUNC  ITEM DESC.ITEM ESCALA CARGO"
#define STR0050  "*** Nao existe Habilidade para este Funcionario ***"
#define STR0051  "Funcionário"
#define STR0052  "Grau Cargo"
#define STR0053  "Pontos"
#define STR0054  "Grau Func"	
#define STR0055  "Curso"
#define STR0056  "Sinônimo"
#define STR0057  "Período"
#define STR0058  "Validade"
#define STR0059  "Neces."
#define STR0060  "Entidade"
#define STR0061  "Calend"
#define STR0062  "Tipo Reserva"
#define STR0063  "Dt.Solic."
#define STR0064  "Tipo"
#define STR0065 "Esse relatório apresenta os dados do cadastro de funcionários. "
#define STR0066  "Sim"
#define STR0067  "Não"
#define STR0068  "It.Esc.Func"
#define STR0069  "It.Esc.Cargo"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TRMR020  ³ Autor ³ Eduardo Ju            ³ Data ³  26/06/06  ³±±           
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Cargos do Treinamento                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRMR020                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Tania       ³25/09/2006³100336³Acertos para o Relatorio personalizavel,  ³±±
±±³            ³          ³      ³do Release 4. Inclusao do Ajusta SX1.     ³±±
±±³Luiz Gustavo³02/02/2007³Melhor³Retiradas funcoes de ajuste de dicionario.³±±
±±³Eduardo Ju  ³22/06/2007³125709³Validacao da Impressao da Descr. do Item  ³±±
±±³            ³          ³      ³de Escala (Habilidades) - Release 3.      ³±±
±±³Eduardo Ju  ³10/07/2007³116452³Validacao da Impressao dos Cursos do      ³±±
±±³            ³          ³      ³Funcionario - Release 3.                  ³±±
±±³Eduardo Ju  ³02/10/2007³130665³Uso da fGetCargo na R4.                   ³±±
±±³Eduardo Ju  ³17/10/2007³133981³Validacao da Secao Habilidades na R4 e R3.³±±
±±³Leandro Dr. ³09/03/2009³005422³Retirado F3 do campo "Nome" do pergunte.  ³±±
±±³Leandro Dr. ³09/03/2009³005566³Ajuste na busca por cargos s/ C.C.        ³±±
±±³Leandro Dr. ³01/04/2009|005878³Ajuste para quebrar linha quando descricao³±±
±±³            ³          |      ³do fator ou grau ultrapassar 30 caracteres³±±
±±³Rogerio R.  ³29/07/2009³18271/³Compatibilizacao dos fontes para aumento o³±±
±±³            ³          ³ 2009 ³dcampo filial e gestão corporativa.       ³±±
±±³Andreia     ³23/10/2009³26377/³Ajuste para imprimir a descrição do cargo ³±±
±±³            ³          ³2009  ³de acordo com a filial.                   ³±±
±±³Luciana     ³22/01/2010³29570/³Ajuste para imprimir o codigo da filial do³±±
±±³            ³          ³2009  ³funcionario no cabecalho.                 ³±±
±±³Mauricio MR ³23/04/2010³5573/ ³Ajuste para imprimir a duracao do curso do³±±
±±³            ³          ³2010  ³funcionario. 				                ³±± 
±±³Luciana     ³11/08/2011³16958/³Ajuste na exibicao dos titulos do         ³±±
±±³            ³          ³2011  ³relatorio                                 ³±± 
±±³Gustavo M.  ³13/12/2011³32176/³Ajuste para impressao de campos da SRA no ³±±
±±³            ³          ³2011  ³relatorio personalizado.	                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function UTRMR020()
                                   
Local oReport
Local aArea 	:= GetArea()
Private cAliasX	:= "SRA"
Private cFator	:= ""
Private cItEscCar	:= ""    

AcertSX1()
AcertSXB()

	Pergunte("TRR20R",.F.)
	oReport := UReportDef()
	oReport:PrintDialog()	


RestArea( aArea )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef() ³ Autor ³ Eduardo Ju          ³ Data ³ 26.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Definicao do Componente de Impressao do Relatorio           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UReportDef()

Local oReport
Local oSection1	
Local oSection2         
Local oSection3
Local oSection4
Local oSection5
Local oSection6
Local oSection7
Local oSection8
Local oSection9            
Local oSection10
Local oSection11
Local oSection12
Local oSection13
Local aOrdem    := {}

Private cCalend
Private cCurso
Private cTurma
Private cTipo
Private cTeste                                
Private nTot
Private cDescCalend
Private cDescCurso
Private cDescTipo 
Private dData

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:=TReport():New("TRMR020",STR0001,"TRR20R",{|oReport| PrintReport(oReport)},STR0065+" "+STR0002+" "+STR0003)	//"Relatorio de Funcionarios"#"Será impresso de acordo com os parametros solicitados pelo usuario"
oReport:SetLandscape()
Pergunte("TRR20R",.F.)
cFator	:= Alltrim(MV_PAR08)

Aadd( aOrdem, STR0004)	// "Matricula"
Aadd( aOrdem, STR0005)	// "Nome"
Aadd( aOrdem, STR0006)	// "Centro de Custo" 
Aadd( aOrdem, STR0007)	// "Cargo" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Primeira Secao: Funcionario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
oSection1 := TRSection():New(oReport,STR0051,{"SRA","SQ3","SI3"},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection1:SetTotalInLine(.F.)  
oSection1:SetHeaderBreak()   

TRCell():New(oSection1,"RA_FILIAL","SRA")					//Matricula do Funcionario
TRCell():New(oSection1,"RA_MAT","SRA")					//Matricula do Funcionario
TRCell():New(oSection1,"RA_NOME","SRA")					//Nome do Funcionario
TRCell():New(oSection1,"RA_NASC","SRA")					//Dt. de Nascimento
TRCell():New(oSection1,"RA_ADMISSA","SRA")				//Dt. de Admissao
TRCell():New(oSection1,"RA_ESTCIVI","SRA",,,15,,{|| Left(TrmDesc("SX5","33"+(cAliasX)->RA_ESTCIVI,"SX5->X5_DESCRI"),15) })//Estado Civil
TRCell():New(oSection1,"RA_CARGO","SRA",,,,,{|| fGetCargo((cAliasX)->RA_MAT,(cAliasX)->RA_FILIAL)})				//Cargo
TRCell():New(oSection1,"Q3_DESCSUM","SQ3","",,,,{|| FDesc("SQ3",fGetCargo((cAliasX)->RA_MAT,(cAliasX)->RA_FILIAL),"SQ3->Q3_DESCSUM",30,(cAliasX)->RA_FILIAL)})			//Descricao do Cargo  
TRCell():New(oSection1,"RA_CC","SRA")					//Centro De Custo
TRCell():New(oSection1,"I3_DESC","SI3","") 			//Descricao do CC

TRPosition():New(oSection1,"SQ3",1,{|| TrmSqOrd("SQ3")}) 
TRPosition():New(oSection1,"SI3",1,{|| xFilial("SI3", (cAliasX)->RA_FILIAL) + (cAliasX)->RA_CC})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Segunda Secao: Graduacao do Funcionario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1,STR0017,{"SQ1","SQ8","SQ2","SQ4","SQV"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection2:SetTotalInLine(.F.)  
oSection2:SetHeaderBreak()
oSection2:ShowHeader(.T.) 	//Imprime Cabecalho da Secao
oSection2:SetLeftMargin(3)	//Identacao da Secao      

TRCell():New(oSection2,"Q1_FATOR","SQ1")			//Codigo do Fator
TRCell():New(oSection2,"Q1_DESCSUM","SQ1","",,30)	//Descricao do Fator 
TRCell():New(oSection2,"Q4_GRAU","SQ4",STR0052)//Codigo do Grau do Cargo  
TRCell():New(oSection2,"Q2_DESC","SQ2","",,20)		//Descricao do Grau do Cargo
TRCell():New(oSection2,"Q2_PONTOSI","SQ2",STR0053,"@E 9999.99")	//Pontos do Cargo 
TRCell():New(oSection2,"Q8_GRAU","SQ8",STR0054)//Codigo do Grau do Funcionario 
TRCell():New(oSection2,"QV_DESCGRA","SQV","",,30)	//Descricao do Grau do Funcionario
TRCell():New(oSection2,"Q8_PONTOS","SQ8",STR0053,"@E 9999.99",,,,,,,.T.)	//Pontos do Funcionario 
TRCell():New(oSection2,"Q1_DESCDET","SQ1")			//Codigo da Descricao Detalhada do Fator  		
TRCell():New(oSection2,"Q1_MEMO1","SQ1",STR0043,,,,{|| MSMM(SQ1->Q1_DESCDET,,,,3)},,,,.T.) //Descricao Detalhada do Fator 
TRCell():New(oSection2,"Q8_OBS","SQ8")				//Codigo da Observacao do Fator do Funcionario		
TRCell():New(oSection2,"Q8_MEMO1","SQ8",STR0045,/*Picture*/,,/*lPixel*/,{|| MSMM(SQ8->Q8_OBS,,,,3)}) //Descricao da Observacao do Fator do Funcionario  		

TRPosition():New(oSection2,"SQV",1,{|| xFilial("SQV",SQ8->Q8_FILIAL) + SQ8->Q8_FATOR + SQ8->Q8_GRAU })
TRPosition():New(oSection2,"SQ4",2,{|| TrmSqOrd("SQ4")})
TRPosition():New(oSection2,"SQ2",2,{|| xFilial("SQ2",SQ4->Q4_FILIAL) + SQ4->Q4_FATOR + SQ4->Q4_GRAU}) 
TRPosition():New(oSection2,"SQ1",3,{|| xFilial("SQ1",SQ4->Q4_FILIAL) + SQ4->Q4_GRUPO + SQ4->Q4_FATOR })

oSection2:SetLineStyle() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Terceira Secao: Historico da Carreira ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection3 := TRSection():New(oSection1,STR0023,{"SQC"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection3:SetTotalInLine(.F.)  
oSection3:SetHeaderBreak()
oSection3:ShowHeader(.T.) 	//Imprime Cabecalho da Secao
oSection3:SetLeftMargin(3)	//Identacao da Secao         

TRCell():New(oSection3,"QC_ADMISSA","SQC")			//Data de Admissao
TRCell():New(oSection3,"QC_DEMISSA","SQC")			//Data de Demissao
TRCell():New(oSection3,"QC_EMPRESA","SQC")			//Empresa
TRCell():New(oSection3,"QC_CARGO","SQC")			//Cargo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Quarta Secao: Historico da Carreira na Empresa  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection4 := TRSection():New(oSection1,STR0026,{"SR7"/*,"SRJ"*/},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection4:SetTotalInLine(.F.)  
oSection4:SetHeaderBreak()
oSection4:ShowHeader(.T.) 	//Imprime Cabecalho da Secao
oSection4:SetLeftMargin(3)	//Identacao da Secao                    

TRCell():New(oSection4,"R7_DATA","SR7")				//Data do Aumento
TRCell():New(oSection4,"R7_TIPO","SR7")				//Tipo de Aumento
TRCell():New(oSection4,"X5_DESCRI","SX5","",,20)	//Descricao do Tipo de Aumento
TRCell():New(oSection4,"R7_FUNCAO","SR7")			//Funcao
TRCell():New(oSection4,"RJ_DESC","SRJ")				//Descricao da Funcao

TRPosition():New(oSection4,"SRJ",1,{|| xFilial("SRJ",SR7->R7_FILIAL) + SR7->R7_FUNCAO})
TRPosition():New(oSection4,"SX5",1,{|| xFilial("SX5",SR7->R7_FILIAL) + "41" + SR7->R7_TIPO})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Quinta Secao: Cursos do Funcionario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection5 := TRSection():New(oSection1,STR0020,{"RA4"/*,"RA1","RA9","RA0"*/},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection5:SetTotalInLine(.F.)  
oSection5:SetHeaderBreak()
oSection5:ShowHeader(.T.) 	//Imprime Cabecalho da Secao
oSection5:SetLeftMargin(3)	//Identacao da Secao   
                                
TRCell():New(oSection5,"RA4_CURSO","RA4",STR0055)	//Codigo do Curso do Funcionario
TRCell():New(oSection5,"RA1_DESC","RA1","")		//Descricao do Curso  
TRCell():New(oSection5,"RA4_SINONI","RA4",STR0056)	//Sinonimo do Curso
TRCell():New(oSection5,"RA9_DESCR","RA9","")  		//Descricao do Sinonimo do Curso  
TRCell():New(oSection5,"RA4_DATAIN","RA4",STR0057)//Periodo: Data Inicio do Curso
TRCell():New(oSection5,"RA4_DATAFI","RA4","") 		//Periodo: Data Final do Curso 
TRCell():New(oSection5,"RA4_DURACA","RA4") 			//Duracao
TRCell():New(oSection5,"RA4_UNDURA","RA4","") 		//Unidade de Duracao
TRCell():New(oSection5,"RA4_VALIDA","RA4",STR0058) //Validade

//TRCell():New(<oParent>, <cName>, [ <cAlias> ], [ <cTitle> ],;
//							[ <cPicture> ], [ <nSize> ], [ <.lPixel.> ], [ <bBlock> ],;
//							[ <"cAlign"> ], [ <.lLineBreak.> ], [ <"cHeaderAlign"> ], [ <.lCellBreak.> ],;
//							[ <nColSpace> ], [<.lAutoSize.>], [ <nClrBack> ], [ <nClrFore> ])

//NECESSIDADE DE TREINAMENTO                                
TRCell():New(oSection5,"NECES","",STR0059,/*Picture*/,6,/*lPixel*/,{|| IIF(RA5->( DbSeek(xFilial("RA5") + (cAliasX)->RA_CARGO+(cAliasX)->RA_CC+RA4->RA4_CURSO )),STR0066,STR0067) }) //Descricao Detalhada do Fator 
TRCell():New(oSection5,"RA4_ENTIDA","RA4",STR0060)	//Codigo da Entidade 
TRCell():New(oSection5,"RA0_DESC","RA0","",,25)	//Descricao Codigo da Entidade 
TRCell():New(oSection5,"RA4_NOTA","RA4")			//Nota
TRCell():New(oSection5,"RA4_PRESEN","RA4")			//Presenca

//REALIZADO

TRPosition():New(oSection5,"RA1",1,{|| xFilial("RA1",RA4->RA4_FILIAL) + RA4->RA4_CURSO}) 
TRPosition():New(oSection5,"RA9",2,{|| xFilial("RA9",RA4->RA4_FILIAL) + RA4->RA4_CURSO})
TRPosition():New(oSection5,"RA0",1,{|| xFilial("RA0",RA4->RA4_FILIAL) + RA4->RA4_ENTIDA}) 
TRPosition():New(oSection5,"RA5",2,{|| xFilial("RA5",(cAliasX)->RA_FILIAL) + (cAliasX)->RA_CARGO+(cAliasX)->RA_CC+RA4->RA4_CURSO}) 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Sexta Secao: Cursos Extracurriculares ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection6 := TRSection():New(oSection1,STR0030,{"SQ9"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection6:SetTotalInLine(.F.)  
oSection6:SetHeaderBreak()
oSection6:ShowHeader(.T.) 	//Imprime Cabecalho da Secao
oSection6:SetLeftMargin(3)	//Identacao da Secao  
                            
TRCell():New(oSection6,"Q9_DATA","SQ9")				//Data do Termino do Curso 
TRCell():New(oSection6,"Q9_DESCRIC","SQ9",,,40)	//Descricao do Curso
TRCell():New(oSection6,"Q9_ENTIDAD","SQ9")			//Entidade do Curso
TRCell():New(oSection6,"Q9_ESCOLAR","SQ9")			//Escolaridade
TRCell():New(oSection6,"Q9_PONTOS","SQ9")			//Pontos

TRFunction():New(oSection6:Cell("Q9_PONTOS"),/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,"@E 9999.99"/*cPicture*/,/*uFormula*/,/*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Setima Secao: Solicitacao de Cursos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection7 := TRSection():New(oSection1,STR0033,{"RA3"/*,"RA1","RA2"*/},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection7:SetTotalInLine(.F.)  
oSection7:SetHeaderBreak()
oSection7:ShowHeader(.T.) 	//Imprime Cabecalho da Secao
oSection7:SetLeftMargin(3)	//Identacao da Secao   

TRCell():New(oSection7,"RA3_CURSO","RA3",STR0055)		//Codigo do Curso    
TRCell():New(oSection7,"RA1_DESC","RA1","")			//Descricao do Curso  
TRCell():New(oSection7,"RA3_TURMA","RA3")				//Turma  
TRCell():New(oSection7,"RA3_CALEND","RA3",STR0061)		//Calendario de Treinamento
TRCell():New(oSection7,"RA2_DESC","RA2","")			//Descricado do Calendario
TRCell():New(oSection7,"RA3_RESERV","RA3")				//Codigo do Tipo da Reserva #SUPRIMIR
TRCell():New(oSection7,"X5_DESCRI","SX5",STR0062,,20)//Descricao do Tipo da Reserva
TRCell():New(oSection7,"RA3_NVEZAD","RA3") 		   		//Periodo: Data Final do Curso 
TRCell():New(oSection7,"RA3_DATA","RA3",STR0063)		//Data da Solicitacao  
TRCell():New(oSection7,"RA2_DATAIN","RA2",STR0057)		//Periodo: Data Inicio do Curso
TRCell():New(oSection7,"RA2_DATAFI","RA2","") 			//Periodo: Data Final do Curso 

TRPosition():New(oSection7,"RA1",1,{|| xFilial("RA1",RA3->RA3_FILIAL) + RA3->RA3_CURSO}) 
TRPosition():New(oSection7,"RA2",1,{|| xFilial("RA2",RA3->RA3_FILIAL) + RA3->RA3_CALEND+RA3->RA3_CURSO+RA3->RA3_TURMA})
TRPosition():New(oSection7,"SX5",1,{|| xFilial("SX5",RA3->RA3_FILIAL) + "R7" + RA3->RA3_RESERV})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Oitava Secao: Avaliacoes de Treinamento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection8 := TRSection():New(oSection1,STR0040,{"RAI"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection8:SetTotalInLine(.F.)  
oSection8:SetHeaderBreak()
oSection8:ShowHeader(.T.) 	//Imprime Cabecalho da Secao
oSection8:SetLeftMargin(3)	//Identacao da Secao  

TRCell():New(oSection8,"RAI_CALEND","RAI")			//Codigo do Calendario  
TRCell():New(oSection8,"RA2_DESC","RA2","")		//Descricado do Calendario
TRCell():New(oSection8,"RAI_CURSO","RAI")			//Codigo do Curso  
TRCell():New(oSection8,"RA1_DESC","RA1","")		//Descricao do Curso  
TRCell():New(oSection8,"RAI_TURMA","RAI")		  	//Turma
TRCell():New(oSection8,"RAI_TIPO","RAI",STR0064)	//Codigo do Tipo de Avaliacao  
TRCell():New(oSection8,"X5_DESCRI","SX5","",,20)	//Descricao do Tipo de Avaliacao  
TRCell():New(oSection8,"RAI_TESTE","RAI")		  	//Codigo da Avaliacao 

//If Len("RAI_TESTE") == 3
TRCell():New(oSection8,"QQ_DESCRIC","SQQ","")	  	//Descricao da Avaliacao 
/*Else
	TRCell():New(oSection8,"QW_DESCRIC","SQW","",,20)	  //Descricao da Avaliacao 
EndIf*/

TRCell():New(oSection8,"RAJ_DATA","RAJ")		  	//Data da Avaliacao 

//TRCell():New(oSection8,"DATA","","Data",,8,,{|| dData })		  	//Data da Avaliacao 
TRCell():New(oSection8,"RAI_RESULT","RAI",,,,,{|| TrTotResult() })		//Resultado da Avaliacao 

TRPosition():New(oSection8,"RA1",1,{|| xFilial("RA1",RAI->RAI_FILIAL) + RAI->RAI_CURSO})   
TRPosition():New(oSection8,"RA2",1,{|| xFilial("RA2",RAI->RAI_FILIAL) + RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA})
TRPosition():New(oSection8,"SX5",1,{|| xFilial("SX5",RAI->RAI_FILIAL) + "RJ" + RAI->RAI_TIPO})          
TRPosition():New(oSection8,"RAJ",1,{|| xFilial("RAJ",RAI->RAI_FILIAL) + RAI->RAI_CALEND+RAI->RAI_CURSO})  

//If Len("RAI_TESTE") == 3
	TRPosition():New(oSection8,"SQQ",1,{|| xFilial("SQQ",RAI->RAI_FILIAL) + Alltrim(RAI->RAI_TESTE)}) 
/*Else
	TRPosition():New(oSection8,"SQW",1,{|| xFilial("SQW") + RAI->RAI_TESTE}) 
EndIf*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Nona Secao: Habilidades ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection9 := TRSection():New(oSection1,STR0048,{"RBI","RBH","RBK","RBL"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection9:SetTotalInLine(.F.)  
oSection9:SetHeaderBreak()
oSection9:ShowHeader(.T.) 	//Imprime Cabecalho da Secao
oSection9:SetLeftMargin(3)	//Identacao da Secao  

TRCell():New(oSection9,"RBI_HABIL","RBI")		  	   	//Codigo da Habilidade
TRCell():New(oSection9,"RBG_DESC","RBG","",,40) 		//Descricao da Habilidade
TRCell():New(oSection9,"RBI_ESCALA"	,"RBI") 	   	   	//Escala
TRCell():New(oSection9,"RBK_DESCRI"	,"RBK","",,30) 		//Descricao da Escala
TRCell():New(oSection9,"RBI_ITESCA"	,"RBI",STR0068) 	//Item de Escala do Funcionario
TRCell():New(oSection9,"RBL_DESCRI"	,"RBL","",,30)		//Descricao do Item de Escala 
TRCell():New(oSection9,"RBH_ITESCA"	,"RBH",STR0069,,,,{|| FItEscCar() }) 	//Item de Escala dp Cargo
TRCell():New(oSection9,"X_RBL_DESCRI","RBL","",,30,,{|| FDesc("RBL",RBH->RBH_ESCALA+cItEscCar,"RBL_DESCRI") }) //Descricao do Item de Escala do Cargo

TRPosition():New(oSection9,"RBG",1,{|| xFilial("RBG",RBI->RBI_FILIAL) + RBI->RBI_HABIL }) 
TRPosition():New(oSection9,"RBK",1,{|| xFilial("RBK",RBI->RBI_FILIAL) + RBI->RBI_ESCALA }) 
TRPosition():New(oSection9,"RBL",1,{|| xFilial("RBL",RBI->RBI_FILIAL) + RBI->RBI_ESCALA + RBI->RBI_ITESCA }) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Segunda Secao: Descricao Detalhada do Cargo ³
//³ Diego Mafisolli 10/05/2017 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

oSection10 := TRSection():New(oSection1,"CARGO DO FUNCIONARIO",{"SQ3","SQ0","SQB","SI3"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection10:SetTotalInLine(.F.)  
oSection10:SetHeaderBreak()
oSection10:ShowHeader(.T.) 	//Imprime Cabecalho da Secao
oSection10:SetLeftMargin(3)	//Identacao da Secao    

TRCell():New(oSection10,"Q3_CARGO","SQ3",,,,,{|| fGetCargo((cAliasX)->RA_MAT,(cAliasX)->RA_FILIAL)})				//Cargo
TRCell():New(oSection10,"Q3_DESCSUM","SQ3",,,,,{|| FDesc("SQ3",fGetCargo((cAliasX)->RA_MAT,(cAliasX)->RA_FILIAL),"SQ3->Q3_DESCSUM",30,(cAliasX)->RA_FILIAL)})			//Descricao do Cargo  
TRCell():New(oSection10,"Q3_GRUPO","SQ3",,,,,{|| FDesc("SQ3",fGetCargo((cAliasX)->RA_MAT,(cAliasX)->RA_FILIAL),"SQ3->Q3_GRUPO",30,(cAliasX)->RA_FILIAL)})				//Grupo
TRCell():New(oSection10,"Q0_DESCRIC","SQ0","")				//Descricao do Grupo
TRCell():New(oSection10,"Q3_DEPTO","SQ3",,,,,{|| FDesc("SQ3",fGetCargo((cAliasX)->RA_MAT,(cAliasX)->RA_FILIAL),"SQ3->Q3_DEPTO",30,(cAliasX)->RA_FILIAL)})		//Codigo do Depto
TRCell():New(oSection10,"QB_DESCRIC","SQB","")			//Descricao do Depto 
TRCell():New(oSection10,"Q3_CC","SQ3",,,20,.T.)					//Centro de Custo
TRCell():New(oSection10,"I3_DESC","SI3","") 			//Descricao do CC

TRPosition():New(oSection1,"SQ0",1,{|| RhFilial("SQ0",SQ3->Q3_FILIAL) + SQ3->Q3_GRUPO})
TRPosition():New(oSection1,"SQB",1,{|| RhFilial("SQB",SQ3->Q3_FILIAL) + SQ3->Q3_DEPTO})
TRPosition():New(oSection1,"SI3",1,{|| RhFilial("SI3",SQ3->Q3_FILIAL) + SQ3->Q3_CC}) 

oSection11 := TRSection():New(oSection1,"DESCRICAO DETALHADA DO CARGO",{"SQ3"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection11:SetTotalInLine(.F.)  
oSection11:SetHeaderBreak()
oSection11:ShowHeader(.T.) 	//Imprime Cabecalho da Secao
oSection11:SetLeftMargin(8)	//Identacao da Secao 

TRCell():New(oSection11,"Q3_MEMO1","SQ3","",/*Picture*/,,/*lPixel*/,{|| MSMM(FDesc("SQ3",fGetCargo((cAliasX)->RA_MAT,(cAliasX)->RA_FILIAL),"SQ3->Q3_DESCDET",30,(cAliasX)->RA_FILIAL),,,,3)}) //Descricao Detalhada do Cargo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Sexta Secao: Graduacao dos Cargos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection12:= TRSection():New(oSection1,"",{"SQ4","SQ1","SQ2"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection12:SetTotalInLine(.F.)  
oSection12:SetHeaderBreak()
oSection12:ShowHeader(.T.) 	//Imprime Cabecalho da Secao
oSection12:SetLeftMargin(8)	//Identacao da Secao  
                              
TRCell():New(oSection12,"Q4_FATOR","SQ4","GRADUACAO")		//Codigo do Fator
TRCell():New(oSection12,"Q1_DESCSUM","SQ1","")	   		//Descricao do Fator 
TRCell():New(oSection12,"Q4_GRAU","SQ4",,,10,.T.)		//Codigo do Grau
TRCell():New(oSection12,"Q2_DESC","SQ2","")				//Descricao do Grau
TRCell():New(oSection12,"Q4_PONTOS","SQ4",,"@E 9999.99",15,.T.)//Pontos   

TRPosition():New(oSection12,"SQ1",3,{|| RhFilial("SQ1",SQ4->Q4_FILIAL) + SQ4->Q4_FATOR})
TRPosition():New(oSection12,"SQ2",2,{|| RhFilial("SQ2",SQ4->Q4_FILIAL) + SQ4->Q4_FATOR + SQ4->Q4_GRAU})	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Setima Secao: Cursos dos Cargos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection13 := TRSection():New(oSection1,"",{"RA5","RA1"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection13:SetTotalInLine(.F.)  
oSection13:SetHeaderBreak()
oSection13:ShowHeader(.T.) 	//Imprime Cabecalho da Secao
oSection13:SetLeftMargin(8)	//Identacao da Secao  

TRCell():New(oSection13,"RA5_CURSO","RA5","CURSOS DO CARGO")	//Codigo do Curso  
TRCell():New(oSection13,"RA1_DESC","RA1","")		//Descricao do Curso 
TRCell():New(oSection13,"RA5_VALIDA","RA5")			//Validade
TRCell():New(oSection13,"RA5_HORAS","RA5")			//Horas Minima
TRCell():New(oSection13,"RA5_NOTA","RA5")			//Nota Minima 
TRCell():New(oSection13,"RA5_FREQUE","RA5")			//% Frequencia Minima  
TRCell():New(oSection13,"RA5_PRIORI","RA5")			//Prioridade
TRCell():New(oSection13,"RA5_UNPRIO","RA5")			//Unidade da Prioridade

TRPosition():New(oSection13,"RA1",1,{|| RhFilial("RA1",RA5->RA5_FILIAL) + RA5->RA5_CURSO }) 


Return oReport   

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TrmSqOrd()  ³ Autor ³ Leandro Dr.         ³ Data ³ 09.03.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Seta a ordem de pesquisa do SQ3 e SQ4                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³TRMR020                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function TrmSqOrd(cAlias)
Local aArea  := GetArea()
Local bRet   := {|| }
Local cChave := ""

dbSelectArea("SQ3")
dbSetOrder(1)

If dbSeek(xFilial("SQ3", (cAliasX)->RA_FILIAL)+(cAliasX)->RA_CARGO+(cAliasX)->RA_CC)
	cChave 	:= (cAliasX)->RA_CARGO+SQ3->Q3_CC
Else
	cChave	:= (cAliasX)->RA_CARGO+Space(TamSX3("RA_CC")[1])
EndIf

If cAlias == "SQ3"
	bRet := {|| xFilial("SQ3", (cAliasX)->RA_FILIAL) + cChave}
Else
	bRet := {|| xFilial("SQ4", (cAliasX)->RA_FILIAL) + cChave + SQ8->Q8_FATOR}
EndIf

RestArea(aArea)

Return Eval(bRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef() ³ Autor ³ Eduardo Ju          ³ Data ³ 28.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Relatorio                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)  
Local oSection3 := oReport:Section(1):Section(2)
Local oSection4 := oReport:Section(1):Section(3)
Local oSection5 := oReport:Section(1):Section(4)
Local oSection6 := oReport:Section(1):Section(5)
Local oSection7 := oReport:Section(1):Section(6)
Local oSection8 := oReport:Section(1):Section(7)
Local oSection9 := oReport:Section(1):Section(8)
Local oSection10 :=oReport:Section(1):Section(9)
Local oSection11 :=oReport:Section(1):Section(10)
Local oSection12 :=oReport:Section(1):Section(11)
Local oSection13 :=oReport:Section(1):Section(12)
Local cAcessaSRA:= &("{ || " + ChkRH(FunName(),"SRA","2") + "}")
Local cFiltro 	:= ""
Local nOrdem  	:= osection1:GetOrder()
Local cIndCond	:= ""                                               
Local cSituacao	:= MV_PAR06
Local nRegX		:= 1

oSection1:SetLineCondition(cAcessaSRA)

oSection2:SetLineCondition( {|| fCheckSq8() })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ MV_PAR01        //  Filial                                   ³ 
//³ MV_PAR02        //  Matricula                                ³ 
//³ MV_PAR03        //  Nome                                     ³ 
//³ MV_PAR04        //  Centro Custo                             ³ 
//³ MV_PAR05        //  Cargo                                    ³ 
//³ MV_PAR06        //  Situacao do Funcionario					 ³ 
//³ MV_PAR07        //  Imprime Graduacao S/N                    ³ 
//³ MV_PAR08        //  Fator Graduacao                          ³ 
//³ MV_PAR09        //  Impr Pontos S/N  		                 ³ 
//³ MV_PAR10        //  Impr Somente Totais Ptos S/N             ³ 
//³ MV_PAR11       	//  Imprime Desc. Detalhada do Fator S/N 	 ³ 
//³ MV_PAR12       	//  Imprime Observacao do Fator Funcion. S/N ³ 
//³ MV_PAR13        //  Imprime Historico Carreira S/N           ³ 
//³ MV_PAR14        //  Imprime Historico Carreira Empresa S/N   ³ 
//³ MV_PAR15        //  Imprime Cursos S/N                       ³ 
//³ MV_PAR16        //  Imprime Cursos Realizados S/N/Ambos      ³ 
//³ MV_PAR17       	//  Imprime Sinonimo de Curso S/N 			 ³ 
//³ MV_PAR18        //  Imprime Cursos Extracurriculares S/N     ³ 
//³ MV_PAR19        //  Imprime Solicitacao Cursos S/N           ³ 
//³ MV_PAR20        //  Imprime Avaliacoes Cursos S/N			 ³ 
//³ MV_PAR21       	//  Imprime Habilidades                      ³ 
//³ MV_PAR22        //  Impr. um Funcion. por Folha S/N          ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Graduacao do Funcionario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR07 <> 1
	oSection2:Disable()
EndIf        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Pontos dos Fatores de Graduacao do Cargo e do Funcionario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR09 <> 1    
	oSection2:Cell("Q2_PONTOSI"):Disable()
	oSection2:Cell("Q8_PONTOS"):Disable()
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Totais dos Pontos dos Fatores de Graduacao do Cargo e do Funcionario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR10 = 1               
	TRFunction():New(oSection2:Cell("Q2_PONTOSI"),/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,"@E 9999.99"/*cPicture*/,/*uFormula*/,/*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection2:Cell("Q8_PONTOS"),/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,"@E 9999.99"/*cPicture*/,/*uFormula*/,/*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Descricao Detalhada do Fator ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR11 <> 1
	oSection2:Cell("Q1_DESCDET"):Disable()	
	oSection2:Cell("Q1_MEMO1"):Disable() 
Else 
	oSection2:Cell("Q1_DESCDET"):Disable()	
	oSection2:Cell("Q1_MEMO1"):SetLineBreak() //Impressao de campo Memo
EndIf                                     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Observacao do Fator Funcionario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR12 <> 1      	
	oSection2:Cell("Q8_OBS"):Disable()
	oSection2:Cell("Q8_MEMO1"):Disable() 
Else
	oSection2:Cell("Q8_OBS"):Disable()
	oSection2:Cell("Q8_MEMO1"):SetLineBreak() //Impressao de campo Memo
	oSection2:SetLineBreak()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Historico de Carreira ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR13 <> 1
	oSection3:Disable()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Historico de Carreira na Empresa ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR14 <> 1
	oSection4:Disable()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cursos do Funcionario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR15 <> 1
	oSection5:Disable()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Graduacao do Cargo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*If MV_PAR16
	
EndIf */

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Sinonimo do Cursos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR17 <> 1
	oSection5:Cell("RA4_SINONI"):Disable()	
	oSection5:Cell("RA9_DESCR"):Disable()	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cursos Extracurriculares ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR18 <> 1 
	oSection6:Disable()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Solicitacao de Curso     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR19 <> 1 
	oSection7:Disable()
Else
	oSection7:Cell("RA3_RESERV"):Disable()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Avaliacoes de Treinamento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR20 <> 1 
	oSection8:Disable()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Habilidades ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR21 <> 1 
	oSection9:Disable()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Um Funcionario por Folha ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR22 == 1   		
	oSection1:SetPageBreak(.T.) //Salta Pagina		
EndIf

cSitQuery	:= ""
// filtro do relatorio
#IFDEF TOP
	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	MakeSqlExpr("TRR20R")
	cAliasX	:= GetNextAlias()

	//-- Modifica variaveis para a Query
	For nRegX:=1 to Len(cSituacao)
		cSitQuery += "'"+Subs(cSituacao,nRegX,1)+"'"
		If ( nRegX+1 ) <= Len(cSituacao)
			cSitQuery += "," 
		Endif
	Next nRegX     
	cSitQuery := "%" + cSitQuery + "%"

	oSection1:BeginQuery()

	If nOrdem == 1
		cOrdem := "%RA_FILIAL,RA_MAT%"
	ElseIf nOrdem == 2
		cOrdem := "%RA_FILIAL,RA_NOME%" 
	ElseIf nOrdem == 3
		cOrdem := "%RA_FILIAL,RA_CC%"
	Elseif nOrdem == 4
		cOrdem := "%RA_FILIAL,RA_CARGO%"
	Endif

	BeginSql alias cAliasX  //"SRA"              

	SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_NASC, RA_ADMISSA, RA_ESTCIVI, RA_CARGO, RA_CC
	FROM %table:SRA% SRA 
	WHERE	SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%) AND
			SRA.%notDel%   
			ORDER BY %exp:cOrdem%

	EndSql
	END REPORT QUERY oSection1 PARAM MV_PAR01, MV_PAR02, MV_PAR03 , MV_PAR04 , MV_PAR05

	oSection1:EndQuery()
#ELSE             
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ MV_PAR01        //  Filial                                   ³
	//³ MV_PAR02        //  Matricula                                ³
	//³ MV_PAR03        //  Nome                                     ³
	//³ MV_PAR04        //  Centro de custo                          ³
	//³ MV_PAR05        //  Cargo                                    ³
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	MakeAdvplExpr("TRR20R")	                                  

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a ordem selecionada                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//"Matr¡cula"###"Centro de Custo"###"Nome"###"Centro de Custo + Nome"//
	If nOrdem == 1
		cIndCond:= "RA_FILIAL+RA_MAT"
	ElseIf nOrdem == 2
		cIndCond:= "RA_FILIAL+RA_NOME"
	ElseIf nOrdem == 3
		cIndCond:= "RA_FILIAL+RA_CC"
	Elseif nOrdem == 4
		cIndCond:= "RA_FILIAL+RA_CARGO"
	Endif

	//-- Adiciona no filtro o parametro tipo Range
	cCond	:= ""

	//³ MV_PAR01        //  Filial                                   ³ 
	If !Empty(MV_PAR01)
		cCond += MV_PAR01 + " .AND. "
	EndIf                 

	//³ MV_PAR02        //  Matricula                                ³ 
	If !Empty(MV_PAR02)
		cCond += MV_PAR02 + " .AND. "
	EndIf                 

	//³ MV_PAR03        //  Nome                              ³ 
	If !Empty(MV_PAR03)
		cCond += MV_PAR03 + " .AND. "
	EndIf                 

	//³ MV_PAR04        //  Centro Custo                             ³ 
	If !Empty(MV_PAR04)
		cCond += MV_PAR04 + " .AND. "
	EndIf                 

	//³ MV_PAR05        //  Cargo                                    ³ 
	If !Empty(MV_PAR05)
		cCond += MV_PAR05 + " .AND. "
	EndIf                 

	cCond	+= 'RA_SITFOLH $ "' + cSituacao + '"'

  	oSection1:SetFilter(cCond,cIndCond) 
#ENDIF
	
	/*If !Empty(MV_PAR08)
		cFiltro := MV_PAR08 
		oSection2:SetFilter(cFiltro)
	EndIf */
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ordem do Relatorio   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*If nOrdem == 1	
		oSection1:SetIdxOrder(1)	//Matricula
	ElseIf nOrdem == 2
	 	oSection1:SetIdxOrder(3)	//Nome
	ElseIf nOrdem == 3
		oSection1:SetIdxOrder(2)	//Centro de Custo
	ElseIf nOrdem == 4	
		oSection1:SetIdxOrder(7)	//Cargo
	EndIf  */

dbSelectArea( cAliasX )                              
   		    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Condicao para Impressao   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2:SetRelation({|| xFilial("SQ8", (cAliasX)->RA_FILIAL) + (cAliasX)->RA_MAT} ,"SQ8",1,.T.)
oSection2:SetParentFilter({|cParam| SQ8->Q8_FILIAL+SQ8->Q8_MAT == cParam},{|| (cAliasX)->RA_FILIAL + (cAliasX)->RA_MAT })

oSection3:SetRelation({|| xFilial("SQC", (cAliasX)->RA_FILIAL) + (cAliasX)->RA_MAT} ,"SQC",1,.T.)
oSection3:SetParentFilter({|cParam| SQC->QC_FILIAL+SQC->QC_MAT == cParam},{|| (cAliasX)->RA_FILIAL + (cAliasX)->RA_MAT})

oSection4:SetRelation({|| xFilial("SR7", (cAliasX)->RA_FILIAL) + (cAliasX)->RA_MAT},"SR7",1,.T.)
oSection4:SetParentFilter({|cParam| SR7->R7_FILIAL+SR7->R7_MAT == cParam},{|| (cAliasX)->RA_FILIAL + (cAliasX)->RA_MAT }) 

oSection5:SetRelation({|| xFilial("RA4", (cAliasX)->RA_FILIAL) + (cAliasX)->RA_MAT},"RA4",1,.T.)
oSection5:SetParentFilter({|cParam| RA4->RA4_FILIAL+RA4->RA4_MAT == cParam},{|| (cAliasX)->RA_FILIAL + (cAliasX)->RA_MAT })

oSection6:SetRelation({|| xFilial("SQ9", (cAliasX)->RA_FILIAL) + (cAliasX)->RA_MAT},"SQ9",1,.T.)
oSection6:SetParentFilter({|cParam| SQ9->Q9_FILIAL+SQ9->Q9_MAT == cParam},{|| (cAliasX)->RA_FILIAL + (cAliasX)->RA_MAT })
	
oSection7:SetRelation({|| xFilial("RA3", (cAliasX)->RA_FILIAL) + (cAliasX)->RA_MAT},"RA3",1,.T.)
oSection7:SetParentFilter({|cParam| RA3->RA3_FILIAL+RA3->RA3_MAT == cParam},{|| (cAliasX)->RA_FILIAL + (cAliasX)->RA_MAT })

//Criacao de Indice Temporario	
oSection8:SetFilter("","RAI_FILIAL+RAI_MAT+RAI_CALEND+RAI_CURSO+RAI_TURMA+RAI_TESTE")
oSection8:SetRelation({|| xFilial("RAI", (cAliasX)->RA_FILIAL) + (cAliasX)->RA_MAT},"RAI",oSection8:GetIdxOrder(),.T.)
oSection8:SetParentFilter({|cParam| RAI->RAI_FILIAL+RAI->RAI_MAT == cParam},{|| (cAliasX)->RA_FILIAL + (cAliasX)->RA_MAT })
	
oSection9:SetRelation({|| xFilial("RBI", (cAliasX)->RA_FILIAL) + (cAliasX)->RA_MAT},"RBI",1,.T.)
oSection9:SetParentFilter({|cParam| RBI->RBI_FILIAL+RBI->RBI_MAT == cParam},{|| (cAliasX)->RA_FILIAL + (cAliasX)->RA_MAT })

oSection10:SetRelation({|| xFilial("SQ3", (cAliasX)->RA_FILIAL) + (cAliasX)->RA_CARGO},"SQ3",1,.T.)
oSection10:SetParentFilter({|cParam| SQ3->Q3_CARGO == cParam},{||(cAliasX)->RA_CARGO }) //

oSection11:SetRelation({|| xFilial("SQ3", (cAliasX)->RA_FILIAL) + (cAliasX)->RA_CARGO},"SQ3",1,.T.)
oSection11:SetParentFilter({|cParam| SQ3->Q3_CARGO == cParam},{||(cAliasX)->RA_CARGO }) //

oSection12:SetRelation({|| xFilial("SQ4")+SQ3->Q3_CARGO},"SQ4",1,.T.)
oSection12:SetParentFilter({|cParam| SQ4->Q4_CARGO == cParam},{|| SQ3->Q3_CARGO})	                             

oSection13:SetRelation({|| xFilial("RA5")+SQ3->Q3_CARGO},"RA5",1,.T.)
oSection13:SetParentFilter({|cParam| RA5->RA5_CARGO == cParam},{|| SQ3->Q3_CARGO})	

		                              
oReport:SetMeter((cAliasX)->(LastRec()))	
oSection1:Print() //Imprimir 

Return Nil       

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TrTotResult ³ Autor ³ Eduardo Ju          ³ Data ³ 30.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Somatoria da Pontuacao da Avaliacao                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRMR020                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function TrTotResult()

Local cLoop 	:= RAI->RAI_MAT+RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA+RAI->RAI_TESTE
Local nTotal 	:= 0
Local cSvAlias 	:= Alias()
Local lSkip 	:= .F.

DbSelectArea("RAI")
While !Eof() .And. RAI->RAI_MAT+RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA+RAI->RAI_TESTE == cLoop
	lSkip := .T.
	nTotal += RAI->RAI_RESULT
	DbSkip()
EndDo

If lSkip
	DbSkip(-1)
EndIf

DbSelectArea(cSvAlias)

Return nTotal

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FItEscCar   ³ Autor ³ Eduardo Ju          ³ Data ³ 17.10.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Codigo e Descrição do Item de Escala do 'Cargo'             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRMR020                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FItEscCar()  
  
Local aSaveArea	:= GetArea()
Local cCargo 	:= fGetCargo((cAliasX)->RA_MAT,(cAliasX)->RA_FILIAL)
Local cCC    	:= (cAliasX)->RA_CC  
	
dbSelectArea("SQ3")
dbSetOrder(1)

If dbSeek(xFilial("SQ3")+cCargo+cCC) .Or. dbSeek(xFilial("SQ3")+cCargo) 
    	
	dbSelectArea("RBH")
   	dbSetOrder(2)
	
	If dbSeek(xFilial("RBH")+SQ3->Q3_GRUPO+cCargo+cCC) .Or. dbSeek(xFilial("RBH")+SQ3->Q3_GRUPO+cCargo)
					
		While RBH->(!Eof()) 
							            
			If RBH->RBH_HABIL+RBH->RBH_ESCALA == RBI->RBI_HABIL+RBI->RBI_ESCALA  					
				cItEscCar := RBH->RBH_ITESCA
				Exit
			EndIf 
			
        	RBH->(dbSkip())
   		EndDo
		
	EndIf
EndIf  

RestArea(aSaveArea)
	    
Return cItEscCar

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TRMR020   ºAutor  ³Microsiga           º Data ³  10/28/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fCheckSQ8()   

Local aAreaSq8	:= GetArea()
Local lRetorno	:= .F.

dbSelectArea("SQ8")
dbSetOrder(1) //Q8_FILIAL+Q8_MAT+Q8_FATOR
If dbSeek(xFilial("SQ8",(cAliasX)->RA_FILIAL)+(cAliasX)->RA_MAT+cFator)
	lRetorno	:= .T.
Endif
        
RestArea(aAreaSQ8)

Return(lRetorno)

//=========>> Daqui para baixo, trata-se do release 3 ou anterior.
/*
PROGRAMA FONTE ORIGINAL ABAIXO
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TRMR020R3³ Autor ³ Cristina Ogura        ³ Data ³ 08.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Funcionarios para o treinamento               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRMR020R3(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Emerson G.R.³27/05/04³xxxxxx³Tratam. Cargo do Funcionario - fGetCargo()³±±
±±³Emerson G.R.³22/06/04³071935³Correcao na busca de cargo por C.C.		  ³±±
±±³Eduardo Ju  ³30/06/04³072410³Impressao de data de avaliacoes.		  ³±± 
±±³Emerson G.R.³20/08/04³002533³Correc.no espacamento do campo RA4_DURACA.³±±
±±³Eduardo Ju  ³20/01/05³076915³Inclusao do Parametro: Cursos Realizados. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function TRMR020R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cString 	:= "SRA"       							// Alias do arquivo principal (Base)
Local cDesc1  	:= STR0001								//"Relatorio de Funcionarios."
Local cDesc2  	:= STR0002								//"Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3  	:= STR0003								//"usu rio."
Local aOrd    	:= {STR0004,STR0005,STR0006,STR0007}	//"Matricula"###"Nome"###"Centro Custo"###"Cargo"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {STR0008,1,STR0009,2,2,1,"",1 }		//"Zebrado"###"Administra‡„o"
Private NomeProg := "TRMR020"
Private aLinha   := {}
Private nLastKey := 0
Private cPerg    := "TRR020"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Titulo   := STR0010						//"Relatorio de Funcionarios"
Private Colunas  := 132 
Private AT_PRG   := "TRR020"
Private wCabec0  := 1
Private wCabec1  := ""
Private Contfl   := 1
Private Li       := 0
Private nTamanho := "M" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("TRR020",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ MV_PAR01        //  Filial de                                ³
//³ MV_PAR02        //  Filial ate                               ³
//³ MV_PAR03        //  Matricula de                             ³
//³ MV_PAR04        //  Matricula ate                            ³
//³ MV_PAR05        //  Nome de                                  ³
//³ MV_PAR06        //  Nome ate                                 ³
//³ MV_PAR07        //  Centro Custo de                          ³
//³ MV_PAR08        //  Centro Custo ate                         ³
//³ MV_PAR09        //  Cargo de                                 ³
//³ MV_PAR10        //  Cargo ate                                ³
//³ MV_PAR11        //  Imprime Graduacao S/N                    ³
//³ MV_PAR12        //  Imprime Historico Carreira S/N           ³
//³ MV_PAR13        //  Imprime Historico Carreira Empresa S/N   ³
//³ MV_PAR14        //  Imprime Cursos S/N                       ³
//³ MV_PAR15        //  Imprime Cursos Extracurriculares S/N     ³
//³ MV_PAR16        //  Imprime Solicitacao Cursos S/N           ³
//³ MV_PAR17        //  Impr. um Funcion. por Folha S/N          ³
//³ MV_PAR18        //  Impr Pontos S/N  		                 ³
//³ MV_PAR19        //  Impr Somente Totais Ptos S/N             ³
//³ MV_PAR20        //  Fator Graduacao De                       ³
//³ MV_PAR21        //  Fator Graduacao Ate                      ³
//³ MV_PAR22        //  Situacao do Funcionario					 ³
//³ MV_PAR23        //  Imprime Avaliacoes Cursos S/N			 ³
//³ MV_PAR24       	//  Imprime Desc. Detalhada do Fator S/N 	 ³
//³ MV_PAR25       	//  Imprime Observacao do Fator Funcion. S/N ³
//³ MV_PAR26       	//  Imprime Sinonimo de Curso S/N 			 ³
//³ MV_PAR27       	//  Habilidades                   			 ³
//³ MV_PAR28        //  Imprime Cursos Realizados S/N/Ambos      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="TRMR020"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

If nLastKey = 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
EndIf

RptStatus({|lEnd| Tr020Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Tr020Imp ³ Autor ³ Cristina Ogura        ³ Data ³ 08.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao que imprime os requisitos dos funcionarios          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Tr020Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        - A‡Æo do Codelock                             ³±±
±±³          ³ wnRel       - T¡tulo do relat¢rio                          ³±±
±±³          ³ cString     - Mensagem			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRMR020                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Tr020Imp(lEnd,WnRel,cString )

Local nOrdem 	:= aReturn[8]
Local cDet		:= ""
Local cAuxDet	:= ""
Local cEstCiv	:= ""
Local cDescCargo:= ""
Local cGrupo	:= ""
Local nLinha	:= 0
Local nBegin	:= 0
Local cAuxCC	:= ""
Local l1Vez		:= .T.
Local cFil		:= ""
Local cDtNasc 	:= Space(10)
Local cDtAdm  	:= Space(10)
Local lImp	  	:= .F.
Local cAcessaSRA:= &("{ || " + ChkRH(FunName(),"SRA","2") + "}")
Local cCargo	:= "" 
Local cFilAnterior := ""
Local cFilFun		:= ""
Local cEmpFun		:= ""

Private cInicio, cFim 
Private aInfo   := {}



dbSelectArea("SRA")
If nOrdem == 1			// Matricula
	dbSetOrder(1)
	wcabec0 := 1 
	wcabec1 := STR0011	//"FILIAL  MATR.  NOME                           DT.NASC.   DT.ADMIS   EST.CIVIL         CARGO                     CENTRO CUSTO"
						// 123456 123456789012345678901234567890 1234567890 1234567890 1-123456789012345 1234-123456789012345678901234567890 123456789-123456789012345 
ElseIf nOrdem == 2		// Nome + Matricula
	dbSetOrder(3)
	wcabec0 := 1	
	wcabec1 := STR0012	//"FILIAL  NOME                            MATR. DT.NASC.   DT.ADMIS   EST.CIVIL         CARGO                     CENTRO CUSTO"
						// 123456789012345678901234567890 123456 1234567890 1234567890 1-123456789012345 1234-123456789012345678901234567890 123456789-123456789012345
ElseIf nOrdem == 3		// Centro Custo + Matricula
	dbSetOrder(2)
	wcabec0 := 1
	wcabec1 := STR0013	//"FILIAL  MATR. NOME                           DT.NASC.   DT.ADMIS   EST.CIVIL         CARGO                               "
						// 123456 123456789012345678901234567890 1234567890 1234567890 1-123456789012345 1234-1234567890123456789001234567890		
ElseIf nOrdem == 4		// Cargo
	dbSetOrder(7)
	wcabec0 := 1
	wcabec1 := STR0014	//"FILIAL  NOME                            MATR. DT.NASC.   DT.ADMIS   EST.CIVIL         CENTRO CUSTO                       "
						// 123456789012345678901234567890 123456 1234567890 1234567890 1-123456789012345 123456789-1234567890123456789012345
EndIf	

cFil := xFilial("SRA", MV_PAR01)  

If nOrdem == 1						
	dbSeek(cFil+MV_PAR03,.T.)
	cInicio	:= "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim	:= MV_PAR02 + MV_PAR04
ElseIf nOrdem == 2
	dbSeek(cFil+MV_PAR05,.T.)
	cInicio	:= "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim	:= MV_PAR02 + MV_PAR06 + MV_PAR04
ElseIf nOrdem == 3
	dbSeek(cFil+MV_PAR07,.T.)
	cInicio	:= "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim	:= MV_PAR02 + MV_PAR08 + MV_PAR04
ElseIf nOrdem == 4	
	dbSeek(cFil,.T.)
	cInicio	:= "SRA->RA_FILIAL"
	cFim	:= MV_PAR02
EndIf	

SetRegua(RecCount())

While !Eof() .And. &cInicio <= cFim

	IncRegua()
	
	If lEnd
		@Prow()+1,0 PSAY cCancel		
		Exit
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas				 |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
       dbSkip()
       Loop
    EndIf
	                  
	cCargo := fGetCargo(SRA->RA_MAT,SRA->RA_FILIAL)
	
	If 	(SRA->RA_NOME 	< MV_PAR05)	.Or. (SRA->RA_NOME 	> MV_PAR06) .Or. ;
		(SRA->RA_MAT 	< MV_PAR03) .Or. (SRA->RA_MAT 	> MV_PAR04)	.Or. ;
		(SRA->RA_CC 	< MV_PAR07)	.Or. (SRA->RA_CC 	> MV_PAR08)	.Or. ; 
		(cCargo 		< MV_PAR09) .Or. (cCargo 		> MV_PAR10)
		dbSkip()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Situacao de Funcionarios							 |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(SRA->RA_SITFOLH $ MV_PAR22)
		dbSkip()
		Loop
	EndIf
    
	// Centro de Custo
	If nOrdem = 3
		cDet := "Centro de Custo: " + SRA->RA_CC + "-" +DescCC(SRA->RA_CC)	//"Centro de Custo: "
		If l1Vez 
			l1Vez := .F.
			IMPR(cDet,"C")
			cAuxCC := SRA->RA_CC
		EndIf
		If cAuxCC # SRA->RA_CC
			cDet:=""
			IMPR(cDet,"P")
			cDet   := "Centro de Custo: " + SRA->RA_CC + "-" + DescCC(SRA->RA_CC)	//"Centro de Custo: "
			cAuxCC := SRA->RA_CC
			IMPR(cDet,"C")
		EndIf
	EndIf
	
	cEstCivil	:= Left(TrmDesc("SX5","33"+SRA->RA_ESTCIVI,"SX5->X5_DESCRI"),15)
	cDescCargo	:= Left(TrmDesc("SQ3",cCargo,"SQ3->Q3_DESCSUM",SRA->RA_FILIAL),20)
	cGrupo		:= SQ3->Q3_GRUPO
	
	If nOrdem # 2
		cDet:= SRA->RA_FILIAL + Space(06) + SRA->RA_MAT + Space(01) + Substr(SRA->RA_NOME,1,30) 
	Else
		cDet:= SRA->RA_FILIAL + Space(06) + Substr(SRA->RA_NOME,1,30) + Space(01)	+ SRA->RA_MAT 
	EndIf
	cDtNasc := 	If(__SetCentury(),Dtoc(SRA->RA_NASC),Dtoc(SRA->RA_NASC)+Space(2))
	cDtAdm 	:= 	If(__SetCentury(),Dtoc(SRA->RA_ADMISSA),Dtoc(SRA->RA_ADMISSA)+Space(2))
	
	cDet+= Space(01) + cDtNasc + Space(01) + cDtAdm + Space(01)
	cDet+= SRA->RA_ESTCIVI + "-" + cEstCivil + Space(01) + cCargo + "-" + cDescCargo
	
	If nOrdem # 3
		cDet+= Space(01)+ AllTrim(SRA->RA_CC) + "-" + AllTrim(Substr(DescCC(SRA->RA_CC),1,19)) 
	EndIf	
	lImp := .T.
	
	IMPR(cDet,"C")
	
	//  Imprime Graduacao S/N
	If MV_PAR11 == 1
		nLinha := Tr020lin("SQ8")
		If Li+nLinha < 53 .And. nLinha < 50
			Tr020Grad(cCargo,cGrupo)
		Else
			IMPR(cDet,"P")
			Tr020Grad(cCargo,cGrupo)
		EndIf		
	EndIf
	
	//  Imprime Historico Carreira S/N       
	If MV_PAR12 == 1
		nLinha := Tr020lin("SQC")		
		If Li+nLinha < 53 .And. nLinha < 50 
			Tr020HC()
		Else
			IMPR(cDet,"P")
			Tr020HC()
		EndIf					
	EndIf
	
	//  Imprime Historico Carreira na Empresa S/N   
	If MV_PAR13 == 1 
		nLinha := Tr020lin("SR7")
		If Li+nLinha < 53 .And. nLinha < 50  
			Tr020HE()
		Else
			IMPR(cDet,"P")
			Tr020HE()
		EndIf		
	EndIf
	
	//  Imprime Cursos S/N                      
	If MV_PAR14	== 1
		nLinha := Tr020lin("RA5")
		If Li+nLinha < 53 .And. nLinha < 50
			//Tr020Cur(cCargo, SRA->RA_CODFUNC, SRA->RA_CC)
		Else
			IMPR(cDet,"P")
			//Tr020Cur(cCargo, SRA->RA_CODFUNC, SRA->RA_CC)
		EndIf		
	EndIf
	
	//  Imprime Cursos ExtraCurriculares  S/N      
	If MV_PAR15 == 1
		nLinha := Tr020lin("SQ9")
		If Li+nLinha < 53 .And. nLinha < 50
			Tr020Extra()
		Else
			IMPR(cDet,"P")
			Tr020Extra()
		EndIf		
	EndIf
	
	// Imprime Solicitacao Cursos S/N        
	If MV_PAR16 == 1
		nLinha := Tr020lin("RA3")
		If Li+nLinha < 53 .And. nLinha < 50
			Tr020Sol()
		Else
			IMPR(cDet,"P")
			Tr020Sol()
		EndIf		
	EndIf

	// Imprime Avaliacoes Cursos S/N        
	If MV_PAR23 == 1
		nLinha := Tr020lin("RAI")
		If Li+nLinha < 53 .And. nLinha < 50
			Tr020Aval()
		Else
			IMPR(cDet,"P")
			Tr020Aval()
		EndIf		
	EndIf
    
	// Imprime Habilidades do Funcionario S/N
	If MV_PAR27 == 1 
		nLinha := Tr020lin("RBI")
		If Li+nLinha < 53 .And. nLinha < 50
			Tr020Habil(SRA->RA_MAT,cCargo,SRA->RA_CC)
		Else
			IMPR(cDet,"P")
			Tr020Habil(SRA->RA_MAT,cCargo,SRA->RA_CC)
		EndIf					
	EndIf
	
	dbSelectArea("SRA") 
	dbSkip()	

	
	// Imprime um funcionario por Folha
	If MV_PAR17 == 1 
		If !Eof() .And. &cInicio <= cFim
			cDet := ""
			IMPR(cDet,"P")
		EndIf
	Else
		cDet := Repl("-",Colunas)
		IMPR(cDet,"C")
	EndIf	
EndDo

If lImp
	Impr("","F")
EndIf	

dbSelectArea("SRA")
Set Filter to 
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ Tr020Grad    ³ Autor ³ Equipe R.H.       ³ Data ³ 08.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Graduacao dos Funcionarios   					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Tr020Grad(cCargo,cGrupo)								      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRMR020  											  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Tr020Grad(cCargo,cGrupo)

Local aSaveArea := GetArea()
Local cDet		 := ""
Local l1Vez 	 := .T.
Local aFator	 := {}
Local nCargos	 := 0
Local nFuncs	 := 0
Local cFuncFator := ""
Local cDescFator := ""
Local nFuncPt	 := 0
Local cFil		 := ""
Local cFil2		 := ""
Local cFil3		 := ""
Local nx		 := 0 
Local cChave	 := ""
Local cDescFat   := ""
Local cDescGra   := ""
Local cFuncDGrau := ""
Local cDscFatAux := ""
Local cDscGraAux := ""
Local cDscFunGra := ""
Local cFator     := ""
Local cGrau      := ""
Local cFunGrau   := ""
Local nLinha     := 0
Local i			 := 0
Local lPriVez    := .T.

cDet := ""
IMPR(cDet,"C")							 

IMPR(__PrtThinLine(),"C")	// Imprime uma linha para separar informacaoes impressas

cDet := Space(05) + "GRADUACAO DO FUNCIONARIO"	//"GRADUACAO DO FUNCIONARIO"
IMPR(cDet,"C")                                                  
							 
IMPR(__PrtThinLine(),"C")

// Carrega os Fatores do Cargo e Funcionario
FMontaFator(,,cCargo,SRA->RA_MAT,cGrupo,,@aFator,SRA->RA_CC)
                                     
dbSelectArea("SQ8")
dbSetOrder(1)
cFil := xFilial("SQ8", SRA->RA_FILIAL)
dbSeek(cFil+SRA->RA_MAT)
While cFil+SRA->RA_MAT == SQ8->Q8_FILIAL+SQ8->Q8_MAT
	
	dbSelectArea("SQ3")
	dbSetOrder(1)
	cFil := xFilial("SQ3", SRA->RA_FILIAL)
	If dbSeek(cFil+cCargo+SRA->RA_CC)
		cChave 	:= cCargo+SQ3->Q3_CC
	Else
		cChave	:= cCargo + Space(TamSX3("RA_CC")[1])
	EndIf
	
	dbSelectArea("SQ4")
	dbSetOrder(2)
	cFil2 := xFilial("SQ4", SRA->RA_FILIAL)
	cChave := cFil2+cChave+SQ8->Q8_FATOR
	If dbSeek(cChave)

		dbSelectArea("SQ8")
		dbSetOrder(1)
  		dbSkip()
		Loop
	EndIf
	
	cFuncFator:= SQ8->Q8_FATOR           
	cDescFator:= FDesc("SQV",SQ8->Q8_FATOR,"SQV->QV_DESCFAT",30)
	
	cFuncGrau := SQ8->Q8_GRAU
	cFuncDGrau:= FDesc("SQV",SQ8->Q8_FATOR+SQ8->Q8_GRAU,"SQV->QV_DESCGRA",30)

	If SQ8->( FieldPos("Q8_PONTOS") ) > 0
		nFuncPt	:= SQ8->Q8_PONTOS
	Else	
	
		dbSelectArea("SQ2")
		dbSetOrder(1) 
		cFil3 := xFilial("SQ2", SRA->RA_FILIAL)	 
		If dbSeek(cFil3+cGrupo+SQ8->Q8_FATOR+SQ8->Q8_GRAU)
			nFuncPt	:= SQ2->Q2_PONTOSI
		EndIF
    EndIf
    
	Aadd(aFator,{ cFuncFator,;	// 1 Fator
				  cDescFator,;	// 2 Descricao do Fator
				  Space(2),;	// 3 Grau do Cargo
				  Space(30),;	// 4 Descricao do Grau do Cargo
				  0,;			// 5 Pontos do Cargo
				  cFuncGrau,;	// 6 Grau do Funcionario
				  cFuncDGrau,;	// 7 Descricao do Grau do Funcionario
  				  0,;	  		// 8 Pontos do Funcionario(Zerado,pois cargo nao exige este fator)
  				  cGrupo}) 		// 9 Grupo
		
	dbSelectArea("SQ8")
	dbSkip()
EndDo

nCargos := 0
nFuncs  := 0

For nx := 1 To Len(aFator)

	// Verifica o Fator de Graduacao De/Ate
	If 	aFator[nx][1] < MV_PAR20 .Or.;
		aFator[nx][1] > MV_PAR21
		Loop
	EndIf	

	// Soma os totais de Pontos dos Cargos e Funcionarios
	nCargos := nCargos + aFator[nx][5]
	nFuncs	:= nFuncs  + aFator[nx][8]		                     

	// Imprime os pontos e somente os totais pontos dos fatores
	If MV_PAR18== 1 .And. MV_PAR19 == 1  
		l1Vez 	:= .F.    		
		Loop
	EndIf	
               
	If 	l1Vez
		l1Vez := .F.    
		// Imprime os pontos dos Fatores   
		If MV_PAR18 == 1    // Sim
			cDet := Space(08) + STR0037	//"FATOR AVALIACAO                   GRADUACAO NECESSARIA               PONTOS           GRADUACAO FUNCIONARIO           PONTOS"
											//"12 123456789012345678901234567890 12 123456789012345678901234567890 9999999           12 123456789012345678901234567 9999999		
		Else
			cDet := Space(08) + STR0018	//"FATOR AVALIACAO                   GRADUACAO NECESSARIA              GRADUACAO FUNCIONARIO            "
		EndIf											
											//"12 123456789012345678901234567890 12 123456789012345678901234567890 12 123456789012345678901234567890		
		IMPR(cDet,"C")
		IMPR(__PrtThinLine(),"C")
	EndIf	

	cDescFat  := TrmDesc("SQ1",cGrupo+aFator[nx][1],"Q1_DESCSUM")
	cDescGra  := TrmDesc("SQ2",cGrupo+aFator[nx][1]+aFator[nx][3],"Q2_DESC")
	cFuncDGrau:= TrmDesc("SQV",aFator[nx][1]+aFator[nx][6],"SQV->QV_DESCGRA")
	cFator    := aFator[nx][1]
	cGrau     := aFator[nx][3]
	cFunGrau  := aFator[nX][6]

    nLinha := Max( MlCount(cDescFat,30) , Max(MlCount(cDescGra,30),MlCount(cFuncDGrau,30)) ) //Verifica a quantidade de linhas para a maior descricao
    lPriVez := .T.

    For i := 1 to nLinha
        
		cDscFatAux := Memoline(cDescFat,30,i,,.T.)
		cDscGraAux := Memoline(cDescGra,30,i,,.T.)
		If MV_PAR18 == 1
			cDscFunGra := Memoline(cFuncDGrau,27,i,,.T.)
			cDscFunGra := If (Empty(cDscFunGra),Space(27),cDscFunGra)			
		Else
			cDscFunGra := Memoline(cFuncDGrau,30,i,,.T.)
			cDscFunGra := If (Empty(cDscFunGra),Space(30),cDscFunGra)
		EndIf
		
		cDscFatAux := If (Empty(cDscFatAux),Space(30),cDscFatAux)
		cDscGraAux := If (Empty(cDscGraAux),Space(30),cDscGraAux)

		// Imprime os pontos dos fatores
		If MV_PAR18 == 1		// Sim
			If lPriVez
				cDet	:= Space(08) + cFator + Space(01) + cDscFatAux + Space(01)
				cDet	+= cGrau + Space(01) + cDscGraAux+ Space(01) 
				cDet    += Transform(aFator[nx][5],"@E 9999.99")+Space(11)
				cDet 	+= cFunGrau + Space(01) + cDscFunGra+Space(01)
				cDet	+= Transform(aFator[nx][8],"@E 9999.99")
				lPriVez := .F.
			Else
				cDet	:= Space(08) + cFator + Space(01) + cDscFatAux + Space(01)
				cDet	+= cGrau + Space(01) + cDscGraAux+ Space(01) 
				cDet    += Space(18)
				cDet 	+= cFunGrau + Space(01) + cDscFunGra+Space(01)
			EndIf
		Else
			cDet	:= Space(08) + cFator + Space(01) + cDscFatAux + Space(01)
			cDet	+= cGrau + Space(01) + cDscGraAux + Space(01)
			cDet 	+= cFunGrau + Space(01) + cDscFunGra
		EndIf
		
		cFator   := Space(2)
		cGrau    := Space(2)
		cFunGrau := Space(2)
	
		IMPR(cDet,"C")
    Next i

	// Imprime Descricao Detalhada do Fator
	If MV_PAR24 == 1    
		Tr020DetFat(aFator[nX])
	EndIf
	    
	// Imprime Observacao de Fatores Funcionario
	If MV_PAR25 == 1    
		Tr020ObsFat(aFator[nX])
	EndIf

Next nx                 

// Imprime os totais dos pontos
If MV_PAR18 # 2 .And. !l1Vez
	// Imprimir por pontos e apenas os totais
	If 	MV_PAR18==1 .And. MV_PAR19 == 1     
		cDet := Space(08) + STR0037	//"FATOR AVALIACAO                   GRADUACAO NECESSARIA               PONTOS           GRADUACAO FUNCIONARIO              PONTOS"
		IMPR(cDet,"C")
	Else
		cDet:=""
		IMPR(cDet,"C")                    			
	EndIf
	cDet:= Space(50)+ STR0038 + Space(15)+ Transform(nCargos,"@E 9999.99")	// "T O T A L :"
	cDet+= Space(16)+ STR0038 + Space(15)+ Transform(nFuncs,"@E 9999.99")	// "T O T A L :"
	IMPR(cDet,"C")	
EndIf	

If l1Vez
	cDet := Space(08) + STR0019	//" *** Nao existe graduacao para este funcionario *** "
	IMPR(cDet,"C")
EndIf

RestArea(aSaveArea)

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ Tr020Curso   ³ Autor ³ Equipe R.H.       ³ Data ³ 08.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os curso do cargo x cursos do funcionario		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Tr020Curso(cCargo, cFuncao, cCC)						      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRMR020  											  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Tr020Cur(cCargo, cFuncao, cCC)

Local aSaveArea 	:= GetArea()
Local aCurCargo		:= {}
Local aCurFun		:= {}
Local nPosAchou		:= 0
Local lNecessario	:= .F.
Local cCurso		:= ""
Local cDescCurso	:= ""
Local cEntid		:= ""
Local cDescEnt		:= ""
Local i  			:= 0
Local cDet			:= ""
Local cDtIni 		:= Space(10) 
Local cDtFin 		:= Space(10) 
Local cDtVal 		:= Space(10) 
Local cFil			:= ""
Local cChave		:= ""
Local cRA5			:= ""
Local cSinon		:= ""
Local cDescSi		:= ""

cDet := ""
IMPR(cDet,"C")							 
IMPR(__PrtThinLine(),"C")

cDet :=  Space(05) + STR0020	//"CURSOS DO FUNCIONARIO"
IMPR(cDet,"C")
IMPR(__PrtThinLine(),"C")                     

// aCurFun : 	1 - Codigo do Curso
//				2 - Necessario para o cargo
// 				3 - Realizado 
//				4 - Entidade
//				5 - Nota
//				6 - %Presenca                                  
//				7 - Data inicial
//				8 - Data final
//			    9 - Duracao
//				10- Unid. duracao
//				11- Validade
//				12- Sinonimo


dbSelectArea("SQ3")
dbSetOrder(1)
cFil := xFilial("SQ3", SRA->RA_FILIAL)
If dbSeek(cFil+cCargo+cCC)
	cChave 	:= cCargo+cCC 
Else
	cChave	:= cCargo+Space(TamSX3("RA_CC")[1])
EndIf

dbSelectArea("RA5")		// Cursos do Cargo
dbSetOrder(2)   
cFil := xFilial("RA5", SRA->RA_FILIAL)
cChave 	:= cFil+cChave
dbSeek(cChave)
cRA5	:= "RA5->RA5_FILIAL+RA5->RA5_CARGO+RA5->RA5_CC"

While !Eof() .And. cChave == &cRA5 
	Aadd(aCurCargo	,{RA5->RA5_CURSO})
	dbSkip()
EndDo

dbSelectArea("RAL")		// Cursos da Funcao
dbSetOrder(1)   
cFil := xFilial("RAL", SRA->RA_FILIAL)
If dbSeek(cFil+cFuncao)
	While !Eof() .And. cFil+cFuncao ==;
							 RAL->RAL_FILIAL+RAL->RAL_FUNCAO 
		If Ascan(aCurCargo,{|x| x[1] == RAL->RAL_CURSO}) == 0
			Aadd(aCurCargo	,{RAL->RAL_CURSO})
		End	
		dbSkip()
	EndDo
EndIf

dbSelectArea("RA4")		// Cursos do Funcionario
dbSetOrder(1) 
cFil := xFilial("RA4", SRA->RA_FILIAL)
//Quando usuario optar Cursos Realizados 'Nao' eh verificado os Cursos do Funcionario
If MV_PAR28 == 2 .Or. MV_PAR28 == 3
	For i:=1 to Len(aCurCargo)
		If MV_PAR28 == 3 .Or. ( MV_PAR28 == 2 .And. !(dbSeek(cFil+SRA->RA_MAT+aCurCargo[i][1])) )
			Aadd(aCurFun,{aCurCargo[i][1],.T.,.F.,Space(04),0,0,Space(10),Space(10),0,Space(1),Space(10),Space(04)})		
		EndIf			
	Next i	
EndIf

If dbSeek(cFil+SRA->RA_MAT)
 		While !Eof() .And. cFil+SRA->RA_MAT ==;
							 RA4->RA4_FILIAL+RA4->RA4_MAT .And. (MV_PAR28 == 1 .Or. MV_PAR28 == 3)

		cDtIni := If(__SetCentury(),Dtoc(RA4->RA4_DATAIN),Dtoc(RA4->RA4_DATAIN)+Space(2))	
		cDtFin := If(__SetCentury(),Dtoc(RA4->RA4_DATAFI),Dtoc(RA4->RA4_DATAFI)+Space(2))	
		cDtVal := If(__SetCentury(),Dtoc(RA4->RA4_VALIDA),Dtoc(RA4->RA4_VALIDA)+Space(2))	
		nPosAchou 	:= 0					 
		nPosAchou 	:= Ascan(aCurFun,{|x| x[1] == RA4->RA4_CURSO})  
		
		If nPosAchou > 0 .And. aCurFun[nPosAchou][3] == .F.
			aCurFun[nPosAchou][2] := .T. 
			aCurFun[nPosAchou][3] := .T.
			aCurFun[nPosAchou][4] := RA4->RA4_ENTIDA
			aCurFun[nPosAchou][5] := RA4->RA4_NOTA
			aCurFun[nPosAchou][6] := RA4->RA4_PRESENC
			aCurFun[nPosAchou][7] := cDtIni
			aCurFun[nPosAchou][8] := cDtFin
			aCurFun[nPosAchou][9] := RA4->RA4_DURACA
			aCurFun[nPosAchou][10]:= RA4->RA4_UNDURA
			aCurFun[nPosAchou][11]:= cDtVal
			aCurFun[nPosAchou][12]:= RA4->RA4_SINONI
		Else 
			Aadd(aCurFun,{RA4->RA4_CURSO, .F., .T., RA4->RA4_ENTIDA, RA4->RA4_NOTA, RA4->RA4_PRESENC,;
						cDtIni, cDtFin, RA4->RA4_DURACA, RA4->RA4_UNDURA, cDtVal, RA4->RA4_SINONI })
		
			nPosAchou 	:= Ascan(aCurCargo,{|x| x[1] == RA4->RA4_CURSO})  
			If nPosAchou > 0						
				aCurFun[Len(aCurFun)][2] := .T. 			
			EndIf
	   	EndIf
		
		dbSkip()						 
	EndDo
EndIf							 

If Len(aCurFun) > 0                        

    // Ordena Cursos por ordem de Data inicial
	Asort(aCurFun,,,{|x,y| Dtos(Ctod(x[7])) < Dtos(Ctod(y[7])) })
	
	cDet := Space(08) + STR0021	//"CURSO                                PERIODO        DURACAO  VALIDADE NECES. ENTIDADE                   NOTA PRESENCA REALIZ"
								// 1234 123456789012345678901234 1234567890 12345678901234567 1234567890 123456 1234567890123456789012345 12345 12345678 123
Else
	cDet := Space(08) + STR0022	//" *** Nao existe Curso para este Funcionario ***"
EndIf	
IMPR(cDet,"C")
IMPR(__PrtThinLine(),"C")

For i :=1 To Len(aCurFun)
	cDescEnt := Left(TrmDesc("RA0",aCurFun[i][4],"RA0->RA0_DESC"),40)
	cDescCur := Left(TrmDesc("RA1",aCurFun[i][1],"RA1->RA1_DESC"),30)
	
	cDet		:= Space(08) + aCurFun[i][1] + "-" + Left(cDescCur,24) + Space(01) 
	cDet		+= aCurFun[i][7] + Space(01) + aCurFun[i][8]+Space(1)
	cDet		+= Transform(aCurFun[i][9],"@E 9999.99")+ aCurFun[i][10] + Space(01)
	cDet		+= aCurFun[i][11] + Space(01)
	cDet		+= IIF(aCurFun[i][2],"Sim","Nao") + Space(03)
	cDet		+= aCurFun[i][4] + "-" + Left(cDescEnt,19) + Space(01)
	cDet		+= Transform(aCurFun[i][5],"@E 999.99") + Space(02)
	cDet		+= Transform(aCurFun[i][6],"@E 999.99%") + Space(02)		
	cDet		+= IIF(aCurFun[i][3],"Sim","Nao")
	IMPR(cDet,"C")	
	
	If MV_PAR26 == 1 // Imprimir Sinonimo de Curso
                            
		cSinon	:= aCurFun[i][12]
		cDescSi	:= Fdesc("RA9", cSinon, "RA9_DESCR")
		
	    cDet := Space(13) + STR0047 + cSinon + " - " +cDescSi //"SINONIMO: "
		IMPR(cDet,"C")
	EndIf
	
Next i

RestArea(aSaveArea)

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ Tr020HC      ³ Autor ³ Equipe R.H.       ³ Data ³ 08.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o historico de carreira                   		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Tr020HC()                    						      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRMR020  											  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Tr020HC()

Local aSaveArea := GetArea()
Local l1Vez		:= .T.
Local cDet		:= ""
Local cDtAdm 	:= Space(10)
Local cDtDem 	:= Space(10) 
Local cFil		:= ""

cDet := ""
IMPR(cDet,"C")							 
IMPR(__PrtThinLine(),"C")

cDet :=  Space(05) + STR0023	//"HISTORICO DE CARREIRA"
IMPR(cDet,"C")       							 
IMPR(__PrtThinLine(),"C")

dbSelectArea("SQC")
dbSetOrder(1)
cFil := xFilial("SQC", SRA->RA_FILIAL)
If dbSeek(cFil+SRA->RA_MAT)
	While !Eof() .And. cFil+SRA->RA_MAT ==;
							 SQC->QC_FILIAL+SQC->QC_MAT

		If l1Vez						 
			l1Vez	:= .F.
			cDet 	:= Space(08) + STR0024	//"ADMISSAO   DEMISSAO   EMPRESA                        CARGO                         "    
											// 1234567890 1234567890 123456789012345678901234567890 123456789012345678901234567890"
			IMPR(cDet,"C")
			IMPR(__PrtThinLine(),"C")
										 
		EndIf											 
	
		cDtAdm 	:= 	If(__SetCentury(),Dtoc(SQC->QC_ADMISSA),Dtoc(SQC->QC_ADMISSA)+Space(2))	
		cDtDem	:= 	If(__SetCentury(),Dtoc(SQC->QC_DEMISSA),Dtoc(SQC->QC_DEMISSA)+Space(2))
			
		cDet := Space(08) + cDtAdm + Space(01) + cDtDem
		cDet += Space(01) + SQC->QC_EMPRESA + Space(01) + SQC->QC_CARGO 
		IMPR(cDet,"C")
		
		dbSkip()					 
	EndDo						 
EndIf

If l1Vez
	cDet := Space(08) + STR0025	//" *** Nao existe Historico de Carreira para este Funcionario *** "
	IMPR(cDet,"C")
EndIf

RestArea(aSaveArea)

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ Tr020HE      ³ Autor ³ Equipe R.H.       ³ Data ³ 08.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o historico de carreira na empresa          		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Tr020HE()                    						      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRMR020  											  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Tr020HE()

Local aSaveArea := GetArea()
Local l1Vez		:= .T.
Local cDet		:= ""
Local cDescTp	:= ""
Local cDtR7 	:= Space(10) 
Local cFil		:= ""

cDet := ""
IMPR(cDet,"C")							 
IMPR(__PrtThinLine(),"C")

cDet :=  Space(05) + STR0026	//"HISTORICO DE CARREIRA NA EMPRESA"
IMPR(cDet,"C")                                                  							 
IMPR(__PrtThinLine(),"C")

dbSelectArea("SR7")
dbSetOrder(1)  
cFil := xFilial("SR7", SRA->RA_FILIAL)
If dbSeek(cFil+SRA->RA_MAT)
	While !Eof() .And. cFil+SRA->RA_MAT ==;
							 SR7->R7_FILIAL+SR7->R7_MAT
							 
		If l1Vez						 
			l1Vez 	:= .F.
			cDet 	:= Space(08) + STR0027	//"DT AUMENTO  TP AUMENTO               FUNCAO                   " 
											// 1234567890  123-12345678901234567890 1234-12345678901234567890"
			IMPR(cDet,"C")							 
			IMPR(__PrtThinLine(),"C")
			
		EndIf	
		
		cDescTp := Left(TrmDesc("SX5","41"+SR7->R7_TIPO,"SX5->X5_DESCRI"),20)
		cDtR7 	:= 	If(__SetCentury(),Dtoc(SR7->R7_DATA),Dtoc(SR7->R7_DATA)+Space(2))	
		
		cDet := Space(08) + cDtR7 + Space(02) 
		cDet += SR7->R7_TIPO + "-" + cDescTp + Space(01) 
		cDet += SR7->R7_FUNCAO + "-" + SR7->R7_DESCFUN
		IMPR(cDet,"C")
		
		dbSkip()					 
	EndDo						 
EndIf

If l1Vez
	cDet := Space(08) + STR0028	//" *** Nao existe Historico de Carreira na Empresa para este Funcionario *** "
	IMPR(cDet,"C")
EndIf

RestArea(aSaveArea)

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ Tr020Extra   ³ Autor ³ Equipe R.H.       ³ Data ³ 08.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os cursos Extra curriculares             		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Tr020Extra()                    						      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRMR020  											  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Tr020Extra()

Local aSaveArea := GetArea()
Local l1Vez		:= .T.
Local cDet		:= ""
Local nExtra	:= 0                  
Local cDtQ9		:= Space(10)
Local cFil		:= ""

cDet := ""
IMPR(cDet,"C")						
IMPR(__PrtThinLine(),"C")

cDet :=  Space(05) + STR0030	//"CURSOS EXTRACURRICULARES"
IMPR(cDet,"C")                   
IMPR(__PrtThinLine(),"C")

nExtra :=0
dbSelectArea("SQ9")                      
dbSetOrder(1)    
cFil := xFilial("SQ9", SRA->RA_FILIAL)
If dbSeek(cFil+SRA->RA_MAT)
	While !Eof() .And. cFil+SRA->RA_MAT ==;
							 SQ9->Q9_FILIAL+SQ9->Q9_MAT
		
		// Totalizar os pontos dos cursos extracurriculares
		nExtra := nExtra + SQ9->Q9_PONTOS                                                 

		// Imprimir por pontos e apenas os totais
		If MV_PAR18==1 .And. MV_PAR19==1						
			l1Vez := .F.
			dbSkip()
			Loop
		EndIf	
										 
		If l1Vez						 
			l1Vez 	:= .F.   
			cDet 	:= Space(08) + STR0031		//"DATA       DESCRICAO                                ENTIDADE                       ESCOLARIDADE " 													
												// 1234567890 1234567890123456789012345678901234567890 123456789012345678901234567890     123          9999999"
			// Imprime pontos 
			If MV_PAR18 == 1 	// Sim
				cDet += Space(08) + STR0039	//"PONTOS" 
			EndIf

			IMPR(cDet,"C")							 
			IMPR(__PrtThinLine(),"C")
			
		EndIf	
                            
		cDtQ9 	:= 	If(__SetCentury(),Dtoc(SQ9->Q9_DATA),Dtoc(SQ9->Q9_DATA)+Space(2))	

		cDet := Space(08) + cDtQ9+ Space(01) 
		cDet += SQ9->Q9_DESCRIC + Space(01) + SQ9->Q9_ENTIDAD 
		cDet += Space(01) + IIF(SQ9->Q9_ESCOLAR=="S","Sim","Nao")

		// Imprime pontos 
		If MV_PAR18 == 1 	// Sim
			cDet += Space(16) + Transform(SQ9->Q9_PONTOS,"@E 9999.99")
		EndIf	
		
		IMPR(cDet,"C")
		
		dbSkip()					 
	EndDo						 
EndIf

If l1Vez
	cDet := Space(08) + STR0032	//	" *** Nao existe Curso ExtraCurricular para este Funcionario *** "
	IMPR(cDet,"C")
EndIf

If 	MV_PAR18#2 .And. !l1Vez
	cDet:=""
	IMPR(cDet,"C")                  
	// Imprimir por pontos apenas os totais
	If MV_PAR18==1 .And. MV_PAR19==1
		cDet := Space(08) + STR0031	//"DATA     DESCRICAO                                ENTIDADE                       ESCOLARIDADE "
		cDet += Space(08) + STR0039	//"PONTOS" 
		IMPR(cDet,"C")
	EndIf
	cDet:= Space(87)+ STR0038 + Space(12)+ Transform(nExtra,"@E 9999.99")	// "T O T A L :"
	IMPR(cDet,"C")	
EndIf

RestArea(aSaveArea)

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ Tr020Sol     ³ Autor ³ Equipe R.H.       ³ Data ³ 08.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime as solicitacoes dos cursos                		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Tr020Sol()                    						      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRMR020  											  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Tr020Sol()

Local aSaveArea := GetArea()
Local l1Vez		:= .T.
Local cDet		:= ""
Local cDtSolic 	:= ""
Local cFil		:= ""

cDet := ""
IMPR(cDet,"C")							 
IMPR(__PrtThinLine(),"C")

cDet :=  Space(05) + STR0033	//"SOLICITACAO DE CURSOS"
IMPR(cDet,"C")                    
IMPR(__PrtThinLine(),"C")	 

dbSelectArea("RA3")
dbSetOrder(1) 
cFil := xFilial("RA3", SRA->RA_FILIAL)
If dbSeek(cFil+SRA->RA_MAT)
  		While !Eof() .And. cFil+SRA->RA_MAT ==;
							 RA3->RA3_FILIAL+RA3->RA3_MAT
							 
		If l1Vez						 
			l1Vez 	:= .F.
			cDet 	:= Space(08) + STR0034	//"CURSO                               TURMA CALENDARIO                TP RESERVA    VZ ADIADO DT.SOLIC.         PERIODO       "
											// 1234-123456789012345678901234567890   123 1234-12345678901234567890 1-12345678901 1234      99/99/9999 99/99/9999 99/99/9999"  
			IMPR(cDet,"C")								 							 
			IMPR(__PrtThinLine(),"C")
		EndIf	
		
		cDescCurso	:= Left(TrmDesc("RA1",RA3->RA3_CURSO,"RA1->RA1_DESC"),30)
		cDescCalend	:= Left(TrmDesc("RA2",RA3->RA3_CALEND,"RA2->RA2_DESC"),20)
		cDescTp		:= Left(TrmDesc("SX5","R7"+RA3->RA3_RESERV,"SX5->X5_DESCRI"),19)
		cDtSolic	:= If(__SetCentury(),Dtoc(RA3->RA3_DATA)		,Dtoc(RA3->RA3_DATA)	+Space(2))	
		cDtIni 		:= If(__SetCentury(),Dtoc(RA2->RA2_DATAIN)	,Dtoc(RA2->RA2_DATAIN)	+Space(2))	
		cDtFin 		:= If(__SetCentury(),Dtoc(RA2->RA2_DATAFI)	,Dtoc(RA2->RA2_DATAFI)	+Space(2))	
		
		cDet := Space(08) + RA3->RA3_CURSO + "-" + cDescCurso + Space(03)
		cDet += RA3->RA3_TURMA + Space(01) + RA3->RA3_CALEND + "-" 
		cDet += cDescCalend + Space(01) + cDescTp + Space(01)
		cDet += Transform(RA3->RA3_NVEZAD,"999") 
		cDet += Space(01) + cDtSolic + Space(01)
		cDet += cDtIni + " " + cDtFin
		IMPR(cDet,"C")
		
		dbSkip()					 
	EndDo						 
EndIf

If l1Vez
	cDet := Space(08) + STR0035	//"*** Nao existe Solicitacao de Curso feita por este Funcionario ***"
	IMPR(cDet,"C")
EndIf

RestArea(aSaveArea)

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ Tr020Aval    ³ Autor ³ Equipe R.H.       ³ Data ³ 08.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime as Avaliacoes dos cursos                  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Tr020Aval()                    						      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRMR020  											  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Tr020Aval()

Local aSaveArea := GetArea()
Local l1Vez		:= .T.
Local cDet		:= ""
Local cFil		:= ""
Local cFil2		:= ""
Local nResult	:= 0
Local cDescCal	:= ""
Local cDescCur	:= ""   
Local cDescTes	:= ""
Local aTeste	:= {}
Local nX		:= 0
Local cCalend	:= ""
Local cCurso	:= ""
Local cTurma	:= ""
Local cTeste	:= ""
Local cQuest	:= ""
Local nPontos	:= 0 
Local cTipo		:= ""
Local cDTipo	:= ""
Local cData 	:= ""

cDet := ""
IMPR(cDet,"C")							 
IMPR(__PrtThinLine(),"C")

cDet :=  Space(05) + STR0040	//"AVALIACOES DE TREINAMENTO"
IMPR(cDet,"C")       							 
IMPR(__PrtThinLine(),"C")

dbSelectArea("RAI")
dbSetOrder(2) 
cFil := xFilial("RAI", SRA->RA_FILIAL)
If dbSeek(cFil+SRA->RA_MAT)
	
	While !Eof() .And. cFil+SRA->RA_MAT ==;
		RAI->RAI_FILIAL+RAI->RAI_MAT
		
		DbSelectarea("RAJ")
		RAJ->(dbSetOrder(1))
		RAJ->(dbSeek(xFilial("RAJ")+RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA+RAI->RAI_MAT))
		While !Eof() .And. ((RAI->RAI_FILIAL+RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA+RAI->RAI_MAT) ==;
							(RAJ->RAJ_FILIAL+RAJ->RAJ_CALEND+RAJ->RAJ_CURSO+RAJ->RAJ_TURMA+RAJ->RAJ_MAT))

			If AllTrim(RAI->RAI_TESTE) == AllTrim(RAJ->RAJ_TESTE)
				Aadd(aTeste,{RAI->RAI_CALEND,RAI->RAI_CURSO,RAI->RAI_TURMA,RAI->RAI_TESTE,RAI->RAI_QUESTA,RAI->RAI_RESULT,RAI->RAI_TIPO,RAJ->RAJ_DATA})
				Exit
	        EndIf

	        dbSkip()
	   	EndDo
				
		dbSelectArea("RAI")
		dbSkip()
	EndDo 
	Asort(aTeste,,,{|x,y| x[1]+x[2]+x[3]+x[4] < y[1]+y[2]+y[3]+y[4]})
	
	cDet 	:= Space(08) + STR0041	//"CALENDARIO                CURSO                     TURMA TIPO AVALIACAO           AVALIACAO                 RESULT."
									// 1234-12345678901234567890 1234-12345678901234567890  123  123-12345678901234567890 1234-12345678901234567890 123456 "
	IMPR(cDet,"C")							 
	IMPR(__PrtThinLine(),"C")
	
	For nX := 1 to Len(aTeste)
		
		cCalend	:= aTeste[nx][1]		
		cCurso	:= aTeste[nx][2]		
		cTurma	:= aTeste[nx][3]		
		cTeste	:= Alltrim(aTeste[nx][4])
		cTipo	:= aTeste[nx][7]
		cDTipo	:= Left(TrmDesc("SX5","RJ"+cTipo,"X5_DESCRI"),16)
		cData	:= If(__SetCentury(),Dtoc(aTeste[nx][8])	,Dtoc(aTeste[nx][8])	+Space(2))
				
		cAux 	:= aTeste[nx][1]+aTeste[nx][2]+aTeste[nx][3]+aTeste[nx][4]
		nPontos := 0
		
		While cAux == aTeste[nx][1]+aTeste[nx][2]+aTeste[nx][3]+aTeste[nx][4]
			
			cDescCal	:= Left(TrmDesc("RA2",aTeste[nx][1],"RA2->RA2_DESC"),20)
			cDescCur	:= Left(TrmDesc("RA1",aTeste[nx][2],"RA1->RA1_DESC"),20)
			If Len(cTeste) == 3
				cDescTes	:= Left(TrmDesc("SQQ",cTeste,"SQQ->QQ_DESCRIC"),20)
			Else
				cDescTes	:= Left(TrmDesc("SQW",cTeste,"SQW->QW_DESCRIC"),20)
			EndIf
			
			cQuest		:= aTeste[nx][5]
			nResult		:= aTeste[nx][6]
			If nResult > 0
				dbSelectArea("SQO")
				dbSetOrder(1)
				cFil2 := xFilial("SQO", SRA->RA_FILIAL) 
				If dbSeek(cFil2+cQuest)
					nPontos += ((SQO->QO_PONTOS * nResult) / 100)
				EndIf
			EndIf
            nx ++
            If nx > Len(aTeste)
            	Exit
            EndIf
		EndDo
        nx--

		cDet := Space(08) + cCalend + "-" + cDescCal + Space(01)
		cDet += cCurso + "-" + cDescCur + Space(02)
		cDet += cTurma	+ Space(02)
		cDet += cTipo +"-"+ cDTipo +Space(01)
		cDet += cTeste + Iif(Len(cTeste) == 3," -","-") + cDescTes + Space(01)
		cDet += cData + Space(01)
		cDet += Transform(nPontos,"@E 999.99")
	
	
		IMPR(cDet,"C")		
	Next nX
	
Else
	cDet := Space(08) + STR0042	//"*** Nao existe Avaliacao deste Funcionario ***"
	IMPR(cDet,"C")
EndIf

RestArea(aSaveArea)

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ Tr020DetFat  ³ Autor ³ Equipe R.H.       ³ Data ³ 08.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Descricao Detalhada do Fator               		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Tr020DetFat(aFator)             						      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRMR020  											  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function  Tr020DetFat(aFator)

Local cDet		:= ""
Local cFil		:= ""
Local cDescDet	:= ""
Local nLinha	:= 0
Local nBegin	:= 0

dbSelectArea("SQ1")
dbSetOrder(1)
cFil := xFilial("SQ1", SRA->RA_FILIAL)
dbSeek(cFil + aFator[9] + aFator[1])

cDet	:= Space(18) + UPPER(STR0043)	//"DESCRICAO DETALHADA DO FATOR"
IMPR(cDet,"C")

cDescDet := MSMM(SQ1->Q1_DESCDET,,,,3)

nLinha	:= MLCount(cDescDet,112)
If nLinha > 0
	For nBegin := 1 To nLinha
		cDet := Space(20)+ Memoline(cDescDet,112,nBegin,,.T.)
		IMPR(cDet,"C")
	Next nBegin
Else
	cDet := Space(17)+ STR0044	//" *** Nao existe Descricao detalhada do Fator *** "
	IMPR(cDet,"C")
EndIf
cDet := ""
IMPR(cDet,"C")

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ Tr020ObsFat  ³ Autor ³ Equipe R.H.       ³ Data ³ 08.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime as Observacoes de Fatores Funcionario       		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Tr020DetFat(aFator)             						      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRMR020  											  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Tr020ObsFat(aFator)

Local cFil		:= ""
Local cDet		:= ""
Local cDescDet	:= ""
Local nLinha	:= ""
Local nBegin	:= 0

dbSelectArea("SQ8")
dbSetOrder(1)
cFil := xFilial("SQ8", SRA->RA_FILIAL)
dbSeek(cFil + SRA->RA_MAT + aFator[1])

cDet	:= Space(18) + UPPER(STR0045)	//"OBSERVACAO FATOR DO FUNCIONARIO"
IMPR(cDet,"C")

cDescDet := MSMM(SQ8->Q8_OBS,,,,3)

nLinha	:= MLCount(cDescDet,112)
If nLinha > 0
	For nBegin := 1 To nLinha
		cDet := Space(20)+ Memoline(cDescDet,112,nBegin,,.T.)
		IMPR(cDet,"C")
	Next nBegin
Else
	cDet := Space(17)+ STR0046	//" *** Nao tem nenhuma Observacao para este Fator *** "
	IMPR(cDet,"C")
EndIf
cDet := ""
IMPR(cDet,"C")

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ Tr020Habil   ³ Autor ³ Eduardo Ju        ³ Data ³ 18.02.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime as Competencias/Habilidades do Cargo               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Tr020Habil(cMat,cCargo,cCC)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRMR020  											  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Tr020Habil(cMat,cCargo,cCC)

Local aSaveArea	:= GetArea()
Local cDet		:= ""
Local cDescHabil:= ""
Local cDescEscal:= ""
Local cDescItEsc:= ""
Local cDItEscCar:= ""
Local l1Vez 	:= .T. 
                  
IMPR(__PrtThinLine(),"C")   // Imprime uma linha para separar informacaoes impressas
cDet :=  Space(05) + OemToAnsi(STR0048)	//"HABILIDADES"
IMPR(cDet,"C")                     
IMPR(__PrtThinLine(),"C")

dbSelectArea("RBI")
dbSetOrder(1)
cFil := xFilial("RBI", SRA->RA_FILIAL)
If dbSeek(cFil+cMat)   
	While RBI->(!Eof()) .And. cFil+cMat == RBI->RBI_FILIAL+RBI->RBI_MAT
		If l1Vez							 
			l1Vez	:= .F.
			cDet	:= Space(08) + OemToAnsi(STR0049)	//Space(08) +"HABIL. DESC.HABILIDADE                  ESC. DESC.ESCALA            ITEM DESC.ITEM ESCALA FUNC  ITEM DESC.ITEM ESCALA CARGO"
			IMPR(cDet,"C")							 
		EndIf	
	    
		cDescHabil := FDesc("RBG",RBI->RBI_HABIL,"RBG_DESC",32)
		cDescEscal := FDesc("RBK",RBI->RBI_ESCALA,"RBK_DESCRI",22) 
		cDescItEsc := FDesc("RBL",RBI->RBI_ESCALA + RBI->RBI_ITESCA,"RBL_DESCRI",22)
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Codigo e Descrição do Item de Escala do 'Cargo'  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
		dbSelectArea("SQ3")
		dbSetOrder(1)
		
		If dbSeek(xFilial("SQ3")+cCargo+cCC) .Or. dbSeek(xFilial("SQ3")+cCargo) 
	    	
	    	dbSelectArea("RBH")
	   		dbSetOrder(2)
			
			If dbSeek(xFilial("RBH")+SQ3->Q3_GRUPO+cCargo+cCC) .Or. dbSeek(xFilial("RBH")+SQ3->Q3_GRUPO+cCargo)
							
				While RBH->(!Eof()) 
									            
					If RBH->RBH_HABIL+RBH->RBH_ESCALA == RBI->RBI_HABIL+RBI->RBI_ESCALA  					
						cItEscCar := RBH->RBH_ITESCA
						cDItEscCar:= FDesc("RBL",RBH->RBH_ESCALA+RBH->RBH_ITESCA,"RBL_DESCRI",22)  
						Exit
					EndIf 
					
		        	RBH->(dbSkip())
		        	
	    		EndDo
				
		    EndIf
	    EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao das linhas de Detalhes da Secao 'Habilidades' ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		 
		cDet := Space(08) + Alltrim(RBI->RBI_HABIL) + Space(01)
		cDet += cDescHabil + Space(03)
		cDet += Alltrim(RBI->RBI_ESCALA) + Space(01)
		cDet += cDescEscal + Space(03) 
		cDet += Alltrim(RBI->RBI_ITESCA) + Space(01)
		cDet += cDescItEsc + Space(03)		
		cDet += Alltrim(cItEscCar) + Space(01)
		cDet += cDItEscCar
		
		IMPR(cDet,"C")
					
		RBI->(dbSkip())
	EndDo    				 	
EndIf

If l1Vez
	cDet := Space(08) + OemToAnsi(STR0050)	//"*** Nao existe Habilidade para este Funcionario ***"
	IMPR(cDet,"C")
EndIf

cDet:=""
IMPR(cDet,"C")

RestArea(aSaveArea)

Return Nil               

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ Tr020lin     ³ Autor ³ Eduardo Ju        ³ Data ³ 25.02.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Checagem de numeros de linhas para impressao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Tr020lin                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRMR020  											  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Tr020lin(cAlias)

Local aSaveArea := GetArea()
Local cFil		:= ""
Local nLinhas	:= 0

Do Case 
	Case cAlias  == "SQ8"	//Graduacao Fatores Funcionarios
		dbSelectArea("SQ8")
		dbSetOrder(1) 
		cFil := xFilial("SQ8", SRA->RA_FILIAL)
		If dbSeek(cFil+SRA->RA_MAT)
			While !Eof() .And. cFil+SRA->RA_MAT == SQ8->Q8_FILIAL+SQ8->Q8_MAT
				nLinhas ++
				DbSkip()
			EndDo
		EndIf	 

	Case cAlias  == "SQC"	//Historico de Carreira	
		dbSelectArea("SQC")
		dbSetOrder(1)
		cFil := xFilial("SQC", SRA->RA_FILIAL)
		If dbSeek(cFil+SRA->RA_MAT)
			While !Eof() .And. cFil+SRA->RA_MAT == SQC->QC_FILIAL+SQC->QC_MAT
		    	nLinhas ++
		    	DbSkip()
			EndDo
		EndIf

	Case cAlias == "SR7"	//Historico Alteracoes Salariais
		dbSelectArea("SR7")
		dbSetOrder(1)  
		cFil := xFilial("SR7", SRA->RA_FILIAL)
		If dbSeek(cFil+SRA->RA_MAT)
			While !Eof() .And. cFil+SRA->RA_MAT == SR7->R7_FILIAL+SR7->R7_MAT
				nLinhas ++ 
				DbSkip()
			EndDo
		EndIf	

	Case cAlias == "RA4"	//Cursos do Funcionario	
		dbSelectArea("RA4")		
		dbSetOrder(1) 
		cFil := xFilial("RA4", SRA->RA_FILIAL)
		If dbSeek(cFil+SRA->RA_MAT)
 			While !Eof() .And. cFil+SRA->RA_MAT == RA4->RA4_FILIAL+RA4->RA4_MAT			
				nLinhas ++
				DbSkip()
			EndDo
		EndIf

	Case cAlias == "SQ9"	//Extra Curriculares 
		dbSelectArea("SQ9")                      
		dbSetOrder(1)    
		cFil := xFilial("SQ9", SRA->RA_FILIAL)
		If dbSeek(cFil+SRA->RA_MAT)
			While !Eof() .And. cFil+SRA->RA_MAT == SQ9->Q9_FILIAL+SQ9->Q9_MAT
				nLinhas ++
				DbSkip()
			EndDo
		EndIf

	Case cAlias == "RA3"
		dbSelectArea("RA3")
		dbSetOrder(1) 
		cFil := xFilial("RA3", SRA->RA_FILIAL)
		If dbSeek(cFil+SRA->RA_MAT)
  			While !Eof() .And. cFil+SRA->RA_MAT == RA3->RA3_FILIAL+RA3->RA3_MAT
  				nLinhas ++
  				DbSkip()
			EndDo
		EndIf

	Case cAlias == ("RAI")
		dbSelectArea("RAI")
		dbSetOrder(2) 
		cFil := xFilial("RAI", SRA->RA_FILIAL)
		If dbSeek(cFil+SRA->RA_MAT)
			While !Eof() .And. cFil+SRA->RA_MAT == RAI->RAI_FILIAL+RAI->RAI_MAT
				nLinhas ++
				DbSkip()
			EndDo
		EndIf

	Case cAlias == ("RBI")
		dbSelectArea("RBI")
		dbSetOrder(1)
		cFil := xFilial("RBI", SRA->RA_FILIAL)
		If dbSeek(cFil+SRA->RA_MAT)   
			While !Eof() .And. cFil+SRA->RA_MAT == RBI->RBI_FILIAL+RBI->RBI_MAT		
				nLinhas ++
				DbSkip()
			EndDo
		EndIf
EndCase

RestArea(aSaveArea)	
Return(nLinhas) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AcertSX1  ³ Autor ³Eduardo Ju             ³ Data ³ 30.01.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Atualizacao do Pergunte TRR20R - 08 no Dicionario SX1.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³TRMR020                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
Static Function AcertSX1()             

Local aRegs		:= {}
Local cPerg		:=  "TRR20R"
       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³           Grupo  	 Ordem 	 Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	 Tipo  	 Tamanho  Decimal  Presel    GSC   	Valid        Var01       Def01               DefSPA1        	DefEng1      	     Cnt01               Var02   Def02    		     DefSpa2             DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	 XF3   GrgSxg  cPyme aHelpPor	aHelpEng	aHelpSpa    cHelp  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aRegs,{cPerg	,"08"	,"Fator  de Graduação ?"	   		,"¿Factor graduacion ?"  	,"Graduation factor ?","MV_CH8"  	,"C"	,99			,0		,0		,"R",""	,"MV_PAR08"	,""					,""					,""					,"Q8_FATOR"		,""	,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"SQ102",""    ,"S"	,{}			,{}			,{}			,".TRR20R08."})

ValidPerg(aRegs,cPerg)

dbSelectArea("SX1")
dbSetOrder(01)

IF dbSeek( "TRR20R    03", .F. ) 
	IF !Empty( SX1->X1_F3 )
		RecLock("SX1",.F.)
		SX1->X1_F3 :=  " " 
		SX1->( MsUnlock() )
	EndIf	
EndIf

Return Nil  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AcertSXB	 ³ Autor ³ Eduardo Ju           ³ Data ³ 30.01.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Inclusao de Consultas Padrao                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³RSP*TRM                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AcertSXB()

Local aSaveArea 	:= GetArea()
Local aSxb			:= {}
Local nx			:= 0

dbSelectArea("SXB")
dbSetOrder(1)    

//Criacao de nova consulta
If !( SXB->(dbSeek(	"SQ102 ")) )
  
	Aadd(aSxb, {"SQ102 ","1","01","DB","Fatores Avaliacao","Factores Evaluacion","Evaluation Factors","SQ1",""})
	Aadd(aSxb, {"SQ102 ","2","01","03","Codigo","Codigo","Code","",""})
	Aadd(aSxb, {"SQ102 ","4","01","01","Fator","Factor","Factor","SQ1->Q1_FATOR",""})
	Aadd(aSxb, {"SQ102 ","4","01","02","Descricao","Descripcion","Description","SQ1->Q1_DESCSUM",""})
	Aadd(aSxb, {"SQ102 ","5","01","","","","","SQ1->Q1_FATOR",""})    
	Aadd(aSxb, {"SQ102 ","6","01","","","","","SQ1->Q1_GRUPO = SQ3->Q3_GRUPO",""})
	
	For nx := 1 To Len(aSXB)
		RecLock("SXB",.T.)
			SXB->XB_ALIAS 	:= aSxb[nx][1]
			SXB->XB_TIPO	:= aSxb[nx][2]
			SXB->XB_SEQ		:= aSxb[nx][3]
			SXB->XB_COLUNA	:= aSxb[nx][4]
			SXB->XB_DESCRI	:= aSxb[nx][5]
			SXB->XB_DESCSPA	:= aSxb[nx][6]
			SXB->XB_DESCENG := aSxb[nx][7]
			SXB->XB_CONTEM	:= aSxb[nx][8]
		MsUnlock()        
	Next nx
EndIf    

dbSelectArea("SXB")
dbSetOrder(1)

RestArea(aSaveArea)

Return Nil    