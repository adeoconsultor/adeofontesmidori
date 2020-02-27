User Function CM010TOK()

Local lRet := ParamIxb[1] 
Local x 
 
For x:=1 To Len(aCols)
	aCols[x][6] := IIf(ValType(aCols[x][6])== 'C',Val(aCols[x][6]),aCols[x][6])
Next   


Return (lRet)