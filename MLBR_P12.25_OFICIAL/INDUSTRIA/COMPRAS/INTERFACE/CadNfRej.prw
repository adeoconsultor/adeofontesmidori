#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CadNFRej     � Autor � Humberto Garcia � Data �  22/04/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Gerar a tela para cadastramento de notas fiscais que foram ���
���          � rejeitadas pela empresa, mas devem ser registradas para    ���
���          �  controle interno, sem gerar continuidade de processos     ���
�������������������������������������������������������������������������͹��
���Uso       � Recebimento e Dep. Fiscal - Midori Atlantica               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CadNfRej


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZ8"

dbSelectArea("SZ8")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Notas Fiscais Rejeitadas",cVldExc,cVldAlt)

Return
