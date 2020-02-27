#include 'protheus.ch'
#include 'rwmake.ch'

user function M410PVNF()
	if date() <> ddatabase
		Alert("A Data Base "+dtoc(ddatabase)+" é inválida para Geração de Nota Fiscal."+chr(13)+chr(10)+;
		'A data correta deve ser '+dtoc(date())+"."+chr(13)+chr(13)+;
		'Se voce continuar poderá ter problema com a transmissão da NFE')
	endif

return .t.