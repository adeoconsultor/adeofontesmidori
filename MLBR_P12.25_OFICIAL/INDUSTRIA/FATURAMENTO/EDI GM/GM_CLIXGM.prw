#INCLUDE "rwmake.ch"

/* TAGGs - CONSULTORIA    
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Cliente      � MIDORI ATLANTICA                                        ���
�������������������������������������������������������������������������Ĵ��
���Programa     � GM_CLIXGM        � Responsavel � REGINALDO NASCIMENTO   ���
�������������������������������������������������������������������������Ĵ��
���Descri��o    � AMARRACAO CODIGO CLIENTE INT.MODIRO x CODIGO GM         ���
�������������������������������������������������������������������������Ĵ��
��� Data        � 12/08/11         � Implantacao �                        ���
�������������������������������������������������������������������������Ĵ��
��� Programador � ANESIO G.FARIA                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GM_CLIXGM


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZK"

dbSelectArea("SZK")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Amarra��o CODIGO CLIENTE INT.MIDORI x CODIGO GM. . .",cVldExc,cVldAlt)

Return
