/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北赏屯屯屯屯屯屯脱屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯突北
北�              � Funcao para preencher o campo CT5_ORIGEM conforme     罕�
北� MACT5ORI.PRW � regra abaixo.    									 罕�
北�              � 				     			   			    		 罕�
北韧屯屯屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯图北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
/*/
User Function MACT5ORI()

Local _cRet := '"' + M->CT5_LANPAD + '-' + M->CT5_SEQUEN+'/' + substr(ALLTRIM(M->CT5_DESC),1,58)+' / "' + '+Upper(SubSTR(cUsuario,7,15))'

Return(_cRet)