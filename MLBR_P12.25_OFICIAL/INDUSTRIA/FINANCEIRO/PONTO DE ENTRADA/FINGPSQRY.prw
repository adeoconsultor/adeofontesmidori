#Include "Protheus.ch"
/*--------------------------------------------------------- 
Funcao: FINGPQRY       |Autor: AOliveira  |Data: 11-10-2011
-----------------------------------------------------------
Desc.:  PE utilizado p/ inclusão de filtrar por 
        filial de origem, na emissao de GPS.
---------------------------------------------------------*/
User Function FINGPSQRY()
Local cRetQry := ""
cRetQry := " E2_FILORIG BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "

Return(cRetQry)