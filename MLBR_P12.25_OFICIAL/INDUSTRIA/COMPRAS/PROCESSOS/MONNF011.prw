#INCLUDE "PROTHEUS.CH"

/*
* Funcao			: MONNF011 
* Autor				: DANIEL TORNISIELO
* Data				: 14/08/2015
* Descrição			: Array para execução de JOB por Empresa/Filial
* Observacoes		: 
*/ 
User Function MONNF011() 
	Local aParam 	:= {}
	
	If ISINCALLSTACK("U_MONNF002") .Or. ISINCALLSTACK("U_MONNF020") //Comunicação com o SEFAZ
		// Empresa/Filial
		aAdd(aParam , { "01" , "01" })
		//aAdd(aParam , { "01" , "04" })
		aAdd(aParam , { "01" , "08" })
		aAdd(aParam , { "01" , "09" })
		//aAdd(aParam , { "01" , "19" })	//Atualização 2019.05.24. Eurai Rapelli - #23218 - Monitor / Cockpit (Removido CNPJ)
	EndIf
	
	If ISINCALLSTACK("U_MONNF004") //Recebimento de E-mail
		// Empresa/Filial
		aAdd(aParam , { "01" , "01" })
		//aAdd(aParam , { "01" , "04" })
		aAdd(aParam , { "01" , "08" })
		aAdd(aParam , { "01" , "09" })
		//aAdd(aParam , { "01" , "19" })	//Atualização 2019.05.24. Eurai Rapelli - #23218 - Monitor / Cockpit (Removido CNPJ)
	EndIf
	
	If ISINCALLSTACK("U_MONNF005") //Leitura do XML e importação para o Banco de Conhecimento do Protheus
		// Empresa/Filial
		aAdd(aParam , { "01" , "01" })
		//aAdd(aParam , { "01" , "04" })
		aAdd(aParam , { "01" , "08" })
		aAdd(aParam , { "01" , "09" })
		//aAdd(aParam , { "01" , "19" })	//Atualização 2019.05.24. Eurai Rapelli - #23218 - Monitor / Cockpit (Removido CNPJ)
	EndIf
	
Return(aParam)